# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name  : q_img42.4gl copy from q_img4.4gl
# Program ver.  : 1.0
# Description   : 根據料號對倉庫/儲位/批號查詢,且順序依發料優先順序
# Input parameter: p_img01:料號
#                  p_img02:倉庫
#                  p_img03:存放位置
#                  p_img04:批號
#                  p_kind :倉儲類別  'S':一般倉庫檔 'W':在製品倉庫 'A':查全部
#                  p_type :經營方式
#                  p_plant:機構別
# Date & Author : NO.FUN-960130  2009/07/22 by sunyanchun 
# Memo          : 
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:TQC-A10153 10/01/25 By lilingyu 畫面檔欄位增加,程式數組定義并未改變導致運行時當出
# Modify.........: No.FUN-A50102 10/06/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-AC0387 10/12/29 By lixia 刪除WHERE中img38
# Modify.........: No:MOD-B60084 11/06/10 By JoHung 新增q_img42畫面檔，原本用q_img4，改為新增的畫面檔
# Modify.........: No:TQC-BA0002 11/10/05 By pauline 查詢img_file時未用cl_get_target_table() 
# Modify.........: No:TQC-D20058 13/02/27 By pauline 判斷來源是否為WPC,若為WPC則隱藏多於欄位 
# Modify.........: No:TQC-D70053 13/07/23 By qirl 對axmt610的倉庫進行空管

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1, 
         img02    LIKE img_file.img02,
         img03    LIKE img_file.img03,   #NO.FUN-9B0016
         img04    LIKE img_file.img04,
         img09    LIKE img_file.img09,
         img10    LIKE img_file.img10,
         img27    LIKE img_file.img27
#TQC-A10153 --begin--
        ,img23    LIKE img_file.img23,
        imgg10_1  LIKE imgg_file.imgg10,
        imgg10_2  LIKE imgg_file.imgg10,
        imgg10_3  LIKE imgg_file.imgg10,
        imgg10_4  LIKE imgg_file.imgg10,
        imgg10_5  LIKE imgg_file.imgg10,
        imgg10_6  LIKE imgg_file.imgg10,
        imgg10_7  LIKE imgg_file.imgg10,
        imgg10_8  LIKE imgg_file.imgg10,
        imgg10_9  LIKE imgg_file.imgg10,
        imgg10_10 LIKE imgg_file.imgg10                                                                        
#TQC-A10153 --end--         
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,
         img02        LIKE img_file.img02,
         img03        LIKE img_file.img03,
         img04        LIKE img_file.img04,
         img09        LIKE img_file.img09,
         img10        LIKE img_file.img10,
         img27        LIKE img_file.img27
#TQC-A10153 --begin--
        ,img23    LIKE img_file.img23,
        imgg10_1  LIKE imgg_file.imgg10,
        imgg10_2  LIKE imgg_file.imgg10,
        imgg10_3  LIKE imgg_file.imgg10,
        imgg10_4  LIKE imgg_file.imgg10,
        imgg10_5  LIKE imgg_file.imgg10,
        imgg10_6  LIKE imgg_file.imgg10,
        imgg10_7  LIKE imgg_file.imgg10,
        imgg10_8  LIKE imgg_file.imgg10,
        imgg10_9  LIKE imgg_file.imgg10,
        imgg10_10 LIKE imgg_file.imgg10                                                                        
#TQC-A10153 --end--            
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).
DEFINE   mi_cons_index    LIKE type_file.chr1     #CONSTRUCT時回傳哪一個值      
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#
DEFINE   ms_ret1          STRING, 
         ms_ret2          STRING,
         ms_ret3          STRING
DEFINE   ms_default1      STRING, 
         ms_default2      STRING,
         ms_default3      STRING
DEFINE   ms_img01         LIKE img_file.img01
DEFINE   ms_kind          LIKE img_file.img22    #倉儲類別  
DEFINE   ms_type          LIKE type_file.chr1
DEFINE   ms_plant         LIKE img_file.imgplant
#DEFINE   g_dbs            LIKE azp_file.azp03  #TQC-A10153
 DEFINE   l_dbs            LIKE azp_file.azp03  #TQC-A10153
DEFINE   g_reconstruct    LIKE type_file.num5   
 
FUNCTION q_img42(pi_multi_sel,pi_need_cons,p_img01,ps_default1,ps_default2,ps_default3,p_kind,p_type,p_plant)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_default1    STRING  , 
            ps_default2    STRING  ,
            ps_default3    STRING  
   DEFINE   p_img01        LIKE img_file.img01
   DEFINE   p_kind         LIKE img_file.img22 
   DEFINE   p_type         LIKE type_file.chr1
   DEFINE   p_plant        LIKE img_file.imgplant
 
   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
   LET ms_default3 = ps_default3
   LET ms_img01 = p_img01
   LET ms_kind = p_kind
   LET ms_type = p_type
   LET ms_plant = p_plant
   
   WHENEVER ERROR CALL cl_err_msg_log
 
#  OPEN WINDOW w_qry WITH FORM "qry/42f/q_img4" ATTRIBUTE(STYLE="create_qry")   #MOD-B60084 mark 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_img42" ATTRIBUTE(STYLE="create_qry")  #MOD-B60084
#  CALL cl_ui_locale("q_img4")                                                  #MOD-B60084 mark
   CALL cl_ui_locale("q_img42")                                                 #MOD-B60084

   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
#   SELECT tqb05 INTO g_dbs FROM tqb_file WHERE tqb01 = ms_plant   #TQC-A10153
#    SELECT tqb05 INTO l_dbs FROM tqb_file WHERE tqb01 = ms_plant   #TQC-A10153
#    IF cl_null(l_dbs) THEN LET l_dbs = g_dbs END IF                #TQC-A10153
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF

  #TQC-D20058 add START
  #判斷來源是否為WPC,若為WPC則隱藏多於欄位
   IF FGL_GETENV("GWC") AND NOT cl_null(FGL_GETENV("GWC")) THEN
      CALL cl_set_comp_visible("img27,imgg10_1,imgg10_2,imgg10_3,imgg10_4,imgg10_5,imgg10_6,imgg10_7,imgg10_8,imgg10_9,imgg10_10",FALSE)
   END IF
  #TQC-D20058 add END

 
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("img02", "red")
   END IF
 
   CALL img42_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1,ms_ret2,ms_ret3 
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2009/07/16 by sunyanchun
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION img42_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 
            li_continue      LIKE type_file.num5      #是否繼續.
   DEFINE   li_start_index   LIKE type_file.num10,
            li_end_index     LIKE type_file.num10 
   DEFINE   li_curr_page     LIKE type_file.num5  
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 
   LET li_reconstruct = TRUE
   LET g_reconstruct = TRUE    
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         LET ms_cons_where = "1=1"
     
         CALL img42_qry_prep_result_set() 
         #如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         #如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
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
     
      CALL img42_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL img42_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL img42_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION img42_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING
   DEFINE   ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            img02      LIKE img_file.img02,
            img03      LIKE img_file.img03,
            img04      LIKE img_file.img04,
            img09      LIKE img_file.img09,
            img10      LIKE img_file.img10,
            img27      LIKE img_file.img27
#TQC-A10153 --begin--
        ,img23    LIKE img_file.img23,
        imgg10_1  LIKE imgg_file.imgg10,
        imgg10_2  LIKE imgg_file.imgg10,
        imgg10_3  LIKE imgg_file.imgg10,
        imgg10_4  LIKE imgg_file.imgg10,
        imgg10_5  LIKE imgg_file.imgg10,
        imgg10_6  LIKE imgg_file.imgg10,
        imgg10_7  LIKE imgg_file.imgg10,
        imgg10_8  LIKE imgg_file.imgg10,
        imgg10_9  LIKE imgg_file.imgg10,
        imgg10_10 LIKE imgg_file.imgg10                                                                        
#TQC-A10153 --end--               
   END RECORD
 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_img42', 'img_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',img02,img03,img04,img09,img10,img27", 
                ",img23,'','','','','','','','','','' ",       #TQC-A10153
   #             " FROM img_file",                                    #TQC-BA0002 mark
                " FROM ", cl_get_target_table(ms_plant,'img_file') ,  #TQC-BA0002 add
                " WHERE ",ms_cons_where
#TQC-D70053--add--star---
     IF g_prog = 'axmt610' THEN
        LET ls_sql = ls_sql CLIPPED," AND img22 != 'I'"
     END IF
#TQC-D70053--add--end---
   
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND img01 ='", ms_img01,"' "
      IF ms_kind !='A' THEN
         LET ls_where = ls_where CLIPPED, " AND img22 MATCHES '",ms_kind,"' "
      END IF
      IF g_reconstruct THEN
         IF ms_default1 IS NOT NULL AND ms_default1 <> ' ' THEN
            LET ls_where = ls_where CLIPPED," AND img02='",ms_default1,"' "
         END IF
         
         IF NOT cl_null(ms_default2) THEN
            LET ls_where = ls_where CLIPPED," AND img03='",ms_default2,"' "
         END IF
      END IF
   END IF
      IF ms_type = '1' THEN
         LET ls_where = ls_where CLIPPED," AND img02 NOT IN (SELECT jce02 FROM ",
                                         #g_dbs,".jce_file)"  #TQC-A10153
                                         # l_dbs,".jce_file)"  #TQC-A10153
                                         cl_get_target_table(ms_plant,'jce_file'), ")" #FUN-A50102 
      END IF
      IF ms_type MATCHES '[234]' THEN
         LET ls_where = ls_where CLIPPED," AND img02 IN (SELECT jce02 FROM ",
                                    #     g_dbs,".jce_file)" #TQC-A10153
                                          #l_dbs,".jce_file)" #TQC-A10153
                                          cl_get_target_table(ms_plant,'jce_file'), ")" #FUN-A50102 
      END IF
      #LET ls_where = ls_where CLIPPED," AND imgplant = '",ms_plant,"' AND img38 = '",ms_type,"'"
      LET ls_where = ls_where CLIPPED," AND imgplant = '",ms_plant,"'"  #TQC-AC0387
  
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED, " ORDER BY img27,img02,img03"
#FUN-990069---begin                                                                                                                 
  # IF (NOT mi_multi_sel ) THEN                                                                                                      
      CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql              #FUN-A50102	
      CALL cl_parse_qry_sql( ls_sql, ms_plant ) RETURNING ls_sql  
  # END IF                                                                                                                           
#FUN-990069---end 
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
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
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	. pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION img42_qry_set_display_data(pi_start_index, pi_end_index)
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
 
##################################################
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               . pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION img42_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_img.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL img42_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL img42_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL img42_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL img42_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL img42_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
            LET ms_ret2 = NULL       #CHI-9C0048
            LET ms_ret3 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF NOT mi_multi_sel THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
            LET ms_ret3 = ms_default3
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
 
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	. pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION img42_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               . pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION img42_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 
   DEFINE   li_continue      LIKE type_file.num5,
            li_reconstruct   LIKE type_file.num5 
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_img.*
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
         LET g_reconstruct = FALSE  
      
         EXIT DISPLAY
      ON ACTION accept
         CALL img42_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF NOT mi_multi_sel THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
            LET ms_ret3 = ms_default3
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION img42_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	. pi_sel_index   LIKE type_file.num10    所選擇的資料索引
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION img42_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10 
 
 
   #GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].img02 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].img02 CLIPPED)
            END IF
         END IF    
      END FOR
      #複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].img02
      LET ms_ret2 = ma_qry[pi_sel_index].img03
      LET ms_ret3 = ma_qry[pi_sel_index].img04
   END IF
END FUNCTION
#FUN-960130

