# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artp254.4gl
# Descriptions...: 订货需求整批抛转作业
# Date & Author..: NO.FUN-CC0057 12/12/13 By xumeimei  
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  tm      RECORD
                ruc01         STRING,
                ruc28         LIKE ruc_file.ruc28, 
                ruc27         STRING,
                ruc32         STRING
                END RECORD   
DEFINE  g_ruc   DYNAMIC ARRAY OF RECORD
                sel           LIKE type_file.chr1,
                ruc01         LIKE ruc_file.ruc01,
                ruc06         LIKE ruc_file.ruc06,
                ruc28         LIKE ruc_file.ruc28,
                ruc02         LIKE ruc_file.ruc02,
                ruc03         LIKE ruc_file.ruc03,
                ruc05         LIKE ruc_file.ruc05,
                ruc27         LIKE ruc_file.ruc27,
                ruc04         LIKE ruc_file.ruc04,
                ima02         LIKE ima_file.ima02,
                ima131        LIKE ima_file.ima131,
                ruc16         LIKE ruc_file.ruc16,
                ruc18         LIKE ruc_file.ruc18,
                ruc21         LIKE ruc_file.ruc21,
                ruc08         LIKE ruc_file.ruc08,
                ruc09         LIKE ruc_file.ruc09,
                ruc33         LIKE ruc_file.ruc33,
                ruc34         LIKE ruc_file.ruc34
                END RECORD
DEFINE  g_ruc_t DYNAMIC ARRAY OF RECORD
                sel           LIKE type_file.chr1,
                ruc01         LIKE ruc_file.ruc01,
                ruc06         LIKE ruc_file.ruc06,
                ruc28         LIKE ruc_file.ruc28,
                ruc02         LIKE ruc_file.ruc02,
                ruc03         LIKE ruc_file.ruc03,
                ruc05         LIKE ruc_file.ruc05,
                ruc27         LIKE ruc_file.ruc27,
                ruc04         LIKE ruc_file.ruc04,
                ima02         LIKE ima_file.ima02,
                ima131        LIKE ima_file.ima131,
                ruc16         LIKE ruc_file.ruc16,
                ruc18         LIKE ruc_file.ruc18,
                ruc21         LIKE ruc_file.ruc21,
                ruc08         LIKE ruc_file.ruc08,
                ruc09         LIKE ruc_file.ruc09,
                ruc33         LIKE ruc_file.ruc33,
                ruc34         LIKE ruc_file.ruc34
                END RECORD
DEFINE g_cnt                  LIKE type_file.num10
DEFINE g_rec_b                LIKE type_file.num10
DEFINE l_ac                   LIKE type_file.num10
DEFINE l_ac_t                 LIKE type_file.num10
DEFINE g_sql                  STRING 
DEFINE g_curs_index           LIKE type_file.num10
DEFINE g_row_count            LIKE type_file.num10

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

   DROP TABLE  p254_tmp;
   CREATE TEMP TABLE  p254_tmp(
           sel           LIKE type_file.chr1,
           ruc01         LIKE ruc_file.ruc01,
           ruc06         LIKE ruc_file.ruc06,
           ruc28         LIKE ruc_file.ruc28,
           ruc02         LIKE ruc_file.ruc02,
           ruc03         LIKE ruc_file.ruc03,
           ruc05         LIKE ruc_file.ruc05,
           ruc27         LIKE ruc_file.ruc27,
           ruc04         LIKE ruc_file.ruc04,
           ima02         LIKE ima_file.ima02,
           ima131        LIKE ima_file.ima131,
           ruc16         LIKE ruc_file.ruc16,
           ruc18         LIKE ruc_file.ruc18,
           ruc21         LIKE ruc_file.ruc21,
           ruc08         LIKE ruc_file.ruc08,
           ruc09         LIKE ruc_file.ruc09,
           ruc33         LIKE ruc_file.ruc33,
           ruc34         LIKE ruc_file.ruc34,
           ruc12         LIKE ruc_file.ruc12,
           ruc22         LIKE ruc_file.ruc22,
           ruc32         LIKE ruc_file.ruc32);
   DELETE FROM  p254_tmp WHERE 1=1;
   
   OPEN WINDOW p254_w WITH FORM "art/42f/artp254"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()   
   LET g_action_choice = ""
   CALL cl_set_comp_visible("ruc33",FALSE)
   CALL p254_q()
   CALL p254_menu()
 
   CLOSE WINDOW p254_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p254_curs()
   CLEAR FORM 
   CALL g_ruc.clear()
   DIALOG ATTRIBUTES(UNBUFFERED)
   CONSTRUCT BY NAME tm.ruc01 ON ruc01
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(ruc01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ruc01"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    LET tm.ruc01 = g_qryparam.multiret
                    DISPLAY tm.ruc01 TO ruc01
                    NEXT FIELD ruc01 
              END CASE
        AFTER CONSTRUCT
    END CONSTRUCT
    INPUT BY NAME tm.ruc28
    END INPUT
    CONSTRUCT BY NAME tm.ruc27 ON ruc27
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
    END CONSTRUCT
    INPUT BY NAME tm.ruc32
    END INPUT
    BEFORE DIALOG
       LET tm.ruc32 = g_plant
       DISPLAY tm.ruc32 TO ruc32 
       LET tm.ruc28 = '2'
       DISPLAY tm.ruc28 TO ruc28

    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE DIALOG    
 
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
 
    ON ACTION close
       LET INT_FLAG=1
       EXIT DIALOG 
 
    ON ACTION ACCEPT
       IF cl_null(tm.ruc01) THEN
          LET tm.ruc01 = " 1=1"
       END IF
       IF cl_null(tm.ruc27) THEN
          LET tm.ruc27 = " 1=1"
       END IF
       ACCEPT DIALOG
 
    ON ACTION cancel
       LET INT_FLAG = 1
       EXIT DIALOG 
    END DIALOG       
    IF INT_FLAG THEN
       RETURN
    END IF
END FUNCTION

FUNCTION p254_menu()
DEFINE l_n   LIKE type_file.num10 

   WHILE TRUE
      CALL p254_bp("G")

      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p254_q()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n
                 FROM p254_tmp
               IF l_n > 0 THEN
                  CALL p254_b()
               ELSE
                  RETURN
               END IF
            END IF
            
         WHEN "select_all"
            IF cl_chk_act_auth() THEN
               CALL p254_yn('Y')
            END IF
            
         WHEN "cancel_all"
            IF cl_chk_act_auth() THEN
               CALL p254_yn('N')
            END IF
            
         WHEN "trans_product"
            IF cl_chk_act_auth() THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n
                 FROM p254_tmp
                WHERE sel = 'Y'
               IF l_n > 0 THEN
                  CALL p254_tp()
               END IF
            END IF

         WHEN "turn_trans"
            IF cl_chk_act_auth() THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n 
                 FROM p254_tmp
                WHERE sel = 'Y'
               IF l_n > 0 THEN
                  CALL p254_tt()
               END IF
            END IF
            
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         WHEN "g_idle_seconds"
            CALL cl_on_idle()
            CONTINUE WHILE

         WHEN "about"
            CALL cl_about()

         WHEN "close"
            LET INT_FLAG = FALSE
            LET g_action_choice = "exit"
            EXIT WHILE
    
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_ruc),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION p254_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1
DEFINE   l_ac   INTEGER
   IF p_ud <> "G" OR g_action_choice = "detail"  THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_ruc TO s_ruc.* ATTRIBUTE(COUNT = g_cnt)
        BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

      END DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DIALOG

      ON ACTION select_all
         LET g_action_choice="select_all"
         CALL p254_yn('Y')

      ON ACTION cancel_all
         LET g_action_choice="cancel_all"
         CALL p254_yn('N')
          
      ON ACTION trans_product
         LET g_action_choice="trans_product"
         EXIT DIALOG
      
      ON ACTION turn_trans
         LET g_action_choice="turn_trans"
         EXIT DIALOG

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG

      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG
     
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION p254_q()
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)

    INITIALIZE tm.* TO NULL
    MESSAGE "" 
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_ruc.clear()
    DISPLAY ' ' TO FORMONLY.cnt
    CALL p254_curs()  
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE tm.* TO NULL
       RETURN
    END IF
    CALL p254_show()
END FUNCTION
 
FUNCTION p254_show()
    CALL cl_show_fld_cont()
    CALL p254_ins_tmp()
    CALL p254_b_fill()   
END FUNCTION

FUNCTION p254_ins_tmp()
DEFINE l_sql    STRING
DEFINE l_ruc    RECORD
                sel           LIKE type_file.chr1,
                ruc01         LIKE ruc_file.ruc01,
                ruc06         LIKE ruc_file.ruc06,
                ruc28         LIKE ruc_file.ruc28,
                ruc02         LIKE ruc_file.ruc02,
                ruc03         LIKE ruc_file.ruc03,
                ruc05         LIKE ruc_file.ruc05,
                ruc27         LIKE ruc_file.ruc27,
                ruc04         LIKE ruc_file.ruc04,
                ima02         LIKE ima_file.ima02,
                ima131        LIKE ima_file.ima131,
                ruc16         LIKE ruc_file.ruc16,
                ruc18         LIKE ruc_file.ruc18,
                ruc21         LIKE ruc_file.ruc21,
                ruc08         LIKE ruc_file.ruc08,
                ruc09         LIKE ruc_file.ruc09,
                ruc33         LIKE ruc_file.ruc33,
                ruc34         LIKE ruc_file.ruc34
                END RECORD
   DELETE FROM  p254_tmp
   IF cl_null(tm.ruc27) THEN
      LET tm.ruc27 = " 1=1"
   ELSE
      LET tm.ruc27 = cl_replace_str(tm.ruc27,"ruc27","CAST( ruc27 AS date )")
   END IF
   LET l_sql = " SELECT 'N',ruc01,ruc06,ruc28,ruc02,ruc03,ruc05,ruc27,ruc04,'','',",
               "        ruc16,ruc18,ruc21,ruc08,ruc09,ruc33,ruc34 FROM ruc_file",
               "  WHERE (ruc22 = ' ' OR ruc22 is null)",
               "    AND ruc28 = '2'",
               "    AND ruc32 = '",g_plant,"'",
               "    AND ruc12 = '3'",
               "    AND ",tm.ruc27 CLIPPED,
               "    AND ",tm.ruc01 CLIPPED
   PREPARE p254_ins_tmp_pre FROM l_sql
   DECLARE p254_ins_tmp_cs CURSOR FOR p254_ins_tmp_pre
   FOREACH p254_ins_tmp_cs INTO l_ruc.*
      IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
      END IF
      SELECT ima02,ima131 INTO l_ruc.ima02,l_ruc.ima131
        FROM ima_file
       WHERE ima01 = l_ruc.ruc04
      INSERT INTO p254_tmp VALUES ('N',l_ruc.ruc01,l_ruc.ruc06,l_ruc.ruc28,l_ruc.ruc02,l_ruc.ruc03,l_ruc.ruc05,
                                    l_ruc.ruc27,l_ruc.ruc04,l_ruc.ima02,l_ruc.ima131,l_ruc.ruc16,l_ruc.ruc18,
                                    l_ruc.ruc21,l_ruc.ruc08,l_ruc.ruc09,l_ruc.ruc33,l_ruc.ruc34,'3','N',g_plant)
   END FOREACH
END FUNCTION

FUNCTION p254_b_fill()
   DEFINE l_sql         STRING
 
   IF cl_null(tm.ruc27) THEN
      LET tm.ruc27 = " 1=1"
   ELSE
      LET tm.ruc27 = cl_replace_str(tm.ruc27,"ruc27","CAST( ruc27 AS date )")
   END IF
   LET l_sql = " SELECT sel,ruc01,ruc06,ruc28,ruc02,ruc03,ruc05,ruc27,ruc04,ima02,ima131,",
               "         ruc16,ruc18,ruc21,ruc08,ruc09,ruc33,ruc34 FROM p254_tmp",
               "  WHERE ruc22 = 'N'",
               "    AND ruc28 = '2'",
               "    AND ruc32 = '",g_plant,"'",
               "    AND ruc12 = '3'",
               "    AND ",tm.ruc27 CLIPPED,
               "    AND ",tm.ruc01 CLIPPED
   DECLARE p254_sel_ruc_cs CURSOR FROM l_sql 
   CALL g_ruc.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   FOREACH p254_sel_ruc_cs INTO g_ruc[g_cnt].*
      IF SQLCA.SQLCODE THEN
          CALL cl_err('foreach:',SQLCA.SQLCODE,1)
          EXIT FOREACH
      END IF
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ruc.deleteElement(g_cnt)
   
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt
   LET g_cnt = 0
END FUNCTION
FUNCTION p254_b()
DEFINE l_allow_insert  LIKE type_file.num5
DEFINE l_allow_delete  LIKE type_file.num5

   LET g_action_choice = ""
   CALL cl_opmsg('b')
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_ruc WITHOUT DEFAULTS FROM s_ruc.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
             LET l_ac = 1
          END IF

       BEFORE ROW 
          LET l_ac = ARR_CURR()
          BEGIN WORK

       ON ROW CHANGE
          UPDATE p254_tmp SET sel = g_ruc[l_ac].sel
           WHERE ruc01 = g_ruc[l_ac].ruc01
             AND ruc02 = g_ruc[l_ac].ruc02
             AND ruc03 = g_ruc[l_ac].ruc03
             AND ruc28 = '2'
             AND ruc32 = g_plant
             AND ruc12 = '3'
             AND ruc22 = 'N'
           IF SQLCA.SQLCODE THEN
              CALL cl_err3("upd","p254_tmp",g_ruc[l_ac].ruc01,"",SQLCA.SQLCODE,"","",1)
           ELSE
             COMMIT WORK
           END IF

      AFTER ROW
         LET l_ac= ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            ROLLBACK WORK
            EXIT INPUT
         END IF  
         COMMIT WORK
   END INPUT
   COMMIT WORK
   CALL p254_b_fill()
END FUNCTION
FUNCTION p254_yn(p_y)
DEFINE p_y  LIKE type_file.chr1
   UPDATE p254_tmp SET sel = p_y
   CALL p254_b_fill()
END FUNCTION
FUNCTION p254_tp()
DEFINE l_type      LIKE type_file.chr1
DEFINE l_way       STRING 

   OPEN WINDOW artp2541_w WITH FORM "art/42f/artp2541"
          ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_locale("artp2541")
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT l_type FROM type
      END INPUT
      INPUT l_way FROM way
      END INPUT
      BEFORE DIALOG
         LET l_type ='2'
         DISPLAY l_type TO type
      ON ACTION ACCEPT
         CALL p254_tp_ins(l_way)
         ACCEPT DIALOG
      ON ACTION cancel
         EXIT DIALOG
      ON ACTION EXIT
         EXIT DIALOG
   END DIALOG

   CLOSE WINDOW artp2541_w
END FUNCTION

FUNCTION p254_tp_ins(p_way)
DEFINE p_way        LIKE type_file.chr1
DEFINE l_sql        STRING
DEFINE l_rye04      LIKE rye_file.rye04
DEFINE g_tsc        RECORD LIKE tsc_file.*
DEFINE g_tsd        RECORD LIKE tsd_file.*
DEFINE l_rtz07      LIKE rtz_file.rtz07
DEFINE l_ima25      LIKE ima_file.ima25
DEFINE l_ima55      LIKE ima_file.ima55
DEFINE l_ruc02      LIKE ruc_file.ruc02
DEFINE l_ruc04      LIKE ruc_file.ruc04
DEFINE l_ruc16      LIKE ruc_file.ruc16
DEFINE l_ruc18      LIKE ruc_file.ruc18
DEFINE l_ruc21      LIKE ruc_file.ruc21
DEFINE l_bmb03      LIKE bmb_file.bmb03
DEFINE l_bmb10      LIKE bmb_file.bmb10
DEFINE l_bmb06      LIKE bmb_file.bmb06
DEFINE l_bmb07      LIKE bmb_file.bmb07
DEFINE l_tsd02      LIKE tsd_file.tsd02
DEFINE l_flag       LIKE type_file.chr1
DEFINE l_fac        LIKE type_file.num20_6
DEFINE l_flag1      LIKE type_file.chr1
DEFINE l_fac1       LIKE type_file.num20_6
DEFINE l_flag2      LIKE type_file.chr1
DEFINE l_fac2       LIKE type_file.num20_6
DEFINE l_msg        LIKE type_file.chr1000
DEFINE li_result    LIKE type_file.num5
DEFINE l_ruc        DYNAMIC ARRAY OF RECORD
                    tsc01      LIKE tsc_file.tsc01,
                    tsc05      LIKE tsc_file.tsc05,
                    ruc02      LIKE ruc_file.ruc02,
                    ruc04      LIKE ruc_file.ruc04
                    END RECORD
DEFINE l_i          LIKE type_file.num5
DEFINE i            LIKE type_file.num5
DEFINE l_n          LIKE type_file.num5

   LET g_success = 'Y'
   BEGIN WORK
   CALL s_get_defslip("atm","U6",g_plant,'N') RETURNING l_rye04
   IF cl_null(l_rye04) THEN
      CALL cl_err('','art-315',1)
      LET g_success = 'N'
   END IF
   IF p_way = '1' THEN
      LET l_i = 1
      LET g_sql = "SELECT ruc04,ruc16,SUM(ruc18),SUM(ruc21) FROM p254_tmp",
                  " WHERE sel = 'Y'",
                  "   AND ruc34 is null",
                  " GROUP BY ruc04,ruc16",
                  " ORDER BY ruc04,ruc16"
      DECLARE p254_sel_ruc3_cs CURSOR FROM g_sql
      FOREACH p254_sel_ruc3_cs INTO l_ruc04,l_ruc16,l_ruc18,l_ruc21
         CALL s_auto_assign_no("atm",l_rye04,g_today,"U6","tsc_file","tsc",g_plant,"","")
              RETURNING li_result,g_tsc.tsc01
         IF (NOT li_result) THEN
            CALL cl_err('','sub-145',1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01 = l_ruc04
         SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_ruc04
         SELECT rtz07 INTO l_rtz07 FROM rtz_file WHERE rtz01 = g_plant
         LET g_tsc.tsc02 = g_today
         LET g_tsc.tsc03 = l_ruc04
         LET g_tsc.tsc04 = l_ima55
         CALL s_umfchk(l_ruc04,l_ima55,l_ima25)
              RETURNING l_flag,l_fac
         IF l_flag = 1 THEN
            LET l_msg = l_ima55 CLIPPED,'->',l_ima25 CLIPPED
            CALL cl_err(l_msg CLIPPED,'aqc-500',1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         CALL s_umfchk(l_ruc04,l_ruc16,l_ima55)
              RETURNING l_flag2,l_fac2
         IF l_flag2 = 1 THEN
            LET l_msg = l_ima55 CLIPPED,'->',l_ruc16 CLIPPED
            CALL cl_err(l_msg CLIPPED,'aqc-500',1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET g_tsc.tsc041 = l_fac
         LET g_tsc.tsc05 = l_fac2*(l_ruc18 - l_ruc21)
         LET g_tsc.tsc06 = l_ima55
         LET g_tsc.tsc07 = l_fac2
         LET g_tsc.tsc08 = l_fac2*(l_ruc18 - l_ruc21)
         LET g_tsc.tsc12 = l_rtz07
         LET g_tsc.tsc13 = ' '
         LET g_tsc.tsc14 = ' '
         LET g_tsc.tsc15 = g_grup
         LET g_tsc.tsc16 = g_user
         LET g_tsc.tscconf = 'N'
         LET g_tsc.tscpost = 'N'
         LET g_tsc.tscacti = 'Y'
         LET g_tsc.tscuser = g_user
         LET g_tsc.tscgrup = g_grup
         LET g_tsc.tscdate = g_today
         LET g_tsc.tscud13 = NULL
         LET g_tsc.tscud14 = NULL
         LET g_tsc.tscud15 = NULL
         LET g_tsc.tsccond = g_today
         LET g_tsc.tsccont = TIME
         LET g_tsc.tscconu = g_user
         LET g_tsc.tscplant = g_plant
         LET g_tsc.tsclegal = g_legal
         LET g_tsc.tscorig = g_grup
         LET g_tsc.tscoriu = g_user
         LET g_tsc.tsc21 = NULL
         IF l_i = 1 THEN 
            INSERT INTO tsc_file VALUES(g_tsc.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins_tsc:',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            LET l_ruc[l_i].ruc04 = l_ruc04
            LET l_ruc[l_i].tsc01 = g_tsc.tsc01
            LET l_ruc[l_i].tsc05 = g_tsc.tsc05
            LET l_i = l_i + 1
         ELSE
            IF l_ruc[l_i - 1].ruc04 <> l_ruc04 THEN
               INSERT INTO tsc_file VALUES(g_tsc.*)
               IF SQLCA.sqlcode THEN
                  CALL cl_err('ins_tsc:',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               LET l_ruc[l_i].ruc04 = l_ruc04
               LET l_ruc[l_i].tsc01 = g_tsc.tsc01
               LET l_ruc[l_i].tsc05 = g_tsc.tsc05
               LET l_i = l_i + 1
            ELSE
               UPDATE tsc_file SET tsc05 = tsc05 + l_fac2*(l_ruc18 - l_ruc21)
                WHERE tsc01 = l_ruc[l_i - 1].tsc01
               IF SQLCA.sqlcode THEN
                  CALL cl_err('upd_tsc:',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               SELECT tsc05 INTO l_ruc[l_i].tsc05 
                 FROM tsc_file
                WHERE tsc01 = l_ruc[l_i - 1].tsc01
            END IF
         END IF
         UPDATE p254_tmp SET ruc34 = g_tsc.tsc01
          WHERE ruc04 = l_ruc04
            AND sel = 'Y'
            AND ruc16 = l_ruc16
         IF SQLCA.sqlcode THEN
            CALL cl_err('upd_p254_tmp:',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         UPDATE ruc_file SET ruc34 = g_tsc.tsc01
          WHERE ruc04 = l_ruc04
            AND ruc16 = l_ruc16
            AND ruc02||ruc03 IN (SELECT ruc02||ruc03 FROM p254_tmp
                                  WHERE ruc04 = l_ruc04
                                    AND sel = 'Y'
                                    AND ruc16 = l_ruc16)
         IF SQLCA.sqlcode THEN
            CALL cl_err('upd_ruc:',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END FOREACH
      IF g_success = 'Y' THEN
         IF l_i <> 1 THEN LET i = l_i -1 END IF
         FOR l_i = 1 TO i
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM bmb_file WHERE bmb01 = l_ruc[l_i].ruc04
            IF l_n > 0 THEN
               SELECT MAX(tsd02)+1 INTO l_tsd02
                 FROM tsd_file
                WHERE tsd01 = l_ruc[l_i].tsc01
               IF cl_null(l_tsd02) THEN
                  LET l_tsd02 = 1
               END IF
               LET l_sql = "SELECT bmb03,bmb10,bmb06,bmb07 FROM bmb_file",
                           " WHERE bmb01 = '",l_ruc[l_i].ruc04,"'"
               DECLARE p254_sel_bmb_cs CURSOR FROM l_sql
               FOREACH p254_sel_bmb_cs INTO l_bmb03,l_bmb10,l_bmb06,l_bmb07
                  LET g_tsd.tsd01 = l_ruc[l_i].tsc01
                  LET g_tsd.tsd02 = l_tsd02
                  LET g_tsd.tsd03 = l_bmb03
                  LET g_tsd.tsd04 = l_bmb10
                  SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_ruc04
                  CALL s_umfchk(l_ruc04,l_bmb10,l_ima25)
                       RETURNING l_flag1,l_fac1
                  IF l_flag1 = 1 THEN
                     LET l_msg = l_ima25 CLIPPED,'->',l_bmb10 CLIPPED
                     CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
                  LET g_tsd.tsd041 = l_fac1
                  LET g_tsd.tsd05 = l_ruc[l_i].tsc05 * l_bmb06 / l_bmb07
                  LET g_tsd.tsd12 = l_rtz07
                  LET g_tsd.tsd13 = ' '
                  LET g_tsd.tsd14 = ' '
                  LET g_tsd.tsdud13 = NULL
                  LET g_tsd.tsdud14 = NULL
                  LET g_tsd.tsdud15 = NULL
                  LET g_tsd.tsdplant = g_plant
                  LET g_tsd.tsdlegal = g_legal
                  INSERT INTO tsd_file VALUES(g_tsd.*)
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('ins_tsd:',SQLCA.SQLCODE,1)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
                  LET l_tsd02 = l_tsd02 + 1
               END FOREACH
            END IF
         END FOR
      END IF
   END IF
   IF p_way = '2' THEN
      LET l_i = 1
      LET g_sql = "SELECT ruc02,ruc04,ruc16,SUM(ruc18),SUM(ruc21) FROM p254_tmp",
                  " WHERE sel = 'Y'",
                  "   AND ruc34 is null",
                  " GROUP BY ruc02,ruc04,ruc16",
                  " ORDER BY ruc02,ruc04,ruc16"
      DECLARE p254_sel_ruc1_cs CURSOR FROM g_sql
      FOREACH p254_sel_ruc1_cs INTO l_ruc02,l_ruc04,l_ruc16,l_ruc18,l_ruc21
         CALL s_auto_assign_no("atm",l_rye04,g_today,"U6","tsc_file","tsc",g_plant,"","")
              RETURNING li_result,g_tsc.tsc01
         IF (NOT li_result) THEN
            CALL cl_err('','sub-145',1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01 = l_ruc04
         SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_ruc04
         SELECT rtz07 INTO l_rtz07 FROM rtz_file WHERE rtz01 = g_plant
         LET g_tsc.tsc02 = g_today
         LET g_tsc.tsc03 = l_ruc04
         LET g_tsc.tsc04 = l_ima55
         CALL s_umfchk(l_ruc04,l_ima55,l_ima25)
              RETURNING l_flag,l_fac
         IF l_flag = 1 THEN
            LET l_msg = l_ima55 CLIPPED,'->',l_ima25 CLIPPED
            CALL cl_err(l_msg CLIPPED,'aqc-500',1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         CALL s_umfchk(l_ruc04,l_ruc16,l_ima55)
              RETURNING l_flag2,l_fac2
         IF l_flag2 = 1 THEN
            LET l_msg = l_ima55 CLIPPED,'->',l_ruc16 CLIPPED
            CALL cl_err(l_msg CLIPPED,'aqc-500',1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET g_tsc.tsc041 = l_fac
         LET g_tsc.tsc05 = l_fac2*(l_ruc18 - l_ruc21)
         LET g_tsc.tsc06 = l_ima55
         LET g_tsc.tsc07 = l_fac2
         LET g_tsc.tsc08 = l_fac2*(l_ruc18 - l_ruc21)
         LET g_tsc.tsc12 = l_rtz07
         LET g_tsc.tsc13 = ' '
         LET g_tsc.tsc14 = ' '
         LET g_tsc.tsc15 = g_grup
         LET g_tsc.tsc16 = g_user
         LET g_tsc.tscconf = 'N'
         LET g_tsc.tscpost = 'N'
         LET g_tsc.tscacti = 'Y'
         LET g_tsc.tscuser = g_user
         LET g_tsc.tscgrup = g_grup
         LET g_tsc.tscdate = g_today
         LET g_tsc.tscud13 = NULL
         LET g_tsc.tscud14 = NULL
         LET g_tsc.tscud15 = NULL
         LET g_tsc.tsccond = g_today
         LET g_tsc.tsccont = TIME
         LET g_tsc.tscconu = g_user
         LET g_tsc.tscplant = g_plant
         LET g_tsc.tsclegal = g_legal
         LET g_tsc.tscorig = g_grup
         LET g_tsc.tscoriu = g_user
         LET g_tsc.tsc21 = NULL
         IF l_i = 1 THEN 
            INSERT INTO tsc_file VALUES(g_tsc.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins_tsc:',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            LET l_ruc[l_i].ruc04 = l_ruc04
            LET l_ruc[l_i].ruc02 = l_ruc02
            LET l_ruc[l_i].tsc01 = g_tsc.tsc01
            LET l_ruc[l_i].tsc05 = g_tsc.tsc05
            LET l_i = l_i + 1
         ELSE
            IF l_ruc[l_i - 1].ruc04 = l_ruc04 AND l_ruc[l_i - 1].ruc02 = l_ruc02 THEN
               UPDATE tsc_file SET tsc05 = tsc05 + l_fac2*(l_ruc18 - l_ruc21)
                WHERE tsc01 = l_ruc[l_i - 1].tsc01
               IF SQLCA.sqlcode THEN
                  CALL cl_err('upd_tsc:',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               SELECT tsc05 INTO l_ruc[l_i].tsc05 
                 FROM tsc_file
                WHERE tsc01 = l_ruc[l_i - 1].tsc01
            ELSE
               INSERT INTO tsc_file VALUES(g_tsc.*)
               IF SQLCA.sqlcode THEN
                  CALL cl_err('ins_tsc:',SQLCA.SQLCODE,1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               LET l_ruc[l_i].ruc04 = l_ruc04
               LET l_ruc[l_i].ruc02 = l_ruc02
               LET l_ruc[l_i].tsc01 = g_tsc.tsc01
               LET l_ruc[l_i].tsc05 = g_tsc.tsc05
               LET l_i = l_i + 1
            END IF
         END IF
         UPDATE ruc_file SET ruc34 = g_tsc.tsc01
          WHERE ruc04 = l_ruc04
            AND ruc16 = l_ruc16
            AND ruc02 = l_ruc02
         IF SQLCA.sqlcode THEN
            CALL cl_err('upd_ruc:',SQLCA.SQLCODE,1)
            LET g_success = 'N' 
            EXIT FOREACH
         END IF
         UPDATE p254_tmp SET ruc34 = g_tsc.tsc01
          WHERE ruc04 = l_ruc04
            AND sel = 'Y'
            AND ruc16 = l_ruc16
            AND ruc02 = l_ruc02
         IF SQLCA.sqlcode THEN
            CALL cl_err('upd_p254_tmp:',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END FOREACH
      IF g_success = 'Y' THEN
         IF l_i <> 1 THEN LET i = l_i -1 END IF
         FOR l_i = 1 TO i
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM bmb_file WHERE bmb01 = l_ruc[l_i].ruc04
            IF l_n > 0 THEN
               SELECT MAX(tsd02) INTO l_tsd02
                 FROM tsd_file
                WHERE tsd01 = l_ruc[l_i].tsc01
               IF cl_null(l_tsd02) THEN
                  LET l_tsd02 = 1
               END IF
               LET l_sql = "SELECT bmb03,bmb10,bmb06,bmb07 FROM bmb_file",
                           " WHERE bmb01 = '",l_ruc[l_i].ruc04,"'"
               DECLARE p254_sel_bmb1_cs CURSOR FROM l_sql
               FOREACH p254_sel_bmb1_cs INTO l_bmb03,l_bmb10,l_bmb06,l_bmb07
                  LET g_tsd.tsd01 = l_ruc[l_i].tsc01
                  LET g_tsd.tsd02 = l_tsd02
                  LET g_tsd.tsd03 = l_bmb03
                  LET g_tsd.tsd04 = l_bmb10
                  SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_ruc04
                  CALL s_umfchk(l_ruc04,l_bmb10,l_ima25)
                       RETURNING l_flag1,l_fac1
                  IF l_flag1 = 1 THEN
                     LET l_msg = l_ima25 CLIPPED,'->',l_bmb10 CLIPPED
                     CALL cl_err(l_msg CLIPPED,'aqc-500',1)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
                  LET g_tsd.tsd041 = l_fac1
                  LET g_tsd.tsd05 = l_ruc[l_i].tsc05 * l_bmb06 / l_bmb07
                  LET g_tsd.tsd12 = l_rtz07
                  LET g_tsd.tsd13 = ' '
                  LET g_tsd.tsd14 = ' '
                  LET g_tsd.tsdud13 = NULL
                  LET g_tsd.tsdud14 = NULL
                  LET g_tsd.tsdud15 = NULL
                  LET g_tsd.tsdplant = g_plant
                  LET g_tsd.tsdlegal = g_legal
                  INSERT INTO tsd_file VALUES(g_tsd.*)
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('ins_tsd:',SQLCA.SQLCODE,1)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
                  LET l_tsd02 = l_tsd02 + 1
               END FOREACH
            END IF
         END FOR
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_err('','art1095',1)
   ELSE
      ROLLBACK WORK
      CALL cl_err('','art1096',1)
   END IF   
   CALL p254_b_fill()
END FUNCTION

FUNCTION p254_tt()
DEFINE l_sql        STRING
DEFINE l_rye04      LIKE rye_file.rye04
DEFINE g_ruo        RECORD LIKE ruo_file.*
DEFINE g_rup        RECORD LIKE rup_file.*
DEFINE l_rtz07_1    LIKE rtz_file.rtz07
DEFINE l_rtz07_2    LIKE rtz_file.rtz07
DEFINE l_ima25      LIKE ima_file.ima25
DEFINE l_ima55      LIKE ima_file.ima55
DEFINE l_ruc01      LIKE ruc_file.ruc01
DEFINE l_ruc02      LIKE ruc_file.ruc02
DEFINE l_ruc03      LIKE ruc_file.ruc03
DEFINE l_ruc04      LIKE ruc_file.ruc04
DEFINE l_ruc06      LIKE ruc_file.ruc06
DEFINE l_ruc16      LIKE ruc_file.ruc16
DEFINE l_ruc18      LIKE ruc_file.ruc18
DEFINE l_ruc21      LIKE ruc_file.ruc21
DEFINE l_rup02      LIKE rup_file.rup02
DEFINE l_rup05      LIKE rup_file.rup05
DEFINE l_ruo05      LIKE ruo_file.ruo05
DEFINE l_imd01      LIKE imd_file.imd01
DEFINE l_azw02_1    LIKE azw_file.azw02
DEFINE l_azw02_2    LIKE azw_file.azw02
DEFINE l_rcj12      LIKE rcj_file.rcj12
DEFINE l_flag       LIKE type_file.chr1
DEFINE l_fac        LIKE type_file.num20_6
DEFINE l_msg        LIKE type_file.chr1000
DEFINE li_result    LIKE type_file.num5
DEFINE l_sma142     LIKE sma_file.sma142
DEFINE l_sma143     LIKE sma_file.sma143
DEFINE l_rcj09      LIKE rcj_file.rcj09
DEFINE l_ruo05_1    LIKE ruo_file.ruo05
DEFINE l_ruo01      LIKE ruo_file.ruo01
DEFINE l_ruoplant   LIKE ruo_file.ruoplant

   SELECT rcj09 INTO l_rcj09 FROM rcj_file
   IF l_rcj09 = 'Y' THEN
      CALL p810_temp('1')
   END IF
   LET g_success = 'Y'
   BEGIN WORK
   LET g_sql = "SELECT ruc01,ruc06,ruc02 FROM p254_tmp",
               " WHERE sel = 'Y'",
               " GROUP BY ruc01,ruc06,ruc02"
   DECLARE p254_sel_ruc_tt_cs CURSOR FROM g_sql
   FOREACH p254_sel_ruc_tt_cs INTO l_ruc01,l_ruc06,l_ruc02
      CALL s_get_defslip("art","J1",g_plant,'N') RETURNING l_rye04
      IF cl_null(l_rye04) THEN
         CALL cl_err('','art-315',1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      CALL s_auto_assign_no("art",l_rye04,g_today,"J1","ruo_file","ruo",g_plant,"","")
           RETURNING li_result,g_ruo.ruo01
      IF (NOT li_result) THEN
         CALL cl_err('','sub-145',1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      SELECT rcj12 INTO l_rcj12 FROM rcj_file
      IF l_rcj12 = '1' THEN 
         LET l_ruo05  = l_ruc01 
      END IF 
      IF l_rcj12 = '2' THEN 
         LET l_ruo05  = l_ruc06
      END IF
      LET g_ruo.ruo02 = '8'
      LET g_ruo.ruo03 = l_ruc02
      LET g_ruo.ruo04 = g_plant
      LET g_ruo.ruo05 = l_ruo05
      LET g_ruo.ruo07 = g_today
      LET g_ruo.ruo08 = g_user
      LET g_ruo.ruoacti = 'Y'
      LET g_ruo.ruoconf = '0'
      LET g_ruo.ruocrat = g_today
      LET g_ruo.ruodate = g_today
      LET g_ruo.ruogrup = g_grup
      LET g_ruo.ruolegal = g_legal
      LET g_ruo.ruoplant = g_plant
      LET g_ruo.ruouser = g_user
      LET g_ruo.ruopos = ' '
      LET g_ruo.ruooriu = g_user
      LET g_ruo.ruoorig = g_grup
      LET g_ruo.ruo15 = 'N'
      LET g_ruo.ruo10 = NULL
      LET g_ruo.ruo12 = NULL
      SELECT sma143 INTO l_sma143 FROM sma_file 
     #IF l_sma143 = '1' THEN
     #   SELECT imd01 INTO l_imd01 
     #     FROM imd_file 
     #    WHERE imd10 = 'W'
     #      AND imd22 = 'Y'
     #      AND imd20 = g_ruo.ruo04
     #ELSE
     #   SELECT imd01 INTO l_imd01 
     #     FROM imd_file 
     #    WHERE imd10 = 'W'
     #      AND imd22 = 'Y'
     #      AND imd20 = g_ruo.ruo05
     #END IF
     #LET g_ruo.ruo14 = l_imd01
      LET g_ruo.ruo14 = NULL
      SELECT azw02 INTO l_azw02_1 FROM azw_file WHERE azw01 = g_ruo.ruo04
      SELECT azw02 INTO l_azw02_2 FROM azw_file WHERE azw01 = g_ruo.ruo05
      IF l_azw02_1 <> l_azw02_2 THEN
         LET g_ruo.ruo901 = 'Y'
      ELSE
         LET g_ruo.ruo901 = 'N'
      END IF
      INSERT INTO ruo_file VALUES(g_ruo.*) 
      IF SQLCA.sqlcode THEN
         CALL cl_err('ins_ruo:',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         EXIT FOREACH
      ELSE
         SELECT MAX(rup02)+1 INTO l_rup02
           FROM rup_file
          WHERE rup01 = g_ruo.ruo01
         IF cl_null(l_rup02) THEN
            LET l_rup02 = 1
         END IF
         LET l_sql = "SELECT ruc03,ruc04,ruc16,ruc18,ruc21 FROM p254_tmp",
                     " WHERE sel = 'Y'",
                     "   AND ruc01 = '",l_ruc01,"'",
                     "   AND ruc06 = '",l_ruc06,"'",
                     "   AND ruc02 = '",l_ruc02,"'"
         DECLARE p254_sel_ruc_2_cs CURSOR FROM l_sql
         FOREACH p254_sel_ruc_2_cs INTO l_ruc03,l_ruc04,l_ruc16,l_ruc18,l_ruc21
            SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = l_ruc04
            SELECT rty06 INTO l_rup05 FROM rty_file WHERE rty01= g_ruo.ruo04 AND rty02 = l_ruc04
            IF cl_null(l_rup05) THEN
               LET l_rup05 = '1'
            END IF
            SELECT rtz07 INTO l_rtz07_1 FROM rtz_file WHERE rtz01 = g_plant
            SELECT rtz07 INTO l_rtz07_2 FROM rtz_file WHERE rtz01 = g_ruo.ruo05
            LET g_rup.rup01 = g_ruo.ruo01
            LET g_rup.rup02 = l_rup02
            LET g_rup.rup03 = l_ruc04
            LET g_rup.rup04 = l_ima25
            LET g_rup.rup05 = l_rup05
            LET g_rup.rup06 = NULL
            LET g_rup.rup07 = l_ruc16
            CALL s_umfchk(g_rup.rup03,g_rup.rup07,g_rup.rup04)
                 RETURNING l_flag,l_fac
            IF l_flag = 1 THEN
               LET l_msg = g_rup.rup07 CLIPPED,'->',g_rup.rup04 CLIPPED
               CALL cl_err(l_msg CLIPPED,'aqc-500',1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            LET g_rup.rup08 = l_fac
            LET g_rup.rup09 = l_rtz07_1
            LET g_rup.rup10 = ' '
            LET g_rup.rup11 = ' '
            LET g_rup.rup12 = l_ruc18 - l_ruc21
            LET g_rup.rup13 = l_rtz07_2
            LET g_rup.rup14 = ' '
            LET g_rup.rup15 = ' '
            LET g_rup.rup16 = l_ruc18 - l_ruc21
            LET g_rup.ruplegal = g_legal
            LET g_rup.rupplant = g_plant
            LET g_rup.rup17 = l_ruc03
            LET g_rup.rup18 = 'N'
            LET g_rup.rup19 = l_ruc18 - l_ruc21
            LET g_rup.rup22 = l_ruc06
            INSERT INTO rup_file VALUES(g_rup.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins_rup:',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            UPDATE ruc_file SET ruc21 = ruc18,
                                ruc22 = '6'
             WHERE ruc01 = l_ruc01
               AND ruc06 = l_ruc06
               AND ruc02 = l_ruc02
               AND ruc03 = l_ruc03
            IF SQLCA.sqlcode THEN
               CALL cl_err('upd_ruc:',SQLCA.SQLCODE,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            LET l_rup02 = l_rup02 + 1
         END FOREACH
      END IF
     #UPDATE ruc_file SET ruc21 = ruc18,
     #                    ruc22 = '6' 
     # WHERE ruc01 = l_ruc01
     #   AND ruc06 = l_ruc06
     #   AND ruc02 = l_ruc02
     #IF SQLCA.sqlcode THEN
     #   CALL cl_err('upd_ruc:',SQLCA.SQLCODE,1)
     #   LET g_success = 'N'
     #   EXIT FOREACH
     #END IF
      UPDATE p254_tmp SET ruc21 = ruc18,
                           ruc22 = '6'
       WHERE ruc01 = l_ruc01
         AND sel = 'Y'
         AND ruc06 = l_ruc06
         AND ruc02 = l_ruc02
      IF SQLCA.sqlcode THEN
         CALL cl_err('upd_p254_tmp:',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
   IF g_success = 'Y' THEN
      IF l_rcj09 = 'Y' THEN
         DECLARE ruo_temp_cs CURSOR FOR
        # SELECT ruo01,ruoplant,ruo05 FROM p254_temp
          SELECT DISTINCT ruo_file.* FROM ruo_file,p254_tmp
           WHERE ruo02 = '8'
             AND ruo03 = ruc02
             AND sel = 'Y'
             AND ruoplant = g_plant
         FOREACH ruo_temp_cs INTO g_ruo.*
            CALL t256_sub(g_ruo.*,'1','N')
           #CALL p810_out_yes(l_ruo01,l_ruoplant,'N')
           #LET l_sql =  "SELECT ruo01,ruoplant FROM ",cl_get_target_table(l_ruo05_1,'ruo_file'),
           #             " WHERE ruo011 = ? AND ruoplant = ? "
           #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           #CALL cl_parse_qry_sql(l_sql, l_ruo05_1) RETURNING l_sql
           #PREPARE ruo_sel FROM l_sql
           #EXECUTE ruo_sel USING l_ruo01,l_ruo05_1 INTO l_ruo01,l_ruoplant
           #SELECT sma142 INTO l_sma142 FROM sma_file
           #IF l_sma142 = 'Y' THEN
           #   CALL p810_in_yes(l_ruo01,l_ruoplant,'N')
           #END IF
         END FOREACH
      END IF      
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_err('','art1097',1)
   ELSE
      ROLLBACK WORK
      CALL cl_err('','art1098',1)
   END IF
   IF l_rcj09 = 'Y' THEN
      CALL p810_temp('2')
   END IF
   CALL p254_b_fill()   
END FUNCTION
#FUN-CC0057
