# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: p_replang_regen.4gl
# Descriptions...: 重新產生語言別4rp樣板當
# Date & Author..: 11/05/05 by jacklai
# Param : arg_val(1):gdw08  報表樣板ID
#         arg_val(2):gdm03  語言別
#         arg_val(3):4rpdir 4rp目錄路徑 
#         arg_val(4):gdw09  4rp樣板檔名
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report
# Modify.........: No.FUN-C10044 12/01/13 By jacklai 表頭的公司地址等欄位說明寬度調整時，欄位值的定位點應跟隨調整
# Modify.........: No.FUN-C30008 12/03/02 By jacklai 增加欄位對齊屬性
# Modify.........: No.FUN-C30288 12/04/09 By jacklai 防止GR報表結構不合規則的單頭單身欄位進行行序的更改
# Modify.........: No.FUN-C40034 12/04/17 By janet 判斷gdm27控制欄位是否顯示公式欄位內容
# Modify.........: No.TQC-C50079 12/05/09 By odyliao 增加 PageNoBox (頁次) 的屬性修改
# Modify.........: No.FUN-C50112 12/04/17 By janet 增加gdm26控制欄位寫回4rp
# Modify.........: No.FUN-C50123 12/06/05 By odyliao 產生時固定將欄位的fidelity設定為true
# Modify.........: No.FUN-CB0059 12/11/14 By janet DHspacer、Dspacer、GHspacer、Fspacer、GFspacer不用加_label及_value
# Modify.........: No.FUN-CC0081 12/12/13 By janet 原判斷空白欄位統整 

IMPORT os

DATABASE ds

#No.FUN-B40095
DEFINE g_4rpdir         STRING
DEFINE g_gdw09          LIKE gdw_file.gdw09
DEFINE g_gdw08          LIKE gdw_file.gdw08
DEFINE g_gdm03          LIKE gdm_file.gdm03
DEFINE g_label_rmargin  LIKE type_file.num15_3

MAIN
    LET g_gdw08 = ARG_VAL(1)
    LET g_gdm03 = ARG_VAL(2)
    LET g_4rpdir = ARG_VAL(3)
    LET g_gdw09 = ARG_VAL(4)
    LET g_label_rmargin = 0.1

    CALL p_replang_regen()
END MAIN

PRIVATE FUNCTION p_replang_regen()
    DEFINE l_base4rp    STRING
    DEFINE l_4rpfile    STRING
    DEFINE l_doc        om.DomDocument
    DEFINE l_rootnode   om.DomNode
    DEFINE l_gdm        RECORD LIKE gdm_file.*
    DEFINE l_sql        STRING
    DEFINE l_rwx        LIKE type_file.num5
    DEFINE l_cmd        STRING
    DEFINE l_gdm04_str  STRING     #FUN-CB0059

    IF os.Path.exists(g_4rpdir) THEN
        LET l_sql = "SELECT * FROM gdm_file WHERE gdm01=? AND gdm03=? ORDER BY gdm05,gdm09,gdm10,gdm07"
        DECLARE p_replang_gdm3_cur SCROLL CURSOR FROM l_sql

        LET l_4rpfile = os.Path.join(g_4rpdir,g_gdm03 CLIPPED)
        LET l_4rpfile = os.Path.join(l_4rpfile,g_gdw09 CLIPPED||".4rp")

        IF NOT os.Path.exists(l_4rpfile) THEN
            LET l_base4rp = os.Path.join(g_4rpdir,"src")
            LET l_base4rp = os.Path.join(l_base4rp,g_gdw09 CLIPPED||".4rp")
        ELSE
            LET l_base4rp = l_4rpfile
        END IF
        
        LET l_doc = om.DomDocument.createFromXmlFile(l_base4rp)
        IF l_doc IS NOT NULL THEN
            LET l_rootnode = l_doc.getDocumentElement()
            IF l_rootnode IS NOT NULL THEN
                FOREACH p_replang_gdm3_cur USING g_gdw08,g_gdm03 INTO l_gdm.*
                  ##FUN-CB0059-(s) 
                  LET l_gdm04_str=l_gdm.gdm04 CLIPPED 
                  #FUN-CC0081 mark -(s)
                  #IF  l_gdm04_str.getIndexOf("Dspacer",1)>1 OR l_gdm04_str.getIndexOf("DHspacer",1)>1 OR l_gdm04_str.getIndexOf("GHspacer",1)>1 OR  
                  #   l_gdm04_str.getIndexOf("Fspacer",1)>1 OR l_gdm04_str.getIndexOf("GFspacer",1)>1 
                  #FUN-CC0081 mark -(e)
                  IF  l_gdm04_str.getIndexOf("spacer",1)>1   #FUN-CC0081 add
                      THEN
                     # CALL p_replang_change_node("//WORDWRAPBOX[@name=\""||l_gdm.gdm04||"]",l_doc,l_rootnode,l_gdm.*,"L") #FUN-CC0081 mark
                     # CALL p_replang_change_node("//WORDBOX[@name=\""||l_gdm.gdm04||"]",l_doc,l_rootnode,l_gdm.*,"V")     #FUN-CC0081 mark
                     #FUN-CC0081 add-(s)
                      CALL p_replang_change_node("//WORDWRAPBOX[@name=\""||l_gdm.gdm04||"\"]",l_doc,l_rootnode,l_gdm.*,"L")
                      CALL p_replang_change_node("//WORDWRAPBOX[@name=\""||l_gdm.gdm04||"\"]",l_doc,l_rootnode,l_gdm.*,"V")
                      CALL p_replang_change_node("//WORDBOX[@name=\""||l_gdm.gdm04||"\"]",l_doc,l_rootnode,l_gdm.*,"L") 
                      CALL p_replang_change_node("//WORDBOX[@name=\""||l_gdm.gdm04||"\"]",l_doc,l_rootnode,l_gdm.*,"V") 
                     #FUN-CC0081 add-(e)
                  ELSE  
                  ##FUN-CB0059 -(e)
                    CALL p_replang_change_node("//WORDWRAPBOX[@name=\""||l_gdm.gdm04||"_Label\"]",l_doc,l_rootnode,l_gdm.*,"L")
                    CALL p_replang_change_node("//WORDWRAPBOX[@name=\""||l_gdm.gdm04||"_Value\"]",l_doc,l_rootnode,l_gdm.*,"V")
                    CALL p_replang_change_node("//WORDBOX[@name=\""||l_gdm.gdm04||"_Label\"]",l_doc,l_rootnode,l_gdm.*,"L")
                    CALL p_replang_change_node("//WORDBOX[@name=\""||l_gdm.gdm04||"_Value\"]",l_doc,l_rootnode,l_gdm.*,"V")
                    CALL p_replang_change_node("//DECIMALFORMATBOX[@name=\""||l_gdm.gdm04||"_Value\"]",l_doc,l_rootnode,l_gdm.*,"V")
                    CALL p_replang_change_node("//PAGENOBOX[@name=\""||l_gdm.gdm04||"_Value\"]",l_doc,l_rootnode,l_gdm.*,"V") #TQC-C50079
                  END IF  #  #FUN-CB0059 add
                END FOREACH

                CALL l_rootnode.writeXml(l_4rpfile)

                #變更權限為777 Unix/Linux only
                LET l_rwx = 511 #7*64 + 7*8 + 7
                IF NOT os.Path.chrwx(l_4rpfile,l_rwx) THEN END IF
                LET l_cmd = "chmod 777 ",l_4rpfile
                DISPLAY l_cmd
            END IF
        END IF
    ELSE
        CALL cl_err("","",0)
    END IF
END FUNCTION

PRIVATE FUNCTION p_replang_change_node(p_tagname,p_doc,p_node,p_gdm,p_tagtype)
   DEFINE p_tagname    STRING
   DEFINE p_doc        om.DomDocument
   DEFINE p_node       om.DomNode
   DEFINE p_gdm        RECORD LIKE gdm_file.*        #從DB讀取的屬性
   DEFINE p_tagtype    LIKE type_file.chr1           #L:Label,V:Value
   DEFINE l_nodes      om.NodeList
   DEFINE l_curnode    om.DomNode
   DEFINE l_i          LIKE type_file.num10
   DEFINE l_parent     om.DomNode
   DEFINE l_pos        LIKE type_file.num15_3
   #FUN-C30008 移除未使用變數
   DEFINE l_tmpstr     STRING
   DEFINE l_gdm        RECORD LIKE gdm_file.*        #從4rp讀取的屬性

   LET l_nodes = p_node.selectByPath(p_tagname)
   FOR l_i = 1 TO l_nodes.getLength()
      LET l_curnode = l_nodes.item(l_i)
      LET l_parent = l_curnode.getParent()

      #設定單頭欄位的定位點
      LET l_gdm.gdm07 = p_replang_rmunit(l_curnode.getAttribute("y"))
      IF l_gdm.gdm07 != p_gdm.gdm07 THEN
         IF (p_gdm.gdm05 MATCHES "[1345]") AND p_gdm.gdm07 >= 0 THEN #FUN-C10044 add gdm05=3,4,5
            CASE p_tagtype
               WHEN "L"    #單頭欄位說明
                  IF p_gdm.gdm22 = "N" THEN
                     CALL l_curnode.removeAttribute("y")
                     CALL l_curnode.setAttribute("y",p_gdm.gdm07 USING "<<<<<<<<&.&&&cm")
                  END IF
               WHEN "V"    #單頭欄位
                  CASE p_gdm.gdm22
                     WHEN "Y"
                        CALL l_curnode.removeAttribute("y")
                        CALL l_curnode.setAttribute("y",p_gdm.gdm07 USING "<<<<<<<<&.&&&cm")
                     WHEN "N"
                        IF p_gdm.gdm15 IS NOT NULL AND p_gdm.gdm15 >= 0 THEN #FUN-C10044
                           LET l_pos = p_gdm.gdm07 + g_label_rmargin + p_gdm.gdm15
                        ELSE
                           LET l_pos = p_gdm.gdm07
                        END IF
                        CALL l_curnode.removeAttribute("y")
                        CALL l_curnode.setAttribute("y",l_pos USING "<<<<<<<<&.&&&cm")
                  END CASE
            END CASE
         END IF
      END IF

      #變更單頭或單身欄位行序 #FUN-C30008 移到最後
      #變更單身欄位欄序 #FUN-C30008 移到最後
      
      CASE p_tagtype
         WHEN "L"
            IF p_gdm.gdm15 IS NOT NULL AND p_gdm.gdm15 >= 0 THEN
               CALL l_curnode.removeAttribute("width")
               CALL l_curnode.setAttribute("width",p_gdm.gdm15||"cm")
            END IF

            IF p_gdm.gdm16 IS NOT NULL THEN
               CALL l_curnode.removeAttribute("fontName")
               CALL l_curnode.setAttribute("fontName",p_gdm.gdm16)
            END IF

            IF p_gdm.gdm17 IS NOT NULL THEN
               CALL l_curnode.removeAttribute("fontSize")
               CALL l_curnode.setAttribute("fontSize",p_gdm.gdm17)
            END IF

            IF p_gdm.gdm18 IS NOT NULL THEN
               CALL l_curnode.removeAttribute("fontBold")
               CALL l_curnode.setAttribute("fontBold",p_replang_char2boolstr(p_gdm.gdm18))
            END IF

            #將多語言資料寫入4rp
            #DISPLAY p_gdm.gdm04,":",(p_gdm.gdm23 IS NULL)   #debug
            IF p_gdm.gdm23 IS NOT NULL THEN
               #DISPLAY "gdm23=",p_gdm.gdm23    #debug
               LET l_tmpstr = l_curnode.getAttribute("text")
               IF l_tmpstr.getIndexOf("{{",1) <= 0 THEN
                  CALL l_curnode.removeAttribute("text")
                  CALL  l_curnode.setAttribute("text",p_gdm.gdm23 CLIPPED)
               END IF
            END IF

            #FUN-C30008 --start--
            IF NOT cl_null(p_gdm.gdm25) THEN
               CALL l_curnode.removeAttribute("textAlignment")
               CALL l_curnode.setAttribute("textAlignment",p_replang_setalign(p_gdm.gdm25))
            END IF
            #FUN-C30008 --end--
              ##FUN-C40034 ADD---START
              CASE
                 WHEN p_gdm.gdm22 = "Y"
                    CALL l_curnode.removeAttribute("rtl:condition")
                    CALL l_curnode.setAttribute("rtl:condition","Boolean.FALSE")
                    
                 OTHERWISE
                    CALL l_curnode.removeAttribute("rtl:condition")
                    
                    IF NOT cl_null(p_gdm.gdm27) THEN  
                      CALL l_curnode.setAttribute("rtl:condition",p_gdm.gdm27)
                    END IF 
                    
              END CASE  
             ##FUN-C40034 ADD---END 
            CALL p_replang_setcolor(l_curnode,p_gdm.gdm19)
         WHEN "V"
            IF p_gdm.gdm08 IS NOT NULL AND p_gdm.gdm08 > 0 THEN
               CALL l_curnode.removeAttribute("width")
               CALL l_curnode.setAttribute("width",p_gdm.gdm08||"cm")
            END IF

            IF p_gdm.gdm11 IS NOT NULL THEN
               CALL l_curnode.removeAttribute("fontName")
               CALL l_curnode.setAttribute("fontName",p_gdm.gdm11)
            END IF

            IF p_gdm.gdm12 IS NOT NULL THEN
               CALL l_curnode.removeAttribute("fontSize")
               CALL l_curnode.setAttribute("fontSize",p_gdm.gdm12)
            END IF

            IF p_gdm.gdm13 IS NOT NULL THEN
               CALL l_curnode.removeAttribute("fontBold")
               CALL l_curnode.setAttribute("fontBold",p_replang_char2boolstr(p_gdm.gdm13))
            END IF

            #FUN-C30008 --start--
            IF NOT cl_null(p_gdm.gdm25) THEN
               CALL l_curnode.removeAttribute("textAlignment")
               CALL l_curnode.setAttribute("textAlignment",p_replang_setalign(p_gdm.gdm24))
            END IF
            #FUN-C30008 --end--

            CALL p_replang_setcolor(l_curnode,p_gdm.gdm14)
           #隱藏
            CASE
               WHEN p_gdm.gdm21 = "Y"
                  CALL l_curnode.removeAttribute("rtl:condition")
                  CALL l_curnode.setAttribute("rtl:condition","Boolean.FALSE")
               OTHERWISE
                  CALL l_curnode.removeAttribute("rtl:condition")
                  ##FUN-C50112 ADD---START
                  IF NOT cl_null(p_gdm.gdm26) THEN
                    CALL l_curnode.setAttribute("rtl:condition",p_gdm.gdm26)
                  END IF 
                  ##FUN-C50112 ADD---END
                  
            END CASE
      END CASE


 
      #No.FUN-C50123  ---start-
      #自動設定欄位fidelity屬性為true
      CALL p_replang_fidelity(l_curnode)
      #No.FUN-C50123  ---end---
      
      #轉換是否折行
      CALL p_replang_convertwrap(l_curnode,p_gdm.gdm20)

      #FUN-C30008 --start--
      #變更單頭或單身欄位行序
      CALL p_replang_moveline(p_doc,l_curnode,p_gdm.*)

      #變更單頭或單身欄位行序
      CALL p_replang_movelinecol(p_doc,l_curnode,p_gdm.*)
      #FUN-C30008 --end--
   END FOR
END FUNCTION

#FUN-C30008 --start--
#單頭變更行序
PRIVATE FUNCTION p_replang_moveline(p_doc,p_node,p_gdm)
   DEFINE p_doc         om.DomDocument
   DEFINE p_node        om.DomNode
   DEFINE p_gdm         RECORD LIKE gdm_file.*        #從DB讀取的屬性
   DEFINE l_src_lineno  LIKE type_file.num5           #舊4rp的行數
   DEFINE l_src_colno   LIKE type_file.num5           #舊4rp的欄位順序
   DEFINE l_dst_line    om.DomNode                    #新行節點
   DEFINE l_src_line    om.DomNode                    #原行節點
   DEFINE l_level       LIKE type_file.num5           #欄位與單頭區段的層數
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_cur_node    om.DomNode                    #欄位所在的容器節點
   
   IF p_gdm.gdm05 = "1" THEN
      CALL p_replang_getlinecol(p_node)
         RETURNING l_src_lineno, l_src_colno
      #單頭行數需要修改
      IF l_src_lineno != p_gdm.gdm09 AND l_src_lineno > 0 AND p_gdm.gdm09 > 0 THEN #FUN-C30288 add p_gdm.gdm09 > 0
         LET l_dst_line = p_replang_get_dstnode(p_node,p_gdm.gdm09)
         LET l_src_line = p_replang_get_dstnode(p_node,l_src_lineno)
         LET l_level = p_replang_getlevel(p_node) #取得欄位層數
         
         IF l_dst_line IS NOT NULL AND l_src_line IS NOT NULL THEN
            IF l_level = 2 THEN #兩層
               #搬移節點
               CALL p_replang_movenodes(p_doc,p_node,l_dst_line,l_src_line,NULL)
            ELSE #三層以上
               IF l_level >= 3 THEN
                  FOR l_i = 1 TO l_src_line.getChildCount()
                     LET l_cur_node = l_src_line.getChildByIndex(l_i)
                     IF l_cur_node.getTagName() = "LAYOUTNODE" THEN
                        IF p_replang_findchild(l_cur_node,p_node) THEN
                           #搬移節點
                           CALL p_replang_movenodes(p_doc,p_node,l_dst_line,l_src_line,NULL)
                           EXIT FOR
                        END IF
                     END IF
                  END FOR
               END IF
            END IF
         END IF #搬移節點             
      END IF
   END IF
END FUNCTION

#單身變更行序及欄位順序
PRIVATE FUNCTION p_replang_movelinecol(p_doc,p_node,p_gdm)
   DEFINE p_doc         om.DomDocument
   DEFINE p_node        om.DomNode
   DEFINE p_gdm         RECORD LIKE gdm_file.*        #從DB讀取的屬性
   DEFINE l_src_lineno  LIKE type_file.num5           #舊4rp的行數
   DEFINE l_src_colno   LIKE type_file.num5           #舊4rp的欄位順序
   DEFINE l_dst_line    om.DomNode                    #新行節點
   DEFINE l_src_line    om.DomNode                    #原行節點
   DEFINE l_dst_col     om.DomNode                    #新欄位順序節點

   IF p_gdm.gdm05 = "2" THEN
      #取得舊4rp單身欄位的行序及欄位順序
      CALL p_replang_getlinecol(p_node)
         RETURNING l_src_lineno, l_src_colno

      #DISPLAY p_node.getAttribute("name")," 4rp(",l_src_lineno USING "<<<<<<<&",",",l_src_colno USING "<<<<<<<&","); db(",p_gdm.gdm09 USING "<<<<<<<&",",",p_gdm.gdm10 USING "<<<<<<<&",")" #debug FUN-C30288

      #FUN-C30288 --start--
      #單身行序及欄位順序需要修改
      IF (l_src_lineno != p_gdm.gdm09 OR l_src_colno != p_gdm.gdm10) 
         AND l_src_lineno > 0 AND p_gdm.gdm09 > 0
         AND l_src_colno > 0 AND p_gdm.gdm10 > 0
      THEN
      #FUN-C30288 --end--
         LET l_dst_line = p_replang_get_dstnode(p_node,p_gdm.gdm09)
         LET l_src_line = p_replang_get_dstnode(p_node,l_src_lineno)

         IF l_dst_line IS NOT NULL AND l_src_line IS NOT NULL THEN   #FUN-C30288 add
            #找出要變更的目標節點
            LET l_dst_col = p_replang_get_seqnode(l_dst_line,p_gdm.gdm10)

            IF l_dst_col IS NOT NULL THEN #FUN-C30288 add
               #搬移節點
               CALL p_replang_movenodes(p_doc,p_node,l_dst_line,l_src_line,l_dst_col)
            #FUN-C30288 --start-- add
            ELSE
               IF p_gdm.gdm10 > 0 THEN
                  CALL p_replang_movenodes(p_doc,p_node,l_dst_line,l_src_line,l_dst_col)
               END IF
            END IF
            #FUN-C30288 --end-- add
         END IF
      END IF
   END IF
END FUNCTION

#搬移節點
PRIVATE FUNCTION p_replang_movenodes(p_doc,p_node,p_dst_line,p_src_line,p_dst_col)
   DEFINE p_doc         om.DomDocument
   DEFINE p_node        om.DomNode
   DEFINE p_dst_line    om.DomNode
   DEFINE p_src_line    om.DomNode
   DEFINE p_dst_col     om.DomNode
   DEFINE l_vars        DYNAMIC ARRAY OF om.DomNode   #變數節點陣列
   DEFINE l_tnode       om.DomNode                    #暫存節點
   DEFINE l_vtnode      om.DomNode                    #暫存變數節點
   DEFINE l_i           LIKE type_file.num5

   IF p_doc IS NOT NULL AND p_node IS NOT NULL AND p_dst_line IS NOT NULL 
      AND p_src_line IS NOT NULL
   THEN
      #取得需搬移的變數節點
      LET l_vars = p_replang_get_varnodes(p_node)
      #搬移
      LET l_tnode = p_doc.copy(p_node,TRUE)

      #FUN-C30288 --start--
      #DISPLAY "before remove [",p_node.getAttribute("name"),"]:",p_replang_findchild(p_src_line, p_node) #debug FUN-C30288
      CALL p_doc.removeElement(p_node)
      #DISPLAY "after remove [",p_node.getAttribute("name"),"]:",p_replang_findchild(p_src_line, p_node) #debug FUN-C30288
      #FUN-C30288 --end--
      
      IF p_dst_col IS NOT NULL THEN
         CALL p_dst_line.insertBefore(l_tnode,p_dst_col)
      ELSE 
         CALL p_dst_line.appendChild(l_tnode)
      END IF
      FOR l_i = 1 TO l_vars.getLength()
         LET l_vtnode = p_doc.copy(l_vars[l_i],TRUE)
         
         #FUN-C30288 --start--
         #DISPLAY "before remove variable [",l_vars[l_i].getAttribute("name"),"]:",p_replang_findchild(p_src_line, l_vars[l_i]) #debug FUN-C30288
         CALL p_doc.removeElement(l_vars[l_i])
         #DISPLAY "after remove variable [",l_vars[l_i].getAttribute("name"),"]:",p_replang_findchild(p_src_line, l_vars[l_i]) #debug 120402
         #FUN-C30288 --end--
         
         CALL p_dst_line.insertBefore(l_vtnode,l_tnode)
      END FOR
   END IF
END FUNCTION
#FUN-C30008 --end--

PRIVATE FUNCTION p_replang_fidelity(p_node)
   DEFINE p_node        om.DomNode

   CALL p_node.removeAttribute("fidelity")
   CALL p_node.setAttribute("fidelity","true")
   
END FUNCTION
