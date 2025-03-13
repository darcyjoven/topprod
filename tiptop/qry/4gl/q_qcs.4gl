# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Program name  : q_qcs.4ql
# Date & Author : FUN-880074 2008/10/14 By jan 
# Modify........: No.MOD-950180 By chenyu qcs00 = 'A' OR 'B'時判斷有問題
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-980025 09/10/09 By dxfwo hardcode的部分修改
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:MOD-B10226 11/01/26 By sabrina WHERE條件多串項次 
# Modify.........: No:MOD-BB0125 11/11/10 by destiny 过滤掉已过帐,未审核,不检验的单号
# Modify.........: No:MOD-C20004 12/02/01 By ck2yuan 匯出excel功能修正
# Modify.........: No:FUN-C30163 12/12/27 By pauline 增加顯示待驗量,並且待驗量為0時不顯示
# Modify.........: No:MOD-D10092 13/01/31 By Elise 調撥單的過帳碼為imm03非immpost
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	
         ina01       LIKE ina_file.ina01,
         ina03       LIKE ina_file.ina03,
         inb03       LIKE inb_file.inb03,
         inb16       LIKE inb_file.inb16,
         qcs22       LIKE qcs_file.qcs22     #FUN-C30163 add
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         ina01       LIKE ina_file.ina01,
         ina03       LIKE ina_file.ina03,
         inb03       LIKE inb_file.inb03,
         inb16       LIKE inb_file.inb16,
         qcs22       LIKE qcs_file.qcs22     #FUN-C30163 add
END RECORD
 
DEFINE   m_qcs00          LIKE qcs_file.qcs00
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING
DEFINE   ms_default2      STRING
DEFINE   ms_ret1          STRING,
         ms_ret2          STRING,
         ms_ret3          STRING,
         ms_ret4          STRING
 
FUNCTION q_qcs(pi_multi_sel,pi_need_cons,ps_default1,ps_default2,p_qcs00)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	
            pi_need_cons   LIKE type_file.num5,  
            ps_default1    STRING,
            ps_default2    STRING
   DEFINE   p_qcs00        LIKE qcs_file.qcs00
 
 
   WHENEVER ERROR CONTINUE
 
   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2 
   LET m_qcs00 = p_qcs00
   
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_qcs" ATTRIBUTE(STYLE="create_qry")  
 
   CALL cl_ui_locale("q_qcs")
     
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
         CALL cl_set_comp_font_color("ina01,inb03", "red")
   END IF
 
   CALL qcs_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1,ms_ret2
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2004/03/16 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION qcs_qry_sel()
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
   LET ms_cons_where = " 1=1"
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
           CASE
             WHEN m_qcs00 = 'A' OR m_qcs00 = 'B'
                  CONSTRUCT ms_cons_where ON ina01,ina03,inb03,inb16
                                         FROM s_qcs[1].ina01,s_qcs[1].ina03,s_qcs[1].inb03,s_qcs[1].inb16 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            END CONSTRUCT
                                      
             WHEN m_qcs00 = 'C' OR m_qcs00 = 'D'
                  CONSTRUCT ms_cons_where ON imm01,imm02,imn02,imn10
                                        FROM s_qcs[1].ina01,s_qcs[1].ina03,s_qcs[1].inb03,s_qcs[1].inb16  
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            END CONSTRUCT
                                   
             WHEN m_qcs00 = 'E'
                  CONSTRUCT ms_cons_where ON imo01,imo02,imp02,imp04
                                        FROM s_qcs[1].ina01,s_qcs[1].ina03,s_qcs[1].inb03,s_qcs[1].inb16 
 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            END CONSTRUCT
                                   
             WHEN m_qcs00 = 'F'
                  CONSTRUCT ms_cons_where ON imr01,imr02,imq02,imq07
                                        FROM s_qcs[1].ina01,s_qcs[1].ina03,s_qcs[1].inb03,s_qcs[1].inb16  
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            END CONSTRUCT
                                   
             WHEN m_qcs00 = 'G'
                  CONSTRUCT ms_cons_where ON qsa01,qsa11,qsa06
                                     FROM s_qcs[1].ina01,s_qcs[1].ina03,s_qcs[1].inb16 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            END CONSTRUCT
                                   
             WHEN m_qcs00 = 'H'
                  CONSTRUCT ms_cons_where ON oha01,oha02,ohb03,ohb12
                                        FROM s_qcs[1].ina01,s_qcs[1].ina03,s_qcs[1].inb03,s_qcs[1].inb16 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            END CONSTRUCT
           OTHERWISE
             EXIT CASE
           END CASE                                                                                                                                                                                
#               ON IDLE g_idle_seconds
#                  CALL cl_on_idle()
#                  CONTINUE CONSTRUCT
#            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL qcs_qry_prep_result_set() 
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
     
      CALL qcs_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
     
      # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL qcs_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL qcs_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2004/03/16 by saki
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION qcs_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
              ina01       LIKE ina_file.ina01,
              ina03       LIKE ina_file.ina03,
              inb03       LIKE inb_file.inb03,
              inb16       LIKE inb_file.inb16,
              qcs22       LIKE qcs_file.qcs22    #FUN-C30163 add
   END RECORD
   DEFINE   l_n        LIKE type_file.num5
 
   
   CASE
      #No.MOD-950180 modify --begin
      #WHEN m_qcs00 = 'A' OR m_qcs00 = 'B'
      #  LET ls_sql = "SELECT 'N',ina01,ina03,inb03,inb16",
      #               "  FROM ina_file,inb_file,OUTER ima_file ",
      #               " WHERE ina01 = inb01",
      #               "   AND ina00 = '1'",
      #               "   AND inb04 = ima_file.ima01",
      #               "   AND ",ms_cons_where
       WHEN m_qcs00 = 'A' 
 
         #Begin:FUN-980030
         LET l_filter_cond = cl_get_extra_cond_for_qry('q_qcs', 'ina_file')
         IF NOT cl_null(l_filter_cond) THEN
            LET ms_cons_where = ms_cons_where,l_filter_cond
         END IF
         #End:FUN-980030
         LET ls_sql = "SELECT 'N',ina01,ina03,inb03,inb09,''",   #FUN-C30163 add ''
                      "  FROM ina_file,inb_file,OUTER ima_file ",
                      " WHERE ina01 = inb01",
                      "   AND (ina00 = '1' OR ina00 = '2')",
                      "   AND inb04 = ima_file.ima01",
                      "   AND inaconf='Y' AND inapost='N' AND inb10='Y' ",  #MOD-BB0125
                      "   AND ",ms_cons_where
       WHEN m_qcs00 = 'B' 
         LET ls_sql = "SELECT 'N',ina01,ina03,inb03,inb09,''",    #FUN-C30163 add ''
                      "  FROM ina_file,inb_file,OUTER ima_file ",
                      " WHERE ina01 = inb01",
                      "   AND (ina00 = '3' OR ina00 = '4')",
                      "   AND inb04 = ima_file.ima01",
                      "   AND inaconf='Y' AND inapost='N' AND inb10='Y' ",  #MOD-BB0125
                      "   AND ",ms_cons_where
      #No.MOD-950180 modify --end
                   
       WHEN m_qcs00 = 'C'   
         LET ls_sql = "SELECT 'N',imm01,imm02,imn02,imn10,''",    #FUN-C30163 add ''
                      "  FROM imn_file,imm_file,OUTER ima_file ",
                      " WHERE imn01 = imm01",
                      "   AND imm10 = '1'",
                      "   AND imn03 = ima_file.ima01",
                     #"   AND immconf='Y' AND immpost='N' AND imn29='Y' ", #MOD-BB0125 #MOD-D10092 mark
                      "   AND immconf='Y' AND imm03='N' AND imn29='Y' ",   #MOD-D10092 add
                      "   AND ",ms_cons_where
                      
       WHEN m_qcs00 = 'D'   
         LET ls_sql = "SELECT 'N',imm01,imm02,imn02,imn10i,''",    #FUN-C30163 add ''
                      "  FROM imn_file,imm_file,OUTER ima_file ",
                      " WHERE imn01 = imm01",
                      "   AND imm10 = '3'",
                      "   AND imn03 = ima_file.ima01",
                     #"   AND immconf='Y' AND immpost='N' AND imn29='Y' ",  #MOD-BB0125 #MOD-D10092 mark
                      "   AND immconf='Y' AND imm03='N' AND imn29='Y' ",    #MOD-D10092 add
                      "   AND ",ms_cons_where
                      
       WHEN m_qcs00 = 'E'   
         LET ls_sql = "SELECT 'N',imo01,imo02,imp02,imp04,''",     #FUN-C30163 add ''
                      "  FROM imo_file,imp_file,OUTER ima_file,OUTER img_file ",
                      " WHERE imo01 = imp01",
                      "   AND imp03 = ima_file.ima01",
                      "   AND imp03 = img_file.img01",
                      "   AND imp11 = img_file.img02",
                      "   AND imp12 = img_file.img03",
                      "   AND imp13 = img_file.img04",
                      "   AND imoconf = 'Y'",
                      "   AND imopost = 'N'",
                      "   AND imo07 = 'N'",
                      "   AND imp15 = 'Y'",
                      "   AND ",ms_cons_where  
         
        
         WHEN m_qcs00 = 'F'   
         LET ls_sql = "SELECT 'N',imr01,imr02,imq02,imq07,''",     #FUN-C30163 add ''
                      "  FROM imr_file,imq_file,imp_file ",
                      " WHERE imr01 = imq01",
                      "   AND imr00 = '1'",
                      "   AND imq03 = imp01",
                      "   AND imrconf='Y' AND imrpost='N' ", #MOD-BB0125
                      "   AND imq04 = imp02",
                      "   AND ",ms_cons_where 
                      
         WHEN m_qcs00 = 'G'   
         LET ls_sql = "SELECT 'N',qsa01,qsa11,'',qsa06,''",   #FUN-C30163 add ''
                      "  FROM qsa_file ",
                      " WHERE qsaacti = 'Y'",
                      "   AND qsa08 = 'Y' ",      #FUN-C30163 add
                      "   AND ",ms_cons_where             
                      
         WHEN m_qcs00 = 'H'   
         LET ls_sql = "SELECT 'N',oha01,oha02,ohb03,ohb12,''",    #FUN-C30163 add ''
                      "  FROM oha_file,ohb_file,OUTER ima_file ",
                      " WHERE oha01 = ohb01",
                      "   AND (oha41 = 'N' OR oha41 IS NULL OR oha41 = ' ')",
                      "   AND ohb04 = ima_file.ima01",
                      "   AND ohaconf='Y' AND ohapost='N' AND ohb61='Y' ", #MOD-BB0125
                      "   AND ",ms_cons_where  
                                 
       
       OTHERWISE
           EXIT CASE
   END CASE 
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

      CALL ogb6_get_qcs22(m_qcs00,lr_qry.ina01,lr_qry.inb03,'') RETURNING lr_qry.qcs22  #FUN-C30163 add

     #FUN-C30163 add START
      IF cl_null(lr_qry.qcs22) THEN
         LET lr_qry.qcs22 = 0
      END IF

      IF lr_qry.qcs22 = 0 OR lr_qry.qcs22 < 0 THEN
         CONTINUE FOREACH
      END IF
     #FUN-C30163 add END
 
      LET ma_qry[li_i].* = lr_qry.*
      IF m_qcs00 = 'G' THEN                    #MOD-B10226 addd
         SELECT COUNT(*) INTO l_n FROM qcs_file
          WHERE qcs01 = ma_qry[li_i].ina01
            AND qcs14 = 'Y'
     #MOD-B10226---add---start---
      ELSE
         SELECT COUNT(*) INTO l_n FROM qcs_file
          WHERE qcs01 = ma_qry[li_i].ina01
            AND qcs02 = ma_qry[li_i].inb03      
            AND qcs14 = 'Y'
      END IF 
     #MOD-B10226---add---end---
      IF l_n > 0 THEN
         INITIALIZE ma_qry[li_i].* TO NULL
      ELSE
        LET li_i = li_i + 1
      END IF
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2004/03/16 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION qcs_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : 2004/03/16 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION qcs_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
  #---MOD-C20004 str add-----
   DEFINE w ui.Window
   DEFINE f ui.Form
   DEFINE page om.DomNode
  #---MOD-C20004 end add----- 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_gat.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_qcs.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_qcs.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL qcs_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_qcs.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL qcs_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL qcs_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_qcs.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL qcs_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL qcs_qry_accept(pi_start_index+ARR_CURR()-1)
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
        #---MOD-C20004 str add-----
         LET w = ui.Window.getCurrent()
         LET f = w.getForm()
         LET page = f.FindNode("Table","s_qcs")
         CALL cl_export_to_excel(page,base.TypeInfo.create(ma_qry),'','')
        #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
        #---MOD-C20004 end add-----
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
# Date & Author : 2004/03/16 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION qcs_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : 2004/03/16 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION qcs_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
  #---MOD-C20004 str add-----
   DEFINE w ui.Window
   DEFINE f ui.Form
   DEFINE page om.DomNode
  #---MOD-C20004 end add----- 
 
   DISPLAY ARRAY ma_qry_tmp TO s_qcs.*
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
         CALL qcs_qry_accept(pi_start_index+ARR_CURR()-1)
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
        #---MOD-C20004 str add-----
         LET w = ui.Window.getCurrent()
         LET f = w.getForm()
         LET page = f.FindNode("Table","s_qcs")
         CALL cl_export_to_excel(page,base.TypeInfo.create(ma_qry),'','')
        #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
        #---MOD-C20004 end add-----
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
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2004/03/16 by saki
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION qcs_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2004/03/16 by saki
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION qcs_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].ina01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].ina01 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].ina01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].inb03 CLIPPED
   END IF
END FUNCTION
#No.FUN-880074
