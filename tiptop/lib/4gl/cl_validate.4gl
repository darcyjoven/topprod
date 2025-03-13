# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: cl_validate.4gl
# Descriptions...: 動態檢查程式及欄位連查 No.FUN-710055
# Date & Author..: 07/01/24 by saki
# Usage..........: CALL cl_validate() RETURNING li_result
# Modify.........: No.FUN-750079 07/05/21 by alex 新增MSV判斷條件
# Modify.........: No.FUN-760049 07/06/21 by saki 行業別代碼更動
# Modify.........: No.FUN-760072 07/06/26 by saki 串查固定傳Q功能, 欄位隱藏時不串查. 開窗查詢加入串查功能
# Modify.........: No.FUN-750068 07/07/06 by saki 增加製造行業別Combobox的函式
# Modify.........: No.TQC-780010 07/08/02 by saki 避免不同table, field name相同, 造成搜尋資料有問題
# Modify.........: No.FUN-790042 07/09/20 by alexstar Performance改善
# Modify.........: No.EXT-7A0042 07/09/20 by alexstar Change Execute to FOREACH,and move cl_get_table_name to cl_show_fld_cont
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-810061 08/01/15 by saki 字串沖碼問題
# Modify.........: No.FUN-810089 08/03/05 by saki 行業別架構更動
# Modify.........: No.FUN-840011 08/04/03 by saki 自定義欄位修正
# Modify.........: No.CHI-990046 09/09/23 By Hiko 解決客製時,作業非正常關閉的問題.
# Modify.........: No:MOD-A10159 10/01/26 By saki 客製時找不到畫面資料以及select多筆錯誤
# Modify.........: No:MOD-A40020 10/04/06 By saki 單身串查程式名稱須reset
# Modify.........: No:CHI-A40067 10/05/17 By saki 共用畫面串查程式設定改變
# Modify.........: No:FUN-A70010 10/07/05 By tsai_yen 增加尋找ScrollGrid的Matrix屬性的元件
# Modify.........: No.FUN-B50102 11/05/17 By tsai_yen 函式說明
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   g_ui            RECORD
            g_value      STRING,
            g_check_mtd  STRING,
            g_check_dym  STRING,
            g_check_fun  STRING,
            g_refer_mtd  STRING,
            g_refer_fld  STRING,
            g_refer_dym  STRING,
            g_refer_fun  STRING,
            g_rpt_mtd    STRING,
            g_rpt_dym    STRING,
            g_rpt_fun    STRING
                         END RECORD
DEFINE   gr_gavxx        DYNAMIC ARRAY OF RECORD
            gav02        LIKE gav_file.gav02,
            gav32        LIKE gav_file.gav32,
            uifield_name STRING                      #No.FUN-760072
                         END RECORD
DEFINE   gw_win          ui.Window
DEFINE   gn_win          om.DomNode
DEFINE   g_db_type       LIKE type_file.chr3
DEFINE   g_std_id        LIKE smb_file.smb01
DEFINE   gr_resetbtn     DYNAMIC ARRAY OF RECORD     #No:CHI-A40067
            field        STRING,
            prog         STRING
                         END RECORD
 
#FUN-B50102 函式說明
##################################################
# Descriptions...: 檢查資料重複、基本資料檔檢查、帶出關聯欄位資料
# Date & Author..: 2007/01/24 by saki
# Input Parameter: none
# Return code....: TRUE/FALSE
# Usage..........: CALL cl_validate() RETURNING li_result
# Memo...........: No.FUN-710055
# Modify.........: 
##################################################
FUNCTION cl_validate()
   DEFINE   li_result        LIKE type_file.num5
 
   LET li_result = TRUE
 
   # 一般行業別代碼
#  SELECT smb01 INTO g_std_id FROM smb_file WHERE smb02="0" AND smb05="Y"  #No.FUN-760049 mark
   LET g_std_id = "std"
 
   #抓取UI設定資料,目前欄位值
   CALL cl_ui_set_init() RETURNING g_ui.g_value,
                                   g_ui.g_check_mtd,g_ui.g_check_dym,g_ui.g_check_fun,
                                   g_ui.g_refer_mtd,g_ui.g_refer_fld,g_ui.g_refer_dym,g_ui.g_refer_fun,
                                   g_ui.g_rpt_mtd,g_ui.g_rpt_dym,g_ui.g_rpt_fun
 
   #基本檔資料檢查
   IF NOT cl_data_check("",g_ui.g_value) THEN
      RETURN FALSE
   ELSE
      LET li_result = TRUE
   END IF
 
   #資料重複檢查
   IF NOT cl_repeat_check("",g_ui.g_value) THEN
      RETURN FALSE
   ELSE
      LET li_result = TRUE
   END IF
 
   #帶出referenct欄位
   CALL cl_reference("",g_ui.g_value) RETURNING li_result
 
   RETURN li_result
END FUNCTION
 
##################################################
# Descriptions...: 抓取元件設定值
# Date & Author..: 2007/01/24 by saki
# Input Parameter: none
# Return code....: ls_value 畫面上顯示的值   lc_gav28 基本檔資料檢查方式
#                  lc_gav20 動態檢查設定     lc_gav21 SQL或函式檢查設定
#                  lc_gav29 關聯欄位抓取方式 lc_gav31 關聯欄位代碼
#                  lc_gav22 關聯欄位動態設定 lc_gav23 SQL或函式抓取方式
#                  lc_gav30 資料重複檢查方式 lc_gav26 動態資料檢查
#                  lc_gav27 SQL或函式檢查設定
##################################################
 
FUNCTION cl_ui_set_init()
   DEFINE   lwin_curr        ui.Window
   DEFINE   lfrm_curr        ui.Form
   DEFINE   lnode_item       om.DomNode
   DEFINE   lnode_value_list om.DomNode,
            lnode_value      om.DomNode,
            lst_value        om.NodeList 
   DEFINE   lnode_parent     om.DomNode
   DEFINE   li_curr          LIKE type_file.num5
   DEFINE   li_show_curr     LIKE type_file.num5
   DEFINE   li_offset        LIKE type_file.num5
   DEFINE   li_pagesize      LIKE type_file.num5
   DEFINE   ls_value         STRING
   DEFINE   li_cnt           LIKE type_file.num5
   DEFINE   lc_custom        LIKE gav_file.gav08
   DEFINE   lc_gav20         LIKE gav_file.gav20
   DEFINE   lc_gav21         LIKE gav_file.gav21
   DEFINE   lc_gav22         LIKE gav_file.gav22
   DEFINE   lc_gav23         LIKE gav_file.gav23
   DEFINE   lc_gav26         LIKE gav_file.gav26
   DEFINE   lc_gav27         LIKE gav_file.gav27
   DEFINE   lc_gav28         LIKE gav_file.gav28
   DEFINE   lc_gav29         LIKE gav_file.gav29
   DEFINE   lc_gav30         LIKE gav_file.gav30
   DEFINE   lc_gav31         LIKE gav_file.gav31
   DEFINE   ls_tabname       STRING
 
   INITIALIZE g_ui.* TO NULL
 
   CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
 
   #抓取欄位目前的值
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
 
   LET ls_tabname = cl_get_table_name(g_fld_name CLIPPED)
   LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||g_fld_name CLIPPED)
   IF lnode_item IS NULL THEN
      LET lnode_item = lfrm_curr.findNode("FormField","formonly."||g_fld_name CLIPPED)
      IF lnode_item IS NULL THEN
         LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||g_fld_name CLIPPED)
         IF lnode_item IS NULL THEN
            LET lnode_Item = lfrm_curr.findNode("TableColumn","formonly."||g_fld_name CLIPPED)
            IF lnode_item IS NULL THEN
               LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||g_fld_name CLIPPED) #FUN-A70010
               IF lnode_item IS NULL THEN
                  LET lnode_Item = lfrm_curr.findNode("Matrix","formonly."||g_fld_name CLIPPED)  #FUN-A70010            
                  IF lnode_item IS NULL THEN
                     RETURN ls_value,lc_gav28,lc_gav20,lc_gav21,lc_gav29,lc_gav31,lc_gav22,lc_gav23,
                            lc_gav30,lc_gav26,lc_gav27
                  END IF
               END IF
            END IF
         END IF
      END IF
   END IF
   IF lnode_item.getTagName() = "TableColumn" THEN
      LET lnode_value_list = lnode_item.getLastChild()
      LET lst_value = lnode_value_list.selectByTagName("Value")
      LET lnode_parent = lnode_item.getParent()
      LET li_curr = lnode_parent.getAttribute("currentRow")
      LET li_offset = lnode_parent.getAttribute("offset")
      LET li_pagesize = lnode_parent.getAttribute("pageSize")
      LET li_show_curr = li_curr - li_offset + 1
      IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND 
         (li_show_curr != 0) THEN
         LET lnode_value = lst_value.item(li_show_curr)
         LET ls_value = lnode_value.getAttribute("value")
      END IF
   ELSE
      LET ls_value = lnode_item.getAttribute("value")
   END IF
 
   # 先看有沒有客製資料存在
   SELECT COUNT(UNIQUE gav01) INTO li_cnt FROM gav_file
    WHERE gav01 = g_frm_name AND gav08 = "Y"
   IF li_cnt > 0 THEN
      LET lc_custom = "Y"
   ELSE
      LET lc_custom = "N"
   END IF
   # 再看有沒有行業別資料存在
#  LET g_ui_setting = g_sma.sma124     #No.FUN-810089 mark, cl_ui_locale會得到g_ui_setting
   SELECT COUNT(*) INTO li_cnt FROM gav_file
    WHERE gav01 = g_frm_name AND gav08 = lc_custom AND gav11 = g_ui_setting
   IF li_cnt <= 0 THEN
      LET g_ui_setting = g_std_id
   END IF
 
   SELECT gav20,gav21,gav22,gav23,gav26,gav27,gav28,gav29,gav30,gav31
     INTO lc_gav20,lc_gav21,lc_gav22,lc_gav23,lc_gav26,lc_gav27,lc_gav28,
          lc_gav29,lc_gav30,lc_gav31 FROM gav_file
    WHERE gav01 = g_frm_name AND gav02 = g_fld_name AND gav08 = lc_custom
      AND gav11 = g_ui_setting
   RETURN ls_value,lc_gav28,lc_gav20,lc_gav21,lc_gav29,lc_gav31,lc_gav22,lc_gav23,
          lc_gav30,lc_gav26,lc_gav27
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 基本檔資料檢查
# Date & Author..: 2007/01/24 by saki
# Input Parameter: ps_field 欄位代碼
#                  pc_value 欄位值
# Return code....: TRUE/FALSE
# Usage..........: CALL cl_data_check("",g_ui.g_value) RETURNING l_result
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_data_check(ps_field,pc_value)
   DEFINE   ps_field         STRING
   DEFINE   pc_value         LIKE type_file.chr1000
   DEFINE   lc_custom        LIKE gav_file.gav08
   DEFINE   lc_gav20         LIKE gav_file.gav20
   DEFINE   lc_gav21         LIKE gav_file.gav21
   DEFINE   lc_gav28         LIKE gav_file.gav28
   DEFINE   ls_table         STRING
   DEFINE   ls_field         STRING
   DEFINE   ls_sql           STRING
   DEFINE   ls_first_line    STRING
   DEFINE   li_cnt           LIKE type_file.num10    #No.FUN-840011
   DEFINE   lc_gat03         LIKE gat_file.gat03
   DEFINE   li_result        LIKE type_File.num5
 
 
   #如果是空值就不檢查,空值利用必要欄位設定
   IF cl_null(pc_value) THEN
      RETURN TRUE
   END IF
 
   LET g_std_id = "std"     #No.FUN-760072
 
   IF NOT cl_null(ps_field) THEN
      CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
      LET g_fld_name = ps_field
   END IF
 
   IF cl_null(g_ui.g_check_mtd) OR NOT cl_null(ps_field) THEN
      # 先看有沒有客製資料存在
      SELECT COUNT(UNIQUE gav01) INTO li_cnt FROM gav_file
       WHERE gav01 = g_frm_name AND gav08 = "Y"
      IF li_cnt > 0 THEN
         LET lc_custom = "Y"
      ELSE
         LET lc_custom = "N"
      END IF
      # 再看有沒有行業別資料存在
#     LET g_ui_setting = g_sma.sma124     #No.FUN-810089 mark
      SELECT gav20,gav21,gav28 INTO lc_gav20,lc_gav21,lc_gav28 FROM gav_file
       WHERE gav01 = g_frm_name AND gav02 = g_fld_name AND gav08 = lc_custom
         AND gav11 = g_ui_setting
      IF SQLCA.sqlcode = 100 THEN
         SELECT gav20,gav21,gav28 INTO lc_gav20,lc_gav21,lc_gav28 FROM gav_file
          WHERE gav01 = g_frm_name AND gav02 = g_fld_name AND gav08 = lc_custom
            AND gav11 = g_std_id
      END IF
      LET g_ui.g_check_mtd = lc_gav28
      LET g_ui.g_check_dym = lc_gav20
      LET g_ui.g_check_fun = lc_gav21
   END IF
 
   LET li_result = TRUE
   IF g_ui.g_check_mtd = "1" AND (NOT cl_null(g_ui.g_check_dym)) THEN
      LET ls_table = g_ui.g_check_dym.subString(1,g_ui.g_check_dym.getIndexOf(".",1)-1)
      LET ls_field = g_ui.g_check_dym.subString(g_ui.g_check_dym.getIndexOf(".",1)+1,g_ui.g_check_dym.getLength())
      LET ls_sql = "SELECT COUNT(*) FROM ",ls_table,
                   " WHERE ",ls_field,"='",pc_value CLIPPED,"'"
      PREPARE check_pre FROM ls_sql
      EXECUTE check_pre INTO li_cnt
      IF li_cnt <= 0 THEN
         LET li_result = FALSE
      END IF
   END IF
 
   IF g_ui.g_check_mtd = "2" AND (NOT cl_null(g_ui.g_check_fun)) THEN
      LET g_ui.g_check_fun = cl_replace_str(g_ui.g_check_fun,"\n","")
      PREPARE check_sql_pre FROM g_ui.g_check_fun
      EXECUTE check_sql_pre INTO li_cnt USING pc_value
      IF li_cnt <= 0 THEN
         LET ls_table = g_ui.g_check_fun.subString(g_ui.g_check_fun.getIndexOf(" FROM ",1)+6,g_ui.g_check_fun.getIndexOf(" WHERE ",1)-1)
         LET li_result = FALSE
      END IF
   END IF
 
   IF (g_ui.g_check_mtd = "3" OR g_ui.g_check_mtd = "4") AND 
      (NOT cl_null(g_ui.g_check_fun)) THEN
      LET ls_first_line = g_ui.g_check_fun.subString(1,g_ui.g_check_fun.getIndexOf("\n",1)-1)
      CASE
         WHEN ls_first_line.getIndexOf("fun01",1)
            CALL cl_validate_fun01(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun02",1)
            CALL cl_validate_fun02(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun03",1)
            CALL cl_validate_fun03(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun04",1)
            CALL cl_validate_fun04(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun05",1)
            CALL cl_validate_fun05(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun06",1)
            CALL cl_validate_fun06(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun07",1)
            CALL cl_validate_fun07(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun08",1)
            CALL cl_validate_fun08(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun09",1)
            CALL cl_validate_fun09(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun10",1)
            CALL cl_validate_fun10(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun11",1)
            CALL cl_validate_fun11(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun12",1)
            CALL cl_validate_fun12(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun13",1)
            CALL cl_validate_fun13(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun14",1)
            CALL cl_validate_fun14(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun15",1)
            CALL cl_validate_fun15(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun16",1)
            CALL cl_validate_fun16(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun17",1)
            CALL cl_validate_fun17(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun18",1)
            CALL cl_validate_fun18(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun19",1)
            CALL cl_validate_fun19(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun20",1)
            CALL cl_validate_fun20(pc_value) RETURNING li_result
      END CASE
   END IF
 
   IF NOT li_result AND g_ui.g_check_mtd MATCHES '[12]' THEN
      LET ls_sql = "SELECT gat03 FROM gat_file ",
                   " WHERE gat01 = '",ls_table,"' AND gat02 = '",g_lang,"'"
      PREPARE pre_gat03 FROM ls_sql
      EXECUTE pre_gat03 INTO lc_gat03
      CALL cl_err_msg("","lib-236",pc_value CLIPPED||"|"||lc_gat03 CLIPPED||"|"||ls_table,1)
   END IF
   RETURN li_result
END FUNCTION
 
##################################################
# Descriptions...: 關聯欄位值抓取並顯示
# Date & Author..: 2007/01/24 by saki
# Input Parameter: ps_field 欄位代碼
#                  pc_value 欄位值
# Return code....: TRUE
##################################################
 
FUNCTION cl_reference(ps_field,pc_value)
   DEFINE   ps_field         STRING
   DEFINE   pc_value         LIKE type_file.chr1000
   DEFINE   lc_custom        LIKE gav_file.gav08
   DEFINE   li_cnt           LIKE type_file.num5
   DEFINE   lc_gav22         LIKE gav_file.gav22
   DEFINE   lc_gav23         LIKE gav_file.gav23
   DEFINE   lc_gav29         LIKE gav_file.gav29
   DEFINE   lc_gav31         LIKE gav_file.gav31
   DEFINE   lwin_curr        ui.Window
   DEFINE   lfrm_curr        ui.Form
   DEFINE   ls_table         STRING
   DEFINE   ls_field         STRING
   DEFINE   lc_ref_value     LIKE type_file.chr1000
   DEFINE   ls_sql           STRING
   DEFINE   lnode_item       om.DomNode
   DEFINE   lnode_value_list om.DomNode,
            lnode_value      om.DomNode,
            lst_value        om.NodeList 
   DEFINE   lnode_parent     om.DomNode
   DEFINE   li_curr          LIKE type_file.num5
   DEFINE   li_show_curr     LIKE type_file.num5
   DEFINE   li_offset        LIKE type_file.num5
   DEFINE   li_pagesize      LIKE type_file.num5
   DEFINE   ls_first_line    STRING
   DEFINE   li_result        LIKE type_File.num5
   DEFINe   ls_tabname       STRING
 
   #如果是空值就不尋找
   IF cl_null(pc_value) THEN
      RETURN TRUE
   END IF
 
   LET g_std_id = "std"     #No.FUN-760072
 
   IF NOT cl_null(ps_field) THEN
      CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
      LET g_fld_name = ps_field
   END IF
 
   IF cl_null(g_ui.g_refer_mtd) OR cl_null(g_ui.g_refer_fld) OR NOT cl_null(ps_field) THEN
      # 先看有沒有客製資料存在
      SELECT COUNT(UNIQUE gav01) INTO li_cnt FROM gav_file
       WHERE gav01 = g_frm_name AND gav08 = "Y"
      IF li_cnt > 0 THEN
         LET lc_custom = "Y"
      ELSE
         LET lc_custom = "N"
      END IF
      # 再看有沒有行業別資料存在
#     LET g_ui_setting = g_sma.sma124     #No.FUN-810089 mark
      SELECT gav22,gav23,gav29,gav31 INTO lc_gav22,lc_gav23,lc_gav29,lc_gav31 FROM gav_file
       WHERE gav01 = g_frm_name AND gav02 = g_fld_name AND gav08 = lc_custom
         AND gav11 = g_ui_setting
      IF SQLCA.sqlcode = 100 THEN
         SELECT gav22,gav23,gav29,gav31 INTO lc_gav22,lc_gav23,lc_gav29,lc_gav31 FROM gav_file
          WHERE gav01 = g_frm_name AND gav02 = g_fld_name AND gav08 = lc_custom
            AND gav11 = g_std_id
      END IF
      LET g_ui.g_refer_mtd = lc_gav29
      LET g_ui.g_refer_fld = lc_gav31
      LET g_ui.g_refer_dym = lc_gav22
      LET g_ui.g_refer_fun = lc_gav23
   END IF
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   #reference欄位節點
   LET ls_tabname = cl_get_table_name(g_ui.g_refer_fld)
   LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||g_ui.g_refer_fld)
   IF lnode_item IS NULL THEN
      LET lnode_item = lfrm_curr.findNode("FormField","formonly."||g_ui.g_refer_fld)
      IF lnode_item IS NULL THEN
         LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||g_ui.g_refer_fld)
         IF lnode_item IS NULL THEN
            LET lnode_Item = lfrm_curr.findNode("TableColumn","formonly."||g_ui.g_refer_fld)
            IF lnode_item IS NULL THEN
               LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||g_ui.g_refer_fld) #FUN-A70010
               IF lnode_item IS NULL THEN
                  LET lnode_Item = lfrm_curr.findNode("Matrix","formonly."||g_ui.g_refer_fld)  #FUN-A70010
               END IF
            END IF
         END IF
      END IF
   END IF
 
   IF g_ui.g_refer_mtd = "1" AND (NOT cl_null(g_ui.g_refer_dym)) THEN
      LET ls_table = g_ui.g_refer_dym.subString(1,g_ui.g_refer_dym.getIndexOf(".",1)-1)
      LET ls_field = g_ui.g_refer_dym.subString(g_ui.g_refer_dym.getIndexOf(".",1)+1,g_ui.g_refer_dym.getLength())
      LET ls_sql = "SELECT ",g_ui.g_refer_fld," FROM ",ls_table,
                   " WHERE ",ls_field,"='",pc_value,"'"
      PREPARE ref_pre FROM ls_sql
      EXECUTE ref_pre INTO lc_ref_value
 
      IF lnode_item IS NOT NULL THEN
         IF lnode_item.getTagName() = "TableColumn" THEN
            LET lnode_value_list = lnode_item.getLastChild()
            LET lst_value = lnode_value_list.selectByTagName("Value")
            LET lnode_parent = lnode_item.getParent()
            LET li_curr = lnode_parent.getAttribute("currentRow")
            LET li_offset = lnode_parent.getAttribute("offset")
            LET li_pagesize = lnode_parent.getAttribute("pageSize")
            LET li_show_curr = li_curr - li_offset + 1
            IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND 
               (li_show_curr != 0) THEN
               LET lnode_value = lst_value.item(li_show_curr)
               CALL lnode_value.setAttribute("value",lc_ref_value)
            END IF
         ELSE
            CALL lnode_item.setAttribute("value",lc_ref_value)
         END IF
      END IF
      CALL ui.Interface.refresh()
   END IF
 
   IF g_ui.g_refer_mtd = "2" AND (NOT cl_null(g_ui.g_refer_fun)) THEN
      LET g_ui.g_refer_fun = cl_replace_str(g_ui.g_refer_fun,"\n","")
      PREPARE refer_sql_pre FROM g_ui.g_refer_fun
      EXECUTE refer_sql_pre INTO lc_ref_value USING pc_value
      IF lnode_item IS NOT NULL THEN
         IF lnode_item.getTagName() = "TableColumn" THEN
            LET lnode_value_list = lnode_item.getLastChild()
            LET lst_value = lnode_value_list.selectByTagName("Value")
            LET lnode_parent = lnode_item.getParent()
            LET li_curr = lnode_parent.getAttribute("currentRow")
            LET li_offset = lnode_parent.getAttribute("offset")
            LET li_pagesize = lnode_parent.getAttribute("pageSize")
            LET li_show_curr = li_curr - li_offset + 1
            IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND 
               (li_show_curr != 0) THEN
               LET lnode_value = lst_value.item(li_show_curr)
               CALL lnode_value.setAttribute("value",lc_ref_value)
            END IF
         ELSE
            CALL lnode_item.setAttribute("value",lc_ref_value)
         END IF
      END IF
      CALL ui.Interface.refresh()
   END IF
 
   IF (g_ui.g_refer_mtd = "3" OR g_ui.g_refer_mtd = "4") AND
      (NOT cl_null(g_ui.g_refer_fun)) THEN
      LET ls_first_line = g_ui.g_refer_fun.subString(1,g_ui.g_refer_fun.getIndexOf("\n",1)-1)
      CASE
         WHEN ls_first_line.getIndexOf("fun01",1)
            CALL cl_validate_fun01(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun02",1)
            CALL cl_validate_fun02(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun03",1)
            CALL cl_validate_fun03(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun04",1)
            CALL cl_validate_fun04(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun05",1)
            CALL cl_validate_fun05(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun06",1)
            CALL cl_validate_fun06(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun07",1)
            CALL cl_validate_fun07(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun08",1)
            CALL cl_validate_fun08(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun09",1)
            CALL cl_validate_fun09(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun10",1)
            CALL cl_validate_fun10(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun11",1)
            CALL cl_validate_fun11(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun12",1)
            CALL cl_validate_fun12(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun13",1)
            CALL cl_validate_fun13(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun14",1)
            CALL cl_validate_fun14(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun15",1)
            CALL cl_validate_fun15(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun16",1)
            CALL cl_validate_fun16(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun17",1)
            CALL cl_validate_fun17(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun18",1)
            CALL cl_validate_fun18(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun19",1)
            CALL cl_validate_fun19(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun20",1)
            CALL cl_validate_fun20(pc_value) RETURNING li_result
      END CASE
   END IF
 
   RETURN TRUE
END FUNCTION
 
##################################################
# Descriptions...: 資料重複檢查
# Date & Author..: 2007/01/24 by saki
# Input Parameter: ps_field 欄位代碼
#                  pc_value 欄位值
# Return code....: TRUE/FALSE
##################################################
 
FUNCTION cl_repeat_check(ps_field,pc_value)
   DEFINE   ps_field         STRING
   DEFINE   pc_value         LIKE type_file.chr1000
   DEFINE   lc_custom        LIKE gav_file.gav08
   DEFINE   lc_gav26         LIKE gav_file.gav26
   DEFINE   lc_gav27         LIKE gav_file.gav27
   DEFINE   lc_gav30         LIKE gav_file.gav30
   DEFINE   ls_table         STRING
   DEFINE   ls_field         STRING
   DEFINE   ls_sql           STRING
   DEFINE   ls_first_line    STRING
   DEFINE   li_cnt           LIKE type_file.num5
   DEFINE   lc_gat03         LIKE gat_file.gat03
   DEFINE   li_result        LIKE type_File.num5
 
 
   #如果是空值就不檢查,空值利用必要欄位設定
   IF cl_null(pc_value) THEN
      RETURN TRUE
   END IF
 
   LET g_std_id = "std"     #No.FUN-760072
 
   IF NOT cl_null(ps_field) THEN
      CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
      LET g_fld_name = ps_field
   END IF
 
   IF cl_null(g_ui.g_rpt_mtd) OR NOT cl_null(ps_field) THEN
      # 先看有沒有客製資料存在
      SELECT COUNT(UNIQUE gav01) INTO li_cnt FROM gav_file
       WHERE gav01 = g_frm_name AND gav08 = "Y"
      IF li_cnt > 0 THEN
         LET lc_custom = "Y"
      ELSE
         LET lc_custom = "N"
      END IF
      # 再看有沒有行業別資料存在
#     LET g_ui_setting = g_sma.sma124     #No.FUN-810089 mark
      SELECT gav26,gav27,gav30 INTO lc_gav26,lc_gav27,lc_gav30 FROM gav_file
       WHERE gav01 = g_frm_name AND gav02 = g_fld_name AND gav08 = lc_custom
         AND gav11 = g_ui_setting
      IF SQLCA.sqlcode = 100 THEN
         SELECT gav26,gav27,gav30 INTO lc_gav26,lc_gav27,lc_gav30 FROM gav_file
          WHERE gav01 = g_frm_name AND gav02 = g_fld_name AND gav08 = lc_custom
            AND gav11 = g_std_id
      END IF
      LET g_ui.g_rpt_mtd = lc_gav26
      LET g_ui.g_rpt_dym = lc_gav27
      LET g_ui.g_rpt_fun = lc_gav30
   END IF
 
   LET li_result = TRUE
   IF g_ui.g_rpt_mtd = "1" AND (NOT cl_null(g_ui.g_rpt_dym)) THEN
      LET ls_table = g_ui.g_rpt_dym.subString(1,g_ui.g_rpt_dym.getIndexOf(".",1)-1)
      LET ls_field = g_ui.g_rpt_dym.subString(g_ui.g_rpt_dym.getIndexOf(".",1)+1,g_ui.g_rpt_dym.getLength())
      LET ls_sql = "SELECT COUNT(*) FROM ",ls_table,
                   " WHERE ",ls_field,"='",pc_value CLIPPED,"'"
      PREPARE rpt_pre FROM ls_sql
      EXECUTE rpt_pre INTO li_cnt
      IF li_cnt > 0 THEN
         LET li_result = FALSE
      END IF
   END IF
 
   IF g_ui.g_rpt_mtd = "2" AND (NOT cl_null(g_ui.g_rpt_fun)) THEN
      LET g_ui.g_rpt_fun = cl_replace_str(g_ui.g_rpt_fun,"\n","")
      PREPARE rpt_sql_pre FROM g_ui.g_rpt_fun
      EXECUTE rpt_sql_pre INTO li_cnt USING pc_value
      IF li_cnt > 0 THEN
         LET ls_table = g_ui.g_rpt_fun.subString(g_ui.g_rpt_fun.getIndexOf(" FROM ",1)+6,g_ui.g_rpt_fun.getIndexOf(" WHERE ",1)-1)
         LET li_result = FALSE
      END IF
   END IF
 
   IF (g_ui.g_rpt_mtd = "3" OR g_ui.g_rpt_mtd = "4") AND
      (NOT cl_null(g_ui.g_rpt_fun)) THEN
      LET ls_first_line = g_ui.g_rpt_fun.subString(1,g_ui.g_rpt_fun.getIndexOf("\n",1)-1)
      CASE
         WHEN ls_first_line.getIndexOf("fun01",1)
            CALL cl_validate_fun01(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun02",1)
            CALL cl_validate_fun02(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun03",1)
            CALL cl_validate_fun03(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun04",1)
            CALL cl_validate_fun04(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun05",1)
            CALL cl_validate_fun05(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun06",1)
            CALL cl_validate_fun06(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun07",1)
            CALL cl_validate_fun07(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun08",1)
            CALL cl_validate_fun08(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun09",1)
            CALL cl_validate_fun09(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun10",1)
            CALL cl_validate_fun10(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun11",1)
            CALL cl_validate_fun11(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun12",1)
            CALL cl_validate_fun12(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun13",1)
            CALL cl_validate_fun13(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun14",1)
            CALL cl_validate_fun14(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun15",1)
            CALL cl_validate_fun15(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun16",1)
            CALL cl_validate_fun16(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun17",1)
            CALL cl_validate_fun17(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun18",1)
            CALL cl_validate_fun18(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun19",1)
            CALL cl_validate_fun19(pc_value) RETURNING li_result
         WHEN ls_first_line.getIndexOf("fun20",1)
            CALL cl_validate_fun20(pc_value) RETURNING li_result
      END CASE
   END IF
 
   IF NOT li_result AND g_ui.g_rpt_mtd MATCHES '[12]' THEN
      LET ls_sql = "SELECT gat03 FROM gat_file ",
                   " WHERE gat01 = '",ls_table,"' AND gat02 = '",g_lang,"'"
      PREPARE pre2_gat03 FROM ls_sql
      EXECUTE pre2_gat03 INTO lc_gat03
      CALL cl_err_msg("","lib-400",pc_value CLIPPED||"|"||lc_gat03||"|"||ls_table,1)
   END IF
   RETURN li_result
END FUNCTION
 
##################################################
# Descriptions...: 欄位連查
# Date & Author..: 2007/01/24 by saki
# Input Parameter: ps_fldname 欄位代碼
# Return code....: void
##################################################
 
FUNCTION cl_qry_string(ps_fldname)
   DEFINE   ps_fldname       STRING
   DEFINE   lwin_curr        ui.Window
   DEFINE   lfrm_curr        ui.Form
   DEFINE   lnode_frm        om.DomNode
   DEFINE   ls_frmname       STRING
   DEFINE   li_cnt           LIKE type_file.num5
   DEFINE   lc_custom        LIKE gav_file.gav08
   DEFINE   lnode_root       om.DomNode
   DEFINE   llst_items       om.NodeList
   DEFINE   li_i             LIKE type_file.num10
   DEFINE   lnode_item       om.DomNode
   DEFINE   ls_sql           STRING
   DEFINE   lc_gav32         LIKE gav_file.gav32
   DEFINE   ls_i             STRING
   DEFINE   ls_btn_sn        STRING
   DEFINE   lnode_value_list om.DomNode,
            lnode_value      om.DomNode,
            lst_value        om.NodeList
   DEFINE   lnode_parent     om.DomNode
   DEFINE   li_curr          LIKE type_file.num5
   DEFINE   li_show_curr     LIKE type_file.num5
   DEFINE   li_offset        LIKE type_file.num5
   DEFINE   li_pagesize      LIKE type_file.num5
   DEFINE   ls_size          STRING
   DEFINE   lnode_button     om.DomNode
   DEFINE   ls_value         STRING
   DEFINE   ls_cmd           STRING
   DEFINE   ls_tabname       STRING
   DEFINE   ls_ui_setting    STRING    #No.FUN-760072
   DEFINE   ls_uifield_name  STRING    #No.FUN-760072
   DEFINE   li_prog_idxs     LIKE type_file.num5    #No.TQC-810061
   DEFINE   li_prog_idxe     LIKE type_file.num5    #No.TQC-810061
   DEFINE   ls_tmp           STRING                 #No.TQC-810061
   DEFINE   li_j             LIKE type_file.num5    #No:CHI-A40067
 
 
   IF cl_null(ps_fldname) THEN
      RETURN
   END IF
 
   LET g_std_id = "std"     #No.FUN-760072
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   IF lfrm_curr IS NULL THEN
      RETURN
   END IF
   LET lnode_frm = lfrm_curr.getNode()
   LET ls_frmname = lnode_frm.getAttribute("name")
   #No:CHI-A40067 --start--
   IF ls_frmname.subString(ls_frmname.getLength()-3,ls_frmname.getLength()) = ".tmp" THEN
      LET ls_frmname = ls_frmname.subString(1,ls_frmname.getLength()-4)
   END IF
#  IF ls_frmname.getIndexOf("T",1) THEN
   IF ls_frmname.subString(ls_frmname.getLength(),ls_frmname.getLength()) = "T" THEN
   #No:CHI-A40067 ---end---
      LET ls_frmname = ls_frmname.subString(1,ls_frmname.getIndexOf("T",1)-1)
   END IF
 
   #No:MOD-A10159 --start--
   IF cl_null(g_frm_name) THEN
      LET g_frm_name = ls_frmname
   END IF
   #No:MOD-A10159 ---end---

   # 先看有沒有客製資料存在
   SELECT COUNT(UNIQUE gav01) INTO li_cnt FROM gav_file
    WHERE gav01 = g_frm_name AND gav08 = "Y"
   IF li_cnt > 0 THEN
      LET lc_custom = "Y"
   ELSE
      LET lc_custom = "N"
   END IF
 
   IF ps_fldname = "detail" THEN
      #No.FUN-760072 --start--
#     LET lnode_root = ui.Interface.getRootNode()
#     LET llst_items = lnode_root.selectByTagName("TableColumn")
      LET llst_items = lnode_frm.selectByTagName("TableColumn")
      #No.FUN-760072 ---end---
      LET li_cnt = 1
      FOR li_i = 1 TO llst_items.getLength()
          LET lnode_item = llst_items.item(li_i)
          LET ps_fldname = lnode_item.getAttribute("colName")
          IF (ps_fldname IS NULL) THEN
             CONTINUE FOR
          END IF
 
          #No.FUN-760072 --start--
          LET lc_gav32 = ""

          #No:CHI-A40067 --start-- 先以程式內cl_reset_qry_btn設定為主
          FOR li_j = 1 TO gr_resetbtn.getLength()
              IF gr_resetbtn[li_j].field = ps_fldname THEN
                 LET lc_gav32 = gr_resetbtn[li_j].prog
                 EXIT FOR
              END IF
          END FOR
          #No:CHI-A40067 ---end---

          LET ls_uifield_name = ps_fldname
          IF lnode_item.getAttribute("tag") IS NOT NULL THEN
             LET ps_fldname = lnode_item.getAttribute("tag")
          END IF
          #No.FUN-760072 ---end---
          IF cl_null(lc_gav32) THEN      #No:CHI-A40067
             # 再看有沒有行業別資料存在
             LET ls_sql = "SELECT gav32 FROM gav_file ",
                          " WHERE gav01='",ls_frmname,"' AND gav02='",ps_fldname,"'",
                          "   AND gav08='",lc_custom,"' AND gav11='",g_sma.sma124 CLIPPED,"'"
             PREPARE user_t_pre FROM ls_sql
             EXECUTE user_t_pre INTO lc_gav32
             IF SQLCA.sqlcode = 100 THEN
                LET ls_sql = "SELECT gav32 FROM gav_file ",
                             " WHERE gav01='",ls_frmname,"' AND gav02='",ps_fldname,"'",
                             "   AND gav08='",lc_custom,"' AND gav11='",g_std_id CLIPPED,"'"
                PREPARE default_t_pre FROM ls_sql
                EXECUTE default_t_pre INTO lc_gav32
             #No.FUN-760072 --start--
             ELSE
                LET ls_ui_setting = g_sma.sma124
             #No.FUN-760072 ---end---
             END IF
             IF cl_null(lc_gav32) THEN
             #No.FUN-760072 --start-- p_per設定為主, 再來參考p_qry
                LET ls_sql = "SELECT gac15 FROM gac_file ",
                             " WHERE gac01='",ls_frmname,"' AND gac06='",ps_fldname,"' AND gac12='Y'"
                PREPARE gac15_c_pre FROM ls_sql
                EXECUTE gac15_c_pre INTO lc_gav32
                IF cl_null(lc_gav32) THEN
                   LET ls_sql = "SELECT gac15 FROM gac_file ",
                                " WHERE gac01='",ls_frmname,"' AND gac06='",ps_fldname,"' AND gac12='N'"
                   PREPARE gac15_p_pre FROM ls_sql
                   EXECUTE gac15_p_pre INTO lc_gav32
                   IF cl_null(lc_gav32) THEN
                      CONTINUE FOR
                   END IF
                END IF
             ELSE
                LET ls_ui_setting = g_std_id
             #No.FUN-760072 ---end---
             END IF
          END IF      #No:CHI-A40067
          #No.FUN-760072 --start-- 欄位隱藏不出現串查選項
          IF lnode_item.getAttribute("hidden") = "1" THEN
             CONTINUE FOR
          END IF
          #No.FUN-760072 ---end---
          LET gr_gavxx[li_cnt].gav02 = ps_fldname
          LET gr_gavxx[li_cnt].gav32 = lc_gav32
          LET gr_gavxx[li_cnt].uifield_name = ls_uifield_name
          LET li_cnt = li_cnt + 1
      END FOR
      IF gr_gavxx.getLength() <= 0 THEN
         RETURN
      ELSE
         LET ls_tabname = cl_get_table_name(gr_gavxx[1].gav02)
         LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||gr_gavxx[1].gav02 CLIPPED)
         IF lnode_item IS NULL THEN
            LET lnode_item = lfrm_curr.findNode("TableColumn","formonly."||gr_gavxx[1].gav02 CLIPPED)
            ###FUN-A70010 START ###
            IF lnode_item IS NULL THEN
               LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||gr_gavxx[1].gav02 CLIPPED)
               IF lnode_item IS NULL THEN
                  LET lnode_item = lfrm_curr.findNode("Matrix","formonly."||gr_gavxx[1].gav02 CLIPPED)
               END IF
            END IF
            ###FUN-A70010 END ###
         END IF
         IF lnode_item IS NOT NULL THEN
            LET lnode_parent = lnode_item.getParent()
            LET ls_size = lnode_parent.getAttribute("size")
            IF ls_size = "0" THEN
               RETURN
            END IF
         END IF
      END IF
 
      LET gw_win = ui.Window.getCurrent()
      LET gn_win = gw_win.getNode()
      MENU "qry" ATTRIBUTE(STYLE="popup")
         BEFORE MENU
             #求設定檔,列出列表,並改變btn名稱回傳fldname名稱
             #No:MOD-A40020 --start-- Use Genero 2.2 dialog hidden method
#            HIDE OPTION ALL
             FOR li_i = 1 TO 20
                 LET ls_i = li_i
                 LET ls_btn_sn = "btnb_" || ls_i
                 CALL DIALOG.setActionHidden(ls_btn_sn,TRUE)
             END FOR
             FOR li_i = 1 TO gr_gavxx.getLength()
                 LET ls_i = li_i
                 LET ls_btn_sn = "btnb_" || ls_i
#                SHOW OPTION ls_btn_sn
                 CALL DIALOG.setActionHidden(ls_btn_sn,FALSE)
             END FOR
             #No:MOD-A40020 ---end---
             CALL cl_setQryOption(ls_frmname,ls_ui_setting)   #No.FUN-760072 傳參數
 
         ON ACTION btnb_1
            LET ps_fldname = gr_gavxx[1].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[1].gav32
            EXIT MENU
 
         ON ACTION btnb_2
            LET ps_fldname = gr_gavxx[2].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[2].gav32
            EXIT MENU
 
         ON ACTION btnb_3
            LET ps_fldname = gr_gavxx[3].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[3].gav32
            EXIT MENU
 
         ON ACTION btnb_4
            LET ps_fldname = gr_gavxx[4].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[4].gav32
            EXIT MENU
 
         ON ACTION btnb_5
            LET ps_fldname = gr_gavxx[5].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[5].gav32
            EXIT MENU
 
         ON ACTION btnb_6
            LET ps_fldname = gr_gavxx[6].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[6].gav32
            EXIT MENU
 
         ON ACTION btnb_7
            LET ps_fldname = gr_gavxx[7].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[7].gav32
            EXIT MENU
 
         ON ACTION btnb_8
            LET ps_fldname = gr_gavxx[8].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[8].gav32
            EXIT MENU
 
         ON ACTION btnb_9
            LET ps_fldname = gr_gavxx[9].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[9].gav32
            EXIT MENU
 
         ON ACTION btnb_10
            LET ps_fldname = gr_gavxx[10].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[10].gav32
            EXIT MENU
 
         ON ACTION btnb_11
            LET ps_fldname = gr_gavxx[11].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[11].gav32
            EXIT MENU
 
         ON ACTION btnb_12
            LET ps_fldname = gr_gavxx[12].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[12].gav32
            EXIT MENU
 
         ON ACTION btnb_13
            LET ps_fldname = gr_gavxx[13].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[13].gav32
            EXIT MENU
 
         ON ACTION btnb_14
            LET ps_fldname = gr_gavxx[14].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[14].gav32
            EXIT MENU
 
         ON ACTION btnb_15
            LET ps_fldname = gr_gavxx[15].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[15].gav32
            EXIT MENU
 
         ON ACTION btnb_16
            LET ps_fldname = gr_gavxx[16].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[16].gav32
            EXIT MENU
 
         ON ACTION btnb_17
            LET ps_fldname = gr_gavxx[17].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[17].gav32
            EXIT MENU
 
         ON ACTION btnb_18
            LET ps_fldname = gr_gavxx[18].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[18].gav32
            EXIT MENU
 
         ON ACTION btnb_19
            LET ps_fldname = gr_gavxx[19].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[19].gav32
            EXIT MENU
 
         ON ACTION btnb_20
            LET ps_fldname = gr_gavxx[20].uifield_name       #No.FUN-760072
            LET lc_gav32 = gr_gavxx[20].gav32
            EXIT MENU
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
      END MENU
      IF INT_FLAG THEN
         LET INT_FLAG = FALSE
         RETURN
      END IF
 
      LET ls_tabname = cl_get_table_name(ps_fldname)
      LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||ps_fldname)
      IF lnode_item IS NULL THEN
         LET lnode_item = lfrm_curr.findNode("TableColumn","formonly."||ps_fldname)
         IF lnode_item IS NULL THEN
            LET lnode_item = lfrm_curr.findNode("TableColumn",ps_fldname)
            ###FUN-A70010 START ###
            IF lnode_item IS NULL THEN
               LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||ps_fldname)
               IF lnode_item IS NULL THEN
                  LET lnode_item = lfrm_curr.findNode("Matrix","formonly."||ps_fldname)
                  IF lnode_item IS NULL THEN
                     LET lnode_item = lfrm_curr.findNode("Matrix",ps_fldname)
                  END IF
               END IF
            END IF
            ###FUN-A70010 END ###
         END IF
      END IF
      IF lnode_item IS NOT NULL THEN
         LET lnode_value_list = lnode_item.getLastChild()
         LET lst_value = lnode_value_list.selectByTagName("Value")
         LET lnode_parent = lnode_item.getParent()
         LET li_curr = lnode_parent.getAttribute("currentRow")
         LET li_offset = lnode_parent.getAttribute("offset")
         LET li_pagesize = lnode_parent.getAttribute("pageSize")
         LET li_show_curr = li_curr - li_offset + 1
         IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND
            (li_show_curr != 0) THEN
            LET lnode_value = lst_value.item(li_show_curr)
            LET ls_value = lnode_value.getAttribute("value")
         END IF
      END IF
      IF cl_null(ls_value) THEN
         RETURN
      END IF
   ELSE
      LET lnode_button = lfrm_curr.findNode("Button",ps_fldname)
      IF lnode_button IS NOT NULL THEN
         LET ls_cmd = lnode_button.getAttribute("comment")
         #No.TQC-810061 --start--
         LET li_prog_idxs = 0
         LET li_prog_idxe = 0
         LET ls_tmp = ls_cmd
         WHILE ls_tmp.getIndexOf("[",li_prog_idxs+1)
            LET li_prog_idxs = ls_tmp.getIndexOf("[",li_prog_idxs+1)
         END WHILE
         LET ls_tmp = ls_cmd
         WHILE ls_tmp.getIndexOf("]",li_prog_idxe+1)
            LET li_prog_idxe = ls_tmp.getIndexOf("]",li_prog_idxe+1)
         END WHILE
         LET ls_cmd = ls_cmd.subString(li_prog_idxs+1,li_prog_idxe-1)
#        LET ls_cmd = ls_cmd.subString(ls_cmd.getIndexOf("[",1)+1,ls_cmd.getIndexOf("]",1)-1)
         #No.TQC-810061 ---end---
         LET lc_gav32 = ls_cmd
         LET lnode_item = lnode_button.getNext()
         LET ls_value = lnode_item.getAttribute("value")
         IF cl_null(ls_value) THEN
            RETURN
         END IF
      END IF
   END IF
   LET ls_cmd = lc_gav32 CLIPPED," '",ls_value,"' 'q'"
DISPLAY "Connect to...",ls_cmd
   CALL cl_cmdrun_wait(ls_cmd)
END FUNCTION
 
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 開窗查詢加入串查功能
# Date & Author..: 07/06/26 by saki
# Input Parameter: pc_frm_name
#                  pc_ui_setting
# Return code....: none
# Usage..........: CALL cl_setQryOption(ls_frmname,ls_ui_setting)
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_setQryOption(pc_frm_name,pc_ui_setting)      #No.FUN-760072
   DEFINE pc_frm_name     LIKE gae_file.gae01            #No.FUN-760072
   DEFINE pc_ui_setting   LIKE gae_file.gae12            #No.FUN-760072
   DEFINE ln_menu         om.DomNode,
          ln_menuAction   om.DomNode
   DEFINE ll_menu         om.NodeList,
          ll_menuAction   om.NodeList
   DEFINE li_i            LIKE type_file.num10,          #No.FUN-690005 INTEGER
          li_j            LIKE type_file.num10           #No.FUN-690005 INTEGER
   DEFINE ls_j            STRING
   DEFINE lc_gae04        LIKE gae_file.gae04
   DEFINE lc_gaz03        LIKE gaz_file.gaz03
   DEFINE ls_act_name     STRING                         #No.FUN-760072
 
 
   LET ll_menu = gn_win.selectByPath("//Menu[@text=\"qry\"]")
   LET ln_menu = ll_menu.item(1)
   IF ln_menu IS NULL THEN
      RETURN
   END IF
   LET ll_menuAction = ln_menu.selectByTagName("MenuAction")
   FOR li_i = 1 TO ll_menuAction.getLength()
       LET ln_menuAction = ll_menuAction.item(li_i)
       FOR li_j = 1 TO gr_gavxx.getLength()
           LET ls_j = li_j
           IF ln_menuAction.getAttribute("name") = "btnb_" || ls_j THEN
              LET lc_gae04 = ""    #No:MOD-A40020
              SELECT gae04 INTO lc_gae04 FROM gae_file
               WHERE gae01 = pc_frm_name AND gae02 = gr_gavxx[li_j].gav02 AND gae03 = g_lang AND gae12 = pc_ui_setting AND gae11='Y' #CHI-990046
              IF STATUS THEN #CHI-990046              
                 SELECT gae04 INTO lc_gae04 FROM gae_file
                  WHERE gae01 = pc_frm_name AND gae02 = gr_gavxx[li_j].gav02 AND gae03 = g_lang AND gae12 = pc_ui_setting AND gae11='Y' #CHI-990046
              END IF
              #No.FUN-760072 --start--
              SELECT gaq03 INTO lc_gae04 FROM gaq_file WHERE gaq01 = gr_gavxx[li_j].gav02 AND gaq02 = g_lang
              #No.FUN-760072 ---end---
              LET lc_gaz03 = ""    #No:MOD-A40020
              SELECT gaz03 INTO lc_gaz03 FROM gaz_file
               WHERE gaz01 = gr_gavxx[li_j].gav32 AND gaz02 = g_lang AND gaz05 = "Y"   #No:MOD-A10159 --modify condition
              #No:MOD-A10159 --start--
              IF cl_null(lc_gaz03) THEN
                 SELECT gaz03 INTO lc_gaz03 FROM gaz_file
                  WHERE gaz01 = gr_gavxx[li_j].gav32 AND gaz02 = g_lang AND gaz05 = "N"
              END IF
              #No:MOD-A10159 ---end---
              LET ls_act_name = lc_gae04 CLIPPED," - ",lc_gaz03 CLIPPED,"[",gr_gavxx[li_j].gav32,"]"  #No.FUN-760072
              CALL ln_menuAction.setAttribute("text",ls_act_name )    #No.FUN-760072
           END IF
       END FOR
   END FOR
END FUNCTION
 
# cl_get_table_name has been moved to cl_show_fld_cont #EXT-7A0042
 
#No.FUN-750068 --start--  #FUN-B50102
##################################################
# Descriptions...: 製造行業別Combobox的函式
# Date & Author..: 07/07/06 by saki
# Input Parameter: pc_fieldname
# Return code....: 
# Usage..........: CALL cl_set_combo_industry("azw03")
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_set_combo_industry(pc_fieldname)
   DEFINE   pc_fieldname STRING
   DEFINE   ls_sql       STRING
   DEFINE   lc_smb01     LIKE smb_file.smb01
   DEFINE   lc_smb03     LIKE smb_file.smb03
   DEFINE   ls_value     STRING
   DEFINE   ls_desc      STRING
 
   LET ls_sql = "SELECT UNIQUE smb01,smb03 FROM smb_file WHERE smb02='",g_lang CLIPPED,"'"
   PREPARE smb_pre FROM ls_sql
   DECLARE smb_curs CURSOR FOR smb_pre
   FOREACH smb_curs INTO lc_smb01,lc_smb03
      IF lc_smb01 = "std" THEN
         LET ls_value = lc_smb01 CLIPPED,",",ls_value
         LET ls_desc = lc_smb01 CLIPPED," : ",lc_smb03 CLIPPED,",",ls_desc
      ELSE
         LET ls_value = ls_value,lc_smb01 CLIPPED,","
         LET ls_desc = ls_desc,lc_smb01 CLIPPED," : ",lc_smb03 CLIPPED,","
      END IF
   END FOREACH
   CALL cl_set_combo_items(pc_fieldname,ls_value.subString(1,ls_value.getLength()-1),ls_desc.subString(1,ls_desc.getLength()-1))
END FUNCTION
#No.FUN-750068 ---end---

##################################################
# Descriptions...: 重新設定共用畫面的串查程式
# Date & Author..: 2010/05/17 by saki
# Input Parameter: ps_fieldnames 須重新設定串查的欄位代碼, Ex. oga011,oga16
#                  ps_qryprogs   串查程式, Ex. axmt610,axmt410
# Return code....: void
# Memo...........: #No:CHI-A40067
#                : CALL cl_reset_qry_btn("oga011,oga16","axmt610,axmt410")
##################################################
FUNCTION cl_reset_qry_btn(ps_fieldnames,ps_qryprogs)
   DEFINE   ps_fieldnames  STRING
   DEFINE   ps_qryprogs    STRING
   DEFINE   li_i           LIKE type_file.num5
   DEFINE   lst_strs       base.StringTokenizer
   DEFINE   ls_str         STRING
   DEFINE   lwin_curr      ui.Window
   DEFINE   lfrm_curr      ui.Form
   DEFINE   ls_tabname     STRING
   DEFINE   lnode_item     om.DomNode
   DEFINE   lnode_child    om.DomNode

   LET li_i = 1
   LET lst_strs = base.StringTokenizer.create(ps_fieldnames,",")
   WHILE lst_strs.hasMoreTokens()
      LET ls_str = lst_strs.nextToken()
      LET ls_str = ls_str.trim()
      LET gr_resetbtn[li_i].field = ls_str
      LET li_i = li_i + 1
   END WHILE

   LET li_i = 1
   LET lst_strs = base.StringTokenizer.create(ps_qryprogs,",")
   WHILE lst_strs.hasMoreTokens()
      LET ls_str = lst_strs.nextToken()
      LET ls_str = ls_str.trim()
      LET gr_resetbtn[li_i].prog = ls_str
      LET li_i = li_i + 1
   END WHILE

   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()

   FOR li_i = 1 TO gr_resetbtn.getLength()
       LET ls_tabname = cl_get_table_name(gr_resetbtn[li_i].field)
       LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||gr_resetbtn[li_i].field)
       IF lnode_item IS NULL THEN
          LET lnode_item = lfrm_curr.findNode("FormField","formonly."||gr_resetbtn[li_i].field)
          IF lnode_item IS NULL THEN
             CONTINUE FOR
          END IF
       END IF
       LET lnode_child = lnode_item.getFirstChild()
       IF lnode_child IS NULL THEN
          CALL cl_setButton(lnode_item,gr_resetbtn[li_i].prog,1,0) RETURNING lnode_item
       ELSE
          CALL cl_setButton(lnode_item,gr_resetbtn[li_i].prog,lnode_child.getAttribute("posX")-1,lnode_child.getAttribute("posY")) RETURNING lnode_item
       END IF
   END FOR
END FUNCTION
