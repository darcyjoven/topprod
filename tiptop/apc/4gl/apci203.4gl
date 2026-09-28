# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: apci203.4gl
# Descriptions...: POS权限设定作业
# Date & Author..: No:FUN-C40084 12/04/26 By yangxf
# Date & Author..: No:FUN-C60024 12/06/25 By yangxf 修改查询显示BUG
# Modify.........: No.FUN-D20038 13/02/20 By dongsz POS使用者權限相關邏輯調整
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題


DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_ryr         RECORD LIKE ryr_file.*,
       g_ryr_t       RECORD LIKE ryr_file.*,
       g_ryr01_t     LIKE ryr_file.ryr01,
       g_rys         DYNAMIC ARRAY OF RECORD
           rys02        LIKE rys_file.rys02,
           rys02_desc   LIKE type_file.chr100,
           rys03        LIKE rys_file.rys03,
           rysacti      LIKE rys_file.rysacti
                     END RECORD,
       g_rys_t       RECORD
           rys02        LIKE rys_file.rys02,
           rys02_desc   LIKE type_file.chr100,
           rys03        LIKE rys_file.rys03,
           rysacti      LIKE rys_file.rysacti
                     END RECORD,

       g_ryt         DYNAMIC ARRAY OF RECORD
           ryt03        LIKE ryt_file.ryt03,
           ryt03_desc   LIKE type_file.chr100,
           ryt04        LIKE ryt_file.ryt04,
           rytacti      LIKE ryt_file.rytacti    
                     END RECORD,
       g_ryt_t       RECORD
           ryt03        LIKE ryt_file.ryt03,
           ryt03_desc   LIKE type_file.chr100,
           ryt04        LIKE ryt_file.ryt04,
           rytacti      LIKE ryt_file.rytacti   
                     END RECORD, 
       g_ryr1        DYNAMIC ARRAY OF RECORD
           ryr01        LIKE ryr_file.ryr01,
           ryr02        LIKE ryr_file.ryr02,
           ryr03        LIKE ryr_file.ryr03,
           ryrpos       LIKE ryr_file.ryrpos,
           rys02        LIKE rys_file.rys02,
           rys02_desc1  LIKE type_file.chr100,
           rys03        LIKE rys_file.rys03,
           rysacti      LIKE rys_file.rysacti,
           ryt03        LIKE ryt_file.ryt03,
           ryt03_desc1  LIKE type_file.chr100,
           ryt04        LIKE ryt_file.ryt04,
           rytacti      LIKE ryt_file.rytacti
                     END RECORD,        
       g_sql               STRING,
       g_wc                STRING,
       g_wc1               STRING,
       g_wc2               string,
       g_rec_b             LIKE type_file.num5,
       g_rec_b1            LIKE type_file.num5,
       g_rec_b2            LIKE type_file.num5,
       l_ac                LIKE type_file.num5,
       l_ac1               LIKE type_file.num5,
       l_ac2               LIKE type_file.num5,
       l_ac_t              LIKE type_file.num5,
       l_ac1_t             LIKE type_file.num5 
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_cnt1              LIKE type_file.num10
DEFINE g_cnt2              LIKE type_file.num10
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_multi_rys02       STRING
DEFINE g_multi_ryt03       STRING
DEFINE g_pos_str           LIKE type_file.chr1
DEFINE g_b_flag            LIKE type_file.chr1

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("apc")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_forupd_sql = "SELECT * FROM ryr_file WHERE ryr01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i203_cl CURSOR FROM g_forupd_sql
   OPEN WINDOW i203_w WITH FORM "apc/42f/apci203"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   IF g_aza.aza88 = 'Y' THEN
      CALL cl_set_comp_visible("ryrpos",TRUE)
    ELSE
      CALL cl_set_comp_visible("ryrpos",FALSE)
   END IF
   CALL i203_menu()
   CLOSE WINDOW i203_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION i203_cs()
   DEFINE  l_table         LIKE    type_file.chr1000
   DEFINE  l_where         LIKE    type_file.chr1000
   DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01

   CLEAR FORM
   CALL g_rys.clear()
   CALL g_ryt.clear()
   CALL g_ryr1.clear()
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_ryr.* TO NULL
   DIALOG ATTRIBUTE (UNBUFFERED)   
      CONSTRUCT BY NAME g_wc ON ryr01,ryr02,ryr03,ryrpos
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(ryr01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ryr01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryr01
                  NEXT FIELD ryr01
               OTHERWISE EXIT CASE
            END CASE
      END CONSTRUCT
      CONSTRUCT g_wc1 ON rys02,rys03,rysacti
              FROM s_rys[1].rys02,s_rys[1].rys03,
                   s_rys[1].rysacti
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(rys02)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.arg1 = g_lang
              LET g_qryparam.form ="q_rys02"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO rys02
              NEXT FIELD rys02
            END CASE
      END CONSTRUCT

      CONSTRUCT g_wc2 ON ryt03,ryt04,rytacti
            FROM s_ryt[1].ryt03,s_ryt[1].ryt04,
                 s_ryt[1].rytacti
      BEFORE CONSTRUCT
        CALL cl_qbe_init()

        ON ACTION CONTROLP
             CASE
                WHEN INFIELD(ryt03)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1 = g_lang
                LET g_qryparam.form ="q_ryt03"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ryt03
                NEXT FIELD ryt03
             END CASE

       END CONSTRUCT

       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION close
          LET INT_FLAG=1
          EXIT DIALOG
 
       ON ACTION accept
          EXIT DIALOG
 
       ON ACTION cancel
          LET INT_FLAG=1
          EXIT DIALOG
 
   END DIALOG
   IF INT_FLAG THEN
      RETURN
   END IF     
   LET g_sql =   "SELECT UNIQUE ryr01 "
   LET l_table = "  FROM ryr_file "
   LET l_where = " WHERE ",g_wc CLIPPED
   IF g_wc1 <> " 1=1" THEN
      LET l_table = l_table," ,rys_file "
      LET l_where = l_where," AND rys01 = ryr01 AND ",g_wc1 CLIPPED
   END IF 
   IF g_wc2 <> " 1=1" THEN
      LET l_table = l_table," ,ryt_file "
      LET l_where = l_where," AND ryt01 = ryr01 AND ",g_wc2 CLIPPED
   END IF 
   LET g_sql = g_sql,l_table,l_where
   PREPARE i203_prepare FROM g_sql
   DECLARE i203_cs
           SCROLL CURSOR WITH HOLD FOR i203_prepare
#  LET g_sql =   "SELECT COUNT(*) "                                   #FUN-C60024 mark
   LET g_sql =   "SELECT COUNT(UNIQUE ryr01) "                        #FUN-C60024  add
   LET l_table = "  FROM ryr_file "
   LET l_where = " WHERE ",g_wc CLIPPED
   IF g_wc1 <> " 1=1" THEN
      LET l_table = l_table," ,rys_file "
      LET l_where = l_where," AND rys01 = ryr01 AND ",g_wc1 CLIPPED
   END IF 
   IF g_wc2 <> " 1=1" THEN
#     LET l_table = l_table,",ryt_file "                                #FUN-C60024 mark
#     LET l_where = l_where," AND ryt01 = ryr01 AND ",g_wc2 CLIPPED     #FUN-C60024 mark
      LET l_table = l_table,",rys_file,ryt_file "                       #FUN-C60024 add
      LET l_where = l_where," AND ryt01 = ryr01 AND rys01 = ryr01 AND rys02 = ryt02 AND ",g_wc2 CLIPPED      #FUN-C60024  add
   END IF
   LET g_sql = g_sql,l_table,l_where
   PREPARE i203_precount FROM g_sql
   DECLARE i203_count CURSOR FOR i203_precount
END FUNCTION

FUNCTION i203_menu()
   WHILE TRUE
      CALL i203_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i203_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i203_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i203_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i203_u()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i203_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_rys),base.TypeInfo.create(g_ryt),base.TypeInfo.create(g_ryr1))
            END IF
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_ryr.ryr01 IS NOT NULL THEN
                 LET g_doc.column1 = "ryr01"
                 LET g_doc.value1 = g_ryr.ryr01
                 CALL cl_doc()
               END IF
         END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i203_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_rys TO s_rys.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
         DISPLAY g_rec_b TO FORMONLY.cn2
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET g_b_flag = '1'   #FUN-D30033 add

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL i203_b1_fill(g_wc2)
         CALL cl_show_fld_cont()
         
      END DISPLAY    
     DISPLAY ARRAY g_ryt TO s_ryt.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            DISPLAY g_rec_b1 TO FORMONLY.cn3
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag = '2'   #FUN-D30033 add

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()
      AFTER DISPLAY
         CONTINUE DIALOG
      END DISPLAY
      DISPLAY ARRAY g_ryr1 TO s_ryr.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()
      AFTER DISPLAY
         CONTINUE DIALOG
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

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG

      ON ACTION first
         CALL i203_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION previous
         CALL i203_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION jump
         CALL i203_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION next
         CALL i203_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION last
         CALL i203_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac2 = 1
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL i203_show()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac2 = ARR_CURR()
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

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG     
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i203_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_rys.clear()
   CALL g_ryt.clear()
   CALL g_ryr1.clear()
   LET g_wc = NULL
   LET g_wc1= NULL
   LET g_wc2= NULL   
   IF s_shut(0) THEN
      RETURN
   END IF
   INITIALIZE g_ryr.* LIKE ryr_file.*
   LET g_ryr01_t = NULL
   LET g_ryr_t.* = g_ryr.*

   WHILE TRUE
      LET g_ryr.ryruser=g_user
      LET g_ryr.ryroriu = g_user
      LET g_ryr.ryrorig = g_grup
      LET g_ryr.ryrgrup=g_grup
      LET g_ryr.ryrcrat=g_today
      LET g_ryr.ryracti='Y'
      LET g_ryr.ryrpos = '1'
      CALL i203_i("a")

      IF INT_FLAG THEN
         INITIALIZE g_ryr.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF cl_null(g_ryr.ryr01) THEN
         CONTINUE WHILE
      END IF
      BEGIN WORK
      INSERT INTO ryr_file VALUES (g_ryr.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","ryr_file",
                      g_ryr.ryr01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_ryr.ryr01,'I')
      END IF
      SELECT ryr01 INTO g_ryr.ryr01 FROM ryr_file
       WHERE ryr01 = g_ryr.ryr01
      LET g_ryr01_t = g_ryr.ryr01
      LET g_ryr_t.* = g_ryr.*
      CALL g_rys.clear()
      CALL g_ryt.clear()
      LET g_rec_b = 0
      LET g_rec_b1= 0
      LET g_pos_str = 'N'
      CALL i203_b()
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION i203_u()
   DEFINE l_ryrpos    LIKE ryr_file.ryrpos

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_ryr.ryr01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   CALL cl_set_comp_entry("ryr01",FALSE)    #FUN-D20038 add

   SELECT * INTO g_ryr.* FROM ryr_file
    WHERE ryr01=g_ryr.ryr01

   MESSAGE ""
   LET g_ryr01_t = g_ryr.ryr01

   IF g_aza.aza88 = 'Y' THEN
      BEGIN WORK
      OPEN i203_cl USING g_ryr.ryr01
      IF STATUS THEN
         CALL cl_err("OPEN i203_cl:", STATUS, 1)
         CLOSE i203_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH i203_cl INTO g_ryr.*
      IF SQLCA.sqlcode THEN
          CALL cl_err(g_ryr.ryr01,SQLCA.sqlcode,0)
          CLOSE i203_cl
          ROLLBACK WORK
          RETURN
      END IF
      LET l_ryrpos = g_ryr.ryrpos    #记录已传pos否初值
      UPDATE ryr_file SET ryrpos = '4'
       WHERE ryr01 = g_ryr.ryr01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ryr_file",g_ryr.ryrpos,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF 
      LET g_ryr.ryrpos = '4'
      DISPLAY BY NAME g_ryr.ryrpos
      CLOSE i203_cl
      COMMIT WORK
   END IF

   BEGIN WORK
   OPEN i203_cl USING g_ryr.ryr01
   IF STATUS THEN
      CALL cl_err("OPEN i203_cl:", STATUS, 1)
      CLOSE i203_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i203_cl INTO g_ryr.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ryr.ryr01,SQLCA.sqlcode,0)
       CLOSE i203_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL i203_show()

   WHILE TRUE
      LET g_ryr01_t = g_ryr.ryr01
      LET g_ryr.ryrmodu=g_user
      LET g_ryr.ryrdate=g_today
      
      CALL i203_i("u")

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ryr.*=g_ryr_t.*
         LET g_ryr.ryrpos = l_ryrpos
         UPDATE ryr_file SET ryrpos = g_ryr.ryrpos
          WHERE ryr01 = g_ryr_t.ryr01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ryr_file",g_ryr.ryrpos,"",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF
         CALL i203_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      IF g_ryr.ryr01 != g_ryr01_t THEN
         UPDATE rys_file SET rys01 = g_ryr.ryr01
          WHERE rys01 = g_ryr01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rys_file",g_ryr01_t,
                         "",SQLCA.sqlcode,"","rys",1)
            CONTINUE WHILE
         END IF
         UPDATE ryt_file SET ryt01 = g_ryr.ryr01
          WHERE ryt01 = g_ryr01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","ryt_file","","",SQLCA.sqlcode,"","",1)
             CONTINUE WHILE
         END IF
      END IF
      IF g_aza.aza88 = 'Y' THEN
         IF l_ryrpos <> '1' THEN
            LET g_ryr.ryrpos = '2'
         ELSE
            LET g_ryr.ryrpos = '1'
         END IF
      END IF 
      UPDATE ryr_file SET ryr_file.* = g_ryr.*
       WHERE ryr01 = g_ryr01_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rys_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   SELECT ryrpos INTO g_ryr.ryrpos
     FROM ryr_file
    WHERE ryr01 = g_ryr.ryr01
   DISPLAY BY NAME g_ryr.ryrpos 
   CLOSE i203_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ryr.ryr01,'U')
END FUNCTION

FUNCTION i203_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1
   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY BY NAME g_ryr.ryrpos
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_ryr.ryr01,g_ryr.ryr02,
                 g_ryr.ryr03,g_ryr.ryrpos
       WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i203_set_entry(p_cmd)
         CALL i203_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD ryr01
         IF NOT cl_null(g_ryr.ryr01) THEN 
            IF (g_ryr.ryr01 != g_ryr_t.ryr01 AND NOT cl_null(g_ryr_t.ryr01)) 
               OR cl_null(g_ryr_t.ryr01) THEN          
               SELECT COUNT(*) INTO l_n 
                 FROM ryr_file 
                WHERE ryr01 = g_ryr.ryr01
               IF l_n > 0 THEN 
                  CALL cl_err(g_ryr.ryr01,-239,0)
                  LET g_ryr.ryr01 = g_ryr_t.ryr01
                  NEXT FIELD ryr01
               END IF 
            END IF 
         END IF

      AFTER FIELD ryr03
         IF NOT cl_null(g_ryr.ryr03) THEN
            IF g_ryr.ryr03 < 0 OR g_ryr.ryr03 > 100 THEN
               CALL cl_err('','apc-196',0)
               LET g_ryr.ryr03 = g_ryr_t.ryr03
               NEXT FIELD ryr03
            END IF 
         END IF 

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END INPUT

END FUNCTION


FUNCTION i203_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CLEAR FORM
   CALL g_rys.clear()
   CALL g_ryt.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   DISPLAY ' ' TO FORMONLY.cn2
   DISPLAY ' ' TO FORMONLY.cn3
   CALL i203_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ryr.* TO NULL
      CALL g_rys.clear()
      CALL g_ryt.clear()
      RETURN
   END IF

   OPEN i203_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ryr.* TO NULL
      CLEAR FORM
   ELSE
      OPEN i203_count
      FETCH i203_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i203_fetch('F')
   END IF

END FUNCTION

FUNCTION i203_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     i203_cs INTO g_ryr.ryr01
      WHEN 'P' FETCH PREVIOUS i203_cs INTO g_ryr.ryr01
      WHEN 'F' FETCH FIRST    i203_cs INTO g_ryr.ryr01
      WHEN 'L' FETCH LAST     i203_cs INTO g_ryr.ryr01
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
            FETCH ABSOLUTE g_jump i203_cs INTO g_ryr.ryr01
            LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ryr.ryr01,SQLCA.sqlcode,0)
      INITIALIZE g_ryr.* TO NULL
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
   END IF

   SELECT * INTO g_ryr.* FROM ryr_file WHERE ryr01 = g_ryr.ryr01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ryr_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_ryr.* TO NULL
      RETURN
   END IF

   LET g_data_owner = g_ryr.ryruser
   LET g_data_group = g_ryr.ryrgrup
   LET l_ac = 1
   CALL i203_show()

END FUNCTION

FUNCTION i203_show()

   LET g_ryr_t.* = g_ryr.*
   DISPLAY BY NAME g_ryr.ryr01,g_ryr.ryr02,
                   g_ryr.ryr03,g_ryr.ryrpos
   CALL i203_b_fill(g_wc1,g_wc2)              #FUN-C60024  add g_wc2
   CALL i203_b1_fill(g_wc2)
   CALL i203_b2_fill(g_wc1,g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i203_r()
   DEFINE l_n  LIKE type_file.num5
   DEFINE l_n1 LIKE type_file.num5
   
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_ryr.ryr01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   SELECT * INTO g_ryr.* FROM ryr_file
    WHERE ryr01=g_ryr.ryr01
   LET l_n = 0
   LET l_n1 = 0 
   IF g_ryr.ryrpos = '3' THEN 
      SELECT COUNT(*) INTO l_n
        FROM rys_file 
       WHERE rys01 = g_ryr.ryr01
         AND rysacti = 'Y'
      SELECT COUNT(*) INTO l_n1
        FROM ryt_file
       WHERE ryt01 = g_ryr.ryr01
         AND rytacti = 'Y'
   END IF 
   IF g_ryr.ryrpos = '1' OR 
      (l_n = 0 AND l_n1 = 0 AND g_ryr.ryrpos = '3') THEN
   ELSE 
      CALL cl_err('','apc-156',0) #資料的狀態須已傳POS否為'1.新增未下傳'，或者已傳POS否為'3.已下傳'且單身資料都無效，才能刪除！
      RETURN      
   END IF 
   BEGIN WORK

   OPEN i203_cl USING g_ryr.ryr01
   IF STATUS THEN
      CALL cl_err("OPEN i203_cl:", STATUS, 1)
      CLOSE i203_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i203_cl INTO g_ryr.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ryr.ryr01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL i203_show()

   IF cl_delh(0,0) THEN
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "ryr01"
      LET g_doc.value1 = g_ryr.ryr01
      CALL cl_del_doc()
      DELETE FROM ryr_file WHERE ryr01 = g_ryr.ryr01
      DELETE FROM zw_file  WHERE zw01  = g_ryr.ryr01     #FUN-D20038 add
      DELETE FROM zy_file  WHERE zy01  = g_ryr.ryr01     #FUN-D20038 add
      DELETE FROM rys_file WHERE rys01 = g_ryr.ryr01
      DELETE FROM ryt_file WHERE ryt01 = g_ryr.ryr01
      CLEAR FORM
      CALL g_rys.clear()
      CALL g_ryt.clear()
      OPEN i203_count
      FETCH i203_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i203_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i203_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i203_fetch('/')
      END IF
   END IF
   CALL i203_show()
   CLOSE i203_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ryr.ryr01,'D')
END FUNCTION


FUNCTION i203_b()
DEFINE
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_ryrpos        LIKE ryr_file.ryrpos,
    l_flag          LIKE type_file.chr1,
    l_ryp04         LIKE ryp_file.ryp04,     #FUN-D20038 add
    l_ryp04_1       LIKE ryp_file.ryp04,     #FUN-D20038 add
    l_ryp06         LIKE ryp_file.ryp06,     #FUN-D20038 add
    l_ryp06_1       LIKE ryp_file.ryp06,     #FUN-D20038 add
    l_ryp06_2       LIKE ryp_file.ryp06,     #FUN-D20038 add
    l_zz04          LIKE zz_file.zz04        #FUN-D20038 add
       

    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_ryr.ryr01 IS NULL THEN
       RETURN
    END IF

    SELECT * INTO g_ryr.* FROM ryr_file
     WHERE ryr01=g_ryr.ryr01

    IF g_aza.aza88 = 'Y' THEN
       BEGIN WORK
       OPEN i203_cl USING g_ryr.ryr01
       IF STATUS THEN
          CALL cl_err("OPEN i203_cl:", STATUS, 1)
          CLOSE i203_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH i203_cl INTO g_ryr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_ryr.ryr01,SQLCA.sqlcode,0)
          CLOSE i203_cl
          ROLLBACK WORK
          RETURN
       END IF
       LET l_ryrpos = g_ryr.ryrpos
       LET g_pos_str = 'N'
       UPDATE ryr_file SET ryrpos = '4'
        WHERE ryr01 = g_ryr.ryr01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","ryr_file",g_ryr.ryr01,"",SQLCA.sqlcode,"","",1)
          ROLLBACK WORK
          RETURN
       END IF
       LET g_ryr.ryrpos = '4'
       DISPLAY BY NAME g_ryr.ryrpos
       COMMIT WORK
    END IF
    LET g_forupd_sql = "SELECT rys02,'',rys03,rysacti ",
                       "  FROM rys_file ",
                       "  WHERE rys01=? AND rys02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i203_bcl CURSOR FROM g_forupd_sql
    LET g_forupd_sql = "SELECT ryt03,'',ryt04,rytacti ",
                       "  FROM ryt_file ",
                       "  WHERE ryt01=? AND ryt02=? AND ryt03=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i203_bcl_1 CURSOR FROM g_forupd_sql

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    IF g_rec_b > 0 THEN LET l_ac = 1 END IF     #FUN-D30033 add
    IF g_rec_b1 > 0 THEN LET l_ac1 = 1 END IF   #FUN-D30033 add

    DIALOG ATTRIBUTE(UNBUFFERED)
       INPUT ARRAY g_rys FROM s_rys.*
             ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,
                       INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                       APPEND ROW=l_allow_insert)
          BEFORE INPUT
             IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(l_ac)
             END IF
             LET g_b_flag = '1'   #FUN-D30033 add

          BEFORE ROW
             LET p_cmd=''
             LET l_ac = ARR_CURR()
             LET l_lock_sw = 'N'
             LET l_n  = ARR_COUNT()
             LET l_flag = '1'
             BEGIN WORK
             LET g_success = 'N'
             OPEN i203_cl USING g_ryr.ryr01
             IF STATUS THEN
                CALL cl_err("OPEN i203_cl:", STATUS, 1)
                CLOSE i203_cl
                ROLLBACK WORK
                RETURN
             END IF
 
             FETCH i203_cl INTO g_ryr.*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_ryr.ryr01,SQLCA.sqlcode,0)
                CLOSE i203_cl
                ROLLBACK WORK
                RETURN
             END IF
             CALL i203_b1_fill(g_wc2)
             IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_before_input_done = FALSE
                CALL i203_set_entry_b1(p_cmd)
                CALL i203_set_no_entry_b1(p_cmd)
                LET g_before_input_done = TRUE
                LET g_rys_t.* = g_rys[l_ac].*
                OPEN i203_bcl USING g_ryr.ryr01,g_rys_t.rys02
                IF STATUS THEN
                   CALL cl_err("OPEN i203_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i203_bcl INTO g_rys[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_rys_t.rys02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      CALL i203_rys02('d')
                   END IF
                END IF
                CALL cl_show_fld_cont()
             END IF
 
          BEFORE INSERT
             LET l_n = ARR_COUNT()
             LET p_cmd='a'
             LET g_before_input_done = FALSE
             CALL i203_set_entry_b1(p_cmd)
             CALL i203_set_no_entry_b1(p_cmd)
             LET g_before_input_done = TRUE
             INITIALIZE g_rys[l_ac].* TO NULL
             LET g_rys_t.* = g_rys[l_ac].*
             LET g_rys[l_ac].rysacti= 'Y' 
             CALL cl_show_fld_cont()
             NEXT FIELD rys02
    
          AFTER INSERT
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                CLOSE i203_bcl
                CANCEL INSERT
             END IF
             INSERT INTO rys_file(rys01,rys02,rys03,rysacti)
             VALUES(g_ryr.ryr01,g_rys[l_ac].rys02,g_rys[l_ac].rys03,
                    g_rys[l_ac].rysacti)
 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rys_file",g_rys[l_ac].rys02,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
               #FUN-D20038--add--str---
                SELECT ryp04 INTO l_ryp04 FROM ryp_file WHERE ryp01 = g_rys[l_ac].rys02
                IF l_ryp04 = '2' THEN
                   #新增zw_file
                   SELECT COUNT(*) INTO l_n FROM zw_file WHERE zw01 = g_ryr.ryr01
                   IF l_n < 1 THEN
                      INSERT INTO zw_file(zw01,zw02,zw03,zw04,zw05,zw06,zwacti,zwuser,zwgrup,zwmodu,zwdate,zworig,zworiu)
                         VALUES(g_ryr.ryr01,g_ryr.ryr02,NULL,'1',NULL,NULL,'Y',g_user,g_grup,g_user,g_today,g_grup,g_user)
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("ins","zw_file","","",SQLCA.sqlcode,"","",1)
                         CANCEL INSERT
                      END IF
                   END IF
                      
                   #新增zy_file
                   SELECT ryp06 INTO l_ryp06 FROM ryp_file WHERE ryp01 = g_rys[l_ac].rys02
                   SELECT COUNT(*) INTO l_n FROM zy_file WHERE zy01 = g_ryr.ryr01 AND zy02 =  l_ryp06
                   IF l_n < 1 THEN
                      SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = l_ryp06
                      INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy06,zyuser,zygrup,zymodu,zydate,zy07,zyorig,zyoriu)
                         VALUES(g_ryr.ryr01,l_ryp06,l_zz04,'0','0',NULL,g_user,g_grup,g_user,g_today,'0',g_grup,g_user)
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("ins","zy_file","","",SQLCA.sqlcode,"","",1)
                         CANCEL INSERT
                      END IF
                   END IF
                END IF 
               #FUN-D20038--add--end---
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                LET g_pos_str = 'Y'
                IF l_ryrpos <> '1' THEN
                   LET l_ryrpos = '2'
                ELSE 
                   LET l_ryrpos = '1'
                END IF 
                DISPLAY g_rec_b TO FORMONLY.cn2
             END IF

          AFTER FIELD rys02
             IF NOT cl_null(g_rys[l_ac].rys02) THEN
                IF (g_rys[l_ac].rys02 != g_rys_t.rys02 AND NOT cl_null(g_rys_t.rys02))
                   OR cl_null(g_rys_t.rys02) THEN
                   SELECT COUNT(*) INTO l_cnt
                     FROM rys_file 
                    WHERE rys01 = g_ryr.ryr01 
                      AND rys02 = g_rys[l_ac].rys02
                   IF l_cnt > 0 THEN
                      CALL cl_err(g_rys[l_ac].rys02,-239,0)
                      LET g_rys[l_ac].rys02 = g_rys_t.rys02
                      NEXT FIELD rys02
                   END IF 
                END IF 
                CALL i203_rys02(p_cmd)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rys[l_ac].rys02,g_errno,0)
                   LET g_rys[l_ac].rys02 = g_rys_t.rys02
                   NEXT FIELD rys02
                END IF
                CALL i203_rys02_ryt03_chk()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rys[l_ac].rys02,g_errno,0)
                   LET g_rys[l_ac].rys02 = g_rys_t.rys02
                   NEXT FIELD rys02
                END IF      
             END IF 

          BEFORE DELETE
             IF g_rys_t.rys02 IS NOT NULL THEN
                IF l_ryrpos = '1'
                   OR (g_rys_t.rysacti = 'N' AND l_ryrpos = '3') THEN     
                   SELECT COUNT(*) INTO l_cnt
                     FROM ryt_file 
                    WHERE ryt01 = g_ryr.ryr01 
                      AND ryt02 = g_rys_t.rys02
                      AND rytacti = 'Y' 
                   IF (l_cnt > 0  AND l_ryrpos = '1')
                      OR l_cnt = 0 THEN
                      IF NOT cl_delete() THEN
                         CANCEL DELETE
                      END IF
                      INITIALIZE g_doc.* TO NULL
                      LET g_doc.column1 = "rys02"
                      LET g_doc.value1 = g_rys[l_ac].rys02
                      CALL cl_del_doc()
                      IF l_lock_sw = "Y" THEN
                         CALL cl_err("", -263, 1)
                         CANCEL DELETE
                      END IF
                      DELETE FROM rys_file WHERE rys01 = g_ryr_t.ryr01
                                             AND rys02 = g_rys_t.rys02
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("del","rys_file",g_rys_t.rys02,"",SQLCA.sqlcode,"","",1)
                         EXIT DIALOG
                      END IF
                     #FUN-D20038--add--str---
                      SELECT ryp04 INTO l_ryp04 FROM ryp_file WHERE ryp01 = g_rys_t.rys02
                      IF l_ryp04 = '2' THEN
                         #刪除zy_file
                         SELECT ryp06 INTO l_ryp06 FROM ryp_file WHERE ryp01 = g_rys_t.rys02
                         DELETE FROM zy_file WHERE zy01 = g_ryr_t.ryr01 AND zy02 = l_ryp06
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("del","zy_file","","",SQLCA.sqlcode,"","",1)
                            EXIT DIALOG
                         END IF
                      END IF
                     #FUN-D20038--add--end---
                      DELETE FROM ryt_file WHERE ryt01 = g_ryr_t.ryr01
                                             AND ryt02 = g_rys_t.rys02
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("del","ryt_file",g_rys_t.rys02,"",SQLCA.sqlcode,"","",1)
                         EXIT DIALOG
                      END IF
                      COMMIT WORK
                      LET g_rec_b=g_rec_b-1
                      DISPLAY g_rec_b TO FORMONLY.cn2
                   ELSE 
                      CALL cl_err('','apc-156',0)
                      CANCEL DELETE
                   END IF 
                ELSE 
                   CALL cl_err('','apc-156',0)
                   CANCEL DELETE
                END IF 
                CALL i203_b1_fill(g_wc2)
                CALL i203_b2_fill(g_wc1,g_wc2)
             END IF

          ON ROW CHANGE
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_rys[l_ac].* = g_rys_t.*
                CLOSE i203_bcl
                ROLLBACK WORK
                EXIT DIALOG
             END IF
 
             IF l_lock_sw="Y" THEN
                CALL cl_err(g_rys_t.rys02,-263,0)
                LET g_rys[l_ac].* = g_rys_t.*
             ELSE
                UPDATE rys_file SET rys02 = g_rys[l_ac].rys02,
                                    rys03 = g_rys[l_ac].rys03,
                                    rysacti = g_rys[l_ac].rysacti
                 WHERE rys01 = g_ryr_t.ryr01
                   AND rys02 = g_rys_t.rys02
 
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","rys_file",g_rys_t.rys02,"",SQLCA.sqlcode,"","",1)
                   LET g_rys[l_ac].* = g_rys_t.*
                ELSE
                  #FUN-D20038--add--str---
                   IF g_rys[l_ac].rys02 != g_rys_t.rys02 THEN
                      SELECT ryp04 INTO l_ryp04 FROM ryp_file WHERE ryp01 = g_rys[l_ac].rys02
                      IF l_ryp04 = '2' THEN
                         SELECT ryp04 INTO l_ryp04_1 FROM ryp_file WHERE ryp01 = g_rys_t.rys02
                         IF l_ryp04_1 = '2' THEN
                            #如果原模塊的功能類型為網頁,則更新zy_file
                            SELECT ryp06 INTO l_ryp06_1 FROM ryp_file WHERE ryp01 = g_rys[l_ac].rys02
                            SELECT ryp06 INTO l_ryp06_2 FROM ryp_file WHERE ryp01 = g_rys_t.rys02
                            SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = l_ryp06
                            UPDATE zy_file SET zy02 = l_ryp06_1,zy03 = l_zz04 
                             WHERE zy01 = g_ryr.ryr01 AND zy02 = l_ryp06_2
                            IF SQLCA.sqlcode THEN
                               CALL cl_err3("upd","zy_file","","",SQLCA.sqlcode,"","",1)
                               LET g_rys[l_ac].* = g_rys_t.*
                            END IF
                         ELSE
                            #如果原模塊的功能類型不為網頁,則新增zy_file
                            SELECT ryp06 INTO l_ryp06_1 FROM ryp_file WHERE ryp01 = g_rys[l_ac].rys02
                            SELECT COUNT(*) INTO l_n FROM zy_file WHERE zy01 = g_ryr.ryr01 AND zy02 =  l_ryp06_1
                            IF l_n < 1 THEN
                               SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = l_ryp06_1
                               INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy06,zyuser,zygrup,zymodu,zydate,zy07,zyorig,zyoriu)
                                  VALUES(g_ryr.ryr01,l_ryp06_1,l_zz04,'0','0',NULL,g_user,g_grup,g_user,g_today,'0',g_grup,g_user)
                               IF SQLCA.sqlcode THEN
                                  CALL cl_err3("ins","zy_file","","",SQLCA.sqlcode,"","",1)
                                  LET g_rys[l_ac].* = g_rys_t.*
                               END IF
                            END IF
                         END IF
                      ELSE
                         #如果功能類型不為網頁,則刪除zy_file
                         SELECT ryp06 INTO l_ryp06 FROM ryp_file WHERE ryp01 = g_rys_t.rys02
                         DELETE FROM zy_file WHERE zy01 = g_ryr.ryr01 AND zy02 = l_ryp06
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("del","zy_file","","",SQLCA.sqlcode,"","",1)
                            LET g_rys[l_ac].* = g_rys_t.*
                         END IF
                      END IF
                   END IF 
                  #FUN-D20038--add--end---
                   UPDATE ryt_file SET ryt02 = g_rys[l_ac].rys02 
                    WHERE ryt01 = g_ryr_t.ryr01
                      AND ryt02 = g_rys_t.rys02
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","ryt_file",g_rys_t.rys02,"",SQLCA.sqlcode,"","",1)
                      LET g_rys[l_ac].* = g_rys_t.*
                   ELSE
                      MESSAGE 'UPDATE O.K'
                      LET g_pos_str = 'Y'
                      IF l_ryrpos <> '1' THEN
                         LET l_ryrpos = '2'
                      ELSE 
                         LET l_ryrpos = '1'
                      END IF 
                      COMMIT WORK
                   END IF 
                END IF
             END IF

          AFTER ROW
             LET l_ac = ARR_CURR()
             LET l_ac_t = l_ac
 
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_rys[l_ac].* = g_rys_t.*
                ELSE 
                   CALL g_rys.deleteElement(l_ac)
                END IF
                CLOSE i203_bcl
                ROLLBACK WORK
                EXIT DIALOG
             END IF
             CLOSE i203_bcl
             COMMIT WORK

          ON ACTION controlp
             CASE
                WHEN INFIELD(rys02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ryp"
                   LET g_qryparam.default1 = g_rys[l_ac].rys02
                   LET g_qryparam.arg1 = g_lang
                   IF p_cmd = 'a' THEN
                      LET g_qryparam.state = "c"
                      LET g_qryparam.where = " ryp01 NOT IN(SELECT rys02 FROM rys_file WHERE rys01 = '",g_ryr.ryr01,"') "
                      CALL cl_create_qry() RETURNING g_multi_rys02
                      IF NOT cl_null(g_multi_rys02) THEN
                          CALL i203_rys02_m()
                          CALL i203_b_fill(" 1=1"," 1=1")        #FUN-C60024  add "1=1"
                          CALL i203_b()
                          LET g_pos_str = 'Y' 
                          EXIT DIALOG 
                      END IF      
                   ELSE           
                      CALL cl_create_qry() RETURNING g_rys[l_ac].rys02
                      DISPLAY BY NAME g_rys[l_ac].rys02
                      CALL i203_rys02('d')
                   END IF
                   NEXT FIELD rys02
                OTHERWISE
                EXIT CASE
             END CASE
       END INPUT

       INPUT ARRAY g_ryt FROM s_ryt.*
          ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
                    INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
          BEFORE INPUT
             IF g_rec_b1 != 0 THEN
                CALL fgl_set_arr_curr(l_ac1)
             END IF
             LET g_b_flag = '2'  #FUN-D30033 add
 
          BEFORE ROW
             LET p_cmd=''
             LET l_ac1 = ARR_CURR()
             LET l_lock_sw = 'N'
             LET l_n  = ARR_COUNT()
             IF cl_null(g_rys[l_ac].rys02) THEN
                CALL cl_err('','apc-192',0)  
                CALL g_rys.deleteElement(l_ac)
                NEXT FIELD rys02 
             END IF 
             LET l_flag = '2'
             BEGIN WORK
             LET g_success = 'N'
             OPEN i203_cl USING g_ryr.ryr01
             IF STATUS THEN
                CALL cl_err("OPEN i203_cl:", STATUS, 1)
                CLOSE i203_cl
                ROLLBACK WORK
                RETURN
             END IF

             OPEN i203_bcl USING g_ryr.ryr01,g_rys[l_ac].rys02
             IF STATUS THEN
                CALL cl_err("OPEN i203_bcl:", STATUS, 1)
                CLOSE i203_bcl
                ROLLBACK WORK
                RETURN
             END IF
             FETCH i203_bcl INTO g_rys[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_rys[l_ac].rys02,SQLCA.sqlcode,0)
                CLOSE i203_bcl
                ROLLBACK WORK
                RETURN 
             END IF
             IF g_rec_b1>=l_ac1 THEN
                LET p_cmd='u'
                LET g_before_input_done = FALSE
                CALL i203_set_entry_b2(p_cmd)
                CALL i203_set_no_entry_b2(p_cmd)
                LET g_before_input_done = TRUE
                LET g_ryt_t.* = g_ryt[l_ac1].*
                OPEN i203_bcl_1 USING g_ryr.ryr01,g_rys[l_ac].rys02,g_ryt_t.ryt03
                IF STATUS THEN
                   CALL cl_err("OPEN i203_bcl_1:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i203_bcl_1 INTO g_ryt[l_ac1].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_ryt_t.ryt03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE 
                      CALL i203_rys02('d')
                      CALL i203_ryt03('d')
                   END IF
                END IF
                CALL cl_show_fld_cont()
             END IF
 
          BEFORE INSERT
             LET l_n = ARR_COUNT()
             LET p_cmd='a'
             LET g_before_input_done = FALSE
             CALL i203_set_entry_b2(p_cmd)
             CALL i203_set_no_entry_b2(p_cmd)
             LET g_before_input_done = TRUE
             INITIALIZE g_ryt[l_ac1].* TO NULL
             LET g_ryt_t.* = g_ryt[l_ac1].*
             LET g_ryt[l_ac1].rytacti= 'Y'
             CALL i203_rys02('d')
             CALL cl_show_fld_cont()
             NEXT FIELD ryt03
 
          AFTER INSERT
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                CLOSE i203_bcl_1
                CANCEL INSERT
             END IF
             INSERT INTO ryt_file(ryt01,ryt02,ryt03,ryt04,rytacti)
             VALUES(g_ryr.ryr01,g_rys[l_ac].rys02,g_ryt[l_ac1].ryt03,
                    g_ryt[l_ac1].ryt04,g_ryt[l_ac1].rytacti)
 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","ryt_file",g_ryt[l_ac1].ryt03,"",SQLCA.sqlcode,"","",1)
                CANCEL INSERT
             ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b1=g_rec_b1+1
                LET g_pos_str = 'Y'
                IF l_ryrpos <> '1' THEN
                   LET l_ryrpos = '2'
                ELSE 
                   LET l_ryrpos = '1'
                END IF 
                DISPLAY g_rec_b1 TO FORMONLY.cn3
             END IF

          AFTER FIELD ryt03
             IF NOT cl_null(g_ryt[l_ac1].ryt03) THEN
                IF (g_ryt[l_ac1].ryt03 != g_ryt_t.ryt03 AND NOT cl_null(g_ryt_t.ryt03))
                   OR cl_null(g_ryt_t.ryt03) THEN
                   SELECT COUNT(*) INTO l_cnt
                     FROM ryt_file
                    WHERE ryt01 = g_ryr.ryr01
                      AND ryt02 = g_rys[l_ac].rys02
                      AND ryt03 = g_ryt[l_ac1].ryt03
                   IF l_cnt > 0 THEN
                      CALL cl_err(g_ryt[l_ac1].ryt03,-239,0)
                      LET g_ryt[l_ac1].ryt03 = g_ryt_t.ryt03
                      NEXT FIELD ryt03
                   END IF
                END IF
                CALL i203_ryt03(p_cmd)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_ryt[l_ac1].ryt03,g_errno,0)
                   LET g_ryt[l_ac1].ryt03 = g_ryt_t.ryt03
                   NEXT FIELD ryt03
                END IF 
             END IF

          BEFORE DELETE
             IF g_ryt_t.ryt03 IS NOT NULL THEN
                IF l_ryrpos = '1'
                   OR (g_ryt_t.rytacti = 'N' AND l_ryrpos = '3') THEN
                   IF NOT cl_delete() THEN
                      CANCEL DELETE
                   END IF
                   INITIALIZE g_doc.* TO NULL
                   LET g_doc.column1 = "ryt03"
                   LET g_doc.value1 = g_ryt[l_ac1].ryt03
                   CALL cl_del_doc()
                   IF l_lock_sw = "Y" THEN
                      CALL cl_err("", -263, 1)
                      CANCEL DELETE
                   END IF
                   DELETE FROM ryt_file WHERE ryt01 = g_ryr.ryr01
                                          AND ryt02 = g_rys[l_ac].rys02
                                          AND ryt03 = g_ryt_t.ryt03
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","ryt_file",g_ryt_t.ryt03,"",SQLCA.sqlcode,"","",1)
                      EXIT DIALOG
                   END IF
                   COMMIT WORK
                   LET g_rec_b1=g_rec_b1-1
                   DISPLAY g_rec_b1 TO FORMONLY.cn3
                ELSE 
                   CALL cl_err('','apc-156',0)
                   CANCEL DELETE
                END IF 
                CALL i203_b2_fill(g_wc1,g_wc2)
             END IF

          ON ROW CHANGE
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                LET g_ryt[l_ac1].* = g_ryt_t.*
                CLOSE i203_bcl_1
                ROLLBACK WORK
                EXIT DIALOG
             END IF
 
             IF l_lock_sw="Y" THEN
                CALL cl_err(g_ryt_t.ryt03,-263,0)
                LET g_ryt[l_ac1].* = g_ryt_t.*
             ELSE
                UPDATE ryt_file SET ryt03=g_ryt[l_ac1].ryt03,
                                    ryt04=g_ryt[l_ac1].ryt04,
                                    rytacti=g_ryt[l_ac1].rytacti
                 WHERE ryt01 = g_ryr_t.ryr01
                   AND ryt02 = g_rys[l_ac].rys02
                   AND ryt03 = g_ryt_t.ryt03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","ryt_file",g_ryt_t.ryt03,"",SQLCA.sqlcode,"","",1)
                   LET g_ryt[l_ac1].* = g_ryt_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                   LET g_pos_str = 'Y'
                   IF l_ryrpos <> '1' THEN
                      LET l_ryrpos = '2'
                   ELSE
                      LET l_ryrpos = '1'
                   END IF 
                END IF
             END IF

          AFTER ROW
             LET l_ac1 = ARR_CURR()            
             LET l_ac1_t = l_ac1                
 
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_ryt[l_ac1].* = g_ryt_t.*
                ELSE
                   CALL g_ryt.deleteElement(l_ac1)
                END IF
                CLOSE i203_bcl_1
                ROLLBACK WORK
                EXIT DIALOG
             END IF
             CLOSE i203_bcl_1
             COMMIT WORK

          ON ACTION controlp
             CASE
                WHEN INFIELD(ryt03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_ryq"
                     LET g_qryparam.arg1 = g_rys[l_ac].rys02
                     LET g_qryparam.arg2 = g_lang
                     LET g_qryparam.where = " ryq01 NOT IN(SELECT ryt03 FROM ryt_file WHERE ryt01 = '",g_ryr.ryr01,"') "
                     LET g_qryparam.default1 = g_ryt[l_ac1].ryt03
                     IF p_cmd = 'a' THEN
                        LET g_qryparam.state = "c"    
                        CALL cl_create_qry() RETURNING g_multi_ryt03
                        IF NOT cl_null(g_multi_ryt03) THEN
                            CALL i203_ryt03_m()
                            CALL i203_b1_fill(" 1=1")
                            CALL i203_b()
                            LET g_pos_str = 'Y'
                            EXIT DIALOG 
                        END IF
                     ELSE
                        CALL cl_create_qry() RETURNING g_ryt[l_ac1].ryt03
                        DISPLAY BY NAME g_ryt[l_ac1].ryt03  
                        CALL i203_ryt03('d')
                     END IF
                     NEXT FIELD ryt03 
             END CASE
      END INPUT

      #FUN-D30033--add---begin---
      BEFORE DIALOG
         CASE g_b_flag 
            WHEN '1' NEXT FIELD rys02
            WHEN '2' NEXT FIELD ryt03
         END CASE
      #FUN-D30033--add---end---

      ON ACTION accept
         ACCEPT DIALOG

      ON ACTION cancel
         IF l_flag = '1' THEN
            IF p_cmd='u' THEN
               LET g_rys[l_ac].* = g_rys_t.*
            ELSE
               CALL g_rys.deleteElement(l_ac)
               IF g_rec_b != 0 THEN     #FUN-D30033 add
                  LET g_action_choice = "detail"  #FUN-D30033 add
               END IF                   #FUN-D30033 add
            END IF
            CLOSE i203_bcl
            ROLLBACK WORK
         END IF 
         IF l_flag = '2' THEN
            IF p_cmd='u' THEN
               LET g_ryt[l_ac1].* = g_ryt_t.*
            ELSE
               CALL g_ryt.deleteElement(l_ac1)
               IF g_rec_b1 != 0 THEN     #FUN-D30033 add
                  LET g_action_choice = "detail"  #FUN-D30033 add
               END IF 
            END IF
            CLOSE i203_bcl_1
            ROLLBACK WORK
         END IF 
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
   END DIALOG   
   IF g_aza.aza88 = 'Y' THEN
      IF NOT cl_null(g_pos_str) THEN 
         IF g_pos_str = 'Y' THEN
            IF l_ryrpos <> '1' THEN
               LET g_ryr.ryrpos = '2'
            ELSE   
               LET g_ryr.ryrpos = '1'
            END IF  
            UPDATE ryr_file SET ryrpos = g_ryr.ryrpos
             WHERE ryr01 = g_ryr.ryr01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","rys_file","","",SQLCA.sqlcode,"","",1)
               LET g_ryr.ryrpos = g_ryr_t.ryrpos
            END IF
         ELSE 
            UPDATE ryr_file SET ryrpos = l_ryrpos
             WHERE ryr01 = g_ryr.ryr01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","rys_file","","",SQLCA.sqlcode,"","",1)
               LET g_ryr.ryrpos = g_ryr_t.ryrpos
            END IF
            LET g_ryr.ryrpos = l_ryrpos
         END IF 
      END IF 
      DISPLAY BY NAME g_ryr.ryrpos
   END IF 
   CLOSE i203_bcl
   CLOSE i203_bcl_1
   CALL i203_delall()
   CALL i203_b2_fill(g_wc1,g_wc2)
END FUNCTION

FUNCTION i203_rys02(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_rypacti LIKE ryp_file.rypacti
DEFINE l_ryx05   LIKE ryx_file.ryx05
DEFINE l_ryp02   LIKE ryp_file.ryp02
   LET g_errno = ''
   SELECT ryp02,rypacti INTO l_ryp02,l_rypacti 
     FROM ryp_file 
    WHERE ryp01 = g_rys[l_ac].rys02 
   CASE 
      WHEN SQLCA.SQLCODE = 100 LET g_errno = 'apc-188'
      WHEN l_rypacti <> 'Y'    LET g_errno = 'apc-189'
      WHEN l_ryp02 <> '2'      LET g_errno = 'apc-193'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      SELECT ryx05 INTO l_ryx05
        FROM ryx_file 
       WHERE ryx01 = 'ryp_file'
         AND ryx02 = 'ryp01'
         AND ryx03 = g_rys[l_ac].rys02
         AND ryx04 = g_lang
      LET g_rys[l_ac].rys02_desc = l_ryx05
      DISPLAY BY NAME g_rys[l_ac].rys02_desc
   END IF   
END FUNCTION 

FUNCTION i203_rys02_ryt03_chk()
DEFINE l_cnt   LIKE type_file.num10
   LET g_errno = ''
   SELECT COUNT(*) INTO l_cnt
     FROM ryq_file,ryt_file
    WHERE ryq01 = ryt03 
      AND ryq02 <> g_rys[l_ac].rys02
      AND ryt02 = g_rys_t.rys02
      AND ryt01 = g_ryr.ryr01
   IF l_cnt > 0 THEN
      LET g_errno = 'apc-195'
   END IF

END FUNCTION 

FUNCTION i203_ryt03(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
DEFINE l_ryqacti LIKE ryq_file.ryqacti
DEFINE l_ryx05   LIKE ryx_file.ryx05
DEFINE l_ryq02   LIKE ryq_file.ryq02
   LET g_errno = ''
   SELECT ryq02,ryqacti INTO l_ryq02,l_ryqacti
     FROM ryq_file
    WHERE ryq01 = g_ryt[l_ac1].ryt03 
   CASE 
      WHEN SQLCA.SQLCODE = 100          LET g_errno = 'apc-190'
      WHEN l_ryqacti <> 'Y'             LET g_errno = 'apc-191'
      WHEN l_ryq02 <> g_rys[l_ac].rys02 LET g_errno = 'apc-194'
      OTHERWISE                         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      SELECT ryx05 INTO l_ryx05
        FROM ryx_file
       WHERE ryx01 = 'ryq_file'
         AND ryx02 = 'ryq01'
         AND ryx03 = g_ryt[l_ac1].ryt03
         AND ryx04 = g_lang
      LET g_ryt[l_ac1].ryt03_desc = l_ryx05
      DISPLAY BY NAME g_ryt[l_ac1].ryt03_desc
   END IF
END FUNCTION

FUNCTION i203_rys02_m()
DEFINE   tok         base.StringTokenizer
DEFINE   l_sql       STRING
DEFINE   l_n         LIKE type_file.num5
DEFINE   l_e         LIKE type_file.num5
DEFINE   l_rys       RECORD LIKE rys_file.*
DEFINE   l_success   LIKE type_file.chr1
   BEGIN WORK
   LET l_success = 'Y'
   LET l_n = 0
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_rys02,"|")
   WHILE tok.hasMoreTokens()
      INITIALIZE l_rys.* TO NULL
      LET l_rys.rys02 = tok.nextToken()
      SELECT count(*) INTO l_n FROM rys_file
       WHERE rys01 = g_ryr.ryr01
         AND rys02 = l_rys.rys02
      IF l_n > 0 THEN
         CONTINUE WHILE
      ELSE 
         LET l_rys.rys01 = g_ryr.ryr01
         LET l_rys.rys03 = '1'
         LET l_rys.rysacti = 'Y'
         INSERT INTO rys_file VALUES(l_rys.*)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('',l_rys.rys02,'Ins rys_file',SQLCA.sqlcode,1)
            LET l_success = 'N'
            CONTINUE WHILE
         END IF   
      END IF
      LET l_ac = l_ac + 1
   END WHILE
   IF l_success <> 'Y' THEN
      CALL s_showmsg()
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF  
END FUNCTION

FUNCTION i203_ryt03_m()
DEFINE   tok         base.StringTokenizer
DEFINE   l_sql       STRING
DEFINE   l_n         LIKE type_file.num5
DEFINE   l_ryt       RECORD LIKE ryt_file.*
DEFINE   l_success   LIKE type_file.chr1
   BEGIN WORK
   LET l_success = 'Y'
   LET l_n = 0
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_ryt03,"|")
   WHILE tok.hasMoreTokens()
      INITIALIZE l_ryt.* TO NULL
      LET l_ryt.ryt03 = tok.nextToken()
      SELECT count(*) INTO l_n FROM ryt_file
       WHERE ryt01 = g_ryr.ryr01
         AND ryt02 = g_rys[l_ac].rys02
         AND ryt03 = l_ryt.ryt03
      IF l_n > 0 THEN
         CONTINUE WHILE
      ELSE 
         LET l_ryt.ryt01 = g_ryr.ryr01
         LET l_ryt.ryt02 = g_rys[l_ac].rys02
         LET l_ryt.ryt04 = '1'
         LET l_ryt.rytacti = 'Y'
         INSERT INTO ryt_file VALUES(l_ryt.*)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('',l_ryt.ryt03,'Ins ryt_file',SQLCA.sqlcode,1)
            LET l_success = 'N'
            CONTINUE WHILE
         END IF   
      END IF
      LET l_ac1 = l_ac1 + 1
   END WHILE
   IF l_success <> 'Y' THEN
      CALL s_showmsg()
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF  
END FUNCTION

FUNCTION i203_delall()

   SELECT COUNT(*) INTO g_cnt FROM rys_file
    WHERE rys01 = g_ryr.ryr01

   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM ryr_file WHERE ryr01 = g_ryr.ryr01
      DELETE FROM zw_file  WHERE zw01  = g_ryr.ryr01      #FUN-D20038 add
   END IF

END FUNCTION


FUNCTION i203_b_fill(p_wc1,p_wc2)                #FUN-C60024  add p_wc2
DEFINE p_wc1      STRING
DEFINE p_wc2      STRING                         #FUN-C60024  add
DEFINE l_ryx05  LIKE ryx_file.ryx05
   LET g_sql = "SELECT rys02,'',rys03,rysacti ",
               "  FROM rys_file",
               " WHERE rys01 ='",g_ryr.ryr01,"' "

   IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
   END IF
#FUN-C60024  add begin ---
   IF p_wc2 <> " 1=1" THEN
      LET g_sql = g_sql CLIPPED," AND rys02 IN (SELECT ryt02 FROM ryt_file WHERE ",p_wc2 CLIPPED,")" 
   END IF 
#FUN-C60024  add end ----
   LET g_sql=g_sql CLIPPED," ORDER BY rys02 "

   PREPARE i203_pb FROM g_sql
   DECLARE rys_cs CURSOR FOR i203_pb

   CALL g_rys.clear()
   LET g_cnt = 1
   FOREACH rys_cs INTO g_rys[g_cnt].*
      IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
      END IF
      LET g_errno = ' '
      SELECT ryx05 INTO l_ryx05
        FROM ryx_file
       WHERE ryx01 = 'ryp_file'
         AND ryx02 = 'ryp01'
         AND ryx03 = g_rys[g_cnt].rys02
         AND ryx04 = g_lang
      LET g_rys[g_cnt].rys02_desc = l_ryx05
      DISPLAY BY NAME g_rys[g_cnt].rys02_desc
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      LET l_ryx05 = ''
   END FOREACH
   LET g_rec_b=g_cnt-1
   CALL g_rys.deleteElement(g_cnt)
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION i203_b1_fill(p_wc2)
DEFINE p_wc2    STRING
DEFINE l_ryx05  LIKE ryx_file.ryx05
   LET g_sql = "SELECT ryt03,'',ryt04,rytacti ",
               "  FROM ryt_file",
               " WHERE ryt01 ='",g_ryr.ryr01,"' ",
               " AND ryt02 ='",g_rys[l_ac].rys02,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ryt03 "
   PREPARE i203_pb_1 FROM g_sql
   DECLARE ryt_cs CURSOR FOR i203_pb_1
   CALL g_ryt.clear()
   LET g_cnt1 = 1
   FOREACH ryt_cs INTO g_ryt[g_cnt1].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
        END IF
       LET g_errno = ' '
      SELECT ryx05 INTO l_ryx05
        FROM ryx_file
       WHERE ryx01 = 'ryq_file'
         AND ryx02 = 'ryq01'
         AND ryx03 = g_ryt[g_cnt1].ryt03
         AND ryx04 = g_lang
      LET g_ryt[g_cnt1].ryt03_desc = l_ryx05
      DISPLAY BY NAME g_ryt[g_cnt1].ryt03_desc
      LET g_cnt1 = g_cnt1 + 1
      IF g_cnt1 > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      LET l_ryx05 = ''
   END FOREACH
   LET g_rec_b1=g_cnt1-1
   CALL g_ryt.deleteElement(g_cnt1)
   DISPLAY g_rec_b1 TO FORMONLY.cn3
   LET g_cnt1 = 0
END FUNCTION

FUNCTION i203_b2_fill(p_wc1,p_wc2)
DEFINE p_wc1     STRING
DEFINE p_wc2     STRING
DEFINE l_ryx05   LIKE ryx_file.ryx05
DEFINE l_ryx05_1 LIKE ryx_file.ryx05
DEFINE l_table   LIKE type_file.chr1000
DEFINE l_where   LIKE type_file.chr1000
   LET g_sql = "SELECT ryr01,ryr02,ryr03,ryrpos,",
               "rys02,'',rys03,rysacti,",
               "ryt03,'',ryt04,rytacti "
   LET l_table = " FROM ryr_file LEFT JOIN rys_file ON ryr01 = rys01 "
   LET l_where = " WHERE ",g_wc CLIPPED
   IF p_wc1 <> " 1=1" THEN
      LET l_table = l_table," AND ",p_wc1 CLIPPED 
   END IF 
   LET l_table = l_table," LEFT JOIN ryt_file ON ryt01 = rys01 AND rys02 = ryt02 "
   IF p_wc2 <> " 1=1" THEN
      LET l_table = l_table," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql = g_sql,l_table,l_where
   LET g_sql=g_sql CLIPPED," ORDER BY ryr01,rys02,ryt03 "
   PREPARE i203_pb_2 FROM g_sql
   DECLARE ryr_cs CURSOR FOR i203_pb_2
   CALL g_ryr1.clear()
   LET g_cnt2 = 1
   FOREACH ryr_cs INTO g_ryr1[g_cnt2].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_errno = ' '

      SELECT ryx05 INTO l_ryx05
        FROM ryx_file
       WHERE ryx01 = 'ryp_file'
         AND ryx02 = 'ryp01'
         AND ryx03 = g_ryr1[g_cnt2].rys02
         AND ryx04 = g_lang
      LET g_ryr1[g_cnt2].rys02_desc1 = l_ryx05
    
      SELECT ryx05 INTO l_ryx05_1
        FROM ryx_file
       WHERE ryx01 = 'ryq_file'
         AND ryx02 = 'ryq01'
         AND ryx03 = g_ryr1[g_cnt2].ryt03
         AND ryx04 = g_lang       
      LET g_ryr1[g_cnt2].ryt03_desc1 = l_ryx05_1 
      DISPLAY BY NAME g_ryr1[g_cnt2].rys02_desc1,g_ryr1[g_cnt2].ryt03_desc1
      LET g_cnt2 = g_cnt2 + 1
      IF g_cnt1 > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      LET l_ryx05 = ''
      LET l_ryx05_1 = ''
   END FOREACH
   LET g_rec_b2=g_cnt2-1
   CALL g_ryr1.deleteElement(g_cnt2)
   LET g_cnt2 = 0
END FUNCTION

FUNCTION i203_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ryr01",TRUE)
   END IF
END FUNCTION

FUNCTION i203_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ryr01",FALSE)
   END IF
END FUNCTION

FUNCTION i203_set_entry_b1(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("rys02",TRUE)
   END IF
END FUNCTION 

FUNCTION i203_set_no_entry_b1(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rys02",FALSE)
   END IF
END FUNCTION 

FUNCTION i203_set_entry_b2(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ryt03",TRUE)
   END IF
END FUNCTION

FUNCTION i203_set_no_entry_b2(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ryt03",FALSE)
   END IF
END FUNCTION

#FUN-C40084
