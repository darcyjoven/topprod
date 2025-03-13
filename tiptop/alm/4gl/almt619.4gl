# Prog. Version..: '5.30.06-13.03.12(00006)'     #
# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: almt619.4gl
# Descriptions...: 卡開帳作業 
# Date & Author..: No:FUN-C30176 By pauline 12/06/19
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No:FUN-C90018 12/09/06 By Lori 已兌換積分限輸入小於等於零的數值
# Modify.........: No:FUN-C90102 12/11/02 By pauline 將lsm_file檔案類別改為B.基本資料,將lsmplant用lsmstore取代
#                                                    將lsn_file檔案類別改為B.基本資料,將lsnplant用lsnstore取代
# Modify.........: No:FUN-CB0077 12/11/22 By xumeimei 单档调整为双档
# Modify.........: No:CHI-C80041 12/12/26 By bart 1.增加作廢功能 2.刪除單頭

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_lry       RECORD LIKE lry_file.*,
       g_lry_t     RECORD LIKE lry_file.*,  #備份舊值
       g_lry01_t   LIKE lry_file.lry01,     #Key值備份
       g_wc        STRING,                  #儲存 user 的查詢條件
       g_sql       STRING                  #組 sql 用

DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令
DEFINE g_chr                 LIKE lry_file.lryacti        
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_i                   LIKE type_file.num5          
DEFINE g_msg                 LIKE type_file.chr1000       
DEFINE g_curs_index          LIKE type_file.num10         
DEFINE g_row_count           LIKE type_file.num10         #總筆數
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數
DEFINE g_no_ask              LIKE type_file.num5          #是否開啟指定筆視窗
DEFINE g_void                LIKE type_file.chr1
DEFINE g_confirm             LIKE type_file.chr1
DEFINE g_kindtype            LIKE oay_file.oaytype     
DEFINE g_t1                  LIKE oay_file.oayslip     
DEFINE g_kindslip            LIKE oay_file.oayslip    
#FUN-CB0077----------add-------str
DEFINE g_lsp         DYNAMIC ARRAY OF RECORD
          lsp04      LIKE lsp_file.lsp04,
          lsp03      LIKE lsp_file.lsp03,
          lsp02      LIKE lsp_file.lsp02,
          lsp16      LIKE lsp_file.lsp16,
          lsp15      LIKE lsp_file.lsp15,
          lsp14      LIKE lsp_file.lsp14,
          lsp05      LIKE lsp_file.lsp05,
          lsp06      LIKE lsp_file.lsp06,
          lsp07      LIKE lsp_file.lsp07,
          lsp08      LIKE lsp_file.lsp08,
          lsp09      LIKE lsp_file.lsp09,
          lsp10      LIKE lsp_file.lsp10,
          lsp11      LIKE lsp_file.lsp11,
          lsp12      LIKE lsp_file.lsp12,
          lsp13      LIKE lsp_file.lsp13
                     END RECORD
DEFINE g_lsp_t       RECORD
          lsp04      LIKE lsp_file.lsp04,
          lsp03      LIKE lsp_file.lsp03,
          lsp02      LIKE lsp_file.lsp02,
          lsp16      LIKE lsp_file.lsp16,
          lsp15      LIKE lsp_file.lsp15,
          lsp14      LIKE lsp_file.lsp14,
          lsp05      LIKE lsp_file.lsp05,
          lsp06      LIKE lsp_file.lsp06,
          lsp07      LIKE lsp_file.lsp07,
          lsp08      LIKE lsp_file.lsp08,
          lsp09      LIKE lsp_file.lsp09,
          lsp10      LIKE lsp_file.lsp10,
          lsp11      LIKE lsp_file.lsp11,
          lsp12      LIKE lsp_file.lsp12,
          lsp13      LIKE lsp_file.lsp13
                     END RECORD
DEFINE l_ac          LIKE type_file.num5
DEFINE g_wc2         STRING
DEFINE g_rec_b       LIKE type_file.num5
DEFINE g_rec_b2      LIKE type_file.num5
#FUN-CB0077----------add-------end
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   INITIALIZE g_lry.* TO NULL
   LET g_kindtype = 'Q7' 

   LET g_forupd_sql = "SELECT * FROM lry_file WHERE lry01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t619_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR

   OPEN WINDOW t619_w WITH FORM "alm/42f/almt619"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   LET g_action_choice = ""
   CALL t619_menu()

   CLOSE WINDOW t619_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN 

#FUN-CB0077----------mark--------str
#FUNCTION t619_cs()
#DEFINE ls      STRING
#
#    CLEAR FORM
#    INITIALIZE g_lry.* TO NULL
#    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
#        lryplant,lrylegal,lry01,lry02,lry03,lry05,lry04,lry06,lry07,lry08,
#        lry09,lry10,lry11,lry12,lry13,lry14,lry15,lry16,lry17,lry18,lry19,lry20,
#        lryuser,lrygrup,lryoriu,lrycrat,lrymodu,lryorig,lryacti,lrydate  
#
#        BEFORE CONSTRUCT
#           CALL cl_qbe_init()
#
#        ON ACTION controlp
#           CASE
#              WHEN INFIELD(lryplant)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_lryplant"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO lryplant
#                 NEXT FIELD lryplant
#
#              WHEN INFIELD(lrylegal)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_lrylegal"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO lrylegal
#                 NEXT FIELD lrylegal
#
#              WHEN INFIELD(lry01)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_lry01"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO lry01
#                 NEXT FIELD lry01
#
#              WHEN INFIELD(lry02)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_lry02"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO lry02
#                 NEXT FIELD lry02
#
#              WHEN INFIELD(lry03)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_lry03"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO lry03
#                 NEXT FIELD lry03
#
#              WHEN INFIELD(lry05)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_lry05"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO lry05
#                 NEXT FIELD lry05
#
#              WHEN INFIELD(lry04)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_lry04"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO lry04
#                 NEXT FIELD lry04
#
#              WHEN INFIELD(lry15)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_lry15"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO lry15
#                 NEXT FIELD lry15
#
#              WHEN INFIELD(lry17)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_lry17"          
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO lry17
#                 NEXT FIELD lry17
#
#              WHEN INFIELD(lry19)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_lry19"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO lry19
#                 NEXT FIELD lry19
#              OTHERWISE
#                 EXIT CASE
#           END CASE
#
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
#
#      ON ACTION about
#         CALL cl_about()
#
#      ON ACTION help
#         CALL cl_show_help()
#
#      ON ACTION controlg
#         CALL cl_cmdask()
#
#
#
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#      ON ACTION qbe_save
#                     CALL cl_qbe_save()
#
#    END CONSTRUCT
#
#    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lryuser', 'lrygrup')
#
#    LET g_sql="SELECT lry01 FROM lry_file ", # 組合出 SQL 指令
#        " WHERE ",g_wc CLIPPED, " ",
#        " ORDER BY lry01"
#    PREPARE t619_prepare FROM g_sql
#    DECLARE t619_cs                                # SCROLL CURSOR
#        SCROLL CURSOR WITH HOLD FOR t619_prepare
#    LET g_sql=
#        "SELECT COUNT(*) FROM lry_file WHERE ",g_wc CLIPPED
#    PREPARE t619_precount FROM g_sql
#    DECLARE t619_count CURSOR FOR t619_precount
#END FUNCTION
#
#FUNCTION t619_menu()
#   DEFINE l_cmd  LIKE type_file.chr1000
#   DEFINE l_oayconf LIKE oay_file.oayconf      
#    MENU ""
#        BEFORE MENU
#           CALL cl_navigator_setting(g_curs_index, g_row_count)
#
#        ON ACTION insert
#            LET g_action_choice="insert"
#            IF cl_chk_act_auth() THEN
#                 CALL t619_a()
#                 LET g_t1=s_get_doc_no(g_lry.lry01)
#                 IF NOT cl_null(g_t1) THEN
#                     SELECT oayconf INTO l_oayconf FROM oay_file
#                     WHERE oayslip = g_t1
#                     IF l_oayconf ='Y' THEN
#                       CALL t619_confirm()
#                    END IF
#                 END IF
#            END IF
#
#        ON ACTION query
#            LET g_action_choice="query"
#            IF cl_chk_act_auth() THEN
#                 CALL t619_q()
#            END IF
#
#        ON ACTION next
#            CALL t619_fetch('N')
#
#        ON ACTION previous
#            CALL t619_fetch('P')
#
#        ON ACTION modify
#            LET g_action_choice="modify"
#            IF cl_chk_act_auth() THEN
#                 CALL t619_u('w')
#            END IF
#
#        ON ACTION invalid
#            LET g_action_choice="invalid"
#            IF cl_chk_act_auth() THEN
#               CALL t619_x()
#            END IF
#
#        ON ACTION delete
#            LET g_action_choice="delete"
#            IF cl_chk_act_auth() THEN
#               CALL t619_r()
#            END IF
#
#        ON ACTION confirm
#           LET g_action_choice="confirm"
#           IF cl_chk_act_auth() THEN
#              CALL t619_confirm()
#           END IF
#           CALL t619_pic()
#
#
#        ON ACTION help
#            CALL cl_show_help()
#        ON ACTION exit
#            LET g_action_choice = "exit"
#            EXIT MENU
#        ON ACTION jump
#            CALL t619_fetch('/')
#        ON ACTION first
#            CALL t619_fetch('F')
#        ON ACTION last
#            CALL t619_fetch('L')
#        ON ACTION controlg
#            CALL cl_cmdask()
#        ON ACTION locale
#            CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE MENU
#
#      ON ACTION about
#         CALL cl_about()
#
#
#        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145
#             LET INT_FLAG=FALSE
#           LET g_action_choice = "exit"
#           EXIT MENU
#
#         ON ACTION related_document
#           LET g_action_choice="related_document"
#           IF cl_chk_act_auth() THEN
#              IF g_lry.lry01 IS NOT NULL THEN
#                 LET g_doc.column1 = "lry01"
#                 LET g_doc.value1 = g_lry.lry01
#                 CALL cl_doc()
#              END IF
#           END IF
#
#    END MENU
#    CLOSE t619_cs
#END FUNCTION
#FUN-CB0077----------mark--------end

#FUN-CB0077-----------add--------str
FUNCTION t619_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM
   CALL g_lsp.clear()

   LET g_action_choice=" "
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_lry.* TO NULL
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON lry01,lry02,lryplant,lrylegal,lry18,lry19,lry20,
                                lryuser,lrygrup,lryoriu,lrycrat,lrymodu,
                                lryorig,lryacti,lrydate
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
   
         ON ACTION controlp
            CASE
               WHEN INFIELD(lryplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lryplant"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lryplant
                  NEXT FIELD lryplant

               WHEN INFIELD(lrylegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lrylegal"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lrylegal
                  NEXT FIELD lrylegal

               WHEN INFIELD(lry01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lry01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lry01
                  NEXT FIELD lry01

               WHEN INFIELD(lry02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lry02"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lry02
                  NEXT FIELD lry02

               WHEN INFIELD(lry19)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lry19"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lry19
                  NEXT FIELD lry19
               OTHERWISE
                  EXIT CASE
            END CASE
      END CONSTRUCT
      CONSTRUCT g_wc2 ON lsp04,lsp03,lsp02,lsp16,lsp15,lsp14,lsp05,lsp06,
                         lsp07,lsp08,lsp09,lsp10,lsp11,lsp12,lsp13
                    FROM s_lsp[1].lsp04,s_lsp[1].lsp03,s_lsp[1].lsp02,s_lsp[1].lsp16,
                         s_lsp[1].lsp15,s_lsp[1].lsp14,s_lsp[1].lsp05,s_lsp[1].lsp06,
                         s_lsp[1].lsp07,s_lsp[1].lsp08,s_lsp[1].lsp09,s_lsp[1].lsp10,
                         s_lsp[1].lsp11,s_lsp[1].lsp12,s_lsp[1].lsp13
   
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
   
         ON ACTION controlp
            CASE
               WHEN INFIELD(lsp04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lsp04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lsp04
                  NEXT FIELD lsp04
               WHEN INFIELD(lsp03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lsp03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lsp03
                  NEXT FIELD lsp03
               WHEN INFIELD(lsp02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lsp02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lsp02
                  NEXT FIELD lsp02
               WHEN INFIELD(lsp16)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lsp16"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lsp16
                  NEXT FIELD lsp16
               WHEN INFIELD(lsp14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lsp14"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lsp14
                  NEXT FIELD lsp14
               OTHERWISE EXIT CASE  
            END CASE       
      END CONSTRUCT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION accept
         ACCEPT DIALOG
      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   END DIALOG
   IF INT_FLAG THEN
      RETURN
   END IF
   
   IF NOT cl_null(g_wc2) THEN
      LET g_wc2 = g_wc2 CLIPPED
   ELSE
      LET g_wc2 = " 1=1"
   END IF

   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT lry01 FROM lry_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY lry01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE lry01 ",
                  "  FROM lry_file,lsp_file ",
                  " WHERE lry01 = lsp01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lry01"
   END IF
   PREPARE t619_prepare FROM g_sql
   DECLARE t619_cs  
       SCROLL CURSOR WITH HOLD FOR t619_prepare

   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM lry_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lry01) FROM lry_file,lsp_file WHERE ",
                "lry01 = lsp01 and ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t619_precount FROM g_sql
   DECLARE t619_count CURSOR FOR t619_precount
END FUNCTION

FUNCTION t619_menu()
DEFINE l_oayconf    LIKE oay_file.oayconf   

   WHILE TRUE
      CALL t619_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t619_a()
               LET g_t1=s_get_doc_no(g_lry.lry01)
               IF NOT cl_null(g_t1) THEN
                  SELECT oayconf INTO l_oayconf FROM oay_file
                   WHERE oayslip = g_t1
                  IF l_oayconf ='Y' THEN
                     CALL t619_confirm()
                  END IF
               END IF                      
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t619_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL t619_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL t619_u('u')
            END IF
            
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL t619_x() 
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
                  CALL t619_confirm()
            END IF
             CALL t619_pic()

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_lry.lryacti='N' THEN
                  CALL cl_err('','9028',1)
               END IF
               IF g_lry.lry18='Y' THEN
                  CALL cl_err('','mfg1005',0)
               END IF
               CALL t619_b('d')
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lsp),'','')
            END IF

         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lry.lry01 IS NOT NULL THEN
                    LET g_doc.column1 = "lry01"
                    LET g_doc.value1 = g_lry.lry01
                    CALL cl_doc()
                 END IF
              END IF

         WHEN "from_excel"
            CALL t619_from_excel()
            CALL t619_show()
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t619_v()
               CALL t619_pic()
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
END FUNCTION

FUNCTION t619_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lsp TO s_lsp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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

      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      ON ACTION first
         CALL t619_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION previous
         CALL t619_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION jump
         CALL t619_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION next
         CALL t619_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION last
         CALL t619_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY

      ON ACTION invalid
         LET g_action_choice="invalid"
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

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION from_excel
         LET g_action_choice = 'from_excel'
         EXIT DISPLAY
     
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t619_bp_refresh()
  DISPLAY ARRAY g_lsp TO s_lsp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
END FUNCTION
#FUN-CB0077-----------add--------end
FUNCTION t619_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lry.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t619_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t619_count
    FETCH t619_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t619_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lry.lry01,SQLCA.sqlcode,0)
        INITIALIZE g_lry.* TO NULL
    ELSE
        CALL t619_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


FUNCTION t619_fetch(p_fllrw)
    DEFINE
        p_fllrw         LIKE type_file.chr1

    CASE p_fllrw
        WHEN 'N' FETCH NEXT     t619_cs INTO g_lry.lry01
        WHEN 'P' FETCH PREVIOUS t619_cs INTO g_lry.lry01
        WHEN 'F' FETCH FIRST    t619_cs INTO g_lry.lry01
        WHEN 'L' FETCH LAST     t619_cs INTO g_lry.lry01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t619_cs INTO g_lry.lry01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lry.lry01,SQLCA.sqlcode,0)
        INITIALIZE g_lry.* TO NULL
        RETURN
    ELSE
      CASE p_fllrw
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_lry.* FROM lry_file    # 重讀DB,因TEMP有不被更新特性
       WHERE lry01 = g_lry.lry01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lry_file",g_lry.lry01,"",SQLCA.sqlcode,"","",0)
    ELSE
        LET g_data_owner=g_lry.lryuser
        LET g_data_group=g_lry.lrygrup
        LET g_data_plant=g_lry.lryplant  
        CALL t619_show()                   # 重新顯示
    END IF
END FUNCTION


FUNCTION t619_show()
DEFINE  l_rtz13    LIKE rtz_file.rtz13
DEFINE  l_azt02    LIKE azt_file.azt02
DEFINE  l_gen02    LIKE gen_file.gen02    #FUN-CB0077 add
    LET g_lry_t.* = g_lry.*
   #FUN-CB0077------mark---str
   #DISPLAY BY NAME g_lry.lry01,g_lry.lry02,g_lry.lry03,g_lry.lry04,
   #                g_lry.lry05,g_lry.lry06,g_lry.lry07,g_lry.lry08,
   #                g_lry.lry20,g_lry.lry09,g_lry.lry11,g_lry.lry12,
   #                g_lry.lry13,g_lry.lry14,g_lry.lry15,g_lry.lry16,
   #                g_lry.lry17,g_lry.lry18,g_lry.lry19,g_lry.lry20,
   #                g_lry.lryuser,g_lry.lrygrup,g_lry.lrymodu,g_lry.lrydate,
   #                g_lry.lrycrat,g_lry.lryoriu,g_lry.lryorig,g_lry.lrylegal,
   #                g_lry.lryacti,g_lry.lryplant
   #FUN-CB0077------mark---end

    #FUN-CB0077------add---str
    DISPLAY BY NAME g_lry.lry01,g_lry.lry02,g_lry.lry18,g_lry.lry19,g_lry.lry20,
                    g_lry.lryuser,g_lry.lrygrup,g_lry.lrymodu,g_lry.lrydate,
                    g_lry.lrycrat,g_lry.lryoriu,g_lry.lryorig,g_lry.lrylegal,
                    g_lry.lryacti,g_lry.lryplant
    #FUN-CB0077------add---end
   #CALL t619_lry03('d')
   #CALL t619_lry14('d')
    CALL t619_pic()
    SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lry.lryplant
    SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lry.lrylegal
    DISPLAY l_rtz13 TO FORMONLY.rtz13
    DISPLAY l_azt02 TO FORMONLY.azt02
    #FUN-CB0077-----add-----str
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_lry.lry19
    DISPLAY l_gen02 TO FORMONLY.gen02
    CALL t619_b_fill(g_wc2)
    #FUN-CB0077-----add-----end
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t619_pic()
   CASE g_lry.lry18
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void = ''
      WHEN 'X'  LET g_confirm = ''
                LET g_void = 'Y'
      OTHERWISE LET g_confirm = ''
                LET g_void = ''
   END CASE

   #圖形顯示
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lry.lryacti)
END FUNCTION

FUNCTION t619_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lry01",TRUE)
     END IF

END FUNCTION

FUNCTION t619_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("lry01",FALSE)
    END IF

END FUNCTION

FUNCTION t619_a()
DEFINE  l_count    LIKE type_file.num5
DEFINE  li_result  LIKE type_file.num5
DEFINE  l_rtz13    LIKE rtz_file.rtz13    #FUN-A80148
DEFINE  l_azt02    LIKE azt_file.azt02

    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_lry.* LIKE lry_file.*
    LET g_lry_t.*=g_lry.*
    LET g_lry01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lry.lryplant=g_plant
        LET g_lry.lrylegal =g_legal
        LET g_lry.lryuser = g_user
        LET g_lry.lryoriu = g_user
        LET g_lry.lryorig = g_grup
        LET g_lry.lrygrup = g_grup               #使用者所屬群
        LET g_lry.lrycrat = g_today
        LET g_lry.lryacti = 'Y'
        LET g_lry.lry02 = g_today
        LET g_lry.lry18 ='N'
        #FUN-CB0077----------add------str
        LET g_lry.lry04 = ' '
        LET g_lry.lry05 = ' '
        LET g_lry.lry08 = 0
        LET g_lry.lry09 = 0
        LET g_lry.lry11 = 0
        LET g_lry.lry12 = 0
        LET g_lry.lry13 = 0
        LET g_lry.lry14 = 0
        LET g_lry.lry15 = ' '
        #FUN-CB0077----------add------end
        LET g_data_plant = g_plant 
        CALL t619_lryplant()
        CALL t619_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_lry.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_lsp.clear()
            EXIT WHILE
        END IF
        IF cl_null(g_lry.lry01) THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK
        LET g_success = 'Y'
        CALL s_auto_assign_no("alm",g_lry.lry01,g_lry.lrycrat,g_kindtype,"lry_file","lry01",g_lry.lryplant,"","")
           RETURNING li_result,g_lry.lry01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_lry.lry01
        INSERT INTO lry_file VALUES(g_lry.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lry_file",g_lry.lry01,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        IF g_success = 'N' THEN
           ROLLBACK WORK
           CONTINUE WHILE
        ELSE
           COMMIT WORK
        END IF
        #FUN-CB0077-----add----str
        SELECT lry01 INTO g_lry.lry01 FROM lry_file
         WHERE lry01 = g_lry.lry01
        LET g_lry01_t = g_lry.lry01        #保留舊值
        LET g_lry_t.* = g_lry.*
        CALL g_lsp.clear()
        LET g_rec_b = 0
        CALL t619_b('a') 
        #FUN-CB0077-----add----end
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION t619_lryplant()
DEFINE l_rtz13       LIKE rtz_file.rtz13
DEFINE l_azt02       LIKE azt_file.azt02

   DISPLAY BY NAME g_lry.lryplant
   DISPLAY BY NAME g_lry.lrylegal
   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lry.lryplant
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lry.lrylegal
   DISPLAY l_rtz13 TO FORMONLY.rtz13
   DISPLAY l_azt02 TO FORMONLY.azt02

END FUNCTION

FUNCTION t619_i(p_cmd)
   DEFINE   p_cmd       LIKE type_file.chr1,
            l_input     LIKE type_file.chr1,
            l_n         LIKE type_file.num5,
            l_n1        LIKE type_file.num5,
            l_lph09     LIKE lph_file.lph09,
            l_lph10     LIKE lph_file.lph10,
            l_lph11     LIKE lph_file.lph11,
            l_lph26     LIKE lph_file.lph26
   DEFINE   y1          LIKE type_file.num5
   DEFINE   m1          LIKE type_file.num5
   DEFINE   d1          LIKE type_file.num5
   DEFINE   l_char      LIKE type_file.chr10
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   l_rtz13     LIKE rtz_file.rtz13

  #FUN-CB0077---------mark---str
  # DISPLAY BY NAME g_lry.lry01,g_lry.lry02,g_lry.lry03,g_lry.lry04,
  #                 g_lry.lry05,g_lry.lry06,g_lry.lry07,g_lry.lry08,
  #                 g_lry.lry20,g_lry.lry09,g_lry.lry11,g_lry.lry12,
  #                 g_lry.lry13,g_lry.lry14,g_lry.lry15,g_lry.lry16,
  #                 g_lry.lry17,g_lry.lry18,g_lry.lry19,g_lry.lry20,
  #                 g_lry.lryuser,g_lry.lrygrup,g_lry.lrymodu,g_lry.lrydate,
  #                 g_lry.lrycrat,g_lry.lryoriu,g_lry.lryorig,g_lry.lrylegal,
  #                 g_lry.lryacti,g_lry.lryplant

  #INPUT BY NAME
  #   g_lry.lry01,g_lry.lry02,g_lry.lry03,g_lry.lry05,g_lry.lry04,
  #   g_lry.lry06,g_lry.lry07,g_lry.lry08,g_lry.lry09,g_lry.lry10,
  #   g_lry.lry11,g_lry.lry12,g_lry.lry13,g_lry.lry14,g_lry.lry15,
  #   g_lry.lry16,g_lry.lry17,
  #   g_lry.lryuser,g_lry.lrygrup,g_lry.lrymodu,g_lry.lrydate,
  #   g_lry.lrycrat,g_lry.lryoriu,g_lry.lryorig
  #   WITHOUT DEFAULTS
  #FUN-CB0077---------mark---end

   #FUN-CB0077---------add--------str
   DISPLAY BY NAME g_lry.lry01,g_lry.lry02,g_lry.lry18,g_lry.lry19,g_lry.lry20,
                   g_lry.lryuser,g_lry.lrygrup,g_lry.lrymodu,g_lry.lrydate,
                   g_lry.lrycrat,g_lry.lryoriu,g_lry.lryorig,g_lry.lrylegal,
                   g_lry.lryacti,g_lry.lryplant
   INPUT BY NAME g_lry.lry01,g_lry.lry02,g_lry.lry18,g_lry.lry19,g_lry.lry20,
                 g_lry.lryuser,g_lry.lrygrup,g_lry.lrymodu,g_lry.lrydate,
                 g_lry.lrycrat,g_lry.lryoriu,g_lry.lryorig,g_lry.lrylegal,
                 g_lry.lryacti,g_lry.lryplant 
      WITHOUT DEFAULTS
   #FUN-CB0077---------add--------end
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          LET g_lry_t.* = g_lry.*
          CALL t619_set_entry(p_cmd)
          CALL t619_set_no_entry(p_cmd)
          #CALL t619_entry_lry()   #FUN-CB0077 mark
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("lry01")

      AFTER FIELD lry01
         IF g_lry.lry01 IS NOT NULL THEN
            CALL s_check_no("alm",g_lry.lry01,g_lry01_t,g_kindtype,"lry_file","lry01","")
                 RETURNING li_result,g_lry.lry01
            IF (NOT li_result) THEN
               LET g_lry.lry01=g_lry_t.lry01
               NEXT FIELD lry01
            END IF
            DISPLAY BY NAME g_lry.lry01
         END IF


     #FUN-CB0077----mark---str
     #AFTER FIELD lry03
     #   IF NOT cl_null(g_lry.lry03) THEN
     #     #CALL t619_check()
     #     #CALL t619_lry03()
     #      IF NOT cl_null(g_errno) THEN
     #         CALL cl_err('',g_errno,1)
     #         LET g_lry.lry03 = g_lry_t.lry03
     #         NEXT FIELD lry03
     #      END IF
     #   END IF

     #AFTER FIELD lry04
     #   IF NOT cl_null(g_lry.lry04) THEN
     #      IF p_cmd = 'a' OR 
     #         (p_cmd = 'u' AND g_lry.lry04 <> g_lry_t.lry04) THEN
     #         CALL t619_chk_lry04()
     #         IF NOT cl_null(g_errno) THEN
     #            CALL cl_err('',g_errno,0)
     #            NEXT FIELD lry04
     #         END IF
     #         CALL t619_entry_lry()
     #         IF NOT cl_null(g_lry.lry15) THEN
     #            SELECT COUNT(*) INTO l_n FROM lnk_file
     #             WHERE lnk01 = g_lry.lry04 
     #               AND lnk02 = '1'
     #               AND lnk03 = g_lry.lry15
     #            IF cl_null(l_n) OR l_n = 0 THEN
     #               CALL cl_err('','alm-h51',0)
     #               NEXT FIELD lry15
     #            END IF
     #         END IF
     #         IF NOT cl_null(g_lry.lry17) THEN
     #            SELECT COUNT(*) INTO l_n FROM lnk_file
     #             WHERE lnk01 = g_lry.lry04 
     #               AND lnk02 = '1'
     #               AND lnk03 = g_lry.lry17
     #            IF cl_null(l_n) OR l_n = 0 THEN
     #               CALL cl_err('','alm-h51',0)
     #               NEXT FIELD lry17
     #            END IF
     #         END IF
     #      END IF
     #   END IF

     #AFTER FIELD lry05
     #   IF NOT cl_null(g_lry.lry05) THEN
     #      LET l_n = 0 
     #      SELECT COUNT(*) INTO l_n FROM lpj_file
     #         WHERE lpj03 = g_lry.lry05 
     #      IF l_n > 0 THEN
     #         CALL cl_err('','alm-h45',0)
     #         NEXT FIELD lry05
     #      END IF
     #      CALL t619_chk_lry04()
     #      IF NOT cl_null(g_errno) THEN
     #         CALL cl_err('',g_errno,0)
     #         NEXT FIELD lry05
     #      END IF
     #   END IF 

     #AFTER FIELD lry06 
     #   IF NOT cl_null(g_lry.lry06) THEN
     #      IF g_lry.lry06 > g_today THEN
     #         CALL cl_err('','alm-h47',0)
     #         NEXT FIELD lry06
     #      END IF
     #   END IF

     #AFTER FIELD lry07 
     #   IF NOT cl_null(g_lry.lry07) THEN
     #      IF g_lry.lry07 < g_today THEN
     #         CALL cl_err('','alm-h49',0)
     #         NEXT FIELD lry07
     #      END IF
     #   END IF
    
     #AFTER FIELD lry09 
     #   IF NOT cl_null(g_lry.lry09) THEN
     #      IF g_lry.lry09 < 0 THEN
     #         CALL cl_err('','aec-020',0)
     #         NEXT FIELD lry09
     #      END IF 
     #   END IF

     #AFTER FIELD lry10
     #  IF NOT cl_null(g_lry.lry10) THEN
     #     IF g_lry.lry10 > g_today THEN
     #        CALL cl_err('','alm-h50',0)
     #        NEXT FIELD lry10
     #     END IF
     #     IF NOT cl_null( g_lry.lry06) THEN
     #        IF g_lry.lry10 < g_lry.lry06 THEN
     #           CALL cl_err('','alm-h52',0)
     #           NEXT FIELD lry10
     #        END IF
     #     END IF
     #  END IF
   
     ##FUN-C90018 add begin---
     #AFTER FIELD lry12
     #   IF NOT cl_null(g_lry.lry12) AND g_lry.lry12 > 0 THEN
     #      CALL cl_err('','alm-h72',0)
     #      NEXT FIELD lry12
     #   END IF 
     ##FUN-C90018 add end-----

     #AFTER FIELD lry14
     #   IF NOT cl_null(g_lry.lry14) THEN
     #      IF g_lry.lry14 < 0 THEN
     #         CALL cl_err('','aec-020',0)
     #         NEXT FIELD lry14
     #      END IF
     #   END IF

     #AFTER FIELD lry15
     #   IF NOT cl_null(g_lry.lry15) THEN
     #      IF p_cmd = 'a' OR
     #         (p_cmd = 'u' AND g_lry_t.lry15 <> g_lry.lry15) THEN
     #         SELECT COUNT(*) INTO l_n FROM lnk_file 
     #          WHERE lnk03 = g_lry.lry15
     #            AND lnk01 = g_lry.lry04
     #            AND lnk02 = '1'
     #         IF cl_null(l_n) OR l_n = 0 THEN
     #            CALL cl_err('','alm-h51',0)
     #            NEXT FIELD lry15 
     #         END IF
     #      END IF
     #      IF NOT cl_null(g_lry.lry17) THEN
     #         SELECT COUNT(*) INTO l_n FROM lnk_file
     #          WHERE lnk01 = g_lry.lry04
     #            AND lnk02 = '1'
     #            AND lnk03 = g_lry.lry17
     #         IF cl_null(l_n) OR l_n = 0 THEN
     #            CALL cl_err('','alm-h51',0)
     #            NEXT FIELD lry17
     #         END IF
     #      END IF
     #   END IF

     #AFTER FIELD lry17
     #   IF NOT cl_null(g_lry.lry17) THEN
     #      IF p_cmd = 'a' OR
     #         (p_cmd = 'u' AND g_lry_t.lry17 <> g_lry.lry17) THEN
     #         SELECT COUNT(*) INTO l_n FROM lnk_file
     #          WHERE lnk03 = g_lry.lry17  
     #            AND lnk01 = g_lry.lry04
     #            AND lnk02 = '1'
     #         IF cl_null(l_n) OR l_n = 0 THEN
     #            CALL cl_err('','alm-h51',0)
     #            NEXT FIELD lry17
     #         END IF
     #      END IF
     #      IF NOT cl_null(g_lry.lry15) THEN
     #         SELECT COUNT(*) INTO l_n FROM lnk_file
     #          WHERE lnk01 = g_lry.lry04
     #            AND lnk02 = '1'
     #            AND lnk03 = g_lry.lry15
     #         IF cl_null(l_n) OR l_n = 0 THEN
     #            CALL cl_err('','alm-h51',0)
     #            NEXT FIELD lry15
     #         END IF
     #      END IF
     #   END IF
     #FUN-CB0077----mark---end

      ON ACTION CONTROLP
        CASE
           WHEN INFIELD(lry01)     #單據編號
              LET g_t1=s_get_doc_no(g_lry.lry01)
              CALL q_oay(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1   
              LET g_lry.lry01 = g_t1
              DISPLAY BY NAME g_lry.lry01
              NEXT FIELD lry01

          #FUN-CB0077----mark---str
          #WHEN INFIELD(lry03)   #卡種
          #   CALL cl_init_qry_var()
          #   LET g_qryparam.form ="q_lpk01"
          #   LET g_qryparam.default1 = g_lry.lry03
          #   CALL cl_create_qry() RETURNING g_lry.lry03
          #   DISPLAY BY NAME g_lry.lry03
          #   NEXT FIELD lry03


          #WHEN INFIELD(lry04)   #卡種 
          #   CALL cl_init_qry_var()
          #   LET g_qryparam.form ="q_lph11"
          #   LET g_qryparam.default1 = g_lry.lry04
          #   LET g_qryparam.arg1 = g_plant
          #   CALL cl_create_qry() RETURNING g_lry.lry04
          #   DISPLAY BY NAME g_lry.lry04
          #   NEXT FIELD lry04

          #WHEN INFIELD(lry15)   #發卡營運中心
          #   CALL cl_init_qry_var()
          #   LET g_qryparam.form ="q_lpy19_i"
          #   LET g_qryparam.default1 = g_lry.lry15
          #   IF NOT cl_null(g_lry.lry04) THEN
          #      LET g_qryparam.where =  " azw01 IN (SELECT lnk03 FROM lnk_file WHERE lnk01 = '",g_lry.lry04,"' AND lnk02 = '1' ) "
          #   END IF 
          #   CALL cl_create_qry() RETURNING g_lry.lry15,l_rtz13
          #   DISPLAY BY NAME g_lry.lry15
          #   DISPLAY l_rtz13 TO lry05 
          #   NEXT FIELD lry15

          #WHEN INFIELD(lry17)  #開卡營運中心
          #   CALL cl_init_qry_var()
          #   LET g_qryparam.form ="q_lpy19_i"
          #   LET g_qryparam.default1 = g_lry.lry17
          #   IF NOT cl_null(g_lry.lry04) THEN
          #      LET g_qryparam.where =  " azw01 IN (SELECT lnk03 FROM lnk_file WHERE lnk01 = '",g_lry.lry04,"' AND lnk02 = '1' ) "
          #   END IF
          #   CALL cl_create_qry() RETURNING g_lry.lry17,l_rtz13
          #   DISPLAY BY NAME g_lry.lry17
          #   DISPLAY l_rtz13 TO lry07
          #   NEXT FIELD lry17
          #FUN-CB0077----mark---end
        END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
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

FUNCTION t619_u(p_w)
DEFINE p_w   like type_file.chr1

    IF g_lry.lry01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lry.lry18 = 'X' THEN RETURN END IF #CHI-C80041
   IF g_lry.lry18 = 'Y' THEN
      CALL cl_err(g_lry.lry01,'alm-027',1)
      RETURN
   END IF
   IF g_lry.lryacti='N' THEN
      CALL cl_err(g_lry.lry01,'alm-147',1)
      RETURN
   END IF
   SELECT * INTO g_lry.* FROM lry_file WHERE lry01=g_lry.lry01
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lry01_t = g_lry.lry01
   BEGIN WORK

   OPEN t619_cl USING g_lry01_t
   IF STATUS THEN
      CALL cl_err("OPEN t619_cl:", STATUS, 1)
      CLOSE t619_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t619_cl INTO g_lry.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lry.lry01,SQLCA.sqlcode,1)
       RETURN
   END IF

   IF p_w != 'c' THEN
    LET g_lry.lrymodu=g_user                  #修改者
    LET g_lry.lrydate = g_today
   ELSE
    LET g_lry.lrymodu=NULL                  #修改者
    LET g_lry.lrydate = NULL

   END IF

    CALL t619_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t619_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_lry.*=g_lry_t.*
            CALL t619_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE lry_file SET lry_file.* = g_lry.*    # 更新DB
            WHERE lry01 = g_lry01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lry_file",g_lry.lry01,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t619_cl
    COMMIT WORK
    CALL t619_b_fill("1=1")  #FUN-CB0077 add
    CALL t619_bp_refresh()   #FUN-CB0077 add
END FUNCTION

#FUN-CB0077--------mark---------str
#FUNCTION t619_chk_lry04()
#DEFINE l_n        LIKE type_file.num5
#DEFINE l_lph03    LIKE lph_file.lph03
#DEFINE l_lph06    LIKE lph_file.lph06
#DEFINE l_lph32    LIKE lph_file.lph32
#DEFINE l_lph33    LIKE lph_file.lph33
#DEFINE l_lph34    LIKE lph_file.lph34
#DEFINE l_lph35    LIKE lph_file.lph35
#DEFINE l_length   LIKE type_file.num5
#   LET g_errno = '' 
#   IF NOT cl_null(g_lry.lry04) THEN
#      SELECT lph03,lph06,lph32,lph33,lph34
#        INTO l_lph03,l_lph06,l_lph32,l_lph33,l_lph34
#      FROM lph_file
#        WHERE lph01 = g_lry.lry04
#      SELECT COUNT(*) INTO l_n FROM lph_file   
#         WHERE lph01 = g_lry.lry04
#           AND lph24 = 'Y' AND lphacti = 'Y' 
#      IF l_n = 0 OR cl_null(l_n) THEN
#         LET g_errno = 'alm-h46'
#         RETURN
#      END IF
#      SELECT COUNT(*) INTO l_n FROM lnk_file  
#         WHERE lnk03 = g_plant 
#           AND lnk01 = g_lry.lry04 
#           AND lnk02 = '1'
#      IF cl_null(l_n) OR l_n = 0 THEN
#         LET g_errno = 'alm-694'
#         RETURN
#      END IF
#      IF NOT cl_null(g_lry.lry05) THEN
#         LET l_length = LENGTH(g_lry.lry05) 
#         IF l_lph32 <> l_length 
#           OR l_lph34 <> g_lry.lry05[1,l_lph33] THEN
#            LET g_errno = 'alm-687' 
#            RETURN 
#         END IF 
#      END IF 
#   END IF
#   
#END FUNCTION
#
#FUNCTION t619_entry_lry()
#DEFINE l_lph03    LIKE lph_file.lph03
#DEFINE l_lph06    LIKE lph_file.lph06
#   LET g_errno = ''
#   IF NOT cl_null(g_lry.lry04) THEN
#      SELECT lph03,lph06
#        INTO l_lph03,l_lph06
#      FROM lph_file
#        WHERE lph01 = g_lry.lry04
#      IF l_lph03 = 'N' THEN
#         CALL cl_set_comp_entry("lry08",FALSE)  
#         LET g_lry.lry08 = 0
#         DISPLAY BY NAME g_lry.lry08  
#      ELSE
#         CALL cl_set_comp_entry("lry08",TRUE)
#      END IF
#      IF l_lph06 = 'N' THEN
#         CALL cl_set_comp_entry("lry11,lry12,lry13",FALSE)
#          LET g_lry.lry11 = 0 
#          LET g_lry.lry12 = 0
#          LET g_lry.lry13 = 0
#          DISPLAY BY NAME g_lry.lry11, g_lry.lry12, g_lry.lry13 
#      ELSE
#         CALL cl_set_comp_entry("lry11,lry12,lry13",TRUE)
#      END IF
#   END IF
#END FUNCTION
#FUN-CB0077--------mark---------end

FUNCTION t619_r()

    IF g_lry.lry01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lry.lry18 = 'X' THEN RETURN END IF #CHI-C80041
    IF g_lry.lry18 = 'Y' THEN
      CALL cl_err(g_lry.lry01,'alm-027',1)
      RETURN
    END IF
    IF g_lry.lryacti='N' THEN
       CALL cl_err(g_lry.lry01,'alm-147',1)
       RETURN
    END IF

    LET g_lry01_t = g_lry.lry01
    BEGIN WORK

    OPEN t619_cl USING g_lry01_t
    IF STATUS THEN
       CALL cl_err("OPEN t619_cl:", STATUS, 0)
       CLOSE t619_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t619_cl INTO g_lry.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lry.lry01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t619_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          
        LET g_doc.column1 = "lry01"         
        LET g_doc.value1 = g_lry.lry01      
        CALL cl_del_doc()                                   
       DELETE FROM lry_file WHERE lry01 = g_lry01_t
       DELETE FROM lsp_file WHERE lsp01 = g_lry01_t    #FUN-CB0077 add
       CLEAR FORM
       CALL g_lsp.clear() 
       OPEN t619_count
       IF STATUS THEN
          CLOSE t619_cs
          CLOSE t619_count
          COMMIT WORK
          RETURN
       END IF
       FETCH t619_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t619_cs
          CLOSE t619_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t619_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t619_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE              
          CALL t619_fetch('/')
       END IF
    END IF
    CLOSE t619_cl
    COMMIT WORK
END FUNCTION 
 
FUNCTION t619_confirm()
   DEFINE l_n        LIKE type_file.num10     #FUN-CB0077 add
   DEFINE l_lsp04    LIKE lsp_file.lsp04      #FUN-CB0077 add
   DEFINE l_sql      STRING                   #FUN-CB0077 add
   DEFINE l_flag     LIKE type_file.chr1      #FUN-CB0077 add

   LET g_success = 'Y'
   IF cl_null(g_lry.lry01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF
   IF g_lry.lry18 = 'X' THEN RETURN END IF #CHI-C80041
   IF g_lry.lry18 = 'Y' THEN
      CALL cl_err('','alm-005',0)
      RETURN
   END IF
   IF g_lry.lryacti='N' THEN
      CALL cl_err(g_lry.lry01,'alm-147',1)
      RETURN
   END IF
   #FUN-CB0077---------add---------str
   LET l_flag ='Y'
   CALL s_showmsg_init()
   LET l_sql = "SELECT lsp04 FROM lsp_file",
               " WHERE lsp01 = '",g_lry.lry01,"'"
   DECLARE sel_lsp04_cs CURSOR FROM l_sql
   FOREACH sel_lsp04_cs INTO l_lsp04
       IF SQLCA.SQLCODE THEN
          CALL s_errmsg('foreach:',l_lsp04,'',SQLCA.SQLCODE,1)
          EXIT FOREACH
          RETURN
       END IF
       SELECT COUNT(*) INTO l_n FROM lpj_file
        WHERE lpj03 = l_lsp04
       IF l_n > 0 THEN
          CALL s_errmsg('lsp04',l_lsp04,'','alm2001',1)
          LET l_flag ='N'
          CONTINUE FOREACH
       END IF
   END FOREACH
   IF l_flag ='N' THEN
      CALL s_showmsg()
      RETURN
   END IF
   #FUN-CB0077---------add---------end
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t619_cl USING g_lry.lry01
   IF STATUS THEN
       CALL cl_err("open t619_cl:",STATUS,1)
       CLOSE t619_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t619_cl INTO g_lry.*
    IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lry.lry01,SQLCA.sqlcode,0)
      CLOSE t619_cl
      ROLLBACK WORK
      RETURN
    END IF
   LET g_lry_t.* = g_lry.*
   IF NOT cl_confirm("alm-006") THEN
       RETURN
   ELSE
      CALL t619_ins_lpj()
      IF g_success = 'N' THEN
         ROLLBACK WORK
         RETURN
      END IF
      CALL t619_ins_lsm()
      IF g_success = 'N' THEN
         ROLLBACK WORK
         RETURN
      END IF
      LET g_lry.lry18 = 'Y' 
      LET g_lry.lry19 = g_user
      LET g_lry.lry20 = g_today
      UPDATE lry_file SET lry18 = g_lry.lry18,
                          lry19 = g_lry.lry19,
                          lry20 = g_lry.lry20
                    WHERE lry01 = g_lry.lry01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lry:',SQLCA.SQLCODE,0)
         LET g_success='N'
         LET g_lry.lry18 = "N"
         LET g_lry.lry19 = g_lry_t.lry19 
         LET g_lry.lry20 = g_lry_t.lry20 
         DISPLAY BY NAME g_lry.lry18,g_lry.lry19,g_lry.lry20 
         ROLLBACK WORK
      ELSE
         DISPLAY BY NAME g_lry.lry18,g_lry.lry19,g_lry.lry20
         COMMIT WORK
      END IF
   END IF

END FUNCTION

#FUN-CB0077--------mark------str
#FUNCTION t619_ins_lpj()
#DEFINE l_lpj        RECORD LIKE lpj_file.*
#DEFINE l_lph03      LIKE lph_file.lph03
#DEFINE l_lph08      LIKE lph_file.lph08
#   SELECT lph03,lph08
#     INTO l_lph03,l_lph08
#     FROM lph_file
#    WHERE lph01 = g_lry.lry04 
#   IF cl_null(l_lph08) THEN
#      LET l_lph08 = 100
#   END IF
#   LET l_lpj.lpj01 = g_lry.lry03 
#   LET l_lpj.lpj02 = g_lry.lry04
#   LET l_lpj.lpj03 = g_lry.lry05
#   LET l_lpj.lpj04 = g_lry.lry06
#   LET l_lpj.lpj05 = g_lry.lry07
#   LET l_lpj.lpj06 = g_lry.lry08
#   LET l_lpj.lpj07 = g_lry.lry09
#   LET l_lpj.lpj08 = g_lry.lry10 
#   LET l_lpj.lpj09 = '2'
#   LET l_lpj.lpj10 = NULL
#   LET l_lpj.lpj11 = l_lph08
#   LET l_lpj.lpj12 = g_lry.lry11
#   LET l_lpj.lpj13 = g_lry.lry12
#   LET l_lpj.lpj14 = g_lry.lry13
#   LET l_lpj.lpj15 = g_lry.lry14
#   LET l_lpj.lpj16 = l_lph03
#   LET l_lpj.lpj17 = g_lry.lry15
#   LET l_lpj.lpj18 = g_lry.lry16 
#   LET l_lpj.lpj19 = g_lry.lry17
#   LET l_lpj.lpj20 = NULL
#   LET l_lpj.lpj21 = NULL
#   LET l_lpj.lpj22 = NULL
#   LET l_lpj.lpj23 = NULL
#   LET l_lpj.lpj24 = NULL
#   LET l_lpj.lpj25 = NULL
#   LET l_lpj.lpjpos = '1'
#
#   INSERT INTO lpj_file VALUES l_lpj.*
#   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err3("ins","lpj_file",l_lpj.lpj01,"",SQLCA.sqlcode,"","",1)
#      LET g_success = 'N'
#      RETURN
#   END IF 
# 
#END FUNCTION
#
#FUNCTION t619_ins_lsm()
#DEFINE l_lsm        RECORD LIKE lsm_file.*
#
#   LET l_lsm.lsm01 = g_lry.lry05
##  LET l_lsm.lsm02 = 'B'         #FUN-C70045 mark
#   LET l_lsm.lsm02 = '1'         #FUN-C70045 add
#   LET l_lsm.lsm15 = '1'         #FUN-C70045 add
#   LET l_lsm.lsm03 = g_lry.lry01
#   LET l_lsm.lsm04 = 0
#   LET l_lsm.lsm05 = g_today
#   LET l_lsm.lsm06 = NULL
#   LET l_lsm.lsm07 = NULL
#   LET l_lsm.lsm08 = 0 
#   LET l_lsm.lsm09 = g_lry.lry09
#   LET l_lsm.lsm10 = g_lry.lry14
#   LET l_lsm.lsm11 = g_lry.lry13
#   LET l_lsm.lsm12 = g_lry.lry11
#   LET l_lsm.lsm13 = g_lry.lry12
#   LET l_lsm.lsm14 = g_lry.lry10
#  #LET l_lsm.lsmplant = g_plant  #FUN-C90102 mark 
#   LET l_lsm.lsmstore = g_plant  #FUN-C90102 add
#   LET l_lsm.lsmlegal = g_legal
#
#   INSERT INTO lsm_file VALUES l_lsm.*
#   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err3("ins","lsm_file",l_lsm.lsm01,"",SQLCA.sqlcode,"","",1)
#      LET g_success = 'N'
#      RETURN
#   ELSE
#      CALL t619_ins_lsn()
#   END IF   
#
#END FUNCTION
#
#FUNCTION t619_ins_lsn()
#DEFINE l_lsn        RECORD LIKE lsn_file.*
#
#   LET l_lsn.lsn01 = g_lry.lry05
##  LET l_lsn.lsn02 = 'G'   #FUN-C70045 mark
#   LET l_lsn.lsn02 = '1'   #FUN-C70045 add
#   LET l_lsn.lsn10 = '1'   #FUN-C70045 add
#   LET l_lsn.lsn03 = g_lry.lry01
#   LET l_lsn.lsn04 = g_lry.lry08 
#   LET l_lsn.lsn05 = g_today
#   LET l_lsn.lsn06 = NULL
#   SELECT lph08 INTO l_lsn.lsn07 FROM lph_file 
#      WHERE lph01 = g_lry.lry04 
#   IF cl_null(l_lsn.lsn07) THEN 
#      LET l_lsn.lsn07 = 100 
#   END IF
#   LET l_lsn.lsn08 = ' ' 
#   LET l_lsn.lsn09 = 0 
#  #LET l_lsn.lsnplant = g_plant  #FUN-C90102 mark 
#   LET l_lsn.lsnstore = g_plant  #FUN-C90102 add
#   LET l_lsn.lsnlegal = g_legal
#
#   INSERT INTO lsn_file VALUES l_lsn.*
#   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err3("ins","lsn_file",l_lsn.lsn01,"",SQLCA.sqlcode,"","",1)
#      LET g_success = 'N'
#      RETURN
#   END IF
#
#END FUNCTION
#FUN-CB0077--------mark------end

FUNCTION t619_x()

    IF g_lry.lry01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lry.lry18 = 'Y' THEN
      CALL cl_err(g_lry.lry01,'alm-027',1)
      RETURN
    END IF

    LET g_lry01_t = g_lry.lry01
    LET g_lry_t.* = g_lry.*
    BEGIN WORK

    OPEN t619_cl USING g_lry01_t
    IF STATUS THEN
       CALL cl_err("OPEN t619_cl:", STATUS, 0)
       CLOSE t619_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t619_cl INTO g_lry.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lry.lry01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t619_show()
    IF cl_exp(0,0,g_lry.lryacti) THEN
        LET g_chr=g_lry.lryacti
        IF g_lry.lryacti='Y' THEN
            LET g_lry.lryacti='N'
        ELSE
            LET g_lry.lryacti='Y'
        END IF
        LET g_lry.lrymodu=g_user
        LET g_lry.lrydate = g_today
        UPDATE lry_file
            SET lryacti=g_lry.lryacti,
                lrymodu=g_lry.lrymodu,
                lrydate=g_lry.lrydate
            WHERE lry01=g_lry.lry01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_lry.lry01,SQLCA.sqlcode,0)
            LET g_lry.lryacti=g_chr
            LET g_lry.lrymodu=g_lry_t.lrymodu
            LET g_lry.lrydate=g_lry_t.lrydate
        END IF
        DISPLAY BY NAME g_lry.lryacti,g_lry.lrydate,g_lry.lrymodu
    END IF
    CALL t619_pic()
    CLOSE t619_cl
    COMMIT WORK
END FUNCTION
#FUN-C30176
#FUN-CB0077---------add--------str
FUNCTION t619_entry_lsp()
DEFINE l_lph03    LIKE lph_file.lph03
DEFINE l_lph06    LIKE lph_file.lph06
   LET g_errno = ''
   IF NOT cl_null(g_lsp[l_ac].lsp03) THEN
      SELECT lph03,lph06
        INTO l_lph03,l_lph06
        FROM lph_file
       WHERE lph01 = g_lsp[l_ac].lsp03
      IF l_lph03 = 'N' THEN
         CALL cl_set_comp_entry("lsp07",FALSE)  
         LET g_lsp[l_ac].lsp07 = 0
         DISPLAY BY NAME g_lsp[l_ac].lsp07  
      ELSE
         CALL cl_set_comp_entry("lsp07",TRUE)
      END IF
      IF l_lph06 = 'N' THEN
         CALL cl_set_comp_entry("lsp10,lsp11,lsp12",FALSE)
          LET g_lsp[l_ac].lsp10= 0 
          LET g_lsp[l_ac].lsp11= 0
          LET g_lsp[l_ac].lsp12= 0
          DISPLAY BY NAME g_lsp[l_ac].lsp10, g_lsp[l_ac].lsp11, g_lsp[l_ac].lsp12
      ELSE
         CALL cl_set_comp_entry("lsp10,lsp11,lsp12",TRUE)
      END IF
   END IF
END FUNCTION

FUNCTION t619_ins_lpj()
DEFINE l_lpj        RECORD LIKE lpj_file.*
DEFINE l_lsp        RECORD LIKE lsp_file.*
DEFINE l_lph03      LIKE lph_file.lph03
DEFINE l_lph08      LIKE lph_file.lph08
DEFINE l_sql        STRING

   LET l_sql = "INSERT INTO lpj_file (lpj01,lpj02,lpj03,lpj04,lpj05,lpj06,lpj07,lpj08,lpj09,",
               "                      lpj11,lpj12,lpj13,lpj14,lpj15,lpj16,lpj17,lpj18,lpj19,lpjpos)",
               " SELECT lsp02,lsp03,lsp04,lsp05,lsp06,lsp07,lsp08,",
               "        lsp09,'2',lph08,lsp10,lsp11,lsp12,lsp13,",
               "        lph03,lsp14,lsp15,lsp16,'1'",
               "   FROM lph_file,lsp_file",
               "  WHERE lph01 = lsp03",
               "    AND lsp01 = '",g_lry.lry01,"'"
   PREPARE t619_sel_lsp_cs FROM l_sql
   EXECUTE t619_sel_lsp_cs
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","lpj_file",g_lry.lry01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION

FUNCTION t619_ins_lsm()
DEFINE l_lsm        RECORD LIKE lsm_file.*
DEFINE l_lsp        RECORD LIKE lsp_file.*
DEFINE l_sql        STRING

   LET l_sql = "INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm08,lsm09,lsm10,",
               "                      lsm11,lsm12,lsm13,lsm14,lsm15,lsmstore,lsmlegal)",
               " SELECT lsp04,'1','",g_lry.lry01,"',0,'",g_today,"',0,lsp08,",
               "        lsp13,lsp12,lsp10,lsp11,lsp09,'1','",g_plant,"','",g_legal,"'",
               "   FROM lsp_file",
               "  WHERE lsp01 = '",g_lry.lry01,"'"     
   PREPARE t619_sel_lsp_cs1 FROM l_sql
   EXECUTE t619_sel_lsp_cs1
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","lsm_file",g_lry.lry01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_success = 'Y' THEN
      CALL t619_ins_lsn()
   END IF

END FUNCTION

FUNCTION t619_ins_lsn()
DEFINE l_lsn        RECORD LIKE lsn_file.*
DEFINE l_lsp        RECORD LIKE lsp_file.*
DEFINE l_sql        STRING

   LET l_sql = "INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn07,",
               "                      lsn08,lsn09,lsn10,lsnstore,lsnlegal)",
               " SELECT lsp04,'1','",g_lry.lry01,"',lsp07,'",g_today,"',",
               "        CASE WHEN(lph08 is null) THEN 100 ELSE lph08 END,",
               "        ' ',0,'1','",g_plant,"','",g_legal,"'",
               "   FROM lsp_file,lph_file",
               "  WHERE lsp01 = '",g_lry.lry01,"'",
               "    AND lph01 = lsp03" 
   PREPARE t619_sel_lsp_cs2 FROM l_sql
   EXECUTE t619_sel_lsp_cs2
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","lsn_file",l_lsn.lsn01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
#單身
FUNCTION t619_b(p_w)
 DEFINE  l_ac_t          LIKE type_file.num5                #未取消的ARRAY CNT
 DEFINE  l_n             LIKE type_file.num5                #檢查重複用
 DEFINE  l_cnt           LIKE type_file.num5                #檢查重複用
 DEFINE  l_lock_sw       LIKE type_file.chr1                #單身鎖住否
 DEFINE  p_cmd           LIKE type_file.chr1                #處理狀態
 DEFINE  l_allow_insert  LIKE type_file.num5
 DEFINE  l_allow_delete  LIKE type_file.num5
 DEFINE  p_w             LIKE type_file.chr1
 DEFINE  l_rtz13         LIKE rtz_file.rtz13
 
    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_lry.lry01 IS NULL THEN
       RETURN
    END IF

    SELECT * INTO g_lry.* FROM lry_file WHERE lry01=g_lry.lry01
    IF g_lry.lry18 = 'X' THEN RETURN END IF #CHI-C80041
    IF g_lry.lry18 = 'Y' THEN
       CALL cl_err('','alm-097',1)
       RETURN
    END IF

    IF g_lry.lryacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_lry.lry01,'alm-004',0)
       RETURN
    END IF
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT lsp04,lsp03,lsp02,lsp16,lsp15,lsp14,lsp05,lsp06,", 
                       "       lsp07,lsp08,lsp09,lsp10,lsp11,lsp12,lsp13",  
                       "  FROM lsp_file,lry_file", 
                       " WHERE lsp01=lry01 and lsp01 =? and lsp04 =? ", 
                       "  FOR UPDATE  "
    LET g_forupd_sql=cl_forupd_sql(g_forupd_sql)
    DECLARE t619_bcl CURSOR FROM g_forupd_sql 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_lsp WITHOUT DEFAULTS FROM s_lsp.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL t619_entry_lsp()
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()

           BEGIN WORK

           OPEN t619_cl USING g_lry.lry01
           IF STATUS THEN
              CALL cl_err("OPEN t619_cl:", STATUS, 1)
              CLOSE t619_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t619_cl INTO g_lry.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lry.lry01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t619_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lsp_t.* = g_lsp[l_ac].*  #BACKUP
              OPEN t619_bcl USING g_lry.lry01,g_lsp_t.lsp04
              IF STATUS THEN
                 CALL cl_err("OPEN t619_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t619_bcl INTO g_lsp[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lsp_t.lsp04,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lsp[l_ac].* TO NULL
           LET g_lsp_t.* = g_lsp[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           LET g_before_input_done = FALSE
           LET g_before_input_done = TRUE
           NEXT FIELD lsp04

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_lsp[l_ac].lsp04) THEN
              CALL cl_err(g_lsp[l_ac].lsp04,'alm-062',1)
              NEXT FIELD lsp04
           END IF

          INSERT INTO lsp_file(lsp01,lsp02,lsp03,lsp04,lsp05,lsp06,lsp07,lsp08,lsp09,
                               lsp10,lsp11,lsp12,lsp13,lsp14,lsp15,lsp16,lsplegal,lspplant)
          VALUES(g_lry.lry01,g_lsp[l_ac].lsp02,g_lsp[l_ac].lsp03,g_lsp[l_ac].lsp04,
                 g_lsp[l_ac].lsp05,g_lsp[l_ac].lsp06,g_lsp[l_ac].lsp07,
                 g_lsp[l_ac].lsp08,g_lsp[l_ac].lsp09,g_lsp[l_ac].lsp10,
                 g_lsp[l_ac].lsp11,g_lsp[l_ac].lsp12,g_lsp[l_ac].lsp13,
                 g_lsp[l_ac].lsp14,g_lsp[l_ac].lsp15,g_lsp[l_ac].lsp16,
                 g_lry.lrylegal,g_lry.lryplant)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lsp_file",g_lry.lry01,g_lsp[l_ac].lsp04,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

        AFTER FIELD lsp04
           IF NOT cl_null(g_lsp[l_ac].lsp04) THEN
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lsp_t.lsp04 != g_lsp[l_ac].lsp04) THEN
                 SELECT COUNT(*) INTO l_n FROM lsp_file
                  WHERE lsp04 = g_lsp[l_ac].lsp04
                    AND lsp01 = g_lry.lry01
                 IF l_n > 0 THEN
                    CALL cl_err('','-239',0)
                    NEXT FIELD lsp04
                 END IF
                 LET l_n = 0 
                 SELECT COUNT(*) INTO l_n FROM lpj_file
                  WHERE lpj03 = g_lsp[l_ac].lsp04
                 IF l_n > 0 THEN
                    CALL cl_err('','alm-h45',0)
                    NEXT FIELD lsp04
                 END IF
                 CALL t619_chk_lsp03()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD lsp04
                 END IF
              END IF
           END IF

        AFTER FIELD lsp03
           IF NOT cl_null(g_lsp[l_ac].lsp03) THEN
            IF p_cmd = 'a' OR 
               (p_cmd = 'u' AND g_lsp_t.lsp03 != g_lsp[l_ac].lsp03) THEN
               CALL t619_chk_lsp03()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD lsp03
               END IF
               CALL t619_entry_lsp()
               IF NOT cl_null(g_lsp[l_ac].lsp14) THEN
                  SELECT COUNT(*) INTO l_n FROM lnk_file
                   WHERE lnk01 = g_lsp[l_ac].lsp03 
                     AND lnk02 = '1'
                     AND lnk03 = g_lsp[l_ac].lsp14
                  IF cl_null(l_n) OR l_n = 0 THEN
                     CALL cl_err('','alm-h51',0)
                     NEXT FIELD lsp03
                  END IF
               END IF
               IF NOT cl_null(g_lsp[l_ac].lsp16) THEN
                  SELECT COUNT(*) INTO l_n FROM lnk_file
                   WHERE lnk01 = g_lsp[l_ac].lsp03
                     AND lnk02 = '1'
                     AND lnk03 = g_lsp[l_ac].lsp16
                  IF cl_null(l_n) OR l_n = 0 THEN
                     CALL cl_err('','alm-h51',0)
                     NEXT FIELD lsp03
                  END IF
               END IF
            END IF
         END IF

      AFTER FIELD lsp16
         IF NOT cl_null(g_lsp[l_ac].lsp16) THEN
            IF p_cmd = 'a' OR
               (p_cmd = 'u' AND g_lsp_t.lsp16 <> g_lsp[l_ac].lsp16) THEN
               SELECT COUNT(*) INTO l_n FROM lnk_file
                WHERE lnk03 = g_lsp[l_ac].lsp16
                  AND lnk01 = g_lsp[l_ac].lsp03
                  AND lnk02 = '1'
               IF cl_null(l_n) OR l_n = 0 THEN
                  CALL cl_err('','alm-h51',0)
                  NEXT FIELD lsp16
               END IF
            END IF
            IF NOT cl_null(g_lsp[l_ac].lsp14) THEN
               SELECT COUNT(*) INTO l_n FROM lnk_file
                WHERE lnk01 = g_lsp[l_ac].lsp03
                  AND lnk02 = '1'
                  AND lnk03 = g_lsp[l_ac].lsp14
               IF cl_null(l_n) OR l_n = 0 THEN
                  CALL cl_err('','alm-h51',0)
                  NEXT FIELD lsp14
               END IF
            END IF
         END IF

      AFTER FIELD lsp14
         IF NOT cl_null(g_lsp[l_ac].lsp14) THEN
            IF p_cmd = 'a' OR
               (p_cmd = 'u' AND g_lsp_t.lsp14 <> g_lsp[l_ac].lsp14) THEN
               SELECT COUNT(*) INTO l_n FROM lnk_file 
                WHERE lnk03 = g_lsp[l_ac].lsp14
                  AND lnk01 = g_lsp[l_ac].lsp03
                  AND lnk02 = '1'
               IF cl_null(l_n) OR l_n = 0 THEN
                  CALL cl_err('','alm-h51',0)
                  NEXT FIELD lsp14 
               END IF
            END IF
            IF NOT cl_null(g_lsp[l_ac].lsp16) THEN
               SELECT COUNT(*) INTO l_n FROM lnk_file
                WHERE lnk01 = g_lsp[l_ac].lsp03
                  AND lnk02 = '1'
                  AND lnk03 = g_lsp[l_ac].lsp16
               IF cl_null(l_n) OR l_n = 0 THEN
                  CALL cl_err('','alm-h51',0)
                  NEXT FIELD lsp16
               END IF
            END IF
         END IF

      AFTER FIELD lsp05 
         IF NOT cl_null(g_lsp[l_ac].lsp05) THEN
            IF g_lsp[l_ac].lsp05 > g_today THEN
               CALL cl_err('','alm-h47',0)
               NEXT FIELD lsp05
            END IF
         END IF

      AFTER FIELD lsp06 
         IF NOT cl_null(g_lsp[l_ac].lsp06) THEN
            IF g_lsp[l_ac].lsp06 < g_today THEN
               CALL cl_err('','alm-h49',0)
               NEXT FIELD lsp06
            END IF
         END IF
    
      AFTER FIELD lsp08 
         IF NOT cl_null(g_lsp[l_ac].lsp08) THEN
            IF g_lsp[l_ac].lsp08 < 0 THEN
               CALL cl_err('','aec-020',0)
               NEXT FIELD lsp08
            END IF 
         END IF
         
     AFTER FIELD lsp09
        IF NOT cl_null(g_lsp[l_ac].lsp09) THEN
           IF g_lsp[l_ac].lsp09 > g_today THEN
              CALL cl_err('','alm-h50',0)
              NEXT FIELD lsp09
           END IF
           IF NOT cl_null(g_lsp[l_ac].lsp05) THEN
              IF g_lsp[l_ac].lsp09 < g_lsp[l_ac].lsp05 THEN
                 CALL cl_err('','alm-h52',0)
                 NEXT FIELD lsp09
              END IF
           END IF
        END IF

      AFTER FIELD lsp11
         IF NOT cl_null(g_lsp[l_ac].lsp11) AND g_lsp[l_ac].lsp11 > 0 THEN
            CALL cl_err('','alm-h72',0)
            NEXT FIELD lsp11
         END IF
         
      AFTER FIELD lsp13
         IF NOT cl_null(g_lsp[l_ac].lsp13) THEN
            IF g_lsp[l_ac].lsp13 < 0 THEN
               CALL cl_err('','aec-020',0)
               NEXT FIELD lsp13
            END IF
         END IF

         
      BEFORE DELETE                      #是否取消單身
         DISPLAY "BEFORE DELETE"
         IF g_lsp_t.lsp04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM lsp_file
             WHERE lsp01 = g_lry.lry01
               AND lsp04 = g_lsp_t.lsp04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","lsp_file",g_lry.lry01,g_lsp_t.lsp04,SQLCA.sqlcode,"","",1)
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
            LET g_lsp[l_ac].* = g_lsp_t.*
            CLOSE t619_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_lsp[l_ac].lsp04,-263,1)
            LET g_lsp[l_ac].* = g_lsp_t.*
         ELSE
            UPDATE lsp_file SET lsp02 = g_lsp[l_ac].lsp02,
                                lsp03 = g_lsp[l_ac].lsp03,
                                lsp04 = g_lsp[l_ac].lsp04,
                                lsp05 = g_lsp[l_ac].lsp05,
                                lsp06 = g_lsp[l_ac].lsp06,
                                lsp07 = g_lsp[l_ac].lsp07,
                                lsp08 = g_lsp[l_ac].lsp08,
                                lsp09 = g_lsp[l_ac].lsp09,
                                lsp10 = g_lsp[l_ac].lsp10,
                                lsp11 = g_lsp[l_ac].lsp11,
                                lsp12 = g_lsp[l_ac].lsp12,
                                lsp13 = g_lsp[l_ac].lsp13,
                                lsp14 = g_lsp[l_ac].lsp14,
                                lsp15 = g_lsp[l_ac].lsp15,
                                lsp16 = g_lsp[l_ac].lsp16
             WHERE lsp01 = g_lry.lry01
               AND lsp04 = g_lsp_t.lsp04
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","lsp_file",g_lry.lry01,g_lsp_t.lsp04,SQLCA.sqlcode,"","",1)
               LET g_lsp[l_ac].* = g_lsp_t.*
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
               LET g_lsp[l_ac].* = g_lsp_t.*
            END IF
            CLOSE t619_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE t619_bcl
         COMMIT WORK

        ON ACTION CONTROLP
        CASE
           WHEN INFIELD(lsp02)   #会员编号
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_lpk01"
              LET g_qryparam.default1 = g_lsp[l_ac].lsp02
              CALL cl_create_qry() RETURNING g_lsp[l_ac].lsp02
              DISPLAY BY NAME g_lsp[l_ac].lsp02
              NEXT FIELD lsp02

           WHEN INFIELD(lsp03)   #卡種 
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_lph11"
              LET g_qryparam.default1 = g_lsp[l_ac].lsp03
              LET g_qryparam.arg1 = g_plant
              CALL cl_create_qry() RETURNING g_lsp[l_ac].lsp03
              DISPLAY BY NAME g_lsp[l_ac].lsp03
              NEXT FIELD lsp03

           WHEN INFIELD(lsp14)   #發卡營運中心
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_lpy19_i"
              LET g_qryparam.default1 = g_lsp[l_ac].lsp14
              IF NOT cl_null(g_lsp[l_ac].lsp03) THEN
                 LET g_qryparam.where =  " azw01 IN (SELECT lnk03 FROM lnk_file WHERE lnk01 = '",g_lsp[l_ac].lsp03,"' AND lnk02 = '1' ) "
              END IF 
              CALL cl_create_qry() RETURNING g_lsp[l_ac].lsp14,l_rtz13
              DISPLAY BY NAME g_lsp[l_ac].lsp14
              NEXT FIELD lsp14

           WHEN INFIELD(lsp16)  #開卡營運中心
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_lpy19_i"
              LET g_qryparam.default1 = g_lsp[l_ac].lsp16
              IF NOT cl_null(g_lsp[l_ac].lsp03) THEN
                 LET g_qryparam.where =  " azw01 IN (SELECT lnk03 FROM lnk_file WHERE lnk01 = '",g_lsp[l_ac].lsp03,"' AND lnk02 = '1' ) "
              END IF
              CALL cl_create_qry() RETURNING g_lsp[l_ac].lsp16,l_rtz13
              DISPLAY BY NAME g_lsp[l_ac].lsp16
              NEXT FIELD lsp16
        END CASE

        ON ACTION CONTROLO 
           IF INFIELD(lsp04) AND l_ac > 1 THEN
              LET g_lsp[l_ac].* = g_lsp[l_ac-1].*
              NEXT FIELD lsp04
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

        ON ACTION controls
           CALL cl_set_head_visible("","AUTO")
    END INPUT

   IF p_cmd = 'u' AND p_w !='c' THEN
      LET g_lry.lrymodu = g_user
      LET g_lry.lrydate = g_today
      UPDATE lry_file SET lrymodu = g_lry.lrymodu,
                          lrydate = g_lry.lrydate
       WHERE lry01 = g_lry.lry01
   END IF
    DISPLAY BY NAME g_lry.lrymodu,g_lry.lrydate
    CLOSE t619_bcl
    COMMIT WORK
    CALL t619_delHeader()
END FUNCTION

FUNCTION t619_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lry.lry01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lry_file ",
                  "  WHERE lry01 LIKE '",l_slip,"%' ",
                  "    AND lry01 > '",g_lry.lry01,"'"
      PREPARE t619_pb1 FROM l_sql 
      EXECUTE t619_pb1 INTO l_cnt       
      
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
         CALL t619_v()
         CALL t619_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lry_file WHERE lry01 = g_lry.lry01
         INITIALIZE g_lry.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION

FUNCTION t619_b_fill(p_wc2)
DEFINE p_wc2    STRING
DEFINE l_s      LIKE type_file.chr1000
DEFINE l_m      LIKE type_file.chr1000
DEFINE i        LIKE type_file.num5
DEFINE l_n      LIKE type_file.num5

   LET g_sql = "SELECT lsp04,lsp03,lsp02,lsp16,lsp15,lsp14,lsp05,lsp06,", 
               "       lsp07,lsp08,lsp09,lsp10,lsp11,lsp12,lsp13", 
               "  FROM lsp_file", 
               " WHERE lsp01 ='",g_lry.lry01,"'"

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
  # LET g_sql=g_sql CLIPPED," ORDER BY lsp04 "
   DECLARE t619_lsp_cs CURSOR FROM g_sql
   CALL g_lsp.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH t619_lsp_cs INTO g_lsp[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_lsp.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION t619_chk_lsp03()
DEFINE l_n        LIKE type_file.num5
DEFINE l_lph03    LIKE lph_file.lph03
DEFINE l_lph06    LIKE lph_file.lph06
DEFINE l_lph32    LIKE lph_file.lph32
DEFINE l_lph33    LIKE lph_file.lph33
DEFINE l_lph34    LIKE lph_file.lph34
DEFINE l_lph35    LIKE lph_file.lph35
DEFINE l_length   LIKE type_file.num5
   LET g_errno = '' 
   IF NOT cl_null(g_lsp[l_ac].lsp03) THEN
      SELECT lph03,lph06,lph32,lph33,lph34
        INTO l_lph03,l_lph06,l_lph32,l_lph33,l_lph34
        FROM lph_file
       WHERE lph01 = g_lsp[l_ac].lsp03
      SELECT COUNT(*) INTO l_n FROM lph_file   
         WHERE lph01 = g_lsp[l_ac].lsp03
           AND lph24 = 'Y' AND lphacti = 'Y' 
      IF l_n = 0 OR cl_null(l_n) THEN
         LET g_errno = 'alm-h46'
         RETURN
      END IF
      SELECT COUNT(*) INTO l_n FROM lnk_file  
         WHERE lnk03 = g_plant 
           AND lnk01 = g_lsp[l_ac].lsp03
           AND lnk02 = '1'
      IF cl_null(l_n) OR l_n = 0 THEN
         LET g_errno = 'alm-694'
         RETURN
      END IF
      IF NOT cl_null(g_lsp[l_ac].lsp04) THEN
         LET l_length = LENGTH(g_lsp[l_ac].lsp04) 
         IF l_lph32 <> l_length 
           OR l_lph34 <> g_lsp[l_ac].lsp04[1,l_lph33] THEN
            LET g_errno = 'alm-687' 
            RETURN 
         END IF 
      END IF 
   END IF
END FUNCTION
FUNCTION t619_from_excel()
   DEFINE   lr_data         DYNAMIC ARRAY OF RECORD
            data04,data03,data02,data16,data15,data14,data05,
            data06,data07,data08,data09,data10,data11,data12,data13
                            LIKE type_file.chr50 
                            END RECORD
   DEFINE   ls_doc_path     STRING
   DEFINE   ls_file_name    STRING
   DEFINE   ls_file_path    STRING
   DEFINE   li_result       LIKE type_file.num5
   DEFINE   li_cnt          LIKE type_file.num5
   DEFINE   ls_fields       STRING
   DEFINE   ls_exe_sql      STRING
   DEFINE   li_i            LIKE type_file.num5
   DEFINE   li_j            LIKE type_file.num5
   DEFINE   li_k            LIKE type_file.num5
   DEFINE   ls_cell         STRING
   DEFINE   ls_cell2        STRING
   DEFINE   ls_cell_r       STRING
   DEFINE   ls_cell_c       STRING
   DEFINE   ls_cell_r2      STRING
   DEFINE   ls_cell_c2      STRING
   DEFINE   li_data_stat    LIKE type_file.num5
   DEFINE   li_data_end     LIKE type_file.num5
   DEFINE   li_col_idx      LIKE type_file.num5
   DEFINE   ls_value        STRING
   DEFINE   lr_err          DYNAMIC ARRAY OF RECORD
               line         STRING,
               key1         STRING,
               err          STRING,
               cmd          STRING
                            END RECORD
   DEFINE   lr_loc          DYNAMIC ARRAY OF RECORD
               loc1         LIKE type_file.chr10,
               loc2         LIKE type_file.chr10
                            END RECORD
   DEFINE   l_flag          LIKE type_file.chr1
   DEFINE   ls_max_no       LIKE type_file.chr10
   DEFINE   ls_chr          LIKE type_file.chr10
   DEFINE   ls_date         LIKE type_file.chr10
   DEFINE   ls_col_cnt      LIKE type_file.num5
   DEFINE   ls_col_cnt1     LIKE type_file.num5
   DEFINE   l_str           STRING
   DEFINE   l_str1          STRING
   DEFINE   l_lry04         LIKE rye_file.rye04
   DEFINE   l_n             LIKE type_file.num10
   DEFINE   l_flag1         LIKE type_file.chr1
   DEFINE   l_flag2         LIKE type_file.chr1
   DEFINE   l_flag3         LIKE type_file.chr1
   DEFINE   l_flag4         LIKE type_file.chr1


   #開窗選擇檔案
   OPEN WINDOW almt6191_w WITH FORM "alm/42f/almt6191" 
   CALL cl_ui_locale("almt6191")
   
   INPUT ls_doc_path,ls_col_cnt,ls_col_cnt1 WITHOUT DEFAULTS
    FROM FORMONLY.doc_path,FORMONLY.col_cnt,FORMONLY.col_cnt1
      BEFORE INPUT
         LET ls_col_cnt = 1
         LET ls_col_cnt1= 1
         DISPLAY ls_col_cnt,ls_col_cnt1 TO col_cnt,col_cnt1
      AFTER FIELD col_cnt
         IF NOT cl_null(ls_col_cnt) THEN
            IF ls_col_cnt < 0 OR ls_col_cnt > 10000 THEN
               NEXT FIELD col_cnt
            END IF
         END IF
      AFTER FIELD col_cnt1
         IF NOT cl_null(ls_col_cnt1) THEN
            IF ls_col_cnt1 < 0 OR ls_col_cnt1 > 10000 THEN
               NEXT FIELD col_cnt
            END IF
         END IF
      AFTER INPUT 
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF ls_doc_path IS NULL OR cl_null(ls_col_cnt) OR cl_null(ls_col_cnt) THEN
            NEXT FIELD doc_path
         END IF
      ON ACTION open_file
         CALL cl_browse_file() RETURNING ls_doc_path
         DISPLAY ls_doc_path TO FORMONLY.doc_path
      ON ACTION exit
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      CLOSE WINDOW almt6191_w
      RETURN
   END IF
 
   IF ls_doc_path IS NULL OR cl_null(ls_col_cnt) OR cl_null(ls_col_cnt) THEN
      CLOSE WINDOW almt6191_w
      RETURN
   ELSE
      LET ls_file_path = ls_doc_path  #完整路径
      LET ls_file_name = ls_doc_path  #文件名
      WHILE TRUE
         IF ls_file_name.getIndexOf("/",1) THEN #取文件名,去除路径
            LET ls_file_name = ls_file_name.subString(ls_file_name.getIndexOf("/",1) + 1,ls_file_name.getLength())
         ELSE
            EXIT WHILE
         END IF
      END WHILE
      DISPLAY 'ls_file_path = ',ls_file_path
   END IF

   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
 
   CALL ui.Interface.frontCall("standard","shellexec",[ls_file_path] ,li_result)
   CALL t619_checkError(li_result,"Open File")
 
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL",ls_file_name],[li_result])
   CALL t619_checkError(li_result,"Connect File")
 
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL","Sheet1"],[li_result])
   CALL t619_checkError(li_result,"Connect Sheet1")
 
   MESSAGE ls_file_name," File Analyze..."
 
   FOR li_i = 1 TO 15  #取excel中每个栏位的开始位置和结束位置
       LET l_str = li_i
       LET l_str1 = ls_col_cnt
       LET lr_loc[li_i].loc1 = "R",l_str1.trim(),"C",l_str.trim()
       LET l_str1 = ls_col_cnt1
       LET lr_loc[li_i].loc2 = "R",l_str1.trim(),"C",l_str.trim()
   END FOR
 
   #準備解Excel內的資料
   #第一階段搜尋
   LET li_col_idx = 1
   FOR li_i = 1 TO 15   #1->excel中的栏位数
      #直接默认取列，直向
      #R1C1  第一行第一列
      #R10C1 第十行第一列
      LET ls_cell = lr_loc[li_i].loc1
      LET ls_cell_c = ls_cell.subString(ls_cell.getIndexOf("C",1),ls_cell.getLength())
      LET ls_cell_r = ls_cell.subString(ls_cell.getIndexOf("R",1)+1,ls_cell.getIndexOf("C",1)-1)
      LET li_data_stat = ls_cell_r
      LET ls_cell = lr_loc[li_i].loc2
      LET ls_cell_r = ls_cell.subString(ls_cell.getIndexOf("R",1)+1,ls_cell.getIndexOf("C",1)-1)
      LET li_data_end = ls_cell_r
 
      #將抓到的資料放到lr_data
      LET li_cnt = 1
      FOR li_j = li_data_stat TO li_data_end
          LET ls_value = ""
                LET ls_cell_r = li_j
                LET ls_cell = "R",ls_cell_r.trim(),ls_cell_c.trim()
          CALL ui.Interface.frontCall("WINDDE","DDEPeek",["EXCEL",ls_file_name,ls_cell],[li_result,ls_value])
          CALL t619_checkError(li_result,"Peek Cells")
          LET ls_value = ls_value.trim()
          IF ls_value.getIndexOf("\"",1) THEN
             LET ls_value = cl_replace_str(ls_value,'"','@#$%')
             LET ls_value = cl_replace_str(ls_value,'@#$%','\"')
          END IF
          IF ls_value.getIndexOf("'",1) THEN
             LET ls_value = cl_replace_str(ls_value,"'","@#$%")
             LET ls_value = cl_replace_str(ls_value,"@#$%","''")
          END IF
          CASE li_col_idx
             WHEN 1
                LET lr_data[li_cnt].data04 = ls_value
             WHEN 2
                LET lr_data[li_cnt].data03 = ls_value
             WHEN 3
                LET lr_data[li_cnt].data02 = ls_value
             WHEN 4
                LET lr_data[li_cnt].data16 = ls_value
             WHEN 5
                LET lr_data[li_cnt].data15 = ls_value
             WHEN 6
                LET lr_data[li_cnt].data14 = ls_value
             WHEN 7
                LET lr_data[li_cnt].data05 = ls_value
             WHEN 8
                LET lr_data[li_cnt].data06 = ls_value
             WHEN 9
                LET lr_data[li_cnt].data07 = ls_value
             WHEN 10
                LET lr_data[li_cnt].data08 = ls_value
             WHEN 11
                LET lr_data[li_cnt].data09 = ls_value
             WHEN 12
                LET lr_data[li_cnt].data10 = ls_value
             WHEN 13
                LET lr_data[li_cnt].data11 = ls_value
             WHEN 14
                LET lr_data[li_cnt].data12 = ls_value
             WHEN 15
                LET lr_data[li_cnt].data13 = ls_value
          END CASE
          LET li_cnt = li_cnt + 1
      END FOR
      LET li_col_idx = li_col_idx + 1
   END FOR
   CALL g_lsp.deleteElement(li_cnt)

   BEGIN WORK

   LET g_success = 'Y'
   LET l_flag3 ='Y'
   SELECT * INTO g_lry.* FROM lry_file 
    WHERE lry01 = g_lry.lry01
   IF SQLCA.sqlcode = 100 THEN INITIALIZE g_lry.* TO NULL END IF
   IF cl_null(g_lry.lry01) OR g_lry.lry18 = 'Y' THEN
      INITIALIZE g_lry.* TO NULL
      LET g_lry.lryplant=g_plant
      LET g_lry.lrylegal =g_legal
      LET g_lry.lryuser = g_user
      LET g_lry.lryoriu = g_user
      LET g_lry.lryorig = g_grup
      LET g_lry.lrygrup = g_grup               #使用者所屬群
      LET g_lry.lrycrat = g_today
      LET g_lry.lryacti = 'Y'
      LET g_lry.lry02 = g_today
      LET g_lry.lry18 ='N'
      LET g_lry.lry04 = ' '
      LET g_lry.lry05 = ' '
      LET g_lry.lry08 = 0
      LET g_lry.lry09 = 0
      LET g_lry.lry11 = 0
      LET g_lry.lry12 = 0
      LET g_lry.lry13 = 0
      LET g_lry.lry14 = 0
      LET g_lry.lry15 = ' '
      LET g_lry.lry18 = 'N'
      CALL s_get_defslip("alm","Q7",g_plant,'N') RETURNING l_lry04
      IF cl_null(l_lry04) THEN
         CALL cl_err('','art-315',1)
         LET g_success = 'N'
         INITIALIZE g_lry.* TO NULL
      END IF
      IF g_success = 'Y' THEN
         CALL s_auto_assign_no("alm",l_lry04,g_today,"Q7","lry_file","lry01",g_plant,"","")
              RETURNING li_result,g_lry.lry01
         IF (NOT li_result) THEN
            CALL cl_err('','sub-145',1)
            LET g_success = 'N'
            INITIALIZE g_lry.* TO NULL
         ELSE 
            INSERT INTO lry_file VALUES(g_lry.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_lry.lry01,SQLCA.sqlcode,0)
               LET g_success = 'N'
               INITIALIZE g_lry.* TO NULL
            END IF
         END IF
      END IF
      IF g_success = 'Y' THEN
         LET l_flag3 = 'N'
      ELSE
         ROLLBACK WORK
      END IF
   END IF

   IF g_success = 'Y' THEN
      CALL s_showmsg_init()
      LET li_k = 1
      LET l_flag1 = 'Y'
      LET l_flag2 = 'Y'
      FOR li_i = 1 TO lr_data.getLength()
          IF NOT cl_null(lr_data[li_i].data04) THEN
             LET l_flag4 = 'Y'
             LET l_n = 0
             SELECT COUNT(*) INTO l_n FROM lpj_file
              WHERE lpj03 = lr_data[li_i].data04
             IF l_n > 0 THEN
                LET l_flag1 = 'N'
                LET l_flag4 = 'N'
                CALL s_errmsg('lsp04',lr_data[li_i].data04,'','alm-577',1)
                CONTINUE FOR
             END IF
             LET l_n = 0
             SELECT COUNT(*) INTO l_n FROM lsp_file
              WHERE lsp01 = g_lry.lry01
                AND lsp04 = lr_data[li_i].data04
             IF l_n > 0 THEN
                LET l_flag1 = 'N'
                LET l_flag4 = 'N' 
                CALL s_errmsg('lsp04',lr_data[li_i].data04,'','alm2003',1)
                CONTINUE FOR
             END IF
             IF l_flag4 = 'Y' THEN
                LET ls_exe_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'lsp_file'),
                                 " VALUES('",g_lry.lry01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"',",
                                 "        '",lr_data[li_i].data04 CLIPPED,"','",lr_data[li_i].data05 CLIPPED,"','",lr_data[li_i].data06 CLIPPED,"',",
                                 "        '",lr_data[li_i].data07 CLIPPED,"','",lr_data[li_i].data08 CLIPPED,"','",lr_data[li_i].data09 CLIPPED,"',",
                                 "        '",lr_data[li_i].data10 CLIPPED,"','",lr_data[li_i].data11 CLIPPED,"','",lr_data[li_i].data12 CLIPPED,"',",
                                 "        '",lr_data[li_i].data13 CLIPPED,"','",lr_data[li_i].data14 CLIPPED,"','",lr_data[li_i].data15 CLIPPED,"',",
                                 "        '",lr_data[li_i].data16 CLIPPED,"','",g_legal,"','",g_plant,"')"
                CALL cl_replace_sqldb(ls_exe_sql)RETURNING ls_exe_sql  
                CALL cl_parse_qry_sql(ls_exe_sql,g_plant_new) RETURNING ls_exe_sql
                PREPARE execute3_sql FROM ls_exe_sql
                EXECUTE execute3_sql
                IF SQLCA.sqlcode THEN
                   LET lr_err[li_k].line = li_i
                   LET lr_err[li_k].key1 = g_lry.lry01
                   LET lr_err[li_k].err  = SQLCA.sqlcode
                   LET lr_err[li_k].cmd  = ls_exe_sql
                   LET li_k = li_k + 1
                END IF
             END IF
          END IF
      END FOR
      IF lr_err.getLength() > 0 THEN
         CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"Line|Key1|Error")
         CALL cl_end2(2) RETURNING l_flag
         LET l_flag2 = 'N'
         ROLLBACK WORK
         IF l_flag3 = 'N' THEN
            DELETE FROM lry_file WHERE lry01 = g_lry.lry01
            INITIALIZE g_lry.* TO NULL
         END IF
      ELSE
         CALL cl_end2(1) RETURNING l_flag
      END IF
      SELECT COUNT(*) INTO g_rec_b FROM lsp_file
       WHERE lsp01 = g_lry.lry01
      IF g_rec_b = 0 AND l_flag3 = 'N'THEN
         DELETE FROM lry_file WHERE lry01 = g_lry.lry01
         INITIALIZE g_lry.* TO NULL
      END IF
      COMMIT WORK
   END IF
   IF l_flag1 = 'N' AND l_flag2 = 'Y' THEN
      CALL s_showmsg()
   END IF
   #關閉Excel寫入
   CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL","Sheet1"],[li_result])
   CALL t619_checkError(li_result,"Finish")
 
   CLOSE WINDOW almt6191_w
END FUNCTION
 
FUNCTION t619_checkError(p_result,p_msg)
   DEFINE   p_result   LIKE type_file.num5
   DEFINE   p_msg      STRING
   DEFINE   ls_msg     STRING
   DEFINE   li_result  LIKE type_file.num5
 
 
   IF p_result THEN
      RETURN
   END IF
   DISPLAY p_msg," DDE ERROR:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[ls_msg])
   DISPLAY ls_msg
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
   IF NOT li_result THEN
      DISPLAY "Exit with DDE Error."
   END IF
END FUNCTION
#FUN-CB0077---------add--------end
#CHI-C80041---begin
FUNCTION t619_v()
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lry.lry01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t619_cl USING g_lry.lry01
   IF STATUS THEN
      CALL cl_err("OPEN t619_cl:", STATUS, 1)
      CLOSE t619_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t619_cl INTO g_lry.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lry.lry01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t619_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_lry.lry18 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_lry.lry18)   THEN 
        LET g_chr=g_lry.lry18
        IF g_lry.lry18='N' THEN 
            LET g_lry.lry18='X' 
        ELSE
            LET g_lry.lry18='N'
        END IF
        UPDATE lry_file
            SET lry18=g_lry.lry18,  
                lrymodu=g_user,
                lrydate=g_today
            WHERE lry01=g_lry.lry01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lry_file",g_lry.lry01,"",SQLCA.sqlcode,"","",1)  
            LET g_lry.lry18=g_chr 
        END IF
        DISPLAY BY NAME g_lry.lry18 
   END IF
 
   CLOSE t619_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lry.lry01,'V')
 
END FUNCTION
#CHI-C80041---end
