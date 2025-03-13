# Prog. Version..: '5.30.06-13.03.26(00003)'     #
#
# Program name  : q_ogb5.4gl
# Program ver.  : 7.0
# Description   :
# Date & Author : 2012/07/02 #FUN-C60036 by xuxz
# Modify........: No:FUN-CA0084 12/10/19 By xuxz 不是多選開窗資料挑選加條件
# Modify.........: No:MOD-CA0092 12/10/30 By xuxz 多選開窗資料加條件
# Modify.........: No:MOD-CC0049 12/12/11 By suncx 開窗選擇出货单單出货日期年月不能大於發票日期年月
# Modify.........: NO.TQC-D20009 13/02/06 By xujing chenjing 增加欄位:'品名','規格','倉庫編號','倉庫批號'
# Modify.........: No:MOD-D60160 13/06/19 By SunLM 将MOD-CC0049调整为出货单日期不能大于发票录入日期
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
# Modify.........: No:MOD-D70061 13/07/09 By SunLM 未审核的出货单不能选出来开票
# Modify.........: No.MOD-DC0091 13/12/13 By SunLM 非成本仓的出货和销退不能开票


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         oga01    LIKE oga_file.oga01,
         oga02    LIKE oga_file.oga02,
         ogb03    LIKE ogb_file.ogb03,
         ogb04    LIKE ogb_file.ogb04,
        #TQC-D20009---add---str---
         ima02    LIKE ima_file.ima02,
         ima021   LIKE ima_file.ima021,
         ogb09    LIKE ogb_file.ogb09,
         imd02    LIKE imd_file.imd02,
        #TQC-D20009---add---end---
         ogb091   LIKE ogb_file.ogb091,
         ime03    LIKE ime_file.ime03,        #TQC-D20009
         ogb092   LIKE ogb_file.ogb092,       #TQC-D20009
         ogb917   LIKE ogb_file.ogb917,
         ogb60    LIKE ogb_file.ogb60
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,
         oga01        LIKE oga_file.oga01,
         oga02        LIKE oga_file.oga02,
         ogb03        LIKE ogb_file.ogb03,
         ogb04        LIKE ogb_file.ogb04,
        #TQC-D20009---add---str---
         ima02        LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         ogb09        LIKE ogb_file.ogb09,
         imd02        LIKE imd_file.imd02,
        #TQC-D20009---add---end---
         ogb091       LIKE ogb_file.ogb091,
         ime03        LIKE ime_file.ime03,        #TQC-D20009
         ogb092       LIKE ogb_file.ogb092,       #TQC-D20009
         ogb917       LIKE ogb_file.ogb917,
         ogb60        LIKE ogb_file.ogb60
END RECORD
DEFINE   ms_cus       LIKE oga_file.oga03,
         ms_omf05     LIKE omf_file.omf05,
         ms_omf06     LIKE omf_file.omf06,
         ms_omf07     LIKE omf_file.omf07
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.
DEFINE   ms_ret1          STRING    
DEFINE   ms_ret2          STRING
DEFINE   ms_plant         LIKE type_file.chr10        
DEFINE   ms_omf00         LIKE omf_file.omf00
DEFINE   ms_date      LIKE type_file.dat   #MOD-CC0049 add
#FUNCTION q_ogb5(pi_multi_sel,pi_need_cons,ps_cus,ps_omf05,ps_omf06,ps_omf07,ps_plant,ps_omf00)  
FUNCTION q_ogb5(pi_multi_sel,pi_need_cons,ps_cus,ps_omf05,ps_omf06,ps_omf07,ps_plant,ps_omf00,ps_omf03)  #MOD-CC0049 add ps_omf03
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_cus         LIKE oga_file.oga03,
            ps_omf05       LIKE omf_file.omf05,
            ps_omf06       LIKE omf_file.omf06,
            ps_omf07       LIKE omf_file.omf07,
            ps_plant       LIKE type_file.chr10,
            ps_omf00       LIKE omf_file.omf00,
            ps_omf03       LIKE omf_file.omf03    #MOD-CC0049 add 
   DEFINE   l_yy,l_mm       LIKE type_file.num5   #MOD-CC0049 add
   DEFINE   l_flag          LIKE type_file.chr1   #MOD-CC0049 add
   DEFINE   l_bdate,l_edate LIKE type_file.dat    #MOD-CC0049 add
 
   WHENEVER ERROR CONTINUE

   LET g_plant_new = ps_plant

   LET ms_cus    = ps_cus
   LET ms_omf05  = ps_omf05
   LET ms_omf06 = ps_omf06
   LET ms_omf07 = ps_omf07
   LET ms_plant  = ps_plant     
   LET ms_omf00 = ps_omf00
   LET ms_ret1 = ''
   LET ms_ret2 = ''
   #MOD-CC0049 add begin------------------------
   IF NOT cl_null(ps_omf03) THEN 
      #CALL s_yp(ps_omf03) RETURNING l_yy,l_mm #MOD-D60160 mark  
      #CALL s_azm(l_yy,l_mm) RETURNING l_flag,l_bdate,l_edate #MOD-D60160 mark 
      #LET ms_date = l_edate #MOD-D60160 mark 
      LET ms_date = ps_omf03  #MOD-D60160
   END IF 
   #MOD-CC0049 add end--------------------------
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_ogb" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_ogb")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
      CALL cl_set_comp_visible("oga03",FALSE)
   END IF
   CALL cl_set_comp_visible("oga03",FALSE)
   CALL ogb5_qry_sel()
   
   CLOSE WINDOW w_qry
   IF (mi_multi_sel) THEN
      RETURN ms_ret1,'' #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1,ms_ret2 #回傳值(也許有多個).
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb5_qry_sel()
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
            #CONSTRUCT BY NAME ms_cons_where ON oga01,oga02,ogb03,ogb04,ogb091,ogb12,ogb60 
            CONSTRUCT BY NAME ms_cons_where ON oga01,oga02,ogb03,ogb04,ogb09,ogb091,ogb092,ogb917,ogb60   #TQC-D20009 add ogb09,ogb092
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
 
         CALL ogb5_qry_prep_result_set()
         # 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
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
 
      CALL ogb5_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      # 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL ogb5_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL ogb5_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION ogb5_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	
   DEFINE   ls_n       LIKE type_file.num10
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   
            oga01      LIKE oga_file.oga01,
            oga02      LIKE oga_file.oga02,
            ogb03      LIKE ogb_file.ogb03,
            ogb04      LIKE ogb_file.ogb04,
           #TQC-D20009---add---str---
            ima02      LIKE ima_file.ima02,
            ima021     LIKE ima_file.ima021,
            ogb09      LIKE ogb_file.ogb09,
            imd02      LIKE imd_file.imd02,
           #TQC-D20009---add---end---
            ogb091     LIKE ogb_file.ogb091,
            ime03      LIKE ime_file.ime03,        #TQC-D20009
            ogb092     LIKE ogb_file.ogb092,       #TQC-D20009
            ogb917     LIKE ogb_file.ogb917,  
            ogb60      LIKE ogb_file.ogb60
   END RECORD
   DEFINE   l_buf           LIKE oay_file.oayslip
   DEFINE   l_oay11         LIKE oay_file.oay11
   DEFINE   l_omf917   LIKE omf_file.omf917 #MOD-CA0092
   DEFINE   l_sql      STRING  #MOD-DC0091
   DEFINE   l_cnt      LIKE type_file.num5 #MOD-DC0091
   DEFINE l_ogb09  LIKE ogb_file.ogb09 #MOD-DC0091
   DEFINE l_ogb17  LIKE ogb_file.ogb17 #MOD-DC0091
   
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_ogb5', 'ogb_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   LET ls_sql = "SELECT 'N',oga01,oga02,ogb03,ogb04,ima02,ima021,ogb09,imd02,ogb091,ime03,ogb092,ogb917,ogb60",   #TQC-D20009 add ima02,ima021,ogb09,imd02,ime03,ogb092
                "  FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", 
                          cl_get_target_table(g_plant_new,'ogb_file'),     
                "         LEFT OUTER JOIN ima_file ON ogb04 = ima01 ",      #TQC-D20009 add
                "         LEFT OUTER JOIN imd_file ON ogb09 = imd01 ",      #TQC-D20009 add
                "         LEFT OUTER JOIN ime_file ON ogb09 = ime01 AND ogb091 = ime02 ",   #TQC-D20009 add
                "         AND imeacti = 'Y' ",     #FUN-D40103
                " WHERE ",ms_cons_where CLIPPED,
                "   AND oga01 = ogb01",
                "   AND ogb60 < ogb917 ",  
               "   AND ogaconf = 'Y' AND ogapost='Y' ",    #TQC-D20009 cj mark  #MOD-D70061恢復
                "   AND (oga09 = '2' OR oga09 ='3' OR oga09 = '8' OR oga09='A') ", 
                "   AND oga65='N' ",  
                "   AND oga00 IN ('1','4','5','6')",
                "   AND ogaplant = '",ms_plant,"' ",  
                "   AND oga03 = '",ms_omf05 CLIPPED, "'",
                "   AND oga21 = '",ms_omf06 CLIPPED, "'",
                "   AND oga23 = '",ms_omf07 CLIPPED, "'",
                "   AND oga02 <= '",ms_date CLIPPED, "'",  #MOD-CC0049
	            "  ORDER BY oga01,ogb03 "
 
 
   DISPLAY "ls_sql=",ls_sql
   CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql  
   CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
      #MOD-DC0091 add begin-------
      LET l_sql = " SELECT ogb09,ogb17 FROM ",cl_get_target_table(g_plant_new,'ogb_file'), 
                  "  WHERE ogb01 = '",lr_qry.oga01,"'",
                  "  AND   ogb03 = '",lr_qry.ogb03,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
      PREPARE sel_ogb09_pre_1 FROM l_sql
      EXECUTE sel_ogb09_pre_1 INTO l_ogb09,l_ogb17
      IF l_ogb17 ='Y' THEN #多仓储批的出货
         LET l_sql = " SELECT count(*) FROM ",cl_get_target_table(g_plant_new,'ogc_file'),",", cl_get_target_table(g_plant_new,'jce_file'),
                     "  WHERE ogc01 = '",lr_qry.oga01,"'",
                     "  AND   ogc03 = '",lr_qry.ogb03,"'",
                     "  AND   jce02 = ogc09"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
         PREPARE sel_ogc_pre_1 FROM l_sql
         EXECUTE sel_ogc_pre_1 INTO l_cnt
         IF l_cnt > 0 THEN 
            CONTINUE FOREACH 
         END IF 
      ELSE 
         LET l_sql = " SELECT count(*) FROM ",cl_get_target_table(g_plant_new,'jce_file'),
                     "  WHERE jce02 = '",l_ogb09,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
         PREPARE sel_jce_pre_1 FROM l_sql
         EXECUTE sel_jce_pre_1 INTO l_cnt
         IF l_cnt > 0 THEN 
            CONTINUE FOREACH
         END IF 
      END IF               
      #MOD-DC0091 add end---------
      LET ls_n = 0 
      IF mi_multi_sel THEN #FUN-CA0084 add 
         SELECT COUNT(*) INTO ls_n FROM omf_file
          WHERE omf00 = ms_omf00 AND omf11 = lr_qry.oga01
            AND omf12 = lr_qry.ogb03
         IF ls_n >0 THEN CONTINUE FOREACH END IF 
      END IF #FUN-CA0084 add
      #MOD-CA0092-add--str
      LET l_omf917 = 0 
      SELECT SUM(omf917) INTO l_omf917 FROM omf_file
       WHERE omf11 = lr_qry.oga01
         AND omf12 = lr_qry.ogb03
      IF cl_null(l_omf917) THEN LET l_omf917 = 0 END IF 
      IF l_omf917 = lr_qry.ogb917 AND mi_multi_sel THEN
         CONTINUE FOREACH
      END IF
      #MOD-CA0092--add--end
      IF NOT cl_null(lr_qry.oga01) THEN
              CALL s_get_doc_no(lr_qry.oga01) RETURNING l_buf
              LET ls_sql = "SELECT oay11 FROM ",cl_get_target_table(g_plant_new,'oay_file'),
                           " WHERE oayslip='",l_buf,"' "
              CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              					
		      CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql              
              PREPARE sel_oay11_pre FROM ls_sql
              EXECUTE sel_oay11_pre INTO l_oay11
              IF NOT STATUS AND l_oay11<>'Y' THEN
                 CONTINUE FOREACH
              END IF
      END IF
      IF cl_null(lr_qry.oga01) AND g_ooz.ooz19='N' THEN CONTINUE FOREACH
      END IF
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
# Parameter   	. pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION ogb5_qry_set_display_data(pi_start_index, pi_end_index)
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
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               . pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb5_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_continue      LIKE type_file.num5, 
            li_reconstruct   LIKE type_file.num5  
   DEFINE   li_i     LIKE type_file.num10
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ogb.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE,UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb5_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb5_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         CALL ogb5_qry_refresh()
 
         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        
            CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL ogb5_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL ogb5_qry_accept(pi_start_index+ARR_CURR()-1)
         END IF                      
         LET li_continue = FALSE
 
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 
         LET li_continue = FALSE
         LET ms_ret1 = ''
         LET ms_ret2 = ''
 
         EXIT INPUT
 
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
# Description  	: 重設查詢資料關於'check'欄位的值.
# Parameter   	. pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb5_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               . pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb5_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  	
            li_reconstruct   LIKE type_file.num5  
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_ogb.*
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
         CALL ogb5_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 
         LET li_continue = FALSE
 
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON ACTION qry_string
         CALL cl_qry_string("detail")
 
   END DISPLAY
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION ogb5_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Parameter   	. pi_sel_index   LIKE type_file.num10    所選擇的資料索引	
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb5_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].oga01 CLIPPED || "," || ma_qry[li_i].ogb03)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].oga01 CLIPPED || "," || ma_qry[li_i].ogb03)
            END IF
         END IF
      END FOR
      LET ms_ret1 = lsb_multi_sel.toString()
      
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].oga01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].ogb03 CLIPPED
   END IF
END FUNCTION
#FUN-C60036
