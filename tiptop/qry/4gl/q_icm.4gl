# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name  : q_imc.4gl
# Description   : 下階料件查詢
# Date & Author : 2012/03/30 by Bart (#FUN-C30305)

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         icm02    LIKE icm_file.icm02,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         icm02    LIKE icm_file.icm02,
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021
END RECORD

DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.
DEFINE   ms_default1      STRING 
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   mc_icm01         LIKE icm_file.icm01
DEFINE   l_i              LIKE type_file.num10
   
FUNCTION q_icm(pi_multi_sel,pi_need_cons,ps_default1,p_icm01)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_default1    STRING  , #預設回傳值(在取消時會回傳此類預設值).
            p_icm01        LIKE icm_file.icm01
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_icm" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_icm")
   
   LET ms_default1 = ps_default1
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   LET mc_icm01 = p_icm01
 
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   CALL q_icm_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1 #回傳值(也許有多個).
   END IF
END FUNCTION

##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2012/03/30 by Bart
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION q_icm_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE.
            li_continue      LIKE type_file.num5      #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10,
            li_end_index     LIKE type_file.num10
   DEFINE   li_curr_page     LIKE type_file.num5
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 #每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE

         CALL q_icm_qry_prep_result_set() 
         #  如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         #  如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
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
     
      LET li_end_index = li_start_index + mi_page_count - 1
     
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF
     
      CALL q_icm_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file 
       WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file 
       WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      CALL q_icm_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
     
END FUNCTION

 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2012/03/30 by Bart
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION q_icm_qry_prep_result_set()
   DEFINE   l_j      LIKE type_file.num5 
      
      FOR l_i = ma_qry.getLength() TO 1 STEP -1
         CALL ma_qry.deleteElement(l_i)
      END FOR
 
      LET l_i = 1
      CALL q_icm_get_icm02(mc_icm01)
      LET l_j = 1
      WHILE (l_j < l_i)
         CALL q_icm_get_icm02(ma_qry[l_j].icm02)
         LET l_j = l_j + 1
      END WHILE 
END FUNCTION

FUNCTION q_icm_get_icm02(p_icm01)
DEFINE p_icm01 LIKE icm_file.icm01
DEFINE lr_qry   RECORD
       icm02    LIKE icm_file.icm02,
       ima02    LIKE ima_file.ima02,
       ima021   LIKE ima_file.ima021
                END RECORD
DEFINE  l_sql   STRING   
        
   LET l_sql=" SELECT icm02,ima02,ima021 ",
             " FROM icm_file, ima_file ",
             " WHERE icm02 = ima01 ",
             "   AND icm01 = '",p_icm01,"'"

   DECLARE lcurs_qry1 CURSOR FROM l_sql 
   
   FOREACH lcurs_qry1 INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(l_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      #判斷是否已達選取上限
      IF l_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      LET ma_qry[l_i].* = lr_qry.*
      LET l_i = l_i + 1
   END FOREACH
   CLOSE lcurs_qry1
END FUNCTION 

##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2012/03/30 by Bart
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION q_icm_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_i             LIKE type_file.num10,
            li_j             LIKE type_file.num10
 
 
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
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2012/03/30 by Bart
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION q_icm_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_icm.*
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
      ON ACTION accept
         CALL q_icm_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0
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
# Description  	: 選擇並確認資料.
# Date & Author : 2012/03/30 by Bart
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION q_icm_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].icm02 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].icm02 CLIPPED)
            END IF
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].icm02 CLIPPED
   END IF
END FUNCTION
#FUN-C30305
