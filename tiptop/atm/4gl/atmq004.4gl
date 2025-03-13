# Pattern name...: cnmi003.4gl
# Date & Author..: 2012/08/31 By Lee
#Modify.........: No.150819 15/08/19 By jiangln 增加栏位：扣帐资料否，异动单号，异动项次号；去掉右边整批撤销单价按钮
#Modify.........: No.150917 15/09/15 By caohp   部分条码编号的料件栏位为空

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE
    g_tlfb           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        tlfb06      LIKE tlfb_file.tlfb06,
        tlfb07      LIKE tlfb_file.tlfb07,
        tlfb08      LIKE tlfb_file.tlfb08,
        tlfb09      LIKE tlfb_file.tlfb09,
        tlfb10      LIKE tlfb_file.tlfb10,
        tlfb01      lIKE tlfb_file.tlfb01,
        ima01       LIKE ima_file.ima01, 
        ima02       LIKE ima_file.ima02, 
        tlfb05      LIKE tlfb_file.tlfb05,
        ima25       LIKE ima_file.ima25,
        tlfb14      LIKE tlfb_file.tlfb14,
        tlfb02      LIKE tlfb_file.tlfb02,
        tlfb03      LIKE tlfb_file.tlfb03,
        tlfb04      LIKE tlfb_file.tlfb04,
        edit13      LIKE type_file.chr50
       ,tlfb19      LIKE tlfb_file.tlfb19   #NO.150819
    #   ,tlfb905      LIKE tlfb_file.tlfb905 #NO.150819
    #   ,tlfb906      LIKE tlfb_file.tlfb906 #NO.150819
                    END RECORD,
    g_tlfb_t         RECORD                 #程式變數 (舊值)
        tlfb06      LIKE tlfb_file.tlfb06,
        tlfb07      LIKE tlfb_file.tlfb07,
        tlfb08      LIKE tlfb_file.tlfb08,
        tlfb09      LIKE tlfb_file.tlfb09,
        tlfb10      LIKE tlfb_file.tlfb10,
        tlfb01      lIKE tlfb_file.tlfb01,
        ima01       LIKE ima_file.ima01, 
        ima02       LIKE ima_file.ima02, 
        tlfb05      LIKE tlfb_file.tlfb05,
        ima25       LIKE ima_file.ima25,
        tlfb14      LIKE tlfb_file.tlfb14,
        tlfb02      LIKE tlfb_file.tlfb02,
        tlfb03      LIKE tlfb_file.tlfb03,
        tlfb04      LIKE tlfb_file.tlfb04,
        edit13      LIKE type_file.chr50
       ,tlfb19      LIKE tlfb_file.tlfb19 #NO.150819
   #    ,tlfb905      LIKE tlfb_file.tlfb905  #NO.150819
   #    ,tlfb906      LIKE tlfb_file.tlfb906  #NO.150819
                    END RECORD,
    g_wc,g_sql      STRING,        #TQC-630166    
    g_rec_b         LIKE type_file.num5,        #單身筆數             #No.FUN-680098  SMALLINT
    l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT  #No.FUN-680098  SMALLINT

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL       
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098  SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5     #NO:FUN-570108        #No.FUN-680098 SMALLINT
DEFINE g_argv1      LIKE tlfb_file.tlfb07

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
   OPEN WINDOW q004_w AT p_row,p_col
     WITH FORM "atm/42f/atmq004"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
   CALL cl_ui_init()
   
   CALL cl_set_comp_visible('edit13',FALSE)
   CALL cl_set_act_visible('detail',FALSE)
   
   IF NOT cl_null(g_argv1) THEN
      LET g_action_choice = "query"
      IF cl_chk_act_auth() THEN CALL q004_q() END IF
   END IF

   CALL q004_menu()

   CLOSE WINDOW q004_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

FUNCTION q004_menu()
DEFINE l_cmd  LIKE type_file.chr1000 
   WHILE TRUE
      CALL q004_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q004_q()
            END IF                           

         WHEN "help"      CALL cl_show_help()
         WHEN "exit"      EXIT WHILE
         WHEN "controlg"  CALL cl_cmdask()
         WHEN "detail"      CONTINUE WHILE

#mark NO.150819 start------         
#         WHEN "delete_b"
#             CALL delete_b()
#             CALL q004_b_fill(g_wc)
#mark NO.150819 end------

         WHEN "exporttoexcel"   #No:FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tlfb),'','')
            END IF

      END CASE
   END WHILE

END FUNCTION

#mark NO.150819 start-----
#FUNCTION delete_b()
#DEFINE  l_ac          LIKE type_file.num5
#DEFINE  l_sfuconf     LIKE sfu_file.sfuconf
#    LET l_ac = ARR_CURR()
#    IF g_tlfb[l_ac].tlfb07 NOT matches '[HA]' THEN 
#    	 RETURN
#    END IF
#    SELECT sfuconf INTO l_sfuconf FROM sfu_file WHERE sfu01 = g_tlfb[l_ac].tlfb07
#    IF l_sfuconf = 'Y' THEN
#    	 RETURN
#    END IF
#    IF cl_delh(0,0) THEN 
#       BEGIN WORK
#       DELETE FROM tlfb_file WHERE tlfb07 = g_tlfb[l_ac].tlfb07 AND tlfb08 = g_tlfb[l_ac].tlfb08 
#                             AND tlfb09 = g_tlfb[l_ac].tlfb09 AND tlfb10 = g_tlfb[l_ac].tlfb10
#       COMMIT WORK
#    END IF
#END FUNCTION
#mark NO.150819 end----------


FUNCTION q004_q()

   CALL q004_b_askkey()

END FUNCTION

FUNCTION q004_b_askkey()
   DEFINE g_tlfb07 LIKE tlfb_file.tlfb07
   DEFINE g_tlfb08 LIKE tlfb_file.tlfb08
   DEFINE g_tlfb09 LIKE tlfb_file.tlfb09
   DEFINE g_tlfb10 LIKE tlfb_file.tlfb10
   CLEAR FORM
   CALL g_tlfb.clear()
   
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " tlfb07 = '",g_argv1,"'"
      CALL q004_b_fill(g_wc)
      RETURN
   END IF
   
   CONSTRUCT g_wc ON  tlfb06,tlfb07,tlfb08,tlfb09,tlfb10,tlfb01,tlfb05,tlfb14,tlfb02,tlfb03,tlfb04   #NO.150819 add tlfb905,tlfb906           
                FROM  s_tlfb[1].tlfb06,s_tlfb[1].tlfb07,s_tlfb[1].tlfb08,s_tlfb[1].tlfb09,s_tlfb[1].tlfb10,
                s_tlfb[1].tlfb01,s_tlfb[1].tlfb05,s_tlfb[1].tlfb14,s_tlfb[1].tlfb02,s_tlfb[1].tlfb03,s_tlfb[1].tlfb04
                   #NO.150819 add
										   

       BEFORE CONSTRUCT
              CALL cl_qbe_init()
              
       ON ACTION CONTROLP
       	  CASE WHEN INFIELD(tlfb07)                                   
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_tlfb"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_tlfb[1].tlfb07
                WHEN INFIELD(tlfb09)                                   
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_tlfb09"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_tlfb[1].tlfb09
               WHEN INFIELD(tlfb01)                                   
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_tlfb01"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_tlfb[1].tlfb01
          
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


   CALL q004_b_fill(g_wc)

END FUNCTION

FUNCTION q004_b_fill(p_wc2)             
DEFINE p_wc2           STRING
DEFINE l_year      LIKE aba_file.aba03
DEFINE l_month     LIKE aba_file.aba04 
DEFINE l_ima25     LIKE ima_file.ima25 
DEFINE l_factor LIKE ecm_file.ecm59
DEFINE l_cnt    LIKE type_file.num5       
       
   LET g_sql = #" SELECT  tlfb06,tlfb07,tlfb08,tlfb09,tlfb10,tlfb01,","substr(tlfb01,0,instr(tlfb01,'%',1,1)-1), ",     #No.150917 mark by caohp 150917
               " SELECT  tlfb06,tlfb07,tlfb08,tlfb09,tlfb10,tlfb01,'',",      #No.150917 add by caohp 150917
               " '',tlfb05,'',tlfb14,tlfb02,tlfb03,tlfb04,'',tlfb19 ",   #NO.150819 add tlfb19,tlfb905,tlfb906    
               "   FROM tlfb_file ",
               "  WHERE  ",p_wc2 CLIPPED,
               "  ORDER BY 1"
   PREPARE q004_pb FROM g_sql
   DECLARE tlfb_curs CURSOR FOR q004_pb

   CALL g_tlfb.clear()

   LET g_cnt = 1
   MESSAGE "Searching!"

   FOREACH tlfb_curs INTO g_tlfb[g_cnt].* 
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      #No.150917 str:add by caohp 150917
      IF g_tlfb[g_cnt].ima01 IS NULL THEN
         SELECT INSTR(g_tlfb[g_cnt].tlfb01,'%') INTO l_cnt FROM DUAL
         IF l_cnt >= 1 THEN
            SELECT substr(g_tlfb[g_cnt].tlfb01,0,instr(g_tlfb[g_cnt].tlfb01,'%',1,1)-1) INTO g_tlfb[g_cnt].ima01 FROM DUAL 
            SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = g_tlfb[g_cnt].ima01
            IF l_cnt = 0 THEN
               LET g_tlfb[g_cnt].ima01 = NULL
            END IF
         END IF
      END IF
      IF g_tlfb[g_cnt].ima01 IS NULL THEN
         SELECT INSTR(g_tlfb[g_cnt].tlfb01,'.') INTO l_cnt FROM DUAL
         IF l_cnt >= 1 THEN
            SELECT substr(g_tlfb[g_cnt].tlfb01,0,instr(g_tlfb[g_cnt].tlfb01,'.',1,1)-1) INTO g_tlfb[g_cnt].ima01 FROM DUAL 
            SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = g_tlfb[g_cnt].ima01
            IF l_cnt = 0 THEN
               LET g_tlfb[g_cnt].ima01 = NULL
            END IF
         END IF
      END IF
      #No.150917 end:add by caohp 150917
      SELECT ima02,ima25 INTO g_tlfb[g_cnt].ima02,g_tlfb[g_cnt].ima25 FROM ima_file 
      #WHERE ima01 = substr(g_tlfb[g_cnt].tlfb01,0,instr(g_tlfb[g_cnt].tlfb01,'%',1,1)-1)      No.150917 mark by caohp 150917
      WHERE ima01 = g_tlfb[g_cnt].ima01
       
      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF

   END FOREACH

   CALL g_tlfb.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION q004_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       #No.FUN-680098 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
    #  RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tlfb TO s_tlfb.*  ATTRIBUTE(COUNT=g_rec_b)

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
#mark NO.150819 start-----         
#      ON ACTION delete_b
#         LET g_action_choice="delete_b"
#         EXIT DISPLAY   
#mark NO.150819 end-------         

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