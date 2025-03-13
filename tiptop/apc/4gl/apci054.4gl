# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: apci054.4gl
# Descriptions...: POS触屏設定作業
# Date & Author..: #No.FUN-D20020 13/02/05 By xumm 
# Modify.........: #No:FUN-D20081 13/02/25 By xumm 調整圖片的顯示方式
# Modify.........: #No:FUN-D30006 13/03/04 By xumm 產品根據參數設置抓取不同資料
# Modify.........: #No:FUN-D30075 13/03/22 By xumm 事務邏輯調整
# Modify.........: #No:FUN-D30093 13/03/26 By dongsz 1.添加分類來源rzi09欄位及相關邏輯 2.添加有效/無效的相關邏輯
# Modify.........: #No:FUN-D40015 13/04/02 By xumm 更改大類時，序號問題調整
# Modify.........: #No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

GLOBALS
   DEFINE g_main_array      DYNAMIC ARRAY OF RECORD   # 大分類
          main_id           LIKE type_file.chr10,     # 大分類編號
          main_name         LIKE type_file.chr30      # 大分類名稱
                            END RECORD
   DEFINE g_item_array      DYNAMIC ARRAY OF RECORD   # 小分類
          item_main_id      LIKE type_file.chr10,     # 大分類編號
          item_id           LIKE type_file.chr10,     # 小分類編號
          item_name         LIKE type_file.chr30      # 小分類名稱
                            END RECORD
   DEFINE g_product_array   DYNAMIC ARRAY OF RECORD   # 商品細項
          product_main_id   LIKE type_file.chr10,     # 大分類編號
          product_item_id   LIKE type_file.chr10,     # 小分類編號
          product_id        LIKE type_file.chr30,     # 商品編號
          product_name      LIKE type_file.chr30,     # 商品名稱
          product_price     LIKE type_file.num5,      # 商品價格
          product_unit      LIKE type_file.chr10,     # 商品单位
          product_picture   LIKE type_file.chr300     # 商品圖片
                            END RECORD
   DEFINE g_main_form_but   DYNAMIC ARRAY OF RECORD   # 大分類
          main_but_name     STRING,                   # 元件名稱(name)
          main_id           LIKE type_file.chr10      # 大分類編號
                            END RECORD
   DEFINE g_item_form_but   DYNAMIC ARRAY OF RECORD   # 小分類
          item_but_name     STRING,                   # 元件名稱(name)
          item_main_id      LIKE type_file.chr10,     # 大分類編號
          item_id           LIKE type_file.chr10      # 小分類編號
                            END RECORD
   DEFINE g_product_form_but    DYNAMIC ARRAY OF RECORD   # 商品細項
          product_but_name  STRING,                   # 元件名稱(name)
          product_main_id   LIKE type_file.chr10,     # 大分類編號
          product_item_id   LIKE type_file.chr10,     # 小分類編號
          product_id        LIKE type_file.chr10      # 商品編號
                            END RECORD
   DEFINE g_main_col        LIKE type_file.num5       # 使用者輸入的大分類行數
   DEFINE g_main_row        LIKE type_file.num5       # 使用者輸入的大分類列數
   DEFINE g_item_col        LIKE type_file.num5       # 使用者輸入的小分類行數
   DEFINE g_item_row        LIKE type_file.num5       # 使用者輸入的小分類列數
   DEFINE g_product_col     LIKE type_file.num5       # 使用者輸入的商品細項行數
   DEFINE g_product_row     LIKE type_file.num5       # 使用者輸入的商品細項列數
   DEFINE g_main_page       LIKE type_file.num5       # 目前在大分類第幾頁
   DEFINE g_item_page       LIKE type_file.num5       # 目前在小分類第幾頁
   DEFINE g_product_page    LIKE type_file.num5       # 目前在商品細項第幾頁
   DEFINE g_curr_act        STRING                    # 紀錄目前游標所指的action
   DEFINE g_curr_act_old    STRING                    # 紀錄目前游標所指的action - 舊
   DEFINE g_act_max         LIKE type_file.num5       # 最多預設幾個按鈕
   DEFINE g_act_hidden      STRING                    # 紀錄要隱藏起來的action
   DEFINE g_ima01           DYNAMIC ARRAY OF STRING
   DEFINE g_ima04           DYNAMIC ARRAY OF STRING
   DEFINE g_main_curr_page           LIKE type_file.num5    # 大分類目前的頁數
   DEFINE g_main_page_count          LIKE type_file.num5    # 大分類每頁可放置的元件個數 (行 * 列)
   DEFINE g_main_start_index         LIKE type_file.num5    # 大分類每頁的array起始位置
   DEFINE g_main_end_index           LIKE type_file.num5    # 大分類每頁的array結束位置 
   DEFINE g_main_array_langth        LIKE type_file.num5    # 大分類的array長度
   DEFINE g_item_curr_page           LIKE type_file.num5    # 小分類目前的頁數
   DEFINE g_item_page_count          LIKE type_file.num5    # 小分類每頁可放置的元件個數 (行 * 列)
   DEFINE g_item_start_index         LIKE type_file.num5    # 小分類每頁的array起始位置
   DEFINE g_item_end_index           LIKE type_file.num5    # 小分類每頁的array結束位置 
   DEFINE g_item_array_langth        LIKE type_file.num5    # 小分類的array長度
   DEFINE g_product_curr_page        LIKE type_file.num5    # 商品細項目前的頁數
   DEFINE g_product_page_count       LIKE type_file.num5    # 商品細項每頁可放置的元件個數 (行 * 列)
   DEFINE g_product_start_index      LIKE type_file.num5    # 商品細項每頁的起始位置
   DEFINE g_product_end_index        LIKE type_file.num5    # 商品細項每頁的結束位置 
   DEFINE g_product_array_langth     LIKE type_file.num5    # 商品細項的array長度
   DEFINE g_rzi                      RECORD LIKE rzi_file.* 
   DEFINE g_rzi_t                    RECORD LIKE rzi_file.*
   DEFINE g_before_input_done        LIKE type_file.num5
   DEFINE g_row_count                LIKE type_file.num10
   DEFINE g_curs_index               LIKE type_file.num10
   DEFINE g_wc                       STRING
   DEFINE g_sql                      STRING
   DEFINE g_forupd_sql               STRING
   DEFINE g_rec_b1                   LIKE type_file.num5
   DEFINE g_rec_b2                   LIKE type_file.num5
   DEFINE g_rec_b3                   LIKE type_file.num5
   DEFINE g_msg                      LIKE type_file.chr1000
   DEFINE g_cnt                      LIKE type_file.num5
   DEFINE g_jump                     LIKE type_file.num10
   DEFINE g_no_ask                   LIKE type_file.num5
   DEFINE g_flag                     LIKE type_file.chr1    #鼠标位置标识符 0:单头 1:大类 2:小类 3:产品
   DEFINE g_flag1                    LIKE type_file.chr1    #区分是单身/单头的操作
   DEFINE g_button1                  LIKE type_file.num5    #大类的第几笔资料
   DEFINE g_button2                  LIKE type_file.num5    #小类的第几笔资料
   DEFINE g_button3                  LIKE type_file.num5    #产品的第几笔资料
   DEFINE g_but1                     STRING                 #大类的ACTION
   DEFINE g_but2                     STRING                 #小类的ACTION
   DEFINE g_but3                     STRING                 #产品的ACTION
   DEFINE g_rzipos                   LIKE rzi_file.rzipos   #POS否标识符
   DEFINE g_rec_b                    LIKE type_file.num5    #生效门店笔数
   DEFINE l_ac                       LIKE type_file.num5
   DEFINE g_rzl                      DYNAMIC ARRAY OF RECORD
          rzl02                      LIKE rzl_file.rzl02,
          rtz13                      LIKE rtz_file.rtz13,
          rzlacti                    LIKE rzl_file.rzlacti
                                     END RECORD
   DEFINE g_rzl_t                    RECORD
          rzl02                      LIKE rzl_file.rzl02,
          rtz13                      LIKE rtz_file.rtz13,
          rzlacti                    LIKE rzl_file.rzlacti
                                     END RECORD
   DEFINE g_oba01_tree               STRING #FUN-D30006 Add
   DEFINE g_chr                      LIKE type_file.chr1    #FUN-D30093 add
END GLOBALS

MAIN
   DEFINE g_time        VARCHAR(8)                #計算被使用時間
   DEFINE p_row,p_col   SMALLINT
   DEFINE ls_str        STRING
   DEFINE ls_num        LIKE type_file.num5
 
   OPTIONS                                       #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                               #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)                 #計算使用時間 (進入時間) 
      RETURNING g_time

   
   LET g_forupd_sql = "SELECT * FROM rzi_file WHERE rzi01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i054_cl CURSOR FROM g_forupd_sql     
   
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW i054_w AT p_row,p_col
     WITH FORM "apc/42f/apci054" ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()

   CALL cl_set_comp_visible("rzipos",g_aza.aza88 = 'Y')
   # 預設點選大分類的第一筆資料，
   # 因為大分類的第一個元件是上一頁，所以改帶第二個元件
   LET g_curr_act = "main_but002"
   LET g_curr_act_old = "main_but002"
   LET g_but1 = "main_but002"
   LET g_but2 = "item_but001"
   LET g_but3 = "product_but001"

   LET g_flag = '0'
   LET g_flag1 = '0'
   LET g_button1 = 1
   LET g_button2 = 1
   LET g_button3 = 1
   # 定義最多只能設定100個按鈕
   LET g_act_max = 100
   CALL i054_b_clear()
   CALL i054_menu()
 
   CLOSE WINDOW i054_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出時間) 
      RETURNING g_time
END MAIN

FUNCTION i054_menu()
   DEFINE lc_c           LIKE type_file.num5
   DEFINE lc_k           LIKE type_file.num5
   DEFINE lc_act_hidden  STRING                   #隱藏的按鈕,以","分隔
   DEFINE lc_act         STRING
   DEFINE lc_n           LIKE type_file.num5
   DEFINE lc_start       LIKE type_file.num5

   MENU ""
      BEFORE MENU
         CALL cl_set_act_visible("true", FALSE)
         #隱藏沒有使用到的Button
         CALL cl_str_sepcnt(g_act_hidden,",") RETURNING lc_k
         IF lc_k > 0 THEN
            FOR lc_c = 1 TO lc_k
               CALL cl_str_sepsub(g_act_hidden,",",lc_c,lc_c) RETURNING lc_act
               CALL DIALOG.setActionHidden(lc_act, 1)
            END FOR
         END IF

      ON ACTION query                          #"Q.查询"
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL cl_set_act_visible("true", FALSE)
            CALL i054_q()
         END IF
         
      ON ACTION insert                         #"A.輸入"
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            IF g_flag1 = '0' THEN
               CALL i054_a()
            ELSE
               CALL i054_ab(g_flag)            #单身录入
            END IF
         END IF

      ON ACTION modify                         #"U.更改"
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            IF g_flag1 = '0' THEN
               CALL i054_u()
            ELSE
               CALL i054_ub(g_flag)            #单身更改
            END IF
         END IF

      ON ACTION delete                         #"R.删除"
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            IF g_flag1 = '0' THEN
               CALL i054_r()
            ELSE
               CALL i054_rb(g_flag)            #单身删除
            END IF
         END IF

      ON ACTION reproduce                      #"C.复制"
         LET g_action_choice="reproduce"
         IF cl_chk_act_auth() THEN
            CALL i054_copy()
         END IF

      ON ACTION detail                         #"B.单身"
         LET g_action_choice="detail"
         IF cl_chk_act_auth() THEN
            CALL i054_b()
         END IF

      ON ACTION exit                           #"Esc.結束"
         IF g_flag1 = '1' THEN       #FUN-D30075 Add
            CALL i054_work()         #FUN-D30075 Add
         END IF                      #FUN-D30075 Add
         LET g_action_choice="exit"
         EXIT MENU

      ON ACTION effect                         #生效门店
         LET g_action_choice="effect"
         IF cl_chk_act_auth() THEN
            CALL i054_eff()
         END IF

     #FUN-D30093--add--str---
      ON ACTION invalid                        #有效/無效
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL i054_x()
            CALL i054_show()
         END IF
     #FUN-D30093--add--end---

      ON ACTION next
         CALL i054_fetch('N')

      ON ACTION previous
         CALL i054_fetch('P')

      ON ACTION jump
         CALL i054_fetch('/')

      ON ACTION first
         CALL i054_fetch('F')

      ON ACTION last
         CALL i054_fetch('L')

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION close
         IF g_flag1 = '1' THEN       #FUN-D30075 Add
            CALL i054_work()         #FUN-D30075 Add
         END IF                      #FUN-D30075 Add
         LET INT_FLAG=FALSE
         LET g_action_choice = "exit"
         EXIT MENU

      ON ACTION TRUE
         LET g_flag1 = '0'
        #FUN-D30075-----Mark------Str
        #IF g_aza.aza88 = 'Y' THEN
        #   LET g_rzi.rzipos = g_rzipos
        #   UPDATE rzi_file SET rzipos = g_rzipos
        #    WHERE rzi01 = g_rzi.rzi01
        #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        #      CALL cl_err3("upd","rzi_file",g_rzi.rzi01,"",SQLCA.sqlcode,"","",1)
        #   END IF
        #   DISPLAY BY NAME g_rzi.rzipos
        #END IF
        #FUN-D30075-----Mark------End
         CALL i054_work()         #FUN-D30075 Add
         CALL cl_set_act_visible("query,reproduce,detail", TRUE)
         CALL cl_set_act_visible("true", FALSE)
         CALL cl_set_act_visible("next,previous,jump,first,last", TRUE)
         CALL cl_set_act_visible("effect", TRUE)   #FUN-D30075 Add 
         CALL i054_change_style("R")

      # 加入預設的ON ACTION
      &include "apci054_main_act.4gl"
      &include "apci054_item_act.4gl"
      &include "apci054_product_act.4gl"

   END MENU
END FUNCTION


FUNCTION i054_cs()

   CLEAR FORM
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_rzi.* TO NULL
      CONSTRUCT BY NAME g_wc ON  rzi01,rzi02,rzipos,rzi03,rzi04,rzi05,rzi06,
                                 rzi07,rzi08,rzi09,rziuser,rzigrup,rzioriu,rzicrat,   #FUN-D30093 add rzi09
                                 rzimodu,rziorig,rziacti,rzidate

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp
         CASE WHEN INFIELD(rzi01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_rzi01"
                   LET g_qryparam.default1 = g_rzi.rzi01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO rzi01
                   NEXT FIELD rzi01
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
   IF INT_FLAG THEN
      RETURN
   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rziuser', 'rzigrup')
   IF cl_null(g_wc) THEN
      LET g_wc = " 1=1"
   END IF
   LET g_sql = " SELECT rzi01 FROM rzi_file ",
               "  WHERE ",g_wc CLIPPED,
               "  ORDER BY rzi01"
   PREPARE i054_prepare FROM g_sql
   DECLARE i054_cs SCROLL CURSOR WITH HOLD FOR i054_prepare

   LET g_sql = "SELECT COUNT(*) FROM rzi_file ",
               "  WHERE ",g_wc CLIPPED
   PREPARE i054_precount FROM g_sql
   DECLARE i054_count CURSOR FOR i054_precount
END FUNCTION


# 查询
FUNCTION i054_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_rzi.* TO NULL
   CALL i054_b_clear()
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY ' ' TO FORMONLY.cnt
   CALL i054_cs()
   IF INT_FLAG OR g_action_choice="exit" THEN
      LET INT_FLAG = 0
      CLEAR FORM
      LET g_rec_b1=0
      LET g_rec_b2=0
      LET g_rec_b3=0
      INITIALIZE g_rzi.* TO NULL
      RETURN
   END IF

   OPEN i054_cs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_rzi.* TO NULL
   ELSE
      OPEN i054_count
      FETCH i054_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i054_fetch('F')
   END IF
END FUNCTION

FUNCTION i054_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,
            l_abso   LIKE type_file.num10

   CASE p_flag
      WHEN 'N' FETCH NEXT     i054_cs INTO g_rzi.rzi01
      WHEN 'P' FETCH PREVIOUS i054_cs INTO g_rzi.rzi01
      WHEN 'F' FETCH FIRST    i054_cs INTO g_rzi.rzi01
      WHEN 'L' FETCH LAST     i054_cs INTO g_rzi.rzi01
      WHEN '/'
         IF (NOT g_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION about
                   CALL cl_about()

                ON ACTION HELP
                   CALL cl_show_help()

                ON ACTION controlg
                   CALL cl_cmdask()

             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         FETCH ABSOLUTE g_jump i054_cs INTO g_rzi.rzi01
         LET g_no_ask = FALSE
   END CASE

   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_rzi.rzi01,SQLCA.SQLCODE,0)
      INITIALIZE g_rzi.* TO NULL
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
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
   SELECT * INTO g_rzi.* FROM rzi_file WHERE  rzi01 = g_rzi.rzi01
   IF SQLCA.SQLCODE THEN
      INITIALIZE g_rzi.* TO NULL
      CALL cl_err3("sel","rzi_file",g_rzi.rzi01,"",SQLCA.SQLCODE,"","",1)
      RETURN
   END IF

   CALL i054_show()
END FUNCTION

FUNCTION i054_show()
   DISPLAY BY NAME g_rzi.rzi01,g_rzi.rzi02,g_rzi.rzi03,g_rzi.rzi04,
                   g_rzi.rzi05,g_rzi.rzi06,g_rzi.rzi07,g_rzi.rzi08,g_rzi.rzi09,    #FUN-D30093 add g_rzi.rzi09
                   g_rzi.rzipos,g_rzi.rziuser,g_rzi.rzigrup,
                   g_rzi.rzioriu,g_rzi.rzimodu,g_rzi.rzidate,
                   g_rzi.rziorig,g_rzi.rziacti,g_rzi.rzicrat

   LET g_main_curr_page = 1
   LET g_item_curr_page = 1
   LET g_product_curr_page = 1
   LET g_main_start_index = 1
   LET g_item_start_index = 1
   LET g_product_start_index = 1
   #动态显示画面ACTTION数量
   LET g_main_col = g_rzi.rzi04
   LET g_main_row = g_rzi.rzi03
   LET g_item_col = g_rzi.rzi06
   LET g_item_row = g_rzi.rzi05
   LET g_product_col = g_rzi.rzi08
   LET g_product_row = g_rzi.rzi07 
   LET g_main_page_count = g_rzi.rzi03 * g_rzi.rzi04
   LET g_item_page_count = g_rzi.rzi05 * g_rzi.rzi06
   LET g_product_page_count = g_rzi.rzi07 * g_rzi.rzi08 +2
   CALL i054_get_data("M","","")
   CALL i054_display_row() 
   CALL i054_form("main","main_group",1,g_main_page_count-2)
   CALL i054_form("item","item_group",1,g_item_page_count-2)
   CALL i054_form("product","product_group",1,g_product_page_count-2)
   CALL cl_show_fld_cont()
   
   CALL cl_set_field_pic1("","","","","",g_rzi.rziacti,"","")    #FUN-D30093 add
END FUNCTION


# 新增
FUNCTION i054_a()

   CLEAR FORM
   INITIALIZE g_rzi.* TO NULL
   INITIALIZE g_rzi_t.* TO NULL 
   CALL i054_b_clear()        
   CALL cl_opmsg('a')
   WHILE TRUE
      SELECT rzc05 INTO g_rzi.rzi04 FROM rzc_file WHERE rzc01 = 'BClass_Line'
      SELECT rzc05 INTO g_rzi.rzi03 FROM rzc_file WHERE rzc01 = 'BClass_Row'
      SELECT rzc05 INTO g_rzi.rzi06 FROM rzc_file WHERE rzc01 = 'SClass_Line'
      SELECT rzc05 INTO g_rzi.rzi05 FROM rzc_file WHERE rzc01 = 'SClass_Row'
      SELECT rzc05 INTO g_rzi.rzi08 FROM rzc_file WHERE rzc01 = 'Goods_Line'
      SELECT rzc05 INTO g_rzi.rzi07 FROM rzc_file WHERE rzc01 = 'Goods_Row'
      SELECT rcj13 INTO g_rzi.rzi09 FROM rcj_file    #FUN-D30093 add
      LET g_rzi.rzipos = '1'
      LET g_rzi.rziuser = g_user
      LET g_rzi.rzigrup = g_grup
      LET g_rzi.rzidate = g_today
      LET g_rzi.rziacti = 'Y'
      LET g_rzi.rzicrat = g_today
      LET g_rzi.rzioriu = g_user
      LET g_rzi.rziorig = g_grup
      CALL i054_i("a")
      IF INT_FLAG THEN
         INITIALIZE g_rzi.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
      IF g_rzi.rzi01 IS NULL THEN
         CONTINUE WHILE
      END IF
      BEGIN WORK
      INSERT INTO rzi_file VALUES(g_rzi.*)
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("ins","rzi_file",g_rzi.rzi01,"",SQLCA.SQLCODE,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
      # 依據各分類的資料動態顯示在畫面上
      CALL i054_form("main","main_group",1,g_main_page_count-2)
      CALL i054_form("item","item_group",1,g_item_page_count-2)
      CALL i054_form("product","product_group",1,g_product_page_count-2)
      EXIT WHILE
   END WHILE 
END FUNCTION

FUNCTION i054_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,
          l_n          LIKE type_file.num5,
          l_cmd        STRING,
          li_result    LIKE type_file.num5


   DISPLAY BY NAME g_rzi.rzi01,g_rzi.rzi02,g_rzi.rzi03,g_rzi.rzi04,
                   g_rzi.rzi05,g_rzi.rzi06,g_rzi.rzi07,g_rzi.rzi08,g_rzi.rzi09,  #FUN-D30093 add g_rzi.rzi09
                   g_rzi.rzipos,g_rzi.rziuser,g_rzi.rzigrup,
                   g_rzi.rzioriu,g_rzi.rzimodu,g_rzi.rzidate,
                   g_rzi.rziorig,g_rzi.rziacti,g_rzi.rzicrat
   INPUT BY NAME   g_rzi.rzi01,g_rzi.rzi02,g_rzi.rzi03,g_rzi.rzi04,
                   g_rzi.rzi05,g_rzi.rzi06,g_rzi.rzi07,g_rzi.rzi08,g_rzi.rzi09,  #FUN-D30093 add g_rzi.rzi09
                   g_rzi.rzipos,g_rzi.rziuser,g_rzi.rzigrup,
                   g_rzi.rzioriu,g_rzi.rzimodu,g_rzi.rzidate,
                   g_rzi.rziorig,g_rzi.rziacti,g_rzi.rzicrat
      WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i054_set_entry(p_cmd)
         CALL i054_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD rzi01
         IF NOT cl_null(g_rzi.rzi01) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rzi_t.rzi01 <> g_rzi.rzi01) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n 
                 FROM rzi_file 
                WHERE rzi01 = g_rzi.rzi01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_rzi.rzi01 = g_rzi_t.rzi01
                  DISPLAY BY NAME g_rzi.rzi01
                  NEXT FIELD rzi01
               END IF
            END IF
         END IF

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

      ON ACTION HELP
         CALL cl_show_help()

      AFTER INPUT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            EXIT INPUT
         END IF
         LET g_main_col = g_rzi.rzi04
         LET g_main_row = g_rzi.rzi03
         LET g_item_col = g_rzi.rzi06
         LET g_item_row = g_rzi.rzi05
         LET g_product_col = g_rzi.rzi08
         LET g_product_row = g_rzi.rzi07
         IF g_main_col <= 0 OR g_main_row <= 0 OR g_item_col <= 0 OR g_item_row <= 0 OR
            g_product_col <= 0 OR g_product_row <= 0 THEN
            LET l_cmd = "預設行列數不可空白或為0"
            CALL cl_err(l_cmd,"!",1)
            NEXT FIELD rzi03
         END IF
         
         IF (g_main_col * g_main_row) <= 2 OR (g_item_col * g_item_row) <= 2 OR
            (g_product_col * g_product_row) <= 2 THEN
            LET l_cmd = "因為行列數中的元件還需要包含上下頁的功能\n",
                        "因此設定的元件個數(行數*列數)不可 <= 2"
            CALL cl_err(l_cmd,"!",1)
            NEXT FIELD rzi03
         END IF
         
         # 紀錄每個分類一頁個別可以呈現的元件個數
         LET g_main_page_count = g_main_col * g_main_row
         LET g_item_page_count = g_item_col * g_item_row
         LET g_product_page_count = g_product_col * g_product_row +2
   END INPUT
END FUNCTION

# 修改
FUNCTION i054_u()

   IF cl_null(g_rzi.rzi01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_rzi.* FROM rzi_file WHERE rzi01 = g_rzi.rzi01

   IF g_rzi.rziacti = 'N' THEN
      CALL cl_err(g_rzi.rzi01,9027,0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   IF g_aza.aza88 = 'Y' THEN
      BEGIN WORK
      OPEN i054_cl USING g_rzi.rzi01
      IF STATUS THEN
         CALL cl_err("OPEN i054_cl:",STATUS,1)
         CLOSE i054_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH i054_cl INTO g_rzi.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_rzi.rzi01,SQLCA.sqlcode,1)
         CLOSE i054_cl
         ROLLBACK WORK
         RETURN
      END IF
      LET g_rzi_t.* = g_rzi.*
      LET g_rzipos = g_rzi.rzipos
      UPDATE rzi_file SET rzipos = '4'
       WHERE rzi01 = g_rzi_t.rzi01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rzi_file",g_rzi.rzipos,"",SQLCA.sqlcode,"","",1) 
         ROLLBACK WORK 
         RETURN
      END IF
      LET g_rzi.rzipos = '4'
      DISPLAY BY NAME g_rzi.rzipos
      CLOSE i054_cl
      COMMIT WORK
   END IF
   
   BEGIN WORK
   OPEN i054_cl USING g_rzi.rzi01
   IF STATUS THEN
      CALL cl_err("OPEN i054_cl:",STATUS,1)
      CLOSE i054_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i054_cl INTO g_rzi.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rzi.rzi01,SQLCA.sqlcode,1)
      CLOSE i054_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL i054_show()
   WHILE TRUE
      LET g_rzi_t.* = g_rzi.*
      LET g_rzi.rzimodu=g_user
      LET g_rzi.rzidate=g_today

      CALL i054_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rzi.*=g_rzi_t.*

         IF g_aza.aza88 = 'Y' THEN
            LET g_rzi.rzipos = g_rzipos
            UPDATE rzi_file SET rzipos = g_rzi.rzipos
             WHERE rzi01 = g_rzi_t.rzi01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","rzi_file",g_rzi.rzipos,"",SQLCA.sqlcode,"","",1)
               CONTINUE WHILE
            END IF
            DISPLAY BY NAME g_rzi.rzipos
         END IF

         CALL i054_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF g_aza.aza88 = 'Y' THEN
         IF g_rzipos <> '1' THEN
            LET g_rzi.rzipos = '2'
         ELSE
            LET g_rzi.rzipos = '1'
         END IF
      END IF

      UPDATE rzi_file SET rzi_file.* = g_rzi.*
       WHERE rzi01 = g_rzi_t.rzi01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_rzi.rzi01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_rzi.rzipos
      EXIT WHILE
   END WHILE
   CLOSE i054_cl
   COMMIT WORK
   SELECT * INTO g_rzi.* FROM rzi_file
    WHERE rzi01 = g_rzi.rzi01
   CALL i054_show()
END FUNCTION

# 删除
FUNCTION i054_r()

   IF cl_null(g_rzi.rzi01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_rzi.* FROM rzi_file WHERE rzi01 = g_rzi.rzi01

  #FUN-D30093--add--str---
   IF g_rzi.rziacti = 'N' THEN
      CALL cl_err(g_rzi.rzi01,'aim-153',1)
      RETURN
   END IF
  #FUN-D30093--add--end---

   BEGIN WORK

   OPEN i054_cl USING g_rzi.rzi01
   IF STATUS THEN
      CALL cl_err("OPEN i054_cl:",STATUS,1)
      CLOSE i054_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i054_cl INTO g_rzi.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rzi.rzi01,SQLCA.sqlcode,1)
      ROLLBACK WORK
      RETURN
   END IF
   CALL i054_show()

   IF g_aza.aza88  = 'Y' THEN
      IF NOT ((g_rzi.rzipos='3' AND g_rzi.rziacti='N') OR (g_rzi.rzipos='1'))  THEN
         CALL cl_err('','apc-139',0)
         RETURN
      END IF
   END IF
   IF cl_delete() THEN
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "rzi01"
      LET g_doc.value1 = g_rzi.rzi01
      CALL cl_del_doc()
      DELETE FROM rzj_file WHERE rzj01 = g_rzi.rzi01
      DELETE FROM rzk_file WHERE rzk01 = g_rzi.rzi01
      DELETE FROM rzi_file WHERE rzi01 = g_rzi.rzi01
      CLEAR FORM
      OPEN i054_count
      IF STATUS THEN
         CLOSE i054_cs
         CLOSE i054_count
         COMMIT WORK
         RETURN
      END IF
      FETCH i054_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i054_cs
         CLOSE i054_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i054_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i054_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i054_fetch('/')
      END IF
   END IF
   CLOSE i054_cl
   COMMIT WORK
   CALL i054_show()
END FUNCTION

# 复制
FUNCTION i054_copy()
 DEFINE l_newno    LIKE lmm_file.lmm01
 DEFINE l_oldno    LIKE lmm_file.lmm01
 DEFINE l_count    LIKE type_file.num5 

    IF g_rzi.rzi01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    LET g_before_input_done = FALSE
    CALL i054_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM rzi01

       AFTER FIELD rzi01
          LET l_count = 0
          IF NOT cl_null(l_newno) THEN
             SELECT COUNT(*) INTO l_count FROM rzi_file WHERE rzi01 = l_newno
             IF l_count > 0 THEN
                CALL cl_err('','-239',0)
                NEXT FIELD rzi01
             END IF
             DISPLAY l_newno TO rzi01
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
       DISPLAY BY NAME g_rzi.rzi01
       RETURN
    END IF
    DISPLAY l_newno TO rzi01

    DROP TABLE x
    SELECT * FROM rzi_file
     WHERE rzi01 = g_rzi.rzi01
      INTO TEMP x
    UPDATE x
       SET rzi01=l_newno,
           rzipos='1',
           rziacti='Y',
           rziuser=g_user,
           rzigrup=g_grup,
           rzimodu=NULL,
           rzidate=NULL,
           rzicrat=g_today
    INSERT INTO rzi_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","rzi_file",g_rzi.rzi01,"",SQLCA.sqlcode,"","",1)
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
  
    DROP TABLE y
    SELECT * FROM rzj_file
     WHERE rzj01 = g_rzi.rzi01
      INTO TEMP y
    UPDATE y
       SET rzj01 = l_newno
    INSERT INTO rzj_file SELECT * FROM y 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","rzk_file",g_rzi.rzi01,"",SQLCA.sqlcode,"","",1)
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF

    DROP TABLE z
    SELECT * FROM rzk_file
     WHERE rzk01 = g_rzi.rzi01
      INTO TEMP z
    UPDATE z
       SET rzk01 = l_newno 
    INSERT INTO rzk_file SELECT * FROM z
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","rzk_file",g_rzi.rzi01,"",SQLCA.sqlcode,"","",1)
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF

    LET l_oldno = g_rzi.rzi01
    LET g_rzi.rzi01 = l_newno
    CALL i054_u()
END FUNCTION

#FUN-D30093--add--str---
FUNCTION i054_x()
DEFINE l_rzl02     LIKE rzl_file.rzl02
DEFINE l_n         LIKE type_file.num5
DEFINE l_sql       STRING
   
   IF s_shut(0) THEN RETURN END IF

   IF g_rzi.rzi01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN i054_cl USING g_rzi.rzi01
   IF STATUS THEN
      CALL cl_err("OPEN i054_cl:",STATUS,1)
      CLOSE i054_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i054_cl INTO g_rzi.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rzi.rzi01,SQLCA.sqlcode,1)
      ROLLBACK WORK
      RETURN
   END IF

   IF cl_exp(0,0,g_rzi.rziacti) THEN
      LET g_chr=g_rzi.rziacti 
      IF g_rzi.rziacti = 'N' THEN 
         LET l_n = 0
         LET l_sql = " SELECT rzl02 FROM rzl_file WHERE rzl01 = '",g_rzi.rzi01,"' AND rzlacti = 'Y'"
         PREPARE sel_rzl02_pre FROM l_sql
         DECLARE sel_rzl02_cs  CURSOR FOR sel_rzl02_pre
         FOREACH sel_rzl02_cs INTO l_rzl02
            SELECT COUNT(*) INTO l_n FROM rzl_file
             WHERE rzl02 = l_rzl02
               AND rzl01 IN (SELECT rzi01 FROM rzi_file WHERE rziacti = 'Y')
               AND rzlacti = 'Y'
            IF l_n > 0 THEN
               CALL cl_err(l_rzl02,'apc-223',1)
               ROLLBACK WORK
               RETURN
            END IF
         END FOREACH
         LET g_rzi.rziacti = 'Y'
      ELSE
         LET g_rzi.rziacti = 'N'
      END IF
      UPDATE rzi_file SET rziacti = g_rzi.rziacti,
                          rzimodu = g_user,
                          rzidate = g_today
       WHERE rzi01 = g_rzi.rzi01
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rzi_file",g_rzi.rzi01,"",SQLCA.sqlcode,"","",1)
         LET g_rzi.rziacti = g_chr
         LET g_success = 'N'
      END IF
      UPDATE rzi_file SET rzipos = '2'
       WHERE rzi01 = g_rzi.rzi01
         AND rzipos IN ('3','4')
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","rzi_file",g_rzi.rzi01,"",SQLCA.sqlcode,"","",1)
         LET g_rzi.rziacti = g_chr
         LET g_success = 'N'
      END IF

      IF g_success = 'N' THEN
         ROLLBACK WORK
         CLOSE i054_cl
         RETURN
      END IF

      DISPLAY BY NAME g_rzi.rziacti
   END IF
   CLOSE i054_cl
   COMMIT WORK
   
END FUNCTION
#FUN-D30093--add--end---


FUNCTION i054_set_entry(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1

   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rzi01",TRUE)
   END IF
END FUNCTION

# 单身
FUNCTION i054_b()
DEFINE l_rzi01     LIKE rzi_file.rzi01

   LET g_action_choice = ""
   IF g_rzi.rzi01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

  #FUN-D30093--add--str---
   SELECT * INTO g_rzi.* FROM rzi_file WHERE rzi01 = g_rzi.rzi01
   IF g_rzi.rziacti = 'N' THEN
      CALL cl_err(g_rzi.rzi01,'alm1499',1)
      RETURN
   END IF   
  #FUN-D30093--add--end---
  
   BEGIN WORK
   LET g_success = 'Y'
   OPEN i054_cl USING g_rzi.rzi01
   IF STATUS THEN
      CALL cl_err("OPEN i054_cl:",STATUS,1)
      CLOSE i054_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i054_cl INTO g_rzi.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rzi.rzi01,SQLCA.sqlcode,1)
      CLOSE i054_cl
      ROLLBACK WORK
      RETURN
   END IF
   #FUN-D30075----Add-----Str
   IF g_aza.aza88 = 'Y' THEN
      LET g_rzipos = g_rzi.rzipos
      UPDATE rzi_file SET rzipos = '4'
       WHERE rzi01 = g_rzi.rzi01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rzi_file",g_rzi.rzi01,"",SQLCA.sqlcode,"","",1)
      END IF
      LET g_rzi.rzipos = '4'
      DISPLAY BY NAME g_rzi.rzipos
   END IF
   CLOSE i054_cl   
   COMMIT WORK  
   BEGIN WORK
   OPEN i054_cl USING g_rzi.rzi01
   IF STATUS THEN
      CALL cl_err("OPEN i054_cl:",STATUS,1)
      CLOSE i054_cl
      ROLLBACK WORK
   END IF
   FETCH i054_cl INTO g_rzi.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rzi.rzi01,SQLCA.sqlcode,1)
      CLOSE i054_cl
      ROLLBACK WORK
   END IF
   #FUN-D30075----Add-----End

   CALL cl_set_act_visible("query,reproduce,detail", FALSE)
   CALL cl_set_act_visible("true", TRUE)
   CALL cl_set_act_visible("next,previous,jump,first,last", FALSE)
   CALL cl_set_act_visible("effect", FALSE)   #FUN-D30075 Add 

   LET g_but1 = "main_but002"
   LET g_but2 = "item_but001"
   LET g_but3 = "product_but001"
   LET g_flag1 = '1'
   LET g_main_curr_page = 1
   LET g_item_curr_page = 1
   LET g_product_curr_page = 1
   LET g_main_start_index = 1
   LET g_item_start_index = 1
   LET g_product_start_index = 1

  #FUN-D30075---Mark---Str
  #IF g_aza.aza88 = 'Y' THEN
  #   LET g_rzipos = g_rzi.rzipos
  #   UPDATE rzi_file SET rzipos = '4'
  #    WHERE rzi01 = g_rzi.rzi01
  #   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
  #      CALL cl_err3("upd","rzi_file",g_rzi.rzi01,"",SQLCA.sqlcode,"","",1)
  #   END IF
  #   LET g_rzi.rzipos = '4'
  #   DISPLAY BY NAME g_rzi.rzipos
  #END IF
  #FUN-D30075---Mark---End
   SELECT * INTO g_rzi.* FROM rzi_file
    WHERE rzi01=g_rzi.rzi01
   CALL i054_show()
   CALL i054_main_act(2)       #默认大类的第二个按钮
END FUNCTION

#单身录入
FUNCTION i054_ab(p_flag)
DEFINE p_flag        LIKE type_file.chr1     #1:大类单身 2:小类单身 3:产品单身
DEFINE l_rcj13       LIKE rcj_file.rcj13 
DEFINE l_rcj14       LIKE rcj_file.rcj14
DEFINE l_rcj15       LIKE rcj_file.rcj15
DEFINE l_rzj         RECORD LIKE rzj_file.*
DEFINE l_rzk         RECORD LIKE rzk_file.*
DEFINE l_n           LIKE type_file.num5
DEFINE l_n1          LIKE type_file.num5
DEFINE l_str         LIKE type_file.chr100
DEFINE g_gca         RECORD LIKE gca_file.*

   IF p_flag = '1' THEN
      IF NOT cl_null(g_main_array[g_button1].main_id) THEN
         CALL cl_err('','apc1063',1)
         RETURN
      END IF
   END IF
   IF p_flag = '2' THEN
      IF NOT cl_null(g_item_array[g_button2].item_id) THEN
         CALL cl_err('','apc1063',1)
         RETURN
      END IF
   END IF
   IF p_flag = '3' THEN
      IF NOT cl_null(g_product_array[g_button3].product_id) THEN
         CALL cl_err('','apc1063',1)
         RETURN
      END IF
   END IF

  #LET g_success = 'Y' #FUN-D30075 Mark 
   SELECT rcj13,rcj14,rcj15 INTO l_rcj13,l_rcj14,l_rcj15 FROM rcj_file
   IF p_flag =  '1' OR p_flag =  '2' THEN
      CALL cl_init_qry_var()
      IF p_flag =  '1' THEN
        #IF l_rcj13 = '1' THEN      #FUN-D30093 mark
         IF g_rzi.rzi09 = '1' THEN  #FUN-D30093 add
            LET g_qryparam.form = "q_obapos"
         ELSE
            LET g_qryparam.form = "q_rzhpos"
         END IF
         LET g_qryparam.arg1 = l_rcj14
      ELSE
        #IF l_rcj13 = '1' THEN      #FUN-D30093 mark
         IF g_rzi.rzi09 = '1' THEN  #FUN-D30093 add
            LET g_qryparam.form = "q_obapos1"
         ELSE
            LET g_qryparam.form = "q_rzhpos1"
         END IF
         #FUN-D30006----Add&Mark------Str
         IF l_rcj15 = '99' THEN
           #IF l_rcj13 = '1' THEN      #FUN-D30093 mark
            IF g_rzi.rzi09 = '1' THEN  #FUN-D30093 add
               LET g_qryparam.where = " oba14 = '0'"
            ELSE
               LET g_qryparam.where = " rzh05 = '0'"
            END IF
         ELSE
           #IF l_rcj13 = '1' THEN      #FUN-D30093 mark
            IF g_rzi.rzi09 = '1' THEN  #FUN-D30093 add
               LET g_qryparam.where = " oba12 = '",l_rcj15,"'"
            ELSE
               LET g_qryparam.where = " rzh03 = '",l_rcj15,"'"
            END IF
         END IF
        #LET g_qryparam.arg1 = l_rcj15 
        #CALL i054_sel_oba() RETURNING g_qryparam.arg2 
         CALL i054_sel_oba() RETURNING g_qryparam.arg1
         #FUN-D30006----Add&Mark------End
      END IF
      CALL cl_create_qry() RETURNING l_rzj.rzj03
      IF NOT cl_null(l_rzj.rzj03) THEN
        #IF l_rcj13 = '1' THEN         #FUN-D30093 mark
         IF g_rzi.rzi09 = '1' THEN     #FUN-D30093 add
            SELECT oba02 INTO l_rzj.rzj04
              FROM oba_file
             WHERE oba01 = l_rzj.rzj03
         ELSE
            SELECT rzh02 INTO l_rzj.rzj04
              FROM rzh_file
             WHERE rzh01 = l_rzj.rzj03
         END IF
         LET l_rzj.rzj01 = g_rzi.rzi01
         LET l_rzj.rzj02 = p_flag
         LET l_rzj.rzjacti = 'Y'
         IF p_flag =  '1' THEN
            LET l_rzj.rzj05 = null
            SELECT MAX(rzj06)+1 INTO l_rzj.rzj06
              FROM rzj_file
             WHERE rzj01 = g_rzi.rzi01
               AND rzj02 = '1'
         ELSE
            LET l_rzj.rzj05 = g_main_array[g_button1].main_id
            SELECT MAX(rzj06)+1 INTO l_rzj.rzj06
              FROM rzj_file
             WHERE rzj01 = g_rzi.rzi01
               AND rzj02 = '2'
               AND rzj05 = l_rzj.rzj05
         END IF
         IF cl_null(l_rzj.rzj06) THEN
            LET l_rzj.rzj06 = 1
         END IF
         LET l_n1 = 0
         SELECT COUNT(*) INTO l_n1
           FROM rzj_file
          WHERE rzj01 = g_rzi.rzi01
            AND rzj03 = l_rzj.rzj03
         IF l_n1 = 0 THEN                        #数据库不存在此笔资料,则新增此笔资料
            INSERT INTO rzj_file VALUES(l_rzj.*)
            IF SQLCA.SQLCODE THEN
               LET g_success = 'N'
               CALL cl_err('',SQLCA.SQLCODE,1)
            END IF
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n
              FROM rzj_file
             WHERE rzj01 = g_rzi.rzi01
               AND rzj03 = l_rzj.rzj03
               AND rzjacti = 'Y'
            IF l_n > 0 THEN                      #数据库存在此笔资料且有效，提示是否移动此笔资料到当前位置
               IF cl_confirm("apc1062")  THEN    #是|则修改此笔资料的顺序号，否|则不做操作
                  IF p_flag =  '1' THEN
                    #UPDATE rzj_file SET rzj06 = g_button1   #FUN-D40015 Mark
                     UPDATE rzj_file SET rzj06 = l_rzj.rzj06 #FUN-D40015 Add
                      WHERE rzj01 = g_rzi.rzi01
                        AND rzj03 = l_rzj.rzj03
                     IF SQLCA.SQLCODE THEN
                        LET g_success = 'N'
                        CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
                     END IF
                 #FUN-D40015-------Mark------Str
                 #ELSE
                 #   UPDATE rzj_file SET rzj06 = g_button2
                 #    WHERE rzj01 = g_rzi.rzi01
                 #      AND rzj03 = l_rzj.rzj03
                 #   IF SQLCA.SQLCODE THEN
                 #      LET g_success = 'N'
                 #      CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
                 #   END IF
                 #FUN-D40015-------Mark------End
                  END IF
               END IF
            ELSE                                #数据库存在此笔资料且无效则直接更新此笔资料为有效
               UPDATE rzj_file SET rzjacti = 'Y',
                                   rzj04 = l_rzj.rzj04,
                                   rzj06 = l_rzj.rzj06
                WHERE rzj01 = g_rzi.rzi01
                  AND rzj03 = l_rzj.rzj03
               IF SQLCA.SQLCODE THEN
                  LET g_success = 'N'
                  CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
               END IF
            END IF
         END IF
      ELSE
         LET g_success = 'N'
      END IF
   END IF
   IF p_flag =  '3' THEN
      CALL cl_init_qry_var()
     #FUN-D30006-----Add&Mark-----Str
     #LET g_qryparam.form = "q_imapos"
     #IF l_rcj13 = '1' THEN            #FUN-D30093 mark
      IF g_rzi.rzi09 = '1' THEN        #FUN-D30093 add
         LET g_oba01_tree = "'",g_item_array[g_button2].item_id,"'"
         CALL i054_get_oba01_tree('1',g_item_array[g_button2].item_id)
         LET g_oba01_tree = "(",g_oba01_tree CLIPPED,")"
         LET g_qryparam.form = "q_imapos"
         LET g_qryparam.where = "ima131 IN ",g_oba01_tree CLIPPED
      ELSE
         LET g_oba01_tree = "'",g_item_array[g_button2].item_id,"'"
         CALL i054_get_oba01_tree('2',g_item_array[g_button2].item_id)
         LET g_oba01_tree = "(",g_oba01_tree CLIPPED,")"
         LET g_qryparam.form = "q_imapos1"
         LET g_qryparam.where = "ima1030 IN ",g_oba01_tree CLIPPED
      END IF
     #FUN-D30006-----Add&Mark-----End
     #LET g_qryparam.arg1 = g_item_array[g_button2].item_id #FUN-D30006 Mark
      CALL cl_create_qry() RETURNING l_rzk.rzk02 
      IF NOT cl_null(l_rzk.rzk02) THEN
         LET l_rzk.rzk01 = g_rzi.rzi01
        #SELECT ima25,ima131 INTO l_rzk.rzk03,l_rzk.rzk04   #FUN-D30006 Mark
         SELECT ima25 INTO l_rzk.rzk03                      #FUN-D30006 Add
           FROM ima_file 
          WHERE ima01 = l_rzk.rzk02
         LET l_rzk.rzk04 = g_item_array[g_button2].item_id  #FUN-D30006 Add
         CALL i054_check('',l_rzk.rzk02,l_rzk.rzk03)
         IF g_success = 'Y' THEN
            LET l_str = "ima01=",l_rzk.rzk02
            SELECT gca_file.* INTO g_gca.*
              FROM gca_file
             WHERE gca01 = l_str 
               AND gca02 = ' '
               AND gca03 = ' '
               AND gca04 = ' '
               AND gca05 = ' '
               AND gca08 = 'FLD'
               AND gca09 = 'ima04'
               AND gca11 = 'Y'
            LOCATE l_rzk.rzk05 IN MEMORY
            SELECT gcb09 INTO l_rzk.rzk05
              FROM gcb_file
             WHERE gcb01 = g_gca.gca07
               AND gcb02 = g_gca.gca08
               AND gcb03 = g_gca.gca09
               AND gcb04 = g_gca.gca10
            SELECT MAX(rzk06)+1 INTO l_rzk.rzk06
              FROM rzk_file
             WHERE rzk01 = g_rzi.rzi01
               AND rzk04 = l_rzk.rzk04
            IF cl_null(l_rzk.rzk06) THEN
               LET l_rzk.rzk06 = 1
            END IF
            LET l_rzk.rzkacti = 'Y'
            LET l_n1 = 0
            SELECT COUNT(*) INTO l_n1
              FROM rzk_file
             WHERE rzk01 = g_rzi.rzi01
               AND rzk02 = l_rzk.rzk02
            IF l_n1 = 0 THEN
               INSERT INTO rzk_file VALUES(l_rzk.*) 
               IF SQLCA.SQLCODE THEN
                  LET g_success = 'N'
                  CALL cl_err('',SQLCA.SQLCODE,1)
               END IF
            ELSE
               LET l_n = 0
               SELECT COUNT(*) INTO l_n
                 FROM rzk_file
                WHERE rzk01 = g_rzi.rzi01
                  AND rzk02 = l_rzk.rzk02
                  AND rzkacti = 'Y'
               IF l_n > 0 THEN
                  IF cl_confirm("apc1062")  THEN
                    #UPDATE rzk_file SET rzk06 = g_button3,    #FUN-D30006 Add ,   #FUN-D40015 Mark
                     UPDATE rzk_file SET rzk06 = l_rzk.rzk06,  #FUN-D40015 Add
                                         rzk04 = l_rzk.rzk04,  #FUN-D30006 Add 
                                         rzk05 = l_rzk.rzk05   #FUN-D30006 Add
                      WHERE rzk01 = g_rzi.rzi01
                        AND rzk02 = l_rzk.rzk02
                        AND rzk03 = l_rzk.rzk03
                     IF SQLCA.SQLCODE THEN
                        LET g_success = 'N'
                        CALL cl_err('upd_rzk',SQLCA.SQLCODE,1)
                     END IF
                  END IF
               ELSE
                  UPDATE rzk_file SET rzkacti = 'Y',
                                      rzk03 = l_rzk.rzk03,     #FUN-D30093 add
                                      rzk04 = l_rzk.rzk04,     #FUN-D30093 add
                                      rzk05 = l_rzk.rzk05,
                                      rzk06 = l_rzk.rzk06
                   WHERE rzk01 = g_rzi.rzi01
                     AND rzk02 = l_rzk.rzk02
                     AND rzk03 = l_rzk.rzk03
                  IF SQLCA.SQLCODE THEN
                     LET g_success = 'N' 
                     CALL cl_err('upd_rzk',SQLCA.SQLCODE,1)
                  END IF
               END IF
            END IF
         END IF
      ELSE
         LET g_success = 'N'
      END IF
   END IF
  #FUN-D30075----Mark----Str
  #IF g_success = 'Y' THEN
  #   IF g_aza.aza88 = 'Y' THEN
  #      IF g_rzipos <> '1' THEN
  #         LET g_rzipos = '2'
  #      ELSE
  #         LET g_rzipos = '1'
  #      END IF
  #   END IF
  #END IF
  #FUN-D30075----Mark----End
  #IF g_success ='Y' THEN              #FUN-D40015 Mark
   IF NOT cl_null(l_rzj.rzj03) OR NOT cl_null(l_rzk.rzk02) THEN    #FUN-D40015 Add
      CALL i054_refresh(p_flag,l_rzj.rzj03) 
   END IF  
END FUNCTION


#单身更改
FUNCTION i054_ub(p_flag)
DEFINE p_flag        LIKE type_file.chr1     #1:大类单身 2:小类单身 3:产品单身
DEFINE l_rcj13       LIKE rcj_file.rcj13
DEFINE l_rcj14       LIKE rcj_file.rcj14
DEFINE l_rcj15       LIKE rcj_file.rcj15
DEFINE l_rzj         RECORD LIKE rzj_file.*
DEFINE l_rzk         RECORD LIKE rzk_file.*
DEFINE l_n           LIKE type_file.num5
DEFINE l_n1          LIKE type_file.num5
DEFINE l_str         LIKE type_file.chr100
DEFINE g_gca         RECORD LIKE gca_file.*
DEFINE l_success     LIKE type_file.chr1    #FUN-D40015 Add
DEFINE l_rzj06       LIKE rzj_file.rzj06    #FUN-D40015 Add
DEFINE l_rzk06       LIKE rzk_file.rzk06    #FUN-D40015 Add
  
   IF p_flag = '1' THEN
      IF cl_null(g_main_array[g_button1].main_id) THEN
         CALL cl_err('','apc1064',1)
         RETURN
      END IF
   END IF
   IF p_flag = '2' THEN
      IF cl_null(g_item_array[g_button2].item_id) THEN
         CALL cl_err('','apc1064',1)
         RETURN
      END IF
   END IF
   IF p_flag = '3' THEN
      IF cl_null(g_product_array[g_button3].product_id) THEN
         CALL cl_err('','apc1064',1)
         RETURN
      END IF
   END IF 

  #BEGIN WORK              #FUN-D30075 Mark
  #LET g_success = 'Y'     #FUN-D30075 Mark

   LET l_success = 'Y'     #FUN-D40015 Add
  #FUN-D40015-----Mark-----Str
  #IF p_flag = '1' THEN
  #   UPDATE rzj_file SET rzjacti = 'N'
  #    WHERE rzj01 = g_rzi.rzi01
  #      AND rzj03 = g_main_array[g_button1].main_id
  #   IF SQLCA.SQLCODE THEN
  #      LET g_success = 'N'
  #      CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
  #   END IF
  #END IF
  #IF p_flag = '2' THEN
  #   UPDATE rzj_file SET rzjacti = 'N'
  #    WHERE rzj01 = g_rzi.rzi01
  #      AND rzj03 = g_item_array[g_button2].item_id
  #   IF SQLCA.SQLCODE THEN
  #      LET g_success = 'N'
  #      CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
  #   END IF
  #END IF
  #IF p_flag = '3' THEN
  #   UPDATE rzk_file SET rzkacti = 'N'
  #    WHERE rzk01 = g_rzi.rzi01
  #      AND rzk02 = g_product_array[g_button3].product_id
  #      AND rzk03 = g_product_array[g_button3].product_unit
  #   IF SQLCA.SQLCODE THEN
  #      LET g_success = 'N'
  #      CALL cl_err('upd_rzk',SQLCA.SQLCODE,1)
  #   END IF
  #END IF
  #FUN-D40015-----Mark-----End

   SELECT rcj13,rcj14,rcj15 INTO l_rcj13,l_rcj14,l_rcj15 FROM rcj_file
   IF p_flag =  '1' OR p_flag =  '2' THEN
      CALL cl_init_qry_var()
      IF p_flag =  '1' THEN
        #IF l_rcj13 = '1' THEN          #FUN-D30093 mark
         IF g_rzi.rzi09 = '1' THEN      #FUN-D30093 add
            LET g_qryparam.form = "q_obapos"
         ELSE
            LET g_qryparam.form = "q_rzhpos"
         END IF
         LET g_qryparam.arg1 = l_rcj14
      ELSE
        #IF l_rcj13 = '1' THEN          #FUN-D30093 mark
         IF g_rzi.rzi09 = '1' THEN      #FUN-D30093 add
            LET g_qryparam.form = "q_obapos1"
         ELSE
            LET g_qryparam.form = "q_rzhpos1"
         END IF
         #FUN-D30006----Add&Mark------Str
         IF l_rcj15 = '99' THEN
           #IF l_rcj13 = '1' THEN       #FUN-D30093 mark
            IF g_rzi.rzi09 = '1' THEN   #FUN-D30093 add
               LET g_qryparam.where = " oba14 = '0'"
            ELSE
               LET g_qryparam.where = " rzh05 = '0'"
            END IF
         ELSE
           #IF l_rcj13 = '1' THEN       #FUN-D30093 mark
            IF g_rzi.rzi09 = '1' THEN   #FUN-D30093 add
               LET g_qryparam.where = " oba12 = '",l_rcj15,"'"
            ELSE
               LET g_qryparam.where = " rzh03 = '",l_rcj15,"'"
            END IF
         END IF
        #LET g_qryparam.arg1 = l_rcj15
        #CALL i054_sel_oba() RETURNING g_qryparam.arg2
         CALL i054_sel_oba() RETURNING g_qryparam.arg1
         #FUN-D30006----Add&Mark------End
      END IF
      CALL cl_create_qry() RETURNING l_rzj.rzj03
      IF NOT cl_null(l_rzj.rzj03) THEN
        #IF l_rcj13 = '1' THEN          #FUN-D30093 mark
         IF g_rzi.rzi09 = '1' THEN      #FUN-D30093 add 
            SELECT oba02 INTO l_rzj.rzj04
              FROM oba_file
             WHERE oba01 = l_rzj.rzj03
         ELSE
            SELECT rzh02 INTO l_rzj.rzj04
              FROM rzh_file
             WHERE rzh01 = l_rzj.rzj03
         END IF
         LET l_rzj.rzj01 = g_rzi.rzi01
         LET l_rzj.rzj02 = p_flag
         LET l_rzj.rzjacti = 'Y'
         IF p_flag =  '1' THEN
            LET l_rzj.rzj05 = null
            SELECT MAX(rzj06)+1 INTO l_rzj.rzj06
              FROM rzj_file
             WHERE rzj01 = g_rzi.rzi01
               AND rzj02 = '1'
         ELSE
            LET l_rzj.rzj05 = g_main_array[g_button1].main_id
            SELECT MAX(rzj06)+1 INTO l_rzj.rzj06
              FROM rzj_file
             WHERE rzj01 = g_rzi.rzi01
               AND rzj02 = '2'
               AND rzj05 = l_rzj.rzj05
         END IF
         IF cl_null(l_rzj.rzj06) THEN
            LET l_rzj.rzj06 = 1
         END IF
         #FUN-D40015-----Add------Str
         IF p_flag = '1' THEN
            SELECT rzj06 INTO l_rzj06
              FROM rzj_file
             WHERE rzj01 = g_rzi.rzi01
               AND rzj03 = g_main_array[g_button1].main_id   
         ELSE
            SELECT rzj06 INTO l_rzj06
              FROM rzj_file
             WHERE rzj01 = g_rzi.rzi01
               AND rzj03 = g_item_array[g_button2].item_id 
         END IF
         IF cl_null(l_rzj06) THEN
            LET l_rzj06 = 1
         END IF
         #FUN-D40015-----Add------End
         LET l_n1 = 0
         SELECT COUNT(*) INTO l_n1
           FROM rzj_file
          WHERE rzj01 = g_rzi.rzi01
            AND rzj03 = l_rzj.rzj03
         IF l_n1 = 0 THEN                                 #数据库不存在此笔资料,则新增此笔资料
            INSERT INTO rzj_file VALUES(l_rzj.*)
            IF SQLCA.SQLCODE THEN
               LET g_success = 'N'  
               LET l_success = 'N'    #FUN-D40015 Add
               CALL cl_err('',SQLCA.SQLCODE,1)
            END IF
            #FUN-D40015-----Add------Str
            IF p_flag = '1' THEN
               UPDATE rzj_file SET rzj06 = l_rzj06
                WHERE rzj01 = g_rzi.rzi01
                  AND rzj03 = l_rzj.rzj03
               IF SQLCA.SQLCODE THEN
                  LET g_success = 'N'
                  LET l_success = 'N'    #FUN-D40015 Add
                  CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
               END IF
               UPDATE rzj_file SET rzj06 = l_rzj.rzj06 
                WHERE rzj01 = g_rzi.rzi01
                  AND rzj03 = g_main_array[g_button1].main_id
               IF SQLCA.SQLCODE THEN
                  LET g_success = 'N'
                  LET l_success = 'N'    #FUN-D40015 Add
                  CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
               END IF
            END IF
            IF p_flag = '2' THEN
               UPDATE rzj_file SET rzj06 = l_rzj06
                WHERE rzj01 = g_rzi.rzi01
                  AND rzj03 = l_rzj.rzj03
               IF SQLCA.SQLCODE THEN
                  LET g_success = 'N'
                  LET l_success = 'N'   
                  CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
               END IF
               UPDATE rzj_file SET rzj06 = l_rzj.rzj06
                WHERE rzj01 = g_rzi.rzi01
                  AND rzj03 = g_item_array[g_button2].item_id
               IF SQLCA.SQLCODE THEN
                  LET g_success = 'N'
                  LET l_success = 'N'
                  CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
               END IF
            END IF
            #FUN-D40015-----Add------End
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n
              FROM rzj_file
             WHERE rzj01 = g_rzi.rzi01
               AND rzj03 = l_rzj.rzj03
               AND rzjacti = 'Y'
            IF l_n > 0 THEN                               #数据库存在此笔资料且有效则报错不可修改
               LET g_success = 'N' 
               LET l_success = 'N'    #FUN-D40015 Add
               CALL cl_err('','apc1065',1)
            ELSE                                          #数据库存在此笔资料且无效
               IF p_flag = '1' THEN
                  UPDATE rzj_file SET rzjacti = 'Y',      #更新此笔资料为有效,顺序号为当前顺序号     
                                      rzj04 = l_rzj.rzj04,
                                     #rzj06 = g_button1   #FUN-D40015 Mark
                                      rzj06 = l_rzj06     #FUN-D40015 Add  
                   WHERE rzj01 = g_rzi.rzi01
                     AND rzj03 = l_rzj.rzj03
                  IF SQLCA.SQLCODE THEN
                     LET g_success = 'N'
                     LET l_success = 'N'    #FUN-D40015 Add
                     CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
                  END IF
                  UPDATE rzj_file SET rzj06 = l_rzj.rzj06 #更新修改前的数据顺序号为最大顺序号加一
                   WHERE rzj01 = g_rzi.rzi01
                     AND rzj03 = g_main_array[g_button1].main_id
                  IF SQLCA.SQLCODE THEN
                     LET g_success = 'N'
                     LET l_success = 'N'    #FUN-D40015 Add
                     CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
                  END IF
               END IF
               IF p_flag = '2' THEN
                  UPDATE rzj_file SET rzjacti = 'Y',
                                      rzj04 = l_rzj.rzj04,
                                     #rzj06 = g_button2    #FUN-D40015 Mark
                                      rzj06 = l_rzj06      #FUN-D40015 Add
                   WHERE rzj01 = g_rzi.rzi01
                     AND rzj03 = l_rzj.rzj03
                  IF SQLCA.SQLCODE THEN
                     LET g_success = 'N'
                     LET l_success = 'N'    #FUN-D40015 Add
                     CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
                  END IF
                  UPDATE rzj_file SET rzj06 = l_rzj.rzj06
                   WHERE rzj01 = g_rzi.rzi01
                     AND rzj03 = g_item_array[g_button2].item_id
                  IF SQLCA.SQLCODE THEN
                     LET g_success = 'N' 
                     LET l_success = 'N'    #FUN-D40015 Add
                     CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
                  END IF
               END IF
            END IF
         END IF
      ELSE
         LET g_success = 'N'
         LET l_success = 'N'    #FUN-D40015 Add
      END IF
   END IF
   
   IF p_flag =  '3' THEN
      CALL cl_init_qry_var()
     #FUN-D30006-----Add&Mark-----Str
     #LET g_qryparam.form = "q_imapos"
     #IF l_rcj13 = '1' THEN              #FUN-D30093 mark
      IF g_rzi.rzi09 = '1' THEN          #FUN-D30093 add
         LET g_oba01_tree = "'",g_item_array[g_button2].item_id,"'"
         CALL i054_get_oba01_tree('1',g_item_array[g_button2].item_id)
         LET g_oba01_tree = "(",g_oba01_tree CLIPPED,")"
         LET g_qryparam.form = "q_imapos"
         LET g_qryparam.where = "ima131 IN ",g_oba01_tree CLIPPED
      ELSE
         LET g_oba01_tree = "'",g_item_array[g_button2].item_id,"'"
         CALL i054_get_oba01_tree('2',g_item_array[g_button2].item_id)
         LET g_oba01_tree = "(",g_oba01_tree CLIPPED,")"
         LET g_qryparam.form = "q_imapos1"
         LET g_qryparam.where = "ima1030 IN ",g_oba01_tree CLIPPED
      END IF
     #FUN-D30006-----Add&Mark-----End
     #LET g_qryparam.arg1 = g_item_array[g_button2].item_id #FUN-D30006 Mark
      CALL cl_create_qry() RETURNING l_rzk.rzk02
      IF NOT cl_null(l_rzk.rzk02) THEN
         LET l_rzk.rzk01 = g_rzi.rzi01
        #SELECT ima25,ima131 INTO l_rzk.rzk03,l_rzk.rzk04   #FUN-D30006 Mark
         SELECT ima25 INTO l_rzk.rzk03                      #FUN-D30006 Add
           FROM ima_file 
          WHERE ima01 = l_rzk.rzk02
         LET l_rzk.rzk04 = g_item_array[g_button2].item_id  #FUN-D30006 Add
         CALL i054_check('',l_rzk.rzk02,l_rzk.rzk03)
         LET l_str = "ima01=",l_rzk.rzk02
         SELECT gca_file.* INTO g_gca.*
           FROM gca_file
          WHERE gca01 = l_str
            AND gca02 = ' '
            AND gca03 = ' '
            AND gca04 = ' '
            AND gca05 = ' '
            AND gca08 = 'FLD'
            AND gca09 = 'ima04'
            AND gca11 = 'Y'
         LOCATE l_rzk.rzk05 IN MEMORY
         SELECT gcb09 INTO l_rzk.rzk05
           FROM gcb_file
          WHERE gcb01 = g_gca.gca07
            AND gcb02 = g_gca.gca08
            AND gcb03 = g_gca.gca09
            AND gcb04 = g_gca.gca10
         SELECT MAX(rzk06)+1 INTO l_rzk.rzk06
           FROM rzk_file
          WHERE rzk01 = g_rzi.rzi01
            AND rzk04 = l_rzk.rzk04
         IF cl_null(l_rzk.rzk06) THEN
            LET l_rzk.rzk06 = 1
         END IF
         #FUN-D40015----Add----Str
         SELECT rzk06 INTO l_rzk06
           FROM rzk_file
          WHERE rzk01 = g_rzi.rzi01
            AND rzk04 = l_rzk.rzk04
         IF cl_null(l_rzk06) THEN
            LET l_rzk06 = 1
         END IF
         #FUN-D40015----Add----End
         LET l_rzk.rzkacti = 'Y'
         LET l_n1 = 0
         SELECT COUNT(*) INTO l_n1
           FROM rzk_file
          WHERE rzk01 = g_rzi.rzi01
            AND rzk02 = l_rzk.rzk02
         IF l_n1 = 0 THEN
            INSERT INTO rzk_file VALUES(l_rzk.*)
            IF SQLCA.SQLCODE THEN
               LET g_success = 'N'
               LET l_success = 'N'    #FUN-D40015 Add
               CALL cl_err('',SQLCA.SQLCODE,1)
            END IF
            #FUN-D40015-----Add------Str
            UPDATE rzk_file SET rzk06 = l_rzk06
             WHERE rzk01 = g_rzi.rzi01
               AND rzk02 = l_rzk.rzk02
               AND rzk03 = l_rzk.rzk03
            IF SQLCA.SQLCODE THEN
               LET g_success = 'N'
               LET l_success = 'N' 
               CALL cl_err('upd_rzk',SQLCA.SQLCODE,1)
            END IF
            UPDATE rzk_file SET rzk06 = l_rzk.rzk06
             WHERE rzk01 = g_rzi.rzi01
               AND rzk02 = g_product_array[g_button3].product_id
               AND rzk03 = g_product_array[g_button3].product_unit
            IF SQLCA.SQLCODE THEN
               LET g_success = 'N'
               LET l_success = 'N'
               CALL cl_err('upd_rzk',SQLCA.SQLCODE,1)
            END IF
            #FUN-D40015-----Add------End
         ELSE
            LET l_n = 0
            SELECT COUNT(*) INTO l_n
              FROM rzk_file
             WHERE rzk01 = g_rzi.rzi01
               AND rzk02 = l_rzk.rzk02
               AND rzkacti = 'Y'
            IF l_n > 0 THEN
               LET g_success = 'N'     
               LET l_success = 'N'    #FUN-D40015 Add
               CALL cl_err('','apc1065',1)
            ELSE
               UPDATE rzk_file SET rzkacti = 'Y',
                                   rzk05 = l_rzk.rzk05,
                                   rzk04 = l_rzk.rzk04,  #FUN-D30006 Add 
                                  #rzk06 = g_button3     #FUN-D40015 Mark
                                   rzk06 = l_rzk06       #FUN-D40015 Add
                WHERE rzk01 = g_rzi.rzi01
                  AND rzk02 = l_rzk.rzk02
                  AND rzk03 = l_rzk.rzk03
               IF SQLCA.SQLCODE THEN
                  LET g_success = 'N'
                  LET l_success = 'N'    #FUN-D40015 Add
                  CALL cl_err('upd_rzk',SQLCA.SQLCODE,1)
               END IF
               UPDATE rzk_file SET rzk06 = l_rzk.rzk06
                WHERE rzk01 = g_rzi.rzi01
                  AND rzk02 = g_product_array[g_button3].product_id 
                  AND rzk03 = g_product_array[g_button3].product_unit
               IF SQLCA.SQLCODE THEN
                  LET g_success = 'N'
                  LET l_success = 'N'    #FUN-D40015 Add 
                  CALL cl_err('upd_rzk',SQLCA.SQLCODE,1)
               END IF
            END IF
         END IF
      ELSE
         LET g_success = 'N'
         LET l_success = 'N'    #FUN-D40015 Add
      END IF
   END IF
   #FUN-D40015--------Add----Str
   IF l_success = 'Y' THEN
      IF p_flag = '1' THEN
         UPDATE rzj_file SET rzjacti = 'N'
          WHERE rzj01 = g_rzi.rzi01
            AND rzj03 = g_main_array[g_button1].main_id
         IF SQLCA.SQLCODE THEN
            LET g_success = 'N'
            CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
         END IF
      END IF
      IF p_flag = '2' THEN
         UPDATE rzj_file SET rzjacti = 'N'
          WHERE rzj01 = g_rzi.rzi01
            AND rzj03 = g_item_array[g_button2].item_id
         IF SQLCA.SQLCODE THEN
            LET g_success = 'N'
            CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
         END IF
      END IF
      IF p_flag = '3' THEN
         UPDATE rzk_file SET rzkacti = 'N'
          WHERE rzk01 = g_rzi.rzi01
            AND rzk02 = g_product_array[g_button3].product_id
            AND rzk03 = g_product_array[g_button3].product_unit
         IF SQLCA.SQLCODE THEN
            LET g_success = 'N'
            CALL cl_err('upd_rzk',SQLCA.SQLCODE,1)
         END IF
      END IF   
   END IF
   #FUN-D40015--------Add----End
  #FUN-D30075--Mark$Add--Str
  #IF g_success = 'Y' THEN
  #   IF g_aza.aza88 = 'Y' THEN
  #      IF g_rzipos <> '1' THEN
  #         LET g_rzipos = '2'
  #      ELSE
  #         LET g_rzipos = '1'
  #      END IF
  #   END IF
  #END IF
  #IF g_success = 'Y' THEN
  #   COMMIT WORK 
  #   CALL i054_refresh(p_flag,l_rzj.rzj03)
  #ELSE
  #   ROLLBACK WORK
  #END IF
  #IF g_success = 'Y' THEN   #FUN-D40015 Mark
   IF NOT cl_null(l_rzj.rzj03) OR NOT cl_null(l_rzk.rzk02) THEN     #FUN-D40015 Add
      CALL i054_refresh(p_flag,l_rzj.rzj03)
   END IF           
  #FUN-D30075--Mark&Add--End
  
END FUNCTION

#单身删除
FUNCTION i054_rb(p_flag)
DEFINE p_flag        LIKE type_file.chr1     #1:大类单身 2:小类单身 3:产品单身

   IF p_flag = '1' THEN
      IF cl_null(g_main_array[g_button1].main_id) THEN
         CALL cl_err('','apc1064',1)
         RETURN
      END IF
   END IF
   IF p_flag = '2' THEN
      IF cl_null(g_item_array[g_button2].item_id) THEN
         CALL cl_err('','apc1064',1)
         RETURN
      END IF
   END IF
   IF p_flag = '3' THEN
      IF cl_null(g_product_array[g_button3].product_id) THEN
         CALL cl_err('','apc1064',1)
         RETURN
      END IF
   END IF
   IF NOT cl_delb(0,0) THEN
      RETURN
   END IF

  #BEGIN WORK              #FUN-D30075 Mark
  #LET g_success = 'Y'     #FUN-D30075 Mark
   IF p_flag = '1' THEN
      UPDATE rzj_file SET rzjacti = 'N'
       WHERE rzj01 = g_rzi.rzi01
         AND rzj03 = g_main_array[g_button1].main_id 
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
      END IF
      UPDATE rzj_file SET rzjacti = 'N'
       WHERE rzj01 = g_rzi.rzi01
         AND rzj05 = g_main_array[g_button1].main_id
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
      END IF
      UPDATE rzk_file SET rzkacti = 'N'
       WHERE rzk01 = g_rzi.rzi01
         AND rzk04 IN (SELECT rzj03 
                         FROM rzj_file 
                        WHERE rzj01 = g_rzi.rzi01
                          AND rzj05 = g_main_array[g_button1].main_id)
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err('upd_rzk',SQLCA.SQLCODE,1)
      END IF
     #IF g_success = 'Y' THEN   #FUN-D40015 Mark
      IF NOT cl_null(g_main_array[g_button1+1].main_id) THEN       #FUN-D40015 Add
         CALL i054_refresh(p_flag,g_main_array[g_button1+1].main_id)
      ELSE                                                         #FUN-D40015 Add   
         CALL i054_refresh(p_flag,g_main_array[g_button1].main_id) #FUN-D40015 Add 
      END IF  
   END IF
   IF p_flag = '2' THEN
      UPDATE rzj_file SET rzjacti = 'N'
       WHERE rzj01 = g_rzi.rzi01
         AND rzj03 = g_item_array[g_button2].item_id
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err('upd_rzj',SQLCA.SQLCODE,1)
      END IF
      UPDATE rzk_file SET rzkacti = 'N'
       WHERE rzk01 = g_rzi.rzi01
         AND rzk04 = g_item_array[g_button2].item_id
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err('upd_rzk',SQLCA.SQLCODE,1)
      END IF
     #IF g_success = 'Y' THEN    #FUN-D40015 Mark
      IF NOT cl_null(g_item_array[g_button2+1].item_id) THEN        #FUN-D40015 Add
         CALL i054_refresh(p_flag,g_item_array[g_button2+1].item_id)
      ELSE                                                          #FUN-D40015 Add
         CALL i054_refresh(p_flag,g_item_array[g_button2].item_id)  #FUN-D40015 Add
      END IF 
   END IF
   IF p_flag = '3' THEN
      UPDATE rzk_file SET rzkacti = 'N'
       WHERE rzk01 = g_rzi.rzi01
         AND rzk02 = g_product_array[g_button3].product_id
         AND rzk03 = g_product_array[g_button3].product_unit
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
         CALL cl_err('upd_rzk',SQLCA.SQLCODE,1)
     #ELSE                            #FUN-D40015 Mark
     #   CALL i054_refresh(p_flag,'') #FUN-D40015 Mark 
      END IF
      CALL i054_refresh(p_flag,'')    #FUN-D40015 Add
   END IF
  #FUN-D30075----Mark------Str
  #IF g_success = 'Y' THEN
  #   IF g_aza.aza88 = 'Y' THEN
  #      IF g_rzipos <> '1' THEN
  #         LET g_rzipos = '2'
  #      ELSE
  #         LET g_rzipos = '1'
  #      END IF
  #   END IF
  #END IF
  #IF g_success = 'Y' THEN
  #   COMMIT WORK
  #ELSE
  #   ROLLBACK WORK
  #END IF
  #FUN-D30075----Mark------End
END FUNCTION

FUNCTION i054_set_no_entry(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1

   IF p_cmd = 'u' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rzi01",FALSE)
   END IF
END FUNCTION

# 紀錄要隱藏的action
FUNCTION i054_get_act_hidden()
   DEFINE lc_act_hidden    STRING
   DEFINE lc_n             LIKE type_file.num5
   DEFINE lc_start         LIKE type_file.num5

   # 大分類要隱藏的action
   LET lc_start = g_main_page_count + 1
   FOR lc_n = lc_start TO g_act_max
      LET lc_act_hidden = lc_act_hidden,",main_but",lc_n USING "&&&"
   END FOR

   # 小分類要隱藏的action
   LET lc_start = g_item_page_count + 1
   FOR lc_n = lc_start TO g_act_max
      LET lc_act_hidden = lc_act_hidden,",item_but",lc_n USING "&&&"
   END FOR

   # 商品細項要隱藏的action
   # 因為商品細項的action按下去之後並不會有作用，所以全部隱藏起來

   LET lc_start = g_product_page_count + 1
   FOR lc_n = lc_start TO g_act_max
      LET lc_act_hidden = lc_act_hidden,",product_but",lc_n USING "&&&"
   END FOR

   IF lc_act_hidden.getindexof(",",1) > 0 THEN   #拿掉第一個","
      LET lc_act_hidden = lc_act_hidden.substring(2,lc_act_hidden.getlength())
   END IF

   RETURN lc_act_hidden
END FUNCTION

# 取得資料
FUNCTION i054_get_data(li_kind,li_curr_main_id,li_curr_item_id)
   DEFINE li_kind                 LIKE type_file.chr1     # 要取得何種分類的資料
   DEFINE li_m                    LIKE type_file.num5     # 大分類
   DEFINE li_i                    LIKE type_file.num5     # 小分類
   DEFINE li_p                    LIKE type_file.num5     # 商品細項
   DEFINE li_cnt                  LIKE type_file.num5    
   DEFINE li_curr_main_id         LIKE type_file.chr10    # 目前大分類的哪一筆資料
   DEFINE li_curr_item_id         LIKE type_file.chr10    # 目前小分類的哪一筆資料
   DEFINE li_k                    LIKE type_file.num5
   DEFINE li_sql                  STRING
   DEFINE l_str                   STRING
   DEFINE l_ima25                 LIKE ima_file.ima25 
   DEFINE l_rtz05                 LIKE rtz_file.rtz05

   CASE li_kind
      WHEN "M"     # 取得大分類資料
         LET g_item_curr_page = 1
         LET g_item_start_index = 1
         LET g_product_curr_page = 1
         LET g_product_start_index = 1
         CALL g_main_array.clear()
         CALL g_main_form_but.clear()
         LET li_cnt = 1
         LET li_k = 1
         DECLARE main_data_curs CURSOR FOR
            SELECT rzj03,rzj04 FROM rzj_file
             WHERE rzj01 = g_rzi.rzi01
               AND rzj02 = '1'
               AND rzjacti = 'Y'
             ORDER BY rzj06
         FOREACH main_data_curs INTO g_main_array[li_cnt].*
            IF cl_null(li_curr_main_id) THEN
               IF li_cnt = 1 THEN     # 預設取第一筆資料
                  LET li_curr_main_id = g_main_array[li_cnt].main_id
               END IF
            END IF

            # 將資料塞到array中，以便之後要做資料update時可以取到button與資料的對應關係
            # 所以g_main_form_but中需預留上下頁的button的筆數
            IF li_k MOD g_main_page_count = 1 THEN   # 表示為上一頁
               LET g_main_form_but[li_k].main_but_name = "main_but",li_k USING "&&&"
               LET g_main_form_but[li_k].main_id = "P"
               LET li_k = li_k + 1
            END IF

            IF li_k MOD g_main_page_count <> 0 AND li_k MOD g_main_page_count <> 1 THEN
               LET g_main_form_but[li_k].main_but_name = ""
               LET g_main_form_but[li_k].main_id = g_main_array[li_cnt].main_id
               LET li_k = li_k + 1
            END IF

            IF li_k MOD g_main_page_count = 0 THEN   # 表示為下一頁
               LET g_main_form_but[li_k].main_but_name = "main_but",li_k USING "&&&"
               LET g_main_form_but[li_k].main_id = "N"
               LET li_k = li_k + 1
            END IF

            LET li_cnt = li_cnt + 1
         END FOREACH
         CALL g_main_array.deleteElement(li_cnt)

         IF cl_null(g_main_curr_page) OR g_main_curr_page = 0 OR g_flag1 = '0' THEN 
            LET g_main_curr_page = 1        # 預設從第一頁開始
         END IF
         IF cl_null(g_main_start_index) OR g_main_start_index = 0 OR g_flag1 = '0' THEN 
            LET g_main_start_index = 1      # 預設從第一筆開始
         END IF

         # 紀錄array長度，因為後面可能還會塞空白資料
         LET g_main_array_langth = g_main_array.getLength()

         # 每頁須扣除掉2個元件，作為上下頁功能鍵
         LET g_main_end_index = (g_main_start_index + (g_main_page_count - 2)) - 1
  
         # 若更新大分類資料，也須一併更新小分類資料
         CALL i054_get_data("I",li_curr_main_id,"")
  
      WHEN "I"     # 取得小分類資料
         CALL g_item_array.clear()
         CALL g_item_form_but.clear()
         LET g_product_curr_page = 1
         LET g_product_start_index = 1
         LET li_cnt = 1
         LET li_k = 1
         DECLARE item_data_curs CURSOR FOR
            SELECT rzj05,rzj03,rzj04 FROM rzj_file
             WHERE rzj01 = g_rzi.rzi01
               AND rzj02 = '2'
               AND rzj05 = li_curr_main_id
               AND rzjacti = 'Y'
             ORDER BY rzj06
         FOREACH item_data_curs INTO g_item_array[li_cnt].*
            IF cl_null(li_curr_item_id) THEN    #FUN-D40015 Add
               IF li_cnt = 1 THEN     # 預設取第一筆資料
                  LET li_curr_main_id = g_item_array[li_cnt].item_main_id
                  LET li_curr_item_id = g_item_array[li_cnt].item_id
               END IF 
            END IF                              #FUN-D40015 Add

            # 將資料塞到array中，以便之後要做資料update時可以取到button與資料的對應關係
            # 所以g_item_form_but中需預留上下頁的button的筆數
            IF li_k MOD g_item_page_count > 1 THEN
               LET g_item_form_but[li_k].item_but_name = ""
               LET g_item_form_but[li_k].item_main_id = g_item_array[li_cnt].item_main_id
               LET g_item_form_but[li_k].item_id = g_item_array[li_cnt].item_id
               LET li_k = li_k + 1
            END IF

            IF li_k MOD g_item_page_count = g_item_page_count - 1 THEN   # 表示為上一頁
               LET g_item_form_but[li_k].item_but_name = "item_but",li_k USING "&&&"
               LET g_item_form_but[li_k].item_main_id = "P"
               LET g_item_form_but[li_k].item_id = "P"
               LET li_k = li_k + 1
            END IF

            IF li_k MOD g_item_page_count = 0 THEN   # 表示為下一頁
               LET g_item_form_but[li_k].item_but_name = "item_but",li_k USING "&&&"
               LET g_item_form_but[li_k].item_main_id = "N"
               LET g_item_form_but[li_k].item_id = "N"
               LET li_k = li_k + 1
            END IF

            LET li_cnt = li_cnt + 1
         END FOREACH
         CALL g_item_array.deleteElement(li_cnt)

         IF cl_null(g_item_curr_page) OR g_item_curr_page = 0 OR g_flag1 = '0' THEN
            LET g_item_curr_page = 1       # 預設從第一頁開始
         END IF
         IF cl_null(g_item_start_index) OR g_item_start_index = 0 OR g_flag1 = '0' THEN
            LET g_item_start_index = 1     # 預設從第一筆開始
         END IF

         # 紀錄array長度，因為後面可能還會塞空白資料
         LET g_item_array_langth = g_item_array.getLength()

         # 每頁須扣除掉2個元件，作為上下頁功能鍵
         LET g_item_end_index = (g_item_start_index + (g_item_page_count - 2)) - 1

         # 若更新小分類資料，也須一併更新商品細項資料
         CALL i054_get_data("P",li_curr_main_id,li_curr_item_id)
  
      WHEN "P"     # 取得商品細項資料
         CALL g_product_array.clear()
         CALL g_product_form_but.clear()
         LET li_cnt = 1
         LET li_k = 1
         DECLARE product_data_curs CURSOR FOR
           SELECT '','',rzk02,'','',rzk03,'' FROM rzk_file
             WHERE rzk01 = g_rzi.rzi01
               AND rzk04 = li_curr_item_id
               AND rzkacti = 'Y'
             ORDER BY rzk06
         FOREACH product_data_curs INTO g_product_array[li_cnt].*
            SELECT ima02,ima25 INTO g_product_array[li_cnt].product_name,l_ima25
              FROM ima_file
             WHERE ima01 = g_product_array[li_cnt].product_id
            SELECT rtz05 INTO l_rtz05
              FROM rtz_file
             WHERE rtz01 = g_plant
            IF NOT cl_null(l_ima25)  AND NOT cl_null(l_rtz05) THEN
               SELECT (CASE rtg08 WHEN 'Y' THEN COALESCE(rth04,rtg05)
                                 WHEN 'N' THEN rtg05 END)
                 INTO g_product_array[li_cnt].product_price
                 FROM rtg_file
                 LEFT OUTER JOIN rth_file
                   ON (rth01 = rtg01 AND rth02 = rtg04)
                WHERE rtg01 = l_rtz05
                  AND rtg03 = g_product_array[li_cnt].product_id
                  AND rtg04 = l_ima25
            END IF
            LET l_str = "rzk05=",g_product_array[li_cnt].product_id
            CALL i054_get_location(l_str,g_product_array[li_cnt].product_id) RETURNING g_product_array[li_cnt].product_picture
            # 將資料塞到array中，以便之後要做資料update時可以取到button與資料的對應關係
            # 所以g_product_form_but中需預留上下頁的button的筆數
            IF li_k MOD g_product_page_count > 1 THEN
               LET g_product_form_but[li_k].product_but_name = ""
               LET g_product_form_but[li_k].product_main_id = li_curr_main_id
               LET g_product_form_but[li_k].product_item_id = li_curr_item_id
               LET g_product_form_but[li_k].product_id = g_product_array[li_cnt].product_id
               LET li_k = li_k + 1
            END IF

            IF li_k MOD g_product_page_count = g_product_page_count - 1 THEN   # 表示為上一頁
               LET g_product_form_but[li_k].product_but_name = "product_but",li_k USING "&&&"
               LET g_product_form_but[li_k].product_main_id = "P"
               LET g_product_form_but[li_k].product_item_id = "P"
               LET g_product_form_but[li_k].product_id = "P"
               LET li_k = li_k + 1
            END IF

            IF li_k MOD g_product_page_count = 0 THEN   # 表示為下一頁
               LET g_product_form_but[li_k].product_but_name = "product_but",li_k USING "&&&"
               LET g_product_form_but[li_k].product_main_id = "N"
               LET g_product_form_but[li_k].product_item_id = "N"
               LET g_product_form_but[li_k].product_id = "N"
               LET li_k = li_k + 1
            END IF

            LET li_cnt = li_cnt + 1
         END FOREACH
         CALL g_product_array.deleteElement(li_cnt)

         IF cl_null(g_product_curr_page) OR g_product_curr_page = 0 OR g_flag1 = '0' THEN
            LET g_product_curr_page = 1        # 預設從第一筆開始
         END IF
         IF cl_null(g_product_start_index) OR g_product_start_index = 0 OR g_flag1 = '0' THEN
            LET g_product_start_index = 1      # 預設從第一筆開始
         END IF

         # 紀錄array長度，因為後面可能還會塞空白資料
         LET g_product_array_langth = g_product_array.getLength()

         # 每頁須扣除掉2個元件，作為上下頁功能鍵
         LET g_product_end_index = (g_product_start_index + (g_product_page_count - 2)) - 1

   END CASE
END FUNCTION

#动态显示画面ACTION
FUNCTION i054_form(p_kind,p_group,p_start_index,p_end_index)
   DEFINE p_kind          STRING               # 區分是哪一個分類
   DEFINE p_group         STRING               # 紀錄畫面上GROUP元件
   DEFINE p_start_index   LIKE type_file.num5  # 紀錄要從第幾筆資料開始顯示，因為有翻頁功能
   DEFINE p_end_index     LIKE type_file.num5  # 紀錄顯示到第幾筆資料顯示，因為有翻頁功能
   DEFINE l_act_num       LIKE type_file.num5  # 按鈕數量
   DEFINE l_acthidden     STRING               # 隱藏的按鈕,以","分隔
   DEFINE li_cnt          LIKE type_file.num5
   DEFINE li_k            LIKE type_file.num5
   DEFINE ls_name         STRING               # 元件名稱(name)
   DEFINE ls_desc         STRING               # 元件顯示說明(text)
   DEFINE li_x            LIKE type_file.num5  # 元件的x軸位置
   DEFINE li_y            LIKE type_file.num5  # 元件的y軸位置
   DEFINE li_col_now      LIKE type_file.num5  # 紀錄目前是第幾行
   DEFINE li_row_now      LIKE type_file.num5  # 紀錄目前是第幾列
   DEFINE li_num          LIKE type_file.num5  # 紀錄目前是第幾個元件
   DEFINE li_width        LIKE type_file.num5  # 元件寬度
   DEFINE li_height       LIKE type_file.num5  # 元件高度
   DEFINE li_mod_num      LIKE type_file.num5  # 取餘數用
   DEFINE li_j            LIKE type_file.num5
   DEFINE li_first        LIKE type_file.num5

   LET li_x = 0
   LET li_y = 0
   LET li_col_now = 0
   LET li_row_now = 0
   LET li_first = TRUE

   # 動態設定元件
   CASE
      WHEN p_kind = "main"     # 大分類
         LET li_width = 10
         LET li_height = 1

         # 先刪除原先建立的元件
         CALL i054_remove_component(p_group)
         
         FOR li_cnt = p_start_index TO p_end_index
            IF li_first THEN
               # 因為每一頁都有兩個action用來做上下頁
               IF li_cnt > 2 THEN
                  LET li_num = li_cnt + ((g_main_curr_page - 1) * 2)
               ELSE
                  LET li_num = li_cnt
               END IF
               LET li_first = FALSE
            ELSE
               LET li_num = li_num + 1
            END IF
            IF li_cnt = 0 THEN LET li_cnt = 1 END IF
            IF li_num = 0 THEN LET li_num = 1 END IF

            # 設定元件的x軸與y軸位置
            CALL i054_xy(li_num,g_main_col,li_col_now,li_row_now,li_width,li_height)
                 RETURNING li_col_now,li_row_now,li_x,li_y

            # 大分類的上一頁功能要排在第一個元件
            IF li_row_now = 1 AND li_col_now = 1 THEN
               # 設定上一頁
               LET ls_name = "main_but",li_num USING "&&&"
               LET ls_desc = "↑"
               CALL i054_create_button_component(p_group,ls_name,ls_desc,
                                                      li_x,li_y,li_width,li_height)
               LET g_main_form_but[li_num].main_but_name = ls_name
               LET g_main_form_but[li_num].main_id = "P"

               LET li_num = li_num + 1

               # 設定元件的x軸與y軸位置
               CALL i054_xy(li_num,g_main_col,li_col_now,li_row_now,li_width,li_height)
                    RETURNING li_col_now,li_row_now,li_x,li_y
            END IF

            LET ls_name = "main_but",li_num USING "&&&"
            LET ls_desc = g_main_array[li_cnt].main_name
            CALL i054_create_button_component(p_group,ls_name,ls_desc,
                                                   li_x,li_y,li_width,li_height)
            LET g_main_form_but[li_num].main_but_name = ls_name
            LET g_main_form_but[li_num].main_id = g_main_array[li_cnt].main_id

            # 每一頁要留兩個action放置上下頁功能鍵
            IF li_cnt MOD (g_main_page_count - 2) = 0 THEN
               # 設定下一頁
               LET li_num = li_num + 1

               # 設定元件的x軸與y軸位置
               CALL i054_xy(li_num,g_main_col,li_col_now,li_row_now,li_width,li_height)
                    RETURNING li_col_now,li_row_now,li_x,li_y

               LET ls_name = "main_but",li_num USING "&&&"
               LET ls_desc = "↓"
               CALL i054_create_button_component(p_group,ls_name,ls_desc,
                                                      li_x,li_y,li_width,li_height)
               LET g_main_form_but[li_num].main_but_name = ls_name
               LET g_main_form_but[li_num].main_id = "N"

               EXIT FOR
            END IF
         END FOR

      WHEN p_kind = "item"    # 小分類
         LET li_width = 10
         LET li_height = 1

         # 先刪除原先建立的元件
         CALL i054_remove_component(p_group)

         FOR li_cnt = p_start_index TO p_end_index
            IF li_first THEN
               # 因為每一頁都有兩個action用來做上下頁
               IF li_cnt > 2 THEN
                  LET li_num = li_cnt + ((g_item_curr_page - 1) * 2)
               ELSE
                  LET li_num = li_cnt
               END IF
               LET li_first = FALSE
            ELSE
               LET li_num = li_num + 1
            END IF
            IF li_cnt = 0 THEN LET li_cnt = 1 END IF
            IF li_num = 0 THEN LET li_num = 1 END IF

            # 設定元件的x軸與y軸位置
            CALL i054_xy(li_num,g_item_col,li_col_now,li_row_now,li_width,li_height)
                 RETURNING li_col_now,li_row_now,li_x,li_y

            LET ls_name = "item_but",li_num USING "&&&"
            LET ls_desc = g_item_array[li_cnt].item_name
            CALL i054_create_button_component(p_group,ls_name,ls_desc,
                                                   li_x,li_y,li_width,li_height)
            LET g_item_form_but[li_num].item_but_name = ls_name
            LET g_item_form_but[li_num].item_main_id = g_item_array[li_cnt].item_main_id
            LET g_item_form_but[li_num].item_id = g_item_array[li_cnt].item_id

            # 每一頁要留兩個action放置上下頁功能鍵
            IF li_cnt MOD (g_item_page_count - 2) = 0 THEN
               # 設定上一頁
               LET li_num = li_num + 1

               # 設定元件的x軸與y軸位置
               CALL i054_xy(li_num,g_item_col,li_col_now,li_row_now,li_width,li_height)
                    RETURNING li_col_now,li_row_now,li_x,li_y

               LET ls_name = "item_but",li_num USING "&&&"
               LET ls_desc = "←"
               CALL i054_create_button_component(p_group,ls_name,ls_desc,
                                                      li_x,li_y,li_width,li_height)
               LET g_item_form_but[li_num].item_but_name = ls_name
               LET g_item_form_but[li_num].item_main_id = "P"
               LET g_item_form_but[li_num].item_id = "P"

               # 設定下一頁
               LET li_num = li_num + 1

               # 設定元件的x軸與y軸位置
               CALL i054_xy(li_num,g_item_col,li_col_now,li_row_now,li_width,li_height)
                    RETURNING li_col_now,li_row_now,li_x,li_y

               LET ls_name = "item_but",li_num USING "&&&"
               LET ls_desc = "→"
               CALL i054_create_button_component(p_group,ls_name,ls_desc,
                                                      li_x,li_y,li_width,li_height)
               LET g_item_form_but[li_num].item_but_name = ls_name
               LET g_item_form_but[li_num].item_main_id = "N"
               LET g_item_form_but[li_num].item_id = "N"

               EXIT FOR
            END IF
         END FOR

      WHEN p_kind = "product"    # 商品細項
         LET li_width = 10
         LET li_height = 8

         # 先刪除原先建立的元件
         CALL i054_remove_component(p_group)

         FOR li_cnt = p_start_index TO p_end_index  
            IF li_first THEN
               # 因為每一頁都有兩個action用來做上下頁
               IF li_cnt > 2 THEN
                  LET li_num = li_cnt + ((g_product_curr_page - 1) * 2)
               ELSE
                  LET li_num = li_cnt
               END IF
               LET li_first = FALSE
            ELSE
               LET li_num = li_num + 1
            END IF
            IF li_cnt = 0 THEN LET li_cnt = 1 END IF
            IF li_num = 0 THEN LET li_num = 1 END IF
 
            # 設定元件的x軸與y軸位置
            CALL i054_xy(li_num-(g_product_curr_page-1)*2,g_product_col,li_col_now,li_row_now,li_width,li_height)
                 RETURNING li_col_now,li_row_now,li_x,li_y
            CALL i054_create_product_component(p_group,"1",li_num,
                                                    g_product_array[li_cnt].product_name,
                                                    g_product_array[li_cnt].product_picture,
                                                    g_product_array[li_cnt].product_price,
                                                    li_x,li_y,li_width,li_height)

            LET g_product_form_but[li_num].product_but_name = "product_but",li_num USING "&&&"
            LET g_product_form_but[li_num].product_main_id = g_product_array[li_cnt].product_main_id
            LET g_product_form_but[li_num].product_item_id = g_product_array[li_cnt].product_item_id
            LET g_product_form_but[li_num].product_id = g_product_array[li_cnt].product_id

            # 每一頁要留兩個action放置上下頁功能鍵
            IF li_cnt MOD (g_product_page_count - 2) = 0 THEN
               # 設定上一頁
               LET li_num = li_num + 1

               # 設定元件的x軸與y軸位置
               CALL i054_xy(li_num-(g_product_curr_page-1)*2,g_product_col,li_col_now,li_row_now,li_width,li_height)
                    RETURNING li_col_now,li_row_now,li_x,li_y

               LET ls_desc = "←"
               CALL i054_create_product_component(p_group,"2",li_num,
                                                       ls_desc,
                                                       g_product_array[li_cnt].product_picture,
                                                       g_product_array[li_cnt].product_price,
                                                       li_x,li_y,li_width,li_height)

               LET g_product_form_but[li_num].product_but_name = "product_but",li_num USING "&&&"
               LET g_product_form_but[li_num].product_main_id = "P"
               LET g_product_form_but[li_num].product_item_id = "P"
               LET g_product_form_but[li_num].product_id = "P"
               
               # 設定下一頁
               LET li_num = li_num + 1

               # 設定元件的x軸與y軸位置
               CALL i054_xy(li_num-(g_product_curr_page-1)*2,g_product_col,li_col_now,li_row_now,li_width,li_height) 
                    RETURNING li_col_now,li_row_now,li_x,li_y

               LET ls_desc = "→"
               CALL i054_create_product_component(p_group,"2",li_num,
                                                       ls_desc,
                                                       g_product_array[li_cnt].product_picture,
                                                       g_product_array[li_cnt].product_price,
                                                       li_x,li_y,li_width,li_height)

               LET g_product_form_but[li_num].product_but_name = "product_but",li_num USING "&&&"
               LET g_product_form_but[li_num].product_main_id = "N"
               LET g_product_form_but[li_num].product_item_id = "N"
               LET g_product_form_but[li_num].product_id = "N"

               EXIT FOR
            END IF
         END FOR
   END CASE
END FUNCTION

# 設定元件要呈現的X軸與Y軸位置
FUNCTION i054_xy(p_num,p_disp_col,p_col_now,p_row_now,p_width,p_height)
   DEFINE p_num        LIKE type_file.num5   # 紀錄目前是第幾個元件
   DEFINE p_disp_col   LIKE type_file.num5   # 紀錄使用者設定的列數
   DEFINE p_width      LIKE type_file.num5   # 紀錄元件寬度
   DEFINE p_height     LIKE type_file.num5   # 紀錄元件高度
   DEFINE p_col_now    LIKE type_file.num5   # 紀錄目前是第幾行
   DEFINE p_row_now    LIKE type_file.num5   # 紀錄目前是第幾列
   DEFINE p_x          LIKE type_file.num5   # 要回傳的x軸位置
   DEFINE p_y          LIKE type_file.num5   # 要回傳的y軸位置


   IF p_disp_col = 1 THEN                    # 若使用者設定的行數為1，表示每放一個元件就要換列
      LET p_col_now = 1
      LET p_row_now = p_row_now + 1
   ELSE
      IF p_num MOD p_disp_col = 1 THEN       # 表示為新的一行
         LET p_col_now = 0
         LET p_row_now = p_row_now + 1
      END IF
      LET p_col_now = p_col_now + 1
   END IF

   # 先計算出該元件位在這一列的第幾個元件，再乘以元件寬度
   # 若寬度為10，第一個元件應該從第1個位元開始排起，所以第二個元件應該在第11個位元呈現才對
   LET p_x = ((p_col_now - 1) * p_width) + 1

   # 先計算出該元件位在第幾列，再乘以元件高度
   LET p_y = ((p_row_now - 1) * p_height) + 1

   RETURN p_col_now,p_row_now,p_x,p_y
END FUNCTION

# 刪除分類元件
FUNCTION i054_remove_component(lc_group)
   DEFINE lc_kind         STRING                  # 紀錄是哪個分類
   DEFINE lc_group        STRING                  # 畫面上哪一個Group
   DEFINE lwin_curr       ui.Window
   DEFINE lfrm_curr       ui.Form
   DEFINE lnode_group     om.DomNode
   DEFINE llst_items      om.nodeList
   DEFINE lnode_item      om.DomNode
   DEFINE ls_item_name    STRING
   DEFINE ls_parent_tag   STRING
   DEFINE li_k            LIKE type_file.num5


   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_group = lfrm_curr.findNode("Group",lc_group)
   IF lnode_group IS NULL THEN
      MESSAGE "Can't find layout"
      RETURN
   END IF

   LET ls_parent_tag = lnode_group.getTagName()
   LET llst_items = lnode_group.selectByPath("//" || ls_parent_tag || "//*")
   FOR li_k = 1 to llst_items.getLength()
      LET lnode_item = llst_items.item(li_k)
      CALL lnode_group.removeChild(lnode_item)
   END FOR
END FUNCTION

# 建立Button元件
FUNCTION i054_create_button_component(lc_group,lc_name,lc_desc,lc_x,lc_y,lc_width,lc_height)
   DEFINE lc_group        STRING                  # 畫面上哪一個Group
   DEFINE lc_name         STRING                  # 元件名稱(name)
   DEFINE lc_desc         STRING                  # 元件顯示說明(text)
   DEFINE lc_x            LIKE type_file.num5     # 元件的x軸
   DEFINE lc_y            LIKE type_file.num5     # 元件的y軸
   DEFINE lc_width        LIKE type_file.num5     # 元件寬度
   DEFINE lc_height       LIKE type_file.num5     # 元件高度
   DEFINE lwin_curr       ui.Window
   DEFINE lfrm_curr       ui.Form
   DEFINE lnode_group     om.DomNode
   DEFINE lnode_button    om.DomNode
   DEFINE lnode_replace   om.DomNode
   DEFINE lnode_old       om.DomNode
   DEFINE lc_but_name     STRING
   DEFINE lc_mod_num      LIKE type_file.num5


   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_group = lfrm_curr.findNode("Group",lc_group)
   IF lnode_group IS NULL THEN
      MESSAGE "Can't find layout"
      RETURN
   END IF

   LET lnode_button = lnode_group.createChild("Button")
   CALL lnode_button.setAttribute("name",lc_name)
   CALL lnode_button.setAttribute("text",lc_desc)
   CALL lnode_button.setAttribute("comment",lc_desc)
   CALL lnode_button.setAttribute("posX",lc_x)
   CALL lnode_button.setAttribute("posY",lc_y)
   CALL lnode_button.setAttribute("gridWidth",lc_width)
   CALL lnode_button.setAttribute("gridHeight",lc_height)
END FUNCTION

# 建立商品細項元件
FUNCTION i054_create_product_component(lc_group,lc_type,lc_num,lc_desc,lc_picture,lc_price,lc_x,lc_y,lc_width,lc_height)
   DEFINE lc_group        STRING                  # 畫面上哪一個Group
   DEFINE lc_type         LIKE type_file.chr1     # 1表示建立完整商品細項元件，2表示建立上下頁功能鍵
   DEFINE lc_num          LIKE type_file.num5     # 元件個數
   DEFINE lc_name         STRING                  # 元件名稱(name)
   DEFINE lc_desc         STRING                  # 元件顯示說明(text)
   DEFINE lc_picture      STRING                  # 商品圖片
   DEFINE lc_price        LIKE type_file.num5     # 商品價格
   DEFINE lc_x            LIKE type_file.num5     # 元件的x軸
   DEFINE lc_y            LIKE type_file.num5     # 元件的y軸
   DEFINE lc_width        LIKE type_file.num5     # 元件寬度
   DEFINE lc_height       LIKE type_file.num5     # 元件高度
   DEFINE lwin_curr       ui.Window
   DEFINE lfrm_curr       ui.Form
   DEFINE lnode_group     om.DomNode
   DEFINE lnode_group_2   om.DomNode
   DEFINE lnode_button    om.DomNode
   DEFINE lnode_grid      om.DomNode
   DEFINE lnode_label_1   om.DomNode
   DEFINE lnode_label_2   om.DomNode
   DEFINE lnode_vbox      om.DomNode
   DEFINE lnode_hbox      om.DomNode
   DEFINE lnode_img       om.DomNode    #FUN-D20081 Mark

   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_group = lfrm_curr.findNode("Group",lc_group)
   IF lnode_group IS NULL THEN
      MESSAGE "Can't find layout"
      RETURN
   END IF

   IF lc_type = "1" THEN    # 建立商品細項元件
      # 商品細項包含商品名稱、商品圖片、商品價格，
      # 因此須以group包含以上三個元件

      # 建立Group     # 因為想要以框線區別產品資訊，所以這邊用group，而不用grid
      LET lnode_group_2 = lnode_group.createChild("Group")
      LET lc_name = "product_group2_",lc_num USING "&&&"  #元件名稱 ex:"product_group2_001"
      CALL lnode_group_2.setAttribute("name",lc_name)
      CALL lnode_group_2.setAttribute("posX",lc_x)
      CALL lnode_group_2.setAttribute("posY",lc_y)
      CALL lnode_group_2.setAttribute("gridWidth",lc_width)
      CALL lnode_group_2.setAttribute("gridHeight",lc_height)

      #FUN-D20081 Mark Str
      # 建立Label
      #LET lnode_label_1 = lnode_group_2.createChild("Label")  
      #LET lc_name = "product_lab1_",lc_num USING "&&&"  #元件名稱 ex:"product_lab1_001"
      #CALL lnode_label_1.setAttribute("name",lc_name)
      #CALL lnode_label_1.setAttribute("text",lc_desc)
      #CALL lnode_label_1.setAttribute("comment",lc_desc)
      #CALL lnode_label_1.setAttribute("posX",1)
      #CALL lnode_label_1.setAttribute("posY",1)
      #CALL lnode_label_1.setAttribute("gridWidth",10)
      #CALL lnode_label_1.setAttribute("gridHeight",1)
      # 建立圖片
      #LET lnode_button = lnode_group_2.createChild("Button") 
      #LET lc_name = "product_but",lc_num USING "&&&"      #元件名稱 ex:"product_but001"
      #CALL lnode_button.setAttribute("autoScale",1)         
      #CALL lnode_button.setAttribute("stretch",'')         
      #CALL lnode_button.setAttribute("name",lc_name)     
      #CALL lnode_button.setAttribute("image",lc_picture)
      #CALL lnode_button.setAttribute("sizePolicy","fixed") #fixed,dynamic,initial
      #CALL lnode_button.setAttribute("comment",lc_desc)
      #CALL lnode_button.setAttribute("posX",1)
      #CALL lnode_button.setAttribute("posY",2)
      #CALL lnode_button.setAttribute("gridWidth",10)
      #CALL lnode_button.setAttribute("gridHeight",6)
      #FUN-D20081 Mark End


      #FUN-D20081 Add Str
      # 建立Buttton
      LET lnode_button = lnode_group_2.createChild("Button") 
      LET lc_name = "product_but",lc_num USING "&&&" 
      CALL lnode_button.setAttribute("name",lc_name)
      CALL lnode_button.setAttribute("text",lc_desc)
      CALL lnode_button.setAttribute("sizePolicy","fixed") #fixed,dynamic,initial
      CALL lnode_button.setAttribute("comment",lc_desc)
      CALL lnode_button.setAttribute("posX",1)
      CALL lnode_button.setAttribute("posY",1)
      CALL lnode_button.setAttribute("gridWidth",10)
      CALL lnode_button.setAttribute("gridHeight",1)

      # 建立圖片
      LET lnode_img = lnode_group_2.createChild("Image")
      LET lc_name = "product_img",lc_num USING "&&&" 
      CALL lnode_img.setAttribute("name",lc_name)
      CALL lnode_img.setAttribute("image",lc_picture)
      CALL lnode_img.setAttribute("sizePolicy","fixed") #fixed,dynamic,initial
      CALL lnode_img.setAttribute("comment",lc_desc)
      CALL lnode_img.setAttribute("posX",1)
      CALL lnode_img.setAttribute("posY",2)
      CALL lnode_img.setAttribute("gridWidth",10)
      CALL lnode_img.setAttribute("gridHeight",6)
      CALL lnode_img.setAttribute("autoScale",1)
      CALL lnode_img.setAttribute("stretch",'')
      #FUN-D20081 Add End

      # 建立Label
      LET lnode_label_2 = lnode_group_2.createChild("Label")
      LET lc_name = "product_lab2_",lc_num USING "&&&"  #元件名稱 ex:"product_lab2_001"
      CALL lnode_label_2.setAttribute("name",lc_name)
      CALL lnode_label_2.setAttribute("text",lc_price)
      CALL lnode_label_2.setAttribute("comment",lc_price)
      CALL lnode_label_2.setAttribute("posX",1)
      CALL lnode_label_2.setAttribute("posY",8)
      CALL lnode_label_2.setAttribute("gridWidth",10)
      CALL lnode_label_2.setAttribute("gridHeight",1)
   ELSE
      # 建立上下頁功能鍵
      LET lnode_button = lnode_group.createChild("Button")
      LET lc_name = "product_but",lc_num USING "&&&"      #元件名稱 ex:"product_but001"
      CALL lnode_button.setAttribute("name",lc_name)     
      CALL lnode_button.setAttribute("text",lc_desc)
      CALL lnode_button.setAttribute("comment",lc_desc)
      CALL lnode_button.setAttribute("posX",lc_x)
      CALL lnode_button.setAttribute("posY",lc_y+7)
      CALL lnode_button.setAttribute("gridWidth",10)
      CALL lnode_button.setAttribute("gridHeight",1)
   END IF

END FUNCTION


#按下大分類按鈕
FUNCTION i054_main_act(p_button)
   DEFINE p_button        LIKE type_file.num5   #按下第6個按鈕，則p_button = 6
   DEFINE p_mod_cnt       LIKE type_file.num5   #紀錄取得的餘數
   DEFINE li_array_num    LIKE type_file.num5
   DEFINE li_k            LIKE type_file.num5
   DEFINE li_start        LIKE type_file.num5

   LET g_flag = '1'
   LET g_button2 = 1
   LET g_button3 = 1
   LET g_curr_act_old = g_curr_act
   LET g_curr_act = "main_but",p_button USING "&&&"   # 紀錄目前按下哪一個按鈕
   LET p_mod_cnt = p_button MOD g_main_page_count     # 紀錄目前的action在畫面上的位置

   # 大分類的上一頁action固定放在第一個元件
   # 所以若取餘數為1的話，表示是這一頁的第一個元件
   IF p_mod_cnt = 1 THEN

      IF p_button = 1 THEN
         LET g_button1 = 1
         LET g_curr_act = "main_but002"
      ELSE
         LET g_button1 = p_button - (g_main_page_count - 2) - ((g_main_curr_page-1)*2)
         LET g_curr_act = "main_but",p_button-g_main_page_count+1  USING "&&&"
      END IF
      # 起始位置位在第二頁以後的，按上一頁才有作用
      IF g_main_curr_page > 1 THEN    # 目前所在頁數在第二頁以後的
         LET g_main_curr_page = g_main_curr_page - 1
         # 重新布置大分類的元件
         LET g_main_start_index = g_main_start_index - (g_main_page_count - 2)
         LET g_main_end_index = g_main_start_index + ((g_main_page_count - 2) - 1)
         CALL i054_form("main","main_group",g_main_start_index,g_main_end_index)
      END IF
   END IF

   # 大分類的下一頁action固定放在最後一個元件
   # 所以若取餘數為0的話，表示是這一頁的最後一個元件
   IF p_mod_cnt = 0 THEN
      # 資料總筆數大於目前筆數，按下一頁才有作用
      #IF (g_main_array_langth - (g_main_page_count - 2)) >  0 THEN
      #IF (g_main_array_langth + (g_main_page_count - 2)) > g_main_end_index THEN
      #IF g_main_curr_page < g_main_array_langth/(g_main_page_count - 2) THEN
      #IF NOT cl_null(g_main_array[p_button - (g_main_curr_page*2 - 1)+1].main_id) THEN
      IF  g_main_curr_page*(g_main_page_count-2)-1 < g_main_array_langth THEN
         LET g_button1 = p_button - (g_main_curr_page*2 - 1)
         LET g_curr_act = "main_but",p_button+2  USING "&&&"
         LET g_main_curr_page = g_main_curr_page + 1
         # 重新布置大分類的元件
         LET g_main_start_index = g_main_start_index + (g_main_page_count - 2)
         LET g_main_end_index = g_main_start_index + ((g_main_page_count - 2) - 1)
         CALL i054_form("main","main_group",g_main_start_index,g_main_end_index)
      ELSE
         LET g_button1 = (g_main_curr_page-1)*g_main_page_count+1
         LET g_curr_act = "main_but",p_button-(g_main_page_count-2) USING "&&&"
      END IF
   END IF

   # 當按下大分類中非上下頁的按鈕
   # 若餘數為0表示最後一個元件，在此為下一頁，若餘數為1表示第一個元件，在此為上一頁
   IF p_mod_cnt > 1 THEN
      LET g_button1 = p_button - (g_main_curr_page*2 - 1)
      # 判斷是否為最後一頁，因為只有最後一頁才會佈署空白元件
      IF g_main_end_index > g_main_array_langth THEN

         # 判斷是否按下空白元件
         # 若元件在畫面上的位置 > array資料總筆數取得的餘數+1 (會+1是因為每頁的第一個元件是放上一頁)
         # 表示按下的是空白元件
         IF p_mod_cnt > ((g_main_array_langth MOD (g_main_page_count - 2)) + 1) THEN
            LET g_item_curr_page = 1
            CALL i054_get_data("I",g_main_array[g_button1].main_id,"")
         ELSE
            # 按下非空白元件的按鈕，應該帶出相關的小分類資料
            # 判斷要取的是array中第幾筆資料
            # (目前的頁數 -1) * (畫面上能布置的個數(須扣除下上頁功能鍵)) + 畫面位置 -1
            LET li_array_num = ((g_main_curr_page - 1) * (g_main_page_count - 2)) + p_mod_cnt - 1
            LET g_item_curr_page = 1
            CALL i054_get_data("I",g_main_array[li_array_num].main_id,"")

            # 重新布置小分類的元件
            LET g_item_start_index = 1
            LET g_item_end_index = g_item_start_index + ((g_item_page_count - 2) - 1)
            CALL i054_form("item","item_group",g_item_start_index,g_item_end_index)

            # 重新布置商品細項的元件
            LET g_product_start_index = 1
            LET g_product_end_index = g_product_start_index + ((g_product_page_count - 2) - 1)
            CALL i054_form("product","product_group",g_product_start_index,g_product_end_index)

         END IF
      ELSE
         # 按下非空白元件的按鈕，應該帶出相關的小分類資料
         # 判斷要取的是array中第幾筆資料
         # (目前的頁數 -1) * (畫面上能布置的個數(須扣除下上頁功能鍵)) + 畫面位置 -1
         LET li_array_num = ((g_main_curr_page - 1) * (g_main_page_count - 2)) + p_mod_cnt - 1
         LET g_item_curr_page = 1
         CALL i054_get_data("I",g_main_array[li_array_num].main_id,"")

         # 重新布置小分類的元件
         LET g_item_start_index = 1
         LET g_item_end_index = g_item_start_index + ((g_item_page_count - 2) - 1)
         CALL i054_form("item","item_group",g_item_start_index,g_item_end_index)

         # 重新布置商品細項的元件
         LET g_product_start_index = 1
         LET g_product_end_index = g_product_start_index + ((g_product_page_count - 2) - 1)
         CALL i054_form("product","product_group",g_product_start_index,g_product_end_index)
      END IF
   END IF
   LET g_but1 = g_curr_act
   LET g_but2 = "item_but001"
   LET g_but3 = "product_but001"
   LET g_item_curr_page = 1
   LET g_item_start_index = 1
   CALL i054_get_data("I",g_main_array[g_button1].main_id,"")
   CALL i054_form("item","item_group",g_item_start_index,g_item_end_index)
   CALL i054_form("product","product_group",g_product_start_index,g_product_end_index)
   CALL i054_change_style("M")
   CALL i054_display_row()
END FUNCTION

#按下小分類按鈕
FUNCTION i054_item_act(p_button)
   DEFINE p_button        LIKE type_file.num5   #按下第6個按鈕，則p_button = 6
   DEFINE p_mod_cnt       LIKE type_file.num5   #紀錄取得的餘數
   DEFINE li_array_num    LIKE type_file.num5
   DEFINE li_k            LIKE type_file.num5
   DEFINE li_start        LIKE type_file.num5

   LET g_flag = '2'
   LET g_button3 = 1
   LET g_curr_act_old = g_curr_act
   LET g_curr_act = "item_but",p_button USING "&&&"   # 紀錄目前按下哪一個按鈕
   LET p_mod_cnt = p_button MOD g_item_page_count     # 紀錄目前的action在畫面上的位置

   # 小分類的上一頁action固定放在倒數第二個元件
   # 所以若取餘數 = (畫面行*列總個數 - 1) 的話，表示是這一頁的倒數第二個元件
   IF p_mod_cnt = g_item_page_count - 1  THEN
      IF g_item_curr_page = 1 OR g_item_curr_page = 2 THEN
         LET g_button2 = 1
         LET g_curr_act = "item_but001"
      ELSE
         LET g_button2 = p_button - (g_item_page_count + g_item_curr_page*2)
         LET g_curr_act = "item_but",p_button-(g_item_page_count*2-2)  USING "&&&"
      END IF
      # 起始位置位在第二頁以後的，按上一頁才有作用
      IF g_item_curr_page > 1 THEN
         LET g_item_curr_page = g_item_curr_page - 1

         # 重新布置小分類的元件
         LET g_item_start_index = g_item_start_index - (g_item_page_count - 2)
         LET g_item_end_index = g_item_start_index + ((g_item_page_count - 2) - 1)
         CALL i054_form("item","item_group",g_item_start_index,g_item_end_index)
      END IF
   END IF

   # 小分類的下一頁action固定放在最後一個元件
   # 所以若取餘數為0的話，表示是這一頁的最後一個元件
   IF p_mod_cnt = 0 THEN
      # 資料總筆數大於目前筆數，按下一頁才有作用
      IF g_item_curr_page*(g_item_page_count - 2) - 1 < g_item_array_langth THEN
         LET g_button2 = p_button - (g_item_curr_page*2 - 1)
         LET g_curr_act = "item_but",p_button+1  USING "&&&"
         LET g_item_curr_page = g_item_curr_page + 1
         # 重新布置小分類的元件
         LET g_item_start_index = g_item_start_index + (g_item_page_count - 2)
         LET g_item_end_index = (g_item_start_index + (g_item_page_count - 2) - 1)
         CALL i054_form("item","item_group",g_item_start_index,g_item_end_index)
      ELSE
         LET g_button2 = (g_item_curr_page-1)*g_item_page_count+1
         LET g_curr_act = "item_but",g_button2 USING "&&&"
      END IF
   END IF

   # 當按下小分類中非上下頁的按鈕
   # 若餘數為0表示最後一個元件，在此為下一頁，若餘數為(畫面個數-1)表示是倒數第二個元件，在此為上一頁
   IF p_mod_cnt <> 0 AND p_mod_cnt <> (g_item_page_count - 1) THEN
      LET g_button2 = p_button - (g_item_curr_page-1)*2
      # 判斷是否為最後一頁，因為只有最後一頁才會佈署空白元件
      IF g_item_end_index > g_item_array_langth THEN

         # 判斷是否按下空白元件
         # 若元件在畫面上的位置 > array資料總筆數取得的餘數，表示按下的是空白元件
         IF p_mod_cnt <= (g_item_array_langth MOD (g_item_page_count - 2)) THEN
            # 按下非空白元件的按鈕，應該帶出相關的商品細項資料
            # 判斷要取的是array中第幾筆資料
            # 先算出按下的按鈕在畫面上的位置
            # (目前的頁數 -1) * (畫面上能布置的個數(須扣除下上頁功能鍵)) + 畫面位置
            LET li_array_num = ((g_item_curr_page - 1) * (g_item_page_count - 2)) + p_mod_cnt
            LET g_product_curr_page = 1
            CALL i054_get_data("P",g_item_array[li_array_num].item_main_id,g_item_array[li_array_num].item_id)

            # 重新布置商品細項的元件
            LET g_product_start_index = 1
            LET g_product_end_index = g_product_start_index + ((g_product_page_count - 2) - 1)
            CALL i054_form("product","product_group",g_product_start_index,g_product_end_index)
         END IF
     ELSE
         # 按下非空白元件的按鈕，應該帶出相關的小分類資料
         # 判斷要取的是array中第幾筆資料
         # (目前的頁數 -1) * (畫面上能布置的個數(須扣除下上頁功能鍵)) + 畫面位置
         LET li_array_num = ((g_item_curr_page - 1) * (g_item_page_count - 2)) + p_mod_cnt
         LET g_product_curr_page = 1
         CALL i054_get_data("P",g_item_array[li_array_num].item_main_id,g_item_array[li_array_num].item_id)

         # 重新布置商品細項的元件
         LET g_product_start_index = 1
         LET g_product_end_index = g_product_start_index + ((g_product_page_count - 2) - 1)
         CALL i054_form("product","product_group",g_product_start_index,g_product_end_index)
      END IF
   END IF
   LET g_but2 = g_curr_act
   LET g_but3 = "product_but001"
   LET g_product_curr_page = 1
   LET g_product_start_index = 1
   CALL i054_get_data("P",g_item_array[g_button2].item_main_id,g_item_array[g_button2].item_id)
   CALL i054_form("product","product_group",g_product_start_index,g_product_end_index)
   CALL i054_change_style("I")
   CALL i054_display_row()
END FUNCTION

#按下產生商品細項按鈕
FUNCTION i054_product_act(p_button)
   DEFINE p_button        LIKE type_file.num5   #按下第6個按鈕，則p_button = 6
   DEFINE p_mod_cnt       LIKE type_file.num5   #紀錄取得的餘數
   DEFINE li_array_num    LIKE type_file.num5
   DEFINE li_k            LIKE type_file.num5
   DEFINE li_start        LIKE type_file.num5

   LET g_flag = '3'
   LET g_curr_act_old = g_curr_act
   LET g_curr_act = "product_but",p_button USING "&&&"   # 紀錄目前按下哪一個按鈕
   LET p_mod_cnt = p_button MOD g_product_page_count     # 紀錄目前的action在畫面上的位置

   # 商品細項的上一頁action固定放在倒數第二個元件
   # 所以若取餘數 = (畫面行*列總個數 - 1)，表示是這一頁的倒數第二個元件
   IF p_button MOD g_product_page_count = g_product_page_count - 1 THEN
      IF g_product_curr_page = 1 OR g_product_curr_page = 2 THEN
         LET g_button3 = 1
         LET g_curr_act = "product_but001"
      ELSE
         LET g_button3 = p_button - (g_product_page_count + g_product_curr_page*2)
         LET g_curr_act = "product_but",p_button-(g_product_page_count*2-2) USING "&&&"
      END IF
      # 起始位置位在第二頁以後的，按上一頁才有作用
      IF g_product_curr_page > 1 THEN
         LET g_product_curr_page = g_product_curr_page - 1
         # 重新布置商品細項的元件
         LET g_product_start_index = g_product_start_index - (g_product_page_count - 2)
         LET g_product_end_index = (g_product_start_index + (g_product_page_count - 2) - 1)
         CALL i054_form("product","product_group",g_product_start_index,g_product_end_index)
      END IF
   END IF

   # 商品細項的下一頁action固定放在最後一個元件
   # 所以若取餘數為0的話，表示是這一頁的最後一個元件
   IF p_button MOD g_product_page_count = 0 THEN
      # 資料總筆數大於目前筆數，按下一頁才有作用
      IF g_product_curr_page*(g_product_page_count - 2) - 1 < g_product_array_langth THEN
         LET g_button3 = p_button - (g_product_curr_page*2 - 1)
         LET g_curr_act = "product_but",p_button+1 USING "&&&"
         LET g_product_curr_page = g_product_curr_page + 1
         # 重新布置商品細項的元件
         LET g_product_start_index = g_product_start_index + (g_product_page_count - 2)
         LET g_product_end_index = g_product_start_index + ((g_product_page_count - 2) - 1)
         CALL i054_form("product","product_group",g_product_start_index,g_product_end_index)
      ELSE
         LET g_button3 = (g_product_curr_page-1)*g_product_page_count+1
         LET g_curr_act = "product_but",g_button3 USING "&&&"
      END IF
   END IF

   # 當按下商品細項中非上下頁的按鈕
   # 若餘數為0表示最後一個元件，在此為下一頁，若餘數為(畫面個數-1)表示是倒數第二個元件，在此為上一頁
   IF p_mod_cnt <> 0 AND p_mod_cnt <> (g_product_page_count - 1) THEN
      LET g_button3 = p_button - (g_product_curr_page-1)*2
   END IF
   LET g_but3 = g_curr_act
   CALL i054_change_style("P")
   CALL i054_display_row()
END FUNCTION

#显示单身大类、小类、产品的笔数
FUNCTION i054_display_row()
   SELECT COUNT(*) INTO g_rec_b1
     FROM rzj_file
    WHERE rzj01 = g_rzi.rzi01
      AND rzj02 = '1'
   SELECT COUNT(*) INTO g_rec_b2
     FROM rzj_file
    WHERE rzj01 = g_rzi.rzi01
      AND rzj02 = '2'
      AND rzj05 = g_main_array[g_button1].main_id
   SELECT COUNT(*) INTO g_rec_b3
     FROM rzk_file
    WHERE rzk01 = g_rzi.rzi01
      AND rzk04 = g_item_array[g_button2].item_id
   DISPLAY g_rec_b1 TO FORMONLY.cn1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   DISPLAY g_rec_b3 TO FORMONLY.cn3
END FUNCTION
# 調整元件style
FUNCTION i054_change_style(lc_type)
   DEFINE lc_type         LIKE type_file.chr1     # M:点击大类 I:点击小类 P:点击产品 R:清空
   DEFINE lc_kind         STRING                  # 紀錄是哪個分類
   DEFINE lc_node         STRING                  # 畫面上哪一個元件
   DEFINE lc_node_name    STRING                  # 畫面元件名稱
   DEFINE lc_node_name1   STRING                  # 畫面元件名稱
   DEFINE lc_node_name2   STRING                  # 畫面元件名稱
   DEFINE lwin_curr       ui.Window
   DEFINE lfrm_curr       ui.Form
   DEFINE lnode_node      om.DomNode
   DEFINE lnode_node1     om.DomNode
   DEFINE lnode_node2     om.DomNode
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_button1       LIKE type_file.num5    #大类的第几個按鈕
   DEFINE l_button2       LIKE type_file.num5    #小类的第几個按鈕
   DEFINE l_button3       LIKE type_file.num5    #产品的第几個按鈕

   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()

   LET lc_node = "Button"
   FOR l_n = 1 TO g_rzi.rzi03*g_rzi.rzi04*g_main_curr_page
       LET lc_node_name = "main_but",l_n USING "&&&"
       LET lnode_node = lfrm_curr.findNode(lc_node,lc_node_name)
       CALL lnode_node.setAttribute("style","")
   END FOR
   FOR l_n = 1 TO g_rzi.rzi05*g_rzi.rzi06*g_item_curr_page
       LET lc_node_name1 = "item_but",l_n USING "&&&"
       LET lnode_node1 = lfrm_curr.findNode(lc_node,lc_node_name1)
       CALL lnode_node1.setAttribute("style","")
   END FOR
   FOR l_n = 1 TO g_rzi.rzi07*g_rzi.rzi08*g_product_curr_page
       LET lc_node_name2 = "product_but",l_n USING "&&&"
       LET lnode_node2 = lfrm_curr.findNode(lc_node,lc_node_name2)
       CALL lnode_node2.setAttribute("style","")
   END FOR
   
   IF lc_type = "M" THEN
      LET lc_node_name = g_curr_act
      LET lc_node_name1 = "item_but001"
      LET lc_node_name2 = "product_but001"
      LET lnode_node = lfrm_curr.findNode(lc_node,lc_node_name)
      LET lnode_node1 = lfrm_curr.findNode(lc_node,lc_node_name1)
      LET lnode_node2 = lfrm_curr.findNode(lc_node,lc_node_name2)
   END IF
   IF lc_type = "I" THEN
      LET lc_node_name = g_curr_act
      LET lc_node_name1 = g_but1
      LET lc_node_name2 = "product_but001"
      LET lnode_node = lfrm_curr.findNode(lc_node,lc_node_name)
      LET lnode_node1 = lfrm_curr.findNode(lc_node,lc_node_name1)
      LET lnode_node2 = lfrm_curr.findNode(lc_node,lc_node_name2)
   END IF
   IF lc_type = "P" THEN
      LET lc_node_name = g_curr_act
      LET lc_node_name1 = g_but1
      LET lc_node_name2 = g_but2
      LET lnode_node = lfrm_curr.findNode(lc_node,lc_node_name)
      LET lnode_node1 = lfrm_curr.findNode(lc_node,lc_node_name1)
      LET lnode_node2 = lfrm_curr.findNode(lc_node,lc_node_name2)
   END IF
   IF lc_type <> "R" THEN
      CALL lnode_node.setAttribute("style","bgcolor_red")
      CALL lnode_node1.setAttribute("style","bgcolor_yellow")
      CALL lnode_node2.setAttribute("style","bgcolor_yellow")
   END IF

END FUNCTION

#获取图片
FUNCTION i054_get_location(p_value,p_rzk02)
DEFINE p_value       LIKE type_file.chr100
DEFINE p_rzk02       LIKE rzk_file.rzk02
DEFINE l_rzk05       LIKE rzk_file.rzk05
DEFINE gs_tempdir    STRING
DEFINE gs_fglasip    STRING
DEFINE gs_location   STRING
DEFINE gr_gca        RECORD LIKE gca_file.*
DEFINE gr_gcb        RECORD LIKE gcb_file.*
DEFINE lst_tok       base.StringTokenizer
DEFINE ls_name       STRING
DEFINE ls_token      STRING
DEFINE ls_fname      STRING
DEFINE lch_pipe      base.Channel
DEFINE ls_buf        STRING

  LET gs_tempdir = FGL_GETENV("TEMPDIR")
  LET gs_fglasip = FGL_GETENV("FGLASIP")

  LET ls_name = p_value CLIPPED, ".png"
  LET ls_fname = gs_tempdir, "/", ls_name
  LOCATE l_rzk05 IN FILE ls_fname
  SELECT rzk05 INTO l_rzk05 FROM rzk_file
   WHERE rzk01 = g_rzi.rzi01
     AND rzk02 = p_rzk02 
  IF SQLCA.SQLCODE THEN
     RUN "rm -f " || ls_fname
     CALL cl_err3("sel","rzk_file",g_rzi.rzi01,p_rzk02,SQLCA.sqlcode,"","select rzk05:",0)
     RETURN FALSE
  ELSE
     LET lch_pipe = base.Channel.create()
     CALL lch_pipe.openPipe("ls -al " || ls_fname, "r")
     WHILE lch_pipe.read(ls_buf)
     END WHILE
     IF NOT ( ( ls_buf.subString(2, 3) = "rw" ) AND
              ( ls_buf.subString(5, 6) = "rw" ) AND
              ( ls_buf.subString(8, 9) = "rw" ) ) THEN
        RUN "chmod 666 " || ls_fname
     END IF
     CALL lch_pipe.close()
     LET gs_location = gs_fglasip, "/tiptop/out/", ls_name
  END IF

  RETURN gs_location
END FUNCTION

#清空单身数据预设画面ACTION数量和位置
FUNCTION i054_b_clear()

   CALL i054_get_data("M","","") #清空单身资料
   #抓取POS基础参数设置
   #预设大类10行1列，小类2行10列，产品3行4列
   SELECT rzc05 INTO g_main_col FROM rzc_file WHERE rzc01 = 'BClass_Line'
   SELECT rzc05 INTO g_main_row FROM rzc_file WHERE rzc01 = 'BClass_Row'
   SELECT rzc05 INTO g_item_col FROM rzc_file WHERE rzc01 = 'SClass_Line'
   SELECT rzc05 INTO g_item_row FROM rzc_file WHERE rzc01 = 'SClass_Row'
   SELECT rzc05 INTO g_product_col FROM rzc_file WHERE rzc01 = 'Goods_Line'
   SELECT rzc05 INTO g_product_row FROM rzc_file WHERE rzc01 = 'Goods_Row'
   IF cl_null(g_main_col) THEN
      LET g_main_col = 1
   END IF
   IF cl_null(g_main_row) THEN
      LET g_main_row = 10
   END IF
   IF cl_null(g_item_col) THEN
      LET g_item_col = 10
   END IF
   IF cl_null(g_item_row) THEN
      LET g_item_row = 2
   END IF
   IF cl_null(g_product_col) THEN
      LET g_product_col = 4
   END IF
   IF cl_null(g_product_row) THEN
      LET g_product_row = 3
   END IF
   LET g_main_page_count = g_main_col*g_main_row
   LET g_item_page_count = g_item_col*g_item_row
   LET g_product_page_count = g_product_col*g_product_row+2
   # 取得要隱藏起來的action
   CALL i054_get_act_hidden() RETURNING g_act_hidden
   # 依據各分類的資料動態顯示在畫面上
   CALL i054_form("main","main_group",1,g_main_page_count-2)
   CALL i054_form("item","item_group",1,g_item_page_count-2)
   CALL i054_form("product","product_group",1,g_product_page_count-2+2) 
END FUNCTION

#生效范围
FUNCTION i054_eff()
   IF g_rzi.rzi01 IS NULL THEN
      CALL cl_err('',-400,0)
      CALL cl_set_act_visible("true", FALSE)
      RETURN
   END IF
  #FUN-D30093--add--str---
   SELECT rziacti INTO g_rzi.rziacti FROM rzi_file WHERE rzi01 = g_rzi.rzi01
   IF g_rzi.rziacti = 'N' THEN
      CALL cl_err(g_rzi.rzi01,'apc-222',1)
      RETURN
   END IF
  #FUN-D30093--add--end---
   OPEN WINDOW i054_1_w WITH FORM "apc/42f/apci054_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   CALL i054_eff_fill()
   CALL i054_eff_menu()
   CLOSE WINDOW i054_1_w 
END FUNCTION

#生效范围的MENU
FUNCTION i054_eff_menu()
DEFINE l_cmd   LIKE type_file.chr1000 
                                
   WHILE TRUE
      CALL i054_eff_bp("G")
      CASE g_action_choice
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i054_eff_b()  
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

#生效范围bp
FUNCTION i054_eff_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN  #FUN-D30033 add detail
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rzl TO s_rzl.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
         LET INT_FLAG=FALSE
         LET g_action_choice = "exit"
         EXIT  DISPLAY
 
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

#生效范围b 
FUNCTION i054_eff_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否              
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1                 #可刪除否
DEFINE l_pos_str   LIKE type_file.chr1  #FUN-D30075 Add
DEFINE l_rzipos    LIKE rzi_file.rzipos #FUN-D30075 Add
DEFINE l_cmd       LIKE type_file.chr1  #FUN-D30033 add
 
   IF s_shut(0) THEN RETURN END IF
   
   LET g_action_choice = " "   #FUN-D30033 add 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

  #FUN-D30075 Add Begin ---
   IF g_aza.aza88 = 'Y' THEN
      BEGIN WORK
      OPEN i054_cl USING g_rzi.rzi01
      IF STATUS THEN
         CALL cl_err("OPEN i054_cl:",STATUS,1)
         CLOSE i054_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH i054_cl INTO g_rzi.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_rzi.rzi01,SQLCA.sqlcode,1)
         CLOSE i054_cl
         ROLLBACK WORK
         RETURN
      END IF
      LET l_pos_str = 'N'
      LET l_rzipos = g_rzi.rzipos
      UPDATE rzi_file SET rzipos = '4'
       WHERE rzi01 = g_rzi.rzi01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rzi_file",g_rzi.rzi01,"",SQLCA.sqlcode,"","",1)
         RETURN
      END IF
      LET g_rzi.rzipos = '4'
      COMMIT WORK
   END IF
  #FUN-D30075 Add End -----
 
   LET g_forupd_sql = "SELECT rzl02,'',rzlacti ",
                      "  FROM rzl_file WHERE rzl01='",g_rzi.rzi01,"'",
                      "  AND rzl02= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i054_bcl CURSOR FROM g_forupd_sql 
 
   INPUT ARRAY g_rzl WITHOUT DEFAULTS FROM s_rzl.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

         #FUN-D30075 Add Begin ---
          BEGIN WORK
          OPEN i054_cl USING g_rzi.rzi01
          IF STATUS THEN
             CALL cl_err("OPEN i054_cl:",STATUS,1)
             CLOSE i054_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH i054_cl INTO g_rzi.*
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_rzi.rzi01,SQLCA.sqlcode,1)
             CLOSE i054_cl
             ROLLBACK WORK
             RETURN
          END IF
         #FUN-D30075 Add End -----
 
          IF g_rec_b>=l_ac THEN 
            #BEGIN WORK #FUN-D30075 Mark
             LET g_before_input_done = FALSE                                    
             LET g_before_input_done = TRUE                                             
             LET g_rzl_t.* = g_rzl[l_ac].*  #BACKUP
             LET l_cmd = 'u'   #FUN-D30033 add
             OPEN i054_bcl USING g_rzl_t.rzl02
             IF STATUS THEN
                CALL cl_err("OPEN i054_bcl:",STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i054_bcl INTO g_rzl[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_rzl[l_ac].rzl02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   SELECT rtz13 INTO g_rzl[l_ac].rtz13
                     FROM rtz_file
                    WHERE rtz01 = g_rzl[l_ac].rzl02
                   DISPLAY BY NAME g_rzl[l_ac].rtz13
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET g_before_input_done = FALSE                                       
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_rzl[l_ac].* TO NULL   
          LET g_rzl[l_ac].rzlacti = 'Y'  
          LET g_rzl_t.* = g_rzl[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()    
          LET l_cmd = 'a'    #FUN-D30033 add
          NEXT FIELD rzl02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i054_bcl
             CANCEL INSERT
          END IF
          INSERT INTO rzl_file(rzl01,rzl02,rzlacti)   
                        VALUES(g_rzi.rzi01,g_rzl[l_ac].rzl02,g_rzl[l_ac].rzlacti)  
          IF SQLCA.sqlcode THEN   
             CALL cl_err3("ins","rzl_file",g_rzl[l_ac].rzl02,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.bcn2  
             COMMIT WORK
            #FUN-D30075 Add Begin ---
             LET l_pos_str = 'Y'
             IF l_rzipos <> '1' THEN
                LET l_rzipos = '2'
             ELSE
                LET l_rzipos = '1'
             END IF
            #FUN-D30075 Add End -----
          END IF
              
            
       AFTER FIELD rzl02
          IF NOT cl_null(g_rzl[l_ac].rzl02) THEN
             IF g_rzl[l_ac].rzl02 != g_rzl_t.rzl02 OR
                g_rzl_t.rzl02 IS NULL THEN
                LET l_n = 0
                SELECT COUNT(*) INTO l_n
                  FROM rtz_file
                 WHERE rtz01=g_rzl[l_ac].rzl02
                IF l_n = 0 THEN
                   CALL cl_err('','alm-001',1)
                   LET g_rzl[l_ac].rzl02 = g_rzl_t.rzl02
                   NEXT FIELD rzl02
                ELSE
                   LET l_n =0
                   SELECT COUNT(*) INTO l_n
                     FROM rtz_file
                    WHERE rtz01=g_rzl[l_ac].rzl02
                      AND rtz28 = 'Y'
                   IF l_n = 0 THEN
                      CALL cl_err('','alm-903',1)
                      LET g_rzl[l_ac].rzl02 = g_rzl_t.rzl02
                      NEXT FIELD rzl02
                   END IF 
                END IF
                LET l_n = 0
                SELECT COUNT(*) INTO l_n
                  FROM rzl_file
                 WHERE rzl01 = g_rzi.rzi01
                   AND rzl02 = g_rzl[l_ac].rzl02
                IF l_n > 0 THEN
                   CALL cl_err('','-239',1)
                   LET g_rzl[l_ac].rzl02 = g_rzl_t.rzl02
                   NEXT FIELD rzl02
                END IF
               #FUN-D30093--mark--str---
               #LET l_n = 0
               #SELECT COUNT(*) INTO l_n
               #  FROM rzl_file
               # WHERE rzl02 = g_rzl[l_ac].rzl02
               #IF l_n > 0 THEN
               #   CALL cl_err('','apc1069',1)
               #   LET g_rzl[l_ac].rzl02 = g_rzl_t.rzl02
               #   NEXT FIELD rzl02
               #END IF
               #FUN-D30093--mark--end---
               #FUN-D30093--add--str---      #同一門店只能有一個有效的方案
                LET l_n = 0
                SELECT COUNT(*) INTO l_n FROM rzl_file 
                 WHERE rzl02 = g_rzl[l_ac].rzl02
                   AND rzl01 IN (SELECT rzi01 FROM rzi_file WHERE rziacti = 'Y')
                   AND rzlacti = 'Y'
                IF l_n > 0 THEN
                   CALL cl_err(g_rzl[l_ac].rzl02,'apc-223',1)
                   LET g_rzl[l_ac].rzl02 = g_rzl_t.rzl02
                   NEXT FIELD rzl02
                END IF
               #FUN-D30093--add--end---
                LET g_success = 'Y'
                CALL i054_check(g_rzl[l_ac].rzl02,'','')
                IF g_success = 'N' THEN
                   LET g_rzl[l_ac].rzl02 = g_rzl_t.rzl02
                   NEXT FIELD rzl02
                END IF
                SELECT rtz13 INTO g_rzl[l_ac].rtz13
                  FROM rtz_file
                 WHERE rtz01 = g_rzl[l_ac].rzl02
                DISPLAY BY NAME g_rzl[l_ac].rtz13 
             END IF
          ELSE 
             LET g_rzl[l_ac].rtz13=''
             DISPLAY '' TO g_rzl[l_ac].rtz13
          END IF


       AFTER FIELD rzlacti
          IF NOT cl_null(g_rzl[l_ac].rzlacti) THEN
             IF g_rzl[l_ac].rzlacti NOT MATCHES '[YN]' THEN 
                LET g_rzl[l_ac].rzlacti = g_rzl_t.rzlacti
                NEXT FIELD rzlacti
             END IF
            #FUN-D30093--add--str---
             IF g_rzl[l_ac].rzlacti = 'Y' THEN
                LET l_n = 0
                SELECT COUNT(*) INTO l_n FROM rzl_file
                 WHERE rzl02 = g_rzl[l_ac].rzl02
                   AND rzl01 IN (SELECT rzi01 FROM rzi_file WHERE rziacti = 'Y')
                   AND rzlacti = 'Y'
                IF l_n > 0 THEN
                   CALL cl_err(g_rzl[l_ac].rzl02,'apc-223',1)
                   LET g_rzl[l_ac].rzl02 = g_rzl_t.rzl02
                   NEXT FIELD rzlacti
                END IF
             END IF
            #FUN-D30093--add--end---
          END IF
          
       BEFORE DELETE                            #是否取消單身
         #FUN-D30075 Add Begin ---
          IF g_aza.aza88 = 'Y' THEN
             IF NOT ((l_rzipos='3' AND g_rzl_t.rzlacti='N') OR (l_rzipos ='1'))  THEN
                CALL cl_err('','apc-139',0)
                CANCEL DELETE
             END IF
          END IF
         #FUN-D30075 Add End -----
          IF g_rzl_t.rzl02 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM rzl_file
              WHERE rzl01 = g_rzi.rzi01 
                AND rzl02 = g_rzl[l_ac].rzl02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rzl_file",g_rzl[l_ac].rzl02,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.bcn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_rzl[l_ac].* = g_rzl_t.*
             CLOSE i054_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_rzl[l_ac].rzl02,-263,0)
             LET g_rzl[l_ac].* = g_rzl_t.*
          ELSE           
             UPDATE rzl_file SET rzlacti=g_rzl[l_ac].rzlacti
              WHERE rzl01 = g_rzi.rzi01
                AND rzl02 = g_rzl[l_ac].rzl02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","rzl_file",g_rzl[l_ac].rzl02,"",SQLCA.sqlcode,"","",1) 
                LET g_rzl[l_ac].* = g_rzl_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
               #FUN-D30075 Add Begin ---
                LET l_pos_str = 'Y'
                IF l_rzipos <> '1' THEN
                   LET l_rzipos = '2'
                ELSE
                   LET l_rzipos = '1'
                END IF
               #FUN-D30075 Add End -----
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增  #FUN-D30033 mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             #FUN-D30033--add--begin--
             IF l_cmd='u' THEN
                LET g_rzl[l_ac].* = g_rzl_t.*
             ELSE
                CALL g_rzl.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             END IF
             #FUN-D30033--add--end----
             CLOSE i054_bcl            # 新增
             ROLLBACK WORK             # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac   #FUN-D30033 add
          CLOSE i054_bcl               # 新增
          COMMIT WORK
          
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(rzl02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_rtz"
                 LET g_qryparam.default1 = g_rzl[l_ac].rzl02
                 CALL cl_create_qry() RETURNING g_rzl[l_ac].rzl02
                 DISPLAY BY NAME g_rzl[l_ac].rzl02
                 NEXT FIELD rzl02 
           END CASE
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
          
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help() 
   END INPUT
   CLOSE i054_bcl
   COMMIT WORK

  #FUN-D30075 Add Begin ---
   IF g_aza.aza88 = 'Y' THEN
      IF l_pos_str = 'Y' THEN
         IF l_rzipos <> '1' THEN
            LET g_rzi.rzipos = '2'
         ELSE
            LET g_rzi.rzipos = '1'
         END IF 
      ELSE
         LET g_rzi.rzipos = l_rzipos
      END IF
      UPDATE rzi_file SET rzipos = g_rzi.rzipos
       WHERE rzi01 = g_rzi.rzi01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rzi_file",g_rzi.rzi01,"",SQLCA.sqlcode,"","",1)
         RETURN
      END IF
   END IF
  #FUN-D30075 Add Begin ---

   CALL i054_eff_fill()
END FUNCTION

#生效范围资料显示
FUNCTION i054_eff_fill()    
 
    LET g_sql = "SELECT rzl02,'',rzlacti",
                "  FROM rzl_file ",
                " WHERE rzl01='",g_rzi.rzi01,"'",
                " ORDER BY rzl02"
    PREPARE i054_pb FROM g_sql
    DECLARE rzl_curs CURSOR FOR i054_pb
 
    CALL g_rzl.clear()
    LET g_cnt = 1
    FOREACH rzl_curs INTO g_rzl[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH 
        END IF
        SELECT rtz13 INTO g_rzl[g_cnt].rtz13
          FROM rtz_file
         WHERE rtz01 = g_rzl[g_cnt].rzl02
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rzl.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.bcn2  
    LET g_cnt = 0
END FUNCTION

#单身有异动时刷新画面
FUNCTION i054_refresh(p_flag,p_rzj03)
DEFINE p_flag           LIKE type_file.chr1
DEFINE p_rzj03          LIKE rzj_file.rzj03

    IF p_flag = '1' THEN 
      CALL i054_display_row()
      CALL i054_get_data("M",p_rzj03,'')
      CALL i054_form("main","main_group",g_main_start_index,g_main_end_index)
      CALL i054_form("item","item_group",g_item_start_index,g_item_end_index)
      CALL i054_form("product","product_group",g_product_start_index,g_product_end_index)
      CALL i054_change_style("M")
   END IF         
   IF p_flag = '2' THEN
      CALL i054_display_row()
      CALL i054_get_data("I",g_main_array[g_button1].main_id,p_rzj03)
      CALL i054_form("main","main_group",g_main_start_index,g_main_end_index)
      CALL i054_form("item","item_group",g_item_start_index,g_item_end_index)
      CALL i054_form("product","product_group",g_product_start_index,g_product_end_index)
      CALL i054_change_style("I")
   END IF
   IF p_flag = '3' THEN
      CALL i054_display_row()
      CALL i054_get_data("P",g_main_array[g_button1].main_id,g_item_array[g_button2].item_id)
      CALL i054_form("main","main_group",g_main_start_index,g_main_end_index)
      CALL i054_form("item","item_group",g_item_start_index,g_item_end_index)
      CALL i054_form("product","product_group",g_product_start_index,g_product_end_index)
      CALL i054_change_style("P")
   END IF
END FUNCTION

#检查门店对应产品策略价格策略是否有对应产品
#产品是否有条码资料
FUNCTION i054_check(p_rzl02,p_rzk02,p_rzk03)
DEFINE p_rzl02      LIKE rzl_file.rzl02     #门店编号
DEFINE p_rzk02      LIKE rzk_file.rzk02     #产品编号
DEFINE p_rzk03      LIKE rzk_file.rzk03     #产品对应单位
DEFINE l_rzl02      LIKE rzl_file.rzl02
DEFINE l_rtz04      LIKE rtz_file.rtz04
DEFINE l_rtz05      LIKE rtz_file.rtz05
DEFINE l_rzk02      LIKE rzk_file.rzk02
DEFINE l_n          LIKE type_file.num5
DEFINE l_msg        STRING

   CALL s_showmsg_init()
   IF NOT cl_null(p_rzk02) AND NOT cl_null(p_rzk03) THEN    #录入产品
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM rta_file
       WHERE rta01 = p_rzk02
         AND rta03 = p_rzk03
      IF l_n = 0 THEN
         LET g_success = 'N'
         CALL s_errmsg('rta01',p_rzk02,'','apc1066',1)
      ELSE
         LET l_n = 0
         SELECT COUNT(*) INTO l_n
           FROM rta_file
          WHERE rta01 = p_rzk02
            AND rta03 = p_rzk03
            AND rtaacti = 'Y'
         IF l_n = 0 THEN
             LET g_success = 'N'
             CALL s_errmsg('rta01',p_rzk02,'','apc1070',1)
         END IF
      END IF 
      LET g_sql = "SELECT rzl02 FROM rzl_file",
                  " WHERE rzl01 = '",g_rzi.rzi01,"'"
      PREPARE i054_rzl_pb FROM g_sql
      DECLARE i054_rzl_cs CURSOR FOR i054_rzl_pb
      FOREACH i054_rzl_cs INTO l_rzl02
         SELECT rtz04,rtz05 INTO l_rtz04,l_rtz05
           FROM rtz_file
          WHERE rtz01 = l_rzl02
         IF NOT cl_null(l_rtz04) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n
              FROM rte_file
             WHERE rte01 = l_rtz04
               AND rte03 = p_rzk02
            IF l_n = 0 THEN
               LET g_success = 'N'
               LET l_msg = l_rzl02,"/",l_rtz04,"/",p_rzk02
               CALL s_errmsg('rzl02/rtz04/rzk02',l_msg,'','apc1067',1)
            ELSE
               LET l_n = 0
               SELECT COUNT(*) INTO l_n
                 FROM rte_file
                WHERE rte01 = l_rtz04
                  AND rte03 = p_rzk02
                  AND rte07 = 'Y'
               IF l_n = 0 THEN
                  LET g_success = 'N'
                  LET l_msg = l_rzl02,"/",l_rtz04,"/",p_rzk02
                  CALL s_errmsg('rzl02/rtz04/rzk02',l_msg,'','apc1071',1)
               END IF
            END IF
            CONTINUE FOREACH
         END IF
         IF NOT cl_null(l_rtz05) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n
             FROM rtg_file
            WHERE rtg01 = l_rtz05
              AND rtg03 = p_rzk02
            IF l_n = 0 THEN
               LET g_success = 'N'
               LET l_msg = l_rzl02,"/",l_rtz05,"/",p_rzk02
               CALL s_errmsg('rzl02/rtz05/rzk02',l_msg,'','apc1068',1)
            ELSE
               LET l_n = 0
               SELECT COUNT(*) INTO l_n
                 FROM rtg_file
                WHERE rtg01 = l_rtz05
                  AND rtg03 = p_rzk02
                  AND rtg09 = 'Y'
               IF l_n = 0 THEN
                  LET g_success = 'N'
                  LET l_msg = l_rzl02,"/",l_rtz05,"/",p_rzk02
                  CALL s_errmsg('rzl02/rtz05/rzk02',l_msg,'','apc1072',1)
               END IF
            END IF
            CONTINUE FOREACH
         END IF
      END FOREACH
   END IF
   IF NOT cl_null(p_rzl02) THEN      #录入门店
      SELECT rtz04,rtz05 INTO l_rtz04,l_rtz05
        FROM rtz_file
       WHERE rtz01 = p_rzl02
      LET g_sql = "SELECT rzk02 FROM rzk_file",
                  " WHERE rzk01 = '",g_rzi.rzi01,"'",
                  "   AND rzkacti = 'Y'"
      PREPARE i054_rzk_pb FROM g_sql
      DECLARE i054_rzk_cs CURSOR FOR i054_rzk_pb
      FOREACH i054_rzk_cs INTO l_rzk02
         IF NOT cl_null(l_rtz04) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n
              FROM rte_file
             WHERE rte01 = l_rtz04
               AND rte03 = l_rzk02
            IF l_n = 0 THEN
               LET g_success = 'N'
               LET l_msg = p_rzl02,"/",l_rtz04,"/",l_rzk02 
               CALL s_errmsg('rzl02/rtz04/rzk02',l_msg,'','apc1067',1)
            ELSE
               LET l_n = 0
               SELECT COUNT(*) INTO l_n
                 FROM rte_file
                WHERE rte01 = l_rtz04
                  AND rte03 = l_rzk02
                  AND rte07 = 'Y'
               IF l_n = 0 THEN
                  LET g_success = 'N'
                  LET l_msg = p_rzl02,"/",l_rtz04,"/",l_rzk02
                  CALL s_errmsg('rzl02/rtz04/rzk02',l_msg,'','apc1071',1)
               END IF
            END IF
            CONTINUE FOREACH
         END IF
         IF NOT cl_null(l_rtz05) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n
             FROM rtg_file
            WHERE rtg01 = l_rtz05
              AND rtg03 = l_rzk02
            IF l_n = 0 THEN
               LET g_success = 'N'
               LET l_msg = p_rzl02,"/",l_rtz05,"/",l_rzk02
               CALL s_errmsg('rzl02/rtz05/rzk02',l_msg,'','apc1068',1)
            ELSE
               LET l_n = 0
               SELECT COUNT(*) INTO l_n
                FROM rtg_file
               WHERE rtg01 = l_rtz05
                 AND rtg03 = l_rzk02
                 AND rtg09 = 'Y'
               IF l_n = 0 THEN
                  LET g_success = 'N'
                  LET l_msg = p_rzl02,"/",l_rtz05,"/",l_rzk02
                  CALL s_errmsg('rzl02/rtz05/rzk02',l_msg,'','apc1072',1)
               END IF
            END IF
            CONTINUE FOREACH
         END IF
      END FOREACH
   END IF
   CALL s_showmsg()  
END FUNCTION

#开窗数据的删选
FUNCTION i054_sel_oba()
DEFINE l_oba01       LIKE oba_file.oba01
DEFINE l_rzh01       LIKE rzh_file.rzh01
DEFINE l_rcj13       LIKE rcj_file.rcj13
DEFINE l_rcj14       LIKE rcj_file.rcj14
DEFINE l_rcj15       LIKE rcj_file.rcj15
DEFINE l_i           LIKE type_file.num5
DEFINE l_str         STRING

SELECT rcj13,rcj14,rcj15 INTO l_rcj13,l_rcj14,l_rcj15 FROM rcj_file

IF l_rcj15 - l_rcj14 = 1 THEN
   LET l_str = "'",g_main_array[g_button1].main_id,"'"
ELSE
   LET l_str = "'",g_main_array[g_button1].main_id,"'"
  #IF l_rcj13 = '1' THEN                                #FUN-D30093 mark
   IF g_rzi.rzi09 = '1' THEN                            #FUN-D30093 add
      FOR l_i=1 TO l_rcj15 - l_rcj14 -1
         LET g_sql = " SELECT oba01 FROM oba_file",
                     "  WHERE oba13 IN (",l_str,")"
         PREPARE i054_sel_oba_pb FROM g_sql 
         DECLARE i054_sel_oba_cs CURSOR FOR i054_sel_oba_pb
         FOREACH i054_sel_oba_cs INTO l_oba01
            LET l_str = l_str,",'",l_oba01,"'"
         END FOREACH
      END FOR
   END IF
  #IF l_rcj13 = '2' THEN                                #FUN-D30093 mark
   IF g_rzi.rzi09 = '2' THEN                            #FUN-D30093 add 
      FOR l_i=1 TO l_rcj15 - l_rcj14 -1
         LET g_sql = " SELECT rzh01 FROM rzh_file",
                     "  WHERE rzh04 IN (",l_str,")"
         PREPARE i054_sel_rzh_pb FROM g_sql 
         DECLARE i054_sel_rzh_cs CURSOR FOR i054_sel_rzh_pb
         FOREACH i054_sel_rzh_cs INTO l_rzh01
            LET l_str = l_str,",'",l_rzh01,"'"
         END FOREACH
      END FOR
   END IF
END IF
RETURN l_str
END FUNCTION

#FUN-D30006 Add Begin ---
FUNCTION i054_get_oba01_tree(p_cmd,p_oba01)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE p_oba01   LIKE oba_file.oba01
DEFINE l_sql     STRING
DEFINE l_oba01   DYNAMIC ARRAY OF RECORD
       oba01     LIKE oba_file.oba01,
       oba14     LIKE oba_file.oba14
                 END RECORD
DEFINE l_i       LIKE type_file.num5

   IF cl_null(p_oba01) THEN RETURN END IF

   IF p_cmd = '1' THEN
      LET l_sql = "SELECT oba01,oba14 FROM oba_file WHERE oba13 = '",p_oba01 CLIPPED,"' "
   ELSE
      LET l_sql = "SELECT rzh01,rzh05 FROM rzh_file WHERE rzh04 = '",p_oba01 CLIPPED,"' "
   END IF
   LET l_i = 1
   PREPARE sel_oba_pre FROM l_sql
   DECLARE sel_oba_cs CURSOR WITH HOLD FOR sel_oba_pre
   FOREACH sel_oba_cs INTO l_oba01[l_i].*
      LET l_i = l_i + 1
   END FOREACH
   CALL l_oba01.deleteElement(l_i)

   FOR l_i = 1 TO l_oba01.getLength()
      IF l_oba01[l_i].oba14 = '0' THEN
         IF cl_null(g_oba01_tree) THEN
            LET g_oba01_tree = "'",l_oba01[l_i].oba01 CLIPPED,"'"
         ELSE
            LET g_oba01_tree = g_oba01_tree CLIPPED,",'",l_oba01[l_i].oba01 CLIPPED,"'"
         END IF
      END IF

      CALL i054_get_oba01_tree(p_cmd,l_oba01[l_i].oba01)
   END FOR

END FUNCTION
#FUN-D30006 Add End -----
#FUN-D30075 Add Str -----
FUNCTION i054_work()
   IF g_success = 'Y' THEN
      IF g_aza.aza88 = 'Y' THEN
         IF g_rzipos <> '1' THEN
            LET g_rzipos = '2'
         ELSE
            LET g_rzipos = '1'
         END IF
      END IF
   END IF
   IF g_aza.aza88 = 'Y' THEN
      LET g_rzi.rzipos = g_rzipos
      UPDATE rzi_file SET rzipos = g_rzipos
       WHERE rzi01 = g_rzi.rzi01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rzi_file",g_rzi.rzi01,"",SQLCA.sqlcode,"","",1)
      END IF
      DISPLAY BY NAME g_rzi.rzipos
   END IF   
   CLOSE i054_cl
   COMMIT WORK
END FUNCTION
#FUN-D30075 Add End -----
#FUN-D20020
