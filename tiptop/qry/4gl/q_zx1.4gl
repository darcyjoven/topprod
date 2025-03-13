# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#{
# Program name ..: q_zx1.4gl
# Program ver....: 7.0
# Description....: 人員查詢  
# Date & Author..: 06/10/16 by yoyo
# Memo...........:
#}
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-8A0226 08/10/29 By Sarah 本程式增加後沒過單,導致p_load_msg開窗沒反應,重新過單
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1, 
         zx01     LIKE zx_file.zx01,
         zx02     LIKE zx_file.zx02,
         zx03     LIKE zx_file.zx03,
         online   LIKE type_file.chr1
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         zx01     LIKE zx_file.zx01,
         zx02     LIKE zx_file.zx02,
         zx03     LIKE zx_file.zx03,
         online   LIKE type_file.chr1
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5  #是否需要復選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5  #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_default1      STRING     
DEFINE   ms_type          LIKE type_file.chr1            
DEFINE   ms_ret1          STRING     
 
FUNCTION q_zx1(pi_multi_sel,pi_need_cons,ps_default1,ps_type) 
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_type        LIKE type_file.chr1,    
            ps_default1    STRING    
            {%與回傳欄位的個數相對應,格式為ps_default+流水號}
 
 
   LET ms_default1 = ps_default1
   LET ms_type     = ps_type    
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry_zx1 WITH FORM "qry/42f/q_zx1" ATTRIBUTE(STYLE="createqry")
 
   CALL cl_ui_locale("q_zx1")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不復選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在復選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("zx01", "red")
   END IF
 
   CALL zx_qry_sel()
 
   CLOSE WINDOW w_qry_zx1
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
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
FUNCTION zx_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,   #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,   #是否重新CONSTRUCT.預設為TRUE.
            li_continue      LIKE type_file.num5  
   DEFINE   li_start_index   LIKE type_file.num10,  
            li_end_index     LIKE type_file.num10
   DEFINE   li_curr_page     LIKE type_file.num5  
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 300
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
 
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
 
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON zx01,zx02,zx03
                                  FROM s_zx[1].zx01,s_zx[1].zx02,s_zx[1].zx03
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
 
         CALL zx_qry_prep_result_set()
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
 
      CALL zx_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL zx_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL zx1_qry_displa_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 准備查詢畫面的資料集.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION zx_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10
   DEFINE   l_n      LIKE type_file.num10
   DEFINE   l_cmd    STRING
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,
            zx01     LIKE zx_file.zx01,                   
            zx02     LIKE zx_file.zx02,                   
            zx03     LIKE zx_file.zx03,   
            online   LIKE type_file.chr1
   END RECORD
   DEFINE   lr_arr   RECORD
            check    LIKE type_file.chr1,
            zx01     LIKE zx_file.zx01,                   
            zx02     LIKE zx_file.zx02,                   
            zx03     LIKE zx_file.zx03,                   
            online   LIKE type_file.chr1
   END RECORD
 
 
      #Begin:FUN-980030
      LET l_filter_cond = cl_get_extra_cond_for_qry('q_zx1', 'zx_file')
      IF NOT cl_null(l_filter_cond) THEN
         LET ms_cons_where = ms_cons_where,l_filter_cond
      END IF
      #End:FUN-980030
      LET ls_sql = "SELECT 'N',zx01,zx02,zx03,'N' ", 
                   "  FROM zx_file",
                   " WHERE ",ms_cons_where
 
 
 
   LET ls_sql = ls_sql," ORDER BY zx01" 
 
   DISPLAY "ls_sql=",ls_sql
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
 
      LET lr_qry.check   = lr_arr.check
      LET lr_qry.zx01    = lr_arr.zx01
      LET lr_qry.zx02    = lr_arr.zx02
      LET lr_qry.zx03    = lr_arr.zx03
      
      #抓取是否上線
      SELECT count(*) INTO l_n FROM gbq_file 
       WHERE gbq03 = lr_arr.zx01
      IF l_n > 0 THEN
         LET lr_arr.online = 'Y'
      END IF
      LET lr_qry.online = lr_arr.online
#      LET l_cmd = "ps -ef|grep fglrun|grep -v grep|grep ",lr_arr.zx01 clipped," > zx_process.txt"
#      RUN l_cmd 
#      LET l_cmd = "test -s zx_process.txt"
#      RUN l_cmd RETURNING l_n
#      IF l_n = 0 THEN
#         LET lr_arr.online = 'Y'
#      END IF
#      LET lr_qry.online = lr_arr.online
#      LET l_cmd="rm zx_process.txt"
#      RUN l_cmd
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
 
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_start_index   INTEGER   所要顯現的查詢資料起始位置
#               : pi_end_index     INTEGER   所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION zx_qry_set_display_data(pi_start_index, pi_end_index)
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
# Description  	: 采用INPUT ARRAY的方式來顯現查詢過后的資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   INTEGER   所要顯現的查詢資料起始位置
#               : pi_end_index     INTEGER   所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變后的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION zx_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   i                LIKE type_file.num10
   DEFINE   l_n              LIKE type_file.num10
   DEFINE   l_cmd            STRING
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5 
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_zx.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE,UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_zx.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL zx1_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_zx.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL zx1_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         CALL zx1_qry_refresh()
 
         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_zx.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL zx1_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL zx1_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
 
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
 
         EXIT INPUT
 
      ### FUN-880082 mark START ###         
#      #全選
#      ON ACTION checkall
#         CALL zx1_qry_checkall_multi_sel()
#         LET pi_start_index = 1
#         LET li_continue = TRUE 
#         EXIT INPUT
      ### FUN-880082 mark END ###
 
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
 
      #按部門選擇
      ON ACTION checkdep  
         CALL zx1_qry_checkdep_multi_sel()
         LET pi_start_index = 1
         LET li_continue = TRUE 
         EXIT INPUT
      
      #刷新上線人員 
      ON ACTION refreshonline
        FOR i =1 TO ma_qry.getLength()
#         LET l_cmd = "ps -ef|grep fglrun|grep -v grep|grep ",ma_qry[i].zx01 clipped," > zx_process.txt"
#         RUN l_cmd 
#         LET l_cmd = "test -s zx_process.txt"
#         RUN l_cmd RETURNING l_n
#         IF l_n = 0 THEN                                           
#            LET ma_qry[i].online='Y'                               
#            LET ma_qry_tmp[i].online='Y'
#         ELSE
#            LET ma_qry[i].online='N'                               
#            LET ma_qry_tmp[i].online='N'
#         END IF                                                       
#         LET l_cmd="rm zx_process.txt"
#         RUN l_cmd
          SELECT count(*) INTO l_n FROM gbq_file
           WHERE gbq03=ma_qry[i].zx01
          IF l_n > 0 THEN
             LET ma_qry[i].online='Y'                               
             LET ma_qry_tmp[i].online='Y'
          ELSE
             LET ma_qry[i].online='N'                               
             LET ma_qry_tmp[i].online='N'
          END IF                                                       
            
        END FOR
        DISPLAY ARRAY ma_qry_tmp TO s_zx.*
        CONTINUE INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
#如果要輸入多個部門，用︱分隔開
FUNCTION zx1_qry_checkdep_multi_sel()
   DEFINE   li_i       LIKE type_file.num10
   DEFINE   l_dep      STRING    
   DEFINE   l_depnew   LIKE zx_file.zx03
   DEFINE   dep_no     LIKE type_file.num10
   DEFINE   l_n        LIKE type_file.num10
   DEFINE   i          LIKE type_file.num10
   DEFINE   dep_mult   base.StringTokenizer
    
   OPEN WINDOW w_qry_input WITH FORM "qry/42f/q_zx1_depart" 
 
   CALL cl_ui_locale("q_zx1_depart")
 
   INPUT l_dep FROM depart 
     AFTER FIELD depart
       LET dep_mult = base.StringTokenizer.create(l_dep,"|")
       LET dep_no = dep_mult.countTokens()
       FOR i = 1 TO dep_no  
         LET l_depnew = dep_mult.nextToken()
         SELECT count(*) INTO l_n FROM zx_file
          WHERE zx03 = l_depnew
         IF l_n = 0 THEN
            CALL cl_err3("sel","zx_file","","","zx-001","","",0)
            NEXT FIELD depart
            EXIT FOR
         END IF
       END FOR
 
     AFTER INPUT
       IF INT_FLAG THEN                                                       
          EXIT INPUT                                                          
       END IF    
       LET dep_mult = base.StringTokenizer.create(l_dep,"|")
       LET dep_no = dep_mult.countTokens()
       FOR i = 1 TO dep_no  
         LET l_dep = dep_mult.nextToken()
         FOR li_i = 1 TO ma_qry.getLength()
           IF l_dep = ma_qry[li_i].zx03 THEN
             LET ma_qry[li_i].check = 'Y'
           END IF
         END FOR
       END FOR
  
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(depart)
              CALL cl_init_qry_var()                                        
              LET g_qryparam.form     = "q_gem"                             
              LET g_qryparam.state    = "c"                                 
              CALL cl_create_qry() RETURNING g_qryparam.multiret            
              LET l_dep = g_qryparam.multiret
              DISPLAY l_dep TO depart                         
              NEXT FIELD depart     
          OTHERWISE EXIT CASE
       END CASE
 
    ON IDLE g_idle_seconds                                                    
       CALL cl_on_idle()                                                      
       CONTINUE INPUT 
 
  END INPUT
  IF INT_FLAG THEN                                                             
      LET INT_FLAG = 0                                                          
      CLOSE WINDOW w_qry_input                                                  
      RETURN                                                                    
  END IF                                                                       
                                                                                
  CLOSE WINDOW w_qry_input
END FUNCTION
 
FUNCTION zx1_qry_checkall_multi_sel()
   DEFINE   li_i   LIKE type_file.num10
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'Y'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_start_index   INTEGER   所要顯現的查詢資料起始位置
#               : pi_end_index     INTEGER   所要顯現的查詢資料結束位置
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION zx1_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Description  	: 采用DISPLAY ARRAY的方式來顯現查詢過后的資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   INTEGER   所要顯現的查詢資料起始位置
#               : pi_end_index     INTEGER   所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變后的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION zx1_qry_displa_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_zx.*
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
         CALL zx1_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
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
FUNCTION zx1_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇并確認資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_sel_index   INTEGER   所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION zx1_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10
 
 
   # 2004/06/03 by saki : GDC 1.3版本后，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].zx01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].zx01 CLIPPED)
            END IF
         END IF
      END FOR
      # 2003/09/16 by Hiko : 復選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].zx01 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
#MOD-8A0226
