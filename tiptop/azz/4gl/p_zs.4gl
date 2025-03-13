# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_zs.4gl
# Descriptions...: 檔案架構修整記錄維護作業
# Date & Author..: 92/07/18 By yen
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN g_bottom_margin改5
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/23 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-790092 07/09/17 By rainy 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0015 09/11/04 By Carrier SQL STANDARDIZE
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE   g_zta              RECORD LIKE zta_file.*, #檔案架構修整記錄(假單頭)
         g_zta01_t          LIKE zta_file.zta01,    #檔案架構修整記錄(舊值)
         g_zta02_t          LIKE zta_file.zta02,    #檔案架構修整記錄(舊值)
         g_zta01            LIKE zta_file.zta01,    #
         g_zta02            LIKE zta_file.zta02,    #
         g_zs               DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
            zs03            LIKE zs_file.zs03,      #序號
            zs04            LIKE zs_file.zs04,      #修正日期
            zs05            LIKE zs_file.zs05,      #屬性
            zs06            LIKE zs_file.zs06,      #修正指令及說明
            zs07            LIKE zs_file.zs07,      #修正人
            zs08            LIKE zs_file.zs08,      #工作單號
            zs12            LIKE zs_file.zs12,      #正式成功否
            zs09            LIKE zs_file.zs09,      #測試區
            zs10            LIKE zs_file.zs10,      #正式區
            zs11            LIKE zs_file.zs11       #打包
                            END RECORD,
         g_zs_t             RECORD                  #程式變數 (舊值)
            zs03            LIKE zs_file.zs03,      #序號
            zs04            LIKE zs_file.zs04,      #修正日期
            zs05            LIKE zs_file.zs05,      #屬性
            zs06            LIKE zs_file.zs06,      #修正指令及說明
            zs07            LIKE zs_file.zs07,      #修正人
            zs08            LIKE zs_file.zs08,      #工作單號
            zs12            LIKE zs_file.zs12,      #正式成功否
            zs09            LIKE zs_file.zs09,      #測試區
            zs10            LIKE zs_file.zs10,      #正式區
            zs11            LIKE zs_file.zs11       #打包
                            END RECORD,
#     g_x                ARRAY[30] OF VARCHAR(40),
        #g_wc,g_wc2,g_sql   VARCHAR(1000),             #TQC-630166 
         g_wc,g_wc2,g_sql   STRING,   #TQC-630166
         g_status           LIKE type_file.num5,    #回傳指令執行正確否  #No.FUN-680135 SMALLINT
         g_rec_b            LIKE type_file.num5,    #單身筆數            #No.FUN-680135 SMALLINT
         l_ac               LIKE type_file.num5     #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
DEFINE   g_forupd_sql       STRING
DEFINE   g_curs_index       LIKE type_file.num10,   #No.FUN-680135 INTEGER
         g_row_count        LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_chr              LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt              LIKE type_file.num10    #No.FUN-680135 INTEGER
#DEFINE  g_dash             LIKE type_file.chr1000  #Dash line     #No.FUN-680135 VARCHAR(400)
DEFINE   g_i                LIKE type_file.num5     #count/index for any purpose  #No.FUN-680135 SMALLINT
DEFINE   g_msg              LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_gat03            LIKE gat_file.gat03     #No.FUN-680135 VARCHAR(36)
DEFINE   g_db_type          LIKE type_file.chr3     #No.FUN-680135 VARCHAR(3)
DEFINE   ch                 base.channel
DEFINE   g_MODNO            LIKE zs_file.zs08
DEFINE   g_jump             LIKE type_file.num10,   #No.FUN-680135 INTEGER
         mi_no_ask          LIKE type_file.num5     #No.FUN-680135 SMALLINT
 
#主程式開始
MAIN
#     DEFINE   l_time   LIKE type_file.chr8              #No.FUN-6A0096
   DEFINE   p_row,p_col     LIKE type_file.num5     #No.FUN-680135  SMALLINT
 
   OPTIONS                                          #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                  #擷取中斷鍵, 由程式處理
 
   LET g_zta.zta01 = ARG_VAL(1)                     #參數-1(table_name)
   LET g_zta.zta02 = ARG_VAL(2)                     #參數-2(db_name)
   LET g_MODNO     = ARG_VAL(3)                     #參數-3(mod#)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log               #忽略一切錯誤
 
   IF (NOT cl_setup("AZZ")) THEN                    #啟動程式: 預設必要值及檢查權限
       EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)                  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW p_zs_w AT p_row,p_col WITH FORM "azz/42f/p_zs"
   ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   LET g_db_type=cl_db_get_database_type()
 
   IF NOT cl_null(g_zta.zta01) OR NOT cl_null(g_zta.zta02) OR
      NOT cl_null(g_MODNO) THEN
      LET g_zta01=g_zta.zta01
      LET g_zta02=g_zta.zta02
      CALL p_zs_q()
   END IF
 
   CALL p_zs_menu()    #中文
 
   CLOSE WINDOW p_zs_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)     #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
#QBE 查詢資料
FUNCTION p_zs_cs()
   CLEAR FORM                           #清除畫面
   CALL g_zs.clear()
   IF NOT cl_null(g_zta01) AND NOT cl_null(g_zta02) THEN
      LET g_wc=" zta01='",g_zta01 CLIPPED,"' AND zta02='",g_zta02 CLIPPED,"'"
      LET g_wc2=" 1=1"
      LET g_zta01=''
      LET g_zta02=''
   ELSE
      IF g_MODNO IS NOT NULL THEN
         LET g_wc=" 1=1"
         LEt g_wc2=" zs08='",g_MODNO CLIPPED,"'"
      ELSE
         CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
         CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
          zta01,zta02,gat03,zta05,zta06
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
         #資料權限的檢查
         #Begin:FUN-980030
         #         IF g_priv2='4' THEN                           #只能使用自己的資料
         #             LET g_wc = g_wc clipped," AND ztauser = '",g_user,"'"
         #         END IF
         #         IF g_priv3='4' THEN                           #只能使用相同群的資料
         #             LET g_wc = g_wc clipped," AND ztagrup MATCHES '",g_grup CLIPPED,"*'"
         #         END IF
 
         #         IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         #             LET g_wc = g_wc clipped," AND ztagrup IN ",cl_chk_tgrup_list()
         #         END IF
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ztauser', 'ztagrup')
         #End:FUN-980030
 
 
      CONSTRUCT g_wc2 ON zs03,zs04,zs05,zs06,zs07,      # 螢幕上取單身條件
                            zs08,zs09,zs10,zs11,zs12
                 FROM s_zs[1].zs03,s_zs[1].zs04,s_zs[1].zs05,s_zs[1].zs06,
                      s_zs[1].zs07,s_zs[1].zs08,s_zs[1].zs09,s_zs[1].zs10,
                      s_zs[1].zs11,s_zs[1].zs12
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
         IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
      END IF
   END IF
 
   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
      LET g_sql = "SELECT  zta01,zta02 FROM zta_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 2"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT DISTINCT  zta01,zta02 ",
                  "  FROM zta_file, zs_file ",
                  " WHERE zta01 = zs01",
                  "   AND zta02 = zs02",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 2"
   END IF
 
   PREPARE p_zs_prepare FROM g_sql
   DECLARE p_zs_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR p_zs_prepare
 
   LET g_forupd_sql = "SELECT * FROM zta_file WHERE zta01=? and zta02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zs_cl CURSOR FROM g_forupd_sql
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM zta_file WHERE ",g_wc CLIPPED
   ELSE
      IF g_db_type="IFX" THEN
         LET g_sql="SELECT COUNT(*) FROM table(multiset(SELECT DISTINCT zta01,zta02 FROM zta_file ,zs_file ",
                   " WHERE zs01=zta01 AND zs02=zta02 AND ",
                   g_wc CLIPPED," AND ",g_wc2 CLIPPED,"))"
      ELSE
         LET g_sql="SELECT COUNT(*) FROM (SELECT DISTINCT zta01,zta02 FROM zta_file ,zs_file ",
                   " WHERE zs01=zta01 AND zs02=zta02 AND ",
                   g_wc CLIPPED," AND ",g_wc2 CLIPPED,")"
      END IF
   END IF
   PREPARE p_zs_precount FROM g_sql
   DECLARE p_zs_count CURSOR FOR p_zs_precount
END FUNCTION
 
FUNCTION p_zs_menu()
   WHILE TRUE
      CALL p_zs_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_zs_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() AND g_user='qazzaq' THEN
               CALL p_zs_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
--               MENU "" ATTRIBUTE(STYLE="popup")
#                COMMAND "1.列印修改記錄" CALL p_zs_out1()
--                 ON ACTION print_update_record
                    CALL p_zs_out1()
#                COMMAND "2.列印修改.sql" CALL p_zs_out2()
--                 ON ACTION print_update_sql
--                    CALL p_zs_out2()
#                COMMAND "X.執行修改.sql" RUN 'isql ds alter_ds.sql;read a'
--                 ON ACTION exe_update_sql
--                    RUN 'isql ds alter_ds.sql;read a'
#                COMMAND "Esc.結束" EXIT MENU
--                 ON IDLE g_idle_seconds
--                    CALL cl_on_idle()
--                    CONTINUE MENU
--               END MENU
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_zs),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION p_zs_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_zs.clear()
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
    CALL p_zs_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN p_zs_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('OPEN SCROLL CURSOR ERROR',SQLCA.sqlcode,0)
       INITIALIZE g_zta.* TO NULL
    ELSE
       OPEN p_zs_count
       FETCH p_zs_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL p_zs_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION p_zs_fetch(p_flag)
   DEFINE   p_flag    LIKE type_file.chr1,   #處理方式   #No.FUN-680135 VARCHAR(1) 
            l_abso    LIKE type_file.num10,  #絕對的筆數 #No.FUN-680135 INTEGER
            ls_jump   LIKE ze_file.ze03
 
   SELECT ze03 INTO ls_jump FROM ze_file WHERE ze01 = 'azz-020' AND ze02 = g_lang
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_zs_cs INTO g_zta.zta01,g_zta.zta02
      WHEN 'P' FETCH PREVIOUS p_zs_cs INTO g_zta.zta01,g_zta.zta02
      WHEN 'F' FETCH FIRST    p_zs_cs INTO g_zta.zta01,g_zta.zta02
      WHEN 'L' FETCH LAST     p_zs_cs INTO g_zta.zta01,g_zta.zta02
      WHEN '/'
         IF (NOT mi_no_ask) THEN
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
         FETCH ABSOLUTE g_jump p_zs_cs INTO g_zta.zta01,g_zta.zta02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zta.zta01,SQLCA.sqlcode,0)
      INITIALIZE g_zta.* TO NULL  #TQC-6B0105
      LET g_zta.zta01 = NULL LET g_zta.zta02 = NULL      #TQC-6B0105
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
   END IF
 
   SELECT * INTO g_zta.* FROM zta_file WHERE zta01=g_zta.zta01 and zta02=g_zta.zta02
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_zta.zta01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("sel","zta_file",g_zta.zta01,g_zta.zta02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
      INITIALIZE g_zta.* TO NULL
      RETURN
   END IF
   SELECT gat03 INTO g_gat03 FROM gat_file
    WHERE gat01 = g_zta.zta01
      AND gat02 = g_lang
   CALL p_zs_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION p_zs_show()                       # 顯示單頭值
   DISPLAY g_zta.zta01,g_zta.zta02,g_gat03,{g_zta.zta02,g_zta.zta02e,g_zta.zta02c,}
           g_zta.zta05,g_zta.zta06
        TO zta01,zta02,gat03,zta05,zta06
   CALL p_zs_b_fill(g_wc2)                 #單身
END FUNCTION
 
#單身
FUNCTION p_zs_b()
   DEFINE   l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,                 #檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680135 VARCHAR(1)
            l_cnt           LIKE type_file.num10,                #可更改否 (含取消) #No.FUN-680135 INTEGER
            l_z06           LIKE zs_file.zs06,
            l_zta03         LIKE zta_file.zta03,
            l_zta07         LIKE zta_file.zta07,
            l_top           LIKE type_file.chr50,                #No.FUN-680135 VARCHAR(25)
            l_str           LIKE type_file.chr1000,              #No.FUN-680135 VARCHAR(100)
            l_i             LIKE type_file.num5,                 #No.FUN-680135 SMALLINT
            l_cmd           LIKE type_file.chr1000,              #No.FUN-680135 VARCHAR(100)
            l_err           ARRAY[20] of LIKE type_file.chr1000  #No.FUN-680135 APPAY[20] of VARCHAR(80)
   DEFINE   l_allow_insert  LIKE type_file.num5,                 #No.FUN-680135 VARCHAR(1)
            l_allow_delete  LIKE type_file.num5                  #No.FUN-680135 VARCHAR(1)
 
   LET g_action_choice = ""
   IF g_zta.zta01 IS NULL OR g_zta.zta02 IS NULL THEN
      RETURN
   END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT zs03,zs04,zs05,zs06,zs07,zs08,zs12,zs09,zs10,zs11",
                      "  FROM zs_file",
                      "  WHERE zs01 = ? AND zs02=? AND zs03=?",
                      " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zs_bcl CURSOR FROM g_forupd_sql            # LOCK CURSOR
 
   INPUT ARRAY g_zs WITHOUT DEFAULTS FROM s_zs.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
--CKP, 除了為修改狀態外, 不需備份舊值
#         LET g_zs_t.* = g_zs[l_ac].*  #BACKUP
         LET l_lock_sw = 'N'            #DEFAULT
 
         BEGIN WORK
         OPEN p_zs_cl USING g_zta.zta01,g_zta.zta02
         IF STATUS THEN
            CALL cl_err("OPEN p_zs_bcl:",STATUS,1)
            CLOSE p_zs_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH p_zs_cl INTO g_zta.*
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_zta.zta01,SQLCA.sqlcode,0)
            CLOSE p_zs_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
 
            LET g_zs_t.* = g_zs[l_ac].*  #BACKUP
            OPEN p_zs_bcl USING g_zta.zta01,g_zta.zta02,g_zs_t.zs03  #表示更改狀態
            IF STATUS THEN
               CALL cl_err("OPEN p_zs_bcl:",STATUS,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_zs_bcl INTO g_zs[l_ac].*
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_zs_t.zs03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
               END IF
            END IF
         END IF
         IF g_zs[l_ac].zs10='Y' THEN
            NEXT FIELD zs12
         END IF
 
 
     BEFORE INSERT
        LET l_n = ARR_COUNT()
        LET p_cmd='a'
     INITIALIZE g_zs[l_ac].* TO NULL      #900423
#  #     LET g_zs[l_ac].xxxxx = 'Y'       #Body default
        LET g_zs[l_ac].zs04  = g_today   #Body default
        LET g_zs[l_ac].zs05  = 'p'       #Body default
        LET g_zs[l_ac].zs07  = g_user    #Body default
        LET g_zs[l_ac].zs09  = 'Y'    #Body default
        LET g_zs[l_ac].zs10  = 'Y'    #Body default
        LET g_zs[l_ac].zs11  = 'Y'    #Body default
   #     LET g_zs[l_ac].zs08  = g_MODNO   #Body default
        LET g_zs_t.* = g_zs[l_ac].*         #新輸入資料
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
# 用cancel insert來替代以下statement
            CANCEL INSERT
#            CALL g_zs.deleteElement(l_ac)
#            IF g_rec_b != 0 THEN
#               LET g_action_choice = "detail"
#               LET l_ac = l_ac_t
#            END IF
#            EXIT INPUT
         END IF
 
        INSERT INTO zs_file(zs01,zs02,zs03,zs04,zs05,zs06,
                            zs07,zs08,zs09,zs10,zs11,zs12)
                     VALUES(g_zta.zta01,g_zta.zta02,g_zs[l_ac].zs03,
                            g_zs[l_ac].zs04,g_zs[l_ac].zs05,g_zs[l_ac].zs06,
                            g_zs[l_ac].zs07,g_zs[l_ac].zs08,g_zs[l_ac].zs09,
                            g_zs[l_ac].zs10,g_zs[l_ac].zs11,g_zs[l_ac].zs12)
        IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zs[l_ac].zs03,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","zs_file",g_zta.zta01,g_zs[l_ac].zs03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
--CKP, 新增至資料庫發生錯誤時, CANCEL INSERT, 不需要讓舊值回復到原變數
            CANCEL INSERT
#            LET g_zs[l_ac].* = g_zs_t.*
        ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
        END IF
 
     BEFORE FIELD zs03                        #default 序號
        IF g_zs[l_ac].zs03 IS NULL OR
           g_zs[l_ac].zs03 = 0 THEN
            SELECT max(zs03)+1
               INTO g_zs[l_ac].zs03
               FROM zs_file
               WHERE zs01 = g_zta.zta01
                 AND zs02 = g_zta.zta02
            IF g_zs[l_ac].zs03 IS NULL THEN
                LET g_zs[l_ac].zs03 = 1
            END IF
        END IF
 
     AFTER FIELD zs03                        #check 序號是否重複
        IF g_zs[l_ac].zs03 IS NULL THEN
           LET g_zs[l_ac].zs03 = g_zs_t.zs03
           NEXT FIELD zs03
        END IF
        IF g_zs[l_ac].zs03 != g_zs_t.zs03 OR
           g_zs_t.zs03 IS NULL THEN
           SELECT count(*) INTO l_n
             FROM zs_file
            WHERE zs01 = g_zta.zta01
              AND zs02 = g_zta.zta02
              AND zs03 = g_zs[l_ac].zs03
           IF l_n > 0 THEN
              CALL cl_err('',-239,0)
              LET g_zs[l_ac].zs03 = g_zs_t.zs03
              NEXT FIELD zs03
           END IF
        END IF
 
     AFTER FIELD zs07
        IF NOT cl_null(g_zs[l_ac].zs07) THEN
           SELECT count(*) INTO l_cnt FROM zx_file
            WHERE zx01 = g_zs[l_ac].zs07
           IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
           IF l_cnt = 0 THEN
              CALL cl_err(g_zs[l_ac].zs07,'mfg9329',1)
              NEXT FIELD zs07
           END IF
        END IF
 
#     AFTER FIELD zs08
#        IF NOT cl_null(g_zs[l_ac].zs08) THEN
#           SELECT count(*) INTO l_cnt FROM zl_file
#                           WHERE zl08 = g_zs[l_ac].zs08
#           IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
#           IF l_cnt = 0 THEN
#              CALL cl_err(g_zs[l_ac].zs08,'mfg9329',1)
#              NEXT FIELD zs08
#           END IF
#        END IF
 
     BEFORE DELETE                            #是否取消單身
        IF g_zs_t.zs03 > 0 AND g_zs_t.zs03 IS NOT NULL THEN
           IF NOT cl_delb(0,0) THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           DELETE FROM zs_file
            WHERE zs01 = g_zta.zta01
              AND zs02 = g_zta.zta02
              AND zs03 = g_zs_t.zs03
           IF SQLCA.sqlcode THEN
              #CALL cl_err(g_zs_t.zs03,SQLCA.sqlcode,0)  #No.FUN-660081
              CALL cl_err3("del","zs_file",g_zta.zta01,g_zs_t.zs03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
              ROLLBACK WORK
              CANCEL DELETE
           END IF
           LET g_rec_b=g_rec_b-1
           DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
           CLOSE p_zs_bcl
           COMMIT WORK
        END IF
 
#     AFTER DELETE
#        CALL p_zs_bu(1,0,l_ac)
#        LET l_n = ARR_COUNT()
#        INITIALIZE g_zs[l_n+1].* TO NULL
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zs[l_ac].* = g_zs_t.*
            CLOSE p_zs_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zs[l_ac].zs03,-263,1)
            LET g_zs[l_ac].* = g_zs_t.*
         ELSE
            UPDATE zs_file SET zs03=g_zs[l_ac].zs03,
                               zs04=g_zs[l_ac].zs04,zs05=g_zs[l_ac].zs05,
                               zs06=g_zs[l_ac].zs06,zs07=g_zs[l_ac].zs07,
                               zs08=g_zs[l_ac].zs08,zs09=g_zs[l_ac].zs09,
                               zs10=g_zs[l_ac].zs10,zs11=g_zs[l_ac].zs11,
                               zs12=g_zs[l_ac].zs12
             WHERE CURRENT OF p_zs_bcl
            IF SQLCA.SQLERRD[3]=0 THEN
               #CALL cl_err(g_zs[l_ac].zs03,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","zs_file",g_zta.zta01,g_zs_t.zs03,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               LET g_zs[l_ac].* = g_zs_t.*
            ELSE
               MESSAGE "UPDATE OK!!"
               COMMIT WORK
            END IF
{            UPDATE zs_file SET zs10=g_zs[l_ac].zs10,
                               zs11='Y'
             WHERE CURRENT OF p_zs_bcl
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err(g_zs[l_ac].zs03,SQLCA.sqlcode,0)
               ROLLBACK WORK
               LET g_zs[l_ac].* = g_zs_t.*
            ELSE
         #     DECLARE p_zs_a CURSOR FOR
         #        SELECT * FROM zta_file
         #        WHERE zta01=g_zta.zta01
         #          AND zta02=g_zta.zta02
         #     DECLARE p_zs_b CURSOR FOR
         #        SELECT * FROM ztb_file
         #        WHERE ztb01=g_zta.zta01
         #          AND ztb02=g_zta.zta02
         #     DECLARE p_zs_c CURSOR FOR
         #        SELECT * FROM ztc_file
         #        WHERE ztc01=g_zta.zta01
         #          AND ztc02=g_zta.zta02
               IF g_db_type="IFX" THEN
                  LET g_sql="UPDATE ds@on_tcp5.zs_file SET zs10='",
                             g_zs[l_ac].zs10 CLIPPED,"',zs11='Y'"
               ELSE
                  LET g_sql="UPDATE zs_file@to_std SET zs10='",
                             g_zs[l_ac].zs10 CLIPPED,"',zs11='Y'"
               END IF
               EXECUTE IMMEDIATE g_sql
               IF SQLCA.SQLERRD[3]=0 THEN
                  #CALL cl_err(g_zs[l_ac].zs03,SQLCA.sqlcode,0)  #No.FUN-660081
                  CALL cl_err3("upd","zs_file",g_zs[l_ac].zs10,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
                  ROLLBACK WORK
                  LET g_zs[l_ac].* = g_zs_t.*
               ELSE
                  IF g_db_type = "IFX" THEN
                     LET g_sql=" INSERT INTO ds@on_tcp5.zta_file",
                               " SELECT * FROM zta_file ",
                               "  WHERE zta01='",g_zta.zta01 CLIPPED,"','",
                               "    AND zta02='",g_zta.zta02 CLIPPED,"'"
                  ELSE
                     LET g_sql=" INSERT INTO zta_file@to_std ",
                               " SELECT * FROM zta_file ",
                               "  WHERE zta01='",g_zta.zta01 CLIPPED,"','",
                               "    AND zta02='",g_zta.zta02 CLIPPED,"'"
                  END IF
                  EXECUTE IMMEDIATE g_sql
                  #IF SQLCA.SQLCODE<>0 AND SQLCA.SQLCODE<>-239 THEN                  #TQC-790092
                  IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790092
                     #CALL cl_err(g_zs[l_ac].zs03,SQLCA.sqlcode,0)  #No.FUN-660081
                     CALL cl_err3("upd","zs_file",g_zs[l_ac].zs10,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
                     ROLLBACK WORK
                     LET g_zs[l_ac].* = g_zs_t.*
                  ELSE
                     IF g_db_type = "IFX" THEN
                        LET g_sql=" INSERT INTO ds@on_tcp5.ztb_file",
                                  " SELECT * FROM ztb_file ",
                                  "  WHERE ztb01='",g_zta.zta01 CLIPPED,"','",
                                  "    AND ztb10='",g_zta.zta02 CLIPPED,"'"
                     ELSE
                        LET g_sql=" INSERT INTO ztb_file@to_std ",
                                  " SELECT * FROM ztb_file ",
                                  "  WHERE ztb01='",g_zta.zta01 CLIPPED,"','",
                                  "    AND ztb10='",g_zta.zta02 CLIPPED,"'"
                     END IF
                     EXECUTE IMMEDIATE g_sql
                     #IF SQLCA.SQLCODE<>0 AND SQLCA.SQLCODE<>-239 THEN                  #TQC-790092
                     IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790092
                        #CALL cl_err(g_zs[l_ac].zs03,SQLCA.sqlcode,0)  #No.FUN-660081
                        CALL cl_err3("ins","ztb_file",g_zta.zta01,g_zta.zta02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                        ROLLBACK WORK
                        LET g_zs[l_ac].* = g_zs_t.*
                     ELSE
                        IF g_db_type = "IFX" THEN
                           LET g_sql=" INSERT INTO ds@on_tcp5.ztc_file",
                                     " SELECT * FROM ztc_file ",
                                     "  WHERE ztc01='",g_zta.zta01 CLIPPED,"','",
                                     "    AND ztc10='",g_zta.zta02 CLIPPED,"'"
                        ELSE
                           LET g_sql=" INSERT INTO ztc_file@to_std ",
                                     " SELECT * FROM ztc_file ",
                                     "  WHERE ztc01='",g_zta.zta01 CLIPPED,"','",
                                     "    AND ztc10='",g_zta.zta02 CLIPPED,"'"
                        END IF
                        EXECUTE IMMEDIATE g_sql
                        #IF SQLCA.SQLCODE<>0 AND SQLCA.SQLCODE<>-239 THEN                  #TQC-790092
                        IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790092
                           #CALL cl_err(g_zs[l_ac].zs03,SQLCA.sqlcode,0)  #No.FUN-660081
                           CALL cl_err3("ins","ztc_file",g_zta.zta01,g_zta.zta02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                           ROLLBACK WORK
                           LET g_zs[l_ac].* = g_zs_t.*
                        ELSE
                           SELECT zta03,zta07 INTO l_zta03,l_zta07
                             FROM zta_file
                            WHERE zta01=g_zta.zta01
                              AND zta02=g_zta.zta02
                           IF l_zta07='T' THEN
                              CASE
                                 WHEN g_zs[l_ac].zs06[1,12]='create table'
                                    LET l_zta03=UPSHIFT(l_zta03)
                                    LET l_cmd='dbaccess ds@on_tcp5 $',
                                              l_zta03 CLIPPED,'/sql/c_',
                                              g_zta.zta01[1,3] CLIPPED,'.sql',
                                              ' 2> $TEMPDIR/error.out'
                                    RUN l_cmd RETURNING g_status
                                    IF g_status != 0 THEN
                                       CALL fgl_getenv('TEMPDIR') RETURNING l_top
                                       LET l_str=l_top CLIPPED,'/error.out'
                                       LET ch=base.channel.create()
                                       CALL ch.openfile( l_str, "r" )
                                       LET l_i=1
                                       WHILE ch.read(l_err[l_i])
                                         LET l_i=l_i+1
                                       END WHILE
                                       CALL ch.close()
                                       FOR l_i=2 TO 20
                                           LET l_err[1]=l_err[1] CLIPPED,l_err[l_i] CLIPPED
                                       END FOR
                                       CALL fgl_winmessage("Error Info", l_err[1] CLIPPED, "error info")
                                       ROLLBACK WORK
                                       LET g_zs[l_ac].zs10 = 'N'
                                    ELSE
                                       MESSAGE 'UPDATE O.K'
                                       LET g_zs[l_ac].zs11 = 'Y'
                                       COMMIT WORK
                                    END IF
                                WHEN g_zs[l_ac].zs06[1,11]='alter table'
                                    LET l_cmd="echo '",g_zs[l_ac].zs06 CLIPPED,
                                              "'|dbaccess ds@on_tcp5 ",
                                              ' 2> $TEMPDIR/error.out'
                                    RUN l_cmd RETURNING g_status
                                    IF g_status != 0 THEN
                                       CALL fgl_getenv('TEMPDIR') RETURNING l_top
                                       LET l_str=l_top CLIPPED,'/error.out'
                                       LET ch=base.channel.create()
                                       CALL ch.openfile(l_str, "r" )
                                       LET l_i=1
                                       WHILE ch.read(l_err[l_i])
                                          LET l_i=l_i+1
                                       END WHILE
                                       CALL ch.close()
                                       FOR l_i=2 TO 20
                                           LET l_err[1]=l_err[1] CLIPPED,l_err[l_i] CLIPPED
                                       END FOR
                                       CALL fgl_winmessage("Error Info", l_err[1] CLIPPED, "error info")
                                       ROLLBACK WORK
                                       LET g_zs[l_ac].zs10 = 'N'
                                    ELSE
                                       MESSAGE 'UPDATE O.K'
                                       LET g_zs[l_ac].zs11 = 'Y'
                                       COMMIT WORK
                                    END IF
                                 WHEN g_zs[l_ac].zs06[1,10]='drop table'
                                 OTHERWISE
                                    LET l_cmd="echo '",g_zs[l_ac].zs06 CLIPPED,
                                              "'|dbaccess ds@on_tcp5 ",
                                              ' 2> $TEMPDIR/error.out'
                                    RUN l_cmd RETURNING g_status
                                    IF g_status != 0 THEN
                                       CALL fgl_getenv('TEMPDIR') RETURNING l_top
                                       LET l_str=l_top CLIPPED,'/error.out'
                                       LET ch=base.channel.create()
                                       CALL ch.openfile(l_str, "r" )
                                       LET l_i=1
                                       WHILE ch.read(l_err[l_i])
                                          LET l_i=l_i+1
                                       END WHILE
                                       CALL ch.close()
                                       FOR l_i=2 TO 20
                                           LET l_err[1]=l_err[1] CLIPPED,l_err[l_i] CLIPPED
                                       END FOR
                                       CALL fgl_winmessage("Error Info", l_err[1] CLIPPED, "error info")
                                       ROLLBACK WORK
                                       LET g_zs[l_ac].zs10 = 'N'
                                    ELSE
                                       MESSAGE 'UPDATE O.K'
                                       LET g_zs[l_ac].zs11 = 'Y'
                                       COMMIT WORK
                                    END IF
                              END CASE
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
            END IF}
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zs[l_ac].* = g_zs_t.*
            END IF
            CLOSE p_zs_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
#         LET g_zs_t.* = g_zs[l_ac].*
         CLOSE p_zs_bcl
         COMMIT WORK
 
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(zs07)
#              CALL q_zx(g_zs[l_ac].zs07) RETURNING g_zs[l_ac].zs07
#              NEXT FIELD zs07
#           WHEN INFIELD(zs08)
#              CALL q_zl(0,0,g_zs[l_ac].zs08) RETURNING g_zs[l_ac].zs08
#              NEXT FIELD zs08
#           OTHERWISE EXIT CASE
#        END  CASE
 
 
      ON ACTION CONTROLN
         CALL p_zs_b_askkey()
         EXIT INPUT
 
#     ON ACTION CONTROLO                        #沿用所有欄位
#        IF INFIELD(zs03) AND l_ac > 1 THEN
#           LET g_zs[l_ac].* = g_zs[l_ac-1].*
#           LET g_zs[l_ac].zs03 = NULL
#           NEXT FIELD zs03
#        END IF
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
#     ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
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
 
   CLOSE p_zs_bcl
   CLOSE p_zs_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_zs_b_askkey()
   #DEFINE   l_wc2   LIKE type_file.chr1000  #TQC-630166 #No.FUN-680135 VARCHAR(1000)
    DEFINE   l_wc2   STRING                  #TQC-630166
 
CONSTRUCT l_wc2 ON zs03,zs04,zs05,zs06,zs07,zs08,zs09,zs10,zs11,zs12
      FROM s_zs[1].zs03,s_zs[1].zs04,s_zs[1].zs05,s_zs[1].zs06,s_zs[1].zs07,
           s_zs[1].zs08,s_zs[1].zs09,s_zs[1].zs10,s_zs[1].zs11,s_zs[1].zs12
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
   CALL p_zs_b_fill(l_wc2)
END FUNCTION
 
FUNCTION p_zs_b_fill(p_wc2)                 #BODY FILL UP
   #DEFINE   p_wc2   LIKE type_file.chr1000 #TQC-630166   #No.FUN-680135 VARCHAR(1000)
    DEFINE   p_wc2   STRING                 #TQC-630166
 
   LET g_sql =
       "SELECT zs03,zs04,zs05,zs06,zs07,zs08,zs12,zs09,zs10,zs11 ",
       " FROM zs_file ",
       " WHERE zs01 ='",g_zta.zta01,"' AND zs02='",g_zta.zta02,"' AND ",  #單頭
       p_wc2 CLIPPED,                     #單身
       " ORDER BY 1"
   PREPARE p_zs_pb FROM g_sql
   DECLARE zs_curs                       #SCROLL CURSOR
       CURSOR FOR p_zs_pb
 
   CALL g_zs.clear()
 
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH zs_curs INTO g_zs[g_cnt].*   #單身 ARRAY 填充
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
   LET g_rec_b=g_cnt-1
   CALL g_zs.deleteElement(g_cnt)
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p_zs_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ""
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_zs TO s_zs.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
#     ON ACTION insert
#        LET g_action_choice = "insert"
#        EXIT DISPLAY
      ON ACTION query
         LET g_action_choice = "query"
         EXIT DISPLAY
#     ON ACTION delete
#        LET g_action_choice = "delete"
#        EXIT DISPLAY
#     ON ACTION modify
#        LET g_action_choice = "modify"
#        EXIT DISPLAY
#      ON ACTION detail
#         LET g_action_choice = "detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice = "output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice = "help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice = "detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice = "controlg"
         EXIT DISPLAY
      ON ACTION first
         CALL p_zs_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
      ON ACTION previous
         CALL p_zs_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
      ON ACTION jump
         CALL p_zs_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
      ON ACTION next
         CALL p_zs_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
      ON ACTION last
         CALL p_zs_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
 
FUNCTION p_zs_bp_refresh()
   DISPLAY ARRAY g_zs TO s_zs.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION p_zs_out1()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680135 SMALLINT
    sr              RECORD
        zta01       LIKE zta_file.zta01,   #檔案編號
        zta02       LIKE zta_file.zta02,   #檔案編號
        gat03       LIKE gat_file.gat03,   #檔案名稱
#       zta02       LIKE zta_file.zta02,   #檔案名稱
#       zta02e      LIKE zta_file.zta02e,  #英文名稱
#       zta02c      LIKE zta_file.zta02c,  #簡體中文
--      zta04       LIKE zta_file.zta04,   #使 用 別
        zta05       LIKE zta_file.zta05,   #產生日期
        zta06       LIKE zta_file.zta06,   #產 生 者
        zs03        LIKE zs_file.zs03,     #序號
        zs04        LIKE zs_file.zs04,     #修正日期
        zs06        LIKE zs_file.zs06,     #修正指令及說明
        zs07        LIKE zs_file.zs07,     #修正人
        zs08        LIKE zs_file.zs08      #工作單號
                    END RECORD,
    l_name          LIKE type_file.chr20   #External(Disk) file name #No.FUN-680135 VARCHAR(20)
#   l_zaa08         VARCHAR(60)
 
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('p_zs') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    DECLARE p_zs_zaa_cur CURSOR FOR
#            SELECT zaa02,zaa08 FROM zaa_file
#             WHERE zaa01 = "p_zs" AND zaa03 = g_lang
#    FOREACH p_zs_zaa_cur INTO g_i,l_zaa08
#       LET g_x[g_i] = l_zaa08
#    END FOREACH
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'p_zs'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    LET g_sql="SELECT zta01,zta02,zta02,zta02e,zta02c,zta05,zta06,",
    IF g_db_type = "IFX" THEN
       LET g_sql="SELECT zta01,zta02,gat03,zta05,zta06,",
                 "       zs03,zs04,zs06,zs07,zs08",
                 "  FROM zta_file,zs_file,OUTER gat_file",
                 " WHERE zta01 = zs01 ",
                 "   AND zta02 = zs02 ",
                 "   AND zta01 = gat01 ",
                 "   AND gat02 = '",g_lang CLIPPED,"'",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
    ELSE
       LET g_sql="SELECT zta01,zta02,gat03,zta05,zta06,",
                 "       zs03,zs04,zs06,zs07,zs08",
                 #No.TQC-9B0015  --Begin
                 "  FROM zs_file,zta_file LEFT OUTER JOIN gat_file",
                 "                        ON  zta01 = gat01 ",
                 " WHERE zta01 = zs01 ",
                 "   AND zta02 = zs02 ",
                 "   AND gat02 = '",g_lang CLIPPED,"'",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
                 #No.TQC-9B0015  --End  
    END IF
    PREPARE p_zs_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_zs_co                         # SCROLL CURSOR
         CURSOR FOR p_zs_p1
 
    START REPORT p_zs_rep1 TO l_name
 
    FOREACH p_zs_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT p_zs_rep1(sr.*)
 
    END FOREACH
 
    FINISH REPORT p_zs_rep1
 
    CLOSE p_zs_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_zs_rep1(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
    l_sw1           LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
    l_sw            LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
    l_i             LIKE type_file.num5,    #No.FUN-680135 SMALLINT
    sr              RECORD
        zta01       LIKE zta_file.zta01,    #檔案編號
        zta02       LIKE zta_file.zta02,    #資料庫
        gat03       LIKE gat_file.gat03,    #檔案名稱
#       zta02       LIKE zta_file.zta02,    #檔案名稱
#       zta02e      LIKE zta_file.zta02e,   #英文名稱
#       zta02c      LIKE zta_file.zta02c,   #簡體中文
--      zta04       LIKE zta_file.zta04,    #使 用 別
        zta05       LIKE zta_file.zta05,    #產生日期
        zta06       LIKE zta_file.zta06,    #產 生 者
        zs03        LIKE zs_file.zs03,      #序號
        zs04        LIKE zs_file.zs04,      #修正日期
        zs06        LIKE zs_file.zs06,      #修正指令及說明
        zs07        LIKE zs_file.zs07,      #修正人
        zs08        LIKE zs_file.zs08       #工作單號
                    END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.zta01,sr.zta02,sr.zs03
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today USING 'yy/mm/dd',' ',TIME,
                COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
            LET l_sw = 'y'
            LET l_sw1 = 'y'
 
        BEFORE GROUP OF sr.zta01  #檔案名稱
            IF l_sw = 'n'
               THEN LET l_sw = 'y'
            END IF
            IF l_sw1 != 'y'
               THEN SKIP 1 LINE
                    PRINT '----------------------------------------',
                          '----------------------------------------'
            END IF
            PRINT g_x[11],
                  COLUMN 15,g_x[16],
                  COLUMN 53,g_x[12],
                  COLUMN 63,g_x[17]
            PRINT '------------  ----------------------------',
                  '--------  --------  ----------'
#            CASE
#              WHEN g_lang = '1'
#                   LET sr.zta02=sr.zta02e
#                   LET sr.zta02e=''
#              WHEN g_lang = '2'
#                   LET sr.zta02=sr.zta02c
#                   LET sr.zta02e=''
#            END CASE
            PRINT COLUMN 1,sr.zta01 CLIPPED,
                  COLUMN 15,sr.gat03 CLIPPED,
#                  COLUMN 13,sr.zta02 CLIPPED,
                  COLUMN 53,sr.zta05 CLIPPED,
                  COLUMN 63,sr.zta06 CLIPPED
--                  COLUMN 72,sr.zta04 CLIPPED
#            IF sr.zta02 IS NOT NULL THEN
#               PRINT COLUMN 13,sr.zta02e
#            END IF
 
        AFTER GROUP OF sr.zta01
            LET l_sw1 = 'n'
 
        ON EVERY ROW
           IF sr.zs03 IS NOT NULL AND sr.zs03 != 0  THEN
              IF l_sw = 'y' THEN
                 SKIP 1 LINE
                 PRINT COLUMN 6,g_x[13],
                       COLUMN 12,g_x[18],
                       COLUMN 22,g_x[19],
                       COLUMN 89,g_x[14],
                       COLUMN 97,g_x[15]
                 PRINT '     ----  --------  ----------------------',
                       '-------------------------------------------  ------  ----------'
                 LET l_sw = 'n'
              END IF
           END IF
           PRINT COLUMN 04,sr.zs03 CLIPPED,
                 COLUMN 12,sr.zs04 CLIPPED,
                 COLUMN 22,sr.zs06 CLIPPED,
                 COLUMN 89,sr.zs07[1,6] CLIPPED,
                 COLUMN 97,sr.zs08 CLIPPED
 
        ON LAST ROW
            IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc,'zta01,gat03') RETURNING g_sql
               #TQC-630166
               #IF g_sql[001,080] > ' ' THEN
	       #	       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
               #IF g_sql[071,140] > ' ' THEN
	       #	       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
               #IF g_sql[141,210] > ' ' THEN
	       #	       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
               PRINT g_dash[1,g_len]
               CALL cl_prt_pos_wc(g_sql)
               #END TQC-630166
            END IF
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
FUNCTION p_zs_out2()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680135 SMALLINT
    sr              RECORD
        zta01       LIKE zta_file.zta01,   #檔案編號
        zs03        LIKE zs_file.zs03,     # Seq
        zs04        LIKE zs_file.zs04,     #修正日期
        zs06        LIKE zs_file.zs06,     #修正指令及說明
        zs07        LIKE zs_file.zs07,     #修正人
        zs08        LIKE zs_file.zs08      #工作單號
                    END RECORD,
    l_name          LIKE type_file.chr20   #External(Disk) file name #No.FUN-680135 VARCHAR(20)
 
    IF g_wc IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_wait()
    LET l_name = 'alter_ds.sql'
#   CALL cl_outnam('p_zs') RETURNING l_name
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    LET g_sql="SELECT zta01,zs03,zs04,zs06,zs07,zs08",
          " FROM zta_file,zs_file",
          " WHERE zta01 = zs01 AND ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED
    PREPARE p_zs_p2 FROM g_sql                # RUNTIME 編譯
    DECLARE p_zs_co2 CURSOR FOR p_zs_p2        # CURSOR
 
    START REPORT p_zs_rep2 TO l_name
    FOREACH p_zs_co2 INTO sr.*
        OUTPUT TO REPORT p_zs_rep2(sr.*)
    END FOREACH
    FINISH REPORT p_zs_rep2
 
    CLOSE p_zs_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_zs_rep2(sr)
DEFINE
    sr              RECORD
        zta01       LIKE zta_file.zta01,   #檔案編號
        zs03       LIKE zs_file.zs03,   # Seq
        zs04       LIKE zs_file.zs04,   #修正日期
        zs06       LIKE zs_file.zs06,   #修正指令及說明
        zs07       LIKE zs_file.zs07,   #修正人
        zs08       LIKE zs_file.zs08    #工作單號
                    END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin   #FUN-580098
       PAGE LENGTH g_page_line
 
    ORDER BY sr.zta01,sr.zs04,sr.zs03
 
    FORMAT
        ON EVERY ROW
            PRINT 'alter table ',
                  COLUMN 13,sr.zta01,
                  COLUMN 53, '{',sr.zs04,' By ',sr.zs07 CLIPPED,'}'
            PRINT COLUMN 06,sr.zs06 CLIPPED,';'
            PRINT ''
END REPORT
#Patch....NO.TQC-610037 <001> #
