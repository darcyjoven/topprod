# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsq812.4gl
# Descriptions...: APS 採購建議調整維護作業
# Date & Author..: 09/06/09 By Duke #FUN-960042
# Modify.........: NO:FUN-A30081 10/03/24 By Lilan 1.來源項次改show vob03,但此欄位值為"PR5-690001-0001",需拆解抓出項次來
#                                                  2.已作廢的請購單應要能夠show出
# Modify.........: No.FUN-B50050 11/05/11 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-C40041 13/01/17 By Nina  在b_fill()段修正判斷ischang的條件，將pmn35<>vob04 改成用pmn34<>vob04

DATABASE ds

GLOBALS "../../config/top.global"

#FUN-960042

#模組變數(Module Variables)
DEFINE   g_vob01              LIKE vob_file.vob01,      #APS版本  (假單頭)
         g_vob02              LIKE vob_file.vob02,      #儲存版本 (假單頭)
         g_vob03              LIKE vob_file.vob03,      #
         g_debug              LIKE type_file.chr1,      #檢查用
         g_vob01_t            LIKE vob_file.vob01,      #APS版本  (假單頭)
         g_vob02_t            LIKE vob_file.vob02,      #儲存版本 (假單頭)
         g_vob13_1            LIKE vob_file.vob13,
         g_vob07_1            LIKE vob_file.vob07,
         g_vob36_1            LIKE vob_file.vob36,
         g_pmm12_1            LIKE pmm_file.pmm12,
         g_gen02              LIKE gen_file.gen02,
         g_vob13_1_t          LIKE vob_file.vob13,
         g_vob07_1_t          LIKE vob_file.vob07,
         g_vob36_1_t          LIKE vob_file.vob36,
         g_pmm12_1_t          LIKE pmm_file.pmm12,
         g_vob              DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
            vob36             LIKE vob_file.vob36,      #
            vob13             LIKE vob_file.vob13,      #
            pmm25             LIKE pmm_file.pmm25,      #狀況碼
            pmm12             LIKE pmm_file.pmm12,      #請採購人員
            pmm09             LIKE pmm_file.pmm09,      #廠商
           #vaz23             LIKE vaz_file.vaz23,      #FUN-A30081 mark
            itemno            LIKE type_file.num5,      #FUN-A30081 add
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
            vob13             LIKE vob_file.vob13,      #
            pmm25             LIKE pmm_file.pmm25,      #狀況碼
            pmm12             LIKE pmm_file.pmm12,      #
            pmm09             LIKE pmm_file.pmm09,      #
           #vaz23             LIKE vaz_file.vaz23,      #FUN-A30081 mark
            itemno            LIKE type_file.num5,      #FUN-A30081 add
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
             wc2     LIKE type_file.chr1000
             END RECORD,
         g_sql          STRING,
        #g_vob_rowid         LIKE type_file.chr18,     #FUN-B50050 mark
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
DEFINE   g_forupd_sql       STRING                   #SELECT ... FOR UPDATE NOWAIT NOWAIT SQL
DEFINE   mi_curs_index      LIKE type_file.num10
DEFINE   lc_qbe_sn          LIKE gbm_file.gbm01      
DEFINE   g_row_count        LIKE type_file.num10
DEFINE   mi_jump            LIKE type_file.num10,
         mi_no_ask          LIKE type_file.num5
DEFINE   g_pna15            LIKE pna_file.pna15     
DEFINE   g_change_lang      LIKE type_file.chr1
MAIN
   DEFINE   p_row,p_col     LIKE type_file.num5

   #FUN-B50050---mod---str----
   OPTIONS                                           #改變一些系統預設值
      INPUT NO WRAP                                  #輸入的方式: 不打轉
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理
   #FUN-B50050---mod---end----

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
   LET g_vob13_1 = NULL
   LET g_vob07_1 = NULL
   LET g_vob13_1_t = NULL
   LET g_vob07_1_t = NULL
   LET g_vob36_1 = NULL
   LET g_pmm12_1 = NULL
   LET g_vob36_1_t = NULL
   LET g_pmm12_1_t = NULL

   LET p_row = 4 LET p_col = 20

   OPEN WINDOW apst812_w AT p_row,p_col WITH FORM "aps/42f/apsq812"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_set_comp_visible("vob08,vob20,vob04,vob03,vob14",FALSE)  
   CALL cl_set_comp_entry('pmm25,pmm12,pmm09,vob07,vob11,vob14,vob40',FALSE)


   LET g_debug = 'Y'
   IF NOT cl_null(g_argv1) THEN CALL t812_q() END IF


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
      CONSTRUCT tm.wc ON vob01,vob02,vob13,vob07,pmm12,vob36
           FROM vob01,vob02,vob13_1,vob07_1,pmm12_1,vob36_1

          BEFORE CONSTRUCT
             IF g_vob01_t IS NOT NULL THEN
                DISPLAY g_vob01_t TO FORMONLY.vob01
                DISPLAY g_vob02_t TO FORMONLY.vob02
                DISPLAY g_vob13_1_t TO FORMONLY.vob13_1
                DISPLAY g_vob07_1_t TO FORMONLY.vob07_1
                DISPLAY g_pmm12_1_t TO FORMONLY.pmm12_1
                DISPLAY g_vob36_1_t TO FORMONLY.vob36_1

             END IF

          AFTER FIELD vob01
             LET g_vob01 =  GET_FLDBUF(vob01)
             IF cl_null(g_vob01) THEN
                CALL cl_err('','aps-521',1)
                NEXT FIELD vob01
             END IF

          AFTER FIELD pmm12_1
             LET g_pmm12_1 =  GET_FLDBUF(pmm12_1)
             SELECT gen02 INTO g_gen02 FROM gen_file
              WHERE gen01 = g_pmm12_1
             IF cl_null(g_pmm12_1) OR STATUS THEN
                LET g_gen02 = NULL
             END IF
             DISPLAY g_gen02 TO gen02

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
              WHEN INFIELD(pmm12_1)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen6"
                CALL cl_create_qry() RETURNING g_pmm12_1,g_gen02
                DISPLAY g_pmm12_1 TO pmm12_1
                DISPLAY g_gen02 TO gen02
                NEXT FIELD pmm12_1

              WHEN INFIELD(vob13_1)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmm"
                CALL cl_create_qry() RETURNING g_vob13_1
                DISPLAY g_vob13_1 TO vob13_1
                NEXT FIELD vob13_1

              WHEN INFIELD(vob07_1)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                CALL cl_create_qry() RETURNING g_vob07_1
                DISPLAY g_vob07_1 TO vob07_1
                NEXT FIELD vob07_1

             END CASE

      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF

      LET g_vob01_t = g_vob01
      LET g_vob02_t = g_vob02
      LET g_vob13_1_t = g_vob13_1
      LET g_vob07_1_t = g_vob07_1
      LET g_pmm12_1_t = g_pmm12_1
      LET g_vob36_1_t = g_vob36_1


      CALL cl_set_head_visible("","YES")
      CALL q810_b_askkey()
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
  #FUN-B50050---------mod-----------str-----
  #LET g_sql = "SELECT UNIQUE vob01,vob02 ",
  #           #"  FROM voc_file,vob_file,vaz_file,pmm_file ", #FUN-A30081 mark
  #            "  FROM voc_file,vob_file,pmm_file ",          #FUN-A30081 add
  #            " WHERE voc00=vob00",
  #            "   AND voc01=vob01          ",
  #            "   AND voc02=vob02          ",
  #            "   AND voc03=vob03          ",
  #           #"   AND vaz01=vob03          ",                #FUN-A30081 mark
  #            "   AND vob05='0'            ",
  #           #"   AND vaz10=vob13          ",                #FUN-A30081 mark
  #           #"   AND vaz24='1'            ",                #FUN-A30081 mark
  #            "   AND vob00 = '",g_plant,"'",
  #            "   AND vob13=pmm01(+)          ",
  #            "   AND ",tm.wc CLIPPED,
  #            "   AND ",tm.wc2 CLIPPED,
  #            "   AND (voc04<>'0' or voc05<>'0') "
   LET g_sql = "SELECT UNIQUE vob01,vob02 ",
               "  FROM voc_file,vob_file ",
               "  LEFT OUTER JOIN pmm_file ON vob13 = pmm01 ",
               " WHERE voc00=vob00",
               "   AND voc01=vob01          ",
               "   AND voc02=vob02          ",
               "   AND voc03=vob03          ",
               "   AND vob05='0'            ",
               "   AND vob00 = '",g_plant,"'",
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND (voc04<>'0' or voc05<>'0') "
  #FUN-B50050---------mod-----------end-----

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
   CONSTRUCT tm.wc2 ON vob13,pmm25,pmm12,pmm09,
                      #vaz23,                                 #FUN-A30081 mark
                       itemno,                                #FUN-A30081 add
                       vob07,ima02,vob11,pmn20,vob33,
                       pmn34,   
                       vob14,pmn35,vob40,vob17,vob42      
        FROM s_vob[1].vob13,s_vob[1].pmm25,
             s_vob[1].pmm12,s_vob[1].pmm09,
            #s_vob[1].vaz23,                                  #FUN-A30081 mark
             s_vob[1].itemno,                                 #FUN-A30081 add
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

        #FUN-960042 MARK --STR------------
        # WHEN "detail"
        #    IF cl_chk_act_auth() THEN
        #        CALL t812_b()
        #    ELSE
        #       LET g_action_choice = NULL
        #    END IF
        #FUN-960042 MARK --END------------

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

         WHEN "po_detail"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF g_rec_b > 0 AND l_ac > 0 THEN
                  LET g_msg = " apmt540 '", g_vob[l_ac].vob13,"'"
                  CALL cl_cmdrun_wait(g_msg CLIPPED)
               END IF
            END IF
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
   DISPLAY g_vob13_1 TO FORMONLY.vob13_1
   DISPLAY g_vob07_1 TO FORMONLY.vob07_1
   DISPLAY g_pmm12_1 TO FORMONLY.pmm12_1
   DISPLAY g_vob36_1 TO FORMONLY.vob36_1

   LET g_vob01_t = g_vob01
   LET g_vob02_t = g_vob02
   LET g_vob13_1_t = g_vob13_1
   LET g_vob07_1_t = g_vob07_1
   LET g_pmm12_1_t = g_pmm12_1
   LET g_vob36_1_t = g_vob36_1

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
                    #" WHERE vob00=? AND vob01=? AND vob02=? AND vob03=? FOR UPDATE NOWAIT " #FUN-B50050 mark
                     " WHERE vob00=? AND vob01=? AND vob02=? AND vob03=? FOR UPDATE "        #FUN-B50050 add
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50050 add

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
      #l_pmn35 LIKE pmn_file.pmn35,     #FUN-C40041 mark
       l_pmn34 LIKE pmn_file.pmn34,     #FUN-C40041 add
       l_gen   LIKE type_file.num5  

  #FUN-A30081 mark str -----------------
  #LET g_sql = "SELECT vob36,vob13,pmm25,gen02,pmc03,vaz23,vob07,ima02, ",    
  #            " vob11,'',",
  #            " pmn20, ", 
  #            " pmn20-pmn50+pmn55,vob33,vob33-pmn20,pmn34,vob14,pmn35,vob40,'',vob17,vob42,vob08,vob20,vob04,vob03   ", 
  #            "  FROM voc_file,vob_file,vaz_file,pmm_file,pmn_file,ima_file,gen_file,pmc_file ",
  #            " WHERE voc00=vob00",
  #            "   AND voc01=vob01          ",
  #            "   AND voc02=vob02          ",
  #            "   AND voc03=vob03          ",
  #            "   AND vaz01=vob03          ",
  #            "   AND vob05='0'            ",
  #            "   AND vob07=ima01(+)          ",
  #            "   AND pmm12=gen01(+)          ",
  #            "   AND pmm09=pmc01(+)          ",
  #            "   AND vaz10=vob13          ",
  #            "   AND vob01 = '",g_vob01,"'",
  #            "   AND vob02 = '",g_vob02,"'",
  #            "   AND vob00 = '",g_plant,"'",
  #            "   AND vaz24 = '1' ", 
  #            "   AND vob13=pmm01(+)    ",
  #            "   AND vaz10=pmn01(+)    ",
  #            "   AND vaz23=pmn02(+)    ",
  #            "   AND ",tm.wc CLIPPED,
  #            "   AND ",tm.wc2 CLIPPED,
  #            "   AND (voc04<>'0' or voc05<>'0') ", 
  #            "   AND pmm18 <>'X' "
  #FUN-A30081 mark end -----------------

  #FUN-A30081 add str ------------
  #FUN-B50050---mod---str---------
  #LET g_sql = "SELECT distinct vob36,vob13,pmm25,gen02,pmc03, ",
  #            "       cast(substr(vob03,length(vob03)-3,4) as int), ",
  #            "       vob07,ima02,vob11,'',pmn20,pmn20-pmn50+pmn55,vob33, ",
  #            "       vob33-pmn20,pmn34,vob14,pmn35,vob40,'',vob17,vob42, ",
  #            "       vob08,vob20,vob04,vob03   ",
  #            "  FROM voc_file,vob_file,pmm_file,pmn_file,ima_file,gen_file,pmc_file ",
  #            " WHERE voc00=vob00 ",
  #            "   AND voc01=vob01 ",
  #            "   AND voc02=vob02 ",
  #            "   AND voc03=vob03 ",
  #            "   AND vob13=pmn01 ",                                         #採購單單號
  #            "   AND pmn02=cast(substr(vob03,length(vob03)-3,4) as int) ",  #採購單項次
  #            "   AND vob07=ima01(+) ",
  #            "   AND vob13=pmm01(+) ",
  #            "   AND pmm12=gen01(+) ",
  #            "   AND pmm09=pmc01(+) ",
  #            "   AND vob01 = '",g_vob01,"'",
  #            "   AND vob02 = '",g_vob02,"'",
  #            "   AND vob00 = '",g_plant,"'",
  #            "   AND ",tm.wc CLIPPED,
  #            "   AND ",tm.wc2 CLIPPED,
  #            "   AND vob05='0'   ",
  #            "   AND (voc04<>'0' or voc05<>'0') "
   LET g_sql = "SELECT distinct vob36,vob13,pmm25,gen02,pmc03, ",
               "       cast(substr(vob03,length(vob03)-3,4) as int), ",
               "       vob07,ima02,vob11,'',pmn20,pmn20-pmn50+pmn55,vob33, ",
               "       vob33-pmn20,pmn34,vob14,pmn35,vob40,'',vob17,vob42, ",
               "       vob08,vob20,vob04,vob03   ",
               "  FROM pmn_file,voc_file,vob_file ",
               "  LEFT OUTER JOIN ima_file ON vob07 = ima01 ",
               "  LEFT OUTER JOIN pmm_file ON vob13 = pmm01 ",
               "  LEFT OUTER JOIN gen_file ON pmm12 = gen01 ",
               "  LEFT OUTER JOIN pmc_file ON pmm09 = pmc01 ",
               " WHERE voc00=vob00 ",
               "   AND voc01=vob01 ",
               "   AND voc02=vob02 ",
               "   AND voc03=vob03 ",
               "   AND vob13=pmn01 ",                                         #採購單單號
               "   AND pmn02=cast(substr(vob03,length(vob03)-3,4) as int) ",  #採購單項次
               "   AND vob01 = '",g_vob01,"'",
               "   AND vob02 = '",g_vob02,"'",
               "   AND vob00 = '",g_plant,"'",
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND vob05='0'   ",
               "   AND (voc04<>'0' or voc05<>'0') "
  #FUN-B50050---mod---end---------
   #FUN-A30081 add end -----------


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
           #select pmn20,pmn53-pmn58,pmn35       #FUN-C40041 mark
           #  into l_pmn20,l_pmn5358,l_pmn35     #FUN-C40041 mark
            select pmn20,pmn53-pmn58,pmn34       #FUN-C40041 add
              into l_pmn20,l_pmn5358,l_pmn34     #FUN-C40041 add
              from pmn_file
             where pmn01=g_vob[g_cnt].vob13
               and pmn02=g_vob[g_cnt].itemno      #FUN-A30081 mod:vaz23 =>itemno
           #if l_pmn20<>g_vob[g_cnt].vob08 or l_pmn5358<>g_vob[g_cnt].vob20 or l_pmn35<>g_vob[g_cnt].vob04 then   #FUN-C40041 mark
            if l_pmn20<>g_vob[g_cnt].vob08 or l_pmn5358<>g_vob[g_cnt].vob20 or l_pmn34<>g_vob[g_cnt].vob04 then   #FUN-C40041 add
               let g_vob[g_cnt].ischange='Y'
            else
               let g_vob[g_cnt].ischange='N'
            end if

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

      BEFORE ROW
         LET l_ac = ARR_CURR()
         #CALL cl_show_fld_cont()

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

     #FUN-960042 MARK --STR--------------
     # ON ACTION detail
     #    LET g_action_choice="detail"
     #    LET l_ac = 1
     #    EXIT DISPLAY
     #FUN-960042 MARK --END--------------

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

      ON ACTION po_detail #採購單維護
         LET g_action_choice="po_detail"
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
