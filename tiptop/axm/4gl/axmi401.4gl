# Prog. Version..: '5.30.06-13.04.22(00003)'     #
# Pattern name...: axmi401.4gl
# Descriptions...: 订货会基本资料维护作业 
# Date & Author..: No:FUN-A50011 10/04/05 By yangfeng
# Modify.........: No.FUN-B90105 11/10/08 By linlin 維護訂單會基本信息
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds


GLOBALS "../../config/top.global"
DEFINE  g_odl         DYNAMIC ARRAY OF RECORD
            odl01     LIKE odl_file.odl01,
            odl02     LIKE odl_file.odl02,
            odl03     LIKE odl_file.odl03,
            odl04     LIKE odl_file.odl04,
            odl05     LIKE odl_file.odl05,
            odlacti   LIKE odl_file.odlacti
                      END RECORD,
        g_odl_t       RECORD
            odl01     LIKE odl_file.odl01,
            odl02     LIKE odl_file.odl02,
            odl03     LIKE odl_file.odl03,
            odl04     LIKE odl_file.odl04,
            odl05     LIKE odl_file.odl05,
            odlacti   LIKE odl_file.odlacti
                      END RECORD,
        g_wc2,g_sql   STRING,
        g_rec_b       LIKE type_file.num5,
        l_ac          LIKE type_file.num5
DEFINE g_forupd_sql   STRING
DEFINE g_cnt          LIKE type_file.num10,
       g_i            LIKE type_file.num5
DEFINE g_before_input_done    LIKE type_file.num5
DEFINE g_str          STRING
MAIN
   DEFINE p_col,p_row LIKE type_file.num5
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   IF(NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF(NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET p_row = 5
   LET p_col = 10
   OPEN WINDOW i401_w AT p_row,p_col WITH FORM "axm/42f/axmi401" ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   LET g_wc2 = " 1=1"
   CALL i401_b_fill(g_wc2)
   CALL i401_menu()
   CLOSE WINDOW i401_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i401_menu()
   WHILE TRUE
      CALL i401_bp("G")
      CASE g_action_choice
         WHEN "query"
	    IF cl_chk_act_auth() THEN
	       CALL i401_q()
	    END IF
	 WHEN "detail"
	    IF cl_chk_act_auth() THEN
	       CALL i401_b()
	    ELSE
	       LET g_action_choice = NULL
	    END IF
	 WHEN "exit"
	    EXIT WHILE
{	 WHEN "output"
	    IF cl_chk_act_auth() THEN
	       CALL i401_out()
	    END IF
}
	 WHEN "related_document"
	    IF cl_chk_act_auth() THEN
	       IF g_odl[1].odl01 IS NOT NULL THEN
	          LET g_doc.column1 = "odl01"
		  LET g_doc.value1 = g_odl[1].odl01
                  CALL cl_doc()
	       END IF
	    END IF
	 WHEN "exporttoexcel"
	    IF cl_chk_act_auth() THEN
	       CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_odl),'','')
	    END IF
	 WHEN "help"
	    CALL cl_show_help()
	 WHEN "controlg"
	    CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i401_bp(p_ud)
   DEFINE p_ud LIKE type_file.chr1 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_odl TO s_odl.* ATTRIBUTE (COUNT = g_rec_b)
      BEFORE ROW 
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice = "query"
	 EXIT DISPLAY
      ON ACTION detail 
         LET g_action_choice = "detail"
	 LET l_ac = 1
	 EXIT DISPLAY
{      ON ACTION output
         LET g_action_choice = "output"
	 EXIT DISPLAY
}
      ON ACTION help
         LET g_action_choice = "help"
	 EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
	 CALL cl_show_fld_cont()
      ON ACTION exit
         LET g_action_choice = "exit"
	 EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice = "controlg"
	 EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice = "detail"
	 LET l_ac = ARR_CURR()
	 EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = FALSE
	 LET g_action_choice = "exit"
	 EXIT DISPLAY
      ON ACTION about
         CALL cl_about()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
	 CONTINUE DISPLAY
      ON ACTION related_document
         LET g_action_choice = "related_document"
	 EXIT DISPLAY
      ON ACTION exporttoexcel
         LET g_action_choice = "exporttoexcel"
	 EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION 

FUNCTION i401_b_fill(p_wc2)
   DEFINE p_wc2   LIKE type_file.chr1000
   LET g_sql = "SELECT odl01,odl02,odl03,odl04,odl05,odlacti FROM odl_file ",
               " WHERE ",p_wc2 CLIPPED
   DECLARE odl_cs CURSOR FROM g_sql
   CALL g_odl.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"
   FOREACH odl_cs INTO g_odl[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
	 EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_odl.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt
   LET g_cnt = 0
   
END FUNCTION

FUNCTION i401_q()
   CALL i401_b_askkey()
END FUNCTION

FUNCTION i401_b()
   DEFINE l_ac_t     LIKE type_file.num5,
          l_n        LIKE type_file.num5,
	  l_lock_sw  LIKE type_file.chr1,
	  p_cmd      LIKE type_file.chr1,
	  l_allow_insert   LIKE type_file.chr1,
	  l_allow_delete   LIKE type_file.chr1
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN 
   END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   LET g_forupd_sql = "SELECT odl01,odl02,odl03,odl04,odl05,odlacti FROM odl_file",
                      " WHERE odl01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i401_bcl  CURSOR FROM g_forupd_sql
 
   INPUT ARRAY g_odl WITHOUT DEFAULTS FROM s_odl.*
   ATTRIBUTE (COUNT = g_rec_b,MAXCOUNT = g_max_rec,UNBUFFERED,
              INSERT ROW = l_allow_insert,DELETE ROW = l_allow_delete,
	      APPEND ROW = l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
      BEFORE ROW 
        LET p_cmd = ''
	LET l_ac = ARR_CURR()
	LET l_lock_sw = 'N'
	LET l_n = ARR_COUNT()
	IF g_rec_b >= l_ac THEN
	   BEGIN WORK 
	   LET p_cmd = 'u'
	   LET g_before_input_done = FALSE
	   CALL i401_set_entry(p_cmd)
	   CALL i401_set_no_entry(p_cmd)
	   LET g_before_input_done = TRUE
	   LET g_odl_t.* = g_odl[l_ac].*
	   OPEN i401_bcl USING g_odl_t.odl01
	   IF STATUS THEN
	      CALL cl_err("open i401_bcl:",STATUS,1)
	      LET l_lock_sw = 'Y'
	   END IF
	   FETCH  i401_bcl INTO g_odl[l_ac].*
	   IF SQLCA.sqlcode THEN
	      CALL cl_err(g_odl_t.odl01,SQLCA.sqlcode,1)
	      LET l_lock_sw = 'Y'
	   END IF
	   CALL cl_show_fld_cont()
       	END IF
      BEFORE INSERT
         LET l_n = ARR_CURR()
	 LET p_cmd = 'a'
	 LET g_before_input_done = FALSE
	 CALL i401_set_entry(p_cmd)
	 CALL i401_set_no_entry(p_cmd)
	 LET g_before_input_done = TRUE
	 INITIALIZE g_odl[l_ac].* TO NULL
	 LET g_odl[l_ac].odlacti = 'Y'   # give odlacti a default value which is Y
	 LET g_odl_t.* = g_odl[l_ac].*
	 CALL cl_show_fld_cont()
	 NEXT FIELD odl01
      AFTER INSERT
         IF INT_FLAG THEN
	    CALL cl_err('',9001,0)
	    LET INT_FLAG = 0
	    CLOSE i401_bcl
	    CANCEL INSERT
	 END IF
         INSERT INTO odl_file(odl01,odl02,odl03,odl04,odl05,odlacti,odluser,odlgrup,odlmodu,odlorig,odloriu,odldate)  #FUN-B90105 ADD odlmodu
         VALUES(g_odl[l_ac].odl01,g_odl[l_ac].odl02,g_odl[l_ac].odl03,g_odl[l_ac].odl04,g_odl[l_ac].odl05,g_odl[l_ac].odlacti,g_user,g_grup,g_user,g_grup,g_user,g_today)  #FUN-B90105 ADD g_user    
         IF SQLCA.sqlcode THEN
	    CALL cl_err3("ins","odl_file",g_odl[l_ac].odl01,"",SQLCA.sqlcode,"","",1)
	    CANCEL INSERT
	 ELSE 
	    MESSAGE 'INSERT O.K'
	    LET g_rec_b = g_rec_b + 1
	    DISPLAY g_rec_b TO FORMONLY.cnt
	 END IF
	 
      AFTER FIELD odl01
         IF NOT cl_null(g_odl[l_ac].odl01) THEN
	    IF p_cmd = 'a' OR (p_cmd = 'u' AND g_odl[l_ac].odl01 != g_odl_t.odl01) THEN
	       SELECT count(*) INTO l_n FROM odl_file WHERE odl01 = g_odl[l_ac].odl01
	       IF l_n > 0 THEN
	          CALL cl_err('',-239,0)
		  LET g_odl[l_ac].odl01 = g_odl_t.odl01
		  NEXT FIELD odl01
	       END IF
	    END IF
	 END IF
      AFTER FIELD odl03
         IF  cl_null(g_odl[l_ac].odl03) THEN
             CALL cl_err('',-1124,0)
            ELSE
              IF (NOT cl_null(g_odl[l_ac].odl04)) AND ( g_odl[l_ac].odl03 > g_odl[l_ac].odl04) THEN  # FUN-B90105  add
               CALL cl_err('','aap1002',1)
            NEXT FIELD odl03
         END IF
      END IF
      AFTER FIELD odl04
         IF  cl_null(g_odl[l_ac].odl04) THEN
             CALL cl_err('',-1124,0)
             ELSE
            IF (NOT cl_null(g_odl[l_ac].odl03)) AND ( g_odl[l_ac].odl04 < g_odl[l_ac].odl03) THEN
               CALL cl_err('','aap-100',1)
               NEXT FIELD odl04
            END IF
         END IF
      AFTER FIELD odlacti
         IF NOT cl_null(g_odl[l_ac].odlacti) THEN
            IF g_odl[l_ac].odlacti NOT MATCHES '[YN]' THEN 
               LET g_odl[l_ac].odlacti = g_odl_t.odlacti
               NEXT FIELD odlacti
            END IF
         END IF
      BEFORE DELETE
         IF g_odl_t.odl01 IS NOT NULL THEN
	    IF NOT cl_delete() THEN
	       CANCEL DELETE
	    END IF
	    IF l_lock_sw = 'Y' THEN
	       CALL cl_err("",-263,1)
	       CANCEL DELETE
	    END IF
	    DELETE FROM odl_file WHERE odl01 = g_odl_t.odl01
	    IF SQLCA.sqlcode THEN
	       CALL cl_err3("del","odl_file",g_odl_t.odl01,"",SQLCA.sqlcode,"","",1)
	       EXIT INPUT
	    END IF
	    LET g_rec_b = g_rec_b - 1
	    DISPLAY g_rec_b TO FORMONLY.cnt
	    COMMIT WORK
	 END IF
      ON ROW CHANGE
         IF INT_FLAG THEN
	    CALL cl_err('',9001,0)
	    LET INT_FLAG = 0
	    LET g_odl[l_ac].* = g_odl_t.*
	    CLOSE i401_bcl
	    ROLLBACK WORK
	    EXIT INPUT
	 END IF
	 IF l_lock_sw = 'Y' THEN
	    CALL cl_err(g_odl[l_ac].odl01,-263,0)
	    LET g_odl[l_ac].* = g_odl_t.*
	 ELSE 
	    UPDATE odl_file SET odl01 = g_odl[l_ac].odl01,
	                        odl02 = g_odl[l_ac].odl02,
				odl03 = g_odl[l_ac].odl03,
				odl04 = g_odl[l_ac].odl04,
				odl05 = g_odl[l_ac].odl05,
				odlacti = g_odl[l_ac].odlacti,
				odlmodu = g_user
	    WHERE odl01 = g_odl_t.odl01
	    IF SQLCA.sqlcode THEN
	       CALL cl_err3("upd","odl_file",g_odl_t.odl01,"",SQLCA.sqlcode,"","",1)
	       LET g_odl[l_ac].* = g_odl_t.*
	    ELSE
	       MESSAGE 'UPDATE O.K'
	       COMMIT WORK
	    END IF
         END IF
	                        
      AFTER ROW
         LET l_ac = ARR_CURR()
	#LET l_ac_t = l_ac  #FUN-D30034 mark
	 IF INT_FLAG THEN
	    CALL cl_err('',9001,0)
	    LET INT_FLAG = 0
	    IF p_cmd = 'u' THEN
	       LET g_odl[l_ac].* = g_odl_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_odl.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
	    END IF
	    CLOSE i401_bcl
	    ROLLBACK WORK
	    EXIT INPUT
	 END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
	 CLOSE i401_bcl
	 COMMIT WORK

      ON ACTION controlz
         CALL cl_show_req_fields()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION about
         CALL cl_about()
      ON ACTION help
         CALL cl_show_help()
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
   END INPUT
   CLOSE i401_bcl
   COMMIT WORK
END FUNCTION

FUNCTION i401_b_askkey()
   CLEAR FORM
   CALL g_odl.clear()

   CONSTRUCT g_wc2 ON odl01,odl02,odl03,odl04,odl05,odlacti
       FROM  s_odl[1].odl01, s_odl[1].odl02,s_odl[1].odl03,s_odl[1].odl04,s_odl[1].odl05,s_odl[1].odlacti

       BEFORE CONSTRUCT 
          CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
	  CONTINUE CONSTRUCT
       ON ACTION help
          CALL cl_show_help()
       ON ACTION about
          CALL cl_about()
       ON ACTION controlg
          CALL cl_cmdask()
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
   CALL i401_b_fill(g_wc2)
END FUNCTION
{
FUNCTION i401_out()
   IF g_wc2 IS NULL THEN
      CALL cl_err('',9057,0)
      RETURN
   END IF
   LET g_str = ''
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_sql = "SELECT * FROM odl_file WHERE ",g_wc2 CLIPPED
   ERROR ""
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc2,'odl01,odl02,odl03,odl04,odl05,odlacti') RETURNING g_wc2
   END IF
   LET g_str = g_wc2
   CALL cl_prt_cs1("axmi401","axmi401",g_sql,g_str)
END FUNCTION
}
FUNCTION i401_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1

   IF (p_cmd = 'a' AND ( NOT g_before_input_done)) THEN
      CALL cl_set_comp_entry("odl01",TRUE)
   END IF
END FUNCTION

FUNCTION i401_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   
   IF p_cmd = 'u' AND (NOT g_before_input_done) AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("odl01",FALSE)
   END IF
END FUNCTION 
#FUN-A50011
