# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Program name  : q_short_qty.4gl
# Description   : 工單查詢
# Date & Author : 2009/04/08 by dongbg (FUN-940039)
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-980025 09/10/09 By dxfwo hardcode的部分修改
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:FUN-A60028 10/09/10 By lilingyu 平行工藝
# Modify.........: No:TQC-B60307 11/06/23 By jan 參數沒勾選走平行工藝，不需要show製程段和製程序
# Modify.........: No:MOD-C10002 12/01/02 By ck2yuan 將 ms_ret1~7預設給NULL
# Modify.........: No:CHI-C70046 12/08/28 By bart 不顯示sfa061改顯示sfa06
# Modify.........: No:FUN-D60056 13/06/17 By lixh1 增加全選/全部不選按鈕

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qty   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         sfb01    LIKE sfb_file.sfb01,
         sfb13    LIKE sfb_file.sfb13,
         sfb05    LIKE sfb_file.sfb05,
#FUN-A60028 --begin--         
         sfa012   LIKE sfa_file.sfa012,
         sfa013   LIKE sfa_file.sfa013,  
#FUN-A60028 --end--           
         sfa03    LIKE sfa_file.sfa03,
         sfa08    LIKE sfa_file.sfa08,
         sfa12    LIKE sfa_file.sfa12,
         sfa27    LIKE sfa_file.sfa27,
         sfa28    LIKE sfa_file.sfa28,
        short_qty LIKE sfa_file.sfa07,
         #sfa061   LIKE sfa_file.sfa061,  #CHI-C70046 
         sfa06    LIKE sfa_file.sfa06,    #CHI-C70046 
         sfa062   LIKE sfa_file.sfa062,
         sfa063   LIKE sfa_file.sfa063,
         sfa064   LIKE sfa_file.sfa064,
         sfa065   LIKE sfa_file.sfa065,
         sfa066   LIKE sfa_file.sfa066,
         sfb04    LIKE sfb_file.sfb04,
         sfb08    LIKE sfb_file.sfb08,
         sfb081   LIKE sfb_file.sfb081,
         sfb09    LIKE sfb_file.sfb09,
         sfb94    LIKE sfb_file.sfb94       
END RECORD
DEFINE   ma_qty_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         sfb01    LIKE sfb_file.sfb01,
         sfb13    LIKE sfb_file.sfb13,
         sfb05    LIKE sfb_file.sfb05,
#FUN-A60028 --begin--         
         sfa012   LIKE sfa_file.sfa012,
         sfa013   LIKE sfa_file.sfa013,  
#FUN-A60028 --end--           
         sfa03    LIKE sfa_file.sfa03,
         sfa08    LIKE sfa_file.sfa08,
         sfa12    LIKE sfa_file.sfa12,
         sfa27    LIKE sfa_file.sfa27,
         sfa28    LIKE sfa_file.sfa28,
        short_qty LIKE sfa_file.sfa07,
         #sfa061   LIKE sfa_file.sfa061,  #CHI-C70046 
         sfa06    LIKE sfa_file.sfa06,    #CHI-C70046 
         sfa062   LIKE sfa_file.sfa062,
         sfa063   LIKE sfa_file.sfa063,
         sfa064   LIKE sfa_file.sfa064,
         sfa065   LIKE sfa_file.sfa065,
         sfa066   LIKE sfa_file.sfa066,
         sfb04    LIKE sfb_file.sfb04,
         sfb08    LIKE sfb_file.sfb08,
         sfb081   LIKE sfb_file.sfb081,
         sfb09    LIKE sfb_file.sfb09,
         sfb94    LIKE sfb_file.sfb94         
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   ms_where         STRING                  #外部傳入的where條件
DEFINE   ms_type          LIKE type_file.chr1     #外部傳入的對欠料量的控制
                                                  #1.欠料量>0 2.欠料量<0 3.欠料量=0 4.不考慮欠料量
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_default1      STRING     
DEFINE   ms_default2      STRING     
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_ret2          LIKE sfa_file.sfa03
DEFINE   ms_ret3          LIKE sfa_file.sfa08
DEFINE   ms_ret4          LIKE sfa_file.sfa12
DEFINE   ms_ret5          LIKE sfa_file.sfa27
DEFINE   ms_ret6          LIKE sfa_file.sfa012    #FUN-A60028 
DEFINE   ms_ret7          LIKE sfa_file.sfa013    #FUN-A60028 
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpos

FUNCTION short_qty2(pi_multi_sel,pi_need_cons,ps_default1,ps_default2,ps_where,ps_type)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING,
            ps_default2    STRING,
            ps_where       STRING,
            ps_type        LIKE type_file.chr1
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
 
   LET ms_ret1 = NULL    #MOD-C10002 add
   LET ms_ret2 = NULL    #MOD-C10002 add
   LET ms_ret3 = NULL    #MOD-C10002 add
   LET ms_ret4 = NULL    #MOD-C10002 add
   LET ms_ret5 = NULL    #MOD-C10002 add
   LET ms_ret6 = NULL    #MOD-C10002 add
   LET ms_ret7 = NULL    #MOD-C10002 add
 
   OPEN WINDOW short_qty_qry WITH FORM "qry/42f/q_short_qty" ATTRIBUTE(STYLE="create_qry") 
 
   CALL cl_ui_locale("q_short_qty")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   LET ms_where = ps_where
   LET ms_type  = ps_type
 
   ----若外部沒有傳入條件,默認 ' 1=1'----
   IF cl_null(ms_where) THEN
      LET ms_where = ' AND 1=1' 
   END IF
 
   ----若外部沒有傳入欠料量控制,默認不考慮欠料量----
   IF cl_null(ms_type) THEN
      LET ms_type = '4' 
   END IF
 
   CALL cl_set_comp_visible("sfa012,sfa013",g_sma.sma541='Y')    #TQC-B60307

   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko :
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("sfb01", "red")
   END IF
   CALL short_qty_qry_sel()
   CLOSE WINDOW short_qty_qry
   
   IF mi_multi_sel=2 THEN
      RETURN ms_ret1,ms_ret3,ms_ret5 #複選資料只能回傳一個欄位的組合字串.
      
   END IF 
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1,ms_ret3,ms_ret5  #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1,ms_ret6,ms_ret5   #回傳值(也許有多個).  #FUN-A60028 add ms_ret6,ms_ret7
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION short_qty_qry_sel()
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
            CONSTRUCT ms_cons_where ON sfb01,sfb13,sfb05,sfa012,sfa013,sfa03,sfa08,sfa12,sfa27,sfa28, #FUN-A60028 add sfa012,sfa013  
                                       sfa06,sfa062,sfa063,sfa064,sfa065,sfa066,  #CHI-C70046 sfa061 -> sfa06
                                       sfb04,sfb08,sfb081,sfb09,sfb94                                            
                                  FROM s_short_qty[1].sfb01,s_short_qty[1].sfb13,s_short_qty[1].sfb05,
                                       s_short_qty[1].sfa012,s_short_qty[1].sfa013,         #FUN-A60028                                
                                       s_short_qty[1].sfa03,s_short_qty[1].sfa08,s_short_qty[1].sfa12,
                                       s_short_qty[1].sfa27,s_short_qty[1].sfa28,
                                       s_short_qty[1].sfa06,s_short_qty[1].sfa062,  #CHI-C70046 sfa061 -> sfa06
                                       s_short_qty[1].sfa063,s_short_qty[1].sfa064,
                                       s_short_qty[1].sfa065,s_short_qty[1].sfa066,
                                       s_short_qty[1].sfb04,
                                       s_short_qty[1].sfb08,s_short_qty[1].sfb081,s_short_qty[1].sfb09,
                                       s_short_qty[1].sfb94                                             
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL short_qty_qry_prep_result_set() 
         # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qty.getLength()
         END IF
         # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
         IF (mi_page_count >= ma_qty.getLength()) THEN
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
     
      IF (li_end_index > ma_qty.getLength()) THEN
         LET li_end_index = ma_qty.getLength()
      END IF
     
      CALL short_qty_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qty.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel=1) THEN
         CALL short_qty_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL short_qty_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION short_qty_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING
   DEFINE   li_i     LIKE type_file.num10
   DEFINE   lr_qty   RECORD
            check    LIKE type_file.chr1,
            sfb01    LIKE sfb_file.sfb01,
            sfb13    LIKE sfb_file.sfb13,
            sfb05    LIKE sfb_file.sfb05,
#FUN-A60028 --begin--         
         sfa012   LIKE sfa_file.sfa012,
         sfa013   LIKE sfa_file.sfa013,  
#FUN-A60028 --end--             
            sfa03    LIKE sfa_file.sfa03,
            sfa08    LIKE sfa_file.sfa08,
            sfa12    LIKE sfa_file.sfa12,
            sfa27    LIKE sfa_file.sfa27,
            sfa28    LIKE sfa_file.sfa28,
        short_qty    LIKE sfa_file.sfa07,
            #sfa061   LIKE sfa_file.sfa061,  #CHI-C70046
            sfa06    LIKE sfa_file.sfa06,    #CHI-C70046
            sfa062   LIKE sfa_file.sfa062,
            sfa063   LIKE sfa_file.sfa063,
            sfa064   LIKE sfa_file.sfa064,
            sfa065   LIKE sfa_file.sfa065,
            sfa066   LIKE sfa_file.sfa066,
            sfb04    LIKE sfb_file.sfb04,
            sfb08    LIKE sfb_file.sfb08,
            sfb081   LIKE sfb_file.sfb081,
            sfb09    LIKE sfb_file.sfb09,
            sfb94    LIKE sfb_file.sfb94             
   END RECORD
#DEFINE l_sfa03       LIKE sfa_file.sfa03      
#DEFINE l_sfa08       LIKE sfa_file.sfa08 
#DEFINE l_sfa12       LIKE sfa_file.sfa12 
DEFINE l_short_qty   LIKE sfa_file.sfa06
#DEFINE l_sfa012      LIKE sfa_file.sfa012   #FUN-A50066 add    #FUN-A60028 mark
#DEFINE l_sfa013      LIKE sfa_file.sfa013   #FUN-A50066 add    #FUN-A60028 mark
 
   IF cl_null(ms_cons_where) THEN
      LET ms_cons_where = ' 1=1'
   END IF
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_short_qty', 'sfb_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',sfb01,sfb13,sfb05,sfa012,sfa013,sfa03,sfa08,sfa12,sfa27,sfa28,'',", #FUN-A60028 add sfa012,sfa013
                "           sfa06,sfa062,sfa063,sfa064,sfa065,sfa066,",  #CHI-C70046 sfa061 -> sfa06
#                "           sfb04,sfb08,sfb081,sfb09,sfb94,sfa012,sfa013",  #FUN-A50066 mod #FUN-A60028	 
                 "           sfb04,sfb08,sfb081,sfb09,sfb94",                                #FUN-A60028	
                "  FROM sfb_file,sfa_file",
                " WHERE sfa01 = sfb01 ", #AND sfb04 IN ('2','3','4','5','6') ",
               #"   AND sfb87 <> 'X' AND ",ms_cons_where CLIPPED,ms_where CLIPPED,
                "   AND ",ms_cons_where CLIPPED,ms_where CLIPPED,
                " ORDER BY sfb01 "
 
  ##NO.FUN-980025 GP5.2 add--begin						
   IF (NOT mi_multi_sel ) THEN						
        CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql						
   END IF						
  ##NO.FUN-980025 GP5.2 add--end
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qty.getLength() TO 1 STEP -1
      CALL ma_qty.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
#   FOREACH lcurs_qry INTO lr_qty.*,l_sfa012,l_sfa013  #FUN-A50066 mod   #,l_sfa03,l_sfa08,l_sfa12   #FUN-A60028 mark
    FOREACH lcurs_qry INTO lr_qty.*                                                                  #FUN-A60028 mark
      #判斷欠料量
      CALL s_shortqty(lr_qty.sfb01,lr_qty.sfa03,lr_qty.sfa08,lr_qty.sfa12,lr_qty.sfa27,
#                      l_sfa012,l_sfa013)   #FUN-A50066 add  #FUN-A60028 mark
                       lr_qty.sfa012,lr_qty.sfa013)          #FUN-A60028 
           RETURNING l_short_qty
      IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF  
      LET lr_qty.short_qty = l_short_qty
      CASE ms_type
         WHEN '1'      #欠料量>0 
           IF l_short_qty <=0 THEN CONTINUE FOREACH END IF
         WHEN '2'      #欠料量<0 
           IF l_short_qty >=0 THEN CONTINUE FOREACH END IF
         WHEN '3'      #欠料量=0 
           IF l_short_qty !=0 THEN CONTINUE FOREACH END IF
         OTHERWISE EXIT CASE 
      END CASE
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      LET ma_qty[li_i].* = lr_qty.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION short_qty_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = ma_qty_tmp.getLength() TO 1 STEP -1
      CALL ma_qty_tmp.deleteElement(li_i)
   END FOR
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qty_tmp[li_j+1].* = ma_qty[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qty_tmp.getLength())
END FUNCTION
 
##################################################
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION short_qty_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   INPUT ARRAY ma_qty_tmp WITHOUT DEFAULTS FROM s_short_qty.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) 
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_ecd.check) RETURNING ma_qty_tmp[ARR_CURR()].check
         CALL short_qty_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ecd.check) RETURNING ma_qty_tmp[ARR_CURR()].check
         CALL short_qty_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qty.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL short_qty_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_ecd.check) RETURNING ma_qty_tmp[ARR_CURR()].check
            CALL short_qty_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL short_qty_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
            LET ms_ret2 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qty),'','')
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
      ON ACTION qry_string
         CALL cl_qry_string("detail")
 
      ON ACTION selectall
         FOR li_i = 1 TO ma_qty_tmp.getLength()
             LET ma_qty_tmp[li_i].check = "Y"
         END FOR
 
      ON ACTION select_none
         FOR li_i = 1 TO ma_qty_tmp.getLength()
             LET ma_qty_tmp[li_i].check = "N"
         END FOR
 
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION short_qty_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qty[li_i].check = ma_qty_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION short_qty_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qty_tmp TO s_short_qty.*
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
         IF ((pi_start_index + mi_page_count) <= ma_qty.getLength()) THEN
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
         CALL short_qty_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qty),'','')
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
      ON ACTION qry_string
         CALL cl_qry_string("detail")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2003/09/22 by Winny
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION short_qty_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qty.getLength()
      LET ma_qty[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION short_qty_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            lsb_multi_sel2   base.StringBuffer,
            lsb_multi_sel3   base.StringBuffer, #darcy:2022/06/15 add
            li_i            LIKE type_file.num10  	#No.FUN-680131 INTEGER
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
      LET lsb_multi_sel2 = base.StringBuffer.create()
      LET lsb_multi_sel3 = base.StringBuffer.create() #darcy:2022/06/15 add
      
      FOR li_i = 1 TO ma_qty.getLength()
         IF (ma_qty[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
            #  CALL lsb_multi_sel.append(ma_qty[li_i].sfb01 CLIPPED)          #FUN-D60056 mark
               CALL lsb_multi_sel.append(ma_qty[li_i].sfa03 CLIPPED)          #FUN-D60056
               CALL lsb_multi_sel2.append(ma_qty[li_i].sfa08 CLIPPED)
               CALL lsb_multi_sel3.append(ma_qty[li_i].sfa27 CLIPPED) #darcy:2022/06/15 add
              # LET ms_ret3 = ma_qty[li_i].sfa08 CLIPPED
            ELSE
            #  CALL lsb_multi_sel.append("|" || ma_qty[li_i].sfb01 CLIPPED)   #FUN-D60056 mark
               CALL lsb_multi_sel.append("|" || ma_qty[li_i].sfa03 CLIPPED)   #FUN-D60056
               CALL lsb_multi_sel2.append(ma_qty[li_i].sfa08 CLIPPED)
               CALL lsb_multi_sel3.append(ma_qty[li_i].sfa27 CLIPPED) #darcy:2022/06/15 add
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
      let ms_ret5 = lsb_multi_sel3.toString() #darcy:2022/06/15
      LET ms_ret3 = lsb_multi_sel2.toString()
   ELSE
      LET ms_ret1 = ma_qty[pi_sel_index].sfb01 CLIPPED
      LET ms_ret2 = ma_qty[pi_sel_index].sfa03 CLIPPED
      LET ms_ret3 = ma_qty[pi_sel_index].sfa08 CLIPPED
      LET ms_ret4 = ma_qty[pi_sel_index].sfa12 CLIPPED
      LET ms_ret5 = ma_qty[pi_sel_index].sfa27 CLIPPED
      LET ms_ret6 = ma_qty[pi_sel_index].sfa012 CLIPPED   #FUN-A60028 add
      LET ms_ret7 = ma_qty[pi_sel_index].sfa013 CLIPPED   #FUN-A60028 add          
   END IF
END FUNCTION
#FUN-940039
