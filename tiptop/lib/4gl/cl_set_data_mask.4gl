# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: cl_set_data_mask.4gl
# Descriptions...: 動態顯現/隱藏畫面上的資料遮罩
# Date & Author..: 03/06/26 by Hiko
# Usage..........: CALL cl_set_data_mask("oea01,oea04", FALSE)
# Modify.........: No.FUN-BC0056 11/12/23 By jrg542 修改畫面上資料遮罩 
# Modify.........: No:FUN-C40086 12/05/02 By Kevin 資安欄位傳送
# Modify.........: No:FUN-CA0016 12/12/27 By joyce 1.應判斷是否有設立可視權限再決定是否對資料進行遮罩
#                                                  2.仿照GP 5.25的FUN-C80074追單--記錄原始資料 g_data_hide 用來比對遮罩 value
# Modify.........: No:FUN-D10008 13/01/09 By joyce 調整可設定多組可視權限
# Modify.........: No:FUN-CC0109 13/01/11 By joyce 若遮罩樣式是頭尾各顯示N字，當資料字數的一半<=N時，應只顯示前面N字，後面的全部遮蔽

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
   DEFINE gc_gdv01      LIKE gdv_file.gdv01
   DEFINE gc_gdv02      LIKE gdv_file.gdv02
   DEFINE gc_gdv05      LIKE gdv_file.gdv05
   DEFINE gc_gdu        RECORD LIKE gdu_file.*
   DEFINE g_data_mask  DYNAMIC ARRAY OF RECORD  #FUN-C40086
              field     STRING,
              datavalue STRING
          END RECORD
   # No:FUN-CA0016 ---start---
   DEFINE g_data_hide  DYNAMIC ARRAY OF RECORD  #FUN-C80074
              field     STRING,
              datavalue STRING,
              hidevalue STRING
          END RECORD
   # No:FUN-CA0016 --- end ---
END GLOBALS
 
# Descriptions...: 顯現/隱藏畫面上的元件.
# Date & Author..: 2003/06/26 by Hiko
# Input Parameter: ps_fields STRING 要顯現/隱藏元件的欄位名稱字串(中間以逗點分隔)
# Return Code....: void
 
FUNCTION cl_set_data_mask()
   DEFINE ps_fields     STRING
   DEFINE lst_fields    base.StringTokenizer,
          ls_field_name STRING  
   DEFINE lnode_root    om.DomNode,
          llst_items    om.NodeList,
          li_i          LIKE type_file.num5, 
          lnode_item    om.DomNode,
          ls_item_name  STRING
   DEFINE lwin_curr     ui.Window,
          lfrm_curr     ui.Form
   DEFINE lnode_frm     om.DomNode
   DEFINE lnode_value   om.DomNode
   DEFINE lnode_vitem   om.DomNode
   DEFINE ls_formName   STRING
   DEFINE ls_tagName    STRING
   DEFINE ls_tabname    STRING
   DEFINE lc_gdv01      LIKE gdv_file.gdv01
   DEFINE lc_gdv02      LIKE gdv_file.gdv02
   DEFINE lc_gdv07      LIKE gdv_file.gdv07    # No:FUN-CA0016
   DEFINE lc_gdv08      LIKE gdv_file.gdv08    # No:FUN-CA0016
   DEFINE ls_nodevalue  STRING
   DEFINE li_count      LIKE type_file.num5
   DEFINE ls_sql        STRING
   DEFINE li_j          LIKE type_file.num5    #FUN-C40086
   DEFINE ls_hide       STRING                 # No:FUN-C70084

   #系統參數不允許遮罩，直接離開 (一定要明示 "N")
   IF g_azz.azz17 IS NOT NULL AND g_azz.azz17 = "N" THEN
      RETURN
   END IF

#  #背景作業，非GDC作業，直接離開  cl_show_fld_cont 已做過  #No.FUN-BC0056
#  IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN  
#     RETURN
#  END IF
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   IF lfrm_curr IS NULL THEN
      RETURN
   END IF

   LET lnode_frm = lfrm_curr.getNode()
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_items = lnode_frm.selectByPath("//Form//*")
 
   LET ls_formName = lnode_frm.getAttribute("text")
   LET lc_gdv01 = ls_formName.trim()

   #判斷畫面是否存在設定
   SELECT COUNT(*) INTO li_count FROM gdv_file WHERE gdv01 = lc_gdv01
   IF STATUS OR li_count < 1 THEN
      RETURN
   END IF   

   #FUN-C40086 start
   CALL g_data_mask.clear()
   LET li_j = 1
   #FUN-C40086 end
 
   #FOREACH迴圈找出對應的欄位
   LET ls_sql = "SELECT gdv02,gdv07,gdv08 FROM gdv_file WHERE gdv01 = '",lc_gdv01 CLIPPED,"' ",   # No:FUN-CA0016
                 "ORDER BY gdv02"
   DECLARE cl_set_data_mask_cur CURSOR FROM ls_sql

   FOREACH cl_set_data_mask_cur INTO lc_gdv02,lc_gdv07,lc_gdv08   # No:FUN-CA0016

      # lnode_item為被設定顯示格式的欄位節點
      LET ls_tabname = cl_get_table_name(lc_gdv02 CLIPPED) 

      LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||lc_gdv02 CLIPPED)
      IF lnode_item IS NULL THEN
         LET lnode_item = lfrm_curr.findNode("FormField","formonly." || lc_gdv02 CLIPPED)
         IF lnode_item IS NULL THEN
            #No.FUN-BC0056 --start 先註解
            #LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||lc_gdv02 CLIPPED) 
            #IF lnode_item IS NULL THEN
            #   LET lnode_item = lfrm_curr.findNode("TableColumn","formonly." || lc_gdv02 CLIPPED)
            #   IF lnode_item IS NULL THEN
            #      LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||lc_gdv02 CLIPPED) 
            #      IF lnode_item IS NULL THEN
            #         LET lnode_item = lfrm_curr.findNode("Matrix","formonly." || lc_gdv02 CLIPPED)
            #      END IF
            #   END IF
            #END IF
            #No.FUN-BC0056 -- end 
         END IF
      END IF

      IF lnode_item IS NULL THEN
         CONTINUE FOREACH
      END IF

      CASE 
         WHEN lnode_item.getTagName() = "FormField"
            LET ls_nodevalue = lnode_item.getAttribute("value")
            IF ls_nodevalue IS NOT NULL AND ls_nodevalue.getLength() > 0 THEN

               # No:FUN-CA0016 ---modiry start---
               # 確認是否有設定個人(gdv07)或群組(gdv08)的可視權限
               # 若有可視權限則資料不做遮罩
            #  CALL lnode_item.setAttribute("value",cl_set_data_mask_method(lc_gdv01,lc_gdv02,ls_nodevalue))   # mark by No:FUN-CA0016
               IF NOT cl_set_data_mask_chk(lc_gdv07,lc_gdv08) THEN
                  #FUN-C80074 start
                  LET ls_hide = cl_set_data_mask_method(lc_gdv01,lc_gdv02,ls_nodevalue)
                  CALL lnode_item.setAttribute("value", ls_hide )
                  #FUN-C80074 end
               END IF
               # No:FUN-CA0016 --- modify end ---

               #FUN-C40086 start
               LET g_data_mask[li_j].field =  lc_gdv02

               # No:FUN-C70084 ---start---
               LET g_data_hide[li_j].field =  lc_gdv02
               LET g_data_hide[li_j].hidevalue =  ls_hide

               IF g_data_hide[li_j].hidevalue = ls_nodevalue THEN  #如果資料已隱藏
                  IF g_data_hide[li_j].datavalue IS NULL THEN      #原始資料沒 mask
                     LET g_data_mask[li_j].datavalue = ls_nodevalue
                  ELSE
                     LET g_data_mask[li_j].datavalue = g_data_hide[li_j].datavalue
                  END IF
               ELSE
                  LET g_data_mask[li_j].datavalue =  ls_nodevalue
                  LET g_data_hide[li_j].datavalue =  ls_nodevalue
               END IF
               # No:FUN-C70084 --- end ---

               LET li_j = li_j + 1
               #FUN-C40086 end
            END IF

         WHEN lnode_item.getTagName() = "TableColumn"
            LET lnode_value = lnode_item.getLastChild()
            FOR li_i = 1 TO lnode_value.getChildCount()
               LET lnode_vitem = lnode_value.getChildByIndex(li_i)
               LET ls_nodevalue = lnode_vitem.getAttribute("value")
               IF ls_nodevalue IS NOT NULL AND ls_nodevalue.getLength() > 0 THEN

                  # No:FUN-CA0016 ---modify start---
                  # 確認是否有設定個人或群組的可視權限
               #  CALL lnode_vitem.setAttribute("value",cl_set_data_mask_method(lc_gdv01,lc_gdv02,ls_nodevalue))   # mark by No:FUN-CA0016
                  IF NOT cl_set_data_mask_chk(lc_gdv07,lc_gdv08) THEN
                     CALL lnode_vitem.setAttribute("value",cl_set_data_mask_method(lc_gdv01,lc_gdv02,ls_nodevalue))
                  END IF
                  # No:FUN-CA0016 --- modify end ---

               #  display cl_set_data_mask_method(lc_gdv01,lc_gdv02,ls_nodevalue)
               END IF
            END FOR

         OTHERWISE
      END CASE

   END FOREACH
END FUNCTION
      

#遮罩方式計算
FUNCTION cl_set_data_mask_method(lc_gdv01,lc_gdv02,ls_nodevalue)

   DEFINE lc_gdv01      LIKE gdv_file.gdv01
   DEFINE lc_gdv02      LIKE gdv_file.gdv02
   DEFINE lc_gdv05      LIKE gdv_file.gdv05
   DEFINE lc_gdu        RECORD LIKE gdu_file.*
   DEFINE ls_nodevalue  STRING
   DEFINE ls_nodenew    STRING
   DEFINE ls_nodepart   STRING
   DEFINE li_node       LIKE type_file.num5
   DEFINE li_more       LIKE type_file.num5
   DEFINE la_str        DYNAMIC ARRAY OF STRING
   DEFINE li_str        LIKE type_file.num5
   DEFINE li_pos        LIKE type_file.num5
   DEFINE li_status     LIKE type_file.num5

   LET li_more = 0
   CALL la_str.clear()

   #分解輸入字串至陣列 移到下面cl_set_data_mask_calc() #No.FUN-BC0056 ---start---
   #FOR li_node = 1 TO ls_nodevalue.getLength() 
   #   IF li_more > 0 THEN
   #      LET li_more = li_more - 1
   #   ELSE
   #      LET ls_nodepart = ls_nodevalue.getcharAt(li_node)
   #      DISPLAY "ls_nodepart:",ls_nodepart
   #      IF ls_nodepart.getLength() > 1 THEN
   #         LET li_more = ls_nodepart.getLength() -1
   #      END IF
         
   #      LET la_str[la_str.getLength()+1] = ls_nodepart
   #   END IF
   #END FOR            #No.FUN-BC0056  ---end---

   #抓取應用Pattern
   LET li_status = FALSE
   IF gc_gdv01 IS NOT NULL AND gc_gdv02 IS NOT NULL THEN
      IF lc_gdv01 = gc_gdv01 AND lc_gdv02 = gc_gdv02 THEN
         LET lc_gdv05 = gc_gdv05
         LET li_status = TRUE
         LET lc_gdu.* = gc_gdu.*
      END IF
   END IF
   IF NOT li_status THEN
      SELECT gdv05 INTO lc_gdv05 FROM gdv_file WHERE gdv01 = lc_gdv01 AND gdv02 = lc_gdv02
      SELECT * INTO lc_gdu.* FROM gdu_file WHERE gdu01 = lc_gdv05
      IF STATUS THEN
         DISPLAY "gdv05:",STATUS
      END IF
      LET gc_gdv01 = lc_gdv01 CLIPPED
      LET gc_gdv02 = lc_gdv02 CLIPPED
      LET gc_gdv05 = lc_gdv05 CLIPPED
      LET gc_gdu.* = lc_gdu.*
   END IF

   RETURN cl_set_data_mask_calc(lc_gdu.*,ls_nodevalue)
END FUNCTION


FUNCTION cl_set_data_mask_calc(lc_gdu,ls_nodevalue) 

   DEFINE lc_gdu RECORD LIKE gdu_file.*
   DEFINE ls_nodenew    STRING
   DEFINE la_str        DYNAMIC ARRAY OF STRING
   DEFINE li_node       LIKE type_file.num5
   DEFINE li_more       LIKE type_file.num5
   DEFINE li_str        LIKE type_file.num5
   DEFINE li_pos        LIKE type_file.num5
   DEFINE li_status     LIKE type_file.num5
   DEFINE ls_nodevalue  STRING
   DEFINE ls_nodepart   STRING
   
   LET ls_nodenew = ""
   
   #分解輸入字串至陣列
   FOR li_node = 1 TO ls_nodevalue.getLength() 
      IF li_more > 0 THEN
         LET li_more = li_more - 1
      ELSE
         LET ls_nodepart = ls_nodevalue.getcharAt(li_node)
         IF ls_nodepart.getLength() > 1 THEN
            LET li_more = ls_nodepart.getLength() -1
         END IF
         LET la_str[la_str.getLength()+1] = ls_nodepart
      END IF
   END FOR
   LET li_str = la_str.getLength()
   #1.遮罩中間字串, 顯示頭尾 (不與其他規則共用)
   IF lc_gdu.gdu03 > 0 THEN
      LET li_node = 0 
      FOR li_node = 1 TO li_str
         # No:FUN-CC0109 ---modify start---
         # 當資料長度的一半比設定頭尾各要顯示的字數還少時，應只顯示前面要顯示的字數，後面的資料還是要遮蔽起來
         # 例如：姓名遮罩頭尾各要顯示一個字，若今天有一個人姓名為 [陳沖]，
         #       則設定遮罩後，顯示的資料應為 [陳*] ，而非把 [陳沖] 兩個字都顯示出來
         IF (li_str / 2) <= lc_gdu.gdu03 THEN
            IF li_node > lc_gdu.gdu03 THEN
               LET ls_nodenew = ls_nodenew,"*"
            ELSE
               LET ls_nodenew = ls_nodenew, la_str[li_node]
            END IF
         ELSE
            IF li_node > lc_gdu.gdu03 AND (li_str - lc_gdu.gdu03)+1 > li_node THEN
               LET ls_nodenew = ls_nodenew,"*"
            ELSE
               LET ls_nodenew = ls_nodenew, la_str[li_node]
            END IF
         END IF
         # No:FUN-CC0109 --- modify end ---
      END FOR
      RETURN ls_nodenew
   END IF
   
   #2.遮罩 從頭算 第N字起遮罩 
   IF lc_gdu.gdu04 > 0 THEN
      LET li_node = 0 
      FOR li_node = 1 TO li_str
         IF li_node > lc_gdu.gdu04 THEN
            LET la_str[li_node] = "*"
         END IF
      END FOR
   END IF
   #3.遮罩 從尾算 第N字起遮罩
   IF lc_gdu.gdu05 > 0 THEN
      LET li_node = 0 
      FOR li_node = li_str TO 1 STEP -1
         IF li_str - li_node < lc_gdu.gdu05 THEN
            LET la_str[li_node] = "*"
         END IF
      END FOR
   END IF

   #4.從指定的字算起 (不可抓取 * 沒用的)
   IF NOT cl_null(lc_gdu.gdu06) THEN
      IF ls_nodevalue.getIndexOf(lc_gdu.gdu06,1) THEN
         LET li_pos = li_str
         LET li_node = 0 
         FOR li_node = 1 TO li_str
            IF la_str[li_node] = lc_gdu.gdu06 THEN
               LET li_pos = li_node
               CONTINUE FOR
            END IF
            IF li_node > li_pos THEN
               LET la_str[li_node] = "*"
            END IF
         END FOR
      END IF
   END IF

   #組合後方條件
   FOR li_node = 1 TO li_str
      LET ls_nodenew = ls_nodenew,la_str[li_node]
   END FOR
   RETURN ls_nodenew
END FUNCTION

FUNCTION cl_set_data_mask_chk(lc_gdv07,lc_gdv08)

   DEFINE lc_gdv07   LIKE gdv_file.gdv07
   DEFINE lc_gdv08   LIKE gdv_file.gdv08
   DEFINE tok        base.StringTokenizer

   #若沒有權限就加上UI遮罩,並將欄位設定為 NOENTRY
   # No:FUN-D10008 ---modify start---
   # 原先用","作為區隔，但是因為在p_perscrty中做遮罩設定時是以"|"做區隔，
   # 因此調整此處的分隔符號
#  LET tok = base.StringTokenizer.create(lc_gdv07,",")  #gdv07個人
   LET tok = base.StringTokenizer.create(lc_gdv07,"|")  #gdv07個人
   # No:FUN-D10008 --- modify end ---

   WHILE tok.hasMoreTokens()
      IF g_user = tok.nextToken() THEN
         RETURN TRUE
      END IF
   END WHILE

   # No:FUN-D10008 ---modify start---
   # 原先用","作為區隔，但是因為在p_perscrty中做遮罩設定時是以"|"做區隔，
   # 因此調整此處的分隔符號
#  LET tok = base.StringTokenizer.create(lc_gdv08,",")  #gdv08群組
   LET tok = base.StringTokenizer.create(lc_gdv08,"|")  #gdv08群組
   # No:FUN-D10008 --- modify end ---

   WHILE tok.hasMoreTokens()
      # No:FUN-CA0016    # 在p_perscrty中gdv08是設立權限類別，所以此處也應以權限類別來判斷
   #  IF g_grup = tok.nextToken() THEN
      IF g_clas = tok.nextToken() THEN   # No:FUN-CA0016 modify
         RETURN TRUE
      END IF
   END WHILE

   RETURN FALSE

END FUNCTION
