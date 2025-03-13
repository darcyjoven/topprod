# Prog. Version..: '5.10.03-08.08.20(009)''     #
#
# Pattern name...: ghri0781
# Descriptions...: 按钮维护作业
# Date & Author..: 13/08/16 jiangxt

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hred    DYNAMIC ARRAY OF RECORD                  
         hred01   LIKE hred_file.hred01,
         hred02   LIKE hred_file.hred02,
         hred03   LIKE hred_file.hred03,
         hred04   LIKE hred_file.hred04,
         hredacti LIKE hred_file.hredacti
                 END RECORD,
       g_hred_t  RECORD 
         hred01   LIKE hred_file.hred01,
         hred02   LIKE hred_file.hred02,
         hred03   LIKE hred_file.hred03,
         hred04   LIKE hred_file.hred04,
         hredacti LIKE hred_file.hredacti
                 END RECORD
DEFINE g_rec_b             LIKE type_file.num5  
DEFINE l_ac                 LIKE type_file.num5 
DEFINE g_sql                STRING
DEFINE g_forupd_sql         STRING 
DEFINE g_before_input_done  LIKE type_file.num5          #判斷是否已執行 Before Input指令       #No.FUN-680102 SMALLINT
DEFINE g_cnt                LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_wc                 STRING

MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                                      #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081

   OPEN WINDOW i0781_w WITH FORM "ghr/42f/ghri0781"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_action_choice = ""

   CALL i0781_b_fill("1=1")
   CALL i0781_menu()
   
   CLOSE WINDOW i0781_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i0781_cs()

    CLEAR FORM
    CALL g_hred.clear()
    LET g_rec_b=0
    
    CONSTRUCT g_wc ON hred01,hred02,hred03,hred04,hredacti
         FROM s_hred[1].hred01,s_hred[1].hred02,s_hred[1].hred03,
              s_hred[1].hred04,s_hred[1].hredacti

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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hreduser', 'hredgrup')

END FUNCTION

FUNCTION i0781_menu()

   WHILE TRUE
      CALL i0781_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i0781_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i0781_b()
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

FUNCTION i0781_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G"  THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hred TO s_hred.* ATTRIBUTE(COUNT=g_rec_b)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting(1,1)
                 
      BEFORE ROW
         CALL cl_show_fld_cont()
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY 
         
      ON ACTION detail
         LET l_ac=1
         LET g_action_choice="detail"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION ACCEPT
         LET l_ac=1
         LET g_action_choice="detail"
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
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                       
         CALL cl_set_head_visible("","AUTO")    

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i0781_q()
    
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i0781_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF  
    
    CALL i0781_b_fill(g_wc)
    
END FUNCTION

FUNCTION i0781_b_fill(p_wc)
DEFINE p_wc  STRING

   LET g_sql = "SELECT hred01,hred02,hred03,hred04,hredacti",
               "  FROM hred_file WHERE ",p_wc,
               " ORDER BY hred01"
   PREPARE i0781_pb FROM g_sql
   DECLARE i0781_pc CURSOR FOR i0781_pb
   CALL g_hred.clear()
   LET g_cnt = 1

   FOREACH i0781_pc INTO g_hred[g_cnt].*
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
   CALL g_hred.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
END FUNCTION

FUNCTION i0781_b()
DEFINE l_lock_sw       LIKE type_file.chr1
DEFINE p_cmd           LIKE type_file.chr1
DEFINE l_allow_insert  LIKE type_file.chr1
DEFINE l_allow_delete  LIKE type_file.chr1
DEFINE l_cnt           LIKE type_file.num5

    LET g_action_choice = "" 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    LET g_forupd_sql = "SELECT hred01,hred02,hred03,hred04,hredacti",
                       "  FROM hred_file WHERE hred01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i0781_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_hred WITHOUT DEFAULTS FROM s_hred.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_insert,APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'     
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               LET g_before_input_done = TRUE
               LET g_hred_t.* = g_hred[l_ac].*  #BACKUP
               OPEN i0781_bcl USING g_hred[l_ac].hred01
               IF STATUS THEN
                  CALL cl_err("OPEN i0781_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i0781_bcl INTO g_hred[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hred_t.hred01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

        BEFORE INSERT
           LET p_cmd='a'
           CALL cl_show_fld_cont()
           SELECT MAX(hred01)+1 INTO g_hred[l_ac].hred01 FROM hred_file
           IF cl_null(g_hred[l_ac].hred01) THEN LET g_hred[l_ac].hred01=1 END IF 
           LET g_hred[l_ac].hredacti='Y'
           DISPLAY BY NAME g_hred[l_ac].hred01,g_hred[l_ac].hredacti
           
           
        AFTER FIELD hred02
           IF cl_null(g_hred[l_ac].hred02) THEN 
              NEXT FIELD hred02 
           END IF 
           IF p_cmd='a' OR (p_cmd='u' AND g_hred[l_ac].hred02!=g_hred_t.hred02) THEN 
              SELECT count(*) INTO l_cnt FROM hred_file
               WHERE hred02=g_hred[l_ac].hred02
              IF l_cnt>0 THEN 
                 CALL cl_err('','agl-447',0)
                 NEXT FIELD hred02
              END IF 
              SELECT F_TRANS_PINYIN_CAPITAL(g_hred[l_ac].hred02) INTO g_hred[l_ac].hred04 FROM dual
              IF cl_null(g_hred[l_ac].hred04) THEN
                 CALL cl_err('','ghr-178',0) 
                 NEXT FIELD hred02
              END IF 
              DISPLAY BY NAME g_hred[l_ac].hred04
           END IF 
           
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i0781_bcl
              CANCEL INSERT
           END IF
           
        BEGIN WORK
           INSERT INTO hred_file(hred01,hred02,hred03,hred04,hredacti)
                VALUES(g_hred[l_ac].hred01,g_hred[l_ac].hred02,g_hred[l_ac].hred03,
                       g_hred[l_ac].hred04,g_hred[l_ac].hredacti)
           IF SQLCA.sqlcode THEN
               ROLLBACK WORK
               CALL cl_err3("ins","hred_file",g_hred[l_ac].hred01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
           END IF

        BEFORE DELETE
           IF NOT cl_delete() THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           DELETE FROM hred_file WHERE hred01 = g_hred[l_ac].hred01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hred_file",g_hred[l_ac].hred01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
              EXIT INPUT
           END IF
           LET g_rec_b=g_rec_b-1
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN                 #?板?绋.?娈
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hred[l_ac].* = g_hred_t.*
              CLOSE i0781_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hred[l_ac].hred01,-263,0)
               LET g_hred[l_ac].* = g_hred_t.*
           ELSE
               UPDATE hred_file SET hred02=g_hred[l_ac].hred02,
                                    hred03=g_hred[l_ac].hred03,
                                    hred04=g_hred[l_ac].hred04,
                                    hredacti=g_hred[l_ac].hredacti
                               WHERE hred01 = g_hred[l_ac].hred01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hred_file",g_hred[l_ac].hred01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hred[l_ac].* = g_hred_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR() 

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_hred[l_ac].* = g_hred_t.*
              END IF
              CLOSE i0781_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i0781_bcl
           COMMIT WORK

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121

        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121

    END INPUT
    
    CLOSE i0781_bcl
    COMMIT WORK

END FUNCTION
