# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmt512.4gl
# Descriptions...: 集團採購發出還原作業
# Date & Author..: No.FUN-630040 06/03/22 By Nicola
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-6A0162 06/11/07 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-710030 07/02/05 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-710033 07/03/29 By Mandy 多單位畫面標準寫法調整
# Modify.........: No.TQC-760091 07/06/15 By rainy 勾多筆還原錯誤 -284
# Modify.........: No.FUN-7B0018 08/02/29 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-950096 09/05/25 By Nicola pny07增加3.自行採購
# Modify.........: No.MOD-950183 09/06/05 By Dido 多角採購單拋轉還原失敗
# Modify.........: No.FUN-960011 09/06/26 By shiwuying 採購單刪掉處理
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pny   DYNAMIC ARRAY OF RECORD
                  sel       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
                  pnx03     LIKE pnx_file.pnx03,
                  pnx04     LIKE pnx_file.pnx04,
                  azp02     LIKE azp_file.azp02,
                  pnx05     LIKE pnx_file.pnx05,
                  pnx06     LIKE pnx_file.pnx06,
                  pnx07     LIKE pnx_file.pnx07,
                  ima02     LIKE ima_file.ima02,
                  pnx09     LIKE pnx_file.pnx09,
                  pnx16     LIKE pnx_file.pnx16,
                  pnx18     LIKE pnx_file.pnx18,
                  pny07     LIKE pny_file.pny07,
                  pny08     LIKE pny_file.pny08,
                  pny09     LIKE pny_file.pny09,
                  pny16     LIKE pny_file.pny16,
                  pny13     LIKE pny_file.pny13,
                  pny19     LIKE pny_file.pny19,
                  pny20     LIKE pny_file.pny20,
                  pny24     LIKE pny_file.pny24,
                  pny21     LIKE pny_file.pny21,
                  pny22     LIKE pny_file.pny22
               END RECORD,
       g_pny_t RECORD
                  sel       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
                  pnx03     LIKE pnx_file.pnx03,
                  pnx04     LIKE pnx_file.pnx04,
                  azp02     LIKE azp_file.azp02,
                  pnx05     LIKE pnx_file.pnx05,
                  pnx06     LIKE pnx_file.pnx06,
                  pnx07     LIKE pnx_file.pnx07,
                  ima02     LIKE ima_file.ima02,
                  pnx09     LIKE pnx_file.pnx09,
                  pnx16     LIKE pnx_file.pnx16,
                  pnx18     LIKE pnx_file.pnx18,
                  pny07     LIKE pny_file.pny07,
                  pny08     LIKE pny_file.pny08,
                  pny09     LIKE pny_file.pny09,
                  pny16     LIKE pny_file.pny16,
                  pny13     LIKE pny_file.pny13,
                  pny19     LIKE pny_file.pny19,
                  pny20     LIKE pny_file.pny20,
                  pny24     LIKE pny_file.pny24,
                  pny21     LIKE pny_file.pny21,
                  pny22     LIKE pny_file.pny22
               END RECORD,
       g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,         #No.FUN-680136 SMALLINT
       l_ac           LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_pny01        LIKE pny_file.pny01
DEFINE g_pny02        LIKE pny_file.pny02
DEFINE g_pny03_1      LIKE pny_file.pny03
DEFINE g_pny03_2      LIKE pny_file.pny03
DEFINE g_geu02        LIKE geu_file.geu02
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_i            LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(72)
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("apm")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW t512_w WITH FORM "apm/42f/apmt512"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL t512_def_form()   #TQC-710033 add
 
   CALL t512_menu()
 
   CLOSE WINDOW t512_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t512_menu()
 
   WHILE TRUE
      CALL t512_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t512_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t512_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "unrelease"
            IF cl_chk_act_auth() THEN
               CALL t512_unrelease()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No.FUN-6A0162-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
                 IF g_pny01 IS NOT NULL THEN            
                    LET g_doc.column1 = "pny01"               
                    LET g_doc.column2 = "pny02" 
                    LET g_doc.column3 = "pny03"
                    LET g_doc.column4 = "pny03"  
                    LET g_doc.value1 = g_pny01            
                    LET g_doc.value2 = g_pny02
                    LET g_doc.value3 = g_pny03_1
                    LET g_doc.value4 = g_pny03_2
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0162-------add--------end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t512_q()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
 
   CLEAR FORM
   CALL g_pny.clear()
 
   CALL cl_set_head_visible("group01","YES")           #No.FUN-6B0032
   INPUT g_pny01,g_pny02,g_pny03_1,g_pny03_2 WITHOUT DEFAULTS 
         FROM pny01,pny02,pny03_1,pny03_2 
 
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD pny01
         SELECT geu02 INTO g_geu02 FROM geu_file
          WHERE geu01 = g_pny01
            AND geu00 = "4"
         IF STATUS THEN
#           CALL cl_err(g_pny01,"anm-027",0)   #No.FUN-660129
            CALL cl_err3("sel","geu_file",g_pny01,"","anm-027","","",1)  #No.FUN-660129
            NEXT FIELD pny01
         END IF
         DISPLAY g_geu02 TO geu02
 
      ON CHANGE pny02
         IF g_pny02 = "1" THEN
            CALL cl_set_comp_entry("pny03_1",TRUE)
            CALL cl_set_comp_entry("pny03_2",FALSE)
            CALL cl_set_comp_visible("pnx05",FALSE)
         ELSE
            CALL cl_set_comp_entry("pny03_1",FALSE)
            CALL cl_set_comp_entry("pny03_2",TRUE)
            CALL cl_set_comp_visible("pnx05",TRUE)
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pny01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_geu"
               LET g_qryparam.arg1 = "4"
               LET g_qryparam.default1 = g_pny01
               CALL cl_create_qry() RETURNING g_pny01
               DISPLAY g_pny01 TO pny01
               NEXT FIELD pny01
            OTHERWISE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
      
      ON ACTION help
         CALL cl_show_help()
      
      ON ACTION controlg
         CALL cl_cmdask()
      
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CONSTRUCT g_wc2 ON pnx04,pnx05,pnx07,pnx09,pny07,pny08,pny09,pny20,pny24
                 FROM s_pny[1].pnx04,s_pny[1].pnx05,s_pny[1].pnx07,
                      s_pny[1].pnx09,s_pny[1].pny07,s_pny[1].pny08,
                      s_pny[1].pny09,s_pny[1].pny20,s_pny[1].pny24
 
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pnx04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azp"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnx04
                 NEXT FIELD pnx04
            WHEN INFIELD(pnx07)
#FUN-AA0059---------mod------------str-----------------            
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state = "c"
#                 LET g_qryparam.form ="q_ima"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO pnx07
                 NEXT FIELD pnx07
            WHEN INFIELD(pny08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azp"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pny08
                 NEXT FIELD pny08
            WHEN INFIELD(pny09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azp"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pny09
                 NEXT FIELD pny09
            WHEN INFIELD(pny20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_poz"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pny20
                 NEXT FIELD pny20
            WHEN INFIELD(pny24)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pny24
                 NEXT FIELD pny24
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL t512_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t512_b()
   DEFINE l_allow_insert  LIKE type_file.num5,                #可新增否 #No.FUN-680136 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否 #No.FUN-680136 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_pny[l_ac].pnx03) THEN
      RETURN
   END IF
 
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   INPUT ARRAY g_pny WITHOUT DEFAULTS FROM s_pny.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      AFTER ROW
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
 
      ON ACTION select_all
         FOR g_i = 1 TO g_rec_b
            LET g_pny[l_ac].sel = "Y"
         END FOR
 
      ON ACTION cancel_all
         FOR g_i = 1 TO g_rec_b
            LET g_pny[l_ac].sel = "N"
         END FOR
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("group01","AUTO")       #No.FUN-6B0032
   END INPUT
 
END FUNCTION
 
FUNCTION t512_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   IF g_pny02 = "1" THEN
      LET g_sql = "SELECT 'N',pnx03,pnx04,'',pnx05,pnx06,pnx07,'',",
                  "       pnx09,pnx16,pnx18,pny07,pny08,pny09,pny16,",
                  "       pny13,pny19,pny20,pny24,pny21,pny22",
                  "  FROM pnx_file,pny_file",
                  " WHERE ",p_wc2 CLIPPED,
                  "   AND pnx01 = '",g_pny01,"'",
                  "   AND pnx02 = '",g_pny02,"'",
                  "   AND pnx03 = '",g_pny03_1,"'",
                  "   AND pnx01 = pny01",
                  "   AND pnx02 = pny02",
                  "   AND pnx03 = pny03",
                  "   AND pnx04 = pny04",
                  "   AND pnx05 = pny05",
                  "   AND pnx06 = pny06",
                  "   AND pny21 IS NOT NULL",
                  " ORDER BY pnx03,pnx04"
   ELSE
      LET g_sql = "SELECT 'N',pnx03,pnx04,'',pnx05,pnx06,pnx07,'',",
                  "       pnx09,pnx16,pnx18,pny07,pny08,pny09,pny16,",
                  "       pny13,pny19,pny20,pny24,pny21,pny22",
                  "  FROM pnx_file,pny_file",
                  " WHERE ",p_wc2 CLIPPED,
                  "   AND pnx01 = '",g_pny01,"'",
                  "   AND pnx02 = '",g_pny02,"'",
                  "   AND pnx03 = '",g_pny03_2,"'",
                  "   AND pnx01 = pny01",
                  "   AND pnx02 = pny02",
                  "   AND pnx03 = pny03",
                  "   AND pnx04 = pny04",
                  "   AND pnx05 = pny05",
                  "   AND pnx06 = pny06",
                  "   AND pny21 IS NOT NULL",
                  " ORDER BY pnx03,pnx04"
   END IF
 
   PREPARE t512_pb1 FROM g_sql
   DECLARE pny_curs CURSOR FOR t512_pb1
  
   CALL g_pny.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH pny_curs INTO g_pny[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT azp02 INTO g_pny[g_cnt].azp02
        FROM azp_file
       WHERE azp01 = g_pny[g_cnt].pnx04
 
      SELECT ima02 INTO g_pny[g_cnt].ima02
        FROM ima_file
       WHERE ima01 = g_pny[g_cnt].pnx07
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_pny.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t512_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_pny TO s_pny.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION unrelease
         LET g_action_choice="unrelease"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL t512_def_form()   #TQC-710033 add
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("group01","AUTO")       #No.FUN-6B0032      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel",TRUE)
 
END FUNCTION
 
FUNCTION t512_unrelease()
   DEFINE l_msg    STRING   #TQC-760091
   DEFINE l_azp03  LIKE azp_file.azp03     #MOD-950183
   DEFINE l_cnt    LIKE type_file.num5     #No.FUN-960011
   DEFINE l_pmm22  LIKE pmm_file.pmm22     #No.FUN-960011
   DEFINE l_pmm40  LIKE pmm_file.pmm40     #No.FUN-960011
   DEFINE l_pmm40t LIKE pmm_file.pmm40t    #No.FUN-960011
   DEFINE l_pmm905 LIKE pmm_file.pmm905    #No.FUN-960011
 
   IF NOT cl_sure(0,0) THEN
      RETURN
   END IF
 
   CALL cl_wait()
 
   LET g_msg = ""
   LET g_success = "Y"
 
   FOR g_i = 1 TO g_rec_b
      IF g_pny[g_i].sel = "Y" THEN
         IF cl_null(g_msg) THEN
            LET g_msg = "'",g_pny[g_i].pny21 CLIPPED,"'"
         ELSE
            LET g_msg = g_msg CLIPPED,",'",g_pny[g_i].pny21,"'"
         END IF
        #TQC-760091 begin
         LET l_msg = " pmm01 ='",g_pny[g_i].pny21 CLIPPED,"'"
         IF g_pny[g_i].pny07 <> "3" THEN   #No.FUN-950096
         #No.FUN-960011 start -----
            SELECT pmm905 INTO l_pmm905
              FROM pmm_file
             WHERE pmm01 = g_pny[g_i].pny21
            IF l_pmm905 = 'N' THEN
               CONTINUE FOR
            END IF
         #No.FUN-960011 end -------
           #-MOD-950183-add-
            SELECT azp03 INTO l_azp03 FROM azp_file
             WHERE azp01 = g_pny[g_i].pnx04
         #   CALL cl_ins_del_sid(2) #FUN-980030    #FUN-990069
            CALL cl_ins_del_sid(2,'') #FUN-980030    #FUN-990069
            CLOSE DATABASE 
            DATABASE l_azp03
         #   CALL cl_ins_del_sid(1) #FUN-980030   #FUN-990069
            CALL cl_ins_del_sid(1,g_pny[g_i].pnx04) #FUN-980030   #FUN-990069
            CALL p811(l_msg,"A") RETURNING g_success
         #   CALL cl_ins_del_sid(2) #FUN-980030   #FUN-990069
            CALL cl_ins_del_sid(2,'') #FUN-980030   #FUN-990069
            CLOSE DATABASE 
            DATABASE g_dbs
         #   CALL cl_ins_del_sid(1,g_plant) #FUN-980030
           #-MOD-950183-end-
            IF g_success = "N" THEN
               CALL cl_err("","apm-043",1)
               RETURN
            END IF
         END IF   #No.FUN-950096
        #TQC-760091 end
      END IF
   END FOR
 
   IF NOT cl_null(g_msg) THEN
      LET g_msg = " pmm01 in (",g_msg CLIPPED,")"
      #CALL p811(g_msg,"A") RETURNING g_success      #TQC-760091
   END IF
 
  #TQC-760091 begin
   #IF g_success = "N" THEN
   #   CALL cl_err("","apm-043",1)
   #   RETURN
   #END IF
  #TQC-760091 end
 
   BEGIN WORK
   CALL s_showmsg_init()        #No.FUN-710030
   FOR g_i = 1 TO g_rec_b
#No.FUN-710030 -- begin --
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
#No.FUN-710030 -- end --
#No.FUN-960011 start -----
#     IF g_pny[l_ac].sel = "Y" THEN
      IF g_pny[g_i].sel = "Y" THEN
 
#        DELETE FROM pmm_file
#         WHERE pmm01 = g_pny[g_i].pny21
#        IF STATUS THEN
#           CALL cl_err("del pmm error","",0)   #No.FUN-660129
#No.FUN-710030 -- begin --
#            CALL cl_err3("del","pmm_file",g_pny[g_i].pny21,"",SQLCA.sqlcode,"","del pmm error",1)  #No.FUN-660129
#           IF g_bgerr THEN
#              CALL s_errmsg("pmm01",g_pny[g_i].pny21,"del pmm error",SQLCA.sqlcode,1)
#           ELSE
#              CALL cl_err3("del","pmm_file",g_pny[g_i].pny21,"",SQLCA.sqlcode,"","del pmm error",1)
#           END IF
#No.FUN-710030 -- end --
#           LET g_success = "N"
#        END IF
 
#        DELETE FROM pmn_file
#         WHERE pmn01 = g_pny[g_i].pny21
#        IF STATUS THEN
#           CALL cl_err("del pmn error","",0)   #No.FUN-660129
#No.FUN-710030 -- begin --
#            CALL cl_err3("del","pmn_file",g_pny[g_i].pny21,"",SQLCA.sqlcode,"","del pmn error",1)  #No.FUN-660129
#           IF g_bgerr THEN
#              CALL s_errmsg("pmn01",g_pny[g_i].pny21,"del pmn error",SQLCA.sqlcode,1)
#           ELSE
#              CALL cl_err3("del","pmn_file",g_pny[g_i].pny21,"",SQLCA.sqlcode,"","del pmn error",1)
#           END IF
#No.FUN-710030 -- end --
#           LET g_success = "N"
#        #NO.FUN-7B0018 08/02/29 add --begin
#        ELSE
#           IF NOT s_industry('std') THEN
#              IF NOT s_del_pmni(g_pny[g_i].pny21,'','') THEN
#                 LET g_success = 'N'
#              END IF
#           END IF
#        #NO.FUN-7B0018 08/02/29 add --end
#        END IF
 
         DELETE FROM pmn_file
          WHERE pmn01 = g_pny[g_i].pny21
            AND pmn02 = g_pny[g_i].pny22
         IF STATUS THEN 
            IF g_bgerr THEN
               CALL s_errmsg("pmn01",g_pny[g_i].pny21,"del pmn error",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("del","pmn_file",g_pny[g_i].pny21,"",SQLCA.sqlcode,"","del pmn error",1)
            END IF
         ELSE
            IF NOT s_industry('std') THEN
               IF NOT s_del_pmni(g_pny[g_i].pny21,g_pny[g_i].pny22,'') THEN
                  LET g_success = 'N'
               END IF
            END IF
         END IF
         SELECT COUNT(*) INTO l_cnt FROM pmn_file
          WHERE pmn01 = g_pny[g_i].pny21
         IF l_cnt = 0 THEN
            DELETE FROM pmm_file
             WHERE pmm01 = g_pny[g_i].pny21
            IF STATUS THEN
               IF g_bgerr THEN
                  CALL s_errmsg("pmm01",g_pny[g_i].pny21,"del pmm error",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("del","pmm_file",g_pny[g_i].pny21,"",SQLCA.sqlcode,"","del pmm error",1)
               END IF
               LET g_success = "N"
            END IF
         ELSE
            SELECT SUM(pmn88),SUM(pmn88t) INTO l_pmm40,l_pmm40t
              FROM pmn_file
             WHERE pmn01 = g_pny[g_i].pny21
 
            SELECT pmm22 INTO l_pmm22 FROM pmm_file
             WHERE pmm01 = g_pny[g_i].pny21
            SELECT azi04 INTO t_azi04 FROM azi_file
             WHERE azi01=l_pmm22 AND aziacti ='Y'
            CALL cl_digcut(l_pmm40,t_azi04) RETURNING l_pmm40
            CALL cl_digcut(l_pmm40t,t_azi04) RETURNING l_pmm40t
 
            UPDATE pmm_file SET pmm40 = l_pmm40,
                                pmm40t= l_pmm40t
             WHERE pmm01 = g_pny[g_i].pny21
            IF STATUS THEN
               IF g_bgerr THEN
                  CALL s_errmsg("pmm01",g_pny[g_i].pny21,"upd pmm error",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","pmm_file",g_pny[g_i].pny21,"",SQLCA.sqlcode,"","upd pmm error",1)
               END IF
               LET g_success = "N"
            END IF
         END IF
#No.FUN-960011 end ------
         UPDATE pny_file SET pny21 = "",
                             pny22 = ""
          WHERE pny21 = g_pny[g_i].pny21
            AND pny22 = g_pny[g_i].pny22          #No.FUN-960011 add
         IF STATUS THEN
#           CALL cl_err("upd pny err",STATUS,0)   #No.FUN-660129
#No.FUN-710030 -- begin --
#            CALL cl_err3("upd","pny_file",g_pny[g_i].pny21,"",SQLCA.sqlcode,"","upd pny err",1)  #No.FUN-660129
            IF g_bgerr THEN
               CALL s_errmsg("pny21",g_pny[g_i].pny21,"upd pny err",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","pny_file",g_pny[g_i].pny21,"",SQLCA.sqlcode,"","upd pny err",1)
            END IF
#No.FUN-710030 -- end --
            LET g_success = "N"
         END IF
 
         UPDATE pml_file SET pml21 = pml21-g_pny[g_i].pny19
          WHERE pml01 = g_pny[g_i].pnx05
            AND pml02 = g_pny[g_i].pnx06
         IF STATUS THEN
#           CALL cl_err("upd pml err",STATUS,0)   #No.FUN-660129
#No.FUN-710030 -- begin --
#            CALL cl_err3("upd","pml_file",g_pny[g_i].pnx05,"",STATUS,"","upd pml err",1)  #No.FUN-660129
            IF g_bgerr THEN
               LET g_showmsg = g_pny[g_i].pnx05,"/",g_pny[g_i].pnx06
               CALL s_errmsg("pml01,pml02",g_showmsg,"upd pml err",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","pml_file",g_pny[g_i].pnx05,g_pny[g_i].pnx06,STATUS,"","upd pml err",1)
            END IF
#No.FUN-710030 -- end --
            LET g_success = "N"
         END IF
 
         UPDATE pnx_file SET pnx20 = pnx20-g_pny[g_i].pny19
          WHERE pnx01 = g_pny01
            AND pnx02 = g_pny02
            AND pnx03 = g_pny[g_i].pnx03
            AND pnx04 = g_pny[g_i].pnx04
            AND pnx05 = g_pny[g_i].pnx05
            AND pnx06 = g_pny[g_i].pnx06
         IF STATUS THEN
#           CALL cl_err("upd pnx err",STATUS,0)   #No.FUN-660129
#No.FUN-710030 -- begin --
#            CALL cl_err3("upd","pnx_file",g_pny01,"",STATUS,"","upd pnx err",1)  #No.FUN-660129
            IF g_bgerr THEN
               LET g_showmsg = g_pny01,"/",g_pny02,"/",g_pny[g_i].pnx03,"/",g_pny[g_i].pnx04,"/",g_pny[g_i].pnx05,"/",g_pny[g_i].pnx06
               CALL s_errmsg("pnx01,pnx02,pnx03,pnx04,pnx05,pnx06",g_showmsg,"upd pnx err",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","pnx_file",g_pny01,g_pny02,SQLCA.sqlcode,"","upd pnx err",1)
            END IF
#No.FUN-710030 -- end --
            LET g_success = "N"
         END IF
      END IF
   END FOR
#No.FUN-710030 -- begin --
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
#No.FUN-710030 -- end --
 
   CALL s_showmsg()       #No.FUN-710030
   IF g_success = "Y" THEN
      COMMIT WORK
      CALL cl_err("","abm-019",1)
   ELSE
      ROLLBACK WORK
      CALL cl_err("","abm-020",1)
   END IF
 
END FUNCTION
 
#-----TQC-710033---------add----str---
FUNCTION t512_def_form()   
    IF g_sma.sma115 = "N" THEN
       CALL cl_set_comp_visible("pny13,pny16",FALSE)
    END IF
    #使用多單位的單位管制方式-母子單位
    IF g_sma.sma122 ='1' THEN 
       #--單身
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg #母單位數量
       CALL cl_set_comp_att_text("pny16",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg #子單位數量
       CALL cl_set_comp_att_text("pny13",g_msg CLIPPED)
       #--end
    END IF
 
    #使用多單位的單位管制方式-參考單位
    IF g_sma.sma122 ='2' THEN 
       #--單身
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg #參考單位數量
       CALL cl_set_comp_att_text("pny16",g_msg CLIPPED)
       CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg #異動數量
       CALL cl_set_comp_att_text("pny13",g_msg CLIPPED)
       #--end
    END IF
END FUNCTION
#-----TQC-710033---------add----end---
 
