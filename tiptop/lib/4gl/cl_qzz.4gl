# Prog. Version..: '5.30.06-13.03.12(00000)'     #
 
# Program name...: cl_qzz.sql
# Descriptions...: 程式代碼查詢
# Date & Author..: 2004/01/15 by saki
# Modify.........: No.TQC-630109 06/03/10 By saki Array最大筆數控制
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-7C0059 07/12/19 By saki 調整備註事項
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1)
         zz01     LIKE zz_file.zz01,
         gaz03    LIKE gaz_file.gaz03
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1)
         zz01         LIKE zz_file.zz01,
         gaz03        LIKE gaz_file.gaz03
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5             #No.FUN-690005  SMALLINT   #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5             #No.FUN-690005  SMALLINT   #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10            #No.FUN-690005  INTEGER    #每頁顯現資料筆數.
DEFINE   ms_default1      STRING  
DEFINE   ms_ret1          STRING  
 
##################################################
# Descriptions...: 存在權限設定作業內的程式代碼查詢
# Date & Author..: 2004/01/15 by saki
# Input Parameter: pi_multi_sel   Y/N 是否多選
#                  pi_need_cons   Y/N 是否可查詢
#                  ps_default1    程式代碼預設值
# Return code....: ms_ret1        程式代碼
# Modify.........: No.FUN-7C0059 07/12/19 by saki
##################################################
FUNCTION cl_qzz(pi_multi_sel,pi_need_cons,ps_default1)
   DEFINE   pi_multi_sel   LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            pi_need_cons   LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            ps_default1    STRING    
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET ms_default1 = ps_default1 
 
   OPEN WINDOW w_qry WITH FORM "lib/42f/cl_qzz" ATTRIBUTE(STYLE="createqry")
 
   CALL cl_ui_locale("cl_qzz")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("zz01", "red")
   END IF
 
   CALL qzz_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
   END IF
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 畫面顯現與資料的選擇.
# Date & Author..: 2004/01/15 by saki
# Input Parameter: none
# Return Code....: void
##################################################
FUNCTION qzz_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,             #No.FUN-690005  SMALLINT   #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,             #No.FUN-690005  SMALLINT   #是否重新CONSTRUCT.預設為TRUE. 
            li_continue      LIKE type_file.num5              #No.FUN-690005  SMALLINT    #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10,            #No.FUN-690005  INTEGER
            li_end_index     LIKE type_file.num10             #No.FUN-690005  INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5             #No.FUN-690005  SMALLINT
 
 
   LET mi_page_count = 20 
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON zz01,gaz03
                                  FROM s_zz[1].zz01,s_zz[1].gaz03
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL qzz_qry_prep_result_set() 
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
     
         LET li_reconstruct = FALSE
      END IF
     
      LET li_end_index = li_start_index + mi_page_count - 1
     
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF
     
      CALL qzz_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
      MESSAGE "Total count : " || ma_qry.getLength() || "  Page : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL qzz_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL qzz_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 準備查詢畫面的資料集.
# Date & Author..: 2004/01/15 by saki
# Input Parameter: none
# Return Code....: void
##################################################
FUNCTION qzz_qry_prep_result_set()
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10            #No.FUN-690005  INTEGER
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,             #No.FUN-690005  VARCHAR(1) 
            zz01       LIKE zz_file.zz01,
            gaz03      LIKE gaz_file.gaz03
   END RECORD
 
 
#  IF g_lang = '0' THEN
#     LET ls_sql = "SELECT 'N',zz01,zz02", 
#                  " FROM zz_file,zy_file,zx_file",
#                  " WHERE ",ms_cons_where CLIPPED
#  ELSE
#     LET ls_sql = "SELECT 'N',zz01,zz02e", 
#                  " FROM zz_file,zy_file,zx_file",
#                  " WHERE ",ms_cons_where CLIPPED
#  END IF
   IF (NOT mi_multi_sel) THEN
   LET ls_sql = "SELECT 'N',zz01,gaz03",
                "  FROM zz_file,gaz_file,zx_file,zy_file",
                " WHERE zz01 = gaz01 AND gaz02 = '",g_lang,"'",
                " AND zz01 = zy02 AND zy01 = zx04 AND zx01 = '",g_user,"'",
                "   AND ",ms_cons_where CLIPPED
   ELSE
      LET ls_sql = "SELECT 'N',zz01,gaz03",
                   "  FROM zz_file,gaz_file",
                   " WHERE zz01 = gaz01 AND gaz02 = '",g_lang,"'",
                   "   AND ",ms_cons_where CLIPPED
   END IF
   LET ls_sql = ls_sql CLIPPED," ORDER BY zz01"
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
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
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定查詢畫面的顯現資料.
# Date & Author..: 2004/01/15 by saki
# Input Parameter: pi_start_index   INTEGER   所要顯現的查詢資料起始位置
#                  pi_end_index     INTEGER   所要顯現的查詢資料結束位置
# Return Code....: void
##################################################
FUNCTION qzz_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,            #No.FUN-690005  INTEGER
            pi_end_index     LIKE type_file.num10             #No.FUN-690005  INTEGER
   DEFINE   li_i             LIKE type_file.num10,            #No.FUN-690005  INTEGER
            li_j             LIKE type_file.num10             #No.FUN-690005  INTEGER
 
 
   CALL ma_qry_tmp.clear()
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author..: 2004/01/15 by saki
# Input Parameter: ps_hide_act      STRING    所要隱藏的Action Button
#                  pi_start_index   INTEGER   所要顯現的查詢資料起始位置
#                  pi_end_index     INTEGER   所要顯現的查詢資料結束位置
# Return Code....: SMALLINT   是否繼續
#                  SMALLINT   是否重新查詢
#                  INTEGER    改變後的起始位置
##################################################
FUNCTION qzz_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,            #No.FUN-690005  INTEGER
            pi_end_index     LIKE type_file.num10             #No.FUN-690005  INTEGER
   DEFINE   li_continue      LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            li_reconstruct   LIKE type_file.num5              #No.FUN-690005  SMALLINT
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_zz.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_zz.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL qzz_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_zz.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL qzz_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL qzz_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         CALL GET_FLDBUF(s_zz.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL qzz_qry_reset_multi_sel(pi_start_index, pi_end_index)
         CALL qzz_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 重設查詢資料關於'check'欄位的值.
# Date & Author..: 2004/01/15 by saki
# Input Parameter: pi_start_index   INTEGER   所要顯現的查詢資料起始位置
#                  pi_end_index     INTEGER   所要顯現的查詢資料結束位置
# Return Code....: void
##################################################
FUNCTION qzz_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,            #No.FUN-690005  INTEGER
            pi_end_index     LIKE type_file.num10             #No.FUN-690005  INTEGER
   DEFINE   li_i             LIKE type_file.num10,            #No.FUN-690005  INTEGER
            li_j             LIKE type_file.num10             #No.FUN-690005  INTEGER
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author..: 2004/01/15 by saki
# Input Parameter: ps_hide_act      STRING    所要隱藏的Action Button
#                  pi_start_index   INTEGER   所要顯現的查詢資料起始位置
#                  pi_end_index     INTEGER   所要顯現的查詢資料結束位置
# Return Code....: SMALLINT   是否繼續
#                  SMALLINT   是否重新查詢
#                  INTEGER    改變後的起始位置
##################################################
FUNCTION qzz_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,            #No.FUN-690005  INTEGER
            pi_end_index     LIKE type_file.num10             #No.FUN-690005  INTEGER
   DEFINE   li_continue      LIKE type_file.num5,             #No.FUN-690005  SMALLINT
            li_reconstruct   LIKE type_file.num5              #No.FUN-690005  SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_zz.*
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
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION accept
         CALL qzz_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 重設查詢資料.
# Date & Author..: 2004/01/15 by saki
# Input Parameter: none
# Return Code....: void
##################################################
FUNCTION qzz_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10            #No.FUN-690005  INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 選擇並確認資料.
# Date & Author..: 2004/01/15 by saki
# Input Parameter: pi_sel_index   INTEGER   所選擇的資料索引
# Return Code....: void
##################################################
FUNCTION qzz_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10            #No.FUN-690005  INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10            #No.FUN-690005  INTEGER 
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].zz01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].zz01 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].zz01 CLIPPED
   END IF
END FUNCTION
