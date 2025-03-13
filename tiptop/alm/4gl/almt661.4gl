# Prog. Version..: '5.30.06-13.04.09(00005)'     #
#
# Pattern name...: almt661.4gl
# Descriptions...: 券規則變更設定作業
# Date & Author..: NO.FUN-CB0025 12/11/08 By naning
# Modify.........: No.FUN-CC0058 12/12/26 By xumeimei 调整收券规则逻辑
# Modify.........: No.FUN-D10117 13/01/31 By dongsz 收券規則設置作業規則類型改為4
# Modify.........: No.FUN-D30019 13/03/14 By baogc 逻辑调整
# Modify.........: No:CHI-D20015 13/03/28 By lixh1 整批修改update[確認]/[取消確認]動作時,要一併異動確認異動人員與確認異動日期


DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_lts         RECORD LIKE lts_file.*,
       g_lts_t       RECORD LIKE lts_file.*,
       g_lts01_t     LIKE lts_file.lts01,
       g_ltt         DYNAMIC ARRAY OF RECORD
          ltt03      LIKE ltt_file.ltt03,
          ltt03_desc LIKE ima_file.ima02,
          lttacti    LIKE ltt_file.lttacti
                     END RECORD,
       g_ltt_t       RECORD
          ltt03      LIKE ltt_file.ltt03,
          ltt03_desc LIKE ima_file.ima02,
          lttacti    LIKE ltt_file.lttacti
                     END RECORD,
       g_ltu         DYNAMIC ARRAY OF RECORD
          ltu03      LIKE ltu_file.ltu03,
          ltu03_desc LIKE ima_file.ima02,
          ltuacti    LIKE ltu_file.ltuacti
                     END RECORD,
       g_ltu_t       RECORD
          ltu03      LIKE ltu_file.ltu03,
          ltu03_desc LIKE ima_file.ima02,
          ltuacti    LIKE ltu_file.ltuacti
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_wc3         STRING,
       g_rec_b       LIKE type_file.num5,
       g_rec_b1      LIKE type_file.num5,
       l_ac          LIKE type_file.num5,
       l_ac1         LIKE type_file.num5
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_void              LIKE type_file.chr1
DEFINE g_b_flag            STRING
DEFINE g_lts021_o          LIKE lts_file.lts021
DEFINE g_flag2             LIKE type_file.chr1
DEFINE g_lpx03             LIKE lpx_file.lpx03
DEFINE g_lpx04             LIKE lpx_file.lpx04
DEFINE g_lts03             LIKE lts_file.lts03
DEFINE g_lts06             LIKE lts_file.lts06
DEFINE g_lts07             LIKE lts_file.lts07
DEFINE g_del1              LIKE type_file.chr1
DEFINE g_del2              LIKE type_file.chr1

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM lts_file WHERE lts01= ? AND lts02 = ? ",
                       "  AND lts021 = ? AND ltsplant = ? FOR UPDATE "
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

   DECLARE t661_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW t661_w WITH FORM "alm/42f/almt661"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   CALL t661_menu()
   CLOSE WINDOW t661_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t661_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM
   CALL g_ltt.clear()
   CALL g_ltu.clear()
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_lts.* TO NULL
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON lts01,lts02,lts021,
                             lts03,lts04,lts05,lts06,lts07,lts08,
                             lts09,lts10,ltsconf,ltsconu,ltscond,lts11,lts12,
                             ltsuser,ltsgrup,ltsoriu,ltsorig,ltscrat,ltsmodu,
                             ltsacti,ltsdate


         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(lts01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lts01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lts01
                  NEXT FIELD lts01
               WHEN INFIELD(lts02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lts02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lts02
                  NEXT FIELD lts02
               WHEN INFIELD(lts03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lts03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lts03
                  NEXT FIELD lts03
               WHEN INFIELD(ltsconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ltsconu"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ltsconu
                  NEXT FIELD ltsconu

               OTHERWISE EXIT CASE
            END CASE

         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT

      CONSTRUCT g_wc2 ON ltt03,lttacti
           FROM s_ltt[1].ltt03,s_ltt[1].lttacti

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION controlp
            CASE
               WHEN INFIELD(ltt03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ltt03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ltt03
                  NEXT FIELD ltt03
               OTHERWISE EXIT CASE
            END CASE
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT
      CONSTRUCT g_wc3 ON ltu03,ltuacti
           FROM s_ltu[1].ltu03,s_ltu[1].ltuacti

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION controlp
            CASE
               WHEN INFIELD(ltu03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ltu03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ltu03
                  NEXT FIELD ltu03
               OTHERWISE EXIT CASE
            END CASE
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT
      ON ACTION ACCEPT
         EXIT DIALOG
      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
   END DIALOG
   IF INT_FLAG THEN
      RETURN
   END IF
   #如果只有單頭下條件
   IF g_wc2 = " 1=1" AND g_wc3 = " 1=1" THEN
      LET g_sql = " SELECT * FROM lts_file ",
                  "  WHERE ltsplant = '",g_plant,"'",
                  "    AND ",g_wc CLIPPED

   END IF
   #如果只有單身一下條件
   IF g_wc2 <> " 1=1" AND g_wc3 = " 1=1" THEN
      LET g_sql = " SELECT * FROM lts_file,ltt_file ",
                  "  WHERE ltsplant = '",g_plant,"'",
                  "    AND lts01 = ltt01 AND lts02 = ltt02 AND lts021 = ltt021 ",
                  "    AND ",g_wc CLIPPED ,
                  "    AND ",g_wc2 CLIPPED
   END IF
   #如果只有單身二下條件
   IF g_wc2 = " 1=1" AND g_wc3 <> " 1=1" THEN
      LET g_sql = " SELECT * FROM lts_file,ltu_file ",
                  "  WHERE ltsplant = '",g_plant,"'",
                  "    AND lts01 = ltu01 AND lts02 = ltu02 AND lts021 = ltu021 ",
                  "    AND ",g_wc CLIPPED ,
                  "    AND ",g_wc3 CLIPPED
   END IF
   #如果兩個單身都下條件
   IF g_wc2 <> " 1=1" AND g_wc3 <> " 1=1" THEN
      LET g_sql = " SELECT * FROM lts_file,ltt_file,ltu_file ",
                  "  WHERE ltsplant = '",g_plant,"'",
                  "    AND lts01 = ltt01 AND lts02 = ltt02 AND lts021 = ltt021 ",
                  "    AND lts01 = ltu01 AND lts02 = ltu02 AND lts021 = ltu021 ",
                  "    AND ltt01 = ltu01 AND ltt02 = ltu02 AND ltt021 = ltu021  ",
                  "    AND ",g_wc CLIPPED ,
                  "    AND ",g_wc2 CLIPPED,
                  "    AND ",g_wc3 CLIPPED
   END IF
   PREPARE t661_prepare FROM g_sql
   DECLARE t661_cs SCROLL CURSOR WITH HOLD FOR t661_prepare
   #對應查出資料筆數
   IF g_wc2 = " 1=1" AND g_wc3 = " 1=1" THEN
      LET g_sql = " SELECT COUNT(*) FROM ( SELECT UNIQUE lts01,lts02,lts021,ltsplant FROM lts_file ",
                  "  WHERE ltsplant = '",g_plant,"'",
                  "    AND ",g_wc CLIPPED," )"

   END IF
   IF g_wc2 <> " 1=1" AND g_wc3 = " 1=1" THEN
      LET g_sql = " SELECT COUNT(*) FROM ( SELECT UNIQUE lts01,lts02,lts021,ltsplant FROM lts_file,ltt_file ",
                  "  WHERE ltsplant = '",g_plant,"'",
                  "    AND lts01 = ltt01 AND lts02 = ltt02 AND lts021 = ltt021 ",
                  "    AND ltsplant = lttplant ",
                  "    AND ",g_wc CLIPPED ,
                  "    AND ",g_wc2 CLIPPED," )"
   END IF
   IF g_wc2 = " 1=1" AND g_wc3 <> " 1=1" THEN
      LET g_sql = " SELECT COUNT(*) FROM ( SELECT UNIQUE lts01,lts02,lts021,ltsplant FROM lts_file,ltu_file ",
                  "  WHERE ltsplant = '",g_plant,"'",
                  "    AND lts01 = ltu01 AND lts02 = ltu02 AND lts021 = ltu021 ",
                  "    AND ltsplant = ltuplant ",
                  "    AND ",g_wc CLIPPED ,
                  "    AND ",g_wc3 CLIPPED," )"
   END IF
   IF g_wc2 <> " 1=1" AND g_wc3 <> " 1=1" THEN
      LET g_sql = " SELECT COUNT(*) FROM ( SELECT UNIQUE lts01,lts02,lts021,ltsplant FROM lts_file,ltt_file,ltu_file ",
                  "  WHERE ltsplant = '",g_plant,"'",
                  "    AND lts01 = ltt01 AND lts02 = ltt02 AND lts021 = ltt021 AND ltsplant = lttplant ",
                  "    AND lts01 = ltu01 AND lts02 = ltu02 AND lts021 = ltu021 AND ltsplant = ltuplant ",
                  "    AND ltt01 = ltu01 AND ltt02 = ltu02 AND ltt021 = ltu021 AND ltuplant = lttplant  ",
                  "    AND ",g_wc CLIPPED ,
                  "    AND ",g_wc2 CLIPPED,
                  "    AND ",g_wc3 CLIPPED," )"
   END IF
   PREPARE t661_precount FROM g_sql
   DECLARE t661_count CURSOR FOR t661_precount
END FUNCTION

FUNCTION t661_menu()
DEFINE l_msg        LIKE type_file.chr1000
   WHILE TRUE
      CALL t661_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t661_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t661_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t661_r()
            END IF
         #無效
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t661_x()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t661_u()
            END IF
         #單身
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t661_b()
               CALL t661_b_fill(" 1=1")
               CALL t661_b1_fill(" 1=1")
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ltt),base.TypeInfo.create(g_ltu),'')
            END IF
         #生效營運中心
         WHEN "eff_plant"
            IF cl_chk_act_auth() THEN
               CALL t661_eff_plant()
            END IF
         #確認
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t661_conf()
            END IF
         #取消確認
         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
               CALL t661_unconf()
            END IF
         #發佈
         WHEN "release"
            IF cl_chk_act_auth() THEN
               CALL t661_release()
            END IF

         #相关文件
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_lts.lts01 IS NOT NULL THEN
                  LET g_doc.column1 = "ltsplant"
                  LET g_doc.value1  = g_lts.ltsplant
                  LET g_doc.column2 = "lts01"
                  LET g_doc.value2  = g_lts.lts01
                  LET g_doc.column3 = "lts02"
                  LET g_doc.value3  = g_lts.lts02
                  CALL cl_doc()
               END IF
            END IF            
      END CASE
   END WHILE

   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
   END IF
END FUNCTION

FUNCTION t661_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_ltt TO s_ltt.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            #表示在第一單身
            LET g_b_flag='1'

         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      DISPLAY ARRAY g_ltu TO s_ltu.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            #表示在第二單身
            LET g_b_flag='2'

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG

      ON ACTION first
         CALL t661_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION previous
         CALL t661_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION jump
         CALL t661_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION next
         CALL t661_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION last
         CALL t661_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac1 = 1
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         LET l_ac1 = ARR_CURR()
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      #生效營運中心
      ON ACTION eff_plant
         LET g_action_choice="eff_plant"
         EXIT DIALOG
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DIALOG
      #發佈
      ON ACTION release
         LET g_action_choice="release"
         EXIT DIALOG
      #相关文件
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t661_a()

   MESSAGE ""
   CLEAR FORM
   LET g_success = 'Y'

   CALL g_ltt.clear()
   CALL g_ltu.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
   LET g_wc3= NULL
   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_lts.* LIKE lts_file.*
   #初始化值
   LET g_lts.lts08 = 'N'
   LET g_lts.lts09 = 0
   LET g_lts.lts10 = 0
   LET g_lts.lts11 = 'N'
   LET g_lts.ltsacti  = 'Y'
   LET g_lts.ltsconf  = 'N'
   LET g_lts.ltscrat  = g_today
   LET g_lts.ltsgrup  = g_grup
   LET g_lts.ltslegal = g_legal
   LET g_lts.ltsorig  = g_grup
   LET g_lts.ltsoriu  = g_user
   LET g_lts.ltsplant = g_plant
   LET g_lts.ltsuser  = g_user

   LET g_lts_t.* = g_lts.*
   CALL cl_opmsg('a')

   WHILE TRUE
      CALL t661_i("a")
      IF INT_FLAG THEN
         INITIALIZE g_lts.* TO NULL
         CALL g_ltt.clear()
         CALL g_ltu.clear()
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF

      IF cl_null(g_lts.lts02) THEN
         CONTINUE WHILE
      END IF
      BEGIN WORK

      INSERT INTO lts_file VALUES (g_lts.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lts_file",g_lts.lts02,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
      CALL t661_ins_b()
      CALL t661_eff_plant()
      SELECT * INTO g_lts.* FROM lts_file
       WHERE  lts01 = g_lts.lts01
         AND lts02 = g_lts.lts02
         AND lts021 = g_lts.lts021
      
      LET g_lts_t.* = g_lts.*
      CALL g_ltt.clear()
      CALL g_ltu.clear()
      #前一版本的單身資料全部都帶進
      CALL t661_b_fill(" 1=1")
      CALL t661_b1_fill(" 1=1")
      CALL t661_refresh()
      
     #因為預設會將前一版本的單身資料全部都帶進,所以這邊不可以直接將單身資料筆數設定為0
      IF cl_null(g_rec_b) THEN
         LET g_rec_b = 0
      END IF
      IF cl_null(g_rec_b1) THEN
         LET g_rec_b1 = 0
      END IF
      CALL t661_b()
      CALL t661_b_fill(" 1=1")
      CALL t661_b1_fill(" 1=1")
      CALL t661_refresh()
      EXIT WHILE
   END WHILE
  #CALL t661_delall() #FUN-D30019 Mark
END FUNCTION
FUNCTION t661_ins_b()
   DEFINE  l_sql       STRING
   #臨時表存儲單身信息
   DROP TABLE ltt_temp
   SELECT * FROM ltt_file WHERE 1 = 0 INTO TEMP ltt_temp
   DROP TABLE ltu_temp
   SELECT * FROM ltu_file WHERE 1 = 0 INTO TEMP ltu_temp
   DROP TABLE ltn_temp
   SELECT * FROM ltn_file WHERE 1 = 0 INTO TEMP ltn_temp

   LET g_success = 'Y'
   LET g_lts021_o = g_lts.lts021 - 1
   BEGIN WORK
   
   DELETE FROM ltt_temp
   DELETE FROM ltu_temp
   DELETE FROM ltn_temp
   IF g_del1 <> 'Y' THEN 
      INSERT INTO ltt_temp
           SELECT ltt_file.*
             FROM ltt_file
            WHERE ltt01 = g_lts.lts01
              AND ltt02 = g_lts.lts02
              AND ltt021 = g_lts021_o
              AND lttplant = g_plant
      UPDATE ltt_temp SET ltt021 = g_lts.lts021        
      #寫入第一單身收券規則
      LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant, 'ltt_file'),
                  " SELECT * FROM ltt_temp"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
      PREPARE trans_ins_ltt FROM l_sql
      EXECUTE trans_ins_ltt
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','INSERT INTO ltt_file:',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   IF g_del2 <> 'Y' THEN
      INSERT INTO ltu_temp
           SELECT ltu_file.*
             FROM ltu_file
            WHERE ltu01 = g_lts.lts01
              AND ltu02 = g_lts.lts02
              AND ltu021 = g_lts021_o
              AND ltuplant = g_plant
      UPDATE ltu_temp SET ltu021 = g_lts.lts021
      #寫入 排除規則
      LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant, 'ltu_file'),
                  " SELECT * FROM ltu_temp"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
      PREPARE trans_ins_ltu FROM l_sql
      EXECUTE trans_ins_ltu
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','INSERT INTO ltu_file:',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF 
   INSERT INTO ltn_temp
        SELECT ltn_file.*
          FROM ltn_file
         WHERE ltn01 = g_lts.lts01
           AND ltn02 = g_lts.lts02
          #AND ltn03 = '3'         #FUN-D10117 mark
           AND ltn03 = '4'           #FUN-D10117 add
           AND ltn08 = g_lts021_o
           AND ltnplant = g_plant

   
   
   UPDATE ltn_temp SET ltn08 = g_lts.lts021

   
   #寫入生效營運中心
   LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant, 'ltn_file'),
               " SELECT * FROM ltn_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
   PREPARE trans_ins_ltn FROM l_sql
   EXECUTE trans_ins_ltn
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','INSERT INTO ltn_file:',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   DROP TABLE ltt_temp
   DROP TABLE ltu_temp
   DROP TABLE ltn_temp
   IF g_success = 'Y' THEN
      COMMIT WORK 
   ELSE
   	  CALL s_showmsg()   
   END IF 
   
END FUNCTION
FUNCTION t661_u()

   IF s_shut(0) THEN
      RETURN
   END IF

   CALL t661_msg('mod')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   SELECT * INTO g_lts.* FROM lts_file
    WHERE lts01 = g_lts.lts01
      AND lts02 = g_lts.lts02
      AND lts021 = g_lts.lts021
      AND ltsplant = g_lts.ltsplant

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lts_t.* = g_lts.*
   BEGIN WORK

   OPEN t661_cl USING g_lts.lts01,g_lts.lts02,g_lts.lts021,g_lts.ltsplant
   IF STATUS THEN
      CALL cl_err("OPEN t661_cl:", STATUS, 1)
      CLOSE t661_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t661_cl INTO g_lts.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lts.lts01,SQLCA.sqlcode,0)
       CLOSE t661_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL t661_show()

   WHILE TRUE
      LET g_lts.ltsmodu = g_user
      LET g_lts.ltsdate = g_today 
      CALL t661_i("u")

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lts.*=g_lts_t.*
         CALL t661_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      UPDATE lts_file SET lts_file.* = g_lts.*
       WHERE lts01 = g_lts.lts01
         AND lts02 = g_lts.lts02
         AND lts021 = g_lts.lts021
         AND ltsplant = g_lts.ltsplant

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lts_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE t661_cl
   COMMIT WORK
   CALL t661_b_fill(" 1=1")
   CALL t661_b1_fill(" 1=1")
   IF g_rec_b = 0 AND g_rec_b1 = 0 THEN
      CALL t661_b()
      CALL t661_b_fill(" 1=1")
      CALL t661_b1_fill(" 1=1")
      CALL t661_refresh()   
   END IF
  #CALL t661_delall() #FUN-D30019 Mark
END FUNCTION

FUNCTION t661_i(p_cmd)
DEFINE    l_n         LIKE type_file.num5
DEFINE    p_cmd       LIKE type_file.chr1
DEFINE    l_rtz13     LIKE rtz_file.rtz13

   IF s_shut(0) THEN
      RETURN
   END IF
   LET g_del1 = 'N'
   LET g_del2 = 'N'
   LET g_success = 'Y'
   DISPLAY BY NAME g_lts.lts08,g_lts.lts11,g_lts.ltsconf,
                   g_lts.ltsuser,g_lts.ltsmodu,g_lts.ltsacti,g_lts.ltsgrup,
                   g_lts.ltsdate,g_lts.ltscrat,g_lts.ltsoriu,g_lts.ltsorig

   INPUT BY NAME g_lts.lts01,g_lts.lts02,g_lts.lts021,g_lts.lts03,g_lts.lts04,
                 g_lts.lts05,g_lts.lts06,g_lts.lts07,g_lts.lts08,g_lts.lts09,g_lts.lts10
           WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t661_set_entry(p_cmd)
         CALL t661_set_no_entry(p_cmd)
         CALL cl_set_comp_entry("lts06,lts07",FALSE)    #FUN-CC0058 add
         LET g_before_input_done = TRUE
         LET g_flag2 = 'N'
         LET g_lts.lts01 = g_plant
         SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_plant
         DISPLAY BY NAME g_lts.lts01
         DISPLAY l_rtz13 TO rtz13
         IF g_lts.lts08 = 'N' THEN
            CALL cl_set_comp_entry("lts09",FALSE)
            CALL cl_set_comp_entry("lts10",FALSE)
         ELSE
            CALL cl_set_comp_entry("lts09",TRUE)
            CALL cl_set_comp_entry("lts10",TRUE)
         END IF      
      AFTER FIELD lts02
         IF NOT cl_null(g_lts.lts02) THEN
            IF p_cmd = 'a' THEN
               CALL t661_lts02()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lts02
               ELSE
                  CALL t661_b_fill(" 1=1")
                  CALL t661_b1_fill(" 1=1")
                  CALL t661_refresh()
               END IF

            END IF
         END IF

      AFTER FIELD lts06
         IF (p_cmd = 'a' AND g_lts06 != g_lts.lts06)THEN    
            #修改單頭會刪除單身，是否繼續
            IF NOT cl_confirm('alm2000') THEN
               LET g_lts.lts06  =g_lts06
            ELSE
               LET g_del1 = 'Y'     
            END IF
         END IF
         #IF (p_cmd = 'u' AND g_lts.lts06 != g_lts_t.lts06) THEN                        #FUN-CC0058 mark
         IF p_cmd = 'u' AND g_lts.lts06 != g_lts_t.lts06 AND g_lts_t.lts06 <> '0' THEN  #FUN-CC0058 add
            IF NOT cl_confirm('alm-816') THEN
               LET g_lts.lts06=g_lts_t.lts06
            ELSE 
                #刪除第二單身信息
               DELETE FROM ltt_file
                WHERE ltt01 = g_lts.lts01
                  AND ltt02 = g_lts.lts02
                  AND ltt021 = g_lts.lts021
                  AND lttplant = g_lts.ltsplant
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","ltt_file",g_lts.lts01,g_lts.lts02,SQLCA.sqlcode,"","",1)
               ELSE
                  CALL g_ltt.clear()
                  CALL t661_b_fill(" 1=1")
                  CALL t661_refresh()
               END IF
            END IF
         END IF  

      AFTER FIELD lts07
         IF (p_cmd = 'a' AND g_lts07 != g_lts.lts07)THEN    
            #修改單頭會刪除單身，是否繼續
            IF NOT cl_confirm('alm2000') THEN
               LET g_lts.lts07  =g_lts07
            ELSE
               LET g_del2 = 'Y'     
            END IF
         END IF
         #IF (p_cmd = 'u' AND g_lts.lts07 != g_lts_t.lts07) THEN                        #FUN-CC0058 mark
         IF p_cmd = 'u' AND g_lts.lts07 != g_lts_t.lts07 AND g_lts_t.lts07 <> '0' THEN  #FUN-CC0058 add
            IF NOT cl_confirm('alm-816') THEN
               LET g_lts.lts07=g_lts_t.lts07
            ELSE 
                #刪除第二單身信息
               DELETE FROM ltu_file
                WHERE ltu01 = g_lts.lts01
                  AND ltu02 = g_lts.lts02
                  AND ltu021 = g_lts.lts021
                  AND ltuplant = g_lts.ltsplant
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","ltu_file",g_lts.lts01,g_lts.lts02,SQLCA.sqlcode,"","",1)
               ELSE
                  CALL g_ltu.clear()
                  CALL t661_b1_fill(" 1=1")
                  CALL t661_refresh()
               END IF
            END IF
         END IF    
      AFTER FIELD lts04
         IF NOT cl_null(g_lts.lts04) THEN
            CALL t661_lts04_lts05(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lts.lts04=g_lts_t.lts04
               NEXT FIELD lts04
            END IF
            IF g_success = 'N' THEN 
               NEXT FIELD lts04
            END IF
            
         END IF

      AFTER FIELD lts05
         IF NOT cl_null(g_lts.lts05) THEN
            CALL t661_lts04_lts05(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lts.lts05=g_lts_t.lts05
               NEXT FIELD lts05
            END IF
            IF g_success = 'N' THEN 
               NEXT FIELD lts05
            END IF               
         END IF
      ON CHANGE lts08
         IF g_lts.lts08 = 'N' THEN
            CALL cl_set_comp_entry("lts09",FALSE)
            CALL cl_set_comp_entry("lts10",FALSE)
            LET g_lts.lts09 = 0
            LET g_lts.lts10 = 0
            DISPLAY BY NAME g_lts.lts09,g_lts.lts10
         ELSE
            LET g_lts.lts09 = '' 
            LET g_lts.lts10 = ''
            DISPLAY BY NAME g_lts.lts09,g_lts.lts10
            CALL cl_set_comp_entry("lts09",TRUE)
            CALL cl_set_comp_entry("lts10",TRUE)
         END IF     
      AFTER FIELD lts09
         IF g_lts.lts09 <= 0 THEN
            CALL cl_err('','alm-h29',0)
            LET g_lts.lts09 = g_lts_t.lts09
            NEXT FIELD lts09
         END IF
      AFTER FIELD lts10
         IF g_lts.lts10 <= 0 THEN
            CALL cl_err('','alm-h29',0)
            LET g_lts.lts10 = g_lts_t.lts10
            NEXT FIELD lts10
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON ACTION controlp
         CASE
            WHEN INFIELD(lts02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ltp02"
               #制定營運中心相同，已發佈的資料
               LET g_qryparam.where = " ltp11 = 'Y' AND ltp01 = '",g_lts.lts01,"'"
               LET g_qryparam.default1 = g_lts.lts02
               CALL cl_create_qry() RETURNING g_lts.lts02
               DISPLAY BY NAME g_lts.lts02
               NEXT FIELD lts02
            WHEN INFIELD(lts03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lpx01"
               LET g_qryparam.default1 = g_lts.lts03
               CALL cl_create_qry() RETURNING g_lts.lts03
               DISPLAY BY NAME g_lts.lts03
               NEXT FIELD lts03
            OTHERWISE EXIT CASE
          END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END INPUT

END FUNCTION

FUNCTION t661_lts02()
   DEFINE  l_cnt       LIKE type_file.num5
   DEFINE  l_sql       STRING
   DEFINE  l_lpx02     LIKE lpx_file.lpx02
   LET g_errno = ''
   IF cl_null(g_lts.lts02) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF

   LET g_lts021_o = ''
   #取出當前單號對應的版本號
   SELECT ltp021 INTO g_lts021_o
     FROM ltp_file
    WHERE ltp01 = g_plant
      AND ltp02 = g_lts.lts02
      AND ltp11 = 'Y'
      AND ltpacti = 'Y'
      AND ltpplant = g_plant
   #規則單號不存在或者未發佈
   IF cl_null(g_lts021_o) THEN
      LET g_errno = 'alm1996'
      RETURN
   END IF
   LET g_lts.lts021 = g_lts021_o + 1
   SELECT COUNT(lts01) INTO l_cnt FROM lts_file
    WHERE lts01 = g_lts.lts01
      AND lts02 = g_lts.lts02
      AND lts021 = g_lts.lts021
      AND ltsplant = g_lts.ltsplant
   IF l_cnt > 0 THEN
      LET g_errno = '-239'
      RETURN
   END IF 
   #取出單頭信息
   SELECT ltp03,ltp04,ltp05,ltp06,ltp07,ltp08,ltp09,ltp10
     INTO g_lts.lts03,g_lts.lts04,g_lts.lts05,g_lts.lts06,g_lts.lts07,
          g_lts.lts08,g_lts.lts09,g_lts.lts10
     FROM ltp_file
    WHERE ltp01 = g_plant
      AND ltp02 = g_lts.lts02
      AND ltp021 = g_lts021_o
      AND ltp11 = 'Y'
      AND ltpacti = 'Y'
      AND ltpplant = g_plant
   LET g_lts03 = g_lts.lts03 
   LET g_lts06 = g_lts.lts06
   LET g_lts07 = g_lts.lts07
   IF g_lts.lts08 = 'N' THEN
      CALL cl_set_comp_entry("lts09",FALSE)
      CALL cl_set_comp_entry("lts10",FALSE)
   ELSE
   	  CALL cl_set_comp_entry("lts09",TRUE)
      CALL cl_set_comp_entry("lts10",TRUE)
   END IF    
   SELECT lpx02,lpx03,lpx04 INTO l_lpx02,g_lpx03,g_lpx04 FROM lpx_file  
    WHERE lpx01 = g_lts.lts03

   DISPLAY l_lpx02 TO lpx02
   DISPLAY BY NAME g_lts.lts021,g_lts.lts03,g_lts.lts04,g_lts.lts05,
                   g_lts.lts06,g_lts.lts07,g_lts.lts08,g_lts.lts09,g_lts.lts10

END FUNCTION

FUNCTION t661_lts04_lts05(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_n   LIKE type_file.num10
   LET g_errno = ''
   IF NOT cl_null(g_lts.lts03) THEN
      SELECT lpx03,lpx04 INTO g_lpx03,g_lpx04 FROM lpx_file  
       WHERE lpx01 = g_lts.lts03
      #如果收券規則時間範圍在券種時間範圍之外
      IF g_lts.lts04 < g_lpx03 OR g_lts.lts04 > g_lpx04 
        OR g_lts.lts05 < g_lts03 OR g_lts.lts05 > g_lpx04 THEN
         LET g_errno = 'alm1995'
         RETURN
      END IF
   END IF

   IF  cl_null(g_lts.lts04) OR  cl_null(g_lts.lts05) THEN
      RETURN
   END IF
   #失效日期不可小于生效日期
   IF g_lts.lts04 > g_lts.lts05 THEN
      LET g_errno = 'art-711'
      RETURN
   END IF
   IF cl_null(g_lts.lts03) THEN 
      RETURN 
   END IF      
   IF p_cmd = 'a' THEN
      SELECT COUNT(*) INTO l_n
        FROM ltp_file
       WHERE ltp03 =g_lts.lts03
         AND (ltp04 BETWEEN g_lts.lts04 AND g_lts.lts05
          OR  ltp05 BETWEEN g_lts.lts04 AND g_lts.lts05
          OR (ltp04 <= g_lts.lts04 AND ltp05 >= g_lts.lts05))
         AND ltp11 = 'Y'
         AND ltpconf = 'Y'
         AND ltpacti = 'Y'
         AND ltp02 <> g_lts.lts02
   ELSE
      SELECT COUNT(*) INTO l_n
        FROM ltp_file
       WHERE  ltp03 =g_lts.lts03
         AND (ltp04 BETWEEN g_lts.lts04 AND g_lts.lts05
          OR  ltp05 BETWEEN g_lts.lts04 AND g_lts.lts05
          OR (ltp04 <= g_lts.lts04 AND ltp05 >= g_lts.lts05))
         AND ltp11 = 'Y'
         AND ltpconf = 'Y'
         AND ltpacti = 'Y'
         AND ltp02 <> g_lts_t.lts02
   END IF
   IF l_n>0 THEN
      LET g_errno = 'alm1998'
      RETURN
   END IF
   CALL t661_ckmult(p_cmd)
END FUNCTION

FUNCTION t661_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ltt.clear()
   CALL g_ltu.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL t661_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lts.* TO NULL
      RETURN
   END IF

   OPEN t661_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lts.* TO NULL
   ELSE
      OPEN t661_count
      FETCH t661_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t661_fetch('F')
   END IF

END FUNCTION

FUNCTION t661_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     t661_cs INTO g_lts.*
      WHEN 'P' FETCH PREVIOUS t661_cs INTO g_lts.*
      WHEN 'F' FETCH FIRST    t661_cs INTO g_lts.*
      WHEN 'L' FETCH LAST     t661_cs INTO g_lts.*
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t661_cs INTO g_lts.*
            LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lts.lts01,SQLCA.sqlcode,0)
      INITIALIZE g_lts.* TO NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF

   SELECT * INTO g_lts.* FROM lts_file WHERE lts01 = g_lts.lts01
                                         AND lts02 = g_lts.lts02
                                         AND lts021 = g_lts.lts021
                                         AND ltsplant = g_lts.ltsplant

   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lts_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lts.* TO NULL
      RETURN
   END IF

   CALL t661_show()

END FUNCTION

FUNCTION t661_show()
DEFINE l_rtz13    LIKE rtz_file.rtz13
DEFINE l_lpx02    LIKE lpx_file.lpx02
DEFINE l_gen02    LIKE gen_file.gen02
   LET g_lts_t.* = g_lts.*
   DISPLAY BY NAME g_lts.lts01,g_lts.lts02,g_lts.lts021,g_lts.lts03,
                   g_lts.lts04,g_lts.lts05,g_lts.lts06,g_lts.lts07, g_lts.lts08,
                   g_lts.lts09,g_lts.lts10,g_lts.lts11,g_lts.lts12,
                   g_lts.ltsconf,g_lts.ltsconu,g_lts.ltscond,g_lts.ltscont,
                   g_lts.ltsuser,g_lts.ltsmodu,g_lts.ltsacti,g_lts.ltsgrup,g_lts.ltsdate,
                   g_lts.ltscrat,g_lts.ltsoriu,g_lts.ltsorig

   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_lts.lts01
   DISPLAY l_rtz13 TO rtz13
   SELECT lpx02 INTO l_lpx02 FROM lpx_file WHERE lpx01 = g_lts.lts03
   DISPLAY l_lpx02 TO lpx02
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lts.ltsconu
   DISPLAY l_gen02 TO gen02
   CALL t661_b_fill(g_wc2)
   CALL t661_b1_fill(g_wc3)
   CALL cl_show_fld_cont()
   CALL t661_pic()
END FUNCTION

FUNCTION t661_r()

   IF s_shut(0) THEN
      RETURN
   END IF

   CALL t661_msg('del')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   SELECT * INTO g_lts.* FROM lts_file
    WHERE lts01=g_lts.lts01
      AND lts02 = g_lts.lts02
      AND lts021 = g_lts.lts021
      AND ltsplant = g_lts.ltsplant

   BEGIN WORK

   OPEN t661_cl USING g_lts.lts01,g_lts.lts02,g_lts.lts021,g_lts.ltsplant
   IF STATUS THEN
      CALL cl_err("OPEN t661_cl:", STATUS, 1)
      CLOSE t661_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t661_cl INTO g_lts.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lts.lts01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL t661_show()

   IF cl_delh(0,0) THEN
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "lts01"
      LET g_doc.column2 = "lts02"
      LET g_doc.column3 = "lts021"
      LET g_doc.column4 = "ltsplant"
      LET g_doc.value1 = g_lts.lts01
      LET g_doc.value2 = g_lts.lts02
      LET g_doc.value3 = g_lts.lts021
      LET g_doc.value4 = g_lts.ltsplant
      CALL cl_del_doc()
      

      DELETE FROM ltt_file
            WHERE ltt01    = g_lts.lts01
              AND ltt02    = g_lts.lts02
              AND ltt021    =g_lts.lts021
              AND lttplant = g_lts.ltsplant
      IF SQLCA.sqlcode THEN
         CALL cl_err3("DELETE ","ltt_file",g_lts.lts02,"",SQLCA.sqlcode,"","ltt",1)
         LET g_success = 'N'
      END IF

      DELETE FROM ltu_file
            WHERE ltu01    = g_lts.lts01
              AND ltu02    = g_lts.lts02
              AND ltu021    = g_lts.lts021
              AND ltuplant = g_lts.ltsplant
      IF SQLCA.sqlcode  THEN
         CALL cl_err3("DELETE ","ltu_file",g_lts.lts02,"",SQLCA.sqlcode,"","ltu",1)
         LET g_success = 'N'
      END IF
      DELETE FROM ltn_file
            WHERE ltn01    = g_lts.lts01
              AND ltn02    = g_lts.lts02
              AND ltn08    = g_lts.lts021
              AND ltnplant = g_lts.ltsplant
      IF SQLCA.sqlcode THEN
         CALL cl_err3("DELETE ","ltn_file",g_lts.lts02,"",SQLCA.sqlcode,"","ltn",1)
         LET g_success = 'N'
      END IF

      DELETE FROM lts_file
            WHERE lts01    = g_lts.lts01
              AND lts02    = g_lts.lts02
              AND lts021    = g_lts.lts021
              AND ltsplant = g_lts.ltsplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("DELETE ","lts_file",g_lts.lts02,"",SQLCA.sqlcode,"","lts",1)
      END IF      
       
      CLEAR FORM
      CALL g_ltt.clear()
      CALL g_ltu.clear()
      OPEN t661_count
      IF STATUS THEN
         CLOSE t661_cs
         CLOSE t661_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t661_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t661_cs
         CLOSE t661_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t661_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t661_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t661_fetch('/')
      END IF
   END IF
   CLOSE t661_cl
   COMMIT WORK

END FUNCTION

FUNCTION t661_b()
DEFINE   l_ac_t          LIKE type_file.num5
DEFINE   l_n             LIKE type_file.num5
DEFINE   l_cnt           LIKE type_file.num5
DEFINE   l_lock_sw       LIKE type_file.chr1
DEFINE   p_cmd           LIKE type_file.chr1
DEFINE   l_allow_insert  LIKE type_file.num5
DEFINE   l_allow_delete  LIKE type_file.num5
DEFINE   l_allow_insert1 LIKE type_file.num5  #FUN-CC0058 add
DEFINE   l_allow_delete1 LIKE type_file.num5  #FUN-CC0058 add
DEFINE   l_n1            LIKE type_file.num5
DEFINE   l_ac1_t         LIKE type_file.num5

   LET g_action_choice = ""

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lts.lts01 IS NULL THEN
      RETURN
   END IF
   IF g_lts.lts06 = '0' AND g_lts.lts07 = '0' THEN     #FUN-CC0058 add
      RETURN                                           #FUN-CC0058 add
   END IF                                              #FUN-CC0058 add
   IF g_lts.lts01 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   IF g_lts.ltsacti = 'N' THEN
      CALL cl_err('','9027',0)
      RETURN
   END IF

   IF g_lts.lts11 = 'Y' THEN        #已發佈時不允許修改
      CALL cl_err('','alm-h55',0)
      RETURN
   END IF

   IF g_lts.ltsconf = 'Y' THEN   #已確認時不允許修改
      CALL cl_err('','alm-027',0)
      RETURN
   END IF
   CALL cl_opmsg('b')

   LET g_forupd_sql = " SELECT ltt03,'',lttacti ",
                      " FROM ltt_file ",
                      " WHERE ltt01 = ? AND ltt02 = ? AND ltt021 =?  AND lttplant = ? AND ltt03 = ? ",
                      "  FOR UPDATE  "
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE t661_bcl CURSOR FROM g_forupd_sql
   # LOCK CURSOR
   LET g_forupd_sql = " SELECT ltu03,'',ltuacti ",
                      " FROM ltu_file ",
                      " WHERE ltu01 = ? AND ltu02 = ? AND ltu021 =?  AND ltuplant = ? AND ltu03 = ? ",
                      "  FOR UPDATE  "
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
   DECLARE t661_bcl1 CURSOR FROM g_forupd_sql

   #LET l_allow_insert = cl_detail_input_auth("insert")  #FUN-CC0058 mark
   #LET l_allow_delete = cl_detail_input_auth("delete")  #FUN-CC0058 mark
   #FUN-CC0058---add----str
   IF g_lts.lts06 = '0' THEN
      LET l_allow_insert = FALSE
      LET l_allow_delete = FALSE
   ELSE
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
   END IF
   IF g_lts.lts07 = '0' THEN
      LET l_allow_insert1 = FALSE
      LET l_allow_delete1 = FALSE
   ELSE
      LET l_allow_insert1 = cl_detail_input_auth("insert")
      LET l_allow_delete1 = cl_detail_input_auth("delete")
   END IF
   #FUN-CC0058--add----end
   DIALOG ATTRIBUTE(UNBUFFERED)
      INPUT ARRAY g_ltt FROM s_ltt.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

         BEFORE INPUT
            IF g_lts.lts06 = '0' THEN          #FUN-CC0058 add
               CALL cl_err('','alm2005',0)     #FUN-CC0058 add
            END IF                             #FUN-CC0058 add
            #如果是進入第二單身，則到第二單身欄位
            #IF g_b_flag = '2' THEN            #FUN-CC0058 mark
            IF g_b_flag = '2' AND g_lts.lts07 <> '0' THEN  #FUN-CC0058 add
               NEXT FIELD ltu03
            END IF

            DISPLAY "BEFORE INPUT!"
             IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

         BEFORE ROW
            DISPLAY "BEFORE ROW!"
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            OPEN t661_cl USING g_lts.lts01,g_lts.lts02,g_lts.lts021,g_lts.ltsplant
            IF STATUS THEN
               CALL cl_err("OPEN t661_cl:", STATUS, 1)
               CLOSE t661_cl
               ROLLBACK WORK
               RETURN
            END IF

            FETCH t661_cl INTO g_lts.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_lts.lts01,SQLCA.sqlcode,0)
               CLOSE t661_cl
               ROLLBACK WORK
               RETURN
            END IF

            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_ltt_t.* = g_ltt[l_ac].*  #BACKUP
               OPEN t661_bcl USING g_lts.lts01,g_lts.lts02,g_lts.lts021,g_lts.ltsplant,g_ltt_t.ltt03
               IF STATUS THEN
                  CALL cl_err("OPEN t661_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t661_bcl INTO g_ltt[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ltt_t.ltt03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL t661_ltt03('d')
               CALL cl_show_fld_cont()
            END IF

         BEFORE INSERT
            DISPLAY "BEFORE INSERT!"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ltt[l_ac].* TO NULL
            LET g_ltt_t.* = g_ltt[l_ac].*
            LET g_ltt[l_ac].lttacti = 'Y'
            CALL cl_show_fld_cont()
            LET g_before_input_done = FALSE
            LET g_before_input_done = TRUE
            NEXT FIELD ltt03

         AFTER INSERT
            DISPLAY "AFTER INSERT!"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            INSERT INTO ltt_file(ltt01,ltt02,ltt021,ltt03,lttacti,lttlegal,lttplant)
            VALUES(g_lts.lts01,g_lts.lts02,g_lts.lts021,g_ltt[l_ac].ltt03,g_ltt[l_ac].lttacti,
                    g_lts.ltslegal,g_lts.ltsplant)

            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ltt_file",g_lts.lts02,g_ltt[l_ac].ltt03,SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cnt1
            END IF

          
         #FUN-CC0058 Begin---
         BEFORE FIELD ltt03,lttacti
            IF g_lts.lts06 = '0' THEN
               NEXT FIELD ltu03
            END IF
         #FUN-CC0058 End-----

         AFTER FIELD ltt03
            IF NOT cl_null(g_ltt[l_ac].ltt03) THEN
               CALL t661_ltt03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ltt[l_ac].ltt03=g_ltt_t.ltt03
                  NEXT FIELD ltt03
               END IF
               IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ltt[l_ac].ltt03 != g_ltt_t.ltt03) THEN
                  SELECT COUNT(*) INTO l_n1
                    FROM ltt_file
                   WHERE ltt01 = g_lts.lts01
                     AND ltt02 = g_lts.lts02
                     AND ltt021 = g_lts.lts021
                     AND lttplant = g_lts.ltsplant
                     AND ltt03=g_ltt[l_ac].ltt03
                  IF l_n1>0 THEN
                     CALL cl_err('','-239',0)
                     LET g_ltt[l_ac].ltt03=g_ltt_t.ltt03
                     NEXT FIELD ltt03
                  END IF
                  #如果收券規則與排除規則相同，則兩個單身的編號不可重複
                  IF g_lts.lts06 = g_lts.lts07 THEN
                     SELECT COUNT(*) INTO l_n1
                       FROM ltu_file
                      WHERE ltu01 = g_lts.lts01
                        AND ltu02 = g_lts.lts02
                        AND ltu021 = g_lts.lts021
                        AND ltuplant = g_lts.ltsplant
                        AND ltu03=g_ltt[l_ac].ltt03
                     IF l_n1>0 THEN
                        CALL cl_err('','alm1997',0)
                        LET g_ltt[l_ac].ltt03=g_ltt_t.ltt03
                        NEXT FIELD ltt03
                     END IF
                  END IF
               END IF
            END IF

         BEFORE DELETE
            DISPLAY "BEFORE DELETE"
            IF g_ltt_t.ltt03 IS NOT NULL THEN
               #FUN-CC0058--------add----str
               IF NOT t661_chk_ltppos(g_ltt_t.ltt03,'1') THEN
                  CANCEL DELETE
               END IF
               #FUN-CC0058--------add----end
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM ltt_file
                WHERE ltt01 = g_lts.lts01
                  AND ltt02 = g_lts.lts02
                  AND ltt021 = g_lts.lts021
                  AND lttplant = g_lts.ltsplant
                  AND ltt03 = g_ltt_t.ltt03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","ltt_file",g_lts.lts02,g_ltt_t.ltt03,SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  CANCEL DELETE
               ELSE

               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cnt1
            END IF
            COMMIT WORK

         ON ROW CHANGE

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ltt[l_ac].* = g_ltt_t.*
               CLOSE t661_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ltt[l_ac].ltt03,-263,1)
               LET g_ltt[l_ac].* = g_ltt_t.*
            ELSE
               UPDATE ltt_file SET ltt03 = g_ltt[l_ac].ltt03,
                                   lttacti = g_ltt[l_ac].lttacti
                WHERE ltt01 = g_lts_t.lts01
                  AND ltt02 = g_lts_t.lts02
                  AND ltt021 = g_lts_t.lts021
                  AND lttplant = g_lts_t.ltsplant
                  AND ltt03 = g_ltt_t.ltt03
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","ltt_file",g_lts.lts02,g_ltt_t.ltt03,SQLCA.sqlcode,"","",1)
                  LET g_ltt[l_ac].* = g_ltt_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

         AFTER ROW
            DISPLAY  "AFTER ROW!!"
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ltt[l_ac].* = g_ltt_t.*
                 #CALL t661_delall() #FUN-D30019 Mark
               END IF
               CLOSE t661_bcl
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            CLOSE t661_bcl
            COMMIT WORK

         ON ACTION controlp
            CASE
               WHEN INFIELD(ltt03)
                 #如果收券規則不是 1.產品
                 IF g_lts.lts06 <> '1' THEN
                    CALL cl_init_qry_var()
                    CASE g_lts.lts06
                       #產品分類
                       WHEN "2"
                          LET g_qryparam.form ="q_oba1"
                       #品牌
                       WHEN "3"
                          LET g_qryparam.form ="q_tqa"
                          LET g_qryparam.arg1='2'
                    END CASE
                    LET g_qryparam.default1 = g_ltt[l_ac].ltt03
                    CALL cl_create_qry() RETURNING g_ltt[l_ac].ltt03
                 ELSE
                    CALL q_sel_ima(FALSE, "q_ima", "", g_ltt[l_ac].ltt03, "", "", "", "" ,"",'' )
                    RETURNING g_ltt[l_ac].ltt03
                 END IF
                 DISPLAY BY NAME g_ltt[l_ac].ltt03
                 NEXT FIELD ltt03
               OTHERWISE EXIT CASE
            END CASE

         ON ACTION CONTROLO
            IF INFIELD(ltt03) AND l_ac > 1 THEN
               LET g_ltt[l_ac].* = g_ltt[l_ac-1].*
               LET g_ltt[l_ac].ltt03 = g_rec_b + 1
               NEXT FIELD ltt03
            END IF

      END INPUT
      INPUT ARRAY g_ltu FROM s_ltu.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
                    INSERT ROW=l_allow_insert1,DELETE ROW=l_allow_delete1,  #FUN-CC0058 add
                    APPEND ROW=l_allow_insert1)                             #FUN-CC0058 add
                    #INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,   #FUN-CC0058 mark
                    #APPEND ROW=l_allow_insert)                             #FUN-CC0058 mark

         BEFORE INPUT
            DISPLAY "BEFORE INPUT!"
            LET g_b_flag = '1'   
            IF g_rec_b1 != 0 THEN
               CALL fgl_set_arr_curr(l_ac1)
            END IF
            IF g_lts.lts07 = '0' THEN          #FUN-CC0058 add
               CALL cl_err('','alm2006',0)     #FUN-CC0058 add
            END IF                             #FUN-CC0058 add

         BEFORE ROW
            DISPLAY "BEFORE ROW!"
            LET p_cmd = ''
            LET l_ac1 = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            OPEN t661_cl USING g_lts.lts01,g_lts.lts02,g_lts.lts021,g_lts.ltsplant
            IF STATUS THEN
               CALL cl_err("OPEN t661_cl:", STATUS, 1)
               CLOSE t661_cl
               ROLLBACK WORK
               RETURN
            END IF

            FETCH t661_cl INTO g_lts.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_lts.lts01,SQLCA.sqlcode,0)
               CLOSE t661_cl
               ROLLBACK WORK
               RETURN
            END IF

            IF g_rec_b1 >= l_ac1 THEN
               LET p_cmd='u'
               LET g_ltu_t.* = g_ltu[l_ac1].*  #BACKUP
               OPEN t661_bcl1 USING g_lts.lts01,g_lts.lts02,g_lts.lts021,g_lts.ltsplant,g_ltu_t.ltu03
               IF STATUS THEN
                  CALL cl_err("OPEN t661_bcl1:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t661_bcl1 INTO g_ltu[l_ac1].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ltu_t.ltu03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL t661_ltu03('d')
               CALL cl_show_fld_cont()
            END IF

         BEFORE INSERT
            DISPLAY "BEFORE INSERT!"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ltu[l_ac1].* TO NULL
            LET g_ltu_t.* = g_ltu[l_ac1].*
            LET g_ltu[l_ac1].ltuacti = 'Y'
            CALL cl_show_fld_cont()
            LET g_before_input_done = FALSE
            LET g_before_input_done = TRUE
            NEXT FIELD ltu03

         AFTER INSERT
            DISPLAY "AFTER INSERT!"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            INSERT INTO ltu_file(ltu01,ltu02,ltu021,ltu03,ltuacti,ltulegal,ltuplant)
            VALUES(g_lts.lts01,g_lts.lts02,g_lts.lts021,g_ltu[l_ac1].ltu03,g_ltu[l_ac1].ltuacti,
                   g_lts.ltslegal,g_lts.ltsplant)

            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ltu_file",g_lts.lts02,g_ltu[l_ac1].ltu03,SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b1=g_rec_b1+1
               DISPLAY g_rec_b1 TO FORMONLY.cnt2
            END IF

         
         #FUN-CC0058 Begin---
         BEFORE FIELD ltu03,ltuacti
            IF g_lts.lts07 = '0' THEN
               NEXT FIELD ltt03
            END IF
         #FUN-CC0058 End-----

         AFTER FIELD ltu03
            IF NOT cl_null(g_ltu[l_ac1].ltu03) THEN
               CALL t661_ltu03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_ltu[l_ac1].ltu03=g_ltu_t.ltu03
                  NEXT FIELD ltu03
               END IF
               IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ltu[l_ac1].ltu03 != g_ltu_t.ltu03) THEN
                  SELECT COUNT(*) INTO l_n1
                    FROM ltu_file
                   WHERE ltu01 = g_lts.lts01
                     AND ltu02 = g_lts.lts02
                     AND ltu021 = g_lts.lts021
                     AND ltuplant = g_lts.ltsplant
                     AND ltu03=g_ltu[l_ac1].ltu03
                  IF l_n1>0 THEN
                     CALL cl_err('','-239',0)
                     LET g_ltu[l_ac1].ltu03=g_ltu_t.ltu03
                     NEXT FIELD ltu03
                  END IF
                  IF g_lts.lts06 = g_lts.lts07 THEN
                     SELECT COUNT(*) INTO l_n1
                     FROM ltt_file
                     WHERE ltt01 = g_lts.lts01
                       AND ltt02 = g_lts.lts02
                       AND ltt021 = g_lts.lts021
                       AND lttplant = g_lts.ltsplant
                       AND ltt03=g_ltu[l_ac1].ltu03
                     IF l_n1>0 THEN
                        CALL cl_err('','alm1997',0)
                        LET g_ltu[l_ac1].ltu03=g_ltu_t.ltu03
                        NEXT FIELD ltu03
                     END IF
                  END IF
               END IF
            END IF
         BEFORE DELETE
            DISPLAY "BEFORE DELETE"
            IF g_ltu_t.ltu03 IS NOT NULL THEN
               #FUN-CC0058--------add----str
               IF NOT t661_chk_ltppos(g_ltu_t.ltu03,'2') THEN
                  CANCEL DELETE
               END IF
               #FUN-CC0058--------add----end
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
                 IF l_lock_sw = "Y" THEN
                    CALL cl_err("", -263, 1)
                    CANCEL DELETE
                 END IF
                 DELETE FROM ltu_file
                  WHERE ltu01 = g_lts.lts01
                    AND ltu02 = g_lts.lts02
                    AND ltu021 = g_lts.lts021
                    AND ltuplant = g_lts.ltsplant
                    AND ltu03 = g_ltu_t.ltu03
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","ltu_file",g_lts.lts02,g_ltu_t.ltu03,SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 ELSE

                 END IF
                 LET g_rec_b1=g_rec_b1-1
                 DISPLAY g_rec_b1 TO FORMONLY.cnt2
              END IF
              COMMIT WORK

         ON ROW CHANGE

            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ltu[l_ac1].* = g_ltu_t.*
               CLOSE t661_bcl1
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ltu[l_ac1].ltu03,-263,0)
               LET g_ltu[l_ac1].* = g_ltu_t.*
            ELSE
               UPDATE ltu_file SET ltu03 = g_ltu[l_ac1].ltu03,
                                   ltuacti = g_ltu[l_ac1].ltuacti
                WHERE ltu01 = g_lts_t.lts01
                  AND ltu02 = g_lts_t.lts02
                  AND ltu021 = g_lts_t.lts021
                  AND ltuplant = g_lts_t.ltsplant
                  AND ltu03 = g_ltu_t.ltu03
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","ltu_file",g_lts.lts02,g_ltu_t.ltu03,SQLCA.sqlcode,"","",1)
                  LET g_ltu[l_ac1].* = g_ltu_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

         AFTER ROW
            DISPLAY  "AFTER ROW!!"
            LET l_ac1 = ARR_CURR()
            LET l_ac1_t = l_ac1
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ltu[l_ac1].* = g_ltu_t.*
                 #CALL t661_delall() #FUN-D30019 Mark
               END IF
               CLOSE t661_bcl1
               ROLLBACK WORK
               EXIT DIALOG
            END IF
            CLOSE t661_bcl1
            COMMIT WORK

         ON ACTION controlp
            CASE
               WHEN INFIELD(ltu03)
                 IF g_lts.lts07 <> '1' THEN
                    CALL cl_init_qry_var()
                    CASE g_lts.lts07
                       WHEN "2"
                          LET g_qryparam.form ="q_oba1"
                       WHEN "3"
                          LET g_qryparam.form ="q_tqa"
                          LET g_qryparam.arg1='2'
                    END CASE
                    LET g_qryparam.default1 = g_ltu[l_ac1].ltu03
                    CALL cl_create_qry() RETURNING g_ltu[l_ac1].ltu03
                 ELSE
                    CALL q_sel_ima(FALSE, "q_ima", "", g_ltu[l_ac1].ltu03, "", "", "", "" ,"",'' )
                    RETURNING g_ltu[l_ac1].ltu03
                 END IF
                 DISPLAY BY NAME g_ltu[l_ac1].ltu03
                 NEXT FIELD ltu03
               OTHERWISE EXIT CASE
            END CASE

         ON ACTION CONTROLO
            IF INFIELD(ltu03) AND l_ac1 > 1 THEN
               LET g_ltu[l_ac1].* = g_ltu[l_ac1-1].*
               LET g_ltu[l_ac1].ltu03 = g_rec_b1 + 1
               NEXT FIELD ltu03
            END IF

      END INPUT
      ON ACTION ACCEPT
         ACCEPT DIALOG
      ON ACTION CANCEL
         EXIT DIALOG
      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
   END DIALOG

   CLOSE t661_bcl1
   COMMIT WORK
   CLOSE t661_bcl
   COMMIT WORK
  #CALL t661_delall() #FUN-D30019 Mark
END FUNCTION

FUNCTION t661_ltt03(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1
DEFINE   l_obaacti       LIKE oba_file.obaacti
DEFINE   l_imaacti       LIKE ima_file.imaacti
DEFINE   l_tqa03         LIKE tqa_file.tqa03
DEFINE   l_ima02         LIKE ima_file.ima02
DEFINE   l_tqa02         LIKE tqa_file.tqa02
DEFINE   l_oba02         LIKE oba_file.oba02

    LET g_errno =''
    #收券規則
    CASE g_lts.lts06
       #1.產品
       WHEN "1"
          SELECT imaacti,ima02 INTO l_imaacti,l_ima02 FROM ima_file
          WHERE ima01=g_ltt[l_ac].ltt03
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_ima02 = NULL
               WHEN l_imaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case
          IF cl_null(g_errno) OR p_cmd='d' THEN
             LET g_ltt[l_ac].ltt03_desc=l_ima02
             DISPLAY g_ltt[l_ac].ltt03_desc TO name1
          END IF
       #2.產品分類
       WHEN "2"
          SELECT obaacti,oba02 INTO l_obaacti,l_oba02
            FROM oba_file
           WHERE oba01=g_ltt[l_ac].ltt03
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_oba02 = NULL
               WHEN l_obaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END CASE
          IF cl_null(g_errno) OR p_cmd='d' THEN
             LET g_ltt[l_ac].ltt03_desc=l_oba02
             DISPLAY g_ltt[l_ac].ltt03_desc TO name1
          END IF
       #3.品牌
       WHEN "3"
          SELECT tqa03,tqa02 INTO l_tqa03,l_tqa02 FROM tqa_file
          WHERE tqa01=g_ltt[l_ac].ltt03 AND tqa03='2'
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_tqa02 = NULL
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case
          IF cl_null(g_errno) OR p_cmd='d' THEN
             LET g_ltt[l_ac].ltt03_desc=l_tqa02
             DISPLAY g_ltt[l_ac].ltt03_desc TO name1
          END IF

    END CASE

END FUNCTION

FUNCTION t661_ltu03(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1
DEFINE   l_obaacti       LIKE oba_file.obaacti
DEFINE   l_imaacti       LIKE ima_file.imaacti
DEFINE   l_tqa03         LIKE tqa_file.tqa03
DEFINE   l_ima02         LIKE ima_file.ima02
DEFINE   l_tqa02         LIKE tqa_file.tqa02
DEFINE   l_oba02         LIKE oba_file.oba02

    LET g_errno =''
    #排除規則
    CASE g_lts.lts07
       #產品
       WHEN "1"
          SELECT imaacti,ima02 INTO l_imaacti,l_ima02 FROM ima_file
          WHERE ima01=g_ltu[l_ac1].ltu03
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_ima02 = NULL
               WHEN l_imaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case
          IF cl_null(g_errno) OR p_cmd='d' THEN
             LET g_ltu[l_ac1].ltu03_desc=l_ima02
             DISPLAY g_ltu[l_ac1].ltu03_desc TO name2
          END IF
       #產品分類
       WHEN "2"
          SELECT obaacti,oba02 INTO l_obaacti,l_oba02
            FROM oba_file
           WHERE oba01=g_ltu[l_ac1].ltu03
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_oba02 = NULL
               WHEN l_obaacti !='Y'   LET g_errno='9028'
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END CASE
          IF cl_null(g_errno) OR p_cmd='d' THEN
             LET g_ltu[l_ac1].ltu03_desc=l_oba02
             DISPLAY g_ltu[l_ac1].ltu03_desc TO name2
          END IF
       #品牌
       WHEN "3"
          SELECT tqa03,tqa02 INTO l_tqa03,l_tqa02 FROM tqa_file
          WHERE tqa01=g_ltu[l_ac1].ltu03 AND tqa03='2'
          CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                      LET l_tqa02 = NULL
               OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
          END case
          IF cl_null(g_errno) OR p_cmd='d' THEN
             LET g_ltu[l_ac1].ltu03_desc=l_tqa02
             DISPLAY g_ltu[l_ac1].ltu03_desc TO name2
          END IF

    END CASE

END FUNCTION

FUNCTION t661_b_fill(p_wc2)
DEFINE p_wc2   STRING

   LET g_sql = "SELECT ltt03,'',lttacti",
               "  FROM ltt_file",
               " WHERE ltt01 = '", g_lts.lts01,"' ",
               "   AND ltt02 = '", g_lts.lts02,"' ",
               "   AND ltt021 = '", g_lts.lts021,"' ",
               "   AND lttplant = '",g_lts.ltsplant,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ltt03 "

   DISPLAY g_sql

   PREPARE t661_pb FROM g_sql
   DECLARE ltt_cs CURSOR FOR t661_pb

   CALL g_ltt.clear()
   LET g_cnt = 1

   FOREACH ltt_cs INTO g_ltt[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CASE g_lts.lts06
          WHEN "1"
             SELECT ima02 INTO g_ltt[g_cnt].ltt03_desc FROM ima_file
              WHERE ima01=g_ltt[g_cnt].ltt03
          WHEN "2"
             SELECT oba02 INTO g_ltt[g_cnt].ltt03_desc FROM oba_file
                 WHERE oba01=g_ltt[g_cnt].ltt03
          WHEN "3"
             SELECT tqa02 INTO g_ltt[g_cnt].ltt03_desc FROM tqa_file
              WHERE tqa01=g_ltt[g_cnt].ltt03
                AND tqa03='2'

       END CASE
       DISPLAY g_ltt[g_cnt].ltt03_desc TO name1
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ltt.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt1
   LET g_cnt = 0

END FUNCTION

FUNCTION t661_b1_fill(p_wc2)
DEFINE p_wc2   STRING

   LET g_sql = "SELECT ltu03,'',ltuacti ",
               "  FROM ltu_file",
               " WHERE ltu01 = '",g_lts.lts01,"' ",
               "   AND ltu02 = '",g_lts.lts02,"' ",
               "   AND ltu021 = '",g_lts.lts021,"' ",
               "   AND ltuplant = '",g_lts.ltsplant,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ltu03 "

   DISPLAY g_sql

   PREPARE t661_pb_1 FROM g_sql
   DECLARE ltu_cs CURSOR FOR t661_pb_1

   CALL g_ltu.clear()
   LET g_cnt = 1

   FOREACH ltu_cs INTO g_ltu[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CASE g_lts.lts07
          WHEN "1"
             SELECT ima02 INTO g_ltu[g_cnt].ltu03_desc FROM ima_file
              WHERE ima01=g_ltu[g_cnt].ltu03
          WHEN "2"
             SELECT oba02 INTO g_ltu[g_cnt].ltu03_desc FROM oba_file
                 WHERE oba01=g_ltu[g_cnt].ltu03
          WHEN "3"
             SELECT tqa02 INTO g_ltu[g_cnt].ltu03_desc FROM tqa_file
              WHERE tqa01=g_ltu[g_cnt].ltu03
                AND tqa03='2'
       END CASE
       DISPLAY g_ltu[g_cnt].ltu03_desc TO name2
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ltu.deleteElement(g_cnt)

   LET g_rec_b1=g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cnt2
   LET g_cnt = 0
END FUNCTION

FUNCTION t661_x()
   DEFINE l_cnt LIKE type_file.num5

   LET l_cnt = 0

   IF s_shut(0) THEN
      RETURN
   END IF

   CALL t661_msg('invalid')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET g_action_choice = ""
   IF g_lts.ltsacti = 'N' THEN 
   #將無效改為有效時，檢查是否券種+生失效日期重複
      SELECT COUNT(*) INTO l_cnt
        FROM ltp_file
       WHERE ltp03 =g_lts.lts03
         AND (ltp04 BETWEEN g_lts.lts04 AND g_lts.lts05
          OR  ltp05 BETWEEN g_lts.lts04 AND g_lts.lts05
          OR (ltp04 <= g_lts.lts04 AND ltp05 >= g_lts.lts05))
         AND ltp11 = 'Y'
         AND ltpconf = 'Y'
         AND ltpacti = 'Y'
         AND ltp02 <> g_ltp.ltp02  
      IF l_cnt > 0 THEN
         CALL cl_err('','alm1999',0)
         RETURN   
      END IF
   END IF 
   BEGIN WORK

   OPEN t661_cl USING g_lts.lts01,g_lts.lts02,g_lts.lts021,g_lts.ltsplant
   IF STATUS THEN
      CALL cl_err("OPEN lts_cl:", STATUS, 1)
      CLOSE t661_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t661_cl INTO g_lts.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lts.lts01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL t661_show()

   IF cl_exp(0,0,g_lts.ltsacti) THEN                   #確認一下
      LET g_chr=g_lts.ltsacti
      IF g_lts.ltsacti='Y' THEN
         LET g_lts.ltsacti = 'N'
         LET g_lts.ltsmodu = g_user
      ELSE
         LET g_lts.ltsacti = 'Y'
         LET g_lts.ltsmodu = g_user
      END IF

      UPDATE lts_file SET ltsacti=g_lts.ltsacti,
                          ltsmodu=g_lts.ltsmodu,
                          ltsdate=g_today
       WHERE lts01 = g_lts.lts01
         AND lts02 = g_lts.lts02
         AND lts021 = g_lts.lts021
         AND ltsplant = g_lts.ltsplant

      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lts_file",g_lts.lts02,"",SQLCA.sqlcode,"","",1)
         LET g_lts.ltsacti=g_chr
      END IF
   END IF

   CLOSE t661_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT ltsacti,ltsmodu,ltsdate
     INTO g_lts.ltsacti,g_lts.ltsmodu,g_lts.ltsdate FROM lts_file
    WHERE lts01 = g_lts.lts01
      AND lts02 = g_lts.lts02
      AND lts021 = g_lts.lts021
      AND ltsplant = g_lts.ltsplant

   DISPLAY BY NAME g_lts.ltsmodu,g_lts.ltsdate,g_lts.ltsacti
   CALL t661_pic()

END FUNCTION

FUNCTION t661_msg(p_cmd)
   DEFINE p_cmd LIKE type_file.chr30

   IF cl_null(g_lts.lts07) THEN
      LET g_errno = '-400'          #請先選取欲處理的資料
      RETURN
   END IF

   IF p_cmd <> 'eff_plant' THEN
      IF g_lts.lts01 <> g_plant THEN
         LET g_errno = 'art-977'       #目前在營運中心不是制定營運中心,不可修改
         RETURN
      END IF

      IF g_lts.lts11 = 'Y' THEN
         LET g_errno = 'alm-h55'       #F已發佈,不可修改
         RETURN
      END IF
   END IF

   IF p_cmd = 'conf' THEN
      IF g_lts.ltsconf ='Y' THEN    #已確認
         LET g_errno = '1208'
         RETURN
      END IF
      IF g_lts.ltsacti='N' THEN
         LET g_errno = 'alm-048'    #資料無效,不可確認
         RETURN
      END IF 
   END IF

   IF p_cmd = 'unconf' THEN
      IF g_lts.ltsacti='N' THEN
         LET g_errno = 'alm-973'    #資料無效,不可取消確認
         RETURN
      END IF

      IF g_lts.ltsconf ='N' THEN
         LET g_errno = '9025'       #尚未確認,不可取消確認
         RETURN
      END IF
   END IF

   IF p_cmd = 'release' THEN
      IF g_lts.lts11 = 'Y' THEN
         LET g_errno = 'alm-h63'    #已發佈
         RETURN
      END IF

      IF g_lts.ltsacti = 'N' THEN
         LET g_errno = 'alm-h60'    #資料無效,不可發佈
         RETURN
      END IF

      IF g_lts.ltsconf = 'N' THEN
         LET g_errno = 'alm-h64'    #資料未確定,不可發佈
         RETURN
      END IF
   END IF

   IF p_cmd = 'mod' THEN
      IF g_lts.lts11 = 'Y' THEN     #已發佈時不允許修改
         LET g_errno = 'alm-h55'
         RETURN
      END IF

      IF g_lts.ltsconf = 'Y' THEN   #已確認時不允許修改
         LET g_errno = 'alm-027'
         RETURN
      END IF
      IF g_lts.ltsacti = 'N' THEN
         LET g_errno = 'alm-069'
         RETURN
      END IF 
   END IF
   IF p_cmd = 'del' THEN
      IF g_lts.lts11 = 'Y' THEN     #已發佈時不允許修改
         LET g_errno = 'alm-h55'
         RETURN
      END IF

      IF g_lts.ltsconf = 'Y' THEN   #已確認時不允許修改
         LET g_errno = 'alm-027'
         RETURN
      END IF
      IF g_lts.ltsacti = 'N' THEN
         LET g_errno = 'alm-069'
         RETURN
      END IF
   END IF  
   IF p_cmd = 'invalid' THEN
      IF g_lts.lts11 = 'Y' THEN     #已發佈時不允許修改
         LET g_errno = 'alm-h55'
         RETURN
      END IF

      IF g_lts.ltsconf = 'Y' THEN   #已確認時不允許修改
         LET g_errno = 'alm-027'
         RETURN
      END IF
   END IF
 
   LET g_errno = NULL
END FUNCTION
#生效營運中心
FUNCTION t661_eff_plant()
   CALL t661_msg('eff_plant')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET g_action_choice = ""

  #CALL t555_sub2(g_lts.lts01,g_lts.lts02,'3',g_lts.lts03,g_lts.lts021)   #FUN-D10117 mark
   CALL t555_sub2(g_lts.lts01,g_lts.lts02,'4',g_lts.lts03,g_lts.lts021)     #FUN-D10117 add
END FUNCTION

FUNCTION t661_conf()
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_gen02   LIKE gen_file.gen02
   CALL t661_msg('conf')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF
   #檢查生效營運中心存在
   SELECT COUNT(*) INTO l_cnt FROM ltn_file
    WHERE ltn01 = g_lts.lts01
      AND ltn02 = g_lts.lts02
     #AND ltn03 = '3'           #FUN-D10117 mark
      AND ltn03 = '4'             #FUN-D10117 add
      AND ltn08 = g_lts.lts021
      AND ltnplant = g_lts.ltsplant

   IF l_cnt = 0 THEN
      CALL cl_err('','art-546',0)
      RETURN
   END IF
  #檢查生效營運中心是否存在制定營運中心
   SELECT COUNT(*) INTO l_cnt FROM ltn_file
    WHERE ltn01 = g_lts.lts01
      AND ltn02 = g_lts.lts02
     #AND ltn03 = '3'           #FUN-D10117 mark
      AND ltn03 = '4'             #FUN-D10117 add
      AND ltn04 = g_lts.ltsplant
      AND ltn08 = g_lts.lts021
      AND ltnplant = g_lts.ltsplant

   IF l_cnt = 0 THEN
      CALL cl_err('','alm-h42',0)
      RETURN
   END IF
   #檢查生效營運中心與券種生效範圍
   SELECT COUNT(*) INTO l_cnt FROM ltn_file
    WHERE ltn01 = g_lts.lts01
      AND ltn02 = g_lts.lts02
     #AND ltn03 = '3'            #FUN-D10117 mark
      AND ltn03 = '4'             #FUN-D10117 add
      AND ltn08 = g_lts.lts021
      AND ltn04 NOT IN (SELECT lnk03 FROM lnk_file
                         WHERE lnk01 = g_lts.lts03
                           AND lnk05 = 'Y' )

   IF l_cnt > 0 THEN
      CALL cl_err('','alm1641',0)
      RETURN
   END IF
   CALL t661_ckmult('c')
   IF g_success = 'N' THEN RETURN END IF

   IF NOT cl_confirm('axm-108') THEN RETURN END IF

   LET g_action_choice = ""
   LET g_success = 'Y'

   UPDATE lts_file
      SET ltscond = g_today,
          ltscont = g_time,
          ltsconf = 'Y',
          ltsconu = g_user,
          ltsdate = g_today,
          ltsmodu = g_user
    WHERE lts01 = g_lts.lts01 AND lts02 = g_lts.lts02
      AND lts021 = g_lts.lts021 AND ltsplant = g_plant

   IF SQLCA.sqlcode THEN
       LET g_success = 'N'
      CALL cl_err3("upd","lts_file",g_lts.lts02,"",SQLCA.sqlcode,"","lts01",1)
      ROLLBACK WORK
      RETURN
   ELSE
      LET g_lts.ltscond = g_today
      LET g_lts.ltscont = g_time
      LET g_lts.ltsconf = 'Y'
      LET g_lts.ltsconu = g_user
      LET g_lts.ltsdate = g_today
      LET g_lts.ltsmodu = g_user
      SELECT gen02 INTO l_gen02 FROM gen_file
       WHERE gen01 = g_lts.ltsconu
      DISPLAY l_gen02 TO gen02
      DISPLAY BY NAME g_lts.ltscond
      DISPLAY BY NAME g_lts.ltscont
      DISPLAY BY NAME g_lts.ltsconf
      DISPLAY BY NAME g_lts.ltsconu
      DISPLAY BY NAME g_lts.ltsdate
      DISPLAY BY NAME g_lts.ltsmodu

      CALL t661_pic()

      COMMIT WORK
   END IF
END FUNCTION

FUNCTION t661_ckmult(p_cmd)
   DEFINE l_sql        STRING
   DEFINE l_ltn04      LIKE ltn_file.ltn04
   DEFINE l_n          LIKE type_file.num5
   DEFINE p_cmd        LIKE type_file.chr1
   LET g_success = 'Y'
   IF cl_null(g_lts.lts03) THEN 
      RETURN 
   END IF    
   CALL s_showmsg_init()
   
   LET l_sql = "SELECT DISTINCT ltn04 FROM ltn_file WHERE ltn01 = '",g_lts.lts01 CLIPPED,"' ",
               "    AND ltn02 = '",g_lts.lts02 CLIPPED,"' " ,
               "    AND ltn08 =  ",g_lts.lts021 CLIPPED,"  ",
               "    AND ltnplant = '",g_lts.ltsplant,"' "

   PREPARE ltn_pre1 FROM l_sql
   DECLARE ltn_cs1 CURSOR FOR ltn_pre1
   FOREACH ltn_cs1 INTO l_ltn04
      IF cl_null(l_ltn04) THEN
         CONTINUE FOREACH
      END IF
      LET l_n = 0 
      LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_ltn04, 'ltp_file'),
                  " WHERE ltp03 = '",g_lts.lts03,"'",
                  "   AND (ltp04 BETWEEN '",g_lts.lts04 ,"' AND '",g_lts.lts05 ,"' ",
                  "    OR ltp05 BETWEEN '",g_lts.lts04,"' AND '",g_lts.lts05,"' ",
                  "    OR (ltp04 <= '",g_lts.lts04 ,"' AND ltp05 >= '",g_lts.lts05,"')) ",
                  "   AND ltp11 = 'Y' AND ltpconf = 'Y' AND ltpacti = 'Y' ",
                  "   AND ltp02 <> '",g_lts.lts02,"'",
                  "   AND ltpplant = '",l_ltn04,"'"
      PREPARE ltp_cnt1 FROM l_sql
      EXECUTE ltp_cnt1 INTO l_n
      IF l_n > 0 THEN
         CALL s_errmsg('ltp04',l_ltn04,l_ltn04,'alm1642',1)
         LET g_success = 'N'
      END IF
         #判斷營運中心是否符合券種生效營運中心
      LET l_n = 0
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_ltn04, 'lnk_file'),
                  "   WHERE lnk01 = '",g_lts.lts03,"'  AND lnk02 = '2' AND lnk05 = 'Y' ",
                  "      AND lnk03 = '",l_ltn04,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_ltn04 ) RETURNING l_sql
      PREPARE lnk_cnt1 FROM l_sql
      EXECUTE lnk_cnt1 INTO l_n
      
      IF l_n = 0 OR cl_null(l_n) THEN
         CALL s_errmsg('ltn04',l_ltn04,l_ltn04,'alm1643',1)
         LET g_success = 'N'
      END IF
   END FOREACH

   CALL s_showmsg()
END FUNCTION

FUNCTION t661_unconf()
   DEFINE l_cnt LIKE type_file.num5
   DEFINE l_gen02    LIKE gen_file.gen02     #CHI-D20015

   CALL t661_msg('unconf')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   LET g_action_choice = ""

   IF cl_confirm('aap-224') THEN
      BEGIN WORK
    # UPDATE lts_file SET ltscond = NULL,      #CHI-D20015 mark
                      #   ltscont = NULL,      #CHI-D20015 mark
      UPDATE lts_file SET ltscond = g_today,   #CHI-D20015  
                          ltscont = g_time,    #CHI-D20015
                          ltsconf = 'N',
                      #   ltsconu = NULL,      #CHI-D20015 mark
                          ltsconu = g_user,    #CHI-D20015
                          ltsdate = g_today,
                          ltsmodu = g_user
       WHERE lts01 = g_lts.lts01
         AND lts02 = g_lts.lts02
         AND lts021 = g_lts.lts021
         AND ltsplant = g_lts.ltsplant

      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","lts_file",g_lts.lts02,"",SQLCA.sqlcode,"","lts02",1)
         ROLLBACK WORK
      ELSE
         COMMIT WORK

      #  LET g_lts.ltscond = NULL     #CHI-D20015
         LET g_lts.ltscond = g_today  #CHI-D20015
      #  LET g_lts.ltscont = NULL     #CHI-D20015
         LET g_lts.ltscont = g_time   #CHI-D20015
         LET g_lts.ltsconf = 'N'
      #  LET g_lts.ltsconu = NULL     #CHI-D20015 
         LET g_lts.ltsconu = g_user   #CHI-D20015
         LET g_lts.ltsdate = g_today
         LET g_lts.ltsmodu = g_user
         DISPLAY BY NAME g_lts.ltscond
         DISPLAY BY NAME g_lts.ltscont
         DISPLAY BY NAME g_lts.ltsconf
         DISPLAY BY NAME g_lts.ltsconu
         DISPLAY BY NAME g_lts.ltsdate
         DISPLAY BY NAME g_lts.ltsmodu
      #  DISPLAY '' TO gen02    #CHI-D20015 mark
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lts.ltsconu  #CHI-D20015
         DISPLAY l_gen02 TO gen02   #CHI-D20015
         CALL t661_pic()
      END IF
   END IF

END FUNCTION
#發佈
FUNCTION t661_release()
   DEFINE l_ltn04 LIKE ltn_file.ltn04,
          l_ltn07 LIKE ltn_file.ltn07
   DEFINE l_azw02                             LIKE azw_file.azw02
   DEFINE l_sql                               STRING
   DEFINE l_lts    RECORD                     LIKE lts_file.*,
          l_ltt    DYNAMIC ARRAY OF RECORD    LIKE ltt_file.*,
          l_ltu    DYNAMIC ARRAY OF RECORD    LIKE ltu_file.*,
          l_ltn    DYNAMIC ARRAY OF RECORD    LIKE ltn_file.*

   DEFINE l_cnt                               LIKE type_file.num5
   DEFINE l_max_rec                           LIKE type_file.num5
   DEFINE l_rec                               LIKE type_file.num5
   DEFINE l_ltppos                            LIKE ltp_file.ltppos

   LET g_action_choice = ""
   LET g_success = 'Y'
   CALL t661_msg('release')
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   CALL t661_ckmult('r')
   IF g_success = 'N' THEN RETURN END IF

   IF NOT cl_confirm('art-660') THEN
      RETURN
   END IF
   CALL s_showmsg_init()
   BEGIN WORK
   IF g_success = 'Y' THEN
      #依變更生效營運中心清單將變更單複製到各營運中心下,並回寫至規則單
      LET l_sql = "SELECT ltn04,ltn07 FROM ltn_file WHERE ltn01 = '",g_lts.lts01 CLIPPED,"' ",
                 "    AND ltn02 = '",g_lts.lts02 CLIPPED,"' " ,
                 "    AND ltn08 =  ",g_lts.lts021 CLIPPED,"  ",
                 "    AND ltnplant = '",g_lts.ltsplant,"' "

      PREPARE ltl_pre1 FROM l_sql
      DECLARE ltl_cs1 CURSOR FOR ltl_pre1
      FOREACH ltl_cs1 INTO l_ltn04,l_ltn07
         IF cl_null(l_ltn04) THEN
            CONTINUE FOREACH
         END IF
         SELECT azw02 INTO l_azw02 FROM azw_file WHERE azw01 = l_ltn04

         SELECT * INTO l_lts.* FROM lts_file WHERE lts01 = g_lts.lts01 AND lts02 = g_lts.lts02
                                               AND lts021 = g_lts.lts021 AND ltsplant = g_lts.ltsplant

         LET l_lts.ltsacti  = l_ltn07
         LET l_lts.ltslegal = l_azw02
         LET l_lts.ltsplant = l_ltn04
         LET l_lts.lts11 = 'Y'
         LET l_lts.lts12 = g_today
         LET g_lts021_o = g_lts.lts021 - 1  
         #積分/折扣規則變更單頭檔   所有的營運中心
         IF g_success = 'Y' THEN
            #先查詢pos然後再做處理
            LET l_sql = "SELECT ltppos FROM ",cl_get_target_table(l_ltn04, 'ltp_file'),
                        " WHERE ltp01 = '",l_lts.lts01,"' ",
                        "   AND ltp02 = '",l_lts.lts02,"' ",
                        "   AND ltp021 =  ",g_lts021_o,
                        "   AND ltpplant ='",l_lts.ltsplant,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
            PREPARE trans_sel_ltp FROM l_sql
            EXECUTE trans_sel_ltp INTO l_ltppos
            #營運中心存在當前規則單號資料
            IF NOT cl_null(l_ltppos) THEN
               IF l_ltppos = '1' THEN
                  LET l_ltppos = '1'
               ELSE
                  LET l_ltppos = '2'
               END IF
               #刪除原資料
               LET l_sql = "DELETE FROM ",cl_get_target_table(l_ltn04, 'ltp_file'),
                           " WHERE ltp01 = '",l_lts.lts01,"' ",
                           "   AND ltp02 = '",l_lts.lts02,"' ",
                           "   AND ltp021 =  ",g_lts021_o,
                           "   AND ltpplant ='",l_lts.ltsplant,"' "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
               PREPARE trans_del_ltp FROM l_sql
               EXECUTE trans_del_ltp
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                  CALL s_errmsg('','','DELETE ltp_file:',SQLCA.sqlcode,1)
                  ROLLBACK WORK
                  EXIT FOREACH
               ELSE
                  DISPLAY 'Delete ltp_file Where ltp07 = ',l_lts.lts02
               END IF
            #營運中心不存在當前單號資料
            ELSE
               LET l_ltppos = '1'
            END IF
         END IF

         IF g_success = 'Y' THEN
            #寫入收券規則單頭檔
             LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'ltp_file'),
                        "            (ltp01,ltp02,ltp021,ltp03,ltp04,ltp05,ltppos,ltp06,ltp07,ltp08,ltp09,ltp10,",
                        "             ltp11,ltp12,ltpacti,ltpcond,ltpcont,ltpconf,ltpconu,ltpcrat,ltpdate,ltpgrup,",
                        "             ltplegal,ltpmodu,ltporig,ltporiu,ltpplant,ltpuser)",
                        "      VALUES('",l_lts.lts01,"','",l_lts.lts02,"','",l_lts.lts021,"','",l_lts.lts03,"','",l_lts.lts04,"','",l_lts.lts05,"','",l_ltppos,"', ",
                        "             '",l_lts.lts06,"','",l_lts.lts07,"','",l_lts.lts08,"',",l_lts.lts09,",",l_lts.lts10,",'",l_lts.lts11,"',",
                        "             '",l_lts.lts12,"','",l_lts.ltsacti,"','",l_lts.ltscond,"','",l_lts.ltscont,"','",l_lts.ltsconf,"','",l_lts.ltsconu,"',",
                        "             '",l_lts.ltscrat,"','",l_lts.ltsdate,"','",l_lts.ltsgrup,"','",l_lts.ltslegal,"','",l_lts.ltsmodu,"', ",
                        "             '",l_lts.ltsorig,"','",l_lts.ltsoriu,"','",l_lts.ltsplant,"','",l_lts.ltsuser,"')"

            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
            PREPARE trans_ins_ltp FROM l_sql
            EXECUTE trans_ins_ltp
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','INSERT INTO ltp_file:',SQLCA.sqlcode,1)
               ROLLBACK WORK
               EXIT FOREACH
            ELSE
               DISPLAY 'Insert: lts_file: ',l_lts.lts02,' for plant:  ',l_ltn04
            END IF
         END IF
         #在非當前營運中心增加資料
         IF g_success = 'Y' AND g_lts.ltsplant <> l_ltn04 THEN
             LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'lts_file'),
                        "            (lts01,lts02,lts021,lts03,lts04,lts05,lts06,lts07,lts08,lts09,lts10,",
                        "             lts11,lts12,ltsacti,ltscond,ltscont,ltsconf,ltsconu,ltscrat,ltsdate,ltsgrup,",
                        "             ltslegal,ltsmodu,ltsorig,ltsoriu,ltsplant,ltsuser)",
                        "      VALUES('",l_lts.lts01,"','",l_lts.lts02,"','",l_lts.lts021,"','",l_lts.lts03,"','",l_lts.lts04,"','",l_lts.lts05,"',",
                        "             '",l_lts.lts06,"','",l_lts.lts07,"','",l_lts.lts08,"',",l_lts.lts09,",",l_lts.lts10,",'",l_lts.lts11,"',",
                        "             '",l_lts.lts12,"','",l_lts.ltsacti,"','",l_lts.ltscond,"','",l_lts.ltscont,"','",l_lts.ltsconf,"','",l_lts.ltsconu,"',",
                        "             '",l_lts.ltscrat,"','",l_lts.ltsdate,"','",l_lts.ltsgrup,"','",l_lts.ltslegal,"','",l_lts.ltsmodu,"', ",
                        "             '",l_lts.ltsorig,"','",l_lts.ltsoriu,"','",l_lts.ltsplant,"','",l_lts.ltsuser,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
            PREPARE trans_ins_lts FROM l_sql
            EXECUTE trans_ins_lts
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','INSERT INTO lts_file:',SQLCA.sqlcode,1)
               ROLLBACK WORK
               EXIT FOREACH
            ELSE
               DISPLAY 'Insert: lts_file: ',l_lts.lts02,' for plant:  ',l_ltn04
            END IF
         END IF

         #第一單身收券規則
         IF g_success = 'Y' THEN
            LET l_sql = "DELETE FROM ",cl_get_target_table(l_ltn04, 'ltq_file'),
                        " WHERE ltq01 = '",l_lts.lts01,"' ",
                        "   AND ltq02 = '",l_lts.lts02,"' ",
                        "   AND ltqplant ='",l_lts.ltsplant,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
            PREPARE trans_del_ltq FROM l_sql
            EXECUTE trans_del_ltq
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','DELETE ltq_file:',SQLCA.sqlcode,1)
               ROLLBACK WORK
               EXIT FOREACH
            ELSE
               DISPLAY 'Delete ltq_file, ltq02 : ',l_lts.lts02
            END IF
         END IF
         IF g_success = 'Y' THEN
            SELECT COUNT(*) INTO l_max_rec FROM ltt_file
            WHERE ltt01 = g_lts.lts01 AND ltt02 = g_lts.lts02
              AND ltt021 = g_lts.lts021 AND lttplant = g_lts.ltsplant
            LET l_rec = 1
            LET l_sql = "SELECT * FROM ",cl_get_target_table(g_lts.ltsplant, 'ltt_file'),
                        " WHERE ltt01 = '",g_lts.lts01,"' ",
                        "   AND ltt02 = '",g_lts.lts02,"' ",
                        "   AND ltt021 = '",g_lts.lts021,"' ",
                        "   AND lttplant = '",g_lts.ltsplant,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, g_lts.ltsplant) RETURNING l_sql
            PREPARE ltt_sur FROM l_sql
            DECLARE ltt_ins_sur CURSOR FOR ltt_sur
            FOREACH ltt_ins_sur INTO l_ltt[l_rec].*
               LET l_ltt[l_rec].lttlegal = l_azw02
               LET l_ltt[l_rec].lttplant = l_ltn04
               #非當前營運中心
               IF g_success = 'Y' AND g_lts.ltsplant <> l_ltn04 THEN
                  #寫入收券規則變更單身檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'ltt_file'),
                              "      (ltt01,ltt02,ltt021,ltt03,lttacti,lttlegal,lttplant) ",
                              "VALUES('",l_ltt[l_rec].ltt01,"','",l_ltt[l_rec].ltt02,"', '",l_ltt[l_rec].ltt021,"',",
                              "       '",l_ltt[l_rec].ltt03,"','",l_ltt[l_rec].lttacti,"',",
                              "       '",l_ltt[l_rec].lttlegal,"','",l_ltt[l_rec].lttplant,"' )"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, g_lts.ltsplant) RETURNING l_sql
                  PREPARE trans_ins_ltt2 FROM l_sql
                  EXECUTE trans_ins_ltt2
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'
                     CALL s_errmsg('','','INSERT INTO ltt_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: ltt_file: ',l_ltt[l_rec].ltt03,' for plant:  ',l_ltn04
                  END IF
               END IF

               IF g_success = 'Y' THEN
                  #寫入收券規則單身檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'ltq_file'),
                              "      (ltq01,ltq02,ltq03,ltqacti,ltqlegal,ltqplant) ",
                              "VALUES('",l_ltt[l_rec].ltt01,"','",l_ltt[l_rec].ltt02,"', ",
                              "       '",l_ltt[l_rec].ltt03,"','",l_ltt[l_rec].lttacti,"',",
                              "       '",l_ltt[l_rec].lttlegal,"','",l_ltt[l_rec].lttplant,"' )"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, g_lts.ltsplant) RETURNING l_sql
                  PREPARE trans_ins_ltq FROM l_sql
                  EXECUTE trans_ins_ltq
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'
                     CALL s_errmsg('','','INSERT INTO ltq_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: ltq_file: ',l_ltt[l_rec].ltt02,' for plant:  ',l_ltn04
                  END IF
               END IF
               IF l_rec = l_max_rec THEN
                  EXIT FOREACH
               ELSE
                  IF g_success = 'Y' THEN
                     LET l_rec = l_rec + 1
                  END IF
               END IF
            END FOREACH
         END IF

         #排除明細
         IF g_success = 'Y' THEN
            #刪除原來資料
            LET l_sql = "DELETE FROM ",cl_get_target_table(l_ltn04, 'ltr_file'),
                        " WHERE ltr01 = '",l_lts.lts01,"' ",
                        "   AND ltr02 = '",l_lts.lts02,"' ",
                        "   AND ltrplant ='",l_lts.ltsplant,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
            PREPARE trans_del_ltr FROM l_sql
            EXECUTE trans_del_ltr
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','DELETE ltr_file:',SQLCA.sqlcode,1)
               ROLLBACK WORK
               EXIT FOREACH
            ELSE
               DISPLAY 'Delete ltr_file, ltr02 : ',l_lts.lts02
            END IF
         END IF
         IF g_success = 'Y' THEN
            SELECT COUNT(*) INTO l_max_rec FROM ltu_file
            WHERE ltu01 = g_lts.lts01 AND ltu02 = g_lts.lts02
              AND ltu021 = g_lts.lts021 AND ltuplant = g_lts.ltsplant
            LET l_rec = 1
            LET l_sql = "SELECT * FROM ",cl_get_target_table(g_lts.ltsplant, 'ltu_file'),
                        " WHERE ltu01 = '",g_lts.lts01,"' ",
                        "   AND ltu02 = '",g_lts.lts02,"' ",
                        "   AND ltu021 = '",g_lts.lts021,"' ",
                        "   AND ltuplant = '",g_lts.ltsplant,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, g_lts.ltsplant) RETURNING l_sql
            PREPARE ltu_sur FROM l_sql
            DECLARE ltu_ins_sur CURSOR FOR ltu_sur
            FOREACH ltu_ins_sur INTO l_ltu[l_rec].*
               LET l_ltu[l_rec].ltulegal = l_azw02
               LET l_ltu[l_rec].ltuplant = l_ltn04

               IF g_success = 'Y' AND g_lts.ltsplant <> l_ltn04 THEN
                  #寫入收券規則變更單身檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'ltu_file'),
                              "      (ltu01,ltu02,ltu021,ltu03,ltuacti,ltulegal,ltuplant) ",
                              "VALUES('",l_ltu[l_rec].ltu01,"','",l_ltu[l_rec].ltu02,"', '",l_ltu[l_rec].ltu021,"',",
                              "       '",l_ltu[l_rec].ltu03,"','",l_ltu[l_rec].ltuacti,"',",
                              "       '",l_ltu[l_rec].ltulegal,"','",l_ltu[l_rec].ltuplant,"' )"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, g_lts.ltsplant) RETURNING l_sql
                  PREPARE trans_ins_ltu2 FROM l_sql
                  EXECUTE trans_ins_ltu2
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'
                     CALL s_errmsg('','','INSERT INTO ltu_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: ltu_file: ',l_ltu[l_rec].ltu03,' for plant:  ',l_ltn04
                  END IF
               END IF

               IF g_success = 'Y' THEN
                  #寫入收券規則單身檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'ltr_file'),
                              "      (ltr01,ltr02,ltr03,ltracti,ltrlegal,ltrplant)  ",
                              "VALUES('",l_ltu[l_rec].ltu01,"','",l_ltu[l_rec].ltu02,"', ",
                              "       '",l_ltu[l_rec].ltu03,"','",l_ltu[l_rec].ltuacti,"',",
                              "       '",l_ltu[l_rec].ltulegal,"','",l_ltu[l_rec].ltuplant,"' )"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, g_lts.ltsplant) RETURNING l_sql
                  PREPARE trans_ins_ltr FROM l_sql
                  EXECUTE trans_ins_ltr
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'
                     CALL s_errmsg('','','INSERT INTO ltr_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: ltr_file: ',l_ltu[l_rec].ltu02,' for plant:  ',l_ltn04
                  END IF
               END IF
               IF l_rec = l_max_rec THEN
                  EXIT FOREACH
               ELSE
                  IF g_success = 'Y' THEN
                     LET l_rec = l_rec + 1
                  END IF
               END IF
            END FOREACH
         END IF
         #生效營運中心
         IF g_success = 'Y' THEN
            LET l_sql = "DELETE FROM ",cl_get_target_table(l_ltn04, 'lso_file'),
                        " WHERE lso01 = '",l_lts.lts01,"' ",
                        "   AND lso02 = '",l_lts.lts02,"' ",
                        "   AND lso03 = '3' ",
                        "   AND lsoplant ='",l_lts.ltsplant,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
            PREPARE trans_del_lso FROM l_sql
            EXECUTE trans_del_lso
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('','','DELETE lso_file:',SQLCA.sqlcode,1)
               ROLLBACK WORK
               EXIT FOREACH
            ELSE
               DISPLAY 'Delete lso_file,lso02: ',l_lts.lts02
            END IF
         END IF
         IF g_success = 'Y' THEN
            SELECT COUNT(*) INTO l_max_rec FROM ltn_file
            WHERE ltn01 = g_lts.lts01 AND ltn02 = g_lts.lts02
            AND ltn08 = g_lts.lts021 AND ltnplant = g_lts.ltsplant
            LET l_rec = 1
            LET l_sql = "SELECT * FROM ",cl_get_target_table(g_lts.ltsplant, 'ltn_file'),
                        " WHERE ltn01 = '",g_lts.lts01,"' ",
                        "   AND ltn02 = '",g_lts.lts02,"' ",
                        "   AND ltn08 =  ",g_lts.lts021,"  ",
                        "   AND ltnplant = '", g_lts.ltsplant,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, g_lts.ltsplant) RETURNING l_sql
            PREPARE ltn_sur FROM l_sql
            DECLARE ltn_ins_sur CURSOR FOR ltn_sur
            FOREACH ltn_ins_sur INTO l_ltn[l_rec].*
               LET l_ltn[l_rec].ltnlegal = l_azw02
               LET l_ltn[l_rec].ltnplant = l_ltn04

               IF g_success = 'Y' AND g_lts.ltsplant <> l_ltn04 THEN
                  #寫入收券規則生效營運中心變更檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'ltn_file'),
                              "      (ltn01,ltn02,ltn03,ltn04,ltn05,ltn06,ltn07,ltn08,ltnlegal,ltnplant) ",
                              "VALUES('",l_ltn[l_rec].ltn01,"','",l_ltn[l_rec].ltn02,"','",l_ltn[l_rec].ltn03,"','",l_ltn[l_rec].ltn04,"','",l_ltn[l_rec].ltn05,"',",
                              "       '",l_ltn[l_rec].ltn06,"','",l_ltn[l_rec].ltn07,"','",l_ltn[l_rec].ltn08,"','",l_ltn[l_rec].ltnlegal,"','",l_ltn[l_rec].ltnplant,"')"

                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
                  PREPARE trans_ins_ltn2 FROM l_sql
                  EXECUTE trans_ins_ltn2
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'
                     CALL s_errmsg('','','INSERT INTO ltn_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: ltn_file: ',l_ltn[l_rec].ltn03,' for plant:  ',l_ltn04
                  END IF
               END IF

               IF g_success = 'Y' THEN
                  #寫入收券規則生效營運中心檔
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_ltn04, 'lso_file'),
                              "           (lso01,lso02,lso03,lso04,lso05,lso06,lso07,lsolegal,lsoplant) ",
                              "VALUES('",l_ltn[l_rec].ltn01,"','",l_ltn[l_rec].ltn02,"','",l_ltn[l_rec].ltn03,"','",l_ltn[l_rec].ltn04,"','",l_ltn[l_rec].ltn05,"',",
                              "       '",l_ltn[l_rec].ltn06,"','",l_ltn[l_rec].ltn07,"','",l_ltn[l_rec].ltnlegal,"','",l_ltn[l_rec].ltnplant,"')"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_ltn04) RETURNING l_sql
                  PREPARE trans_ins_lso FROM l_sql
                  EXECUTE trans_ins_lso
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'
                     CALL s_errmsg('','','INSERT INTO ltn_file:',SQLCA.sqlcode,1)
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     DISPLAY 'Insert: lso_file: ',l_ltn[l_rec].ltn03,' for plant:  ',l_ltn04
                  END IF
               END IF

               IF l_rec = l_max_rec THEN
                  EXIT FOREACH
               ELSE
                  IF g_success = 'Y' THEN
                     LET l_rec = l_rec + 1
                  END IF
               END IF
            END FOREACH
         END IF
      END FOREACH
   END IF
   IF g_success = 'N' THEN
      CALL s_showmsg()
      RETURN
   END IF
   UPDATE lts_file
      SET
          ltsdate = g_today,
          ltsmodu = g_user,
          lts11 = 'Y',
          lts12 = g_today
    WHERE lts01 = g_lts.lts01 AND lts02 = g_lts.lts02
      AND lts021 = g_lts.lts021 AND ltsplant = g_plant

   IF SQLCA.sqlcode THEN
       LET g_success = 'N'
      CALL cl_err3("upd","lts_file",g_lts.lts02,"",SQLCA.sqlcode,"","lts01",1)
      ROLLBACK WORK
      RETURN
   ELSE
      LET g_lts.lts11 = 'Y'
      LET g_lts.lts12 = g_today

      DISPLAY BY NAME g_lts.lts11
      DISPLAY BY NAME g_lts.lts12

      CALL t661_pic()

      COMMIT WORK
   END IF
END FUNCTION

FUNCTION t661_delall()

   DEFINE l_ltt_cnt  LIKE type_file.num5,
          l_ltu_cnt  LIKE type_file.num5

   SELECT COUNT(*) INTO l_ltt_cnt FROM ltt_file
    WHERE ltt01    = g_lts.lts01
      AND ltt02    = g_lts.lts02
      AND ltt021    = g_lts.lts021
      AND lttplant = g_lts.ltsplant

   SELECT COUNT(*) INTO l_ltu_cnt FROM ltu_file
    WHERE ltu01    = g_lts.lts01
      AND ltu02    = g_lts.lts02
      AND ltu021    = g_lts.lts021
      AND ltuplant = g_lts.ltsplant
   IF l_ltt_cnt =0 AND l_ltu_cnt = 0 THEN                #第一單身及第二單身都沒有資料時刪除單頭
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED

      DELETE FROM ltn_file
            WHERE ltn01    = g_lts.lts01
              AND ltn02    = g_lts.lts02
              AND ltn08    = g_lts.lts021
              AND ltnplant = g_lts.ltsplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("DELETE ","ltn_file",g_lts.lts02,"",SQLCA.sqlcode,"","ltt",1)
      END IF

      DELETE FROM lts_file
            WHERE lts01    = g_lts.lts01
              AND lts02    = g_lts.lts02
              AND lts021    = g_lts.lts021
              AND ltsplant = g_lts.ltsplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("DELETE ","lts_file",g_lts.lts02,"",SQLCA.sqlcode,"","ltt",1)
      END IF

      CLEAR FORM
      INITIALIZE g_lts.* TO NULL
   END IF
END FUNCTION

FUNCTION t661_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lts02",TRUE)
    END IF
END FUNCTION

FUNCTION t661_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lts02",FALSE)
    END IF

END FUNCTION
FUNCTION t661_refresh()
   DISPLAY ARRAY g_ltt TO s_ltt.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY

   DISPLAY ARRAY g_ltu TO s_ltu.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY

END FUNCTION

FUNCTION t661_pic()
   CASE g_lts.ltsconf
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void = ''
      OTHERWISE LET g_confirm = ''
                LET g_void = ''
   END CASE

   #圖形顯示
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lts.ltsacti)
END FUNCTION
#FUN-CC0058------add----str
FUNCTION t661_chk_ltppos(p_ltu03,p_type)
DEFINE l_sql          STRING
DEFINE l_n            LIKE type_file.num10
DEFINE p_type         LIKE type_file.chr1
DEFINE p_ltu03        LIKE ltu_file.ltu03
DEFINE l_ltn04        LIKE ltn_file.ltn04

   IF g_aza.aza88 ='N' THEN
      RETURN TRUE
   END IF
   LET l_sql = "SELECT ltn04 FROM ltn_file",
               " WHERE ltn01 = '",g_lts.lts01,"'",
               "   AND ltn02 = '",g_lts.lts02,"'",
               "   AND ltn08 = '",g_lts.lts021,"'",
               "   AND ltnplant = '",g_lts.ltsplant,"'",
              #"   AND ltn03 = '3'"                #FUN-D10117 mark
               "   AND ltn03 = '4'"                  #FUN-D10117 add
   DECLARE t661_chk_cs CURSOR FROM l_sql
   FOREACH t661_chk_cs INTO l_ltn04
      LET l_n = 0
      IF p_type = '1' THEN
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_ltn04,"ltp_file"),",",
                                             cl_get_target_table(l_ltn04,"ltq_file"),
                     "  WHERE ltp01 = '",g_lts.lts01,"'",
                     "    AND ltp02  = '",g_lts.lts02,"'",
                     "    AND ltpplant = '",l_ltn04,"'",
                     "    AND ltp01 = ltq01 AND ltp02 = ltq02 AND ltpplant = ltqplant",
                     "    AND ltq03 = '",p_ltu03,"'",
                     "    AND (ltppos = '2' OR (ltppos = '3' AND ltqacti = 'Y'))"
      ELSE
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_ltn04,"ltp_file"),",",
                                             cl_get_target_table(l_ltn04,"ltr_file"),
                     "  WHERE ltp01 = '",g_lts.lts01,"'",
                     "    AND ltp02  = '",g_lts.lts02,"'",
                     "    AND ltpplant = '",l_ltn04,"'",
                     "    AND ltp01 = ltr01 AND ltp02 = ltr02 AND ltpplant = ltrplant",
                     "    AND ltr03 = '",p_ltu03,"'",
                     "    AND (ltppos = '2' OR (ltppos = '3' AND ltracti = 'Y'))"
         
      END IF
      PREPARE t661_sel_ltp_ltq FROM l_sql
      EXECUTE t661_sel_ltp_ltq INTO l_n
      IF l_n > 0 THEN
         CALL cl_err('','apc-155',1)
         RETURN FALSE
      END IF 
   END FOREACH
   RETURN TRUE
END FUNCTION
#FUN-CC0058------add----end
#FUN-CB0025
