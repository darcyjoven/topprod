# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name  : q_gdy03.4gl
# Program ver.  : 7.0
# Description   : 此程式為p_gr_history之整批產生功能
# Date & Author : 2012/02/03 By downheal
# Modify........: No.FUN-C10009 12/02/03 By downheal 新增程式具單頭單身，可複選且傳回多欄資料

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD   #No.FUN-C10009
         CHECK       LIKE type_file.chr1,   #No.FUN-C10009 
         gdy03       LIKE gdy_file.gdy03,   #No.FUN-C10009   
         zw02        LIKE zw_file.zw02
END RECORD

DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         CHECK       LIKE type_file.chr1, 
         gdy03       LIKE gdy_file.gdy03,       
         zw02        LIKE zw_file.zw02
END RECORD

DEFINE   ma_qry_final   DYNAMIC ARRAY OF RECORD
         gdy03          LIKE gdy_file.gdy03,       
         zw02           LIKE zw_file.zw02   
END RECORD

DEFINE   mi_multi_sel     SMALLINT     #是否需要複選資料(TRUE/FALSE)
DEFINE   mi_need_cons     SMALLINT     #是否需要CONSTRUCT(TRUE/FALSE)
DEFINE   ms_cons_where    STRING       #暫存CONSTRUCT區塊的WHERE條件
DEFINE   mi_page_count    INTEGER      #每頁顯現資料筆數
DEFINE   ms_default1      SMALLINT
DEFINE   ms_default2      VARCHAR(8)
DEFINE   ms_ret1          STRING
DEFINE   ms_ret2          STRING
DEFINE   ms_type          LIKE gdy_file.gdy02
#DEFINE   ms_cover         STRING
#DEFINE   ms_qry           STRING
DEFINE   li_cover         STRING

FUNCTION q_gdy03(pi_multi_sel,pi_need_cons,ps_default1,ps_type)
   DEFINE   pi_multi_sel  SMALLINT,                #允許多選
            pi_need_cons  SMALLINT,                #允許輸入篩選條件
            ps_default1   SMALLINT,
            ps_default2   VARCHAR(1)
            #pi_cover      LIKE gdy_file.gdy04     #是否覆蓋已存在資料
   DEFINE   ps_type       LIKE gdy_file.gdy02      #傳入的留存類別參數, 影響開窗欄位內容   
 
   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
   LET ms_type = ps_type
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW q_gdy03_w WITH FORM "qry/42f/q_gdy03" ATTRIBUTE(STYLE=g_win_style CLIPPED)
  
   CALL cl_ui_locale("q_gdy03")
 
   LET ms_ret1 = ""
   LET ms_ret2 = ""
   LET mi_multi_sel = TRUE
   LET mi_need_cons = pi_need_cons

   # 該程式代號無相關維護資料時，將隱藏'刪除存在資料'選項
   IF ms_default1 == 1 THEN
      CALL cl_set_comp_visible("gdy04",TRUE)
   ELSE
      CALL cl_set_comp_visible("gdy04",FALSE)
   END IF
   
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("gdy03", "red")
   END IF
 
   CALL q_gdy03_sel()
 
   CLOSE WINDOW q_gdy03_w
 
   IF (mi_multi_sel) THEN
      RETURN ma_qry_final, li_cover      #回傳勾選資料與刪除資料與否設定
   ELSE
      RETURN ma_qry_final, li_cover
   END IF
END FUNCTION
 
##################################################
# Description   : 畫面顯現與資料的選擇.
# Date & Author : 2012/02/03 by Downheal       
# Parameter   	: none
# Return   	   : void
# Memo        	:
# Modify   	   :
##################################################
FUNCTION q_gdy03_sel()
   DEFINE   ls_hide_act      STRING,
#   DEFINE   li_hide_page     SMALLINT,    #是否隱藏'上下頁'的按鈕
            li_reconstruct   SMALLINT,     #是否重新CONSTRUCT.預設為TRUE
            li_continue      SMALLINT      #是否繼續
   DEFINE   li_start_index   INTEGER,
            li_end_index     INTEGER
   DEFINE   li_curr_page     SMALLINT
   DEFINE   li_count         VARCHAR(1500),
            li_page          VARCHAR(1500)
   DEFINE   li_i             SMALLINT
   #DEFINE   ps_hide_act      STRING,
            #pi_start_index   INTEGER,
            #pi_end_index     INTEGER
   DEFINE   l_cover          STRING        #刪除資料與否選項(Y/N)    
 
 
   LET mi_page_count = 100
   LET li_reconstruct = TRUE
   LET li_cover = "Y"                      #預設為刪除資料(y)
   
   WHILE TRUE
   CLEAR FORM
   LET INT_FLAG = FALSE
   LET ls_hide_act = ""
   MESSAGE ""
   
   #傳入之留存類別(2:權限類別,3:使用者),將影響construct段內容  
   CASE ms_type     

   WHEN '2'     #2:權限類別
      IF (li_reconstruct) THEN
         DIALOG ATTRIBUTES(UNBUFFERED)
            INPUT l_cover FROM s_gdy03_t.gdy04
               BEFORE INPUT
                  LET l_cover = li_cover
                  DISPLAY l_cover TO s_gdy03_t.gdy04
                  CASE g_lang              #改變欄位名稱敘述, 並可因語系切換
                     WHEN "0"         
                     CALL cl_set_comp_att_text("gdy03","權限類別代號")
                     CALL cl_set_comp_att_text("zw02", "權限類別說明")
                     WHEN "1"
                     CALL cl_set_comp_att_text("gdy03","Permission Category")
                     CALL cl_set_comp_att_text("zw02", "Description")
                     WHEN "2"
                     CALL cl_set_comp_att_text("gdy03","权限类别代号")
                     CALL cl_set_comp_att_text("zw02", "权限类别说明")
                     OTHERWISE
                     CALL cl_set_comp_att_text("gdy03","Permission Category")
                     CALL cl_set_comp_att_text("zw02", "Description")           
                  END CASE
            END INPUT
            
            #抓取權限類別搜尋條件
            CONSTRUCT ms_cons_where ON zw01,zw02 FROM s_gdy03[1].gdy03, s_gdy03[1].zw02
            END CONSTRUCT

            ON ACTION ACCEPT
               LET li_cover = l_cover
            EXIT DIALOG
               
            ON ACTION CANCEL
               LET INT_FLAG=TRUE
            EXIT DIALOG
         END DIALOG
      END IF
   
   WHEN '3'     #3:使用者
      IF (li_reconstruct) THEN
         DIALOG ATTRIBUTES(UNBUFFERED)
            INPUT l_cover FROM s_gdy03_t.gdy04
               BEFORE INPUT
                  LET l_cover = li_cover
                  DISPLAY l_cover TO s_gdy03_t.gdy04
                  CASE g_lang              #改變欄位名稱敘述, 並可因語系切換
                     WHEN "0"         
                     CALL cl_set_comp_att_text("gdy03","使用者編號")
                     CALL cl_set_comp_att_text("zw02", "使用者名稱")
                     WHEN "1"
                     CALL cl_set_comp_att_text("gdy03","User")
                     CALL cl_set_comp_att_text("zw02", "User Name")
                     WHEN "2"
                     CALL cl_set_comp_att_text("gdy03","使用者编号")
                     CALL cl_set_comp_att_text("zw02", "使用者名称")
                     OTHERWISE
                     CALL cl_set_comp_att_text("gdy03","User")
                     CALL cl_set_comp_att_text("zw02", "User Name")            
                  END CASE               
            END INPUT
            
            #抓取使用者搜尋條件
            CONSTRUCT ms_cons_where ON zx01,zx02 FROM s_gdy03[1].gdy03,s_gdy03[1].zw02
            END CONSTRUCT

            ON ACTION ACCEPT
               LET li_cover = l_cover
            EXIT DIALOG
               
            ON ACTION CANCEL
               LET INT_FLAG=TRUE
            EXIT DIALOG
         END DIALOG
      END IF
   END CASE

   IF (INT_FLAG) THEN
      LET INT_FLAG = FALSE
      RETURN
   END IF
      
   IF (li_reconstruct) THEN
      CALL q_gdy03_prep_result_set()   #依照搜尋條件抓取資料
      
      # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
      IF (mi_page_count = 0) THEN
         LET mi_page_count = ma_qry.getLength()
      END IF
      # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
      IF (mi_page_count >= ma_qry.getLength()) THEN
         LET ls_hide_act = "prevpage,nextpage"
      END IF
     
      IF (NOT mi_need_cons) THEN
         IF (ls_hide_act IS NULL) THEN
            LET ls_hide_act = "reconstruct"
         ELSE
            LET ls_hide_act = "prevpage,nextpage,reconstruct"
         END IF 
      END IF
     
      LET li_start_index = 1
      LET li_reconstruct = FALSE   #已做過資料查詢，故設為FALSE代表不需要查詢
   END IF
   
      LET li_end_index = li_start_index + mi_page_count - 1
     
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF

      CALL q_gdy03_set_display_data(li_start_index, li_end_index)   #顯示資料
      LET li_curr_page = li_end_index / mi_page_count
      
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF

      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page

      DIALOG ATTRIBUTES(UNBUFFERED)   #顯示單頭單身資料，並提供選擇功能

         #單身段, 將勾選的資料存入ma_qry_tmp
         INPUT ARRAY ma_qry_tmp FROM s_gdy03.*
            ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE, APPEND ROW=FALSE, WITHOUT DEFAULTS=TRUE)
            
         BEFORE INPUT
            CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
            IF (ls_hide_act IS NOT NULL) THEN   
               CALL cl_set_act_visible(ls_hide_act, FALSE)
            END IF

         ON ACTION PREVPAGE
            CALL GET_FLDBUF(s_gdy03.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL q_gdy03_reset_multi_sel(li_start_index, li_end_index)
            LET li_start_index = li_start_index - mi_page_count
            IF ((li_start_index - mi_page_count) >= 1) THEN
               LET li_start_index = li_start_index - mi_page_count
            END IF
            LET li_continue = TRUE
            EXIT DIALOG
         
         ON ACTION nextpage
            CALL GET_FLDBUF(s_gdy03.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL q_gdy03_reset_multi_sel(li_start_index, li_end_index)
            IF ((li_start_index + mi_page_count) <= ma_qry.getLength()) THEN
               LET li_start_index = li_start_index + mi_page_count
            END IF
         LET li_continue = TRUE
         EXIT DIALOG
         
         ON ACTION refresh
            CALL q_gdy03_refresh()
            LET li_start_index = 1
            LET li_continue = TRUE
            EXIT DIALOG
            
         ON ACTION reconstruct
            LET li_reconstruct = TRUE
            LET li_continue = TRUE
            EXIT DIALOG
            
         ON ACTION ACCEPT
            IF ARR_CURR()>0 THEN
               CALL GET_FLDBUF(s_gdy03.check) RETURNING ma_qry_tmp[ARR_CURR()].CHECK
               CALL q_gdy03_reset_multi_sel(li_start_index, li_end_index)  
               CALL q_gdy03_accept(li_start_index+ARR_CURR()-1)
            ELSE
               LET ms_ret1 = NULL
            END IF         
            LET li_continue = FALSE
         EXIT DIALOG
         
         ON ACTION cancel
            LET INT_FLAG = 0
            IF (NOT mi_multi_sel) THEN
               LET ms_ret1 = ms_default1
               LET ms_ret2 = ms_default2
            END IF
            LET li_continue = FALSE
            EXIT DIALOG
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            #CONTINUE INPUT
 
 
         #ON ACTION exporttoexcel
            #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
    
 
         ON ACTION selectall
            FOR li_i = 1 TO ma_qry_tmp.getLength()
                LET ma_qry_tmp[li_i].check = "Y"
            END FOR
 
         ON ACTION select_none
            FOR li_i = 1 TO ma_qry_tmp.getLength()
                LET ma_qry_tmp[li_i].check = "N"
            END FOR
         END INPUT

         #單頭段
         INPUT l_cover FROM s_gdy03_t.gdy04 ATTRIBUTE (WITHOUT DEFAULTS = TRUE)
            BEFORE INPUT
               LET l_cover = li_cover
               DISPLAY l_cover TO s_gdy03_t.gdy04
               CALL cl_set_act_visible("accept,cancel", TRUE)

            AFTER INPUT
               LET li_cover = l_cover
               #CALL cl_set_act_visible("accept,cancel", TRUE)

            ON ACTION ACCEPT
               EXIT DIALOG
               
            ON ACTION CANCEL
               LET INT_FLAG=TRUE
            EXIT DIALOG    
         END INPUT         
      END DIALOG

     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF

      IF (INT_FLAG) THEN
         LET INT_FLAG = FALSE
         EXIT WHILE
      END IF
      
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author   : 2012/02/03 by downheal      
# Parameter   	   : none
# Return          : void
# Memo        	   : 依照傳入程式的留存類別不同，做不同的資料庫查詢
# Modify          :
##################################################
FUNCTION q_gdy03_prep_result_set()
   DEFINE   ls_sql   STRING
   DEFINE   li_i     INTEGER
   DEFINE   lr_qry   RECORD
         CHECK       LIKE type_file.chr1, 
         gdy03       LIKE gdy_file.gdy03,       
         zw02        LIKE zw_file.zw02
   END RECORD
   
   #傳入之留存類別參數,2:權限類別   
   IF (ms_type == 2) THEN
      LET ls_sql =  "SELECT 'N',zw01,zw02",
                   " FROM zw_file",
                   " WHERE ",ms_cons_where,
                   " ORDER BY zw01"
   END IF

   #傳入之留存類別參數,3:使用者   
   IF (ms_type == 3) THEN
      LET ls_sql =  "SELECT 'N',zx01,zx02",
                   " FROM zx_file",
                   " WHERE ",ms_cons_where,
                   " ORDER BY zx01"   
   END IF
   
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author   : 2012/02/03 by downheal       
# Parameter   	   : pi_start_index   INTEGER    所要顯現的查詢資料起始位置
#                 : pi_end_index     INTEGER    所要顯現的查詢資料結束位置
# Return          : void
# Memo        	   :
# Modify         :
##################################################
FUNCTION q_gdy03_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   INTEGER,
            pi_end_index     INTEGER
   DEFINE   li_i             INTEGER,
            li_j             INTEGER
 
   FOR li_i = ma_qry_tmp.getLength() TO 1 STEP -1
      CALL ma_qry_tmp.deleteElement(li_i)
   END FOR
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
##################################################
# Description   : 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2012/02/15 by downheal       
# Parameter   	 : ps_hide_act      STRING     所要隱藏的Action Button
#               : pi_start_index   INTEGER    所要顯現的查詢資料起始位置
#               : pi_end_index     INTEGER    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#           : SMALLINT   是否重新查詢
#           : INTEGER    改變後的起始位置
# Memo      :
# Modify   	:
##################################################
FUNCTION q_gdy03_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   INTEGER,
            pi_end_index     INTEGER
   DEFINE   li_continue      SMALLINT,
            li_reconstruct   SMALLINT,
            li_i             SMALLINT
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_gdy03.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
         
      ON ACTION prevpage
         CALL GET_FLDBUF(s_gdy03.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL q_gdy03_reset_multi_sel(pi_start_index, pi_end_index)
         LET pi_start_index = pi_start_index - mi_page_count
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
         
      ON ACTION nextpage
         CALL GET_FLDBUF(s_gdy03.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL q_gdy03_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT
         
      ON ACTION refresh
         CALL q_gdy03_refresh()
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT INPUT
         
      ON ACTION reconstruct          #重新查詢
         LET li_reconstruct = TRUE   #重新查詢參數設定為是
         LET li_continue = TRUE
         EXIT INPUT
         
      ON ACTION ACCEPT
         IF ARR_CURR()>0 THEN
            CALL GET_FLDBUF(s_gdy03.check) RETURNING ma_qry_tmp[ARR_CURR()].CHECK
            CALL q_gdy03_reset_multi_sel(pi_start_index, pi_end_index)  
            CALL q_gdy03_accept(pi_start_index+ARR_CURR()-1)
         ELSE
            LET ms_ret1 = NULL
         END IF         
         LET li_continue = FALSE
         EXIT INPUT
         
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
         END IF
         LET li_continue = FALSE
         EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      #No.FUN-660161--begin   
      #ON ACTION exporttoexcel
         #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end     
 
      ON ACTION selectall     #選項全選
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "Y"
         END FOR
 
      ON ACTION select_none   #選項全不選
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "N"
         END FOR
   
   END INPUT

   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author   : 2012/02/03 by downheal     
# Parameter   	   : pi_start_index   INTEGER    所要顯現的查詢資料起始位置
#                 : pi_end_index     INTEGER    所要顯現的查詢資料結束位置
# Return   	      : void
# Memo        	   :
# Modify   	      :
##################################################
FUNCTION q_gdy03_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   INTEGER,
            pi_end_index     INTEGER
   DEFINE   li_i             INTEGER,
            li_j             INTEGER
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author   : 2012/02/03 by downheal    
# Parameter   	   : ps_hide_act      STRING     所要隱藏的Action Button
#                 : pi_start_index   INTEGER    所要顯現的查詢資料起始位置
#                 : pi_end_index     INTEGER    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#           : SMALLINT   是否重新查詢
#           : INTEGER    改變後的起始位置
# Memo      :
# Modify   	:
##################################################
FUNCTION q_gdy03_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   INTEGER,
            pi_end_index     INTEGER
   DEFINE   li_continue      SMALLINT,
            li_reconstruct   SMALLINT

   DISPLAY ARRAY ma_qry_tmp TO s_gdy03.*
      BEFORE DISPLAY
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT DISPLAY
         
      ON ACTION nextpage
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT DISPLAY
         
      ON ACTION refresh
         LET ms_ret1 = ""
         LET ms_ret2 = ""
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT DISPLAY
         
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         EXIT DISPLAY
         
      ON ACTION accept
         IF cl_null(ms_ret2) THEN
            CALL q_gdy03_accept(pi_start_index+ARR_CURR()-1)
         END IF
         LET li_continue = FALSE
         EXIT DISPLAY
         
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
         END IF
         LET ms_ret1 = ""
         LET ms_ret2 = ""
         LET li_continue = FALSE
         EXIT DISPLAY
         
      # 2003/10/13 by saki : 組合摘要功能鍵
      ON ACTION select
         CALL q_gdy03_accept(pi_start_index+ARR_CURR()-1)
     
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      #ON ACTION exporttoexcel
         #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')   
   END DISPLAY
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2012/02/03 by downheal    
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION q_gdy03_refresh()
   DEFINE   li_i   INTEGER
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author   : 2012/02/03 by downheal      
# Parameter   	   : pi_sel_index   INTEGER    所選擇的資料索引
# Return   	: void
# Memo      :
# Modify   	:
##################################################
FUNCTION q_gdy03_accept(pi_sel_index)
   DEFINE   pi_sel_index    INTEGER,
   #DEFINE   lsb_multi_name  base.StringBuffer,
            #lsb_multi_sel   base.StringBuffer,
            li_i            INTEGER,
            li_qry          INTEGER

   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET li_qry = 1
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            LET ma_qry_final[li_qry].gdy03 = ma_qry[li_i].gdy03
            LET ma_qry_final[li_qry].zw02 = ma_qry[li_i].zw02
            LET li_qry = li_qry + 1
         END IF
      END FOR
   END IF
END FUNCTION
