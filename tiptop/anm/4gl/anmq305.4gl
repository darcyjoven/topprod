# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: anmq305.4gl 
# Descriptions...: 銀行收款查詢作業
# Date & Author..: No.FUN-B30213 11/06/28 By lixia
# Modify.........: No.TQC-C50173 12/05/21 By lutingting 開放查詢,用參數管控ACTION 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nmu_hd        RECORD                       #單頭變數
        nmu03       LIKE nmu_file.nmu03,
        nmu04       LIKE nmu_file.nmu04,
        nmu05       LIKE nmu_file.nmu05
        END RECORD,
    g_nmu_hd_t      RECORD                       #單頭變數
        nmu03       LIKE nmu_file.nmu03,
        nmu04       LIKE nmu_file.nmu04,
        nmu05       LIKE nmu_file.nmu05
        END RECORD,    
    g_nmu           DYNAMIC ARRAY OF RECORD      #程式變數(單身)
        chk         LIKE type_file.chr1,    
        nmu24       LIKE nmu_file.nmu24,
        nmu01       LIKE nmu_file.nmu01,
        nmu02       LIKE nmu_file.nmu02,
        nmu15       LIKE nmu_file.nmu15,
        nmu06       LIKE nmu_file.nmu06,
        nmu19       LIKE nmu_file.nmu19,
        nmu20       LIKE nmu_file.nmu20,
        nmu08       LIKE nmu_file.nmu08,
        nmu09       LIKE nmu_file.nmu09,
        nmu10       LIKE nmu_file.nmu10,
        nmu11       LIKE nmu_file.nmu11,
        nmu13       LIKE nmu_file.nmu13,
        nmu14       LIKE nmu_file.nmu14,
        nmu16       LIKE nmu_file.nmu16,
        nmu12       LIKE nmu_file.nmu12,
        nmu22       LIKE nmu_file.nmu22,
        nmu23       LIKE nmu_file.nmu23,
        nmuud01     LIKE nmu_file.nmuud01,
        nmuud02     LIKE nmu_file.nmuud02,
        nmuud03     LIKE nmu_file.nmuud03,
        nmuud04     LIKE nmu_file.nmuud04,
        nmuud05     LIKE nmu_file.nmuud05,
        nmuud06     LIKE nmu_file.nmuud06,
        nmuud07     LIKE nmu_file.nmuud07,
        nmuud08     LIKE nmu_file.nmuud08,
        nmuud09     LIKE nmu_file.nmuud09,
        nmuud10     LIKE nmu_file.nmuud10,
        nmuud11     LIKE nmu_file.nmuud11,
        nmuud12     LIKE nmu_file.nmuud12,
        nmuud13     LIKE nmu_file.nmuud13,
        nmuud14     LIKE nmu_file.nmuud14,
        nmuud15     LIKE nmu_file.nmuud15
        END RECORD,
    g_nmu_t         RECORD                       #程式變數(舊值)
        chk         LIKE type_file.chr1,     
        nmu24       LIKE nmu_file.nmu24,
        nmu01       LIKE nmu_file.nmu01,
        nmu02       LIKE nmu_file.nmu02,
        nmu15       LIKE nmu_file.nmu15,
        nmu06       LIKE nmu_file.nmu06,
        nmu19       LIKE nmu_file.nmu19,
        nmu20       LIKE nmu_file.nmu20,
        nmu08       LIKE nmu_file.nmu08,
        nmu09       LIKE nmu_file.nmu09,
        nmu10       LIKE nmu_file.nmu10,
        nmu11       LIKE nmu_file.nmu11,
        nmu13       LIKE nmu_file.nmu13,
        nmu14       LIKE nmu_file.nmu14,
        nmu16       LIKE nmu_file.nmu16,
        nmu12       LIKE nmu_file.nmu12,
        nmu22       LIKE nmu_file.nmu22,
        nmu23       LIKE nmu_file.nmu23,
        nmuud01     LIKE nmu_file.nmuud01,
        nmuud02     LIKE nmu_file.nmuud02,
        nmuud03     LIKE nmu_file.nmuud03,
        nmuud04     LIKE nmu_file.nmuud04,
        nmuud05     LIKE nmu_file.nmuud05,
        nmuud06     LIKE nmu_file.nmuud06,
        nmuud07     LIKE nmu_file.nmuud07,
        nmuud08     LIKE nmu_file.nmuud08,
        nmuud09     LIKE nmu_file.nmuud09,
        nmuud10     LIKE nmu_file.nmuud10,
        nmuud11     LIKE nmu_file.nmuud11,
        nmuud12     LIKE nmu_file.nmuud12,
        nmuud13     LIKE nmu_file.nmuud13,
        nmuud14     LIKE nmu_file.nmuud14,
        nmuud15     LIKE nmu_file.nmuud15
        END RECORD,
    g_wc            STRING,                      #WHERE CONDITION
    g_sql           STRING,   
    g_rec_b         LIKE type_file.num5,         #單身筆數
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT
DEFINE   g_msg1,g_msg2,g_msg3,g_msg4 LIKE ze_file.ze03    
DEFINE   g_before_input_done LIKE type_file.num5
DEFINE   g_forupd_sql STRING                     #SELECT ... FOR UPDATE  SQL
DEFINE   g_sql_tmp    STRING
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   g_chr          LIKE type_file.chr1
DEFINE   g_i            LIKE type_file.num5      #count/index for any purpose
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   g_cmd          LIKE type_file.chr1000
DEFINE   g_payee        LIKE type_file.num20_6
DEFINE   g_payer        LIKE type_file.num20_6
DEFINE   l_channel      base.Channel            
 
MAIN
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
                                                                                
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log                                          
                                                                                
    IF (NOT cl_setup("ANM")) THEN                                               
       EXIT PROGRAM                                                             
    END IF
 
   #TQC-C50173--mark--str--   
   #IF g_aza.aza73 = 'N' THEN
   #   CALL cl_err('','anm-980',1)
   #   EXIT PROGRAM
   #END IF
   #TQC-C50173--mark--end
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
     
    INITIALIZE g_nmu_hd.* to NULL
    INITIALIZE g_nmu_hd_t.* to NULL
 
    LET g_forupd_sql = "SELECT nmu03,nmu04,nmu05 FROM nmu_file WHERE nmu03 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE q305_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW q305_w WITH FORM "anm/42f/anmq305"
       ATTRIBUTE(STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()         
 
    #TQC-C50173--add--str--
    IF g_aza.aza73 = 'N' THEN
       CALL cl_set_act_visible("online_download_bill,induct_the_bill,change_sheet",FALSE)
    END IF 
    #TQC-C50173--add--end
    LET g_action_choice = ""                                              
    CALL q305_menu()  
    CLOSE WINDOW q305_w                         #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q305_curs()
    CLEAR FORM #清除畫面
    CALL cl_opmsg('q')
    CALL cl_set_head_visible("","YES")
   INITIALIZE g_nmu_hd.* TO NULL    
    CONSTRUCT g_wc ON nmu03,nmu04,nmu05,nmu24,nmu01,nmu02, # 螢幕上取條件
                      nmu15,nmu06,nmu08,nmu09,nmu10,nmu11,
                      nmu13,nmu14,nmu16,nmu12,nmu22,nmu23,
                      nmuud01,nmuud02,nmuud03,nmuud04,nmuud05,
                      nmuud06,nmuud07,nmuud08,nmuud09,nmuud10,
                      nmuud11,nmuud12,nmuud13,nmuud14,nmuud15
         FROM nmu03,nmu04,nmu05,s_nmu[1].nmu24,s_nmu[1].nmu01,s_nmu[1].nmu02,          
              s_nmu[1].nmu15,s_nmu[1].nmu06,s_nmu[1].nmu08,
              s_nmu[1].nmu09,s_nmu[1].nmu10,s_nmu[1].nmu11,
              s_nmu[1].nmu13,s_nmu[1].nmu14,s_nmu[1].nmu16,
              s_nmu[1].nmu12,s_nmu[1].nmu22,s_nmu[1].nmu23,
              s_nmu[1].nmuud01,s_nmu[1].nmuud02,s_nmu[1].nmuud03,
              s_nmu[1].nmuud04,s_nmu[1].nmuud05,s_nmu[1].nmuud06,
              s_nmu[1].nmuud07,s_nmu[1].nmuud08,s_nmu[1].nmuud09,
              s_nmu[1].nmuud10,s_nmu[1].nmuud11,s_nmu[1].nmuud12,
              s_nmu[1].nmuud13,s_nmu[1].nmuud14,s_nmu[1].nmuud15
 
         BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(nmu03)
                  CALL cl_init_qry_var()    
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_nma"                              
                  CALL cl_create_qry() RETURNING g_qryparam.multiret       
                  DISPLAY g_qryparam.multiret TO nmu03
            END CASE
 
         ON IDLE g_idle_seconds                                              
            CALL cl_on_idle()                                                
 
         ON ACTION qbe_select
            CALL cl_qbe_select() 
 
         ON ACTION qbe_save
            CALL cl_qbe_save() 
            CONTINUE CONSTRUCT                                               
 
         ON ACTION about         
            CALL cl_about()      
    
         ON ACTION help          
            CALL cl_show_help()  
    
         ON ACTION controlg      
            CALL cl_cmdask()     
 
    END CONSTRUCT   
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 
 
    IF INT_FLAG THEN 
        CALL q305_show()
        RETURN
    END IF
 
    LET g_sql = "SELECT UNIQUE nmu03 ",
                "  FROM nmu_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY nmu03"
    PREPARE q305_prepare FROM g_sql
    DECLARE q305_cs                              #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q305_prepare
 
    LET g_sql_tmp = "SELECT UNIQUE nmu03 ",
                    "  FROM nmu_file ",
                    " WHERE ", g_wc CLIPPED,
                    " INTO TEMP x "
    DROP TABLE x
    PREPARE q305_pre_x FROM g_sql_tmp
    EXECUTE q305_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE q305_precnt FROM g_sql
    DECLARE q305_cnt CURSOR FOR q305_precnt
END FUNCTION
 
FUNCTION q305_menu()
   WHILE TRUE
      CALL q305_bp("G")
      CASE g_action_choice
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL q305_q()
           END IF
        WHEN "online_download_bill"
           IF cl_chk_act_auth() THEN
              CALL q305_odb()
           END IF
        WHEN "induct_the_bill"
           IF cl_chk_act_auth() THEN
              CALL q305_itb()
           END IF        
        WHEN "change_sheet"
           IF cl_chk_act_auth() THEN
              CALL q305_chg()
           END IF
        WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL q305_b()
            ELSE
               LET g_action_choice = NULL
            END IF   
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION q305_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index, g_row_count)
    INITIALIZE g_nmu_hd TO NULL
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_nmu.clear() 
    DISPLAY '     ' TO FORMONLY.cnt
    CALL q305_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN q305_cs                                 # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_nmu_hd TO NULL
    ELSE
        OPEN q305_cnt
        FETCH q305_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL q305_fetch('F')                     # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION q305_fetch(p_flag)
    DEFINE p_flag   LIKE type_file.chr1       #處理方式
    
    CASE p_flag
        WHEN 'N' FETCH NEXT     q305_cs INTO g_nmu_hd.nmu03
        WHEN 'P' FETCH PREVIOUS q305_cs INTO g_nmu_hd.nmu03
        WHEN 'F' FETCH FIRST    q305_cs INTO g_nmu_hd.nmu03
        WHEN 'L' FETCH LAST     q305_cs INTO g_nmu_hd.nmu03
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
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump q305_cs INTO g_nmu_hd.nmu03
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmu_hd.nmu03, SQLCA.sqlcode, 0)
        INITIALIZE g_nmu_hd.* TO NULL
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
    END IF
    SELECT UNIQUE nmu03,nmu04,nmu05 INTO g_nmu_hd.nmu03,g_nmu_hd.nmu04,g_nmu_hd.nmu05
      FROM nmu_file
     WHERE nmu03 = g_nmu_hd.nmu03
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","nmu_file",g_nmu_hd.nmu03,"",SQLCA.sqlcode,"","",1)
        INITIALIZE g_nmu TO NULL
        RETURN
    END IF
    CALL q305_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION q305_show()
   DEFINE l_nma02   LIKE nma_file.nma02
   DEFINE l_nmt02   LIKE nmt_file.nmt02   
   
   LET g_nmu_hd_t.* = g_nmu_hd.*                                 #保存單頭舊值
   DISPLAY BY NAME g_nmu_hd.nmu03,g_nmu_hd.nmu04,g_nmu_hd.nmu05  #顯示單頭值
                    
   SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01 = g_nmu_hd.nmu03
   SELECT nmt02 INTO l_nmt02 FROM nmt_file WHERE nmt01 = g_nmu_hd.nmu04
   DISPLAY l_nma02 TO FORMONLY.nma02
   DISPLAY l_nmt02 TO FORMONLY.nmt02
   CALL q305_b_fill(g_wc) #單身
   CALL cl_show_fld_cont()                  
END FUNCTION

#單身填充 
FUNCTION q305_b_fill(p_wc2)
   DEFINE p_wc2    STRING
   DEFINE l_sql    STRING 
   DEFINE l_cnt    LIKE type_file.num5
          
    IF cl_null(p_wc2) THEN
       LET p_wc2 = " 1=1 "
    END IF   
    LET g_sql = "SELECT 'N',nmu24,nmu01,nmu02,nmu15,nmu06,nmu19,nmu20,nmu08,nmu09,nmu10,", 
                "       nmu11,nmu13,nmu14,nmu16,nmu12,nmu22,nmu23,nmuud01,nmuud02,",
                "       nmuud03,nmuud04,nmuud05,nmuud06,nmuud07,nmuud08,nmuud09,nmuud10,",                      
                "       nmuud11,nmuud12,nmuud13,nmuud14,nmuud15",
                "  FROM nmu_file",
                " WHERE nmu03 = '", g_nmu_hd.nmu03, "'",
	            "   AND ", p_wc2 CLIPPED,
                " ORDER BY nmu01,nmu02"
    PREPARE q305_pb FROM g_sql        
    DECLARE q305_bcs CURSOR FOR q305_pb      
 
    CALL g_nmu.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    LET g_payee = 0
    LET g_payer = 0
    FOREACH q305_bcs INTO g_nmu[g_cnt].*         #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF cl_null(g_nmu[g_cnt].nmu24) THEN 
           LET g_Nmu[g_cnt].nmu24 = 'N'
        END IF
        IF g_nmu[g_cnt].nmu09 = 1 THEN
           IF NOT cl_null(g_nmu[g_cnt].nmu10) THEN
              LET g_payee = g_payee + g_nmu[g_cnt].nmu10
           END IF
        END IF
        IF g_nmu[g_cnt].nmu09 = -1 THEN
           IF NOT cl_null(g_nmu[g_cnt].nmu10) THEN
              LET g_payer = g_payer + g_nmu[g_cnt].nmu10
           END IF
        END IF
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
        END IF
    END FOREACH
    CALL g_nmu.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    DISPLAY g_payee TO FORMONLY.payee_amount
    DISPLAY g_payer TO FORMONLY.payer_amount
    LET g_cnt = 0

    IF g_rec_b > 0 THEN
       DROP TABLE nmu_tmp1
       CREATE TEMP TABLE nmu_tmp1(
                         chk   LIKE type_file.chr1,
                         nmu01 LIKE nmu_file.nmu01,
                         nmu09 LIKE nmu_file.nmu09,
                         nmu12 LIKE nmu_file.nmu12,
                         nmu14 LIKE nmu_file.nmu14,
                         nmu19 LIKE nmu_file.nmu19,
                         nmu23 LIKE nmu_file.nmu23)
       LET l_sql = " INSERT INTO nmu_tmp1 ",
                   " SELECT 'N',nmu01,nmu09,nmu12,nmu14,nmu19,nmu23 FROM nmu_file ",
                   "  WHERE nmu03 = '", g_nmu_hd.nmu03, "'",
	               "    AND ", p_wc2 CLIPPED
       PREPARE q305_pre_y FROM l_sql
       EXECUTE q305_pre_y 
    END IF   
    
END FUNCTION
 
#單身顯示
FUNCTION q305_bp(p_ud)
   DEFINE p_ud     LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " " 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmu TO s_nmu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL cl_show_fld_cont()    
      
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first 
         CALL q305_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                  
         EXIT DISPLAY              
 
      ON ACTION previous
         CALL q305_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
         EXIT DISPLAY                
 
      ON ACTION jump 
         CALL q305_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
         EXIT DISPLAY              
 
      ON ACTION next
         CALL q305_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
         EXIT DISPLAY              
 
      ON ACTION last 
         CALL q305_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
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

      ON ACTION detail                          
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit" 
         EXIT DISPLAY 
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION online_download_bill
         LET g_action_choice="online_download_bill"
         EXIT DISPLAY
 
      ON ACTION induct_the_bill
         LET g_action_choice="induct_the_bill"
         EXIT DISPLAY

      ON ACTION change_sheet  
         LET g_action_choice="change_sheet"
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
 
#單身
FUNCTION q305_b()
   DEFINE l_n    LIKE type_file.num5
   DEFINE l_i    LIKE type_file.num5
   DEFINE p_cmd  LIKE type_file.chr1 
   
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF 
   CALL cl_opmsg('b')   
   
   INPUT ARRAY g_nmu WITHOUT DEFAULTS FROM s_nmu.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
            INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)                   
            
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         
      BEFORE ROW
         LET l_ac = ARR_CURR() 
         LET l_n  = ARR_COUNT()  
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_nmu_t.* = g_nmu[l_ac].*
            CALL cl_show_fld_cont()
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR() 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nmu[l_ac].* = g_nmu_t.*
            END IF
            EXIT INPUT
         END IF
         IF g_nmu[l_ac].nmu09 = '1' THEN
            UPDATE nmu_tmp1 SET chk = g_nmu[l_ac].chk 
             WHERE nmu23 = g_nmu[l_ac].nmu23
         END IF   

      ON ACTION selectall
         FOR l_i = 1 TO g_rec_b
            LET g_nmu[l_i].chk = "Y"
         END FOR
         UPDATE nmu_tmp1 SET chk = "Y"

      ON ACTION select_none
         FOR l_i = 1 TO g_rec_b
            LET g_nmu[l_i].chk = "N"
         END FOR
         UPDATE nmu_tmp1 SET chk = "N"   
           
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
END FUNCTION 

#聯機下載對帳單 
FUNCTION q305_odb()
   DEFINE l_nmu03   LIKE nmu_file.nmu03
 
   CALL p305_tm(g_nmu_hd.nmu03,g_nmu_hd.nmu05,'','','') RETURNING l_nmu03         
   IF cl_null(l_nmu03) THEN
      RETURN
   ELSE
      LET g_nmu_hd.nmu03 = l_nmu03
      SELECT nmu04,nmu05 INTO g_nmu_hd.nmu04,g_nmu_hd.nmu05
        FROM nmu_file
       WHERE nmu03 = g_nmu_hd.nmu03
      CALL q305_show()
   END IF
END FUNCTION

#導入對帳單 
FUNCTION q305_itb()   
   DEFINE l_locale    STRING  #路径
   DEFINE l_file      STRING  #文件名
   DEFINE l_str       LIKE type_file.chr4 #文件类型
   DEFINE l_cmd       LIKE type_file.chr1000
   DEFINE li_status   LIKE type_file.num10
   DEFINE tok         base.StringTokenizer
   DEFINE l_loc       STRING
   DEFINE l_str1      STRING
   DEFINE l_str2      STRING
   DEFINE i,j,k,l     LIKE type_file.num5
   DEFINE l_nmu       RECORD LIKE nmu_file.*
   DEFINE l_n         LIKE type_file.num5
   DEFINE g_read      base.Channel
   DEFINE l_i         LIKE type_file.num5 
   DEFINE l_year      LIKE type_file.chr4
   DEFINE l_month     LIKE type_file.chr4
   DEFINE l_day       LIKE type_file.chr4
   DEFINE l_dt        LIKE type_file.chr20
   DEFINE l_date1     LIKE type_file.chr20
   DEFINE l_time      LIKE type_file.chr20
   DEFINE l_nmu23     LIKE nmu_file.nmu23
   DEFINE l_sql       STRING
   DEFINE l_noa       RECORD LIKE noa_file.*
   DEFINE l_noa05     LIKE noa_file.noa05 
   DEFINE l_noa02     LIKE noa_file.noa02 
   DEFINE l_nma01_1   LIKE nma_file.nma01 
   DEFINE l_nma01     LIKE nma_file.nma01
   DEFINE l_nma04     LIKE nma_file.nma04
   DEFINE l_nma10     LIKE nma_file.nma10
   DEFINE l_nma39     LIKE nma_file.nma39
   DEFINE l_nmaacti   LIKE nma_file.nmaacti
   DEFINE l_nma43     LIKE nma_file.nma43
   DEFINE l_nmr02     LIKE nmr_file.nmr02
   DEFINE l_nmr021    LIKE nmr_file.nmr02
   DEFINE l_nmr03     LIKE nmr_file.nmr03
   DEFINE l_nmr031    LIKE nmr_file.nmr03

   CREATE TEMP TABLE nmu_temp(
        nmu01    LIKE nmu_file.nmu01,
        nmu02    LIKE nmu_file.nmu02, 
        nmu03    LIKE nmu_file.nmu03, 
        nmu04    LIKE nmu_file.nmu04,
        nmu05    LIKE nmu_file.nmu05,
        nmu06    LIKE nmu_file.nmu06,
        nmu07    LIKE nmu_file.nmu07,
        nmu08    LIKE nmu_file.nmu08,
        nmu09    LIKE nmu_file.nmu09,
        nmu10    LIKE nmu_file.nmu10,
        nmu11    LIKE nmu_file.nmu11,
        nmu12    LIKE nmu_file.nmu12,
        nmu13    LIKE nmu_file.nmu13,
        nmu14    LIKE nmu_file.nmu14,
        nmu15    LIKE nmu_file.nmu15,
        nmu16    LIKE nmu_file.nmu16,
        nmu17    LIKE nmu_file.nmu17,
        nmu18    LIKE nmu_file.nmu18,
        nmu19    LIKE nmu_file.nmu19,
        nmu20    LIKE nmu_file.nmu20,
        nmu21    LIKE nmu_file.nmu21,
        nmu22    LIKE nmu_file.nmu22,
        nmu23    LIKE nmu_file.nmu23,
        nmu24    LIKE nmu_file.nmu24,
        nmuud01  LIKE nmu_file.nmuud01,
        nmuud02  LIKE nmu_file.nmuud02,
        nmuud03  LIKE nmu_file.nmuud03,
        nmuud04  LIKE nmu_file.nmuud04,
        nmuud05  LIKE nmu_file.nmuud05,
        nmuud06  LIKE nmu_file.nmuud06,
        nmuud07  LIKE nmu_file.nmuud07,
        nmuud08  LIKE nmu_file.nmuud08,
        nmuud09  LIKE nmu_file.nmuud09,
        nmuud10  LIKE nmu_file.nmuud10,
        nmuud11  LIKE nmu_file.nmuud11,
        nmuud12  LIKE nmu_file.nmuud12,
        nmuud13  LIKE nmu_file.nmuud13,
        nmuud14  LIKE nmu_file.nmuud14,
        nmuud15  LIKE nmu_file.nmuud15,
        nmulegal LIKE nmu_file.nmulegal)
   DELETE FROM nmu_temp    

   LET l_noa05 = ''
   LET l_noa02 = ''
   LET l_nma01_1 = ''
   INITIALIZE l_noa.* TO NULL
   INITIALIZE l_locale TO NULL
   
   #輸入交易類型
   CALL q305_info()  RETURNING l_nma01_1,l_noa05,l_noa02
   IF cl_null(l_noa05) OR cl_null(l_noa02) THEN
      CALL cl_err("","anm1038",1)
      RETURN
   END IF
   
   #獲取文件及路徑   
   LET l_locale = cl_browse_file()
   IF cl_null(l_locale) THEN
      CALL cl_msgany(10,10,'give up!')
      RETURN
   END IF

   #檢查文件類型   
   LET tok = base.StringTokenizer.create(l_locale,"/")
   WHILE tok.hasMoreTokens()
      LET l_loc = tok.nextToken()
   END WHILE  
   LET l_str = l_loc.subString(l_loc.getLength()-2,l_loc.getLength())
   IF l_str <> 'txt' AND l_str <> 'dat' AND l_str <> 'rpt' AND 
      l_str <> 'act' AND l_str <> 'csv' THEN
      CALL cl_err('','anm-975',1)
      RETURN
   END IF

   SELECT nma01,nmaacti,nma43 INTO l_nma01,l_nmaacti,l_nma43
     FROM nma_file
    WHERE nma01 = l_nma01_1
   IF SQLCA.sqlcode OR l_nmaacti <> 'Y' OR l_nma43 <> 'Y' THEN
      CALL cl_err('','anm-977',1)
      RETURN
   END IF
   
   IF l_nmr03 < l_nmr02 THEN
      CALL cl_err('','mfg9234',1)
      RETURN
   END IF
   SELECT nmr02,nmr03 INTO l_nmr021,l_nmr031
     FROM nmr_file
    WHERE nmr01 = l_nma01
   IF l_nmr02 = l_nmr021 AND l_nmr03 = l_nmr031 THEN
      IF NOT cl_confirm('anm-258') THEN
         RETURN
      END IF
   END IF
   IF l_nmr02 > l_nmr031 THEN
      CALL cl_getmsg('anm-254',g_lang) RETURNING g_msg2
      CALL cl_getmsg('anm-256',g_lang) RETURNING g_msg3
      LET g_msg4 = l_nmr031
      LET g_msg1 = g_msg2 CLIPPED,g_msg4 CLIPPED,g_msg3 CLIPPED  
      IF NOT cl_confirm(g_msg1) THEN
         RETURN
      END IF
   END IF
   IF l_nmr03 < l_nmr021 THEN
      CALL cl_getmsg('anm-255',g_lang) RETURNING g_msg2
      CALL cl_getmsg('anm-256',g_lang) RETURNING g_msg3
      LET g_msg4 = l_nmr021
      LET g_msg1 = g_msg2 CLIPPED,g_msg4 CLIPPED,g_msg3 CLIPPED  
      IF NOT cl_confirm(g_msg1) THEN
         RETURN
      END IF
   END IF
   
   #上傳文件
   LET l_file = "/tmp/",l_loc   
   CALL cl_upload_file(l_locale,l_file) RETURNING li_status
   IF NOT li_status THEN
      CALL cl_msgany(10,10,'upload fail!')
      RETURN
   END IF     

   SELECT noa_file.* INTO l_noa.* FROM noa_file,nma_file
    WHERE noa01 = nma47   AND nma01 = l_nma01_1
      AND nmaacti  = 'Y'  AND noa04 = '2'      
      AND noa02 = l_noa02 AND noa14='2'
      AND noa05 = l_noa05  
   IF cl_null(l_noa.noa01) THEN
      CALL cl_err(l_nma01_1,'anm1024',1)
      RETURN 
   END IF

   LET g_success = 'Y'
   CALL s_showmsg_init()    
   IF l_noa.noa06 = '1' THEN #xml
      CALL p305_fromXml(l_file,l_noa.*)
   ELSE
      LET g_read = base.Channel.create()
      CALL g_read.openFile(l_file,"r")
      WHILE TRUE
         LET l_str1 = ""
         LET l_str1 = g_read.readLine()
         LET l_str2 = l_str1.subString(l_str1.getLength(),l_str1.getLength())
         IF NOT cl_null(l_str1) AND l_str2 = '\r' THEN
            LET l_str1 = l_str1.subString(1,l_str1.getLength()-1)
         END IF
     
         IF cl_null(l_str1) AND l_str2 = '\r' THEN
            CONTINUE WHILE
         END IF
         IF cl_null(l_str1) AND cl_null(l_str2) THEN
            EXIT WHILE
         END IF
         CALL p305_fromStr(l_str1,l_noa.*)      
      END WHILE      
   END IF
   
   IF g_success = 'Y' THEN
      BEGIN WORK
      SELECT nma39,nma04,nma10 INTO l_nma39,l_nma04,l_nma10
        FROM nma_file
       WHERE nma01 = l_nma01  
     
      DECLARE q305_cs1 CURSOR FOR SELECT * FROM nmu_temp
      FOREACH q305_cs1 INTO l_nmu.*
         IF cl_null(l_nmu.nmu13) THEN
            LET l_nmu.nmu13 = ' '
         END IF
         SELECT COUNT(*) INTO l_n FROM nmu_file 
          WHERE nmu01 = l_nmu.nmu01 
            AND nmu16 = l_nmu.nmu16
            AND nmu13 = l_nmu.nmu13
            AND nmu03 = l_nma01
         IF l_n >0 THEN 
            CONTINUE FOREACH 
         ELSE 
            LET l_nmu.nmu03 = l_nma01
            LET l_nmu.nmu04 = l_nma39
            LET l_nmu.nmu05 = l_nma04
            LET l_nmu.nmu08 = l_nma10
            IF cl_null(l_nmu.nmu17) THEN 
               LET l_nmu.nmu17 = ' ' 
            END IF
            IF cl_null(l_nmu.nmu18) THEN 
               LET l_nmu.nmu18 = ' ' 
            END IF
            IF cl_null(l_nmu.nmu13) THEN 
               LET l_nmu.nmu13 = ' ' 
            END IF
            IF cl_null(l_nmu.nmu23) THEN  #流水號
               LET l_date1 = g_today
               LET l_year = YEAR(l_date1)USING '&&&&'
               LET l_month = MONTH(l_date1) USING '&&'
               LET l_day = DAY(l_date1) USING  '&&'
               LET l_time = TIME(CURRENT)
               LET l_dt  = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                           l_time[1,2],l_time[4,5],l_time[7,8]
               SELECT MAX(nmu23) + 1 INTO l_nmu.nmu23 FROM nmu_file
                WHERE nmu23[1,14] = l_dt
               IF cl_null(l_nmu.nmu23) THEN
                  LET l_nmu.nmu23 = l_dt,'000001'
               END IF
            END IF   
            LET l_nmu.nmulegal = g_legal 
            INSERT INTO nmu_file VALUES(l_nmu.*)
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('ins nmu','','',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF            
      END FOREACH
      IF g_success = 'Y' THEN
         SELECT COUNT(*) INTO l_n FROM nmr_file 
          WHERE nmr01 = l_nma01
         IF l_n = 0 THEN 
            INSERT INTO nmr_file VALUES(l_nma01,l_nmr02,l_nmr03,g_legal) #FUN-980005 add legal 
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('ins nmr','','',SQLCA.sqlcode,1)
               LET g_success = 'N' 
            END IF 
         ELSE
            CASE 
               WHEN l_nmr03 < l_nmr021  
                  UPDATE nmr_file SET nmr02 = l_nmr02,nmr03 = l_nmr03 
                   WHERE nmr01 = l_nma01
                  IF SQLCA.sqlcode THEN 
                     CALL s_errmsg('upd nmr','','',SQLCA.sqlcode,1)
                     LET g_success = 'N' 
                  END IF  
               WHEN l_nmr02 < l_nmr021 AND l_nmr03 >= l_nmr021 AND l_nmr03 <= l_nmr031
                  UPDATE nmr_file SET nmr02 = l_nmr02
                   WHERE nmr01 = l_nma01
                  IF SQLCA.sqlcode THEN 
                     CALL s_errmsg('upd nmr','','',SQLCA.sqlcode,1)
                     LET g_success = 'N' 
                  END IF 
               WHEN l_nmr03 > l_nmr031 AND l_nmr02 >= l_nmr021 AND l_nmr02 <= l_nmr031
                  UPDATE nmr_file SET nmr03 = l_nmr03
                   WHERE nmr01 = l_nma01
                  IF SQLCA.sqlcode THEN 
                     CALL s_errmsg('upd nmr','','',SQLCA.sqlcode,1)
                     LET g_success = 'N' 
                  END IF 
               WHEN l_nmr03 > l_nmr031 AND l_nmr02 < l_nmr021 
                  UPDATE nmr_file SET nmr02 = l_nmr02,
                                      nmr03 = l_nmr03
                   WHERE nmr01 = l_nma01
                  IF SQLCA.sqlcode THEN  
                     CALL s_errmsg('upd nmr','','',SQLCA.sqlcode,1)
                     LET g_success = 'N' 
                  END IF 
               OTHERWISE EXIT CASE 
            END CASE 
         END IF
      END IF
   END IF
   IF g_success = 'Y'  THEN   
      COMMIT WORK
   ELSE
      ROLLBACK WORK
      CALL s_showmsg()
   END IF   
   LET l_cmd = "rm ",l_file
   RUN l_cmd 

   LET g_nmu_hd.nmu03 = l_nmu.nmu03
   LET g_nmu_hd.nmu04 = l_nmu.nmu04
   LET g_nmu_hd.nmu05 = l_nmu.nmu05 
   LET g_wc = "nmu03 = '",l_nmu.nmu03,"'"
   IF cl_null(l_nmu.nmu03) THEN
      CLEAR FORM
      CALL cl_err('','anm-259',1)
   END IF 
   CALL q305_show()
   
END FUNCTION

#轉銀行收支單
FUNCTION q305_chg()
   DEFINE l_no          LIKE nmg_file.nmg00
   DEFINE l_nmg00       LIKE nmg_file.nmg00
   DEFINE li_result     LIKE type_file.num5
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_nmg         RECORD LIKE nmg_file.*
   DEFINE l_npk         RECORD LIKE npk_file.*
   DEFINE l_nmu         RECORD LIKE nmu_file.*
   DEFINE l_nmu01       LIKE nmu_file.nmu01
   DEFINE l_nmu12       LIKE nmu_file.nmu12
   DEFINE l_nmu19       LIKE nmu_file.nmu19
   DEFINE l_nmg23       LIKE nmg_file.nmg23 
   DEFINE l_nmg25       LIKE nmg_file.nmg25 
   DEFINE l_sql         STRING

   #1.輸入收支單別
   LET l_no = ''
   LET l_i = 0
   LET l_nmg00 = ''

   SELECT COUNT(*) INTO l_i FROM nmu_tmp1 
    WHERE nmu09 = '1' AND chk = 'Y' AND nmu14 IS NULL
   IF l_i < 1 THEN
      CALL cl_err("","aic-044",1)
      RETURN
   END IF 

   CALL q305_nmg00()  RETURNING l_no
   IF cl_null(l_no) THEN
      CALL cl_err("","anm-217",1)
      RETURN
   END IF

   LET g_success = 'Y' 
   BEGIN WORK
   CALL s_showmsg_init()
   LET l_sql = "SELECT DISTINCT nmu01,nmu12,nmu19 FROM nmu_tmp1 ",
               " WHERE chk = 'Y' AND nmu09 = '1' AND nmu14 IS NULL"
   PREPARE p100_nmg_pre FROM l_sql
   DECLARE p100_nmg_dec CURSOR FOR p100_nmg_pre            
   FOREACH p100_nmg_dec INTO l_nmu01,l_nmu12,l_nmu19
      IF STATUS THEN
         CALL s_errmsg("foreach","","p100_nmg_dec",STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      CALL s_auto_assign_no("anm",l_no,TODAY,"3","nmg_file","nmg00","","","")
           RETURNING li_result,l_nmg00
      IF NOT li_result THEN
         LET g_success = 'N'
         CALL s_errmsg("nmg00",l_nmg00,"auto_assign_no fail",'abm-621',1)
         EXIT FOREACH
      END IF      

      INITIALIZE l_nmg.* TO NULL
      INITIALIZE l_npk.* TO NULL
      INITIALIZE l_nmu.* TO NULL
      LET l_i = 0
      LET l_nmg23 = 0
      LET l_nmg25 = 0
      #插入單頭nmg_file
      LET l_nmg.nmg00 = l_nmg00     #收支單號
      LET l_nmg.nmg01 = l_nmu01     #收支日期
      LET l_nmg.nmg05 = 0           #原帳出帳金額 
      LET l_nmg.nmg06 = 0           #本帳出帳金額
      LET l_nmg.nmg12 = l_nmu12     #摘要
      LET l_nmg.nmg18 = 'MISC'      #廠商客戶編號
      LET l_nmg.nmg19 = l_nmu19     #廠商客戶簡稱
      LET l_nmg.nmg20 = '21'        #入帳類別      
      LET l_nmg.nmg29 = 'N'         #暫收否
      LET l_nmg.nmgconf = 'N'       #確認碼
      LET l_nmg.nmgacti = 'Y'     
      LET l_nmg.nmguser = g_user
      LET l_nmg.nmggrup = g_grup
      LET l_nmg.nmgmodu = NULL
      LET l_nmg.nmgdate = g_today      
      LET l_nmg.nmglegal = g_legal
      LET l_nmg.nmgoriu = g_user
      LET l_nmg.nmgorig = g_grup     

      LET l_sql = "SELECT * FROM nmu_file",
                  " WHERE nmu01 = '",l_nmu01,"'",
                  "   AND nmu03 = '", g_nmu_hd.nmu03, "'",
                  "   AND nmu23 IN (SELECT nmu23 FROM nmu_tmp1 WHERE nmu09 = '1' AND nmu14 IS NULL AND chk = 'Y')"
      IF cl_null(l_nmu12) THEN 
         LET l_sql = l_sql,"  AND nmu12 is null"
      ELSE
         LET l_sql = l_sql,"  AND nmu12 = '",l_nmu12,"'"   
      END IF 
      IF cl_null(l_nmu19) THEN 
         LET l_sql = l_sql,"  AND nmu19 is null"
      ELSE
         LET l_sql = l_sql,"  AND nmu19 = '",l_nmu19,"'"   
      END IF             
      LET l_sql = l_sql," ORDER BY nmu_file.nmu01,nmu_file.nmu02"
      #插入單身npk_file
      PREPARE p100_npk_pre FROM l_sql
      DECLARE p100_npk_dec CURSOR FOR p100_npk_pre             
      FOREACH p100_npk_dec INTO l_nmu.*
         IF STATUS THEN
            CALL s_errmsg("foreach","","p100_npk_dec",STATUS,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET l_i = l_i + 1
         LET l_npk.npk00 = l_nmg00                 #收支單號
         LET l_npk.npk01 = l_i                    #收支項次
         LET l_npk.npk03 = '1'                     #異動別
         LET l_npk.npk04 = l_nmu.nmu03             #銀行編碼
         LET l_npk.npk05 = l_nmu.nmu08             #幣別
         CALL s_curr3(l_npk.npk05,l_nmg.nmg01,'B') #存入 
         RETURNING l_npk.npk06                     #匯率
         SELECT nma05 INTO l_npk.npk07             #科目編號
           FROM nma_file WHERE nma01 = l_npk.npk04
         LET l_npk.npk08 = l_nmu.nmu10             #原幣金額         
         LET l_npk.npk09 = l_npk.npk08*l_npk.npk06 #本幣金額
         LET l_npk.npk10 = l_nmu.nmu12             #摘要
         LET l_npk.npk12 = l_nmu.nmu23             #網銀轉入流水號
         LET l_npk.npklegal = g_legal              #所屬法人

         IF cl_null(l_npk.npk08) THEN
            LET l_npk.npk08 = 0
         END IF
         IF cl_null(l_npk.npk09) THEN
            LET l_npk.npk09 = 0
         END IF

         INSERT INTO npk_file VALUES (l_npk.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npk_file",l_nmg00,"",SQLCA.sqlcode,"","ins npk:",1) 
            LET g_success = 'N'
            EXIT FOREACH
         ELSE
            UPDATE nmu_file SET nmu14 = l_nmg00 
             WHERE nmu01 = l_nmu.nmu01 AND nmu03 = l_nmu.nmu03
               AND nmu13 = l_nmu.nmu13 AND nmu16 = l_nmu.nmu16
               AND nmu17 = l_nmu.nmu17 AND nmu18 = l_nmu.nmu18
               AND nmu23 = l_nmu.nmu23
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","nmu_file",l_nmu.nmu23,"",SQLCA.sqlcode,"","upda nmu:",1) 
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF   
         LET l_nmg23 = l_nmg23 + l_npk.npk08
         LET l_nmg25 = l_nmg25 + l_npk.npk09   
      END FOREACH
      IF g_success = 'Y' THEN
         LET l_nmg.nmg23 = l_nmg23           #原幣入帳金額 
         LET l_nmg.nmg25 = l_nmg25           #本幣入帳金額
         INSERT INTO nmg_file VALUES (l_nmg.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","nmg_file",l_nmg.nmg01,"",SQLCA.sqlcode,"","ins nmg:",1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END IF   
   END FOREACH   
   IF g_success = "N" THEN 
      ROLLBACK WORK   
      CALL s_showmsg()
   ELSE
      CALL cl_err("","abm-019",0)
      COMMIT WORK   
   END IF 
   CALL q305_show()
END FUNCTION

#收支單別設置
FUNCTION q305_nmg00()
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_no          LIKE nmg_file.nmg00
   DEFINE li_result     LIKE type_file.num5
   
   LET l_no = ''
   OPEN WINDOW q305_1_w AT 10,20 WITH FORM "anm/42f/anmq305_1"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("anmq305_1")
    
   INPUT l_no WITHOUT DEFAULTS FROM nmg_type
      AFTER FIELD nmg_type         
         IF NOT cl_null(l_no) THEN
            CALL s_check_no("anm",l_no,"","3",""," ","") RETURNING li_result,l_no             
            IF (NOT li_result) THEN
               NEXT FIELD nmg_type
            END IF
            CALL s_get_doc_no(l_no) RETURNING l_no
         END IF

      ON ACTION controlp
         CASE       
            WHEN INFIELD(nmg_type)   
               CALL q_nmy(FALSE,FALSE,l_no,'3','ANM') RETURNING l_no
               DISPLAY l_no TO nmg_type   
            OTHERWISE 
               EXIT CASE
         END CASE

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
       CLOSE WINDOW q305_1_w
       RETURN ''
    END IF
    CLOSE WINDOW q305_1_w
    RETURN l_no
END FUNCTION

#銀行編號+交易類型
FUNCTION q305_info()
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_azf03       LIKE azf_file.azf03
   DEFINE l_noa05       LIKE noa_file.noa05
   DEFINE l_noa02       LIKE noa_file.noa02
   DEFINE l_noa03       LIKE noa_file.noa03
   DEFINE l_nma01       LIKE nma_file.nma01
   DEFINE l_nma47       LIKE nma_file.nma47

   LET l_nma01 = g_nmu_hd.nmu03
   LET l_noa05 = ''
   LET l_noa02 = ''
   LET l_noa03 = ''
   LET l_nma47 = ''
   OPEN WINDOW q305_1_w AT 10,20 WITH FORM "anm/42f/anmq305_2"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("anmq305_2")
    
   INPUT l_nma01,l_noa05,l_noa02 WITHOUT DEFAULTS FROM nma01,noa05,noa02
      AFTER FIELD nma01
         IF NOT cl_null(l_nma01) THEN 
            CALL q305_nma01(l_nma01)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err(l_nma01,g_errno,1)
               NEXT FIELD nma01
            ELSE
               SELECT nma47 INTO l_nma47 FROM nma_file
                WHERE nma01 = l_nma01 
            END IF
         END IF
   
      AFTER FIELD noa05
         IF NOT cl_null(l_noa05) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM noa_file 
             WHERE noa05 = l_noa05 AND noa04 = '2' AND noa14 = '2'
            IF l_n > 0 THEN 
               SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01 = l_noa05 AND azf02 = 'T'
               IF cl_null(l_noa02) THEN
                  SELECT noa02,noa03 INTO l_noa02,l_noa03 FROM noa_file 
                   WHERE noa01 = l_nma47 AND noa05 = l_noa05 AND noa13 = 'Y' AND noa04 = '2' AND noa14 = '2'
                  DISPLAY l_noa02,l_noa03 TO noa02,noa03
               END IF
               DISPLAY l_azf03 TO azf03
            ELSE
               CALL cl_err(l_noa05,'anm1034',0)
               NEXT FIELD noa05
            END IF   
         END IF

      AFTER FIELD noa02
         IF NOT cl_null(l_noa02) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM noa_file 
             WHERE noa05 = l_noa05 AND noa04 = '2' AND noa01 = l_nma47 AND noa14 = '2' AND noa02 = l_noa02
            IF l_n < 1 THEN              
               CALL cl_err(l_noa02,'adm-002',0)
               NEXT FIELD noa02
            ELSE
               SELECT noa03 INTO l_noa03 FROM noa_file
                WHERE noa01 = l_nma47 AND noa05 = l_noa05 AND noa02 = l_noa02 AND noa04 = '2' AND noa14 = '2'
               DISPLAY l_noa03 TO noa03
            END IF   
         END IF   
         
      ON ACTION controlp
         CASE
            WHEN INFIELD(nma01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_nma7'
               LET g_qryparam.default1 = l_nma01
               CALL cl_create_qry() RETURNING l_nma01
               DISPLAY BY NAME l_nma01
               NEXT FIELD nma01
         
            WHEN INFIELD(noa05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_noa05"
               LET g_qryparam.default1= l_noa05
               LET g_qryparam.arg1 = l_nma47
               LET g_qryparam.arg2 = '2'
               CALL cl_create_qry() RETURNING l_noa05
               NEXT FIELD noa05 

            WHEN INFIELD(noa02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_noa02"
               LET g_qryparam.default1= l_noa02
               LET g_qryparam.arg1 = l_noa05
               LET g_qryparam.arg2 = l_nma47
               LET g_qryparam.arg3 = '2'
               CALL cl_create_qry() RETURNING l_noa02
               NEXT FIELD noa02       
            OTHERWISE 
               EXIT CASE
         END CASE

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
       CLOSE WINDOW q305_1_w
       RETURN '','',''
    END IF
    CLOSE WINDOW q305_1_w
    RETURN l_nma01,l_noa05,l_noa02
END FUNCTION

FUNCTION q305_nma01(p_nma01)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE p_nma01     LIKE nma_file.nma01
   DEFINE l_nma02     LIKE nma_file.nma02
   DEFINE l_nmaacti   LIKE nma_file.nmaacti
 
   LET g_errno = ''    
   SELECT nma02,nmaacti INTO l_nma02,l_nmaacti     
     FROM nma_file      
    WHERE nma01= p_nma01 
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'aap-007'
                               LET l_nma02 = ''   
      WHEN l_nmaacti = 'N'     LET g_errno = 'mfg0301'
      OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-----'     
   END CASE     
    
   DISPLAY l_nma02 TO FORMONLY.nma02
END FUNCTION 
#FUN-B30213--end--
