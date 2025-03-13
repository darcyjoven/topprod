# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Program name  : q_smy72.4gl
# Description   : 單據形態開窗查詢
# Date & Author : No.FUN-980038 2009/09/09 by chenmoyan
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.TQC-9B0191 09/12/03 By jan 單據輸單別自動帶性質时增加ICD採購類型的處理
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:CHI-B60053 11/06/09 By JoHung 將單據型態為RTN拿掉
# Modify.........: No:TQC-B60243 11/06/21 By lixh1 系統別為'ASF'，單據性質為'5'的'工單備置單別,
#                                                  單據形態開窗只出現'1:工單備置'和'2:工單退備置' 
# Modify.........: No:TQC-BB0090 11/10/10 By destiny 增加验退的单据形态
# Modify.........: No:MOD-BA0154 12/01/17 By Vampire 採購/收貨/入庫/退貨單據型態都要有'REG'/'EXP'/'CAP'/'SUB'/'TRI'/'TAP' 
# Modify.........: No:MOD-C70006 12/07/02 By Sakura 調整單據性質為4程式段
# Modify.........: No.FUN-C70014 12/07/13 By suncx 新增RunCard發料作業，所以新增单据型态D，表示RunCard發料單別

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         kind     LIKE smy_file.smy72,
         descr    LIKE ze_file.ze03
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,
         kind     LIKE smy_file.smy72,
         descr    LIKE ze_file.ze03
END RECORD
DEFINE	l_indo    ARRAY[8] of RECORD
	 sss      LIKE type_file.chr3,
	 eee      LIKE type_file.chr3
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.
DEFINE   ms_default1      STRING
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE 	 l_x              STRING
DEFINE   l_ze03           LIKE ze_file.ze03
DEFINE   l_string         STRING
DEFINE   l_system         ARRAY[8] OF LIKE type_file.chr3
DEFINE	 l_n              LIKE type_file.num5
DEFINE	 l_inx            LIKE type_file.num5
DEFINE   l_kind           LIKE smy_file.smykind
 
FUNCTION q_smy72(pi_multi_sel,pi_need_cons,p_sys,p_kind,ps_default1)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_default1    STRING  , #預設回傳值(在取消時會回傳此類預設值).
	    p_sys          LIKE smy_file.smysys,
            p_kind         LIKE smy_file.smysys
 
   LET ms_default1 = ps_default1
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET l_system[1]='apm'
   LET l_system[2]='asf'
   LET l_inx=0
   FOR l_n=1 TO 2
       IF p_sys=l_system[l_n] THEN
	   LET l_inx=l_n
	   EXIT FOR
       END IF
   END FOR
 
   IF l_inx=0 THEN RETURN ms_ret1 END IF
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_smy72" ATTRIBUTE(STYLE="create_qry")
 
   CALL cl_ui_locale("q_smy72")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   LET l_kind = p_kind
 
   #不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("za05", "red")
   END IF
 
   CALL smy72_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1 #回傳值(也許有多個).
   END IF
END FUNCTION
 
########################################
# Description  	: 畫面顯現與資料的選擇.
########################################
FUNCTION smy72_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE.
            li_continue      LIKE type_file.num5      #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10,
            li_end_index     LIKE type_file.num10
   DEFINE   li_curr_page     LIKE type_file.num5
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
     
         CALL smy72_qry_prep_result_set() 
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
     
      CALL smy72_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL smy72_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL smy72_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
##################################################
FUNCTION smy72_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING,
            ls_where_1 STRING
   DEFINE   li_i       LIKE type_file.num10
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位
            kind       LIKE smy_file.smy72,
            descr      LIKE ze_file.ze03
   END RECORD
   DEFINE tok          base.StringTokenizer
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_smy72', 'ze_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT ze03",
                " FROM ze_file",
                " WHERE ",ms_cons_where
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND ze01[1,3]='asm'",
                     " AND ze02 = '",g_lang,"'"
      CASE l_inx
         WHEN 1
            CASE l_kind
               WHEN 1
                  LET ls_where_1 = 
                  " AND ze01 IN ('asm-115','asm-116','asm-117','asm-118')"
               WHEN 2
                  LET ls_where_1 = " AND ze01 IN ('asm-119','asm-120',",
                                   "              'asm-121','asm-122',",
                                   "              'asm-123','asm-124')"
               WHEN 3
                  #LET ls_where_1 = " AND ze01 IN ('asm-101','asm-119',",  #MOD-BA0154 mark
                  LET ls_where_1 = " AND ze01 IN ('asm-119',",             #MOD-BA0154 add
                                   "              'asm-120','asm-121',",
                                   "              'asm-122','asm-123',",   #MOD-BA0154 add
                                   "              'asm-124')"              #MOD-BA0154 add              #WHEN 4 #MOD-C70006 mark
               WHEN 4   #MOD-C70006 add
                  LET ls_where_1 = " AND ze01 IN ('asm-119','asm-120',",
#                                  "              'asm-121','asm-126')"   #CHI-B60053 mark
#                                  "              'asm-121')"              #CHI-B60053      #MOD-BA0154 mark
                                   "              'asm-121','asm-122',",   #MOD-BA0154 add
                                   "              'asm-123','asm-124')"    #MOD-BA0154 add
               WHEN 7
                  LET ls_where_1 = " AND ze01 IN ('asm-119','asm-120',",
#                                  "              'asm-121','asm-126')"   #CHI-B60053 mark
#                                  "              'asm-121')"              #CHI-B60053       #MOD-BA0154 mark
                                   "              'asm-121','asm-122',",   #MOD-BA0154 add
                                   "              'asm-123','asm-124')"    #MOD-BA0154 add
               #TQC-9B0191--begin--add-----------
               #TQC-BB0090--begin
               WHEN 'E'
                  LET ls_where_1 = " AND ze01 IN ('asm-119','asm-120',",
                                   "              'asm-121','asm-122',",
                                   "              'asm-123','asm-124')"
               #TQC-BB0090--end
               WHEN 'A'
                  LET ls_where_1 = " AND ze01 IN ('asm-102','asm-103',",
                                   "              'asm-104','asm-105')"
               WHEN 'B'
                  LET ls_where_1 = " AND ze01 IN ('asm-102','asm-103',",
                                   "              'asm-104')"
               WHEN 'C'
                  LET ls_where_1 = " AND ze01 IN ('asm-102','asm-103',",
                                   "              'asm-104')"
               WHEN 'D'
                  LET ls_where_1 = " AND ze01 IN ('asm-102','asm-103',",
                                   "              'asm-104')"
               #TQC-9B0191--end--add-------------
            END CASE
         WHEN 2
            CASE l_kind
               WHEN 1   
                  LET ls_where_1 = " AND ze01 IN ('asm-127','asm-128',",
                                   "              'asm-129','asm-130',",
                                   "              'asm-131','asm-132',",
                                   "              'asm-133')"
               WHEN 3
                  LET ls_where_1 = " AND ze01 IN ('asm-134','asm-135',",
                                   "              'asm-136','asm-137',",
                                   "              'asm-138','asm-139','asm-146')"  #FUN-C70014 add asm-146
               WHEN 4
                  LET ls_where_1 = " AND ze01 IN ('asm-140','asm-141',",
                                   "              'asm-142','asm-143',",
                                   "              'asm-144')"
              #TQC-B60243 ---------------------Begin----------------------
               WHEN 5
                  LET ls_where_1 = " AND ze01 IN ('asm-093','asm-094')"
              #TQC-B60243 ---------------------End------------------------
            END CASE
      END CASE
      LET ls_where = ls_where CLIPPED,ls_where_1 CLIPPED,
                     " ORDER BY ze01 "
   END IF
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO l_ze03
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      LET l_string = l_ze03
      LET tok=base.StringTokenizer.create(l_string,":")
      WHILE tok.hasMoreTokens()
         LET l_x=tok.nextToken()
         LET lr_qry.kind=l_x
         LET l_x=tok.nextToken()
         LET lr_qry.descr=l_x
         EXIT WHILE
      END WHILE
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
##################################################
FUNCTION smy72_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_i             LIKE type_file.num10,
            li_j             LIKE type_file.num10
 
 
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
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
##################################################
FUNCTION smy72_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_kind.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_kind.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL smy72_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_kind.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL smy72_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL smy72_qry_refresh()
     
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
            CALL smy72_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL smy72_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
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
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION smy72_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION smy72_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
 
 
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
         CALL smy72_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
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
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION smy72_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION smy72_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].kind CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].kind CLIPPED)
            END IF
         END IF    
      END FOR
      # 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].kind CLIPPED
   END IF
END FUNCTION
#No.FUN-980038
