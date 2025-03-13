# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#{
# Program name  : q_ogb4.4gl
# Program ver.  : 7.0
# Description   :
# Date & Author : 2009/07/14 #FUN-960140 by lutingting 
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
#}
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定 
# Modify.........: No.FUN-9A0093 09/11/01 By lutingting增加參數PLANT 
# Modify.........: No.FUN-9C0013 09/12/03 By lutingting繼續處理FUN-9A0093問題
# Modify.........: No.FUN-9C0041 09/12/15 By lutingting 跨庫要去實體DB抓取資料
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-B40214 11/04/28 By yinhy 开窗选择一笔数据，会带出多笔
# Modify.........: No:FUN-BB0083 11/12/19 By xujing 增加數量欄位小數取位
# Modify.........: No.FUN-C90078 12/09/20 By minpp omb38='2',INSERT omb_file 前，抓取omb33，omb331的值
# Modify.........: No.FUN-D10101 13/01/22 By lujh axrt300單身新增已開票數量欄位，賦默認值0

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         oga01    LIKE oga_file.oga01,
         oga02    LIKE oga_file.oga02,
         ogb03    LIKE ogb_file.ogb03,
         ogb04    LIKE ogb_file.ogb04,
         ogb091   LIKE ogb_file.ogb091,
         ogb917   LIKE ogb_file.ogb917,
         ogb60    LIKE ogb_file.ogb60
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,
         oga01        LIKE oga_file.oga01,
         oga02        LIKE oga_file.oga02,
         ogb03        LIKE ogb_file.ogb03,
         ogb04        LIKE ogb_file.ogb04,
         ogb091       LIKE ogb_file.ogb091,
         ogb917       LIKE ogb_file.ogb917,
         ogb60        LIKE ogb_file.ogb60
END RECORD
DEFINE   ms_cus       LIKE oga_file.oga03,
         ms_oma01     LIKE oma_file.oma01,
         #ms_omaplant     LIKE oma_file.omaplant,   #FUN-960140 090824 mark
         ms_oma66     LIKE oma_file.oma66,          #FUN-960140 090824 add
         ms_oma213    LIKE oma_file.oma213,
         ms_oma211    LIKE oma_file.oma211,
         ms_oma24     LIKE oma_file.oma24,
         ms_oma58     LIKE oma_file.oma58,
         ms_omb03     LIKE omb_file.omb03,
         ms_omb12     LIKE omb_file.omb12,
         ms_oma00     LIKE oma_file.oma00,
         ms_oma02     LIKE oma_file.oma02
DEFINE   mr_ogb       RECORD LIKE ogb_file.*,
         mr_omb       RECORD LIKE omb_file.*
DEFINE   ms_oma08     LIKE oma_file.oma08    
DEFINE   ms_oma68     LIKE oma_file.oma68    
DEFINE   ms_oma21     LIKE oma_file.oma21    
DEFINE   ms_oma23     LIKE oma_file.oma23      
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.
DEFINE   ms_dbs           LIKE type_file.chr21     #FUN-9A0093 
DEFINE   ms_plant         LIKE type_file.chr10     #FUN-9A0093   

FUNCTION q_ogb4(pi_multi_sel,pi_need_cons,ps_cus,ps_oma01,ps_oma213,ps_oma211,ps_oma24,ps_oma58,ps_oma00,ps_oma02,ps_plant)  #FUN-9A0093 add plant 
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_cus         LIKE oga_file.oga03,
            ps_oma01       LIKE oma_file.oma01,
            ps_oma213      LIKE oma_file.oma213,
            ps_oma211      LIKE oma_file.oma211,
            ps_oma24       LIKE oma_file.oma24,
            ps_oma58       LIKE oma_file.oma58,
            ps_oma00       LIKE oma_file.oma00,
            ps_oma02       LIKE oma_file.oma02
            ,ps_plant      LIKE type_file.chr10   #FUN-9A0093
 
   WHENEVER ERROR CONTINUE

   #FUN-9A0093--add--str-
   #IF cl_null(ps_plant) THEN  #FUN-A50102
   #   LET ms_dbs = NULL
   #ELSE
      LET g_plant_new = ps_plant
      #FUN-9C0041--mod--str--
      #CALL s_getdbs()
      #LET ms_dbs = g_dbs_new
   #    CALL s_gettrandbs()
   #    LET ms_dbs = g_dbs_tra
      #FUN-9C0041--mod--end
   #END IF  
   #FUN-9A0093--add--end

   LET ms_cus    = ps_cus
   LET ms_oma01  = ps_oma01
   LET ms_oma213 = ps_oma213
   LET ms_oma211 = ps_oma211
   LET ms_oma24  = ps_oma24
   LET ms_oma58  = ps_oma58
   LET ms_oma00  = ps_oma00
   LET ms_oma02  = ps_oma02
   LET ms_oma08  = NULL
   LET ms_oma68  = NULL 
   LET ms_oma21  = NULL 
   LET ms_oma23  = NULL 
   LET ms_plant  = ps_plant     #FUN-9A0093

   OPEN WINDOW w_qry WITH FORM "qry/42f/q_ogb" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_ogb")
 
   LET mi_multi_sel = TRUE
   LET mi_need_cons = pi_need_cons
 
   CALL ogb4_qry_sel()
 
   CLOSE WINDOW w_qry
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb4_qry_sel()
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
            CONSTRUCT BY NAME ms_cons_where ON oga01,oga02,ogb03,ogb04,ogb091,ogb917,ogb60 
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
 
         CALL ogb4_qry_prep_result_set()
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
 
      CALL ogb4_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      # 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL ogb4_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL ogb4_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION ogb4_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   
            oga01      LIKE oga_file.oga01,
            oga02      LIKE oga_file.oga02,
            ogb03      LIKE ogb_file.ogb03,
            ogb04      LIKE ogb_file.ogb04,
            ogb091     LIKE ogb_file.ogb091,
            ogb917     LIKE ogb_file.ogb917,  
            ogb60      LIKE ogb_file.ogb60
   END RECORD
   DEFINE   l_buf           LIKE oay_file.oayslip
   DEFINE   l_oay11         LIKE oay_file.oay11
   #SELECT omaplant INTO ms_omaplant FROM oma_file WHERE oma01 = ms_oma01   #FUN-960140 090824 mark
   SELECT oma66 INTO ms_oma66 FROM oma_file WHERE oma01 = ms_oma01          #FUN-960140 090824 add
   IF ms_oma00 = '12' THEN
      LET ms_cons_where = ms_cons_where," AND YEAR(oga02) = YEAR('",ms_oma02,"') ",
                                        " AND MONTH(oga02) = MONTH('",ms_oma02,"') "
   END IF
 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_ogb4', 'ogb_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',oga01,oga02,ogb03,ogb04,ogb091,ogb917,ogb60",  
                #" FROM oga_file,ogb_file",   #FUN-9A0093 mark
                #"  FROM ",ms_dbs CLIPPED,"oga_file,",ms_dbs CLIPPED,"ogb_file ",   #FUN-9A0093
                "  FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", #FUN-A50102
                          cl_get_target_table(g_plant_new,'ogb_file'),     #FUN-A50102 
                " WHERE ",ms_cons_where CLIPPED,
		            "   AND oga01 = ogb01",
		            "   AND oga03 = '",ms_cus CLIPPED,"'",
		            "   AND ogb60 < ogb917 ",  
		            "   AND ogaconf = 'Y' AND ogapost='Y' ",
                "   AND (oga09 = '2' OR oga09 ='3' OR oga09 = '8' OR oga09='A') ", 
                "  AND oga65='N' ",  
                "  AND oga00 IN ('1','4','5','6')",
                #"  AND ogaplant = '",ms_omaplant,"' "    #FUN-960140 090824 mark
                "  AND ogaplant = '",ms_oma66,"' "     #FUN-960140 090824 add
    IF ms_oma00='12' THEN
       SELECT oma08,oma68,oma21,oma23 INTO ms_oma08,ms_oma68,ms_oma21,ms_oma23
         FROM oma_file WHERE oma01=ms_oma01
       LET ls_sql = ls_sql," AND oga08 ='",ms_oma08 CLIPPED, "'",
                      " AND oga03 = '",ms_cus CLIPPED, "'",
                      " AND (oga18 = '",ms_oma68 CLIPPED, "'",
                      " OR oga18 IS NULL)",
                      " AND oga21 = '",ms_oma21 CLIPPED, "'",
                      " AND oga23 = '",ms_oma23 CLIPPED, "'"
   # END IF  #TQC-B40214
    LET ls_sql = ls_sql,"   AND ogb01 NOT IN ",
                 #" (SELECT omb31 FROM omb_file,ogb_file ",   #FUN-9A0093 mark
                 #" (SELECT omb31 FROM ",ms_dbs CLIPPED," omb_file,",ms_dbs CLIPPED,"ogb_file " ,
                 " (SELECT omb31 FROM ",cl_get_target_table(g_plant_new,'omb_file'),",", #FUN-A50102
                                        cl_get_target_table(g_plant_new,'ogb_file'),     #FUN-A50102
                 "    WHERE omb31=ogb01  ",
                 "     AND omb12 = ogb917) ",
	               "  ORDER BY oga01,ogb03 "
	  END IF  

#FUN-990069---begin 
   #IF (NOT mi_multi_sel ) THEN   #FUN-A50102
   #   #FUN-9A0093--add--str--
   #   IF NOT cl_null(ms_plant) THEN
   #      CALL cl_parse_qry_sql( ls_sql, ms_plant ) RETURNING ls_sql
   #   ELSE
   #   #FUN-9A0093--add--end
   #      CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql
   #   END IF    #FUN-9A0093
   #END IF     
#FUN-990069---end 
 
   DISPLAY "ls_sql=",ls_sql
   CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql  #FUN-A50102 
   CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
      IF NOT cl_null(lr_qry.oga01) THEN
              CALL s_get_doc_no(lr_qry.oga01) RETURNING l_buf
             #FUN-9C0013--mod--str--
             #SELECT oay11 INTO l_oay11 FROM oay_file
             # WHERE oayslip=l_buf
              #LET ls_sql = "SELECT oay11 FROM ",ms_dbs CLIPPED,"oay_file ",
              LET ls_sql = "SELECT oay11 FROM ",cl_get_target_table(g_plant_new,'oay_file'), #FUN-A50102
                           " WHERE oayslip='",l_buf,"' "
              CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
		      CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102              
              PREPARE sel_oay11_pre FROM ls_sql
              EXECUTE sel_oay11_pre INTO l_oay11
             #FUN-9C0013--mod--end
              IF NOT STATUS AND l_oay11<>'Y' THEN
                 CONTINUE FOREACH
              END IF
      END IF
      IF ms_oma00='12' AND cl_null(lr_qry.oga01) AND
              g_ooz.ooz19='N' THEN CONTINUE FOREACH
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
FUNCTION ogb4_qry_set_display_data(pi_start_index, pi_end_index)
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
FUNCTION ogb4_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_continue      LIKE type_file.num5, 
            li_reconstruct   LIKE type_file.num5  
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ogb.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb4_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb4_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         CALL ogb4_qry_refresh()
 
         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            IF ms_oma00 = '12' THEN       
              IF cl_null(ma_qry_tmp[ARR_CURR()].check) OR ma_qry_tmp[ARR_CURR()].check ='N'
                THEN EXIT INPUT END IF
              IF cl_confirm('axr-613') THEN
                 CALL ogb4_qry_reset_multi_sel(pi_start_index, pi_end_index)
                 IF cl_sure(0,0) THEN
                    CALL ogb4_qry_accept(pi_start_index+ARR_CURR()-1)
                 ELSE
                    CLOSE WINDOW q_ogb_w
                 END IF
              ELSE
                  CLOSE WINDOW q_ogb_w
              END IF
            ELSE
              CALL ogb4_qry_reset_multi_sel(pi_start_index, pi_end_index)
              IF cl_sure(0,0) THEN
                 CALL ogb4_qry_accept(pi_start_index+ARR_CURR()-1)
              ELSE
                 CLOSE WINDOW q_ogb_w
              END IF
            END IF
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
 
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 
         LET li_continue = FALSE
 
         EXIT INPUT
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON ACTION qry_string
         CALL cl_qry_string("detail")
 
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
FUNCTION ogb4_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION ogb4_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
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
         CALL ogb4_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION ogb4_qry_refresh()
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
FUNCTION ogb4_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	  
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	
   DEFINE   l_oma930        LIKE oma_file.oma930    
   DEFINE   l_sql           STRING                 
   DEFINE   l_ogb01         LIKE ogb_file.ogb01   
   DEFINE   l_ogb03         DYNAMIC ARRAY OF LIKE ogb_file.ogb03  
   DEFINE   l_cnt           LIKE type_file.num10   
   DEFINE   l_cnt1          LIKE type_file.num10  
   DEFINE   mr_ogb01        LIKE ogb_file.ogb01   
   DEFINE   mr_ogb03        LIKE ogb_file.ogb03  
   DEFINE   ls_sql          STRING    #FUN-9C0013
   CREATE TEMP TABLE qogb_file(
               ogb01  LIKE ogb_file.ogb01 NOT NULL,     #FUN-9A0093
               ogb03  LIKE ogb_file.ogb03 NOT NULL)     #FUN-9A0093
               #ogb01  varchar(16) NOT NULL,   #FUN-9A0093
               #ogb03  SMALLINT NOT NULL)      #FUN-9A0093

   #MESSAGE 'WORKING....' ATTRIBUTES(YELLOW)  #FUN-9A0093 編譯錯誤
   LET g_success='Y'
   BEGIN WORK
      SELECT MAX(omb03)+1 INTO ms_omb03 FROM omb_file WHERE omb01 = ms_oma01
      IF cl_null(ms_omb03) THEN LET ms_omb03=1 END IF
      LET l_oma930=NULL
      IF g_aaz.aaz90='Y' THEN
         SELECT oma903 INTO l_oma930 FROM oma_file
                                    WHERE oma01=ms_oma01
      END IF
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            LET l_cnt1= 0
           #FUN-9C0013--mod--str--
           #SELECT ogb01 INTO l_ogb01 FROM ogb_file WHERE ogb01 = ma_qry[li_i].oga01
            #LET ls_sql = "SELECT ogb01 FROM ",ms_dbs CLIPPED,"ogb_file ",
            LET ls_sql = "SELECT ogb01 FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                         " WHERE ogb01 = '",ma_qry[li_i].oga01,"' "
            CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
		    CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102             
            PREPARE sel_ogb01_pre FROM ls_sql
            EXECUTE sel_ogb01_pre INTO l_ogb01
           #FUN-9C0013--mod--end
            SELECT COUNT(UNIQUE(ogb01)) INTO l_cnt1 FROM qogb_file WHERE ogb01=l_ogb01
            IF l_cnt1 >0 THEN CONTINUE FOR END IF
            LET l_cnt = 1
            #LET l_sql = "SELECT ogb03 FROM ogb_file WHERE ogb01 = '",ma_qry[li_i].oga01 CLIPPED ,"'"  #FUN-9C0013
            #LET l_sql = "SELECT ogb03 FROM ",ms_dbs CLIPPED,"ogb_file WHERE ogb01 = '",ma_qry[li_i].oga01 CLIPPED ,"'"  #FUN-9C0013
         IF ms_oma00 = '12' THEN    #No.TQC-B40214
            LET l_sql = "SELECT ogb03 FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                        " WHERE ogb01 = '",ma_qry[li_i].oga01 CLIPPED ,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
		    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102              
            PREPARE t300_q_ogb1 FROM l_sql
            DECLARE t300_co_ogb1 CURSOR FOR t300_q_ogb1
            FOREACH t300_co_ogb1 INTO l_ogb03[l_cnt]
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 LET g_success='N'
                 EXIT FOREACH
              END IF
              INSERT INTO qogb_file(ogb01,ogb03) VALUES(l_ogb01,l_ogb03[l_cnt])
              IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                 LET g_success='N'
                 RETURN 0
              END IF
              Let l_cnt=l_cnt+1
            END FOREACH
        #No.TQC-B40214 --Begin
        ELSE
        	  INSERT INTO qogb_file(ogb01,ogb03) VALUES(l_ogb01,ma_qry[li_i].ogb03)
              IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                 LET g_success='N'
                 RETURN 0
              END IF
            
        END IF
        #No.TQC-B40214 --End
           #FUN-9C0013--mod--str--
           #UPDATE oga_file SET oga10 = ms_oma01 WHERE oga01=ma_qry[li_i].oga01
            #LET ls_sql = "UPDATE ",ms_dbs CLIPPED,"oga_file ",
            LET ls_sql = "UPDATE ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                         "   SET oga10 = '",ms_oma01,"' ",
                         " WHERE oga01 = '",ma_qry[li_i].oga01,"' "
            CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
		    CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102               
            PREPARE upd_oga_pre FROM ls_sql
            EXECUTE upd_oga_pre
           #FUN-9C0013--mod--end
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err3("upd","oga_file",ma_qry[li_i].oga01,"",SQLCA.SQLCODE,"","update oga_file",1)
               LET g_success = 'N'
            END IF
         END IF
      END FOR
      LET l_sql = "SELECT ogb01,ogb03 FROM qogb_file"
      PREPARE t300_q_ogb2 FROM l_sql
      DECLARE t300_co_ogb2 CURSOR FOR t300_q_ogb2
      FOREACH t300_co_ogb2 INTO mr_ogb01,mr_ogb03
        #FUN-9C0013--mod--str--
        #SELECT * INTO mr_ogb.* FROM ogb_file
        #  WHERE ogb01=mr_ogb01 AND ogb03=mr_ogb03
         #LET ls_sql = "SELECT * FROM ",ms_dbs CLIPPED,"ogb_file ",
         LET ls_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                      " WHERE ogb01='",mr_ogb01,"' ",
                      "   AND ogb03='",mr_ogb03,"' "
         CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102               
         PREPARE sel_ogb_pre FROM ls_sql
         EXECUTE sel_ogb_pre INTO mr_ogb.*
        #FUN-9C0013--mod--end
         INITIALIZE mr_omb.* TO NULL
         LET mr_omb.omb01 = ms_oma01
         LET mr_omb.omb03 = ms_omb03
         SELECT SUM(omb12) INTO ms_omb12 FROM omb_file,oma_file
          WHERE oma00='12'
            AND oma01=omb01
            AND omavoid='N'
            AND omb44=ms_plant   #FUN-9C0013
            AND omb31=mr_ogb01
            AND omb32=mr_ogb03
         IF STATUS THEN
            CONTINUE FOREACH
         END IF
         IF cl_null(ms_omb12) THEN LET ms_omb12=0 END IF
         LET mr_omb.omb12 = (mr_ogb.ogb917 - mr_ogb.ogb64) - ms_omb12
         IF  mr_omb.omb12 <= 0 THEN   #判斷出貨數量<應收數量
             CALL cl_err(mr_ogb.ogb01,'axm-301',1)
             CONTINUE FOREACH          #不產生單身部份
         END IF
         CALL ogb4_qry_detail()
         LET mr_omb.omb930=l_oma930 
         LET mr_omb.omblegal = g_legal #FUN-980012 add
         CALL ogb4_omb33()                          #FUN-C90078
         RETURNING mr_omb.omb33,mr_omb.omb331        #FUN-C90078
         LET mr_omb.omb48 = 0   #FUN-D10101 add
         INSERT INTO omb_file VALUES(mr_omb.*)
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("ins","omb_file","","",STATUS,"","",0)
            LET g_success='N'
            EXIT FOREACH
         END IF
         LET ms_omb03 = ms_omb03 + 1
      END FOREACH
      DROP TABLE qogb_file         
      IF g_success = 'Y' AND NOT cl_null(mr_omb.omb01) THEN 
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
END FUNCTION
 
FUNCTION ogb4_qry_detail()
 
     LET mr_omb.omb31 = mr_ogb.ogb01
     LET mr_omb.omb32 = mr_ogb.ogb03
     LET mr_omb.omb44 = ms_plant       #FUN-9C0013
     LET mr_omb.omb04 = mr_ogb.ogb04
     LET mr_omb.omb05 = mr_ogb.ogb916  
     LET mr_omb.omb12 = s_digqty(mr_omb.omb12,mr_omb.omb05) #FUN-BB0083 add
     LET mr_omb.omb06 = mr_ogb.ogb06
     LET mr_omb.omb13 = mr_ogb.ogb13
     IF ms_oma213 = 'N' THEN
        LET mr_omb.omb14  = mr_omb.omb12  * mr_omb.omb13
        LET mr_omb.omb14t = mr_omb.omb14  * (1 + ms_oma211/100)
     ELSE
        LET mr_omb.omb14t = mr_omb.omb12  * mr_omb.omb13
        LET mr_omb.omb14  = mr_omb.omb14t / (1 + ms_oma211/100)
     END IF
     CALL cl_digcut(mr_omb.omb14,g_azi04) RETURNING mr_omb.omb14
     CALL cl_digcut(mr_omb.omb14t,g_azi04)RETURNING mr_omb.omb14t
     LET mr_omb.omb15  = mr_omb.omb13  * ms_oma24
     LET mr_omb.omb16  = mr_omb.omb14  * ms_oma24
     LET mr_omb.omb16t = mr_omb.omb14t * ms_oma24
     LET mr_omb.omb17  = mr_omb.omb13  * ms_oma58
     LET mr_omb.omb18  = mr_omb.omb14  * ms_oma58
     LET mr_omb.omb18t = mr_omb.omb14t * ms_oma58
     IF cl_null(mr_omb.omb17) THEN LET mr_omb.omb17=0 END IF
     IF cl_null(mr_omb.omb18) THEN LET mr_omb.omb18=0 END IF
     IF cl_null(mr_omb.omb18t) THEN LET mr_omb.omb18t=0 END IF
     CALL cl_digcut(mr_omb.omb15,t_azi04) RETURNING mr_omb.omb15
     CALL cl_digcut(mr_omb.omb16,t_azi04) RETURNING mr_omb.omb16
     CALL cl_digcut(mr_omb.omb16t,t_azi04)RETURNING mr_omb.omb16t
     CALL cl_digcut(mr_omb.omb17,t_azi03) RETURNING mr_omb.omb17
     CALL cl_digcut(mr_omb.omb18,t_azi04) RETURNING mr_omb.omb18
     CALL cl_digcut(mr_omb.omb18t,t_azi04)RETURNING mr_omb.omb18t
     LET mr_omb.omb34=0 LET mr_omb.omb35=0
 
     MESSAGE mr_omb.omb03,' ',mr_omb.omb04,' ',mr_omb.omb12
END FUNCTION

#FUN-C90078---add--str
FUNCTION ogb4_omb33()
DEFINE l_sql    STRING
DEFINE l_oma08  LIKE oma_file.oma08
DEFINE l_oba11  LIKE oba_file.oba11
DEFINE l_oba111 LIKE oba_file.oba111
DEFINE l_ool41  LIKE ool_file.ool41
DEFINE l_ool411 LIKE ool_file.ool411
DEFINE l_oma13  LIKE oma_file.oma13
DEFINE l_omb33  LIKE omb_file.omb33
DEFINE l_omb331 LIKE omb_file.omb331

   IF ms_oma00<>'12' THEN RETURN '' ,'' END IF
   SELECT oma08,oma13 INTO l_oma08,l_oma13 FROM oma_file WHERE oma01=ms_oma01
   IF cl_null(mr_omb.omb33) THEN
        LET l_oba11 = NULL
        IF l_oma08 = '1' THEN
           LET l_sql = "SELECT oba11,oba111 ",
                       "  FROM ",cl_get_target_table(g_plant_new,'oba_file'),",",
                                 cl_get_target_table(g_plant_new,'ima_file'),
                       " WHERE oba01 = ima_file.ima131",
                       "   AND ima01 = '",mr_omb.omb04,"'"
        ELSE
           LET l_sql = "SELECT oba17,oba171 ",
                       "  FROM ",cl_get_target_table(g_plant_new,'oba_file'),",",
                                 cl_get_target_table(g_plant_new,'ima_file'),
                       " WHERE oba01 = ima_file.ima131",
                       "   AND ima01 = '",mr_omb.omb04,"'"
        END IF
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
        PREPARE sel_oba_pre19 FROM l_sql
        EXECUTE sel_oba_pre19 INTO l_oba11,l_oba111
        IF SQLCA.sqlcode THEN
           LET l_oba11 = NULL
           LET l_oba111= NULL
           CALL s_errmsg('ima01',mr_omb.omb04,"sel oba" ,STATUS,0)
        END IF
        LET l_omb33 = l_oba11
        LET l_omb331 = l_oba111
     END IF

      IF cl_null(l_omb33) THEN
         IF l_oma08='1' THEN
            SELECT ool41 INTO l_omb33
              FROM ool_file
             WHERE ool01 = l_oma13
            IF g_aza.aza63 = 'Y' THEN
               SELECT ool411 INTO l_omb331
                 FROM ool_file
               WHERE ool01 = l_oma13
            END IF
         ELSE
            SELECT ool40 INTO l_omb33
              FROM ool_file
             WHERE ool01 = l_oma13
            IF g_aza.aza63 = 'Y' THEN
               SELECT ool401 INTO l_omb331
                 FROM ool_file
               WHERE ool01 = l_oma13
            END IF
         END IF
      END IF
      IF g_aza.aza63='N' THEN
         LET l_omb331=''
      END IF
      RETURN l_omb33,l_omb331
END FUNCTION
#FUN-C90078--add---end


