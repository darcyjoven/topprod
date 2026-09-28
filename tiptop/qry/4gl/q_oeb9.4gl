# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#
# Program name  : q_oeb9.4gl
# Program ver.  : 7.0
# Description   : 訂單資料查詢
# Date & Author : 2009/07/14 #FUN-960140 by lutingting 
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定 
# Modify.........: No.FUN-9A0093 09/11/01 By lutingting增加參數PLANT 
# Modify.........: No.FUN-9C0013 09/12/03 By lutingting繼續FUN-9A0093問題
# Modify.........: No.FUN-9C0041 09/12/15 By lutingting 跨庫要去實體DB抓取資料
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No.FUN-A50102 10/06/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-D10101 13/01/22 By lujh axrt300單身新增已開票數量欄位，賦默認值0

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         oea01    LIKE oea_file.oea01,
         oea02    LIKE oea_file.oea02,
         oeb03    LIKE oeb_file.oeb03,
         oeb04    LIKE oeb_file.oeb04,
         oeb091   LIKE oeb_file.oeb091,
         oeb917   LIKE oeb_file.oeb917,
         oeb24    LIKE oeb_file.oeb24
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,
         oea01        LIKE oea_file.oea01,
         oea02        LIKE oea_file.oea02,
         oeb03        LIKE oeb_file.oeb03,
         oeb04        LIKE oeb_file.oeb04,
         oeb091       LIKE oeb_file.oeb091,
         oeb917       LIKE oeb_file.oeb917,
         oeb24        LIKE oeb_file.oeb24
END RECORD
DEFINE   ms_cus       LIKE oea_file.oea03,
         ms_oma01     LIKE oma_file.oma01,
         ms_oma213    LIKE oma_file.oma213,
         ms_oma211    LIKE oma_file.oma211,
         ms_oma24     LIKE oma_file.oma24,
         ms_omb03     LIKE omb_file.omb03
DEFINE   mr_oeb       RECORD LIKE oeb_file.*,
         mr_omb       RECORD LIKE omb_file.*
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.
DEFINE   ms_dbs           LIKE type_file.chr21        #FUN-9A0093
DEFINE   ms_plant         LIKE type_file.chr10        #FUN-9A0093

FUNCTION q_oeb9(pi_multi_sel,pi_need_cons,ps_cus,ps_oma01,ps_oma213,ps_oma211,ps_oma24,ps_plant)    #FUN-9A0093 add plant
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_default1    STRING  ,
            ps_cus         LIKE oea_file.oea03,
            ps_oma01       LIKE oma_file.oma01,
            ps_oma213      LIKE oma_file.oma213,
            ps_oma211      LIKE oma_file.oma211,
            ps_oma24       LIKE oma_file.oma24
            ,ps_plant      LIKE type_file.chr10   #FUN-9A0093
 
 
   WHENEVER ERROR CONTINUE
 
   #FUN-9A0093--add--str-
   #IF cl_null(ps_plant) THEN   #FUN-A50102
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
   LET ms_plant  = ps_plant     #FUN-9A0093 

   OPEN WINDOW w_qry WITH FORM "qry/42f/q_oeb1" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_oeb1")
 
   LET mi_multi_sel = TRUE
   LET mi_need_cons = pi_need_cons
 
   DISPLAY ps_cus TO FORMONLY.oea03
   CALL oeb9_qry_sel()
 
   CLOSE WINDOW w_qry
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oeb9_qry_sel()
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
            #CONSTRUCT BY NAME ms_cons_where ON oea01,oea02,oeb03,oeb04,oeb091,oeb12,oeb24
            CONSTRUCT BY NAME ms_cons_where ON oea01,oea02,oeb03,oeb04,oeb091,oeb917,oeb24 
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
 
         CALL oeb9_qry_prep_result_set()
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
 
      CALL oeb9_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      #  若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL oeb9_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL oeb9_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION oeb9_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   
            oea01      LIKE oea_file.oea01,
            oea02      LIKE oea_file.oea02,
            oeb03      LIKE oeb_file.oeb03,
            oeb04      LIKE oeb_file.oeb04,
            oeb091     LIKE oeb_file.oeb091,
            #oeb12      LIKE oeb_file.oeb12, 
            oeb917     LIKE oeb_file.oeb917, 
            oeb24      LIKE oeb_file.oeb24
   END RECORD
   DEFINE   l_oma16         LIKE oma_file.oma16 
   #DEFINE   l_omaplant         LIKE oma_file.omaplant    #FUN-960140 090824 mark
   DEFINE   l_oma66         LIKE oma_file.oma66           #FUN-960140 090824 add 
 
 
   #LET ls_sql = "SELECT 'N',oea01,oea02,oeb03,oeb04,oeb091,oeb12,oeb24",
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_oeb9', 'oea_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',oea01,oea02,oeb03,oeb04,oeb091,oeb917,oeb24", 
                #" FROM oea_file,oeb_file",     #FUN-9A0093
                #"  FROM ",ms_dbs CLIPPED,"oea_file,",ms_dbs CLIPPED,"oeb_file ",    #FUN-9A0093
                "  FROM ",cl_get_target_table(g_plant_new,'oea_file'),",", #FUN-A50102
                          cl_get_target_table(g_plant_new,'oeb_file'),     #FUN-A50102
                " WHERE ",ms_cons_where CLIPPED,
		"   AND oea01 = oeb01 ",
		"   AND oea03 = '",ms_cus CLIPPED,"'",
		"   AND oeaconf = 'Y' ",
		"   AND oea00 = '1' ",
		"   AND oea161 != 0 "
   #SELECT oma16,omaplant INTO l_oma16,l_omaplant FROM oma_file WHERE oma01 = ms_oma01   #FUN-960140 090824 mark
   SELECT oma16,oma66 INTO l_oma16,l_oma66 FROM oma_file WHERE oma01 = ms_oma01          #FUN-960140 090824 add
  
   #IF NOT cl_null(l_omaplant) THEN    #FUN-960140 090824 mark
   IF NOT cl_null(l_oma66) THEN        #FUN-960140 090824 add 
      #LET ls_sql = ls_sql," AND oeaplant = '",l_omaplant CLIPPED,"'"    #FUN-960140 090824 mark
      LET ls_sql = ls_sql," AND oeaplant = '",l_oma66 CLIPPED,"'"     #FUN-960140 090824 add
   END IF
   IF NOT cl_null(l_oma16) THEN 
      LET ls_sql = ls_sql," AND oea01 = '",l_oma16 CLIPPED,"'",
                   " ORDER BY oea01,oeb03 "
   ELSE
      LET ls_sql = ls_sql," ORDER BY oea01,oeb03 "
   END IF
#FUN-990069---begin 
   #IF (NOT mi_multi_sel ) THEN  #FUN-A50102
   #   #FUN-9A0093--add--str--
   #   IF NOT cl_null(ms_plant) THEN
   #      CALL cl_parse_qry_sql( ls_sql, ms_plant ) RETURNING ls_sql
   #   ELSE
   #   #FUN-9A0093--add--end
   #      CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql
   #   END IF   #FUN-9A0093
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
 
      # 判斷是否已達選取上限  
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
FUNCTION oeb9_qry_set_display_data(pi_start_index, pi_end_index)
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
FUNCTION oeb9_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_continue      LIKE type_file.num5, 
            li_reconstruct   LIKE type_file.num5 
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oeb.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_oeb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oeb9_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_oeb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oeb9_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         CALL oeb9_qry_refresh()
 
         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_oeb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL oeb9_qry_reset_multi_sel(pi_start_index, pi_end_index)
            IF cl_sure(0,0) THEN
               CALL oeb9_qry_accept(pi_start_index+ARR_CURR()-1)
            ELSE
               CLOSE WINDOW q_oeb_w
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
FUNCTION oeb9_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION oeb9_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_continue      LIKE type_file.num5,  
            li_reconstruct   LIKE type_file.num5  	
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_oeb.*
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
         CALL oeb9_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION oeb9_qry_refresh()
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
FUNCTION oeb9_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  
   DEFINE   l_oma930        LIKE oma_file.oma930 
   DEFINE   ls_sql          STRING         #FUN-9C0013 
 
   #MESSAGE 'WORKING....' ATTRIBUTES(YELLOW)   #FUN-9A0093 編譯報錯
   LET g_success='Y'
   BEGIN WORK
      SELECT MAX(omb03)+1 INTO ms_omb03 FROM omb_file WHERE omb01 = ms_oma01
      IF cl_null(ms_omb03) THEN LET ms_omb03=1 END IF
      LET l_oma930=NULL
      IF g_aaz.aaz90='Y' THEN
         SELECT oma930 INTO l_oma930 FROM oma_file
                                    WHERE oma01=ms_oma01
      END IF
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
           #FUN-9C0013--mod--str--
           #SELECT * INTO mr_oeb.* FROM oeb_file
           #WHERE oeb01=ma_qry[li_i].oea01 AND oeb03=ma_qry[li_i].oeb03
            #LET ls_sql = "SELECT * FROM ",ms_dbs CLIPPED,"oeb_file ",
            LET ls_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                         " WHERE oeb01='",ma_qry[li_i].oea01,"' ",
                         "   AND oeb03='",ma_qry[li_i].oeb03,"' "
            CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
		    CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102             
            PREPARE sel_oea_pre FROM ls_sql
            EXECUTE sel_oea_pre INTO mr_oeb.*
           #FUN-9C0013--mod--end
            INITIALIZE mr_omb.* TO NULL
            LET mr_omb.omb01 = ms_oma01
            LET mr_omb.omb03 = ms_omb03
            CALL q_oeb9_detail()
            LET mr_omb.omb930=l_oma930 
            LET mr_omb.omblegal = g_legal  #FUN-980012 add
            LET mr_omb.omb48 = 0   #FUN-D10101 add
            INSERT INTO omb_file VALUES(mr_omb.*)
            LET ms_omb03 = ms_omb03 + 1
            IF STATUS THEN
               CALL cl_err3("ins","omb_file","","",STATUS,"","",0)
               EXIT FOR
            END IF
         END IF
      END FOR
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   MESSAGE ''
END FUNCTION
 
FUNCTION q_oeb9_detail()
     LET mr_omb.omb31 = mr_oeb.oeb01
     LET mr_omb.omb32 = mr_oeb.oeb03
     LET mr_omb.omb44 = ms_plant       #FUN-9C0013
     LET mr_omb.omb04 = mr_oeb.oeb04
     LET mr_omb.omb05 = mr_oeb.oeb916   
     LET mr_omb.omb06 = mr_oeb.oeb06
     LET mr_omb.omb12 = mr_oeb.oeb917   
     LET mr_omb.omb13 = mr_oeb.oeb13
     IF ms_oma213 = 'N' THEN
        LET mr_omb.omb14  = mr_omb.omb12  * mr_omb.omb13
        LET mr_omb.omb14t = mr_omb.omb14  * (1 + ms_oma211/100)
     ELSE
        LET mr_omb.omb14t = mr_omb.omb12  * mr_omb.omb13
        LET mr_omb.omb14  = mr_omb.omb14t / (1 + ms_oma211/100)
     END IF
     CALL cl_digcut(mr_omb.omb14,t_azi04) RETURNING mr_omb.omb14  
     CALL cl_digcut(mr_omb.omb14t,t_azi04)RETURNING mr_omb.omb14t 
     LET mr_omb.omb15  = mr_omb.omb13  * ms_oma24
     LET mr_omb.omb16  = mr_omb.omb14  * ms_oma24
     LET mr_omb.omb16t = mr_omb.omb14t * ms_oma24
     CALL cl_digcut(mr_omb.omb15,g_azi04) RETURNING mr_omb.omb15 
     CALL cl_digcut(mr_omb.omb16,g_azi04) RETURNING mr_omb.omb16 
     CALL cl_digcut(mr_omb.omb16t,g_azi04)RETURNING mr_omb.omb16t
     MESSAGE mr_omb.omb03,' ',mr_omb.omb04,' ',mr_omb.omb12
END FUNCTION
#FUN-960140--add
