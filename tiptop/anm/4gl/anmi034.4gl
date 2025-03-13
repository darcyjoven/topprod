# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: anmi034.4gl
# Descriptions...: 銀行外幣匯款性質維護作業 
# Date & Author..: FUN-A20010 10/02/27 By chenmoyan
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
#(Module Variables)
DEFINE 
    g_nnc01         LIKE nnc_file.nnc01,
    g_nnc01_t       LIKE nnc_file.nnc01,
    g_nnc           DYNAMIC ARRAY OF RECORD    #(Program Variables)
                    nnc02     LIKE nnc_file.nnc02,
                    nnc03     LIKE nnc_file.nnc03
                    END RECORD,
    g_nnc_t         RECORD    #(Program Variables)
                    nnc02     LIKE nnc_file.nnc02,
                    nnc03     LIKE nnc_file.nnc03
                    END RECORD,
    g_wc,g_wc2,g_sql     STRING,
    g_rec_b         LIKE type_file.num5,                 
    g_buf           LIKE nnc_file.nnc01,  
    l_ac            LIKE type_file.num5,        
    l_cmd           LIKE type_file.chr1000  
DEFINE p_row,p_col          LIKE type_file.num5  


DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5   

DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_chr           LIKE type_file.chr1   
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000 

DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10 
DEFINE   g_jump         LIKE type_file.num10  
DEFINE   mi_no_ask      LIKE type_file.num5 
DEFINE   l_table        STRING
DEFINE   l_sql          STRING
DEFINE   g_str          STRING

MAIN

    OPTIONS                                
        INPUT NO WRAP                      
    DEFER INTERRUPT                        

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF


   CALL cl_used(g_prog,g_time,1)
      RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM nnc_file WHERE nnc01 = ? FOR UPDATE"                                                           
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i034_cl CURSOR FROM g_forupd_sql

   LET p_row = 2 LET p_col = 12

   OPEN WINDOW i034_w AT p_row,p_col       
        WITH FORM "anm/42f/anmi034"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL i034_menu()

   CLOSE WINDOW i034_w     
     CALL cl_used(g_prog,g_time,2)
        RETURNING g_time
END MAIN

FUNCTION i034_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01

    CLEAR FORM             
    CALL g_nnc.clear()
    CALL cl_set_head_visible("","YES")

    CONSTRUCT g_wc ON nnc01,nnc02,nnc03
                 FROM nnc01,s_nnc[1].nnc02,s_nnc[1].nnc03

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
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)

    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF

    LET g_sql = "SELECT DISTINCT nnc01 FROM nnc_file",
                " WHERE ", g_wc CLIPPED 
 
    PREPARE i034_prepare FROM g_sql
    DECLARE i034_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i034_prepare
 
    LET g_sql="SELECT COUNT(DISTINCT nnc01) FROM nnc_file",
              " WHERE ",g_wc CLIPPED
    PREPARE i034_precount FROM g_sql
    DECLARE i034_count CURSOR FOR i034_precount

END FUNCTION

FUNCTION i034_menu()

   WHILE TRUE
      CALL i034_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i034_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i034_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i034_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i034_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nnc),'','')
            END IF
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_nnc01 IS NOT NULL THEN
                 LET g_doc.column1 = "nnc01"
                 LET g_doc.value1 = g_nnc01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i034_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_nnc.clear()

   INITIALIZE g_nnc01    LIKE nnc_file.nnc01
    
   CALL cl_opmsg('a')

   WHILE TRUE
      CALL i034_i('a')

      IF INT_FLAG THEN          
         LET g_nnc01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0

      CALL i034_b()    
      LET g_nnc01_t=g_nnc01
      EXIT WHILE
   END WHILE

END FUNCTION


FUNCTION i034_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )

    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  

    CALL i034_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF

    MESSAGE " SEARCHING ! " 
    OPEN i034_cs                  
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       LET g_nnc01 = NULL 
    ELSE
       OPEN i034_count
       FETCH i034_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL i034_fetch('F')       
    END IF

    MESSAGE ""

END FUNCTION


FUNCTION i034_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1  

   CASE p_flag
      WHEN 'N' FETCH NEXT     i034_cs INTO g_nnc01
      WHEN 'P' FETCH PREVIOUS i034_cs INTO g_nnc01
      WHEN 'F' FETCH FIRST    i034_cs INTO g_nnc01
      WHEN 'L' FETCH LAST     i034_cs INTO g_nnc01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
         FETCH ABSOLUTE g_jump i034_cs INTO g_nnc01
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnc01,SQLCA.sqlcode,0)
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
   CALL i034_show()
END FUNCTION


FUNCTION i034_show()

   DISPLAY g_nnc01 TO nnc01
                   
   CALL i034_b_fill(g_wc)      
   CALL cl_show_fld_cont()                   
END FUNCTION

FUNCTION i034_i(p_cmd)
   DEFINE   p_cmd        LIKE type_file.chr1 
   DEFINE   l_count      LIKE type_file.num5
   DEFINE   l_n          LIKE type_file.num5

   DISPLAY g_nnc01 TO nnc01

   INPUT   g_nnc01  WITHOUT DEFAULTS FROM  nnc01

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i034_set_entry(p_cmd)
         CALL i034_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      ON ACTION controlf          
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()

   END INPUT

END FUNCTION

FUNCTION i034_r()
   DEFINE   l_cnt         LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF

   IF cl_null(g_nnc01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 

   BEGIN WORK

   OPEN i034_cl USING g_nnc01
   IF STATUS THEN
      CALL cl_err("OPEN i034_cl:", STATUS, 1)
      CLOSE i034_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i034_cl INTO g_nnc01               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnc01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   IF cl_delh(0,0) THEN      
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "nnc01"
      LET g_doc.value1 = g_nnc01
      CALL cl_del_doc()
      DELETE FROM nnc_file 
       WHERE nnc01 = g_nnc01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","nnc_file",g_nnc01,"",SQLCA.sqlcode,"","BODY DELETE",0)  
      ELSE
         CLEAR FORM
         CALL g_nnc.clear()
         OPEN i034_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i034_cs
            CLOSE i034_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i034_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i034_cs
            CLOSE i034_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i034_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i034_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE         
            CALL i034_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK

END FUNCTION

FUNCTION i034_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                
    l_n             LIKE type_file.num5,                 
    l_n2            LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                
    l_allow_insert  LIKE type_file.num5,                
    l_allow_delete  LIKE type_file.num5                 

    LET g_action_choice = ""
    IF g_nnc01 IS NULL THEN RETURN END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql = 
        " SELECT nnc02,nnc03", 
        "   FROM nnc_file ",  
        "  WHERE nnc00=' ' AND nnc01 = ? AND nnc02=? FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i034_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_nnc WITHOUT DEFAULTS FROM s_nnc.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
           LET p_cmd =''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()

           BEGIN WORK

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_nnc_t.* = g_nnc[l_ac].*  #BACKUP

              OPEN i034_bcl USING g_nnc01,g_nnc_t.nnc02
              IF STATUS THEN
                 CALL cl_err("OPEN i034_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i034_bcl INTO g_nnc[l_ac].* 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_nnc_t.nnc02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()    
           END IF

        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_nnc[l_ac].* TO NULL
            LET g_nnc_t.* = g_nnc[l_ac].*       
           CALL cl_show_fld_cont()
           NEXT FIELD nnc02

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

        IF cl_null(g_nnc[l_ac].nnc02) THEN LET g_nnc[l_ac].nnc02=' ' END IF
           INSERT INTO nnc_file(nnc01,nnc02,nnc03,nnc00)
                         VALUES(g_nnc01,g_nnc[l_ac].nnc02,
                                g_nnc[l_ac].nnc03,' ')
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","nnc_file",g_nnc01,g_nnc[l_ac].nnc02,SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
           ELSE
              LET g_rec_b = g_rec_b + 1
              MESSAGE 'INSERT O.K'
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

        AFTER FIELD nnc02           
           IF NOT cl_null(g_nnc[l_ac].nnc02) THEN
              IF g_nnc[l_ac].nnc02 != g_nnc_t.nnc02
                 OR g_nnc_t.nnc02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM nnc_file
                  WHERE nnc01 = g_nnc01
                    AND nnc02 = g_nnc[l_ac].nnc02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_nnc[l_ac].nnc02 = g_nnc_t.nnc02
                    NEXT FIELD nnc02
                 END IF
              END IF
           END IF

        BEFORE DELETE                 
           IF g_nnc_t.nnc02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN 
                 CANCEL DELETE
              END IF
              
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              
              DELETE FROM nnc_file 
               WHERE nnc01 = g_nnc01 
                 AND nnc02 = g_nnc_t.nnc02
                 AND nnc03 = g_nnc_t.nnc03
              IF SQLCA.SQLERRD[3] = 0 THEN
                 CALL cl_err3("del","nnc_file",g_nnc01,g_nnc_t.nnc02,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE 
              ELSE
                 LET g_rec_b = g_rec_b -1 
                 DISPLAY g_rec_b TO FORMONLY.cn2  
              END IF
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_nnc[l_ac].* = g_nnc_t.*
              CLOSE i034_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_nnc[l_ac].nnc02,-263,1)
              LET g_nnc[l_ac].* = g_nnc_t.*
           ELSE
              UPDATE nnc_file SET nnc02=g_nnc[l_ac].nnc02,
                                  nnc03=g_nnc[l_ac].nnc03
               WHERE nnc01 = g_nnc01 
                 AND nnc02 = g_nnc_t.nnc02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","nnc_file",g_nnc01,g_nnc_t.nnc02,SQLCA.sqlcode,"","",1)
                 LET g_nnc[l_ac].* = g_nnc_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()
        #  LET l_ac_t = l_ac     #FUN-D30032 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_nnc[l_ac].* = g_nnc_t.*
            #FUN-D30032--add--str--
              ELSE
                 CALL g_nnc.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30032--add--end--
              END IF
              CLOSE i034_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac     #FUN-D30032 add
           CLOSE i034_bcl
           COMMIT WORK

        ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

        ON ACTION CONTROLO                     
            IF INFIELD(nnc02) AND l_ac > 1 THEN
                LET g_nnc[l_ac].* = g_nnc[l_ac-1].*
                NEXT FIELD nnc03
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
    
    END INPUT

    CLOSE i034_bcl
    COMMIT WORK

END FUNCTION

FUNCTION i034_b_askkey()
DEFINE    l_wc           LIKE type_file.chr1000

   CONSTRUCT l_wc  ON nnc02,nnc03
       FROM s_nnc[1].nnc02, s_nnc[1].nnc03 

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
        RETURN
    END IF
    CALL i034_b_fill(l_wc)

END FUNCTION

FUNCTION i034_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc     STRING 
DEFINE l_pjb03  LIKE pjb_file.pjb03
DEFINE l_pjj01  LIKE pjj_file.pjj01

   LET g_sql = "SELECT nnc02,nnc03",
               " FROM nnc_file",
               " WHERE nnc01 ='",g_nnc01,"'",    
               "   AND nnc00 =' '",
               "   AND ",p_wc CLIPPED,         
               " ORDER BY nnc02"


   PREPARE i034_pb FROM g_sql
   DECLARE nnc_curs CURSOR FOR i034_pb

   CALL g_nnc.clear()
   LET g_rec_b = 0
   LET g_cnt = 1

   FOREACH nnc_curs INTO g_nnc[g_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1
     
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
    
   END FOREACH
   CALL g_nnc.deleteElement(g_cnt)
   LET g_rec_b =g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0

END FUNCTION

FUNCTION i034_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_nnc TO s_nnc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION first 
         CALL i034_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
                              

      ON ACTION previous
         CALL i034_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY

      ON ACTION jump 
         CALL i034_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY
                              
      ON ACTION next
         CALL i034_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
                              

      ON ACTION last 
         CALL i034_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY

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
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION related_document        
         LET g_action_choice="related_document"          
         EXIT DISPLAY 

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION i034_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1        

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("nnc01",TRUE) 
   END IF

END FUNCTION

FUNCTION i034_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       

   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("nnc01",FALSE) 
   END IF
END FUNCTION
#FUN-A20010
