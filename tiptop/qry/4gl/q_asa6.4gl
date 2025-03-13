# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Prog. Version...: '5.25.03-11.07.14(00000)'
# Program name    : q_asa6.4gl
# Description     : 
# Date & Author   : 2011/07/25 by guoch
# Memo            : 
# Modify..........: No.FUN-B70062 11/07/26 By guoch 上层公司族群编号栏位开窗
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植

#FUN-B70062 --beatk
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-BB0036

DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         asa01    LIKE asa_file.asa01,
         asa02    LIKE asa_file.asa02,
         asg02    LIKE asg_file.asg02,
         asa03    LIKE asa_file.asa03
END RECORD

DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,
         asa01        LIKE asa_file.asa01,
         asa02        LIKE asa_file.asa02,
         asg02        LIKE asg_file.asg02,
         asa03        LIKE asa_file.asa03
END RECORD

DEFINE  mi_multi_sel  LIKE type_file.num5
DEFINE  mi_need_cons  LIKE type_file.num5
DEFINE  ms_cons_where STRING
DEFINE  mi_page_count LIKE type_file.num5
DEFINE  ms_default1   STRING
DEFINE  ms_ret1       STRING
DEFINE  ms_arg1       STRING


FUNCTION q_asa6(pi_multi_sel,pi_need_cons,ps_default1,ps_arg1)
   DEFINE  pi_multi_sel    LIKE type_file.num5,
           pi_need_cons    LIKE type_file.num5,
           p_asa01         LIKE asa_file.asa01,
           ps_default1     STRING,
           ps_arg1         STRING
   
   LET ms_default1 = ps_default1
   LET ms_arg1 = ps_arg1
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_asa6" ATTRIBUTE(STYLE="create_qry")
   
   CALL cl_ui_locale("q_asa6")
   
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
   
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("asa01","red")
   END IF 
   
   CALL asa6_qry_sel()
   
   CLOSE WINDOW w_qry
   
   IF (mi_multi_sel) THEN
      RETURN ms_ret1
   ELSE
      RETURN ms_ret1
   END IF
END FUNCTION

FUNCTION asa6_qry_sel()
   DEFINE   ls_hide_act     STRING
   DEFINE   li_hide_page    LIKE type_file.num5,
            li_reconstruct  LIKE type_file.num5,
            li_continue     LIKE type_file.num5
   DEFINE   li_start_index  LIKE type_file.num10,
            li_end_index    LIKE type_file.num10
   DEFINE   li_curr_page    LIKE type_file.num5
   
   LET mi_page_count = 20 
   LET li_reconstruct = TRUE
   
   WHILE TRUE
      CLEAR FROM
      
      LET INT_FLAG = FALSE
      
      IF (li_reconstruct) THEN
         MESSAGE ""
         LET ms_cons_where = "1=1"
         
         CALL asa6_qry_prep_result_set()
         
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
      
      CALL asa6_qry_set_display_data(li_start_index,li_end_index)
      
      LET li_curr_page = li_end_index / mi_page_count
      MESSAGE "Total count : " || ma_qry.getLength() || " Page : " || li_curr_page
      
      IF (mi_multi_sel) THEN
         CALL asa6_qry_input_array(ls_hide_act,li_start_index,li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL asa6_qry_display_array(ls_hide_act,li_start_index,li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF 
      
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
###############################################

FUNCTION asa6_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_asa.*
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
         CALL asa6_qry_accept(pi_start_index+ARR_CURR()-1)
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
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON ACTION qry_string
         CALL cl_qry_string("detail")
    
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

###############################################
FUNCTION asa6_qry_prep_result_set()
   DEFINE l_filter_cond   STRING
   DEFINE ls_sql          STRING,
          ls_where        STRING
   DEFINE li_i            LIKE type_file.num10,
          l_beatk_key     LIKE asa_file.asa01
   DEFINE lr_qry          RECORD
          check           LIKE type_file.chr1,
          asa01           LIKE asa_file.asa01,
          asa02           LIKE asa_file.asa02,
          asg02           LIKE asg_file.asg02,
          asa03           LIKE asa_file.asa03
             END RECORD,
          l_adb01         LIKE adb_file.adb01,
          l_adb02         LIKE adb_file.adb02,
          l_flag          LIKE type_file.num5
    
   LET l_beatk_key = ' '
   
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_asa6','asa_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   
   LET ls_sql = "SELECT 'N',asa01,asa02,asg02,asa03 FROM ",
                 cl_get_target_table(ms_arg1,'asa_file'),",",
                 cl_get_target_table(ms_arg1,'asg_file'),
                " WHERE asa02 = asg01 AND ",ms_cons_where
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY asa01 "
   
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
   
   FOR li_i = ma_qry.getlength() TO 1 STEP -1
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
###############################################

FUNCTION asa6_qry_set_display_data(pi_start_index,pi_end_index)
   DEFINE   pi_start_index    LIKE type_file.num10,
            pi_end_index      LIKE type_file.num10
   DEFINE   li_i              LIKE type_file.num10,
            li_j              LIKE type_file.num10
            
   FOR li_i = ma_qry_tmp.getLength() TO 1 STEP -1
      CALL ma_qry_tmp.deleteElement(li_i)
   END FOR
   
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
   
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION

#################################################

FUNCTION asa6_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5
   
   INPUT ARRAY ma_qry_tmp   WITHOUT DEFAULTS FROM s_asa.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)
      BEFORE INPUT
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_asa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL asa6_qry_reset_multi_sel(pi_start_index, pi_end_index)
         
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         
         LET li_continue = TRUE
         
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_asa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL asa6_qry_reset_multi_sel(pi_start_index, pi_end_index)
         
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         
         LET li_continue = TRUE
         
         EXIT INPUT
      ON ACTION refresh
         CALL asa6_qry_refresh()
         
         LET pi_start_index = 1
         LET li_continue = TRUE
         
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN
            CALL GET_FLDBUF(s_asa.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL asa6_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL asa6_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                  
            LET ms_ret1 = NULL      
         END IF                 
         LET li_continue = FALSE
     
         EXIT INPUT
         
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
      
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
         
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

############################################
FUNCTION asa6_qry_refresh()
   DEFINE   li_i    LIKE type_file.num10
   
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
############################################
FUNCTION asa6_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index    LIKE type_file.num10,
            pi_end_index      LIKE type_file.num10
   DEFINE   li_i              LIKE type_file.num10,
            li_j              LIKE type_file.num10
            
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
############################################
FUNCTION asa6_qry_accept(pi_sel_index)
   DEFINE    pi_sel_index    LIKE type_file.num10
   DEFINE    lsb_multi_sel   base.StringBuffer,
             li_i            LIKE type_file.num10
       
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
   
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
      
      FOR li_i = 1 TO ma_qry.getLength()
         IF (lsb_multi_sel.getLength() = 0) THEN
            CALL lsb_multi_sel.append(ma_qry[li_i].asa01 CLIPPED)
         ELSE
            CALL lsb_multi_sel.append("|" || ma_qry[li_i].asa01 CLIPPED)
         END IF
      END FOR
      
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].asa01 CLIPPED
   END IF
END FUNCTION
#FUN-B70062 --end
