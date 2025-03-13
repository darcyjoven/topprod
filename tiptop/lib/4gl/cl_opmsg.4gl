# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Library name...: cl_opmsg
# Descriptions...: 文字介面用於顯示操作方法於第一、二行，操作方法著重於FUNCTION鍵的使用；
#                  對圖形介面則無作用。
# Input parameter: p_op_type 操作型態，a:新增、u:更改、q:查詢、
#                                      b:單身處理、w:多欄查詢、
#                                      p:列印條件選擇
# Return code....: none
# Usage..........: call cl_opmsg(p_op_type)
# Date & Author..: 89/09/04 By LYS
# Modify.........: No.FUN-640184 06/04/12 By Echo 自動執行確認功能
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-740146 07/04/24 By Echo 判斷是否背景作業，條件需再加上 g_gui_type 
# Modify.........: No.FUN-7C0085 07/12/31 By joyce 修改lib說明，以符合p_findfunc抓取的規格
# Modify.........: No.FUN-9B0156 09/11/30 By alex 調整ATTRIBUTES
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
FUNCTION cl_opmsg(p_op_type)
   DEFINE p_op_type     LIKE type_file.chr2,             #No.FUN-690005  VARCHAR(2)
          g_i           LIKE type_file.num5              #No.FUN-690005  SMALLINT
 
   #FUN-640184
   IF g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]"  THEN    #TQC-740146
      RETURN
   END IF
   #END FUN-640184
 
   LET g_i = g_gui_type
   IF g_i >= 1 AND NOT (g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6') THEN 
      RETURN
   END IF
 
#  CASE                                               #FUN-9B0156
#    WHEN g_lang = '0'  CALL cl_opmsg_0(p_op_type)
#    WHEN g_lang = '2'  CALL cl_opmsg_2(p_op_type)
#    OTHERWISE  CALL cl_opmsg_1(p_op_type)
#  END CASE
   CALL cl_opmsg_1(p_op_type)

END FUNCTION
 
## No.FUN-7C0085
###################################################
## Private Func...: TRUE
## Descriptions...:
## Date & Author..: 
## Input Parameter: p_op_type
## Return code....: 
###################################################
# 
#FUNCTION cl_opmsg_0(p_op_type)
#   DEFINE p_op_type     LIKE type_file.chr2,           #No.FUN-690005  VARCHAR(2)
#          l_msg1        LIKE type_file.chr1000,        #No.FUN-690005  VARCHAR(120)
#          l_msg2        LIKE ze_file.ze03              #No.FUN-690005  VARCHAR(80) 
#   CASE p_op_type
#        WHEN 'm' ERROR 'Esc:作業結束,←→:功\能選擇, <return>',
#                       '或按功\能第一字:執行, Ctrl-W:作業說明'
#                       display '' at 2,1
#        WHEN 'n' ERROR 'Esc:結束,←→:功\能選擇,Ctrl-W:作業說明,',
#                       'F3:單身下頁,F4:單身上頁,Ctrl-N:單身選擇'
#                       display '' at 2,1
#        WHEN 'a' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = '<Esc>輸入結束 <^A>插字 <^F>欄位說明 <Del>放棄輸入 <^X>消字 <^D>消多個字'
#                 MESSAGE l_msg1 
#                ELSE 
#                 LET l_msg1 = '<Esc>輸入結束 <^A>插字 <^F>欄位說明'
#                 LET l_msg2=  '<Del>放棄輸入 <^X>消字 <^D>消多個字'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'u' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = '<Esc>修改結束 <^A>插字 <^F>欄位說明 <Del>放棄修改 <^X>消字 <^D>消多個字'
#                 MESSAGE l_msg1 
#                ELSE 
#                 LET l_msg1 = '<Esc>修改結束 <^A>插字 <^F>欄位說明'
#                 LET l_msg2=  '<Del>放棄修改 <^X>消字 <^D>消多個字'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'q' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = "請在各欄位輸入查詢條件,<Esc>結束 <Del>放棄 *x*,<,<=,>,>=,<>,=,x:y,x|y,?x?,[x-y]*"
#                 MESSAGE l_msg1 
#                ELSE 
#                 LET l_msg1 = "請在各欄位輸入查詢條件,<Esc>結束 <Del>放棄 "
#                 LET l_msg2 = " *x*,<,<=,>,>=,<>,=,x:y,x|y,?x?,[x-y]*"
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'b' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = '<Esc>處理結束 <^N>重查 <F1>插行 <F4>上頁 <Del>放棄修改 <^O>複製 <F2>刪行 <F3>下頁'
#                 MESSAGE l_msg1 
#                ELSE 
#                 LET l_msg1 = '<Esc>處理結束 <^N>重查 <F1>插行 <F4>上頁'
#                 LET l_msg2 = '<Del>放棄修改 <^O>複製 <F2>刪行 <F3>下頁'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'w' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = '<Esc>結束 <CR>擷取 <F4>上頁 <Del>放棄 <^N>重查 <F3>下頁'
#                 MESSAGE l_msg1 
#                ELSE 
#                 LET l_msg1 = '<Esc>結束 <CR>擷取 <F4>上頁'
#                 LET l_msg2 = '<Del>放棄 <^N>重查 <F3>下頁'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'p'
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = '<Esc>條件正確,開始列表 <Del>放棄列表,離開作業'
#                 MESSAGE l_msg1 
#                ELSE 
#                 LET l_msg1 = '<Esc>條件正確,開始列表'
#                 LET l_msg2 = '<Del>放棄列表,離開作業'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'z' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = '<Esc>條件正確,開始處理 <Del>放棄處理,離開作業'
#                 MESSAGE l_msg1 
#                ELSE 
#                 LET l_msg1 = '<Esc>條件正確,開始處理'
#                 LET l_msg2 = '<Del>放棄處理,離開作業'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 's' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = 'Esc:輸入結束,開始作業,Del:放棄作業 ↑↓:上下, F3:下頁, F4:上頁'
#                 MESSAGE l_msg1 
#                ELSE 
#                 LET l_msg1 = 'Esc:輸入結束,開始作業,Del:放棄作業'
#                 LET l_msg2 = '↑↓:上下, F3:下頁, F4:上頁'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 't' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = 'Esc:輸入結束回主劃面 Del:放棄輸入'
#                 MESSAGE l_msg1 
#                ELSE 
#                 LET l_msg1 = 'Esc:輸入結束回主劃面'
#                 LET l_msg2 = 'Del:放棄輸入'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'd' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = 'Esc:結束回主劃面  H:Help '
#                 MESSAGE l_msg1 
#                ELSE 
#                 LET l_msg2 = 'Esc:結束回主劃面'
#                 LET l_msg1 = 'H:Help '
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'f' 
#                 LET l_msg1 = 'Del:放棄輸入, 結束作業'
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 MESSAGE l_msg1 
#                ELSE
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN '$' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = 'Esc:處理結束,F1:插入一行,F2:取消一行,F3:下頁,F4:上頁 ↑↓:上, 下, <^N>重查,<^P>區間輸入,<^O>刪除全部序號'
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = 'Esc:處理結束,F1:插入一行,F2:取消一行,F3:下頁,F4:上頁'
#                 LET l_msg2 = '↑↓:上, 下, <^N>重查,<^P>區間輸入,<^O>刪除全部序號'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN '0' 
#                 LET l_msg1 = 'Esc:處理結束,Del:放棄作業'
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 MESSAGE l_msg1 
#                ELSE
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                END IF 
#        WHEN 'aa' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = 'Esc:輸入結束,Del:放棄輸入,<^F>:欄位說明,<^U>:序號控制 ↑↓←→:移動游標, <^A>:插字,<^X>:消字'
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = 'Esc:輸入結束,Del:放棄輸入,<^F>:欄位說明,<^U>:序號控制'
#                 LET l_msg2=  '↑↓←→:移動游標, <^A>:插字,<^X>:消字'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#   END CASE
#END FUNCTION
 
# No.FUN-7C0085
##################################################
# Private Func...: TRUE
# Descriptions...:
# Date & Author..: 
# Input Parameter: p_op_type
# Return code....: 
##################################################
 
FUNCTION cl_opmsg_1(p_op_type)
   DEFINE p_op_type     LIKE type_file.chr2,             #No.FUN-690005   VARCHAR(2)
          l_c           LIKE type_file.chr2,           #No.FUN-690005  VARCHAR(02)
          l_msg1        LIKE type_file.chr1000,        #No.FUN-690005  VARCHAR(120)
          l_msg2        LIKE ze_file.ze03              #No.FUN-690005  VARCHAR(80)
   CASE p_op_type
        WHEN 'a' 
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 LET l_msg1 = '<Esc>End <^A>Insert <^F>Field Help <Del>Abort <^X>Delete <^D>Delete After'
                 MESSAGE l_msg1 
                ELSE
                 LET l_msg1 = '<Esc>End <^A>Insert <^F>Field Help'
                 LET l_msg2=  '<Del>Abort <^X>Delete <^D>Delete After'
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                 DISPLAY l_msg2 AT 2,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN 'm' ERROR 'Esc:End,←→:Select, <return>',
                       'or Press Key:Execute, Ctrl-W:Help'
                       display '' at 2,1
        WHEN 'n' ERROR 'Esc:End,←→:Select,Ctrl-W:Help,',
                       'F3:PgDn,F4:PgUp,Ctrl-N:Body'
                       display '' at 2,1
        WHEN 'u' 
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 LET l_msg1 = '<Esc>End <^A>Insert <^F>Help <Del>Abort <^X>Delete <^D>Delete After'
                 MESSAGE l_msg1 
                ELSE
                 LET l_msg1 = '<Esc>End <^A>Insert <^F>Help'
                 LET l_msg2=  '<Del>Abort <^X>Delete <^D>Delete After'
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                 DISPLAY l_msg2 AT 2,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN 'q'
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 LET l_msg1 = "Enter Condition to Query,<Esc>End <Del>Abort *x*,<,<=,>,>=,<<,>>,<>,=,x:y,x|y,?x?,    "
                 MESSAGE l_msg1 
                ELSE
                 LET l_msg1 = "Enter Condition to Query,<Esc>End <Del>Abort"
                 LET l_msg2 = "*x*,<,<=,>,>=,<<,>>,<>,=,x:y,x|y,?x?,    "
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                 DISPLAY l_msg2 AT 2,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN 'b' 
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 LET l_msg1 = '<Esc>End <^N>New <F1>Insert <F4>PgUp <Del>Abort <^O>Copy <F2>Delete <F3>PgDn'
                 MESSAGE l_msg1 
                ELSE
                 LET l_msg1 = '<Esc>End <^N>New <F1>Insert <F4>PgUp'
                 LET l_msg2 = '<Del>Abort <^O>Copy <F2>Delete <F3>PgDn'
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                 DISPLAY l_msg2 AT 2,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN 'w' 
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 LET l_msg1 = '<Esc>End <CR>Access <F4>PgUp <Del>Abort <^N>New <F3>PgDn'
                 MESSAGE l_msg1 
                ELSE
                 LET l_msg1 = '<Esc>End <CR>Access <F4>PgUp'
                 LET l_msg2 = '<Del>Abort <^N>New <F3>PgDn'
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                 DISPLAY l_msg2 AT 2,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN 'p' 
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 LET l_msg1 = '<Esc>Condition OK, Start to Print <Del>Abort Printing, Exit'
                 MESSAGE l_msg1 
                ELSE
                 LET l_msg1 = '<Esc>Condition OK, Start to Print'
                 LET l_msg2 = '<Del>Abort Printing, Exit'
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                 DISPLAY l_msg2 AT 2,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN 'z' 
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 LET l_msg1 = '<Esc>Condition OK, Start to Process <Del>Abort Process, Exit'
                 MESSAGE l_msg1 
                ELSE
                 LET l_msg1 = '<Esc>Condition OK, Start to Process'
                 LET l_msg2 = '<Del>Abort Process, Exit'
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN 's' 
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 LET l_msg1 = 'Esc:End, Start the Task,Del:Abort ↑↓:Up Dn, F3:PgDn, F4:PgUp'
                 MESSAGE l_msg1 
                ELSE
                 LET l_msg1 = 'Esc:End, Start the Task,Del:Abort'
                 LET l_msg2 = '↑↓:Up Dn, F3:PgDn, F4:PgUp'
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                 DISPLAY l_msg2 AT 2,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN 't' 
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 LET l_msg1 = 'Esc:End, Back to Main Page  Del:Abort'
                 MESSAGE l_msg1 
                ELSE
                 LET l_msg1 = 'Esc:End, Back to Main Page'
                 LET l_msg2 = 'Del:Abort'
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                 DISPLAY l_msg2 AT 2,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN 'd' 
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 LET l_msg2 = 'Esc:End, Back to Main Page  H:Help '
                 MESSAGE l_msg1 
                ELSE
                 LET l_msg2 = 'Esc:End, Back to Main Page'
                 LET l_msg1 = 'H:Help '
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                 DISPLAY l_msg2 AT 2,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN 'f' 
                 LET l_msg1 = 'Del:Abort, End Task'
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 MESSAGE l_msg1 
                ELSE
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN '$' 
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 LET l_msg1 = 'Esc:End,F1:Insert,F2:Delete,F3:PgDn,F4:PgUp ↑↓:Up, Dn, <^N>New,<^P>Enter QBE,<^O>Delete All S/N'
                 MESSAGE l_msg1 
                ELSE
                 LET l_msg1 = 'Esc:End,F1:Insert,F2:Delete,F3:PgDn,F4:PgUp'
                 LET l_msg2 = '↑↓:Up, Dn, <^N>New,<^P>Enter QBE,<^O>Delete All S/N'
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                 DISPLAY l_msg2 AT 2,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN '0' 
                 LET l_msg1 = 'Esc:End,Del:Abort'
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 MESSAGE l_msg1 
                ELSE
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                END IF
        WHEN 'aa' 
                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
                 LET l_msg1 = 'Esc:End,Del:Abort,<^F>:Field Help,<^U>:S/N Control ↑↓←→:Move Cursor, <^A>:Insert,<^X>:Delete'
                 MESSAGE l_msg1 
                ELSE
                 LET l_msg1 = 'Esc:End,Del:Abort,<^F>:Field Help,<^U>:S/N Control'
                 LET l_msg2=  '↑↓←→:Move Cursor, <^A>:Insert,<^X>:Delete'
                 DISPLAY l_msg1 AT 1,1 #ATTRIBUTE(WHITE)
                 DISPLAY l_msg2 AT 2,1 #ATTRIBUTE(WHITE)
                END IF
		OTHERWISE EXIT CASE
   END CASE
END FUNCTION
 
## No.FUN-7C0085
###################################################
## Private Func...: TRUE
## Descriptions...:
## Date & Author..: 
## Input Parameter: p_op_type
## Return code....: 
###################################################
# 
#FUNCTION cl_opmsg_2(p_op_type)
#   DEFINE p_op_type     LIKE type_file.chr2,         #No.FUN-690005  VARCHAR(2)
#          l_msg1        LIKE ze_file.ze03,           #No.FUN-690005  VARCHAR(80)
#          l_msg2        LIKE ze_file.ze03            #No.FUN-690005  VARCHAR(80)
#   CASE p_op_type
#        WHEN 'm' ERROR 'Esc:作業退出,←→:功\能選擇, <return>',
#                       '或按功\能第一字:運行, Ctrl-W:作業說明'
#                       display ' ' at 2,1
#        WHEN 'n' ERROR 'Esc:結束,←→:功\能選擇,Ctrl-W:作業說明,',
#                       'F3:單身下頁,F4:單身上頁,Ctrl-N:單身選擇'
#                       display ' ' at 2,1
#        WHEN 'a' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = '<Esc>錄入結束 <^A>插字 <^F>字段說明 <Del>放棄錄入 <^X>消字 <^D>消多個字'
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = '<Esc>錄入結束 <^A>插字 <^F>字段說明'
#                 LET l_msg2=  '<Del>放棄錄入 <^X>消字 <^D>消多個字'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'u' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = '<Esc>修改結束 <^A>插字 <^F>字段說明 <Del>放棄修改 <^X>消字 <^D>消多個字'
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = '<Esc>修改結束 <^A>插字 <^F>字段說明'
#                 LET l_msg2=  '<Del>放棄修改 <^X>消字 <^D>消多個字'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'q' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = "請在各字段錄入查詢條件,<Esc>結束 <Del>放棄  *x*,<,<=,>,>=,<>,=,x:y,x|y,?x?,[x-y]*"
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = "請在各字段錄入查詢條件,<Esc>結束 <Del>放棄 "
#                 LET l_msg2 = " *x*,<,<=,>,>=,<>,=,x:y,x|y,?x?,[x-y]*"
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'b' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = '<Esc>處理結束 <^N>重查 <F1>插行 <F4>上頁 <Del>放棄修改 <^O>複製 <F2>刪行 <F3>下頁'
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = '<Esc>處理結束 <^N>重查 <F1>插行 <F4>上頁'
#                 LET l_msg2 = '<Del>放棄修改 <^O>複製 <F2>刪行 <F3>下頁'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'w' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = '<Esc>結束 <CR>擷取 <F4>上頁 <Del>放棄 <^N>重查 <F3>下頁'
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = '<Esc>結束 <CR>擷取 <F4>上頁'
#                 LET l_msg2 = '<Del>放棄 <^N>重查 <F3>下頁'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'p' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = '<Esc>條件正確,開始打印 <Del>放棄打印,退出作業'
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = '<Esc>條件正確,開始打印'
#                 LET l_msg2 = '<Del>放棄打印,退出作業'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'z' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = '<Esc>條件正確,開始處理 <Del>放棄處理,退出作業'
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = '<Esc>條件正確,開始處理'
#                 LET l_msg2 = '<Del>放棄處理,退出作業'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 's' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = 'Esc:錄入結束,開始作業,Del:放棄作業 ↑↓:上下, F3:下頁, F4:上頁'
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = 'Esc:錄入結束,開始作業,Del:放棄作業'
#                 LET l_msg2 = '↑↓:上下, F3:下頁, F4:上頁'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 't' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = 'Esc:錄入結束回主劃面  Del:放棄錄入'
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = 'Esc:錄入結束回主劃面'
#                 LET l_msg2 = 'Del:放棄錄入'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'd' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = 'Esc:退出回主劃面  H:Help '
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg2 = 'Esc:退出回主劃面'
#                 LET l_msg1 = 'H:Help '
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'f' 
#                 LET l_msg1 = 'Del:放棄錄入, 退出作業'
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 MESSAGE l_msg1 
#                ELSE
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN '$' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = 'Esc:處理結束,F1:插入一行,F2:取消一行,F3:下頁,F4:上頁 ↑↓:上, 下, <^N>重查,<^P>區間錄入,<^O>刪除全部序號'
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = 'Esc:處理結束,F1:插入一行,F2:取消一行,F3:下頁,F4:上頁'
#                 LET l_msg2 = '↑↓:上, 下, <^N>重查,<^P>區間錄入,<^O>刪除全部序號'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN '0' 
#                 LET l_msg1 = 'Esc:處理結束,Del:放棄作業'
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 MESSAGE l_msg1 
#                ELSE
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                END IF
#        WHEN 'aa' 
#                IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
#                 LET l_msg1 = 'Esc:錄入結束,Del:放棄錄入,<^F>:字段說明,<^U>:序號控制 ↑↓←→:移動光標, <^A>:插字,<^X>:消字'
#                 MESSAGE l_msg1 
#                ELSE
#                 LET l_msg1 = 'Esc:錄入結束,Del:放棄錄入,<^F>:字段說明,<^U>:序號控制'
#                 LET l_msg2=  '↑↓←→:移動光標, <^A>:插字,<^X>:消字'
#                 DISPLAY l_msg1 AT 1,1 ATTRIBUTE(WHITE)
#                 DISPLAY l_msg2 AT 2,1 ATTRIBUTE(WHITE)
#                END IF
#   END CASE
#END FUNCTION
