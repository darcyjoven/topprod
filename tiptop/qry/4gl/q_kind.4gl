# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name  : q_kind.4gl
# Program ver.  : 7.0
# Description   : 主製程作業序號資料查詢
# Date & Author : 2003/09/23 by Winny
# Memo          : 
# Modify        :
# Modify........: No.MOD-520132 05/02/29 By pengu 單據性質欄位的動態開窗，由原本讀取za_file 改讀取ze_file
# Modify........: No.MOD-540166 05/05/05 By Carol aim 改 26-38
# Modify........: No.MOD-560234 05/07/15 By elva  加單據系統別AEM  
# Modify........: No.MOD-5B0311 06/01/23 By Carrier SQL語句修正
# Modify........: No.FUN-5C0114 06/02/15 By kim 加入ASR報工單的單據性質
# Modify........: No.FUN-610014 06/02/20 By vivien smykind新增aimE雜發申請單,apm9調撥申請單  
# Modify........: No.FUN-660161 06/07/07 By cl  增加匯出Excel功能
# Modify........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify........: No.FUN-690003 06/09/18 By Mandy #改寫,因為多了apm:'asm-049':廠商申請及aim:'asm-023':料件申請
# Modify........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify........: NO.FUN-720041 07/03/12 BY yiting 增加「品質異常單」選項
# Modify........: No.TQC-740154 07/05/04 By kim 加入ASF報工單的單據性質
# Modify........: No.CHI-6A0061 07/05/28 By kim AQC系統增加單據別2檢驗申請單
# Modify........: NO.FUN-6B0045 07/07/25 BY yiting ASF系統增加單據性質(MPS/獨立需求)
# Modify........: NO.FUN-770057 07/08/30 BY rainy  AIM系統增加單據性質H(廠對廠撥入單)
# Modify........: NO.FUN-810016 08/01/09 By ve007 單據性質增加服飾業類別
# Modify........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify........: No.FUN-870124 08/08/12 By jan 服飾業增加T/U單據性質
# Modify........: No.FUN-880082 08/09/02 By tsai_yen 開窗全選功能
# Modify........: No.FUN-930108 09/03/23 By zhaijie新增asm-092:5-料件承認申請單單據性質
# Modify........: No.FUN-960130 09/07/21 By Sunyanchun 新增art系統性質開窗
# Modify........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify........: No.CHI-960065 09/11/06 By jan AIM增加I單據性質
# Modify........: No.TQC-9B0191 09/12/01 By jan APM增加A/B/C/D單據性質
# Modify........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify........: No:CHI-A30014 10/03/11 By Dido 匯出excel功能修正 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         kind     LIKE type_file.chr1,          #No.FUN-680131 VARCHAR(1)
         descr    LIKE ze_file.ze03             #No.FUN-680131 VARCHAR(30)
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         kind     LIKE type_file.chr1,          #No.FUN-680131 VARCHAR(1)
         descr    LIKE ze_file.ze03             #No.FUN-680131 VARCHAR(30)
END RECORD
#No.MOD-5B0311   --Begin
#DEFINE	l_indo    ARRAY[6] of RECORD #FUN-5C0114 5->6
#DEFINE	l_indo    ARRAY[7] of RECORD #FUN-720041 6->7   #NO.FUN-960130  #NO.FUN-9B0016
DEFINE	l_indo    ARRAY[8] of RECORD #FUN-720041 7->8   #NO.FUN-960130
	 sss      LIKE type_file.chr3,          #No.FUN-680131 VARCHAR(3)
	 eee      LIKE type_file.chr3           #No.FUN-680131 VARCHAR(3)
END RECORD
#No.MOD-5B0311   --End  
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE 	 l_x              LIKE ze_file.ze03       #No.FUN-680131 VARCHAR(40)
DEFINE 	 l_cons           LIKE type_file.chr1     #No.FUN-680131 VARCHAR(1)
#DEFINE   l_system         ARRAY[6] OF LIKE type_file.chr3   #FUN-5C0114 5->6 #No.FUN-680131 VARCHAR(03) 
#DEFINE   l_system         ARRAY[7] OF LIKE type_file.chr3    #FUN-720041 6->7 #NO.FUN-960130--mark--   
DEFINE   l_system         ARRAY[8] OF LIKE type_file.chr3    #FUN-960130 7->8
DEFINE	 l_n              LIKE type_file.num5     #No.FUN-680131 SMALLINT
DEFINE	 l_inx            LIKE type_file.num5     #No.FUN-680131 SMALLINT
 
FUNCTION q_kind(pi_multi_sel,pi_need_cons,p_sys,ps_default1)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  , #預設回傳值(在取消時會回傳此類預設值).
	    p_sys          LIKE smy_file.smysys
 
   LET ms_default1 = ps_default1
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET l_system[1]='abm'
   LET l_system[2]='aim'
   LET l_system[3]='apm'
   LET l_system[4]='asf'
   LET l_system[5]='aem'   #MOD-560234 
   LET l_system[6]='asr'   #FUN-5C0114
   LET l_system[7]='aqc'   #FUN-720041
   LET l_system[8]='art'   #FUN-960130
   LET l_inx=0
   #FOR l_n=1 TO 6  #FUN-5C0114  5->6
   #FOR l_n=1 TO 7   #FUN-720041 6->7   #FUN-960130---mark---
   FOR l_n=1 TO 8    #FUN-960130 7->8
       IF p_sys=l_system[l_n] THEN
	   LET l_inx=l_n
	   EXIT FOR
       END IF
   END FOR
 
   IF l_inx=0 THEN RETURN ms_ret1 END IF
 
    #MOD-560234  --begin
   #No.MOD-5B0311  --Begin
   LET l_indo[1].sss='024' LET l_indo[1].eee='025'
#  LET l_indo[2].sss='026' LET l_indo[2].eee='038' #BugNo:6817 
   LET l_indo[2].sss='026' LET l_indo[2].eee='039' #BugNo:6817 #FUN-610014
   LET l_indo[3].sss='040' LET l_indo[3].eee='048' #apm        #FUN-610014
   LET l_indo[4].sss='050' LET l_indo[4].eee='067'
   LET l_indo[5].sss='068' LET l_indo[5].eee='071' #MOD-560234 
   LET l_indo[6].sss='072' LET l_indo[6].eee='072' #MOD-560234 
   #No.MOD-5B0311  --End  
    #MOD-560234  --end
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_kind" ATTRIBUTE(STYLE="create_qry")   #No.FUN-660161
 
   CALL cl_ui_locale("q_kind")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko :
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("za05", "red")
   END IF
 
   CALL kind_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1 #回傳值(也許有多個).
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION kind_qry_sel()
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
         LET ms_cons_where = "1=1"
     
         CALL kind_qry_prep_result_set() 
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
     
      CALL kind_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL kind_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL kind_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION kind_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING,
            ls_where_1 STRING #FUN-690003
   DEFINE   li_i       LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位	#No.FUN-680131 VARCHAR(1)
            kind       LIKE type_file.chr1,    #No.FUN-680131 VARCHAR(1)
            descr      LIKE ze_file.ze03       #No.FUN-680131 VARCHAR(30)
   END RECORD
   #------MOD-520132---------------------------------------
  #LET ls_sql = "SELECT 'N',za05",
  #             " FROM za_file",
  #             " WHERE ",ms_cons_where
  #IF NOT mi_multi_sel THEN
  #   LET ls_where = " AND za01='asmi300'",
  #                  "   AND za03 = ",g_lang,
  #                  "   AND za02 BETWEEN ", l_indo[l_inx].sss,
  #                  "                AND ", l_indo[l_inx].eee
  
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_kind', 'ze_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',ze03",
                " FROM ze_file",
                " WHERE ",ms_cons_where
   IF NOT mi_multi_sel THEN
#FUN-690003----------------------------------------mark-----------------------------------
#FUN-610014 --start
#     IF l_inx='2' THEN 
#        LET ls_where = " AND ze01[1,3]='asm'",
#                       "   AND ze02 = ",g_lang,
#        #No.MOD-5B0311  --Begin
#                       "   AND (ze01[5,7] BETWEEN '",l_indo[l_inx].sss,"'", #MOD-560234 
#                       "                AND '",l_indo[l_inx].eee,"'",
#        #No.MOD-5B0311  --End  
#                       " OR ze01 = 'asm-073' OR ze01='asm-074') "    
#     ELSE
#        LET ls_where = " AND ze01[1,3]='asm'",
#                       "   AND ze02 = ",g_lang,
#        #No.MOD-5B0311  --Begin
#                       "   AND ze01[5,7] BETWEEN '",l_indo[l_inx].sss,"'", #MOD-560234 
#                       "                AND '",l_indo[l_inx].eee,"'",
#                       " ORDER BY ze01 "
#        #No.MOD-5B0311  --End  
#     END IF
#FUN-610014 --end  
#FUN-690003----------------------------------------mark------------------------end--------
#FUN-690003----------------------------------------mod-------------------------str--------
#改寫,因為多了apm:'asm-049':廠商申請
#改寫,因為多了aim:'asm-023':料件申請
#FUN-610014 --start
      LET ls_where = " AND ze01[1,3]='asm'",
                     " AND ze02 = '",g_lang,"'"
      CASE l_inx
        WHEN 1
         #No.FUN-810016 --begin--單據性質增加類型:3-款式BOM固定屬性變更單，4-正式BOM底稿單
         IF NOT s_industry('slk') THEN
          LET ls_where_1 = " AND ze01 IN ('asm-024','asm-025','asm-092')"    #FUN-930108
         ELSE
          LET ls_where_1 = " AND ze01 IN ('asm-024','asm-025','asm-082','asm-083','asm-092')"    #FUN-930108
         END IF
         #No.FUN-810016 --end-- 	
        WHEN 2
          LET ls_where_1 = " AND ze01 IN ('asm-023',",
                           "              'asm-026','asm-027','asm-028','asm-029','asm-030',",
                           "              'asm-031','asm-032','asm-033','asm-034','asm-035',",
                           "              'asm-036','asm-037','asm-038','asm-039',",
                           "              'asm-073','asm-074','asm-081','asm-704')"  #FUN-770057 add #CHI-960065 add asm-704 
        WHEN 3
          LET ls_where_1 = " AND ze01 IN ('asm-040','asm-041','asm-042','asm-043','asm-044','asm-045',",
                           "              'asm-046','asm-047','asm-048','asm-049','asm-106','asm-107',", #TQC-9B0191 add asm-106/asm-107
                           "              'asm-108','asm-109') "    #TQC-9B0191
        WHEN 4
          #No.FUN-810016 --begin--增加單據類型:O-飛票報工單，P-產品工藝變更單                                                            
          #Q-工單工藝變更單，R-裁片轉移單
         IF NOT s_industry('slk') THEN 
          LET ls_where_1 = " AND ze01 IN ('asm-050','asm-051','asm-052','asm-053','asm-054','asm-055',",
                           "              'asm-056','asm-057','asm-058','asm-059','asm-060',",
                           "              'asm-061','asm-062','asm-063','asm-064','asm-065',",
                           "              'asm-066','asm-067','asm-077',", #TQC-740154
                           "              'asm-079','asm-080','asm-084',",   #FUN-6B0045 
                           "              'asm-085','asm-086')"
         ELSE
         	LET ls_where_1 = " AND ze01 IN ('asm-050','asm-051','asm-052','asm-053','asm-054','asm-055',",
                           "              'asm-056','asm-057','asm-058','asm-059','asm-060',",
                           "              'asm-061','asm-062','asm-063','asm-064','asm-065',",
                           "              'asm-066','asm-067','asm-077',", #TQC-740154
                           "              'asm-079','asm-080',",   #FUN-6B0045 
                           "              'asm-084','asm-085','asm-086','asm-087','asm-088','asm-089','asm-090')" #NO.FUN-870124
         END IF                                      
          #No.FUN-810016 --end--                  
        WHEN 5
          LET ls_where_1 = " AND ze01 IN ('asm-068','asm-069','asm-070','asm-071') "
        WHEN 6
          LET ls_where_1 = " AND ze01 IN ('asm-072')"
#NO.FUN-720041 start-
        WHEN 7
          LET ls_where_1 = " AND ze01 IN ('asm-076','asm-078')" #CHI-6A0061
 
#NO.FUN-720041 end---
#FUN-960130----------------begin------------
        WHEN 8
           LET ls_where_1 = " AND ze01 IN ('asm-427','asm-428','asm-429','asm-430',
                                        'asm-431','asm-432','asm-433','asm-434',
                                        'asm-435','asm-436','asm-437','asm-438',
                                        'asm-439','asm-440','asm-441','asm-442',
                                        'asm-443','asm-444','asm-445','asm-446',
                                        'asm-447','asm-448','asm-449','asm-450',
                                        'asm-451','asm-452','asm-453','asm-454')"
#FUN-960130----------------end------------
      END CASE
      LET ls_where = ls_where CLIPPED,ls_where_1 CLIPPED,
                     " ORDER BY ze01 "
#FUN-690003----------------------------------------mod-------------------------end--------
   END IF
  #---------END---------------------------------------------------------------
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO l_cons,l_x
      LET lr_qry.kind = l_x[1,1]
      LET lr_qry.descr = l_x[2,40]
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION kind_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/23 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION kind_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
  #-CHI-A30014-add-
   DEFINE w ui.Window
   DEFINE f ui.Form
   DEFINE page om.DomNode
  #-CHI-A30014-end-
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_kind.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
   #ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_kind.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL kind_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_kind.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL kind_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL kind_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_kind.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL kind_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL kind_qry_accept(pi_start_index+ARR_CURR()-1)
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
 
      #No.FUN-660161--begin
      ON ACTION exporttoexcel
        #-CHI-A30014-add-
         LET w = ui.Window.getCurrent()  
         LET f = w.getForm()   
         LET page = f.FindNode("Table","s_kind")   
         CALL cl_export_to_excel(page,base.TypeInfo.create(ma_qry),'','')
        #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
        #-CHI-A30014-end-
      #No.FUN-660161--end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
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
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION kind_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/23 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION kind_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
  #-CHI-A30014-add-
   DEFINE w ui.Window
   DEFINE f ui.Form
   DEFINE page om.DomNode
  #-CHI-A30014-end-
 
   DISPLAY ARRAY ma_qry_tmp TO s_kind.*
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
         CALL kind_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      #No.FUN-660161--begin
      ON ACTION exporttoexcel
        #-CHI-A30014-add-
         LET w = ui.Window.getCurrent()  
         LET f = w.getForm()   
         LET page = f.FindNode("Table","s_kind")   
         CALL cl_export_to_excel(page,base.TypeInfo.create(ma_qry),'','')
        #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
        #-CHI-A30014-end-
      #No.FUN-660161--end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
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
# Date & Author : 2003/09/23 by Winny
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION kind_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/23 by Winny
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION kind_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].kind CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].kind CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].kind CLIPPED
   END IF
END FUNCTION
