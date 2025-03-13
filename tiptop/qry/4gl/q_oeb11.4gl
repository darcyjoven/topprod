# Prog. Version..: '5.30.06-13.03.12(00004)'     #

# Program name...: q_oeb11.4gl
# Descriptions...: 訂單資料查詢
# Date & Author..: #No.FUN-870033 2008/07/08 by xiaofeizhu  
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定 
# Modify.........: No.FUN-9B0156 09/11/30 By alex 調整ATTRIBUTES
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:TQC-B50118 11/05/20 By lixia 全選和全部選重複
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  
         oeb03    LIKE oeb_file.oeb03,
         oeb04    LIKE oeb_file.oeb04,
         oeb12    LIKE oeb_file.oeb12,  
         oeb28    LIKE oeb_file.oeb28
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	
         oeb03        LIKE oeb_file.oeb03,
         oeb04        LIKE oeb_file.oeb04,
         oeb12        LIKE oeb_file.oeb12,   
         oeb28        LIKE oeb_file.oeb28
END RECORD
DEFINE   ms_cus       LIKE oea_file.oea01
 
DEFINE   mr_oeb       RECORD LIKE oeb_file.*
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	
DEFINE   ms_cons_where    STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.	
DEFINE   li_i             LIKE type_file.num10
DEFINE   ms_ret1          STRING
 
FUNCTION q_oeb11(pi_multi_sel,pi_need_cons,ps_cus)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  
            pi_need_cons   LIKE type_file.num5,  	
            ps_default1    STRING  , 
            ps_cus         LIKE oea_file.oea01
 
 
   WHENEVER ERROR CONTINUE
 
   LET ms_cus    = ps_cus   
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_oeb11" ATTRIBUTE(STYLE="create_qry") 
 
   CALL cl_ui_locale("q_oeb11")
 
   LET mi_multi_sel = TRUE
   LET mi_need_cons = pi_need_cons
 
   CALL oeb11_qry_sel()
 
   CLOSE WINDOW w_qry
   IF (mi_multi_sel) THEN                                                                                                           
      RETURN ms_ret1 #復選資料只能回傳一個欄位的組合字串.                                                                           
   ELSE                                                                                                                             
      RETURN ms_ret1 #回傳值(也許有多個).                                                                                           
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2008/07/08 by xiaofeizhu
# Parameter   	: none
# Return   	    : void
# Memo        	:
# Modify      	:
##################################################
FUNCTION oeb11_qry_sel()
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
            CONSTRUCT BY NAME ms_cons_where ON oeb03
  
            ON ACTION controlg      
               CALL cl_cmdask()     
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION about         
               CALL cl_about()      
 
            ON ACTION help          
               CALL cl_show_help()  
 
            END CONSTRUCT
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL oeb11_qry_prep_result_set() 
 
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
     
      CALL oeb11_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL oeb11_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL oeb11_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2008/07/08 by xiaofeizhu
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION oeb11_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   	
            oeb03      LIKE oeb_file.oeb03,
            oeb04      LIKE oeb_file.oeb04,
            oeb12      LIKE oeb_file.oeb12,  
            oeb28      LIKE oeb_file.oeb28
   END RECORD
 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_oeb11', 'oeb_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',oeb03,oeb04,oeb12,oeb28",   
                " FROM oeb_file",
                " WHERE ",ms_cons_where CLIPPED,
            		"   AND oeb01 = '",ms_cus CLIPPED,"'"
 
#FUN-990069---begin 
   IF (NOT mi_multi_sel ) THEN
      CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql
   END IF     
#FUN-990069---end  
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
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
# Date & Author : 2008/07/08 by xiaofeizhu
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION oeb11_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_i             LIKE type_file.num10, 	
            li_j             LIKE type_file.num10 	
 
   FOR li_i = ma_qry_tmp.getLength() TO 1 STEP -1
      CALL ma_qry_tmp.deleteElement(li_i)
   END FOR
 
   CALL ma_qry_tmp.clear()
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
##################################################
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2008/07/08 by xiaofeizhu
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return      	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	    :
##################################################
FUNCTION oeb11_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  
            li_reconstruct   LIKE type_file.num5  	
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082 
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oeb.* 
      ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE,UNBUFFERED)
 
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_oeb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oeb11_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_oeb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oeb11_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL oeb11_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_oeb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL oeb11_qry_reset_multi_sel(pi_start_index, pi_end_index)
#           IF cl_sure(0,0) THEN
               CALL oeb11_qry_accept(pi_start_index+ARR_CURR()-1)
#           ELSE
#              CLOSE WINDOW q_oeb_w
#           END IF
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 
         LET li_continue = FALSE
     
         EXIT INPUT
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
#     ON ACTION qry_string
#        CALL cl_qry_string("detail")
 
  
      ON ACTION controlg      
         CALL cl_cmdask()     
 
#TQC-B50118--mark--str--     
#      ON ACTION select_all
#         FOR li_i = 1 TO ma_qry_tmp.getLength()
#            LET ma_qry_tmp[li_i].check = "Y"
#         END FOR
#                                                                                                                                    
#      ON ACTION cancel_all
#         FOR li_i = 1 TO ma_qry_tmp.getLength()
#            LET ma_qry_tmp[li_i].check = "N"
#         END FOR
#TQC-B50118--mark--end--
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ### FUN-880082 START ###
      ON ACTION selectall
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "Y"
         END FOR
 
      ON ACTION select_none
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "N"
         END FOR
      ### FUN-880082 END ###
         
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : 2008/07/08 by xiaofeizhu
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return      	: void
# Memo        	:
# Modify   	    :
##################################################
FUNCTION oeb11_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2008/07/08 by xiaofeizhu
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return   	    : SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	    :
##################################################
FUNCTION oeb11_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  	
            li_reconstruct   LIKE type_file.num5  	
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_oeb.*
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
         CALL oeb11_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON ACTION qry_string
         CALL cl_qry_string("detail")
  
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
   END DISPLAY
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2008/07/08 by xiaofeizhu
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION oeb11_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2008/07/08 by xiaofeizhu
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	
# Return   	    : void
# Memo        	:
# Modify   	    :
##################################################
FUNCTION oeb11_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	
   DEFINE   l_oma930        LIKE oma_file.oma930 
 
 
#  MESSAGE 'WORKING....' ATTRIBUTES(YELLOW)    #FUN-9B0156
   LET g_success='Y'
   BEGIN WORK
      
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].oeb03 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].oeb03 CLIPPED)
            END IF
         END IF    
      END FOR 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].oeb03 CLIPPED      
   END IF    
                                                                                 
   IF g_success='Y' THEN
      COMMIT WORK 
   ELSE
      ROLLBACK WORK
   END IF
   MESSAGE ''
END FUNCTION
#No.FUN-870033
