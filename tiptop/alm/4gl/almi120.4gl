# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: almi120.4gl
# Descriptions...: 樓層基本資料維護
# Date & Author..: FUN-870015 08/07/01 By shiwuying
# Modify.........: No.FUN-960134 09/06/29 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No.MOD-AC0249 10/12/21 By baogc 添加ACTION預設上一筆
# Modify.........: No.FUN-B80141 11/08/23 By yangxf 原单档多栏改成假双档，增加【資料清單】頁簽
# Modify.........: No.TQC-C30111 11/03/08 By yangxf 樓層存在于區域基本資料lmy_file中,單身不可改為無效或删除
# Modify.........: No.TQC-D40054 12/04/22 By lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lmc           DYNAMIC ARRAY OF RECORD
#FUN-B80141 Begin----
#          lmcstore       LIKE lmc_file.lmcstore, #No.FUN-960134 
#          rtz13       LIKE rtz_file.rtz13,   #FUN-A80148 add    
#          lmclegal    LIKE lmc_file.lmclegal, 
#          azt02       LIKE azt_file.azt02,   
#          lmc02       LIKE lmc_file.lmc02,  
#          lmb03       LIKE lmb_file.lmb03, 
#FUN-B80141 end----
           lmc03       LIKE lmc_file.lmc03,
           lmc04       LIKE lmc_file.lmc04,
#FUN-B80141 Begin----
           lmc08       LIKE lmc_file.lmc08,   
           lmc09       LIKE lmc_file.lmc09,  
           lmc11       LIKE lmc_file.lmc11, 
           lmc12       LIKE lmc_file.lmc12,
#FUN-B80141 end----
           lmc06       LIKE lmc_file.lmc06,
           lmc10       LIKE lmc_file.lmc10,     #FUN-B80141  add
           lmc05       LIKE lmc_file.lmc05,
           lmc07       LIKE lmc_file.lmc07
                       END RECORD,
       g_lmc_t         RECORD             
#FUN-B80141 Begin----
#          lmcstore       LIKE lmc_file.lmcstore,      
#          rtz13       LIKE rtz_file.rtz13,   #FUN-A80148 add  
#          lmclegal    LIKE lmc_file.lmclegal,
#          azt02       LIKE azt_file.azt02,  
#          lmc02       LIKE lmc_file.lmc02, 
#          lmb03       LIKE lmb_file.lmb03,
#FUN-B80141 end----
           lmc03       LIKE lmc_file.lmc03,
           lmc04       LIKE lmc_file.lmc04,
#FUN-B80141 Begin----
           lmc08       LIKE lmc_file.lmc08, 
           lmc09       LIKE lmc_file.lmc09,  
           lmc11       LIKE lmc_file.lmc11,   
           lmc12       LIKE lmc_file.lmc12,    
#FUN-B80141 end----
           lmc06       LIKE lmc_file.lmc06,
           lmc10       LIKE lmc_file.lmc10,     #FUN-B80141  add
           lmc05       LIKE lmc_file.lmc05,
           lmc07       LIKE lmc_file.lmc07
                       END RECORD,
       g_wc2,g_sql     STRING, 
       g_rec_b         LIKE type_file.num5,               
       l_ac            LIKE type_file.num5                
#FUN-B80141--------------begin------------
DEFINE g_lmc_2         DYNAMIC ARRAY OF RECORD
           lmcstore    LIKE lmc_file.lmcstore,
           rtz13       LIKE rtz_file.rtz13,  
           lmclegal    LIKE lmc_file.lmclegal, 
           azt02       LIKE azt_file.azt02,
           lmc02       LIKE lmc_file.lmc02,
           lmb03       LIKE lmb_file.lmb03,
           lmc03       LIKE lmc_file.lmc03,
           lmc04       LIKE lmc_file.lmc04,
           lmc08       LIKE lmc_file.lmc08,
           lmc09       LIKE lmc_file.lmc09,
           lmc11       LIKE lmc_file.lmc11, 
           lmc12       LIKE lmc_file.lmc12,  
           lmc06       LIKE lmc_file.lmc06,
           lmc10       LIKE lmc_file.lmc10,   
           lmc05       LIKE lmc_file.lmc05,
           lmc07       LIKE lmc_file.lmc07
                       END RECORD
DEFINE g_lmc_1         RECORD LIKE lmc_file.*
DEFINE g_argv1         LIKE lmc_file.lmcstore,
       g_argv2         LIKE lmc_file.lmc02
DEFINE g_lmcstore      LIKE lmc_file.lmcstore,
       g_rtz13         LIKE rtz_file.rtz13,
       g_lmclegal      LIKE lmc_file.lmclegal,
       g_azt02         LIKE azt_file.azt02,
       g_lmc02         LIKE lmc_file.lmc02,
       g_lmb03         LIKE lmb_file.lmb03, 
       g_lmcstore_t    LIKE lmc_file.lmcstore,
       g_lmclegal_t    LIKE lmc_file.lmclegal,
       g_lmc02_t       LIKE lmc_file.lmc02
DEFINE l_msg           LIKE type_file.chr1000,
       l_ac1           LIKE type_file.num5,
       g_rec_b1        LIKE type_file.num5,
       g_flag_bp       LIKE type_file.chr1
#FUN-B80141--------------add------------ 
DEFINE g_forupd_sql         STRING                  
DEFINE g_cnt                LIKE type_file.num10    
DEFINE g_msg                LIKE type_file.chr1000 
DEFINE g_before_input_done  LIKE type_file.num5     
DEFINE g_i                  LIKE type_file.num5     
DEFINE g_wc            STRING 
DEFINE p_row,p_col          LIKE type_file.num5
DEFINE g_sql_tmp            STRING
DEFINE g_row_count          LIKE type_file.num10
DEFINE g_curs_index         LIKE type_file.num10
DEFINE g_jump               LIKE type_file.num10
DEFINE mi_no_ask            LIKE type_file.num5
DEFINE g_lla                RECORD LIKE lla_file.*   #FUN-B80141 Add By shi

MAIN     
    OPTIONS                              
        INPUT NO WRAP     #No.FUN-9B0136
    #   FIELD ORDER FORM  #No.FUN-9B0136
    DEFER INTERRUPT                    
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)

    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
    END IF
      
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
         
    OPEN WINDOW i120_w WITH FORM "alm/42f/almi120"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
#FUN-B80141 begin----
    LET g_forupd_sql = "SELECT * FROM lmc_file WHERE lmcstore = ? ",    
                       " AND lmclegal = ? AND lmc02 = ? FOR UPDATE"      
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)                     
    DECLARE i120_cl CURSOR FROM g_forupd_sql
#   LET g_wc2 = '1=1'              #FUN-B80141 mark 
#   CALL i120_b_fill(g_wc2)        #FUN-B80141 mark
#FUN-B80141 end----
    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
       CALL i120_q() 
    END IF    
    CALL cl_set_comp_required("lmc09,lmc12",TRUE)
    CALL i120_menu()
    CLOSE WINDOW i120_w               
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 
#FUN-B80141---------------begin----------------
FUNCTION i120_cs()
    CLEAR FORM
    CALL g_lmc.clear()
    LET g_lmcstore = NULL
    LET g_lmclegal = NULL
    LET g_lmc02 = NULL
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " lmcstore = '",g_argv1,"'",
                  " AND lmc02 = '",g_argv2,"'"
       LET g_argv1 = NULL
       LET g_argv2 = NULL
    ELSE
       CONSTRUCT g_wc ON lmcstore,lmclegal,lmc02,lmc03,lmc04,lmc08,lmc09,lmc11,lmc12,
                         lmc06,lmc10,lmc05,lmc07
           FROM lmcstore,lmclegal,lmc02,s_lmc[1].lmc03,s_lmc[1].lmc04,s_lmc[1].lmc08,
                s_lmc[1].lmc09,s_lmc[1].lmc11,s_lmc[1].lmc12,
                s_lmc[1].lmc06,s_lmc[1].lmc10,s_lmc[1].lmc05,s_lmc[1].lmc07
   
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
   
         ON ACTION controlp
            CASE
               WHEN INFIELD(lmcstore)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_lmcstore"
                  LET g_qryparam.where = " lmcstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmcstore
                  NEXT FIELD lmcstore
               WHEN INFIELD(lmclegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmclegal"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " lmcstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmclegal
                  NEXT FIELD lmclegal
               WHEN INFIELD(lmc02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmc02"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " lmcstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmc02
                  NEXT FIELD lmc02
               WHEN INFIELD(lmc03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmc03"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " lmcstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmc03
                  NEXT FIELD lmc03
               OTHERWISE EXIT CASE
            END CASE
   
         ON ACTION qbe_select
            CALL cl_qbe_select()
   
         ON ACTION qbe_save
            CALL cl_qbe_save()
   
       END CONSTRUCT
       IF INT_FLAG THEN 
         LET g_wc = NULL
         RETURN
       END IF
    END IF 
    LET g_sql="SELECT UNIQUE lmcstore,lmclegal,lmc02",
              " FROM lmc_file ",
              " WHERE ", g_wc CLIPPED,
              "  AND lmcstore IN ",g_auth,
              " ORDER BY lmcstore,lmclegal,lmc02 "
    PREPARE i120_prepare FROM g_sql
    DECLARE i120_bcs
        SCROLL CURSOR WITH HOLD FOR i120_prepare
    DROP TABLE x
    LET g_sql_tmp="SELECT UNIQUE lmcstore,lmclegal,lmc02 ",
                  "  FROM lmc_file WHERE ", g_wc CLIPPED,
                  "   AND lmcstore IN ",g_auth,
                  " GROUP BY lmcstore,lmclegal,lmc02",
                  " INTO TEMP x"
    PREPARE i120_precount_x FROM g_sql_tmp
    EXECUTE i120_precount_x
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i120_precount FROM g_sql
    DECLARE i120_count CURSOR FOR i120_precount
END FUNCTION
#FUN-B80141--------------- end ----------------

FUNCTION i120_menu()
 
   WHILE TRUE
         CALL i120_bp1("G")           #FUN-B80141
#        CALL i120_bp("G")            #FUN-B80141   mark 
      CASE g_action_choice

#FUN-B80141--------------begin------------
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i120_a()
            END IF 

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i120_r()
            END IF
         WHEN "help"
             CALL cl_show_help()

         WHEN "exit"
              EXIT WHILE

         WHEN "controlg"
             CALL cl_cmdask()         
         WHEN "Areamaintaining"
            IF cl_chk_act_auth() THEN
            #IF l_ac > 0 THEN
            #    IF NOT cl_null(g_lmcstore) AND NOT cl_null(g_lmc02) AND NOT cl_null(g_lmc[l_ac].lmc03) THEN
            #      LET g_wc = " 1=1"
            #      CALL i120_show() 
            #     #LET l_msg = "almi121  '",g_lmcstore,"' '",g_lmc02,"' '",g_lmc[l_ac].lmc03 CLIPPED,"'"
            #      CALL cl_cmdrun_wait(l_msg)
            #    END IF 
            #ELSE
            #    CALL cl_err('',-400,1)
            #END IF 
                IF l_ac > 0 THEN
                LET l_msg = "almi121  '",g_lmcstore,"' '",g_lmc02,"' '",g_lmc[l_ac].lmc03 CLIPPED,"'"
               #LET l_msg = "almi121  " #Mod By shi
                CALL cl_cmdrun_wait(l_msg)
                END IF
             END IF 
#FUN-B80141--------------end ------------
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i120_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               LET l_ac = ARR_CURR()
               IF l_ac > 0 THEN
               #  IF cl_chk_mach_auth(g_lmc[l_ac].lmcstore,g_plant) THEN
                     CALL i120_b()
               #  END IF
               ELSE 
                  CALL i120_b()
                  LET g_action_choice = NULL
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #CALL i120_out()
#FUN-B80141--------------begin-----------
#              IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
#              LET g_msg = 'p_query "almi120" "',g_wc2 CLIPPED,'"'
               IF cl_null(g_lmcstore) THEN
                   CALL cl_err('',-400,1)
               ELSE 
                   IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
                   LET g_msg = 'p_query "almi120" "',g_wc CLIPPED,'"'
                   CALL cl_cmdrun(g_msg)
               END IF 
#FUN-B80141--------------end ------------
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lmc),base.TypeInfo.create(g_lmc_2),'')
            END IF
#FUN-B80141   mark
      END CASE
   END WHILE
END FUNCTION

#FUN-B80141--------------begin------------ 
FUNCTION i120_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i120_bcs INTO g_lmcstore,g_lmclegal,g_lmc02
        WHEN 'P' FETCH PREVIOUS i120_bcs INTO g_lmcstore,g_lmclegal,g_lmc02
        WHEN 'F' FETCH FIRST    i120_bcs INTO g_lmcstore,g_lmclegal,g_lmc02
        WHEN 'L' FETCH LAST     i120_bcs INTO g_lmcstore,g_lmclegal,g_lmc02
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
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i120_bcs
            INTO g_lmcstore,g_lmclegal,g_lmc02 
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmcstore,SQLCA.sqlcode,0)
       INITIALIZE g_lmcstore TO NULL
       INITIALIZE g_lmclegal TO NULL
       INITIALIZE g_lmc02 TO NULL
    ELSE
       OPEN i120_count
       FETCH i120_count INTO g_row_count
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       DISPLAY g_curs_index TO FORMONLY.idx
       CALL i120_show()
    END IF
END FUNCTION


FUNCTION i120_show()
       LET g_lmcstore_t = g_lmcstore
       LET g_lmclegal_t = g_lmclegal
       LET g_lmc02_t = g_lmc02
       DISPLAY g_lmcstore TO lmcstore
       DISPLAY g_lmclegal TO lmclegal
       DISPLAY g_lmc02 TO lmc02
       CALL i120_lmcstore("d") 
       CALL i120_b_fill(g_wc)
       CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i120_a()
DEFINE l_n     LIKE type_file.num10
DEFINE l_rtz28 LIKE rtz_file.rtz28
   SELECT rtz28 INTO l_rtz28 
     FROM rtz_file
    WHERE rtz01 = g_plant
   IF l_rtz28 <> 'Y' THEN
      CALL cl_err('','alm-881',0)
      RETURN
   END IF  
   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   CLEAR FORM
   LET g_lmcstore = g_plant 
   LET g_lmclegal = g_legal
   SELECT azt02 INTO g_azt02 FROM azt_file
       WHERE azt01 = g_lmclegal
   SELECT rtz13 INTO g_rtz13
     FROM rtz_file INNER JOIN azw_file
       ON rtz01 = azw01
    WHERE rtz01 = g_lmcstore
   LET g_lmc02    = NULL
   LET g_lmb03    = NULL
   LET g_lmc02_t = NULL
   LET g_wc=NULL
   LET g_wc2=NULL
   WHILE TRUE
      CALL i120_i("a")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lmcstore = NULL
         LET g_lmclegal = NULL
         LET g_lmc02 = NULL
         CALL g_lmc.clear()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
      FROM lmc_file
      WHERE lmcstore = g_lmcstore
        AND lmclegal = g_lmclegal
        AND lmc02    = g_lmc02
      LET g_lmcstore_t = g_lmcstore
      LET g_lmclegal_t = g_lmclegal
      LET g_lmc02_t    = g_lmc02
      CALL g_lmc.clear()
      IF l_n >0 THEN
         CALL i120_b_fill(" 1=1")
         CALL i120_b()
      ELSE
         CALL i120_b()
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION 


FUNCTION i120_i(p_cmd)
    DEFINE p_cmd           LIKE type_file.chr1
    DISPLAY g_lmcstore TO lmcstore
    DISPLAY g_rtz13 TO rtz13
    DISPLAY g_lmclegal TO lmclegal
    DISPLAY g_azt02 TO azt02
    INPUT g_lmcstore,g_lmclegal,g_lmc02  WITHOUT DEFAULTS
          FROM lmcstore,lmclegal,lmc02

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i120_set_entry(p_cmd)
            CALL i120_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE


        AFTER FIELD lmc02
            IF NOT cl_null(g_lmc02) THEN
               IF g_lmc02!=g_lmc02_t OR g_lmc02_t IS NULL THEN
                  CALL i120_lmcstore(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_lmc02,g_errno,0)
                     LET g_lmc02 = g_lmc02_t
                     NEXT FIELD lmc02
                  END IF
               END IF
            END IF

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(lmc02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lmb1"
                 LET g_qryparam.arg1 = g_lmcstore
                 CALL cl_create_qry() RETURNING g_lmc02
                 DISPLAY BY NAME g_lmc02
                 CALL i120_lmcstore("d")
                 NEXT FIELD lmc02
             OTHERWISE EXIT CASE
           END CASE

        ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode())
          RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

    END INPUT
END FUNCTION

FUNCTION i120_bp1(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1         

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DIALOG ATTRIBUTES(UNBUFFERED)   
      DISPLAY ARRAY g_lmc TO s_lmc.* ATTRIBUTE(COUNT=g_rec_b)
   
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         BEFORE ROW
            LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
   
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
            CALL i120_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG
   
         ON ACTION previous
            CALL i120_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG
   
         ON ACTION jump
            CALL i120_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG
   
         ON ACTION next
            CALL i120_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG
   
         ON ACTION last
            CALL i120_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DIALOG
   
         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
            EXIT DIALOG
   
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
    
         ON ACTION Areamaintaining
            LET g_action_choice="Areamaintaining"
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

         ON ACTION output
            LET g_action_choice="output"
            EXIT DIALOG
   
         ON ACTION accept
            LET g_action_choice="detail"
            LET l_ac = ARR_CURR()
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
            LET g_action_choice="exporttoexcel"
            EXIT DIALOG
   
         AFTER DISPLAY
            CONTINUE DIALOG
   
      END DISPLAY
      DISPLAY ARRAY g_lmc_2 TO s_lmc_2.* ATTRIBUTE(COUNT=g_rec_b)
   
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
   
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()
   
         ON ACTION accept
            LET l_ac1 = ARR_CURR()
            LET g_jump = l_ac1
            LET mi_no_ask = TRUE
            IF l_ac1>0 THEN #將清單的資料回傳到主畫面
               SELECT UNIQUE lmcstore,lmclegal,lmc02
                 INTO g_lmcstore,g_lmclegal,g_lmc02
                 FROM lmc_file
                WHERE lmcstore=g_lmc_2[l_ac1].lmcstore
                  AND lmclegal=g_lmc_2[l_ac1].lmclegal
                  AND lmc02=g_lmc_2[l_ac1].lmc02
            CALL i120_show()
            END IF
            EXIT DIALOG
   
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
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

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
   
         ON ACTION about
            CALL cl_about()
   
         ON ACTION exporttoexcel
            LET g_action_choice="exporttoexcel"
            EXIT DIALOG

         AFTER DISPLAY
            CONTINUE DIALOG
   
      END DISPLAY
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)   
END FUNCTION

FUNCTION i120_r()
   DEFINE l_n          LIKE type_file.num10
   DEFINE l_lmcstore   LIKE lmc_file.lmcstore
   DEFINE l_lmc        DYNAMIC ARRAY OF RECORD
                       lmc01       LIKE lmc_file.lmc01,
                       lmc02       LIKE lmc_file.lmc02,
                       lmc03       LIKE lmc_file.lmc03,
                       lmc04       LIKE lmc_file.lmc04,
                       lmc05       LIKE lmc_file.lmc05,
                       lmc06       LIKE lmc_file.lmc06,
                       lmc07       LIKE lmc_file.lmc07,    
                       lmclegal    LIKE lmc_file.lmclegal,
                       lmcstore    LIKE lmc_file.lmcstore,
                       lmc08       LIKE lmc_file.lmc08,
                       lmc09       LIKE lmc_file.lmc09,
                       lmc10       LIKE lmc_file.lmc10,
                       lmc11       LIKE lmc_file.lmc11,
                       lmc12       LIKE lmc_file.lmc12
                       END RECORD                  
   DEFINE l_i          LIKE type_file.num10   
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_lmcstore IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   IF g_lmcstore <> g_plant THEN
      CALL cl_err('','alm1023',0)
      RETURN
   END IF
   CALL l_lmc.clear()
   LET l_n = 0
   LET l_i = 1 
   LET g_sql = "SELECT * FROM lmc_file ",
               " WHERE lmcstore = '",g_lmcstore,"'",
               "   AND lmc02 = '",g_lmc02,"'"
   PREPARE i120_del_prepare FROM g_sql
   DECLARE lmc_del CURSOR FOR i120_del_prepare
   FOREACH lmc_del INTO l_lmc[l_i].* 
       SELECT count(*) INTO l_n 
         FROM lmy_file
        WHERE lmystore = l_lmc[l_i].lmcstore
          AND lmy01 = l_lmc[l_i].lmc02
          AND lmy02 = l_lmc[l_i].lmc03
       LET l_i = l_i + 1
       IF l_n > 0 THEN
          EXIT FOREACH
       END IF 
   END FOREACH 
   IF l_n > 0 THEN
      CALL cl_err('','alm-773',0)
      RETURN
   END IF 
   BEGIN WORK
   LET g_lmcstore_t = g_lmcstore
   LET g_lmclegal_t = g_lmclegal
   LET g_lmc02_t = g_lmc02
   OPEN i120_cl USING g_lmcstore_t,g_lmclegal_t,g_lmc02_t
   IF STATUS THEN
      CALL cl_err("OPEN i120_cl:", STATUS, 1)
      CLOSE i120_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i120_cl INTO g_lmc_1.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmcstore,SQLCA.sqlcode,0)
      CLOSE i120_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL i120_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL
       LET g_doc.column1 = "lmcstore"
       LET g_doc.value1 = g_lmcstore
       CALL cl_del_doc()
       OPEN i120_count
       FETCH i120_count INTO g_row_count
       IF cl_null(g_argv1) THEN
          DELETE FROM lmc_file WHERE lmcstore = g_lmcstore_t
       ELSE 
          DELETE FROM lmc_file WHERE lmcstore = g_argv1
                                 AND lmc02 = g_argv2
       END IF 
       CLEAR FORM
       CALL g_lmc.clear()
       LET g_row_count = g_row_count - 1
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i120_bcs
       IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i120_fetch('L')
       ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i120_fetch('/')
       END IF
    END IF
   CLOSE i120_cl
   COMMIT WORK
END FUNCTION
#FUN-B80141--------------end------------

FUNCTION i120_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_lmcstore TO NULL
    INITIALIZE g_lmclegal TO NULL
    INITIALIZE g_lmc02 TO NULL

   MESSAGE ""
   DISPLAY '' TO FORMONLY.cnt
   CALL i120_cs()            
   IF INT_FLAG THEN         
      LET INT_FLAG = 0
      INITIALIZE g_lmcstore TO NULL
      INITIALIZE g_lmclegal TO NULL
      INITIALIZE g_lmc02 TO NULL
      RETURN
   END IF
   OPEN i120_bcs
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lmcstore TO NULL
      INITIALIZE g_lmclegal TO NULL
      INITIALIZE g_lmc02 TO NULL
   ELSE
      CALL i120_fetch('F')
      CALL i120_b2_fill()
      OPEN i120_count
      FETCH i120_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
#  CALL i120_b_askkey()             #FUN-B80141   mark
END FUNCTION 
#FUN-B80141--------------add start------------
FUNCTION i120_b2_fill()
  DEFINE l_lmcstore      LIKE lmc_file.lmcstore
  DEFINE l_i             LIKE type_file.num10
    LET g_sql = "SELECT DISTINCT lmcstore FROM lmc_file ", # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED,
                " AND lmcstore IN ",g_auth,
                " ORDER BY lmcstore"
    PREPARE i120_prepare_b FROM g_sql
    DECLARE i120_list_cur CURSOR FOR i120_prepare_b
    CALL g_lmc_2.clear()
    LET l_i = 1
    FOREACH i120_list_cur INTO l_lmcstore
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       LET g_sql = "SELECT lmcstore,'',lmclegal,'',lmc02,'',lmc03,lmc04,lmc08,lmc09,lmc11,lmc12,",
                   "lmc06,lmc10,lmc05,lmc07", 
                   "  FROM lmc_file",
                   " WHERE ",g_wc CLIPPED, 
                   "   AND lmcstore ='", l_lmcstore,"'",
                   " ORDER BY lmcstore,lmc02,lmc03 "
       PREPARE i120_pb_2 FROM g_sql
       DECLARE lmc_curs2 CURSOR FOR i120_pb_2  
       FOREACH lmc_curs2 INTO g_lmc_2[l_i].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF 
          SELECT rtz13 INTO g_lmc_2[l_i].rtz13
            FROM rtz_file INNER JOIN azw_file
              ON rtz01 = azw01
           WHERE rtz01 =g_lmc_2[l_i].lmcstore 
          
          SELECT lmb03 INTO g_lmc_2[l_i].lmb03
            FROM lmb_file
           WHERE lmb02 = g_lmc_2[l_i].lmc02
             AND lmbstore = g_lmc_2[l_i].lmcstore
   
         SELECT azt02 INTO g_lmc_2[l_i].azt02 
           FROM azt_file
          WHERE azt01 = g_lmc_2[l_i].lmclegal
          LET l_i = l_i + 1
          IF l_i > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
       END FOREACH
    END FOREACH
    CALL g_lmc_2.deleteElement(l_i)
    LET g_rec_b1 = l_i - 1
    DISPLAY g_rec_b1 TO FORMONLY.cn3 
    DISPLAY ARRAY g_lmc_2 TO s_lmc_2.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
END FUNCTION
#FUN-B80141--------------add end--------------

FUNCTION i120_b()
    DEFINE
       l_ac_t          LIKE type_file.num5,    
       l_n             LIKE type_file.num5,     
       l_n2            LIKE type_file.num5,
       l_n3            LIKE type_file.num5,
       l_n4            LIKE type_file.num5,   
       l_cnt           LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,  
       p_cmd           LIKE type_file.chr1,   
       l_allow_insert  LIKE type_file.chr1,   
       l_allow_delete  LIKE type_file.chr1    
    DEFINE l_rtz13     LIKE rtz_file.rtz13   #FUN-A80148 add
    DEFINE l_lmb03     LIKE lmb_file.lmb03
    DEFINE l_lmc04     LIKE lmc_file.lmc04
#   DEFINE l_tqa06     LIKE tqa_file.tqa06
 
    LET g_action_choice = ""
 
####判斷當前組織機構是否是門店，只能在門店錄資料######
#  SELECT tqa06 INTO l_tqa06 FROM tqa_file
#   WHERE tqa03 = '14'
#     AND tqaacti = 'Y'
#     AND tqa01 IN(SELECT tqb03 FROM tqb_file
#                   WHERE tqbacti = 'Y'
#                     AND tqb09 = '2'
#                     AND tqb01 = g_plant)
#  IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN
#     CALL cl_err('','alm-600',1)
#     CALL g_lmc.clear()
#     RETURN
#  END IF
 
#  SELECT COUNT(*) INTO l_cnt FROM rtz_file
#   WHERE rtz01 = g_plant
#     AND rtz28 = 'Y'
#  IF l_cnt < 1 THEN
#     CALL cl_err('','alm-606',1)
#     CALL g_lmc.clear()
#     RETURN 
#  END IF
######################################################
     
    IF s_shut(0) THEN RETURN END IF
#FUN-B80141----------ADD-------------
    IF cl_null(g_lmc02) THEN
       RETURN
    END IF 
    IF g_lmcstore <> g_plant THEN
       CALL cl_err('','alm1023',0)
       RETURN
    END IF
  
#FUN-B80141---------END-ADD----------
    LET l_allow_insert = cl_detail_input_auth('insert')
    CALL i120_set_entry_b(p_cmd)        #FUN-B80141       
    CALL i120_set_no_entry_b(p_cmd)     #FUN-B80141
    LET l_allow_delete = cl_detail_input_auth('delete')

    SELECT * INTO g_lla.* FROM lla_file WHERE llastore = g_plant #FUN-B80141
 
    CALL cl_opmsg('b')
#FUN-B80141-------------mark------------- 
#    LET g_forupd_sql = "SELECT lmcstore,'',lmclegal,'',lmc02,'',lmc03,lmc04,",
#                       "       lmc05,lmc06,lmc07",
#                       " FROM lmc_file WHERE ",
#                       " lmcstore=? AND lmc02=? AND lmc03=? FOR UPDATE "
#FUN-B80141-------------mark------------- 
    LET g_forupd_sql = "SELECT lmc03,lmc04,lmc08,lmc09,lmc11,lmc12,lmc06,lmc10,lmc05,lmc07",     #FUN-B80141  
                       "  FROM lmc_file ",
                       " WHERE lmcstore = ? ",
                       "   AND lmclegal = ? ",
                       "   AND lmc02 = ? ",
                       "   AND lmc03  = ? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i120_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_lmc WITHOUT DEFAULTS FROM s_lmc.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac) 
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET  g_before_input_done = FALSE 
#              CALL i120_set_entry(p_cmd)            #FUN-B80141  mark
#              CALL i120_set_no_entry(p_cmd)         #FUN-B80141  mark
               CALL i120_set_entry_b(p_cmd)        #FUN-B80141
               CALL i120_set_no_entry_b(p_cmd)     #FUN-B80141
               LET  g_before_input_done = TRUE 
 
               BEGIN WORK
               LET g_lmc_t.* = g_lmc[l_ac].*  #BACKUP
               OPEN i120_bcl USING g_lmcstore_t,g_lmclegal_t,g_lmc02_t,g_lmc_t.lmc03
               IF STATUS THEN
                  CALL cl_err("OPEN i120_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                  FETCH i120_bcl INTO g_lmc[l_ac].* 
                  IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_lmc_t.lmcstore,SQLCA.sqlcode,1) #FUN-B80141  mark
                     CALL cl_err(g_lmcstore,SQLCA.sqlcode,1)       #FUN-B80141
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()  
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_lmc[l_ac].* TO NULL
#           LET g_lmc[l_ac].lmclegal = g_legal        #FUN-B80141  mark
            IF l_ac > 1 THEN 
                LET g_lmc[l_ac].lmc11 = g_lmc[l_ac-1].lmc11
                LET g_lmc[l_ac].lmc12 = g_lmc[l_ac-1].lmc12 
            END IF 
            LET g_lmc[l_ac].lmc07 = 'Y'       #Body default
#           LET g_lmc[l_ac].lmcstore = g_plant        #FUN-B80141  mark
            LET g_lmc_t.* = g_lmc[l_ac].*
            LET  g_before_input_done = FALSE
#           CALL i120_set_entry(p_cmd)                #FUN-B80141  mark 
#           CALL i120_set_no_entry(p_cmd)             #FUN-B80141  mark
            CALL i120_set_entry_b(p_cmd)        #FUN-B80141
            CALL i120_set_no_entry_b(p_cmd)     #FUN-B80141
            LET  g_before_input_done = TRUE
            CALL cl_show_fld_cont()    
#           NEXT FIELD lmcstore              #FUN-B80141  mark
            NEXT FIELD lmc03                 #FUN-B80141
       AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
#FUN-B80141 add begin ---
            CALL i120_lmc08(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lmc[l_ac].lmc08 = g_lmc_t.lmc08
               CANCEL INSERT
            END IF
            CALL i120_lmc09(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lmc[l_ac].lmc09 = g_lmc_t.lmc09
               CANCEL INSERT
            END IF
#FUN-B80141 add end ---
            INSERT INTO lmc_file(lmcstore,lmclegal,lmc02,lmc03,lmc04,lmc05,
                                 lmc06,lmc07,lmc08,lmc09,lmc10,lmc11,lmc12)                #FUN-B80141  add lmc08,lmc09.lmc10.lmc11,lmc12
#                VALUES(g_lmc[l_ac].lmcstore,g_lmc[l_ac].lmclegal,g_lmc[l_ac].lmc02,      #FUN-B80141  mark
                 VALUES(g_lmcstore,g_lmclegal,g_lmc02,                             #FUN-B80141
                        g_lmc[l_ac].lmc03,g_lmc[l_ac].lmc04,
                        g_lmc[l_ac].lmc05,g_lmc[l_ac].lmc06,g_lmc[l_ac].lmc07,
                        g_lmc[l_ac].lmc08,g_lmc[l_ac].lmc09,g_lmc[l_ac].lmc10,     #FUN-B80141 add
                        g_lmc[l_ac].lmc11,g_lmc[l_ac].lmc12)                       #FUN-B80141 add 
            IF SQLCA.sqlcode THEN
#              CALL cl_err3("ins","lmc_file",g_lmc[l_ac].lmcstore,"",SQLCA.sqlcode,"","",1)  #FUN-B80141   mark 
               CALL cl_err3("ins","lmc_file",g_lmc[l_ac].lmc03,"",SQLCA.sqlcode,"","",1)  #FUN-B80141  add
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2 
            END IF
#FUN-B80141-----------mark---------- 
#        AFTER FIELD lmcstore
#            IF NOT cl_null(g_lmc[l_ac].lmcstore) THEN
#               CALL i120_lmcstore(p_cmd)
#               IF NOT cl_null(g_errno) THEN     
#                  CALL cl_err(g_lmc[l_ac].lmcstore,g_errno,0)
#                  LET g_lmc[l_ac].lmcstore = g_lmc_t.lmcstore
#                  EXIT INPUT
#               END IF
#            END IF
# 
#        AFTER FIELD lmc02
#            IF NOT cl_null(g_lmc[l_ac].lmc02) THEN
#               IF g_lmc[l_ac].lmc02!=g_lmc_t.lmc02 OR g_lmc_t.lmc02 IS NULL THEN
#                  CALL i120_lmcstore(p_cmd)
#                  IF NOT cl_null(g_errno) THEN     
#                     CALL cl_err(g_lmc[l_ac].lmc02,g_errno,0)
#                     LET g_lmc[l_ac].lmc02 = g_lmc_t.lmc02
#                     NEXT FIELD lmc02
#                  END IF
#                  IF NOT cl_null(g_lmc[l_ac].lmc03) THEN
#                     SELECT COUNT(*) INTO l_cnt FROM lmc_file
#                      WHERE lmcstore = g_lmc[l_ac].lmcstore
#                        AND lmc02 = g_lmc[l_ac].lmc02
#                        AND lmc03 = g_lmc[l_ac].lmc03
#                     IF l_cnt > 0 THEN
#                        CALL cl_err(g_lmc[l_ac].lmc02,'-239',0)
#                        NEXT FIELD lmc02
#                     END IF
#                  END IF
#               END IF
#            END IF
#FUN-B80141-----------mark----------
 
        AFTER FIELD lmc03
#           IF NOT cl_null(g_lmc[l_ac].lmc02) AND    #FUN-B80141  mark
            IF NOT cl_null(g_lmc[l_ac].lmc03) AND
              (g_lmc[l_ac].lmc03!=g_lmc_t.lmc03 OR cl_null(g_lmc_t.lmc03)) THEN
              SELECT COUNT(*) INTO l_cnt FROM lmc_file
#               WHERE lmcstore = g_lmc[l_ac].lmcstore  #FUN-B80141  mark
#                 AND lmc02 = g_lmc[l_ac].lmc02        #FUN-B80141  mark
               WHERE lmcstore = g_lmcstore            #FUN-B80141
                 AND lmc02 = g_lmc02                  #FUN-B80141
                 AND lmclegal = g_lmclegal            #FUN-B80141
                 AND lmc03 = g_lmc[l_ac].lmc03
              IF l_cnt > 0 THEN
                 CALL cl_err(g_lmc[l_ac].lmc03,'-239',0)
                 NEXT FIELD lmc03
              END IF
              IF p_cmd = 'u' THEN
                 LET l_n2 = 0
                 LET l_n3 = 0
                 LET l_n4 = 0
                 SELECT COUNT(*) INTO l_n2
                   FROM lmy_file
                  WHERE lmystore = g_lmcstore
                    AND lmy01 = g_lmc02
                    AND lmy02 = g_lmc_t.lmc03
                 SELECT COUNT(*) INTO l_n3
                   FROM lmd_file
                  WHERE lmdstore = g_lmcstore
                    AND lmd03 = g_lmc02
                    AND lmd04 = g_lmc_t.lmc03
                 SELECT COUNT(*) INTO l_n4
                   FROM lia_file
                  WHERE liaplant = g_lmcstore
                    AND lia07 = g_lmc02
                    AND lia08 = g_lmc_t.lmc03
                 IF l_n2 > 0 OR l_n3 > 0 OR l_n4 > 0 THEN
                    LET g_lmc[l_ac].lmc03 = g_lmc_t.lmc03
                    CALL cl_err('','alm-776',0)
                    NEXT FIELD lmc03
                 END IF 
              END IF            
           END IF
#FUN-B80141----------add-------------
        AFTER FIELD lmc08,lmc09,lmc11,lmc12
           CASE 
              WHEN INFIELD(lmc08)
                   CALL i120_lmc08(p_cmd)
              WHEN INFIELD(lmc09)
                   CALL i120_lmc09(p_cmd)
           END CASE
           IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               CASE 
                  WHEN INFIELD(lmc08)
                     LET g_lmc[l_ac].lmc08 = g_lmc_t.lmc08        
                     NEXT FIELD lmc08
                  WHEN INFIELD(lmc09)
                     LET g_lmc[l_ac].lmc09 = g_lmc_t.lmc09  
                     NEXT FIELD lmc09
               END CASE 
           END IF 
           IF g_lmc[l_ac].lmc08 < 0 THEN
              CALL cl_err('','alm-769',0)
              LET g_lmc[l_ac].lmc08 = g_lmc_t.lmc08
              NEXT FIELD lmc08
           END IF 
           IF g_lmc[l_ac].lmc09 < 0 THEN
              CALL cl_err('','alm-770',0)
              LET g_lmc[l_ac].lmc09 = g_lmc_t.lmc09
              NEXT FIELD lmc09
           END IF 
           IF g_lmc[l_ac].lmc11 < 0 OR g_lmc[l_ac].lmc11 >100 THEN 
              CALL cl_err('','alm-771',0)
              LET g_lmc[l_ac].lmc11 = g_lmc_t.lmc11
              NEXT FIELD lmc11 
           END IF 
           IF g_lmc[l_ac].lmc12 < 0 THEN
              CALL cl_err('','alm-772',0)
              LET g_lmc[l_ac].lmc12 = g_lmc_t.lmc12
              NEXT FIELD lmc12
           END IF 
          #FUN-B80141 Begin--- By shi
           IF cl_null(g_lla.lla03) THEN
              CALL cl_err('','alm1172',0)
              CASE
                 WHEN INFIELD(lmc08)
                    NEXT FIELD lmc08
                 WHEN INFIELD(lmc09)
                    NEXT FIELD lmc09
              END CASE
           ELSE  
              LET g_lmc[l_ac].lmc08 = cl_digcut(g_lmc[l_ac].lmc08,g_lla.lla03)
              LET g_lmc[l_ac].lmc09 = cl_digcut(g_lmc[l_ac].lmc09,g_lla.lla03)
           END IF
          #FUN-B80141 End-----

#FUN-B80141----------add end-------------
        AFTER FIELD lmc07 
           IF g_lmc[l_ac].lmc07 = 'N' THEN
#FUN-B80141----------beging-----------
#             SELECT count(*) INTO l_n FROM lme_file 
#               WHERE lmestore = g_lmc[l_ac].lmcstore 
#                 AND lme02 = g_lmc[l_ac].lmc02      
#                AND lme03 = g_lmc[l_ac].lmc03
#             IF l_n > 0 THEN
#                CALL cl_err('','alm-020',1)
#                LET g_lmc[l_ac].lmc07 = 'Y'
#                NEXT FIELD lmc07
#             END IF
#FUN-B80141----------end-------------
#TQC-C30111 add begin ---
              SELECT count(*) INTO l_n 
                FROM lmy_file 
               WHERE lmystore = g_lmcstore 
                 AND lmy01 = g_lmc02
                 AND lmy02 = g_lmc[l_ac].lmc03
              IF l_n > 0 THEN                                               
                 CALL cl_err('','alm1597',1)                          
                 LET g_lmc[l_ac].lmc07 = 'Y'                          
                 NEXT FIELD lmc07              
              END IF
#TQC-C30111 add end -----
              SELECT count(*) INTO l_n FROM lmd_file                            
#               WHERE lmdstore = g_lmc[l_ac].lmcstore #FUN-B80141  mark                                 
#                 AND lmd03 = g_lmc[l_ac].lmc02       #FUN-B80141  mark
               WHERE lmdstore = g_lmcstore            #FUN-B80141
                 AND lmd03 = g_lmc02                  #FUN-B80141                                       
                 AND lmd04 = g_lmc[l_ac].lmc03                                  
              IF l_n > 0 THEN                                                   
                 CALL cl_err('','alm-021',1)                                    
                 LET g_lmc[l_ac].lmc07 = 'Y'                                    
                 NEXT FIELD lmc07                                               
              END IF
              SELECT count(*) INTO l_n FROM lmf_file                            
#               WHERE lmfstore = g_lmc[l_ac].lmcstore #FUN-B80141  mark                                 
#                 AND lmf03 = g_lmc[l_ac].lmc02       #FUN-B80141  mark 
               WHERE lmfstore = g_lmcstore            #FUN-B80141
                 AND lmf03 = g_lmc02                  #FUN-B80141                                     
                 AND lmf04 = g_lmc[l_ac].lmc03                                  
              IF l_n > 0 THEN                                                   
                 CALL cl_err('','alm-022',1)                                    
                 LET g_lmc[l_ac].lmc07 = 'Y'                                    
                 NEXT FIELD lmc07                                               
              END IF
#FUN-B80141----------beging-----------
#              SELECT count(*) INTO l_n FROM lml_file                            
#               WHERE lmlstore = g_lmc[l_ac].lmcstore 
#                 AND lml04 = g_lmc[l_ac].lmc02      
#                 AND lml05 = g_lmc[l_ac].lmc03                                  
#              IF l_n > 0 THEN                                                   
#                 CALL cl_err('','alm-024',1)                                    
#                 LET g_lmc[l_ac].lmc07 = 'Y'                                    
#                 NEXT FIELD lmc07                                               
#              END IF
#FUN-B80141----------end-------------
           END IF
 
        BEFORE DELETE 
#           IF g_lmc_t.lmcstore IS NOT NULL THEN     #FUN-B80141  mark
            IF g_lmc_t.lmc03 IS NOT NULL THEN
#FUN-B80141----------beging-----------
#              SELECT count(*) INTO l_n FROM lme_file
#               WHERE lmestore = g_lmc[l_ac].lmcstore 
#               WHERE lmestore = g_lmcstore
#                 AND lme02 = g_lmc02                
#                 AND lme02 = g_lmc[l_ac].lmc02     
#                 AND lme03 = g_lmc[l_ac].lmc03
#              IF l_n > 0 THEN
#                 CALL cl_err('','alm-020',1) 
#                 CANCEL DELETE 
#              END IF
#FUN-B80141----------end-------------
#TQC-C30111 add begin ---
               SELECT count(*) INTO l_n
                 FROM lmy_file
                WHERE lmystore = g_lmcstore
                  AND lmy01 = g_lmc02
                  AND lmy02 = g_lmc_t.lmc03 
               IF l_n > 0 THEN
                  CALL cl_err('','alm1597',1)
                  CANCEL DELETE
               END IF
#TQC-C30111 add end -----
               SELECT count(*) INTO l_n FROM lmd_file
#                WHERE lmdstore = g_lmc[l_ac].lmcstore     #FUN-B80141  mark
#                  AND lmd03 = g_lmc[l_ac].lmc02           #FUN-B80141  mark
                WHERE lmdstore = g_lmcstore                #FUN-B80141
                  AND lmd03 = g_lmc02                      #FUN-B80141   
#                 AND lmd04 = g_lmc[l_ac].lmc03            #TQC-C30111 mark
                  AND lmd04 = g_lmc_t.lmc03                #TQC-C30111 add
               IF l_n > 0 THEN
                  CALL cl_err('','alm-021',1)
                  CANCEL DELETE
               END IF
               SELECT count(*) INTO l_n FROM lmf_file 
#                WHERE lmfstore = g_lmc[l_ac].lmcstore     #FUN-B80141  mark
#                  AND lmf03 = g_lmc[l_ac].lmc02           #FUN-B80141  mark
                 WHERE lmfstore = g_lmcstore               #FUN-B80141
                   AND lmf03 = g_lmc02                     #FUN-B80141
#                  AND lmf04 = g_lmc[l_ac].lmc03           #TQC-C30111 mark
                   AND lmf04 = g_lmc_t.lmc03               #TQC-C30111 add
               IF l_n > 0 THEN 
                  CALL cl_err('','alm-022',1)
                  CANCEL DELETE
               END IF
#FUN-B80141----------beging-----------
#              SELECT count(*) INTO l_n FROM lml_file
#                WHERE lmlstore = g_lmc[l_ac].lmcstore  
#                  AND lml04 = g_lmc[l_ac].lmc02       
#                 AND lml05 = g_lmc[l_ac].lmc03
#               IF l_n > 0 THEN
#                  CALL cl_err('','alm-024',1)
#                  CANCEL DELETE
#               END IF
#FUN-B80141----------end-------------
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               ELSE 
                  IF l_lock_sw = "Y" THEN 
                      CALL cl_err("", -263, 1) 
                      CANCEL DELETE 
                  END IF 
#TQC-C30111 mark begin ---
#   #FUN-B80141  ----------begin-----------
#                  SELECT count(*) INTO l_n
#                    FROM lmy_file
#                   WHERE lmystore = g_lmcstore
#                     AND lmy01 = g_lmc02
#                     AND lmy02 = g_lmc[l_ac].lmc03   
#                  IF l_n > 0 THEN
#                     CALL cl_err('','alm-773',0)
#                     CANCEL DELETE  
#                  END IF
#   #FUN-B80141  ----------end------------
#TQC-C30111 mark end ----                  
   #              DELETE FROM lmc_file WHERE lmcstore = g_lmc_t.lmcstore #FUN-B80141  mark
   #                                     AND lmc02 = g_lmc_t.lmc02       #FUN-B80141  mark
                  DELETE FROM lmc_file WHERE lmcstore = g_lmcstore_t     #FUN-B80141
                                         AND lmc02 = g_lmc02_t           #FUN-B80141
                                         AND lmc03 = g_lmc_t.lmc03
                  IF SQLCA.sqlcode THEN
   #                  CALL cl_err3("del","lmc_file",g_lmc_t.lmcstore,"",SQLCA.sqlcode,"","",1)  #FUN-B80141  mark
                      CALL cl_err3("del","lmc_file",g_lmcstore_t,"",SQLCA.sqlcode,"","",1) #FUN-B80141
                      ROLLBACK WORK
                      CANCEL DELETE
                  ELSE 
                     LET g_rec_b=g_rec_b-1
                     DISPLAY g_rec_b TO FORMONLY.cn2
                     MESSAGE "Delete OK" 
                     CLOSE i120_bcl     
                     COMMIT WORK
                  END IF
               END IF 
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lmc[l_ac].* = g_lmc_t.*
              CLOSE i120_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
#             CALL cl_err(g_lmc[l_ac].lmcstore,-263,1) #FUN-B80141  mark
              CALL cl_err(g_lmcstore,-263,1)           #FUN-B80141
              LET g_lmc[l_ac].* = g_lmc_t.*
           ELSE
#             UPDATE lmc_file SET lmcstore = g_lmc[l_ac].lmcstore, #FUN-B80141  mark
#                                 lmclegal = g_lmc[l_ac].lmclegal, #FUN-B80141  mark
#                                 lmc02 = g_lmc[l_ac].lmc02,       #FUN-B80141  mark 
              UPDATE lmc_file SET                                  #FUN-B80141
                                  lmc03 = g_lmc[l_ac].lmc03,
                                  lmc04 = g_lmc[l_ac].lmc04,
                                  lmc05 = g_lmc[l_ac].lmc05,
                                  lmc06 = g_lmc[l_ac].lmc06,
                                  lmc08 = g_lmc[l_ac].lmc08,
                                  lmc09 = g_lmc[l_ac].lmc09,
                                  lmc11 = g_lmc[l_ac].lmc11,
                                  lmc12 = g_lmc[l_ac].lmc12,
                                  lmc10 = g_lmc[l_ac].lmc10,
                                  lmc07 = g_lmc[l_ac].lmc07
#                           WHERE lmcstore = g_lmc_t.lmcstore      #FUN-B80141  mark
#                             AND lmc02 = g_lmc_t.lmc02            #FUN-B80141  mark
                            WHERE lmcstore = g_lmcstore_t          #FUN-B80141
                              AND lmc02 = g_lmc02_t                #FUN-B80141
                              AND lmc03 = g_lmc_t.lmc03
              IF SQLCA.sqlcode THEN
#                CALL cl_err3("upd","lmc_file",g_lmc_t.lmcstore,"",SQLCA.sqlcode,"","",1) #FUN-B80141  mark
                 CALL cl_err3("upd","lmc_file",g_lmcstore_t,"",SQLCA.sqlcode,"","",1) #FUN-B80141
                 LET g_lmc[l_ac].* = g_lmc_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i120_bcl
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                   LET g_lmc[l_ac].* = g_lmc_t.*
               #TQC-D40054--add--begin--
               ELSE
                  CALL g_lmc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #TQC-D40054--add--end----
               END IF
              #IF cl_null(g_lmc[l_ac].lmc03) THEN  #TQC-D40054 mark
              #   CALL g_lmc.deleteElement(l_ac)   #TQC-D40054 mark 
              #END IF                              #TQC-D40054 mark
               CLOSE i120_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
#FUN-B80141 add begin ---
            IF cl_null(g_lmc[l_ac].lmc03) THEN
               CALL g_lmc.deleteElement(l_ac)
            END IF 
#FUN-B80141 add end ---
            LET l_ac_t = l_ac 
            CLOSE i120_bcl
            COMMIT WORK 
 
        ON ACTION CONTROLO
        #   IF INFIELD(lmcstore) AND l_ac > 1 THEN  #MOD-AC0249 MARK
            IF l_ac > 1 THEN                        #MOD-AC0249 ADD
               LET g_lmc[l_ac].* = g_lmc[l_ac-1].*
        #      LET g_lmc[l_ac].lmcstore = NULL      #MOD-AC0249 MARK
        #      NEXT FIELD lmcstore                  #MOD-AC0249 MARK
            END IF
#MOD-AC0249-----------------mark---------------            
#        ON ACTION controlp
#         CASE
#            WHEN INFIELD(lmcstore)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_lmb"
#               LET g_qryparam.arg1 = g_lmc[l_ac].lmcstore
#               LET g_qryparam.default1 = g_lmc[l_ac].lmcstore
#               LET g_qryparam.default2 = g_lmc[l_ac].rtz13
#               LET g_qryparam.default3 = g_lmc[l_ac].lmc02
#               LET g_qryparam.default4 = g_lmc[l_ac].lmb03
#               CALL cl_create_qry() RETURNING g_lmc[l_ac].lmcstore,g_lmc[l_ac].rtz13,g_lmc[l_ac].lmc02,g_lmc[l_ac].lmb03
#               DISPLAY BY NAME g_lmc[l_ac].lmcstore,g_lmc[l_ac].rtz13,g_lmc[l_ac].lmc02,g_lmc[l_ac].lmb03
#               NEXT FIELD lmcstore
#            WHEN INFIELD(lmc02)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_lmb"
#               LET g_qryparam.arg1 = g_lmc[l_ac].lmcstore
#               LET g_qryparam.default1 = g_lmc[l_ac].lmcstore                      
#               LET g_qryparam.default2 = g_lmc[l_ac].rtz13                      
#               LET g_qryparam.default3 = g_lmc[l_ac].lmc02                      
#               LET g_qryparam.default4 = g_lmc[l_ac].lmb03                      
#               CALL cl_create_qry() RETURNING g_lmc[l_ac].lmcstore,g_lmc[l_ac].rtz13,g_lmc[l_ac].lmc02,g_lmc[l_ac].lmb03                                           
#               DISPLAY BY NAME g_lmc[l_ac].lmcstore,g_lmc[l_ac].rtz13,g_lmc[l_ac].lmc02,g_lmc[l_ac].lmb03
#               NEXT FIELD lmc02
#            OTHERWISE EXIT CASE
#         END CASE
#MOD-AC0249-----------------mark---------------
        ON ACTION CONTROLR
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
         
    END INPUT
    CLOSE i120_bcl
    COMMIT WORK
    CALL i120_b2_fill()
END FUNCTION
 
FUNCTION i120_lmc08(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1 
   DEFINE l_count    LIKE lmc_file.lmc08 
   DEFINE l_lmb07    LIKE lmb_file.lmb07
   LET g_errno = ''
   IF p_cmd = 'a' THEN
      SELECT SUM(lmc08) INTO l_count
        FROM lmc_file
       WHERE lmcstore = g_lmcstore
         AND lmc02 = g_lmc02
      IF cl_null(l_count) THEN
         LET l_count = 0
      END IF 
      LET l_count = l_count + g_lmc[l_ac].lmc08
   ELSE 
      IF p_cmd = 'u' THEN
         SELECT SUM(lmc08) INTO l_count
           FROM lmc_file
          WHERE lmcstore = g_lmcstore
            AND lmc02 = g_lmc02
            AND lmc03 <> g_lmc[l_ac].lmc03   
           IF cl_null(l_count) THEN
             LET l_count = 0
           END IF
           LET l_count = l_count + g_lmc[l_ac].lmc08
      END IF 
   END IF 
   SELECT lmb07 INTO l_lmb07
     FROM lmb_file
    WHERE lmbstore = g_lmcstore
      AND lmb02 = g_lmc02      
   IF l_count > l_lmb07 THEN
      LET g_errno = 'alm-774'
   END IF
END FUNCTION 

FUNCTION i120_lmc09(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_count    LIKE lmc_file.lmc09
   DEFINE l_lmb08    LIKE lmb_file.lmb08
   LET g_errno = ''
   IF p_cmd = 'a' THEN
      SELECT SUM(lmc09) INTO l_count
        FROM lmc_file
       WHERE lmcstore = g_lmcstore
         AND lmc02 = g_lmc02
      IF cl_null(l_count) THEN
         LET l_count = 0
      END IF
      LET l_count = l_count + g_lmc[l_ac].lmc09
   ELSE 
      IF p_cmd = 'u' THEN
         SELECT SUM(lmc09) INTO l_count
           FROM lmc_file
          WHERE lmcstore = g_lmcstore
            AND lmc02 = g_lmc02
            AND lmc03 <> g_lmc[l_ac].lmc03
         IF cl_null(l_count) THEN
            LET l_count = 0
         END IF
         LET l_count = l_count + g_lmc[l_ac].lmc09
      END IF
   END IF   
   SELECT lmb08 INTO l_lmb08
     FROM lmb_file
    WHERE lmbstore = g_lmcstore
      AND lmb02 = g_lmc02
   IF l_count > l_lmb08 THEN
      LET g_errno = 'alm-775'
   END IF
END FUNCTION

FUNCTION i120_lmcstore(p_cmd)
   DEFINE l_rtz01    LIKE rtz_file.rtz01 
   DEFINE l_azt02    LIKE azt_file.azt02
   DEFINE l_rtz13    LIKE rtz_file.rtz13,
          l_rtz28    LIKE rtz_file.rtz28,
        # l_rtzacti  LIKE rtz_file.rtzacti,           #FUN-A80148 mark by vealxu 
          l_azwacti  LIKE azw_file.azwacti,           #FUN-A80148 add  by vealxu
          l_lmb02    LIKE lmb_file.lmb02,
          l_lmb03    LIKE lmb_file.lmb03,
          l_lmb06    LIKE lmb_file.lmb06,
          p_cmd      LIKE type_file.chr1
 
   LET g_errno = ' '
#FUN-B80141--------------mark------------
#   IF NOT cl_null(g_lmc[l_ac].lmcstore) THEN
#      SELECT rtz01,rtz13,rtz28,azwacti                  #FUN-A80148 rtzacti ->azwacti mod by vealxu
#        INTO l_rtz01,l_rtz13,l_rtz28,l_azwacti          #FUN-A80148 l_rtzacti ->l_azwacti mod by vealxu
#        FROM rtz_file INNER JOIN azw_file               #FUN-A80148 add azw_file add by vealxu 
#          ON rtz01 = azw01                              #FUN-A80148 add by vealxu      
#       WHERE rtz01 = g_lmc[l_ac].lmcstore 
#      CASE 
#         WHEN SQLCA.SQLCODE = 100      LET g_errno = 'alm-001'
#                                       LET l_rtz13 = NULL
#       # WHEN l_rtzacti='N'            LET g_errno = '9028'         #FUN-A80148 mark by vealxu 
#         WHEN l_azwacti = 'N'          LET g_errno = '9028'         #FUN-A80148 add  by vealxu 
#         WHEN l_rtz28='N'              LET g_errno = 'alm-002'
#         WHEN l_rtz01 <> g_plant       LET g_errno = 'alm-376'
#         OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
#      END CASE
#   END IF
# 
#   IF NOT cl_null(g_lmc[l_ac].lmc02) THEN
#      SELECT lmb02,lmb03,lmb06
#        INTO l_lmb02,l_lmb03,l_lmb06
#        FROM lmb_file 
#       WHERE lmb02 = g_lmc[l_ac].lmc02
#         AND lmbstore = g_lmc[l_ac].lmcstore
#      CASE
#         WHEN SQLCA.SQLCODE = 100      LET g_errno = 'alm-904'
#                                       LET l_lmb02 = NULL
#                                       LET l_lmb03 = NULL
#         WHEN l_lmb06 = 'N'            LET g_errno = '9028'
#         OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
#      END CASE
#   END IF
# 
#   IF cl_null(g_errno) or p_cmd = 'd' THEN
#      SELECT azt02 INTO l_azt02 FROM azt_file
#       WHERE azt01 = g_lmc[l_ac].lmclegal
#      LET g_lmc[l_ac].azt02 = l_azt02
# 
#      LET g_lmc[l_ac].lmb03 = l_lmb03
#      LET g_lmc[l_ac].rtz13 = l_rtz13
#      DISPLAY BY NAME g_lmc[l_ac].rtz13,g_lmc[l_ac].lmb03,
#                      g_lmc[l_ac].azt02
#   END IF
#FUN-B80141--------------mark------------
#FUN-B80141--------------add------------
   IF NOT cl_null(g_lmcstore) THEN
      SELECT rtz01,rtz13,rtz28,azwacti       
        INTO l_rtz01,l_rtz13,l_rtz28,l_azwacti
        FROM rtz_file INNER JOIN azw_file    
          ON rtz01 = azw01                  
       WHERE rtz01 = g_lmcstore
      CASE
         WHEN SQLCA.SQLCODE = 100      LET g_errno = 'alm-001'
                                       LET l_rtz13 = NULL
         WHEN l_azwacti = 'N'          LET g_errno = '9028'       
         WHEN l_rtz28='N'              LET g_errno = 'alm-002'
         WHEN l_rtz01 <> g_plant       LET g_errno = 'alm-376'
         OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
   END IF

   IF NOT cl_null(g_lmc02) THEN
      SELECT lmb02,lmb03,lmb06
        INTO l_lmb02,l_lmb03,l_lmb06
        FROM lmb_file
       WHERE lmb02 = g_lmc02
         AND lmbstore = g_lmcstore
      CASE
         WHEN SQLCA.SQLCODE = 100      LET g_errno = 'alm-904'
                                       LET l_lmb02 = NULL
                                       LET l_lmb03 = NULL
         WHEN l_lmb06 = 'N'            LET g_errno = '9028'
         OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
   END IF

   IF cl_null(g_errno) or p_cmd = 'd' THEN
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_lmclegal
      LET g_azt02 = l_azt02
      LET g_lmb03 = l_lmb03
      LET g_rtz13 = l_rtz13
      DISPLAY g_rtz13 TO rtz13
      DISPLAY g_azt02 TO azt02
      DISPLAY g_lmb03 TO lmb03
   END IF
#FUN-B80141--------------add------------
END FUNCTION
 
FUNCTION i120_b_askkey()
    CLEAR FORM
    CALL g_lmc.clear()
    CONSTRUCT g_wc2 ON lmcstore,lmclegal,lmc02,lmc03,lmc04,lmc05,lmc06,lmc07
            FROM s_lmc[1].lmcstore,s_lmc[1].lmclegal,s_lmc[1].lmc02,
                 s_lmc[1].lmc03,s_lmc[1].lmc04,s_lmc[1].lmc05,s_lmc[1].lmc06,
                 s_lmc[1].lmc07
    LET g_lmcstore = NULL
    LET g_lmclegal = NULL
    LET g_lmc02 = NULL
    CONSTRUCT g_wc2 ON lmcstore,lmclegal,lmc02,lmc03,lmc04,lmc08,lmc09,lmc11,lmc12,
                      lmc06,lmc10,lmc05,lmc07
        FROM lmcstore,lmclegal,lmc02,s_lmc[1].lmc03,s_lmc[1].lmc04,s_lmc[1].lmc08,
             s_lmc[1].lmc09,s_lmc[1].lmc11,s_lmc[1].lmc12,
             s_lmc[1].lmc06,s_lmc[1].lmc10,s_lmc[1].lmc05,s_lmc[1].lmc07
 
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
         
      ON ACTION controlp
         CASE
            WHEN INFIELD(lmcstore)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_lmcstore"
               LET g_qryparam.where = " lmcstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmcstore
               NEXT FIELD lmcstore
            WHEN INFIELD(lmclegal)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmclegal"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lmcstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmclegal
               NEXT FIELD lmclegal
            WHEN INFIELD(lmc02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmc02"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lmcstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmc02
               NEXT FIELD lmc02
            WHEN INFIELD(lmc03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmc03"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lmcstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmc03
               NEXT FIELD lmc03
            OTHERWISE EXIT CASE
         END CASE
      
      ON ACTION qbe_select
         CALL cl_qbe_select() 
         
      ON ACTION qbe_save
	 CALL cl_qbe_save()
 
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b = 0
      RETURN
    END IF
    CALL i120_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i120_b_fill(p_wc2)
    DEFINE p_wc2     LIKE type_file.chr1000  
#   LET g_sql = "SELECT lmcstore,'',lmclegal,'',lmc02,'',lmc03,lmc04,lmc05,lmc06,lmc07",       #FUN-B80141   mark
    LET g_sql = "SELECT lmc03,lmc04,lmc08,lmc09,lmc11,lmc12,lmc06,lmc10,lmc05,lmc07",         #FUN-B80141
                " FROM lmc_file",
                " WHERE ", p_wc2 CLIPPED,
                "  AND  lmcstore = '",g_lmcstore,"'",
                "  AND  lmc02 = '",g_lmc02,"'",
                "  AND  lmclegal = '",g_lmclegal,"'",
                " ORDER BY lmcstore,lmc02,lmc03 "
    PREPARE i120_pb FROM g_sql
    DECLARE lmc_curs CURSOR FOR i120_pb
 
    CALL g_lmc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lmc_curs INTO g_lmc[g_cnt].*  
       IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
#FUN-B80141--------------mark------------
#       SELECT rtz13 INTO g_lmc[g_cnt].rtz13 FROM rtz_file
#       WHERE rtz01 = g_lmc[g_cnt].lmcstore
#       IF SQLCA.sqlcode THEN
#          CALL cl_err3("sel","rtz_file",g_lmc[g_cnt].rtz13,"",SQLCA.sqlcode,"","",0)
#          LET g_lmc[g_cnt].rtz13 = NULL
#       END IF 
#       SELECT lmb03 INTO g_lmc[g_cnt].lmb03 FROM lmb_file
#       WHERE lmb02 = g_lmc[g_cnt].lmc02
#         AND lmbstore = g_lmc[g_cnt].lmcstore
#       IF SQLCA.sqlcode THEN
#          CALL cl_err3("sel","rtz_file",g_lmc[g_cnt].lmb03,"",SQLCA.sqlcode,"","",0)
#          LET g_lmc[g_cnt].lmb03 = NULL
#       END IF     
#       SELECT azt02 INTO g_lmc[g_cnt].azt02 FROM azt_file
#        WHERE azt01 = g_lmc[g_cnt].lmclegal
#       IF SQLCA.sqlcode THEN
#          CALL cl_err3("sel","azt_file",g_lmc[g_cnt].azt02,"",SQLCA.sqlcode,"","",0)
#          LET g_lmc[g_cnt].azt02 = NULL
#       END IF
#FUN-B80141--------------mark------------
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_lmc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2   
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i120_bp(p_ud)
 
   DEFINE   p_ud   LIKE type_file.chr1    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lmc TO s_lmc.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
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
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
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
 
FUNCTION i120_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
#    CALL cl_set_comp_entry("lmcstore,lmc02,lmc03",TRUE)    #FUN-B80141  mark   
     CALL cl_set_comp_entry("lmc02",TRUE)          #FUN-B80141
  END IF
END FUNCTION 
 
FUNCTION i120_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN 
#    CALL cl_set_comp_entry("lmcstore,lmc02,lmc03",FALSE)               #FUN-B80141  mark
     CALL cl_set_comp_entry("lmc02",FALSE)                      #FUN-B80141
#  ELSE                                                                 #FUN-B80141  mark 
#     CALL cl_set_comp_entry("lmcstore,lmclegal,lmc02",TRUE)            #FUN-B80141  mark
  END IF
  CALL cl_set_comp_entry("lmcstore,lmclegal",FALSE)
END FUNCTION

#FUN-B80141 add begin ---
FUNCTION i120_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("lmc03",TRUE)
  END IF 
END FUNCTION

FUNCTION i120_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("lmc03",FALSE)
  END IF 
END FUNCTION
#FUN-B80141 add end ---

#FUN-870015
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
