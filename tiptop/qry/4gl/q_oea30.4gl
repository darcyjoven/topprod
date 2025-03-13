# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#{
# Program name  : q_oea30.4gl
# Program ver.  : 7.0
# Description   : 
# Date & Author : NO:TQC-A40114 2010/04/22 by xiaofeizhu
# Modify........: No:MOD-AC0226 10/12/20 By sabrina 不應撈出出貨通知單的單據 
# Modify........: No:MOD-B70264 11/07/29 By yinhy 不應撈出已立帳的出貨單資料
# Modify........: No:TQC-B90206 11/09/29 By Carrier QBE查不到资料,按"确认"程序当出
# Modify........: No:MOD-BC0091 11/12/12 By Polly 排除訂金已轉應收自動產生
# Modify........: No:TQC-C70167 12/07/25 By Polyy 調整排除訂金已轉應收自動產生的條件

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	
         oea01    LIKE oea_file.oea01,                                     
         oea02    LIKE oea_file.oea02,
         oea03    LIKE oea_file.oea03,                     
         oea032   LIKE oea_file.oea032
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	
         oea01    LIKE oea_file.oea01,
         oea02    LIKE oea_file.oea02,
         oea03    LIKE oea_file.oea03,
         oea032   LIKE oea_file.oea032
END RECORD

DEFINE   mi_multi_sel     LIKE type_file.num5     	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     
DEFINE   mi_page_count    LIKE type_file.num10    	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING,    
         g_cus_no         LIKE oea_file.oea03,     #No.FUN-680131 CHAR(20)
         g_type           LIKE type_file.chr1      #No.FUN-680131 CHAR(1)

FUNCTION q_oea30(pi_multi_sel,pi_need_cons)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  , 
            p_cus_no       LIKE oea_file.oea03,     #No.FUN-680131 CHAR(20)
            p_type         LIKE type_file.chr1      #No.FUN-680131 CHAR(1)
 
 
#   LET ms_default1 = ps_default1
#   LET g_cus_no= p_cus_no
#   LET g_type  = p_type
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_oea30" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161

   CALL cl_ui_locale("q_oea30")

   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons

   # 2004/02/09 by saki : 
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("oea01", "red")
   END IF

   CALL oea30_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
   END IF
END FUNCTION

##################################################
# Description  	: 
# Date & Author : 2003/09/22 by jack
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oea30_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,    	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5     
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
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
             CONSTRUCT ms_cons_where ON oea01, oea02, oea03, oea032
                                  FROM s_oea[1].oea01,s_oea[1].oea02,s_oea[1].oea03,s_oea[1].oea032
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
                   CONTINUE CONSTRUCT
             
             END CONSTRUCT
             LET ms_cons_where = ms_cons_where CLIPPED ," AND oeaconf = 'Y'"  

            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL oea30_qry_prep_result_set() 
         # 2003/07/14 by Hiko 
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 2003/07/14 by Hiko
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
     
      CALL oea30_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count

      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF

      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang

      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL oea30_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL oea30_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

##################################################
# Description  	: 
# Date & Author : 2003/09/22 by jack
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION oea30_qry_prep_result_set()
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   l_oeb04  LIKE oeb_file.oeb04
   DEFINE   l_sql,l_buf LIKE type_file.chr1000	#No.FUN-680131 CHAR(500)
   DEFINE   l_oeb12  LIKE oeb_file.oeb12
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   	#No.FUN-680131 CHAR(1)
            oea01    LIKE oea_file.oea01,
            oea02    LIKE oea_file.oea02,
            oea03    LIKE oea_file.oea03,
            oea032   LIKE oea_file.oea032

   END RECORD
   
   DEFINE   ms_cons_where1    STRING 

   LET ms_cons_where1= cl_replace_str(ms_cons_where,'oea','oga')

   LET ls_sql = "SELECT 'N',oea01,oea02,oea03,oea032", 
                " FROM oea_file",
                " WHERE ",ms_cons_where,
                "   AND oea01 NOT IN (SELECT oma16 FROM oma_file WHERE omavoid='N' AND oma16 IS NOT NULL)", #TQC-C70167 add 
                " UNION ",
                "SELECT 'N',oga01,oga02,oga03,oga032", 
                " FROM oga_file",
                " WHERE ",ms_cons_where1,
                "   AND oga09 != '1' AND oga09 != '5' ",           #MOD-AC0226 add
                "   AND (oga10 IS NULL OR oga10 = ' ')",           #MOD-B70264
                "   AND ogaconf = 'Y' AND ogapost = 'Y'"           #MOD-B70264
               #"   AND oea01 NOT IN (SELECT oma16 FROM oma_file WHERE omavoid = 'N')"  #MOD-BC0091 add #TQC-C70167 mark

#   IF NOT mi_multi_sel THEN
#      LET ls_where = "   AND oeaconf = 'Y' AND oea00!='0' "
#   END IF
#   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY oea01"

   DISPLAY "ls_sql=",ls_sql
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

      #FUN-4C0001  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION

##################################################
# Description  	: 
# Date & Author : 2003/09/22 by jack
# Parameter   	: pi_start_index   LIKE type_file.num10   	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10   #No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION oea30_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 

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
# Description  	: 
# Date & Author : 2003/09/22 by jack
# Parameter   	: ps_hide_act      STRING    
#               : pi_start_index   LIKE type_file.num10   	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10   	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   
#               : SMALLINT  
#               : INTEGER   
# Memo        	:
# Modify   	:
##################################################
FUNCTION oea30_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No:FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oea.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oea.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_oea.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oea30_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_oea.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oea30_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL oea30_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #No.TQC-B90206
            CALL GET_FLDBUF(s_oea.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL oea30_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL oea30_qry_accept(pi_start_index+ARR_CURR()-1)
         #No.TQC-B90206  --Begin
         ELSE
            LET ms_ret1 = NULL
         END IF
         #No.TQC-B90206  --End
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF

         LET li_continue = FALSE
     
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--

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
# Description  	: 
# Date & Author : 2003/09/22 by jack
# Parameter   	: pi_start_index   LIKE type_file.num10   	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10   	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oea30_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION

##################################################
# Description  	: 
# Date & Author : 2003/09/22 by jack
# Parameter   	: ps_hide_act      STRING    
#               : pi_start_index   LIKE type_file.num10    	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10   	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   
#               : SMALLINT   
#               : INTEGER   
# Memo        	:
# Modify   	:
##################################################
FUNCTION oea30_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_oea.*
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
         CALL oea30_qry_accept(pi_start_index+ARR_CURR()-1)
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
   
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

##################################################
# Description   : 
# Date & Author : 2003/09/22 by jack
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION oea30_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER


   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION

##################################################
# Description  	: 
# Date & Author : 2003/09/22 by jack
# Parameter   	: pi_sel_index   LIKE type_file.num10    	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oea30_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	#No.FUN-680131 INTEGER
 

   # 2004/06/03 by saki 
   IF pi_sel_index = 0 THEN
      RETURN
   END IF

   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].oea01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].oea01 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko :
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].oea01 CLIPPED
   END IF
END FUNCTION
#TQC-A40114 End
