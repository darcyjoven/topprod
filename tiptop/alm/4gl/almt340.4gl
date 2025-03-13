# Prog. Version..: '5.30.06-13.04.09(00007)'     #
#
# Pattern name...: almt340.4gl
# Descriptions...: 合約費用項設置作業
# Date & Author..: NO.FUN-B90121 11/09/23 By xumm  
# Modify.........: No:TQC-C20330 12/02/21 By xumm  修改alm1452報錯相關判斷
# Modify.........: No:FUN-C30072 12/04/17 By xumm  单身费用编号检查：不能录入费用支出类型的费用编号
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C80041 12/12/26 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No.CHI-D20015 13/03/26 By qiull 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lii            RECORD LIKE lii_file.*,    
       g_lii_t          RECORD LIKE lii_file.*,   
       g_lii_o          RECORD LIKE lii_file.*,  
       g_lii01_t        LIKE lii_file.lii01,      
       g_lij            DYNAMIC ARRAY OF RECORD
           lij02        LIKE lij_file.lij02,
           oaj02        LIKE oaj_file.oaj02,
           oaj031       LIKE oaj_file.oaj031, 
           lnj02        LIKE lnj_file.lnj02,
           lij03        LIKE lij_file.lij03,
           lnr02        LIKE lnr_file.lnr02,
           lij04        LIKE lij_file.lij04,
           lij05        LIKE lij_file.lij05,
           lij06        LIKE lij_file.lij06,
           lij07        LIKE lij_file.lij07,
           lij08        LIKE lij_file.lij08
                        END RECORD,
       g_lij_t          RECORD                    
           lij02        LIKE lij_file.lij02,
           oaj02        LIKE oaj_file.oaj02,
           oaj031       LIKE oaj_file.oaj031, 
           lnj02        LIKE lnj_file.lnj02,
           lij03        LIKE lij_file.lij03,
           lnr02        LIKE lnr_file.lnr02,
           lij04        LIKE lij_file.lij04,
           lij05        LIKE lij_file.lij05,
           lij06        LIKE lij_file.lij06,
           lij07        LIKE lij_file.lij07,
           lij08        LIKE lij_file.lij08
                        END RECORD,
       g_lij_o          RECORD                     
           lij02        LIKE lij_file.lij02,
           oaj02        LIKE oaj_file.oaj02,
           oaj031       LIKE oaj_file.oaj031, 
           lnj02        LIKE lnj_file.lnj02,
           lij03        LIKE lij_file.lij03,
           lnr02        LIKE lnr_file.lnr02,
           lij04        LIKE lij_file.lij04,
           lij05        LIKE lij_file.lij05,
           lij06        LIKE lij_file.lij06,
           lij07        LIKE lij_file.lij07,
           lij08        LIKE lij_file.lij08
                        END RECORD,
          g_sql            STRING,                      
          g_wc             STRING,                     
          g_wc2            STRING,                    
          g_rec_b          LIKE type_file.num5,      
          l_ac             LIKE type_file.num5      
DEFINE g_forupd_sql        STRING            
DEFINE g_before_input_done LIKE type_file.num5 
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE li_result           LIKE type_file.num5  
DEFINE g_msg               LIKE ze_file.ze03  
DEFINE g_curs_index        LIKE type_file.num10 
DEFINE g_row_count         LIKE type_file.num10 
DEFINE g_jump              LIKE type_file.num10 
DEFINE g_no_ask            LIKE type_file.num5                        
DEFINE g_confirm           LIKE type_file.chr1
DEFINE g_void              LIKE type_file.chr1
DEFINE g_t1                LIKE oay_file.oayslip
 
MAIN
   OPTIONS                              
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM lii_file WHERE lii01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t340_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t340_w WITH FORM "alm/42f/almt340"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_set_locale_frm_name("almt340")   
   CALL cl_ui_init()
   
   LET g_pdate = g_today   
 
   CALL t340_menu()
   CLOSE WINDOW t340_w               
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t340_cs()
   CLEAR FORM 
   CALL g_lij.clear()
 
   IF g_wc =' ' THEN
      LET g_wc=' 1=1'
   END IF

   CALL cl_set_head_visible("","YES")   
   INITIALIZE g_lii.* TO NULL     
   CONSTRUCT BY NAME g_wc ON lii01,liiplant,liilegal,lii05,lii03,lii04,
                             lii02,liiconf,liiconu,liicond,lii06,liicont,
                             liiuser,liigrup,liioriu,liimodu,liidate,
                             liiorig,liiacti,liicrat
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(lii01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lii01"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lii01
                  NEXT FIELD lii01
      
               WHEN INFIELD(liiplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_liiplant"
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.default1 = g_plant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO liiplant
                  NEXT FIELD liiplant
      
               WHEN INFIELD(liilegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_liilegal"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_legal
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO liilegal
                  NEXT FIELD liilegal

                WHEN INFIELD(lii05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lii05"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lii05
                  NEXT FIELD lii05 

                WHEN INFIELD(lii03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lii03"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lii03
                  NEXT FIELD lii03

                WHEN INFIELD(lii04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lii04"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lii04
                  NEXT FIELD lii04

                WHEN INFIELD(liiconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_liiconu"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO liiconu
                  NEXT FIELD liiconu 
                  
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about        
            CALL cl_about()    
     
         ON ACTION help        
            CALL cl_show_help()
     
          ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         ON ACTION controlg   
            CALL cl_cmdask() 
      
   END CONSTRUCT
      
   IF INT_FLAG THEN
      RETURN
   END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('liiuser', 'liigrup')
 
   CONSTRUCT g_wc2 ON lij02,lij03,lij04,lij05,lij06,lij07,lij08
                 FROM s_lij[1].lij02,s_lij[1].lij03,s_lij[1].lij04,s_lij[1].lij05,
                      s_lij[1].lij06,s_lij[1].lij07,s_lij[1].lij08                
 
         BEFORE CONSTRUCT
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(lij02) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_lij02" 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lij02
                    NEXT FIELD lij02
                    
               WHEN INFIELD(lij03) 
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_lij03"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO lij03
                    NEXT FIELD lij03
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
   
   IF INT_FLAG THEN
      RETURN
   END IF

 
 
   IF g_wc2 = " 1=1" THEN    
      LET g_sql = "SELECT  lii01 FROM lii_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY lii01"
   ELSE                     
      LET g_sql = "SELECT UNIQUE lii_file.lii01 ",
                  "  FROM lii_file, lij_file ",
                  " WHERE lii01 = lij01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lii01"
   END IF
 
   PREPARE t340_prepare FROM g_sql
   DECLARE t340_cs  SCROLL CURSOR WITH HOLD FOR t340_prepare
 
   IF g_wc2 = " 1=1" THEN 
      LET g_sql="SELECT COUNT(*) FROM lii_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lii01) FROM lii_file,lij_file WHERE ",
                "lij01=lii01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t340_precount FROM g_sql
   DECLARE t340_count CURSOR FOR t340_precount
 
END FUNCTION
 
FUNCTION t340_menu()
 
   WHILE TRUE
      CALL t340_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t340_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t340_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t340_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t340_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t340_x()
            END IF
            CALL t340_pic()           
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t340_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t340_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lij),'','')
            END IF 

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t340_confirm()
               CALL t340_pic()
            END IF   
                    
         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
               CALL t340_unconfirm()
               CALL t340_pic()
            END IF
 
         WHEN "related_document" 
              IF cl_chk_act_auth() THEN
                 IF g_lii.lii01 IS NOT NULL THEN
                    LET g_doc.column1 = "lii01"
                    LET g_doc.value1 = g_lii.lii01
                    CALL cl_doc()
                 END IF
               END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t340_v()
               CALL t340_pic()
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t340_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
  

   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lij TO s_lij.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
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

      ON ACTION locale
         CALL cl_dynamic_locale()

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      ON ACTION first
         CALL t340_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t340_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION jump
         CALL t340_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t340_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t340_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")     
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t340_bp_refresh()
   DISPLAY ARRAY g_lij TO s_lij.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
         
   END DISPLAY
END FUNCTION
 
FUNCTION t340_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_lij.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lii.* LIKE lii_file.*      
   LET g_lii01_t = NULL

 
   LET g_lii_t.* = g_lii.*
   LET g_lii_o.* = g_lii.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_lii.liiuser = g_user
      LET g_lii.liioriu = g_user
      LET g_lii.liiorig = g_grup
      LET g_lii.liigrup = g_grup
      LET g_lii.liidate = g_today
      LET g_lii.liiacti = 'Y' 
      LET g_lii.liiconf = 'N'
      LET g_lii.liicrat = g_today 
      LET g_lii.liiplant = g_plant
      LET g_lii.liilegal = g_legal
      LET g_lii.lii02 = g_today
      CALL t340_liiplant()
      CALL t340_liilegal()

      CALL t340_i("a")               
 
      IF INT_FLAG THEN              
         INITIALIZE g_lii.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_lij.clear()
         EXIT WHILE
      END IF
 
      IF cl_null(g_lii.lii01) THEN     
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      
      CALL s_auto_assign_no("alm",g_lii.lii01,g_today,"O8","lii_file","lii01","","","")
           RETURNING li_result,g_lii.lii01
      IF (NOT li_result) THEN  
          ROLLBACK WORK
          CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lii.lii01
 
      INSERT INTO lii_file VALUES (g_lii.*)
 
      IF SQLCA.sqlcode THEN               
         CALL cl_err3("ins","lii_file",g_lii.lii01,"",SQLCA.sqlcode,"","",1) 
         ROLLBACK WORK      
         CONTINUE WHILE
      ELSE
         COMMIT WORK     
         CALL cl_flow_notify(g_lii.lii01,'I')
      END IF
 
      SELECT lii01 INTO g_lii.lii01 FROM lii_file
       WHERE lii01 = g_lii.lii01
      LET g_lii01_t = g_lii.lii01   
      LET g_lii_t.* = g_lii.*
      LET g_lii_o.* = g_lii.*
       
      LET g_rec_b = 0  
      CALL t340_b()   
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t340_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lii.lii01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_lii.* FROM lii_file
    WHERE lii01=g_lii.lii01
   IF g_lii.liiconf = 'X' THEN RETURN END IF   #CHI-C80041
   IF g_lii.liiconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
 
   IF g_lii.liiacti ='N' THEN    
      CALL cl_err(g_lii.lii01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lii01_t = g_lii.lii01
   BEGIN WORK

   OPEN t340_cl USING g_lii.lii01
   IF STATUS THEN
      CALL cl_err("OPEN t340_cl:", STATUS, 1)
      CLOSE t340_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t340_cl INTO g_lii.*           
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lii.lii01,SQLCA.sqlcode,0) 
       CLOSE t340_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t340_show()
 
   WHILE TRUE
      LET g_lii01_t = g_lii.lii01
      LET g_lii_o.* = g_lii.*
      LET g_lii.liimodu = g_user
      LET g_lii.liidate = g_today          
      
 
      CALL t340_i("u")                 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lii.*=g_lii_t.*
         CALL t340_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lii.lii01 != g_lii01_t THEN       
         UPDATE lii_file SET lii01 = g_lii.lii01
          WHERE lii01 = g_lii01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lii_file",g_lii01_t,"",SQLCA.sqlcode,"","lii",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE lii_file SET lii_file.* = g_lii.*
       WHERE lii01 = g_lii_t.lii01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lii_file","","",SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t340_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lii.lii01,'U')
 
   CALL t340_b_fill("1=1")
   CALL t340_bp_refresh()
 
END FUNCTION
 
FUNCTION t340_i(p_cmd)
   DEFINE   p_cmd       LIKE type_file.chr1 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lii.lii01,g_lii.liiplant,g_lii.liilegal,g_lii.lii05,
                   g_lii.lii03,g_lii.lii04,g_lii.lii02,g_lii.liiconf,g_lii.liiconu,
                   g_lii.liicond,g_lii.lii06,g_lii.liicont,g_lii.liiuser,
                   g_lii.liigrup,g_lii.liioriu,g_lii.liimodu,g_lii.liidate,g_lii.liiorig,
                   g_lii.liiacti,g_lii.liicrat
 
   CALL cl_set_head_visible("","YES")        
   INPUT BY NAME   g_lii.lii01,g_lii.liiplant,g_lii.liilegal,g_lii.lii05,
                   g_lii.lii03,g_lii.lii04,g_lii.lii02,g_lii.liiconf,g_lii.liiconu,
                   g_lii.liicond,g_lii.lii06,g_lii.liicont,g_lii.liiuser,
                   g_lii.liigrup,g_lii.liioriu,g_lii.liimodu,g_lii.liidate,g_lii.liiorig,
                   g_lii.liiacti,g_lii.liicrat
       WITHOUT DEFAULTS
 
     BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t340_set_entry(p_cmd)
         CALL t340_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("lii01")
 
      AFTER FIELD lii01
       DISPLAY "AFTER FIELD lii01"
         IF g_lii.lii01 IS NOT NULL THEN
            IF p_cmd = "a" 
                      OR (p_cmd = "u" AND g_lii.lii01 != g_lii01_t) THEN
                         CALL s_check_no("alm",g_lii.lii01,g_lii_t.lii01,"O8","lii_file","lii01,liiplant","")
                            RETURNING li_result,g_lii.lii01
                         IF (NOT li_result) THEN
                            LET g_lii.lii01 = g_lii_t.lii01
                            NEXT FIELD lii01
                         END IF
            END IF
         END IF


      AFTER FIELD lii03
         IF g_lii.lii03 IS NOT NULL THEN
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               CALL t340_lii03('d') 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lii.lii03,g_errno,0)
                  LET g_lii.lii03 = g_lii_t.lii03
                  NEXT FIELD lii03
               END IF
            END IF
         ELSE
            IF g_lii.lii04 IS NOT NULL THEN
               CALL cl_err('','alm-907',0)
               LET g_lii.lii03 = g_lii_t.lii03
            END IF
            DISPLAY '' TO FORMONLY.lmb03
         END IF
         

      AFTER FIELD lii04
         IF g_lii.lii04 IS NOT NULL THEN
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF  cl_null(g_lii.lii03) THEN
                   CALL cl_err('','alm1077',1)
                   LET g_lii.lii04 = NULL 
                   NEXT FIELD lii03
               END IF
               CALL t340_lii04('d') 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lii.lii04,g_errno,0)
                  LET g_lii.lii04 = g_lii_t.lii04
                  NEXT FIELD lii04
               END IF
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.lmc04
         END IF

 
      AFTER FIELD lii05
        IF NOT cl_null(g_lii.lii05) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lii_t.lii05 <> g_lii.lii05) THEN
               CALL t340_lii05('d') 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lii.lii05,g_errno,0)
                  LET g_lii.lii05 = g_lii_t.lii05
                  DISPLAY BY NAME g_lii.lii05
                  NEXT FIELD lii05
               END IF
            END IF
         END IF
          
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF       
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lii01)
               LET g_t1=s_get_doc_no(g_lii.lii01)
               CALL q_oay(FALSE,FALSE,g_t1,'O8','alm') RETURNING g_t1
               LET g_lii.lii01 = g_t1
               DISPLAY BY NAME g_lii.lii01
               NEXT FIELD lii01
         
            WHEN INFIELD(lii05) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_tqa"
               LET g_qryparam.default1 = g_lii.lii05
               LET g_qryparam.arg1 = '30'
               CALL cl_create_qry() RETURNING g_lii.lii05
               DISPLAY BY NAME g_lii.lii05
               CALL t340_lii05('d')
               NEXT FIELD lii05
 
            WHEN INFIELD(lii03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lii03i"
               LET g_qryparam.default1 = g_lii.lii03
               LET g_qryparam.where = " lmb06 = 'Y' AND lmbstore = '",g_lii.liiplant,"'"
               CALL cl_create_qry() RETURNING g_lii.lii03
               DISPLAY BY NAME g_lii.lii03
               CALL t340_lii03('d')
               NEXT FIELD lii03

            WHEN INFIELD(lii04) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lii04i"
               LET g_qryparam.default1 = g_lii.lii04
               LET g_qryparam.where = " lmc02 = '",g_lii.lii03,"' AND lmc07 = 'Y' AND lmcstore = '",g_lii.liiplant,"'"
               CALL cl_create_qry() RETURNING g_lii.lii04
               DISPLAY BY NAME g_lii.lii04
               CALL t340_lii04('d')
               NEXT FIELD lii04
               
            OTHERWISE EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about        
          CALL cl_about()    
 
       ON ACTION help       
          CALL cl_show_help()
 
   END INPUT
 
END FUNCTION

FUNCTION t340_liiplant()
  DEFINE l_rtz13          LIKE rtz_file.rtz13
     
  SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_lii.liiplant
  DISPLAY l_rtz13 TO FORMONLY.rtz13
END FUNCTION

FUNCTION t340_liilegal()
  DEFINE l_azt02          LIKE azt_file.azt02

  SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lii.liilegal
  DISPLAY l_azt02 TO FORMONLY.azt02
END FUNCTION
FUNCTION t340_lii05(p_cmd)  
   DEFINE l_tqa02         LIKE tqa_file.tqa02,
          l_tqaacti       LIKE tqa_file.tqaacti,
          p_cmd           LIKE type_file.chr1  
 
   LET g_errno = ' '
   SELECT tqa02,tqaacti 
     INTO l_tqa02,l_tqaacti  
     FROM tqa_file
    WHERE tqa01 = g_lii.lii05
      AND tqa03 = '30'
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm1062'
                                  LET l_tqa02 = NULL
        WHEN l_tqaacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' OR p_cmd = 'a' THEN
      DISPLAY l_tqa02 TO FORMONLY.tqa02
   END IF
END FUNCTION
 
FUNCTION t340_lii03(p_cmd)  
    DEFINE  l_lmb03        LIKE lmb_file.lmb03,
            l_lmb06        LIKE lmb_file.lmb06,
            l_cnt          LIKE type_file.num5,
            p_cmd          LIKE type_file.chr1  
 
    LET g_errno = " "
    SELECT lmb03,lmb06 INTO l_lmb03,l_lmb06
      FROM lmb_file 
     WHERE lmb02 = g_lii.lii03   
       AND lmbstore = g_lii.liiplant
    CASE WHEN SQLCA.SQLCODE = 100           LET g_errno = 'alm1064'
                                            LET l_lmb03 = NULL 
         WHEN l_lmb06 = 'N'                 LET g_errno = '9028'
         OTHERWISE                          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) AND NOT cl_null(g_lii.lii04) THEN
       SELECT COUNT(*) INTO l_cnt FROM lmc_file
        WHERE lmcstore = g_lii.liiplant
          AND lmc02 = g_lii.lii03
          AND lmc03 = g_lii.lii04
       IF l_cnt = 0 THEN
          LET g_errno = 'alm-907'
       END IF
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' OR p_cmd = 'a' THEN
       DISPLAY l_lmb03 TO FORMONLY.lmb03
    END IF
END FUNCTION

FUNCTION t340_lii04(p_cmd)  
    DEFINE  l_lmc04        LIKE lmc_file.lmc04,
            l_lmc07        LIKE lmc_file.lmc07,
            p_cmd          LIKE type_file.chr1  
 
    LET g_errno = " "
    SELECT lmc04,lmc07 INTO l_lmc04,l_lmc07
      FROM lmc_file 
     WHERE lmc02 = g_lii.lii03
       AND lmc03 = g_lii.lii04  
       AND lmcstore = g_lii.liiplant 
    CASE WHEN SQLCA.SQLCODE = 100           LET g_errno = 'alm-907'
                                            LET l_lmc04 = ' ' 
         WHEN l_lmc07 = 'N'                 LET g_errno = '9028'
         OTHERWISE                          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    IF cl_null(g_lii.lii04) THEN
       LET l_lmc04 = NULL
       DISPLAY l_lmc04 TO FORMONLY.lmc04
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' OR p_cmd = 'a' THEN
       DISPLAY l_lmc04 TO FORMONLY.lmc04
    END IF
END FUNCTION
 
FUNCTION t340_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lij.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t340_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lii.* TO NULL
      LET g_lii01_t = NULL
      LET g_wc = NULL
      RETURN
   END IF
 
   OPEN t340_cs                           
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lii.* TO NULL
      LET g_lii01_t = NULL
      LET g_wc = NULL
   ELSE
      OPEN t340_count
      FETCH t340_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t340_fetch('F')                  
   END IF
 
END FUNCTION
 
FUNCTION t340_fetch(p_flag)
   DEFINE  p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t340_cs INTO g_lii.lii01
      WHEN 'P' FETCH PREVIOUS t340_cs INTO g_lii.lii01
      WHEN 'F' FETCH FIRST    t340_cs INTO g_lii.lii01
      WHEN 'L' FETCH LAST     t340_cs INTO g_lii.lii01
      WHEN '/'
            IF (NOT g_no_ask) THEN      
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
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t340_cs INTO g_lii.lii01
            LET g_no_ask = FALSE     
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lii.lii01,SQLCA.sqlcode,0)
      INITIALIZE g_lii.* TO NULL        
      LET g_lii01_t = NULL       
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
 
   SELECT * INTO g_lii.* FROM lii_file WHERE lii01 = g_lii.lii01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lii_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_lii.* TO NULL
      LET g_lii01_t = NULL
      RETURN
   END IF
   
   LET g_data_owner = g_lii.liiuser      
   LET g_data_group = g_lii.liigrup      
   LET g_data_plant = g_lii.liiplant
 
   CALL t340_show()
 
END FUNCTION
 

FUNCTION t340_show()
    
   LET g_lii_t.* = g_lii.*                
   LET g_lii_o.* = g_lii.*                
   DISPLAY BY NAME g_lii.lii01,g_lii.liiplant,g_lii.liilegal,g_lii.lii05,
                   g_lii.lii03,g_lii.lii04,g_lii.lii02,g_lii.liiconf,g_lii.liiconu,
                   g_lii.liicond,g_lii.lii06,g_lii.liicont,g_lii.liiuser,
                   g_lii.liigrup,g_lii.liioriu,g_lii.liimodu,g_lii.liidate,g_lii.liiorig,
                   g_lii.liiacti,g_lii.liicrat
                             
   CALL t340_lii05('d')
   CALL t340_lii03('d')
   CALL t340_lii04('d')   
   CALL t340_liiplant()
   CALL t340_liilegal()
 
   CALL t340_b_fill(g_wc2)                 
   CALL t340_pic() 
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t340_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lii.lii01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lii.liiconf = 'Y' THEN
       CALL cl_err('','alm1061',0)
       RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t340_cl USING g_lii.lii01
   IF STATUS THEN
      CALL cl_err("OPEN t340_cl:", STATUS, 1)
      CLOSE t340_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t340_cl INTO g_lii.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lii.lii01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t340_show()
 
   IF cl_exp(0,0,g_lii.liiacti) THEN                   
      LET g_chr=g_lii.liiacti
      IF g_lii.liiacti='Y' THEN
         LET g_lii.liiacti='N'
      ELSE
         LET g_lii.liiacti='Y'
      END IF
 
      UPDATE lii_file SET  liiacti=g_lii.liiacti,
                           liimodu=g_user,
                           liidate=g_today
       WHERE lii01=g_lii.lii01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lii_file",g_lii.lii01,"",SQLCA.sqlcode,"","",1)  
         LET g_lii.liiacti=g_lii_t.liiacti
      END IF
   END IF
 
   CLOSE t340_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lii.lii01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT liicti,liimodu,liidate
     INTO g_lii.liiacti,g_lii.liimodu,g_lii.liidate FROM lii_file
    WHERE lii01=g_lii.lii01
   DISPLAY BY NAME g_lii.liiacti,g_lii.liimodu,g_lii.liidate
 
END FUNCTION
 
FUNCTION t340_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lii.lii01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   SELECT * INTO g_lii.* FROM lii_file
    WHERE lii01=g_lii.lii01
   IF g_lii.liiconf = 'X' THEN RETURN END IF   #CHI-C80041
   IF g_lii.liiconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t340_cl USING g_lii.lii01
   IF STATUS THEN
      CALL cl_err("OPEN t340_cl:", STATUS, 1)
      CLOSE t340_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t340_cl INTO g_lii.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lii.lii01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t340_show()
 
   IF cl_delh(0,0) THEN                   
      INITIALIZE g_doc.* TO NULL          
      LET g_doc.column1 = "lii01"         
      LET g_doc.value1 = g_lii.lii01      
      CALL cl_del_doc()                
      DELETE FROM lii_file WHERE lii01 = g_lii.lii01
      DELETE FROM lij_file WHERE lij01 = g_lii.lii01
      CLEAR FORM
      CALL g_lij.clear()
      OPEN t340_count
      FETCH t340_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t340_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t340_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      
         CALL t340_fetch('/')
      END IF
   END IF
 
   CLOSE t340_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lii.lii01,'D')
END FUNCTION
 

FUNCTION t340_b()
DEFINE   l_n             LIKE type_file.num5,        
         l_ac_t          LIKE type_file.num5,        
         l_lock_sw       LIKE type_file.chr1,                
         p_cmd           LIKE type_file.chr1,                
         l_allow_insert  LIKE type_file.num5,               
         l_allow_delete  LIKE type_file.num5,
         l_n1            LIKE type_file.num5
DEFINE   l_lij05         LIKE lij_file.lij05     #TQC-C20330 add
         

 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
    IF g_lii.liiconf = 'X' THEN RETURN END IF   #CHI-C80041
    IF g_lii.liiconf = 'Y' THEN
       CALL cl_err('','alm1061',0)
       RETURN
    END IF

    IF g_lii.lii01 IS NULL THEN
       RETURN
    END IF 
 
    SELECT * INTO g_lii.* FROM lii_file
     WHERE lii01=g_lii.lii01
 
    IF g_lii.liiacti ='N' THEN    
       CALL cl_err(g_lii.lii01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT lij02,'','','',lij03,'',lij04,lij05,lij06,lij07,lij08",
                       "  FROM lij_file",
                       "  WHERE lij01=? AND lij02=? FOR UPDATE"  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t340_bcl CURSOR FROM g_forupd_sql      
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_lij WITHOUT DEFAULTS FROM s_lij.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
              LET l_ac = 1
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t340_cl USING g_lii.lii01
           IF STATUS THEN
              CALL cl_err("OPEN t340_cl:", STATUS, 1)
              CLOSE t340_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t340_cl INTO g_lii.*            
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lii.lii01,SQLCA.sqlcode,0)      
              CLOSE t340_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lij_t.* = g_lij[l_ac].*  
              LET g_lij_o.* = g_lij[l_ac].*  
              OPEN t340_bcl USING g_lii.lii01,g_lij_t.lij02
              IF STATUS THEN
                 CALL cl_err("OPEN t340_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t340_bcl INTO g_lij[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lij_t.lij02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF

                 LET g_errno = ' ' 
                 SELECT oaj02,oaj031 INTO g_lij[l_ac].oaj02,g_lij[l_ac].oaj031 FROM oaj_file
                  WHERE oaj01 = g_lij[l_ac].lij02 AND oajacti = 'Y'
                  
                 SELECT lnj02 INTO g_lij[l_ac].lnj02 FROM lnj_file
                  WHERE lnj01 = g_lij[l_ac].oaj031 AND lnj03 = 'Y'
                  
                 SELECT lnr02 INTO g_lij[l_ac].lnr02 FROM lnr_file
                  WHERE lnr01 = g_lij[l_ac].lij03 AND lnr04 = 'Y'
              END IF
              CALL cl_show_fld_cont()     
              CALL t340_set_entry_b(p_cmd)    
              CALL t340_set_no_entry_b(p_cmd) 
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lij[l_ac].* TO NULL      
           LET g_lij[l_ac].lij06 = 'Y'          
           LET g_lij_t.* = g_lij[l_ac].*         
           LET g_lij_o.* = g_lij[l_ac].*         
           CALL cl_show_fld_cont()         
           CALL t340_set_entry_b(p_cmd)    
           CALL t340_set_no_entry_b(p_cmd) 
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO lij_file(lij01,lij02,lij03,lij04,lij05,lij06,lij07,lij08,lijplant,lijlegal)
                         VALUES(g_lii.lii01,g_lij[l_ac].lij02,g_lij[l_ac].lij03,g_lij[l_ac].lij04,
                                g_lij[l_ac].lij05,g_lij[l_ac].lij06,g_lij[l_ac].lij07,g_lij[l_ac].lij08,g_lii.liiplant,g_lii.liilegal)                      
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lij_file",g_lii.lii01,g_lij[l_ac].lij02,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        AFTER FIELD lij02                       
           IF NOT cl_null(g_lij[l_ac].lij02) THEN
              IF g_lij[l_ac].lij02 != g_lij_t.lij02 OR g_lij_t.lij02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM lij_file
                  WHERE lij01 = g_lii.lii01
                    AND lij02 = g_lij[l_ac].lij02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lij[l_ac].lij02 = g_lij_t.lij02
                    NEXT FIELD lij02
                 END IF
                 CALL t340_lij02(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lij[l_ac].lij02 = g_lij_t.lij02
                    LET g_lij[l_ac].oaj02 = g_lij_t.oaj02
                    LET g_lij[l_ac].oaj031 = g_lij_t.oaj031
                    LET g_lij[l_ac].lnj02 = g_lij_t.lnj02
                    LET g_lij[l_ac].lij05 = g_lij_t.lij05
                    NEXT FIELD lij02
                 END IF
                 CALL t340_lij03_1()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('lij05:',g_errno,0)
                    NEXT FIELD lij05
                 END IF
                 IF NOT cl_null(g_lij[l_ac].oaj031) THEN
                    CALL t340_oaj031(p_cmd)         
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_lij[l_ac].lij02 = g_lij_t.lij02
                       LET g_lij[l_ac].oaj02 = g_lij_t.oaj02
                       LET g_lij[l_ac].oaj031 = g_lij_t.oaj031
                       LET g_lij[l_ac].lnj02 = g_lij_t.lnj02
                       NEXT FIELD lij02
                    END IF
                 END IF
                 #TQC-C20330----mark---str---- 
                 #SELECT COUNT(*) INTO l_n1 FROM lij_file
                 # WHERE lijplant = g_lii.liiplant
                 #   AND lij02 = g_lij[l_ac].lij02 
                 #   AND lij05 <> g_lij[l_ac].lij05
                 #IF l_n1 > 0 THEN
                 #   CALL cl_err('lij05:','alm1452',0)
                 #   LET g_lij[l_ac].lij05 = NULL
                 #END IF
                 #TQC-C20330----mark---end----
                 #TQC-C20330----add----str----
                 CALL t340_lij05(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('lij05:',g_errno,0)
                    LET g_lij[l_ac].lij05 = NULL
                 END IF
                 #TQC-C20330----add----end----
              END IF
           END IF
            
            
 
      AFTER FIELD lij03                       
         IF NOT cl_null(g_lij[l_ac].lij03) THEN
            CALL t340_lij03(p_cmd)   
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('lij03:',g_errno,0)
               LET g_lij[l_ac].lij03 = g_lij_t.lij03
               LET g_lij[l_ac].lnr02 = g_lij_t.lnr02
               NEXT FIELD lij03
            END IF 
            CALL t340_lij03_1()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('lij03:',g_errno,0)
               LET g_lij[l_ac].lij03 = g_lij_t.lij03
               LET g_lij[l_ac].lnr02 = g_lij_t.lnr02
               NEXT FIELD lij03
            END IF
            LET g_lij_t.lij03 = g_lij[l_ac].lij03
            LET g_lij_t.lnr02 = g_lij[l_ac].lnr02
         END IF

       AFTER FIELD lij05                       
         IF NOT cl_null(g_lij[l_ac].lij05) THEN
            CALL t340_lij03_1()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('lij05:',g_errno,0)
               IF NOT cl_null(g_lij_t.lij05) THEN
                  LET g_lij[l_ac].lij05 = g_lij_t.lij05
               END IF
               NEXT FIELD lij05
            END IF
            IF NOT cl_null(g_lij[l_ac].lij02) THEN
               #TQC-C20330----mark---str----
               #SELECT COUNT(*) INTO l_n1 FROM lij_file
               # WHERE lijplant = g_lii.liiplant 
               #   AND lij02 = g_lij[l_ac].lij02
               #   AND lij05 <> g_lij[l_ac].lij05
               #IF l_n1 > 0 THEN
               #   CALL cl_err('lij05:','alm1452',0)
               #   LET g_lij[l_ac].lij05 = g_lij_t.lij05
               #   NEXT FIELD lij05
               #END IF
               #TQC-C20330----mark---end----
               #TQC-C20330----add----str----
               CALL t340_lij05(p_cmd)    
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('lij05:',g_errno,0)
                  LET g_lij[l_ac].lij05 = g_lij_t.lij05
                  NEXT FIELD lij05
               END IF
               #TQC-C20330----add----end----
            END IF
         END IF

      AFTER FIELD lij08                      
         IF NOT cl_null(g_lij[l_ac].lij08) THEN
            IF g_lij[l_ac].lij08 <= 0 OR g_lij[l_ac].lij08 >31 THEN
               CALL cl_err('lij08:','alm1076',0)
               LET g_lij[l_ac].lij08 = g_lij_t.lij08
               NEXT FIELD lij08
            END IF
            LET g_lij_t.lij08 = g_lij[l_ac].lij08
         END IF
         
       BEFORE DELETE                      
           DISPLAY "BEFORE DELETE"
           IF g_lij_t.lij02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lij_file
               WHERE lij01 = g_lii.lii01
                 AND lij02 = g_lij_t.lij02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lij_file",g_lii.lii01,g_lij_t.lij02,SQLCA.sqlcode,"","",1)  
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
              LET g_lij[l_ac].* = g_lij_t.*
              CLOSE t340_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lij[l_ac].lij02,-263,1)
              LET g_lij[l_ac].* = g_lij_t.*
           ELSE
              UPDATE lij_file SET   lij02=g_lij[l_ac].lij02,
                                    lij03=g_lij[l_ac].lij03,
                                    lij04=g_lij[l_ac].lij04,
                                    lij05=g_lij[l_ac].lij05,
                                    lij06=g_lij[l_ac].lij06,
                                    lij07=g_lij[l_ac].lij07, 
                                    lij08=g_lij[l_ac].lij08 
               WHERE lij01=g_lii.lii01
                 AND lij02=g_lij_t.lij02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lij_file",g_lii.lii01,g_lij[l_ac].lij02,SQLCA.sqlcode,"","",1)  
                 LET g_lij[l_ac].* = g_lij_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
        
        
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lij[l_ac].* = g_lij_t.*
              END IF
              CLOSE t340_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t340_bcl
           COMMIT WORK
 
           ON ACTION CONTROLO                        
              IF INFIELD(lij02) AND l_ac > 1 THEN
                 LET g_lij[l_ac].* = g_lij[l_ac-1].*
                 NEXT FIELD lij02
              END IF
 
           ON ACTION CONTROLR
              CALL cl_show_req_fields()
 
           ON ACTION CONTROLG
              CALL cl_cmdask()
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(lij02) 
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_lij02i"
                      LET g_qryparam.default1 = g_lij[l_ac].lij02
                      CALL cl_create_qry() RETURNING g_lij[l_ac].lij02
                      DISPLAY BY NAME g_lij[l_ac].lij02             
                      IF NOT cl_null(g_lij[l_ac].lij02) THEN
                         CALL t340_lij02(p_cmd)
                         CALL t340_oaj031('d')
                      END IF
                      NEXT FIELD lij02

                  WHEN INFIELD(lij03) 
                      CALL cl_init_qry_var()
                      LET g_qryparam.form ="q_lij03i"
                      LET g_qryparam.default1 = g_lij[l_ac].lij03
                      IF g_lij[l_ac].lij05 = '1' THEN
                         LET g_qryparam.where = "lnr04='Y' AND lnr03='0'" 
                      END IF
                      CALL cl_create_qry() RETURNING g_lij[l_ac].lij03
                      DISPLAY BY NAME g_lij[l_ac].lij03             
                      IF NOT cl_null(g_lij[l_ac].lij03) THEN
                         CALL t340_lij03('d')
                      END IF
                      NEXT FIELD lij03
                 
                OTHERWISE EXIT CASE
              END CASE
 
          ON ACTION CONTROLF
             CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
             CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
          ON ACTION about         
             CALL cl_about()      
 
          ON ACTION HELP          
             CALL cl_show_help()  
  
          ON ACTION controls                           
             CALL cl_set_head_visible("","AUTO")       
    END INPUT
 
    LET g_lii.liimodu = g_user
    LET g_lii.liidate = g_today
    UPDATE lii_file SET liimodu = g_lii.liimodu,liidate = g_lii.liidate
     WHERE lii01 = g_lii.lii01
    DISPLAY BY NAME g_lii.liimodu,g_lii.liidate
 
    CLOSE t340_bcl
    COMMIT WORK
#   CALL t340_delall()  #CHI-C30002 mark
    CALL t340_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t340_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lii.lii01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lii_file ",
                  "  WHERE lii01 LIKE '",l_slip,"%' ",
                  "    AND lii01 > '",g_lii.lii01,"'"
      PREPARE t340_pb1 FROM l_sql 
      EXECUTE t340_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t340_v()
         CALL t340_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lii_file WHERE lii01 = g_lii.lii01
         INITIALIZE g_lii.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t340_delall()

#  SELECT COUNT(*) INTO g_cnt FROM lij_file
#   WHERE lij01 = g_lii.lii01 AND lijplant = g_lii.liiplant

#  IF g_cnt = 0 THEN                   
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM lii_file WHERE lii01 = g_lii.lii01 AND liiplant = g_lii.liiplant
#  END IF

#END FUNCTION
#CHI-C30002 -------- mark -------- end

 
FUNCTION t340_lij02(p_cmd)  
   DEFINE l_oaj02    LIKE oaj_file.oaj02,
          l_oaj031   LIKE oaj_file.oaj031,
          l_oaj07    LIKE oaj_file.oaj07,
          l_oajacti  LIKE oaj_file.oajacti,
          l_oaj05    LIKE oaj_file.oaj05,
          p_cmd      LIKE type_file.chr1    

   LET g_errno = ' '
   #SELECT oaj02,oaj031,oaj07,oajacti INTO l_oaj02,l_oaj031,l_oaj07,l_oajacti                 #FUN-C30072 mark
   SELECT oaj02,oaj031,oaj07,oajacti,oaj05 INTO l_oaj02,l_oaj031,l_oaj07,l_oajacti,l_oaj05    #FUN-C30072 add
     FROM oaj_file WHERE oaj01 = g_lij[l_ac].lij02

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'axm-360'
                                  LET l_oaj02 = NULL
                                  LET l_oaj031 = NULL
                                  LET l_oaj07 = NULL
        WHEN l_oajacti='N'        LET g_errno = '9028'
        WHEN l_oaj05 = '10'       LET g_errno = 'alm1618'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' OR p_cmd = 'a' THEN 
      LET g_lij[l_ac].oaj02 = l_oaj02
      LET g_lij[l_ac].oaj031 = l_oaj031
      LET g_lij[l_ac].lij05 = l_oaj07
      DISPLAY BY NAME g_lij[l_ac].oaj02
      DISPLAY BY NAME g_lij[l_ac].oaj031
      DISPLAY BY NAME g_lij[l_ac].lij05
   END IF
   IF p_cmd = 'u' AND g_lij[l_ac].lij02 = g_lij_t.lij02 THEN
      LET g_lij[l_ac].lij05 = g_lij_t.lij05
      DISPLAY BY NAME g_lij[l_ac].lij05
   END IF
 
END FUNCTION

FUNCTION t340_oaj031(p_cmd)  
   DEFINE l_lnj02    LIKE lnj_file.lnj02,
          l_lnj03    LIKE lnj_file.lnj03,
          p_cmd      LIKE type_file.chr1    

   LET g_errno = ' '
   SELECT lnj02,lnj03 INTO l_lnj02,l_lnj03
     FROM lnj_file WHERE lnj01 = g_lij[l_ac].oaj031

   CASE WHEN SQLCA.SQLCODE = 100          LET g_errno = 'alm-073'
                                          LET l_lnj02 = NULL
        WHEN  l_lnj03='N'                 LET g_errno = '9028'
        OTHERWISE                         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' OR p_cmd = 'a' THEN 
      LET g_lij[l_ac].lnj02 = l_lnj02
      DISPLAY BY NAME g_lij[l_ac].lnj02
   END IF
 
END FUNCTION

FUNCTION t340_lij03(p_cmd)
   DEFINE l_lnr02    LIKE lnr_file.lnr02,
          l_lnr04    LIKE lnr_file.lnr04,
          p_cmd      LIKE type_file.chr1 

   LET g_errno = ' '
   SELECT lnr02,lnr04 INTO l_lnr02,l_lnr04
     FROM lnr_file WHERE lnr01 = g_lij[l_ac].lij03

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm1066' 
                                  LET l_lnr02 = NULL
        WHEN l_lnr04='N'          LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' OR p_cmd = 'a' THEN 
      LET g_lij[l_ac].lnr02 = l_lnr02
      DISPLAY BY NAME g_lij[l_ac].lnr02
   END IF
  
END FUNCTION

#TQC-C20330----add----str----
FUNCTION t340_lij05(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_n        LIKE type_file.num5  
 
   LET g_errno = ' '

   IF p_cmd = 'a' THEN
      SELECT COUNT(*) INTO l_n FROM lij_file
       WHERE lijplant = g_lii.liiplant
         AND lij02 = g_lij[l_ac].lij02
         AND lij05 <> g_lij[l_ac].lij05
   END IF
   IF p_cmd = 'u' THEN
      SELECT COUNT(*) INTO l_n FROM lij_file
       WHERE lijplant = g_lii.liiplant
         AND lij02 = g_lij[l_ac].lij02
         AND lij05 <> g_lij[l_ac].lij05
         AND lij05 <> g_lij_t.lij05
   END IF
   IF l_n > 0 THEN
      LET g_errno = 'alm1452'
   END IF
END FUNCTION
#TQC-C20330----add----end----

FUNCTION t340_lij03_1()
   DEFINE l_lnr03    LIKE lnr_file.lnr03

   LET g_errno = ' '
   SELECT lnr03 INTO l_lnr03
     FROM lnr_file WHERE g_lij[l_ac].lij03 = lnr01 

   IF g_lij[l_ac].lij05 = '1' AND l_lnr03 > 0 THEN
      LET g_errno = 'alm1074'
   END IF
END FUNCTION

FUNCTION t340_b_fill(p_wc2)
DEFINE p_wc2           STRING
DEFINE l_sql           STRING
 
   LET l_sql = "SELECT lij02,'','','',lij03,'',lij04,lij05,lij06,lij07,lij08",
               "  FROM lij_file",   
               " WHERE lij01 ='",g_lii.lii01,"'"
 
   IF NOT cl_null(p_wc2) THEN
      LET l_sql=l_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET l_sql=l_sql CLIPPED," ORDER BY lij02,lij03 "
   DISPLAY l_sql
 
   PREPARE t340_pb FROM l_sql
   DECLARE lij_cs CURSOR FOR t340_pb
 
   CALL g_lij.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH lij_cs INTO g_lij[g_cnt].*   
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT oaj02,oaj031 INTO g_lij[g_cnt].oaj02,g_lij[g_cnt].oaj031
        FROM oaj_file WHERE oaj01 = g_lij[g_cnt].lij02 AND oajacti = 'Y'
 
      SELECT lnj02 INTO g_lij[g_cnt].lnj02
        FROM lnj_file WHERE lnj01 = g_lij[g_cnt].oaj031 AND lnj03 = 'Y'

      SELECT lnr02 INTO g_lij[g_cnt].lnr02
        FROM lnr_file WHERE lnr01 = g_lij[g_cnt].lij03 AND lnr04 = 'Y'

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_lij.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
   CALL t340_bp_refresh()
 
END FUNCTION
 
FUNCTION t340_copy()
 DEFINE l_newno   LIKE lii_file.lii01,
        l_oldno   LIKE lii_file.lii01 

   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lii.lii01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t340_set_entry('a')
 
   CALL cl_set_head_visible("","YES")     
   INPUT  l_newno FROM lii01 
     BEFORE INPUT
          CALL cl_set_docno_format("lii01")

   
     AFTER FIELD lii01
         CALL s_check_no("alm",l_newno,g_lii_t.lii01,"O8","lii_file","lii01,liiplant","") RETURNING li_result,l_newno
         DISPLAY l_newno TO lii01
         IF (NOT li_result) THEN
            LET g_lii.lii01 = g_lii_o.lii01
            NEXT FIELD lii01
         END IF
         CALL s_auto_assign_no("alm",l_newno,g_today,"O8","lii_file","lii01","","","") RETURNING li_result,l_newno
         DISPLAY l_newno TO lii01
         IF (NOT li_result) THEN
            LET g_lii.lii01 = g_lii_o.lii01
            NEXT FIELD lii01
         END IF

     ON ACTION controlp
         CASE
            WHEN INFIELD(lii01)
               LET g_t1=s_get_doc_no(l_newno)
               CALL q_oay(FALSE,FALSE,g_t1,'O8','alm') RETURNING g_t1
               LET l_newno = g_t1
               DISPLAY BY NAME l_newno
               NEXT FIELD lii01
            OTHERWISE EXIT CASE
         END CASE
 
     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
     ON ACTION controlg      
        CALL cl_cmdask()     
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_lii.lii01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM lii_file         
       WHERE lii01=g_lii.lii01
       INTO TEMP y
 
   UPDATE y
       SET lii01=l_newno,    
           liiplant=g_plant,  
           liiuser=g_user,   
           liigrup=g_grup,   
           liimodu=NULL,     
           liidate=g_today,  
           liiacti='Y',  
           liiconf='N',    
           liicond=NULL,
           liicont=NULL,
           liiconu=NULL
   INSERT INTO lii_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","lii_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM lij_file         
       WHERE lij01=g_lii.lii01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET lij01=l_newno
 
   INSERT INTO lij_file
      SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","lij_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK 
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_lii.lii01
   SELECT lii_file.* INTO g_lii.* FROM lii_file WHERE lii01 = l_newno
   CALL t340_u()
   CALL t340_b()
   #SELECT lii_file.* INTO g_lii.* FROM lii_file WHERE lii01 = l_oldno  #FUN-C30027
   #CALL t340_show()  #FUN-C30027
 
END FUNCTION
 
 
FUNCTION t340_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lii01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t340_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lii01",FALSE)
    END IF

END FUNCTION

FUNCTION t340_confirm()
  DEFINE l_liicond         LIKE lii_file.liicond 
  DEFINE l_liiconu         LIKE lii_file.liiconu
  DEFINE l_liimodu         LIKE lii_file.liimodu
  DEFINE l_liidate         LIKE lii_file.liidate
  DEFINE l_liicont         LIKE lii_file.liicont


   IF cl_null(g_lii.lii01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 -------------- add ---------------- begin
   IF g_lii.liiconf = 'X' THEN RETURN END IF   #CHI-C80041
   IF g_lii.liiconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
   IF g_lii.liiacti = 'N' THEN
      CALL cl_err('','alm1067',0)
      RETURN
   END IF
   IF NOT cl_confirm("alm1070") THEN RETURN END IF
#CHI-C30107 -------------- add ---------------- end
   SELECT lii_file.* INTO g_lii.* FROM lii_file
    WHERE lii01 = g_lii.lii01
   IF g_lii.liiconf = 'X' THEN RETURN END IF   #CHI-C80041
   IF g_lii.liiconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
   IF g_lii.liiacti = 'N' THEN
      CALL cl_err('','alm1067',0)
      RETURN
   END IF
 

   LET l_liicond = g_lii.liicond
   LET l_liiconu = g_lii.liiconu
   LET l_liimodu = g_lii.liimodu
   LET l_liidate = g_lii.liidate   
   LET l_liicont = g_lii.liicont  

   IF g_lii.liiacti ='N' THEN
      CALL cl_err(g_lii.lii01,'alm1068',1)
      RETURN
   END IF
   IF g_lii.liiconf = 'X' THEN RETURN END IF   #CHI-C80041
   IF g_lii.liiconf = 'Y' THEN
      CALL cl_err(g_lii.lii01,'alm1069',1)
      RETURN
   END IF
   
   BEGIN WORK
 
   OPEN t340_cl USING g_lii.lii01
   IF STATUS THEN
      CALL cl_err("OPEN t340_cl:",STATUS,0)
      CLOSE t340_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t340_cl INTO g_lii.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lii.lii01,SQLCA.sqlcode,0)
      CLOSE t340_cl
      ROLLBACK WORK
      RETURN
   END IF
    
#  IF NOT cl_confirm("alm1070") THEN #CHI-C30107 mark
#      RETURN                         #CHI-C30107 mark
#  ELSE                               #CHI-C30107 mark
      LET g_lii.liiconf = 'Y'
      LET g_lii.liicond = g_today 
      LET g_lii.liiconu = g_user 
      LET g_lii.liimodu = g_user
      LET g_lii.liidate = g_today 
      LET g_lii.liicont = TIME 
      UPDATE lii_file
         SET liiconf = 'Y',
             liicond = g_lii.liicond,
             liiconu = g_lii.liiconu,
             liimodu = g_lii.liimodu,
             liidate = g_lii.liidate,
             liicont = g_lii.liicont
       WHERE lii01 = g_lii.lii01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lii:',SQLCA.SQLCODE,0)
         LET g_lii.liiconf = 'N'
         LET g_lii.liicond = l_liicond
         LET g_lii.liiconu = l_liiconu
         LET g_lii.liimodu = l_liimodu
         LET g_lii.liidate = l_liidate
         LET g_lii.liidate = l_liicont 
         DISPLAY BY NAME g_lii.liiconf,g_lii.liicond,g_lii.liiconu,g_lii.liimodu,g_lii.liidate,g_lii.liicont
         RETURN
       ELSE
         DISPLAY BY NAME g_lii.liiconf,g_lii.liicond,g_lii.liiconu,g_lii.liimodu,g_lii.liidate,g_lii.liicont
       END IF
#   END IF   #CHI-C30107 mark
    
   CLOSE t340_cl
   COMMIT WORK  
   CALL t340_pic() 
END FUNCTION

FUNCTION t340_pic()
   CASE g_lii.liiconf
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void    = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void    = ''
      WHEN 'X'  LET g_confirm = 'N'  #CHI-C80041
                LET g_void    = 'Y'  #CHI-C80041
      OTHERWISE LET g_confirm = ''
                LET g_void    = ''
   END CASE

   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lii.liiacti)
END FUNCTION

FUNCTION t340_unconfirm()
DEFINE l_n      LIKE type_file.num5

   IF cl_null(g_lii.lii01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT lii_file.* INTO g_lii.* FROM lii_file
    WHERE lii01 = g_lii.lii01
   
   SELECT COUNT(*) INTO l_n FROM lnt_file
    WHERE lnt71 = g_lii.lii01 
   IF l_n > 0 THEN
      CALL cl_err(g_lii.lii01,'alm1202',1)
      RETURN
   END IF
   IF g_lii.liiacti ='N' THEN
      CALL cl_err(g_lii.lii01,'alm1071',1)
      RETURN
   END IF
   IF g_lii.liiconf = 'N' THEN
      CALL cl_err(g_lii.lii01,'alm1072',1)
      RETURN
   END IF
   
   BEGIN WORK
 
   OPEN t340_cl USING g_lii.lii01
   IF STATUS THEN
      CALL cl_err("OPEN t340_cl:",STATUS,0)
      CLOSE t340_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t340_cl INTO g_lii.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lii.lii01,SQLCA.sqlcode,0)
      CLOSE t340_cl
      ROLLBACK WORK
      RETURN
   END IF
   
 
   IF NOT cl_confirm('alm1073') THEN
      RETURN
   ELSE
      UPDATE lii_file
         SET liiconf = 'N',
             #CHI-D20015---modify---str---
             #liicond = '',
             #liiconu = '',
             liicond = g_today,
             liiconu = g_user,
             #CHI-D20015---modify---end---
             liimodu = g_user,
             liidate = g_today,
             liicont = '00:00:00'
       WHERE lii01 = g_lii.lii01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lii:',SQLCA.SQLCODE,0)
         LET g_lii.liiconf = 'Y' 
         LET g_lii.liicond = g_lii_t.liicond 
         LET g_lii.liiconu = g_lii_t.liiconu
         LET g_lii.liimodu = g_lii_t.liimodu
         LET g_lii.liidate = g_lii_t.liidate
         LET g_lii.liicont = g_lii_t.liicont
         DISPLAY BY NAME g_lii.liiconf,g_lii.liicond,g_lii.liiconu,g_lii.liimodu,g_lii.liidate,g_lii.liicont
       ELSE
         LET g_lii.liiconf = 'N'
         #CHI-D20015---modify---str---
         #LET g_lii.liicond = ''
         #LET g_lii.liiconu = ''
         LET g_lii.liicond = g_today
         LET g_lii.liiconu = g_user
         #CHI-D20015---modify---end---
         LET g_lii.liimodu = g_user
         LET g_lii.liidate = g_today 
         LET g_lii.liicont = '00:00:00'
         DISPLAY BY NAME g_lii.liiconf,g_lii.liicond,g_lii.liiconu,g_lii.liimodu,g_lii.liidate,g_lii.liicont
       END IF
    END IF 

   CLOSE t340_cl
   COMMIT WORK   
END FUNCTION
 
FUNCTION t340_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF INFIELD(lij03) THEN
       CALL cl_set_comp_entry("lij03",TRUE)    
    END IF
    
END FUNCTION
 
FUNCTION t340_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
  CALL cl_set_comp_entry("oaj02,oaj031,lnj02,lnr02",FALSE)

END FUNCTION
#FUN-B90121
#CHI-C80041---begin
FUNCTION t340_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lii.lii01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t340_cl USING g_lii.lii01
   IF STATUS THEN
      CALL cl_err("OPEN t340_cl:", STATUS, 1)
      CLOSE t340_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t340_cl INTO g_lii.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lii.lii01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t340_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_lii.liiconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_lii.liiconf)   THEN 
        LET l_chr=g_lii.liiconf
        IF g_lii.liiconf='N' THEN 
            LET g_lii.liiconf='X' 
        ELSE
            LET g_lii.liiconf='N'
        END IF
        UPDATE lii_file
            SET liiconf=g_lii.liiconf,  
                liimodu=g_user,
                liidate=g_today
            WHERE lii01=g_lii.lii01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lii_file",g_lii.lii01,"",SQLCA.sqlcode,"","",1)  
            LET g_lii.liiconf=l_chr 
        END IF
        DISPLAY BY NAME g_lii.liiconf
   END IF
 
   CLOSE t340_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lii.lii01,'V')
 
END FUNCTION
#CHI-C80041---end

