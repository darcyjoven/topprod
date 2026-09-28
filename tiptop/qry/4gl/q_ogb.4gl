# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#{
# Program name   : q_ogb.4gl
# Program ver.   : 7.0
# Description    : 
# Date & Author  : 2004/02/28 by saki
# Memo           : 
# Modify.........: No.MOD-530692 By day 數量重復計算
# Modify.........: No.FUN-610020 06/01/18 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.MOD-720089 07/02/14 By Smapmin 增加insert omb17,omb18,omb18t
# Modify.........: No.MOD-740413 07/04/29 By chenl  單身出貨單開窗查詢不應該把已立過應收的出貨單還查出來，如果數量不相同(omb12!=ogb12)則不排除。
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-740016 07/05/09 By Nicola 借出管理
# Modify.........: No.FUN-670090 07/01/15 BY yiting cl_err->cl_err3
# Modify.........: No.TQC-750058 07/05/14 By Smapmin 檢核出貨日期與帳款日期不同年月的狀況
# Modify.........: No.MOD-790096 07/09/20 By Smapmin 單位/數量改抓計價單位/計價數量
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.MOD-840089 08/04/14 By Smapmin 修正MOD-740413 
# Modify.........: No.MOD-840532 08/04/22 By Smapmin 僅抓出貨類別為1456
# Modify.........: No.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.MOD-870209 08/07/21 By Smapmin omb38未給值
# Modify.........: No.MOD-870311 08/08/01 By Sarah 取位時原幣應該用t_azi(以oma23抓取),本幣用g_azi,兩者顛倒了
# Modify.........: No.MOD-880005 08/08/08 By Sarah 寫入omb_file後,要回寫來源單據的帳單編號欄位
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-8B0127 08/11/19 By chenl 增加數據篩選功能，單據日期應小于等于立賬日期。
# Modify.........: No.MOD-8C0211 08/12/22 By chenl 若出貨單單別未勾選轉AR，則單據不顯示。
# Modify.........: No.MOD-930277 09/03/26 By chenl 增加篩選條件，內外銷需對應。
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
#}
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定 
# Modfiy.........: No.FUN-9A0093 09/11/04 By lutingting增加參數PLANT 
# Modify.........: No.FUN-9C0013 09/12/03 By lutingting 延續FUN-9A0093處理得問題
# Modify.........: No.FUN-9C0041 09/12/15 By lutingting 跨庫要去實體DB抓取資料
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No.FUN-A50102 10/06/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-BB0083 11/12/19 By xujing 增加數量欄位小數取位
# Modify.........: No.MOD-C90161 12/09/21 By Polly 給予ogb41、ogb42 預設值
# Modify.........: No.FUN-C90078 12/10/17 By minpp omb38='2',INSERT omb_file 前，抓取omb33，omb331的值
# Modify.........: No.FUN-D10101 13/01/22 By lujh axrt300單身新增已開票數量欄位，賦默認值0

DATABASE ds
 

GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         oga01    LIKE oga_file.oga01,
         oga02    LIKE oga_file.oga02,
         ogb03    LIKE ogb_file.ogb03,
         ogb04    LIKE ogb_file.ogb04,
         ogb091   LIKE ogb_file.ogb091,
         #ogb12    LIKE ogb_file.ogb12,   #MOD-790096
         ogb917   LIKE ogb_file.ogb917,   #MOD-790096
         ogb60    LIKE ogb_file.ogb60
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         oga01        LIKE oga_file.oga01,
         oga02        LIKE oga_file.oga02,
         ogb03        LIKE ogb_file.ogb03,
         ogb04        LIKE ogb_file.ogb04,
         ogb091       LIKE ogb_file.ogb091,
         #ogb12        LIKE ogb_file.ogb12,   #MOD-790096
         ogb917       LIKE ogb_file.ogb917,   #MOD-790096
         ogb60        LIKE ogb_file.ogb60
END RECORD
DEFINE   ms_cus       LIKE oga_file.oga03,
         ms_oma01     LIKE oma_file.oma01,
         ms_oma213    LIKE oma_file.oma213,
         ms_oma211    LIKE oma_file.oma211,
         ms_oma24     LIKE oma_file.oma24,
         ms_oma58     LIKE oma_file.oma58,   #MOD-720089
         ms_omb03     LIKE omb_file.omb03,
         ms_omb12     LIKE omb_file.omb12,
         ms_oma00     LIKE oma_file.oma00,   #TQC-750058
         ms_oma02     LIKE oma_file.oma02    #TQC-750058
DEFINE   mr_ogb       RECORD LIKE ogb_file.*,
         mr_omb       RECORD LIKE omb_file.*
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_dbs           LIKE type_file.chr21        #FUN-9A0093
DEFINE   ms_plant         LIKE type_file.chr10        #FUN-9A0093

#FUNCTION q_ogb(pi_multi_sel,pi_need_cons,ps_cus,ps_oma01,ps_oma213,ps_oma211,ps_oma24)   #MOD-720089
#FUNCTION q_ogb(pi_multi_sel,pi_need_cons,ps_cus,ps_oma01,ps_oma213,ps_oma211,ps_oma24,ps_oma58)   #MOD-720089   #TQC-750058
FUNCTION q_ogb(pi_multi_sel,pi_need_cons,ps_cus,ps_oma01,ps_oma213,ps_oma211,ps_oma24,ps_oma58,ps_oma00,ps_oma02,ps_plant)    #TQC-750058   #FUN-9A0093  add plant
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_cus         LIKE oga_file.oga03,
            ps_oma01       LIKE oma_file.oma01,
            ps_oma213      LIKE oma_file.oma213,
            ps_oma211      LIKE oma_file.oma211,
            ps_oma24       LIKE oma_file.oma24, 
            ps_oma58       LIKE oma_file.oma58,   #MOD-720089
            ps_oma00       LIKE oma_file.oma00,   #TQC-750058
            ps_oma02       LIKE oma_file.oma02    #TQC-750058
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
   LET ms_oma58  = ps_oma58    #MOD-720089
   LET ms_oma00  = ps_oma00    #TQC-750058
   LET ms_oma02  = ps_oma02    #TQC-750058
   LET ms_plant  = ps_plant    #FUN-9A0093 

   OPEN WINDOW w_qry WITH FORM "qry/42f/q_ogb" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_ogb")
 
   LET mi_multi_sel = TRUE
   LET mi_need_cons = pi_need_cons
 
   CALL ogb_qry_sel()
 
   CLOSE WINDOW w_qry
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2004/02/28 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 
   LET li_reconstruct = TRUE
   LET ms_cons_where = NULL  #No.MOD-8B0127 
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
            #CONSTRUCT BY NAME ms_cons_where ON oga01,oga02,ogb03,ogb04,ogb091,ogb12,ogb60   #MOD-790096
            CONSTRUCT BY NAME ms_cons_where ON oga01,oga02,ogb03,ogb04,ogb091,ogb917,ogb60   #MOD-790096
     
#--NO.MOD-860078 start---
  
            ON ACTION controlg      
               CALL cl_cmdask()     
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION about         
               CALL cl_about()      
 
            ON ACTION help          
               CALL cl_show_help()  
 
            END CONSTRUCT
#--NO.MOD-860078 end------- 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL ogb_qry_prep_result_set() 
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
     
      CALL ogb_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL ogb_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL ogb_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2004/02/28 by saki
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION ogb_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            oga01      LIKE oga_file.oga01,
            oga02      LIKE oga_file.oga02,
            ogb03      LIKE ogb_file.ogb03,
            ogb04      LIKE ogb_file.ogb04,
            ogb091     LIKE ogb_file.ogb091,
            #ogb12      LIKE ogb_file.ogb12,   #MOD-790096
            ogb917     LIKE ogb_file.ogb917,   #MOD-790096
            ogb60      LIKE ogb_file.ogb60
   END RECORD
   DEFINE   l_oga07    LIKE oga_file.oga07  #No.MOD-8B0127 
   DEFINE l_slip       LIKE oay_file.oayslip  #No.MOD-8C0211
   DEFINE l_oay11      LIKE oay_file.oay11    #No.MOD-8C0211
   DEFINE l_oma08      LIKE oma_file.oma08    #No.MOD-930277
 
   #-----TQC-750058---------
   IF ms_oma00 = '12' THEN
     #No.MOD-8B0127--begin-- modify
     #LET ms_cons_where = ms_cons_where," AND YEAR(oga02) = YEAR('",ms_oma02,"') ",
     #                                  " AND MONTH(oga02) = MONTH('",ms_oma02,"') "  
      IF cl_null(ms_cons_where) THEN
         LET ms_cons_where = ' 1=1'
      END IF 
      IF NOT cl_null(ms_oma02) THEN
         LET ms_cons_where = ms_cons_where," AND oga02 <= '",ms_oma02,"'"
      END IF
     #No.MOD-8B0127---end--- modify
     #No.MOD-930277--begin--
      LET l_oma08 = NULL
      SELECT oma08 INTO l_oma08 FROM oma_file WHERE oma01 = ms_oma01
      IF NOT cl_null(l_oma08) THEN 
         LET ms_cons_where = ms_cons_where," AND oga08 ='",l_oma08 CLIPPED,"'"
      END IF 
     #No.MOD-930277---end---
   END IF
   #-----END TQC-750058-----
 
   #LET ls_sql = "SELECT 'N',oga01,oga02,ogb03,ogb04,ogb091,ogb12,ogb60",   #MOD-790096
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_ogb', 'ogb_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',oga01,oga02,ogb03,ogb04,ogb091,ogb917,ogb60",   #MOD-790096
                #" FROM oga_file,ogb_file",     #FUN-9A0093 mark
                #"  FROM ",ms_dbs CLIPPED,"oga_file, ",ms_dbs CLIPPED,"ogb_file ",      #FUN-9A0093
                "  FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", #FUN-A50102
                          cl_get_target_table(g_plant_new,'ogb_file'),     #FUN-A50102
                " WHERE ",ms_cons_where CLIPPED,
		"   AND oga01 = ogb01",
		"   AND oga03 = '",ms_cus CLIPPED,"'",
		#"   AND ogb60 < ogb12 ",   #MOD-790096
		"   AND ogb60 < ogb917 ",   #MOD-790096
		"   AND ogaconf = 'Y' AND ogapost='Y' ",
                "   AND (oga09 = '2' OR oga09 ='3' OR oga09 = '8' OR oga09='A') ",  #010809改  #No.FUN-610020   #No.FUN-740016
                "  AND oga65='N' ",  #No.FUN-610020
                "  AND oga00 IN ('1','4','5','6')",   #MOD-840532
                #-----MOD-840089---------
                ##No.MOD-740413--begin--
                #"   AND ogb01 NOT IN (SELECT omb31 FROM omb_file,ogb_file ",
                #"                      WHERE omb31 = ogb01 and omb32=ogb32 ",   
                ##"                        AND omb12 = ogb12)                ",   #MOD-790096
                #"                        AND omb12 = ogb917)                ",   #MOD-790096
                ##No.MOD-740413--begin--
                "   AND ogb01||ogb03 NOT IN ",
                #"       (SELECT omb31||omb32 FROM omb_file,ogb_file ",   #FUN-9A0093
                #"       (SELECT omb31||omb32 FROM ",ms_dbs CLIPPED,"omb_file,",ms_dbs CLIPPED,"ogb_file ",    #FUN-9A0093
                "       (SELECT omb31||omb32 FROM ",cl_get_target_table(g_plant_new,'omb_file'),",", #FUN-A50102
                                                    cl_get_target_table(g_plant_new,'ogb_file'),     #FUN-A50102
                "          WHERE omb31=ogb01 AND omb32=ogb03 ",
                "            AND omb12 = ogb917) ",
                #-----END MOD-840089-----
		" ORDER BY oga01,ogb03 "
 
#FUN-990069---begin 
   #IF (NOT mi_multi_sel ) THEN  #FUN-A50102
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
     #No.MOD-8B0127--begin-- 
      IF NOT cl_null(lr_qry.oga01) THEN 
         LET l_oga07 = NULL
        #FUN-9C0013--mod--str--
        #SELECT oga07 INTO l_oga07 FROM oga_file WHERE oga01 = lr_qry.oga01 
         #LET ls_sql = "SELECT oga07 FROM ",ms_dbs CLIPPED,"oga_file ",
         LET ls_sql = "SELECT oga07 FROM ",cl_get_target_table(g_plant_new,'oga_file'),     #FUN-A50102
                      " WHERE oga01 = '",lr_qry.oga01,"' "
         CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102             
         PREPARE sel_oga07_pre FROM ls_sql
         EXECUTE sel_oga07_pre INTO l_oga07 
        #FUN-9C0013--mod--end
         IF l_oga07 <> 'Y' THEN 
            IF YEAR(lr_qry.oga02) <> YEAR(ms_oma02) OR 
               MONTH(lr_qry.oga02) <> MONTH(ms_oma02) THEN
               CONTINUE FOREACH 
            END IF
         END IF
      END IF
     #No.MOD-8B0127---end--- 
 
     #No.MOD-8C0211--begin--
      CALL s_get_doc_no(lr_qry.oga01) RETURNING l_slip
     #FUN-9C0013--mod--str--
     #SELECT oay11 INTO l_oay11 FROM oay_file WHERE oayslip = l_slip
      #LET ls_sql = "SELECT oay11 FROM ",ms_dbs CLIPPED,"oay_file ",
      LET ls_sql = "SELECT oay11 FROM ",cl_get_target_table(g_plant_new,'oay_file'),     #FUN-A50102
                   " WHERE oayslip = '",l_slip,"' "
      CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102               
      PREPARE sel_oay11_pre FROM ls_sql
      EXECUTE sel_oay11_pre INTO l_oay11
     #FUN-9C0013--mod--end
      IF l_oay11<> 'Y' THEN
         CONTINUE FOREACH
      END IF
     #No.MOD-8C0211---end---
 
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
# Date & Author : 2004/02/28 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION ogb_qry_set_display_data(pi_start_index, pi_end_index)
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
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2004/02/28 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ogb.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ogb.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL ogb_qry_refresh()
     
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
            CALL ogb_qry_reset_multi_sel(pi_start_index, pi_end_index)
            IF cl_sure(0,0) THEN
               CALL ogb_qry_accept(pi_start_index+ARR_CURR()-1)
            ELSE
               CLOSE WINDOW q_ogb_w
            END IF
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         LET li_continue = FALSE
     
         EXIT INPUT
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--
 
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
#--NO.MOD-860078 start---
  
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
#--NO.MOD-860078 end------- 
 
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
# Date & Author : 2004/02/28 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2004/02/28 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
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
         CALL ogb_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--
 
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
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2004/02/28 by saki
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION ogb_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2004/02/28 by saki
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb_qry_accept(pi_sel_index)
   DEFINE pi_sel_index    LIKE type_file.num10 	   #No.FUN-680131 INTEGER
   DEFINE lsb_multi_sel   base.StringBuffer 
   DEFINE li_i            LIKE type_file.num10     #No.FUN-680131 INTEGER
   DEFINE l_oma930        LIKE oma_file.oma930     #FUN-680006 
   DEFINE l_oma           RECORD LIKE oma_file.*   #MOD-880005 add
   DEFINE ls_sql          STRING                   #FUN-9C0013 

   #MESSAGE 'WORKING....' ATTRIBUTES(YELLOW)    #FUN-9A0093 編譯報錯
   LET g_success='Y'
   BEGIN WORK
      SELECT MAX(omb03)+1 INTO ms_omb03 FROM omb_file WHERE omb01 = ms_oma01 
      #@@@ 95/07/05 by danny
      IF cl_null(ms_omb03) THEN LET ms_omb03=1 END IF
      #@@@
      SELECT * INTO l_oma.* FROM oma_file WHERE oma01 = ms_oma01   #MOD-880005 add
      #FUN-680006...............begin
      LET l_oma930=NULL
      IF g_aaz.aaz90='Y' THEN
         SELECT oma903 INTO l_oma930 FROM oma_file
                                    WHERE oma01=ms_oma01
      END IF
      #FUN-680006...............end
     #str MOD-870311 add
     #抓取原幣取位小數位數
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
        FROM azi_file WHERE azi01=(SELECT oma23 FROM oma_file
                                    WHERE oma01=ms_oma01)
     #end MOD-870311 add
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
           #FUN-9C0013--mod--str--
           #SELECT * INTO mr_ogb.* FROM ogb_file
           #WHERE ogb01=ma_qry[li_i].oga01 AND ogb03=ma_qry[li_i].ogb03
            #LET ls_sql = "SELECT * FROM ",ms_dbs CLIPPED,"ogb_file ",
            LET ls_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                         " WHERE ogb01='",ma_qry[li_i].oga01,"' ",
                         "   AND ogb03='",ma_qry[li_i].ogb03,"' "
            CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
		    CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102               
            PREPARE sel_ogb_pre FROM ls_sql
            EXECUTE sel_ogb_pre INTO mr_ogb.*
           #FUN-9C0013--mod--end
            INITIALIZE mr_omb.* TO NULL
            LET mr_omb.omb01 = ms_oma01
            LET mr_omb.omb03 = ms_omb03
            #No:7682
            SELECT SUM(omb12) INTO ms_omb12 FROM omb_file,oma_file
             WHERE oma00='12'
               AND oma01=omb01
               AND omavoid='N'
               AND omb44=ms_plant    #FUN-9C0013
               AND omb31=mr_ogb.ogb01
               AND omb32=mr_ogb.ogb03
            IF STATUS THEN 
               CONTINUE FOR
            END IF
            IF cl_null(ms_omb12) THEN LET ms_omb12=0 END IF
 #No.MOD-530692--begin
            #LET mr_omb.omb12 = (mr_ogb.ogb12 - mr_ogb.ogb64) - ms_omb12   #MOD-790096
            LET mr_omb.omb12 = (mr_ogb.ogb917 - mr_ogb.ogb64) - ms_omb12   #MOD-790096
#           LET mr_omb.omb12 = (mr_ogb.ogb12 - mr_ogb.ogb60 - mr_ogb.ogb64) - ms_omb12
 #No.MOD-530692--end   
            IF  mr_omb.omb12 <= 0 THEN   #判斷出貨數量<應收數量
                CALL cl_err(mr_ogb.ogb01,'axm-301',1)
                #DISPLAY "mr_omb.omb12",mr_omb.omb12
                #DISPLAY " CONTINUE FOR"
                CONTINUE FOR           #不產生單身部份
            END IF
            #No:7682
            CALL ogb_qry_detail()
            LET mr_omb.omb930=l_oma930  #FUN-680006
            #-----MOD-870209---------
            IF ms_oma00 = '12' OR ms_oma00 = '13' THEN
               LET mr_omb.omb38 = '2' 
            ELSE
               LET mr_omb.omb38 = '99' 
            END IF 
            #-----END MOD-870209-----
            LET mr_omb.omblegal = g_legal #FUN-980012 add
            CALL ogb_omb33()                             #FUN-C90078
            RETURNING mr_omb.omb33,mr_omb.omb331         #FUN-C90078
            LET mr_omb.omb48 = 0   #FUN-D10101 add 
            INSERT INTO omb_file VALUES(mr_omb.*)
            IF SQLCA.SQLCODE THEN
               #CALL cl_err('ins omb',STATUS,1) LET g_success='N'
               CALL cl_err3("ins","omb_file","","",STATUS,"","",0)   #No.FUN-670090
               EXIT FOR
           #str MOD-880005 add
            ELSE
               IF l_oma.oma00 = '12' AND l_oma.oma16 IS NULL THEN
                  IF mr_omb.omb38 = '2' OR mr_omb.omb38 = '4' THEN
                    #FUN-9C0013--mod--str--
                    #UPDATE oga_file SET oga10 = l_oma.oma01,
                    #                    oga05 = l_oma.oma05
                    # WHERE oga01 = mr_omb.omb31
                     #LET ls_sql = "UPDATE ",ms_dbs CLIPPED,"oga_file ",
                     LET ls_sql = "UPDATE ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                                  "   SET oga10 = '",l_oma.oma01,"' ,",
                                  "       oga05 = '",l_oma.oma05,"' ",
                                  " WHERE oga01 = '",mr_omb.omb31,"' "
                     CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
		             CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102               
                     PREPARE upd_oga_pre FROM ls_sql
                     EXECUTE upd_oga_pre 
                    #FUN-9C0013--mod--end
                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                        CALL cl_err3("upd","oga_file",mr_omb.omb31,"",SQLCA.SQLCODE,"","update oga_file",1)
                     END IF
                  END IF
                  IF mr_omb.omb38 = '3' OR mr_omb.omb38 = '5' THEN
                    #FUN-9C0013--mod--str--
                    #UPDATE oha_file SET oha10 = l_oma.oma01
                    # WHERE oha01 = mr_omb.omb31
                     #LET ls_sql = "UPDATE ",ms_dbs CLIPPED,"oha_file ",
                     LET ls_sql = "UPDATE ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                                  "   SET oha10 = '",l_oma.oma01,"' ",
                                  " WHERE oha01 = '",mr_omb.omb31,"' "
                     CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
		             CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102                
                     PREPARE upd_oha_pre FROM ls_sql
                     EXECUTE upd_oha_pre  
                    #FUN-9C0013--mod--end                   
                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                        CALL cl_err3("upd","oha_file",mr_omb.omb31,"",SQLCA.SQLCODE,"","update oha_file",1)
                     END IF
                  END IF
               END IF
               IF l_oma.oma00 ='21' AND l_oma.oma16 IS NULL THEN
                 #FUN-9C0013--mod--str--
                 #UPDATE oha_file SET oha10 = l_oma.oma01
                 # WHERE oha01 = mr_omb.omb31
                  #LET ls_sql = "UPDATE ",ms_dbs CLIPPED,"oha_file ",
                  LET ls_sql = "UPDATE ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                               "   SET oha10 = '",l_oma.oma01,"' ",
                               " WHERE oha01 = '",mr_omb.omb31,"' "
                  CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
		          CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102              
                  PREPARE upd_oha_pre1 FROM ls_sql
                  EXECUTE upd_oha_pre1
                 #FUN-9C0013--mod--end
                   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                      CALL cl_err3("upd","oha_file",mr_omb.omb31,"",SQLCA.SQLCODE,"","update oha_file",1)
                   END IF
               END IF
           #end MOD-880005 add
            END IF
            LET ms_omb03 = ms_omb03 + 1
         END IF    
      END FOR
END FUNCTION
 
FUNCTION ogb_qry_detail()
 
     LET mr_omb.omb31 = mr_ogb.ogb01
     LET mr_omb.omb32 = mr_ogb.ogb03
     LET mr_omb.omb44 = ms_plant        #FUN-9C0013
     LET mr_omb.omb04 = mr_ogb.ogb04
     #LET mr_omb.omb05 = mr_ogb.ogb05   #MOD-790096
     LET mr_omb.omb05 = mr_ogb.ogb916   #MOD-790096
     LET mr_omb.omb06 = mr_ogb.ogb06
    #LET mr_omb.omb12 = mr_ogb.ogb12 - mr_ogb.ogb60   #No:7682
     LET mr_omb.omb12 = s_digqty(mr_omb.omb12,mr_omb.omb05)   #FUN-BB0083 add
     LET mr_omb.omb13 = mr_ogb.ogb13
     LET mr_omb.omb41 = mr_ogb.ogb41                  #MOD-C90161 add
     LET mr_omb.omb42 = mr_ogb.ogb42                  #MOD-C90161 add
     IF ms_oma213 = 'N' THEN
        LET mr_omb.omb14  = mr_omb.omb12  * mr_omb.omb13
        LET mr_omb.omb14t = mr_omb.omb14  * (1 + ms_oma211/100)
     ELSE
        LET mr_omb.omb14t = mr_omb.omb12  * mr_omb.omb13
        LET mr_omb.omb14  = mr_omb.omb14t / (1 + ms_oma211/100)
     END IF
     CALL cl_digcut(mr_omb.omb13,t_azi03) RETURNING mr_omb.omb13    #MOD-870311 add
     CALL cl_digcut(mr_omb.omb14,t_azi04) RETURNING mr_omb.omb14    #MOD-870311 mod g_azi->t_azi
     CALL cl_digcut(mr_omb.omb14t,t_azi04)RETURNING mr_omb.omb14t   #MOD-870311 mod g_azi->t_azi
     LET mr_omb.omb15  = mr_omb.omb13  * ms_oma24
     LET mr_omb.omb16  = mr_omb.omb14  * ms_oma24
     LET mr_omb.omb16t = mr_omb.omb14t * ms_oma24
     #-----MOD-720089---------
     LET mr_omb.omb17  = mr_omb.omb13  * ms_oma58
     LET mr_omb.omb18  = mr_omb.omb14  * ms_oma58
     LET mr_omb.omb18t = mr_omb.omb14t * ms_oma58
     #-----END MOD-720089-----
     IF cl_null(mr_omb.omb17) THEN LET mr_omb.omb17=0 END IF
     IF cl_null(mr_omb.omb18) THEN LET mr_omb.omb18=0 END IF
     IF cl_null(mr_omb.omb18t) THEN LET mr_omb.omb18t=0 END IF
     CALL cl_digcut(mr_omb.omb15,g_azi03) RETURNING mr_omb.omb15    #MOD-870311 mod t_azi04->g_azi03
     CALL cl_digcut(mr_omb.omb16,g_azi04) RETURNING mr_omb.omb16    #MOD-870311 mod t_azi->g_azi
     CALL cl_digcut(mr_omb.omb16t,g_azi04)RETURNING mr_omb.omb16t   #MOD-870311 mod t_azi->g_azi
     CALL cl_digcut(mr_omb.omb17,g_azi03) RETURNING mr_omb.omb17    #MOD-870311 mod t_azi->g_azi
     CALL cl_digcut(mr_omb.omb18,g_azi04) RETURNING mr_omb.omb18    #MOD-870311 mod t_azi->g_azi
     CALL cl_digcut(mr_omb.omb18t,g_azi04)RETURNING mr_omb.omb18t   #MOD-870311 mod t_azi->g_azi
     LET mr_omb.omb34=0 LET mr_omb.omb35=0
 
     MESSAGE mr_omb.omb03,' ',mr_omb.omb04,' ',mr_omb.omb12
END FUNCTION

#FUN-C90078---add--str
FUNCTION ogb_omb33()
DEFINE l_sql    STRING
DEFINE l_oma08  LIKE oma_file.oma08
DEFINE l_oba11  LIKE oba_file.oba11
DEFINE l_oba111 LIKE oba_file.oba111
DEFINE l_ool41  LIKE ool_file.ool41
DEFINE l_ool411 LIKE ool_file.ool411
DEFINE l_oma13  LIKE oma_file.oma13
DEFINE l_omb33  LIKE omb_file.omb33
DEFINE l_omb331 LIKE omb_file.omb331

   IF ms_oma00<>'12' THEN RETURN '','' END IF
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

