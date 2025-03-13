# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name  : q_field.4gl
# Program ver.  : 7.0
# Description   : 欄位內容查詢
# Date & Author : 2003/11/20 by saki
# Memo          : 
# Modify        :
# Modify........: 04/07/20 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify........: No.FUN-660161 06/07/07 By cl  增加匯出Excel功能
# Modify........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
#}
 
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry    DYNAMIC ARRAY OF RECORD
         no        LIKE smx_file.smx04,    #No.FUN-680131 SMALLINT
         fields    LIKE smx_file.smx05,    #No.FUN-680131 VARCHAR(10)
         descr     LIKE za_file.za05       #No.FUN-680131 VARCHAR(30)
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         no           LIKE smx_file.smx04,    #No.FUN-680131 SMALLINT
         fields       LIKE smx_file.smx05,    #No.FUN-680131 VARCHAR(10)
         descr        LIKE za_file.za05       #No.FUN-680131 VARCHAR(30)
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_report        LIKE smx_file.smx01     #No.FUN-680131 VARCHAR(10)
DEFINE   l_line,ms_seq    LIKE type_file.num5,    #No.FUN-680131 SMALLINT
         ms_selected      LIKE type_file.num5,    #No.FUN-680131 SMALLINT
         ms_max,l_i,l_j   LIKE type_file.num5,    #No.FUN-680131 SMALLINT SMALLINT
         ms_k,ms_l,l_ac   LIKE type_file.num5,    #No.FUN-680131 SMALLINT
         g_cnt            LIKE type_file.num5     #No.FUN-680131 SMALLINT
 
FUNCTION q_field(pi_multi_sel,pi_need_cons,ps_report)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_report      LIKE smx_file.smx01          #No.FUN-680131 VARCHAR(10)
 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET ms_report = ps_report
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_field" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161
 
   CALL cl_ui_locale("q_field")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   CALL field_qry_sel()
 
   CLOSE WINDOW w_qry
 
   RETURN ms_selected
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/11/20 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION field_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   l_seq            LIKE type_file.num5        #No.FUN-680131 SMALLINT
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
     
         LET ms_selected=0
         INPUT l_line WITHOUT DEFAULTS FROM linex
            AFTER FIELD linex
               IF l_line IS NULL OR l_line < 1 OR l_line > 3 THEN
                  LET l_line=1
                  NEXT FIELD linex
               END IF
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
         
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
         END INPUT
 
         SELECT MAX(smx04)+1 INTO l_seq
           FROM smx_file
          WHERE smx01 = ms_report AND smx03 = l_line
         IF l_seq IS NULL OR l_seq = 0 THEN
            LET l_seq=1
         END IF
 
         LET ms_seq = l_seq
 
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON za05
                                  FROM s_fields[1].fields
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL field_qry_prep_result_set() 
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
     
      CALL field_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
#     IF (mi_multi_sel) THEN
#        CALL field_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
#     ELSE
         CALL field_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
#     END IF
     
      #放棄前面所做的一切
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET ms_selected = 0
      END IF
      
      #已有看中的, 請將之放入資料庫中, 並做相關的更新
      IF ms_selected THEN
         CALL q_fi(ms_report)
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/11/20 by saki
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION field_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_x       LIKE za_file.za05,       #No.FUN-680131 VARCHAR(40)
            l_max      LIKE type_file.num5      #No.FUN-680131 SMALLINT
 
 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_field', 'za_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT za05", 
                " FROM za_file",
                " WHERE ",ms_cons_where CLIPPED,
                "   AND za01 = 'asmi900' AND za03 ='",g_lang,"'",
                "   AND za02 >= 20 "
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_x
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      LET ma_qry[li_i].no= ''
      LET ma_qry[li_i].fields = lr_x[1,10]
      LET ma_qry[li_i].descr  = lr_x[11,40]
 
      LET li_i = li_i + 1
   END FOREACH
 
   LET l_max = li_i - 1
   CALL SET_COUNT(l_max)
 
   LET ms_max = l_max
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/11/20 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION field_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   CALL ma_qry_tmp.clear()
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/11/20 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION field_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_fields.*
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
#     ON ACTION refresh
#        LET pi_start_index = 1
#        LET li_continue = TRUE
#     
#        EXIT DISPLAY
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION accept
#        CALL field_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      #No.FUN-660161--begin
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end
 
      ON ACTION selected
         LET l_ac = ARR_CURR()
         IF ma_qry_tmp[l_ac].no IS NULL THEN               #選上
            LET ms_selected = ms_selected + 1
            LET ma_qry_tmp[l_ac].no = ms_seq
            LET ms_seq=ms_seq+1
         ELSE							#後悔了
            IF ma_qry_tmp[l_ac].no != (ms_seq-1) THEN
               LET g_cnt = l_ac - ARR_CURR() + 1
               LET ms_k = ma_qry_tmp[l_ac].no
               LET ms_l = 0
               FOR l_i=1 TO ms_max
                  IF ma_qry_tmp[l_i].no IS NULL
                     OR ma_qry_tmp[l_i].no < ms_k THEN
                     CONTINUE FOR
                  END IF
                  LET ma_qry_tmp[l_i].no = ma_qry_tmp[l_i].no - 1
                  LET l_j = l_i - g_cnt + 1
                  IF l_j >= 1 AND l_j <= 7 THEN
                     DISPLAY ma_qry_tmp[l_i].no TO s_fields[l_j].no
                  END IF
                  LET ms_l = ms_l + 1
                  IF ms_l >= ms_selected THEN EXIT FOR END IF
               END FOR
            END IF
            LET ms_selected = ms_selected - 1
            LET ms_seq = ms_seq - 1
            LET ma_qry_tmp[l_ac].no = ''
         END IF
#        DISPLAY ARRAY ma_qry_tmp TO s_fields.*
#           BEFORE DISPLAY
#              EXIT DISPLAY
#           ON IDLE g_idle_seconds
#              CALL cl_on_idle()
#              CONTINUE DISPLAY
#        
#        END DISPLAY
#        CALL cl_set_act_visible("accept,cancel", TRUE)
         MESSAGE ms_selected,' Item(s) Selected'
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
#--NO.MOD-860078 start---
  
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
#--NO.MOD-860078 end------- 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
FUNCTION q_fi(p_report)
   DEFINE   p_report   LIKE smx_file.smx01,       #No.FUN-680131 VARCHAR(10)
            l_see      LIKE type_file.num5        #No.FUN-680131 SMALLINT
 
 
   #取得目前項次
   SELECT MAX(smx02)+1
     INTO l_see
     FROM smx_file
    WHERE smx01 = p_report
   IF l_see IS NULL OR l_see=0 THEN
      LET l_see=1
   END IF
   
   #要將選上的項次一一塞入資料庫中, 各項次依其挑選的順序排列
   LET l_j=0
   LET l_see = l_see - ms_seq + ms_selected
   FOR l_i=1 TO ms_max
       IF ma_qry_tmp[l_i].no IS NULL THEN
          CONTINUE FOR
       END IF
       LET ms_k = l_see + ma_qry_tmp[l_i].no      #項次
       INSERT INTO smx_file(smx01,smx02,smx03,smx04,smx05,smx06,
                             smx07,smxdmy1,smxdmy2)  #No.MOD-470041
                     VALUES(p_report,			#報表代號
       	                    ms_k,			#項次
       	                    l_line,		        #行序
       	                    ma_qry_tmp[l_i].no,         #欄序
       	                    ma_qry_tmp[l_i].fields,     #來源欄位
       	                    '',				#欄位來源
       	                    '',				#欄位長度
       	                    '','')		        #DUMMY
       LET l_j=l_j+1
       IF l_j >= ms_selected THEN
          EXIT FOR
       END IF
   END FOR
END FUNCTION
