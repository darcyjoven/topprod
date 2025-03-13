# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Program name  : q_ecm.4gl
# Program ver.  : 7.0
# Description   : 作業序類資料查詢
# Date & Author : 2003/09/22 by Winny
# Memo          : 
# Modify        :
# Modify........: No.MOD-530442 05/03/31 By pengu  作業編號查詢時，應一併將check-in、checkin-hold、checkout-hold 顯示出來
# Modify........: No.FUN-660161 06/07/07 By cl  增加匯出Excel功能
# Modify........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/08/29 By tsai_yen 開窗全選功能
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No.TQC-C90105 12/09/25 By chenjing 修改wip量計算
# Modify.........: No.FUN-C30163 12/12/26 By pauline aqct510查詢增加顯示待驗量
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         ecm03    LIKE ecm_file.ecm03,
         ecm04    LIKE ecm_file.ecm04, 
         ecm45    LIKE ecm_file.ecm45, 
         wipqty   LIKE ecm_file.ecm315,
         ecm53    LIKE ecm_file.ecm53, 
          #-------------No.MOD-530442-------
         ecm54    LIKE ecm_file.ecm54,
         ecm55    LIKE ecm_file.ecm55,
         ecm56    LIKE ecm_file.ecm56,
         #-----------No.MOD-530442 END-----
         qcm22    LIKE qcm_file.qcm22   #FUN-C30163 add
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         ecm03    LIKE ecm_file.ecm03,
         ecm04    LIKE ecm_file.ecm04, 
         ecm45    LIKE ecm_file.ecm45, 
         wipqty   LIKE ecm_file.ecm315,
         ecm53    LIKE ecm_file.ecm53, 
          #-------------No.MOD-530442-------
         ecm54    LIKE ecm_file.ecm54,
         ecm55    LIKE ecm_file.ecm55,
         ecm56    LIKE ecm_file.ecm56,
          #-------------No.MOD-530442-------
         qcm22    LIKE qcm_file.qcm22   #FUN-C30163 add
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_ret2          STRING     #回傳欄位的變數
DEFINE   g_key1           LIKE ecm_file.ecm01  
DEFINE   g_key2           LIKE ecm_file.ecm04  
DEFINE
          #l_ecm54          LIKE ecm_file.ecm54,     #-No.MOD-530442-------
         l_ecm59          LIKE ecm_file.ecm59,
         l_ecm291         LIKE ecm_file.ecm291,
         l_ecm301         LIKE ecm_file.ecm301,
         l_ecm302         LIKE ecm_file.ecm302,
         l_ecm303         LIKE ecm_file.ecm303,
         l_ecm311         LIKE ecm_file.ecm311,
         l_ecm312         LIKE ecm_file.ecm312,
         l_ecm313         LIKE ecm_file.ecm313,
         l_ecm314         LIKE ecm_file.ecm314,
         l_ecm316         LIKE ecm_file.ecm316,
         l_ecm321         LIKE ecm_file.ecm321,
         l_ecm322         LIKE ecm_file.ecm322
DEFINE   g_qcm00          LIKE qcm_file.qcm00    #FUN-C30163 add
DEFINE   g_qcm01          LIKE qcm_file.qcm01    #FUN-C30163 add
DEFINE   g_show_qty       LIKE type_file.chr1   #FUN-C30163 add

#FUN-C30163 add START
#多增加傳入參數:p_cons_where: 查詢資料的where 條件
#               p_show_qty  :是否顯示送驗量
#               p_qcm00     :資料來源
#               p_qcm01     :PQC單號
#FUN-C30163 add END
#FUNCTION q_ecm(pi_multi_sel,pi_need_cons,ps_default1,ps_default2)   #FUN-C30163 mark
FUNCTION q_ecm(pi_multi_sel,pi_need_cons,ps_default1,ps_default2,p_cons_where,p_show_qty,p_qcm00,p_qcm01)   #FUN-C30163 add
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  ,#預設回傳值(在取消時會回傳此類預設值).
            ps_default2    STRING   #預設回傳值(在取消時會回傳此類預設值).
   DEFINE   p_qcm00        LIKE qcm_file.qcm00   #FUN-C30163 add   #來源:1.工單  2.手動輸入
   DEFINE   p_qcm01        LIKE qcm_file.qcm01   #FUN-C30163 add   #單號
   DEFINE   p_cons_where   STRING                #FUN-C30163 add
   DEFINE   p_show_qty     LIKE type_file.chr1   #FUN-C30163 add
 
   LET ms_default1 = ps_default2
   LET g_key1 = ps_default1
   LET g_key2 = ps_default2
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_ecm" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161
 
   CALL cl_ui_locale("q_ecm")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   #FUN-C30163 add START
   LET ms_cons_where = p_cons_where
   LET g_qcm00 = p_qcm00
   LET g_qcm01 = p_qcm01  
   IF cl_null(ms_cons_where) THEN LET ms_cons_where = " 1=1"  END IF
   LET g_show_qty = p_show_qty
   IF cl_null(g_show_qty) THEN LET g_show_qty = 'N' END IF
   #FUN-C30163 add END
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("ecm04", "red")
   END IF

  #FUN-C30163 add START
   IF g_show_qty = 'Y' THEN
      CALL cl_set_comp_visible("qcm22",TRUE)
   ELSE
      CALL cl_set_comp_visible("qcm22",TRUE)
   END IF
  #FUN-C30163 add END
 
   CALL ecm_qry_sel()
 
   CLOSE WINDOW w_qry
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.   
   ELSE
      RETURN ms_ret1,ms_ret2 #回傳值(也許有多個).
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ecm_qry_sel()
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
        #LET ms_cons_where = "1=1"   #FUN-C30163 mark
     
         CALL ecm_qry_prep_result_set() 
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
     
      CALL ecm_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL ecm_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL ecm_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION ecm_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   l_ecm012 LIKE ecm_file.ecm012       #FUN-C30163 add
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
            ecm03    LIKE ecm_file.ecm03,
            ecm04    LIKE ecm_file.ecm04, 
            ecm45    LIKE ecm_file.ecm45, 
            wipqty   LIKE ecm_file.ecm315,
            ecm53    LIKE ecm_file.ecm53, 
             #-------------No.MOD-530442-------
            ecm54    LIKE ecm_file.ecm54,  
            ecm55    LIKE ecm_file.ecm55,
            ecm56    LIKE ecm_file.ecm56,
             #-------------No.MOD-530442-------
            qcm22    LIKE qcm_file.qcm22   #FUN-C30163 add
   END RECORD
 
 
    #Begin:FUN-980030
    LET l_filter_cond = cl_get_extra_cond_for_qry('q_ecm', 'ecm_file')
    IF NOT cl_null(l_filter_cond) THEN
       LET ms_cons_where = ms_cons_where,l_filter_cond
    END IF
    #End:FUN-980030
    LET ls_sql =  "SELECT 'N',ecm03,ecm04,ecm45,' ',ecm53,ecm54,ecm55,ecm56,'',",  #-No.MOD-530442  #FUN-C30163 add ''
                 "        ecm291,ecm301,ecm302,ecm311,ecm312,ecm313,", 
                 "        ecm314,ecm321,ecm322,ecm303,ecm316,ecm59,ecm012 ",    #FUN-C30163 add ecm012
                 "  FROM ecm_file",
                 " WHERE ",ms_cons_where
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND ecm01='",g_key1,"'"
      IF NOT cl_null(g_key2) THEN
           LET ls_where = ls_where CLIPPED," AND ecm04='",g_key2,"'"
      END IF
   END IF
   LET ls_sql=ls_sql CLIPPED,ls_where CLIPPED," ORDER BY ecm03"
#FUN-990069---begin 
   IF (NOT mi_multi_sel ) THEN
      CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql
   END IF     
#FUN-990069---end 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
    FOREACH lcurs_qry INTO lr_qry.*,l_ecm291,l_ecm301,l_ecm302,  #--No.MOD-530442-
                          l_ecm311,l_ecm312,l_ecm313,l_ecm314,l_ecm321,
                          l_ecm322,l_ecm303,l_ecm316,l_ecm59,l_ecm012    #FUN-C30163 add ecm012
      #TQC-C90105--add--
       IF cl_null(l_ecm59) THEN 
          LET l_ecm59 = 1
       END IF 
      #TQC-C90105--add--
      #----------No.MOD-530442-------
     #IF l_ecm54='Y' THEN          # Check in='Y'
     IF lr_qry.ecm54='Y' THEN          # Check in='Y'
      #----------No.MOD-530442-------
        LET lr_qry.wipqty 
                          =  l_ecm291             #check in
                          - l_ecm311*l_ecm59     #良品轉出
                          - l_ecm312*l_ecm59     #重工轉出
                          - l_ecm313*l_ecm59     #當站報廢
                          - l_ecm314*l_ecm59     #當站下線
                          - l_ecm316*l_ecm59
                          - l_ecm321             #委外加工量  #TQC-C90105
                          + l_ecm322             #委外完工量  #TQC-C90105
     ELSE
       LET lr_qry.wipqty 
                         =  l_ecm301             #良品轉入量
                         + l_ecm302             #重工轉入量
                         + l_ecm303 
                         - l_ecm311*l_ecm59     #良品轉出
                         - l_ecm312*l_ecm59     #重工轉出
                         - l_ecm313*l_ecm59     #當站報廢
                         - l_ecm314*l_ecm59     #當站下線
                         - l_ecm316*l_ecm59
                         - l_ecm321             #委外加工量  #TQC-C90105
                         + l_ecm322             #委外完工量  #TQC-C90105
     END IF
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
     #FUN-C30163 add START
      IF g_show_qty = 'Y' THEN
         CALL ecm_get_qty(g_key1,lr_qry.ecm03,lr_qry.ecm54,l_ecm012)  #FUN-C30163 add
              RETURNING lr_qry.qcm22   #FUN-C30163 add
         IF cl_null(lr_qry.qcm22) OR lr_qry.qcm22 = 0 THEN CONTINUE FOREACH END IF
      END IF
     #FUN-C30163 add END 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION ecm_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/22 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ecm_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_ecm.* 
   ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
   #ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_ecm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ecm_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_ecm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ecm_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL ecm_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_ecm.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL ecm_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL ecm_qry_accept(pi_start_index+ARR_CURR()-1)
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
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ecm_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/22 by Winny
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ecm_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_ecm.*
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
         CALL ecm_qry_accept(pi_start_index+ARR_CURR()-1)
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
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2003/09/22 by Winny
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION ecm_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/22 by Winny
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ecm_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].ecm04 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].ecm04 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].ecm04 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].ecm03 CLIPPED
   END IF
END FUNCTION

#FUN-C30163 add START
#取得待驗數量
FUNCTION ecm_get_qty(p_ecm01,p_ecm03,p_ecm54,p_ecm012)
DEFINE p_ecm01           LIKE ecm_file.ecm01
DEFINE p_ecm03           LIKE ecm_file.ecm03
DEFINE p_ecm54           LIKE ecm_file.ecm54
DEFINE p_ecm012          LIKE ecm_file.ecm012
DEFINE l_qty             LIKE qcm_file.qcm22 
DEFINE l_un_post_qty     LIKE qcm_file.qcm22
DEFINE l_post_qty        LIKE qcm_file.qcm22
DEFINE l_qcm091          LIKE qcm_file.qcm091
DEFINE l_ecm03_par       LIKE ecm_file.ecm03_par
DEFINE l_ecm62           LIKE ecm_file.ecm62
DEFINE l_ecm63           LIKE ecm_file.ecm63
DEFINE l_ecm04           LIKE ecm_file.ecm04
DEFINE l_ecm301          LIKE ecm_file.ecm301
DEFINE l_ecm302          LIKE ecm_file.ecm302
DEFINE l_ecm303          LIKE ecm_file.ecm303
DEFINE l_ecm291          LIKE ecm_file.ecm291
DEFINE l_ecm322          LIKE ecm_file.ecm322
DEFINE l_ecm313          LIKE ecm_file.ecm313
DEFINE l_ecm315          LIKE ecm_file.ecm315
DEFINE l_wip_qty         LIKE qcm_file.qcm22 
DEFINE l_bn_ecm012       LIKE ecm_file.ecm012
DEFINE l_bn_ecm03        LIKE ecm_file.ecm03 
DEFINE l_ima153          LIKE ima_file.ima153
DEFINE l_cnt             LIKE type_file.num10
DEFINE l_cnt2            LIKE type_file.num10
DEFINE l_min_set         LIKE sfb_file.sfb08

   LET l_qty = 0

   SELECT ecm03_par,ecm62,ecm63,ecm04,ecm301,
          ecm302,ecm303,ecm291,ecm322,ecm313
     INTO l_ecm03_par,l_ecm62,l_ecm63,l_ecm04,
          l_ecm301,l_ecm302,l_ecm303,l_ecm291,l_ecm322,l_ecm313
    FROM ecm_file
    WHERE ecm01= p_ecm01 AND ecm03 = p_ecm03
      AND ecm012 = p_ecm012

   IF cl_null(l_ecm62) OR l_ecm62=0 THEN
      LET l_ecm62=1
   END IF
   IF cl_null(l_ecm63) OR l_ecm63=0 THEN
      LET l_ecm63=1
   END IF

   SELECT SUM(qcm22) INTO l_un_post_qty FROM qcm_file
    WHERE qcm02 = p_ecm01
      AND qcm14 = 'N'   #未確認
      AND qcm01 <> g_qcm01
      AND qcm05 = p_ecm03

   IF l_un_post_qty IS NULL THEN
      LET l_un_post_qty = 0
   END IF

   SELECT SUM(qcm091) INTO l_post_qty FROM qcm_file
    WHERE qcm02 = p_ecm01
      AND qcm14 = 'Y'   #確認
      AND qcm01 <> g_qcm01
      AND qcm05 = p_ecm03

   IF l_post_qty IS NULL THEN
      LET l_post_qty = 0
   END IF
   LET l_qcm091 = l_post_qty + l_un_post_qty
   IF cl_null(l_qcm091) THEN LET l_qcm091 = 0 END IF

   IF p_ecm54='Y' THEN  #Check in 否
      LET l_qty = l_ecm291
                + l_ecm322
                - l_ecm313
                - l_qcm091
   ELSE
      IF g_sma.sma1431='N' OR cl_null(g_sma.sma1431) THEN
         LET l_qty = l_ecm301
                   + l_ecm302
                   + l_ecm303
                   + l_ecm322
                   - l_ecm313
                   - l_qcm091
      ELSE
         CALL ecm_check_auto_report(p_ecm01,'',p_ecm012,p_ecm03)
            RETURNING l_bn_ecm012,l_bn_ecm03,l_wip_qty
         LET l_qty = l_wip_qty
                   + l_ecm322
                   - l_ecm313
                   - l_qcm091
         IF cl_null(l_wip_qty) THEN LET l_wip_qty = 0 END IF
      END IF
   END IF
   IF cl_null(l_qty) AND g_qcm00='1' THEN LET l_qty = 0 END IF

   IF g_qcm00='1' THEN
      CALL s_get_ima153(l_ecm03_par) RETURNING l_ima153
      CALL s_minp_routing(p_ecm01,g_sma.sma73,l_ima153,l_ecm04,p_ecm012,p_ecm03)
      RETURNING l_cnt2,l_min_set

      SELECT SUM(ecm315) INTO l_ecm315 FROM ecm_file
       WHERE ecm01 = p_ecm01
      IF cl_null(l_ecm315) OR l_ecm315 = 0 THEN
         LET l_ecm315 = 0
      END IF
      IF g_sma.sma542 = 'Y' THEN
         SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01 = p_ecm01 AND (sfa08 = l_ecm04 OR sfa08 = ' ')
            AND sfa012 = p_ecm012 AND sfa013 = p_ecm03
            AND sfa161 > 0
      ELSE
         SELECT COUNT(*) INTO l_cnt FROM sfa_file
          WHERE sfa01 = p_ecm01 AND (sfa08 = l_ecm04 OR sfa08 = ' ')
            AND sfa161 > 0
      END IF
      IF l_qty > (l_min_set*l_ecm62/l_ecm63) + l_ecm315 AND l_cnt > 0 THEN
         LET l_qty = (l_min_set*l_ecm62/l_ecm63) + l_ecm315
      END IF
   END IF

   RETURN l_qty
END FUNCTION

FUNCTION ecm_check_auto_report(p_sfb01,p_sgm01,p_ecm012,p_ecm03)

   DEFINE p_sfb01  LIKE sfb_file.sfb01
   DEFINE p_sgm01  LIKE sgm_file.sgm01
   DEFINE p_ecm012 LIKE ecm_file.ecm012
   DEFINE p_ecm03  LIKE ecm_file.ecm03
   DEFINE l_sql    STRING
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_min_tran_out LIKE ecm_file.ecm311   #最小轉出量
   DEFINE l_min_ecm012   LIKE ecm_file.ecm012
   DEFINE l_min_ecm03    LIKE ecm_file.ecm03
   DEFINE l_ecm  RECORD
                   ecm012   LIKE ecm_file.ecm012 ,
                   ecm03    LIKE ecm_file.ecm03  ,
                   ecm301   LIKE ecm_file.ecm301 ,
                   ecm302   LIKE ecm_file.ecm302 ,
                   ecm303   LIKE ecm_file.ecm303 ,
                   ecm311   LIKE ecm_file.ecm311 ,
                   ecm312   LIKE ecm_file.ecm312 ,
                   ecm313   LIKE ecm_file.ecm313 ,
                   ecm314   LIKE ecm_file.ecm314 ,
                   ecm315   LIKE ecm_file.ecm315 ,
                   ecm316   LIKE ecm_file.ecm316 ,
                   ecm321   LIKE ecm_file.ecm321 ,
                   ecm322   LIKE ecm_file.ecm322 ,
                   ecm52    LIKE ecm_file.ecm52  ,
                   ecm62    LIKE ecm_file.ecm62  ,
                   ecm63    LIKE ecm_file.ecm63  ,
                   ecm66    LIKE ecm_file.ecm66
                END RECORD
   DEFINE l_pre_ecm012   LIKE ecm_file.ecm012
   DEFINE l_pre_ecm03    LIKE ecm_file.ecm03
   DEFINE l_aecm         RECORD LIKE ecm_file.*
   DEFINE l_ecm62        LIKE ecm_file.ecm62
   DEFINE l_ecm63        LIKE ecm_file.ecm63
   DEFINE l_ecm311       LIKE ecm_file.ecm311
   DEFINE l_ecm312       LIKE ecm_file.ecm312
   DEFINE l_ecm313       LIKE ecm_file.ecm313
   DEFINE l_ecm314       LIKE ecm_file.ecm314
   DEFINE l_ecm316       LIKE ecm_file.ecm316
   DEFINE l_ecm321       LIKE ecm_file.ecm321
   DEFINE l_ecm322       LIKE ecm_file.ecm322
   DEFINE l_min_tran_out_sum  LIKE ecm_file.ecm311

   IF p_ecm012 IS NULL THEN LET p_ecm012=' ' END IF

 #抓取當站的組成用量和底數
   SELECT ecm62,ecm63,ecm311,ecm312,ecm313,ecm314,ecm316,ecm321,ecm322
    INTO l_ecm62,l_ecm63,l_ecm311,l_ecm312,l_ecm313,l_ecm314,l_ecm316,l_ecm321,l_ecm322
    FROM ecm_file
    WHERE ecm01 = p_sfb01
      AND ecm012 = p_ecm012
      AND ecm03 = p_ecm03
   IF cl_null(l_ecm62) THEN LET l_ecm62 = 1 END IF
   IF cl_null(l_ecm63) THEN LET l_ecm63 = 1 END IF
   IF cl_null(l_ecm311) THEN LET l_ecm311 = 0 END IF
   IF cl_null(l_ecm312) THEN LET l_ecm312 = 0 END IF
   IF cl_null(l_ecm313) THEN LET l_ecm313 = 0 END IF
   IF cl_null(l_ecm314) THEN LET l_ecm314 = 0 END IF
   IF cl_null(l_ecm316) THEN LET l_ecm316 = 0 END IF
   IF cl_null(l_ecm321) THEN LET l_ecm321 = 0 END IF
   IF cl_null(l_ecm322) THEN LET l_ecm322 = 0 END IF

   LET l_sql = "SELECT ecm012,ecm03,ecm301,ecm302,ecm303,",
               "ecm311,ecm312,ecm313,ecm314,ecm315,ecm316,",
               "ecm321,ecm322,ecm52,ecm62,ecm63,ecm66 FROM ecm_file ",
               " WHERE ecm01='",p_sfb01,"'",
               "   AND ecm012='",p_ecm012,"'",
               "   AND ecm66='Y' "
   IF p_ecm03 > 0 AND p_ecm03 IS NOT NULL THEN
      LET l_sql = l_sql ,"   AND ecm03 < ",p_ecm03
   END IF
   LET l_sql = l_sql ,"  ORDER BY ecm03 DESC"

   LET l_min_ecm012 = ' '
   LET l_min_ecm03  = 0
   PREPARE ecm_auto_report_p1 FROM l_sql
   DECLARE ecm_auto_report_c1 CURSOR FOR ecm_auto_report_p1
   FOREACH ecm_auto_report_c1 INTO l_ecm.*
       LET l_min_tran_out = l_ecm.ecm311 + l_ecm.ecm315
       IF cl_null(l_ecm.ecm62) THEN LET l_ecm.ecm62 = 1 END IF
       IF cl_null(l_ecm.ecm63) THEN LET l_ecm.ecm63 = 1 END IF
       LET l_min_tran_out = l_min_tran_out/l_ecm.ecm62 * l_ecm.ecm63
       LET l_min_tran_out = l_min_tran_out * l_ecm62/l_ecm63
       IF cl_null(l_min_tran_out) THEN LET l_min_tran_out = 0 END IF
       LET l_min_ecm012 = l_ecm.ecm012
       LET l_min_ecm03  = l_ecm.ecm03
       EXIT FOREACH
   END FOREACH

   LET l_sql = "SELECT * FROM ecm_file ",
               " WHERE ecm01='",p_sfb01,"'",
               "   AND ecm012='",p_ecm012,"'"
   IF p_ecm03 > 0 AND p_ecm03 IS NOT NULL THEN
      LET l_sql = l_sql ,"   AND ecm03 < = ",p_ecm03
   END IF
  #抓取最小站的良品轉入量
   LET l_sql = l_sql ,"  ORDER BY ecm03 "
   PREPARE ecm_auto_report_p5 FROM l_sql
   DECLARE ecm_auto_report_c5 CURSOR FOR ecm_auto_report_p5

   #2.若前面無報工點='Y'的資料,則check首製程序
   IF l_min_ecm03 = 0 THEN
         LET l_min_tran_out_sum = 0   #FUN-A70095
         FOREACH ecm_auto_report_c5 INTO l_aecm.*        #FUN-A70095
            IF cl_null(l_aecm.ecm62) THEN LET l_aecm.ecm62 = 1 END IF  #FUN-A70095
            IF cl_null(l_aecm.ecm63) THEN LET l_aecm.ecm63 = 1 END IF  #FUN-A70095
            IF l_aecm.ecm54='Y' THEN   #check in ??
               LET l_min_tran_out = l_aecm.ecm291
            ELSE
              #只先算第一站的轉入量即可，在t700_sub_check_auto_report()外面再去扣除該站的轉出量
               LET l_min_tran_out = l_aecm.ecm301
                                  + l_aecm.ecm302
                                  + l_aecm.ecm303
            END IF
            IF cl_null(l_min_tran_out) THEN LET l_min_tran_out=0 END IF
            LET l_min_tran_out = l_min_tran_out/l_aecm.ecm62 * l_aecm.ecm63
            LET l_min_tran_out_sum = l_min_tran_out_sum + l_min_tran_out
            EXIT FOREACH
         END FOREACH    #FUN-A70095
         IF cl_null(l_min_tran_out_sum) THEN LET l_min_tran_out_sum=0 END IF
         LET l_min_tran_out = l_min_tran_out_sum * l_ecm62/l_ecm63
         IF cl_null(l_min_tran_out) THEN LET l_min_tran_out=0 END IF
   END IF

   LET l_min_tran_out = l_min_tran_out
                        - l_ecm311                #良品轉出
                        - l_ecm312                #重工轉出
                        - l_ecm313                #當站報廢
                        - l_ecm314                #當站下線
                        - l_ecm316                #工單轉出

   RETURN l_min_ecm012,l_min_ecm03,l_min_tran_out
END FUNCTION

#FUN-C30163 add END



