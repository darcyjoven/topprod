# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_keyrelat.sql
# Descriptions...: 相關鍵值說明查詢出其中一個需要的
# Date & Author..: 03/12/25 by hjwang
# Source From....: 03/09/23 by carrier q_apa2, saki p_keyrelat
# Memo...........: 本程式無 multiselect 的必要
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: No.FUN-680147 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-850069 08/05/14 By alex 調整說明
 
DATABASE ds   #FUN-850069
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         gae01    LIKE gae_file.gae01,
         gae03    LIKE gae_file.gae03,
         gae04    LIKE gae_file.gae04,
         keysts   LIKE gae_file.gae01         #No.FUN-680147 VARCHAR(15)
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         gae01    LIKE gae_file.gae01,
         gae03    LIKE gae_file.gae03,
         gae04    LIKE gae_file.gae04,
         keysts   LIKE gae_file.gae01         #No.FUN-680147 VARCHAR(15)
END RECORD
 
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10        #No.FUN-680147 INTEGER  #每頁顯現資料筆數.
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING     
DEFINE   ms_error         STRING     
DEFINE   mc_lang          LIKE type_file.chr1         #No.FUN-680147 VARCHAR(1)
DEFINE   ms_gae03         STRING 
DEFINE   mi_select_type   STRING                      #No.FUN-680147 STRING  #選擇模式 TRUE:在gau03找到, FALSE:gau01
 
# Descriptions...: 相關鍵值說明查詢出其中一個需要的
 
FUNCTION s_keyrelat(ps_default1,ps_gae03,pc_lang)
   DEFINE   ps_default1    STRING
   DEFINE   pc_lang        LIKE type_file.chr1        #No.FUN-680147 VARCHAR(1)
   DEFINE   ps_gae03       STRING
 
   LET ms_default1 = ps_default1
   LET ms_ret1     = ps_default1
   LET mc_lang  = pc_lang
   LET ms_gae03 = ps_gae03
 
   INITIALIZE ms_error TO NULL
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "sub/42f/s_keyrelat"
   ATTRIBUTE( STYLE = g_win_style )
 
   CALL cl_ui_locale("s_keyrelat")
 
   CALL keyrelat_qry_sel()
 
   CLOSE WINDOW w_qry
 
   RETURN ms_ret1 
END FUNCTION
 
# Descriptions...: 畫面顯現與資料的選擇.
# Input Parameter: none
# Return Code....: void
# Private Func...: TRUE
 
FUNCTION keyrelat_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,         #No.FUN-680147 SMALLINT  #是否隱藏'上下頁'的按鈕.
            li_continue      LIKE type_file.num5          #No.FUN-680147 SMALLINT  #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10,        #No.FUN-680147 INTEGER
            li_end_index     LIKE type_file.num10         #No.FUN-680147 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
#   LET mi_page_count = 20 
 
   WHILE TRUE
      CLEAR FORM
 
      LET INT_FLAG = FALSE
 
         CALL keyrelat_qry_prep_result_set()
         IF NOT cl_null(ms_error) THEN RETURN END IF
         # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
         IF (mi_page_count >= ma_qry.getLength()) THEN
            LET ls_hide_act = "prevpage,nextpage"
         END IF
 
         IF (ls_hide_act IS NOT NULL) THEN
            LET ls_hide_act = "prevpage,nextpage"
         END IF
 
         LET li_start_index = 1
 
      LET li_end_index = li_start_index + mi_page_count - 1
 
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF
 
      CALL keyrelat_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
      MESSAGE "Total count : " || ma_qry.getLength() || "  Page : " || li_curr_page
 
      CALL keyrelat_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_start_index
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
# Private Func...: TRUE
 
FUNCTION keyrelat_qry_prep_result_set()
   DEFINE   ls_sql   LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(700)
            ls_where LIKE type_file.chr1000        #No.FUN-680147 VARCHAR(500)
   DEFINE   li_i     LIKE type_file.num10          #No.FUN-680147 INTEGER
   DEFINE   ls_cnt   LIKE type_file.num5           #No.FUN-680147 SMALLINT
   DEFINE   lc_gau01 LIKE gau_file.gau01           #取得gau01
   DEFINE   lc_gau03 LIKE gau_file.gau03
   DEFINE   lc_gae03 LIKE gae_file.gae03
   DEFINE   lr_qry   RECORD
            gae01    LIKE gae_file.gae01,
            gae03    LIKE gae_file.gae03,                   
            gae04    LIKE gae_file.gae04,
            keysts   LIKE gae_file.gae01           #No.FUN-680147 VARCHAR(15)
   END RECORD
   LET li_i=0
   LET lc_gae03 = ms_gae03 CLIPPED
   INITIALIZE ls_where TO NULL
 
   # 選擇gau01
   SELECT count(*) INTO li_i FROM gau_file WHERE gau03 = lc_gae03
   IF STATUS OR li_i = 0 THEN
      SELECT count(*) INTO li_i FROM gau_file WHERE gau01 = lc_gae03
      IF STATUS THEN
         LET ms_error = 'error in select' 
      ELSE
         LET lc_gau01 = lc_gae03
      END IF
   ELSE
      SELECT distinct gau01 INTO lc_gau01 FROM gau_file WHERE gau03 = lc_gae03
   END IF
   IF NOT cl_null(ms_error) THEN RETURN END IF
 
   #以下為 referance p_keyrelat
 
   SELECT COUNT(gau03) INTO ls_cnt FROM gau_file WHERE gau01 = lc_gau01
   LET ls_sql = "SELECT gau03 FROM gau_file ",
                " WHERE gau01 = '",lc_gau01 CLIPPED,"'",
                " ORDER BY gau03 "
   PREPARE p_keyrelat_batch FROM ls_sql
   DECLARE batch_cur CURSOR FOR p_keyrelat_batch
   LET li_i = 1
   FOREACH batch_cur INTO lc_gau03
      IF SQLCA.sqlcode THEN
         CALL cl_err('batch_cur:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET ls_where = ls_where CLIPPED," gae03 = '", lc_gau03,"'"
      IF li_i < ls_cnt THEN
         LET ls_where = ls_where CLIPPED, " OR "
      END IF
      LET li_i = li_i + 1
   END FOREACH
   IF NOT cl_null(ls_where) THEN
      LET ls_where = ls_where CLIPPED, " OR gae03 = '",lc_gau01 CLIPPED,"'"
   END IF
   CASE mc_lang
      WHEN '0' LET ls_sql = "SELECT gae01,gae03,gae04,'' "
      WHEN '1' LET ls_sql = "SELECT gae01,gae03,gae05,'' "
      WHEN '2' LET ls_sql = "SELECT gae01,gae03,gae06,'' "
      OTHERWISE
               LET ls_sql = "SELECT gae01,gae03,gae04,'' "
   END CASE
 
   LET ls_sql = ls_sql CLIPPED, " FROM gae_file",
                       " WHERE ",ls_where CLIPPED,
                       " ORDER BY gae03,gae01"
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err("FOREACH:", SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
      IF lr_qry.gae03 = lc_gau01 THEN
         LET lr_qry.keysts = 'Primary KEY'
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
 
# Input Parameter: pi_start_index   INTEGER   所要顯現的查詢資料起始位置
#                  pi_end_index     INTEGER   所要顯現的查詢資料結束位置
# Return Code....: void
# Private Func...: TRUE
 
FUNCTION keyrelat_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,        #No.FUN-680147 INTEGER
            pi_end_index     LIKE type_file.num10         #No.FUN-680147 INTEGER
   DEFINE   li_i             LIKE type_file.num10,        #No.FUN-680147 INTEGER
            li_j             LIKE type_file.num10         #No.FUN-680147 INTEGER
 
   FOR li_i = ma_qry_tmp.getLength() TO 1 STEP -1
      CALL ma_qry_tmp.deleteElement(li_i)
   END FOR
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
# Input Parameter: ps_hide_act      STRING    所要隱藏的Action Button
#                  pi_start_index   INTEGER   所要顯現的查詢資料起始位置
#                  pi_end_index     INTEGER   所要顯現的查詢資料結束位置
# Return Code....: SMALLINT   是否繼續
#                  SMALLINT   是否重新查詢
#                  INTEGER    改變後的起始位置
# Private Func...: TRUE
 
FUNCTION keyrelat_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,        #No.FUN-680147 INTEGER
            pi_end_index     LIKE type_file.num10         #No.FUN-680147 INTEGER
   DEFINE   li_continue      LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_keyrelat.*
      BEFORE DISPLAY
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
 
      ON ACTION accept
         CALL keyrelat_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
         EXIT DISPLAY
 
      ON ACTION cancel
         LET ms_ret1 = ms_default1
         LET li_continue = FALSE
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,pi_start_index
END FUNCTION
 
# Input Parameter: pi_sel_index   INTEGER   所選擇的資料索引
# Return Code....: void
# Private Func...: TRUE
 
FUNCTION keyrelat_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10        #No.FUN-680147 INTEGER
   DEFINE   li_i            LIKE type_file.num10        #No.FUN-680147 INTEGER
 
   LET ms_ret1 = ma_qry[pi_sel_index].gae04 CLIPPED
 
END FUNCTION
