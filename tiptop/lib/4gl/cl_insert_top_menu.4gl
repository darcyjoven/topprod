# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Program name...: cl_insert_top_menu.4gl
# Descriptions...: 插入TopMenu.
# Date & Author..: 03/11/06 by Hiko
# Usage..........: CALL cl_insert_top_menu(NULL)
# Modify.........: 03/12/11 by Hiko : 因為動態增加TopMenu時,其command為呈現disable狀態,
#                                     原因在於主程式並無相對應之ON ACTION,因此必須動態
#                                     產生Menu的Action,但是Genero目前版本並無法抓取Menu
#                                     節點,因此無法產生Action.最後決定以StartMenu替代.
# Modify.........: No.TQC-6B0077 06/11/15 by saki : 剔除udm_tree, 語言別轉換須重新製作startmenu節點
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
 
# Descriptions...: 插入Top Menus.
# Date & Author..: 2003/07/03 by Hiko
# Input Parameter: pc_prog   VARCHAR(10)   程式代號
# Return code....: void
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
 
FUNCTION cl_insert_top_menu(pc_prog)
   DEFINE   pc_prog          LIKE zz_file.zz01
   DEFINE   ls_prog_group    STRING,
             #MOD-490253
            lc_prog_group    LIKE gae_file.gae04,
            #--
            ls_prog_desc     STRING,
            lc_prog_type     LIKE zz_file.zz10,
            ls_sql           STRING
   DEFINE   lr_zz            RECORD
            prog             LIKE zz_file.zz01,
            prog_exec        LIKE zz_file.zz08,
            prog_desc        LIKE gaz_file.gaz03 
                             END RECORD
   DEFINE   lnode_root       om.DomNode,
            llst_sm          om.NodeList,
            llst_sm_group    om.NodeList,
            llst_sm_cmd      om.NodeList,
            lnode_sm         om.DomNode,
            lnode_sm_group   om.DomNode,
            lnode_sm_cmd     om.DomNode,
            li_i             LIKE type_file.num5,       #No.FUN-690005  SMALLINT,
            ls_cmd_name      STRING,
            ls_prog          STRING
#           ls_cmd_exec      STRING  #2004/03/25 改以 zz08 處理
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (cl_null(pc_prog)) THEN
      LET pc_prog = g_prog
   END IF
 
   #No.TQC-6B0077 --start--
   IF g_prog = "udm_tree" THEN
      RETURN
   END IF
   #No.TQC-6B0077 ---end---
 
#  2004/03/15 hjwang 更改 zz_file 檔案名稱多語言 
 
   SELECT gae04 INTO lc_prog_group FROM gae_file
    WHERE gae01='TopProgGroup' AND gae02='0' AND gae03=g_lang
   LET ls_prog_group = lc_prog_group CLIPPED
####
   
   SELECT zz10 INTO lc_prog_type FROM zz_file WHERE zz01=pc_prog
   IF (cl_null(lc_prog_type)) THEN
      RETURN
   END IF
   
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_sm = lnode_root.selectByTagName("StartMenu")
 
   IF (llst_sm.getLength() = 0) THEN
      LET lnode_sm = lnode_root.createChild("StartMenu")
   ELSE
      LET lnode_sm = llst_sm.item(1)
      #No.TQC-6B0077 --start--
      CALL lnode_root.removeChild(lnode_sm)
      LET lnode_sm = lnode_root.createChild("StartMenu")
      #No.TQC-6B0077 ---end---
   END IF
 
   LET llst_sm_group = lnode_sm.selectByTagName("StartMenuGroup")
   IF (llst_sm_group.getLength() = 0) THEN
      LET lnode_sm_group = lnode_sm.createChild("StartMenuGroup")
   ELSE
      LET lnode_sm_group = llst_sm_group.item(1)
   END IF
 
   CALL lnode_sm_group.setAttribute("text", ls_prog_group)
   
#  2004/03/15 hjwang 更改 zz_file 檔案名稱多語言 
#  2004/03/25 hjwang 執行該程式改以抓取 zz08 為準
   LET ls_sql = "SELECT zz01,zz08,gaz03 ", # || ls_prog_desc ||
                 " FROM zz_file, OUTER gaz_file ",
                " WHERE zz10='", lc_prog_type, "'",
                  " AND gaz01=zz01 AND gaz02='",g_lang CLIPPED,"'"
####
 
   PREPARE lprep_zz FROM ls_sql
   DECLARE lcurs_zz CURSOR FOR lprep_zz
   
   LET llst_sm_cmd = lnode_sm_group.selectByTagName("StartMenuCommand")
   FOREACH lcurs_zz INTO lr_zz.*
      IF (lr_zz.prog != pc_prog) THEN
         LET ls_prog = lr_zz.prog CLIPPED
         IF (llst_sm_cmd.getLength() = 0) THEN
            LET lnode_sm_cmd = lnode_sm_group.createChild("StartMenuCommand") 
            CALL lnode_sm_cmd.setAttribute("name", ls_prog)
            CALL lnode_sm_cmd.setAttribute("text", lr_zz.prog_desc CLIPPED)
            CALL lnode_sm_cmd.setAttribute("exec", lr_zz.prog_exec CLIPPED)
         ELSE
            FOR li_i = 1 TO llst_sm_cmd.getLength()
               LET lnode_sm_cmd = llst_sm_cmd.item(li_i)
               LET ls_cmd_name = lnode_sm_cmd.getAttribute("name")
               IF (ls_cmd_name.equals(ls_prog)) THEN
                  CALL lnode_sm_cmd.setAttribute("text", lr_zz.prog_desc CLIPPED)
                  EXIT FOR
               END IF
            END FOR
         END IF
      END IF
   END FOREACH
END FUNCTION
