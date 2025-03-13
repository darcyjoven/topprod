# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_create_4sm.4gl
# Descriptions...: 產生udmtree所需要的個人StartMenu.
# Memo...........: 1.以zx05為根節點.
#                  2.若zx05有異動,則要重新執行此程式.
#                  3.若zm_file有異動,則必須將有包含到的.4sm都要重新建立.
#                  4.若aooi901有新增資料庫, 則會新增所屬的4sm
# Date & Author..: 2003/07/15 by Hiko
# Modify.........: 04/05/14 saki zm_file是synonym的, 所以在重新建立的時候應該要跑所有db的4sm檔案
# Modify.........: No.MOD-510130 05/02/17 saki 修改4sm update路徑
# Modify.........: No.FUN-510047 05/04/19 alex 修改產生 4sm 及抓取 4sm 規則去除 db
# Modify.........: No.MOD-540068 05/04/21 saki 增加訊息
# Modify.........: No.MOD-620012 06/02/09 alex 修改產出語言別的指標
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify.........: NO.FUN-760037 07/10/04 By alex 修正enable時區時發生的問題
# Modify.........: No.TQC-810031 08/01/09 By Smapmin 先抓客製程式名稱,再抓標準程式名稱
# Modify.........: No.FUN-810054 08/01/18 By alex 判別作業系統
# Modify.........: No.TQC-920011 09/02/06 By alex 產生4sm一律改走exe2的路
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_azz05    LIKE azz_file.azz05  #FUN-760037
 
##########################################################################
# Descriptions...: 建立StartMenu.
# Memo...........: 
# Input parameter: pc_menu_root  LIKE zx_file.zx05  StartMenu的根節點
#                  pi_rebuild    SMALLINT           是否需要重新建立已存在的4sm
# Return code....: void
# Usage..........: CALL cl_create_4sm("m01",TRUE)
# Date & Author..: 2003/07/08 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_create_4sm(pc_menu_root, pi_rebuild)
   DEFINE   pc_menu_root   LIKE zx_file.zx05,
            pi_rebuild     LIKE type_file.num5,         #No.FUN-690005 SMALLINT
            li_language    LIKE type_file.num5,         #No.FUN-690005 SMALLINT
            lc_language    LIKE gay_file.gay01,         #MOD-620012
            ls_file_path   STRING,
            ldoc_4sm       om.DomDocument,
            ldoc_root      om.DomDocument,
            lnode_root     om.DomNode,
            lnode_child    om.DomNode,
            ls_text        STRING
   DEFINE   ls_sql         STRING
#  DEFINE   ls_dbs         VARCHAR(21)     #FUN-510047
#  DEFINE   li_db_num      INTEGER      #FUN-510047
   DEFINE   li_lang_num    LIKE type_file.num5          #No.FUN-690005 SMALLINT
#  DEFINE   li_dbs         INTEGER      #FUN-510047
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (cl_null(pc_menu_root)) THEN
      SELECT zx05 INTO pc_menu_root FROM zx_file WHERE zx01=g_user
      IF (SQLCA.SQLCODE) THEN
         LET pc_menu_root = "menu"
      END IF
   END IF
 
  #FUN-760037
  SELECT azz05 INTO g_azz05 FROM azz_file #azz為一筆資料檔案
 
   # 2004/05/14 by saki : 加上所有資料庫的數目*目前語言別 才是正確的4sm數目
   # 2004/06/11 by saki : 不能說最正確, 只是算出目前所有應該要存在的4sm
   #                      但有可能程式傳回FALSE不用重新蓋過4sm, 這種是檢查不用製造
#  # FUN-510047
#  # 2005/04/19 alex 取消 db (2005/04/14 產品會議決議 by Raymon,clin,Rita)
#  SELECT COUNT(UNIQUE azp03) INTO li_db_num FROM azp_file WHERE azp053 = 'Y'
 
   SELECT COUNT(UNIQUE gay01) INTO li_lang_num FROM gay_file
   
#  #FUN-510047
#  CALL cl_progress_bar(li_db_num * li_lang_num)
   CALL cl_progress_bar(li_lang_num)
 
#  # 2004/05/14 by saki : 搜尋我們有的資料庫
#  DECLARE lcurs_azp CURSOR FOR
#                    SELECT UNIQUE azp03 FROM azp_file WHERE azp053 = 'Y'
 
#  # 2006/02/09 alex MOD-620012
   DECLARE lcurs_gay CURSOR FOR
                     SELECT UNIQUE gay01 FROM gay_file
 
   # 2003/07/16 by Hiko : 語言別共有3種.
#  FOR li_language = 0 TO li_lang_num - 1
   FOREACH lcurs_gay INTO lc_language        #MOD-620012
 
      # 2004/05/14 by saki : 搜尋我們有的資料庫, 將所有資料庫的4sm都重建
      # 2005/04/19 alex 不重建
#     LET li_dbs = 0
#     FOREACH lcurs_azp INTO ls_dbs
#        IF (SQLCA.sqlcode) THEN
#           EXIT FOREACH
#        END IF
         
#        # 2004/06/11 by saki : 要計算目前跑了幾個dbs要與language相乘才與總數比較
#        LET li_dbs = li_dbs + 1
#        LET ls_file_path = gs_4sm_path || "/" || li_language || "/" || ls_dbs CLIPPED || "_" || pc_menu_root CLIPPED || ".4sm"
 
#        #MOD-620012
#        LET ls_file_path = gs_4sm_path || "/" || li_language || "/" || pc_menu_root CLIPPED || ".4sm"
         LET ls_file_path = gs_4sm_path || "/" || lc_language CLIPPED|| "/" || pc_menu_root CLIPPED || ".4sm"
 
         # 2003/12/25 by Hiko : 正常應該是先判斷檔案是否存在,然後在判斷是否需要重建,
         #                      但是這樣的判斷順序,勢必每種設定都要判斷檔案是否存在,
         #                      因此改成在設定為不需重建時,才判斷所要建立的4sm是否存在.
#        IF (NOT pi_rebuild) THEN
#           LET ldoc_4sm = om.DomDocument.createFromXmlFile(ls_file_path)
#           IF (ldoc_4sm IS NOT NULL) THEN
#              IF (g_trace = 'Y') THEN
#                 DISPLAY "cl_create_4sm : The file [" || ls_file_path || "] exist."
#              END IF
#              
#              CONTINUE FOR
#           END IF
#        END IF
 
         IF (NOT pi_rebuild) THEN
            DISPLAY "Start to check : ",ls_file_path
         ELSE
            DISPLAY "Start to replace : ",ls_file_path
         END IF
         LET ldoc_4sm = om.DomDocument.createFromXmlFile(ls_file_path)
         IF (ldoc_4sm IS NOT NULL) THEN
            IF (NOT pi_rebuild) THEN
              #IF (g_trace = 'Y') THEN
                  DISPLAY "cl_create_4sm : The file [" || ls_file_path || "] exist."
              #END IF
 
                #No.MOD-540068 底下cl_progressing就會計算mi_count了，這裡不需要
#              CALL cl_increase_progress_counter()
 
                #No.MOD-540068 --start-- cl_progressing會自己判斷關閉視窗
               # 2004/06/11 by saki
               # 2005/04/19 FUN-510047
#              IF ((li_language + 1) = li_lang_num) THEN
#              IF (((li_language + 1) * li_dbs) = (li_lang_num * li_db_num)) THEN
#                 CALL cl_close_progress_bar()  
#              END IF
                #No.MOD-540068 ---end---
 
               # 2004/06/11 by saki : 離開FOREACH就好, EXIT FOR 會使得後面的dbs沒有檢查到
#              CONTINUE FOREACH  #FUN-510047
            END IF
         END IF
         CALL cl_progressing("Create : " || ls_file_path)
 
         LET ldoc_root = om.DomDocument.create("StartMenu")
         LET lnode_root = ldoc_root.getDocumentElement()
         LET lnode_child = lnode_root.createChild("StartMenuGroup")
         CALL lnode_child.setAttribute("name", pc_menu_root CLIPPED)
 
#        #MOD-620012
#        LET ls_text = cl_get_node_text(li_language, pc_menu_root CLIPPED)
         LET ls_text = cl_get_node_text(lc_language, pc_menu_root CLIPPED)
         LET ls_text = ls_text.trim()
 
         CALL lnode_child.setAttribute("text", ls_text)
         #CALL lnode_child.setAttribute("image", "letter")
 
#        #MOD-620012
#        CALL cl_create_menu_tree(li_language, lnode_child, pc_menu_root CLIPPED)
         CALL cl_create_menu_tree(lc_language, lnode_child, pc_menu_root CLIPPED)
 
         CALL lnode_root.writeXml(ls_file_path)
 
         IF (ldoc_4sm IS NULL) THEN
            RUN "chmod 777 " || ls_file_path
         END IF
#     END FOREACH  #FUN-510047
   END FOREACH     #END FOR #MOD-620012
 
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 建立程式清單樹狀結構.
# Memo...........: 
# Input parameter: pc_lang       VARCHAR(1)     語言別
#                  pnode_parent  om.DomNode  樹狀結構的父項節點
#                  pc_cmd_key    VARCHAR(10)    索引值
# Return code....: void
# Usage..........: CALL cl_create_menu_tree(g_lang,lnode_child,"m01")
# Date & Author..: 2003/07/15 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_create_menu_tree(pc_lang, pnode_parent, pc_cmd_key)
   DEFINE   pc_lang        LIKE type_file.chr1,         #No.FUN-690005 VARCHAR(1) 
            pnode_parent   om.DomNode,
            pc_cmd_key     LIKE zm_file.zm01
   DEFINE   lr_zm          RECORD LIKE zm_file.*
   DEFINE   ls_text        STRING,
            li_cmd_count   LIKE type_file.num5,         #No.FUN-690005 SMALLINT
            lnode_child    om.DomNode,
            lc_exec        LIKE zz_file.zz08
   DEFINE la_zm DYNAMIC ARRAY OF RECORD LIKE zm_file.*
   DEFINE li_i LIKE type_file.num5          #No.FUN-690005 SMALLINT
 
   DECLARE lcurs_zm CURSOR FOR 
                    SELECT * FROM zm_file WHERE zm01=pc_cmd_key ORDER BY zm03
 
   FOREACH lcurs_zm INTO lr_zm.*
      IF (SQLCA.SQLCODE) THEN
         EXIT FOREACH
      END IF
 
      LET la_zm[li_i+1].* = lr_zm.*
      LET li_i = li_i + 1
   END FOREACH
 
   FOR li_i = 1 TO la_zm.getLength()
      LET ls_text = cl_get_node_text(pc_lang, la_zm[li_i].zm04)
      LET ls_text = ls_text.trim()
 
      SELECT COUNT(*) INTO li_cmd_count FROM zm_file WHERE zm01=la_zm[li_i].zm04
      IF (li_cmd_count > 0) THEN
         LET lnode_child = pnode_parent.createChild("StartMenuGroup")
         CALL lnode_child.setAttribute("name", la_zm[li_i].zm04 CLIPPED)
         CALL lnode_child.setAttribute("text", ls_text)
         #CALL lnode_child.setAttribute("image", "letter")
         CALL cl_create_menu_tree(pc_lang, lnode_child, la_zm[li_i].zm04)
      ELSE
         LET lnode_child = pnode_parent.createChild("StartMenuCommand")
         CALL lnode_child.setAttribute("name", la_zm[li_i].zm04 CLIPPED)
         CALL lnode_child.setAttribute("text", ls_text)
    
##       #FUN-760037
#        IF g_azz05 = "N" THEN   #TQC-920011
#           SELECT zz08 INTO lc_exec FROM zz_file WHERE zz01=la_zm[li_i].zm04
#        ELSE
            IF cl_get_os_type() = "WINDOWS" THEN   #FUN-810054
              LET lc_exec = "%FGLRUN% %AZZi%/p_go ",la_zm[li_i].zm04 CLIPPED
            ELSE
              LET lc_exec = "$FGLRUN $AZZi/p_go ",la_zm[li_i].zm04 CLIPPED
            END IF
#        END IF
    
         CALL lnode_child.setAttribute("exec", lc_exec CLIPPED)
        #CALL lnode_child.setAttribute("image", "find")
      END IF 
   END FOR  
END FUNCTION
 
##########################################################################
# Descriptions...: 回傳子項節點語言別的顯現字串.
# Memo...........: 
# Input parameter: ps_prog  STRING   程式代號
#                  pc_lang  VARCHAR(1)  語言別
# Return code....: STRING 顯現字串
# Usage..........: CALL cl_get_node_text(g_lang,g_prog)
# Date & Author..: 2003/07/15 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_get_node_text(pc_lang, ps_prog)
   DEFINE   pc_lang         LIKE type_file.chr1,         #No.FUN-690005 VARCHAR(1) 
            ps_prog         STRING
   DEFINE # ls_field_name   STRING,
            ls_sql          STRING
   DEFINE   lc_prog         LIKE zz_file.zz01
   DEFINE   lc_text         LIKE gaz_file.gaz03
   DEFINE   ls_text         STRING
 
#  2004/03/15 將 zz02 移為多語言架構
   LET lc_prog = ps_prog CLIPPED
   #-----TQC-810031---------
   #LET ls_sql = "SELECT gaz03 FROM gaz_file WHERE gaz01= ? AND gaz02 = ? "
   #PREPARE lcurs_zz_pre FROM ls_sql
   #EXECUTE lcurs_zz_pre INTO lc_text USING lc_prog,pc_lang
   LET ls_sql = "SELECT gaz03 FROM gaz_file WHERE gaz01= ? AND gaz02 = ? ",
                " AND gaz05 = 'Y' "
   PREPARE lcurs_zz_pre FROM ls_sql
   EXECUTE lcurs_zz_pre INTO lc_text USING lc_prog,pc_lang
   IF cl_null(lc_text) THEN
      LET ls_sql = "SELECT gaz03 FROM gaz_file WHERE gaz01= ? AND gaz02 = ? ",
                   " AND gaz05 = 'N' "
      PREPARE lcurs_zz_pre2 FROM ls_sql
      EXECUTE lcurs_zz_pre2 INTO lc_text USING lc_prog,pc_lang
   END IF
   #-----END TQC-810031-----
 
#  CASE
#     WHEN pc_lang = '0' LET ls_field_name = "zz02"
#     WHEN pc_lang = '1' LET ls_field_name = "zz02e"
#     WHEN pc_lang = '2' LET ls_field_name = "zz02c"
#  END CASE
#
#  LET ls_sql = "SELECT " || ls_field_name || 
#                " FROM zz_file WHERE zz01='" || ps_prog.trim() || "'"
#  DECLARE lcurs_zz CURSOR FROM ls_sql
#  OPEN lcurs_zz
#  FETCH lcurs_zz INTO lc_text
#  CLOSE lcurs_zz
 
   # 2004/04/13 by saki : 增加顯示程式代號
   LET ls_text = lc_text CLIPPED, " (" , lc_prog CLIPPED, ")"
 
   RETURN ls_text CLIPPED
END FUNCTION
