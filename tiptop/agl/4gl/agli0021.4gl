# Prog. Version..: '5.30.06-13.04.22(00002)'     #
# Pattern name...: agli0021.4gl
# Descriptions...: 合併報表聯屬公司股本異動查詢修改作業
# Date & Author..: 12/06/01 By Belle(FUN-C50059)
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
#FUN-C50059
GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_axbb01          LIKE axbb_file.axbb01,
    g_axbb01_t        LIKE axbb_file.axbb01,
    g_axbb02          LIKE axbb_file.axbb02,
    g_axbb02_t        LIKE axbb_file.axbb02,
    g_axbb03          LIKE axbb_file.axbb03,
    g_axbb03_t        LIKE axbb_file.axbb03,
    g_axbb04          LIKE axbb_file.axbb04,
    g_axbb04_t        LIKE axbb_file.axbb04,
    g_axbb05          LIKE axbb_file.axbb05,
    g_axbb05_t        LIKE axbb_file.axbb05,
    g_axbb            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        axbb07        LIKE axbb_file.axbb07,
        axbb08        LIKE axbb_file.axbb08,
        axbb09        LIKE axbb_file.axbb09,
        axbb10        LIKE axbb_file.axbb10,
        aag02         LIKE aag_file.aag02,
        axbb06        LIKE axbb_file.axbb06
                      END RECORD,
    g_axbb_t          RECORD                     #程式變數 (舊值)
        axbb07        LIKE axbb_file.axbb07,
        axbb08        LIKE axbb_file.axbb08,
        axbb09        LIKE axbb_file.axbb09,
        axbb10        LIKE axbb_file.axbb10,
        aag02         LIKE aag_file.aag02,
        axbb06        LIKE axbb_file.axbb06
                      END RECORD,
    g_wc,g_sql,g_wc2  STRING,
    g_show            LIKE type_file.chr1,
    g_rec_b           LIKE type_file.num5,   #單身筆數
    g_flag            LIKE type_file.chr1,
    g_ss              LIKE type_file.chr1,
    l_ac              LIKE type_file.num5,   #目前處理的ARRAY CNT
    g_argv1           LIKE axbb_file.axbb01,
    g_argv2           LIKE axbb_file.axbb02,
    g_argv3           LIKE axbb_file.axbb03,
    g_argv4           LIKE axbb_file.axbb04,
    g_argv5           LIKE axbb_file.axbb05
DEFINE p_row,p_col    LIKE type_file.num5
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg         LIKE ze_file.ze03
DEFINE   g_row_count   LIKE type_file.num10
DEFINE   g_curs_index  LIKE type_file.num10
DEFINE   l_cmd         LIKE type_file.chr1000
DEFINE   g_aaz641      LIKE aaz_file.aaz641
DEFINE   g_plant_axz03 LIKE type_file.chr10

MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time


   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
   LET g_argv3 =ARG_VAL(3)
   LET g_argv4 =ARG_VAL(4)
   LET g_argv5 =ARG_VAL(5)

   LET p_row = 3 LET p_col = 16

   OPEN WINDOW i0021_w AT p_row,p_col
     WITH FORM "agl/42f/agli0021"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   IF NOT (cl_null(g_argv1) AND cl_null(g_argv2) AND cl_null(g_argv3) 
                            AND cl_null(g_argv4) AND cl_null(g_argv5)) THEN
      CALL i0021_q()
   END IF   
   CALL i0021_menu()

   CLOSE WINDOW i0021_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION i0021_cs()
DEFINE l_sql STRING

    IF NOT (cl_null(g_argv1) AND cl_null(g_argv2) AND cl_null(g_argv3)
                             AND cl_null(g_argv4) AND cl_null(g_argv5)) THEN
       LET g_wc = " axbb01 = '",g_argv1,"'"
             ," AND axbb02 = '",g_argv2,"'"
             ," AND axbb03 = '",g_argv3,"'"
             ," AND axbb04 = '",g_argv4,"'"
             ," AND axbb05 = '",g_argv5,"'"
    ELSE
       CLEAR FORM                            #清除畫面
       CALL g_axbb.clear()
       CALL cl_set_head_visible("","YES")
       INITIALIZE g_axbb01 TO NULL
       INITIALIZE g_axbb02 TO NULL
       INITIALIZE g_axbb03 TO NULL
       INITIALIZE g_axbb04 TO NULL
       INITIALIZE g_axbb05 TO NULL
       CONSTRUCT g_wc ON axbb01,axbb02,axbb03,axbb04,axbb05,axbb10,axbb06
            FROM axbb01,axbb02,axbb03,axbb04,axbb05,s_axbb[1].axbb10,s_axbb[1].axbb06
               
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
          ON ACTION CONTROLP
             CASE
                WHEN INFIELD(axbb01) #族群編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_axa1"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO axbb01
                   NEXT FIELD axbb01
                WHEN INFIELD(axbb02) #上層公司
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_axz"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO axbb02
                   NEXT FIELD axbb02
                WHEN INFIELD(axbb03) #上層帳別
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_aaa"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO axbb03
                   NEXT FIELD axbb03
                WHEN INFIELD(axbb04) #下層公司編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_axz"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO axbb04
                   NEXT FIELD axbb04
                WHEN INFIELD(axbb05) #下層帳別
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_aaa"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO axbb05
                   NEXT FIELD axbb05
                WHEN INFIELD(axbb10)
                   CALL q_m_aag2(TRUE,TRUE,g_plant_axz03,g_axbb[1].axbb10,'23',g_aaz641)
                       RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO axbb10
                   NEXT FIELD axbb10
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
          RETURN
       END IF
    END IF

    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT UNIQUE axbb01,axbb02,axbb03,axbb04,axbb05 FROM axbb_file "
             ," WHERE ", g_wc CLIPPED
    LET g_sql= l_sql," ORDER BY axbb01,axbb02,axbb04"
    PREPARE i0021_prepare FROM g_sql      #預備一下
    DECLARE i0021_bcs                     #宣告成可捲動的
    SCROLL CURSOR WITH HOLD FOR i0021_prepare
    
    LET g_sql="SELECT COUNT(*) "
             ,"  FROM ("
             ,"        SELECT UNIQUE axbb01,axbb02,axbb03,axbb04,axbb05 FROM axbb_file "
             ,"         WHERE ", g_wc CLIPPED,")"

    PREPARE i0021_precount FROM g_sql    
    DECLARE i0021_count CURSOR FOR i0021_precount
 
    CALL i0021_show()
END FUNCTION

FUNCTION i0021_menu()

   WHILE TRUE
      CALL i0021_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i0021_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i0021_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i0021_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i0021_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF                   
               LET l_cmd = 'p_query "agli0021" "',g_wc CLIPPED,'"'               
               CALL cl_cmdrun(l_cmd) 
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_axbb),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_axbb01 IS NOT NULL THEN
                LET g_doc.column1 = "axbb01"
                LET g_doc.column2 = "axbb02"
                LET g_doc.column3 = "axbb03"
                LET g_doc.column4 = "axbb04"
                LET g_doc.column5 = "axbb05"
                LET g_doc.value1 = g_axbb01
                LET g_doc.value2 = g_axbb02
                LET g_doc.value3 = g_axbb03
                LET g_doc.value4 = g_axbb04
                LET g_doc.value5 = g_axbb05
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i0021_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_axbb.clear()
   LET g_axbb01 = NULL
   LET g_axbb02 = NULL
   LET g_axbb03 = NULL
   LET g_axbb04 = NULL
   LET g_axbb05 = NULL
   LET g_axbb01_t = NULL
   LET g_axbb02_t = NULL
   LET g_axbb03_t = NULL
   LET g_axbb04_t = NULL
   LET g_axbb05_t = NULL
   CALL cl_opmsg('a')

   WHILE TRUE
      CALL i0021_i("a")                    #輸入單頭
      IF INT_FLAG THEN                    #使用者不玩了
         LET g_axbb01=NULL
         LET g_axbb02=NULL
         LET g_axbb03=NULL
         LET g_axbb04=NULL
         LET g_axbb05=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_ss='N' THEN
         CALL g_axbb.clear()
      ELSE
         CALL i0021_b_fill('1=1')         #單身
      END IF
      CALL i0021_b()                      #輸入單身
      LET g_axbb01_t = g_axbb01
      LET g_axbb02_t = g_axbb02
      LET g_axbb03_t = g_axbb03
      LET g_axbb04_t = g_axbb04
      LET g_axbb05_t = g_axbb05
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i0021_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改
   l_cnt           LIKE type_file.num10

   LET g_ss='Y'
 
   CALL cl_set_head_visible("","YES")

   INPUT g_axbb01,g_axbb02,g_axbb03,g_axbb04,g_axbb05 WITHOUT DEFAULTS
       FROM axbb01,axbb02,axbb03,axbb04,axbb05

       AFTER FIELD axbb01
          IF NOT cl_null(g_axbb01) THEN
             SELECT COUNT(*) INTO l_cnt FROM axa_file
              WHERE axa01 = g_axbb01
             IF l_cnt <=0  THEN
                CALL cl_err(g_axbb01,'agl-223',0)
                NEXT FIELD axbb01
             END IF
          END IF

      AFTER FIELD axbb02            #上層公司編號
        IF NOT cl_null(g_axbb02) THEN
          #自動帶入帳別
           SELECT axz05 INTO g_axbb03 FROM axz_file WHERE axz01 = g_axbb02
           IF cl_null(g_axbb03) THEN
              CALL cl_err(g_axbb03,'aco-025',0)
              NEXT FIELD axbb02
           END IF
           DISPLAY g_axbb03 TO axbb03
           CALL cl_set_comp_entry("axbb03",FALSE)
           #增加上層公司+帳別的合理性判斷,應存在agli009
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM axa_file
            WHERE axa01=g_axbb01 AND axa02=g_axbb02
           IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
           IF l_cnt = 0  THEN
              CALL cl_err(g_axbb02,'agl-223',0)
              NEXT FIELD axbb02
           END IF
        END IF

      AFTER FIELD axbb04    #下層公司
        IF NOT cl_null(g_axbb04) THEN
          #自動帶入帳別
           SELECT axz05 INTO g_axbb05 FROM axz_file WHERE axz01 = g_axbb04
           IF cl_null(g_axbb05) THEN
              CALL cl_err(g_axbb04,'aco-025',0)
              NEXT FIELD axbb04
           END IF
           DISPLAY g_axbb05 TO axbb05
           CALL cl_set_comp_entry("axbb05",FALSE)
          #檢查輸入的下層公司資料是否與單頭公司相同
           IF g_axbb02 = g_axbb04 AND g_axbb03 = g_axbb05 THEN
              CALL cl_err(g_axbb04,'agl-152',1)
              NEXT FIELD axbb04
           END IF

           LET l_cnt=0
           SELECT COUNT(*) INTO l_cnt FROM axb_file
            WHERE axb01 = g_axbb01 AND axb02 = g_axbb02 AND axb03 = g_axbb03
              AND axb04 = g_axbb04 AND axb05 = g_axbb05
           IF (l_cnt = 0) OR (SQLCA.sqlcode) THEN
              CALL cl_err(g_axbb01,'agl1032',1)
              NEXT FIELD axbb01
           END IF
        END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axbb01) #族群編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               CALL cl_create_qry() RETURNING g_axbb01
               DISPLAY BY NAME g_axbb01
               NEXT FIELD axbb01
            WHEN INFIELD(axbb02) #上層公司
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"
               LET g_qryparam.default1 = g_axbb02
               CALL cl_create_qry() RETURNING g_axbb02
               DISPLAY BY NAME g_axbb02
               NEXT FIELD axbb02
            WHEN INFIELD(axbb04) #下層公司
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"
               LET g_qryparam.default1 = g_axbb04
               CALL cl_create_qry() RETURNING g_axbb04
               DISPLAY BY NAME g_axbb04
               NEXT FIELD axbb04
            OTHERWISE EXIT CASE
          END CASE

        ON ACTION CONTROLG
          CALL cl_cmdask()

        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()

        ON ACTION CONTROLF                  #欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
   END INPUT
END FUNCTION

FUNCTION i0021_q()
   LET g_axbb01 = ''
   LET g_axbb02 = ''
   LET g_axbb03 = ''
   LET g_axbb04 = ''
   LET g_axbb05 = ''
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_axbb01,g_axbb02 TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_axbb.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i0021_cs()                      #取得查詢條件
   IF INT_FLAG THEN                     #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_axbb01,g_axbb02,g_axbb03,g_axbb04,g_axbb05 TO NULL
      RETURN
   END IF
   OPEN i0021_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_axbb01,g_axbb02 TO NULL
   ELSE
      OPEN i0021_count
      FETCH i0021_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i0021_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION

#處理資料的讀取
FUNCTION i0021_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式
   l_abso          LIKE type_file.num10   #絕對的筆數
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i0021_bcs INTO g_axbb01,g_axbb02,g_axbb03,g_axbb04,g_axbb05
       WHEN 'P' FETCH PREVIOUS i0021_bcs INTO g_axbb01,g_axbb02,g_axbb03,g_axbb04,g_axbb05
       WHEN 'F' FETCH FIRST    i0021_bcs INTO g_axbb01,g_axbb02,g_axbb03,g_axbb04,g_axbb05
       WHEN 'L' FETCH LAST     i0021_bcs INTO g_axbb01,g_axbb02,g_axbb03,g_axbb04,g_axbb05
       WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR l_abso
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
            FETCH ABSOLUTE l_abso i0021_bcs INTO g_axbb01,g_axbb02
   END CASE
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_axbb01,SQLCA.sqlcode,0)
      INITIALIZE g_axbb01 TO NULL
      INITIALIZE g_axbb02 TO NULL
      INITIALIZE g_axbb03 TO NULL
      INITIALIZE g_axbb04 TO NULL
      INITIALIZE g_axbb05 TO NULL
   ELSE
      CALL i0021_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
END FUNCTION

#將資料顯示在畫面上
FUNCTION i0021_show()
DEFINE l_cnt           LIKE type_file.num5 
DEFINE l_axbb06        LIKE axbb_file.axbb06 
DEFINE l_axbb07        LIKE axbb_file.axbb07 
DEFINE l_axbb08        LIKE axbb_file.axbb08 
DEFINE l_axbb09        LIKE axbb_file.axbb09 
DEFINE l_axbb10        LIKE axbb_file.axbb10

   SELECT COUNT(*) INTO l_cnt FROM axbb_file
    WHERE axbb01 = g_argv1 AND axbb02 = g_argv2 AND axbb03 = g_argv3
      AND axbb04 = g_argv4 AND axbb05 = g_argv5 
   IF l_cnt = 0 THEN
      SELECT axb07,axb08,axb11,axb12,axb13 
        INTO l_axbb07,l_axbb06,l_axbb08,l_axbb09,l_axbb10
        FROM axb_file
       WHERE axb01 = g_argv1 AND axb02 = g_argv2 AND axb03 = g_argv3
         AND axb04 = g_argv4 AND axb05 = g_argv5 
      IF NOT (cl_null(l_axbb07) AND cl_null(l_axbb06) AND cl_null(l_axbb08) 
          AND cl_null(l_axbb09) AND cl_null(l_axbb10)) THEN
         IF cl_null(l_axbb06) THEN LET l_axbb06 = g_today END IF
         IF cl_null(l_axbb09) THEN LET l_axbb09 = 0 END IF
            INSERT INTO axbb_file(axbb01,axbb02,axbb03,axbb04,axbb05
                                 ,axbb06,axbb07,axbb08,axbb09,axbb10)
            VALUES (g_argv1,g_argv2,g_argv3,g_argv4,g_argv5 
                   ,l_axbb06,l_axbb07,l_axbb08,l_axbb09,l_axbb10)
      END IF
   END IF

   DISPLAY g_axbb01 TO axbb01
   DISPLAY g_axbb02 TO axbb02
   DISPLAY g_axbb03 TO axbb03
   DISPLAY g_axbb04 TO axbb04
   DISPLAY g_axbb05 TO axbb05
   CALL i0021_b_fill(g_wc)                      #單身
   CALL cl_show_fld_cont()
END FUNCTION


#取消整筆 (所有合乎單頭的資料)
FUNCTION i0021_r()
   IF (cl_null(g_axbb01) OR cl_null(g_axbb02) OR cl_null(g_axbb03) 
                         OR cl_null(g_axbb04) OR cl_null(g_axbb05)) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   INITIALIZE g_doc.* TO NULL
   LET g_doc.column1 = "axbb01"
   LET g_doc.column2 = "axbb02"
   LET g_doc.column3 = "axbb03"
   LET g_doc.column4 = "axbb04"
   LET g_doc.column5 = "axbb05"
   LET g_doc.value1 = g_axbb01
   LET g_doc.value2 = g_axbb02
   LET g_doc.value3 = g_axbb03
   LET g_doc.value4 = g_axbb04
   LET g_doc.value5 = g_axbb05
   CALL cl_del_doc()
   DELETE FROM axbb_file WHERE axbb01=g_axbb01 AND axbb02=g_axbb02 AND axbb03=g_axbb03
                           AND axbb04=g_axbb04 AND axbb05=g_axbb05
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","axbb_file",g_axbb01,g_axbb02,SQLCA.sqlcode,"","del axbb",1)
      RETURN      
   END IF   

   INITIALIZE g_axbb01,g_axbb02,g_axbb03,g_axbb04,g_axbb05 TO NULL
   MESSAGE ""
   OPEN i0021_count
   FETCH i0021_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN i0021_bcs
      CALL i0021_fetch('F') 
   ELSE
      DISPLAY g_axbb01 TO axbb01
      DISPLAY g_axbb02 TO axbb02
      DISPLAY g_axbb03 TO axbb03
      DISPLAY g_axbb04 TO axbb04
      DISPLAY g_axbb05 TO axbb05
      DISPLAY 0 TO FORMONLY.cn2
      CALL g_axbb.clear()
      CALL i0021_menu()
   END IF

END FUNCTION

#單身
FUNCTION i0021_b()
DEFINE
   l_ac_t              LIKE type_file.num5,          #未取消的ARRAY CNT
   l_n                 LIKE type_file.num5,          #檢查重複用
   l_lock_sw           LIKE type_file.chr1,          #單身鎖住否
   p_cmd               LIKE type_file.chr1,          #處理狀態
   l_allow_insert      LIKE type_file.num5,          #可新增否
   l_allow_delete      LIKE type_file.num5,          #可刪除否
   l_cnt               LIKE type_file.num10,
   l_sql               STRING 
DEFINE l_axbb          RECORD
         axbb01        LIKE axbb_file.axbb01,
         axbb02        LIKE axbb_file.axbb02,
         axbb03        LIKE axbb_file.axbb03,
         axbb04        LIKE axbb_file.axbb04,
         axbb05        LIKE axbb_file.axbb05
                       END RECORD
DEFINE l_axbb07        LIKE axbb_file.axbb07 
DEFINE l_sum_axbb07    LIKE axbb_file.axbb07 

   LET g_action_choice = ""

   IF cl_null(g_axbb01) OR cl_null(g_axbb02) OR cl_null(g_axbb03) OR cl_null(g_axbb04) OR cl_null(g_axbb05) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF

   IF s_shut(0) THEN RETURN END IF

   CALL cl_opmsg('b')

   CALL s_aaz641_dbs(g_axbb01,g_axbb02) RETURNING g_plant_axz03
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641 

   LET g_forupd_sql = "SELECT axbb07,axbb08,axbb09,axbb10,'',axbb06 FROM axbb_file",
                      " WHERE axbb01 = ? AND axbb02= ? AND axbb03= ? AND axbb04= ? AND axbb05= ? AND axbb06= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)                   
   DECLARE i0021_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   IF g_rec_b=0 THEN CALL g_axbb.clear() END IF

   INPUT ARRAY g_axbb WITHOUT DEFAULTS FROM s_axbb.*

      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'               #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_axbb_t.* = g_axbb[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i0021_bcl USING g_axbb01,g_axbb02,g_axbb03,g_axbb04,g_axbb05,g_axbb[l_ac].axbb06
            IF STATUS THEN
               CALL cl_err("OPEN i0021_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i0021_bcl INTO g_axbb[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i0021_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL i0021_set_axbb10(g_axbb[l_ac].axbb10) RETURNING g_axbb[l_ac].aag02
                  LET g_axbb_t.*=g_axbb[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_axbb[l_ac].* TO NULL
         LET g_axbb_t.* = g_axbb[l_ac].*
         LET g_axbb[l_ac].axbb06=g_today                #預設今天日期
         CALL cl_show_fld_cont()
         NEXT FIELD axbb07

      AFTER FIELD axbb07
         IF NOT cl_null(g_axbb[l_ac].axbb07) THEN
            IF g_axbb[l_ac].axbb07 < 0 OR g_axbb[l_ac].axbb07 > 100 THEN
              CALL cl_err(g_axbb[l_ac].axbb07,'mfg0013',0)
              LET g_axbb[l_ac].axbb07 = g_axbb_t.axbb07
              NEXT FIELD axbb07
            END IF
         END IF         
         
      AFTER FIELD axbb06                         # check data 是否重複
         IF NOT cl_null(g_axbb[l_ac].axbb06) THEN
            IF g_axbb[l_ac].axbb06 != g_axbb_t.axbb06 OR g_axbb_t.axbb06 IS NULL THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM axbb_file
                WHERE axbb01 = g_axbb01 AND axbb02 = g_axbb02 AND axbb03 = g_axbb03
                  AND axbb04 = g_axbb04 AND axbb05 = g_axbb05 AND axbb06 = g_axbb[l_ac].axbb06
               IF (l_cnt > 0) OR (SQLCA.sqlcode) THEN
                  CALL cl_err(g_axbb[l_ac].axbb06,-239,0)
                  NEXT FIELD axbb07
               END IF
               CALL i0021_set_axbb10(g_axbb[l_ac].axbb10) RETURNING g_axbb[l_ac].aag02
               DISPLAY BY NAME g_axbb[l_ac].aag02
            END IF
         ELSE
            LET g_axbb[l_ac].aag02 = null
            DISPLAY BY NAME g_axbb[l_ac].aag02
         END IF

      AFTER FIELD axbb08
         IF NOT cl_null(g_axbb[l_ac].axbb08) THEN
            IF g_axbb[l_ac].axbb08 <= 0 THEN
              CALL cl_err(g_axbb[l_ac].axbb08,'aec-042',0)
              LET g_axbb[l_ac].axbb08 = g_axbb_t.axbb08
              NEXT FIELD axbb08
            END IF
         END IF
 
      AFTER FIELD axbb09
         IF NOT cl_null(g_axbb[l_ac].axbb09) THEN
            IF g_axbb[l_ac].axbb09 <= 0 THEN
              CALL cl_err(g_axbb[l_ac].axbb09,'aec-042',0)
              LET g_axbb[l_ac].axbb09 = g_axbb_t.axbb09
              NEXT FIELD axbb09
            END IF
         END IF

      AFTER FIELD axbb10
         IF NOT cl_null(g_axbb[l_ac].axbb10) THEN
            LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_axz03,'aag_file')
                       ," WHERE aag00 = '",g_aaz641,"'"
                       ,"   AND aag01 = '",g_axbb[l_ac].axbb10,"'"
                       ,"   AND aag07 in ('2','3')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            PREPARE i0021_pre_axbb10_1 FROM l_sql
            DECLARE i0021_cur_axbb10_1 CURSOR FOR i0021_pre_axbb10_1
            OPEN i0021_cur_axbb10_1
            FETCH i0021_cur_axbb10_1 INTO l_n
            IF l_n=0 THEN
               CALL cl_err(g_axbb[l_ac].axbb10,'aap-021',0)
               LET g_axbb[l_ac].axbb10 = g_axbb_t.axbb10
               NEXT FIELD axbb10
            ELSE
               CALL i0021_set_axbb10(g_axbb[l_ac].axbb10) RETURNING g_axbb[l_ac].aag02
               DISPLAY BY NAME g_axbb[l_ac].aag02
            END IF
         END IF

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_axbb[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_axbb[l_ac].* TO s_axbb.*
            CALL g_axbb.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM axb_file
          WHERE axb01 = g_axbb01 AND axb02 = g_axbb02 AND axb03 = g_axbb03
            AND axb04 = g_axbb04 AND axb05 = g_axbb05
         IF (l_cnt = 0) OR (SQLCA.sqlcode) THEN
            CALL cl_err(g_axbb01,'agl1032',0)
            CANCEL INSERT
         END IF
         LET l_axbb07 = 0
         LET l_sum_axbb07 = 0
         DECLARE i0021_cs1 CURSOR FOR
            SELECT DISTINCT axbb01,axbb02,axbb03,axbb04,axbb05 FROM axbb_file
             WHERE axbb04 = g_axbb04 
               AND axbb05 = g_axbb05
               AND axbb01 = g_axbb01
         FOREACH i0021_cs1 INTO l_axbb.axbb01,l_axbb.axbb02,l_axbb.axbb03,l_axbb.axbb04,l_axbb.axbb05
            SELECT axbb07 INTO l_axbb07
              FROM axbb_file
             WHERE axbb01 = l_axbb.axbb01 AND axbb02 = l_axbb.axbb02 AND axbb03 = l_axbb.axbb03
               AND axbb04 = l_axbb.axbb04 AND axbb05 = l_axbb.axbb05
               AND axbb06 = (SELECT MAX(axbb06) FROM axbb_file
                              WHERE axbb01 = l_axbb.axbb01 AND axbb02 = l_axbb.axbb02 AND axbb03 = l_axbb.axbb03
                                AND axbb04 = l_axbb.axbb04 AND axbb05 = l_axbb.axbb05)
               IF NOT ((l_axbb.axbb01 = g_axbb01) AND (l_axbb.axbb02 = g_axbb02) AND (l_axbb.axbb03 = g_axbb03)) THEN
                  LET l_sum_axbb07 = l_sum_axbb07 + l_axbb07
               END IF
         END FOREACH
         LET l_sum_axbb07 = l_sum_axbb07 + g_axbb[l_ac].axbb07
         IF l_sum_axbb07 > 100 THEN
            CALL cl_err(l_sum_axbb07,'agl1031',0)
            CANCEL INSERT
         END IF
         INSERT INTO axbb_file(axbb01,axbb02,axbb03,axbb04,axbb05,axbb07,axbb06,axbb08,axbb09,axbb10)
              VALUES(g_axbb01,g_axbb02,g_axbb03,g_axbb04,g_axbb05,g_axbb[l_ac].axbb07,g_axbb[l_ac].axbb06
                    ,g_axbb[l_ac].axbb08,g_axbb[l_ac].axbb09,g_axbb[l_ac].axbb10)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","axbb_file",g_axbb[l_ac].axbb06,'',SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_axbb_t.axbb06 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM axbb_file WHERE axbb01 = g_axbb01 AND axbb02 = g_axbb02 AND axbb03 = g_axbb03
                                   AND axbb04 = g_axbb04 AND axbb05 = g_axbb05 AND axbb06 = g_axbb_t.axbb06
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","axbb_file",g_axbb[l_ac].axbb06,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_axbb[l_ac].* = g_axbb_t.*
            CLOSE i0021_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_axbb[l_ac].axbb06,-263,1)
            LET g_axbb[l_ac].* = g_axbb_t.*
         ELSE
            LET l_axbb07 = 0
            LET l_sum_axbb07 = 0
            DECLARE i0021_cs2 CURSOR FOR
               SELECT DISTINCT axbb01,axbb02,axbb03,axbb04,axbb05 FROM axbb_file
                WHERE axbb04 = g_axbb04 and axbb05 = g_axbb05
            FOREACH i0021_cs2 INTO l_axbb.axbb01,l_axbb.axbb02,l_axbb.axbb03,l_axbb.axbb04,l_axbb.axbb05
               SELECT axbb07 INTO l_axbb07
                 FROM axbb_file
                WHERE axbb01 = l_axbb.axbb01 AND axbb02 = l_axbb.axbb02 AND axbb03 = l_axbb.axbb03
                  AND axbb04 = l_axbb.axbb04 AND axbb05 = l_axbb.axbb05
                  AND axbb06 = (SELECT MAX(axbb06) FROM axbb_file
                                 WHERE axbb01 = l_axbb.axbb01 AND axbb02 = l_axbb.axbb02 AND axbb03 = l_axbb.axbb03
                                   AND axbb04 = l_axbb.axbb04 AND axbb05 = l_axbb.axbb05)
               IF NOT ((l_axbb.axbb01 = g_axbb01) AND (l_axbb.axbb02 = g_axbb02) AND (l_axbb.axbb03 = g_axbb03)) THEN
                  LET l_sum_axbb07 = l_sum_axbb07 + l_axbb07
               END IF
            END FOREACH
            LET l_sum_axbb07 = l_sum_axbb07 + g_axbb[l_ac].axbb07
            IF l_sum_axbb07 > 100 THEN
               CALL cl_err(l_sum_axbb07,'agl1031',0)
            ELSE
               UPDATE axbb_file SET axbb07 = g_axbb[l_ac].axbb07,axbb06 = g_axbb[l_ac].axbb06,axbb08 = g_axbb[l_ac].axbb08
                                 , axbb09 = g_axbb[l_ac].axbb09,axbb10 = g_axbb[l_ac].axbb10
                             WHERE axbb01 = g_axbb01 AND axbb02 = g_axbb02 AND axbb03 = g_axbb03
                               AND axbb04 = g_axbb04 AND axbb05 = g_axbb05 AND axbb06 = g_axbb_t.axbb06
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","axbb_file",g_axbb[l_ac].axbb06,"",SQLCA.sqlcode,"","",1)
                  LET g_axbb[l_ac].* = g_axbb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_axbb[l_ac].* = g_axbb_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_axbb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i0021_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         CLOSE i0021_bcl
         COMMIT WORK
         CALL g_axbb.deleteElement(g_rec_b+1)

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axbb10)
               CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_axbb[l_ac].axbb10,'23',g_aaz641)
                   RETURNING g_axbb[l_ac].axbb10
               DISPLAY BY NAME g_axbb[l_ac].axbb10 
               NEXT FIELD axbb10
         END CASE

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(axbb02) AND l_ac > 1 THEN
            LET g_axbb[l_ac].* = g_axbb[l_ac-1].*
            LET g_axbb[l_ac].axbb06=null
            NEXT FIELD axbb06
         END IF

      ON ACTION CONTROLZ
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
                                     
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    

   END INPUT

   CLOSE i0021_bcl
   COMMIT WORK
 
END FUNCTION

FUNCTION i0021_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING

   LET g_sql = "SELECT axbb07,axbb08,axbb09,axbb10,'',axbb06",
               "  FROM axbb_file ",
               " WHERE axbb01 = '",g_axbb01,"'",
               "   AND axbb02 = '",g_axbb02,"'",
               "   AND axbb03 = '",g_axbb03,"'",
               "   AND axbb04 = '",g_axbb04,"'",
               "   AND axbb05 = '",g_axbb05,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY axbb06"
   PREPARE i0021_prepare2 FROM g_sql       #預備一下
   DECLARE axbb_cs CURSOR FOR i0021_prepare2

   CALL g_axbb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH axbb_cs INTO g_axbb[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i0021_set_axbb10(g_axbb[g_cnt].axbb10) RETURNING g_axbb[g_cnt].aag02
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_axbb.deleteElement(g_cnt)

   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION i0021_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_axbb TO s_axbb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION first
         CALL i0021_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL i0021_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION jump
         CALL i0021_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION next
         CALL i0021_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION last
         CALL i0021_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
      
      ON ACTION output
         LET g_action_choice="output"
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

      ON ACTION related_document
         LET g_action_choice="related_document"          
         EXIT DISPLAY 

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i0021_set_axbb10(p_axbb10)
DEFINE p_axbb10 LIKE axbb_file.axbb10,
       l_aag02 LIKE aag_file.aag02

   CALL s_aaz641_dbs(g_axbb01,g_axbb02) RETURNING g_plant_axz03
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641

   LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_axz03,'aag_file')
              ," WHERE aag01 = '",p_axbb10,"'"
              ,"   AND aag00 = '",g_aaz641,"'"
              ,"   AND aag07 in ('2','3')"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   PREPARE i0021_pre_axbb10_2 FROM g_sql
   DECLARE i0021_cur_axbb10_2 CURSOR FOR i0021_pre_axbb10_2
   OPEN i0021_cur_axbb10_2
   FETCH i0021_cur_axbb10_2 INTO l_aag02

   IF SQLCA.sqlcode THEN LET l_aag02=null END IF
   RETURN l_aag02
END FUNCTION

