# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almt600.4gl
# Descriptions...: 積分換券變更設定作業
# Date & Author..: No.FUN-C50137 12/06/05 By pauline
# Modify.........: No.FUN-C60089 12/07/20 By pauline 將兌換來源納入PK值
# Modify.........: No.CHI-C80047 12/08/23 By pauline 將卡種納入PK值
# Modify.........: No.FUN-C90067 12/09/25 By pauline 調整單身的PK值,同一兌換方案代碼的積分達/累計消費額+產品編號不可重複
# Modify.........: No:CHI-C80041 12/12/26 By bart 1.增加作廢功能 2.刪除單頭

DATABASE ds
GLOBALS "../../config/top.global"
DEFINE
    g_lqx           RECORD LIKE lqx_file.*,
    g_lqx_t         RECORD LIKE lqx_file.*,
    g_lqx_o         RECORD LIKE lqx_file.*,
    g_lqx01         LIKE lqx_file.lqx01,
    g_lqx01_t       LIKE lqx_file.lqx01,
    g_ydate         DATE,
    g_lqy           DYNAMIC ARRAY OF RECORD       #
        lqy06       LIKE lqy_file.lqy06,          #項次 
        lqy02       LIKE lqy_file.lqy02,          #積分達
        lqy07       LIKE lqy_file.lqy07,          #纍計消費額       
        lqy03       LIKE lqy_file.lqy03,          #贈品編號
        ima02       LIKE ima_file.ima02,          #贈品名稱        
        ima021      LIKE ima_file.ima021,         #贈品規格
        lqy04       LIKE lqy_file.lqy04,
        gfe02       LIKE gfe_file.gfe02,
        lqy05       LIKE lqy_file.lqy05
                    END RECORD,
    g_lqy_t         RECORD                        #
        lqy06       LIKE lqy_file.lqy06,          #項次
        lqy02       LIKE lqy_file.lqy02,          #積分達
        lqy07       LIKE lqy_file.lqy07,          #纍計消費額       
        lqy03       LIKE lqy_file.lqy03,          #贈品編號
        ima02       LIKE ima_file.ima02,          #贈品名稱         
        ima021      LIKE ima_file.ima021,         #贈品規格
        lqy04       LIKE lqy_file.lqy04,
        gfe02       LIKE gfe_file.gfe02,
        lqy05       LIKE lqy_file.lqy05
                    END RECORD,
    g_lqy_o         RECORD                        #
        lqy06       LIKE lqy_file.lqy06,          #項次
        lqy02       LIKE lqy_file.lqy02,          #積分達
        lqy07       LIKE lqy_file.lqy07,          #纍計消費額       
        lqy03       LIKE lqy_file.lqy03,          #贈品編號
        ima02       LIKE ima_file.ima02,          #贈品名稱         
        ima021      LIKE ima_file.ima021,         #贈品規格
        lqy04       LIKE lqy_file.lqy04,
        gfe02       LIKE gfe_file.gfe02,
        lqy05       LIKE lqy_file.lqy05
                    END RECORD,
    g_sql           STRING,                       #CURSOR
    g_wc            STRING,                       #
    g_wc2           STRING,                       #
    g_rec_b         LIKE type_file.num5,
    l_ac            LIKE type_file.num5
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose
DEFINE g_msg               LIKE type_file.chr1000
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_argv1             LIKE lqx_file.lqx01
DEFINE g_argv2             STRING
DEFINE g_lqy04_t           LIKE lqy_file.lqy04
DEFINE g_ary          DYNAMIC ARRAY OF RECORD
          plant            LIKE azw_file.azw01,          #plant
          acti             LIKE lsz_file.lsz10           #有效否
                      END RECORD
DEFINE g_cnt2              LIKE type_file.num5
DEFINE g_flag2             LIKE type_file.chr1
DEFINE g_lsz02             LIKE lsz_file.lsz02       #FUN-C60089 add
DEFINE g_lqx02_t           LIKE lqx_file.lqx02       #CHI-C80047 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   LET g_argv1 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
   IF cl_null(g_argv1) THEN
      LET g_argv1 = '0'
      LET g_lsz02 = '3'   #FUN-C60089 add
   END IF
   IF g_argv1 = '1' THEN
      LET g_prog = "almt601"
      LET g_lsz02 = '4'   #FUN-C60089 add
   END IF
  #FUN-C60089 add START
   IF g_argv1 = '0' THEN
      LET g_lqx.lqx00 = '0'
   ELSE
      IF g_argv1 = '1' THEN
         LET g_lqx.lqx00 = '1'
      END IF
   END IF
  #FUN-C60089 add END

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM lqx_file WHERE lqx00 = '",g_lqx.lqx00,"' AND lqx01 = ? ",   #FUN-C60089 add lqx00
                      "                         AND lqx10 = ? AND lqx11 = ? AND lqx02 = ? FOR UPDATE"   #CHI-C80047 add lqx02
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t600_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW t600_w WITH FORM "alm/42f/almt600"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   IF g_argv1 = '0' THEN
      CALL cl_set_comp_visible("lqx09,lqy07",FALSE)
   END IF 
   IF g_argv1 = '1' THEN
      CALL cl_set_comp_visible("lqy02",FALSE)
   END IF

   DISPLAY BY NAME g_lqx.lqx00   #FUN-C60089 add

   LET g_action_choice = ""
   CALL t600_menu()
   CLOSE WINDOW t600_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t600_cs()

 CLEAR FORM
 CALL g_lqy.clear()
   IF g_argv1 = '0' THEN
      LET g_lqx.lqx00 = '0'
   ELSE
      IF g_argv1 = '1' THEN
         LET g_lqx.lqx00 = '1'
      END IF
   END IF
   DISPLAY BY NAME g_lqx.lqx00
    CONSTRUCT BY NAME g_wc ON lqx10,lqx01,lqx11,lqx02,lqx03,lqx04,lqx05,               
                              lqx09,lqx12,lqx13,lqx06,lqx07,lqx08,
                              lqxplant,lqxlegal,                                         
                              lqxuser,lqxgrup,lqxoriu,lqxorig,lqxcrat,lqxmodu,lqxdate,lqxacti
      ON ACTION controlp
         CASE
           WHEN INFIELD(lqx10)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lqx10"
              LET g_qryparam.state = "c"
              CALL cl_create_qry()
                   RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lqx10
              NEXT FIELD lqx10

           WHEN INFIELD(lqxplant)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lqxplant"
              LET g_qryparam.state = "c"
              CALL cl_create_qry()
                   RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lqxplant
              NEXT FIELD lqxplant

           WHEN INFIELD(lqxlegal)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lqxlegal"
              LET g_qryparam.state = "c"
              CALL cl_create_qry()
                   RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lqxlegal
              NEXT FIELD lqxlegal

            WHEN INFIELD(lqx01)   #方案編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqx01"
               LET g_qryparam.arg1= g_argv1
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqx01
               NEXT FIELD lqx01

            WHEN INFIELD(lqx02)   #卡種編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqx02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqx02
               CALL t600_lqx02('d')
               NEXT FIELD lqx02

            WHEN INFIELD(lqx06)  #審核人
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqx06"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqx06
               NEXT FIELD lqx06
            OTHERWISE EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lqxuser', 'lqxgrup') 

   IF INT_FLAG THEN
      RETURN
   END IF

   CONSTRUCT g_wc2 ON lqy06,lqy02,lqy07,lqy03,lqy04,lqy05 
        FROM s_lqy[1].lqy06,s_lqy[1].lqy02,s_lqy[1].lqy07,s_lqy[1].lqy03,s_lqy[1].lqy04,s_lqy[1].lqy05
   ON ACTION CONTROLP
      CASE
        WHEN INFIELD(lqy03)  #贈品編號
           CALL cl_init_qry_var()
           LET g_qryparam.state= "c"
           LET g_qryparam.form ="q_lqy03"  
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO lqy03
           NEXT FIELD lqy03

        WHEN INFIELD(lqy04)  #單位 
           CALL cl_init_qry_var()
           LET g_qryparam.state= "c"
           LET g_qryparam.form ="q_lqy04"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO lqy04
           NEXT FIELD lqy04
         OTHERWISE EXIT CASE
      END CASE

      ON ACTION about
         CALL cl_about()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

   END CONSTRUCT

   IF INT_FLAG THEN
      RETURN
   END IF

   LET g_wc = " lqx00 = '",g_lqx.lqx00,"' AND ",g_wc CLIPPED

   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT lqx01,lqx10,lqx11,lqx02 FROM lqx_file ",   #CHI-C80047 add lqx02
                  " WHERE ", g_wc CLIPPED,
                  "   AND lqxplant = '",g_plant,"' ",   #FUN-C60089 add
                  " ORDER BY lqx01"
   ELSE
      LET g_sql = "SELECT UNIQUE lqx01,lqx10,lqx11,lqx02 ",   #CHI-C80047 add
                  "  FROM lqx_file, lqy_file ",
                  " WHERE lqx01 = lqy01 ",
                  "   AND lqx00 = lqy00 ",   #FUN-C60089 add
                  "   AND lqy09 = lqx11 AND lqy08 = lqx10 ", 
                  "   AND lqy10 = lqx02 ",   #CHI-C80047 add
                  "   AND lqxplant = lqyplant  ",       #FUN-C60089 add
                  "   AND lqxplant = '",g_plant,"' ",   #FUN-C60089 add
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lqx01"
   END IF

   PREPARE t600_prepare FROM g_sql
   DECLARE t600_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t600_prepare

   IF g_wc2 = " 1=1" THEN
      LET g_sql="SELECT COUNT(*) FROM lqx_file WHERE ",g_wc CLIPPED,
                "   AND lqxplant = '",g_plant,"' "    #FUN-C60089 add
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lqx01) FROM lqx_file,lqy_file WHERE ",
                "lqy01=lqx01  AND lqy09 = lqx11 AND lqy08 = lqx10 ",
                " AND lqy00 = lqx00  ",   #FUN-C60089 add
                " AND lqy10 = lqx02  ",   #CHI-C80047 add
                " AND lqxplant = lqyplant  ",       #FUN-C60089 add
                " AND lqxplant = '",g_plant,"' ",   #FUN-C60089 add
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t600_precount FROM g_sql
   DECLARE t600_count CURSOR FOR t600_precount

END FUNCTION

FUNCTION t600_menu()
   DEFINE l_str  LIKE type_file.chr1000
   DEFINE l_msg  LIKE type_file.chr1000

   WHILE TRUE
      CALL t600_bp("G")
      CASE g_action_choice

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t600_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t600_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t600_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t600_u()
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t600_x()
            END IF

         WHEN "detail"
           IF cl_chk_act_auth() THEN
               CALL t600_b()
           ELSE
              LET g_action_choice = NULL
           END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lqx),'','')
            END IF

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t600_y()
            END IF

         WHEN "category"  #生效營運中心
           IF cl_chk_act_auth() THEN
              IF g_lqx.lqx01 IS NULL THEN
                 CALL cl_err('',-400,0)
              ELSE
                #CALL t590_sub(g_lqx.lqx01,g_lqx.lqx11,'2',g_lqx.lqx10)   #FUN-C60089 mark
                 CALL t590_sub(g_lqx.lqx01,g_lqx.lqx11,g_lsz02,g_lqx.lqx10,g_lqx.lqx02)   #FUN-C60089 add  #CHI-C80047 add lqx02
              END IF
           END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t600_v()
               CALL t600_field_pic()
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION

FUNCTION t600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   CALL cl_set_act_visible("accept,cancel",FALSE )

   LET g_action_choice = " "
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_lqy TO s_lqy.* ATTRIBUTE(COUNT=g_rec_b)
        BEFORE DISPLAY
           CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG

      ON ACTION first
         CALL t600_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION previous
         CALL t600_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION jump
         CALL t600_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION next
         CALL t600_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION last
         CALL t600_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
      #CHI-C80041---end 
      ON ACTION category
         LET g_action_choice="category"
         EXIT DIALOG

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG


   END DIALOG

   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION

FUNCTION t600_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lqy.clear()
   DISPLAY ' ' TO FORMONLY.cnt

   CALL t600_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lqx.* TO NULL
      RETURN
   END IF

   OPEN t600_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lqx.* TO NULL
   ELSE
      OPEN t600_count
      FETCH t600_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt

      CALL t600_fetch('F')
   END IF

END FUNCTION

FUNCTION t600_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     t600_cs INTO g_lqx.lqx01,g_lqx.lqx10,g_lqx.lqx11,g_lqx.lqx02     #CHI-C80047 add
      WHEN 'P' FETCH PREVIOUS t600_cs INTO g_lqx.lqx01,g_lqx.lqx10,g_lqx.lqx11,g_lqx.lqx02     #CHI-C80047 add
      WHEN 'F' FETCH FIRST    t600_cs INTO g_lqx.lqx01,g_lqx.lqx10,g_lqx.lqx11,g_lqx.lqx02     #CHI-C80047 add
      WHEN 'L' FETCH LAST     t600_cs INTO g_lqx.lqx01,g_lqx.lqx10,g_lqx.lqx11,g_lqx.lqx02     #CHI-C80047 add
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
      FETCH ABSOLUTE g_jump t600_cs INTO g_lqx.lqx01,g_lqx.lqx10,g_lqx.lqx11
      LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqx.lqx01,SQLCA.sqlcode,0)
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

   SELECT * INTO g_lqx.* FROM lqx_file 
     WHERE lqx01 = g_lqx.lqx01 
       AND lqx00 = g_lqx.lqx00   #FUN-C60089 add
       AND lqx02 = g_lqx.lqx02   #CHI-C80047 add
       AND lqx10 = g_lqx.lqx10 
       AND lqx11 = g_lqx.lqx11 
       AND lqxplant = g_plant    #FUN-C60089 add
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lqx_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lqx.* TO NULL
      RETURN
   END IF

   LET g_data_owner = g_lqx.lqxuser
   LET g_data_group = g_lqx.lqxgrup
   LET g_data_plant = g_lqx.lqxplant  
   CALL t600_show()

END FUNCTION


FUNCTION t600_show()
   LET g_lqx_t.* = g_lqx.*
   LET g_lqx_o.* = g_lqx.*
   DISPLAY BY NAME g_lqx.lqx10, g_lqx.lqx00, g_lqx.lqx01, g_lqx.lqx11, g_lqx.lqx02, g_lqx.lqx03,
                   g_lqx.lqx04, g_lqx.lqx05, g_lqx.lqx09, g_lqx.lqx12, g_lqx.lqx13, g_lqx.lqx05,
                   g_lqx.lqx06, g_lqx.lqx07, g_lqx.lqx08, g_lqx.lqxplant, g_lqx.lqxlegal,
                   g_lqx.lqxuser, g_lqx.lqxgrup, g_lqx.lqxoriu, g_lqx.lqxorig, g_lqx.lqxcrat,
                   g_lqx.lqxmodu, g_lqx.lqxdate, g_lqx.lqxacti 
   CALL t600_lqx01()
   CALL t600_lqx10()      
   CALL t600_lqx02('d')
   CALL t600_b_fill(g_wc2)
   CALL t600_field_pic()
END FUNCTION

FUNCTION t600_lqx10()  #制定營運中心名稱
DEFINE l_rtz13      LIKE rtz_file.rtz13
DEFINE l_azt02     LIKE azt_file.azt02

   DISPLAY '' TO FORMONLY.lqx10_desc

   IF NOT cl_null(g_lqx.lqx10) THEN
       SELECT rtz13 INTO l_rtz13 FROM rtz_file
        WHERE rtz01 = g_lqx.lqx10
          AND rtz28 = 'Y'
       DISPLAY l_rtz13 TO FORMONLY.lqx10_desc

   END IF
   DISPLAY '' TO FORMONLY.rtz13
   
   IF NOT cl_null(g_lqx.lqxplant) THEN
       SELECT rtz13 INTO l_rtz13 FROM rtz_file
        WHERE rtz01 = g_lqx.lqxplant
          AND rtz28 = 'Y'
       DISPLAY l_rtz13 TO FORMONLY.rtz13
   
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_lqx.lqxlegal 
      DISPLAY l_azt02 TO FORMONLY.azt02
   END IF
END FUNCTION

FUNCTION t600_lqx01()  #方案代碼說明
DEFINE l_lsl03      LIKE lsl_file.lsl03

   DISPLAY '' TO FORMONLY.lqx01_desc

   IF NOT cl_null(g_lqx.lqx01) THEN
       SELECT lsl03 INTO l_lsl03 FROM lsl_file
        WHERE lsl02 = g_lqx.lqx01
          AND lslconf = 'Y'
          AND lsl01 = g_lqx.lqx10 
       DISPLAY l_lsl03 TO FORMONLY.lqx01_desc
   END IF
END FUNCTION


FUNCTION t600_lqx02(p_cmd) #卡種編號
    DEFINE p_cmd       LIKE type_file.chr1
    DEFINE p_code      LIKE type_file.chr1
    DEFINE l_lph02     LIKE lph_file.lph02
    DEFINE l_lph03     LIKE lph_file.lph03
    DEFINE l_lph06     LIKE lph_file.lph06
    DEFINE l_lph24     LIKE lph_file.lph24
    DEFINE l_lphacti   LIKE lph_file.lphacti
    LET g_errno = ' '
    SELECT lph02,lph03,lph06,lph24,lphacti
      INTO l_lph02,l_lph03,l_lph06,l_lph24,l_lphacti
      FROM lph_file WHERE lph01 = g_lqx.lqx02
                      AND lphacti='Y'
    CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'mfg3006'
         WHEN l_lphacti='N'      LET g_errno = 'mfg9028'
         WHEN l_lph06 = 'N'      LET g_errno = 'alm-628'
         WHEN l_lph24 <> 'Y'     LET g_errno = '9029'
         OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
    DISPLAY l_lph02 TO FORMONLY.lph02
    END IF
END FUNCTION

FUNCTION t600_field_pic()
   DEFINE l_flag   LIKE type_file.chr1

   CASE
     WHEN g_lqx.lqxacti = 'N'
        CALL cl_set_field_pic("","","","","","N")
     WHEN g_lqx.lqx05 = 'Y'
        CALL cl_set_field_pic("Y","","","","","")
     WHEN g_lqx.lqx05 = 'X'  #CHI-C80041
        CALL cl_set_field_pic("","","","","Y","")  #CHI-C80041
     OTHERWISE
        CALL cl_set_field_pic("","","","","","")
   END CASE
END FUNCTION

FUNCTION t600_b_fill(p_wc2)              #BODY FILL UP

    DEFINE p_wc2       STRING

    LET g_sql = "SELECT lqy06,lqy02,lqy07,lqy03,ima02,ima021,lqy04,'',lqy05 ",
                "  FROM lqy_file,ima_file",
                " WHERE lqy01 ='",g_lqx.lqx01,"' ",
                "  AND lqy00 = '",g_lqx.lqx00,"' ",   #FUN-C60058 add
                "  AND lqy08 = '",g_lqx.lqx10,"' ", 
                "  AND lqy09 = '",g_lqx.lqx11,"' ",  
                "  AND lqy10 = '",g_lqx.lqx02,"' ",   #CHI-C80047 add
               #"  AND lqyplant = '",g_plant,"' ",    #FUN-C60058 add   #CHI-C80047 mark
                "  AND lqyplant = '",g_lqx.lqxplant,"' ",               #CHI-C80047 add
                "  AND ima01= lqy03"    

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
  #LET g_sql=g_sql CLIPPED," ORDER BY 1,2 "   #FUN-C60089 mark 
   LET g_sql=g_sql CLIPPED," ORDER BY lqy06 "   #FUN-C60089 add
   DISPLAY g_sql

    PREPARE t600_pb FROM g_sql
    DECLARE lqy_cs                       #CURSOR
        CURSOR FOR t600_pb

    CALL g_lqy.clear()
    LET g_cnt = 1

    FOREACH lqy_cs INTO g_lqy[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT gfe02 INTO g_lqy[g_cnt].gfe02 FROM gfe_file WHERE gfe01=g_lqy[g_cnt].lqy04 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
      END IF
    END FOREACH
    CALL g_lqy.deleteElement(g_cnt)

    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION t600_a()
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num10

   MESSAGE ""
   CLEAR FORM
   CALL g_lqy.clear()

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_lqx.* LIKE lqx_file.*
   LET g_lqx01_t = NULL

   LET g_lqx.lqx05 = 'N'
   LET g_lqx_t.* = g_lqx.*
   LET g_lqx_o.* = g_lqx.*
   CALL cl_opmsg('a')
   WHILE TRUE
      IF g_argv1 = '0' THEN
         LET g_lqx.lqx00 = '0'
         LET g_lqx.lqx09 = ' '
      ELSE
         IF g_argv1 = '1' THEN
            LET g_lqx.lqx00 = '1'
            LET g_lqx.lqx09 = '0'
         END IF
      END IF
      LET g_lqx.lqx05='N'
      LET g_lqx.lqxplant = g_plant
      LET g_lqx.lqxlegal = g_legal
      LET g_data_plant = g_plant    #No.FUN-A10060
      LET g_lqx.lqxoriu = g_user    #No.FUN-A10060
      LET g_lqx.lqxorig = g_grup    #No.FUN-A10060
      LET g_lqx.lqxuser=g_user
      LET g_lqx.lqxcrat=g_today
      LET g_lqx.lqxgrup=g_grup
      LET g_lqx.lqxacti='Y'
      LET g_lqx.lqx10 = g_plant      #制定營運中心
      LET g_lqx.lqx11 = 0            #版本號
      LET g_lqx.lqx12 = '1'          #兌換限制
      LET g_lqx.lqx13 = 0            #兌換次數
      CALL t600_lqx10()
      CALL t600_i("a")

      IF INT_FLAG THEN
         INITIALIZE g_lqx.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         ROLLBACK WORK
         EXIT WHILE
      END IF

      IF cl_null(g_lqx.lqx01) THEN
         CONTINUE WHILE
      END IF

      LET g_lqx.lqxoriu = g_user      
      LET g_lqx.lqxorig = g_grup      
      INSERT INTO lqx_file VALUES (g_lqx.*)

      IF SQLCA.sqlcode THEN
         CALL cl_err(g_lqx.lqx01,SQLCA.sqlcode,1)
         ROLLBACK WORK      
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_lqx.lqx01,'I')
      END IF

      CALL t600_temp('a',g_plant,g_legal)  #將前一版號的資料預設帶入  #CHI-C80047 add 

      SELECT * INTO g_lqx.* FROM lqx_file
         WHERE lqx01 = g_lqx.lqx01
           AND lqx00 = g_lqx.lqx00  #FUN-C60089 add
           AND lqx02 = g_lqx.lqx02  #CHI-C80047 add
           AND lqx10 = g_lqx.lqx10 
           AND lqx11 = g_lqx.lqx11 
           AND lqxplant = g_plant   #FUN-C60089 add
      LET g_lqx01_t = g_lqx.lqx01
      LET g_lqx02_t = g_lqx.lqx02   #CHI-C80047 add
      LET g_lqx_t.* = g_lqx.*
      LET g_lqx_o.* = g_lqx.*
      CALL g_lqy.clear()

      CALL t600_b_fill(" 1=1")
      CALL t600_refresh()

     #因為預設會將前一版本的單身資料全部都帶進,所以這邊不可以直接將單身資料筆數設定為0
      IF cl_null(g_rec_b) THEN
         LET g_rec_b = 0
      END IF
      CALL t600_b()
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION t600_i(p_cmd)

DEFINE l_n,l_n1    LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr8
DEFINE li_result   LIKE type_file.num5

   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY BY NAME g_lqx.lqx10, g_lqx.lqx00, g_lqx.lqx01, g_lqx.lqx11, g_lqx.lqx02, g_lqx.lqx03,
                   g_lqx.lqx04, g_lqx.lqx05, g_lqx.lqx09, g_lqx.lqx12, g_lqx.lqx13, g_lqx.lqx05,
                   g_lqx.lqx06, g_lqx.lqx07, g_lqx.lqx08, g_lqx.lqxplant, g_lqx.lqxlegal,
                   g_lqx.lqxuser, g_lqx.lqxgrup, g_lqx.lqxoriu, g_lqx.lqxorig, g_lqx.lqxcrat,
                   g_lqx.lqxmodu, g_lqx.lqxdate, g_lqx.lqxacti 

   INPUT BY NAME   g_lqx.lqx01,g_lqx.lqx02,g_lqx.lqx03,
                   g_lqx.lqx04,g_lqx.lqx09,g_lqx.lqx12,
                   g_lqx.lqx13,g_lqx.lqx08
       WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_flag2 = 'N'
         LET g_before_input_done = FALSE
         CALL t600_set_entry(p_cmd)
         CALL t600_set_no_entry(p_cmd)
         CALL t600_entry_lqx12()
         CALL t600_lqx10()
         LET g_before_input_done = TRUE

      AFTER FIELD lqx01
          IF cl_null(g_lqx.lqx01) THEN
             CALL cl_err('','alm-809',0)
             NEXT FIELD lqx01 
          END IF
          IF NOT cl_null(g_lqx.lqx01) THEN
             IF p_cmd="a" OR (p_cmd="u" AND g_lqx.lqx01 !=g_lqx01_t ) THEN
                LET g_errno = ' '
                CALL t600_chk_lqx01()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD lqx01 
                END IF
                CALL t600_lqx01()
               #IF g_flag2 <> 'Y' THEN   #FUN-C60089 add  #CHI-C80047 mark
                IF NOT cl_null(g_lqx.lqx02) AND p_cmd = 'a' THEN  #CHI-C80047 add
                   SELECT MAX(lqx11) INTO g_lqx.lqx11 FROM lqx_file
                     WHERE lqx01 = g_lqx.lqx01 AND lqx10 = g_lqx.lqx10 
                       AND lqx00 = g_lqx.lqx00   #FUN-C60089 add
                       AND lqx02 = g_lqx.lqx02   #CHI-C80047 add
                       AND lqxplant = g_plant    #FUN-C60089 add
                       AND lqx05 <> 'X'  #CHI-C80041
                   IF cl_null(g_lqx.lqx11) THEN
                     LET g_lqx.lqx11 = 0
                   END IF
                  #CALL t600_temp('a',g_plant,g_legal)  #將前一版號的資料預設帶入  #CHI-C80047 mark
                   CALL t600_lqx11()
                END IF  #FUN-C60089 add 
                CALL t600_entry_lqx12()
             END IF
          END IF

      AFTER FIELD lqx02
         IF cl_null(g_lqx.lqx02) THEN
            DISPLAY '' TO FORMONLY.lph02
            CALL cl_err('','alm-809',0)
            NEXT FIELD lqx02
         ELSE
            SELECT COUNT(*) INTO l_n1 FROM lph_file
                WHERE lph01 = g_lqx.lqx02
            IF l_n1=0 THEN
               CALL cl_err(g_lqx.lqx02,'alm-h46',0)
               NEXT FIELD lqx02
            END IF
            CALL t600_lqx02(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD lqx02
            END IF
           #CHI-C80047 add START
            IF p_cmd="a" OR (p_cmd="u" AND g_lqx.lqx02 !=g_lqx02_t ) THEN 
                LET g_errno = ' '
                CALL t600_chk_lqx01()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD lqx02
                END IF
                CALL t600_lqx01()
                IF NOT cl_null(g_lqx.lqx01) AND p_cmd = 'a' THEN  
                   SELECT MAX(lqx11) INTO g_lqx.lqx11 FROM lqx_file
                     WHERE lqx01 = g_lqx.lqx01 AND lqx10 = g_lqx.lqx10
                       AND lqx00 = g_lqx.lqx00  
                       AND lqx02 = g_lqx.lqx02  
                       AND lqxplant = g_plant 
                       AND lqx05 <> 'X'  #CHI-C80041  
                   IF cl_null(g_lqx.lqx11) THEN
                     LET g_lqx.lqx11 = 0
                   END IF
                   CALL t600_lqx11()
                END IF  
                CALL t600_entry_lqx12()
            END IF
           #CHI-C80047 add END
         END IF

      AFTER FIELD lqx03
         IF cl_null(g_lqx.lqx03) THEN
            CALL cl_err('','alm-809',0)
            NEXT FIELD lqx03
         ELSE
            IF g_lqx.lqx03 < g_today THEN
               CALL cl_err('','alm-804',0)
               NEXT FIELD lqx03
            END IF
         END IF

      AFTER FIELD lqx04
         IF cl_null(g_lqx.lqx04) THEN
            CALL cl_err('','alm-809',0)
            NEXT FIELD lqx04
         ELSE
            IF g_lqx.lqx04 < g_lqx.lqx03 THEN
               CALL cl_err('','alm-805',0)
               NEXT FIELD lqx04
            END IF
         END IF

      ON CHANGE lqx12
         CALL t600_entry_lqx12()
         IF g_lqx.lqx12 <> '1' THEN
            IF g_lqx.lqx13 < 1 THEN
               CALL cl_err('','aec-042',0)
               NEXT FIELD lqx13
            END IF
         ELSE
            LET g_lqx.lqx13 = 0
            DISPLAY BY NAME g_lqx.lqx13
         END IF
  
      AFTER FIELD lqx13 
         IF NOT cl_null(g_lqx.lqx13) THEN
            IF g_lqx.lqx12 <> '1' THEN
               IF g_lqx.lqx13 < 1 THEN
                  CALL cl_err('','aec-042',0)
                  NEXT FIELD lqx13
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
    
           #WHEN INFIELD(lqx01) #方案編號
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.form ="q_lsl02"
           #   LET g_qryparam.arg1 = g_plant
           #   LET g_qryparam.default1 = g_lqx.lqx01
           #   CALL cl_create_qry() RETURNING g_lqx.lqx01
           #   DISPLAY g_lqx.lqx01 TO lqx01
           #   CALL t600_lqx01()
           #   NEXT FIELD lqx01

            WHEN INFIELD(lqx01) #方案編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lpq011"
               LET g_qryparam.arg1 = g_plant
               LET g_qryparam.default1 = g_lqx.lqx01
               LET g_qryparam.where = " lpq13 = '",g_plant,"' AND lpq00 = '",g_argv1,"'"
               CALL cl_create_qry() RETURNING g_lqx.lqx01
               DISPLAY g_lqx.lqx01 TO lqx01
               CALL t600_lqx01()
               NEXT FIELD lqx01
          
            WHEN INFIELD(lqx02) #卡種編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lph01_2" 
               LET g_qryparam.default1 = g_lqx.lqx02
               CALL cl_create_qry() RETURNING g_lqx.lqx02
               DISPLAY g_lqx.lqx02 TO lqx02
               CALL t600_lqx02('d')
               NEXT FIELD lqx02
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

  #CHI-C80047 mark START 
  #IF INT_FLAG AND p_cmd = 'a' AND g_flag2 = 'Y' THEN  #非正常離開必須要將剛才預設新增的單身資料刪除,避免錯誤 
  #   DELETE FROM lqx_file WHERE lqx00 = g_lqx.lqx00 AND lqx01 = g_lqx.lqx01    #FUN-C60089 add lqx00 
  #                          AND lqx10 = g_lqx.lqx10 AND lqx11 = g_lqx.lqx11
  #                          AND lqxplant = g_plant                             #FUN-C60089 add
  #   DELETE FROM lqy_file WHERE lqy00 = g_lqx.lqx00 AND lqy01 = g_lqx.lqx01    #FUN-C60089 add lqy00
  #                          AND lqy08 = g_lqx.lqx10 AND lqy09 = g_lqx.lqx11
  #                          AND lqyplant = g_plant                             #FUN-C60089 add
  #  #DELETE FROM lsz_file WHERE lsz01 = g_lqx.lqx01 AND lsz02 = '2' AND lsz11 = g_lqx.lqx10 AND lsz12 = g_lqx.lqx11    #FUN-C60089 mark
  #   DELETE FROM lsz_file WHERE lsz01 = g_lqx.lqx01 AND lsz02 = g_lsz02        #FUN-C60089 add
  #                          AND lsz11 = g_lqx.lqx10 AND lsz12 = g_lqx.lqx11    #FUN-C60089 add
  #                          AND lszplant = g_plant                             #FUN-C60089 add
  #END IF
  #CHI-C80047 mark END

END FUNCTION


FUNCTION t600_chk_lqx01()  #確認方案代碼已存在於almi600/almi601內 並且已發出
DEFINE l_n          LIKE type_file.num5
DEFINE l_lpq08      LIKE lpq_file.lpq08
DEFINE l_lpq15      LIKE lpq_file.lpq15

   LET g_errno = ' '
   LET l_n = 0
   IF NOT cl_null(g_lqx.lqx01) THEN
      IF cl_null(g_lqx.lqx02) THEN   #CHI-C80047 add
         SELECT COUNT(*) INTO l_n FROM lpq_file
          WHERE lpq01 = g_lqx.lqx01
            AND lpq13 = g_lqx.lqx10
            AND lpq00 = g_argv1
            AND lpqplant = g_plant     #FUN-C60058 add
         IF l_n = 0 THEN
            LET g_errno = 'alm-h34'   #輸入的方案代碼不存在於almi600/almi601中
            RETURN
         END IF
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM lqx_file   #輸入方案代碼已存在未確認的變更單
          WHERE lqx01 = g_lqx.lqx01 AND lqx05 = 'N'
            AND lqx00 = g_lqx.lqx00   #FUN-C60089 add
            AND lqx10 = g_lqx.lqx10
            AND lqx00 = g_argv1
            AND lqxplant = g_plant    #FUN-C60089 add
            AND lqx05 <> 'X'  #CHI-C80041
         IF l_n > 0 THEN
            LET g_errno = 'alm-h37'
            RETURN
         END IF
     #CHI-C80047 add END
      ELSE
         SELECT COUNT(*) INTO l_n FROM lpq_file
          WHERE lpq01 = g_lqx.lqx01
            AND lpq03 = g_lqx.lqx02  
            AND lpq13 = g_lqx.lqx10
            AND lpq00 = g_argv1
            AND lpqplant = g_plant   
         IF l_n = 0 THEN
            LET g_errno = 'alm-h34'   #輸入的方案代碼不存在於almi600/almi601中
            RETURN
         END IF
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM lqx_file   #輸入方案代碼已存在未確認的變更單
          WHERE lqx01 = g_lqx.lqx01 AND lqx05 = 'N'
            AND lqx00 = g_lqx.lqx00  
            AND lqx02 = g_lqx.lqx02  
            AND lqx10 = g_lqx.lqx10
            AND lqx00 = g_argv1
            AND lqxplant = g_plant   
            AND lqx05 <> 'X'  #CHI-C80041
         IF l_n > 0 THEN
            LET g_errno = 'alm-h37'
            RETURN
         END IF
     #CHI-C80047 add END
         SELECT lpq08,lpq15 INTO l_lpq08,l_lpq15
             FROM lpq_file
            WHERE lpq01 = g_lqx.lqx01
              AND lpq00 = g_lqx.lqx00  
              AND lpq03 = g_lqx.lqx02  
              AND lpq13 = g_lqx.lqx10
              AND lpqplant = g_plant   
      END IF    #CHI-C80047 add
   END IF
   IF l_lpq08 = 'N' THEN
      LET g_errno = 'alm-h35'
      RETURN
   END IF
   IF l_lpq15 = 'N' THEN
      LET g_errno = 'alm-h36'
      RETURN
   END IF
END FUNCTION


FUNCTION t600_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("lqx01,",TRUE)
  END IF

END FUNCTION

FUNCTION t600_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

  CALL cl_set_comp_entry("lqx05,lqx06,lqx07",FALSE)                      

  IF p_cmd='u' AND g_chkey='N' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("lqx01",FALSE)
  END IF

END FUNCTION

FUNCTION t600_entry_lqx12()
  IF g_lqx.lqx12 = '1' THEN   #當兌換限制為1.不限兌換次數時,兌換次數不可編輯
     LET g_lqx.lqx13 = 0
     DISPLAY BY NAME g_lqx.lqx13
     CALL cl_set_comp_entry("lqx13",FALSE)
  ELSE
     CALL cl_set_comp_entry("lqx13",TRUE)
     CALL cl_set_comp_required("lqx13",TRUE)
  END IF
END FUNCTION

FUNCTION t600_b()
DEFINE
       l_ac_t            LIKE type_file.num5,
       l_n,l_n1,l_n2     LIKE type_file.num5,
       l_cnt             LIKE type_file.num5,
       l_lock_sw         LIKE type_file.chr1,
       p_cmd             LIKE type_file.chr1,
       l_allow_insert    LIKE type_file.num5,
       l_allow_delete    LIKE type_file.num5
DEFINE l_rtz04_except    LIKE type_file.num5         #營運中心是否尋在商品策略  
DEFINE l_rtz04           LIKE rtz_file.rtz04         #商品策略   
    LET g_action_choice = ""


    IF s_shut(0) THEN
       RETURN
    END IF

    IF cl_null(g_lqx.lqx01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    SELECT * INTO g_lqx.* FROM lqx_file
     WHERE lqx01 = g_lqx.lqx01
       AND lqx00 = g_lqx.lqx00  #FUN-C60089 add
       AND lqx02 = g_lqx.lqx02  #CHI-C80047 add
       AND lqx10 = g_lqx.lqx10
       AND lqx11 = g_lqx.lqx11
       AND lqxplant = g_plant   #FUN-C60089 add

    IF g_lqx.lqxacti ='N' THEN
       CALL cl_err(g_lqx.lqx01,'mfg1000',0)
       RETURN
    END IF
    IF g_lqx.lqx05 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lqx.lqx05 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
  
    IF g_plant <> g_lqx.lqx10 THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
   
    LET g_forupd_sql = "SELECT lqy06,lqy02,lqy07,lqy03,'','',lqy04,'',lqy05 ",
                       "  FROM lqy_file",
                       " WHERE lqy01=? AND lqy06=?  ",
                       "   AND lqy00 = '",g_lqx.lqx00,"' ",       #FUN-C60058 add
                       "   AND lqy10 = '",g_lqx.lqx02,"' ",       #CHI-C80047 add
                       "   AND lqy09 = '",g_lqx.lqx11,"' AND lqy08 = '",g_lqx.lqx10,"' FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    CALL cl_opmsg('b')

    INPUT ARRAY g_lqy WITHOUT DEFAULTS FROM s_lqy.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           LET g_lqy04_t = NULL   

        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'           
           LET l_n  = ARR_COUNT()

           BEGIN WORK

           OPEN t600_cl USING g_lqx.lqx01, g_lqx.lqx10, g_lqx.lqx11, g_lqx.lqx02  #CHI-C80047 add lqx02
           IF STATUS THEN
              CALL cl_err("OPEN t600_cl:", STATUS, 1)
              CLOSE t600_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t600_cl INTO g_lqx.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lqx.lqx01,SQLCA.sqlcode,0)
              CLOSE t600_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lqy_t.* = g_lqy[l_ac].*  #BACKUP
              LET g_lqy_o.* = g_lqy[l_ac].*  #BACKUP
              LET g_lqy04_t = g_lqy[l_ac].lqy04  
              OPEN t600_bcl USING g_lqx.lqx01,g_lqy[l_ac].lqy06  
              IF STATUS THEN
                 CALL cl_err("OPEN t600_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t600_bcl INTO g_lqy[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lqy[l_ac].lqy02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT ima02,ima021 INTO g_lqy[l_ac].ima02,
                                          g_lqy[l_ac].ima021
                    FROM ima_file WHERE ima01=g_lqy[l_ac].lqy03
              END IF
              CALL t600_lqy04('d')
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET p_cmd='a'
           LET l_n = ARR_COUNT()
           INITIALIZE g_lqy[l_ac].* TO NULL
           IF g_argv1 = '0' THEN
              LET g_lqy[l_ac].lqy07 = 0
           END IF
           IF g_argv1 = '1' THEN
              LET g_lqy[l_ac].lqy02 = 0
           END IF
           LET g_lqy_t.* = g_lqy[l_ac].*
           LET g_lqy_o.* = g_lqy[l_ac].*
           LET g_lqy04_t = g_lqy[l_ac].lqy04
           NEXT FIELD lqy06   

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_lqy[l_ac].lqy02) THEN LET g_lqy[l_ac].lqy02 = 0 END IF
           IF cl_null(g_lqy[l_ac].lqy07) THEN LET g_lqy[l_ac].lqy07 = 0 END IF
           INSERT INTO lqy_file(lqy00,lqy01,lqy02,lqy03,lqy04,lqy05,lqy06,lqy07,lqy08,lqy09,lqyplant,lqylegal,lqy10)   #CHI-C80047 add ,lqy00,lqy10,  
                 VALUES( g_lqx.lqx00,g_lqx.lqx01,g_lqy[l_ac].lqy02, g_lqy[l_ac].lqy03, g_lqy[l_ac].lqy04,g_lqy[l_ac].lqy05,
                        g_lqy[l_ac].lqy06,g_lqy[l_ac].lqy07,g_lqx.lqx10,g_lqx.lqx11,g_plant, g_legal,g_lqx.lqx02 )   #CHI-C80047 add lqx00,lqx02
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lqy_file",g_lqx.lqx01,g_lqy[l_ac].lqy06,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

       BEFORE FIELD lqy06                        #default 序號
          IF cl_null(g_lqy[l_ac].lqy06) THEN
              SELECT max(lqy06)+1 INTO g_lqy[l_ac].lqy06 FROM lqy_file
               WHERE lqy01 = g_lqx.lqx01
                 AND lqy00 = g_lqx.lqx00    #FUN-C60058 add
                 AND lqy08 = g_lqx.lqx10 AND lqy09 = g_lqx.lqx11
                 AND lqy10 = g_lqx.lqx02    #CHI-C80047 add
                 AND lqyplant = g_plant     #FUN-C60058 add
              IF g_lqy[l_ac].lqy06 IS NULL THEN
                 LET g_lqy[l_ac].lqy06 = 1
              END IF
           ELSE 
              IF (p_cmd = 'u' AND g_lqy[l_ac].lqy06 != g_lqy_t.lqy06 )
               OR (p_cmd = 'a' AND cl_null(g_lqy_t.lqy06) )THEN
                 SELECT COUNT(*) INTO l_n FROM lqy_file 
                   WHERE lqy01 = g_lqx.lqx01
                    AND lqy00 = g_lqx.lqx00       #FUN-C60058 add
                    AND lqy08 = g_lqx.lqx10 AND lqy09 = g_lqx.lqx11
                    AND lqy10 = g_lqx.lqx02       #CHI-C80047 add
                    AND lqy06 = g_lqy[l_ac].lqy06 
                    AND lqyplant = g_plant        #FUN-C60058 add 
                 IF NOT cl_null(l_n) AND l_n > 0 THEN
                    CALL cl_err('','-239',0)  
                    NEXT FIELD lqy06
                 END IF 
              END IF
           END IF

       AFTER FIELD lqy06 
           IF NOT cl_null(g_lqy[l_ac].lqy06) THEN
              IF (p_cmd = 'u' AND g_lqy[l_ac].lqy06 != g_lqy_t.lqy06 )
               OR (p_cmd = 'a' AND cl_null(g_lqy_t.lqy06) )THEN
                 SELECT COUNT(*) INTO l_n FROM lqy_file
                   WHERE lqy01 = g_lqx.lqx01
                    AND lqy00 = g_lqx.lqx00       #FUN-C60058 add
                    AND lqy08 = g_lqx.lqx10 AND lqy09 = g_lqx.lqx11
                    AND lqy06 = g_lqy[l_ac].lqy06
                    AND lqy10 = g_lqx.lqx02       #CHI-C80047 add
                    AND lqyplant = g_plant        #FUN-C60058 add
                 IF NOT cl_null(l_n) AND l_n > 0 THEN
                    CALL cl_err('',-239,0) 
                    NEXT FIELD lqy06
                 END IF
              END IF
           END IF

       AFTER FIELD lqy07
          IF NOT cl_null(g_lqy[l_ac].lqy07) AND g_argv1 = '1' THEN
             IF g_lqy[l_ac].lqy07 < 0 THEN
                CALL cl_err('','alm-342',0)
                LET g_lqy[l_ac].lqy07 = g_lqy_t.lqy07
                NEXT FIELD lqy07
             END IF
          END IF

       AFTER FIELD lqy02
         #IF NOT cl_null(g_lqy[l_ac].lqy02) AND cl_null(g_argv1) THEN  #FUN-C90067 mark
          IF NOT cl_null(g_lqy[l_ac].lqy02) AND g_argv1 = '0'  THEN  #FUN-C90067 add
             IF g_lqy[l_ac].lqy02 < 0 THEN
                CALL cl_err("","alm-808",0)
                NEXT FIELD lqy02
             END IF
            #FUN-C90067 add START
             CALL t600_chk_lqypk()
             IF NOT cl_null(g_errno ) THEN 
                CALL cl_err('',g_errno,0)
                NEXT FIELD CURRENT
             END IF
            #IF NOT cl_null(g_lqy[l_ac].lqy03) THEN
            #   LET l_n = 0
            #   SELECT COUNT(*) INTO l_n FROM lqy_file
            #    WHERE lqy00 = g_lqx.lqx00
            #      AND lqy01 = g_lqx.lqx01    
            #      AND lqy02 = g_lqy[l_ac].lqy02
            #      AND lqy03 = g_lqy[l_ac].lqy03
            #      AND lqy06 <> g_lqy[l_ac].lqy06
            #      AND lqy08 = g_lqx.lqx10
            #      AND lqy09 = g_lqx.lqx11
            #      AND lqy10 = g_lqx.lqx02 
            #      AND lqyplant = g_plant  
            #   IF l_n > 0 THEN
            #      CALL cl_err('','alm-h73',0)
            #      NEXT FIELD lqy02 
            #   END IF
            #END IF
            #FUN-C90067 add END 
          END IF

       AFTER FIELD lqy03
          IF cl_null(g_lqy[l_ac].lqy03) THEN
             LET g_lqy[l_ac].ima02 = ''
             LET g_lqy[l_ac].ima021 = ''
             DISPLAY g_lqy[l_ac].ima02 TO ima02
             DISPLAY g_lqy[l_ac].ima021 TO ima021
          ELSE
             IF NOT s_chk_item_no(g_lqy[l_ac].lqy03,"") THEN
                CALL cl_err('',g_errno,1)
                LET g_lqy[l_ac].lqy03= g_lqy_t.lqy03
                NEXT FIELD lqy03
             END IF
             LET l_n2 = 0
             SELECT COUNT(*) INTO l_n2 FROM ima_file
                 WHERE ima01 = g_lqy[l_ac].lqy03
                   AND ima154 = 'N'
                IF l_n2=0 THEN
                   CALL cl_err(g_lqy[l_ac].lqy03,'alm-h22',0) 
                   NEXT FIELD lqy03
                END IF
                CALL t600_lqy03('d')
            #FUN-C90067 mark START 
            #IF (g_lqy[l_ac].lqy02 !=g_lqy_t.lqy02) OR
            #   g_lqy_t.lqy02 IS NULL  THEN
            #   SELECT COUNT(*) INTO l_n FROM lqy_file
            #    WHERE lqy01 = g_lqx.lqx01
            #      AND lqy00 = g_lqx.lqx00       #FUN-C60058 add
            #      AND lqy08 = g_lqx.lqx10
            #      AND lqy09 = g_lqx.lqx11
            #      AND lqy02 = g_lqy[l_ac].lqy02
            #      AND lqy03 = g_lqy[l_ac].lqy03
            #      AND lqy10 = g_lqx.lqx02       #CHI-C80047 add
            #      AND lqyplant = g_plant        #FUN-C60058 add
            #   IF l_n > 0 THEN
            #      CALL cl_err("",-239,1)
            #      LET g_lqy[l_ac].lqy02 = g_lqy_t.lqy02
            #      LET g_lqy[l_ac].lqy03 = g_lqy_t.lqy03
            #      LET g_lqy[l_ac].ima02 = ''
            #      LET g_lqy[l_ac].ima021 = ''
            #      LET g_lqy[l_ac].lqy04 = g_lqy_t.lqy04
            #      NEXT FIELD lqy02
            #   END IF
            #END IF
            #FUN-C90067 mark END
            #FUN-C90067 add START
             IF NOT cl_null(g_lqy[l_ac].lqy02) THEN
                CALL t600_chk_lqypk()
                IF NOT cl_null(g_errno ) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD CURRENT
                END IF
               #LET l_n = 0
               #SELECT COUNT(*) INTO l_n FROM lqy_file
               # WHERE lqy00 = g_lqx.lqx00
               #   AND lqy01 = g_lqx.lqx01       
               #   AND lqy02 = g_lqy[l_ac].lqy02
               #   AND lqy03 = g_lqy[l_ac].lqy03
               #   AND lqy06 <> g_lqy[l_ac].lqy06
               #   AND lqy08 = g_lqx.lqx10
               #   AND lqy09 = g_lqx.lqx11
               #   AND lqy10 = g_lqx.lqx02 
               #   AND lqyplant = g_plant   
               #IF l_n > 0 THEN
               #   CALL cl_err('','alm-h73',0)
               #   NEXT FIELD lqy03
               #END IF
             END IF
            #FUN-C90067 add END
          END IF

        AFTER FIELD lqy04
           IF NOT cl_null(g_lqy[l_ac].lqy04) THEN
              CALL t600_lqy04(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                LET g_lqy[l_ac].lqy04= g_lqy_t.lqy04
                NEXT FIELD lqy04
              END IF
              IF NOT t600_lqy05_check() THEN
                 LET g_lqy04_t = g_lqy[l_ac].lqy04
                 NEXT FIELD lqy05
              END IF
              LET g_lqy04_t = g_lqy[l_ac].lqy04
             #FUN-C90067 add START
              CALL t600_chk_lqypk()
              IF NOT cl_null(g_errno ) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD CURRENT
              END IF
             #FUN-C90067 add END
           END IF

       AFTER FIELD lqy05
          IF NOT t600_lqy05_check() THEN NEXT FIELD lqy05 END IF   
         #FUN-C90067 add START
          CALL t600_chk_lqypk()
          IF NOT cl_null(g_errno ) THEN
             CALL cl_err('',g_errno,0)
             NEXT FIELD CURRENT
          END IF
         #FUN-C90067 add END

       BEFORE DELETE
          IF NOT cl_null(g_lqy_t.lqy06) THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM lqy_file
              WHERE lqy01 = g_lqx.lqx01
                AND lqy00 = g_lqx.lqx00      #FUN-C60058 add
                AND lqy06 = g_lqy_t.lqy06 
                AND lqy08 = g_lqx.lqx10 
                AND lqy09 = g_lqx.lqx11
                AND lqy10 = g_lqx.lqx02      #CHI-C80047 add
                AND lqyplant = g_plant       #FUN-C60058 add
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lqy_file","","",SQLCA.sqlcode,"","",1)
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
             LET g_lqy[l_ac].* = g_lqy_t.*
             CLOSE t600_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_lqy[l_ac].lqy06,-263,1) 
             LET g_lqy[l_ac].* = g_lqy_t.*
          ELSE
             UPDATE lqy_file SET lqy06=g_lqy[l_ac].lqy06,  
                                 lqy07=g_lqy[l_ac].lqy07,
                                 lqy02=g_lqy[l_ac].lqy02,
                                 lqy04=g_lqy[l_ac].lqy04, 
                                 lqy05=g_lqy[l_ac].lqy05, 
                                 lqy03=g_lqy[l_ac].lqy03
              WHERE lqy01 = g_lqx.lqx01
                AND lqy00 = g_lqx.lqx00       #FUN-C60058 add
                AND lqy06 = g_lqy_t.lqy06   
                AND lqy08 = g_lqx.lqx10 
                AND lqy09 = g_lqx.lqx11 
                AND lqy10 = g_lqx.lqx02       #CHI-C80047 add
                AND lqyplant = g_plant        #FUN-C60058 add

             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","lqy_file",g_lqx.lqx01,g_lqy_t.lqy02,SQLCA.sqlcode,"","",1)
                LET g_lqy[l_ac].* = g_lqy_t.*
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
                LET g_lqy[l_ac].* = g_lqy_t.*
             END IF
             CLOSE t600_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE t600_bcl
          COMMIT WORK

       ON ACTION CONTROLO
          IF INFIELD(lqy) AND l_ac > 1 THEN
             LET g_lqy[l_ac].* = g_lqy[l_ac-1].*
             LET g_lqy[l_ac].lqy02 = g_rec_b + 1
             NEXT FIELD lqy06
          END IF

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()


       ON ACTION controlp
          CASE
             WHEN INFIELD(lqy03)  #贈品編號
                CALL cl_init_qry_var()
                CALL s_rtz04_except(g_plant) RETURNING l_rtz04_except,l_rtz04
                IF NOT l_rtz04_except THEN
                   LET g_qryparam.form ="q_ima01_6"
                ELSE
                   LET g_qryparam.form ="q_rte00"
                   LET g_qryparam.arg1= l_rtz04
                END IF
                LET g_qryparam.default1 = g_lqy[l_ac].lqy03
                LET g_qryparam.where = " ima154 = 'N' "
                CALL cl_create_qry() RETURNING g_lqy[l_ac].lqy03
                DISPLAY BY NAME g_lqy[l_ac].lqy03
                CALL t600_lqy03('d')
                NEXT FIELD lqy03
       
            WHEN INFIELD(lqy04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.default1 = g_lqy[l_ac].lqy04
               CALL cl_create_qry() RETURNING g_lqy[l_ac].lqy04
               DISPLAY BY NAME g_lqy[l_ac].lqy04
               CALL t600_lqy04('d')
               NEXT FIELD lqy04
          
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

      ON ACTION help
         CALL cl_show_help()

    END INPUT

    DISPLAY BY NAME g_lqx.lqxcrat,g_lqx.lqxmodu,g_lqx.lqxdate

    CLOSE t600_bcl
    COMMIT WORK
    CALL t600_delHeader()    

END FUNCTION 

FUNCTION t600_u()

    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF cl_null(g_lqx.lqx01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    SELECT * INTO g_lqx.* FROM lqx_file
     WHERE lqx01 = g_lqx.lqx01
       AND lqx00 = g_lqx.lqx00  #FUN-C60089 add
       AND lqx02 = g_lqx.lqx02  #CHI-C80047 add
       AND lqx10 = g_lqx.lqx10
       AND lqx11 = g_lqx.lqx11
       AND lqxplant = g_plant   #FUN-C60089 add

    IF g_lqx.lqxacti ='N' THEN
       CALL cl_err(g_lqx.lqx01,'mfg1000',0)
       RETURN
    END IF
    IF g_lqx.lqx05 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lqx.lqx05 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF

    IF g_plant <> g_lqx.lqx10 THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lqx01_t = g_lqx.lqx01
    LET g_lqx02_t = g_lqx.lqx02    #CHI-C80047 add
    BEGIN WORK

    OPEN t600_cl USING g_lqx.lqx01, g_lqx.lqx10, g_lqx.lqx11, g_lqx.lqx02     #CHI-C80047 add lqx02
    IF STATUS THEN
       CALL cl_err("OPEN t600_cl:", STATUS, 1)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH t600_cl INTO g_lqx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lqx.lqx01,SQLCA.sqlcode,0)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF

   CALL t600_show()

  #CHI-C80047 add START
   LET g_lqx01_t = g_lqx.lqx01
   LET g_lqx02_t = g_lqx.lqx02    
   LET g_lqx_o.* = g_lqx.*
   LET g_lqx_t.* = g_lqx.*
  #CHI-C80047 add END

   WHILE TRUE
     #CHI-C80047 mark START
     #LET g_lqx01_t = g_lqx.lqx01
     #LET g_lqx02_t = g_lqx.lqx02    #CHI-C80047 add
     #LET g_lqx_o.* = g_lqx.*
     #LET g_lqx_t.* = g_lqx.*
     #CHI-C80047 mark END
      LET g_lqx.lqxmodu=g_user
      LET g_lqx.lqxdate=g_today
      IF g_lqx.lqx07 MATCHES '[Ss11WwRr]' THEN
         LET g_lqx.lqx07 = '0'
      END IF
      CALL t600_i("u")

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lqx.*=g_lqx_t.*
         CALL t600_show()
         CALL cl_err('','9001',0)
         ROLLBACK WORK
         EXIT WHILE
      END IF

      IF g_lqx.lqx01 != g_lqx01_t THEN
         UPDATE lqy_file SET lqy01 = g_lqx.lqx01
          WHERE lqy01 = g_lqx01_t
            AND lqy00 = g_lqx.lqx00     #FUN-C60058 add
            AND lqy08 = q_lqx_o.lqx10   
            AND lqy09 = g_lqx_o.lqx11   
            AND lqy10 = g_lqx02_t     #CHI-C80047 add
            AND lqyplant = g_plant      #FUN-C60058 add
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lqy_file",g_lqx01_t,"",SQLCA.sqlcode,"","lqy",1)
            CONTINUE WHILE
         END IF
      END IF
    
     #CHI-C80047 add START
      IF g_lqx.lqx02 != g_lqx02_t THEN
         UPDATE lqy_file 
            SET lqy10 = g_lqx.lqx02
          WHERE lqy01 = g_lqx01_t
            AND lqy00 = g_lqx.lqx00    
            AND lqy08 = g_lqx.lqx10
            AND lqy09 = g_lqx.lqx11
            AND lqy10 = g_lqx02_t     
         IF SQLCA.sqlcode  THEN
            CALL cl_err3("upd","lqy_file",g_lqx01_t,"",SQLCA.sqlcode,"","lqy",1)
            CONTINUE WHILE
         END IF
         UPDATE lsz_file
            SET lsz13 = g_lqx.lqx02
          WHERE lsz01 = g_lqx01_t
            AND lsz02 = g_lsz02
            AND lsz11 = g_lqx.lqx10
            AND lsz12 = g_lqx.lqx11
            AND lsz13 = g_lqx02_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lqx_file",g_lqx01_t,"",SQLCA.sqlcode,"","lqx",1)
            CONTINUE WHILE
         END IF
      END IF
     #CHI-C80047 add END

      UPDATE lqx_file SET lqx_file.* = g_lqx.*
       WHERE lqx01 = g_lqx01_t
         AND lqx00 = g_lqx.lqx00   #FUN-C60089 add
         AND lqx02 = g_lqx02_t     #CHI-C80047 add
         AND lqx10 = g_lqx_o.lqx10   
         AND lqx11 = g_lqx_o.lqx11 
         AND lqxplant  = g_plant   #FUN-C60089 add

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lqx_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE t600_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lqx.lqx01,'U')

END FUNCTION

FUNCTION t600_x()

    LET g_action_choice = ""
    LET g_success = 'Y' 
    IF s_shut(0) THEN
       RETURN
    END IF
    
    IF cl_null(g_lqx.lqx01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    
    SELECT * INTO g_lqx.* FROM lqx_file
     WHERE lqx01 = g_lqx.lqx01 
       AND lqx00 = g_lqx.lqx00  #FUN-C60089 add
       AND lqx02 = g_lqx.lqx02  #CHI-C80047 add
       AND lqx10 = g_lqx.lqx10
       AND lqx11 = g_lqx.lqx11
       AND lqxplant = g_plant   #FUN-C60089 add

    IF g_lqx.lqx05 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lqx.lqx05 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
       
    IF g_plant <> g_lqx.lqx10 THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lqx01_t = g_lqx.lqx01
    BEGIN WORK

    OPEN t600_cl USING g_lqx.lqx01, g_lqx.lqx10, g_lqx.lqx11,g_lqx.lqx02    #CHI-C80047 add
    IF STATUS THEN
       CALL cl_err("OPEN t600_cl:", STATUS, 1)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH t600_cl INTO g_lqx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lqx.lqx01,SQLCA.sqlcode,0)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF

   CALL t600_show()

   IF cl_exp(0,0,g_lqx.lqxacti) THEN
      LET g_chr=g_lqx.lqxacti
      IF g_lqx.lqxacti='Y' THEN
         LET g_lqx.lqxacti='N'
      ELSE
         LET g_lqx.lqxacti='Y'
      END IF

      UPDATE lqx_file SET lqxacti = g_lqx.lqxacti,
                          lqxmodu = g_user,
                          lqxdate = g_today
       WHERE lqx01 = g_lqx01_t
         AND lqx00 = g_lqx.lqx00   #FUN-C60089 add
         AND lqx02 = g_lqx.lqx02   #CHI-C80047 add
         AND lqx10 = g_lqx_o.lqx10
         AND lqx11 = g_lqx_o.lqx11
         AND lqxplant = g_plant    #FUN-C60089 add
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lqx_file",g_lqx.lqx01,"",SQLCA.sqlcode,"","",1)
         LET g_lqx.lqxacti=g_chr
      END IF
   END IF

   CLOSE t600_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lqx.lqx01,'V')
   ELSE
      ROLLBACK WORK
   END IF

   SELECT lqxacti,lqxmodu.lqxdate,lqxcrat 
     INTO g_lqx.lqxacti, g_lqx.lqxmodu, g_lqx.lqxdate, g_lqx.lqxcrat 
     FROM lqx_file
       WHERE lqx01 = g_lqx01_t
         AND lqx00 = g_lqx.lqx00  #FUN-C60089 add
         AND lqx02 = g_lqx.lqx02  #CHI-C80047 add
         AND lqx10 = g_lqx.lqx10
         AND lqx11 = g_lqx.lqx11
         AND lqxplant = g_plant   #FUN-C60089 add

   DISPLAY BY NAME g_lqx.lqxacti, g_lqx.lqxmodu, g_lqx.lqxdate, g_lqx.lqxcrat    
   CALL t600_field_pic()

END FUNCTION

FUNCTION t600_lqy04(p_cmd)
 DEFINE p_cmd          LIKE type_file.chr1
 DEFINE l_gfe02        LIKE  gfe_file.gfe02
 DEFINE l_gfeacti      LIKE  gfe_file.gfeacti

   LET g_errno = ''

   SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti
     FROM gfe_file
    WHERE gfe01 = g_lqy[l_ac].lqy04
   CASE WHEN SQLCA.SQLCODE = 100
                           LET g_errno = 'art-061'
        WHEN l_gfeacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_lqy[l_ac].gfe02 = l_gfe02
      DISPLAY BY NAME g_lqy[l_ac].gfe02
   END IF
END FUNCTION

FUNCTION t600_lqy03(p_cmd)  #贈品編號
    DEFINE p_cmd       LIKE type_file.chr1
    DEFINE p_code      LIKE type_file.chr1
    DEFINE l_ima02     LIKE ima_file.ima02
    DEFINE l_ima021     LIKE ima_file.ima021
    DEFINE l_ima31     LIKE ima_file.ima31
    DEFINE l_imaacti     LIKE ima_file.imaacti

    LET g_errno = ' '
    SELECT ima02,ima021,ima31,imaacti INTO l_ima02,l_ima021,l_ima31,l_imaacti
      FROM ima_file WHERE ima01 = g_lqy[l_ac].lqy03
                      AND imaacti = 'Y'
    CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'mfg3006'
         WHEN l_imaacti='N'        LET g_errno = 'mfg9028'
         OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'        END CASE
    IF cl_null(g_errno) AND cl_null(g_lqy[l_ac].lqy04) THEN
       LET g_lqy[l_ac].lqy04 = l_ima31
       DISPLAY BY NAME g_lqy[l_ac].lqy04
    END IF
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_lqy[l_ac].ima02 = l_ima02
       LET g_lqy[l_ac].ima021 = l_ima021
       DISPLAY g_lqy[l_ac].ima02 TO ima02
       DISPLAY g_lqy[l_ac].ima021 TO ima021
    END IF
END FUNCTION

FUNCTION t600_lqy05_check()
   IF NOT cl_null(g_lqy[l_ac].lqy05) AND NOT cl_null(g_lqy[l_ac].lqy04) THEN
      IF cl_null(g_lqy_t.lqy05) OR cl_null(g_lqy04_t) 
       OR g_lqy_t.lqy05 != g_lqy[l_ac].lqy05 
       OR g_lqy04_t != g_lqy[l_ac].lqy04 THEN
         LET g_lqy[l_ac].lqy05=s_digqty(g_lqy[l_ac].lqy05,g_lqy[l_ac].lqy04)
         DISPLAY BY NAME g_lqy[l_ac].lqy05
      END IF
   END IF
   IF NOT cl_null(g_lqy[l_ac].lqy05) THEN
      IF g_lqy[l_ac].lqy05 <= 0 THEN
         CALL cl_err('','alm1368',0)
         LET g_lqy[l_ac].lqy05= g_lqy_t.lqy05
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t600_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lqx.lqx01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lqx_file ",
                  "  WHERE lqx01 = '",g_lqx.lqx01,"'",
                  "    AND lqx11 > '",g_lqx.lqx11,"'"
      PREPARE t600_pb1 FROM l_sql 
      EXECUTE t600_pb1 INTO l_cnt       
      
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
         CALL t600_v()
         CALL t600_field_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lqx_file WHERE lqx00 = g_lqx.lqx00 AND lqx01 = g_lqx.lqx01   #FUN-C60089 add lqx00
                                AND lqx10 = g_lqx.lqx10 AND lqx11 = g_lqx.lqx11
                                AND lqxplant = g_plant                            #FUN-C60089 add
                                AND lqx02 = g_lqx.lqx02                           #CHI-C80047 add
        #DELETE FROM lsz_file WHERE lsz01 = g_lqx.lqx01 AND lsz02 = '2' AND lsz11 = g_lqx.lqx10 AND lsz12 = g_lqx.lqx11   #FUN-C60089 mark 
         DELETE FROM lsz_file WHERE lsz01 = g_lqx.lqx01 AND lsz02 = g_lsz02       #FUN-C60089 add
                                AND lsz11 = g_lqx.lqx10 AND lsz12 = g_lqx.lqx11   #FUN-C60089 add
                                AND lszplant = g_plant                            #FUN-C60089 add
                                AND lsz13 = g_lqx.lqx02                           #CHI-C80047 add

         INITIALIZE g_lqx.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION

FUNCTION t600_temp(p_cmd,p_plant,p_legal)
DEFINE l_sql         STRING
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_n           LIKE type_file.num5
DEFINE p_cmd         LIKE type_file.chr1
DEFINE p_plant       LIKE lsu_file.lsuplant
DEFINE p_legal       LIKE lsu_file.lsulegal
DEFINE l_lqx11       LIKE lqx_file.lqx11      #CHI-C80047 add

   LET g_flag2 = 'Y'
   IF cl_null(g_lqx.lqx01) THEN
      RETURN
      CALL cl_err('','-400',0)
   END IF

  #CHI-C80047 mark START
  #SELECT MAX(lqx11) INTO g_lqx.lqx11 FROM lqx_file
  #  WHERE lqx01 = g_lqx.lqx11 AND lqx10 = g_lqx.lqx10
  #    AND lqx00 = g_lqx.lqx00   #FUN-C60089 add
  #    AND lqx02 = g_lqx.lqx02   #CHI-C80047 add
  #    AND lqxplant = g_plant    #FUN-C60089 add
  #IF cl_null(g_lqx.lqx10) THEN
  #  LET g_lqx.lqx10 = 0
  #END IF

  #SELECT * INTO g_lqx.* FROM lqx_file
  #  WHERE lqx01 = g_lqx.lqx01
  #    AND lqx00 = g_lqx.lqx00   #FUN-C60089 add
  #    AND lqx02 = g_lqx.lqx02   #CHI-C80047 add
  #    AND lqx10 = g_lqx.lqx10
  #    AND lqx11 = g_lqx.lqx11
  #    AND lqxplant = g_plant    #FUN-C60089 add
  #CHI-C80047 mark END

  #CHI-C80047 add START
   IF p_cmd = 'a' THEN
      LET l_lqx11 = g_lqx.lqx11 - 1 
   ELSE
      LET l_lqx11 = g_lqx.lqx11
   END IF 
   IF cl_null(l_lqx11) OR l_lqx11 < 1 THEN
      LET l_lqx11 = 0 
   END IF 
  #CHI-C80047 add END
   LET g_lqx.lqx05 = 'N'

   DROP TABLE lqx_temp
   SELECT * FROM lqx_file WHERE 1 = 0 INTO TEMP lqx_temp
   DROP TABLE lqy_temp
   SELECT * FROM lqy_file WHERE 1 = 0 INTO TEMP lqy_temp
   DROP TABLE lsz_temp
   SELECT * FROM lsz_file WHERE 1 = 0 INTO TEMP lsz_temp

   LET g_success = 'Y'

   DELETE FROM lqx_temp
   DELETE FROM lqy_temp
   DELETE FROM lsz_temp

   INSERT INTO lqx_temp SELECT * FROM lqx_file 
                         WHERE lqx01 = g_lqx.lqx01 
                           AND lqx00 = g_lqx.lqx00   #FUN-C60089 add
                           AND lqx02 = g_lqx.lqx02   #CHI-C80047 add
                           AND lqx10 = g_lqx.lqx10
                          #AND lqx11 = g_lqx.lqx11   #CHI-C80047 mark 
                           AND lqx11 = l_lqx11       #CHI-C80047 add 
                           AND lqxplant = g_lqx.lqxplant
 
   INSERT INTO lqy_temp SELECT * FROM lqy_file
                         WHERE lqy01 = g_lqx.lqx01 
                           AND lqy00 = g_lqx.lqx00   #FUN-C60089 add
                           AND lqy08 = g_lqx.lqx10 
                          #AND lqy09 = g_lqx.lqx11   #CHI-C80047 mark
                           AND lqy09 = l_lqx11       #CHI-C80047 add 
                           AND lqy10 = g_lqx.lqx02   #CHI-C80047 add
                           AND lqyplant = g_lqx.lqxplant 

   INSERT INTO lsz_temp SELECT lsz_file.* FROM lsz_file
                        #WHERE lsz01 = g_lqx.lqx01 AND lsz02 = '2'         #FUN-C60089 mark
                         WHERE lsz01 = g_lqx.lqx01 AND lsz02 = g_lsz02     #FUN-C60089 add
                           AND lsz11 = g_lqx.lqx10 
                          #AND lsz12 = g_lqx.lqx11               #CHI-C80047 mark
                           AND lsz12 = l_lqx11                   #CHI-C80047 mark
                           AND lsz13 = g_lqx.lqx02               #CHI-C80047 add
                           AND lszplant = g_lqx.lqxplant         #FUN-C60089 add

   IF p_cmd = 'a' THEN   #當為新增的時候才將版本號+1
     #CHI-C80047 mark START
     #UPDATE lqx_temp SET lqx11 = g_lqx.lqx11 + 1

     #UPDATE lqy_temp SET lqy09 = g_lqx.lqx11 + 1

     #UPDATE lsz_temp SET lsz12 = g_lqx.lqx11 + 1 
     #CHI-C80047 mark END 
     #CHI-C80047 add START
      UPDATE lqx_temp SET lqx11 = g_lqx.lqx11 

      UPDATE lqy_temp SET lqy09 = g_lqx.lqx11 

      UPDATE lsz_temp SET lsz12 = g_lqx.lqx11 
     #CHI-C80047 add END
   ELSE                 #當確認時只將plantCode&legalCode update
      UPDATE lqx_temp SET lqx05 = 'Y',
                          lqxplant = p_plant,
                          lqxlegal = p_legal

      UPDATE lqy_temp SET lqyplant = p_plant, 
                          lqylegal = p_legal

      UPDATE lsz_temp SET lszplant = p_plant,
                          lszlegal = p_legal

   END IF

   IF p_cmd <> 'a' THEN   #當為新增時不將單頭新增,只display畫面上,等user點選確認後才新增

      LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'lqx_file'),   #單頭
                  " SELECT * FROM lqx_temp"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql
      PREPARE trans_ins_lqx FROM l_sql
      EXECUTE trans_ins_lqx
      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','INSERT INTO lqx_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
      END IF
   END IF

   LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'lqy_file'),   #單身
               " SELECT * FROM lqy_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql
   PREPARE trans_ins_lqy FROM l_sql
   EXECUTE trans_ins_lqy
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('','','INSERT INTO lqy_file:',SQLCA.sqlcode,1)
     LET g_success = 'N'
   END IF

   LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'lsz_file'),   #生效營運中心
               " SELECT * FROM lsz_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, p_plant) RETURNING l_sql
   PREPARE trans_ins_lsz FROM l_sql
   EXECUTE trans_ins_lsz
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('','','INSERT INTO lsz_file:',SQLCA.sqlcode,1)
     LET g_success = 'N'
   END IF

   DROP TABLE lqx_temp
   DROP TABLE lqy_temp
   DROP TABLE lsz_temp

   IF p_cmd = 'a' THEN
     #LET g_lqx.lqx11 = g_lqx.lqx11 + 1   #CHI-C80047 mark

      DISPLAY BY NAME g_lqx.lqx10, g_lqx.lqx00, g_lqx.lqx01, g_lqx.lqx11, g_lqx.lqx02, g_lqx.lqx03,
                      g_lqx.lqx04, g_lqx.lqx05, g_lqx.lqx09, g_lqx.lqx12, g_lqx.lqx13, g_lqx.lqx05,
                      g_lqx.lqx06, g_lqx.lqx07, g_lqx.lqx08, g_lqx.lqxplant, g_lqx.lqxlegal,
                      g_lqx.lqxuser, g_lqx.lqxgrup, g_lqx.lqxoriu, g_lqx.lqxorig, g_lqx.lqxcrat,
                      g_lqx.lqxmodu, g_lqx.lqxdate, g_lqx.lqxacti
   END IF

END FUNCTION

FUNCTION t600_refresh()
      DISPLAY ARRAY g_lqy TO s_lqy.* ATTRIBUTE(COUNT=g_rec_b)
        BEFORE DISPLAY
           EXIT DISPLAY
      END DISPLAY

END FUNCTION

FUNCTION t600_r()
DEFINE
       l_ac_t            LIKE type_file.num5,
       l_n,l_n1,l_n2     LIKE type_file.num5,
       l_cnt             LIKE type_file.num5,
       l_lock_sw         LIKE type_file.chr1,
       p_cmd             LIKE type_file.chr1,
       l_allow_insert    LIKE type_file.num5,
       l_allow_delete    LIKE type_file.num5
    LET g_action_choice = ""


    IF s_shut(0) THEN
       RETURN
    END IF

    IF cl_null(g_lqx.lqx01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    SELECT * INTO g_lqx.* FROM lqx_file
     WHERE lqx01 = g_lqx.lqx01
       AND lqx00 = g_lqx.lqx00   #FUN-C60089 add
       AND lqx02 = g_lqx.lqx02   #CHI-C80047 add
       AND lqx10 = g_lqx.lqx10
       AND lqx11 = g_lqx.lqx11
       AND lqxplant = g_plant    #FUN-C60089 add

    IF g_lqx.lqxacti ='N' THEN
       CALL cl_err(g_lqx.lqx01,'mfg1000',0)
       RETURN
    END IF
    IF g_lqx.lqx05 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lqx.lqx05 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF

    IF g_plant <> g_lqx.lqx10 THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
    
    BEGIN WORK

    OPEN t600_cl USING g_lqx.lqx01, g_lqx.lqx10, g_lqx.lqx11,g_lqx.lqx02     #CHI-C80047 add
    IF STATUS THEN
       CALL cl_err("OPEN t600_cl:", STATUS, 1)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH t600_cl INTO g_lqx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lqx.lqx01,SQLCA.sqlcode,0)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF 

   CALL t600_show()

   IF cl_delh(0,0) THEN
      DELETE FROM lqx_file WHERE lqx00 = g_lqx.lqx00 AND lqx01 = g_lqx.lqx01    #FUN-C60089 add lqx00
                             AND lqx10 = g_lqx.lqx10 AND lqx11 = g_lqx.lqx11 
                             AND lqxplant = g_plant                             #FUN-C60089 add
                             AND lqx02 = g_lqx.lqx02                            #CHI-C80047 add
      DELETE FROM lqy_file WHERE lqy00 = g_lqx.lqx00 AND lqy01 = g_lqx.lqx01    #FUN-C60089 add lqy00
                             AND lqy08 = g_lqx.lqx10 AND lqy09 = g_lqx.lqx11
                             AND lqyplant = g_plant                             #FUN-C60089 add
                             AND lqy10 = g_lqx.lqx02                            #CHI-C80047 add
     #DELETE FROM lsz_file WHERE lsz01 = g_lqx.lqx01 AND lsz02 = '2' AND lsz11 = g_lqx.lqx10 AND lsz12 = g_lqx.lqx11       #FUN-C60089 mark 
      DELETE FROM lsz_file WHERE lsz01 = g_lqx.lqx01 AND lsz02 = g_lsz02 AND lsz11 = g_lqx.lqx10 AND lsz12 = g_lqx.lqx11   #FUN-C60089 add 
                             AND lszplant = g_plant                                                                        #FUN-C60089 add
                             AND lsz13 = g_lqx.lqx02                            #CHI-C80047 add           
      CLEAR FORM
      CALL g_lqy.clear()
      OPEN t600_count
       IF STATUS THEN
          CLOSE t600_cs
          CLOSE t600_count
          COMMIT WORK
          RETURN
       END IF
      FETCH t600_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t600_cs
          CLOSE t600_count
          COMMIT WORK
          RETURN
       END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t600_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t600_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t600_fetch('/')
      END IF
   END IF

   CLOSE t600_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lqx.lqx01,'D')
END FUNCTION

FUNCTION t600_y() 
    DEFINE l_n LIKE type_file.num5
    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF cl_null(g_lqx.lqx01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    SELECT * INTO g_lqx.* FROM lqx_file
     WHERE lqx01 = g_lqx.lqx01
       AND lqx00 = g_lqx.lqx00   #FUN-C60089 add
       AND lqx02 = g_lqx.lqx02   #CHI-C80047 add
       AND lqx10 = g_lqx.lqx10
       AND lqx11 = g_lqx.lqx11
       AND lqxplant = g_plant    #FUN-C60089 add

    IF g_lqx.lqxacti ='N' THEN
       CALL cl_err(g_lqx.lqx01,'mfg1000',0)
       RETURN
    END IF
    IF g_lqx.lqx05 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lqx.lqx05 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF

    IF g_plant <> g_lqx.lqx10 THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF

    SELECT COUNT(*) INTO l_n   #判斷生效營運中心是否為空
      FROM lsz_file
     WHERE lsz01 = g_lqx.lqx01
       AND lszplant = g_lqx.lqxplant
      #AND lsz02 = '2'       #FUN-C60089 mark 
       AND lsz02 = g_lsz02   #FUN-C60089 add
       AND lsz12 = g_lqx.lqx11
       AND lsz11 = g_lqx.lqx10
       AND lsz13 = g_lqx.lqx02  #CHI-C80047 add
    IF l_n = 0 THEN
       CALL cl_err('','alm1367',0)
       RETURN
    END IF
 
    CALL t600_chk_lqx02()   #判斷生效營運中心是否與卡生效營運中心符合

    IF g_success = 'N' THEN
       RETURN
    END IF

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lqx01_t = g_lqx.lqx01
    IF NOT cl_confirm('axm-108') THEN RETURN END IF
    BEGIN WORK

    OPEN t600_cl USING g_lqx.lqx01, g_lqx.lqx10, g_lqx.lqx11,g_lqx.lqx02     #CHI-C80047 add 
    IF STATUS THEN
       CALL cl_err("OPEN t600_cl:", STATUS, 1)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH t600_cl INTO g_lqx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lqx.lqx01,SQLCA.sqlcode,0)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF

    CALL t600_iss()  #確認同時將資料發佈到各營運中心

    IF g_success = 'N' THEN
       ROLLBACK WORK
    ELSE
       LET g_lqx.lqx05 = 'Y'
       LET g_lqx.lqx06=g_user
       LET g_lqx.lqx07=g_today
       UPDATE lqx_file SET lqx05 = g_lqx.lqx05,
                           lqx06 = g_lqx.lqx06,
                           lqx07 = g_lqx.lqx07
                        WHERE lqx01 = g_lqx.lqx01
                          AND lqx00 = g_lqx.lqx00   #FUN-C60089 add
                          AND lqx02 = g_lqx.lqx02   #CHI-C80047 add
                          AND lqx10 = g_lqx.lqx10
                          AND lqx11 = g_lqx.lqx11 
                          AND lqxplant = g_plant    #FUN-C60089 add
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","lqx_file",g_lqx.lqx01,"",SQLCA.sqlcode,"","",0)
          ROLLBACK WORK
          RETURN
       END IF
       CLOSE t600_cl
       COMMIT WORK
       DISPLAY BY NAME g_lqx.lqx05
       DISPLAY BY NAME g_lqx.lqx06
       DISPLAY BY NAME g_lqx.lqx07
       CALL t600_field_pic()
    END IF
END FUNCTION 

FUNCTION t600_chk_lqx02()  #判斷營運中心是否符合卡種生效營運中心
DEFINE l_lsz03          LIKE lsz_file.lsz03   #卡種
DEFINE l_n              LIKE type_file.num5
DEFINE l_cnt            LIKE type_file.num5
DEFINE l_sql            STRING

   LET g_success = 'Y'
   CALL s_showmsg_init()
   IF cl_null(g_lqx.lqx02) THEN RETURN END IF

   LET l_sql = " SELECT lsz03 FROM lsz_file ",
               "    WHERE lsz01 = '",g_lqx.lqx01,"' ",
              #"      AND lsz02 = '2' ",            #FUN-C60089 mark
               "      AND lsz02 = '",g_lsz02,"'",   #FUN-C60089 add 
               "      AND lsz11 = '",g_lqx.lqx10,"' ",
               "      AND lsz12 = '",g_lqx.lqx11,"'",
               "      AND lsz10 = 'Y' ",
               "      AND lsz13 = '",g_lqx.lqx02,"' ",  #CHI-C80047 add
               "      AND lszplant = '",g_plant,"' "   #FUN-C60058 add

   PREPARE t600_lsz03_pre FROM l_sql
   DECLARE t600_lsz03_cl CURSOR FOR t600_lsz03_pre

   FOREACH t600_lsz03_cl INTO l_lsz03
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF cl_null(l_lsz03) THEN CONTINUE FOREACH END IF

      #判斷營運中心是否符合卡種生效營運中心
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lsz03, 'lnk_file'),
                  "   WHERE lnk01 = '",g_lqx.lqx02,"'  AND lnk02 = '1' AND lnk05 = 'Y' ",
                  "      AND lnk03 = '",l_lsz03,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_lsz03 ) RETURNING l_sql
      PREPARE trans_cnt FROM l_sql
      EXECUTE trans_cnt INTO l_n

      IF l_n = 0 OR cl_null(l_n) THEN
         CALL s_errmsg('lsz03',l_lsz03,l_lsz03,'alm-h33',1)
         LET g_success = 'N'
      END IF
      #判斷其他生效營運中心是否已存在此兌換單號
      LET l_cnt = 0
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lsz03, 'lpq_file'),
                  "   WHERE lpq01 = '",g_lqx.lqx01,"'  AND lpq08 = 'Y' AND lpq15 = 'Y' ",
                  "     AND lpq00 = '",g_lqx.lqx00,"' ",      #FUN-C60058 add
                  "     AND lpqacti = 'Y' AND lpq13 NOT IN ('",g_lqx.lqx10,"')"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_lsz03) RETURNING l_sql
      PREPARE trans_cnt1 FROM l_sql
      EXECUTE trans_cnt1 INTO l_cnt
      IF l_cnt > 0 THEN
         CALL s_errmsg('lsz03',l_lsz03,l_lsz03,'alm-h32',1)
         LET g_success = 'N'
      END IF
   END FOREACH
   CALL s_showmsg()

END FUNCTION

FUNCTION t600_iss()
   DEFINE l_sql         STRING
   DEFINE l_plant       LIKE lsu_file.lsuplant
   DEFINE l_sql2        STRING
   DEFINE l_legal       LIKE lqx_file.lqxlegal
   DEFINE l_i           LIKE type_file.num5
   LET l_sql = " SELECT lsz03,lsz10 FROM lsz_file ",
               " WHERE lsz01 = '",g_lqx.lqx01,"' AND lsz12 = '",g_lqx.lqx11,"' ",
              #"   AND lsz02 = '2' AND lsz11 = '",g_lqx.lqx10,"'  "             #FUN-C60089 mark
               "   AND lsz02 = '",g_lsz02,"' AND lsz11 = '",g_lqx.lqx10,"' ",   #FUN-C60089 add 
               "   AND lsz13 = '",g_lqx.lqx02,"' ",        #CHI-C80047 add 
               "   AND lszplant = '",g_lqx.lqxplant,"' "   #FUN-C60089 add

   PREPARE lsz_pre FROM l_sql
   DECLARE lsz_cs CURSOR FOR lsz_pre
   LET g_cnt2 = 1
   FOREACH lsz_cs INTO g_ary[g_cnt2].plant ,g_ary[g_cnt2].acti
       LET g_cnt2 = g_cnt2 + 1
   END FOREACH
   LET g_cnt2 = g_cnt2 - 1
   FOR l_i = 1 TO g_cnt2 

      IF cl_null(g_ary[l_i].plant) THEN CONTINUE FOR END IF
      LET l_plant = g_ary[l_i].plant

      SELECT azw02 INTO l_legal FROM azw_file
       WHERE azw01 = l_plant AND azwacti='Y'
      IF g_lqx.lqx10 = l_plant THEN   #與當前機構相同則不拋

      ELSE
         CALL t600_temp('u',l_plant,l_legal)
      END IF
      IF g_success = 'N' THEN RETURN END IF

   END FOR
   CALL t600_ins_lpq()
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
END FUNCTION

FUNCTION t600_ins_lpq()
   DEFINE l_sql       STRING
   DEFINE l_plant     LIKE lsu_file.lsuplant
   DEFINE l_legal     LIKE lsu_file.lsulegal
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_lqx       RECORD LIKE lqx_file.*
   DEFINE l_lqy       RECORD LIKE lqy_file.*
   DEFINE l_lsz       RECORD LIKE lsz_file.*
   DEFINE l_i         LIKE type_file.num5
   FOR l_i = 1 TO g_cnt2
      IF cl_null(g_ary[l_i].plant) THEN CONTINUE FOR END IF
      LET l_plant = g_ary[l_i].plant

      SELECT azw02 INTO l_legal FROM azw_file
       WHERE azw01 = l_plant AND azwacti='Y'

      #將原有的資料刪除,新增全新資料
      LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant, 'lpq_file'),
                  "   WHERE lpq01 = '",g_lqx.lqx01,"' AND lpq13 = '",g_lqx.lqx10,"'",
                  "     AND lpq00 = '",g_lqx.lqx00,"' ",       #FUN-C60058 add
                  "     AND lpq03 = '",g_lqx.lqx02,"' ",       #CHI-C80047 add
                  "     AND lpqplant = '",l_plant,"'"
      PREPARE trans_del_lst FROM l_sql
      EXECUTE trans_del_lst
      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','DELETE lpq_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOR
      END IF
      LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant, 'lpr_file'),
                  "   WHERE lpr01 = '",g_lqx.lqx01,"' AND lpr08 = '",g_lqx.lqx10,"'",
                  "     AND lpr00 = '",g_lqx.lqx00,"' ",     #FUN-C60058 add
                  "     AND lpr09 = '",g_lqx.lqx02,"' ",     #CHI-C80047 add
                  "     AND lprplant = '",l_plant,"'"
      PREPARE trans_del_lss FROM l_sql
      EXECUTE trans_del_lss
      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','DELETE lpr_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOR
      END IF
      LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant, 'lni_file'),
                  "   WHERE lni01 = '",g_lqx.lqx01,"' AND lni14 = '",g_lqx.lqx10,"'",
                  "     AND lni15 = '",g_lqx.lqx02,"'",   #CHI-C80047 add
                 #"     AND lni02 = '2' AND lniplant = '",l_plant,"'"    #FUN-C60058 mark
                  "     AND lni02 = '",g_lsz02,"' AND lniplant = '",l_plant,"' "    #FUN-C60058 add
      PREPARE trans_del_lni FROM l_sql
      EXECUTE trans_del_lni
      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','DELETE lni_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOR
      END IF

      #單頭
      SELECT * INTO l_lqx.* FROM lqx_file
         WHERE lqx01 = g_lqx.lqx01
           AND lqx00 = g_lqx.lqx00   #FUN-C60089 add
           AND lqx02 = g_lqx.lqx02   #CHI-C80047 add
           AND lqx11 = g_lqx.lqx11 AND lqx11 = g_lqx.lqx11
           AND lqx10 = g_lqx.lqx10
           AND lqxplant = g_lqx.lqxplant
      IF g_ary[l_i].acti = 'N' THEN
         LET l_lqx.lqx05 = 'Y'
         LET l_lqx.lqxacti = 'N'
      ELSE
         LET l_lqx.lqx05 = 'Y'
         LET l_lqx.lqxacti = 'Y'
      END IF

      LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'lpq_file'),
                  "        (lpq00,lpq01,lpq02,lpq03,lpq04,lpq05,lpq06,lpq07,",
                  "         lpq08,lpq09,lpq10,lpq11,lpq12,lpq13,lpq14,  ",
                  "         lpq15,lpq16,lpq17,lpq18, ",
                  "         lpqacti, lpqcrat,lpqdate,lpqgrup, ",
                  "         lpqlegal,lpqmodu,lpqorig,lpqoriu,lpqplant,lpquser ) ",
                  " VALUES( '",l_lqx.lqx00,"', '",l_lqx.lqx01,"', '','",l_lqx.lqx02,"', ",
                  "         '",l_lqx.lqx03,"','",l_lqx.lqx04,"','N',' ' ,'",l_lqx.lqx05,"', ",
                  "         '",g_user,"','",g_today,"','",l_lqx.lqx08,"',",
                  "         '",l_lqx.lqx09,"','",l_lqx.lqx10,"','",l_lqx.lqx11,"','Y','",g_today,"', ",
                  "         '",l_lqx.lqx12,"','",l_lqx.lqx13,"',  ",
                  "         '",l_lqx.lqxacti,"','",l_lqx.lqxcrat,"',",
                  "         '', '",l_lqx.lqxgrup,"', '",l_legal,"','",l_lqx.lqxmodu,"', ",
                  "         '",l_lqx.lqxorig,"', '",l_lqx.lqxoriu,"','",l_plant,"','",l_lqx.lqxuser,"')"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE trans_ins_lqx1 FROM l_sql
      EXECUTE trans_ins_lqx1
      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','INSERT INTO lpq_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOR
      END IF
      #第一單身
      LET l_sql = " SELECT * FROM lqy_file ",
                  "    WHERE lqy01 = '",g_lqx.lqx01,"' ",
                  "      AND lqy00 = '",g_lqx.lqx00,"' ",  #FUN-C60089 add
                  "      AND lqy08 = '",g_lqx.lqx10,"' ",
                  "      AND lqy10 = '",g_lqx.lqx02,"' ",  #CHI-C80047 add
                  "      AND lqyplant = '",g_lqx.lqxplant,"' ",
                  "      AND lqy09 = '",g_lqx.lqx11,"'"
      PREPARE lqy_pre FROM l_sql
      DECLARE lqy_cs1 CURSOR FOR lqy_pre
      FOREACH lqy_cs1 INTO l_lqy.*
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'lpr_file'),
                     "        (lpr00,lpr01,lpr02,lpr03,lpr04,lpr05,lpr06,lpr07,lpr08,lprlegal,lprplant,lpr09 )",   #FUN-C60089 add lpr00  #CHI-C80047 add lpr09
                     " VALUES( '",l_lqy.lqy00,"', '",l_lqy.lqy01,"', '",l_lqy.lqy02,"', '",l_lqy.lqy03,"','",l_lqy.lqy04,"', ",    #FUN-C60089 add
                     "         '",l_lqy.lqy05,"', '",l_lqy.lqy06,"', '",l_lqy.lqy07,"','",l_lqy.lqy08,"', ",
                     "         '",l_legal,"','",l_plant,"', '",l_lqy.lqy10,"')"   #CHI-C80047 add lqy10
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE trans_ins_lpr FROM l_sql
         EXECUTE trans_ins_lpr
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lpr_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
         END IF
      END FOREACH
      #生效營運中心 
      LET l_sql = " SELECT * FROM lsz_file ",
                 #"    WHERE lsz01 = '",g_lqx.lqx01,"' AND lsz02 = '2' ",             #FUN-C60089 mark
                  "    WHERE lsz01 = '",g_lqx.lqx01,"' AND lsz02 = '",g_lsz02,"' ",   #FUN-C60089 add
                  "      AND lsz11 = '",g_lqx.lqx10,"' ",
                  "      AND lsz12 = '",g_lqx.lqx11,"' ",
                  "      AND lsz13 = '",g_lqx.lqx02,"' ",  #CHI-C80047 add
                  "      AND lszplant = '",g_lqx.lqxplant,"' "
      PREPARE lsz_pre2 FROM l_sql
      DECLARE lsz_cs2 CURSOR FOR lsz_pre2
      FOREACH lsz_cs2 INTO l_lsz.*
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'lni_file'),
                     "        (lni01,lni02,lni04,lni07,lni08,lni11,",
                     "         lni12,lni13,lni14,lnilegal,lniplant,lni15 ) ",   #CHI-C80047 add lni15
                     " VALUES( '",l_lsz.lsz01,"', '",l_lsz.lsz02,"', '",l_lsz.lsz03,"','",l_lsz.lsz04,"', ",
                     "         '",l_lsz.lsz05,"','",l_lsz.lsz08,"','',",
                     "         '",l_lsz.lsz10,"','",l_lsz.lsz11,"','",l_legal,"','",l_plant,"','",l_lsz.lsz13,"' )"  #CHI-C80047 add lsz13
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE trans_ins_lni FROM l_sql
         EXECUTE trans_ins_lni
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lni_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
         END IF
      END FOREACH
   END FOR
END FUNCTION
#CHI-C80047 add START
FUNCTION t600_lqx11()

   SELECT MAX(lqx11) INTO g_lqx.lqx11 FROM lqx_file
     WHERE lqx01 = g_lqx.lqx11 AND lqx10 = g_lqx.lqx10
       AND lqx00 = g_lqx.lqx00   
       AND lqx02 = g_lqx.lqx02  
       AND lqxplant = g_plant  
       AND lqx05 <> 'X'  #CHI-C80041  
   IF cl_null(g_lqx.lqx10) THEN
     LET g_lqx.lqx10 = 0
   END IF

   SELECT * INTO g_lqx.* FROM lqx_file
     WHERE lqx01 = g_lqx.lqx01
       AND lqx00 = g_lqx.lqx00  
       AND lqx02 = g_lqx.lqx02  
       AND lqx10 = g_lqx.lqx10
       AND lqx11 = g_lqx.lqx11
       AND lqxplant = g_plant   

   LET g_lqx.lqx05 = 'N'


   LET g_lqx.lqx11 = g_lqx.lqx11 + 1

   DISPLAY BY NAME g_lqx.lqx10, g_lqx.lqx00, g_lqx.lqx01, g_lqx.lqx11, g_lqx.lqx02, g_lqx.lqx03,
                   g_lqx.lqx04, g_lqx.lqx05, g_lqx.lqx09, g_lqx.lqx12, g_lqx.lqx13, g_lqx.lqx05,
                   g_lqx.lqx06, g_lqx.lqx07, g_lqx.lqx08, g_lqx.lqxplant, g_lqx.lqxlegal,
                   g_lqx.lqxuser, g_lqx.lqxgrup, g_lqx.lqxoriu, g_lqx.lqxorig, g_lqx.lqxcrat,
                   g_lqx.lqxmodu, g_lqx.lqxdate, g_lqx.lqxacti

END FUNCTION
#CHI-C80047 add END
#FUN-C50137 
#FUN-C90067 add START

FUNCTION t600_chk_lqypk()
DEFINE l_n     LIKE type_file.num5
  
   LET l_n = 0
   LET g_errno = ' '
   IF cl_null(l_ac) OR l_ac = 0 THEN RETURN END IF
   IF cl_null(g_lqy[l_ac].lqy06) THEN RETURN END IF
   IF g_argv1 = '0' AND NOT cl_null(g_lqy[l_ac].lqy02) AND NOT cl_null(g_lqy[l_ac].lqy03) THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM lqy_file
       WHERE lqy00 = g_lqx.lqx00
         AND lqy01 = g_lqx.lqx01
         AND lqy02 = g_lqy[l_ac].lqy02
         AND lqy03 = g_lqy[l_ac].lqy03
         AND lqy06 <> g_lqy[l_ac].lqy06
         AND lqy08 = g_lqx.lqx10
         AND lqy09 = g_lqx.lqx11
         AND lqy10 = g_lqx.lqx02
         AND lqyplant = g_plant
      IF l_n > 0 THEN
         LET g_errno = 'alm-h73'
      END IF
   END IF
   IF g_argv1 = '1' AND NOT cl_null(g_lqy[l_ac].lqy07) AND NOT cl_null(g_lqy[l_ac].lqy03) THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM lqy_file
       WHERE lqy00 = g_lqx.lqx00
         AND lqy01 = g_lqx.lqx01
         AND lqy03 = g_lqy[l_ac].lqy03
         AND lqy06 <> g_lqy[l_ac].lqy06
         AND lqy07 = g_lqy[l_ac].lqy07
         AND lqy08 = g_lqx.lqx10
         AND lqy09 = g_lqx.lqx11
         AND lqy10 = g_lqx.lqx02
         AND lqyplant = g_plant
      IF l_n > 0 THEN
         LET g_errno = 'alm-h75'
      END IF
   END IF
   IF NOT cl_null(g_errno) THEN RETURN END IF

   IF NOT cl_null(g_lqy[l_ac].lqy02) AND NOT cl_null(g_lqy[l_ac].lqy03) 
    AND NOT cl_null(g_lqy[l_ac].lqy04) AND NOT cl_null(g_lqy[l_ac].lqy05) THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM lqy_file
       WHERE lqy00 = g_lqx.lqx00
         AND lqy01 = g_lqx.lqx01
         AND lqy03 = g_lqy[l_ac].lqy03
         AND lqy04 = g_lqy[l_ac].lqy04
         AND lqy05 = g_lqy[l_ac].lqy05      
         AND lqy06 <> g_lqy[l_ac].lqy06
         AND lqy08 = g_lqx.lqx10
         AND lqy09 = g_lqx.lqx11
         AND lqy10 = g_lqx.lqx02
         AND lqyplant = g_plant 
      IF l_n > 0 THEN
         IF g_argv1 = '0' THEN
            LET g_errno = 'alm-h74' 
         ELSE
            LET g_errno = 'alm-h76' 
         END IF
      END IF
   END IF
   

END FUNCTION 
#FUN-C90067 add END
#CHI-C80041---begin
FUNCTION t600_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lqx.lqx01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t600_cl USING g_lqx.lqx01, g_lqx.lqx10, g_lqx.lqx11,g_lqx.lqx02
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_lqx.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqx.lqx01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t600_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_lqx.lqx05 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_lqx.lqx05)   THEN 
        LET l_chr=g_lqx.lqx05
        IF g_lqx.lqx05='N' THEN 
            LET g_lqx.lqx05='X' 
        ELSE
            LET g_lqx.lqx05='N'
        END IF
        UPDATE lqx_file
            SET lqx05=g_lqx.lqx05,  
                lqxmodu=g_user,
                lqxdate=g_today
            WHERE lqx01 = g_lqx.lqx01
              AND lqx00 = g_lqx.lqx00  
              AND lqx02 = g_lqx.lqx02   
              AND lqx10 = g_lqx.lqx10
              AND lqx11 = g_lqx.lqx11 
              AND lqxplant = g_plant 
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lqx_file",g_lqx.lqx01,"",SQLCA.sqlcode,"","",1)  
            LET g_lqx.lqx05=l_chr 
        END IF
        DISPLAY BY NAME g_lqx.lqx05
   END IF
 
   CLOSE t600_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lqx.lqx01,'V')
 
END FUNCTION
#CHI-C80041---end
