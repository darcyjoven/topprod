# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Program name  : q_m_asw.4gl
# Description   : 整批生成項次開窗
# Date & Author : NO:FUN-B90088 2011/08/31 BY xuxz
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-BB0036

DEFINE ma_qry   DYNAMIC ARRAY OF RECORD 
       CHECK    LIKE type_file.chr1,
       asw04    LIKE asw_file.asw04,
       asw07    LIKE asw_file.asw07,
       asg02_s  LIKE asg_file.asg02,
       asw08    LIKE asw_file.asw08,
       asg02_t  LIKE asg_file.asg02
       END RECORD 

DEFINE ma_qry_tmp   DYNAMIC ARRAY OF RECORD 
       CHECK    LIKE type_file.chr1,
       asw04    LIKE asw_file.asw04,
       asw07    LIKE asw_file.asw07,
       asg02_s  LIKE asg_file.asg02,
       asw08    LIKE asw_file.asw08,
       asg02_t  LIKE asg_file.asg02
       END RECORD 
DEFINE g_asw01 LIKE asw_file.asw01
DEFINE g_asw02 LIKE asw_file.asw02
DEFINE g_asw03 LIKE asw_file.asw03
DEFINE g_asw031 LIKE asw_file.asw031
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING                        #回傳欄位的變數

FUNCTION q_m_asw(pi_multi_sel,pi_need_cons,p_asw01,p_asw02,p_asw03,p_asw031)
   DEFINE p_asw01 LIKE asw_file.asw01
   DEFINE p_asw02 LIKE asw_file.asw02
   DEFINE p_asw03 LIKE asw_file.asw03
   DEFINE p_asw031 LIKE asw_file.asw031
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	
            pi_need_cons   LIKE type_file.num5

   
   WHENEVER ERROR CALL cl_err_msg_log

   OPEN WINDOW w_qry WITH FORM "qry/42f/q_m_asw" ATTRIBUTE(STYLE="create_qry")

   CALL cl_ui_locale("q_m_asw")

   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   LET  g_asw01 = p_asw01
   LET  g_asw02 = p_asw02
   LET  g_asw03 = p_asw03
   LET  g_asw031 = p_asw031

   # 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF

   CALL m_asw_qry_sel()
   
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1 #回傳值(也許有多個).
   END IF
END FUNCTION


##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_asw_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	
            li_continue      LIKE type_file.num5      #是否繼續.	SMALLINT
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
            CONSTRUCT ms_cons_where ON asw04,asw07,asw08
                                  FROM s_asw[1].asw04,s_asw[1].asw07,s_asw[1].asw08
            ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF

         CALL m_asw_qry_prep_result_set() 
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

      CALL m_asw_qry_set_display_data(li_start_index, li_end_index)

      LET li_curr_page = li_end_index / mi_page_count

      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF

      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang

      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page

      IF (mi_multi_sel) THEN
         CALL m_asw_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL m_asw_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2011/08/31 by xuxz
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION m_asw_qry_prep_result_set()
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10
   DEFINE   lr_qry   RECORD
            CHECK    LIKE type_file.chr1,
            asw04    LIKE asw_file.asw04,
            asw07    LIKE asw_file.asw07,
            asg02_s  LIKE asg_file.asg02,
            asw08    LIKE asw_file.asw08,
            asg02_t  LIKE asg_file.asg02
            END RECORD
   LET ls_sql = "SELECT 'N',asw04,asw07,'',asw08,'' ",
                "  FROM asw_file ",
                " WHERE ",ms_cons_where
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND asw01= '",g_asw01,"'",
                     " AND asw02= '",g_asw02,"'",
                     " AND asw03= '",g_asw03,"'",
                     " AND asw031= '",g_asw031,"'"
   END IF
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED
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

      SELECT asg02 INTO lr_qry.asg02_s FROM asg_file
       WHERE asg01= lr_qry.asw07 
      SELECT asg02 INTO lr_qry.asg02_t FROM asg_file
       WHERE asg01= lr_qry.asw08 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION



   
FUNCTION m_asw_qry_set_display_data(pi_start_index,pi_end_index)
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

FUNCTION m_asw_qry_input_array(ps_hide_act,pi_start_index,pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No:FUN-880082
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_asw.* 
    ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
   #ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_asw.check) RETURNING ma_qry_tmp[ARR_CURR()].CHECK
         CALL m_asw_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_asw.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_asw_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL m_asw_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         CALL GET_FLDBUF(s_asw.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_asw_qry_reset_multi_sel(pi_start_index, pi_end_index)
         CALL m_asw_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF

         LET li_continue = FALSE
     
         EXIT INPUT

      #No.FUN-660161--beatk
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

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

FUNCTION m_asw_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION


FUNCTION m_asw_qry_display_array(ps_hide_act,pi_start_index,pi_end_index )
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT

   DISPLAY ARRAY ma_qry_tmp TO s_asw.*
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
         CALL m_asw_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF

         LET li_continue = FALSE
      
         EXIT DISPLAY

      #No.FUN-660161--beatk
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

FUNCTION m_asw_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER


   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION

FUNCTION m_asw_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	#No.FUN-680131 INTEGER
 

   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF

   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].asw04 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].asw04 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].asw04 CLIPPED
   END IF
END FUNCTION
#FUN-B90088
