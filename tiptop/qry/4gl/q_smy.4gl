# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name  : q_smy.4gl
# Program ver.  : 7.0
# Description   : 單據性質查詢
# Date & Author : 2003/09/19 by Leagh
# Memo          : 
# Modify        : NO.MOD-540156 2005/06/30 By Elva 單別設限使用者及使用部門未控管
# Modify.........: No.MOD-660032 06/06/19 By Pengu 單別之部門檢核應一致捉取p_zx之部門資料
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify.........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-760072 07/06/28 By saki 欄位串查功能
# Modify.........: No.FUN-870043 08/08/19 By saki 開窗全選功能
# Modify.........: No.TQC-880037 08/08/21 By claire 開窗匯出excel結果是錯的
# Modify.........: No.FUN-950021 09/05/21 By Carrier 組合拆解
# Modify.........: No.TQC-970230 09/07/24 By lilingyu 點擊"重新查詢",無法進入自定義查詢狀態
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:MOD-C50005 12/05/02 By SunLM 單別錄入時候,委外單別只能出現在委外作業中
# Modify.........: No:TQC-C50083 12/05/11 By zhuhao Mark MOD-C50005修改內容
# Modify.........: No:FUN-C80045 12/08/17 By nanbing 開窗出的單別排除aooi410中預設POS單別rye04 
DATABASE ds
 
GLOBALS "../../config/top.global"
#查詢資料的暫存器.
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         smyslip  LIKE smy_file.smyslip,
         smydesc  LIKE smy_file.smydesc,
         smyauno  LIKE smy_file.smyauno,
         smydmy5  LIKE smy_file.smydmy5
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         smyslip  LIKE smy_file.smyslip,
         smydesc  LIKE smy_file.smydesc,
         smyauno  LIKE smy_file.smyauno,
         smydmy5  LIKE smy_file.smydmy5
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_sys           LIKE smy_file.smysys
DEFINE   ms_kind          LIKE smy_file.smykind
DEFINE   w ui.Window                                  #TQC-880037
DEFINE   n om.DomNode                                 #TQC-880037  
DEFINE   ms_par_cons_where STRING                     #No.FUN-950021
DEFINE   l_chr            LIKE type_file.chr1          #TQC-970230
 
FUNCTION q_smy(pi_multi_sel,pi_need_cons,ps_default1,p_sys,p_kind)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  , #預設回傳值(在取消時會回傳此類預設值).
            p_sys          LIKE smy_file.smysys,        #系統別
            p_kind         LIKE smy_file.smykind 	#單據性質
 
 
   LET ms_default1 = ps_default1
   LET ms_sys = p_sys
   LET ms_sys = UPSHIFT(ms_sys)  #TQC-670008 add
   LET ms_kind = p_kind
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_smy" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_smy")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("smyslip", "red")
   END IF
 
   CALL smy_qry_sel()
 
   CLOSE WINDOW w_qry
 
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
FUNCTION smy_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
    LET l_chr = 'N'                                   #TQC-970230 
 
   LET mi_page_count = 100 #每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         LET ms_cons_where = '1=1'
 
#TQC-970230 --begin--
      IF (li_continue) AND (li_reconstruct) AND (l_chr = 'Y') THEN 
         CALL smy_construct()   
      END IF  
#TQC-970230 --end-- 
     
         CALL smy_qry_prep_result_set() 
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
     
      CALL smy_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
     
      # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL smy_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL smy_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
#TQC-970230 --begin--
FUNCTION smy_construct()
  CLEAR FORM
  CALL ma_qry_tmp.clear()
  CONSTRUCT ms_cons_where ON smyslip,smydesc,smyauno,smydmy5
       FROM s_smy[1].smyslip,s_smy[1].smydesc,
            s_smy[1].smyauno,s_smy[1].smydmy5
    
     ON ACTION about         
        CALL cl_about()        
     
     ON ACTION help          
        CALL cl_show_help()  
     
     ON ACTION controlg      
        CALL cl_cmdask()      
     
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT 
  END CONSTRUCT
END FUNCTION 
#TQC-970230 --end--
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION smy_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位(per亦需將check移除). 	#No.FUN-680131 VARCHAR(1)
            smyslip  LIKE smy_file.smyslip,
            smydesc  LIKE smy_file.smydesc,
            smyauno  LIKE smy_file.smyauno,
            smydmy5  LIKE smy_file.smydmy5
   END RECORD
   DEFINE   g_gen03  LIKE gen_file.gen03  ,       #部門代號
	    l_n      LIKE type_file.num5   	#No.FUN-680131 SMALLINT
  #DEFINE   l_smy72  LIKE smy_file.smy72       #單據形態 MOD-C50005 #TQC-C50083 mark
 
 
 
   LET ls_sql= "SELECT 'N',smyslip,smydesc,smyauno,smydmy5",
               "  FROM smy_file",
               " WHERE ",ms_cons_where CLIPPED,
               " AND smyslip NOT IN (SELECT rye04 FROM rye_file WHERE ryeacti = 'Y' AND upper(rye01) = '",ms_sys,"' AND rye04 IS NOT NULL) " #FUN-C80045 add 
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND smyacti='Y'"
      IF ms_sys != '*' THEN	#若指定系統別
        #LET ls_where = ls_where CLIPPED," AND smysys ='",ms_sys,"'"         #TQC-670008 remark
         LET ls_where = ls_where CLIPPED," AND upper(smysys) ='",ms_sys,"'"  #TQC-670008
      END IF
 
      IF ms_kind != '*' THEN	#若指定單據性質
         LET ls_where = ls_where CLIPPED," AND smykind ='",ms_kind,"'" 
      END IF
   END IF
   #No.FUN-950021  --Begin
   IF ms_par_cons_where IS NOT NULL THEN
      LET ls_where = ls_where CLIPPED," AND ",ms_par_cons_where
      LET ms_par_cons_where = NULL
   END IF
   #No.FUN-950021  --End  
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_smy', 'smy_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY smyslip"
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
     #TQC-C50083 -- mark -- begin
     ##MOD-C50005 add begin 單別錄入時候,進行單別的過濾
     #SELECT smy72 INTO l_smy72 FROM smy_file
     # WHERE smyslip = lr_qry.smyslip
     #IF NOT cl_null(l_smy72) THEN 
     #   IF g_prog = 'apmt200' OR g_prog = 'apmt730' OR g_prog = 'apmt200_icd' OR g_prog = 'apmt730_icd' THEN    
     #      IF l_smy72 != 'SUB' THEN 
     #         CONTINUE FOREACH                
     #      END IF 
     #   END IF 
     #   IF g_prog = 'apmt110' OR g_prog = 'apmt720' OR g_prog = 'apmt110_icd' OR g_prog = 'apmt720_icd' THEN 
     #      IF l_smy72 = 'SUB' THEN 
     #         CONTINUE FOREACH                
     #      END IF 
     #   END IF    
     #END IF             
     ##MOD-C50005 add begin
     #TQC-C50083 -- mark -- end
      #------------------------------------------------------ 970909 Roger
      #NO:6842
      #--------------No.MOD-660032 modify
       #SELECT gen03 INTO g_gen03 FROM gen_file where gen01=g_user   #抓此人所屬部門
        SELECT zx03 INTO g_gen03 FROM zx_file where zx01=g_user   #抓此人所屬部門
      #--------------No.MOD-660032 end
      IF SQLCA.SQLCODE THEN
          LET g_gen03=NULL
      END IF
      #權限先check user再check部門
       #SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.smyslip  AND smu03=ms_sys #CHECK USER #NO.MOD-540156   #TQC-670008 remark
       SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.smyslip  AND upper(smu03)=ms_sys #CHECK USER            #TQC-670008 
      IF l_n>0 THEN                                                #USER權限存有資料,並g_user判斷是否存在
          #SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.smyslip AND smu02=g_user AND smu03=ms_sys #NO.MOD-540156         #TQC-670008 remark
          SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.smyslip AND smu02=g_user AND upper(smu03)=ms_sys #NO.MOD-540156   #TQC-670008
         IF l_n=0 THEN
             IF g_gen03 IS NULL THEN                               #g_user沒有部門           
                 CONTINUE FOREACH
             ELSE                                                  #CHECK g_user部門是否存在                                                    
                  #SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.smyslip AND smv02=g_gen03 AND smv03=ms_sys #NO.MOD-540156       #TQC-670008 remark
                  SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.smyslip AND smv02=g_gen03 AND upper(smv03)=ms_sys #NO.MOD-540156 #TQC-670008 
                 IF l_n=0 THEN
                    CONTINUE FOREACH
                 END IF
             END IF
         END IF
      ELSE                                                          #CHECK Dept               
          #SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.smyslip AND smv03=ms_sys #NO.MOD-540156       #TQC-670008 remark
          SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.smyslip AND upper(smv03)=ms_sys #NO.MOD-540156 #TQC-670008 
          IF l_n>0 THEN
             IF g_gen03 IS NULL THEN                                #g_user沒有部門     
                 CONTINUE FOREACH 
             ELSE                                                   #CHECK g_user部門是否存在
                  #SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.smyslip AND smv02=g_gen03 AND smv03=ms_sys #NO.MOD-540156       #TQC-670008 remark
                  SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.smyslip AND smv02=g_gen03 AND upper(smv03)=ms_sys #NO.MOD-540156 #TQC-670008 
                 IF l_n=0 THEN
                    CONTINUE FOREACH
                 END IF
             END IF             
          END IF
      END IF     
      #NO:6842
      #------------------------------------------------------ 970909 Roger
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION smy_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION smy_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-870043
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_smy.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)   #No.FUN-870043
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_smy.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL smy_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_smy.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL smy_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL smy_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_smy.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL smy_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL smy_qry_accept(pi_start_index+ARR_CURR()-1)
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
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
        #TQC-880037-begin-modify
        LET w = ui.Window.getCurrent()
        LET n = w.getNode()
        CALL cl_export_to_excel(n,base.TypeInfo.create(ma_qry),'','')
       #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
        #TQC-880037-end-modify
      #No.FUN-660161 --end--
   
      #No.FUN-760072 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-760072 ---end---
 
      #No.FUN-870043 --start--
      ON ACTION selectall
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "Y"
         END FOR
 
      ON ACTION select_none
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "N"
         END FOR
      #No.FUN-870043 ---end---
   
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION smy_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION smy_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_smy.*
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
         LET l_chr = 'Y'          #TQC-970230    
               
         EXIT DISPLAY
      ON ACTION accept
         CALL smy_qry_accept(pi_start_index+ARR_CURR()-1)
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
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
        #TQC-880037-begin-modify
        LET w = ui.Window.getCurrent()
        LET n = w.getNode()
        CALL cl_export_to_excel(n,base.TypeInfo.create(ma_qry),'','')
       #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
        #TQC-880037-end-modify
      #No.FUN-660161 --end--
   
      #No.FUN-760072 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-760072 ---end---
  
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
FUNCTION smy_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION smy_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].smyslip CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].smyslip CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
display "LET QUERY ms_ret1=",ms_ret1
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].smyslip CLIPPED
display "LET INSERT ms_ret1=",ms_ret1
   END IF
END FUNCTION
 
#No.FUN-950021  --Begin
FUNCTION smy_qry_set_par_where(p_where)
   DEFINE p_where STRING
 
   LET ms_par_cons_where  =  p_where
END FUNCTION
#No.FUN-950021  --End  
