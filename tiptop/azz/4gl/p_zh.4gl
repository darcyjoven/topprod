# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: p_zh.4gl
# Descriptions...: 程式歷程維護作業
# Date & Author..: 03/08/22 By Letter
# Modify.........: No.MOD-470041 04/07/19 By Wiky 修改INSERT INTO...
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-740155 07/04/26 By kim zz02以gaz03取代
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/13 By destiny display xxx.*改為display對應欄位
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_gam           RECORD LIKE gam_file.*,     #程式歷程維護作業(單頭)
    g_gam_t         RECORD LIKE gam_file.*,     #程式歷程維護作業(舊值)
    g_gam_o         RECORD LIKE gam_file.*,     #程式歷程維護作業(舊值)
    g_gam01_t         LIKE gam_file.gam01,      #程式代號(舊值)
    g_gaz03           LIKE gaz_file.gaz03,        #(程式名稱) #TQC-740155
    g_gan        DYNAMIC ARRAY of RECORD        #程式變數-單身(Program Variables)
        gan01         LIKE gan_file.gan01,      #項次
        ganmodu       LIKE gan_file.ganmodu,    #修改人
        gandate       LIKE gan_file.gandate,    #時間
        gan03         LIKE gan_file.gan03       #說明
    END RECORD,
    g_gan_t         RECORD                      #程式變數-單身(Program Variables)
        gan01         LIKE gan_file.gan01,      #項次
        ganmodu       LIKE gan_file.ganmodu,    #修改人
        gandate       LIKE gan_file.gandate,    #時間
        gan03         LIKE gan_file.gan03       #說明
    END RECORD,
    g_gan01_t           LIKE gan_file.gan01,    #(舊值)
    g_wc,g_wc2,g_sql    string,                 #No.FUN-580092 HCN
    g_cmd               LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(200)
    g_rec_b             LIKE type_file.num5,    #單身筆數              #No.FUN-680135 SMALLINT
    l_ac                LIKE type_file.num5,    #目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
    l_sl                LIKE type_file.num5,    #目前處理的SCREEN LINE #No.FUN-680135 SMALLINT
    g_argv1             LIKE gam_file.gam01     #程式代號
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-580092 HCN     #No.FUN-680135 INTEGER
DEFINE   g_jump         LIKE type_file.num10,  #No.FUN-680135 INTEGER
         g_no_ask       LIKE type_file.num5    #No.FUN-680135 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_log           LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql    STRING
DEFINE   g_before_input_done  LIKE type_file.num5   #No.FUN-680135 SMALLINT
 
MAIN
    OPTIONS                                     #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
    LET g_argv1 =ARG_VAL(1)
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AZZ")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096
 
    LET g_forupd_sql = "SELECT gam01,gam02 FROM gam_file  WHERE gam01 = ? ",
                         " FOR UPDATE "     # g_gam.gam01
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE zh_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW zh_w WITH FORM "azz/42f/p_zh"
    ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CALL zh_q()
       CALL zh_u()
       LET g_argv1=NULL
    END IF
 
    CALL zh_menu()
 
    CLOSE WINDOW zh_w                         #結束畫面
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
 
#QBE 查詢資料
FUNCTION zh_cs()
  IF NOT cl_null(g_argv1) THEN
    LET g_wc = " gam01 = '",g_argv1,"'"
  ELSE
    CLEAR FORM                             #清除畫面
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
     CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        gam01
 
#TQC-860017 start
        ON ACTION about
           CALL cl_about()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
     END CONSTRUCT
#TQC-860017 end
 
    IF INT_FLAG THEN RETURN END IF
  END IF
{
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND gamuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND gamgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND gamgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gamuser', 'gamgrup')
    #End:FUN-980030
 
}
 
    LET g_sql = "SELECT gam01 FROM gam_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY gam01"
 
    PREPARE gam_prepare FROM g_sql
    DECLARE gam_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR gam_prepare
 
    LET g_sql="SELECT COUNT(*) FROM gam_file WHERE ",g_wc CLIPPED
 
    PREPARE gam_precount FROM g_sql
    DECLARE gam_count CURSOR FOR gam_precount
 
END FUNCTION
 
#中文的MENU
FUNCTION zh_menu()
 
   WHILE TRUE
      CALL zh_bp("G")
      CASE g_action_choice
 
        WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL zh_a()
            END IF
 
        WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL zh_q()
            END IF
 
        WHEN "modify"
            CALL zh_u()
 
        WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL zh_b()
            ELSE
               LET g_action_choice = NULL
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
 
 
#Add  輸入
FUNCTION zh_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_gan.clear()
    INITIALIZE g_gam.* LIKE gam_file.*             #DEFAULT 設定
    LET g_gam01_t = NULL
    #預設值及將數值類變數清成零
    LET g_gam_o.* = g_gam.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_gam.gamuser=g_user
        LET g_gam.gamgrup=g_grup
        LET g_gam.gammodu=g_grup
        LET g_gam.gamdate=g_today
        CALL zh_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_gam.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_gam.gam01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_gam.gamoriu = g_user      #No.FUN-980030 10/01/04
        LET g_gam.gamorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO gam_file VALUES (g_gam.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            #CALL cl_err(g_gam.gam01,SQLCA.sqlcode,1)  #No.FUN-660081
            CALL cl_err3("ins","gam_file",g_gam.gam01,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
            CONTINUE WHILE
        END IF
        SELECT gam01 INTO g_gam.gam01 FROM gam_file
            WHERE gam01 = g_gam.gam01
        LET g_gam01_t = g_gam.gam01            #保留舊值
        LET g_gam_t.* = g_gam.*
 
        CALL g_gan.clear()
        LET g_rec_b = 0
        CALL zh_b()                            #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION zh_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,       #判斷必要欄位是否有輸入 #No.FUN-680135 VARCHAR(1) 
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改          #No.FUN-680135 VARCHAR(1)
    l_n             LIKE type_file.num5        #No.FUN-680135 SMALLINT
 
    DISPLAY BY NAME g_gam.gam01,g_gam.gam02
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_gam.gam01,g_gam.gam02
        WITHOUT DEFAULTS ATTRIBUTE (YELLOW) HELP 1
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL p_zh_set_entry(p_cmd)
           CALL p_zh_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD gam01
            IF g_gam.gam01 IS NULL THEN
               NEXT FIELD gam01
            END IF
            DISPLAY BY NAME g_gam.gam01 ATTRIBUTE(REVERSE)
 
         IF g_gam.gam01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_gam.gam01 != g_gam01_t) THEN
               SELECT count(*) INTO l_n FROM gam_file
                  WHERE gam01 = g_gam.gam01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_gam.gam01,-239,0)
                  LET g_gam.gam01 = g_gam01_t
                  DISPLAY BY NAME g_gam.gam01
                  NEXT FIELD gam01
               END IF
              # CALL i010_azb01('a')
              # IF NOT cl_null(g_errno) THEN
              #    CALL cl_err('gam01:',g_errno,0)
              #    LET g_azb.azb01 = g_azb01_t
              #    DISPLAY BY NAME g_azb.azb01
              #    NEXT FIELD azb01
              # END IF
            END IF
         END IF
 
        AFTER FIELD gam02
            IF g_gam.gam02 IS NULL THEN
               NEXT FIELD gam02
            END IF
            DISPLAY BY NAME g_gam.gam02 ATTRIBUTE(REVERSE)
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_gam.gam02)  THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_gam.gam02 ATTRIBUTE(REVERSE)
            END IF
            IF l_flag='Y' THEN
                CALL cl_err('','9033',0)
                NEXT FIELD gam02
            END IF
 
        ON KEY(CONTROL-F)                  #欄位說明
            CASE
                WHEN INFIELD(gam01) CALL cl_fldhlp('gam01')
                WHEN INFIELD(gam02) CALL cl_fldhlp('gam02')
                OTHERWISE           CALL cl_fldhlp('    ')
            END CASE
 
        ON KEY(CONTROL-O)                        # 沿用所有欄位
            IF INFIELD(gam01) THEN
                LET g_gam.* = g_gam_t.*
                #No.FUN-9A0024--begin 
                #DISPLAY BY NAME g_gam.*
                DISPLAY g_gam.gam01 TO gam01
                DISPLAY g_gam.gam02 TO gam02
                #No.FUN-9A0024--end
                 ATTRIBUTE(YELLOW)
                NEXT FIELD gam01
            END IF
 
        ON KEY(CONTROL-G)
            CALL cl_cmdask()
   
#TQC-860017 start
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
          CONTINUE INPUT
#TQC-860017 end
    END INPUT
END FUNCTION
 
FUNCTION p_zh_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gam01",TRUE)
   END IF
END FUNCTION
 
FUNCTION p_zh_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gam01",FALSE)
   END IF
END FUNCTION
 
#Query 查詢
FUNCTION zh_q()
    # 2004/02/06 by Hiko : 初始化單頭資料筆數.
     LET g_row_count = 0 #No.FUN-580092 HCN
    LET g_curs_index = 0
     CALL cl_navigator_setting(g_curs_index,g_row_count) #No.FUN-580092 HCN
 
    CALL cl_opmsg('q')
    MESSAGE ""
    INITIALIZE g_gam.* TO NULL
    CLEAR FORM
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL zh_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_gam.* TO NULL
        RETURN
    END IF
    MESSAGE " SEARCHING ! " ATTRIBUTE(REVERSE)
    OPEN gam_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_gam.* TO NULL
    ELSE
        OPEN gam_count
         FETCH gam_count INTO g_row_count #No.FUN-580092 HCN
         DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA) #No.FUN-580092 HCN
        CALL zh_fetch('F')                    # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION zh_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,      #處理方式    #No.FUN-680135 VARCHAR(1) 
    l_abso          LIKE type_file.num10      #絕對的筆數  #No.FUN-680135 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     gam_cs INTO g_gam.gam01
        WHEN 'P' FETCH PREVIOUS gam_cs INTO g_gam.gam01
        WHEN 'F' FETCH FIRST    gam_cs INTO g_gam.gam01
        WHEN 'L' FETCH LAST     gam_cs INTO g_gam.gam01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump gam_cs INTO g_gam.gam01
            LET g_no_ask = FALSE
    END CASE
 
    #Letter 加入
 
     #IF g_gam.gam01 IS NULL THEN
     #   LET g_gam.gam01=g_argv1
        #SELECT zz02 INTO g_zz02
        #FROM zz_file
        #WHERE zz01=g_gam.gam01
        #CALL zh_show()
        #加入單頭資料入資料庫
        #CALL zh_i('a')
        #INSERT INTO gam_file (gam01,gam02) VALUES(g_gam.gam01,g_gam.gam02)
        #CALL zh_u()
        #CALL zh_b()
 
     #ELSE
       #TQC-740155.............begin
       #LET g_zz02 =NULL 
       #SELECT gam02,zz02 INTO g_gam.gam02,g_zz02
       #FROM gam_file,OUTER zz_file
       #WHERE gam01 = g_gam.gam01
       #AND  zz01  = gam01
        LET g_gaz03=cl_get_progdesc(g_gam.gam01,g_lang)  #g_gam.gam01
       #TQC-740155.............end
        CALL zh_show()
     #END IF
 
 
#   #暫時Mark起來
#    
#   IF SQLCA.sqlcode THEN
#       CALL cl_err(g_gam.gam01,SQLCA.sqlcode,0)
#       RETURN
#   END IF
#
#   SELECT gam02,zz02 INTO g_gam.gam02,g_zz02
#     FROM gam_file,OUTER zz_file
#    WHERE gam01 = g_gam.gam01
#     AND  zz01  = gam01
#    
#   IF SQLCA.sqlcode THEN
#       CALL cl_err(g_gam.gam01,SQLCA.sqlcode,0)
#       INITIALIZE g_gam.* TO NULL
#       RETURN
#   END IF
#   CALL zh_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION zh_show()
    LET g_gam_t.* = g_gam.*                #保存單頭舊值
    LET g_gam_o.* = g_gam.*                #保存單頭舊值
   # DISPLAY BY NAME g_gam.*                #顯示單頭值
    DISPLAY g_gam.gam01 TO gam01
    DISPLAY g_gam.gam02 TO gam02
   #DISPLAY g_zz02 TO FORMONLY.zz02 #TQC-740155
    DISPLAY g_gaz03 TO FORMONLY.gaz03 #TQC-740155
    CALL zh_b_fill(g_wc)                   #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
{
FUNCTION zh_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_gam.gam01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN zh_cl USING g_gam.gam01
    IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN zh_cl',SQLCA.sqlcode,1)   #資料被他人LOCK
        RETURN
    END IF
 
    FETCH zh_cl INTO g_gam.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err('FETCH zh_cl',SQLCA.sqlcode,1)   #資料被他人LOCK
        RETURN
    END IF
    CALL zh_show()
    IF cl_delh(0,0) THEN                   #確認一下
         DELETE FROM gam_file WHERE gam01 = g_gam.gam01
         DELETE FROM gan_file WHERE gan03 = g_gam.gam01
         INITIALIZE g_gam.* TO NULL
         CLEAR FORM
    END IF
    CLOSE zh_cl
    #IF g_log = 'Y' THEN COMMIT WORK END IF
    COMMIT WORK
END FUNCTION
  }
#單身
FUNCTION zh_b()
DEFINE
 
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT     #No.FUN-680135 SMALLINT 
    l_n             LIKE type_file.num5,                #檢查重複用            #No.FUN-680135 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否            #No.FUN-680135 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,                #Esc結束INPUT ARRAY 否 #No.FUN-680135 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態              #No.FUN-680135 VARCHAR(1)
    l_cnt           LIKE type_file.num5,                #No.FUN-680135 SMALLINT
    l_jump          LIKE type_file.num5,                #判斷是否跳過AFTER ROW的處理 #No.FUN-680135 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否              #No.FUN-680135 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否              #No.FUN-680135 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_gam.gam01 IS NULL IS NULL THEN
        RETURN
    END IF
   #TQC-740155..............begin
   #SELECT gam01,gam02 INTO g_gam.gam01,g_gam.gam02 FROM gam_file WHERE gam01=g_gam.gam01
 
   #IF g_gam.gam01 IS NOT NULL THEN
   #  SELECT zz02 INTO g_zz02 FROM zz_file WHERE zz01=g_gam.gam01 
   #END IF
    LET g_gaz03=cl_get_progdesc(g_gam.gam01,g_lang) #TQC-740155
   #TQC-740155..............end
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT gan01,ganmodu,gandate,gan03 FROM gan_file ",
                        "  WHERE gan02 = ? AND gan01= ? ",
                          " FOR UPDATE " # g_gam.gam01 g_gan_t.gan01
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE gam_bcl CURSOR FROM g_forupd_sql    # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_ac_t = 0
    WHILE TRUE
        LET l_exit_sw = "y"                #正常結束,除非 ^N
 
            LET g_gan[l_ac].ganmodu = g_user
            LET g_gan[l_ac].gandate=TODAY
        INPUT ARRAY g_gan
        WITHOUT DEFAULTS
        FROM s_gan.*
 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  #ATTRIBUTE(RED)
            LET g_gan_t.* = g_gan[l_ac].*  #BACKUP
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN zh_cl USING g_gam.gam01
            IF SQLCA.sqlcode THEN
               CALL cl_err('OPEN zh_cl',SQLCA.sqlcode,1)
               CLOSE zh_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH zh_cl INTO g_gam.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err('FETCH zh_cl',SQLCA.sqlcode,1)
               CLOSE zh_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_gan_t.gan01 IS NOT NULL THEN
                LET p_cmd='u'
                OPEN gam_bcl USING g_gam.gam01, g_gan_t.gan01
                IF SQLCA.sqlcode THEN
                    CALL cl_err('OPEN gam_bcl',SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
 
                FETCH gam_bcl INTO g_gan[l_ac].*
                IF SQLCA.sqlcode THEN
                    CALL cl_err('FETCH gam_bcl',SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
            ELSE
                LET p_cmd='a'  #輸入新資料
             INITIALIZE g_gan[l_ac].* TO NULL  #900423
                LET g_gan[l_ac].ganmodu = g_user
                LET g_gan[l_ac].gandate=TODAY
            DISPLAY g_gan[l_ac].* TO s_gan[l_sl].* ATTRIBUTE (YELLOW)
            #     DISPLAY g_gan[l_ac].ganmodu TO s_gan[l_sl].ganmodu
            END IF
            IF l_ac <= l_n then                  #DISPLAY NEWEST
                DISPLAY g_gan[l_ac].* TO s_gan[l_sl].* ATTRIBUTE (YELLOW)
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            #NEXT FIELD gan02
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
         INITIALIZE g_gan[l_ac].* TO NULL        #900423
          {  SELECT MAX(gan01) INTO g_gan01_t FROM gan_file
            LET g_gan01_t =g_gan01_t+1
            LET g_gan[l_ac].gan01=g_gan01_t
          }
            LET g_gan_t.* = g_gan[l_ac].*           #新輸入資料
            LET g_gan[l_ac].ganmodu = g_user
            LET g_gan[l_ac].gandate=TODAY
            DISPLAY g_gan[l_ac].* TO s_gan[l_sl].* ATTRIBUTE (YELLOW)
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD gan01
 
        BEFORE FIELD gan01  #項次
            IF g_gan[l_ac].gan01 IS NULL OR g_gan[l_ac].gan01 = 0 THEN
                SELECT max(gan01)+1 INTO g_gan[l_ac].gan01
                   FROM gan_file WHERE gan02 = g_gam.gam01
                IF g_gan[l_ac].gan01 IS NULL THEN
                    LET g_gan[l_ac].gan01 = 1
                END IF
                DISPLAY g_gan[l_ac].gan01 TO s_gan[l_sl].gan01
            END IF
            IF  g_gan[l_ac].gan01 IS NOT NULL THEN
              IF g_gan_t.gan01 IS NULL THEN  # 單身新增
                 LET g_gan[l_ac].ganmodu=g_user
                 LET g_gan[l_ac].gandate=TODAY
                 DISPLAY g_gan[l_ac].ganmodu TO s_gan[l_sl].ganmodu
                 DISPLAY g_gan[l_ac].gandate TO s_gan[l_sl].gandate
                 NEXT FIELD gan03
              END IF
            END IF
 
        AFTER FIELD gan03
            IF g_gan[l_ac].gan03 IS NULL THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD gan03
            END IF
      {
        BEFORE DELETE                            #是否取消單身
            IF g_gan_t.gan01 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    LET l_exit_sw = "n"
                    LET l_ac_t = l_ac
                    EXIT INPUT
                END IF
                DELETE FROM gan_file
                    WHERE gan02 = g_gam.gam01
                      AND gan01 = g_gan_t.gan01
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_gan_t.gan01,SQLCA.sqlcode,0)
                    LET l_exit_sw = "n"
                    LET l_ac_t = l_ac
                    EXIT INPUT
                END IF
                    LET g_rec_b=g_rec_b-1
                    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            #IF g_log='Y' THEN COMMIT WORK END IF
                COMMIT WORK
            END IF
 
        AFTER DELETE
          LET l_n = ARR_COUNT()
          INITIALIZE g_gan[l_n+1].* TO NULL
          LET l_jump = 1
}
        AFTER ROW
                LET l_ac = ARR_CURR()    #FUN-D30034 Add
                DISPLAY g_gan[l_ac].* TO s_gan[l_sl].* ATTRIBUTE (YELLOW) 
                IF INT_FLAG THEN                 #900423
                    CALL cl_err('',9001,0)
                    LET INT_FLAG = 0
                   #FUN-D30034--mark&add--str--
                   #LET g_gan[l_ac].* = g_gan_t.*
                   #DISPLAY g_gan[l_ac].* TO s_gan[l_sl].* ATTRIBUTE (YELLOW)
                    IF p_cmd = 'u' THEN
                       LET g_gan[l_ac].* = g_gan_t.*
                    ELSE
                       CALL g_gan.deleteElement(l_ac)
                       IF g_rec_b != 0 THEN
                          LET g_action_choice = "detail"
                          LET l_ac = l_ac_t
                       END IF
                    END IF
                   #FUN-D30034--mark&add--end--
                    EXIT INPUT
                END IF
 
                IF g_gan[l_ac].gan01 IS NULL THEN  #重要欄位空白,無效
                    INITIALIZE g_gan[l_ac].* TO NULL
                    DISPLAY g_gan[l_ac].* TO s_gan[l_sl].* ATTRIBUTE (YELLOW)
                END IF
 
                IF  g_gan[l_ac].gan01 IS NOT NULL THEN
                    IF g_gan_t.gan01 IS NULL THEN  # 單身新增
                         INSERT INTO gan_file(gan01,gan02,gan03,ganmodu,gandate) #No.MOD-470041
                                     VALUES(g_gan[l_ac].gan01,g_gam.gam01,
                                            g_gan[l_ac].gan03,g_gan[l_ac].ganmodu,
                                            g_gan[l_ac].gandate)
                        IF SQLCA.sqlcode THEN
                            #CALL cl_err(g_gan[l_ac].gan01,SQLCA.sqlcode,0)  #No.FUN-660081
                            CALL cl_err3("ins","gan_file",g_gam.gam01,g_gan[l_ac].gan01,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                            LET g_gan[l_ac].* = g_gan_t.*
                            DISPLAY g_gan[l_ac].* TO s_gan[l_sl].* ATTRIBUTE (YELLOW)
                        ELSE
                            MESSAGE 'INSERT O.K'
                            #IF g_query='Y' THEN       #顯示合乎條件筆數
                                LET g_rec_b=g_rec_b+1
                                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                            #END IF
                            COMMIT WORK
                        END IF
                    END IF
                END IF
 
                IF g_gan[l_ac].gan01 IS NOT NULL THEN
                    IF g_gan_t.gan01 IS NOT NULL AND g_gan[l_ac+1].gan03 IS NOT NULL THEN
                       CALL cl_err('','azz-017',0)
                    END IF
                END IF
                LET l_ac_t = l_ac   #FUN-D30034 Add 
               #LET g_gan_t.* = g_gan[l_ac].*          # 900423    #FUN-D30034 Mark
 
 
        ON KEY(CONTROL-N)
            CALL zh_b_askkey()
            LET l_exit_sw = "n"
            EXIT INPUT
 
        ON KEY(CONTROL-O)                        #沿用所有欄位
            IF INFIELD(gan01) AND l_ac > 1 THEN
                LET g_gan[l_ac].* = g_gan[l_ac-1].*
                #LET g_gan[l_ac].gan03 = l_ac
                DISPLAY g_gan[l_ac].* TO s_gan[l_sl].* ATTRIBUTE (YELLOW)
                NEXT FIELD gan01
            END IF
 
        ON KEY(CONTROL-G)
            CALL cl_cmdask()
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON KEY(CONTROL-F)
            CASE
                WHEN INFIELD(gan02) CALL cl_fldhlp('gan02')
                WHEN INFIELD(gan01) CALL cl_fldhlp('gan01')
                WHEN INFIELD(gan05) CALL cl_fldhlp('gan05')
                OTHERWISE          CALL cl_fldhlp('    ')
            END CASE
#TQC-860017 start
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
#TQC-860017 end
 
        END INPUT
 
 
        IF l_exit_sw = "y" THEN
            EXIT WHILE                     #ESC 或 DEL 結束 INPUT
        ELSE
            CONTINUE WHILE                 #^N 結束 INPUT
        END IF
    END WHILE
 
    CLOSE gam_bcl
    #IF g_log = 'Y' THEN COMMIT WORK END IF
    COMMIT WORK
    CALL zh_delall()
END FUNCTION
 
FUNCTION zh_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_gam.gam01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT gam01 INTO g_gam.gam01 FROM gam_file
     WHERE gam01=g_gam.gam01
    CALL cl_opmsg('u')
    LET g_gam01_t = g_gam.gam01
    BEGIN WORK
 
    OPEN zh_cl USING g_gam.gam01
    IF SQLCA.sqlcode THEN
        CALL cl_err('FETCH z_cl',SQLCA.sqlcode,1)      # 資料被他人LOCK
        RETURN
    END IF
 
    FETCH zh_cl INTO g_gam.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err('FETCH z_cl',SQLCA.sqlcode,1)      # 資料被他人LOCK
        RETURN
    END IF
 
    CALL zh_show()
    WHILE TRUE
        LET g_gam01_t = g_gam.gam01
        LET g_gam_o.* = g_gam.*
        #LET g_gam.gammodu=g_user
        #LET g_gam.gamdate=g_today
        CALL zh_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_gam.*=g_gam_t.*
            CALL zh_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE gam_file SET gam02   = g_gam.gam02,
                            gammodu = g_user,
                            gamdate = today
            WHERE gam01 = g_gam.gam01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            #CALL cl_err(g_gam.gam02,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("upd","gam_file",g_gam01_t,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE zh_cl
    IF g_log = 'Y' THEN COMMIT WORK END IF
END FUNCTION
 
FUNCTION zh_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(200)
 
 CONSTRUCT l_wc2 ON gan02,gan01,gan05
            FROM s_gan[1].gan02,s_gan[1].gan01,s_gan[1].gan05
#TQC-860017 start
       ON ACTION about
          CALL cl_about()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    END CONSTRUCT
#TQC-860017 end
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL zh_b_fill(l_wc2)
END FUNCTION
 
FUNCTION zh_b_fill(p_wc2)                   #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(200)
    num_t           LIKE type_file.num10    #No.FUN-680135 INTEGER
    {
    LET g_sql =
        "SELECT gan01,ganmodu,gandate,gan03 ",
        " FROM gan_file ",
        " WHERE gan02 ='",g_gam.gam01 CLIPPED,"' AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
    }
    LET g_sql =
        "SELECT gan01,ganmodu,gandate,gan03 ",
        " FROM gan_file ",
        " WHERE gan02 ='",g_gam.gam01 CLIPPED,"' ",
        " ORDER BY 1"
 
    PREPARE gam_pb FROM g_sql
    DECLARE gan_curs                       #SCROLL CURSOR
        CURSOR FOR gam_pb
 
    CALL g_gan.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    LET num_t=0
    FOREACH gan_curs INTO g_gan[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        LET num_t=num_t + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
 
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    #IF g_query='Y' THEN                  #顯示合乎條件筆數
        DISPLAY g_rec_b TO FORMONLY.cn2   #ATTRIBUTE(RED)
        #LET g_cnt = 0
        #DISPLAY g_cnt   TO FORMONLY.cnt  #ATTRIBUTE(RED)
    #END IF
END FUNCTION
 
FUNCTION zh_bp(p_ud)
 
   DEFINE p_ud     LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   IF p_ud<>'G' OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gan TO s_gan.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()            #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY                    # Q.查詢
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY                    # Q.查詢
 
      ON ACTION next
         CALL zh_fetch('N')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL zh_fetch('P')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION first
         CALL zh_fetch('F')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL zh_fetch('/')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL zh_fetch('L')
          CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY                    # U.更改
 
{
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY                    # X.作廢
 
      ON ACTION delete
         LET g_action_choice='delete'
         EXIT DISPLAY                    # R.取消
}
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac =1
         EXIT DISPLAY                    # B.單身
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY                    # H.說明
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY                    # Esc.結束
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION zh_delall()
    SELECT COUNT(*) INTO g_cnt
      FROM gan_file
     WHERE gan02 = g_gam.gam01
    IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM gam_file WHERE gam01 = g_gam.gam01
       IF SQLCA.sqlcode THEN   			#置入資料庫不成功
          #CALL cl_err(g_gam.gam01,SQLCA.sqlcode,1)  #No.FUN-660081
          CALL cl_err3("del","gam_file",g_gam.gam01,"",SQLCA.sqlcode,"","",1)    #No.FUN-660081
       END IF
    END IF
 
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
