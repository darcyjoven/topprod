# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: p_azwa.4gl
# Descriptions...: 使用者營運中心階層查詢
# Date & Author..: No.FUN-A10092 10/01/15 By tsai_yen
# Modify.........:

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables) #FUN-A10092
DEFINE g_azwa01       LIKE azwa_file.azwa01
DEFINE g_azwa01_t     LIKE azwa_file.azwa01
DEFINE g_azwa         DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
          azwa02      LIKE azwa_file.azwa02,
          azwa03      LIKE azwa_file.azwa03,
          zx02        LIKE zx_file.zx02
                      END RECORD
DEFINE m_zx02         LIKE zx_file.zx02
DEFINE g_wc           STRING
DEFINE g_sql          STRING
DEFINE g_rec_b        LIKE type_file.num5      #單身筆數
DEFINE l_ac           LIKE type_file.num5      #目前處理的ARRAY CNT
DEFINE g_msg          LIKE type_file.chr1000
DEFINE g_row_count    LIKE type_file.num10
DEFINE g_curs_index   LIKE type_file.num10
DEFINE g_jump         LIKE type_file.num10
DEFINE mi_no_ask      LIKE type_file.num5
DEFINE g_idx          LIKE type_file.num5      #g_tree的index，用於tree_fill()的recursive
DEFINE g_tree DYNAMIC ARRAY OF RECORD
          name           STRING,               #節點名稱
          pid            STRING,               #父節點id
          id             STRING,               #節點id
          has_children   BOOLEAN,              #1:有子節點, null:無子節點
          expanded       BOOLEAN,              #0:不展開, 1:展開
          level          LIKE type_file.num5,  #階層
          #各程式key的數量會不同，單身和單頭的key都要記錄
          #若key是數值，要先轉字串，避免數值型態放到Tree有多餘空白
          treekey1       STRING,
          treekey2       STRING,
          treekey3       STRING
                         END RECORD
DEFINE g_argv1         LIKE zx_file.zx01         #使用者編號

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5

   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,                     #輸入的方式: 不打轉
       FIELD ORDER FORM
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   LET g_argv1 = ARG_VAL(1)               #使用者編號

   CALL cl_used(g_prog,g_time,1) RETURNING g_time


   LET g_azwa01_t = NULL
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW p_azwa_w AT p_row,p_col WITH FORM "azz/42f/p_azwa"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   
   IF NOT cl_null(g_argv1) THEN
      CALL p_azwa_q(g_argv1)
   ELSE
      CALL p_azwa_q(g_user)
   END IF
   
   CALL p_azwa_menu()
   CLOSE FORM p_azwa_w                   #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION p_azwa_cs(p_azwa)
   DEFINE p_azwa   LIKE azwa_file.azwa01
      
   CLEAR FORM                             #清除畫面
   CALL g_azwa.clear()

   INITIALIZE g_azwa01 TO NULL
   
   LET g_wc = NULL
   IF NOT cl_null(p_azwa) THEN    #預設查詢條件
      LET g_wc = "azwa01='",p_azwa CLIPPED,"'"
   END IF
   
   IF cl_null(g_wc) THEN
      CONSTRUCT g_wc ON azwa01 FROM azwa01  #螢幕上取條件
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(azwa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_zx"
                  LET g_qryparam.state ="c"
                  LET g_qryparam.default1 = g_azwa01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO azwa01
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
   END IF

   IF INT_FLAG THEN RETURN END IF
   LET g_sql= "SELECT DISTINCT azwa01 FROM azwa_file",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY azwa01"
   PREPARE p_azwa_prepare FROM g_sql        #預備一下
   DECLARE p_azwa_bcs                       #宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_azwa_prepare

   LET g_sql="SELECT COUNT(DISTINCT azwa01)",
             " FROM azwa_file WHERE ", g_wc CLIPPED
   PREPARE p_azwa_precount FROM g_sql
   DECLARE p_azwa_count CURSOR FOR p_azwa_precount
END FUNCTION


FUNCTION p_azwa_menu()
   DEFINE l_tree_arr_curr    LIKE type_file.num5

   WHILE TRUE
      LET g_action_choice = " "

      CALL cl_set_act_visible("accept,cancel", FALSE)

      #TREE
      #讓各個交談指令可以互動
      DIALOG ATTRIBUTES(UNBUFFERED)
         #TREE
         DISPLAY ARRAY g_tree TO tree.*
            BEFORE DISPLAY
               CALL cl_navigator_setting( g_curs_index, g_row_count )
               
            BEFORE ROW #可用來設定"選取"時的動作.
               LET l_tree_arr_curr = ARR_CURR()
         END DISPLAY #TREE end

         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG

         ON ACTION first
            CALL p_azwa_fetch('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
            END IF
            ACCEPT DIALOG

         ON ACTION previous
            CALL p_azwa_fetch('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
                ACCEPT DIALOG

         ON ACTION jump
            CALL p_azwa_fetch('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
                ACCEPT DIALOG

         ON ACTION next
            CALL p_azwa_fetch('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
                ACCEPT DIALOG

         ON ACTION last
            CALL p_azwa_fetch('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
              IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
              END IF
              ACCEPT DIALOG

         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()

         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION close                #視窗右上角的"x"
            LET INT_FLAG=FALSE
            LET g_action_choice="exit"
            EXIT DIALOG

         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG

         ON ACTION accept
            LET g_action_choice="detail"
            LET l_ac = ARR_CURR()
            EXIT DIALOG

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG

         ON ACTION about
            CALL cl_about()
      END DIALOG
      CALL cl_set_act_visible("accept,cancel", TRUE)


      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_azwa_q(NULL)
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
FUNCTION p_azwa_q(p_azwa)
   DEFINE p_azwa   LIKE azwa_file.azwa01
   
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_azwa01 TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tree.clear()
   CALL g_azwa.clear()
   CALL p_azwa_cs(p_azwa)                #取得查詢條件
   IF INT_FLAG THEN                      #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_azwa_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                 #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_azwa01 TO NULL
   ELSE
       OPEN p_azwa_count
       FETCH p_azwa_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL p_azwa_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION

#處理資料的讀取
FUNCTION p_azwa_fetch(p_flag)
    DEFINE p_flag    LIKE type_file.chr1     #處理方式

    MESSAGE ""

    CASE p_flag
        WHEN 'N' FETCH NEXT     p_azwa_bcs INTO g_azwa01
        WHEN 'P' FETCH PREVIOUS p_azwa_bcs INTO g_azwa01
        WHEN 'F' FETCH FIRST    p_azwa_bcs INTO g_azwa01
        WHEN 'L' FETCH LAST     p_azwa_bcs INTO g_azwa01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump p_azwa_bcs INTO g_azwa01
            LET mi_no_ask = FALSE
    END CASE

    SELECT DISTINCT azwa01 FROM azwa_file WHERE azwa01 = g_azwa01
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err3("sel","azwa_file",g_azwa01,"",SQLCA.sqlcode,"","",1)
        INITIALIZE g_azwa01 TO NULL 
    ELSE
        CALL p_azwa_show()
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE

        CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION


#將資料顯示在畫面上
FUNCTION p_azwa_show()
   DISPLAY g_azwa01 TO azwa01           #單頭
   SELECT zx02 INTO m_zx02 FROM zx_file WHERE zx01=g_azwa01
   IF STATUS=100 THEN LET m_zx02='' END IF
   DISPLAY m_zx02 TO FORMONLY.zx02
   CALL p_azwa_tree_fill(NULL,0,NULL)   #Tree填充

   CALL cl_show_fld_cont()
END FUNCTION


##################################################
# Descriptions...: Tree填充
# Date & Author..: 10/01/15 By tsai_yen
# Input Parameter: p_pid,p_level,p_key3
# Return code....:
##################################################
FUNCTION p_azwa_tree_fill(p_pid,p_level,p_key3)
   DEFINE p_pid              STRING                #父節點id
   DEFINE p_level            LIKE type_file.num5   #階層
   DEFINE p_key3             STRING
   DEFINE l_azwa             DYNAMIC ARRAY OF RECORD
             azwa02          LIKE azwa_file.azwa02,
             azwa03          LIKE azwa_file.azwa03,
             child_cnt       LIKE type_file.num5,  #子節點數
             azw08           LIKE azw_file.azw08
                             END RECORD
   DEFINE l_str              STRING
   DEFINE max_level          LIKE type_file.num5   #最大階層數,可避免無窮迴圈.
   DEFINE l_i                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5

   LET max_level = 20 #設定最大階層數

   IF p_level = 0 THEN
      CALL g_tree.clear()
      #設虛擬根節點
      LET g_idx = 1
      LET p_level = 1
      LET g_tree[g_idx].expanded = 1          #0:不展開, 1:展開
      LET g_tree[g_idx].name = "Plant List"
      LET g_tree[g_idx].id = "1"
      LET g_tree[g_idx].pid = NULL
      LET g_tree[g_idx].has_children = TRUE
      LET g_tree[g_idx].level = p_level
      LET g_tree[g_idx].treekey1 = NULL
      LET g_tree[g_idx].treekey2 = NULL
      LET g_tree[g_idx].treekey3 = NULL

      LET p_level = p_level + 1   #下一階層

      #找最上層的節點,和QBE查詢結果不同,只顯示此user的
      LET g_sql = "SELECT azwa_file.azwa02,azwa_file.azwa02 as azwa03,azwa_file.child_cnt,azw_file.azw08",
                  " FROM (",
                     " SELECT azwa02,COUNT(azwa02)-1 as child_cnt",
                        " FROM azwa_file",
                        " WHERE azwa01='",g_azwa01 CLIPPED,"'",
                          " AND azwa02 NOT IN (",
                                " SELECT azwa03",
                                   " FROM azwa_file",
                                   " WHERE azwa01='",g_azwa01 CLIPPED,"'",
                                   " AND azwa02 <> azwa03",
                               " )",
                     " GROUP BY azwa02",
                  " ) azwa_file",
                  " LEFT JOIN (",
                     " SELECT azw01,azw08",
                        " FROM azw_file",
                  " ) azw_file",
                  " ON azwa_file.azwa02 = azw_file.azw01",
                  " ORDER BY azwa_file.azwa02"
      PREPARE p_azwa_tree_pre1 FROM g_sql
      DECLARE p_azwa_tree_cs1 CURSOR FOR p_azwa_tree_pre1

      LET l_i = 1
      CALL l_azwa.clear()
      FOREACH p_azwa_tree_cs1 INTO l_azwa[l_i].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF

         LET g_idx = g_idx + 1
         LET g_tree[g_idx].pid = "1"
         LET l_str = l_i  #數值轉字串
         LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
         LET g_tree[g_idx].expanded = 1    #0:不展開, 1:展開

         LET g_tree[g_idx].name = l_azwa[l_i].azwa03,"(",l_azwa[l_i].azw08,")"
         LET g_tree[g_idx].level = p_level
         LET g_tree[g_idx].treekey1 = g_azwa01
         LET g_tree[g_idx].treekey2 = l_azwa[l_i].azwa02
         LET g_tree[g_idx].treekey3 = l_azwa[l_i].azwa03
         #有子節點
         IF l_azwa[l_i].child_cnt > 0 THEN
            LET g_tree[g_idx].has_children = TRUE
            CALL p_azwa_tree_fill(g_tree[g_idx].id,p_level,g_tree[g_idx].treekey3)
         ELSE
            LET g_tree[g_idx].has_children = FALSE
         END IF
         LET l_i = l_i + 1
      END FOREACH
   ELSE
      LET p_level = p_level + 1   #下一階層
      IF p_level > max_level THEN
         CALL cl_err_msg("","azz1001",max_level,0)
         RETURN
      END IF

      LET g_sql = "SELECT '",p_key3 CLIPPED,"',azwa_file.azwa02 as azwa03,azwa_file.child_cnt,azw_file.azw08",
                  " FROM (",
                     " SELECT azwa02,COUNT(azwa02)-1 as child_cnt",
                        " FROM azwa_file",
                        " WHERE azwa01='",g_azwa01 CLIPPED,"'",
                          " AND azwa02 IN (",
                                " SELECT azwa03",
                                   " FROM azwa_file",
                                   " WHERE azwa01='",g_azwa01 CLIPPED,"'",
                                   " AND azwa02 = '",p_key3 CLIPPED,"' AND azwa03 <> '",p_key3 CLIPPED,"'",
                               " )",
                     " GROUP BY azwa02",
                  " ) azwa_file",
                  " LEFT JOIN (",
                     " SELECT azw01,azw08",
                        " FROM azw_file",
                  " ) azw_file",
                  " ON azwa_file.azwa02 = azw_file.azw01",
                  " ORDER BY azwa_file.azwa02"
      PREPARE p_azwa_tree_pre2 FROM g_sql
      DECLARE p_azwa_tree_cs2 CURSOR FOR p_azwa_tree_pre2

      #在FOREACH中直接使用遞迴,資料會錯亂,所以先將資料放到陣列後,在FOR迴圈處理
      LET l_cnt = 1
      CALL l_azwa.clear()
      FOREACH p_azwa_tree_cs2 INTO l_azwa[l_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      CALL l_azwa.deleteelement(l_cnt)  #刪除FOREACH最後新增的空白列
      LET l_cnt = l_cnt - 1

      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid CLIPPED
            LET l_str = l_i  #數值轉字串
            LET g_tree[g_idx].id = g_tree[g_idx].pid,".",l_str
            LET g_tree[g_idx].expanded = 1    #0:不展開, 1:展開
            LET g_tree[g_idx].name = l_azwa[l_i].azwa03,"(",l_azwa[l_i].azw08,")"
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].treekey1 = g_azwa01
            LET g_tree[g_idx].treekey2 = l_azwa[l_i].azwa02
            LET g_tree[g_idx].treekey3 = l_azwa[l_i].azwa03
            #有子節點
            IF l_azwa[l_i].child_cnt > 0 THEN
               LET g_tree[g_idx].has_children = TRUE
               CALL p_azwa_tree_fill(g_tree[g_idx].id,p_level,g_tree[g_idx].treekey3)
            ELSE
               LET g_tree[g_idx].has_children = FALSE
            END IF
          END FOR
      END IF
   END IF
END FUNCTION 
