# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: axri110.4gl
# Descriptions...: 社福團體愛心碼維護作業
# Date & Author..: 12/04/26 By Lori(FUN-C40078)
# Modify.........: No.FUN-C50022 12/05/09 By pauline 作業一開啟時直接先將資料Query出來 
# Modify.........: No:FUN-D30032 13/04/02 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
   g_ooh01         LIKE ooh_file.ooh01,
   g_ooh02         LIKE ooh_file.ooh02,
   g_oohacti       LIKE ooh_file.oohacti,
   g_oohpos        LIKE ooh_FILE.oohpos,
   g_ooh01_t       LIKE ooh_file.ooh01,
   g_ooh02_t       LIKE ooh_file.ooh02,
   g_oohacti_t     LIKE ooh_file.oohacti,
   g_oohpos_t      LIKE ooh_FILE.oohpos,
   g_ooh           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
       ooh01          LIKE ooh_file.ooh01,
       ooh02          LIKE ooh_file.ooh02,
       oohacti        LIKE ooh_file.oohacti,
       oohpos         LIKE ooh_file.oohpos
                   END RECORD,
   g_ooh_t         RECORD                    #程式變數 (舊值)
       ooh01          LIKE ooh_file.ooh01,
       ooh02          LIKE ooh_file.ooh02,
       oohacti        LIKE ooh_file.oohacti,
       oohpos         LIKE ooh_file.oohpos
                   END RECORD,
   g_wc            string,
   g_sql           string,
   g_rec           LIKE type_file.num5,       #單身筆數 SMALLINT
   l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT SMALLINT

DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10       #INTEGER
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose #SMALLINT
DEFINE g_msg        LIKE type_file.chr1000     #VARCHAR(72)
DEFINE g_before_input_done  LIKE type_file.num5

DEFINE   g_curs_index   LIKE type_file.num10         #INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #INTEGER
DEFINE   g_jump         LIKE type_file.num10         #INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #SMALLINT

MAIN
   DEFINE p_row      LIKE type_file.num5,         #No.FUN-680123  SMALLINT
          p_col      LIKE type_file.num5          #No.FUN-680123  SMALLINT

   OPTIONS                                          #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                                  #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
      RETURNING g_time    

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW i110_w AT p_row,p_col
          WITH FORM "axr/42f/axri110"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL i110_b_fill(" 1=1")   #FUN-C50022 add
   CALL i110_menu()
   CLOSE WINDOW i110_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
        RETURNING g_time
END MAIN

FUNCTION i110_menu()
   WHILE TRUE
      CALL i110_bp("G")
      CASE g_action_choice
        #WHEN "insert"
        #   IF cl_chk_act_auth() THEN
        #      CALL i110_a()
        #   END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i110_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i110_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_ooh),'','')
            END IF
         WHEN "related_document"           #相關文件
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_ooh[l_ac].ooh01 IS NOT NULL THEN
                  LET g_doc.column1 = "ooh01"
                  LET g_doc.value1 = g_ooh[l_ac].ooh01
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i110_q()
   CALL i110_b_askkey()
END FUNCTION

FUNCTION i110_b()
   DEFINE l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT
       l_n             LIKE type_file.num5,      #檢查重複用
       l_lock_sw       LIKE type_file.chr1,      #單身鎖住否
       p_cmd           LIKE type_file.chr1,      #處理狀態
       l_possible      LIKE type_file.num5,      #用來設定判斷重複的可能性
       l_allow_insert  LIKE type_file.chr1,      #可新增否
       l_allow_delete  LIKE type_file.chr1       #可刪除否

   IF s_shut(0) THEN RETURN END IF

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   CALL cl_opmsg('b')

   LET g_forupd_sql = " SELECT ooh01,ooh02,oohacti,oohpos",
                      "   FROM ooh_file",
                      "  WHERE ooh01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_ooh WITHOUT DEFAULTS FROM s_ooh.*
      ATTRIBUTE (COUNT=g_rec,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec >= l_ac THEN
            LET p_cmd='u'
            LET  g_before_input_done = FALSE
            LET  g_before_input_done = TRUE
            BEGIN WORK
            LET p_cmd='u'
            LET g_ooh_t.* = g_ooh[l_ac].*  #BACKUP
            OPEN i110_bcl USING g_ooh_t.ooh01
            IF STATUS THEN
               CALL cl_err("OPEN i110_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i110_bcl INTO g_ooh[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ooh_t.ooh01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET  g_before_input_done = FALSE
         LET  g_before_input_done = TRUE
         INITIALIZE g_ooh[l_ac].* TO NULL
         LET g_ooh[l_ac].oohacti = 'Y'
         LET g_ooh[l_ac].oohpos = '1'
         LET g_ooh_t.* = g_ooh[l_ac].*     #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD ooh01

      AFTER FIELD ooh01                    #check 編號是否重複
         IF g_ooh[l_ac].ooh01 != g_ooh_t.ooh01 OR
            (g_ooh[l_ac].ooh01 IS NOT NULL AND g_ooh_t.ooh01 IS NULL) THEN
            SELECT count(*) INTO l_n FROM ooh_file
             WHERE ooh01 = g_ooh[l_ac].ooh01
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_ooh[l_ac].ooh01 = g_ooh_t.ooh01
               NEXT FIELD ooh01
            END IF
         END IF

      AFTER FIELD ooh02
         IF cl_null(g_ooh[l_ac].ooh02) THEN
            LET g_ooh[l_ac].ooh02 = g_ooh_t.ooh02
            NEXT FIELD ooh02
         END IF

      AFTER FIELD oohacti
         IF cl_null(g_ooh[l_ac].oohacti) THEN
            LET g_ooh[l_ac].oohacti = g_ooh_t.oohacti
            NEXT FIELD oohacti
         END IF

      AFTER FIELD oohpos
         IF cl_null(g_ooh[l_ac].oohpos) THEN
            LET g_ooh[l_ac].oohpos = g_ooh_t.oohpos
            NEXT FIELD oohpos
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_ooh_t.ooh01 IS NOT NULL THEN
            IF g_ooh[l_ac].oohpos = '1' OR (g_ooh[l_ac].oohpos = '3' AND g_ooh[l_ac].oohacti = 'N') THEN

               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF

               INITIALIZE g_doc.* TO NULL
               LET g_doc.column1 = "ooh01"
               LET g_doc.value1 = g_ooh[l_ac].ooh01
               CALL cl_del_doc()

               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF

               DELETE FROM ooh_file
                WHERE ooh01 = g_ooh_t.ooh01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","ooh_file",g_ooh_t.ooh01,"",SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec=g_rec-1
               DISPLAY g_rec TO FORMONLY.cn2
               COMMIT WORK
            ELSE
               CALL cl_err('', 'axr-171', 1)
               CANCEL DELETE
            END IF
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ooh[l_ac].* = g_ooh_t.*
            CLOSE i110_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF

         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ooh[l_ac].ooh01,-263,1)
            LET g_ooh[l_ac].* = g_ooh_t.*
         ELSE
            IF g_ooh[l_ac].oohpos = '3' THEN
               LET g_ooh[l_ac].oohpos = '2'
            END IF

            UPDATE ooh_file SET ooh01   = g_ooh[l_ac].ooh01,
                                ooh02   = g_ooh[l_ac].ooh02,
                                oohacti = g_ooh[l_ac].oohacti,
                                oohpos  = g_ooh[l_ac].oohpos
             WHERE ooh01 = g_ooh_t.ooh01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ooh_file",g_ooh_t.ooh01,"",SQLCA.sqlcode,"","",1)
               LET g_ooh[l_ac].* = g_ooh_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ooh[l_ac].* = g_ooh_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_ooh.deleteElement(l_ac)
               IF g_rec != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i110_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i110_bcl
         COMMIT WORK

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i110_bcl
         END IF
         INSERT INTO ooh_file(ooh01,ooh02,oohacti,oohpos)
                       VALUES(g_ooh[l_ac].ooh01,g_ooh[l_ac].ooh02
                             ,g_ooh[l_ac].oohacti,g_ooh[l_ac].oohpos)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ooh_file",g_ooh[l_ac].ooh01,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec = g_rec + 1
            DISPLAY g_rec TO FORMONLY.cn2
         END IF

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(giq01) AND l_ac > 1 THEN
            LET g_ooh[l_ac].* = g_ooh[l_ac-1].*
            NEXT FIELD giq01
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

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
   END INPUT

   CLOSE i110_bcl
   COMMIT WORK
END FUNCTION

FUNCTION i110_b_askkey()
            
   CLEAR FORM
   CALL g_ooh.clear()
      
   CONSTRUCT g_wc ON ooh01,ooh02,oohacti,oohpos
        FROM s_ooh[1].ooh01,s_ooh[1].ooh02,s_ooh[1].oohacti,s_ooh[1].oohpos
      BEFORE CONSTRUCT
        CALL cl_qbe_init()

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

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF

   CALL i110_b_fill(g_wc)

END FUNCTION

FUNCTION i110_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2    LIKE type_file.chr1000
DEFINE l_cmd    LIKE type_file.chr1000

   LET g_sql = "SELECT ooh01,ooh02,oohacti,oohpos ",
               " FROM ooh_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY ooh01"
   PREPARE i110_pb FROM g_sql
   DECLARE ooh_curs CURSOR FOR i110_pb

   CALL g_ooh.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"

   FOREACH ooh_curs INTO g_ooh[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_ooh.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec = g_cnt-1
   DISPLAY g_rec TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION i110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ooh TO s_ooh.* ATTRIBUTE(COUNT=g_rec)

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
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

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

       ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
#FUN-C40078
