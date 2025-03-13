# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_correctElement.4gl
# Descriptions...: doing some attributes correction during initialization
# Date & Author..: 04/02/20 by Brendan
# Modify.........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-710055 07/03/07 By saki 自定義欄位功能
# Modify.........: No.FUN-790056 07/09/28 By Brendan GDC 2.02.04 日期欄位設定 SAMPLE 屬性時導致欄位寬度過小, 先 mark 掉相關段落以預設寬度呈現
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
# 2004/02/03 by Hiko : cl_dynamic_locale呼叫時的判斷依據.
GLOBALS
   DEFINE   mi_call_by_dynamic_locale   LIKE type_file.num5     #No.FUN-690005  SMALLINT
END GLOBALS
 
# Descriptions...: correct attribute of element of DOM tree
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_correctElement()
# Date & Author..: 2004/02/24 by Brendan
 
FUNCTION cl_correctElement()
    DEFINE lw_window   ui.Window
    DEFINE lf_form     ui.Form
    DEFINE ln_form     om.DomNode
 
 
    LET lw_window = ui.Window.getCurrent()
    LET lf_form = lw_window.getForm()
    LET ln_form = lf_form.getNode()
 
    CALL cl_correctElementAttribute(ln_form)
END FUNCTION
 
##########################################################################
# Descriptions...: default attribute of every elements
# Memo...........:
# Input parameter: pn_node     Form Node
# Return code....: none
# Usage..........: CALL cl_correctElementAttribute(ln_form)
# Date & Author..: 2004/02/24 by Brendan
# Modify.........: 
##########################################################################
FUNCTION cl_correctElementAttribute(pn_node)
    DEFINE pn_node    om.DomNode,
           ln_child   om.DomNode
   
    LET ln_child = pn_node.getFirstChild()
    WHILE ln_child IS NOT NULL
        CASE ln_child.getTagName()
            WHEN "ButtonEdit"
             -- CALL cl_extendWidth(ln_child)
                CALL cl_addScroll(ln_child)
                CALL cl_sampleString(ln_child)
                CALL cl_requiredHint(ln_child)
            WHEN "Edit"
                CALL cl_requiredHint(ln_child)
                CALL cl_addScroll(ln_child)
            WHEN "ComboBox"
                CALL cl_requiredHint(ln_child)
                 CALL cl_sizePolicy(ln_child)                #No.MOD-540048
            WHEN "DateEdit"
#                CALL cl_sampleString(ln_child)              #No.FUN-790056
                CALL cl_requiredHint(ln_child)
            WHEN "TextEdit"
                CALL cl_requiredHint(ln_child)
             -- CALL cl_ridScroll(ln_child)
            WHEN "Label"
                CALL cl_sizePolicy(ln_child)
            WHEN "CheckBox"
                CALL cl_sizePolicy(ln_child)
            WHEN "RadioGroup"
                CALL cl_sizePolicy(ln_child)
            WHEN "Table"
                CALL cl_unHidable(ln_child)
        END CASE
        CALL cl_correctElementAttribute(ln_child)
        LET ln_child = ln_child.getNext()
    END WHILE
END FUNCTION
 
##########################################################################
# Descriptions...: change sizePolicy of 'Lable' node to 'dyanmic'
# Memo...........: for on the fly locale change usage
# Input parameter: dom node of 'Label'
# Return code....: void
# Usage..........: CALL cl_sizePolicy(ln_child)
# Date & Author..: 2004/02/24 by Brendan
# Modify.........: 
##########################################################################
FUNCTION cl_sizePolicy(pn_node)
    DEFINE pn_node     om.DomNode,
           ln_parent   om.DomNode
    DEFINE ls_policy   STRING
 
 
#   LET ln_parent = pn_node.getParent()
#   IF ln_parent.getTagName() = "FormField" THEN
    LET ls_policy = pn_node.getAttribute("sizePolicy")
    IF ( ls_policy.getLength() = 0 ) OR ( ls_policy = "initial" ) THEN
       CALL pn_node.setAttribute("sizePolicy", "dynamic")
    END IF
#   END IF
END FUNCTION
 
##########################################################################
# Descriptions...: add sample string of 'ButtonEdit', 'DateEdit'
# Memo...........: for INPUT, let whole string appearring in once.
# Input parameter: dom node of 'ButtonEdit'
# Return code....: void
# Usage..........: CALL cl_sampleString(ln_child)
# Date & Author..: 2004/02/24 by Brendan
# Modify.........: 
##########################################################################
FUNCTION cl_sampleString(pn_node)
    DEFINE pn_node      om.DomNode,
           ln_parent    om.DomNode
    DEFINE li_width     LIKE type_file.num10,        #No.FUN-690005 INTEGER
           li_width_tmp LIKE type_file.num10,        #No.FUN-690005 INTEGER
           li_cnt       LIKE type_file.num10         #No.FUN-690005 INTEGER
    DEFINE ls_width     STRING,
           ls_sample    STRING
 
 
    LET ln_parent = pn_node.getParent()
    IF ln_parent.getTagName() = "FormField" OR
       ln_parent.getTagName() = "TableColumn" OR 
       ln_parent.getTagName() = "Matrix" THEN
       LET ls_width = pn_node.getAttribute("gridWidth")
       IF ls_width.getLength() = 0 THEN
          LET ls_width = pn_node.getAttribute("width")
          IF ls_width.getLength() = 0 THEN
             LET ls_width = '1'
          END IF
       END IF
       LET li_width = ls_width
 
       IF ( pn_node.getTagName() = "DateEdit" ) AND ( li_width >= 12 ) THEN
          RETURN
       END IF
 
       LET ls_sample = NULL
       LET li_width_tmp=li_width * 0.5 
       IF li_width_tmp=0 THEN LET li_width_tmp=1 END IF
       FOR li_cnt = 1 TO li_width_tmp
           LET ls_sample = ls_sample CLIPPED, 'M'
       END FOR
       LET li_width_tmp=li_width * 0.5 
       IF li_width_tmp=0 THEN LET li_width_tmp=1 END IF
       FOR li_cnt = 1 TO li_width_tmp
           LET ls_sample = ls_sample CLIPPED, '0'
       END FOR
       CALL pn_node.setAttribute("sample", ls_sample)
    END IF
END FUNCTION
 
##########################################################################
# Descriptions...: mark required field with obvious color hint
# Memo...........: 
# Input parameter: dom node of ANY 
# Return code....: void
# Usage..........: CALL cl_requiredHint(ln_child)
# Date & Author..: 2004/02/24 by Brendan
# Modify.........: 
##########################################################################
FUNCTION cl_requiredHint(pn_node)
    DEFINE pn_node       om.DomNode,
           ln_parent     om.DomNode
    DEFINE ls_required   STRING,
           ls_notNull    STRING
 
 
    LET ln_parent = pn_node.getParent()
    IF ln_parent.getTagName() = "FormField" OR 
       ln_parent.getTagName() = "TableColumn" OR
       ln_parent.getTagName() = "Matrix" THEN
       LET ls_required = ln_parent.getAttribute("required")
       LET ls_notNull = ln_parent.getAttribute("notNull")
       IF ( ls_required.getLength() != 0 AND ls_required = '1' ) OR
          ( ls_notNull.getLength() != 0 AND ls_notNull = '1' ) THEN
          # 2004/03/02 hjwang 利用gas02 做 REQUIRED
#         CALL pn_node.setAttribute("color","red")
          # 2004/03/26 hjwang Formfield 做 gas02, TableColumn 做 gas03
          IF ln_parent.getTagName() = "FormField" OR
             ln_parent.getTagName() = "Matrix" THEN
             #No.FUN-710055 --start-- demo中
#            CALL pn_node.setAttribute("color", g_gas.gas02 CLIPPED)
             CALL pn_node.setAttribute("style", "inputbgcolor_"||g_gas.gas02 CLIPPED)
             #No.FUN-710055 ---end---
          ELSE
             #No.FUN-710055 --start-- demo中
#            CALL pn_node.setAttribute("color", g_gas.gas03 CLIPPED)
             CALL pn_node.setAttribute("style", "inputbgcolor_"||g_gas.gas02 CLIPPED)
             #No.FUN-710055 ---end---
          END IF
#         CALL pn_node.setAttribute("reverse", "1")   #No.FUN-710055 mark
       END IF
    END IF
END FUNCTION
 
##########################################################################
# Descriptions...: extend width / gridwidth
# Memo...........: 
# Input parameter: dom node of 'ButtonEdit'
# Return code....: void
# Usage..........: CALL cl_extendWidth(ln_child)
# Date & Author..: 2004/03/04 by Brendan
# Modify.........: 
##########################################################################
FUNCTION cl_extendWidth(pn_node)
    DEFINE pn_node        om.DomNode,
           ln_parent      om.DomNode
    DEFINE ls_gridWidth   STRING,
           ls_width       STRING
    DEFINE li_gridWidth   LIKE type_file.num10,        #No.FUN-690005 INTEGER
           li_width       LIKE type_file.num10         #No.FUN-690005 INTEGER
 
 
    LET ln_parent = pn_node.getParent()
    IF ln_parent.getTagName() = "FormField" THEN
       LET ls_gridWidth = pn_node.getAttribute("gridWidth")
       IF ls_gridWidth.getLength() = 0 THEN
          LET ls_gridWidth = '1'
       END IF
       LET li_gridWidth = ls_gridWidth
       LET ls_gridWidth = li_gridWidth + 2
       LET ls_width = pn_node.getAttribute("width")
       IF ls_width.getLength() = 0 THEN
          LET ls_width = '1'
       END IF
       LET li_width = ls_width
       LET ls_width = li_width + 2
       CALL pn_node.setAttribute("gridWidth", ls_gridWidth)
       CALL pn_node.setAttribute("width", ls_width)
    END IF
END FUNCTION
 
##########################################################################
# Descriptions...: add 'SCROLL' attribute
# Memo...........: 
# Input parameter: dom node of 'ButtonEdit'
# Return code....: void
# Usage..........: CALL cl_addScroll(ln_child)
# Date & Author..: 2004/03/04 by Brendan
# Modify.........: 
##########################################################################
FUNCTION cl_addScroll(pn_node)
    DEFINE pn_node        om.DomNode,
           ln_parent      om.DomNode
    DEFINE ls_scroll      STRING
 
 
    LET ln_parent = pn_node.getParent()
    IF ln_parent.getTagName() = "FormField" OR
       ln_parent.getTagName() = "TableColumn" OR
       ln_parent.getTagName() = "Matrix" THEN
       LET ls_scroll = pn_node.getAttribute("scroll")
       IF ( ls_scroll.getLength() = 0 ) OR 
          ( ls_scroll = '0' ) THEN
          CALL pn_node.setAttribute("scroll", '1')
       END IF
    END IF
END FUNCTION
 
##########################################################################
# Descriptions...: rid 'SCROLL' attribute
# Memo...........: 
# Input parameter: dom node of 'TextEdit'
# Return code....: void
# Usage..........: CALL cl_ridScroll(ln_node)
# Date & Author..: 2004/03/23 by Brendan
# Modify.........: 
##########################################################################
FUNCTION cl_ridScroll(pn_node)
    DEFINE pn_node        om.DomNode,
           ln_parent      om.DomNode
    DEFINE ls_scroll      STRING
 
 
    LET ln_parent = pn_node.getParent()
    IF ln_parent.getTagName() = "FormField" THEN
       LET ls_scroll = pn_node.getAttribute("scroll")
       IF ( ls_scroll.getLength() != 0 ) OR 
          ( ls_scroll = '1' ) THEN
          CALL pn_node.setAttribute("scroll", '0')
       END IF
    END IF
END FUNCTION
 
##########################################################################
# Descriptions...: Set Table Unhidable Columns
# Memo...........: 
# Input parameter: dom node of 'Table'
# Return code....: void
# Usage..........: CALL cl_unHidable(ln_child)
# Date & Author..: 2004/12/09 by saki
# Modify.........: 
##########################################################################
FUNCTION cl_unHidable(pn_node)
   DEFINE   lc_aza39   LIKE aza_file.aza39
   DEFINE   pn_node    om.DomNode
 
 
   SELECT aza39 INTO lc_aza39 FROM aza_file
   IF lc_aza39 = "N" THEN
      CALL pn_node.setAttribute("unhidableColumns","1")
   END IF
END FUNCTION
