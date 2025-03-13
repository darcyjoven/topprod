# Pattern name...: ctmq001.4gl
# Date & Author..: by tianry  150722

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE
    g_ibb           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        ibb01    LIKE ibb_file.ibb01,
        ibb02    LIKE ibb_file.ibb02,
        ibb03    LIKE ibb_file.ibb03,
        ibb04    LIKE ibb_file.ibb04,
        ibb06    LIKE ibb_file.ibb06,
        ima02    LIKE ima_file.ima02, 
        ima021   LIKE ima_file.ima021,   
        ibb07    LIKE ibb_file.ibb07,
     #   ibb17    LIKE ibb_file.ibb17,
     #   ibb20    LIKE ibb_file.ibb20,
        ibbacti  LIKE ibb_file.ibbacti
                    END RECORD,
    g_ibb_t         RECORD                 #程式變數 (舊值)
        ibb01    LIKE ibb_file.ibb01,
        ibb02    LIKE ibb_file.ibb02,
        ibb03    LIKE ibb_file.ibb03,
        ibb04    LIKE ibb_file.ibb04,
        ibb06    LIKE ibb_file.ibb06,
        ima02    LIKE ima_file.ima02,    
        ima021   LIKE ima_file.ima021,
        ibb07    LIKE ibb_file.ibb07,
  #      ibb17    LIKE ibb_file.ibb17,
  #      ibb20    LIKE ibb_file.ibb20,
        ibbacti  LIKE ibb_file.ibbacti
                    END RECORD,
    g_wc,g_sql      STRING,        #TQC-630166    
    g_rec_b         LIKE type_file.num5,        #單身筆數             #No.FUN-680098  SMALLINT
    l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT  #No.FUN-680098  SMALLINT

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL       
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098  SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5     #NO:FUN-570108        #No.FUN-680098 SMALLINT
DEFINE g_argv1      LIKE ibb_file.ibb01

MAIN

DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680098  SMALLINT

   OPTIONS                               #改變一些系統預設值
      FORM LINE       FIRST + 2,         #畫面開始的位置
      MESSAGE LINE    LAST,              #訊息顯示的位置
      PROMPT LINE     LAST,              #提示訊息的位置
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CTM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   LET g_argv1=ARG_VAL(1)

   LET p_row = 4 LET p_col = 24
   OPEN WINDOW i601_w AT p_row,p_col
     WITH FORM "atm/42f/atmq001"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
   CALL cl_ui_init()
   
   CALL cl_set_comp_visible('ibb12',FALSE)
   CALL cl_set_act_visible('detail',FALSE)
   
   IF NOT cl_null(g_argv1) THEN
      LET g_action_choice = "query"
      IF cl_chk_act_auth() THEN CALL i601_q() END IF
   END IF

   CALL i601_menu()

   CLOSE WINDOW i601_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION i601_menu()
DEFINE l_cmd  LIKE type_file.chr1000 
   WHILE TRUE
      CALL i601_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i601_q()
            END IF                           

         WHEN "help"      CALL cl_show_help()
         WHEN "exit"      EXIT WHILE
         WHEN "controlg"  CALL cl_cmdask()
         WHEN "detail"      CONTINUE WHILE
         
#         WHEN "delete_b"
 #            CALL delete_b()
  #           CALL i601_b_fill(g_wc)

         WHEN "exporttoexcel"   #No:FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ibb),'','')
            END IF

      END CASE
   END WHILE

END FUNCTION

{FUNCTION delete_b()
DEFINE  l_ac          LIKE type_file.num5
DEFINE  l_sfuconf     LIKE sfu_file.sfuconf
    LET l_ac = ARR_CURR()
    IF g_ibb[l_ac].ibb00 NOT matches '[HA]' THEN 
    	 RETURN
    END IF
    SELECT sfuconf INTO l_sfuconf FROM sfu_file WHERE sfu01 = g_ibb[l_ac].ibb01
    IF l_sfuconf = 'Y' THEN
    	 RETURN
    END IF
    IF cl_delh(0,0) THEN 
       BEGIN WORK
       DELETE FROM ibb_file WHERE ibb01 = g_ibb[l_ac].ibb01 AND ibb02 = g_ibb[l_ac].ibb02
       COMMIT WORK
    END IF
END FUNCTION
}

FUNCTION i601_q()

   CALL i601_b_askkey()

END FUNCTION

FUNCTION i601_b_askkey()

   CLEAR FORM
   CALL g_ibb.clear()
   
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " ibb01 = '",g_argv1,"'"
      CALL i601_b_fill(g_wc)
      RETURN
   END IF
   
   CONSTRUCT g_wc ON  ibb01,ibb02,ibb03,ibb04,ibb06,ibb07,ibb17,ibb20,ibbacti
                FROM  s_ibb[1].ibb01,s_ibb[1].ibb02,s_ibb[1].ibb03,s_ibb[1].ibb04,
                      s_ibb[1].ibb06,s_ibb[1].ibb07,s_ibb[1].ibbacti

       BEFORE CONSTRUCT
              CALL cl_qbe_init()
              
       ON ACTION CONTROLP
       	  CASE WHEN INFIELD(ibb06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form ="q_ima"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_ibb[1].ibb06
                   NEXT FIELD ibb06
       	  END CASE
         
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
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


   CALL i601_b_fill(g_wc)

END FUNCTION

FUNCTION i601_b_fill(p_wc2)             
DEFINE p_wc2           STRING
DEFINE l_year      LIKE aba_file.aba03
DEFINE l_month     LIKE aba_file.aba04 
DEFINE l_ima25     LIKE ima_file.ima25 
DEFINE l_factor LIKE ecm_file.ecm59
DEFINE l_cnt    LIKE type_file.num5       
       
   LET g_sql = " SELECT  ibb01,ibb02,ibb03,ibb04, ",
	       "         ibb06,'','',ibb07, ",
               "         ibbacti  ",     
               "   FROM ibb_file  ",
               "  WHERE  ",p_wc2 CLIPPED,
               "  ORDER BY 1"
   PREPARE i601_pb FROM g_sql
   DECLARE ibb_curs CURSOR FOR i601_pb

   CALL g_ibb.clear()

   LET g_cnt = 1
   MESSAGE "Searching!"

   FOREACH ibb_curs INTO g_ibb[g_cnt].* 
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
       
      SELECT ima02,ima021 INTO g_ibb[g_cnt].ima02,g_ibb[g_cnt].ima021 FROM ima_file WHERE ima01 = g_ibb[g_cnt].ibb06
       
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

   END FOREACH

   CALL g_ibb.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION i601_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       #No.FUN-680098 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
    #  RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ibb TO s_ibb.*  ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
         ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
         
     # ON ACTION delete_b
      #   LET g_action_choice="delete_b"
       #  EXIT DISPLAY   
         

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION exporttoexcel   #No:FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---


   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION



 
 
