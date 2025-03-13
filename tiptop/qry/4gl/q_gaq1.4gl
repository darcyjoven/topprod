# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Program name  : q_gaq1.4gl
# Program ver.  : 7.0
# Description   : 資料欄位查詢
# Date & Author : 2006/11/20 By Echo  FUN-690069
# Modify........: No.FUN-7C0020 07/12/06 By Echo 功能調整<part2>
# Modify........: No.FUN-810062 08/02/19 By Echo 增加 MSV 程式段
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.FUN-860089 09/04/28 By Echo 開窗全選功能重覆
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No.FUN-A90024 10/11/10 By Jay 調整各DB利用sch_file取得table與field等資訊
 
DATABASE ds
 
#FUN-690069 新程式
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         gat01    LIKE gat_file.gat01,                      
         gaq01    LIKE gaq_file.gaq01,                      
         gaq03    LIKE gaq_file.gaq03
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         gat01    LIKE gat_file.gat01,                      
         gaq01    LIKE gaq_file.gaq01,                      
         gaq03    LIKE gaq_file.gaq03
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      LIKE gaq_file.gaq03
DEFINE   ms_default1_t    LIKE gaq_file.gaq03
DEFINE   ms_tabname       STRING
DEFINE   ms_ret1          LIKE gaq_file.gaq03
DEFINE   ms_db_type       LIKE type_file.chr3
 
FUNCTION q_gaq1(pi_multi_sel,pi_need_cons,ps_default1,ps_tabname)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    LIKE gaq_file.gaq03,
            ps_tabname     STRING
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_gaq1" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161
  
   CALL cl_ui_locale("q_gaq1")
 
   LET ms_db_type=cl_db_get_database_type()
 
   LET ms_ret1 = ""
   LET ms_default1   = ps_default1
   LET ms_default1_t = ps_default1
   LET ms_tabname    = ps_tabname
   LET mi_multi_sel  = pi_multi_sel
   LET mi_need_cons  = pi_need_cons
 
   IF ms_tabname.getIndexOf(',',1) = 0 THEN
      CALL cl_set_comp_visible("gat01",FALSE)
   END IF
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
   
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("gaq03", "red")
   END IF
 
   CALL gaq_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/18 by carrier       
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION gaq_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 0
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
 
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) AND ms_default1 IS NULL THEN
            CONSTRUCT ms_cons_where ON gat01,gaq01,gaq03
                                  FROM s_gaq[1].gat01,s_gaq[1].gaq01,s_gaq[1].gaq03
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
     
         CALL gaq_qry_prep_result_set() 
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
     
      CALL gaq_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL gaq_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL gaq_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/18 by carrier       
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION gaq_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            gat01    LIKE gat_file.gat01,                      
            gaq01    LIKE gaq_file.gaq01,                      
            gaq03    LIKE gaq_file.gaq03
            END RECORD
   DEFINE   l_str    STRING
   DEFINE   l_str2   STRING
   DEFINE   l_p      LIKE type_file.num5
   DEFINE   l_tab    LIKE gat_file.gat01
   DEFINE   l_tok    base.StringTokenizer
   DEFINE   buf      base.StringBuffer
   DEFINE   l_zta17  LIKE zta_file.zta17        #FUN-7C0020
 
   #FUN-7C0020
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
   LET l_str = ms_default1
   LET buf = base.StringBuffer.create()
   CALL buf.append(l_str)
   CALL buf.replace(" ","", 0)
   LET l_str = buf.toString()
   
   LET l_tok = base.StringTokenizer.createExt(ms_tabname CLIPPED,",","",TRUE)
   WHILE l_tok.hasMoreTokens()
      LET l_tab=l_tok.nextToken()
 
      LET l_zta17 = NULL
      SELECT zta17 INTO l_zta17
        FROM zta_file WHERE zta01 = l_tab AND zta02 = g_dbs
 
      LET buf = base.StringBuffer.create()
      CALL buf.append(ms_cons_where)
      
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構
      #No.FUN-810062
      #CASE ms_db_type
      #  WHEN  'IFX' 
      #     CALL buf.replace("gat01","t.tabname", 0)
      #  WHEN  'ORA'
      #     IF NOT cl_null(l_zta17 CLIPPED) THEN
      #        CALL buf.replace("gat01","lower(user_tab_columns.table_name)", 0)
      #     ELSE
      #        CALL buf.replace("gat01","lower(all_tab_columns.table_name)", 0)
      #     END IF
      #  WHEN "MSV"
      #     CALL buf.replace("gat01","t.tabname", 0)
      #END CASE
      CALL buf.replace("gat01","sch01", 0)
      #---FUN-A90024---end-------
      
      LET ms_cons_where = buf.toString()

      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構
      #CASE ms_db_type
      # WHEN  'IFX' 
      #   IF NOT cl_null(l_zta17 CLIPPED) THEN
      # 
      #     #Begin:FUN-980030
      #     LET l_filter_cond = cl_get_extra_cond_for_qry('q_gaq1', 'gap_file')
      #     IF NOT cl_null(l_filter_cond) THEN
      #        LET ms_cons_where = ms_cons_where,l_filter_cond
      #     END IF
      #     #End:FUN-980030
      #     LET ls_sql =
      #             "SELECT unique 'N','',gaq01,gaq03",
      #             " FROM gaq_file,",
      #             "   ", l_zta17 CLIPPED,":syscolumns c,",
      #             "   ", l_zta17 CLIPPED,":systables t",
      #             " WHERE c.tabid=t.tabid AND t.tabname= ? ",
      #             "   AND c.colname=gaq_file.gaq01 ",
      #             "   AND gaq_file.gaq02 = '",g_lang CLIPPED,"'",
      #             "   AND ",ms_cons_where,
      #             " ORDER BY gaq_file.gaq01"
      #   ELSE
      #     LET ls_sql =
      #             "SELECT unique 'N','',gaq01,gaq03",
      #             " FROM gaq_file,syscolumns c,systables t",
      #             " WHERE c.tabid=t.tabid AND t.tabname= ? ",
      #             "   AND c.colname=gaq_file.gaq01 ",
      #             "   AND gaq_file.gaq02 = '",g_lang CLIPPED,"'",
      #             "   AND ",ms_cons_where,
      #             " ORDER BY gaq_file.gaq01"
      #   END IF
      #
      # WHEN 'ORA'
      #   IF NOT cl_null(l_zta17 CLIPPED) THEN
      #     LET ls_sql = 
      #             "SELECT unique 'N','',gaq01,gaq03",
      #             " FROM gaq_file,all_tab_columns",
      #             " WHERE lower(all_tab_columns.table_name)= ? ",
      #             "   AND lower(all_tab_columns.column_name)=gaq_file.gaq01 ",
      #             "   AND gaq_file.gaq02 = '",g_lang CLIPPED,"'",
      #             "   AND ",ms_cons_where," ORDER BY gaq_file.gaq01"
      #   ELSE
      #     LET ls_sql = 
      #             "SELECT unique 'N','',gaq01,gaq03",
      #             " FROM gaq_file,user_tab_columns",
      #             " WHERE lower(user_tab_columns.table_name)= ? ",
      #             "   AND lower(user_tab_columns.column_name)=gaq_file.gaq01 ",
      #             "   AND gaq_file.gaq02 = '",g_lang CLIPPED,"'",
      #             "   AND ",ms_cons_where," ORDER BY gaq_file.gaq01"
      #   END IF
      #
      # WHEN "MSV"
      #   IF NOT cl_null(l_zta17 CLIPPED) THEN
      #     LET ls_sql =
      #             "SELECT unique 'N','',gaq01,gaq03",
      #             " FROM gaq_file,",
      #             "   ",FGL_GETENV("MSSQLAREA") CLIPPED,"_",l_zta17 CLIPPED,".sys.columns c,",
      #             "   ",FGL_GETENV("MSSQLAREA") CLIPPED,"_", l_zta17 CLIPPED,".sys.objects t",
      #             " WHERE c.object_id = t.object_id AND t.name= ? ",
      #             "   AND c.name = gaq_file.gaq01 ",
      #             "   AND gaq_file.gaq02 = '",g_lang CLIPPED,"'",
      #             "   AND ",ms_cons_where,
      #             " ORDER BY gaq_file.gaq01"
      #   ELSE
      #     LET ls_sql =
      #             "SELECT unique 'N','',gaq01,gaq03",
      #             " FROM gaq_file, sys.columns c, sys.objects t",
      #             " WHERE c.object_id = t.object_id AND t.name= ? ",
      #             "   AND c.name = gaq_file.gaq01 ",
      #             "   AND gaq_file.gaq02 = '",g_lang CLIPPED,"'",
      #             "   AND ",ms_cons_where,
      #             " ORDER BY gaq_file.gaq01"
      #   END IF
      #END CASE
      #END No.FUN-810062
      LET ls_sql = 
              "SELECT unique 'N','',gaq01,gaq03",
              " FROM gaq_file, sch_file ",
              " WHERE lower(sch01) = ? ",
              "   AND lower(sch02) = gaq_file.gaq01 ",
              "   AND gaq_file.gaq02 = '", g_lang CLIPPED, "'",
              "   AND ", ms_cons_where, " ORDER BY gaq_file.gaq01"
      #---FUN-A90024---end-------
 
      DECLARE lcurs_qry CURSOR FROM ls_sql
 
 
   #END FUN-7C0020
 
     #OPEN lcurs_qry USING l_tab
      FOREACH lcurs_qry USING l_tab INTO lr_qry.*
         IF (SQLCA.SQLCODE) THEN
            CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
            EXIT FOREACH
         END IF
         LET lr_qry.gat01 = l_tab CLIPPED
         IF l_str = lr_qry.gaq01 CLIPPED THEN
            LET lr_qry.check = 'Y'
         ELSE
            LET l_p = l_str.getIndexOf(lr_qry.gaq01 CLIPPED,1)
            IF l_p > 0 THEN
               CASE l_p 
                  WHEN 1 
                     LET l_str2 = lr_qry.gaq01 CLIPPED
                     IF l_str.getCharAt(l_p + l_str2.getLength()) = "," THEN
                        LET lr_qry.check = 'Y'
                     END IF
                  OTHERWISE
                     LET l_str2 = lr_qry.gaq01 CLIPPED
                     IF l_str.getLength() = l_p + l_str2.getLength()-1 THEN
                         IF l_str.getCharAt(l_p-1) = "," THEN
                            LET lr_qry.check = 'Y'
                         END IF
                     ELSE
                         IF l_str.getCharAt(l_p-1) = "," AND 
                            l_str.getCharAt(l_p + l_str2.getLength()) = "," 
                         THEN
                            LET lr_qry.check = 'Y'
                         END IF
                     END IF
               END CASE
            END IF
         END IF
         #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
         IF li_i-1 >= g_aza.aza38 THEN
            CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
            EXIT FOREACH
         END IF
         LET ma_qry[li_i].* = lr_qry.*
         LET li_i = li_i + 1
      END FOREACH
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/18 by carrier       
# Parameter   	. pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION gaq_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/18 by carrier       
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               . pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION gaq_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_gaq.* ATTRIBUTE(UNBUFFERED,INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_gaq.* ATTRIBUTE(UNBUFFERED,INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
 
      ON ACTION prevpage
         CALL GET_FLDBUF(s_gaq.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL gaq_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         LET pi_start_index = pi_start_index - mi_page_count
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_gaq.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL gaq_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
 
      #FUN-860089 -- start --
      #ON ACTION select_all
      #   CALL gaq_qry_refresh('Y')
 
      #ON ACTION un_select_all
      #   CALL gaq_qry_refresh('N')
      #FUN-860089 -- end --
 
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         LET ms_default1 = NULL
         EXIT INPUT
 
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_gaq.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL gaq_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL gaq_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         LET ms_ret1 = ms_default1_t
 
         LET li_continue = FALSE
     
         EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      #No.FUN-660161--begin   
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end     
   
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
# Date & Author : 2003/09/18 by carrier       
# Parameter   	. pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION gaq_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/18 by carrier       
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               . pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION gaq_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_gaq.*
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
      
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION accept
         CALL gaq_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         LET ms_ret1 = ms_default1_t
         LET li_continue = FALSE
      
         EXIT DISPLAY
     
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      #No.FUN-660161--begin   
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end     
   
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
# Date & Author : 2003/09/18 by carrier       
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION gaq_qry_refresh(p_check)
   DEFINE   li_i    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   p_check LIKE type_file.chr1
 
   FOR li_i = 1 TO ma_qry_tmp.getLength()
      LET ma_qry_tmp[li_i].check = p_check
   END FOR
END FUNCTION
 
##################################################
# Description   : 選擇並確認資料.
# Date & Author : 2003/09/24 by jack
# Parameter     . pi_sel_index   LIKE type_file.num10    所選擇的資料索引
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION gaq_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10        #No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10        #No.FUN-680131 INTEGER
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].gaq01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("," || ma_qry[li_i].gaq01 CLIPPED)
            END IF
         END IF
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].gaq01 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
 
