# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: p_zy_r02.4gl
# Descriptions...: 權限類別允許執行功能表
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

   LET g_sql = "zw01.zw_file.zw01, zw02.zw_file.zw02, zy02.zy_file.zy02,",
               "gaz03.gaz_file.gaz03,",
               "zy04.zy_file.zy04, zy04n.gae_file.gae04,",
               "zy05.zy_file.zy05, zy05n.gae_file.gae04,",
               "zy07.zy_file.zy07, zy07n.gae_file.gae04,",
               "zy03.zy_file.zy03"

   LET l_table = cl_prt_temptable('p_zy_r02',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,? ,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL zy_r02_tm()
   ELSE
      CALL zy_r02()
   END IF
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION zy_r02_tm()
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000
   DEFINE li_result      LIKE type_file.num5
   #DEFINE l_gbl02        LIKE gbl_file.gbl02   #Action 代碼(程式Action比照功能記錄檔)

   LET p_row = 4 LET p_col = 15

   OPEN WINDOW zy_r02_w AT p_row,p_col WITH FORM "azz/42f/p_zy_r02"
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
      CONSTRUCT BY NAME tm.wc ON zw01,zy02
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
               WHEN INFIELD(zw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_zw"
                  LET g_qryparam.state ="c"
                  #LET g_qryparam.default1 = g_zy01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zw01
               WHEN INFIELD(zy02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zy02
            END CASE
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW zy_r02_w
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
         CLOSE WINDOW zy_r02_w
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='p_zy_r02'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('p_zy_r02','9031',1)
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
            CALL cl_cmdat('p_zy_r02',g_time,l_cmd)
         END IF
         CLOSE WINDOW zy_r02_w
         EXIT PROGRAM
      END IF
      #CALL cl_wait()
      CALL zy_r02()
      ERROR ""
   END WHILE
   CLOSE WINDOW zy_r02_w
END FUNCTION

FUNCTION zy_r02()
   DEFINE l_sql     STRING
   DEFINE sr        RECORD
          zw01   LIKE zw_file.zw01,    #權限代碼
          zw02   LIKE zw_file.zw02,    #權限說明
          zy02   LIKE zy_file.zy02,    #程式代碼
          gaz03  LIKE gaz_file.gaz03,  #程式名稱
          zy04   LIKE zy_file.zy04,    #對非用戶本身產出資料處理
          zy04n  LIKE gae_file.gae04,
          zy05   LIKE zy_file.zy05,    #對非與使用者同部門產出資料處理
          zy05n  LIKE gae_file.gae04,
          zy07   LIKE zy_file.zy07,    #程式單身處理權限
          zy07n  LIKE gae_file.gae04,
          zy03   LIKE zy_file.zy03     #Action 代碼
          END RECORD

   #清除暫存資料
   CALL cl_del_data(l_table)

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   LET l_sql = "SELECT zw01,zw02,zy02,gaz03,zy04,zy04n,zy05,zy05n,zy07,zy07n,zy03",
                  " FROM (",
                    " SELECT zw01,zw02,zy02,gaz03,",
                           " zy04,zy04 || ':' || zy04_n.zy04_name as zy04n,",
                           " zy05,zy05 || ':' || zy05_n.zy05_name as zy05n,",
                           " zy07,zy07 || ':' || zy07_n.zy07_name as zy07n,",
                           " zy03", 
                     " FROM (",
                        " SELECT zw01,zw02,zy02,gaz03,zy04,zy05,zy07,zy03",
                        " FROM zw_file,zy_file,gaz_file",
                        " WHERE zw01 = zy01 AND gaz01 = zy02 AND zwacti = 'Y' AND gaz02 = '",g_rlang,"'",
                     " )",
                     " LEFT JOIN (",
                       " SELECT gae02,gae04 as zy04_name",
                       " FROM gae_file",
                       " WHERE gae01='p_zy' AND gae03='",g_rlang,"'",
                     " ) zy04_n",
                     " ON zy04_n.gae02 = 'zy04_' || zy04",
                     " LEFT JOIN (",
                        " SELECT gae02,gae04 as zy05_name",
                        " FROM gae_file",
                        " WHERE gae01='p_zy' AND gae03='",g_rlang,"'",
                      " ) zy05_n",
                      " ON zy05_n.gae02 = 'zy05_' || zy05",
                      " LEFT JOIN (",
                         " SELECT gae02,gae04 as zy07_name",
                         " FROM gae_file",
                         " WHERE gae01='p_zy' AND gae03='",g_rlang,"'",
                      " ) zy07_n",
                      " ON zy07_n.gae02 = 'zy07_' || zy07",
                   " )",
                   " WHERE ", tm.wc CLIPPED
   PREPARE zy_r02_prepare1 FROM l_sql
   DISPLAY l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      EXIT PROGRAM
   END IF
   DECLARE zy_r02_curs1 CURSOR FOR zy_r02_prepare1

   FOREACH zy_r02_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
            
      LET sr.zy03 = cl_replace_str(sr.zy03, ASCII 9, "")   #TAB
      LET sr.zy03 = cl_replace_str(sr.zy03, "　", "")      #全形空白
      
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
   CALL cl_prt_cs3('p_zy_r02','p_zy_r02',l_sql,g_str)

END FUNCTION
