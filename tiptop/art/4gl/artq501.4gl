# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: "artq501.4gl"
# Descriptions...: 需求匯總查詢作業
# Date & Author..: FUN-BA0103 11/10/24 By suncx
# Modify.........: No:FUN-BA0103 11/10/24 By suncx


DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_ruc   DYNAMIC ARRAY OF RECORD
               ruc00  LIKE ruc_file.ruc00,
               ruc01  LIKE ruc_file.ruc01,
               ruc06  LIKE ruc_file.ruc06,
               ruc02  LIKE ruc_file.ruc02,
               ruc03  LIKE ruc_file.ruc03,
               ruc05  LIKE ruc_file.ruc05,
               ruc27  LIKE ruc_file.ruc27,
               ruc04  LIKE ruc_file.ruc04,
               ruc15  LIKE ruc_file.ruc15,
               ima131 LIKE ima_file.ima131,
               ruc13  LIKE ruc_file.ruc13,
               ruc14  LIKE ruc_file.ruc14,
               ruc16  LIKE ruc_file.ruc16,
               ruc17  LIKE ruc_file.ruc17,
               ruc07  LIKE ruc_file.ruc07,
               ruc18  LIKE ruc_file.ruc18,
               ruc19  LIKE ruc_file.ruc19,
               ruc20  LIKE ruc_file.ruc20,
               ruc21  LIKE ruc_file.ruc21,
               ruc22  LIKE ruc_file.ruc22,
               ruc28  LIKE ruc_file.ruc28,
               ruc08  LIKE ruc_file.ruc08,
               ruc09  LIKE ruc_file.ruc09,
               ruc10  LIKE ruc_file.ruc10,
               ruc11  LIKE ruc_file.ruc11,
               ruc12  LIKE ruc_file.ruc12,
               ruc26  LIKE ruc_file.ruc26,
               ruc23  LIKE ruc_file.ruc23,
               ruc24  LIKE ruc_file.ruc24,
               ruc25  LIKE ruc_file.ruc25,
               ruc29  LIKE ruc_file.ruc29,
               ruc30  LIKE ruc_file.ruc30
               END RECORD,
       g_ruc_t RECORD
               ruc00  LIKE ruc_file.ruc00,
               ruc01  LIKE ruc_file.ruc01,
               ruc06  LIKE ruc_file.ruc06,
               ruc02  LIKE ruc_file.ruc02,
               ruc03  LIKE ruc_file.ruc03,
               ruc05  LIKE ruc_file.ruc05,
               ruc27  LIKE ruc_file.ruc27,
               ruc04  LIKE ruc_file.ruc04,
               ruc15  LIKE ruc_file.ruc15,
               ima131 LIKE ima_file.ima131,
               ruc13  LIKE ruc_file.ruc13,
               ruc14  LIKE ruc_file.ruc14,
               ruc16  LIKE ruc_file.ruc16,
               ruc17  LIKE ruc_file.ruc17,
               ruc07  LIKE ruc_file.ruc07,
               ruc18  LIKE ruc_file.ruc18,
               ruc19  LIKE ruc_file.ruc19,
               ruc20  LIKE ruc_file.ruc20,
               ruc21  LIKE ruc_file.ruc21,
               ruc22  LIKE ruc_file.ruc22,
               ruc28  LIKE ruc_file.ruc28,
               ruc08  LIKE ruc_file.ruc08,
               ruc09  LIKE ruc_file.ruc09,
               ruc10  LIKE ruc_file.ruc10,
               ruc11  LIKE ruc_file.ruc11,
               ruc12  LIKE ruc_file.ruc12,
               ruc26  LIKE ruc_file.ruc26,
               ruc23  LIKE ruc_file.ruc23,
               ruc24  LIKE ruc_file.ruc24,
               ruc25  LIKE ruc_file.ruc25,
               ruc29  LIKE ruc_file.ruc29,
               ruc30  LIKE ruc_file.ruc30
               END RECORD   
DEFINE g_sql   STRING,
       g_wc    STRING,
       g_rec_b LIKE type_file.num5,
       l_ac    LIKE type_file.num5
DEFINE p_row,p_col LIKE type_file.num5
DEFINE g_cnt       LIKE type_file.num10
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
   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 4 LET p_col = 10
   OPEN WINDOW q501_w AT p_row,p_col WITH FORM "art/42f/artq501"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_wc = " 1=1"
   CALL q501_b_fill(g_wc)
   CALL q501_menu()
   CLOSE WINDOW q501_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q501_menu()
   DEFINE l_cmd     STRING         

   WHILE TRUE
      CALL q501_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q501_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET l_cmd='p_query "artq501" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION q501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = ''

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ruc TO s_ruc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
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

      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      AFTER DISPLAY
         CONTINUE DISPLAY

    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q501_q()
   CLEAR FORM
   CONSTRUCT g_wc ON ruc00,ruc01,ruc06,ruc02,ruc03,ruc05,ruc27,ruc04,
                     ruc15,ima131,ruc13,ruc14,ruc16,ruc17,ruc07,ruc18,
                     ruc19,ruc20,ruc21,ruc22,ruc28,ruc08,ruc09,ruc10,
                     ruc11,ruc12,ruc26,ruc23,ruc24,ruc25,ruc29,ruc30            
                FROM s_ruc[1].ruc00,s_ruc[1].ruc01,s_ruc[1].ruc06,s_ruc[1].ruc02,
                     s_ruc[1].ruc03,s_ruc[1].ruc05,s_ruc[1].ruc27,s_ruc[1].ruc04,
                     s_ruc[1].ruc15,s_ruc[1].ima131,s_ruc[1].ruc13,s_ruc[1].ruc14,
                     s_ruc[1].ruc16,s_ruc[1].ruc17,s_ruc[1].ruc07,s_ruc[1].ruc18,
                     s_ruc[1].ruc19,s_ruc[1].ruc20,s_ruc[1].ruc21,s_ruc[1].ruc22,
                     s_ruc[1].ruc28,s_ruc[1].ruc08,s_ruc[1].ruc09,s_ruc[1].ruc10,
                     s_ruc[1].ruc11,s_ruc[1].ruc12,s_ruc[1].ruc26,s_ruc[1].ruc23,
                     s_ruc[1].ruc24,s_ruc[1].ruc25,s_ruc[1].ruc29,s_ruc[1].ruc30
      ON ACTION controlp
         CASE
            WHEN INFIELD(ruc01)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruc01
               NEXT FIELD ruc01
            WHEN INFIELD(ruc02)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ruc02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruc02
               NEXT FIELD ruc02
            WHEN INFIELD(ruc06)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruc06
               NEXT FIELD ruc06
            WHEN INFIELD(ruc04)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ruc004"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruc04
               NEXT FIELD ruc04
            WHEN INFIELD(ima131)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima131"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima131
               NEXT FIELD ima131
            WHEN INFIELD(ruc13)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruc13
               NEXT FIELD ruc13
            WHEN INFIELD(ruc16)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gfe"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruc16
               NEXT FIELD ruc16
            WHEN INFIELD(ruc28)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ruc28"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruc28
               NEXT FIELD ruc28
            WHEN INFIELD(ruc10)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc3"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruc10
               NEXT FIELD ruc10
            WHEN INFIELD(ruc26)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruc26
               NEXT FIELD ruc26
            WHEN INFIELD(ruc30)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ruc01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ruc30
               NEXT FIELD ruc30

            OTHERWISE
               EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rucser', 'rucgrup') #FUN-980030

   IF INT_FLAG THEN
      RETURN
   END IF

   CALL q501_b_fill(g_wc)
END FUNCTION 

FUNCTION q501_b_fill(p_wc2)
DEFINE   p_wc2       STRING

    LET g_sql = "SELECT ruc00,ruc01,ruc06,ruc02,ruc03,ruc05,ruc27,ruc04,ruc15,ima131,",
                "       ruc13,ruc14,ruc16,ruc17,ruc07,ruc18,ruc19,ruc20,ruc21,ruc22,",
                "       ruc28,ruc08,ruc09,ruc10,ruc11,ruc12,ruc26,ruc23,ruc24,ruc25,",
                "       ruc29,ruc30",
                "  FROM ruc_file LEFT JOIN ima_file",
                "    ON ruc04 = ima01", 
                " WHERE ",p_wc2 CLIPPED,
                " ORDER BY ruc01,ruc06"

    PREPARE q501_pb FROM g_sql
    DECLARE ruc_cs CURSOR FOR q501_pb

    CALL g_ruc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH ruc_cs INTO g_ruc[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1)
        EXIT FOREACH
        END IF
        SELECT ima131 INTO g_ruc[g_cnt].ima131 FROM ima_file
        WHERE ima01 = g_ruc[g_cnt].ruc04
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH

    CALL g_ruc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION
#FUN-BA0103
