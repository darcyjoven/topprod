# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Program name  : q_sgm.4gl
# Program ver.  : 7.0
# Description   : 作業序類資料查詢
# Date & Author : 2003/09/19 by Leagh
# Memo          : 
# Modify        : By cl  No.MOD-640138 增加傳入參數，判別多選查詢時所要傳出值。'1'為sgm04,'2'為sgm03
# Modify........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-980025 09/10/09 By dxfwo hardcode的部分修改
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:MOD-A10096 10/11/25 By sabrina 當有傳作業編號引數時，會查不到資料
# Modify.........: No:TQC-BC0064 12/01/13 By SunLM 修正TQC-AB0389 遺漏移除本作業sgm59
# Modify.........: No.FUN-C30163 12/12/27 By pauline aqct511查詢增加顯示待驗量
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#查詢資料的暫存器.
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         sgm03    LIKE sgm_file.sgm03,
         sgm04    LIKE sgm_file.sgm04, 
         sgm45    LIKE sgm_file.sgm45, 
         wipqty   LIKE sgm_file.sgm315,
         sgm53    LIKE sgm_file.sgm53,
         qcm22    LIKE qcm_file.qcm22    #FUN-C30163 add 
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         sgm03        LIKE sgm_file.sgm03,
         sgm04        LIKE sgm_file.sgm04, 
         sgm45        LIKE sgm_file.sgm45, 
         wipqty       LIKE sgm_file.sgm315,
         sgm53        LIKE sgm_file.sgm53,
         qcm22    LIKE qcm_file.qcm22    #FUN-C30163 add 
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default2      STRING     
DEFINE   ms_default3      STRING     
DEFINE   ms_ret2          STRING ,   #回傳欄位的變數
         ms_ret3          STRING,    #回傳欄位的變數
         ms_key1          LIKE sgm_file.sgm01
DEFINE   ms_chooseret     LIKE type_file.chr1     #回傳值選擇  No.MOD-640138  #No.FUN-680131 VARCHAR(1)
DEFINE   g_qcm01          LIKE qcm_file.qcm01     #FUN-C30163 add
DEFINE   g_qcm00          LIKE qcm_file.qcm00     #FUN-C30163 add
DEFINE   g_show_qcm22     LIKE type_file.chr1     #FUN-C30163 add  #是否顯示送驗量

#FUN-C30163 add START
#多增加傳入參數:p_show_qty  :是否顯示送驗量
#               p_qcm00     :資料來源
#               p_qcm01     :PQC單號
#FUN-C30163 add END 
#FUNCTION q_sgm(pi_multi_sel,pi_need_cons,p_key1,ps_default2,ps_chooseret)    #No.MOD-640138  #FUN-C30163 mark
FUNCTION q_sgm(pi_multi_sel,pi_need_cons,p_key1,ps_default2,ps_chooseret,p_show_qcm22,p_qcm00,p_qcm01)     #FUN-C30163  add
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    LIKE sgm_file.sgm04, #預設回傳值(在取消時會回傳此類預設值).
           #ps_default2    LIKE sgm_file.sgm03, #預設回傳值(在取消時會回傳此類預設值).     #MOD-A10096 mark
            ps_default2    LIKE sgm_file.sgm04, #預設回傳值(在取消時會回傳此類預設值).     #MOD-A10096 add
            p_key1         LIKE sgm_file.sgm01,
            p_key2         LIKE sgm_file.sgm04 
   DEFINE   ps_chooseret   LIKE type_file.chr1   #No.MOD-640138   #No.FUN-680131 VARCHAR(1)
   DEFINE   p_qcm01        LIKE qcm_file.qcm01     #FUN-C30163 add
   DEFINE   p_qcm00        LIKE qcm_file.qcm00     #FUN-C30163 add
   DEFINE   p_show_qcm22   LIKE type_file.chr1     #FUN-C30163 add  #是否顯示送驗量

   LET ms_default2 = ps_default2
   LET ms_key1     = p_key1
   LET ms_chooseret= ps_chooseret               #No.MOD-640138
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_sgm" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_sgm")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
  #FUN-C30163 add START
   LET g_qcm00 = p_qcm00
   LET g_qcm01 = p_qcm01
   LET g_show_qcm22 = p_show_qcm22
   IF cl_null(g_qcm01) THEN LET g_qcm01 = ' ' END IF
   IF cl_null(g_show_qcm22) THEN
      LET g_show_qcm22 = 'N'
   END IF
   IF g_show_qcm22 = 'Y' THEN
      CALL cl_set_comp_visible("qcm22",TRUE)
   ELSE
      CALL cl_set_comp_visible("qcm22",FALSE)
   END IF
  #FUN-C30163 add END
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("sgm04", "red")
   END IF
 
   CALL sgm_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret2 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret2,ms_ret3 #回傳值(也許有多個).
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
FUNCTION sgm_qry_sel()
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
     
         IF (mi_need_cons) THEN
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL sgm_qry_prep_result_set() 
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
     
      CALL sgm_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL sgm_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL sgm_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION sgm_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位(per亦需將check移除). 	#No.FUN-680131 VARCHAR(1)
            sgm03    LIKE sgm_file.sgm03,
            sgm04    LIKE sgm_file.sgm04, 
            sgm45    LIKE sgm_file.sgm45, 
            wipqty   LIKE sgm_file.sgm315,
            sgm53    LIKE sgm_file.sgm53,
            qcm22    LIKE qcm_file.qcm22      #FUN-C30163 add 
   END RECORD
   DEFINE   l_sgm54         LIKE sgm_file.sgm54,
            l_sgm291        LIKE sgm_file.sgm291,
            l_sgm301        LIKE sgm_file.sgm301,
            l_sgm302        LIKE sgm_file.sgm302,
            l_sgm303        LIKE sgm_file.sgm303,
            l_sgm304        LIKE sgm_file.sgm304,
            l_sgm311        LIKE sgm_file.sgm311,
            l_sgm312        LIKE sgm_file.sgm312,
            l_sgm313        LIKE sgm_file.sgm313,
            l_sgm314        LIKE sgm_file.sgm314,
            l_sgm316        LIKE sgm_file.sgm316,
            l_sgm317        LIKE sgm_file.sgm317,
            #l_sgm59         LIKE sgm_file.sgm59,  #TQC-BC0064
            l_sgm321        LIKE sgm_file.sgm321,
            l_sgm322        LIKE sgm_file.sgm322 
   DEFINE   l_sgm012        LIKE sgm_file.sgm012   #FUN-C30163 add
   DEFINE   l_sgm01         LIKE sgm_file.sgm01    #FUN-C30163 add 
 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_sgm', 'sgm_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT  'N',sgm03,sgm04,sgm45,'',sgm53,'',",    #FUN-C30163 add  ''
                "        sgm54,sgm291,sgm301,sgm302,sgm303,sgm304,",
                "        sgm311,sgm312,sgm313,", 
                "        sgm314,sgm316,sgm317,sgm321,sgm322,sgm012,sgm01 ",  #TQC-BC0064  #FUN-C30163 add sgm012,sgm01
                "  FROM sgm_file",
                " WHERE ",ms_cons_where CLIPPED
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND sgm01='",ms_key1,"'"
      IF ms_default2 IS NOT NULL THEN
         LET ls_where = ls_where CLIPPED," AND sgm04='",ms_default2,"'"
      END IF
   END IF
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY sgm03"
 
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
 
   FOREACH lcurs_qry INTO lr_qry.*,l_sgm54 ,l_sgm291,l_sgm301,l_sgm302,
                          l_sgm303,l_sgm304,l_sgm311,l_sgm312,l_sgm313,
                          l_sgm314,l_sgm316,l_sgm317,l_sgm321,l_sgm322,  #TQC-BC0064 sgm59
                          l_sgm012,l_sgm01                              #FUN-C30163 add
                          
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      IF l_sgm54='Y' THEN          # Check in='Y'
         LET lr_qry.wipqty 
                             =  l_sgm291             #check in
                              - l_sgm311 #TQC-BC0064*l_sgm59     #良品轉出
                              - l_sgm312 #TQC-BC0064*l_sgm59     #重工轉出
                              - l_sgm313 #TQC-BC0064*l_sgm59     #當站報廢
                              - l_sgm314 #TQC-BC0064*l_sgm59     #當站下線
                              - l_sgm316 #TQC-BC0064*l_sgm59
                              - l_sgm317 #TQC-BC0064*l_sgm59
#                             - l_sgm321             #委外加工量
#                             + l_sgm322             #委外完工量
      ELSE
         LET lr_qry.wipqty 
                             =  l_sgm301             #良品轉入量
                              + l_sgm302             #重工轉入量
                              + l_sgm303 
                              + l_sgm304
                              - l_sgm311 #TQC-BC0064*l_sgm59     #良品轉出
                              - l_sgm312 #TQC-BC0064*l_sgm59     #重工轉出
                              - l_sgm313 #TQC-BC0064*l_sgm59     #當站報廢
                              - l_sgm314 #TQC-BC0064*l_sgm59     #當站下線
                              - l_sgm316 #TQC-BC0064*l_sgm59
                              - l_sgm317 #TQC-BC0064*l_sgm59
#                             - l_sgm321             #委外加工量
#                             + l_sgm322             #委外完工量
      END IF
     #FUN-C30163 add START
      IF g_show_qcm22 = 'Y' THEN
         CALL sgm_get_qcm22(lr_qry.sgm03,l_sgm012,l_sgm01,g_qcm00) RETURNING lr_qry.qcm22
         IF cl_null(lr_qry.qcm22) OR lr_qry.qcm22 = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF
     #FUN-C30163 add END
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
FUNCTION sgm_qry_set_display_data(pi_start_index, pi_end_index)
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
FUNCTION sgm_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_sgm.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_sgm.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_sgm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL sgm_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_sgm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL sgm_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL sgm_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_sgm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL sgm_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL sgm_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret2 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
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
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION sgm_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION sgm_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_sgm.*
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
         CALL sgm_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
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
# Date & Author : 2003/09/18 by Leagh
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION sgm_qry_refresh()
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
FUNCTION sgm_qry_accept(pi_sel_index)
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
               IF ms_chooseret = '1' THEN                                         #No.MOD-640138
                  CALL lsb_multi_sel.append(ma_qry[li_i].sgm04 CLIPPED)
               ELSE                                                               #No.MOD-640138
                  IF ms_chooseret = '2' THEN                                      #No.MOD-640138
                     CALL lsb_multi_sel.append(ma_qry[li_i].sgm03 CLIPPED)        #No.MOD-640138
                  END IF                                                          #No.MOD-640138
               END IF                                                             #No.MOD-640138
            ELSE
               IF ms_chooseret = '1' THEN                                         #No.MOD-640138
                  CALL lsb_multi_sel.append("|" || ma_qry[li_i].sgm04 CLIPPED)     
               ELSE                                                               #No.MOD-640138
                  IF ms_chooseret = '2' THEN                                      #No.MOD-640138
                     CALL lsb_multi_sel.append("|" || ma_qry[li_i].sgm03 CLIPPED) #No.MOD-640138
                  END IF                                                          #No.MOD-640138
               END IF                                                             #No.MOD-640138
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret2 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret2 = ma_qry[pi_sel_index].sgm04 CLIPPED
      LET ms_ret3 = ma_qry[pi_sel_index].sgm03 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION

#FUN-C30163 add START
FUNCTION sgm_get_qcm22(p_sgm03,p_sgm012,p_sgm01,p_qcm00)
 DEFINE p_sgm03     LIKE sgm_file.sgm03
 DEFINE p_sgm012    LIKE sgm_file.sgm012
 DEFINE p_sgm01     LIKE sgm_file.sgm01
 DEFINE p_qcm00     LIKE qcm_file.qcm00
 DEFINE l_sgm54     LIKE sgm_file.sgm54
 DEFINE l_sgm291    LIKE sgm_file.sgm291
 DEFINE l_sgm301    LIKE sgm_file.sgm301
 DEFINE l_sgm302    LIKE sgm_file.sgm302
 DEFINE l_sgm303    LIKE sgm_file.sgm303
 DEFINE l_sgm322    LIKE sgm_file.sgm322
 DEFINE l_qcm22     LIKE qcm_file.qcm22
 DEFINE l_qcm091    LIKE qcm_file.qcm091

   LET l_qcm22 = 0

   SELECT sgm54,sgm291,sgm301,sgm302,sgm303,sgm322
    INTO l_sgm54,l_sgm291,l_sgm301,l_sgm302,l_sgm303,l_sgm322
    FROM sgm_file
    WHERE sgm01= p_sgm01 AND sgm03 = p_sgm03
      AND sgm012 = p_sgm012

   #-->已Accept 的良品數(未確認)
   SELECT SUM(qcm091) INTO l_qcm091 FROM qcm_file
    WHERE qcm03 = p_sgm01
      AND qcm05 = p_sgm03
      AND qcm01 <> g_qcm01
      AND qcm09 = '1'
      AND qcm14 <> 'X'
      AND qcm18 = '2'

   IF cl_null(l_qcm091) THEN
      LET l_qcm091 = 0
   END IF

   IF l_sgm54='Y' THEN
      LET l_qcm22 = l_sgm291
                  + l_sgm322
                  - l_qcm091
   ELSE
      LET l_qcm22 = l_sgm301 + l_sgm302 + l_sgm303
                  + l_sgm322
                  - l_qcm091
   END IF

   IF cl_null(l_qcm22) AND p_qcm00='1' THEN LET l_qcm22 = 0  END IF
   RETURN l_qcm22

END FUNCTION
#FUN-C30163 add END

