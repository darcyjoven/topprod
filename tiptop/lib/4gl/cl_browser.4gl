# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Library name...: cl_browser.4gl
# Descriptions...: 資料瀏覽功能
# Memo...........: CALL cl_browser("zz_file","*",g_wc,"zz01",g_curs_index) RETURNING g_jump
#                  如果要調整array顯示的欄位個數，底下的程式段@@處要注意修改
#                  如果是增加欄位個數，cl_browser_show也要放大
#                  cl_browser_show只要比任何呼叫進來的array欄位個數多就可以
# Date & Author..: 2006/01/20 by saki
# Modify.........: No.FUN-690005 06/09/15 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-750079 07/05/21 By alex 新增MSV判斷條件
# Modify.........: No.FUN-7C0045 07/12/14 By alex 修改說明
# Modify.........: No.TQC-860016 08/06/10 By saki 增加ON IDLE段
# Modify.........: No:FUN-A70010 10/07/05 By tsai_yen 增加尋找ScrollGrid的Matrix屬性的元件
# Modify.........: No.FUN-AA0017 10/10/13 By alex 新增ASE判斷條件

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-7C0045

DEFINE   mr_array         DYNAMIC ARRAY OF RECORD    #@@所有資料的array
            field1,field2,field3,field4,field5,
            field6,field7,field8,field9,field10,
            field11,field12,field13,field14,field15,
            field16,field17,field18,field19,field20,
            field21,field22,field23,field24,field25,
            field26,field27,field28,field29,field30,
            field31,field32,field33,field34,field35,
            field36,field37,field38,field39,field40,
            field41,field42,field43,field44,field45,
            field46,field47,field48,field49,field50   STRING
                          END RECORD
DEFINE   mr_array_tmp     DYNAMIC ARRAY OF RECORD    #@@切page後每頁的array
            field1,field2,field3,field4,field5,
            field6,field7,field8,field9,field10,
            field11,field12,field13,field14,field15,
            field16,field17,field18,field19,field20,
            field21,field22,field23,field24,field25,
            field26,field27,field28,field29,field30,
            field31,field32,field33,field34,field35,
            field36,field37,field38,field39,field40,
            field41,field42,field43,field44,field45,
            field46,field47,field48,field49,field50   STRING
                          END RECORD
DEFINE   g_ac             LIKE type_file.num10   #No.FUN-690005 INTEGER
DEFINE   g_curs_idx       LIKE type_file.num10   #No.FUN-690005 INTEGER
DEFINE   g_pagecount      LIKE type_file.num10   #No.FUN-690005 INTEGER
DEFINE   g_not_first_jump LIKE type_file.num5    #No.FUN-690005 SMALLINT   #第一次進來的跳筆動作，之後翻頁不再跳筆
DEFINE   g_show_warning   LIKE type_file.num5    #No.FUN-690005 SMALLINT   #show訊息指標

##########################################################################
# Descriptions...: 搜尋要瀏覽的資料
# Memo...........:
# Input parameter: ps_tabnames   STRING     table代號字串以","連接，如果ps_colcodes打*，會以第一個table為主要搜尋欄位的依據
#                  ps_colcodes   STRING     field代號字串以","連接，或直接打*，可找全部欄位(50個內)
#                  ps_wc         STRING     查詢的where條件
#                  ps_order      STRING     排序欄位
#                  pi_curs_index INTEGER    focus的筆數
# Return code....: g_ac          INTEGER    選取的筆數
# Usage..........: CALL cl_browser("zz_file","*",g_wc,"zz01",g_curs_index) RETURNING g_jump
# Date & Author..: 2006/01/20 by saki
# Modify.........:
##########################################################################
FUNCTION cl_browser(ps_tabnames,ps_colcodes,ps_wc,ps_order,pi_curs_index)
   DEFINE   ps_tabnames   STRING
   DEFINE   ps_colcodes   STRING
   DEFINE   ps_wc         STRING
   DEFINE   ps_order      STRING
   DEFINE   pi_curs_index LIKE type_file.num10   #No.FUN-690005 INTEGER
   DEFINE   ls_main_table STRING
   DEFINE   ls_colcodes   STRING
   DEFINE   ls_colnames   STRING
   DEFINE   ls_sql        STRING
   DEFINE   ls_fldtext    STRING
   DEFINE   lr_array_tmp  RECORD   #@@Array顯示的欄位名稱及個數
               field1,field2,field3,field4,field5,
               field6,field7,field8,field9,field10,
               field11,field12,field13,field14,field15,
               field16,field17,field18,field19,field20,
               field21,field22,field23,field24,field25,
               field26,field27,field28,field29,field30,
               field31,field32,field33,field34,field35,
               field36,field37,field38,field39,field40,
               field41,field42,field43,field44,field45,
               field46,field47,field48,field49,field50   LIKE type_file.chr1000 #No.FUN-690005 VARCHAR(255)
                          END RECORD
   DEFINE   li_col_cnt    LIKE type_file.num5    #No.FUN-690005 SMALLINT
   DEFINE   li_cnt        LIKE type_file.num10   #No.FUN-690005 INTEGER
   DEFINE   g_db_type     LIKE type_file.chr3    #No.FUN-690005 VARCHAR(3)
   DEFINE   lc_col_code   LIKE type_file.chr20   #No.FUN-690005 VARCHAR(20)
   DEFINE   lwin_curr     ui.Window,
            lfrm_curr     ui.Form,
            lnode_frm     om.DomNode,
            lnode_item    om.DomNode,
            lnode_pre     om.DomNode,
            ls_tag_name   STRING,
            ls_pretag_name STRING
   DEFINE   lst_col_codes  base.StringTokenizer,
            ls_col_code    STRING
   DEFINE   lc_gaq03       LIKE gaq_file.gaq03
   DEFINE   li_idx         LIKE type_file.num5    #No.FUN-690005 SMALLINT   #No.FUN-620071
   DEFINE   li_idx2        LIKE type_file.num5    #No.FUN-690005 SMALLINT   #No.FUN-620071
   DEFINE   ls_tabname     STRING


   WHENEVER ERROR CONTINUE
   IF cl_null(ps_tabnames) OR cl_null(ps_colcodes) OR cl_null(ps_wc) THEN
      RETURN pi_curs_index
   END IF

   #預設值
   LET g_pagecount = 100
   LET g_not_first_jump = FALSE
   LET g_show_warning = FALSE
   CALL mr_array.clear()
   CALL mr_array_tmp.clear()
   #No.FUN-620071 --start-- sample
#  LET ls_main_table = ps_tabnames.subString(1,ps_tabnames.getIndexOf(",",1)-1)
#  IF cl_null(ls_main_table) THEN
#     LET ls_main_table = ps_tabnames
#  END IF
   LET ls_main_table = ps_wc.subString((ps_wc.getIndexOf("FROM",1)+5),(ps_wc.getIndexOf("_file",ls_sql.getIndexOf("FROM",1)+5)+5))
   #No.FUN-620071 ---end--- sample
   LET g_curs_idx = pi_curs_index

   #以下是抓主程式的畫面節點出來
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   IF lfrm_curr IS NULL THEN
      RETURN pi_curs_index
   END IF
   LET lnode_frm = lfrm_curr.getNode()

   #組合要搜尋的欄位代碼及顯示於array的名稱
   #如果要搜尋的欄位是指定*的話，自動指定table裡面的欄位代碼及名稱，
   #並確定存在gaq_file才可以
   IF ps_colcodes = "*" THEN
      #欄位代碼搜尋方式是到DS資料庫裡面找尋table下的欄位，分ORA跟IFX

#     #FUN-750079 head
      LET g_db_type = cl_db_get_database_type()

      CASE g_db_type
         WHEN "ORA"
            LET ls_sql = " SELECT LOWER(column_name) FROM all_tab_columns",
                          " WHERE LOWER(table_name) = '",ls_main_table,"' ",
                            " AND OWNER = 'DS' ORDER BY column_name"
         WHEN "IFX"
            LET ls_sql = " SELECT b.colname FROM ds:systables a,ds:syscolumns b",
                          " WHERE a.tabid = b.tabid ",
                            " AND a.tabname = '",ls_main_table,"' ",
                          " ORDER BY colname"
         WHEN "MSV"
            LET ls_sql = " SELECT b.name FROM sysobjects a,syscolumns b",
                          " WHERE a.id = b.id ",
                            " AND a.name = '",ls_main_table,"' ",
                          " ORDER BY name"
         WHEN "ASE"                            #FUN-AA0017
            LET ls_sql = " SELECT b.name FROM sysobjects a,syscolumns b",
                          " WHERE a.id = b.id ",
                            " AND a.name = '",ls_main_table,"' ",
                          " ORDER BY name"
      END CASE
#     #FUN-750079 tail

      PREPARE gaq_pre FROM ls_sql
      DECLARE gaq_curs CURSOR FOR gaq_pre
      LET li_col_cnt = 1
      FOREACH gaq_curs INTO lc_col_code
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
         LET ls_colcodes = ls_colcodes,lc_col_code CLIPPED,","

         #先搜尋此欄位在畫面上有沒有名稱顯示，以此為主
         LET ls_fldtext = ""
         LET ls_tabname = cl_get_table_name(lc_col_code)
         LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||lc_col_code CLIPPED)
         IF lnode_item IS NULL THEN
            LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||lc_col_code CLIPPED)
            IF lnode_item IS NULL THEN
               LET lnode_item = lfrm_curr.findNode("FormField","formonly." || lc_col_code CLIPPED)
               IF lnode_item IS NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly." || lc_col_code CLIPPED)
                  ###FUN-A70010 START ###
                  IF lnode_item IS NULL THEN
                     LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||lc_col_code CLIPPED)
                     IF lnode_item IS NULL THEN
                        LET lnode_item = lfrm_curr.findNode("Matrix","formonly." || lc_col_code CLIPPED)
                     END IF
                  END IF
                  ###FUN-A70010 END ###
               END IF
            END IF
         END IF
         IF lnode_item IS NOT NULL THEN
            LET ls_tag_name = lnode_item.getTagName()
            IF ls_tag_name.equals("TableColumn") THEN
               LET ls_fldtext = lnode_item.getAttribute("text")
            ELSE
               LET lnode_pre = lnode_item.getPrevious()
               IF lnode_pre IS NOT NULL THEN
                  LET ls_pretag_name = lnode_pre.getTagName()
                  IF ls_pretag_name.equals("Label") THEN
                     LET ls_fldtext = lnode_pre.getAttribute("text")
                  END IF
               END IF
            END IF
         END IF

         #如果畫面沒有欄位或是沒有名稱顯示的就找gaq裡面找名稱
         IF cl_null(ls_fldtext) THEN
            SELECT gaq03 INTO lc_gaq03 FROM gaq_file WHERE gaq01= lc_col_code AND gaq02 = g_lang
            IF cl_null(lc_gaq03) THEN
               LET ls_fldtext = lc_col_code CLIPPED
            ELSE
               LET ls_fldtext = lc_gaq03
            END IF
         END IF

         LET ls_colnames = ls_colnames,ls_fldtext,""
         LET li_col_cnt = li_col_cnt + 1
         IF li_col_cnt > 50 THEN    #@@如果要增加array的欄位個數，這裡要調整符合值
            EXIT FOREACH
         END IF
      END FOREACH

      LET ls_colcodes = ls_colcodes.subString(1,ls_colcodes.getLength() - 1)
      LET ls_colnames = ls_colnames.subString(1,ls_colnames.getLength() - 1)
   ELSE
   #No.FUN-620071 --start-- sample
#     LET ls_colcodes = ps_colcodes
      LET ls_colcodes = ps_wc.subString(ps_wc.getIndexOf("SELECT ",1)+7,ps_wc.getIndexOf(" FROM",1)-1)
#     LET li_idx = ps_wc.getIndexOf("SELECT ",1)
#     LET li_idx2 = ps_wc.getIndexOf(" FROM",1)
#     LET ls_colcodes = ps_wc.subString(li_idx +7,li_idx2-1)
   #No.FUN-620071 ---end--- sample

      LET li_col_cnt = 1
   #No.FUN-620071 --start-- sample
#     LET lst_col_codes = base.StringTokenizer.create(ps_colcodes, ",")
      LET lst_col_codes = base.StringTokenizer.create(ls_colcodes, ",")
   #No.FUN-620071 ---end--- sample
      WHILE lst_col_codes.hasMoreTokens()
         LET ls_col_code = lst_col_codes.nextToken()
         LET ls_col_code = ls_col_code.trim()
   #No.FUN-620071 --start-- sample
         LET li_idx = ls_col_code.getIndexOf(" ",1)
         IF li_idx > 0 THEN
            LET ls_col_code = ls_col_code.subString(1,li_idx - 1)
         END IF
   #No.FUN-620071 ---end--- sample

         #先搜尋此欄位在畫面上有沒有名稱顯示，以此為主
         LET ls_fldtext = ""
         LET ls_tabname = cl_get_table_name(lc_col_code)
         LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||ls_col_code)
         IF lnode_item IS NULL THEN
            LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||ls_col_code)
            IF lnode_item IS NULL THEN
               LET lnode_item = lfrm_curr.findNode("FormField","formonly." || ls_col_code)
               IF lnode_item IS NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn","formonly." || ls_col_code)
                  ###FUN-A70010 START ###
                  IF lnode_item IS NULL THEN
                     LET lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||lc_col_code CLIPPED)
                     IF lnode_item IS NULL THEN
                        LET lnode_item = lfrm_curr.findNode("Matrix","formonly." || lc_col_code CLIPPED)
                     END IF
                  END IF
                  ###FUN-A70010 END ###
               END IF
            END IF
         END IF
         IF lnode_item IS NOT NULL THEN
            LET ls_tag_name = lnode_item.getTagName()
            IF ls_tag_name.equals("TableColumn") THEN
               LET ls_fldtext = lnode_item.getAttribute("text")
            ELSE
               LET lnode_pre = lnode_item.getPrevious()
               IF lnode_pre IS NOT NULL THEN
                  LET ls_pretag_name = lnode_pre.getTagName()
                  IF ls_pretag_name.equals("Label") THEN
                     LET ls_fldtext = lnode_pre.getAttribute("text")
                  END IF
               END IF
            END IF
         END IF

         #如果畫面沒有欄位或是沒有名稱顯示的就找gaq裡面找名稱
         LET lc_col_code = ls_col_code
         IF cl_null(ls_fldtext) THEN
            SELECT gaq03 INTO lc_gaq03 FROM gaq_file WHERE gaq01= lc_col_code AND gaq02 = g_lang
            IF cl_null(lc_gaq03) THEN
               LET ls_fldtext = lc_col_code CLIPPED
            ELSE
               LET ls_fldtext = lc_gaq03
            END IF
         END IF

         LET ls_colnames = ls_colnames,ls_fldtext,""
         LET li_col_cnt = li_col_cnt + 1
         IF li_col_cnt > 50 THEN    #@@如果要增加array的欄位個數，這裡要調整符合值
            EXIT WHILE
         END IF
      END WHILE

      LET ls_colnames = ls_colnames.subString(1,ls_colnames.getLength() - 1)
   END IF

   #依照傳進來的Table、條件及排序方式，還有剛剛組合的欄位代碼搜尋資料
   #放在lr_array_tmp裡面
   #No.FUN-620071 --start-- sample
#  IF cl_null(ps_order) THEN
#     LET ls_sql = "SELECT UNIQUE ",ls_colcodes," FROM ",ps_tabnames,
#                  " WHERE ",ps_wc
#  ELSE
#     LET ls_sql = "SELECT UNIQUE ",ls_colcodes," FROM ",ps_tabnames,
#                  " WHERE ",ps_wc," ORDER BY ",ps_order
#  END IF
   LET ls_sql = ps_wc
   #No.FUN-620071 ---end--- sample
   DISPLAY "自動顯示列表SQL:",ls_sql
   PREPARE array_pre FROM ls_sql
   DECLARE array_curs CURSOR FOR array_pre

   LET li_cnt = 1
   FOREACH array_curs INTO lr_array_tmp.*
      IF SQLCA.sqlcode THEN
         CALL cl_err("FOREACH error",SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF

      #@@如果要增加array的欄位個數，這裡要調整符合值
      LET mr_array[li_cnt].field1 = lr_array_tmp.field1
      LET mr_array[li_cnt].field2 = lr_array_tmp.field2
      LET mr_array[li_cnt].field3 = lr_array_tmp.field3
      LET mr_array[li_cnt].field4 = lr_array_tmp.field4
      LET mr_array[li_cnt].field5 = lr_array_tmp.field5
      LET mr_array[li_cnt].field6 = lr_array_tmp.field6
      LET mr_array[li_cnt].field7 = lr_array_tmp.field7
      LET mr_array[li_cnt].field8 = lr_array_tmp.field8
      LET mr_array[li_cnt].field9 = lr_array_tmp.field9
      LET mr_array[li_cnt].field10 = lr_array_tmp.field10
      LET mr_array[li_cnt].field11 = lr_array_tmp.field11
      LET mr_array[li_cnt].field12 = lr_array_tmp.field12
      LET mr_array[li_cnt].field13 = lr_array_tmp.field13
      LET mr_array[li_cnt].field14 = lr_array_tmp.field14
      LET mr_array[li_cnt].field15 = lr_array_tmp.field15
      LET mr_array[li_cnt].field16 = lr_array_tmp.field16
      LET mr_array[li_cnt].field17 = lr_array_tmp.field17
      LET mr_array[li_cnt].field18 = lr_array_tmp.field18
      LET mr_array[li_cnt].field19 = lr_array_tmp.field19
      LET mr_array[li_cnt].field20 = lr_array_tmp.field20
      LET mr_array[li_cnt].field21 = lr_array_tmp.field21
      LET mr_array[li_cnt].field22 = lr_array_tmp.field22
      LET mr_array[li_cnt].field23 = lr_array_tmp.field23
      LET mr_array[li_cnt].field24 = lr_array_tmp.field24
      LET mr_array[li_cnt].field25 = lr_array_tmp.field25
      LET mr_array[li_cnt].field26 = lr_array_tmp.field26
      LET mr_array[li_cnt].field27 = lr_array_tmp.field27
      LET mr_array[li_cnt].field28 = lr_array_tmp.field28
      LET mr_array[li_cnt].field29 = lr_array_tmp.field29
      LET mr_array[li_cnt].field30 = lr_array_tmp.field30
      LET mr_array[li_cnt].field31 = lr_array_tmp.field31
      LET mr_array[li_cnt].field32 = lr_array_tmp.field32
      LET mr_array[li_cnt].field33 = lr_array_tmp.field33
      LET mr_array[li_cnt].field34 = lr_array_tmp.field34
      LET mr_array[li_cnt].field35 = lr_array_tmp.field35
      LET mr_array[li_cnt].field36 = lr_array_tmp.field36
      LET mr_array[li_cnt].field37 = lr_array_tmp.field37
      LET mr_array[li_cnt].field38 = lr_array_tmp.field38
      LET mr_array[li_cnt].field39 = lr_array_tmp.field39
      LET mr_array[li_cnt].field40 = lr_array_tmp.field40
      LET mr_array[li_cnt].field41 = lr_array_tmp.field41
      LET mr_array[li_cnt].field42 = lr_array_tmp.field42
      LET mr_array[li_cnt].field43 = lr_array_tmp.field43
      LET mr_array[li_cnt].field44 = lr_array_tmp.field44
      LET mr_array[li_cnt].field45 = lr_array_tmp.field45
      LET mr_array[li_cnt].field46 = lr_array_tmp.field46
      LET mr_array[li_cnt].field47 = lr_array_tmp.field47
      LET mr_array[li_cnt].field48 = lr_array_tmp.field48
      LET mr_array[li_cnt].field49 = lr_array_tmp.field49
      LET mr_array[li_cnt].field50 = lr_array_tmp.field50

      LET li_cnt = li_cnt + 1
      IF li_cnt > g_max_rec THEN
         LET g_show_warning = TRUE
         EXIT FOREACH
      END IF
   END FOREACH

   IF mr_array.getLength() <= 0 THEN
      CALL cl_err(ls_sql || "\n","lib-316",1)
      RETURN pi_curs_index
   END IF

   #傳遞Array Tree顯示在畫面上
   CALL cl_browser_sel(ls_colnames,li_col_cnt-1,pi_curs_index)
   RETURN g_ac
END FUNCTION

##########################################################################
# Descriptions...: 處理array內容並分頁
# Memo...........:
# Input parameter: ps_title_str  STRING      作為table中各欄位Title的字串，轉好多語言後，請用""組合傳入
#                  pi_col_cnt    SMALLINT    array的欄位數
#                  pi_curs_index INTEGER     focus的筆數
# Return code....: none
# Usage..........: CALL cl_browser_sel(ls_colnames,li_col_cnt-1,pi_curs_index)
# Date & Author..: 2006/01/20 by saki
# Modify.........:
##########################################################################
FUNCTION cl_browser_sel(ps_title_str,pi_col_cnt,pi_curs_index)
   DEFINE   ps_title_str     STRING
   DEFINE   pi_col_cnt       LIKE type_file.num5    #No.FUN-690005 SMALLINT
   DEFINE   pi_curs_index    LIKE type_file.num10   #No.FUN-690005 INTEGER
   DEFINE   lnode_record     om.DomNode
   DEFINE   llst_fields      om.NodeList
   DEFINE   lnode_field      om.DomNode
   DEFINE   li_rec_cnt       LIKE type_file.num10   #No.FUN-690005 INTEGER
   DEFINE   ls_visible_str   STRING
   DEFINE   li_i             LIKE type_file.num5    #No.FUN-690005 SMALLINT
   DEFINE   li_j             LIKE type_file.num5    #No.FUN-690005 SMALLINT
   DEFINE   ls_i             STRING
   DEFINE   lst_title_names  base.StringTokenizer
   DEFINE   ls_title         STRING
   DEFINE   ls_field_name    STRING
   DEFINE   ls_hide_act      STRING
   DEFINE   li_continue      LIKE type_file.num5    #No.FUN-690005 SMALLINT     #是否繼續顯現資料.
   DEFINE   li_start_index,li_end_index LIKE type_file.num10   #No.FUN-690005 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5    #No.FUN-690005 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03


   OPEN WINDOW cl_browser_w AT 1,1 WITH FORM "lib/42f/cl_browser"
      ATTRIBUTE(STYLE="frm_list")
   CALL cl_ui_locale("cl_browser")

   #依照欄位多寡將不用的欄位隱藏起來
   FOR li_i = pi_col_cnt + 1 TO 50
       LET ls_i = li_i
       LET ls_visible_str = ls_visible_str,"field",ls_i
       IF li_i != 50 THEN
          LET ls_visible_str = ls_visible_str,","
       END IF
   END FOR
   CALL cl_set_comp_visible(ls_visible_str,FALSE)

   #將欄位Title動態塞入畫面中
   LET lst_title_names = base.StringTokenizer.create(ps_title_str,"")
   LET li_i = 1
   WHILE lst_title_names.hasMoreTokens()
      LET ls_title = lst_title_names.nextToken()
      LET ls_title = ls_title.trim()

      LET ls_i = li_i
      LET ls_field_name = "field",ls_i
      CALL cl_set_comp_att_text(ls_field_name,ls_title)
      LET li_i = li_i + 1
   END WHILE

   LET li_start_index = 1

   WHILE TRUE
      CLEAR FORM

      LET INT_FLAG = FALSE
      LET ls_hide_act = ""

      #如果沒有設定'每頁顯現資料筆數',則預設顯示所有資料
      IF (g_pagecount IS NULL) THEN
         LET g_pagecount = mr_array.getLength()
      END IF

      #如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則隱藏'上下頁'的按鈕
      IF (g_pagecount >= mr_array.getLength()) THEN
         LET ls_hide_act = "prevpage,nextpage"
      END IF

      LET li_end_index = li_start_index + g_pagecount - 1

      IF (li_end_index > mr_array.getLength()) THEN
         LET li_end_index = mr_array.getLength()
      END IF

      #依照傳進來的目前筆數指標將page跳到該筆畫面並停在該筆
      IF (NOT g_not_first_jump) AND (pi_curs_index > g_pagecount) THEN
         IF (pi_curs_index MOD g_pagecount) = 0 THEN
             LET li_start_index = (pi_curs_index / g_pagecount) - 1
         ELSE
             LET li_start_index = (pi_curs_index / g_pagecount)
         END IF
         LET li_start_index = li_start_index * g_pagecount + 1
         LET li_end_index = li_start_index + g_pagecount - 1
         IF (li_end_index > mr_array.getLength()) THEN
            LET li_end_index = mr_array.getLength()
         END IF
         LET pi_curs_index = pi_curs_index - li_start_index + 1
      END IF
      CALL cl_browser_set_display_data(li_start_index, li_end_index)

      LET li_curr_page = li_end_index / g_pagecount

      IF (li_end_index MOD g_pagecount) > 0 THEN
         LET li_curr_page = li_curr_page + 1
         IF cl_null(ls_hide_act) THEN
            LET ls_hide_act = "nextpage"
         ELSE
            LET ls_hide_act = ls_hide_act.trim(),",nextpage"
         END IF
      END IF

      IF li_curr_page = 1 THEN
         IF cl_null(ls_hide_act) THEN
            LET ls_hide_act = "prevpage"
         ELSE
            LET ls_hide_act = ls_hide_act.trim(),",prevpage"
         END IF
      END IF

      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang

      MESSAGE li_count CLIPPED || " : " || mr_array.getLength() || "    " || li_page CLIPPED || " : " || li_curr_page

      #顯示畫面
      CALL cl_browser_show_array(ls_hide_act,li_start_index,li_end_index,pi_curs_index) RETURNING li_continue,li_start_index

      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE

   CLOSE WINDOW cl_browser_w
END FUNCTION

##########################################################################
# Private Func...: TRUE
# Descriptions...: 設定查詢畫面的顯現資料.
# Memo...........:
# Input parameter: pi_start_index INTEGER 所要顯現的查詢資料起始位置
#                  pi_end_index   INTEGER 所要顯現的查詢資料結束位置
# Return code....: void
# Usage..........: CALL cl_browser_set_display_data(li_start_index, li_end_index)
# Date & Author..: 2006/01/23 by saki
# Modify.........:
##########################################################################
FUNCTION cl_browser_set_display_data(pi_start_index, pi_end_index)
  DEFINE pi_start_index,pi_end_index LIKE type_file.num10   #No.FUN-690005 INTEGER
  DEFINE li_i,li_j LIKE type_file.num10   #No.FUN-690005 INTEGER

  CALL mr_array_tmp.clear()

  FOR li_i = pi_start_index TO pi_end_index
      LET mr_array_tmp[li_j+1].* = mr_array[li_i].*
      LET li_j = li_j + 1
  END FOR

  CALL SET_COUNT(mr_array_tmp.getLength())
END FUNCTION

##########################################################################
# Private Func...: TRUE
# Descriptions...: 顯示array內容並回傳選擇行數
# Memo...........:
# Input parameter: ps_hide_act    STRING   所要隱藏的Action Button
#                  pi_start_index INTEGER  所要顯現的查詢資料起始位置
#                  pi_end_index   INTEGER  所要顯現的查詢資料結束位置
#                  pi_curs_index  INTEGER  focus在此頁的第幾筆
# Return code....: li_continue    SMALLINT 是否繼續
#                  pi_start_index INTEGER  改變後的起始位置
# Usage..........: CALL cl_browser_show_array(ls_hide_act,li_start_index,li_end_index,pi_curs_index) RETURNING li_continue,li_start_index
# Date & Author..: 2006/01/20 by saki
# Modify.........:
##########################################################################
FUNCTION cl_browser_show_array(ps_hide_act,pi_start_index,pi_end_index,pi_curs_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,  #No.FUN-690005 INTEGER,
            pi_end_index     LIKE type_file.num10,  #No.FUN-690005 INTEGER,
            pi_curs_index    LIKE type_file.num10   #No.FUN-690005 INTEGER
   DEFINE   li_continue      LIKE type_file.num5    #No.FUN-690005 SMALLINT     #是否繼續顯現資料.
   DEFINE   ls_msg           STRING


   DISPLAY ARRAY mr_array_tmp TO s_array.* ATTRIBUTE(COUNT=g_max_rec,UNBUFFERED)
      BEFORE DISPLAY
         IF (g_show_warning) THEN
            LET ls_msg = cl_getmsg("lib-317",g_lang)
            DISPLAY ls_msg.trim() TO FORMONLY.warning
         END IF
         IF (NOT g_not_first_jump) THEN
            CALL fgl_set_arr_curr(pi_curs_index)
            LET g_not_first_jump = TRUE
         ELSE
            CALL fgl_set_arr_curr(1)
         END IF
         CALL cl_set_act_visible("prevpage,nextpage",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF

      ON ACTION prevpage
         IF ((pi_start_index - g_pagecount) >= 1) THEN
            LET pi_start_index = pi_start_index - g_pagecount
         END IF
         LET li_continue = TRUE
         EXIT DISPLAY

      ON ACTION nextpage
         IF ((pi_start_index + g_pagecount) <= mr_array.getLength()) THEN
            LET pi_start_index = pi_start_index + g_pagecount
         END IF
         LET li_continue = TRUE
         EXIT DISPLAY

      ON ACTION accept
         LET g_ac = pi_start_index + ARR_CURR() - 1
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG = FALSE
         LET g_ac = g_curs_idx
         EXIT DISPLAY

      ON ACTION exporttoexcel
         IF cl_chk_act_auth() THEN
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(mr_array),'','')
         END IF

      ON ACTION exit
         LET g_ac = g_curs_idx
         EXIT DISPLAY

      #No.TQC-860016 --start--
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()
      #No.TQC-860016 ---end---

   END DISPLAY

   RETURN li_continue,pi_start_index
END FUNCTION
