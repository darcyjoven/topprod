# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Program name  : q_sgm4.4gl
# Program ver.  : 7.0
# Description   : 作業序類資料查詢
# Date & Author : 2012/12/18 By pauline 
# Memo          : 
# Modify.........: No.FUN-C30163 12/12/18 By pauline aqct511查詢增加顯示待驗量
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#查詢資料的暫存器.
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  
         sgm012       LIKE sgm_file.sgm012,
         sgm014       LIKE sgm_file.sgm014,
         sgm03        LIKE sgm_file.sgm03,
         sgm03_par    LIKE sgm_file.sgm03_par, 
         qcm22        LIKE qcm_file.qcm22    
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,   
         sgm012       LIKE sgm_file.sgm012,
         sgm014       LIKE sgm_file.sgm014,
         sgm03        LIKE sgm_file.sgm03,
         sgm03_par    LIKE sgm_file.sgm03_par,
         qcm22        LIKE qcm_file.qcm22  
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	
DEFINE   ms_default1      STRING
DEFINE   ms_default2      STRING     
DEFINE   ms_default3      STRING     
DEFINE   ms_ret2          STRING ,   #回傳欄位的變數
         ms_ret3          STRING,    #回傳欄位的變數
         ms_key1          LIKE sgm_file.sgm01
DEFINE   ms_chooseret     LIKE type_file.chr1     #回傳值選擇  
DEFINE   g_qcm01          LIKE qcm_file.qcm01     
DEFINE   g_qcm00          LIKE qcm_file.qcm00      
DEFINE   g_show_qcm22     LIKE type_file.chr1     #是否顯示送驗量

#FUN-C30163 add START
#多增加傳入參數:p_show_qty  :是否顯示送驗量
#               p_qcm00     :資料來源
#               p_qcm01     :PQC單號
#FUN-C30163 add END

FUNCTION q_sgm4(pi_multi_sel,pi_need_cons,p_key1,ps_default1,ps_default2,ps_chooseret,p_show_qcm22,p_qcm00,p_qcm01)   
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    LIKE sgm_file.sgm04, #預設回傳值(在取消時會回傳此類預設值).
            ps_default2    LIKE sgm_file.sgm04, #預設回傳值(在取消時會回傳此類預設值).  
            p_key1         LIKE sgm_file.sgm01,
            p_key2         LIKE sgm_file.sgm04 
   DEFINE   ps_chooseret   LIKE type_file.chr1   
   DEFINE   p_qcm01        LIKE qcm_file.qcm01    
   DEFINE   p_qcm00        LIKE qcm_file.qcm00    
   DEFINE   p_show_qcm22   LIKE type_file.chr1      #是否顯示送驗量

   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
   LET ms_key1     = p_key1
   LET ms_chooseret= ps_chooseret            
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_sgm4" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_sgm4")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons

   LET g_qcm00 = p_qcm00
   LET g_qcm01 = p_qcm01
   LET g_show_qcm22 = p_show_qcm22
   IF cl_null(g_qcm01) THEN LET g_qcm01 = ' ' END IF
   IF cl_null(g_show_qcm22) THEN
      LET g_show_qcm22 = 'N' 
   END IF
   IF g_show_qcm22 = 'Y' THEN
      CALL cl_set_comp_visible("qcm22",TRUE) 
   ELSE
      CALL cl_set_comp_visible("qcm22",FALSE) 
   END IF
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("sgm04", "red")
   END IF
 
   CALL sgm4_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret2 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret2,ms_ret3 #回傳值(也許有多個).
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION sgm4_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	
            li_continue      LIKE type_file.num5      #是否繼續.	
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
         LET ms_cons_where = "1=1"
     
         IF (mi_need_cons) THEN
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL sgm4_qry_prep_result_set() 
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
     
      CALL sgm4_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL sgm4_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL sgm4_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
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
FUNCTION sgm4_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
         check        LIKE type_file.chr1,   
         sgm012       LIKE sgm_file.sgm012,
         sgm014       LIKE sgm_file.sgm014,
         sgm03        LIKE sgm_file.sgm03,
         sgm03_par    LIKE sgm_file.sgm03_par,
         qcm22        LIKE qcm_file.qcm22  
   END RECORD
   DEFINE   l_sgm01   LIKE sgm_file.sgm01
 
 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_sgm4', 'sgm_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT  'N',sgm012,sgm014,sgm03,sgm03_par,'',sgm01 ",  
                "  FROM sgm_file",
                " WHERE  sgm01 = '",ms_key1,"' ",
                "   AND ",ms_cons_where CLIPPED
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY sgm03"
 
   IF (NOT mi_multi_sel ) THEN						
        CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql						
   END IF						
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*,l_sgm01
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      IF g_show_qcm22 = 'Y' THEN
         CALL sgm_get_qcm22(lr_qry.sgm03,lr_qry.sgm012,l_sgm01,g_qcm00) RETURNING lr_qry.qcm22   #串到q_sgm.4gl內 
         IF cl_null(lr_qry.qcm22) OR lr_qry.qcm22 = 0 THEN
            CONTINUE FOREACH 
         END IF
      END IF
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION sgm4_qry_set_display_data(pi_start_index, pi_end_index)
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
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION sgm4_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  	
            li_reconstruct   LIKE type_file.num5  	
   DEFINE   li_i             LIKE type_file.num5        
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_sgm.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) 
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_sgm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL sgm4_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_sgm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL sgm4_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL sgm4_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN    
            CALL GET_FLDBUF(s_sgm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL sgm4_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL sgm4_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                       
            LET ms_ret2 = NULL      
            LET ms_ret3 = NULL
         END IF                     
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret2 = ms_default1
            LET ms_ret3 = ms_default2
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
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION sgm4_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION sgm4_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  	
            li_reconstruct   LIKE type_file.num5  	
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_sgm.*
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
         CALL sgm4_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret2 = ms_default1
            LET ms_ret3 = ms_default2
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
   
      ON ACTION qry_string
         CALL cl_qry_string("detail")
 
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
FUNCTION sgm4_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION sgm4_qry_accept(pi_sel_index)
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
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
                  CALL lsb_multi_sel.append(ma_qry[li_i].sgm012 CLIPPED)
                  CALL lsb_multi_sel.append(ma_qry[li_i].sgm03 CLIPPED)        
            ELSE
                  CALL lsb_multi_sel.append("|" || ma_qry[li_i].sgm012 CLIPPED)   
                  CALL lsb_multi_sel.append("|" || ma_qry[li_i].sgm03 CLIPPED) 
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret2 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret2 = ma_qry[pi_sel_index].sgm012 CLIPPED
      LET ms_ret3 = ma_qry[pi_sel_index].sgm03 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION


#FUN-C30163 

