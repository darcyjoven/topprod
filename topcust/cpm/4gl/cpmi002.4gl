# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: 仓库对应作业编号
# Descriptions...: cpmi002
# Date & Author..: guanyao 16/05/31


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE g_tc_aec_1 RECORD
         tc_aec01  LIKE tc_aec_file.tc_aec01,
         imd02     LIKE imd_file.imd02
                  END RECORD,
       g_tc_aec_1_t  RECORD
         tc_aec01  LIKE tc_aec_file.tc_aec01,
         imd02     LIKE imd_file.imd02
                  END RECORD,
       g_tc_aec    DYNAMIC ARRAY OF RECORD
         tc_aec02    LIKE tc_aec_file.tc_aec02,
         tc_aec03    LIKE tc_aec_file.tc_aec03,
         ecm45       LIKE ecm_file.ecm45, 
         tc_aec04    LIKE tc_aec_file.tc_aec04,
         tc_aec05    LIKE tc_aec_file.tc_aec05,
         tc_aec06    LIKE tc_aec_file.tc_aec06,
         tc_aec07    LIKE tc_aec_file.tc_aec07,
         tc_aec08    LIKE tc_aec_file.tc_aec08,
         tc_aec09    LIKE tc_aec_file.tc_aec09,
         tc_aec10    LIKE tc_aec_file.tc_aec10,
         tc_aec11    LIKE tc_aec_file.tc_aec11,
         tc_aec12    LIKE tc_aec_file.tc_aec12,
         tc_aec13    LIKE tc_aec_file.tc_aec13, 
         tc_aec14    LIKE tc_aec_file.tc_aec14,
         tc_aec15    LIKE tc_aec_file.tc_aec15,
         tc_aec16    LIKE tc_aec_file.tc_aec16,
         tc_aec17    LIKE tc_aec_file.tc_aec17,
         tc_aec18    LIKE tc_aec_file.tc_aec18,
         tc_aec19    LIKE tc_aec_file.tc_aec19,
         tc_aec20    LIKE tc_aec_file.tc_aec20,
         tc_aecuser  LIKE tc_aec_file.tc_aecuser,
         tc_aecgrep  LIKE tc_aec_file.tc_aecgrep,
         tc_aecmodu  LIKE tc_aec_file.tc_aecmodu,
         tc_aecdate  LIKE tc_aec_file.tc_aecdate
                   END RECORD,
       g_tc_aec_t  RECORD
         tc_aec02    LIKE tc_aec_file.tc_aec02,
         tc_aec03    LIKE tc_aec_file.tc_aec03,
         ecm45       LIKE ecm_file.ecm45, 
         tc_aec04    LIKE tc_aec_file.tc_aec04,
         tc_aec05    LIKE tc_aec_file.tc_aec05,
         tc_aec06    LIKE tc_aec_file.tc_aec06,
         tc_aec07    LIKE tc_aec_file.tc_aec07,
         tc_aec08    LIKE tc_aec_file.tc_aec08,
         tc_aec09    LIKE tc_aec_file.tc_aec09,
         tc_aec10    LIKE tc_aec_file.tc_aec10,
         tc_aec11    LIKE tc_aec_file.tc_aec11,
         tc_aec12    LIKE tc_aec_file.tc_aec12,
         tc_aec13    LIKE tc_aec_file.tc_aec13, 
         tc_aec14    LIKE tc_aec_file.tc_aec14,
         tc_aec15    LIKE tc_aec_file.tc_aec15,
         tc_aec16    LIKE tc_aec_file.tc_aec16,
         tc_aec17    LIKE tc_aec_file.tc_aec17,
         tc_aec18    LIKE tc_aec_file.tc_aec18,
         tc_aec19    LIKE tc_aec_file.tc_aec19,
         tc_aec20    LIKE tc_aec_file.tc_aec20,
         tc_aecuser  LIKE tc_aec_file.tc_aecuser,
         tc_aecgrep  LIKE tc_aec_file.tc_aecgrep,
         tc_aecmodu  LIKE tc_aec_file.tc_aecmodu,
         tc_aecdate  LIKE tc_aec_file.tc_aecdate
                  END RECORD,

       g_tc_aec_2 RECORD LIKE tc_aec_file.*,

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

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("CPM")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   INITIALIZE g_tc_aec_1.* TO NULL

   LET g_forupd_sql = "SELECT * FROM tc_aec_file WHERE tc_aec01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i002_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR


   OPEN WINDOW i002_w WITH FORM "cpm/42f/cpmi002"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()


   LET g_action_choice = ""
   CALL i002_menu()

   CLOSE WINDOW i002_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i002_cs()

    CLEAR FORM
    INITIALIZE g_tc_aec_1.* TO NULL      
    CONSTRUCT g_wc ON                     # 螢幕上取條件
        tc_aec01,tc_aec02,tc_aec03,tc_aec04,tc_aec05,tc_aec06,tc_aec07,tc_aec08,tc_aec09,
        tc_aec10,tc_aec11,tc_aec12,tc_aec13,tc_aec14,tc_aec15,tc_aec16,tc_aec17,tc_aec18,
        tc_aec19,tc_aec20,tc_aecuser,tc_aecgrep,tc_aecmodu,tc_aecdate
        FROM tc_aec01,s_tc_aec[1].tc_aec02,s_tc_aec[1].tc_aec03,
             s_tc_aec[1].tc_aec04,s_tc_aec[1].tc_aec05,s_tc_aec[1].tc_aec06,
             s_tc_aec[1].tc_aec07,s_tc_aec[1].tc_aec08,s_tc_aec[1].tc_aec09,
             s_tc_aec[1].tc_aec10,s_tc_aec[1].tc_aec11,s_tc_aec[1].tc_aec12,
             s_tc_aec[1].tc_aec13,s_tc_aec[1].tc_aec14,s_tc_aec[1].tc_aec15,
             s_tc_aec[1].tc_aec16,s_tc_aec[1].tc_aec17,s_tc_aec[1].tc_aec18,
             s_tc_aec[1].tc_aec19,s_tc_aec[1].tc_aec20,s_tc_aec[1].tc_aecuser,
             s_tc_aec[1].tc_aecgrep,s_tc_aec[1].tc_aecmodu,s_tc_aec[1].tc_aecdate
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_aec03)
                 CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_aec03
                 NEXT FIELD tc_aec03
              WHEN INFIELD(tc_aec01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_imd"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = "W"
                 LET g_qryparam.default1 = g_tc_aec_1.tc_aec01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_aec01
                 NEXT FIELD tc_aec01
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

    LET g_sql="SELECT DISTINCT tc_aec01 FROM tc_aec_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY tc_aec01"
    PREPARE i002_prepare FROM g_sql
    DECLARE i002_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i002_prepare
    DROP TABLE x

    LET g_sql="SELECT DISTINCT tc_aec01 FROM tc_aec_file ",
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

#        WHEN "invalid"
#           IF cl_chk_act_auth() THEN
#              CALL i002_x()
#           END IF

        WHEN "reproduce"
           IF cl_chk_act_auth() THEN
              CALL i002_copy()
           END IF

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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_aec),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_aec_1.tc_aec01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_aec01"
                 LET g_doc.value1 = g_tc_aec_1.tc_aec01
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
   DISPLAY ARRAY g_tc_aec TO s_tc_aec.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
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
    INITIALIZE g_tc_aec_1.* TO NULL            #No.FUN-6A0015
    CALL g_tc_aec.clear()
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
        CALL cl_err(g_tc_aec_1.tc_aec01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_aec_1.* TO NULL
    ELSE
        CALL i002_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i002_fetch(p_flag)
DEFINE p_flag     LIKE type_file.chr1

    CASE p_flag
        WHEN 'N' FETCH NEXT     i002_cs INTO g_tc_aec_1.tc_aec01
        WHEN 'P' FETCH PREVIOUS i002_cs INTO g_tc_aec_1.tc_aec01
        WHEN 'F' FETCH FIRST    i002_cs INTO g_tc_aec_1.tc_aec01
        WHEN 'L' FETCH LAST     i002_cs INTO g_tc_aec_1.tc_aec01
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
            FETCH ABSOLUTE g_jump i002_cs INTO g_tc_aec_1.tc_aec01
            LET mi_no_ask = FALSE         #No.FUN-6A0066
    END CASE

    SELECT DISTINCT tc_aec01,imd02 INTO g_tc_aec_1.* 
      FROM tc_aec_file LEFT JOIN imd_file ON imd01 = tc_aec01
     WHERE tc_aec01 = g_tc_aec_1.tc_aec01
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_aec_1.tc_aec01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_aec_1.* TO NULL  #TQC-6B0105
        LET g_tc_aec_1.tc_aec01 = NULL      #TQC-6B0105
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
    LET g_tc_aec_1_t.* = g_tc_aec_1.*
    DISPLAY BY NAME g_tc_aec_1.*
    CALL i002_b_fill(' 1=1')
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i002_a()

    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_tc_aec_1.* TO NULL
    CALL g_tc_aec.clear()
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i002_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_tc_aec_1.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_tc_aec_1.tc_aec01 IS NULL THEN              # KEY 不可空白
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
DEFINE l_y           LIKE type_file.num5
DEFINE l_imd02       LIKE imd_file.imd02
DEFINE l_x           LIKE type_file.num5

   DISPLAY BY NAME g_tc_aec_1.*
   
   INPUT BY NAME
      g_tc_aec_1.tc_aec01
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i002_set_entry(p_cmd)
          CALL i002_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

      AFTER FIELD tc_aec01
         IF NOT cl_null(g_tc_aec_1.tc_aec01) THEN
            LET l_x = 0
            SELECT COUNT(*) INTO l_x FROM imd_file 
             WHERE imd10 = 'W' 
               AND imd01 = g_tc_aec_1.tc_aec01 
               AND imdacti = 'Y'     
            IF l_x = 0 OR cl_null(l_x) THEN
               CALL cl_err(g_tc_aec_1.tc_aec01,'cpm-030',0) 
               NEXT FIELD tc_aec01
            END IF
            LET l_imd02 = ''
            SELECT imd02 INTO g_tc_aec_1.imd02 FROM imd_file WHERE imd01 =  g_tc_aec_1.tc_aec01
            DISPLAY BY NAME g_tc_aec_1.imd02       
         END IF 

      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(tc_aec01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_imd"
              LET g_qryparam.arg1 = "W"
              LET g_qryparam.default1 = g_tc_aec_1.tc_aec01
              CALL cl_create_qry() RETURNING g_tc_aec_1.tc_aec01
              DISPLAY BY NAME g_tc_aec_1.tc_aec01
              NEXT FIELD tc_aec01

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
      CALL cl_set_comp_entry("tc_aec01",TRUE) 
    END IF
END FUNCTION

FUNCTION i002_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_aec01",FALSE) 
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
    
    IF g_tc_aec_1.tc_aec01 IS NULL THEN
       RETURN
    END IF
    
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT tc_aec02,tc_aec03,'',tc_aec04,tc_aec05,tc_aec06,tc_aec07,tc_aec08,tc_aec09,",
                       "       tc_aec10,tc_aec11,tc_aec12,tc_aec13,tc_aec14,tc_aec15,tc_aec16,tc_aec17,",
                       "       tc_aec18,tc_aec19,tc_aec20,tc_aecuser,tc_aecgrep,tc_aecmodu,tc_aecdate",
                       "  FROM tc_aec_file",
                       "  WHERE tc_aec01= ? AND tc_aec02= ? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i002_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_tc_aec WITHOUT DEFAULTS FROM s_tc_aec.*
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
              LET g_tc_aec_t.* = g_tc_aec[l_ac].*
              OPEN i002_bcl USING g_tc_aec_1.tc_aec01,g_tc_aec_t.tc_aec02
              IF STATUS THEN
                 CALL cl_err("OPEN i002_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i002_bcl INTO g_tc_aec[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_aec_t.tc_aec02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT ecd02 INTO g_tc_aec[l_ac].ecm45 FROM ecd_file WHERE ecd01 = g_tc_aec[l_ac].tc_aec03
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_aec[l_ac].* TO NULL      #900423
           LET g_tc_aec[l_ac].tc_aecuser = g_user
           LET g_tc_aec[l_ac].tc_aecgrep = g_grup
           LET g_tc_aec[l_ac].tc_aecdate = g_today
           LET g_tc_aec[l_ac].tc_aec04  = 'N'
           LET g_tc_aec_t.* = g_tc_aec[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD tc_aec02 

        BEFORE FIELD  tc_aec02
           IF g_tc_aec[l_ac].tc_aec02 IS NULL OR g_tc_aec[l_ac].tc_aec02 =0 THEN 
              SELECT max(tc_aec02)+1 INTO g_tc_aec[l_ac].tc_aec02 FROM tc_aec_file 
              WHERE tc_aec01 = g_tc_aec_1.tc_aec01
                IF g_tc_aec[l_ac].tc_aec02 IS NULL  THEN 
                   LET g_tc_aec[l_ac].tc_aec02 = 1 
                END IF 
            END IF 

        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           INSERT INTO tc_aec_file(tc_aec01,tc_aec02,tc_aec03,tc_aec04,tc_aec05,tc_aec06,tc_aec07,tc_aec08,tc_aec09,
                                   tc_aec10,tc_aec11,tc_aec12,tc_aec13,tc_aec14,tc_aec15,tc_aec16,tc_aec17,tc_aec18,
                                   tc_aec19,tc_aec20,tc_aecuser,tc_aecgrep,tc_aecmodu,tc_aecdate)
           VALUES(g_tc_aec_1.tc_aec01,g_tc_aec[l_ac].tc_aec02,g_tc_aec[l_ac].tc_aec03,g_tc_aec[l_ac].tc_aec04,
                  g_tc_aec[l_ac].tc_aec05,g_tc_aec[l_ac].tc_aec06,g_tc_aec[l_ac].tc_aec07,g_tc_aec[l_ac].tc_aec08,
                  g_tc_aec[l_ac].tc_aec09,g_tc_aec[l_ac].tc_aec10,g_tc_aec[l_ac].tc_aec11,g_tc_aec[l_ac].tc_aec12,
                  g_tc_aec[l_ac].tc_aec13,g_tc_aec[l_ac].tc_aec14,g_tc_aec[l_ac].tc_aec15,g_tc_aec[l_ac].tc_aec16,
                  g_tc_aec[l_ac].tc_aec17,g_tc_aec[l_ac].tc_aec18,g_tc_aec[l_ac].tc_aec19,g_tc_aec[l_ac].tc_aec20,
                  g_tc_aec[l_ac].tc_aecuser,g_tc_aec[l_ac].tc_aecgrep,g_tc_aec[l_ac].tc_aecmodu,g_tc_aec[l_ac].tc_aecdate)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_aec_file",g_tc_aec_1.tc_aec01,'',SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'  
              COMMIT WORK
              LET g_rec_b=g_rec_b+1 
              DISPLAY g_rec_b TO FORMONLY.cn2    
           END IF

        AFTER FIELD tc_aec02
           IF NOT cl_null(g_tc_aec[l_ac].tc_aec02) THEN 
              IF g_tc_aec_t.tc_aec02 ! = g_tc_aec[l_ac].tc_aec02 OR 
                 g_tc_aec_t.tc_aec02 IS NULL THEN 
                 SELECT count(*) INTO l_a FROM tc_aec_file 
                  WHERE tc_aec01 = g_tc_aec_1.tc_aec01 
                    AND tc_aec02 = g_tc_aec[l_ac].tc_aec02
                 IF l_a >0 THEN 
                    CALL cl_err('','cpm-031',0)
                    NEXT FIELD tc_aec02
                 END IF 
              END IF 
           END  IF

        AFTER FIELD tc_aec03
           IF NOT cl_null(g_tc_aec[l_ac].tc_aec03) THEN 
              IF g_tc_aec_t.tc_aec03 ! = g_tc_aec[l_ac].tc_aec03 OR 
                 g_tc_aec_t.tc_aec03 IS NULL THEN 
                 LET l_a = 0
                 SELECT COUNT(*) INTO l_a FROM ecd_file 
                  WHERE ecd01 = g_tc_aec[l_ac].tc_aec03
                    AND ecdacti = 'Y'
                 IF cl_null(l_a) OR l_a = 0 THEN 
                    CALL cl_err('','cpm-032',0)
                    NEXT FIELD tc_aec03
                 END IF 
                 LET l_a = 0
                 SELECT COUNT(*) INTO l_a FROM tc_aec_file 
                  WHERE tc_aec01 = g_tc_aec_1.tc_aec01 
                    AND tc_aec03 = g_tc_aec[l_ac].tc_aec03
                 IF l_a > 0 THEN 
                    CALL cl_err('','cpm-033',0)
                    NEXT FIELD tc_aec03
                 END IF 
                 SELECT ecd02 INTO g_tc_aec[l_ac].ecm45 FROM ecd_file 
                  WHERE ecd01= g_tc_aec[l_ac].tc_aec03
                   AND ecdacti = 'Y'
                 DISPLAY BY NAME g_tc_aec[l_ac].ecm45
              END IF 
           END IF 
        
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_tc_aec_t.tc_aec02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE    
              END IF              
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE    
              END IF              
              DELETE FROM tc_aec_file
               WHERE tc_aec01 = g_tc_aec_1.tc_aec01
                 AND tc_aec02 = g_tc_aec_t.tc_aec02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_aec_file",g_tc_aec_1.tc_aec01,g_tc_aec_t.tc_aec02,SQLCA.sqlcode,"","",1) 
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
              LET g_tc_aec[l_ac].* = g_tc_aec_t.*
              CLOSE i002_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_aec[l_ac].tc_aec04,-263,1)
              LET g_tc_aec[l_ac].* = g_tc_aec_t.*
           ELSE
              UPDATE tc_aec_file SET tc_aec02=g_tc_aec[l_ac].tc_aec02,
                                     tc_aec03=g_tc_aec[l_ac].tc_aec03,
                                     tc_aec04=g_tc_aec[l_ac].tc_aec04,
                                     tc_aec05=g_tc_aec[l_ac].tc_aec05,
                                     tc_aec06=g_tc_aec[l_ac].tc_aec06,
                                     tc_aec07=g_tc_aec[l_ac].tc_aec07,
                                     tc_aec08=g_tc_aec[l_ac].tc_aec08,
                                     tc_aec09=g_tc_aec[l_ac].tc_aec09,
                                     tc_aec10=g_tc_aec[l_ac].tc_aec10,
                                     tc_aec11=g_tc_aec[l_ac].tc_aec11,
                                     tc_aec12=g_tc_aec[l_ac].tc_aec12,
                                     tc_aec13=g_tc_aec[l_ac].tc_aec13,
                                     tc_aec14=g_tc_aec[l_ac].tc_aec14,
                                     tc_aec15=g_tc_aec[l_ac].tc_aec15,
                                     tc_aec16=g_tc_aec[l_ac].tc_aec16,
                                     tc_aec17=g_tc_aec[l_ac].tc_aec17,
                                     tc_aec18=g_tc_aec[l_ac].tc_aec18,
                                     tc_aec19=g_tc_aec[l_ac].tc_aec19,
                                     tc_aec20=g_tc_aec[l_ac].tc_aec20,
                                     tc_aecmodu=g_user,
                                     tc_aecdate=g_today
               WHERE tc_aec01=g_tc_aec_1.tc_aec01
                 AND tc_aec02 = g_tc_aec_t.tc_aec02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tc_aec_file",g_tc_aec_1.tc_aec01,g_tc_aec_t.tc_aec02,SQLCA.sqlcode,"","",1)
                 LET g_tc_aec[l_ac].* = g_tc_aec_t.*
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
                 LET g_tc_aec[l_ac].* = g_tc_aec_t.*
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
              WHEN INFIELD(tc_aec03)                 #作業編號
                 CALL q_ecd(FALSE,TRUE,g_tc_aec[l_ac].tc_aec03) RETURNING g_tc_aec[l_ac].tc_aec03
                 DISPLAY BY NAME g_tc_aec[l_ac].tc_aec03     #No.MOD-490371
                 NEXT FIELD tc_aec03
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

   LET g_sql = "SELECT tc_aec02,tc_aec03,ecd02,tc_aec04,tc_aec05,tc_aec06,tc_aec07,tc_aec08,tc_aec09,",
               "       tc_aec10,tc_aec11,tc_aec12,tc_aec13,tc_aec14,tc_aec15,tc_aec16,tc_aec17,tc_aec18,tc_aec19,",
               "       tc_aec20,tc_aecuser,tc_aecgrep,tc_aecmodu,tc_aecdate",
               "  FROM tc_aec_file LEFT JOIN ecd_file ON ecd01 = tc_aec03 AND ecdacti = 'Y'",
               " WHERE tc_aec01 = '",g_tc_aec_1.tc_aec01,"' ",
               "  AND ", g_wc CLIPPED

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY tc_aec02 "
   DISPLAY g_sql

   PREPARE i002_pb FROM g_sql
   DECLARE tc_aec_cs CURSOR FOR i002_pb

   CALL g_tc_aec.clear()
   LET g_cnt = 1

   FOREACH tc_aec_cs INTO g_tc_aec[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_tc_aec.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION i002_copy()
DEFINE      l_n       LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_new01   LIKE tc_aec_file.tc_aec01,
            l_new02   LIKE tc_aec_file.tc_aec02,
            l_old01   LIKE tc_aec_file.tc_aec01,
            l_old02   LIKE tc_aec_file.tc_aec02
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_tc_aec_1.tc_aec01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   LET g_before_input_done = FALSE
    CALL i002_set_entry('a')
    LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_new01 WITHOUT DEFAULTS FROM tc_aec01  #No.FUN-710055
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

     AFTER FIELD tc_aec01
         IF cl_null(l_new01) THEN
            NEXT FIELD tc_aec01
         END IF

          SELECT COUNT(*) INTO g_cnt FROM tc_aec_file
           WHERE tc_aec01 = l_new01
          IF g_cnt > 0 THEN
             CALL cl_err_msg(NULL,"cec-009",l_new01,10)
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
              WHEN INFIELD(tc_aec01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_imd"
                 LET g_qryparam.arg1 = "W"
                 LET g_qryparam.default1 = l_new01
                 CALL cl_create_qry() RETURNING l_new01
                 DISPLAY BY NAME l_new01
                 NEXT FIELD tc_aec01
                OTHERWISE
                 EXIT CASE
           END CASE
         
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_tc_aec_1.tc_aec01 TO tc_aec01  
      RETURN
   END IF
 
   DROP TABLE x

   SELECT * FROM tc_aec_file 
     WHERE tc_aec01=g_tc_aec_1.tc_aec01 
   INTO TEMP x

 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_tc_aec_1.tc_aec01,'',SQLCA.sqlcode,"","",1)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET tc_aec01 = l_new01
 
   INSERT INTO tc_aec_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","tc_aec_file",l_new01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660081
      RETURN
   ELSE    
      DROP TABLE x
      SELECT * FROM tc_aec_file 
       WHERE tc_aec01=g_tc_aec_1.tc_aec01 
        INTO TEMP x
      UPDATE x
         SET tc_aec01 = l_new01                    
      INSERT INTO tc_aec_file SELECT * FROM x
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_tc_aec_1.tc_aec01
   LET g_tc_aec_1.tc_aec01 = l_new01
   CALL i002_b()
   LET g_tc_aec_1.tc_aec01 = l_old01
   CALL i002_show()

END FUNCTION

FUNCTION i002_r()
    IF g_tc_aec_1.tc_aec01 IS NULL THEN  #FUN-C60033
      CALL cl_err("",-400,0)  
      RETURN
   END IF

   BEGIN WORK 
   OPEN i002_cl USING g_tc_aec_1.tc_aec01
   IF STATUS THEN
      CALL cl_err(g_tc_aec_1.tc_aec01,SQLCA.sqlcode,0)
      CLOSE i002_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i002_cl INTO g_tc_aec_1.tc_aec01
   IF SQLCA.sqlcode THEN                                         #資料被他人LOCK
         CALL cl_err(g_tc_aec_1.tc_aec01,SQLCA.sqlcode,0) RETURN END IF
   CALL i002_show()

   IF cl_delh(15,21) THEN                #確認一下
       INITIALIZE g_doc.* TO NULL     
       LET g_doc.column1 = "tc_aec01"       #FUN-C60033
       LET g_doc.value1 = g_tc_aec_1.tc_aec01  #FUN-C60033
       CALL cl_del_doc()       
       DELETE FROM tc_aec_file WHERE tc_aec01 = g_tc_aec_1.tc_aec01
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","tc_aec_file","","",SQLCA.sqlcode,"","BODY DELETE:",1)
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
        CALL g_tc_aec.clear()
       MESSAGE ""
       OPEN i002_count #MOD-D60152 add
       FETCH i002_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i002_cl
          CLOSE i002_count
          COMMIT WORK
          RETURN
       END IF
    
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