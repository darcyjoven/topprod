# Prog. Version..: '5.30.09-13.09.06(00000)'     #
# Pattern name...: q_oma_pmc.4gl
# Descriptions...: 應收(10賬扣)/預付待抵(23:預付)查詢
# Date & Author..: No:FUN-D80049 13/08/15 By yuhuabao
# Modify.........: No:FUN-D80116 13/08/29 By yuhuabao 客商開窗查詢里加一下全稱
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD       #MOD-C80101
         check    LIKE type_file.chr1,  	
         a        LIKE type_file.chr1,    #FUN-D60082 add
         oma01    LIKE oma_file.oma01,
         oma032    LIKE oma_file.oma032,
         occ18    LIKE occ_file.occ18,    #FUN-D80116
         occ19    LIKE occ_file.occ19,    #FUN-D80116
         omc02    LIKE omc_file.omc02,
         omc13    LIKE omc_file.omc13     
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         a        LIKE type_file.chr1,    #FUN-D60082 add
         oma01    LIKE oma_file.oma01,
         oma032    LIKE oma_file.oma032,
         occ18    LIKE occ_file.occ18,    #FUN-D80116
         occ19    LIKE occ_file.occ19,    #FUN-D80116
         omc02    LIKE omc_file.omc02,    
         omc13    LIKE omc_file.omc13
END RECORD
#
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_ret2          STRING
DEFINE   mc_dbs           LIKE type_file.chr21 	#No.FUN-680131 VARCHAR(21)
DEFINE   mc_oma01         LIKE oma_file.oma01
#FUN-D60082--add--str--
DEFINE   lc_qbe_sn         LIKE gbm_file.gbm01   
DEFINE   tm     RECORD
              a    LIKE type_file.chr10
                END RECORD
DEFINE   a      LIKE type_file.chr1
DEFINE  g_customer LIKE occ_file.occ01
#FUN-D60082--add--end--                
#
 
FUNCTION q_oma01_apa01(pi_multi_sel,pi_need_cons,p_plant,p_cust) 
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  , #預設回傳值(在取消時會回傳此類預設值).
            p_dbs          LIKE type_file.chr21, 	#No.FUN-680131 VARCHAR(21)
            p_plant        LIKE type_file.chr10
   DEFINE   p_cust         LIKE occ_file.occ01


   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_oma01_apa01" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_oma01_apa01")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   LET g_customer = p_cust
   
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko :
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("oma01", "red")
   END IF
 
   CALL m_oma01_apa01_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1
   END IF
END FUNCTION
 

FUNCTION m_oma01_apa01_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
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

            #FUN-D60082--add--str--
            LET a = '1'    
            DIALOG ATTRIBUTES(UNBUFFERED) 
            INPUT a FROM s_oma[1].a     
                ATTRIBUTE(WITHOUT DEFAULTS=TRUE)

                BEFORE INPUT
                   CALL cl_qbe_display_condition(lc_qbe_sn)
            END INPUT  
            #FUN-D60082--add--end--  
          
            CONSTRUCT ms_cons_where ON oma01,oma032                 
                                  FROM s_oma[1].oma01,s_oma[1].oma032
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE DIALOG
            
            END CONSTRUCT
            ON ACTION ACCEPT
               EXIT DIALOG        
       
            ON ACTION CANCEL
               LET INT_FLAG=1
               EXIT DIALOG
            END DIALOG   
            #FUN-D60082--add--end--  
             
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
            
         ELSE
            LET ms_cons_where=' 1=1'
         END IF
     
         CALL m_oma01_apa01_qry_prep_result_set() 
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
     
      CALL m_oma01_apa01_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file 
       WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file 
       WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL m_oma01_apa01_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL m_oma01_apa01_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
FUNCTION m_oma01_apa01_qry_prep_result_set()
   DEFINE   l_filter_cond STRING #MOD-C90076
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
         check    LIKE type_file.chr1,
         a        LIKE type_file.chr1,    #FUN-D60082 add
         oma01    LIKE oma_file.oma01,
         oma032    LIKE oma_file.oma032,
         occ18    LIKE occ_file.occ18,    #FUN-D80116
         occ19    LIKE occ_file.occ19,    #FUN-D80116
         omc02    LIKE omc_file.omc02,
         omc13    LIKE omc_file.omc13
   END RECORD
   DEFINE   l_pmc_where STRING #MOD-C90076
 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_oma01_apa01', 'oma_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   LET l_pmc_where = cl_replace_str(ms_cons_where,'oma01','apa01')  #FUN-D80049 add
   LET l_pmc_where = cl_replace_str(l_pmc_where,'oma032','apa07')  #FUN-D80049 add
  
   #End:FUN-980030
   #FUN-D60082--add--str--
   IF a = '1' THEN 
#     LET ls_sql = "SELECT 'N','1',oma01,oma032,omc02,omc13 ",  #FUN-D80049 add  #FUN-D80116 mark
      LET ls_sql = "SELECT 'N','1',oma01,oma032,occ18,occ19,omc02,omc13 ", #FUN-D80116 add
                   "  FROM ",cl_get_target_table(g_plant_new,'oma_file'), 
                   "  LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'occ_file')," ON occ01=oma03 ", #FUN-D80116
                   "  LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'omc_file')," ON omc01=oma01 ",
                   " WHERE oma00 = '10' ",
                   "   AND oma03 = '",g_customer,"'",
                   "   AND omc08 > omc10 ",
                   "   AND omaconf = 'Y' ",
                   "   AND omavoid != 'Y' ",
                   
                   "   AND ",ms_cons_where
   END IF 
   IF a = '2' THEN 
#     LET ls_sql = " SELECT 'N','2',apa01,apa07,1,apa73 ",    #FUN-D80049 add #FUN-D80116 mark
      LET ls_sql = " SELECT 'N','2',apa01,apa07,pmc081,pmc082,1,apa73 ",   #FUN-D80116  add
                   "   FROM ",cl_get_target_table(g_plant_new,'apa_file'),
                   "  LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'pmc_file')," ON pmc01=apa06 ", #FUN-D80116
                   "  WHERE apa00 = '23' ",
                   "    AND apa06 = '",g_customer,"'",
                   "    AND apa34f > apa35f ", 
                   "    AND apa41 = 'Y' ",
                   "    AND apa42 != 'Y'",
                   "   AND ",l_pmc_where     
   END IF 
   IF a = '3' THEN 
#     LET ls_sql = "SELECT 'N','1',oma01,oma032,omc02,omc13 ",  #FUN-D80049 add  #FUN-D80116 mark
      LET ls_sql = "SELECT 'N','1',oma01,oma032,occ18,occ19,omc02,omc13 ", #FUN-D80116 add
                   "  FROM ",cl_get_target_table(g_plant_new,'oma_file'),
                   "  LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'occ_file')," ON occ01=oma03 ", #FUN-D80116
                   "  LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'omc_file')," ON omc01=oma01 ",
                   " WHERE oma00 = '10' ",
                   "   AND oma03 = '",g_customer,"'",
                   "   AND omc08 > omc10 ",
                   "   AND omaconf = 'Y' ",
                   "   AND omavoid != 'Y' ",
                   "   AND ",ms_cons_where,
                   " UNION ",
#                  " SELECT 'N','2',apa01,apa07,1,apa73 ",    #FUN-D80049 add  #FUN-D80116 mark
                   " SELECT 'N','2',apa01,apa07,pmc081,pmc082,1,apa73 ",   #FUN-D80116  add
                   "   FROM ",cl_get_target_table(g_plant_new,'apa_file'),
                   "  LEFT OUTER JOIN ",cl_get_target_table(g_plant_new,'pmc_file')," ON pmc01=apa06 ", #FUN-D80116
                   "  WHERE apa00 = '23' ",
                   "    AND apa06 = '",g_customer,"'",
                   "    AND apa34f > apa35f ",
                   "    AND apa41 = 'Y' ", 
                   "    AND apa42 != 'Y'",
                   "   AND ",l_pmc_where
   END IF  #FUN-D60082 add 
  
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED
 
   DISPLAY "ls_sql=",ls_sql
 	 CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql        #FUN-920032
         CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102 
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
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
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
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION m_oma01_apa01_qry_set_display_data(pi_start_index, pi_end_index)
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
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_oma01_apa01_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oma.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
   #ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_oma.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_oma01_apa01_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_oma.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_oma01_apa01_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL m_oma01_apa01_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN     
            CALL GET_FLDBUF(s_oma.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL m_oma01_apa01_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL m_oma01_apa01_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                      
            LET ms_ret1 = NULL       
            LET ms_ret2 = NULL
         END IF                   
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
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
   
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
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
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_oma01_apa01_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_oma01_apa01_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_oma.*
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
         CALL m_oma01_apa01_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default1
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
# Date & Author : 2003/09/23 by Winny
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION m_oma01_apa01_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_oma01_apa01_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].oma01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].oma01 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].oma01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].oma032 CLIPPED
   END IF
END FUNCTION
