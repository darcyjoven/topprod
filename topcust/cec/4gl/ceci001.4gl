# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ceci001
# Descriptions...: 消耗性料件使用配比维护作业
# Date & Author..: guanyao


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE g_tc_ecu_1 RECORD
         tc_ecu01     LIKE tc_ecu_file.tc_ecu01,
         tc_ecu02     LIKE tc_ecu_file.tc_ecu02
                  END RECORD,
       g_tc_ecu_1_t  RECORD
         tc_ecu01     LIKE tc_ecu_file.tc_ecu01,
         tc_ecu02     LIKE tc_ecu_file.tc_ecu02
                  END RECORD,
       g_tc_ecu    DYNAMIC ARRAY OF RECORD
         tc_ecuud10   LIKE tc_ecu_file.tc_ecuud10,
         tc_ecu03     LIKE tc_ecu_file.tc_ecu03, 
         tc_ecu04     LIKE tc_ecu_file.tc_ecu04,
         ima02        LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         tc_ecu05     LIKE tc_ecu_file.tc_ecu05,
         tc_ecu06     LIKE tc_ecu_file.tc_ecu06,
         tc_ecuud01   LIKE tc_ecu_file.tc_ecuud01,
         tc_ecuud02   LIKE tc_ecu_file.tc_ecuud02,
         tc_ecuud03   LIKE tc_ecu_file.tc_ecuud03,
         tc_ecuud04   LIKE tc_ecu_file.tc_ecuud04,
         tc_ecuud05   LIKE tc_ecu_file.tc_ecuud05,
         tc_ecuud06   LIKE tc_ecu_file.tc_ecuud06,
         tc_ecuud07   LIKE tc_ecu_file.tc_ecuud07,
         tc_ecuud08   LIKE tc_ecu_file.tc_ecuud08,
         tc_ecuud09   LIKE tc_ecu_file.tc_ecuud09,
         tc_ecuud11   LIKE tc_ecu_file.tc_ecuud11,
         tc_ecuud12   LIKE tc_ecu_file.tc_ecuud12,
         tc_ecuud13   LIKE tc_ecu_file.tc_ecuud13,
         tc_ecuud14   LIKE tc_ecu_file.tc_ecuud14,
         tc_ecuud15   LIKE tc_ecu_file.tc_ecuud15
                   END RECORD,
       g_tc_ecu_t  RECORD
         tc_ecuud10   LIKE tc_ecu_file.tc_ecuud10,
         tc_ecu03     LIKE tc_ecu_file.tc_ecu03, 
         tc_ecu04     LIKE tc_ecu_file.tc_ecu04,
         ima02        LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         tc_ecu05     LIKE tc_ecu_file.tc_ecu05,
         tc_ecu06     LIKE tc_ecu_file.tc_ecu06,
         tc_ecuud01   LIKE tc_ecu_file.tc_ecuud01,
         tc_ecuud02   LIKE tc_ecu_file.tc_ecuud02,
         tc_ecuud03   LIKE tc_ecu_file.tc_ecuud03,
         tc_ecuud04   LIKE tc_ecu_file.tc_ecuud04,
         tc_ecuud05   LIKE tc_ecu_file.tc_ecuud05,
         tc_ecuud06   LIKE tc_ecu_file.tc_ecuud06,
         tc_ecuud07   LIKE tc_ecu_file.tc_ecuud07,
         tc_ecuud08   LIKE tc_ecu_file.tc_ecuud08,
         tc_ecuud09   LIKE tc_ecu_file.tc_ecuud09,
         tc_ecuud11   LIKE tc_ecu_file.tc_ecuud11,
         tc_ecuud12   LIKE tc_ecu_file.tc_ecuud12,
         tc_ecuud13   LIKE tc_ecu_file.tc_ecuud13,
         tc_ecuud14   LIKE tc_ecu_file.tc_ecuud14,
         tc_ecuud15   LIKE tc_ecu_file.tc_ecuud15
                  END RECORD,

       g_tc_ecu_2 RECORD LIKE tc_ecu_file.*,

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
DEFINE  g_multi_tc_ecu03  STRING 

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
   INITIALIZE g_tc_ecu_1.* TO NULL

   LET g_forupd_sql = "SELECT * FROM tc_ecu_file WHERE tc_ecu01 = ? AND tc_ecu02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR


   OPEN WINDOW i001_w WITH FORM "cec/42f/ceci001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()


   LET g_action_choice = ""
   CALL i001_menu()

   CLOSE WINDOW i001_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i001_cs()

    CLEAR FORM
    INITIALIZE g_tc_ecu_1.* TO NULL      
    CONSTRUCT g_wc ON                     # 螢幕上取條件
        tc_ecu01,tc_ecu02,tc_ecu03,tc_ecu04,tc_ecu05,tc_ecu06,tc_ecuud01,tc_ecuud02,tc_ecuud03,
        tc_ecuud04,tc_ecuud05,tc_ecuud06,tc_ecuud07,tc_ecuud08,tc_ecuud09,tc_ecuud10,tc_ecuud11,
        tc_ecuud12,tc_ecuud13,tc_ecuud14,tc_ecuud15
        FROM tc_ecu01,tc_ecu02,
             s_tc_ecu[1].tc_ecu03,s_tc_ecu[1].tc_ecu04,s_tc_ecu[1].tc_ecu05,s_tc_ecu[1].tc_ecu06,
             s_tc_ecu[1].tc_ecuud01,s_tc_ecu[1].tc_ecuud02,s_tc_ecu[1].tc_ecuud03,s_tc_ecu[1].tc_ecuud04,
             s_tc_ecu[1].tc_ecuud05,s_tc_ecu[1].tc_ecuud06,s_tc_ecu[1].tc_ecuud07,s_tc_ecu[1].tc_ecuud08,
             s_tc_ecu[1].tc_ecuud09,s_tc_ecu[1].tc_ecuud10,s_tc_ecu[1].tc_ecuud11,s_tc_ecu[1].tc_ecuud12,
             s_tc_ecu[1].tc_ecuud13,s_tc_ecu[1].tc_ecuud14,s_tc_ecu[1].tc_ecuud15
             
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_ecu01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_ecu01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_ecu_1.tc_ecu01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecu01
                 NEXT FIELD tc_ecu01
              
              WHEN INFIELD(tc_ecu02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_ecv03"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_ecu_1.tc_ecu02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecu02
                 NEXT FIELD tc_ecu02

             WHEN INFIELD(tc_ecu03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_ecu03_1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_ecu[1].tc_ecu03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecu03
                 NEXT FIELD tc_ecu03

             WHEN INFIELD(tc_ecu04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_ecu04"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tc_ecu[1].tc_ecu04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ecu04
                 NEXT FIELD tc_ecu04
                 
              OTHERWISE
                 EXIT CASE
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

    LET g_sql="SELECT DISTINCT tc_ecu01,tc_ecu02 FROM tc_ecu_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY tc_ecu01"
    PREPARE i001_prepare FROM g_sql
    DECLARE i001_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i001_prepare
    DROP TABLE x

    LET g_sql="SELECT DISTINCT tc_ecu01,tc_ecu02 FROM tc_ecu_file ",
              " WHERE ",g_wc CLIPPED,
              " INTO TEMP x"
    PREPARE i001_ins_temp_pre FROM g_sql
    EXECUTE i001_ins_temp_pre
    
    LET g_sql=
        "SELECT COUNT(*) FROM x "
    PREPARE i001_precount FROM g_sql
    DECLARE i001_count CURSOR FOR i001_precount
END FUNCTION

FUNCTION i001_menu()

   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i001_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF

        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i001_r()
           END IF

#        WHEN "modify"
#           IF cl_chk_act_auth() THEN
#              CALL i001_u()
#           END IF

#        WHEN "invalid"
#           IF cl_chk_act_auth() THEN
#              CALL i001_x()
#           END IF

       # WHEN "reproduce"
       #    IF cl_chk_act_auth() THEN
       #       CALL i001_copy()
       #    END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i001_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_ecu),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_ecu_1.tc_ecu01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_ecu01"
                 LET g_doc.value1 = g_tc_ecu_1.tc_ecu01
                 CALL cl_doc()
               END IF
         END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i001_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_ecu TO s_tc_ecu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
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
         CALL i001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION previous
         CALL i001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION jump
         CALL i001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION next
         CALL i001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION last
         CALL i001_fetch('L')
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

FUNCTION i001_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_tc_ecu_1.* TO NULL            #No.FUN-6A0015
    CALL g_tc_ecu.clear()
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i001_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i001_count
    FETCH i001_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i001_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_ecu_1.tc_ecu01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_ecu_1.* TO NULL
    ELSE
        CALL i001_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i001_fetch(p_flag)
DEFINE p_flag     LIKE type_file.chr1

    CASE p_flag
        WHEN 'N' FETCH NEXT     i001_cs INTO g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02
        WHEN 'P' FETCH PREVIOUS i001_cs INTO g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02
        WHEN 'F' FETCH FIRST    i001_cs INTO g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02
        WHEN 'L' FETCH LAST     i001_cs INTO g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02
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
            FETCH ABSOLUTE g_jump i001_cs INTO g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02
            LET mi_no_ask = FALSE         #No.FUN-6A0066
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_ecu_1.tc_ecu01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_ecu_1.* TO NULL  #TQC-6B0105
        LET g_tc_ecu_1.tc_ecu01 = NULL      #TQC-6B0105
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

    CALL i001_show()                   # 重新顯示
END FUNCTION

FUNCTION i001_show()

    LET g_tc_ecu_1_t.* = g_tc_ecu_1.*
    DISPLAY BY NAME g_tc_ecu_1.*
    CALL i001_b_fill(' 1=1')
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i001_a()

    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_tc_ecu_1.* TO NULL
    CALL g_tc_ecu.clear()
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i001_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_tc_ecu_1.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_tc_ecu_1.tc_ecu01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF 
        LET g_rec_b = 0
        CALL i001_b_fill('1=1')
        CALL i001_b()
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i001_i(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1
DEFINE l_x           LIKE type_file.num5
DEFINE l_ecb03       LIKE ecb_file.ecb03

   DISPLAY BY NAME g_tc_ecu_1.*
   
   INPUT BY NAME
      g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i001_set_entry(p_cmd)
          CALL i001_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

      AFTER FIELD tc_ecu01
         IF NOT cl_null(g_tc_ecu_1.tc_ecu01) THEN 
            LET l_x = 0
            SELECT COUNT(*) INTO  l_x FROM ecu_file,ima_file 
             WHERE ecu01 = g_tc_ecu_1.tc_ecu01  
               AND ima01 = ecu01 
               AND ima08 = 'M' 
            IF cl_null(l_x) OR l_x = 0 THEN 
               CALL cl_err('','cec-003',1)
               NEXT FIELD tc_ecu01
            ELSE 
               IF NOT cl_null(g_tc_ecu_1.tc_ecu02) THEN
                  LET l_ecb03 = '' 
                  SELECT ecb03 INTO l_ecb03 FROM ecb_file 
                   WHERE ecb01 = g_tc_ecu_1.tc_ecu01 
                     AND ecb02 = g_tc_ecu_1.tc_ecu02
                  IF cl_null(l_ecb03) THEN
                     CALL cl_err('','cec-004',0)
                     NEXT FIELD tc_ecu01
                  END IF  
               END IF 
            END IF 
         END IF 
      
      AFTER FIELD tc_ecu02
         IF NOT cl_null(g_tc_ecu_1.tc_ecu02) THEN 
            LET l_x = 0
            SELECT COUNT(*) INTO l_x FROM ecu_file
             WHERE ecu02 = g_tc_ecu_1.tc_ecu02  
            IF cl_null(l_x) OR l_x = 0 THEN 
               CALL cl_err('','cec-005',1)
               NEXT FIELD tc_ecu02
            ELSE 
               IF NOT cl_null(g_tc_ecu_1.tc_ecu01) THEN
                  LET l_ecb03 = ''  
                  SELECT ecb03 INTO l_ecb03 FROM ecb_file 
                   WHERE ecb01 = g_tc_ecu_1.tc_ecu01 
                     AND ecb02 = g_tc_ecu_1.tc_ecu02
                  IF cl_null(l_ecb03) THEN
                     CALL cl_err('','cec-004',0)
                     NEXT FIELD tc_ecu02
                  END IF  
               END IF 
            END IF 
         END IF

      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(tc_ecu01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_tc_ecu01"
              LET g_qryparam.default1 = g_tc_ecu_1.tc_ecu01
              CALL cl_create_qry() RETURNING g_tc_ecu_1.tc_ecu01
              DISPLAY BY NAME g_tc_ecu_1.tc_ecu01
              NEXT FIELD tc_ecu01
           WHEN INFIELD(tc_ecu02)
              CALL cl_init_qry_var()
              IF cl_null(g_tc_ecu_1.tc_ecu01) THEN 
                 LET g_qryparam.form = "cq_ecu"
              ELSE 
                 LET g_qryparam.form = "cq_ecu02"
                 LET g_qryparam.arg1=g_tc_ecu_1.tc_ecu01
              END IF 
              LET g_qryparam.default1 = g_tc_ecu_1.tc_ecu02
              CALL cl_create_qry() RETURNING g_tc_ecu_1.tc_ecu02
              DISPLAY BY NAME g_tc_ecu_1.tc_ecu02
              NEXT FIELD tc_ecu02
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

FUNCTION i001_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN        #No.FUN-550021
      CALL cl_set_comp_entry("tc_ecu01,tc_ecu02",TRUE) 
    END IF
END FUNCTION

FUNCTION i001_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_ecu01,tc_ecu02",FALSE) 
   END IF
END FUNCTION

FUNCTION i001_b()
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
    
    IF g_tc_ecu_1.tc_ecu01 IS NULL THEN
       RETURN
    END IF
    
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT tc_ecuud10,tc_ecu03,tc_ecu04,'','',tc_ecu05,tc_ecu06,tc_ecuud01,tc_ecuud02,tc_ecuud03,",
                       "       tc_ecuud04,tc_ecuud05,tc_ecuud06,tc_ecuud07,tc_ecuud08,tc_ecuud09,",
                       "       tc_ecuud11,tc_ecuud12,tc_ecuud13,tc_ecuud14,tc_ecuud15",
                       "  FROM tc_ecu_file",
                       "  WHERE tc_ecu01= ? AND tc_ecu02= ? AND tc_ecuud10 = ? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_tc_ecu WITHOUT DEFAULTS FROM s_tc_ecu.*
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
              LET g_tc_ecu_t.* = g_tc_ecu[l_ac].*
              OPEN i001_bcl USING g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02,g_tc_ecu_t.tc_ecuud10
              IF STATUS THEN
                 CALL cl_err("OPEN i001_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i001_bcl INTO g_tc_ecu[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_ecu_t.tc_ecuud10,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT ima02,ima021 INTO g_tc_ecu[l_ac].ima02,g_tc_ecu[l_ac].ima021 
                   FROM ima_file 
                  WHERE ima01 = g_tc_ecu[l_ac].tc_ecu04
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_ecu[l_ac].* TO NULL      #900423
           LET g_tc_ecu_t.* = g_tc_ecu[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD tc_ecuud10 

        BEFORE FIELD  tc_ecuud10
           IF g_tc_ecu[l_ac].tc_ecuud10 IS NULL OR g_tc_ecu[l_ac].tc_ecuud10 =0 THEN 
              SELECT max(tc_ecuud10)+1 INTO g_tc_ecu[l_ac].tc_ecuud10 FROM tc_ecu_file 
              WHERE tc_ecu01 = g_tc_ecu_1.tc_ecu01 AND tc_ecu02 = g_tc_ecu_1.tc_ecu02
                IF g_tc_ecu[l_ac].tc_ecuud10 IS NULL  THEN 
                   LET g_tc_ecu[l_ac].tc_ecuud10 = 1 
                END IF 
            END IF

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           INSERT INTO tc_ecu_file
           VALUES(g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02,g_tc_ecu[l_ac].tc_ecu03,g_tc_ecu[l_ac].tc_ecu04,
                  g_tc_ecu[l_ac].tc_ecu05,g_tc_ecu[l_ac].tc_ecu06,g_tc_ecu[l_ac].tc_ecuud01,g_tc_ecu[l_ac].tc_ecuud02,
                  g_tc_ecu[l_ac].tc_ecuud03,g_tc_ecu[l_ac].tc_ecuud04,g_tc_ecu[l_ac].tc_ecuud05,g_tc_ecu[l_ac].tc_ecuud06,
                  g_tc_ecu[l_ac].tc_ecuud07,g_tc_ecu[l_ac].tc_ecuud08,g_tc_ecu[l_ac].tc_ecuud09,g_tc_ecu[l_ac].tc_ecuud10,
                  g_tc_ecu[l_ac].tc_ecuud11,g_tc_ecu[l_ac].tc_ecuud12,g_tc_ecu[l_ac].tc_ecuud13,g_tc_ecu[l_ac].tc_ecuud14,
                  g_tc_ecu[l_ac].tc_ecuud15,'Y',g_user,g_grup,'',g_today)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_ecu_file",g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'  
              COMMIT WORK
              LET g_rec_b=g_rec_b+1 
              DISPLAY g_rec_b TO FORMONLY.cn2    
           END IF

        AFTER FIELD tc_ecuud10
           IF NOT cl_null(g_tc_ecu[l_ac].tc_ecuud10) THEN 
              IF g_tc_ecu_t.tc_ecuud10 ! = g_tc_ecu[l_ac].tc_ecuud10 OR 
                 g_tc_ecu_t.tc_ecuud10 IS NULL THEN 
                 SELECT count(*) INTO l_a FROM tc_ecu_file 
                 WHERE tc_ecu01 = g_tc_ecu_1.tc_ecu01 
                 AND tc_ecu02 = g_tc_ecu_1.tc_ecu02
                 AND tc_ecuud10 = g_tc_ecu[l_ac].tc_ecuud10
                 IF l_a >0 THEN 
                    CALL cl_err('','cec-007',0)
                    NEXT FIELD tc_ecuud10
                 END IF 
              END IF 
           END  IF

        AFTER FIELD tc_ecu03
           IF NOT cl_null(g_tc_ecu[l_ac].tc_ecu03) THEN 
              IF g_tc_ecu_t.tc_ecu03 ! = g_tc_ecu[l_ac].tc_ecu03 OR 
                 g_tc_ecu_t.tc_ecu03 IS NULL THEN 
                 LET l_a= 0
                 LET l_a=0                
                 SELECT count(*) INTO l_a FROM ecb_file 
                  WHERE ecb01 = g_tc_ecu_1.tc_ecu01 
                    AND ecb02 = g_tc_ecu_1.tc_ecu02
                    AND ecb03 = g_tc_ecu[l_ac].tc_ecu03
                 IF cl_null(l_a) OR l_a = 0 THEN 
                    CALL cl_err('','cec-005',0)
                    NEXT FIELD tc_ecu03
                 END IF
                 IF NOT cl_null(g_tc_ecu[l_ac].tc_ecu04) THEN 
                    SELECT count(*) INTO l_a FROM tc_ecu_file 
                     WHERE tc_ecu01 = g_tc_ecu_1.tc_ecu01 
                       AND tc_ecu02 = g_tc_ecu_1.tc_ecu02
                       AND tc_ecu04 = g_tc_ecu[l_ac].tc_ecu04
                       AND tc_ecu03 = g_tc_ecu[l_ac].tc_ecu03
                    IF l_a >0 THEN 
                       CALL cl_err('','cec-002',0)
                       NEXT FIELD tc_ecu03
                    END IF 
                 END IF 
              END IF 
           END  IF
        
        AFTER FIELD tc_ecu04
           IF NOT cl_null(g_tc_ecu[l_ac].tc_ecu04) THEN
              IF g_tc_ecu_t.tc_ecu04 ! = g_tc_ecu[l_ac].tc_ecu04 OR 
                 g_tc_ecu_t.tc_ecu04 IS NULL THEN 
                 LET l_x = 0
                 SELECT COUNT (*) INTO l_x FROM ima_file WHERE ima01 = g_tc_ecu[l_ac].tc_ecu04
                 IF cl_null(l_x) OR l_x = 0 THEN 
                    CALL cl_err('','cec-001',0)
                    NEXT FIELD tc_ecu04
                 ELSE
                    IF NOT cl_null(g_tc_ecu[l_ac].tc_ecu03) THEN 
                       SELECT COUNT(*) INTO l_x FROM tc_ecu_file 
                        WHERE tc_ecu01 = g_tc_ecu_1.tc_ecu01
                          AND tc_ecu02 = g_tc_ecu_1.tc_ecu02
                          AND tc_ecu03 = g_tc_ecu[l_ac].tc_ecu03
                          AND tc_ecu04 = g_tc_ecu[l_ac].tc_ecu04
                       IF l_x >0 THEN 
                          CALL cl_err('','cec-006',0)
                          NEXT FIELD tc_ecu04
                       END IF 
                    END IF      
                    SELECT ima02,ima021 INTO g_tc_ecu[l_ac].ima02,g_tc_ecu[l_ac].ima021
                      FROM ima_file 
                     WHERE ima01 = g_tc_ecu[l_ac].tc_ecu04
                    DISPLAY BY NAME g_tc_ecu[l_ac].ima02,g_tc_ecu[l_ac].ima021
                 END IF 
              END IF 
           END IF 
             
        
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_tc_ecu_t.tc_ecuud10 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE    
              END IF              
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE    
              END IF              
              DELETE FROM tc_ecu_file
               WHERE tc_ecu01 = g_tc_ecu_1.tc_ecu01
                 AND tc_ecu02 = g_tc_ecu_1.tc_ecu02
                 AND tc_ecuud10 = g_tc_ecu_t.tc_ecuud10
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_ecu_file",g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02,SQLCA.sqlcode,"","",1) 
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
              LET g_tc_ecu[l_ac].* = g_tc_ecu_t.*
              CLOSE i001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_ecu[l_ac].tc_ecu04,-263,1)
              LET g_tc_ecu[l_ac].* = g_tc_ecu_t.*
           ELSE
              UPDATE tc_ecu_file SET tc_ecu03=g_tc_ecu[l_ac].tc_ecu03,
                                     tc_ecu04=g_tc_ecu[l_ac].tc_ecu04,
                                     tc_ecu05=g_tc_ecu[l_ac].tc_ecu05,
                                     tc_ecu06=g_tc_ecu[l_ac].tc_ecu06,
                                     tc_ecuud01=g_tc_ecu[l_ac].tc_ecuud01,
                                     tc_ecuud02=g_tc_ecu[l_ac].tc_ecuud02,
                                     tc_ecuud03=g_tc_ecu[l_ac].tc_ecuud03,
                                     tc_ecuud04=g_tc_ecu[l_ac].tc_ecuud04,
                                     tc_ecuud05=g_tc_ecu[l_ac].tc_ecuud05,
                                     tc_ecuud06=g_tc_ecu[l_ac].tc_ecuud06,
                                     tc_ecuud07=g_tc_ecu[l_ac].tc_ecuud07,
                                     tc_ecuud08=g_tc_ecu[l_ac].tc_ecuud08,
                                     tc_ecuud09=g_tc_ecu[l_ac].tc_ecuud09,
                                     tc_ecuud10=g_tc_ecu[l_ac].tc_ecuud10,
                                     tc_ecuud11=g_tc_ecu[l_ac].tc_ecuud11,
                                     tc_ecuud12=g_tc_ecu[l_ac].tc_ecuud12,
                                     tc_ecuud13=g_tc_ecu[l_ac].tc_ecuud13,
                                     tc_ecuud14=g_tc_ecu[l_ac].tc_ecuud14,
                                     tc_ecuud15=g_tc_ecu[l_ac].tc_ecuud15,
                                     tc_ecumodu=g_user,
                                     tc_ecudate=g_today
               WHERE tc_ecu01=g_tc_ecu_1.tc_ecu01
                 AND tc_ecu02=g_tc_ecu_1.tc_ecu02
                 AND tc_ecuud10 = g_tc_ecu_t.tc_ecuud10
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tc_ecu_file",g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02,SQLCA.sqlcode,"","",1)
                 LET g_tc_ecu[l_ac].* = g_tc_ecu_t.*
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
                 LET g_tc_ecu[l_ac].* = g_tc_ecu_t.*
              END IF
              CLOSE i001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i001_bcl
           COMMIT WORK                
                                  
        ON ACTION CONTROLZ        
           CALL cl_show_req_fields()
                                  
        ON ACTION CONTROLG        
           CALL cl_cmdask()       
                 
        ON ACTION controlp
           CASE
             WHEN INFIELD(tc_ecu04) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="cq_tc_ecu04"   #MOD-920024 q_pmc2-->q_pmc1
               LET g_qryparam.default1 = g_tc_ecu[l_ac].tc_ecu04
               CALL cl_create_qry() RETURNING g_tc_ecu[l_ac].tc_ecu04
               DISPLAY BY NAME g_tc_ecu[l_ac].tc_ecu04
               NEXT FIELD tc_ecu04

             WHEN INFIELD(tc_ecu03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="cq_tc_ecu03"   #MOD-920024 q_pmc2-->q_pmc1
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1=g_tc_ecu_1.tc_ecu01
               LET g_qryparam.arg2=g_tc_ecu_1.tc_ecu02
               LET g_qryparam.plant = g_plant
               CALL cl_create_qry() RETURNING g_multi_tc_ecu03
               IF NOT cl_null(g_multi_tc_ecu03) THEN 
                  CALL i001_multi_tc_ecu04()
                  CALL i001_b_fill('1=1')
                  CALL i001_b()
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
              
    CLOSE i001_bcl 
    COMMIT WORK  

END FUNCTION

FUNCTION i001_b_fill(p_wc2)
DEFINE p_wc2  STRING
IF cl_null(g_wc) THEN 
LET g_wc = ' 1=1'
END  IF 

   LET g_sql = "SELECT tc_ecuud10,tc_ecu03,tc_ecu04,ima02,ima021,tc_ecu05,tc_ecu06,tc_ecuud01,tc_ecuud02,tc_ecuud03,",
               "       tc_ecuud04,tc_ecuud05,tc_ecuud06,tc_ecuud07,tc_ecuud08,tc_ecuud09,",
               "       tc_ecuud11,tc_ecuud12,tc_ecuud13,tc_ecuud14,tc_ecuud15",
               "  FROM tc_ecu_file LEFT JOIN ima_file ON ima01 = tc_ecu04",
               " WHERE tc_ecu01 = '",g_tc_ecu_1.tc_ecu01,"' ",
               "   AND tc_ecu02 = '",g_tc_ecu_1.tc_ecu02,"' ",
               "  AND ", g_wc CLIPPED

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY tc_ecu03 "
   DISPLAY g_sql

   PREPARE i001_pb FROM g_sql
   DECLARE tc_ecu_cs CURSOR FOR i001_pb

   CALL g_tc_ecu.clear()
   LET g_cnt = 1

   FOREACH tc_ecu_cs INTO g_tc_ecu[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_tc_ecu.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION i001_copy()
DEFINE      l_n       LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_new01   LIKE tc_ecu_file.tc_ecu01,
            l_new02   LIKE tc_ecu_file.tc_ecu02,
            l_old01   LIKE tc_ecu_file.tc_ecu01,
            l_old02   LIKE tc_ecu_file.tc_ecu02
DEFINE l_ecb03        LIKE oeb_file.oeb03
DEFINE l_x            LIKE type_file.num5
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_tc_ecu_1.tc_ecu01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   LET g_before_input_done = FALSE
    CALL i001_set_entry('a')
    LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_new01,l_new02 WITHOUT DEFAULTS FROM tc_ecu01,tc_ecu02  #No.FUN-710055
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

     AFTER FIELD tc_ecu01
       IF NOT cl_null(l_new01) THEN 
            LET l_x = 0
            SELECT COUNT(*) INTO  l_x FROM ecu_file,ima_file 
             WHERE ecu01 = l_new01  
               AND ima01 = ecu01 
               AND ima08 = 'M' 
            IF cl_null(l_x) OR l_x = 0 THEN 
               CALL cl_err('','cec-003',1)
               NEXT FIELD tc_ecu01
            ELSE 
               IF NOT cl_null(l_new02) THEN
                  LET l_ecb03 = '' 
                  SELECT ecb03 INTO l_ecb03 FROM ecb_file 
                   WHERE ecb01 = l_new01
                     AND ecb02 = l_new02
                  IF cl_null(l_ecb03) THEN
                     CALL cl_err('','cec-004',0)
                     NEXT FIELD tc_ecu01
                  END IF  
               END IF 
            END IF 
         END IF 

     AFTER FIELD tc_ecu02
        IF NOT cl_null(l_new02) THEN 
            LET l_x = 0
            SELECT COUNT(*) INTO l_x FROM ecu_file
             WHERE ecu02 = l_new02  
            IF cl_null(l_x) OR l_x = 0 THEN 
               CALL cl_err('','cec-005',1)
               NEXT FIELD tc_ecu02
            ELSE 
               IF NOT cl_null(l_new01) THEN
                  LET l_ecb03 = ''  
                  SELECT ecb03 INTO l_ecb03 FROM ecb_file 
                   WHERE ecb01 = l_new01 
                     AND ecb02 = l_new02
                  IF cl_null(l_ecb03) THEN
                     CALL cl_err('','cec-004',0)
                     NEXT FIELD tc_ecu02
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
              WHEN INFIELD(tc_ecu01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_tc_ecu01"
                 LET g_qryparam.default1 = l_new01
                 CALL cl_create_qry() RETURNING l_new01
                 DISPLAY BY NAME l_new01  
                 NEXT FIELD tc_ecu01
             WHEN INFIELD(tc_ecu02)
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
                 NEXT FIELD tc_ecu02
                OTHERWISE
                 EXIT CASE
           END CASE
         
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02 TO tc_ecu01,tc_ecu02  
      RETURN
   END IF
 
   DROP TABLE x

   SELECT * FROM tc_ecu_file 
     WHERE tc_ecu01=g_tc_ecu_1.tc_ecu01 and tc_ecu02=g_tc_ecu_1.tc_ecu02 
   INTO TEMP x

 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02,SQLCA.sqlcode,"","",1)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET tc_ecu01 = l_new01,                        # 資料鍵值
          tc_ecu02 = l_new02                     # No.FUN-710055
 
   INSERT INTO tc_ecu_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","tc_ecu_file",l_new01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660081
      RETURN
   ELSE    
      DROP TABLE x
      SELECT * FROM tc_ecu_file 
       WHERE tc_ecu01=g_tc_ecu_1.tc_ecu01 AND tc_ecu02=g_tc_ecu_1.tc_ecu02 
        INTO TEMP x
      UPDATE x
         SET tc_ecu01 = l_new01,
             tc_ecu02 = l_new02                    
      INSERT INTO tc_ecu_file SELECT * FROM x
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_tc_ecu_1.tc_ecu01
   LET l_old02 = g_tc_ecu_1.tc_ecu02
   LET g_tc_ecu_1.tc_ecu01 = l_new01
   LET g_tc_ecu_1.tc_ecu02 = l_new02
   CALL i001_b_fill('1=1')
   CALL i001_b()
   LET g_tc_ecu_1.tc_ecu01 = l_old01
   LET g_tc_ecu_1.tc_ecu02 = l_old02
   CALL i001_show()

END FUNCTION

FUNCTION i001_r()
    IF g_tc_ecu_1.tc_ecu01 IS NULL THEN  #FUN-C60033
      CALL cl_err("",-400,0)  
      RETURN
   END IF

   BEGIN WORK 
   OPEN i001_cl USING g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02
   IF STATUS THEN
      CALL cl_err(g_tc_ecu_1.tc_ecu01,SQLCA.sqlcode,0)
      CLOSE i001_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i001_cl INTO g_tc_ecu_1.tc_ecu01,g_tc_ecu_1.tc_ecu02
   IF SQLCA.sqlcode THEN                                         #資料被他人LOCK
         CALL cl_err(g_tc_ecu_1.tc_ecu01,SQLCA.sqlcode,0) RETURN END IF
   CALL i001_show()

   IF cl_delh(15,21) THEN                #確認一下
       INITIALIZE g_doc.* TO NULL     
       LET g_doc.column1 = "tc_ecu01"       #FUN-C60033
       LET g_doc.value1 = g_tc_ecu_1.tc_ecu01  #FUN-C60033
       CALL cl_del_doc()       
       DELETE FROM tc_ecu_file WHERE tc_ecu01 = g_tc_ecu_1.tc_ecu01 AND tc_ecu02 = g_tc_ecu_1.tc_ecu02
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","tc_ecu_file","","",SQLCA.sqlcode,"","BODY DELETE:",1)
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
        CALL g_tc_ecu.clear()
       MESSAGE ""
       OPEN i001_count #MOD-D60152 add
       FETCH i001_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i001_cl
          CLOSE i001_count
          COMMIT WORK
          RETURN
       END IF

       IF g_row_count > 0 THEN  #TQC-AC0245
           LET g_row_count = g_row_count - 1 #TQC-AC0245
        END IF
        DISPLAY g_row_count TO FORMONLY.cnt
    
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i001_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i001_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i001_fetch('/')
       END IF

    END IF 
   CLOSE i001_cl
   COMMIT WORK
END FUNCTION 

FUNCTION i001_multi_tc_ecu04()        
DEFINE   tok         base.StringTokenizer
DEFINE   l_sql       STRING
DEFINE   l_n         LIKE type_file.num5
DEFINE   l_plant     LIKE azw_file.azw01
DEFINE   l_unit      LIKE oeb_file.oeb05
DEFINE   g_cnt       LIKE type_file.num5 
DEFINE   l_tc_ecu    RECORD LIKE tc_ecu_file.*
DEFINE
  l_cnt, li_i                 LIKE type_file.num5,        
  l_qty                       LIKE type_file.num10,   
  p_cmd                       LIKE type_file.chr1,   
  i                           LIKE type_file.num5     #FUN-B10010
DEFINE l_tc_ecuud10    LIKE tc_ecu_file.tc_ecuud10    
  
   LET l_plant = g_plant
   CALL s_showmsg_init()
   LET tok = base.StringTokenizer.create(g_multi_tc_ecu03,"|")      
   LET i=1                    #FUN-B10010
   SELECT max(tc_ecuud10) INTO l_tc_ecuud10 FROM tc_ecu_file 
    WHERE tc_ecu01= g_tc_ecu_1.tc_ecu01
      AND tc_ecu02= g_tc_ecu_1.tc_ecu02
   WHILE tok.hasMoreTokens()
      LET l_tc_ecu.tc_ecu03 = tok.nextToken()
      LET l_tc_ecu.tc_ecu04 = '' 
      LET l_tc_ecu.tc_ecu05 = ''
      LET l_tc_ecu.tc_ecu06 = ''
      LET l_tc_ecu.tc_ecuud01 = ''
      LET l_tc_ecu.tc_ecuud02 = ''
      LET l_tc_ecu.tc_ecuud03 = ''
      LET l_tc_ecu.tc_ecuud04 = ''
      LET l_tc_ecu.tc_ecuud05 = ''
      LET l_tc_ecu.tc_ecuud06 = ''
      LET l_tc_ecu.tc_ecuud07 = ''
      LET l_tc_ecu.tc_ecuud08 = ''
      LET l_tc_ecu.tc_ecuud09 = ''
      IF cl_null(l_tc_ecuud10) THEN 
         LET l_tc_ecu.tc_ecuud10 = i
      ELSE 
         LET l_tc_ecu.tc_ecuud10 = i+l_tc_ecuud10
      END IF 
      LET l_tc_ecu.tc_ecuud11 = ''
      LET l_tc_ecu.tc_ecuud12 = ''
      LET l_tc_ecu.tc_ecuud13 = ''
      LET l_tc_ecu.tc_ecuud14 = ''
      LET l_tc_ecu.tc_ecuud15 = ''
      LET l_tc_ecu.tc_ecu01 = g_tc_ecu_1.tc_ecu01
      LET l_tc_ecu.tc_ecu02 = g_tc_ecu_1.tc_ecu02
      LET l_tc_ecu.tc_ecuacti = 'Y'
      LET l_tc_ecu.tc_ecuuser = g_user
      LET l_tc_ecu.tc_ecugrup = g_grup
      LET l_tc_ecu.tc_ecumodu = ''
      LET l_tc_ecu.tc_ecudate = g_today
        
      INSERT INTO tc_ecu_file VALUES (l_tc_ecu.*)
      IF STATUS THEN
         CALL s_errmsg('tc_ecu01',l_tc_ecu.tc_ecu03,'INS tc_ecu_file',STATUS,1)
         CONTINUE WHILE
      END IF
      LET i = i+1                         
   END WHILE
   CALL s_showmsg()
END FUNCTION