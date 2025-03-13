# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name  : q_m_rvu.4gl
# Description   : 成本分攤目的應付帳款查詢
# Date & Author  : FUN-C90126   2012/10/16 By xuxz

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         arvu00        LIKE rvu_file.rvu00,
         rvu01        LIKE rvu_file.rvu01,
         rvv02        LIKE rvv_file.rvv02,
         rvu03        LIKE rvu_file.rvu03,
         rvu04        LIKE rvu_file.rvu04,
         rvu05        LIKE rvu_file.rvu05,
         rvu06        LIKE rvu_file.rvu06,
         gem02        LIKE gem_file.gem02,
         rvu07        LIKE rvu_file.rvu07,
         gen02        LIKE gen_file.gen02,
         rvu08        LIKE rvu_file.rvu08
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         rvu00        LIKE rvu_file.rvu00,
         rvu01        LIKE rvu_file.rvu01,
         rvv02        LIKE rvv_file.rvv02,
         rvu03        LIKE rvu_file.rvu03,
         rvu04        LIKE rvu_file.rvu04,
         rvu05        LIKE rvu_file.rvu05,
         rvu06        LIKE rvu_file.rvu06,
         gem02        LIKE gem_file.gem02,
         rvu07        LIKE rvu_file.rvu07,
         gen02        LIKE gen_file.gen02,
         rvu08        LIKE rvu_file.rvu08
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5   #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5   #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_ret1          STRING     
DEFINE   ms_ret2          STRING     
DEFINE   p_aqa01          LIKE aqa_file.aqa01            

FUNCTION q_m_rvu(pi_multi_sel,pi_need_cons,l_aqa01)       
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            l_aqa01        LIKE aqa_file.aqa01          

   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_m_rvu" ATTRIBUTE(STYLE="create_qry")  
 
   CALL cl_ui_locale("q_m_rvu")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   LET p_aqa01 = l_aqa01               
   LET ms_ret1 = ''
   LET ms_ret2 = ''

   #不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   #在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("rvu01", "red")
   END IF
 
   CALL rvu1_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1,'' 
   ELSE
      RETURN ms_ret1,ms_ret2 
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvu1_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,   #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,   #是否重新CONSTRUCT.預設為TRUE.
            li_continue      LIKE type_file.num5    #是否繼續.
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
            CONSTRUCT ms_cons_where ON rvu00,rvu01,rvv02,rvu3,rvu04,rvu05,rvu06,rvu07,rvu08
                                  FROM s_rvu[1].rvu00,s_rvu[1].rvu01,s_rvu[1].rvv02,
                                       s_rvu[1].rvu03,s_rvu[1].rvu04,s_rvu[1].rvu05,
                                       s_rvu[1].rvu06,s_rvu[1].rvu07,s_rvu[1].rvu08
                                       
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
 
         CALL rvu1_qry_prep_result_set()
         #如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         #如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
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
 
      CALL rvu1_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL rvu1_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL rvu1_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION rvu1_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,
            rvu00        LIKE rvu_file.rvu00,
            rvu01        LIKE rvu_file.rvu01,
            rvv02        LIKE rvv_file.rvv02,
            rvu03        LIKE rvu_file.rvu03,
            rvu04        LIKE rvu_file.rvu04,
            rvu05        LIKE rvu_file.rvu05,
            rvu06        LIKE rvu_file.rvu06,
            gem02        LIKE gem_file.gem02,
            rvu07        LIKE rvu_file.rvu07,
            gen02        LIKE gen_file.gen02,
            rvu08        LIKE rvu_file.rvu08
   END RECORD
   DEFINE   lr_arr   RECORD
            check    LIKE type_file.chr1,
            rvu00        LIKE rvu_file.rvu00,
            rvu01        LIKE rvu_file.rvu01,
            rvv02        LIKE rvv_file.rvv02,
            rvu03        LIKE rvu_file.rvu03,
            rvu04        LIKE rvu_file.rvu04,
            rvu05        LIKE rvu_file.rvu05,
            rvu06        LIKE rvu_file.rvu06,
            gem02        LIKE gem_file.gem02,
            rvu07        LIKE rvu_file.rvu07,
            gen02        LIKE gen_file.gen02,
            rvu08        LIKE rvu_file.rvu08
   END RECORD
   DEFINE l_date  LIKE type_file.dat 
   DEFINE l_cnt   LIKE type_file.num5     

   LET ls_sql = "SELECT 'N',rvu00,rvu01,rvv02,rvu03,rvu04,rvu05,rvu06,gem02,",
                "       rvu07,gen02,rvu08 ",
                "  FROM rvu_file,rvv_file,gen_file,gem_file",
            #   "   FROM ",cl_get_target_table(g_plant_new,'rvu_file'),",",
            #                 cl_get_target_table(g_plant_new,'rvv_file'),",",
            #                 cl_get_target_table(g_plant_new,'gen_file'),",",
            #                 cl_get_target_table(g_plant_new,'gem_file'), 
                " WHERE ",ms_cons_where CLIPPED,
                "   AND rvu06=gem01 AND rvu07=gen01 ",
                "   AND rvu01=rvv01 ",
                " ORDER BY rvu00,rvu01,rvu02 "
                 
   CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql  
   CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql 
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_arr.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
      
      SELECT COUNT (*) INTO l_cnt FROM aqa_file ,aqc_file
       WHERE aqa01=aqc01
         AND aqa01 = p_aqa01 
         AND aqc02=lr_arr.rvu01
         AND aqc03=lr_arr.rvv02
         AND aqaconf <> 'X'
      IF l_cnt>0 THEN
         CONTINUE FOREACH
      END IF

      LET lr_qry.rvu00 = lr_arr.rvu00
      LET lr_qry.rvu01 = lr_arr.rvu01
      LET lr_qry.rvv02 = lr_arr.rvv02
      LET lr_qry.rvu03 = lr_arr.rvu03
      LET lr_qry.rvu04 = lr_arr.rvu04
      LET lr_qry.rvu05 = lr_arr.rvu05
      LET lr_qry.rvu06 = lr_arr.rvu06
      LET lr_qry.gem02 = lr_arr.gem02
      LET lr_qry.rvu07 = lr_arr.rvu07
      LET lr_qry.gen02 = lr_arr.gen02
      LET lr_qry.rvu08 = lr_arr.rvu08
      
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION rvu1_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: LIKE type_file.num5   是否繼續
#               : LIKE type_file.num5   是否重新查詢
#               : LIKE type_file.num10    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvu1_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_rvu.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_rvu.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_rvu.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL rvu1_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_rvu.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL rvu1_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         CALL rvu1_qry_refresh()
 
         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        
            CALL GET_FLDBUF(s_rvu.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL rvu1_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL rvu1_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        
            LET ms_ret1 = NULL      
         END IF                      
         LET li_continue = FALSE
 
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
         END IF
 
         LET li_continue = FALSE
 
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
   

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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvu1_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: LIKE type_file.num5   是否繼續
#               : LIKE type_file.num5   是否重新查詢
#               : LIKE type_file.num10    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvu1_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_rvu.*
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
         CALL rvu1_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
         END IF
 
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
   
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION rvu1_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_sel_index   LIKE type_file.num10   所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvu1_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10
 
 
   #GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].rvu01 CLIPPED || "," || ma_qry[li_i].rvv02 CLIPPED)#FUN-C90126 add || "'" ||rvu02 
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].rvu01 CLIPPED || "," || ma_qry[li_i].rvv02 CLIPPED)#FUN-C90126 add || "'" ||rvu02 
            END IF
         END IF
      END FOR
      #複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].rvu01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].rvv02 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
#FUN-C90126
