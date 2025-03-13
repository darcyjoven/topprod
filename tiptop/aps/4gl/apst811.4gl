# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: apst811.4gl
# Descriptions...: APS 請購建議調整維護作業
# Date & Author..: 09/05/04 By Duke #FUN-940089
# Modify.........: No:FUN-A10137 10/01/26 By Mandy D:不可調整的pmk25的判斷改成 pmk25 in('2','6','9','S')
# Modify.........: No:FUN-A30082 10/03/24 By Lilan 來源項次要改show vob03,但此欄位值為"PR5-690001-0001",需拆解抓出項次來 
# Modify.........: No:FUN-B50020 11/05/09 By Lilan APS GP5.1追版至GP5.25
# Modify.........: No:FUN-B60047 11/06/08 By Mandy (1)功能"整批請購調整","自動作廢"
#                                                     資料的來源應直接用查詢出單身的SQL(_b_fill),不要重新抓取,避免取得的資料不一致
# Modify.........: No:FUN-BB0020 11/11/03 By Mandy 增加"結案自動調整"功能
# Modify.........: No:FUN-BB0025 11/11/08 By Mandy 增加"整批產生變更單"功能


DATABASE ds

GLOBALS "../../config/top.global"

#FUN-940089

#模組變數(Module Variables)
DEFINE   g_vob01              LIKE vob_file.vob01,      #APS版本  (假單頭)
         g_vob02              LIKE vob_file.vob02,      #儲存版本 (假單頭)
         g_vob03              LIKE vob_file.vob03,      #
         g_vob01_t            LIKE vob_file.vob01,      #APS版本  (假單頭)
         g_vob02_t            LIKE vob_file.vob02,      #儲存版本 (假單頭)
         g_vob              DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
            vob36             LIKE vob_file.vob36,      #
            status            LIKE type_file.chr1,      #
            vob13             LIKE vob_file.vob13,      #
            pml16             LIKE pml_file.pml16,      #
            pmk12             LIKE pmk_file.pmk12,      #請採購人員
            pmk09             LIKE pmk_file.pmk09,      #廠商
           #vaz23             LIKE vaz_file.vaz23,      #FUN-A30082 mark
            itemno            LIKE type_file.num5,      #FUN-A30082 add
            vob07             LIKE vob_file.vob07,      #
            ima02             LIKE ima_file.ima02,      #
            vob11             LIKE vob_file.vob11,      #
            ischange          LIKE vob_file.vob36,      #來源已異動
            pml20             LIKE pml_file.pml20,      #
            unst_qty          LIKE pml_file.pml20,      #
            vob33             LIKE vob_file.vob33,      #
            qty               LIKE pml_file.pml20,      #
            pml34             LIKE pml_file.pml34,      #
            vob14             LIKE vob_file.vob14,      # 
            pml35             LIKE pml_file.pml35,      #
            vob40             LIKE vob_file.vob40,      #
            vob17             LIKE vob_file.vob17,
            vob42             LIKE vob_file.vob42,
            vob08             LIKE vob_file.vob08,
            vob20             LIKE vob_file.vob20,
            vob04             LIKE vob_file.vob04,
            vob03             LIKE vob_file.vob03
                             END RECORD,
         g_vob_t             RECORD                     #程式變數 (舊值)
            vob36             LIKE vob_file.vob36,      #
            status            LIKE type_file.chr1,      #
            vob13             LIKE vob_file.vob13,      #
            pml16             LIKE pml_file.pml16,      #
            pmk12             LIKE pmk_file.pmk12,      #
            pmk09             LIKE pmk_file.pmk09,      #
           #vaz23             LIKE vaz_file.vaz23,      #FUN-A30081 mark
            itemno            LIKE type_file.num5,      #FUN-A30081 add
            vob07             LIKE vob_file.vob07,      #
            ima02             LIKE ima_file.ima02,      #
            vob11             LIKE vob_file.vob11,      #
            ischange          LIKE vob_file.vob36,      #來源已異動
            pml20             LIKE pml_file.pml20,      #
            unst_qty          LIKE pml_file.pml20,      #
            vob33             LIKE vob_file.vob33,      #
            qty               LIKE pml_file.pml20,      #
            pml34             LIKE pml_file.pml34,      #
            vob14             LIKE vob_file.vob14, 
            pml35             LIKE pml_file.pml35,      #
            vob40             LIKE vob_file.vob40,
            vob17             LIKE vob_file.vob17,      #
            vob42             LIKE vob_file.vob42,
            vob08             LIKE vob_file.vob08,
            vob20             LIKE vob_file.vob20,
            vob04             LIKE vob_file.vob04,
            vob03             LIKE vob_file.vob03
                             END RECORD,

         tm  RECORD  
             wc      LIKE type_file.chr1000,
             wc2     LIKE type_file.chr1000,
             hstatus LIKE type_file.chr1,
             pne05   LIKE pne_file.pne05 #FUN-BB0025 add
             END RECORD,

         g_sql          STRING,
        #g_vob_rowid         LIKE type_file.chr18,
         g_rec_b             LIKE type_file.num10,     #單身筆數
         l_ac                LIKE type_file.num5,      #目前處理的ARRAY CNT
         g_argv1             LIKE vob_file.vob01,
         g_argv2             LIKE vob_file.vob02      

DEFINE   g_vob04_check       LIKE type_file.num5,      #檢查對上parent的關係
         redo_m_check        LIKE type_file.num5       #程式離開時是否要產生有更改的menu

#主程式開始
DEFINE   g_chr              LIKE type_file.chr1
DEFINE   g_cnt              LIKE type_file.num10
DEFINE   g_i                LIKE type_file.num5      #count/index for any purpose
DEFINE   g_msg              LIKE type_file.chr1000
DEFINE   g_forupd_sql       STRING                   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   mi_curs_index      LIKE type_file.num10
DEFINE   lc_qbe_sn          LIKE gbm_file.gbm01      
DEFINE   g_row_count        LIKE type_file.num10
DEFINE   mi_jump            LIKE type_file.num10,
         mi_no_ask          LIKE type_file.num5
DEFINE   g_change_lang      LIKE type_file.chr1
#FUN-BB0025--add---str---
DEFINE g_show_msg      DYNAMIC ARRAY OF RECORD
       fld01           LIKE  type_file.chr100,
       fld02           LIKE  type_file.chr100,
       fld03           LIKE  type_file.chr100,
       fld04           LIKE  type_file.chr100
                       END RECORD
DEFINE g_fld01         LIKE  gaq_file.gaq03
DEFINE g_fld02         LIKE  gaq_file.gaq03
DEFINE g_fld03         LIKE  gaq_file.gaq03
DEFINE g_fld04         LIKE  gaq_file.gaq03
DEFINE g_err_cnt       LIKE  type_file.num5   
DEFINE g_status1       LIKE  ze_file.ze03
DEFINE g_status2       LIKE  ze_file.ze03
DEFINE g_msg2          LIKE  ze_file.ze03 
DEFINE g_pne04         LIKE pne_file.pne04 #變更理由碼     
#FUN-BB0025--add---end---

MAIN
   DEFINE   p_row,p_col     LIKE type_file.num5

   OPTIONS                                           #改變一些系統預設值
      INPUT NO WRAP                                  #輸入的方式: 不打轉
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
         RETURNING g_time
   LET g_argv1 = ARG_VAL(1)
   LET g_vob01 = NULL                     #清除鍵值
   LET g_vob02 = NULL                     #清除鍵值
   LET g_vob01_t = NULL
   LET g_vob02_t = NULL
   LET p_row = 4 LET p_col = 20

   OPEN WINDOW apst811_w AT p_row,p_col WITH FORM "aps/42f/apst811"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_set_comp_visible("vob08,vob20,vob04,vob03",FALSE)
   CALL cl_set_comp_entry('pml16,pmk12,pmk09,vob07,vob11,vob40',FALSE);

   IF NOT cl_null(g_argv1) THEN CALL t811_q() END IF

   CALL cl_getmsg('abm-020',g_lang) RETURNING g_status1 #執行失敗 #FUN-BB0025 add
   CALL cl_getmsg('abm-019',g_lang) RETURNING g_status2 #執行成功 #FUN-BB0025 add

   CALL t811_menu()
   CLOSE WINDOW apst811_w               #結束畫面
    CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time
END MAIN

FUNCTION t811_curs()
DEFINE l_vzy01   LIKE vzy_file.vzy01  
DEFINE l_vzy02   LIKE vzy_file.vzy02  

   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "vob01 = '",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN
         LET tm.wc = tm.wc, " AND vob02 = '",g_argv2,"'"
      END IF
      LET tm.wc2=" 1=1 "

       LET g_sql= " SELECT UNIQUE vob01,vob02 FROM vob_file ",
                  " WHERE ", tm.wc  CLIPPED,
                  "   AND ", tm.wc2 CLIPPED,
                  "   AND vob00 = '",g_plant,"'",
                  " ORDER BY vob01,vob02 "
       IF NOT cl_null(g_argv2) THEN
          LET g_argv1 = ''
       END IF

   ELSE
      CLEAR FORM                             #清除畫面
      CALL g_vob.clear()
      CALL cl_set_head_visible("","YES")

      CONSTRUCT tm.wc ON vob01,vob02 FROM vob01,vob02  

          BEFORE CONSTRUCT
            IF g_vob01_t IS NOT NULL THEN
               DISPLAY g_vob01_t TO FORMONLY.vob01
               DISPLAY g_vob02_t TO FORMONLY.vob02
             END IF

          AFTER FIELD vob01
             LET g_vob01 =  GET_FLDBUF(vob01)
             IF cl_null(g_vob01) THEN
                CALL cl_err('','aps-521',1)
                NEXT FIELD vob01
             END IF

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
             CALL cl_qbe_list() RETURNING lc_qbe_sn
             CALL cl_qbe_display_condition(lc_qbe_sn)


          ON ACTION CONTROLP
             CASE
              WHEN INFIELD(vob01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_vob"
                LET g_qryparam.arg1=g_plant
                LET g_qryparam.default1 = g_vob01
                CALL cl_create_qry() RETURNING g_vob01,g_vob02
                DISPLAY g_vob01 TO vob01
                DISPLAY g_vob02 TO vob02
                NEXT FIELD vob01
             END CASE


      END CONSTRUCT

      IF INT_FLAG THEN
         RETURN
      END IF

      LET g_vob01_t = g_vob01
      LET g_vob02_t = g_vob02

      LET tm.hstatus = NULL
     #INPUT BY NAME tm.hstatus WITHOUT DEFAULTS           #FUN-BB0025 mark
      INPUT BY NAME tm.hstatus,tm.pne05 WITHOUT DEFAULTS  #FUN-BB0025 add pne05

         BEFORE FIELD hstatus
            LET tm.hstatus = 'A'
            DISPLAY BY NAME  tm.hstatus
            CALL t811_set_entry()       #FUN-BB0025 add
            CALL t811_set_no_required() #FUN-BB0025 add

         AFTER FIELD hstatus
            IF cl_null(tm.hstatus) THEN
               NEXT  FIELD hstatus
            END IF 
            #FUN-BB0025--add---str---
            IF tm.hstatus = 'C' THEN
                LET tm.pne05 = g_user
                CALL t811_peo(tm.pne05)
            ELSE
                LET tm.pne05 = ''
                DISPLAY BY NAME tm.pne05
                DISPLAY '' TO FORMONLY.gen02
            END IF
            CALL t811_set_no_entry() 
            CALL t811_set_required() 
            #FUN-BB0025--add---end---
         #FUN-BB0025---add---str---
         AFTER FIELD pne05  #變更人員
               IF NOT cl_null(tm.pne05) THEN
                  CALL t811_peo(tm.pne05)
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(tm.pne05,g_errno,1)  
                      LET tm.pne05 = ''
                      DISPLAY BY NAME tm.pne05
                      DISPLAY '' TO FORMONLY.gen02
                      NEXT FIELD pne05 
                  END IF
               END IF
         ON ACTION CONTROLP
            CASE      #查詢符合條件的單號
                 WHEN INFIELD(pne05) #變更人員
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = tm.pne05
                     CALL cl_create_qry() RETURNING tm.pne05 
                     DISPLAY BY NAME tm.pne05
                     CALL t811_peo(tm.pne05)
                     NEXT FIELD pne05 
                OTHERWISE EXIT CASE
              END CASE
         #FUN-BB0025---add---end---
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION about
            CALL cl_about()
         ON ACTION help
            CALL cl_show_help()
         ON ACTION controlg
            CALL cl_cmdask()
         ON ACTION qbe_save
            CALL cl_qbe_save()
         ON ACTION locale
           LET g_change_lang = TRUE
           EXIT INPUT
      END INPUT

      CALL cl_set_head_visible("","YES")
      CALL q810_b_askkey()
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF

  #FUN-A30082 mod str ----
   LET g_sql = "SELECT UNIQUE vob01,vob02  ",
              #"  FROM voc_file,vob_file,vaz_file,pmk_file,pml_file   ",
               "  FROM voc_file,vob_file,pmk_file,pml_file   ",                 
               " WHERE voc00=vob00          ",
               "   AND voc01=vob01          ",
               "   AND voc02=vob02          ",
               "   AND voc03=vob03          ",
              #"   AND vaz01=vob03          ",
               "   AND vob05='0'            ",
              #"   AND vaz10=vob13          ",
               "   AND vob00 = '",g_plant,"'",
              #"   AND (vaz24='0' OR vaz24 = '' OR vaz24 IS NULL)",
              #"   AND vaz10 = pml01    ",
              #"   AND vaz23 = pml02    ",
               "   AND vob13 = pml01    ",
               "   AND pml02 = cast(substr(vob03,length(vob03)-3,4) as int)  ",
               "   AND vob13 = pmk01    ",
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND (voc04<>'0' or voc05<>'0') " 
  #FUN-A30082 mod end ----

   DISPLAY g_sql
   PREPARE t811_prepare FROM g_sql      #預備一下
   DECLARE t811_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t811_prepare

   DROP TABLE count_tmp
    LET g_sql = g_sql," INTO TEMP count_tmp "
   PREPARE t811_cnt_tmp  FROM g_sql
   EXECUTE t811_cnt_tmp
   DECLARE t811_count CURSOR FOR SELECT COUNT(*) FROM count_tmp

END FUNCTION


FUNCTION q810_b_askkey()
   CONSTRUCT tm.wc2 ON vob36,vob13,pml16,pmk12,pmk09,
                       #vaz23,                                #FUN-A30082 mark
                       itemno,                                #FUN-A30082 add
                       vob07,ima02,vob11,pml20,vob33,
                       pml34,vob14,pml35,vob17,vob40,vob42
        FROM s_vob[1].vob36,
             s_vob[1].vob13,s_vob[1].pml16,
             s_vob[1].pmk12,
             s_vob[1].pmk09,
            #s_vob[1].vaz23,                                  #FUN-A30082 mark
             s_vob[1].itemno,                                 #FUN-A30082 add
             s_vob[1].vob07,s_vob[1].ima02,
             s_vob[1].vob11,s_vob[1].pml20,
             s_vob[1].vob33,s_vob[1].pml34,
             s_vob[1].vob14,s_vob[1].pml35,
             s_vob[1].vob17,
             s_vob[1].vob40,s_vob[1].vob42   

      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      ON IDLE g_idle_seconds
      CALL cl_on_idle()
           CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()
      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(pmk12)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmk8"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_vob[1].pmk12
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmk12
              NEXT FIELD pmk12
          WHEN INFIELD(pmk09)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmk9"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_vob[1].pmk09
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO pmk09
             NEXT FIELD pmk09
          WHEN INFIELD(vob07)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_vob[1].vob07
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO vob07
             NEXT FIELD vob07
          WHEN INFIELD(vob11)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gfe"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_vob[1].vob11
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO vob11
             NEXT FIELD vob11
          WHEN INFIELD(vob42)    #供給法則
             CALL cl_init_qry_var()
             LET g_qryparam.form = "cq_tc_sup001"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_vob[1].vob42
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO vob42
             NEXT FIELD vob42

          END CASE

      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
END FUNCTION


FUNCTION t811_menu()

   WHILE TRUE
      CALL t811_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t811_q()
            END IF
         WHEN "next"
            CALL t811_fetch('N')
         WHEN "previous"
            CALL t811_fetch('P')

         WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL t811_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN  "help"
            CALL cl_show_help()
         WHEN  "exit"
            EXIT WHILE
         WHEN  "jump"
            CALL t811_fetch('/')
         WHEN  "first"
            CALL t811_fetch('F')
         WHEN  "last"
            CALL t811_fetch('L')
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vob),'','')
            END IF

         #全選
         WHEN "pick_all"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN
                  IF t811_pick('A') THEN
                     MESSAGE 'No Rows can be chosen'
                  END IF
               END IF
            END IF

         #全不選
         WHEN "drop_all"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN
                  IF t811_pick('E') THEN
                     MESSAGE 'No Rows can be chosen'
                  END IF
               END IF
            END IF

         #請購單明細
         WHEN "pr_detail"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF g_rec_b > 0 AND l_ac > 0 THEN
                     IF g_vob[l_ac].status='A' OR g_vob[l_ac].status='D' OR
                       #g_vob[l_ac].status='E' OR g_vob[l_ac].status='F' OR #FUN-BB0025 mark
                        g_vob[l_ac].status='E' OR g_vob[l_ac].status='C' OR #FUN-BB0025 add
                        g_vob[l_ac].status='G'    THEN
                        LET g_msg = " apmt420 '", g_vob[l_ac].vob13,"'"
                        CALL cl_cmdrun_wait(g_msg CLIPPED)
                     END IF
               END IF
            END IF

        #FUN-BB0020--mark---str----
        ##請購單結案維護
        #WHEN "pr_closing"
        #   IF g_rec_b = 0 THEN
        #      CALL cl_err('','aps-702',1)
        #   ELSE
        #      IF g_rec_b > 0 AND l_ac > 0 THEN
        #            LET g_msg = " apmp451 "
        #            CALL cl_cmdrun_wait(g_msg CLIPPED)
        #      END IF
        #   END IF 
        #FUN-BB0020--mark---end----
        #FUN-BB0020--add----str----
         #結案自動調整
         WHEN "auto_batch_close"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN
                  LET g_success = 'Y'
                  BEGIN WORK
                  CALL t811_pr_close()
                  IF g_success !='C' THEN
                     CALL cl_err('','afa-116',1)
                  END IF
                  CALL t811_b_fill()                   
               END IF
            END IF 
        #FUN-BB0020--add----end----

         #整批請購調整
         WHEN "batch_pr_adjust"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN
                  LET g_success = 'Y'
                  BEGIN WORK
                  CALL t811_batch_pr_adjust()
                  IF g_success !='C' THEN 
                     CALL cl_err('','afa-116',1)
                  END IF
                  CALL t811_b_fill()                   
               END IF
            END IF
         #FUN-BB0025---add----str---
         #整批產生變更單
         WHEN "batch_pr_change"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN
                  LET g_success = 'Y'
                  BEGIN WORK
                  CALL t811_batch_pr_change()
                  IF g_success !='C' THEN
                     CALL cl_err('','afa-116',1)
                  END IF
                  CALL t811_b_fill()
               END IF
            END IF 
         #FUN-BB0025---add----end---

         #自動作廢
         WHEN "pr_void"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN
                  LET g_success = 'Y'
                  BEGIN WORK
                  CALL t811_pr_void()
                  IF g_success !='C' THEN
                     CALL cl_err('','afa-116',1)
                  END IF
                  CALL t811_b_fill()                   
               END IF
            END IF 
      END CASE
   END WHILE
END FUNCTION

FUNCTION t811_q()

   LET g_row_count = 0
   LET mi_curs_index = 0
   CALL cl_navigator_setting(mi_curs_index,g_row_count)

   MESSAGE ""
   CALL cl_opmsg('q')

   CALL t811_curs()                           #取得查詢條件

   IF INT_FLAG THEN                           #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t811_count
    FETCH t811_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt

   OPEN t811_b_curs                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                      #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_vob01 TO NULL
      INITIALIZE g_vob02 TO NULL
   ELSE
      CALL t811_fetch('F')                    #讀出TEMP第一筆並顯示
   END IF

END FUNCTION

FUNCTION t811_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,     #處理方式
            l_abso   LIKE type_file.num10     #絕對的筆數

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t811_b_curs INTO g_vob01,g_vob02
      WHEN 'P' FETCH PREVIOUS t811_b_curs INTO g_vob01,g_vob02
      WHEN 'F' FETCH FIRST    t811_b_curs INTO g_vob01,g_vob02
      WHEN 'L' FETCH LAST     t811_b_curs INTO g_vob01,g_vob02
      WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                  LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR mi_jump

                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()

                  ON ACTION about
                     CALL cl_about()

                  ON ACTION help
                     CALL cl_show_help()

                  ON ACTION controlg
                     CALL cl_cmdask()

               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
      FETCH ABSOLUTE mi_jump t811_b_curs INTO g_vob01,g_vob02
      LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_vob01,SQLCA.sqlcode,0)
      INITIALIZE g_vob01 TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET mi_curs_index = 1
         WHEN 'P' LET mi_curs_index = mi_curs_index - 1
         WHEN 'N' LET mi_curs_index = mi_curs_index + 1
         WHEN 'L' LET mi_curs_index = g_row_count 
         WHEN '/' LET mi_curs_index = mi_jump
      END CASE

      CALL cl_navigator_setting(mi_curs_index, g_row_count)
      CALL t811_show()
   END IF

END FUNCTION

FUNCTION t811_show()

   CLEAR FROM
   CALL g_vob.clear()
   DISPLAY g_vob01 TO FORMONLY.vob01              #單頭
   DISPLAY g_vob02 TO FORMONLY.vob02              #單頭

   LET g_vob01_t = g_vob01
   LET g_vob02_t = g_vob02

   CALL t811_b_fill()                   
   #IF t811_pick('A') THEN
   #   MESSAGE 'No Rows can be chosen'
   #END IF
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t811_b()
   DEFINE   l_ac_t           LIKE type_file.num5,       #未取消的ARRAY CNT                          
            l_n              LIKE type_file.num5,       #檢查重複用                                
            l_lock_sw        LIKE type_file.chr1,       #單身鎖住否                               
            p_cmd            LIKE type_file.chr1,       #處理狀態                                 
            l_allow_insert   LIKE type_file.num5,       #可新增否                                  
            l_allow_delete   LIKE type_file.num5,       #可刪除否                                  
            ls_cnt           LIKE type_file.num5      

   LET g_action_choice = ""

   IF g_vob01 IS NULL AND g_vob02 IS NULL THEN
      RETURN
   END IF
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT vob36 ",
                      "  FROM vob_file    ",
                      " WHERE vob00=? AND vob01=? AND vob02=? AND vob03=? FOR UPDATE "

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)    #FUN-B50020 add

   DECLARE t811_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_vob WITHOUT DEFAULTS FROM s_vob.*
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
            LET g_vob_t.* = g_vob[l_ac].*  #BACKUP
            LET p_cmd='u'
            OPEN t811_b_curl USING g_plant,g_vob01,g_vob02,g_vob[l_ac].vob03 
            IF STATUS THEN
               CALL cl_err("OPEN t811_b_cur1:",STATUS,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t811_b_curl INTO g_vob[l_ac].vob36
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_vob_t.vob36,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()                      
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_vob[l_ac].* = g_vob_t.*
            CLOSE t811_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_vob[l_ac].vob36,-263,1)
            LET g_vob[l_ac].* = g_vob_t.*
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_vob[l_ac].* = g_vob_t.*
            END IF
            CLOSE t811_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE t811_b_curl
         COMMIT WORK

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about                    
         CALL cl_about()                 
 
      ON ACTION help                     
         CALL cl_show_help()             
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","YES")                                                                                        

   END INPUT

   CLOSE t811_b_curl
   COMMIT WORK
 
END FUNCTION


FUNCTION t811_b_fill()              #BODY FILL UP
DEFINE g_wc  STRING

DEFINE l_pmk25 LIKE pmk_file.pmk25,
       l_pml20 LIKE pml_file.pml20,
       l_pmm25 LIKE pmm_file.pmm25,
       l_pmn50 LIKE pmn_file.pmn50,
       l_pmn20 LIKE pmn_file.pmn20,
       l_pml21 LIKE pml_file.pml21, 
       l_pml34 LIKE pml_file.pml34,  
       l_pmn5358 LIKE pmn_file.pmn53, 
       l_pmn34 LIKE pmn_file.pmn34    

  LET g_sql = #"SELECT vob36,'',vob13,pml16,gen02,pmc03,vaz23,vob07,ima02, ",           #FUN-A30082 mark
               "SELECT vob36,'',vob13,pml16,gen02,pmc03, ",                             #FUN-A30082 add
               "       cast(substr(vob03,length(vob03)-3,4) as int),vob07,ima02, ",     #FUN-A30082 add
               "       vob11,'',pml20,pml20-pml21,vob33,vob33-pml20, ",
               "       pml34,vob14,pml35,vob40,vob17,vob42,vob08,vob20,vob04,vob03  ", 
              #"  FROM voc_file,vob_file,vaz_file,pmk_file,pml_file,ima_file,gen_file,pmc_file  ",  #FUN-A30082 mark
              #FUN-B0020--mod---str---
              #"  FROM voc_file,vob_file,pmk_file,pml_file,ima_file,gen_file,pmc_file  ",           #FUN-A30082 add
               "  FROM voc_file,pml_file,",
               "       vob_file LEFT OUTER JOIN ima_file ON vob07 = ima01 ",
               "                LEFT OUTER JOIN pmk_file ON vob13 = pmk01 ",
               "                LEFT OUTER JOIN gen_file ON pmk12 = gen01 ", 
               "                LEFT OUTER JOIN pmc_file ON pmk09 = pmc01 ",
              #FUN-B0020--mod---end---
               " WHERE voc00=vob00          ",
               "   AND voc01=vob01          ",
               "   AND voc02=vob02          ",
               "   AND voc03=vob03          ",
              #"   AND vaz01=vob03          ",                                          #FUN-A30082 mark
               "   AND vob13 = pml01        ",                                          #FUN-A30082 add
               "   AND pml02 = cast(substr(vob03,length(vob03)-3,4) as int)  ",         #FUN-A30082 add
               "   AND vob05='0'            ",
              #"   AND vob07=ima01(+)          ", #FUN-B50020 mark
              #"   AND pmk12=gen01(+)          ", #FUN-B50020 mark
              #"   AND pmk09=pmc01(+)          ", #FUN-B50020 mark
              #"   AND vaz10=vob13          ",                                          #FUN-A30082 mark
               "   AND vob01 = '",g_vob01,"'",
               "   AND vob02 = '",g_vob02,"'",
               "   AND vob00 = '",g_plant,"'",
              #"   AND (vaz24='0' OR vaz24 = '' OR vaz24 IS NULL)",                     #FUN-A30082 mark
              #"   AND vob13=pmk01(+)    ", #FUN-B50020 mark
              #"   AND vaz10=pml01(+)    ",                                                #FUN-A30082 mark
              #"   AND vaz23=pml02(+)    ",                                                #FUN-A30082 mark
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND (voc04<>'0' or voc05<>'0') ", 
               "   AND pmk18 <>'X' ",                       
               "   AND (vob36<>'Y' OR vob36 IS NULL) "

   CASE tm.hstatus
      WHEN 'A'
         LET g_sql = g_sql , " AND pmk25 IN ('0','R','W')  AND vob33>0  ",
                             " AND (vob33<>pml20 OR vob14<>pml34 OR vob40<>pml35) "
      WHEN 'D'
           #FUN-A10137---mod---str---
           #LET g_sql = g_sql , " AND ((pmk25 NOT IN ('0','1') AND vob33>0 ",
           #                    "      AND (vob33<>pml20 OR vob14<>pml34 OR vob40<>pml35)) ",
           #                    "     OR ",
           #                    "      (pmk25 IN ('S') ))"             
            LET g_sql = g_sql , " AND ((pmk25 IN ('2') AND vob33>0 ",
                                "      AND (vob33<>pml20 OR vob14<>pml34 OR vob40<>pml35)) ",
                                "     OR ",
                                "      (pmk25 IN ('6','9','S') ))"            
           #FUN-A10137---mod---end---
      WHEN 'E'
           LET g_sql = g_sql , " AND pmk25 IN ('0','R','W') ",
                               " AND vob33=0  "
     #WHEN 'F' #FUN-BB0025 mark
      WHEN 'C' #FUN-BB0025 add
          LET g_sql = g_sql , " AND pmk25 = '1' AND vob33>0  ",
                              " AND (vob33<>pml20 OR vob14<>pml34 OR vob40<>pml35) "
      WHEN 'G'
           LET g_sql = g_sql , " AND (pml16 IN ('1','2') AND vob33 = 0) "
   END CASE
   LET g_sql = g_sql CLIPPED," ORDER BY vob03 " #FUN-B50020 add

   PREPARE vob_pre FROM g_sql
   DECLARE vob_curs CURSOR FOR vob_pre

   CALL g_vob.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH vob_curs INTO g_vob[g_cnt].*   #單身 ARRAY 填充

      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

     #品名
      SELECT ima02 INTO g_vob[g_cnt].ima02
        FROM ima_file
       WHERE ima01=g_vob[g_cnt].vob07

           SELECT pml20,
                  pml21,
                  pml34  
                  INTO 
                  l_pml20,
                  l_pml21,
                  l_pml34   
        FROM pml_file
       WHERE pml01=g_vob[g_cnt].vob13
        #AND pml02=g_vob[g_cnt].vaz23     #FUN-A30082 mark
         AND pml02=g_vob[g_cnt].itemno    #FUN-A30082 add
      LET g_vob[g_cnt].pml20 = l_pml20  
           if l_pml20<>g_vob[g_cnt].vob08 or 
              l_pml21<>g_vob[g_cnt].vob20 or 
              l_pml34<>g_vob[g_cnt].vob04 then   
         let g_vob[g_cnt].ischange='Y'
      else
         let g_vob[g_cnt].ischange='N'
      end if

      #status
      LET g_vob[g_cnt].status = tm.hstatus
      #SELECT pmk25 INTO l_pmk25 FROM pmk_file WHERE pmk01=g_vob[g_cnt].vob13
      #CASE
      #   WHEN l_pmk25='0' AND g_vob[g_cnt].vob33>0 AND
      #        ((g_vob[g_cnt].vob33<>g_vob[g_cnt].pml20) OR
      #         (g_vob[g_cnt].vob14<>g_vob[g_cnt].pml34) OR
      #         (g_vob[g_cnt].vob40<>g_vob[g_cnt].pml35)) 
      #        LET g_vob[g_cnt].status='A'
      #   WHEN ((l_pmk25<>'0' AND l_pmk25<>'1')  AND g_vob[g_cnt].vob33>0 AND
      #         ((g_vob[g_cnt].vob33<>g_vob[g_cnt].pml20) OR 
      #          (g_vob[g_cnt].vob14<>g_vob[g_cnt].pml34) OR
      #          (g_vob[g_cnt].vob40<>g_vob[g_cnt].pml35))
      #        )
      #        OR
      #        (l_pmk25='S' AND g_vob[g_cnt].vob33=0)
      #        LET g_vob[g_cnt].status='D'
      #   WHEN (l_pmk25='0' OR l_pmk25='R' OR l_pmk25='W') AND g_vob[g_cnt].vob33=0 
      #        LET g_vob[g_cnt].status='E'
      #   WHEN l_pmk25='1' AND g_vob[g_cnt].vob33>0 AND
      #        ((g_vob[g_cnt].vob33<>g_vob[g_cnt].pml20) OR
      #         (g_vob[g_cnt].vob14<>g_vob[g_cnt].pml34) OR
      #         (g_vob[g_cnt].vob40<>g_vob[g_cnt].pml35))
      #        LET g_vob[g_cnt].status='F'
      #   WHEN (g_vob[g_cnt].pml16='1' OR g_vob[g_cnt].pml16='2') AND 
      #        g_vob[g_cnt].vob33=0
      #        LET g_vob[g_cnt].status='G'
      #END CASE

      LET g_rec_b = g_rec_b + 1
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_vob.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION t811_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1                           

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_vob TO s_vob.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
          CALL cl_navigator_setting(mi_curs_index,g_row_count) 
         #CALL cl_set_action_active("pr_closing,batch_pr_adjust,pr_void",FALSE)       #FUN-BB0020 mark
          CALL cl_set_action_active("auto_batch_close,batch_pr_adjust,pr_void",FALSE) #FUN-BB0020 add
          CALL cl_set_action_active("batch_pr_change",FALSE)                          #FUN-BB0025 add
      CASE
         WHEN tm.hstatus='G'
           #CALL cl_set_action_active("pr_closing",TRUE)                              #FUN-BB0020 mark
            CALL cl_set_action_active("auto_batch_close",TRUE)                        #FUN-BB0020 add
         WHEN tm.hstatus='A'
            CALL cl_set_action_active("batch_pr_adjust",TRUE)
         WHEN tm.hstatus='E'
            CALL cl_set_action_active("pr_void",TRUE)
         #FUN-BB0025---add----str---
         WHEN tm.hstatus='C'
            CALL cl_set_action_active("batch_pr_change",TRUE)
         #FUN-BB0025---add----end---
      END CASE

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                                     

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                                     
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION first
         CALL t811_fetch('F')
         CALL cl_navigator_setting(mi_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)                     
         END IF
         ACCEPT DISPLAY                                          

      ON ACTION previous
         CALL t811_fetch('P')
         CALL cl_navigator_setting(mi_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)                     
           END IF
	 ACCEPT DISPLAY                                          
 
      ON ACTION jump
         CALL t811_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)                                      
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)                     
         END IF
	 ACCEPT DISPLAY                                          
 
      ON ACTION last
         CALL t811_fetch('L')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)                                      
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)                     
         END IF
	 ACCEPT DISPLAY                                          
 
      ON ACTION next
         CALL t811_fetch('N')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)                                      
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)                     
         END IF
	 ACCEPT DISPLAY                                          

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about                    
         CALL cl_about()                 
 
      ON ACTION help                     
         CALL cl_show_help()             
 
      ON ACTION controlg                 
         CALL cl_cmdask()                
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY


      ON ACTION pick_all
         LET g_action_choice="pick_all"
         EXIT DISPLAY

      ON ACTION drop_all
         LET g_action_choice="drop_all"
         EXIT DISPLAY

      ON ACTION pr_detail #請購單維護
         IF cl_null(g_rec_b) or g_rec_b = 0 THEN 
            LET g_action_choice=''
            CALL cl_err('','ain-070',0)
         ELSE LET g_action_choice="pr_detail"
         END IF
         EXIT DISPLAY

     #FUN-BB0020----mark----str---
     #ON ACTION pr_closing #請購單結案維護
     #   IF cl_null(g_rec_b) or g_rec_b = 0 THEN 
     #      LET g_action_choice=''
     #      CALL cl_err('','ain-070',0)
     #   ELSE LET g_action_choice="pr_closing"
     #   END IF
     #   EXIT DISPLAY
     #FUN-BB0020----mark----end---

      ON ACTION batch_pr_adjust #整批請購調整
         IF cl_null(g_rec_b) or g_rec_b = 0 THEN
            LET g_action_choice=''
            CALL cl_err('','ain-070',0)
         ELSE LET g_action_choice="batch_pr_adjust"
         END IF
         EXIT DISPLAY

      #FUN-BB0025---add----str---
      ON ACTION batch_pr_change  #整批產生採購變更單
         LET g_action_choice="batch_pr_change"
         EXIT DISPLAY
      #FUN-BB0025---add----end---

      ON ACTION pr_void #請購單作廢自動維護
         IF cl_null(g_rec_b) or g_rec_b = 0 THEN
            LET g_action_choice=''
           CALL cl_err('','ain-070',0)
          ELSE LET g_action_choice="pr_void"
         END IF
         EXIT DISPLAY

     #FUN-BB0020----add-----str---
      ON ACTION auto_batch_close #結案自動調整
         IF cl_null(g_rec_b) or g_rec_b = 0 THEN 
            LET g_action_choice=''
            CALL cl_err('','ain-070',0)
         ELSE 
            LET g_action_choice="auto_batch_close"
         END IF
         EXIT DISPLAY
     #FUN-BB0020----str-----end---

      AFTER DISPLAY
         CONTINUE DISPLAY

    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION t811_pr_void()  #作廢自動調整
DEFINE l_update   VARCHAR(1),
       l_pml      RECORD LIKE pml_file.*,
       l_vob      RECORD LIKE vob_file.*,
       l_cnt      SMALLINT,
       l_cntx     SMALLINT,
       l_pml16    LIKE pml_file.pml16,
       l_str      STRING,
       i          SMALLINT

   #詢問是否確定執行
   IF NOT cl_confirm('aap-017') THEN
      LET g_success = 'C'
      RETURN
   END IF

   LET l_str = cl_getmsg('aps-738',g_lang)
   MESSAGE l_str

  #FUN-B60047--mark---str---
  #LET g_sql = "SELECT UNIQUE vob_file.*,pml_file.* ",
  #           #"  FROM voc_file,vob_file,vaz_file,pmk_file,pml_file",             #FUN-A30082 mark
  #            "  FROM voc_file,vob_file,pmk_file,pml_file",                      #FUN-A30082 add
  #            " WHERE voc00=vob00          ",
  #            "   AND voc01=vob01          ",
  #            "   AND voc02=vob02          ",
  #            "   AND voc03=vob03          ",
  #            "   AND vob13 = pml01    ",
  #            "   AND pml02 = cast(substr(vob03,length(vob03)-3,4) as int)  ",   #FUN-A30082 add
  #           #"   AND vaz01=vob03          ",                                    #FUN-A30082 add
  #            "   AND vob05='0'            ",
  #           #"   AND vaz10=vob13          ",                                    #FUN-A30082 mark
  #            "   AND vob01 = '",g_vob01,"'",
  #            "   AND vob02 = '",g_vob02,"'",
  #            "   AND vob00 = '",g_plant,"'",
  #           #"   AND (vaz24='0' OR vaz24 = '' OR vaz24 IS NULL)",               #FUN-A30082 mark
  #            "   AND vob13 = pmk01    ",
  #            "   AND ",tm.wc CLIPPED,
  #            "   AND ",tm.wc2 CLIPPED,
  #            "   AND (voc04<>'0' or voc05<>'0') ",
  #            "   AND vob33 = 0 ",
  #            "   AND pml16 = '0' ",
  #            "   AND pmk01 = pml01 ",
  #           #"   AND pml02 = vaz23 ",                                           #FUN-A30082 mark
  #            "  ORDER BY pml01,pml02"


  #PREPARE t811_pr_void_p FROM g_sql
  #DECLARE t811_pr_void_cs CURSOR FOR t811_pr_void_p
  #FUN-B60047--mark---end---

   LET l_cnt = 0
  #FOREACH t811_pr_void_cs INTO l_vob.*,l_pml.* #FUN-B60047 mark
   FOR i = 1 TO g_rec_b
      IF STATUS THEN
         #LET g_success = 'N'
         #CALL cl_err('foreach t811_pr_void_cs:',STATUS,1)
         RETURN
      END IF
     #FUN-B60047--mod---str---
     #IF g_vob[i].vob03 = l_vob.vob03 AND g_vob[i].vob36='Y' THEN 
      IF g_vob[i].vob36='Y' THEN                                  
          SELECT * INTO l_pml.*
            FROM pml_file
           WHERE pml01 = g_vob[i].vob13
             AND pml02 = g_vob[i].itemno
          SELECT * INTO l_vob.*
            FROM vob_file
           WHERE vob00 = g_plant
             AND vob01 = g_vob01
             AND vob02 = g_vob02
             AND vob03 = g_vob[i].vob03
     #FUN-B60047--mod---end---
         UPDATE pml_file SET pml16 = '9'
          WHERE pml01 = l_pml.pml01
            AND pml02 = l_pml.pml02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err('upd pml16_9:',SQLCA.sqlcode,1)
            RETURN
         END IF
   
         #檢查所有單身是不是都已作廢，若已結案則單頭也跟著結案
         LET l_cntx = 0
         SELECT COUNT(*) INTO l_cntx FROM pml_file
          WHERE pml01 = l_pml.pml01 AND pml16 != '9'
         IF l_cntx = 0 OR cl_null(l_cntx) THEN
            UPDATE pmk_file SET pmk25 = '9',pmk18='X',pmkmodu='aps',pmkdate=g_today
             WHERE pmk01 = l_pml.pml01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               LET g_success = 'N'
               CALL cl_err("upd pmk25_9:",SQLCA.sqlcode,1)
               RETURN
            END IF
         END IF

         UPDATE pmk_file SET pmkmodu='aps',pmkdate=g_today
          WHERE pmk01 = l_pml.pml01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err('upd pmk:',SQLCA.sqlcode,1)
            RETURN
         END IF

         UPDATE vob_file SET vob36='Y'
          WHERE vob00=g_plant
            AND vob01=g_vob01
            AND vob02=g_vob02
            AND vob03=g_vob[i].vob03

         LET l_cnt = l_cnt + 1  
      END IF
   END FOR 
  #END FOREACH #FUN-B60047 mark
   COMMIT WORK
   #MESSAGE ""
   LET l_str = cl_getmsg("anm-973",g_lang)
   MESSAGE l_str||l_cnt
END FUNCTION


#單身段挑選處理
FUNCTION t811_pick(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,       #決定全選("A",表示全選)或全不選("E",表示全不選)
       l_i        LIKE type_file.num5,
       l_max_b    LIKE type_file.num5
   LET l_max_b = g_rec_b
   CASE p_cmd
      WHEN 'A'
         FOR l_i = 1 TO l_max_b
            LET g_vob[l_i].vob36 = 'Y'
         END FOR
      WHEN 'E'
         FOR l_i = 1 TO l_max_b
            LET g_vob[l_i].vob36 = 'N'
         END FOR
      OTHERWISE EXIT CASE
   END CASE
   RETURN false
END FUNCTION

#整批請購調整
FUNCTION t811_batch_pr_adjust()
DEFINE l_update   VARCHAR(1),
       l_pml      RECORD LIKE pml_file.*,
       l_vob      RECORD LIKE vob_file.*,
       l_cnt      SMALLINT,
       l_pml16    LIKE pml_file.pml16,
       l_str      STRING,
       i          SMALLINT
   #詢問是否確定執行
   IF NOT cl_confirm('aap-017') THEN
      LET g_success = 'C'
      RETURN
   END IF

   LET l_str = cl_getmsg('aps-738',g_lang)
   MESSAGE l_str
 #FUN-B60047--mark---str---
 ##FUN-A30082 mod str ---------------
 # LET g_sql = "SELECT UNIQUE vob_file.*,pml_file.* ",
 #            #"  FROM voc_file,vob_file,vaz_file,pmk_file,pml_file ",
 #             "  FROM voc_file,vob_file,pmk_file,pml_file ",
 #             " WHERE voc00=vob00          ",
 #             "   AND voc01=vob01          ",
 #             "   AND voc02=vob02          ",
 #             "   AND voc03=vob03          ",
 #            #"   AND vaz01=vob03          ",
 #             "   AND vob05='0'            ",
 #            #"   AND vaz10=vob13          ",
 #             "   AND pmk01=pml01          ",
 #            #"   AND vaz23=pml02       ",
 #             "   AND vob13 = pml01    ",
 #             "   AND pml02 = cast(substr(vob03,length(vob03)-3,4) as int)  ",
 #             "   AND vob01 = '",g_vob01,"'",
 #             "   AND vob02 = '",g_vob02,"'",
 #             "   AND vob00 = '",g_plant,"'",
 #            #"   AND (vaz24='0' OR vaz24 = '' OR vaz24 IS NULL)",
 #             "   AND vob13 = pmk01    ",
 #             "   AND ",tm.wc CLIPPED,
 #             "   AND ",tm.wc2 CLIPPED,
 #             "   AND (voc04<>'0' or voc05<>'0') ",
 #            #FUN-B50020 mod str ------------- 
 #            #"   AND (to_date(vob14)<>to_date(pml34) OR to_date(vob40)<>to_date(pml35) OR (vob33<>pml20 )) ",
 #             "   AND ((CAST(vob14 AS DATE) <> CAST(pml34 AS DATE)) OR",
 #             "        (CAST(vob40 AS DATE) <> CAST(pml35 AS DATE)) OR",
 #             "        (vob33 <> pml20))", 
 #            #FUN-B50020 mod end -------------
 #             "   AND pml16 = '0' AND vob33>0 "
 ##FUN-A30082 mod end ---------------

 # PREPARE t811_batch_pr_adjust_p FROM g_sql
 # DECLARE t811_batch_pr_adjust_cs CURSOR FOR t811_batch_pr_adjust_p
 #FUN-B60047--mark---end---

   LET l_cnt = 0  
  #FOREACH t811_batch_pr_adjust_cs INTO l_vob.*,l_pml.*  #FUN-B60047 mark
   FOR i = 1 TO g_rec_b
       IF STATUS THEN
          RETURN
       END IF
    #FUN-B60047--mod---str---
    #IF g_vob[i].vob03 = l_vob.vob03 AND g_vob[i].vob36='Y' THEN 
     IF g_vob[i].vob36='Y' THEN                                  
         SELECT * INTO l_pml.*
           FROM pml_file
          WHERE pml01 = g_vob[i].vob13
            AND pml02 = g_vob[i].itemno
         SELECT * INTO l_vob.*
           FROM vob_file
          WHERE vob00 = g_plant
            AND vob01 = g_vob01
            AND vob02 = g_vob02
            AND vob03 = g_vob[i].vob03
    #FUN-B60047--mod---end---
       IF l_pml.pml34<>l_vob.vob14 OR l_pml.pml35<>l_vob.vob40 THEN
          UPDATE pml_file SET pml34 = l_vob.vob14,pml35=l_vob.vob40,
                              pml33 = l_vob.vob14
           WHERE pml01 = l_pml.pml01    
             AND pml02 = l_pml.pml02    
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                 LET g_success = 'N'
                 CALL cl_err("upd pml35:",SQLCA.sqlcode,1)
                 RETURN
              END IF
       END IF
 
       IF l_vob.vob33>0 AND l_vob.vob33<>l_pml.pml20 THEN
          UPDATE pml_file SET pml20 = l_vob.vob33
           WHERE pml01 = l_pml.pml01
             AND pml02 = l_pml.pml02          
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_success = 'N'
             CALL cl_err('upd pml20:',SQLCA.sqlcode,1)
             RETURN
          END IF
       END IF
 
       UPDATE pmk_file SET pmkmodu='aps',pmkdate=g_today
        WHERE pmk01 = l_pml.pml01

       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          LET g_success = 'N'
          CALL cl_err('upd pmk:',SQLCA.sqlcode,1)
          RETURN
       END IF

 
       UPDATE vob_file SET vob36='Y'
        WHERE vob00=g_plant
          AND vob01=g_vob01
          AND vob02=g_vob02
          AND vob03=g_vob[i].vob03

       LET l_cnt = l_cnt + 1
     END IF
   END FOR
  #END FOREACH #FUN-B60047 mark
   COMMIT WORK
   LET l_str = cl_getmsg("anm-973",g_lang)
   MESSAGE l_str||l_cnt
END FUNCTION

#FUN-B50020
#FUN-BB0020---add-----str----
FUNCTION t811_pr_close()  #結案自動調整
DEFINE l_qty      LIKE pml_file.pml20
DEFINE l_sta      LIKE type_file.chr1           
DEFINE l_update   VARCHAR(1),
       l_pml      RECORD LIKE pml_file.*,
       l_vob      RECORD LIKE vob_file.*,
       l_cnt      SMALLINT,
       l_cntx     SMALLINT,
       l_pml16    LIKE pml_file.pml16,
       l_str      STRING,
       i          SMALLINT

   #詢問是否確定執行
   IF NOT cl_confirm('aap-017') THEN
      LET g_success = 'C'
      RETURN
   END IF

   LET l_str = cl_getmsg('aps-738',g_lang)
   MESSAGE l_str


   LET l_cnt = 0
   FOR i = 1 TO g_rec_b
      IF STATUS THEN
         RETURN
      END IF
      IF g_vob[i].vob36='Y' THEN
          SELECT * INTO l_pml.*
            FROM pml_file
           WHERE pml01 = g_vob[i].vob13
             AND pml02 = g_vob[i].itemno
          SELECT * INTO l_vob.*
            FROM vob_file
           WHERE vob00 = g_plant
             AND vob01 = g_vob01
             AND vob02 = g_vob02
             AND vob03 = g_vob[i].vob03
         LET l_qty = l_pml.pml20 - l_pml.pml21
         CALL t811_sta(l_qty) RETURNING l_sta    

         UPDATE pml_file SET pml16 = l_sta
          WHERE pml01 = l_pml.pml01
            AND pml02 = l_pml.pml02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err('upd pml16:',SQLCA.sqlcode,1)
            RETURN
         END IF
   
         LET l_cntx = 0
         SELECT COUNT(*) INTO l_cntx FROM pml_file
          WHERE pml01 = l_pml.pml01 
            AND pml16 NOT IN ('6','7','8','9')
         IF l_cntx = 0 THEN
            UPDATE pmk_file 
               SET pmk25 = '6',
                   pmk27 = g_today
             WHERE pmk01 = l_pml.pml01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               LET g_success = 'N'
               CALL cl_err("upd pmk25_9:",SQLCA.sqlcode,1)
               RETURN
            END IF
         END IF

         UPDATE pmk_file SET pmkmodu='aps',pmkdate=g_today
          WHERE pmk01 = l_pml.pml01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_success = 'N'
            CALL cl_err('upd pmk:',SQLCA.sqlcode,1)
            RETURN
         END IF

         UPDATE vob_file SET vob36='Y'
          WHERE vob00=g_plant
            AND vob01=g_vob01
            AND vob02=g_vob02
            AND vob03=g_vob[i].vob03

         LET l_cnt = l_cnt + 1  
      END IF
   END FOR 
   COMMIT WORK
   LET l_str = cl_getmsg("anm-973",g_lang) #成功筆數
   MESSAGE l_str||l_cnt
END FUNCTION

FUNCTION t811_sta(p_qty)
    DEFINE p_qty    LIKE pml_file.pml20
    DEFINE l_sta    LIKE type_file.chr1

     CASE      
       WHEN p_qty = 0 LET  l_sta = '6'
       WHEN p_qty > 0 LET  l_sta = '8'  ##(請購量-已轉採量)>0==>結短
       WHEN p_qty < 0 LET  l_sta = '7'  ##(請購量-已轉採量)<0==>結長
       OTHERWISE EXIT CASE 
     END CASE
     RETURN l_sta    
END FUNCTION       


#FUN-BB0020---add-----end----

#FUN-BB0025---add-----str----
FUNCTION t811_batch_pr_change()  #自動產生變更單
DEFINE l_vob13_t  LIKE vob_file.vob13    #FUN-B80004 add
DEFINE l_pmk      RECORD LIKE pmk_file.*,
       l_pml      RECORD LIKE pml_file.*,
       l_pne      RECORD LIKE pne_file.*,
       l_pnf      RECORD LIKE pnf_file.*,
       l_vob      RECORD LIKE vob_file.*,
       l_cnt,l_n  SMALLINT,
       l_name     LIKE type_file.chr1000,
       l_str      STRING,
       i          SMALLINT
DEFINE p_cmd      LIKE type_file.chr1

   #詢問是否確定執行
   IF NOT cl_confirm('aap-017') THEN
      LET g_success = 'C'
      RETURN
   END IF
  
   LET g_pne04 = ''
   CALL cl_init_qry_var()
   LET g_qryparam.form     = "q_azf01a" 
   LET g_qryparam.arg1     = 'B'        
   LET g_qryparam.default1 = ''
   CALL cl_create_qry() RETURNING g_pne04
   IF cl_null(g_pne04) THEN
      IF NOT cl_confirm('aps-760') THEN #理由碼空白，是否繼續?
         LET g_success = 'N'
         RETURN
      END IF
   END IF


   START REPORT t811_rep TO "apst811.txt"

   LET l_cnt = 0  

   CALL g_show_msg.clear() 
   LET g_err_cnt = 0       
   LET l_vob13_t = NULL 
   FOR i = 1 TO g_rec_b
      IF STATUS THEN
         RETURN
      END IF
    IF g_vob[i].vob36 = 'Y' THEN
        SELECT * INTO l_pmk.*
          FROM pmk_file
         WHERE pmk01 = g_vob[i].vob13
        SELECT * INTO l_pml.*
          FROM pml_file
         WHERE pml01 = g_vob[i].vob13
           AND pml02 = g_vob[i].itemno
        SELECT * INTO l_vob.*
          FROM vob_file
         WHERE vob00 = g_plant
           AND vob01 = g_vob01
           AND vob02 = g_vob02
           AND vob03 = g_vob[i].vob03
        IF cl_null(l_vob13_t) OR (l_vob13_t <> g_vob[i].vob13) THEN 
            #---->判斷此请购單,是否尚有未审核的變更單
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM pne_file
             WHERE pne01 = l_pmk.pmk01
               AND pne06 = 'N' #未审核
            IF l_n > 0 THEN                   
               CALL cl_getmsg('aps-810',g_lang) RETURNING g_msg #此請購單尚有未發出的請購變更單,請先處理請購變更單!
               LET g_err_cnt = g_err_cnt + 1
               LET g_show_msg[g_err_cnt].fld01 = l_pml.pml01
               LET g_show_msg[g_err_cnt].fld02 = l_pml.pml02
               LET g_show_msg[g_err_cnt].fld03 = g_status1
               LET g_show_msg[g_err_cnt].fld04 = g_msg
               CONTINUE FOR     
            END IF
        END IF 
        
        OUTPUT TO REPORT t811_rep(l_pmk.*,l_pml.*,l_vob.*)
        IF g_success = 'Y' THEN
           UPDATE vob_file SET vob36='Y'
            WHERE vob00=g_plant
              AND vob01=g_vob01
              AND vob02=g_vob02
              AND vob03=g_vob[i].vob03
           LET l_cnt = l_cnt + 1  
        
           LET g_err_cnt = g_err_cnt + 1
           LET g_show_msg[g_err_cnt].fld01 = l_pml.pml01
           LET g_show_msg[g_err_cnt].fld02 = l_pml.pml02
           LET g_show_msg[g_err_cnt].fld03 = g_status2
        END IF
    END IF
    LET l_vob13_t = g_vob[i].vob13 
   END FOR
   COMMIT WORK
   LET l_str = cl_getmsg("anm-973",g_lang) #成功筆數：
   MESSAGE l_str||l_cnt
   FINISH REPORT t811_rep
   CALL t811_show_msg() 

END FUNCTION

#FOR整批產生變更單
REPORT t811_rep(l_pmk,l_pml,l_vob)
DEFINE  l_pmk     RECORD LIKE pmk_file.*,
        l_pml     RECORD LIKE pml_file.*,
        l_pne     RECORD LIKE pne_file.*,
        l_pnf     RECORD LIKE pnf_file.*,
        l_vob     RECORD LIKE vob_file.*,
        l_t1      LIKE pmk_file.pmk01,
        l_cmd     STRING,
        p_cmd     LIKE type_file.chr1,
        l_ima49   LIKE ima_file.ima49,  
        l_ima491  LIKE ima_file.ima491  

ORDER EXTERNAL BY l_pml.pml01,l_pml.pml02

FORMAT

   BEFORE GROUP OF l_pml.pml01
      #產生採購變更單單頭
      INITIALIZE l_pne.* TO NULL
      LET l_pne.pne01 = l_pmk.pmk01
      SELECT max(pne02) INTO l_pne.pne02
        FROM pne_file
       WHERE pne01 = l_pne.pne01
      IF cl_null(l_pne.pne02) THEN
         LET l_pne.pne02 = 1
      ELSE
         LET l_pne.pne02 = l_pne.pne02 + 1
      END IF
      LET l_pne.pne03 = g_today                #變更日期
      LET l_pne.pne04 = g_pne04                #變更理由
      LET l_pne.pne05 = tm.pne05               #變更人員
      LET l_pne.pne06 = 'N'                    #確認否
      LET l_pne.pne09 = l_pmk.pmk22            #變更前幣別
      LET l_pne.pne14 = '0'                    #狀況碼
      LET l_pne.pneacti = 'Y'                  #資料有效碼
      LET l_pne.pneconf = 'N'                  #發出否
      LET l_pne.pnedate = g_today
      LET l_pne.pnegrup = g_grup
      LET l_pne.pnelegal = g_legal             #所屬法人
      LET l_t1 = s_get_doc_no(l_pne.pne01)     #簽核否
      SELECT smyapr INTO l_pne.pnemksg FROM smy_file
       WHERE smyslip = l_t1
      IF cl_null(l_pne.pnemksg) THEN LET l_pne.pnemksg = 'N' END IF
      LET l_pne.pnemodu = g_user
      LET l_pne.pneorig = g_grup
      LET l_pne.pneoriu = g_user
      LET l_pne.pneplant = g_plant             #所屬營運中心
      LET l_pne.pneuser = g_user

      INSERT INTO pne_file VALUES(l_pne.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","pne_file",l_pne.pne01,'',SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF

   ON EVERY ROW
      #產生採購變更單單身
      INITIALIZE l_pnf.* TO NULL
      LET l_pnf.pnf01 = l_pne.pne01
      LET l_pnf.pnf02 = l_pne.pne02
      LET l_pnf.pnf03 = l_pml.pml02
      LET l_pnf.pnf041b = l_pml.pml041
      LET l_pnf.pnf04b = l_pml.pml04
      LET l_pnf.pnf07b = l_pml.pml07
      LET l_pnf.pnf121b = l_pml.pml121
      LET l_pnf.pnf122b = l_pml.pml122
      LET l_pnf.pnf12b = l_pml.pml12
      LET l_pnf.pnf20a = l_vob.vob33 #數量
      LET l_pnf.pnf20b = l_pml.pml20
      #變更後原始交貨日期 = 系統規劃抵達日期 
      LET l_pnf.pnf33a = l_vob.vob14    
      IF l_pnf.pnf33a < g_today THEN
         LET l_pnf.pnf33a = g_today
      END IF
      LET l_pnf.pnf33b = l_pml.pml33
      LET l_pnf.pnf41b = l_pml.pml41
      LET l_pnf.pnf80b = l_pml.pml80
      LET l_pnf.pnf81b = l_pml.pml81
      LET l_pnf.pnf82b = l_pml.pml82
      LET l_pnf.pnf83b = l_pml.pml83
      LET l_pnf.pnf84b = l_pml.pml84
      LET l_pnf.pnf85b = l_pml.pml85
      LET l_pnf.pnf86b = l_pml.pml86
      LET l_pnf.pnf87b = l_pml.pml87
      LET l_pnf.pnflegal = g_legal #所屬法人
      LET l_pnf.pnfplant = g_plant #所屬營運中心

      INSERT INTO pnf_file VALUES(l_pnf.*)
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err3("ins","pnf_file",l_pne.pne01,l_pml.pml02,SQLCA.sqlcode,"","",1)
      END IF

END REPORT
FUNCTION t811_show_msg()
  CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
  CALL cl_get_feldname('pml01',g_lang) RETURNING g_fld01
  CALL cl_get_feldname('pml02',g_lang) RETURNING g_fld02
  CALL cl_get_feldname('fbh05',g_lang) RETURNING g_fld03
  CALL cl_get_feldname('aab03',g_lang) RETURNING g_fld04
  LET g_msg2 = g_fld01 CLIPPED,'|',g_fld02 CLIPPED,'|',
               g_fld03 CLIPPED,'|',g_fld04 CLIPPED
  CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg,g_msg2)
END FUNCTION

FUNCTION t811_peo(p_key)
         DEFINE p_cmd       LIKE type_file.chr1,  
                p_key       LIKE gen_file.gen01,
                l_gen02     LIKE gen_file.gen02,
                l_genacti   LIKE gen_file.genacti
 
        LET g_errno = ' '
        SELECT gen02,genacti INTO l_gen02,l_genacti
            FROM gen_file WHERE gen01 = p_key
 
        CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                       LET l_gen02 = NULL
               WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
        DISPLAY l_gen02 TO FORMONLY.gen02
END FUNCTION

FUNCTION t811_set_entry()
   CALL cl_set_comp_entry("pne05",TRUE)
END FUNCTION
 
FUNCTION t811_set_no_entry()
  IF tm.hstatus <> 'C' THEN
      CALL cl_set_comp_entry("pne05",FALSE)
  END IF
END FUNCTION

FUNCTION t811_set_required()
  IF tm.hstatus = 'C' THEN
      CALL cl_set_comp_required("pne05",TRUE)
  END IF
END FUNCTION

FUNCTION t811_set_no_required()
   CALL cl_set_comp_required("pne05",FALSE)
END FUNCTION
#FUN-BB0025---add-----end----
