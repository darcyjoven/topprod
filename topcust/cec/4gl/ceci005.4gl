# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ceci005
# Descriptions...: 归集点作业
# Date & Author..: guanyao 16/07/29


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE g_tc_sfc_1 RECORD
         tc_sfc01    LIKE tc_sfc_file.tc_sfc01,
         tc_sfcud01  LIKE tc_sfc_file.tc_sfcud01
                  END RECORD,
       g_tc_sfc_1_t  RECORD
         tc_sfc01    LIKE tc_sfc_file.tc_sfc01,
         tc_sfcud01  LIKE tc_sfc_file.tc_sfcud01
                  END RECORD,
       g_tc_sfc    DYNAMIC ARRAY OF RECORD
         tc_sfc02  LIKE tc_sfc_file.tc_sfc02,
         ecd02     LIKE ecd_file.ecd02
                   END RECORD,
       g_tc_sfc_t  RECORD
         tc_sfc02  LIKE tc_sfc_file.tc_sfc02,
         ecd02     LIKE ecd_file.ecd02
                  END RECORD,

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

   IF (NOT cl_setup("CEC")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   INITIALIZE g_tc_sfc_1.* TO NULL

   LET g_forupd_sql = "SELECT * FROM tc_sfc_file WHERE tc_sfc01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i005_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR


   OPEN WINDOW i005_w WITH FORM "cec/42f/ceci005"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()


   LET g_action_choice = ""
   CALL i005_menu()

   CLOSE WINDOW i005_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i005_cs()

    CLEAR FORM
    INITIALIZE g_tc_sfc_1.* TO NULL      
    CONSTRUCT g_wc ON                     # 螢幕上取條件
        tc_sfc01,tc_sfcud01,tc_sfc02
        FROM tc_sfc01,tc_sfcud01,
             s_tc_sfc[1].tc_sfc02
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_sfc02)
                   CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tc_sfc02
                   NEXT FIELD tc_sfc02
              
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

    LET g_sql="SELECT DISTINCT tc_sfc01 FROM tc_sfc_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY tc_sfc01"
    PREPARE i005_prepare FROM g_sql
    DECLARE i005_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i005_prepare
    DROP TABLE x

    LET g_sql="SELECT DISTINCT tc_sfc01 FROM tc_sfc_file ",
              " WHERE ",g_wc CLIPPED,
              " INTO TEMP x"
    PREPARE i005_ins_temp_pre FROM g_sql
    EXECUTE i005_ins_temp_pre
    
    LET g_sql=
        "SELECT COUNT(*) FROM x "
    PREPARE i005_precount FROM g_sql
    DECLARE i005_count CURSOR FOR i005_precount
END FUNCTION

FUNCTION i005_menu()

   WHILE TRUE
      CALL i005_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i005_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i005_q()
            END IF

        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i005_r()
           END IF

        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i005_u()
           END IF

#        WHEN "invalid"
#           IF cl_chk_act_auth() THEN
#              CALL i005_x()
#           END IF

        WHEN "reproduce"
           IF cl_chk_act_auth() THEN
              CALL i005_copy()
           END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i005_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_sfc),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_sfc_1.tc_sfc01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_sfc01"
                 LET g_doc.value1 = g_tc_sfc_1.tc_sfc01
                 CALL cl_doc()
               END IF
         END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION i005_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_sfc TO s_tc_sfc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
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
         CALL i005_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION previous
         CALL i005_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION jump
         CALL i005_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION next
         CALL i005_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)

      ON ACTION last
         CALL i005_fetch('L')
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

FUNCTION i005_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_tc_sfc_1.* TO NULL            #No.FUN-6A0015
    CALL g_tc_sfc.clear()
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i005_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i005_count
    FETCH i005_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i005_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfc_1.tc_sfc01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_sfc_1.* TO NULL
    ELSE
        CALL i005_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i005_fetch(p_flag)
DEFINE p_flag     LIKE type_file.chr1

    CASE p_flag
        WHEN 'N' FETCH NEXT     i005_cs INTO g_tc_sfc_1.tc_sfc01
        WHEN 'P' FETCH PREVIOUS i005_cs INTO g_tc_sfc_1.tc_sfc01
        WHEN 'F' FETCH FIRST    i005_cs INTO g_tc_sfc_1.tc_sfc01
        WHEN 'L' FETCH LAST     i005_cs INTO g_tc_sfc_1.tc_sfc01
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
            FETCH ABSOLUTE g_jump i005_cs INTO g_tc_sfc_1.tc_sfc01
            LET mi_no_ask = FALSE         #No.FUN-6A0066
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfc_1.tc_sfc01,SQLCA.sqlcode,0)
        INITIALIZE g_tc_sfc_1.* TO NULL  #TQC-6B0105
        LET g_tc_sfc_1.tc_sfc01 = NULL      #TQC-6B0105
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

    CALL i005_show()                   # 重新顯示
END FUNCTION

FUNCTION i005_show()

    SELECT tc_sfc01,tc_sfcud01 INTO g_tc_sfc_1.* FROM tc_sfc_file WHERE tc_sfc01= g_tc_sfc_1.tc_sfc01
    LET g_tc_sfc_1_t.* = g_tc_sfc_1.*
    DISPLAY BY NAME g_tc_sfc_1.*
    CALL i005_b_fill(' 1=1')
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i005_a()

    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_tc_sfc_1.* TO NULL
    CALL g_tc_sfc.clear()
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i005_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_tc_sfc_1.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_tc_sfc_1.tc_sfc01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF 
        LET g_rec_b = 0
        CALL i005_b_fill('1=1')
        CALL i005_b()
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i005_i(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1
DEFINE l_y           LIKE type_file.num5
DEFINE l_x           LIKE type_file.num5

   DISPLAY BY NAME g_tc_sfc_1.*
   
   INPUT BY NAME
      g_tc_sfc_1.tc_sfc01,g_tc_sfc_1.tc_sfcud01
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i005_set_entry(p_cmd)
          CALL i005_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

      AFTER FIELD tc_sfc01
         IF NOT cl_null(g_tc_sfc_1.tc_sfc01) THEN 
            LET l_x = ''
            SELECT COUNT(*) INTO l_x  FROM tc_sfc_file WHERE tc_sfc01 = g_tc_sfc_1.tc_sfc01
            IF l_x >0 THEN 
               CALL cl_err('tc_sfc01','cec-011',0)
               NEXT FIELD tc_sfc01
            END IF 
         END IF 
      

      AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

     {ON ACTION controlp
        CASE
           WHEN INFIELD(tc_sfc01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_tc_sfc_1.tc_sfc01
              CALL cl_create_qry() RETURNING g_tc_sfc_1.tc_sfc01
              DISPLAY BY NAME g_tc_sfc_1.tc_sfc01
              NEXT FIELD tc_sfc01

           OTHERWISE
              EXIT CASE
           END CASE}

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

FUNCTION i005_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN        #No.FUN-550021
      CALL cl_set_comp_entry("tc_sfc01",TRUE) 
    END IF
END FUNCTION

FUNCTION i005_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_sfc01",FALSE) 
   END IF
END FUNCTION

FUNCTION i005_b()
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
    
    IF g_tc_sfc_1.tc_sfc01 IS NULL THEN
       RETURN
    END IF
    
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT tc_sfc02,''",
                       "  FROM tc_sfc_file",
                       "  WHERE tc_sfc01= ? AND tc_sfc02= ? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i005_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_tc_sfc WITHOUT DEFAULTS FROM s_tc_sfc.*
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
              LET g_tc_sfc_t.* = g_tc_sfc[l_ac].*
              OPEN i005_bcl USING g_tc_sfc_1.tc_sfc01,g_tc_sfc_t.tc_sfc02
              IF STATUS THEN
                 CALL cl_err("OPEN i005_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i005_bcl INTO g_tc_sfc[l_ac].*
                 SELECT ecd02 INTO g_tc_sfc[l_ac].ecd02 FROM ecd_file WHERE ecd01 = g_tc_sfc[l_ac].tc_sfc02
                 DISPLAY BY NAME g_tc_sfc[l_ac].ecd02
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_sfc_t.tc_sfc02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tc_sfc[l_ac].* TO NULL      #900423
           LET g_tc_sfc_t.* = g_tc_sfc[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD tc_sfc02


        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           INSERT INTO tc_sfc_file(tc_sfc01,tc_sfc02,tc_sfcud01)
           VALUES(g_tc_sfc_1.tc_sfc01,g_tc_sfc[l_ac].tc_sfc02,g_tc_sfc_1.tc_sfcud01)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","tc_sfc_file",g_tc_sfc_1.tc_sfc01,g_tc_sfc[l_ac].tc_sfc02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'  
              COMMIT WORK
              LET g_rec_b=g_rec_b+1 
              DISPLAY g_rec_b TO FORMONLY.cn2    
           END IF

        AFTER FIELD tc_sfc02
           IF NOT cl_null(g_tc_sfc[l_ac].tc_sfc02) THEN 
              IF g_tc_sfc_t.tc_sfc02 ! = g_tc_sfc[l_ac].tc_sfc02 OR 
                 g_tc_sfc_t.tc_sfc02 IS NULL THEN 
                 SELECT count(*) INTO l_a FROM tc_sfc_file 
                  WHERE tc_sfc01 = g_tc_sfc_1.tc_sfc01 
                    AND tc_sfc02 = g_tc_sfc[l_ac].tc_sfc02
                 IF l_a >0 THEN 
                    CALL cl_err('','cec-012',0)
                    NEXT FIELD tc_sfc02
                 END IF 
                 SELECT ecd02 INTO g_tc_sfc[l_ac].ecd02 FROM ecd_file WHERE ecd01= g_tc_sfc[l_ac].tc_sfc02
                 DISPLAY BY NAME g_tc_sfc[l_ac].ecd02
              END IF 
           END  IF
           
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_tc_sfc_t.tc_sfc02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE    
              END IF              
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE    
              END IF              
              DELETE FROM tc_sfc_file
               WHERE tc_sfc01 = g_tc_sfc_1.tc_sfc01
                 AND tc_sfc02 = g_tc_sfc_t.tc_sfc02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tc_sfc_file",g_tc_sfc_1.tc_sfc01,g_tc_sfc_t.tc_sfc02,SQLCA.sqlcode,"","",1) 
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
              LET g_tc_sfc[l_ac].* = g_tc_sfc_t.*
              CLOSE i005_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tc_sfc[l_ac].tc_sfc02,-263,1)
              LET g_tc_sfc[l_ac].* = g_tc_sfc_t.*
           ELSE
              UPDATE tc_sfc_file SET tc_sfc02=g_tc_sfc[l_ac].tc_sfc02
               WHERE tc_sfc01=g_tc_sfc_1.tc_sfc01
                 AND tc_sfc02=g_tc_sfc_t.tc_sfc02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","tc_sfc_file",g_tc_sfc_1.tc_sfc01,g_tc_sfc_t.tc_sfc02,SQLCA.sqlcode,"","",1)
                 LET g_tc_sfc[l_ac].* = g_tc_sfc_t.*
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
                 LET g_tc_sfc[l_ac].* = g_tc_sfc_t.*
              END IF
              CLOSE i005_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i005_bcl
           COMMIT WORK                
                                  
        ON ACTION CONTROLZ        
           CALL cl_show_req_fields()
                                  
        ON ACTION CONTROLG        
           CALL cl_cmdask()       
                 
        ON ACTION controlp
           CASE
             WHEN INFIELD(tc_sfc02) #廠商編號
                CALL q_ecd(FALSE,TRUE,g_tc_sfc[l_ac].tc_sfc02)
                   RETURNING g_tc_sfc[l_ac].tc_sfc02
                DISPLAY BY NAME g_tc_sfc[l_ac].tc_sfc02      #No.MOD-490371
                NEXT FIELD tc_sfc02
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
              
    CLOSE i005_bcl 
    COMMIT WORK  

END FUNCTION

FUNCTION i005_b_fill(p_wc2)
DEFINE p_wc2  STRING
IF cl_null(g_wc) THEN 
LET g_wc = ' 1=1'
END  IF 

   LET g_sql = "SELECT tc_sfc02,ecd02",
               "  FROM tc_sfc_file LEFT JOIN ecd_file ON ecd01 = tc_sfc02",
               " WHERE tc_sfc01 = '",g_tc_sfc_1.tc_sfc01,"' ",
               "  AND ", g_wc CLIPPED

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY tc_sfc02 "
   DISPLAY g_sql

   PREPARE i005_pb FROM g_sql
   DECLARE tc_sfc_cs CURSOR FOR i005_pb

   CALL g_tc_sfc.clear()
   LET g_cnt = 1

   FOREACH tc_sfc_cs INTO g_tc_sfc[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_tc_sfc.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION i005_copy()
DEFINE      l_n       LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_new01   LIKE tc_sfc_file.tc_sfc01,
            l_new02   LIKE tc_sfc_file.tc_sfc02,
            l_old01   LIKE tc_sfc_file.tc_sfc01,
            l_old02   LIKE tc_sfc_file.tc_sfc02
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_tc_sfc_1.tc_sfc01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   LET g_before_input_done = FALSE
    CALL i005_set_entry('a')
    LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_new01 WITHOUT DEFAULTS FROM tc_sfc01  #No.FUN-710055
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
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
              WHEN INFIELD(tc_sfc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_jmb"
                 LET g_qryparam.default1 = l_new01
                 CALL cl_create_qry() RETURNING l_new01
                 DISPLAY BY NAME l_new01
                 NEXT FIELD tc_sfc01
            OTHERWISE
                 EXIT CASE
           END CASE
         
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_tc_sfc_1.tc_sfc01 TO tc_sfc01  
      RETURN
   END IF
 
   DROP TABLE x

   SELECT * FROM tc_sfc_file 
     WHERE tc_sfc01=g_tc_sfc_1.tc_sfc01 
   INTO TEMP x

 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_tc_sfc_1.tc_sfc01,'',SQLCA.sqlcode,"","",1)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET tc_sfc01 = l_new01                     # No.FUN-710055
 
   INSERT INTO tc_sfc_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","tc_sfc_file",l_new01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660081
      RETURN
   ELSE    
      DROP TABLE x
      SELECT * FROM tc_sfc_file 
       WHERE tc_sfc01=g_tc_sfc_1.tc_sfc01 
        INTO TEMP x
      UPDATE x
         SET tc_sfc01 = l_new01                    
      INSERT INTO tc_sfc_file SELECT * FROM x
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_tc_sfc_1.tc_sfc01
   LET g_tc_sfc_1.tc_sfc01 = l_new01
   CALL i005_u()
   CALL i005_b()
   LET g_tc_sfc_1.tc_sfc01 = l_old01
   CALL i005_show()

END FUNCTION

FUNCTION i005_u()
DEFINE  l_cnt   LIKE type_file.num5     #NO FUN-690009 SMALLINT
   IF s_shut(0) THEN RETURN END IF
   
   IF g_tc_sfc_1.tc_sfc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
 
   BEGIN WORK
   OPEN i005_cl USING g_tc_sfc_1.tc_sfc01       
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_sfc_1.tc_sfc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE i005_cs
      ROLLBACK WORK
      RETURN
   ELSE
      FETCH i005_cl INTO g_tc_sfc_1.tc_sfc01

      IF SQLCA.sqlcode THEN
         CALL cl_err(g_tc_sfc_1.tc_sfc01,SQLCA.sqlcode,0)  # 資料被他人LOCK
         CLOSE i005_cl ROLLBACK WORK RETURN
      END IF
   END IF
   LET g_tc_sfc_1_t.* = g_tc_sfc_1.* 
   CALL i005_show()
   WHILE TRUE 
      CALL i005_i("u")                                  
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tc_sfc_1.*=g_tc_sfc_1_t.*
         CALL i005_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE tc_sfc_file SET tc_sfc_file.tc_sfcud01 = g_tc_sfc_1.tc_sfcud01

                    WHERE tc_sfc_file.tc_sfc01 = g_tc_sfc_1_t.tc_sfc01     #FUN-C60033 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","tc_sfc_file",g_tc_sfc_1_t.tc_sfc01,"",SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE

       ELSE


      END IF

      EXIT WHILE
   END WHILE
   CLOSE i005_cl
   COMMIT WORK
   CALL i005_b_fill('1=1')
END FUNCTION

FUNCTION i005_r()
    IF g_tc_sfc_1.tc_sfc01 IS NULL THEN  #FUN-C60033
      CALL cl_err("",-400,0)  
      RETURN
   END IF

   BEGIN WORK 
   OPEN i005_cl USING g_tc_sfc_1.tc_sfc01
   IF STATUS THEN
      CALL cl_err(g_tc_sfc_1.tc_sfc01,SQLCA.sqlcode,0)
      CLOSE i005_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i005_cl INTO g_tc_sfc_1.tc_sfc01
   IF SQLCA.sqlcode THEN                                         #資料被他人LOCK
         CALL cl_err(g_tc_sfc_1.tc_sfc01,SQLCA.sqlcode,0) RETURN END IF
   CALL i005_show()

   IF cl_delh(15,21) THEN                #確認一下
       INITIALIZE g_doc.* TO NULL     
       LET g_doc.column1 = "tc_sfc01"       #FUN-C60033
       LET g_doc.value1 = g_tc_sfc_1.tc_sfc01  #FUN-C60033
       CALL cl_del_doc()       
       DELETE FROM tc_sfc_file WHERE tc_sfc01 = g_tc_sfc_1.tc_sfc01
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","tc_sfc_file","","",SQLCA.sqlcode,"","BODY DELETE:",1)
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
        CALL g_tc_sfc.clear()
       MESSAGE ""
       OPEN i005_count #MOD-D60152 add
       FETCH i005_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i005_cl
          CLOSE i005_count
          COMMIT WORK
          RETURN
       END IF
    
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i005_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i005_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i005_fetch('/')
       END IF

    END IF 
   CLOSE i005_cl
   COMMIT WORK
END FUNCTION 