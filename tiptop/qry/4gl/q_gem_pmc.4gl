# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name. .: q_gem_pmc.4gl
# Program ver.   : 7.0
# Descriptions.. : asfi510 sfp07查询时要开gem_file及pmc_file的资料
# Date & Author. : 13/06/14 By Carrier
 
DATABASE ds  
 
GLOBALS "../../config/top.global"
 
DEFINE ma_qry           DYNAMIC  ARRAY OF RECORD
                        check    LIKE type_file.chr1,        
                        gem01    LIKE gem_file.gem01,
                        gem02    LIKE gem_file.gem02
                        END RECORD
DEFINE ma_qry_tmp       DYNAMIC  ARRAY OF RECORD
                        check    LIKE type_file.chr1,        
                        gem01    LIKE gem_file.gem01,
                        gem02    LIKE gem_file.gem02
                        END RECORD
 
DEFINE mi_multi_sel     LIKE type_file.num5      #是否需要複選資料(TRUE/FALSE).  
DEFINE mi_need_cons     LIKE type_file.num5      #是否需要CONSTRUCT(TRUE/FALSE). 
DEFINE ms_cons_where    STRING                   #暫存CONSTRUCT區塊的WHERE條件.
DEFINE mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.    
DEFINE ms_default1      STRING     
DEFINE ms_ret1          STRING 
DEFINE l_chr            LIKE type_file.chr1  
 
FUNCTION q_gem_pmc(pi_multi_sel,pi_need_cons,ps_default1)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_default1    STRING

   LET ms_default1 = ps_default1   

   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_gem_pmc" ATTRIBUTE(STYLE="create_qry") 
 
   CALL cl_ui_locale("q_gem_pmc")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("gem01", "red")
   END IF
 
   CALL q_gem_pmc_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
   END IF
END FUNCTION
 
##################################################
# Description        : 畫面顯現與資料的選擇.
# Date & Author : 2004/04/29 by Carrier
# Parameter         : none
# Return         : void
# Memo              :
# Modify         :
##################################################
FUNCTION q_gem_pmc_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.      #No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE.       #No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.      #No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10,       #No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10       #No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5        #No.FUN-680131 SMALLINT
 
   LET l_chr = 'N'
   LET mi_page_count = 100
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         LET ms_cons_where = "1=1"
         
         IF (li_continue) AND (li_reconstruct) AND (l_chr = 'Y') THEN 
           CALL q_gem_pmc_construct()   
         END IF
         
         CALL q_gem_pmc_qry_prep_result_set() 
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
     
      CALL q_gem_pmc_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
      MESSAGE "Total count : " || ma_qry.getLength() || "  Page : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL q_gem_pmc_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL q_gem_pmc_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

FUNCTION q_gem_pmc_construct()
  CLEAR FORM
  CALL ma_qry_tmp.clear()

  CONSTRUCT ms_cons_where ON gem01,gem02
       FROM s_gem_pmc[1].gem01,s_gem_pmc[1].gem02
    
     ON ACTION about         
        CALL cl_about()        
     
     ON ACTION help          
        CALL cl_show_help()  
     
     ON ACTION controlg      
        CALL cl_cmdask()      
     
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT 
  END CONSTRUCT
END FUNCTION 

##################################################
# Description        : 準備查詢畫面的資料集.
# Date & Author : 2004/04/29 by Carrier
# Parameter         : none
# Return        : void
# Memo              :
# Modify        :
##################################################
FUNCTION q_gem_pmc_qry_prep_result_set()
   DEFINE l_filter_cond STRING 
   DEFINE ls_sql        STRING,
          l_sql         STRING,
          ls_where      STRING
   DEFINE li_i          LIKE type_file.num10
   DEFINE lr_qry        RECORD
                        check    LIKE type_file.chr1,        
                        gem01    LIKE gem_file.gem01,
                        gem02    LIKE gem_file.gem02
                        END RECORD

   LET ls_where = cl_replace_str(ms_cons_where,'gem01','pmc01')
   LET ls_where = cl_replace_str(ls_where,'gem02','pmc03')
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_gem_pmc','pmc_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ls_where = ls_where,l_filter_cond
   END IF
   IF cl_null(ls_where) THEN LET ls_where = " 1=1" END IF

   LET l_filter_cond = cl_get_extra_cond_for_qry('q_gem_pmc','gem_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   IF cl_null(ms_cons_where) THEN LET ms_cons_where = " 1=1" END IF

   LET ls_sql = " SELECT 'N',gem01,gem02 ",
                "   FROM gem_file    ",
                "  WHERE gemacti = 'Y' ",
                "    AND ",ms_cons_where,
                " UNION ALL ",
                " SELECT 'N',pmc01,pmc03 ",
                "   FROM pmc_file ",
                " WHERE pmcacti = 'Y' ",
                "   AND ",ls_where
   LET ls_sql=ls_sql CLIPPED," ORDER BY gem01"
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
 
      #判斷是否已達選取上限 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH  
END FUNCTION
 
##################################################
# Description        : 設定查詢畫面的顯現資料.
# Date & Author : 2004/04/29 by Carrier
# Parameter         : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置      #No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置      #No.FUN-680131 INTEGER
# Return        : void
# Memo              :
# Modify        :
##################################################
FUNCTION q_gem_pmc_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,       #No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10       #No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10,       #No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10       #No.FUN-680131 INTEGER
 
 
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
# Description        : 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2004/04/29 by Carrier
# Parameter         : ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置      #No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置      #No.FUN-680131 INTEGER
# Return         : SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo              :
# Modify         :
##################################################
FUNCTION q_gem_pmc_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,       #No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10       #No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,        #No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5        #No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_gem_pmc.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE)                              #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_gem_pmc.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE, APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_gem_pmc.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL q_gem_pmc_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_gem_pmc.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL q_gem_pmc_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL q_gem_pmc_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         LET l_chr = 'Y'
         
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_gem_pmc.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL q_gem_pmc_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL q_gem_pmc_qry_accept(pi_start_index+ARR_CURR()-1)
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
 
##################################################
# Description        : 重設查詢資料關於'check'欄位的值.
# Date & Author : 2004/04/29 by Carrier
# Parameter         : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置      #No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置      #No.FUN-680131 INTEGER
# Return         : void
# Memo              :
# Modify         :
##################################################
FUNCTION q_gem_pmc_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,       #No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10       #No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10,       #No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10       #No.FUN-680131 INTEGER
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
##################################################
# Description        : 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2004/04/29 by Carrier
# Parameter         : ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置      #No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置      #No.FUN-680131 INTEGER
# Return         : SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo              :
# Modify         :
##################################################
FUNCTION q_gem_pmc_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,       #No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10       #No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,        #No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5        #No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_gem_pmc.*
      BEFORE DISPLAY
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
         LET l_chr = 'Y'
         
         EXIT DISPLAY
      ON ACTION accept
         CALL q_gem_pmc_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
     
      ON ACTION qry_string
         CALL cl_qry_string("detail")
  
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2004/04/29 by Carrier
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION q_gem_pmc_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10       #No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description        : 選擇並確認資料.
# Date & Author : 2004/04/29 by Carrier
# Parameter         : pi_sel_index   LIKE type_file.num10    所選擇的資料索引      #No.FUN-680131 INTEGER
# Return         : void
# Memo              :
# Modify         :
##################################################
FUNCTION q_gem_pmc_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10       #No.FUN-680131 INTEGER
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
               CALL lsb_multi_sel.append(ma_qry[li_i].gem01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].gem01 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].gem01 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
