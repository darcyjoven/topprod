# Prog. Version..: '5.30.06-13.03.15(00003)'     #
# Pattern name..: q_ime_1.4gl
# Program ver.  : 7.0
# Descriptions..: 視窗多行查詢程式(查詢某檔案的少數欄位,以多行呈現)
#		  指定工廠的庫位查詢
# Date & Author.: 10/10/19 By yinhy  #No.FUN-AA0080
# Modify.........: No:FUN-AA0084 10/11/01 By yinhy 修改MATCHES用法
# Modify.........: No:MOD-D20163 13/3/04 By bart 一頁顯示100筆
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
 
DATABASE ds  #No.FUN-AA0080
 
GLOBALS "../../config/top.global"
 
DEFINE    ma_qry   DYNAMIC ARRAY OF RECORD
          check    LIKE type_file.chr1,  	
         	ime01 LIKE ime_file.ime01,
          imd02 LIKE imd_file.imd02,
          ime02 LIKE ime_file.ime02,
		      ime03 LIKE ime_file.ime03,
      		ime04 LIKE ime_file.ime04,
      		ime05 LIKE ime_file.ime05,
      		ime06 LIKE ime_file.ime06,
      		ime07 LIKE ime_file.ime07
END RECORD
DEFINE    ma_qry_tmp   DYNAMIC ARRAY OF RECORD
          check        LIKE type_file.chr1,  	
         	ime01 LIKE ime_file.ime01,
          imd02 LIKE imd_file.imd02,
          ime02 LIKE ime_file.ime02,
		      ime03 LIKE ime_file.ime03,
      		ime04 LIKE ime_file.ime04,
      		ime05 LIKE ime_file.ime05,
      		ime06 LIKE ime_file.ime06,
      		ime07 LIKE ime_file.ime07
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_ware          LIKE imd_file.imd01
DEFINE   ms_ret1          STRING 
DEFINE   ms_type          LIKE type_file.chr2     
DEFINE   ms_plant         LIKE type_file.chr10 
DEFINE   ms_ime05         LIKE ime_file.ime05
DEFINE   ms_ime06         LIKE ime_file.ime06
DEFINE   ms_ime12         LIKE ime_file.ime12
DEFINE   l_chr            LIKE type_file.chr1  
 
FUNCTION q_ime_1(pi_multi_sel,pi_need_cons,ps_default1,p_ware,p_type,p_plant,p_ime05,p_ime06,p_ime12)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            p_ware         LIKE imd_file.imd01,
	          p_type         LIKE type_file.chr2,   #No.FUN-680131 VARCHAR(1)
            ps_default1    STRING,   
            p_plant        LIKE type_file.chr10,
            p_ime05        LIKE ime_file.ime05,
            p_ime06        LIKE ime_file.ime06,
            p_ime12        LIKE ime_file.ime12
   LET ms_default1 = ps_default1
   LET ms_ware = p_ware
   LET ms_type = p_type
   LET ms_plant = p_plant
   IF cl_null(ms_plant) THEN
      LET ms_plant = g_plant
   END IF
   LET ms_ime05 = p_ime05
   LET ms_ime06 = p_ime06
   LET ms_ime12 = p_ime12
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_ime_1" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_ime_1")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("ime02", "red")
   END IF
 
   CALL q_ime_1_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2004/04/29 by Carrier
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION q_ime_1_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
   LET l_chr = 'N'
   #LET mi_page_count = 20  #MOD-D20163
   LET mi_page_count = 100  #MOD-D20163
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         LET ms_cons_where = "1=1"
         
         IF (li_continue) AND (li_reconstruct) AND (l_chr = 'Y') THEN 
           CALL q_ime_1_construct()   
         END IF
         
         CALL q_ime_1_qry_prep_result_set() 
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
     
      CALL q_ime_1_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
      MESSAGE "Total count : " || ma_qry.getLength() || "  Page : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL q_ime_1_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL q_ime_1_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

FUNCTION q_ime_1_construct()
  CLEAR FORM
  CALL ma_qry_tmp.clear()
      		
  CONSTRUCT ms_cons_where ON ime01,imd02,ime02,ime03,ime04,ime05,ime06,ime07
       FROM s_ime_1[1].ime01,s_ime_1[1].imd02,s_ime_1[1].ime02,s_ime_1[1].ime03,
            s_ime_1[1].ime04,s_ime_1[1].ime05,s_ime_1[1].ime06,s_ime_1[1].ime07
    
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
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2004/04/29 by Carrier
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION q_ime_1_qry_prep_result_set()
   DEFINE l_filter_cond STRING 
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10, 	
            l_begin_key LIKE imd_file.imd01
   DEFINE   lr_qry   RECORD
             check    LIKE type_file.chr1,   	
         	   ime01 LIKE ime_file.ime01,
             imd02 LIKE imd_file.imd02,
             ime02 LIKE ime_file.ime02,
		         ime03 LIKE ime_file.ime03,
      		   ime04 LIKE ime_file.ime04,
      		   ime05 LIKE ime_file.ime05,
      		   ime06 LIKE ime_file.ime06,
      		   ime07 LIKE ime_file.ime07
   END RECORD
   DEFINE   l_n      LIKE type_file.num10 	
 
   LET l_begin_key = ' '
   
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_ime_1', 'imd_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   
   LET ls_sql = "SELECT 'N',ime01,imd02,ime02,ime03,ime04,ime05,ime06,ime07",                         
                 " FROM ",cl_get_target_table(ms_plant,'ime_file'),
                 ",",cl_get_target_table(ms_plant,'imd_file'),
                 " WHERE ime01=imd01 AND ",ms_cons_where,
                 " AND imdacti='Y'",
                 " AND imeacti = 'Y'"     #FUN-D40103    
   
   LET ls_where = ls_where CLIPPED," AND imd20 ='",ms_plant,"'"  
   
   IF NOT cl_null(ms_ware) THEN
      LET ls_where = ls_where CLIPPED," AND ime01 = '",ms_ware,"'"
   END IF
#No.FUN-AA0084  --Begin   
#   IF NOT cl_null(ms_type) AND ms_type <> '*' THEN
#     LET ls_where = ls_where CLIPPED," AND imd04 MATCHES '[",ms_type,"]'"
#   END IF
   IF NOT cl_null(ms_type) AND ms_type <> '*' AND ms_type <> 'WS' AND ms_type <> 'SW' THEN      #若指定倉庫屬性
      LET ls_where = ls_where CLIPPED," AND ime04 = '",ms_type,"'"
   END IF   
#No.FUN-AA0084  --End
   IF NOT cl_null(ms_ime05) THEN  
     LET ls_where = ls_where CLIPPED," AND ime05 ='",ms_ime05,"'"
   END IF 
   
   IF NOT cl_null(ms_ime06) THEN  
     LET ls_where = ls_where CLIPPED," AND ime06 ='",ms_ime06,"'"
   END IF 
   IF NOT cl_null(ms_ime12) THEN  
     LET ls_where = ls_where CLIPPED," AND ime12 ='",ms_ime12,"'"
   END IF 
 
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY ime10 "
 
   DISPLAY "ls_sql=",ls_sql
 	 CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql        
   CALL cl_parse_qry_sql(ls_sql,ms_plant) RETURNING ls_sql 
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
# Date & Author : 2004/04/29 by Carrier
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION q_ime_1_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2004/04/29 by Carrier
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION q_ime_1_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ime_1.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE)                              #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ime_1.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE, APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_ime_1.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL q_ime_1_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ime_1.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL q_ime_1_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL q_ime_1_qry_refresh()
     
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
            CALL GET_FLDBUF(s_ime_1.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL q_ime_1_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL q_ime_1_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : 2004/04/29 by Carrier
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION q_ime_1_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2004/04/29 by Carrier
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION q_ime_1_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_ime_1.*
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
         CALL q_ime_1_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION q_ime_1_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2004/04/29 by Carrier
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION q_ime_1_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].ime02 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].ime02 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].ime02 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
