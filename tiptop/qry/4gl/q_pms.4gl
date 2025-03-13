# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#{
# Program name  : q_pms.sql
# Program ver.  : 7.0
# Description   : 常用特殊說明資料查詢
#               : 本作業不同於一般的查詢,請特別小心使用
#               : 程式段與特殊qry標準規格有差異
# Date & Author : 2004/06/25 by saki
# Memo          : 
# Modify        :
# Modify........: 04/07/20 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify........: 05/04/04 By wujie Bugno.MOD-530882 程序中變量名稱寫錯了
#                 ms_refault[1-4]無此變量,ms_refault[1-4]應改為ms_default[1-4]
# Modify.........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify.........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
#}
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-980025 09/10/09 By dxfwo hardcode的部分修改
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         pms01    LIKE pms_file.pms01,
         pms02    LIKE pms_file.pms02
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         pms01        LIKE pms_file.pms01,
         pms02        LIKE pms_file.pms02
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      LIKE pmo_file.pmo01    #單號
DEFINE   ms_default2      LIKE pmo_file.pmo02    #資料性質
DEFINE   ms_default3      LIKE pmo_file.pmo03    #項次
DEFINE   ms_default4      LIKE pmo_file.pmo04    #位置
DEFINE   ms_ret1          STRING
 
FUNCTION q_pms(pi_multi_sel,pi_need_cons,ps_default1,ps_default2,ps_default3,ps_default4)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    LIKE pmo_file.pmo01,   #單號
            ps_default2    LIKE pmo_file.pmo02,   #資料性質
            ps_default3    LIKE pmo_file.pmo03,   #項次
            ps_default4    LIKE pmo_file.pmo04    #位置
 
 
   WHENEVER ERROR CONTINUE
 
   LET ms_default1 = ps_default1 
   LET ms_default2 = ps_default2 
   LET ms_default3 = ps_default3 
   LET ms_default4 = ps_default4 
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_pms" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_pms")
 
   LET mi_multi_sel = FALSE
   LET mi_need_cons = pi_need_cons
 
   CALL pms_qry_sel()
 
   CLOSE WINDOW w_qry
 
   RETURN ms_ret1 
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2004/06/25 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION pms_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
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
    
      LET ms_ret1 = "Y"
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON pms01,pms02
                                  FROM s_pms[1].pms01,s_pms[1].pms02
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL pms_qry_prep_result_set() 
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
     
      CALL pms_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
     
      # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      CALL pms_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2004/06/25 by saki
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION pms_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            pms01      LIKE pms_file.pms01,
            pms02      LIKE pms_file.pms02
   END RECORD
 
 
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_pms', 'pms_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N',pms01,pms02", 
                " FROM pms_file",
                " WHERE ",ms_cons_where CLIPPED
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY pms01"
 
  ##NO.FUN-980025 GP5.2 add--begin						
   IF (NOT mi_multi_sel ) THEN						
        CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql						
   END IF						
  ##NO.FUN-980025 GP5.2 add--end
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
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
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2004/06/25 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION pms_qry_set_display_data(pi_start_index, pi_end_index)
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
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2004/06/25 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION pms_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_seq_tmp       LIKE type_file.num5,       #No.FUN-680131 SMALLINT
            li_seq           LIKE type_file.num5,       #No.FUN-680131 SMALLINT
            li_i             LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   ls_sql           STRING
   DEFINE   ls_pmt03         LIKE pmt_file.pmt03,
            ls_pmt04         LIKE pmt_file.pmt04
 
 
   SELECT max(pmo05) INTO li_seq_tmp FROM pmo_file
    WHERE pmo01 = ms_default1 AND pmo02 = ms_default2
      AND pmo03 = ms_default3 AND pmo04 = ms_default4
   IF li_seq_tmp IS NULL THEN LET li_seq_tmp = 0 END IF
   LET li_seq = li_seq_tmp
 
   LET ls_sql = "SELECT pmt03, pmt04 ",
                " FROM pmt_file ",
                " WHERE pmt01 = ? ",
                " ORDER BY pmt03 "
   PREPARE q_pmt_prepare FROM ls_sql
   DECLARE pmt_curs CURSOR FOR q_pmt_prepare
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY ma_qry_tmp TO s_pms.* ATTRIBUTES(UNBUFFERED)
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
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            IF ma_qry_tmp[ARR_CURR()].check = "N" THEN
               LET ma_qry_tmp[ARR_CURR()].check = "Y"
               FOREACH pmt_curs USING ma_qry_tmp[ARR_CURR()].pms01 INTO ls_pmt03,ls_pmt04
                  IF SQLCA.sqlcode THEN      
                     LET ms_ret1 = 'N'
                     CALL cl_err('foreach error',SQLCA.sqlcode,0)
                     EXIT FOREACH 
                  END IF
                  LET li_seq = li_seq + 1
                  INSERT INTO pmo_file(pmo01,pmo02,pmo03,
                                        pmo04,pmo05,pmo06,pmoplant,pmolegal) #No.MOD-470041  #FUN-980012 add pmoplant,pmolegal
                                VALUES(ms_default1,ms_default2,ms_default3,
                                       ms_default4,li_seq,ls_pmt04,g_plant,g_legal) #FUN-980012 add g_plant,g_legal
                  IF SQLCA.sqlcode THEN
                     LET ms_ret1 = 'N'
                     EXIT FOREACH
                  END IF
               END FOREACH 
            ELSE
               LET ma_qry_tmp[ARR_CURR()].check = "N"
               LET li_seq_tmp = li_seq_tmp + 1
               FOR li_i = li_seq_tmp  TO li_seq
                   DELETE FROM pmo_file 
                    WHERE pmo01 = ms_default1
                      AND pmo02 = ms_default2
                      AND pmo03 = ms_default3
                      AND pmo05 = li_i
                      AND pmo04 = ms_default4
                   IF SQLCA.sqlcode THEN
                      LET ms_ret1 = 'N'
                   END IF
               END FOR
            END IF
         ELSE                        #CHI-9C0048
            LET ms_ret1 = 'N'        #CHI-9C0048
         END IF                      #CHI-9C0048            
         LET li_continue = TRUE
      
      ON ACTION select
         LET ma_qry_tmp[ARR_CURR()].check = "Y"
         FOREACH pmt_curs USING ma_qry_tmp[ARR_CURR()].pms01 INTO ls_pmt03,ls_pmt04
            IF SQLCA.sqlcode THEN      
               LET ms_ret1 = 'N'
               CALL cl_err('foreach error',SQLCA.sqlcode,0)
               EXIT FOREACH 
            END IF
            LET li_seq = li_seq + 1
 #NO.MOD-530882--begin
            INSERT INTO pmo_file(pmo01,pmo02,pmo03,
                                  pmo04,pmo05,pmo06,pmoplant,pmolegal) #No.MOD-470041 #FUN-980012 add pmoplant,pmolegal
                          VALUES(ms_default1,ms_default2,ms_default3,
                                 ms_default4,li_seq,ls_pmt04,g_plant,g_legal) #FUN-980012 add g_plant,g_legal
            IF SQLCA.sqlcode THEN
               LET ms_ret1 = 'N'
               EXIT FOREACH
            END IF
         END FOREACH 
         LET li_continue = TRUE
 
      ON ACTION cancel_select
         LET INT_FLAG = 0 #No.CHI-690081
         LET ma_qry_tmp[ARR_CURR()].check = "N"
         LET li_seq_tmp = li_seq_tmp + 1
         FOR li_i = li_seq_tmp  TO li_seq
             DELETE FROM pmo_file 
              WHERE pmo01 = ms_default1
                AND pmo02 = ms_default2
                AND pmo03 = ms_default3
                AND pmo05 = li_i
                AND pmo04 = ms_default4
             IF SQLCA.sqlcode THEN
                LET ms_ret1 = 'N'
             END IF
         END FOR
         LET li_continue = TRUE
 
 #NO.MOD-530882--end              
      ON ACTION exit
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
   CALL cl_set_act_visible("accept,cancel",TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
