# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Program name  : q_rvaaqc3.4gl
# Program ver.  : 
# Description   : 收料單號目查詢
# Date & Author : 2007/02/09 by rainy   #CHI-6B0075
# Memo          : 
#
# Modify........: MOD-7B0125 2007/11/13 By xufeng 錄入時,收貨單號應該可以CONSTRUCT查詢
# Modify........: MOD-810045 2008/01/11 By claire ms_cons_where 沒有值時也應給1=1
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: NO.MOD-850323 08/05/30 By claire l_qcs22,l_rvb07 要default=0
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-890151 08/09/17 By Pengu  剛新增的收貨單無法查詢到
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-980025 09/10/09 By dxfwo hardcode的部分修改
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:MOD-C20004 12/02/01 By ck2yuan 匯出excel功能修正
# Modify.........: No.MOD-C30275 12/03/10 By xianghui 為抓取apmt111的資料，在抓資料的SQL後面用UNAION ALL串一句SQL
# Modify.........: No:MOD-CA0119 12/10/19 By suncx IQC數量和採購允收數量勾稽時,入庫+驗退>=收貨數量時，則不需開窗帶出
# Modify.........: No:FUN-C30163 12/12/27 By pauline 增加顯示待驗量,並且待驗量為0時不顯示
  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,	
		rva01  LIKE rva_file.rva01,
		rvb02  LIKE rvb_file.rvb02,
		rva02  LIKE rva_file.rva02,
		rva05  LIKE rva_file.rva05,
		rva03  LIKE rva_file.rva03,
		rva06  LIKE rva_file.rva06,
		rvb05  LIKE rvb_file.rvb05,
                qcs22  LIKE qcs_file.qcs22    #FUN-C30163 add
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,	
		rva01  LIKE rva_file.rva01,
		rvb02  LIKE rvb_file.rvb02,
		rva02  LIKE rva_file.rva02,
		rva05  LIKE rva_file.rva05,
		rva03  LIKE rva_file.rva03,
		rva06  LIKE rva_file.rva06,
		rvb05  LIKE rvb_file.rvb05,
                qcs22  LIKE qcs_file.qcs22    #FUN-C30163 add
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5   #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5   #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10  #每頁顯現資料筆數.
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING  
DEFINE   ms_ret2          STRING  
 
 
FUNCTION q_rvaaqc3(pi_multi_sel,pi_need_cons,ps_default1)
   DEFINE   pi_multi_sel   LIKE type_file.num5,	
            pi_need_cons   LIKE type_file.num5,
            ps_default1    STRING    
            {%與回傳欄位的個數相對應,格式為ps_default+流水號}
 
 
   LET ms_default1 = ps_default1
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_rvaaqc3" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_rvaaqc3")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("rva01", "red")
   END IF
 
   CALL rvaaqc3_qry_sel()
 
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
FUNCTION rvaaqc3_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,   #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,   #是否重新CONSTRUCT.預設為TRUE. 
            li_continue      LIKE type_file.num5    #是否繼續.	
   DEFINE   li_start_index   LIKE type_file.num10,	
            li_end_index     LIKE type_file.num10	
   DEFINE   li_curr_page     LIKE type_file.num5	
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
         LET ms_cons_where = " 1=1"  #MOD-810045 add
         #No.MOD-7B0125  ---begin------
         IF mi_need_cons THEN
            CONSTRUCT ms_cons_where ON rva01,rvb02,rva02,rva05,rva03,rva06,rvb05 
                                   FROM s_rva[1].rva01,s_rva[1].rvb02,s_rva[1].rva02, 
                                        s_rva[1].rva05,s_rva[1].rva03,                
                                        s_rva[1].rva06,s_rva[1].rvb05                 
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
         #No.MOD-7B0125  ---end--------
 
         CALL rvaaqc3_qry_prep_result_set() 
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
     
      CALL rvaaqc3_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL rvaaqc3_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL rvaaqc3_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION rvaaqc3_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,
            rva01  LIKE rva_file.rva01,
            rvb02  LIKE rvb_file.rvb02,
            rva02  LIKE rva_file.rva02,
            rva05  LIKE rva_file.rva05,
            rva03  LIKE rva_file.rva03,
            rva06  LIKE rva_file.rva06,
            rvb05  LIKE rvb_file.rvb05,
            qcs22  LIKE qcs_file.qcs22    #FUN-C30163 add
   END RECORD
   DEFINE l_rvb07  LIKE rvb_file.rvb07,
          l_qcs22  LIKE qcs_file.qcs22
   DEFINE l_rvb29  LIKE rvb_file.rvb29,  #MOD-CA0119
          l_rvb30  LIKE rvb_file.rvb30   #MOD-CA0119

 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_rvaaqc3', 'rva_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',rva01,rvb02,rva02,rva05,rva03,rva06,rvb05,'' ",    #FUN-C30163 add ''
                " FROM rva_file,rvb_file,pmm_file ",
                " WHERE rva01=rvb01 AND rvb04=pmm01 ",
                "   AND rvaacti='Y' AND rvaconf = 'Y'",
               #-------------No.MOD-890151 modify
               #"   AND pmm18 <> 'X'  AND rvb31>0 AND rvb18<='30' ",
                "   AND pmm18 <> 'X'  AND rvb31>=0 AND rvb18<='30' ",
               #-------------No.MOD-890151 end
                "   AND rvb39 <>'N' AND rvb19 <>'2'",
                "   AND ",ms_cons_where,
                #MOD-C30275----add----str----
                " UNION ALL ",
                "SELECT 'N',rva01,rvb02,rva02,rva05,rva03,rva06,rvb05 ,'' ",  #FUN-C30163 add ''
                " FROM rva_file,rvb_file ",
                " WHERE rva01=rvb01 AND rva00='2' ",
                "   AND rvaacti='Y' AND rvaconf = 'Y'",
                "   AND rvb31>=0 AND rvb18<='30' ",
                "   AND rvb39 <>'N' AND (rvb19 <>'2' OR rvb19 IS NULL)",
                "   AND ",ms_cons_where
                #MOD-C30275----add----end----
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY rva01,rvb02"
 
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
     
    #過濾掉已登打的資料
      SELECT rvb07
       INTO l_rvb07
       FROM rvb_file
      WHERE rvb01=lr_qry.rva01
        AND rvb02=lr_qry.rvb02
      IF cl_null(l_rvb07) THEN LET l_rvb07 = 0 END IF
 
      SELECT SUM(qcs22)
        INTO l_qcs22 FROM qcs_file
       WHERE qcs01 =lr_qry.rva01
         AND qcs02 =lr_qry.rvb02
         AND qcs14 !='X'
         AND qcs00 = '1'
      IF cl_null(l_rvb07) THEN LET l_rvb07=0 END IF #MOD-850323
      IF cl_null(l_qcs22) THEN LET l_qcs22=0 END IF #MOD-850323
      IF l_rvb07-l_qcs22 < = 0 THEN
        CONTINUE FOREACH
      END IF
      LET lr_qry.qcs22 = l_rvb07 - l_qcs22    #FUN-C30163 add
      #MOD-CA0119 add begin------------------------------------
      IF g_sma.sma886[8,8] = 'Y' THEN
         SELECT rvb29,rvb30
           INTO l_rvb29,l_rvb30
           FROM rvb_file
          WHERE rvb01=lr_qry.rva01
            AND rvb02=lr_qry.rvb02
          IF cl_null(l_rvb29) THEN LET l_rvb29 = 0 END IF
          IF cl_null(l_rvb30) THEN LET l_rvb30 = 0 END IF
          IF l_rvb07 - l_rvb30 - l_rvb29 <=0 THEN
             CONTINUE FOREACH
          END IF
      END IF
      #MOD-CA0119 add end-------------------------------------- 

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
# Parameter   	: pi_start_index   LIKE type_file.type07   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.type07   所要顯現的查詢資料結束位置
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION rvaaqc3_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/24 by jack
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.type07   所要顯現的查詢資料起始位置
#               : pi_end_index     LIKE type_file.type07   所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvaaqc3_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,	
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
  #---MOD-C20004 str add-----
   DEFINE w ui.Window
   DEFINE f ui.Form
   DEFINE page om.DomNode
  #---MOD-C20004 end add----- 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_rva.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_rva.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_rva.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL rvaaqc3_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_rva.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL rvaaqc3_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL rvaaqc3_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_rva.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL rvaaqc3_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL rvaaqc3_qry_accept(pi_start_index+ARR_CURR()-1)
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
        #---MOD-C20004 str add-----
         LET w = ui.Window.getCurrent()
         LET f = w.getForm()
         LET page = f.FindNode("Table","s_rva")
         CALL cl_export_to_excel(page,base.TypeInfo.create(ma_qry),'','')
        #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
        #---MOD-C20004 end add-----
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
# Parameter   	: pi_start_index   
#               : pi_end_index    
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvaaqc3_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2003/09/24 by jack
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   INTEGER  所要顯現的查詢資料起始位置
#               : pi_end_index     INTEGER  所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvaaqc3_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10,
            pi_end_index     LIKE type_file.num10
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5
  #---MOD-C20004 str add-----
   DEFINE w ui.Window
   DEFINE f ui.Form
   DEFINE page om.DomNode
  #---MOD-C20004 end add----- 
 
   DISPLAY ARRAY ma_qry_tmp TO s_rva.*
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
         CALL rvaaqc3_qry_accept(pi_start_index+ARR_CURR()-1)
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
        #---MOD-C20004 str add-----
         LET w = ui.Window.getCurrent()
         LET f = w.getForm()
         LET page = f.FindNode("Table","s_rva")
         CALL cl_export_to_excel(page,base.TypeInfo.create(ma_qry),'','')
        #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
        #---MOD-C20004 end add-----
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
FUNCTION rvaaqc3_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/24 by jack
# Parameter   	: pi_sel_index   INTEGER  所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvaaqc3_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].rva01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].rva01 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].rva01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].rvb02 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
#CHI-6B0075
