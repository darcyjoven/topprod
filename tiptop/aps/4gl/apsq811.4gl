# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsq811.4gl
# Descriptions...: APS 請購建議調整查詢作業
# Date & Author..: 09/06/09 By Duke #FUN-960041
# Modify.........: NO:FUN-A30081 10/03/24 By Lilan 1.來源項次可以改show vob03,但此欄位值為"PR5-690001-0001",需拆解抓出項次來 
#                                                  2.FUNCTION t811_b_fill()已作廢的請購單應要能夠show出
# Modify.........: No.FUN-B50050 11/05/11 By Mandy---GP5.25 追版:以上為GP5.1 的單號---

DATABASE ds

GLOBALS "../../config/top.global"

#FUN-960041

#模組變數(Module Variables)
DEFINE   g_vob01              LIKE vob_file.vob01,      #APS版本  (假單頭)
         g_vob02              LIKE vob_file.vob02,      #儲存版本 (假單頭)
         g_vob03              LIKE vob_file.vob03,      #
         g_vob01_t            LIKE vob_file.vob01,      #APS版本  (假單頭)
         g_vob02_t            LIKE vob_file.vob02,      #儲存版本 (假單頭)
         g_vob13_1            LIKE vob_file.vob13,      
         g_vob07_1            LIKE vob_file.vob07,
         g_vob36_1            LIKE vob_file.vob36,
         g_pmk12_1            LIKE pmk_file.pmk12,
         g_gen02              LIKE gen_file.gen02,
         g_vob13_1_t          LIKE vob_file.vob13,
         g_vob07_1_t          LIKE vob_file.vob07,
         g_vob36_1_t          LIKE vob_file.vob36,
         g_pmk12_1_t          LIKE pmk_file.pmk12,
         g_vob              DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
            vob36             LIKE vob_file.vob36,      #
            vob13             LIKE vob_file.vob13,      #
            pml16             LIKE pml_file.pml16,      #
            pmk12             LIKE pmk_file.pmk12,      #請採購人員
            pmk09             LIKE pmk_file.pmk09,      #廠商
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
DEFINE   g_change_lang      LIKE type_file.chr1

MAIN
   DEFINE   p_row,p_col     LIKE type_file.num5

   #FUN-B50050---mod-----str--
   OPTIONS                                           #改變一些系統預設值
      INPUT NO WRAP                                  #輸入的方式: 不打轉
   DEFER INTERRUPT                                   #擷取中斷鍵, 由程式處理
   #FUN-B50050---mod-----end--

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
   LET g_vob13_1 = NULL                     
   LET g_vob07_1 = NULL                     
   LET g_vob13_1_t = NULL
   LET g_vob07_1_t = NULL
   LET g_vob36_1 = NULL                     
   LET g_pmk12_1 = NULL                     
   LET g_vob36_1_t = NULL
   LET g_pmk12_1_t = NULL
   LET p_row = 4 LET p_col = 20

   OPEN WINDOW apsq811_w AT p_row,p_col WITH FORM "aps/42f/apsq811"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_set_comp_visible("vob08,vob20,vob04,vob03",FALSE)
   CALL cl_set_comp_entry('pml16,pmk12,pmk09,vob07,vob11,vob40',FALSE);

   IF NOT cl_null(g_argv1) THEN CALL t811_q() END IF

   CALL t811_menu()
   CLOSE WINDOW apsq811_w               #結束畫面
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

      CONSTRUCT tm.wc ON vob01,vob02,vob13,vob07,pmk12,vob36 
           FROM vob01,vob02,vob13_1,vob07_1,pmk12_1,vob36_1  

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

          AFTER FIELD pmk12_1
             LET g_pmk12_1 =  GET_FLDBUF(pmk12_1)
             SELECT gen02 INTO g_gen02 FROM gen_file
              WHERE gen01 = g_pmk12_1
             IF cl_null(g_pmk12_1) OR STATUS THEN 
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
                LET g_qryparam.arg1=g_plant
                LET g_qryparam.default1 = g_vob01
                CALL cl_create_qry() RETURNING g_vob01,g_vob02
                DISPLAY g_vob01 TO vob01
                DISPLAY g_vob02 TO vob02
                NEXT FIELD vob01

              WHEN INFIELD(pmk12_1)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen6"
                CALL cl_create_qry() RETURNING g_pmk12_1,g_gen02
                DISPLAY g_pmk12_1 TO pmk12_1
                DISPLAY g_gen02 TO gen02
                NEXT FIELD pmk12_1

             WHEN INFIELD(vob13_1)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmk3"
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

      CALL cl_set_head_visible("","YES")
      CALL q810_b_askkey()
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF

  #FUN-A30081 mod str ------
   LET g_sql = "SELECT UNIQUE vob01,vob02  ",
              #"  FROM voc_file,vob_file,vaz_file,pmk_file,pml_file   ",
               "  FROM voc_file,vob_file,pmk_file,pml_file   ",
               " WHERE voc00=vob00          ",
               "   AND voc01=vob01          ",
               "   AND voc02=vob02          ",
               "   AND voc03=vob03          ",
              #"   AND vaz01=vob03          ",
              #"   AND vaz10=vob13          ",
              #"   AND (vaz24='0' OR vaz24 = '' OR vaz24 IS NULL)",
              #"   AND vaz10 = pml01    ",     #採購單單號
              #"   AND vaz23 = pml02    ",     #採購單項次
               "   AND vob13 = pml01    ",
               "   AND pml02 = cast(substr(vob03,length(vob03)-3,4) as int)  ",
               "   AND vob13 = pmk01    ",
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND vob00 = '",g_plant,"'",
               "   AND vob05='0'            ",
               "   AND (voc04<>'0' or voc05<>'0') "
  #FUN-A30081 mod end -----


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
   CONSTRUCT tm.wc2 ON vob13,pml16,pmk12,pmk09,
                      #vaz23,                         #FUN-A30081 mark
                       itemno,                        #FUN-A30081 add
                       vob07,ima02,vob11,pml20,vob33,
                       pml34,  vob14,pml35,vob17,vob40,vob42
        FROM s_vob[1].vob13,s_vob[1].pml16,
             s_vob[1].pmk12,
             s_vob[1].pmk09,
            #s_vob[1].vaz23,                          #FUN-A30081 mark
             s_vob[1].itemno,                         #FUN-A30081 add
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

        #FUN-960041 MARK --STR---------------
        #  WHEN "detail"
        #     IF cl_chk_act_auth() THEN
        #        CALL t811_b()
        #    ELSE
        #       LET g_action_choice = NULL
        #    END IF
        #FUN-960041 MARK --END---------------
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
         #請購單明細
         WHEN "pr_detail"
            IF g_rec_b = 0 THEN
               CALL cl_err('','aps-702',1)
            ELSE
               IF g_rec_b > 0 AND l_ac > 0 THEN
                  LET g_msg = " apmt420 '", g_vob[l_ac].vob13,"'"
                  CALL cl_cmdrun_wait(g_msg CLIPPED)
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
   DISPLAY g_vob13_1 TO FORMONLY.vob13_1
   DISPLAY g_vob07_1 TO FORMONLY.vob07_1
   DISPLAY g_pmk12_1 TO FORMONLY.pmk12_1
   DISPLAY g_vob36_1 TO FORMONLY.vob36_1

   LET g_vob01_t = g_vob01
   LET g_vob02_t = g_vob02

   CALL t811_b_fill()                   
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

   LET g_forupd_sql =
                     "SELECT vob36 ",
                     "  FROM vob_file    ",
                    #" WHERE vob00=? AND vob01=? AND vob02=? AND vob03=? FOR UPDATE NOWAIT " #FUN-B50050 mark
                     " WHERE vob00=? AND vob01=? AND vob02=? AND vob03=? FOR UPDATE "        #FUN-B50050 add
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50050 add

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

 #FUN-A30081 mark str------------
 #LET g_sql = "SELECT vob36,vob13,pml16,gen02,pmc03,vaz23,vob07,ima02, ",       
 #             "  vob11,'',pml20,pml20-pml21,vob33,vob33-pml20, ",
 #             "  pml34,vob14,pml35,vob40,vob17,vob42,vob08,vob20,vob04,vob03  ", 
 #             "  FROM voc_file,vob_file,vaz_file,pmk_file,pml_file,ima_file,gen_file,pmc_file  ",
 #             " WHERE voc00=vob00          ",
 #             "   AND voc01=vob01          ",
 #             "   AND voc02=vob02          ",
 #             "   AND voc03=vob03          ",
 #             "   AND vaz01=vob03          ",
 #             "   AND vob05='0'            ",
 #             "   AND vob07=ima01(+)          ",
 #             "   AND pmk12=gen01(+)          ",
 #             "   AND pmk09=pmc01(+)          ", 
 #             "   AND vaz10=vob13          ",
 #             "   AND vob01 = '",g_vob01,"'",
 #             "   AND vob02 = '",g_vob02,"'",
 #             "   AND vob00 = '",g_plant,"'",
 #             "   AND (vaz24='0' OR vaz24 = '' OR vaz24 IS NULL)",
 #             "   AND vob13=pmk01(+)    ",
 #             "   AND vaz10=pml01(+)    ",
 #             "   AND vaz23=pml02(+)    ",
 #             "   AND ",tm.wc CLIPPED,
 #             "   AND ",tm.wc2 CLIPPED,
 #             "   AND (voc04<>'0' or voc05<>'0') ", 
 #             "   AND pmk18 <>'X' "
 #FUN-A30081 mark end--------------------------

  #FUN-A30081 add str -------------------
  #FUN-B50050---mod---str----
  #LET g_sql = "SELECT distinct vob36,vob13,pml16,gen02,pmc03,cast(substr(vob03,length(vob03)-3,4) as int), ",
  #            "       vob07,ima02,vob11,'',pml20,pml20-pml21,vob33,vob33-pml20, ",
  #            "       pml34,vob14,pml35,vob40,vob17,vob42,vob08,vob20,vob04,vob03  ",
  #            "  FROM voc_file,vob_file,pmk_file,pml_file,ima_file,gen_file,pmc_file  ",
  #            " WHERE voc00=vob00          ",
  #            "   AND voc01=vob01          ",
  #            "   AND voc02=vob02          ",
  #            "   AND voc03=vob03          ",
  #            "   AND vob13 = pml01        ",
  #            "   AND pml02 = cast(substr(vob03,length(vob03)-3,4) as int)  ",
  #            "   AND vob05='0'            ",
  #            "   AND vob07=ima01(+)          ",
  #            "   AND vob13=pmk01(+)          ",
  #            "   AND pmk12=gen01(+)          ",
  #            "   AND pmk09=pmc01(+)          ",
  #            "   AND vob01 = '",g_vob01,"'",
  #            "   AND vob02 = '",g_vob02,"'",
  #            "   AND vob00 = '",g_plant,"'",
  #            "   AND ",tm.wc CLIPPED,
  #            "   AND ",tm.wc2 CLIPPED,
  #            "   AND (voc04<>'0' or voc05<>'0') "
   LET g_sql = "SELECT distinct vob36,vob13,pml16,gen02,pmc03,cast(substr(vob03,length(vob03)-3,4) as int), ",
               "       vob07,ima02,vob11,'',pml20,pml20-pml21,vob33,vob33-pml20, ",
               "       pml34,vob14,pml35,vob40,vob17,vob42,vob08,vob20,vob04,vob03  ",
               "  FROM pml_file,voc_file,vob_file ",
               "  LEFT OUTER JOIN ima_file ON vob07 = ima01 ",
               "  LEFT OUTER JOIN pmk_file ON vob13 = pmk01 ",
               "  LEFT OUTER JOIN gen_file ON pmk12 = gen01 ",
               "  LEFT OUTER JOIN pmc_file ON pmk09 = pmc01 ",
               " WHERE voc00=vob00          ",
               "   AND voc01=vob01          ",
               "   AND voc02=vob02          ",
               "   AND voc03=vob03          ",
               "   AND vob13 = pml01        ",
               "   AND pml02 = cast(substr(vob03,length(vob03)-3,4) as int)  ",
               "   AND vob05='0'            ",
               "   AND vob01 = '",g_vob01,"'",
               "   AND vob02 = '",g_vob02,"'",
               "   AND vob00 = '",g_plant,"'",
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND (voc04<>'0' or voc05<>'0') "
  #FUN-B50050---mod---end----
 #FUN-A30081 add end------------------------

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
        #AND pml02=g_vob[g_cnt].vaz23       #FUN-A30081 mark
         AND pml02=g_vob[g_cnt].itemno      #FUN-A30081 add
      LET g_vob[g_cnt].pml20 = l_pml20  
           if l_pml20<>g_vob[g_cnt].vob08 or 
              l_pml21<>g_vob[g_cnt].vob20 or 
              l_pml34<>g_vob[g_cnt].vob04 then   
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
          CALL cl_set_action_active("pr_closing,batch_pr_adjust,pr_void",FALSE)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                                     

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

     #FUN-960041 MARK --STR------------- 
     # ON ACTION detail
     #    LET g_action_choice="detail"
     #    LET l_ac = 1
     #    EXIT DISPLAY
     #FUN-960041 MARK --END------------

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

      #FUN-960041 MARK --STR-----------
      #ON ACTION accept
      #   LET g_action_choice="detail"
      #   LET l_ac = ARR_CURR()
      #   EXIT DISPLAY
      #FUN-960041 MARK --END-----------

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

      ON ACTION pr_detail #請購單維護
         IF cl_null(g_rec_b) or g_rec_b = 0 THEN
            LET g_action_choice=''
            CALL cl_err('','ain-070',0)
         ELSE LET g_action_choice="pr_detail"
         END IF
         EXIT DISPLAY


      AFTER DISPLAY
         CONTINUE DISPLAY

    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION





