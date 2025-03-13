# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name  : q_zaa2.4gl
# Program ver.  : 7.0
# Description   : 多行式報表樣版查詢
# Date & Author : 2007/06/11 by Echo  FUN-6B0098
# Modify        :
 
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
 
DATABASE ds
 
#FUN-6B0098
 
GLOBALS "../../config/top.global"
 
DEFINE   mi_multi_sel     LIKE type_file.num5   #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5   #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_default1      STRING     
DEFINE   ms_arg1          LIKE zaa_file.zaa01     
DEFINE   ms_arg2          LIKE zaa_file.zaa03    
DEFINE   ms_arg3          LIKE zaa_file.zaa10     
DEFINE   ms_arg4          LIKE zaa_file.zaa04     
DEFINE   ms_arg5          LIKE zaa_file.zaa17
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_ret2          STRING     #回傳欄位的變數
DEFINE   ms_ret3          STRING     #回傳欄位的變數
DEFINE   ms_ret4          STRING     #回傳欄位的變數
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         zaa04            LIKE zaa_file.zaa04,
         zaa17            LIKE zaa_file.zaa17,
         zaa11            LIKE zaa_file.zaa11,
         gae04            LIKE gae_file.gae04
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         zaa04            LIKE zaa_file.zaa04,
         zaa17            LIKE zaa_file.zaa17,
         zaa11            LIKE zaa_file.zaa11,
         gae04            LIKE gae_file.gae04
END RECORD
FUNCTION q_zaa2(pi_multi_sel,pi_need_cons,ps_arg1,ps_arg2,ps_arg3,ps_arg4,ps_arg5)
DEFINE   pi_multi_sel     LIKE type_file.num5,
         pi_need_cons     LIKE type_file.num5
DEFINE   ps_arg1          LIKE zaa_file.zaa01     
DEFINE   ps_arg2          LIKE zaa_file.zaa03    
DEFINE   ps_arg3          LIKE zaa_file.zaa10     
DEFINE   ps_arg4          LIKE zaa_file.zaa04     
DEFINE   ps_arg5          LIKE zaa_file.zaa17
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW q_zaa2 WITH FORM "qry/42f/q_zaa2" ATTRIBUTE(STYLE="create_qry") 
 
 
   CALL cl_ui_locale("q_zaa2")
   LET ms_arg1 = ps_arg1
   LET ms_arg2 = ps_arg2
   LET ms_arg3 = ps_arg3
   LET ms_arg4 = ps_arg4
   LET ms_arg5 = ps_arg5
 
   CALL zaa_qry_sel()
 
   CLOSE WINDOW q_zaa2 
 
   RETURN ms_ret1,ms_ret2,ms_ret3,ms_ret4 #複選資料只能回傳一個欄位的組合字串.
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION zaa_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,   #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,   #是否重新CONSTRUCT.預設為TRUE. 
            li_continue      LIKE type_file.num5    #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10,
            li_end_index     LIKE type_file.num10
   DEFINE   li_curr_page     LIKE type_file.num5
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 #每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         LET ms_cons_where = '1=1'
     
         CALL zaa_qry_prep_result_set() 
         # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
         IF (mi_page_count >= ma_qry.getLength()) THEN
            LET ls_hide_act = "prevpage,nextpage"
         END IF
     
            IF (ls_hide_act IS NULL) THEN
               LET ls_hide_act = "reconstruct"
            ELSE
               LET ls_hide_act = "prevpage,nextpage,reconstruct"
            END IF 
     
         LET li_start_index = 1
     
         LET li_reconstruct = FALSE
      END IF
     
      LET li_end_index = li_start_index + mi_page_count - 1
     
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF
     
      CALL zaa_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
     
      # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
         CALL zaa_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
 
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION zaa_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql        STRING
   DEFINE   li_i          LIKE type_file.num10
   DEFINE   lr_qry        RECORD
                            zaa04  LIKE zaa_file.zaa04,
                            zaa17  LIKE zaa_file.zaa17,
                            zaa11  LIKE zaa_file.zaa11,
                            gae04  LIKE gae_file.gae04
                          END RECORD
   DEFINE l_gae02         LIKE gae_file.gae02
   DEFINE l_zaa07_ze03    LIKE ze_file.ze03
   DEFINE l_zaa18_ze03    LIKE ze_file.ze03
 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_zaa2', 'zaa_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT UNIQUE zaa04,zaa17,zaa11,''",
               "  FROM zaa_file ",
               " WHERE ",ms_cons_where ," AND zaa01='",ms_arg1 CLIPPED,"' ",
               "   AND zaa03 = '", ms_arg2 CLIPPED, "'",
               "   AND zaa10 = '", ms_arg3 CLIPPED, "'",
               "   AND ((zaa04 = 'default' AND zaa17 = 'default') ",
               "    OR zaa04= '",ms_arg4 CLIPPED,"'",
               "    OR zaa17= '",ms_arg5 CLIPPED,"') ",
               " ORDER BY zaa04,zaa17,zaa11 "
 
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   SELECT ze03 INTO l_zaa07_ze03
     FROM ze_file WHERE ze01 = 'lib-362' AND ze02 = ms_arg2
   SELECT ze03 INTO l_zaa18_ze03
     FROM ze_file WHERE ze01 = 'lib-363' AND ze02 = ms_arg2
  
   FOREACH lcurs_qry INTO lr_qry.*,l_gae02
       
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-2 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
      LET lr_qry.gae04 = l_zaa07_ze03
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
 
      LET lr_qry.gae04 = l_zaa18_ze03
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION zaa_qry_set_display_data(pi_start_index, pi_end_index)
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
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: LIKE type_file.num5   是否繼續
#               : LIKE type_file.num5   是否重新查詢
#               : LIKE type_file.num10    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION zaa_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_zaa.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         CALL zaa_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
            LET ms_ret1 = ""
            LET ms_ret2 = ""
            LET ms_ret3 = ""
            LET ms_ret4 = ""
         LET li_continue = FALSE
     
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--
   
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: LIKE type_file.num5   是否繼續
#               : LIKE type_file.num5   是否重新查詢
#               : LIKE type_file.num10    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION zaa_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_zaa.*
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
         CALL zaa_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
            LET ms_ret1 = ""
            LET ms_ret2 = ""
            LET ms_ret3 = ""
            LET ms_ret4 = ""
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--
   
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_sel_index   LIKE type_file.num10   所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION zaa_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10 
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
      LET ms_ret1 = ma_qry[pi_sel_index].zaa04 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].zaa17 CLIPPED
      LET ms_ret3 = ma_qry[pi_sel_index].zaa11 CLIPPED
      LET ms_ret4 = ma_qry[pi_sel_index].gae04 CLIPPED
END FUNCTION
