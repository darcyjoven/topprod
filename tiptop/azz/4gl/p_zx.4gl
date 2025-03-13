# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: p_zx.4gl
# Descriptions...: 使用者基本資料
# Date & Author..: 02/05/31 By LYS
# Modify.........: 04/09/15 新增 controlp 開窗函式
# Modify.........: No.MOD-4A0030 04/10/05 By alex 新增限制 
# Modify.........: No.FUN-4B0044 04/11/15 By alex 新增異動 zx08 時與 zxy_file 連動
# Modify.........: No.FUN-4C0040 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.MOD-510008 05/01/05 By alex 修改 copy 功能
# Modify.........: No.FUN-510050 05/01/28 By Pengu 報表轉XML
# Modify.........: No.MOD-530094 05/03/14 By alex 增加串接說明
# Modify.........: No.FUN-530027 05/03/21 By alex 增加多語系控制功能,為方便搜詢,併入77
# Modify.........: No.MOD-540068 05/04/21 By saki check 4sm若目錄無填寫不再呼叫cl_create_4sm
# Modify.........: No.FUN-550077 05/05/20 By alex 加多語系顯示更新等功能
# Modify.........: No.MOD-560212 05/07/01 By alex 增加檢查 zwacti
# Modify.........: No.MOD-5B0313 05/07/01 By kim "使用者目錄"開窗畫面無法下查詢條件
# Modify.........: No.TQC-610001 06/01/02 By alex 刪除時說明並一起刪除zxy,zxw資料
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-660169 06/08/04 By saki 增加語言別切換控制選項
# Modify.........: No.FUN-680135 06/09/19 欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By johnray l_time轉g_time
# Modify.........: No.FUN-660048 07/01/05 By Echo 增加維護Express權限功能的button
# Modify.........: No.TQC-6C0060 07/01/08 By alexstar 多語言功能單純化
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-830011 08/03/19 By alex 密碼更新相關功能新增
# Modify.........: No.FUN-830081 08/03/21 By alex 取消gem_file檢查不到時next field
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-870142 08/08/18 By alex 調整zxacti相關功能
# Modify.........: No.FUN-880115 08/08/28 By alexstar 當輸入完 zx04 後將 zw03 帶入 zx05
# Modify.........: NO.FUN-890113 08/11/17 By kevin MDM整合
# Modify.........: NO.FUN-910094 09/01/20 By alex 新增zx10編碼機制
# Modify.........: NO.FUN-920182 09/02/25 By alex 放大實際欄位長但限制最大輸入為20
# Modify.........: NO.FUN-930042 09/03/06 By alex 新增強制使用者變更zx10選項
# Modify.........: NO.MOD-950128 09/05/15 By sabrina 更改時，zx01不能做修改
# Modify.........: NO.FUN-940126 09/06/18 By Hiko 複製時要設定newno給zx10
# Modify.........: NO.FUN-970073 09/07/21 By Kevin 把老報表改成p_query
# Modify.........: No.FUN-980025 09/08/05 By dxfwo   集團架構改善
# Modify.........: No.FUN-9A0024 09/10/13 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-A10126 10/01/14 By liuxqa 重新过单FUN-9B0145 
# Modify.........: No.FUN-A10092 10/01/15 By tsai_yen 使用者營運中心階層查詢
# Modify.........: No.FUN-A50080 10/05/21 By Hiko 移除關於azwa_file的設定
# Modify.........: NO:MOD-AA0132 10/10/21 By Dido 修改後無法複製 
# Modify.........: NO.TQC-B10159 11/01/14 By alex 設定newno給zx10要使用編碼機制
# Modify.........: NO.MOD-B40146 11/05/10 By vampire 串查程式無法使用
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B50210 11/05/25 BY sabrina 複製功能有問題
# Modify.........: No.FUN-B60105 11/06/22 By tsai_yen 移除"使用者營運中心階層查詢"
# Modify.........: No.MOD-B90138 11/09/22 By johung 修正密碼修改後不會更新zx16的問題
# Modify.........: No.FUN-C10004 12/01/02 By tsai_yen GP5.3 GWC&GDC開發區合併
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-CC0110 12/12/19 By LeoChang p_zx修改權限時避免資料重覆

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_zx                RECORD LIKE zx_file.*
DEFINE g_zx_t              RECORD LIKE zx_file.*
DEFINE g_zx01_t            LIKE zx_file.zx01
DEFINE g_wc                STRING
DEFINE g_sql               STRING
DEFINE g_redomenu_zx05     LIKE zx_file.zx05
DEFINE g_forupd_sql        STRING                #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10  #No.FUN-680135 INTEGER   
DEFINE g_i                 LIKE type_file.num5   #No.FUN-680135 SMALLINT #count/index for any purpose
DEFINE g_msg               LIKE type_file.chr1000#No.FUN-680135 VARCHAR(72)
DEFINE g_redo_all_menu     LIKE type_file.num5   #No.FUN-680135 SMALLINT #是否執行redo_all_menu
DEFINE g_change_menu_cnt   LIKE type_file.num5   #No.FUN-680135 SMALLINT
DEFINE g_change_menu       DYNAMIC ARRAY OF RECORD
         menu_name            LIKE zm_file.zm01
                           END RECORD
DEFINE g_row_count         LIKE type_file.num10, #No.FUN-680135 INTEGER
       g_curs_index        LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE g_jump              LIKE type_file.num10, #No.FUN-680135 INTEGER
       g_no_ask            LIKE type_file.num5   #No.FUN-680135 SMALLINT #FUN-6A0080
DEFINE g_on_change         LIKE type_file.num5   #No.FUN-680135 SMALLINT #FUN-550077
DEFINE g_u_flag            LIKE type_file.chr1   #FUN-890113
DEFINE g_before_input_done   LIKE type_file.num5    #No.FUN-680135 SMALLINT #MOD-950128 add
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
 
#  LET g_redo_all_menu = FALSE   #預設不執行redo_all_menu
 
   INITIALIZE g_zx.* TO NULL
   INITIALIZE g_zx_t.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM zx_file WHERE zx01 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zx_curl CURSOR FROM g_forupd_sql

   ###FUN-C10004 START ###
   LET g_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzx_file",
                        "(wzx01,wzx02,wzx03,wzx04,wzx05,",
                        "wzx06,wzx07,wzx08,wzx10,",
                        "wzxuser,wzxgrup,wzxmodu,wzxdate,wzxacti)",
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
   PREPARE p_zx_ins_wzx_pre01 FROM g_sql

   LET g_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzy_file(wzy01,wzy02,wzy03)",
                    " VALUES(?,?,?)"
   PREPARE p_zx_wzy_ins_pre1 FROM g_sql

   LET g_forupd_sql = "SELECT wzx01 FROM ",s_dbstring("wds") CLIPPED,"wzx_file WHERE wzx01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zx_wzx_curl CURSOR FROM g_forupd_sql

   LET g_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzx_file",
               " SET wzx01 = ? ,wzx02 = ? ,wzx03 = ? ,wzx04 = ? ,wzx05 = ? ,",
                   " wzx06 = ? ,wzx07 = ? ,wzx08 = ? ,",
                   " wzxuser = ? ,wzxgrup = ? ,wzxmodu = ? ,wzxdate = ? ,wzxacti = ?",
               " WHERE wzx01 = ?"
   PREPARE p_zx_wzx_upd_pre01 FROM g_sql

   LET g_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzy_file SET wzy03=?",
                " WHERE wzy01=? AND wzy02=? AND wzy03=?"
   PREPARE p_zx_wzy_upd_pre FROM g_sql
   ###FUN-C10004 END ###

   #FUN-CC0110 -start-
   LET g_sql = "DELETE FROM ",s_dbstring("wds") clipped,"wzy_file",
                " WHERE wzy01=? AND wzy02=? AND wzy03=?"
   PREPARE p_zx_wzy_del_pre1 FROM g_sql
   #FUN-CC0110 --end--
   
   OPEN WINDOW p_zx_w WITH FORM "azz/42f/p_zx"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   # 2004/05/24 新增語言別選項
   CALL cl_set_combo_lang("zx06")
 
   LET g_change_menu_cnt = 1
   LET g_change_menu[g_change_menu_cnt].menu_name = " "
 
   CALL p_zx_menu()
 
   CLOSE WINDOW p_zx_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
FUNCTION p_zx_curs()
 
   CLEAR FORM
   CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件  #FUN-910094 zx10不要做construct
       zx01,zx02,zx03,zx04,zx05,zx11,zx12,zx07,zx08,zx09,#zx10, #FUN-830011
       zx19,zx18,zx15,zx06,  #No.FUN-660169 FUN-930042
       zxacti,zxuser,zxgrup,zxmodu,zxdate  #FUN-870142
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(zx01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_zx"
               LET g_qryparam.state ="c"
               LET g_qryparam.default1 = g_zx.zx01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO zx01
 
            WHEN INFIELD(zx03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.state ="c"
               LET g_qryparam.default1 = g_zx.zx03
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO zx03
 
            WHEN INFIELD(zx04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_zw"
               LET g_qryparam.state ="c"
               LET g_qryparam.default1 = g_zx.zx04
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO zx04
 
            WHEN INFIELD(zx05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_menu"
               LET g_qryparam.state ="c"
              #LET g_qryparam.construct ="N" #MOD-5B0313
               LET g_qryparam.arg1 = g_lang CLIPPED
               LET g_qryparam.default1 = g_zx.zx05
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO zx05
 
            WHEN INFIELD(zx08)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.state ="c"
               LET g_qryparam.construct ="N"
               LET g_qryparam.default1 = g_zx.zx08
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO zx08
 
            WHEN INFIELD(zx11)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gbk"
               LET g_qryparam.state ="c"
               LET g_qryparam.construct ="N"
               LET g_qryparam.default1 = g_zx.zx11
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO zx11
 
         END CASE
 
      ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('zxuser', 'zxgrup') #FUN-980030
 
   #資料權限的檢查
   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND zxuser = '",g_user,"'"
   END IF
 
   IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET g_wc = g_wc clipped," AND zxgrup = '",g_grup,"'"
   END IF
   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET g_wc = g_wc clipped," AND zxgrup IN ",cl_chk_tgrup_list()
   END IF
 
   LET g_sql="SELECT zx01 FROM zx_file ", # 組合出 SQL 指令
             " WHERE ",g_wc CLIPPED, " ORDER BY zx01"
 
  #IF g_aza.aza44 = "Y" THEN #FUN-550077  #TQC-6C0060 mark
  #   CALL cl_itemname_construct(g_sql,"zx_file","zx02","zx01") RETURNING g_sql
  #END IF
 
   PREPARE p_zx_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE p_zx_curs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR p_zx_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM zx_file WHERE ",g_wc CLIPPED
   PREPARE p_zx_precount FROM g_sql
   DECLARE p_zx_count CURSOR FOR p_zx_precount
 
END FUNCTION
 
FUNCTION p_zx_menu()
 
    MENU ""
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL cl_set_comp_visible("user_unlock",TRUE)
 
      ON ACTION insert             #"A.輸入" HELP 32001
          LET g_action_choice="insert"
          IF cl_chk_act_auth() THEN
               CALL p_zx_a()
          END IF
 
      ON ACTION query              #"Q.查詢" HELP 32002
          LET g_action_choice="query"
          IF cl_chk_act_auth() THEN
               CALL p_zx_q()
          END IF
 
      ON ACTION modify             #"U.更改" HELP 32005
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
               CALL p_zx_u()
          END IF
 
      ON ACTION next             #"N.下筆" HELP 32003
          CALL p_zx_fetch('N') 
 
      ON ACTION previous           #"P.上筆" HELP 32004
          CALL p_zx_fetch('P')
 
      ON ACTION delete             #"R.取消" HELP 32006
          LET g_action_choice="delete"
          IF cl_chk_act_auth() THEN
               CALL p_zx_r()
          END IF
 
      ON ACTION reproduce          #"C.複製" HELP 32008
          LET g_action_choice="reproduce"
          IF cl_chk_act_auth() THEN
               CALL p_zx_copy()
          END IF
 
      ON ACTION output             #"O.列印" HELP 32009
          LET g_action_choice="output"
          IF cl_chk_act_auth() THEN
             CALL p_zx_out()
          END IF
 
      ON ACTION invalid           #FUN-870142
          LET g_action_choice="invalid"
          IF cl_chk_act_auth() THEN
             CALL p_zx_x()
          END IF
 
      ON ACTION help               #"H.說明" HELP 10102
          CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         #CALL cl_show_fld_cont()                   #FUN-550037 hmf  #TQC-6C0060 mark
         # 2004/05/24 新增語言別選項
         CALL cl_set_combo_lang("zx06")
         CALL cl_show_fld_cont()                    #FUN-550077
 
      ON ACTION exit               #"Esc.結束"
         IF g_change_menu.getLength() > 0 AND 
            NOT cl_null(g_change_menu[1].menu_name) THEN
            CALL p_zx_redo_menu(FALSE)
         END IF
         LET g_action_choice="exit"
         EXIT MENU
 
      ON ACTION direction     #"M.目錄"
         IF NOT cl_null(g_zx.zx01) AND NOT cl_null(g_zx.zx05) THEN
            LET g_msg="p_zm ",g_zx.zx05
            CALL cl_cmdrun(g_msg)
         END IF
 
      ON ACTION redo_all_menu
         CALL p_zx_redo_all_menu()
 
      ON ACTION maintain_zxy          #MOD-490468
         IF NOT cl_null(g_zx.zx01) THEN
            LET g_msg="p_zxy ",g_zx.zx01
            CALL cl_cmdrun(g_msg)
         END IF
        
      ###FUN-A10092 START ###   #FUN-B60105 mark
      #ON ACTION azwa_tree             #使用者營運中心階層查詢
      #   IF NOT cl_null(g_zx.zx01) THEN
      #      LET g_msg="p_azwa ",g_zx.zx01
      #      CALL cl_cmdrun(g_msg)
      #   END IF
      ###FUN-A10092 END ###
 
      ON ACTION maintain_zxw          #MOD-4A0030
        IF NOT cl_null(g_zx.zx01) THEN
           LET g_msg="p_zxw ",g_zx.zx01
           CALL cl_cmdrun(g_msg)
        END IF
 
      ON ACTION express_biy            #"維護Express報表權限"  #FUN-660048
          LET g_action_choice="express_biy"
          IF cl_chk_act_auth() THEN
             LET g_msg="p_biy ",g_zx.zx01
             CALL cl_cmdrun(g_msg)
          END IF              
 
      ON ACTION jump               #KEY('/')
          CALL p_zx_fetch('/')
 
      ON ACTION first              #KEY(F)
          CALL p_zx_fetch('F')
 
      ON ACTION last               #KEY(L)
          CALL p_zx_fetch('L')
 
      ON ACTION controlg           #KEY(CONTROL-G)
          CALL cl_cmdask()
 
       -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            #No.MOD-540068 --start--
           IF g_change_menu.getLength() > 0 AND 
              NOT cl_null(g_change_menu[1].menu_name) THEN
              CALL p_zx_redo_menu(FALSE)
           END IF
            #No.MOD-540068 ---end---
           LET g_action_choice = "exit"
           EXIT MENU
                        
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION user_unlock
          CALL p_zx10_user_unlock()

     #MOD-B40146---add---start---
      &include "qry_string.4gl"
     #MOD-B40146---add---end-----
                        
   END MENU
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL cl_set_comp_visible("user_unlock",FALSE)
END FUNCTION
 
 
FUNCTION p_zx10_user_unlock()
 
    DEFINE li_gbt10   LIKE gbt_file.gbt10   #FUN-930042
 
    IF cl_null(g_zx.zx01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    BEGIN WORK
    ###FUN-C10004 START ###
    OPEN p_zx_wzx_curl USING g_zx.zx01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_zx.zx01,SQLCA.sqlcode,1)
       RETURN
    END IF
    FETCH p_zx_wzx_curl INTO g_zx.zx01               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
       RETURN
    END IF
    ###FUN-C10004 END ###
    OPEN p_zx_curl USING g_zx.zx01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_zx.zx01,SQLCA.sqlcode,1)
       RETURN
    END IF
 
    FETCH p_zx_curl INTO g_zx.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
       RETURN
    ELSE
      IF g_zx.zx20 IS NULL THEN
         LET g_zx.zx20 = 0
      END IF
    END IF
 
    SELECT gbt10 INTO li_gbt10 FROM gbt_file WHERE gbt00="0" 
    IF STATUS OR li_gbt10 IS NULL THEN LET li_gbt10 = 0 END IF
    IF li_gbt10 > 0 AND g_zx.zx20 >= li_gbt10 THEN
       LET g_zx.zx20 = 0
       UPDATE zx_file SET zx20 = g_zx.zx20 
        WHERE zx01 = g_zx.zx01
       DISPLAY g_zx.zx20,"N" TO zx20,FORMONLY.locked
    END IF
    COMMIT WORK

    CLOSE p_zx_wzx_curl   #FUN-C10004
    CLOSE p_zx_curl
 
END FUNCTION
 
 
 
FUNCTION p_zx_redo_all_menu()
 
#   MESSAGE "Redo all menus will take very long time,Please wait or click 'Cancel' for leave"
 
    IF NOT cl_confirm("azz-048") THEN
       RETURN
    END IF
 
    DECLARE zx05_all_curs CURSOR FOR
       SELECT UNIQUE(zx05) FROM zx_file
    FOREACH zx05_all_curs INTO g_redomenu_zx05
       IF SQLCA.sqlcode THEN
          CALL cl_err('OPEN zx05_all_curs:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
        IF NOT cl_null(g_redomenu_zx05) THEN            #No.MOD-540068
          CALL cl_create_4sm(g_redomenu_zx05, FALSE)
       END IF
    END FOREACH
 
    CLOSE p_zx_curs
END FUNCTION
 
PRIVATE FUNCTION p_zx_a()
 
   DEFINE li_zx08    LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE lc_gbt07   LIKE gbt_file.gbt07   #FUN-910094
 
   MESSAGE ""
   CLEAR FORM                              # 清螢墓欄位內容
   INITIALIZE g_zx.* LIKE zx_file.*
   INITIALIZE g_zx_t.* LIKE zx_file.*      #FUN-920182
   LET g_zx.zx06 = '0'
   LET g_zx.zx07 = 'N'
   LET g_zx.zx12 = 'N'
   LET g_zx.zx15 = '3'                     #FUN-660169
   LET g_zx.zx16 = g_today                 #FUN-830011
   LET g_zx.zx17 = "0"                     #FUN-830011
   LET g_zx.zx19 = "Y"                     #FUN-930042
   LET g_zx.zxacti = "Y"                   #FUN-870142
   LET g_zx01_t = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_zx.zxuser = g_user
      LET g_zx.zxgrup = g_grup               #使用者所屬群
      LET g_zx.zxdate = g_today
 
      CALL p_zx_i("a")                      # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF g_zx.zx01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
#    #FUN-550077
     #IF g_aza.aza44 = "Y" THEN  #TQC-6C0060 mark
     #   CALL cl_itemname_switch(1,"zx_file","zx02",g_zx.zx01,g_zx.zx02) RETURNING g_zx.zx02
     #END IF
 
      LET g_zx.zx10 = cl_user_encode(g_zx.zx10)    #FUN-910094
 
      LET g_zx.zxoriu = g_user      #No.FUN-980030 10/01/04
      LET g_zx.zxorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO zx_file VALUES(g_zx.*)       # DISK WRITE
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("ins","zx_file",g_zx.zx01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
         CONTINUE WHILE
      ELSE
         ###FUN-C10004 START ###
         EXECUTE p_zx_ins_wzx_pre01 USING g_zx.zx01,g_zx.zx02,g_zx.zx06,g_zx.zx08,g_zx.zx03,
                                      g_zx.zx10,g_zx.zx09,g_zx.zx16,'',
                                      g_zx.zxuser,g_zx.zxgrup,g_zx.zxmodu,g_zx.zxdate,g_zx.zxacti
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","wzx_file",g_zx.zx01,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
         END IF
         ###FUN-C10004 END ###
         
         IF g_aza.aza44 = "Y" THEN
            CALL cl_itemname_switch(2,"zx_file","zx02",g_zx.zx01,g_zx.zx02) RETURNING g_zx.zx02
         END IF
         LET g_zx_t.* = g_zx.*                # 保存上筆資料
         SELECT zx01 INTO g_zx.zx01 FROM zx_file
          WHERE zx01 = g_zx.zx01
 
         LET li_zx08 = 0
         SELECT COUNT(*) INTO li_zx08 FROM zxy_file
          WHERE zxy01=g_zx.zx01 AND zxy03=g_zx.zx08
          IF li_zx08 = 0 AND NOT cl_null(g_zx.zx08) THEN  #MOD-490468
            CALL cl_err_msg(NULL, "azz-072", g_zx.zx01 CLIPPED || "|" || g_zx.zx08 CLIPPED,10)
            INSERT INTO zxy_file(zxy01,zxy02,zxy03) 
             VALUES(g_zx.zx01,g_zx.zx02,g_zx.zx08)
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zx.zx08,SQLCA.sqlcode,1)  #No.FUN-660081
               CALL cl_err3("ins","zxy_file",g_zx.zx01,g_zx.zx08,SQLCA.sqlcode,"","",1)    #No.FUN-660081               
            ELSE #FUN-C10004
               ###FUN-C10004 START ###
               EXECUTE p_zx_wzy_ins_pre1 USING g_zx.zx01,'2',g_zx.zx08
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("ins","wzy_file",g_zx.zx01,g_zx.zx08,SQLCA.sqlcode,"","",1)
               END IF
               ###FUN-C10004 END ###
            END IF
         END IF
         #CALL s_ins_auth_plant(g_zx.zx01)         #No.FUN-980025 #FUN-A50080
         #FUN-890113 start
         CASE aws_mdmdata('zx_file','insert',g_zx.zx01,base.TypeInfo.create(g_zx),'CreateUserData')
              WHEN 0  #無與 MDM 整合
                   CALL cl_msg('INSERT O.K')                   
              WHEN 1  #呼叫 MDM 成功
                   CALL cl_msg('INSERT O.K, INSERT MDM O.K')                   
              WHEN 2  #呼叫 MDM 失敗                   
         END CASE
         #FUN-890113 end 
      END IF
 
      EXIT WHILE
   END WHILE
   LET g_wc=' '
 
END FUNCTION
 
FUNCTION p_zx_i(p_cmd)
 
   DEFINE p_cmd           LIKE type_file.chr1,  #No.FUN-680135 VARCHAR(1)
          l_n             LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE lc_gem02        LIKE gem_file.gem02   #MOD-530094
   DEFINE lc_zw02         LIKE zw_file.zw02     #MOD-560212
   DEFINE lc_zwacti       LIKE zw_file.zwacti   #MOD-560212
   DEFINE ls_tmp          STRING                #FUN-920182
 
   DISPLAY BY NAME g_zx.zx20,g_zx.zxuser,g_zx.zxgrup,g_zx.zxdate,g_zx.zxmodu 
   DISPLAY BY NAME g_zx.zx01 THRU g_zx.zx09 
 
   LET g_on_change = TRUE   #FUN-550077
 
   INPUT BY NAME g_zx.zx01,g_zx.zx02,
                 g_zx.zx03,g_zx.zx04,g_zx.zx05,g_zx.zx11,
                 g_zx.zx12,g_zx.zx07,g_zx.zx08,g_zx.zx09,g_zx.zx10,g_zx.zx19,
                 g_zx.zx18,             #FUN-830011
                 g_zx.zx15,g_zx.zx06    #No.FUN-660169
       WITHOUT DEFAULTS 
 
      #MOD-950128---add---start---
       BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_zx_set_entry(p_cmd)
         CALL p_zx_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
      #MOD-950128---add---end---
 
       AFTER FIELD zx01
          IF NOT cl_null(g_zx.zx01) THEN
             IF p_cmd = "a" OR (p_cmd = "u" AND g_zx.zx01 != g_zx01_t) THEN
                SELECT count(*) INTO l_n FROM zx_file
                 WHERE zx01 = g_zx.zx01
                IF l_n > 0 THEN                  # Duplicated
                   CALL cl_err(g_zx.zx01,-239,0)
                   LET g_zx.zx01 = g_zx01_t
                   DISPLAY BY NAME g_zx.zx01 
                   NEXT FIELD zx01
                END IF
             END IF
             IF p_cmd = "a" THEN           #FUN-930042
                LET g_zx.zx10 = g_zx.zx01
                DISPLAY BY NAME g_zx.zx10 
             END IF
          END IF
 
       AFTER FIELD zx03
          LET lc_gem02 = ""
          IF NOT cl_null(g_zx.zx03) THEN
#            #MOD-530094
             SELECT gem02 INTO lc_gem02 FROM gem_file WHERE gem01=g_zx.zx03
             IF STATUS THEN
                #CALL cl_err('select '||g_zx.zx03||" ",STATUS,0)  #No.FUN-660081
                CALL cl_err3("sel","gem_file",g_zx.zx03,"",STATUS,"","select "||g_zx.zx03,0)    #No.FUN-660081
#               #FUN-830081
                LET lc_gem02 = "(",g_dbs CLIPPED,") ",cl_getmsg("agl-003",g_lang) CLIPPED
#               NEXT FIELD zx03
#            ELSE
             END IF
             DISPLAY lc_gem02 TO gem02   #FUN-830081
          END IF
 
       AFTER FIELD zx04
          LET lc_zw02 = ""
          IF NOT cl_null(g_zx.zx04) THEN
             IF cl_null(g_zx.zx05) THEN  #FUN-880115
                SELECT zw03 INTO g_zx.zx05 FROM zw_file WHERE zw01=g_zx.zx04
                DISPLAY g_zx.zx05 TO zx05
             END IF
#            #MOD-530094  MOD-560212
             SELECT zw02,zwacti INTO lc_zw02,lc_zwacti FROM zw_file
              WHERE zw01=g_zx.zx04
             IF STATUS THEN
                #CALL cl_err('select '||g_zx.zx04||" ",STATUS,0)  #No.FUN-660081
                CALL cl_err3("sel","zw_file",g_zx.zx04,"",STATUS,"","select "||g_zx.zx04,0)    #No.FUN-660081
                NEXT FIELD zx04
             ELSE
                IF lc_zwacti != "Y" THEN   #MOD-560212
                   CALL cl_err_msg(NULL,"azz-218",g_zx.zx04 CLIPPED,10)
                   LET g_zx.zx04 = g_zx_t.zx04
                   DISPLAY g_zx.zx04 TO zx04
                   NEXT FIELD zx04
                END IF
                DISPLAY lc_zw02 TO zw02
             END IF
             IF g_zx.zx05 IS NULL THEN
                LET g_zx.zx05=g_msg
                DISPLAY BY NAME g_zx.zx05
             END IF
          END IF
 
        AFTER FIELD zx05  #MOD-4B0310
          IF NOT cl_null(g_zx.zx05) THEN
             SELECT zz01 FROM zz_file WHERE zz01=g_zx.zx05 AND zz011="MENU"
             IF STATUS THEN
                #CALL cl_err("select "||g_zx.zx05||" ",STATUS,0)  #No.FUN-660081
                CALL cl_err3("sel","zz_file",g_zx.zx05,"",STATUS,"","select "||g_zx.zx05,0)    #No.FUN-660081
                NEXT FIELD zx05
             END IF
          END IF
 
        AFTER FIELD zx07   #MOD-4B0310
          IF g_zx.zx07 = "N" THEN
             SELECT COUNT(*) INTO l_n FROM zxy_file WHERE zxy01=g_zx.zx01
             IF l_n > 1 THEN 
                CALL cl_err_msg(NULL,"azz-057",g_zx.zx01 CLIPPED,10)
                NEXT FIELD zx07
             END IF
          END IF
 
        AFTER FIELD zx08   #MOD-490468
          IF NOT cl_null(g_zx.zx08) THEN
             SELECT azp01 FROM azp_file WHERE azp01=g_zx.zx08
             IF STATUS THEN
                #CALL cl_err("select "||g_zx.zx08||" ",STATUS,0)  #No.FUN-660081
                CALL cl_err3("sel","azp_file",g_zx.zx08,"",STATUS,"","select "||g_zx.zx08,0)    #No.FUN-660081
                NEXT FIELD zx08
             END IF
          END IF
 
       AFTER FIELD zx10   #FUN-920182
          IF NOT cl_null(g_zx.zx10) THEN
             IF g_zx.zx10 <> g_zx_t.zx10 THEN
                LET ls_tmp = g_zx.zx10
                IF ls_tmp.getLength() > 20 THEN
                   CALL cl_err("Maximum Length Should Be < 20","!",1)
                   NEXT FIELD zx10
                END IF
                LET g_zx.zx19 = "Y"           #FUN-930042
                DISPLAY BY NAME g_zx.zx19 
             END IF
          END IF
 
       AFTER FIELD zx11
          IF NOT cl_null(g_zx.zx11) THEN
             SELECT count(*) INTO l_n FROM gbk_file WHERE gbk01 = g_zx.zx11
             IF l_n<=0 OR l_n is null OR STATUS THEN
                CALL cl_err("select "||g_zx.zx11||" ",STATUS,0)
                NEXT FIELD zx11
             END IF
          END IF
 
#      #FUN-550077
       ON CHANGE zx02
          IF g_aza.aza44 = "Y" THEN
            #CALL cl_itemname_modcurr("zx_file","zx02",g_zx.zx01,g_zx.zx02) RETURNING g_i  #TQC-6C0060 mark
             IF g_zx14 = "Y" AND g_on_change THEN
               #CALL p_itemname_update("zx_file","zx02",g_zx.zx01,g_zx.zx02) RETURNING g_zx.zx02  #TQC-6C0060 mark
                CALL p_itemname_update("zx_file","zx02",g_zx.zx01) #TQC-6C0060 
               #DISPLAY g_zx.zx02 TO zx02  #TQC-6C0060 mark
                CALL cl_show_fld_cont()   #TQC-6C0060 
             END IF
          END IF
 
#      #FUN-550077
       ON ACTION update_item
          IF g_aza.aza44 = "Y" THEN
             CALL GET_FLDBUF(zx02) RETURNING g_zx.zx02
            #CALL p_itemname_update("zx_file","zx02",g_zx.zx01,g_zx.zx02) RETURNING g_zx.zx02  #TQC-6C0060 mark
             CALL p_itemname_update("zx_file","zx02",g_zx.zx01) #TQC-6C0060
             LET g_on_change=FALSE
            #DISPLAY g_zx.zx02 TO zx02  #TQC-6C0060 mark
             CALL cl_show_fld_cont()   #TQC-6C0060 
          ELSE
             CALL cl_err(g_zx.zx02,"lib-151",1)
          END IF
 
       ON ACTION controlo                        # 沿用所有欄位
          IF INFIELD(zx01) THEN
             LET g_zx.* = g_zx_t.*
             #No.FUN-9A0024--begin
             #DISPLAY BY NAME g_zx.* 
             DISPLAY BY NAME g_zx.zx01,g_zx.zx02,g_zx.zx03,g_zx.zx04,g_zx.zx05,g_zx.zx06,
                             g_zx.zx07,g_zx.zx08,g_zx.zx09,g_zx.zx10,g_zx.zx11,g_zx.zx12,
                             g_zx.zx15,g_zx.zx19,g_zx.zx20,g_zx.zxacti,g_zx.zx16,g_zx.zx17,            
                             g_zx.zx18,g_zx.zxuser,g_zx.zxgrup,g_zx.zxdate,g_zx.zxmodu,
                             g_zx.zxoriu,g_zx.zxorig    
             #No.FUN-9A0024--end                         
             NEXT FIELD zx01
          END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(zx01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zx"
               LET g_qryparam.default1 = g_zx.zx01
               CALL cl_create_qry() RETURNING g_zx.zx01
               DISPLAY g_zx.zx01 TO zx01
 
            WHEN INFIELD(zx03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_zx.zx03
               CALL cl_create_qry() RETURNING g_zx.zx03
               DISPLAY g_zx.zx03 TO zx03
 
            WHEN INFIELD(zx04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zw"
               LET g_qryparam.default1 = g_zx.zx04
               CALL cl_create_qry() RETURNING g_zx.zx04
               DISPLAY g_zx.zx04 TO zx04
 
            WHEN INFIELD(zx05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_menu"
               LET g_qryparam.default1 = g_zx.zx05
              #LET g_qryparam.construct ="N" #MOD-5B0313
               LET g_qryparam.arg1 = g_lang CLIPPED
               CALL cl_create_qry() RETURNING g_zx.zx05
               DISPLAY g_zx.zx05 TO zx05
 
            WHEN INFIELD(zx08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.construct ="N"
               LET g_qryparam.default1 = g_zx.zx08
               CALL cl_create_qry() RETURNING g_zx.zx08
               DISPLAY g_zx.zx08 TO zx08
 
            WHEN INFIELD(zx11)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gbk"
               LET g_qryparam.default1 = g_zx.zx11
               LET g_qryparam.construct ="N"
               CALL cl_create_qry() RETURNING g_zx.zx11
               DISPLAY g_zx.zx11 TO zx11
         END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION controlz
          CALL cl_show_req_fields()
 
       ON ACTION controlf                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
   END INPUT
 
END FUNCTION
 
FUNCTION p_zx_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL p_zx_curs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
 
   OPEN p_zx_count
   FETCH p_zx_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN p_zx_curs                            # 從DB產生合乎條件TEMP(0-30秒)
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
      INITIALIZE g_zx.* TO NULL
   ELSE
      CALL p_zx_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION p_zx_fetch(p_flzx)
 
   DEFINE p_flzx  LIKE type_file.chr1   #No.FUN-680135 VARCHAR(1)
 
   CASE p_flzx
      WHEN 'N' FETCH NEXT     p_zx_curs INTO g_zx.zx01
      WHEN 'P' FETCH PREVIOUS p_zx_curs INTO g_zx.zx01
      WHEN 'F' FETCH FIRST    p_zx_curs INTO g_zx.zx01
      WHEN 'L' FETCH LAST     p_zx_curs INTO g_zx.zx01
      WHEN '/'
         IF (NOT g_no_ask) THEN   #FUN-6A0080
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
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               RETURN
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_zx_curs INTO g_zx.zx01
         LET g_no_ask = FALSE    #FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
      INITIALIZE g_zx.* TO NULL  #TQC-6B0105
      LET g_zx.zx01 = NULL      #TQC-6B0105
      RETURN
   ELSE
      CASE p_flzx
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
 
   SELECT * INTO g_zx.* FROM zx_file            # 重讀DB,因TEMP有不被更新特性
    WHERE zx01 = g_zx.zx01
 
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("sel","zx_file",g_zx.zx01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
   ELSE                                      #FUN-4C0040權限控管
      #FUN-550077  #TQC-6C0060 mark
     #IF g_aza.aza44 = "Y" AND NOT cl_null(g_zx.zx02) THEN 
     #   CALL cl_itemname_by_lang("zx_file","zx02",g_zx.zx01 CLIPPED,g_lang,g_zx.zx02) RETURNING g_zx.zx02
     #END IF
      IF g_zx.zx19 IS NULL OR g_zx.zx19 <> "Y" THEN   #FUN-930042
         LET g_zx.zx19 = "N"
      END IF
      IF g_zx.zx20 IS NULL THEN
         LET g_zx.zx20 = 0
      END IF
      LET g_data_owner=g_zx.zxuser
      LET g_data_group=g_zx.zxgrup
      CALL p_zx_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION p_zx_show()
 
   DEFINE lc_gem02   LIKE gem_file.gem02   #MOD-530094
   DEFINE li_gbt10   LIKE gbt_file.gbt10   #FUN-930042
 
   LET g_zx_t.* = g_zx.*
 
   DISPLAY BY NAME g_zx.zx01,g_zx.zx02,g_zx.zx03,g_zx.zx04,g_zx.zx05,g_zx.zx06,
                   g_zx.zx07,g_zx.zx08,g_zx.zx09,g_zx.zx10,g_zx.zx11,g_zx.zx12,
                   g_zx.zx15,g_zx.zx19,g_zx.zx20,             #FUN-660169 FUN-930042
                   g_zx.zxacti,g_zx.zx16,g_zx.zx17,g_zx.zx18, #FUN-830011
                   g_zx.zxuser,g_zx.zxgrup,g_zx.zxdate,g_zx.zxmodu,
                   g_zx.zxoriu,g_zx.zxorig                    #No.FUN-9A0024 
 
   #MOD-530094
   LET lc_gem02 = ""
   SELECT gem02 INTO lc_gem02 FROM gem_file WHERE gem01=g_zx.zx03
   IF SQLCA.sqlcode THEN  #FUN-830081
      LET lc_gem02 = "(",g_dbs CLIPPED,") ",cl_getmsg("agl-003",g_lang) CLIPPED
   END IF
   DISPLAY lc_gem02 TO gem02
   LET lc_gem02 = ""
   SELECT zw02 INTO lc_gem02 FROM zw_file WHERE zw01=g_zx.zx04
   DISPLAY lc_gem02 TO zw02
 
   SELECT gbt10 INTO li_gbt10 FROM gbt_file WHERE gbt00="0" 
   IF STATUS OR li_gbt10 IS NULL THEN LET li_gbt10 = 0 END IF
   IF li_gbt10 > 0 AND g_zx.zx20 >= li_gbt10 THEN
      DISPLAY "Y" TO FORMONLY.locked
   ELSE
      DISPLAY "N" TO FORMONLY.locked
   END IF
 
   CALL cl_show_fld_cont()              #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION p_zx_u()
   DEFINE l_n      LIKE type_file.num5   #No.FUN-680135 SMALLINT 
   DEFINE li_zx08  LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE lc_gbt07 LIKE gbt_file.gbt07   #FUN-910094
   DEFINE l_n1     LIKE type_file.num5   #FUN-CC0110
   
   IF g_zx.zx01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_zx01_t = g_zx.zx01
   LET g_zx_t.*=g_zx.* 
   BEGIN WORK
   ###FUN-C10004 START ###
   OPEN p_zx_wzx_curl USING g_zx.zx01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,1)
      RETURN
   END IF
   FETCH p_zx_wzx_curl INTO g_zx.zx01               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
      RETURN
   END IF
   ###FUN-C10004 END ###
   OPEN p_zx_curl USING g_zx.zx01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,1)
      RETURN
   END IF
 
   FETCH p_zx_curl INTO g_zx.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
      RETURN
   ELSE
  #TQC-6C0060 mark
  #   IF g_aza.aza44 = "Y" THEN    #FUN-550077
  #      IF NOT cl_null(g_zx.zx02) THEN
  #         CALL cl_itemname_modsys("zx_file","zx02",g_zx.zx01,g_zx.zx02) RETURNING g_i
  #      END IF
  #      CALL cl_itemname_by_lang("zx_file","zx02",g_zx.zx01,g_lang,g_zx.zx02) RETURNING g_zx.zx02
  #   END IF
 
      IF g_zx.zx19 IS NULL OR g_zx.zx19 <> "Y" THEN    #FUN-930042
         LET g_zx.zx19 = "N"
      END IF
      IF g_zx.zx20 IS NULL THEN
         LET g_zx.zx20 = 0
      END IF
   END IF
 
   LET g_zx.zxmodu = g_user                  #修改者
   LET g_zx.zxdate = g_today                 #修改日期
 
   CALL p_zx_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL p_zx_i("u")                       # 欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_zx.*=g_zx_t.* 
        #IF g_aza.aza44 = "Y" THEN      #FUN-550077  #TQC-6C0060 mark
        #   CALL cl_itemname_modcurr("zx_file","zx02",g_zx.zx01,g_zx.zx02) RETURNING g_i
        #END IF
         EXIT WHILE
      ELSE   #FUN-830011
        #IF g_zx.zx10 != g_zx_t.zx10 THEN    #Admin調整密碼時也同步更新資料   #MOD-B90138 mark
         IF g_zx.zx10 != g_zx_t.zx10 OR cl_null(g_zx_t.zx10) THEN             #MOD-B90138
            LET g_zx.zx16 = g_today
            LET g_zx.zx17 = 0
            LET g_zx.zx10 = cl_user_encode(g_zx.zx10)  #FUN-910094
         END IF
 
         IF NOT cl_null(g_zx.zx18) AND g_zx.zx18 <= g_today THEN
            LET g_zx.zxacti = "N"    #FUN-870142
         ELSE
            LET g_zx.zxacti = "Y"
         END IF 
         DISPLAY BY NAME g_zx.zx16,g_zx.zx17,g_zx.zxacti
      END IF
 
     #IF g_aza.aza44 THEN    #FUN-550077  #TQC-6C0060 mark
     #   CALL cl_itemname_switch(1,"zx_file","zx02",g_zx.zx01,g_zx.zx02) RETURNING g_zx.zx02
     #END IF
 
      LET g_zx.zx14 = g_zx14  #TQC-6C0060 
      UPDATE zx_file SET zx_file.* = g_zx.*  
         WHERE zx01 = g_zx_t.zx01
 
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","zx_file",g_zx01_t,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
         CONTINUE WHILE
      ELSE
         ###FUN-C10004 START ###
         EXECUTE p_zx_wzx_upd_pre01 USING g_zx.zx01,g_zx.zx02,g_zx.zx06,g_zx.zx08,g_zx.zx03,
                                      g_zx.zx10,g_zx.zx09,g_zx.zx16,
                                      g_zx.zxuser,g_zx.zxgrup,g_zx.zxmodu,g_zx.zxdate,g_zx.zxacti,
                                      g_zx_t.zx01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","wzx_file",g_zx_t.zx01,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
         END IF
         ###FUN-C10004 END ###
        #IF g_aza.aza44 THEN    #FUN-550077  #TQC-6C0060 mark
        #   CALL cl_itemname_switch(2,"zx_file","zx02",g_zx.zx01,g_zx.zx02) RETURNING g_zx.zx02
        #END IF
      END IF
 
      IF g_zx.zx04 !=g_zx_t.zx04 THEN           #修改權限類別時須考慮
         SELECT COUNT(*) INTO l_n FROM zxw_file #zxw_file是否有UPDATE
          WHERE zxw01=g_zx.zx01                 #NO:4360     
            AND zxw04=g_zx_t.zx04
 
         IF l_n >0 THEN
            #FUN-CC0110 -start-
            SELECT COUNT(*) INTO l_n1 FROM zxw_file #zxw_file是否有UPDATE
             WHERE zxw01=g_zx.zx01                 #NO:4360     
                  AND zxw04=g_zx.zx04
            IF l_n1>0 THEN 
               DELETE FROM zxw_file WHERE zxw01=g_zx.zx01 AND zxw04=g_zx_t.zx04
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","zxw_file",g_zx.zx01,g_zx_t.zx04,SQLCA.sqlcode,"","",0)
                  CONTINUE WHILE
               ELSE 
                  EXECUTE p_zx_wzy_del_pre1 USING g_zx.zx01,'1',g_zx_t.zx04
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("del","wzy_file",g_zx.zx01,g_zx_t.zx04,SQLCA.sqlcode,"","",0)
                     ROLLBACK WORK   
                     CONTINUE WHILE
                  END IF
               END IF 
            ELSE
            #FUN-CC0110 --end--    
               UPDATE zxw_file SET zxw04=g_zx.zx04
                WHERE zxw01=g_zx.zx01
                  AND zxw04=g_zx_t.zx04
               IF SQLCA.sqlcode THEN
                  #CALL cl_err(g_zx.zx04,SQLCA.sqlcode,0)  #No.FUN-660081
                  CALL cl_err3("upd","zxw_file",g_zx.zx01,g_zx_t.zx04,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                  CONTINUE WHILE
               ELSE #FUN-C10004
                  ###FUN-C10004 START ###
                  #預設權限類別
                  EXECUTE p_zx_wzy_upd_pre USING g_zx.zx04,g_zx.zx01,'1',g_zx_t.zx04
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","wzy_file",g_zx.zx01,g_zx_t.zx04,SQLCA.sqlcode,"","",0)
                     ROLLBACK WORK   #FUN-CC0110 add
                     CONTINUE WHILE
                  END IF
                  ###FUN-C10004 END ###
               END IF
            END IF 
         END IF    
      END IF
      
      IF g_zx.zx05 != g_zx_t.zx05 THEN
         CALL p_zx_redo_menu(TRUE)
      END IF
 
      #修改Default-Plant時需要考慮是否對該工廠有使用權限
      IF g_zx.zx08 != g_zx_t.zx08 THEN
         LET li_zx08 = 0
         IF g_zx.zx07 = "Y" THEN
            SELECT COUNT(*) INTO li_zx08 FROM zxy_file
             WHERE zxy01=g_zx.zx01 AND zxy03=g_zx.zx08
             IF li_zx08 = 0 AND NOT cl_null(g_zx.zx08) THEN  #MOD-490468
               CALL cl_err_msg(NULL, "azz-072", g_zx.zx01 CLIPPED|| "|" || g_zx.zx08 CLIPPED,10)
               INSERT INTO zxy_file(zxy01,zxy02,zxy03) 
                VALUES(g_zx.zx01,g_zx.zx02,g_zx.zx08)
               IF SQLCA.sqlcode THEN
                  #CALL cl_err(g_zx.zx08,SQLCA.sqlcode,1)  #No.FUN-660081
                  CALL cl_err3("ins","zxy_file",g_zx.zx01,g_zx.zx08,SQLCA.sqlcode,"","",1)    #No.FUN-660081
               ELSE #FUN-C10004
                  ###FUN-C10004 START ###
                  EXECUTE p_zx_wzy_ins_pre1 USING g_zx.zx01,'2',g_zx.zx08
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("ins","wzy_file",g_zx.zx01,g_zx.zx08,SQLCA.sqlcode,"","",1)
                  END IF
                  ###FUN-C10004 END ###
               END IF
            END IF
         ELSE
            IF NOT cl_null(g_zx.zx08) THEN
               SELECT COUNT(*) INTO li_zx08 FROM zxy_file
                WHERE zxy01=g_zx.zx01 
               CASE li_zx08 
                  WHEN "0" 
                     INSERT INTO zxy_file(zxy01,zxy02,zxy03) 
                     VALUES(g_zx.zx01,g_zx.zx02,g_zx.zx08)
                     IF SQLCA.sqlcode THEN
                        #CALL cl_err(g_zx.zx08,SQLCA.sqlcode,1)  #No.FUN-660081
                        CALL cl_err3("ins","zxy_file",g_zx.zx01,g_zx.zx08,SQLCA.sqlcode,"","",1)    #No.FUN-660081
                     ELSE #FUN-C10004
                        ###FUN-C10004 START ###
                        EXECUTE p_zx_wzy_ins_pre1 USING g_zx.zx01,'2',g_zx.zx08
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("ins","wzy_file",g_zx.zx01,g_zx.zx08,SQLCA.sqlcode,"","",1)
                        END IF
                        ###FUN-C10004 END ###
                     END IF
                  WHEN "1"
                     UPDATE zxy_file SET zxy03=g_zx.zx08 WHERE zxy01=g_zx.zx01
                     IF SQLCA.sqlcode THEN
                        #CALL cl_err(g_zx.zx08,SQLCA.sqlcode,1)  #No.FUN-660081
                        CALL cl_err3("upd","zxy_file",g_zx.zx01,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
                     ELSE #FUN-C10004
                        ###FUN-C10004 START ###
                        EXECUTE p_zx_wzy_upd_pre USING g_zx.zx08,g_zx.zx01,'2',g_zx_t.zx08
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","wzy_file",g_zx.zx01,g_zx_t.zx08,SQLCA.sqlcode,"","",0)
                        END IF
                        ###FUN-C10004 END ###
                     END IF
                  OTHERWISE
                     CALL cl_err_msg(NULL,"azz-057",g_zx.zx01 CLIPPED,10)
               END CASE
            END IF
         END IF
      END IF
 
      #CALL s_ins_auth_plant(g_zx.zx01)   #No.FUN-980025 #FUN-A50080
 
      #FUN-890113 start
      LET g_u_flag=""
      CASE aws_mdmdata('zx_file','update',g_zx.zx01,base.TypeInfo.create(g_zx),'CreateUserData')
              WHEN 0  #無與 MDM 整合
                   CALL cl_msg('UPDATE O.K')                   
              WHEN 1  #呼叫 MDM 成功
                   CALL cl_msg('UPDATE O.K, UPDATE MDM O.K')                   
              WHEN 2  #呼叫 MDM 失敗
              	   LET g_u_flag="1"              	              	   
      END CASE
      #FUN-890113 end 
      EXIT WHILE
   END WHILE
 
   CLOSE p_zx_wzx_curl   #FUN-C10004
   CLOSE p_zx_curl
   #FUN-890113 start
   IF g_u_flag="1" THEN 
   	 ROLLBACK WORK   
   ELSE   		
     COMMIT WORK
   END IF
   #FUN-890113 end
 
END FUNCTION
 
 
 
FUNCTION p_zx_x()      #FUN-870142
 
   IF g_zx.zx01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_zx01_t = g_zx.zx01
   LET g_zx_t.*=g_zx.* 
   BEGIN WORK
   ###FUN-C10004 START ###
   OPEN p_zx_wzx_curl USING g_zx.zx01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,1)
      RETURN
   END IF
   FETCH p_zx_wzx_curl INTO g_zx.zx01               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
      RETURN
   END IF
   ###FUN-C10004 END ###
   OPEN p_zx_curl USING g_zx.zx01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,1)
      RETURN
   END IF
 
   FETCH p_zx_curl INTO g_zx.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_zx.zxmodu = g_user                  #修改者
   LET g_zx.zxdate = g_today                 #修改日期
 
   IF NOT cl_null(g_zx.zx18) AND g_zx.zx18 <= g_today THEN
      LET g_zx.zxacti = "N"
   ELSE
      LET g_zx.zxacti = "Y"
   END IF 
   CALL p_zx_show()
   IF cl_exp(0,0,g_zx.zxacti) THEN
 
      IF g_zx.zxacti = "Y" THEN
         LET g_zx.zxacti = "N"
         LET g_zx.zx18 = g_today
      ELSE
         LET g_zx.zxacti = "Y"
         LET g_zx.zx18 = ""
      END IF 

      UPDATE zx_file SET zx18 = g_zx.zx18,     zxacti = g_zx.zxacti,
                         zxdate = g_zx.zxdate, zxmodu = g_zx.zxmodu
       WHERE zx01 = g_zx.zx01
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","zx_file",g_zx01_t,"",SQLCA.sqlcode,"","",0) 
      ELSE
         ###FUN-C10004 START ###
         LET g_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzx_file",
                     " SET wzxmodu = ? ,wzxdate = ? ,wzxacti = ?",
                     " WHERE wzx01 = ?"
         PREPARE p_zx_wzx_upd_acti_pre FROM g_sql
         EXECUTE p_zx_wzx_upd_acti_pre USING g_zx.zxmodu,g_zx.zxdate,g_zx.zxacti,g_zx.zx01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","wzx_file",g_zx.zx01,"",SQLCA.sqlcode,"","",0)
         END IF
         ###FUN-C10004 END ###
         DISPLAY BY NAME g_zx.zx18,g_zx.zxacti,g_zx.zxdate,g_zx.zxmodu
      END IF
   END IF

   CLOSE p_zx_wzx_curl   #FUN-C10004
   CLOSE p_zx_curl
   COMMIT WORK
 
END FUNCTION
 
 
 
FUNCTION redo_menu_check(ls_zm01)
DEFINE   ls_zm01        LIKE zm_file.zm01,
         li_i           LIKE type_file.num10,  #No.FUN-680135 INTEGER
         ls_cnt         LIKE type_file.num10,  #No.FUN-680135 INTEGER
         no_redo_flag   LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
   FOR li_i = 1 TO g_change_menu.getLength()
      IF ls_zm01 = g_change_menu[li_i].menu_name THEN
         LET no_redo_flag = TRUE
      END IF
   END FOR
   IF NOT no_redo_flag THEN
      LET g_change_menu[g_change_menu_cnt].menu_name = ls_zm01
      LET g_change_menu_cnt = g_change_menu.getLength() + 1
   END IF
END FUNCTION
 
FUNCTION p_zx_redo_menu(ls_flag)
   DEFINE  ls_flag   LIKE type_file.num5,   #No.FUN-680135 SMALLINT
           li_i      LIKE type_file.num5,   #No.FUN-680135 SMALLINT
           ls_run    LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE  ls_msg    LIKE ze_file.ze03      #No.FUN-680135 VARCHAR(300)
   DEFINE  ls_title  LIKE ze_file.ze03      #No.FUN-680135 VARCHAR(300)
 
   LET ls_run = FALSE
   SELECT ze03 INTO ls_title FROM ze_file
    WHERE ze01 = 'azz-049' AND ze02 = g_lang
   SELECT ze03 INTO ls_msg   FROM ze_file
    WHERE ze01 = 'azz-050' AND ze02 = g_lang
 
   MENU ls_title ATTRIBUTE(STYLE="dialog", COMMENT=ls_msg)
      ON ACTION accept
         LET ls_run = TRUE
      ON ACTION cancel
         IF ls_flag THEN
            CALL redo_menu_check(g_zx.zx05)
         END IF
         EXIT MENU
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
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
   IF ls_run THEN
      IF ls_flag THEN
         CALL cl_create_4sm(g_zx.zx05, FALSE)
      ELSE
         FOR li_i = 1 TO g_change_menu.getLength()
            CALL cl_create_4sm(g_change_menu[li_i].menu_name, FALSE)
         END FOR
      END IF
   END IF
   RETURN
END FUNCTION
 
FUNCTION p_zx_r()
 
   DEFINE l_chr LIKE type_file.chr1   #No.FUN-680135 VARCHAR(1)
 
   IF cl_null(g_zx.zx01) THEN         #MOD-610001
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
   ###FUN-C10004 START ###
   OPEN p_zx_wzx_curl USING g_zx.zx01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
      RETURN
   END IF
   FETCH p_zx_wzx_curl INTO g_zx.zx01               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
      RETURN
   END IF
   ###FUN-C10004 END ###
   OPEN p_zx_curl USING g_zx.zx01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   FETCH p_zx_curl INTO g_zx.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL p_zx_show()
 
#  IF cl_delete() THEN
   IF cl_confirm("azz-235") THEN                #MOD-610001
      DELETE FROM zxw_file WHERE zxw01 = g_zx.zx01
      DELETE FROM zxy_file WHERE zxy01 = g_zx.zx01
      DELETE FROM zx_file  WHERE zx01 = g_zx.zx01
 
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","zx_file",g_zx.zx01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
      ELSE
         ###FUN-C10004 START ###
         LET g_sql = "DELETE FROM ",s_dbstring("wds") CLIPPED,"wzy_file WHERE wzy01 = ?"
         PREPARE p_zx_wzy_del_pre FROM g_sql
         EXECUTE p_zx_wzy_del_pre USING g_zx.zx01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","wzy_file",g_zx.zx01,"",SQLCA.sqlcode,"","",0)
            ROLLBACK WORK
            RETURN
         END IF

         LET g_sql = "DELETE FROM ",s_dbstring("wds") CLIPPED,"wzx_file WHERE wzx01 = ?"
         PREPARE p_zx_wzx_del_pre FROM g_sql
         EXECUTE p_zx_wzx_del_pre USING g_zx.zx01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","wzx_file",g_zx.zx01,"",SQLCA.sqlcode,"","",0) 
            ROLLBACK WORK
            RETURN
         END IF
         ###FUN-C10004 END ###
         
         #CALL s_ins_auth_plant(g_zx.zx01)   #No.FUN-980025 #FUN-A50080
         CLEAR FORM
         INITIALIZE g_zx.* LIKE zx_file.*
         OPEN p_zx_count
#FUN-B50065------begin---
         IF STATUS THEN
            CLOSE p_zx_count
            CLOSE p_zx_wzx_curl   #FUN-C10004
            CLOSE p_zx_curl
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
         FETCH p_zx_count INTO g_row_count
#FUN-B50065------begin---
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE p_zx_count
            CLOSE p_zx_wzx_curl   #FUN-C10004
            CLOSE p_zx_curl
            COMMIT WORK
            RETURN
         END IF
#FUN-B50065------end------
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_zx_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_zx_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #FUN-6A0080
            CALL p_zx_fetch('/')
         END IF
      END IF
   END IF

   CLOSE p_zx_wzx_curl   #FUN-C10004
   CLOSE p_zx_curl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION p_zx_copy()
 
   DEFINE l_n          LIKE type_file.num5,   #No.FUN-680135 SMALLINT
          l_newno      LIKE zx_file.zx01
   DEFINE li_zx08      LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE l_oldno      LIKE zx_file.zx01      #MOD-AA0132
   DEFINE l_newzx10    LIKE zx_file.zx10      #TQC-B10159
 
   IF g_zx.zx01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   ELSE                          #MOD-AA0132 
      LET l_oldno = g_zx.zx01    #MOD-AA0132
   END IF
 
  #-MOD-AA0132-add-
   LET g_before_input_done = FALSE
   CALL p_zx_set_entry('a')
   CALL p_zx_set_no_entry('a')
   LET g_before_input_done = TRUE
  #-MOD-AA0132-end-

#  CALL cl_getmsg('copy',g_lang) RETURNING g_msg
#           LET INT_FLAG = 0  ######add for prompt bug
#  PROMPT g_msg CLIPPED,': ' FOR l_newno
 
    # 2005/01/05 MOD-510008 修改 l_newno 
   INPUT l_newno WITHOUT DEFAULTS FROM zx01
 
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
 
   IF INT_FLAG OR cl_null(l_newno) THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_zx.zx01           #MOD-AA0132
      RETURN
   END IF
 
   SELECT count(*) INTO l_n FROM zx_file
    WHERE zx01 = l_newno
 
   IF l_n > 0 THEN
      CALL cl_err(l_newno,-239,0)
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM zx_file
    WHERE zx01=g_zx.zx01
     INTO TEMP x
 
   LET l_newzx10 = cl_user_encode(l_newno)       #TQC-B10159

   UPDATE x SET zx01 = l_newno,    #資料鍵值
                zx02 = "",
                zx10 = l_newzx10,  #FUN-940126   #TQC-B10159
                zxuser = g_user,   #資料所有者
                zxgrup = g_grup,   #資料所有者所屬群
                zxmodu = NULL,     #資料修改日期
                zxdate = g_today   #資料建立日期
 
   INSERT INTO zx_file SELECT * FROM x
 
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_zx.zx01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","zx_file",l_newno,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
   ELSE
      ###FUN-C10004 START ###
      LET g_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzx_file",
                           "(wzx01,wzx02,wzx03,wzx04,wzx05,",
                            "wzx06,wzx07,wzx08,",
                            "wzxuser,wzxgrup,wzxmodu,wzxdate,wzxacti)",
                    " SELECT zx01,zx02,zx06,zx08,zx03,",
                            "zx10,zx09,zx16,",
                            "zxuser,zxgrup,zxmodu,zxdate,zxacti FROM x"
      PREPARE p_zx_ins_wzx_pre02 FROM g_sql
      EXECUTE p_zx_ins_wzx_pre02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","wzx_file",l_newno,"",SQLCA.sqlcode,"","",0)
      END IF
      ###FUN-C10004 END ###
      MESSAGE 'ROW(',l_newno,') O.K'
 
      #修改 Default-Plant 時需要考慮是否對該工廠有使用權限
      LET li_zx08 = 0
      SELECT COUNT(*) INTO li_zx08 FROM zxy_file
       WHERE zxy01=l_newno AND zxy03=g_zx.zx08
#      WHERE zxy01=g_zx.zx01 AND zxy03=g_zx.zx08
 
       IF li_zx08 = 0 AND NOT cl_null(g_zx.zx08) THEN  #MOD-490468
 
         CALL cl_err_msg(NULL, "azz-072", l_newno CLIPPED ||"|"|| g_zx.zx08 CLIPPED,10)
#        CALL cl_err_msg(NULL, "azz-072", g_zx.zx01 CLIPPED ||"|"|| g_zx.zx08 CLIPPED,10)
 
         INSERT INTO zxy_file(zxy01,zxy02,zxy03) 
          VALUES(l_newno,g_zx.zx02,g_zx.zx08)
#         VALUES(g_zx.zx01,g_zx.zx02,g_zx.zx08)
 
         IF SQLCA.sqlcode THEN
            #CALL cl_err("Insert zxy_file",SQLCA.sqlcode,1)  #No.FUN-660081
            #CALL cl_err3("ins","zxy_file",g_zx.zx01,g_zx.zx08,SQLCA.sqlcode,"","Insert zxy_file",1)    #No.FUN-660081 #FUN-C10004 mark
#           CALL cl_err(g_zx.zx08,SQLCA.sqlcode,1)
            CALL cl_err3("ins","zxy_file",l_newno,g_zx.zx08,SQLCA.sqlcode,"","",1)   #FUN-C10004
         ELSE #FUN-C10004
            ###FUN-C10004 START ###
            EXECUTE p_zx_wzy_ins_pre1 USING l_newno,'2',g_zx.zx08
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","wzy_file",l_newno,g_zx.zx08,SQLCA.sqlcode,"","",1)
            END IF
            ###FUN-C10004 END ###
         END IF
         #CALL s_ins_auth_plant(l_newno)  #No.FUN-980025 #FUN-A50080
      END IF
   END IF
  #-MOD-AA0132-add-
   SELECT zx01 INTO g_zx.zx01 FROM zx_file WHERE zx01 = l_newno
   CALL p_zx_u()
  #MOD-B50210---modify---start---
  #SELECT zx01,zx02,zx03,zx04,zx05,zx06,zx07,zx08,zx09,zx10,
  #       zx11,zx12,zx13,zx14,zx15,zx16,zx17,zx18,zx19,zx20,
  #       zxacti,zxdate,zxgrup,zxmodu,zxuser
#FUN-C30027---begin
#   SELECT *
#  #MOD-B50210---modify---end---
#     INTO g_zx.*
#     FROM zx_file
#    WHERE zx01 = l_oldno
#FUN-C30027---end
   CALL p_zx_show()
  #-MOD-AA0132-end-
   call p_zx_copy_plus(l_oldno,l_newno,g_zx.zx02) #darcy:2024/01/22 add
END FUNCTION
#FUN-970073 start
FUNCTION p_zx_out()
#    DEFINE
#        l_i             LIKE type_file.num5,   #No.FUN-680135 SMALLINT
#        l_name          LIKE type_file.chr20,  #No.FUN-680135 VARCHAR(20) # External(Disk) file name
#        l_za05          LIKE type_file.chr1000,#No.FUN-680135 VARCHAR(40) #
#        l_chr           LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
    DEFINE l_cmd  LIKE type_file.chr1000
    IF cl_null(g_wc) THEN 
       LET g_wc=" zx01='",g_zx.zx01,"'"
    END IF
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
     
    LET l_cmd = 'p_query "p_zx" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
#    
#    CALL cl_wait()
#    CALL cl_outnam('p_zx') RETURNING l_name
#
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#
#    LET g_sql="SELECT * FROM zx_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc CLIPPED
#    PREPARE p_zx_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE p_zx_curo                         # SCROLL CURSOR
#         CURSOR FOR p_zx_p1
#
#    START REPORT p_zx_rep TO l_name
#display "aw:",l_name
#    FOREACH p_zx_curo INTO g_zx.*
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        ELSE
#           #FUN-550077  #TQC-6C0060 mark
#          #IF g_aza.aza44 = "Y" THEN
#          #   CALL cl_itemname_by_lang("zx_file","zx02",g_zx.zx01,g_lang,g_zx.zx02) RETURNING g_zx.zx02
#          #END IF
#        END IF
#        OUTPUT TO REPORT p_zx_rep(g_zx.*)
#    END FOREACH
#
#    FINISH REPORT p_zx_rep
#
#    CLOSE p_zx_curo
#
#    CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
#REPORT p_zx_rep(sr)
#    DEFINE l_trailer_sw     LIKE type_file.chr1,   #No.FUN-680135 VARCHAR(1)
#           l_gem02          LIKE gem_file.gem02,
#           sr               RECORD LIKE zx_file.*,
#           l_chr            LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER EXTERNAL BY sr.zx01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-LENGTH(g_company))/2)+1,g_company
#            PRINT COLUMN ((g_len-LENGTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,
#                  g_x[32] CLIPPED,
#                  g_x[33] CLIPPED,
#                  g_x[34] CLIPPED,
#                  g_x[35] CLIPPED,
#                  g_x[36] CLIPPED,
#                  g_x[37] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.zx03
#            PRINT COLUMN g_c[31],sr.zx01,
#                  COLUMN g_c[32],sr.zx02,
#                  COLUMN g_c[33],sr.zx03,
#                  COLUMN g_c[34],l_gem02,
#                  COLUMN g_c[35],sr.zx04,
#                  COLUMN g_c[36],sr.zx05,
#                  COLUMN g_c[37],sr.zx06
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#FUN-970073 end
 
#MOD-950128---add---start---
FUNCTION p_zx_set_entry(p_cmd)
 DEFINE p_cmd LIKE type_file.chr1   
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done )  THEN
     CALL cl_set_comp_entry("zx01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_zx_set_no_entry(p_cmd)
 DEFINE p_cmd LIKE type_file.chr1   
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("zx01",FALSE)
   END IF
 
END FUNCTION
#MOD-950128---add---end---
#TQC-A10126


#darcy:2024/01/22 add s---
# 复制p_zxw，复制aooi040
function p_zx_copy_plus(p_zx01,p_newno,p_name)
   define p_zx01,p_newno  like zx_file.zx01
   define p_name          like gen_file.gen02

   # 复制p_zxw

   DROP TABLE x

   SELECT * FROM zxw_file WHERE zxw01=p_zx01 INTO TEMP x

   UPDATE x SET zxw01=p_newno     #資料鍵值

   BEGIN WORK   #FUN-C10004
   INSERT INTO zxw_file SELECT * FROM x

   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","zxw_file",p_newno,"",SQLCA.sqlcode,"","",0)
      ROLLBACK WORK   #FUN-C10004
      RETURN
   ELSE
      ###FUN-C10004 START ###
      UPDATE x SET zxw03='3' WHERE zxw03='2'
      LET g_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzy_file SELECT zxw01,zxw03,zxw04 FROM x"
      PREPARE p_zxw_wzy_ins_pre02 FROM g_sql
      EXECUTE p_zxw_wzy_ins_pre02
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","wzy_file",p_newno,"",SQLCA.SQLCODE,"","",0)
         ROLLBACK WORK
         RETURN
      ELSE
         COMMIT WORK
      END IF
      ###FUN-C10004 END ###
   END IF

   message "copy p_zxw over."

   # 新建aooi040资料

   DROP TABLE x

   SELECT * FROM gen_file WHERE gen01=p_zx01 INTO TEMP x

   UPDATE x SET gen01=p_newno,gen02=p_name     #資料鍵值

   BEGIN WORK   #FUN-C10004
   INSERT INTO gen_file SELECT * FROM x

   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","gen_file",p_zx01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF

   message "copy aooi040 over."

   message "copy over."

end function
#darcy:2024/01/22 add e---
