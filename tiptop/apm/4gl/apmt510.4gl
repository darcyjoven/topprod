# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmt510.4gl
# Descriptions...: 集團採購底稿分配作業
# Date & Author..: No.FUN-630040 06/03/20 By Nicola
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-6A0162 06/11/07 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: NO.FUN-670007 06/11/30 by yiting poz04/poz05己無作用
# Modify.........: No.TQC-710033 07/03/29 By Mandy 多單位畫面標準寫法調整
# Modify.........: No.TQC-730114 07/03/29 By Nicola 類別取資料時取錯  
# Modify.........: No.TQC-730119 07/03/30 By Nicola pny24應為最終供應商
# Modify.........: No.FUN-950096 09/05/25 By Nicola pny07增加3.自行採購
# Modify.........: No.MOD-960016 09/07/07 By Smapmin 調撥時,流程代碼未預設 
#                                                    apm-298-->axm-298
# Modify.........: No.FUN-980006 09/08/14 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pnx   DYNAMIC ARRAY OF RECORD
                  pnx03     LIKE pnx_file.pnx03,
                  pnx04     LIKE pnx_file.pnx04,
                  azp02     LIKE azp_file.azp02,
                  pnx05     LIKE pnx_file.pnx05,
                  pnx06     LIKE pnx_file.pnx06,
                  pnx07     LIKE pnx_file.pnx07,
                  ima02     LIKE ima_file.ima02,
                  pnx08     LIKE pnx_file.pnx08,
                  pnx09     LIKE pnx_file.pnx09,
                  pnx13     LIKE pnx_file.pnx13,
                  pnx15     LIKE pnx_file.pnx15,
                  pnx10     LIKE pnx_file.pnx10,
                  pnx12     LIKE pnx_file.pnx12,
                  pnx16     LIKE pnx_file.pnx16,
                  pnx18     LIKE pnx_file.pnx18,
                  pnx20     LIKE pnx_file.pnx20
               END RECORD,
       g_pnx_t RECORD
                  pnx03     LIKE pnx_file.pnx03,
                  pnx04     LIKE pnx_file.pnx04,
                  azp02     LIKE azp_file.azp02,
                  pnx05     LIKE pnx_file.pnx05,
                  pnx06     LIKE pnx_file.pnx06,
                  pnx07     LIKE pnx_file.pnx07,
                  ima02     LIKE ima_file.ima02,
                  pnx08     LIKE pnx_file.pnx08,
                  pnx09     LIKE pnx_file.pnx09,
                  pnx13     LIKE pnx_file.pnx13,
                  pnx15     LIKE pnx_file.pnx15,
                  pnx10     LIKE pnx_file.pnx10,
                  pnx12     LIKE pnx_file.pnx12,
                  pnx16     LIKE pnx_file.pnx16,
                  pnx18     LIKE pnx_file.pnx18,
                  pnx20     LIKE pnx_file.pnx20
               END RECORD,
       g_pny   DYNAMIC ARRAY OF RECORD
                  pny07     LIKE pny_file.pny07,
                  pny08     LIKE pny_file.pny08,
                  azp02_1   LIKE azp_file.azp02,
                  pny09     LIKE pny_file.pny09,
                  azp02_2   LIKE azp_file.azp02,
                  pny10     LIKE pny_file.pny10,
                  pny14     LIKE pny_file.pny14,
                  pny15     LIKE pny_file.pny15,
                  pny16     LIKE pny_file.pny16,
                  pny11     LIKE pny_file.pny11,
                  pny12     LIKE pny_file.pny12,
                  pny13     LIKE pny_file.pny13,
                  pny17     LIKE pny_file.pny17,
                  pny18     LIKE pny_file.pny18,
                  pny19     LIKE pny_file.pny19,
                  pny20     LIKE pny_file.pny20,
                  pny24     LIKE pny_file.pny24,
                  pny21     LIKE pny_file.pny21,
                  pny22     LIKE pny_file.pny22
               END RECORD,
       g_pny_t RECORD
                  pny07     LIKE pny_file.pny07,
                  pny08     LIKE pny_file.pny08,
                  azp02_1   LIKE azp_file.azp02,
                  pny09     LIKE pny_file.pny09,
                  azp02_2   LIKE azp_file.azp02,
                  pny10     LIKE pny_file.pny10,
                  pny14     LIKE pny_file.pny14,
                  pny15     LIKE pny_file.pny15,
                  pny16     LIKE pny_file.pny16,
                  pny11     LIKE pny_file.pny11,
                  pny12     LIKE pny_file.pny12,
                  pny13     LIKE pny_file.pny13,
                  pny17     LIKE pny_file.pny17,
                  pny18     LIKE pny_file.pny18,
                  pny19     LIKE pny_file.pny19,
                  pny20     LIKE pny_file.pny20,
                  pny24     LIKE pny_file.pny24,
                  pny21     LIKE pny_file.pny21,
                  pny22     LIKE pny_file.pny22
               END RECORD,
       g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,         #No.FUN-680136 SMALLINT
       g_rec_b1       LIKE type_file.num5,         #No.FUN-680136 SMALLINT
       l_ac1          LIKE type_file.num5,         #No.FUN-680136 SMALLINT
       l_ac1_t        LIKE type_file.num5,         #No.FUN-680136 SMALLINT
       l_ac           LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE g_pnx01        LIKE pnx_file.pnx01
DEFINE g_pnx02        LIKE pnx_file.pnx02
DEFINE g_pnx03        LIKE pnx_file.pnx03
DEFINE g_geu02        LIKE geu_file.geu02
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done   STRING
DEFINE g_ima906       LIKE ima_file.ima906
DEFINE li_result      LIKE type_file.num5          #No.FUN-680136 SMALLINT
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
 
   OPEN WINDOW t510_w WITH FORM "apm/42f/apmt510"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL t510_def_form()   #TQC-710033 add
 
   CALL t510_menu()
 
   CLOSE WINDOW t510_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t510_menu()
 
   WHILE TRUE
      CALL t510_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t510_q()
            END IF
         WHEN "distributed_detail"
            IF cl_chk_act_auth() THEN
               CALL t510_b()
            ELSE
               LET g_action_choice = NULL
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
             IF g_pnx01 IS NOT NULL THEN
                LET g_doc.column1 = "pnx01"
                LET g_doc.column2 = "pnx02"
                LET g_doc.column3 = "pnx03"
                LET g_doc.value1 = g_pnx01
                LET g_doc.value2 = g_pnx02
                LET g_doc.value3 = g_pnx03
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0162-------add--------end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t510_q()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
 
   CLEAR FORM
   CALL g_pnx.clear()
   LET g_pnx02 = "1"
 
   CALL cl_set_head_visible("group01","YES")           #No.FUN-6B0032
   INPUT g_pnx01,g_pnx02,g_pnx03 WITHOUT DEFAULTS FROM pnx01,pnx02,pnx3 
 
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD pnx01
         IF cl_null(g_pnx01) THEN
            CALL cl_err(g_pnx01,"aap-099",0)
            NEXT FIELD pnx01
         END IF
         SELECT geu02 INTO g_geu02 FROM geu_file
          WHERE geu01 = g_pnx01
            AND geu00 = "4"
         IF STATUS THEN
#           CALL cl_err(g_pnx01,"anm-027",0)   #No.FUN-660129
            CALL cl_err3("sel","geu_file",g_pnx01,"","anm_027","","",1)  #No.FUN-660129
            NEXT FIELD pnx01
         END IF
         DISPLAY g_geu02 TO geu02
 
      AFTER FIELD pnx02
         IF cl_null(g_pnx02) THEN
            CALL cl_err(g_pnx02,"aap-099",0)
            NEXT FIELD pnx02
         END IF
         IF g_pnx02 = "1" THEN
            CALL cl_set_comp_entry("pnx3",FALSE)
            CALL cl_set_comp_visible("pnx05",FALSE)
         ELSE
            CALL cl_set_comp_entry("pnx3",TRUE)
            CALL cl_set_comp_visible("pnx05",TRUE)
         END IF
 
      AFTER FIELD pnx3
         IF cl_null(g_pnx03) AND g_pnx02 = "2" THEN
            CALL cl_err(g_pnx03,"aap-099",0)
            NEXT FIELD pnx3
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pnx01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_geu"
               LET g_qryparam.arg1 = "4"
               LET g_qryparam.default1 = g_pnx01
               CALL cl_create_qry() RETURNING g_pnx01
               DISPLAY g_pnx01 TO pnx01
               NEXT FIELD pnx01
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
 
   CONSTRUCT g_wc2 ON pnx03,pnx04,pnx05,pnx07,pnx08,pnx09
                 FROM s_pnx[1].pnx03,s_pnx[1].pnx04,s_pnx[1].pnx05,
                      s_pnx[1].pnx07,s_pnx[1].pnx08,s_pnx[1].pnx09
 
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
 
   CALL t510_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_pnx_t.* = g_pnx[l_ac1].*
   SELECT ima906 INTO g_ima906 
     FROM ima_file
    WHERE ima01 = g_pnx_t.pnx07
 
   CALL t510_b_fill()
 
END FUNCTION
 
FUNCTION t510_b()
   DEFINE l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
          l_n             LIKE type_file.num5,      #檢查重複用         #No.FUN-680136 SMALLINT
          l_lock_sw       LIKE type_file.chr1,      #單身鎖住否         #No.FUN-680136 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,      #處理狀態           #No.FUN-680136 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,      #可新增否           #No.FUN-680136 SMALLINT
          l_allow_delete  LIKE type_file.num5       #可刪除否           #No.FUN-680136 SMALLINT
   DEFINE l_oee09         LIKE oee_file.oee09
   DEFINE l_sumpny19      LIKE oee_file.oee083
   DEFINE l_poy04         LIKE pny_file.pny04
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg("b")
 
   IF cl_null(g_pnx_t.pnx03) THEN
      RETURN
   END IF
 
   LET g_forupd_sql = "SELECT pny07,pny08,'',pny09,'',pny10,pny14,",
                      "       pny15,pny16,pny11,pny12,pny13,pny17,",
                      "       pny18,pny19,pny20,pny24,pny21,pny22",
                      "  FROM pny_file",
                      "  WHERE pny01=? AND pny02=? AND pny03=?",
                      "   AND pny04=? AND pny05=? AND pny06=?",
                      "   AND pny07=? AND pny08=? AND pny09=?",
                    # "   AND pny10=? AND pny20=? AND pny24=? FOR UPDATE"
                      "   AND pny10=? AND pny20=? FOR UPDATE"   #No.TQC-730119
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t510_bcl CURSOR FROM g_forupd_sql
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pny WITHOUT DEFAULTS FROM s_pny.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ""
         LET l_ac = ARR_CURR()
         LET l_lock_sw = "N"
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET g_pny_t.* = g_pny[l_ac].*
            LET p_cmd = "u"
            BEGIN WORK
            OPEN t510_bcl USING g_pnx01,g_pnx02,g_pnx_t.pnx03,
                                g_pnx_t.pnx04,g_pnx_t.pnx05,g_pnx_t.pnx06,
                                g_pny_t.pny07,g_pny_t.pny08,g_pny_t.pny09,
                               #g_pny_t.pny10,g_pny_t.pny20,g_pny_t.pny24
                                g_pny_t.pny10,g_pny_t.pny20   #No.TQC-730119
            IF STATUS THEN
               CALL cl_err("OPEN t510_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t510_bcl INTO g_pny[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pny_t.pny07,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT azp02 INTO g_pny[l_ac].azp02_1 FROM azp_file
                   WHERE azp01 = g_pny[l_ac].pny08
                  SELECT azp02 INTO g_pny[l_ac].azp02_2 FROM azp_file
                   WHERE azp01 = g_pny[l_ac].pny09
               END IF
            END IF
         END IF
         CALL t510_set_entry()
         CALL t510_set_no_entry()
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = "a"
         INITIALIZE g_pny[l_ac].* TO NULL
         LET g_pny_t.* = g_pny[l_ac].*
         CALL t510_set_entry()
         CALL t510_set_no_entry()
         LET g_pny_t.pny19 = 0
         LET g_pny[l_ac].pny07 = "1"
         LET g_pny[l_ac].pny09 = g_pnx_t.pnx04
         SELECT azp02 INTO g_pny[l_ac].azp02_2 FROM azp_file
          WHERE azp01 = g_pny[l_ac].pny09
         LET g_pny[l_ac].pny10 = g_today
 
         SELECT SUM(pny19) INTO l_sumpny19
           FROM pny_file
          WHERE pny01 = g_pnx01
            AND pny02 = g_pnx02
            AND pny03 = g_pnx_t.pnx03
            AND pny04 = g_pnx_t.pnx04
            AND pny05 = g_pnx_t.pnx05
            AND pny06 = g_pnx_t.pnx06
 
         IF cl_null(l_sumpny19) THEN
            LET l_sumpny19 = 0
         END IF
 
         IF g_sma.sma115 = "Y" THEN
            SELECT pnx10,pnx11,pnx12,pnx13,pnx14,pnx15,pnx16,pnx17
              INTO g_pny[l_ac].pny11,g_pny[l_ac].pny12,g_pny[l_ac].pny13,
                   g_pny[l_ac].pny14,g_pny[l_ac].pny15,g_pny[l_ac].pny16,
                   g_pny[l_ac].pny17,g_pny[l_ac].pny18
              FROM pnx_file
             WHERE pnx01 = g_pnx01
               AND pnx02 = g_pnx02
               AND pnx03 = g_pnx_t.pnx03
               AND pnx04 = g_pnx_t.pnx04
               AND pnx05 = g_pnx_t.pnx05
               AND pnx06 = g_pnx_t.pnx06
 
            IF g_ima906 = "1" THEN
               LET g_pny[l_ac].pny19 = g_pnx_t.pnx18-l_sumpny19
               LET g_pny[l_ac].pny13 = g_pny[l_ac].pny19 / g_pny[l_ac].pny12
            ELSE
               LET g_pny[l_ac].pny13 = 0 
               LET g_pny[l_ac].pny16 = 0 
               LET g_pny[l_ac].pny19 = 0 
            END IF
         ELSE
            SELECT pnx16
              INTO g_pny[l_ac].pny17
              FROM pnx_file
             WHERE pnx01 = g_pnx01
               AND pnx02 = g_pnx02
               AND pnx03 = g_pnx_t.pnx03
               AND pnx04 = g_pnx_t.pnx04
               AND pnx05 = g_pnx_t.pnx05
               AND pnx06 = g_pnx_t.pnx06
 
            LET g_pny[l_ac].pny19 = g_pnx_t.pnx18-l_sumpny19
         END IF
         NEXT FIELD pny07
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err("",9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_pny[l_ac].pny08) THEN
            LET g_pny[l_ac].pny08 = " "
         END IF
         CALL t510_keychk()
         IF g_cnt > 0 THEN
            CANCEL INSERT
            NEXT FIELD pny07
         END IF
         #-----No.FUN-950096-----
         IF g_pny[l_ac].pny07='3' AND cl_null(g_pny[l_ac].pny20) THEN
            LET g_pny[l_ac].pny20 = ' ' 
         END IF
         #-----No.FUN-950096 END -----
         INSERT INTO pny_file(pny01,pny02,pny03,pny04,pny05,pny06, 
                              pny07,pny08,pny09,pny10,pny11,pny12,
                              pny13,pny14,pny15,pny16,pny17,pny18,
                              pny19,pny20,pny21,pny22,pny24,pnyplant,pnylegal) #FUN-980006 add pnyplant,pnylegal
                       VALUES(g_pnx01,g_pnx02,g_pnx_t.pnx03,
                              g_pnx_t.pnx04,g_pnx_t.pnx05,
                              g_pnx_t.pnx06,g_pny[l_ac].pny07,
                              g_pny[l_ac].pny08,g_pny[l_ac].pny09,
                              g_pny[l_ac].pny10,g_pny[l_ac].pny11,
                              g_pny[l_ac].pny12,g_pny[l_ac].pny13,
                              g_pny[l_ac].pny14,g_pny[l_ac].pny15,
                              g_pny[l_ac].pny16,g_pny[l_ac].pny17,
                              g_pny[l_ac].pny18,g_pny[l_ac].pny19,
                              g_pny[l_ac].pny20,g_pny[l_ac].pny21,
                              g_pny[l_ac].pny22,g_pny[l_ac].pny24,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pny[l_ac].pny07,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("ins","pny_file",g_pnx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CANCEL INSERT
         ELSE
            MESSAGE "INSERT O.K"
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD pny07
         IF NOT cl_null(g_pny[l_ac].pny07) THEN
            IF g_pny[l_ac].pny07 != g_pny_t.pny07 OR cl_null(g_pny_t.pny07) THEN
               CALL t510_keychk()
            END IF
         END IF
         CALL t510_set_entry()
         CALL t510_set_no_entry()
 
      AFTER FIELD pny08
         IF g_pny[l_ac].pny08 != g_pny_t.pny08 OR cl_null(g_pny_t.pny08) THEN
            IF NOT cl_null(g_pny[l_ac].pny08) THEN
               CALL t510_keychk()
               IF g_pny[l_ac].pny08 = g_pny[l_ac].pny09 THEN
                  CALL cl_err(g_pny[l_ac].pny08,"apm-101",0)
                  NEXT FIELD pny08
               END IF
               SELECT azp02 INTO g_pny[l_ac].azp02_1 FROM azp_file
                WHERE azp01 = g_pny[l_ac].pny08
               IF STATUS THEN
#                 CALL cl_err(g_pny[l_ac].pny08,"aap-025",0)   #No.FUN-660129
                  CALL cl_err3("sel","azp_file",g_pny[l_ac].pny08,"","aap-025","","",1)  #No.FUN-660129
                  NEXT FIELD pny08
               ELSE
                  DISPLAY BY NAME g_pny[l_ac].azp02_1
               END IF
            ELSE
               LET g_pny[l_ac].azp02_1 = ''
               DISPLAY BY NAME g_pny[l_ac].azp02_1
            END IF
         END IF
 
      AFTER FIELD pny10
         IF NOT cl_null(g_pny[l_ac].pny10) THEN
            IF g_pny[l_ac].pny10 != g_pny_t.pny10 OR cl_null(g_pny_t.pny10) THEN
               CALL t510_keychk()
            END IF
         END IF
 
      AFTER FIELD pny13
         IF cl_null(g_pny[l_ac].pny13) OR g_pny[l_ac].pny13 < 0 THEN
            CALL cl_err("","asf-745",0)
            NEXT FIELD pny13
         ELSE
            IF g_ima906 = "2" THEN
               LET g_pny[l_ac].pny19 = g_pny[l_ac].pny13 * g_pny[l_ac].pny12
                                     + g_pny[l_ac].pny16 * g_pny[l_ac].pny15
            ELSE
               LET g_pny[l_ac].pny19 = g_pny[l_ac].pny13 * g_pny[l_ac].pny12
            END IF
            DISPLAY BY NAME g_pny[l_ac].pny19
            SELECT SUM(pny19) INTO l_sumpny19
              FROM pny_file
             WHERE pny01 = g_pnx01
               AND pny02 = g_pnx02
               AND pny03 = g_pnx_t.pnx03
               AND pny04 = g_pnx_t.pnx04
               AND pny05 = g_pnx_t.pnx05
               AND pny06 = g_pnx_t.pnx06
            IF cl_null(l_sumpny19) THEN
               LET l_sumpny19 = 0
            END IF
            IF g_pny[l_ac].pny19 > (g_pnx_t.pnx18
                                    -l_sumpny19+g_pny_t.pny18) THEN
               CALL cl_err("","mfg3528",0)
               NEXT FIELD pny13
            END IF
         END IF
 
      AFTER FIELD pny16
         IF cl_null(g_pny[l_ac].pny16) OR g_pny[l_ac].pny16 < 0 THEN
            CALL cl_err("","asf-745",0)
            NEXT FIELD pny16
         ELSE
            IF g_ima906 = "2" THEN
               LET g_pny[l_ac].pny19 = g_pny[l_ac].pny13 * g_pny[l_ac].pny12
                                     + g_pny[l_ac].pny16 * g_pny[l_ac].pny15
            ELSE
               LET g_pny[l_ac].pny19 = g_pny[l_ac].pny13 * g_pny[l_ac].pny12
            END IF
            DISPLAY BY NAME g_pny[l_ac].pny19
            SELECT SUM(pny19) INTO l_sumpny19
              FROM pny_file
             WHERE pny01 = g_pnx01
               AND pny02 = g_pnx02
               AND pny03 = g_pnx_t.pnx03
               AND pny04 = g_pnx_t.pnx04
               AND pny05 = g_pnx_t.pnx05
               AND pny06 = g_pnx_t.pnx06
            IF cl_null(l_sumpny19) THEN
               LET l_sumpny19 = 0
            END IF
            IF g_pny[l_ac].pny19 > (g_pnx_t.pnx18
                                    -l_sumpny19+g_pny_t.pny18) THEN
               CALL cl_err("","mfg3528",0)
               NEXT FIELD pny16
            END IF
         END IF
 
      AFTER FIELD pny19
         IF cl_null(g_pny[l_ac].pny19) OR g_pny[l_ac].pny19 <= 0 THEN
            CALL cl_err("","aap-022",0)
            NEXT FIELD pny19
         ELSE
            SELECT SUM(pny19) INTO l_sumpny19
              FROM pny_file
             WHERE pny01 = g_pnx01
               AND pny02 = g_pnx02
               AND pny03 = g_pnx_t.pnx03
               AND pny04 = g_pnx_t.pnx04
               AND pny05 = g_pnx_t.pnx05
               AND pny06 = g_pnx_t.pnx06
            IF cl_null(l_sumpny19) THEN
               LET l_sumpny19 = 0
            END IF
            IF g_pny[l_ac].pny19 > (g_pnx_t.pnx18
                                    -l_sumpny19+g_pny_t.pny19) THEN
               CALL cl_err("","mfg3528",0)
               NEXT FIELD pny19
            END IF
         END IF
 
      #-----No.TQC-730119-----
      BEFORE FIELD pny20
         IF cl_null(g_pny[l_ac].pny20) THEN
            IF g_pny[l_ac].pny07 = "2" THEN   #No.TQC-730114
               SELECT pnv04 INTO g_pny[l_ac].pny20
                 FROM pnv_file
                WHERE pnv01 = g_pnx01
                  AND pnv02 = g_pnx_t.pnx04
            
      #        SELECT poy04 INTO g_pny[l_ac].pny24
      #          FROM poy_file
      #         WHERE poy01 = g_pny[l_ac].pny20
      #           AND poy02 = 1
            ELSE
               #SELECT pnw04 INTO g_pny[l_ac].pny20   #MOD-960016
               SELECT pnw05 INTO g_pny[l_ac].pny20   #MOD-960016
                 FROM pnw_file
                WHERE pnw01 = g_pnx01
                  AND pnw02 = g_pny[l_ac].pny08
                  #AND pnw02 = g_pny[l_ac].pny09   #MOD-960016
                  AND pnw03 = g_pny[l_ac].pny09   #MOD-960016
#NO.FUN-670007 start--\
      #        SELECT poy03 INTO g_pny[l_ac].pny24
      #          FROM poy_file
      #         WHERE poy01 = g_pny[l_ac].pny20
      #           AND poy02 = 0
            
#               SELECT poz04 INTO g_pny[l_ac].pny24
#                 FROM poz_file
#                WHERE poz01 = g_pny[l_ac].pny20
#NO.FUN-670007 end-----
            END IF
         END IF
      #-----No.TQC-730119-----
 
      AFTER FIELD pny20
         IF NOT cl_null(g_pny[l_ac].pny20) THEN
            IF g_pny[l_ac].pny20 != g_pny_t.pny20 OR cl_null(g_pny_t.pny20) THEN
               CALL t510_keychk()
              ##-----No.TQC-730119 Mark-----
#NO.FUN-670007 start---poz04/poz05己無作用 改抓poy_file資料
              #SELECT poy03 INTO g_pny[l_ac].pny24
              #  FROM poy_file,poz_file
              # WHERE poy01 = poz01
              #   AND poy01 = g_pny[l_ac].pny20
              #   AND poz00 = '2'
              #   AND poy02 = 0   #起始站
              #   AND poy04 = g_pny[l_ac].pny09
 
#             # SELECT poz04 INTO g_pny[l_ac].pny24
#             #   FROM poz_file
#             #  WHERE poz00 = "2"
#             #    AND poz05 = g_pny[l_ac].pny09
#             #    AND poz01 = g_pny[l_ac].pny20
#NO.FUN-670007 end------
              #IF STATUS THEN
#             #   CALL cl_err(g_pny[l_ac].pny20,"tri-006",0)   #No.FUN-660129
              #   #CALL cl_err3("sel","poz_file",g_pny[l_ac].pny20,"","tri-006","","",1)  #No.FUN-660129
              #   CALL cl_err3("sel","poy_file",g_pny[l_ac].pny20,"","tri-006","","",1)  #No.FUN-660129
              #   NEXT FIELD pny20
              #END IF
              #SELECT poy04 INTO l_poy04 FROM poy_file
              # WHERE poy02 = (SELECT MAX(poy02) FROM poy_file
              #                 WHERE poy01 = g_pny[l_ac].pny20
              #                 GROUP BY poy01)
              #   AND poy01 = g_pny[l_ac].pny20
              #IF l_poy04 <> g_pny[l_ac].pny08 THEN
              #   CALL cl_err("","apm-993",0)
              #   NEXT FIELD pny20
              #END IF
              ##-----No.TQC-730119 Mark END-----
            END IF
           ##-----No.TQC-730119 Mark-----
           #IF g_pny[l_ac].pny07 = "1" THEN
           #   SELECT poy04 INTO g_pny[l_ac].pny24
           #     FROM poy_file
           #    WHERE poy01 = g_pny[l_ac].pny20
           #      AND poy02 = 1
           #ELSE
#NO.FUN-670007 start--\
           #   SELECT poy03 INTO g_pny[l_ac].pny24
           #     FROM poy_file
           #    WHERE poy01 = g_pny[l_ac].pny20
           #      AND poy02 = 0
           #
#          #    SELECT poz04 INTO g_pny[l_ac].pny24
#          #      FROM poz_file
#          #     WHERE poz01 = g_pny[l_ac].pny20
#NO.FUN-670007 end-----
           #END IF
           ##-----No.TQC-730119 Mark END-----
         END IF
 
      AFTER FIELD pny24
         IF NOT cl_null(g_pny[l_ac].pny24) THEN
            IF g_pny[l_ac].pny24 != g_pny_t.pny24 OR cl_null(g_pny_t.pny24) THEN
               CALL t510_keychk()
               SELECT * FROM pmc_file
                WHERE pmc01 = g_pny[l_ac].pny24
               IF STATUS THEN
#                 CALL cl_err(g_pny[l_ac].pny24,"aap-000",0)   #No.FUN-660129
                  CALL cl_err3("sel","pmc_file",g_pny[l_ac].pny24,"","aap-000","","",1)  #No.FUN-660129
                  NEXT FIELD pny24
               END IF
            END IF
         END IF
 
      BEFORE DELETE
         IF g_pny_t.pny07 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM pny_file
             WHERE pny01 = g_pnx01
               AND pny02 = g_pnx02
               AND pny03 = g_pnx_t.pnx03
               AND pny04 = g_pnx_t.pnx04
               AND pny05 = g_pnx_t.pnx05
               AND pny06 = g_pnx_t.pnx06
               AND pny07 = g_pny_t.pny07
               AND pny08 = g_pny_t.pny08
               AND pny09 = g_pny_t.pny09
               AND pny10 = g_pny_t.pny10
               AND pny20 = g_pny_t.pny20
              #AND pny24 = g_pny_t.pny24   #No.TQC-730119
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_pny_t.pny07,SQLCA.sqlcode,0)   #No.FUN-660129
               CALL cl_err3("del","pny_file",g_pnx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            MESSAGE "Delete OK"
            CLOSE t510_bcl
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err("",9001,0)
            LET INT_FLAG = 0
            LET g_pny[l_ac].* = g_pny_t.*
            CLOSE t510_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF cl_null(g_pny[l_ac].pny08) THEN
            LET g_pny[l_ac].pny08 = " "
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err(g_pny[l_ac].pny07,-263,1)
            LET g_pny[l_ac].* = g_pny_t.*
         ELSE
            UPDATE pny_file SET pny07 = g_pny[l_ac].pny07,
                                pny08 = g_pny[l_ac].pny08,
                                pny09 = g_pny[l_ac].pny09,
                                pny10 = g_pny[l_ac].pny10,
                                pny11 = g_pny[l_ac].pny11,
                                pny12 = g_pny[l_ac].pny12,
                                pny13 = g_pny[l_ac].pny13,
                                pny14 = g_pny[l_ac].pny14,
                                pny15 = g_pny[l_ac].pny15,
                                pny16 = g_pny[l_ac].pny16,
                                pny17 = g_pny[l_ac].pny17,
                                pny18 = g_pny[l_ac].pny18,
                                pny19 = g_pny[l_ac].pny19,
                                pny20 = g_pny[l_ac].pny20,
                                pny24 = g_pny[l_ac].pny24
             WHERE pny01 = g_pnx01
               AND pny02 = g_pnx02
               AND pny03 = g_pnx_t.pnx03
               AND pny04 = g_pnx_t.pnx04
               AND pny05 = g_pnx_t.pnx05
               AND pny06 = g_pnx_t.pnx06
               AND pny07 = g_pny_t.pny07
               AND pny08 = g_pny_t.pny08
               AND pny09 = g_pny_t.pny09
               AND pny10 = g_pny_t.pny10
               AND pny20 = g_pny_t.pny20
             # AND pny24 = g_pny_t.pny24   #No.TQC-730119
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_pny[l_ac].pny07,SQLCA.sqlcode,0)   #No.FUN-660129
               CALL cl_err3("upd","pny_file",g_pnx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               LET g_pny[l_ac].* = g_pny_t.*
            ELSE
               MESSAGE "UPDATE O.K"
               CLOSE t510_bcl
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
      #  LET l_ac_t = l_ac   #FUN-D30034
         IF INT_FLAG THEN
            CALL cl_err("",9001,0)
            LET INT_FLAG = 0
            IF p_cmd = "u" THEN
               LET g_pny[l_ac].* = g_pny_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_pny.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE t510_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034
         CLOSE t510_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pny08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 = g_pny[l_ac].pny08
               CALL cl_create_qry() RETURNING g_pny[l_ac].pny08
               DISPLAY BY NAME g_pny[l_ac].pny08
               NEXT FIELD pny08
            WHEN INFIELD(pny20)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_poz2"
               LET g_qryparam.default1 = g_pny[l_ac].pny20
               LET g_qryparam.arg1 = "2"
               LET g_qryparam.arg2 = g_pny[l_ac].pny09
               CALL cl_create_qry() RETURNING g_pny[l_ac].pny20
               DISPLAY BY NAME g_pny[l_ac].pny20
               NEXT FIELD pny20
            WHEN INFIELD(pny24)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc"
               LET g_qryparam.default1 = g_pny[l_ac].pny24
               CALL cl_create_qry() RETURNING g_pny[l_ac].pny24
               DISPLAY BY NAME g_pny[l_ac].pny24
               NEXT FIELD pny24
         END CASE
 
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
 
   CLOSE t510_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t510_keychk()
 
   SELECT COUNT(*) INTO g_cnt FROM pny_file
    WHERE pny01 = g_pnx01
      AND pny02 = g_pnx02
      AND pny03 = g_pnx_t.pnx03
      AND pny04 = g_pnx_t.pnx04
      AND pny05 = g_pnx_t.pnx05
      AND pny06 = g_pnx_t.pnx06
      AND pny07 = g_pny[l_ac].pny07
      AND pny08 = g_pny[l_ac].pny08
      AND pny09 = g_pny[l_ac].pny09
      AND pny10 = g_pny[l_ac].pny10
      AND pny20 = g_pny[l_ac].pny20
     #AND pny24 = g_pny[l_ac].pny24   #No.TQC-730119
   IF g_cnt > 0 THEN
      CALL cl_err("","axm-298",0)   #MOD-960016 apm-298-->axm-298
   END IF
 
END FUNCTION
 
FUNCTION t510_b1_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   IF g_pnx02 = "1" THEN
      LET g_sql = "SELECT pnx03,pnx04,'',pnx05,pnx06,pnx07,'',pnx08,pnx09,",
                  "       pnx13,pnx15,pnx10,pnx12,pnx16,pnx18,pnx20",
                  "  FROM pnx_file",
                  " WHERE ",p_wc2 CLIPPED,
                  "   AND pnx01 = '",g_pnx01,"'",
                  "   AND pnx02 = '",g_pnx02,"'",
                  "   AND (pnx18-pnx20) > 0",
                  " ORDER BY pnx03"
   ELSE
      LET g_sql = "SELECT pnx03,pnx04,'',pnx05,pnx06,pnx07,'',pnx08,pnx09,",
                  "       pnx13,pnx15,pnx10,pnx12,pnx16,pnx18,pnx20",
                  "  FROM pnx_file",
                  " WHERE ",p_wc2 CLIPPED,
                  "   AND pnx01 = '",g_pnx01,"'",
                  "   AND pnx02 = '",g_pnx02,"'",
                  "   AND pnx03 = '",g_pnx03,"'",
                  "   AND pnx19 = 'N'",
                  " ORDER BY pnx03"
   END IF
 
   PREPARE t510_pb1 FROM g_sql
   DECLARE pnx_curs CURSOR FOR t510_pb1
  
   CALL g_pnx.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH pnx_curs INTO g_pnx[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT azp02 INTO g_pnx[g_cnt].azp02
        FROM azp_file
       WHERE azp01 = g_pnx[g_cnt].pnx04
 
      SELECT ima02 INTO g_pnx[g_cnt].ima02
        FROM ima_file
       WHERE ima01 = g_pnx[g_cnt].pnx07
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_pnx.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   DISPLAY g_rec_b1 TO FORMONLY.cn3
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t510_b_fill()
 
   LET g_sql = "SELECT pny07,pny08,'',pny09,'',pny10,pny14,pny15,pny16,pny11,",
               "       pny12,pny13,pny17,pny18,pny19,pny20,pny24,pny21,pny22",
               "  FROM pny_file",
               " WHERE pny01 = '",g_pnx01,"'",
               "   AND pny02 = '",g_pnx02,"'",
               "   AND pny03 = '",g_pnx_t.pnx03,"'",
               "   AND pny04 = '",g_pnx_t.pnx04,"'",
               "   AND pny05 = '",g_pnx_t.pnx05,"'",
               "   AND pny06 = '",g_pnx_t.pnx06,"'",
               " ORDER BY pny07"
 
   PREPARE t510_pb FROM g_sql
   DECLARE pny_curs CURSOR FOR t510_pb
  
   CALL g_pny.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH pny_curs INTO g_pny[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
      SELECT azp02 INTO g_pny[g_cnt].azp02_1 FROM azp_file
       WHERE azp01 = g_pny[g_cnt].pny08
 
      SELECT azp02 INTO g_pny[g_cnt].azp02_2 FROM azp_file
       WHERE azp01 = g_pny[g_cnt].pny09
 
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
 
FUNCTION t510_bp2()
 
   DISPLAY ARRAY g_pny TO s_pny.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
 
      ON ACTION controlg 
         CALL cl_cmdask()
 
   END DISPLAY
 
END FUNCTION
 
FUNCTION t510_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "distributed_detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_pnx TO s_pnx.* ATTRIBUTE(COUNT=g_rec_b1,KEEP CURRENT ROW)
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         IF l_ac1 = 0 THEN
            LET l_ac1 = 1
         END IF
         CALL cl_show_fld_cont()
         LET l_ac1_t = l_ac1
         LET g_pnx_t.* = g_pnx[l_ac1].*
         SELECT ima906 INTO g_ima906 
           FROM ima_file
          WHERE ima01 = g_pnx_t.pnx07
         CALL t510_b_fill()
         CALL t510_bp2()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION distributed_detail
         LET g_action_choice="distributed_detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL t510_def_form()   #TQC-710033 add
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
     #ON ACTION accept
     #   LET g_action_choice="distributed_detail"
     #   LET l_ac = ARR_CURR()
     #   EXIT DISPLAY
 
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
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t510_set_entry()
 
   IF g_sma.sma115 = "N" THEN
      CALL cl_set_comp_entry("pny07,pny08,pny10,pny19,pny20,pny24",TRUE)
   ELSE
      CALL cl_set_comp_entry("pny07,pny08,pny10,pny13,pny16,pny20,pny24",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t510_set_no_entry()
 
   IF NOT cl_null(g_pny[l_ac].pny21) THEN
      CALL cl_set_comp_entry("pny07,pny08,pny10,pny13,pny16,pny19,pny20,pny24",FALSE)
   END IF
 
   IF g_ima906 = "1" THEN
      CALL cl_set_comp_entry("pny16",FALSE)
   END IF
 
   IF g_pny[l_ac].pny07 = "1" THEN
      CALL cl_set_comp_entry("pny24",FALSE)
   END IF
 
   #-----No.FUN-950096-----
   IF g_pny[l_ac].pny07 = "3" THEN
      CALL cl_set_comp_entry("pny08,pny20",FALSE)
   END IF
   #-----No.FUN-950096 END-----
 
END FUNCTION
 
#-----TQC-710033---------add----str---
FUNCTION t510_def_form()   
    IF g_sma.sma115 = "N" THEN
       CALL cl_set_comp_visible("pny11,pny12,pny13",FALSE)
       CALL cl_set_comp_visible("pny14,pny15,pny16",FALSE)
       CALL cl_set_comp_visible("pny18",FALSE)
       CALL cl_set_comp_visible("pnx10,pnx12,pnx13,pnx15",FALSE)
       CALL cl_set_comp_entry("pny13,pny16",FALSE)
    ELSE
       CALL cl_set_comp_visible("pny12,pny15,pny18",FALSE)
       CALL cl_set_comp_entry("pny19",FALSE)
    END IF
    #使用多單位的單位管制方式-母子單位
    IF g_sma.sma122 ='1' THEN 
       #--單頭
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg #母單位
       CALL cl_set_comp_att_text("pnx13",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg #母單位數量
       CALL cl_set_comp_att_text("pnx15",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg #子單位
       CALL cl_set_comp_att_text("pnx10",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg #子單位數量
       CALL cl_set_comp_att_text("pnx12",g_msg CLIPPED)
       #--end
 
       #--單身
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg #母單位
       CALL cl_set_comp_att_text("pny14",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg #母單位數量
       CALL cl_set_comp_att_text("pny16",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg #子單位
       CALL cl_set_comp_att_text("pny11",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg #子單位數量
       CALL cl_set_comp_att_text("pny13",g_msg CLIPPED)
       #--end
    END IF
 
    #使用多單位的單位管制方式-參考單位
    IF g_sma.sma122 ='2' THEN 
       #--單頭
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg #參考單位
       CALL cl_set_comp_att_text("pnx13",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg #參考單位數量
       CALL cl_set_comp_att_text("pnx15",g_msg CLIPPED)
       CALL cl_getmsg('asm-359',g_lang) RETURNING g_msg #請購單位
       CALL cl_set_comp_att_text("pnx10",g_msg CLIPPED)
       CALL cl_getmsg('asm-360',g_lang) RETURNING g_msg #請購數量
       CALL cl_set_comp_att_text("pnx12",g_msg CLIPPED)
       #--end
 
       #--單身
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg #參考單位
       CALL cl_set_comp_att_text("pny14",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg #參考單位數量
       CALL cl_set_comp_att_text("pny16",g_msg CLIPPED)
       CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg #異動單位
       CALL cl_set_comp_att_text("pny11",g_msg CLIPPED)
       CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg #異動數量
       CALL cl_set_comp_att_text("pny13",g_msg CLIPPED)
       #--end
    END IF
END FUNCTION
#-----TQC-710033---------add----end---
