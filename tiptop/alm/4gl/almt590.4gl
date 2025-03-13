# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almt590.4gl
# Descriptions...: 積分換券變更設定作業 
# Date & Author..: No.FUN-C50085 12/05/24 By pauline
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C60089 12/07/20 By pauline 將兌換來源納入PK值
# Modify.........: No.CHI-C80047 12/08/21 By pauline 將卡種納入PK值
DATABASE ds
GLOBALS "../../config/top.global"

DEFINE
    g_lsu           RECORD LIKE lsu_file.*,
    g_lsu_t         RECORD LIKE lsu_file.*,
    g_lsu_o         RECORD LIKE lsu_file.*,
    g_lsu01         LIKE lsu_file.lsu01,
    g_lsu01_t       LIKE lsu_file.lsu01,
    g_ydate         DATE,
    g_lsv           DYNAMIC ARRAY OF RECORD       #
        lsv02       LIKE lsv_file.lsv02,          #積分達
        lsv03       LIKE lsv_file.lsv03,          #累計消費達  
        lsv04       LIKE lsv_file.lsv04,          #兌換基數
        lsv05       LIKE lsv_file.lsv05           #兌換基數換券金額
                    END RECORD,
    g_lsv_t         RECORD       
        lsv02       LIKE lsv_file.lsv02,          #積分達
        lsv03       LIKE lsv_file.lsv03,          #累計消費達   
        lsv04       LIKE lsv_file.lsv04,          #兌換基數
        lsv05       LIKE lsv_file.lsv05           #兌換基數換券金額
                    END RECORD,
    g_lsv_o         RECORD       
        lsv02       LIKE lsv_file.lsv02,          #積分達
        lsv03       LIKE lsv_file.lsv03,          #累計消費達   
        lsv04       LIKE lsv_file.lsv04,          #兌換基數
        lsv05       LIKE lsv_file.lsv05           #兌換基數換券金額
                    END RECORD,
    g_lsw           DYNAMIC ARRAY OF RECORD
        lsw02       LIKE lsw_file.lsw02,
        lpx02_1     LIKE lpx_file.lpx02
                    END RECORD,
    g_lsw_t         RECORD
        lsw02       LIKE lsw_file.lsw02,
        lpx02_1     LIKE lpx_file.lpx02
                    END RECORD,
    g_lsw_o         RECORD
        lsw02       LIKE lsw_file.lsw02,
        lpx02_1     LIKE lpx_file.lpx02
                    END RECORD,
    g_sql           STRING,                       
    g_wc            STRING,                       
    g_wc2           STRING,
    g_wc3           STRING,                       
    g_rec_b         LIKE type_file.num5,
    g_rec_b1        LIKE type_file.num5,         
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
DEFINE g_argv1             LIKE lsu_file.lsu01
DEFINE g_argv2             STRING
DEFINE g_b_flag            STRING
DEFINE g_flag              LIKE type_file.chr1  
DEFINE g_ary          DYNAMIC ARRAY OF RECORD
          plant            LIKE azw_file.azw01,          #plant
          acti             LIKE lsz_file.lsz10           #有效否
                      END RECORD
DEFINE g_cnt2              LIKE type_file.num5
DEFINE g_flag2             LIKE type_file.chr1
DEFINE g_lsz02             LIKE lsz_file.lsz02    #FUN-C60089 add
DEFINE g_lsu02_t           LIKE lsu_file.lsu02    #CHI-C80047 add
MAIN
   OPTIONS
       INPUT NO WRAP    
   DEFER INTERRUPT
   LET g_argv1 = ARG_VAL(1)      

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
   IF g_argv1 = '1' THEN
      LET g_prog = 'almt591'
      LET g_lsz02 = '2'   #FUN-C60089 add
   ELSE                   #FUN-C60089 add
      LET g_lsz02 = '1'   #FUN-C60089 add
   END IF

  #FUN-C60089 add START
   IF cl_null(g_argv1) THEN
      LET g_lsu.lsu00 = '0'
   ELSE
      IF g_argv1 = '1' THEN
         LET g_lsu.lsu00 = '1'
      END IF
   END IF
  #FUN-C60089 add END

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

  #LET g_forupd_sql = "SELECT * FROM lsu_file WHERE lsu00 = '",g_lsu.lsu00,"' AND lsu01=? AND lsu11=? AND lsu12=? FOR UPDATE"  #FUN-C60089 add lsu00  #CHI-C80047 mark
   LET g_forupd_sql = "SELECT * FROM lsu_file WHERE lsu00 = '",g_lsu.lsu00,"' AND lsu01=? AND lsu11=? ",       #CHI-C80047 add
                      "                         AND lsu12=? AND lsu02 = ? FOR UPDATE"                                        #CHI-C80047 add 

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t590_cl CURSOR FROM g_forupd_sql

   OPEN WINDOW t590_w WITH FORM "alm/42f/almt590"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   IF cl_null(g_argv1) THEN
      CALL cl_set_comp_visible("lsu10,lsv03",FALSE)
   ELSE
      IF g_argv1 = '1' THEN
         CALL cl_set_comp_visible("lsv02",FALSE)
      END IF
   END IF

   DISPLAY BY NAME g_lsu.lsu00     #FUN-C60089 add 

   LET g_action_choice = ""
   CALL t590_menu()
   CLOSE WINDOW t590_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN


FUNCTION t590_menu()
   DEFINE l_str  LIKE type_file.chr1000
   DEFINE l_msg  LIKE type_file.chr1000

   WHILE TRUE
      CALL t590_bp("G")
      CASE g_action_choice

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t590_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t590_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t590_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t590_u()
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t590_x()
            END IF

         WHEN "detail"
           IF cl_chk_act_auth() THEN
             IF g_b_flag IS NULL OR g_b_flag ='1' THEN
                 CALL t590_b()
              ELSE
                 CALL t590_b1()
              END IF
           ELSE
              LET g_action_choice = NULL
           END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lsu),'','')
            END IF

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t590_y()
            END IF

         WHEN "category"  #生效營運中心
           IF cl_chk_act_auth() THEN
              IF g_lsu.lsu01 IS NULL THEN
                 CALL cl_err('',-400,0)
              ELSE
                #CALL t590_sub(g_lsu.lsu01,g_lsu.lsu12,'1',g_lsu.lsu11)      #FUN-C60089 mark
                 CALL t590_sub(g_lsu.lsu01,g_lsu.lsu12,g_lsz02,g_lsu.lsu11,g_lsu.lsu02)  #FUN-C60089 add  #CHI-C80047 add lsu02
              END IF
           END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION t590_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   LET g_success = 'Y'
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   CALL cl_set_act_visible("accept,cancel",FALSE )  

   LET g_action_choice = " "
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_lsv TO s_lsv.* ATTRIBUTE(COUNT=g_rec_b)
        BEFORE DISPLAY
           LET g_b_flag='1'
           CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY
 
      DISPLAY ARRAY g_lsw TO s_lsw.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            LET g_b_flag='2'
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
         CALL t590_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION previous
         CALL t590_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION jump
         CALL t590_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION next
         CALL t590_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION last
         CALL t590_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG

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

FUNCTION t590_cs()

   CLEAR FORM
   CALL g_lsv.clear()
   CALL g_lsw.clear()
   IF cl_null(g_argv1) THEN
      LET g_lsu.lsu00 = '0'
   ELSE
      IF g_argv1 = '1' THEN
         LET g_lsu.lsu00 = '1'
      END IF
   END IF
   DISPLAY BY NAME g_lsu.lsu00
   CONSTRUCT BY NAME g_wc ON lsu11,lsu01,lsu12,lsu02,lsu03,lsu04,lsu05,lsu13,lsu14,
                             lsu10,lsu06,lsu07,lsu08,lsu09,lsuplant,lsulegal,   
                             lsuuser,lsugrup,lsuoriu,lsuorig,  
                             lsucrat,lsumodu,lsuacti,lsudate
      ON ACTION controlp
         CASE
           WHEN INFIELD(lsu11)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lsu11"
              IF cl_null(g_argv1) THEN
                 LET g_qryparam.where = " lsu00 = '0' "
              ELSE
                 LET g_qryparam.where = " lsu00 = '",g_argv1,"'"
              END IF
              LET g_qryparam.state = "c"
              CALL cl_create_qry()
                   RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lsu11
              NEXT FIELD lsu11

           WHEN INFIELD(lsuplant)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lsuplant"
              IF cl_null(g_argv1) THEN
                 LET g_qryparam.where = " lsu00 = '0' "
              ELSE
                 LET g_qryparam.where = " lsu00 = '",g_argv1,"'"
              END IF
              LET g_qryparam.state = "c"
              CALL cl_create_qry()
                   RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lsuplant
              NEXT FIELD lsuplant
 
           WHEN INFIELD(lsulegal)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lsulegal"
              IF cl_null(g_argv1) THEN
                 LET g_qryparam.where = " lsu00 = '0' "
              ELSE
                 LET g_qryparam.where = " lsu00 = '",g_argv1,"'"
              END IF
              LET g_qryparam.state = "c"
              CALL cl_create_qry()
                   RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lsulegal
              NEXT FIELD lsulegal
 
            WHEN INFIELD(lsu01)   #方案編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lsu01"
               IF cl_null(g_argv1) THEN
                  LET g_qryparam.where = " lsu00 = '0' "
               ELSE
                  LET g_qryparam.where = " lsu00 = '",g_argv1,"'"
               END IF
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lsu01
               NEXT FIELD lsu01
 
            WHEN INFIELD(lsu02)   #卡種編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lsu02"
               IF cl_null(g_argv1) THEN
                  LET g_qryparam.where = " lsu00 = '0' "
               ELSE
                  LET g_qryparam.where = " lsu00 = '",g_argv1,"'"
               END IF
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lsu02
               CALL t590_lsu02('d')
               NEXT FIELD lsu02
 
            WHEN INFIELD(lsu07)  #審核人
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lsu10"
               IF cl_null(g_argv1) THEN
                  LET g_qryparam.where = " lsu00 = '0' "
               ELSE
                  LET g_qryparam.where = " lsu00 = '",g_argv1,"'"
               END IF
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lsu07
               NEXT FIELD lsu07
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lsuuser', 'lsugrup') 
   LET g_wc = " lsu00 = '",g_lsu.lsu00,"' AND ",g_wc CLIPPED 
   IF INT_FLAG THEN
      RETURN
   END IF

   CONSTRUCT g_wc2 ON lsv02,lsv03,lsv04,lsv05              
        FROM s_lsv[1].lsv02,s_lsv[1].lsv03,s_lsv[1].lsv04, 
             s_lsv[1].lsv05

      ON ACTION about
         CALL cl_about()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

   END CONSTRUCT

   IF INT_FLAG THEN
      RETURN
   END IF 

   CONSTRUCT g_wc3 ON lsw02,lpx02_1
        FROM s_lsw[1].lsw02, s_lsw[1].lpx02_1

      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(lsw02)  #券類型編號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form ="q_lsw02_1"
              IF cl_null(g_argv1) THEN
                 LET g_qryparam.arg1 = '0'
              ELSE
                 LET g_qryparam.arg1 =g_argv1
              END IF
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lsw02
              NEXT FIELD lsw02
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

      ON ACTION qbe_save
         CALL cl_qbe_save()


   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF

   IF cl_null(g_wc3) THEN
      LET g_wc3=' 1=1'
   END IF
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF

   IF g_wc2 = " 1=1" THEN
      IF g_wc3 = " 1=1" THEN   #FUN-C60089 add
          LET g_sql = "SELECT lsu01,lsu11,lsu12,lsu02 FROM lsu_file ",  #CHI-C80047 add lsu02
                      " WHERE ", g_wc CLIPPED,
                      "   AND lsuplant = '",g_plant,"' ",  #FUN-C60089 add
                      " ORDER BY lsu01"
     #FUN-C60089 add START
      ELSE
          LET g_sql = "SELECT DISTINCT lsu01,lsu11,lsu12,lsu02 ",  #CHI-C80047 add lsu02
                      "  FROM lsu_file,lsw_file ",
                      " WHERE lsu00 = lsw00 AND lsu01 = lsw01 ",
                      "   AND lsu11 = lsw03 AND lsu12 = lsw04 ",
                      "   AND lsu02 = lsw05 ",             #CHI-C80047 add
                      "   AND ", g_wc CLIPPED, 
                      "   AND ", g_wc3 CLIPPED,
                      "   AND lsuplant = lswplant ",       #FUN-C60089 add
                      "   AND lsuplant = '",g_plant,"' ",  #FUN-C60089 add
                      " ORDER BY lsu01"
      END IF
     #FUN-C60089 add END
   ELSE
      IF g_wc3 = " 1=1" THEN          #FUN-C60089 add
         LET g_sql = "SELECT UNIQUE lsu01 ,lsu11,lsu12,lsu02 ",   #FUN-C60089 add lsu11  #CHI-C80047 add lsu02
                     "  FROM lsu_file, lsv_file ",
                     " WHERE lsu01 = lsv01",
                     "   AND lsu00 = lsv00",   #FUN-C60089 add
                     "   AND lsu11 = lsv06",   #FUN-C60089 add
                     "   AND lsu12 = lsv07",   #FUN-C60089 add
                     "   AND lsu02 = lsv08",   #CHI-C80047 add
                     "   AND lsuplant = lsvplant  ",      #FUN-C60089 add
                     "   AND lsuplant = '",g_plant,"' ",  #FUN-C60089 add
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY lsu01"
     #FUN-C60089 add START
      ELSE
         LET g_sql = "SELECT UNIQUE lsu01 ,lsu11,lsu12,lsu02 ",   #CHI-C80047 add lsu02
                     "  FROM lsu_file, lsv_file,lsw_file ",
                     " WHERE lsu01 = lsv01 ",
                     "   AND lsu00 = lsv00 ",  
                     "   AND lsu02 = lsv08 ",   #CHI-C80047 add
                     "   AND lsu02 = lsw05 ",   #CHI-C80047 add
                     "   AND lsu11 = lsv06 ",
                     "   AND lsu12 = lsv07 ",
                     "   AND lsu00 = lsw00 AND lsu01 = lsw01 ",
                     "   AND lsu11 = lsw03 ",
                     "   AND lsu12 = lsw04 ",
                     "   AND lsuplant = lsvplant ",        #FUN-C60089 add
                     "   AND lsuplant = lswplant ",        #FUN-C60089 add
                     "   AND lsuplant = '",g_plant,"' ",   #FUN-C60089 add
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED, 
                     "   AND ",g_wc3 CLIPPED,
                     " ORDER BY lsu01"
      END IF 
     #FUN-C60089 add END
   END IF

   PREPARE t590_prepare FROM g_sql
   DECLARE t590_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t590_prepare

   IF g_wc2 = " 1=1" THEN
      IF g_wc3 = " 1=1" THEN    #FUN-C60089 add
         LET g_sql="SELECT COUNT(*) FROM lsu_file WHERE ",g_wc CLIPPED
     #FUN-C60089 add START
      ELSE
         LET g_sql=" SELECT COUNT(*) ",
                   "   FROM lsu_file,lsw_file ",
                   "  WHERE lsu00 = lsw00 AND lsu01 = lsw01 ",
                   "    AND lsu11 = lsw03 AND lsu12 = lsw04 ",
                   "    AND lsu02 = lsw05 ",               #CHI-C80047 add
                   "    AND lsuplant = lswplant ",         #FUN-C60089 add
                   "    AND lsuplant = '",g_plant,"' ",    #FUN-C60089 add
                   "    AND ",g_wc CLIPPED,
                   "    AND ",g_wc3 CLIPPED

      END IF
     #FUN-C60089 add END
   ELSE
      IF g_wc3 = " 1=1" THEN    #FUN-C60089 add
        #LET g_sql="SELECT COUNT(DISTINCT lsu01) FROM lsu_file,lsv_file WHERE ",   #FUN-C60089 mark
     #FUN-C60089 add START
         LET g_sql="SELECT COUNT(*) ",                   
                   "  FROM lsu_file,lsv_file ",
                   "  WHERE ",                            
                   "        lsu00 = lsv00 AND lsu01 = lsv01 ",   
                   "    AND lsu02 = lsv08 ",    #CHI-C80047 add
                   "    AND lsu11 = lsv06 AND lsu12 = lsv07 ",   
                   "    AND lsuplant = lsvplant  ",       #FUN-C60089 add
                   "    AND lsuplant = '",g_plant,"' ",   #FUN-C60089 add
                   "    AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      ELSE
         LET g_sql="SELECT COUNT(*) ",                     
                   "  FROM lsu_file,lsv_file,lsw_file ",   
                   "  WHERE ",                             
                   "        lsu00 = lsv00 AND lsu01 = lsv01 ",   
                   "    AND lsu02 = lsv08 AND lsu02 = lsw05 ",   #CHI-C80047 add
                   "    AND lsu11 = lsv06 AND lsu12 = lsv07 ",   
                   "    AND lsu00 = lsw00 AND lsu01 = lsw01 ",   
                   "    AND lsu11 = lsw03 AND lsu12 = lsw04 ",   
                   "    AND lsuplant = lsvplant AND lsuplant = lswplant ",
                   "    AND lsuplant = '",g_plant,"' ", 
                   "    AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   "    AND ",g_wc3 CLIPPED                  
      END IF
     #FUN-C60089 add END
   END IF
   PREPARE t590_precount FROM g_sql
   DECLARE t590_count CURSOR FOR t590_precount

END FUNCTION

FUNCTION t590_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lsv.clear()
   CALL g_lsw.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   CALL t590_cs()

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lsu.* TO NULL
      RETURN
   END IF

   OPEN t590_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lsu.* TO NULL
   ELSE
      OPEN t590_count
      FETCH t590_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt

      CALL t590_fetch('F')
   END IF

END FUNCTION

FUNCTION t590_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     t590_cs INTO g_lsu.lsu01, g_lsu.lsu11, g_lsu.lsu12,g_lsu.lsu02   #CHI-C80047 add
      WHEN 'P' FETCH PREVIOUS t590_cs INTO g_lsu.lsu01, g_lsu.lsu11, g_lsu.lsu12,g_lsu.lsu02   #CHI-C80047 add
      WHEN 'F' FETCH FIRST    t590_cs INTO g_lsu.lsu01, g_lsu.lsu11, g_lsu.lsu12,g_lsu.lsu02   #CHI-C80047 add
      WHEN 'L' FETCH LAST     t590_cs INTO g_lsu.lsu01, g_lsu.lsu11, g_lsu.lsu12,g_lsu.lsu02   #CHI-C80047 add
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
      FETCH ABSOLUTE g_jump t590_cs INTO g_lsu.lsu01, g_lsu.lsu11, g_lsu.lsu12
      LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lsu.lsu01,SQLCA.sqlcode,0)
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

   SELECT * INTO g_lsu.* FROM lsu_file 
      WHERE lsu00 = g_lsu.lsu00   #FUN-C60089 add
        AND lsu01 = g_lsu.lsu01 
        AND lsu02 = g_lsu.lsu02   #CHI-C80047 add
        AND lsu11 = g_lsu.lsu11 AND  lsu12 = g_lsu.lsu12
        AND lsuplant = g_plant    #FUN-C60089 add
      ORDER BY lsu01,lsu11,lsu12
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lsu_file","","",SQLCA.sqlcode,"","",0)
      INITIALIZE g_lsu.* TO NULL
      RETURN
   END IF

   LET g_data_owner = g_lsu.lsuuser
   LET g_data_group = g_lsu.lsugrup
   LET g_data_plant = g_lsu.lsuplant
   CALL t590_show()

END FUNCTION

FUNCTION t590_show()
   LET g_lsu_t.* = g_lsu.*
   LET g_lsu_o.* = g_lsu.*
   DISPLAY BY NAME g_lsu.lsu11,g_lsu.lsu00,g_lsu.lsu01,g_lsu.lsu12,g_lsu.lsu02,
                   g_lsu.lsu03,g_lsu.lsu04,g_lsu.lsu05,g_lsu.lsu13,
                   g_lsu.lsu14,g_lsu.lsu10,g_lsu.lsu06,
                   g_lsu.lsu07,g_lsu.lsu08,g_lsu.lsu09,                                                   
                   g_lsu.lsuplant,g_lsu.lsulegal,
                   g_lsu.lsuuser,g_lsu.lsugrup,
                   g_lsu.lsucrat,g_lsu.lsumodu,
                   g_lsu.lsudate,g_lsu.lsuacti,
                   g_lsu.lsuoriu,g_lsu.lsuorig
   CALL t590_lsu11()  
   CALL t590_lsu01()
   CALL t590_lsuplant()
   CALL t590_lsu02('d')
   CALL t590_b_fill(g_wc2)
   CALL t590_b1_fill(g_wc3)   
   CALL t590_field_pic()
END FUNCTION

FUNCTION t590_lsu11()  #制定營運中心名稱
DEFINE l_rtz13      LIKE rtz_file.rtz13

   DISPLAY '' TO FORMONLY.lsu11_desc

   IF NOT cl_null(g_lsu.lsu11) THEN
       SELECT rtz13 INTO l_rtz13 FROM rtz_file
        WHERE rtz01 = g_lsu.lsu11
          AND rtz28 = 'Y'
       DISPLAY l_rtz13 TO FORMONLY.lsu11_desc

   END IF
END FUNCTION

FUNCTION t590_lsu01()  #方案代碼說明
DEFINE l_lsl03      LIKE lsl_file.lsl03  

   DISPLAY '' TO FORMONLY.lsu01_desc

   IF NOT cl_null(g_lsu.lsu01) THEN
       SELECT lsl03 INTO l_lsl03 FROM lsl_file
        WHERE lsl02 = g_lsu.lsu01 
          AND lslconf = 'Y'
          AND lsl01 = g_lsu.lsu11 
       DISPLAY l_lsl03 TO FORMONLY.lsu01_desc
   END IF
END FUNCTION

FUNCTION t590_chk_lsu01()  #確認方案代碼已存在於almi590/almi591內 並且已發出
DEFINE l_n          LIKE type_file.num5
DEFINE l_lsl03      LIKE lsl_file.lsl03
DEFINE l_lst09      LIKE lst_file.lst09
DEFINE l_lst16      LIKE lst_file.lst16

   LET g_errno = ' ' 
   LET l_n = 0 
   IF NOT cl_null(g_lsu.lsu01) THEN
      IF cl_null(g_lsu.lsu02) THEN   #CHI-C80047 add
         IF cl_null(g_argv1) THEN
            SELECT COUNT(*) INTO l_n FROM lst_file
             WHERE lst01 = g_lsu.lsu01
               AND lst14 = g_lsu.lsu11
               AND lst00 = '0'
               AND lstplant = g_plant    #FUN-C60089 add
         ELSE
            SELECT COUNT(*) INTO l_n FROM lst_file
             WHERE lst01 = g_lsu.lsu01
               AND lst14 = g_lsu.lsu11
               AND lst00 = '1' 
               AND lstplant = g_plant    #FUN-C60089 add
         END IF
     #CHI-C80047 add START
      ELSE
         IF cl_null(g_argv1) THEN
            SELECT COUNT(*) INTO l_n FROM lst_file
             WHERE lst01 = g_lsu.lsu01
               AND lst14 = g_lsu.lsu11
               AND lst00 = '0'
               AND lst03 = g_lsu.lsu02   
               AND lstplant = g_plant    
         ELSE
            SELECT COUNT(*) INTO l_n FROM lst_file
             WHERE lst01 = g_lsu.lsu01
               AND lst14 = g_lsu.lsu11
               AND lst00 = '1'
               AND lst03 = g_lsu.lsu02 
               AND lstplant = g_plant   
         END IF
      END IF
     #CHI-C80047 add END
      IF l_n = 0 THEN
         LET g_errno = 'alm-h34'   #輸入的方案代碼不存在於almi590/almi591中
         RETURN
      END IF
      LET l_n = 0 
      IF cl_null(g_argv1) THEN
         SELECT COUNT(*) INTO l_n FROM lsu_file   #輸入方案代碼已存在未確認的變更單  #almt590
          WHERE lsu01 = g_lsu.lsu01 AND lsu06 = 'N'
            AND lsu02 = g_lsu.lsu02    #CHI-C80047 add
            AND lsu11 = g_lsu.lsu11
            AND lsu00 = '0'
            AND lsuplant = g_plant   #FUN-C60089 add
      ELSE
         SELECT COUNT(*) INTO l_n FROM lsu_file   #輸入方案代碼已存在未確認的變更單  #almt591
          WHERE lsu01 = g_lsu.lsu01 AND lsu06 = 'N'
            AND lsu02 = g_lsu.lsu02    #CHI-C80047 add
            AND lsu11 = g_lsu.lsu11
            AND lsu00 = '1'
            AND lsuplant = g_plant   #FUN-C60089 add
      END IF
      IF l_n > 0 THEN
         LET g_errno = 'alm-h37'
         RETURN
      END IF
      SELECT lst09, lst16 INTO l_lst09, l_lst16
          FROM lst_file
         WHERE lst01 = g_lsu.lsu01
           AND lst00 = g_lsu.lsu00   #FUN-C60089 add
           AND lst14 = g_lsu.lsu11
           AND lst03 = g_lsu.lsu02   #CHI-C80047 add
           AND lstplant = g_plant    #FUN-C60089 add
   END IF
   IF l_lst09 = 'N' THEN
      LET g_errno = 'alm-h35' 
      RETURN
   END IF
   IF l_lst16 = 'N' THEN
      LET g_errno = 'alm-h36'
      RETURN
   END IF
END FUNCTION

FUNCTION t590_lsuplant()
DEFINE l_rtz13      LIKE rtz_file.rtz13   
DEFINE l_azt02      LIKE azt_file.azt02

  DISPLAY '' TO FORMONLY.rtz13

  IF NOT cl_null(g_lsu.lsuplant) THEN
      SELECT rtz13 INTO l_rtz13 FROM rtz_file
       WHERE rtz01 = g_lsu.lsuplant
         AND rtz28 = 'Y'
      DISPLAY l_rtz13 TO FORMONLY.rtz13

     SELECT azt02 INTO l_azt02 FROM azt_file
      WHERE azt01 = g_lsu.lsulegal
     DISPLAY l_azt02 TO FORMONLY.azt02
  END IF
END FUNCTION

FUNCTION t590_lsu02(p_cmd)
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
      FROM lph_file WHERE lph01 = g_lsu.lsu02
       AND lphacti='Y'

    CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'mfg3006'
         WHEN l_lphacti='N'      LET g_errno = 'mfg9028'
         WHEN l_lph06  ='N'      LET g_errno = 'alm-628'
         WHEN l_lph24 <> 'Y'     LET g_errno = '9029'
         OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
    DISPLAY l_lph02 TO FORMONLY.lph02
    END IF
END FUNCTION

FUNCTION t590_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2       STRING

   LET g_sql = "SELECT lsv02,lsv03,lsv04,lsv05 ",  
               "  FROM lsv_file",
               " WHERE lsv01 ='",g_lsu.lsu01,"' AND lsv06 = '",g_lsu.lsu11,"' ",
               "   AND lsv00 = '",g_lsu.lsu00,"' ",  #FUN-C60089 add
               "   AND lsv08 = '",g_lsu.lsu02,"' ",  #CHI-C80047 add
               "   AND lsv07 = '",g_lsu.lsu12,"' ",
              #"   AND lsvplant = '",g_plant,"' "    #FUN-C60089 add   #CHI-C80047 mark 
               "   AND lsvplant = '",g_lsu.lsuplant,"' "               #CHI-C80047 add

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lsv02 "
   DISPLAY g_sql

   PREPARE t590_pb FROM g_sql
   DECLARE lsv_cs                       #CURSOR
       CURSOR FOR t590_pb

   CALL g_lsv.clear()
   LET g_cnt = 1

   FOREACH lsv_cs INTO g_lsv[g_cnt].*
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
   CALL g_lsv.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION t590_b1_fill(p_wc3)
DEFINE p_wc3           VARCHAR(200)

    LET g_sql =
        "SELECT lsw02,''  FROM lsw_file ",
        " WHERE lsw01 = '",g_lsu.lsu01,"' ",
        "   AND lsw00 = '",g_lsu.lsu00,"' ",  #FUN-C60089 add
        "   AND lsw03 = '",g_lsu.lsu11,"' ",
        "   AND lsw04 = '",g_lsu.lsu12,"' ",
        "   AND lsw05 = '",g_lsu.lsu02,"' ",  #CHI-C80047 add
       #"   AND lswplant = '",g_plant,"' ",   #FUN-C60089 add  #CHI-C80047 mark
        "   AND lswplant = '",g_lsu.lsuplant,"' ",             #CHI-C80047 add  
        "   AND ",p_wc3 CLIPPED,
        " ORDER BY lsw02 "

    PREPARE t590_pd FROM g_sql
    DECLARE lsw_curs CURSOR FOR t590_pd

    CALL g_lsw.clear()
    LET g_cnt = 1

    FOREACH lsw_curs INTO g_lsw[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
              SELECT lpx02 INTO g_lsw[g_cnt].lpx02_1
                FROM lpx_file
               WHERE lpx01 =g_lsw[g_cnt].lsw02
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH

    CALL g_lsw.deleteElement(g_cnt)
    LET g_rec_b1=g_cnt-1
   DISPLAY g_rec_b1 TO FORMONLY.cn3
END FUNCTION

FUNCTION t590_field_pic()
   DEFINE l_flag   LIKE type_file.chr1

   CASE
     WHEN g_lsu.lsuacti = 'N'
        CALL cl_set_field_pic("","","","","","N")
     WHEN g_lsu.lsu06 = 'Y'
        CALL cl_set_field_pic("Y","","","","","")
     OTHERWISE
        CALL cl_set_field_pic("","","","","","")
   END CASE
END FUNCTION

FUNCTION t590_a()
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num10

   MESSAGE ""
   CLEAR FORM
   CALL g_lsv.clear()
   CALL g_lsw.clear()

   IF s_shut(0) THEN
      RETURN
   END IF

   INITIALIZE g_lsu.* LIKE lsu_file.*
   LET g_lsu01_t = NULL

   LET g_lsu.lsu06 = 'N'
   LET g_lsu_t.* = g_lsu.*
   LET g_lsu_o.* = g_lsu.*
   CALL cl_opmsg('a')
   

   WHILE TRUE
      IF cl_null(g_argv1) THEN
         LET g_lsu.lsu00 = '0'
         LET g_lsu.lsu10 = ' '
      ELSE
         IF g_argv1 = '1' THEN
            LET g_lsu.lsu00 = '1'
            LET g_lsu.lsu10 = '0'
         END IF
      END IF
      LET g_lsu.lsu06='N'
      LET g_lsu.lsu12 = ' '
      LET g_lsu.lsuplant = g_plant
      LET g_lsu.lsulegal = g_legal
      LET g_lsu.lsuoriu = g_user   
      LET g_lsu.lsuorig = g_grup   
      LET g_data_plant = g_plant   
      LET g_lsu.lsuuser=g_user
      LET g_lsu.lsucrat=g_today
      LET g_lsu.lsugrup=g_grup
      LET g_lsu.lsuacti='Y'
      LET g_lsu.lsu11 = g_plant      #制定營運中心
      LET g_lsu.lsu12 = 0            #版本號
      LET g_lsu.lsu13 = '1'          #兌換限制
      LET g_lsu.lsu14 = 0            #兌換次數
      CALL t590_lsu11()
      CALL t590_i("a")
     
      IF INT_FLAG THEN
         INITIALIZE g_lsu.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         ROLLBACK WORK
         EXIT WHILE
      END IF

      IF cl_null(g_lsu.lsu01) THEN
         CONTINUE WHILE
      END IF

      LET g_lsu.lsuoriu = g_user      
      LET g_lsu.lsuorig = g_grup      
      INSERT INTO lsu_file VALUES (g_lsu.*)

      IF SQLCA.sqlcode THEN
         CALL cl_err(g_lsu.lsu01,SQLCA.sqlcode,1)
         ROLLBACK WORK       
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_lsu.lsu01,'I')
      END IF


      CALL t590_temp('a',g_plant,g_legal)  #將前一版號的資料預設帶入   #CHI-C80047 add

      SELECT * INTO g_lsu.* FROM lsu_file
       WHERE lsu01 = g_lsu.lsu01 AND lsu12 = g_lsu.lsu12
         AND lsu00 = g_lsu.lsu00   #FUN-C60089 add
         AND lsu02 = g_lsu.lsu02   #CHI-C80047 add
         AND lsu11 = g_lsu.lsu11
         AND lsu12 = g_lsu.lsu12
         AND lsuplant = g_lsuplant   #FUN-C60089 add
      LET g_lsu01_t = g_lsu.lsu01
      LET g_lsu_t.* = g_lsu.*
      LET g_lsu_o.* = g_lsu.*
      CALL g_lsv.clear()

      CALL t590_b_fill("1=1")
      CALL t590_b1_fill("1=1")
      CALL t590_refresh()

     #因為預設會將前一版本的單身資料全部都帶進,所以這邊不可以直接將單身資料筆數設定為0
      IF cl_null(g_rec_b) THEN
         LET g_rec_b = 0 
      END IF
      IF cl_null(g_rec_b1) THEN
         LET g_rec_b1 = 0  
      END IF
      CALL t590_b()
      CALL t590_b1_fill("1=1")
      CALL t590_refresh()
      CALL t590_b1()  
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION t590_i(p_cmd)

DEFINE l_n,l_n1    LIKE type_file.num5
DEFINE p_cmd       LIKE type_file.chr8
DEFINE li_result   LIKE type_file.num5

   IF s_shut(0) THEN
      RETURN
   END IF

   DISPLAY BY NAME g_lsu.lsu11,g_lsu.lsu00,g_lsu.lsu01,g_lsu.lsu12,g_lsu.lsu02,
                   g_lsu.lsu03,g_lsu.lsu04,g_lsu.lsu05,
                   g_lsu.lsu13,g_lsu.lsu14,g_lsu.lsu10,g_lsu.lsu06,       
                   g_lsu.lsu07,g_lsu.lsu08,g_lsu.lsu09,g_lsu.lsu09,   
                   g_lsu.lsuplant,g_lsu.lsulegal,
                   g_lsu.lsuuser,g_lsu.lsucrat,g_lsu.lsumodu,
                   g_lsu.lsugrup,g_lsu.lsudate,g_lsu.lsuacti,g_lsu.lsuoriu,g_lsu.lsuorig

   INPUT BY NAME   g_lsu.lsu01,g_lsu.lsu02,g_lsu.lsu03,              
                   g_lsu.lsu04,g_lsu.lsu05,g_lsu.lsu10,
                   g_lsu.lsu13,g_lsu.lsu14,
                   g_lsu.lsu09
       WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_flag2 = 'N'
         LET g_before_input_done = FALSE
         CALL t590_set_entry(p_cmd)
         CALL t590_set_no_entry(p_cmd)
         CALL t590_entry_lsu13()
         CALL t590_lsuplant()
         LET g_before_input_done = TRUE

      AFTER FIELD lsu01
          IF cl_null(g_lsu.lsu01) THEN
             CALL cl_err('','alm-809',0)
             NEXT FIELD lsu01
          END IF
          IF NOT cl_null(g_lsu.lsu01) THEN
             IF p_cmd="a" OR (p_cmd="u" AND g_lsu.lsu01 !=g_lsu01_t) THEN
                LET g_errno = ' '
                CALL t590_chk_lsu01()   
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD lsu01
                END IF
                CALL t590_lsu01()  
               #IF g_flag2 <> 'Y' THEN   #FUN-C60089 add   #CHI-C80047 mark 
                IF NOT cl_null(g_lsu.lsu02) AND p_cmd = 'a'  THEN   #CHI-C80047 add
                   SELECT MAX(lsu12) INTO g_lsu.lsu12 FROM lsu_file
                     WHERE lsu01 = g_lsu.lsu01 AND lsu11 = g_lsu.lsu11 
                       AND lsu00 = g_lsu.lsu00    #FUN-C60089 add
                       AND lsu02 = g_lsu.lsu02    #CHI-C80047 add
                       AND lsuplant = g_plant     #FUN-C60089 add
                   IF cl_null(g_lsu.lsu12) THEN
                     LET g_lsu.lsu12 = 0
                   END IF
                  #CALL t590_temp('a',g_plant,g_legal)  #將前一版號的資料預設帶入  #CHI-C80047 mark
                   CALL t590_lsu12()   #將前一版號的資料預設帶入  #CHI-C80047 add 
                   LET g_lsu_o.* = g_lsu.*  #CHI-C80047 add
                END IF  #FUN-C60089 add
                CALL t590_entry_lsu13()    #FUN-C60089 add
             END IF
          END IF

     #CHI-C80047 add START
      AFTER FIELD lsu02
          IF NOT cl_null(g_lsu.lsu02) THEN
             IF p_cmd = 'a' OR 
                (p_cmd = 'u' AND g_lsu.lsu02 <> g_lsu_o.lsu02) THEN
                LET g_errno = ' '
                CALL t590_chk_lsu01()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD lsu02
                END IF
                IF NOT cl_null(g_lsu.lsu02) AND p_cmd = 'a' THEN   
                   SELECT MAX(lsu12) INTO g_lsu.lsu12 FROM lsu_file
                     WHERE lsu01 = g_lsu.lsu01 AND lsu11 = g_lsu.lsu11
                       AND lsu00 = g_lsu.lsu00    
                       AND lsu02 = g_lsu.lsu02    
                       AND lsuplant = g_plant     
                   IF cl_null(g_lsu.lsu12) THEN
                     LET g_lsu.lsu12 = 0
                   END IF
                   CALL t590_lsu12()   #將前一版號的資料預設帶入
                   LET g_lsu_o.* = g_lsu.*  
                END IF  
                CALL t590_entry_lsu13()   
             END IF
          END IF
     #CHI-C80047 add END

      AFTER FIELD lsu03
         IF NOT cl_null(g_lsu.lsu03) THEN
            IF g_lsu.lsu03 < g_today THEN
               CALL cl_err('','alm-804',0)
               NEXT FIELD lsu03
            END IF
         END IF
         IF NOT cl_null(g_lsu.lsu04) THEN
            IF g_lsu.lsu04 < g_lsu.lsu03 THEN
               CALL cl_err('','alm-805',0)
               NEXT FIELD lsu03
            END IF
         END IF

      AFTER FIELD lsu04
         IF NOT cl_null(g_lsu.lsu04) AND NOT cl_null(g_lsu.lsu03) THEN
            IF g_lsu.lsu04 < g_lsu.lsu03 THEN
               CALL cl_err('','alm-805',0)
               NEXT FIELD lsu04
            END IF
         END IF

      ON CHANGE lsu13 
         CALL t590_entry_lsu13()
         IF g_lsu.lsu13 <> '1' THEN
            IF g_lsu.lsu14 < 1 THEN
               CALL cl_err('','aec-042',0)
               NEXT FIELD lsu14
            END IF
         ELSE
            LET g_lsu.lsu14 = 0
            DISPLAY BY NAME g_lsu.lsu14
         END IF         

      AFTER FIELD lsu14
         IF NOT cl_null(g_lsu.lsu14) THEN
            IF g_lsu.lsu13 <> '1' THEN
               IF g_lsu.lsu14 < 1 THEN
                  CALL cl_err('','aec-042',0)
                  NEXT FIELD lsu14 
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
            WHEN INFIELD(lsu01) #方案編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lst01"
               LET g_qryparam.arg1 = g_plant
               LET g_qryparam.default1 = g_lsu.lsu01
               IF cl_null(g_argv1) THEN
                  LET g_qryparam.where = " lst14 = '",g_plant,"' AND lst00 = '0' "
               ELSE
                  LET g_qryparam.where = " lst14 = '",g_plant,"' AND lst00 = '",g_argv1,"'"
               END IF
               CALL cl_create_qry() RETURNING g_lsu.lsu01
               DISPLAY g_lsu.lsu01 TO lsu01
               CALL t590_lsu01()
               NEXT FIELD lsu01

            WHEN INFIELD(lsu02) #卡種編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lph01_2"       
               LET g_qryparam.default1 = g_lsu.lsu02
               CALL cl_create_qry() RETURNING g_lsu.lsu02
               DISPLAY g_lsu.lsu02 TO lsu02
               CALL t590_lsu02('d')
               NEXT FIELD lsu02
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
  #IF INT_FLAG AND p_cmd = 'a' AND g_flag2 = 'Y' THEN   #非正常離開必須要將剛才預設新增的單身資料刪除,避免錯誤
  #   DELETE FROM lsv_file WHERE lsv00 = g_lsu.lsu00 AND lsv01 = g_lsu.lsu01 AND lsv06 = g_lsu.lsu11    #FUN-C60089 add lsv00
  #                          AND lsv07 = g_lsu.lsu12 AND lsvplant = g_plant
  #                          AND lsv08 = g_lsu.lsu02     #CHI-C80047 add
  #   DELETE FROM lsw_file WHERE lsw00 = g_lsu.lsu00 AND lsw01 = g_lsu.lsu01 AND lsw03 = g_lsu.lsu11    #FUN-C60089 add lsw00
  #                          AND lsw04 = g_lsu.lsu12 AND lswplant = g_plant
  #                          AND lsw05 = g_lsu.lsu02     #CHI-C80047 add
  #  #DELETE FROM lsz_file WHERE lsz01 = g_lsu.lsu01 AND lsz02 = '1' AND lsz11 = g_lsu.lsu11 AND lsz12 = g_lsu.lsu12 AND lszplant = g_plant   #FUN-C60089 mark
  #   DELETE FROM lsz_file WHERE lsz01 = g_lsu.lsu01 AND lsz02 = g_lsz02 AND lsz11 = g_lsu.lsu11         #FUN-C60089 add
  #                          AND lsz12 = g_lsu.lsu12 AND lszplant = g_plant                              #FUN-C60089 add
  #                          AND lsz13 = g_lsu.lsu02     #CHI-C80047 add
  #END IF
  #CHI-C80047 mark END

END FUNCTION

FUNCTION t590_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("lsu01,",TRUE)
  END IF

END FUNCTION

FUNCTION t590_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

  CALL cl_set_comp_entry("lsu07,lsu08",FALSE)

  IF p_cmd='u' AND g_chkey='N' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("lsu01",FALSE)
  END IF

END FUNCTION

FUNCTION t590_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("",TRUE)
  END IF

  IF cl_null(g_argv1) THEN
     CALL cl_set_comp_required("lsv02,lsv05,lsv04",TRUE)
  ELSE
    IF g_argv1 = '1' THEN
       CALL cl_set_comp_required("lsv05,lsv04",TRUE)
    END IF
  END IF
END FUNCTION

FUNCTION t590_set_entry_b1(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("",TRUE)
  END IF
  CALL cl_set_comp_required("lsw02",TRUE)
END FUNCTION

FUNCTION t590_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n,l_n1,l_n2   LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5,
    l_sfb08         LIKE sfb_file.sfb08

    LET g_action_choice = ""

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_lsu.lsu01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_lsu.* FROM lsu_file
     WHERE lsu01=g_lsu.lsu01 AND lsu11 = g_lsu.lsu11   
       AND lsu00 = g_lsu.lsu00  #FUN-C60089 add
       AND lsu02 = g_lsu.lsu02  #CHI-C80047 add
       AND lsu12 = g_lsu.lsu12
       AND lsuplant = g_plant   #FUN-C60089 add

    IF g_lsu.lsuacti ='N' THEN
       CALL cl_err(g_lsu.lsu01,'mfg1000',0)
       RETURN
    END IF
    IF g_lsu.lsu06 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lsu.lsu06 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF

    IF g_plant <> g_lsu.lsu11 THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF

    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT lsv02,lsv03,lsv04,lsv05 ",   
                       "  FROM lsv_file",
                       " WHERE lsv01 = ? AND lsv02 = ? AND lsv03 = ? ",
                       "   AND lsv06 = ? AND lsv07 = ? ",
                       "   AND lsv08 = '",g_lsu.lsu02,"' ",  #CHI-C80047 add        
                       "   AND lsvplant = '",g_plant,"' ",   #FUN-C60089 add
                       "   AND lsv00 = '",g_lsu.lsu00,"' FOR UPDATE"      #FUN-C60089 add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t590_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")


    INPUT ARRAY g_lsv WITHOUT DEFAULTS FROM s_lsv.*
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

           OPEN t590_cl USING g_lsu.lsu01,g_lsu.lsu11,g_lsu.lsu12,g_lsu.lsu02   #CHI-C80047 add lsu02
           IF STATUS THEN
              CALL cl_err("OPEN t590_cl:", STATUS, 1)
              CLOSE t590_cl
              ROLLBACK WORK
              RETURN
           END IF

           FETCH t590_cl INTO g_lsu.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lsu.lsu01,SQLCA.sqlcode,0)
              CLOSE t590_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lsv_t.* = g_lsv[l_ac].*  #BACKUP
              LET g_lsv_o.* = g_lsv[l_ac].*  #BACKUP
              OPEN t590_bcl USING g_lsu.lsu01,g_lsv[l_ac].lsv02,g_lsv[l_ac].lsv03,g_lsu.lsu11, g_lsu.lsu12  
              IF STATUS THEN
                 CALL cl_err("OPEN t590_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t590_bcl INTO g_lsv[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lsu.lsu01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL t590_set_entry_b(p_cmd)
              IF cl_null(g_argv1) THEN
                 NEXT FIELD lsv02
              ELSE
                 IF g_argv1 = '1' THEN
                    NEXT FIELD lsv03
                 END IF
              END IF
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET p_cmd='a'
           LET l_n = ARR_COUNT()
           INITIALIZE g_lsv[l_ac].* TO NULL
           IF cl_null(g_argv1) THEN
              LET g_lsv[l_ac].lsv03 = 0
           ELSE
              IF g_argv1 = '1' THEN
                 LET g_lsv[l_ac].lsv02 = 0
              END IF
           END IF
           LET g_lsv_t.* = g_lsv[l_ac].*
           LET g_lsv_o.* = g_lsv[l_ac].*
           CALL t590_set_entry_b(p_cmd)
           IF cl_null(g_argv1) THEN
              NEXT FIELD lsv02
           ELSE
              IF g_argv1 = '1' THEN
                 NEXT FIELD lsv03
              END IF
           END IF

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO lsv_file(lsvplant,lsvlegal,lsv00,lsv01,lsv02,lsv03,lsv04,lsv05,lsv06,lsv07,lsv08)                #FUN-C60089 add lsv00  #CHI-C80047 add lsv08                
           VALUES(g_plant,g_legal,g_lsu.lsu00,g_lsu.lsu01,g_lsv[l_ac].lsv02,g_lsv[l_ac].lsv03,g_lsv[l_ac].lsv04,        #FUN-C60089 add lsu00
                  g_lsv[l_ac].lsv05,g_plant,g_lsu.lsu12,g_lsu.lsu02)                                                    #CHI-C80047 add lsu02            
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lsv_file",g_lsu.lsu01,g_lsv[l_ac].lsv02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

       AFTER FIELD lsv02
          IF NOT cl_null(g_lsv[l_ac].lsv02) THEN
             IF (g_lsv[l_ac].lsv02 !=g_lsv_t.lsv02) OR
                g_lsv_t.lsv02 IS NULL  THEN
                SELECT COUNT(*) INTO l_n FROM lsv_file
                 WHERE lsv01=g_lsu.lsu01
                   AND lsv00 = g_lsu.lsu00    #FUN-C60089 add
                   AND lsv02=g_lsv[l_ac].lsv02
                   AND lsv06=g_lsu.lsu11 
                   AND lsv07=g_lsu.lsu12
                   AND lsv08=g_lsu.lsu02      #CHI-C80047 add
                   AND lsvplant = g_plant     #FUN-C60089 add
                IF l_n > 0 THEN
                   CALL cl_err("",-239,1)
                   LET g_lsv[l_ac].lsv02=g_lsv_t.lsv02
                   NEXT FIELD lsv02
                END IF
             END IF
             IF g_lsv[l_ac].lsv02 <= 0 THEN    
                CALL cl_err("","alm-808",0)
                NEXT FIELD lsv02
             END IF
          END IF

       AFTER FIELD lsv03
          IF NOT cl_null(g_lsv[l_ac].lsv03) THEN
             IF (g_lsv[l_ac].lsv03 !=g_lsv_t.lsv03) OR
                g_lsv_t.lsv03 IS NULL  THEN
                SELECT COUNT(*) INTO l_n FROM lsv_file
                 WHERE lsv01 = g_lsu.lsu01
                   AND lsv00 = g_lsu.lsu00     #FUN-C60089 add
                   AND lsv03 = g_lsv[l_ac].lsv03
                   AND lsv06 = g_lsu.lsu11
                   AND lsv07 = g_lsu.lsu12
                   AND lsv08 = g_lsu.lsu02     #CHI-C80047 add
                   AND lsvplant = g_plant      #FUN-C60089 add
                IF l_n > 0 THEN
                   CALL cl_err("",-239,1)
                   LET g_lsv[l_ac].lsv03=g_lsv_t.lsv03
                   NEXT FIELD lsv03
                END IF
             END IF
             IF g_lsv[l_ac].lsv03 <= 0 THEN
                CALL cl_err("","alm-808",0)
                NEXT FIELD lsv03
             END IF
          END IF

       AFTER FIELD lsv04
         IF NOT cl_null(g_lsv[l_ac].lsv04) THEN
            IF g_lsv[l_ac].lsv04 < 0 THEN
                CALL cl_err("","alm-808",0)
                NEXT FIELD lsv04
             END IF
         END IF

       AFTER FIELD lsv05
         IF NOT cl_null(g_lsv[l_ac].lsv05) THEN
            IF g_lsv[l_ac].lsv05 < 0 THEN
                CALL cl_err("","alm-808",0)
                NEXT FIELD lsv05
             END IF
         END IF

        BEFORE DELETE
           IF NOT cl_null(g_lsv_t.lsv02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lsv_file
               WHERE lsv01 = g_lsu.lsu01
                 AND lsv00 = g_lsu.lsu00     #FUN-C60089 add
                 AND lsv02 = g_lsv_t.lsv02
                 AND lsv03 = g_lsv_t.lsv03  
                 AND lsv06 = g_plant
                 AND lsv07 = g_lsu.lsu12
                 AND lsv08 = g_lsu.lsu02     #CHI-C80047 add
                 AND lsvplant = g_plant   
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lsv_file","","",SQLCA.sqlcode,"","",1)
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
              LET g_lsv[l_ac].* = g_lsv_t.*
              CLOSE t590_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lsv[l_ac].lsv02,-263,1)
              LET g_lsv[l_ac].* = g_lsv_t.*
           ELSE
              IF g_argv1 <> '1' THEN  
                 UPDATE lsv_file SET lsv02=g_lsv[l_ac].lsv02,
                                     lsv03=g_lsv[l_ac].lsv03,   #FUN-C60089 add
                                     lsv04=g_lsv[l_ac].lsv04,
                                     lsv05=g_lsv[l_ac].lsv05
                  WHERE lsv01=g_lsu.lsu01
                    AND lsv00 = g_lsu.lsu00    #FUN-C60089 add
                    AND lsv02 = g_lsv_t.lsv02
                    AND lsv03 = g_lsv_t.lsv03    
                    AND lsv06 = g_lsu.lsu11 
                    AND lsv07 = g_lsu.lsu12     
                    AND lsv08 = g_lsu.lsu02    #CHI-C80047 add
                    AND lsvplant = g_plant     #FUN-C60089 add
              ELSE     
                 UPDATE lsv_file SET lsv02=g_lsv[l_ac].lsv02,
                                     lsv03=g_lsv[l_ac].lsv03,  #FUN-C60089 add
                                     lsv04=g_lsv[l_ac].lsv04,
                                     lsv05=g_lsv[l_ac].lsv05
                  WHERE lsv01=g_lsu.lsu01
                    AND lsv00 = g_lsu.lsu00     #FUN-C60089 add
                    AND lsv02 = g_lsv_t.lsv02  
                    AND lsv03 = g_lsv_t.lsv03
                    AND lsv06 = g_lsu.lsu11
                    AND lsv07 = g_lsu.lsu12    
                    AND lsv08 = g_lsu.lsu02     #CHI-C80047 add
                    AND lsvplant = g_plant      #FUN-C60089 add
              END IF   
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lsv_file",g_lsu.lsu01,g_lsv_t.lsv02,SQLCA.sqlcode,"","",1)
                 LET g_lsv[l_ac].* = g_lsv_t.*
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
                 LET g_lsv[l_ac].* = g_lsv_t.*
              END IF
              CLOSE t590_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE t590_bcl
           COMMIT WORK

        ON ACTION CONTROLO
           IF INFIELD(lsv02) AND l_ac > 1 THEN
              LET g_lsv[l_ac].* = g_lsv[l_ac-1].*
              LET g_lsv[l_ac].lsv02 = g_rec_b + 1
              NEXT FIELD lsv02
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
    DISPLAY BY NAME g_lsu.lsucrat,g_lsu.lsumodu,g_lsu.lsudate

    CLOSE t590_bcl
    COMMIT WORK

END FUNCTION

FUNCTION t590_delall()

    LET g_flag = 'Y'   
    SELECT COUNT(*) INTO g_cnt FROM lsv_file
     WHERE lsv01 = g_lsu.lsu01
       AND lsv00 = g_lsu.lsu00   #FUN-C60089 add
       AND lsv06 = g_lsu.lsu11
       AND lsv07 = g_lsu.lsu12
       AND lsv08 = g_lsu.lsu02   #CHI-C80047 add
       AND lsvplant = g_plant    #FUN-C60089 add
    IF g_cnt = 0 THEN
       SELECT COUNT(*) INTO g_cnt FROM lsw_file
        WHERE lsw01 = g_lsu.lsu01
          AND lsw00 = g_lsu.lsu00    #FUN-C60089 add
          AND lsw03 = g_lsu.lsu11
          AND lsw04 = g_lsu.lsu12
          AND lsw05 = g_lsu.lsu02    #CHI-C80047 add
          AND lswplant = g_plant     #FUN-C60089 add
    END IF
    IF g_cnt = 0 THEN
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM lsu_file WHERE lsu00 = g_lsu.lsu00 AND lsu01 = g_lsu.lsu01 AND lsu12 = g_lsu.lsu12    #FUN-C60089 add lsu00
                              AND lsu02 = g_lsu.lsu02            #CHI-C80047 add
                              AND lsu11 = g_lsu.lsu11 AND lsuplant = g_plant   
       DELETE FROM lsv_file WHERE lsv00 = g_lsu.lsu00 AND lsv01 = g_lsu.lsu01 AND lsv06 = g_lsu.lsu11    #FUN-C60089 add lsv00
                              AND lsv08 = g_lsu.lsu02    #CHI-C80047 add
                              AND lsv07 = g_lsu.lsu12 AND lsvplant = g_plant
       DELETE FROM lsw_file WHERE lsw00 = g_lsu.lsu00 AND lsw01 = g_lsu.lsu01 AND lsw03 = g_lsu.lsu11    #FUN-C60089 add lsw00 
                              AND lsw05 = g_lsu.lsu02    #CHI-C80047 add
                              AND lsw04 = g_lsu.lsu12 AND lswplant = g_plant
      #DELETE FROM lsz_file WHERE lsz01 = g_lsu.lsu01 AND lsz02 = '1' AND lsz11 = g_lsu.lsu11 AND lsz12 = g_lsu.lsu12 AND lszplant = g_plant  #FUN-C60089 mark
       DELETE FROM lsz_file WHERE lsz01 = g_lsu.lsu01 AND lsz02 = g_lsz02                            #FUN-C60089 add 
                             AND lsz11 = g_lsu.lsu11 AND lsz12 = g_lsu.lsu12 AND lszplant = g_plant  #FUN-C60089 add
                             AND lsz13 = g_lsu.lsu02    #CHI-C80047 add
       LET g_flag = 'N'    
    END IF

END FUNCTION

FUNCTION t590_b1()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1,
    l_cnt           LIKE type_file.num10

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    IF cl_null(g_lsu.lsu01) THEN
       RETURN
    END IF

    IF g_lsu.lsuacti ='N' THEN
       CALL cl_err(g_lsu.lsu01,'mfg1000',0)
       RETURN
    END IF
    IF g_lsu.lsu06 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_lsu.lsu06 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF

    IF g_plant <> g_lsu.lsu11 THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    LET g_forupd_sql =
        "SELECT lsw02,'' FROM lsw_file ",
        " WHERE lsw01 = '",g_lsu.lsu01,"' ", 
        "   AND lsw00 = '",g_lsu.lsu00,"' ",  #FUN-C60089 add
        "   AND lsw03 = '",g_lsu.lsu11,"' ",
        "   AND lsw04 = '",g_lsu.lsu12,"' ",
        "   AND lsw05 = '",g_lsu.lsu02,"' ",  #CHI-C80047 add
        "   AND lsw02 =? ",
        "   AND lswplant = '",g_plant,"' ",   #FUN-C60089 add
        " ORDER BY lsw02 ",
        "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t590_bcl2 CURSOR FROM g_forupd_sql

    INPUT ARRAY g_lsw WITHOUT DEFAULTS FROM s_lsw.*
          ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

    BEFORE INPUT
       IF g_rec_b1 != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF

    BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'
        LET l_n  = ARR_COUNT()
        IF g_rec_b1>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_lsw_t.* = g_lsw[l_ac].*
           OPEN t590_bcl2 USING  g_lsw[l_ac].lsw02
           IF STATUS THEN
              CALL cl_err("OPEN t590_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE
              FETCH t590_bcl2 INTO g_lsw[l_ac].*
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_lsw_t.lsw02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
              SELECT lpx02 INTO g_lsw[l_ac].lpx02_1
                FROM lpx_file
               WHERE lpx01 =g_lsw[l_ac].lsw02
           END IF
           CALL cl_show_fld_cont()
           CALL t590_set_entry_b1(p_cmd)
        END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET p_cmd='a'
           LET l_n = ARR_COUNT()
           INITIALIZE g_lsw[l_ac].* TO NULL
           LET g_lsw_t.* = g_lsw[l_ac].*
           LET g_lsw_o.* = g_lsw[l_ac].*
           CALL t590_set_entry_b1(p_cmd)
           NEXT FIELD lsw02

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO lsw_file(lswplant,lswlegal,lsw00,lsw01,lsw02,lsw03,lsw04,lsw05)     #FUN-C60089 add lsw00   #CHI-C80047 add lsw05
           VALUES(g_plant,g_legal,g_lsu.lsu00,g_lsu.lsu01,    #FUN-C60089 add lsu00
                  g_lsw[l_ac].lsw02,g_plant,g_lsu.lsu12,g_lsu.lsu02)                       #CHI-C80047 add lsu02    
           IF SQLCA.sqlcode THEN 
              CALL cl_err3("ins","lsw_file",g_lsu.lsu01,g_lsw[l_ac].lsw02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b1=g_rec_b1+1     
              DISPLAY g_rec_b1 TO FORMONLY.cn2  
           END IF

        AFTER FIELD lsw02
           IF NOT cl_null(g_lsw[l_ac].lsw02) THEN
              IF g_lsw[l_ac].lsw02 != g_lsw_t.lsw02
                 OR g_lsw_t.lsw02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM lsw_file
                  WHERE lsw01 = g_lsu.lsu01
                    AND lsw00 = g_lsu.lsu00      #FUN-C60089 add
                    AND lsw02 = g_lsw[l_ac].lsw02
                    AND lsw03 = g_lsu.lsu11
                    AND lsw04 = g_lsu.lsu12 
                    AND lsw05 = g_lsu.lsu02      #CHI-C80047 add
                    AND lswplant = g_plant       #FUN-C60089 add
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lsw[l_ac].lsw02 = g_lsw_t.lsw02
                    NEXT FIELD lsw02
                 END IF
                 CALL t590_lsw02(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_lsw[l_ac].lsw02,g_errno,0)
                    NEXT FIELD lsw02
                 END IF
              END IF
           END IF

        BEFORE DELETE
           IF NOT cl_null(g_lsw_t.lsw02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lsw_file
               WHERE lsw01 = g_lsu.lsu01
                 AND lsw00 = g_lsu.lsu00     #FUN-C60089 add
                 AND lsw02 = g_lsw_t.lsw02
                 AND lsw03 = g_lsu.lsu11
                 AND lsw04 = g_lsu.lsu12
                 AND lsw05 = g_lsu.lsu02     #CHI-C80047 add
                 AND lswplant = g_plant      #FUN-C60089 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lsw_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
              DISPLAY g_rec_b1 TO FORMONLY.cn2
           END IF
           COMMIT WORK

     ON ROW CHANGE
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_lsw[l_ac].* = g_lsw_t.*
           CLOSE t590_bcl2
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_lsw[l_ac].lsw02,-263,0)
           LET g_lsw[l_ac].* = g_lsw_t.*
        ELSE
           UPDATE lsw_file
              SET lsw02 =g_lsw[l_ac].lsw02 ,
                  lswplant = g_plant,
                  lswlegal = g_legal
            WHERE lsw01=g_lsu.lsu01
              AND lsw00 = g_lsu.lsu00   #FUN-C60089 add
              AND lsw02=g_lsw_t.lsw02
              AND lsw03 = g_lsu.lsu11
              AND lsw04 = g_lsu.lsu12
              AND lsw05 = g_lsu.lsu02   #CHI-C80047 add
              AND lswplant = g_plant    #FUN-C60089 add
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","lsw_file",g_lsw_t.lsw02,"",SQLCA.sqlcode,"","",1) 
              LET g_lsw[l_ac].* = g_lsw_t.*
           ELSE
              COMMIT WORK
           END IF
        END IF

     AFTER ROW
        LET l_ac = ARR_CURR()
        LET l_ac_t = l_ac

        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_lsw[l_ac].* = g_lsw_t.*
           END IF
           CLOSE t590_bcl2
           ROLLBACK WORK
           EXIT INPUT
        END IF
        CLOSE t590_bcl2
        COMMIT WORK

     ON ACTION controlp
        CASE
           WHEN INFIELD(lsw02)  #券類型編號
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_lpx01_2"   
              LET g_qryparam.default1 = g_lsw[l_ac].lsw02
              LET g_qryparam.arg1 =g_plant  
              CALL cl_create_qry() RETURNING g_lsw[l_ac].lsw02
              DISPLAY BY NAME g_lsw[l_ac].lsw02
              CALL t590_lsw02('d')
              NEXT FIELD lsw02
            OTHERWISE EXIT CASE
         END CASE

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

      ON ACTION help
         CALL cl_show_help()


     END INPUT


    CLOSE t590_bcl2
    COMMIT WORK
    CALL t590_delall()

END FUNCTION

FUNCTION t590_lsw02(p_cmd)
    DEFINE p_cmd       LIKE type_file.chr1
    DEFINE p_code      LIKE type_file.chr1
    DEFINE l_lpx02     LIKE lpx_file.lpx02
    DEFINE l_lpx15     LIKE lpx_file.lpx15
    DEFINE l_lpxacti   LIKE lpx_file.lpxacti
    LET g_errno = ' '
    SELECT lpx02,lpx15,lpxacti INTO l_lpx02,l_lpx15,l_lpxacti
      FROM lpx_file WHERE lpx01 = g_lsw[l_ac].lsw02
                      AND lpxacti='Y'
    CASE WHEN SQLCA.SQLCODE =100 LET g_errno = 'alm-758'    
         WHEN l_lpx15 <> 'Y'     LET g_errno = '9029'
         OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'        END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_lsw[l_ac].lpx02_1 = l_lpx02
       DISPLAY BY NAME g_lsw[l_ac].lpx02_1
    END IF
END FUNCTION

FUNCTION t590_temp(p_cmd,p_plant,p_legal)
DEFINE l_sql         STRING
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_n           LIKE type_file.num5
DEFINE p_cmd         LIKE type_file.chr1
DEFINE p_plant       LIKE lsu_file.lsuplant
DEFINE p_legal       LIKE lsu_file.lsulegal
DEFINE l_lsu12       LIKE lsu_file.lsu12

   LET g_flag2 = 'Y'
   IF cl_null(g_lsu.lsu01) THEN
      LET g_flag2 = 'N'  #FUN-C60089 add
      RETURN
      CALL cl_err('','-400',0)
   END IF
  
  #CHI-C80047 mark START 
  #SELECT MAX(lsu12) INTO g_lsu.lsu12 FROM lsu_file
  #  WHERE lsu01 = g_lsu.lsu01 
  #    AND lsu00 = g_lsu.lsu00   #FUN-C60089 add
  #    AND lsu02 = g_lsu.lsu02   #CHI-C80047 add
  #    AND lsu11 = g_lsu.lsu11
  #    AND lsuplant = g_plant    #FUN-C60089 add

  #IF cl_null(g_lsu.lsu12) THEN
  #  LET g_lsu.lsu12 = 0
  #END IF

  #SELECT * INTO g_lsu.* FROM lsu_file
  # WHERE lsu01 = g_lsu.lsu01 
  #   AND lsu00 = g_lsu.lsu00    #FUN-C60089 add
  #   AND lsu02 = g_lsu.lsu02    #CHI-C80047 add
  #  #AND lsu12 = g_lsu.lsu12    #CHI-C80047 mark 
  #   AND lsu12 = l_lsu12        #CHI-C80047 add
  #   AND lsu11 = g_plant 
  #   AND lsuplant = g_plant
  #CHI-C80047 mark END
  #CHI-C80047 add START
   IF p_cmd = 'a' THEN
      LET l_lsu12 = g_lsu.lsu12 - 1  
   ELSE
      LET l_lsu12 = g_lsu.lsu12 
   END IF
   IF cl_null(l_lsu12) OR l_lsu12 < 1 THEN
      LET l_lsu12  = 0
   END IF
  #CHI-C80047 add eND
   LET g_lsu.lsu06 = 'N'
 
   DROP TABLE lsu_temp
   SELECT * FROM lsu_file WHERE 1 = 0 INTO TEMP lsu_temp
   DROP TABLE lsv_temp
   SELECT * FROM lsv_file WHERE 1 = 0 INTO TEMP lsv_temp
   DROP TABLE lsw_temp
   SELECT * FROM lsw_file WHERE 1 = 0 INTO TEMP lsw_temp
   DROP TABLE lsz_temp
   SELECT * FROM lsz_file WHERE 1 = 0 INTO TEMP lsz_temp

   LET g_success = 'Y'

   DELETE FROM lsu_temp
   DELETE FROM lsv_temp
   DELETE FROM lsw_temp
   DELETE FROM lsz_temp

   INSERT INTO lsu_temp SELECT lsu_file.* FROM lsu_file
                         WHERE lsu01 = g_lsu.lsu01
                           AND lsu00 = g_lsu.lsu00   #FUN-C60089 add
                           AND lsu02 = g_lsu.lsu02   #CHI-C80047 add
                           AND lsu11 = g_lsu.lsu11
                          #AND lsu12 = g_lsu.lsu12   #CHI-C80047 mark
                           AND lsu12 = l_lsu12       #CHI-C80047 add
                           AND lsuplant = g_plant

   INSERT INTO lsv_temp SELECT lsv_file.* FROM lsv_file
                         WHERE lsv01 = g_lsu.lsu01 
                           AND lsv00 = g_lsu.lsu00    #FUN-C60089 add
                           AND lsv06 = g_lsu.lsu11
                          #AND lsv07 = g_lsu.lsu12    #CHI-C80047 mark
                           AND lsv07 = l_lsu12        #CHI-C80047 add
                           AND lsv08 = g_lsu.lsu02    #CHI-C80047 add
                           AND lsvplant = g_plant

   INSERT INTO lsw_temp SELECT lsw_file.* FROM lsw_file
                         WHERE lsw01 = g_lsu.lsu01 
                           AND lsw00 = g_lsu.lsu00    #FUN-C60089 add
                           AND lsw03 = g_lsu.lsu11
                          #AND lsw04 = g_lsu.lsu12    #CHI-C80047 mark
                           AND lsw04 = l_lsu12        #CHI-C80047 add 
                           AND lsw05 = g_lsu.lsu02    #CHI-C80047 add
                           AND lswplant = g_plant

   INSERT INTO lsz_temp SELECT lsz_file.* FROM lsz_file
                         WHERE lsz01 = g_lsu.lsu01 
                          #AND lsz02 = '1'       #FUN-C60089 mark
                           AND lsz02 = g_lsz02   #FUN-C60089 add
                           AND lsz11 = g_lsu.lsu11 
                          #AND lsz12 = g_lsu.lsu12    #CHI-C80047 mark
                           AND lsz12 = l_lsu12        #CHI-C80047 add
                           AND lsz13 = g_lsu.lsu02    #CHI-C80047 add
                           AND lszplant = g_lsu.lsuplant   #FUN-C60089 add

   IF p_cmd = 'a' THEN   #當為新增的時候才將版本號+1
     #CHI-C80047 mark START
     #UPDATE lsu_temp SET lsu12 = g_lsu.lsu12 + 1

     #UPDATE lsv_temp SET lsv07 = g_lsu.lsu12  + 1

     #UPDATE lsw_temp SET lsw04 = g_lsu.lsu12 + 1

     #UPDATE lsz_temp SET lsz12 = g_lsu.lsu12 + 1
     #CHI-C80047 mark END
     #CHI-C80047 add START
      UPDATE lsu_temp SET lsu12 = g_lsu.lsu12 

      UPDATE lsv_temp SET lsv07 = g_lsu.lsu12 

      UPDATE lsw_temp SET lsw04 = g_lsu.lsu12 

      UPDATE lsz_temp SET lsz12 = g_lsu.lsu12 
     #CHI-C80047 add END
   ELSE                 #當確認時只將plantCode&legalCode update
      UPDATE lsu_temp SET lsu06 = 'Y',
                          lsuplant = p_plant,
                          lsulegal = p_legal 

      UPDATE lsv_temp SET lsvplant = p_plant, 
                          lsvlegal = p_legal 

      UPDATE lsw_temp SET lswplant = p_plant,
                          lswlegal = p_legal

      UPDATE lsz_temp SET lszplant = p_plant,
                          lszlegal = p_legal
      
   END IF

   IF p_cmd <> 'a' THEN   #當為新增時不將單頭新增,只display畫面上,等user點選確認後才新增
 
      LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'lsu_file'),   #單頭
                  " SELECT * FROM lsu_temp"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
      PREPARE trans_ins_lsu FROM l_sql
      EXECUTE trans_ins_lsu
      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','INSERT INTO lsu_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
      END IF
   END IF

   LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'lsv_file'),   #單頭 
               " SELECT * FROM lsv_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql 
   CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql 
   PREPARE trans_ins_lsv FROM l_sql 
   EXECUTE trans_ins_lsv
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('','','INSERT INTO lsv_file:',SQLCA.sqlcode,1)
     LET g_success = 'N' 
   END IF 

   LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'lsw_file'),   #單頭
               " SELECT * FROM lsw_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
   PREPARE trans_ins_lsw FROM l_sql
   EXECUTE trans_ins_lsw
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('','','INSERT INTO lsw_file:',SQLCA.sqlcode,1)
     LET g_success = 'N'
   END IF

   LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'lsz_file'),   #單頭
               " SELECT * FROM lsz_temp"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, g_plant) RETURNING l_sql
   PREPARE trans_ins_lsz FROM l_sql
   EXECUTE trans_ins_lsz
   IF SQLCA.sqlcode THEN
     CALL s_errmsg('','','INSERT INTO lsz_file:',SQLCA.sqlcode,1)
     LET g_success = 'N'
   END IF

   DROP TABLE lsu_temp
   DROP TABLE lsv_temp
   DROP TABLE lsw_temp
   DROP TABLE lsz_temp
 
   IF p_cmd = 'a' THEN
     #LET g_lsu.lsu12 = g_lsu.lsu12 + 1  #CHI-C80047 mark
     
      DISPLAY BY NAME g_lsu.lsu11,g_lsu.lsu00,g_lsu.lsu01,g_lsu.lsu12,g_lsu.lsu02,
                      g_lsu.lsu03,g_lsu.lsu04,g_lsu.lsu05,
                      g_lsu.lsu13,g_lsu.lsu14,
                      g_lsu.lsu10,g_lsu.lsu06,g_lsu.lsu07,g_lsu.lsu08,g_lsu.lsu09,
                      g_lsu.lsuplant,g_lsu.lsulegal,
                      g_lsu.lsuuser,g_lsu.lsucrat,g_lsu.lsumodu,
                      g_lsu.lsugrup,g_lsu.lsudate,g_lsu.lsuacti,g_lsu.lsuoriu,g_lsu.lsuorig
   END IF


END FUNCTION

FUNCTION t590_refresh()
      DISPLAY ARRAY g_lsv TO s_lsv.* ATTRIBUTE(COUNT=g_rec_b)
        BEFORE DISPLAY
           EXIT DISPLAY
      END DISPLAY

      DISPLAY ARRAY g_lsw TO s_lsw.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
           EXIT DISPLAY
      END DISPLAY

END FUNCTION

FUNCTION t590_r()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lsu.lsu01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   SELECT * INTO g_lsu.* FROM lsu_file
    WHERE lsu01=g_lsu.lsu01
      AND lsu00 = g_lsu.lsu00   #FUN-C60089 add
      AND lsu02 = g_lsu.lsu02   #CHI-C80047 add
      AND lsu12=g_lsu.lsu12
      AND lsu11=g_lsu.lsu11
      AND lsuplant = g_plant    #FUN-C60089 add
   IF g_lsu.lsuacti ='N' THEN
      CALL cl_err(g_lsu.lsu01,'mfg1000',0)
      RETURN
   END IF
   IF g_lsu.lsu06 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_lsu.lsu06 = 'X' THEN CALL cl_err('',9028,0) RETURN END IF

   BEGIN WORK

   OPEN t590_cl USING g_lsu.lsu01,g_lsu.lsu11,g_lsu.lsu12,g_lsu.lsu02  #CHI-C80047 add lsu02
   IF STATUS THEN
      CALL cl_err("OPEN t590_cl:", STATUS, 1)
      CLOSE t590_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t590_cl INTO g_lsu.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lsu.lsu01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   CALL t590_show()

   IF cl_delh(0,0) THEN
      DELETE FROM lsu_file WHERE lsu00 = g_lsu.lsu00 AND lsu01 = g_lsu.lsu01 AND lsu12 = g_lsu.lsu12   #FUN-C60089 add lsu00
                             AND lsu11 = g_lsu.lsu11 AND lsuplant = g_plant  AND lsu02 = g_lsu.lsu02   #CHI-C80047 add lsu02
      DELETE FROM lsv_file WHERE lsv00 = g_lsu.lsu00 AND lsv01 = g_lsu.lsu01 AND lsv06 = g_lsu.lsu11   #FUN-C60089 add lsv00
                             AND lsv07 = g_lsu.lsu12 AND lsvplant = g_plant  AND lsv08 = g_lsu.lsu02   #CHI-C80047 add lsv08
      DELETE FROM lsw_file WHERE lsw00 = g_lsu.lsu00 AND lsw01 = g_lsu.lsu01 AND lsw03 = g_lsu.lsu11   #FUN-C60089 add lsw00 
                             AND lsw04 = g_lsu.lsu12 AND lswplant = g_plant  AND lsw05 = g_lsu.lsu02   #CHI-C80047 add lsw05
     #DELETE FROM lsz_file WHERE lsz01 = g_lsu.lsu01 AND lsz02 = '1' AND lsz11 = g_lsu.lsu11 AND lsz12 = g_lsu.lsu12 AND lszplant = g_plant  #FUN-C60089 mark
      DELETE FROM lsz_file WHERE lsz01 = g_lsu.lsu01 AND lsz02 = g_lsz02 AND lsz11 = g_lsu.lsu11 AND lsz12 = g_lsu.lsu12 AND lszplant = g_plant  #FUN-C60089 add
                             AND lsz13 = g_lsu.lsu02   #CHI-C80047 add
      CLEAR FORM
      CALL g_lsv.clear()
      CALL g_lsw.clear()
      OPEN t590_count
       IF STATUS THEN
          CLOSE t590_cs
          CLOSE t590_count
          COMMIT WORK
          RETURN
       END IF
      FETCH t590_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t590_cs
          CLOSE t590_count
          COMMIT WORK
          RETURN
       END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t590_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t590_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t590_fetch('/')
      END IF
   END IF

   CLOSE t590_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lsu.lsu01,'D')

END FUNCTION

FUNCTION t590_u()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lsu.lsu01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lsu.* FROM lsu_file
    WHERE lsu01 = g_lsu.lsu01
      AND lsu00 = g_lsu.lsu00   #FUN-C60089 add
      AND lsu02 = g_lsu.lsu02   #CHI-C80047 add
      AND lsu11 = g_lsu.lsu11
      AND lsu12 = g_lsu.lsu12
      AND lsuplant = g_plant    #FUN-C60089 add

   IF g_lsu.lsuacti ='N' THEN
      CALL cl_err(g_lsu.lsu01,'mfg1000',0)
      RETURN
   END IF

   IF g_lsu.lsu06 = 'Y' OR g_lsu.lsu06 ='X' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF

   IF g_plant <> g_lsu.lsu11 THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lsu01_t = g_lsu.lsu01
   BEGIN WORK

   OPEN t590_cl USING g_lsu.lsu01,g_lsu.lsu11,g_lsu.lsu12,g_lsu.lsu02   #CHI-C80047 add lsu02
   IF STATUS THEN
      CALL cl_err("OPEN t590_cl:", STATUS, 1)
      CLOSE t590_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t590_cl INTO g_lsu.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsu.lsu01,SQLCA.sqlcode,0)
       CLOSE t590_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL t590_show()

   WHILE TRUE
      LET g_lsu01_t = g_lsu.lsu01
      LET g_lsu02_t = g_lsu.lsu02    #CHI-C80047 add 
      LET g_lsu_t.* = g_lsu.*   #CHI-C80047 add
      LET g_lsu_o.* = g_lsu.*
      LET g_lsu.lsumodu=g_user
      LET g_lsu.lsudate=g_today
      CALL t590_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lsu.*=g_lsu_t.*
         CALL t590_show()
         CALL cl_err('','9001',0)
         ROLLBACK WORK 
         EXIT WHILE
      END IF

      IF g_lsu.lsu01 != g_lsu01_t THEN
         UPDATE lsv_file SET lsv01 = g_lsu.lsu01
          WHERE lsv01 = g_lsu01_t
            AND lsv00 = g_lsu.lsu00    #FUN-C60089 add
            AND lsv06 = g_lsu.lsu11      
            AND lsv07 = g_lsu.lsu12
            AND lsv08 = g_lsu02_t      #CHI-C80047 add
            AND lsvplant = g_plant     #FUN-C60089 add
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lsu_file",g_lsu01_t,"",SQLCA.sqlcode,"","lss",1)
            CONTINUE WHILE
         END IF
      END IF

     #CHI-C80047 add START
      IF g_lsu.lsu02 != g_lsu02_t THEN
         UPDATE lsv_file SET lsv08 = g_lsu.lsu02
          WHERE lsv01 = g_lsu01_t
            AND lsv00 = g_lsu.lsu00    
            AND lsv06 = g_lsu.lsu11
            AND lsv07 = g_lsu.lsu12
            AND lsv08 = g_lsu_t.lsu02
            AND lsvplant = g_plant   
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lsu_file",g_lsu01_t,"",SQLCA.sqlcode,"","lss",1)
            CONTINUE WHILE
         END IF
         UPDATE lsw_file
            SET lsw05 = g_lsu.lsu02
          WHERE lsw00 = g_lsu.lsu00
            AND lsw01 = g_lsu01_t   
            AND lsw03 = g_lsu.lsu11
            AND lsw04 = g_lsu.lsu12
            AND lsw05 = g_lsu02_t   
            AND lswplant = g_plant  
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lsu_file",g_lsu01_t,"",SQLCA.sqlcode,"","lss",1)
            CONTINUE WHILE
         END IF
         UPDATE lsz_file
            SET lsz13 = g_lsu.lsu02
          WHERE lsz01 = g_lsu01_t
            AND lsz02 = g_lsz02
            AND lsz11 = g_lsu.lsu11
            AND lsz12 = g_lsu.lsu12
            AND lsz13 = g_lsu02_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lsu_file",g_lsu01_t,"",SQLCA.sqlcode,"","lss",1)
            CONTINUE WHILE
         END IF

      END IF
     #CHI-C80047 add END

      UPDATE lsu_file SET lsu_file.* = g_lsu.*
       WHERE lsu01 = g_lsu01_t AND lsu11 = g_lsu_t.lsu11
         AND lsu00 = g_lsu.lsu00   #FUN-C60089 add
         AND lsu02 = g_lsu02_t     #CHI-C80047 add
         AND lsu12 = g_lsu_t.lsu12
         AND lsuplant = g_plant    #FUN-C60089 add

      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lsu_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE

   CLOSE t590_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lsu.lsu01,'U')

END FUNCTION

FUNCTION t590_x()

   LET g_success = 'Y'  
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lsu.lsu01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lsu.lsu06 != 'N' THEN CALL cl_err('',9065,0) RETURN END IF

   IF g_plant <> g_lsu.lsu11 THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   BEGIN WORK

   OPEN t590_cl USING g_lsu.lsu01,g_lsu.lsu11,g_lsu.lsu12,g_lsu.lsu02  #CHI-C80047 add lsu02
   IF STATUS THEN
      CALL cl_err("OPEN t590_cl:", STATUS, 1)
      CLOSE t590_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t590_cl INTO g_lsu.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lsu.lsu01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CALL t590_show()

   IF cl_exp(0,0,g_lsu.lsuacti) THEN
      LET g_chr=g_lsu.lsuacti
      IF g_lsu.lsuacti='Y' THEN
         LET g_lsu.lsuacti='N'
      ELSE
         LET g_lsu.lsuacti='Y'
      END IF

      UPDATE lsu_file SET lsuacti=g_lsu.lsuacti,
                          lsumodu=g_user,
                          lsudate=g_today
       WHERE lsu01 = g_lsu.lsu01
         AND lsu00 = g_lsu.lsu00   #FUN-C60089 add
         AND lsu02 = g_lsu.lsu02   #CHI-C80047 add
         AND lsu11 = g_lsu.lsu11
         AND lsu12 = g_lsu.lsu12
         AND lsuplant = g_plant    #FUN-C60089 add
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lsu_file",g_lsu.lsu01,"",SQLCA.sqlcode,"","",1)
         LET g_lsu.lsuacti=g_chr
      END IF
   END IF

   CLOSE t590_cl

   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lsu.lsu01,'V')
   ELSE
      ROLLBACK WORK
   END IF

   SELECT lsuacti,lsumodu,lsudate,lsucrat
     INTO g_lsu.lsuacti,g_lsu.lsumodu,g_lsu.lsudate,g_lsu.lsucrat
     FROM lsu_file
    WHERE lsu01 = g_lsu.lsu01
      AND lsu00 = g_lsu.lsu00   #FUN-C60089 add
      AND lsu02 = g_lsu.lsu02   #CHI-C80047 add
      AND lsu11 = g_lsu.lsu11
      AND lsu12 = g_lsu.lsu12
      AND lsuplant = g_plant    #FUN-C60089 add
   DISPLAY BY NAME g_lsu.lsuacti,g_lsu.lsumodu,g_lsu.lsudate,g_lsu.lsucrat
   CALL t590_field_pic()
END FUNCTION

FUNCTION t590_y()

   DEFINE l_n LIKE type_file.num5    

   LET g_success = 'Y'
   IF g_lsu.lsu01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#CHI-C30107 ------------- add ------------- begin
   IF g_lsu.lsu06 !='N' THEN
      CALL cl_err('','8888',0)
      RETURN
   END IF
   IF g_lsu.lsuacti = 'N' THEN
      CALL cl_err('','9028',0)
      RETURN
   END IF

   IF g_plant <> g_lsu.lsu11 THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   SELECT * INTO g_lsu.* FROM lsu_file 
                        WHERE lsu01 = g_lsu.lsu01
                          AND lsu00 = g_lsu.lsu00   #FUN-C60089 add
                          AND lsu02 = g_lsu.lsu02   #CHI-C80047 add
                          AND lsu11 = g_lsu.lsu11
                          AND lsu12 = g_lsu.lsu12
                          AND lsuplant = g_plant    #FUN-C60089 add
#CHI-C30107 ------------- add ------------- end
   IF g_lsu.lsu06 !='N' THEN
      CALL cl_err('','8888',0)
      RETURN
   END IF
   IF g_lsu.lsuacti = 'N' THEN
      CALL cl_err('','9028',0)
      RETURN
   END IF

   IF g_plant <> g_lsu.lsu11 THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF

   SELECT COUNT(*) INTO l_n   #判斷生效營運中心是否為空
     FROM lsz_file
    WHERE lsz01 = g_lsu.lsu01
      AND lszplant = g_lsu.lsuplant
     #AND lsz02 = '1'       #FUN-C60089 mark
      AND lsz02 = g_lsz02   #FUN-C60089 add
      AND lsz10 = 'Y'
      AND lsz12 = g_lsu.lsu12
      AND lsz11 = g_lsu.lsu11
      AND lsz13 = g_lsu.lsu02   #CHI-C80047 add
   IF l_n = 0 THEN
      CALL cl_err('','alm1367',0)
      RETURN
   END IF
 
   CALL t590_chk_lsz03()   #判斷生效營運中心是否與卡生效營運中心符合


   IF g_success = 'N' THEN
      RETURN 
   END IF
  

#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK

   OPEN t590_cl USING g_lsu.lsu01,g_lsu.lsu11,g_lsu.lsu12,g_lsu.lsu02   #CHI-C80047 add lsu02
   IF STATUS THEN
       CALL cl_err("OPEN t590_cl:", STATUS, 1)
       CLOSE t590_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t590_cl INTO g_lsu.*
    CALL t590_iss()  #確認同時將資料發佈到各營運中心
    IF g_success = 'N' THEN
       ROLLBACK WORK
    ELSE
       LET g_lsu.lsu06 = 'Y'
       LET g_lsu.lsu07=g_user
       LET g_lsu.lsu08=g_today
       UPDATE lsu_file SET lsu06 = g_lsu.lsu06,
                           lsu07 = g_lsu.lsu07,
                           lsu08 = g_lsu.lsu08
                        WHERE lsu01 = g_lsu.lsu01
                          AND lsu00 = g_lsu.lsu00  #FUN-C60089 add
                          AND lsu02 = g_lsu.lsu02  #CHI-C80047 add
                          AND lsu11 = g_lsu.lsu11  #FUN-C60089 add
                          AND lsu12 = g_lsu.lsu12
                          AND lsuplant = g_plant   #FUN-C60089 add
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","lsu_file",g_lsu.lsu01,"",SQLCA.sqlcode,"","",0)
          ROLLBACK WORK
          RETURN
       END IF
       CLOSE t590_cl
       COMMIT WORK
       DISPLAY BY NAME g_lsu.lsu06
       DISPLAY BY NAME g_lsu.lsu07
       DISPLAY BY NAME g_lsu.lsu08
       CALL t590_field_pic()
    END IF

END FUNCTION

FUNCTION t590_iss()
   DEFINE l_sql         STRING
   DEFINE l_plant       LIKE lsu_file.lsuplant
   DEFINE l_sql2        STRING 
   DEFINE l_legal       LIKE lsu_file.lsulegal
   DEFINE l_i           LIKE type_file.num5
   LET l_sql = " SELECT lsz03,lsz10 FROM lsz_file ",
               " WHERE lsz01 = '",g_lsu.lsu01,"' AND lsz12 = '",g_lsu.lsu12,"' ",
              #"   AND lsz02 = '1'  AND lsz11 = '",g_lsu.lsu11,"' "             #FUN-C60089 mark
               "   AND lsz02 = '",g_lsz02,"'  AND lsz11 = '",g_lsu.lsu11,"' ",  #FUN-C60089 add 
               "   AND lsz13 = '",g_lsu.lsu02,"' ",        #CHI-C80047 add
               "   AND lszplant = '",g_lsu.lsuplant,"' "   #FUN-C60089 add

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
      IF g_lsu.lsu11 = l_plant THEN   #與當前機構相同則不拋
   
      ELSE
#        CALL t590_temp('u',l_plant,l_legal) 
      END IF
      IF g_success = 'N' THEN RETURN END IF
 
   END FOR
   CALL t590_ins_lst()
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE 
      COMMIT WORK
   END IF
END FUNCTION

FUNCTION t590_ins_lst()
   DEFINE l_sql       STRING
   DEFINE l_plant     LIKE lsu_file.lsuplant
   DEFINE l_legal     LIKE lsu_file.lsulegal
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_lsu       RECORD LIKE lsu_file.*
   DEFINE l_lsv       RECORD LIKE lsv_file.*
   DEFINE l_lsw       RECORD LIKE lsw_file.*
   DEFINE l_lsz       RECORD LIKE lsz_file.*
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_lst       RECORD LIKE lst_file.*   #CHI-C80047 add
   FOR l_i = 1 TO g_cnt2
      
      IF cl_null(g_ary[l_i].plant) THEN CONTINUE FOR END IF
      LET l_plant = g_ary[l_i].plant
      SELECT * INTO l_lsu.* FROM lsu_file
         WHERE lsu01 = g_lsu.lsu01 
           AND lsu00 = g_lsu.lsu00   #FUN-C60089 add
           AND lsu02 = g_lsu.lsu02   #CHI-C80047 add
           AND lsu11 = g_lsu.lsu11 
           AND lsu12 = g_lsu.lsu12
           AND lsuplant = g_lsu.lsuplant

      SELECT azw02 INTO l_legal FROM azw_file
       WHERE azw01 = l_plant AND azwacti='Y'
      IF g_ary[l_i].acti = 'N' THEN   #若acti = 'N' 時,則將有效否欄位設定為'N' 
         LET l_lsu.lsu06 = 'Y'
         LET l_lsu.lsuacti = 'N'
      ELSE 
         LET l_lsu.lsu06 = 'Y'
         LET l_lsu.lsuacti = 'Y'
      END IF
      #將原有的資料刪除,新增全新資料
      LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant, 'lst_file'),
                  "   WHERE lst01 = '",g_lsu.lsu01,"' AND lst14 = '",g_lsu.lsu11,"'",
                  "     AND lst00 = '",g_lsu.lsu00,"' ",  #FUN-C60089 add
                  "     AND lst03 = '",g_lsu.lsu02,"' ",  #CHI-C80047 add
                  "     AND lstplant = '",l_plant,"'"
      PREPARE trans_del_lst FROM l_sql
      EXECUTE trans_del_lst
      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','DELETE lst_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOR
      END IF   
      LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant, 'lss_file'),
                  "   WHERE lss01 = '",g_lsu.lsu01,"' AND lss07 = '",g_lsu.lsu11,"'",
                  "     AND lss00 = '",g_lsu.lsu00,"' ",   #FUN-C60089 add
                  "     AND lss08 = '",g_lsu.lsu02,"' ",   #CHI-C80047 add
                  "     AND lssplant = '",l_plant,"'"
      PREPARE trans_del_lss FROM l_sql
      EXECUTE trans_del_lss
      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','DELETE lss_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOR 
      END IF
      LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant, 'lsr_file'),
                  "   WHERE lsr01 = '",g_lsu.lsu01,"' AND lsr03 = '",g_lsu.lsu11,"'",
                  "     AND lsr00 = '",g_lsu.lsu00,"' ",   #FUN-C60089 add
                  "     AND lsr04 = '",g_lsu.lsu02,"' ",   #CHI-C80047 add
                  "     AND lsrplant = '",l_plant,"'"
      PREPARE trans_del_lsr FROM l_sql 
      EXECUTE trans_del_lsr
      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','DELETE lsr_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOR 
      END IF  
      LET l_sql = "DELETE FROM ",cl_get_target_table(l_plant, 'lni_file'),
                  "   WHERE lni01 = '",g_lsu.lsu01,"' AND lni14 = '",g_lsu.lsu11,"'",
                 #"     AND lni02 = '1' AND lniplant = '",l_plant,"'"   #FUN-C60089 mark 
                  "     AND lni15 = '",g_lsu.lsu02,"' ",   #CHI-C80047 add
                  "     AND lni02 = '",g_lsz02,"' AND lniplant = '",l_plant,"'"   #FUN-C60089 add  
      PREPARE trans_del_lni FROM l_sql 
      EXECUTE trans_del_lni
      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','DELETE lni_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOR 
      END IF  
      #單頭  
     #CHI-C80047 mark START
     #LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'lst_file'),
     #            "        (lst00,lst01,lst03,lst04,lst05,lst06, ",
     #            "         lst09,lst10,lst11,lst12,lst13,lst14,lst15,lst16,lst17, ",
     #            "         lst18,lst19, ",
     #            "         lstacti,lstcrat,lstdate,lstgrup, ",
     #            "         lstlegal,lstmodu,lstorig,lstoriu,lstplant,lstuser ) ",
     #            " VALUES( '",l_lsu.lsu00,"', '",l_lsu.lsu01,"', '",l_lsu.lsu02,"',CAST('",l_lsu.lsu03,"' AS DATE), ",
     #            "         CAST('",l_lsu.lsu04,"' AS DATE) ,'",l_lsu.lsu05,"','",l_lsu.lsu06,"' , ",
     #            "         '",g_user,"','",g_today,"','",l_lsu.lsu09,"',",
     #            "         '",l_lsu.lsu10,"','",l_lsu.lsu11,"','",g_lsu.lsu12,"','Y','",g_today,"',",
     #            "         '",l_lsu.lsu13,"','",l_lsu.lsu14,"',  ",
     #            "         '",l_lsu.lsuacti,"','",l_lsu.lsucrat,"',",
     #            "         '', '",l_lsu.lsugrup,"', '",l_legal,"','",l_lsu.lsumodu,"', ",
     #            "         '",l_lsu.lsuorig,"', '",l_lsu.lsuoriu,"','",l_plant,"','",l_lsu.lsuuser,"')"
     #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
     #CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
     #PREPARE trans_ins_lst FROM l_sql
     #EXECUTE trans_ins_lst
     #CHI-C80047 mark END
     #CHI-C80047 add START
      LET l_lst.lst00    = l_lsu.lsu00
      LET l_lst.lst01    = l_lsu.lsu01
      LET l_lst.lst02    = NULL
      LET l_lst.lst03    = l_lsu.lsu02
      LET l_lst.lst04    = l_lsu.lsu03
      LET l_lst.lst05    = l_lsu.lsu04
      LET l_lst.lst06    = l_lsu.lsu05
      LET l_lst.lst07    = ' ' 
      LET l_lst.lst08    = ' '
      LET l_lst.lst09    = l_lsu.lsu06
      LET l_lst.lst10    = l_lsu.lsu07
      LET l_lst.lst11    = g_today
      LET l_lst.lst12    = l_lsu.lsu09
      LET l_lst.lst13    = l_lsu.lsu10
      LET l_lst.lst14    = l_lsu.lsu11
      LET l_lst.lst15    = l_lsu.lsu12
      LET l_lst.lst16    = 'Y'
      LET l_lst.lst17    = g_today
      LET l_lst.lst18    = l_lsu.lsu13
      LET l_lst.lst19    = l_lsu.lsu14
      LET l_lst.lstacti  = l_lsu.lsuacti
      LET l_lst.lstcrat  = l_lsu.lsucrat
      LET l_lst.lstdate  = l_lsu.lsudate
      LET l_lst.lstgrup  = l_lsu.lsugrup
      LET l_lst.lstmodu  = l_lsu.lsumodu
      LET l_lst.lstuser  = l_lsu.lsuuser
      LET l_lst.lstoriu  = l_lsu.lsuoriu
      LET l_lst.lstorig  = l_lsu.lsuorig
      LET l_lst.lstlegal = l_legal
      LET l_lst.lstplant = l_plant
      LET l_lst.lstpos   = '1'
      INSERT INTO lst_file VALUES (l_lst.*) 
     #CHI-C80047 add END

      IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','INSERT INTO lst_file:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOR 
      END IF
      #第一單身
      LET l_sql = " SELECT * FROM lsv_file ",
                  "    WHERE lsv01 = '",g_lsu.lsu01,"' ",
                  "      AND lsv00 = '",g_lsu.lsu00,"' ",     #FUN-C60089 add
                  "      AND lsv07 = '",g_lsu.lsu12,"' ",
                  "      AND lsv08 = '",g_lsu.lsu02,"' ",     #CHI-C80047 add
                  "      AND lsvplant = '",g_lsu.lsuplant,"' ",
                  "      AND lsv06 = '",g_lsu.lsu11,"'"
      PREPARE lsv_pre FROM l_sql
      DECLARE lsv_cs1 CURSOR FOR lsv_pre
      FOREACH lsv_cs1 INTO l_lsv.*
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'lss_file'),
                     "        (lss00,lss01,lss02,lss03,lss04,lss05,lss07,lsslegal,lssplant,lss08 )",   #FUN-C60089 lss00  #CHI-C80047 add lss08
                     " VALUES( '",l_lsv.lsv00,"', '",l_lsv.lsv01,"', '",l_lsv.lsv02,"', '",l_lsv.lsv03,"','",l_lsv.lsv04,"', ",   #FUN-C60089 add lsv00
                     "         '",l_lsv.lsv05,"', '",l_lsv.lsv06,"','",l_legal,"','",l_plant,"','",l_lsv.lsv08,"')"   #CHI-C80047 add lsv08
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE trans_ins_lss FROM l_sql
         EXECUTE trans_ins_lss
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lss_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH 
         END IF
      END FOREACH
      #第二單身
      LET l_sql = " SELECT * FROM lsw_file ",
                  "    WHERE lsw01 = '",g_lsu.lsu01,"' ",
                  "      AND lsw00 = '",g_lsu.lsu00,"' ",   #FUN-C60089 add
                  "      AND lsw03 = '",g_lsu.lsu11,"' ",
                  "      AND lsw04 = '",g_lsu.lsu12,"' ",
                  "      AND lsw05 = '",g_lsu.lsu02,"' ",   #CHI-C80047 add
                  "      AND lswplant = '",g_lsu.lsuplant,"' "

      PREPARE lsw_pre FROM l_sql
      DECLARE lsw_cs CURSOR FOR lsw_pre
      FOREACH lsw_cs INTO l_lsw.*
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'lsr_file'),
                     "        (lsr00,lsr01,lsr02,lsr03,lsrlegal,lsrplant,lsr04) ",   #FUN-C60089 add  lsr00  #CHI-C80047 add lsr04
                     " VALUES( '",l_lsw.lsw00,"', '",l_lsw.lsw01,"', '",l_lsw.lsw02,"', '",l_lsw.lsw03,"', ",    #FUN-C60089 add lsw00
                     "         '",l_legal,"','",l_plant,"','",l_lsw.lsw05,"')"    #CHI-C80047 add lsw05
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE trans_ins_lsr FROM l_sql
         EXECUTE trans_ins_lsr
         IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','INSERT INTO lsr_file:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
         END IF
      END FOREACH
      #生效營運中心
      LET l_sql = " SELECT * FROM lsz_file ",
                 #"    WHERE lsz01 = '",g_lsu.lsu01,"' AND lsz02 = '1' ",             #FUN-C60089 mark
                  "    WHERE lsz01 = '",g_lsu.lsu01,"' AND lsz02 = '",g_lsz02,"' ",   #FUN-C60089 add
                  "      AND lsz11 = '",g_lsu.lsu11,"' ",
                  "      AND lsz12 = '",g_lsu.lsu12,"' ",
                  "      AND lsz13 = '",g_lsu.lsu02,"' ",
                  "      AND lszplant = '",g_lsu.lsuplant,"' "
      PREPARE lsz_pre2 FROM l_sql
      DECLARE lsz_cs2 CURSOR FOR lsz_pre2
      FOREACH lsz_cs2 INTO l_lsz.*
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant, 'lni_file'),
                     "        (lni01,lni02,lni04,lni07,lni08,lni11,",
                     "         lni12,lni13,lni14,lnilegal,lniplant,lni15 ) ",   #CHI-C80047 add lni15
                     " VALUES( '",l_lsz.lsz01,"', '",l_lsz.lsz02,"', '",l_lsz.lsz03,"','",l_lsz.lsz04,"', ",
                     "         '",l_lsz.lsz05,"','",l_lsz.lsz08,"','',",
                     "         '",l_lsz.lsz10,"','",l_lsz.lsz11,"','",l_legal,"','",l_plant,"','",l_lsz.lsz13,"')"   #CHI-C80047 add lsz13
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

FUNCTION t590_chk_lsz03()  #判斷營運中心是否符合卡種生效營運中心
DEFINE l_lsz03          LIKE lsz_file.lsz03   #卡種
DEFINE l_n              LIKE type_file.num5
DEFINE l_cnt            LIKE type_file.num5
DEFINE l_sql            STRING

   LET g_success = 'Y' 
   CALL s_showmsg_init()
   IF cl_null(g_lsu.lsu02) THEN RETURN END IF

   LET l_sql = " SELECT lsz03 FROM lsz_file ",
               "    WHERE lsz01 = '",g_lsu.lsu01,"' ",
              #"      AND lsz02 = '1' ",           #FUN-C60089 mark
               "      AND lsz02 = '",g_lsz02,"'",  #FUN-C60089 add
               "      AND lsz11 = '",g_lsu.lsu11,"' ",
               "      AND lsz12 = '",g_lsu.lsu12,"' ",
               "      AND lsz13 = '",g_lsu.lsu02,"' ",  #CHI-C80047 add
               "      AND lszplant = '",g_lsu.lsuplant,"' ",  #FUN-C60089 add
               "      AND lsz10 = 'Y' "

   PREPARE t590_lsz03_pre FROM l_sql
   DECLARE t590_lsz03_cl CURSOR FOR t590_lsz03_pre

   FOREACH t590_lsz03_cl INTO l_lsz03 
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      IF cl_null(l_lsz03) THEN CONTINUE FOREACH END IF

      #判斷營運中心是否符合卡種生效營運中心
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lsz03, 'lnk_file'),
                  "   WHERE lnk01 = '",g_lsu.lsu02,"'  AND lnk02 = '1' AND lnk05 = 'Y' ",
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
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lsz03, 'lst_file'),
                  "   WHERE lst01 = '",g_lsu.lsu01,"'  AND lst09 = 'Y' AND lst16 = 'Y' ",
                  "     AND lst00 = '",g_lsu.lsu00,"' ",   #FUN-C60089 add
                  "     AND lst03 = '",g_lsu.lsu02,"' ",   #CHI-C80047 add
                  "     AND lstacti = 'Y' AND lst14 NOT IN ('",g_lsu.lsu11,"')"
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

FUNCTION t590_entry_lsu13()

  IF g_lsu.lsu13 = '1' THEN   #當兌換限制為1.不限兌換次數時,兌換次數不可編輯
     LET g_lsu.lsu14 = 0
     DISPLAY BY NAME g_lsu.lsu14
     CALL cl_set_comp_entry("lsu14,",FALSE)
  ELSE
     CALL cl_set_comp_entry("lsu14,",TRUE)
     CALL cl_set_comp_required("lsu14",TRUE) 
  END IF
END FUNCTION

#CHI-C80047 add START

#FUNCTION t590_del(p_lsu01,p_lsu02)
#  DEFINE p_lsu01      LIKE lsu_file.lsu01
#  DEFINE p_lsu02      LIKE lsu_file.lsu02

#     IF g_flag2 <> 'Y' THEN 
#        RETURN
#     END IF
#
#     IF cl_null(p_lsu01) THEN
#        LET p_lsu01 = g_lsu.lsu01
#     END IF
#     IF cl_null(p_lsu02) THEN
#        LEt p_lsu02 = g_lsu.lsu02
#     END IF
#     IF cl_null(p_lsu01) OR cl_null(p_lsu02) THEN
#        RETURN
#     END IF 
#     LET g_flag2 = 'N'
#     DELETE FROM lsv_file WHERE lsv00 = g_lsu.lsu00 AND lsv01 = p_lsu01 AND lsv06 = g_lsu.lsu11    
#                            AND lsv07 = g_lsu.lsu12 AND lsvplant = g_plant
#                            AND lsv08 = p_lsu02    
#     DELETE FROM lsw_file WHERE lsw00 = g_lsu.lsu00 AND lsw01 = p_lsu01 AND lsw03 = g_lsu.lsu11  
#                            AND lsw04 = g_lsu.lsu12 AND lswplant = g_plant
#                            AND lsw05 = p_lsu02     
#     DELETE FROM lsz_file WHERE lsz01 = p_lsu01 AND lsz02 = g_lsz02 AND lsz11 = g_lsu.lsu11         
#                            AND lsz12 = g_lsu.lsu12 AND lszplant = g_plant                          
#                            AND lsz13 = p_lsu02    
#END FUNCTION
 
FUNCTION t590_lsu12()

   SELECT MAX(lsu12) INTO g_lsu.lsu12 FROM lsu_file
     WHERE lsu01 = g_lsu.lsu01
       AND lsu00 = g_lsu.lsu00   
       AND lsu02 = g_lsu.lsu02   
       AND lsu11 = g_lsu.lsu11
       AND lsuplant = g_plant    

   IF cl_null(g_lsu.lsu12) THEN
     LET g_lsu.lsu12 = 0
   END IF

   SELECT * INTO g_lsu.* FROM lsu_file
    WHERE lsu01 = g_lsu.lsu01
      AND lsu00 = g_lsu.lsu00   
      AND lsu02 = g_lsu.lsu02   
      AND lsu12 = g_lsu.lsu12   
      AND lsu11 = g_plant
      AND lsuplant = g_plant

   LET g_lsu.lsu06 = 'N'
   LET g_lsu.lsu12 = g_lsu.lsu12 + 1 

   DISPLAY BY NAME g_lsu.lsu11,g_lsu.lsu00,g_lsu.lsu01,g_lsu.lsu12,g_lsu.lsu02,
                   g_lsu.lsu03,g_lsu.lsu04,g_lsu.lsu05,
                   g_lsu.lsu13,g_lsu.lsu14,
                   g_lsu.lsu10,g_lsu.lsu06,g_lsu.lsu07,g_lsu.lsu08,g_lsu.lsu09,
                   g_lsu.lsuplant,g_lsu.lsulegal,
                   g_lsu.lsuuser,g_lsu.lsucrat,g_lsu.lsumodu,
                   g_lsu.lsugrup,g_lsu.lsudate,g_lsu.lsuacti,g_lsu.lsuoriu,g_lsu.lsuorig
END FUNCTION
#CHI-C80047 add END

#FUN-C50085
 
