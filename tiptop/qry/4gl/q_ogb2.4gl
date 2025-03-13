# Prog. Version..: '5.30.06-13.04.02(00010)'     #

# Program name   : q_ogb2.4gl
# Program ver.   : 7.0
# Date & Author  : 2006/07/20 cl
# Modify.........: No.MOD-530692 By day 數量重復計算
# Modify.........: No.FUN-610020 06/01/18 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify.........: No.FUN-680131 06/09/01 By Carrier 欄位型態用LIKE定義
# Modify.........: No.TQC-6C0085 06/12/18 By chenl  修正sql錯誤。
# Modify.........: No.FUN-670090 07/01/15 BY yiting cl_err->cl_err3
# Modify.........: No.TQC-7A0120 07/11/22 By chenl  sql修正
# Modify.........: No.TQC-790152 07/11/27 By chenl  對來源類型賦值。
# Modify.........: No.MOD-820066 08/02/17 By chenl  修改金額計算，將單價*折扣率后進行取位，再與數量相乘得到金額。
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.MOD-830016 08/07/15 By jan  修正MOD-820066。需判斷折扣率是否為null，若為null則應該賦值為100
# Modify.........: No.MOD-870209 08/07/21 By Smapmin omb38未給值
# Modify.........: No.MOD-870311 08/08/01 By Sarah 取位時原幣應該用t_azi(以oma23抓取),本幣用g_azi,兩者顛倒了
# Modify.........: No.MOD-880005 08/08/08 By Sarah 寫入omb_file後,要回寫來源單據的帳單編號欄位
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-8B0081 08/11/07 By chenl 單身發票單價及金額帶默認值。
# Modify.........: No.MOD-8B0127 08/11/13 By chenl 增加數據篩選功能，單據日期應小于等于立賬年月
# Modify.........: No.MOD-8B0256 08/11/25 By wujie 從出貨單帶資料時
#                                                  1：沒有把不同稅別的資料排除
#                                                  2：沒有帶出omb17，omb18，omb18t
# Modify.........: No.MOD-8C0211 08/12/23 By chenl 1.若出貨單單別未勾選轉AR，則不顯示單據。
#                                                  2.增加MOD-790096單據修改內容。將ogb12->ogb917
# Modify.........: No.MOD-920309 09/02/24 By liuxqa 1.如果出貨單同時使用了多倉批和料件替代的功能
#                                                     在INSERT omb_file時，未考慮ogc_file的資料。
#                                                     和ogc17新的料件不一致，造成立賬單身料號和真正的異動料號不一致。
# Modify.........: No.MOD-930277 09/03/26 By chenl  增加篩選條件，內外銷需對應。
# Modify.........: No.TQC-940147 09/04/24 By liuxqa mark MOD-920309 
# Modify.........: No.TQC-950128 09/05/21 By xiaofeizhu 修改開窗失敗的問題
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定 
# Modify.........: No.FUN-9B0156 09/11/30 By alex 調整ATTRIBUTES
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:FUN-BB0083 11/12/19 By xujing 增加數量欄位小數取位
# Modify.........: No.MOD-C10012 12/01/10 By Polly omb31開窗查詢排除已立帳之出貨單
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
        #ogb12    LIKE ogb_file.ogb12,   #No.MOD-8C0211
         ogb917   LIKE ogb_file.ogb917,  #No.MOD-8C0211
         ogb60    LIKE ogb_file.ogb60
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         oga01        LIKE oga_file.oga01,
         oga02        LIKE oga_file.oga02,
         ogb03        LIKE ogb_file.ogb03,
         ogb04        LIKE ogb_file.ogb04,
         ogb091       LIKE ogb_file.ogb091,
        #ogb12        LIKE ogb_file.ogb12,  #No.MOD-8C0211
         ogb917       LIKE ogb_file.ogb917, #No.MOD-8C0211
         ogb60        LIKE ogb_file.ogb60
END RECORD
DEFINE   ms_cus       LIKE oga_file.oga03,
         ms_oma01     LIKE oma_file.oma01,
         ms_oma213    LIKE oma_file.oma213,
         ms_oma211    LIKE oma_file.oma211,
         ms_oma24     LIKE oma_file.oma24,
         ms_omb03     LIKE omb_file.omb03,
         ms_omb12     LIKE omb_file.omb12,
         ms_oma68     LIKE oma_file.oma68,
         ms_omb38     LIKE omb_file.omb38   #MOD-870209
DEFINE   mr_ogb       RECORD LIKE ogb_file.*,
         mr_omb       RECORD LIKE omb_file.*
#         mr_ogc       RECORD LIKE ogc_file.*   #No.MOD-920309 add by liuxqa#TQC-940147 
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
 
#FUNCTION q_ogb2(pi_multi_sel,pi_need_cons,ps_cus,ps_oma01,ps_oma213,ps_oma211,ps_oma24,ps_oma68)   #MOD-870209
FUNCTION q_ogb2(pi_multi_sel,pi_need_cons,ps_cus,ps_oma01,ps_oma213,ps_oma211,ps_oma24,ps_oma68,ps_omb38)   #MOD-870209
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_cus         LIKE oga_file.oga03,
            ps_oma01       LIKE oma_file.oma01,
            ps_oma213      LIKE oma_file.oma213,
            ps_oma211      LIKE oma_file.oma211,
            ps_oma24       LIKE oma_file.oma24,
            ps_oma68       LIKE oma_file.oma68,
            ps_omb38       LIKE omb_file.omb38   #MOD-870209
 
   WHENEVER ERROR CONTINUE
 
   LET ms_cus    = ps_cus   
   LET ms_oma01  = ps_oma01 
   LET ms_oma213 = ps_oma213
   LET ms_oma211 = ps_oma211
   LET ms_oma24  = ps_oma24 
   LET ms_oma68  = ps_oma68    #No.TQC-6C0085 
   LET ms_omb38  = ps_omb38   #MOD-870209
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_ogb" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_ogb")
 
   LET mi_multi_sel = TRUE
   LET mi_need_cons = pi_need_cons
 
   CALL ogb2_qry_sel()
 
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
FUNCTION ogb2_qry_sel()
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
   LET ms_cons_where = NULL #No.MOD-8B0127 
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
           #CONSTRUCT BY NAME ms_cons_where ON oga01,oga02,ogb03,ogb04,ogb091,ogb12,ogb60  #No.MOD-8C0211
            CONSTRUCT BY NAME ms_cons_where ON oga01,oga02,ogb03,ogb04,ogb091,ogb917,ogb60 #No.MOD-8C0211
     
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
     
         CALL ogb2_qry_prep_result_set() 
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
     
      CALL ogb2_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL ogb2_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL ogb2_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION ogb2_qry_prep_result_set()
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
           #ogb12      LIKE ogb_file.ogb12,   #No.MOD-8C0211
            ogb917     LIKE ogb_file.ogb917,  #No.MOD-8C0211
            ogb60      LIKE ogb_file.ogb60
   END RECORD
   DEFINE   l_oma02    LIKE type_file.dat     #No.MOD-8B0127 
   DEFINE   l_oga07    LIKE oga_file.oga07    #No.MOD-8B0127
   DEFINE   l_oma21    LIKE oma_file.oma21    #No.MOD-8B0256
   DEFINE   l_slip     LIKE oay_file.oayslip  #No.MOD-8C0211 
   DEFINE   l_oay11    LIKE oay_file.oay11    #No.MOD-8C0211 
   DEFINE   l_oma08    LIKE oma_file.oma08    #No.MOD-930277
   DEFINE   l_omb12    LIKE omb_file.omb12    #MOD-C10012 add
   DEFINE   l_ogbplant LIKE ogb_file.ogbplant #MOD-C10012 add
 
  #No.TQC-7A0120--begin--
   IF cl_null(ms_cons_where) THEN
      LET ms_cons_where = ' 1=1'
   END IF 
  #No.TQC-7A0120---end---
  #No.MOD-8B0127--begin--  
   LET l_oma02 = NULL
   LET l_oma08 = NULL 
   SELECT oma02,oma08,oma21 INTO l_oma02,l_oma08,l_oma21 FROM oma_file WHERE oma01 = ms_oma01    #No.MOD-8B0256 #No.MOD-930277 add oma08
   IF NOT cl_null(l_oma02) THEN 
#     LET ms_cons_where = ms_cons_where," oga02 <= '",l_oma02,"'"                 #TQC-950128 Mark                                  
      LET ms_cons_where = ms_cons_where," AND oga02 <= '",l_oma02,"'"             #TQC-950128  
   END IF  
  #No.MOD-8B0127---end--- 
  #No.MOD-930277--begin--
   IF NOT cl_null(l_oma08) THEN 
#     LET ms_cons_where = ms_cons_where," oga08 = '",l_oma08 CLIPPED,"'"          #TQC-950128 Mark                                  
      LET ms_cons_where = ms_cons_where," AND oga08 = '",l_oma08 CLIPPED,"'"      #TQC-950128
   END IF 
  #No.MOD-930277---end---
 
  #LET ls_sql = "SELECT 'N',oga01,oga02,ogb03,ogb04,ogb091,ogb12,ogb60",   #No.MOD-8C0211
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_ogb2', 'ogb_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
  #LET ls_sql = "SELECT 'N',oga01,oga02,ogb03,ogb04,ogb091,ogb917,ogb60",     #No.MOD-8C0211 #MOD-C10012 mark
   LET ls_sql = "SELECT 'N',oga01,oga02,ogb03,ogb04,",                        #MOD-C10012 add
                "       ogb091,ogb917,ogb60,ogbplant",                        #MOD-C10012 add
                "  FROM oga_file,ogb_file",
                " WHERE ",ms_cons_where CLIPPED,
		"   AND oga01 = ogb01",
		"   AND oga03 = '",ms_cus CLIPPED,"'",
               #"   AND ogb60 < ogb12 ",  #No.MOD-8C0211
                "   AND ogb60 < ogb917 ",  #No.MOD-8C0211
		"   AND ogaconf = 'Y' AND ogapost='Y' ",
                "   AND (oga09 = '2' OR oga09 ='3' OR oga09 = '8') ",  #010809改  #No.FUN-610020
                 "  AND oga65='N' ",  #No.FUN-610020
                "   AND (oga18='",ms_oma68,"'"," OR oga18=' ' OR oga18 IS NULL )",   #No.TQC-6C0085 alter ogb18->oga18
                "   AND ogb1005 != '2'",
                "   AND oga00 IN ('1','4','5','6')",   #No.MOD-8B0256
                "   AND oga21 ='",l_oma21,"'",         #No.MOD-8B0256 
		" ORDER BY oga01,ogb03 "
 
#FUN-990069---begin 
   IF (NOT mi_multi_sel ) THEN
      CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql
   END IF     
#FUN-990069---end  
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
  #FOREACH lcurs_qry INTO lr_qry.*                          #MOD-C10012 mark
   FOREACH lcurs_qry INTO lr_qry.*,l_ogbplant               #MOD-C10012 add
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF

     #---------------------------------------MOD-C10012----------------------start
      SELECT SUM(omb12) INTO l_omb12
        FROM omb_file,oma_file
       WHERE oma00 = '12'
         AND oma01 = omb01
         AND omavoid = 'N'
         AND omaconf = 'N'
         AND omb31 = lr_qry.oga01
         AND omb32 = lr_qry.ogb03
         AND omb44 = l_ogbplant

      IF cl_null(l_omb12) THEN
         LET l_omb12 = 0
      END IF

      IF lr_qry.ogb917 - l_omb12 <= 0 THEN   #判斷出貨數量<=AR數量則不產生
         CONTINUE FOREACH                    #單身部分
      END IF

     #---------------------------------------MOD-C10012------------------------end
 
     #No.MOD-8B0127--begin--
     #根據oga07的值排除不符合要求的記錄。
      IF NOT cl_null(lr_qry.oga01) THEN
         LET l_oga07 = NULL
         SELECT oga07 INTO l_oga07 FROM oga_file WHERE oga01 = lr_qry.oga01
         IF l_oga07 <> 'Y' THEN
            IF YEAR(lr_qry.oga02) <> YEAR(l_oma02) OR
               MONTH(lr_qry.oga02) <> MONTH(l_oma02) THEN
               CONTINUE FOREACH
            END IF
         END IF
      END IF
     #No.MOD-8B0127---end---
 
      #No.MOD-8C0211--begin--
      CALL s_get_doc_no(lr_qry.oga01) RETURNING l_slip 
      SELECT oay11 INTO l_oay11 FROM oay_file WHERE oayslip = l_slip 
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
FUNCTION ogb2_qry_set_display_data(pi_start_index, pi_end_index)
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
FUNCTION ogb2_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
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
         CALL ogb2_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ogb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb2_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL ogb2_qry_refresh()
     
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
            CALL ogb2_qry_reset_multi_sel(pi_start_index, pi_end_index)
            IF cl_sure(0,0) THEN
               CALL ogb2_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION ogb2_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION ogb2_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
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
         CALL ogb2_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION ogb2_qry_refresh()
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
FUNCTION ogb2_qry_accept(pi_sel_index)
   DEFINE pi_sel_index    LIKE type_file.num10 	   #No.FUN-680131 INTEGER
   DEFINE lsb_multi_sel   base.StringBuffer 
   DEFINE li_i            LIKE type_file.num10     #No.FUN-680131 INTEGER
   DEFINE l_oma           RECORD LIKE oma_file.*   #MOD-880005 add
#   DEFINE l_sql1          STRING              #No.MOD-920309 add by liuxqa #TQC-940147
 
#  MESSAGE 'WORKING....' ATTRIBUTES(YELLOW)     #FUN-9B0156
   LET g_success='Y'
   BEGIN WORK
      SELECT MAX(omb03)+1 INTO ms_omb03 FROM omb_file WHERE omb01 = ms_oma01 
      #@@@ 95/07/05 by danny
      IF cl_null(ms_omb03) THEN LET ms_omb03=1 END IF
      #@@@
      SELECT * INTO l_oma.* FROM oma_file WHERE oma01 = ms_oma01   #MOD-880005 add
     #str MOD-870311 add
     #抓取原幣取位小數位數
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
        FROM azi_file WHERE azi01=(SELECT oma23 FROM oma_file
                                    WHERE oma01=ms_oma01)
     #end MOD-870311 add
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            SELECT * INTO mr_ogb.* FROM ogb_file
            WHERE ogb01=ma_qry[li_i].oga01 AND ogb03=ma_qry[li_i].ogb03
#TQC-940147
{
#No.MOD-920309 add by liuxqa --begin--
            LET l_sql1 =" SELECT ogb_file.*,ogc_file.* FROM ogb_file,OUTER ogc_file WHERE ogb01=ogc01 AND ogb03=ogc03 AND ogb01='",ma_qry[li_i].oga01,
                        "' AND ogb03=",ma_qry[li_i].ogb03," AND ogb17 <>'Y'",
                        " UNION ALL ",
                        " SELECT ogb_file.*,ogc_file.* FROM ogb_file,ogc_file WHERE ogb01=ogc01 AND ogb03=ogc03 AND ogb01='",ma_qry[li_i].oga01,
                        "' AND ogb03=",ma_qry[li_i].ogb03," AND ogb17 = 'Y'"
            PREPARE ogc_prepare1 FROM l_sql1
            DECLARE ogc_cur1 CURSOR FOR ogc_prepare1
            FOREACH ogc_cur1 INTO mr_ogb.*,mr_ogc.*
#No.MOD-920309 add by liuxqa --end--
}
#TQC-940147
            INITIALIZE mr_omb.* TO NULL
            LET mr_omb.omb01 = ms_oma01
            LET mr_omb.omb03 = ms_omb03
            #No:7682
#TQC-940147
{
#No.MOD-920309 add by liuxqa --begin--
            IF NOT cl_null(mr_ogc.ogc092) THEN
               LET mr_omb.omb04 = mr_ogc.ogc17
               LET mr_omb.ombud02 = mr_ogc.ogc092
               SELECT SUM(omb12) INTO ms_omb12 FROM omb_file,oma_file
                 WHERE oma00='12'
                 AND oma01=omb01
                 AND omavoid='N'
                 AND omb31=mr_ogb.ogb01
                 AND omb32=mr_ogb.ogb03
                 AND omb04=mr_ogc.ogc17
                 AND ombud02=mr_ogc.ogc092
            ELSE
              LET mr_omb.omb04 = mr_ogb.ogb04
              LET mr_omb.ombud02 = mr_ogb.ogb092
#No.MOD-920309 add by liuxqa --end--
}
#TQC-940147
              SELECT SUM(omb12) INTO ms_omb12 FROM omb_file,oma_file
               WHERE oma00='12'
                 AND oma01=omb01
                 AND omavoid='N'
                 AND omb31=mr_ogb.ogb01
                 AND omb32=mr_ogb.ogb03
                 #AND ombud02=mr_ogb.ogb092   #No.MOD-920309 add by liuxqa #TQC-940147
            #END IF                           #No.MOD-920309 add by liuxqa #TQC-940147
            IF STATUS THEN 
               CONTINUE FOR
            END IF
            LET mr_omb.omb39 = mr_ogb.ogb1012
            IF cl_null(ms_omb12) THEN LET ms_omb12=0 END IF
 #No.MOD-530692--begin
           #LET mr_omb.omb12 = (mr_ogb.ogb12 - mr_ogb.ogb64) - ms_omb12  #No.MOD-8C0211
            LET mr_omb.omb12 = (mr_ogb.ogb917 - mr_ogb.ogb64) - ms_omb12 #No.MOD-8C0211 
#           LET mr_omb.omb12 = (mr_ogb.ogb12 - mr_ogb.ogb60 - mr_ogb.ogb64) - ms_omb12
 #No.MOD-530692--end
#TQC-940147
{
#No.MOD-920309 add by liuxqa 
            IF mr_ogb.ogb17 = 'Y' THEN
               LET mr_omb.omb12 = (mr_ogb.ogb917 - mr_ogb.ogb64)*mr_ogc.ogc12/mr_ogb.ogb12 - ms_omb12
            ELSE
               LET mr_omb.omb12 = (mr_ogb.ogb917 - mr_ogb.ogb64) - ms_omb12
            END IF
#No.MOD-920309 add by liuxqa    
}
#TQC-940147
            IF  mr_omb.omb12 <= 0 THEN   #判斷出貨數量<應收數量
                CALL cl_err(mr_ogb.ogb01,'axm-301',1)
                #DISPLAY "mr_omb.omb12",mr_omb.omb12
                #DISPLAY " CONTINUE FOR"
                CONTINUE FOR           #不產生單身部份
            END IF
            #No:7682
            CALL ogb2_qry_detail()
            LEt mr_omb.omb38 = ms_omb38                  #MOD-870209
            LEt mr_omb.omblegal = g_legal                #FUN-980012 add
            LET mr_omb.omb44 = mr_ogb.ogbplant           #MOD-C10012 add
            CALL ogb2_omb33()                            #FUN-C90078
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
                     UPDATE oga_file SET oga10 = l_oma.oma01,
                                         oga05 = l_oma.oma05
                      WHERE oga01 = mr_omb.omb31
                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                        CALL cl_err3("upd","oga_file",mr_omb.omb31,"",SQLCA.SQLCODE,"","update oga_file",1)
                     END IF
                  END IF
                  IF mr_omb.omb38 = '3' OR mr_omb.omb38 = '5' THEN
                     UPDATE oha_file SET oha10 = l_oma.oma01
                      WHERE oha01 = mr_omb.omb31
                     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                        CALL cl_err3("upd","oha_file",mr_omb.omb31,"",SQLCA.SQLCODE,"","update oha_file",1)
                     END IF
                  END IF
               END IF
               IF l_oma.oma00 ='21' AND l_oma.oma16 IS NULL THEN
                  UPDATE oha_file SET oha10 = l_oma.oma01
                   WHERE oha01 = mr_omb.omb31
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
 
FUNCTION ogb2_qry_detail()
DEFINE   l_oma58        LIKE oma_file.oma58  #No.MOD-8B0081
 
     LET mr_omb.omb38 = '2'           #No.TQC-790152
     LET mr_omb.omb31 = mr_ogb.ogb01
     LET mr_omb.omb32 = mr_ogb.ogb03
     LET mr_omb.omb04 = mr_ogb.ogb04
     LET mr_omb.omb05 = mr_ogb.ogb05
     LET mr_omb.omb06 = mr_ogb.ogb06
    #LET mr_omb.omb12 = mr_ogb.ogb12 - mr_ogb.ogb60   #No:7682
     LET mr_omb.omb12 = s_digqty(mr_omb.omb12,mr_omb.omb05)  #FUN-BB0083 add
     LET mr_omb.omb13 = mr_ogb.ogb13
     IF ms_oma213 = 'N' THEN
       #LET mr_omb.omb14  = mr_omb.omb12  * mr_omb.omb13  #No.MOD-820066
        LET mr_omb.omb14  = ogb2_qry_amount(mr_omb.omb12,mr_omb.omb13,mr_ogb.ogb1006,t_azi03) #No.MOD-820066
        LET mr_omb.omb14t = mr_omb.omb14  * (1 + ms_oma211/100)
     ELSE
       #LET mr_omb.omb14t = mr_omb.omb12  * mr_omb.omb13  #No.MOD-820066
        LET mr_omb.omb14t = ogb2_qry_amount(mr_omb.omb12,mr_omb.omb13,mr_ogb.ogb1006,t_azi03) #No.MOD-820066
        LET mr_omb.omb14  = mr_omb.omb14t / (1 + ms_oma211/100)
     END IF
     IF mr_omb.omb39 = 'Y' THEN
        LET mr_omb.omb14 = 0
        LET mr_omb.omb14t= 0
     END IF
     CALL cl_digcut(mr_omb.omb13,t_azi03) RETURNING mr_omb.omb13    #MOD-870311 add
     CALL cl_digcut(mr_omb.omb14,t_azi04) RETURNING mr_omb.omb14    #MOD-870311 mod g_azi->t_azi
     CALL cl_digcut(mr_omb.omb14t,t_azi04)RETURNING mr_omb.omb14t   #MOD-870311 mod g_azi->t_azi
     #No.MOD-8B0081--begin-- modify
     LET mr_omb.omb15  = mr_omb.omb13  * ms_oma24
     LET mr_omb.omb16  = mr_omb.omb14  * ms_oma24
     LET mr_omb.omb16t = mr_omb.omb14t * ms_oma24
     LET l_oma58 = NULL 
     SELECT oma58 INTO l_oma58 FROM oma_file 
      WHERE oma01 = ms_oma01     
     IF cl_null(l_oma58) THEN LET l_oma58 = 0 END IF 
     LET mr_omb.omb17  = mr_omb.omb13  * l_oma58
     LET mr_omb.omb18  = mr_omb.omb14  * l_oma58
     LET mr_omb.omb18t = mr_omb.omb14t * l_oma58
     #No.MOD-8B0081---end---  
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
 
#No.MOD-820066--begin--
FUNCTION ogb2_qry_amount(p_qty,p_price,p_rate,p_azi03) 
DEFINE   p_qty    LIKE ogb_file.ogb12    #數量
DEFINE   p_price  LIKE ogb_file.ogb13    #單價(未折扣)
DEFINE   p_rate   LIKE ogb_file.ogb1006  #折扣率
DEFINE   p_azi03  LIKE azi_file.azi03    
DEFINE   l_price  LIKE ogb_file.ogb13    #單價(已折扣)
DEFINE   l_amount LIKE ogb_file.ogb14  
 
    #No.MOD-830016--begin--                                                                                                         
    IF cl_null(p_rate) THEN                                                                                                         
       LET p_rate = 100                                                                                                             
    END IF                                                                                                                          
    #No.MOD-830016--begin-- 
    LET l_price = cl_digcut(p_price*p_rate/100,p_azi03)
    LET l_amount= p_qty*l_price
    IF cl_null(l_amount) THEN 
       LET l_amount = 0
    END IF 
    RETURN l_amount
 
END FUNCTION
#No.MOD-820066---end---
#FUN-C90078--add--str
FUNCTION ogb2_omb33()
DEFINE l_sql    STRING
DEFINE l_oma08  LIKE oma_file.oma08
DEFINE l_oba11  LIKE oba_file.oba11
DEFINE l_oba111 LIKE oba_file.oba111
DEFINE l_ool41  LIKE ool_file.ool41
DEFINE l_ool411 LIKE ool_file.ool411
DEFINE l_oma13  LIKE oma_file.oma13
DEFINE l_omb33  LIKE omb_file.omb33
DEFINE l_omb331 LIKE omb_file.omb331


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

#FUN-C90078--add--end

