# Prog. Version..: '5.30.06-13.04.22(00004)'     #
# PROG. VERSION..: '5.25.03-11.07.14(00000)'     #
#
# PATTERN NAME...: sagli920.4gl
# DESCRIPTIONS...: 現金流量表揭露事項維護作業
# DATE & AUTHOR..: #FUN-B80180 11/08/29 BY zhangweib
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植
# Modify.........: NO.MOD-C40131 12/04/18 By Elise sagli920 使用 atm_file 與畫面檔無法對應,還原回 gim_file
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"  #FUN-BB0037

#MOD-C40131------S------
#DEFINE
#  g_atm            DYNAMIC ARRAY OF RECORD   #程式變數(program variables)   #FUN-B80180
#     atm00         LIKE atm_file.atm00,
#     atm01         LIKE atm_file.atm01,
#     atm02         LIKE atm_file.atm02,
#     atm03         LIKE atm_file.atm03
#                   END RECORD,
#  g_atm_t          RECORD                   #程式變數 (舊值)
#      atm00        LIKE atm_file.atm00,
#      atm01        LIKE atm_file.atm01,
#      atm02        LIKE atm_file.atm02,
#      atm03        LIKE atm_file.atm03
#                   END RECORD,
#  g_atm00          LIKE atm_file.atm00,
#  g_wc2,g_wc       STRING,
#  g_sql            STRING,
#  g_rec_b          LIKE type_file.num5,     #單身筆數
#  l_ac             LIKE type_file.num5      #目前處理的array cnt
#DEFINE g_atm04      LIKE atm_file.atm04
#DEFINE g_atm05      LIKE atm_file.atm05
#DEFINE g_atm06      LIKE atm_file.atm06
#DEFINE g_atm04_t    LIKE atm_file.atm04
#DEFINE g_atm05_t    LIKE atm_file.atm05
#DEFINE g_atm06_t    LIKE atm_file.atm06
#DEFINE g_forupd_sql STRING
#DEFINE g_msg        LIKE ze_file.ze03
#DEFINE g_cnt        LIKE type_file.num10
#DEFINE g_i          LIKE type_file.num5      #count/index for any purpose
#DEFINE l_cmd        LIKE type_file.chr1000
#DEFINE g_curs_index LIKE type_file.num10
#DEFINE g_row_count  LIKE type_file.num10
#DEFINE g_jump       LIKE type_file.num10
#DEFINE g_no_ask     LIKE type_file.num5
#DEFINE g_before_input_done  LIKE type_file.num5
#DEFINE l_tmp        LIKE type_file.num5
#DEFINE l_aza02      LIKE aza_file.aza02

#FUNCTION i920(p_atm00)
#DEFINE p_atm00 LIKE type_file.chr1

#  WHENEVER ERROR CALL cl_err_msg_log

#  LET g_forupd_sql = " SELECT * FROM atm_file ",
#                     " WHERE atm00 = ? AND atm04 = ? ",
#                     "   AND atm05 = ? AND atm06 = ? FOR UPDATE "
#  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#  DECLARE i920_cl CURSOR FROM g_forupd_sql
#  LET g_atm00= p_atm00
#  CALL cl_set_comp_visible("atm00",FALSE)

#  SELECT aza02 INTO l_aza02 FROM aza_file
#  IF l_aza02 = '1' THEN LET l_tmp = 12 ELSE LET l_tmp = 13 END IF
#  IF g_atm00 = 'N' THEN 
#     LET g_atm06 = ' '
#     CALL cl_set_comp_visible("atm06",FALSE)
#  END IF

#  CALL i920_menu()
#END FUNCTION

#FUNCTION i920_cs()

#  CLEAR FORM
#  CALL g_atm.clear()
#  
#  IF g_atm00 = 'Y' THEN
#     CONSTRUCT g_wc ON atm04,atm05,atm06,atm01,atm02,atm03
#          FROM atm04,atm05,atm06,s_atm[1].atm01,s_atm[1].atm02,s_atm[1].atm03
#     
#        BEFORE CONSTRUCT
#          CALL cl_qbe_init()

#        ON ACTION controlp
#           CASE
#              WHEN INFIELD(atm06)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_asa6"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO atm06
#                 NEXT FIELD atm0im066

#              OTHERWISE
#                 EXIT CASE
#           END CASE

#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT

#        ON ACTION about
#           CALL cl_about()

#        ON ACTION HELP
#           CALL cl_show_help()

#        ON ACTION controlg
#           CALL cl_cmdask()

#        ON ACTION qbe_select
#           CALL cl_qbe_select()

#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#     END CONSTRUCT
#  ELSE
#     CONSTRUCT g_wc ON atm04,atm05,atm01,atm02,atm03
#          FROM atm04,atm05,s_atm[1].atm01,s_atm[1].atm02,s_atm[1].atm03

#        BEFORE CONSTRUCT
#          CALL cl_qbe_init()

#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE CONSTRUCT

#        ON ACTION about
#           CALL cl_about()

#        ON ACTION HELP
#           CALL cl_show_help()

#        ON ACTION controlg
#           CALL cl_cmdask()

#        ON ACTION qbe_select
#           CALL cl_qbe_select()

#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#     END CONSTRUCT
#  END IF
#  LET g_wc = g_wc CLIPPED,cl_get_extra_cond(NULL, NULL)

#  IF INT_FLAG THEN
#     LET INT_FLAG = 0
#     LET g_wc = NULL
#     RETURN
#  END IF

#     LET g_sql = "SELECT DISTINCT atm04,atm05,atm06 ",
#                 "  FROM atm_file ",
#                 " WHERE ",g_wc CLIPPED,
#                 "   AND atm00 = '",g_atm00,"'",
#                 " ORDER BY atm04"

#  PREPARE i920_prepare FROM g_sql
#  DECLARE i920_cs                         #scroll cursor
#      SCROLL CURSOR WITH HOLD FOR i920_prepare

#END FUNCTION

#FUNCTION i920_menu()

#  WHILE TRUE
#     CALL i920_bp("g")
#     CASE g_action_choice
#        WHEN "query"
#           IF cl_chk_act_auth() THEN
#              CALL i920_q()
#           END IF
#        WHEN "insert"                          # a.輸入
#           IF cl_chk_act_auth() THEN
#              CALL i920_a()
#           END IF
#        WHEN "modify"                          # u.更新
#           IF cl_chk_act_auth() THEN
#              CALL i920_u()
#           END IF
#        WHEN "reproduce"                       # C.複製
#           IF cl_chk_act_auth() THEN
#              CALL i920_copy()
#           END IF
#        WHEN "detail"
#           IF cl_chk_act_auth() THEN
#              CALL i920_b()
#           ELSE
#              LET g_action_choice = NULL
#           END IF
#        WHEN "delete"                          # r.取消
#           IF cl_chk_act_auth() THEN
#              CALL i920_r()
#           END IF
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
#              LET l_cmd = 'p_query "ggli504" "',g_wc2 CLIPPED,'"'
#              CALL cl_cmdrun(l_cmd)
#           END IF
#        WHEN "help"
#           CALL cl_show_help()
#        WHEN "exit"
#           EXIT WHILE
#        WHEN "controlg"
#           CALL cl_cmdask()
#         WHEN "related_document"
#           IF cl_chk_act_auth() AND l_ac != 0 THEN
#              IF g_atm[l_ac].atm01 IS NOT NULL THEN
#                 LET g_doc.column1 = "atm00"
#                 LET g_doc.value1 = g_atm[l_ac].atm00
#                 LET g_doc.column2 = "atm01"
#                 LET g_doc.value2 = g_atm[l_ac].atm01
#                 CALL cl_doc()
#              END IF
#           END IF
#        WHEN "exporttoexcel"
#           IF cl_chk_act_auth() THEN
#             CALL cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_atm),'','')
#           END IF
#     END CASE
#  END WHILE

#END FUNCTION

#FUNCTION i920_a()
#  MESSAGE ""
#  CLEAR FORM
#  CALL g_atm.clear()
#  LET g_atm04 = NULL
#  LET g_atm05 = NULL
#  LET g_atm06 = NULL

#  WHILE TRUE
#     CALL i920_i("a")                       # 輸入單頭

#     IF INT_FLAG THEN                            # 使用者不玩了
#        LET g_atm04 = NULL
#        LET g_atm05 = NULL
#        LET g_atm06 = NULL
#        LET INT_FLAG = 0
#        CALL cl_err('',9001,0)
#        EXIT WHILE
#     END IF
#     LET g_rec_b = 0

#     CALL i920_b()                          # 輸入單身
#     LET g_atm04_t = g_atm04
#     LET g_atm05_t = g_atm05
#     LET g_atm06_t = g_atm06
#     EXIT WHILE
#  END WHILE
#END FUNCTION

#FUNCTION i920_i(p_cmd)
#  DEFINE p_cmd        LIKE type_file.chr1
#  DEFINE l_count      LIKE type_file.num5
#  INPUT g_atm04,g_atm05,g_atm06 
#     WITHOUT DEFAULTS FROM atm04,atm05,atm06

#     AFTER FIELD atm04
#        IF NOT cl_null(g_atm04) AND NOT cl_null(g_atm05) AND NOT cl_null(g_atm06) THEN
#           IF (g_atm04_t IS NULL OR (g_atm04 != g_atm04_t)) OR
#              (g_atm05_t IS NULL OR (g_atm05 != g_atm05_t)) OR
#              (g_atm06_t IS NULL OR (g_atm06 != g_atm06_t)) THEN
#              CALL i920_chk()
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err('',g_errno,1)
#                 LET g_atm04 = g_atm04_t
#                 LET g_errno = ' '
#                 NEXT FIELD atm04
#              END IF
#           END IF
#        END IF

#     AFTER FIELD atm05
#        IF NOT cl_null(g_atm05) THEN
#           IF g_atm05 < 1 OR g_atm05 > l_tmp  THEN
#              CALL cl_err('','agl-020',1)
#              NEXT FIELD atm05
#           END IF
#           IF NOT cl_null(g_atm04) AND NOT cl_null(g_atm05) AND NOT cl_null(g_atm06) THEN
#              IF (g_atm04_t IS NULL OR (g_atm04 != g_atm04_t)) OR 
#                 (g_atm05_t IS NULL OR (g_atm05 != g_atm05_t)) OR 
#                 (g_atm06_t IS NULL OR (g_atm06 != g_atm06_t)) THEN
#                 CALL i920_chk()
#                 IF NOT cl_null(g_errno) THEN
#                    CALL cl_err('',g_errno,1)
#                    LET g_atm05 = g_atm05_t
#                    LET g_errno = ' '
#                    NEXT FIELD atm05
#                 END IF
#              END IF
#           END IF
#        END IF

#     AFTER FIELD atm06
#        IF NOT cl_null(g_atm06) THEN
#           SELECT asa01 FROM asa_file WHERE asa01 = g_atm06
#           IF sqlca.sqlcode = 100 THEN
#              CALL cl_err('','agl-265',1)
#              NEXT FIELD atm06
#           END IF
#           IF NOT cl_null(g_atm04) AND NOT cl_null(g_atm05) AND NOT cl_null(g_atm06) THEN
#              IF (g_atm04_t IS NULL OR (g_atm04 != g_atm04_t)) OR 
#                 (g_atm04_t IS NULL OR (g_atm04 != g_atm04_t)) OR
#                 (g_atm05_t IS NULL OR (g_atm05 != g_atm05_t)) OR
#                 (g_atm06_t IS NULL OR (g_atm06 != g_atm06_t)) THEN
#                 CALL i920_chk()
#                 IF NOT cl_null(g_errno) THEN
#                    CALL cl_err('',g_errno,1)
#                    LET g_atm06 = g_atm06_t
#                    LET g_errno = ' '
#                    NEXT FIELD atm06
#                 END IF
#              END IF
#           END IF
#        END IF

#     ON ACTION controlp
#         CASE
#            WHEN INFIELD(atm06)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_asa6"
#              LET g_qryparam.default1= g_atm06
#              CALL cl_create_qry() RETURNING g_atm06
#              NEXT FIELD atm06
#           OTHERWISE
#              EXIT CASE
#         END CASE

#   END INPUT
#END FUNCTION

#FUNCTION i920_u()
#  DEFINE l_atm_lock    RECORD LIKE atm_file.*
#  IF s_shut(0) THEN
#     RETURN
#  END IF
#  IF g_chkey = 'N' THEN
#     CALL cl_err('','agl-266',1)
#     RETURN
#  END IF
#  IF cl_null(g_atm04) THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
#  MESSAGE ""
#  LET g_atm04_t = g_atm04
#  LET g_atm05_t = g_atm05
#  LET g_atm06_t = g_atm06

#  BEGIN WORK
#  OPEN i920_cl USING g_atm00,g_atm04,g_atm05,g_atm06
#  IF STATUS THEN
#     CALL cl_err("DATA LOCK:",STATUS,1)
#     CLOSE i920_cl
#     ROLLBACK WORK
#     RETURN
#  END IF
#  FETCH i920_cl INTO l_atm_lock.*
#  IF SQLCA.sqlcode THEN
#     CALL cl_err("atm04 LOCK:",SQLCA.sqlcode,1)
#     CLOSE i920_cl
#     ROLLBACK WORK
#     RETURN
#  END IF

#  WHILE TRUE
#     CALL i920_i("u")
#     IF INT_FLAG THEN
#        LET g_atm04 = g_atm04_t
#        LET g_atm05 = g_atm05_t
#        LET g_atm06 = g_atm06_t
#        DISPLAY g_atm04,g_atm05,g_atm06 TO atm04,atm05,atm06
#        LET INT_FLAG = 0
#        CALL cl_err('',9001,0)
#        EXIT WHILE
#     END IF
#     IF g_atm00 = 'N' THEN LET g_atm06 = ' ' END IF
#     UPDATE atm_file SET atm04 = g_atm04, atm05 = g_atm05, atm06 = g_atm06
#      WHERE atm04 = g_atm04_t
#        AND atm05 = g_atm05_t
#        AND atm06 = g_atm06_t
#        AND atm00 = g_atm00
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3("upd","atm_file",g_atm04_t,g_atm05_t,SQLCA.sqlcode,"","",1)
#        CONTINUE WHILE
#     END IF
#     EXIT WHILE
#  END WHILE
#  COMMIT WORK
#END FUNCTION

#FUNCTION i920_count()
#  DEFINE l_atm     DYNAMIC ARRAY of RECORD
#           atm04   LIKE atm_file.atm04,
#           atm05   LIKE atm_file.atm05,
#           atm06   LIKE atm_file.atm06 
#                   END RECORD
#  DEFINE li_cnt   LIKE type_file.num10 
#  DEFINE li_rec_b LIKE type_file.num10

#  LET g_sql = "SELECT DISTINCT atm04,atm05,atm06 FROM atm_file WHERE ",g_wc CLIPPED,
#              "   AND atm00 = '",g_atm00,"'",
#              " ORDER BY atm05,atm06"
#  PREPARE i920_precount FROM g_sql
#  DECLARE i920_count CURSOR FOR i920_precount
#  LET li_cnt=1
#  LET li_rec_b=0
#  FOREACH i920_count INTO l_atm[li_cnt].*
#      LET li_rec_b = li_rec_b + 1
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#         LET li_rec_b = li_rec_b - 1
#         EXIT FOREACH
#      END IF
#      LET li_cnt = li_cnt + 1
#   END FOREACH
#   LET g_row_count=li_rec_b

#END FUNCTION

#FUNCTION i920_q()
#  DEFINE li_rec_b LIKE type_file.num10
#  MESSAGE ""
#  LET g_row_count = 0
#  LET g_curs_index = 0
#  CALL cl_navigator_setting( g_curs_index, g_row_count )
#  CLEAR FORM
#  CALL g_atm.clear()
#  DISPLAY '' TO formonly.cnt
#  CALL i920_cs()
#  IF INT_FLAG THEN                              #使用者不玩了
#     LET INT_FLAG = 0
#     RETURN
#  END IF
#  OPEN i920_cs                         #從db產生合乎條件temp(0-30秒)
#  IF sqlca.sqlcode THEN                         #有問題
#     CALL cl_err('',sqlca.sqlcode,0)
#     INITIALIZE g_atm04 TO NULL
#     INITIALIZE g_atm05 TO NULL
#     INITIALIZE g_atm06 TO NULL
#  ELSE
#     CALL i920_count()
#     DISPLAY g_row_count TO FORMONLY.cnt
#     CALL i920_fetch('F')                 #讀出temp第一筆並顯示
#   END IF
#END FUNCTION

#FUNCTION i920_fetch(p_flag)                  #處理資料的讀取
#  DEFINE   p_flag   LIKE type_file.chr1,         #處理方式
#           l_abso   LIKE type_file.num10         #絕對的筆數

#  MESSAGE ""
#  CASE p_flag
#     WHEN 'N' FETCH NEXT     i920_cs INTO g_atm04,g_atm05,g_atm06
#     WHEN 'P' FETCH PREVIOUS i920_cs INTO g_atm04,g_atm05,g_atm06
#     WHEN 'F' FETCH FIRST    i920_cs INTO g_atm04,g_atm05,g_atm06
#     WHEN 'L' FETCH LAST     i920_cs INTO g_atm04,g_atm05,g_atm06
#     WHEN '/'
#        IF (NOT g_no_ask) THEN
#           CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
#              LET INT_FLAG = 0
#           PROMPT g_msg CLIPPED,': ' FOR g_jump
#               ON IDLE g_idle_seconds
#                  CALL cl_on_idle()

#               ON ACTION controlp
#                  CALL cl_cmdask()

#               ON ACTION HELP
#                  CALL cl_show_help()

#               ON ACTION about
#                  CALL cl_about()

#           END PROMPT
#           IF INT_FLAG THEN
#              LET INT_FLAG = 0
#              EXIT CASE
#           END IF
#        END IF
#        FETCH ABSOLUTE g_jump i920_cs INTO g_atm04,g_atm05,g_atm06
#        LET g_no_ask = FALSE
#  END CASE

#  IF sqlca.sqlcode THEN
#     CALL cl_err(g_atm04,sqlca.sqlcode,0)
#     INITIALIZE g_atm04 TO NULL
#     INITIALIZE g_atm05 TO NULL
#     INITIALIZE g_atm06 TO NULL
#  ELSE
#     CASE p_flag
#        WHEN 'F' LET g_curs_index = 1
#        WHEN 'P' LET g_curs_index = g_curs_index - 1
#        WHEN 'N' LET g_curs_index = g_curs_index + 1
#        WHEN 'L' LET g_curs_index = g_row_count
#        WHEN '/' LET g_curs_index = g_jump
#     END CASE

#     CALL cl_navigator_setting(g_curs_index, g_row_count)

#     CALL i920_show()
#  END IF
#END FUNCTION

#FUNCTION i920_show()                         # 將資料顯示在畫面上
#  DISPLAY g_atm04,g_atm05,g_atm06 TO atm04,atm05,atm06
#  CALL i920_b_fill(g_wc)                    # 單身
#  CALL cl_show_fld_cont()
#END FUNCTION

#FUNCTION i920_b()
#DEFINE l_ac_t          LIKE type_file.num5,                #未取消的array cnt
#      l_n             LIKE type_file.num5,                #檢查重複用
#      l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
#      p_cmd           LIKE type_file.chr1,                #處理狀態
#      l_possible      LIKE type_file.num5,                #用來設定判斷重複的可能性
#      l_allow_insert  LIKE type_file.chr1,                #可新增否
#      l_allow_delete  LIKE type_file.chr1                 #可刪除否

#  IF s_shut(0) THEN RETURN END IF

#  LET l_allow_insert = cl_detail_input_auth('insert')
#  LET l_allow_delete = cl_detail_input_auth('delete')
#  CALL cl_opmsg('b')

#  LET g_forupd_sql = " select atm00,atm01,atm02,atm03,atm04,atm05,atm06 ",
#                     "   from atm_file  ",
#                     "  where atm00 = ? ",
#                     "    and atm01 = ? ",
#                     "    and atm04 = ? ",
#                     "    and atm05 = ? ",
#                     "    and atm06 = ? for update "
#  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#  DECLARE i920_bcl CURSOR FROM g_forupd_sql      # lock cursor

#  INPUT ARRAY g_atm WITHOUT DEFAULTS FROM s_atm.*
#     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

#     BEFORE INPUT
#        LET g_action_choice = ""
#        IF g_rec_b!=0 THEN
#           CALL fgl_set_arr_curr(l_ac)
#        END IF

#     BEFORE ROW
#        LET p_cmd=''
#        LET l_ac = arr_curr()
#        LET l_lock_sw = 'n'            #default
#        LET l_n  = arr_count()

#        IF g_rec_b >= l_ac THEN
#           LET p_cmd='u'
#           LET  g_before_input_done = FALSE
#           CALL i920_set_entry(p_cmd)
#           CALL i920_set_no_entry(p_cmd)
#           LET  g_before_input_done = TRUE
#           BEGIN WORK
#           LET p_cmd='u'
#           LET g_atm_t.* = g_atm[l_ac].*  #backup
#           OPEN i920_bcl USING g_atm_t.atm00,g_atm_t.atm01,g_atm04,g_atm05,g_atm06
#           IF STATUS THEN
#              CALL cl_err("open i920_bcl:", STATUS, 1)
#              LET l_lock_sw = "y"
#           ELSE
#              FETCH i920_bcl INTO g_atm[l_ac].*
#              IF sqlca.sqlcode THEN
#                 CALL cl_err(g_atm_t.atm00,sqlca.sqlcode,1)
#                 LET l_lock_sw = "y"
#              END IF
#           END IF
#           CALL cl_show_fld_cont()
#        END IF

#     BEFORE INSERT
#        LET l_n = arr_count()
#        LET p_cmd='a'
#        LET  g_before_input_done = FALSE
#        CALL i920_set_entry(p_cmd)
#        CALL i920_set_no_entry(p_cmd)
#        LET  g_before_input_done = TRUE
#        INITIALIZE g_atm[l_ac].* TO NULL
#        LET g_atm[l_ac].atm00 = 'n'           #default
#        LET g_atm_t.* = g_atm[l_ac].*         #新輸入資料
#        CALL cl_show_fld_cont()
#        NEXT FIELD atm01

#     BEFORE FIELD atm01                        #default 序號
#       IF g_atm[l_ac].atm01 IS NULL OR g_atm[l_ac].atm01 = 0 THEN
#          SELECT max(atm01)+1
#            INTO g_atm[l_ac].atm01
#            FROM atm_file
#           WHERE atm00 = g_atm00
#             AND atm04 = g_atm04
#             AND atm05 = g_atm05
#             AND atm06 = g_atm06
#          IF g_atm[l_ac].atm01 IS NULL THEN
#             LET g_atm[l_ac].atm01 = 1
#          END IF
#       END IF

#     AFTER FIELD atm01                        #check 編號是否重複
#        IF NOT cl_null(g_atm[l_ac].atm01) THEN
#           IF g_atm[l_ac].atm01 != g_atm_t.atm01 OR
#              (g_atm[l_ac].atm01 IS NOT NULL AND g_atm_t.atm01 IS NULL) THEN
#              SELECT COUNT(*) INTO l_n FROM atm_file
#               WHERE atm00 = g_atm00
#                 AND atm01 = g_atm[l_ac].atm01
#                 AND atm04 = g_atm04
#                 AND atm05 = g_atm05
#                 AND atm06 = g_atm06
#              IF l_n > 0 THEN
#                 CALL cl_err('',-239,0)
#                 LET g_atm[l_ac].atm01 = g_atm_t.atm01
#                 NEXT FIELD atm01
#              END IF
#           END IF
#        END IF

#     BEFORE DELETE                            #是否取消單身
#        IF g_atm_t.atm01 IS NOT NULL AND g_atm_t.atm01 IS NOT NULL THEN
#           IF NOT cl_delete() THEN
#              CANCEL DELETE
#           END IF
#           INITIALIZE g_doc.* TO NULL
#           LET g_doc.column1 = "atm01"
#           LET g_doc.value1 = g_atm[l_ac].atm01
#           CALL cl_del_doc()
#           IF l_lock_sw = "y" THEN
#              CALL cl_err("", -263, 1)
#              CANCEL DELETE
#           END IF
#           DELETE FROM atm_file
#            WHERE atm00 = g_atm00
#              AND atm01 = g_atm_t.atm01
#              AND atm04 = g_atm04
#              AND atm05 = g_atm05
#              AND atm06 = g_atm06
#           IF sqlca.sqlcode THEN
#              CALL cl_err3("del","atm_file",g_atm_t.atm01,"",sqlca.sqlcode,"","",1)
#              ROLLBACK WORK
#              CANCEL DELETE
#           END IF
#           LET g_rec_b=g_rec_b-1
#           DISPLAY g_rec_b TO formonly.cn2
#           COMMIT WORK
#        END IF

#     ON ROW CHANGE
#        IF INT_FLAG THEN
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           LET g_atm[l_ac].* = g_atm_t.*
#           CLOSE i920_bcl
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF
#        IF l_lock_sw = 'y' THEN
#           CALL cl_err(g_atm[l_ac].atm01,-263,1)
#           LET g_atm[l_ac].* = g_atm_t.*
#        ELSE
#           UPDATE atm_file SET atm00 = g_atm00,
#                               atm01 = g_atm[l_ac].atm01,
#                               atm02 = g_atm[l_ac].atm02,
#                               atm03 = g_atm[l_ac].atm03
#            WHERE atm00 = g_atm00
#              AND atm01 = g_atm_t.atm01
#              AND atm04 = g_atm04
#              AND atm05 = g_atm05
#              AND atm06 = g_atm06
#           IF sqlca.sqlcode THEN
#              CALL cl_err3("upd","atm_file",g_atm_t.atm01,"",sqlca.sqlcode,"","",1)
#              LET g_atm[l_ac].* = g_atm_t.*
#              ROLLBACK WORK
#           ELSE
#              MESSAGE 'update o.k'
#              COMMIT WORK
#           END IF
#        END IF

#     AFTER ROW
#        LET l_ac = arr_curr()
#        LET l_ac_t = l_ac

#        IF INT_FLAG THEN
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           IF p_cmd='u' THEN
#              LET g_atm[l_ac].* = g_atm_t.*
#           END IF
#           CLOSE i920_bcl
#           ROLLBACK WORK
#           EXIT INPUT
#        END IF

#        CLOSE i920_bcl
#        COMMIT WORK

#     AFTER INSERT
#        IF INT_FLAG THEN
#           CALL cl_err('',9001,0)
#           LET INT_FLAG = 0
#           CLOSE i920_bcl
#           CALL g_atm.deleteelement(l_ac)
#           IF g_rec_b != 0 THEN
#              LET g_action_choice = "detail"
#              LET l_ac = l_ac_t
#           END IF
#           EXIT INPUT
#        END IF

#        IF g_atm00 = 'N' THEN LET g_atm06 = ' ' END IF

#        INSERT INTO atm_file(atm00,atm01,atm02,atm03,atm04,atm05,atm06)
#                      VALUES(g_atm00,g_atm[l_ac].atm01,g_atm[l_ac].atm02,
#                             g_atm[l_ac].atm03,g_atm04,g_atm05,g_atm06)
#         IF sqlca.sqlcode THEN
#            CALL cl_err3("ins","atm_file",g_atm[l_ac].atm01,"",sqlca.sqlcode,"","",1)
#            LET g_atm[l_ac].* = g_atm_t.*
#         ELSE
#            MESSAGE 'insert o.k'
#            LET g_rec_b = g_rec_b + 1
#            DISPLAY g_rec_b TO formonly.cn2
#         END IF

#     ON ACTION controlo                        #沿用所有欄位
#        IF INFIELD(atm00) AND l_ac > 1 THEN
#           LET g_atm[l_ac].* = g_atm[l_ac-1].*
#           NEXT FIELD atm00
#        END IF

#     ON ACTION controlz
#        CALL cl_show_req_fields()

#     ON ACTION controlg
#        CALL cl_cmdask()

#     ON ACTION controlf
#        CALL cl_set_focus_form(ui.interface.getrootnode()) RETURNING g_fld_name,g_frm_name
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT

#     ON ACTION about
#        CALL cl_about()

#     ON ACTION HELP
#        CALL cl_show_help()

#  END INPUT

#  CLOSE i920_bcl
#  COMMIT WORK

#END FUNCTION


#FUNCTION i920_b_fill(p_wc2)              #body fill up
#DEFINE p_wc2     LIKE type_file.chr1000

#  LET g_sql = "SELECT atm00,atm01,atm02,atm03",
#              "  FROM atm_file",
#              " WHERE atm04 = '",g_atm04,"'",
#              "   AND atm05 = '",g_atm05,"'",
#              "   AND atm06 = '",g_atm06,"'",
#              "   AND atm00 = '",g_atm00,"'",
#              " ORDER BY 2"
#  PREPARE i920_pb FROM g_sql
#  DECLARE atm_curs CURSOR FOR i920_pb

#  CALL g_atm.clear()
#  LET g_cnt = 1
#  MESSAGE "searching!"

#  FOREACH atm_curs INTO g_atm[g_cnt].*   #單身 array 填充
#     IF STATUS THEN
#        CALL cl_err('foreach:',STATUS,1)
#        EXIT FOREACH
#     END IF

#     LET g_cnt = g_cnt + 1

#     IF g_cnt > g_max_rec THEN
#        CALL cl_err( '', 9035, 0 )
#        EXIT FOREACH
#     END IF

#  END FOREACH

#  CALL g_atm.deleteelement(g_cnt)
#  MESSAGE ""
#  LET g_rec_b = g_cnt-1
#  DISPLAY g_rec_b TO formonly.cn2
#  LET g_cnt = 0

#END FUNCTION

#FUNCTION i920_copy()
#  DEFINE   l_n       LIKE type_file.num5,
#           l_atm04   LIKE atm_file.atm04,
#           l_atm05   LIKE atm_file.atm05,
#           l_atm06   LIKE atm_file.atm06,
#           l_old04   LIKE atm_file.atm04,
#           l_old05   LIKE atm_file.atm05,
#           l_old06   LIKE atm_file.atm06

#  IF s_shut(0) THEN                             # 檢查權限
#     RETURN
#  END IF

#  IF g_atm04 IS NULL OR g_atm05 IS NULL OR g_atm06 IS NULL THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
#  LET l_atm04 = NULL
#  LET l_atm05 = NULL
#  IF g_atm00 = 'Y' THEN 
#     LET l_atm06 = NULL
#  ELSE
#     LET l_atm06 = ' '
#  END IF
#  CALL cl_set_head_visible("","yes")
#  INPUT l_atm04,l_atm05,l_atm06 WITHOUT DEFAULTS FROM atm04,atm05,atm06


#     AFTER FIELD atm04
#        IF NOT cl_null(l_atm04) AND NOT cl_null(l_atm05) AND NOT cl_null(l_atm06) THEN
#           SELECT COUNT(atm04) INTO l_n FROM atm_file
#            WHERE atm04 = l_atm04
#              AND atm05 = l_atm05
#              AND atm06 = l_atm06
#              AND atm00 = g_atm00
#           IF l_n > 0 THEN
#              LET g_errno = '-239'
#           ELSE
#              LET g_errno = ' '
#           END IF
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err('',g_errno,1)
#              LET l_atm04 = NULL
#              LET g_errno = ' '
#              NEXT FIELD atm04
#           END IF
#        END IF

#     AFTER FIELD atm05
#        IF NOT cl_null(l_atm05) THEN
#           IF l_atm05 < 1 OR l_atm05 > l_tmp  THEN
#              CALL cl_err('','agl-020',1)
#              NEXT FIELD atm05
#           END IF
#           IF NOT cl_null(l_atm04) AND NOT cl_null(l_atm05) AND NOT cl_null(l_atm06) THEN
#              SELECT COUNT(atm04) INTO l_n FROM atm_file
#               WHERE atm04 = l_atm04
#                 AND atm05 = l_atm05
#                 AND atm06 = l_atm06
#                 AND atm00 = g_atm00
#              IF l_n > 0 THEN
#                 LET g_errno = '-239'
#              ELSE
#                 LET g_errno = ' '
#              END IF
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err('',g_errno,1)
#                 LET l_atm05 = NULL
#                 LET g_errno = ' '
#                 NEXT FIELD atm05
#              END IF
#           END IF
#        END IF

#     AFTER FIELD atm06
#        IF NOT cl_null(l_atm06) THEN
#           SELECT asa01 FROM asa_file WHERE asa01 = l_atm06
#           IF sqlca.sqlcode = 100 THEN
#              CALL cl_err('','agl-265',1)
#              NEXT FIELD atm06
#           END IF
#           IF NOT cl_null(g_atm04) AND NOT cl_null(l_atm05) AND NOT cl_null(l_atm06) THEN
#              SELECT COUNT(atm04) INTO l_n FROM atm_file
#               WHERE atm04 = l_atm04
#                 AND atm05 = l_atm05
#                 AND atm06 = l_atm06
#                 AND atm00 = g_atm00
#              IF l_n > 0 THEN
#                 LET g_errno = '-239'
#              ELSE
#                LET g_errno = ' '
#              END IF
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err('',g_errno,1)
#                 LET l_atm06 = NULL
#                 LET g_errno = ' '
#                 NEXT FIELD atm06
#              END IF
#           END IF
#        END IF

#     AFTER INPUT
#        IF INT_FLAG THEN
#           EXIT INPUT
#        END IF
#         SELECT COUNT(*) INTO g_cnt FROM atm_file
#          WHERE gae01 = l_atm04 AND gae11 = l_atm05 AND gae12 = l_atm06
#         IF g_cnt > 0 THEN
#            CALL cl_err_msg(NULL,"azz-110",l_atm04||"|"||l_atm05,10)
#         END IF

#     ON ACTION controlp
#         CASE
#            WHEN INFIELD(atm06)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_asa6"
#              LET g_qryparam.default1= g_atm06
#              CALL cl_create_qry() RETURNING g_atm06
#              NEXT FIELD atm06
#           OTHERWISE
#              EXIT CASE
#         END CASE

#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT

#     ON ACTION HELP
#        CALL cl_show_help()
#     ON ACTION controlg
#        CALL cl_cmdask()
#     ON ACTION about
#        CALL cl_about()

#  END INPUT

#  IF INT_FLAG THEN
#     LET INT_FLAG = 0
#     DISPLAY g_atm04,g_atm05,g_atm06 TO atm04,atm05,atm06
#     RETURN
#  END IF

#  DROP TABLE x
#  SELECT * FROM atm_file WHERE atm04 = g_atm04 AND atm05 = g_atm05 AND atm06 = g_atm06 AND atm00 = g_atm00
#    INTO TEMP x

#  IF sqlca.sqlcode THEN
#     CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",0)
#     RETURN
#  END IF

#  UPDATE x
#     SET atm04 = l_atm04,                        # 資料鍵值
#         atm05 = l_atm05,                        # 資料鍵值
#         atm06 = l_atm06                         # 資料鍵值

#  INSERT INTO atm_file SELECT * FROM x

#  IF sqlca.sqlcode THEN
#     CALL cl_err3("ins","gae_file","","",sqlca.sqlcode,"","",0)
#     RETURN
#  END IF


#  LET l_old04 = g_atm04
#  LET l_old05 = g_atm05
#  LET l_old06 = g_atm06
#  LET g_atm04 = l_atm04
#  LET g_atm05 = l_atm05
#  LET g_atm06 = l_atm06
#  CALL i920_b()
#  LET g_atm04 = l_old04
#  LET g_atm05 = l_old05
#  LET g_atm06 = l_old06
#  CALL i920_show()
#END FUNCTION

#FUNCTION i920_r()        # 取消整筆 (所有合乎單頭的資料)
#  DEFINE   l_cnt   LIKE type_file.num5,
#           l_gae   RECORD LIKE atm_file.*

#  IF s_shut(0) THEN RETURN END IF
#  IF cl_null(g_atm04) THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
#  BEGIN WORK
#  IF cl_delh(0,0) THEN                   #確認一下
#     DELETE FROM atm_file
#      WHERE atm04 = g_atm04 AND atm05 = g_atm05 AND atm06 = g_atm06
#     CLEAR FORM
#     CALL g_atm.CLEAR()
#     LET g_atm04 = NULL
#     LET g_atm05 = NULL
#     LET g_atm06 = NULL
#     CALL i920_count()
#     DISPLAY g_row_count TO FORMONLY.cnt
#     OPEN i920_cs
#     IF g_curs_index = g_row_count + 1 THEN
#        LET g_jump = g_row_count
#        CALL i920_fetch('L')
#     ELSE
#        LET g_jump = g_curs_index
#        LET g_no_ask = TRUE
#        CALL i920_fetch('/')
#     END IF
#  END IF

#  CLOSE i920_cs
#  COMMIT WORK
#END FUNCTION

#FUNCTION i920_bp(p_ud)
#  DEFINE   p_ud   LIKE type_file.chr1


#  IF p_ud <> "g" OR g_action_choice = "detail" THEN
#     RETURN
#  END IF

#  LET g_action_choice = " "

#  CALL cl_set_act_visible("accept,cancel", FALSE)
#  DISPLAY ARRAY g_atm TO s_atm.* ATTRIBUTE(COUNT=g_rec_b)

#     BEFORE ROW
#        LET l_ac = arr_curr()
#     CALL cl_show_fld_cont()
#     ON ACTION insert
#        LET g_action_choice="insert"
#        EXIT DISPLAY

#     ON ACTION modify
#        LET g_action_choice="modify"
#        EXIT DISPLAY

#     ON ACTION query
#        LET g_action_choice="query"
#        EXIT DISPLAY

#     ON ACTION reproduce
#        LET g_action_choice='reproduce'
#        EXIT DISPLAY

#     ON ACTION delete
#        LET g_action_choice='delete'
#        EXIT DISPLAY

#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY

#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY

#     ON ACTION FIRST                            # 第一筆
#        CALL i920_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)
#        END IF
#        ACCEPT DISPLAY

#     ON ACTION PREVIOUS                         # p.上筆
#        CALL i920_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)
#        END IF
#       ACCEPT DISPLAY
#       
#     ON ACTION jump                             # 指定筆
#        CALL i920_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)
#        END IF
#        ACCEPT DISPLAY
#        
#     ON ACTION NEXT                             # n.下筆
#        CALL i920_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)
#        END IF
#        ACCEPT DISPLAY
#        
#     ON ACTION LAST                             # 最終筆
#        CALL i920_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)
#        END IF
#        ACCEPT DISPLAY

#     ON ACTION HELP
#        LET g_action_choice="help"
#        EXIT DISPLAY
#        
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()
#         
#     ON ACTION EXIT
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#        
#     ON ACTION controlg
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
#        
#     ON ACTION ACCEPT
#        LET g_action_choice="detail"
#        LET l_ac = arr_curr()
#        EXIT DISPLAY
#        
#     ON ACTION CANCEL
#        LET INT_FLAG=FALSE
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#        
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#        
#     ON ACTION about
#        CALL cl_about()

#@    on action 相關文件
#      ON ACTION related_document
#        LET g_action_choice="related_document"
#        EXIT DISPLAY

#     ON ACTION exporttoexcel
#        LET g_action_choice = 'exporttoexcel'
#        EXIT DISPLAY

#     AFTER DISPLAY
#        CONTINUE DISPLAY

#  END DISPLAY

#  CALL cl_set_act_visible("accept,cancel", TRUE)

#END FUNCTION

#FUNCTION i920_set_entry(p_cmd)
# DEFINE p_cmd   LIKE type_file.chr1
#  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("atm01",TRUE)
#  END IF
#END FUNCTION

#FUNCTION i920_set_no_entry(p_cmd)
# DEFINE p_cmd   LIKE type_file.chr1
#  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("atm01",FALSE)
#  END IF
#END FUNCTION

#FUNCTION i920_chk()
#  DEFINE l_n      LIKE type_file.num5
#  SELECT COUNT(atm04) INTO l_n FROM atm_file
#   WHERE atm04 = g_atm04
#     AND atm05 = g_atm05
#     AND atm06 = g_atm06
#     AND atm00 = g_atm00
#  IF l_n > 0 THEN
#     LET g_errno = '-239'
#  ELSE 
#     LET g_errno = ' ' 
#  END IF
#END FUNCTION
#MOD-C40131------E------


#MOD-C40131------S------
DEFINE
   g_gim            DYNAMIC ARRAY OF RECORD   #程式變數(program variables)   #FUN-B80180
      gim00         LIKE gim_file.gim00,
      gim01         LIKE gim_file.gim01,
      gim02         LIKE gim_file.gim02,
      gim03         LIKE gim_file.gim03
                    END RECORD,
   g_gim_t          RECORD                   #程式變數 (舊值)
       gim00        LIKE gim_file.gim00,
       gim01        LIKE gim_file.gim01,
       gim02        LIKE gim_file.gim02,
       gim03        LIKE gim_file.gim03
                    END RECORD,
   g_gim00          LIKE gim_file.gim00,
   g_wc2,g_wc       STRING,
   g_sql            STRING,
   g_rec_b          LIKE type_file.num5,     #單身筆數
   l_ac             LIKE type_file.num5      #目前處理的array cnt
DEFINE g_gim04      LIKE gim_file.gim04
DEFINE g_gim05      LIKE gim_file.gim05
DEFINE g_gim06      LIKE gim_file.gim06
DEFINE g_gim04_t    LIKE gim_file.gim04
DEFINE g_gim05_t    LIKE gim_file.gim05
DEFINE g_gim06_t    LIKE gim_file.gim06
DEFINE g_forupd_sql STRING
DEFINE g_msg        LIKE ze_file.ze03
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_i          LIKE type_file.num5      #count/index for any purpose
DEFINE l_cmd        LIKE type_file.chr1000
DEFINE g_curs_index LIKE type_file.num10
DEFINE g_row_count  LIKE type_file.num10
DEFINE g_jump       LIKE type_file.num10
DEFINE g_no_ask     LIKE type_file.num5
DEFINE g_before_input_done  LIKE type_file.num5
DEFINE l_tmp        LIKE type_file.num5
DEFINE l_aza02      LIKE aza_file.aza02

FUNCTION i920(p_gim00)
DEFINE p_gim00 LIKE type_file.chr1

   WHENEVER ERROR CALL cl_err_msg_log

   LET g_forupd_sql = " SELECT * FROM gim_file ",
                      " WHERE gim00 = ? AND gim04 = ? ",
                      "   AND gim05 = ? AND gim06 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i920_cl CURSOR FROM g_forupd_sql
   LET g_gim00= p_gim00
   CALL cl_set_comp_visible("gim00",FALSE)

   SELECT aza02 INTO l_aza02 FROM aza_file
   IF l_aza02 = '1' THEN LET l_tmp = 12 ELSE LET l_tmp = 13 END IF
   IF g_gim00 = 'N' THEN 
      LET g_gim06 = ' '
      CALL cl_set_comp_visible("gim06",FALSE)
   END IF

   CALL i920_menu()
END FUNCTION

FUNCTION i920_cs()

   CLEAR FORM
   CALL g_gim.clear()
   
   IF g_gim00 = 'Y' THEN
      CONSTRUCT g_wc ON gim04,gim05,gim06,gim01,gim02,gim03
           FROM gim04,gim05,gim06,s_gim[1].gim01,s_gim[1].gim02,s_gim[1].gim03
      
         BEFORE CONSTRUCT
           CALL cl_qbe_init()

         ON ACTION controlp
            CASE
               WHEN INFIELD(gim06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asa6"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gim06
                  NEXT FIELD gim0im066

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
   ELSE
      CONSTRUCT g_wc ON gim04,gim05,gim01,gim02,gim03
           FROM gim04,gim05,s_gim[1].gim01,s_gim[1].gim02,s_gim[1].gim03

         BEFORE CONSTRUCT
           CALL cl_qbe_init()

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
   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(NULL, NULL)

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF

      LET g_sql = "SELECT DISTINCT gim04,gim05,gim06 ",
                  "  FROM gim_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND gim00 = '",g_gim00,"'",
                  " ORDER BY gim04"

   PREPARE i920_prepare FROM g_sql
   DECLARE i920_cs                         #scroll cursor
       SCROLL CURSOR WITH HOLD FOR i920_prepare

END FUNCTION

FUNCTION i920_menu()

   WHILE TRUE
      CALL i920_bp("g")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i920_q()
            END IF
         WHEN "insert"                          # a.輸入
            IF cl_chk_act_auth() THEN
               CALL i920_a()
            END IF
         WHEN "modify"                          # u.更新
            IF cl_chk_act_auth() THEN
               CALL i920_u()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL i920_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i920_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "delete"                          # r.取消
            IF cl_chk_act_auth() THEN
               CALL i920_r()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET l_cmd = 'p_query "ggli504" "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_gim[l_ac].gim01 IS NOT NULL THEN
                  LET g_doc.column1 = "gim00"
                  LET g_doc.value1 = g_gim[l_ac].gim00
                  LET g_doc.column2 = "gim01"
                  LET g_doc.value2 = g_gim[l_ac].gim01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.interface.getrootnode(),base.typeinfo.create(g_gim),'','')
            END IF
      END CASE
   END WHILE

END FUNCTION

FUNCTION i920_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_gim.clear()
   LET g_gim04 = NULL
   LET g_gim05 = NULL
   LET g_gim06 = NULL

   WHILE TRUE
      CALL i920_i("a")                       # 輸入單頭

      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_gim04 = NULL
         LET g_gim05 = NULL
         LET g_gim06 = NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0

      CALL i920_b()                          # 輸入單身
      LET g_gim04_t = g_gim04
      LET g_gim05_t = g_gim05
      LET g_gim06_t = g_gim06
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i920_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_count      LIKE type_file.num5
   INPUT g_gim04,g_gim05,g_gim06 
      WITHOUT DEFAULTS FROM gim04,gim05,gim06

      AFTER FIELD gim04
         IF NOT cl_null(g_gim04) AND NOT cl_null(g_gim05) AND NOT cl_null(g_gim06) THEN
            IF (g_gim04_t IS NULL OR (g_gim04 != g_gim04_t)) OR
               (g_gim05_t IS NULL OR (g_gim05 != g_gim05_t)) OR
               (g_gim06_t IS NULL OR (g_gim06 != g_gim06_t)) THEN
               CALL i920_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET g_gim04 = g_gim04_t
                  LET g_errno = ' '
                  NEXT FIELD gim04
               END IF
            END IF
         END IF

      AFTER FIELD gim05
         IF NOT cl_null(g_gim05) THEN
            IF g_gim05 < 1 OR g_gim05 > l_tmp  THEN
               CALL cl_err('','agl-020',1)
               NEXT FIELD gim05
            END IF
            IF NOT cl_null(g_gim04) AND NOT cl_null(g_gim05) AND NOT cl_null(g_gim06) THEN
               IF (g_gim04_t IS NULL OR (g_gim04 != g_gim04_t)) OR 
                  (g_gim05_t IS NULL OR (g_gim05 != g_gim05_t)) OR 
                  (g_gim06_t IS NULL OR (g_gim06 != g_gim06_t)) THEN
                  CALL i920_chk()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,1)
                     LET g_gim05 = g_gim05_t
                     LET g_errno = ' '
                     NEXT FIELD gim05
                  END IF
               END IF
            END IF
         END IF

      AFTER FIELD gim06
         IF NOT cl_null(g_gim06) THEN
            SELECT asa01 FROM asa_file WHERE asa01 = g_gim06
            IF sqlca.sqlcode = 100 THEN
               CALL cl_err('','agl-265',1)
               NEXT FIELD gim06
            END IF
            IF NOT cl_null(g_gim04) AND NOT cl_null(g_gim05) AND NOT cl_null(g_gim06) THEN
               IF (g_gim04_t IS NULL OR (g_gim04 != g_gim04_t)) OR 
                  (g_gim04_t IS NULL OR (g_gim04 != g_gim04_t)) OR
                  (g_gim05_t IS NULL OR (g_gim05 != g_gim05_t)) OR
                  (g_gim06_t IS NULL OR (g_gim06 != g_gim06_t)) THEN
                  CALL i920_chk()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,1)
                     LET g_gim06 = g_gim06_t
                     LET g_errno = ' '
                     NEXT FIELD gim06
                  END IF
               END IF
            END IF
         END IF

      ON ACTION controlp
          CASE
             WHEN INFIELD(gim06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_asa6"
               LET g_qryparam.default1= g_gim06
               CALL cl_create_qry() RETURNING g_gim06
               NEXT FIELD gim06
            OTHERWISE
               EXIT CASE
          END CASE

    END INPUT
END FUNCTION

FUNCTION i920_u()
   DEFINE l_gim_lock    RECORD LIKE gim_file.*
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_chkey = 'N' THEN
      CALL cl_err('','agl-266',1)
      RETURN
   END IF
   IF cl_null(g_gim04) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   LET g_gim04_t = g_gim04
   LET g_gim05_t = g_gim05
   LET g_gim06_t = g_gim06

   BEGIN WORK
   OPEN i920_cl USING g_gim00,g_gim04,g_gim05,g_gim06
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i920_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i920_cl INTO l_gim_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gim04 LOCK:",SQLCA.sqlcode,1)
      CLOSE i920_cl
      ROLLBACK WORK
      RETURN
   END IF

   WHILE TRUE
      CALL i920_i("u")
      IF INT_FLAG THEN
         LET g_gim04 = g_gim04_t
         LET g_gim05 = g_gim05_t
         LET g_gim06 = g_gim06_t
         DISPLAY g_gim04,g_gim05,g_gim06 TO gim04,gim05,gim06
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_gim00 = 'N' THEN LET g_gim06 = ' ' END IF
      UPDATE gim_file SET gim04 = g_gim04, gim05 = g_gim05, gim06 = g_gim06
       WHERE gim04 = g_gim04_t
         AND gim05 = g_gim05_t
         AND gim06 = g_gim06_t
         AND gim00 = g_gim00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gim_file",g_gim04_t,g_gim05_t,SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION

FUNCTION i920_count()
   DEFINE l_gim     DYNAMIC ARRAY of RECORD
            gim04   LIKE gim_file.gim04,
            gim05   LIKE gim_file.gim05,
            gim06   LIKE gim_file.gim06 
                    END RECORD
   DEFINE li_cnt   LIKE type_file.num10 
   DEFINE li_rec_b LIKE type_file.num10

   LET g_sql = "SELECT DISTINCT gim04,gim05,gim06 FROM gim_file WHERE ",g_wc CLIPPED,
               "   AND gim00 = '",g_gim00,"'",
               " ORDER BY gim05,gim06"
   PREPARE i920_precount FROM g_sql
   DECLARE i920_count CURSOR FOR i920_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i920_count INTO l_gim[li_cnt].*
       LET li_rec_b = li_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET li_rec_b = li_rec_b - 1
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_rec_b

END FUNCTION

FUNCTION i920_q()
   DEFINE li_rec_b LIKE type_file.num10
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM
   CALL g_gim.clear()
   DISPLAY '' TO formonly.cnt
   CALL i920_cs()
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i920_cs                         #從db產生合乎條件temp(0-30秒)
   IF sqlca.sqlcode THEN                         #有問題
      CALL cl_err('',sqlca.sqlcode,0)
      INITIALIZE g_gim04 TO NULL
      INITIALIZE g_gim05 TO NULL
      INITIALIZE g_gim06 TO NULL
   ELSE
      CALL i920_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i920_fetch('F')                 #讀出temp第一筆並顯示
    END IF
END FUNCTION

FUNCTION i920_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,         #處理方式
            l_abso   LIKE type_file.num10         #絕對的筆數

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i920_cs INTO g_gim04,g_gim05,g_gim06
      WHEN 'P' FETCH PREVIOUS i920_cs INTO g_gim04,g_gim05,g_gim06
      WHEN 'F' FETCH FIRST    i920_cs INTO g_gim04,g_gim05,g_gim06
      WHEN 'L' FETCH LAST     i920_cs INTO g_gim04,g_gim05,g_gim06
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION controlp
                   CALL cl_cmdask()

                ON ACTION HELP
                   CALL cl_show_help()

                ON ACTION about
                   CALL cl_about()

            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i920_cs INTO g_gim04,g_gim05,g_gim06
         LET g_no_ask = FALSE
   END CASE

   IF sqlca.sqlcode THEN
      CALL cl_err(g_gim04,sqlca.sqlcode,0)
      INITIALIZE g_gim04 TO NULL
      INITIALIZE g_gim05 TO NULL
      INITIALIZE g_gim06 TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)

      CALL i920_show()
   END IF
END FUNCTION

FUNCTION i920_show()                         # 將資料顯示在畫面上
   DISPLAY g_gim04,g_gim05,g_gim06 TO gim04,gim05,gim06
   CALL i920_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i920_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的array cnt
       l_n             LIKE type_file.num5,                #檢查重複用
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否
       p_cmd           LIKE type_file.chr1,                #處理狀態
       l_possible      LIKE type_file.num5,                #用來設定判斷重複的可能性
       l_allow_insert  LIKE type_file.chr1,                #可新增否
       l_allow_delete  LIKE type_file.chr1                 #可刪除否

   IF s_shut(0) THEN RETURN END IF

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   CALL cl_opmsg('b')

   LET g_forupd_sql = " select gim00,gim01,gim02,gim03,gim04,gim05,gim06 ",
                      "   from gim_file  ",
                      "  where gim00 = ? ",
                      "    and gim01 = ? ",
                      "    and gim04 = ? ",
                      "    and gim05 = ? ",
                      "    and gim06 = ? for update "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i920_bcl CURSOR FROM g_forupd_sql      # lock cursor

   INPUT ARRAY g_gim WITHOUT DEFAULTS FROM s_gim.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = arr_curr()
         LET l_lock_sw = 'n'            #default
         LET l_n  = arr_count()

         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET  g_before_input_done = FALSE
            CALL i920_set_entry(p_cmd)
            CALL i920_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            BEGIN WORK
            LET p_cmd='u'
            LET g_gim_t.* = g_gim[l_ac].*  #backup
            OPEN i920_bcl USING g_gim_t.gim00,g_gim_t.gim01,g_gim04,g_gim05,g_gim06
            IF STATUS THEN
               CALL cl_err("open i920_bcl:", STATUS, 1)
               LET l_lock_sw = "y"
            ELSE
               FETCH i920_bcl INTO g_gim[l_ac].*
               IF sqlca.sqlcode THEN
                  CALL cl_err(g_gim_t.gim00,sqlca.sqlcode,1)
                  LET l_lock_sw = "y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = arr_count()
         LET p_cmd='a'
         LET  g_before_input_done = FALSE
         CALL i920_set_entry(p_cmd)
         CALL i920_set_no_entry(p_cmd)
         LET  g_before_input_done = TRUE
         INITIALIZE g_gim[l_ac].* TO NULL
         LET g_gim[l_ac].gim00 = 'n'           #default
         LET g_gim_t.* = g_gim[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD gim01

      BEFORE FIELD gim01                        #default 序號
        IF g_gim[l_ac].gim01 IS NULL OR g_gim[l_ac].gim01 = 0 THEN
           SELECT max(gim01)+1
             INTO g_gim[l_ac].gim01
             FROM gim_file
            WHERE gim00 = g_gim00
              AND gim04 = g_gim04
              AND gim05 = g_gim05
              AND gim06 = g_gim06
           IF g_gim[l_ac].gim01 IS NULL THEN
              LET g_gim[l_ac].gim01 = 1
           END IF
        END IF

      AFTER FIELD gim01                        #check 編號是否重複
         IF NOT cl_null(g_gim[l_ac].gim01) THEN
            IF g_gim[l_ac].gim01 != g_gim_t.gim01 OR
               (g_gim[l_ac].gim01 IS NOT NULL AND g_gim_t.gim01 IS NULL) THEN
               SELECT COUNT(*) INTO l_n FROM gim_file
                WHERE gim00 = g_gim00
                  AND gim01 = g_gim[l_ac].gim01
                  AND gim04 = g_gim04
                  AND gim05 = g_gim05
                  AND gim06 = g_gim06
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gim[l_ac].gim01 = g_gim_t.gim01
                  NEXT FIELD gim01
               END IF
            END IF
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_gim_t.gim01 IS NOT NULL AND g_gim_t.gim01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL
            LET g_doc.column1 = "gim01"
            LET g_doc.value1 = g_gim[l_ac].gim01
            CALL cl_del_doc()
            IF l_lock_sw = "y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM gim_file
             WHERE gim00 = g_gim00
               AND gim01 = g_gim_t.gim01
               AND gim04 = g_gim04
               AND gim05 = g_gim05
               AND gim06 = g_gim06
            IF sqlca.sqlcode THEN
               CALL cl_err3("del","gim_file",g_gim_t.gim01,"",sqlca.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO formonly.cn2
            COMMIT WORK
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gim[l_ac].* = g_gim_t.*
            CLOSE i920_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'y' THEN
            CALL cl_err(g_gim[l_ac].gim01,-263,1)
            LET g_gim[l_ac].* = g_gim_t.*
         ELSE
            UPDATE gim_file SET gim00 = g_gim00,
                                gim01 = g_gim[l_ac].gim01,
                                gim02 = g_gim[l_ac].gim02,
                                gim03 = g_gim[l_ac].gim03
             WHERE gim00 = g_gim00
               AND gim01 = g_gim_t.gim01
               AND gim04 = g_gim04
               AND gim05 = g_gim05
               AND gim06 = g_gim06
            IF sqlca.sqlcode THEN
               CALL cl_err3("upd","gim_file",g_gim_t.gim01,"",sqlca.sqlcode,"","",1)
               LET g_gim[l_ac].* = g_gim_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'update o.k'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = arr_curr()
         #LET l_ac_t = l_ac  #FUN-D30032

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gim[l_ac].* = g_gim_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_gim.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i920_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032

         CLOSE i920_bcl
         COMMIT WORK

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i920_bcl
            CALL g_gim.deleteelement(l_ac)
            IF g_rec_b != 0 THEN
               LET g_action_choice = "detail"
               LET l_ac = l_ac_t
            END IF
            EXIT INPUT
         END IF

         IF g_gim00 = 'N' THEN LET g_gim06 = ' ' END IF

         INSERT INTO gim_file(gim00,gim01,gim02,gim03,gim04,gim05,gim06)
                       VALUES(g_gim00,g_gim[l_ac].gim01,g_gim[l_ac].gim02,
                              g_gim[l_ac].gim03,g_gim04,g_gim05,g_gim06)
          IF sqlca.sqlcode THEN
             CALL cl_err3("ins","gim_file",g_gim[l_ac].gim01,"",sqlca.sqlcode,"","",1)
             LET g_gim[l_ac].* = g_gim_t.*
          ELSE
             MESSAGE 'insert o.k'
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO formonly.cn2
          END IF

      ON ACTION controlo                        #沿用所有欄位
         IF INFIELD(gim00) AND l_ac > 1 THEN
            LET g_gim[l_ac].* = g_gim[l_ac-1].*
            NEXT FIELD gim00
         END IF

      ON ACTION controlz
         CALL cl_show_req_fields()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION controlf
         CALL cl_set_focus_form(ui.interface.getrootnode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION HELP
         CALL cl_show_help()

   END INPUT

   CLOSE i920_bcl
   COMMIT WORK

END FUNCTION


FUNCTION i920_b_fill(p_wc2)              #body fill up
DEFINE p_wc2     LIKE type_file.chr1000

   LET g_sql = "SELECT gim00,gim01,gim02,gim03",
               "  FROM gim_file",
               " WHERE gim04 = '",g_gim04,"'",
               "   AND gim05 = '",g_gim05,"'",
               "   AND gim06 = '",g_gim06,"'",
               "   AND gim00 = '",g_gim00,"'",
               " ORDER BY 2"
   PREPARE i920_pb FROM g_sql
   DECLARE gim_curs CURSOR FOR i920_pb

   CALL g_gim.clear()
   LET g_cnt = 1
   MESSAGE "searching!"

   FOREACH gim_curs INTO g_gim[g_cnt].*   #單身 array 填充
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

   CALL g_gim.deleteelement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO formonly.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION i920_copy()
   DEFINE   l_n       LIKE type_file.num5,
            l_gim04   LIKE gim_file.gim04,
            l_gim05   LIKE gim_file.gim05,
            l_gim06   LIKE gim_file.gim06,
            l_old04   LIKE gim_file.gim04,
            l_old05   LIKE gim_file.gim05,
            l_old06   LIKE gim_file.gim06

   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF

   IF g_gim04 IS NULL OR g_gim05 IS NULL OR g_gim06 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET l_gim04 = NULL
   LET l_gim05 = NULL
   IF g_gim00 = 'Y' THEN 
      LET l_gim06 = NULL
   ELSE
      LET l_gim06 = ' '
   END IF
   CALL cl_set_head_visible("","yes")
   INPUT l_gim04,l_gim05,l_gim06 WITHOUT DEFAULTS FROM gim04,gim05,gim06


      AFTER FIELD gim04
         IF NOT cl_null(l_gim04) AND NOT cl_null(l_gim05) AND NOT cl_null(l_gim06) THEN
            SELECT COUNT(gim04) INTO l_n FROM gim_file
             WHERE gim04 = l_gim04
               AND gim05 = l_gim05
               AND gim06 = l_gim06
               AND gim00 = g_gim00
            IF l_n > 0 THEN
               LET g_errno = '-239'
            ELSE
               LET g_errno = ' '
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,1)
               LET l_gim04 = NULL
               LET g_errno = ' '
               NEXT FIELD gim04
            END IF
         END IF

      AFTER FIELD gim05
         IF NOT cl_null(l_gim05) THEN
            IF l_gim05 < 1 OR l_gim05 > l_tmp  THEN
               CALL cl_err('','agl-020',1)
               NEXT FIELD gim05
            END IF
            IF NOT cl_null(l_gim04) AND NOT cl_null(l_gim05) AND NOT cl_null(l_gim06) THEN
               SELECT COUNT(gim04) INTO l_n FROM gim_file
                WHERE gim04 = l_gim04
                  AND gim05 = l_gim05
                  AND gim06 = l_gim06
                  AND gim00 = g_gim00
               IF l_n > 0 THEN
                  LET g_errno = '-239'
               ELSE
                  LET g_errno = ' '
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET l_gim05 = NULL
                  LET g_errno = ' '
                  NEXT FIELD gim05
               END IF
            END IF
         END IF

      AFTER FIELD gim06
         IF NOT cl_null(l_gim06) THEN
            SELECT asa01 FROM asa_file WHERE asa01 = l_gim06
            IF sqlca.sqlcode = 100 THEN
               CALL cl_err('','agl-265',1)
               NEXT FIELD gim06
            END IF
            IF NOT cl_null(g_gim04) AND NOT cl_null(l_gim05) AND NOT cl_null(l_gim06) THEN
               SELECT COUNT(gim04) INTO l_n FROM gim_file
                WHERE gim04 = l_gim04
                  AND gim05 = l_gim05
                  AND gim06 = l_gim06
                  AND gim00 = g_gim00
               IF l_n > 0 THEN
                  LET g_errno = '-239'
               ELSE
                 LET g_errno = ' '
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  LET l_gim06 = NULL
                  LET g_errno = ' '
                  NEXT FIELD gim06
               END IF
            END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
          SELECT COUNT(*) INTO g_cnt FROM gim_file
           WHERE gae01 = l_gim04 AND gae11 = l_gim05 AND gae12 = l_gim06
          IF g_cnt > 0 THEN
             CALL cl_err_msg(NULL,"azz-110",l_gim04||"|"||l_gim05,10)
          END IF

      ON ACTION controlp
          CASE
             WHEN INFIELD(gim06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_asa6"
               LET g_qryparam.default1= g_gim06
               CALL cl_create_qry() RETURNING g_gim06
               NEXT FIELD gim06
            OTHERWISE
               EXIT CASE
          END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION HELP
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_gim04,g_gim05,g_gim06 TO gim04,gim05,gim06
      RETURN
   END IF

   DROP TABLE x
   SELECT * FROM gim_file WHERE gim04 = g_gim04 AND gim05 = g_gim05 AND gim06 = g_gim06 AND gim00 = g_gim00
     INTO TEMP x

   IF sqlca.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",0)
      RETURN
   END IF

   UPDATE x
      SET gim04 = l_gim04,                        # 資料鍵值
          gim05 = l_gim05,                        # 資料鍵值
          gim06 = l_gim06                         # 資料鍵值

   INSERT INTO gim_file SELECT * FROM x

   IF sqlca.sqlcode THEN
      CALL cl_err3("ins","gae_file","","",sqlca.sqlcode,"","",0)
      RETURN
   END IF


   LET l_old04 = g_gim04
   LET l_old05 = g_gim05
   LET l_old06 = g_gim06
   LET g_gim04 = l_gim04
   LET g_gim05 = l_gim05
   LET g_gim06 = l_gim06
   CALL i920_b()
   #FUN-C30027---begin
   #LET g_gim04 = l_old04
   #LET g_gim05 = l_old05
   #LET g_gim06 = l_old06
   #CALL i920_show()
   #FUN-C30027---end
END FUNCTION

FUNCTION i920_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,
            l_gae   RECORD LIKE gim_file.*

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gim04) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM gim_file
       WHERE gim04 = g_gim04 AND gim05 = g_gim05 AND gim06 = g_gim06
      CLEAR FORM
      CALL g_gim.CLEAR()
      LET g_gim04 = NULL
      LET g_gim05 = NULL
      LET g_gim06 = NULL
      CALL i920_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i920_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i920_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i920_fetch('/')
      END IF
   END IF

   CLOSE i920_cs
   COMMIT WORK
END FUNCTION

FUNCTION i920_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "g" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gim TO s_gim.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = arr_curr()
      CALL cl_show_fld_cont()
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION reproduce
         LET g_action_choice='reproduce'
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice='delete'
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION FIRST                            # 第一筆
         CALL i920_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION PREVIOUS                         # p.上筆
         CALL i920_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
        ACCEPT DISPLAY
        
      ON ACTION jump                             # 指定筆
         CALL i920_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
         
      ON ACTION NEXT                             # n.下筆
         CALL i920_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
         
      ON ACTION LAST                             # 最終筆
         CALL i920_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DISPLAY
         
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
          
      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
         
      ON ACTION ACCEPT
         LET g_action_choice="detail"
         LET l_ac = arr_curr()
         EXIT DISPLAY
         
      ON ACTION CANCEL
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
         
      ON ACTION about
         CALL cl_about()

#@    on action 相關文件
       ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION i920_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("gim01",TRUE)
   END IF
END FUNCTION

FUNCTION i920_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("gim01",FALSE)
   END IF
END FUNCTION

FUNCTION i920_chk()
   DEFINE l_n      LIKE type_file.num5
   SELECT COUNT(gim04) INTO l_n FROM gim_file
    WHERE gim04 = g_gim04
      AND gim05 = g_gim05
      AND gim06 = g_gim06
      AND gim00 = g_gim00
   IF l_n > 0 THEN
      LET g_errno = '-239'
   ELSE 
      LET g_errno = ' ' 
   END IF
END FUNCTION
#MOD-C40131------E------

