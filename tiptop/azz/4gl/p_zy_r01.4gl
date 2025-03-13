# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: p_zy_r01.4gl
# Descriptions...: 程式基本執行權限表
# Date & Author..: No.FUN-A80004 11/01/13 By tsai_yen
# Modify.........:

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm      RECORD
       wc      STRING,
       s       LIKE type_file.chr3,
       t       LIKE type_file.chr3,
       more    LIKE type_file.chr1
       END RECORD
DEFINE tm02    RECORD
       s1,s2   LIKE type_file.chr20,
       t1,t2   LIKE type_file.chr1
       END RECORD

DEFINE g_cnt       LIKE type_file.num10
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING

MAIN
   OPTIONS                                    #改變一些系統預設值
       FORM LINE       FIRST + 2,             #畫面開始的位置
       MESSAGE LINE    LAST,                  #訊息顯示的位置
       PROMPT LINE     LAST,                  #提示訊息的位置
       INPUT NO WRAP                          #輸入的方式: 不打轉
   DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理

   #FUN-A80004
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_rep_user = ARG_VAL(7)
   LET g_rep_clas = ARG_VAL(8)
   LET g_template = ARG_VAL(9)
   LET g_rpt_name = ARG_VAL(10)
   LET tm.wc = ARG_VAL(11)
   LET tm.s  = ARG_VAL(12)
   LET tm.t  = ARG_VAL(13)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_sql = "gaz01.gaz_file.gaz01,     gaz03.gaz_file.gaz03,",
               "gaz05.gaz_file.gaz05,     gap02.gap_file.gap02,",
               "gbd04_std.gbd_file.gbd04, gbd04_prog.gbd_file.gbd04"

   LET l_table = cl_prt_temptable('p_zy_r01',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL zy_r01_tm()
   ELSE
      CALL zy_r01()
   END IF
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION zy_r01_tm()
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE li_result      LIKE type_file.num5
   #DEFINE l_gbl02        LIKE gbl_file.gbl02   #Action 代碼(程式Action比照功能記錄檔)

   LET p_row = 4 LET p_col = 15

   OPEN WINDOW zy_r01_w AT p_row,p_col WITH FORM "azz/42f/p_zy_r01"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   INITIALIZE tm.* TO NULL

   #LET tm.s    = '23 '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #default 排序,跳頁
   LET tm02.s1   = tm.s[1,1]
   LET tm02.s2   = tm.s[2,2]
   LET tm02.t1   = tm.t[1,1]
   LET tm02.t2   = tm.t[2,2]
   IF cl_null(tm02.s1) THEN LET tm02.s1 = ""  END IF
   IF cl_null(tm02.s2) THEN LET tm02.s2 = ""  END IF
   IF cl_null(tm02.t1) THEN LET tm02.t1 = "N" END IF
   IF cl_null(tm02.t2) THEN LET tm02.t2 = "N" END IF
   
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON gaz01,gap02
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT CONSTRUCT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION help
            CALL cl_show_help()

         ON ACTION about
            CALL cl_about()

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(gaz01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz"
                  LET g_qryparam.state = "c"
                  #LET g_qryparam.default1= g_zz.zz01
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gaz01
                  NEXT FIELD gaz01
               WHEN INFIELD(gap02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gap02"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gap02
                  NEXT FIELD gap02
            END CASE
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW zy_r01_w
         EXIT PROGRAM
      END IF

      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      INPUT BY NAME tm02.s1,tm02.s2,
                    tm02.t1,tm02.t2,
                    tm.more
                    WITHOUT DEFAULTS
         BEFORE INPUT
            LET tm02.s1 = 1
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         AFTER INPUT
            LET tm.s = tm02.s1[1,1],tm02.s2[1,1]
            LET tm.t = tm02.t1,tm02.t2

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION help
            CALL cl_show_help()

         ON ACTION about
            CALL cl_about()

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW zy_r01_w
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='p_zy_r01'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('p_zy_r01','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_rlang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",
                            " '",g_rep_clas CLIPPED,"'",
                            " '",g_template CLIPPED,"'",
                            " '",g_rpt_name CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'"
            CALL cl_cmdat('p_zy_r01',g_time,l_cmd)
         END IF
         CLOSE WINDOW zy_r01_w
         EXIT PROGRAM
      END IF
      #CALL cl_wait()
      CALL zy_r01()
      ERROR ""
   END WHILE
   CLOSE WINDOW zy_r01_w
END FUNCTION

FUNCTION zy_r01()
   DEFINE l_sql     STRING
   DEFINE sr        RECORD
          gaz01      LIKE gaz_file.gaz01,  #程式代碼
          gaz03      LIKE gaz_file.gaz03,  #程式名稱
          gaz05      LIKE gaz_file.gaz05,  #客製碼
          gap02      LIKE gap_file.gap02,  #Action 代碼
          gbd04_std  LIKE gbd_file.gbd04,  #Action共用名稱
          gbd04_prog LIKE gbd_file.gbd04   #Action本程式自定名稱
          END RECORD

   #清除暫存資料
   CALL cl_del_data(l_table)

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   LET l_sql = " SELECT gaz01,gaz03,gaz05,gap02,",
               "        gad_std.gbd04 as gbd04_std,gad_prog.gbd04 as gbd04_prog",
               " FROM ",
               " (SELECT gaz01,gaz02,gaz03,gaz05 FROM gaz_file,zz_file",
               "    WHERE zz01 = gaz01 AND zz011 <> 'MENU'",
               "      AND gaz02 = '",g_rlang,"'",
               " ) gaz_file",
               " LEFT JOIN",
               " (SELECT gap01,gap02 FROM gap_file",
               " ) gap_file",
               " ON gaz01 = gap01",
               " LEFT JOIN",
               " (SELECT gbd01,gbd02,gbd03,gbd04,gbd05 FROM gbd_file",
               "    WHERE gbd02 = 'standard' AND gbd03 = '",g_rlang,"' AND gbd07='N'",
               " ) gad_std",
               " ON gap02 = gad_std.gbd01",
               " LEFT JOIN",
               " (SELECT gbd01,gbd02,gbd03,gbd04,gbd05 FROM gbd_file",
               "    WHERE gbd03 = '",g_rlang,"' AND gbd07='N'",
               " ) gad_prog",
               " ON gap02 = gad_prog.gbd01 AND gap01 = gad_prog.gbd02",
               " WHERE ", tm.wc CLIPPED
   PREPARE zy_r01_prepare1 FROM l_sql
   DISPLAY l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      EXIT PROGRAM
   END IF
   DECLARE zy_r01_curs1 CURSOR FOR zy_r01_prepare1

   FOREACH zy_r01_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF

      #寫入暫存檔
      EXECUTE insert_prep USING sr.*
   END FOREACH

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #欲傳到CR做排序、跳頁、小計控制的參數
   LET g_str = tm.s[1,1],";",tm.s[2,2],";",   #排序
               tm.t[1,1],";",tm.t[2,2]        #跳頁
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'gaz01,gap02')
           RETURNING tm.wc
      LET g_str = g_str ,";",tm.wc
   END IF
   CALL cl_prt_cs3('p_zy_r01','p_zy_r01',l_sql,g_str)

END FUNCTION
