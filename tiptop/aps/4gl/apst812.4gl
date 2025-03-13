# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: apst812.4gl
# Descriptions...: APS 採購建議調整維護作業
# Create         : FUN-950004 09/05/05 By Duke  
# Modify.........: FUN-A30083 10/03/24 By lilan 採購調整的整批採購調整功能異動成功,但...
#                             (1)單頭:未稅/含稅總金額(pmm40/pmm40t)沒有跟著動 
#                             (2)單身:未稅/含稅金額(pmn88/pmn88t)沒有跟著動  
#                             (3)來源項次要改show vob03,但此欄位值為"PR5-690001-0001",需拆解抓出項次來
# Modify.........: No:FUN-B50020 11/05/09 By Lilan APS GP5.1追版至GP5.25
# Modify.........: No:FUN-B60047 11/06/08 By Mandy (1)功能"整批採購調整","整批產生變更單","作廢自動調整"
#                                                     資料的來源應直接用查詢出單身的SQL(_b_fill),不要重新抓取,避免取得的資料不一致
#                                                  (2)功能"整批產生變更單",show出最後產生變更單的狀況
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:FUN-B80004 11/07/31 By Mandy 功能"整批產生變更單",若採購單號相同,應併單處理
# Modify.........: No:FUN-BB0020 11/11/03 By Mandy 增加"結案自動調整"功能
# Modify.........: No:FUN-910088 12/01/31 By chenjing 增加數量欄位小數取位
# Modify.........: No:FUN-C40041 13/01/17 By Nina 在b_fill()段修正判斷ischang的條件，將pmn35<>vob04改成用pmn34<>vob04

DATABASE ds

GLOBALS "../../config/top.global"

#FUN-950004

#模組變數(Module Variables)
DEFINE   g_vob01              LIKE vob_file.vob01,      #APS版本  (假單頭)
         g_vob02              LIKE vob_file.vob02,      #儲存版本 (假單頭)
         g_vob03              LIKE vob_file.vob03,      #
         g_debug              LIKE type_file.chr1,      #檢查用
         g_vob01_t            LIKE vob_file.vob01,      #APS版本  (假單頭)
         g_vob02_t            LIKE vob_file.vob02,      #儲存版本 (假單頭)
         g_vob              DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
            vob36             LIKE vob_file.vob36,      #
            status            LIKE type_file.chr1,      #建議狀態
            vob13             LIKE vob_file.vob13,      #
            pmm25             LIKE pmm_file.pmm25,      #狀況碼
            pmm12             LIKE pmm_file.pmm12,      #請採購人員
            pmm09             LIKE pmm_file.pmm09,      #廠商
           #vaz23             LIKE vaz_file.vaz23,      #FUN-A30083 mark
            itemno            LIKE type_file.num5,      #FUN-A30083 add
            vob07             LIKE vob_file.vob07,      #
            ima02             LIKE ima_file.ima02,      #
            vob11             LIKE vob_file.vob11,      #
            ischange          LIKE vob_file.vob36,      #來源已異動
            pmn20             LIKE pmn_file.pmn20,      #
            unst_qty          LIKE pmn_file.pmn20,      #
            vob33             LIKE vob_file.vob33,      #
            qty               LIKE pmn_file.pmn20,      #
            pmn34             LIKE pmn_file.pmn34,      #
            vob14             LIKE vob_file.vob14,
            pmn35             LIKE pmn_file.pmn35,      #
            vob40             LIKE vob_file.vob40,      #
            isgenerate        LIKE type_file.num5,      #產生變更單  
            vob17             LIKE vob_file.vob17,      #
            vob42             LIKE vob_file.vob42,      #
            vob08             LIKE vob_file.vob08,       #
            vob20             LIKE vob_file.vob20,
            vob04             LIKE vob_file.vob04,
            vob03             LIKE vob_file.vob03
                             END RECORD,
         g_vob_t             RECORD                     #程式變數 (舊值)
            vob36             LIKE vob_file.vob36,      #
            status            LIKE type_file.chr1,      #建議狀態
            vob13             LIKE vob_file.vob13,      #
            pmm25             LIKE pmm_file.pmm25,      #狀況碼
            pmm12             LIKE pmm_file.pmm12,      #
            pmm09             LIKE pmm_file.pmm09,      #
           #vaz23             LIKE vaz_file.vaz23,      #FUN-A30083 mark
            itemno            LIKE type_file.num5,      #FUN-A30083 add
            vob07             LIKE vob_file.vob07,      #
            ima02             LIKE ima_file.ima02,      #
            vob11             LIKE vob_file.vob11,      #
            ischange          LIKE vob_file.vob36,      #來源已異動
            pmn20             LIKE pmn_file.pmn20,      #
            unst_qty          LIKE pmn_file.pmn20,      #
            vob33             LIKE vob_file.vob33,      #
            qty               LIKE pmn_file.pmn20,      #
            pmn34             LIKE pmn_file.pmn34,      #
            vob14             LIKE vob_file.vob14,
            pmn35             LIKE pmn_file.pmn35,      #
            vob40             LIKE vob_file.vob40,
            isgenerate        LIKE type_file.num5,      #產生變更單
            vob17             LIKE vob_file.vob17,       #
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
             pna16   LIKE pna_file.pna16 #FUN-B50020 add
             END RECORD,
         g_sql          STRING,
        #g_vob_rowid         LIKE type_file.chr18,     #FUN-B50020 mark
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
DEFINE   g_pna15            LIKE pna_file.pna15     
DEFINE   g_change_lang      LIKE type_file.chr1
#FUN-B60047--add---str---
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
DEFINE g_msg2          LIKE ze_file.ze03 
#FUN-B60047--add---end---

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

   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
      RETURNING g_time
   LET g_argv1 = ARG_VAL(1)
   LET g_vob01 = NULL                     #清除鍵值
   LET g_vob02 = NULL                     #清除鍵值
   LET g_vob01_t = NULL
   LET g_vob02_t = NULL
   LET p_row = 4 LET p_col = 20

   OPEN WINDOW apst812_w AT p_row,p_col WITH FORM "aps/42f/apst812"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_set_comp_visible("vob08,vob20,vob04,vob03",FALSE)  
   CALL cl_set_comp_entry('pmm25,pmm12,pmm09,vob07,vob11,vob14,vob40',FALSE)


   LET g_debug = 'Y'
   IF NOT cl_null(g_argv1) THEN CALL t812_q() END IF

   CALL cl_getmsg('abm-020',g_lang) RETURNING g_status1 #執行失敗 #FUN-B60047 add
   CALL cl_getmsg('abm-019',g_lang) RETURNING g_status2 #執行成功 #FUN-B60047 add

   CALL t812_menu()
   CLOSE WINDOW apst812_w               #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
      RETURNING g_time
END MAIN

FUNCTION t812_curs()
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
                LET g_qryparam.arg1 = g_plant
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

     #LET tm.hstatus = NULL  #FUN-B50020 mark
      LET tm.hstatus = 'B'   #FUN-B50020 add
      INPUT BY NAME tm.hstatus,tm.pna16 WITHOUT DEFAULTS  #FUN-B50020 add pna16

         BEFORE FIELD hstatus
           #LET tm.hstatus = 'B'         #FUN-B50020 mark
           #DISPLAY BY NAME tm.hstatus   #FUN-B50020 mark
            CALL t812_set_entry()        #FUN-B50020 add
            CALL t812_set_no_required()  #FUN-B50020 add

         AFTER FIELD hstatus
            IF cl_null(tm.hstatus) THEN
               NEXT FIELD hstatus
            END IF 
            IF tm.hstatus = 'C' THEN
                LET tm.pna16 = g_user
                CALL t812_peo(tm.pna16)
            ELSE
                LET tm.pna16 = ''
                DISPLAY BY NAME tm.pna16
                DISPLAY '' TO FORMONLY.gen02
            END IF
            CALL t812_set_no_entry() #FUN-B50020 add
            CALL t812_set_required() #FUN-B50020 add
         #FUN-B50020---add---str---
         AFTER FIELD pna16  #變更人員
               IF NOT cl_null(tm.pna16) THEN
                  CALL t812_peo(tm.pna16)
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(tm.pna16,g_errno,1)  
                      LET tm.pna16 = ''
                      DISPLAY BY NAME tm.pna16
                      DISPLAY '' TO FORMONLY.gen02
                      NEXT FIELD pna16 
                  END IF
               END IF
         ON ACTION CONTROLP
            CASE      #查詢符合條件的單號
                 WHEN INFIELD(pna16) #變更人員
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = tm.pna16
                     CALL cl_create_qry() RETURNING tm.pna16 
                     DISPLAY BY NAME tm.pna16
                     CALL t812_peo(tm.pna16)
                     NEXT FIELD pna16 
                OTHERWISE EXIT CASE
              END CASE
         #FUN-B50020---add---end---
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

  #FUN-A30083 mod str----------
   LET g_sql = "SELECT UNIQUE vob01,vob02 ",
              #"  FROM voc_file,vob_file,vaz_file,pmm_file ",
              #"  FROM voc_file,vob_file,pmm_file ",                                  #FUN-B50020 mark
               "  FROM voc_file,vob_file LEFT OUTER JOIN pmm_file ON vob13 = pmm01 ", #FUN-B50020 add
               " WHERE voc00=vob00          ",
               "   AND voc01=vob01          ",
               "   AND voc02=vob02          ",
               "   AND voc03=vob03          ",
              #"   AND vaz01=vob03          ",
               "   AND vob05='0'            ",
              #"   AND vaz10=vob13          ",
              #"   AND vaz24='1'            ",
               "   AND vob00 = '",g_plant,"'",
              #"   AND vob13=pmm01    ", #FUN-B50020 mark
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND (voc04<>'0' or voc05<>'0') "
  #FUN-A30083 mod end----------


   DISPLAY g_sql
   PREPARE t812_prepare FROM g_sql      #預備一下
   DECLARE t812_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t812_prepare

   DROP TABLE count_tmp

   LET g_sql = g_sql," INTO TEMP count_tmp "

   PREPARE t812_cnt_tmp  FROM g_sql
   EXECUTE t812_cnt_tmp
   DECLARE t812_count CURSOR FOR SELECT COUNT(*) FROM count_tmp

END FUNCTION


FUNCTION q810_b_askkey()
   CONSTRUCT tm.wc2 ON vob36,vob13,pmm25,pmm12,pmm09,
                      #vaz23,                         #FUN-A30083 mark
                       itemno,                        #FUN-A30083 add
                       vob07,ima02,vob11,pmn20,vob33,
                       pmn34,   
                       vob14,pmn35,vob40,vob17,vob42      
        FROM s_vob[1].vob36,
             s_vob[1].vob13,s_vob[1].pmm25,
             s_vob[1].pmm12,s_vob[1].pmm09,
            #s_vob[1].vaz23,                          #FUN-A30083 mark
             s_vob[1].itemno,                         #FUN-A30083 add
             s_vob[1].vob07,s_vob[1].ima02,
             s_vob[1].vob11,s_vob[1].pmn20,
             s_vob[1].vob33,s_vob[1].pmn34,s_vob[1].vob14,
             s_vob[1].pmn35,s_vob[1].vob40,s_vob[1].vob17,
             s_vob[1].vob42


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
           WHEN INFIELD(pmm12)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmk8"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_vob[1].pmm12
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmm12
              NEXT FIELD pmm12
          WHEN INFIELD(pmm09)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmk9"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_vob[1].pmm09
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO pmm09
             NEXT FIELD pmm09
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


FUNCTION t812_menu()

   WHILE TRUE
      CALL t812_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t812_q()
            END IF
         WHEN "next"
            CALL t812_fetch('N')
         WHEN "previous"
            CALL t812_fetch('P')

         WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL t812_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN  "help"
            CALL cl_show_help()
         WHEN  "exit"
            EXIT WHILE
         WHEN  "jump"
            CALL t812_fetch('/')
         WHEN  "first"
            CALL t812_fetch('F')
         WHEN  "last"
            CALL t812_fetch('L')
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
                  IF t812_pick('A') THEN
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
                 IF t812_pick('E') THEN
                    MESSAGE 'No Rows can be chosen'
                 END IF
              END IF
            END IF
  
         WHEN "po_detail"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF g_rec_b > 0 AND l_ac > 0 THEN
                  IF g_vob[l_ac].status='B' or g_vob[l_ac].status='C' or
                     g_vob[l_ac].status='D' or g_vob[l_ac].status='E' or
                     g_vob[l_ac].status='F' or g_vob[l_ac].status='G' THEN
                     LET g_msg = " apmt540 '", g_vob[l_ac].vob13,"'"
                     CALL cl_cmdrun_wait(g_msg CLIPPED)
                  END IF
               END IF
            END IF

         #整批採購調整
         WHEN "batch_po_adjust"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN
                  LET g_success = 'Y'
                  BEGIN WORK
                  CALL t812_batch_po_adjust()
                  IF g_success !='C' THEN
                     CALL cl_err('','afa-116',1)
                  END IF
                  CALL t812_b_fill()
               END IF
            END IF
  
         #整批產生變更單
         WHEN "batch_po_change"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN
                  LET g_success = 'Y'
                  BEGIN WORK
                  CALL t812_batch_po_change()
                  IF g_success !='C' THEN
                     CALL cl_err('','afa-116',1)
                  END IF
                  CALL t812_b_fill()
               END IF
            END IF 

         #作廢自動調整
         WHEN "chg_void"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN
                  LET g_success = 'Y'
                  BEGIN WORK
                  CALL t812_chg_void()
                  IF g_success !='C' THEN
                     CALL cl_err('','afa-116',1)
                  END IF
                  CALL t812_b_fill()
               END IF
            END IF
        #FUN-BB0020--add----str----
         #結案自動調整
         WHEN "auto_batch_close"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF cl_chk_act_auth() THEN
                  LET g_success = 'Y'
                  BEGIN WORK
                  CALL t812_chg_close()
                  IF g_success !='C' THEN
                     CALL cl_err('','afa-116',1)
                  END IF
                  CALL t812_b_fill()                   
               END IF
            END IF 
        #FUN-BB0020--add----end----
      END CASE
   END WHILE
END FUNCTION

FUNCTION t812_q()

   LET g_row_count = 0
   LET mi_curs_index = 0
   CALL cl_navigator_setting(mi_curs_index,g_row_count)

   MESSAGE ""
   CALL cl_opmsg('q')

   CALL t812_curs()                           #取得查詢條件

   IF INT_FLAG THEN                           #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t812_count
    FETCH t812_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt

   OPEN t812_b_curs                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                      #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_vob01 TO NULL
      INITIALIZE g_vob02 TO NULL
   ELSE
      CALL t812_fetch('F')                    #讀出TEMP第一筆並顯示
   END IF

END FUNCTION

FUNCTION t812_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,     #處理方式
            l_abso   LIKE type_file.num10     #絕對的筆數

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t812_b_curs INTO g_vob01,g_vob02
      WHEN 'P' FETCH PREVIOUS t812_b_curs INTO g_vob01,g_vob02
      WHEN 'F' FETCH FIRST    t812_b_curs INTO g_vob01,g_vob02
      WHEN 'L' FETCH LAST     t812_b_curs INTO g_vob01,g_vob02
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
      FETCH ABSOLUTE mi_jump t812_b_curs INTO g_vob01,g_vob02
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
      CALL t812_show()
   END IF

END FUNCTION

FUNCTION t812_show()

   CLEAR FROM
   CALL g_vob.clear()
   DISPLAY g_vob01 TO FORMONLY.vob01              #單頭
   DISPLAY g_vob02 TO FORMONLY.vob02              #單頭
   LET g_vob01_t = g_vob01
   LET g_vob02_t = g_vob02
   CALL t812_b_fill()    
END FUNCTION

FUNCTION t812_b()
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

   LET g_forupd_sql =
                     "SELECT vob36 ",
                     "  FROM vob_file    ",
                     " WHERE vob00=? AND vob01=? AND vob02=? AND vob03=? FOR UPDATE "

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)    #FUN-B50020 add
   
   DECLARE t812_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR

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
            OPEN t812_b_curl USING g_plant,g_vob01,g_vob02,g_vob[l_ac].vob03
            IF STATUS THEN
               CALL cl_err("OPEN t812_b_cur1:",STATUS,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t812_b_curl INTO g_vob[l_ac].vob36
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
            CLOSE t812_b_curl
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
            CLOSE t812_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE t812_b_curl
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

   CLOSE t812_b_curl
   COMMIT WORK

END FUNCTION


FUNCTION t812_b_fill()              #BODY FILL UP
DEFINE g_wc  STRING

DEFINE l_pmk25 LIKE pmk_file.pmk25,
       l_pml20 LIKE pml_file.pml20,
       l_pmm25 LIKE pmm_file.pmm25,
       l_pmn50 LIKE pmn_file.pmn50,
       l_pmn20 LIKE pmn_file.pmn20,
       l_pml21 LIKE pml_file.pml21, 
       l_pml35 LIKE pml_file.pml35, 
       l_pmn5358 LIKE pmn_file.pmn53, 
      #l_pmn35 LIKE pmn_file.pmn35,    #FUN-C40041 mark
       l_pmn34 LIKE pmn_file.pmn34,    #FUN-C40041 add
       l_gen   LIKE type_file.num5  

  #FUN-A30083 mod str -----------------
   LET g_sql = "SELECT vob36,'',vob13,pmm25,gen02,pmc03, ",
              #"       vaz23, ",
               "       cast(substr(vob03,length(vob03)-3,4) as int), ",
               "       vob07,ima02,vob11,'',pmn20, ",
               "       pmn20-pmn50+pmn55,vob33,vob33-pmn20,pmn34,vob14,pmn35,vob40,'', ",
               "       vob17,vob42,vob08,vob20,vob04,vob03   ",
              #"  FROM voc_file,vob_file,vaz_file,pmm_file,pmn_file,ima_file,gen_file,pmc_file ",
              #FUN-B0020--mod---str---
              #"  FROM voc_file,vob_file,pmm_file,pmn_file,ima_file,gen_file,pmc_file ", #FUN-B50020 mark
               "  FROM voc_file,pmn_file,",
               "       vob_file LEFT OUTER JOIN ima_file ON vob07 = ima01 ",
               "                LEFT OUTER JOIN pmm_file ON vob13 = pmm01 ",
               "                LEFT OUTER JOIN gen_file ON pmm12 = gen01 ", 
               "                LEFT OUTER JOIN pmc_file ON pmm09 = pmc01 ",
              #FUN-B0020--mod---end---
               " WHERE voc00=vob00",
               "   AND voc01=vob01          ",
               "   AND voc02=vob02          ",
               "   AND voc03=vob03          ",
              #"   AND vaz01=vob03          ",
               "   AND vob05='0'            ",
              #"   AND vob07=ima01(+)    ",   #FUN-B50020 mark
              #"   AND pmm12=gen01(+)    ",   #FUN-B50020 mark
              #"   AND pmm09=pmc01(+)    ",   #FUN-B50020 mark
               "   AND vob13=pmn01 ",                                         #採購單單號
               "   AND pmn02=cast(substr(vob03,length(vob03)-3,4) as int) ",  #採購單項次
              #"   AND vaz10=vob13          ",
               "   AND vob01 = '",g_vob01,"'",
               "   AND vob02 = '",g_vob02,"'",
               "   AND vob00 = '",g_plant,"'",
              #"   AND vaz24 = '1' ",
              #"   AND vob13=pmm01(+) ", #FUN-B50020 mark
              #"   AND vaz10=pmn01(+) ",
              #"   AND vaz23=pmn02(+) ",
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND (voc04<>'0' or voc05<>'0') ",
               "   AND pmm18 <>'X' ",
               "   AND (vob36<>'Y' OR vob36 IS NULL) "
  #FUN-A30083 mod end ---------------------

   CASE tm.hstatus
      WHEN 'D'
           LET g_sql = g_sql , " AND ((pmm25  IN ('6','9') AND vob33>0) OR  ",
                               "      (pmm25='2' AND pmn20-pmn50+pmn55<pmn20-vob33) OR",
                               "      (pmm25 = 'S') ",
                               "     ) "
      WHEN  'B'
           LET g_sql = g_sql , " AND pmm25 IN ('0','R','W')  AND vob33>0",
                              #" AND (to_date(vob14)<>to_date(pmn34) OR ",               #FUN-B50020 mark
                               " AND ((CAST(vob14 AS DATE) <> CAST(pmn34 AS DATE)) OR ", #FUN-B50020 add
                               "      (vob33 <> pmn20) OR ",
                              #"      to_date(vob40)<>to_date(pmn35)) "                  #FUN-B50020 mark
                               "      (CAST(vob40 AS DATE) <> CAST(pmn35 AS DATE)))"     #FUN-B50020 add
      WHEN 'C'
           LET g_sql = g_sql , " AND (pmm25 ='2' and vob33 > 0) ",
                               " AND ((vob33>pmn20) OR ",
                               "      (vob33<pmn20 AND pmn20-pmn50+pmn55>=pmn20-vob33) OR ",
                              #"      (vob33=pmn20 AND (to_date(vob14)<>to_date(pmn34) OR to_date(vob40)<>to_date(pmn35)))",   #FUN-B50020 mark
                              #FUN-B50020 add str ----------------
                               "      (vob33=pmn20 AND ",                                                   
                               "       ((CAST(vob14 AS DATE) <> CAST(pmn34 AS DATE)) OR (CAST(vob40 AS DATE) <> CAST(pmn35 AS DATE))",
                               "      ))",
                              #FUN-B50020 add end ----------------
                               "     ) "
      WHEN 'E'
           LET g_sql = g_sql , " AND pmm25 IN  ('0','R','W') AND vob33 = 0 "
      WHEN 'F'
           LET g_sql = g_sql , " AND pmm25 = '1' AND vob33 > 0 ",
                              #" AND (to_date(vob14)<>to_date(pmn34) OR vob33<>pmn20 OR to_date(vob40)<>to_date(pmn35) ) "  #FUN-B50020 mark
                               " AND ((CAST(vob14 AS DATE) <> CAST(pmn34 AS DATE)) OR (vob33<>pmn20) OR (CAST(vob40 AS DATE) <> CAST(pmn35 AS DATE)))"   #FUN-B50020 add
      WHEN 'G'
           LET g_sql = g_sql , " AND pmm25 in ('1','2') AND vob33 = 0 "
   END CASE
   LET g_sql = g_sql CLIPPED," ORDER BY vob03" #FUN-B80004 add
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

      #發出變更處理判斷
      SELECT COUNT(*) INTO l_gen FROM pna_file
       WHERE pna01 = g_vob[g_cnt].vob13
         AND pnaconf = 'N'
      IF l_gen > 0 THEN
         LET g_vob[g_cnt].isgenerate=1
      ELSE
         LET g_vob[g_cnt].isgenerate=0
      END IF

          # ischange
           #select pmn20,pmn53-pmn58,pmn35      #FUN-C40041 mark
           #  into l_pmn20,l_pmn5358,l_pmn35    #FUN-C40041 mark
            select pmn20,pmn53-pmn58,pmn34      #FUN-C40041 add 
              into l_pmn20,l_pmn5358,l_pmn34    #FUN-C40041 add
              from pmn_file
             where pmn01=g_vob[g_cnt].vob13
               and pmn02=g_vob[g_cnt].itemno      #FUN-A30083 mod:vaz23 =>itemno
           #if l_pmn20<>g_vob[g_cnt].vob08 or l_pmn5358<>g_vob[g_cnt].vob20 or l_pmn35<>g_vob[g_cnt].vob04 then    #FUN-C40041 mark
            if l_pmn20<>g_vob[g_cnt].vob08 or l_pmn5358<>g_vob[g_cnt].vob20 or l_pmn34<>g_vob[g_cnt].vob04 then    #FUN-C40041 add
               let g_vob[g_cnt].ischange='Y'
            else
               let g_vob[g_cnt].ischange='N'
            end if

          #status
          LET g_vob[g_cnt].status = tm.hstatus
          # SELECT pmm25 INTO l_pmm25 FROM pmm_file WHERE pmm01=g_vob[g_cnt].vob13
          #  IF l_pmm25='0' AND g_vob[g_cnt].vob33>0 AND
          #     (g_vob[g_cnt].vob14<>g_vob[g_cnt].pmn34 OR g_vob[g_cnt].vob33<>l_pmn20) THEN  
          #     LET g_vob[g_cnt].status='B'
          #  END IF
          #  IF (l_pmm25='2' AND g_vob[g_cnt].vob33>0 ) AND 
          #     ((g_vob[g_cnt].vob33>l_pmn20)  OR 
          #      (g_vob[g_cnt].vob33<l_pmn20 AND g_vob[g_cnt].unst_qty >= l_pmn20-g_vob[g_cnt].vob33) OR
          #      (g_vob[g_cnt].vob14<>g_vob[g_cnt].pmn34) ) THEN
          #     LET g_vob[g_cnt].status='C'
          #  END IF
          #  IF ((l_pmm25<>'0' AND l_pmm25<>'1' AND l_pmm25<>'2' AND g_vob[g_cnt].vob33>0 ) OR
          #     (g_vob[g_cnt].unst_qty < l_pmn20-g_vob[g_cnt].vob33  OR g_vob[g_cnt].vob14<>g_vob[g_cnt].pmn34)) OR
          #     (l_pmm25='S' AND g_vob[g_cnt].vob33=0) THEN
          #     LET g_vob[g_cnt].status='D'
          #  END IF
          #  #若存在未發出之變更單時，必須列為不可調整
　　　　  #　IF g_vob[g_cnt].isgenerate=1 THEN
          #     LET g_vob[g_cnt].status='D'
          #  END IF　　　　　　
          #  IF ((l_pmm25='0' OR l_pmm25='S' OR l_pmm25='W')  AND g_vob[g_cnt].vob33=0) THEN
          #     LET g_vob[g_cnt].status='E'
          #  END IF
          #  IF (l_pmm25='1' AND g_vob[g_cnt].vob33>0) AND
          #     (g_vob[g_cnt].vob14<>g_vob[g_cnt].pmn34 OR g_vob[g_cnt].vob33<>l_pmn20) THEN
          #     LET g_vob[g_cnt].status='F'
          #  END IF
          #  IF ((l_pmm25='1' OR l_pmm25='2') AND g_vob[g_cnt].vob33=0) THEN
          #     LET g_vob[g_cnt].status='G'
          #  END IF


      LET g_rec_b = g_rec_b + 1
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_vob.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0

END FUNCTION

FUNCTION t812_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_vob TO s_vob.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(mi_curs_index,g_row_count)
         CALL cl_set_action_active("batch_po_adjust,batch_po_change,chg_void",FALSE)
         CALL cl_set_action_active("auto_batch_close",FALSE)  #FUN-BB0020 add
      CASE
         WHEN tm.hstatus='B' 
            CALL cl_set_action_active("batch_po_adjust",TRUE)
         WHEN tm.hstatus='C'
            CALL cl_set_action_active("batch_po_change",TRUE)
         WHEN tm.hstatus='E'
            CALL cl_set_action_active("chg_void",TRUE)
         WHEN tm.hstatus='G'                                   #FUN-BB0020 add
            CALL cl_set_action_active("auto_batch_close",TRUE) #FUN-BB0020 add
      END CASE

      BEFORE ROW
         LET l_ac = ARR_CURR()
         #CALL cl_show_fld_cont()

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
         CALL t812_fetch('F')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL t812_fetch('P')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)
           END IF
	 ACCEPT DISPLAY

      ON ACTION jump
         CALL t812_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION last
         CALL t812_fetch('L')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY

      ON ACTION next
         CALL t812_fetch('N')
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

      ON ACTION po_detail #採購單維護
         LET g_action_choice="po_detail"
         EXIT DISPLAY

      ON ACTION batch_po_adjust  #整批採購調整
         LET g_action_choice="batch_po_adjust"
         EXIT DISPLAY

      ON ACTION batch_po_change  #整批產生採購變更單
         LET g_action_choice="batch_po_change"
         EXIT DISPLAY

      ON ACTION chg_void  #自動作廢
         LET g_action_choice="chg_void"
         EXIT DISPLAY

     #FUN-BB0020----add-----str---
      ON ACTION auto_batch_close #結案自動調整
         LET g_action_choice="auto_batch_close"
         EXIT DISPLAY
     #FUN-BB0020----str-----end---

      AFTER DISPLAY
         CONTINUE DISPLAY

    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
    CALL cl_set_action_active("batch_po_adjust,batch_po_change,chg_void",TRUE)
END FUNCTION

#作廢
FUNCTION t812_chg_void()
DEFINE l_update   VARCHAR(1),
       l_pmn      RECORD LIKE pmn_file.*,
       l_cnt      SMALLINT,
       l_pmn16    LIKE pmn_file.pmn16,
       l_str      STRING,
       l_vob      RECORD LIKE vob_file.*,
       l_n1,l_n2  SMALLINT,
       i          SMALLINT

   #詢問是否確定執行
   IF NOT cl_confirm('aap-017') THEN
      LET g_success = 'C'
      RETURN
   END IF

   LET l_str = cl_getmsg('aps-738',g_lang) #電腦產生中
   MESSAGE l_str

 #FUN-B60047--mark---str--
 ##FUN-A30083 mod str ---------------
 # LET g_sql = "SELECT UNIQUE pmn_file.*,vob_file.* ",
 #            #"  FROM voc_file,vob_file,vaz_file,pmm_file,pmn_file,",
 #             "  FROM voc_file,vob_file,pmm_file,pmn_file,",
 #             "       ima_file ",
 #             " WHERE voc00=vob00",
 #             "   AND voc01=vob01          ",
 #             "   AND voc02=vob02          ",
 #             "   AND voc03=vob03          ",
 #            #"   AND vaz01=vob03          ",
 #            #"   AND vaz10=vob13          ",
 #             "   AND vob01 = '",g_vob01,"'",
 #             "   AND vob02 = '",g_vob02,"'",
 #             "   AND vob00 = '",g_plant,"'",
 #             "   AND ",tm.wc CLIPPED,
 #             "   AND ",tm.wc2 CLIPPED,
 #             "   AND (voc04<>'0' or voc05<>'0') ",
 #            #"   AND vaz24 = '1' ",
 #            #"   AND vaz23 = pmn02 ",
 #             "   AND vob13=pmn01 ",                                         #採購單單號
 #             "   AND pmn02=cast(substr(vob03,length(vob03)-3,4) as int) ",  #採購單項次
 #             "   AND vob05 = '0' ",
 #             "   AND vob33 = 0 ",
 #             "   AND pmn01 = pmm01 ",
 #             "   AND pmn16 in ('0','R','W') ",
 #             "   AND ima01 = pmn04 ",
 #             "  ORDER BY pmn01,pmn02"
 ##FUN-A30083 mod end ---------------


 # PREPARE t812_ch_void_p FROM g_sql
 # DECLARE t812_ch_void_cs CURSOR FOR t812_ch_void_p
 #FUN-B60047--mark---end--
   LET l_cnt = 0 
  #FOREACH t812_ch_void_cs INTO l_pmn.*,l_vob.* #FUN-B60047 mark
   FOR i = 1 TO g_rec_b
      IF STATUS THEN
         #LET g_success = 'N'
         #CALL cl_err('foreach t812_ch_void_cs:',STATUS,1)
         RETURN
      END IF

     #FUN-B60047--mod---str--
     #IF g_vob[i].vob03 = l_vob.vob03 AND g_vob[i].vob36='Y' THEN
      IF g_vob[i].vob36 = 'Y' THEN
         SELECT * INTO l_pmn.*
           FROM pmn_file
          WHERE pmn01 = g_vob[i].vob13
            AND pmn02 = g_vob[i].itemno
         SELECT * INTO l_vob.*
           FROM vob_file
          WHERE vob00 = g_plant
            AND vob01 = g_vob01
            AND vob02 = g_vob02
            AND vob03 = g_vob[i].vob03
   #FUN-B60047--mod---end--
         UPDATE pmn_file SET pmn16 = '9' #作廢
          WHERE pmn01 = l_pmn.pmn01
            AND pmn02 = l_pmn.pmn02
         IF STATUS THEN
            CALL cl_err('upd pmn',status,1)
            LET g_success = 'N'
         END IF
         UPDATE pmm_file SET pmmmodu='aps',pmmdate=g_today
           WHERE pmm01 = l_pmn.pmn01

         LET l_n1 = 0
         SELECT COUNT(*) INTO l_n1 FROM pmn_file
          WHERE pmn01 = l_pmn.pmn01
          IF cl_null(l_n1) THEN LET l_n1 = 0 END IF

         LET l_n2 = 0
         SELECT COUNT(*) INTO l_n2 FROM pmn_file
          WHERE pmn01 = l_pmn.pmn01
            AND pmn16 = '9'
         IF cl_null(l_n2) THEN LET l_n2 = 0 END IF
         IF l_n1 = l_n2 THEN
            #單身筆數 = 單身的作廢筆數 => 單身全部作廢，需update單頭
            UPDATE pmm_file SET pmm25='9',
                                pmm18='X',
                                pmmmodu='aps',
                                pmmacti='N',
                                pmmdate=TODAY
            WHERE pmm01 = l_pmn.pmn01
            IF STATUS THEN
               CALL cl_err('upd pmn',status,1)
               LET g_success = 'N'
            END IF
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


#單身段挑選處理
FUNCTION t812_pick(p_cmd)
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

#目的：針對已開立但未核準之採購單單據做到廠日及採購數量之調整
FUNCTION t812_batch_po_adjust()
DEFINE l_update   VARCHAR(1),
       l_pmn      RECORD LIKE pmn_file.*,
       l_cnt      SMALLINT,
       l_pmn16    LIKE pmn_file.pmn16,
       l_str      STRING,
       l_vob      RECORD LIKE vob_file.*,
       i          SMALLINT

   #詢問是否確定執行
   IF NOT cl_confirm('aap-017') THEN
      LET g_success = 'C'
      RETURN
   END IF

   LET l_str = cl_getmsg('aps-738',g_lang) #電腦產生中
   MESSAGE l_str
 #FUN-B60047--mark---str---
 ##FUN-A30083 mod str ------------------------------
 # LET g_sql = "SELECT UNIQUE pmn_file.*,vob_file.* ",
 #            #"  FROM voc_file,vob_file,vaz_file,pmm_file,pmn_file,",
 #             "  FROM voc_file,vob_file,pmm_file,pmn_file,",
 #             "       ima_file ",
 #             " WHERE voc00=vob00",
 #             "   AND voc01=vob01          ",
 #             "   AND voc02=vob02          ",
 #             "   AND voc03=vob03          ",
 #            #"   AND vaz01=vob03          ",
 #            #"   AND vaz10=vob13          ",
 #             "   AND vob01 = '",g_vob01,"'",
 #             "   AND vob02 = '",g_vob02,"'",
 #             "   AND vob00 = '",g_plant,"'",
 #             "   AND ",tm.wc CLIPPED,
 #             "   AND ",tm.wc2 CLIPPED,
 #             "   AND (voc04<>'0' or voc05<>'0') ",
 #             "   AND vob13=pmn01 ",                                         #採購單單號
 #             "   AND pmn02=cast(substr(vob03,length(vob03)-3,4) as int) ",  #採購單項次
 #            #"   AND vaz24 = '1' ",
 #            #"   AND vaz23 = pmn02 ",
 #             "   AND vob05 = '0' ",
 #             "   AND pmn01 = pmm01 ",
 #             "   AND pmn16 = '0' ", #已開立
 #            #"   AND (to_date(vob14) <> to_date(pmn34) OR to_date(vob40) <> to_date(pmn35) OR ",   #FUN-B50020 mark
 #             "   AND ((CAST(vob14 AS DATE) <> CAST(pmn34 AS DATE)) OR (CAST(vob40 AS DATE) <> CAST(pmn35 AS DATE)) OR ",   #FUN-B50020 add
 #             "        (vob33<>pmn20 AND vob33>0)          ", #建議採購量<>採購量且建議採購量>0
 #             "       )                                    ",
 #             "   AND ima01 = pmn04 ",
 #             "  ORDER BY pmn01,pmn02"
 ##FUN-A30083 mod end ------------------------------

 # PREPARE t812_bat_poadj_p FROM g_sql
 # DECLARE t812_bat_poadj_cs CURSOR FOR t812_bat_poadj_p
 #FUN-B60047--mark---end---
   LET l_cnt = 0  
 # FOREACH t812_bat_poadj_cs INTO l_pmn.*,l_vob.* #FUN-B60047 mark
   FOR i = 1 to g_rec_b
      IF STATUS THEN
         RETURN
      END IF
   #FUN-B60047--mod---str--
   #IF g_vob[i].vob03 = l_vob.vob03 AND g_vob[i].vob36='Y' THEN
    IF g_vob[i].vob36 = 'Y' THEN
        SELECT * INTO l_pmn.*
          FROM pmn_file
         WHERE pmn01 = g_vob[i].vob13
           AND pmn02 = g_vob[i].itemno
        SELECT * INTO l_vob.*
          FROM vob_file
         WHERE vob00 = g_plant
           AND vob01 = g_vob01
           AND vob02 = g_vob02
           AND vob03 = g_vob[i].vob03
   #FUN-B60047--mod---end--
        IF l_pmn.pmn34<>l_vob.vob14 OR l_pmn.pmn35<>l_vob.vob40 THEN
           UPDATE pmn_file SET pmn34 = l_vob.vob14,pmn35=l_vob.vob40,
                               pmn33 = l_vob.vob14
            WHERE pmn01 = l_pmn.pmn01
              AND pmn02 = l_pmn.pmn02
        END IF
        IF l_pmn.pmn20<>l_vob.vob33  AND l_vob.vob33>0 THEN
           UPDATE pmn_file SET pmn20 = l_vob.vob33 
            WHERE pmn01 = l_pmn.pmn01
              AND pmn02 = l_pmn.pmn02
           UPDATE pml_file SET pml21 = l_vob.vob33 
            WHERE pml01 = l_pmn.pmn24
              AND pml02 = l_pmn.pmn25
        END IF
        
        IF STATUS THEN
           CALL cl_err('upd pmn',status,1)
           LET g_success = 'N'
        END IF
        
        UPDATE pmm_file SET pmmmodu='aps',pmmdate=g_today
          WHERE pmm01 = l_pmn.pmn01
        
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_success = 'N'
           CALL cl_err('upd pmm:',SQLCA.sqlcode,1)
           RETURN
        END IF
        
        UPDATE vob_file SET vob36='Y'
         WHERE vob00=g_plant
           AND vob01=g_vob01
           AND vob02=g_vob02
           AND vob03=g_vob[i].vob03
        
        #FUN-A30083 add str ---
        #update 採購單單身金額&單頭的總金額
         CALL t812_pmm40(l_pmn.pmn01,l_pmn.pmn02)
         IF g_success='N' THEN
            CALL cl_err("upd pmm_file",SQLCA.sqlcode,1)
            RETURN
         END IF
        #FUN-A30083 add end ---
        
        LET l_cnt = l_cnt + 1  
     END IF
   END FOR
  #END FOREACH #FUN-B60047 mark
   COMMIT WORK
   LET l_str = cl_getmsg("anm-973",g_lang)
   MESSAGE l_str||l_cnt   
END FUNCTION


FUNCTION t812_batch_po_change()  #自動產生變更單
DEFINE l_vob13_t  LIKE vob_file.vob13    #FUN-B80004 add
DEFINE l_pmm      RECORD LIKE pmm_file.*,
       l_pmn      RECORD LIKE pmn_file.*,
       l_pna      RECORD LIKE pna_file.*,
       l_pnb      RECORD LIKE pnb_file.*,
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
  
   LET g_pna15 = ''
   CALL cl_init_qry_var()
  #FUN-B50020---mod---str---
  #LET g_qryparam.form     = "q_azf"
  #LET g_qryparam.arg1     = '2'
   LET g_qryparam.form     = "q_azf01a" 
   LET g_qryparam.arg1     = 'B'        
  #FUN-B50020---mod---end---
   LET g_qryparam.default1 = ''
   CALL cl_create_qry() RETURNING g_pna15
   IF cl_null(g_pna15) THEN
      IF NOT cl_confirm('aps-760') THEN
         LET g_success = 'N'
         RETURN
      END IF
   END IF

  #FUN-B60047--mark---str---
  #LET g_sql = "SELECT UNIQUE pmm_file.*,pmn_file.*,vob_file.* ",
  #            "  FROM voc_file,vob_file,vaz_file,pmm_file,pmn_file,",
  #            "       ima_file",   
  #            " WHERE voc00=vob00",
  #            "   AND voc01=vob01          ",
  #            "   AND voc02=vob02          ",
  #            "   AND voc03=vob03          ",
  #            "   AND vaz01=vob03          ",
  #            "   AND vob05='0'            ",
  #            "   AND vaz10=vob13          ",
  #            "   AND vob01 = '",g_vob01,"'",
  #            "   AND vob02 = '",g_vob02,"'",
  #            "   AND vob00 = '",g_plant,"'",
  #            "   AND vob13 = pmm01    ",
  #            "   AND pmn01 = vaz10    ",   
  #            "   AND pmn02 = vaz23    ",   
  #            "   AND ",tm.wc CLIPPED,
  #            "   AND ",tm.wc2 CLIPPED,
  #            "   AND (voc04<>'0' or voc05<>'0') ",
  #            "   AND vaz24 = '1' ",
  #            "   AND pmn01 = pmm01 ",
  #            "   AND pmn16 IN ('2')",  #2.已發出
  #            "   AND ima01 = pmn04 ",
  #           #"   AND (to_date(vob14) <> to_date(pmn34) OR to_date(vob40) <> to_date(pmn35) OR ",   #FUN-B50020 mark
  #            "   AND ((CAST(vob14 AS DATE) <> CAST(pmn34 AS DATE)) OR (CAST(vob40 AS DATE) <> CAST(pmn35 AS DATE)) OR ",  #FUN-B50020 add
  #            "        (vob33 <> pmn20 AND vob33 > 0)       ",
  #            "       )                                    "   

  #LET g_sql = g_sql, "  ORDER BY pmn01,pmn02"
  #DISPLAY g_sql

  #PREPARE t812_batch_po_change_p FROM g_sql
  #DECLARE t812_batch_po_change_cs CURSOR FOR t812_batch_po_change_p
  #FUN-B60047--mark---end---

   START REPORT t812_rep TO "apst812.txt"

   LET l_cnt = 0  

   CALL g_show_msg.clear() #FUN-B60047  add
   LET g_err_cnt = 0       #FUN-B60047  add
  #FOREACH t812_batch_po_change_cs INTO l_pmm.*,l_pmn.*,l_vob.* #FUN-B60047 mark
   LET l_vob13_t = NULL #FUN-B80004 add
   FOR i = 1 TO g_rec_b
      IF STATUS THEN
         RETURN
      END IF
   #FUN-B60047--mod---str--
   #IF g_vob[i].vob03 = l_vob.vob03 AND g_vob[i].vob36='Y' THEN
    IF g_vob[i].vob36 = 'Y' THEN
        SELECT * INTO l_pmm.*
          FROM pmm_file
         WHERE pmm01 = g_vob[i].vob13
        SELECT * INTO l_pmn.*
          FROM pmn_file
         WHERE pmn01 = g_vob[i].vob13
           AND pmn02 = g_vob[i].itemno
        SELECT * INTO l_vob.*
          FROM vob_file
         WHERE vob00 = g_plant
           AND vob01 = g_vob01
           AND vob02 = g_vob02
           AND vob03 = g_vob[i].vob03
   #FUN-B60047--mod---end--
        IF cl_null(l_vob13_t) OR (l_vob13_t <> g_vob[i].vob13) THEN #FUN-B80004--add if 判斷
            #先檢查有無已存在未發出的採購變更單
            LET l_n = 0
            SELECT count(*) INTO l_n FROM pna_file,pnb_file
             WHERE pna01 = l_pmm.pmm01
               AND pnaconf IN ('N','n')
               AND pna01 = pnb01
               AND pna02 = pnb02
               AND pna05 <> 'X' #未作廢的
            IF l_n > 0 THEN                   # 代表尚有未發出的採購變更單
               #FUN-B60047--add---str--
               CALL cl_getmsg('apm-454',g_lang) RETURNING g_msg #此採購單尚有未發出的採購變更單,請先處理採購變更單!
               LET g_err_cnt = g_err_cnt + 1
               LET g_show_msg[g_err_cnt].fld01 = l_pmn.pmn01
               LET g_show_msg[g_err_cnt].fld02 = l_pmn.pmn02
               LET g_show_msg[g_err_cnt].fld03 = g_status1
               LET g_show_msg[g_err_cnt].fld04 = g_msg
               #FUN-B60047--add---end--
              #CONTINUE FOREACH #FUN-B60047 mark
               CONTINUE FOR     #FUN-B60047 add
            END IF
        END IF #FUN-B80004 add
        
        OUTPUT TO REPORT t812_rep(l_pmm.*,l_pmn.*,l_vob.*)
        IF g_success = 'Y' THEN
           UPDATE vob_file SET vob36='Y'
            WHERE vob00=g_plant
              AND vob01=g_vob01
              AND vob02=g_vob02
              AND vob03=g_vob[i].vob03
           LET l_cnt = l_cnt + 1  
        
           #FUN-B60047--add---str--
           LET g_err_cnt = g_err_cnt + 1
           LET g_show_msg[g_err_cnt].fld01 = l_pmn.pmn01
           LET g_show_msg[g_err_cnt].fld02 = l_pmn.pmn02
           LET g_show_msg[g_err_cnt].fld03 = g_status2
           #FUN-B60047--add---end--
        END IF
    END IF
    LET l_vob13_t = g_vob[i].vob13 #FUN-B80004 add
   END FOR
  #END FOREACH #FUN-B60047
   COMMIT WORK
   LET l_str = cl_getmsg("anm-973",g_lang)
   MESSAGE l_str||l_cnt
   FINISH REPORT t812_rep
   CALL t812_show_msg() #FUN-B60047 add

END FUNCTION

#FOR整批產生變更單
REPORT t812_rep(l_pmm,l_pmn,l_vob)
DEFINE  l_pmm     RECORD LIKE pmm_file.*,
        l_pmn     RECORD LIKE pmn_file.*,
        l_pna     RECORD LIKE pna_file.*,
        l_pnb     RECORD LIKE pnb_file.*,
        l_vob     RECORD LIKE vob_file.*,
        l_t1      LIKE pmm_file.pmm01,
        l_cmd     STRING,
        p_cmd     LIKE type_file.chr1,
        l_ima49   LIKE ima_file.ima49,  
        l_ima491  LIKE ima_file.ima491  

ORDER EXTERNAL BY l_pmn.pmn01,l_pmn.pmn02

FORMAT

   BEFORE GROUP OF l_pmn.pmn01
      #產生採購變更單單頭
      INITIALIZE l_pna.* TO NULL
      LET l_pna.pna01 = l_pmm.pmm01
      SELECT max(pna02) INTO l_pna.pna02
        FROM pna_file
       WHERE pna01 = l_pna.pna01
      IF cl_null(l_pna.pna02) THEN
         LET l_pna.pna02 = 1
      ELSE
         LET l_pna.pna02 = l_pna.pna02 + 1
      END IF
      LET l_pna.pna04 = g_today
      LET l_pna.pna05 = 'N'                    #發出否
      LET l_pna.pna08 = l_pmm.pmm22
      LET l_pna.pna09 = l_pmm.pmm10
      LET l_pna.pna10 = l_pmm.pmm20
      LET l_pna.pna12 = l_pmm.pmm11
      LET l_pna.pna13 = '0'                    #開立
      LET l_pna.pna14 = 'N'
      LET l_pna.pna15 = g_pna15           
      LET l_pna.pnaconf = 'N'                  #發出否
      LET l_pna.pnaacti = 'Y'
      LET l_pna.pnagrup = g_grup
      LET l_pna.pnadate = g_today
      LET l_pna.pnauser = 'aps'   
      LET l_t1 = s_get_doc_no(l_pna.pna01)
      SELECT smyapr INTO l_pna.pna14 FROM smy_file
       WHERE smyslip = l_t1

      LET l_pna.pnaplant = g_plant #FUN-B50020 add 所屬營運中心
      LET l_pna.pnalegal = g_legal #FUN-B50020 add 所屬法人
      LET l_pna.pna16 = tm.pna16   #FUN-B50020 add 變更人員

      INSERT INTO pna_file VALUES(l_pna.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","pna_file",l_pna.pna01,'',SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF

   ON EVERY ROW
      #產生採購變更單單身
      INITIALIZE l_pnb.* TO NULL
      LET l_pnb.pnb01 = l_pna.pna01
      LET l_pnb.pnb02 = l_pna.pna02
      LET l_pnb.pnb03 = l_pmn.pmn02
      LET l_pnb.pnb04b = l_pmn.pmn04
      LET l_pnb.pnb07b = l_pmn.pmn07
      LET l_pnb.pnb20b = l_pmn.pmn20
      LET l_pnb.pnb83b = l_pmn.pmn83
      LET l_pnb.pnb84b = l_pmn.pmn84
      LET l_pnb.pnb85b = l_pmn.pmn85
      LET l_pnb.pnb80b = l_pmn.pmn80
      LET l_pnb.pnb81b = l_pmn.pmn81
      LET l_pnb.pnb82b = l_pmn.pmn82
      LET l_pnb.pnb86b = l_pmn.pmn86
      LET l_pnb.pnb87b = l_pmn.pmn87
      LET l_pnb.pnb31b = l_pmn.pmn31
      LET l_pnb.pnb32b = l_pmn.pmn31t
      LET l_pnb.pnb33b = l_pmn.pmn33
      LET l_pnb.pnb041b = l_pmn.pmn041
      LET l_pnb.pnb90 = l_pmn.pmn24
      LET l_pnb.pnb91 = l_pmn.pmn25

      SELECT ima49,ima491 INTO l_ima49,l_ima491
        FROM ima_file
       WHERE ima01 = l_pmn.pmn04
      IF g_debug = 'Y' THEN
         DISPLAY "[t812_rep]ima01=",l_pmn.pmn04 CLIPPED
         DISPLAY "       -> ima49=",l_ima49 USING '<<<<<<<<'
         DISPLAY "       -> ima49=",l_ima491 USING '<<<<<<<<'
      END IF

      #變更後原始交貨日期 = 系統規劃抵達日期 
      LET l_pnb.pnb33a = l_vob.vob14    
      IF l_pnb.pnb33a < g_today THEN
         LET l_pnb.pnb33a = g_today
      END IF
      LET l_pnb.pnb20a = l_vob.vob33 #數量
      LET l_pnb.pnb20a = s_digqty(l_pnb.pnb20a,l_pnb.pnb07b)   #FUN-910088--add--


      IF g_debug = 'Y' THEN
         DISPLAY "[t812_rep]pnb33a=",l_pnb.pnb33a
      END IF
      LET l_pnb.pnbplant = g_plant #FUN-B50020 add所屬營運中心
      LET l_pnb.pnblegal = g_legal #FUN-B50020 add 所屬法人

      INSERT INTO pnb_file VALUES(l_pnb.*)
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err3("ins","pnb_file",l_pna.pna01,l_pmn.pmn02,SQLCA.sqlcode,"","",1)
      END IF

END REPORT


#FUN-A30083 add---str---     
#update 採購單頭的總金額
FUNCTION t812_pmm40(l_pmn01,l_pmn02)
  DEFINE l_pmn01  LIKE pmn_file.pmn01,   #採購單單號
         l_pmn02  LIKE pmn_file.pmn02,   #採購項次
         l_pmn20  LIKE pmn_file.pmn20,   #採購量
         l_pmn31  LIKE pmn_file.pmn31,   #單身未稅金額
         l_pmn31t LIKE pmn_file.pmn31t,  #單身含稅金額
         l_pmn88  LIKE pmn_file.pmn88,   #單身未稅金額合計
         l_pmn88t LIKE pmn_file.pmn88t,  #單身含稅金額合計
         l_pmn87  LIKE pmn_file.pmn87,   #CHI-B70039 add
         l_pmm22  LIKE pmm_file.pmm22,   #幣別
         l_pmm40  LIKE pmm_file.pmm40,   #單頭未稅總額
         l_pmm40t LIKE pmm_file.pmm40t   #單頭含稅總額

  LET g_success = 'Y'

  SELECT pmm22 INTO l_pmm22
    FROM pmm_file
   WHERE pmm01 = l_pmn01

  SELECT azi03,azi04 INTO t_azi03,t_azi04
    FROM azi_file
   WHERE azi01 = l_pmm22

# SELECT pmn20,pmn31,pmn31t INTO l_pmn20,l_pmn31,l_pmn31t                 #CHI-B70039 mark
  SELECT pmn20,pmn31,pmn31t,pmn87 INTO l_pmn20,l_pmn31,l_pmn31t,l_pmn87   #CHI-B70039
    FROM pmn_file
   WHERE pmn01 = l_pmn01
     AND pmn02 = l_pmn02

# LET l_pmn88 = cl_digcut(l_pmn31*l_pmn20,t_azi04)    #CHI-B70039 mark
# LET l_pmn88t= cl_digcut(l_pmn31t*l_pmn20,t_azi04)   #CHI-B70039
  LET l_pmn88 = cl_digcut(l_pmn87*l_pmn31,t_azi04)    #CHI-B70039
  LET l_pmn88t= cl_digcut(l_pmn87*l_pmn31t,t_azi04)   #CHI-B70039

  UPDATE pmn_file SET pmn88 = l_pmn88,
                      pmn88t= l_pmn88t
   WHERE pmn01 = l_pmn01
     AND pmn02 = l_pmn02

  IF SQLCA.sqlcode THEN
     LET g_success='N'
  END IF

  IF g_success = 'Y' THEN
     SELECT SUM(pmn88),SUM(pmn88t)
       INTO l_pmm40,l_pmm40t
       FROM pmn_file
      WHERE pmn01 = l_pmn01

     LET l_pmm40 = cl_digcut(l_pmm40,t_azi04)
     LET l_pmm40t= cl_digcut(l_pmm40t,t_azi04)

     UPDATE pmm_file SET pmm40 = l_pmm40,
                         pmm40t= l_pmm40t
      WHERE pmm01 = l_pmn01
     IF SQLCA.sqlcode THEN
        LET g_success='N'
     END IF
  END IF
END FUNCTION
#FUN-A30083 add---end---

#FUN-B50020---add----str---
FUNCTION t812_peo(p_key)
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

FUNCTION t812_set_entry()
   CALL cl_set_comp_entry("pna16",TRUE)
END FUNCTION
 
FUNCTION t812_set_no_entry()
  IF tm.hstatus <> 'C' THEN
      CALL cl_set_comp_entry("pna16",FALSE)
  END IF
END FUNCTION

FUNCTION t812_set_required()
  IF tm.hstatus = 'C' THEN
      CALL cl_set_comp_required("pna16",TRUE)
  END IF
END FUNCTION

FUNCTION t812_set_no_required()
   CALL cl_set_comp_required("pna16",FALSE)
END FUNCTION
#FUN-B50020---add----end---
#FUN-B60047--add---str---
FUNCTION t812_show_msg()
  CALL cl_getmsg('apm-574',g_lang) RETURNING g_msg
  CALL cl_get_feldname('pmn01',g_lang) RETURNING g_fld01
  CALL cl_get_feldname('pmn02',g_lang) RETURNING g_fld02
  CALL cl_get_feldname('fbh05',g_lang) RETURNING g_fld03
  CALL cl_get_feldname('aab03',g_lang) RETURNING g_fld04
  LET g_msg2 = g_fld01 CLIPPED,'|',g_fld02 CLIPPED,'|',
               g_fld03 CLIPPED,'|',g_fld04 CLIPPED
  CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg,g_msg2)
END FUNCTION
#FUN-B60047--add---end---
#FUN-BB0020---add-----str----
FUNCTION t812_chg_close()  #結案自動調整
DEFINE l_cntx     LIKE type_file.num5
DEFINE l_qty      LIKE pml_file.pml20
DEFINE l_sta      LIKE type_file.chr1           
DEFINE l_update   LIKE type_file.chr1,
       l_pmn      RECORD LIKE pmn_file.*,
       l_cnt      LIKE type_file.num5,
       l_pmn16    LIKE pmn_file.pmn16,
       l_str      STRING,
       l_vob      RECORD LIKE vob_file.*,
       l_n1,l_n2  LIKE type_file.num5,
       i          LIKE type_file.num5

   #詢問是否確定執行
   IF NOT cl_confirm('aap-017') THEN
      LET g_success = 'C'
      RETURN
   END IF

   LET l_str = cl_getmsg('aps-738',g_lang) #電腦產生中
   MESSAGE l_str

   LET l_cnt = 0 
   FOR i = 1 TO g_rec_b
      IF STATUS THEN
         RETURN
      END IF

      IF g_vob[i].vob36 = 'Y' THEN                                
         SELECT * INTO l_pmn.*
           FROM pmn_file
          WHERE pmn01 = g_vob[i].vob13
            AND pmn02 = g_vob[i].itemno
         SELECT * INTO l_vob.*
           FROM vob_file
          WHERE vob00 = g_plant
            AND vob01 = g_vob01
            AND vob02 = g_vob02
            AND vob03 = g_vob[i].vob03

         LET l_qty = l_pmn.pmn50-l_pmn.pmn20-l_pmn.pmn55
         CALL t812_sta(l_qty) RETURNING l_sta    

         UPDATE pmn_file SET pmn16 = l_sta
          WHERE pmn01 = l_pmn.pmn01
            AND pmn02 = l_pmn.pmn02
         IF STATUS THEN
            CALL cl_err('upd pmn',status,1)
            LET g_success = 'N'
         END IF
         UPDATE pmm_file SET pmmmodu='aps',pmmdate=g_today
           WHERE pmm01 = l_pmn.pmn01

         LET l_cntx = 0
         SELECT COUNT(*) INTO l_cntx FROM pmn_file
          WHERE pmn01 = l_pmn.pmn01 
            AND pmn16 NOT IN ('6','7','8','9')

         IF l_cntx = 0 THEN
            UPDATE pmm_file 
               SET pmm25 = '6', 
                   pmm27 = g_today
            WHERE pmm01 = l_pmn.pmn01
            IF STATUS THEN
               CALL cl_err('upd pmn',status,1)
               LET g_success = 'N'
            END IF
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
   LET l_str = cl_getmsg("anm-973",g_lang)
   MESSAGE l_str||l_cnt   

END FUNCTION

FUNCTION t812_sta(p_qty)
   DEFINE p_qty    LIKE pmn_file.pmn50
   DEFINE l_sta    LIKE type_file.chr1

   CASE
      WHEN p_qty = 0 LET  l_sta = '6'
      WHEN p_qty > 0 LET  l_sta = '7'
      WHEN p_qty < 0 LET  l_sta = '8'
      OTHERWISE EXIT CASE
   END CASE
   RETURN l_sta
END FUNCTION
#FUN-BB0020---add-----end----
