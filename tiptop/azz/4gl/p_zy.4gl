# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_zy.4gl
# Descriptions...: 執行權限設定作業
# Date & Author..: 91/06/09 LYS
# Modify.........: No.MOD-470041 04/07/20 By Wiky 修改INSERT INTO...
# Modify.........: No.MOD-480245 04/08/10 By Kammy 依 menu 整批產生時組 sql 
#                                p_key 要 clipped
# Modify.........: No.           04/08/19 將zy03顯示改為依照語言別顯示資料
# Modify.........: No.MOD-480464 04/08/23 By Kammy 右邊 ring menu 功能測試修改
# Modify.........: No.MOD-490021 04/09/01 By Wiky 開窗傳值錯誤
# Modify.........: No.MOD-490152 04/09/08 By alex 改變define -> like
# Modify.........: No.MOD-490216 04/09/15 By saki 權限Action不改變語言顯示
# Modify.........: No.MOD-490292 04/09/15 By alex 改變 control-p 部份開窗函式
# Modify.........: No.FUN-4A0083 04/11/08 By alex 增加由 p_zw 串入的功能
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0104 05/01/05 By alex 修改 4js bug 定義超長
# Modify.........: No.FUN-510050 05/02/21 By pengu 報表轉XML
# Modify.........: No.MOD-530169 05/03/21 By alex 調整依程式產生相關作業功能
# Modify.........: No.MOD-540163 05/04/29 By alex 刪除錯誤的 order by 用法
# Modify.........: No.MOD-540026 05/05/02 By alex 新增單身權限維護功能
# Modify.........: No.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-590028 05/09/26 By alex 修整按鍵
# Modify.........: No.MOD-590329 05/10/04 By yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.MOD-560212 05/10/17 By alex 新增判斷此群組是否已失效,失效則不改
# Modify.........: No.TQC-5B0057 05/11/28 By alex 增加列印時因長度限制會切斷允許執行說明
# Modify.........: No.FUN-5C0057 05/12/13 By alex 取消唯護報表權限功能
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/23 By bnlent  新增單頭折疊功能
# Modify.........: No.FUN-660048 07/01/05 By Echo 增加維護Express權限功能的button
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-790092 07/09/17 By rainy 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-880014 08/08/20 By sherry 增加“權限類別維護”action
# Modify.........: No.MOD-970066 09/07/08 By Dido 修改後應更新 zydate,zygrup,zymodu,zyuser
# Modify.........: NO.FUN-970073 09/07/21 By Kevin 把老報表改成p_query
# Modify.........: NO.FUN-950105 09/07/27 By sabrina (1)MENU整批處理要將開窗鈕作出來，並將右邊的action刪除
#                                                    (2)MENU整批刪除時要有詢問視窗在做刪除
#                                                    (3)MENU整批產生要show出重覆的程式代號並做選擇是否要新增
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0145 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-A80004 11/01/13 By tsai_yen 報表:程式基本執行權限表,權限類別允許執行功能表
# Modify.........: No:FUN-B40008 11/04/07 By tsai_yen 有使用者在p_zx或p_zxw使用到權限時,不可刪除此p_zy
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:CHI-C80029 12/08/28 By Elise 移除zz18/zz19,zy04/zy05給預設值0
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_zy01         LIKE zy_file.zy01,   #類別代號 (假單頭)
    g_zy01_t       LIKE zy_file.zy01,   #類別代號 (舊值)
    g_zy           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        zy02       LIKE zy_file.zy02,   #程式代號
        gaz03      LIKE gaz_file.gaz03, #程式名稱
        zy03       LIKE zy_file.zy03,   #執行權限
        zy04       LIKE zy_file.zy04,   #資料權限-1
        zy05       LIKE zy_file.zy05,   #資料權限-2
        zy07       LIKE zy_file.zy07    #資料權限-2
                    END RECORD,
    g_zy_t         RECORD               #程式變數 (舊值)
        zy02       LIKE zy_file.zy02,   #程式代號
        gaz03      LIKE gaz_file.gaz03, #程式名稱
        zy03       LIKE zy_file.zy03,   #執行權限
        zy04       LIKE zy_file.zy04,   #資料權限-1
        zy05       LIKE zy_file.zy05,   #資料權限-2
        zy07       LIKE zy_file.zy07    #資料權限-2
                    END RECORD,
    g_wc,g_sql       STRING,
    g_ss             LIKE type_file.chr1,    #決定後續步驟        #No.FUN-680135 VARCHAR(1)
    g_rec_b          LIKE type_file.num5,    #單身筆數            #No.FUN-680135 SMALLINT
    l_ac             LIKE type_file.num5     #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
DEFINE g_chr         LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE g_cnt         LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE g_forupd_sql  STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose #No.FUN-680135 SMALLINT
DEFINE g_msg         LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE g_curs_index  LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE g_row_count   LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE g_jump        LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE g_no_ask     LIKE type_file.num5     #No.FUN-680135 SMALLINT #FUN-6A0080
DEFINE g_argv1       LIKE zy_file.zy01
DEFINE g_before_input_done LIKE type_file.num5    #NO.MOD-580056  #No.FUN-680135 SMALLINT
DEFINE g_zz         DYNAMIC ARRAY OF RECORD
                   select LIKE type_file.chr1,
                   gaz01  LIKE gaz_file.gaz01,
                   gaz03  LIKE gaz_file.gaz03
                   END RECORD
DEFINE g_cnt1       LIKE type_file.num10    
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   LET g_argv1=ARG_VAL(1)                #若有傳入群組名則接收
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096
 
   LET g_zy01 = NULL                     #清除鍵值
   LET g_zy01_t = NULL
 
   OPEN WINDOW p_zy_w WITH FORM "azz/42f/p_zy"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_zy_q()
   END IF
       
   CALL p_zy_menu()
 
   CLOSE WINDOW p_zy_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
FUNCTION p_zy_curs()
 
   CLEAR FORM                             #清除畫面
   CALL g_zy.clear()
 
#  CALL g_zy03.clear() 
 
   #FUN-4A0083
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "zy01 = '",g_argv1 CLIPPED,"' "
   ELSE
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      CONSTRUCT g_wc ON zy01,zy02,zy03,zy04,zy05,zy07    #螢幕上取條件
         FROM zy01,s_zy[1].zy02,s_zy[1].zy03,s_zy[1].zy04,
                   s_zy[1].zy05,s_zy[1].zy07 
 
         ON ACTION controlp
             CASE  # MOD-490292
               WHEN INFIELD(zy01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_zw" 
                  LET g_qryparam.state ="c" 
                  LET g_qryparam.default1 = g_zy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zy01
 
                WHEN INFIELD(zy02)   # MOD-4A0005
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gaz" 
                  LET g_qryparam.state ="c" 
                  LET g_qryparam.default1 = g_zy[1].zy02
                  LET g_qryparam.arg1 = g_lang
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zy02
            END CASE
 
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('zyuser', 'zygrup') #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
 
   END IF
 
   LET g_sql= "SELECT UNIQUE zy01 FROM zy_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY 1"
   PREPARE p_zy_prepare FROM g_sql      #預備一下
   DECLARE p_zy_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR p_zy_prepare
 
   LET g_sql="SELECT COUNT(DISTINCT zy01) FROM zy_file WHERE ",g_wc CLIPPED
   PREPARE p_zy_precount FROM g_sql
   DECLARE p_zy_count CURSOR FOR p_zy_precount
 
END FUNCTION
 
FUNCTION p_zy_menu()
 
   WHILE TRUE
      CALL p_zy_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL p_zy_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL p_zy_q() 
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN 
               CALL p_zy_r()
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL p_zy_copy() 
            END IF
 
         #No.MOD-480464 mark
        #WHEN "batch"
        #   CAll act_def_batch()
 
         WHEN "detail" 
            IF cl_chk_act_auth() THEN 
               CALL p_zy_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN 
               CALL p_zy_out() 
            END IF
 
         WHEN "help" 
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "batch_gen_by_prog"
            IF cl_chk_act_auth() THEN
               CALL p_zy_g()
            END IF
 
         WHEN "batch_gen_by_menu"
            IF cl_chk_act_auth() THEN
               CALL p_zy_k() 
            END IF
 
         WHEN "batch_del_by_menu" 
            IF cl_chk_act_auth() THEN 
               CALL p_zy_d()
            END IF
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_zy),'','')
            END IF
 
         WHEN "action_with_owner"   #FUN-4B0049
            IF cl_chk_act_auth() THEN
               IF cl_null(g_zy01) THEN 
                  CALL cl_err(' ',-400,1)
               ELSE
                  IF NOT cl_null(g_zy[l_ac].zy02) THEN
                     LET g_msg='p_auth_as "',g_zy[l_ac].zy02,'" '   #TQC-590028
                     CALL cl_cmdrun_wait(g_msg)
                  ELSE
                     CALL cl_err(' ',-400,1)
                  END IF
               END IF
            END IF
 
         WHEN "express_biy"         #FUN-660048
            IF cl_chk_act_auth() THEN
               LET g_msg='p_biy "',g_zy01 CLIPPED,'" '
               CALL cl_cmdrun(g_msg)
            END IF
            
        WHEN "p_zy_r01"         #FUN-A80004
            IF cl_chk_act_auth() THEN
               LET g_msg="p_zy_r01 ",g_zy01
               CALL cl_cmdrun(g_msg)
            END IF
        WHEN "p_zy_r02"         #FUN-A80004
            IF cl_chk_act_auth() THEN
               LET g_msg="p_zy_r02 ",g_zy01
               CALL cl_cmdrun(g_msg)
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_zy_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_zy.clear()
#  CALL g_zy03.clear()
   INITIALIZE g_zy01 LIKE zy_file.zy01
   LET g_zy01_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_zy_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
     # INSERT INTO sysusers VALUES (g_zy01,'D','9','')
 
      IF SQLCA.sqlcode THEN
         #CALL cl_err('',SQLCA.sqlcode,1)  #No.FUN-660081
         CALL cl_err3("upd","sysusers",g_zy01,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_zy.clear() 
#        CALL g_zy03.clear() 
      ELSE
         CALL p_zy_b_fill('1=1')         #單身
      END IF
 
      LET g_rec_b=0
      CALL p_zy_b()                   #輸入單身
 
      LET g_zy01_t = g_zy01            #保留舊值
      EXIT WHILE
   END WHILE
   LET g_wc=' '
 
END FUNCTION
 
FUNCTION p_zy_i(p_cmd)
 
   DEFINE p_cmd           LIKE type_file.chr1    #a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
   DEFINE lc_zwacti       LIKE zw_file.zwacti    #MOD-560212
 
   LET g_ss='Y'
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT g_zy01 WITHOUT DEFAULTS FROM zy01
 
#NO.MOD-590329 MARK-----------------
    #NO.MOD-580056------
#      BEFORE INPUT
#         LET g_before_input_done = FALSE
#         CALL p_zy_set_entry(p_cmd)
#         CALL p_zy_set_no_entry(p_cmd)
#         LET g_before_input_done = TRUE
   #--------END
#NO.MOD-590329 MARK-----------------
 
      AFTER FIELD zy01                  #類別代號
         IF NOT cl_null(g_zy01) THEN
            IF g_zy01 != g_zy01_t OR g_zy01_t IS NULL THEN
               SELECT UNIQUE zy01 INTO g_chr
                 FROM zy_file
                WHERE zy01=g_zy01
 
               IF SQLCA.sqlcode THEN             #不存在, 新來的
                  IF p_cmd='a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_zy01,-239,0)
                     LET g_zy01=g_zy01_t
                     NEXT FIELD zy01
                  END IF
               END IF
                # Check zw_file   #MOD-560212
               SELECT zwacti INTO lc_zwacti FROM zw_file
                WHERE zw01 = g_zy01
               IF SQLCA.SQLCODE THEN
                  #CALL cl_err(g_zy01,SQLCA.SQLCODE,1)  #No.FUN-660081
                  CALL cl_err3("sel","zw_file",g_zy01,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
                  NEXT FIELD zy01
                ELSE                     #MOD-560212
                  IF lc_zwacti = "N" THEN
                     CALL cl_err_msg(NULL,"azz-218",g_zy01 CLIPPED,10)
                     NEXT FIELD zy01
                  END IF
               END IF
            END IF
 
            CALL p_zy_zy01(p_cmd)
 
            IF g_chr = 'E' THEN
               CALL cl_err('',SQLCA.sqlcode,0)
               NEXT FIELD zy01
            END IF
         END IF
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION controlp
          CASE  # MOD-490292
             WHEN INFIELD(zy01)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_zw" 
                LET g_qryparam.default1 = g_zy01
                CALL cl_create_qry() RETURNING g_zy01
                DISPLAY g_zy01 TO zy01
             OTHERWISE
                EXIT CASE
         END CASE
 
      ON ACTION about         #FUN-860033
         CALL cl_about()      #FUN-860033
 
      ON ACTION controlg      #FUN-860033
         CALL cl_cmdask()     #FUN-860033
 
      ON ACTION help          #FUN-860033
         CALL cl_show_help()  #FUN-860033
 
      ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE INPUT
 
   END INPUT
 
END FUNCTION
   
FUNCTION  p_zy_zy01(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,        #No.FUN-680135 VARCHAR(1)
   l_zw02          LIKE zw_file.zw02,
   l_zwacti        LIKE zw_file.zwacti         #資料有效碼
 
   LET g_chr = ' '
 
   SELECT zw02,zwacti INTO l_zw02,l_zwacti
     FROM zw_file
    WHERE zw01 = g_zy01
 
  IF SQLCA.sqlcode THEN
      LET g_chr = 'E'
      LET l_zw02 = NULL
   ELSE
      IF l_zwacti='N' THEN                     #無效的資料
         LET g_chr='E'
      END IF
   END IF
 
   DISPLAY l_zw02,l_zwacti TO zw02,zwacti      #MOD-560212
 
END FUNCTION
 
FUNCTION p_zy_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL p_zy_curs()                        #取得查詢條件
 
   IF INT_FLAG THEN                        #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN p_zy_b_curs                        #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                   #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_zy01 TO NULL
   ELSE
      CALL p_zy_fetch('F')                 #讀出TEMP第一筆並顯示
      OPEN p_zy_count
      FETCH p_zy_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
 
END FUNCTION
 
FUNCTION p_zy_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-680135 VARCHAR(1) 
   l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_zy_b_curs INTO g_zy01
      WHEN 'P' FETCH PREVIOUS p_zy_b_curs INTO g_zy01
      WHEN 'F' FETCH FIRST    p_zy_b_curs INTO g_zy01
      WHEN 'L' FETCH LAST     p_zy_b_curs INTO g_zy01
      WHEN '/' 
            IF (NOT g_no_ask) THEN       #FUN-6A0080 
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                  LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump p_zy_b_curs INTO g_zy01
            LET g_no_ask = FALSE    #FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_zy01,SQLCA.sqlcode,0)
      INITIALIZE g_zy01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL p_zy_show()
   END IF
 
END FUNCTION
 
FUNCTION p_zy_show()
 
   DISPLAY g_zy01 TO zy01              #單頭
   CALL p_zy_zy01('a')                 #單身
   CALL p_zy_b_fill(g_wc)              #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_zy_r()
    ###FUN-B40008 START ###
    DEFINE li_chkzx        LIKE type_file.num10   
    DEFINE li_chkzxw       LIKE type_file.num10   
    DEFINE ls_progname     STRING
    ###FUN-B40008 END ### 

   IF g_zy01 IS NULL THEN
      RETURN
   END IF
 
   IF cl_delh(0,0) THEN                   #確認一下
      ###FUN-B40008 START ### 
      LET li_chkzx = 0
      SELECT COUNT(*) INTO li_chkzx FROM zx_file
         WHERE zx04 = g_zy01
      IF li_chkzx > 0 THEN
         CALL cl_get_progname("p_zx",g_lang) RETURNING ls_progname
         LET ls_progname = ls_progname.trim(),"|p_zx|",g_zy01
         CALL cl_err_msg(NULL,"azz-217",ls_progname.trim(),10)
         RETURN
      ELSE
         LET li_chkzxw = 0
         SELECT count(*) INTO li_chkzxw FROM zxw_file
            WHERE zxw03 = "1" AND zxw04 = g_zy01
         IF li_chkzxw > 0 THEN
            CALL cl_get_progname("p_zx",g_lang) RETURNING ls_progname
            LET ls_progname = ls_progname.trim(),"|p_zx|",g_zy01
            CALL cl_err_msg(NULL,"azz-217",ls_progname.trim(),10)
            RETURN
         END IF
      END IF
      ###FUN-B40008 END ###

      DELETE FROM zy_file WHERE zy01 = g_zy01
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","zy_file",g_zy01,"",SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_zy.clear()
#        CALL g_zy03.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
 
         OPEN p_zy_count
#FUN-B50065------begin---
         IF STATUS THEN
            CLOSE p_zy_count
            RETURN
         END IF
#FUN-B50065------end------
         FETCH p_zy_count INTO g_row_count
#FUN-B50065------begin---
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE p_zy_count
            RETURN
         END IF
#FUN-B50065------end------
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_zy_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_zy_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE        #FUN-6A0080
            CALL p_zy_fetch('/')
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p_zy_b()
 
    DEFINE l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
           l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680135 SMALLINT
           l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680135 VARCHAR(1)
           p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680135 VARCHAR(1)
           l_allow_insert  LIKE type_file.num5,   #可新增否          #No.FUN-680135 SMALLINT
           l_allow_delete  LIKE type_file.num5    #可刪除否          #No.FUN-680135 SMALLINT
    DEFINE lc_zwacti       LIKE zw_file.zwacti    #MOD-560212
 
    LET g_action_choice = ""
    IF cl_null(g_zy01) THEN
       CALL cl_err('',-400,0)
       RETURN
     ELSE                     #MOD-560212
       SELECT zwacti INTO lc_zwacti FROM zw_file
        WHERE zw01 = g_zy01
       IF lc_zwacti = "N" THEN
          CALL cl_err_msg(NULL,"azz-218",g_zy01 CLIPPED,10)
          RETURN
       END IF
    END IF
    
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT zy02,'',zy03,zy04,zy05,zy07 ",
                         " FROM zy_file ",
                        " WHERE zy01=? AND zy02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_zy_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_zy WITHOUT DEFAULTS FROM s_zy.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
         
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
#          LET l_n  = ARR_COUNT()
           IF g_rec_b >= l_ac THEN
              BEGIN WORK
              LET p_cmd='u'
              LET g_zy_t.* = g_zy[l_ac].*  #BACKUP
#NO.MOD-590329 MARK-----------------
 #No.MOD-580056 --start
#              LET g_before_input_done = FALSE
#              CALL p_zy_set_entry_b(p_cmd)
#              CALL p_zy_set_no_entry_b(p_cmd)
#              LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK-------------------
              OPEN p_zy_bcl USING g_zy01,g_zy_t.zy02
              FETCH p_zy_bcl INTO g_zy[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_zy_t.zy02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              ELSE
#                # 2004/08/19 變更權限顯示方式
#                LET g_zy03[l_ac].zy03=g_zy[l_ac].zy03
#                CALL s_act_desc_tab(g_zy[l_ac].zy02,g_zy03[l_ac].zy03,g_zy[l_ac].zy07,"1")
 #                     RETURNING g_zy[l_ac].zy03       #MOD-490216
#                LET g_zy03_t.*=g_zy03[l_ac].*
 
                 LET g_zy_t.*=g_zy[l_ac].*
                 CALL p_zy_zy02(' ')
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_zy[l_ac].* TO NULL      #900423
           LET g_zy[l_ac].zy04 = 0
           LET g_zy[l_ac].zy05 = 0
           LET g_zy[l_ac].zy07 = 0
           LET g_zy_t.* = g_zy[l_ac].*         #新輸入資料
#NO.MOD-590329 MARK--------------------
 #No.MOD-580056 --start
#           LET g_before_input_done = FALSE
#           CALL p_zy_set_entry_b(p_cmd)
#           CALL p_zy_set_no_entry_b(p_cmd)
#           LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK--------------------
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD zy02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
#          INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy06,zy07) #FUN-5C0057
           INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,
                               zyuser,zygrup,zydate,zyoriu,zyorig)
                VALUES(g_zy01,g_zy[l_ac].zy02, g_zy[l_ac].zy03,
                              g_zy[l_ac].zy04, g_zy[l_ac].zy05,
                              g_zy[l_ac].zy07,
                              g_user,g_grup,g_today, g_user, g_grup)                #FUN-5C0057      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
              #CALL cl_err(g_zy[l_ac].zy02,SQLCA.sqlcode,0)  #No.FUN-660081
              CALL cl_err3("ins","zy_file",g_zy01,g_zy[l_ac].zy02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_zy_t.zy02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM zy_file
                WHERE zy01 = g_zy01
                  AND zy02 = g_zy_t.zy02
              IF SQLCA.sqlcode THEN
                 #CALL cl_err(g_zy_t.zy02,SQLCA.sqlcode,0)  #No.FUN-660081
                 CALL cl_err3("del","zy_file",g_zy01,g_zy_t.zy02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        AFTER FIELD zy02                        #check 序號是否重複
           IF g_zy[l_ac].zy02 IS NOT NULL AND
              (g_zy[l_ac].zy02 != g_zy_t.zy02 OR
               g_zy_t.zy02 IS NULL) THEN
              SELECT count(*) INTO l_n FROM zy_file
               WHERE zy01 = g_zy01 
                 AND zy02 = g_zy[l_ac].zy02
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_zy[l_ac].zy02 = g_zy_t.zy02
                 NEXT FIELD zy02
              ELSE
                 CALL p_zy_zy02(p_cmd)
                 IF g_chr = 'E' THEN
                    CALL cl_err('','-100',0)
                    NEXT FIELD zy02
                 END IF
              END IF
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_zy[l_ac].* = g_zy_t.*
              CLOSE p_zy_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_zy[l_ac].zy02,-263,1)
              LET g_zy[l_ac].* = g_zy_t.*
           ELSE
              UPDATE zy_file SET zy02 = g_zy[l_ac].zy02,
                                 zy03 = g_zy[l_ac].zy03,
                                 zy04 = g_zy[l_ac].zy04,
                                 zy05 = g_zy[l_ac].zy05,
                                 zy07 = g_zy[l_ac].zy07, 
                                 zydate = g_today,		#MOD-970066 
                                 zygrup = g_grup, 		#MOD-970066
                                 zymodu = g_user, 		#MOD-970066
                                 zyuser = g_user 		#MOD-970066
               WHERE zy01=g_zy01
                 AND zy02=g_zy_t.zy02
              IF SQLCA.sqlcode THEN
                 #CALL cl_err(g_zy[l_ac].zy02,SQLCA.sqlcode,1)  #No.FUN-660081
                 CALL cl_err3("upd","zy_file",g_zy01,g_zy_t.zy02,SQLCA.sqlcode,"","",1)    #No.FUN-660081
                 LET g_zy[l_ac].* = g_zy_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac       #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_zy[l_ac].* = g_zy_t.*
              #FUN-D30034---add---str---
              ELSE
                 CALL g_zy.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF
              CLOSE p_zy_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac       #FUN-D30034 add
           CLOSE p_zy_bcl
           COMMIT WORK
 
        ON ACTION controlp
            CASE  # MOD-490292
              WHEN INFIELD(zy02)
 #                CALL cl_qzz(FALSE,TRUE,g_zy[l_ac].zy02)  #No.MOD-490021
#                     RETURNING g_zy[l_ac].zy02
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gaz" 
                 LET g_qryparam.arg1 = g_lang CLIPPED
                 LET g_qryparam.default1 = g_zy[l_ac].zy02
                 CALL cl_create_qry() RETURNING g_zy[l_ac].zy02
                 DISPLAY g_zy[l_ac].zy02 TO zy02
           END CASE
 
        ON ACTION modify_auth
           # 2004/08/19 變更權限顯示方式
           # 2004/09/10 不變更顯示
           CALL s_act_define(g_zy01, g_zy[l_ac].zy02,'zy_file',g_zy[l_ac].zy03,g_zy[l_ac].zy07)
                RETURNING g_zy[l_ac].zy03,g_zy[l_ac].zy07
#          CALL s_act_desc_tab(g_zy[l_ac].zy02,g_zy03[l_ac].zy03,g_zy[l_ac].zy07,"1")
 #               RETURNING g_zy[l_ac].zy03             #MOD-490216
           DISPLAY g_zy[l_ac].zy03,g_zy[l_ac].zy04,g_zy[l_ac].zy07
                TO zy03,zy04,zy07
           NEXT FIELD zy03
 
         ON ACTION modify_detail_auth   #MOD-540026
           CALL s_act_detail(g_zy[l_ac].zy07) RETURNING g_zy[l_ac].zy07
           DISPLAY g_zy[l_ac].zy07 TO zy07
 
        ON ACTION controlo                        #沿用所有欄位
           IF INFIELD(zy02) AND l_ac > 1 THEN
              LET g_zy[l_ac].* = g_zy[l_ac-1].*
              NEXT FIELD zy02
           END IF
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
    END INPUT
 
    CLOSE p_zy_bcl
    COMMIT WORK
 
END FUNCTION
   
FUNCTION  p_zy_zy02(p_cmd)
DEFINE
    p_cmd       LIKE type_file.chr1,      #No.FUN-680135 VARCHAR(1)
    l_zz04	    LIKE zz_file.zz04,
    l_cnt       LIKE type_file.num10      #No.FUN-680135 INTEGER
 
#  # 2004/04/26 將 zz02 移至 gaz03
#
#     SELECT zz04,gaz03 INTO l_zz04,g_zy[l_ac].gaz03
#       FROM zz_file, gaz_file
#      WHERE zz01 = g_zy[l_ac].zy02
#        AND gaz_file.gaz01 = zz01 AND gaz_file.gaz02 = g_lang
 
 #     #MOD-540163
      CALL cl_get_progname(g_zy[l_ac].zy02,g_lang) RETURNING g_zy[l_ac].gaz03
#     SELECT gaz03 INTO g_zy[l_ac].gaz03 FROM gaz_file
#      WHERE g_zy[l_ac].zy02 = gaz01 AND gaz02 = g_lang order by gaz05
 
      SELECT zz04 INTO l_zz04
        FROM zz_file
       WHERE zz01 = g_zy[l_ac].zy02
 
   IF SQLCA.sqlcode THEN
      LET g_chr = 'E'
    #  LET g_zy[l_ac].gaz03 = NULL
      RETURN
   END IF
 
   LET g_chr = ' '
 
   IF p_cmd = 'a' THEN
      LET g_zy[l_ac].zy03 = l_zz04
#     IF g_zy03[l_ac].zy03 IS NULL THEN
#        LET g_zy03[l_ac].zy03 = l_zz04
#     END IF
   END IF
 
END FUNCTION
 
 
FUNCTION p_zy_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc  STRING
 
#  LET g_sql = "SELECT unique zy02,gaz03,zy03,zy04,zy05,zy07 ",
#               " FROM zy_file, OUTER gaz_file ",
#              " WHERE zy01 = '",g_zy01,"' ",
#                " AND zy02 = gaz01 AND gaz02 = '",g_lang CLIPPED,"' ",
#                " AND ",p_wc CLIPPED ,
#              " ORDER BY 1"
  
   LET g_sql = "SELECT zy02,' ',zy03,zy04,zy05,zy07 ",
                " FROM zy_file",
               " WHERE zy01 = '",g_zy01,"' ",
                 " AND ",p_wc CLIPPED ,
               " ORDER BY zy02"
   PREPARE p_zy_prepare2 FROM g_sql      #預備一下
 
   DECLARE zy_curs CURSOR FOR p_zy_prepare2
 
   CALL g_zy.clear()
#  CALL g_zy03.clear()
   LET g_rec_b=0
   LET g_cnt = 1
   MESSAGE " Wait " 
 
   FOREACH zy_curs INTO g_zy[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
 #     #MOD-540163
      CALL cl_get_progname( g_zy[g_cnt].zy02,g_lang) RETURNING g_zy[g_cnt].gaz03
#     SELECT gaz03 INTO g_zy[g_cnt].gaz03 FROM gaz_file 
#      WHERE gaz01= g_zy[g_cnt].zy02 AND gaz02=g_lang order by gaz05
 
#     # 2004/08/19 改變權限顯示方式
#     LET g_zy03[g_cnt].zy03=g_zy[g_cnt].zy03
 #     CALL s_act_desc_tab(g_zy[g_cnt].zy02,g_zy03[g_cnt].zy03,g_zy[g_cnt].zy07,"1") RETURNING g_zy[g_cnt].zy03       #MOD-490216
 
      LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN   #MOD-4B0274
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_zy.deleteElement(g_cnt)
   IF SQLCA.sqlcode THEN CALL cl_err('FOREACH:',SQLCA.sqlcode,1) END IF
   MESSAGE ""
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_zy_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_zy TO s_zy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
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
 
      ON ACTION first 
         CALL p_zy_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous
         CALL p_zy_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION jump 
         CALL p_zy_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next
         CALL p_zy_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last 
         CALL p_zy_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION output
         LET g_action_choice="output"
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
#        EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
#@    ON ACTION 依程式整批產生
      ON ACTION batch_gen_by_prog
         LET g_action_choice="batch_gen_by_prog"
         EXIT DISPLAY
 
#@    ON ACTION 依MENU整批產生
      ON ACTION batch_gen_by_menu
         LET g_action_choice="batch_gen_by_menu"
         EXIT DISPLAY
 
#@    ON ACTION 依MENU整批刪除
      ON ACTION batch_del_by_menu
         LET g_action_choice="batch_del_by_menu"
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
 
      ON ACTION action_with_owner   #FUN-4B0049
         LET g_action_choice = 'action_with_owner'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
#@    ON ACTION 維護Express報表權限"
      ON ACTION express_biy                        #FUN-660048
          LET g_action_choice="express_biy"
          EXIT DISPLAY

      ON ACTION p_zy_r01                           #FUN-A80004
          LET g_action_choice="p_zy_r01"
          EXIT DISPLAY
          
      ON ACTION p_zy_r02                           #FUN-A80004
          LET g_action_choice="p_zy_r02"
          EXIT DISPLAY  
          
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_zy_copy()
 
   DEFINE l_newno   LIKE zy_file.zy01
   DEFINE l_oldno   LIKE zy_file.zy01
   DEFINE lc_zwacti LIKE zw_file.zwacti  #MOD-560212
   DEFINE l_flag    LIKE type_file.chr1  #No.FUN-880014
   
   IF g_zy01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_newno FROM zy01
 
      AFTER FIELD zy01
         IF l_newno IS NULL THEN
            NEXT FIELD zy01
         END IF
         SELECT count(*) INTO g_cnt FROM zy_file
          WHERE zy01 = l_newno
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD zy01
         END IF
 
         # Check zw_file   #MOD-560212
         SELECT zwacti INTO lc_zwacti FROM zw_file
          WHERE zw01 = l_newno
         IF SQLCA.SQLCODE THEN
            #CALL cl_err(l_newno,SQLCA.SQLCODE,1)  #No.FUN-660081
            CALL cl_err3("sel","zw_file",l_newno,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
            NEXT FIELD zy01
          ELSE                     #MOD-560212
            IF lc_zwacti = "N" THEN
               CALL cl_err_msg(NULL,"azz-218",l_newno CLIPPED,10)
               NEXT FIELD zy01
            END IF
         END IF
 
      ON ACTION about         #FUN-860033
         CALL cl_about()      #FUN-860033
 
      ON ACTION controlg      #FUN-860033
         CALL cl_cmdask()     #FUN-860033
 
      ON ACTION help          #FUN-860033
         CALL cl_show_help()  #FUN-860033
 
      ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE INPUT
          
      #No.FUN-880014---Begin
      ON ACTION author_maintain
         LET l_flag = 'Y'
         LET g_msg='p_zw "',l_flag CLIPPED,'" '
         CALL cl_cmdrun_wait(g_msg)
      #No.FUN-880014---End
 
   END INPUT
 
   IF INT_FLAG OR l_newno IS NULL THEN
      LET INT_FLAG = 0
      DISPLAY g_zy01 TO zy01  #No.FUN-880014
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM zy_file WHERE zy01=g_zy01 INTO TEMP x
 
   UPDATE x SET zy01=l_newno,    #資料鍵值
                zyuser=g_user,
                zygrup=g_grup,
                zydate=g_today    #FUN-5C0057
 
   INSERT INTO zy_file SELECT * FROM x
 
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_zy01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","zy_file",l_newno,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
      RETURN
   ELSE 
   	  LET l_oldno = g_zy01 #No.FUN-880014  
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE 'COPY(',g_cnt USING '<<<<',') Rows O.K'
   #LET g_zy01 = l_oldno  #No.FUN-880014  #FUN-C30027
   #CALL p_zy_show()      #No.FUN-880014  #FUN-C30027
 
END FUNCTION
 
FUNCTION p_zy_g()                               #依程式產生  MOD-560212
   DEFINE l_wc,l_sql    STRING,
          l_ac          LIKE type_file.num5,    #No.FUN-680135 SMALLINT
          l_zz04        LIKE zz_file.zz04,
         #l_zz18        LIKE zz_file.zz18,      #CHI-C80029 mark
         #l_zz19        LIKE zz_file.zz19,      #CHI-C80029 mark
          l_zz32        LIKE zz_file.zz32,
          l_zz  DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
            xxxx        LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
            zz01        LIKE zz_file.zz01,
            gaz03       LIKE gaz_file.gaz03,
            zz011       LIKE zz_file.zz011,     #MOD-530169
            zz03        LIKE zz_file.zz03,
            zz10        LIKE zz_file.zz10       #MOD-530169
#           zz11        LIKE zz_file.zz11,      #MOD-530169
#           zz12        LIKE zz_file.zz12       #MOD-530169
                    END RECORD
   DEFINE ls_zz011      STRING 
   DEFINE lc_zz011      LIKE zz_file.zz011
   DEFINE lc_zw02       LIKE zw_file.zw02       #MOD-530203
   DEFINE lc_zwacti     LIKE zw_file.zwacti     #MOD-560212
 
   #MOD-530203 MOD-560212
   IF g_zy01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT zw02,zwacti INTO lc_zw02,lc_zwacti FROM zw_file
    WHERE zw01=g_zy01
   IF lc_zwacti = "N" THEN
      CALL cl_err_msg(NULL,"azz-218",g_zy01 CLIPPED,10)
      RETURN
   END IF
 
   OPEN WINDOW p_zy_g_w WITH FORM "azz/42f/p_zy_g"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_zy_g")
 
   DISPLAY g_zy01,lc_zw02 TO g_zy01,zw02   #MOD-560212
 
   LET ls_zz011=""
   DECLARE p_zy_zz011_cur CURSOR FOR SELECT gao01 FROM gao_file ORDER BY gao01
   FOREACH p_zy_zz011_cur INTO lc_zz011
      IF cl_null(ls_zz011) THEN
         LET ls_zz011=lc_zz011
      ELSE
         LET ls_zz011=ls_zz011 CLIPPED,",",lc_zz011 CLIPPED
      END IF
   END FOREACH
   CALL cl_set_combo_items("zz011",ls_zz011,ls_zz011)
 
#  #MOD-530169
#   INPUT BY NAME g_zy01 WITHOUT DEFAULTS
#
#      AFTER FIELD g_zy01
#         SELECT zw01 FROM zw_file WHERE zw01=g_zy01
#         IF SQLCA.SQLCODE THEN
#            CALL cl_err('sel zw:',SQLCA.SQLCODE,1)
#            NEXT FIELD g_zy01
#         END IF
#   END INPUT
#
#   IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW p_zy_g_w RETURN END IF
 
   CALL cl_opmsg('q')
 
    # 2004/04/26 將攔位名稱 zz02 改為 gaz03                   #MOD-480464
    CONSTRUCT l_wc ON zz01,zz011,zz03,zz10   #,zz11,zz12      #MOD-530169
                FROM s_zz[1].zz01,s_zz[1].zz011,s_zz[1].zz03,s_zz[1].zz10 
#                   ,s_zz[1].zz11,s_zz[1].zz12                #MOD-530169
 
      ON ACTION controlp  #MOD-530169
        CASE
           WHEN INFIELD(zz01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaz"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1= l_zz[1].zz01
               LET g_qryparam.arg1 = g_lang CLIPPED
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO zz01
               NEXT FIELD zz01
 
           WHEN INFIELD(zz10)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gaw"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1= l_zz[1].zz10
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO zz10
              NEXT FIELD zz10
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
 
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW p_zy_g_w
      RETURN
   END IF
 
   CALL cl_opmsg('w')
 
   # 2004/04/26 將攔位名稱 zz02 改為 gaz03
#  LET l_sql = "SELECT 'Y',zz01,gaz03,zz03,zz10,zz11,zz12 ",
#  #MOD-530169
   LET l_sql = "SELECT 'Y',zz01,gaz03,zz011,zz03,zz10 ",
         " FROM zz_file LEFT OUTER JOIN gaz_file ",   
                              " ON gaz_file.gaz01 = zz_file.zz01 ",   
                             " AND gaz_file.gaz02 = '",g_lang CLIPPED,"' ", 
        " WHERE ",l_wc CLIPPED, 
        " ORDER BY zz01"
 
   PREPARE q_zz_prepare FROM l_sql
 
   DECLARE zz_curs CURSOR FOR q_zz_prepare
 
   LET l_ac = 1
 
   FOREACH zz_curs INTO l_zz[l_ac].*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT zy01 FROM zy_file
       WHERE zy01 = g_zy01
         AND zy02 = l_zz[l_ac].zz01
 
      IF SQLCA.sqlcode = 0 THEN CONTINUE FOREACH END IF
 
      LET l_ac = l_ac + 1
   END FOREACH
    CALL l_zz.deleteElement(l_ac)  #No.MOD-480464
    LET g_rec_b = l_ac - 1         #No.MOD-480464
    LET l_ac = 1                   #No.MOD-480464
 
   #No.MOD-480464
   DISPLAY ARRAY l_zz TO s_zz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
         BEFORE DISPLAY 
           EXIT DISPLAY
   END DISPLAY
 
   INPUT ARRAY l_zz WITHOUT DEFAULTS FROM s_zz.*  
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE ,APPEND ROW=FALSE)
 
         BEFORE INPUT
          IF g_rec_b!=0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
         AFTER FIELD xxxx
            IF NOT cl_null(l_zz[l_ac].xxxx) THEN
               IF l_zz[l_ac].xxxx NOT MATCHES '[YN]' THEN
                  NEXT FIELD xxxx
               END IF
            END IF
 
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT  
    #No.MOD-480464
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p_zy_g_w
      RETURN
   END IF
 
   FOR l_ac = 1 TO l_zz.getLength()
      IF l_zz[l_ac].xxxx != 'Y' OR l_zz[l_ac].xxxx IS NULL THEN
         CONTINUE FOR
      END IF
 
      MESSAGE l_zz[l_ac].zz01
 
     #CHI-C80029---mod---S---
     #SELECT zz04,zz18,zz19,zz32
     #  INTO l_zz04,l_zz18,l_zz19,l_zz32 FROM zz_file
     # WHERE zz01 = l_zz[l_ac].zz01
      SELECT zz04,zz32
        INTO l_zz04,l_zz32 FROM zz_file
       WHERE zz01 = l_zz[l_ac].zz01
     #CHI-C80029---mod---E---
 
      IF SQLCA.sqlcode THEN
         LET l_zz04 = NULL
        #LET l_zz18 = NULL  #CHI-C80029 mark
        #LET l_zz19 = NULL  #CHI-C80029 mark
         LET l_zz32 = NULL
      END IF
 
#      INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy06,      #FUN-5C0057
#                          zyuser,zygrup,zymodu,zydate,zy07) #No.MOD-470041 
#                  VALUES(g_zy01,l_zz[l_ac].zz01,l_zz04,l_zz18,l_zz19,
#                         '1234XSVDEL',g_user,g_grup,'',g_today,l_zz32)
       INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,
                           zyuser,zygrup,zymodu,zydate,zyoriu,zyorig) #No.MOD-470041 
                   VALUES(g_zy01,l_zz[l_ac].zz01,l_zz04,'0','0',l_zz32,  #CHI-C80029 mod l_zz18,l_zz19 ->0
                          g_user,g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
   END FOR
 
   CALL cl_end(0,0)
   CLOSE WINDOW p_zy_g_w
 
END FUNCTION
 
FUNCTION p_zy_k()
 
   DEFINE l_zz01	LIKE zz_file.zz01
   DEFINE lc_zwacti     LIKE zw_file.zwacti    #MOD-560212
   DEFINE t_zy01        LIKE type_file.num5    #FUN-950105 add
 
   OPEN WINDOW p_zy_k_w WITH FORM "azz/42f/p_zy_k"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_zy_k")
 
   INPUT BY NAME g_zy01,l_zz01 WITHOUT DEFAULTS
 
      AFTER FIELD g_zy01
         IF NOT cl_null(g_zy01) THEN
            SELECT zwacti INTO lc_zwacti FROM zw_file WHERE zw01=g_zy01
            IF STATUS THEN
               #CALL cl_err('sel zw:',STATUS,1)  #No.FUN-660081
               CALL cl_err3("sel","zw_file",g_zy01,"",STATUS,"","sel zw",1)    #No.FUN-660081
               NEXT FIELD g_zy01
            ELSE                     #MOD-560212
               IF lc_zwacti = "N" THEN
                  CALL cl_err_msg(NULL,"azz-218",g_zy01 CLIPPED,10)
                  NEXT FIELD g_zy01
               END IF
            END IF
         END IF
#        #MOD-560212
#        IF l_zz01 IS NULL THEN
#           SELECT MAX(zx05) INTO l_zz01 FROM zx_file WHERE zx04=g_zy01
#           DISPLAY BY NAME l_zz01
#        END IF
 
      AFTER FIELD l_zz01
         SELECT zz01 FROM zz_file WHERE zz01=l_zz01
         IF STATUS THEN
            #CALL cl_err('sel zz:',STATUS,1)  #No.FUN-660081
            CALL cl_err3("sel","zz_file",l_zz01,"",STATUS,"","sel zz",1)    #No.FUN-660081
            NEXT FIELD l_zz01
         END IF
 
      ON ACTION controlp     #MOD-560212
         CASE
            WHEN INFIELD(g_zy01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zw"
               LET g_qryparam.default1 = g_zy01
               CALL cl_create_qry() RETURNING g_zy01
               DISPLAY g_zy01 TO g_zy01
               NEXT FIELD g_zy01
 
            WHEN INFIELD(l_zz01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zm"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.default1 = l_zz01
               CALL cl_create_qry() RETURNING l_zz01
               DISPLAY l_zz01 TO l_zz01
               NEXT FIELD l_zz01
         OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION about         #FUN-860033
         CALL cl_about()      #FUN-860033
 
      ON ACTION controlg      #FUN-860033
         CALL cl_cmdask()     #FUN-860033
 
      ON ACTION help          #FUN-860033
         CALL cl_show_help()  #FUN-860033
 
      ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE INPUT
 
   END INPUT
 
 #FUN-950105---add---start---
   SELECT COUNT(*) INTO t_zy01 FROM zy_file,gaz_file
    WHERE zy01 = g_zy01
      AND zy02 = gaz01  AND gaz02 = g_lang
      AND zy02 IN (SELECT zm04 FROM zm_file WHERE zm01 = l_zz01)
   IF t_zy01 > 0 THEN
      CALL p_zy_k2(g_zy01,l_zz01)
   END IF
 #FUN-950105---add---end---
 
   CLOSE WINDOW p_zy_k_w
 
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   CALL p_zy_bom(0,l_zz01)
 
   DISPLAY g_zy01 TO zy01
 
   CALL p_zy_b_fill('1=1')         #單身
 
   CALL p_zy_bp("D")
 
END FUNCTION
 
FUNCTION p_zy_bom(p_level,p_key)
  DEFINE p_level     LIKE type_file.num5,    #No.FUN-680135 SMALLINT
          p_key       LIKE zm_file.zm01,     #No.MOD-480245
         l_ac,i      LIKE type_file.num5,    #No.FUN-680135 SMALLINT 
         sr DYNAMIC ARRAY OF RECORD          #每階存放資料
             zm03    LIKE zm_file.zm03,
             zm04    LIKE zm_file.zm04,
             zz03    LIKE zz_file.zz03,
             zz04    LIKE zz_file.zz04,      #No.FUN-680135 VARCHAR(3000)
#            zz04    LIKE zz_file.zz04,
            #zz18    LIKE zz_file.zz18,      #CHI-C80029 mark
            #zz19    LIKE zz_file.zz19,      #CHI-C80029 mark
             zz32    LIKE zz_file.zz32
                 END RECORD,
         l_zy        RECORD
             zy01    LIKE zy_file.zy01,
             zy02    LIKE zy_file.zy02,
             zy03    LIKE zy_file.zy03,
             zy04    LIKE zy_file.zy04,
             zy05    LIKE zy_file.zy05,
             zy06    LIKE zy_file.zy06,
             zyuser  LIKE zy_file.zyuser,
             zygrup  LIKE zy_file.zygrup,
             zymodu  LIKE zy_file.zymodu,
             zydate  LIKE zy_file.zydate,
             zy07    LIKE zy_file.zy07
                 END RECORD,
         l_sql       STRING
 
   IF p_level > 20 THEN
      CALL cl_err('','mfg2733',1)
      RETURN
   END IF
 
   LET p_level = p_level + 1
 
   IF p_level > 20 THEN
      RETURN
   END IF
 
    #No.MOD-480245
   LET l_sql = " SELECT zm03,zm04,zz03,zz04,zz32 ",    #zz18,zz19, CHI-C80029 mark 
               "   FROM zm_file, zz_file ",
               "  WHERE zm01= '",p_key CLIPPED,"'",
               "    AND zm04=zz01 ",
               "    AND zm04 NOT IN (SELECT zy02 FROM zy_file WHERE zy01 = '",g_zy01,"')"      #FUN-950105 add 抓出不存在zy_file裡的
   PREPARE p_zy_bom_pre FROM l_sql
   DECLARE p_zy_bom_c CURSOR FOR p_zy_bom_pre
    #No.MOD-480245
 
   LET l_ac = 1
 
   FOREACH p_zy_bom_c INTO sr[l_ac].*  # 先將BOM單身存入BUFFER
      IF STATUS THEN
         CALL cl_err('fore p500_cur:',STATUS,1)
         EXIT FOREACH
      END IF
      LET l_ac=l_ac+1
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL sr.deleteElement(l_ac)
 
   FOR i = 1 TO sr.getLength()               # 讀BUFFER傳給REPORT
      IF sr[i].zz03='M' THEN
         CALL p_zy_bom(p_level,sr[i].zm04)
      END IF
 
      LET l_zy.zy01=g_zy01
      LET l_zy.zy02=sr[i].zm04
      LET l_zy.zy03=sr[i].zz04
     #LET l_zy.zy04=sr[i].zz18   #CHI-C80029 mark
     #LET l_zy.zy05=sr[i].zz19   #CHI-C80029 mark
      LET l_zy.zy04='0'          #CHI-C80029
      LET l_zy.zy05='0'          #CHI-C80029
      LET l_zy.zy07=sr[i].zz32
 
#     INSERT INTO zy_file VALUES(l_zy.*)   #FUN-5C0057
      INSERT INTO zy_file (zy01,zy02,zy03,zy04,zy05,zy07,
                           zyuser,zygrup,zydate,zyoriu,zyorig)
             VALUES(l_zy.zy01,l_zy.zy02,l_zy.zy03,l_zy.zy04,l_zy.zy05,l_zy.zy07,
                    l_zy.zyuser,l_zy.zygrup,l_zy.zydate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
      #IF STATUS THEN                                   #TQC-790092 
          #IF STATUS != -239 THEN   #No.MOD-480464      #TQC-790092
       IF SQLCA.SQLCODE THEN                            #TQC-790092
          IF NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790092
            #CALL cl_err('ins zy:',STATUS,0)  #No.FUN-660081
            CALL cl_err3("ins","zy_file",l_zy.zy01,l_zy.zy02,STATUS,"","ins zy",0)    #No.FUN-660081
          END IF                   #No.MOD-480464
      END IF
 
      MESSAGE 'ins:',l_zy.zy02
   END FOR
 
   INITIALIZE l_zy.* TO NULL
   LET l_zy.zy01=g_zy01
   LET l_zy.zy02=p_key
#  INSERT INTO zy_file VALUES(l_zy.*)        #FUN-5C0057
   INSERT INTO zy_file (zy01,zy02,zy03,zy04,zy05,zy07,
                        zyuser,zygrup,zydate,zyoriu,zyorig)
             VALUES(l_zy.zy01,l_zy.zy02,l_zy.zy03,l_zy.zy04,l_zy.zy05,l_zy.zy07,
                    l_zy.zyuser,l_zy.zygrup,l_zy.zydate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
   MESSAGE 'ins:',l_zy.zy02
 
END FUNCTION
 
FUNCTION p_zy_d()
   DEFINE l_zz01	LIKE zz_file.zz01
   DEFINE l_n           LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE lc_zwacti     LIKE zw_file.zwacti    #MOD-560212
 
   OPEN WINDOW p_zy_k_w WITH FORM "azz/42f/p_zy_k"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_zy_k")
 
   INPUT BY NAME g_zy01,l_zz01 WITHOUT DEFAULTS
 
      AFTER FIELD g_zy01
         IF NOT cl_null(g_zy01) THEN
            SELECT zwacti INTO lc_zwacti FROM zw_file   #MOD-560212
             WHERE zw01=g_zy01
            IF STATUS THEN
               #CALL cl_err('sel zw:',STATUS,1)   #No.FUN-660081
               CALL cl_err3("sel","zw_file",g_zy01,"",STATUS,"","sel zw",1)    #No.FUN-660081
               NEXT FIELD g_zy01
            ELSE                     #MOD-560212
               IF lc_zwacti = "N" THEN
                  CALL cl_err_msg(NULL,"azz-218",g_zy01 CLIPPED,10)
                  NEXT FIELD g_zy01
               END IF
            END IF
         END IF
#        #MOD-560212
#        IF l_zz01 IS NULL THEN
#           SELECT MAX(zx05) INTO l_zz01 FROM zx_file WHERE zx04=g_zy01
#           DISPLAY BY NAME l_zz01
#        END IF
 
      AFTER FIELD l_zz01
         SELECT zz01 FROM zz_file WHERE zz01=l_zz01
         IF STATUS THEN
            #CALL cl_err('sel zz:',STATUS,1)  #No.FUN-660081
            CALL cl_err3("sel","zz_file",l_zz01,"",STATUS,"","sel zz",1)    #No.FUN-660081
            NEXT FIELD l_zz01
         END IF
         # Check 是否有符合資料
         SELECT COUNT(*) INTO l_n FROM zy_file
          WHERE zy01=g_zy01 AND zy02=l_zz01
         IF l_n = 0 THEN
            CALL cl_err('','mfg3382',0) NEXT FIELD l_zz01
         END IF
 
      ON ACTION controlp     #MOD-560212
         CASE
            WHEN INFIELD(g_zy01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zw"
               LET g_qryparam.default1 = g_zy01
               CALL cl_create_qry() RETURNING g_zy01
               DISPLAY g_zy01 TO g_zy01
               NEXT FIELD g_zy01
 
            WHEN INFIELD(l_zz01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zm"
               LET g_qryparam.arg1 = g_lang
               LET g_qryparam.default1 = l_zz01
               CALL cl_create_qry() RETURNING l_zz01
               DISPLAY l_zz01 TO l_zz01
               NEXT FIELD l_zz01
         OTHERWISE EXIT CASE
         END CASE
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
 
      ON ACTION about         #FUN-860033
         CALL cl_about()      #FUN-860033
 
      ON ACTION controlg      #FUN-860033
         CALL cl_cmdask()     #FUN-860033
 
      ON ACTION help          #FUN-860033
         CALL cl_show_help()  #FUN-860033
 
      ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE INPUT
 
   END INPUT
 
   CLOSE WINDOW p_zy_k_w
 
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   BEGIN WORK
 
   IF cl_delete() THEN           #FUN-950105 add
      CALL p_zy_bom_del(0,l_zz01)
      COMMIT WORK
   END IF                        #FUN-950105 add
 
   DISPLAY g_zy01 TO zy01
 
   CALL p_zy_b_fill('1=1')         #單身
 
   CALL p_zy_bp("D")
 
END FUNCTION
 
FUNCTION p_zy_bom_del(p_level,p_key)
  DEFINE p_level     LIKE type_file.num5,    #No.FUN-680135 SMALLINT
         p_key       LIKE zm_file.zm01,      #主件料件編號
         l_sql       STRING,
         l_ac,i      LIKE type_file.num5,    #No.FUN-680135 SMALLINT 
         sr          DYNAMIC ARRAY OF RECORD
             zm01    LIKE zm_file.zm01,
             zm04    LIKE zm_file.zm04,
             zz03    LIKE zz_file.zz03
         END RECORD
 
   IF p_level > 20 THEN CALL cl_err('','mfg2733',1) RETURN END IF
 
   LET p_level = p_level + 1 IF p_level > 20 THEN RETURN END IF
 
    #No.MOD-480464
   LET l_sql = " SELECT zm01,zm04,zz03 FROM zm_file,zz_file ",
               "  WHERE zm01='",p_key CLIPPED,"'",
               "    AND zm04=zz01 "
   PREPARE p_zy_del_pre FROM l_sql
 
   DECLARE p_zy_cs CURSOR FOR p_zy_del_pre
    #No.MOD-480464 (end)
 
   LET l_ac = 1
 
   FOREACH p_zy_cs INTO sr[l_ac].*
      IF STATUS THEN
         CALL cl_err('',STATUS,1)
         EXIT FOREACH
      END IF
      LET l_ac= l_ac + 1
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   FOR i = 1 TO l_ac-1
      IF sr[i].zz03='M' THEN CALL p_zy_bom_del(p_level,sr[i].zm04) END IF
      DELETE FROM zy_file WHERE zy01=g_zy01 AND zy02=sr[i].zm04
      IF STATUS THEN
         #CALL cl_err('del zy:',STATUS,1)  #No.FUN-660081
         CALL cl_err3("del","zy_file",g_zy01,sr[i].zm04,STATUS,"","del zy",1)    #No.FUN-660081
      END IF
      MESSAGE 'del:',sr[i].zm04
   END FOR
 
   DELETE FROM zy_file WHERE zy01=g_zy01 AND zy02=p_key
 
   IF STATUS THEN
      #CALL cl_err('del zy:',STATUS,1)  #No.FUN-660081
      CALL cl_err3("del","zy_file",g_zy01,p_key,STATUS,"","del zy",1)    #No.FUN-660081
   END IF
 
   MESSAGE 'ins:',p_key
 
END FUNCTION
#FUN-970073 start  
FUNCTION p_zy_out()
#DEFINE
#    l_i             LIKE type_file.num5,  #No.FUN-680135 SMALLINT
#    sr              RECORD
#        zy01         LIKE zy_file.zy01,   #類別代號
#        zw02         LIKE zw_file.zw02,   #類別名稱
#        zy02         LIKE zy_file.zy02,   #程式代號
#        zy03         LIKE zy_file.zy03,   
#        zy04         LIKE zy_file.zy04,   #
#        zy05         LIKE zy_file.zy05,   #
#        zy07         LIKE zy_file.zy07,   #
#        gaz03        LIKE gaz_file.gaz03  #程式名稱
#                    END RECORD,
#    l_name          LIKE type_file.chr20, #External(Disk) file name  #No.FUN-680135 VARCHAR(20)
#    l_za05          LIKE za_file.za05
DEFINE l_wc1        LIKE type_file.chr1000   #No.TQC-9A0145
DEFINE  l_cmd       LIKE type_file.chr1000

    #No.TQC-9A0145  --Begin
    LET l_wc1 = g_wc
    IF cl_null(l_wc1) THEN 
       LET l_wc1=" zy01='",g_zy01,"'"   # AND"," zy02='",g_zy.zy02,"'"       
    END IF
    IF l_wc1 IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    LET l_wc1 = l_wc1 , " AND gaz02='",g_lang CLIPPED,"'"
    LET l_cmd = 'p_query "p_zy" "',l_wc1 CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
    #No.TQC-9A0145  --End  
    
END FUNCTION
 
 
##################################################
# Description  	: 批次更新不同CLASS內相同程式的Action設定.
# Date & Author : 2003/11/26 by Hiko
# Parameter   	: none
# Return   	: void
# Memo        	: 只針對zy_file作同步更新的動作.
# Modify   	:
##################################################
FUNCTION act_def_batch()
   DEFINE   ls_comment   STRING
 
 
   LET ls_comment = "Do you want to update all class about " || g_zy[l_ac].zy02 CLIPPED || " action setting ?"
   MENU "Batch Option" ATTRIBUTE(STYLE="dialog", COMMENT=ls_comment)
      ON ACTION accept
         UPDATE zy_file SET zy03=g_zy[l_ac].zy03 WHERE zy02=g_zy[l_ac].zy02
         IF (SQLCA.SQLCODE) THEN
            #CKP
            ERROR "Update zy_file fail."
            ##
         END IF
         
         EXIT MENU
      ON ACTION cancel
         LET INT_FLAG = FALSE
         EXIT MENU               
 
       -- for Windows close event trapped
       ON ACTION close   #ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145   #FUN-9B0145  
           LET g_action_choice = "exit"
           EXIT MENU
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                        
   END MENU
END FUNCTION   
 
#NO.MOD-590329 MARK------------------------
 #No.MOD-580056 --start
#FUNCTION p_zy_set_entry(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("zy01",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_zy_set_no_entry(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("zy01",FALSE)
#   END IF
#END FUNCTION
 
#FUNCTION p_zy_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("zy02",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_zy_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("zy02",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580056 --end
#NO.MOD-590329 MARK--------------------------
 
#FUN-950105---add---start---
FUNCTION p_zy_k2(p_zy01,p_zz01)
    DEFINE p_zy01          LIKE zy_file.zy01,
           p_zz01          LIKE zz_file.zz01,
           l_sql           STRING,
           g_i,j           LIKE type_file.num5,
           l_allow_insert  LIKE type_file.num5,
           l_allow_delete  LIKE type_file.num5,
           l_zm03          LIKE zm_file.zm03,
           l_zm04          LIKE zm_file.zm04,
           l_zz03          LIKE zz_file.zz03,
           l_zz04          LIKE zz_file.zz04,
          #l_zz18          LIKE zz_file.zz18,  #CHI-C80029 mark
          #l_zz19          LIKE zz_file.zz19,  #CHI-C80029 mark
           l_zz32          LIKE zz_file.zz32
 
  #將存在於zm_file裡的程式代表顯示出來，並讓使用者決定是否要做新增的動作
    OPEN WINDOW p_zy_k2_w AT 12,40 WITH FORM "azz/42f/p_zy_k2"
    ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_locale("p_zy_k2")
 
    LET l_sql = "SELECT 'Y',zy02,gaz03 ",
                " FROM zy_file,gaz_file ",
                " WHERE zy01 = '",p_zy01,"'",
                "   AND zy02 = gaz01  AND gaz02 = '",g_lang,"'",
                "   AND zy02 IN (SELECT zm04 FROM zm_file WHERE zm01 = '",p_zz01,"')"
    DECLARE p_zy_k2_cs CURSOR FROM l_sql
    
    CALL g_zz.clear()
    LET g_rec_b=0
    LET g_cnt1 = 1
    FOREACH p_zy_k2_cs INTO g_zz[g_cnt1].*   #單身 ARRAY 填充
       IF sqlca.sqlcode THEN
          CALL cl_err(' FOREACH：', SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt1 = g_cnt1 + 1
 
       IF g_cnt1 > g_max_rec THEN
          CALL cl_err("",9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_zz.deleteElement(g_cnt1)
    LET g_cnt1 = g_cnt1 - 1
 
    #改成INPUT 
    LET g_rec_b = g_cnt1
    LET l_ac = 0
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
 
    INPUT ARRAY g_zz WITHOUT DEFAULTS FROM s_zz.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
       AFTER FIELD select
          IF NOT cl_null(g_zz[l_ac].select) THEN
             IF g_zz[l_ac].select NOT MATCHES "[YN]" THEN
                NEXT FIELD select
             END IF
          END IF
 
       AFTER INPUT
          FOR g_i =1 TO g_rec_b
             IF g_zz[g_i].select = 'Y' AND
                NOT cl_null(g_zz[g_i].gaz01)  THEN
             END IF
          END FOR
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION select_all
          FOR g_i = 1 TO g_rec_b
              LET g_zz[g_i].select="Y"
          END FOR
 
       ON ACTION cancel_all
          FOR g_i = 1 TO g_rec_b
              LET g_zz[g_i].select="N"
          END FOR
 
       AFTER ROW
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
 
    END INPUT
 
    CLOSE WINDOW p_zy_k2_w 
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    FOR j = 1 TO g_zz.getLength()               # 讀BUFFER傳給REPORT
       IF g_zz[j].select = 'Y' THEN
          DELETE FROM zy_file WHERE zy01=g_zy01 AND zy02=g_zz[j].gaz01
 
          SELECT zm03,zm04,zz03,zz04,zz32             #zz18,zz19, CHI-C80029 mark 
            INTO l_zm03,l_zm04,l_zz03,l_zz04,l_zz32   #l_zz18,l_zz19, CHI-C80029 mark 
            FROM zm_file, zz_file 
           WHERE zm04 = g_zz[j].gaz01 
             AND zm04 = zz01 
             AND zm01 = p_zz01
         
          INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,
                               zyuser,zygrup,zydate,zyoriu,zyorig)
                 VALUES(g_zy01,l_zm04,l_zz04,'0','0',l_zz32,        #CHI-C80029 mod l_zz18,l_zz19 ->0
                        g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.SQLCODE THEN                           
              IF NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN   
                CALL cl_err3("ins","zy_file",g_zy01,l_zm04,STATUS,"","ins zy",0)    
              END IF                   
          END IF
 
          MESSAGE 'ins:',l_zm04
       END IF
    END FOR
 
END FUNCTION
#FUN-950105---add---end---
