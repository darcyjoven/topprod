# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: cl_show_fld_cont.4gl.4gl
# Descriptions...: 設定p_per內有特殊格式設定的欄位
# Date & Author..: 05/05/12 by saki
# Memo...........: 將原本的cl_show_rate_comment改寫成field所有資料顯示共用
#                 所有在p_per的格式設定都用|分隔, 可設定
#                 加入新的特殊設定要到cl_field_format做修改
#             
#                 1. 匯率顯示: rate(幣別欄位)
#                 2. textEdit明細顯示: show_fd_desc
#                 3. 金額逗號: amt --不在此function控制
#                 4. 物件多語系名稱: show_itme(參照table,參照欄名,key序列,per檔上欄位名稱)
#                 5. 多單位欄位顯示: multi_unit(數量二欄位,單位二欄位,換算率二欄位,數量一欄位,單位一欄位,換算率一欄位,採購單位欄位,料件編號欄位)
#
# Usage..........: CALL cl_show_fld_cont()
# Modify.........: 05/06/17 FUN-560077 alex 單身顯示修整
# Modify.........: No.FUN-560197 05/06/22 By saki 增加雙單位開窗及hint顯示
# Modify.........: No.FUN-560243 05/06/28 By saki check參數檔才顯示多單位詳細資料
# Modify.........: No.FUN-560270 05/06/30 By saki 逗號顯示獨立成function
# Modify.........: No.MOD-5A0288 05/10/19 By saki cl_show_multi_unit_comment()中先抓客製資料,將客製碼調為共用
# Modify.........: No.TQC-640080 06/04/08 By Alexstar 取消"去除搜尋主鍵前後欄位空白"的功能
# Modify.........: No.FUN-640184 06/04/12 By Echo 自動執行確認功能
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-6C0060 06/12/13 By alexstar 多語言功能單純化
# Modify.........: No.FUN-720042 07/03/02 By saki 因應4fd使用, findNode搜尋修改
# Modify.........: No.FUN-710055 07/03/13 By saki 行業別功能
# Modify.........: No.TQC-740146 07/04/24 By Echo 判斷是否背景作業，條件需再加上 g_gui_type 
# Modify.........: NO:EXT-7A0042 07/09/20 By alexstar Change Execute to FOREACH,and move cl_get_table_name to cl_show_fld_cont
# Modify.........: No.FUN-7B0028 07/11/12 By alex 修訂註解以配合自動抓取機制
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-810061 08/01/17 By saki 串查Button的隱藏
# Modify.........: No.FUN-810089 08/03/05 By saki 行業別架構修正
# Modify.........: No.FUN-A10029 10/01/06 By alex 抓取formname 含.tmp字樣時自動刪除
# Modify.........: No.TQC-A10100 10/01/11 By ELLE 修改all_syscolumns為syscolumns_file
# Modify.........: No:FUN-A70010 10/07/05 By tsai_yen 增加尋找ScrollGrid的Matrix屬性的元件
# Modify.........: No.TQC-A70031 10/07/06 By alex 修改syscolumns_file為tiptop_columns
# Modify.........: No.FUN-AA0017 10/10/19 By alex 增加ASE處理function
# Modify.........: No.FUN-A90024 10/11/05 By Jay 新調整各DB利用sch_file取得table與field等資訊 
# Modify.........: No.FUN-B50102 11/05/17 By tsai_yen 函式說明
# Modify.........: No:FUN-B60104 11/06/21 By saki 使用tiptop.4ad隱藏串查Action
# Modify.........: No:DEV-C50001 12/06/28 By joyce 補過之前個資未過單項目
# Modify.........: No:MOD-DA0032 13/10/08 By SunLM 如果该数字串中包含“.”，则走入去除小数点后0的逻辑

DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
#No.TQC-810061 --start--
GLOBALS
   DEFINE   mi_btn_sn           LIKE type_file.num5
   DEFINE   mi_table_flag       LIKE type_file.num5
   DEFINE   mi_btnb_flag        LIKE type_file.num5
   #No.TQC-810061 --start--
   DEFINE   mr_btnb                     DYNAMIC ARRAY OF RECORD
               form_name                LIKE gae_file.gae01,
               table_flag               LIKE type_file.num5,
               btnb_flag                LIKE type_file.num5 
                                        END RECORD
   #No.TQC-810061 ---end---
END GLOBALS
#No.TQC-810061 ---end---
 
DEFINE   gf_form     ui.Form
DEFINE   g_cust_flag LIKE type_file.chr1            #No.MOD-5A0288  #No.FUN-690005 VARCHAR(1)
 

#FUN-B50102 函式說明
##################################################
# Descriptions...: 抓取p_per設定以更動畫面顯示
# Date & Author..: 2005/05/12 By saki
# Input Parameter: none
# Return code....: none
# Usage..........: CALL cl_show_fld_cont()
# Memo...........: 
# Modify.........: No.FUN-7B0028 07/11/12 alex 修訂註解以配合自動抓取機制
##################################################
FUNCTION cl_show_fld_cont()
   DEFINE lnode_root      om.DomNode
   DEFINE lwin_curr       ui.Window
   DEFINE lnode_frm       om.DomNode
   DEFINE ls_formName     STRING
   DEFINE lc_gav01        LIKE gav_file.gav01
   DEFINE li_gav_cnt      LIKE type_file.num10      #No.FUN-690005 INTEGER
   DEFINE lc_gav02        LIKE gav_file.gav02,
          lc_gav06        LIKE gav_file.gav06
   DEFINE lst_format      base.StringTokenizer
   DEFINE ls_format       STRING
   DEFINE lnode_item      om.DomNode
   DEFINE ls_curr         STRING
   DEFINE li_inx_s        LIKE type_file.num5,       #No.FUN-690005 SMALLINT,
          li_inx_e        LIKE type_file.num5        #No.FUN-690005 SMALLINT
   DEFINE ls_substring    STRING                #No.FUN-550077
   DEFINE ls_field_list   STRING                #No.FUN-560197
   DEFINE ls_tabname      STRING                #No.FUN-720042
   #No.TQC-810061 --start--
   DEFINE li_cnt          LIKE type_file.num5
   DEFINE lnode_button    om.DomNode
   DEFINE ls_btn_name     STRING
   DEFINE ls_btn_hidden   STRING
   #No.TQC-810061 ---end---
 
 
   #FUN-640184
   #IF g_bgjob = 'Y' THEN
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN    #TQC-740146
      RETURN
   END IF
   #END FUN-640184

   #資料遮罩
   CALL cl_set_data_mask()
   CALL cl_set_data_mask_detail("b")
 
   LET lnode_root = ui.Interface.getRootNode()
   LET lwin_curr = ui.Window.getCurrent()
   LET gf_form = lwin_curr.getForm()
   IF gf_form IS NULL THEN
      RETURN
   END IF
   #No.TQC-810061 --start-- 移動位置
   LET lnode_frm = gf_form.getNode()
   LET ls_formName = lnode_frm.getAttribute("name")
   IF ls_formName.subString(ls_formName.getLength()-3,ls_formName.getLength()) = ".tmp" THEN
      LET ls_formName = ls_formName.subString(1,ls_formName.getLength()-4)   #FUN-A10029
   END IF
   IF ls_formName.subString(ls_formName.getLength(),ls_formName.getLength()) = "T" THEN
      LET ls_formName = ls_formName.subString(1,ls_formName.getLength()-1)
   END IF
   #No.TQC-810061 ---end---

   #No:FUN-B60104 --mark start-- 
   #No.TQC-810061 --start--
#  FOR li_cnt = 1 TO mr_btnb.getLength()
#      IF mr_btnb[li_cnt].form_name = ls_formName THEN
#         IF NOT mr_btnb[li_cnt].table_flag OR NOT mr_btnb[li_cnt].btnb_flag THEN
#            CALL cl_set_act_visible("btn_detail",FALSE)
#         ELSE
#            CALL cl_set_act_visible("btn_detail",TRUE)
#         END IF
#      END IF
#  END FOR
#
#  FOR li_cnt = 1 TO 20
#      LET ls_btn_name = "btn_",li_cnt USING '&&'
#      LET lnode_button = gf_form.findNode("Button",ls_btn_name)
#      IF lnode_button IS NULL THEN
#         LET ls_btn_hidden = ls_btn_hidden,ls_btn_name,","
#      END IF
#  END FOR
#  CALL cl_set_act_visible(ls_btn_hidden.subString(1,ls_btn_hidden.getLength()-1),FALSE)
   #No.TQC-810061 ---end---
   #No:FUN-B60104 ---mark end---
 
   LET li_inx_s = ls_formName.getIndexOf("T", 1)
   IF li_inx_s != 0 THEN
      LET ls_formName = ls_formName.subString(1, li_inx_s - 1)
   END IF
   LET lc_gav01 = ls_formName
 
   SELECT COUNT(*) INTO li_gav_cnt FROM gav_file
    WHERE gav01 = lc_gav01 AND gav08 = 'Y' AND gav11 = g_ui_setting   #No.FUN-710055  #No.FUN-810089 cl_ui_locale會得到g_ui_setting
   IF li_gav_cnt > 0 THEN
      LET g_cust_flag = "Y"      #No.MOD-5A0288
   ELSE
      LET g_cust_flag = "N"      #No.MOD-5A0288
   END IF
   
   DECLARE gav_curs CURSOR FOR
      SELECT gav02,gav06 FROM gav_file
       WHERE gav06 IS NOT NULL AND gav01 = lc_gav01 AND gav08 = g_cust_flag AND gav11 = g_sma.sma124  #No.FUN-710055
   FOREACH gav_curs INTO lc_gav02,lc_gav06
 
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
 
      # lnode_item為被設定顯示格式的欄位節點
      LET ls_tabname = cl_get_table_name(lc_gav02 CLIPPED)    #No.FUN-720042
      LET lnode_item = gf_form.findNode("FormField",ls_tabname||"."||lc_gav02 CLIPPED)  #No.FUN-720042
      IF lnode_item IS NULL THEN
         LET lnode_item = gf_form.findNode("TableColumn",ls_tabname||"."||lc_gav02 CLIPPED)  #No.FUN-720042
         IF lnode_item IS NULL THEN
            LET lnode_item = gf_form.findNode("Matrix",ls_tabname||"."||lc_gav02 CLIPPED)  #FUN-A70010
            IF lnode_item IS NULL THEN
               LET lnode_item = gf_form.findNode("FormField","formonly." || lc_gav02 CLIPPED)
               IF lnode_item IS NULL THEN
                  LET lnode_item = gf_form.findNode("TableColumn","formonly." || lc_gav02 CLIPPED)
                  IF lnode_item IS NULL THEN
                     LET lnode_item = gf_form.findNode("Matrix","formonly." || lc_gav02 CLIPPED) #FUN-A70010
                  END IF
               END IF
            END IF
         END IF
      END IF
 
      #No.FUN-570193 --start--
      IF lnode_item IS NULL THEN
         CONTINUE FOREACH
      END IF
      #No.FUN-570193 ---end---
 
      LET lst_format = base.StringTokenizer.create(lc_gav06,"|")
      WHILE lst_format.hasMoreTokens()
         LET ls_format = lst_format.nextToken()
         LET ls_format = ls_format.trim()
         LET ls_format = ls_format.toLowerCase()
 
         # p_per特殊格式設定rate(幣別欄位)時
         LET li_inx_s = ls_format.getIndexOf("rate(",1)
         IF li_inx_s != 0 THEN
            LET li_inx_e = ls_format.getIndexOf(")",li_inx_s + 5)
            LET ls_curr = ls_format.subString(li_inx_s + 5,li_inx_e - 1)
            IF ((lnode_item IS NOT NULL) AND (ls_curr IS NOT NULL)) THEN
               CALL cl_show_rate_comment(lnode_item,ls_curr)
            END IF
         END IF
 
         # p_per特殊格式設定show_fd_desc時(顯示textEdit詳細內容)
         LET li_inx_s = ls_format.getIndexOf("show_fd_desc",1)
         IF li_inx_s != 0 THEN
            CALL cl_show_textEdit_comment(lnode_item)
         END IF
 
#        # FUN-550077 物件名稱採多語系顯示功能
         IF g_aza.aza44 = "Y" THEN    #No.FUN-710055
            LET li_inx_s = ls_format.getIndexOf("show_itme(",1)
            LET ls_substring = ls_format.substring(li_inx_s+10,ls_format.getLength())
            LET ls_substring = ls_substring.substring(1,ls_substring.getIndexOf(")",1)-1)
            IF li_inx_s != 0 THEN
               CALL cl_show_itme_comment(lnode_item,ls_substring)
            END IF
         END IF
 
         #No.FUN-560197 多單位顯示
         IF g_sma.sma115 = "Y" THEN                    #No.FUN-560243
            LET li_inx_s = ls_format.getIndexOf("multi_unit(",1)
            IF li_inx_s != 0 THEN
               LET li_inx_e = ls_format.getIndexOf(")",li_inx_s + 5)
               LET ls_field_list = ls_format.subString(li_inx_s + 11,li_inx_e - 1)
               CALL cl_show_multi_unit_comment(lnode_item,ls_field_list)
            END IF
         END IF
      END WHILE
   END FOREACH
END FUNCTION

 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 顯示匯率比率
# Date & Author..: 2005/01/03 By saki
# Input Parameter: pnode_item     匯率欄位節點
#                  ps_curr        幣別欄位名稱
# Return code....: none
# Usage..........: CALL cl_show_rate_comment(pnode_item,ps_curr)
# Memo...........: 
# Modify.........: 
##################################################
FUNCTION cl_show_rate_comment(pnode_item,ps_curr)
   DEFINE pnode_item       om.DomNode
   DEFINE ps_curr          STRING
   DEFINE lnode_curr       om.DomNode
   DEFINE ls_item_tag      STRING
   DEFINE ls_curr_tag      STRING
   DEFINE lnode_value_list om.DomNode,
          lnode_value      om.DomNode,
          lst_value        om.NodeList 
   DEFINE lnode_parent     om.DomNode
   DEFINE lnode_child      om.DomNode
   DEFINE li_curr          LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE li_show_curr     LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE li_offset        LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE li_pagesize      LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE lc_curr_val      LIKE ade_file.ade04       #No.FUN-690005 VARCHAR(04)
   DEFINE ls_node_val      STRING
   DEFINE ls_rate_comt     STRING
   DEFINE ls_node_comt     STRING
   DEFINE li_inx_e         LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE ls_tabname       STRING                    #No.FUN-720042
 
 
   # lnode_curr為幣別欄位節點
   LET ls_tabname = cl_get_table_name(ps_curr)       #No.FUN-720042
   LET lnode_curr = gf_form.findNode("FormField",ls_tabname||"."||ps_curr)
   IF lnode_curr IS NULL THEN
      LET lnode_curr = gf_form.findNode("TableColumn",ls_tabname||"."||ps_curr)
      IF lnode_curr IS NULL THEN
         LET lnode_curr = gf_form.findNode("Matrix",ls_tabname||"."||ps_curr) #FUN-A70010
         IF lnode_curr IS NULL THEN
            LET lnode_curr = gf_form.findNode("FormField","formonly." || ps_curr)
            IF lnode_curr IS NULL THEN
               LET lnode_curr = gf_form.findNode("TableColumn","formonly." || ps_curr)
               IF lnode_curr IS NULL THEN
                  LET lnode_curr = gf_form.findNode("Matrix","formonly." || ps_curr)  #FUN-A70010
               END IF
            END IF
         END IF
      END IF
   END IF
 
   IF ((pnode_item IS NOT NULL) AND (lnode_curr IS NOT NULL)) THEN
      LET ls_item_tag = pnode_item.getTagName()
      LET ls_curr_tag = lnode_curr.getTagName()
      # 抓取幣別目前的value
      IF ls_curr_tag.equals("TableColumn") THEN
         LET lnode_value_list = lnode_curr.getLastChild()
         LET lst_value = lnode_value_list.selectByTagName("Value")
         LET lnode_parent = lnode_curr.getParent()
         LET li_curr = lnode_parent.getAttribute("currentRow")
         LET li_offset = lnode_parent.getAttribute("offset")
         LET li_pagesize = lnode_parent.getAttribute("pageSize")
         LET li_show_curr = li_curr - li_offset + 1
         IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND 
            (li_show_curr != 0) THEN
            LET lnode_value = lst_value.item(li_show_curr)
            LET lc_curr_val = lnode_value.getAttribute("value")
         END IF
      ELSE
         LET lc_curr_val = lnode_curr.getAttribute("value")
      END IF
 
      IF ls_item_tag.equals("TableColumn") THEN
         LET lnode_value_list = pnode_item.getLastChild()
         LET lst_value = lnode_value_list.selectByTagName("Value")
         LET lnode_parent = pnode_item.getParent()
         LET li_curr = lnode_parent.getAttribute("currentRow")
         LET li_offset = lnode_parent.getAttribute("offset")
         LET li_pagesize = lnode_parent.getAttribute("pageSize")
         LET li_show_curr = li_curr - li_offset + 1
         IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND 
            (li_show_curr != 0) THEN
            LET lnode_value = lst_value.item(li_show_curr)
            LET ls_node_val = lnode_value.getAttribute("value")
         END IF
      ELSE
         LET ls_node_val = pnode_item.getAttribute("value")
      END IF
 
      LET lnode_child = pnode_item.getFirstChild()
      LET ls_node_comt = lnode_child.getAttribute("comment")
      LET li_inx_e = ls_node_comt.getIndexOf("--(",1)
      IF li_inx_e != 0 THEN
         LET ls_node_comt = ls_node_comt.subString(1,li_inx_e - 2)
      END IF
 
      # 確認幣別與匯率欄位的value都存在才可顯示comment
      IF (NOT cl_null(lc_curr_val)) AND (NOT cl_null(ls_node_val)) THEN
         LET ls_rate_comt = NULL
         CALL cl_getRateComment(lc_curr_val,ls_node_val) RETURNING ls_rate_comt
         LET ls_node_comt = ls_node_comt," --(",ls_rate_comt.trim(),")--"
         CALL lnode_child.setAttribute("comment",ls_node_comt)
      ELSE
         CALL lnode_child.setAttribute("comment",ls_node_comt)
      END IF
   END IF
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 計算匯率比率
# Date & Author..: 2005/01/03 By saki
# Input Parameter: p_curr   單位
#                  p_rate   匯率
# Return code....: l_rate   STRING
# Usage..........: CALL cl_getRateComment(p_curr,p_rate)
# Memo...........: 
# Modify.........: 
##################################################
FUNCTION cl_getRateComment(p_curr,p_rate)
   DEFINE p_curr      LIKE ade_file.ade04     #No.FUN-690005 VARCHAR(04)
   DEFINE p_rate      LIKE abb_file.abb25     #No.FUN-690005 DECIMAL(20,10)
   DEFINE l_rate      STRING
   DEFINE l_a1        LIKE abb_file.abb25     #No.FUN-690005 DECIMAL(20,10)
   DEFINE l_a2        LIKE abb_file.abb25     #No.FUN-690005 DECIMAL(20,10)
   DEFINE l_azi10     LIKE azi_file.azi10
   DEFINE l_azi07     LIKE azi_file.azi07
   DEFINE l_azi02     LIKE azi_file.azi02
   DEFINE l_tmprate   STRING                #FUN-550077
 
   IF cl_null(p_rate) THEN
      LET p_rate = 0
   END IF
 
   LET l_azi10 = NULL
   LET l_a1 = 0
   LET l_a2 = 0
   LET l_rate = NULL
 
   SELECT azi02,azi07,azi10 INTO l_azi02,l_azi07,l_azi10
     FROM azi_file WHERE azi01 = p_curr 
   IF (SQLCA.SQLCODE) OR (l_azi10 IS NULL) OR (l_azi10 = " ") THEN
      LET l_azi10 = "1"
   END IF
 
   CASE
      WHEN l_azi10 = "1"    #乘
         LET l_a1 = 1
         LET l_a2 = p_rate * l_a1
         LET l_a2 = cl_digcut(l_a2,l_azi07)
             
      WHEN l_azi10 = "2"    #除
         LET l_a2 = 1
         LET l_a1 = l_a2 / p_rate
         LET l_a1 = cl_digcut(l_a1,l_azi07)
   END CASE
 
#  LET l_rate = p_curr CLIPPED," ",l_a1," : ",g_aza.aza17 CLIPPED," ",l_a2
#  #FUN-550077
   LET l_tmprate = l_a1
   LET l_rate = p_curr CLIPPED," ",l_tmprate.trim()
   LET l_tmprate = l_a2
   LET l_rate = l_rate.trim()," : ",g_aza.aza17 CLIPPED," ",l_tmprate.trim()
 
   RETURN l_rate
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 顯示textEdit詳細內容
# Date & Author..: 2005/05/12 By saki
# Input Parameter: pnode_item     顯示欄位節點
# Return code....: none
# Usage..........: CALL cl_show_textEdit_comment(pnode_item)
# Memo...........:
# Modify.........: No.FUN-540019 05/04/26 by saki 增加show_fd_desc設定顯示TEXTEDIT的內容
##################################################
FUNCTION cl_show_textEdit_comment(pnode_item)
   DEFINE pnode_item       om.DomNode
   DEFINE ls_item_tag      STRING
   DEFINE lnode_value_list om.DomNode,
          lnode_value      om.DomNode,
          lst_value        om.NodeList 
   DEFINE lnode_parent     om.DomNode
   DEFINE lnode_child      om.DomNode
   DEFINE li_curr          LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE li_show_curr     LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE li_offset        LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE li_pagesize      LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE ls_node_val      STRING
   DEFINE ls_node_comt     STRING
   DEFINE li_inx_e         LIKE type_file.num5       #No.FUN-690005 SMALLINT
 
 
   IF (pnode_item IS NOT NULL) THEN
      LET ls_item_tag = pnode_item.getTagName()
 
      IF ls_item_tag.equals("TableColumn") THEN
         LET lnode_value_list = pnode_item.getLastChild()
         LET lst_value = lnode_value_list.selectByTagName("Value")
         LET lnode_parent = pnode_item.getParent()
         LET li_curr = lnode_parent.getAttribute("currentRow")
         LET li_offset = lnode_parent.getAttribute("offset")
         LET li_pagesize = lnode_parent.getAttribute("pageSize")
         LET li_show_curr = li_curr - li_offset + 1
         IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND 
            (li_show_curr != 0) THEN
            LET lnode_value = lst_value.item(li_show_curr)
            LET ls_node_val = lnode_value.getAttribute("value")
         END IF
      ELSE
         LET ls_node_val = pnode_item.getAttribute("value")
      END IF
 
      LET lnode_child = pnode_item.getFirstChild()
      LET ls_node_comt = lnode_child.getAttribute("comment")
      LET li_inx_e = ls_node_comt.getIndexOf(" \n --(",1)
      IF li_inx_e != 0 THEN
         LET ls_node_comt = ls_node_comt.subString(1,li_inx_e - 1)
      END IF
      
      IF (NOT cl_null(ls_node_val)) THEN
         LET ls_node_comt = ls_node_comt," \n --(",ls_node_val.trim(),")--"
         CALL lnode_child.setAttribute("comment",ls_node_comt)
      ELSE
         CALL lnode_child.setAttribute("comment",ls_node_comt)
      END IF
   END IF
END FUNCTION
 
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 顯示不同語系的名稱資料
# Date & Author..: 2005/05/20 By alex
# Input Parameter: pnode_item     物件名稱欄位節點
#                  ls_condiction  條件值 (以,分隔)
# Return code....: none
# Usage..........: CALL cl_show_itme_comment(pnode_item,ls_condiction)
# Memo...........:
# Modify.........: FUN-550077
##################################################
FUNCTION cl_show_itme_comment(pnode_item,ls_condiction)
 
   DEFINE pnode_item       om.DomNode
   DEFINE lnode_item       om.DomNode
   DEFINE lnode_child      om.DomNode
   DEFINE ls_condiction    STRING
   DEFINE ls_show_field    STRING
   DEFINE ls_item_tag      STRING
   DEFINE ls_node_comt     STRING
   DEFINE ls_node_val      STRING
   DEFINE li_inx_e,li_i    LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE lc_gbc           RECORD LIKE gbc_file.*
   DEFINE ls_gbc03         STRING
   DEFINE lnode_value_list om.DomNode,
          lnode_value      om.DomNode,
          lst_value        om.NodeList 
   DEFINE lnode_parent     om.DomNode
   DEFINE li_curr          LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE li_show_curr     LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE li_offset        LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE li_pagesize      LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE lc_valuetype     LIKE type_file.chr2        #No.FUN-690005 VARCHAR(2)
   DEFINE ls_tabname       STRING                    #No.FUN-720042
 
   #No.FUN-710055 --mark--
#  IF g_aza.aza44<>"Y" THEN
#     RETURN
#  END IF
   #No.FUN-710055 --mark--
 
   IF (pnode_item IS NOT NULL) THEN
      LET ls_item_tag = pnode_item.getTagName()
      LET lnode_child = pnode_item.getFirstChild()
      LET ls_node_comt = lnode_child.getAttribute("comment")
      LET li_inx_e = ls_node_comt.getIndexOf("\n ---(",1)
      IF li_inx_e != 0 THEN
         LET ls_node_comt = ls_node_comt.subString(1,li_inx_e - 1)
      END IF
 
      LET li_inx_e = ls_condiction.getIndexOf(",",1)
      LET lc_gbc.gbc01 = ls_condiction.subString(1,li_inx_e-1)
 
      LET ls_condiction= ls_condiction.subString(li_inx_e+1,ls_condiction.getLength())
      LET li_inx_e = ls_condiction.getIndexOf(",",1)
      LET lc_gbc.gbc02 = ls_condiction.subString(1,li_inx_e-1)
 
      LET ls_condiction= ls_condiction.subString(li_inx_e+1,ls_condiction.getLength())
      LET li_inx_e = ls_condiction.getIndexOf(",",1)
      LET ls_show_field= ls_condiction.subString(1,li_inx_e-1)
 
      LET ls_condiction= ls_condiction.subString(li_inx_e+1,ls_condiction.getLength())
 
      # lnode_item為被設定顯示格式的欄位節點
      LET ls_tabname = cl_get_table_name(ls_show_field.trim())     #No.FUN-720042
      LET lnode_item = gf_form.findNode("FormField",ls_tabname||"."||ls_show_field.trim()) #No.FUN-720042
      IF lnode_item IS NULL THEN
         LET lnode_item = gf_form.findNode("TableColumn",ls_tabname||"."||ls_show_field.trim()) #No.FUN-720042
         IF lnode_item IS NULL THEN
            LET lnode_item = gf_form.findNode("Matrix",ls_tabname||"."||ls_show_field.trim()) #FUN-A70010
            IF lnode_item IS NULL THEN
               LET lnode_item = gf_form.findNode("FormField","formonly." || ls_show_field.trim())
               IF lnode_item IS NULL THEN
                  LET lnode_item = gf_form.findNode("TableColumn","formonly." || ls_show_field.trim())
                  IF lnode_item IS NULL THEN
                     LET lnode_item = gf_form.findNode("Matrix","formonly." || ls_show_field.trim())   #FUN-A70010
                  END IF
               END IF
            END IF
         END IF
      END IF
 
      #No.FUN-570193 --start--
      IF lnode_item IS NULL THEN
         RETURN
      END IF
      #No.FUN-570193 ---end---
 
      LET ls_item_tag = lnode_item.getTagName()
      IF ls_item_tag.equals("TableColumn") THEN
         LET lnode_value_list = lnode_item.getLastChild()
         LET lst_value = lnode_value_list.selectByTagName("Value")
         LET lnode_parent = pnode_item.getParent()
         LET li_curr = lnode_parent.getAttribute("currentRow")
         LET li_offset = lnode_parent.getAttribute("offset")
         LET li_pagesize = lnode_parent.getAttribute("pageSize")
         LET li_show_curr = li_curr - li_offset + 1
         IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND
            (li_show_curr != 0) THEN
            LET lnode_value = lst_value.item(li_show_curr)
            LET ls_gbc03 = lnode_value.getAttribute("value")
         END IF
      ELSE
         LET ls_gbc03 = lnode_item.getAttribute("value")
      END IF
 
      LET ls_node_val = ""
     #LET lc_gbc.gbc03 = ls_gbc03.trim()
      LET lc_gbc.gbc03 = ls_gbc03               #TQC-640080
      DECLARE cl_get_gbc_curl CURSOR FOR
       SELECT gbc04,gbc05 FROM gbc_file
        WHERE gbc01=lc_gbc.gbc01 AND gbc02=lc_gbc.gbc02
          AND gbc03=lc_gbc.gbc03
      FOREACH cl_get_gbc_curl INTO lc_gbc.gbc04,lc_gbc.gbc05
         LET ls_node_val = ls_node_val.trim(),"\n ---( ",lc_gbc.gbc04 CLIPPED,":",lc_gbc.gbc05 CLIPPED," )--- "
      END FOREACH
 
      IF (NOT cl_null(ls_node_val)) THEN
         LET ls_node_comt = ls_node_comt,ls_node_val.trim()
         CALL lnode_child.setAttribute("comment",ls_node_comt)
      ELSE
         CALL lnode_child.setAttribute("comment",ls_node_comt)
      END IF
 
      # 條件值中加上一參數設定哪個欄位要參照到多語言欄位，沒有就保持空白
     #IF NOT cl_null(ls_condiction) THEN  #TQC-6C0060 mark
     #   LET lnode_item = gf_form.findNode("FormField",ls_condiction.trim())
     #   LET lc_valuetype="fx"
     #   IF lnode_item IS NULL THEN
     #      LET lnode_item = gf_form.findNode("TableColumn",ls_condiction.trim())
     #      LET lc_valuetype="tx"
     #      IF lnode_item IS NULL THEN
     #         LET lnode_item = gf_form.findNode("FormField","formonly." || ls_condiction.trim())
     #         LET lc_valuetype="ff"
     #         IF lnode_item IS NULL THEN
     #            LET lnode_item = gf_form.findNode("TableColumn","formonly." || ls_condiction.trim())
     #            LET lc_valuetype="tf"
     #         END IF
     #      END IF
     #   END IF
     #   IF lnode_item IS NOT NULL THEN
     #      SELECT gbc05 INTO lc_gbc.gbc05 FROM gbc_file
     #       WHERE gbc01=lc_gbc.gbc01 AND gbc02=lc_gbc.gbc02
     #         AND gbc03=lc_gbc.gbc03 AND gbc04=g_lang
     #      IF SQLCA.SQLCODE OR cl_null(lc_gbc.gbc05) THEN RETURN END IF
 
     #      IF lc_valuetype[1]="f" THEN
     #         CALL lnode_item.setAttribute("value",lc_gbc.gbc05)
#           ELSE  #FUN-560077
#              LET lnode_value_list = lnode_item.getLastChild()
#              LET lst_value = lnode_value_list.selectByTagName("Value")
#              LET lnode_parent = pnode_item.getParent()
#              LET li_curr = lnode_parent.getAttribute("currentRow")
#              LET li_offset = lnode_parent.getAttribute("offset")
#              LET li_pagesize = lnode_parent.getAttribute("pageSize")
#              LET li_show_curr = li_curr - li_offset + 1
#              IF (li_curr >= li_offset) AND (li_curr < li_offset + li_pagesize) AND
#                 (li_show_curr != 0) THEN
#                 LET lnode_value = lst_value.item(li_show_curr)
#                 CALL lnode_value.setAttribute("value",lc_gbc.gbc05 CLIPPED)
#              END IF
#              #FUN-560086 if changed in dynamic locale
#              IF g_dyloc2sfld THEN
#                 LET g_dyloc2sfld = FALSE
#              END IF
     #      END IF
     #   END IF
 
     #END IF
   END IF
 
 
   RETURN
 
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 顯示多單位詳細內容
# Date & Author..: 2005/06/22 By saki
# Input Parameter: pnode_item     匯率欄位節點
#                  ps_field_list  相關欄位名稱字串
# Return code....: none
# Usage..........: CALL cl_show_multi_unit_comment(pnode_item,ps_field_list)
# Memo...........:
# Modify.........: No.FUN-560197
##################################################
FUNCTION cl_show_multi_unit_comment(pnode_item,ps_field_list)
   DEFINE   pnode_item      om.DomNode
   DEFINE   ps_field_list   STRING
   DEFINE   ls_item_tag     STRING
   DEFINE   lst_fld_list    base.StringTokenizer
   DEFINE   ls_qty_2        STRING,            #單位二數量欄位名稱
            ls_unit_2       STRING,            #單位二單位欄位名稱
            ls_rate_2       STRING,            #單位二換算率欄位名稱
            ls_qty_1        STRING,            #單位一數量欄位名稱
            ls_unit_1       STRING,            #單位一單位欄位名稱
            ls_rate_1       STRING,            #單位一換算率欄位名稱
            ls_unit_name    STRING,            #採購單位
            ls_itemno_fld   STRING             #料件編號欄位 No.FUN-560243
   DEFINE   ls_qty2         STRING,
            ls_unit2        STRING,
            ls_rate2        STRING,
            ls_qty1         STRING,
            ls_unit1        STRING,
            ls_rate1        STRING,
            ls_unit         STRING,
            ls_itemno       STRING             #No.FUN-560243
   DEFINE   li_cnt          LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE   li_inx_e        LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE   ls_comment      STRING
   DEFINE   lnode_child     om.DomNode
   DEFINE   ls_node_comt    STRING
   DEFINE   ls_qty_total    STRING
   DEFINE   lc_ima906       LIKE ima_file.ima906
   DEFINE   ls_sql          STRING
   DEFINE   lc_gae04        LIKE gae_file.gae04
 
 
   IF (pnode_item IS NULL) OR (ps_field_list IS NULL) THEN
      RETURN
   ELSE
      LET ls_item_tag = pnode_item.getTagName()
   END IF
 
   LET li_cnt = 1
   LET lst_fld_list = base.StringTokenizer.create(ps_field_list,",")
   WHILE lst_fld_list.hasMoreTokens()
      CASE li_cnt
         WHEN 1
            LET ls_qty_2 = lst_fld_list.nextToken()
            LET ls_qty_2 = ls_qty_2.trim()
         WHEN 2
            LET ls_unit_2 = lst_fld_list.nextToken()
            LET ls_unit_2 = ls_unit_2.trim()
         WHEN 3
            LET ls_rate_2 = lst_fld_list.nextToken()
            LET ls_unit_2 = ls_unit_2.trim()
         WHEN 4
            LET ls_qty_1 = lst_fld_list.nextToken()
            LET ls_qty_1 = ls_qty_1.trim()
         WHEN 5
            LET ls_unit_1 = lst_fld_list.nextToken()
            LET ls_unit_1 = ls_unit_1.trim()
         WHEN 6
            LET ls_rate_1 = lst_fld_list.nextToken()
            LET ls_rate_1 = ls_rate_1.trim()
         WHEN 7
            LET ls_unit_name = lst_fld_list.nextToken()
            LET ls_unit_name = ls_unit_name.trim()
         WHEN 8
            LET ls_itemno_fld = lst_fld_list.nextToken()
            LET ls_itemno_fld = ls_itemno_fld.trim()
      END CASE
      LET li_cnt = li_cnt + 1
   END WHILE
 
   CALL cl_multi_unit_getValue(ls_item_tag,ls_qty_2,"1") RETURNING ls_qty2
   CALL cl_multi_unit_getValue(ls_item_tag,ls_unit_2,"2") RETURNING ls_unit2
   CALL cl_multi_unit_getValue(ls_item_tag,ls_rate_2,"3") RETURNING ls_rate2
   CALL cl_multi_unit_getValue(ls_item_tag,ls_qty_1,"4") RETURNING ls_qty1
   CALL cl_multi_unit_getValue(ls_item_tag,ls_unit_1,"5") RETURNING ls_unit1
   CALL cl_multi_unit_getValue(ls_item_tag,ls_rate_1,"6") RETURNING ls_rate1
   CALL cl_multi_unit_getValue(ls_item_tag,ls_unit_name,"7") RETURNING ls_unit
   CALL cl_multi_unit_getValue(ls_item_tag,ls_itemno_fld,"8") RETURNING ls_itemno
 
   LET ls_qty_total  = (ls_qty2*ls_rate2) + (ls_qty1*ls_rate1)
   CALL cl_remove_zero(ls_qty_total)  RETURNING ls_qty_total
   CALL cl_number_add_comma(ls_qty_total) RETURNING ls_qty_total
   LET ls_comment = "  ",ls_qty2," (",ls_unit2,") * ",ls_rate2,"  +  ",ls_qty1," (",ls_unit1,") * ",ls_rate1,
                    "  =  ",ls_qty_total," (",ls_unit,") "
 
   LET lnode_child = pnode_item.getFirstChild()
   LET ls_node_comt = lnode_child.getAttribute("comment")
   LET li_inx_e = ls_node_comt.getIndexOf("\nMulti Unit :",1)
   IF li_inx_e != 0 THEN
      LET ls_node_comt = ls_node_comt.subString(1,li_inx_e - 1)
   END IF
 
   #No.FUN-560243 --start--
   LET ls_sql = "SELECT ima906 FROM ima_file WHERE ima01 = '",ls_itemno,"'"
   PREPARE ima_cur FROM ls_sql
   EXECUTE ima_cur INTO lc_ima906
   IF lc_ima906 = "2" THEN
      SELECT gae04 INTO lc_gae04 FROM gae_file WHERE gae01 = "aimi100" AND gae02 = "ima906_2" AND gae03 = g_lang AND gae11 = g_cust_flag AND gae12 = g_ui_setting   #No.MOD-5A0288   #No.FUN-810089
      LET ls_node_comt = ls_node_comt,"\nMulti Unit : (",lc_gae04 CLIPPED,")\n",ls_comment
      CALL lnode_child.setAttribute("comment",ls_node_comt)
   ELSE
      CASE lc_ima906
         WHEN "1"
            SELECT gae04 INTO lc_gae04 FROM gae_file WHERE gae01 = "aimi100" AND gae02 = "ima906_1" AND gae03 = g_lang AND gae11 = g_cust_flag AND gae12 = g_ui_setting   #No.MOD-5A0288   #No.FUN-810089
            LET ls_node_comt = ls_node_comt,"\nMulti Unit : (",lc_gae04 CLIPPED,")"
            CALL lnode_child.setAttribute("comment",ls_node_comt)
         WHEN "3"
            SELECT gae04 INTO lc_gae04 FROM gae_file WHERE gae01 = "aimi100" AND gae02 = "ima906_3" AND gae03 = g_lang AND gae11 = g_cust_flag AND gae12 = g_ui_setting   #No.MOD-5A0288   #No.FUN-810089
            LET ls_node_comt = ls_node_comt,"\nMulti Unit : (",lc_gae04 CLIPPED,")"
            CALL lnode_child.setAttribute("comment",ls_node_comt)
         OTHERWISE
            CALL lnode_child.setAttribute("comment",ls_node_comt)
      END CASE
   END IF
   #No.FUN-560243 ---end---
END FUNCTION
 
#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 取得多單位的值
# Date & Author..: 05/05/12 By saki
# Input Parameter: ps_tag_name,ps_fld_name,ps_fld_inx
# Return code....: ls_value
# Usage..........: CALL cl_multi_unit_getValue(ls_item_tag,ls_qty_2,"1") RETURNING ls_qty2
# Memo...........:
##################################################
FUNCTION cl_multi_unit_getValue(ps_tag_name,ps_fld_name,ps_fld_inx)
   DEFINE   ps_tag_name   STRING
   DEFINE   ps_fld_name   STRING
   DEFINE   ps_fld_inx    LIKE type_file.chr1       #No.FUN-690005 VARCHAR(1)
   DEFINE   lnode_value_list om.DomNode,
            lnode_value      om.DomNode,
            lst_value        om.NodeList 
   DEFINE   lnode_item       om.DomNode
   DEFINE   lnode_parent     om.DomNode
   DEFINE   li_curr          LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE   li_show_curr     LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE   li_offset        LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE   li_pagesize      LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE   li_qty2          LIKE aqc_file.aqc05,      #No.FUN-690005 DEC(15,3),
            lc_unit2         LIKE ade_file.ade04,      #No.FUN-690005 VARCHAR(4),
            li_rate2         LIKE tsc_file.tsc10,      #No.FUN-690005 DEC(16,8),
            li_qty1          LIKE aqc_file.aqc05,      #No.FUN-690005 DEC(15,3),
            lc_unit1         LIKE ade_file.ade04,      #No.FUN-690005 VARCHAR(4),
            li_rate1         LIKE tsc_file.tsc10,      #No.FUN-690005 DEC(16,8),
            lc_unit          LIKE ade_file.ade04       #No.FUN-690005 VARCHAR(4)
   DEFINE   li_i             LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE   ls_value         STRING
   DEFINE   ls_tabname       STRING                    #No.FUN-720042
 
 
   LET ls_tabname = cl_get_table_name(ps_fld_name)     #No.FUN-720042
   LET lnode_item = gf_form.findNode(ps_tag_name,ls_tabname||"."||ps_fld_name)  #No.FUN-720042
   IF lnode_item IS NOT NULL THEN
      IF ps_tag_name.equals("TableColumn") THEN
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
   END IF
 
   IF ps_fld_inx MATCHES '[1346]' THEN
      CALL cl_remove_zero(ls_value) RETURNING ls_value
      CALL cl_number_add_comma(ls_value) RETURNING ls_value
   END IF
 
   RETURN ls_value
 
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Descriptions...: 將數值字串後面多餘的0刪除
# Date & Author..: 2005/06/28 By saki
# Input Parameter: ps_value     數值字串
# Return code....: ls_value     數值字串
# Usage..........: CALL cl_remove_zero(l_ogb.ogb12) RETURNING l_ogb12
# Memo...........: Ex.23400.34500 ->23400.345
# Modify.........: No.FUN-560197
##################################################
FUNCTION cl_remove_zero(ps_value)
   DEFINE   ps_value   STRING
   DEFINE   ls_value   STRING
   DEFINE   li_i,t       LIKE type_file.num5       #No.FUN-690005 SMALLINT
 
 
   LET ls_value = ps_value
   IF ls_value.getIndexOf('.',1) <> 0 THEN  #MOD-DA0032 add
      FOR li_i = ls_value.getLength() TO 1 STEP -1
          IF ls_value.subString(li_i,li_i) = "0" THEN
             LET ls_value = ls_value.subString(1,li_i - 1)
          ELSE
             EXIT FOR
          END IF
      END FOR
   END IF  #MOD-DA0032 add
   IF ls_value.subString(ls_value.getLength(),ls_value.getLength()) = "." THEN
      LET ls_value = ls_value.subString(1,ls_value.getLength() - 1)
   END IF
 
   RETURN ls_value
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Private Func...: TRUE
# Descriptions...: 將數值加上逗號分隔顯示
# Date & Author..: 2005/06/30 By saki
# Input Parameter: ps_value     數值字串
# Return code....: ls_value     數值字串
# Usage..........: CALL cl_number_add_comma(ls_value) RETURNING ls_value
# Memo...........: Ex.23400.34500 ->23,400.345
# Modify.........: No.FUN-560270
##################################################
FUNCTION cl_number_add_comma(ps_value)
   DEFINE   ps_value   STRING
   DEFINE   ls_value   STRING
   DEFINE   li_i       LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE   li_inx_s   LIKE type_file.num5       #No.FUN-690005 SMALLINT
   DEFINE   ls_value_l STRING
   DEFINE   ls_value_r STRING
   DEFINE   lsb_value  base.StringBuffer
 
 
   LET ls_value = ps_value
   LET li_inx_s = ls_value.getIndexOf(".",1)
   IF li_inx_s <= 0 THEN
      LET ls_value_l = ls_value
   ELSE
      LET ls_value_l = ls_value.subString(1,li_inx_s - 1)
      LET ls_value_r = ls_value.subString(li_inx_s + 1,ls_value.getLength())
   END IF
   LET lsb_value = base.StringBuffer.create()
   CALL lsb_value.append(ls_value_l)
   FOR li_i = ls_value_l.getLength() TO 1 STEP -3
       IF li_i != ls_value_l.getLength() THEN
          CALL lsb_value.insertAt(li_i + 1,",")
       END IF
   END FOR
   LET ls_value = lsb_value.toString()
 
   RETURN ls_value
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Descriptions...: 尋找欄位在資料庫對應的table name
# Date & Author..: 2007/03/02 By saki
# Input Parameter: ps_fldname 欄位代碼
# Return code....: lc_frmname 表格代碼
# Usage..........: CALL cl_get_table_name(ps_fldname) RETURNING ls_tabname
# Memo...........:
# Modify.........: No.EXT-7A0042 Moved from cl_validate.4gl
##################################################
FUNCTION cl_get_table_name(ps_fldname)
   DEFINE   ps_fldname        STRING
   DEFINE   lc_tabname        LIKE type_file.chr30
   DEFINE   ls_tabname        STRING
   DEFINE   ls_sql            STRING
   DEFINE   ps_fldname_char   LIKE gae_file.gae02    #FUN-790042
   DEFINE   g_db_type         LIKE type_file.chr3    #EXT-7A0042

   #---FUN-A90024---start----- 
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #目前統一用sch_file紀錄TIPTOP資料結構
   #LET g_db_type = cl_db_get_database_type()
   #IF g_db_type = "ORA" THEN                           #FUN-790042
   #   LET ps_fldname_char = ps_fldname.toUpperCase()   
   #ELSE
   #   LET ps_fldname_char = ps_fldname
   #END IF
   #
   #CASE g_db_type
   #   WHEN "ORA" 
   ##FUN-790042 add---start---
   ##TQC-A10100 #TQC-A70031
   #      LET ls_sql = " SELECT table_name FROM ds.tiptop_columns", 
   #                    " WHERE column_name = ? "
   ##FUN-790042 add---end---
   #
   #   WHEN "IFX"
   ##FUN-790042 add---start---
   ##TQC-A10100 #TQC-A70031
   #      LET ls_sql = " SELECT a.tabname FROM ds:systables a,ds:tiptop_columns b", 
   #                    " WHERE a.tabid = b.tabid",
   #                      " AND b.colname = ? "
   ##FUN-790042 add---end---
   #
   #   WHEN "MSV"
   ##FUN-790042 add---start---
   #      LET ls_sql = " SELECT UNIQUE a.name FROM sysobjects a, syscolumns b",
   #                    " WHERE a.name LIKE '%_file'",
   #                      " AND a.id = b.id ",
   #                      " AND a.name IN (SELECT gat01 FROM gat_file)",
   #                      " AND b.name = ? "
   #   WHEN "ASE"                                 #FUN-AA0017
   #      LET ls_sql = " SELECT UNIQUE a.name FROM sysobjects a, syscolumns b",
   #                    " WHERE a.name LIKE '%_file'",
   #                      " AND a.id = b.id ",
   #                      " AND a.name IN (SELECT gat01 FROM gat_file)",
   #                      " AND b.name = ? "
   #END CASE
   ##FUN-790042 add---end---
   LET ps_fldname_char = ps_fldname
   
   LET ls_sql = " SELECT sch01 FROM sch_file ",
                "   WHERE sch02 = ? ",
                "     AND sch01 LIKE '%_file' "
   #---FUN-A90024---end-------
 
   PREPARE get_tabname FROM ls_sql
#FUN-790042 add---start---
   DECLARE get_tabname_curs CURSOR FOR get_tabname
   FOREACH get_tabname_curs USING ps_fldname_char INTO lc_tabname
      IF NOT cl_null(lc_tabname) THEN
         EXIT FOREACH
      END IF
   END FOREACH
 
   IF g_db_type = "ORA" THEN                              #FUN-790042
      LET ls_tabname = lc_tabname CLIPPED
      LET ls_tabname = ls_tabname.toLowerCase() 
   ELSE
      LET ls_tabname = lc_tabname CLIPPED
   END IF
#FUN-790042 add---end---
 
   RETURN ls_tabname
END FUNCTION
# No:DEV-C50001
