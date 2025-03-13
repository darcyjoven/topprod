# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimt610.4gl
# Descriptions...: 批序號開帳作業
# Date & Author..: TQC-B90236 11/11/02 By zhuhao
# Modify.........: No.TQC-C10054 12/01/16 By wuxj   資料同步，過單
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20496 12/02/27 By zhuhao 錯誤信息修改
# Modify.........: No.TQC-C20548 12/02/29 By zhuhao 增加邏輯判
# Modify.........: No.MOD-C30394 12/03/16 By xujing 錯誤信息aic-020改為aim-167
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-C50177 12/05/21 By fengrui 畫面檔已經控管,故MARK程式中欄位的非空控管
# Modify.........: No.TQC-C50184 12/05/21 By fengrui 項次欄位添加大於0控管
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-C80041 12/12/19 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_ing                   RECORD LIKE ing_file.*,
       g_ing_t                 RECORD LIKE ing_file.*, 
       g_ing_o                 RECORD LIKE ing_file.*,
       g_ing01_t               LIKE ing_file.ing01,  
       g_wc                    STRING,                 
       g_sql                   STRING,                
       g_ima02                 LIKE ima_file.ima02,
       g_ima021                LIKE ima_file.ima021,
       g_img09                 LIKE ima_file.ima09,
       g_img10                 LIKE ima_file.ima10

DEFINE 
     g_inh          DYNAMIC ARRAY OF RECORD 
        inh02       LIKE inh_file.inh02,   
        inh04       LIKE inh_file.inh04,  
        inh03       LIKE inh_file.inh03,
        inh05       LIKE inh_file.inh05, 
        inh06       LIKE inh_file.inh06,
        inh07       LIKE inh_file.inh07,             
        inh08       LIKE inh_file.inh08
                    END RECORD,
    g_inh_t         RECORD      
        inh02       LIKE inh_file.inh02,   
        inh04       LIKE inh_file.inh04,  
        inh03       LIKE inh_file.inh03,
        inh05       LIKE inh_file.inh05, 
        inh06       LIKE inh_file.inh06,
        inh07       LIKE inh_file.inh07,             
        inh08       LIKE inh_file.inh08
                    END RECORD,
    g_inh_o        RECORD      
        inh02       LIKE inh_file.inh02,   
        inh04       LIKE inh_file.inh04,  
        inh03       LIKE inh_file.inh03,
        inh05       LIKE inh_file.inh05, 
        inh06       LIKE inh_file.inh06,
        inh07       LIKE inh_file.inh07,             
        inh08       LIKE inh_file.inh08
                    END RECORD,
    g_wc2           STRING,                          
    g_rec_b         LIKE type_file.num5,        
    l_ac            LIKE type_file.num5,       
    g_count         LIKE type_file.num5
DEFINE g_forupd_sql        STRING                
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_i                 LIKE type_file.num5       
DEFINE g_curs_index        LIKE type_file.num10   
DEFINE g_row_count         LIKE type_file.num10   
DEFINE g_jump              LIKE type_file.num10   
DEFINE g_no_ask            LIKE type_file.num5 
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_t1                LIKE type_file.chr5

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5    
   OPTIONS                            
      INPUT NO WRAP
   DEFER INTERRUPT 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF                 
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("AIM")) THEN       
      EXIT PROGRAM
   END IF           
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_forupd_sql="SELECT * FROM ing_file WHERE ing01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) 
   DECLARE t610_cl CURSOR FROM g_forupd_sql
   LET p_row = 4 LET p_col = 3
   OPEN WINDOW t610_w AT p_row,p_col WITH FORM "aim/42f/aimt610"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()

   CALL t610_menu()
   CLOSE WINDOW t610_w                 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t610_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
   CLEAR FORM 
   CALL g_inh.clear()
   CALL cl_set_head_visible("","YES")          
   INITIALIZE g_ing.* TO NULL     
   CONSTRUCT BY NAME g_wc ON
         ing01,ing02,ing03,ing04,ing05,ing06,ingconf,ingpost,
         inguser,inggrup,ingoriu,ingorig,ingmodu,ingdate
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
            ON ACTION controlp
               CASE
                  WHEN INFIELD(ing01) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_ing"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ing01
                     NEXT FIELD ing01
                  WHEN INFIELD(ing03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_ing02"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ing03
                     NEXT FIELD ing03
                  WHEN INFIELD(ing04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_ing03"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ing04
                     NEXT FIELD ing04
                  WHEN INFIELD(ing05)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_ing04"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ing05
                     NEXT FIELD ing05
                  WHEN INFIELD(ing06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = 'c'
                     LET g_qryparam.form ="q_ing05"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ing06
                     NEXT FIELD ing06
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
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF
   CONSTRUCT g_wc2 ON inh02,inh04,inh03,inh05,inh06,inh07,inh08
                 FROM s_inh[1].inh02,s_inh[1].inh04,s_inh[1].inh03,s_inh[1].inh05,
                      s_inh[1].inh06,s_inh[1].inh07,s_inh[1].inh08
       BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
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
      LET g_sql = "SELECT UNIQUE ing_file.ing01 ",
                  "  FROM ing_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY ing01"
   ELSE                          
      LET g_sql = "SELECT UNIQUE ing_file.ing01 ",
                  "  FROM ing_file, inh_file ",
                  " WHERE ing01 = inh01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY ing01"
   END IF
   PREPARE t610_prepare FROM g_sql
   DECLARE t610_cs    
      SCROLL CURSOR WITH HOLD FOR t610_prepare
   IF g_wc2 = " 1=1" THEN 
      LET g_sql="SELECT COUNT(*) FROM ing_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT ing01) FROM ing_file,inh_file ",
                " WHERE inh01=ing01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t610_precount FROM g_sql
   DECLARE t610_count CURSOR FOR t610_precount
END FUNCTION

FUNCTION t610_menu()
   WHILE TRUE
      CALL t610_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t610_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t610_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t610_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t610_u()
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t610sub_y_chk()
               IF g_success = "Y" THEN
                  CALL t610sub_y_upd() 
               END IF
            END IF

         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t610_z()
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t610_s()
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_inh),'','')
            END IF

         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t610_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t610_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t610_x()  #CHI-D20010
               CALL t610_x(1) #CHI-D20010  
            END IF
         #CHI-C80041---end   
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t610_x(2)
            END IF
        #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION

FUNCTION t610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "       
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_inh TO s_inh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
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
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
      ON ACTION exporttoexcel
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY
      ON ACTION first
         CALL t610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
      ON ACTION previous
         CALL t610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION jump
         CALL t610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         CALL t610_fetch("N")
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION last
         CALL t610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
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
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t610_bp_refresh()
  DISPLAY ARRAY g_inh TO s_inh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION

FUNCTION t610_a()
   DEFINE li_result       LIKE type_file.num5
   MESSAGE ""
   CLEAR FORM
   CALL g_inh.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
   IF s_shut(0) THEN
      RETURN
   END IF
      
   INITIALIZE g_ing.* LIKE ing_file.*             
   LET g_ing01_t = NULL
   LET g_ing_t.* = g_ing.*
   LET g_ing_o.* = g_ing.*
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_ing.ing02 = g_today
      LET g_ing.ingconf='N'
      LET g_ing.ingpost='N'
      LET g_ing.inguser= g_user
      LET g_ing.inggrup= g_grup
      LET g_ing.ingoriu= g_user
      LET g_ing.ingorig= g_grup
      LET g_ing.inglegal= g_legal
      LET g_ing.ingplant= g_plant
      CALL t610_i("a")                 
      IF INT_FLAG THEN                  
         INITIALIZE g_ing.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF cl_null(g_ing.ing01) THEN      
         CONTINUE WHILE
      END IF
      CALL s_auto_assign_no("aim",g_ing.ing01,g_today,"K","ing_file","ing01",
                "","","")
           RETURNING li_result,g_ing.ing01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_ing.ing01
      IF cl_null(g_ing.ing05) THEN
         LET g_ing.ing05 = ' '
      END IF
      IF cl_null(g_ing.ing06) THEN
         LET g_ing.ing06 = ' '
      END IF
      INSERT INTO ing_file(ing01,ing02,ing03,ing04,ing05,ing06,ingconf,ingpost,
                           inguser,inggrup,ingorig,ingoriu,ingplant,inglegal) 
       VALUES (g_ing.ing01,g_ing.ing02,g_ing.ing03,g_ing.ing04,g_ing.ing05,g_ing.ing06,
               g_ing.ingconf,g_ing.ingpost,g_user,g_grup,g_grup,g_user,g_plant,g_legal)
      IF SQLCA.sqlcode THEN                    
         CALL cl_err3("ins","ing_file",g_ing.ing01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         CALL cl_flow_notify(g_ing.ing01,'I')
      END IF
      SELECT ing01 INTO g_ing.ing01 FROM ing_file
       WHERE ing01 = g_ing.ing01
      LET g_ing01_t = g_ing.ing01      
      LET g_ing_t.* = g_ing.*
      LET g_ing_o.* = g_ing.*
      CALL g_inh.clear()
      LET g_rec_b = 0  
      CALL t610_b()                
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t610_u()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_ing.ing01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_ing.ingconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF
   IF g_ing.ingpost = 'Y' THEN
      CALL cl_err('','aim-318',0)     #TQC-C20496 
      RETURN
   END IF
   SELECT * INTO g_ing.* FROM ing_file
    WHERE ing01=g_ing.ing01
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ing01_t = g_ing.ing01
   BEGIN WORK
   OPEN t610_cl USING g_ing.ing01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t610_cl INTO g_ing.*                   
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ing.ing01,SQLCA.sqlcode,0)   
       CLOSE t610_cl
       ROLLBACK WORK
       RETURN
   END IF
   CALL t610_show()
   WHILE TRUE
      LET g_ing01_t = g_ing.ing01
      LET g_ing_o.* = g_ing.*
      LET g_ing.ingmodu=g_user
      LET g_ing.ingdate=g_today 
      CALL t610_i("u")                  
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ing.*=g_ing_t.*
         CALL t610_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_ing.ing01 != g_ing01_t THEN            
         UPDATE inh_file SET inh01 = g_ing.ing01
          WHERE inh01 = g_ing01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","inh_file",g_ing01_t,"",SQLCA.sqlcode,"","inh",1)  
            CONTINUE WHILE
         END IF
      END IF
      UPDATE ing_file SET ing_file.* = g_ing.*
       WHERE ing01 = g_ing.ing01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ing_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t610_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ing.ing01,'U')
   CALL t610_b_fill("1=1")
   CALL t610_bp_refresh()
END FUNCTION
 
FUNCTION t610_i(p_cmd)
   DEFINE l_n       LIKE type_file.num5,    
          p_cmd     LIKE type_file.chr1   
   DEFINE li_result LIKE type_file.num5    
   IF s_shut(0) THEN
      RETURN
   END IF
   DISPLAY BY NAME
      g_ing.ing01,g_ing.ing02,g_ing.ing03,g_ing.ing04,g_ing.ing05,g_ing.ing06,
      g_ing.ingconf,g_ing.ingpost,g_ing.inguser,g_ing.inggrup,g_ing.ingorig,
      g_ing.ingoriu,g_ing.ingmodu,g_ing.ingdate
   INPUT BY NAME
      g_ing.ing01,g_ing.ing02,g_ing.ing03,g_ing.ing04,g_ing.ing05,g_ing.ing06,
      g_ing.ingconf,g_ing.ingpost,g_ing.inguser,g_ing.inggrup,g_ing.ingorig,
      g_ing.ingoriu,g_ing.ingmodu,g_ing.ingdate
      WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t610_set_entry(p_cmd)
         CALL t610_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("ing01")

      AFTER FIELD ing01
         IF NOT cl_null(g_ing.ing01) THEN
            LET g_t1 = s_get_doc_no(g_ing.ing01)
            CALL s_check_no("aim",g_ing.ing01,g_ing_t.ing01,"K","ing_file","ing01","")  
                 RETURNING li_result,g_ing.ing01
            DISPLAY BY NAME g_ing.ing01
            IF (NOT li_result) THEN
               IF p_cmd = 'a' THEN
                  LET g_ing.ing01=''
                  NEXT FIELD ing01
               END IF
            END IF
         END IF
      AFTER FIELD ing02
         #TQC-C50177--mark--str--
         #IF cl_null(g_ing.ing02) THEN
         #   CALL cl_err('','aap-099',0)
         #   NEXT FIELD ing02
         #ELSE
         #TQC-C50177--mark--end--
         IF NOT cl_null(g_ing.ing02) THEN  #TQC-C50177 add
            IF YEAR(g_ing.ing02) <> YEAR(g_today) THEN
               CALL cl_err('',-1204,0)
               NEXT FIELD ing02
            ELSE
               IF g_ing.ing02 < g_sma.sma53 THEN
                  CALL cl_err('','ing-001',0)
                  NEXT FIELD ing02
               END IF
            END IF   
         END IF  
      AFTER FIELD ing03
         #TQC-C50177--mark--str--
         #IF cl_null(g_ing.ing03) THEN
         #   CALL cl_err('','aap-099',0)
         #   NEXT FIELD ing03
         #ELSE
         #TQC-C50177--mark--end--
         IF NOT cl_null(g_ing.ing03) THEN  #TQC-C50177 add
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM ima_file 
             WHERE ima01=g_ing.ing03 AND (ima918='Y' OR  ima921='Y')
            IF l_n>0 THEN
               SELECT ima02,ima021 INTO g_ima02,g_ima021 FROM ima_file
                WHERE ima01=g_ing.ing03 
               DISPLAY g_ima02 TO ima02
               DISPLAY g_ima021 TO ima021
            ELSE 
         #     CALL cl_err('','aic-020',0)  #MOD-C30394  mark
               CALL cl_err('','aim-167',0)  #MOD-C30394  add
               NEXT FIELD ing03
            END IF
            IF p_cmd='a' THEN
               SELECT COUNT(img02) INTO l_n FROM img_file WHERE img01=g_ing.ing03
               IF l_n<1 THEN
                  CALL cl_err('','ing-007',0)
                  NEXT FIELD ing03
               END IF
            ELSE
               SELECT COUNT(img02) INTO l_n FROM img_file WHERE img01=g_ing.ing03 
               IF l_n<1 THEN
                  CALL cl_err('','ing-007',0)
                  NEXT FIELD ing03
               ELSE
                  SELECT COUNT(img02) INTO l_n FROM img_file WHERE img01=g_ing.ing03 AND img02=g_ing.ing04
                  IF l_n<1 THEN
                     LET g_ing.ing04=''
                     LET g_ing.ing05=''
                     LET g_ing.ing06=''
                  END IF
               END IF
            END IF
         END IF 
      AFTER FIELD ing04
         #TQC-C50177--mark--str--
         #IF cl_null(g_ing.ing04) THEN
         #   CALL cl_err('','aap-099',0)
         #   NEXT FIELD ing04
         #ELSE
         #TQC-C50177--mark--end--
         IF NOT cl_null(g_ing.ing04) THEN  #TQC-C50177 add
            SELECT COUNT(img02) INTO l_n FROM img_file
             WHERE img01=g_ing.ing03 AND img02 = g_ing.ing04
            IF l_n<1 THEN
               CALL cl_err('','aim-703',0)
               NEXT FIELD ing04
            ELSE
               CALL t610_g_img()
            END IF
         END IF  
      AFTER FIELD ing05
         IF cl_null(g_ing.ing05) THEN
            LET g_ing.ing05=' '
            DISPLAY BY NAME g_ing.ing05
         END IF
         #TQC-C50177--mark--str--
         #SELECT COUNT(img03) INTO l_n FROM img_file
         # WHERE img01=g_ing.ing03 AND img02=g_ing.ing04
         #   AND img03=g_ing.ing05
         #IF l_n<1 THEN
         #   CALL cl_err('',-1281,0)
         #   NEXT FIELD ing05
         #ELSE
         #   CALL t610_g_img()
         #END IF
         #TQC-C50177--mark--end--
      AFTER FIELD ing06
         IF cl_null(g_ing.ing06) THEN
            LET g_ing.ing06=' '
            DISPLAY g_ing.ing06 TO ing06
         END IF 
         IF cl_null(g_ing.ing05) THEN
            LET g_ing.ing05=' '
            DISPLAY g_ing.ing05 TO ing05
         END IF
         #TQC-C50177--mark--str--
         #LET l_n=0
         #SELECT COUNT(img03) INTO l_n FROM img_file
         # WHERE img01=g_ing.ing03 AND img02=g_ing.ing04
         #   AND img03=g_ing.ing05 AND img04=g_ing.ing06
         #IF l_n<1 THEN
         #   CALL cl_err('','asf-507',0)
         #   NEXT FIELD ing06
         #ELSE
         #   CALL t610_g_img()
         #END IF
         #TQC-C50177--mark--end--

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         LET g_ing.inguser = s_get_data_owner("ing_file") #FUN-C10039
         LET g_ing.inggrup = s_get_data_group("ing_file") #FUN-C10039
         IF g_ing.ing05 IS NULL THEN LET g_ing.ing05=' ' END IF
         IF g_ing.ing06 IS NULL THEN LET g_ing.ing06=' ' END IF
         #TQC-C50177--add--str--
         LET l_n=0
         SELECT COUNT(img03) INTO l_n FROM img_file
          WHERE img01=g_ing.ing03 AND img02=g_ing.ing04
            AND img03=g_ing.ing05 AND img04=g_ing.ing06
         IF l_n<1 THEN
            CALL cl_err('','asf-507',0)
            NEXT FIELD ing03         #TQC-C50177  ing06--ing03
         ELSE
            CALL t610_g_img()
         END IF
         #TQC-C50177--add--end--
         LET l_n=0
         SELECT COUNT(*) INTO l_n FROM imgs_file
          WHERE imgs01 = g_ing.ing03
            AND imgs02 = g_ing.ing04
            AND imgs03 = g_ing.ing05
            AND imgs04 = g_ing.ing06
         IF l_n > 0 THEN
            CALL cl_err('','ing-002',0)
            CONTINUE INPUT
         END IF
      ON ACTION controlp
         CASE 
            WHEN INFIELD(ing01)
                 LET g_t1 = s_get_doc_no(g_ing.ing01)
                 CALL q_smy(FALSE,FALSE,g_t1,'AIM','K') RETURNING g_t1
                 LET g_ing.ing01 = g_t1
                 DISPLAY BY NAME g_ing.ing01
                 NEXT FIELD ing01
            WHEN INFIELD(ing03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ing01"
                 LET g_qryparam.default1 = g_ing.ing03
                 CALL cl_create_qry() RETURNING g_ing.ing03
                 DISPLAY BY NAME g_ing.ing03
                 NEXT FIELD ing03
            WHEN INFIELD(ing04) OR INFIELD(ing05) OR INFIELD(ing06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_img1"
                 LET g_qryparam.arg1 = g_ing.ing03
                 CALL cl_create_qry() RETURNING g_ing.ing04,g_ing.ing05,g_ing.ing06
                 IF cl_null(g_ing.ing05) THEN
                    LET g_ing.ing05 = ' '
                 END IF
                 IF cl_null(g_ing.ing06) THEN
                    LET g_ing.ing06 = ' '
                 END IF
                 DISPLAY g_ing.ing04 TO ing04
                 DISPLAY g_ing.ing05 TO ing05
                 DISPLAY g_ing.ing06 TO ing06
                 IF INFIELD(ing04) THEN NEXT FIELD ing04 END IF
                 IF INFIELD(ing05) THEN NEXT FIELD ing05 END IF
                 IF INFIELD(ing06) THEN NEXT FIELD ing06 END IF
           END CASE

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
END FUNCTION

FUNCTION t610_g_img()
   SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
    WHERE img01 = g_ing.ing03
      AND img02 = g_ing.ing04
      AND img03 = g_ing.ing05
      AND img04 = g_ing.ing06
   DISPLAY g_img09,g_img10 TO img09,img10
END FUNCTION
 
FUNCTION t610_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1  
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ing01",TRUE)
    END IF
END FUNCTION
 
FUNCTION t610_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1  
    IF p_cmd = 'u' AND g_chkey = "N" AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ing01",FALSE)
    END IF
END FUNCTION

FUNCTION t610_b_set_entry(p_cmd)
   DEFINE   l_ima918        LIKE ima_file.ima918
   DEFINE   l_ima921        LIKE ima_file.ima921
   DEFINE   p_cmd           LIKE type_file.chr1
   IF p_cmd = 'a' THEN
      CALL cl_set_comp_entry("inh08",FALSE)
      CALL cl_set_comp_required("inh02,inh06",TRUE)
      SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file
       WHERE ima01 = g_ing.ing03
      IF l_ima918 = 'Y' THEN
         CALL cl_set_comp_required("inh04",TRUE)
      END IF
      IF l_ima921 = 'Y' THEN
         CALL cl_set_comp_required("inh03",TRUE)
      END IF
   END IF
   IF p_cmd = 'u' THEN
      IF cl_null(g_inh[l_ac].inh07) THEN
         LET g_inh[l_ac].inh08 = ''
         CALL cl_set_comp_entry("inh08",FALSE)
      ELSE
         CALL cl_set_comp_entry("inh08",TRUE)
         CALL cl_set_comp_required("inh08",TRUE)
      END IF
   END IF
END FUNCTION

FUNCTION t610_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_inh.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL t610_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ing.* TO NULL
      RETURN
   END IF
   OPEN t610_cs                           
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ing.* TO NULL
   ELSE
      OPEN t610_count
      FETCH t610_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t610_fetch('F')                
   END IF
END FUNCTION

FUNCTION t610_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1
   DEFINE l_slip   LIKE smy_file.smyslip
   CASE p_flag
      WHEN "N" FETCH NEXT     t610_cs INTO g_ing.ing01
      WHEN 'P' FETCH PREVIOUS t610_cs INTO g_ing.ing01
      WHEN 'F' FETCH FIRST    t610_cs INTO g_ing.ing01
      WHEN 'L' FETCH LAST     t610_cs INTO g_ing.ing01
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
         FETCH ABSOLUTE g_jump t610_cs INTO g_ing.ing01
         LET mi_no_ask = FALSE          
   END CASE
   IF SQLCA.sqlcode THEN                  
      INITIALIZE g_ing.* TO NULL
      RETURN
   ELSE
      CASE p_flag                        
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN "N" LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.cn2
   END IF
   SELECT * INTO g_ing.* FROM ing_file WHERE ing01 = g_ing.ing01
   IF SQLCA.sqlcode THEN                  
      CALL cl_err3("sel","ing_file",g_ing.ing01,"",SQLCA.sqlcode,"","",0)
   ELSE
      LET g_data_owner=g_ing.inguser      
      LET g_data_group=g_ing.inggrup
   END IF
   CALL t610_show()
END FUNCTION

FUNCTION t610_show()
   LET g_ing_t.* = g_ing.*              
   DISPLAY BY NAME          
      g_ing.ing01,g_ing.ing02,g_ing.ing03,g_ing.ing04,g_ing.ing05,g_ing.ing06,
      g_ing.ingconf,g_ing.ingpost,g_ing.inguser,g_ing.inggrup,
      g_ing.ingoriu,g_ing.ingmodu,g_ing.ingdate,g_ing.ingorig
   SELECT ima02,ima021 INTO g_ima02,g_ima021 FROM ima_file WHERE ima01 = g_ing.ing03
   DISPLAY g_ima02 TO ima02
   DISPLAY g_ima021 TO ima021
   SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
    WHERE img01=g_ing.ing03 AND img02=g_ing.ing04 
      AND img03=g_ing.ing05 AND img04=g_ing.ing06
   DISPLAY g_img09,g_img10 TO img09,img10
   CALL t610_b_fill(g_wc2)      
   CALL cl_show_fld_cont()                 
END FUNCTION

FUNCTION t610_r()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_ing.ing01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_ing.ingconf = 'Y' THEN
      CALL cl_err('','abm-881',0)
      RETURN
   END IF
   IF g_ing.ingpost = 'Y' THEN
      CALL cl_err('','aim-318',0)    #TQC-C20496
      RETURN
   END IF
   SELECT * INTO g_ing.* FROM ing_file
    WHERE ing01=g_ing.ing01
   BEGIN WORK
   OPEN t610_cl USING g_ing.ing01
   IF STATUS THEN
      CALL cl_err("OPEN iing_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t610_cl INTO g_ing.*              
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ing.ing01,SQLCA.sqlcode,0)   
      ROLLBACK WORK
      RETURN
   END IF
   CALL t610_show()
   IF cl_delh(0,0) THEN            
       INITIALIZE g_doc.* TO NULL  
       LET g_doc.column1 = "ing01"      
       LET g_doc.value1 = g_ing.ing01   
       CALL cl_del_doc()            
      DELETE FROM ing_file WHERE ing01 = g_ing.ing01
      DELETE FROM inh_file WHERE inh01 = g_ing.ing01
      CLEAR FORM
      CALL g_inh.clear()
      OPEN t610_count
      FETCH t610_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t610_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t610_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE    
         CALL t610_fetch('/')
      END IF
   END IF
   CLOSE t610_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ing.ing01,'D')
END FUNCTION

FUNCTION t610_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,           
      l_n             LIKE type_file.num5,             
      l_lock_sw       LIKE type_file.chr1,            
      p_cmd           LIKE type_file.chr1,           
      l_allow_insert  LIKE type_file.chr1,               
      l_allow_delete  LIKE type_file.chr1,               
      l_inh06         LIKE inh_file.inh06,
      l_img10         LIKE img_file.img10
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   IF g_ing.ing01 IS NULL THEN
      RETURN
   END IF 
   IF g_ing.ingconf = 'Y' THEN
      CALL cl_err('','abm-879',0)
      RETURN
   END IF
   IF g_ing.ingpost = 'Y' THEN
      CALL cl_err('','aim-318',0)     #TQC-C20496
      RETURN
   END IF

   SELECT * INTO g_ing.* FROM ing_file 
    WHERE ing01 = g_ing.ing01
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT inh02,inh04,inh03,inh05,inh06,inh07,inh08",
                      "  FROM inh_file WHERE inh01 = ? AND inh02 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   DECLARE t610_bcl CURSOR FROM g_forupd_sql                   
   INPUT ARRAY g_inh WITHOUT DEFAULTS FROM s_inh.*         
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
      BEFORE INPUT
          DISPLAY "BEFORE INPUT!"
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
      BEFORE ROW
          DISPLAY "BEFORE ROW!"
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = "N"
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          OPEN t610_cl USING g_ing.ing01
          IF STATUS THEN
             CALL cl_err("OPEN t610_cl:", STATUS, 1)
             CLOSE t610_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH t610_cl INTO g_ing.*      
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_ing.ing01,SQLCA.sqlcode,0) 
             CLOSE t610_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_inh_t.* = g_inh[l_ac].* 
             LET g_inh_o.* = g_inh[l_ac].*
             OPEN t610_bcl USING g_ing_t.ing01,g_inh_t.inh02
             IF STATUS THEN
                CALL cl_err("OPEN t610_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t610_bcl INTO g_inh[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_inh_t.inh02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont() 
             CALL t610_b_set_entry(p_cmd) 
          END IF
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
              LET l_n = ARR_COUNT()
              LET p_cmd='a'                               
              INITIALIZE g_inh[l_ac].* TO NULL     
              LET g_inh_t.* = g_inh[l_ac].*         
              CALL cl_show_fld_cont()        
              CALL t610_b_set_entry(p_cmd)    
              NEXT FIELD inh02
        BEFORE FIELD inh02
           IF g_inh[l_ac].inh02 IS NULL OR g_inh[l_ac].inh02 = 0 THEN
              SELECT max(inh02)+1
                INTO g_inh[l_ac].inh02
                FROM inh_file
               WHERE inh01=g_ing.ing01
              IF g_inh[l_ac].inh02 IS NULL THEN
                 LET g_inh[l_ac].inh02 = 1
              END IF
           END IF
        AFTER FIELD inh02         
           IF NOT cl_null(g_inh[l_ac].inh02) THEN
              IF g_inh[l_ac].inh02 != g_inh_t.inh02 OR
                 g_inh_t.inh02 IS NULL THEN
                 #TQC-C50184--add--str--
                 IF g_inh[l_ac].inh02 < = 0 THEN
                    LET g_inh[l_ac].inh02 = g_inh_t.inh02
                    DISPLAY BY NAME g_inh[l_ac].inh02
                    CALL cl_err('','aec-994',0)
                   NEXT FIELD inh02
                 END IF
                 #TQC-C50184--add--end--
                 SELECT count(*) INTO l_n FROM inh_file
                  WHERE inh01 = g_ing.ing01 AND inh02 = g_inh[l_ac].inh02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_inh[l_ac].inh02 = g_inh_t.inh02
                    NEXT FIELD inh02
                 END IF
              END IF     
           END IF         
        AFTER FIELD inh06
           IF g_inh[l_ac].inh06 <= 0 THEN
              CALL cl_err('','alm-468',0)
           END IF
        AFTER FIELD inh07
           IF cl_null(g_inh[l_ac].inh07) THEN
              LET g_inh[l_ac].inh08 = ''
              CALL cl_set_comp_entry('inh08',FALSE)
           ELSE
              CALL cl_set_comp_entry('inh08',TRUE)
              CALL cl_set_comp_required("inh08",TRUE)
           END IF
        ON CHANGE inh07
           CALL t610_b_set_entry(p_cmd)
        AFTER FIELD inh08
           IF NOT cl_null(g_inh[l_ac].inh08) THEN
              CASE g_inh[l_ac].inh07
                 WHEN '1'
                    LET l_n = 0
                    SELECT COUNT(*) INTO l_n FROM oea_file WHERE oea01 = g_inh[l_ac].inh08
                    IF l_n < 1 THEN
                       CALL cl_err('','aim1121',0)
                       NEXT FIELD inh08
                    END IF
                 WHEN '2'
                    LET l_n = 0
                    SELECT COUNT(*) INTO l_n FROM sfb_file WHERE sfb01 = g_inh[l_ac].inh08
                    IF l_n < 1 THEN
                       CALL cl_err('','aim1121',0)
                       NEXT FIELD inh08
                     END IF
                 WHEN '3'
                    LET l_n = 0
                    SELECT COUNT(*) INTO l_n FROM pja_file WHERE pja01 = g_inh[l_ac].inh08
                    IF l_n < 1 THEN
                       CALL cl_err('','aim1121',0)
                       NEXT FIELD inh08
                    END IF
              END CASE
           END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              LET g_inh[l_ac].* = g_inh_t.*
              CLOSE t610_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_inh[l_ac].inh02,-263,0)
              LET g_inh[l_ac].* = g_inh_t.*
           ELSE
              IF cl_null(g_inh[l_ac].inh04) THEN
                 LET g_inh[l_ac].inh04 = ' '
              END IF
              IF cl_null(g_inh[l_ac].inh03) THEN
                 LET g_inh[l_ac].inh03 = ' '
              END IF
              IF cl_null(g_inh[l_ac].inh08) THEN
                 LET g_inh[l_ac].inh08 = ' '
              END IF
              UPDATE inh_file
                 SET inh02=g_inh[l_ac].inh02,inh04=g_inh[l_ac].inh04,
                     inh03=g_inh[l_ac].inh03,inh05=g_inh[l_ac].inh05,
                     inh06=g_inh[l_ac].inh06,inh07=g_inh[l_ac].inh07,
                     inh08=g_inh[l_ac].inh08,inhlegal=g_legal,inhplant=g_plant
               WHERE inh01=g_ing.ing01 AND inh02 = g_inh_t.inh02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","inh_file",g_ing.ing01,"",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 LET g_inh[l_ac].* = g_inh_t.*
              ELSE
                 COMMIT WORK
              END IF
           END IF

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',-9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           BEGIN WORK
           IF cl_null(g_inh[l_ac].inh04) THEN
              LET g_inh[l_ac].inh04 = ' '
           END IF
           IF cl_null(g_inh[l_ac].inh03) THEN
              LET g_inh[l_ac].inh03 = ' '
           END IF
           IF cl_null(g_inh[l_ac].inh08) THEN
              LET g_inh[l_ac].inh08 = ' '
           END IF
           INSERT INTO inh_file(inh01,inh02,inh03,inh04,inh05,inh06,
                                inh07,inh08,inhlegal,inhplant)
           VALUES(g_ing.ing01,g_inh[l_ac].inh02,g_inh[l_ac].inh03,
                  g_inh[l_ac].inh04,g_inh[l_ac].inh05,g_inh[l_ac].inh06,
                  g_inh[l_ac].inh07,g_inh[l_ac].inh08,g_legal,g_plant)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","inh_file",g_ing.ing01,g_inh[l_ac].inh02,SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.count
          END IF
        BEFORE DELETE                     
           DISPLAY "BEFORE DELETE"
           IF g_inh_t.inh02 > 0 AND g_inh_t.inh02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM inh_file
               WHERE inh01 = g_ing.ing01
                 AND inh02 = g_inh_t.inh02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","inh_file",g_ing.ing01,g_inh_t.inh02,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.count
           END IF
           COMMIT WORK
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D40030 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_inh[l_ac].* = g_inh_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_inh.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--  
              END IF
              CLOSE t610_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D40030 Add
           CLOSE t610_bcl
           COMMIT WORK
        AFTER INPUT
           SELECT SUM(inh06) INTO l_inh06 FROM inh_file WHERE inh01 = g_ing.ing01
           SELECT img10 INTO l_img10 FROM img_file
            WHERE img01 = g_ing.ing03
              AND img02 = g_ing.ing04
              AND img03 = g_ing.ing05
              AND img04 = g_ing.ing06
           IF cl_null(l_img10) THEN
              LET l_img10 = 0
           END IF
           IF l_inh06 <> l_img10 THEN
              IF NOT cl_confirm('ing-005') THEN              #單身數量加總與庫存數量不合，是否確認要離開？
                 CONTINUE INPUT
              END IF
           END IF
        ON ACTION CONTROLO                        
            IF INFIELD(inh01) AND l_ac > 1 THEN
                LET g_inh[l_ac].* = g_inh[l_ac-1].*
                NEXT FIELD inh01
            END IF
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
        LET l_n = 0
    END INPUT
    CLOSE t610_bcl
    COMMIT WORK
#   CALL t610_delall()        #CHI-C30002 mark
    CALL t610_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t610_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ing.ing01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ing_file ",
                  "  WHERE ing01 LIKE '",l_slip,"%' ",
                  "    AND ing01 > '",g_ing.ing01,"'"
      PREPARE t610_pb1 FROM l_sql 
      EXECUTE t610_pb1 INTO l_cnt       
      
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
        #CALL t610_x()   #CHI-D20010
         CALL t610_x(1)  #CHI-D20010
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN #CHI-C80041
         DELETE FROM ing_file WHERE ing01 = g_ing.ing01
         INITIALIZE g_ing.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t610_delall()
#DEFINE l_cnt  LIKE type_file.num5    
#   SELECT COUNT(*) INTO l_cnt FROM inh_file
#    WHERE inh01=g_ing.ing01
#   IF l_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM ing_file WHERE ing01 = g_ing.ing01
#      INITIALIZE g_ing.* TO NULL
#      CLEAR FORM
#      CALL g_inh.clear()
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end

FUNCTION t610_b_fill(p_wc2)
   DEFINE p_wc2   STRING
   LET g_sql = "SELECT inh02,inh04,inh03,inh05,inh06,inh07,inh08",
               "  FROM inh_file",
               " WHERE inh01 ='",g_ing.ing01,"' "  
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   PREPARE t610_pb FROM g_sql
   DECLARE inh_cs CURSOR FOR t610_pb
   CALL g_inh.clear()
   LET g_cnt = 1
   FOREACH inh_cs INTO g_inh[g_cnt].*  
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
   CALL g_inh.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.count
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t610_copy()
   DEFINE l_newno     LIKE ing_file.ing01,
          l_newdate   LIKE ing_file.ing06,
          l_oldno     LIKE ing_file.ing01
   DEFINE li_result   LIKE type_file.num5    
   IF s_shut(0) THEN RETURN END IF
   IF g_ing.ing01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_before_input_done = FALSE
   CALL t610_set_entry('a')
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM ing01
       AFTER FIELD ing01
         IF l_newno IS NOT NULL THEN
            LET g_t1 = s_get_doc_no(l_newno)
            CALL s_check_no("aim",l_newno,g_ing_t.ing01,"K","ing_file","ing01","")
                 RETURNING li_result,l_newno
            DISPLAY l_newno TO ing01
            IF (NOT li_result) THEN
               LET l_newno = ''
               NEXT FIELD ing01
            END IF
         END IF
       ON ACTION controlp
         CASE
            WHEN INFIELD(ing01)
                 LET g_t1 = s_get_doc_no(l_newno)
                 CALL q_smy(FALSE,FALSE,g_t1,'AIM','K') RETURNING g_t1
                 LET l_newno = g_t1
                 DISPLAY l_newno TO ing01 
                 NEXT FIELD ing01
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
      RETURN
   END IF
   CALL s_auto_assign_no("aim",l_newno,g_today,"K","ing_file","ing01",
                         "","","")
           RETURNING li_result,l_newno
   IF (NOT li_result) THEN
       RETURN
   END IF
   DISPLAY l_newno TO ing01
   DROP TABLE y
   SELECT * FROM ing_file     
       WHERE ing01=g_ing.ing01
       INTO TEMP y
   UPDATE y
       SET ing01=l_newno,
           ingpost='N',
           ingconf='N',
           inguser=g_user,  
           inggrup=g_grup,  
           ingmodu=NULL,    
           ingdate=g_today 
   INSERT INTO ing_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ing_file","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
   DROP TABLE x
   SELECT * FROM inh_file       
    WHERE inh01=g_ing.ing01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
   UPDATE x SET inh01=l_newno
   INSERT INTO inh_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","inh_file","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
   LET l_oldno = g_ing.ing01
   SELECT ing_file.* INTO g_ing.* FROM ing_file WHERE ing01 = l_newno
   CALL t610_u()
   CALL t610_b()
   #SELECT ing_file.* INTO g_ing.* FROM ing_file WHERE ing01 = l_oldno  #FUN-C30027
   #CALL t610_show()  #FUN-C30027
END FUNCTION

FUNCTION t610sub_y_chk()
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_inh06  LIKE inh_file.inh06
   DEFINE l_img10  LIKE img_file.img10
   LET g_success = 'Y'
#CHI-C30107 ------------ add ---------------- begin
   IF g_ing.ing01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_ing.ingconf <> 'N' THEN
      CALL cl_err('',8888,0)
      LET g_success = 'N'
      RETURN
   END IF
   IF NOT cl_confirm('aap-222') THEN
      LET g_success = 'N'
      RETURN
   END IF
   SELECT * INTO g_ing.* FROM ing_file WHERE ing01 = g_ing.ing01
#CHI-C30107 ------------ add ---------------- end
   IF g_ing.ing01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_ing.ingconf <> 'N' THEN
      CALL cl_err('',8888,0)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM inh_file WHERE inh01 = g_ing.ing01
   IF l_n < 1 THEN 
      CALL cl_err('','art-486',0)
      LET g_success = 'N'
      RETURN
   END IF
   LET l_n = 0
   LET l_inh06 = 0
   LET l_img10 = 0
   SELECT SUM(inh06) INTO l_inh06 FROM inh_file WHERE inh01 = g_ing.ing01
   SELECT img10 INTO l_img10 FROM img_file
    WHERE img01 = g_ing.ing03 
      AND img02 = g_ing.ing04
      AND img03 = g_ing.ing05 
      AND img04 = g_ing.ing06
   IF l_inh06 <> l_img10 THEN 
      CALL cl_err('','ing-006',0)
      LET g_success = 'N' 
      RETURN
   END IF
END FUNCTION

FUNCTION t610sub_y_upd()
#CHI-C30107 ------------ mark ---------------- begin
#  IF NOT cl_confirm('aap-222') THEN
#     RETURN
#  END IF
#CHI-C30107 ------------ mark ---------------- end
   UPDATE ing_file SET ingconf = 'Y'
    WHERE ing01 = g_ing.ing01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ing_file",g_ing.ing01,"",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
   LET g_ing.ingconf = 'Y'
   DISPLAY g_ing.ingconf TO ingconf
   CALL t610_show()
END FUNCTION

FUNCTION t610_z()
   IF g_ing.ing01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_ing.ingpost = 'Y' THEN
      CALL cl_err('','afa-106',0)
      RETURN
   END IF
   IF g_ing.ingconf <> 'Y' THEN
      CALL cl_err('','aim1129',0)
      RETURN
   END IF
   IF NOT cl_confirm('aim-304') THEN
      RETURN
   END IF
   UPDATE ing_file SET ingconf = 'N'
    WHERE ing01 = g_ing.ing01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ing_file",g_ing.ing01,"",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
   LET g_ing.ingconf = 'N'
   DISPLAY g_ing.ingconf TO ingconf
   CALL t610_show()
END FUNCTION

FUNCTION t610_s()
   LET g_success = 'Y'     #TQC-C20548 add
   IF g_ing.ing01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'   #TQC-C20548 add
      RETURN
   END IF
   IF (g_ing.ingconf <> 'Y') OR (g_ing.ingpost <> 'N') THEN
      CALL cl_err('','afa-100',0)
      LET g_success = 'N'   #TQC-C20548 add
      RETURN
   END IF
   IF NOT cl_confirm('mfg0176') THEN
      LET g_success = 'N'   #TQC-C20548 add
      RETURN
   END IF
   LET g_sql = "SELECT inh02,inh04,inh03,inh05,inh06,inh07,inh08",
               "  FROM inh_file",
               " WHERE inh01 ='",g_ing.ing01,"' "
   PREPARE t610_pbl FROM g_sql
   DECLARE inh_csl CURSOR FOR t610_pbl
   CALL g_inh.clear()
   LET g_cnt = 1
   FOREACH inh_csl INTO g_inh[g_cnt].*
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'   #TQC-C20548 add
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT img09 INTO g_img09 FROM img_file
       WHERE img01=g_ing.ing03 AND img02=g_ing.ing04
         AND img03=g_ing.ing05 AND img04=g_ing.ing06
      INSERT INTO imgs_file(imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,
                            imgs07,imgs08,imgs09,imgs10,imgs11,imgsplant,imgslegal)
         VALUES(g_ing.ing03,g_ing.ing04,g_ing.ing05,g_ing.ing06,g_inh[g_cnt].inh03,
                g_inh[g_cnt].inh04,g_img09,g_inh[g_cnt].inh06,g_inh[g_cnt].inh05,
                g_inh[g_cnt].inh07,g_inh[g_cnt].inh08,g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'   #TQC-C20548 add
            CALL cl_err3("ins","imgs_file",g_ing.ing01,"",SQLCA.sqlcode,"","",1)
            EXIT FOREACH
         END IF 
      INSERT INTO tlfs_file(tlfs01,tlfs02,tlfs03,tlfs04,tlfs05,tlfs06,
                            tlfs07,tlfs08,tlfs09,tlfs10,tlfs11,tlfs12,
                            tlfs13,tlfs14,tlfs15,tlfs111,tlfsplant,tlfslegal)
         VALUES(g_ing.ing03,g_ing.ing04,g_ing.ing05,g_ing.ing06,g_inh[g_cnt].inh03,
                g_inh[g_cnt].inh04,g_img09,'aimt610',1,g_ing.ing01,g_inh[g_cnt].inh02,
                g_today,g_inh[g_cnt].inh06,g_inh[g_cnt].inh07,g_inh[g_cnt].inh08,
                g_ing.ing02,g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'   #TQC-C20548 add
            CALL cl_err3("ins","tlfs_file",g_ing.ing01,"",SQLCA.sqlcode,"","",1)
            EXIT FOREACH
         END IF      
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         LET g_success = 'N'   #TQC-C20548 add
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   IF g_success = 'Y' THEN
      UPDATE ing_file SET ingpost = 'Y'
       WHERE ing01 = g_ing.ing01
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'   #TQC-C20548 add
         CALL cl_err3("upd","ing_file",g_ing.ing01,"",SQLCA.sqlcode,"","",1)
         RETURN
      ELSE
         CALL cl_err('','axm-669',0)
      END IF
   END IF
   #TQC-C20548 -- add -- begin
   IF g_success = 'Y' THEN
      LET g_ing.ingpost = 'Y'
      DISPLAY g_ing.ingpost TO ingpost
   ELSE
      CALL cl_err('','aim-307',0)     
   END IF
   #TQC-C20548 -- add -- end
   CALL t610_show()
END FUNCTION   

#TQC-B90236-------------end------------------------
#TQC-C10054-------------end-----------------------

#CHI-C80041---begin
#FUNCTION t610_x()        #CHI-D20010
FUNCTION t610_x(p_type)   #CHI-D20010 
DEFINE   l_chr              LIKE type_file.chr1
DEFINE   l_flag             LIKE type_file.chr1  #CHI-D20010
DEFINE   p_type             LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ing.ing01) THEN CALL cl_err('',-400,0) RETURN END IF  
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_ing.ingconf ='X' THEN RETURN END IF
   ELSE
      IF g_ing.ingconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end 

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t610_cl USING g_ing.ing01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t610_cl INTO g_ing.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ing.ing01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t610_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_ing.ingconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF g_ing.ingconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_ing.ingconf)   THEN  #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN  #CHI-D20010
        LET l_chr=g_ing.ingconf
       #IF g_ing.ingconf='N' THEN   #CHI-D20010
        IF p_type = 1 THEN       #CHI-D20010 
            LET g_ing.ingconf='X' 
        ELSE
            LET g_ing.ingconf='N'
        END IF
        UPDATE ing_file
            SET ingconf=g_ing.ingconf,  
                ingmodu=g_user,
                ingdate=g_today
            WHERE ing01=g_ing.ing01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","ing_file",g_ing.ing01,"",SQLCA.sqlcode,"","",1)  
            LET g_ing.ingconf=l_chr 
        END IF
        DISPLAY BY NAME g_ing.ingconf 
   END IF
 
   CLOSE t610_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ing.ing01,'V')
 
END FUNCTION
#CHI-C80041---end
