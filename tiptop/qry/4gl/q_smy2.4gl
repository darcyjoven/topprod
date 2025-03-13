# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name  : q_smy2.4gl
# Program ver.  : 7.0
# Description   : 單據性質查詢
# Date & Author : 2006/02/24 by day
# Memo          : 
# Modify        :
# Modify.........: No.MOD-660032 06/06/19 By Pengu 單別之部門檢核應一致捉取p_zx之部門資料
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify.........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.TQC-950048 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
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
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要復選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING     #回傳欄位的變數
DEFINE   ms_sys           LIKE smy_file.smysys
DEFINE   ms_kind          LIKE smy_file.smykind
DEFINE   mc_dbs           LIKE type_file.chr21       	#No.FUN-680131 VARCHAR(21)
DEFINE    g_sql           LIKE type_file.chr1000	#No.FUN-680131 VARCHAR(300)
#FUNCTION q_smy2(pi_multi_sel,pi_need_cons,ps_default1,p_sys,p_kind,p_dbs)   #No.FUN-980025
FUNCTION q_smy2(pi_multi_sel,pi_need_cons,ps_default1,p_sys,p_kind,p_plant)  #No.FUN-980025
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  , #預設回傳值(在取消時會回傳此類預設值).
            p_sys          LIKE smy_file.smysys,        #系統別
            p_kind         LIKE smy_file.smykind, 	#單據性質
            p_plant        LIKE type_file.chr10,	#No.FUN-980025 VARCHAR(10)  #No.FUN-980025
            p_dbs          LIKE type_file.chr21 	#No.FUN-680131 VARCHAR(21)
 
   ##NO.FUN-980025 GP5.2 add begin                                                                                                  
   #IF cl_null(p_plant) THEN   #FUN-A50102                                                                                                       
   #  LET p_dbs = NULL                                                                                                               
   #ELSE                                                                                                                             
     LET g_plant_new = p_plant                                                                                                      
   #  CALL s_getdbs()                                                                                                                
   #  LET p_dbs = g_dbs_new                                                                                                          
   #END IF                                                                                                                           
   ##NO.FUN-980025 GP5.2 add end
   LET ms_default1 = ps_default1
   LET ms_sys = p_sys
   LET ms_sys = UPSHIFT(ms_sys) #TQC-670008 add
   LET ms_kind = p_kind
   #LET mc_dbs   = p_dbs
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_smy2" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_smy2")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
   LET ms_ret1 = ''
 
   # 不復選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 在復選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("smyslip", "red")
   END IF
 
   CALL smy2_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #復選資料只能回傳一個欄位的組合字串.
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
FUNCTION smy2_qry_sel()
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
         LET ms_cons_where = '1=1'
     
         CALL smy2_qry_prep_result_set() 
         # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等于所有資料,則要隱藏'上下頁'的按鈕.
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
     
      CALL smy2_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
     
      # 2004/02/25 by saki : 若最后一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL smy2_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL smy2_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 准備查詢畫面的資料集.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION smy2_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   #如果不需要復選資料,則不要設定此欄位(per亦需將check移除). 	#No.FUN-680131 VARCHAR(1)
            smyslip  LIKE smy_file.smyslip,
            smydesc  LIKE smy_file.smydesc,
            smyauno  LIKE smy_file.smyauno,
            smydmy5  LIKE smy_file.smydmy5
   END RECORD
   DEFINE   g_gen03  LIKE gen_file.gen03  ,       #部門代號
	    l_n      LIKE type_file.num5   	#No.FUN-680131 SMALLINT
 
 
 
   LET ls_sql= "SELECT 'N',smyslip,smydesc,smyauno,smydmy5",
               #"  FROM ",mc_dbs CLIPPED,"smy_file",
               "  FROM ",cl_get_target_table(g_plant_new,'smy_file'), #FUN-A50102
               " WHERE ",ms_cons_where CLIPPED
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND smyacti='Y'"
      IF ms_sys != '*' THEN	#若指定系統別
         #LET ls_where = ls_where CLIPPED," AND smysys ='",ms_sys,"'"         #TQC-670008 remark
         LET ls_where = ls_where CLIPPED," AND upper(smysys) ='",ms_sys,"'"   #TQC-670008
      END IF
 
      IF ms_kind != '*' THEN	#若指定單據性質
         LET ls_where = ls_where CLIPPED," AND smykind ='",ms_kind,"'" 
      END IF
   END IF
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_smy2', 'smy_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY smyslip"
 
   DISPLAY "ls_sql=",ls_sql
 	 CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql        #FUN-920032
         CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102
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
      #------------------------------------------------------ 970909 Roger
	#-------------------------------- g_user 是否有該單別的使用權限(970717)
	#NO:6842
     #----------------MOD-660032 modify
       #LET g_sql = "SELECT gen03 FROM ",mc_dbs CLIPPED,".gen_file",
       #            " where gen01='",g_user,"'"   #抓此人所屬部門
       #LET g_sql = "SELECT zx03 FROM ",mc_dbs CLIPPED,".dbo.zx_file",    #TQC-950048 MARK                                              
        #LET g_sql = "SELECT zx03 FROM ",s_dbstring(mc_dbs),"zx_file", #TQC-950048 ADD
        LET g_sql = "SELECT zx03 FROM ",cl_get_target_table(g_plant_new,'zx_file'), #FUN-A50102    
                    " where zx01='",g_user,"'"   #抓此人所屬部門
     #----------------MOD-660032 modify
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        PREPARE slip2 FROM g_sql
        DECLARE slip_curs2 SCROLL CURSOR FOR slip2
        OPEN slip_curs2 
        FETCH slip_curs2 INTO g_gen03 
        IF SQLCA.SQLCODE THEN
            LET g_gen03=NULL
        END IF
        #權限先check user再check部門
        #LET g_sql = " SELECT COUNT(*) FROM ",mc_dbs CLIPPED,".smu_file",
        LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smu_file'), #FUN-A50102    
                   #"  WHERE smu01='",lr_qry.smyslip,"' AND smu03='",ms_sys,"'"         #TQC-670008 remark
                    "  WHERE smu01='",lr_qry.smyslip,"' AND upper(smu03)='",ms_sys,"'"  #TQC-670008
                                                                     #CHECK USER
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        PREPARE slip3 FROM g_sql
        DECLARE slip_curs3 SCROLL CURSOR FOR slip3
        OPEN slip_curs3 
        FETCH slip_curs3 INTO l_n   
        IF l_n>0 THEN                                                                 #USER權限存有資料,并g_user判斷是否存在
           #LET g_sql = "SELECT COUNT(*) FROM ",mc_dbs CLIPPED,".smu_file",
           LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smu_file'), #FUN-A50102 
                       " WHERE smu01='",lr_qry.smyslip,"' AND smu02='",g_user,
                      #" ' AND smu03='",ms_sys,"'"         #TQC-670008 remark
                       " ' AND upper(smu03)='",ms_sys,"'"  #TQC=670008
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
           PREPARE slip4 FROM g_sql
           DECLARE slip_curs4 SCROLL CURSOR FOR slip4
           OPEN slip_curs4 
           FETCH slip_curs4 INTO l_n   
           IF l_n=0 THEN
               IF g_gen03 IS NULL THEN                               #g_user沒有部門           
                   CONTINUE FOREACH
               ELSE
                   #LET g_sql = " SELECT COUNT(*) FROM ",mc_dbs CLIPPED,
                   #            ".smv_file ",
                   LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smv_file'), #FUN-A50102 
                               "  WHERE smv01='",lr_qry.smyslip,"'",
                               "    AND smv02='",g_gen03,"'",
                              #"    AND smv03='",ms_sys,"'"         #TQC-670008 remark
                               "    AND upper(smv03)='",ms_sys,"'"  #TQC-670008
                                                #CHECK g_user部門是否存在
 	               CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                   PREPARE slip5 FROM g_sql
                   DECLARE slip_curs5 SCROLL CURSOR FOR slip5
                   OPEN slip_curs5 
                   FETCH slip_curs5 INTO l_n   
                   IF l_n=0 THEN
                        CONTINUE FOREACH 
                   END IF
               END IF
           END IF
        ELSE
           #LET g_sql="SELECT COUNT(*) FROM ",mc_dbs CLIPPED,".smv_file",
           LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smv_file'), #FUN-A50102
                     " WHERE smv01='",lr_qry.smyslip,"'",
                    #"   AND smv03='",ms_sys,"'"      #CHECK Dept         #TQC-670008 remark
                     "   AND upper(smv03)='",ms_sys,"'"      #CHECK Dept  #TQC-670008
 	       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
           PREPARE slip6 FROM g_sql
           DECLARE slip_curs6 SCROLL CURSOR FOR slip6
           OPEN slip_curs6 
           FETCH slip_curs6 INTO l_n   
            IF l_n>0 THEN
               IF g_gen03 IS NULL THEN                                #g_user沒有部門              
                    CONTINUE FOREACH 
               ELSE
                   #LET g_sql="SELECT COUNT(*) FROM ",mc_dbs CLIPPED,".smv_file",
                   LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smv_file'), #FUN-A50102
                             " WHERE smv01='",lr_qry.smyslip,"'",
                             "   AND smv02='",g_gen03,"'",
                            #"   AND smv03='",ms_sys,"'"           #TQC-670008
                             "   AND upper(smv03)='",ms_sys,"'"    #TQC-670008
                                              #CHECK g_user部門是否存在
 	               CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                   PREPARE slip7 FROM g_sql
                   DECLARE slip_curs7 SCROLL CURSOR FOR slip7
                   OPEN slip_curs7 
                   FETCH slip_curs7 INTO l_n   
                   IF l_n=0 THEN
                         CONTINUE FOREACH 
                   END IF
               END IF             
            END IF
        END IF     
        #NO:6842
        #----------------------------------------------------------------
 
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
FUNCTION smy2_qry_set_display_data(pi_start_index, pi_end_index)
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
# Description  	: 采用INPUT ARRAY的方式來顯現查詢過后的資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變后的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION smy2_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_smy.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_smy.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_smy.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL smy2_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_smy.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL smy2_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL smy2_qry_refresh()
     
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
            CALL smy2_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL smy2_qry_accept(pi_start_index+ARR_CURR()-1)
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
# Description  	: 重設查詢資料關于'check'欄位的值.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION smy2_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Description  	: 采用DISPLAY ARRAY的方式來顯現查詢過后的資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變后的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION smy2_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
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
      
         EXIT DISPLAY
      ON ACTION accept
         CALL smy2_qry_accept(pi_start_index+ARR_CURR()-1)
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
FUNCTION smy2_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇并確認資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION smy2_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	#No.FUN-680131 INTEGER
 
 
   # 2004/06/03 by saki : GDC 1.3版本后，若沒有資料，ARR_CURR()會是0
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
      # 2003/09/16 by Hiko : 復選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
display "LET QUERY ms_ret1=",ms_ret1
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].smyslip CLIPPED
display "LET INSERT ms_ret1=",ms_ret1
   END IF
END FUNCTION
