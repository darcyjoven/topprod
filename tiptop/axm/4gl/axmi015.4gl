# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: axmi015.4gl
# Descriptions...: 售貨動作基本資料維護 
# Date & Author..: 2010/08/06 #FUN-9A0036 By vealxu
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    g_ocr DYNAMIC ARRAY OF RECORD   
        ocr01       LIKE ocr_file.ocr01,
        ocr02       LIKE ocr_file.ocr02
                    END RECORD,
    g_buf           LIKE ima_file.ima01,         
    g_ocr_t         RECORD                       
        ocr01       LIKE ocr_file.ocr01,
        ocr02       LIKE ocr_file.ocr02
                    END RECORD,
    g_wc2,g_sql     string,  
    g_rec_b         LIKE type_file.num5,          
    l_ac            LIKE type_file.num5                
DEFINE p_row,p_col     LIKE type_file.num5      

DEFINE g_forupd_sql          STRING               #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt                 LIKE type_file.num10 
DEFINE g_i                   LIKE type_file.num5  #count/index for any purpose      

MAIN
   OPTIONS                                     
      INPUT NO WRAP                      
   DEFER INTERRUPT                      

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1)      
        RETURNING g_time               

   LET p_row = 2 LET p_col = 3

   OPEN WINDOW i015_w AT p_row,p_col WITH FORM "axm/42f/axmi015"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()

   LET g_wc2 = '1=1'
   CALL i015_b_fill(g_wc2)

   CALL i015_menu()

   CLOSE WINDOW i015_w               
   CALL cl_used(g_prog,g_time,2)      
       RETURNING g_time              

END MAIN

FUNCTION i015_menu()
DEFINE l_cmd  LIKE type_file.chr1000
   WHILE TRUE
      CALL i015_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i015_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i015_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ocr),'','')
            END IF
      END CASE
   END WHILE

END FUNCTION

FUNCTION i015_q()

   CALL i015_b_askkey()

END FUNCTION

FUNCTION i015_b()
   DEFINE l_ac_t          LIKE type_file.num5,                
          l_n             LIKE type_file.num5,                
          l_lock_sw       LIKE type_file.chr1,              
          p_cmd           LIKE type_file.chr1,             
          l_allow_insert  LIKE type_file.num5,             
          l_allow_delete  LIKE type_file.num5               
   DEFINE l_i             LIKE type_file.num5

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')

   LET g_forupd_sql = "  SELECT ocr01,ocr02 FROM ocr_file",
                      "  WHERE ocr01=? FOR UPDATE"
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) 
   DECLARE i015_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_ocr WITHOUT DEFAULTS FROM s_ocr.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
            
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_doctype_format("ocr01")

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success = 'Y'

         IF g_rec_b >= l_ac THEN
            LET g_ocr_t.* = g_ocr[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
            OPEN i015_bcl USING g_ocr_t.ocr01
            IF STATUS THEN
               CALL cl_err("OPEN i015_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i015_bcl INTO g_ocr[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ocr_t.ocr01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_before_input_done = FALSE                                   
            CALL i015_set_entry(p_cmd)                                        
            CALL i015_set_no_entry(p_cmd)                                     
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ocr[l_ac].* TO NULL
         LET g_ocr_t.* = g_ocr[l_ac].*         
         LET g_before_input_done = FALSE                                   
         CALL i015_set_entry(p_cmd)                                        
         CALL i015_set_no_entry(p_cmd)                                     
         LET g_before_input_done = TRUE

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO ocr_file(ocr01,ocr02)
              VALUES(g_ocr[l_ac].ocr01,g_ocr[l_ac].ocr02)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ocr_file",g_ocr[l_ac].ocr01,"",SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      AFTER FIELD ocr01 
         IF g_ocr[l_ac].ocr01 IS NOT NULL THEN
            IF g_ocr[l_ac].ocr01 != g_ocr_t.ocr01 OR
               (NOT cl_null(g_ocr[l_ac].ocr01) AND cl_null(g_ocr_t.ocr01)) THEN
               SELECT count(*) INTO l_n FROM ocr_file
                WHERE ocr01 = g_ocr[l_ac].ocr01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_ocr[l_ac].ocr01 = g_ocr_t.ocr01
                  NEXT FIELD ocr01
               END IF
            END IF
         END IF

      BEFORE DELETE                          
         IF g_ocr_t.ocr01 IS NOT NULL THEN
 
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
          
            DELETE FROM ocr_file WHERE ocr01 = g_ocr_t.ocr01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ocr_file",g_ocr_t.ocr01,"",SQLCA.sqlcode,"","",1) 
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i015_bcl
            COMMIT WORK 
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ocr[l_ac].* = g_ocr_t.*
            CLOSE i015_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ocr[l_ac].ocr01,-263,1)
            LET g_ocr[l_ac].* = g_ocr_t.*
         ELSE
            UPDATE ocr_file SET
                   ocr01=g_ocr[l_ac].ocr01,ocr02=g_ocr[l_ac].ocr02
             WHERE ocr01 = g_ocr_t.ocr01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ocr_file",g_ocr_t.ocr01,"",SQLCA.sqlcode,"","",1) 
               LET g_ocr[l_ac].* = g_ocr_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i015_bcl
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ocr[l_ac].* = g_ocr_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_ocr.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE i015_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE i015_bcl
         COMMIT WORK


      ON ACTION CONTROLO                 
         IF INFIELD(ocr01) AND l_ac > 1 THEN
            LET g_ocr[l_ac].* = g_ocr[l_ac-1].*
            NEXT FIELD ocr01
         END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
      
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT

   CLOSE i015_bcl
   COMMIT WORK

END FUNCTION


FUNCTION i015_b_askkey()

   CLEAR FORM
   CALL g_ocr.clear()

   CONSTRUCT g_wc2 ON ocr01,ocr02
           FROM s_ocr[1].ocr01,s_ocr[1].ocr02
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
      LET g_wc2 = NULL
      RETURN
   END IF

   CALL i015_b_fill(g_wc2)

END FUNCTION

FUNCTION i015_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000

   LET g_sql = "SELECT ocr01,ocr02",
               "  FROM ocr_file",
               " WHERE ", p_wc2 CLIPPED                     
   PREPARE i015_pb FROM g_sql
   DECLARE ocr_curs CURSOR FOR i015_pb

   CALL g_ocr.clear()

   LET g_cnt = 1
   MESSAGE "Searching!" 

   FOREACH ocr_curs INTO g_ocr[g_cnt].*   
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

   CALL g_ocr.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0

END FUNCTION

FUNCTION i015_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ocr TO s_ocr.* ATTRIBUTE(COUNT=g_rec_b)
 
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

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i015_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
                                                                                
    IF (p_cmd = 'a' AND  ( NOT g_before_input_done )
       OR p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'Y' ) THEN
       CALL cl_set_comp_entry("ocr01",TRUE)
    END IF
END FUNCTION            

FUNCTION i015_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1                    
                                                                                
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                             
      CALL cl_set_comp_entry("ocr01",FALSE)                                                                                       
    END IF                                                                                                                          
END FUNCTION            
#FUN-9A0036 
