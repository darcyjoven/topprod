# Prog. Version..: '5.30.06-13.03.26(00010)'     #
#
# Pattern name...: s_p_replang.4gl
# Descriptions...: p_replang共用的Function
# Date & Author..: 11/05/05 by jacklai
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report
# Modify.........: No.FUN-C10044 12/01/13 By jacklai 表頭的公司地址等欄位說明寬度調整時，欄位值的定位點應跟隨調整 
# Modify.........: No.FUN-C20112 12/02/23 By jacklai 將共用程式段自p_replang搬出
# Modify.........: No.FUN-C30008 12/03/02 By jacklai 增加欄位對齊屬性
# Modify.........: No.FUN-C30288 12/04/03 By jacklai 修正群組首與群組尾欄位類別錯誤
# Modify.........: No.FUN-C40034 12/04/17 By janet 設定隱藏否至gdm27及gdm26欄
# Modify.........: No.TQC-C50068 12/05/09 By odyliao 修改p_replang_updgdm() 可能會造成-391錯誤
# Modify.........: No.FUN-C50046 12/05/10 By janet 增加檢查4rp是否符合GR規範機制
# Modify.........: No.FUN-CB0059 12/11/14 By janet 拿掉Dspacer'DHspacer'Gspacer'GHspacer scaleX、scaleY的檢查機制
# Modify.........: No.FUN-CB0063 12/11/14 by stellar 子報表的上層容器必為MiniPage
# Modify.........: No.FUN-CC0005 12/12/03 by janet 增加Mspacer
# Modify.........: No.FUN-CC0081 12/12/12 by janet layouteditor產出或客製的4rp不做GR檢查機制
# Modify.........: No.FUN-D10088 13/01/17 by janet Y有值的檢查列為強制訊息
# Modify.........: No.CHI-D30013 13/03/26 by odyliao 調整 p_replang_readnodes 增加傳參數 p_code 以修正行序欄序問題

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_chk_err_msg        STRING  #FUN-C10044 #檢查報表命名規則的錯誤訊息 #FUN-C20112
DEFINE g_strong_err         INTEGER  #FUN-C50046 #強制錯誤訊息數



#FUN-C50046 -----start-----
FUNCTION p_replang_chkrule(p_gdm01,p_gdm03,p_node,p_tagname)
   DEFINE p_gdm01       LIKE gdm_file.gdm01           
   DEFINE p_gdm03       LIKE gdm_file.gdm03
   DEFINE p_node        om.DomNode
   DEFINE p_tagname     STRING 
   DEFINE l_node        om.NodeList                    #存標籤節點 
   DEFINE l_parent      om.DomNode
   DEFINE l_curnode     om.DomNode
   DEFINE l_prenode     om.DomNode
   DEFINE l_par_parnode om.DomNode                    #祖父節點   
   DEFINE l_i           LIKE type_file.num5   
   DEFINE l_nodeName    STRING
   DEFINE l_find_str    STRING                        #尋找字串   
   DEFINE l_msg         STRING                        #組錯誤訊息的字串緩衝區
   DEFINE l_parname,l_parname_seq     STRING          #父節點name屬性,父節點流水號
   DEFINE l_par_parname  STRING                        #祖父節點name屬性
   DEFINE l_parname_str  STRING 
   DEFINE l_childName   STRING                        #子節點name屬性
   DEFINE l_msg_index   LIKE type_file.num5           #訊息陣列index
   DEFINE l_cnt_zz14    LIKE type_file.num10          #憑證類
   DEFINE l_prog        LIKE gdw_file.gdw01           #程式代號
   DEFINE l_strbuf      base.StringBuffer             #錯誤訊息
   DEFINE l_cur_size    DYNAMIC ARRAY OF STRING       #X,Y,X-size,y-size屬性內容 
   DEFINE l_chi_node    DYNAMIC ARRAY OF om.DomNode       #子節點陣列       
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_set_length  STRING 
   DEFINE l_set_width   STRING 
   DEFINE l_cur_value   FLOAT
   DEFINE l_totlength_new FLOAT 
   DEFINE l_totlength_old FLOAT 
   DEFINE l_wid_value     FLOAT 
   DEFINE l_y_value       FLOAT  
   DEFINE l_BORDERWIDTH ,l_bottonwidth,l_topwidth,l_par_topwidth  FLOAT   #分隔線
   DEFINE l_nextnode,l_childnode,l_chi_prenode    om.DomNode 
   DEFINE l_nextname,l_chi_prename    STRING 
   DEFINE l_font,l_font_size  STRING 
   DEFINE l_set_y       STRING 
   DEFINE l_ii          INTEGER 
   DEFINE l_pre_y_value FLOAT
   DEFINE l_pre_width_value FLOAT
   DEFINE l_pre_y,l_pre_width  STRING 
   DEFINE l_childtag    STRING     #子節點的tagname
   DEFINE l_chi_i       LIKE type_file.num5
   DEFINE l_spacer      STRING 
   DEFINE l_temp        FLOAT 
   DEFINE l_nodeurl     STRING   #FUN-CB0063 121114 by TSD.stellar
   DEFINE l_colname_str,l_find_str1 STRING   #FUN-CB0059 add
   DEFINE l_scaleX,l_scaleY  STRING          #FUN-CB0059 add 
   DEFINE l_subrep_name      STRING          #FUN-CC0005 add
   DEFINE l_seq              INTEGER         #FUN-CC0081 add
   
   LET l_strbuf = base.StringBuffer.create()
   LET l_node = p_node.selectByTagName(p_tagname)
   LET l_msg_index=0 #訊息陣列的index

   
   #新版------
   #有找到
   IF l_node IS NOT NULL THEN 
   
        FOR l_i=1 TO l_node.getLength()
            
            LET l_curnode = l_node.item(l_i)
            LET l_nodename = l_curnode.getAttribute("name")
            LET l_nodeurl = l_curnode.getAttribute("url")    #FUN-CB0063 121114 by stellar
            LET l_parent = l_curnode.getParent()
            LET l_parname=l_parent.getAttribute("name")
            LET l_par_parnode=l_parent.getParent() #祖父節點
            LET l_par_parname=l_par_parnode.getAttribute("name")#祖父節點名稱            
            ###檢查父節點
            IF p_tagname="WORDWRAPBOX" OR p_tagname="WORDBOX" OR 
               p_tagname="PAGENOBOX" OR p_tagname="IMAGEBOX" OR 
               p_tagname="HTMLBOX" OR p_tagname="DECIMALFORMATBOX" THEN 
               IF l_parent.getAttribute("name") IS NOT NULL THEN
                       IF l_parname.getIndexOf("PageFooter",1)>0 THEN
                         IF NOT l_par_parname.equals("PageFooters") THEN
                            LET l_msg ="(強制)", cl_getmsg_parm("azz1235", g_lang, l_nodename),"PageFooters"
                            IF l_msg IS NOT NULL THEN
                               CALL l_strbuf.append(l_msg)
                               CALL l_strbuf.append("\r\n")
                            END IF     
                            LET g_strong_err=g_strong_err+1 #強制訊息                         
                         END IF 
                      ELSE 
                        IF l_parname.getIndexOf("PageHeader",1)>0 THEN
                             IF NOT l_par_parname.equals("PageHeaderGroups") THEN
                                LET l_msg = "(強制)", cl_getmsg_parm("azz1235", g_lang, l_nodename),"PageHeaderGroups"
                                IF l_msg IS NOT NULL THEN
                                   CALL l_strbuf.append(l_msg)
                                   CALL l_strbuf.append("\r\n")
                                END IF 
                                LET g_strong_err=g_strong_err+1 #強制訊息                                  
                             END IF 
                        ELSE
                          IF l_parname.getIndexOf("Master",1)>0 THEN
                             IF NOT l_par_parname.equals("Masters") THEN
                                LET l_msg ="(強制)",  cl_getmsg_parm("azz1235", g_lang, l_nodename),"Masters"
                                IF l_msg IS NOT NULL THEN
                                   CALL l_strbuf.append(l_msg)
                                   CALL l_strbuf.append("\r\n")
                                END IF
                                LET g_strong_err=g_strong_err+1 #強制訊息                                   
                             END IF  
                          ELSE
                               IF l_parname.getIndexOf("DetailHeader",1)>0 THEN
                                 IF NOT l_par_parname.equals("DetailHeaders") THEN
                                    LET l_msg ="(強制)",  cl_getmsg_parm("azz1235", g_lang, l_nodename),"DetailHeaders"
                                    IF l_msg IS NOT NULL THEN
                                       CALL l_strbuf.append(l_msg)
                                       CALL l_strbuf.append("\r\n")
                                    END IF
                                    LET g_strong_err=g_strong_err+1 #強制訊息                                       
                                 END IF 
                               ELSE 
                                   IF l_parname.getIndexOf("Detail",1)>0 THEN
                                     IF NOT l_par_parname.equals("Details") THEN
                                        LET l_msg = "(強制)", cl_getmsg_parm("azz1235", g_lang, l_nodename),"Details"
                                        IF l_msg IS NOT NULL THEN
                                           CALL l_strbuf.append(l_msg)
                                           CALL l_strbuf.append("\r\n")
                                        END IF 
                                        LET g_strong_err=g_strong_err+1 #強制訊息                                           
                                     END IF 
                                   ELSE 
                                       IF l_parname.getIndexOf("ReportFooter",1)>0 THEN
                                         IF NOT l_par_parname.equals("ReportFooters") THEN
                                            LET l_msg ="(強制)",  cl_getmsg_parm("azz1235", g_lang, l_nodename),"ReportFooters"
                                            IF l_msg IS NOT NULL THEN
                                               CALL l_strbuf.append(l_msg)
                                               CALL l_strbuf.append("\r\n")
                                            END IF  
                                            LET g_strong_err=g_strong_err+1 #強制訊息                                               
                                         END IF 
                                       ELSE 
                                          IF l_parname.getIndexOf(l_parname,1)>0 THEN
                                            IF NOT l_par_parname.equals(l_par_parname) THEN
                                                LET l_msg ="(強制)",  l_curnode.getAttribute("name") ,"此節點上層容器命名錯誤" 
                                                IF l_msg IS NOT NULL THEN
                                                   CALL l_strbuf.append(l_msg)
                                                   CALL l_strbuf.append("\r\n")
                                                END IF 
                                                LET g_strong_err=g_strong_err+1 #強制訊息 
                                            END IF 
                                          END IF 
                                       END IF # IF ReportFooter
                                   END IF  #IF Detail
                               END IF     #IF DetailHeader                     
                          END IF    #IF Master
                        END IF  #IF PageHeader

                       
                      END IF  #IF l_parname.getIndexOf(1,"PageFooter")                 
               END IF #l_parent.getAttribute("name") IS NOT NULL
               
            END IF  #IF p_tagname=WORDWRAPBOX、WORDBOX~~~~

            ###檢查PageRoot相關規則
            IF  l_curnode.getAttribute("name")="Page Root" THEN 
                ##檢查為了達成可以按ﾞ單號ﾞ跳頁的功能，憑證類報表的Page Root須放在群組之下
                SELECT gdw01 INTO l_prog FROM gdw_file WHERE gdw08=p_gdm01
                SELECT count(zz14) INTO l_cnt_zz14 FROM zz_file WHERE zz01=l_prog AND (zz14 IN (1))
                IF l_cnt_zz14=1 THEN
                     IF l_parent.getAttribute("name") <> "Group" THEN
                            LET l_msg="(強制)", "憑證類報表的PageRoot沒有擺在Group節點下" 
                            IF l_msg IS NOT NULL THEN
                               CALL l_strbuf.append(l_msg)
                               CALL l_strbuf.append("\r\n")
                            END IF 
                            LET g_strong_err=g_strong_err+1 #強制訊息   
                     END IF 
                ELSE ##檢查非憑證類報表父節點是否為Report,例:artg100.4rp
                     IF  l_parent.getAttribute("name") <> "Report" THEN
                            LET l_msg="(強制)", l_nodeName ,"PageRoot沒有擺在根節點下" 
                            IF l_msg IS NOT NULL THEN
                               CALL l_strbuf.append(l_msg)
                               CALL l_strbuf.append("\r\n")
                            END IF 
                            LET g_strong_err=g_strong_err+1 #強制訊息                               
                     END IF              
                END IF 
                ##檢查尾頁是否隱藏PageFooter
                IF l_curnode.getAttribute("hidePageFooterOnLastPage") IS NULL AND 
                   l_curnode.getAttribute("hidePageFooterOnLastPage") ="false" THEN
                            LET l_msg="(強制)", l_nodeName ,"PageRoot之HidePageFooterOnLastPage選項未勾" 
                            IF l_msg IS NOT NULL THEN
                               CALL l_strbuf.append(l_msg)
                               CALL l_strbuf.append("\r\n")
                            END IF  
                            LET g_strong_err=g_strong_err+1 #強制訊息                    
                END IF    
                
            END IF   #IF  l_curnode.getAttribute("name")="Page Root"
    
    
            ###檢查ReportFooters高度Y有沒有設定為max-2.2cm
            IF l_curnode.getTagName()="MINIPAGE" THEN 
                IF  l_curnode.getAttribute("name")="ReportFooters" AND l_curnode.getAttribute("y")<>"max-2.2cm" THEN 
                      LET l_msg=l_nodeName ,"ReportFooters高度未設定為max-2.2cm" 
                      IF l_msg IS NOT NULL THEN
                         CALL l_strbuf.append(l_msg)
                         CALL l_strbuf.append("\r\n")
                      END IF                   
                END IF 
            END IF 


            ###檢查PageFooters必須放在PageHeaderGroups之前
            IF p_tagname="LAYOUTNODE" AND l_curnode.getAttribute("name")="PageHeaderGroups" THEN
               IF l_i-1>0 THEN 
                  LET l_prenode= l_node.item(l_i-1)
                  IF l_prenode.getAttribute("name")<>"PageFooters" THEN
                        LET l_msg="(強制)", l_nodeName ,"PageFooters必須放在PageHeaderGroups之前" 
                        IF l_msg IS NOT NULL THEN
                           CALL l_strbuf.append(l_msg)
                           CALL l_strbuf.append("\r\n")
                        END IF 
                        LET g_strong_err=g_strong_err+1 #強制訊息                           
                  END IF 
               ELSE 
                   LET l_msg="(強制)", l_nodeName ,"PageFooters必須放在PageHeaderGroups之前" 
                   IF l_msg IS NOT NULL THEN
                      CALL l_strbuf.append(l_msg)
                      CALL l_strbuf.append("\r\n")
                   END IF    
                   LET g_strong_err=g_strong_err+1 #強制訊息                  
               END IF 
               
            END IF 
    
            ###檢查detail子節點欄位是否有設定右邊界為0.1cm
            IF p_tagname="MINIPAGE" THEN                         
                IF  l_parname.subString("Detail",1) AND (NOT l_parname.equals("Details")) THEN 
                    IF l_curnode.getAttribute("marginRightWidth") <> "0.1cm" THEN
                            LET l_msg=l_nodeName ,"單身的欄位右邊界設定錯誤，應為0.1cm (Margin->Right Width->0.1cm)" 
                            IF l_msg IS NOT NULL THEN
                               CALL l_strbuf.append(l_msg)
                               CALL l_strbuf.append("\r\n")
                            END IF            
                    END IF 
                END IF 
            END IF 
            
            ###檢查需照流水號編號的規則
            IF l_curnode.getTagName() = "LAYOUTNODE" THEN  
               CALL  l_chi_node.clear()
               LET l_chi_i=0
               FOR  l_ii=1 TO l_curnode.getChildCount()
                   LET l_childnode=l_curnode.getChildByIndex(l_ii)
                   LET l_childname= l_childnode.getAttribute("name")
                   LET l_childtag=l_childnode.getTagName()
                   IF l_childtag="MINIPAGE" THEN  
                      LET l_chi_i=l_chi_i+1
                      LET l_chi_node[l_chi_i]=l_childnode
                   END IF                       
               END FOR 
               LET l_seq=0 #FUN-CC0081 add
               FOR l_ii=1 TO l_chi_node.getLength()    
                   LET l_find_str=l_nodename    #父節點name屬性的內容
                   IF l_find_str="PageHeaderGroups" THEN LET l_find_str="PageHeaders"  END IF #規則相同
                   #FUN-CB0059 add-(s)
                   LET l_childname= l_chi_node[l_ii].getAttribute("name")  
                   LET l_find_str1=l_find_str.subString(1,l_find_str.getLength()-1)
                   IF l_childname.getIndexOf(l_find_str1,1)>0 THEN 
                   #FUN-CB0059 add-(e)             
                   #LET l_find_str=l_find_str.subString(1,l_find_str.getLength()-1),l_ii USING "&&" #FUN-CC0081 mark
                    LET l_seq=l_seq+1                                                                #FUN-CC0081 add
                    LET l_find_str=l_find_str.subString(1,l_find_str.getLength()-1),l_seq USING "&&"  #FUN-CC0081 add
                   #LET l_childname= l_chi_node[l_ii].getAttribute("name")  #FUN-CB0059 mark
                      CASE l_nodename             
                            WHEN "DetailHeaders" #單身欄位說明各行Stripe物件名稱為DetailHeader01~99，上層節點為DetailHeaders (LayoutNode)             
                               IF NOT l_childname.equals(l_find_str) THEN #找name搭上流水號是否正確                                             
                                  LET l_msg="(強制)", l_childname ,"不應該出現此行或命名錯誤" 
                                  IF l_msg IS NOT NULL THEN
                                     CALL l_strbuf.append(l_msg)
                                     CALL l_strbuf.append("\r\n")
                                  END IF 
                                  LET g_strong_err=g_strong_err+1 #強制訊息                           
                               END IF
                            WHEN "Details"  #單身各行物件名稱為 Detail01~99 (Stripe)， 上層節點為 Details (LayoutNode)
                               IF NOT l_childname.equals(l_find_str) THEN #找name搭上流水號是否正確 
                                  LET l_msg="(強制)", l_childname ,"不應該出現於",l_ii,"行, 或命名錯誤" 
                                  IF l_msg IS NOT NULL THEN
                                     CALL l_strbuf.append(l_msg)
                                     CALL l_strbuf.append("\r\n")
                                  END IF  
                                  LET g_strong_err=g_strong_err+1 #強制訊息                           
                               END IF
                            WHEN "Masters"  #單頭各行 Stripe物件名稱為Master01~99
                               IF NOT l_childname.equals(l_find_str) THEN #找name搭上流水號是否正確 
                                  LET l_msg="(強制)", l_childname ,"不應該出現於",l_ii,"行, 或命名錯誤" 
                                  IF l_msg IS NOT NULL THEN
                                     CALL l_strbuf.append(l_msg)
                                     CALL l_strbuf.append("\r\n")
                                  END IF 
                                  LET g_strong_err=g_strong_err+1 #強制訊息    
                               END IF
                            WHEN "PageFooters"  ##頁尾欄位各行命名為PageFooter01，PageFooter02…，依行序編號即可
                               IF NOT l_childname.equals(l_find_str) THEN
                                  LET l_msg="(強制)", l_childname ,"不應該出現於",l_ii,"行, 或命名錯誤" 
                                  IF l_msg IS NOT NULL THEN
                                     CALL l_strbuf.append(l_msg)
                                     CALL l_strbuf.append("\r\n")
                                  END IF 
                                  LET g_strong_err=g_strong_err+1 #強制訊息                           
                               END IF 
                            WHEN "ReportFooters"  #頁尾欄位各行命名為PageFooter01，PageFooter02…，依行序編號即可
                               IF NOT l_childname.equals(l_find_str) THEN
                                  LET l_msg="(強制)", l_childname ,"不應該出現於",l_ii,"行, 或命名錯誤" 
                                  IF l_msg IS NOT NULL THEN
                                     CALL l_strbuf.append(l_msg)
                                     CALL l_strbuf.append("\r\n")
                                  END IF  
                                  LET g_strong_err=g_strong_err+1 #強制訊息                           
                               END IF               
                            
                            WHEN "PageHeaderGroups" #群組首名稱：GroupHeader_[群組欄位名稱]_[流水號兩碼]
                               IF NOT l_childname.equals(l_find_str) THEN
                                  LET l_msg="(強制)", l_childname ,"不應該出現於",l_ii,"行, 或命名錯誤" 
                                  IF l_msg IS NOT NULL THEN
                                     CALL l_strbuf.append(l_msg)
                                     CALL l_strbuf.append("\r\n")
                                  END IF 
                                  LET g_strong_err=g_strong_err+1 #強制訊息                           
                               END IF 
                              #先不用檢查--------start
                            OTHERWISE      # 群組尾名稱：GroupFooter_[群組欄位名稱]_[流水號兩碼] or 群組首GroupHeader_[群組欄位名稱]_[流水號兩碼]                     
                               LET l_find_str=l_parent.getAttribute("name"),"_",l_i USING "&&"     #父節點name屬性的內容             
                               IF l_nodeName.getIndexOf("l_find_str",1) <0 THEN
                                  LET l_msg=l_nodeName ,"不應該出現於",l_i,"行, 或命名錯誤" 
                                  IF l_msg IS NOT NULL THEN
                                     CALL l_strbuf.append(l_msg)
                                     CALL l_strbuf.append("\r\n")
                                  END IF 
                                  LET g_strong_err=g_strong_err+1 #強制訊息                           
                               END IF 
                            #先不用檢查--------end 
                       END CASE
                   END IF  #l_childname.getIndexOf(l_find_str1,1)>0  #FUN-CB0059 add                   
               END FOR 
            END IF  # l_curnode.getTagName() = "LAYOUTNODE"
    
            
            ###檢查空白欄位的命名規則 
            IF l_curnode.getTagName() = "MINIPAGE" OR l_curnode.getTagName() = "LAYOUTNODE" THEN ###FUN-CB0059 add LAYOUTNODE判斷GFspacer' GHspacer
               CALL l_chi_node.clear()
               LET l_chi_i=0
               FOR  l_ii=1 TO l_curnode.getChildCount()
                   LET l_childnode=l_curnode.getChildByIndex(l_ii)
                   LET l_childname= l_childnode.getAttribute("name")
                   LET l_childtag=l_childnode.getTagName()
                   IF l_nodename.getIndexOf("DetailHeader",1)>0 THEN LET l_spacer="DHspacer" END IF 
                   IF l_nodename.getIndexOf("Detail",1)>0 THEN LET l_spacer="Dspacer" END IF
                   #FUN-CB0059 add---(S)
                   IF l_nodename.getIndexOf("GroupHeader",1)>0 THEN LET l_spacer="GHspacer" END IF 
                   IF l_nodename.getIndexOf("GroupFooter",1)>0 THEN 
                       LET l_spacer="GFspacer"  
                   ELSE 
                       IF l_nodename.getIndexOf("Footer",1)>0 THEN 
                          LET l_spacer="Fspacer" 
                       #FUN-CC0005 add -(s)
                       ELSE
                           IF l_nodename.getIndexOf("Master",1)>0 THEN 
                              LET l_spacer="Mspacer" 
                           END IF 
                       #FUN-CC0005 add -(e)    
                       END IF 
                   END IF     
                   #FUN-CB0059 add---(E)
                   IF l_childname.getIndexOf(l_spacer,1)>0 THEN  
                      LET l_chi_i=l_chi_i+1
                      LET l_chi_node[l_chi_i]=l_childnode
                   END IF                       
               END FOR 
               FOR l_ii=1 TO l_chi_node.getLength()   
                    LET l_parname_seq=l_nodename.subString(l_nodename.getLength()-1,l_nodename.getLength())#流水號
                    LET l_parname_str=l_nodename.subString(1,l_nodename.getLength()-2) 
                    LET l_childname= l_chi_node[l_ii].getAttribute("name") 
                    #DISPLAY "l_childname", l_childname
                    #DISPLAY "l_parname_str", l_parname_str
                    #DISPLAY "l_parname_seq", l_parname_seq
                    #LET l_find_str=l_spacer,l_parname_seq,"_",l_ii USING "&&","_Label"#組出DHspacer01_01  ##FUN-CB0059mark
                    #FUN-CB0059 add--(S)
                    IF l_parname_str.getIndexOf("GroupHeader",1)>0 OR l_parname_str.getIndexOf("GroupFooter",1)>0 THEN
                       IF l_parname_str.getIndexOf("GroupHeader",1)>0 THEN  
                          LET l_colname_str=cl_replace_str(l_parname_str,"GroupHeader","")
                          LET l_parname_str="GroupHeader"
                       END IF 
                       IF l_parname_str.getIndexOf("GroupFooter",1)>0 THEN  
                          LET l_colname_str=cl_replace_str(l_parname_str,"GroupFooter","")
                          LET l_parname_str="GroupFooter"
                       END IF                       
                       LET l_colname_str=l_colname_str.subString(l_colname_str.getIndexOf("_",1)+1,l_colname_str.getLength()-1) #找出中間的欄位名
                       LET l_find_str=l_spacer ,"_",l_colname_str,"_",l_parname_seq,"_",l_ii USING "&&"
                    ELSE 
                    #FUN-CB0059 add--(E)
                       LET l_find_str=l_spacer,l_parname_seq,"_",l_ii USING "&&"#組出DHspacer01_01 #FUN-CB0059 add                       
                    END IF #FUN-CB0059 add
                    #DISPLAY "l_find_str:",l_find_str  
                    #DISPLAY "l_childname:",  l_childName   
                    #DISPLAY "l_parname_str:",l_parname_str         
                    CASE l_parname_str        
                      WHEN "DetailHeader"    #空白欄位名稱命名規則在DetailHeader01中為[DHspacer行號_流水號]。範例: DHspacer01_01                       
                           IF l_childName.equals(l_find_str) =0 THEN #找name搭上流水號是否正確
                              LET l_msg="(強制)", l_childName ,"命名錯誤" 
                              IF l_msg IS NOT NULL THEN
                                 CALL l_strbuf.append(l_msg)
                                 CALL l_strbuf.append("\r\n")
                              END IF 
                              LET g_strong_err=g_strong_err+1 #強制訊息
                           END IF

                      WHEN "Detail"  #空白欄位名稱命名規則在Detail01中為[Dspacer行號_流水號]。範例: Dspacer01_01
                              IF l_childName.equals(l_find_str)=0 THEN #找name搭上流水號是否正確
                                 LET l_msg="(強制)", l_childName ,"命名錯誤" 
                                 IF l_msg IS NOT NULL THEN
                                    CALL l_strbuf.append(l_msg)
                                    CALL l_strbuf.append("\r\n")
                                 END IF 
                                 LET g_strong_err=g_strong_err+1 #強制訊息
                              END IF
                      #FUN-CB0059 add--(s)
                      WHEN "GroupHeader"  #空白欄位名稱命名規則在GroupHeader01中為[GHspacer行號_流水號]。範例: GHspacer01_01
                              IF l_childName.equals(l_find_str)=0 THEN #找name搭上流水號是否正確
                                 LET l_msg="(強制)", l_childName ,"命名錯誤" 
                                 IF l_msg IS NOT NULL THEN
                                    CALL l_strbuf.append(l_msg)
                                    CALL l_strbuf.append("\r\n")
                                 END IF 
                                 LET g_strong_err=g_strong_err+1 #強制訊息
                              END IF
                      WHEN "GroupFooter"  #空白欄位名稱命名規則在GroupFooter01中為[GFspacer行號_流水號]。範例: GFspacer01_01
                              IF l_childName.equals(l_find_str)=0 THEN #找name搭上流水號是否正確
                                 LET l_msg="(強制)", l_childName ,"命名錯誤" 
                                 IF l_msg IS NOT NULL THEN
                                    CALL l_strbuf.append(l_msg)
                                    CALL l_strbuf.append("\r\n")
                                 END IF 
                                 LET g_strong_err=g_strong_err+1 #強制訊息
                              END IF      
                      WHEN "Footer"  #空白欄位名稱命名規則在Footer01中為[GFspacer行號_流水號]。範例: GFspacer01_01
                        IF l_childName.equals(l_find_str)=0 THEN #找name搭上流水號是否正確
                           LET l_msg="(強制)", l_childName ,"命名錯誤" 
                           IF l_msg IS NOT NULL THEN
                              CALL l_strbuf.append(l_msg)
                              CALL l_strbuf.append("\r\n")
                           END IF 
                           LET g_strong_err=g_strong_err+1 #強制訊息
                        END IF     
                      #FUN-CC0005 add -(s)
                      WHEN "Master"  #空白欄位名稱命名規則在Master01中為[Mspacer行號_流水號]。範例: Mspacer01_01
                        IF l_childName.equals(l_find_str)=0 THEN #找name搭上流水號是否正確
                           LET l_msg="(強制)", l_childName ,"命名錯誤" 
                           IF l_msg IS NOT NULL THEN
                              CALL l_strbuf.append(l_msg)
                              CALL l_strbuf.append("\r\n")
                           END IF 
                           LET g_strong_err=g_strong_err+1 #強制訊息
                        END IF   
                      #FUN-CC0005 add -(e)                      
                      #FUN-CB0059 add--(e)
                    END CASE 
               END FOR  #FOR l_ii=1 TO l_chi_node.getLength() 
            END IF 

            
            ###欄位若設定X-Size, Y-Size, X, Y數字，則單位必用cm(必小寫)。0 視同於0 cm。也可設定非數字，ex: max, min, rest
            IF  p_tagname <>"MINIPAGE" AND p_tagname<> "LAYOUTNODE" THEN 
                IF l_nodename.getIndexOf("PageFooterStatus",1)=0 AND l_nodename.getIndexOf("Reporter",1)=0 AND 
                   l_nodename.getIndexOf("ReportFooterStatus",1)=0 AND l_nodename.getIndexOf("PageNo",1)=0 AND 
                   l_nodename.getIndexOf("PageFooterCond",1)=0 AND l_nodename.getIndexOf("ReportFooterCond",1)=0  THEN  
                    CALL l_cur_size.clear()
                    #因為會有max-5cm這類的值，所以不檢查x及y欄位
                    #CALL l_cur_size.appendElement()
                    #LET l_cur_size[l_cur_size.getLength()] = l_curnode.getAttribute("x")
                    #CALL l_cur_size.appendElement()
                    #LET l_cur_size[l_cur_size.getLength()]= l_curnode.getAttribute("y")
                    CALL l_cur_size.appendElement()
                    LET l_cur_size[l_cur_size.getLength()]= l_curnode.getAttribute("width")
                    CALL l_cur_size.appendElement()
                    LET l_cur_size[l_cur_size.getLength()]= l_curnode.getAttribute("length")  
                    CALL l_cur_size.deleteElement(l_cur_size.getLength())
                    FOR l_cnt=1 TO l_cur_size.getLength()
                        IF l_cur_size[l_cnt] IS NOT NULL THEN 
                            IF l_cur_size[l_cnt].getIndexOf("cm",1)>0 THEN 
                               LET l_cur_value=cl_replace_str(l_cur_size[l_cnt],"cm","") #若轉出是max-5 要判斷掉
                               
                               IF l_cur_value IS NULL  THEN #l_cur_size截掉cm不是純數字
                                  #LET l_msg="設定",l_curnode.getAttribute("name"),"格式設定應為 0.5cm, max 或 min" #FUN-D10088 mark
                                  LET l_msg="(強制)設定",l_curnode.getAttribute("name"),"格式設定應為 0.5cm, max 或 min"  #FUN-D10088 add
                                  IF l_msg IS NOT NULL THEN
                                    CALL l_strbuf.append(l_msg)
                                    CALL l_strbuf.append("\r\n")
                                  END IF  
                                  LET g_strong_err=g_strong_err+1 #強制訊息    #FUN-D10088 add

                               END IF 
                                
                            ELSE 
                               IF l_cur_size[l_cnt].equalsIgnoreCase("max") =0 AND 
                                  l_cur_size[l_cnt].equalsIgnoreCase("min") =0 AND 
                                  l_cur_size[l_cnt].equalsIgnoreCase("rest") =0 THEN 
                                  #LET l_msg="設定",l_curnode.getAttribute("name"),"定位單位",l_cur_size[l_cnt],"必須為cm"  #FUN-D10088 mark
                                  LET l_msg="(強制)設定",l_curnode.getAttribute("name"),"定位單位",l_cur_size[l_cnt],"必須為cm"  #FUN-D10088 add
                                  IF l_msg IS NOT NULL THEN
                                     CALL l_strbuf.append(l_msg)
                                     CALL l_strbuf.append("\r\n")
                                  END IF   
                                  LET g_strong_err=g_strong_err+1 #強制訊息    #FUN-D10088 add
                               END IF #max' min'rest
                            END IF #l_cur_size[l_cnt].getIndexOf("cm",1)>0
                        #ELSE 
                            #LET l_msg="設定",l_curnode.getAttribute("name"),"定位單位",l_cur_size[l_cnt],"必須為cm"
                            #IF l_msg IS NOT NULL THEN
                               #CALL l_strbuf.append(l_msg)
                               #CALL l_strbuf.append("\r\n")
                            #END IF                        
                        END IF  #l_cur_size[l_cnt] IS NOT NULL
                    END FOR  #l_cnt=1 TO l_cur_size.getLength()             
                END IF #l_nodename.getIndexOf("PageFooterStatus",1)=0 AND l_nodename.getIndexOf("Reporter",1)=0 AND 
                       # l_nodename.getIndexOf("ReportFooterStatus",1)=0 AND l_nodename.getIndexOf("PageNo",1)
            END IF  #p_tagname <>"MINIPAGE" AND p_tagname<> "LAYOUTNODE" 

            ###欄位顯示的內容有文字，在欄位屬性需勾選Fidelity，否則內容會顯示 □□□
            IF p_tagname="WORDWRAPBOX" OR p_tagname="WORDBOX" OR 
               p_tagname="PAGENOBOX" OR p_tagname="IMAGEBOX" OR 
               p_tagname="HTMLBOX" OR p_tagname="DECIMALFORMATBOX" THEN
               IF l_curnode.getAttribute("fidelity")<>"true" THEN
                  LET l_msg="(強制)", l_curnode.getAttribute("name"),"欄位未勾選Fidelity屬性"
                  IF l_msg IS NOT NULL THEN
                     CALL l_strbuf.append(l_msg)
                     CALL l_strbuf.append("\r\n")
                  END IF  
                  LET g_strong_err=g_strong_err+1 #強制訊息                  
               END IF              
            END IF 


            ###所有欄位的縱向高度都不必設定,寬度一定要設， imageBox例外, 容器一定要設寬跟高
          IF p_tagname <> "rtl:call-report" THEN  #FUN-CB0063 121114 by stellar
            LET l_set_length =l_curnode.getAttribute("length")
            LET l_set_width =l_curnode.getAttribute("width")
            IF p_tagname="MINIPAGE" OR p_tagname="LAYOUTNODE" THEN   #容器一定要設寬跟高
               ##Layout Node 與 Mini Page 的 X-Size 跟 Y-Size 一定要存在，但不檢查設定值
               IF l_set_length IS NULL OR l_set_length.getLength()=0 THEN
                  LET l_msg=l_nodename,"一定要設Y-Size"
                  IF l_msg IS NOT NULL THEN
                     CALL l_strbuf.append(l_msg)
                     CALL l_strbuf.append("\r\n")
                  END IF                     
               END IF
               IF l_set_width IS NULL OR l_set_width.getLength()=0 THEN
                  LET l_msg=l_nodename,"一定要設X-Size"
                  IF l_msg IS NOT NULL THEN
                     CALL l_strbuf.append(l_msg)
                     CALL l_strbuf.append("\r\n")
                  END IF                     
               END IF               
            ELSE #非容器類 縱向高度都不必設定,寬度一定要設
                IF l_set_length IS NOT NULL  THEN
                  LET l_msg=l_nodename,"不可設Y-Size"
                  IF l_msg IS NOT NULL THEN
                     CALL l_strbuf.append(l_msg)
                     CALL l_strbuf.append("\r\n")
                  END IF                     
               END IF   
               
               IF p_tagname="IMAGEBOX"  THEN   #IMAGEBOX是例外，先檢查不能設寬高
                   IF l_set_width IS NOT NULL THEN
                      LET l_msg=l_nodename,"不可設X-Size"
                      IF l_msg IS NOT NULL THEN
                         CALL l_strbuf.append(l_msg)
                         CALL l_strbuf.append("\r\n")
                      END IF                     
                   END IF                    
               ELSE
                   IF l_set_width IS NULL THEN
                      LET l_msg=l_nodename,"一定要設X-Size"
                      IF l_msg IS NOT NULL THEN
                         CALL l_strbuf.append(l_msg)
                         CALL l_strbuf.append("\r\n")
                      END IF                     
                   END IF                 
               END IF      
            END IF 
          END IF   #FUN-CB0063 121114 by stellar

            ###單頭欄位位置: 使用橫軸座標定位
            IF p_tagname="MINIPAGE" THEN
               LET l_parname=l_parent.getAttribute("name")
               IF l_parname IS NOT NULL AND l_parname.getIndexOf("Master",1) >0 AND 
                  l_parent.getAttribute("layoutDirection")="leftToRight" THEN  
                  IF l_curnode.getAttribute("y") IS NULL OR l_curnode.getAttribute("y")="" THEN 
                      LET l_msg="(強制)", l_nodename,"應該設置定位點於Y"
                      IF l_msg IS NOT NULL THEN
                         CALL l_strbuf.append(l_msg)
                         CALL l_strbuf.append("\r\n")
                      END IF 
                      LET g_strong_err=g_strong_err+1 #強制訊息
                  END IF
                  IF l_curnode.getAttribute("x") IS NOT NULL OR l_curnode.getAttribute("x")<>"" THEN 
                      LET l_msg="(強制)", l_nodename,"不應該設置定位點於X"
                      IF l_msg IS NOT NULL THEN
                         CALL l_strbuf.append(l_msg)
                         CALL l_strbuf.append("\r\n")
                      END IF 
                      LET g_strong_err=g_strong_err+1 #強制訊息
                  END IF                   
               END IF    
            END IF 

            ###單身欄位的橫軸與縱軸座標 (屬性X, Y) 都不必設定
            #120608 國羽:先不用檢查單身----mark-s
            #IF p_tagname <> "MINIPAGE" AND p_tagname <>"LAYOUTNODE" THEN 
               #IF l_parname.getIndexOf("Detail",1)>0 AND l_parname <> "Details" THEN 
                   #IF l_curnode.getAttribute("x") IS NOT NULL OR l_curnode.getAttribute("x")<>"" THEN
                          #LET l_msg="(強制)", l_nodename,"不應該設定x"
                          #IF l_msg IS NOT NULL THEN
                             #CALL l_strbuf.append(l_msg)
                             #CALL l_strbuf.append("\r\n")
                          #END IF 
                          #LET g_strong_err=g_strong_err+1 #強制訊息                  
                   #END IF 
                   #IF l_curnode.getAttribute("y") IS NOT NULL OR l_curnode.getAttribute("y")<>"" THEN
                          #LET l_msg="(強制)", l_nodename,"不應該設定y"
                          #IF l_msg IS NOT NULL THEN
                             #CALL l_strbuf.append(l_msg)
                             #CALL l_strbuf.append("\r\n")
                          #END IF 
                          #LET g_strong_err=g_strong_err+1 #強制訊息
                   #END IF                   
                #END IF 
            #END IF 
             #120608 國羽:先不用檢查單身----mark-e

            ### 分隔線檢查
            IF p_tagname="MINIPAGE"  THEN#or p_tagname="LAYOUTNODE"
                ## 表單中共有6條分隔線：
                ## 1. PageFooters 設 borderTopWidth 或 第一個 PageFooter 設 borderTopWidth
                ## 2. 第一個 PageFooter 設 borderBottomWidth
                ## 3. 最後一個 PageHeader 設 borderBottomWidth 
                ## 4. 第一個 DetailHeader 設 borderTopWidth 或 DetailHeaders 設 borderTopWidth
                ## 5. 第一個 ReportFooter 設 borderTopWidth 或 ReportFooters 設 borderTopWidth
                ## 6. 第一個 ReportFooter 設 borderBottomWidth
                
                IF l_curnode.getAttribute("name") IS NOT NULL THEN
                   LET l_BORDERWIDTH=1.5 #寬度1.5                   
                   LET l_bottonwidth=l_curnode.getAttribute("borderBottomWidth")
                   LET l_topwidth=l_curnode.getAttribute("borderTopWidth")
                   #第一、二條線 #
                   IF l_nodename.getIndexOf("PageFooter01",1)>0  THEN    
                      IF l_bottonwidth IS NULL THEN
                         LET l_msg=l_nodename,"PageFooter區段底部須有一條分隔線"
                         IF l_msg IS NOT NULL THEN
                            CALL l_strbuf.append(l_msg)
                            CALL l_strbuf.append("\r\n")
                         END IF                            
                      ELSE 
                          IF l_bottonwidth <> l_BORDERWIDTH THEN
                             LET l_msg=l_nodename,"線條寬度應為1.5"
                             IF l_msg IS NOT NULL THEN
                                CALL l_strbuf.append(l_msg)
                                CALL l_strbuf.append("\r\n")
                             END IF                              
                          END IF 
                      END IF 

                      IF l_topwidth IS NOT NULL THEN
                         IF l_topwidth <> l_BORDERWIDTH THEN
                             LET l_msg=l_nodename,"topwidth線條寬度應為1.5"
                             IF l_msg IS NOT NULL THEN
                                CALL l_strbuf.append(l_msg)
                                CALL l_strbuf.append("\r\n")
                             END IF                             
                         END IF 
                      ELSE 
                         LET l_par_topwidth=l_parent.getAttribute("borderTopWidth")
                         IF l_par_topwidth IS NOT NULL THEN 
                           IF l_par_topwidth<>l_BORDERWIDTH THEN
                             LET l_msg=l_nodename,"應設border - Top Width為1.5"
                             IF l_msg IS NOT NULL THEN
                                CALL l_strbuf.append(l_msg)
                                CALL l_strbuf.append("\r\n")
                             END IF                            
                           END IF 
                         ELSE 
                             LET l_msg="PageFooter區段頂端須有一條分隔線"
                             IF l_msg IS NOT NULL THEN
                                CALL l_strbuf.append(l_msg)
                                CALL l_strbuf.append("\r\n")
                             END IF                              
                         END IF  #IF l_par_topwidth IS NOT NULL 
                      END IF #l_topwidth IS NOT NULL
                   END IF  #l_nodename.getIndexOf("PageFooter01",1)>0

                   #第三條線
                   IF l_parent.getAttribute("name")="PageHeaderGroups" AND l_nodename.getIndexOf("PageHeader",1)>0 THEN
                      LET l_nextnode=l_curnode.getNext() #下一個節點
                      
                      IF l_nextnode IS NULL  THEN  #沒有下一個PageHeaderXX節點，即是最後一個節點                               
                         IF l_bottonwidth IS NOT NULL THEN 
                            IF l_bottonwidth <>  l_BORDERWIDTH THEN
                               LET l_msg=l_nodename," bottonwidth線條寬度應為1.5"
                               IF l_msg IS NOT NULL THEN
                                  CALL l_strbuf.append(l_msg)
                                  CALL l_strbuf.append("\r\n")
                               END IF                                
                            END IF 
                         ELSE 
                               LET l_msg=l_nodename,"區段底端須有一條分隔線"
                               IF l_msg IS NOT NULL THEN
                                  CALL l_strbuf.append(l_msg)
                                  CALL l_strbuf.append("\r\n")
                               END IF                                       
                         END IF #l_bottonwidth IS NOT NULL
                      ELSE
                          LET l_nextname=l_nextnode.getAttribute("name")
                          IF l_nextname.getIndexOf("PageHeader",1)=0 THEN
                             IF l_bottonwidth IS NOT NULL THEN 
                                IF l_bottonwidth <>  l_BORDERWIDTH THEN
                                   LET l_msg=l_nodename," bottonwidth線條寬度應為1.5"
                                   IF l_msg IS NOT NULL THEN
                                      CALL l_strbuf.append(l_msg)
                                      CALL l_strbuf.append("\r\n")
                                   END IF                                
                                END IF 
                             ELSE 
                                   LET l_msg=l_nodename,"區段底端須有一條分隔線"
                                   IF l_msg IS NOT NULL THEN
                                      CALL l_strbuf.append(l_msg)
                                      CALL l_strbuf.append("\r\n")
                                   END IF                                       
                             END IF #l_bottonwidth IS NOT NULL                  
                          END IF 
                      END IF  #l_nextnode IS NULL
                   END IF    #l_parent.getAttribute("name")="PageHeaderGroups
                   
                   #第四條
                   IF l_nodename.getIndexOf("DetailHeader01",1) THEN
                      IF l_topwidth IS NOT NULL  THEN
                         IF l_topwidth <> l_BORDERWIDTH THEN
                             LET l_msg=l_nodename,"topwidth線條寬度應為1.5"
                             IF l_msg IS NOT NULL THEN
                                CALL l_strbuf.append(l_msg)
                                CALL l_strbuf.append("\r\n")
                             END IF                            
                         END IF  
                      ELSE 
                          LET l_par_topwidth=l_parent.getAttribute("borderTopWidth")
                          IF l_par_topwidth IS NULL THEN
                             LET l_msg="DetailHeader區段頂端須有一條分隔線"
                             IF l_msg IS NOT NULL THEN
                                CALL l_strbuf.append(l_msg)
                                CALL l_strbuf.append("\r\n")
                             END IF                              
                          ELSE 
                             IF l_par_topwidth <> l_BORDERWIDTH THEN
                                 LET l_msg=l_nodename,"topwidth線條寬度應為1.5"
                                 IF l_msg IS NOT NULL THEN
                                    CALL l_strbuf.append(l_msg)
                                    CALL l_strbuf.append("\r\n")
                                 END IF                            
                             END IF                             
                          END IF  #IF l_par_topwidth IS NULL THEN
                      END IF   #l_topwidth IS NOT NULL
                   END IF   #l_nodename.getIndexOf("DetailHeader01",1)

                   #第五、六條
                   IF l_nodename.getIndexOf("ReportFooter01",1)>0  THEN    
                      IF l_bottonwidth IS NULL THEN
                         LET l_msg=l_nodename,"ReportFooter區段底部須有一條分隔線"
                         IF l_msg IS NOT NULL THEN
                            CALL l_strbuf.append(l_msg)
                            CALL l_strbuf.append("\r\n")
                         END IF                            
                      ELSE 
                          IF l_bottonwidth <> l_BORDERWIDTH THEN
                             LET l_msg=l_nodename,"線條寬度應為1.5"
                             IF l_msg IS NOT NULL THEN
                                CALL l_strbuf.append(l_msg)
                                CALL l_strbuf.append("\r\n")
                             END IF                              
                          END IF 
                      END IF 

                      IF l_topwidth IS NOT NULL THEN
                         IF l_topwidth <> l_BORDERWIDTH THEN
                             LET l_msg=l_nodename,"topwidth線條寬度應為1.5"
                             IF l_msg IS NOT NULL THEN
                                CALL l_strbuf.append(l_msg)
                                CALL l_strbuf.append("\r\n")
                             END IF                             
                         END IF 
                      ELSE 
                         LET l_par_topwidth=l_parent.getAttribute("borderTopWidth")
                         IF l_par_topwidth IS NOT NULL THEN 
                           IF l_par_topwidth<>l_BORDERWIDTH THEN
                             LET l_msg=l_nodename,"應設border - Top Width為1.5"
                             IF l_msg IS NOT NULL THEN
                                CALL l_strbuf.append(l_msg)
                                CALL l_strbuf.append("\r\n")
                             END IF                            
                           END IF 
                         ELSE 
                             LET l_msg="ReportFooter區段頂端須有一條分隔線"
                             IF l_msg IS NOT NULL THEN
                                CALL l_strbuf.append(l_msg)
                                CALL l_strbuf.append("\r\n")
                             END IF                              
                         END IF  #IF l_par_topwidth IS NOT NULL 
                      END IF #l_topwidth IS NOT NULL
                   END IF  #l_nodename.getIndexOf("ReportFooter01",1)>0
                   
                END IF     #l_curnode.getAttribute("name") IS NOT NULL     
               
            END IF  #
            

            
            ##MiniPage下元件若為欄位，name一定要設為"_Value"、"_Label"、"_LValue"
            IF l_parent.getAttribute("name")="MINIPAGE" AND 
              (p_tagname="WORDWRAPBOX" OR p_tagname="WORDBOX" OR 
               p_tagname="PAGENOBOX" OR p_tagname="IMAGEBOX" OR 
               p_tagname="HTMLBOX" OR p_tagname="DECIMALFORMATBOX") THEN           
               
               IF l_nodename.subString(l_nodename.getLength()-6+1,6) <> "_Value" AND 
                  l_nodename.subString(l_nodename.getLength()-6+1,6) <> "_Label" AND  
                  l_nodename.subString(l_nodename.getLength()-7+1,7) <> "_Label" THEN
                      LET l_msg="(強制)", l_nodename,"的名稱必須為_Value或_Label或_LValue結束"
                      IF l_msg IS NOT NULL THEN
                         CALL l_strbuf.append(l_msg)
                         CALL l_strbuf.append("\r\n")
                      END IF 
                      LET g_strong_err=g_strong_err+1 #強制訊息
               END IF 
            END IF  #

            
            ###繁體中文的標準字型為微軟正黑體；簡體中文的標準字型為黑体(SimHei)；其他語言別為Arial Unicode MS
            IF (p_tagname="WORDWRAPBOX" OR p_tagname="WORDBOX" OR 
               p_tagname="PAGENOBOX" OR p_tagname="HTMLBOX" OR 
               p_tagname="DECIMALFORMATBOX") AND p_gdm03<>"S" THEN #p_gdm03<>"S" src
               LET l_font=l_curnode.getAttribute("fontName")   
               CASE p_gdm03
                   WHEN "0" #繁中                             
                      IF l_font<>"微軟正黑體" AND l_font IS NOT NULL THEN 
                          LET l_msg=l_nodename,"字型設定錯誤，請設定為微軟正黑體"
                          IF l_msg IS NOT NULL THEN
                             CALL l_strbuf.append(l_msg)
                             CALL l_strbuf.append("\r\n")
                          END IF                         
                      END IF 
                   WHEN "2" #簡中
                      IF l_font<>"SimHei" AND l_font IS NOT NULL THEN 
                          LET l_msg=l_nodename,"字型設定錯誤，請設定為SimHei"
                          IF l_msg IS NOT NULL THEN
                             CALL l_strbuf.append(l_msg)
                             CALL l_strbuf.append("\r\n")
                          END IF                         
                      END IF                    
                   OTHERWISE #其他
                      IF l_font<>"Arial Unicode MS" AND l_font IS NOT NULL THEN 
                          LET l_msg=l_nodename,"字型設定錯誤，請設定為Arial Unicode MS"
                          IF l_msg IS NOT NULL THEN
                             CALL l_strbuf.append(l_msg)
                             CALL l_strbuf.append("\r\n")
                          END IF                         
                      END IF                     
               END CASE 
            END IF 

            ###Title1的字型大小為14，Title2的字型大小為12，以外內容的字型大小皆為9
            IF p_tagname="WORDWRAPBOX" OR p_tagname="WORDBOX" OR 
               p_tagname="PAGENOBOX" OR p_tagname="HTMLBOX" OR 
               p_tagname="DECIMALFORMATBOX" THEN
               LET l_font_size=l_curnode.getAttribute("fontSize")   
               IF l_nodename.getIndexOf("title1",1)>0 THEN
                  IF l_font_size<>"14" THEN
                     LET l_msg=l_nodename,"字體大小設定錯誤，請設定為14"
                     IF l_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_msg)
                        CALL l_strbuf.append("\r\n")
                     END IF                   
                  END IF 
               ELSE
                  IF l_nodename.getIndexOf("title2",1)>0 THEN
                      IF l_font_size<>"12" THEN
                         LET l_msg=l_nodename,"字體大小設定錯誤，請設定為12"
                         IF l_msg IS NOT NULL THEN
                            CALL l_strbuf.append(l_msg)
                            CALL l_strbuf.append("\r\n")
                         END IF                   
                      END IF                   
                  ELSE 
                      IF l_font_size<>"9" THEN
                         LET l_msg=l_nodename,"字體大小設定錯誤，請設定為9"
                         IF l_msg IS NOT NULL THEN
                            CALL l_strbuf.append(l_msg)
                            CALL l_strbuf.append("\r\n")
                         END IF                   
                      END IF                   
                  END IF 
               END IF 
            END IF 


            ###單頭欄位說明的字型為粗體
            IF p_tagname="WORDWRAPBOX" OR p_tagname="WORDBOX" OR 
               p_tagname="PAGENOBOX" OR p_tagname="HTMLBOX" OR 
               p_tagname="DECIMALFORMATBOX" THEN
               IF l_parname IS NOT NULL AND l_parname.getIndexOf("Master",1) AND l_nodename.getIndexOf("Label",1)>0 THEN
                  IF l_curnode.getAttribute("fontBold")<>"true" THEN
                     LET l_msg=l_nodename,"單頭欄位沒有設定字型為粗體"
                     IF l_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_msg)
                        CALL l_strbuf.append("\r\n")
                     END IF                      
                  END IF 
               END IF 
            END IF 


            ###公司 logo 的寬度與高度(X-Size, Y-Size) 不須設定(強制)
            ###公司 logo 左靠
            IF p_tagname ="IMAGEBOX" THEN
               IF l_nodename.getIndexOf("logo",1)>0 THEN
                  IF l_curnode.getAttribute("width") IS NOT NULL OR 
                     l_curnode.getAttribute("length") IS NOT NULL THEN
                     LET l_msg="(強制)", l_nodename,"報表logo不可設定高與寬屬性，否則圖片將變形，請修正。"
                     IF l_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_msg)
                        CALL l_strbuf.append("\r\n")
                     END IF  
                     LET g_strong_err=g_strong_err+1 #強制訊息
                  END IF 
                  LET l_set_y=l_curnode.getAttribute("y")
                  LET l_set_y=cl_replace_str(l_set_y,"cm","")
                  LET l_cur_value=l_set_y
                  IF l_cur_value IS NULL OR l_cur_value <> 0 THEN
                     LET l_msg="(強制)", l_nodename,"報表logo請設定為左靠(y=0cm)，請修正。"
                     IF l_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_msg)
                        CALL l_strbuf.append("\r\n")
                     END IF                  
                  END IF 
               END IF 
            END IF 


            
            ###單頭欄位說明與欄位間留 0.1cm 的空白，由橫軸座標屬性決定，不設定 magin 的 right width
            IF p_tagname ="MINIPAGE"  THEN 
                IF l_nodename.getIndexOf("Master",1)>0 AND (NOT l_nodename.equals("Masters")) THEN
                   FOR  l_ii=1 TO l_curnode.getChildCount()
                       LET l_childnode=l_curnode.getChildByIndex(l_ii)
                       LET l_childname= l_childnode.getAttribute("name")
                       LET l_childtag=l_childnode.getTagName()
                       IF l_childtag<>"rtl:input-variable" THEN  
                          LET l_chi_i=l_chi_i+1
                          LET l_chi_node[l_chi_i]=l_childnode
                       END IF                       
                   END FOR 
                      
                   LET l_totlength_new=0
                   FOR l_ii=1 TO l_chi_node.getLength()
                       LET l_childnode=l_chi_node[l_ii]
                       LET l_childname= l_childnode.getAttribute("name")
                       LET l_childtag=l_childnode.getTagName()                   
                       LET l_set_y=l_childnode.getAttribute("y")
                       LET l_y_value=cl_replace_str(l_set_y,"cm","")
                       LET l_set_width=l_childnode.getAttribute("width")
                       LET l_wid_value=cl_replace_str(l_set_width,"cm","")                   


                       IF l_childnode.getAttribute("marginRightWidth") IS NOT NULL THEN 
                          LET l_msg=l_childname,"單頭欄位右方不可透過Margin屬性來設定邊界"
                          IF l_msg IS NOT NULL THEN
                             CALL l_strbuf.append(l_msg)
                             CALL l_strbuf.append("\r\n")
                          END IF                        
                       ELSE 
                          IF l_set_y IS NOT NULL AND l_set_y.getIndexOf("max",1)>0 THEN 
                              LET l_msg=l_childname,"單頭欄位定位點不可透過max來定位，請以cm來定位"
                              IF l_msg IS NOT NULL THEN
                                 CALL l_strbuf.append(l_msg)
                                 CALL l_strbuf.append("\r\n")
                              END IF  
                          ELSE                            
                              IF l_wid_value IS NOT NULL THEN 
                                 IF l_ii>1 THEN 
                                     LET l_chi_prenode=l_chi_node[l_ii-1] #前一個子節點                              
                                     LET l_chi_prename=l_chi_prenode.getAttribute("name") #前一個子節點name值 
                                     LET l_pre_y=l_chi_prenode.getAttribute("y")
                                     LET l_pre_width=l_chi_prenode.getAttribute("width")
                                     LET l_pre_y_value=cl_replace_str(l_pre_y,"cm","")
                                     LET l_pre_width_value=cl_replace_str(l_pre_width,"cm","")
                                     IF l_ii=2 AND (l_pre_y_value IS NULL ) THEN LET l_pre_y_value=0 END IF   
                                     IF l_childname.getIndexOf("Label",1)= 0 AND  
                                        l_chi_prenode IS NOT NULL AND l_chi_prename.getIndexOf("Value",1)=0 THEN 
                                        IF l_y_value IS NULL THEN
                                           LET l_msg=l_childname,"單頭欄位定位點設定錯誤，請以cm為單位來定位及設定欄位寬度"
                                           IF l_msg IS NOT NULL THEN
                                              CALL l_strbuf.append(l_msg)
                                              CALL l_strbuf.append("\r\n")
                                           END IF
                                        ELSE
                                           LET l_totlength_new=l_y_value
                                            IF  l_pre_y IS NOT NULL THEN 
                                               IF (l_pre_y_value IS NULL AND l_ii-1 <>1)OR l_pre_width_value IS NULL  THEN 
                                                  LET l_msg=l_childname,"單頭欄位定位點設定錯誤，請以cm為單位來定位及設定欄位寬度"
                                                  IF l_msg IS NOT NULL THEN
                                                     CALL l_strbuf.append(l_msg)
                                                     CALL l_strbuf.append("\r\n")
                                                  END IF                                              
                                               ELSE  
                                                  LET l_totlength_old=l_pre_y_value+l_pre_width_value                            
                                               END IF  
                                            ELSE
                                                
                                                IF l_pre_width_value IS NULL THEN
                                                   LET l_msg=l_childname,"單頭欄位定位點設定錯誤，請以cm為單位來定位及設定欄位寬度"
                                                   IF l_msg IS NOT NULL THEN
                                                      CALL l_strbuf.append(l_msg)
                                                      CALL l_strbuf.append("\r\n")
                                                   END IF  
                                                ELSE 
                                                   LET l_totlength_old=l_pre_y_value+l_pre_width_value  
                                                   LET l_temp=l_totlength_new-l_totlength_old
                                                   LET l_temp=l_temp USING "&.&&"
                                                   #DISPLAY "l_temp:",l_temp
                                                   #DISPLAY "l_childname:",l_childname
                                                   #DISPLAY "l_chi_prename:",l_chi_prename
                                                   IF l_childname.getIndexOf("Value",1)>0 AND l_chi_prename.getIndexOf("Value",1)=0 AND l_temp <> 0.10 THEN 
                                                       LET l_msg=l_childname,"單頭欄位寬度或定位點設定錯誤，沒有與前一個欄位間隔0.1cm"
                                                       IF l_msg IS NOT NULL THEN
                                                          CALL l_strbuf.append(l_msg)
                                                          CALL l_strbuf.append("\r\n")
                                                       END IF                                          
                                                   END IF 
                                                END IF 
                                            END IF #l_ii>1 AND l_chi_prenode IS NOT NULL
                                        END IF  #IF l_y_value IS NULL

                                     

                                     END IF # l_childname.getIndexOf("Label",1)= 0 AND l_ii>=2 AND l_chi_prenode IS NOT NULL AND l_chi_prename.getIndexOf("Value",1)=0  
                                 END IF  #IF l_ii>1 THEN
                              END IF #l_wid_value IS NOT NULL


                              
                          END IF #l_set_y IS NOT NULL AND l_set_y.getIndexOf("max",1)>0
                       END IF #l_childnode.getAttribute("marginRightWidth") IS NOT NULL

                   END FOR #FOR l_ii=1 TO l_chi_node.getLength()
                END IF  #l_nodename.getIndexOf("Master",1)>0 AND l_nodename.getIndexOf("Masters",1)=0
            END IF  #p_tagname="MINIPAGE" 
            
            #FUN-CB0063 121114 by stellar ----(S)
            ##子報表的上層容器必為MiniPage 
            IF p_tagname = "rtl:call-report" THEN
               IF l_nodeurl.getIndexOf("subrep",1) > 0 THEN
                  IF l_parent.getTagName() <> 'MINIPAGE' THEN
                     LET l_msg="(強制)", l_nodeurl,"的上層容器必為MiniPage"
                     IF l_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_msg)
                        CALL l_strbuf.append("\r\n")
                     END IF 
                     LET g_strong_err=g_strong_err+1 #強制訊息
                  #FUN-CC0005 add -(s)
                  ELSE 
                      LET l_subrep_name=l_nodeurl.subString(l_nodeurl.getIndexOf("subrep",1),l_nodeurl.getIndexOf("subrep",1)+7)
                      IF l_parname.equals(l_subrep_name)=0 THEN
                         LET l_msg="(強制)", l_nodeurl,"的上層容器命名不正確"
                         IF l_msg IS NOT NULL THEN
                            CALL l_strbuf.append(l_msg)
                            CALL l_strbuf.append("\r\n")
                         END IF 
                         LET g_strong_err=g_strong_err+1 #強制訊息                         
                      END IF 
                  #FUN-CC0005 add -(e)
                  END IF

                  #FUN-CC0005 add -(s)
                   IF l_nodeurl.getIndexOf("/",1) > 0 THEN
                         LET l_msg="(強制)", l_nodeurl,"內容不能有/"
                         IF l_msg IS NOT NULL THEN
                            CALL l_strbuf.append(l_msg)
                            CALL l_strbuf.append("\r\n")
                         END IF 
                         LET g_strong_err=g_strong_err+1 #強制訊息  
                   END IF 
                  #FUN-CC0005 add -(e)
               END IF
                
            END IF
            #FUN-CB0063 121114 by stellar ----(E)

            #FUN-CB0059 add------(s)
            ## 不能有scaleX、scaleY 屬性
            IF (p_tagname="WORDWRAPBOX" OR p_tagname="WORDBOX" OR 
               p_tagname="PAGENOBOX" OR p_tagname="HTMLBOX" OR 
               p_tagname="DECIMALFORMATBOX") AND p_gdm03<>"S" THEN #p_gdm03<>"S" src
               LET l_scaleX = l_curnode.getAttribute("scaleX")
               LET l_scaleY = l_curnode.getAttribute("scaleY") 
               IF l_scaleX > 0 THEN
                     LET l_msg="(強制)", l_nodename,"不能設scaleX"
                     IF l_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_msg)
                        CALL l_strbuf.append("\r\n")
                     END IF 
                     LET g_strong_err=g_strong_err+1 #強制訊息
               END IF
               IF l_scaleY > 0 THEN
                     LET l_msg="(強制)", l_nodename,"不能設scaleY"
                     IF l_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_msg)
                        CALL l_strbuf.append("\r\n")
                     END IF 
                     LET g_strong_err=g_strong_err+1 #強制訊息
               END IF
            END IF 
            #FUN-CB0059 add ------(e)


            
        END FOR  #l_i=1 TO l_node.getLength()
   END IF  #IF l_node IS NOT NULL THEN 
   #新版------


       #將錯誤訊息附加到紀錄檢查命名規則錯誤的變數中
    IF l_strbuf.getLength() > 0 THEN
        IF g_chk_err_msg IS NULL THEN
            LET g_chk_err_msg = l_strbuf.toString()
        ELSE
            LET g_chk_err_msg = g_chk_err_msg,l_strbuf.toString()
        END IF
    END IF

     
END FUNCTION 

#FUN-C50046 -----end-----

#No.FUN-B40095
#FUN-C30008 將p_replang_get_lineno()及p_replang_get_seqno()
#合併為p_replang_getlinecol()

#FUN-C30008 --start-
#取出欄位所在行序及欄位順序
FUNCTION p_replang_getlinecol(p_node)
   DEFINE p_node        om.DomNode
   DEFINE x_node        om.DomNode #TEST
   DEFINE x_str         STRING  #TEST
   DEFINE l_parent      om.DomNode
   DEFINE l_seq         LIKE type_file.num5           #累計行序
   DEFINE l_line_seq    LIKE type_file.num5           #行序
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_curnode     om.DomNode
   DEFINE l_curname     STRING
   DEFINE la_parents    DYNAMIC ARRAY OF om.DomNode   #父節點
   DEFINE l_line_idx    LIKE type_file.num5           #行節點位置
   DEFINE l_col_seq     LIKE type_file.num5           #欄位順序
   DEFINE l_col_node    om.DomNode
   
   #找DetailHeaders,Details,Masters該層區段
   CALL la_parents.clear()
   LET la_parents = p_replang_getparents(p_node)
   IF la_parents.getLength() > 0 THEN
      LET l_parent = la_parents[la_parents.getLength()]
      IF la_parents.getLength() > 1 THEN
         LET l_line_idx = la_parents.getLength() - 1
      END IF
   END IF

   #FUN-CB0059 add -(s)
   IF l_line_idx=0 THEN
      RETURN 0,0 
   END IF 
   #FUN-CB0059 add -(e)
   LET l_seq = 0
   LET l_line_seq = 0
   LET l_col_seq = 0

   IF l_parent IS NOT NULL THEN
      #取得行序
      FOR l_i = 1 TO l_parent.getChildCount()
         LET l_curnode = l_parent.getChildByIndex(l_i)
         IF l_curnode.getTagName() = "MINIPAGE" 
            OR l_curnode.getTagName() = "LAYOUTNODE"
         THEN
            LET l_curname = l_curnode.getAttribute("name")
            CASE l_parent.getAttribute("name")
               WHEN "DetailHeaders" #單身欄位說明
                  IF l_curname.getIndexOf("DetailHeader",1) >= 1 THEN
                     LET l_seq = l_seq + 1
                  END IF
               WHEN "Details"       #單身
                  IF l_curname.getIndexOf("Detail",1) >= 1 THEN
                     LET l_seq = l_seq + 1
                  END IF
               WHEN "Masters"       #單頭
                  IF l_curname.getIndexOf("Master",1) >= 1 THEN
                     LET l_seq = l_seq + 1
                  END IF
            END CASE

            #找到該行離開迴圈
            IF l_curnode = la_parents[l_line_idx] THEN
               LET l_line_seq = l_seq
               EXIT FOR
            END IF
         END IF
      END FOR

      #單身需取得欄位順序

     #IF l_line_seq > 0 AND (l_parent.getAttribute("name") = "DetailHeaders" 
     #   OR l_parent.getAttribute("name") = "Details")
     #   AND la_parents[l_line_idx] IS NOT NULL
      IF l_line_seq > 0 AND l_parent.getAttribute("name") = "Details"
         AND la_parents[l_line_idx] IS NOT NULL
      THEN
       #TEST
         LET x_node = la_parents[l_line_idx]
         LET x_str = x_node.toString()
       #TEST
         LET l_seq = 0
         FOR l_i = 1 TO la_parents[l_line_idx].getChildCount()
            LET l_col_node = la_parents[l_line_idx].getChildByIndex(l_i)
               IF l_col_node.getTagName() = "WORDBOX"
                  OR l_col_node.getTagName() = "WORDWRAPBOX"
                  OR l_col_node.getTagName() = "DECIMALFORMATBOX"
                  OR l_col_node.getTagName() = "IMAGEBOX"   #FUN-C30288 
               THEN
                  LET l_seq = l_seq + 1
       #TEST
         LET x_node = l_col_node
         LET x_str = x_node.getAttribute("name")
       #TEST
                  IF l_col_node = p_node THEN               
                     LET l_col_seq = l_seq
                     EXIT FOR
                  END IF
               END IF
         END FOR
      END IF
   END IF
   
   RETURN l_line_seq,l_col_seq
END FUNCTION
#FUN-C30008 --end--

#取得需要與欄位一起搬移的變數節點 找此欄位前的rtl:input-variable 並記下，要一起搬移
FUNCTION p_replang_get_varnodes(p_node)
    DEFINE p_node       om.DomNode
    DEFINE l_parent     om.DomNode
    DEFINE l_nodes      DYNAMIC ARRAY OF om.DomNode
    DEFINE l_current    om.DomNode
    DEFINE l_i          LIKE type_file.num5
    DEFINE l_j          LIKE type_file.num5
    DEFINE l_str        STRING
    DEFINE l_varname    STRING

    CALL l_nodes.clear()
    LET l_parent = p_node.getParent() #父節點
    FOR l_i = 1 TO l_parent.getChildCount() #子節點數
        LET l_current = l_parent.getChildByIndex(l_i) #目前父節點的子節點index
        LET l_varname = l_current.getAttribute("name") #取得NAME屬性的名稱
        IF l_current.getTagName() = "rtl:input-variable" THEN #目前index的標籤名稱 若是rtl:input-variable
            FOR l_j = 1 TO p_node.getAttributesCount() #此節點屬性數
                LET l_str = p_node.getAttributeValue(l_j) #此節點在位置上的值
                IF l_str.getIndexOf("{{",1) > 0 AND l_str.getIndexOf(l_varname,1) > 0 THEN #若有找到{{或屬性名稱
                    CALL l_nodes.appendElement()   #增加元素
                    LET l_nodes[l_nodes.getLength()] = l_current  #將此父節點的子節點index放入陣列
                END IF
            END FOR
        END IF
    END FOR

    RETURN l_nodes
END FUNCTION

#取得單身或單頭欄位變更的目的行節點
FUNCTION p_replang_get_dstnode(p_node,p_lineno)
   DEFINE p_node        om.DomNode
   DEFINE p_lineno      LIKE type_file.num5
   DEFINE l_parent      om.DomNode
   DEFINE l_curnode     om.DomNode
   DEFINE l_i           LIKE type_file.num10
   DEFINE l_flag        LIKE type_file.num5
   #FUN-C30008 移除不使用變數
   DEFINE la_parents    DYNAMIC ARRAY OF om.DomNode   #父節點
   DEFINE l_nodeName    STRING
   DEFINE l_seq         LIKE type_file.num5           #FUN-C30008
   DEFINE l_result      om.DomNode                    #FUN-C30008

   LET  l_curnode = NULL
   LET l_flag = FALSE
   
   #FUN-C30008 --start--
   #找DetailHeaders,Details,Masters該層區段
   CALL la_parents.clear()
   LET la_parents = p_replang_getparents(p_node)
   IF la_parents.getLength() > 0 THEN
      LET l_parent = la_parents[la_parents.getLength()]
   END IF

   #有找到
   IF l_parent IS NOT NULL THEN
      LET l_seq = 0
      #搜尋該層所屬行的子節點
      FOR l_i = 1 TO l_parent.getChildCount()
         LET l_curnode = l_parent.getChildByIndex(l_i)
         IF l_curnode.getTagName() = "MINIPAGE"
            OR l_curnode.getTagName() = "LAYOUTNODE" 
         THEN
            LET l_nodeName = l_curnode.getAttribute("name")
            CASE l_parent.getAttribute("name")
               WHEN "DetailHeaders"
                  IF l_nodeName.getIndexOf("DetailHeader",1) >= 1 THEN
                     LET l_seq = l_seq + 1
                  END IF
               WHEN "Details"
                  IF l_nodeName.getIndexOf("Detail",1) >= 1 THEN
                     LET l_seq = l_seq + 1
                  END IF
               WHEN "Masters"
                  IF l_nodeName.getIndexOf("Master",1) >= 1 THEN
                     LET l_seq = l_seq + 1
                  END IF
            END CASE

            #有找到該行
            IF l_seq = p_lineno THEN
               LET l_result = l_curnode
               EXIT FOR
            END IF
         END IF
      END FOR
   END IF

   RETURN l_result
   #FUN-C30008 --end--
END FUNCTION

#取得變更的單身欄位目的節點
FUNCTION p_replang_get_seqnode(p_parent,p_seqno)
   DEFINE p_parent      om.DomNode           #FUN-C30008
   DEFINE p_seqno       LIKE type_file.num5
   DEFINE l_curnode     om.DomNode
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_resnode     om.DomNode
   DEFINE l_parent_name STRING               #FUN-C30008

   INITIALIZE l_resnode TO NULL
   
   IF p_parent IS NOT NULL AND p_seqno >= 1 THEN   #FUN-C30008
      LET l_cnt = 0
      LET l_parent_name = p_parent.getAttribute("name")
      FOR l_i = 1 TO p_parent.getChildCount()
         LET l_curnode = p_parent.getChildByIndex(l_i)
         IF l_curnode.getTagName() = "WORDBOX"
            OR l_curnode.getTagName() = "WORDWRAPBOX"
            OR l_curnode.getTagName() = "DECIMALFORMATBOX"
            OR l_curnode.getTagName() = "IMAGEBOX"  #FUN-C30008 #FUN-C30288
         THEN
            LET l_cnt = l_cnt + 1
            IF l_cnt = p_seqno THEN
                LET l_resnode = l_curnode
                EXIT FOR
            END IF
         END IF
       END FOR
    END IF  #FUN-C30008
    RETURN l_resnode
END FUNCTION

#設定顏色屬性
FUNCTION p_replang_setcolor(p_node,p_color)
    DEFINE p_node   om.DomNode
    DEFINE p_color  STRING
    DEFINE l_colval STRING

    IF p_color IS NOT NULL THEN
        CALL p_node.removeAttribute("color")
        IF p_color.getCharAt(1) = "#" THEN
            LET l_colval = p_color
        ELSE
            LET l_colval = p_color
        END IF
        CALL p_node.setAttribute("color",l_colval)
    END IF
END FUNCTION

#將資料欄位值Y|N轉為4RP屬性值true|false
FUNCTION p_replang_char2boolstr(p_val)
    DEFINE p_val    STRING
    DEFINE l_res    STRING

    INITIALIZE l_res TO NULL
    CASE p_val
        WHEN "Y"
            LET l_res = "true"
        WHEN "N"
            LET l_res = "false"
    END CASE
    RETURN l_res
END FUNCTION

#將4RP屬性值true|false轉為資料欄位值Y|N
FUNCTION p_replang_bool2char(p_val)
    DEFINE p_val STRING
    DEFINE l_str STRING

    INITIALIZE l_str TO NULL
    CASE
        WHEN p_val.equalsIgnoreCase("true")
            LET l_str = "Y"
        WHEN p_val.equalsIgnoreCase("false")
            LET l_str = "N"
        OTHERWISE
            LET l_str = "N"
    END CASE
    RETURN l_str
END FUNCTION

#將欄位轉換為折行或不折行
FUNCTION p_replang_convertwrap(p_node,p_iswrap)
    DEFINE p_node   om.DomNode
    DEFINE p_iswrap STRING
    DEFINE l_newtag STRING
    DEFINE l_parent om.DomNode
    DEFINE l_tmp    om.DomNode
    DEFINE l_i      LIKE type_file.num5

    INITIALIZE l_newtag TO NULL
    CASE p_iswrap
        WHEN "Y"
            IF p_node.getTagName() = "WORDBOX" THEN
                LET l_newtag = "WORDWRAPBOX"
            END IF
        WHEN "N"
            IF p_node.getTagName() = "WORDWRAPBOX" THEN
                LET l_newtag = "WORDBOX"
            END IF
    END CASE

    IF l_newtag IS NOT NULL THEN
        LET l_parent = p_node.getParent()
        LET l_tmp = l_parent.createChild(l_newtag)
        FOR l_i = 1 TO p_node.getAttributesCount()
            CALL l_tmp.setAttribute(p_node.getAttributeName(l_i),p_node.getAttributeValue(l_i))
        END FOR
        CALL l_parent.replaceChild(l_tmp,p_node)
    END IF
END FUNCTION

#移除定位點及寬度欄位等的長度單位
FUNCTION p_replang_rmunit(p_pos)
    DEFINE p_pos    STRING
    DEFINE l_strbuf base.StringBuffer
    DEFINE l_str    STRING
    DEFINE l_val    LIKE type_file.num15_3

    LET l_val = -1
    IF p_pos IS NOT NULL THEN
        IF p_pos.getIndexOf("cm",1) > 0 THEN
            LET l_strbuf = base.StringBuffer.create()
            CALL l_strbuf.append(p_pos)
            CALL l_strbuf.replace("cm","",0)
            LET l_str = l_strbuf.toString()
            LET l_val = l_str
        ELSE
            TRY
                LET l_val = p_pos
                LET l_val = l_val * 2.54 / 72
            CATCH
                LET l_val = -1
            END TRY
        END IF
    END IF
    RETURN l_val
END FUNCTION

#FUN-C20112 --start--
#讀出4rp中的資料欄位
#FUNCTION p_replang_readnodes(p_gdm,p_node,p_tagname,p_lang,p_gdm01)
FUNCTION p_replang_readnodes(p_gdm,p_node,p_tagname,p_lang,p_gdm01,p_code) #CHI-D30013 add p_code
    DEFINE p_code       LIKE type_file.chr1  #CHI-D30013
    DEFINE p_gdm        DYNAMIC ARRAY OF RECORD LIKE gdm_file.*
    DEFINE p_node       om.DomNode
    DEFINE p_tagname    STRING
    DEFINE p_lang       LIKE gdm_file.gdm03
    DEFINE p_gdm01      LIKE gdm_file.gdm01
    DEFINE l_nodes      om.NodeList
    DEFINE l_i          LIKE type_file.num10
    DEFINE l_j          LIKE type_file.num10
    DEFINE l_curnode    om.DomNode
    DEFINE l_parent     om.DomNode
    DEFINE l_nodename   STRING
    DEFINE l_colname    STRING
    DEFINE l_tagtype    LIKE type_file.chr1
    DEFINE l_index      LIKE type_file.num10
    DEFINE l_exist      LIKE type_file.num5
    DEFINE l_node2      om.DomNode              #FUN-C10044
    DEFINE l_k          LIKE type_file.num10    #FUN-C10044
    DEFINE l_node3      om.DomNode              #FUN-C10044
    DEFINE l_cmpname    STRING                  #FUN-C10044
    DEFINE l_err_msg    STRING                  #FUN-C10044 #錯誤訊息
    DEFINE l_strbuf     base.StringBuffer       #FUN-C10044 #組錯誤訊息的字串緩衝區
    DEFINE l_prev       LIKE type_file.num10    #FUN-C10044 #前一個_Label位置
    DEFINE l_flag       LIKE type_file.num10    #FUN-C10044 #找到成對的_Label與_Value
    DEFINE l_align      STRING                  #FUN-C30008 add
    DEFINE l_line_seq   LIKE type_file.num5     #FUN-C30008 #行序
    DEFINE l_col_seq    LIKE type_file.num5     #FUN-C30008 #欄位順序

    LET l_strbuf = base.StringBuffer.create()
    LET l_nodes = p_node.selectByTagName(p_tagname)
    FOR l_i = 1 TO l_nodes.getLength()
        LET l_colname = NULL #CHI-D30013
        LET l_align = NULL
        LET l_curnode = l_nodes.item(l_i)
        LET l_nodename = l_curnode.getAttribute("name")
        LET l_parent = l_curnode.getParent()

        #FUN-C10044 --start--
        #若為IMAGEBOX物件時，限定名稱為logo_Value才處理
        IF p_tagname = "IMAGEBOX" AND l_nodename != "logo_Value" THEN
            CONTINUE FOR
        END IF
        #FUN-C10044 --end--

    #CHI-D30013 modify-------------------(S)
      # #取得欄位類別
      # CASE
      #     WHEN l_nodename.getIndexOf("_Label",1) > 0  #欄位說明
      #         LET l_tagtype = "L"
      #         LET l_colname = cl_replace_str(l_nodename,"_Label","")
      #     WHEN l_nodename.getIndexOf("_Value",1) > 0  #欄位
      #         LET l_tagtype = "V"
      #         LET l_colname = cl_replace_str(l_nodename,"_Value","")
      #     #FUN-C10044 --start--
      #     WHEN l_nodename.getIndexOf("_LValue",1) > 0  #動態欄位說明
      #         LET l_tagtype = "L"
      #         LET l_colname = cl_replace_str(l_nodename,"_LValue","")
      #     #FUN-C10044 --end--
      #     OTHERWISE                                   #其他
      #         LET l_colname =  l_nodename
      #         LET l_tagtype = "V"
      # END CASE
  
        IF p_code = '1' THEN #for Value & LValue
           CASE
               WHEN l_nodename.getIndexOf("_Value",1) > 0  #欄位
                   LET l_tagtype = "V"
                   LET l_colname = cl_replace_str(l_nodename,"_Value","")
               WHEN l_nodename.getIndexOf("_LValue",1) > 0  #動態欄位說明
                   LET l_tagtype = "L"
                   LET l_colname = cl_replace_str(l_nodename,"_LValue","")
           END CASE
        ELSE                 #for Label
           CASE
               WHEN l_nodename.getIndexOf("_Label",1) > 0  #欄位
                   LET l_tagtype = "L"
                   LET l_colname = cl_replace_str(l_nodename,"_Label","")
           END CASE
        END IF
        IF cl_null(l_colname) THEN CONTINUE FOR END IF
      #CHI-D30013 modify-------------------(E)

        #尋找p_gdm中是否已有相同欄位名稱的資料
        LET l_index = 0
        LET l_exist = FALSE
        FOR l_j = 1 TO p_gdm.getLength()
            IF p_gdm[l_j].gdm04 = l_colname THEN
                LET l_index = l_j
                LET l_exist = TRUE
                EXIT FOR
            END IF
        END FOR

        #在p_gdm中未找到,新增一筆
        IF l_index <= 0 THEN
            CALL p_gdm.appendElement()
            LET l_index = p_gdm.getLength()

            LET p_gdm[l_index].gdm01 = p_gdm01  #FUN-C20112
            LET p_gdm[l_index].gdm02 = l_index
            LET p_gdm[l_index].gdm03 = p_lang
            LET p_gdm[l_index].gdm06 = "G"  #欄位屬性

            #FUN-C30008 --start--
            LET p_gdm[l_index].gdm24 = "L" #欄位水平對齊
            LET p_gdm[l_index].gdm25 = "L" #欄位說明水平對齊
            #FUN-C30008 --end--

            #取欄位名稱
            LET p_gdm[l_index].gdm04 = l_colname  #欄位代碼

            #取欄位屬性
            LET p_gdm[l_index].gdm05 = p_replang_get_category(l_curnode) #欄位類別

            #取行序
            IF p_gdm[l_index].gdm05 MATCHES "[12]" THEN
                #FUN-C30008 --start--
                #LET p_gdm[l_index].gdm09 = p_replang_get_lineno(l_curnode) #mark
                CALL p_replang_getlinecol(l_curnode)
                  RETURNING l_line_seq, l_col_seq
                IF l_line_seq <> 0 AND l_col_seq <> 0 THEN   #FUN-CB0059 add
                  LET p_gdm[l_index].gdm09 = l_line_seq
                END IF                                       #FUN-CB0059 add 
                #FUN-C30008 --end--
            END IF

            #取單身欄位順序
            IF p_gdm[l_index].gdm05 = "2" THEN
                #LET p_gdm[l_index].gdm10 = p_replang_get_seqno(l_curnode) #FUN-C30008 mark
                IF l_line_seq <> 0 AND l_col_seq <> 0 THEN   #FUN-CB0059 add
                  LET p_gdm[l_index].gdm10 = l_col_seq  #FUN-C30008
                END IF                                       #FUN-CB0059 add   
            END IF

            #設定折行否
            IF l_curnode.getTagName() = "WORDWRAPBOX" THEN
                LET p_gdm[l_index].gdm20 = "Y"
            ELSE
                LET p_gdm[l_index].gdm20 = "N"
            END IF

            #設定隱藏否
            CASE l_curnode.getAttribute("rtl:condition")
                WHEN "Boolean.FALSE" LET p_gdm[l_index].gdm21 = "Y"
                WHEN "Boolean.TRUE" LET p_gdm[l_index].gdm21 = "N"
                OTHERWISE LET p_gdm[l_index].gdm21 = "N"  
            END CASE
            #FUN-C40034  ADD-START---
             IF l_tagtype="L" THEN 
                LET p_gdm[l_index].gdm27=l_curnode.getAttribute("rtl:condition")
             END IF 
             IF l_tagtype="V" THEN 
                LET p_gdm[l_index].gdm26=l_curnode.getAttribute("rtl:condition")
             END IF                   
             #FUN-C40034  ADD-END  
         END IF 
          
        CASE p_replang_has_label(p_node,p_gdm[l_index].gdm04)
            WHEN "Y" LET p_gdm[l_index].gdm22 = "N"
            WHEN "N" LET p_gdm[l_index].gdm22 = "Y"
        END CASE

        #FUN-C30008 --start--
        #取行序跟單身欄位順序
        IF p_gdm[l_index].gdm05 MATCHES "[12]" THEN
            IF p_gdm[l_index].gdm09 IS NULL THEN
               CALL p_replang_getlinecol(l_curnode)
                  RETURNING l_line_seq, l_col_seq
               IF l_line_seq <> 0 AND l_col_seq <> 0 THEN   #FUN-CB0059  add 
                 LET p_gdm[l_index].gdm09 = l_line_seq
               END IF                                       #FUN-CB0059  add 
            END IF
            IF p_gdm[l_index].gdm05 = "2" AND p_gdm[l_index].gdm10 IS NULL THEN
              IF l_line_seq <> 0 AND l_col_seq <> 0 THEN   #FUN-CB0059  add 
               LET p_gdm[l_index].gdm10 = l_col_seq
              END IF                                       #FUN-CB0059  add  
            END IF
        END IF


        CASE l_tagtype
            WHEN "L"    #欄位說明
                #單頭需設定定位點
                IF p_gdm[l_index].gdm05 MATCHES "[1345]" THEN #FUN-C10044 add gdm05=3,4,5
                    LET p_gdm[l_index].gdm07 = p_replang_rmunit(l_curnode.getAttribute("y"))
                END IF
                LET p_gdm[l_index].gdm15 = p_replang_rmunit(l_curnode.getAttribute("width"))
                LET p_gdm[l_index].gdm16 = l_curnode.getAttribute("fontName")
                LET p_gdm[l_index].gdm17 = l_curnode.getAttribute("fontSize")
                LET p_gdm[l_index].gdm18 = p_replang_bool2char(l_curnode.getAttribute("fontBold"))
                LET p_gdm[l_index].gdm19 = l_curnode.getAttribute("color")
                LET p_gdm[l_index].gdm23 = l_curnode.getAttribute("text")  #FUN-C20112 add
                LET p_gdm[l_index].gdm27 = l_curnode.getAttribute("rtl:condition")  ##FUN-C50046 ADD janet 120530
                
                #FUN-C30008 --start--
                LET l_align = p_replang_getalign(l_curnode.getAttribute("textAlignment"))   
                IF l_align IS NOT NULL THEN
                    LET p_gdm[l_index].gdm25 = l_align
                END IF
                #FUN-C30008 --end--
            WHEN "V"    #欄位
                #FUN-C30008 --start--
                #取行序
                #IF p_gdm[l_index].gdm05 MATCHES "[12]" THEN
                #    LET p_gdm[l_index].gdm09 = p_replang_get_lineno(l_curnode)
                #END IF
                #FUN-C30008 --end--
                LET p_gdm[l_index].gdm08 = p_replang_rmunit(l_curnode.getAttribute("width"))
                LET p_gdm[l_index].gdm11 = l_curnode.getAttribute("fontName")
                LET p_gdm[l_index].gdm12 = l_curnode.getAttribute("fontSize")
                LET p_gdm[l_index].gdm13 = p_replang_bool2char(l_curnode.getAttribute("fontBold"))
                LET p_gdm[l_index].gdm14 = l_curnode.getAttribute("color")
                LET p_gdm[l_index].gdm26 = l_curnode.getAttribute("rtl:condition")  ##FUN-C50046 ADD janet 120530
                #FUN-C30008 --start--
                LET l_align = p_replang_getalign(l_curnode.getAttribute("textAlignment"))   
                IF l_align IS NOT NULL THEN
                    LET p_gdm[l_index].gdm24 = l_align
                END IF
                #FUN-C30008 --start--

                IF (p_gdm[l_index].gdm05 MATCHES "[1345]") AND p_gdm[l_index].gdm22 = "Y" THEN #FUN-C10044 add gdm05=3,4,5
                    LET p_gdm[l_index].gdm07 = p_replang_rmunit(l_curnode.getAttribute("y"))
                END IF
        END CASE

        IF p_gdm[l_index].gdm13 IS NULL THEN
            LET p_gdm[l_index].gdm13 = "N"
        END IF

        IF p_gdm[l_index].gdm18 IS NULL THEN
            LET p_gdm[l_index].gdm18 = "N"
        END IF

        #FUN-C10044 --start--
        #檢查命名規則
        CASE 
            WHEN p_gdm[l_index].gdm05 = "1"
                IF l_nodename.getIndexOf("_Label",1) <= 0 AND
                    l_nodename.getIndexOf("_Value",1) <= 0 
                    AND l_nodename.getIndexOf("_LValue",1) <= 0 #FUN-C50046 add
                    AND l_nodename.getIndexOf("Mspacer",1) <= 0        #FUN-CC0005 add
                THEN
                    LET l_err_msg = cl_getmsg_parm("azz1192", g_lang, l_nodename)
                    IF l_err_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_err_msg)
                        CALL l_strbuf.append("\r\n")
                    END IF
                END IF

                #檢查單身欄位說明與欄位值是否相連
                IF l_nodename.getIndexOf("_Value",1) >= 1 THEN
                    LET l_prev = 0
                    LET l_flag = FALSE
                    FOR l_j = 1 TO l_parent.getChildCount()
                        LET l_node2 = l_parent.getChildByIndex(l_j)
                        IF l_node2 = l_curnode THEN
                            FOR l_k = l_j - 1 TO 1 STEP -1
                                LET l_node3 = l_parent.getChildByIndex(l_k)
                                IF l_node3.getTagName() = "WORDBOX" OR l_node3.getTagName() = "WORDWRAPBOX" THEN
                                    LET l_prev = l_prev + 1
                                    LET l_cmpname = l_node3.getAttribute("name")
                                    IF l_cmpname = l_colname||"_Label" THEN
                                        LET l_flag = TRUE
                                        EXIT FOR
                                    END IF
                                END IF
                            END FOR
                        END IF
                    END FOR 
                END IF

                IF l_flag AND l_prev > 1 THEN
                    LET l_err_msg = cl_getmsg_parm("azz1192", g_lang, l_nodename)
                    IF l_err_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_err_msg)
                        CALL l_strbuf.append("\r\n")
                    END IF
                END IF
            WHEN p_gdm[l_index].gdm05 = "2"
                IF l_nodename.getIndexOf("_Label",1) <= 0 AND
                    l_nodename.getIndexOf("_Value",1) <= 0 AND
                    l_nodename.getIndexOf("_LValue",1) <= 0 AND
                    l_nodename.getIndexOf("DHspacer",1) <= 0 AND
                    l_nodename.getIndexOf("Dspacer",1) <= 0 AND 
                    l_nodename.getIndexOf("GFspacer",1) <= 0 AND   #FUN-CB0059 add
                    l_nodename.getIndexOf("Fspacer",1) <= 0 AND    #FUN-CB0059 add
                    l_nodename.getIndexOf("GHspacer",1) <= 0    #FUN-CB0059 add                    
                THEN
                    LET l_err_msg = cl_getmsg_parm("azz1192", g_lang, l_nodename)
                    IF l_err_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_err_msg)
                        CALL l_strbuf.append("\r\n")
                    END IF
                END IF
            OTHERWISE
                IF l_nodename.getIndexOf("_Label",1) <= 0 AND
                    l_nodename.getIndexOf("_Value",1) <= 0 AND 
                    l_nodename.getIndexOf("DHspacer",1) <= 0 AND    #FUN-CB0059 add
                    l_nodename.getIndexOf("Dspacer",1) <= 0 AND     #FUN-CB0059 add
                    l_nodename.getIndexOf("GFspacer",1) <= 0 AND   #FUN-CB0059 add
                    l_nodename.getIndexOf("Fspacer",1) <= 0 AND    #FUN-CB0059 add
                    l_nodename.getIndexOf("GHspacer",1) <= 0     #FUN-CB0059 add
                                        
                THEN
                    LET l_err_msg = cl_getmsg_parm("azz1192", g_lang, l_nodename)
                    IF l_err_msg IS NOT NULL THEN
                        CALL l_strbuf.append(l_err_msg)
                        CALL l_strbuf.append("\r\n")
                    END IF
                END IF
        END CASE
        #FUN-C10044 --end--
    END FOR
    #FUN-C10044 --start--
    #將錯誤訊息附加到紀錄檢查命名規則錯誤的變數中
    IF l_strbuf.getLength() > 0 THEN
        IF g_chk_err_msg IS NULL THEN
            LET g_chk_err_msg = l_strbuf.toString()
        ELSE
            LET g_chk_err_msg = g_chk_err_msg,l_strbuf.toString()
        END IF
    END IF
    #FUN-C10044 --end--
END FUNCTION

#檢查欄位是否有欄位說明
FUNCTION p_replang_has_label(p_node,p_name)
    DEFINE p_node   om.DomNode
    DEFINE p_name   STRING
    DEFINE l_nodes  om.NodeList
    DEFINE l_len    LIKE type_file.num5
    DEFINE l_str    STRING
    DEFINE l_res    STRING

    LET l_str = "//WORDWRAPBOX[@name=\""||p_name.trim()||"_Label\"]"
    LET l_nodes = p_node.selectByPath(l_str)
    LET l_len = l_nodes.getLength()

    IF l_len <= 0 THEN
        LET l_str = "//WORDBOX[@name=\""||p_name.trim()||"_Label\"]"
        LET l_nodes = p_node.selectByPath(l_str)
        LET l_len = l_nodes.getLength()
    END IF

    IF l_len >= 1 THEN
        LET l_res = "Y"
    ELSE
        LET l_res = "N"
    END IF
    RETURN l_res
END FUNCTION

#取得欄位類別(1:單頭,2:單身,3:其他,4:群組首,5:群組尾) #FUN-C30288
FUNCTION p_replang_get_category(p_node)
   DEFINE p_node        om.DomNode
   DEFINE l_parent      om.DomNode
   #FUN-C30008 移除未使用變數
   DEFINE l_res         STRING
   DEFINE l_name        STRING      #FUN-C30288

   #FUN-C30008 --start--
   LET l_res = "3"
   
   #找DetailHeaders,Details,Masters該層區段
   LET l_parent = p_node.getParent()
   WHILE TRUE
      IF l_parent IS NULL THEN
         EXIT WHILE
      END IF
      
      CASE l_parent.getAttribute("name")
         WHEN "DetailHeaders"
            LET l_res = "2"
            EXIT WHILE
         WHEN "Details"
            LET l_res = "2"
            EXIT WHILE
         WHEN "Masters"
            LET l_res = "1"
            EXIT WHILE
         #FUN-C30288 --start--
         #WHEN "GroupHeader"
         #   LET l_res = "4"
         #   EXIT WHILE
         #WHEN "GroupFooter"
         #   LET l_res = "5"
         #   EXIT WHILE
         OTHERWISE
            LET l_name = l_parent.getAttribute("name")
            CASE 
               WHEN l_name.getIndexOf("GroupHeader",1) > 0  #群組首
                  LET l_res = "4"
                  EXIT WHILE
               WHEN l_name.getIndexOf("GroupFooter",1) > 0  #群組尾
                  LET l_res = "5"
                  EXIT WHILE
            END CASE
         #FUN-C30288 --end--
      END CASE

      LET l_parent = l_parent.getParent()
   END WHILE

   #FUN-C30008 --end--
   RETURN l_res
END FUNCTION

#取RECORD member的名稱
FUNCTION p_replang_getcolname(p_name)
    DEFINE p_name   STRING
    DEFINE l_name   STRING
    DEFINE l_pos1   LIKE type_file.num10
    DEFINE l_pos2   LIKE type_file.num10
    DEFINE l_i      LIKE type_file.num10

    INITIALIZE l_name TO NULL
    IF p_name IS NOT NULL THEN
        LET l_pos1 = p_name.getIndexOf("_Label",1) - 1
        IF l_pos1 <= 0 THEN
            LET l_pos1 = p_name.getLength()
        END IF

        LET l_pos2 = -1
        FOR l_i = p_name.getLength() TO 1 STEP -1
            IF p_name.getCharAt(l_i) = '.' THEN
                LET l_pos2 = l_i
                EXIT FOR
            END IF
        END FOR
        IF l_pos2 > 0 AND l_pos1 > l_pos2 THEN
            LET l_name = p_name.subString(l_pos2 + 1,l_pos1)
        ELSE
            LET l_name = p_name
        END IF
    END IF
    RETURN l_name
END FUNCTION
#FUN-C20112 --end--

#FUN-C50046 -start--------
FUNCTION p_replang_chk_grule(ps_4rppath,p_gdm01,p_gdm03)
   DEFINE ps_4rppath STRING                                    #4rp路徑
   DEFINE p_gdm01    LIKE gdm_file.gdm01                       #報表樣板ID
   DEFINE p_gdm03    LIKE gdm_file.gdm03                       #語言別
   DEFINE la_gdm     DYNAMIC ARRAY OF RECORD LIKE gdm_file.*
   DEFINE l_doc      om.DomDocument
   DEFINE l_rootnode om.DomNode
   DEFINE ls_msg     STRING
   DEFINE ls_errcnt  INTEGER 
 

   IF cl_null(ps_4rppath) OR cl_null(p_gdm01) OR cl_null(p_gdm03) THEN
      CALL cl_err("","lib-521",0)
      RETURN
   END IF

   IF NOT os.Path.exists(ps_4rppath) THEN
      LET ls_msg = "(path: ",ps_4rppath.trim(),")"
      CALL cl_err(ls_msg,"azz-056",0)
      RETURN
   END IF
    
   CALL la_gdm.clear()     #初始化陣列
   
   LET g_chk_err_msg = NULL

   #將4rp欄位屬性讀入陣列
   LET l_doc = om.DomDocument.createFromXmlFile(ps_4rppath)
   LET l_rootnode = l_doc.getDocumentElement()


   #FUN-C50046 add--START
   #檢查GR所有規範
   LET g_strong_err=0
   #CALL p_replang_remove_node(ps_4rppath) #不移除rtl:input-variable
   CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"WORDWRAPBOX")   #OK
   CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"WORDBOX")     #OK
   CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"DECIMALFORMATBOX")  
   CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"PAGENOBOX")  
   CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"IMAGEBOX")  
   CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"MINIPAGE")  
   CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"LAYOUTNODE")   #SOK
   CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"rtl:call-report")   #FUN-CB0063 121114 by stellar
   #IF g_strong_err>0 THEN 
       #顯示檢查命名規則的錯誤訊息
       #IF g_chk_err_msg IS NOT NULL THEN
          #CALL cl_err(g_chk_err_msg,"!",-1)
       #END IF     
   #END IF 
   LET ls_msg=g_chk_err_msg
   LET ls_errcnt=g_strong_err
   RETURN ls_errcnt,ls_msg
END FUNCTION 
#FUN-C50046---end-----

#FUN-C30008 --start--
#將p_replang rescan(重新掃描4rp)共用function搬到共用區
FUNCTION p_replang_rescan4rp(ps_4rppath,p_gdm01,p_gdm03)
   DEFINE ps_4rppath STRING                                    #4rp路徑
   DEFINE p_gdm01    LIKE gdm_file.gdm01                       #報表樣板ID
   DEFINE p_gdm03    LIKE gdm_file.gdm03                       #語言別
   DEFINE la_gdm     DYNAMIC ARRAY OF RECORD LIKE gdm_file.*
   DEFINE l_doc      om.DomDocument
   DEFINE l_rootnode om.DomNode
   DEFINE ls_msg     STRING
   DEFINE l_cust_path STRING   #FUN-CC0081 add

   IF cl_null(ps_4rppath) OR cl_null(p_gdm01) OR cl_null(p_gdm03) THEN
      CALL cl_err("","lib-521",0)
      RETURN
   END IF

   IF NOT os.Path.exists(ps_4rppath) THEN
      LET ls_msg = "(path: ",ps_4rppath.trim(),")"
      CALL cl_err(ls_msg,"azz-056",0)
      RETURN
   END IF

   
   LET l_cust_path=fgl_getenv("CUST")#抓路徑  #FUN-CC0081 add
   

    
       CALL la_gdm.clear()     #初始化陣列
       
       LET g_chk_err_msg = NULL

       #將4rp欄位屬性讀入陣列
       LET l_doc = om.DomDocument.createFromXmlFile(ps_4rppath)
       LET l_rootnode = l_doc.getDocumentElement()

          
       #CHI-D30013 modify----------------------(S)
         # CALL p_replang_readnodes(la_gdm,l_rootnode,"WORDBOX",p_gdm03,p_gdm01)
         # CALL p_replang_readnodes(la_gdm,l_rootnode,"WORDWRAPBOX",p_gdm03,p_gdm01)
         # CALL p_replang_readnodes(la_gdm,l_rootnode,"DECIMALFORMATBOX",p_gdm03,p_gdm01)
         # CALL p_replang_readnodes(la_gdm,l_rootnode,"PAGENOBOX",p_gdm03,p_gdm01)
         # CALL p_replang_readnodes(la_gdm,l_rootnode,"IMAGEBOX",p_gdm03,p_gdm01)
           CALL p_replang_readnodes(la_gdm,l_rootnode,"WORDBOX",p_gdm03,p_gdm01,'1')
           CALL p_replang_readnodes(la_gdm,l_rootnode,"WORDBOX",p_gdm03,p_gdm01,'2')
           CALL p_replang_readnodes(la_gdm,l_rootnode,"WORDWRAPBOX",p_gdm03,p_gdm01,'1')
           CALL p_replang_readnodes(la_gdm,l_rootnode,"WORDWRAPBOX",p_gdm03,p_gdm01,'2')
           CALL p_replang_readnodes(la_gdm,l_rootnode,"DECIMALFORMATBOX",p_gdm03,p_gdm01,'1')
           CALL p_replang_readnodes(la_gdm,l_rootnode,"DECIMALFORMATBOX",p_gdm03,p_gdm01,'2')
           CALL p_replang_readnodes(la_gdm,l_rootnode,"PAGENOBOX",p_gdm03,p_gdm01,'1')
           CALL p_replang_readnodes(la_gdm,l_rootnode,"PAGENOBOX",p_gdm03,p_gdm01,'2')
           CALL p_replang_readnodes(la_gdm,l_rootnode,"IMAGEBOX",p_gdm03,p_gdm01,'1')
           CALL p_replang_readnodes(la_gdm,l_rootnode,"IMAGEBOX",p_gdm03,p_gdm01,'2')
       #CHI-D30013 modify----------------------(E)

           IF ps_4rppath.getIndexOf(l_cust_path,1)=0 THEN  #FUN-CC0081 add #客製不作檢查
               #FUN-CB0059 add--(s)    
               CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"WORDWRAPBOX")   
               CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"WORDBOX")     
               CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"DECIMALFORMATBOX")  
               CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"PAGENOBOX")  
               CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"IMAGEBOX")  
               CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"MINIPAGE")  
               CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"LAYOUTNODE")   
               CALL p_replang_chkrule(p_gdm01,p_gdm03,l_rootnode,"rtl:call-report")   #FUN-CB0063 add
               #FUN-CB0059 add--(e)   
               
               #顯示檢查命名規則的錯誤訊息
               IF g_chk_err_msg IS NOT NULL THEN
                  #CALL cl_err(g_chk_err_msg,"!",-1)          #FUN-CC0005 mark
                  CALL cl_err_msg(g_chk_err_msg,"!",NULL,-1)  #FUN-CC0005 add
               END IF
            
           END IF #FUN-CC0081 add
       CALL p_replang_updgdm(la_gdm,p_gdm01,p_gdm03)

END FUNCTION

FUNCTION p_replang_remove_node(l_path)
   DEFINE l_path       STRING   #目的檔案路徑
   DEFINE l_cmd,l_read_str STRING
   DEFINE lc_chin          base.Channel
   DEFINE lc_chout         base.Channel
   DEFINE lr_str         DYNAMIC ARRAY OF STRING  
   DEFINE l_i ,i             LIKE type_file.num5 

    
      #讀檔
      LET l_cmd = l_path      
      DISPLAY l_cmd
      LET lc_chin = base.Channel.create() #create new 物件
      CALL lc_chin.openFile(l_cmd,"r") #開啟檔案
      LET l_i=1

      WHILE TRUE   
             LET l_read_str =lc_chin.readLine() #整行讀入
             IF  l_read_str.getIndexOf("rtl:input-variable",1)=0 THEN  #沒有rtl:input-variable才存
               LET lr_str[l_i] =l_read_str #讀取資料後存入tmp中
               IF lc_chin.isEof() THEN EXIT WHILE END IF     #判斷是否為最後         
               LET l_i = l_i + 1
             END IF 
      END WHILE
      CALL lc_chin.close()  

      #寫檔	 

      LET lc_chout = base.Channel.create()
      CALL lc_chout.openFile(l_cmd,"w")
      
      FOR i = 1 TO lr_str.getLength()
	    	 CALL lc_chout.writeLine(lr_str[i])
      END FOR	 
      CALL lc_chout.close()    
END FUNCTION  



#將4rp欄位屬性寫入DB的gdm_file(先刪除後新增)
FUNCTION p_replang_updgdm(pa_gdm,p_gdm01,p_gdm03)
   DEFINE pa_gdm     DYNAMIC ARRAY OF RECORD LIKE gdm_file.*
   DEFINE p_gdm01    LIKE gdm_file.gdm01                       #報表樣板ID
   DEFINE p_gdm03    LIKE gdm_file.gdm03                       #語言別
   DEFINE li_i       LIKE type_file.num5
   DEFINE ls_colname STRING                                    #處理過的欄位名稱
   DEFINE ls_errmsg  STRING
   DEFINE ls_coldesc STRING
   
   WHENEVER ERROR CALL cl_err_msg_log #TQC-C50068
   LET ls_errmsg = "" 
   
   #刪除對應報表樣板ID的語言別資料
   DELETE FROM gdm_file WHERE gdm01 = p_gdm01 AND gdm03 = p_gdm03
   IF SQLCA.SQLCODE THEN
      LET ls_errmsg = ls_errmsg,SQLCA.SQLCODE," '",
                      pa_gdm[li_i].gdm04 CLIPPED,"' ",
                      cl_getmsg(SQLCA.SQLCODE,g_lang),"\n"
   END IF


   #TQC-C50068 -------------------------------(S)
   FOR li_i = pa_gdm.getLength() TO 1 STEP -1
       IF cl_null(pa_gdm[li_i].gdm02) THEN 
          CALL pa_gdm.deleteElement(li_i)
       END IF
   END FOR
   #TQC-C50068 -------------------------------(E)
   #將la_upd_gdm陣列更新到資料庫
   FOR li_i = 1 TO pa_gdm.getLength()    
      IF cl_null(pa_gdm[li_i].gdm02) THEN CONTINUE FOR END IF #TQC-C50068 
      #若4rp的多欄位說明為空白時自動取得翻譯的說明內容
      IF cl_null(pa_gdm[li_i].gdm23) THEN
         LET ls_colname = p_replang_getcolname(pa_gdm[li_i].gdm04 CLIPPED)
         LET pa_gdm[li_i].gdm23 = cl_get_feldname(ls_colname,p_gdm03)
      END IF

      #單頭欄位說明尾端需加冒號(:)
      LET ls_coldesc = pa_gdm[li_i].gdm23 CLIPPED               
      IF pa_gdm[li_i].gdm05 = "1" 
         AND ls_coldesc.getCharAt(ls_coldesc.getLength()) != ":" 
      THEN
         LET pa_gdm[li_i].gdm23 = pa_gdm[li_i].gdm23 CLIPPED,":"
      END IF

      INSERT INTO gdm_file VALUES (pa_gdm[li_i].*)
      IF SQLCA.SQLCODE THEN
         LET ls_errmsg = ls_errmsg,SQLCA.SQLCODE," '",
                         pa_gdm[li_i].gdm04 CLIPPED,"' ",
                         cl_getmsg(SQLCA.SQLCODE,g_lang),"\n"
      END IF
   END FOR

   IF ls_errmsg.getLength() > 0 THEN
      CALL cl_err(ls_errmsg,"!",0)
   END IF
END FUNCTION 

#從4rp中讀取對齊屬性轉成資料庫對齊屬性
FUNCTION p_replang_getalign(p_value)
   DEFINE p_value    STRING
   DEFINE l_result   LIKE  type_file.chr1 

   LET l_result = NULL
   CASE DOWNSHIFT(p_value)
      WHEN "center"
         LET l_result = "C"
      WHEN "right"
         LET l_result = "R"
      WHEN "left"
         LET l_result = "L"
      OTHERWISE
         LET l_result = "L"
   END CASE

   RETURN l_result
END FUNCTION

#資料庫對齊屬性轉成4rp中對齊屬性
FUNCTION p_replang_setalign(p_value)
   DEFINE p_value    LIKE  type_file.chr1
   DEFINE l_result   STRING

   LET l_result = NULL
   CASE UPSHIFT(p_value)
      WHEN "C"
         LET l_result = "center"
      WHEN "R"
         LET l_result = "right"
      WHEN "L"
         LET l_result = "left"
      OTHERWISE
         LET l_result = "left"
   END CASE

   RETURN l_result
END FUNCTION

#取得欄位到單頭單身區段的所有節點
FUNCTION p_replang_getparents(p_node)
   DEFINE p_node     om.DomNode
   DEFINE la_parents DYNAMIC ARRAY OF om.DomNode
   DEFINE l_parent   om.DomNode

   CALL la_parents.clear()
   LET l_parent = p_node.getParent()#父節點
   WHILE TRUE
      IF l_parent IS NULL THEN
         EXIT WHILE
      END IF
      CALL la_parents.appendElement()
      LET la_parents[la_parents.getLength()] = l_parent #將父節點放入陣列
      IF l_parent.getAttribute("name") = "DetailHeaders" #父節點的NAME屬性判斷
          OR l_parent.getAttribute("name") = "Details"
          OR l_parent.getAttribute("name") = "Masters"
      THEN
         EXIT WHILE
      END IF
      LET l_parent = l_parent.getParent()
   END WHILE

   RETURN la_parents
END FUNCTION

#找出目前欄位與DetailHeaders,Details,Masters區段的層數
FUNCTION p_replang_getlevel(p_node)
   DEFINE p_node     om.DomNode
   DEFINE l_parent   om.DomNode
   DEFINE l_level    LIKE type_file.num5

   LET l_level = 0
   #找DetailHeaders,Details,Masters該層區段
   LET l_parent = p_node.getParent()
   WHILE TRUE
      IF l_parent IS NULL THEN
         LET l_level = 0   #未找到時將層數設為0
         EXIT WHILE
      END IF
      LET l_level = l_level + 1
      IF l_parent.getAttribute("name") = "DetailHeaders"
          OR l_parent.getAttribute("name") = "Details"
          OR l_parent.getAttribute("name") = "Masters"
      THEN
         EXIT WHILE
      END IF
      LET l_parent = l_parent.getParent()
   END WHILE

   RETURN l_level
END FUNCTION

#確認p_node是否為p_parent的子節點
FUNCTION p_replang_findchild(p_parent,p_node)
   DEFINE p_parent   om.DomNode
   DEFINE p_node     om.DomNode
   DEFINE l_nodelist om.NodeList
   DEFINE l_curnode  om.DomNode
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_result   LIKE type_file.num5
   DEFINE l_tagname  STRING
   DEFINE l_nodename STRING

   LET l_result = FALSE
   IF p_parent IS NOT NULL AND p_node IS NOT NULL THEN
      LET l_tagname = p_node.getTagName()
      LET l_nodename = p_node.getAttribute("name")
      LET l_nodelist = p_parent.selectByTagName(l_tagname)
      FOR l_i = 1 TO l_nodelist.getLength()
         LET l_curnode = l_nodelist.item(l_i)
         IF l_curnode.getAttribute("name") = l_nodename THEN
            LET l_result = TRUE
            EXIT FOR
         END IF
      END FOR
   END IF
   RETURN l_result
END FUNCTION
#FUN-C30008 --end--
