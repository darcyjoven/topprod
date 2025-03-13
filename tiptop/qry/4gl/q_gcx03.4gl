# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Program name   : q_gcx03.sql
# Program ver.   : 
# Description    : 簽核代號開窗查詢
# Date & Author  : 2012/01/05 by downheal
# Memo           : 
# Modify.........: No.FUN-BB0127 12/01/05 By Downheal 簽核代號開窗，並組合簽核關卡
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         CHECK       LIKE type_file.chr1, 
         gdx01       LIKE gdx_file.gdx01,       #簽核代號
         approval    LIKE type_file.chr1000     #簽核關卡         
END RECORD

DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         CHECK       LIKE type_file.chr1, 
         gdx01       LIKE gdx_file.gdx01,       #簽核代號
         approval    LIKE type_file.chr1000     #簽核關卡  
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_default1      STRING  
DEFINE   ms_ret1          STRING
 
FUNCTION q_gcx03(pi_multi_sel,pi_need_cons,ps_default1)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_default1    STRING
 
   WHENEVER ERROR CONTINUE
 
   LET ms_default1 = ps_default1 
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_gcx03" ATTRIBUTE(STYLE="create_qry") #No.FUN-BB0127
 
   CALL cl_ui_locale("q_gcx03")
 
   #LET mi_multi_sel = pi_multi_sel
   #LET mi_need_cons = pi_need_cons
   LET mi_multi_sel = FALSE
   LET mi_need_cons = pi_need_cons   
 
   # 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("gcx03", "red")
   END IF
 
   CALL gcx03_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2011/12/28 by downheal
# Parameter   	: none
# Return   	: void
# Memo      :
# Modify   	:
##################################################
FUNCTION gcx03_qry_sel()
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
            #CONSTRUCT ms_cons_where ON gcx03, approval
                                  #FROM s_gcx[1].gcx03, s_gcx[1].approval
            CONSTRUCT ms_cons_where ON gdx01
                                  FROM s_gcx[1].gdx01                 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL gcx03_qry_prep_result_set() 
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
     
      CALL gcx03_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
     
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL gcx03_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL gcx03_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description   : 準備查詢畫面的資料集.
# Date & Author : downheal
# Parameter   	: none
# Return       : void
# Memo        	:
# Modify       :
##################################################
FUNCTION gcx03_qry_prep_result_set()
   #DEFINE l_filter_cond STRING
   DEFINE   ls_sql     STRING
            #ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,
            gdx01      LIKE gdx_file.gdx01,       #簽核代號
            approval   LIKE type_file.chr1000     #簽核關卡 
   END RECORD

   LET ls_sql = "SELECT distinct 'N',gdx01,'' ",     
                " FROM gdx_file",
                " WHERE ",ms_cons_where
                
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
      CALL q_gcx03_change(lr_qry.gdx01) RETURNING lr_qry.approval      
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH

END FUNCTION
 
##################################################
# Description   : 設定查詢畫面的顯現資料.
# Date & Author : 2012/01/05 by downheal
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#              : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return       : void
# Memo        	:
# Modify       :
##################################################
FUNCTION gcx03_qry_set_display_data(pi_start_index, pi_end_index)
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
 
##################################################
# Description   : 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2012/01/05 by downheal
# Parameter   	 : ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	    : SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	 :
# Modify   	    :
##################################################
FUNCTION gcx03_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5

   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_gcx.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_gcx.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL gcx03_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_gcx.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL gcx03_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL gcx03_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         #IF ARR_CURR()>0 THEN
            #CALL GET_FLDBUF(s_gcx.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            #CALL gcx03_qry_reset_multi_sel(pi_start_index, pi_end_index)
            #CALL gcx03_qry_accept(pi_start_index+ARR_CURR()-1)
         #ELSE
            #LET ms_ret1 = NULL
         #END IF
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
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
# Description   : 重設查詢資料關於'check'欄位的值.
# Date & Author : 2012/01/05 by downheal
# Parameter   	 : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	    : void
# Memo        	 :
# Modify   	    :
##################################################
FUNCTION gcx03_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Description   : 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2012/01/05 by downheal
# Parameter   	 : ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	    : SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	 :
# Modify   	    :
##################################################
FUNCTION gcx03_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5 
 
   DISPLAY ARRAY ma_qry_tmp TO s_gcx.*
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
         CALL gcx03_qry_accept(pi_start_index+ARR_CURR()-1)
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
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2012/01/05 by downheal
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION gcx03_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description   : 選擇並確認資料.
# Date & Author : 2012/01/05 by downheal
# Parameter   	 : pi_sel_index   LIKE type_file.num10    所選擇的資料索引
# Return   	    : void
# Memo        	 :
# Modify   	    :
##################################################
FUNCTION gcx03_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].gdx01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].gdx01 CLIPPED)
            END IF
         END IF    
      END FOR

      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].gdx01 CLIPPED
   END IF
END FUNCTION

FUNCTION q_gcx03_change(gdx01)   #No.FUN-BB0127
   DEFINE   gdx01        LIKE gdx_file.gdx01,             
            approval     LIKE type_file.chr1000,  #簽核關卡 
            l_sql        STRING,
            l_cnt        LIKE type_file.num5
   DEFINE   l_approval   LIKE type_file.chr1000   #暫存簽核關卡值
   DEFINE   l_approval_string   STRING            #暫存將char轉為string之值已做字串處理
   DEFINE   l_length     LIKE type_file.num5            
    
    IF NOT cl_null(gdx01)  THEN
    LET l_sql = "SELECT gdx04 ",
               " FROM gdx_file ",
               " WHERE gdx_file.gdx01 ='",gdx01,"' AND gdx_file.gdx03 ='", g_lang, "' ",           #單身
               " ORDER BY gdx02"

    PREPARE approval_pb FROM l_sql
    DECLARE approval_curs CURSOR FOR approval_pb

    LET l_cnt = 1
    
    FOREACH approval_curs INTO approval   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_approval = l_approval CLIPPED,approval,","     #每一個職稱要用一個逗號隔開
       LET l_cnt = l_cnt+ 1
    END FOREACH

    LET l_approval_string = l_approval
    LET l_length = l_approval_string.getLength()
    LET l_approval_string = l_approval_string.subString(1,l_length-1)   #用來去除最後一個職稱後面的逗號
    LET l_approval = l_approval_string    
    END IF
    
    RETURN l_approval
END FUNCTION
