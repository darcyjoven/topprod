# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: aooi222.4gl
# Descriptions...: 庫存異動類別理由碼設置作業
# Date & Author..: 12/11/22 By qiull    #FUN-CB0087
# Modify.........: No:TQC-D10103 13/02/04 By qiull 更改出入庫，異動類別，理由碼的控管
# Modify.........: No:TQC-D20042 13/02/22 By qiull 錄入時模具編號不給開窗
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
       g_gge01,g_gge01_t LIKE gge_file.gge01,
       g_gge02,g_gge02_t LIKE gge_file.gge02,
       g_gge_lock        RECORD LIKE gge_file.*,
       g_ggeuser         LIKE gge_file.ggeuser,  
       g_ggegrup         LIKE gge_file.ggegrup,
       g_ggemodu         LIKE gge_file.ggemodu,
       g_ggedate         LIKE gge_file.ggedate,
       g_gge             DYNAMIC ARRAY OF RECORD
           gge03         LIKE gge_file.gge03,
           gge04         LIKE gge_file.gge04,
           gge05         LIKE gge_file.gge05,      
           ggd02         LIKE ggd_file.ggd02,
           gge06         LIKE gge_file.gge06,
           azf03         LIKE azf_file.azf03,
           ggeacti       LIKE gge_file.ggeacti
                         END RECORD,
       g_gge_t           RECORD                    
           gge03         LIKE gge_file.gge03,
           gge04         LIKE gge_file.gge04,
           gge05         LIKE gge_file.gge05,      
           ggd02         LIKE ggd_file.ggd02,
           gge06         LIKE gge_file.gge06,
           azf03         LIKE azf_file.azf03,
           ggeacti       LIKE gge_file.ggeacti 
                            END RECORD,
       g_wc,g_wc2,g_sql     STRING,  
       g_delete             LIKE type_file.chr1,   
       g_rec_b              LIKE type_file.num5,   
       l_ac                 LIKE type_file.num5
DEFINE p_row,p_col          LIKE type_file.num5    
DEFINE g_forupd_sql         STRING   
DEFINE g_chr                LIKE type_file.chr1
DEFINE g_sql_tmp            STRING   
DEFINE g_before_input_done  LIKE type_file.num5        
DEFINE g_cnt                LIKE type_file.num10         
DEFINE g_i                  LIKE type_file.num5          
DEFINE g_msg                LIKE ze_file.ze03           
DEFINE g_row_count          LIKE type_file.num10         
DEFINE g_curs_index         LIKE type_file.num10         
DEFINE g_jump               LIKE type_file.num10         
DEFINE mi_no_ask            LIKE type_file.num5         
DEFINE g_str                STRING  

MAIN
   OPTIONS                               
      INPUT NO WRAP
   DEFER INTERRUPT                       

   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
   INITIALIZE g_gge TO NULL                                                
   INITIALIZE g_gge_t.* TO NULL  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   OPEN WINDOW i222_w AT p_row,p_col               
     WITH FORM "aoo/42f/aooi222"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   
   CALL g_x.clear()
   LET g_delete='N'
   CALL i222_menu()   
   CLOSE WINDOW i222_w     
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i222_menu()
   WHILE TRUE
      CALL i222_bp("G")
      CASE g_action_choice
          WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i222_a()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i222_u()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i222_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i222_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i222_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i222_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i222_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()        
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               call cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_gge),'','')
            END IF 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_gge01 IS NOT NULL THEN
                 LET g_doc.column1 = "gge01"
                 LET g_doc.value1 = g_gge01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i222_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          

    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
    LET g_action_choice = " "
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_gge TO s_gge.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first 
         CALL i222_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN            
              CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY            
 
      ON ACTION previous
         CALL i222_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	       ACCEPT DISPLAY            
 
      ON ACTION jump 
         CALL i222_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	       ACCEPT DISPLAY              
 
      ON ACTION next
         CALL i222_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1) 
           END IF
	       ACCEPT DISPLAY              
 
      ON ACTION last 
         CALL i222_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
           END IF
	       ACCEPT DISPLAY  
           
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
 
     ON ACTION close
       LET g_action_choice="exit"
        EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     
      
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION controls                                
         CALL cl_set_head_visible("","AUTO")     
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i222_cs()

   CLEAR FORM                            
   CALL g_gge.clear()  
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_gge01 TO NULL    
   INITIALIZE g_gge02 TO NULL
   
   CONSTRUCT g_wc ON gge01,gge02,
                     gge03,gge04,gge05,ggd02,gge06,azf03,ggeacti
           FROM gge01,gge02,
                s_gge[1].gge03,s_gge[1].gge04,
                s_gge[1].gge05,s_gge[1].ggd02,
                s_gge[1].gge06,s_gge[1].azf03,s_gge[1].ggeacti
   BEFORE CONSTRUCT
      CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE WHEN INFIELD(gge01)     
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_gge01"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gge01
                   NEXT FIELD gge01
               WHEN INFIELD(gge05)      
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_ggd01"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gge05
                   NEXT FIELD gge05 
               WHEN INFIELD(gge06)      
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_azf41"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gge06
                   NEXT FIELD gge06 
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
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()
		
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF

   LET g_sql="SELECT UNIQUE gge01,gge02",
              " FROM gge_file ", 
              " WHERE ", g_wc CLIPPED,
              " ORDER BY gge01"
   PREPARE i222_prepare FROM g_sql     
   DECLARE i222_bcs SCROLL CURSOR WITH HOLD FOR i222_prepare
   LET g_sql=" SELECT COUNT(UNIQUE gge01) ",
              "   FROM gge_file WHERE ",g_wc CLIPPED
    PREPARE i222_precount FROM g_sql
    DECLARE i222_count CURSOR FOR i222_precount
END FUNCTION

FUNCTION i222_q()
  DEFINE l_gge01     LIKE gge_file.gge01,
         l_curr         LIKE gge_file.gge02,
         l_cnt          LIKE type_file.num10           

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gge01 TO NULL              
    INITIALIZE g_gge02 TO NULL               
             
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_gge.clear()
    CALL i222_cs()                            #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_gge01 TO NULL
      INITIALIZE g_gge02 TO NULL
      RETURN
   END IF
   OPEN i222_bcs                    
   IF SQLCA.sqlcode THEN                        
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_gge01 TO NULL
      INITIALIZE g_gge02 TO NULL
   ELSE
      OPEN i222_count
      FETCH i222_count INTO g_row_count
      DISPLAY g_curs_index TO indx
      DISPLAY g_row_count TO cnt  
      CALL i222_fetch('F')    
   END IF
END FUNCTION

FUNCTION i222_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i222_bcs INTO g_gge01,g_gge02
        WHEN 'P' FETCH PREVIOUS i222_bcs INTO g_gge01,g_gge02
        WHEN 'F' FETCH FIRST    i222_bcs INTO g_gge01,g_gge02
        WHEN 'L' FETCH LAST     i222_bcs INTO g_gge01,g_gge02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0 
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()

                   ON ACTION about       
                      CALL cl_about()     

                   ON ACTION HELP         
                      CALL cl_show_help() 

                   ON ACTION controlg     
                      CALL cl_cmdask()    
         
                END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i222_bcs 
            INTO g_gge01,g_gge02
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN                        
       CALL cl_err(g_gge01,SQLCA.sqlcode,0)
       INITIALIZE g_gge01 TO NULL  
       INITIALIZE g_gge02 TO NULL
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    OPEN i222_count
    FETCH i222_count INTO g_row_count
    DISPLAY g_curs_index TO indx  
    DISPLAY g_row_count TO cnt 
    CALL i222_show()
END FUNCTION

FUNCTION i222_show()
    LET g_gge01_t = g_gge01
    LET g_gge02_t = g_gge02
    DISPLAY g_gge01 TO gge01
    DISPLAY g_gge02 TO gge02
    CALL i222_b_fill(g_wc)
    CALL cl_show_fld_cont()                  
END FUNCTION

FUNCTION i222_gge05()
  SELECT ggd02    
    INTO g_gge[l_ac].ggd02
    FROM ggd_file 
   WHERE ggd01 = g_gge[l_ac].gge05  
   DISPLAY BY NAME g_gge[l_ac].ggd02
END FUNCTION

FUNCTION i222_gge06()
   SELECT azf03
     INTO g_gge[l_ac].azf03 
     FROM azf_file
    WHERE azfacti = 'Y' 
      AND azf02 = '2' 
      AND azf01 = g_gge[l_ac].gge06
    
    DISPLAY BY NAME g_gge[l_ac].azf03
END FUNCTION

FUNCTION i222_a() 

   MESSAGE ""
   CLEAR FORM
   CALL g_gge.clear()
   IF s_shut(0) THEN 
      RETURN 
   END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   CALL g_gge.clear()
   
   INITIALIZE g_gge01 LIKE gge_file.gge01
   INITIALIZE g_gge02 LIKE gge_file.gge02
   LET g_gge01_t = NULL
   CALL cl_opmsg('a') 
   
   WHILE TRUE
      LET g_ggeuser = g_user
      LET g_ggegrup = g_grup
      LET g_ggedate = g_today
      LET g_ggemodu = NULL
      CALL i222_i("a")                   
      IF INT_FLAG THEN                   
         LET g_gge01 = NULL
         CLEAR FORM
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
      CALL i222_b()                           
      LET g_gge01_t = g_gge01 
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i222_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1, 
    l_n             LIKE type_file.num5
    
    IF s_shut(0) THEN
      RETURN
    END IF 
    CALL cl_set_head_visible("","YES")
    INPUT g_gge01,g_gge02  WITHOUT DEFAULTS
          FROM gge01,gge02

         BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i222_set_entry(p_cmd)
            CALL i222_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE

         AFTER FIELD gge01               
            IF NOT cl_null(g_gge01) THEN
               IF (g_gge01 != g_gge01_t AND NOT cl_null(g_gge01_t)) 
                  OR g_gge01_t IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM gge_file
                  WHERE gge01=g_gge01
                  IF l_n >=1 THEN
                     CALL cl_err(g_gge01,"atm-310",0)
                     NEXT FIELD gge01
                  END IF
               END IF
            END IF
        #TQC-D20042---mark---str---
        #ON ACTION CONTROLP
        #   CASE
        #      WHEN INFIELD(gge01)
        #         CALL cl_init_qry_var()
        #         LET g_qryparam.form ="q_gge01"
        #         LET g_qryparam.default1 = g_gge01
        #         CALL cl_create_qry() RETURNING g_gge01
        #         DISPLAY BY NAME g_gge01
        #         NEXT FIELD gge01
        #      OTHERWISE
        #   END CASE
        #TQC-D20042---mark---end---

        ON ACTION CONTROLF                  
          CALL cl_set_focus_form(ui.Interface.getRootNode()) 
          RETURNING g_fld_name,g_frm_name 
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION HELP          
           CALL cl_show_help()  
 
        ON ACTION controlg      
           CALL cl_cmdask()  
    END INPUT
END FUNCTION

#單身
FUNCTION i222_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                #檢查重複用      
    l_str           LIKE type_file.chr20,              
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否     
    p_cmd           LIKE type_file.chr1,                #處理狀態         
    l_allow_insert  LIKE type_file.num5,                #可新增否         
    l_allow_delete  LIKE type_file.num5,                 #可刪除否         
    l_gge04         LIKE gge_file.gge04,
    l_gge05         LIKE gge_file.gge05,
    l_max           LIKE gge_file.gge03

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_gge01 IS NULL  THEN
       RETURN
    END IF

    CALL cl_opmsg('b')
    LET g_ggeuser = g_user
    LET g_ggegrup = g_grup
    LET g_ggemodu = g_user
    LET g_ggedate = g_today

    LET g_forupd_sql = "SELECT gge03,gge04,gge05,'',",
                       "  gge06,'',ggeacti",
                       "  FROM gge_file",
                       "  WHERE gge01=? AND gge03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i222_bcl CURSOR FROM g_forupd_sql
    
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_gge WITHOUT DEFAULTS FROM s_gge.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'  
           IF g_rec_b >= l_ac THEN         
             BEGIN WORK 
        
              LET p_cmd='u'
              LET g_gge_t.* = g_gge[l_ac].*     
              OPEN i222_bcl USING g_gge01,g_gge[l_ac].gge03
              IF STATUS THEN
                 CALL cl_err("OPEN i222_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i222_bcl INTO g_gge[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('g_gge_t.gge04',SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 ELSE 
                    CALL i222_gge05()
                    CALL i222_gge06()
                    LET g_gge_t.*=g_gge[l_ac].*
                 END IF 
              END IF 
              CALL cl_show_fld_cont()   
           END IF 

        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_gge[l_ac].* TO NULL     
           LET g_gge_t.* = g_gge[l_ac].*
           LET g_gge[l_ac].ggeacti = 'Y'         
           CALL cl_show_fld_cont()    
           NEXT FIELD gge03

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           INSERT INTO gge_file(gge01,gge02,ggeuser,ggegrup,ggemodu,ggedate,ggeorig,ggeoriu,gge03,gge04,gge05,
                                   gge06,ggeacti) 
           VALUES(g_gge01,g_gge02,g_ggeuser,g_ggegrup,g_ggemodu,g_ggedate,
                  g_grup,g_user,g_gge[l_ac].gge03,
                  g_gge[l_ac].gge04,g_gge[l_ac].gge05,
                  g_gge[l_ac].gge06,g_gge[l_ac].ggeacti)      
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","gge_file",g_gge01,g_gge[l_ac].gge03,
                             SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO cn2
              COMMIT WORK
           END IF

        BEFORE FIELD gge03                       
          IF g_gge[l_ac].gge03 IS NULL OR g_gge[l_ac].gge03 = 0 THEN
             SELECT max(gge03)+10
               INTO g_gge[l_ac].gge03
               FROM gge_file
              WHERE gge01 = g_gge01
             IF g_gge[l_ac].gge03 IS NULL THEN
                LET g_gge[l_ac].gge03 = 10
             END IF
          END IF
 
       AFTER FIELD gge03                      
          IF NOT cl_null(g_gge[l_ac].gge03) THEN
             IF g_gge[l_ac].gge03 != g_gge_t.gge03
                OR g_gge_t.gge03 IS NULL THEN
                IF g_gge[l_ac].gge03 <= 0 THEN
                   CALL cl_err('','aec-994',0)
                   NEXT FIELD gge03
                END IF
                SELECT count(*)
                  INTO l_n
                  FROM gge_file
                 WHERE gge01 = g_gge01
                   AND gge03 = g_gge[l_ac].gge03
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_gge[l_ac].gge03 = g_gge_t.gge03
                   NEXT FIELD gge03
                END IF
             END IF
          END IF 

        AFTER FIELD gge04
            NEXT FIELD gge05

        AFTER FIELD gge05
           IF NOT cl_null(g_gge[l_ac].gge05) THEN 
              IF p_cmd='a' OR g_gge[l_ac].* <> g_gge_t.* THEN             #TQC-D10103---add---
                 SELECT count(*) INTO l_n FROM ggd_file
                  WHERE ggdacti= 'Y'
                    AND ggd01 = g_gge[l_ac].gge05
                 IF l_n <= 0 THEN 
                    CALL cl_err('','aoo-892',0)
                    NEXT FIELD gge05
                 END IF 
                 IF cl_null(g_gge_t.gge03) THEN LET g_gge_t.gge03 = g_gge[l_ac].gge03 END IF           #TQC-D10103---add---
                 SELECT DISTINCT gge04 INTO l_gge04 FROM gge_file
                  WHERE gge01 = g_gge01
                    AND gge05 = g_gge[l_ac].gge05
                    AND gge03 <> g_gge_t.gge03                            #TQC-D10103---add---
                  IF status=100 THEN
                     LET l_gge04 = NULL 
                  END IF
                  IF l_gge04 IS NOT NULL THEN
                     IF l_gge04 <> g_gge[l_ac].gge04 THEN 
                        CALL cl_err('','aoo-891',0)
                        NEXT FIELD gge05
                     END IF 
                  END IF
                  CALL i222_gge05()
              END IF                                                              #TQC-D10103---add---
           END IF 
           NEXT FIELD gge06
                  
        AFTER FIELD gge06
           IF NOT cl_null(g_gge[l_ac].gge06) THEN 
              IF p_cmd='a' OR g_gge[l_ac].* <> g_gge_t.* THEN             #TQC-D10103---add---
                 SELECT count(*) INTO l_n FROM azf_file
                  WHERE azf01=g_gge[l_ac].gge06
                    AND azfacti = 'Y'
                    AND azf02='2'
                 IF l_n <= 0 THEN
                    CALL cl_err('','mfg3088',0)
                    NEXT FIELD gge06
                 END IF
                 #TQC-D10103---add---str---
                 SELECT COUNT(*) INTO l_n FROM gge_file
                  WHERE gge01 = g_gge01
                    AND gge04 = g_gge[l_ac].gge04
                    AND gge05 = g_gge[l_ac].gge05
                    AND gge06 = g_gge[l_ac].gge06
                 IF l_n >= 1 THEN
                    CALL cl_err('',-239,0)
                    NEXT FIELD gge06
                 END IF
                 IF cl_null(g_gge_t.gge05) THEN
                    LET g_gge_t.gge05 = g_gge[l_ac].gge05
                 END IF
                 #TQC-D10103---add---end---
                 SELECT DISTINCT gge05 INTO l_gge05 FROM gge_file 
                  WHERE gge06 = g_gge[l_ac].gge06
                    AND gge01 = g_gge01
                    AND gge05 <> g_gge_t.gge05                #TQC-D10103---add---
                  IF status=100 THEN
                     LET l_gge05 = NULL
                  END IF 
                  IF l_gge05 IS NOT NULL THEN
                      IF l_gge05 <> g_gge[l_ac].gge05 THEN 
                         CALL cl_err('','aoo-890',0)
                         NEXT FIELD gge06
                      END IF                                     
                  END IF
                  CALL i222_gge06()
              END IF                                          #TQC-D10103---add---
           END IF 

        BEFORE DELETE      
            IF g_gge_t.gge03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM gge_file
                 WHERE gge01 = g_gge01 
                   AND gge03 = g_gge_t.gge03 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","gge_file",g_gge_t.gge03,"",
                                  SQLCA.sqlcode,"","",1) 
                    ROLLBACK WORK
                    CANCEL DELETE 
                    EXIT INPUT
                END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_gge[l_ac].* = g_gge_t.*
              CLOSE i222_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_gge[l_ac].gge05,-263,1)
              LET g_gge[l_ac].* = g_gge_t.*
           ELSE
              UPDATE gge_file SET  gge01=g_gge01,  
                                   gge02=g_gge02,
                                   ggemodu = g_ggemodu,
                                   ggedate = g_ggedate,
                                   gge03=g_gge[l_ac].gge03,
                                   gge04=g_gge[l_ac].gge04,
                                   gge05=g_gge[l_ac].gge05,
                                   gge06=g_gge[l_ac].gge06,
                                   ggeacti=g_gge[l_ac].ggeacti 
               WHERE gge01 = g_gge01 
                 AND gge03 = g_gge_t.gge03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","gge_file",g_gge[l_ac].gge03,"",
                               SQLCA.sqlcode,"","",1)  
                 LET g_gge[l_ac].* = g_gge_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_gge[l_ac].* = g_gge_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_gge.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i222_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add 
            CLOSE i222_bcl
            COMMIT WORK

        ON ACTION controlp 
           CASE
              WHEN INFIELD(gge05)
                 CALL cl_init_qry_var()       
                 LET g_qryparam.form ="q_ggd01"
                 LET g_qryparam.default1 = g_gge[l_ac].gge05
                 CALL cl_create_qry() RETURNING g_gge[l_ac].gge05
                 DISPLAY g_gge[l_ac].gge05 TO gge05
                 CALL i222_gge05()
                 NEXT FIELD gge05   
              WHEN INFIELD(gge06)
                 CALL cl_init_qry_var()       
                 LET g_qryparam.form ="q_azf41"
                 LET g_qryparam.default1 = g_gge[l_ac].gge06
                 CALL cl_create_qry() RETURNING g_gge[l_ac].gge06
                 DISPLAY g_gge[l_ac].gge06 TO gge06
                 CALL i222_gge06()
                 NEXT FIELD gge06       
           END CASE
        ON ACTION CONTROLO 
              IF INFIELD(gge03) AND l_ac > 1 THEN                                                                                      
                 LET g_gge[l_ac].* = g_gge[l_ac-1].* 
                 SELECT max(gge03) INTO l_max FROM gge_file WHERE gge01 = g_gge01
                 LET g_gge[l_ac].gge03 = l_max+10
                 NEXT FIELD gge03                                                                                                     
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

      ON ACTION controls                          
         CALL cl_set_head_visible("","AUTO")     

    END INPUT

    CLOSE i222_bcl
    COMMIT WORK
   
    SELECT COUNT(gge03) INTO l_n FROM gge_file WHERE gge01=g_gge01
    IF l_n = 0 THEN
       CALL i222_delall() 
    END IF   
END FUNCTION

FUNCTION i222_delall()
   SELECT COUNT(*) INTO g_cnt FROM gge_file
    WHERE gge01 = g_gge01

   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM gge_file WHERE gge01 = g_gge01
      CLEAR FORM 
      CALL g_gge.clear()
   END IF
END FUNCTION

FUNCTION i222_b_fill(p_wc)          
DEFINE
    p_wc            LIKE type_file.chr1000       

    LET g_sql = "SELECT gge03,gge04,gge05,ggd02,",
                " gge06,azf03,ggeacti ",
                "  FROM gge_file LEFT JOIN ggd_file ON ggd01=gge05 ",
                "                LEFT JOIN azf_file ON azf01=gge06 AND azf02='2' ",
                " WHERE gge01 = '",g_gge01,"'",
                "   AND gge02 = '",g_gge02,"'",
                "   AND ",p_wc CLIPPED,
                " ORDER BY gge01"
    PREPARE i222_prepare2 FROM g_sql      
    DECLARE gge_cs CURSOR FOR i222_prepare2

    CALL g_gge.clear()   
    LET g_cnt = 1
    LET g_rec_b=0

    FOREACH gge_cs INTO g_gge[g_cnt].*  
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_gge.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1  
    DISPLAY g_rec_b TO FORMONLY.cn2 
END FUNCTION

FUNCTION i222_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1  
    IF (NOT g_before_input_done) THEN                                            
       CALL cl_set_comp_entry("gge01",TRUE)                               
    END IF 
END FUNCTION

FUNCTION i222_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         
    IF (NOT g_before_input_done) THEN                                            
       IF p_cmd = 'u' AND g_chkey = 'N' THEN                                    
           CALL cl_set_comp_entry("gge01",TRUE)                          
       END IF                                                                   
   END IF 

END FUNCTION

FUNCTION i222_u()

   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_gge01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_opmsg('u')
   LET g_gge01_t = g_gge01 
   LET g_ggemodu = g_user
   LET g_ggedate = g_today
   WHILE TRUE
      CALL i222_i("u")                      
        IF INT_FLAG THEN
            LET g_gge01=g_gge01_t
            DISPLAY g_gge01 TO gge01          
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_gge01 != g_gge01_t OR g_gge02 != g_gge02_t  THEN #欄位更改         
            UPDATE gge_file SET gge01  = g_gge01,
                                ggemodu = g_ggemodu,
                                ggedate = g_ggedate
                WHERE gge01 = g_gge01_t       
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","gge_file",g_gge01,"",
                              SQLCA.sqlcode,"","",1) 
                CONTINUE WHILE
            END IF
        END IF
        CALL i222_b()
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i222_r()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_gge01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF cl_delh(0,0) THEN                   #確認一下 
        INITIALIZE g_doc.* TO NULL      
        LET g_doc.column1 = "gge01"     
        LET g_doc.value1 = g_gge01      
        CALL cl_del_doc()                
        DELETE FROM gge_file WHERE gge01 = g_gge01 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","gge_file",g_gge01,"",SQLCA.sqlcode,"",
                         "BODY DELETE",1)  
        ELSE
            CLEAR FORM
            CALL g_gge.clear()
            LET g_delete='Y'
            LET g_gge01 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i222_count                                                     
            FETCH i222_count INTO g_row_count                 
            DISPLAY g_curs_index TO FORMONLY.cnt  
            DISPLAY g_row_count TO FORMONLY.cn2               
            OPEN i222_bcs   
            IF g_row_count>0 THEN            
            IF g_curs_index = g_row_count + 1 THEN            
               LET g_jump = g_row_count                       
            ELSE                                              
               LET g_jump = g_curs_index 
            END IF               
               LET mi_no_ask = TRUE                           
               CALL i222_fetch('/')                           
            END IF
        END IF
    END IF
END FUNCTION

FUNCTION i222_copy()
   DEFINE   l_n              LIKE type_file.num5,         
            l_newno          LIKE gge_file.gge01,
            l_oldgge02       LIKE gge_file.gge02,
            l_oldno          LIKE gge_file.gge01
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
   IF g_gge01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   
   INPUT l_newno FROM gge01
     BEFORE INPUT
          LET g_before_input_done = FALSE                                             
          CALL i222_set_entry('a')                                                  
          LET g_before_input_done = TRUE 
     AFTER FIELD gge01               
          SELECT COUNT(*) INTO l_n FROM gge_file WHERE gge01=l_newno 
            IF l_n > 0 THEN 
               CALL cl_err(l_newno,-239,0) NEXT FIELD gge01
            END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(gge01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gge01"
                 LET g_qryparam.default1 = l_newno
                 CALL cl_create_qry() RETURNING l_newno
                 DISPLAY l_newno TO gge01
                 NEXT FIELD gge01
              OTHERWISE
           END CASE
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_gge01,g_gge02 
      TO gge01,gge02 
      RETURN
   END IF
   DROP TABLE x
   SELECT * FROM gge_file
     WHERE gge01 = g_gge01 
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_gge01,"",SQLCA.sqlcode,"","",0)   
      RETURN
   END IF
   UPDATE x
      SET gge01 = l_newno                        # 資料鍵值
   INSERT INTO gge_file SELECT * FROM x

   LET l_oldno = g_gge01
   LET g_gge01 = l_newno
   CALL i222_b()
   LET g_gge01 = l_oldno
   CALL i222_show()
END FUNCTION

FUNCTION i222_out()
    DEFINE
       l_i             LIKE type_file.num5,          
       l_gge           RECORD LIKE gge_file.*,
       l_name          LIKE type_file.chr20,        
       sr              RECORD 
                       gge01   LIKE gge_file.gge01,
                       gge02   LIKE gge_file.gge02,
                       gge03   LIKE gge_file.gge03,
                       gge04   LIKE gge_file.gge04,
                       gge05   LIKE gge_file.gge05,
                       gge06   LIKE gge_file.gge06,
                       ggeacti  LIKE gge_file.ggeacti
                       END RECORD
   DEFINE l_cmd           LIKE  type_file.chr1000        
 
   IF cl_null(g_wc) AND NOT cl_null(g_gge01)  THEN                                                                                  
      LET g_wc = " gge01 = '",g_gge01,"' "                                                                                          
   END IF                                                                                                                           
   IF g_wc IS NULL THEN                                                                                                             
      CALL cl_err('','9057',0)                                                                                                      
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                                                                                                                              
   LET l_cmd = 'p_query "aooi222" "',g_wc CLIPPED,'"'                                                                 
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN 
END FUNCTION
#FUN-CB0087
