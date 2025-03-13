# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aicq018.4gl
# Descriptions...: ICD料件光罩統計查詢作業
# Date & Author..: No.FUN-7B0076 07/11/21 By johnray
# Modify.........: No.TQC-820008 08/02/16 By baofei 修改INSERT INTO temptable語法
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE tm RECORD
          wc           LIKE type_file.chr1000  # Head Where condition
          END RECORD
DEFINE g_head_1 RECORD
                ict01  LIKE ict_file.ict01,
                ict02  LIKE ict_file.ict02,
                ima02  LIKE ima_file.ima02,
                ima021 LIKE ima_file.ima021
                END RECORD
DEFINE g_ict DYNAMIC ARRAY OF RECORD
             ict03     LIKE ict_file.ict03,
             ict04     LIKE ict_file.ict04,
             ict05     LIKE ict_file.ict05,
             ict06     LIKE ict_file.ict06
             END RECORD
DEFINE l_ac,l_sl       LIKE type_file.num5
DEFINE g_rec_b         LIKE type_file.num5     #單身筆數
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_msg           LIKE type_file.chr1000
DEFINE g_row_count     LIKE type_file.num10
DEFINE g_curs_index    LIKE type_file.num10
DEFINE g_jump          LIKE type_file.num10
DEFINE mi_no_ask       LIKE type_file.num5
DEFINE l_table         STRING
DEFINE g_str           STRING
DEFINE g_sql           STRING
DEFINE g_upd_flag      LIKE type_file.chr1     #結轉后需查詢刷新數據方可繼續操作
 
MAIN
   DEFINE l_time        LIKE type_file.chr8    #計算被使用時間
   DEFINE l_sl          LIKE type_file.num5
   DEFINE p_row,p_col   LIKE type_file.num5
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1)        #計算使用時間 (進入時間) #FUN-BB0047 mark
   #   RETURNING g_time
 
   LET g_sql = " ict01.ict_file.ict01,",
               " ict02.ict_file.ict02,",
               " ict03.ict_file.ict03,",
               " ics06.ics_file.ics03,",
               " ics00.ics_file.ics03,",
               " ics01.ics_file.ics01,",
               " ics02.ics_file.ics02,",
               " ics20.ics_file.ics20,",
               " ics13.ics_file.ics13,",
               " balance.ics_file.ics13,",
               " ics16.ics_file.ics16,",
               " ics19.ics_file.ics19,",
               " occ02.occ_file.occ02,",
               " ima02_1.ima_file.ima02,",
               " ima02_2.ima_file.ima02,",
               " ima02_3.ima_file.ima02,",
               " ics15.ics_file.ics15,",
               " ima021_1.ima_file.ima021,",
               " ima021_2.ima_file.ima021,",
               " ima021_3.ima_file.ima021,",
               " ics14.ics_file.ics14"
   LET l_table = cl_prt_temptable('aicq018',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#   LET g_sql = "INSERT INTO ds_report:",l_table CLIPPED,        #No.TQC-820008 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-820008  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET p_row = 2 LET p_col = 3
   OPEN WINDOW q018_w AT p_row,p_col WITH FORM "aic/42f/aicq018"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_upd_flag = 'N'                  #初始化
   CALL q018_menu()
   CLOSE WINDOW q018_w                   #結束畫面
   CALL cl_used(g_prog,g_time,2)         #計算使用時間 (退出時間)
      RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION q018_cs()
   DEFINE l_cnt LIKE type_file.num5
 
   CLEAR FORM #清除畫面
   CALL g_ict.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL               # Default condition
   CALL cl_set_head_visible("","YES")
 
   INITIALIZE g_head_1.* TO NULL
 
   CONSTRUCT BY NAME tm.wc ON ict01,ict02,ict03,ima02,ima021
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ict01)           #光罩料號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ict"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ict01
               NEXT FIELD ict01
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
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN RETURN END IF
   LET g_sql="SELECT UNIQUE ict01,ict02,ima02,ima021",
             "  FROM ict_file LEFT OUTER JOIN ima_file ON ict01 = ima01 ",
             " WHERE ",tm.wc CLIPPED,
             " ORDER BY 1,2,3,4 "
   PREPARE q018_prepare FROM g_sql
   DECLARE q018_cs SCROLL CURSOR FOR q018_prepare
 
   LET g_sql="SELECT UNIQUE ict01,ict02,ima02,ima021",
             "  FROM ict_file LEFT OUTER JOIN ima_file ON ict01 = ima01 ",
             " WHERE ",tm.wc CLIPPED,
             "  INTO TEMP x "
   DROP TABLE x
   PREPARE q018_precount_x FROM g_sql
   EXECUTE q018_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
 
   PREPARE q018_precount FROM g_sql
   DECLARE q018_count CURSOR FOR q018_precount
END FUNCTION
 
FUNCTION q018_menu()
 
   WHILE TRUE
      CALL q018_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q018_q()
            END IF
         WHEN "statistics_report"
            IF cl_chk_act_auth() THEN
               CALL q018_out()
            END IF
         WHEN "carry_forward"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_head_1.ict01) THEN
                  CALL cl_err('','-400',0)
                  CONTINUE WHILE
               END IF
               IF g_upd_flag = 'Y' THEN
                  CALL cl_err('','aic-202',0)
                  CONTINUE WHILE
               END IF
               CALL q018_carry_forward()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ict),'','')
             END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q018_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q018_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q018_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
       OPEN q018_count
       FETCH q018_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q018_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
   LET g_upd_flag = 'N'                    # 每次查詢之后畫面上顯示的是最新數據
END FUNCTION
 
FUNCTION q018_fetch(p_flag)
DEFINE
   p_flag LIKE type_file.chr1              #處理方式
 
   IF g_upd_flag = 'Y' THEN
      CALL cl_err('','aic-202',1)
      RETURN
   END IF
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q018_cs INTO g_head_1.*
      WHEN 'P' FETCH PREVIOUS q018_cs INTO g_head_1.*
      WHEN 'F' FETCH FIRST    q018_cs INTO g_head_1.*
      WHEN 'L' FETCH LAST     q018_cs INTO g_head_1.*
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0               #add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump q018_cs INTO g_head_1.*
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_head_1.ima021,SQLCA.sqlcode,0)
      INITIALIZE g_head_1.* TO NULL
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
   END IF
 
   CALL q018_show()
END FUNCTION
 
FUNCTION q018_show()
 
   #No.FUN-9A0024--begin   
   #DISPLAY BY NAME g_head_1.*  
   DISPLAY BY NAME g_head_1.ict01,g_head_1.ict02,g_head_1.ima02,g_head_1.ima021
   #No.FUN-9A0024--end   
   CALL q018_b_fill() #單身
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION q018_b_fill()              #BODY FILL UP
   DEFINE #l_sql     LIKE type_file.chr1000
          l_sql      STRING     #NO.FUN-910082
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_tot     LIKE ict_file.ict06
   DEFINE l_totf    LIKE ict_file.ict06
   DEFINE l_tot_o   LIKE ict_file.ict06
   DEFINE l_totf_o  LIKE ict_file.ict06
 
   LET l_sql = "SELECT ict03,ict04,ict05,ict06",
        "  FROM ict_file",
        " WHERE ict01 = '",g_head_1.ict01,"'",
        "   AND ict02 = '",g_head_1.ict02,"'",
        " ORDER BY ict03 "
    PREPARE q018_pb FROM l_sql
    IF STATUS THEN CALL cl_err('q018_pb',STATUS,1) RETURN END IF
    DECLARE q018_bcs CURSOR FOR q018_pb
 
    FOR g_cnt = 1 TO g_ict.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_ict[g_cnt].* TO NULL
    END FOR
    LET l_tot = 0
    LET l_ac = 1
    FOREACH q018_bcs INTO g_ict[l_ac].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('q018(ckp#1):',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_ac = l_ac + 1
       IF l_ac > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ict.deleteElement(l_ac)
    LET g_rec_b = l_ac - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET l_ac = 1
END FUNCTION
 
FUNCTION q018_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ict TO s_ict.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q018_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL q018_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL cl_set_act_visible("accept,cancel", TRUE)
         CALL q018_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL q018_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL q018_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION statistics_report               # 光罩累加數統計表
         LET g_action_choice = 'statistics_report'
         EXIT DISPLAY
 
      ON ACTION carry_forward            # 光罩累加數年度結轉
         LET g_action_choice = 'carry_forward'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q018_out()
DEFINE l_sql      STRING
DEFINE sr RECORD
          ict01    LIKE ict_file.ict01,
          ict02    LIKE ict_file.ict02,
          ict03    LIKE ict_file.ict03,
          ics06    LIKE ics_file.ics06,
          ics00    LIKE ics_file.ics00,
          ics01    LIKE ics_file.ics01,
          ics02    LIKE ics_file.ics02,
          ics20    LIKE ics_file.ics20,
          ics13    LIKE ics_file.ics13,
          balance  LIKE ics_file.ics13,
          ics16    LIKE ics_file.ics16,
          ics19    LIKE ics_file.ics19,
          occ02    LIKE occ_file.occ02,
          ima02_1  LIKE ima_file.ima02,
          ima02_2  LIKE ima_file.ima02,
          ima02_3  LIKE ima_file.ima02,
          ics15    LIKE ics_file.ics15,
          ima021_1 LIKE ima_file.ima021,
          ima021_2 LIKE ima_file.ima021,
          ima021_3 LIKE ima_file.ima021,
          ics14    LIKE ics_file.ics14
          END RECORD
 
   IF cl_null(tm.wc) THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   CALL cl_del_data(l_table)
 
   LET l_sql = " SELECT ict01,ict02,ics06,ics00,ics01,ics02,ics20,ics13,",
               "        ics13-ics15,ics16,ics19,occ02,A.ima02,B.ima02,C.ima02,",
               "        ics15,A.ima021,B.ima021,C.ima021,ics14 ",
               "   FROM ict_file,ics_file,OUTER occ_file,",
               "  OUTER ima_file A,OUTER ima_file B,OUTER ima_file C",
               "  WHERE ict01 = ics00 AND ics_file.ics06=occ_file.occ01 AND icspost = 'N' ",
               "    AND ics_file.ics00 = A.ima01 AND ics_file.ics02 = B.ima01 AND ics_file.ics20 = C.ima01",
               "    AND ",tm.wc CLIPPED
   PREPARE q018_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE q018_curs1 CURSOR FOR q018_prepare1
 
   FOREACH q018_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      EXECUTE insert_prep USING sr.*
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
   END FOREACH
 
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   CALL cl_wcchp(tm.wc,'ict01,ict02') RETURNING tm.wc
   LET g_str = tm.wc,";",g_zz05
   CALL cl_prt_cs3('aicq018','aicq018',l_sql,g_str)
END FUNCTION
 
FUNCTION q018_carry_forward()
DEFINE l_tm RECORD
            ict01   LIKE ict_file.ict01,
            year    LIKE type_file.num5
            END RECORD
DEFINE l_period     LIKE type_file.num5
DEFINE l_ict04      LIKE ict_file.ict04
DEFINE l_ict05      LIKE ict_file.ict05
DEFINE l_ict06      LIKE ict_file.ict06
DEFINE l_go         LIKE type_file.chr1
DEFINE l_flag       LIKE type_file.chr1
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_oea02      LIKE oea_file.oea02
 
   OPEN WINDOW q018_w_1 WITH FORM "aic/42f/aicq018_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale('aicq018_1')
 
   INPUT BY NAME l_tm.ict01,l_tm.year
 
      AFTER FIELD ict01
         IF cl_null(l_tm.ict01) THEN
            CALL cl_err('','azz-310',0)
            NEXT FIELD ict01
         ELSE
            SELECT COUNT(*) INTO l_cnt FROM ict_file
             WHERE ict01 = l_tm.ict01
            IF l_cnt < 1 THEN
               CALL cl_err('','aic-004',0)
               NEXT FIELD ict01
            END IF
         END IF
 
      AFTER FIELD year
         IF cl_null(l_tm.year) THEN
            CALL cl_err('','azz-310',0)
            NEXT FIELD year
         END IF
 
      ON ACTION CONTROLP
         IF INFIELD(ict01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_ict"
            CALL cl_create_qry() RETURNING l_tm.ict01
            DISPLAY l_tm.ict01 TO FORMONLY.ict01
            NEXT FIELD ict01
         END IF
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW q018_w_1
      RETURN
   END IF
 
   IF cl_sure(18,20) THEN
      LET l_flag = 'Y'
      BEGIN WORK
      DELETE FROM ict_file WHERE ict01 = l_tm.ict01 AND ict02 = l_tm.year+1
      FOR l_period = 1 TO 12
         LET l_ict04 = 0
         LET l_ict05 = 0
         LET l_ict06 = 0
         INSERT INTO ict_file(ict01,ict02,ict03) VALUES(l_tm.ict01,l_tm.year + 1,l_period)
         IF SQLCA.sqlcode THEN
            LET l_flag = 'N'
         END IF
         SELECT ict04 INTO l_ict04 FROM ict_file
          WHERE ict01=l_tm.ict01 AND ict02=l_tm.year AND ict03=l_period
         LET l_oea02 = s_getlastday(MDY(l_period ,'1',l_tm.year))
         SELECT SUM(oeb12*oeb05_fac) INTO l_ict05 FROM oea_file,oeb_file
          WHERE oea01=oeb01 AND oeaconf='Y' AND oeb04=l_tm.ict01
            AND oea02=l_oea02
         SELECT ict04+ict05 INTO l_ict06 FROM ict_file
          WHERE ict01=l_tm.ict01 AND ict02=l_tm.year AND ict03=l_period
         UPDATE ict_file SET ict04=l_ict04,ict05=l_ict05,ict06=l_ict06
          WHERE ict01=l_tm.ict01 AND ict02=l_tm.year+1 AND ict03=l_period
         IF SQLCA.sqlcode THEN
            LET l_flag = 'N'
         END IF
      END FOR
   END IF
   # 數據結轉
   IF l_flag = 'N' THEN
      CALL cl_err('','9050',1)
      ROLLBACK WORK
      CLOSE WINDOW q018_w_1
      RETURN
   ELSE
      COMMIT WORK
      LET g_upd_flag = 'Y'
      CALL cl_msgany(2,3,'aic-203')
   END IF
   CLOSE WINDOW q018_w_1
 
END FUNCTION
#No.FUN-7B0076
