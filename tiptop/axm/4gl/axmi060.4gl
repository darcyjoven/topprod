# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi060.4gl
# Descriptions...: 價格條件維護作業
# Date & Author..: NO.FUN-960130 09/07/07 By  Sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No:FUN-A10012 10/01/06 By destiny 同一组别的价格编号不可重复 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A40038 10/04/14 By Smapmin 修改"判斷每組最小順序是否為A類"的條件
# Modify.........: No:FUN-AB0083 10/11/18 By suncx 價格代碼取消抓取rzz_file，改用combobox
# Modify.........: No:MOD-AC0399 11/01/05 By lixh1 调整报表打印格式
# Modify.........: No:MOD-B30096 11/03/11 By wangxin 在ohi04 AFTER FIELD時加判斷，每組只能有一筆A的資料 
# Modify.........: No:MOD-B30223 11/03/12 By baogc 業態為‘1.製造’時，隱藏價格編號下拉選項中的A2和C2
# Modify.........: No:TQC-B50128 11/05/23 By lixia 修改單身時，順序欄位增加每組最小順序必須為A類管控
# Modify.........: No:TQC-B50137 11/05/24 By lixia 修改每組只能有一筆A的資料的管控
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B70058 11/07/19 By zhangll 增加oah07 取到单价是否可以修改
# Modify.........: No.MOD-B80074 11/08/08 By suncx 單頭总笔数抓取錯誤
# Modify.........: No.FUN-C40089 12/04/30 By batr 增加單價可否為零
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oah         RECORD LIKE oah_file.*,    #NO.FUN-9B0016
       g_oah_t       RECORD LIKE oah_file.*,
       g_oah_o       RECORD LIKE oah_file.*,
       g_oah01_t     LIKE oah_file.oah01,
       g_ohi         DYNAMIC ARRAY OF RECORD
           ohi02          LIKE ohi_file.ohi02,
           ohi03          LIKE ohi_file.ohi03,
           ohi04          LIKE ohi_file.ohi04,
           #ohi04_desc    LIKE rzz_file.rzz02,   #FUN-AB0083 mark
           #rzz03         LIKE rzz_file.rzz03    #FUN-AB0083 mark
           type           LIKE type_file.chr1    #FUN-AB0083 add    
                     END RECORD,
       g_ohi_t       RECORD
           ohi02          LIKE ohi_file.ohi02,
           ohi03          LIKE ohi_file.ohi03,
           ohi04          LIKE ohi_file.ohi04,
           #ohi04_desc    LIKE rzz_file.rzz02,   #FUN-AB0083 mark
           #rzz03         LIKE rzz_file.rzz03    #FUN-AB0083 mark
           type           LIKE type_file.chr1    #FUN-AB0083 add            
                     END RECORD,
       g_ohi_o       RECORD 
           ohi02          LIKE ohi_file.ohi02,
           ohi03          LIKE ohi_file.ohi03,
           ohi04          LIKE ohi_file.ohi04,
           #ohi04_desc    LIKE rzz_file.rzz02,   #FUN-AB0083 mark
           #rzz03         LIKE rzz_file.rzz03    #FUN-AB0083 mark
           type           LIKE type_file.chr1    #FUN-AB0083 add           
                     END RECORD,
       g_str         STRING,      #MOD-AC0399
       g_sql         STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5
#MOD-AC0399 ----------------Begin------------------------
DEFINE wc      STRING
DEFINE wc1     STRING
DEFINE tm  RECORD                          # Print condition RECORD
           wc       STRING,
           wc1      STRING
           END RECORD
DEFINE l_table      STRING
#MOD-AC0399 ----------------End--------------------------
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_argv1             LIKE oah_file.oah01
DEFINE g_argv2             STRING 
DEFINE g_flag              LIKE type_file.num5
DEFINE cb                  ui.ComboBox                  #MOD-B30223 ADD
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
#MOD-AC0399 ----------------------Begin-------------------------------
   LET g_sql = "oah01.oah_file.oah01,",
               "oah02.oah_file.oah02,",
               "oah03.oah_file.oah03,",
               "oah04.oah_file.oah04,",
               "oah07.oah_file.oah07,",  #FUN-B70058 add

               "oah05.oah_file.oah05,",
               "oah06.oah_file.oah06,",
               "oah08.oah_file.oah08,",  #FUN-C40089
               "ohi02.ohi_file.ohi02,",
               "ohi03.ohi_file.ohi03,",
               "obb02.obb_file.obb02,",

               "oha10.oha_file.oha10"
  LET l_table = cl_prt_temptable('axmi060',g_sql) CLIPPED   # 產生Temp Table
  IF  l_table = -1 THEN EXIT PROGRAM END IF                 # Temp Table產生
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,? )"  #FUN-B70058 add 1? #FUN-C40089 add ?
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     RETURN
  END IF
  INITIALIZE tm.* TO NULL      
  LET g_pdate = ARG_VAL(1)    
  LET g_towhom = ARG_VAL(2)
  LET g_rlang = ARG_VAL(3)
  LET g_bgjob = ARG_VAL(4)
  LET g_prtway = ARG_VAL(5)
  LET g_copies = ARG_VAL(6)
  LET tm.wc  = ' 1=1'
  LET tm.wc1 = ' 1=1'
  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_copies = '1'
#MOD-AC0399 ----------------------End---------------------------------
 
   LET g_forupd_sql = "SELECT * FROM oah_file WHERE oah01 = ? FOR UPDATE "   #liuxqa 091021
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i060_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW i060_w WITH FORM "axm/42f/axmi060"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
##-MOD-B30223--ADD--BEGIN------
   LET cb = ui.ComboBox.forName("ohi04")
   IF g_azw.azw04 = '1' THEN
      CALL cb.removeItem('A2')
      CALL cb.removeItem('C2')
   END IF
##-MOD-B30223--ADD---END-------
 
   IF NOT cl_null(g_argv1) THEN
      CALL i060_q()
   END IF
   
   CALL i060_menu()
   CLOSE WINDOW i060_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i060_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
   CALL g_ohi.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " oah01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_oah.* TO NULL
      CONSTRUCT BY NAME g_wc ON oah01,oah02,oah04,oah07,oah05,oah06,oah08 #FUN-B70058 add oah07  #FUN-C40089 add oah08
         BEFORE CONSTRUCT
            CALL cl_qbe_init()     
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      LET g_wc =g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 ='1=1'     
   ELSE
      CONSTRUCT g_wc2 ON ohi02,ohi03,ohi04   
              FROM s_ohi[1].ohi02,s_ohi[1].ohi03,s_ohi[1].ohi04
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ohi04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ohi04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ohi04
                  NEXT FIELD ohi04
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
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
    END IF
 
  #IF g_wc2 = "1=1" THEN
   IF g_wc2 = " 1=1" THEN    #MOD-B80074
      LET g_sql = "SELECT  oah01 FROM oah_file ",   #liuxqa 091021
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY oah01"
   ELSE
      LET g_sql = "SELECT UNIQUE oah01 ",           #liuxqa 091021
                  "  FROM oah_file, ohi_file ",
                  " WHERE oah01 = ohi01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY oah01"
   END IF
 
   PREPARE i060_prepare FROM g_sql
   DECLARE i060_cs
       SCROLL CURSOR WITH HOLD FOR i060_prepare
 
  #IF g_wc2 = "1=1" THEN
   IF g_wc2 = " 1=1" THEN   #MOD-B80074
      LET g_sql="SELECT COUNT(*) FROM oah_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(*) FROM oah_file,ohi_file WHERE ",
                "ohi01=oah01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i060_precount FROM g_sql
   DECLARE i060_count CURSOR FOR i060_precount
 
END FUNCTION
 
FUNCTION i060_menu()
   DEFINE l_partnum    STRING
   DEFINE l_supplierid STRING
   DEFINE l_status     LIKE type_file.num10
 
   WHILE TRUE
      CALL i060_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i060_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i060_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i060_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i060_u()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i060_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i060_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i060_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ohi),'','')
            END IF
            
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_oah.oah01 IS NOT NULL THEN
                 LET g_doc.column1 = "oah01"
                 LET g_doc.value1 = g_oah.oah01
                 CALL cl_doc()
               END IF
         END IF
         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i060_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ohi TO s_ohi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION first
         CALL i060_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i060_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i060_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i060_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL i060_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
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
 
      ON ACTION controls       
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i060_bp_refresh()
  DISPLAY ARRAY g_ohi TO s_ohi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
  END DISPLAY
 
END FUNCTION
FUNCTION i060_a()
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_azp02     LIKE azp_file.azp02
  
   MESSAGE ""
   CLEAR FORM
   CALL g_ohi.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_oah.* LIKE oah_file.*
   LET g_oah01_t = NULL
 
   LET g_oah_t.* = g_oah.*
   LET g_oah_o.* = g_oah.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_oah.oah04 = 'N' 
      LET g_oah.oah07 = 'N'   #FUN-B70058 add
      LET g_oah.oah05 = 'N'
      LET g_oah.oah06 = 'N'
      LET g_oah.oah08 = 'Y'   #FUN-C40089
      CALL i060_i("a")
 
      IF INT_FLAG THEN
         INITIALIZE g_oah.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_oah.oah01) THEN
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      INSERT INTO oah_file VALUES (g_oah.*)
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("ins","oah_file",g_oah.oah01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_oah.oah01,'I')
      END IF
 
      LET g_oah01_t = g_oah.oah01
      LET g_oah_t.* = g_oah.*
      LET g_oah_o.* = g_oah.*
      CALL g_ohi.clear()
 
      LET g_rec_b = 0
      CALL i060_b()
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i060_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
 
   IF g_oah.oah01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_oah.* FROM oah_file
    WHERE oah01=g_oah.oah01
 
   CALL cl_opmsg('u')
   LET g_oah01_t = g_oah.oah01
 
   BEGIN WORK
 
   OPEN i060_cl USING g_oah.oah01   #liuxqa 091021
 
   IF STATUS THEN
      CALL cl_err("OPEN i060_cl:", STATUS, 1)
      CLOSE i060_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i060_cl INTO g_oah.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_oah.oah01,SQLCA.sqlcode,0)
       CLOSE i060_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i060_show()
 
   WHILE TRUE
      LET g_oah01_t = g_oah.oah01
      LET g_oah_o.* = g_oah.*
 
      CALL i060_i("u")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_oah.*=g_oah_t.*
         CALL i060_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_oah.oah01 != g_oah01_t THEN
         UPDATE ohi_file SET ohi01 = g_oah.oah01
           WHERE ohi01 = g_oah01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ohi_file",g_oah01_t,"",SQLCA.sqlcode,"","ohi",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE oah_file SET oah_file.* = g_oah.*
       WHERE oah01 = g_oah01_t    #liuxqa 091021
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","oah_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i060_cl
   COMMIT WORK
   CALL cl_flow_notify(g_oah.oah01,'U')
   CALL i060_b_fill("1=1")
 
END FUNCTION
 
FUNCTION i060_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,
   p_cmd     LIKE type_file.chr1 
   
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_oah.oah01,g_oah.oah02,g_oah.oah04,
                   g_oah.oah07,  #FUN-B70058 add
                   g_oah.oah05,g_oah.oah06
                   ,g_oah.oah08  #FUN-C40089
 
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_oah.oah01,g_oah.oah02,g_oah.oah04,
                 g_oah.oah07,  #FUN-B70058 add
                 g_oah.oah05,g_oah.oah06
                 ,g_oah.oah08  #FUN-C40089
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i060_set_entry(p_cmd)
         CALL i060_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD oah01
         IF NOT cl_null(g_oah.oah01) THEN
            IF p_cmd='a' OR 
               (p_cmd='u' AND g_oah.oah01 != g_oah_t.oah01) THEN
               SELECT COUNT(*) INTO l_n FROM oah_file
                  WHERE oah01=g_oah.oah01
               IF l_n > 0 THEN
                  CALL cl_err(g_oah.oah01,'-239',0)
                  NEXT FIELD oah01
               END IF
            END IF
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION HELP
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
FUNCTION i060_ohi04()
 
   LET g_errno = " "
   #FUN-AB0083 mark begin------------------------------
   #SELECT rzz02,rzz03
   #  INTO g_ohi[l_ac].ohi04_desc,g_ohi[l_ac].rzz03
   #  FROM rzz_file 
   #WHERE rzz01 = g_ohi[l_ac].ohi04
   #  AND rzz00 = '2'
   #FUN-AB0083 mark end------------------------------
   
   #FUN-AB0083 add begin------------------------------
   IF g_ohi[l_ac].ohi04 MATCHES "A*" THEN
      LET g_ohi[l_ac].type = "A"
   END IF
   IF g_ohi[l_ac].ohi04 MATCHES "B*" THEN
      LET g_ohi[l_ac].type = "B"
   END IF
   IF g_ohi[l_ac].ohi04 MATCHES "C*" THEN
      LET g_ohi[l_ac].type = "C"
   END IF
   #FUN-AB0083 add end------------------------------
   #FUN-AB0083 mark begin------------------------------
   #CASE WHEN SQLCA.SQLCODE = 100  
   #               LET g_errno = 'axm-183'
   #          OTHERWISE         
   #               LET g_errno = SQLCA.SQLCODE USING '-------'
   #               #DISPLAY g_ohi[l_ac].ohi04_desc TO FORMONLY.ohi04_desc   #FUN-AB0083 mark
   #               DISPLAY BY NAME g_ohi[l_ac].type   #FUN-AB0083 add
   #END CASE
   #FUN-AB0083 mark end------------------------------
   DISPLAY BY NAME g_ohi[l_ac].type   #FUN-AB0083 add
   #No.FUN-960130 bnlent mark begin..
   #未来取价都是通用的，不分业态!
   #IF cl_null(g_errno) THEN
   #   IF g_ohi[l_ac].ohi04 = 'C1' AND g_azw.azw04 <> '3' THEN
   #      LET g_errno = 'axm-524'
   #   END IF
   #   IF (g_ohi[l_ac].ohi04 = 'A2' OR g_ohi[l_ac].ohi04 = 'C4' OR
   #       g_ohi[l_ac].ohi04 = 'C2') AND g_azw.azw04 <> '2' THEN
   #      LET g_errno = 'axm-532'
   #   END IF
   #END IF
   #No.FUN-960130 bnlent mark end..
END FUNCTION
 
FUNCTION i060_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ohi.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i060_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_oah.* TO NULL
      RETURN
   END IF
 
   OPEN i060_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_oah.* TO NULL
   ELSE
      OPEN i060_count
      FETCH i060_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i060_fetch('F')
   END IF
 
END FUNCTION
 
FUNCTION i060_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i060_cs INTO g_oah.oah01
      WHEN 'P' FETCH PREVIOUS i060_cs INTO g_oah.oah01
      WHEN 'F' FETCH FIRST    i060_cs INTO g_oah.oah01
      WHEN 'L' FETCH LAST     i060_cs INTO g_oah.oah01
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
        FETCH ABSOLUTE g_jump i060_cs INTO g_oah.oah01
        LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oah.oah01,SQLCA.sqlcode,0)
      INITIALIZE g_oah.* TO NULL
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
 
   SELECT * INTO g_oah.* FROM oah_file WHERE oah01 = g_oah.oah01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","oah_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_oah.* TO NULL
      RETURN
   END IF
 
   CALL i060_show()
 
END FUNCTION
 
FUNCTION i060_show()
DEFINE  l_gen02  LIKE gen_file.gen02
 
   LET g_oah_t.* = g_oah.*
   LET g_oah_o.* = g_oah.*
   DISPLAY BY NAME g_oah.oah01,g_oah.oah02,g_oah.oah04,
                   g_oah.oah07,  #FUN-B70058 add
                   g_oah.oah05,g_oah.oah06
                   ,g_oah.oah08  #FUN-C40089
   CALL i060_b_fill(g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i060_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_oah.oah01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i060_cl USING g_oah.oah01   #liuxqa 091021
   IF STATUS THEN
      CALL cl_err("OPEN i060_cl:", STATUS, 1)
      CLOSE i060_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i060_cl INTO g_oah.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oah.oah01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i060_show()
 
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "oah01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_oah.oah01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM oah_file WHERE oah01 = g_oah.oah01
      DELETE FROM ohi_file WHERE ohi01 = g_oah.oah01
      CLEAR FORM
      CALL g_ohi.clear()
      OPEN i060_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i060_cs
         CLOSE i060_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      FETCH i060_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i060_cs
         CLOSE i060_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i060_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i060_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i060_fetch('/')
      END IF
   END IF
 
   CLOSE i060_cl
   COMMIT WORK
   CALL cl_flow_notify(g_oah.oah01,'D')
END FUNCTION
 
FUNCTION i060_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_t      LIKE type_file.num5            #No.FUN-A10012
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE  l_line    LIKE type_file.num5
DEFINE  l_exit_flag    LIKE type_file.chr1
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_oah.oah01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_oah.* FROM oah_file
     WHERE oah01=g_oah.oah01
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ohi02,ohi03,ohi04,'','' ", 
                       "  FROM ohi_file ",
                       " WHERE ohi01 = ? AND ohi02 = ? ",
                       "   AND ohi03 = ?  FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i060_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_line = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ohi WITHOUT DEFAULTS FROM s_ohi.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i060_cl USING g_oah.oah01   #liuxqa 091021
           IF STATUS THEN
              CALL cl_err("OPEN i060_cl:", STATUS, 1)
              CLOSE i060_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i060_cl INTO g_oah.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_oah.oah01,SQLCA.sqlcode,0)
              CLOSE i060_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_ohi_t.* = g_ohi[l_ac].*  #BACKUP
              LET g_ohi_o.* = g_ohi[l_ac].*  #BACKUP
              OPEN i060_bcl USING g_oah.oah01,g_ohi_t.ohi02,g_ohi_t.ohi03
              IF STATUS THEN
                 CALL cl_err("OPEN i060_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i060_bcl INTO g_ohi[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ohi_t.ohi02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i060_ohi04() 
              END IF
          END IF 
           
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_ohi[l_ac].* TO NULL
           INITIALIZE g_ohi_t.* TO NULL
           INITIALIZE g_ohi_o.* TO NULL
           IF l_ac >= 2 THEN
              LET g_ohi[l_ac].ohi02 = g_ohi[l_ac-1].ohi02
           ELSE
              LET g_ohi[l_ac].ohi02 =  1            #Body default
           END IF
           NEXT FIELD ohi02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO ohi_file(ohi01,ohi02,ohi03,ohi04)   
           VALUES(g_oah.oah01,g_ohi[l_ac].ohi02,
                  g_ohi[l_ac].ohi03,g_ohi[l_ac].ohi04)   
                 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("ins","ohi_file",g_oah.oah01,g_ohi[l_ac].ohi02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        AFTER FIELD ohi02
           IF NOT cl_null(g_ohi[l_ac].ohi02) THEN
              IF g_ohi[l_ac].ohi02 != g_ohi_t.ohi02
                 OR g_ohi_t.ohi02 IS NULL THEN
                 CALL i060_ohi_check()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_ohi[l_ac].ohi02 = g_ohi_t.ohi02
                    NEXT FIELD ohi02
                 END IF
                 CALL i060_first_a()              
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_ohi[l_ac].ohi02 = g_ohi_t.ohi02
                    NEXT FIELD ohi02
                 END IF
              END IF
           END IF
 
      BEFORE FIELD ohi03
         IF cl_null(g_ohi[l_ac].ohi03) THEN 
            SELECT MAX(ohi03) INTO l_n FROM ohi_file 
                WHERE ohi01 = g_oah.oah01
                  AND ohi02 = g_ohi[l_ac].ohi02
            IF l_n IS NULL THEN LET l_n = 0 END IF
            LET g_ohi[l_ac].ohi03 = l_n + 1
         END IF 
      AFTER FIELD ohi03
         IF NOT cl_null(g_ohi[l_ac].ohi03) THEN
            IF g_ohi_o.ohi03 IS NULL OR
               (g_ohi[l_ac].ohi03 != g_ohi_o.ohi03 ) THEN 
               CALL i060_ohi_check()              
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ohi[l_ac].ohi03,g_errno,0)
                  LET g_ohi[l_ac].ohi03 = g_ohi_o.ohi03
                  DISPLAY BY NAME g_ohi[l_ac].ohi03
                  NEXT FIELD ohi03
               END IF
               CALL i060_first_a()              
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ohi[l_ac].ohi03,g_errno,0)
                  LET g_ohi[l_ac].ohi03 = g_ohi_o.ohi03
                  DISPLAY BY NAME g_ohi[l_ac].ohi03
                  NEXT FIELD ohi03
               END IF
            END IF  
            #TQC-B50128 add ---begin---
            IF p_cmd = 'u' THEN
               LET l_n = 0
               SELECT MIN(ohi03) INTO l_n FROM ohi_file  
                WHERE ohi01 = g_oah.oah01
                  AND ohi02 = g_ohi[l_ac].ohi02
                  AND ohi03 <> g_ohi_o.ohi03
               IF l_n < g_ohi[l_ac].ohi03 AND g_ohi[l_ac].ohi04 MATCHES "A*" THEN              
                  CALL cl_err('','axm-523',0)        
                  LET g_ohi[l_ac].ohi03 = g_ohi_o.ohi03
                  DISPLAY BY NAME g_ohi[l_ac].ohi03
                  NEXT FIELD ohi03
               END IF  
            END IF            
            #TQC-B50128 add ----end----
         END IF  
 
        AFTER FIELD ohi04
           IF NOT cl_null(g_ohi[l_ac].ohi04) THEN
              IF g_ohi_o.ohi04 IS NULL OR
                 (g_ohi[l_ac].ohi04 != g_ohi_o.ohi04 ) THEN 
                 #FUN-AB0083 mark begin------------------ 
                 #CALL i060_ohi04()              
                 #IF NOT cl_null(g_errno) THEN
                 #   CALL cl_err(g_ohi[l_ac].ohi04,g_errno,0)
                 #   LET g_ohi[l_ac].ohi04 = g_ohi_o.ohi04
                 #   DISPLAY BY NAME g_ohi[l_ac].ohi04
                 #   NEXT FIELD ohi04
                 #END IF
                 #FUN-AB0083 mark end------------------ 
                 #判斷每組的第一項都是A類基礎價格
                 CALL i060_first_a()              
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ohi[l_ac].ohi04,g_errno,0)
                    LET g_ohi[l_ac].ohi04 = g_ohi_o.ohi04
                    DISPLAY BY NAME g_ohi[l_ac].ohi04
                    NEXT FIELD ohi04
                 END IF
                 #No.FUN-A10012--begin    
                 IF NOT cl_null(g_ohi[l_ac].ohi02) THEN
                    FOR l_t=1 TO g_rec_b
                       IF g_ohi[l_ac].ohi02=g_ohi[l_t].ohi02 AND l_ac !=l_t THEN
                          IF g_ohi[l_ac].ohi04=g_ohi[l_t].ohi04 THEN
                             LET g_errno="art-617" 
                             EXIT FOR
                          END IF 
                       END IF    
                    END FOR
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_ohi[l_ac].ohi04,g_errno,0)
                       LET g_ohi[l_ac].ohi04 = g_ohi_o.ohi04
                       DISPLAY BY NAME g_ohi[l_ac].ohi04
                       NEXT FIELD ohi04
                    END IF 
                 END IF   
                 #No.FUN-A10012--end  
              #END IF     #TQC-B50137
              #MOD-B30096 add ---begin---
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM ohi_file  
               WHERE ohi01 = g_oah.oah01
                 AND ohi02 = g_ohi[l_ac].ohi02
                 AND ohi04 LIKE 'A%'
              IF l_n<>0 AND g_ohi[l_ac].ohi04 MATCHES "A*" THEN             
                 IF g_ohi_o.ohi04 NOT MATCHES "A*" OR cl_null(g_ohi_o.ohi04) THEN  #TQC-B50137
                    CALL cl_err('','axm-264',1)        
                    NEXT FIELD ohi04
                 END IF           #TQC-B50137 
              END IF    
              #MOD-B30096 add ----end----
              END IF     #TQC-B50137
           END IF
        #No.FUN-AB0083--- ADD begin--------------
        ON CHANGE ohi04
           IF NOT cl_null(g_ohi[l_ac].ohi04) THEN
              CALL i060_ohi04()              
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ohi[l_ac].ohi04,g_errno,0)
                 LET g_ohi[l_ac].ohi04 = g_ohi_o.ohi04
                 DISPLAY BY NAME g_ohi[l_ac].ohi04
                 NEXT FIELD ohi04
              END IF
           END IF
        #No.FUN-AB0083--- ADD end--------------
           
        BEFORE DELETE
           DISPLAY "BEFORE DELETE"
           IF g_ohi_t.ohi02 > 0 AND g_ohi_t.ohi02 IS NOT NULL 
              AND g_ohi_t.ohi03 > 0 AND g_ohi_t.ohi03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM ohi_file
               WHERE ohi01 = g_oah.oah01
                 AND ohi02 = g_ohi_t.ohi02
                 AND ohi03 = g_ohi_t.ohi03 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ohi_file",g_oah.oah01,g_ohi_t.ohi02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              INITIALIZE g_ohi_t.* TO NULL
              INITIALIZE g_ohi_o.* TO NULL
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ohi[l_ac].* = g_ohi_t.*
              CLOSE i060_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ohi[l_ac].ohi02,-263,1)
              LET g_ohi[l_ac].* = g_ohi_t.*
           ELSE
              UPDATE ohi_file SET ohi02=g_ohi[l_ac].ohi02,
                                  ohi03=g_ohi[l_ac].ohi03,
                                  ohi04=g_ohi[l_ac].ohi04
               WHERE ohi01=g_oah.oah01
                 AND ohi02=g_ohi_t.ohi02 
                 AND ohi03=g_ohi_t.ohi03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ohi_file",g_oah.oah01,g_ohi_t.ohi02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_ohi[l_ac].* = g_ohi_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ohi[l_ac].* = g_ohi_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_ohi.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF
              #IF NOT i060_check() THEN
              #   CALL cl_err('','axm-264',1)
              #   NEXT FIELD ohi02
              #END IF 
              IF i060_check() THEN
                 CLOSE i060_bcl
                 ROLLBACK WORK
                 EXIT INPUT
              END IF
           END IF
           LET l_ac_t = l_ac   #FUN-D30034 add
           CLOSE i060_bcl
           COMMIT WORK
        AFTER INPUT
           IF NOT i060_check() THEN
              CALL cl_err('','axm-264',1)
              NEXT FIELD ohi02
           END IF 
        ON ACTION CONTROLO
           IF INFIELD(ohi02) AND l_ac > 1 THEN
              LET g_ohi[l_ac].* = g_ohi[l_ac-1].*
              LET g_ohi[l_ac].ohi02 = g_rec_b + 1
              NEXT FIELD ohi02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
        
        #No.FUN-AB0083 mark---Begin--------------     
        #ON ACTION controlp
        #   CASE
        #      WHEN INFIELD(ohi04)
        #         CALL cl_init_qry_var()
        #         LET g_qryparam.form = "q_rzz01"
        #         LET g_qryparam.arg1 = "2"
        #         LET g_qryparam.default1 = g_ohi[l_ac].ohi04
        #         CALL cl_create_qry() RETURNING g_ohi[l_ac].ohi04
        #         DISPLAY BY NAME g_ohi[l_ac].ohi04
        #         CALL i060_ohi04()
        #         NEXT FIELD ohi04
        #       OTHERWISE EXIT CASE
        #    END CASE
        #No.FUN-AB0083 mark---end--------------  
 
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
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")
    END INPUT
    
    CLOSE i060_bcl
    COMMIT WORK
#   CALL i060_delall()        #CHI-C30002 mark
    CALL i060_delHeader()     #CHI-C30002 add
 
END FUNCTION
#判斷每組的最小順序是否為A類價格代碼
FUNCTION i060_first_a() 
DEFINE l_n        LIKE type_file.num5
#DEFINE l_rzz03   LIKE rzz_file.rzz03   #FUN-AB0083 mark
DEFINE l_type     LIKE type_file.chr1   #FUN-AB0083 add
 
   LET g_errno = ' '
   IF cl_null(g_ohi[l_ac].ohi03) OR 
      cl_null(g_ohi[l_ac].ohi04) OR
      cl_null(g_ohi[l_ac].ohi02) THEN 
      RETURN 
   END IF 
   SELECT MIN(ohi03) INTO l_n FROM ohi_file 
       WHERE ohi01 = g_oah.oah01
         AND ohi02 = g_ohi[l_ac].ohi02   #MOD-A40038
         AND ohi03 < g_ohi[l_ac].ohi03   #MOD-A40038
         #GROUP BY ohi02   #MOD-A40038
   IF l_n IS NULL THEN LET l_n = 0 END IF
   #l_n=0表示每組新增的第一個順序
   IF l_n = 0 OR l_n = g_ohi[l_ac].ohi03 THEN
      #SELECT rzz03 INTO l_rzz03 FROM rzz_file              #FUN-AB0083 mark
      #    WHERE rzz00 = '2' AND rzz01 = g_ohi[l_ac].ohi04  #FUN-AB0083 mark
      
      #FUN-AB0083 add begin------------------------------
      IF g_ohi[l_ac].ohi04 MATCHES "A*" THEN
         LET l_type = "A"
      END IF
      IF g_ohi[l_ac].ohi04 MATCHES "B*" THEN
         LET l_type = "B"
      END IF
      IF g_ohi[l_ac].ohi04 MATCHES "C*" THEN
         LET l_type = "C"
      END IF
      #FUN-AB0083 add end------------------------------
      #IF l_rzz03 IS NULL THEN LET l_rzz03 = ' ' END IF         #FUN-AB0083 mark
      #IF l_rzz03 <> 'A' THEN LET g_errno = 'axm-523' END IF    #FUN-AB0083 mark
      IF l_type IS NULL THEN LET l_type = ' ' END IF         #FUN-AB0083 add
      IF l_type <> 'A' THEN LET g_errno = 'axm-523' END IF   #FUN-AB0083 add
   END IF
END FUNCTION
FUNCTION i060_check()
DEFINE l_ohi02    LIKE ohi_file.ohi02   
DEFINE l_n        LIKE type_file.num5
 
   #檢查每組必須且只能具有一筆A類的類的資料
   LET g_sql = "SELECT ohi02 FROM ohi_file ",
               "   WHERE ohi01 = '",g_oah.oah01,"'",
               "     GROUP BY ohi02 "
   PREPARE pre_sel_ohi FROM g_sql
   DECLARE cur_ohi CURSOR FOR pre_sel_ohi
 
   FOREACH cur_ohi INTO l_ohi02
      IF SQLCA.SQLCODE THEN
         CALL cl_err('',SQLCA.SQLCODE,1)
         RETURN FALSE
      END IF
      #FUN-AB0083 mark begin----------------
      #SELECT COUNT(*) INTO l_n FROM rzz_file,ohi_file
      #    WHERE rzz00 = '2' AND rzz01 = ohi04
      #      AND ohi01 = g_oah.oah01
      #      AND ohi02 = l_ohi02
      #      AND rzz03 = 'A'
      #FUN-AB0083 mark end------------------
      
      #FUN-AB0083 add begin----------------
      SELECT COUNT(*) INTO l_n FROM ohi_file  
       WHERE ohi01 = g_oah.oah01
         AND ohi02 = l_ohi02
         AND ohi04 LIKE 'A%'
      #FUN-AB0083 add end------------------
      IF l_n IS NULL THEN LET l_n = 0 END IF
      IF l_n <> 1 THEN RETURN FALSE END IF
   END FOREACH
 
   RETURN TRUE
END FUNCTION
 
FUNCTION i060_ohi_check()
DEFINE l_n    LIKE type_file.num5
 
   LET g_errno = ' '
   IF cl_null(g_ohi[l_ac].ohi03) OR 
      cl_null(g_ohi[l_ac].ohi02) THEN 
      RETURN 
   END IF 
       
   SELECT count(*) INTO l_n
      FROM ohi_file
     WHERE ohi01 = g_oah.oah01
       AND ohi02 = g_ohi[l_ac].ohi02
       AND ohi03 = g_ohi[l_ac].ohi03
   IF l_n > 0 THEN LET g_errno = -239 END IF  
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i060_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM  oah_file WHERE oah01 = g_oah.oah01
         INITIALIZE g_oah.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i060_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM ohi_file
#     WHERE ohi01 = g_oah.oah01
#
#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM oah_file WHERE oah01 = g_oah.oah01
#     CALL g_ohi.clear()
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i060_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   #LET g_sql = "SELECT ohi02,ohi03,ohi04,'','' ",   #FUN-AB0083 mark
   LET g_sql = "SELECT ohi02,ohi03,ohi04,'' ",   #FUN-AB0083 add
               "  FROM ohi_file",
               " WHERE ohi01 ='",g_oah.oah01,"' "
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY ohi02,ohi03 "
 
   DISPLAY g_sql
 
   PREPARE i060_pb FROM g_sql
   DECLARE ohi_cs CURSOR FOR i060_pb
 
   CALL g_ohi.clear()
   LET g_cnt = 1
 
   FOREACH ohi_cs INTO g_ohi[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #FUN-AB0083 mark begin------------------------------
       #SELECT rzz02,rzz03
       #   INTO g_ohi[g_cnt].ohi04_desc,g_ohi[g_cnt].rzz03
       #   FROM rzz_file 
       # WHERE rzz01 = g_ohi[g_cnt].ohi04
       #   AND rzz00 = '2'
       #FUN-AB0083 mark end------------------------------
       
       #FUN-AB0083 add begin------------------------------
       IF g_ohi[g_cnt].ohi04 MATCHES "A*" THEN
          LET g_ohi[g_cnt].type = "A"
       END IF
       IF g_ohi[g_cnt].ohi04 MATCHES "B*" THEN
          LET g_ohi[g_cnt].type = "B"
       END IF
       IF g_ohi[g_cnt].ohi04 MATCHES "C*" THEN
          LET g_ohi[g_cnt].type = "C"
       END IF
       #FUN-AB0083 add end------------------------------
  
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ohi.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i060_copy()
   DEFINE l_newno     LIKE oah_file.oah01,
          l_oldno     LIKE oah_file.oah01,
          li_result   LIKE type_file.num5,
          l_n         LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_oah.oah01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i060_set_entry('a')
 
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM oah01
 
       AFTER FIELD oah01
          IF l_newno IS NOT NULL THEN 
             SELECT COUNT(*) INTO l_n FROM oah_file
                 WHERE oah01=l_newno
             IF l_n > 0 THEN
                CALL cl_err(l_newno,'-239',0)
                NEXT FIELD oah01
             END IF 
          END IF
 
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_oah.oah01
      ROLLBACK WORK
      RETURN
   END IF
   BEGIN WORK
 
   DROP TABLE y
 
   SELECT * FROM oah_file
       WHERE oah01=g_oah.oah01
       INTO TEMP y
 
   UPDATE y
       SET oah01=l_newno
           
   INSERT INTO oah_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","oah_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM ohi_file
       WHERE ohi01=g_oah.oah01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x SET ohi01=l_newno
 
   INSERT INTO ohi_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ohi_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK 
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_oah.oah01
   SELECT oah_file.* INTO g_oah.* FROM oah_file WHERE oah01 = l_newno   #liuxqa 091021
   CALL i060_u()
   CALL i060_b()
   #SELECT oah_file.* INTO g_oah.* FROM oah_file WHERE oah01 = l_oldno   #liuxqa 091021 #FUN-C80046 
   #CALL i060_show()  #FUN-C80046 
 
END FUNCTION
 
#MOD-AC0399 -------------------------------Begin----------------------------
#FUNCTION i060_out()
#DEFINE l_cmd   LIKE type_file.chr1000                                                                                           
#    IF g_wc IS NULL AND g_oah.oah01 IS NOT NULL THEN
#      # LET g_wc = "oah01='",g_oah.oah01,"'"   #No.MOD-AC0399
#       LET g_wc = 'oah01="',g_oah.oah01,'"'   #No.MOD-AC0399
#    END IF        
    
#   IF g_wc IS NULL THEN
#      CALL cl_err('','9057',0)
#      RETURN
#   END IF
                                                                                                                 
#   IF g_wc2 IS NULL THEN                                                                                                           
#      LET g_wc2 ='1=1'                                                                                                     
#   END IF                                                                                                                   
# #  LET l_cmd='p_query "axmi060" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'     #No.MOD-AC0399
#   LET l_cmd="p_query axmi060 ",
#             " '",g_wc CLIPPED,"'",
#             " '",g_wc2 CLIPPED,"'",
#             " '",g_lang,"'" #No.MOD-AC0399
#   CALL cl_cmdrun(l_cmd)
#END FUNCTION
FUNCTION i060_out()
   DEFINE l_name        LIKE type_file.chr20,
          l_name1       LIKE type_file.chr20,
          l_time        LIKE type_file.chr8,
          l_sql         STRING,
          l_sql1        STRING,  
          l_chr         LIKE type_file.chr1,
          l_za05        LIKE type_file.chr1000,
          sr            RECORD
                        oah01  LIKE oah_file.oah01,
                        oah02  LIKE oah_file.oah02,
                        oah03  LIKE oah_file.oah03,
                        oah04  LIKE oah_file.oah04,    
                        oah07  LIKE oah_file.oah07,   #FUN-B70058 add  
                        oah05  LIKE oah_file.oah05,
                        oah06  LIKE oah_file.oah06,
                        oah08  LIKE oah_file.oah08,   #FUN-C40089
                        ohi02  LIKE ohi_file.ohi02,
                        ohi03  LIKE ohi_file.ohi03,
                        ohi04  LIKE obb_file.obb02,
                        type   LIKE oha_file.oha10
                        END RECORD 
   DEFINE l_prog_name   STRING 
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

   LET l_sql = "SELECT ohi02,ohi03,ohi04,'' ",  
               "  FROM ohi_file",
               " WHERE ohi01 ='",g_oah.oah01,"' "
   PREPARE ohi_pre FROM l_sql
   DECLARE ohi_sr CURSOR WITH HOLD FOR ohi_pre
   
   IF cl_null(g_wc) AND cl_null(g_wc2) AND (g_oah.oah01 <> ' ' OR g_oah.oah01 IS NOT NULL) THEN
      LET g_str = "oah01 = '",g_oah.oah01,"'"
     #FUN-B70058 mod  此写法存在隐患
     #SELECT * INTO sr.oah01,sr.oah02,sr.oah03,sr.oah04,sr.oah05,sr.oah06 FROM oah_file
      SELECT oah01,oah02,oah03,oah04,oah07,oah05,oah06,oah08  #FUN-C40089 add oah08
        INTO sr.oah01,sr.oah02,sr.oah03,sr.oah04,sr.oah07,sr.oah05,sr.oah06,sr.oah08  #FUN-C40089 add oah08
        FROM oah_file
     #FUN-B70058 mod--end
       WHERE oah01 = g_oah.oah01
      FOREACH ohi_sr INTO sr.ohi02,sr.ohi03,sr.ohi04,sr.type
         IF SQLCA.sqlcode  THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF sr.ohi04 MATCHES "A*" THEN
            LET sr.type = "A"
            LET l_prog_name = "type_A"
         END IF
         IF sr.ohi04 MATCHES "B*" THEN
            LET sr.type = "B"
            LET l_prog_name = "type_B"
         END IF
         IF sr.ohi04 MATCHES "C*" THEN
            LET sr.type = "C"
            LET l_prog_name = "type_C"
         END IF
         CALL  get_field_name1(l_prog_name,"axmi060") RETURNING  l_prog_name
         LET sr.type = sr.type,':',l_prog_name
         CASE sr.ohi04
            WHEN  "A1"
               LET l_prog_name = "ohi04_A1"
            WHEN  "A2"
               LET l_prog_name = "ohi04_A2"
            WHEN  "A3"
               LET l_prog_name = "ohi04_A3"
            WHEN  "A4"
               LET l_prog_name = "ohi04_A4"
            WHEN  "A5"
               LET l_prog_name = "ohi04_A5"
            WHEN  "A6"
               LET l_prog_name = "ohi04_A6"
            WHEN  "B1"
               LET l_prog_name = "ohi04_B1"
            WHEN  "B2"
               LET l_prog_name = "ohi04_B2"
            WHEN  "C1"
               LET l_prog_name = "ohi04_C1"
            WHEN  "C2"
               LET l_prog_name = "ohi04_C2"
            WHEN  "C3"
               LET l_prog_name = "ohi04_C3"
            WHEN  "C4"
               LET l_prog_name = "ohi04_C4"
         END CASE
         CALL  get_field_name1(l_prog_name,"axmi060") RETURNING  l_prog_name
         LET sr.ohi04 = sr.ohi04,':',l_prog_name
         EXECUTE insert_prep USING sr.*
      END FOREACH
      INITIALIZE sr TO NULL
   ELSE
      IF g_wc2 = "1=1" THEN
        #FUN-B70058 mod 此写法存在隐患
        #LET l_sql = "SELECT * FROM oah_file ", 
         LET l_sql = "SELECT oah01,oah02,oah03,oah04,oah07,oah05,oah06,oah08 FROM oah_file ",  #FUN-C40089 add oah08
        #FUN-B70058 mod--end
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY oah01"
      ELSE
         LET l_sql = "SELECT DISTINCT oah01,oah02,oah03,oah04,oah07,oah05,oah06,oah08 ",  #FUN-B70058 add oah07 #FUN-C40089 add oah08
                     "  FROM oah_file, ohi_file ",
                     " WHERE oah01 = ohi01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY oah01"
      END IF

      PREPARE i060_pre FROM l_sql
      DECLARE i060_sr CURSOR WITH HOLD FOR i060_pre 
      LET l_sql1 = "SELECT ohi02,ohi03,ohi04,'' ",  
                   "  FROM ohi_file",
                   " WHERE ohi01 = ? "
      PREPARE ohi_pre1 FROM l_sql1
      DECLARE ohi_cs1 CURSOR WITH HOLD FOR ohi_pre1
      FOREACH i060_sr INTO sr.oah01,sr.oah02,sr.oah03,sr.oah04,sr.oah07,sr.oah05,sr.oah06,sr.oah08  #FUN-B70058 add oah07  #FUN-C40089 add oah08
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         FOREACH ohi_cs1  USING sr.oah01 
                           INTO sr.ohi02,sr.ohi03,sr.ohi04,sr.type
            IF SQLCA.sqlcode  THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF sr.ohi04 MATCHES "A*" THEN
               LET sr.type = "A"
               LET l_prog_name = "type_A"
            END IF
            IF sr.ohi04 MATCHES "B*" THEN
               LET sr.type = "B"
               LET l_prog_name = "type_B"
            END IF
            IF sr.ohi04 MATCHES "C*" THEN
               LET sr.type = "C"
               LET l_prog_name = "type_C"
            END IF
            CALL  get_field_name1(l_prog_name,"axmi060") RETURNING  l_prog_name
            LET sr.type = sr.type,':',l_prog_name
            CASE sr.ohi04           
               WHEN  "A1"
                  LET l_prog_name = "ohi04_A1"
               WHEN  "A2"
                  LET l_prog_name = "ohi04_A2"
               WHEN  "A3"
                  LET l_prog_name = "ohi04_A3"
               WHEN  "A4"
                  LET l_prog_name = "ohi04_A4"
               WHEN  "A5"
                  LET l_prog_name = "ohi04_A5"
               WHEN  "A6"
                  LET l_prog_name = "ohi04_A6"
               WHEN  "B1"
                  LET l_prog_name = "ohi04_B1"
               WHEN  "B2"
                  LET l_prog_name = "ohi04_B2"
               WHEN  "C1"
                  LET l_prog_name = "ohi04_C1"
               WHEN  "C2"
                  LET l_prog_name = "ohi04_C2"
	       WHEN  "C3"
                  LET l_prog_name = "ohi04_C3"
               WHEN  "C4"
                  LET l_prog_name = "ohi04_C4"
            END CASE
            CALL  get_field_name1(l_prog_name,"axmi060") RETURNING  l_prog_name
            LET sr.ohi04 = sr.ohi04,':',l_prog_name
            EXECUTE insert_prep USING sr.*
         END FOREACH
         INITIALIZE sr TO NULL
      END FOREACH
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
      LET g_str = ''
      IF g_zz05 = 'Y' THEN
         LET tm.wc = g_wc
         LET tm.wc1 = g_wc2
         LET tm.wc = tm.wc CLIPPED," AND ",tm.wc1
         CALL cl_wcchp(tm.wc,'oah01,oah02,ohi02,ohi03,ohi04,type')
              RETURNING tm.wc
         LET g_str = tm.wc
      END IF
   END IF      
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('axmi060','axmi060',l_sql,g_str)
END FUNCTION

FUNCTION get_field_name1(p_field_code,p_prog_code)
   DEFINE p_field_code STRING
   DEFINE p_prog_code  STRING
   DEFINE l_sql        STRING,
          l_gae04      LIKE gae_file.gae04
   LET l_sql = "SELECT gae04 FROM gae_file",
               " WHERE gae02='",p_field_code,"' AND gae01='",p_prog_code,"' AND gae03='",g_lang,"'"
   DECLARE gae_curs SCROLL CURSOR FROM l_sql
   OPEN gae_curs
   FETCH FIRST gae_curs INTO l_gae04
   CLOSE gae_curs
   RETURN l_gae04 CLIPPED
END FUNCTION
#MOD-AC0399 ---------------------------End-----------------------------------
 
FUNCTION i060_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("oah01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i060_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("oah01",FALSE)
    END IF
 
END FUNCTION
