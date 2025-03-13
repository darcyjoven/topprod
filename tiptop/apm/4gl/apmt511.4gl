# Prog. Version..: '5.30.06-13.03.12(00010)'     #
# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name.... apmt511.4gl
# Descriptions.... 集團採購發出作業
# Date & Author... No.FUN-630040 06/03/21 By Nicola
# Modify.......... No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.......... No.FUN-670061 06/07/17 By kim GP3.5 利潤中心
# Modify.......... No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.......... No.FUN-6A0162 06/11/07 By jamie 新增action"相關文件"
# Modify.......... No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modfiy.......... No.CHI-690043 06/11/22 By Sarah pmn_file增加pmn90(取出單價),INSERT INTO pmn_file前要增加LET pmn90=pmn31
# Modify.......... No.MOD-6B0071 06/12/13 By pengu default 調撥/採購單別時判斷是錯誤
# Modify.......... No.TQC-710071 07/01/18 By Nicola 統購產生的PO，應產生在各需求工廠，而非現行DB
# Modify.......... No.FUN-710030 07/02/05 By johnray 錯誤訊息匯總顯示修改
# Modify.......... No.TQC-710033 07/03/29 By Mandy 多單位畫面標準寫法調整
# Modify.......... No.TQC-730119 07/03/30 By Nicola pny24應為最終供應商
# Modify.......... No.MOD-740357 07/04/23 By Nicola 修改ora
# Modify.......... No.TQC-760062 07/06/07 By rainy 採購發出時-236 error 
# Modify.......... No.TQC-760090 07/06/11 By Mandy 類別為調撥時其pmm901應為"Y"
# Modify.......... No.TQC-760092 07/06/15 By rainy pmm909 應為'2'
# Modify.......... No.TQC-760093 07/06/20 By rainy 轉採購量無回寫
# Modify.......... No.TQC-780096 07/08/31 By rainy  primary key 複合key 處理 
# Modify.......... No.FUN-830132 08/03/28 By hellen 行業別表拆分INSERT/DELETE
# Modify.......... No.FUN-840006 08/04/07 By hellen 項目管理，去掉預算編號相關欄位 pmn66,pmm06
# Modify.......... No.MOD-840568 08/04/23 By Sunyanchun 執行采購發出時會出現訊息.ins pmm error在 INSERT 的欄位數量與 VALUES 的數量不符合
# Modify.......... No.CHI-910049 09/01/20 By Smapmin 調整SQL語法
# Modify.......... No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()   
# Modify.......... No.FUN-950096 09/05/25 By Nicola pny07增加3.自行採購
# Modify.......... No.MOD-950183 09/06/05 By Dido poz04已無使用, 應取單身第0站的上游廠商
# Modify.......... No.FUN-960011 09/06/25 By douzh 用臨時表產生采購單/同(類別、撥入工廠、撥出工廠、預計交貨日、內部流程代碼、供應商代碼)
# Modify.......... No.FUN-980006 09/08/21 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.......... No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.......... No.FUN-980094 09/09/15 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.......... No.FUN-980093 09/09/15 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.......... No.FUN-980025 09/09/27 By dxfwo database 切換
# Modify.........: No.TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:FUN-960130 09/12/09 By Cockroach PASS NO.
# Modify.........: No:TQC-970329 09/12/29 By baofei t511_release()段判斷g_carry[i].azp03是否為空 
# Modify.........: No.TQC-A10060 10/01/12 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:FUN-A30056 10/04/13 By Carrier call p801时,给是否IN TRANSACTION标志位
# Modify.........: No.FUN-A50102 10/07/19 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.......... No.MOD-A90014 10/09/13 By Smapmin 供應商要抓取第0站下一站的供應商
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管
# Modify.........: No:MOD-B30269 11/03/14 By Summer 單身除了選擇的checkbox外,其餘不可輸入 
# Modify.........: No.TQC-BB0126 11/11/16 By destiny 提示信息不对
# Modify.........: No:TQC-C20001 12/02/01 By suncx 已採購發出的資料不可重複採購發出
# Modify.........: No.TQC-C20394 12/02/23 By zhuhao s_auto_assign_no 前後加判斷
# Modify.........: No:MOD-C80116 12/08/15 By SunLM  對pmn13超/短交限率,進行賦值
# Modify.........: No:MOD-D70165 13/07/24 By SunLM  調用SUB函數對pmn13超/短交限率,進行賦值

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
                  pny10     LIKE pny_file.pny10,
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
                  pny10     LIKE pny_file.pny10,
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
DEFINE g_i            LIKE type_file.num10         #No.FUN-680136
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680136
DEFINE g_carry DYNAMIC ARRAY OF RECORD
               azp03     LIKE azp_file.azp03,
               pmm01     LIKE pmm_file.pmm01
               END RECORD
DEFINE g_pny24 DYNAMIC ARRAY OF RECORD
                  pnx03     LIKE pnx_file.pnx03,
                  pnx04     LIKE pnx_file.pnx04,
                  pnx05     LIKE pnx_file.pnx05,
                  pnx06     LIKE pnx_file.pnx06,
                  pny07     LIKE pny_file.pny07,
                  pny08     LIKE pny_file.pny08,
                  pny09     LIKE pny_file.pny09,
                  pny10     LIKE pny_file.pny10,
                  pny20     LIKE pny_file.pny20,
                  pny24     LIKE pny_file.pny24
               END RECORD
#TQC-C20001 add ---------------------------------
DEFINE g_pny21 DYNAMIC ARRAY OF RECORD
                  pny21     LIKE pny_file.pny21,
                  pny22     LIKE pny_file.pny22
               END RECORD
#TQC-C20001 add end------------------------------
 
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
 
   OPEN WINDOW t511_w WITH FORM "apm/42f/apmt511"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   DROP TABLE t511_tmp
   CREATE TEMP TABLE t511_tmp(
                  pny07     LIKE pny_file.pny07,  #類別
                  pny08     LIKE pny_file.pny08,  #撥出營運中心
                  pny09     LIKE pny_file.pny09,  #撥入營運中心
                  pny10     LIKE pny_file.pny10,  #預計交貨日期
                  pny20     LIKE pny_file.pny20,  #內部流程代碼
                  pny24     LIKE pny_file.pny24)  #供應商代碼
 
   CALL t511_def_form()   #TQC-710033 add
 
   CALL t511_menu()
 
   DROP TABLE t511_tmp    #FUN-960011
 
   CLOSE WINDOW t511_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t511_menu()
 
   WHILE TRUE
      CALL t511_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t511_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t511_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "release"
            IF cl_chk_act_auth() THEN
               CALL t511_release()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
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
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t511_q()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
 
   CLEAR FORM
   CALL g_pny.clear()
   LET g_pny02 = "1"
 
   CALL cl_set_head_visible("group01","YES")           #No.FUN-6B0032
   INPUT g_pny01,g_pny02,g_pny03_1,g_pny03_2 WITHOUT DEFAULTS 
         FROM pny01,pny02,pny03_1,pny03_2 
 
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD pny01
         SELECT geu02 INTO g_geu02 FROM geu_file
          WHERE geu01 = g_pny01
            AND geu00 = "4"
         IF STATUS THEN
            CALL cl_err3("sel","geu_file",g_pny01,"","anm-027","","",1)  #No.FUN-660129
            NEXT FIELD pny01
         END IF
         DISPLAY g_geu02 TO geu02
 
      AFTER FIELD pny02
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
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CONSTRUCT g_wc2 ON pnx04,pnx05,pnx07,pnx09,pny07,pny08,pny09,pny20,pny24
                 FROM s_pny[1].pnx04,s_pny[1].pnx05,s_pny[1].pnx07,
                      s_pny[1].pnx09,s_pny[1].pny07,s_pny[1].pny08,
                      s_pny[1].pny09,s_pny[1].pny20,s_pny[1].pny24
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL t511_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t511_b()
   DEFINE l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680136 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680136 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
 
  #IF cl_null(g_pny[l_ac].pnx03) THEN #MOD-B30269 mark
   IF cl_null(g_pny01) THEN #MOD-B30269
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
 
      ON ACTION select_all   #全部選取
         CALL t511_sel_all('Y')
 
      ON ACTION select_non   #全部不選
         CALL t511_sel_all('N')
 
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
 
FUNCTION t511_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b
    LET g_pny[l_i].sel = p_flag
    DISPLAY BY NAME g_pny[l_i].sel
  END FOR
END FUNCTION
 
FUNCTION t511_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   IF g_pny02 = "1" THEN
      LET g_sql = "SELECT 'N',pnx03,pnx04,'',pnx05,pnx06,pnx07,'',",
                  "       pnx09,pnx16,pnx18,pny07,pny08,pny09,pny10,pny16,",
                  "       pny13,pny19,pny20,pny24,pny21,pny22",
                  "  FROM pnx_file,pny_file",
                  " WHERE ",p_wc2 CLIPPED,
                  "   AND pnx01 = '",g_pny01,"'",
                  "   AND pnx02 = '",g_pny02,"'",
                  "   AND pnx01 = pny01",
                  "   AND pnx02 = pny02",
                  "   AND pnx03 = pny03",
                  "   AND pnx04 = pny04",
                  "   AND pnx05 = pny05",
                  "   AND pnx06 = pny06",
                  "   AND pny21 IS NULL"
      IF cl_null(g_pny03_1) THEN
         LET g_sql = g_sql CLIPPED," ORDER BY pnx03,pnx04"
      ELSE
         LET g_sql = g_sql CLIPPED," AND pnx03 = '",g_pny03_1,"'",
                                   " ORDER BY pnx03,pnx04"
      END IF  
   ELSE
      LET g_sql = "SELECT 'N',pnx03,pnx04,'',pnx05,pnx06,pnx07,'',",
                  "       pnx09,pnx16,pnx18,pny07,pny08,pny09,pny10,pny16,",
                  "       pny13,pny19,pny20,pny24,pny21,pny22",
                  "  FROM pnx_file,pny_file",
                  " WHERE ",p_wc2 CLIPPED,
                  "   AND pnx01 = '",g_pny01,"'",
                  "   AND pnx02 = '",g_pny02,"'",
                  "   AND pnx01 = pny01",
                  "   AND pnx02 = pny02",
                  "   AND pnx03 = pny03",
                  "   AND pnx04 = pny04",
                  "   AND pnx05 = pny05",
                  "   AND pnx06 = pny06",
                  "   AND pny21 IS NULL"
      IF cl_null(g_pny03_2) THEN
         LET g_sql = g_sql CLIPPED," ORDER BY pnx03,pnx04"
      ELSE
         LET g_sql = g_sql CLIPPED," AND pnx03 = '",g_pny03_2,"'",
                                   " ORDER BY pnx03,pnx04"
      END IF  
   END IF
 
   PREPARE t511_pb1 FROM g_sql
   DECLARE pny_curs CURSOR FOR t511_pb1
  
   CALL g_pny.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH pny_curs INTO g_pny[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach.",STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT azp02 INTO g_pny[g_cnt].azp02
        FROM azp_file
       WHERE azp01 = g_pny[g_cnt].pnx04
 
      SELECT ima02 INTO g_pny[g_cnt].ima02
        FROM ima_file
       WHERE ima01 = g_pny[g_cnt].pnx07
 
      LET g_pny24[g_cnt].pnx03 = g_pny[g_cnt].pnx03
      LET g_pny24[g_cnt].pnx04 = g_pny[g_cnt].pnx04
      LET g_pny24[g_cnt].pnx05 = g_pny[g_cnt].pnx05
      LET g_pny24[g_cnt].pnx06 = g_pny[g_cnt].pnx06
      LET g_pny24[g_cnt].pny07 = g_pny[g_cnt].pny07
      LET g_pny24[g_cnt].pny08 = g_pny[g_cnt].pny08
      LET g_pny24[g_cnt].pny09 = g_pny[g_cnt].pny09
      LET g_pny24[g_cnt].pny10 = g_pny[g_cnt].pny10
      LET g_pny24[g_cnt].pny20 = g_pny[g_cnt].pny20
      LET g_pny24[g_cnt].pny24 = g_pny[g_cnt].pny24
 
      IF cl_null(g_pny[g_cnt].pny24) THEN
         IF g_pny[g_cnt].pny07 != "3" THEN
            SELECT poy03 INTO g_pny[g_cnt].pny24
             FROM poy_file
            WHERE poy01 = g_pny[g_cnt].pny20
              AND poy02 = 0
         END IF 
      END IF 
           
 
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
 
FUNCTION t511_bp(p_ud)
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
 
      ON ACTION release
         LET g_action_choice="release"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL t511_def_form()   #TQC-710033 add
 
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
 
FUNCTION t511_release()
   DEFINE l_pnx       RECORD LIKE pnx_file.*
   DEFINE l_pny       RECORD LIKE pny_file.*
   DEFINE l_pmm       RECORD LIKE pmm_file.*
   DEFINE l_pmn       RECORD LIKE pmn_file.*
   DEFINE l_pnw04     LIKE pnw_file.pnw04
   DEFINE l_sta       LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1)
   DEFINE li_result   LIKE type_file.num5       #No.FUN-680136 SMALLINT
   DEFINE l_azp03     LIKE azp_file.azp03     #No.TQC-710071
   DEFINE l_dbs       LIKE type_file.chr21    #No.TQC-710071 
   DEFINE l_dbs_tra   LIKE type_file.chr21    #FUN-980093 
   DEFINE l_sql       LIKE type_file.chr1000  #No.TQC-710071
   DEFINE l_pml121    LIKE pml_file.pml121    #No.TQC-710071
   DEFINE l_pml21     LIKE pml_file.pml21     #TQC-760093
   DEFINE l_pmni      RECORD LIKE pmni_file.* #No.FUN-830132
   DEFINE l_n         LIKE type_file.num5          #No.FUN-960011
   DEFINE b_pnx       RECORD LIKE pnx_file.*       #No.FUN-960011 
   DEFINE b_pny       RECORD LIKE pny_file.*       #No.FUN-960011
   DEFINE l_i         LIKE type_file.num5          #No.FUN-960011
   DEFINE l_j         LIKE type_file.num5          #No.FUN-960011
   DEFINE l_poy03     LIKE poy_file.poy03          #No.FUN-960011
   DEFINE l_plant     LIKE azp_file.azp01  #FUN-980006 add
   DEFINE l_legal     LIKE azw_file.azw02  #FUN-980006 add
   DEFINE l_err       STRING               #TQC-C20001 add
   DEFINE l_ima07  LIKE ima_file.ima07     #MOD-C80116 add
 
   IF g_rec_b = 0 THEN
      CALL cl_err('','apm-777',0)
   ELSE
      IF NOT cl_sure(0,0) THEN                                                     
         RETURN                                                                    
      END IF
      CALL cl_wait()
   END IF
   BEGIN WORK
 
   LET g_success = "Y"
 
   CALL g_carry.clear()   #No.FUN-960011
   LET l_j = 1            #No.FUN-960011
 
   CALL s_showmsg_init()        #No.FUN-710030
   FOR g_i = 1 TO g_rec_b
   IF g_success="N" THEN
      LET g_totsuccess="N"
      LET g_success="Y"
   END IF
      IF g_pny[g_i].sel = "Y" THEN
         SELECT COUNT(*) INTO l_n FROM t511_tmp
          WHERE pny07 = g_pny[g_i].pny07
            AND pny08 = g_pny[g_i].pny08
            AND pny09 = g_pny[g_i].pny09
            AND pny10 = g_pny[g_i].pny10
            AND pny20 = g_pny[g_i].pny20
            AND pny24 = g_pny[g_i].pny24
         IF l_n = 0 THEN
           IF NOT cl_null(g_pny24[g_i].pny24) THEN    #No.FUN-960011 shi add
            SELECT pnx_file.*,pny_file.* INTO l_pnx.*,l_pny.*
              FROM pnx_file,pny_file
             WHERE pnx01 = pny01
               AND pnx02 = pny02
               AND pnx03 = pny03
               AND pnx04 = pny04
               AND pnx05 = pny05
               AND pnx06 = pny06
               AND pny01 = g_pny01
               AND pny02 = g_pny02
               AND pny03 = g_pny[g_i].pnx03
               AND pny04 = g_pny[g_i].pnx04
               AND pny05 = g_pny[g_i].pnx05
               AND pny06 = g_pny[g_i].pnx06
               AND pny07 = g_pny[g_i].pny07
               AND pny08 = g_pny[g_i].pny08
               AND pny09 = g_pny[g_i].pny09
               AND pny10 = g_pny[g_i].pny10
               AND pny20 = g_pny[g_i].pny20
               AND pny24 = g_pny24[g_i].pny24
           ELSE
              SELECT pnx_file.*,pny_file.* INTO l_pnx.*,l_pny.*
              FROM pnx_file,pny_file
             WHERE pnx01 = pny01
               AND pnx02 = pny02
               AND pnx03 = pny03
               AND pnx04 = pny04
               AND pnx05 = pny05
               AND pnx06 = pny06
               AND pny01 = g_pny01
               AND pny02 = g_pny02
               AND pny03 = g_pny[g_i].pnx03
               AND pny04 = g_pny[g_i].pnx04
               AND pny05 = g_pny[g_i].pnx05
               AND pny06 = g_pny[g_i].pnx06
               AND pny07 = g_pny[g_i].pny07
               AND pny08 = g_pny[g_i].pny08
               AND pny09 = g_pny[g_i].pny09
               AND pny10 = g_pny[g_i].pny10
               AND pny20 = g_pny[g_i].pny20
               AND pny24 IS NULL
            END IF

            #TQC-C20001 add-------------------------
            IF NOT cl_null(l_pny.pny21) AND NOT cl_null(l_pny.pny22) THEN
               LET l_err = l_pny.pny01,"|",l_pny.pny02,"|",l_pny.pny03,"|",l_pny.pny04,"|",l_pny.pny05,"|",l_pny.pny06
               IF g_bgerr THEN
                  CALL s_errmsg("pny01|pny02|pny03|pny04|pny05|pny06",l_err,"sel pny_file,pnx_file error","apm1072",1)
               ELSE
                  CALL cl_err3("sel","pny_file",l_err,"","apm1072","","sel pny_file,pnx_file error",1)
               END IF
               LET g_success = "N"
            END IF
            #TQC-C20001 add end---------------------
 
            SELECT azp03 INTO l_azp03 FROM azp_file
             WHERE azp01 = l_pnx.pnx04
            LET l_dbs = s_dbstring(l_azp03)   #TQC-950010 ADD  
 
            LET l_plant = l_pnx.pnx04  #FUN-980006 add
            CALL s_getlegal(l_plant) RETURNING l_legal   #FUN-980006 add
 
            LET g_plant_new = l_pnx.pnx04 
            CALL s_gettrandbs()
            LET l_dbs_tra = g_dbs_tra
 
            #採購單頭
            IF l_pny.pny07 = "2" OR l_pny.pny07 = "3" THEN   #No.FUN-950096
               SELECT pnv03 INTO l_pnw04 FROM pnv_file
                WHERE pnv01 = l_pny.pny01
                  AND pnv02 = l_pny.pny04
            ELSE
               SELECT pnw04 INTO l_pnw04 FROM pnw_file
                WHERE pnw01 = l_pny.pny01
                  AND pnw02 = l_pny.pny08
                  AND pnw03 = l_pny.pny09
            END IF
            #TQC-C20394--add--begin
            IF cl_null(l_pnw04) THEN
               LET g_success = 'N'
               CALL cl_err('','pnw-001',1)
               ROLLBACK WORK
               RETURN
            END IF
            #TQC-C20394--add--end
            CALL s_auto_assign_no("apm",l_pnw04,l_pnx.pnx08,"",
                                  "pmm_file","pmm01",l_plant,"","")   #FUN-980094
                        RETURNING li_result,l_pmm.pmm01
            #TQC-C20394--add--begin
            IF (NOT li_result) THEN
               LET g_success = 'N'
               CALL cl_err('','abm-621',0)
               ROLLBACK WORK
               RETURN
            END IF
            #TQC-C20394--add--end
            IF l_pny.pny07 = "3" THEN
               LET l_pmm.pmm02 = "REG"
            ELSE
               LET l_pmm.pmm02 = "TAP"
            END IF
            LET l_pmm.pmm03 = 0
            LET l_pmm.pmm04 = g_today
 
            IF l_pny.pny07 = "3" THEN
               LET l_pmm.pmm09 = l_pny.pny24
               SELECT pmc15,pmc16,pmc17,pmc47,pmc22,pmc49
                 INTO l_pmm.pmm10,l_pmm.pmm11,l_pmm.pmm20,
                      l_pmm.pmm21,l_pmm.pmm22,l_pmm.pmm41
                 FROM pmc_file
                WHERE pmc01 = l_pmm.pmm09
            ELSE
               SELECT poy03,poy06,poy09,poy46
                 INTO l_pmm.pmm09,l_pmm.pmm20,l_pmm.pmm21,l_pmm.pmm13 #付款方式,稅別,採購成本中心抓取 apmi000 設定
                FROM poy_file
               WHERE poy01 = l_pny.pny20
                 #-----MOD-A90014---------
                 #AND poy02 = 0  
                 AND poy02 = (SELECT MIN(poy02) FROM poy_file 
                               WHERE poy01 = l_pny.pny20
                                 AND poy02 <> 0)
                 #-----END MOD-A90014-----
           
               SELECT pmc15,pmc16,pmc22,pmc49
                 INTO l_pmm.pmm10,l_pmm.pmm11,l_pmm.pmm22,l_pmm.pmm41
                 FROM pmc_file
                WHERE pmc01 = l_pmm.pmm09
            END IF
 
            LET l_pmm.pmm12 = g_user
 
            SELECT gen03 INTO l_pmm.pmm13
              FROM gen_file
             WHERE gen01 = l_pmm.pmm12
 
            LET l_pmm.pmm18 = "Y"     #確
            LET l_pmm.pmm25 = "2"     #狀
            LET l_pmm.pmm30 = "N"
            LET l_pmm.pmm31 = YEAR(g_today)
            LET l_pmm.pmm32 = MONTH(g_today)
            LET l_pmm.pmm40 = 0
            LET l_pmm.pmm40t = 0
 
            CALL s_curr(l_pmm.pmm22,g_today) RETURNING l_pmm.pmm42
 
            SELECT gec04 INTO l_pmm.pmm43
              FROM gec_file
             WHERE gec01 = l_pmm.pmm21
 
            LET l_pmm.pmm44 = "1"
            LET l_pmm.pmm45 = "Y"
            LET l_pmm.pmm46 = 0
            LET l_pmm.pmm47 = 0
            LET l_pmm.pmm48 = 0
            LET l_pmm.pmm49 = "N"
 
            IF l_pny.pny07 = "3" THEN
               LET l_pmm.pmm901 = "N"
               LET l_pmm.pmm50 = ""
            ELSE
               IF cl_null(l_pny.pny24) THEN
                  LET l_pmm.pmm901 = "Y" #TQC-760090 add
                  LET l_pmm.pmm50 = ""
               ELSE
                  LET l_pmm.pmm901 = "Y"
                  LET l_pmm.pmm50 = l_pny.pny24
               END IF
            END IF
 
            IF l_pny.pny07 = "3" THEN
               LET l_pmm.pmm902 = " "
               LET l_pmm.pmm903 = ""
               LET l_pmm.pmm904 = ""
               LET l_pmm.pmm905 = "N"
               LET l_pmm.pmm906 = " "
            ELSE
               LET l_pmm.pmm902 = "N"
               LET l_pmm.pmm903 = "1"
               LET l_pmm.pmm904 = l_pny.pny20
               LET l_pmm.pmm905 = "N"
               LET l_pmm.pmm906 = "Y"
            END IF
 
            LET l_pmm.pmm909 = "2"        #TQC-760092
            LET l_pmm.pmmprsw = "Y"
            LET l_pmm.pmmprno = 0
 
            SELECT smyapr,smysign,smyprint 
              INTO l_pmm.pmmmksg,l_pmm.pmmsign,l_pmm.pmmprit
              FROM smy_file
             WHERE smyslip = l_pnw04
 
            LET l_pmm.pmmdays = 0 
            LET l_pmm.pmmsseq = 0 
            LET l_pmm.pmmsmax = 0 
            LET l_pmm.pmmacti = "Y"
            LET l_pmm.pmmuser = g_user
            LET l_pmm.pmmoriu = g_user #FUN-980030
            LET l_pmm.pmmorig = g_grup #FUN-980030
            LET g_data_plant = g_plant #FUN-980030
            LET l_pmm.pmmgrup = g_grup
            LET l_pmm.pmmdate = g_today
            LET l_pmm.pmmplant= l_plant  #FUN-980006 add
            LET l_pmm.pmmlegal= l_legal  #FUN-980006 add
 
           #LET l_sql = "INSERT INTO ",l_dbs_tra CLIPPED,"pmm_file ",  #FUN-980093     #FUN-A50102 mark
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'pmm_file'),        #FUN-A50102   
                        "(pmm01,  pmm02,  pmm03,  pmm04,  pmm05,",
                        " pmm07,  pmm08,  pmm09,  pmm10,",        #No.FUN-840006 pmm07之前去掉pmm06
                        " pmm11,  pmm12,  pmm13,  pmm14,  pmm15,",
                        " pmm16,  pmm17,  pmm18,  pmm20,  pmm21,",
                        " pmm22,  pmm25,  pmm26,  pmm27,  pmm28,",
                        " pmm29,  pmm30,  pmm31,  pmm32,  pmm40,",
                        " pmm401, pmm41,  pmm42,  pmm43,  pmm44,",
                        " pmm45,  pmm46,  pmm47,  pmm48,  pmm49,",
                        " pmm50,  pmm99,  pmm901, pmm902, pmm903,",
                        " pmm904, pmm905, pmm906, pmm907, pmm908,",
                        " pmm909, pmm911, pmm912, pmm913, pmm914,",
                        " pmm915, pmm916, pmmprsw,pmmprno,pmmprdt,",
                        " pmmmksg,pmmsign,pmmdays,pmmprit,pmmsseq,",
                        " pmmsmax,pmmacti,pmmuser,pmmgrup,pmmmodu,",
                        " pmmdate,pmm40t, pmmud01,pmmud02,pmmud03,",
                        " pmmud04,pmmud05,pmmud06,pmmud07,pmmud08,",
                        " pmmud09,pmmud10,pmmud11,pmmud12,pmmud13,",
                        " pmmud14,pmmud15,pmmplant,pmmlegal,pmmoriu,pmmorig )",#TQC-A10060 add pmmoriu,pmmorig  #FUN-980006 add pmmplant,pmmlegal
                        " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                        "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                        "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                        "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                        "        ?,?,?,?,?,?, ?,?,?,?)"  #TQC-A10060 ?,?  #MOD-840568---del一個? #FUN-980006 add ?,?
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-920032
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
            PREPARE ins_pmm FROM l_sql
            EXECUTE ins_pmm USING l_pmm.pmm01,l_pmm.pmm02,l_pmm.pmm03,l_pmm.pmm04,l_pmm.pmm05,
                                  l_pmm.pmm07,l_pmm.pmm08,l_pmm.pmm09,l_pmm.pmm10,      #No.FUN-840006 l_pmm.pmm07之前去掉l_pmm.pmm06
                                  l_pmm.pmm11,l_pmm.pmm12,l_pmm.pmm13,l_pmm.pmm14,l_pmm.pmm15,
                                  l_pmm.pmm16,l_pmm.pmm17,l_pmm.pmm18,l_pmm.pmm20,l_pmm.pmm21,
                                  l_pmm.pmm22,l_pmm.pmm25,l_pmm.pmm26,l_pmm.pmm27,l_pmm.pmm28,
                                  l_pmm.pmm29,l_pmm.pmm30,l_pmm.pmm31,l_pmm.pmm32,l_pmm.pmm40,
                                  l_pmm.pmm401,l_pmm.pmm41,l_pmm.pmm42,l_pmm.pmm43,l_pmm.pmm44,
                                  l_pmm.pmm45,l_pmm.pmm46,l_pmm.pmm47,l_pmm.pmm48,l_pmm.pmm49,
                                  l_pmm.pmm50,l_pmm.pmm99,l_pmm.pmm901,l_pmm.pmm902,l_pmm.pmm903,
                                  l_pmm.pmm904,l_pmm.pmm905,l_pmm.pmm906,l_pmm.pmm907,l_pmm.pmm908,
                                  l_pmm.pmm909,l_pmm.pmm911,l_pmm.pmm912,l_pmm.pmm913,l_pmm.pmm914,
                                  l_pmm.pmm915,l_pmm.pmm916,l_pmm.pmmprsw,l_pmm.pmmprno,l_pmm.pmmprdt,
                                  l_pmm.pmmmksg,l_pmm.pmmsign,l_pmm.pmmdays,l_pmm.pmmprit,l_pmm.pmmsseq,
                                  l_pmm.pmmsmax,l_pmm.pmmacti,l_pmm.pmmuser,l_pmm.pmmgrup,l_pmm.pmmmodu,
                                  l_pmm.pmmdate,l_pmm.pmm40t,l_pmm.pmmud01,l_pmm.pmmud02,l_pmm.pmmud03,
                                  l_pmm.pmmud04,l_pmm.pmmud05,l_pmm.pmmud06,l_pmm.pmmud07,l_pmm.pmmud08,
                                  l_pmm.pmmud09,l_pmm.pmmud10,l_pmm.pmmud11,l_pmm.pmmud12,l_pmm.pmmud13,
                                  l_pmm.pmmud14,l_pmm.pmmud15,l_pmm.pmmplant,l_pmm.pmmlegal   #FUN-980006 add l_pmm.pmmplant,l_pmm.pmmlegal
                                 ,l_pmm.pmmoriu,l_pmm.pmmorig    #TQC-A10060  add  
 
            IF STATUS THEN
               IF g_bgerr THEN
                  CALL s_errmsg("pmm01",l_pmm.pmm01,"ins pmm error",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","pmm_file",l_pmm.pmm01,"",SQLCA.sqlcode,"","ins pmm error",1)
               END IF
               LET g_success = "N"
            END IF
 
            IF l_pny.pny07 <> '3' THEN
               LET g_carry[l_j].azp03 = l_azp03
               LET g_carry[l_j].pmm01 = l_pmm.pmm01
               LET l_j = l_j + 1
            END IF
 
            FOR l_i = 1 TO g_rec_b
               IF g_pny24[l_i].pny07 = g_pny[g_i].pny07 AND
                  g_pny24[l_i].pny08 = g_pny[g_i].pny08 AND
                  g_pny24[l_i].pny09 = g_pny[g_i].pny09 AND
                  g_pny24[l_i].pny10 = g_pny[g_i].pny10 AND
                  g_pny24[l_i].pny20 = g_pny[g_i].pny20 THEN
                  IF g_pny24[l_i].pny07 = '3' AND g_pny24[l_i].pny24 <> g_pny[g_i].pny24 THEN
                     CONTINUE FOR
                  END IF
                  IF g_pny24[l_i].pny07 <> '3' THEN
                     IF  cl_null(g_pny24[l_i].pny24) THEN
                        SELECT poy03 INTO l_poy03
                          FROM poy_file
                         WHERE poy01 = g_pny24[l_i].pny20
                           AND poy02 = 0
                        IF l_poy03 <> l_pmm.pmm09 THEN
                           CONTINUE FOR
                        END IF
                     ELSE
                        IF g_pny24[l_i].pny24 <> g_pny[g_i].pny24 THEN
                           CONTINUE FOR
                        END IF
                     END IF
                  END IF
               ELSE
                  CONTINUE FOR
               END IF
            IF NOT cl_null(g_pny24[l_i].pny24) THEN
               SELECT pnx_file.*,pny_file.* INTO b_pnx.*,b_pny.*
                 FROM pnx_file,pny_file
                WHERE pnx01 = pny01
                  AND pnx02 = pny02
                  AND pnx03 = pny03
                  AND pnx04 = pny04
                  AND pnx05 = pny05
                  AND pnx06 = pny06
                  AND pny01 = g_pny01
                  AND pny02 = g_pny02
                  AND pny03 = g_pny24[l_i].pnx03
                  AND pny04 = g_pny24[l_i].pnx04
                  AND pny05 = g_pny24[l_i].pnx05
                  AND pny06 = g_pny24[l_i].pnx06
                  AND pny07 = g_pny24[l_i].pny07
                  AND pny08 = g_pny24[l_i].pny08
                  AND pny09 = g_pny24[l_i].pny09
                  AND pny10 = g_pny24[l_i].pny10
                  AND pny20 = g_pny24[l_i].pny20
                  AND pny24 = g_pny24[l_i].pny24
            ELSE
               SELECT pnx_file.*,pny_file.* INTO b_pnx.*,b_pny.*
                 FROM pnx_file,pny_file
                WHERE pnx01 = pny01
                  AND pnx02 = pny02
                  AND pnx03 = pny03
                  AND pnx04 = pny04
                  AND pnx05 = pny05
                  AND pnx06 = pny06
                  AND pny01 = g_pny01
                  AND pny02 = g_pny02
                  AND pny03 = g_pny24[l_i].pnx03
                  AND pny04 = g_pny24[l_i].pnx04
                  AND pny05 = g_pny24[l_i].pnx05
                  AND pny06 = g_pny24[l_i].pnx06
                  AND pny07 = g_pny24[l_i].pny07
                  AND pny08 = g_pny24[l_i].pny08
                  AND pny09 = g_pny24[l_i].pny09
                  AND pny10 = g_pny24[l_i].pny10
                  AND pny20 = g_pny24[l_i].pny20
                  AND pny24 IS NULL
            END IF
               #-----單身-----
               LET l_pmn.pmn01 = l_pmm.pmm01
               LET l_pmn.pmn011 = l_pmm.pmm02
 
               LET l_sql = "SELECT MAX(pmn02)+1 ",
                         # "  FROM ",l_dbs_tra CLIPPED,"pmn_file ",  #FUN-980093 #FUN-A50102 mark
                           "  FROM ",cl_get_target_table(l_plant,'pmn_file'),    #FUN-A50102 
                           " WHERE pmn01='",l_pmm.pmm01,"' "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-980093
               PREPARE pmn_b_p FROM l_sql
               IF STATUS THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("","","pmn_p",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("","","","",SQLCA.sqlcode,"","pmn_p",1)
                  END IF
               END IF
               DECLARE pmn_b_c CURSOR FOR pmn_b_p
               OPEN pmn_b_c
               FETCH pmn_b_c INTO l_pmn.pmn02
               CLOSE pmn_b_c
               IF cl_null(l_pmn.pmn02) OR l_pmn.pmn02 = 0 THEN
                  LET l_pmn.pmn02 = 1
               END IF
 
               LET l_pmn.pmn04 = b_pnx.pnx07
               SELECT ima02 INTO l_pmn.pmn041
                 FROM ima_file
                WHERE ima01 = l_pmn.pmn04
               LET l_pmn.pmn07 = b_pny.pny17
               SELECT ima25 INTO l_pmn.pmn08
                 FROM ima_file
                WHERE ima01 = l_pmn.pmn04
               LET l_pmn.pmn09 = b_pny.pny18
               LET l_pmn.pmn11 = "N"
               #LET l_pmn.pmn13 = 0 
               #MOD-D70165 mark begin--------
               #MOD-C80116 add beg----
#               LET l_ima07=' '
#               SELECT ima07 INTO l_ima07 FROM ima_file
#                WHERE ima01=l_pmn.pmn04
#               CASE l_ima07
#                    WHEN 'A' LET l_pmn.pmn13=g_sma.sma341/100
#                    WHEN 'B' LET l_pmn.pmn13=g_sma.sma342/100
#                    WHEN 'C' LET l_pmn.pmn13=g_sma.sma343/100
#                    OTHERWISE LET l_pmn.pmn13=0
#               END CASE   	
               #MOD-C80116 add end----   
               #MOD-D70165 mark end--------   
               CALL s_overate(l_pmn.pmn04) RETURNING l_pmn.pmn13  #MOD-D70165 add         
               LET l_pmn.pmn14 = "Y"
               LET l_pmn.pmn15 = "Y"
               LET l_pmn.pmn16 = "2"   #狀 
               LET l_pmn.pmn20 = b_pny.pny19
               LET l_pmn.pmn24 = b_pny.pny05
               LET l_pmn.pmn25 = b_pny.pny06
               LET l_pmn.pmn30 = 0 
 
               CALL s_pow(b_pny.pny20,b_pnx.pnx07,b_pny.pny04,g_today)
                   RETURNING l_sta,l_pmn.pmn31
 
               IF cl_null(l_pmn.pmn31) THEN
                  LET l_pmn.pmn31 = 0
               END IF
 
               LET l_pmn.pmn31t = l_pmn.pmn31 * (1+l_pmm.pmm43/100) 
               LET l_pmn.pmn33 = b_pny.pny10
               LET l_pmn.pmn34 = b_pny.pny10
               LET l_pmn.pmn35 = b_pny.pny10
               LET l_pmn.pmn38 = "Y"
               LET l_pmn.pmn42 = 0
               LET l_pmn.pmn44 = l_pmn.pmn30 * l_pmm.pmm42 
               LET l_pmn.pmn50 = 0
               LET l_pmn.pmn51 = 0
               LET l_pmn.pmn53 = 0
               LET l_pmn.pmn55 = 0
               LET l_pmn.pmn57 = 0
               LET l_pmn.pmn58 = 0
               LET l_pmn.pmn61 = l_pmn.pmn04
               LET l_pmn.pmn62 = 1
               LET l_pmn.pmn63 = "N"
               LET l_pmn.pmn64 = "N"
               LET l_pmn.pmn65 = "2"
               LET l_pmn.pmn80 = b_pny.pny11
               LET l_pmn.pmn81 = b_pny.pny12
               LET l_pmn.pmn82 = b_pny.pny13
               LET l_pmn.pmn83 = b_pny.pny14
               LET l_pmn.pmn84 = b_pny.pny15
               LET l_pmn.pmn85 = b_pny.pny16
               LET l_pmn.pmn86 = b_pny.pny17
               LET l_pmn.pmn87 = b_pny.pny19
               LET l_pmn.pmn88 = l_pmn.pmn87 * l_pmn.pmn31 
               CALL cl_digcut(l_pmn.pmn88,g_azi04) RETURNING l_pmn.pmn88
               LET l_pmn.pmn88t = l_pmn.pmn87 * l_pmn.pmn31t 
               CALL cl_digcut(l_pmn.pmn88t,g_azi04) RETURNING l_pmn.pmn88t
               LET l_pmn.pmn90 = l_pmn.pmn31    #CHI-690043 add
               IF NOT (cl_null(l_pmn.pmn24) AND cl_null(l_pmn.pmn25)) THEN
                  SELECT pml930 INTO l_pmn.pmn930 FROM pml_file
                                                 WHERE pml01=l_pmn.pmn24
                                                   AND pml02=l_pmn.pmn25
                  IF SQLCA.sqlcode THEN
                     LET l_pmn.pmn930=NULL
                  END IF
               ELSE
                  LET l_pmn.pmn930=s_costcenter(l_pmm.pmm13)
               END IF
               IF cl_null(l_pmn.pmn01) THEN LET l_pmn.pmn01 = ' ' END IF
               IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF
               IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF    #TQC-9B0203
               LET l_pmn.pmnplant = l_plant  #FUN-980006 add
               LET l_pmn.pmnlegal = l_legal  #FUN-980006 add
              #LET l_sql = "INSERT INTO ",l_dbs_tra CLIPPED,"pmn_file ",  #FUN-980093    #FUN-A50102 mark
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'pmn_file'),       #FUN-A50102 
                           "(pmn01, pmn011,pmn02, pmn03, pmn04,",
                           "pmn041,pmn05, pmn06, pmn07, pmn08,",
                           "pmn09, pmn10, pmn11, pmn121,pmn122,",
                           "pmn123,pmn13, pmn14, pmn15, pmn16,",
                           "pmn18, pmn20, pmn23, pmn24, pmn25,",
                           "pmn30, pmn31, pmn31t,pmn32, pmn33,",
                           "pmn34, pmn35, pmn36, pmn37, pmn38,",
                           "pmn40, pmn41, pmn42, pmn43, pmn431,",
                           "pmn44, pmn45, pmn46, pmn50, pmn51,",
                           "pmn52, pmn53, pmn54, pmn55, pmn56,",
                           "pmn57, pmn58, pmn59, pmn60, pmn61,",
                           "pmn62, pmn63, pmn64, pmn65, ",      
                           "pmn67, pmn68, pmn69, pmn70, pmn71,",
                           "pmn80, pmn81, pmn82, pmn83, pmn84,",
                           "pmn85, pmn86, pmn87, pmn88, pmn88t,",
                           "pmn930,pmn401,pmn90, pmnplant,pmnlegal)", #FUN-980006 add pmnplant,pmnlegal
                           " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                           "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                           "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                           "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?)"  #FUN-980006 add ?,?
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
               CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING  l_sql      #FUN-A50102
               PREPARE ins_b_pmn FROM l_sql
               EXECUTE ins_b_pmn USING l_pmn.pmn01,l_pmn.pmn011,l_pmn.pmn02,l_pmn.pmn03,l_pmn.pmn04,
                                     l_pmn.pmn041,l_pmn.pmn05,l_pmn.pmn06,l_pmn.pmn07,l_pmn.pmn08,
                                     l_pmn.pmn09,l_pmn.pmn10,l_pmn.pmn11,l_pmn.pmn121,l_pmn.pmn122,
                                     l_pmn.pmn123,l_pmn.pmn13,l_pmn.pmn14,l_pmn.pmn15,l_pmn.pmn16,
                                     l_pmn.pmn18,l_pmn.pmn20,l_pmn.pmn23,l_pmn.pmn24,l_pmn.pmn25,
                                     l_pmn.pmn30,l_pmn.pmn31,l_pmn.pmn31t,l_pmn.pmn32,l_pmn.pmn33,
                                     l_pmn.pmn34,l_pmn.pmn35,l_pmn.pmn36,l_pmn.pmn37,l_pmn.pmn38,
                                     l_pmn.pmn40,l_pmn.pmn41,l_pmn.pmn42,l_pmn.pmn43,l_pmn.pmn431,
                                     l_pmn.pmn44,l_pmn.pmn45,l_pmn.pmn46,l_pmn.pmn50,l_pmn.pmn51,
                                     l_pmn.pmn52,l_pmn.pmn53,l_pmn.pmn54,l_pmn.pmn55,l_pmn.pmn56,
                                     l_pmn.pmn57,l_pmn.pmn58,l_pmn.pmn59,l_pmn.pmn60,l_pmn.pmn61,
                                     l_pmn.pmn62,l_pmn.pmn63,l_pmn.pmn64,l_pmn.pmn65,  #No.FUN-840006 l_pmn.pmn65之后去掉l_pmn.pmn66
                                     l_pmn.pmn67,l_pmn.pmn68,l_pmn.pmn69,l_pmn.pmn70,l_pmn.pmn71,
                                     l_pmn.pmn80,l_pmn.pmn81,l_pmn.pmn82,l_pmn.pmn83,l_pmn.pmn84,
                                     l_pmn.pmn85,l_pmn.pmn86,l_pmn.pmn87,l_pmn.pmn88,l_pmn.pmn88t,
                                     l_pmn.pmn930,l_pmn.pmn401,l_pmn.pmn90,l_pmn.pmnplant,l_pmn.pmnlegal  #FUN-980006 add pmnplant,pmnlegal
 
               IF STATUS THEN
                  IF g_bgerr THEN
                     LET g_showmsg = l_pmn.pmn01,"/",l_pmn.pmn02
                     CALL s_errmsg("pmn01,pmn02",g_showmsg,"ins pmn error",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","pmn_file",l_pmn.pmn01,l_pmn.pmn02,SQLCA.sqlcode,"","ins pmn error",1)
                  END IF
                  LET g_success = "N"
               ELSE
                  IF NOT s_industry('std') THEN
                     INITIALIZE l_pmni.* TO NULL
                     LET l_pmni.pmni01 = l_pmn.pmn01
                     LET l_pmni.pmni02 = l_pmn.pmn02
                     IF NOT s_ins_pmni(l_pmni.*,'') THEN
                        LET g_success = 'N'
                     END IF
                  END IF
               END IF
            IF g_success = 'Y' THEN
               INSERT INTO t511_tmp VALUES(g_pny[g_i].pny07,g_pny[g_i].pny08,g_pny[g_i].pny09,
                                           g_pny[g_i].pny10,g_pny[g_i].pny20,g_pny[g_i].pny24) 
            END IF
 
         IF NOT cl_null(g_pny24[l_i].pny24) THEN #No.FUN-960011 shi add
         UPDATE pny_file SET pny21 = l_pmn.pmn01,
                             pny22 = l_pmn.pmn02
          WHERE pny01 = b_pny.pny01
            AND pny02 = b_pny.pny02
            AND pny03 = b_pny.pny03
            AND pny04 = b_pny.pny04
            AND pny05 = b_pny.pny05
            AND pny06 = b_pny.pny06
            AND pny07 = b_pny.pny07
            AND pny08 = b_pny.pny08
            AND pny09 = b_pny.pny09
            AND pny10 = b_pny.pny10
            AND pny20 = b_pny.pny20
            AND pny24 = g_pny24[l_i].pny24
         ELSE
            UPDATE pny_file SET pny21 = l_pmn.pmn01,
                                pny22 = l_pmn.pmn02
             WHERE pny01 = b_pny.pny01 
               AND pny02 = b_pny.pny02
               AND pny03 = b_pny.pny03
               AND pny04 = b_pny.pny04
               AND pny05 = b_pny.pny05
               AND pny06 = b_pny.pny06
               AND pny07 = b_pny.pny07
               AND pny08 = b_pny.pny08
               AND pny09 = b_pny.pny09
               AND pny10 = b_pny.pny10
               AND pny20 = b_pny.pny20
               AND pny24 IS NULL
         END IF
         IF STATUS THEN
            IF g_bgerr THEN
               CALL s_errmsg("pny01",b_pny.pny01,"upd pny err",SQLCA.sqlcode,1) #No.FUN-960011
            ELSE
               CALL cl_err3("upd","pny_file",b_pny.pny01,"",SQLCA.sqlcode,"","upd pny err",1) #No.FUN-960011
            END IF
            LET g_success = "N"
         END IF
         LET g_pny21[l_i].pny21 = l_pmn.pmn01    #TQC-C20001
         LET g_pny21[l_i].pny22 = l_pmn.pmn02    #TQC-C20001
 
         SELECT pml21 INTO l_pml21 FROM pml_file      #TQC-760093
          WHERE pml01 = b_pny.pny05
            AND pml02 = b_pny.pny06
     
         IF cl_null(l_pml21) THEN
            LET l_pml21 = 0 
         END IF
 
         LET l_pml21 = l_pml21 + b_pny.pny19  #No.FUN-960011 shi
 
        #LET l_sql ="UPDATE ",l_dbs_tra CLIPPED,"pml_file",  #FUN-980093      #FUN-A50102 mark
         LET l_sql ="UPDATE ",cl_get_target_table(l_plant,'pml_file'),        #FUN-A50102
             "  SET pml21=? ",       #TQC-760093
             " WHERE pml01 = ? ",
             "   AND pml02 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-980093
         PREPARE upd_pml FROM l_sql 
         EXECUTE upd_pml USING l_pml21,b_pny.pny05,b_pny.pny06                #No.FUN-960011 shi
 
         IF STATUS THEN
            IF g_bgerr THEN
               LET g_showmsg = b_pny.pny05,"/",b_pny.pny06  #No.FUN-960011
               CALL s_errmsg("pml01,pml02",g_showmsg,"upd pml err",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","pml_file",b_pny.pny05,b_pny.pny06,SQLCA.sqlcode,"","upd pml err",1) #No.FUN-960011
            END IF
            LET g_success = "N"
         END IF
 
         UPDATE pnx_file SET pnx20 = pnx20+b_pny.pny19
          WHERE pnx01 = b_pny.pny01
            AND pnx02 = b_pny.pny02
            AND pnx03 = b_pny.pny03
            AND pnx04 = b_pny.pny04
            AND pnx05 = b_pny.pny05
            AND pnx06 = b_pny.pny06
         IF STATUS THEN
            IF g_bgerr THEN
               LET g_showmsg = b_pny.pny01,"/",b_pny.pny02,"/",b_pny.pny03,"/",b_pny.pny04,"/",b_pny.pny05,"/",b_pny.pny06 #No.FUN-960011
               CALL s_errmsg("pnx01,pnx02,pnx03,pnx04,pnx05,pnx06",g_showmsg,"upd pnx err",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","pnx_file",b_pny.pny01,b_pny.pny02,SQLCA.sqlcode,"","upd pnx err",1) #No.FUN-960011
            END IF
            LET g_success = "N"
         END IF
        END FOR     #No.FUN-960011 shi add
 
         SELECT SUM(pmn88),SUM(pmn88t) INTO l_pmm.pmm40,l_pmm.pmm40t
           FROM pmn_file
          WHERE pmn01 = l_pmm.pmm01
         IF cl_null(l_pmm.pmm40) THEN
            LET l_pmm.pmm40 = 0 
         END IF
         IF cl_null(l_pmm.pmm40t) THEN
            LET l_pmm.pmm40t = 0 
         END IF
         CALL cl_digcut(l_pmm.pmm40,g_azi04) RETURNING l_pmm.pmm40
         CALL cl_digcut(l_pmm.pmm40t,g_azi04) RETURNING l_pmm.pmm40t
 
        #LET l_sql ="UPDATE ",l_dbs_tra CLIPPED,"pmm_file",  #FUN-980093       #FUN-A50102 mark
         LET l_sql ="UPDATE ",cl_get_target_table(l_plant,'pmm_file'),         #FUN-A50102 
             "  SET pmm40=?,pmm40t=? ",
             " WHERE pmm01 = ? "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-980093
         PREPARE upd_pmm FROM l_sql 
         EXECUTE upd_pmm USING l_pmm.pmm40,l_pmm.pmm40t,l_pmm.pmm01
 
      END IF
    END IF                 #FUN-960011
   END FOR
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
   CALL s_showmsg()       #No.FUN-710030
   IF g_success = "Y" THEN
      COMMIT WORK
      #TQC-C20001 add---------------------------------
      FOR l_i = 1 TO g_rec_b
         LET g_pny[l_i].pny21 = g_pny21[l_i].pny21
         LET g_pny[l_i].pny22 = g_pny21[l_i].pny22
      END FOR
      #TQC-C20001 add end-----------------------------
      IF g_carry.getLength() > 0 THEN
         FOR g_i = 1 TO g_carry.getLength()
             IF cl_null(g_carry[g_i].azp03)   THEN
                CONTINUE FOR 
             END IF
             CALL cl_ins_del_sid(2,'') #FUN-980030           #No.FUN-980025
             CLOSE DATABASE 
             DATABASE g_carry[g_i].azp03 
             CALL cl_ins_del_sid(1,l_pnx.pnx04) #FUN-980030  #No.FUN-980025
             LET g_msg = " pmm01 ='",g_carry[g_i].pmm01,"'"
            #CALL p801(g_msg,"A")        #No.FUN-A30056                         
             CALL p801(g_msg,"A",FALSE)  #No.FUN-A30056
             CALL cl_ins_del_sid(2,'') #FUN-980030           #No.FUN-980025
             CLOSE DATABASE
             DATABASE g_dbs
             CALL cl_ins_del_sid(1,g_plant) #FUN-980030      #No.FUN-980025
         END FOR
      ELSE
         CALL cl_err("","abm-019",1)
      END IF   #No.FUN-950096
   ELSE
      ROLLBACK WORK
      CALL cl_err("","abm-020",1)
   END IF
   CALL cl_msg(" ") #TQC-BB0126
 
END FUNCTION
 
FUNCTION t511_def_form()   
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
    END IF
 
    #使用多單位的單位管制方式-參考單位
    IF g_sma.sma122 ='2' THEN 
       #--單身
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg #參考單位數量
       CALL cl_set_comp_att_text("pny16",g_msg CLIPPED)
       CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg #異動數量
       CALL cl_set_comp_att_text("pny13",g_msg CLIPPED)
    END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
