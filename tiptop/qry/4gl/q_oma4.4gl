# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name  : q_oma4.4gl
# Program ver.  : 7.0
# Description   : A/R 資料查詢
# Date & Author : 2006/07/10 by Tracy 
# Modify........: No.FUN-670026 06/07/10 By Tracy ls_where中改變一個條件
# Modify........: No.FUN-680022 06/08/18 By cl 增加返回值oob19,金額抓取omc_file
# Modify........:                              資料取值抓取oma_file和omc_file
# Modify........: No.FUN-680131 06/09/01 By Carrier 欄位型態用LIKE定義
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify........: No.TQC-810034 08/01/09 By chenl  增加限制條件，所查資料不可已存在于oob_file中，即oob06若已存在則不能顯示
# Modify........: No.MOD-830231 08/03/28 By chenl   修正TQC-810034中的sql錯誤。
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-980025 09/10/09 By dxfwo hardcode的部分修改
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:MOD-C30743 12/03/15 By yinhy 增加幣種欄位
# Modify.........: No:MOD-D60149 13/06/19 By yinhy q_oma4增加币种传参
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
        #oma01    LIKE oma_file.oma01,                     #No.FUN-680022--mark
         omc01    LIKE omc_file.omc01,  #單號              #No.FUN-680022--add
         oma02    LIKE oma_file.oma02,  #帳款日期 
         odno     LIKE oga_file.oga27,  #單據   #No.FUN-680131 VARCHAR(16)
         omc02    LIKE omc_file.omc02,  #子項次            #No.FUN-680022--add
        #oma54t   LIKE oma_file.oma54t,                    #No.FUN-680022--mark              
        #oma56t   LIKE oma_file.oma56t,                    #No.FUN-680022--mark
        #oma55    LIKE oma_file.oma55,                     #No.FUN-680022--mark
        #oma57    LIKE oma_file.oma57                      #No.FUN-680022--mark
         omc08    LIKE omc_file.omc08,  #原幣應收含稅金額  #No.FUN-680022--add
         omc09    LIKE omc_file.omc09,  #本幣應收含稅金額  #No.FUN-680022--ad,
         omc10    LIKE omc_file.omc10,  #原幣已衝金額      #No.FUN-680022--ad,
         omc11    LIKE omc_file.omc11,   #本幣已衝金額      #No.FUN-680022--ad
         oma23    LIKE oma_file.oma23    #幣種   #MOD-C30743
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
        #No.FUN-680022--begin-- mark
   	#       		oma01  LIKE oma_file.oma01,
        #                       oma02  LIKE oma_file.oma02,
        #                       odno   VARCHAR(16),    
	#       		oma54t LIKE oma_file.oma54t,
	#       		oma56t LIKE oma_file.oma56t,
	#       		oma55  LIKE oma_file.oma55,
	#       		oma57  LIKE oma_file.oma57
        #No.FUN-680022--end-- mark
        #No.FUN-680022--begin-- add
         omc01    LIKE omc_file.omc01,  #單號              #No.FUN-680022--add
         oma02    LIKE oma_file.oma02,  #帳款日期 
         odno     LIKE oga_file.oga27,  #單據   #No.FUN-680131 VARCHAR(16)
         omc02    LIKE omc_file.omc02,  #子項次            #No.FUN-680022--add
         omc08    LIKE omc_file.omc08,  #原幣應收含稅金額  #No.FUN-680022--add
         omc09    LIKE omc_file.omc09,  #本幣應收含稅金額  #No.FUN-680022--ad,
         omc10    LIKE omc_file.omc10,  #原幣已衝金額      #No.FUN-680022--ad,
         omc11    LIKE omc_file.omc11,   #本幣已衝金額      #No.FUN-680022--ad
         oma23    LIKE oma_file.oma23    #幣種   #MOD-C30743
        #No.FUN-680022--end-- add
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING, 
         ms_ret2          STRING,
         ms_ret3          STRING,
         ms_ret4          LIKE omc_file.omc02,  #子項次   #No.FUN-680022 --add  #No.FUN-680131 SMALLINT
         g_cus            LIKE oma_file.oma03,	#No.FUN-680131 VARCHAR(20)
         g_key1           LIKE oob_file.oob02,  #No.FUN-680131 SMALLINT
        #g_key2           LIKE oma_file.oma01,  #No.FUN-680022 mark
         g_key2           LIKE omc_file.omc01,  #No.FUN-680022 add
         g_type           LIKE oma_file.oma00,   #No.FUN-680131 VARCHAR(2)
         g_curr           LIKE ooa_file.ooa23    #MOD-D60149
 
FUNCTION q_oma4(pi_multi_sel,pi_need_cons,ps_default1,p_key1,p_key2,p_cus,p_type,p_curr)  #MOD-D60149 add p_curr
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  , 
            p_key1         LIKE oob_file.oob02,  #No.FUN-680131 SMALLINT
          # p_key2         LIKE oma_file.oma01,  #No.FUN-680022 mark
            p_key2         LIKE omc_file.omc01,  #No.FUN-680022 add
	    p_cus          LIKE oma_file.oma03,	#No.FUN-680131 VARCHAR(20)
	    p_type         LIKE oma_file.oma00,   #No.FUN-680131 VARCHAR(2)
	    p_curr         LIKE ooa_file.ooa23    #MOD-D60149
 
 
   LET ms_default1 = ps_default1
   LET g_cus = p_cus
   LET g_key1 = p_key1
   LET g_key2 = p_key2
   LET g_type = p_type
   LET g_curr = p_curr   #MOD-D60149
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_oma1" ATTRIBUTE(STYLE="create_qry") 
 
   CALL cl_ui_locale("q_oma1")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
    # CALL cl_set_comp_font_color("oma01", "red")  #No.FUN-680022 mark
      CALL cl_set_comp_font_color("omc01", "red")  #No.FUN-680022 add
   END IF
 
   CALL oma4_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1,ms_ret2,ms_ret3,ms_ret4 
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/24 by jack
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oma4_qry_sel()
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
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
           #CONSTRUCT ms_cons_where ON oma01,oma54t,oma56t                             #No.FUN-680022--mark     
           #                      FROM s_oma[1].oma01,s_oma[1].oma54t,s_oma[1].oma56t  #No.FUN-680022--mark
            CONSTRUCT ms_cons_where ON omc01,omc08,omc09                               #No.FUN-680022--add 
                                  FROM s_oma[1].omc01,s_oma[1].omc08,s_oma[1].omc09    #No.FUN-680022--add
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL oma4_qry_prep_result_set() 
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
     
      CALL oma4_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL oma4_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL oma4_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/24 by jack
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION oma4_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
         #No.FUN-680022--begin-- mark
         #     			oma01  LIKE oma_file.oma01,
         #                      oma02  LIKE oma_file.oma02,   
         #                      odno   VARCHAR(16),    
	 #      		oma54t LIKE oma_file.oma54t,
	 #      		oma56t LIKE oma_file.oma56t,
	 #      		oma55  LIKE oma_file.oma55,
	 #      		oma57  LIKE oma_file.oma57
         #No.FUN-680022--end-- mark
        #No.FUN-680022--begin-- add
            omc01    LIKE omc_file.omc01,  #單號              #No.FUN-680022--add
            oma02    LIKE oma_file.oma02,  #帳款日期 
            odno     LIKE oga_file.oga27,  #單據   #No.FUN-680131 VARCHAR(16)
            omc02    LIKE omc_file.omc02,  #子項次            #No.FUN-680022--add
            omc08    LIKE omc_file.omc08,  #原幣應收含稅金額  #No.FUN-680022--add
            omc09    LIKE omc_file.omc09,  #本幣應收含稅金額  #No.FUN-680022--ad,
            omc10    LIKE omc_file.omc10,  #原幣已衝金額      #No.FUN-680022--ad,
            omc11    LIKE omc_file.omc11,   #本幣已衝金額      #No.FUN-680022--ad
            oma23    LIKE oma_file.oma23    #幣種   #MOD-C30743
        #No.FUN-680022--end-- add
   END RECORD
   DEFINE   l_amt1,l_amt2       LIKE oma_file.oma55
   DEFINE   l_oga27             LIKE oga_file.oga27
   DEFINE   l_sql               STRING   
 
   IF g_ooz.ooz07 = 'N' THEN
     #No.FUN-680022--begin-- mark
     #LET ls_sql = "SELECT 'N',oma01,oma02,oma46,oma54t-oma55,oma56t-oma57,0,0 ",
     #             " FROM oma_file ",                                                                                               
     #             " WHERE ",ms_cons_where                                                                                          
     #No.FUN-680022--end-- mark
     #No.FUN-680022--begin-- add
 
      #Begin:FUN-980030
      LET l_filter_cond = cl_get_extra_cond_for_qry('q_oma4', 'oma_file')
      IF NOT cl_null(l_filter_cond) THEN
         LET ms_cons_where = ms_cons_where,l_filter_cond
      END IF
      #End:FUN-980030
      LET ls_sql = "SELECT 'N',omc01,oma02,oma16,omc02,omc08-omc10,omc09-omc11,0,0,oma23 ",  #MOD-C30743 add oma23
                   " FROM omc_file,oma_file",                                                                                               
                   " WHERE oma01=omc01 AND ",ms_cons_where                                                                                          
     #No.FUN-680022--end-- add
   ELSE
     #No.FUN-680022--begin-- mark
     #LET ls_sql = "SELECT 'N',oma01,oma02,oma46,oma54t-oma55,oma61,0,0 ",    
     #             " FROM oma_file ",
     #             " WHERE ",ms_cons_where
     #No.FUN-680022--end-- mark
     #No.FUN-680022--begin-- add
      LET ls_sql = "SELECT 'N',oma01,oma02,oma16,omc02,omc08-omc10,omc13,0,0,oma23 ",      #MOD-C30743 add oma23
                   " FROM omc_file,oma_file ",
                   " WHERE oma01=omc01 AND ",ms_cons_where
     #No.FUN-680022--end-- add
   END IF                                                                                                                           
  #No.TQC-810034--begin-- 
   LET ls_sql = ls_sql," AND oma01 NOT IN (SELECT oob06 FROM oob_file WHERE oob01='",g_key2 CLIPPED,"' AND oob06 IS NOT NULL ) "  #No.MOD-830231 add oob06 is not null
  #No.TQC-810034---end---
   IF NOT mi_multi_sel THEN
#     LET ls_where = "   AND oma03 ='",g_cus,"'",          #No.FUN-670026 mark
      LET ls_where = "   AND oma68 ='",g_cus CLIPPED,"'",  #No.FUN-670026
                   # "   AND oma54t > oma55 ",     #No.FUN-680022-- mark
                     "   AND omc08  > omc10 ",     #No.FUN-680022-- add
                     "   AND omaconf = 'Y' "
   END IF
   IF NOT cl_null(g_type) THEN
      LET ls_where = ls_where CLIPPED, " AND oma00 MATCHES '",g_type,"'"
   END IF
   #No.MOD-D60149  --Begin
   IF NOT cl_null(g_type) THEN
   	  LET ls_where = ls_where CLIPPED, " AND oma23 = '",g_curr,"'"
   END IF
   #No.MOD-D60149  --End
  #LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY oma02 "   #No.FUN-680022 mark
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY oma02,omc02 "   #No.FUN-680022 add
 
  ##NO.FUN-980025 GP5.2 add--begin						
   IF (NOT mi_multi_sel ) THEN						
        CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql						
   END IF						
  ##NO.FUN-980025 GP5.2 add--end
 
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
 
      LET l_amt1 = 0
      LET l_amt2 = 0
      IF g_type = '2*' THEN
         SELECT SUM(oob09),SUM(oob10) INTO l_amt1,l_amt2
           FROM oob_file,ooa_file
        # WHERE oob06 = lr_qry.oma01        #No.FUN-680022 mark
          WHERE oob06 = lr_qry.omc01        #No.FUN-680022 add
            AND oob19 = lr_qry.omc02        #No.FUN-680022 add
            AND (oob01 <> g_key2 OR oob02 <> g_key1)
            AND oob01 = ooa01 AND ooaconf = "N"
            AND oob03 = '1' AND oob04 = '3'
         IF STATUS OR (l_amt1 IS NULL) THEN
            LET l_amt1 = 0
            LET l_amt2 = 0
         END IF
        #LET lr_qry.oma55 = lr_qry.oma54t - l_amt1  #No.FUN-680022 mark  
        #LET lr_qry.oma57 = lr_qry.oma56t - l_amt2  #No.FUN-680022 mark
         LET lr_qry.omc10 = lr_qry.omc08  - l_amt1  #No.FUN-680022 add 
         LET lr_qry.omc11 = lr_qry.omc09  - l_amt2  #No.FUN-680022 add
      ELSE
         LET l_oga27 = ''
         LET l_sql = "SELECT oga27 FROM oga_file ",
                   # " WHERE oga10 = '",lr_qry.oma01,"'"   #No.FUN-680022 mark
                     " WHERE oga10 = '",lr_qry.omc01,"'"   #No.FUN-680022 add
         PREPARE oga27_p FROM l_sql
         DECLARE oga27_c CURSOR FOR oga27_p
         OPEN oga27_c
         FETCH oga27_c INTO l_oga27
         LET lr_qry.odno = l_oga27
         SELECT SUM(oob09),SUM(oob10) INTO l_amt1,l_amt2
           FROM oob_file,ooa_file
         #WHERE oob06 = lr_qry.oma01     #No.FUN-680022 mark
          WHERE oob06 = lr_qry.omc01     #No.FUN-680022 add
            AND oob19 = lr_qry.omc02     #No.FUN-680022 add
            AND (oob01 <> g_key2 OR oob02 <> g_key1)
            AND oob01 = ooa01 AND ooaconf = "N"
            AND oob03 = "2" AND oob04 = "1"
         IF STATUS OR (l_amt1 IS NULL) THEN
            LET l_amt1 = 0
            LET l_amt2 = 0
         END IF
        #LET lr_qry.oma55 = lr_qry.oma54t - l_amt1  #No.FUN-680022 mark  
        #LET lr_qry.oma57 = lr_qry.oma56t - l_amt2  #No.FUN-680022 mark
         LET lr_qry.omc10 = lr_qry.omc08  - l_amt1  #No.FUN-680022 add 
         LET lr_qry.omc11 = lr_qry.omc09  - l_amt2  #No.FUN-680022 add
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
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/24 by jack
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION oma4_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/24 by jack
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION oma4_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oma.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oma.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_oma.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oma4_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_oma.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oma4_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL oma4_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_oma.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL oma4_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL oma4_qry_accept(pi_start_index+ARR_CURR()-1)
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
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
   
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
# Date & Author : 2003/09/24 by jack
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oma4_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/24 by jack
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION oma4_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_oma.*
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
         CALL oma4_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
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
   
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2003/09/24 by jack
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION oma4_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/24 by jack
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oma4_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	#No.FUN-680131 INTEGER
 
 
   # GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
             # CALL lsb_multi_sel.append(ma_qry[li_i].oma01 CLIPPED)  #No.FUN-680022 mark
               CALL lsb_multi_sel.append(ma_qry[li_i].omc01 CLIPPED)  #No.FUN-680022 add
            ELSE
             # CALL lsb_multi_sel.append("|" || ma_qry[li_i].oma01 CLIPPED)  #No.FUN-680022 mark
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].omc01 CLIPPED)  #No.FUN-680022 add
            END IF
         END IF    
      END FOR
      # 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
     #No.FUN-680022--begin-- mark
     #LET ms_ret1 = ma_qry[pi_sel_index].oma01 CLIPPED
     #LET ms_ret2 = ma_qry[pi_sel_index].oma55 CLIPPED
     #LET ms_ret3 = ma_qry[pi_sel_index].oma57 CLIPPED
     #No.FUN-680022--end-- mark
     #No.FUN-680022--begin-- add
      LET ms_ret1 = ma_qry[pi_sel_index].omc01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].omc10 CLIPPED
      LET ms_ret3 = ma_qry[pi_sel_index].omc11 CLIPPED
      LET ms_ret4 = ma_qry[pi_sel_index].omc02
     #No.FUN-680022--end-- add
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
