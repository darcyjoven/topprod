# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#{
# Program name   : q_ohb1.4gl
# Program ver.   : 7.0
# Description    : 銷對單資料查詢
# Date & Author  : 2004/02/25 by saki
# Memo           : 
# Modify.........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-670090 07/01/15 BY yiting cl_err->cl_err333
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.MOD-790096 07/09/20 By Smapmin 單位/數量改抓計價單位/計價數量
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.MOD-870209 08/07/21 By Smapmin omb38未給值
# Modify.........: No.MOD-870311 08/08/01 By Sarah 取位時原幣應該用t_azi(以oma23抓取),本幣用g_azi,兩者顛倒了
# Modify.........: No.MOD-880005 08/08/08 By Sarah 寫入omb_file後,要回寫來源單據的帳單編號欄位
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-890208 08/09/24 By chenl 增加銷退日期與立賬日期的稽核
# Modify.........: No.MOD-8B0127 08/11/13 By chenl 對MOD-890208進行調整。
# Modify.........: No.MOD-8C0085 08/12/09 By chenl 若該單號不產生AR則不顯示
# Modify.........: No.MOD-8C0192 08/12/22 By Sarah 計算數量時,需再扣除已立帳未確認的數量
# Modify.........: No.MOD-940155 09/04/11 By Sarah AND ohb60 < ohb917改成AND ((oha09!='5' AND ohb60 < ohb917) OR oha09='5')
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定 
# Modify.........: No.FUN-9A0093 09/11/01 By lutingting增加參數PLANT
# Modify.........: No.FUN-9C0013 09/12/03 By lutingting 延續FUN-9A0093得問題 
# Modify.........: No.FUN-9C0041 09/12/15 By lutingting 跨庫要去實體DB抓取資料
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:MOD-A10107 10/01/19 By Sarah 開窗應只能選取已庫存過帳的銷退單
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A90154 10/09/23 By Dido 折讓若已存在立帳則不可顯示;增加折讓金額欄位 
# Modify.........: No:MOD-B20044 11/02/15 By Dido omb40 給予預設值  
# Modify.........: No:FUN-BB0083 11/12/19 By xujing 增加數量欄位小數取位
# Modify.........: No.FUN-D10101 13/01/22 By lujh axrt300單身新增已開票數量欄位，賦默認值0

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         oha01    LIKE oha_file.oha01,
         oha02    LIKE oha_file.oha02,
         ohb03    LIKE ohb_file.ohb03,
         ohb04    LIKE ohb_file.ohb04,
         ohb091   LIKE ohb_file.ohb091,
         #ohb12    LIKE ohb_file.ohb12,   #MOD-790096
         ohb917   LIKE ohb_file.ohb917,   #MOD-790096
         ohb60    LIKE ohb_file.ohb60,    #MOD-A90154
         ohb14    LIKE ohb_file.ohb14     #MOD-A90154
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         oha01        LIKE oha_file.oha01,
         oha02        LIKE oha_file.oha02,
         ohb03        LIKE ohb_file.ohb03,
         ohb04        LIKE ohb_file.ohb04,
         ohb091       LIKE ohb_file.ohb091,
         #ohb12        LIKE ohb_file.ohb12,   #MOD-790096
         ohb917       LIKE ohb_file.ohb917,   #MOD-790096
         ohb60        LIKE ohb_file.ohb60,    #MOD-A90154
         ohb14        LIKE ohb_file.ohb14     #MOD-A90154
END RECORD
DEFINE   ms_omb03     LIKE omb_file.omb03,
         ms_oma01     LIKE oma_file.oma01,
         ms_oma213    LIKE oma_file.oma213,
         ms_oma211    LIKE oma_file.oma211,
         ms_oma24     LIKE oma_file.oma24,
         ms_oma58     LIKE oma_file.oma58, #MOD-940155 add
         ms_cus       LIKE oha_file.oha03
DEFINE   ms_oma00     LIKE oma_file.oma00  #No.MOD-890208
DEFINE   ms_oma02     LIKE oma_file.oma02  #No.MOD-890208
DEFINE   mr_omb       RECORD LIKE omb_file.*
DEFINE   mr_ohb       RECORD LIKE ohb_file.*
DEFINE   g_omb12      LIKE omb_file.omb12  #MOD-8C0192 add
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_dbs           LIKE type_file.chr21        #FUN-9A0093
DEFINE   ms_plant         LIKE type_file.chr10        #FUN-9A0093 

#FUNCTION q_ohb1(pi_multi_sel,pi_need_cons,ps_cus,ps_oma01,ps_oma213,ps_oma211,ps_oma24)     #No.MOD-890208 mark
FUNCTION q_ohb1(pi_multi_sel,pi_need_cons,ps_cus,ps_oma01,ps_oma213,ps_oma211,ps_oma24,ps_oma00,ps_oma02,ps_plant)  #No.MOD-890208    #FUN-9A0093 add plant
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_cus         LIKE oha_file.oha03,
            ps_oma01       LIKE oma_file.oma01,
            ps_oma213      LIKE oma_file.oma213,
            ps_oma211      LIKE oma_file.oma211,
            ps_oma24       LIKE oma_file.oma24 
   DEFINE   ps_oma00       LIKE oma_file.oma00   #No.MOD-890208
   DEFINE   ps_oma02       LIKE oma_file.oma02   #No.MOD-890208
   DEFINE   ps_plant      LIKE type_file.chr10   #FUN-9A0093 
 
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
   LET ms_oma00  = ps_oma00  #No.MOD-890208
   LET ms_oma02  = ps_oma02  #No.MOD-890208
   LET ms_plant  = ps_plant  #FUN-9A0093  

   OPEN WINDOW w_qry WITH FORM "qry/42f/q_ohb1" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161
 
   CALL cl_ui_locale("q_ohb1")
 
   LET mi_multi_sel = TRUE
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   DISPLAY ms_cus TO FORMONLY.oha03 
 
   CALL ohb1_qry_sel()
 
   CLOSE WINDOW w_qry
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2004/02/25 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ohb1_qry_sel()
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
            #CONSTRUCT BY NAME ms_cons_where ON oha01,oha02,ohb03,ohb04,ohb091,ohb12,ohb60   #MOD-790096
            CONSTRUCT BY NAME ms_cons_where ON oha01,oha02,ohb03,ohb04,ohb091,ohb917,ohb60   #MOD-790096
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL ohb1_qry_prep_result_set() 
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
     
      CALL ohb1_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL ohb1_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL ohb1_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2004/02/25 by saki
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION ohb1_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            oha01      LIKE oha_file.oha01,
            oha02      LIKE oha_file.oha02,
            ohb03      LIKE ohb_file.ohb03,
            ohb04      LIKE ohb_file.ohb04,
            ohb091     LIKE ohb_file.ohb091,
            #ohb12      LIKE ohb_file.ohb12,   #MOD-790096
            ohb917     LIKE ohb_file.ohb917,   #MOD-790096
            ohb60      LIKE ohb_file.ohb60,    #MOD-A90154
            ohb14      LIKE ohb_file.ohb14     #MOD-A90154
   END RECORD
DEFINE l_slip          LIKE oay_file.oayslip  #No.MOD-8C0085
DEFINE l_oay11         LIKE oay_file.oay11    #No.MOD-8C0085
DEFINE l_oha09         LIKE oha_file.oha09    #MOD-940155 add
DEFINE l_cnt           LIKE type_file.num5    #MOD-A90154
 
  #No.MOD-890208--begin--
   IF ms_oma00 = '21' THEN 
     #No.MOD-8B0127--begin-- modify
     #LET ms_cons_where = ms_cons_where ," AND YEAR(oha02) = YEAR('",ms_oma02,"') ", 
     #                                  " AND MONTH(oha02) = MONTH('",ms_oma02,"') "
      IF NOT cl_null(ms_oma02) THEN 
         LET ms_cons_where = ms_cons_where ," AND oha02 <= '",ms_oma02,"'"
      END IF 
     #No.MOD-8B0127---end--- modify
   END IF 
  #No.MOD-890208---end---
 
   #LET ls_sql = "SELECT 'N',oha01,oha02,ohb03,ohb04,ohb091,ohb12,ohb60",    #MOD-790096
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_ohb1', 'ohb_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',oha01,oha02,ohb03,ohb04,ohb091,ohb917,ohb60,ohb14",  #MOD-790096 #MOD-A90154 add ohb14
                #" FROM oha_file,ohb_file",    #FUN-9A0093 mark
                #"  FROM ",ms_dbs CLIPPED,"oha_file,",ms_dbs CLIPPED,"ohb_file ",    #FUN-9A0093
                "  FROM ",cl_get_target_table(g_plant_new,'oha_file'),",", #FUN-A50102
                          cl_get_target_table(g_plant_new,'ohb_file'),     #FUN-A50102
                " WHERE ",ms_cons_where CLIPPED,
                "   AND oha01 = ohb01",
                "   AND oha03 = '",ms_cus CLIPPED,"'",
                #"   AND ohb60 < ohb12 ",   #MOD-790096
               #"   AND ohb60 < ohb917 ",   #MOD-790096                   #MOD-940155 mark
                "   AND ((oha09!='5' AND ohb60 < ohb917) OR oha09='5')",  #MOD-940155
                "   AND ohaconf = 'Y' ",
                "   AND ohapost = 'Y'",  #MOD-A10107 add
                " ORDER BY oha01,ohb03 "
#FUN-990069---begin 
   #IF (NOT mi_multi_sel ) THEN
   #   #FUN-9A0093--add--str--
   #   IF NOT cl_null(ms_plant) THEN
   #      CALL cl_parse_qry_sql( ls_sql, ms_plant ) RETURNING ls_sql
   #   ELSE
   #   #FUN-9A0093--aadd--end
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
 
      #No.MOD-8C0085--begin--
      CALL s_get_doc_no(lr_qry.oha01) RETURNING l_slip
     #FUN-9C0013--mod--str--
     #SELECT oay11 INTO l_oay11 FROM oay_file WHERE oayslip = l_slip
      #LET ls_sql = "SELECT oay11 FROM ",ms_dbs CLIPPED,"oay_file ",
      LET ls_sql = "SELECT oay11 FROM ",cl_get_target_table(g_plant_new,'oay_file'), #FUN-A50102
                   " WHERE oayslip = '",l_slip,"' "
      CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102             
      PREPARE sel_oay11_pre FROM ls_sql
      EXECUTE sel_oay11_pre INTO l_oay11
     #FUN-9C0013--mod--end
      IF l_oay11<> 'Y' THEN
         CONTINUE FOREACH
      END IF
      #No.MOD-8C0085---end---
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
     #str MOD-8C0192 add
      LET g_omb12 = 0
      SELECT abs(SUM(omb12)) INTO g_omb12 FROM oma_file,omb_file
       WHERE oma01=omb01 AND omavoid='N'
         AND omb31=lr_qry.oha01 AND omb32=lr_qry.ohb03
         AND omb44=ms_plant    #FUN-9C0013
      IF cl_null(g_omb12) THEN LET g_omb12=0 END IF
      #當 已開折讓數量ohb60+已立帳折讓數量g_omb12 = 計價數量ohb917,
      #就表示此銷退單+項次已全數立帳,開窗不可再秀出此筆資料
      #str MOD-940155 add
     #FUN-9C0013--mod--str--
     #SELECT oha09 INTO l_oha09 FROM oha_file WHERE oha01=lr_qry.oha01
      #LET ls_sql = "SELECT oha09 FROM ",ms_dbs CLIPPED,"oha_file ",
      LET ls_sql = "SELECT oha09 FROM ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                   " WHERE oha01='",lr_qry.oha01,"' "
      CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102              
      PREPARE sel_oha09_pre FROM ls_sql
      EXECUTE sel_oha09_pre INTO l_oha09
     #FUN-9C0013--mod--end
      IF cl_null(l_oha09) THEN LET l_oha09=' ' END IF
      IF l_oha09!='5' THEN   #當銷退類別為5.折讓時,因銷退數量為0,故不需比較
      #end MOD-940155 add
         IF lr_qry.ohb60+g_omb12 = lr_qry.ohb917 THEN
            CONTINUE FOREACH
         END IF
     #-MOD-A90154-add-
      ELSE
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM oma_file,omb_file
          WHERE oma01=omb01 AND omavoid='N'
            AND omb31=lr_qry.oha01 AND omb32=lr_qry.ohb03
         IF l_cnt > 0 THEN
            CONTINUE FOREACH
         END IF
     #-MOD-A90154-end-
      END IF   #MOD-940155 add
     #end MOD-8C0192 add
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2004/02/25 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION ohb1_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2004/02/25 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ohb1_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ohb.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ohb.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_ohb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ohb1_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ohb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ohb1_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL ohb1_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_ohb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL ohb1_qry_reset_multi_sel(pi_start_index, pi_end_index)
            IF cl_sure(0,0) THEN
               CALL ohb1_qry_accept(pi_start_index+ARR_CURR()-1)
            ELSE
               CLOSE WINDOW w_qry 
            END IF
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         LET li_continue = FALSE
     
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--
   
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
# Date & Author : 2004/02/25 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ohb1_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2004/02/25 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ohb1_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_ohb.*
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
         CALL ohb1_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--
 
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
   END DISPLAY
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2004/02/25 by saki
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION ohb1_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2004/02/25 by saki
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ohb1_qry_accept(pi_sel_index)
   DEFINE pi_sel_index    LIKE type_file.num10 	   #No.FUN-680131 INTEGER
   DEFINE li_i            LIKE type_file.num10     #No.FUN-680131 INTEGER
   DEFINE l_oma930        LIKE oma_file.oma930     #FUN-680006
   DEFINE l_oma           RECORD LIKE oma_file.*   #MOD-880005 add 
   DEFINE l_oha09         LIKE oha_file.oha09      #MOD-940155 add
   DEFINE ls_sql          STRING                   #FUN-9C0013 

   #MESSAGE 'WORKING....' ATTRIBUTES(YELLOW)   #FUN-9A0093  編譯報錯
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
         SELECT oma930 INTO l_oma930 FROM oma_file
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
           #SELECT * INTO mr_ohb.* FROM ohb_file
           # WHERE ohb01=ma_qry[li_i].oha01 AND ohb03=ma_qry[li_i].ohb03
            #LET ls_sql = "SELECT * FROM ",ms_dbs CLIPPED,"ohb_file ",
           LET ls_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102 
                         " WHERE ohb01='",ma_qry[li_i].oha01,"' ",
                         "   AND ohb03='",ma_qry[li_i].ohb03,"' "
            CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102 
            PREPARE sel_oha_pre FROM ls_sql
            EXECUTE sel_oha_pre INTO mr_ohb.*
           #FUN-9C0013--mod--end
            INITIALIZE mr_omb.* TO NULL
            LET mr_omb.omb01 = ms_oma01
            LET mr_omb.omb03 = ms_omb03
            CALL q_ohb_detail()
            LET mr_omb.omb930=l_oma930  #FUN-680006
            LET mr_omb.omb38 = '3'   #MOD-870209
            LET mr_omb.omb40 = mr_ohb.ohb50   #MOD-B20044
           #str MOD-940155 add
           #FUN-9C0013--mod--str--
           #SELECT oha09 INTO l_oha09 FROM oha_file
           # WHERE oha01=ma_qry[li_i].oha01
            #LET ls_sql = "SELECT oha09 FROM ",ms_dbs CLIPPED,"oha_file ",
            LET ls_sql = "SELECT oha09 FROM ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                         " WHERE oha01='",ma_qry[li_i].oha01,"' "
            CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102 
            PREPARE sel_oha09_pre2 FROM ls_sql
            EXECUTE sel_oha09_pre2 INTO l_oha09
           #FUN-9C0013--mod--end
            IF cl_null(l_oha09) THEN LET l_oha09=' ' END IF
            IF l_oha09!='5' THEN   #當銷退類別為5.折讓時,因銷退數量為0,故不需比較
           #end MOD-940155 add
               IF mr_omb.omb12 = 0 THEN CONTINUE FOR END IF   #MOD-8C0192 add
            END IF        #MOD-940155 add
            LET mr_omb.omblegal = g_legal #FUN-980012 add
            LET mr_omb.omb48 = 0   #FUN-D10101 add
            INSERT INTO omb_file VALUES(mr_omb.*)
            LET ms_omb03 = ms_omb03 + 1
            IF STATUS THEN 
               #CALL cl_err('ins omb',STATUS,1)
               CALL cl_err3("ins","omb_file","","",STATUS,"","",1)   #No.FUN-670090
               EXIT FOR
               LET g_success='N'
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
                     PREPARE upd_oha_pre1 FROM ls_sql
                     EXECUTE upd_oha_pre1 
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
                  PREPARE upd_oha_pre2 FROM ls_sql
                  EXECUTE upd_oha_pre2
                 #FUN-9C0013--mod--end
                   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                      CALL cl_err3("upd","oha_file",mr_omb.omb31,"",SQLCA.SQLCODE,"","update oha_file",1)
                   END IF
               END IF
           #end MOD-880005 add
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
 
FUNCTION q_ohb_detail()
   DEFINE l_oha09     LIKE oha_file.oha09    #MOD-940155 add
   DEFINE l_oma00     LIKE oma_file.oma00    #MOD-940155 add
   DEFINE ls_sql      STRING                 #FUN-9C0013 

   LET mr_omb.omb31 = mr_ohb.ohb01
   LET mr_omb.omb32 = mr_ohb.ohb03
   LET mr_omb.omb44 = ms_plant        #FUN-9C0013
   LET mr_omb.omb04 = mr_ohb.ohb04
   #LET mr_omb.omb05 = mr_ohb.ohb05   #MOD-790096
   LET mr_omb.omb05 = mr_ohb.ohb916   #MOD-790096
   LET mr_omb.omb06 = mr_ohb.ohb06
  #str MOD-8C0192 add
   LET g_omb12 = 0
   SELECT abs(SUM(omb12)) INTO g_omb12 FROM oma_file,omb_file
    WHERE oma01=omb01 AND omavoid='N'
      AND omb31=mr_ohb.ohb01 AND omb32=mr_ohb.ohb03
      AND omb44=ms_plant   #FUN-9C0013
   IF cl_null(g_omb12) THEN LET g_omb12=0 END IF
  #end MOD-8C0192 add
   #LET mr_omb.omb12 = mr_ohb.ohb12 - mr_ohb.ohb60   #MOD-790096
  #LET mr_omb.omb12 = mr_ohb.ohb917 - mr_ohb.ohb60   #MOD-790096            #MOD-8C0192 mark
   LET mr_omb.omb12 = mr_ohb.ohb917 - mr_ohb.ohb60 - g_omb12   #MOD-790096  #MOD-8C0192
   LET mr_omb.omb12 = s_digqty(mr_omb.omb12,mr_omb.omb05)      #FUN-BB0083 add
   LET mr_omb.omb13 = mr_ohb.ohb13
   IF ms_oma213 = 'N' THEN
      LET mr_omb.omb14  = mr_omb.omb12  * mr_omb.omb13
      LET mr_omb.omb14t = mr_omb.omb14  * (1 + ms_oma211/100)
   ELSE
      LET mr_omb.omb14t = mr_omb.omb12  * mr_omb.omb13
      LET mr_omb.omb14  = mr_omb.omb14t / (1 + ms_oma211/100)
   END IF
  #str MOD-940155 add
   SELECT oma00,oma58 INTO l_oma00,ms_oma58 FROM oma_file WHERE oma01=ms_oma01
   IF cl_null(ms_oma58) THEN LET ms_oma58=1 END IF
  #選擇的銷退單其銷退方式為5.折讓時,金額直接帶銷退單的金額
  #FUN-9C0013--mod--str--
  #SELECT oha09 INTO l_oha09 FROM oha_file
  # WHERE oha01=mr_ohb.ohb01
   #LET ls_sql = "SELECT oha09 FROM ",ms_dbs CLIPPED,"oha_file ",
   LET ls_sql = "SELECT oha09 FROM ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                " WHERE oha01='",mr_ohb.ohb01,"' "
   CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102              
   PREPARE sel_oha09_pre1 FROM ls_sql
   EXECUTE sel_oha09_pre1 INTO l_oha09
  #FUN-9C0013--mod--end
   IF cl_null(l_oha09) THEN LET l_oha09=' ' END IF
   IF l_oha09 = '5' THEN
      IF l_oma00='21' THEN
         LET mr_omb.omb14 = mr_ohb.ohb14
         LET mr_omb.omb14t= mr_ohb.ohb14t
      ELSE
         LET mr_omb.omb14 = mr_ohb.ohb14 * -1
         LET mr_omb.omb14t= mr_ohb.ohb14t* -1
      END IF
   END IF
  #end MOD-940155 add
   CALL cl_digcut(mr_omb.omb13,t_azi03) RETURNING mr_omb.omb13   #MOD-870311 add
   CALL cl_digcut(mr_omb.omb14,t_azi04) RETURNING mr_omb.omb14   #MOD-790096
   CALL cl_digcut(mr_omb.omb14t,t_azi04)RETURNING mr_omb.omb14t  #MOD-790096
   LET mr_omb.omb15  = mr_omb.omb13  * ms_oma24
   LET mr_omb.omb16  = mr_omb.omb14  * ms_oma24
   LET mr_omb.omb16t = mr_omb.omb14t * ms_oma24
   LET mr_omb.omb18  = mr_omb.omb14  * ms_oma58   #MOD-940155 add
   LET mr_omb.omb18t = mr_omb.omb14t * ms_oma58   #MOD-940155 add
   CALL cl_digcut(mr_omb.omb15,g_azi03) RETURNING mr_omb.omb15   #MOD-790096   #MOD-870311 mod g_azi04->g_azi03
   CALL cl_digcut(mr_omb.omb16,g_azi04) RETURNING mr_omb.omb16   #MOD-790096
   CALL cl_digcut(mr_omb.omb16t,g_azi04)RETURNING mr_omb.omb16t  #MOD-790096
   CALL cl_digcut(mr_omb.omb18,g_azi04) RETURNING mr_omb.omb18   #MOD-940155 add
   CALL cl_digcut(mr_omb.omb18t,g_azi04)RETURNING mr_omb.omb18t  #MOD-940155 add
   MESSAGE mr_omb.omb03,' ',mr_omb.omb04,' ',mr_omb.omb12
END FUNCTION
