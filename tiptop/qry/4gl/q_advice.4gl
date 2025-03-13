# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name  : q_advice.4gl
# Description   : 查詢出貨單 
# Date & Author : 06/10/30 By kim FOR abxi020 
# Memo          : RETURNING ogb01,ogb03|ogb01,ogb03
#               : 回傳值出貨單,出貨項次(ogb01,ogb03)
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/08/26 By tsai_yen 開窗全選功能
 
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定 
# Modify.........: No:MOD-9C0068 09/12/08 By Smapmin 畫面路徑錯誤
#                                                    QBE增加出貨日期
#                                                    單身僅存保稅料否,若不勾應該是保稅和非保稅都要列出
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:FUN-C30073 12/08/13 By Lori QBE新增客戶條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#查詢資料的暫存器.
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
                     check  LIKE type_file.chr1,
                     ogb01  LIKE ogb_file.ogb01,        #出貨單號
                     ogb03  LIKE ogb_file.ogb03,        #出貨項次
                     ogb04  LIKE ogb_file.ogb04,        #料件編號 
                     ogb06  LIKE ogb_file.ogb06,        #品名
                     ima021 LIKE ima_file.ima021,       #規格
                     ogb12  LIKE ogb_file.ogb12,        #數量
                     ogb1014 LIKE ogb_file.ogb1014  #已放行否
                  END RECORD
 
DEFINE   ma_qry_tmp  DYNAMIC ARRAY OF RECORD
                        check  LIKE type_file.chr1,                                    
                        ogb01  LIKE ogb_file.ogb01,        #出貨單號
                        ogb03  LIKE ogb_file.ogb03,        #出貨項次
                        ogb04  LIKE ogb_file.ogb04,        #料件編號 
                        ogb06  LIKE ogb_file.ogb06,        #品名
                        ima021 LIKE ima_file.ima021,       #規格
                        ogb12  LIKE ogb_file.ogb12,        #數量
                        ogb1014 LIKE ogb_file.ogb1014  #已放行否
                     END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5   #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5   #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_no            LIKE bnb_file.bnb05      #客戶編號 
DEFINE   ms_no2           LIKE bnb_file.bnb19  #單身僅存保稅品否 
 
FUNCTION q_advice(pi_multi_sel,pi_need_cons,ps_default1,ps_no,ps_no2)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_default1    STRING,   #預設回傳值(在取消時會回傳此類預設值).
            ps_no          LIKE bnb_file.bnb05,     #客戶編號
            ps_no2         LIKE bnb_file.bnb19  #單身僅存保稅品否
 
   LET ms_default1 = ps_default1
   LET ms_no = ps_no
   LET ms_no2= ps_no2
 
   WHENEVER ERROR CALL cl_err_msg_log
 
  #OPEN WINDOW w_qry WITH FORM "qry/42f/q_advice" ATTRIBUTE(STYLE="createqry")   #MOD-9C0068       #FUN-C30073 mark
   OPEN WINDOW w_qry_advice WITH FORM "qry/42f/q_advice" ATTRIBUTE(STYLE="createqry")   #FUN-C30073 add
 
   CALL cl_ui_locale("q_advice")
   LET ms_ret1=''
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("oga01", "red")
   END IF
 
   CALL advice_qry_sel()
 
  #CLOSE WINDOW w_qry            #FUN-C30073 mark
   CLOSE WINDOW w_qry_advice     #FUN-C30073 ad
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1 #回傳值(也許有多個).
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION advice_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,   #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,   #是否重新CONSTRUCT.預設為TRUE. 
            li_continue      LIKE type_file.num5    #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10,
            li_end_index     LIKE type_file.num10
   DEFINE   li_curr_page     LIKE type_file.num5
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 #每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      #CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         CLEAR FORM
         MESSAGE ""
     
         IF (mi_need_cons) THEN  #要CONSTRUCT
            IF NOT cl_null(ms_no) THEN                                    #FUN-C30073
               CONSTRUCT ms_cons_where ON oga01,oga02 FROM oga01,oga02    #MOD-9C0068
                  BEFORE CONSTRUCT                                        #FUN-C30073
                     DISPLAY ms_no to oga03                               #FUN-C30073
                     CALL cl_set_comp_entry('oga03',FALSE)                #FUN-C30073

                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                     CONTINUE CONSTRUCT

               END CONSTRUCT
            #FUN-C30073 add begin---
            ELSE
               CONSTRUCT ms_cons_where ON oga01,oga02,oga03 FROM oga01,oga02,oga03               
                  BEFORE CONSTRUCT
                     CALL cl_set_comp_entry('oga03',TRUE)

                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                     CONTINUE CONSTRUCT

                  ON ACTION controlp
                     CASE
                        WHEN INFIELD(oga03)
                           CALL cl_init_qry_var()
                           LET g_qryparam.state = 'c'
                           LET g_qryparam.form ="q_occ"
                           LET g_qryparam.where = " occacti = 'Y' "
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO oga03
                     END CASE
               END CONSTRUCT
            END IF
            #FUN-C30073 add end----- 
    
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
 
           #IF ms_cons_where = " 1=1" THEN      #FUN-C30073
            IF ms_cons_where = " 1=1" AND cl_null(ms_no) THEN #FUN-C30073
               CALL cl_err('','9046',0) 
               CONTINUE WHILE 
            END IF
         ELSE
            LET ms_cons_where = " 1=1"
         END IF
     
         CALL advice_qry_prep_result_set() 
         # 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
         IF (mi_page_count >= ma_qry.getLength()) THEN
            LET ls_hide_act = "prevpage,nextpage"
         END IF
     
         IF (NOT mi_need_cons) THEN  #需要CONSTRUCT否
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
     
      CALL advice_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN  #複選否
         CALL advice_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL advice_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION advice_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10
   DEFINE   lr_qry   RECORD
                        check  LIKE type_file.chr1, #如果不需要複選資料,則不要設定此欄位(per亦需將check移除) 
                        ogb01  LIKE ogb_file.ogb01,        #出貨單號
                        ogb03  LIKE ogb_file.ogb03,        #出貨項次
                        ogb04  LIKE ogb_file.ogb04,        #料件編號 
                        ogb06  LIKE ogb_file.ogb06,        #品名
                        ima021 LIKE ima_file.ima021,       #規格
                        ogb12  LIKE ogb_file.ogb12,        #數量
                        ogb1014 LIKE ogb_file.ogb1014  #已放行否
                     END RECORD
 
   ##符合條件的值 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_advice', 'ogb_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',ogb01,ogb03,ogb04,ogb06,ima021,ogb12,ogb1014",
               "  FROM ogb_file,oga_file,ima_file",
               " WHERE ",ms_cons_where CLIPPED,
              #"   AND oga03 ='",ms_no,"'",       #客戶編號   #FUN-C30073 mark
               "   AND ogaconf = 'Y'",            #己確認
               "   AND oga09='2'",                #單據別
               "   AND oga01 = ogb01",
               "   AND ogb04 = ima01"             #料號

   #FUN-C30073 add begin---
   IF NOT cl_null(ms_no) THEN
      LET ls_sql = ls_sql CLIPPED,"   AND oga03 ='",ms_no,"'"
   ENd IF
   #FUN-C30073 add end-----
 
   IF ms_no2 = 'Y' THEN
      LET ls_sql = ls_sql CLIPPED, " AND ima15='Y' "
   #-----MOD-9C0068---------
   #ELSE
   #   LET ls_sql = ls_sql CLIPPED, " AND ima15='N' "
   #-----END MOD-9C0068-----
   END IF
#FUN-990069---begin 
 IF (NOT mi_multi_sel ) THEN
    CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql
 END IF     
#FUN-990069---end
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
 
      #判斷是否已達選取上限
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
  
      IF lr_qry.ogb1014 = 'N' OR cl_null(lr_qry.ogb1014) THEN
         LET lr_qry.check = 'Y'
      END IF
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION advice_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: LIKE type_file.num5   是否繼續
#               : LIKE type_file.num5   是否重新查詢
#               : LIKE type_file.num10    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION advice_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ogb.* 
        ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
        #ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
 
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
 
      ON ACTION prevpage
         CALL GET_FLDBUF(s_advice.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL advice_qry_reset_multi_sel(pi_start_index, pi_end_index)
        
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
         LET li_continue = TRUE

         EXIT INPUT
 
      ON ACTION nextpage
         CALL GET_FLDBUF(s_advice.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL advice_qry_reset_multi_sel(pi_start_index, pi_end_index)
        
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
         LET li_continue = TRUE

         EXIT INPUT
 
      ON ACTION refresh
         CALL advice_qry_refresh()
         LET pi_start_index = 1
         LET li_continue = TRUE
         EXIT INPUT
 
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
         EXIT INPUT
 
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_advice.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL advice_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL advice_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION advice_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.num10   所要顯現的查詢資料結束位置
# Return   	: LIKE type_file.num5   是否繼續
#               : LIKE type_file.num5   是否重新查詢
#               : LIKE type_file.num10    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION advice_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
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
         CALL advice_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Date & Author : 2003/09/18 by Leagh
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION advice_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_sel_index   LIKE type_file.num10   所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION advice_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10 
 
 
   # GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
   LET ms_ret1=''
   IF (mi_multi_sel) THEN  #複選否
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].ogb01 CLIPPED)
               CALL lsb_multi_sel.append("," || ma_qry[li_i].ogb03 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].ogb01 CLIPPED)
               CALL lsb_multi_sel.append("," || ma_qry[li_i].ogb03 CLIPPED)
            END IF
         END IF    
      END FOR
      # 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].ogb01 CLIPPED,
                    ",",ma_qry[pi_sel_index].ogb03 CLIPPED
   END IF
END FUNCTION
