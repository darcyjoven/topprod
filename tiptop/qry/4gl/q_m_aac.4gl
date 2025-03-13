# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#{
# Program name   : q_m_aac.4gl
# Program ver.   : 7.0
# Description    : 傳票單單據性質查詢(多工廠)
# Date & Author  : 2003/09/22 by carrier
# Memo           :
# Modify.........: No.MOD-530658 05/03/26 by saki VARCHAR->CHAR
# Modify.........: No.MOD-660032 06/06/19 By Pengu 單別之部門檢核應一致捉取p_zx之部門資料
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-660161 06/07/07 By cl  增加匯出Excel功能
# Modify.........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-840125 08/06/20 By sherry 系統自動拋轉傳票設定   傳票開窗應加只能選出一般轉帳傳票單別
# Modify.........: No.MOD-880085 08/08/13 By Sarah 組ls_sql時,若mi_acc03不為NULL才需加此條件
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-8C0107 08/12/11 By Sarah SQL要不要組aac03條件,除判斷mi_acc03不為NULL還需增加mi_aac03<>' '
#}
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-980059 09/09/10 By arman  將傳入的DB變數改成plant變數
# Modify.........: No.FUN-970118 09/08/15 By hongmei增加當nmz52='Y'時,aac11可開1或3
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No.FUN-A50102 10/06/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         aac01    LIKE aac_file.aac01,
         aac02    LIKE aac_file.aac02,
         aac11    LIKE aac_file.aac11,
         aacauno  LIKE aac_file.aacauno,
         aacmxno  LIKE aac_file.aacmxno,
         aac03    LIKE aac_file.aac03
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         aac01        LIKE aac_file.aac01,
         aac02        LIKE aac_file.aac02,
         aac11        LIKE aac_file.aac11,
         aacauno      LIKE aac_file.aacauno,
         aacmxno      LIKE aac_file.aacmxno,
         aac03        LIKE aac_file.aac03
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING     
DEFINE   mi_dbs           LIKE type_file.chr21  	#No.FUN-680131 VARCHAR(21)
DEFINE   mi_sys           LIKE zz_file.zz011    	#No.FUN-680131 VARCHAR(3)
DEFINE   mi_aac03         LIKE aac_file.aac03 
DEFINE   mi_aac11         LIKE type_file.chr20          #No.FUN-680131 VARCHAR(10)
DEFINE   mi_aac10         LIKE aac_file.aac10
 
#FUNCTION q_m_aac(pi_multi_sel,pi_need_cons,p_dbs,ps_default1,p_aac11,p_aac03,p_aac10,p_sys)     #No.FUN-980059
FUNCTION q_m_aac(pi_multi_sel,pi_need_cons,p_plant,ps_default1,p_aac11,p_aac03,p_aac10,p_sys)    #No.FUN-980059
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  , 
            {%與回傳欄位的個數相對應,格式為ps_default+流水號}
            p_dbs          LIKE type_file.chr21, 	#No.FUN-680131 VARCHAR(21)
            p_plant        LIKE type_file.chr21, 	#No.FUN-980059 VARCHAR(21)
            p_sys          LIKE zz_file.zz011,   	#No.FUN-680131 VARCHAR(3)
            p_aac03        LIKE aac_file.aac03,
            p_aac11        LIKE type_file.chr20,        #No.FUN-680131 VARCHAR(10)
            p_aac10        LIKE aac_file.aac10
 
 
   ##NO.FUN-980059 GP5.2 add begin                                          
   #IF cl_null(p_plant) THEN #FUN-A50102                                               
     #LET p_dbs = NULL      #FUN-A50102                                              
   #ELSE                    #FUN-A50102                                                
     LET g_plant_new = p_plant                                             
     #CALL s_getdbs()                                                       
     #LET p_dbs = g_dbs_new  #FUN-A50102                                             
   #END IF                   #FUN-A50102                                               
   ##NO.FUN-980059 GP5.2 add end 
   LET ms_default1   = ps_default1
   LET mi_dbs    = p_dbs
   LET mi_sys    = p_sys
   LET mi_sys    = UPSHIFT(mi_sys) #TQC-670008 add
   LET mi_aac03  = p_aac03
   LET mi_aac11  = p_aac11
   LET mi_aac10  = p_aac10
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_m_aac" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_m_aac")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("aac01", "red")
   END IF
 
   CALL m_aac_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      DISPLAY "ms_ret1=",ms_ret1
      RETURN ms_ret1 
   ELSE
      DISPLAY "ms_ret2=",ms_ret1
      RETURN ms_ret1 
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_aac_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE.	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
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
 
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON aac01,aac02,aac11,aacauno,aacmxno,aac03
                                  FROM s_aac[1].aac01,   s_aac[1].aac02,
                                       s_aac[1].aac11,   s_aac[1].aacauno,
                                       s_aac[1].aacmxno, s_aac[1].aac03
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
 
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
 
         CALL m_aac_qry_prep_result_set()
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
 
      CALL m_aac_qry_set_display_data(li_start_index, li_end_index)
 
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL m_aac_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL m_aac_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
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
FUNCTION m_aac_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            aac01    LIKE aac_file.aac01,
            aac02    LIKE aac_file.aac02,
            aac11    LIKE aac_file.aac11,
            aacauno  LIKE aac_file.aacauno,
            aacmxno  LIKE aac_file.aacmxno,
            aac03    LIKE aac_file.aac03
   END RECORD
   DEFINE   l_n      LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   g_gen03  LIKE gen_file.gen03
   DEFINE   ls_where1 STRING                #FUN-970118
   
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_m_aac', 'aac_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',aac01,aac02,aac11,aacauno,aacmxno,aac03", 
                #" FROM ",mi_dbs CLIPPED,"aac_file ",
                " FROM ",cl_get_target_table(g_plant_new,'aac_file'), #FUN-A50102
                " WHERE ",ms_cons_where
  #str MOD-880085 add
  #IF NOT cl_null(mi_aac03) THEN                      #MOD-8C0107 mark
   IF NOT cl_null(mi_aac03) OR mi_aac03 <> ' ' THEN   #MOD-8C0107
      LET ls_sql=ls_sql,"   AND aac03 = '",mi_aac03,"'"     #No.FUN-840125
   END IF
  #end MOD-880085 add
  #FUN-970118---Begin
  #IF NOT mi_multi_sel THEN
  #   LET ls_where = "   AND aac11 IN ",cl_parse(mi_aac11 CLIPPED),
  #                  "   AND aacacti='Y' "
  #END IF
   IF NOT mi_multi_sel THEN
      IF g_nmz.nmz52 = 'Y' THEN
         LET ls_where = "   AND (aac11 MATCHES '",mi_aac11 CLIPPED,"'",
                        "   OR aac11='3' )",
                        "   AND aacacti='Y' "
      ELSE
      	 LET ls_where = "   AND aac11 MATCHES '",mi_aac11 CLIPPED,"'",
                        "   AND aacacti='Y' "
      END IF
   ELSE
   	  IF g_nmz.nmz52 = 'Y' THEN
   	     LET ls_where1 = " AND (aac11='1' OR aac11='3') ",
                         " AND aacacti='Y'  "
      END IF
   END IF
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY aac01"
  #FUN-970118---End 
 
   DISPLAY "ls_sql=",ls_sql
 	 CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql        #FUN-920032
         CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102 
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
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
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
       #SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.aac01 AND smu03=mi_sys   #CHECK USER        #TQC-670008 remark
       SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.aac01 AND upper(smu03)=mi_sys   #CHECK USER  #TQC-670008
       IF l_n>0 THEN                                                #USER權限存有資料,並g_user判斷是否存在
          #SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.aac01 AND smu02=g_user AND smu03=mi_sys        #TQC-670008 remark
          SELECT COUNT(*) INTO l_n FROM smu_file WHERE smu01=lr_qry.aac01 AND smu02=g_user AND upper(smu03)=mi_sys  #TQC-670008
          IF l_n=0 THEN
             IF g_gen03 IS NULL THEN                               #g_user沒有部門           
                  CONTINUE FOREACH
              ELSE                                                  #CHECK g_user部門是否存在                                                    
                  #SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.aac01 AND smv02=g_gen03  AND smv03=mi_sys        #TQC-670008 remark
                  SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.aac01 AND smv02=g_gen03  AND upper(smv03)=mi_sys  #TQC-670008
                  IF l_n=0 THEN
                     CONTINUE FOREACH
                  END IF
              END IF
          END IF
       ELSE                                                          #CHECK Dept               
          #SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.aac01 AND smv03=mi_sys        #TQC-670008 remark
          SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.aac01 AND upper(smv03)=mi_sys  #TQC-670008
           IF l_n>0 THEN
             IF g_gen03 IS NULL THEN                                #g_user沒有部門     
                  CONTINUE FOREACH 
              ELSE                                                   #CHECK g_user部門是否存在
                  #SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.aac01 AND smv02=g_gen03 AND smv03=mi_sys        #TQC-670008 remark
                  SELECT COUNT(*) INTO l_n FROM smv_file WHERE smv01=lr_qry.aac01 AND smv02=g_gen03 AND upper(smv03)=mi_sys  #TQC-670008
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION m_aac_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_aac_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_aac.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_aac.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_{%Record Name}.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_aac_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_aac.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL m_aac_qry_reset_multi_sel(pi_start_index, pi_end_index)
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION refresh
         CALL m_aac_qry_refresh()
 
         LET pi_start_index = 1
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
 
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_aac.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL m_aac_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL m_aac_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_aac_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_aac_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_aac.*
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
         CALL m_aac_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION m_aac_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION m_aac_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].aac01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].aac01 CLIPPED)
            END IF
         END IF
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].aac01 CLIPPED
      {%設定多個回傳值.格式為ms_ret+流水號}
   END IF
END FUNCTION
