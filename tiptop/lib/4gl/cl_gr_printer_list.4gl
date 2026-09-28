# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_gr_printer_list
# Descriptions...: 取得系統印表機
# Input parameter: none
# Return code....: printers STRING(以|做分隔)
# Usage .........: call cl_gr_printer_list() RETURNING printers
# Date & Author..: 11/03/18 By jacklai
# Modify.........: No.FUN-B40095 11/05/05 By jacklai Genero Report

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"

#No.FUN-B40095
FUNCTION cl_gr_printer_list()
    DEFINE l_ch             base.Channel
    DEFINE l_cur            STRING
    DEFINE l_colon_pos      LIKE type_file.num10
    DEFINE l_cur_length     LIKE type_file.num10
    DEFINE l_printer_name   STRING
    DEFINE l_gredir         STRING
    DEFINE l_cmd            STRING
    DEFINE l_printer_count  LIKE type_file.num5
    DEFINE l_strbuf         base.StringBuffer
    DEFINE l_printers       STRING

    # 初始化
    LET l_printer_count = 0
    LET l_ch = base.Channel.create()
    LET l_strbuf = base.StringBuffer.create()

    # 執行命令列指令 printerinfo
    LET l_gredir = FGL_GETENV("GREDIR")
    LET l_cmd = "\"" || l_gredir || "/bin/printerinfo\""
    CALL l_ch.openPipe(l_cmd,"r")

    # 讀取 printerinfo 顯示的每一行, 取出Printer的資訊
    WHILE l_ch.read([l_cur])
        
        LET l_cur = l_cur.trim()    #去空白
        
        # 尋找印表機名稱, 該行有'Service no'字串
        IF l_cur.subString(1,10) == "Service no" THEN
            # 取出印表機名稱
            LET l_colon_pos = l_cur.getIndexOf(":",1)

            # 檢查該行是否有 'Printer' 字串
            IF l_cur.subString(l_colon_pos-8,l_colon_pos-1) == "Printer" THEN
                LET l_printer_count = l_printer_count + 1   #Increasing printer counter

                # 將印表機名稱加入陣列
                LET l_cur_length = l_cur.getLength()
                LET l_printer_name = l_cur.subString(l_colon_pos+2,l_cur_length)
                CALL l_strbuf.append(l_printer_name.trim())
                CALL l_strbuf.append("|")
            END IF
        END IF
    END WHILE
    CALL l_ch.Close()
    LET l_printers = l_strbuf.subString(1,l_strbuf.getLength()-1)
    RETURN l_printers
END FUNCTION # cl_gr_printer_list()

##################################################
# Descriptions...: 顯示選擇系統印表機的視窗
# Date & Author..: 
# Input Parameter: none
# Return code....: STRING   選取的印表機名稱
# Usage..........: LET l_printer = cl_gr_printers_show()
# Memo...........:
##################################################
FUNCTION cl_gr_printers_show()
    DEFINE l_str        STRING
    DEFINE l_i          LIKE type_file.num5
    DEFINE l_strtok     base.StringTokenizer
    DEFINE l_printers   DYNAMIC ARRAY OF RECORD
           printer      STRING
           END RECORD
    DEFINE l_ac         LIKE type_file.num10
    DEFINE l_result     STRING

    LET l_str = cl_gr_printer_list()
    LET l_strtok = base.StringTokenizer.create(l_str,"|")
    LET l_i = 0
    CALL l_printers.clear()
    WHILE l_strtok.hasMoreTokens()
        LET l_i = l_i + 1
        LET l_printers[l_i].printer = l_strtok.nextToken()
        LET l_printers[l_i].printer = l_printers[l_i].PRINTER.trim()
    END WHILE

    IF l_printers.getLength() >= 1 THEN
        OPEN WINDOW cl_gr_prt_w WITH FORM "lib/42f/cl_gr_printers_show" ATTRIBUTE(STYLE="lib")
        CALL cl_ui_locale("cl_gr_printers_show")

        CALL cl_set_act_visible("accept,cancel", FALSE)
        DISPLAY ARRAY l_printers TO s_printers.*  ATTRIBUTE(UNBUFFERED)
            BEFORE ROW
                LET l_ac = ARR_CURR()
            ON ACTION ACCEPT
                LET l_ac = ARR_CURR()
                LET l_result = l_printers[l_ac].printer
                EXIT DISPLAY
        END DISPLAY
        CALL cl_set_act_visible("accept,cancel", TRUE)

        CLOSE WINDOW cl_gr_prt_w
    ELSE
        CALL cl_err('','azz1079',0)
    END IF

    RETURN l_result
END FUNCTION
