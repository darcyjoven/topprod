# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aglq813.4gl
# Descriptions...: 帳別傳票拋轉記錄查詢aglq813
# Date & Author..: 12/07/26 By Lori #FUN-C40112

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
   g_abm          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
       abm01      LIKE abm_file.abm01,       #拋轉來源營運中心
       abm02      LIKE abm_file.abm02,       #拋轉來源帳別
       abm03      LIKE abm_file.abm03,       #拋轉來源傳票編號
       abm04      LIKE abm_file.abm04,       #拋轉目的營運中心
       abm05      LIKE abm_file.abm05,       #拋轉目的帳別
       abm06      LIKE abm_file.abm06,       #拋轉目的傳票編號
       abm07      LIKE abm_file.abm07,       #拋轉日期
       abm08      LIKE abm_file.abm08,       #拋轉時間
       abm09      LIKE abm_file.abm09        #拋轉人員代號
                  END RECORD,
   g_abm_t        RECORD                     #程式變數(Program Variables)
       abm01      LIKE abm_file.abm01,       #拋轉來源營運中心
       abm02      LIKE abm_file.abm02,       #拋轉來源帳別
       abm03      LIKE abm_file.abm03,       #拋轉來源傳票編號
       abm04      LIKE abm_file.abm04,       #拋轉目的營運中心
       abm05      LIKE abm_file.abm05,       #拋轉目的帳別
       abm06      LIKE abm_file.abm06,       #拋轉目的傳票編號
       abm07      LIKE abm_file.abm07,       #拋轉日期
       abm08      LIKE abm_file.abm08,       #拋轉時間
       abm09      LIKE abm_file.abm09        #拋轉人員代號
                  END RECORD,
   g_wc          STRING,
   g_sql         STRING,
   g_rec_b       LIKE type_file.num5,       #單身筆數
   l_ac          LIKE type_file.num5        #目前處理的ARRAY CNT
DEFINE g_forupd_sql  STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt         LIKE type_file.num10    
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose
DEFINE g_argv1    LIKE abm_file.abm01,
       g_argv2    LIKE abm_file.abm02,
       g_argv3    LIKE abm_file.abm03

MAIN
   DEFINE p_row      LIKE type_file.num5,
          p_col      LIKE type_file.num5
  
   OPTIONS                                          #改變一些系統預設值
       INPUT NO WRAP

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 5 LET p_col = 29
   
   OPEN WINDOW q813_w AT p_row,p_col WITH FORM "agl/42f/aglq813"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)

   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "abm01 ='",g_argv1,"' AND abm02 ='",g_argv2,"' AND abm03 ='",g_argv3,"'"
   END IF

   CALL q813_b_fill(g_wc)

   CALL q813_menu()
   CLOSE WINDOW q813_w 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION q813_menu()
   WHILE TRUE
      CALL q813_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q813_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL q813_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_abm[l_ac].abm01 IS NOT NULL THEN
                  LET g_doc.column1 = "abm01"
                  LET g_doc.value1 = g_abm[l_ac].abm01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_abm),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION q813_q()
   CALL q813_b_askkey()
END FUNCTION

FUNCTION q813_b()
DEFINE l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT
       l_n             LIKE type_file.num5,      #檢查重複用
       l_lock_sw       LIKE type_file.chr1,      #單身鎖住否
       p_cmd           LIKE type_file.chr1,      #處理狀態
       l_possible      LIKE type_file.num5,      #用來設定判斷重複的可能性
       l_allow_insert  LIKE type_file.chr1,      #可新增否
       l_allow_delete  LIKE type_file.chr1       #可刪除否
DEFINE l_giq04         LIKE giq_file.giq04

   IF s_shut(0) THEN RETURN END IF

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   CALL cl_opmsg('b')

   LET g_forupd_sql = " SELECT abm01,abm02,abm03,abm04,abm05,abm06,abm07,abm08,abm09",
                      "   FROM abm_file ",
                      "  WHERE abm01 = ? AND abm02 = ? AND abm03 = ? AND abm04 = ?",
                      "    AND abm05 = ? AND abm05 = ? AND abm06 = ? AND abm09 = ?",
                      "    AND abm09 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE q813_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
END FUNCTION

FUNCTION q813_b_askkey()
   DEFINE l_qrywhere STRING

   CLEAR FORM
   CALL g_abm.clear()

   CONSTRUCT g_wc ON abm02,abm03,abm05,abm06,abm07,abm08,abm09
                FROM s_abm[1].abm02,s_abm[1].abm03,s_abm[1].abm05,s_abm[1].abm06,s_abm[1].abm07,s_abm[1].abm08,s_abm[1].abm09

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

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(abm02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abm02
                  NEXT FIELD abm02
               WHEN INFIELD(abm03)
                  LET l_qrywhere = "abaacti='Y'"
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aba02"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abm03
                  NEXT FIELD abm03
               WHEN INFIELD(abm05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abm05
                  NEXT FIELD abm05
               WHEN INFIELD(abm06)
                  LET l_qrywhere = "abaacti='Y'"
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aba02"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO abm06
                  NEXT FIELD abm06
            END CASE
   END CONSTRUCT
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      LET g_rec_b = 0
      RETURN
   END IF
   
   CALL q813_b_fill(g_wc)
END FUNCTION  

FUNCTION q813_b_fill(p_wc2)              #BODY FILL UP
   DEFINE
      p_wc2     STRING

   LET g_sql = "SELECT abm01,abm02,abm03,abm04,abm05,abm06,abm07,abm08,abm09",
               "  FROM abm_file",
               " WHERE ", p_wc2 CLIPPED

   PREPARE q813_pb FROM g_sql
   DECLARE abm_curs CURSOR FOR q813_pb

   CALL g_abm.clear()

   LET g_cnt = 1
   MESSAGE "Searching!"

   FOREACH abm_curs INTO g_abm[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_abm.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION q813_bp(p_ud)
   DEFINE   p_ud  LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_abm TO s_abm.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

         ON ACTION query
            LET g_action_choice="query"
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
#FUN-C40112

