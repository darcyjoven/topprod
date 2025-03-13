# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#{
# Program name  : q_pmk.4gl
# Program ver.  : 7.0
# Description   : QBE視窗多行查詢程式(先問查詢條件,請購單資料檔案查詢)
# Date & Author : 2003/09/24 by jack
# Memo          :
# Modify        : 05/05/31 Lifeng FUN-550131 增加對料件多屬性的支持
#}
# Modify........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-->CHAR
# Modify........: No.TQC-650075 06/05/19 By Rayven 現將程序中涉及的imandx表改為imx表，原欄位imandx改為imx000
# Modify........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-980025 09/10/09 By dxfwo hardcode的部分修改
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
END GLOBALS
 
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
 	 pmk01 LIKE pmk_file.pmk01,
	 pmk04 LIKE pmk_file.pmk04,
	 pmk09 LIKE pmk_file.pmk09,
	 pml02 LIKE pml_file.pml02,
	 pml04 LIKE pml_file.pml04,
	 #FUN-550131 Add Start
	 attdesc      LIKE type_file.chr1000,   #No.FUN-680131 VARCHAR(500)
         att01    LIKE imx_file.imx01,
         att02    LIKE imx_file.imx01,
         att03    LIKE imx_file.imx02,
         att04    LIKE imx_file.imx02,
         att05    LIKE imx_file.imx03,
         att06    LIKE imx_file.imx03,
         att07    LIKE imx_file.imx04,
         att08    LIKE imx_file.imx04,
         att09    LIKE imx_file.imx05,
         att10    LIKE imx_file.imx05,
         att11    LIKE imx_file.imx06,
         att12    LIKE imx_file.imx06,
         att13    LIKE imx_file.imx07,
         att14    LIKE imx_file.imx07,
         att15    LIKE imx_file.imx08,
         att16    LIKE imx_file.imx08,
         att17    LIKE imx_file.imx09,
         att18    LIKE imx_file.imx09,
         att19    LIKE imx_file.imx10,
         att20    LIKE imx_file.imx10,         	
         #FUN-550131 End
	 pml20 LIKE pml_file.pml20
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
 	 pmk01 LIKE pmk_file.pmk01,
	 pmk04 LIKE pmk_file.pmk04,
	 pmk09 LIKE pmk_file.pmk09,
	 pml02 LIKE pml_file.pml02,
	 pml04 LIKE pml_file.pml04,
	 #FUN-550131 Add Start
	 attdesc      LIKE type_file.chr1000,   #No.FUN-680131 VARCHAR(500)
         att01    LIKE imx_file.imx01,
         att02    LIKE imx_file.imx01,
         att03    LIKE imx_file.imx02,
         att04    LIKE imx_file.imx02,
         att05    LIKE imx_file.imx03,
         att06    LIKE imx_file.imx03,
         att07    LIKE imx_file.imx04,
         att08    LIKE imx_file.imx04,
         att09    LIKE imx_file.imx05,
         att10    LIKE imx_file.imx05,
         att11    LIKE imx_file.imx06,
         att12    LIKE imx_file.imx06,
         att13    LIKE imx_file.imx07,
         att14    LIKE imx_file.imx07,
         att15    LIKE imx_file.imx08,
         att16    LIKE imx_file.imx08,
         att17    LIKE imx_file.imx09,
         att18    LIKE imx_file.imx09,
         att19    LIKE imx_file.imx10,
         att20    LIKE imx_file.imx10,        	
         #FUN-550131 End
	 pml20 LIKE pml_file.pml20
END RECORD
 
#FUN-550131 Add Start
DEFINE   ma_cons_lif   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
 	 pmk01 LIKE pmk_file.pmk01,
	 pmk04 LIKE pmk_file.pmk04,
	 pmk09 LIKE pmk_file.pmk09,
	 pml02 LIKE pml_file.pml02,
	 pml04 LIKE pml_file.pml04,
	 attdesc      LIKE type_file.chr1000,   #No.FUN-680131 VARCHAR(500)
         att01    LIKE imx_file.imx01,
         att02    LIKE imx_file.imx01,
         att03    LIKE imx_file.imx02,
         att04    LIKE imx_file.imx02,
         att05    LIKE imx_file.imx03,
         att06    LIKE imx_file.imx03,
         att07    LIKE imx_file.imx04,
         att08    LIKE imx_file.imx04,
         att09    LIKE imx_file.imx05,
         att10    LIKE imx_file.imx05,
         att11    LIKE imx_file.imx06,
         att12    LIKE imx_file.imx06,
         att13    LIKE imx_file.imx07,
         att14    LIKE imx_file.imx07,
         att15    LIKE imx_file.imx08,
         att16    LIKE imx_file.imx08,
         att17    LIKE imx_file.imx09,
         att18    LIKE imx_file.imx09,
         att19    LIKE imx_file.imx10,
         att20    LIKE imx_file.imx10,        	
	 pml20 LIKE pml_file.pml20	
END RECORD
 
#該數組是多屬性料號中的一個重要的控制數組，記錄了整個Table中所有的
#列及其控制信息，在程序中多次用到
#與cl_create_qry中原來的定義相比，刪除了部分成員變量以簡化程序
DEFINE ma_multi_rec DYNAMIC ARRAY OF RECORD
       index	 LIKE type_file.num5,        #字段的序號  #No.FUN-680131 SMALLINT
       colname   STRING,        #列名稱
       value     DYNAMIC ARRAY OF STRING,   #屏幕數組值
       dbfield   STRING,        #在數據庫中對應的實際欄位名稱
       dbtype    LIKE type_file.chr1000,#該欄位在數據庫中的數據類型 #TQC-5A0134 VARCHAR-->CHAR #No.FUN-680131 VARCHAR(102)
#       object    om.DomNode,    #該欄位的列對象
       dispfld   STRING,        #表示該t欄位(或表示料件的x欄位)對應的顯示欄位
       imafld    STRING         #只對x欄位有效，'Y'表示該欄位表示料件編號
                                #'N'表示該欄位不是料件編號
#       visible   SMALLINT       #該列是否顯示出來，只對於t欄位有效
END RECORD
 
#以下是多屬性料件專用的合成SQL用的字符串
DEFINE g_multi_join   STRING,
       g_multi_where  STRING
 
#FUN-550131 End
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING
DEFINE   ms_default2      STRING
DEFINE   ms_ret1          STRING,
         ms_ret2          STRING,
         ms_type          LIKE type_file.chr1     #No.FUN-680131 VARCHAR(1)
 
FUNCTION q_pmk(pi_multi_sel,pi_need_cons,ps_default1,ps_default2,p_type)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  ,
            ps_default2    STRING  ,
            p_type         LIKE type_file.chr1     #No.FUN-680131 VARCHAR(1)
 
 
   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
   LET ms_type     = p_type
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_pmk" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161
 
   CALL cl_ui_locale("q_pmk")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("pmk01", "red")
   END IF
 
   CALL pmk_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1
   ELSE
      RETURN ms_ret1,ms_ret2
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
FUNCTION pmk_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE.	#No.FUN-680131 SMALLINT
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
            #FUN-550131 Start , 根據當前系統中是否進行料件多屬性管理來確定
            #CONSTRUCT的方式
            IF g_sma.sma120 = 'Y' THEN
               CALL pmk_multi_cons()   #調用自定義的CONSTRUCT過程
               LET ms_cons_where = '1=1'  #自定義時這兩個變量是不填充的
            ELSE
              #No.FUN-550131 Add Start , 如果不進行料件多屬性管理則隱藏輔助欄位
              CALL cl_set_comp_visible('attdesc',FALSE)
              CALL cl_set_comp_visible('att01,att02,att03,att04,att05,att06,att07,att08,att09,att10',FALSE)
              CALL cl_set_comp_visible('att11,att12,att13,att14,att15,att16,att17,att18,att19,att20',FALSE)
              #No.FUN-550131 Add End
 
               CONSTRUCT ms_cons_where ON pmk01,pmk04,pmk09,pml02,pml04,pml20
                                     FROM s_pmk[1].pmk01,s_pmk[1].pmk04,s_pmk[1].pmk09,s_pmk[1].pml02,s_pmk[1].pml04,s_pmk[1].pml20
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                     CONTINUE CONSTRUCT
 
               END CONSTRUCT
 
               IF (INT_FLAG) THEN
                  LET INT_FLAG = FALSE
                  EXIT WHILE
               END IF
            END IF
         END IF
         #FUN-550131 End
 
         CALL pmk_qry_prep_result_set()
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
 
      CALL pmk_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL pmk_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL pmk_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION pmk_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
 	 pmk01 LIKE pmk_file.pmk01,
	 pmk04 LIKE pmk_file.pmk04,
	 pmk09 LIKE pmk_file.pmk09,
	 pml02 LIKE pml_file.pml02,
	 pml04 LIKE pml_file.pml04,
	 #FUN-550131 Add Start
	 attdesc      LIKE type_file.chr1000, #No.FUN-680131 VARCHAR(500)
         att01    LIKE imx_file.imx01,
         att02    LIKE imx_file.imx01,
         att03    LIKE imx_file.imx02,
         att04    LIKE imx_file.imx02,
         att05    LIKE imx_file.imx03,
         att06    LIKE imx_file.imx03,
         att07    LIKE imx_file.imx04,
         att08    LIKE imx_file.imx04,
         att09    LIKE imx_file.imx05,
         att10    LIKE imx_file.imx05,
         att11    LIKE imx_file.imx06,
         att12    LIKE imx_file.imx06,
         att13    LIKE imx_file.imx07,
         att14    LIKE imx_file.imx07,
         att15    LIKE imx_file.imx08,
         att16    LIKE imx_file.imx08,
         att17    LIKE imx_file.imx09,
         att18    LIKE imx_file.imx09,
         att19    LIKE imx_file.imx10,
         att20    LIKE imx_file.imx10,         	
         #FUN-550131 End
	 pml20 LIKE pml_file.pml20
   END RECORD
   DEFINE   l_pmk25  LIKE pmk_file.pmk25,
            l_pml16  LIKE pml_file.pml16
 
   #FUN-550131 Modified Start
   #如果不進行料件多屬性管理，或進行了多屬性管理但是沒有輸入任何條件，則執行原有代碼
   IF ( g_sma.sma120 = 'N' )OR(( g_sma.sma120 = 'Y')AND( g_multi_where.getLength() = 0 ))THEN
 
      #Begin:FUN-980030
      LET l_filter_cond = cl_get_extra_cond_for_qry('q_pmk', 'pmk_file')
      IF NOT cl_null(l_filter_cond) THEN
         LET ms_cons_where = ms_cons_where,l_filter_cond
      END IF
      #End:FUN-980030
      LET ls_sql = "SELECT 'N',pmk01,pmk04,pmk09,pml02,pml04,",
                   "'','','','','','','','','','','','','','','','',",  #FUN-550131
                   "'','','','','',",                                   #FUN-550131 Add
                   "pml20,pmk25,pml16 ",
                   " FROM pmk_file,pml_file ",
                   " WHERE ",ms_cons_where
   ELSE
      LET ls_sql = "SELECT 'N',pmk01,pmk04,pmk09,pml02,pml04,",
                   "'','','','','','','','','','','','','','','','',",  #FUN-550131
                   "'','','','','',",                                   #FUN-550131 Add
                   "pml20,pmk25,pml16 ",
                   " FROM pmk_file,pml_file ",g_multi_join,
                   " WHERE ",g_multi_where
   END IF
   #FUN-550131 Modified End
 
 
   IF NOT mi_multi_sel THEN
      LET ls_where = "   AND pmk01 = pml01 AND ",
                     " (pml16 IN ('X','0','1') OR (pml16 = '2' AND pml20 - pml21 > 0))",
                     " AND pmk18 != 'X' AND pmkacti = 'Y' "
   END IF
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY pmk01,pml02 "
 
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
 
   FOREACH lcurs_qry INTO lr_qry.*,l_pmk25,l_pml16
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      IF l_pml16 = '0' AND l_pmk25 = '0' AND ms_type = '1' THEN
         IF NOT q_pmk_check(lr_qry.pmk01) THEN
            INITIALIZE lr_qry.* TO NULL
            CONTINUE FOREACH
         END IF
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
FUNCTION pmk_qry_set_display_data(pi_start_index, pi_end_index)
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
FUNCTION pmk_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_pmk.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_pmk.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_pmk.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL pmk_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_pmk.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL pmk_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         CALL pmk_qry_refresh()
 
         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_pmk.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL pmk_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL pmk_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
            LET ms_ret2 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
 
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
         END IF
 
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
# Date & Author : 2003/09/24 by jack
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION pmk_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION pmk_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_pmk.*
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
         CALL pmk_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
         END IF
 
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
FUNCTION pmk_qry_refresh()
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
FUNCTION pmk_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].pmk01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].pmk01 CLIPPED)
            END IF
         END IF
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].pmk01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].pml02 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
 
FUNCTION  q_pmk_check(l_pmk01)
   DEFINE   l_pmk01     LIKE pmk_file.pmk01,
            l_pmkmksg   LIKE pmk_file.pmkmksg,
            l_pmksseq   LIKE pmk_file.pmksseq,
            l_pmksmax   LIKE pmk_file.pmksmax
 
 
   SELECT pmkmksg,pmksseq,pmksmax
     INTO l_pmkmksg,l_pmksseq,l_pmksmax
     FROM pmk_file
    WHERE pmk01 = l_pmk01 AND
          pmk25 = '0'
   #若為開立狀況,須檢查系統參數ASM#046
   #是否為'N',且需簽核且己簽核順序等於應簽核順序方可進行合併
   # IF g_sma.sma46 = 'N' AND       #sma46已不用NO:4426
   IF l_pmkmksg = 'Y' AND l_pmksseq != l_pmksmax THEN
      RETURN 0
   END IF
   RETURN 1
END FUNCTION
 
##############################################################################
#- FUN-550131 Add Start Below ------------------------------------------------
# 下面都是為料件多屬性機制添加的代碼
 
#初始化模塊全局變量ma_multi_rec，該動作在cl_create_qry標準開窗作業中是在build_table
#的時候進行，按照運行期的狀況來動態填充的，但現在Hardcode中取消了這個函數，並且列數
#是固定的，所以每一個Hardcode版的查詢程序都要有一個這樣的函數，按照實際情況來進行填充
FUNCTION pmk_fill_mutli_rec()
DEFINE
  li_i,li_j            LIKE type_file.num5,      #No.FUN-680131 SMALLINT SMALLINT
  lc_j,lc_jc,lc_jb     LIKE type_file.chr2,      #No.FUN-680131 VARCHAR(2)
  la_field             DYNAMIC ARRAY OF STRING
 
  #填充字段名稱數組
  #pmk01,pmk04,pmk09,pml02,pml04,pml20
  CALL la_field.clear()
  LET la_field[1] = 'pmk01'
  LET la_field[2] = 'pmk04'
  LET la_field[3] = 'pmk09'
  LET la_field[4] = 'pml02'
  LET la_field[5] = 'pml04'
  LET la_field[27] = 'pml20'
 
  #清空該模塊全局數組
  CALL ma_multi_rec.clear()
  #逐項添加信息(7個標準欄位)
  FOR li_i = 1 TO 27
      LET ma_multi_rec[li_i].index = li_i
      LET ma_multi_rec[li_i].colname = la_field[li_i]
      LET ma_multi_rec[li_i].dbfield = la_field[li_i]
      LET ma_multi_rec[li_i].dbtype = 'VARCHAR2'   #其實這裡只區分STRING和INTEGER，所以DATE也用VARCHAR來表示
      LET ma_multi_rec[li_i].dispfld = ''
      LET ma_multi_rec[li_i].imafld = 'N'
  END FOR
  #設置獨特的屬性
  LET ma_multi_rec[5].imafld = 'Y'
  #pml02,pml20是NUMBER型
  LET ma_multi_rec[4].dbtype  = 'NUMBER'
  LET ma_multi_rec[27].dbtype = 'NUMBER'
 
  #這裡要手工制定li_i，因為輔助欄位是插在中間而非添加到最後
  LET li_i = 6  #規則:如果第n個欄位是料件編號欄位則li_i為n+1
  #逐項添加信息(21個輔助欄位)
  LET ma_multi_rec[li_i].index = li_i
  LET ma_multi_rec[li_i].colname = 'attdesc'
  LET ma_multi_rec[li_i].dbfield = ''
  LET ma_multi_rec[li_i].dbtype = 'VARCHAR2'   #其實這裡只區分STRING和INTEGER，所以DATE也用VARCHAR來表示
  LET ma_multi_rec[li_i].dispfld = '@SELF'
  LET ma_multi_rec[li_i].imafld = 'N'
 
  FOR li_j = 1 TO 10  #每兩個輔助欄位對應的欄位是一致的，比如att01和att02對應的都是imx01
      LET lc_jb = li_j USING '&&'
      LET lc_j  = li_j*2 - 1 USING '&&'
      LET lc_jc = li_j*2 USING '&&'
 
      LET ma_multi_rec[li_i + li_j*2-1].index = li_i+li_j*2-1
      LET ma_multi_rec[li_i + li_j*2-1].colname = 'att' || lc_j
      LET ma_multi_rec[li_i + li_j*2-1].dbfield = 'imx' || lc_jb
      LET ma_multi_rec[li_i + li_j*2-1].dbtype = 'VARCHAR2'   #其實這裡只區分STRING和INTEGER，所以DATE也用VARCHAR來表示
      LET ma_multi_rec[li_i + li_j*2-1].dispfld = 'attdesc'
      LET ma_multi_rec[li_i + li_j*2-1].imafld = 'N'
 
      LET ma_multi_rec[li_i + li_j*2].index = li_i+li_j*2
      LET ma_multi_rec[li_i + li_j*2].colname = 'att' || lc_jc
      LET ma_multi_rec[li_i + li_j*2].dbfield = 'imx' || lc_jb
      LET ma_multi_rec[li_i + li_j*2].dbtype = 'VARCHAR2'   #其實這裡只區分STRING和INTEGER，所以DATE也用VARCHAR來表示
      LET ma_multi_rec[li_i + li_j*2].dispfld = 'attdesc'
      LET ma_multi_rec[li_i + li_j*2].imafld = 'N'
  END FOR
END FUNCTION
 
FUNCTION pmk_multi_cons()
  DEFINE l_ac        LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
         lc_ze03     LIKE ze_file.ze03
 
  #初始化中間數組
  CALL pmk_fill_mutli_rec()
  CALL ma_cons_lif.clear()
 
  #因為在默認的窗體創建過程中指定了除CheckBox之外的所有欄位均不能輸入，而現在
  #要用它來模擬CONSTRUCT，所以在調用INPUT過程之前要把這個邏輯反過來，即除了
  #CheckBox之外的所有欄位均可以輸入
  #注意，在模擬CONSTRUCT過程結束之后，要重新恢復原有的規則
  CALL cl_set_comp_entry('check',FALSE)
  CALL cl_set_comp_entry('pmk01,pmk04,pmk09,pml02,pml04,pml20',TRUE)
 
  #設置顯示欄位的標題
  SELECT ze03 INTO lc_ze03 FROM ze_file
    WHERE ze01 = 'lib-233' AND ze02 = g_lang
  CALL cl_set_comp_att_text('attdesc',lc_ze03)
 
  #---------------------------------------------------------------------------
  #以INPUT方式來接受條件查詢并自己手工合成條件
  INPUT ARRAY ma_cons_lif WITHOUT DEFAULTS FROM s_pmk.*
        ATTRIBUTE(UNBUFFERED,INSERT ROW=TRUE, DELETE ROW=TRUE,APPEND ROW=TRUE)
    BEFORE ROW
      #紀錄當前列標
      LET l_ac = ARR_CURR()
      #在每進入一列之前都要將這一列上面的所有明細屬性欄位隱藏起來,但是作為
      #顯示用的只讀顯示列要顯示出來
      CALL cl_set_comp_visible('attdesc',TRUE)
      CALL cl_set_comp_visible('att01,att02,att03,att04,att05,att06,att07,att08,att09,att10',FALSE);
      CALL cl_set_comp_visible('att11,att12,att13,att14,att15,att16,att17,att18,att19,att20',FALSE);
 
    #下面是20個原有欄位的離開事件，這些過程主要是向控制數組中的對應位置寫
    #信息以及顯示可能會有的明細屬性列
    AFTER FIELD pmk01,pmk04,pmk09,pml02,pml04,pml20
      CALL pmk_after_normal_field(FGL_DIALOG_GETFIELDNAME(),FGL_DIALOG_GETBUFFER(),l_ac)
 
    AFTER FIELD att01,att02,att03,att04,att05,att06,att07,att08,att09,att10,
                att11,att12,att13,att14,att15,att16,att17,att18,att19,att20
      CALL pmk_after_detail_field(FGL_DIALOG_GETFIELDNAME(),FGL_DIALOG_GETBUFFER(),l_ac)
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
  END INPUT
 
  #處理條件輸入并合成WHERE條件
  IF INT_FLAG THEN
     #LET INT_FLAG = 0
     LET g_multi_where = ''
     LET g_multi_join = ''
  ELSE
     #這一句話用來生成SQL語句中的where條件
     CALL pmk_make_sql_condition()   #這個市cl_create_qry中定義的標準函數
  END IF
 
  #到此為止用INPUT來模擬CONSTRUCT的語句已經全部結束了
  #----------------------------------------------------------------------------
 
  #現在恢復原有的關于noEntry的設置
  CALL cl_set_comp_entry('check',TRUE)
  CALL cl_set_comp_entry('pmk01,pmk04,pmk09,pml02,pml04,pml20',FALSE)
  #隱藏所有的輔助列,這次包括只讀顯示列也隱藏掉，因為馬上要顯示結果集了
  CALL cl_set_comp_visible('attdesc',FALSE)
  CALL cl_set_comp_visible('att01,att02,att03,att04,att05,att06,att07,att08,att09,att10',FALSE);
  CALL cl_set_comp_visible('att11,att12,att13,att14,att15,att16,att17,att18,att19,att20',FALSE);
END FUNCTION
 
 
#一般欄位處理過程，針對'xxx'開頭的欄位，判斷是否為料件編號欄位，是否需要顯示一些
#明細屬性欄位以及相應的處理過程
#傳入pname為欄位的colname
FUNCTION pmk_after_normal_field(pname,pvalue,prow)
  DEFINE pname        STRING,
         pvalue       STRING,
         prow         LIKE type_file.num5,      #No.FUN-680131 SMALLINT
         pvalue_tmp   LIKE type_file.chr1000,   #No.FUN-680131 VARCHAR(500)
         li_ia,l_i    LIKE type_file.num5,  	#No.FUN-680131 SMALLINT SMALLINT
         li_i         LIKE type_file.num5,      #No.FUN-680131 SMALLINT
         lc_i         LIKE type_file.chr2,      #No.FUN-680131 VARCHAR(02)
  #這個數組用于接收各個屬性列的詳細信息
         g_agb        ARRAY[10] OF RECORD
                      agb03 LIKE agb_file.agb03,  #屬性代碼
                      agc02 LIKE agc_file.agc02,  #屬性的中文描述
                      agc03 LIKE agc_file.agc03,  #欄位長度
                      agc04 LIKE agc_file.agc04,  #欄位使用方式：1隨便輸，
                                                  #2選擇,3有範圍的輸入
                      agc05 LIKE agc_file.agc05,  #欄位限定起始值
                      agc06 LIKE agc_file.agc06   #欄位限定截至值
                      END RECORD,
         lsb_item     base.StringBuffer,
         lsb_value    base.StringBuffer,
         l_agd02      LIKE agd_file.agd02,
         l_agd03      LIKE agd_file.agd03,
 
         li_edit      LIKE type_file.num5,      #No.FUN-680131 SMALLINT
         li_comb      LIKE type_file.num5       #No.FUN-680131 SMALLINT
 
  #定位到控制數組中的當前欄位記錄
  FOR li_ia = 1 TO ma_multi_rec.getLength()
      IF ma_multi_rec[li_ia].colname = pname THEN
         EXIT FOR
      END IF
  END FOR
  #如果在控制數組中沒有定位到當前欄位的信息則說明有問題，直接退出
  IF li_ia > ma_multi_rec.getLength() THEN
     RETURN
  END IF
 
  #保存當前欄位屏幕上輸入的值
  LET ma_multi_rec[li_ia].value[prow] = pvalue
  #如果該欄位不是表示料件編號的欄位，那么就到此為止，不再進行以下的操作了
  IF ma_multi_rec[li_ia].imaFld = 'N' THEN
     RETURN
  END IF
 
  #能進行到這一步說明值已經發生了改變，需要刷新後面的輔助欄位的狀態和內容
 
  LET pvalue_tmp = pvalue
  #如果該欄位當前輸入的料件是要進行多屬性管理的
  IF cl_is_multi_feature_manage(pvalue) = TRUE THEN
     CALL g_agb.clear()
     DECLARE agb_cur CURSOR FOR
       SELECT agb03,agc02,agc03,agc04,agc05,agc06
       FROM agb_file,agc_file,ima_file
       WHERE agb01 = imaag AND agc01 = agb03
         AND ima01 = pvalue_tmp
       ORDER BY agb02
 
     LET l_i = 1
     FOREACH agb_cur INTO g_agb[l_i].*
       #判斷循環的正確性
       IF STATUS THEN
          CALL cl_err('foreach agb',STATUS,0)
          EXIT FOREACH
       END IF
 
       #分別計算出本條屬性值在控制數組中對應的兩個欄位對應的下標
       LET li_edit = li_ia + 1 + 2*l_i - 1
       LET li_comb = li_edit + 1
 
       #判斷當前這一個屬性列的取值方式
       IF g_agb[l_i].agc04 = '2' THEN  #如果是預定義值則顯示組合框
          #隱藏本組對應的編輯框
          CALL cl_set_comp_visible(ma_multi_rec[li_edit].colname,FALSE)
          #顯示本組對應的組合框
          CALL cl_set_comp_visible(ma_multi_rec[li_comb].colname,TRUE)
          #設置組合框對應列的列標題
          CALL cl_set_comp_att_text(ma_multi_rec[li_comb].colname,g_agb[l_i].agc02)
 
          #填充組合框中的選項
          LET lsb_item  = base.StringBuffer.create()
          LET lsb_value = base.StringBuffer.create()
          DECLARE agd_cur CURSOR FOR
            SELECT agd02,agd03 FROM agd_file
            WHERE agd01 = g_agb[l_i].agb03
          FOREACH agd_cur INTO l_agd02,l_agd03
            IF STATUS THEN
               CALL cl_err('foreach agb',STATUS,0)
               EXIT FOREACH
            END IF
            #lsb_value放選項的說明
            CALL lsb_value.append(l_agd03 CLIPPED || ",")
            #lsb_item放選項的值
            CALL lsb_item.append(l_agd02 CLIPPED || ",")
          END FOREACH
          CALL cl_set_combo_items(ma_multi_rec[li_comb].colname,
                                  lsb_item.toString(),
                                  lsb_value.toString())
       ELSE  #否則顯示文本框
          #隱藏本組對應的組合框
          CALL cl_set_comp_visible(ma_multi_rec[li_comb].colname,FALSE)
          #顯示本組對應的文本框
          CALL cl_set_comp_visible(ma_multi_rec[li_edit].colname,TRUE)
          #設置編輯框對應列的列標題
          CALL cl_set_comp_att_text(ma_multi_rec[li_edit].colname,g_agb[l_i].agc02)
       END IF
 
       LET l_i = l_i + 1
       #這里防止下標溢出導致錯誤
       IF l_i = 11 THEN EXIT FOREACH END IF
     END FOREACH
 
     #將剩下的輔助列都設置為不可見
     FOR li_i = li_comb + 1 TO 20
         LET lc_i = li_i USING '&&'
         CALL cl_set_comp_visible('att'||lc_i,FALSE)
     END FOR
  END IF
END FUNCTION
 
 
#明細欄位處理過程，針對'att'開頭的欄位，根據輸入的內容生成明細屬性顯示信息并保存
#當前內容到對應的后台數組中
FUNCTION pmk_after_detail_field(pname,pvalue,pi)
  DEFINE pname         STRING
  DEFINE pvalue        STRING
  DEFINE pi            LIKE type_file.num5       #No.FUN-680131 SMALLINT
  DEFINE lc_string     STRING
  DEFINE lc_disp_field STRING
  DEFINE li_i,li_ia    LIKE type_file.num5       #No.FUN-680131 SMALLINT
  DEFINE li_index      LIKE type_file.num5       #No.FUN-680131 SMALLINT SMALLINT
 
  #定位到控制數組中的當前欄位記錄
  FOR li_ia = 1 TO ma_multi_rec.getLength()
      IF ma_multi_rec[li_ia].colname = pname THEN
         EXIT FOR
      END IF
  END FOR
  IF li_ia > ma_multi_rec.getLength() THEN
     RETURN
  END IF
 
  #得到當前t欄位關聯的顯示欄位名稱
  LET lc_disp_field = ma_multi_rec[li_ia].dispfld
 
  #將當前界面上接收的數值保存到控制數組中去
  LET ma_multi_rec[li_ia].value[pi] = pvalue
 
  #按照當前輸入的內容來更新顯示欄位的內容
  IF lc_disp_field.getLength() > 0 THEN
    LET lc_string = ''
    FOR li_i = 1 TO ma_multi_rec.getLength()
        #定位到只讀欄位對應的索引號
        IF ma_multi_rec[li_i].colname = lc_disp_field THEN
           LET li_index = li_i
        END IF
 
        #合成要顯示在只讀欄位中的內容
        IF ( ma_multi_rec[li_i].colname.subString(1,3) = 'att' )AND
           ( ma_multi_rec[li_i].dispfld = lc_disp_field ) THEN
           #如果該欄位當前行中有值則將其添加到只讀欄位中去
           IF ma_multi_rec[li_i].value[pi].getLength() > 0 THEN
             IF lc_string.getLength() = 0 THEN
                 LET lc_string = cl_get_comb_text('formonly.'||ma_multi_rec[li_i].colname,
                                     ma_multi_rec[li_i].value[pi])
             ELSE
                 LET lc_string = lc_string,',',
                     cl_get_comb_text('formonly.'||ma_multi_rec[li_i].colname,
                                      ma_multi_rec[li_i].value[pi])
             END IF
           END IF
        END IF
    END FOR
 
    #修改該t欄位當前在屏幕上的顯示
#    CALL cl_set_array_value(li_ia,pi,pvalue)
    #修改該t欄位對應的顯示列的當前在屏幕上的顯示
    LET ma_cons_lif[pi].attdesc = lc_string  #這裡這樣寫可以少用一個函數cl_set_array_value
#    CALL cl_set_array_value(li_index,pi,lc_string)
    #將只讀顯示列的內容保存到控制數組中的對應位置，因為這些列是noEntry的
    #不能自己觸發after_detail_field事件所以只能由其他欄位來寫
    LET ma_multi_rec[li_index].value[pi] = lc_string
 
  END IF
 
END FUNCTION
 
#該函數按照控制數組ma_multi_rec中的內容來設置合成SQL相關的兩個全局變量
FUNCTION pmk_make_sql_condition()
  DEFINE li_rowcount    LIKE type_file.num5,      #No.FUN-680131 SMALLINT
         li_i,li_ia     LIKE type_file.num5,      #No.FUN-680131 SMALLINT
         li_n           LIKE type_file.num5,      #No.FUN-680131 SMALLINT
         li_idx_a       LIKE type_file.num5,      #No.FUN-680131 SMALLINT
         li_idx_b       LIKE type_file.num5,      #No.FUN-680131 SMALLINT
         li_c           LIKE type_file.num5       #No.FUN-680131 SMALLINT
  #下面的結構體存放由數組中的值轉換成為的條件語句，每行為一個RECORD
  DEFINE arr_row    DYNAMIC ARRAY OF RECORD
           #成員變量，存放包含明細屬性的條件信息，每個料件欄位，如果
           #在界面上進行了明細屬性的設置，都會包含一個RECORD
           detail      DYNAMIC ARRAY OF RECORD
             jointable    STRING,          #需要JOIN的Table
             condition    DYNAMIC ARRAY OF STRING  #
           END RECORD,
           #成員變量，存放不包含明細屬性的其他欄位的條件設置
           normal     DYNAMIC ARRAY OF STRING
         END RECORD
 
  DEFINE li_alias      LIKE type_file.num5,      #No.FUN-680131 SMALLINT
         lc_alias      STRING,
         lc_tablename  STRING
 
  DEFINE lc_group_min  STRING,
         lc_group      STRING,
         lc_line       STRING
 
 
  #和標準的cl_create_qry中的不同，這裡的行數是由per檔指定的10，所以不用麻煩去動態判斷了
  LET li_rowcount = 10
  #到這里為止已經得到了列的數量并放在了li_rowcount中
 
  #下面這個下標是用來區分用來join的各個imx_file表的別名的
  LET li_alias = 1
 
  #循環每一行
  FOR li_n = 1 to li_rowcount
      #循環該行中的每一列
      FOR li_i = 1 TO ma_multi_rec.getLength()
          #這里解釋一下處理邏輯，第一個列肯定是x欄位，依次循環
          #凡是遇到有x欄位是imafld的，則新增加一個專門的處理過程，
          #處理其后緊跟著的11個t欄位，并將列循環下標直接跳轉到這
          #11個t欄位后的第一個x欄位繼續下一次循環,如果只是一般x欄位
          #則直接對其進行處理
          #當當前欄位名稱已經是'pmn04'時，完成對當前欄位的處理過程
          #之后自動結束循環過程
 
          #如果當前行是作為料件編號的欄位(當前欄位肯定是x欄位)
          IF ma_multi_rec[li_i].imafld = 'Y' THEN
             IF ma_multi_rec[li_i].value[li_n].getLength() > 0 THEN
                #看看其后緊跟的只顯示欄位里面有沒有值，如果沒有則表示
                #沒有設置明細屬性，否則表示設置了明細屬性
                IF ma_multi_rec[li_i+1].value[li_n].getLength() = 0 THEN
                  #沒有明細屬性，只當一般的x欄位處理
                  CALL arr_row[li_n].normal.appendElement()
                  LET arr_row[li_n].normal[arr_row[li_n].normal.getLength()] =
                      cl_make_condition(ma_multi_rec[li_i].value[li_n],
                                        ma_multi_rec[li_i].dbfield,
                                        ma_multi_rec[li_i].dbtype,'')
                ELSE
                  #有明細屬性，要記錄jointable的信息，以及各個明細屬性的條件
                  CALL arr_row[li_n].detail.appendElement()
                  LET li_idx_a = arr_row[li_n].detail.getLength()
                  LET lc_alias = li_alias USING '&&'
                  LET lc_tablename = 'tab' || lc_alias  #生成不重復的表名如tab01,tab02等
                  LET arr_row[li_n].detail[li_idx_a].jointable =
                      'imx_file '||lc_tablename
                  #新增一個條件record
                  CALL arr_row[li_n].detail[li_idx_a].condition.appendElement()
                  LET li_idx_b = arr_row[li_n].detail[li_idx_a].condition.getLength()
                  LET arr_row[li_n].detail[li_idx_a].condition[li_idx_b] =
                      ma_multi_rec[li_i].dbfield || ' = ' || lc_tablename || '.imx000 AND '||
                      lc_tablename || '.imx000 LIKE ''' || ma_multi_rec[li_i].value[li_n] || '%'' '
                  #下面循環處理各個明細欄位
                  FOR li_c = 2 TO 21
                      #如果該明細屬性有值才加入到條件中
                      IF ma_multi_rec[li_i+li_c].value[li_n].getLength() > 0 THEN
                         #新增一個條件record
                         CALL arr_row[li_n].detail[li_idx_a].condition.appendElement()
                         LET li_idx_b = arr_row[li_n].detail[li_idx_a].condition.getLength()
                         LET arr_row[li_n].detail[li_idx_a].condition[li_idx_b] =
                             cl_make_condition(ma_multi_rec[li_i+li_c].value[li_n],
                                               ma_multi_rec[li_i+li_c].dbfield,
                                               ma_multi_rec[li_i+li_c].dbtype,lc_tablename)
                      END IF
                  END FOR
 
                  #增加記數標志以保証下次生成的表別名不會重復
                  LET li_alias = li_alias + 1
                END IF
             END IF
 
             #將當前下標后移21個欄位
             LET li_i = li_i + 21
          ELSE #如果不是料件編號，只是一般的x欄位
             #如果當前欄位給了值(沒有給值則不處理，就當忽略了)
             IF ma_multi_rec[li_i].value[li_n].getLength() > 0 THEN
                CALL arr_row[li_n].normal.appendElement()
                LET li_idx_a = arr_row[li_n].normal.getLength()
                LET arr_row[li_n].normal[li_idx_a] =
                    cl_make_condition(ma_multi_rec[li_i].value[li_n],
                                      ma_multi_rec[li_i].dbfield,
                                      ma_multi_rec[li_i].dbtype,'')
             END IF
          END IF
 
          #如果當前欄位已經是'pml20'(即最後一個標準欄位)則退出當前層次的循環
          IF ma_multi_rec[li_i].colname = 'pml20' THEN
             EXIT FOR
          END IF
 
      END FOR
  END FOR
 
  #按照合成的arr_row數組來賦值兩個全局變量，首先填充明細條件
  #規則，行與行之間是OR關系，同行的各個detail之間是AND關系
  #行內和detail內是AND關系
 
  #循環各個行
  LET g_multi_where = '(1 = 0)'
  LET g_multi_join = ''
  FOR li_i = 1 TO arr_row.getLength()
      #初始化臨時變量(用來存放當前列的所有條件的累加)
      LET lc_line = '1 = 1'
      #得到一行之內的所有normal條件,各個條件之間上用AND連接
      FOR li_n = 1 TO arr_row[li_i].normal.getLength()
          IF arr_row[li_i].normal[li_n].getLength() > 0 THEN
             LET lc_line = lc_line.trim(),' AND ',arr_row[li_i].normal[li_n].trim()
          END IF
      END FOR
 
      #循環一個行之內的各個明細組
      FOR li_n = 1 TO arr_row[li_i].detail.getLength()
          #如果有jointable則將其添加到g_multi_join全局變量中去
          IF arr_row[li_i].detail[li_n].jointable.getLength() > 0 THEN
             LET g_multi_join = g_multi_join.trim(),',',arr_row[li_i].detail[li_n].jointable.trim()
          END IF
          #初始化中間變量，開始循環填充一個組內的各個條件字段
          FOR li_c = 1 TO arr_row[li_i].detail[li_n].condition.getLength()
              IF arr_row[li_i].detail[li_n].condition[li_c].getLength() > 0 THEN
                 LET lc_line = lc_line.trim(),' AND ',arr_row[li_i].detail[li_n].condition[li_c].trim()
              END IF
          END FOR
      END FOR
      #將行信息添加到總的信息串中去
      LET lc_line = lc_line.trim()
      IF lc_line.getLength() > 5 THEN  #即不是初始狀態下的'1 = 1'
         LET g_multi_where = g_multi_where,'OR(',lc_line,')'
      END IF
  END FOR
 
  #注意：g_multi_join的首字符是','因此在添加到查詢語句中的時候是不需要再使用','的
  #重新整理一下g_multi_where,去除空格，并清空邏輯上的空串（即沒有設置條件）
  LET g_multi_where = g_multi_where.trim()
  IF g_multi_where = '(1 = 0)' THEN
     LET g_multi_where = ''
  END IF
 
  #好了，經歷了上面的痛苦的過程，到現在為止g_multi_join和g_multi_where已經成功地合成了
END FUNCTION
#Patch....NO.TQC-610035 <001> #
