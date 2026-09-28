# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ceci002
# Descriptions...: 消耗性料件耗用情况维护
# Date & Author..: guanyao


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE g_tc_ecv_1 RECORD
         tc_ecv01     LIKE tc_ecv_file.tc_ecv01,
         tc_ecv02     LIKE tc_ecv_file.tc_ecv02,
         tc_ecv03     LIKE tc_ecv_file.tc_ecv03, 
         tc_ecv04     LIKE tc_ecv_file.tc_ecv04
                  END RECORD,
       g_tc_ecv_1_t  RECORD
         tc_ecv01     LIKE tc_ecv_file.tc_ecv01,
         tc_ecv02     LIKE tc_ecv_file.tc_ecv02,
         tc_ecv03     LIKE tc_ecv_file.tc_ecv03, 
         tc_ecv04     LIKE tc_ecv_file.tc_ecv04
                  END RECORD,
       g_tc_ecv    DYNAMIC ARRAY OF RECORD
         tc_ecvud10   LIKE tc_ecv_file.tc_ecvud10,
         tc_ecv05     LIKE tc_ecv_file.tc_ecv05, 
         tc_ecv06     LIKE tc_ecv_file.tc_ecv06,
         ima02        LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         tc_ecv07     LIKE tc_ecv_file.tc_ecv07,
         tc_ecvud01   LIKE tc_ecv_file.tc_ecvud01,
         tc_ecvud02   LIKE tc_ecv_file.tc_ecvud02,
         tc_ecvud03   LIKE tc_ecv_file.tc_ecvud03,
         tc_ecvud04   LIKE tc_ecv_file.tc_ecvud04,
         tc_ecvud05   LIKE tc_ecv_file.tc_ecvud05,
         tc_ecvud06   LIKE tc_ecv_file.tc_ecvud06,
         tc_ecvud07   LIKE tc_ecv_file.tc_ecvud07,
         tc_ecvud08   LIKE tc_ecv_file.tc_ecvud08,
         tc_ecvud09   LIKE tc_ecv_file.tc_ecvud09,
         tc_ecvud11   LIKE tc_ecv_file.tc_ecvud11,
         tc_ecvud12   LIKE tc_ecv_file.tc_ecvud12,
         tc_ecvud13   LIKE tc_ecv_file.tc_ecvud13,
         tc_ecvud14   LIKE tc_ecv_file.tc_ecvud14,
         tc_ecvud15   LIKE tc_ecv_file.tc_ecvud15
                   END RECORD,
       g_tc_ecv_t  RECORD
         tc_ecvud10   LIKE tc_ecv_file.tc_ecvud10,
         tc_ecv05     LIKE tc_ecv_file.tc_ecv05, 
         tc_ecv06     LIKE tc_ecv_file.tc_ecv06,
         ima02        LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         tc_ecv07     LIKE tc_ecv_file.tc_ecv07,
         tc_ecvud01   LIKE tc_ecv_file.tc_ecvud01,
         tc_ecvud02   LIKE tc_ecv_file.tc_ecvud02,
         tc_ecvud03   LIKE tc_ecv_file.tc_ecvud03,
         tc_ecvud04   LIKE tc_ecv_file.tc_ecvud04,
         tc_ecvud05   LIKE tc_ecv_file.tc_ecvud05,
         tc_ecvud06   LIKE tc_ecv_file.tc_ecvud06,
         tc_ecvud07   LIKE tc_ecv_file.tc_ecvud07,
         tc_ecvud08   LIKE tc_ecv_file.tc_ecvud08,
         tc_ecvud09   LIKE tc_ecv_file.tc_ecvud09,
         tc_ecvud11   LIKE tc_ecv_file.tc_ecvud11,
         tc_ecvud12   LIKE tc_ecv_file.tc_ecvud12,
         tc_ecvud13   LIKE tc_ecv_file.tc_ecvud13,
         tc_ecvud14   LIKE tc_ecv_file.tc_ecvud14,
         tc_ecvud15   LIKE tc_ecv_file.tc_ecvud15
                  END RECORD,

       g_tc_ecv_2 RECORD LIKE tc_ecv_file.*,

       g_wc        STRING,
       g_wc2       STRING,                       #單身CONSTRUCT結果
       g_rec_b     LIKE type_file.num5,
       l_ac        LIKE type_file.num5,
       l_ac_t      LIKE type_file.num5,
       g_sql       STRING

DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE  SQL        #No.FUN-680102
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        #No.FUN-680102 SMALLINT
DEFINE g_chr                 LIKE azb_file.azbacti        #No.FUN-680102 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(72)
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數        #No.FUN-680102 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680102 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5
DEFINE  g_multi_tc_ecv05  STRING 

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   INITIALIZE g_tc_ecv_1.* TO NULL

   LET g_forupd_sql = "SELECT * FROM tc_ecv_file WHERE tc_ecv01 = ? AND tc_ecv02 = ? ",
                      "                            AND tc_ecv03 = ? AND tc_ecv04 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i002_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR


   OPEN WINDOW i002_w WITH FORM "cec/42f/ceci002"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()


   LET g_action_choice = ""
   CALL i002_menu()

   CLOSE WINDOW i002_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i002_cs()

    CLEAR FORM
    INITIALIZE g_tc_ecv_1.* TO NULL      
    CONSTRUCT g_wc ON                     # 螢幕上取條件
        tc_ecv01,tc_ecv02,tc_ecv03,tc_ecv04,tc_ecv05,tc_ecv06,tc_ecv06,tc_ecvud01,tc_ecvud02,
        tc_ecvud03,tc_ecvud04,tc_ecvud05,tc_ecvud06,tc_ecvud07,tc_ecvud08,tc_ecvud09,tc_ecvud10,
        tc_ecvud11,tc_ecvud12,tc_ecvud13,tc_ecvud14,tc_ecvud15
        FROM tc_ecv01,tc_ecv02,tc_ecv03,tc_ecv04,
             s_tc_ecv[1].tc_ecv05,s_tc_ecv[1].tc_ecv06,s_tc_ecv[1].tc_ecv07,
             s_tc_ecv[1].tc_ecvud01,s_tc_ecv[1].tc_ecvud02,s_tc_ecv[1].tc_ecvud03,s_tc_ecv[1].tc_ecvud04,
             s_tc_ecv[1].tc_ecvud05,s_tc_ecv[1].tc_ecvud06,s_tc_ecv[1].tc_ecvud07,s_tc_ecv[1].tc_ecvud08,
             s_tc_ecv[1].tc_ecvud09,s_tc_ecv[1].tc_ecvud10,s_tc_ecv[1].tc_ecvud11,s_tc_ecv[1].tc_ecvud12,
             s_tc_ecv[1].tc_ecvud13,s_tc_ecv[1].tc_ecvud14,s_tc_ecv[1].tc_ecvud15
             
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_ecv01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_ecu01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_ecv_1.tc_ecv01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecv01
                 NEXT FIELD tc_ecv01
              
              WHEN INFIELD(tc_ecv02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_ecu"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_ecv_1.tc_ecv02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecv02
                 NEXT FIELD tc_ecv02

             WHEN INFIELD(tc_ecv03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_ecg"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_ecv_1.tc_ecv03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecv03
                 NEXT FIELD tc_ecv03

             WHEN INFIELD(tc_ecv05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_ecu03_1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_ecv[1].tc_ecv05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecv05
                 NEXT FIELD tc_ecv05

             WHEN INFIELD(tc_ecv06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_ecu04"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_ecv[1].tc_ecv06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecv06
                 NEXT FIELD tc_ecv06
                 
              OTHERWISE
                 EXIT CASE
           END CASE
       
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
      
        ON ACTION about    
           CALL cl_about()  
      
        ON ACTION HELP       
           CALL cl_show_help()
      
        ON ACTION controlg    
           CALL cl_cmdask()    

        ON ACTION qbe_select
           CALL cl_qbe_select()
        ON ACTION qbe_save
           CALL cl_qbe_save()
    END CONSTRUCT

    LET g_sql="SELECT DISTINCT tc_ecv01,tc_ecv02,tc_ecv03,tc_ecv04 FROM tc_ecv_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY tc_ecv01"
    PREPARE i002_prepare FROM g_sql
    DECLARE i002_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i002_prepare
    DROP TABLE x

    LET g_sql="SELECT DISTINCT tc_ecv01,tc_ecv02,tc_ecv03,tc_ecv04 FROM tc_ecv_file ",
              " WHERE ",g_wc CLIPPED,
              " INTO TEMP x"
    PREPARE i002_ins_temp_pre FROM g_sql
    EXECUTE i002_ins_temp_pre
    
    LET g_sql=
        "SELECT COUNT(*) FROM x "
    PREPARE i002_precount FROM g_sql
    DECLARE i002_count CURSOR FOR i002_precount
END FUNCTION

FUNCTION i002_menu()

   WHILE TRUE
      CALL i002_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i002_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i002_q()
            END IF

        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i002_r()
           END IF

#        WHEN "modify"
#           IF cl_chk_act_auth() THEN
#              CALL i002_u()
#           END IF

#        WHEN "invalid"
#           IF cl_chk_act_auth() THEN
#              CALL i002_x()
#           END IF

#        WHEN "reproduce"
#           IF cl_chk_act_auth() THEN
#              CALL i002_copy()
#           END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i002_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_ecv),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_ecv_1.tc_ecv01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_ecv01"
                 LET g_doc.value1 = g_tc_ecv_1.tc_ecv01
                 CALL cl_doc()
               END IF
         END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i002_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_ecv TO s_tc_ecv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
                 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
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
                 
      ON ACTION first
         CALL i002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION previous
         CALL i002_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION jump
         CALL i002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION next
         CALL i002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION last
         CALL i002_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
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
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0101
         CALL cl_about()      #MOD-4C0101
         
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
      
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i002_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_tc_ecv_1.* TO NULL            #No.FUN-6A0015
    CALL g_tc_ecv.clear()
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i002_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i002_count
    FETCH i002_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i002_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_ecv_1.tc_ecv01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_ecv_1.* TO NULL
    ELSE
        CALL i002_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i002_fetch(p_flag)
DEFINE p_flag     LIKE type_file.chr1

    CASE p_flag
        WHEN 'N' FETCH NEXT     i002_cs INTO g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,g_tc_ecv_1.tc_ecv03,g_tc_ecv_1.tc_ecv04
        WHEN 'P' FETCH PREVIOUS i002_cs INTO g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,g_tc_ecv_1.tc_ecv03,g_tc_ecv_1.tc_ecv04
        WHEN 'F' FETCH FIRST    i002_cs INTO g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,g_tc_ecv_1.tc_ecv03,g_tc_ecv_1.tc_ecv04
        WHEN 'L' FETCH LAST     i002_cs INTO g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,g_tc_ecv_1.tc_ecv03,g_tc_ecv_1.tc_ecv04
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   #No.FUN-6A0066
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()

                  ON ACTION about         #MOD-4C0101
                     CALL cl_about()      #MOD-4C0101

                  ON ACTION help          #MOD-4C0101
                     CALL cl_show_help()  #MOD-4C0101

                  ON ACTION controlg      #MOD-4C0101
                     CALL cl_cmdask()     #MOD-4C0101

               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i002_cs INTO g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,g_tc_ecv_1.tc_ecv03,g_tc_ecv_1.tc_ecv04
            LET mi_no_ask = FALSE         #No.FUN-6A0066
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_ecv_1.tc_ecv01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_ecv_1.* TO NULL  #TQC-6B0105
        LET g_tc_ecv_1.tc_ecv01 = NULL      #TQC-6B0105
        RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 #No.FUN-4A0089
    END IF

    CALL i002_show()                   # 重新顯示
END FUNCTION

FUNCTION i002_show()
DEFINE l_ecg02      LIKE ecg_file.ecg02

    LET g_tc_ecv_1_t.* = g_tc_ecv_1.*
    DISPLAY BY NAME g_tc_ecv_1.*
    SELECT ecg02 INTO l_ecg02 FROM ecg_file WHERE ecg01 = g_tc_ecv_1.tc_ecv03
    DISPLAY l_ecg02 TO FORMONLY.ecg02
    CALL i002_b_fill(' 1=1')
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i002_a()

    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_tc_ecv_1.* TO NULL
    CALL g_tc_ecv.clear()
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tc_ecv_1.tc_ecv04 = g_today
        CALL i002_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_tc_ecv_1.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_tc_ecv_1.tc_ecv01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF 
        LET g_rec_b = 0
        CALL i002_b_fill('1=1')
        CALL i002_b()
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i002_i(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1
DEFINE l_x           LIKE type_file.num5
DEFINE l_ecb03       LIKE ecb_file.ecb03
DEFINE l_ecg02       LIKE ecg_file.ecg02

   DISPLAY BY NAME g_tc_ecv_1.*
   
   INPUT BY NAME
      g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,g_tc_ecv_1.tc_ecv03,g_tc_ecv_1.tc_ecv04
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i002_set_entry(p_cmd)
          CALL i002_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

      AFTER FIELD tc_ecv01
         IF NOT cl_null(g_tc_ecv_1.tc_ecv01) THEN 
            LET l_x = 0
            SELECT COUNT(*) INTO  l_x FROM ecu_file,ima_file 
             WHERE ecu01 = g_tc_ecv_1.tc_ecv01  
               AND ima01 = ecu01 
               AND ima08 = 'M' 
            IF cl_null(l_x) OR l_x = 0 THEN 
               CALL cl_err('','cec-003',1)
               NEXT FIELD tc_ecv01
            ELSE 
               IF NOT cl_null(g_tc_ecv_1.tc_ecv02) THEN
                  LET l_ecb03 = '' 
                  SELECT ecb03 INTO l_ecb03 FROM ecb_file 
                   WHERE ecb01 = g_tc_ecv_1.tc_ecv01 
                     AND ecb02 = g_tc_ecv_1.tc_ecv02
                  IF cl_null(l_ecb03) THEN
                     CALL cl_err('','cec-004',0)
                     NEXT FIELD tc_ecv01
                  END IF  
               END IF 
            END IF 
         END IF 
      
      AFTER FIELD tc_ecv02
         IF NOT cl_null(g_tc_ecv_1.tc_ecv02) THEN 
            LET l_x = 0
            SELECT COUNT(*) INTO l_x FROM ecu_file
             WHERE ecu02 = g_tc_ecv_1.tc_ecv02  
            IF cl_null(l_x) OR l_x = 0 THEN 
               CALL cl_err('','cec-005',1)
               NEXT FIELD tc_ecv02
            ELSE 
               IF NOT cl_null(g_tc_ecv_1.tc_ecv01) THEN
                  LET l_ecb03 = ''  
                  SELECT ecb03 INTO l_ecb03 FROM ecb_file 
                   WHERE ecb01 = g_tc_ecv_1.tc_ecv01 
                     AND ecb02 = g_tc_ecv_1.tc_ecv02
                  IF cl_null(l_ecb03) THEN
                     CALL cl_err('','cec-004',0)
                     NEXT FIELD tc_ecv02
                  END IF  
               END IF 
            END IF 
         END IF

      AFTER FIELD tc_ecv03
         IF NOT cl_null(g_tc_ecv_1.tc_ecv03) THEN 
            IF g_tc_ecv_1_t.tc_ecv03 !=g_tc_ecv_1.tc_ecv03 OR 
               g_tc_ecv_1_t.tc_ecv03 IS NULL THEN 
               LET l_x = 0
               SELECT COUNT(*) INTO l_x FROM ecg_file
                WHERE ecg01 = g_tc_ecv_1.tc_ecv03  
               IF cl_null(l_x) OR l_x = 0 THEN 
                  CALL cl_err('','cec-008',1)
                  NEXT FIELD tc_ecv03
               END IF
               SELECT ecg02 INTO l_ecg02 FROM ecg_file WHERE ecg01 = g_tc_ecv_1.tc_ecv03
               DISPLAY l_ecg02 TO FORMONLY.ecg02
            END IF 
         END IF

      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(tc_ecv01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_tc_ecu01"
              LET g_qryparam.default1 = g_tc_ecv_1.tc_ecv01
              CALL cl_create_qry() RETURNING g_tc_ecv_1.tc_ecv01
              DISPLAY BY NAME g_tc_ecv_1.tc_ecv01
              NEXT FIELD tc_ecv01
           WHEN INFIELD(tc_ecv02)
              CALL cl_init_qry_var()
              IF cl_null(g_tc_ecv_1.tc_ecv01) THEN 
                 LET g_qryparam.form = "cq_ecu"
              ELSE 
                 LET g_qryparam.form = "cq_ecu02"
                 LET g_qryparam.arg1=g_tc_ecv_1.tc_ecv01
              END IF 
              LET g_qryparam.default1 = g_tc_ecv_1.tc_ecv02
              CALL cl_create_qry() RETURNING g_tc_ecv_1.tc_ecv02
              DISPLAY BY NAME g_tc_ecv_1.tc_ecv02
              NEXT FIELD tc_ecv02
            WHEN INFIELD(tc_ecv03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_ecg"
              LET g_qryparam.default1 = g_tc_ecv_1.tc_ecv03
              CALL cl_create_qry() RETURNING g_tc_ecv_1.tc_ecv03
              DISPLAY BY NAME g_tc_ecv_1.tc_ecv03
              NEXT FIELD tc_ecv03
           OTHERWISE
              EXIT CASE
           END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
            
      ON ACTION about         #MOD-4C0101
         CALL cl_about()      #MOD-4C0101
            
      ON ACTION help          #MOD-4C0101
         CALL cl_show_help()  #MOD-4C0101
            
   END INPUT

END FUNCTION

FUNCTION i002_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN        #No.FUN-550021
      CALL cl_set_comp_entry("tc_ecv01,tc_ecv02,tc_ecv03,tc_ecv04",TRUE) 
    END IF
END FUNCTION

FUNCTION i002_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_ecv01,tc_ecv02,tc_ecv03,tc_ecv04",FALSE) 
   END IF
END FUNCTION

FUNCTION i002_b()
DEFINE
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態  #No.FUN-680136 VARCHAR(1)
    l_n             LIKE type_file.num5,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5
DEFINE l_x           LIKE type_file.num5
DEFINE l_a           LIKE type_file.num5

    LET g_action_choice = ""
    
    IF s_shut(0) THEN
       RETURN
    END IF
    
    IF g_tc_ecv_1.tc_ecv01 IS NULL THEN
       RETURN
    END IF
    
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT tc_ecvud10,tc_ecv05,tc_ecv06,'','',tc_ecv07,tc_ecvud01,tc_ecvud02,tc_ecvud03,",
                       "       tc_ecvud04,tc_ecvud05,tc_ecvud06,tc_ecvud07,tc_ecvud08,tc_ecvud09,",
                       "       tc_ecvud11,tc_ecvud12,tc_ecvud13,tc_ecvud14,tc_ecvud15",
                       "  FROM tc_ecv_file",
                       "  WHERE tc_ecv01= ? AND tc_ecv02= ? AND tc_ecv03 = ? AND tc_ecv04 = ? AND tc_ecvud10 = ? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i002_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_tc_ecv WITHOUT DEFAULTS FROM s_tc_ecv.*
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

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tc_ecv_t.* = g_tc_ecv[l_ac].*
              OPEN i002_bcl USING g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,g_tc_ecv_1.tc_ecv03,
                                  g_tc_ecv_1.tc_ecv04,g_tc_ecv_t.tc_ecvud10
              IF STATUS THEN
                 CALL cl_err("OPEN i002_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i002_bcl INTO g_tc_ecv[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_ecv_t.tc_ecvud10,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT ima02,ima021 INTO g_tc_ecv[l_ac].ima02,g_tc_ecv[l_ac].ima021 
                   FROM ima_file 
                  WHERE ima01 = g_tc_ecv[l_ac].tc_ecv06
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_ecv[l_ac].* TO NULL      #900423
           LET g_tc_ecv_t.* = g_tc_ecv[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD tc_ecvud10 

        BEFORE FIELD  tc_ecvud10
           IF g_tc_ecv[l_ac].tc_ecvud10 IS NULL OR g_tc_ecv[l_ac].tc_ecvud10 =0 THEN 
              SELECT max(tc_ecvud10)+1 INTO g_tc_ecv[l_ac].tc_ecvud10 FROM tc_ecv_file 
              WHERE tc_ecv01 = g_tc_ecv_1.tc_ecv01 AND tc_ecv02 = g_tc_ecv_1.tc_ecv02
                AND tc_ecv03 = g_tc_ecv_1.tc_ecv03 AND tc_ecv04 = g_tc_ecv_1.tc_ecv04
                IF g_tc_ecv[l_ac].tc_ecvud10 IS NULL  THEN 
                   LET g_tc_ecv[l_ac].tc_ecvud10 = 1 
                END IF 
            END IF

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           INSERT INTO tc_ecv_file
           VALUES(g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,g_tc_ecv_1.tc_ecv03,g_tc_ecv_1.tc_ecv04,g_tc_ecv[l_ac].tc_ecv05,
                  g_tc_ecv[l_ac].tc_ecv06,g_tc_ecv[l_ac].tc_ecv07,g_tc_ecv[l_ac].tc_ecvud01,g_tc_ecv[l_ac].tc_ecvud02,
                  g_tc_ecv[l_ac].tc_ecvud03,g_tc_ecv[l_ac].tc_ecvud04,g_tc_ecv[l_ac].tc_ecvud05,g_tc_ecv[l_ac].tc_ecvud06,
                  g_tc_ecv[l_ac].tc_ecvud07,g_tc_ecv[l_ac].tc_ecvud08,g_tc_ecv[l_ac].tc_ecvud09,g_tc_ecv[l_ac].tc_ecvud10,
                  g_tc_ecv[l_ac].tc_ecvud11,g_tc_ecv[l_ac].tc_ecvud12,g_tc_ecv[l_ac].tc_ecvud13,g_tc_ecv[l_ac].tc_ecvud14,
                  g_tc_ecv[l_ac].tc_ecvud15,'Y',g_user,g_grup,'',g_today)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_ecv_file",g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'  
              COMMIT WORK
              LET g_rec_b=g_rec_b+1 
              DISPLAY g_rec_b TO FORMONLY.cn2    
           END IF

        AFTER FIELD tc_ecvud10
           IF NOT cl_null(g_tc_ecv[l_ac].tc_ecvud10) THEN 
              IF g_tc_ecv_t.tc_ecvud10 ! = g_tc_ecv[l_ac].tc_ecvud10 OR 
                 g_tc_ecv_t.tc_ecvud10 IS NULL THEN 
                 SELECT count(*) INTO l_a FROM tc_ecv_file 
                 WHERE tc_ecv01 = g_tc_ecv_1.tc_ecv01 
                 AND tc_ecv02 = g_tc_ecv_1.tc_ecv02
                 AND tc_ecv03 = g_tc_ecv_1.tc_ecv03
                 AND tc_ecv04 = g_tc_ecv_1.tc_ecv04
                 AND tc_ecvud10 = g_tc_ecv[l_ac].tc_ecvud10
                 IF l_a >0 THEN 
                    CALL cl_err('','cec-007',0)
                    NEXT FIELD tc_ecuud10
                 END IF 
              END IF 
           END  IF

        AFTER FIELD tc_ecv05
           IF NOT cl_null(g_tc_ecv[l_ac].tc_ecv05) THEN 
              IF g_tc_ecv_t.tc_ecv05 ! = g_tc_ecv[l_ac].tc_ecv05 OR 
                 g_tc_ecv_t.tc_ecv05 IS NULL THEN 
                 LET l_a=0 
                 SELECT count(*) INTO l_a FROM ecb_file 
                  WHERE ecb01 = g_tc_ecv_1.tc_ecv01 
                    AND ecb02 = g_tc_ecv_1.tc_ecv02
                    AND ecb03 = g_tc_ecv[l_ac].tc_ecv05
                 IF cl_null(l_a) OR l_a = 0 THEN 
                    CALL cl_err('','cec-005',0)
                    NEXT FIELD tc_ecv05
                 END IF
                 IF NOT cl_null(g_tc_ecv[l_ac].tc_ecv06) THEN 
                    LET l_a= 0
                    SELECT count(*) INTO l_a FROM tc_ecv_file 
                     WHERE tc_ecv01 = g_tc_ecv_1.tc_ecv01 
                       AND tc_ecv02 = g_tc_ecv_1.tc_ecv02
                       AND tc_ecv03 = g_tc_ecv_1.tc_ecv03
                       AND tc_ecv04 = g_tc_ecv_1.tc_ecv04
                       AND tc_ecv05 = g_tc_ecv[l_ac].tc_ecv05
                       AND tc_ecv06 = g_tc_ecv[l_ac].tc_ecv06
                    IF l_a >0 THEN 
                       CALL cl_err('','cec-002',0)
                       NEXT FIELD tc_ecv05
                    END IF 
                 END IF  
              END IF 
           END  IF
        
        AFTER FIELD tc_ecv06
           IF NOT cl_null(g_tc_ecv[l_ac].tc_ecv06) THEN
              IF g_tc_ecv_t.tc_ecv06 ! = g_tc_ecv[l_ac].tc_ecv06 OR 
                 g_tc_ecv_t.tc_ecv06 IS NULL THEN 
                 LET l_x = 0
                 SELECT COUNT (*) INTO l_x FROM ima_file WHERE ima01 = g_tc_ecv[l_ac].tc_ecv06
                 IF cl_null(l_x) OR l_x = 0 THEN 
                    CALL cl_err('','cec-001',0)
                    NEXT FIELD tc_ecv06
                 ELSE
                    IF NOT cl_null(g_tc_ecv[l_ac].tc_ecv05) THEN 
                       SELECT COUNT(*) INTO l_x FROM tc_ecv_file 
                        WHERE tc_ecv01 = g_tc_ecv_1.tc_ecv01
                          AND tc_ecv02 = g_tc_ecv_1.tc_ecv02
                          AND tc_ecv03 = g_tc_ecv_1.tc_ecv03
                          AND tc_ecv04 = g_tc_ecv_1.tc_ecv04
                          AND tc_ecv05 = g_tc_ecv[l_ac].tc_ecv05
                          AND tc_ecv06 = g_tc_ecv[l_ac].tc_ecv06
                       IF l_x >0 THEN 
                          CALL cl_err('','cec-006',0)
                          NEXT FIELD tc_ecv06
                       END IF  
                    END IF     
                    SELECT ima02,ima021 INTO g_tc_ecv[l_ac].ima02,g_tc_ecv[l_ac].ima021
                      FROM ima_file 
                     WHERE ima01 = g_tc_ecv[l_ac].tc_ecv06
                    DISPLAY BY NAME g_tc_ecv[l_ac].ima02,g_tc_ecv[l_ac].ima021
                 END IF 
              END IF 
           END IF 
             
        
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_tc_ecv_t.tc_ecvud10 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE    
              END IF              
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE    
              END IF              
              DELETE FROM tc_ecv_file
               WHERE tc_ecv01 = g_tc_ecv_1.tc_ecv01
                 AND tc_ecv02 = g_tc_ecv_1.tc_ecv02
                 AND tc_ecv03 = g_tc_ecv_1.tc_ecv03
                 AND tc_ecv04 = g_tc_ecv_1.tc_ecv04
                 AND tc_ecvud10 = g_tc_ecv_t.tc_ecvud10
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_ecv_file",g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,SQLCA.sqlcode,"","",1) 
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
              LET g_tc_ecv[l_ac].* = g_tc_ecv_t.*
              CLOSE i002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_ecv[l_ac].tc_ecv05,-263,1)
              LET g_tc_ecv[l_ac].* = g_tc_ecv_t.*
           ELSE
              UPDATE tc_ecv_file SET tc_ecv05=g_tc_ecv[l_ac].tc_ecv05,
                                     tc_ecv06=g_tc_ecv[l_ac].tc_ecv06,
                                     tc_ecv07=g_tc_ecv[l_ac].tc_ecv07,
                                     tc_ecvud01=g_tc_ecv[l_ac].tc_ecvud01,
                                     tc_ecvud02=g_tc_ecv[l_ac].tc_ecvud02,
                                     tc_ecvud03=g_tc_ecv[l_ac].tc_ecvud03,
                                     tc_ecvud04=g_tc_ecv[l_ac].tc_ecvud04,
                                     tc_ecvud05=g_tc_ecv[l_ac].tc_ecvud05,
                                     tc_ecvud06=g_tc_ecv[l_ac].tc_ecvud06,
                                     tc_ecvud07=g_tc_ecv[l_ac].tc_ecvud07,
                                     tc_ecvud08=g_tc_ecv[l_ac].tc_ecvud08,
                                     tc_ecvud09=g_tc_ecv[l_ac].tc_ecvud09,
                                     tc_ecvud10=g_tc_ecv[l_ac].tc_ecvud10,
                                     tc_ecvud11=g_tc_ecv[l_ac].tc_ecvud11,
                                     tc_ecvud12=g_tc_ecv[l_ac].tc_ecvud12,
                                     tc_ecvud13=g_tc_ecv[l_ac].tc_ecvud13,
                                     tc_ecvud14=g_tc_ecv[l_ac].tc_ecvud14,
                                     tc_ecvud15=g_tc_ecv[l_ac].tc_ecvud15,
                                     tc_ecvmodu=g_user,
                                     tc_ecvdate=g_today
               WHERE tc_ecv01=g_tc_ecv_1.tc_ecv01
                 AND tc_ecv02=g_tc_ecv_1.tc_ecv02
                 AND tc_ecv03=g_tc_ecv_1.tc_ecv03
                 AND tc_ecv04=g_tc_ecv_1.tc_ecv04
                 AND tc_ecvud10 = g_tc_ecv_t.tc_ecvud10
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tc_ecv_file",g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,SQLCA.sqlcode,"","",1)
                 LET g_tc_ecv[l_ac].* = g_tc_ecv_t.*
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
                 LET g_tc_ecv[l_ac].* = g_tc_ecv_t.*
              END IF
              CLOSE i002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i002_bcl
           COMMIT WORK                
                                  
        ON ACTION CONTROLZ        
           CALL cl_show_req_fields()
                                  
        ON ACTION CONTROLG        
           CALL cl_cmdask()       
                 
        ON ACTION controlp
           CASE
             WHEN INFIELD(tc_ecv06) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="cq_tc_ecu04"   #MOD-920024 q_pmc2-->q_pmc1
               LET g_qryparam.default1 = g_tc_ecv[l_ac].tc_ecv06
               CALL cl_create_qry() RETURNING g_tc_ecv[l_ac].tc_ecv06
               DISPLAY BY NAME g_tc_ecv[l_ac].tc_ecv06
               NEXT FIELD tc_ecv06

             WHEN INFIELD(tc_ecv05) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="cq_tc_ecu03"   #MOD-920024 q_pmc2-->q_pmc1
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1=g_tc_ecv_1.tc_ecv01
               LET g_qryparam.arg2=g_tc_ecv_1.tc_ecv02
               LET g_qryparam.plant = g_plant
               CALL cl_create_qry() RETURNING g_multi_tc_ecv05
               IF NOT cl_null(g_multi_tc_ecv05) THEN 
                  CALL i002_multi_tc_ecv04()
                  CALL i002_b_fill('1=1')
                  CALL i002_b()
                  EXIT INPUT 
               END IF 
           END CASE

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
               
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
                 
      ON ACTION about         #MOD-4C0101
         CALL cl_about()      #MOD-4C0101
                  
      ON ACTION help          #MOD-4C0101
         CALL cl_show_help()  #MOD-4C0101
                    
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END INPUT
              
    CLOSE i002_bcl 
    COMMIT WORK  

END FUNCTION

FUNCTION i002_b_fill(p_wc2)
DEFINE p_wc2  STRING
IF cl_null(g_wc) THEN 
LET g_wc = ' 1=1'
END  IF 

   LET g_sql = "SELECT tc_ecvud10,tc_ecv05,tc_ecv06,ima02,ima021,tc_ecv07,tc_ecvud01,tc_ecvud02,tc_ecvud03,",
               "       tc_ecvud04,tc_ecvud05,tc_ecvud06,tc_ecvud07,tc_ecvud08,tc_ecvud09,",
               "       tc_ecvud11,tc_ecvud12,tc_ecvud13,tc_ecvud14,tc_ecvud15",
               "  FROM tc_ecv_file LEFT JOIN ima_file ON ima01 = tc_ecv06",
               " WHERE tc_ecv01 = '",g_tc_ecv_1.tc_ecv01,"' ",
               "   AND tc_ecv02 = '",g_tc_ecv_1.tc_ecv02,"' ",
               "   AND tc_ecv03 = '",g_tc_ecv_1.tc_ecv03,"' ",
               "   AND tc_ecv04 = '",g_tc_ecv_1.tc_ecv04,"' ",
               "  AND ", g_wc CLIPPED

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY tc_ecv03 "
   DISPLAY g_sql

   PREPARE i002_pb FROM g_sql
   DECLARE tc_ecv_cs CURSOR FOR i002_pb

   CALL g_tc_ecv.clear()
   LET g_cnt = 1

   FOREACH tc_ecv_cs INTO g_tc_ecv[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_tc_ecv.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION i002_copy()
DEFINE      l_n       LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_new01   LIKE tc_ecv_file.tc_ecv01,
            l_new02   LIKE tc_ecv_file.tc_ecv02,
            l_old01   LIKE tc_ecv_file.tc_ecv01,
            l_old02   LIKE tc_ecv_file.tc_ecv02
DEFINE l_ecb03        LIKE oeb_file.oeb03
DEFINE l_x            LIKE type_file.num5
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_tc_ecv_1.tc_ecv01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   LET g_before_input_done = FALSE
    CALL i002_set_entry('a')
    LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_new01,l_new02 WITHOUT DEFAULTS FROM tc_ecv01,tc_ecv02  #No.FUN-710055
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

     AFTER FIELD tc_ecv01
       IF NOT cl_null(l_new01) THEN 
            LET l_x = 0
            SELECT COUNT(*) INTO  l_x FROM ecu_file,ima_file 
             WHERE ecu01 = l_new01  
               AND ima01 = ecu01 
               AND ima08 = 'M' 
            IF cl_null(l_x) OR l_x = 0 THEN 
               CALL cl_err('','cec-003',1)
               NEXT FIELD tc_ecv01
            ELSE 
               IF NOT cl_null(l_new02) THEN
                  LET l_ecb03 = '' 
                  SELECT ecb03 INTO l_ecb03 FROM ecb_file 
                   WHERE ecb01 = l_new01
                     AND ecb02 = l_new02
                  IF cl_null(l_ecb03) THEN
                     CALL cl_err('','cec-004',0)
                     NEXT FIELD tc_ecv01
                  END IF  
               END IF 
            END IF 
         END IF 

     AFTER FIELD tc_ecv02
        IF NOT cl_null(l_new02) THEN 
            LET l_x = 0
            SELECT COUNT(*) INTO l_x FROM ecu_file
             WHERE ecu02 = l_new02  
            IF cl_null(l_x) OR l_x = 0 THEN 
               CALL cl_err('','cec-005',1)
               NEXT FIELD tc_ecv02
            ELSE 
               IF NOT cl_null(l_new01) THEN
                  LET l_ecb03 = ''  
                  SELECT ecb03 INTO l_ecb03 FROM ecb_file 
                   WHERE ecb01 = l_new01 
                     AND ecb02 = l_new02
                  IF cl_null(l_ecb03) THEN
                     CALL cl_err('','cec-004',0)
                     NEXT FIELD tc_ecv02
                  END IF  
               END IF 
            END IF 
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
      ON ACTION controlp 
         CASE
              WHEN INFIELD(tc_ecv01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_ecv01"
                 LET g_qryparam.default1 = l_new01
                 CALL cl_create_qry() RETURNING l_new01
                 DISPLAY BY NAME l_new01  
                 NEXT FIELD tc_ecv01
             WHEN INFIELD(tc_ecv02)
                 CALL cl_init_qry_var()
                 IF cl_null(l_new01) THEN 
                    LET g_qryparam.form = "cq_ecu"
                 ELSE 
                    LET g_qryparam.form = "cq_ecu02"
                    LET g_qryparam.arg1=l_new01
                 END IF 
                 LET g_qryparam.default1 = l_new02
                 CALL cl_create_qry() RETURNING l_new02
                 DISPLAY BY NAME l_new02
                 NEXT FIELD tc_ecv02
                OTHERWISE
                 EXIT CASE
           END CASE
         
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02 TO tc_ecv01,tc_ecv02  
      RETURN
   END IF
 
   DROP TABLE x

   SELECT * FROM tc_ecv_file 
     WHERE tc_ecv01=g_tc_ecv_1.tc_ecv01 and tc_ecv02=g_tc_ecv_1.tc_ecv02 
   INTO TEMP x

 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,SQLCA.sqlcode,"","",1)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET tc_ecv01 = l_new01,                        # 資料鍵值
          tc_ecv02 = l_new02                     # No.FUN-710055
 
   INSERT INTO tc_ecv_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","tc_ecv_file",l_new01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660081
      RETURN
   ELSE    
      DROP TABLE x
      SELECT * FROM tc_ecv_file 
       WHERE tc_ecv01=g_tc_ecv_1.tc_ecv01 AND tc_ecv02=g_tc_ecv_1.tc_ecv02 
        INTO TEMP x
      UPDATE x
         SET tc_ecv01 = l_new01,
             tc_ecv02 = l_new02                    
      INSERT INTO tc_ecv_file SELECT * FROM x
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_tc_ecv_1.tc_ecv01
   LET l_old02 = g_tc_ecv_1.tc_ecv02
   LET g_tc_ecv_1.tc_ecv01 = l_new01
   LET g_tc_ecv_1.tc_ecv02 = l_new02
   CALL i002_b_fill('1=1')
   CALL i002_b()
   LET g_tc_ecv_1.tc_ecv01 = l_old01
   LET g_tc_ecv_1.tc_ecv02 = l_old02
   CALL i002_show()

END FUNCTION

FUNCTION i002_r()
    IF g_tc_ecv_1.tc_ecv01 IS NULL THEN  #FUN-C60033
      CALL cl_err("",-400,0)  
      RETURN
   END IF

   BEGIN WORK 
   OPEN i002_cl USING g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,g_tc_ecv_1.tc_ecv03,g_tc_ecv_1.tc_ecv04
   IF STATUS THEN
      CALL cl_err(g_tc_ecv_1.tc_ecv01,SQLCA.sqlcode,0)
      CLOSE i002_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i002_cl INTO g_tc_ecv_1.tc_ecv01,g_tc_ecv_1.tc_ecv02,g_tc_ecv_1.tc_ecv03,g_tc_ecv_1.tc_ecv04
   IF SQLCA.sqlcode THEN                                         #資料被他人LOCK
         CALL cl_err(g_tc_ecv_1.tc_ecv01,SQLCA.sqlcode,0) RETURN END IF
   CALL i002_show()

   IF cl_delh(15,21) THEN                #確認一下
       INITIALIZE g_doc.* TO NULL     
       LET g_doc.column1 = "tc_ecv01"       #FUN-C60033
       LET g_doc.value1 = g_tc_ecv_1.tc_ecv01  #FUN-C60033
       CALL cl_del_doc()       
       DELETE FROM tc_ecv_file WHERE tc_ecv01 = g_tc_ecv_1.tc_ecv01 AND tc_ecv02 = g_tc_ecv_1.tc_ecv02
                                 AND tc_ecv03 = g_tc_ecv_1.tc_ecv03 AND tc_ecv04 = g_tc_ecv_1.tc_ecv04
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","tc_ecv_file","","",SQLCA.sqlcode,"","BODY DELETE:",1)
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
        CALL g_tc_ecv.clear()
       MESSAGE ""
       OPEN i002_count #MOD-D60152 add
       FETCH i002_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i002_cl
          CLOSE i002_count
          COMMIT WORK
          RETURN
       END IF

       IF g_row_count > 0 THEN  
           LET g_row_count = g_row_count - 1 
        END IF 
        DISPLAY g_row_count TO FORMONLY.cnt
       
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i002_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i002_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i002_fetch('/')
       END IF

    END IF 
   CLOSE i002_cl
   COMMIT WORK
END FUNCTION 

FUNCTION i002_multi_tc_ecv04()        
DEFINE   tok         base.StringTokenizer
DEFINE   l_sql       STRING
DEFINE   l_n         LIKE type_file.num5
DEFINE   l_plant     LIKE azw_file.azw01
DEFINE   l_unit      LIKE oeb_file.oeb05
DEFINE   g_cnt       LIKE type_file.num5 
DEFINE   l_tc_ecv    RECORD LIKE tc_ecv_file.*
DEFINE
  l_cnt, li_i                 LIKE type_file.num5,        
  l_qty                       LIKE type_file.num10,   
  p_cmd                       LIKE type_file.chr1,   
  i                           LIKE type_file.num5     #FUN-B10010
DEFINE l_tc_ecvud10           LIKE tc_ecv_file.tc_ecvud10
  
   LET l_plant = g_plant
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_tc_ecv05,"|")      
   LET i=1                    #FUN-B10010
   SELECT max(tc_ecvud10) INTO l_tc_ecvud10 FROM tc_ecv_file 
    WHERE tc_ecv01= g_tc_ecv_1.tc_ecv01
      AND tc_ecv02= g_tc_ecv_1.tc_ecv02
      AND tc_ecv03= g_tc_ecv_1.tc_ecv03
      AND tc_ecv04= g_tc_ecv_1.tc_ecv04
   WHILE tok.hasMoreTokens()
      LET l_tc_ecv.tc_ecv05 = tok.nextToken()
      LET l_tc_ecv.tc_ecv06 = '' 
      LET l_tc_ecv.tc_ecv07 = ''
      LET l_tc_ecv.tc_ecvud01 = ''
      LET l_tc_ecv.tc_ecvud02 = ''
      LET l_tc_ecv.tc_ecvud03 = ''
      LET l_tc_ecv.tc_ecvud04 = ''
      LET l_tc_ecv.tc_ecvud05 = ''
      LET l_tc_ecv.tc_ecvud06 = ''
      LET l_tc_ecv.tc_ecvud07 = ''
      LET l_tc_ecv.tc_ecvud08 = ''
      LET l_tc_ecv.tc_ecvud09 = ''
      IF cl_null(l_tc_ecvud10) THEN 
         LET l_tc_ecv.tc_ecvud10 = i
      ELSE 
         LET l_tc_ecv.tc_ecvud10 = i+l_tc_ecvud10
      END IF 
      LET l_tc_ecv.tc_ecvud11 = ''
      LET l_tc_ecv.tc_ecvud12 = ''
      LET l_tc_ecv.tc_ecvud13 = ''
      LET l_tc_ecv.tc_ecvud14 = ''
      LET l_tc_ecv.tc_ecvud15 = ''
      LET l_tc_ecv.tc_ecv01 = g_tc_ecv_1.tc_ecv01
      LET l_tc_ecv.tc_ecv02 = g_tc_ecv_1.tc_ecv02
      LET l_tc_ecv.tc_ecv03 = g_tc_ecv_1.tc_ecv03
      LET l_tc_ecv.tc_ecv04 = g_tc_ecv_1.tc_ecv04
      LET l_tc_ecv.tc_ecvacti = 'Y'
      LET l_tc_ecv.tc_ecvuser = g_user
      LET l_tc_ecv.tc_ecvgrup = g_grup
      LET l_tc_ecv.tc_ecvmodu = ''
      LET l_tc_ecv.tc_ecvdate = g_today
        
      INSERT INTO tc_ecv_file VALUES (l_tc_ecv.*)
      IF STATUS THEN
         CALL s_errmsg('tc_ecv01',l_tc_ecv.tc_ecv05,'INS tc_ecv_file',STATUS,1)
         CONTINUE WHILE
      END IF
      LET i = i+1                         
   END WHILE
   CALL s_showmsg()
END FUNCTION