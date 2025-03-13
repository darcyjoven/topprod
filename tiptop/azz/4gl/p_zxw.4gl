# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_zxw.4gl
# Descriptions...: 使用者權限類別設定作業
# Date & Author..: 93/01/11 Lee
# Modify.........: No.MOD-470041 04/07/19 By Wiky 修改INSERT INTO...
# Modify.........: No.           04/08/19 By alex 顯示值修正
# Modify.........: No.MOD-490216 04/09/15 By saki 權限action不更換語言顯示
# Modify.........: No.MOD-490480 04/09/30 By saki action選取未更新, 當zxw03選權限類別時, 不出現modify_auth
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0104 05/01/05 By alex 修改 4js bug 定義超長
# Modify.........: No.FUN-510050 05/01/28 By pengu 報表轉XML
# Modify.........: No.MOD-530077 05/03/16 By alex 修 zxw08 不會更新的問題
# Modify.........: No.MOD-540140 05/04/20 By alex 取消 refresh
# Modify.........: No.MOD-540162 05/04/29 By alex 修改 order by 錯誤部份
# Modify.........: No.MOD-540204 05/04/29 By alex 修改控制項錯誤部份
# Modify.........: No.MOD-540026 05/05/02 By alex 新增單身權限控制功能
# Modify.........: No.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: No.MOD-590329 05/10/04 By yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.MOD-560212 05/08/04 By alex 新增判斷此群組是否已失效,失效則不改
# Modify.........: No.TQC-5A0094 05/10/26 By alex 關閉當 zxw03=1 時關閉 zxw04,05,06,07等功能
# Modify.........: No.TQC-5C0116 05/12/27 By alex 去除欄位 null
# Modify.........: No.FUN-620047 06/02/24 By alex 新增zxw04可開窗查詢功能
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/23 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-7C0041 07/12/12 By alextsar 新增複製功能
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-870036 08/07/10 By alex 修正zxw05取值方式
# Modify.........: NO.FUN-970073 09/07/21 By Kevin 把老報表改成p_query
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/27 By douzh GP5.2集團架構調整,azp相關修改
# Modify.........: No.MOD-A30223 10/03/29 By sabrina 單身新增時，zxw05不可輸入
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-C10004 12/01/02 By tsai_yen GP5.3 GWC&GDC開發區合併
# Modify.........: No.FUN-C70005 12/07/02 By tsai_yen GP 5.3的p_zxw資料和p_webauth同步,所以p_zxw單身不要允許新增重複資料
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_zxw01         LIKE zxw_file.zxw01,   #user-id   (假單頭)
    a_zxw01         LIKE zxw_file.zxw01,   #user-id   (假單頭)
    g_zx02          LIKE zx_file.zx02,     #user-name (假單頭)
    g_zxw01_t       LIKE zxw_file.zxw01,   #user-id   (舊值)
    g_zxw           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
        zxw02       LIKE zxw_file.zxw02,   #項次
        zxw03       LIKE zxw_file.zxw03,   #分類
        zxw04       LIKE zxw_file.zxw04,   #權限類別/程式編號
        gaz03       LIKE gaz_file.gaz03,
        zxw05       LIKE zxw_file.zxw05,   #允許執行功能
        zxw06       LIKE zxw_file.zxw06,   #資料所有者存取權限
        zxw07       LIKE zxw_file.zxw07,   #資料所有部門存取權限
        zxw08       LIKE zxw_file.zxw08    #資料所有部門單身存取權限
                    END RECORD,
    g_zxw05         DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
        zxw05       LIKE zxw_file.zxw05    #允許執行功能
                    END RECORD,
    g_zxw_t         RECORD                 #程式變數 (舊值)
        zxw02       LIKE zxw_file.zxw02,   #項次
        zxw03       LIKE zxw_file.zxw03,   #分類
        zxw04       LIKE zxw_file.zxw04,   #權限類別/程式編號
        gaz03       LIKE gaz_file.gaz03,
        zxw05       LIKE zxw_file.zxw05,   #允許執行功能
        zxw06       LIKE zxw_file.zxw06,   #資料所有者存取權限
        zxw07       LIKE zxw_file.zxw07,   #資料所有部門存取權限
        zxw08       LIKE zxw_file.zxw08    #資料所有部門單身存取權限
                    END RECORD,
    g_zxw05_t       RECORD                 #程式變數 (舊值)
        zxw05       LIKE zxw_file.zxw05    #允許執行功能
                    END RECORD,
    g_wc,g_wc2,g_sql STRING,
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數 #No.FUN-680135 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,   #單身筆數                    #No.FUN-680135 SMALLINT
    g_ss            LIKE type_file.chr1,   #No.FUN-680135 VARCHAR(1)
    g_succ          LIKE type_file.chr1,   #No.FUN-680135 VARCHAR(1)
    g_comp          LIKE zxw_file.zxw01,
    g_item          LIKE zxw_file.zxw02,
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
    l_n             LIKE type_file.num5    #No.FUN-680135 SMALLINT

DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5    #NO.MOD-580056    #No.FUN-680135 SMALLINT
DEFINE g_cnt         LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE g_i           LIKE type_file.num5   #count/index for any purpose #No.FUN-680135 SMALLINT
DEFINE g_msg         LIKE type_file.chr1000#No.FUN-680135 VARCHAR(72)
DEFINE g_curs_index  LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE g_row_count   LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE g_jump        LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE g_no_ask      LIKE type_file.num5   #No.FUN-680135 SMALLINT   #FUN-6A0080

MAIN
   OPTIONS                                 #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                         #擷取中斷鍵, 由程式處理

   LET a_zxw01 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
      RETURNING g_time    #No.FUN-6A0096

   LET g_zxw01 = NULL                     #清除鍵值
   LET g_zx02 = NULL                      #清除鍵值
   LET g_zxw01_t = NULL

   OPEN WINDOW p_zxw_w WITH FORM "azz/42f/p_zxw"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_init()

   ###FUN-C10004 START ###
   LET g_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzy_file(wzy01,wzy02,wzy03)",
                    " VALUES(?,?,?)"
   PREPARE p_zxw_wzy_ins_pre011 FROM g_sql
   ###FUN-C10004 END ###

   LET g_zxw01 = a_zxw01
   IF NOT cl_null(g_zxw01) THEN
      SELECT zx02 INTO g_zx02 FROM zx_file WHERE zx01=g_zxw01
      CALL p_zxw_q()
   END IF
   LET g_delete='N'
   CALL p_zxw_menu()
   CLOSE WINDOW p_zxw_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN

FUNCTION p_zxw_cs()

   CLEAR FORM                             #清除畫面
   CALL g_zxw.clear()
   CALL g_zxw05.clear()

   IF INT_FLAG THEN RETURN END IF

   IF cl_null(a_zxw01)  THEN
    CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      CONSTRUCT g_wc ON zxw01,zxw03,zxw04        #FUN-620047
           FROM zxw01,s_zxw[1].zxw03,s_zxw[1].zxw04

         ON ACTION controlp
            CASE
               WHEN INFIELD(zxw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_zx"
                  LET g_qryparam.state ="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zxw01

               WHEN INFIELD(zxw04)      #FUN-620047
                  CALL cl_init_qry_var()
                  MENU "" ATTRIBUTE(STYLE="popup")
                     ON ACTION q_gaz
                        LET g_qryparam.form ="q_gaz"
                        LET g_qryparam.arg1 = g_lang CLIPPED
                     ON ACTION q_zw
                        LET g_qryparam.form ="q_zw"
                     ON IDLE g_idle_seconds
                        CALL cl_on_idle()
                        CONTINUE MENU
                  END MENU
                  LET g_qryparam.state ="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zxw04
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc = "zxw01 ='",a_zxw01,"'" CLIPPED
      DISPLAY g_zxw01 TO zxw01
      DISPLAY g_zx02 TO FORMONLY.zx02
   END IF

   LET g_sql="SELECT UNIQUE zxw01,zx02 FROM zxw_file,zx_file ", #組合出SQL指令
             " WHERE zxw01=zx01 AND ", g_wc CLIPPED,
             " ORDER BY zxw01"
   PREPARE p_zxw_prepare FROM g_sql      #預備一下
   DECLARE p_zxw_bcs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR p_zxw_prepare

   LET g_sql="SELECT COUNT(DISTINCT zxw01) ",
             "  FROM zxw_file,zx_file ",
             " WHERE zxw01=zx01 AND ", g_wc CLIPPED
   PREPARE p_zxw_precount FROM g_sql
   DECLARE p_zxw_count CURSOR FOR p_zxw_precount

END FUNCTION

FUNCTION p_zxw_menu()
   WHILE TRUE
      CALL p_zxw_bp("G")
      CASE g_action_choice

           WHEN "insert"
            IF cl_chk_act_auth() THEN
                CALL p_zxw_a()
            END IF

           WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL p_zxw_q()
            END IF

           WHEN "delete"
            IF cl_chk_act_auth() THEN
                CALL p_zxw_r()
            END IF

           WHEN "reproduce"             #FUN-7C0041
            IF cl_chk_act_auth() THEN
                CALL p_zxw_copy()
            END IF

           WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_zxw_b()
            ELSE
               LET g_action_choice = NULL
            END IF

          WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL p_zxw_out()
            END IF

           WHEN "help"
            CALL cl_show_help()

           WHEN "exit"
            EXIT WHILE

           WHEN "controlg"
            CALL cl_cmdask()
           WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_zxw),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION p_zxw_a()

   IF s_shut(0) THEN RETURN END IF                #檢查權限

   MESSAGE ""
   CLEAR FORM
   CALL g_zxw.clear()
   CALL g_zxw05.clear()
   INITIALIZE g_zxw01 LIKE zxw_file.zxw01
   INITIALIZE g_zx02  LIKE zx_file.zx02
   LET g_zxw01_t = NULL
   DISPLAY g_zxw01 TO zxw01
   DISPLAY g_zx02  TO zx02
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')

   WHILE TRUE
      CALL p_zxw_i("a")                   #輸入單頭

      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      CALL g_zxw.clear()
      CALL g_zxw05.clear()
      LET g_rec_b = 0
      DISPLAY g_rec_b TO FORMONLY.cn2
      CALL p_zxw_b()                   #輸入單身
      LET g_zxw01_t = g_zxw01            #保留舊值
      EXIT WHILE
   END WHILE
   LET g_wc=' '

END FUNCTION

FUNCTION p_zxw_u()

   IF s_shut(0) THEN RETURN END IF                #檢查權限

   IF g_zxw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_zxw01_t = g_zxw01

   ###FUN-C10004 START ###
   LET g_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzy_file SET wzy01=?",
                " WHERE wzy01=? AND wzy02 IN ('1','2')"
   PREPARE p_zxw_wzy_upd_pre01 FROM g_sql
   ###FUN-C10004 END ###

   WHILE TRUE
      CALL p_zxw_i("u")                      #欄位更改

      IF INT_FLAG THEN
         LET g_zxw01=g_zxw01_t
         DISPLAY g_zxw01 TO zxw01      #單頭
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      IF g_zxw01 != g_zxw01_t THEN #更改單頭值
         BEGIN WORK   #FUN-C10004
         UPDATE zxw_file SET zxw01 = g_zxw01  #更新DB
          WHERE zxw01 = g_zxw01_t          #COLAUTH?
         IF SQLCA.sqlcode THEN
            LET g_msg = g_zxw01 CLIPPED
            #CALL cl_err(g_msg,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("upd","zxw_file",g_zxw01_t,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
            ROLLBACK WORK   #FUN-C10004
            CONTINUE WHILE
         ELSE #FUN-C10004
            ###FUN-C10004 START ###
            EXECUTE p_zxw_wzy_upd_pre01 USING g_zxw01,g_zxw01_t
            IF SQLCA.SQLCODE THEN
                CALL cl_err3("upd","wzy_file",g_zxw01_t,"",SQLCA.SQLCODE,"","",0)
                ROLLBACK WORK
                CONTINUE WHILE
            ELSE
               COMMIT WORK
            END IF
            ###FUN-C10004 END ###
         END IF
      END IF
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION p_zxw_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1      #a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)

   LET g_ss='Y'
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT g_zxw01 WITHOUT DEFAULTS FROM zxw01

      AFTER FIELD zxw01            #login user id
         IF NOT cl_null(g_zxw01) THEN
            IF p_cmd="a" THEN
               SELECT COUNT(*) INTO g_cnt FROM zxw_file
                WHERE zxw01=g_zxw01
               IF g_cnt>0 THEN
                  CALL cl_err(g_zxw01,-239,0)
                  NEXT FIELD zxw01
               END IF
            END IF
            SELECT zx02 INTO g_zx02 FROM zx_file WHERE zx01 = g_zxw01
            IF sqlca.sqlcode = 100 THEN
               ERROR "no such user "
               NEXT FIELD zxw01
            ELSE
               DISPLAY g_zx02 TO zx02
            END IF
         END IF

      ON ACTION controlp
         CASE                            #FUN-620047
            WHEN INFIELD(zxw01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_zx"
               CALL cl_create_qry() RETURNING g_zxw01
               DISPLAY g_zxw01 TO zxw01
         END CASE

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      ON IDLE g_idle_seconds  #FUN-860033
         CALL cl_on_idle()
         CONTINUE INPUT

   END INPUT

END FUNCTION

FUNCTION p_zxw_q()
  DEFINE l_zxw01  LIKE zxw_file.zxw01,
         l_zxw02  LIKE zxw_file.zxw02,
         l_cnt    LIKE type_file.num10   #No.FUN-680135 INTEGER

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)

   CALL cl_opmsg('q')
   CALL p_zxw_cs()                         #取得查詢條件

   IF INT_FLAG THEN                        #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_zxw01 TO NULL
      RETURN
   END IF

   OPEN p_zxw_count
   FETCH p_zxw_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt

   OPEN p_zxw_bcs                          #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                   #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_zxw01 TO NULL
   ELSE
      CALL p_zxw_fetch('F')                #讀出TEMP第一筆並顯示
   END IF

END FUNCTION

FUNCTION p_zxw_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,    #處理方式    #No.FUN-680135 VARCHAR(1)
   l_abso          LIKE type_file.num10    #絕對的筆數  #No.FUN-680135 INTEGER

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_zxw_bcs INTO g_zxw01,g_zx02
      WHEN 'P' FETCH PREVIOUS p_zxw_bcs INTO g_zxw01,g_zx02
      WHEN 'F' FETCH FIRST    p_zxw_bcs INTO g_zxw01,g_zx02
      WHEN 'L' FETCH LAST     p_zxw_bcs INTO g_zxw01,g_zx02
      WHEN '/'
            IF (NOT g_no_ask) THEN          #FUN-6A0080
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0      ######add for prompt bug
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
            FETCH ABSOLUTE g_jump p_zxw_bcs INTO g_zxw01,g_zx02
            LET g_no_ask = FALSE         #FUN-6A0080
   END CASE

   LET g_succ='Y'
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_zxw01,SQLCA.sqlcode,0)
      INITIALIZE g_zxw01 TO NULL  #TQC-6B0105
      INITIALIZE g_zx02  TO NULL  #TQC-6B0105
      LET g_succ='N'
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL p_zxw_show()
   END IF

END FUNCTION

FUNCTION p_zxw_show()

 #  #MOD-540204
   DEFINE lc_azp01   LIKE azp_file.azp01

#FUN-980020--begin
#  SELECT azp01 INTO lc_azp01 FROM azp_file
#   WHERE azp03=g_dbs
   LET lc_azp01 = g_plant
#FUN-980020--end

   DISPLAY g_zxw01,g_zx02,g_dbs,lc_azp01
        TO zxw01,FORMONLY.zx02,FORMONLY.dbs,FORMONLY.dbsname

   CALL p_zxw_bf(g_wc)                 #單身

    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION p_zxw_r()

   IF s_shut(0) THEN RETURN END IF                #檢查權限

   IF g_zxw01 IS NULL THEN
      RETURN
   END IF

   IF cl_delh(0,0) THEN                   #確認一下
      ###FUN-C10004 START ###
      BEGIN WORK
      LET g_sql = "DELETE FROM ",s_dbstring("wds"),"wzy_file WHERE wzy01 = ? AND wzy02 IN ('1','3')"
      PREPARE p_zxw_wzyh_del_pre FROM g_sql
      EXECUTE p_zxw_wzyh_del_pre USING g_zxw01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","wzy_file",g_zxw01,"",SQLCA.sqlcode,"","BODY DELETE",0)
         ROLLBACK WORK
         RETURN
      END IF
      ###FUN-C10004 END ###
   
      DELETE FROM zxw_file WHERE zxw01 = g_zxw01
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","zxw_file",g_zxw01,"",SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         ROLLBACK WORK   #FUN-C10004
      ELSE
         COMMIT WORK     #FUN-C10004
         CLEAR FORM
         CALL g_zxw.clear()
         CALL g_zxw05.clear()
         LET g_delete='Y'
         LET g_zxw01 = NULL
         OPEN p_zxw_count
#FUN-B50065------begin---
         IF STATUS THEN
            CLOSE p_zxw_count
            RETURN
         END IF
#FUN-B50065------end------
         FETCH p_zxw_count INTO g_row_count
#FUN-B50065------begin---
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE p_zxw_count
            RETURN
         END IF
#FUN-B50065------end------
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_zxw_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_zxw_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE          #FUN-6A0080
            CALL p_zxw_fetch('/')
         END IF
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
      END IF
   END IF

END FUNCTION

FUNCTION p_zxw_b()

   DEFINE l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680135 SMALLINT
          l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680135 SMALLINT
          l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680135 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680135 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,   #可新增否          #No.FUN-680135 SMALLINT
          l_allow_delete  LIKE type_file.num5,   #可刪除否          #No.FUN-680135 SMALLINT
          l_cnt           LIKE type_file.num10   #No.FUN-680135 INTEGER
   DEFINE lc_zwacti       LIKE zw_file.zwacti    #MOD-560212
   DEFINE l_wzy02         LIKE zxw_file.zxw03    #權限類別(1.權限 3.程式)     #FUN-C10004
   DEFINE l_wzy02_t       LIKE zxw_file.zxw03    #權限類別(1.權限 3.程式)     #FUN-C10004

   #MOD-540204
   LET g_action_choice =" "
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_zxw01) THEN
      RETURN
   END IF

   CALL p_zxw_add()

   CALL cl_opmsg('b')

   LET g_forupd_sql = " SELECT zxw02,zxw03,zxw04,'',zxw05,zxw06,zxw07,zxw08 ",
                        " FROM zxw_file ",
                       "  WHERE zxw01 = ? AND zxw02= ? ",
                         " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zxw_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   ###FUN-C10004 START ###
   LET g_forupd_sql = "SELECT wzy02,wzy03",
                      " FROM ",s_dbstring("wds") CLIPPED,"wzy_file ",
                      " WHERE wzy01 = ? AND wzy02 = ? AND wzy03 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zxw_wzy_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   
   LET g_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzy_file SET wzy02=?, wzy03=?",
                " WHERE wzy01=? AND wzy02=? AND wzy03=?"
   PREPARE p_zxw_wzy_upd_pre02 FROM g_sql

   LET g_sql = "DELETE FROM ",s_dbstring("wds"),"wzy_file",
               " WHERE wzy01 = ? AND wzy02 = ? AND wzy03 = ?"
   PREPARE p_zxw_wzy_del_pre FROM g_sql
   ###FUN-C10004 END ###

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_zxw WITHOUT DEFAULTS FROM s_zxw.*
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
          LET l_n  = ARR_COUNT()
          IF g_rec_b >= l_ac THEN
             BEGIN WORK
             LET g_zxw_t.* = g_zxw[l_ac].*      #BACKUP
             LET p_cmd='u'
#            #TQC-5A0094  #NO.MOD-590329 MARK #No.MOD-580056 --start
             LET g_before_input_done = FALSE
             CALL p_zxw_set_entry_b(p_cmd)
             CALL p_zxw_set_no_entry_b(p_cmd)
             LET g_before_input_done = TRUE
#            #TQC-5A0094   #No.MOD-580056 --end #NO.MOD-590329
             ###FUN-C10004 START ###
             IF g_zxw_t.zxw03 = "2" THEN
                LET l_wzy02_t = "3"
             ELSE
                LET l_wzy02_t = g_zxw_t.zxw03
             END IF
             OPEN p_zxw_wzy_bcl USING g_zxw01,l_wzy02_t,g_zxw_t.zxw04
             IF STATUS THEN
                CALL cl_err("OPEN p_zxw_wzy_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH p_zxw_wzy_bcl INTO l_wzy02,g_zxw[l_ac].zxw04
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_zxw[l_ac].zxw04,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             ###FUN-C10004 END ###
             OPEN p_zxw_bcl USING g_zxw01,g_zxw_t.zxw02
             IF STATUS THEN
                CALL cl_err("OPEN p_zxw_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH p_zxw_bcl INTO g_zxw[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_zxw_t.zxw02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE                                             #TQC-5A0094
#                  # 2004/08/19 改變權限顯示值
#                  LET g_zxw05[l_ac].zxw05=g_zxw[l_ac].zxw05     #MOD-490216
#                  CALL s_act_desc_tab(g_zxw[l_ac].zxw04,g_zxw05[l_ac].zxw05,g_zxw[l_ac].zxw08,"1") RETURNING g_zxw[l_ac].zxw05
                END IF
                IF g_zxw[l_ac].zxw03="1" THEN
                   SELECT zw02 INTO g_zxw[l_ac].gaz03 FROM zw_file
                    WHERE zw01=g_zxw[l_ac].zxw04
#                  #BUG-490480 MOD-540026
                   CALL cl_set_act_visible("modify_auth,modify_detail_auth",FALSE)
                   LET g_zxw[l_ac].zxw05=""                      #TQC-5A0094
                   LET g_zxw[l_ac].zxw06=""                      #TQC-5A0094
                   LET g_zxw[l_ac].zxw07=""                      #TQC-5A0094
                   LET g_zxw[l_ac].zxw08=""                      #TQC-5A0094
                ELSE
#                  #MOD-540163
                   CALL cl_get_progname(g_zxw[l_ac].zxw04,g_lang) RETURNING g_zxw[l_ac].gaz03
#                  SELECT gaz03 INTO g_zxw[l_ac].gaz03 FROM gaz_file
#                   WHERE gaz01=g_zxw[l_ac].zxw04 AND gaz02=g_lang order by gaz05
#                  #BUG-490480 MOD-540026
                   CALL cl_set_act_visible("modify_auth,modify_detail_auth",TRUE)
                END IF
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF

       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_zxw[l_ac].* TO NULL      #900423
          LET g_zxw_t.* = g_zxw[l_ac].*         #新輸入資料
#         #TQC-5A0094   #NO.MOD-590329 Mark #No.MOD-580056 --start
          LET g_before_input_done = FALSE
          CALL p_zxw_set_entry_b(p_cmd)
          LET g_before_input_done = TRUE
#         #TQC-5A0094   #No.MOD-580056 --end #NO.MOD-590329 MARK
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD zxw02

       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          ###FUN-C70005 mark START ###
          #INSERT INTO zxw_file(zxw01,zxw02,zxw03,zxw04,
          #                      zxw05,zxw06,zxw07,zxw08)  #No.MOD-470041
          #     VALUES(g_zxw01,g_zxw[l_ac].zxw02,g_zxw[l_ac].zxw03,
          #           #g_zxw[l_ac].zxw04,g_zxw05[l_ac].zxw05,g_zxw[l_ac].zxw06,
          #            g_zxw[l_ac].zxw04,g_zxw[l_ac].zxw05,g_zxw[l_ac].zxw06,    #MOD-490480
          #            g_zxw[l_ac].zxw07,g_zxw[l_ac].zxw08)
          #IF SQLCA.sqlcode THEN
          #   #CALL cl_err(g_zxw[l_ac].zxw02,SQLCA.sqlcode,0)  #No.FUN-660081
          #   CALL cl_err3("ins","zxw_file",g_zxw01,g_zxw[l_ac].zxw02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
          #   CANCEL INSERT
          #ELSE
          #   ###FUN-C10004 START ###
          #   IF g_zxw[l_ac].zxw03 = "2" THEN
          #      LET l_wzy02 = "3"
          #   ELSE
          #      LET l_wzy02 = g_zxw[l_ac].zxw03
          #   END IF
          #   EXECUTE p_zxw_wzy_ins_pre011 USING g_zxw01,l_wzy02,g_zxw[l_ac].zxw04
          #   IF SQLCA.SQLCODE THEN
          #      CALL cl_err3("ins","wzy_file",g_zxw01,g_zxw[l_ac].zxw04,SQLCA.SQLCODE,"","",0)
          #      ROLLBACK WORK
          #      CANCEL INSERT
          #   ###FUN-C10004 END ###
          ###FUN-C70005 mark END ###
          ###FUN-C70005 START ###
          #因為此函式在新增時不會執行BEGIN WORK,所以無法ROLLBACK
          #p_webauth不能新增重複資料,藉由p_webauth新增成功,再新增p_zxw
          IF g_zxw[l_ac].zxw03 = "2" THEN
             LET l_wzy02 = "3"
          ELSE
             LET l_wzy02 = g_zxw[l_ac].zxw03
          END IF
          EXECUTE p_zxw_wzy_ins_pre011 USING g_zxw01,l_wzy02,g_zxw[l_ac].zxw04
          IF SQLCA.SQLCODE THEN
             CALL cl_err3("ins","wzy_file",g_zxw01,g_zxw[l_ac].zxw04,SQLCA.SQLCODE,"","",0)
             CANCEL INSERT
          ELSE
             INSERT INTO zxw_file(zxw01,zxw02,zxw03,zxw04,
                                   zxw05,zxw06,zxw07,zxw08)
                  VALUES(g_zxw01,g_zxw[l_ac].zxw02,g_zxw[l_ac].zxw03,
                         g_zxw[l_ac].zxw04,g_zxw[l_ac].zxw05,g_zxw[l_ac].zxw06,
                         g_zxw[l_ac].zxw07,g_zxw[l_ac].zxw08)
             IF SQLCA.SQLCODE THEN
                CALL cl_err3("ins","zxw_file",g_zxw01,g_zxw[l_ac].zxw02,SQLCA.SQLCODE,"","",0)
                CANCEL INSERT
             ###FUN-C70005 END ###
             ELSE     #FUN-C10004
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
             END IF   #FUN-C10004
          END IF

       BEFORE FIELD zxw02                        #default 序號
          IF g_zxw[l_ac].zxw02 IS NULL OR g_zxw[l_ac].zxw02=0 THEN
             SELECT max(zxw02)+1 INTO g_zxw[l_ac].zxw02 FROM zxw_file
              WHERE zxw01=g_zxw01
             IF g_zxw[l_ac].zxw02 IS NULL THEN
                LET g_zxw[l_ac].zxw02=1
             END IF
          END IF

       AFTER FIELD zxw02                        #check 序號是否重複
          IF NOT cl_null(g_zxw[l_ac].zxw02) THEN
             IF  g_zxw[l_ac].zxw02=0 THEN
                NEXT FIELD zxw02
             END IF
             IF g_zxw[l_ac].zxw02 != g_zxw_t.zxw02 OR
                g_zxw_t.zxw03 IS NULL THEN
                SELECT count(*) INTO l_n FROM zxw_file
                 WHERE zxw01 = g_zxw01
                   AND zxw02 = g_zxw[l_ac].zxw02
                IF l_n > 0 THEN
                   CALL cl_err(g_zxw[l_ac].zxw03,-239,0)
                   LET g_zxw[l_ac].zxw02 = g_zxw_t.zxw02
                   NEXT FIELD zxw02
                END IF
             END IF
          END IF

       BEFORE FIELD zxw03
          CALL p_zxw_set_entry_b(p_cmd)

       AFTER FIELD zxw03
          IF NOT cl_null(g_zxw[l_ac].zxw03) THEN
             IF g_zxw[l_ac].zxw03="1" AND g_zxw_t.zxw03="2" THEN
#               LET g_zxw05[l_ac].zxw05 = ""
                LET g_zxw[l_ac].zxw05 = ""         #MOD-490480
                LET g_zxw[l_ac].zxw06 = ""
                LET g_zxw[l_ac].zxw07 = ""
                LET g_zxw[l_ac].zxw08 = ""
             END IF   #TQC-5C0116
           # #FUN-870036
           # IF g_zxw[l_ac].zxw03="2" AND cl_null(g_zxw[l_ac].zxw06) THEN
           #    LET g_zxw[l_ac].zxw06 = "0"
           # END IF
           # IF g_zxw[l_ac].zxw03="2" AND cl_null(g_zxw[l_ac].zxw07) THEN
           #    LET g_zxw[l_ac].zxw07 = "0"
           # END IF
           # IF g_zxw[l_ac].zxw03="2" AND cl_null(g_zxw[l_ac].zxw08) THEN
           #    LET g_zxw[l_ac].zxw08 = "0"
           # END IF
          END IF
          DISPLAY g_zxw[l_ac].zxw06,g_zxw[l_ac].zxw07,g_zxw[l_ac].zxw08
               TO zxw06,zxw07,zxw08
          CALL p_zxw_set_no_entry_b(p_cmd)

        ON CHANGE zxw03                             #MOD-490480
          IF NOT cl_null(g_zxw[l_ac].zxw03) THEN
              IF g_zxw[l_ac].zxw03 = "1" THEN       #MOD-540026
                CALL cl_set_act_visible("modify_auth,modify_detail_auth",FALSE)
             ELSE
                CALL cl_set_act_visible("modify_auth,modify_detail_auth",TRUE)
             END IF
          END IF

       AFTER FIELD zxw04
          IF NOT cl_null(g_zxw[l_ac].zxw04) THEN
             IF g_zxw[l_ac].zxw03="1" THEN #權限類別
                IF g_zxw[l_ac].zxw04!=g_zxw_t.zxw04
                   OR cl_null(g_zxw_t.zxw04) THEN
                   SELECT zw02,zwacti INTO g_zxw[l_ac].gaz03
                     FROM zw_file
                    WHERE zw01=g_zxw[l_ac].zxw04
                   IF STATUS THEN
                      #CALL cl_err("sel zw:",STATUS,0)  #No.FUN-660081
                      CALL cl_err3("sel","zw_file",g_zxw[l_ac].zxw04,"",STATUS,"","sel zw",0)    #No.FUN-660081
                      LET g_zxw[l_ac].zxw04=g_zxw_t.zxw04
                      LET g_zxw[l_ac].gaz03=g_zxw_t.gaz03
                      NEXT FIELD zxw04
                   ELSE
                      IF lc_zwacti = "N" THEN
                         CALL cl_err_msg(NULL,"azz-218",g_zxw[l_ac].zxw04 CLIPPED,10)
                         NEXT FIELD zxw04
                      END IF
                   END IF
                END IF
             END IF
             IF g_zxw[l_ac].zxw03="2" THEN #程式編號
                IF g_zxw[l_ac].zxw04!=g_zxw_t.zxw04
                   OR cl_null(g_zxw_t.zxw04) THEN

#                  #MOD-540163
#                  SELECT COUNT(gaz03) INTO l_cnt FROM gaz_file
#                   WHERE gaz01=g_zxw[l_ac].zxw04 AND gaz02=g_lang
#                  IF l_cnt > 1 THEN
#                     SELECT gaz03 INTO g_zxw[l_ac].gaz03 FROM gaz_file
#                      WHERE gaz01=g_zxw[l_ac].zxw04 AND gaz02=g_lang AND gaz05 = 'Y'
#                  ELSE
#                     SELECT gaz03 INTO g_zxw[l_ac].gaz03 FROM gaz_file
#                      WHERE gaz01=g_zxw[l_ac].zxw04 AND gaz02=g_lang AND gaz05 = 'N'
#                  END IF
                   CALL cl_get_progname(g_zxw[l_ac].zxw04,g_lang) RETURNING g_zxw[l_ac].gaz03

                   IF STATUS THEN
                      CALL cl_err("sel zz:",STATUS,0)
                      LET g_zxw[l_ac].zxw04=g_zxw_t.zxw04
                      LET g_zxw[l_ac].gaz03=g_zxw_t.gaz03
                      NEXT FIELD zxw04
                   END IF

#                  #MOD-540204
                   #-------------NO.FUN-870036 START--------------
                   IF cl_null(g_zxw[l_ac].zxw05) THEN  # AND g_zxw[l_ac].zxw06 IS NULL AND
                   #  g_zxw[l_ac].zxw07 IS NULL AND g_zxw[l_ac].zxw08 IS NULL THEN
                      SELECT zz04 INTO g_zxw[l_ac].zxw05            #,zz18,zz19,zz32
                   #    INTO g_zxw[l_ac].zxw05,g_zxw[l_ac].zxw06,   #MOD-490480
                   #         g_zxw[l_ac].zxw07,g_zxw[l_ac].zxw08
                        FROM zz_file
                       WHERE zz01=g_zxw[l_ac].zxw04
                      IF g_zxw[l_ac].zxw03="2" AND cl_null(g_zxw[l_ac].zxw06) THEN
                         LET g_zxw[l_ac].zxw06 = "0"
                      END IF
                      IF g_zxw[l_ac].zxw03="2" AND cl_null(g_zxw[l_ac].zxw07) THEN
                         LET g_zxw[l_ac].zxw07 = "0"
                      END IF
                      IF g_zxw[l_ac].zxw03="2" AND cl_null(g_zxw[l_ac].zxw08) THEN
                         LET g_zxw[l_ac].zxw08 = "0"
                      END IF
                      #-------------NO.FUN-870036 END----------------
                      #-------------NO.MOD-5A0095 START--------------
                      DISPLAY g_zxw[l_ac].zxw05, g_zxw[l_ac].zxw06,
                              g_zxw[l_ac].zxw07, g_zxw[l_ac].zxw08
                           TO zxw05,zxw06,zxw07,zxw08
                      #-------------NO.MOD-5A0095 END----------------
                   END IF
                END IF
             END IF
          END IF

       BEFORE DELETE
          IF g_zxw_t.zxw02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM zxw_file
              WHERE zxw01 = g_zxw01
                AND zxw02 = g_zxw_t.zxw02
             IF SQLCA.sqlcode THEN
                #CALL cl_err(g_zxw_t.zxw02,SQLCA.sqlcode,0)  #No.FUN-660081
                CALL cl_err3("del","zxw_file",g_zxw01,g_zxw_t.zxw02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                ROLLBACK WORK
                CANCEL DELETE
             END IF

             ###FUN-C10004 START ###
             IF g_zxw_t.zxw03 = "2" THEN
                LET l_wzy02_t = "3"
             ELSE
                LET l_wzy02_t = g_zxw_t.zxw03
             END IF
             IF g_zxw[l_ac].zxw03 = "2" THEN
                LET l_wzy02 = "3"
             ELSE
                LET l_wzy02 = g_zxw[l_ac].zxw03
             END IF
             EXECUTE p_zxw_wzy_del_pre USING g_zxw01,l_wzy02_t,g_zxw_t.zxw04
             IF SQLCA.SQLCODE THEN
                CALL cl_err3("del","wzy_file",g_zxw01,g_zxw_t.zxw04,SQLCA.sqlcode,"","",0)
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             ###FUN-C10004 END ###
             COMMIT WORK
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF

       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_zxw[l_ac].* = g_zxw_t.*
             CLOSE p_zxw_wzy_bcl   #FUN-C10004
             CLOSE p_zxw_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_zxw[l_ac].zxw03,-263,1)
             LET g_zxw[l_ac].* = g_zxw_t.*
          ELSE
             UPDATE zxw_file SET zxw03 = g_zxw[l_ac].zxw03,
                                 zxw04 = g_zxw[l_ac].zxw04,
#                                zxw05 = g_zxw05[l_ac].zxw05,
                                  zxw05 = g_zxw[l_ac].zxw05,         #MOD-490480
                                 zxw06 = g_zxw[l_ac].zxw06,
                                 zxw07 = g_zxw[l_ac].zxw07,
                                 zxw08 = g_zxw[l_ac].zxw08
              WHERE zxw01=g_zxw01
                AND zxw02=g_zxw_t.zxw02
             IF SQLCA.sqlcode THEN
                #CALL cl_err(g_zxw[l_ac].zxw02,SQLCA.sqlcode,0)  #No.FUN-660081
                CALL cl_err3("upd","zxw_file",g_zxw01,g_zxw_t.zxw02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                LET g_zxw[l_ac].* = g_zxw_t.*
             ELSE
                ###FUN-C10004 START ###
                IF g_zxw_t.zxw03 = "2" THEN
                   LET l_wzy02_t = "3"
                ELSE
                   LET l_wzy02_t = g_zxw_t.zxw03
                END IF
                IF g_zxw[l_ac].zxw03 = "2" THEN
                   LET l_wzy02 = "3"
                ELSE
                   LET l_wzy02 = g_zxw[l_ac].zxw03
                END IF
                EXECUTE p_zxw_wzy_upd_pre02 USING l_wzy02,g_zxw[l_ac].zxw04,
                                                  g_zxw01,l_wzy02_t,g_zxw_t.zxw04
                IF SQLCA.SQLCODE THEN
                   CALL cl_err3("upd","wzy_file",g_zxw01,g_zxw_t.zxw04,SQLCA.SQLCODE,"","",0)
                   LET g_zxw[l_ac].* = g_zxw_t.*
                   ROLLBACK WORK
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
                ###FUN-C10004 END ###
             END IF
          END IF

       AFTER ROW
          LET l_ac = ARR_CURR()
#         LET l_ac_t = l_ac      #FUN-D30034 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_zxw[l_ac].* = g_zxw_t.*
             #FUN-D30034---add---str---
             ELSE
                CALL g_zxw.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034---add---end---
             END IF
             CLOSE p_zxw_wzy_bcl   #FUN-C10004
             CLOSE p_zxw_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac      #FUN-D30034 add
          CLOSE p_zxw_wzy_bcl   #FUN-C10004
          CLOSE p_zxw_bcl
          COMMIT WORK

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION modify_auth
          # 2004/08/19 改變權限顯示值
          # 2004/09/10 不改變顯示名稱
#         CALL s_act_define(g_zxw01, g_zxw[l_ac].zxw04,'zxw_file', g_zxw05[l_ac].zxw05,g_zxw[l_ac].zxw08)
          CALL s_act_define(g_zxw01, g_zxw[l_ac].zxw04,'zxw_file', g_zxw[l_ac].zxw05,g_zxw[l_ac].zxw08)
               RETURNING g_zxw[l_ac].zxw05,g_zxw[l_ac].zxw08
#         CALL s_act_desc_tab(g_zxw[l_ac].zxw04,g_zxw05[l_ac].zxw05,g_zxw[l_ac].zxw08,"1") RETURNING g_zxw[l_ac].zxw05
          DISPLAY g_zxw[l_ac].zxw05 TO zxw05           #MOD-490216
          DISPLAY g_zxw[l_ac].zxw03 TO zxw03
          DISPLAY g_zxw[l_ac].zxw08 TO zxw08

        ON ACTION modify_detail_auth   #MOD-540026
          CALL s_act_detail(g_zxw[l_ac].zxw08) RETURNING g_zxw[l_ac].zxw08
          DISPLAY g_zxw[l_ac].zxw08 TO zxw08

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121

       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121

       ON ACTION controlp      #FUN-620047
          CASE
            WHEN INFIELD(zxw04)
               CALL cl_init_qry_var()
               IF g_zxw[l_ac].zxw03="2" THEN
                  LET g_qryparam.form ="q_gaz"
                  LET g_qryparam.arg1 = g_lang CLIPPED
               ELSE
                  LET g_qryparam.form ="q_zw"
               END IF
               LET g_qryparam.default1 = g_zxw[l_ac].zxw04
               CALL cl_create_qry() RETURNING g_zxw[l_ac].zxw04
               DISPLAY g_zxw[l_ac].zxw04 TO zxw04
          END CASE
#No.FUN-6A0092------Begin--------------
     ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
#No.FUN-6A0092-----End------------------

   END INPUT
   CLOSE p_zxw_wzy_bcl   #FUN-C10004
   CLOSE p_zxw_bcl
   COMMIT WORK

END FUNCTION

FUNCTION p_zxw_add()
   DEFINE l_zxw02 LIKE zxw_file.zxw02
   DEFINE l_zx04  LIKE zx_file.zx04
   DEFINE l_gaz03 LIKE gaz_file.gaz03

    SELECT COUNT(*) INTO l_n from zx_file    #判斷za_file是否有值
     WHERE zx01=g_zxw01
       AND (zx04 !=''  OR zx04 !=' ')

    IF l_n >0 THEN
       SELECT COUNT(*) INTO l_n from zxw_file,zx_file #判斷zxw_file是否有值
        WHERE zxw01=g_zxw01
          AND zxw01=zx01
          AND zxw04=zx04

       IF l_n>0 THEN
          RETURN
       END IF

       IF cl_confirm('azz-006') THEN
          SELECT MAX(zxw02)+1 INTO l_zxw02 From zxw_file   #抓最大項次
           WHERE zxw01=g_zxw01

          IF cl_null(l_zxw02) OR l_zxw02=0 THEN
             LET l_zxw02=1
          END IF

          SELECT zx04 INTO l_zx04                      #抓權限類別
            FROM zx_file
           WHERE zx01=g_zxw01

          IF STATUS THEN
             #CALL cl_err("zx_file:",STATUS,0)  #No.FUN-660081
             CALL cl_err3("sel","zx_file",g_zxw01,"",STATUS,"","zx_file",0)    #No.FUN-660081
          END IF

          SELECT COUNT(*) INTO l_n FROM zxw_file
           WHERE zxw01=g_zxw01
             AND zxw04=l_zx04

          IF l_n>0 THEN
             CALL cl_err('','azz-007',0)
             RETURN
          END IF

          BEGIN WORK   #FUN-C10004
          INSERT INTO zxw_file(zxw01,zxw02,zxw03,zxw04,
                                zxw05,zxw06,zxw07,zxw08)  #No.MOD-470041
               VALUES(g_zxw01,l_zxw02,'1',l_zx04,'','','','')

          IF SQLCA.sqlcode THEN
             #CALL cl_err(g_zxw[l_ac].zxw02,SQLCA.sqlcode,0)  #No.FUN-660081
             CALL cl_err3("ins","zxw_file",g_zxw01,l_zxw02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
             ROLLBACK WORK   #FUN-C10004
             RETURN
          ELSE
             ###FUN-C10004 START ###
             EXECUTE p_zxw_wzy_ins_pre011 USING g_zxw01,'1',l_zx04
             IF SQLCA.SQLCODE THEN
                CALL cl_err3("ins","wzy_file",g_zxw01,l_zx04,SQLCA.SQLCODE,"","",0)
                ROLLBACK WORK
                RETURN
             ELSE
                COMMIT WORK
             END IF
             ###FUN-C10004 END ###
          END IF

          CALL p_zxw_bf('1=1')
       END IF
    END IF

END FUNCTION

FUNCTION p_zxw_bf(p_wc)              #BODY FILL UP

#  DEFINE p_wc            LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(200)
   DEFINE p_wc            STRING

   LET g_sql = "SELECT zxw02,zxw03,zxw04,'',zxw05,zxw06,zxw07,zxw08 ",
               " FROM zxw_file ",
               " WHERE zxw01 = '",g_zxw01,"' ",
               " ORDER BY 1"
   PREPARE p_zxw_prepare2 FROM g_sql      #預備一下
   DECLARE zxw_cs CURSOR FOR p_zxw_prepare2

   CALL g_zxw.clear()
   CALL g_zxw05.clear()
   LET g_cnt = 1
   LET g_rec_b=0

   FOREACH zxw_cs INTO g_zxw[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
#     ELSE
#        # 2004/08/19 改變權限顯示值
#        LET g_zxw05[g_cnt].zxw05=g_zxw[g_cnt].zxw05    #MOD-490216
#        CALL s_act_desc_tab(g_zxw[g_cnt].zxw04,g_zxw05[g_cnt].zxw05,g_zxw[g_cnt].zxw08,"1") RETURNING g_zxw[g_cnt].zxw05
      END IF
      IF g_zxw[g_cnt].zxw03="1" THEN
         SELECT zw02 INTO g_zxw[g_cnt].gaz03 FROM zw_file
          WHERE zw01=g_zxw[g_cnt].zxw04
         LET g_zxw[g_cnt].zxw05=""                      #TQC-5A0094
         LET g_zxw[g_cnt].zxw06=""                      #TQC-5A0094
         LET g_zxw[g_cnt].zxw07=""                      #TQC-5A0094
         LET g_zxw[g_cnt].zxw08=""                      #TQC-5A0094
      ELSE
#        #MOD-540163
         CALL cl_get_progname(g_zxw[g_cnt].zxw04,g_lang) RETURNING g_zxw[g_cnt].gaz03
#        SELECT gaz03 INTO g_zxw[g_cnt].gaz03 FROM gaz_file
#         WHERE gaz01=g_zxw[g_cnt].zxw04 AND gaz02=g_lang order by gaz05
      END IF
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_zxw.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION p_zxw_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)

    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF

    LET g_action_choice = " "

    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_zxw TO s_zxw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

        BEFORE DISPLAY
           CALL cl_navigator_setting(g_curs_index, g_row_count)

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

        ON ACTION detail
           LET g_action_choice="detail"
           EXIT DISPLAY

        ON ACTION output
           LET g_action_choice="output"
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

        ON ACTION first
           CALL p_zxw_fetch('F')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

        ON ACTION previous
           CALL p_zxw_fetch('P')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	   ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

        ON ACTION jump
           CALL p_zxw_fetch('/')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	   ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

        ON ACTION next
           CALL p_zxw_fetch('N')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	   ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

        ON ACTION last
           CALL p_zxw_fetch('L')
           CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	   ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

        ON ACTION reproduce  #FUN-7C0041
           LET g_action_choice="reproduce"
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

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

        ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
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

FUNCTION p_zxw_copy()    #FUN-7C0041

   DEFINE l_newno      LIKE zxw_file.zxw01,
          l_oldno      LIKE zxw_file.zxw01
   DEFINE lc_zx01      LIKE zx_file.zx01

   IF s_shut(0) THEN RETURN END IF                #檢查權限

   IF cl_null(g_zxw01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_newno FROM zxw01

      AFTER FIELD zxw01
         IF cl_null(l_newno) THEN
            NEXT FIELD zxw01
         END IF
         SELECT count(*) INTO g_cnt FROM zxw_file
          WHERE zxw01 = l_newno
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD zxw01
         END IF

         # Check zx_file
         SELECT zx01 INTO lc_zx01 FROM zx_file
          WHERE zx01 = l_newno
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("sel","zx_file",l_newno,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
            NEXT FIELD zxw01
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

   END INPUT

   IF INT_FLAG OR l_newno IS NULL THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   DROP TABLE x

   SELECT * FROM zxw_file WHERE zxw01=g_zxw01 INTO TEMP x

   UPDATE x SET zxw01=l_newno     #資料鍵值

   BEGIN WORK   #FUN-C10004
   INSERT INTO zxw_file SELECT * FROM x

   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","zxw_file",l_newno,"",SQLCA.sqlcode,"","",0)
      ROLLBACK WORK   #FUN-C10004
      RETURN
   ELSE
      ###FUN-C10004 START ###
      UPDATE x SET zxw03='3' WHERE zxw03='2'
      LET g_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzy_file SELECT zxw01,zxw03,zxw04 FROM x"
      PREPARE p_zxw_wzy_ins_pre02 FROM g_sql
      EXECUTE p_zxw_wzy_ins_pre02
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("ins","wzy_file",l_newno,"",SQLCA.SQLCODE,"","",0)
         ROLLBACK WORK
         RETURN
      ELSE
         COMMIT WORK
      END IF
      ###FUN-C10004 END ###
   END IF

   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE 'COPY(',g_cnt USING '<<<<',') Rows O.K'
   LET g_zxw01 = l_newno  #FUN-C30027
   CALL p_zxw_show()      #FUN-C30027
END FUNCTION
#FUN-970073 start
FUNCTION p_zxw_out()
#DEFINE
#    l_i             LIKE type_file.num5,          #No.FUN-680135 SMALLINT
#    sr              RECORD LIKE zxw_file.*,
#    l_name          LIKE type_file.chr20,         #External(Disk) file name  #No.FUN-680135 VARCHAR(20)
#    l_za05          LIKE type_file.chr1000        #No.FUN-680135 VARCHAR(40)
DEFINE  l_cmd       LIKE type_file.chr1000

    IF cl_null(g_wc) THEN
       LET g_wc=" zxw01='",g_zxw01,"'"
    END IF
    IF g_wc IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET l_cmd = 'p_query "p_zxw" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT *  FROM zxw_file",          # 組合出 SQL 指令
#              " WHERE ",g_wc CLIPPED
#    PREPARE p_zxw_p1 FROM g_sql                   # RUNTIME 編譯
#    DECLARE p_zxw_co                              # SCROLL CURSOR
#        CURSOR FOR p_zxw_p1
#
#    CALL cl_outnam('p_zxw') RETURNING l_name
#    START REPORT p_zxw_rep TO l_name
#
#    FOREACH p_zxw_co INTO sr.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT p_zxw_rep(sr.*)
#    END FOREACH
#
#    FINISH REPORT p_zxw_rep
#
#    CLOSE p_zxw_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

#REPORT p_zxw_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
#    sr              RECORD LIKE zxw_file.*,
#    l_zx02          LIKE zx_file.zx02
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.zxw01,sr.zxw02
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,
#                  g_x[32] CLIPPED,
#                  g_x[33] CLIPPED,
#                  g_x[34] CLIPPED,
#                  g_x[35] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.zxw01
#            SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=sr.zxw01
#            PRINT COLUMN g_c[31],sr.zxw01,
#                  COLUMN g_c[32],l_zx02;
#
#        ON EVERY ROW
#            PRINT COLUMN g_c[33],sr.zxw03,
#                  COLUMN g_c[34],sr.zxw04,
#                  COLUMN g_c[35],sr.zxw05
#
#        AFTER  GROUP OF sr.zxw01
#              SKIP 1 LINE
#
#        ON LAST ROW
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#               THEN PRINT g_dash[1,g_len]
#                    IF g_wc.substring(001,080) > ' ' THEN
#                       PRINT g_x[8] CLIPPED,g_wc.substring(001,070) CLIPPED END IF
#                    IF g_wc.substring(071,140) > ' ' THEN
#                       PRINT COLUMN 10,     g_wc.substring(071,140) CLIPPED END IF
#                    IF g_wc.substring(141,210) > ' ' THEN
#                       PRINT COLUMN 10,     g_wc.substring(141,210) CLIPPED END IF
#            END IF
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#FUN-970073 end
##   #TQC-5A0094   #NO.MOD-590329 MARK #NO.MOD-580056
FUNCTION p_zxw_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)

   IF NOT g_before_input_done OR INFIELD(zxw03) THEN    #TQC-5C0116
    #MOD-A30223---modify---start---
    #CALL cl_set_comp_entry("zxw05,zxw06,zxw07,zxw08",TRUE)
    #CALL cl_set_comp_required("zxw05,zxw06,zxw07,zxw08",TRUE)
     CALL cl_set_comp_entry("zxw06,zxw07,zxw08",TRUE)
     CALL cl_set_comp_required("zxw06,zxw07,zxw08",TRUE)
    #MOD-A30223---modify---end---
#    CALL cl_set_comp_entry("zxw02",TRUE)
   END IF

END FUNCTION

FUNCTION p_zxw_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)

   IF NOT g_before_input_done OR INFIELD(zxw03) THEN   #TQC-5C0116
      IF g_zxw[l_ac].zxw03='1' THEN
         CALL cl_set_comp_entry("zxw05,zxw06,zxw07,zxw08",FALSE)
         CALL cl_set_comp_required("zxw05,zxw06,zxw07,zxw08",FALSE)
#        CALL cl_set_comp_entry("zxw02",FALSE)
      END IF
   END IF

END FUNCTION
#   #TQC-5A0094   #No.MOD-580056 --end #NO.MOD-590329

#Patch....NO.MOD-5A0095 <002> #
