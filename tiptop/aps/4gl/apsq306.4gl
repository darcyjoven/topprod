# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: apsq306.4gl
# Descriptions...: APS 版本查詢
# Date & Author..: 08/05/28 By Duke #FUN-840209
# Modify.........: NO.FUN-870050 BY DUKE
# Modify.........: No:TQC-890023 BY DUKE 無資料時，開啟CP手調器，畫面會被關掉
# Modify.........: No:FUN-8B0086 By Duke 增加資料庫刪除按鈕,單身增加vzy10資料庫狀態
# Modify.........: No:TQC-910018 By Duke 加入每五秒鐘重整畫面
# Modify.........: NO.TQC-940088 09/04/17 BY destiny vzy12定義成DATETIME YEAR TO SECOND于數據庫中長度不符,在msv環境下執行時會報錯
# Modify.........: No.TQC-950078 09/05/13 By Duke 版本確認時間應show到時分秒
# Modify.........: NO.FUN-9B0065 09/11/10 By Mandy (1)J:刪除完成的資料庫不show
#                                                  (2)"APS資料刪除"會執行apsp701,需加傳參數
#                                                  (3)新增Action"TIPTOP資料庫補刪"
#                                                  (4)新增Action"查詢刪除資料"
# Modify.........: No.FUN-B50050 11/05/06 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: NO.FUN-BB0147 11/11/29 By Mandy 做Action "APS資料庫刪除"之前先判斷User需有apsp600/apsp701的權限

DATABASE ds

GLOBALS "../../config/top.global"   #FUN-840079

DEFINE   g_vzy06              LIKE vzy_file.vzy06,      #(假單頭)
         g_vzy06_t            LIKE vzy_file.vzy06,      #(假單頭)                 
         g_vzy              DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
            vzy01             LIKE vzy_file.vzy01,      #
            vzy02             LIKE vzy_file.vzy02,      #
            vzy03             LIKE vzy_file.vzy03,      #
            vzy10             LIKE vzy_file.vzy10,      #
            vzy04             LIKE vzy_file.vzy04,      #
            vzy05             LIKE vzy_file.vzy05,      #
            vzy08             LIKE vzy_file.vzy08,      #
            vzy09             LIKE vzy_file.vzy09,       #
           #vzy12             DATETIME YEAR TO SECOND   #FUN-840209        #No.TQC-940088    
           #vzy12             LIKE type_file.dat        #No.TQC-940088     #No.TQC-950078 MARK
            vzy12             LIKE type_file.chr20      #TQC-950078 ADD
                             END RECORD,
         g_vzy_t             RECORD                     #程式變數 (舊值)
            vzy01             LIKE vzy_file.vzy01,      #
            vzy02             LIKE vzy_file.vzy02,      #
            vzy03             LIKE vzy_file.vzy03,      #
            vzy10             LIKE vzy_file.vzy10,      #
            vzy04             LIKE vzy_file.vzy04,      #
            vzy05             LIKE vzy_file.vzy05,      #
            vzy08             LIKE vzy_file.vzy08,      #
            vzy09             LIKE vzy_file.vzy09,       #
           #vzy12             DATETIME YEAR TO SECOND                      #No.TQC-940088
           #vzy12             LIKE type_file.dat        #No.TQC-940088 ADD #TQC-950078 MARK
            vzy12             LIKE type_file.chr20      #TQC-950078 ADD
                             END RECORD,
         g_wc,g_sql          STRING,                   #No:FUN-580092 HCN
        #g_vzy_rowid         LIKE type_file.chr18,     #No.FUN-680135 INT # saki 20070821 rowid chr18 -> num10  #FUN-B50050 mark
         g_rec_b             LIKE type_file.num10,     #單身筆數      #No.FUN-680135 INTEGER
         l_ac                LIKE type_file.num5,      #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
         g_argv1             LIKE vzy_file.vzy01       #No.FUN-680135 VARCHAR(10)
DEFINE   g_chr             LIKE type_file.chr1      #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt             LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE   g_i               LIKE type_file.num5      #count/index for any purpose  #No.FUN-680135 SMALLINT
DEFINE   g_msg             LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql      STRING                   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_curs_index      LIKE type_file.num10     #No.FUN-680135 INTEGER
DEFINE   g_row_count       LIKE type_file.num10     #No:FUN-580092 HCN   #No.FUN-680135 INTEGER
DEFINE   g_jump            LIKE type_file.num10,    #No.FUN-680135 INTEGER
         g_no_ask          LIKE type_file.num5      #No.FUN-680135 SMALLINT
DEFINE   g_del_ver1        LIKE vzy_file.vzy01      #FUN-9B0065 add #執行"TIPTOP資料庫補刪"時的APS版本
DEFINE   g_del_ver2        LIKE vzy_file.vzy02      #FUN-9B0065 add #執行"TIPTOP資料庫補刪"時的APS儲存版本
DEFINE   g_del_vzy10       LIKE vzy_file.vzy10      #FUN-9B0065 add #執行"TIPTOP資料庫補刪"時的資料庫狀態

MAIN
   OPTIONS                                           #改變一些系統預設值
      INPUT NO WRAP                                  #輸入的方式: 不打轉
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理

  #LET g_argv1 = ARG_VAL(1)               #TQC-910018 MARK

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET g_argv1 = g_plant                  #TQC-910018 ADD
   LET g_vzy06 = NULL                     #清除鍵值
   LET g_vzy06_t = NULL

   OPEN WINDOW apsq306_w WITH FORM "aps/42f/apsq306"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN CALL s300_q() END IF

   CALL s300_menu()
   CLOSE WINDOW apsq306_w               #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION s300_curs()
DEFINE l_azp02 LIKE azp_file.azp02

   #TQC-910018  MARK  --STR--
   #每五分鐘重整單身資料
     #CLEAR FORM                             #清除畫面
     #CALL g_vzy.clear()
   #TQC-910018  MARK  --END--

   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "vzy06 = '",g_argv1,"'"
   ELSE

   #TQC-910018 ADD --STR--
   IF g_action_choice = 'idle' THEN
      LET g_wc = "vzy06 = '",g_vzy06,"'" 
   ELSE
      CLEAR FORM#清除畫面
      CALL g_vzy.clear()
   #TQC-910018 ADD  --END--

      CALL cl_set_head_visible("","YES")     

      CONSTRUCT g_wc ON vzy06,vzy01,vzy03,vzy04,vzy05,vzy08,vzy09
                   FROM vzy06,vzy01,vzy03,vzy04,vzy05,vzy08,vzy09

          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121

          ON ACTION CONTROLP
             CASE

              WHEN INFIELD(vzy06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_vzy06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO vzy06
                 NEXT FIELD vzy06

                WHEN INFIELD(vzy05)     #APS資料庫名稱
                   CALL cl_init_qry_var()
                   LET g_qryparam.state='c'
                   LET g_qryparam.form="q_vzt"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO vzy05
                   NEXT FIELD vzy05
              OTHERWISE
                 EXIT CASE
         END CASE 

      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
   END IF
   END IF

   LET g_sql= "SELECT UNIQUE vzy06 FROM vzy_file ",
              " WHERE ", g_wc  CLIPPED,
              "   AND vzy02 <> '0' ",
              " ORDER BY vzy06"
   DISPLAY g_sql
   PREPARE s300_prepare FROM g_sql      #預備一下
   DECLARE s300_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR s300_prepare

   DROP TABLE count_tmp
   LET g_sql="SELECT UNIQUE vzy06 ",
             "  FROM vzy_file     ",
             " WHERE ", g_wc CLIPPED,
             "   AND vzy02 <> '0'  ",
             " GROUP BY vzy06     ",
             " INTO TEMP count_tmp"
   PREPARE s300_cnt_tmp  FROM g_sql
   EXECUTE s300_cnt_tmp
   DECLARE s300_count CURSOR FOR SELECT COUNT(*) FROM count_tmp

END FUNCTION

FUNCTION s300_menu()

   WHILE TRUE
      CALL s300_bp("G")
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL s300_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_argv1 = NULL    #TQC-910018 ADD
               CALL s300_q()
            END IF

         WHEN "next"
            CALL s300_fetch('N')
         WHEN "previous"
            CALL s300_fetch('P')

         WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL s300_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN  "help"
            CALL cl_show_help()
         WHEN  "exit"
            EXIT WHILE
         WHEN  "jump"
            CALL s300_fetch('/')
         WHEN  "first"
            CALL s300_fetch('F')
         WHEN  "last"
            CALL s300_fetch('L')
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vzy),'','')
            END IF

        #WHEN "setting_parameter" #資料庫參數設定
        #  IF cl_chk_act_auth() THEN
        #     LET g_msg = "apsq303"
        #     CALL cl_cmdrun_wait(g_msg CLIPPED)
        #  END IF

        #WHEN "setting_parameter_1" #資料庫參數設定

         WHEN "aps_db_create" #APS資料庫建立

         WHEN "aps_db_delete" #APS資料庫刪除

         WHEN "APS_CP"    #APS手調器
            IF g_vzy[l_ac].vzy02<>' ' THEN
               LET g_msg = " apst603 '", g_vzy06,"' '", g_vzy[l_ac].vzy01,"' '",g_vzy[l_ac].vzy02,"'"
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
         #FUN-8B0086 ADD
         WHEN "aps_db_delete"   #資料庫刪除

         #FUN-9B0065--add---str--- 
         WHEN "del_erp_aps_data" # TIPTOP資料庫補刪
            IF cl_chk_act_auth() THEN
              IF g_del_vzy10 MATCHES "[DIK]" THEN
                 IF cl_confirm('abx-080') THEN #是否確定執行 (Y/N) ?
                     CALL q306_del_erp_aps_data()
                 END IF
              ELSE
                  CALL cl_err('','aps-517',1) #資料庫狀態需為"D"或"I"或"K"才可執行
              END IF
            END IF
         WHEN "qry_del_aps_data" #查詢刪除資料" 
            IF cl_chk_act_auth() THEN
                CALL q306_qry_del_aps_data()
            END IF
         #FUN-9B0065--add---end--- 

      END CASE
   END WHILE
END FUNCTION

FUNCTION s300_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_vzy.clear()

   CALL cl_opmsg('a')

   WHILE TRUE
      CALL s300_i("a")                            # 輸入單頭

      IF INT_FLAG THEN                            # 使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
                                                  
      CALL s300_b()                               # 輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION s300_i(p_cmd)                       # 處理INPUT

   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  #CHAR(1)
   DEFINE   l_count      LIKE type_file.num5    #SMALLINT

      CALL cl_set_head_visible("","YES")
      INPUT g_vzy06 WITHOUT DEFAULTS FROM vzy06

      AFTER FIELD vzy06
         DISPLAY "AFTER FIELD vzy06"
         IF g_vzy06 IS NOT NULL THEN
            IF p_cmd = "a" THEN                    
              #無此資料庫編號
               LET l_count=0
               SELECT count(*) INTO l_count 
                 FROM azp_file 
                WHERE azp01 = g_vzy06
               IF l_count = 0 THEN              
                  CALL cl_err(g_vzy06,'aps-008',1)
                  LET g_vzy06 = g_vzy06_t
                  DISPLAY BY NAME g_vzy06
                  NEXT FIELD vzy06
               END IF 

              #已存在此資料庫編號
               LET l_count=0
               SELECT count(*) INTO l_count 
                 FROM vzy_file 
                WHERE vzy06 = g_vzy06
               IF l_count <>0 THEN                
                  CALL cl_err(g_vzy06,'aps-009',1)
                  LET g_vzy06 = g_vzy06_t
                  DISPLAY BY NAME g_vzy06
                  NEXT FIELD vzy06
               END IF   

               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('vzy06:',g_errno,1)
                  LET g_vzy06 = g_vzy06_t
                  DISPLAY BY NAME g_vzy06
                  NEXT FIELD vzy06
               END IF
            END IF
         END IF


      ON ACTION CONTROLP
         CASE
              WHEN INFIELD(vzy06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azp"
                 LET g_qryparam.default1 = g_vzy06
                 CALL cl_create_qry() RETURNING g_vzy06
                 DISPLAY g_vzy06 TO vzy06
                 NEXT FIELD vzy06
         END CASE

      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

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
END FUNCTION

FUNCTION s300_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)

   MESSAGE ""
   CALL cl_opmsg('q')

   CALL s300_curs()                           #取得查詢條件

   IF INT_FLAG THEN                           #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN s300_count
    FETCH s300_count INTO g_row_count         #No:FUN-580092 HCN
    DISPLAY g_row_count TO FORMONLY.cnt       #No:FUN-580092 HCN

   OPEN s300_b_curs                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                      #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_vzy06 TO NULL
   ELSE
      CALL s300_fetch('F')                    #讀出TEMP第一筆並顯示
   END IF

END FUNCTION

FUNCTION s300_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,     #處理方式   #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10     #絕對的筆數 #No.FUN-680135 INTEGER

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     s300_b_curs INTO g_vzy06            
      WHEN 'P' FETCH PREVIOUS s300_b_curs INTO g_vzy06            
      WHEN 'F' FETCH FIRST    s300_b_curs INTO g_vzy06            
      WHEN 'L' FETCH LAST     s300_b_curs INTO g_vzy06            
      WHEN '/'
            IF (NOT g_no_ask) THEN
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
      FETCH ABSOLUTE g_jump s300_b_curs INTO g_vzy06
      LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_vzy06,SQLCA.sqlcode,0)
      INITIALIZE g_vzy06 TO NULL                 #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count       #No:FUN-580092 HCN
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count) #No:FUN-580092 HCN
      CALL s300_show()
   END IF

END FUNCTION

FUNCTION s300_show()
  
   LET g_vzy06_t = g_vzy06

   DISPLAY g_vzy06 TO vzy06
   CALL s300_vzy06('d')
 
   CALL s300_b_fill(g_wc)                   #單身

   CALL cl_show_fld_cont()               #No:FUN-550037 hmf
END FUNCTION

FUNCTION s300_b()
   DEFINE   l_ac_t           LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680135 SMALLINT 
            l_n              LIKE type_file.num5,                #檢查重複用         #No.FUN-680135 SMALLINT
            l_lock_sw        LIKE type_file.chr1,                #單身鎖住否         #No.FUN-680135 VARCHAR(1)
            p_cmd            LIKE type_file.chr1,                #處理狀態           #No.FUN-680135 VARCHAR(1)
            l_allow_insert   LIKE type_file.num5,                #可新增否           #No.FUN-680135 SMALLINT
            l_allow_delete   LIKE type_file.num5,                #可刪除否           #No.FUN-680135 SMALLINT
            ls_cnt           LIKE type_file.num5                 #No.FUN-680135      SMALLINT
   DEFINE   l_sql1           STRING  #FUN-B50050 add


   DEFINE l_azp03 LIKE azp_file.azp03

   LET g_action_choice = ""

  #IF g_vzy06 IS NULL AND g_vzy07 IS NULL THEN
   IF g_vzy06 IS NULL THEN
      RETURN
   END IF
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   CALL cl_opmsg('b')

  #FUN-B50050---mod----str-----
  #LET g_forupd_sql =
  #                 #"SELECT vzy01,vzy02,vzy03,vzy10,vzy04,vzy05,vzy08,vzy09,vzy12 ",  #TQC-950078 MARK
  #                  "SELECT vzy01,vzy02,vzy03,vzy10,vzy04,vzy05,vzy08,vzy09, ", #TQC-950078 ADD
  #                  " TO_CHAR(vzy12,'yyyy/mm/dd hh24:MI:SS') vzy12 ",           #TQC-950078 ADD 
   LET l_sql1 = cl_tp_tochar('vzy12','yyyy/mm/dd HH24:MI:SS')
   LET g_forupd_sql =
                     "SELECT vzy01,vzy02,vzy03,vzy10,vzy04,vzy05,vzy08,vzy09, ",l_sql1 CLIPPED," vzy12 ",
  #FUN-B50050---mod----end-----
                     "  FROM vzy_file    ",
                     " WHERE vzy01=? ",
                     "   AND vzy02=? ",
                  #   "   AND vzy06=? ",
                    #" FOR UPDATE NOWAIT " #FUN-B50050 mark
                     " FOR UPDATE "        #FUN-B50050 add

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50050 add
   DECLARE s300_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_vzy WITHOUT DEFAULTS FROM s_vzy.*
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

         BEGIN WORK

         IF g_rec_b >= l_ac THEN
            LET g_vzy_t.* = g_vzy[l_ac].*  #BACKUP
            LET p_cmd='u'
            OPEN s300_b_curl USING g_vzy[l_ac].vzy01,g_vzy[l_ac].vzy02
            #,g_vzy06 #,g_vzy07  
            IF STATUS THEN
               CALL cl_err("OPEN s300_b_cur1:",STATUS,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH s300_b_curl INTO g_vzy[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_vzy_t.vzy01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()                    #FUN-550037(smin)
         END IF
         #CALL s300_set_entry_b()
         CALL s300_set_no_entry_b()

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_vzy[l_ac].* TO NULL      #900423
         LET g_vzy[l_ac].vzy02='0'
         LET g_vzy[l_ac].vzy10='N'
         LET g_vzy_t.* = g_vzy[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD vzy01

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         SELECT azp03 INTO l_azp03 FROM azp_file where azp01=g_vzy06

         INSERT INTO vzy_file(vzy00,vzy01,vzy02,vzy03,vzy10,vzy04,
                              vzy05,vzy08,vzy09,vzy06,vzy07)
              VALUES(g_vzy06,g_vzy[l_ac].vzy01,g_vzy[l_ac].vzy02,g_vzy[l_ac].vzy03,
                     g_vzy[l_ac].vzy10,g_vzy[l_ac].vzy04,g_vzy[l_ac].vzy05,
                     g_vzy[l_ac].vzy08,g_vzy[l_ac].vzy09,g_vzy06,g_vzy06)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","vzy_file",g_vzy06,g_vzy[l_ac].vzy01,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            COMMIT WORK
         END IF

      AFTER FIELD vzy01              
         IF NOT cl_null(g_vzy[l_ac].vzy01) THEN
            IF g_vzy[l_ac].vzy01 != g_vzy_t.vzy01
               OR g_vzy_t.vzy01 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM vzy_file
                WHERE vzy01 = g_vzy[l_ac].vzy01 
                  AND vzy02 = g_vzy[l_ac].vzy02
               IF l_n>0 THEN 
                  CALL cl_err('',-239,0)
                  LET g_vzy[l_ac].vzy01 = g_vzy_t.vzy01
                  NEXT FIELD vzy01
               END IF
            END IF
         END IF

      AFTER FIELD vzy05
         DISPLAY "AFTER FIELD vzy05"
         IF g_vzy[l_ac].vzy05 IS NOT NULL THEN
            IF p_cmd = "a" THEN                    
               SELECT count(*) INTO l_n 
                 FROM vzt_file 
                WHERE vzt01 = g_vzy[l_ac].vzy05
                  AND vzt06 = '2' 
               IF l_n = 0 THEN                     #無此資料庫編號
                  CALL cl_err(g_vzy[l_ac].vzy05,'aps-008',1)
                  LET g_vzy[l_ac].vzy05 = g_vzy_t.vzy05
                  DISPLAY BY NAME g_vzy[l_ac].vzy05
                  NEXT FIELD vzy05
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('vzy05:',g_errno,1)
                  LET g_vzy[l_ac].vzy05 = g_vzy_t.vzy05
                  DISPLAY BY NAME g_vzy[l_ac].vzy05
                  NEXT FIELD vzy05
               END IF
            END IF
         END IF

       BEFORE DELETE                            #是否取消單身
           IF NOT cl_null(g_vzy_t.vzy01) THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM vzy_file
                WHERE vzy01 = g_vzy_t.vzy01
                  AND vzy02 = g_vzy_t.vzy02
                  AND vzy06 = g_vzy06
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","vzy_file",g_vzy_t.vzy01,g_vzy_t.vzy02,SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete OK"
               CLOSE s300_b_curl
               COMMIT WORK
           END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_vzy[l_ac].* = g_vzy_t.*
            CLOSE s300_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_vzy[l_ac].vzy01,-263,1)
            LET g_vzy[l_ac].* = g_vzy_t.*
         ELSE
            UPDATE vzy_file 
               SET vzy01=g_vzy[l_ac].vzy01,
                   vzy02=g_vzy[l_ac].vzy02,
                   vzy03=g_vzy[l_ac].vzy03,
                   vzy10=g_vzy[l_ac].vzy10,
                   vzy04=g_vzy[l_ac].vzy04,
                   vzy05=g_vzy[l_ac].vzy05,
                   vzy08=g_vzy[l_ac].vzy08,
                   vzy09=g_vzy[l_ac].vzy09
             WHERE vzy06=g_vzy06
               AND vzy01=g_vzy_t.vzy01
               AND vzy02=g_vzy_t.vzy02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","vzy_file",g_vzy06,g_vzy_t.vzy01,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_vzy[l_ac].* = g_vzy_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_vzy[l_ac].* = g_vzy_t.*
            END IF
            CLOSE s300_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE s300_b_curl
         COMMIT WORK

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(vzy06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_vzy06
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO vzy06
               NEXT FIELD vzy06

            WHEN INFIELD(vzy05)     #APS資料庫名稱
               CALL cl_init_qry_var()
               LET g_qryparam.form="q_vzt"
               LET g_qryparam.default1=g_vzy[l_ac].vzy05
               CALL cl_create_qry() RETURNING g_vzy[l_ac].vzy05
               DISPLAY g_qryparam.multiret TO g_vzy[l_ac].vzy05
               NEXT FIELD vzy05
         END CASE 

      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","YES")                                                                                        


     #ON ACTION setting_parameter_1  #資料庫參數設定 
     #   LET g_action_choice="setting_parameter_1"
     #   IF cl_chk_act_auth() THEN
     #      LET g_msg = "apsq303"
     #      CALL cl_cmdrun_wait(g_msg CLIPPED)
     #   END IF
     #   EXIT INPUT 

   END INPUT

   CLOSE s300_b_curl
   COMMIT WORK
 
END FUNCTION

FUNCTION s300_b_fill(g_wc)              #BODY FILL UP
DEFINE g_wc     STRING
DEFINE l_sql1   STRING  #FUN-B50050 add

#FUN-B50050---mod---str----
##LET g_sql = "SELECT vzy01,vzy02,vzy03,vzy10,vzy04,vzy05,vzy08,vzy09,vzy12 ", #TQC-950078 MARK
# LET g_sql = "SELECT vzy01,vzy02,vzy03,vzy10,vzy04,vzy05,vzy08,vzy09, ", #TQC-950078 ADD
#             "  TO_CHAR(vzy12,'yyyy/mm/dd hh24:MI:SS') vzy12 ",          #TQC-950078 ADD
  LET l_sql1 = cl_tp_tochar('vzy12','yyyy/mm/dd HH24:MI:SS')
  LET g_sql = "SELECT vzy01,vzy02,vzy03,vzy10,vzy04,vzy05,vzy08,vzy09, ",l_sql1 CLIPPED," vzy12 ",
#FUN-B50050---mod---end----
              "  FROM vzy_file        ",
              " WHERE vzy06='",g_vzy06,"'  ",
              "   AND vzy07='",g_vzy06,"'  ",
              "   AND vzy02 <> '0'  ",
              "   AND ",g_wc CLIPPED,
              "   AND (vzy10 <> 'J' OR vzy10 IS NULL) " #FUN-9B0065 #J:TIPTOP刪除完成的資料庫不show
 
   PREPARE vzy_pre FROM g_sql
   DECLARE vzy_curs CURSOR FOR vzy_pre

   CALL g_vzy.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH vzy_curs INTO g_vzy[g_cnt].*   #單身 ARRAY 填充

      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET g_rec_b = g_rec_b + 1 

      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_vzy.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION s300_bp(p_ud)
   DEFINE   l_sts   LIKE type_file.chr1  #FUN-BB0147 add
   DEFINE   p_ud    LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
   DEFINE   l_vzt01 LIKE vzt_file.vzt01,
            l_vzt02 LIKE vzt_file.vzt02,
            l_vzt03 LIKE vzt_file.vzt03,
            l_vzt04 LIKE vzt_file.vzt04
   DEFINE   l_ze03  LIKE ze_file.ze03    #FUN-8B0006 ADD
   DEFINE   l_vlh03 LIKE vlh_file.vlh03  #FUN-8B0086 ADD


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_vzy TO s_vzy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
          CALL cl_navigator_setting(g_curs_index,g_row_count) #No:FUN-580092 HCN
          #CALL cl_set_comp_visible("vzy03,vzy10,vzy04,vzy05,vzy08,vzy04,vzy09",FALSE)   #FUN-8B0086 MARK
          CALL cl_set_comp_visible("vzy03,vzy04,vzy05,vzy08,vzy04,vzy09",FALSE)    #FUN-8B0086 ADD
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      #ON ACTION insert                           # A.輸入
      #   LET g_action_choice="insert"
      #   EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION first
         CALL s300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No:FUN-580092 HCN
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL s300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No:FUN-580092 HCN
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL s300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No:FUN-580092 HCN
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION last
         CALL s300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No:FUN-580092 HCN
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION next
         CALL s300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517 #No:FUN-580092 HCN
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   LET l_ac = ARR_CURR()
      #   EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      #TQC-910018 MARK  --STR-- 
      #ON IDLE g_idle_seconds
      #   CALL cl_on_idle()
      #   CONTINUE DISPLAY
      #TQC-910018 MARK  --END--
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0049
        LET g_action_choice = 'exporttoexcel'
        EXIT DISPLAY

     #ON ACTION setting_parameter  #資料庫參數設定 
     #   LET g_action_choice="setting_parameter"
     #   EXIT DISPLAY 

      ON ACTION APS_CP
         #TQC-890023
         IF cl_null(g_rec_b) or g_rec_b= 0   THEN 
            LET g_action_choice = ''
            CALL cl_err('','ain-070',0)
         ELSE LET g_action_choice="APS_CP"
         END IF
         EXIT DISPLAY

     #TQC-910018 ADD   --STR--
     ON IDLE 5
        LET g_action_choice = 'idle'
        CALL s300_q()
        EXIT DISPLAY
     #TQC-910018 ADD   --END--


     #FUN-8B0086  ADD  資料庫刪除  ------------------
      ON ACTION aps_db_delete 
        LET g_action_choice="aps_db_delete"
        #FUN-BB0147---add-----str----
        LET g_prog = 'apsp600'
        IF (NOT cl_set_priv()) THEN
             CALL cl_err('apsp600 err:','aps-303',1)#使用者需有程式apsp600和apsp701的執行權限,才能執行APS資料庫刪除
             LET g_prog = 'apsq306' #讓權限資料正確設在apsq306
             CALL cl_set_priv() RETURNING l_sts
             EXIT DISPLAY
        END IF
        LET g_prog = 'apsp701'
        IF (NOT cl_set_priv()) THEN
             #使用者需有程式apsp600和apsp701的執行權限,才能執行APS資料庫刪除
             CALL cl_err('apsp701 err:','aps-303',1)
             LET g_prog = 'apsq306' #讓權限資料正確設在apsq306
             CALL cl_set_priv() RETURNING l_sts
             EXIT DISPLAY
        END IF
        LET g_prog = 'apsq306' #讓權限資料正確設在apsq306
        CALL cl_set_priv() RETURNING l_sts
        #FUN-BB0147---add-----end----
        IF g_vzy[l_ac].vzy02!=' ' AND
           g_vzy[l_ac].vzy02!='0' THEN
           SELECT vlh03 INTO l_vlh03 FROM vlh_file  #版本運作中不得刪除
             WHERE vlh01=g_vzy06
               AND vlh03=g_vzy[l_ac].vzy01
               AND vlh04=g_vzy[l_ac].vzy02
           IF NOT cl_null(l_vlh03) THEN
              CALL cl_err('','aps-514',1)
           ELSE
             #IF (g_vzy[l_ac].vzy10='Y') or (g_vzy[l_ac].vzy10='L') OR             #FUN-9B0065 mark
             #   (cl_null(g_vzy[l_ac].vzy10='Y')) or (g_vzy[l_ac].vzy10=' ') THEN  #FUN-9B0065 mark
              IF g_vzy[l_ac].vzy10 MATCHES "[YLE]" OR                              #FUN-9B0065 add Y:建立完成 E:APS刪除中 L:APS刪除失敗
                 cl_null(g_vzy[l_ac].vzy10) THEN                                   #FUN-9B0065 add 
                IF cl_confirm('aps-012') THEN
  
                  #FUN-8B0086 ADD--------------
                   UPDATE vzy_file SET vzy10='E'
                    WHERE vzy00=g_plant
                      AND vzy01=g_vzy[l_ac].vzy01
                      AND vzy02=g_vzy[l_ac].vzy02
                      LET g_vzy[l_ac].vzy10='E'
                    DISPLAY BY NAME g_vzy[l_ac].vzy10
                  #FUN-8B0086 -----------------
  
                  LET g_msg = "apsp600 'delete_db' '", g_vzy06 CLIPPED,"' '",
                               g_vzy[l_ac].vzy01 CLIPPED ,"' '",
                               g_vzy[l_ac].vzy02 CLIPPED ,"' '",
                               g_user CLIPPED,"' "
                  CALL cl_cmdrun_wait(g_msg CLIPPED)
                  CALL cl_getmsg('aps-513',g_lang) RETURNING l_ze03
  
                  INSERT INTO vzv_file(vzv00,vzv01,vzv02,vzv04,
                       vzv05,vzv06,vzv07,vzv08,vzvplant,vzvlegal) #FUN-B50050 add vzvplant,vzvlegal
                  VALUES(g_plant,g_vzy[l_ac].vzy01,g_vzy[l_ac].vzy02,'90',
                       l_ze03,'R','Y',g_user,g_plant,g_legal) #FUN-B50050 add vzvplant,vzvlegal
                  IF STATUS THEN
                     CALL cl_err3("ins","vzv_file",g_vzy[l_ac].vzy01,g_vzy[l_ac].vzy02,STATUS,"","",1)
                  END IF
                 #LET g_msg = "apsp701 "                                                  #FUN-9B0065 mark
                  LET g_msg = "apsp701 '",g_vzy[l_ac].vzy01,"' '",g_vzy[l_ac].vzy02,"'"   #FUN-9B0065 add
                  CALL cl_cmdrun(g_msg CLIPPED)
                END IF
              ELSE 
                IF (g_vzy[l_ac].vzy10='D') THEN
                   CALL cl_err('','aps-732',1)
                ELSE
                   CALL cl_err('','aps-014',1)
                END IF
              END IF
           END IF
         END IF
         EXIT DISPLAY
        #FUN-8B0086  --------------------------------------------------------

      #FUN-9B0065--add---str---
      ON ACTION del_erp_aps_data
        LET g_action_choice = 'del_erp_aps_data'
        LET g_del_ver1  = g_vzy[l_ac].vzy01
        LET g_del_ver2  = g_vzy[l_ac].vzy02
        LET g_del_vzy10 = g_vzy[l_ac].vzy10
        EXIT DISPLAY
      ON ACTION qry_del_aps_data
        LET g_action_choice = 'qry_del_aps_data'
        EXIT DISPLAY
      #FUN-9B0065--add---end---

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION s300_set_entry_b()

   CALL cl_set_comp_entry("vzy01,vzy03,vzy04,vzy05,vzy08,vzy09",TRUE)

END FUNCTION
FUNCTION s300_set_no_entry_b()

    IF g_vzy[l_ac].vzy10 != 'N' THEN 
       CALL cl_set_comp_entry("vzy01,vzy03,vzy04,vzy05,vzy08,vzy09",FALSE)
    END IF

END FUNCTION

FUNCTION s300_vzy06(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_azp02    LIKE azp_file.azp02

   LET g_errno=''
   SELECT azp02 
     INTO l_azp02
     FROM azp_file
    WHERE azp01=g_vzy06

   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_azp02 TO FORMONLY.azp02
   END IF
END FUNCTION

#FUN-9B0065--add---str---
FUNCTION q306_qry_del_aps_data()
   DEFINE g_show_msg    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                          vzy01       LIKE vzy_file.vzy01,
                          vzy02       LIKE vzy_file.vzy02,
                          vzy12       LIKE type_file.chr100
                        END RECORD
   DEFINE g_gaq03_f1  LIKE gaq_file.gaq03
   DEFINE g_gaq03_f2  LIKE gaq_file.gaq03
   DEFINE g_gaq03_f3  LIKE gaq_file.gaq03
   DEFINE g_msg       LIKE type_file.chr1000 
   DEFINE g_msg2      LIKE type_file.chr1000 
   DEFINE l_sql1      STRING  #FUN-B50050 add
 
         #FUN-B50050------mod--------str-----
         #LET g_sql= "SELECT vzy01,vzy02,",
         #           "       TO_CHAR(vzy12,'yyyy/mm/dd hh24:MI:SS') vzy12 ",
          LET l_sql1 = cl_tp_tochar('vzy12','yyyy/mm/dd HH24:MI:SS')
          LET g_sql= "SELECT vzy01,vzy02,",l_sql1 CLIPPED," vzy12 ",
         #FUN-B50050------mod--------end-----
                     "  FROM vzy_file ",
                     " WHERE vzy00 = '",g_vzy06,"'",
                     "   AND vzy10 = 'J' ", #J:TIPTOP刪除完成
                     "   AND vzy02 <> '0' "
          
          DECLARE s300_qry_del_aps_data_c CURSOR FROM g_sql
          OPEN s300_qry_del_aps_data_c
          LET g_i = 1
          FOREACH s300_qry_del_aps_data_c INTO g_show_msg[g_i].vzy01,g_show_msg[g_i].vzy02, g_show_msg[g_i].vzy12 
             LET g_i = g_i + 1
          END FOREACH
          CALL g_show_msg.deleteElement(g_i)

          LET g_msg = NULL
          LET g_msg2= NULL
          LET g_gaq03_f1 = NULL
          LET g_gaq03_f2 = NULL
          LET g_gaq03_f3 = NULL
          CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
          CALL cl_get_feldname('vzy01',g_lang) RETURNING g_gaq03_f1
          CALL cl_get_feldname('vzy02',g_lang) RETURNING g_gaq03_f2
          CALL cl_get_feldname('vzy12',g_lang) RETURNING g_gaq03_f3
          LET g_msg2 = g_gaq03_f1 CLIPPED,'|',
                       g_gaq03_f2 CLIPPED,'|',
                       g_gaq03_f3 CLIPPED
          CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg,g_msg2)

END FUNCTION

FUNCTION q306_del_erp_aps_data()
   CALL s_del_aps_data(g_vzy06,g_del_ver1,g_del_ver2)
END FUNCTION
#FUN-9B0065--add---end---
