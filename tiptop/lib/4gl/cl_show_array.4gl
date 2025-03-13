# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Program name...: cl_show_array.4gl
# Descriptions...: 開窗顯示array內容
# Date & Author..: 05/09/28 by saki
# Usage..........: CALL (base.TypeInfo.create(g_azb),"簽核人員列表","簽核人員|密碼|金額")
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: No.TQC-630109 06/05/26 By kim "匯出excel" 時,不必做權限控管
# Modify.........: No.FUN-510052 06/06/01 By saki 以某方式定義array只有一個欄位時(lr_array[li_i])，child cnt抓不到正確值
# Modify.........: No.TQC-660079 06/06/22 By kim 按右上角的'X'鈕會當出程式
# Modify.........: No.FUN-690005 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/14 By jamie 程式開頭增加'database ds'
# Modify.........: No.MOD-7C0008 07/12/03 By alexstar 背景呼叫也要讀入ui資訊
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-810083 08/01/28 By alexstar cl_show_array改CALL其他function
# Modify.........: No.TQC-830063 08/04/01 By lumx  程序在顯示錯誤信息畫面離開后，畫面會多出許多隱藏的action
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
# Modify.........: No.TQC-890001 08/09/01 By claire 轉excel欄位不對齊
# Modify.........: No.TQC-8A0054 08/10/17 By claire cl_cmdrun()串出的程式.再呼叫本支作業,action會為英文不是中文
# Modify.........: No.FUN-920077 09/02/03 By sabrina 背景呼叫也要讀入ui資訊
# Modify.........: No.TQC-960298 09/07/02 By sherry ACTION顯示的是英文
# Modify.........: No:MOD-B70271 11/07/29 By tsai_yen 顯示title
# Modify.........: No:FUN-C40045 12/04/12 By tommas 將cl_set_act_visible搬進BEFORE DISPLAY中 
# Modify.........: No:WEB-D10009 13/01/14 By LeoChang 修正action控制問題

DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 
# Descriptions...: 開窗顯示array內容
# Input Parameter: pnode_array  傳入base.TypeInfo.create(array變數)
#                  ps_win_title 作為畫面上方的title字串
#                  ps_title_str 作為table中各欄位Title的字串，轉好多語言後，請用"|"組合傳入
# Return Code....:
 
FUNCTION cl_show_array(pnode_array,ps_win_title,ps_title_str)
   DEFINE   pnode_array      om.DomNode
   DEFINE   ps_win_title     STRING
   DEFINE   ps_title_str     STRING
   DEFINE   lnode_record     om.DomNode
   DEFINE   llst_fields      om.NodeList
   DEFINE   lnode_field      om.DomNode
   DEFINE   llst_rec_fields  om.NodeList
   DEFINE   li_child_cnt     LIKE type_file.num5       #No.FUN-690005  SMALLINT
   DEFINE   li_rec_cnt       LIKE type_file.num10      #No.FUN-690005  INTEGER
   DEFINE   lr_array         DYNAMIC ARRAY OF RECORD
               field1        STRING,
               field2        STRING,
               field3        STRING,
               field4        STRING,
               field5        STRING,
               field6        STRING,
               field7        STRING,
               field8        STRING,
               field9        STRING,
               field10       STRING
                             END RECORD
   DEFINE   ls_visible_str   STRING
   DEFINE   li_i             LIKE type_file.num10       #No.FUN-690005  SMALLINT
   DEFINE   li_j             LIKE type_file.num10       #No.FUN-690005  SMALLINT
   DEFINE   ls_i             STRING
   DEFINE   lst_title_names  base.StringTokenizer
   DEFINE   ls_title         STRING
   DEFINE   w                ui.Window                 #TQC-890001
   DEFINE   n                om.DomNode                #TQC-890001  
 
 
   IF pnode_array IS NULL THEN
      RETURN
   ELSE
      LET li_rec_cnt = pnode_array.getChildCount()
      LET lnode_record = pnode_array.getFirstChild()
   END IF
 
   IF lnode_record IS NULL THEN
      RETURN
   ELSE
      #No.FUN-510052 --start--
#     LET li_child_cnt = lnode_record.getChildCount()
      LET llst_rec_fields = lnode_record.selectByTagName("Field")
      LET li_child_cnt = llst_rec_fields.getLength()
      #No.FUN-510052 ---end---
   END IF
 
   FOR li_i = 1 TO li_rec_cnt
       IF li_i > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )    #No.TQC-630109
          EXIT FOR
       END IF
 
       IF li_i = 1 THEN
          LET lnode_record = pnode_array.getFirstChild()
       ELSE
          LET lnode_record = lnode_record.getNext()
       END IF
 
       LET llst_fields = lnode_record.selectByTagName("Field")
       FOR li_j = 1 TO llst_fields.getLength()
           LET lnode_field = llst_fields.item(li_j)
 
           CASE li_j
              WHEN 1
                 LET lr_array[li_i].field1 = lnode_field.getAttribute("value")
              WHEN 2
                 LET lr_array[li_i].field2 = lnode_field.getAttribute("value")
              WHEN 3
                 LET lr_array[li_i].field3 = lnode_field.getAttribute("value")
              WHEN 4
                 LET lr_array[li_i].field4 = lnode_field.getAttribute("value")
              WHEN 5
                 LET lr_array[li_i].field5 = lnode_field.getAttribute("value")
              WHEN 6
                 LET lr_array[li_i].field6 = lnode_field.getAttribute("value")
              WHEN 7
                 LET lr_array[li_i].field7 = lnode_field.getAttribute("value")
              WHEN 8
                 LET lr_array[li_i].field8 = lnode_field.getAttribute("value")
              WHEN 9
                 LET lr_array[li_i].field9 = lnode_field.getAttribute("value")
              WHEN 10
                 LET lr_array[li_i].field10 = lnode_field.getAttribute("value")
           END CASE
       END FOR
   END FOR
 
   OPEN WINDOW cl_show_array_w AT 1,1 WITH FORM "lib/42f/cl_show_array"
      ATTRIBUTE(STYLE="frm_list")
 
  #TQC-8A0054-mark-begin
# # CALL cl_load_act_sys(NULL)  #TQC-810083   #TQC-830063
  # CALL cl_ui_locale("cl_show_array")   #TQC-810083 unmark
  ##CALL cl_ui_init()   #MOD-7C0008  #TQC-810083 mark
  #TQC-8A0054-mark-end
 
 #FUN-920077----add---start
  IF g_bgjob = 'Y' THEN
     CALL cl_ui_init()     #背景作業時能抓取到對應的語言別
  ELSE
     CALL cl_load_act_sys(NULL)      #TQC-960298 add   
     CALL cl_ui_locale("cl_show_array")  #若不是背景執行時，本身在執行的程式不會被初使化，可維持程式本身的設定，
  END IF
 #FUN-920077---add---end
 
  #TQC-8A0054-begin-add 
  #若在A程式內用cl_cmdrun()的方式執行B程式，且是背景作業不開主視窗，
  #但B程式內會開訊息視窗，此時視窗內的按鍵皆無法轉成中文時該怎麼處理？
  #
  #若B程式訊息視窗內的功能鍵都是標準功能（例:accept、cancel...）的話， 
  # 呼叫cl_load_act_sys(NULL)可以轉換標準功能鍵的多語言；
  #
  #若B程式訊息視窗內包含自設的功能鍵，則必須 叫cl_load_act_list(NULL)轉換。
  #程式一般會在OPEN WINDOW（主視窗）後面 叫cl_ui_init()，cl_ui_init()內就包含上述的兩支function。
  #
  #若要修改此二行請再討論
  #CALL cl_load_act_sys(NULL)      #FUN-920077 mark          
  #CALL cl_ui_locale("cl_show_array")  #FUN-920077 mark
  #TQC-8A0054-end-add 
  CALL cl_chg_win_title(ps_win_title) #FUN-920077 mark  #MOD-B70271 取消mark
 
   DISPLAY li_rec_cnt TO FORMONLY.cnt
   #CALL cl_set_act_visible("accept,cancel",FALSE)  #No:FUN-C40045 #WEB-D10009 mark
   DISPLAY ARRAY lr_array TO s_array.* ATTRIBUTE(COUNT=g_max_rec,UNBUFFERED)
      BEFORE DISPLAY

       #No.FUN-C40045 --start--
         IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN #透過B2B執行
            #CALL cl_set_act_visible("cancel,controlg,about,help,exporttoexcel,exit",FALSE)   #WEB-D10009 mark
            #CALL cl_set_act_visible("accept",TRUE)                                           #WEB-D10009 mark
            #WEB-D10009 -start-
            CALL DIALOG.setActionHidden("accept",0)         
            CALL DIALOG.setActionHidden("cancel",1)         
            CALL DIALOG.setActionHidden("controlg",1)       
            CALL DIALOG.setActionHidden("about",1)          
            CALL DIALOG.setActionHidden("help",1)           
            CALL DIALOG.setActionHidden("exporttoexcel",1)  
            CALL DIALOG.setActionHidden("exit",1)           
            #WEB-D10009 --end--
         END IF
         #CALL cl_set_act_visible(ls_visible_str,FALSE)  #No:FUN-C40045   #WEB-D10009 mark
         LET ls_visible_str = ""
       #No.FUN-C40045 --end--

         FOR li_i = li_child_cnt + 1 TO 10
             LET ls_i = li_i
             LET ls_visible_str = ls_visible_str,"field",ls_i
             IF li_i != 10 THEN
                LET ls_visible_str = ls_visible_str,","
             END IF
         END FOR
         CALL cl_set_comp_visible(ls_visible_str,FALSE)
 
         LET lst_title_names = base.StringTokenizer.create(ps_title_str,"|")
         LET li_i = 1
         WHILE lst_title_names.hasMoreTokens()
            LET ls_title = lst_title_names.nextToken()
            LET ls_title = ls_title.trim()
 
            CASE li_i
               WHEN 1
                  CALL cl_set_comp_att_text("field1",ls_title)
               WHEN 2
                  CALL cl_set_comp_att_text("field2",ls_title)
               WHEN 3
                  CALL cl_set_comp_att_text("field3",ls_title)
               WHEN 4
                  CALL cl_set_comp_att_text("field4",ls_title)
               WHEN 5
                  CALL cl_set_comp_att_text("field5",ls_title)
               WHEN 6
                  CALL cl_set_comp_att_text("field6",ls_title)
               WHEN 7
                  CALL cl_set_comp_att_text("field7",ls_title)
               WHEN 8
                  CALL cl_set_comp_att_text("field8",ls_title)
               WHEN 9
                  CALL cl_set_comp_att_text("field9",ls_title)
               WHEN 10
                  CALL cl_set_comp_att_text("field10",ls_title)
            END CASE
            LET li_i = li_i + 1
         END WHILE
 
      ON ACTION exporttoexcel
        #IF cl_chk_act_auth() THEN mark by FUN-650020
           #TQC-890001-begin-modify
           LET w = ui.Window.getCurrent()
           LET n = w.getNode()
           CALL cl_export_to_excel(n,base.TypeInfo.create(lr_array),'','')
          #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(lr_array),'','')
           #TQC-890001-end-modify
        #END IF
 
      ON ACTION exit
         EXIT DISPLAY
      #TQC-660079...............begin
      ON ACTION cancel
         LET INT_FLAG=0
         EXIT DISPLAY
      #TQC-660079...............end
 
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
   #CALL cl_set_act_visible("accept,cancel",TRUE)  #WEB-D10009 mark
 
   CLOSE WINDOW cl_show_array_w
END FUNCTION
