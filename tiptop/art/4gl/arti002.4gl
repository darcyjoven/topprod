# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: arti002.4gl
# Descriptions...: 条码价签方案生效范围维护作业
# Date & Author..: FUN-B30031 2011/04/20 By shiwuying
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_rza         RECORD LIKE rza_file.*,
       g_rza_t       RECORD LIKE rza_file.*,
       g_rza01_t     LIKE rza_file.rza01,
       g_rzb         DYNAMIC ARRAY OF RECORD
          rzb02      LIKE rzb_file.rzb02,
          azw08      LIKE azw_file.azw08
                     END RECORD,
       g_rzb_t       RECORD
          rzb02      LIKE rzb_file.rzb02,
          azw08      LIKE azw_file.azw08
                     END RECORD,
       g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       g_str         LIKE type_file.chr1000,
       l_ac          LIKE type_file.num5
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5         
DEFINE g_name              STRING
DEFINE g_xml_out           STRING

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT rza01,rza03,rza04 FROM rza_file WHERE rza01 = ? FOR UPDATE "
   LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

   DECLARE i002_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW i002_w WITH FORM "art/42f/arti002"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL i002_menu()
   
   CLOSE WINDOW i002_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i002_cs()
 DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM
   CALL g_rzb.clear()
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_rza.* TO NULL
   CONSTRUCT BY NAME g_wc ON rza01,rza03,rza04 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON ACTION controlp
          CASE
             WHEN INFIELD(rza01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form ="q_rza01"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rza01
                NEXT FIELD rza01
             WHEN INFIELD(rza04)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form ="q_rza04"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rza04
                NEXT FIELD rza04
             OTHERWISE EXIT CASE
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
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF
   
   CONSTRUCT g_wc2 ON rzb02
                 FROM s_rzb[1].rzb02
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      ON ACTION controlp
         CASE
            WHEN INFIELD(rzb02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_rzb02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rzb02
               NEXT FIELD rzb02
            OTHERWISE EXIT CASE  
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

      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF

   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT rza01 FROM rza_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY rza01"
   ELSE
      LET g_sql = "SELECT UNIQUE rza01 ",
                  "  FROM rza_file, rzb_file ",
                  " WHERE rza01 = rzb01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY rza01"
   END IF
   PREPARE i002_prepare FROM g_sql
   DECLARE i002_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i002_prepare

   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM rza_file WHERE ",g_wc CLIPPED

   ELSE
      LET g_sql="SELECT COUNT(DISTINCT rza01) FROM rza_file,rzb_file",
                " WHERE rza01 = rzb01 ",
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i002_precount FROM g_sql
   DECLARE i002_count CURSOR FOR i002_precount
END FUNCTION

FUNCTION i002_menu()
 DEFINE l_msg        LIKE type_file.chr1000

   WHILE TRUE
      CALL i002_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i002_q()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i002_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "preview"
            IF cl_chk_act_auth() THEN
               CALL i002_print()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rzb),'','')
            END IF

         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_rza.rza01 IS NOT NULL THEN
                 LET g_doc.column1 = "rza01"
                 LET g_doc.value1 = g_rza.rza01
                 CALL cl_doc()
               END IF
         END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rzb TO s_rzb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION first
         CALL i002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION previous
         CALL i002_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION jump
         CALL i002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL i002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION last
         CALL i002_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION preview
         LET g_action_choice="preview"
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

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i002_bp_refresh()
  DISPLAY ARRAY g_rzb TO s_rzb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION

FUNCTION i002_rza04(p_cmd)
 DEFINE  p_cmd       LIKE type_file.chr1
 DEFINE  l_azw08     LIKE azw_file.azw08

   LET g_errno=''
   SELECT azw08 INTO l_azw08
     FROM azw_file
    WHERE azw01=g_rza.rza04
   CASE WHEN SQLCA.sqlcode=100 LET g_errno = 'anm-027' 
                               LET l_azw08 = NULL
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
     
   IF cl_null(g_errno) OR p_cmd= 'd' THEN
      DISPLAY l_azw08 TO FORMONLY.rza04_desc
   END IF 
END FUNCTION

FUNCTION i002_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_rzb.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL i002_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_rza.* TO NULL
      RETURN
   END IF

   OPEN i002_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rza.* TO NULL
   ELSE
      OPEN i002_count
      FETCH i002_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt

      CALL i002_fetch('F')
   END IF

END FUNCTION

FUNCTION i002_fetch(p_flag)
 DEFINE p_flag          LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     i002_cs INTO g_rza.rza01
      WHEN 'P' FETCH PREVIOUS i002_cs INTO g_rza.rza01
      WHEN 'F' FETCH FIRST    i002_cs INTO g_rza.rza01
      WHEN 'L' FETCH LAST     i002_cs INTO g_rza.rza01
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
            FETCH ABSOLUTE g_jump i002_cs INTO g_rza.rza01
            LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rza.rza01,SQLCA.sqlcode,0)
      INITIALIZE g_rza.* TO NULL
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

  #SELECT * INTO g_rza.* FROM rza_file WHERE rza01 = g_rza.rza01
   SELECT rza01,rza03,rza04 INTO g_rza.rza01,g_rza.rza03,g_rza.rza04
     FROM rza_file WHERE rza01 = g_rza.rza01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","rza_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_rza.* TO NULL
      RETURN
   END IF

   CALL i002_show()

END FUNCTION

FUNCTION i002_show()
DEFINE l_rtz13     LIKE rtz_file.rtz13   #FUN-A80148 add
DEFINE l_lmb03     LIKE lmb_file.lmb03
DEFINE l_lmc04     LIKE lmc_file.lmc04
DEFINE l_azt02     LIKE azt_file.azt02

   LET g_rza_t.* = g_rza.*
   DISPLAY BY NAME g_rza.rza01,g_rza.rza03,g_rza.rza04
   
   CALL i002_rza04('d')
   CALL i002_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i002_b()
DEFINE l_ac_t          LIKE type_file.num5
DEFINE l_n             LIKE type_file.num5
DEFINE l_lock_sw       LIKE type_file.chr1
DEFINE p_cmd           LIKE type_file.chr1
DEFINE l_allow_insert  LIKE type_file.num5
DEFINE l_allow_delete  LIKE type_file.num5
DEFINE tok             base.StringTokenizer
DEFINE l_azw01         LIKE azw_file.azw01
DEFINE l_flag          LIKE type_file.chr1

    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF cl_null(g_rza.rza01) THEN
       RETURN
    END IF

    IF g_plant <> g_rza.rza04 THEN
       CALL cl_err(g_rza.rza04,'art-977',0)
       RETURN
    END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql = " SELECT rzb02,'' ",
                       " FROM rzb_file ",
                       " WHERE rzb01 = ? AND rzb02 = ?",
                       "  FOR UPDATE  "
    LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)

    DECLARE i002_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_flag = 'N'

    INPUT ARRAY g_rzb WITHOUT DEFAULTS FROM s_rzb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
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

           OPEN i002_cl USING g_rza.rza01
           IF STATUS THEN
              CALL cl_err("OPEN i002_cl:", STATUS, 1)
              CLOSE i002_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH i002_cl INTO g_rza.rza01,g_rza.rza03,g_rza.rza04
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rza.rza01,SQLCA.sqlcode,0)
              CLOSE i002_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rzb_t.* = g_rzb[l_ac].*  #BACKUP
              OPEN i002_bcl USING g_rza.rza01,g_rzb_t.rzb02
              IF STATUS THEN
                 CALL cl_err("OPEN i002_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i002_bcl INTO g_rzb[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rzb_t.rzb02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL i002_rzb02('d')
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_rzb[l_ac].* TO NULL
           LET g_rzb_t.* = g_rzb[l_ac].*
           CALL cl_show_fld_cont()
           LET g_before_input_done = FALSE
           LET g_before_input_done = TRUE
           NEXT FIELD rzb02

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

          INSERT INTO rzb_file(rzb01,rzb02)
          VALUES(g_rza.rza01,g_rzb[l_ac].rzb02)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rzb_file",g_rza.rza01,g_rzb[l_ac].rzb02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF

        AFTER FIELD rzb02
           IF NOT cl_null(g_rzb[l_ac].rzb02) THEN
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rzb[l_ac].rzb02 != g_rzb_t.rzb02) THEN
                 CALL i002_rzb02(p_cmd)
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)
                    LET g_rzb[l_ac].rzb02=g_rzb_t.rzb02
                    NEXT FIELD rzb02
                 END IF
                 LET g_cnt=0
                 SELECT COUNT(*) INTO g_cnt 
                   FROM rzb_file 
                  WHERE rzb01=g_rza.rza01
                    AND rzb02=g_rzb[l_ac].rzb02
                 IF g_cnt>0 THEN 
                    CALL cl_err('','-239',1)
                    LET g_rzb[l_ac].rzb02=g_rzb_t.rzb02
                    NEXT FIELD rzb02
                 END IF      
              END IF
           END IF

        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_rzb_t.rzb02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rzb_file
               WHERE rzb01 = g_rza.rza01
                 AND rzb02 = g_rzb_t.rzb02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rzb_file",g_rza.rza01,g_rzb_t.rzb02,SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rzb[l_ac].* = g_rzb_t.*
              CLOSE i002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_rzb[l_ac].rzb02,-263,1)
              LET g_rzb[l_ac].* = g_rzb_t.*
           ELSE
              UPDATE rzb_file SET rzb02 = g_rzb[l_ac].rzb02
               WHERE rzb01 = g_rza.rza01
                 AND rzb02 = g_rzb_t.rzb02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rzb_file",g_rza.rza01,g_rzb_t.rzb02,SQLCA.sqlcode,"","",1)
                 LET g_rzb[l_ac].* = g_rzb_t.*
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rzb[l_ac].* = g_rzb_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_rzb.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE i002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D30033 Add
           CLOSE i002_bcl
           COMMIT WORK

        ON ACTION controlp
           CASE
              WHEN INFIELD(rzb02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azw13"
                 IF p_cmd = 'a' THEN
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.where = " azw01 IN ",g_auth
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_azw01 = tok.nextToken()
                       IF cl_null(l_azw01) THEN
                          CONTINUE WHILE
                       ELSE
                          LET g_cnt = 0
                          SELECT COUNT(*) INTO l_n  FROM rzb_file
                           WHERE rzb01=g_rza.rza01
                             AND rzb02=l_azw01
                          IF g_cnt > 0 THEN
                             CONTINUE WHILE
                          END IF
                       END IF
                       INSERT INTO rzb_file VALUES (g_rza.rza01,l_azw01)
                    END WHILE
                   LET l_flag = 'Y'
                   EXIT INPUT
                 ELSE
                    LET g_qryparam.default1 = g_rzb[l_ac].rzb02
                    LET g_qryparam.where = " azw01 IN ",g_auth
                    CALL cl_create_qry() RETURNING g_rzb[l_ac].rzb02
                    DISPLAY BY NAME g_rzb[l_ac].rzb02
                    CALL i002_rzb02('d')
                    NEXT FIELD rzb02
                 END IF
              OTHERWISE EXIT CASE
           END CASE

        ON ACTION CONTROLO
           IF INFIELD(rzb02) AND l_ac > 1 THEN
              LET g_rzb[l_ac].* = g_rzb[l_ac-1].*
              LET g_rzb[l_ac].rzb02 = g_rec_b + 1
              NEXT FIELD rzb02
           END IF

        ON ACTION CONTROLR
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

        ON ACTION controls
           CALL cl_set_head_visible("","AUTO")
    END INPUT

    CLOSE i002_bcl
    COMMIT WORK

    IF l_flag = 'Y' THEN
       CALL i002_b_fill(' 1=1')
       CALL i002_b()
    END IF
END FUNCTION

FUNCTION i002_rzb02(p_cmd)
DEFINE   p_cmd           LIKE type_file.chr1
DEFINE   l_azw08         LIKE azw_file.azw08
DEFINE   l_azwacti       LIKE azw_file.azwacti

    LET g_errno =''
    SELECT azw08,azwacti INTO l_azw08,l_azwacti FROM azw_file
     WHERE azw01=g_rzb[l_ac].rzb02
    CASE WHEN SQLCA.sqlcode=100 LET g_errno='100'
                                LET l_azw08 = NULL
         WHEN l_azwacti<>'Y'    LET g_errno='9028'
         OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
    END CASE
    
    IF cl_null(g_errno) THEN 
       LET g_sql = "SELECT azw08 FROM azw_file ",
                   " WHERE azw01='",g_rzb[l_ac].rzb02,"'",
                   "   AND azw01 IN ",g_auth
       PREPARE i002_selazw FROM g_sql
       EXECUTE i002_selazw INTO l_azw08
       IF SQLCA.sqlcode = 100 THEN
          LET g_errno='art-500'
       END IF
    END IF

    IF cl_null(g_errno) OR p_cmd='d' THEN 
       LET g_rzb[l_ac].azw08=l_azw08
       DISPLAY BY NAME g_rzb[l_ac].azw08
    END IF 
END FUNCTION 

FUNCTION i002_b_fill(p_wc2)
DEFINE p_wc2   STRING

   LET g_sql = "SELECT rzb02,'' ",
                "  FROM rzb_file",
                " WHERE rzb01 ='",g_rza.rza01,"' "

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY rzb02 "

   PREPARE i002_pb FROM g_sql
   DECLARE rzb_cs CURSOR FOR i002_pb

   CALL g_rzb.clear()
   LET g_cnt = 1
   FOREACH rzb_cs INTO g_rzb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT azw08 INTO g_rzb[g_cnt].azw08 FROM azw_file
        WHERE azw01 = g_rzb[g_cnt].rzb02
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_rzb.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION i002_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rza01",TRUE)
    END IF
END FUNCTION

FUNCTION i002_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rza01",FALSE)
    END IF
END FUNCTION

FUNCTION i002_print()

   IF cl_null(g_rza.rza01) THEN RETURN END IF

   CALL i002_xml_out()
   CALL i002_xml()
   IF NOT p_pricetag_print(g_rza.rza01,g_name) THEN END IF
END FUNCTION

FUNCTION i002_xml()
DEFINE l_channel       base.Channel
DEFINE l_time     LIKE type_file.chr20                                                                                           
DEFINE l_date1    LIKE type_file.chr20                                                                                           
DEFINE l_dt       LIKE type_file.chr20
DEFINE l_cmd      LIKE type_file.chr1000

    LET l_date1 = g_today                                                                                                            
    LET l_time = g_time                                                                                                            
    LET l_dt   = l_date1[1,2],l_date1[4,5],l_date1[7,8],                                                                             
                 l_time[1,2],l_time[4,5],l_time[7,8]
   #LET g_name = FGL_GETENV("TEMPDIR") CLIPPED,'/',"arti002",l_dt,".xml"
    LET g_name = FGL_GETENV("TEMPDIR") CLIPPED,'/',"arti002",l_dt
    LET g_name = g_name CLIPPED,".xml"
    LET l_cmd  = "rm -f ",g_name
    RUN l_cmd
    LET l_channel = base.Channel.create()
    CALL l_channel.openFile(g_name,"a" )
    CALL l_channel.setDelimiter("")

    CALL l_channel.write(g_xml_out)
    CALL l_channel.close()
END FUNCTION

FUNCTION i002_xml_out()
DEFINE l_str              STRING
DEFINE l_str2             STRING
DEFINE l_i,l_j,l_k,l_kk   LIKE type_file.num10                  
DEFINE l_ima151           LIKE ima_file.ima151
 
  #IF g_rta.getLength() = 0 THEN
  #   RETURN
  #END IF
 
   IF g_rza.rza03='1' THEN
      LET l_str = "<?xml version=\"1.0\" encoding=\"utf-8\"?>", ASCII 10,
                  "<Data>", ASCII 10,
                  "       <DataSet Field=\"ima01|ima02|rta05|ima021|qty\">", ASCII 10
    
      LET l_str2 = "          <Row Data=\"ima01|ima02|rta05|ima021|1\"/>", ASCII 10
      LET l_str = l_str, l_str2
      #FOR l_i = 1 TO g_rta.getLength()
      #    IF g_rta[l_i].sel = 'Y' THEN
      #       FOR l_j = 1 TO g_rta[l_i].qty
      #           LET l_str2 = "          <Row Data=\"",g_rta[l_i].ima01_1,"|",g_rta[l_i].ima02,"|",
      #                         g_rta[l_i].rta05_1,"|",g_rta[l_i].ima021,"|",g_rta[l_i].qty,"\"/>", ASCII 10
      #           LET l_str = l_str, l_str2
      #       END FOR
      #    END IF
      #END FOR
   ELSE
      LET l_str = "<?xml version=\"1.0\" encoding=\"utf-8\"?>", ASCII 10,
                  "<Data>", ASCII 10,
                  "       <DataSet Field=\"ima01|ima02|rta05|ima021|rta03|rtg05|",
                  "rtg06|rac05|rac09|rac12|rac13|rac14|rac15\">", ASCII 10
     
      LET l_str2 = "          <Row Data=\"ima01|ima02|rta05| |rta03|rtg05|rtg06|rac05|rac09|rac12|rac13|rac14|rac15\"/>", ASCII 10
      LET l_str = l_str, l_str2
   END IF

   LET l_str = l_str,
               "       </DataSet>", ASCII 10,
               "</Data>", ASCII 10
 
   LET g_xml_out = l_str
END FUNCTION
#FUN-B30031


