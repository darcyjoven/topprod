# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_usermail.sql
# Descriptions...: 查詢 e-mail地址
# Date & Author..: 04/01/01 by alex
# Modify.........: No.TQC-5A0092 05/10/26 By alex 修改畫面
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-850069 08/05/14 By alex 調整說明
 
DATABASE ds   #FUN-850069  FUN-7C0053
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
         zx01     LIKE zx_file.zx01,
         zx02     LIKE zx_file.zx02,
         zx03     LIKE zx_file.zx03,
         zx09     LIKE zx_file.zx09
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
         zx01         LIKE zx_file.zx01,
         zx02         LIKE zx_file.zx02,
         zx03         LIKE zx_file.zx03,
         zx09         LIKE zx_file.zx09
END RECORD
DEFINE   ma_noemail DYNAMIC ARRAY OF RECORD
         zx01       LIKE zx_file.zx01
                    END RECORD
DEFINE   g_cnt      LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 
# 本程序預設為 mi_multi_sel=TRUE 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE). 	#No.FUN-680147 SMALLINT
 
# 本程序預設 mi_need_cons 為依ms_default1 or ms_default 是否為 null or empty定
# 若此二為 null or empty 則定為 FALSE
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE). 	#No.FUN-680147 SMALLINT
 
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數. 	#No.FUN-680147 INTEGER
DEFINE   ms_default1      STRING,    #User Name (multi-select)
         ms_default2      STRING,    #Relat E-mail address (multi-select)
         ms_mime          LIKE type_file.num5     #是否使用MIME格式回傳E-mail(TRUE/FALSE) 	#No.FUN-680147 SMALLINT
DEFINE   ms_zx01          STRING,    #User Name (multi-select)
         ms_zx09          STRING     #Relat E-mail address (multi-select)
DEFINE   ms_ret1          STRING,    #User Name (multi-select)
         ms_ret2          STRING     #Relat E-mail address (multi-select)
 
FUNCTION s_usermail(pi_multi_sel,pi_need_cons,ps_zx01,ps_zx09,pi_mime)
   DEFINE   pi_multi_sel   LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
            pi_need_cons   LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
            ps_zx01        STRING,
            ps_zx09        STRING,
            pi_mime        LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE   lnode_root     om.DomNode
   DEFINE   llst_items     om.NodeList
   DEFINE   lnode_item     om.DomNode
   DEFINE   li_i           LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET ms_default1 = ps_zx01
   LET ms_default2 = ps_zx09
   LET ms_zx01     = ps_zx01
   LET ms_zx09     = ps_zx09
   LET ms_mime     = pi_mime
 
   OPEN WINDOW w_qry WITH FORM "sub/42f/s_usermail"
   ATTRIBUTE( STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("s_usermail")
 
# 2004/01/01 關閉此功能
#  LET mi_multi_sel = pi_multi_sel
#  LET mi_need_cons = pi_need_cons
 
# 本程序預設為 mi_multi_sel=TRUE 
   LET mi_multi_sel = TRUE
 
# 本程序預設 mi_need_cons 為依ms_default1 or ms_default 是否為 null or empty定
# 若此二為 null or empty 則定為 FALSE
   IF NOT cl_null(ms_default1) OR NOT cl_null(ms_default2) THEN
      LET mi_need_cons = FALSE
   ELSE
      LET mi_need_cons = TRUE
   END IF
 
   # 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      LET lnode_root = ui.Interface.getRootNode()
      LET llst_items = lnode_root.selectByTagName("TableColumn")
      FOR li_i=1 TO llst_items.getLength()
          LET lnode_item = llst_items.item(li_i)
          IF (lnode_item.getAttribute("colName") = "check") THEN
             LET lnode_item = lnode_item.getFirstChild()
             CALL lnode_item.setAttribute("hidden","1")
             EXIT FOR
          END IF
      END FOR
   END IF
 
   # 2004/01/01 關閉此功能
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   # IF (mi_multi_sel) THEN
   #    CALL cl_set_comp_font_color("img02", "red")
   # END IF
 
   CALL usermail_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1,ms_ret2 
   ELSE
      RETURN ms_ret1,ms_ret2
   END IF
END FUNCTION
 
# Descriptions...: 畫面顯現與資料的選擇.
# Input Parameter: none
# Return Code....: void
# Private Func...: TRUE
 
FUNCTION usermail_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕. 	#No.FUN-680147 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE.  	#No.FUN-680147 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續. 	#No.FUN-680147 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10,  	#No.FUN-680147 INTEGER
            li_end_index     LIKE type_file.num10  	#No.FUN-680147 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 
   LET mi_page_count = 100 
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON zx01,zx02,zx03,zx09
                 FROM s_zx[1].zx01,s_zx[1].zx02,s_zx[1].zx03,s_zx[1].zx09
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         ELSE
            LET ms_cons_where = "1=1"
         END IF
     
         CALL usermail_qry_prep_result_set() 
         # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',
         #                      則預設為CLIPPED所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'
         #                      超過/等於所有資料,則要隱藏'上下頁'的按鈕.
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
     
         LET li_reconstruct = FALSE
      END IF
     
      LET li_end_index = li_start_index + mi_page_count - 1
     
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF
     
      CALL usermail_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      MESSAGE "Total count : " || ma_qry.getLength() || "  Page : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL usermail_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL usermail_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
# Descriptions...: 準備查詢畫面的資料集.
# Input Parameter: none
# Return Code....: void
# Private Func...: TRUE
 
FUNCTION usermail_qry_prep_result_set()
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10  	#No.FUN-680147 INTEGER
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,    	#No.FUN-680147 VARCHAR(1)
            zx01       LIKE zx_file.zx01,
            zx02       LIKE zx_file.zx02,
            zx03       LIKE zx_file.zx03,
            zx09       LIKE zx_file.zx09
   END RECORD
 
   LET ls_sql = "SELECT 'N',zx01,zx02,zx03,zx09 ", 
                 " FROM zx_file",
                " WHERE ",ms_cons_where CLIPPED
 
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY zx01,zx03,zx01,zx09" 
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   LET g_cnt = 1
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
      #No.TQC-630109 --start--
      IF li_i > g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
      #No.TQC-630109 ---end---
   END FOREACH
END FUNCTION
 
# Descriptions...: 設定查詢畫面的顯現資料.
# Input Parameter: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置 	#No.FUN-680147
#                  pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置 	#No.FUN-680147
# Return Code....: void
# Private Func...: TRUE
 
FUNCTION usermail_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,  	#No.FUN-680147 INTEGER
            pi_end_index     LIKE type_file.num10  	#No.FUN-680147 INTEGER
   DEFINE   li_i             LIKE type_file.num10,  	#No.FUN-680147 INTEGER
            li_j             LIKE type_file.num10  	#No.FUN-680147 INTEGER
 
   CALL ma_qry_tmp.clear()
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
# Descriptions...: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Input Parameter: ps_hide_act      STRING    所要隱藏的Action Button
#                  pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置 	#No.FUN-680147
#                  pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置 	#No.FUN-680147
# Return Code....: SMALLINT   是否繼續
#                  SMALLINT   是否重新查詢
#                  INTEGER    改變後的起始位置
# Private Func...: TRUE
 
FUNCTION usermail_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,  	#No.FUN-680147 INTEGER
            pi_end_index     LIKE type_file.num10  	#No.FUN-680147 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
            li_reconstruct   LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE   li_i             LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE   l_str            STRING
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_zx.*
         ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
     
      ON ACTION prevpage
         CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL usermail_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
         EXIT INPUT
     
      ON ACTION nextpage
         CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL usermail_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
         EXIT INPUT
     
      ON ACTION refresh
         CALL usermail_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT INPUT
 
      ON ACTION accept
         CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL usermail_qry_reset_multi_sel(pi_start_index, pi_end_index)
         CALL usermail_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         LET l_str = NULL
         FOR li_i = 1 TO ma_noemail.getLength()
             LET l_str = l_str,ma_noemail[li_i].zx01 CLIPPED,"  "
         END FOR
         IF NOT cl_null(l_str) THEN
            CALL cl_err_msg("","lib-048",l_str,1)
         END IF
 
         EXIT INPUT
     
#     ON ACTION enter # 2003/06/03 by Hiko : 為了讓'Enter'與'Accept'功能相同的設定.
#        CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
#        CALL usermail_qry_reset_multi_sel(pi_start_index, pi_end_index)
#        CALL usermail_qry_accept(pi_start_index+ARR_CURR()-1)
#        LET li_continue = FALSE
#        EXIT INPUT
     
      ON ACTION cancel
         LET ms_ret1 = ms_default1
         LET ms_ret2 = ms_default2
 
         LET li_continue = FALSE
         EXIT INPUT
     
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
# Descriptions...: 重設查詢資料關於'check'欄位的值.
# Input Parameter: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置 	#No.FUN-680147
#                  pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置 	#No.FUN-680147
# Return Code....: void
# Private Func...: TRUE
 
FUNCTION usermail_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,  	#No.FUN-680147 INTEGER
            pi_end_index     LIKE type_file.num10  	#No.FUN-680147 INTEGER
   DEFINE   li_i             LIKE type_file.num10,  	#No.FUN-680147 INTEGER
            li_j             LIKE type_file.num10  	#No.FUN-680147 INTEGER
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
# Descriptions...: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Input Parameter: ps_hide_act      STRING    所要隱藏的Action Button
#                  pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置 	#No.FUN-680147
#                  pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置 	#No.FUN-680147
# Return Code....: SMALLINT   是否繼續
#                  SMALLINT   是否重新查詢
#                  INTEGER    改變後的起始位置
# Private Func...: TRUE
 
FUNCTION usermail_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,  	#No.FUN-680147 INTEGER
            pi_end_index     LIKE type_file.num10  	#No.FUN-680147 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
            li_reconstruct   LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE   li_i             LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE   l_str            STRING
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_zx.*
 
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
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT DISPLAY
      
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         EXIT DISPLAY
      
      ON ACTION accept
         CALL usermail_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         LET l_str = NULL
         FOR li_i = 1 TO ma_noemail.getLength()
             LET l_str = l_str,ma_noemail[li_i].zx01 CLIPPED,"  "
         END FOR
         IF NOT cl_null(l_str) THEN
            DISPLAY l_str,"無設定email, 所以不列入mail list中"
         END IF
 
         EXIT DISPLAY
      
      ON ACTION enter # 2003/06/03 by Hiko : 為了讓'Enter'與'Accept'功能相同的設定.
         CALL usermail_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
         EXIT DISPLAY
      
      ON ACTION cancel
         LET ms_ret1 = ms_default1
         LET ms_ret2 = ms_default2
 
         LET li_continue = FALSE
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
# Descriptions...: 重設查詢資料.
# Input Parameter: none
# Return Code....: void
# Private Func...: TRUE
 
FUNCTION usermail_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10  	#No.FUN-680147 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
# Descriptions...: 選擇並確認資料.
# Input Parameter: pi_sel_index   LIKE type_file.num10    所選擇的資料索引 	#No.FUN-680147
# Return Code....: void
# Private Func...: TRUE
 
FUNCTION usermail_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10  	#No.FUN-680147 INTEGER
   DEFINE   lsb_multi_zx01  base.StringBuffer
   DEFINE   lsb_multi_zx09  base.StringBuffer
   DEFINE   li_i            LIKE type_file.num10   	#No.FUN-680147 INTEGER
 
 
   CALL ma_noemail.clear()
   IF (mi_multi_sel) THEN
      LET lsb_multi_zx01 = base.StringBuffer.create()
      LET lsb_multi_zx09 = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF cl_null(ma_qry[li_i].zx09) THEN
               SELECT gen06 INTO ma_qry[li_i].zx09 FROM gen_file WHERE gen01 = ma_qry[li_i].zx01
               IF cl_null(ma_qry[li_i].zx09) THEN
                  LET ma_noemail[g_cnt].zx01 = ma_qry[li_i].zx01
                  LET g_cnt = g_cnt + 1
                  CONTINUE FOR
               END IF
            END IF
            IF (lsb_multi_zx01.getLength() = 0) THEN
               CALL lsb_multi_zx01.append(ma_qry[li_i].zx01 CLIPPED)
               CALL lsb_multi_zx09.append(ma_qry[li_i].zx09 CLIPPED)
               CALL lsb_multi_zx09.append(":" || ma_qry[li_i].zx02 CLIPPED)
            ELSE
               CALL lsb_multi_zx01.append(";" || ma_qry[li_i].zx01 CLIPPED)
               CALL lsb_multi_zx09.append(";" || ma_qry[li_i].zx09 CLIPPED)
               CALL lsb_multi_zx09.append(":" || ma_qry[li_i].zx02 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_zx01.toString()
      LET ms_ret2 = lsb_multi_zx09.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].zx01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].zx09 CLIPPED
   END IF
END FUNCTION
