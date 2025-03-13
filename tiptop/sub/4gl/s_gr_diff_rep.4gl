# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_gr_diff_rep.4gl
# Descriptions...: 比對兩個4rp檔案的差異
# Date & Author..: 11/02/17 By tommas
# Usage .........: call s_gr_diff_rep(p_ori_file, p_new_file) returning l_result
# Input Parameter: p_ori_file (舊4rp的檔案路徑)
#                  p_new_file (新4rp的檔案路徑)
# Return code....: 1   使用者調整完畢並確認完成。調整完成之檔案會直接回存到p_new_file
#                  0   使用者取消。
# Memo...........: 當l_result為1時，調整完畢的檔案將回存到p_new_file，由CALL s_gr_diff_rep的程式
#                  將p_new_file做後續處理。
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report
# Modify.........: No.FUN-CC0099 13/01/24 By janet 增加ze代碼sub-547，修改init

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

#No.FUN-B40095
TYPE rp_node RECORD
         id        STRING,  #樹id
         parentid  STRING,  #上層id
         node_type STRING,  #節點類型
         node_name STRING,  #節點名稱
         is_expand BOOLEAN, #展開？
         diff      STRING,  #比對結果 
         node_id   STRING
         END RECORD 
TYPE g_attr_type RECORD
         attr_name  STRING,
         attr_value STRING
         END RECORD
TYPE g_attr_array       DYNAMIC ARRAY OF g_attr_type
DEFINE r_attr_old       DYNAMIC ARRAY OF RECORD  #用來顯示舊樹的節點屬性
          attr_name     STRING,
          attr_value    STRING
         END RECORD
DEFINE r_attr_new       DYNAMIC ARRAY OF RECORD  #用來顯示新樹的節點屬性
          attr_name     STRING,
          attr_value    STRING
         END RECORD
DEFINE g_stack_keys     DYNAMIC ARRAY OF STRING, #走訪的節點
       g_stack_ids      DYNAMIC ARRAY OF STRING  #走訪的節點
DEFINE g_rp_tree          DYNAMIC ARRAY OF rp_node,  #舊樹
       g_rp_tree_new      DYNAMIC ARRAY OF rp_node   #新樹
DEFINE rp_doc           om.DomDocument,            #舊xml document
       rp_doc_new       om.DomDocument             #新xml document
       
DEFINE g_curr_parent    INTEGER   #目前走訪節點的上層id
DEFINE unique_node_name STRING
DEFINE g_fileType         STRING            
DEFINE g_idx            INTEGER   #目前走訪到第g_idx節點
DEFINE g_node_idx       INTEGER,
       g_node_idx_tmp   INTEGER,
       g_is_init        BOOLEAN

#xml的各個節點的attributes 
#第1維陣列的類型是 g_attr_array
#第2維陣列的類型是 g_attr_type
DEFINE rp_node_attrs     DYNAMIC ARRAY OF g_attr_array 
DEFINE rp_node_attrs_new DYNAMIC ARRAY OF g_attr_array 
DEFINE saxHandler  om.SaxDocumentHandler
DEFINE g_new_file  STRING,
       g_ori_file  STRING, #原始4RP
       g_gdw01     LIKE gdw_file.gdw01, 
       g_gdw02     LIKE gdw_file.gdw02

FUNCTION s_gr_diff_rep(p_ori_file, p_new_file, p_gdw01, p_gdw02)
   DEFINE p_ori_file  STRING, #原來的報表檔
          p_new_file  STRING, #新報表檔
          p_gdw01     LIKE gdw_file.gdw01,
          p_gdw02     LIKE gdw_file.gdw02

   LET g_ori_file = p_ori_file
   LET g_new_file = p_new_file
   LET g_gdw01 = p_gdw01
   LET g_gdw02 = p_gdw02

   LET g_is_init = TRUE

   CREATE TEMP TABLE grp_diff_temp(
      id        LIKE type_file.chr1000, #唯一的名稱
      node_type LIKE type_file.chr100,  #NODE / ATTRIBUTE
      old_value LIKE type_file.chr100,  #原來的舊值
      new_value LIKE type_file.chr100,  #新的值
      old_line  LIKE type_file.num5,    #行號，同時也表示它在樹的第幾row
      new_line  LIKE type_file.num5)    #行號，同時也表示它在樹的第幾row
   
   INITIALIZE g_rp_tree TO NULL
   INITIALIZE rp_node_attrs TO NULL
   INITIALIZE g_rp_tree_new TO NULL
   INITIALIZE rp_node_attrs_new TO NULL
   
   RETURN s_gr_diff_rep_merge(p_ori_file, p_new_file)
END FUNCTION

PRIVATE FUNCTION s_gr_diff_rep_merge(p_ori_file, p_new_file)
   DEFINE p_ori_file   STRING,
          p_new_file   STRING
   DEFINE l_dnd ui.DragDrop,
          l_node        om.DomNode,
          l_i,l_j       INTEGER,
          l_gay01       LIKE gay_file.gay01,
          l_ans         STRING,
          l_node_id     LIKE type_file.chr1000
   DEFINE l_del_arr     DYNAMIC ARRAY OF INTEGER
   DEFINE l_result      BOOLEAN
   PREPARE grp_ins     FROM "INSERT INTO grp_diff_temp VALUES (?,?,?,?,?,?)"
   PREPARE grp_new_upd FROM "UPDATE grp_diff_temp SET new_value=?,new_line=? WHERE id=?"
   PREPARE grp_sel_cnt FROM "SELECT COUNT(*) FROM grp_diff_temp WHERE id = ?"
   
   LET saxHandler = om.SaxDocumentHandler.createForName("sub_s_gr_diff_rep")

   #開始解析舊檔案
   LET rp_doc = om.DomDocument.createFromXmlFile(p_ori_file)
   
   #產生舊檔案的樹
   CALL s_gr_diff_rep_render_tree("OLD")
   
   #開始解析新檔案
   LET rp_doc_new = om.DomDocument.createFromXmlFile(p_new_file)
   
   #產生新檔案的樹 
   CALL s_gr_diff_rep_render_tree("NEW")

   #開始比對新舊檔案
   CALL s_gr_diff_rep_begin_compare()
   
   OPEN WINDOW s_gr_diff_rep_w WITH FORM  "sub/42f/s_gr_diff_rep"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)

   CALL cl_ui_init()  

   DIALOG ATTRIBUTES(UNBUFFERED=TRUE)
   
      DISPLAY ARRAY g_rp_tree TO rp_tree.*
         BEFORE DISPLAY
            CALL DIALOG.setActionActive("addtoright",FALSE)
            #程式第一次啟動時，預選在第一筆不同的節點上。
            IF g_is_init THEN
               FOR l_i = 1 TO g_rp_tree.getLength()
                  IF g_rp_tree[l_i].diff == "-" THEN
                     CALL FGL_SET_ARR_CURR(l_i)
                     EXIT FOR
                  END IF
               END FOR
               LET g_is_init = FALSE               
            END IF
            
         ON DRAG_START (l_dnd)
            #版本Genero 2.30.06
            #Drag到第2層節點之後，無法正常觸發ON DROP，
            #所以先暫時取消DnD
            CALL l_dnd.setOperation(NULL)
         BEFORE ROW
            LET l_i = ARR_CURR()           
            CALL s_gr_diff_rep_show_attrs(l_i, "OLD", DIALOG)
            LET l_i = DIALOG.getCurrentRow("rp_tree")
            IF g_rp_tree[l_i].diff == "-" AND l_i > 1 THEN
               CALL DIALOG.setActionActive("addtoright",TRUE)
            ELSE
               CALL DIALOG.setActionActive("addtoright",FALSE)
            END IF
            
         ON ACTION addtoright
            CALL s_gr_diff_rep_merge_sel_to_new(DIALOG)

      END DISPLAY
      
      DISPLAY ARRAY g_rp_tree_new TO rp_tree_new.*
         ON DRAG_START (l_dnd)
            #版本Genero 2.30.06
            #Drag到第2層節點之後，無法正常觸發ON DROP，
            #所以先暫時取消DnD
            CALL l_dnd.setOperation(NULL)
         BEFORE ROW
            CALL s_gr_diff_rep_show_attrs(ARR_CURR(), "NEW", DIALOG)            
         #===========刪除節點開始===========
         ON ACTION del         
            INITIALIZE l_del_arr TO NULL
            LET l_ans = "yes"
            #FOR l_i = 1 TO g_rp_tree_new.getLength()
            #   IF DIALOG.isRowSelected("rp_tree_new", l_i) THEN
            #      IF g_rp_tree_new[l_i].diff.equals("+") == 0 THEN
            #         #待換成
            #         IF NOT cl_confirm("p_tgr14") THEN
            #            EXIT FOR
            #         END IF
            #      END IF
            #      CALL l_del_arr.appendElement()
            #      LET l_del_arr[l_del_arr.getLength()] = l_i
            #   END IF
            #END FOR
            IF l_ans.equals("yes") THEN
               FOR l_i = l_del_arr.getLength() TO 1 STEP -1
                  #更新temp table
                  LET l_node_id = g_rp_tree_new[l_del_arr[l_i]].node_id, "%"
                  
                  UPDATE grp_diff_temp SET new_value = "", new_line = "0"
                                       WHERE id LIKE l_node_id
                  DELETE FROM grp_diff_temp WHERE old_line = 0 AND id LIKE l_node_id
                  #刪除Tree節點時，連同子節點們一併刪除。
                  #CALL DIALOG.deleteNode("g_rp_tree_new", l_del_arr[l_i])  #重新產生樹，所以這個不用了

                  #刪除對應的DomDoucment
                  LET l_node = s_gr_diff_rep_get_node(g_rp_tree_new[l_i].*, rp_doc_new.getDocumentElement())
                  #l_node是NULL的情況如下：沒有任何屬性 / 屬性名稱沒有name、nameConstraint、url
                  IF l_node IS NOT NULL THEN
                     CALL rp_doc_new.removeElement(l_node)
                  END IF
               END FOR
               #操作完DomDocument後，重新產生樹及節點屬性
               CALL s_gr_diff_rep_render_tree("NEW")
               #重新比對
               CALL s_gr_diff_rep_begin_compare()
            END IF
         #===========刪除節點結束===========
         
      END DISPLAY
      
      DISPLAY ARRAY r_attr_old TO old_attrs.*          
      END DISPLAY

      DISPLAY ARRAY r_attr_new TO new_attrs.*
      END DISPLAY

      BEFORE DIALOG
         CALL DIALOG.setSelectionMode("rp_tree_new",1)

      ON ACTION CLOSE
         EXIT DIALOG

      ON ACTION save
         IF cl_confirm("azz1080") THEN
            display "save 4rp"
            CALL s_gr_diff_rep_save()
            LET l_result = TRUE
            EXIT DIALOG
         END IF

#屬性在p_replang中設定，且新樹中的新節點需合併到
#舊樹中，所以不用這個ACTION 了
#      ON ACTION merge_node
#         CALL s_gr_diff_rep_merge_all()
         
      ON ACTION CANCEL
         IF  NOT os.Path.delete(g_new_file) THEN
         END IF
         LET l_result = FALSE
         EXIT DIALOG
     
      ON ACTION next_diff  #依據舊檔來尋找下一個不同之節點
         LET l_j = DIALOG.getCurrentRow("rp_tree") + 1
         FOR l_i = l_j TO g_rp_tree.getLength()
            IF g_rp_tree[l_i].diff IS NOT NULL THEN
               CALL DIALOG.setCurrentRow("rp_tree",l_i)
               CALL s_gr_diff_rep_show_attrs(l_i, "OLD", DIALOG)
               EXIT FOR
            END IF 
         END FOR
         IF l_j = DIALOG.getCurrentRow("rp_tree") + 1 THEN
            FOR l_i = 1 TO l_j -1
               IF g_rp_tree[l_i].diff IS NOT NULL THEN
                  CALL DIALOG.setCurrentRow("rp_tree",l_i)
                  CALL s_gr_diff_rep_show_attrs(l_i, "OLD", DIALOG)
                  EXIT FOR
               END IF 
            END FOR
         END IF
         
   END DIALOG

   CLOSE WINDOW s_gr_diff_rep_w
   FREE grp_ins
   FREE grp_new_upd
   FREE grp_sel_cnt
   DROP TABLE grp_diff_temp
   RETURN l_result
END FUNCTION

FUNCTION s_gr_diff_rep_save()
   DEFINE l_gay01      LIKE gay_file.gay01
   DEFINE l_4rpdir     STRING
   DEFINE l_basename   STRING
   DEFINE l_langfile   STRING
   DEFINE l_idx        INTEGER
   DEFINE l_doc        om.DomDocument,
          l_tmp        om.DomNode
   DEFINE l_add_nodes  DYNAMIC ARRAY OF rp_node,  #要加到各檔案的節點
          l_del_nodes  DYNAMIC ARRAY OF rp_node

   #先將要新增的節點都先撈出來
   FOR l_idx = 1 TO g_rp_tree_new.getLength()
      IF g_rp_tree_new[l_idx].diff == "+" THEN
         CALL l_add_nodes.appendElement()
         LET l_add_nodes[l_add_nodes.getLength()].* = g_rp_tree_new[l_idx].*
      END IF
   END FOR

   #再從舊樹中把要刪除的節點撈出來
   FOR l_idx = 1 TO g_rp_tree.getLength()
      IF g_rp_tree[l_idx].diff == "-" THEN
         CALL l_del_nodes.appendElement()
         LET l_del_nodes[l_del_nodes.getLength()].* = g_rp_tree[l_idx].*
      END IF
   END FOR

   #先將src中的文件改過
   LET l_doc = om.DomDocument.createFromXmlFile(g_ori_file)

   #把要新增的節點們，加到舊dom中
   CALL s_gr_diff_rep_add_list(l_add_nodes,rp_doc_new.getDocumentElement(), l_doc.getDocumentElement(), "", "")
   #把要刪除的節點們，從舊dom中刪除
   CALL s_gr_diff_rep_del_list(l_del_nodes, l_doc.getDocumentElement())
   LET l_tmp = l_doc.getDocumentElement()
   #回存
   CALL l_tmp.writeXml(g_ori_file)

   LET l_4rpdir = os.Path.dirName(g_ori_file)
   LET l_4rpdir = os.Path.dirName(l_4rpdir)
   LET l_basename = os.Path.basename(g_ori_file)

   #找出各語言別的4rp   
   DECLARE s_gr_diff_rep_gay_curs CURSOR FOR SELECT gay01 FROM gay_file ORDER BY gay01
   FOREACH s_gr_diff_rep_gay_curs INTO l_gay01
      LET l_langfile = os.Path.join(l_4rpdir, l_gay01 CLIPPED)
      LET l_langfile = os.Path.join(l_langfile, l_basename)
      IF os.Path.exists(l_langfile) THEN
         LET l_doc = om.DomDocument.createFromXmlFile(l_langfile)
         LET l_tmp = l_doc.getDocumentElement()
         CALL s_gr_diff_rep_add_list(l_add_nodes, rp_doc_new.getDocumentElement(), l_tmp, l_gay01, os.Path.rootname(l_basename))
         CALL s_gr_diff_rep_del_list(l_del_nodes, l_tmp)
         CALL l_tmp.writeXml(l_langfile)
      ELSE
         DISPLAY "file not found:", l_langfile
      END IF
   END FOREACH   
END FUNCTION


#自動merge只合併相對的上層節點已經存在的，
#如果上層節點不存在，多做幾次merge
PRIVATE FUNCTION s_gr_diff_rep_merge_all()
   TYPE  child_node     DYNAMIC ARRAY OF STRING #舊節點的XML
   DEFINE node_map      DYNAMIC ARRAY OF RECORD
            old_line    INTEGER,                #舊節點行號
            new_line    INTEGER,                #新節點行號
            child_node  child_node
            END RECORD
   DEFINE is_find       BOOLEAN                 #是否在新樹上有找到舊節點相對的上層節點
   DEFINE l_old_node    om.DomNode,             #舊節點
          l_old_doc     om.DomDocument,
          l_tmp_node    om.DomNode
   DEFINE l_new_node    om.DomNode              #新節點
   DEFINE l_old_line    INTEGER,                #舊行號
          l_new_line    INTEGER,                 #新行號
          l_i,l_j,l_k   INTEGER
   DEFINE l_list        DYNAMIC ARRAY OF INTEGER  #必須加入的所有舊節點行號
   DEFINE l_unique_id   STRING,              
          l_parent_id   LIKE type_file.chr1000,
          l_name        STRING
   
   #找出新檔缺少的節點
   INITIALIZE l_list TO NULL
   PREPARE grp_sel_parent1 FROM "SELECT new_line FROM grp_diff_temp WHERE id = ? AND node_type = ? "
   DECLARE grp_d1 CURSOR FOR
      SELECT old_line FROM grp_diff_temp 
                      WHERE node_type = "ELEMENT" 
                      AND new_line = 0 
                      AND old_value == "OLD"
                      ORDER BY old_line 

   #找出所有舊節點的上層節點
   FOREACH grp_d1 INTO l_old_line
      CALL l_list.appendElement()
      LET l_list[l_list.getLength()] = l_old_line
      LET l_unique_id = g_rp_tree[l_old_line].node_id
      LET l_name = g_rp_tree[l_old_line].node_name
      LET l_parent_id = l_unique_id.subString(1,  l_unique_id.getIndexOf("@"||l_Name, 1)-1)

      #找出上層節點在新樹中相對的位置
      EXECUTE grp_sel_parent1 USING l_parent_id, "ELEMENT" INTO l_new_line

      #如果對應的上層節點存在於新樹中，則存入二維陣列中
      IF l_new_line > 0 THEN
         LET is_find = FALSE
         LET l_old_node = s_gr_diff_rep_get_node(g_rp_tree[l_old_line].*, rp_doc.getDocumentElement())
         FOR l_i = 1 TO node_map.getLength()
            IF node_map[l_i].new_line == l_new_line THEN
               CALL node_map[l_i].child_node.appendElement()
               LET node_map[l_i].child_node[node_map[l_i].child_node.getLength()] = l_old_node.toString()
               LET is_find = TRUE
               EXIT FOR 
            END IF
         END FOR
         IF is_find == FALSE THEN
            CALL node_map.appendElement()
            LET node_map[node_map.getLength()].old_line = l_old_line
            LET node_map[node_map.getLength()].new_line = l_new_line
            LET node_map[node_map.getLength()].child_node[1] = l_old_node.toString()
         END IF
      END IF
   END FOREACH

   #從新樹中，由下到上，依序建立node，並append到相對的上層節點底下
   FOR l_i = 1 TO node_map.getLength()
      LET l_new_node = s_gr_diff_rep_get_node(g_rp_tree_new[node_map[l_i].new_line].*, rp_doc_new.getDocumentElement())
      FOR l_j = 1 TO node_map[l_i].child_node.getLength()
         LET l_old_doc = om.DomDocument.createFromString(node_map[l_i].child_node[l_j])
         LET l_old_node = l_old_doc.getDocumentElement()
         LET l_tmp_node = l_new_node.createChild(l_old_node.getTagName())
         FOR l_k = 1 TO l_old_node.getAttributesCount()
            CALL l_tmp_node.setAttribute(l_old_node.getAttributeName(l_k), l_old_node.getAttributeValue(l_k))
         END FOR
      END FOR      
   END FOR
   
   #重新產生新樹
   DELETE FROM grp_diff_temp
   CALL s_gr_diff_rep_render_tree("OLD")
   CALL s_gr_diff_rep_render_tree("NEW")
   #重新比對
   CALL s_gr_diff_rep_begin_compare()
END FUNCTION

###############################################################################
#解析DomDocument，並產生樹
#為什麼要使用"OLD"及"NEW"？因為要讓SaxHandler解析時操作不同的tree及DomDocument
###############################################################################
PRIVATE FUNCTION s_gr_diff_rep_render_tree(p_file_type)
   DEFINE p_file_type  STRING
   DEFINE l_node       om.DomNode
   CASE p_file_type
      WHEN "OLD"
         LET g_fileType = "OLD"
         LET l_node = rp_doc.getDocumentElement()
         CALL l_node.write(saxHandler)
      WHEN "NEW"
         LET g_fileType = "NEW"
         LET l_node = rp_doc_new.getDocumentElement()
         CALL l_node.write(saxHandler)
   END CASE
END FUNCTION

PRIVATE FUNCTION s_gr_diff_rep_merge_sel_to_new(p_dialog)
   DEFINE p_dialog      ui.Dialog
   DEFINE l_i           INTEGER,
          l_pid         INTEGER
   DEFINE l_sel_node    om.DomNode,
          l_new_node    om.DomNode

   LET l_i = p_dialog.getCurrentRow("rp_tree")
   LET l_pid = p_dialog.getCurrentRow("rp_tree_new")
   
   LET l_sel_node = s_gr_diff_rep_get_node(g_rp_tree[l_i].*, rp_doc.getDocumentElement())
   LET l_new_node = s_gr_diff_rep_get_node(g_rp_tree_new[l_pid].*, rp_doc_new.getDocumentElement())

   CALL s_gr_diff_append_to_child(l_new_node, l_sel_node)

   #重新產生新樹
   DELETE FROM grp_diff_temp
   CALL s_gr_diff_rep_render_tree("OLD")
   CALL s_gr_diff_rep_render_tree("NEW")
   #重新比對
   CALL s_gr_diff_rep_begin_compare()
END FUNCTION

############################################################
#說明：逐一從p_source找出符合p_list內的節點，加入p_target的相對應節點中。
#參數：
#  p_list  :節點資訊，只用node_type及node_name做為搜尋節點的依據
#  p_source:p_list的來源依據
#  p_root  :從p_source找到節點後要加入的dom
#############################################################
PRIVATE FUNCTION s_gr_diff_rep_add_list(p_list, p_source, p_target, p_gay01, p_gdw09)
   DEFINE p_list      DYNAMIC ARRAY OF rp_node,
          p_source    om.DomNode,
          p_target    om.DomNode,
          p_gay01     LIKE gay_file.gay01,
          p_gdw09     LIKE gdw_file.gdw09
   DEFINE l_idx       INTEGER,
          l_add_node  om.DomNode,
          l_target    om.DomNode,
          l_tmp       om.DomNode,
          l_r         rp_node,
          l_gdw09     LIKE gdw_file.gdw09,
          l_gdm23     LIKE gdm_file.gdm23,
          l_gdm04     LIKE gdm_file.gdm04,
          l_txt       STRING

   FOR l_idx = 1 TO p_list.getLength()
      LET l_add_node = s_gr_diff_rep_get_node(p_list[l_idx].*, p_source)
      LET l_tmp = l_add_node.getParent()
      LET l_r.node_type = l_tmp.getTagName()
      CASE l_r.node_type
         WHEN "rtl:match"       LET l_r.node_name = l_tmp.getAttribute("nameConstraint")
         WHEN "rtl:call-report" LET l_r.node_name = l_tmp.getAttribute("url")
         OTHERWISE              LET l_r.node_name = l_tmp.getAttribute("name")
      END CASE
      LET l_gdm04 = l_r.node_name
      LET l_target = s_gr_diff_rep_get_node(l_r.*, p_target)
      IF l_target IS NULL THEN CONTINUE FOR END IF
      LET l_txt = l_add_node.getAttribute("text")

      IF l_txt IS NOT NULL AND l_txt NOT MATCHES "{{*}}" AND p_gay01 != "" THEN
      #找出節點中的text屬性，並從p_replang中找出對應的多語言並填入text屬性值
         SELECT gdm23 INTO l_gdm23 FROM gdm_file INNER JOIN gdw_file 
                                     ON gdw08 = gdm01
                                  WHERE gdw01 = g_gdw01 
                                    AND gdw02 = g_gdw02
                                    AND gdw09 = p_gdw09
                                    AND gdm03 = p_gay01
                                    AND gdm04 = l_gdm04
         #將多語言填入要新增的節點中
         IF NOT cl_null(l_gdm23) THEN
            CALL l_add_node.setAttribute("text", l_gdm23)
         END IF
      END IF
      CALL s_gr_diff_append_to_child(l_target, l_add_node)
   END FOR
   
END FUNCTION

############################################################
#說明：逐一從p_target中找出符合p_list內的節點並刪除之。
#參數：
#  p_list  :節點資訊，只用node_type及node_name做為搜尋節點的依據
#  p_target:要被找出來刪除的來源
#############################################################
PRIVATE FUNCTION s_gr_diff_rep_del_list(p_list, p_target)
   DEFINE p_list      DYNAMIC ARRAY OF rp_node,
          p_target    om.DomNode
   DEFINE l_idx       INTEGER,
          l_del_node  om.DomNode,
          l_parent    om.DomNode
          
   FOR l_idx = 1 TO p_list.getLength()
      LET l_del_node = s_gr_diff_rep_get_node(p_list[l_idx].*, p_target)
      IF l_del_node IS NOT NULL THEN
         LET l_parent = l_del_node.getParent()
         IF l_parent IS NOT NULL THEN
            CALL l_parent.removeChild(l_del_node)
         END IF
      END IF
   END FOR
   
END FUNCTION


###################################################
#說明：將p_child加到p_target中。
#參數：
#   p_target：目標節點
#   p_child ：加入的節點
###################################################
PRIVATE FUNCTION s_gr_diff_append_to_child(p_target, p_child)
   DEFINE p_target   om.DomNode,
          p_child    om.DomNode
   DEFINE l_i        INTEGER,
          l_node     om.DomNode,
          l_r        rp_node,
          l_len      INTEGER,
          l_source_parent om.DomNode,
          l_t_node   om.DomNode,
          l_o_node   om.DomNode

          
   LET l_r.node_type = p_child.getTagName()
   CASE l_r.node_type
      WHEN "rtl:match"       LET l_r.node_name = p_child.getAttribute("nameConstraint")
      WHEN "rtl:call-report" LET l_r.node_name = p_child.getAttribute("url")
      OTHERWISE              LET l_r.node_name = p_child.getAttribute("name")
   END CASE

   #逐一比對
   IF s_gr_diff_rep_get_node(l_r.*, p_target) IS NOT NULL THEN RETURN END IF
   
   #先附加到最後
   LET l_node = p_target.createChild(p_child.getTagName())
   FOR l_i = 1 TO p_child.getAttributesCount()
      CALL l_node.setAttribute(p_child.getAttributeName(l_i), p_child.getAttributeValue(l_i))
   END FOR

   #開始尋找節點必須要插入的正確位置 
   LET l_source_parent = p_child.getParent()
   #找出誰的子節點最多
   IF p_target.getChildCount() > l_source_parent.getChildCount() THEN
      LET l_len = p_target.getChildCount()
   ELSE 
      LET l_len = l_source_parent.getChildCount()
   END IF

   FOR l_i = 1 TO l_len
      #比對目前位置的節點不同時，就是要將最後附加上去的節點，移到正確的位置
      IF p_target.getChildCount() <= l_i THEN EXIT FOR END IF
      LET l_t_node = p_target.getChildByIndex(l_i)
      LET l_o_node = l_source_parent.getChildByIndex(l_i)
      IF l_t_node.getAttribute("name") != l_o_node.getAttribute("name") OR
         l_t_node.getAttribute("nameConstraint") != l_o_node.getAttribute("nameConstraint") OR
         l_t_node.getAttribute("url") != l_o_node.getAttribute("url") THEN
         CALL p_target.insertBefore(l_node, l_t_node)
         EXIT FOR
      END IF
   END FOR   

   #遞迴把該新增節點的子節點也加進
   FOR l_i = 1 TO p_child.getChildCount()
      CALL s_gr_diff_append_to_child(l_node, p_child.getChildByIndex(l_i))
   END FOR
END FUNCTION


########################################
#說明：從p_root中找到符合p_r資訊中的節點。
#     以p_r.node_type及p_r.node_name為尋找的依據。
#參數：
#   p_r   ：要找的節點資訊
#   p_root：要被找的節點
##########################################
PRIVATE FUNCTION s_gr_diff_rep_get_node(p_r, p_root)
   DEFINE p_r           rp_node,
          p_root         om.DomNode
   DEFINE l_curr_node   om.DomNode
   DEFINE l_list        om.NodeList,
          l_xpath       STRING,
          l_i           INTEGER,
          l_arr_value   STRING

   #使用xpath遇到冒號就掛了
   IF p_r.node_type.getIndexOf(":",1) > 0 THEN  
      CASE p_r.node_type
         WHEN "rtl:match"
            LET l_list = p_root.selectByTagName(p_r.node_type)
            FOR l_i = 1 TO l_list.getLength()
               LET l_curr_node = l_list.item(l_i)
               LET l_arr_value = l_curr_node.getAttribute("nameConstraint")
               IF l_arr_value IS NOT NULL AND l_arr_value == p_r.node_name THEN
                  RETURN l_curr_node
               END IF                  
            END FOR
            RETURN NULL
         WHEN "rtl:call-report"
            LET l_list = p_root.selectByTagName(p_r.node_type)
            FOR l_i = 1 TO l_list.getLength()
               LET l_curr_node = l_list.item(l_i)
               LET l_arr_value = l_curr_node.getAttribute("url")
               IF l_arr_value IS NOT NULL AND l_arr_value == p_r.node_name THEN
                  RETURN l_curr_node
               END IF                  
            END FOR
            RETURN NULL
         OTHERWISE
            LET l_list = p_root.selectByTagName(p_r.node_type)
            FOR l_i = 1 TO l_list.getLength()
               LET l_curr_node = l_list.item(l_i)
               LET l_arr_value = l_curr_node.getAttribute("name")
               IF l_arr_value IS NOT NULL AND l_arr_value == p_r.node_name THEN
                  RETURN l_curr_node
               END IF                  
            END FOR
            RETURN NULL
      END CASE  
      RETURN l_curr_node
   END IF

   #如果節點名稱不含冒號時
   CASE p_r.node_type
      WHEN "rtl:match"
         LET l_xpath = "//",p_r.node_type,"[@nameConstraint=\"",p_r.node_name, "\"]"
      WHEN "rtl:call-report"
         LET l_xpath = "//",p_r.node_type,"[@url=\"",p_r.node_name, "\"]"
      OTHERWISE
         LET l_xpath = "//",p_r.node_type,"[@name=\"",p_r.node_name, "\"]"
   END CASE   
   LET l_list = p_root.selectByPath(l_xpath)
   IF l_list.getLength() > 0 THEN
      RETURN l_list.item(1)
   ELSE
      RETURN NULL
   END IF

END FUNCTION

#利用arr_curr()來取出相對位置的節點
#必須排除text node
PRIVATE FUNCTION getNodeByIndex(p_node)
   DEFINE p_node  om.DomNode
   DEFINE l_node  om.DomNode
   DEFINE l_i     INTEGER 

   LET g_node_idx_tmp = g_node_idx_tmp + 1
   IF g_node_idx_tmp == g_node_idx THEN
      RETURN p_node
   END IF
   LET l_node = p_node
      IF p_node.getChildCount() > 0 THEN
         FOR l_i = 1 TO p_node.getChildCount()
            LET l_node = p_node.getChildByIndex(l_i)
            #排除純文字節點
            IF l_node.getTagName() == "@chars" THEN CONTINUE FOR END IF 
            LET l_node = getNodeByIndex(l_node)            
            IF l_node IS NOT NULL THEN 
               RETURN l_node
            END IF
         END FOR
      END IF
   RETURN NULL
END FUNCTION

PRIVATE FUNCTION s_gr_diff_rep_show_attrs(p_arr, p_file_type, p_dialog)
   DEFINE p_arr       INTEGER,      #目前選取的行號
          p_file_type STRING, #新或舊檔
          p_dialog    ui.Dialog  
   DEFINE l_old       INTEGER,
          l_new       INTEGER 
   DEFINE l_i         INTEGER
   DEFINE l_id        LIKE type_file.chr1000,
          l_tmp       STRING
   
   INITIALIZE r_attr_new TO NULL
   INITIALIZE r_attr_old TO NULL
   
   CASE p_file_type
      WHEN "OLD"
         LET l_old = p_arr
         SELECT new_line INTO l_new 
                         FROM grp_diff_temp 
                         WHERE old_line = l_old 
                         AND node_type = "ELEMENT"
         IF l_new == 0 THEN
            LET l_tmp = "@",g_rp_tree[l_old].node_name
            LET l_id = g_rp_tree[l_old].node_id.subString(1, g_rp_tree[l_old].node_id.getIndexOf(l_tmp,1)-1)
            SELECT new_line INTO l_new 
                            FROM grp_diff_temp 
                            WHERE id = l_id 
                            AND node_type = "ELEMENT"
         END IF
         CALL p_dialog.setCurrentRow("rp_tree_new", l_new)
      WHEN "NEW"
         LET l_new = p_arr
         SELECT old_line INTO l_old 
                         FROM grp_diff_temp 
                         WHERE new_line = l_new 
                         AND node_type = "ELEMENT"
         IF l_old == 0 THEN
            LET l_tmp = "@",g_rp_tree_new[l_new].node_name
            LET l_id = g_rp_tree_new[l_new].node_id.subString(1, g_rp_tree_new[l_new].node_id.getIndexOf(l_tmp,1)-1)
            SELECT old_line INTO l_old 
                            FROM grp_diff_temp 
                            WHERE id = l_id 
                            AND node_type = "ELEMENT"
         END IF
         CALL p_dialog.setCurrentRow("rp_tree", l_old)
   END CASE

   #顯示舊樹相對映的節點屬性
   IF l_old > 0 THEN
      FOR l_i = 1 TO rp_node_attrs[l_old].getLength()
         CALL r_attr_old.appendElement()
         LET r_attr_old[r_attr_old.getLength()].attr_name = rp_node_attrs[l_old][l_i].attr_name
         LET r_attr_old[r_attr_old.getLength()].attr_value = rp_node_attrs[l_old][l_i].attr_value
      END FOR
   END IF
   
   #顯示新樹相對映的節點屬性
   IF l_new > 0 THEN
      FOR l_i = 1 TO rp_node_attrs_new[l_new].getLength()
         CALL r_attr_new.appendElement()
         LET r_attr_new[r_attr_new.getLength()].attr_name = rp_node_attrs_new[l_new][l_i].attr_name
         LET r_attr_new[r_attr_new.getLength()].attr_value = rp_node_attrs_new[l_new][l_i].attr_value
      END FOR
   END IF
END FUNCTION 

#開始比對temp table中的old_value與new_value，並利用old_line及new_line做標記
PRIVATE FUNCTION s_gr_diff_rep_begin_compare()
   DEFINE  r RECORD
             id        LIKE type_file.chr1000,       #唯一的名稱
             node_type LIKE type_file.chr100, #NODE / ATTRIBUTE
             old_value LIKE type_file.chr100, #原來的舊值
             new_value LIKE type_file.chr100, #新的值
             old_line  INTEGER,                #行號             
             new_line  INTEGER                 #行號             
           END RECORD
   
   PREPARE p1 FROM "SELECT * FROM grp_diff_temp"
   DECLARE c1 CURSOR FOR p1
   FOREACH c1 INTO r.*
      #如果舊有值，新沒值      
      IF r.old_value IS NOT NULL AND r.new_value IS NULL THEN
         LET g_rp_tree[r.old_line].diff = "-"
         CONTINUE FOREACH
      END IF
      #如果新有值，舊沒值
      IF r.new_value IS NOT NULL AND r.old_value IS NULL THEN
         LET g_rp_tree_new[r.new_line].diff = "+"
         CONTINUE FOREACH
      END IF
      #如果新舊值不同
      IF r.node_type != "ELEMENT" AND r.old_value != r.new_value THEN
         LET g_rp_tree[r.old_line].diff = "<>"
         LET g_rp_tree_new[r.new_line].diff = "<>"
         CONTINUE FOREACH
      END IF
   END FOREACH
END FUNCTION

#檢查上傳的紙張設定是否已存在於p_grwp
FUNCTION s_gr_diff_rep_chk_paper_size(p_file_path)
   DEFINE p_file_path     STRING
   DEFINE l_doc           om.DomDocument,
          l_node          om.DomNode,
          l_paper         om.DomNode,
          l_list          om.NodeList,
          l_width_attr    STRING,
          l_length_attr   STRING,
          l_tmp           STRING,
          l_msg           STRING,
          l_gdo02         LIKE gdo_file.gdo02,
          l_gdo03         LIKE gdo_file.gdo03,
          l_gdo04         LIKE gdo_file.gdo04,
          l_gdo05         LIKE gdo_file.gdo05,
          l_gdo06         LIKE gdo_file.gdo06,
          l_ze03          LIKE ze_file.ze03,
          l_len           INTEGER,
          l_gdo           RECORD LIKE gdo_file.*
   DEFINE sb              base.StringBuffer
   DEFINE l_w_tmp         STRING,
          l_l_tmp         STRING,
          l_w_unit        STRING,
          l_l_unit        STRING

   LET l_doc = om.DomDocument.createFromXmlFile(p_file_path)
   LET l_node = l_doc.getDocumentElement()
   LET l_list = l_node.selectByTagName("report:Settings")
   IF l_list.getLength() > 0 THEN
      LET l_paper = l_list.item(1)
   ELSE
#必須改成多語言
      CALL cl_err("","找不到紙張設定!",1)
      RETURN FALSE
   END IF

   LET l_width_attr = l_paper.getAttribute("RWPageWidth")
   LET l_length_attr = l_paper.getAttribute("RWPageLength")

   #到p_grwp找gdo02,最後再來檢查gdo05   
   LET l_gdo05 = "C"
   IF l_width_attr.getIndexOf("in",1) > 0 OR l_length_attr.getIndexOf("in",1) > 0 THEN LET l_gdo05 = "I" END IF
   
   LET sb = base.StringBuffer.create()
   CALL sb.append(l_width_attr)
   CALL sb.replace("width","",1)
   CALL sb.replace("length","",1)
   CALL sb.toUpperCase()
   
   LET l_gdo02 = sb.toString()
   SELECT COUNT(gdo01) INTO l_len FROM gdo_file WHERE gdo02 = l_gdo02
   IF l_len > 0 THEN RETURN TRUE END IF

   CALL sb.clear()
   CALL sb.append(l_width_attr)
   CALL sb.replace("inch","",1)
   CALL sb.replace("in","",1)
   CALL sb.replace("cm","",1)
   CALL sb.toUpperCase()
   LET l_w_tmp = sb.toString()
   LET l_gdo03 = l_w_tmp

   CALL sb.clear()
   CALL sb.append(l_length_attr)
   CALL sb.replace("inch","",1)
   CALL sb.replace("in","",1)
   CALL sb.replace("cm","",1)
   CALL sb.toUpperCase()
   LET l_l_tmp = sb.toString()
   LET l_gdo04 = l_l_tmp
   
#去掉width,length字串後，去掉數值，再比對單位
   LET l_w_unit = cl_replace_str(l_width_attr, "width","")
   LET l_w_unit = cl_replace_str(l_w_unit, "length","")
   LET l_l_unit = cl_replace_str(l_length_attr, "length","")
   LET l_l_unit = cl_replace_str(l_l_unit, "width","")
   LET l_w_unit = cl_replace_str(l_w_unit, l_w_tmp, "")
   LET l_l_unit = cl_replace_str(l_l_unit, l_l_tmp, "")
   IF l_w_unit != l_l_unit THEN
      LET l_ze03 = cl_replace_str(l_ze03, "%1", l_width_attr)
      LET l_ze03 = cl_replace_str(l_ze03, "%2", l_length_attr)
      CALL cl_err_msg("","sub-534",l_width_attr|| "|" || l_length_attr,1)
      RETURN FALSE
   END IF
#############################################

   #l_gdo03及l_gdo04是null表示轉換數值失敗，它是文字
   IF l_gdo03 IS NULL AND l_gdo04 IS NULL THEN
       RETURN TRUE
#      LET l_len = 0
#      LET l_gdo02 = l_w_unit.toUpperCase()
#      SELECT COUNT(*) INTO l_len FROM gdo_file WHERE gdo02 = l_gdo02
#      IF l_len > 0 THEN
#         RETURN TRUE
#      END IF
   END IF

   #從p_grwp抓紙張格式
   SELECT * INTO l_gdo.* FROM gdo_file WHERE gdo03 = l_gdo03 AND  gdo04 = l_gdo04 AND gdo05 = l_gdo05
   IF l_gdo.gdo01 IS NOT NULL THEN
      #檢查紙張單位
      IF l_gdo.gdo05 == l_gdo05 THEN
         RETURN TRUE
      END IF
   END IF

   #有可能是橫式的紙張，所以寬高互換後，再撈一次
   SELECT * INTO l_gdo.* FROM gdo_file WHERE gdo03 = l_gdo04 AND gdo04 = l_gdo03 AND gdo05 = l_gdo05
   IF l_gdo.gdo01 IS NOT NULL THEN
      #檢查紙張單位
      IF l_gdo.gdo05 == l_gdo05 THEN
         RETURN TRUE
      END IF
   END IF

   CALL cl_set_act_visible("accept,cancel", TRUE)

   OPEN WINDOW s_gr_diff_grp_gdo_w WITH FORM "sub/42f/s_gr_diff_rep_gdo"

   #SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = "sub-533" AND ze02 = g_lang #FUN-CC0099 mark
   SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = "sub-547" AND ze02 = g_lang  #FUN-CC0099 add
   LET l_ze03 = cl_replace_str(l_ze03, "%1", l_width_attr)
   LET l_ze03 = cl_replace_str(l_ze03, "%2", l_length_attr ||"\n")

   #CALL cl_ui_init()  #FUN-CC0099 mark
   CALL cl_ui_locale("s_gr_diff_rep")  #FUN-CC0099 add

   INPUT l_gdo02, l_gdo06 FROM FORMONLY.gdo02, FORMONLY.gdo06
      BEFORE INPUT
         DISPLAY l_ze03 TO FORMONLY.message
   END INPUT

   CLOSE WINDOW s_gr_diff_grp_gdo_w

   CALL cl_set_act_visible("accept,cancel", FALSE)

   IF cl_null(l_gdo02) THEN
      RETURN FALSE
   ELSE
      SELECT COUNT(gdo01) INTO l_gdo.gdo01 FROM gdo_file
      LET l_gdo.gdo02 = l_gdo02
      LET l_gdo.gdo03 = l_gdo03
      LET l_gdo.gdo04 = l_gdo04
      LET l_gdo.gdo05 = l_gdo05
      LET l_gdo.gdo06 = l_gdo02
      LET l_gdo.gdo01 = l_gdo.gdo01 + 1
      INSERT INTO gdo_file VALUES ( l_gdo.* )
   END IF
   RETURN TRUE
END FUNCTION

#從其它程式的多語言截取欄位說明
#如果截取後還是沒有值，則從p_feldname抓
FUNCTION s_gr_diff_rep_upd_gdm23(p_gdw08)
   DEFINE p_gdw08       LIKE gdw_file.gdw08
   DEFINE p_gdw09       LIKE gdw_file.gdw09
   DEFINE l_gdm         DYNAMIC ARRAY OF RECORD
             gdm01      LIKE gdm_file.gdm01,
             gdm03      LIKE gdm_file.gdm03,
             gdm04      LIKE gdm_file.gdm04,
             gdm23      LIKE gdm_file.gdm23
                        END RECORD
   DEFINE l_gdw02_qry   STRING
   DEFINE l_i           INTEGER
   DEFINE l_tmp         STRING
   DEFINE l_gdm23       LIKE gdm_file.gdm23
   DEFINE l_gaq01       LIKE gaq_file.gaq01
   DEFINE l_gdm01       LIKE gdm_file.gdm01
   DEFINE l_gdw01_list       STRING
   DEFINE st            base.StringTokenizer
   DEFINE l_sql         STRING,
          l_gae04       LIKE gae_file.gae04,
          l_win         ui.Window

   #SELECT gdw08 INTO l_gdw08 FROM gdw_file WHERE gdw09 = p_gdw09
    OPEN WINDOW s_gr_diff_rep_gdw02_w WITH FORM "sub/42f/s_gr_diff_rep_gdw02"
    CALL cl_ui_init()
    SELECT gae04 INTO l_gae04 FROM gae_file WHERE gae01 = "s_gr_diff_rep_gdw02" AND gae03 = g_lang AND gae02 = "wintitle"
    LET l_win = ui.Window.getCurrent()
    CALL l_win.setText(l_gae04)
    INPUT l_gdw02_qry WITHOUT DEFAULTS FROM gdw02_qry
                      ATTRIBUTES(UNBUFFERED=TRUE)
        ON ACTION controlp
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_gdw02"
           LET g_qryparam.state = "c"
           LET g_qryparam.arg1 = g_lang
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           LET l_gdw02_qry = g_qryparam.multiret
    END INPUT

    CLOSE WINDOW s_gr_diff_rep_gdw02_w
   
   #如果沒有值，表示不參考其它的報表
   IF l_gdw02_qry IS NULL THEN RETURN END IF
   
   LET st = base.StringTokenizer.create(l_gdw02_qry, "|")
   WHILE st.hasMoreTokens()
      LET l_gdw01_list = l_gdw01_list,",'", st.nextToken() CLIPPED, "'"
   END WHILE
   IF l_gdw01_list IS NOT NULL THEN
      LET l_gdw01_list = l_gdw01_list.subString(2, l_gdw01_list.getLength())
   END IF
   
   DECLARE s_gr_diff_rep_gdm_c2 CURSOR FOR 
       SELECT gdm01, gdm03, gdm04, gdm23 FROM gdm_file
       WHERE gdm01 = p_gdw08

   CALL l_gdm.appendElement()
   FOREACH s_gr_diff_rep_gdm_c2 INTO l_gdm[l_gdm.getLength()].*
      CALL l_gdm.appendElement()
   END FOREACH
   CALL l_gdm.deleteElement(l_gdm.getLength())
   
   LET l_sql = "SELECT gdm01, gdm23 FROM gdm_file ",
               "WHERE gdm03 = ? ", #多語言
               "  AND gdm04 = ? ",  #欄位代碼
               "  AND gdm01 IN (SELECT gdw08 FROM gdw_file WHERE gdw01 IN (", l_gdw01_list, ") )"
   DECLARE s_gr_diff_rep_sel_gdm CURSOR FROM l_sql

   FOR l_i = 1 TO l_gdm.getLength()
      #從其它支程式
      LET l_gdm23 = l_gdm[l_i].gdm23
      #當欄位說明是空的時，才從p_replang及p_feldname中抓相關資料
      IF l_gdm23 IS NULL THEN
         FOREACH s_gr_diff_rep_sel_gdm USING l_gdm[l_i].gdm03, l_gdm[l_i].gdm04 INTO l_gdm01,l_gdm23 
            EXIT FOREACH 
         END FOREACH
         IF l_gdm23 IS NULL THEN
            LET l_tmp = l_gdm[l_i].gdm04
            #去掉sr1.xxx的sr1.
            LET l_gaq01 = l_tmp
            IF l_tmp.getIndexOf(".",1) > 0 THEN
               LET l_gaq01 = l_tmp.subString(l_tmp.getIndexOf(".",1)+1, l_tmp.getLength())
            END IF
            SELECT gaq03 INTO l_gdm23 FROM gaq_file
                                      WHERE gaq01 = l_gaq01
                                        AND gaq02 = l_gdm[l_i].gdm03   
            
            IF l_gdm23 IS NOT NULL THEN
               LET l_gdm[l_i].gdm23 = l_gdm23
            END IF
         END IF

         #更新gdm23
         IF l_gdm23 IS NOT NULL THEN
            UPDATE gdm_file SET gdm23 = l_gdm23 WHERE gdm01 = l_gdm[l_i].gdm01
                                                  AND gdm03 = l_gdm[l_i].gdm03
                                                  AND gdm04 = l_gdm[l_i].gdm04
         END IF

      END IF
   END FOR   
   FREE s_gr_diff_rep_gdm_c2
   FREE s_gr_diff_rep_sel_gdm
END FUNCTION

#如<?xml version="1.0" encoding="UTF-8"?>
#processingInstruction("xml", "version=\"1.0\" encoding=\"UTF-8\"")
PRIVATE FUNCTION processingInstruction(name,data)
   DEFINE name,data STRING
END FUNCTION

#讀取到開始節點<.....>
PRIVATE FUNCTION startElement(tag_name,attr)
   DEFINE tag_name      STRING
   DEFINE parent_node   STRING
   DEFINE attr          om.SaxAttributes
   DEFINE l_i           INTEGER
   DEFINE l_cnt         INTEGER
   DEFINE unique_id     LIKE type_file.chr1000
   DEFINE l_name_attr   STRING
   DEFINE att_name      LIKE type_file.chr1000 
   DEFINE att_value     LIKE type_file.chr1000
   
   LET g_idx = g_idx + 1

   #每個節點要產生一個唯一的識別資料，而底下2種
   #tag_name沒有name屬性，所以要拿其它的屬性來產生唯一識別值
   CASE tag_name
      WHEN "rtl:match"
         IF attr.getLength() > 0 AND attr.getValue("nameConstraint") IS NOT NULL AND tag_name == "rtl:match" THEN
            LET l_name_attr = attr.getValue("nameConstraint")
         END IF
      WHEN "rtl:call-report"
         IF attr.getLength() > 0 AND attr.getValue("url") IS NOT NULL AND tag_name == "rtl:call-report" THEN
            LET l_name_attr = attr.getValue("url")
         END IF
      OTHERWISE 
         IF attr.getLength() > 0 AND attr.getValue("name") IS NOT NULL THEN
            LET l_name_attr = attr.getValue("name")
         END IF
   END CASE
   
   IF l_name_attr IS NULL THEN
      LET l_name_attr = tag_name
   END IF
   
   IF g_stack_keys.getLength() > 0 THEN
      LET parent_node = g_stack_keys[g_stack_keys.getLength()]
      LET unique_node_name = unique_node_name, "@",l_name_attr
   ELSE
      LET unique_node_name = l_name_attr
   END IF
   
   CALL g_stack_keys.appendElement()
   LET g_stack_keys[g_stack_keys.getLength()] = l_name_attr
   
   LET unique_id = unique_node_name
   
   IF g_stack_ids.getLength() > 0 THEN
      LET g_curr_parent = g_stack_ids[g_stack_ids.getLength()]
   END IF
   CALL g_stack_ids.appendElement()
   LET g_stack_ids[g_stack_ids.getLength()] = g_idx
   
   #舊檔案處理方式
   IF g_fileType == "OLD" THEN     
      #將舊的樹存入資料庫 
      EXECUTE grp_ins USING  unique_id, "ELEMENT", "OLD", "", g_idx , "0" 
      #產生目前節點的所有屬性路徑與值，存入temp table
      CALL rp_node_attrs.appendElement()
      FOR l_i = 1 TO attr.getLength()  
         #將節點屬性存起來，以便看詳細資料
         LET rp_node_attrs[rp_node_attrs.getLength()][l_i].attr_name = attr.getName(l_i)
         LET rp_node_attrs[rp_node_attrs.getLength()][l_i].attr_value = attr.getValue(l_i)

         LET att_name = unique_id ,"@",attr.getName(l_i)
         LET att_value = attr.getValueByIndex(l_i)
         EXECUTE grp_ins USING att_name, "ATTRIBUTE", att_value, "", g_idx, "0"
      END FOR
      
      #產生舊樹
      CALL g_rp_tree.appendElement()
      LET l_i = g_rp_tree.getLength()
      LET g_rp_tree[l_i].id = g_idx
      LET g_rp_tree[l_i].parentid = g_curr_parent
      LET g_rp_tree[l_i].node_type = tag_name
      LET g_rp_tree[l_i].node_name = l_name_attr
      LET g_rp_tree[l_i].node_id = unique_id
      IF attr.getValue("name") IS NOT NULL THEN 
         LET g_rp_tree[l_i].node_name = attr.getValue("name")
      END IF
      LET g_rp_tree[L_I].is_expand = TRUE
   END IF

   #新檔案處理方式
   IF g_fileType == "NEW" THEN
      #檢查節點是否已經存在
      EXECUTE grp_sel_cnt USING unique_id INTO l_cnt
      #如果節點已經存在，則更新new_line, new_value，否則新增一筆
      IF l_cnt > 0 THEN
         EXECUTE grp_new_upd USING "NEW", g_idx, unique_id
      ELSE
         EXECUTE grp_ins USING unique_id, "ELEMENT", "", "NEW", "0" , g_idx 
      END IF

      #將新節點的所有屬性更新
      CALL rp_node_attrs_new.appendElement()
      FOR l_i = 1 TO attr.getLength()  
         LET rp_node_attrs_new[rp_node_attrs_new.getLength()][l_i].attr_name = attr.getName(l_i)
         LET rp_node_attrs_new[rp_node_attrs_new.getLength()][l_i].attr_value = attr.getValue(l_i)
      
         LET att_name = unique_id ,"@",attr.getName(l_i)
         LET att_value = attr.getValueByIndex(l_i)
         #檢查新節點的屬性是否已經存在
         EXECUTE grp_sel_cnt USING att_name INTO l_cnt
         IF l_cnt > 0 THEN
            EXECUTE grp_new_upd USING att_value, g_idx, att_name
         ELSE
            EXECUTE grp_ins USING att_name, "ATTRIBUTE", "", att_value, "0", g_idx
         END IF
      END FOR

      #產生新樹
      CALL g_rp_tree_new.appendElement()
      LET l_i = g_rp_tree_new.getLength()
      LET g_rp_tree_new[l_i].id = g_idx
      LET g_rp_tree_new[l_i].parentid = g_curr_parent
      LET g_rp_tree_new[l_i].node_type = tag_name
      LET g_rp_tree_new[l_i].node_name = tag_name
      LET g_rp_tree_new[l_i].node_id = unique_id
      IF attr.getValue("name") IS NOT NULL THEN 
         LET g_rp_tree_new[l_i].node_name = attr.getValue("name")
      END IF
      LET g_rp_tree_new[l_i].is_expand = TRUE
   END IF   
END FUNCTION

#讀取到結束節點</.....>
PRIVATE FUNCTION endElement(name)
   DEFINE name   STRING
   DEFINE l_tmp  STRING
   
   #節點走訪結束後，從stack刪除
   IF g_stack_keys.getLength() > 0 THEN
      LET l_tmp = g_stack_keys[g_stack_keys.getLength()]
      LET unique_node_name = unique_node_name.subString(1, unique_node_name.getLength() - (l_tmp.getLength()+1))
      CALL g_stack_keys.deleteElement(g_stack_keys.getLength())
      CALL g_stack_ids.deleteElement(g_stack_ids.getLength())
   END IF

END FUNCTION

#讀取檔案開始
PRIVATE FUNCTION startDocument()
   #初始化一些變數
   LET g_idx = 0
   LET g_curr_parent = 0
   LET unique_node_name = ""
   
   INITIALIZE g_stack_keys TO NULL
   INITIALIZE g_stack_ids TO NULL 

   CASE g_fileType
      WHEN "NEW"
         INITIALIZE g_rp_tree_new TO NULL
         INITIALIZE rp_node_attrs_new TO NULL
      WHEN "OLD"
         INITIALIZE g_rp_tree TO NULL
         INITIALIZE rp_node_attrs TO NULL
   END CASE
END FUNCTION

#讀取檔案結束
PRIVATE FUNCTION endDocument()
END FUNCTION

#read text node
PRIVATE FUNCTION characters(chars)
   DEFINE chars STRING   
END FUNCTION

#文件：插入如&nbsp;的文字時，使用SaxDocumentHandler.skippedEntity("nbsp")
PRIVATE FUNCTION skippedEntity(chars)
  DEFINE chars STRING
END FUNCTION
