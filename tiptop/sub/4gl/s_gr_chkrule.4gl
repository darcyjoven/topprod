# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_gr_chkrule.4gl
# Descriptions...: 防止GR報表結構不合規則的單頭單身欄位進行行序的更改
# Date & Author..: 12/03/26 by jacklai
# Usage .........: LET l_flag = s_gr_chkrule(p_node, p_src_lineno, p_dst_lineno)
# Input Parameter: p_node
#                  p_src_lineno  (新4rp的檔案路徑)
#                  p_dst_lineno   
# Return code....: TRUE
#                  FALSE
# Modify.........: No.FUN-C30288 12/03/29 By jacklai 新建

#FUN-C30288 --start--
IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

#找出不符合規則的Node
FUNCTION s_gr_chkrule(p_node, p_src_lineno, p_dst_lineno)
   DEFINE p_node        om.DomNode
   DEFINE p_src_lineno  LIKE type_file.num5
   DEFINE p_dst_lineno  LIKE type_file.num5
   DEFINE li_flag       LIKE type_file.num5
   DEFINE la_parents    DYNAMIC ARRAY OF om.DomNode
   DEFINE la_lines      DYNAMIC ARRAY OF om.DomNode
   DEFINE ls_secname    STRING

   LET li_flag = FALSE
   CALL la_parents.clear()
   CALL la_lines.clear()
      
   IF p_node IS NOT NULL AND p_src_lineno > 0 AND p_dst_lineno > 0
      AND p_src_lineno != p_dst_lineno
   THEN
      LET la_parents = p_replang_getparents(p_node)
      IF la_parents.getLength() > 0 THEN
         LET ls_secname = la_parents[la_parents.getLength()].getAttribute("name")      
         #取單頭或單身區段各行
         LET la_lines = s_gr_chkrule_getlines(la_parents[la_parents.getLength()])
         LET li_flag = s_gr_chkrule_chklevel(la_lines[p_src_lineno])
         IF NOT li_flag THEN
            LET li_flag = s_gr_chkrule_chklevel(la_lines[p_dst_lineno])
         END IF
      END IF
   END IF
   
   RETURN li_flag
END FUNCTION

#檢查欄位是否可搬移
FUNCTION s_gr_chkrule_field(p_4rppath, p_gdm04, p_src_lineno, p_dst_lineno)
   DEFINE p_4rppath     STRING
   DEFINE p_gdm04       LIKE gdm_file.gdm04
   DEFINE p_src_lineno  LIKE type_file.num5
   DEFINE p_dst_lineno  LIKE type_file.num5
   DEFINE l_doc         om.DomDocument
   DEFINE l_rootnode    om.DomNode
   DEFINE li_i          LIKE type_file.num5
   DEFINE la_nodes      DYNAMIC ARRAY OF om.DomNode
   DEFINE li_flag       LIKE type_file.num5

   LET li_flag = FALSE
   CALL la_nodes.clear()
   IF p_4rppath IS NOT NULL AND p_gdm04 IS NOT NULL
      AND p_src_lineno > 0 AND p_dst_lineno > 0 AND p_src_lineno != p_dst_lineno
   THEN
      LET l_doc = om.DomDocument.createFromXmlFile(p_4rppath)
      LET l_rootnode = l_doc.getDocumentElement()
      #取出所有符合欄位名稱
      LET la_nodes = s_gr_chkrule_findfields(l_rootnode, p_gdm04)
      FOR li_i = 1 TO la_nodes.getLength()
         LET li_flag = s_gr_chkrule(la_nodes[li_i],p_src_lineno,p_dst_lineno)
         IF li_flag THEN
            EXIT FOR
         END IF
      END FOR
   END IF
   RETURN li_flag
END FUNCTION

#取單頭單身區段中的各行
FUNCTION s_gr_chkrule_getlines(p_sectionnode)
   DEFINE p_sectionnode    om.DomNode
   DEFINE li_i             LIKE type_file.num5
   DEFINE la_lines         DYNAMIC ARRAY OF om.DomNode
   DEFINE l_curnode        om.DomNode
   DEFINE ls_name          STRING
   DEFINE ls_secname       STRING

   CALL la_lines.clear()

   IF p_sectionnode IS NOT NULL THEN
      LET ls_secname = p_sectionnode.getAttribute("name")

      #搜尋該層所屬行的子節點
      FOR li_i = 1 TO p_sectionNode.getChildCount()
         LET l_curnode = p_sectionNode.getChildByIndex(li_i)
         IF l_curnode.getTagName() = "MINIPAGE" 
            OR l_curnode.getTagName() = "LAYOUTNODE" 
         THEN
            LET ls_name = l_curnode.getAttribute("name")
            IF (ls_secname = "DetailHeaders" AND ls_name.getIndexOf("DetailHeader",1) >= 1)
               OR (ls_secname = "Details" AND ls_name.getIndexOf("Detail",1) >= 1)
               OR (ls_secname = "Masters" AND ls_name.getIndexOf("Master",1) >= 1)
            THEN
               CALL la_lines.appendElement()
               LET la_lines[la_lines.getLength()] = l_curnode
            END IF
         END IF
      END FOR
   END IF

   RETURN la_lines
END FUNCTION

#取得所有符合名稱的欄位節點
FUNCTION s_gr_chkrule_findfields(p_rootnode,ps_searchname)
   DEFINE p_rootnode    om.DomNode
   DEFINE ps_searchname STRING
   DEFINE la_stack      DYNAMIC ARRAY OF om.DomNode
   DEFINE l_curnode     om.DomNode
   DEFINE li_i          LIKE type_file.num5
   DEFINE l_curchild    om.DomNode
   DEFINE ls_cchildname STRING
   DEFINE la_result     DYNAMIC ARRAY OF om.DomNode

   CALL la_result.clear()
   #使用堆疊巡覽整個子樹
   CALL la_stack.clear()
   CALL stack_push(la_stack,p_rootnode)
   WHILE la_stack.getLength() > 0
      #正在處理的節點(要彈出堆疊)
      LET l_curnode = stack_pop(la_stack)
      IF l_curnode IS NOT NULL THEN
         FOR li_i = l_curnode.getChildCount() TO 1 STEP -1 
            LET l_curchild = l_curnode.getChildByIndex(li_i)

            #當子節點為容器時將子節點推入堆疊
            IF l_curchild.getChildCount() > 0 THEN
               CALL stack_push(la_stack,l_curchild) 
            ELSE
               #當子節點為欄位時,要根據欄位到單頭單身的階層數來判斷是否符合規則 
               IF l_curchild.getTagName() = "WORDBOX"
                  OR l_curchild.getTagName() = "WORDWRAPBOX"
                  OR l_curchild.getTagName() = "DECIMALFORMATBOX"
                  OR l_curchild.getTagName() = "PAGENOBOX"
                  OR l_curchild.getTagName() = "IMAGEBOX"
               THEN
                  LET ls_cchildname = l_curchild.getAttribute("name")
                  IF ls_cchildname IS NOT NULL THEN
                     IF ls_cchildname.getIndexOf(ps_searchname,1) > 0 THEN
                        #DISPLAY "Node<",l_curchild.getTagName()," name=\"",l_curchild.getAttribute("name"),"\">"
                        CALL la_result.appendElement()
                        LET la_result[la_result.getLength()] = l_curchild
                     END IF
                  END IF
               END IF
            END IF
         END FOR
      END IF
   END WHILE

   RETURN la_result
END FUNCTION

#檢查各行中的欄位是否有多層的情況
FUNCTION s_gr_chkrule_chklevel(p_linenode)
   DEFINE p_linenode om.DomNode
   DEFINE l_stack    DYNAMIC ARRAY OF om.DomNode
   DEFINE l_curnode  om.DomNode
   DEFINE li_i       LIKE type_file.num5
   DEFINE l_curchild om.DomNode
   DEFINE li_level   LIKE type_file.num5
   DEFINE li_flag    LIKE type_file.num5

   LET li_flag = FALSE

   #使用堆疊巡覽整個子樹
   CALL l_stack.clear()
   CALL stack_push(l_stack,p_linenode)
   WHILE l_stack.getLength() > 0
      #正在處理的節點(要彈出堆疊)
      LET l_curnode = stack_pop(l_stack)
      IF l_curnode IS NOT NULL THEN
         FOR li_i = 1 TO l_curnode.getChildCount()
            LET l_curchild = l_curnode.getChildByIndex(li_i)

            #當子節點為容器時將子節點推入堆疊
            IF l_curchild.getTagName() = "LAYOUTNODE"
               OR l_curchild.getTagName() = "MINIPAGE"
            THEN
               CALL stack_push(l_stack,l_curchild) 
            ELSE
               #當子節點為欄位時,要根據欄位到單頭單身的階層數來判斷是否符合規則 
               IF l_curchild.getTagName() = "WORDBOX"
                  OR l_curchild.getTagName() = "WORDWRAPBOX"
                  OR l_curchild.getTagName() = "DECIMALFORMATBOX"
                  OR l_curchild.getTagName() = "IMAGEBOX"
               THEN 
                  LET li_level = p_replang_getlevel(l_curchild)
                  #超過兩層為不符規則
                  IF li_level > 2 THEN
                     LET li_flag = TRUE
                     CALL l_stack.clear()
                     EXIT WHILE
                  END IF
               END IF
            END IF
         END FOR
      END IF
   END WHILE

   RETURN li_flag
END FUNCTION

#將節點推入堆疊
PRIVATE FUNCTION stack_push(p_stack,p_node)
   DEFINE p_stack    DYNAMIC ARRAY OF om.DomNode
   DEFINE p_node     om.DomNode

   CALL p_stack.appendElement()
   LET p_stack[p_stack.getLength()] = p_node
END FUNCTION

#將節點彈出堆疊
PRIVATE FUNCTION stack_pop(p_stack)
   DEFINE p_stack    DYNAMIC ARRAY OF om.DomNode
   DEFINE p_node     om.DomNode

   LET p_node = p_stack[p_stack.getLength()]
   CALL p_stack.deleteElement(p_stack.getLength())
   RETURN p_node
END FUNCTION
#FUN-C30288 --end--
