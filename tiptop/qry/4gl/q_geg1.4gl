# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name  : q_geg1.4gl
# Program ver.  : 7.0
# Description   : 常用摘要查詢
# Date & Author : 2012/10/09 by zhangwei    #No.FUN-CA0082

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD   #No.FUN-CA0082
         check    LIKE type_file.chr1,
         geg03    LIKE geg_file.geg03,
         geg04    LIKE geg_file.geg04,
         gei01    LIKE gei_file.gei01,
         gei02    LIKE gei_file.gei02,
         geh01    LIKE geh_file.geh01,
         geh02    LIKE geh_file.geh02
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         geg03    LIKE geg_file.geg03,
         geg04    LIKE geg_file.geg04,
         gei01    LIKE gei_file.gei01,
         gei02    LIKE gei_file.gei02,
         geh01    LIKE geh_file.geh01,
         geh02    LIKE geh_file.geh02
END RECORD

DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_default1      LIKE geg_file.geg04
DEFINE   ms_ret1          LIKE geg_file.geg04
DEFINE   ms_ret2          LIKE geg_file.geg04
DEFINE   w                ui.Window
DEFINE   n                om.DomNode


FUNCTION q_geg1(pi_multi_sel,pi_need_cons,ps_default1)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_default1    LIKE geg_file.geg04


   LET ms_default1 = ps_default1

   WHENEVER ERROR CALL cl_err_msg_log

   OPEN WINDOW w_qry WITH FORM "qry/42f/q_geg1" ATTRIBUTE(STYLE="create_qry")

   CALL cl_ui_locale("q_geg1")

   LET ms_ret1 = ""
   LET mi_multi_sel = FALSE
   LET mi_need_cons = pi_need_cons

   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF

   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("geg04", "red")
   END IF

   CALL geg1_qry_sel()

   CLOSE WINDOW w_qry

   IF (mi_multi_sel) THEN
      RETURN ms_ret1,''
   ELSE
      RETURN ms_ret1,ms_ret2
   END IF
END FUNCTION

##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2012/10/09 by zhangwei
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION geg1_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE.
            li_continue      LIKE type_file.num5      #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10,
            li_end_index     LIKE type_file.num10
   DEFINE   li_curr_page     LIKE type_file.num5
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03

   LET mi_page_count = 100
   LET li_reconstruct = TRUE

   WHILE TRUE
      CLEAR FORM

      LET INT_FLAG = FALSE
      LET ls_hide_act = ""

      IF (li_reconstruct) THEN
         MESSAGE ""

         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON geg03,geg04,gei01,gei02,geh01,geh02
                                  FROM s_geg1[1].geg03,s_geg1[1].geg04,
                                       s_geg1[1].gei01,s_geg1[1].gei02,
                                       s_geg1[1].geh01,s_geg1[1].geh02

               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT

            END CONSTRUCT

            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF

         CALL geg1_qry_prep_result_set()
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
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

      CALL geg1_qry_set_display_data(li_start_index, li_end_index)

      LET li_curr_page = li_end_index / mi_page_count

      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF

      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang

      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page

      IF (mi_multi_sel) THEN
         CALL geg1_qry_input_array(ls_hide_act, li_start_index, li_end_index)
            RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL geg1_qry_display_array(ls_hide_act, li_start_index, li_end_index)
            RETURNING li_continue,li_reconstruct,li_start_index
      END IF

      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2012/10/09 by zhangwei
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION geg1_qry_prep_result_set()
   DEFINE l_filter_cond STRING
   DEFINE ls_sql   STRING
   DEFINE li_i     LIKE type_file.num10
   DEFINE lr_qry   RECORD
          check    LIKE type_file.chr1,
          geg03    LIKE geg_file.geg03,
          geg04    LIKE geg_file.geg04,
          gei01    LIKE gei_file.gei01,
          gei02    LIKE gei_file.gei02,
          geh01    LIKE geh_file.geh01,
          geh02    LIKE geh_file.geh02
   END RECORD

   LET l_filter_cond = cl_get_extra_cond_for_qry('q_geg1', 'geg_file')
   IF cl_null(ms_cons_where) THEN LET ms_cons_where = " 1=1" END IF
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF

   LET ls_sql = "SELECT 'N',geg03,geg04,gei01,gei02,geh01,geh02",
                " FROM geh_file,gei_file left join geg_file ON gei_file.gei01 = geg_file.geg01",
                " WHERE ",ms_cons_where,
                "   AND gei03 = geh01",
                "   AND geh04 = '4'",
                " ORDER BY geh01"

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
# Date & Author : 2012/10/09 by zhangwei
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION geg1_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2012/10/09 by zhangwei
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return     	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION geg1_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5

   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_geg1.*
      ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         IF ARR_CURR()>0 THEN
            CALL GET_FLDBUF(s_geg1.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL geg1_qry_reset_multi_sel(pi_start_index, pi_end_index)

            LET pi_start_index = pi_start_index - mi_page_count

            IF ((pi_start_index - mi_page_count) >= 1) THEN
               LET pi_start_index = pi_start_index - mi_page_count
            END IF
         ELSE
            LET ms_ret1 = NULL
         END IF
         LET li_continue = FALSE

         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_geg1.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL geg1_qry_reset_multi_sel(pi_start_index, pi_end_index)

         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF

         LET li_continue = TRUE

         EXIT INPUT
      ON ACTION refresh
         CALL geg1_qry_refresh()

         LET pi_start_index = 1
         LET li_continue = TRUE

         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE

         EXIT INPUT
      ON ACTION accept
         LET li_continue = FALSE

         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF

         LET li_continue = FALSE

         EXIT INPUT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION exporttoexcel
         LET w = ui.Window.getCurrent()
         LET n = w.getNode()
         CALL cl_export_to_excel(n,base.TypeInfo.create(ma_qry),'','')

      ON ACTION qry_string
         CALL cl_qry_string("detail")

      ON ACTION selectall
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "Y"
         END FOR

      ON ACTION select_none
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "N"
         END FOR

   END INPUT

   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : 2012/10/09 by zhangwei
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return    	: void
# Memo        	:
# Modify   	    :
##################################################
FUNCTION geg1_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_i             LIKE type_file.num10,
            li_j             LIKE type_file.num10

   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION

##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2012/10/09 by zhangwei
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	    : SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION geg1_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5


   DISPLAY ARRAY ma_qry_tmp TO s_geg1.*
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
         LET pi_start_index = 1
         LET li_continue = TRUE

         EXIT DISPLAY
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE

         EXIT DISPLAY
      ON ACTION accept
         IF cl_null(ms_ret1) THEN
            CALL geg1_qry_accept(pi_start_index+ARR_CURR()-1)
         END IF
         LET li_continue = FALSE

         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF

         LET ms_ret1 = ""
         LET li_continue = FALSE

         EXIT DISPLAY
      ON ACTION select
         CALL geg1_qry_accept(pi_start_index+ARR_CURR()-1)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION exporttoexcel
         LET w = ui.Window.getCurrent()
         LET n = w.getNode()
         CALL cl_export_to_excel(n,base.TypeInfo.create(ma_qry),'','')

      ON ACTION qry_string
         CALL cl_qry_string("detail")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

##################################################
# Description   : 重設查詢資料.
# Date & Author : 2012/10/09 by zhangwei
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION geg1_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10


   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION

##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2012/10/09 by zhangwei
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION geg1_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10

   IF pi_sel_index = 0 THEN
      RETURN
   END IF

   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()

      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].geg03 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].geg03 CLIPPED)
            END IF
         END IF
      END FOR
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      IF (ms_ret1 IS NULL) THEN
         LET ms_ret1 = ma_qry[pi_sel_index].gei01 CLIPPED
         LET ms_ret2 = ma_qry[pi_sel_index].geg03 CLIPPED
      ELSE
         LET ms_ret1 = ms_ret1 CLIPPED,ma_qry[pi_sel_index].gei01 CLIPPED
         LET ms_ret2 = ms_ret1 CLIPPED,ma_qry[pi_sel_index].geg03 CLIPPED
      END IF

      DISPLAY ms_ret1 TO FORMONLY.b
   END IF
END FUNCTION
