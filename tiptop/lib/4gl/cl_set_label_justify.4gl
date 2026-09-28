# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Program name...: cl_set_label_justify.4gl
# Descriptions...: 设定Label的对齐格式
# Date & Author..: 13/04/26 by liudong
# Usage..........: 在"OPEN WINDOW" & CALL cl_ui_init()下面调用，参数一：WINDOW名  参数二：left/center/right

DATABASE ds        
 
GLOBALS "../../config/top.global"    

FUNCTION cl_set_label_justify(p_win_name,p_justi)
DEFINE  p_win_name     LIKE type_file.chr1000
DEFINE  p_tagname      LIKE type_file.chr1000
DEFINE  p_justi        LIKE type_file.chr1000
DEFINE  l_i            LIKE type_file.num5
DEFINE  l_ui_win       ui.window
DEFINE  l_nodelist     om.Nodelist
DEFINE  l_wdomnode     om.DomNode
DEFINE  l_ldomnode     om.DomNode

   LET l_ui_win = ui.Window.forName(p_win_name)
   LET l_wdomnode = l_ui_win.getNode()
   LET l_nodelist = l_wdomnode.selectByTagName("Label")
   FOR l_i = 1 TO l_nodelist.getLength()
      LET l_ldomnode = l_nodelist.item(l_i)
      CALL l_ldomnode.setAttribute("justify",p_justi)      
   END FOR

END FUNCTION