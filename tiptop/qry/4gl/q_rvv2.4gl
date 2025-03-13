# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name  : q_rvv22.4gl
# Program ver.  : 7.0
# Description   : 驗收後處理資料查詢
# Date & Author : 2003/09/19 by Leagh
# Memo          : 
 # Modify        : No.MOD-530658 05/03/26 by saki VARCHAR->CHAR
# Modify.........: NO.FUN-550039 05/05/21 By jackie 單據編號加大
# Modify.........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify.........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.TQC-690032 06/09/12 By cl     去除驗退
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.TQC-830018 08/03/17 By lumx Aapt110）廠商進貨發票請款單，單身入庫單號開窗內容中，計價數量帶出的數據不對，應帶出rvv87-rvv23。 
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-910062 09/01/12 By Nicola 倉退單 數量若為 0 時不需要與已請款數量比較
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-980025 09/10/09 By dxfwo hardcode的部分修改
# Modify.........: No.TQC-9A0001 09/10/09 By wujie  rvv17>rvv23的條件寫反了
# Modify.........: No.FUN-9A0093 09/11/02 By lutingting 加傳參數營運中心
# Modify.........: No.FUN-9C0041 09/12/15 By lutingting 跨庫要去實體DB抓取資料
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-B40199 11/04/22 By Sarah SQL條件增加((rvv03='1' AND rvv87>rvv23) OR (rvv03='3' AND rvv23=0 AND rvv39>0))
# Modify.........: No:MOD-B40249 11/04/27 By Sarah 修正MOD-B40199,查詢時不需要過濾上述條件
# Modify.........: No:MOD-C50117 12/05/17 By Polly 增加開窗資料條件過濾
# Modify.........: No:TQC-C70042 12/07/05 By lujh 手動維護aapt110資料，單身入庫單號欄位開窗應過濾掉不需產生賬款資料的VMI倉的入庫單和項次等資料

DATABASE ds
 
GLOBALS "../../config/top.global"
#查詢資料的暫存器.
DEFINE   ma_qry       DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         rvv01        LIKE rvv_file.rvv01,
         rvv02        LIKE rvv_file.rvv02,
         rvv03        LIKE rvv_file.rvv03,
         rvv03_name   LIKE ze_file.ze03,        #No.FUN-680131 VARCHAR(10)
         rvv17        LIKE rvv_file.rvv17
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         rvv01        LIKE rvv_file.rvv01,
         rvv02        LIKE rvv_file.rvv02,
         rvv03        LIKE rvv_file.rvv03,
         rvv03_name   LIKE ze_file.ze03,        #No.FUN-680131 VARCHAR(10)
         rvv17        LIKE rvv_file.rvv17
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_ret1          STRING  ,  #回傳欄位的變數
         ms_ret2          LIKE rvv_file.rvv02,  #回傳欄位的變數  #No.FUN-680131 SMALLINT
         ms_vender        LIKE rvv_file.rvv06,   #No.FUN-680131 VARCHAR(10)
#         ms_default1      VARCHAR(10),
         ms_default1      LIKE rvv_file.rvv01,   #No.FUN-550039  #No.FUN-680131 VARCHAR(16)
         ms_default2      LIKE rvv_file.rvv02,                   #No.FUN-680131 SMALLINT
         ms_rvv03         LIKE rvv_file.rvv03
DEFINE   ms_dbs           LIKE type_file.chr21   #FUN-9A0093
DEFINE   ms_plant         LIKE type_file.chr10   #FUN-9A0093 

#FUNCTION q_rvv2(pi_multi_sel,pi_need_cons,p_vender,p_no1,p_no2,p_rvv03)  #FUN-9A0093	
FUNCTION q_rvv2(pi_multi_sel,pi_need_cons,p_vender,p_no1,p_no2,p_rvv03,p_plant)   #FUN-9A0093
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
#            ps_default1    VARCHAR(10), #預設回傳值(在取消時會回傳此類預設值).
            ps_default1    LIKE rvv_file.rvv01,   #No.FUN-550039  #No.FUN-680131 VARCHAR(16)
            ps_default2    LIKE rvv_file.rvv02   , #預設回傳值(在取消時會回傳此類預設值).  #No.FUN-680131 SMALLINT
            p_vender       LIKE rvv_file.rvv06,   #No.FUN-680131 VARCHAR(10)
#            p_no1	   VARCHAR(10),
            p_no1	   LIKE rvv_file.rvv01,    #No.FUN-550039 #No.FUN-680131 VARCHAR(16)
            p_no2	   LIKE rvv_file.rvv02,    #No.FUN-680131 SMALLINT
            p_rvv03        LIKE rvv_file.rvv03 
   DEFINE   p_plant        LIKE type_file.chr10    #FUN-9A0093
 
   #FUN-9A0093--add--str--
   #IF cl_null(p_plant) THEN   #FUN-A50102
   #   LET ms_dbs = NULL
   #ELSE
      LET g_plant_new = p_plant
      #FUN-9C0041--mod--str
      #CALL s_getdbs()
      #LET ms_dbs = g_dbs_new
   #    CALL s_gettrandbs()
   #    LET ms_dbs = g_dbs_tra
      #FUN-9C0041--mod--end
   #END IF 
   #FUN-9A0093--add--end 

   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
   LET ms_vender   = p_vender
   LET ms_default1 = p_no1
   LET ms_default2 = p_no2
   LET ms_rvv03    = p_rvv03
   LET ms_plant    = p_plant    #FUN-9A0093  

   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_rvv2" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_rvv2")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("rvv01", "red")
   END IF
 
   CALL rvv2_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #複選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1,ms_ret2 #回傳值(也許有多個).
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
FUNCTION rvv2_qry_sel()
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
     
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON rvv01,rvv02,rvv03
                                  FROM s_rvv[1].rvv01,s_rvv[1].rvv02,
                                       s_rvv[1].rvv03
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL rvv2_qry_prep_result_set() 
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
     
      CALL rvv2_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL rvv2_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL rvv2_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION rvv2_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check        LIKE type_file.chr1,   #如果不需要複選資料,則不要設定此欄位(per亦需將check移除). 	#No.FUN-680131 VARCHAR(1)
            rvv01        LIKE rvv_file.rvv01,
            rvv02        LIKE rvv_file.rvv02,
            rvv03        LIKE rvv_file.rvv03,
            rvv03_name   LIKE ze_file.ze03,        #No.FUN-680131 VARCHAR(10)
            rvv17        LIKE rvv_file.rvv17
   END RECORD
   DEFINE   l_rvv17      LIKE rvv_file.rvv17   #No.MOD-910062
   DEFINE   l_rvv23      LIKE rvv_file.rvv23   #No.MOD-910062
 
 
#  LET ls_sql=" SELECT 'N',rvv01,rvv02,rvv03,'',rvv17-rvv23",  #TQC-830018
  #LET ls_sql=" SELECT 'N',rvv01,rvv02,rvv03,'',rvv18-rvv23",  #TQC-830018
 
   LET ls_sql=" SELECT 'N',rvv01,rvv02,rvv03,'',rvv87-rvv23,rvv17,rvv23",   #No.MOD-910062 #TQC-830018
             #"   FROM rvv_file,rvu_file",   #FUN-9A0093 mark
             #"   FROM ",ms_dbs CLIPPED,"rvv_file,",ms_dbs CLIPPED,"rvu_file ",   #FUN-9A0093
              "   FROM ",cl_get_target_table(g_plant_new,'rvv_file'),",", #FUN-A50102
                         cl_get_target_table(g_plant_new,'rvu_file'),     #FUN-A50102
              "  WHERE ",ms_cons_where CLIPPED,
              "    AND rvu01 = rvv01 ",
              "    AND rvv03!='2'    ",     #No.TQC-690032
              "    AND rvuconf <> 'X'",
              "    AND rvv89 != 'Y' "       #TQC-C70042  add
             #"    AND ((rvv03='1' AND rvv87>rvv23) OR (rvv03='3' AND rvv23=0 AND rvv39>0))"  #MOD-B40199 add  #MOD-B40249 mark
  #----------------------------------MOD-C50117--------------------------------------------(S)
   IF g_prog <> 'aapt810' THEN
      LET ls_sql = ls_sql  CLIPPED, "  AND rvv40 <> 'Y' "
   END IF
  #----------------------------------MOD-C50117--------------------------------------------(E)
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND rvv06 ='", ms_vender,"'",
                     " AND ((rvv03='1' AND rvv87>rvv23) OR (rvv03='3' AND rvv23=0 AND rvv39>0))"  #MOD-B40249 add
                   # "    AND rvv17 > rvv23"   #No.MOD-910062
      IF ms_rvv03 IS NOT NULL AND ms_rvv03 <> ' ' AND ms_rvv03<>'*' THEN
         LET ls_where = ls_where CLIPPED," AND rvv03='",ms_rvv03,"' "
      END IF
   END IF
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_rvv2', 'rvv_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY rvv01,rvv02"
 
  ##NO.FUN-980025 GP5.2 add--begin						
   #IF (NOT mi_multi_sel ) THEN						
   #     #FUN-9A0093--add--str--
   #     IF NOT cl_null(ms_plant) THEN
   #        CALL cl_parse_qry_sql( ls_sql, ms_plant ) RETURNING ls_sql
   #     ELSE 
   #     #FUN-9A0093--add--end
   #        CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql						
   #     END IF   #FUN-9A0093
   #END IF						
  ##NO.FUN-980025 GP5.2 add--end
 
   DISPLAY "ls_sql=",ls_sql
   CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql  #FUN-A50102 
   CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*,l_rvv17,l_rvv23   #No.MOD-910062
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      #-----No.MOD-910062-----
      IF lr_qry.rvv03 = '3' AND l_rvv17 = 0 THEN
      ELSE
#        IF l_rvv17 > l_rvv23 THEN
         IF l_rvv17 < l_rvv23 THEN    #No.TQC-9A0001
            CONTINUE FOREACH
         END IF
      END IF
      #-----No.MOD-910062 END-----
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      IF lr_qry.rvv03 = '1' THEN
         LET lr_qry.rvv03_name = '入庫'
      END IF
      IF lr_qry.rvv03 = '2' THEN
         LET lr_qry.rvv03_name = '驗退'
      END IF
      IF lr_qry.rvv03 = '3' THEN
         LET lr_qry.rvv03_name = '倉退'
      END IF
 
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
FUNCTION rvv2_qry_set_display_data(pi_start_index, pi_end_index)
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
FUNCTION rvv2_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_rvv.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_rvv.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_rvv.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL rvv2_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_rvv.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL rvv2_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL rvv2_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_rvv.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL rvv2_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL rvv2_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvv2_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
FUNCTION rvv2_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_rvv.*
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
         CALL rvv2_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Date & Author : 2003/09/18 by Leagh
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION rvv2_qry_refresh()
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
FUNCTION rvv2_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].rvv01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].rvv01 CLIPPED)
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].rvv02 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].rvv01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].rvv02 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
