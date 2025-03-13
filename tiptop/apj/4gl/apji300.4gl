# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: apji300.4gl
# Descriptions...: apji300砐項目分類維護作業
# Date & Author..: No.FUN-790025 07/10/18 By lala
# Modify.........: No.FUN-790025 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pjq           DYNAMIC ARRAY OF RECORD
        pjq01       LIKE pjq_file.pjq01,
        pjq02       LIKE pjq_file.pjq02,
        pjqacti     LIKE pjq_file.pjqacti
                    END RECORD,
    g_pjq_t         RECORD
        pjq01       LIKE pjq_file.pjq01,
        pjq02       LIKE pjq_file.pjq02,
        pjqacti     LIKE pjq_file.pjqacti
                    END RECORD,
    g_wc2,g_sql    STRING,
    g_rec_b         LIKE type_file.num5,
    l_ac            LIKE type_file.num5
 
DEFINE g_forupd_sql         STRING
DEFINE g_cnt                LIKE type_file.num10
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE g_i                  LIKE type_file.num5
 
MAIN
DEFINE  p_row,p_col	 LIKE type_file.num5
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)
         RETURNING g_time
#    IF g_aza.aza08 <> 'Y' THEN
#       EXIT PROGRAM
#    END IF
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i300_w AT p_row,p_col WITH FORM "apj/42f/apji300"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i300_b_fill(g_wc2)
    CALL i300_menu()
    CLOSE WINDOW i300_w
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time
END MAIN
 
FUNCTION i300_menu()
 
   WHILE TRUE
      CALL i300_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i300_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #CALL i300_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET g_msg = 'p_query "apji300" "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjq),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i300_q()
   CALL i300_b_askkey()
END FUNCTION
 
FUNCTION i300_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pjq01,pjq02,pjqacti FROM pjq_file WHERE pjq01=?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i300_bcl CURSOR FROM g_forupd_sql
 
    INPUT ARRAY g_pjq WITHOUT DEFAULTS FROM s_pjq.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
          UNBUFFERED, INSERT ROW = l_allow_insert,
          DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET  g_before_input_done = FALSE
               CALL i300_set_entry(p_cmd)
               CALL i300_set_no_entry(p_cmd)
               LET  g_before_input_done = TRUE
 
               BEGIN WORK
               LET g_pjq_t.* = g_pjq[l_ac].*
               OPEN i300_bcl USING g_pjq_t.pjq01
               IF STATUS THEN
                  CALL cl_err("OPEN i300_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i300_bcl INTO g_pjq[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_pjq_t.pjq01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_pjq[l_ac].* TO NULL
            LET g_pjq[l_ac].pjqacti = 'Y'
            LET g_pjq_t.* = g_pjq[l_ac].*
            LET  g_before_input_done = FALSE
            CALL i300_set_entry(p_cmd)
            CALL i300_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            CALL cl_show_fld_cont()
            NEXT FIELD pjq01
 
      AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO pjq_file(pjq01,pjq02,pjqacti,pjquser,pjqgrup,pjqdate,pjqoriu,pjqorig)
                          VALUES(g_pjq[l_ac].pjq01,g_pjq[l_ac].pjq02,
                                 g_pjq[l_ac].pjqacti, g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","pjq_file",g_pjq[l_ac].pjq01,"",SQLCA.sqlcode,"","",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER FIELD pjq01
            IF NOT cl_null(g_pjq[l_ac].pjq01) THEN
               IF g_pjq[l_ac].pjq01 != g_pjq_t.pjq01 OR
                  (g_pjq[l_ac].pjq01 IS NOT NULL AND g_pjq_t.pjq01 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM pjq_file
                    WHERE pjq01 = g_pjq[l_ac].pjq01
                  IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_pjq[l_ac].pjq01 = g_pjq_t.pjq01
                    NEXT FIELD pjq01
                  END IF
               END IF
            END IF
 
        AFTER FIELD pjqacti
            IF cl_null(g_pjq[l_ac].pjqacti) THEN
               LET g_pjq[l_ac].pjqacti = 'N'
            END IF
 
        BEFORE DELETE
            IF g_pjq_t.pjq01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
               END IF
               DELETE FROM pjq_file WHERE pjq01 = g_pjq_t.pjq01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","pjq_file",g_pjq_t.pjq01,"",SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete OK"
               CLOSE i300_bcl
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pjq[l_ac].* = g_pjq_t.*
              CLOSE i300_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pjq[l_ac].pjq01,-263,1)
              LET g_pjq[l_ac].* = g_pjq_t.*
           ELSE
              UPDATE pjq_file SET pjq01=g_pjq[l_ac].pjq01,
                                  pjq02=g_pjq[l_ac].pjq02,
                                  pjqacti=g_pjq[l_ac].pjqacti,
                                  pjqmodu=g_user,
                                  pjqdate=g_today
                              WHERE pjq01=g_pjq_t.pjq01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pjq_file",g_pjq_t.pjq01,"",SQLCA.sqlcode,"","",1)
                 LET g_pjq[l_ac].* = g_pjq_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i300_bcl
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                   LET g_pjq[l_ac].* = g_pjq_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_pjq.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i300_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i300_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO
            IF INFIELD(pjq01) AND l_ac > 1 THEN
               LET g_pjq[l_ac].* = g_pjq[l_ac-1].*
               LET g_pjq[l_ac].pjq01 = NULL
               NEXT FIELD pjq01
            END IF
 
        ON ACTION CONTROLR
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
    CLOSE i300_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i300_b_askkey()
    CLEAR FORM
    CALL g_pjq.clear()
    CONSTRUCT g_wc2 ON pjq01,pjq02,pjqacti
            FROM s_pjq[1].pjq01,s_pjq[1].pjq02,s_pjq[1].pjqacti
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('pjquser', 'pjqgrup') #FUN-980030
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF
 
    CALL i300_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i300_b_fill(p_wc2)
#    DEFINE p_wc2     LIKE type_file.chr1000
    DEFINE p_wc2  STRING     #NO.FUN-910082
    LET g_sql = "SELECT pjq01,pjq02,pjqacti",
                " FROM pjq_file",
                " WHERE ", p_wc2 CLIPPED,
                " ORDER BY pjq01 "
    PREPARE i300_pb FROM g_sql
    DECLARE pjq_curs CURSOR FOR i300_pb
 
    CALL g_pjq.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pjq_curs INTO g_pjq[g_cnt].*  
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
    CALL g_pjq.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
 
END FUNCTION
 
FUNCTION i300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjq TO s_pjq.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
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
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
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
 
#FUNCTION i300_out()
#    DEFINE
#        l_pjq           RECORD LIKE pjq_file.*,
#        l_i             LIKE type_file.num5, 
#        l_name          LIKE type_file.chr20,
#        l_za05          LIKE type_file.chr1000
#
#    IF g_wc2 IS NULL THEN
#       CALL cl_err('','9057',0)
#    RETURN END IF
#    CALL cl_wait()
#    LET l_name = 'apji300.out'
#    CALL cl_outnam('apji300') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM pjq_file ",
#              " WHERE ",g_wc2 CLIPPED
#    PREPARE i300_p1 FROM g_sql
#    DECLARE i300_co
#        CURSOR FOR i300_p1
#
#    START REPORT i300_rep TO l_name
#
#    FOREACH i300_co INTO l_pjq.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i300_rep(l_pjq.*)
#    END FOREACH
#
#    FINISH REPORT i300_rep
#
#    CLOSE i300_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i300_rep(sr)
#    DEFINE
#        l_str           LIKE aba_file.aba18,
#        l_trailer_sw    LIKE type_file.chr1,
#        sr RECORD LIKE pjq_file.*
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.pjq01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           #PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   
#            PRINT
#            PRINT g_dash
#            PRINT g_x[31],g_x[32],g_x[33]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#            IF sr.pjqacti = 'N'
#                THEN LET l_str='* ';
#                ELSE LET l_str='  ';
#            END IF
#            PRINT COLUMN g_c[31],l_str,sr.pjq01,
#                  COLUMN g_c[32],sr.pjq02,
#                  COLUMN g_c[33],sr.pjqacti
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[7] CLIPPED
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[6] CLIPPED
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
 
FUNCTION i300_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("pjq01",TRUE)
  END IF
END FUNCTION
 
FUNCTION i300_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("pjq01",FALSE)
  END IF
END FUNCTION
# Modify.........: No.FUN-790025 
