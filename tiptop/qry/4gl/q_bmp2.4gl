# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name  : q_bmp2.4gl
# Program ver.  : 7.0
# Description   : 料件編號資料查詢 (ima_file+bmq_file)
# Date & Author : No.TQC-C50030 2011/05/09 by lixh1

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	
         ima01    LIKE ima_file.ima01,
         ima02    LIKE ima_file.ima02,
         ima05    LIKE ima_file.ima05,
         ima06    LIKE ima_file.ima06,
         ima08    LIKE ima_file.ima08         

END RECORD

DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	
         ima01    LIKE ima_file.ima01,
         ima02    LIKE ima_file.ima02,
         ima05    LIKE ima_file.ima05,
         ima06    LIKE ima_file.ima06,
         ima08    LIKE ima_file.ima08  
END RECORD

DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	
DEFINE   ms_default1      STRING     
DEFINE   ms_default2      STRING
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_ret2          STRING     #回傳欄位的變數

DEFINE   l_chr            LIKE type_file.chr1 

FUNCTION q_bmp2(pi_multi_sel,pi_need_cons,ps_default1,ps_default2)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	
            pi_need_cons   LIKE type_file.num5,  	
            ps_default1    STRING,  #預設回傳值(在取消時會回傳此類預設值).
            ps_default2    STRING,  #預設回傳值(在取消時會回傳此類預設值).
            ps_default3    STRING,  #預設回傳值(在取消時會回傳此類預設值). 
            ps_default4    STRING   #預設回傳值(在取消時會回傳此類預設值).
   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_bmp2" ATTRIBUTE(STYLE="create_qry") 
 
   CALL cl_ui_locale("q_bmp2")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   #不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF

   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("ima01", "red")
   END IF   

   CALL bmp2_qry_sel()
 
   CLOSE WINDOW w_qry
   IF (mi_multi_sel) THEN
      RETURN ms_ret1         #複選資料只能回傳一個欄位的組合字串.   
   ELSE
      RETURN ms_ret1         #回傳值(也許有多個).
   END IF
   
END FUNCTION

##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2011/03/28 by lixh1
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################

FUNCTION bmp2_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	
            li_continue      LIKE type_file.num5      #是否繼續.	
   DEFINE   li_start_index   LIKE type_file.num10, 	
            li_end_index     LIKE type_file.num10 	
   DEFINE   li_curr_page     LIKE type_file.num5  	
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100    #每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE
   LET l_chr = 'N' 

   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         LET ms_cons_where = "1=1"
         
         IF (li_continue) AND (li_reconstruct) AND (l_chr = 'Y') THEN 
            CALL bmp2_construct()   
         END IF  
         CALL bmp2_qry_prep_result_set() 
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
      IF (li_end_index < = mi_page_count) THEN
         LET ls_hide_act = "prevpage"
      END IF  
     
      CALL bmp2_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
         LET ls_hide_act = "nextpage"
      END IF

      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL bmp2_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL bmp2_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

FUNCTION bmp2_construct()
  CLEAR FORM
  CALL ma_qry_tmp.clear()
  CONSTRUCT ms_cons_where ON ima01,ima02,ima05,ima06,ima08 
       FROM s_ima[1].ima01,s_ima[1].ima02,s_ima[1].ima05,s_ima[1].ima06,s_ima[1].ima08
       
     ON ACTION about         
        CALL cl_about()        
     
     ON ACTION help          
        CALL cl_show_help()  
     
     ON ACTION controlg      
        CALL cl_cmdask()      
     
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT 
  END CONSTRUCT
END FUNCTION 

##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2011/03/28 by lixh1
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION bmp2_qry_prep_result_set()
   DEFINE   l_filter_cond_ima STRING 
   DEFINE   l_filter_cond_bmq STRING  
   DEFINE   ms_cons_where_bmq STRING 
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	
   DEFINE   l_ecm54  LIKE ecm_file.ecm54
   DEFINE   lr_qry   RECORD
            CHECK    LIKE type_file.chr1,  	
            ima01    LIKE ima_file.ima01,
            ima02    LIKE ima_file.ima02,
            ima05    LIKE ima_file.ima05,
            ima06    LIKE ima_file.ima06,
            ima08    LIKE ima_file.ima08
   END RECORD
   
   LET ms_cons_where_bmq = cl_replace_str(ms_cons_where,'ima','bmq')
   
   LET l_filter_cond_ima = cl_get_extra_cond_for_qry('q_ima01', 'ima_file')
   LET l_filter_cond_bmq = cl_get_extra_cond_for_qry('q_ima01', 'bmq_file')
   
   IF NOT cl_null(l_filter_cond_ima) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond_ima
   END IF
   IF NOT cl_null(l_filter_cond_bmq) THEN
      LET ms_cons_where_bmq = ms_cons_where_bmq,l_filter_cond_bmq
   END IF 
   IF cl_null(ms_cons_where_bmq) THEN
      LET ms_cons_where_bmq = "1 =1"
   END IF
   LET ls_sql = "SELECT 'N',ima01,ima02,ima05,ima06,ima08 FROM ima_file",
                " WHERE imaacti = 'Y' ",
                "   AND ",ms_cons_where CLIPPED,
                " UNION ",
                "SELECT 'N',bmq01,bmq02,bmq05,bmq06,bmq08 FROM bmq_file",
                " WHERE bmqacti = 'Y' ",
                "   AND ",ms_cons_where_bmq CLIPPED
                 
   LET ls_sql=ls_sql CLIPPED," ORDER BY ima01"
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   IF (NOT mi_multi_sel ) THEN
      CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql
   END IF

   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*    
     #判斷是否已達選取上限  
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
# Date & Author : 2011/03/28 by lixh1
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION bmp2_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2011/03/28 by lixh1
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION bmp2_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_continue      LIKE type_file.num5, 
            li_reconstruct   LIKE type_file.num5 
   DEFINE   li_i             LIKE type_file.num5
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ima.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)

      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF

      ON ACTION prevpage
         CALL GET_FLDBUF(s_ecm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL bmp2_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE     
         EXIT INPUT

      ON ACTION nextpage
         CALL GET_FLDBUF(s_qcs.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL bmp2_qry_reset_multi_sel(pi_start_index, pi_end_index)
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         LET li_continue = TRUE
         EXIT INPUT

      ON ACTION refresh
         CALL bmp2_qry_refresh()
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT INPUT

      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         LET l_chr = 'Y'          
         EXIT INPUT

      ON ACTION accept
         IF ARR_CURR()>0 THEN        
            CALL GET_FLDBUF(s_ecm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL bmp2_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL bmp2_qry_accept(pi_start_index+ARR_CURR()-1)
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

      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')

 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
 
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
# Date & Author : 2011/03/28 by lixh1
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION bmp2_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2011/03/28 by lixh1
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION bmp2_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5 
 
   DISPLAY ARRAY ma_qry_tmp TO s_ima.*
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
         LET l_chr = 'Y' 
         EXIT DISPLAY

      ON ACTION accept
         CALL bmp2_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
         END IF
         LET li_continue = FALSE
         EXIT DISPLAY

      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')

 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   

      ON ACTION qry_string
         CALL cl_qry_string("detail")

   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index

END FUNCTION

##################################################
# Description   : 重設查詢資料.
# Date & Author : 2011/03/28 by lixh1
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION bmp2_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2011/01/28 by lixh1
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION bmp2_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].ima01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].ima01 CLIPPED)
            END IF
         END IF    
      END FOR
      #複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].ima01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].ima02 CLIPPED
   END IF
END FUNCTION
#TQC-C50030
