# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Program name...: cl_insert_express_menu.4gl
# Descriptions...: 插入TopMenu.(於TopMenu中新增Express關聯報表的功能)
# Date & Author..: 2005.12.17 By Leagh
# Input parameter: pc_prog    程式代號
# Return code....: void
# Memo...........: FUN-660048
# Usage..........: CALL cl_insert_express_menu(pc_prog)
# Modify.........: No.FUN-690005 06/09/15 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.TQC-670080 06/07/21 by Echo 若程式群組有設定資料，修正重複建立StartMenu.
# Modify.........: No.FUN-740207 07/05/03 By Echo 報表型態應抓取資料欄位，不能寫死rep
# Modify.........: No.MOD-770145 07/07/30 By Echo 報表名稱內容有空白時會出現錯誤
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7C0085 07/12/25 By joyce 修改lib說明，以符合p_findfunc抓取的規格
# Modify.........: No.FUN-810054 08/01/18 By alex 判別作業系統
# Modify.........: No.FUN-840065 08/04/15 By kevin 新增menu(BI關聯報表)
# Modify.........: No.FUN-850029 08/05/06 By kevin 抓取express topmenu清單時需gcg12為null
 
DATABASE ds       
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
# No.FUN-7C0085
###############################################
# Descriptions...: 插入Top Menus.(於TopMenu中新增Express關聯報表的功能)
# Date & Author..: 2005.12.17 by Leagh
# Input parameter: pc_prog    程式代號
# Return code....: void
# Usage..........: CALL cl_insert_express_menu(pc_prog)
# Memo...........: FUN-660048
###############################################
 
FUNCTION cl_insert_express_menu(pc_prog,p_gcg12)
   DEFINE   pc_prog          LIKE zz_file.zz01
   DEFINE   l_type           LIKE gae_file.gae02     #FUN-840065
   DEFINE   p_gcg12          LIKE gcg_file.gcg12     #FUN-840065
   DEFINE   l_gcf09          LIKE gcf_file.gcf09  #FUN-840065
   DEFINE   l_gcf            RECORD LIKE gcf_file.*    	
   DEFINE   ls_prog_group    STRING,
            #BUG-490253
            lc_prog_group    LIKE gae_file.gae04,
            #--
            ls_prog_desc     STRING,
            lc_prog_type     LIKE zz_file.zz10,
            ls_sql           STRING
   DEFINE   lr_gcg           RECORD
            prog             LIKE gcg_file.gcg06,
            prog_exec        LIKE gcg_file.gcg06,
            prog_desc        LIKE gcg_file.gcg07,
            prog_type        LIKE gcg_file.gcg11             #FUN-740207 
                             END RECORD
   DEFINE   lnode_root       om.DomNode,
            lnode_last       om.DomNode,   # Added by Leagh 
            lnode_elem       om.DomNode,   # Added by Leagh
            llst_sm          om.NodeList,
            llst_sm_group    om.NodeList,
            llst_sm_cmd      om.NodeList,
            lnode_sm         om.DomNode,
            lnode_sm_group   om.DomNode,
            lnode_sm_cmd     om.DomNode,
            li_i             LIKE type_file.num5,   #No.FUN-690005 SMALLINT,
            ls_cmd_name      STRING,
            ls_prog          STRING,
            ls_cmd_exec      STRING  #2004/03/25 改以 zz08 處理    #FUN-740207 
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
  #IF g_aza.aza57 MATCHES '[nN]' THEN 
  #   RETURN
  #END IF
 
   IF (cl_null(pc_prog)) THEN
      LET pc_prog = g_prog
   END IF
  
   #FUN-840065 start
   IF p_gcg12="Y" THEN
   	  LET l_type = '1' #Express
   ELSE
      LET l_type = '2' #BI	     	  
   END IF
   #FUN-840065 end   
   
    SELECT distinct gcf09 INTO l_gcf09 FROM gcf_file 
            where gcf02='S'
            
   #FUN-850029 start
   IF p_gcg12="Y" THEN         
      SELECT COUNT(*) INTO li_i FROM gcg_file 
      WHERE gcg06 = pc_prog AND (gcg12=p_gcg12 OR gcg12 IS NULL )#FUN-840065
   ELSE
    	SELECT COUNT(*) INTO li_i FROM gcg_file 
      WHERE gcg06 = pc_prog AND gcg12=p_gcg12
   END IF
   #FUN-850029 end
    
   IF li_i = 0 OR (l_type='2' AND (l_gcf09='N' OR cl_null(l_gcf09))) THEN #FUN-840065
      RETURN
   END IF
 
   SELECT gae04 INTO lc_prog_group FROM gae_file    
    WHERE gae01='TopExpress' AND gae02=l_type AND gae03=g_lang #FUN-840065
    
   LET ls_prog_group = lc_prog_group CLIPPED
####
   
   # 關聯程序編號
   LET lc_prog_type = pc_prog CLIPPED
   IF (cl_null(lc_prog_type)) THEN
      RETURN
   END IF
   
   LET lnode_root = ui.Interface.getRootNode()
 
   # LET lnode_last = lnode_root.getLastChild()
 
  #TQC-670080
  #LET lnode_sm = lnode_root.createChild("StartMenu")
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_sm = lnode_root.selectByTagName("StartMenu")
 
   IF (llst_sm.getLength() = 0) THEN
      LET lnode_sm = lnode_root.createChild("StartMenu")
   ELSE
      LET lnode_sm = llst_sm.item(1)
   END IF
  #END TQC-670080
 
 
   CALL lnode_root.appendChild(lnode_sm) 
   # CALL lnode_root.insertBefore(lnode_sm,lnode_last)
 
   LET lnode_sm_group = lnode_sm.createChild("StartMenuGroup")
 
   CALL lnode_sm_group.setAttribute("text", ls_prog_group)
   
#  2004/03/15 hjwang 更改 zz_file 檔案名稱多語言 
#  2004/03/25 hjwang 執行該程式改以抓取 zz08 為準
 
   #FUN-850029 start
   IF p_gcg12="Y" THEN
      LET ls_sql = "SELECT gcg06,gcg06,gcg07,gcg11  ", # || ls_prog_desc ||
                   " FROM gcg_file ",
                   " WHERE gcg06='", lc_prog_type, "' ", 
                   " and (gcg12='",p_gcg12 CLIPPED, "' or gcg12 is null) "     #FUN-840065  
   ELSE
   	  LET ls_sql = "SELECT gcg06,gcg06,gcg07,gcg11  ",
                   " FROM gcg_file ",
                   " WHERE gcg06='", lc_prog_type, "' ", 
                   " and gcg12='",p_gcg12 CLIPPED, "' " 
   END IF
   #FUN-850029 end
#               " AND gcg05='",l_gcf.gcf05 CLIPPED,"'"
#               " AND gcg01='",l_gcf.gcf01 CLIPPED,"'",
#               " AND gcg02='",l_gcf.gcf02 CLIPPED,"'",
#               " AND gcg03='",l_gcf.gcf03 CLIPPED,"'",
#               " AND gcg04='",l_gcf.gcf04 CLIPPED,"'",
#               " AND gcg05='",l_gcf.gcf05 CLIPPED,"'"
 
####
 
   PREPARE lprep_zz FROM ls_sql
   DECLARE lcurs_zz CURSOR FOR lprep_zz
   
   LET llst_sm_cmd = lnode_sm_group.selectByTagName("StartMenuCommand")
   FOREACH lcurs_zz INTO lr_gcg.*
      IF (lr_gcg.prog = pc_prog) THEN
         LET ls_prog = lr_gcg.prog CLIPPED
         #IF (llst_sm_cmd.getLength() = 0) THEN
            LET lnode_sm_cmd = lnode_sm_group.createChild("StartMenuCommand") 
            IF cl_get_os_type() = "WINDOWS" THEN   #FUN-810054
               LET ls_cmd_exec = "%FGLRUN% %AZZi%/p_express 'T' '"
            ELSE
               LET ls_cmd_exec = "$FGLRUN $AZZi/p_express 'T' '"
            END IF
               LET ls_cmd_exec = ls_cmd_exec.trim(),
                               lr_gcg.prog_exec CLIPPED,"' '",
                               lr_gcg.prog_type CLIPPED,"' '",           #MOD-770145
                               lr_gcg.prog_desc CLIPPED,"'"              #FUN-740207 #MOD-770145
            CALL lnode_sm_cmd.setAttribute("name", ls_prog)
            CALL lnode_sm_cmd.setAttribute("text", lr_gcg.prog_desc CLIPPED)
            CALL lnode_sm_cmd.setAttribute("exec", ls_cmd_exec CLIPPED)  #FUN-740207
      END IF
   END FOREACH
END FUNCTION
