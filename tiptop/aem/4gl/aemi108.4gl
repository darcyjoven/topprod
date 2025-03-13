# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: aemi108.4gl
# Descriptions...: 設備停機記錄維護作業
# Date & Author..: 04/07/08 By Carrier
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: No.MOD-540141 05/04/20 By vivien  刪除HELP FILE
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680072 06/08/23 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780037 07/06/29 By sherry 報表格式修改為p_query 
# Modify.........: No.FUN-980002 09/08/20 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fik           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        fik01       LIKE fik_file.fik01,
        fik02       LIKE fik_file.fik02,
        fik03       LIKE fik_file.fik03,
        fik04       LIKE fik_file.fik04,
        fik05       LIKE fik_file.fik05,
        fik06       LIKE fik_file.fik06
                    END RECORD,
    g_fik_t         RECORD                 #程式變數 (舊值)
        fik01       LIKE fik_file.fik01,
        fik02       LIKE fik_file.fik02,
        fik03       LIKE fik_file.fik03,
        fik04       LIKE fik_file.fik04,
        fik05       LIKE fik_file.fik05,
        fik06       LIKE fik_file.fik06
                    END RECORD,
     g_wc2,g_sql     STRING,  #No.FUN-580092 HCN
     g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680072 SMALLINT
     l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
DEFINE   p_row,p_col     LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE   g_msg           STRING                  
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   l_cmd           LIKE type_file.chr1000           #No.FUN-780037  
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0068
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AEM")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
    LET p_row = 3 LET p_col = 3
 
    OPEN WINDOW i108_w AT p_row,p_col WITH FORM "aem/42f/aemi108"
        ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i108_b_fill(g_wc2)
    CALL i108_menu()
    CLOSE WINDOW i108_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
FUNCTION i108_menu()
   WHILE TRUE
      CALL i108_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i108_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               IF g_rec_b= 0 THEN
                  CALL g_fik.deleteElement(1)
               END IF
               CALL i108_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
            #No.FUN-780037---Begin      
             #  CALL i108_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                   
               LET l_cmd = 'p_query "aemi108" "',g_wc2 CLIPPED,'"'   
               CALL cl_cmdrun(l_cmd) 
            #No.FUN-780037---End
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
 
FUNCTION i108_q()
   CALL i108_b_askkey()
END FUNCTION
 
FUNCTION i108_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT        #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重複用        #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否        #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #處理狀態          #No.FUN-680072 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                            #No.FUN-680072CHAR(1)
    l_allow_delete  LIKE type_file.chr1                             #No.FUN-680072CHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT fik01,fik02,fik03,fik04,fik05,fik06 ",
                       "  FROM fik_file ",
                       " WHERE fik01=? AND fik02=? AND fik03=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i108_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t=0
    INPUT ARRAY g_fik WITHOUT DEFAULTS FROM s_fik.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                     APPEND ROW = l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=' '
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_fik_t.* = g_fik[l_ac].*  #BACKUP
#No.FUN-570110 --start--
               LET g_before_input_done = FALSE
               CALL i108_set_entry_b(p_cmd)
               CALL i108_set_no_entry_b(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570110 --end--
               OPEN i108_bcl USING g_fik_t.fik01,g_fik_t.fik02,g_fik_t.fik03
               IF STATUS THEN
                  CALL cl_err("OPEN i108_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i108_bcl INTO g_fik[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_fik_t.fik01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110 --start--
            LET g_before_input_done = FALSE
            CALL i108_set_entry_b(p_cmd)
            CALL i108_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570110 --end--
            INITIALIZE g_fik[l_ac].* TO NULL      #900423
            LET g_fik_t.* = g_fik[l_ac].*         #新輸入資料
            LET g_fik[l_ac].fik02 = g_today
#            LET g_fik[l_ac].fik03 = '0000'
            LET g_fik[l_ac].fik04 = g_today
#            LET g_fik[l_ac].fik05 = '2359'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fik01
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            CALL i108_fik()
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
            ELSE
               INSERT INTO fik_file
               VALUES(g_fik[l_ac].fik01,g_fik[l_ac].fik02,
                      g_fik[l_ac].fik03,g_fik[l_ac].fik04,
                      g_fik[l_ac].fik05,g_fik[l_ac].fik06,
                         g_user,g_grup,'',g_today,
                      g_plant,g_legal, g_user, g_grup) #FUN-980002       #No.FUN-980030 10/01/04  insert columns oriu, orig
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_fik[l_ac].fik01,SQLCA.sqlcode,0)   #No.FUN-660092
                  CALL cl_err3("ins","fik_file",g_fik[l_ac].fik01,g_fik[l_ac].fik02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
               END IF
            END IF
 
        AFTER FIELD fik01
            IF NOT cl_null(g_fik[l_ac].fik01) THEN
               CALL i108_fik01()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err(g_fik[l_ac].fik01,g_errno,0)
                  LET g_fik[l_ac].fik01 = g_fik_t.fik01
                  NEXT FIELD fik01
               END IF
               IF NOT cl_null(g_fik[l_ac].fik02) AND NOT cl_null(g_fik[l_ac].fik03) THEN
                  IF g_fik[l_ac].fik01 != g_fik_t.fik01 OR cl_null(g_fik_t.fik01)
                  OR g_fik[l_ac].fik02 != g_fik_t.fik02 OR cl_null(g_fik_t.fik02)
                  OR g_fik[l_ac].fik03 != g_fik_t.fik03 OR cl_null(g_fik_t.fik03)
                  THEN
                     SELECT COUNT(*) INTO l_n FROM fik_file
                      WHERE fik01 = g_fik[l_ac].fik01
                        AND fik02 = g_fik[l_ac].fik02
                        AND fik03 = g_fik[l_ac].fik03
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_fik[l_ac].fik01 = g_fik_t.fik01
                        NEXT FIELD fik01
                     END IF
                  END IF
               END IF
            END IF
 
        AFTER FIELD fik02
            IF NOT cl_null(g_fik[l_ac].fik02) THEN
               IF NOT cl_null(g_fik[l_ac].fik01) AND NOT cl_null(g_fik[l_ac].fik03) THEN
                  IF g_fik[l_ac].fik01 != g_fik_t.fik01 OR cl_null(g_fik_t.fik01)
                  OR g_fik[l_ac].fik02 != g_fik_t.fik02 OR cl_null(g_fik_t.fik02)
                  OR g_fik[l_ac].fik03 != g_fik_t.fik03 OR cl_null(g_fik_t.fik03)
                  THEN
                     SELECT COUNT(*) INTO l_n FROM fik_file
                      WHERE fik01 = g_fik[l_ac].fik01
                        AND fik02 = g_fik[l_ac].fik02
                        AND fik03 = g_fik[l_ac].fik03
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_fik[l_ac].fik02 = g_fik_t.fik02
                        NEXT FIELD fik02
                     END IF
                  END IF
               END IF
            END IF
 
        BEFORE FIELD fik03
            IF cl_null(g_fik[l_ac].fik03) THEN
               LET g_fik[l_ac].fik03 = '0000'
            END IF
 
        AFTER FIELD fik03
            IF NOT cl_null(g_fik[l_ac].fik03) THEN
               LET g_i=LENGTH(g_fik[l_ac].fik03)
               IF g_i <> 4 THEN
                  CALL cl_err(g_fik[l_ac].fik03,'aem-006',0)
                  NEXT FIELD fik03
               END IF
               IF g_fik[l_ac].fik03 NOT MATCHES '[0-9][0-9][0-9][0-9]'
               OR g_fik[l_ac].fik03[1,2] <'00' OR g_fik[l_ac].fik03[1,2]>'23'
               OR g_fik[l_ac].fik03[3,4] NOT MATCHES '[0-5][0-9]' THEN
                  CALL cl_err(g_fik[l_ac].fik03,'aem-006',0)
                  NEXT FIELD fik03
               END IF
               IF NOT cl_null(g_fik[l_ac].fik01) AND NOT cl_null(g_fik[l_ac].fik02) THEN
                  IF g_fik[l_ac].fik01 != g_fik_t.fik01 OR cl_null(g_fik_t.fik01)
                  OR g_fik[l_ac].fik02 != g_fik_t.fik02 OR cl_null(g_fik_t.fik02)
                  OR g_fik[l_ac].fik03 != g_fik_t.fik03 OR cl_null(g_fik_t.fik03)
                  THEN
                     SELECT COUNT(*) INTO l_n FROM fik_file
                      WHERE fik01 = g_fik[l_ac].fik01
                        AND fik02 = g_fik[l_ac].fik02
                        AND fik03 = g_fik[l_ac].fik03
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_fik[l_ac].fik03 = g_fik_t.fik03
                        NEXT FIELD fik03
                     END IF
                  END IF
               END IF
            END IF
 
        AFTER FIELD fik04
            IF NOT cl_null(g_fik[l_ac].fik04) THEN
               IF g_fik[l_ac].fik04 < g_fik[l_ac].fik02 THEN
                  CALL cl_err(g_fik[l_ac].fik04,'aem-007',0)
                  NEXT FIELD fik04
               END IF
               IF g_fik[l_ac].fik01 != g_fik_t.fik01 OR cl_null(g_fik_t.fik01)
               OR g_fik[l_ac].fik04 != g_fik_t.fik04 OR cl_null(g_fik_t.fik04)
               OR g_fik[l_ac].fik05 != g_fik_t.fik05 OR cl_null(g_fik_t.fik05)
               THEN
                  SELECT COUNT(*) INTO l_n FROM fik_file
                   WHERE fik01 = g_fik[l_ac].fik01
                     AND fik04 = g_fik[l_ac].fik04
                     AND fik05 = g_fik[l_ac].fik05
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_fik[l_ac].fik04 = g_fik_t.fik04
                     #------MOD-5A0095 START----------
                     DISPLAY BY NAME g_fik[l_ac].fik04
                     #------MOD-5A0095 END------------
                     NEXT FIELD fik04
                  END IF
               END IF
            END IF
 
        BEFORE FIELD fik05
            IF cl_null(g_fik[l_ac].fik05) THEN
               LET g_fik[l_ac].fik05 = '2359'
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_fik[l_ac].fik05
               #------MOD-5A0095 END------------
            END IF
 
        AFTER FIELD fik05
            IF NOT cl_null(g_fik[l_ac].fik05) THEN
               LET g_i=LENGTH(g_fik[l_ac].fik05)
               IF g_i <> 4 THEN
                  CALL cl_err(g_fik[l_ac].fik05,'aem-006',0)
                  NEXT FIELD fik05
               END IF
               IF g_fik[l_ac].fik05 NOT MATCHES '[0-9][0-9][0-9][0-9]'
               OR g_fik[l_ac].fik05[1,2] <'00' OR g_fik[l_ac].fik05[1,2]>'23'
               OR g_fik[l_ac].fik05[3,4] NOT MATCHES '[0-5][0-9]' THEN
                  CALL cl_err(g_fik[l_ac].fik05,'aem-006',0)
                  NEXT FIELD fik05
               END IF
               IF  g_fik[l_ac].fik04 = g_fik[l_ac].fik02
               AND g_fik[l_ac].fik05 < g_fik[l_ac].fik03 THEN
                  CALL cl_err(g_fik[l_ac].fik05,'aem-007',0)
                  NEXT FIELD fik03
               END IF
               IF g_fik[l_ac].fik01 != g_fik_t.fik01 OR cl_null(g_fik_t.fik01)
               OR g_fik[l_ac].fik04 != g_fik_t.fik04 OR cl_null(g_fik_t.fik04)
               OR g_fik[l_ac].fik05 != g_fik_t.fik05 OR cl_null(g_fik_t.fik05)
               THEN
                  SELECT COUNT(*) INTO l_n FROM fik_file
                   WHERE fik01 = g_fik[l_ac].fik01
                     AND fik04 = g_fik[l_ac].fik04
                     AND fik05 = g_fik[l_ac].fik05
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_fik[l_ac].fik05 = g_fik_t.fik05
                     NEXT FIELD fik05
                  END IF
               END IF
               CALL i108_fik()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD fik02
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fik_t.fik01 IS NOT NULL OR g_fik_t.fik02 IS NOT NULL
            OR g_fik_t.fik03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM fik_file WHERE fik01 = g_fik_t.fik01
                                      AND fik02 = g_fik_t.fik02
                                      AND fik03 = g_fik_t.fik03
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fik_t.fik01,SQLCA.sqlcode,0)   #No.FUN-660092
                   CALL cl_err3("del","fik_file",g_fik_t.fik01,g_fik_t.fik02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
               MESSAGE "Delete Ok"
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fik[l_ac].* = g_fik_t.*
               CLOSE i108_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw="Y" THEN
               CALL cl_err(g_fik[l_ac].fik01,-263,0)
               LET g_fik[l_ac].* = g_fik_t.*
            ELSE
               CALL i108_fik()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
               ELSE
                  UPDATE fik_file
                     SET fik01=g_fik[l_ac].fik01,fik02=g_fik[l_ac].fik02,
                         fik03=g_fik[l_ac].fik03,fik04=g_fik[l_ac].fik04,
                         fik05=g_fik[l_ac].fik05,fik06=g_fik[l_ac].fik06,
                         fikmodu=g_user,fikdate=g_today
                   WHERE fik01 = g_fik_t.fik01
                     AND fik02 = g_fik_t.fik02
                     AND fik03 = g_fik_t.fik03
                  IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_fik[l_ac].fik01,SQLCA.sqlcode,1)   #No.FUN-660092
                     CALL cl_err3("upd","fik_file",g_fik_t.fik01,g_fik_t.fik02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                     LET g_fik[l_ac].* = g_fik_t.*
                     CLOSE i108_bcl
                     ROLLBACK WORK
                  ELSE
                     MESSAGE 'UPDATE O.K'
                     COMMIT WORK
                  END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_fik[l_ac].* = g_fik_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fik.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i108_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            IF NOT cl_null(g_errno)  THEN
               NEXT FIELD fik02
            END IF
            CLOSE i108_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO
            IF INFIELD(fik01) AND l_ac > 1 THEN
                LET g_fik[l_ac].* = g_fik[l_ac-1].*
                NEXT FIELD fik01
            END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(fik01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fia"
                  LET g_qryparam.default1 = g_fik[l_ac].fik01
                  CALL FGL_DIALOG_SETBUFFER( g_fik[l_ac].fik01 )
                  CALL cl_create_qry() RETURNING g_fik[l_ac].fik01
                  NEXT FIELD fik01
           END CASE
 
 #No.MOD-540141--begin
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 #No.MOD-540141--end
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
    END INPUT
 
    CLOSE i108_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i108_fik01()
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
        l_fia02     LIKE fia_file.fia02,
        l_fiaacti   LIKE fia_file.fiaacti
 
  LET g_errno = ' '
  SELECT fia02,fiaacti INTO l_fia02,l_fiaacti
    FROM fia_file
   WHERE fia01 = g_fik[l_ac].fik01
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
       WHEN l_fiaacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
 
FUNCTION i108_fik()
DEFINE l_n      LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
    LET g_errno = ' '
    SELECT COUNT(*) INTO l_n FROM fik_file
     WHERE fik01 = g_fik[l_ac].fik01
       AND (((fik02 < g_fik[l_ac].fik02 OR    #停機時間在暫停範圍內
             (fik02 = g_fik[l_ac].fik02 AND fik03 < g_fik[l_ac].fik03)) AND
             (fik04 > g_fik[l_ac].fik02 OR
             (fik04 = g_fik[l_ac].fik02 AND fik05 > g_fik[l_ac].fik03)))
        OR  ((fik02 < g_fik[l_ac].fik04 OR    #開機時間在暫停範圍內
             (fik02 = g_fik[l_ac].fik04 AND fik03 < g_fik[l_ac].fik05)) AND
             (fik04 > g_fik[l_ac].fik04 OR
             (fik04 = g_fik[l_ac].fik04 AND fik05 > g_fik[l_ac].fik05)))
        OR  ((fik02 > g_fik[l_ac].fik02 OR    #暫停時間包含在範圍內
             (fik02 = g_fik[l_ac].fik02 AND fik03 >= g_fik[l_ac].fik03)) AND
             (fik04 < g_fik[l_ac].fik04 OR
             (fik04 = g_fik[l_ac].fik04 AND fik05 <= g_fik[l_ac].fik05))))
       AND (fik02 <> g_fik_t.fik02 OR fik03 <> g_fik_t.fik03)
    IF l_n > 0 THEN
       LET g_errno = 'aem-008'
    END IF
 
END FUNCTION
 
FUNCTION i108_b_askkey()
    CLEAR FORM
    CALL g_fik.clear()
    CONSTRUCT g_wc2 ON fik01,fik02,fik03,fik04,fik05,fik06
            FROM s_fik[1].fik01,s_fik[1].fik02,s_fik[1].fik03,
                 s_fik[1].fik04,s_fik[1].fik05,s_fik[1].fik06
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(fik01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_fia"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_fik[1].fik01
                  NEXT FIELD fik01
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
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('fikuser', 'fikgrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i108_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i108_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    LET g_sql =
        "SELECT fik01,fik02,fik03,fik04,fik05,fik06",
        "  FROM fik_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY fik01,fik02,fik03"
    PREPARE i108_pb FROM g_sql
    DECLARE fik_curs CURSOR FOR i108_pb
 
    CALL g_fik.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH fik_curs INTO g_fik[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fik.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i108_bp(p_ud)
DEFINE
   p_ud            LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fik TO s_fik.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#No.FUN-780037---Begin
{FUNCTION i108_out()
    DEFINE
        l_fik           RECORD LIKE fik_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
        l_name          LIKE type_file.chr20,    #No.FUN-680072 VARCHAR(20)
        l_za05          LIKE type_file.chr1000   #No.FUN-680072 VARCHAR(40) 
 
    IF g_wc2 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('aemi108') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM fik_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i108_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i108_co                         # CURSOR
     CURSOR FOR i108_p1
 
    START REPORT i108_rep TO l_name
 
    FOREACH i108_co INTO l_fik.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i108_rep(l_fik.*)
    END FOREACH
 
    FINISH REPORT i108_rep
 
    CLOSE i108_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i108_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680072CHAR(01)
        l_aq            LIKE type_file.chr20,   #No.FUN-680072CHAR(20)
        l_b1            LIKE type_file.chr20,   #No.FUN-680072CHAR(20)
        sr RECORD LIKE fik_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fik01,sr.fik02,sr.fik03
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<', "/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1, g_x[1]
            PRINT
            PRINT g_dash[1,g_len]
            PRINT g_x[31], g_x[32], g_x[33],
                  g_x[34], g_x[35], g_x[36]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN  g_c[31],sr.fik01,
                  COLUMN  g_c[32],sr.fik02,
                  COLUMN  g_c[33],sr.fik03,
                  COLUMN  g_c[34],sr.fik04,
                  COLUMN  g_c[35],sr.fik05,
                  COLUMN  g_c[36],sr.fik06
 
        ON LAST ROW
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
END REPORT}
#No.FUN-780037---End
#No.FUN-570110 --start--
FUNCTION i108_set_entry_b(p_cmd)
 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("fik01,fik02,fik03",TRUE)
  END IF
 
END FUNCTION
 
 
FUNCTION i108_set_no_entry_b(p_cmd)
 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("fik01,fik02,fik03",FALSE)
   END IF
 
END FUNCTION
#No.FUN-570110 --end--
#Patch....NO.MOD-5A0095 <001,002> #
