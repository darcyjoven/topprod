# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#{
# Program name  : q_gef.sql
# Program ver.  : 7.0
# Description   : 編碼規格查詢
# Date & Author : 2004/06/23 By Danny
# Memo          : 
# Modify        :
# Modify........: No.FUN-660161 06/07/07 By cl  增加匯出Excel功能
# Modify........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
#}
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         geg03    LIKE geg_file.geg03,
         geg04    LIKE geg_file.geg04 
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         geg03        LIKE geg_file.geg03,
         geg04        LIKE geg_file.geg04 
END RECORD
DEFINE   g_geg05      DYNAMIC ARRAY OF  RECORD   
                      geg05 LIKE type_file.chr1000  #No.FUN-680131 VARCHAR(30)
                      END RECORD
DEFINE   g_gef        RECORD LIKE gef_file.* 
DEFINE   g_gei        RECORD LIKE gei_file.* 
DEFINE   g_gel        RECORD LIKE gel_file.* 
DEFINE   ms_default4_old  LIKE gef_file.gef04 
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      LIKE geg_file.geg03,
         ms_default2      LIKE gef_file.gef01,
         ms_default3      LIKE gef_file.gef02,
         ms_default4      LIKE gef_file.gef04,
         ms_default5      LIKE gef_file.gef04,
         ms_default6      LIKE gef_file.gef04,
         ms_default7      LIKE type_file.chr1000   #No.FUN-680131 VARCHAR(40)
DEFINE   ms_ret1          LIKE geg_file.geg05,
         ms_ret2          LIKE geg_file.geg03,
         ms_ret3          LIKE type_file.chr1000,  #No.FUN-680131 VARCHAR(40)
         ms_ret4          LIKE geg_file.geg03
 
FUNCTION q_gef(pi_multi_sel,pi_need_cons,ps_default1,ps_default2,
               ps_default3,ps_default4,ps_default5,ps_default6,ps_default7)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    LIKE geg_file.geg03,
            ps_default2    LIKE gef_file.gef01,
            ps_default3    LIKE gef_file.gef02,
            ps_default4    LIKE gef_file.gef04,
            ps_default5    LIKE gef_file.gef04,
            ps_default6    LIKE gef_file.gef04,
            ps_default7    LIKE type_file.chr1000       #No.FUN-680131 VARCHAR(40)
 
   WHENEVER ERROR CONTINUE
 
   LET ms_default1 = ps_default1 
   LET ms_default2 = ps_default2 
   LET ms_default3 = ps_default3 
   LET ms_default4 = ps_default4 
   LET ms_default5 = ps_default5 
   LET ms_default6 = ps_default6 
   LET ms_default7 = ps_default7 
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_gef" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_gef")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("geg03", "red")
   END IF
 
   CALL gef_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #@複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1,ms_ret2,ms_ret3,ms_ret4
   END IF
END FUNCTION
 
FUNCTION gef_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 #@每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         #此作業不開放construct, 故ms_cons_where在後續不用
         IF (mi_need_cons) THEN
            CONSTRUCT BY NAME ms_cons_where ON geg03,geg04
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL gef_qry_prep_result_set() 
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
     
      CALL gef_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
     
      # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL gef_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL gef_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
FUNCTION gef_qry_prep_result_set()
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            geg03      LIKE geg_file.geg03,
            geg04      LIKE geg_file.geg04
   END RECORD
   DEFINE   l_gel04    LIKE gel_file.gel04
   DEFINE   l_sql      STRING
 
   SELECT gel04 INTO l_gel04 FROM gel_file                                      
    WHERE gel01 = ms_default2 AND gel02 = ms_default3
                                                                                
   LET ms_default4_old = ms_default4
   IF l_gel04 = '2' THEN     #獨立段處理                                        
      LET ms_default4 = ms_default5
   END IF  
 
   LET l_sql = " SELECT * FROM gef_file,gei_file,gel_file",                   
                 "  WHERE gef01 = '",ms_default2,"'",                                
                 "    AND gef02 =  ",ms_default3,                                     
                 "    AND gef04 = '",ms_default4,"'",
                 "    AND gef01 = gei01 ",                                      
                 "    AND gel01 = gei01 ",                                      
                 "    AND gef02 = gel02 "                                      
   PREPARE q_gef_pre2 FROM l_sql                                              
   IF STATUS THEN CALL cl_err('prepare #2',STATUS,0) END IF                   
   DECLARE gef_curs CURSOR FOR q_gef_pre2                                     
   FOREACH gef_curs INTO g_gef.*,g_gei.*,g_gel.*                              
     IF STATUS THEN CALL cl_err('gef_curs',STATUS,0) END IF                   
   END FOREACH                                                                
   DISPLAY BY NAME g_gef.gef01,g_gef.gef02 
   DISPLAY BY NAME g_gei.gei02,g_gei.gei03,g_gei.gei04
   DISPLAY BY NAME g_gel.gel06 
   DISPLAY ms_default1 TO no
   DISPLAY ms_default7 TO desc
 
   LET ls_sql = "SELECT '',geg03,geg04,geg05",
                "  FROM geg_file",
                " WHERE geg01  = '",ms_default2,"'",
                "   AND geg012 =  ",ms_default3,
                "   AND geg013 = '",ms_default4,"'",
                " ORDER BY geg03 "
 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*,g_geg05[li_i].geg05
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
FUNCTION gef_qry_set_display_data(pi_start_index, pi_end_index)
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
 
FUNCTION gef_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_geg.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE)                              #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_geg.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE, APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_geg.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL gef_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_geg.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL gef_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL gef_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_geg.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL gef_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL gef_qry_accept(pi_start_index+ARR_CURR()-1)
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
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
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
 
FUNCTION gef_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
FUNCTION gef_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
   DISPLAY ARRAY ma_qry_tmp TO s_geg.*
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
         CALL gef_qry_accept(pi_start_index+ARR_CURR()-1)
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
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
   END DISPLAY
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
FUNCTION gef_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
FUNCTION gef_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            l_i             LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   #若是獨立段應保留前段的geg05,但獨立段不可為第一段  
   IF ms_default3 != 1 AND g_gel.gel04 = '2' THEN          
      LET ms_ret1 = ms_default6                               
   ELSE                                               
      LET ms_ret1 = g_geg05[pi_sel_index].geg05
   END IF                                             
                                                                                
   LET ms_ret3 = ms_default7
   IF g_gel.gel07 = 'Y' THEN                          
      LET ms_ret3 = ms_ret3 CLIPPED,ma_qry[pi_sel_index].geg04   
   END IF                                             
                                                                                
   IF ms_default4_old MATCHES '*[*%]*' THEN                
      CALL q_gef_p(ms_default4_old,ma_qry[pi_sel_index].geg03,ms_default1,
                   g_gei.gei05) RETURNING ms_ret2
   ELSE                                               
      LET ms_ret2 = ms_default4 CLIPPED,ma_qry[pi_sel_index].geg03     
   END IF           
 
   #針對獨立段之處理                                  
   LET ms_ret4 = ms_default5                                 
   IF cl_null(g_gel.gel04) THEN                       
      FOR l_i=1 TO g_gel.gel03                        
          LET ms_ret4 = ms_ret4 CLIPPED,"&"               
      END FOR                                         
   END IF                                             
   CALL s_geg05(ms_ret4,ms_default2,ms_default3+1,g_gei.gei04,'1')
        RETURNING ms_ret4
 
END FUNCTION
 
#處理編碼結果
FUNCTION q_gef_p(p_geg05,p_geg03,p_no,p_len)
   DEFINE p_len         LIKE type_file.num5     #No.FUN-680131 SMALLINT
   DEFINE l_no,p_no     LIKE geg_file.geg03
   DEFINE l_i,l_j,l_k   LIKE type_file.num5  	#No.FUN-680131 SMALLINT SMALLINT SMALLINT
   DEFINE p_geg05       LIKE geg_file.geg05
   DEFINE p_geg03       LIKE geg_file.geg03
   DEFINE l_len         LIKE type_file.num5     #No.FUN-680131 SMALLINT
   DEFINE l_flag        LIKE type_file.chr1  	#No.FUN-680131 VARCHAR(1) VARCHAR(1)
 
   LET l_flag = 'N'
   LET l_no = p_no 
   LET l_j = LENGTH(p_geg03) - 1
   LET l_k = 0
   LET l_len = LENGTH(l_no)
 
   FOR l_i = l_len + 1 TO p_len
       IF p_geg05[l_i,l_i] = '%' THEN   #獨立段
          LET l_no[l_i,l_i+l_j] = p_geg03
          LET l_flag = 'Y'
          EXIT FOR
       ELSE
          LET l_no[l_i,l_i]=p_geg05[l_i,l_i]
       END IF 
   END FOR 
   IF l_flag = 'N' THEN
      LET l_no = l_no CLIPPED,p_geg03
   END IF
 
   RETURN l_no
END FUNCTION
