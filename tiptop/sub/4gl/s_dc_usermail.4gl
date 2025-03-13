# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_dc_usermail.sql
# Descriptions...: 
# Date & Author..: 08/03/21 By Carrier  #No.FUN-830090
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-830090
 
DEFINE   ma_qry           DYNAMIC ARRAY OF RECORD
         check            LIKE type_file.chr1,   	
         gen01            LIKE gen_file.gen01,
         gen02            LIKE gen_file.gen02,
         gen03            LIKE gen_file.gen03,
         gen06            LIKE gen_file.gen06
END RECORD
DEFINE   ma_qry_tmp       DYNAMIC ARRAY OF RECORD
         check            LIKE type_file.chr1,   	
         gen01            LIKE gen_file.gen01,
         gen02            LIKE gen_file.gen02,
         gen03            LIKE gen_file.gen03,
         gen06            LIKE gen_file.gen06
END RECORD
DEFINE   ma_noemail       DYNAMIC ARRAY OF RECORD
         gen01            LIKE gen_file.gen01
                          END RECORD
DEFINE   g_cnt            LIKE type_file.num5
DEFINE   mi_multi_sel     LIKE type_file.num5     
DEFINE   mi_need_cons     LIKE type_file.num5     
DEFINE   ms_cons_where    STRING     
DEFINE   mi_page_count    LIKE type_file.num10     
DEFINE   ms_default1      STRING,    
         ms_default2      STRING,    
         ms_mime          LIKE type_file.num5     
DEFINE   ms_gen01         STRING,    
         ms_gen06         STRING     
DEFINE   ms_ret1          STRING,    
         ms_ret2          STRING     
 
FUNCTION s_dc_usermail(pi_multi_sel,pi_need_cons,ps_gen01,ps_gen06,pi_mime)
   DEFINE   pi_multi_sel   LIKE type_file.num5,   	
            pi_need_cons   LIKE type_file.num5,   	
            ps_gen01       STRING,
            ps_gen06       STRING,
            pi_mime        LIKE type_file.num5   	
   DEFINE   lnode_root     om.DomNode
   DEFINE   llst_items     om.NodeList
   DEFINE   lnode_item     om.DomNode
   DEFINE   li_i           LIKE type_file.num5   	
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET ms_default1 = ps_gen01
   LET ms_default2 = ps_gen06
   LET ms_gen01    = ps_gen01
   LET ms_gen06    = ps_gen06
   LET ms_mime     = pi_mime
 
   OPEN WINDOW w_qry WITH FORM "sub/42f/s_dc_usermail"
        ATTRIBUTE( STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("s_dc_usermail")
 
   LET mi_multi_sel = TRUE
 
   IF NOT cl_null(ms_default1) OR NOT cl_null(ms_default2) THEN
      LET mi_need_cons = FALSE
   ELSE
      LET mi_need_cons = TRUE
   END IF
   
   IF NOT (mi_multi_sel) THEN
      LET lnode_root = ui.Interface.getRootNode()
      LET llst_items = lnode_root.selectByTagName("TableColumn")
      FOR li_i=1 TO llst_items.getLength()
          LET lnode_item = llst_items.item(li_i)
          IF (lnode_item.getAttribute("colName") = "check") THEN
             LET lnode_item = lnode_item.getFirstChild()
             CALL lnode_item.setAttribute("hidden","1")
             EXIT FOR
          END IF
      END FOR
   END IF
 
   CALL s_dc_usermail_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1,ms_ret2 
   ELSE
      RETURN ms_ret1,ms_ret2
   END IF
END FUNCTION
 
FUNCTION s_dc_usermail_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     
            li_reconstruct   LIKE type_file.num5,     
            li_continue      LIKE type_file.num5      
   DEFINE   li_start_index   LIKE type_file.num10,  	
            li_end_index     LIKE type_file.num10  	
   DEFINE   li_curr_page     LIKE type_file.num5   	
 
   LET mi_page_count = 100 
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON gen01,gen02,gen03,gen06
                 FROM s_zx[1].gen01,s_zx[1].gen02,s_zx[1].gen03,s_zx[1].gen06
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         ELSE
            LET ms_cons_where = "1=1"
         END IF
     
         CALL s_dc_usermail_qry_prep_result_set() 
         
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
     
      CALL s_dc_usermail_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      MESSAGE "Total count : " || ma_qry.getLength() || "  Page : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL s_dc_usermail_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL s_dc_usermail_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
FUNCTION s_dc_usermail_qry_prep_result_set()
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10  	
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,    	
            gen01       LIKE gen_file.gen01,
            gen02       LIKE gen_file.gen02,
            gen03       LIKE gen_file.gen03,
            gen06       LIKE gen_file.gen06
   END RECORD
 
   LET ls_sql = "SELECT 'N',gen01,gen02,gen03,gen06 ", 
                 " FROM gen_file",
                " WHERE ",ms_cons_where CLIPPED
 
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY gen01,gen02,gen03,gen06" 
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   LET g_cnt = 1
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
      
      IF li_i > g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
      
   END FOREACH
END FUNCTION
 
FUNCTION s_dc_usermail_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,  	
            pi_end_index     LIKE type_file.num10  	
   DEFINE   li_i             LIKE type_file.num10,  	
            li_j             LIKE type_file.num10  	
 
   CALL ma_qry_tmp.clear()
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
FUNCTION s_dc_usermail_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,  	
            pi_end_index     LIKE type_file.num10  	
   DEFINE   li_continue      LIKE type_file.num5,   	
            li_reconstruct   LIKE type_file.num5   	
   DEFINE   li_i             LIKE type_file.num5   	
   DEFINE   l_str            STRING
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_zx.*
         ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
     
      ON ACTION prevpage
         CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL s_dc_usermail_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
         EXIT INPUT
     
      ON ACTION nextpage
         CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL s_dc_usermail_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
         EXIT INPUT
     
      ON ACTION refresh
         CALL s_dc_usermail_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT INPUT
 
      ON ACTION accept
         CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL s_dc_usermail_qry_reset_multi_sel(pi_start_index, pi_end_index)
         CALL s_dc_usermail_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         LET l_str = NULL
         FOR li_i = 1 TO ma_noemail.getLength()
             LET l_str = l_str,ma_noemail[li_i].gen01 CLIPPED,"  "
         END FOR
         IF NOT cl_null(l_str) THEN
            CALL cl_err_msg("","lib-048",l_str,1)
         END IF
 
         EXIT INPUT
     
      ON ACTION cancel
         LET ms_ret1 = ms_default1
         LET ms_ret2 = ms_default2
 
         LET li_continue = FALSE
         EXIT INPUT
     
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
FUNCTION s_dc_usermail_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,  	
            pi_end_index     LIKE type_file.num10  	
   DEFINE   li_i             LIKE type_file.num10,  	
            li_j             LIKE type_file.num10  	
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
FUNCTION s_dc_usermail_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,  	
            pi_end_index     LIKE type_file.num10  	
   DEFINE   li_continue      LIKE type_file.num5,   	
            li_reconstruct   LIKE type_file.num5   	
   DEFINE   li_i             LIKE type_file.num5   	
   DEFINE   l_str            STRING
 
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
         CALL s_dc_usermail_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         LET l_str = NULL
         FOR li_i = 1 TO ma_noemail.getLength()
             LET l_str = l_str,ma_noemail[li_i].gen01 CLIPPED,"  "
         END FOR
         IF NOT cl_null(l_str) THEN
            DISPLAY l_str,"無設定email, 所以不列入mail list中"
         END IF
 
         EXIT DISPLAY
      
      ON ACTION enter 
         CALL s_dc_usermail_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
         EXIT DISPLAY
      
      ON ACTION cancel
         LET ms_ret1 = ms_default1
         LET ms_ret2 = ms_default2
 
         LET li_continue = FALSE
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
FUNCTION s_dc_usermail_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10  	
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
FUNCTION s_dc_usermail_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10  	
   DEFINE   lsb_multi_gen01  base.StringBuffer
   DEFINE   lsb_multi_gen06  base.StringBuffer
   DEFINE   li_i            LIKE type_file.num10   	
 
   CALL ma_noemail.clear()
   IF (mi_multi_sel) THEN
      LET lsb_multi_gen01 = base.StringBuffer.create()
      LET lsb_multi_gen06 = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF cl_null(ma_qry[li_i].gen06) THEN
               SELECT gen06 INTO ma_qry[li_i].gen06 FROM gen_file WHERE gen01 = ma_qry[li_i].gen01
               IF cl_null(ma_qry[li_i].gen06) THEN
                  LET ma_noemail[g_cnt].gen01 = ma_qry[li_i].gen01
                  LET g_cnt = g_cnt + 1
                  CONTINUE FOR
               END IF
            END IF
            IF (lsb_multi_gen01.getLength() = 0) THEN
               CALL lsb_multi_gen01.append(ma_qry[li_i].gen01 CLIPPED)
               CALL lsb_multi_gen06.append(ma_qry[li_i].gen06 CLIPPED)
               CALL lsb_multi_gen06.append(":" || ma_qry[li_i].gen02 CLIPPED)
            ELSE
               CALL lsb_multi_gen01.append(";" || ma_qry[li_i].gen01 CLIPPED)
               CALL lsb_multi_gen06.append(";" || ma_qry[li_i].gen06 CLIPPED)
               CALL lsb_multi_gen06.append(":" || ma_qry[li_i].gen02 CLIPPED)
            END IF
         END IF    
      END FOR
      
      LET ms_ret1 = lsb_multi_gen01.toString()
      LET ms_ret2 = lsb_multi_gen06.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].gen01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].gen06 CLIPPED
   END IF
END FUNCTION
