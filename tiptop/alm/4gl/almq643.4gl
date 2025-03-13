# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almq643.4gl
# Descriptions...: 積分月結查詢作業 
# Date & Author..: No.FUN-CB0091 12/11/19 By pauline 


DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_ltw               DYNAMIC ARRAY OF RECORD
            ltw01          LIKE ltw_file.ltw01,
            ltw02          LIKE ltw_file.ltw02,
            ltw03          LIKE ltw_file.ltw03,
            ltw04          LIKE ltw_file.ltw04,
            ltw05          LIKE ltw_file.ltw05 
                           END RECORD

DEFINE g_ltv               DYNAMIC ARRAY OF RECORD
            ltv04          LIKE ltv_file.ltv04,
            ltv05          LIKE ltv_file.ltv05,
            ltv06          LIKE ltv_file.ltv06,
            ltv07          LIKE ltv_file.ltv07,
            ltv08          LIKE ltv_file.ltv08 
                           END RECORD

DEFINE g_wc                STRING
DEFINE l_ac                LIKE type_file.num5
DEFINE l_ac2               LIKE type_file.num5
DEFINE g_cnt               LIKE type_file.num5
DEFINE g_rec_b             LIKE type_file.num5
DEFINE g_rec_b2            LIKE type_file.num5
MAIN
DEFINE p_row,p_col  LIKE type_file.num5
  
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF


   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 2 LET p_col = 3

   OPEN WINDOW q643_w AT p_row,p_col WITH FORM "alm/42f/almq643"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL q643_menu()

   CLOSE WINDOW q643_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION q643_menu()
  DEFINE l_cmd STRING
   WHILE TRUE
      CALL q643_bp("G")

      CASE g_action_choice

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q643_q()
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

        #WHEN "exporttoexcel"
        #   IF cl_chk_act_auth() THEN
        #     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ltw),'','')
        #   END IF

      END CASE
   END WHILE
END FUNCTION


FUNCTION q643_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTE(UNBUFFERED)
      DISPLAY ARRAY g_ltw TO s_ltw.* ATTRIBUTE(COUNT=g_rec_b) 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL q643_b2_fill()
            CALL cl_show_fld_cont()
      END DISPLAY

      DISPLAY ARRAY g_ltv TO s_ltv.* ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE ROW
            LET l_ac2 = ARR_CURR()
            CALL cl_show_fld_cont()
      END DISPLAY

      ON ACTION query
         LET g_action_choice="query"
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

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
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

     #ON ACTION related_document
     #   LET g_action_choice="related_document"
     #   EXIT DIALOG 

     #ON ACTION exporttoexcel
     #   LET g_action_choice = 'exporttoexcel'
     #   EXIT DIALOG 

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q643_q()
    CLEAR FORM
    CALL g_ltw.clear()
    CALL g_ltv.clear()

    CONSTRUCT g_wc ON ltw01,ltw02,ltw03,ltw04,ltw05
         FROM s_ltw[1].ltw01,s_ltw[1].ltw02,s_ltw[1].ltw03,
              s_ltw[1].ltw04,s_ltw[1].ltw05

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
          CASE
             WHEN INFIELD(ltw03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ltw03"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ltw03 
                NEXT FIELD ltw03             
             WHEN INFIELD(ltw04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ltw04"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ltw04
                NEXT FIELD ltw04 
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
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF

   CALL q643_b1_fill(g_wc)
   LET l_ac = 1 
   CALL q643_b2_fill()

END FUNCTION

#上單身資料填充
FUNCTION q643_b1_fill(p_wc)
DEFINE p_wc         STRING
DEFINE l_sql        STRING

   IF cl_null(p_wc) THEN LET p_wc = " 1=1 " END IF 
   LET l_sql = " SELECT ltw01,ltw02,ltw03,ltw04,ltw05 ",
               "   FROM ltw_file ",
               "     WHERE ",p_wc CLIPPED

   PREPARE q643_pb1 FROM l_sql
   DECLARE q643_cur1 CURSOR FOR q643_pb1

   MESSAGE "Searching!"
   LET g_cnt = 1
   FOREACH q643_cur1 INTO g_ltw[g_cnt].*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF 
   END FOREACH

   CALL g_ltw.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

#下單身姿料填充
FUNCTION q643_b2_fill()
DEFINE l_sql           STRING

   CALL g_ltv.clear()
   IF cl_null(l_ac) OR l_ac = 0 THEN RETURN END IF
   IF cl_null(g_ltw[l_ac].ltw01) THEN RETURN END IF
   IF cl_null(g_ltw[l_ac].ltw02) THEN RETURN END IF
   IF cl_null(g_ltw[l_ac].ltw03) THEN RETURN END IF
   

   LET l_sql = " SELECT ltv04,ltv05,ltv06,ltv07,ltv08 ",
               "   FROM ltv_file ",
               "   WHERE ltv01 = '",g_ltw[l_ac].ltw01,"'",
               "     AND ltv02 = '",g_ltw[l_ac].ltw02,"' ",
               "     AND ltv03 = '",g_ltw[l_ac].ltw03,"'",
               "     AND (ltv06 = '",g_ltw[l_ac].ltw04,"'",
               "            OR ltv07 = '",g_ltw[l_ac].ltw04,"' )"

   PREPARE q643_pb2 FROM l_sql
   DECLARE q643_cur2 CURSOR FOR q643_pb2

   MESSAGE "Searching!"
   LET g_cnt = 1
   FOREACH q643_cur2 INTO g_ltv[g_cnt].*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 ) 
         EXIT FOREACH
      END IF  
   END FOREACH

   CALL g_ltv.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cn3
   LET g_cnt = 0
   
END FUNCTION
#FUN-CB0091
