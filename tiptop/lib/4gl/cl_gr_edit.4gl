# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: cl_gr_edit
# Descriptions...: Silverlight for Genero Report樣版編輯作業
# Date & Author..: by tommas  整合Silverlight的LayoutEditor
# Modify.........: No:FUN-C60026 12/06/12 By janet  儲存樣板功能增加、增加cl_gr_savetmp畫面
# Modify.........: No:FUN-C90108 12/09/25 By janet  修改cl_gr_savetmp畫面字義及連動關係
# Modify.........: No:FUN-C90038 12/10/08 By janet  傳入多語言資料，使LE編輯時可切換繁中/英文/簡中界面
# Modify.........: No.FUN-CB0067 12/11/14 by stellar開啟layouteditor前檢查GR報表規範(能檢查多個樣板檔)
# Modify.........: No.FUN-CB0138 12/11/28 by janet  4rp有強制訊息無法開啟layouteditor
# Modify.........: No.FUN-CC0081 12/12/14 by janet  同GR報表，LE未開啟的4rp也要存

IMPORT os
DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_xml         DYNAMIC ARRAY OF STRING #開啟的4rp內容
DEFINE g_xml_tmp     DYNAMIC ARRAY OF STRING #原來的4RP內容
DEFINE g_gdw08       LIKE gdw_file.gdw08 #使用者選擇的主報表
DEFINE g_gdw09_new   LIKE gdw_file.gdw09 #新報表名稱
DEFINE g_zz011       LIKE zz_file.zz011
DEFINE g_gdw01       LIKE gdw_file.gdw01
DEFINE g_gdw02       LIKE gdw_file.gdw02
DEFINE g_gdw03       LIKE gdw_file.gdw03 #客制否
DEFINE g_gdw      DYNAMIC ARRAY OF RECORD
               sel     LIKE type_file.chr1,
               gdw01       LIKE gdw_file.gdw01,  #程式代號
               gdw02       LIKE gdw_file.gdw02,  #樣版代號
               gdw03       LIKE gdw_file.gdw03,  #客制否
               gdw07       LIKE gdw_file.gdw07,    #序號
               gdw08       LIKE gdw_file.gdw08,    #樣版id
               gdw09       LIKE gdw_file.gdw09,    #樣版名稱
               gfs03       LIKE gfs_file.gfs03,    #樣版說明
               gdwdate     LIKE gdw_file.gdwdate,  #最近修改日
               gdwgrup     LIKE gdw_file.gdwgrup,  #資料所有群
               gdwmodu     LIKE gdw_file.gdwmodu,  #資料更改者
               gdworig     LIKE gdw_file.gdworig,  #資料建立部門
               gdwuser     LIKE gdw_file.gdwuser,  #資料所有者
               gdworiu     LIKE gdw_file.gdworiu   #資料建立者
                   END RECORD
DEFINE g_page_size   INTEGER #設定cl_gr_edit.4fd中有幾個Page
DEFINE g_cust_modu_path   STRING
##################################################
# Descriptions...: 使用gdw08抓取相關4rp檔，並開啟LayoutEditor
# Date & Author..: 12/03/07 By tommas
# Input Parameter: p_gdw08
# Return code....: none
##################################################
FUNCTION cl_gr_edit(p_gdw08)
   DEFINE p_gdw08       LIKE gdw_file.gdw08
   DEFINE l_gdw01       LIKE gdw_file.gdw01,#程式代號
           l_gdw02      LIKE gdw_file.gdw02,#樣版代號
           l_gdw03      LIKE gdw_file.gdw03,#客制否
           l_gdw04      LIKE gdw_file.gdw04,#權限類別
           l_gdw05      LIKE gdw_file.gdw05,#使用者
           l_gdw06      LIKE gdw_file.gdw06,#行業別
           l_gdw08_new  STRING,#新的gdw08
           l_gdw09_new  LIKE gdw_file.gdw09,#新的樣版名稱
           l_gdw08      LIKE gdw_file.gdw08,
           l_zz14       LIKE zz_file.zz14,  #報表類型
           l_idx        INTEGER,
           l_i           INTEGER,
           l_tmp        STRING
   DEFINE l_gre_w      ui.Window
   DEFINE l_success  BOOLEAN
   DEFINE l_cmd      STRING
   DEFINE l_sb       base.Stringbuffer
   DEFINE l_result   INTEGER  #回傳總筆數
   DEFINE l_st      base.StringTokenizer
   DEFINE l_doc     om.DomDocument,
           l_node    om.DomNode
   #FUN-C60026 add--start
   DEFINE l_overwrite,l_multi LIKE type_file.chr1 
   DEFINE l_desc     LIKE gfs_file.gfs03 
   DEFINE l_gay01    DYNAMIC ARRAY OF LIKE gay_file.gay01 
   DEFINE l_dsc_tmp,l_dsc_path,l_dsc_path_src  STRING   
   DEFINE l_sql,l_now_str     STRING                    
   DEFINE l_str,l_new_path    STRING                    
   DEFINE  g_gdm_o  DYNAMIC ARRAY OF RECORD   #原本來源的gdm_file   
         gdm02           LIKE gdm_file.gdm04,    # 
         gdm04           LIKE gdm_file.gdm04,    # 欄位代碼
         gdm11           LIKE gdm_file.gdm11,    # 字型
         gdm16           LIKE gdm_file.gdm16,    # 欄位說明字型
         gdm23           LIKE gdm_file.gdm23     # 欄位說明       
         END RECORD 
   DEFINE l_l,i ,l_gfs_cnt         INTEGER 
   DEFINE l_gdw09_old              LIKE gdw_file.gdw09
   #FUN-C60026 add--end 
   DEFINE l_lang_data              STRING   #FUN-C90038 add
   DEFINE l_gdw08_old    DYNAMIC ARRAY OF LIKE gdw_file.gdw08 #FUN-CC0081 add
   DEFINE l_gdw09_oname              LIKE gdw_file.gdw09        #FUN-CC0081 add
     
   CALL g_gdw.clear()
   CALL g_xml.clear()
   LET g_gdw08 = p_gdw08

   SELECT gdw01,gdw02,gdw03,gdw04,gdw05,gdw06 INTO l_gdw01,l_gdw02,l_gdw03,l_gdw04,l_gdw05,l_gdw06           
                        FROM gdw_file WHERE gdw08 = p_gdw08
   SELECT zz14 INTO l_zz14 FROM zz_file WHERE zz01 = l_gdw01
   LET g_gdw01 = l_gdw01
   LET g_gdw02 = l_gdw02
   LET g_gdw03 = l_gdw03
   

   #關閉cl_gre的列印作業視窗
   LET l_gre_w = ui.Window.forName("cl_gre_w")
   IF l_gre_w IS NOT NULL THEN CLOSE WINDOW cl_gre_w END IF
   
   #開啟報表選擇視窗，讓user選擇要開啟哪些報表
   CALL cl_gr_sel_4rp(l_gdw01,l_gdw02,l_gdw03,l_gdw04,l_gdw05,l_gdw06,p_gdw08) #FUN-CC0081 add p_gdw08

   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      RETURN
   END IF

   #指定WebComponent路徑  
   CALL cl_gr_set_wc_path() 
   
   OPEN WINDOW cl_gr_edit_w WITH FORM "lib/42f/cl_gr_edit"
   CALL cl_ui_locale("cl_gr_edit")

   #將多餘的Page隱藏起來，並設定檔案名稱
   CALL cl_gr_edit_set_page() RETURNING g_page_size


   #FUN-C90038 --(S)
   #取得多語言介面內容
   CALL cl_gr_get_multi_lang_xml() RETURNING l_lang_data   
   IF cl_null(l_lang_data) THEN 
       CALL cl_err_msg(NULL,'azz1264',"",10)       
       RETURN 
   END IF
   #FUN-C90038 --(E)
   
   #將讀進來的xml丟給LayoutEditor
   FOR l_idx = 1 TO g_page_size
      IF NOT cl_null(g_xml[l_idx]) THEN
         LET l_tmp = l_idx
         LET l_tmp = "s_wc",l_tmp.trim() #組1~10的web component名稱s_wc1 ~ s_wc10
         CALL cl_set_property_comp(l_tmp, "langdata", l_lang_data)     #多語言界面資料 FUN-C90038 add
         CALL cl_set_property_comp(l_tmp, "reportdata", g_xml[l_idx])  #設定報表內容
         CALL cl_set_property_comp(l_tmp, "action", "set_report_data") #指定給LayoutEditor的資料
         CALL cl_set_property_comp(l_tmp, "lang", g_lang)              #指定語言別
         CALL cl_set_property_comp(l_tmp, "report_type", l_zz14)       #指定模組代碼
      END IF
   END FOR
   
   DIALOG ATTRIBUTE(UNBUFFERED=TRUE)
      INPUT g_xml[1] FROM s_wc1 ATTRIBUTE(WITHOUT DEFAULTS)
      
         BEFORE INPUT
            #隱藏沒有安裝Silverlight時的Action
            CALL dialog.setActionHidden("no_plugin", TRUE)
            CALL dialog.setActionHidden("save_4rp", TRUE)
#            CALL cl_set_comp_visible("save_4rp", FALSE)
#            #CALL dialog.setActionHidden("finished", TRUE)
#            CALL dialog.setActionHidden("save_4rp", TRUE)
#           CALL dialog.setActionHidden("exit", TRUE)
#            CALL cl_set_property_comp("s_wc1", "reportdata", g_xml[1])         #設定報表內容
#            CALL cl_set_property_comp("s_wc1", "action", "set_report_data") #指定給LayoutEditor的資料

#         ON ACTION save_4rp #當LayoutEditor回傳後，直接將內容存檔
#            IF l_success THEN
#               #將回傳的javascript字串中的雙引號\"替換成"
#               LET g_xml = base.StringBuffer.create()
#               CALL g_xml.append(l_wc1)
#               CALL g_xml.replace("\\\"","\"",0)
#               LET l_doc = om.DomDocument.createFromString(g_xml.toString())
#               LET l_node = l_doc.getDocumentElement()
#               CALL l_node.writeXml(g_new_file)
#               EXIT DIALOG
#            END IF   

#         ON ACTION finished
#            LET l_success = cl_gr_edit_save() 
#            IF l_success THEN
#               CALL cl_set_property_comp("s_wc1", "action", "get_report_data")
#            END IF

         #當使用者沒有安裝(版本不符)Silverlight時，會自動開啟微軟的下載位址
         ON ACTION no_plugin
            CALL ui.Interface.frontCall("standard", "launchurl", [g_xml[1]], [])
            
         ON ACTION save_4rp
            IF l_result < g_page_size THEN
               LET l_result = l_result + 1
               LET l_tmp = l_result
               LET l_tmp = "s_wc",l_tmp.trim()
               CALL cl_set_property_comp(l_tmp, "action", "get_report_data")
               NEXT FIELD s_wc2
            ELSE
               EXIT DIALOG
            END IF
      END INPUT
      
      INPUT g_xml[2] FROM s_wc2  ATTRIBUTE(WITHOUT DEFAULTS) 
         BEFORE INPUT
            CALL dialog.setActionHidden("save_4rp", TRUE)
         ON ACTION save_4rp
            IF l_result < g_page_size THEN
               LET l_result = l_result + 1
               LET l_tmp = l_result
               LET l_tmp = "s_wc",l_tmp.trim()
               CALL cl_set_property_comp(l_tmp, "action", "get_report_data")
               NEXT FIELD s_wc3
            ELSE
               EXIT DIALOG
            END IF
      END INPUT
      INPUT g_xml[ 3] FROM s_wc3  ATTRIBUTE(WITHOUT DEFAULTS)   
         BEFORE INPUT
            CALL dialog.setActionHidden("save_4rp", TRUE)
         ON ACTION save_4rp
            IF l_result < g_page_size THEN
               LET l_result = l_result + 1
               LET l_tmp = l_result
               LET l_tmp = "s_wc",l_tmp.trim()
               CALL cl_set_property_comp(l_tmp, "action", "get_report_data")
               NEXT FIELD s_wc4
            ELSE
               EXIT DIALOG
            END IF
      END INPUT
      INPUT g_xml[ 4] FROM s_wc4  ATTRIBUTE(WITHOUT DEFAULTS)  
         BEFORE INPUT
            CALL dialog.setActionHidden("save_4rp", TRUE) 
         ON ACTION save_4rp
            IF l_result < g_page_size THEN
               LET l_result = l_result + 1
               LET l_tmp = l_result
               LET l_tmp = "s_wc",l_tmp.trim()
               CALL cl_set_property_comp(l_tmp, "action", "get_report_data")
               NEXT FIELD s_wc5
            ELSE
               EXIT DIALOG
            END IF
      END INPUT
      INPUT g_xml[ 5] FROM s_wc5  ATTRIBUTE(WITHOUT DEFAULTS)   
         BEFORE INPUT
            CALL dialog.setActionHidden("save_4rp", TRUE)
         ON ACTION save_4rp
            IF l_result < g_page_size THEN
               LET l_result = l_result + 1
               LET l_tmp = l_result
               LET l_tmp = "s_wc",l_tmp.trim()
               CALL cl_set_property_comp(l_tmp, "action", "get_report_data")
               NEXT FIELD s_wc6
            ELSE
               EXIT DIALOG
            END IF
      END INPUT
      INPUT g_xml[ 6] FROM s_wc6  ATTRIBUTE(WITHOUT DEFAULTS)   
         BEFORE INPUT
            CALL dialog.setActionHidden("save_4rp", TRUE)
         ON ACTION save_4rp
            IF l_result < g_page_size THEN
               LET l_result = l_result + 1
               LET l_tmp = l_result
               LET l_tmp = "s_wc",l_tmp.trim()
               CALL cl_set_property_comp(l_tmp, "action", "get_report_data")
               NEXT FIELD s_wc7
            ELSE
               EXIT DIALOG
            END IF
      END INPUT
      INPUT g_xml[7] FROM s_wc7  ATTRIBUTE(WITHOUT DEFAULTS)   
         BEFORE INPUT
            CALL dialog.setActionHidden("save_4rp", TRUE)
         ON ACTION save_4rp
            IF l_result < g_page_size THEN
               LET l_result = l_result + 1
               LET l_tmp = l_result
               LET l_tmp = "s_wc",l_tmp.trim()
               CALL cl_set_property_comp(l_tmp, "action", "get_report_data")
               NEXT FIELD s_wc8
            ELSE
               EXIT DIALOG
            END IF
      END INPUT
      INPUT g_xml[ 8] FROM s_wc8  ATTRIBUTE(WITHOUT DEFAULTS)   
         BEFORE INPUT
            CALL dialog.setActionHidden("save_4rp", TRUE)
         ON ACTION save_4rp
            IF l_result < g_page_size THEN
               LET l_result = l_result + 1
               LET l_tmp = l_result
               LET l_tmp = "s_wc",l_tmp.trim()
               CALL cl_set_property_comp(l_tmp, "action", "get_report_data")
               NEXT FIELD s_wc9
            ELSE
               EXIT DIALOG
            END IF
      END INPUT
      INPUT g_xml[ 9] FROM s_wc9  ATTRIBUTE(WITHOUT DEFAULTS)   
         BEFORE INPUT
            CALL dialog.setActionHidden("save_4rp", TRUE)
         ON ACTION save_4rp
            IF l_result < g_page_size THEN
               LET l_result = l_result + 1
               LET l_tmp = l_result
               LET l_tmp = "s_wc",l_tmp.trim()
               CALL cl_set_property_comp(l_tmp, "action", "get_report_data")
               NEXT FIELD s_wc10
            ELSE
               EXIT DIALOG
            END IF
      END INPUT
      INPUT g_xml[10] FROM s_wc10 ATTRIBUTE(WITHOUT DEFAULTS)   
         BEFORE INPUT
            CALL dialog.setActionHidden("save_4rp", TRUE)
         ON ACTION save_4rp
            EXIT DIALOG
            
      END INPUT
      
      ON ACTION save_all
         #這裡要先請使用者輸入新的報表名稱
         CALL cl_gr_edit_save() RETURNING l_success,l_overwrite,l_multi,l_desc         
         IF NOT l_success THEN
            #FUN-C90108 mark -(s)
            #IF NOT cl_confirm("lib-623") THEN
               #CONTINUE DIALOG  #不離開
            #ELSE
               LET INT_FLAG =FALSE    #FUN-C90108 add
               CONTINUE DIALOG
               #EXIT DIALOG      #離開且不儲存
            #END IF
            #FUN-C90108 mark -(e)
         ELSE
            #確認儲存，取回LayoutEditor的內容
            LET l_result = 1
            CALL cl_set_property_comp("s_wc1", "action", "get_report_data")
            NEXT FIELD s_wc1
         END IF  

      ON ACTION CLOSE
         LET l_success = FALSE
         IF NOT cl_confirm("lib-623") THEN
            CONTINUE DIALOG  #不離開
         ELSE
            LET INT_FLAG = TRUE
            EXIT DIALOG      #離開且不儲存
         END IF
         
      ON ACTION EXIT 
         LET l_success = FALSE
         IF NOT cl_confirm("lib-623") THEN
            CONTINUE DIALOG  #不離開
         ELSE
            LET INT_FLAG = TRUE
            EXIT DIALOG      #離開且不儲存
         END IF
         
   END DIALOG
   
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      CLOSE WINDOW cl_gr_edit_w
      RETURN
   END IF
   LET l_idx = 1

   LET l_sb = base.StringBuffer.create()
   IF l_success THEN
      #回傳多個新的gdw08，每個gdw08以|區隔
      #CALL s_gr_gdwcopy_gdw08(g_gdw09_new, g_gdw08, "N") RETURNING l_gdw08_new #FUN-CC0081 mark
      #FUN-CC0081 add--(s)
      LET l_gdw09_oname=g_gdw[1].gdw09
      FOR l_i=1 TO g_gdw.getLength() 
         IF g_gdw[l_i].gdw09 IS NOT NULL THEN 
             CALL l_sb.clear()
             CALL l_sb.append(g_gdw[l_i].gdw09)        
             CALL l_sb.replace(l_gdw09_oname, g_gdw09_new, 0)  
             LET g_gdw[l_i].gdw09 = l_sb.toString()            
             CALL s_gr_gdwcopy_gdw08(g_gdw[l_i].gdw09, g_gdw[l_i].gdw08, "N") RETURNING l_gdw08_new
             IF g_gdw[1].gdw01 !=l_gdw08_new THEN  #如果回傳的gdw08是一樣的，表示資料已存在
                LET l_gdw08_old[l_i]=g_gdw[l_i].gdw08  #存舊的gdw08 
                IF cl_null(l_gdw08_new) THEN
                   LET l_gdw08_new=g_gdw[l_i].gdw08 
                END IF 
                #如果回傳空值，表示找不到資料...拿原來的去rescan4rp
                LET g_gdw[l_i].gdw08 = l_gdw08_new
             END IF 
         END IF 
      END FOR 
      #FUN-CC0081 add --(e)
      #FUN-CC0081 mark --(s)   
      #IF g_gdw[1].gdw01 != l_gdw08_new THEN  #如果回傳的gdw08是一樣的，表示資料已存在
         #LET l_st = base.StringTokenizer.create(l_gdw08_new, "|")
         #WHILE l_st.hasMoreTokens()
            #LET l_gdw08 = l_st.nextToken()
            #LET l_gdw08_old[l_idx]=g_gdw[l_idx].gdw08  #FUN-CC0081 add #存舊的gdw08
            #IF cl_null(l_gdw08) THEN 
               #LET l_gdw08 = g_gdw[l_idx].gdw08 
            #END IF  
            #如果回傳空值，表示找不到資料...拿原來的去rescan4rp
            #LET g_gdw[l_idx].gdw08 = l_gdw08
            #LET l_idx = l_idx + 1
         #END WHILE
      #END IF
      #FUN-CC0081 mark --(e)
   END IF

   ##FUN-C60026 mark--start--原版
   ##將新的4rp內容，寫回客制區內
   #LET l_i = 1
   #LET l_tmp = gr_edit_get_4rp_dir(gr_edit_get_cust(g_zz011))
#
   #FOR l_idx = 1 TO g_gdw.getLength()
      #IF cl_null(g_gdw[l_idx].gdw01) THEN EXIT FOR END IF
      #
      #IF g_gdw[l_idx].sel =="Y" THEN
         ##將舊的樣版名稱，換成使用者輸入的樣版名稱
         #CALL l_sb.clear()
         ##CALL l_sb.append(g_gdw[l_idx].gdw09)       #未確定 tommas 12/06/06
         ##CALL l_sb.replace(g_gdw02, g_gdw09_new, 0)#未確定 tommas 12/06/06
         ##LET g_gdw[l_idx].gdw09 = l_sb.toString()#未確定 tommas 12/06/06
         #LET g_gdw[l_idx].gdw09 = g_gdw09_new
    #
         #LET l_gdw09_new = l_tmp,g_gdw[l_idx].gdw09,".4rp"  #組新的完整4rp路徑
#
         #CALL l_sb.clear()
         #CALL l_sb.append(g_xml[l_i]) #從LE接收XML字串
         #CALL l_sb.replace("\\\"","\"",0)  #過濾掉LayoutEditor回傳內容中的\"
         #LET l_doc = om.DomDocument.createFromString(l_sb.toString())
         #LET l_node = l_doc.getDocumentElement()
         #CALL l_node.writeXml(l_gdw09_new) #將4rp內容寫回去
         #LET l_cmd = "p_rescan4rp \"", l_gdw09_new, "\" ", g_gdw[l_idx].gdw08, " ", g_lang #rescan 4rp         
         #CALL cl_cmdrun(l_cmd)
         #LET l_i = l_i + 1
#
      #END IF
    #END FOR
   ##FUN-C60026 mark--end-- 原版

   ##FUN-C60026 add--start--改版
   #將新的4rp內容，寫回客制區內
   LET l_i = 1
   LET l_tmp = gr_edit_get_4rp_dir(gr_edit_get_cust(g_zz011))

   FOR l_idx = 1 TO g_gdw.getLength()
      IF cl_null(g_gdw[l_idx].gdw01) THEN EXIT FOR END IF

      ##IF g_gdw[l_idx].sel =="Y" THEN  #FUN-CC0081 mark
         #將舊的樣版名稱，換成使用者輸入的樣版名稱
         #CALL l_sb.clear()
         #CALL l_sb.append(g_gdw[l_idx].gdw09)        #未確定 tommas 12/06/06 
         #CALL l_sb.replace(g_gdw02, g_gdw09_new, 0)  #未確定 tommas 12/06/06
         #LET g_gdw[l_idx].gdw09 = l_sb.toString()    #未確定 tommas 12/06/06      
         #LET g_gdw[l_idx].gdw09 = g_gdw09_new   #FUN-CC0081 mark
   
         LET l_gdw09_new = l_tmp,g_gdw[l_idx].gdw09,".4rp"  #組新的完整4rp路徑
         
         LET l_now_str = CURRENT
         LET l_now_str = cl_replace_str(l_now_str, "-", "")
         LET l_now_str = cl_replace_str(l_now_str, " ", "")
         LET l_now_str = cl_replace_str(l_now_str, ":", "")
         LET l_now_str = cl_replace_str(l_now_str, ".", "")
         LET l_str = g_prog CLIPPED, "_", g_user CLIPPED, "_", l_now_str CLIPPED, ".4rp"
         LET l_new_path = os.Path.join( FGL_GETENV("TEMPDIR"), l_str)         
         #當使用者確認新檔案調整後無誤時，將舊檔備份，並使用新檔將舊檔覆蓋，再重新rescan
         IF os.Path.exists(l_gdw09_new) THEN
            IF l_overwrite="Y" AND l_gdw05=g_user THEN 
                #將舊檔備份
                CALL os.Path.copy(l_gdw09_new, l_gdw09_new || "." || l_now_str) RETURNING l_result
                #刪除舊檔
                CALL os.Path.delete(l_gdw09_new) RETURNING l_result
                #暫存檔copy到舊檔
              
                #CALL os.Path.copy(l_new_path, l_gdw09_new) RETURNING l_result
                #刪除暫存檔
                #CALL os.Path.delete(l_new_path) RETURNING l_result
                 CALL l_sb.clear()
                 #CALL l_sb.append(g_xml[l_i]) #從LE接收XML字串  #FUN-CC0081 mark
                 CALL l_sb.append(g_xml[l_idx]) #從LE接收XML字串   #FUN-CC0081 add
                 CALL l_sb.replace("\\\"","\"",0)  #過濾掉LayoutEditor回傳內容中的\"  
                 #FUN-C60026 add--start  #置換樣板名稱
                # SELECT gdw09 INTO l_gdw09_old FROM gdw_file WHERE gdw08 =g_gdw08  #FUN-CC0081 mark
                 SELECT gdw09 INTO l_gdw09_old FROM gdw_file WHERE gdw08 =l_gdw08_old[l_idx]  #FUN-CC0081 add 121217
                 CALL l_sb.replace(l_gdw09_old,g_gdw[l_idx].gdw09,0)  #過濾掉LayoutEditor回傳內容中的\" 
                 #FUN-C60026 add--end
                 LET l_doc = om.DomDocument.createFromString(l_sb.toString())
                 LET l_node = l_doc.getDocumentElement()
                 CALL l_node.writeXml(l_gdw09_new) #將4rp內容寫回去
                 LET l_cmd = "p_rescan4rp \"", l_gdw09_new, "\" ", g_gdw[l_idx].gdw08, " ", g_lang #rescan 4rp  
                 CALL cl_cmdrun(l_cmd)
                 LET l_i = l_i + 1 
            END IF 
         ELSE
                #CALL os.Path.copy(l_new_path, l_gdw09_new) RETURNING l_result
                 CALL l_sb.clear()
                 #CALL l_sb.append(g_xml[l_i]) #從LE接收XML字串  #FUN-CC0081 mark
                 CALL l_sb.append(g_xml[l_idx]) #從LE接收XML字串   #FUN-CC0081 add
                 CALL l_sb.replace("\\\"","\"",0)  #過濾掉LayoutEditor回傳內容中的\"
                 #FUN-C60026 add--start #置換樣板名稱
                 #SELECT gdw09 INTO l_gdw09_old FROM gdw_file WHERE gdw08 =g_gdw08   #FUN-CC0081 mark 
                 SELECT gdw09 INTO l_gdw09_old FROM gdw_file WHERE gdw08 =l_gdw08_old[l_idx]  #FUN-CC0081 add 121217
                 CALL l_sb.replace(l_gdw09_old,g_gdw[l_idx].gdw09,0)  #過濾掉LayoutEditor回傳內容中的\" 
                 #FUN-C60026 add--end                 
                 LET l_doc = om.DomDocument.createFromString(l_sb.toString())
                 LET l_node = l_doc.getDocumentElement()             
                 CALL l_node.writeXml(l_gdw09_new) #將4rp內容寫回去
                 LET l_cmd = "p_rescan4rp \"", l_gdw09_new, "\" ", g_gdw[l_idx].gdw08, " ", g_lang #rescan 4rp     
                 CALL cl_cmdrun(l_cmd)
                 LET l_i = l_i + 1                    
            
         END IF
 

         #insert gfs_file #樣板說明
         #BEGIN WORK 
         SELECT count(*) INTO l_gfs_cnt FROM gfs_file WHERE gfs01=g_gdw[l_idx].gdw08 AND gfs02=g_lang
         IF l_gfs_cnt=0 OR l_gfs_cnt IS NULL THEN 
             INSERT INTO gfs_file (gfs01,gfs02,gfs03)
                    VALUES (g_gdw[l_idx].gdw08,g_lang,l_desc ) 
         ELSE 
             IF l_overwrite="Y" THEN #要覆蓋
               UPDATE  gfs_file 
                     SET gfs03=l_desc
                     WHERE gfs01=g_gdw[l_idx].gdw08 AND gfs02=g_lang
             END IF 
         END IF 
        
         #COMMIT WORK 
         ##複製至src
         LET l_dsc_tmp=l_tmp.subString(1,l_tmp.getLength()-3)     
         LET l_dsc_path_src=l_dsc_tmp,"/src/",g_gdw[l_idx].gdw09,".4rp" 
         IF os.Path.exists(l_dsc_path_src) THEN 
             IF l_overwrite="Y" THEN
                #將舊檔備份
                CALL os.Path.copy(l_dsc_path_src, l_dsc_path_src || "." || l_now_str) RETURNING l_result
                #刪除舊檔
                CALL os.Path.delete(l_dsc_path_src) RETURNING l_result     
                IF  os.Path.copy(l_gdw09_new,l_dsc_path_src) THEN END IF            
             END IF 
         ELSE
             IF  os.Path.copy(l_gdw09_new,l_dsc_path_src) THEN END IF  
         END IF 
         
         ##多語系, 將修改後的4rp複製至各語系下
         IF l_multi="Y" THEN 
             CALL cl_gr_get_gay01() RETURNING l_gay01
            
             FOR l_i= 1 TO l_gay01.getLength()
                
                IF l_gay01[l_i]<> g_lang THEN #不同語系

                     LET l_dsc_path=""
                     LET l_dsc_path=l_dsc_tmp,"/",l_gay01[l_i],"/",g_gdw[l_idx].gdw09,".4rp"
                     IF os.Path.exists(l_dsc_path) THEN 
                        IF l_overwrite="Y" THEN  #要覆蓋原檔
                             #將舊檔備份
                             CALL os.Path.copy(l_dsc_path, l_dsc_path || "." || l_now_str) RETURNING l_result
                             #刪除舊檔
                             CALL os.Path.delete(l_dsc_path) RETURNING l_result                             
                             #複製
                             IF os.Path.copy(l_gdw09_new,l_dsc_path) THEN END IF
                             #各語系重掃至gdm_file
                             LET l_cmd = "p_rescan4rp \"", l_dsc_path, "\" ", g_gdw[l_idx].gdw08, " ", l_gay01[l_i] #rescan 4rp #                          
                             CALL cl_cmdrun_wait(l_cmd)                        
                             #將來源的gdm_file複製原本語系的gdm11,gdm16,gdm23       
                             LET l_sql="SELECT gdm02,gdm04,gdm11,gdm16,gdm23 FROM gdm_file",
                                       " WHERE gdm01=? and gdm03=? ORDER BY gdm02"
                             DECLARE cl_gr_curs1 CURSOR FROM l_sql
                             OPEN cl_gr_curs1 USING l_gdw08_old[l_idx],l_gay01[l_i]
                             CALL g_gdm_o.clear() 
                             
                             LET i = 1
                             FOREACH cl_gr_curs1 INTO g_gdm_o[i].*                  
                                IF SQLCA.SQLCODE THEN
                                   EXIT FOREACH
                                END IF
                                LET i = i + 1
                             END FOREACH   
                             CALL g_gdm_o.deleteElement(i) 
                             #更新各語系的gdm11、gdm16、gdm23至gdm_file
                             BEGIN WORK 
                             FOR l_l=1 TO g_gdm_o.getLength()
                                 UPDATE  gdm_file 
                                      SET gdm11=g_gdm_o[l_l].gdm11,
                                          gdm16=g_gdm_o[l_l].gdm16,
                                          gdm23=g_gdm_o[l_l].gdm23
                                      WHERE gdm01 = g_gdw[l_idx].gdw08 AND 
                                            gdm02 = g_gdm_o[l_l].gdm02 AND
                                            gdm03 = l_gay01[l_i]

                                 IF SQLCA.sqlcode THEN
                                    DISPLAY SQLCA.sqlcode
                                 END  IF
                             END FOR 
                             IF sqlca.sqlcode THEN
                               ROLLBACK WORK  
                             ELSE 
                               COMMIT WORK
                               DISPLAY "1 COMMIT WORK"
                             END IF   
                        END IF #l_overwrite="Y"
                     ELSE                          
                         IF os.Path.copy(l_gdw09_new,l_dsc_path) THEN END IF
                         #各語系重掃至gdm_file                         
                         LET l_cmd = "p_rescan4rp \"", l_dsc_path, "\" ", g_gdw[l_idx].gdw08, " ", l_gay01[l_i] #rescan 4rp                           
                         CALL cl_cmdrun_wait(l_cmd) 
                         
                         #將來源的gdm_file複製原本語系的gdm11,gdm16,gdm23       
                         LET l_sql="SELECT gdm02,gdm04,gdm11,gdm16,gdm23 FROM gdm_file",
                                   " WHERE gdm01=? and gdm03=? ORDER BY gdm02"
                         DECLARE cl_gr_curs2 CURSOR FROM l_sql
                         OPEN cl_gr_curs2 USING l_gdw08_old[l_idx],l_gay01[l_i]
                         CALL g_gdm_o.clear() 
                         
                         LET i = 1
                         FOREACH cl_gr_curs2 INTO g_gdm_o[i].*                  
                            IF SQLCA.SQLCODE THEN
                               EXIT FOREACH
                            END IF
                            LET i = i + 1
                         END FOREACH   
                         CALL g_gdm_o.deleteElement(i) 
                         #更新各語系的gdm11、gdm16、gdm23至gdm_file
                         BEGIN WORK  
                         FOR l_l=1 TO g_gdm_o.getLength()
                             UPDATE gdm_file 
                                  SET gdm11=g_gdm_o[l_l].gdm11 ,
                                      gdm16=g_gdm_o[l_l].gdm16 ,
                                      gdm23=g_gdm_o[l_l].gdm23 
                                  WHERE gdm01 = g_gdw[l_idx].gdw08 AND 
                                        gdm02 = g_gdm_o[l_l].gdm02 AND
                                        gdm03 = l_gay01[l_i]
                             #LET l_sql="UPDATE gdm_file SET gdm11='",g_gdm_o[l_l].gdm11,"'",
                                                            #",gdm16='",g_gdm_o[l_l].gdm16,"'",
                                                            #",gdm23='",g_gdm_o[l_l].gdm23,"'",
                                                      #" where gdm01='",g_gdw[l_idx].gdw08,"'",
                                                      #" and  gdm02 ='", g_gdm_o[l_l].gdm02,"'",
                                                      #" and  gdm03 ='", l_gay01[l_i],"'"
                              #PREPARE cl_gr_pre1 FROM l_sql
                              #EXECUTE cl_gr_pre1 
                             IF SQLCA.sqlcode THEN
                                DISPLAY SQLCA.sqlcode
                             END  IF

                         END FOR 
                         IF sqlca.sqlcode THEN
                           ROLLBACK WORK  
                         ELSE 
                           COMMIT WORK
                           #DISPLAY "2 COMMIT WORK"  #FUN-CC0081 mark
                         END IF                          
                     END IF 
                   
                END IF  #IF l_gay01[l_i]<> g_lang                  
             END FOR 
 
         END IF #l_multi="Y" THEN


      #END IF  #FUN-CC0081 mark
    END FOR
    
   ##FUN-C60026 add--start--改版
   CLOSE WINDOW cl_gr_edit_w
   
   CALL g_xml.clear()
   CALL g_xml_tmp.clear()
   CALL g_gdw.clear()
END FUNCTION





FUNCTION cl_gr_edit_set_page()
   DEFINE l_idx    INTEGER
   DEFINE l_page   DYNAMIC ARRAY OF om.DomNode
   DEFINE l_win    ui.Window
   DEFINE l_form   ui.Form
   DEFINE l_tmp    STRING
   DEFINE l_i      INTEGER
   
   LET l_win = ui.Window.getCurrent()
   LET l_form = l_win.getForm()


   LET l_i = 0
   FOR l_idx = 1 TO 10
      LET l_tmp = l_idx
      LET l_tmp = "page", l_tmp.trim()
      LET l_page[l_idx] = l_form.findNode("Page",l_tmp)
      CALL l_page[l_idx].setAttribute("hidden","1")
      #IF NOT cl_null(g_xml[l_idx]) THEN CALL l_page[l_idx].setAttribute("hidden", "0") END IF #FUN-CC0081 mark
      IF g_gdw[l_idx].sel == "Y" THEN CALL l_page[l_idx].setAttribute("hidden", "0") END IF  #FUN-CC0081  add
      IF l_idx <= g_gdw.getLength() AND g_gdw[l_idx].sel == "Y" THEN
         IF l_page[l_idx] IS NOT NULL THEN
            LET l_i = l_i + 1
            CALL l_page[l_i].setAttribute("text", g_gdw[l_idx].gdw09)  #設定Page名稱
         END IF
      END IF
   END FOR

   RETURN l_i
END FUNCTION

FUNCTION cl_gr_sel_4rp(p_gdw01,p_gdw02,p_gdw03,p_gdw04,p_gdw05,p_gdw06,p_gdw08)  #FUN-CC0081 add p_gdw08
   DEFINE p_gdw01    LIKE gdw_file.gdw01,#程式代號
           p_gdw02    LIKE gdw_file.gdw02,#樣版代號
           p_gdw03    LIKE gdw_file.gdw03,#客制否
           p_gdw04    LIKE gdw_file.gdw04,#權限類別
           p_gdw05    LIKE gdw_file.gdw05,#使用者
           p_gdw06    LIKE gdw_file.gdw06, #行業別
           p_gdw08    LIKE gdw_file.gdw08   #FUN-CC0081 add
   DEFINE l_idx      INTEGER,
           l_sql      STRING,
           l_len      INTEGER,
           l_gdw09_temp STRING, #FUN-CC0081 add
           l_gdw09_master STRING  #FUN-CC0081 add
           
   #FUN-CC0081 mark-(s)
   #LET l_sql = "SELECT 'N', gdw01,gdw02,gdw03,gdw07,gdw08,gdw09,gfs03,gdwdate,gdwgrup, gdwmodu,gdworig,gdwuser,gdworiu ",
                         #"FROM gdw_file ",
                         #"LEFT JOIN gfs_file ON gfs01 = gdw08 AND gfs02 = ? ",
                         #"WHERE gdw01=? AND gdw02=? AND gdw03=? ",
                                       #" AND gdw04=? AND gdw05=? ", 
                                       #" AND gdw06=? ",
                                       #" ORDER BY gdw07 "   
   #PREPARE cl_gr_4rp_p1 FROM l_sql
   #DECLARE cl_gr_4rp_d1 CURSOR FOR cl_gr_4rp_p1
   #LET l_idx = 1
   #FOREACH cl_gr_4rp_d1 USING g_lang,p_gdw01,p_gdw02,p_gdw03,p_gdw04,p_gdw05,p_gdw06
                            #INTO g_gdw[l_idx].* 
      #LET l_idx = l_idx + 1
   #END FOREACH
   #FUN-CC0081 mark -(e)

   #FUN-CC0081 add--(s)
   #先抓主報表
   LET l_sql = "SELECT 'N', gdw01,gdw02,gdw03,gdw07,gdw08,gdw09,gfs03,gdwdate,gdwgrup, gdwmodu,gdworig,gdwuser,gdworiu ",
                         "FROM gdw_file ",
                         "LEFT JOIN gfs_file ON gfs01 = gdw08 AND gfs02 = ? ",
                         "WHERE gdw08=? "
   PREPARE cl_gr_4rp_p1 FROM l_sql
   DECLARE cl_gr_4rp_d1 CURSOR FOR cl_gr_4rp_p1
   LET l_idx = 1
   FOREACH cl_gr_4rp_d1 USING g_lang,p_gdw08
                            INTO g_gdw[l_idx].* 
      LET l_idx = l_idx + 1
   END FOREACH
   LET l_gdw09_master=g_gdw[1].gdw09
   #先抓子報表
   LET l_sql=""
   LET l_sql = "SELECT 'N', gdw01,gdw02,gdw03,gdw07,gdw08,gdw09,gfs03,gdwdate,gdwgrup, gdwmodu,gdworig,gdwuser,gdworiu ",
                         "FROM gdw_file ",
                         "LEFT JOIN gfs_file ON gfs01 = gdw08 AND gfs02 = ? ",
                         "WHERE gdw01=? AND gdw02=? AND gdw03=? ",
                                       " AND gdw04=? AND gdw05=? ", 
                                       " AND gdw06=? ",                                      
                                       " ORDER BY gdw07 "

   PREPARE cl_gr_4rp_p2 FROM l_sql
   DECLARE cl_gr_4rp_d2 CURSOR FOR cl_gr_4rp_p2
   
   FOREACH cl_gr_4rp_d2 USING g_lang,p_gdw01,p_gdw02,p_gdw03,p_gdw04,p_gdw05,p_gdw06
                            INTO g_gdw[l_idx].* 
      LET l_gdw09_temp=g_gdw[l_idx].gdw09
      IF l_gdw09_temp.getIndexOf(l_gdw09_master,1)> 0 AND l_gdw09_temp <> l_gdw09_master  THEN 
         LET l_idx = l_idx + 1
      ELSE
         CALL g_gdw.deleteElement(l_idx)         
      END IF 
      
   END FOREACH
   #FUN-CC0081 add--(s) 
   
   CALL g_gdw.deleteElement(l_idx)

   #如果只有一筆，直接回傳第一筆,否則開啟報表選擇視窗

   IF g_gdw.getLength() > 1 THEN
      OPEN WINDOW cl_gr_edit_sel4rp  WITH FORM "lib/42f/cl_gr_edit_sel4rp"
      CALL cl_ui_locale("cl_gr_edit_sel4rp")
      
      INPUT ARRAY g_gdw WITHOUT DEFAULTS FROM s_gdw.* ATTRIBUTE(UNBUFFERED=TRUE,APPEND ROW=FALSE,INSERT ROW=FALSE,
                                                                       DELETE ROW=FALSE,AUTO APPEND=FALSE,ACCEPT=FALSE)

         #FUN-CC0081 add -(s)
         BEFORE INPUT 
              LET g_gdw[1].sel = "Y"
         #FUN-CC0081 add -(e)      
         ON ACTION edit_4rp
            LET l_len = 0
            FOR l_idx = 1 TO g_gdw.getLength()
               IF g_gdw[l_idx].sel == "Y" THEN
                  LET l_len = l_len + 1
               END IF
            END FOR
            IF l_len == 0 THEN 
               ERROR "請選擇報表檔!"
               CONTINUE INPUT
            ELSE
               EXIT INPUT
            END IF
      END INPUT
      CLOSE WINDOW cl_gr_edit_sel4rp
   ELSE
      LET l_len = 1
      LET g_gdw[1].sel = "Y"
   END IF

   IF l_len > 0 THEN
      IF cl_gr_read_4rp(g_gdw08) IS NULL THEN
         LET INT_FLAG = TRUE
         RETURN
      END IF
   END IF

END FUNCTION

#儲存步驟：
#  1.開窗詢問存檔名稱
#  2.檢查p_grw檔名及實體檔案是否已存在，並且屬於該使用者的
#  3.必須將4rp儲存到客制區(客制模組名稱是否真符合客制區命名規則???)
#  4.詢問是否覆蓋
FUNCTION cl_gr_edit_save()
   DEFINE l_new_file  STRING
   DEFINE l_success   BOOLEAN
   DEFINE l_doc       om.DomDocument
   DEFINE l_node      om.domNode
   DEFINE l_sb        base.StringBuffer        
   DEFINE l_msg       STRING  
   ##FUN-C60026 -add-start 
   DEFINE s_save   RECORD
          s_name      LIKE gdw_file.gdw09,
          s_desc      LIKE gfs_file.gfs03,
          s_multi     LIKE type_file.chr1,
          s_overwrite LIKE type_file.chr1
          END RECORD 
   DEFINE l_gdw09_str     STRING 
   DEFINE l_gdw09     LIKE gdw_file.gdw09
   DEFINE l_gdw08     LIKE gdw_file.gdw08
   DEFINE l_gdw05     LIKE gdw_file.gdw05
   DEFINE l_gay01    DYNAMIC ARRAY OF STRING 
   DEFINE l_i        INTEGER 
   DEFINE l_4rp_seq  INTEGER     
   ##FUN-C60026 add-end
   DEFINE l_gdw09_o     LIKE gdw_file.gdw09  #FUN-C90108 選擇的原始樣板名稱
   DEFINE l_gfs03_o     LIKE gfs_file.gfs03  #FUN-C90108 選擇的原始樣板說明
   DEFINE l_gdw09_name  STRING               #FUN-C90108 最終要存樣板名稱
   
   #FUN-C60026 mark-start
   #LET l_msg = cl_getmsg("lib-624", g_lang)
   #WHILE TRUE
      #PROMPT l_msg FOR l_new_file
      #IF NOT cl_null(l_new_file) THEN
         #IF l_new_file.toLowerCase() MATCHES "*.4rp" THEN  #去掉.4rp的副檔名
            #LET l_new_file = l_new_file.subString(1, l_new_file.getLength() -4)
         #END IF
         #LET l_success = cl_gr_edit_check_exist(l_new_file)
         #IF l_success THEN
            #LET g_gdw09_new = l_new_file
            #EXIT WHILE
         #END IF
      #ELSE 
         #LET l_success = FALSE
         #EXIT WHILE
      #END IF
   #END WHILE
   #RETURN l_success
   #FUN-C60026 mark-end

   ##FUN-C60026 add-start

   WHILE TRUE
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP,
           FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-73001
       DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
       OPEN WINDOW cl_gr_savetmp_w WITH FORM "lib/42f/cl_gr_savetmp"
       #CALL cl_ui_init()                     #FUN-C90108 mark
       CALL cl_ui_locale("cl_gr_savetmp")
       
       INPUT s_save.* WITHOUT DEFAULTS FROM s_save.*
       
            BEFORE INPUT 
                DISPLAY s_save.s_desc
                SELECT max(gdw08) INTO l_gdw08 FROM gdw_file 
                       WHERE gdw01=g_gdw01 AND gdw05=g_user AND gdw09 NOT LIKE '%_sub%'   
                SELECT gdw05,gdw09 INTO l_gdw05,l_gdw09 FROM gdw_file
                       WHERE gdw08=l_gdw08
                #FUN-C90108 add--(s)
                #抓選擇的原始報表名稱
                SELECT gdw09 INTO l_gdw09_o FROM gdw_file WHERE gdw08=g_gdw08 
                SELECT gfs03 INTO l_gfs03_o FROM gfs_file WHERE gfs01=g_gdw08 AND gfs02 =g_lang
                #FUN-C90108 add--(e)
                
                       
                LET l_gdw09_str=l_gdw09 CLIPPED  
                WHILE l_gdw09_str.getIndexOf("_",1)>1
                     LET l_gdw09_str=l_gdw09_str.subString(l_gdw09_str.getIndexOf("_",1)+1,l_gdw09_str.getLength())
                END WHILE 
                #LET l_i=l_gdw09_str.getLength()-1
                
                LET l_4rp_seq=l_gdw09_str
                IF l_4rp_seq IS NULL OR l_4rp_seq=0 THEN 
                   LET l_4rp_seq=1
                ELSE 
                   LET l_4rp_seq=l_4rp_seq+1
                END IF 
                LET l_new_file=g_gdw01,"_",g_user,"_",l_4rp_seq USING "&&"
                #LET s_save.s_name=l_new_file #FUN-C90108 mark
                LET l_gdw09_name=l_new_file   #FUN-C90108 add
                LET s_save.s_name=l_gdw09_name  #FUN-C90108 add                
                DISPLAY s_save.s_name TO s_name                
                LET s_save.s_multi="Y"
                DISPLAY s_save.s_multi TO s_multi
                LET s_save.s_overwrite="N"
                DISPLAY s_save.s_overwrite TO s_overwrite
                
                IF g_user ="tiptop" OR g_user=l_gdw05  THEN #若user=tiptop或user=l_gdw05
                   CALL cl_set_comp_visible("s_overwrite",TRUE) 
                ELSE 
                   CALL cl_set_comp_visible("s_overwrite",FALSE)                    
                END IF 
                #FUN-C90108 add - (s)
                 IF g_user="tiptop" OR g_user=l_gdw05 THEN
                    CALL cl_set_comp_entry("s_name",TRUE) #能修改
                    CALL cl_set_comp_entry("s_desc",TRUE) #能修改
                 ELSE 
                    CALL cl_set_comp_entry("s_name",FALSE) #不能修改
                    CALL cl_set_comp_entry("s_desc",FALSE) #不能修改
                 END IF                 
                #FUN-C90108 add - (e)
            ON CHANGE s_overwrite
                LET s_save.s_overwrite=s_save.s_overwrite  
                IF s_save.s_overwrite="Y" THEN
                   #FUN-C90108 mark -(s)
                   #IF g_user="tiptop" OR g_user=l_gdw05 THEN
                      #CALL cl_set_comp_entry("s_name",TRUE) #能修改
                   #ELSE 
                   #FUN-C90108 mark -(e)                      
                      LET l_gdw09_name=l_gdw09_o                #舊檔樣板名稱
                      LET s_save.s_name=l_gdw09_name
                      DISPLAY s_save.s_name TO s_name
                      LET s_save.s_desc=l_gfs03_o               #舊檔樣板說明  
                      DISPLAY s_save.s_desc TO s_desc
                      CALL cl_set_comp_entry("s_name",FALSE) #不能修改
                      CALL cl_set_comp_entry("s_desc",FALSE) #FUN-C90108 add
                   #END IF #FUN-C90108 mark
                #FUN-C90108 add -(s)
                ELSE 
                   #FUN-C90108 add -(s)   
                   LET l_gdw09_name=l_new_file               #新檔名
                   LET s_save.s_name=l_gdw09_name
                   DISPLAY s_save.s_name TO s_name
                   DISPLAY "" TO s_desc
                   #FUN-C90108 add -(e)    
                   IF g_user="tiptop" OR g_user=l_gdw05 THEN
                      CALL cl_set_comp_entry("s_name",TRUE) #能修改
                      CALL cl_set_comp_entry("s_desc",TRUE)
                   ELSE 
                      CALL cl_set_comp_entry("s_name",FALSE) #不能修改
                      CALL cl_set_comp_entry("s_desc",FALSE)
                   END IF                
                #FUN-C90108 add -(e)
                END IF 
                
            ON CHANGE s_name 
                
                   LET s_save.s_name=s_save.s_name
                   #LET l_new_file=s_save.s_name  #FUN-C90108 mark
                   LET l_gdw09_name=s_save.s_name   #FUN-C90108 add 
            AFTER FIELD  s_name 
                
                   LET s_save.s_name=s_save.s_name
                   #LET l_new_file=s_save.s_name    #FUN-C90108 mark
                   LET l_gdw09_name=s_save.s_name   #FUN-C90108 add
            #FUN-C90108 add -(s)
            ON CHANGE s_desc 
                   LET s_save.s_desc=s_save.s_desc
                   
            AFTER FIELD  s_desc 
                   LET s_save.s_desc=s_save.s_desc                
            #FUN-C90108 add -(e)
       END INPUT 
       
     
       IF INT_FLAG THEN
           #LET INT_FLAG = FALSE               #FUN-C90108 mark
           CLOSE WINDOW cl_gr_savetmp_w         
           RETURN FALSE ,NULL ,NULL ,NULL      #FUN-C90108 add
       END IF
       
       CLOSE WINDOW cl_gr_savetmp_w   


      #FUN-C90108 mark-(s)
      #IF NOT cl_null(l_new_file) THEN
         #IF l_new_file.toLowerCase() MATCHES "*.4rp" THEN  #去掉.4rp的副檔名
            #LET l_new_file = l_new_file.subString(1, l_new_file.getLength() -4)
         #END IF
         #LET l_success = cl_gr_edit_check_exist(l_new_file)
         #IF l_success THEN
            #LET g_gdw09_new = l_new_file
            #EXIT WHILE
         #END IF
      #FUN-C90108 mark-(e)
      #FUN-C90108 add -(s)
      IF NOT cl_null(l_gdw09_name) THEN
          IF l_gdw09_name.toLowerCase() MATCHES "*.4rp" THEN  #去掉.4rp的副檔名
             LET l_gdw09_name = l_gdw09_name.subString(1, l_gdw09_name.getLength() -4)
          END IF
          LET l_success = cl_gr_edit_check_exist(l_gdw09_name)
          IF l_success THEN
             LET g_gdw09_new = l_gdw09_name
             EXIT WHILE
          END IF
      #FUN-C90108 add -(e)
      ELSE 
         LET l_success = FALSE
         EXIT WHILE
      END IF
   END WHILE

   RETURN l_success,s_save.s_overwrite,s_save.s_multi,s_save.s_desc
   

   ##FUN-C60026 add-end

END FUNCTION


#FUN-C60026 add-start
#抓系統有設的語系
FUNCTION cl_gr_get_gay01()
   
   DEFINE l_gay01    DYNAMIC ARRAY OF LIKE gay_file.gay01 
   DEFINE i          INTEGER 
   

      DECLARE cl_gr_curs3 CURSOR FOR SELECT gay01 FROM gay_file WHERE gayacti = 'Y' ORDER BY gay01
      CALL l_gay01.clear() 
      LET i = 1
       FOREACH cl_gr_curs3 INTO l_gay01[i]
         IF SQLCA.SQLCODE THEN
            EXIT FOREACH
         END IF
         LET i = i + 1
      END FOREACH  
     # CALL l_gay01.deleteElement(i)
      RETURN l_gay01 
END FUNCTION 
#FUN-C60026 add-end

#檢查檔案是否已存在，或該檔名為自己所擁有(p_grw)
PRIVATE FUNCTION cl_gr_edit_check_exist(g_gdw09_new)
   DEFINE g_gdw09_new   LIKE gdw_file.gdw09
   DEFINE l_cust_modu  STRING   
   DEFINE l_f       STRING
   DEFINE l_sep     STRING
   DEFINE l_gdw05   LIKE gdw_file.gdw05 #使用者
   
   #先檢查該檔名是否已經存在p_grw，而且是該使用者所建立
   SELECT gdw05 INTO l_gdw05 FROM gdw_file 
      WHERE gdw01 = g_gdw01 AND gdw02 = g_gdw02 AND gdw09 = g_gdw09_new

   IF g_user != l_gdw05 AND NOT cl_null(l_gdw05) THEN
      CALL cl_err('','azz1201',1)
      RETURN FALSE
   END IF

   #轉換成客制模組名
   LET l_cust_modu = gr_edit_get_cust(g_zz011)

   #在客制區檢查檔名是否重覆
   LET l_f = gr_edit_get_4rp_dir(l_cust_modu.toLowerCase())
   LET l_f = l_f, g_gdw09_new CLIPPED , ".4rp"

   #IF os.Path.exists(l_f) THEN #FUN-C60026 mark
   IF os.Path.exists(l_f) AND g_user=l_gdw05 THEN   #FUN-C60026 add 判斷是不是該使用煮
      IF cl_confirm("azz1080") THEN
         RETURN TRUE
      ELSE 
         RETURN FALSE
      END IF
   END IF

   RETURN TRUE
END FUNCTION

FUNCTION gr_edit_get_4rp_dir(p_zz011)
   DEFINE p_zz011   STRING  #模組名
   DEFINE l_path    STRING  #路徑名
   DEFINE l_sep     STRING  
   LET l_sep = os.path.separator()
   
   LET l_path = FGL_GETENV(p_zz011.toUpperCase())
   LET l_path = l_path, l_sep,"4rp",l_sep,g_lang,l_sep
   RETURN l_path
END FUNCTION

PRIVATE FUNCTION gr_edit_get_cust(p_modu)
   DEFINE p_modu  STRING
   IF p_modu.getCharAt(1) != "C" THEN    
      IF p_modu.getCharAt(1) == "G" THEN
         LET p_modu = "C",p_modu
      ELSE 
         LET p_modu = "C",p_modu.subString(2, p_modu.getLength())
      END IF
   END IF
   RETURN p_modu
END FUNCTION

PRIVATE FUNCTION cl_gr_read_4rp(p_gdw08)
   DEFINE p_gdw08   LIKE gdw_file.gdw08
   DEFINE l_zz011   LIKE zz_file.zz011
   DEFINE l_m       STRING,
           l_idx     INTEGER
   DEFINE l_f       STRING,
           l_tmp     STRING 
   DEFINE l_rp_file base.Channel
   DEFINE l_sb      base.StringBuffer
   DEFINE l_doc     om.DomDocument
   DEFINE l_node    om.DomNode
   DEFINE l_i        INTEGER
   DEFINE l_xml     STRING
   #FUN-CB0067 121114 by stellar ----(S)
   DEFINE l_strbuf      base.StringBuffer
   DEFINE l_strong_err  INTEGER
   DEFINE l_chk_err_msg STRING
   #FUN-CB0067 121114 by stellar ----(E)
   DEFINE l_strong_cnt  INTEGER    #FUN-CB0138
   
   IF g_lang IS NULL THEN LET g_lang = "0" END IF
   LET l_rp_file = base.Channel.create()
   
   SELECT zz011 INTO l_zz011 FROM zz_file WHERE zz01 = g_gdw01 #模組別
   LET g_zz011 = l_zz011   

   LET l_m = l_zz011
   IF g_gdw03 == "Y" THEN
      LET l_m = gr_edit_get_cust(l_zz011)      
   END IF
   CALL gr_edit_get_4rp_dir(l_m.toUpperCase()) RETURNING l_f
 
   LET l_strbuf = base.StringBuffer.create()  #FUN-CB0067 121114 by stellar

   LET l_i = 0
   FOR l_idx = 1 TO g_gdw.getLength()
      
      #IF g_gdw[l_idx].sel == "Y" THEN #FUN-CC0081 mark
         LET l_tmp = l_f,g_gdw[l_idx].gdw09,".4rp"
    
         LET l_doc = om.DomDocument.createFromXmlFile(l_tmp)
         IF l_doc IS NULL THEN
            CALL cl_err(l_tmp, "azz-056", 1)
            RETURN NULL
         END IF
         LET l_node = l_doc.getDocumentElement()
    
         LET l_xml = l_node.toString()
         LET l_i = l_i + 1
         LET g_xml[l_i]=cl_gr_replace_char(l_xml)
         
         IF g_gdw[l_idx].sel == "Y" THEN  #FUN-CC0081 add
             #FUN-CB0067 121114 by stellar ----(S)
             #檢查GR報表規範
            
             CALL p_replang_chk_grule(l_tmp,g_gdw[l_idx].gdw08,g_lang)
                  RETURNING l_strong_err,l_chk_err_msg
             #IF l_strong_err > 0 THEN         #FUN-CB0138 mark
             IF l_chk_err_msg.getLength() > 0 THEN  #FUN-CB0138 add
                CALL l_strbuf.append(g_gdw[l_idx].gdw09)
                CALL l_strbuf.append(":\r\n")
                CALL l_strbuf.append(l_chk_err_msg)
                CALL l_strbuf.append("\r\n")
             END IF
             LET l_strong_cnt=l_strong_cnt+l_strong_err
             #FUN-CB0067 121114 by stellar ----(E)

          END IF
      LET g_xml_tmp[l_idx] = l_xml
   END FOR

   #FUN-CB0067 121114 by TSD.stellar ----(S)
   #IF l_strbuf.getLength() > 0 THEN    #FUN-CB0138 mark
   IF l_strong_cnt > 0 THEN             #FUN-CB0138 add    #有強制訊息就不執行LE  
      #CALL cl_err(l_strbuf.toString(),"!",-1)   #FUN-CB0138 mark 字數不夠
      CALL cl_err_msg(l_strbuf.toString(),"!",NULL,-1)  #FUN-CB0138 add
      RETURN NULL                      
   ELSE                                 #FUN-CB0138 add      
       RETURN TRUE                     #FUN-CB0138 add           
   END IF
   #FUN-CB0067 121114 by TSD.stellar ----(E)

   #RETURN TRUE                        #FUN-CB0138 mark
END FUNCTION

#javascript 字串遇到雙引號"及換行符號\n時，必須特別處理
PRIVATE FUNCTION cl_gr_replace_char(ps_str)
   DEFINE ps_str  STRING
   DEFINE l_sb    base.StringBuffer
   LET l_sb = base.StringBuffer.create()
   CALL l_sb.append(ps_str)
   CALL l_sb.replace("\"", "\\\"", 0)
   CALL l_sb.replace("\n", "", 0)
   RETURN l_sb.toString()
END FUNCTION

#必須在WebComponent畫面的OPEN WINDOW之前呼叫，WebComponent路徑才有效果。
PRIVATE FUNCTION cl_gr_set_wc_path()  
   DEFINE l_wcpath   STRING
   
   LET l_wcpath = FGL_GETENV("WEBSERVERIP")
   LET l_wcpath = l_wcpath, "/components"
   CALL ui.interface.frontCall("standard", "setwebcomponentpath", [l_wcpath],[])
END FUNCTION

#FUN-C90038 --(S)
FUNCTION cl_gr_get_multi_lang_xml() 
DEFINE l_lang_data  STRING
DEFINE l_sql        STRING
DEFINE l_token      base.StringTokenizer
DEFINE l_field      LIKE type_file.chr1000
DEFINE l_desc       LIKE type_file.chr1000
DEFINE l_str,l_str2 STRING
DEFINE l_idx        LIKE type_file.num5
DEFINE l_gay01      LIKE gay_file.gay01
DEFINE l_gay03      LIKE gay_file.gay03

     LET l_sql = "SELECT gay01,gay03 FROM gay_file WHERE gay01 IN ('0','1','2')",
                 " ORDER BY gay01 "
     PREPARE cl_gr_multi_lang_pr FROM l_sql
     DECLARE cl_gr_multi_lang_cs CURSOR FOR cl_gr_multi_lang_pr
     LET l_lang_data = '<?xml version="1.0" encoding="utf-8"?><LANGS>'
     FOREACH cl_gr_multi_lang_cs INTO l_gay01,l_gay03
         LET l_lang_data = l_lang_data CLIPPED,'<LANG name="',l_gay01 USING '&','" desc="',l_gay03 CLIPPED,'">'
             LET l_str = cl_getmsg('azz1263',l_gay01)
             LET l_token = base.StringTokenizer.create(l_str, "|")
             WHILE l_token.hasMoreTokens()
                LET l_str2 = l_token.nextToken()
                LET l_idx = l_str2.getIndexOf(',',1)
                IF l_idx = 0 THEN CONTINUE WHILE END IF
                LET l_field = l_str2
                LET l_desc = l_field[l_idx+1,LENGTH(l_field)]
                LET l_field= l_field[1,l_idx-1]
                LET l_lang_data = l_lang_data,'<ITEM name="',l_field CLIPPED,'">',l_desc CLIPPED,'</ITEM>'
             END WHILE
         LET l_lang_data = l_lang_data CLIPPED,'</LANG>'
     END FOREACH
     IF STATUS THEN LET l_lang_data = NULL RETURN l_lang_data END IF

     LET l_lang_data = l_lang_data CLIPPED,'</LANGS>'
     #DISPLAY "l_lang_data:",l_lang_data
     RETURN l_lang_data
     
END FUNCTION
#FUN-C90038 --(E)
