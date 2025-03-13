# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name..: cl_batch_proc.4gl
# Descriptions..: 動態產生批次資料處理畫面.
# Memo..........: 1. 欲建立的畫面最多只能有10個欄位.
#               : 2. 要處理的資料陣列為系統公用變數.
#               : 3. 畫面結束後,以INT_FLAG來判斷要不要處理.
# Usage.........: 
# Date & Author.: 2003/07/03 by Hiko
# Modify........: No.FUN-710055 07/04/11 by saki createChild時要加上tabIndex
# Modify........: No.FUN-690005 06/09/04 By cheunl  欄位型態定義，改為LIKE
# Modify........: No.FUN-7C0045 07/12/14 By alex 修改說明
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0045
 
CONSTANT MI_MAX_COL_COUNT SMALLINT = 10, # 畫面的最大欄位數
         MI_COL_WIDTH SMALLINT = 20      # 畫面欄位的預設寬度
DEFINE mi_show_proc_success LIKE type_file.num5,          #No.FUN-690005 SMALLINT # 是否顯現作業處理成功的畫面
       mi_show_batch_result LIKE type_file.num5           #No.FUN-690005 SMALLINT # 是否顯現設定批次處理資料的結果畫面
DEFINE mi_col_count   LIKE type_file.num5          #No.FUN-690005 SMALLINT
DEFINE ma_success DYNAMIC ARRAY OF RECORD
       c_check LIKE type_file.chr1,          #No.FUN-690005 VARCHAR(1)
       c_item01,c_item02,c_item03,c_item04,c_item05,
       c_item06,c_item07,c_item08,c_item09,c_item10  LIKE gbc_file.gbc05        #No.FUN-690005 VARCHAR(100)
END RECORD
DEFINE ma_unsuccess DYNAMIC ARRAY OF RECORD
       c_check LIKE type_file.chr1,          #No.FUN-690005 VARCHAR(1)
       c_item01,c_item02,c_item03,c_item04,c_item05,
       c_item06,c_item07,c_item08,c_item09,c_item10 LIKE gbc_file.gbc05        #No.FUN-690005 VARCHAR(100)
END RECORD
DEFINE mwin_curr ui.Window,
       mfrm_curr ui.Form
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 批次處理程式系統公用變數初始化.
# Memo...........: 
# Input parameter: none
# Return code....: void
# Usage..........: CALL cl_init_batch_var()
# Date & Author..: 2003/07/03 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_init_batch_var()
  CALL ga_batch.clear()
END FUNCTION
 
##########################################################################
# Descriptions...: 開啟批次處理資料的選擇畫面.
# Memo...........: 
# Input parameter: ps_headers STRING Table的Header字串(中間以逗點分隔)
# Return code....: void
# Usage..........: CALL cl_batch_proc("ID,Name,Tel")
# Date & Author..: 2003/07/03 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_batch_proc(ps_headers)
  DEFINE ps_headers STRING
  DEFINE node_win,lnode_frm om.DomNode
  DEFINE li_i LIKE type_file.num10         #No.FUN-690005 INTEGER
 
  WHENEVER ERROR CALL cl_err_msg_log
 
# OPEN WINDOW w_batch_proc WITH 20 ROWS,10 COLUMNS ATTRIBUTE(STYLE="batch_proc")
  # 2004/02/04 by Hiko : 因為新版runner的bug,導致動態建立Form時會出現memory fault
  #                    : 的錯誤,因此暫時建立一個實體的Form來動態建立畫面.
  OPEN WINDOW w_batch_proc WITH FORM "lib/42f/dummy_form" ATTRIBUTE (STYLE="create_qry")
 
  LET mwin_curr = ui.Window.getCurrent()
  # 2004/02/04 by Hiko : 因為已經存在實體的Form,因此這裡就不需建立.
# LET lnode_win = mwin_curr.getNode()
# LET lnode_frm = lnode_win.createChild("Form")
  LET mfrm_curr = mwin_curr.getForm()
  LET lnode_frm = mfrm_curr.getNode()
  CALL lnode_frm.setAttribute("name", "frm")
  CALL lnode_frm.setAttribute("style", "dialog")
 
  IF (mi_show_batch_result) THEN
     IF (mi_show_proc_success) THEN
        CALL lnode_frm.setAttribute("text", "Set data successed")
     ELSE
        CALL lnode_frm.setAttribute("text", "Set data unsuccessed")
     END IF
  ELSE
     CALL lnode_frm.setAttribute("text", "Set batch process data")
  END IF
 
  CALL cl_batch_build_table(lnode_frm, ps_headers)
# CALL cl_batch_build_rec_view(lnode_frm)
 
  #CALL lnode_frm.writeXml("@cl_batch_proc.xml")
 
  CALL cl_batch_sel()
 
  CLOSE WINDOW w_batch_proc
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 建立<Table>節點.
# Memo...........: 
# Input parameter: pnode_frm   om.DomNode  <Form>節點
#                  ps_headers  STRING      Table的Header字串(中間以逗號分隔)
# Return code....: void
# Usage..........: CALL cl_batch_build_table(lnode_frm,ps_headers)
# Date & Author..: 2003/07/03 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_batch_build_table(pnode_frm, ps_headers)
  DEFINE pnode_frm om.DomNode,
         ps_headers STRING
  DEFINE lnode_grid,lnode_table,lnode_column,lnode_chk,lnode_edit om.DomNode
  DEFINE lst_headers base.StringTokenizer,
         ls_header STRING,
         li_i,li_width LIKE type_file.num5,         #No.FUN-690005 SMALLINT
         lc_col_index LIKE type_file.chr2           #no.FUN-690005 VARCHAR(2)
  DEFINE ls_tabIndex  STRING                        #No.FUN-710055
 
  LET lnode_grid = pnode_frm.createChild("Grid")
  LET lnode_table = lnode_grid.createChild("Table")
  CALL lnode_table.setAttribute("tabName", "s_xxx")
  CALL lnode_table.setAttribute("height", 20)
  CALL lnode_table.setAttribute("pageSize", 20)
 
  LET lnode_column = lnode_table.createChild("TableColumn")
  CALL lnode_column.setAttribute("text", "Sel")
  CALL lnode_column.setAttribute("colName", "check")
  CALL lnode_column.setAttribute("fieldId", "0")
  CALL lnode_column.setAttribute("sqlTabName", "formonly")
  CALL lnode_column.setAttribute("notNull", "1")
  CALL lnode_column.setAttribute("tabIndex","1")    #No.FUN-710055
 
  # 2003/05/27 by Hiko : 因為CheckBox還無法hidden,所以先以Edit代替,才有辦法hidden.
  IF (mi_show_batch_result) THEN  
     LET lnode_edit = lnode_column.createChild("Edit")
     CALL mfrm_curr.setFieldHidden("check",1)
#    CALL lnode_edit.setAttribute("hidden",1)
#    CALL lnode_column.setAttribute("unhidable","1")
  ELSE
     LET lnode_chk = lnode_column.createChild("CheckBox")
     # 2003/05/27 by Hiko : 一定要設寬度,要不然在選擇的時候會有錯誤.
     CALL lnode_chk.setAttribute("width", "3")
     CALL lnode_chk.setAttribute("valueChecked", "Y")
     CALL lnode_chk.setAttribute("valueUnchecked", "N")
  END IF
 
  LET lst_headers = base.StringTokenizer.create(ps_headers, ",")
  LET mi_col_count = lst_headers.countTokens()
 
  IF (mi_col_count > MI_MAX_COL_COUNT) THEN
     LET mi_col_count = MI_MAX_COL_COUNT
  END IF
  
  # 2003/07/05 by Hiko : 欄位check的fieldId=0,因此其他10個欄位的fieldId從1開始設定.
  FOR li_i = 1 TO mi_col_count
      LET ls_header = lst_headers.nextToken()
      LET lc_col_index = li_i USING '&&'
      LET lnode_column = lnode_table.createChild("TableColumn")
      CALL lnode_column.setAttribute("text", ls_header)
      CALL lnode_column.setAttribute("colName", "xxx" || lc_col_index)
      CALL lnode_column.setAttribute("fieldId", li_i)
      CALL lnode_column.setAttribute("sqlTabName", "formonly")
      # 2003/07/04 by Hiko : 將CheckBox以外的欄位都設定成NOENTRY.
      CALL lnode_column.setAttribute("noEntry", "1")
      #No.FUN-710055 --start--
      LET ls_tabIndex = li_i + 1
      LET ls_tabIndex = ls_tabIndex.trim()
      CALL lnode_column.setAttribute("tabIndex",ls_tabIndex)
      #No.FUN-710055 ---end---
  
      LET lnode_edit = lnode_column.createChild("Edit")
      CALL lnode_edit.setAttribute("width", MI_COL_WIDTH)
  
      LET li_width = li_width + MI_COL_WIDTH
  END FOR
  
  LET li_width = li_width + mi_col_count * 2 + 7
  CALL pnode_frm.setAttribute("width", li_width)
  CALL pnode_frm.setAttribute("height", 11)
 
  IF (mi_col_count < MI_MAX_COL_COUNT) THEN
     # 2003/06/13 by Hiko : 補足10個欄位.
     FOR li_i = mi_col_count+1 TO MI_MAX_COL_COUNT
         LET lnode_column = lnode_table.createChild("TableColumn")
         LET lc_col_index = li_i USING '&&'
         CALL lnode_column.setAttribute("colName", "xxx" || lc_col_index)
         CALL lnode_column.setAttribute("fieldId", li_i)
         #No.FUN-710055 --start--
         LET ls_tabIndex = li_i + 1
         LET ls_tabIndex = ls_tabIndex.trim()
         CALL lnode_column.setAttribute("tabIndex",ls_tabIndex)
         #No.FUN-710055 ---end---
     
         LET lnode_edit = lnode_column.createChild("Edit")
         CALL mfrm_curr.setFieldHidden("xxx" || lc_col_index,1)
#        CALL lnode_edit.setAttribute("width", 0)
#        CALL lnode_edit.setAttribute("hidden",1)
#        CALL lnode_column.setAttribute("unhidable","1")
     END FOR
  END IF
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 建立<RecordView>節點.
# Memo...........: 
# Input parameter: pnode_frm  om.DomNode  <Form>節點
# Return code....: void
# Usage..........: CALL cl_batch_build_rec_view(lnode_frm)
# Date & Author..: 2003/07/03 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_batch_build_rec_view(pnode_frm)
  DEFINE pnode_frm om.DomNode
  DEFINE li_i LIKE type_file.num5,         #No.FUN-690005 SMALLINT
         lnode_rec_view,lnode_link om.DomNode
  # 2003/07/05 by Hiko : 欄位check的fieldIdRef=0,因此其他10個欄位的fieldIdRef從1開始設定.
  FOR li_i = 0 TO MI_MAX_COL_COUNT
      CALL cl_batch_get_rec_view(pnode_frm, "formonly") RETURNING lnode_rec_view
      LET lnode_link = lnode_rec_view.createChild("Link")
      CALL lnode_link.setAttribute("fieldIdRef", li_i)
  END FOR
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 回傳<RecordView>節點.             
# Memo...........: 
# Input parameter: pnode_frm      om.DomNode  <Form>節點      
#                  ps_table_name  STRING      <Table>節點的名稱
# Return code....: om.DomNode     <RecordView>節點          
# Usage..........: CALL cl_batch_get_rec_view(lnode_frm,"formonly") RETURNING lnode_rec_view
# Date & Author..: 2003/07/03 by Hiko                     
# Modify.........: 
##########################################################################
FUNCTION cl_batch_get_rec_view(pnode_frm,ps_table_name)
  DEFINE pnode_frm om.DomNode,
         ps_table_name STRING
  DEFINE lnode_rec_view om.DomNode,
         ls_tag_name,ls_table_name STRING
 
  LET lnode_rec_view = pnode_frm.getFirstChild()
  
  # 2003/04/03 by Hiko : 如果找到<RecordView>,則回傳此節點;若找不到,則新建一個<RecordView>.
  WHILE lnode_rec_view IS NOT NULL
    LET ls_tag_name = lnode_rec_view.getTagName()
 
    IF (ls_tag_name.equals("RecordView")) THEN
       LET ls_table_name = lnode_rec_view.getAttribute("tabName")
 
       IF (ls_table_name.equals(ps_table_name)) THEN
          RETURN lnode_rec_view
       END IF
    END IF
 
    LET lnode_rec_view = lnode_rec_view.getNext()
  END WHILE
 
  LET lnode_rec_view = pnode_frm.createChild("RecordView")
  CALL lnode_rec_view.setAttribute("tabName", ps_table_name)
 
  RETURN lnode_rec_view
END FUNCTION
 
##########################################################################
# Private Func...: TRUE
# Descriptions...: 畫面顯現與資料的選擇.
# Memo...........: 
# Input parameter: none
# Return code....: SMALLINT       是否要處理
#                  DYNAMIC ARRAY  要處理之資料陣列
# Usage..........: CALL cl_batch_sel()
# Date & Author..: 2003/07/03 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_batch_sel()
  DEFINE li_i LIKE type_file.num10,         #No.FUN-690005 INTEGER
         lc_col_index LIKE type_file.chr2,   #No.FUN-690005 VARCHAR(2)
         ls_col_name STRING
  DEFINE li_refresh LIKE type_file.num5     #No.FUN-690005 SMALLINT
 
  WHILE TRUE
    LET INT_FLAG = FALSE
    LET li_refresh = FALSE
 
    IF (mi_show_batch_result) THEN
       DISPLAY ARRAY ga_batch TO s_xxx.* ATTRIBUTE(COUNT=ga_batch.getLength())
         BEFORE DISPLAY 
            IF (mi_show_proc_success) THEN
               CALL cl_set_act_visible("accept,success", FALSE)
            ELSE
               CALL cl_set_act_visible("accept,unsuccess", FALSE)
            END IF 
         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DISPLAY
         ON ACTION success
            EXIT DISPLAY
         ON ACTION unsuccess
            EXIT DISPLAY
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DISPLAY
       
       END DISPLAY
       CALL cl_set_act_visible("accept,cancel", TRUE)
       CALL cl_set_act_visible("accept,success,unsuccess",TRUE)
    ELSE
       INPUT ARRAY ga_batch WITHOUT DEFAULTS FROM s_xxx.* ATTRIBUTE(COUNT=ga_batch.getLength(),
                                                                    INSERT ROW=FALSE,
                                                                    DELETE ROW=FALSE,APPEND ROW=FALSE,
                                                                    UNBUFFERED)
         ON ACTION refresh
            LET li_refresh = TRUE
    
            FOR li_i = 1 TO ga_batch.getLength()
                LET ga_batch[li_i].c_check = "N"
            END FOR
    
            EXIT INPUT
         ON ACTION selall
            LET li_refresh = TRUE
    
            FOR li_i = 1 TO ga_batch.getLength()
                LET ga_batch[li_i].c_check = "Y"
            END FOR
    
            EXIT INPUT
         ON ACTION accept
            # 2003/06/13 可以解決"最後選擇multisel後==>馬上按下確認按鈕==>check資料並無更改"的問題.
            CALL GET_FLDBUF(s_xxx.check) RETURNING ga_batch[ARR_CURR()].c_check
    
            FOR li_i = ga_batch.getLength() TO 1 STEP -1
                IF (ga_batch[li_i].c_check = "N") THEN
                   CALL ga_batch.deleteElement(li_i)
                END IF
            END FOR 
 
            EXIT INPUT
         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT INPUT
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
       
       END INPUT
    END IF
 
    IF (NOT li_refresh) THEN
       EXIT WHILE
    END IF
  END WHILE
END FUNCTION
 
##########################################################################
# Descriptions...: 設定批次處理的執行結果
# Memo...........: 
# Input parameter: pr_curr_proc  RECORD    目前執行的資料
#                  pi_success    SMALLINT  處理是否成功
# Return code....: void
# Usage..........: CALL cl_set_proc_result(lr_bom,g_success)
# Date & Author..: 2003/07/03 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_set_proc_result(pr_curr_proc, pi_success)
  DEFINE pr_curr_proc RECORD
         c_check LIKE type_file.chr1,         #No.FUN-690005 VARCHAR(1)
         c_item01,c_item02,c_item03,c_item04,c_item05,
         c_item06,c_item07,c_item08,c_item09,c_item10 LIKE gbc_file.gbc05   #No.FUN-690005 VARCHAR(100)
                      END RECORD,
         pi_success LIKE type_file.num5       #No.FUN-690005 SMALLINT
 
  IF (pi_success) THEN
     LET ma_success[ma_success.getLength()+1].* = pr_curr_proc.*
  ELSE
     LET ma_unsuccess[ma_unsuccess.getLength()+1].* = pr_curr_proc.*
  END IF
END FUNCTION
 
##########################################################################
# Descriptions...: 顯現處理成功的畫面.
# Memo...........: 
# Input parameter: ps_headers  STRING  TableHeader
# Return code....: void
# Usage..........: CALL cl_show_success_win("Number,Error Code")
# Date & Author..: 2003/07/03 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_show_success_win(ps_headers)
  DEFINE ps_headers STRING
  DEFINE li_i LIKE type_file.num10         #No.FUN-690005 INTEGER
  CALL cl_init_batch_var()
 
  FOR li_i = 1 TO ma_success.getLength()
    LET ga_batch[li_i].* = ma_success[li_i].*
  END FOR
 
  LET mi_show_batch_result = TRUE
  LET mi_show_proc_success = TRUE
 
  CALL cl_batch_proc(ps_headers)
 
  IF (NOT INT_FLAG) THEN
     CALL cl_show_unsuccess_win(ps_headers)
  END IF
END FUNCTION
 
##########################################################################
# Descriptions...: 顯現處理失敗的畫面.
# Memo...........: 
# Input parameter: ps_headers  STRING  TableHeader
# Return code....: void
# Usage..........: CALL cl_show_unsuccess_win("Number,Error Code")
# Date & Author..: 2003/07/03 by Hiko
# Modify.........: 
##########################################################################
FUNCTION cl_show_unsuccess_win(ps_headers)
  DEFINE ps_headers STRING
  DEFINE li_i LIKE type_file.num10         #No.FUN-690005 INTEGER
  CALL cl_init_batch_var()
 
  FOR li_i = 1 TO ma_unsuccess.getLength()
#   LET ga_batch[li_i].* = ma_unsuccess[li_i].*
  END FOR
 
  LET mi_show_batch_result = TRUE
  LET mi_show_proc_success = FALSE
 
  CALL cl_batch_proc(ps_headers)
 
  IF (NOT INT_FLAG) THEN
     CALL cl_show_success_win(ps_headers)
  END IF
END FUNCTION
