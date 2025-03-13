# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name  : q_rvbslk7.4gl copy from q_rvb7.4gl(TQC-C20512) 
# Program ver.  : 7.0
# Description   : 驗收單號查詢
# Date & Author : 2012/02/29 By lixiang  
# Memo          : 

DATABASE ds
 
GLOBALS "../../config/top.global"
#查詢資料的暫存器.
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check       LIKE type_file.chr1,  
         rvbslk02    LIKE rvbslk_file.rvbslk02,
         rvbslk04    LIKE rvbslk_file.rvbslk04,
         rvbslk03    LIKE rvbslk_file.rvbslk03,
         rvbslk05    LIKE rvbslk_file.rvbslk05,
         rvbslk30    LIKE rvbslk_file.rvbslk30 
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check           LIKE type_file.chr1,  	
         rvbslk02        LIKE rvbslk_file.rvbslk02,
         rvbslk04        LIKE rvbslk_file.rvbslk04,
         rvbslk03        LIKE rvbslk_file.rvbslk03,
         rvbslk05        LIKE rvbslk_file.rvbslk05,
         rvbslk30        LIKE rvbslk_file.rvbslk30 
END RECORD
 
DEFINE   ma_cons_lif   DYNAMIC ARRAY OF RECORD
         check           LIKE type_file.chr1, 
         rvbslk02        LIKE rvbslk_file.rvbslk02,
         rvbslk04        LIKE rvbslk_file.rvbslk04,
         rvbslk03        LIKE rvbslk_file.rvbslk03,
         rvbslk05        LIKE rvbslk_file.rvbslk05,
         rvbslk30        LIKE rvbslk_file.rvbslk30    
END RECORD
 
#該數組是多屬性料號中的一個重要的控制數組，記錄了整個Table中所有的
#列及其控制信息，在程序中多次用到
#與cl_create_qry中原來的定義相比，刪除了部分成員變量以簡化程序
DEFINE ma_multi_rec DYNAMIC ARRAY OF RECORD
       index	 LIKE type_file.num5,        #字段的序號
       colname   STRING,                     #列名稱
       value     DYNAMIC ARRAY OF STRING,   #屏幕數組值
       dbfield   STRING,        #在數據庫中對應的實際欄位名稱
       dbtype    LIKE type_file.chr1000, #該欄位在數據庫中的數據類型 
       dispfld   STRING,        #表示該t欄位(或表示料件的x欄位)對應的顯示欄位
       imafld    STRING         #只對x欄位有效，'Y'表示該欄位表示料件編號
                                #'N'表示該欄位不是料件編號
END RECORD
 
#以下是多屬性料件專用的合成SQL用的字符串
DEFINE g_multi_join   STRING,
       g_multi_where  STRING
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	
DEFINE   ms_default1      STRING     
DEFINE   ms_oldvalue      STRING    
DEFINE   ms_ret1          STRING,    #回傳欄位的變數
         ms_rvu01         LIKE rvu_file.rvu01,
         ms_no            LIKE rvbslk_file.rvbslk01
 
FUNCTION q_rvbslk7(pi_multi_sel,pi_need_cons,ps_default1,p_rvu01,p_no)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  
            pi_need_cons   LIKE type_file.num5, 
            ps_default1    STRING  , #預設回傳值(在取消時會回傳此類預設值). 
            p_rvu01        LIKE rvu_file.rvu01,
            p_no           LIKE rvbslk_file.rvbslk01 
 
 
   LET ms_default1 = ps_default1
   LET ms_rvu01    = p_rvu01
   LET ms_no       = p_no
   LET ms_oldvalue = p_rvu01 #在取消時會回傳此預設值
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_rvbslk7" ATTRIBUTE(STYLE="create_qry") 
 
   CALL cl_ui_locale("q_rvbslk7")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("rvbslk02", "red")
   END IF
 
   CALL rvbslk7_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1 #回傳值(也許有多個).
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
##################################################
FUNCTION rvbslk7_qry_sel()
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
     
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON rvbslk02,rvbslk04,rvbslk03,rvbslk05,rvbslk30
                                  FROM s_rvbslk[1].rvbslk02,s_rvbslk[1].rvbslk04,
                                       s_rvbslk[1].rvbslk03,s_rvbslk[1].rvbslk05,
                                       s_rvbslk[1].rvbslk30
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
        
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF                        
         END IF
     
         CALL rvbslk7_qry_prep_result_set() 
         # 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
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
     
      CALL rvbslk7_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL rvbslk7_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL rvbslk7_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
##################################################
FUNCTION rvbslk7_qry_prep_result_set()
   DEFINE l_filter_cond STRING 
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	
   DEFINE   lr_qry   RECORD
         check    LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位(per亦需將check移除). 
         rvbslk02    LIKE rvbslk_file.rvbslk02,
         rvbslk04    LIKE rvbslk_file.rvbslk04,
         rvbslk03    LIKE rvbslk_file.rvbslk03,
         rvbslk05    LIKE rvbslk_file.rvbslk05,
         rvbslk30    LIKE rvbslk_file.rvbslk30 
   END RECORD
   DEFINE   l_rvvslk17  LIKE rvvslk_file.rvvslk17
 
   LET ls_sql=" SELECT 'N',rvbslk02,rvbslk04,rvbslk03,rvbslk05,rvbslk30",
              "   FROM rvbslk_file",
              "  WHERE ",ms_cons_where CLIPPED
                         
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND rvbslk01='",ms_default1,"'"
   END IF
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_rvbslk7', 'rvbslk_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY rvbslk02"
 
   IF (NOT mi_multi_sel ) THEN						
        CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql						
   END IF						
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      # 判斷是否已達選取上限  
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      SELECT SUM(rvvslk17) INTO l_rvvslk17 FROM rvvslk_file
       WHERE rvvslk04 = ms_no 
         AND rvvslk05 = lr_qry.rvbslk02 
         AND rvvslk03 = '3'  
        AND rvvslk01!= ms_rvu01      
      IF cl_null(l_rvvslk17) THEN
         LET l_rvvslk17 = 0
      END IF
      LET lr_qry.rvbslk30 = lr_qry.rvbslk30 - l_rvvslk17
      IF lr_qry.rvbslk30 < 0 THEN
         LET lr_qry.rvbslk30 = 0
      END IF   
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return        : void
##################################################
FUNCTION rvbslk7_qry_set_display_data(pi_start_index, pi_end_index)
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
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
##################################################
FUNCTION rvbslk7_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10  
   DEFINE   li_continue      LIKE type_file.num5,  
            li_reconstruct   LIKE type_file.num5   
   DEFINE   li_i             LIKE type_file.num5  
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_rvbslk.* 
       ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) 
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_rvbslk.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL rvbslk7_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_rvbslk.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL rvbslk7_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL rvbslk7_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN       
            CALL GET_FLDBUF(s_rvbslk.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL rvbslk7_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL rvbslk7_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                      
            LET ms_ret1 = NULL    
         END IF                  
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_oldvalue
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
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: void
##################################################
FUNCTION rvbslk7_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
##################################################
FUNCTION rvbslk7_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  	
            li_reconstruct   LIKE type_file.num5  	
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_rvbslk.*
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
         CALL rvbslk7_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_oldvalue
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
##################################################
FUNCTION rvbslk7_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	
# Return   	: void
##################################################
FUNCTION rvbslk7_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].rvbslk02 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].rvbslk02 CLIPPED)
            END IF
         END IF    
      END FOR
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].rvbslk02 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
#TQC-C20512 
