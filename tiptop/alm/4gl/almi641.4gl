# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern namb...: almi641.4gl
# Descriptions...: 積分公允價值設定作業 
# Date & Author..: No.FUN-CB0046 12/11/13 BY pauline 
# Modify.........: No.FUN-D10011 13/01/03 By pauline 當年月小於/等於關帳日期時不開放修改公允價值 


DATABASE ds

GLOBALS "../../config/top.global"


DEFINE g_ltx01               LIKE ltx_file.ltx01
DEFINE g_ltx01_t             LIKE ltx_file.ltx01
DEFINE g_ltx                 DYNAMIC ARRAY OF RECORD 
           ltx02             LIKE ltx_file.ltx02,
           ltx03             LIKE ltx_file.ltx03
                             END RECORD
DEFINE g_ltx_t               RECORD
           ltx02             LIKE ltx_file.ltx02,
           ltx03             LIKE ltx_file.ltx03
                             END RECORD
DEFINE g_wc                  STRING
DEFINE g_sql                 STRING
DEFINE g_forupd_sql          STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_sql_tmp             STRING   
DEFINE g_jump                LIKE type_file.num10,    
       g_no_ask              LIKE type_file.num5      
DEFINE g_cnt                 LIKE type_file.num10    
DEFINE g_i                   LIKE type_file.num5      
DEFINE g_msg                 LIKE type_file.chr1000   
DEFINE g_row_count           LIKE type_file.num10     
DEFINE g_curs_index          LIKE type_file.num10     
DEFINE g_before_input_done   LIKE type_file.num5      
DEFINE l_ac                  LIKE type_file.num5
DEFINE g_rec_b               LIKE type_file.num5
DEFINE g_aaa07               LIKE aaa_file.aaa07   #FUN-D10011 add

MAIN
    OPTIONS                                # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_ltx01 = NULL                     # 清除鍵值

    LET g_forupd_sql = " SELECT ltx02,ltx03 FROM ltx_file  ",
                        " WHERE ltx01 = ? AND ltx02 = ? AND ltx03 = ? ",
                          " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i641_cl CURSOR FROM g_forupd_sql

  #FUN-D10011 add sTART
   SELECT aaa07 INTO g_aaa07 FROM aaa_file
      WHERE aaa01 = g_aza.aza81
  #FUN-D10011 add END

    OPEN WINDOW i641_w WITH FORM "alm/42f/almi641"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()

    CALL i641_menu()
    CLOSE WINDOW i641_w                    # 結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION i641_curs()
   CALL g_ltx.clear()
   CLEAR FORM                             # 清除畫面
   CALL cl_set_head_visible("","YES")  
   INITIALIZE g_ltx01 TO NULL   
   CONSTRUCT g_wc ON ltx01,ltx02,ltx03    # 螢幕上取條件
                FROM ltx01,s_ltx[1].ltx02,s_ltx[1].ltx03
          
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

      ON ACTION qbe_select
        CALL cl_qbe_select()

      ON ACTION qbe_save
        CALL cl_qbe_save()

    END CONSTRUCT

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) 

    IF INT_FLAG THEN 
       RETURN 
    END IF

    LET g_sql= "SELECT DISTINCT ltx01 FROM ltx_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY ltx01"
    PREPARE i641_prepare FROM g_sql      # 預備一下
    DECLARE i641_b_curs                  # 宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i641_prepare

    LET g_sql="SELECT COUNT(DISTINCT ltx01) FROM ltx_file WHERE ",g_wc
    PREPARE i641_pre_count FROM g_sql
    DECLARE i641_count CURSOR FOR i641_pre_count
END FUNCTION

FUNCTION i641_menu()
   WHILE TRUE
      CALL i641_bp("G")
      CASE g_action_choice

         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i641_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i641_q()
            END IF

         WHEN "out_gift"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun("almg640")
            END IF

         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i641_copy()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i641_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ltx),'','')
            END IF
      
         WHEN "related_document"         
          IF cl_chk_act_auth() THEN
             IF g_ltx01 IS NOT NULL THEN
                LET g_doc.column1 = "ltx01"
                LET g_doc.value1 = g_ltx01
                CALL cl_doc()
             END IF
          END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i641_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ltx TO s_ltx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()               

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

     #串接贈品兌換報表
      ON ACTION out_gift
         LET g_action_choice = "out_gift"
         EXIT DISPLAY

      ON ACTION first
         CALL i641_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
           ACCEPT DISPLAY               

      ON ACTION previous
         CALL i641_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY             

      ON ACTION jump
         CALL i641_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
        ACCEPT DISPLAY             


      ON ACTION next
         CALL i641_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
        ACCEPT DISPLAY                

      ON ACTION last
         CALL i641_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
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
         LET INT_FLAG=FALSE           
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         
         CALL cl_about()      

      ON ACTION exporttoexcel     
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

     ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

     ON ACTION related_document                #No.FUN-6B0079  相關文件
        LET g_action_choice="related_document"
        EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i641_a()
    DEFINE l_i         LIKE type_file.num5
    DEFINE l_ltx       RECORD LIKE ltx_file.*
    WHILE TRUE
        MESSAGE ""
        CLEAR FORM
        CALL g_ltx.clear()
        INITIALIZE g_ltx01 TO NULL
        LET g_ltx01_t = NULL
        #預設值及將數值類變數清成零
        CALL cl_opmsg('a')
        BEGIN WORK
        CALL i641_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            EXIT WHILE
        END IF
        FOR l_i = 1 TO 12
           IF l_i = 0 THEN 
              CONTINUE FOR
           END IF
           IF l_i > 13 THEN
              EXIT FOR
           END IF
           LET l_ltx.ltx01 = g_ltx01
           LET l_ltx.ltx02 = l_i
           LET l_ltx.ltx02 = l_ltx.ltx02 USING "&&"
           LET l_ltx.ltx03 = 1
           INSERT INTO ltx_file VALUES(l_ltx.*)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ltx_file",g_ltx01,"",SQLCA.sqlcode,"","",1)
              LET g_success = 'N'
              EXIT FOR
           ELSE 
              LET g_success = 'Y'
           END IF
        END FOR
        IF g_success = 'Y' THEN
           MESSAGE 'INSERT O.K'
           COMMIT WORK
        END IF   
        LET g_ltx01_t = g_ltx01            #保留舊值
        CALL i641_show( "1=1")
        CALL i641_b()                      #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i641_i(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_j        LIKE type_file.num5
   DEFINE l_n        LIKE type_file.num5
   
   INPUT g_ltx01 WITHOUT DEFAULTS FROM ltx01 

      BEFORE INPUT
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE

      AFTER FIELD ltx01
         IF NOT cl_null(g_ltx01) THEN
            IF length(g_ltx01) <> 4 THEN
               CALL cl_err('','alm-h79',0)
               NEXT FIELD ltx01 
            END IF
            FOR l_j = 1 TO 4
               IF g_ltx01[l_j,l_j] NOT MATCHES '[0-9]' THEN
                  CALL cl_err('','alm-h80',0)
                  NEXT FIELD ltx01
               END IF
             END FOR   
             SELECT COUNT(ltx01) INTO l_n FROM ltx_file
                  WHERE ltx01 = g_ltx01
             IF l_n > 0 THEN
                 CALL cl_err('','-239',0)
                 NEXT FIELD ltx01
             END IF
                  
         END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

   END INPUT

END FUNCTION

FUNCTION i641_b_fill(l_wc)
   DEFINE l_wc      STRING
   DEFINE l_sql     STRING

   IF cl_null(l_wc) THEN
      LET l_wc = " 1=1"
   END IF

   CALL g_ltx.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   LET l_sql = " SELECT ltx02,ltx03 FROM ltx_file",
               "    WHERE ltx01 = '",g_ltx01,"' AND  ",l_wc CLIPPED, 
               " ORDER BY ltx02 "
   PREPARE i641_pb FROM l_sql
   DECLARE i641_curs CURSOR FOR i641_pb
   FOREACH i641_curs INTO g_ltx[g_cnt].*
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
   CALL g_ltx.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0   
END FUNCTION

FUNCTION i641_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1

    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    CALL cl_opmsg('b')


   #FUN-D10011 add START
    IF g_ltx01 < YEAR(g_aaa07) THEN
       CALL cl_err('','alm1393',0)
       RETURN
    END IF
   #FUN-D10011 add END

    INPUT ARRAY g_ltx WITHOUT DEFAULTS FROM s_ltx.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL cl_set_comp_entry("ltx02",FALSE)
            CALL cl_set_act_visible("insert,delete", FALSE)
            
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET  g_before_input_done = FALSE
               LET  g_before_input_done = TRUE

               LET g_ltx_t.* = g_ltx[l_ac].*  #BACKUP
               OPEN i641_cl USING g_ltx01,g_ltx_t.ltx02,g_ltx_t.ltx03
               IF STATUS THEN
                  CALL cl_err("OPEN i641_cl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i641_cl INTO g_ltx[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ltx01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()
            END IF

        AFTER FIELD ltx03
           IF g_ltx[l_ac].ltx03 != g_ltx_t.ltx03 THEN
              IF g_ltx[l_ac].ltx03 < 0 THEN
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD ltx03
              END IF
             #FUN-D10011 add START
              IF g_ltx01 = YEAR(g_aaa07) THEN
                 IF g_ltx_t.ltx02 < MONTH(g_aaa07) OR g_ltx_t.ltx02 = MONTH(g_aaa07) THEN
                    CALL cl_err('','alm1393',0)
                    LET g_ltx[l_ac].ltx03 = g_ltx_t.ltx03
                    NEXT FIELD ltx03
                 END IF 
              END IF
             #FUN-D10011 add END
           END IF            

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ltx[l_ac].* = g_ltx_t.*
              CLOSE i641_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ltx01,-263,1)
              LET g_ltx[l_ac].* = g_ltx_t.*
           ELSE
              UPDATE ltx_file SET ltx03 = g_ltx[l_ac].ltx03
                            WHERE ltx01 = g_ltx01
                              AND ltx02 = g_ltx_t.ltx02 
                              AND ltx03 = g_ltx_t.ltx03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ltx_file",g_ltx01,"",SQLCA.sqlcode,"","",1)
                 LET g_ltx[l_ac].* = g_ltx_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i641_cl
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ltx[l_ac].* = g_ltx_t.*
               END IF
               CLOSE i641_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i641_cl
            COMMIT WORK

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode())
                RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()
           
    END INPUT  
    CALL cl_set_act_visible("insert,delete", TRUE)
   
    CLOSE i641_cl
    COMMIT WORK
END FUNCTION    


#Query 查詢
FUNCTION i641_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i641_curs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i641_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
    IF STATUS THEN                         #有問題
        CALL cl_err('',STATUS,0)
        INITIALIZE g_ltx01 TO NULL
    ELSE
        CALL i641_fetch('F')            #讀出TEMP第一筆並顯示
        OPEN i641_count
        FETCH i641_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION


#處理資料的讀取
FUNCTION i641_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式     
    l_abso          LIKE type_file.num10                 #絕對的筆數   

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i641_b_curs INTO g_ltx01
        WHEN 'P' FETCH PREVIOUS i641_b_curs INTO g_ltx01
        WHEN 'F' FETCH FIRST    i641_b_curs INTO g_ltx01
        WHEN 'L' FETCH LAST     i641_b_curs INTO g_ltx01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i641_b_curs INTO g_ltx01
            LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ltx01,SQLCA.sqlcode,0)
        INITIALIZE g_ltx TO NULL   
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
    END IF

    IF STATUS THEN
        CALL cl_err(g_ltx01,STATUS,0)
    ELSE
        CALL i641_show(g_wc)
    END IF
END FUNCTION

#將資料顯示在畫面上
FUNCTION i641_show(p_wc)
    DEFINE p_wc           STRING
    DISPLAY g_ltx01 TO ltx01
    CALL i641_b_fill(p_wc)        
    CALL cl_show_fld_cont()                 
END FUNCTION


FUNCTION i641_copy()
DEFINE l_newno       LIKE ltx_file.ltx01
DEFINE l_oldno       LIKE ltx_file.ltx01
DEFINE l_j           LIKE type_file.num5
DEFINE l_n           LIKE type_file.num5

    IF g_ltx01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    LET l_newno = g_ltx01
    LET l_oldno = g_ltx01

    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno WITHOUT DEFAULTS FROM ltx01 


       AFTER FIELD ltx01
          IF NOT cl_null(l_newno) THEN
             IF length(l_newno) <> 4 THEN
                CALL cl_err('','alm-h79',0)
                NEXT FIELD ltx01
             END IF
             FOR l_j = 1 TO 4
                IF l_newno[l_j,l_j] NOT MATCHES '[0-9]' THEN
                   CALL cl_err('','alm-h80',0)
                   NEXT FIELD ltx01
                END IF
              END FOR
              SELECT COUNT(ltx01) INTO l_n FROM ltx_file
                   WHERE ltx01 = l_newno 
              IF l_n > 0 THEN
                  CALL cl_err('','-239',0)
                  NEXT FIELD ltx01
              END IF
       
          END IF

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about        
          CALL cl_about()     
 
       ON ACTION help         
          CALL cl_show_help() 
 
       ON ACTION controlg     
          CALL cl_cmdask()    

    END INPUT

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CALL i641_show(g_wc)
        RETURN
    END IF

    DROP TABLE y

    SELECT * FROM ltx_file WHERE ltx01 = l_oldno 
           INTO TEMP y

    UPDATE y SET y.ltx01 = l_newno    #資料鍵值   

    INSERT INTO ltx_file SELECT * FROM y

    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","ltx_file",l_newno,"",SQLCA.sqlcode,"","",1)   
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE 'COPY(',g_cnt USING '<<<<',') Rows O.K'

    LET g_ltx01 = l_newno
    LET g_ltx01_t = g_ltx01

    CALL i641_show(" 1=1")
    CALL i641_b()                      #輸入單身
    CALL i641_show( " 1=1")

END FUNCTION
#FUN-CB0046 
