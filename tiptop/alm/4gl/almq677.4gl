# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: almq677.4gl
# Descriptions...: 券狀態信息查詢作業
# Date & Author..: FUN-960134 09/11/06 By shiwuying
# Modify.........: No:TQC-A10170 10/01/29 By shiwuying 去掉自動帶出單身
# Modify.........: No.FUN-A80022 10/10/18 By vealxu add lqepos
# Modify.........: No:FUN-B50042 11/05/10 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-BC0048 12/01/18 by nanbing almq677接受券编号参数
# Modify.........: No.FUN-C70074 12/07/18 by pauline almt670 action 券狀態訊息查詢,當起/迄券號為null時,預設查詢全部的券資料
# Modify.........: No.FUN-CB0109 12/11/22 By Lori 新增贈券來源(lqe22),遞延金額(lqe23)
# Modify.........: No:FUN-D10040 13/01/18 By xumm 添加已用门店,已用日期栏位

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
     g_lqe          DYNAMIC ARRAY OF RECORD
        lqe01       LIKE lqe_file.lqe01,
        lqe02       LIKE lqe_file.lqe02,
        lpx02       LIKE lpx_file.lpx02,
        lqe03       LIKE lqe_file.lqe03,
        lrz02       LIKE lrz_file.lrz02,
        lqe17       LIKE lqe_file.lqe17,
        lqe22       LIKE lqe_file.lqe22,         #FUN-CB0109 add
        lqe23       LIKE lqe_file.lqe23,         #FUN-CB0109 add
        lqe20       LIKE lqe_file.lqe20,
        lqe21       LIKE lqe_file.lqe21,
        lqe04       LIKE lqe_file.lqe04,
        lqe05       LIKE lqe_file.lqe05,
        lqe06       LIKE lqe_file.lqe06,
        lqe07       LIKE lqe_file.lqe07,
        lqe08       LIKE lqe_file.lqe08,
        lqe09       LIKE lqe_file.lqe09,
        lqe10       LIKE lqe_file.lqe10,
        lqe11       LIKE lqe_file.lqe11,
        lqe12       LIKE lqe_file.lqe12,
        lqe24       LIKE lqe_file.lqe24,      #FUN-D10040 add
        lqe25       LIKE lqe_file.lqe25,      #FUN-D10040 add
        lqe13       LIKE lqe_file.lqe13,
        lqe14       LIKE lqe_file.lqe14,
        lqe15       LIKE lqe_file.lqe15,
        lqe16       LIKE lqe_file.lqe16,
        lqe18       LIKE lqe_file.lqe18,
        lqe19       LIKE lqe_file.lqe19
       ,lqepos      LIKE lqe_file.lqepos         #FUN-A80022 
                    END RECORD,
    g_lqe_t         RECORD
        lqe01       LIKE lqe_file.lqe01,
        lqe02       LIKE lqe_file.lqe02,
        lpx02       LIKE lpx_file.lpx02,
        lqe03       LIKE lqe_file.lqe03,
        lrz02       LIKE lrz_file.lrz02,
        lqe17       LIKE lqe_file.lqe17,
        lqe22       LIKE lqe_file.lqe22,         #FUN-CB0109 add
        lqe23       LIKE lqe_file.lqe23,         #FUN-CB0109 add
        lqe20       LIKE lqe_file.lqe20,
        lqe21       LIKE lqe_file.lqe21,
        lqe04       LIKE lqe_file.lqe04,
        lqe05       LIKE lqe_file.lqe05,
        lqe06       LIKE lqe_file.lqe06,
        lqe07       LIKE lqe_file.lqe07,
        lqe08       LIKE lqe_file.lqe08,
        lqe09       LIKE lqe_file.lqe09,
        lqe10       LIKE lqe_file.lqe10,
        lqe11       LIKE lqe_file.lqe11,
        lqe12       LIKE lqe_file.lqe12,
        lqe24       LIKE lqe_file.lqe24,      #FUN-D10040 add
        lqe25       LIKE lqe_file.lqe25,      #FUN-D10040 add
        lqe13       LIKE lqe_file.lqe13,
        lqe14       LIKE lqe_file.lqe14,
        lqe15       LIKE lqe_file.lqe15,
        lqe16       LIKE lqe_file.lqe16,
        lqe18       LIKE lqe_file.lqe18,
        lqe19       LIKE lqe_file.lqe19
       ,lqepos      LIKE lqe_file.lqepos     #FUN-A80022 
                    END RECORD,
        g_wc2,g_sql STRING,
        g_rec_b     LIKE type_file.num5, 
        l_ac        LIKE type_file.num5 

DEFINE   g_cnt      LIKE type_file.num10
DEFINE   g_i        LIKE type_file.num5
DEFINE g_argv1      LIKE lqe_file.lqe01       #FUN-BC0048 add
DEFINE g_argv2      LIKE lqe_file.lqe01       #FUN-BC0048 add
DEFINE g_argv3      LIKE type_file.chr1       #FUN-C70074 add  #判斷是否來自於其他程式串查進來
DEFINE g_argv4      LIKE lqe_file.lqe02       #FUN-C70074 add  #券種代號

MAIN

   OPTIONS                            
      INPUT NO WRAP              
   DEFER INTERRUPT 
   #FUN-BC0048 start ---   
   LET g_argv1=ARG_VAL(1)               
   LET g_argv2=ARG_VAL(2) 
   #FUN-BC0048 end ---  
   LET g_argv3 = ARG_VAL(3)  #FUN-C70074 add
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)  
         RETURNING g_time
   OPEN WINDOW q677_w AT 10,2 WITH FORM "alm/42f/almq677"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   #FUN-A8002 ----------------add start-----------------------
   IF g_aza.aza88 = 'Y' THEN
      CALL cl_set_comp_visible("lqepos",TRUE)
    ELSE
      CALL cl_set_comp_visible("lqepos",FALSE)
    END IF
    #FUN-A80022 ----------------add end -------------------
   CALL cl_set_comp_visible("lqepos",FALSE)  #NO.FUN-B50042 
   CALL cl_ui_init()
   #FUN-BC0048 start --- 
  #FUN-C70074 mark START
  #IF NOT cl_null(g_argv1)AND NOT cl_null(g_argv2) THEN
  #   LET g_wc2 = " lqe01 BETWEEN '",g_argv1,"' AND '",g_argv2,"' "  
  #   CALL q677_b_fill(g_wc2)  
  #END IF
  #FUN-C70074 mark END
    #FUN-BC0048 end ---  
  #FUN-C70074 add START 
   IF NOT cl_null(g_argv1) THEN
      IF cl_null(g_argv4) THEN
         SELECT lqe02 INTO g_argv4 FROM lqe_file WHERE lqe01 = g_argv1
      END IF 
      IF NOT cl_null(g_argv2) THEN
         LET g_wc2 = " lqe01 BETWEEN '",g_argv1,"' AND '",g_argv2,"' "
      ELSE 
         LET g_wc2 = " (lqe01 > '",g_argv1,"' OR lqe01 = '",g_argv1,"' )"
      END IF
   ELSE 
      IF NOT cl_null(g_argv2) THEN
         IF cl_null(g_argv4) THEN
            SELECT lqe02 INTO g_argv4 FROM lqe_file WHERE lqe01 = g_argv2
         END IF
         LET g_wc2 = " (lqe01 < '",g_argv2,"' OR lqe01 = '",g_argv2,"' )"
      END IF
   END IF
   IF NOT cl_null(g_argv4) THEN
      IF NOT cl_null(g_wc2) THEN
         LET g_wc2 = g_wc2 CLIPPED," AND lqe02 = '",g_argv4,"' "
      ELSE
         LET g_wc2 = " lqe02 = '",g_argv4,"' " 
      END IF
   END IF
   IF NOT cl_null(g_argv3) THEN
      IF cl_null(g_wc2) THEN
         LET g_wc2 = " 1=1" 
      END IF
      CALL q677_b_fill(g_wc2)
   END IF
  #FUN-C70074 add END
   LET g_wc2 = " 1=1"
#  CALL q677_b_fill(g_wc2) #No.TQC-A10170
   CALL q677_menu()
   CLOSE WINDOW q677_w                
   CALL  cl_used(g_prog,g_time,2)      
         RETURNING g_time
END MAIN

FUNCTION q677_menu()
  DEFINE l_cmd STRING
   WHILE TRUE
      CALL q677_bp("G")
      CASE g_action_choice
         WHEN "query"       
            IF cl_chk_act_auth() THEN
               CALL q677_q()
            END IF
         WHEN "output"      
            IF cl_chk_act_auth() THEN
            #  CALL q677_out()
            END IF

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"       
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_lqe[l_ac].lqe01 IS NOT NULL THEN
                  LET g_doc.column1 = "lqe01"
                  LET g_doc.value1 = g_lqe[l_ac].lqe01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lqe),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q677_q()
   CALL q677_b_askkey()
END FUNCTION

FUNCTION q677_b_askkey()
    CLEAR FORM
    CALL g_lqe.clear()

    CONSTRUCT g_wc2 ON lqe01,lqe02,lqe03,lqe17,lqe22,lqe23,lqe20,lqe21,lqe04,lqe05,lqe06,     #FUN-CB0109 add lqe22,lqe23
                       #lqe07,lqe08,lqe09,lqe10,lqe11,lqe12,lqe13,lqe14,lqe15,                #FUN-D10040 mark
                       lqe07,lqe08,lqe09,lqe10,lqe11,lqe12,lqe24,lqe25,lqe13,lqe14,lqe15,     #FUN-D10040 add
                       lqe16,lqe18,lqe19                                      #FUN-A80022 add lqepos 
         FROM s_lqe[1].lqe01,s_lqe[1].lqe02,s_lqe[1].lqe03,s_lqe[1].lqe17,
              s_lqe[1].lqe22,s_lqe[1].lqe23,                                  #FUN-CB0109 add
              s_lqe[1].lqe20,s_lqe[1].lqe21,s_lqe[1].lqe04,s_lqe[1].lqe05,
              s_lqe[1].lqe06,s_lqe[1].lqe07,s_lqe[1].lqe08,s_lqe[1].lqe09,
              #s_lqe[1].lqe10,s_lqe[1].lqe11,s_lqe[1].lqe12,s_lqe[1].lqe13,   #FUN-D10040 mark
              s_lqe[1].lqe10,s_lqe[1].lqe11,s_lqe[1].lqe12,s_lqe[1].lqe24,s_lqe[1].lqe25,s_lqe[1].lqe13, #FUN-D10040 add
              s_lqe[1].lqe14,s_lqe[1].lqe15,s_lqe[1].lqe16,s_lqe[1].lqe18,
              s_lqe[1].lqe19                                         #FUN-A80022 add lqepos #FUN-B50042 remove POS 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
          CASE
            WHEN INFIELD(lqe01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqe01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqe01
               NEXT FIELD lqe01
            WHEN INFIELD(lqe02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqe_2"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqe02
               NEXT FIELD lqe02
            WHEN INFIELD(lqe03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqe03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqe03
               NEXT FIELD lqe03
            WHEN INFIELD(lqe04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqe04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqe04
               NEXT FIELD lqe04
            WHEN INFIELD(lqe06)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqe06"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqe06
               NEXT FIELD lqe06
            WHEN INFIELD(lqe09)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqe09"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqe09
               NEXT FIELD lqe09
            WHEN INFIELD(lqe11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqe11"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqe11
               NEXT FIELD lqe11
            WHEN INFIELD(lqe13)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqe13"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqe13
               NEXT FIELD lqe13
            #FUN-D10040----add---str
            WHEN INFIELD(lqe24)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqe24"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqe24
               NEXT FIELD lqe24
            #FUN-D10040----add---end
            WHEN INFIELD(lqe15)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqe15"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqe15
               NEXT FIELD lqe15
            WHEN INFIELD(lqe18)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lqe18"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lqe18
               NEXT FIELD lqe18
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

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
	 CALL cl_qbe_save()

    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('lqeuser', 'lqegrup') 

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
   
   CALL q677_b_fill(g_wc2)
END FUNCTION

FUNCTION q677_b_fill(p_wc2)
DEFINE
    p_wc2           LIKE type_file.chr1000 

    LET g_sql =
        "SELECT lqe01,lqe02,'',lqe03,'',lqe17,lqe22,lqe23,lqe20,lqe21,lqe04,lqe05,lqe06,",    #FUN-CB0109 add lqe22,lqe23
        "       lqe07,lqe08,lqe09,lqe10,lqe11,lqe12,lqe24,lqe25,lqe13,lqe14,lqe15,",          #FUN-D10040 add lqe24,lqe25           
        "       lqe16,lqe18,lqe19,lqepos ",                                                   #FUN-A80022 add lqepos   
        " FROM lqe_file",
        " WHERE ", p_wc2 CLIPPED,                     
        " ORDER BY lqe01"

    PREPARE q677_pb FROM g_sql
    DECLARE lqe_curs CURSOR FOR q677_pb

    CALL g_lqe.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH lqe_curs INTO g_lqe[g_cnt].* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

        SELECT lpx02 INTO g_lqe[g_cnt].lpx02 FROM lpx_file
         WHERE lpx01 = g_lqe[g_cnt].lqe02
        SELECT lrz02 INTO g_lqe[g_cnt].lrz02 FROM lrz_file
         WHERE lrz01 = g_lqe[g_cnt].lqe03
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lqe.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION q677_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lqe TO s_lqe.* ATTRIBUTE(COUNT=g_rec_b)

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

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-960134
