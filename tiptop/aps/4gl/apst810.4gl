# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apst810.4gl
# Descriptions...: APS 需求訂單優先順序制定維護作業
# Date & Author..: 08/04/22 By jamie #FUN-840079
# Modify.........: FUN-860060 08/06/16 By Duke 
# Modify.........: FUN-870099 08/07/24 by duke
# Modify.........: MOD-870293 08/07/25 By Mandy 建議狀態有空值
# Modify.........: FUN-870153 08/07/30 BY DUKE 依單據類別vaz24判斷是否能執行請購維護或採購維護
# Modify.........: MOD-880179 08/08/21 BY DUKE 鎖定請採購員及供應商編號不可編輯
# Modify.........: TQC-890023 08/09/18 BY DUKE 無資料時,ACTION 按下不得自動關閉視窗
# Modify.........: FUN-8A0149 08/11/03 By duke 變更到庫日期條件 pmn35,pml35 --> pmn34,pml34 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No:EXT-940017 09/04/02 by duke 修正bug
# Modify.........: No.MOD-940217 09/04/15 by duke EXT-940217 改單號 MOD-940217
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#FUN-840079
 
#模組變數(Module Variables)
DEFINE   g_vob01              LIKE vob_file.vob01,      #APS版本  (假單頭)
         g_vob02              LIKE vob_file.vob02,      #儲存版本 (假單頭)
         g_vob03              LIKE vob_file.vob03,      #
         g_vob01_t            LIKE vob_file.vob01,      #APS版本  (假單頭)                 
         g_vob02_t            LIKE vob_file.vob02,      #儲存版本 (假單頭)                 
         g_vob              DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
            vob36             LIKE vob_file.vob36,      #
            status            LIKE type_file.chr1,      #
            vaz24             LIKE vaz_file.vaz24,      #
            vob13             LIKE vob_file.vob13,      #
            gen01             LIKE gen_file.gen01,      #FUN-870099 請採購人員
            pmc01             LIKE pmc_file.pmc01,      #FUN-870099 廠商
            vaz23             LIKE vaz_file.vaz23,      #
            vob07             LIKE vob_file.vob07,      #
            ima02             LIKE ima_file.ima02,      #
            vob11             LIKE vob_file.vob11,      #
            ischange          LIKE vob_file.vob36,      # FUN-860060 來源已異動
            vob08             LIKE vob_file.vob08,      # FUN-860060 原請購量/原採購量
            unst_qty          LIKE pml_file.pml20,      #
            vob33             LIKE vob_file.vob33,      #
            qty               LIKE pml_file.pml20,      #
            vob04             LIKE vob_file.vob04,      # FUN-860060
            sdate             LIKE pml_file.pml33,      #
            vob03             LIKE vob_file.vob03,      #
            vob20             LIKE vob_file.vob20,      # FUN-860060
            voc05             LIKE voc_file.voc05,      # FUN-860060
            vob14             LIKE vob_file.vob14       # FUN-860060
                             END RECORD,
         g_vob_t             RECORD                     #程式變數 (舊值)
            vob36             LIKE vob_file.vob36,      #
            status            LIKE type_file.chr1,      #
            vaz24             LIKE vaz_file.vaz24,      #
            vob13             LIKE vob_file.vob13,      #
            gen01             LIKE gen_file.gen01,      #FUN-870099
            pmc01             LIKE pmc_file.pmc01,      #FUN-870099
            vaz23             LIKE vaz_file.vaz23,      #
            vob07             LIKE vob_file.vob07,      #
            ima02             LIKE ima_file.ima02,      #
            vob11             LIKE vob_file.vob11,      #
            ischange          LIKE vob_file.vob36,      # FUN-860060 來源已異動
            vob08             LIKE vob_file.vob08,      # FUN-860060 原請購量/原
            unst_qty          LIKE pml_file.pml20,      #
            vob33             LIKE vob_file.vob33,      #
            qty               LIKE pml_file.pml20,      #
            vob04             LIKE vob_file.vob04,      # FUN-860060
            sdate             LIKE pml_file.pml33,      #
            vob03             LIKE vob_file.vob03,      #
            vob20             LIKE vob_file.vob20,      # FUN-860060
            voc05             LIKE voc_file.voc05,      # FUN-860060
            vob14             LIKE vob_file.vob14       # FUN-860060
                             END RECORD,
 
         tm  RECORD  #FUN-870099
             #wc      LIKE type_file.chr1000,
             #wc2     LIKE type_file.chr1000
             wc          STRING,     #NO.FUN-910082 
        	   wc2         STRING     #NO.FUN-910082  
             END RECORD,
 
         g_sql          STRING,                                     
         g_rec_b             LIKE type_file.num10,     #單身筆數                            
         l_ac                LIKE type_file.num5,      #目前處理的ARRAY CNT                        
         g_argv1             LIKE vob_file.vob01                              
 
DEFINE   g_vob04_check       LIKE type_file.num5,      #檢查對上parent的關係 
         redo_m_check        LIKE type_file.num5       #程式離開時是否要產生有更改的menu 
 
#主程式開始
DEFINE   g_chr              LIKE type_file.chr1                            
DEFINE   g_cnt              LIKE type_file.num10                           
DEFINE   g_i                LIKE type_file.num5      #count/index for any purpose                         
DEFINE   g_msg              LIKE type_file.chr1000                          
DEFINE   g_forupd_sql       STRING                   #SELECT ... FOR UPDATE SQL
DEFINE   mi_curs_index      LIKE type_file.num10       
DEFINE   lc_qbe_sn          LIKE gbm_file.gbm01      #FUN-870099                  
DEFINE   g_row_count        LIKE type_file.num10                                                
DEFINE   mi_jump            LIKE type_file.num10,                          
         mi_no_ask          LIKE type_file.num5                             
 
MAIN
   DEFINE   p_row,p_col     LIKE type_file.num5      
 
   OPTIONS                                           #改變一些系統預設值
      INPUT NO WRAP
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
 
   OPEN WINDOW apst810_w AT p_row,p_col WITH FORM "aps/42f/apst810"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("vob03,vob20,voc05,vob14",FALSE)
 
   IF NOT cl_null(g_argv1) THEN CALL t810_q() END IF
 
   #MOD-880179
   CALL cl_set_comp_entry('gen01,pmc01',FALSE);
 
   CALL t810_menu()
   CLOSE WINDOW apst810_w               #結束畫面
    CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time                             
END MAIN
 
FUNCTION t810_curs()
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "vob01 = '",g_argv1,"'"
      LET tm.wc2=" 1=1 "
 
       LET g_sql= " SELECT UNIQUE vob01,vob02 FROM vob_file ",
                  " WHERE ", tm.wc  CLIPPED,
                  "   AND ", tm.wc2 CLIPPED, 
                  "   AND vob00 = '",g_plant,"'",
                  " ORDER BY vob01,vob02 "
 
 
   ELSE
      CLEAR FORM                             #清除畫面
      CALL g_vob.clear()
      CALL cl_set_head_visible("","YES")     
      CONSTRUCT tm.wc ON vob01,vob02 FROM vob01,vob02
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION about                    
             CALL cl_about()                 
 
          ON ACTION help                     
             CALL cl_show_help()             
 
          ON ACTION controlg                 
             CALL cl_cmdask()                
 
          ON ACTION qbe_select    #FUN-870099
             CALL cl_qbe_list() RETURNING lc_qbe_sn
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
 
          ON ACTION CONTROLP
             CASE
              WHEN INFIELD(vob01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_vob01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_vob01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO vob01
                 NEXT FIELD vob01
             END CASE
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN 
         RETURN 
      END IF
      #FUN-870099  add ----begin----
      CALL cl_set_head_visible("","YES")
      CALL q810_b_askkey()
      IF INT_FLAG THEN
         RETURN
      END IF
      #fun-870099  add  ----end---- 
   END IF
 
   #FUN-870099 
#   LET g_sql= "SELECT UNIQUE vob01,vob02 FROM vob_file ",
#              " WHERE ", tm.wc  CLIPPED,
#              "   AND vob00 = '",g_plant,"'",
#              " ORDER BY vob01,vob02"
 
 IF (g_vob[1].vaz24='0') or (g_vob[1].vaz24='') or (g_vob[1].vaz24 is NULL) THEN
   LET g_sql = "SELECT UNIQUE vob01,vob02  ",
               "  FROM voc_file,vaz_file,vob_file LEFT OUTER JOIN ",
        " (pmk_file LEFT OUTER JOIN pmc_file ON pmk09=pmc01 ",
        " LEFT OUTER JOIN gen_file ON pmk12=gen01) ON vob13=pmk01         ",
               " WHERE voc00=vob00          ",
               "   AND voc01=vob01          ",
               "   AND voc02=vob02          ",
               "   AND voc03=vob03          ",
               "   AND vaz01=vob03          ",
               "   AND vob05='0'            ",
               "   AND vaz10=vob13          ",
               "   AND vob00 = '",g_plant,"'",
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND (voc04<>'0' or voc05<>'0') " #FUN-860060
   ELSE
   LET g_sql = "SELECT UNIQUE vob01,vob02 ",
               "  FROM voc_file,vaz_file,vob_file LEFT OUTER JOIN ( ",
        " pmm_file LEFT OUTER JOIN pmc_file ON pmm09=pmc01 ",
        " LEFT OUTER JOIN gen_file ON pmm12=gen01) ",
        " ON vob13=pmm01 ",
               " WHERE voc00=vob00",
               "   AND voc01=vob01          ",
               "   AND voc02=vob02          ",
               "   AND voc03=vob03          ",
               "   AND vaz01=vob03          ",
               "   AND vob05='0'            ",
               "   AND vaz10=vob13          ",
               "   AND vob00 = '",g_plant,"'",
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND (voc04<>'0' or voc05<>'0') " #FUN-860060
   END IF
 
   DISPLAY g_sql
   PREPARE t810_prepare FROM g_sql      #預備一下
   DECLARE t810_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t810_prepare
 
   DROP TABLE count_tmp
#   LET g_sql="SELECT UNIQUE vob01,vob02 ",
#             "  FROM vob_file             ",
#             " WHERE ", tm.wc CLIPPED,
#
#             "   AND vob00 = '",g_plant,"'",
#             " GROUP BY vob01,vob02 ",
    LET g_sql = g_sql," INTO TEMP count_tmp "
#             " INTO TEMP count_tmp"
   PREPARE t810_cnt_tmp  FROM g_sql
   EXECUTE t810_cnt_tmp
   DECLARE t810_count CURSOR FOR SELECT COUNT(*) FROM count_tmp
 
END FUNCTION
 
 
FUNCTION q810_b_askkey()
   CONSTRUCT tm.wc2 ON vob36,vaz24,vob13,gen01,pmc01,vaz23,vob07,ima02,vob11,vob08,vob33,vob04 
        FROM s_vob[1].vob36,s_vob[1].vaz24,
             s_vob[1].vob13,s_vob[1].gen01,
             s_vob[1].pmc01,s_vob[1].vaz23,
             s_vob[1].vob07,s_vob[1].ima02,
             s_vob[1].vob11,s_vob[1].vob08,
             s_vob[1].vob33,s_vob[1].vob04
             
 
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
           WHEN INFIELD(gen01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmk8"
              LET g_qryparam.state = "c"
              LET g_qryparam.default1 = g_vob[1].gen01
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO gen01
              NEXT FIELD gen01
          WHEN INFIELD(pmc01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_pmk9"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_vob[1].pmc01
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO pmc01
             NEXT FIELD pmc01
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
 
          END CASE
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
END FUNCTION
 
 
FUNCTION t810_menu()
 
   WHILE TRUE
      CALL t810_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t810_q()
            END IF
         WHEN "next"
            CALL t810_fetch('N')
         WHEN "previous"
            CALL t810_fetch('P')
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL t810_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN  "help"
            CALL cl_show_help()
         WHEN  "exit"
            EXIT WHILE
         WHEN  "jump"
            CALL t810_fetch('/')
         WHEN  "first"
            CALL t810_fetch('F')
         WHEN  "last"
            CALL t810_fetch('L')
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vob),'','')
            END IF
 
         WHEN "pr_detail"    
            #FUN-870153
            IF g_vob[l_ac].vaz24 = 0 THEN  
               IF g_vob[l_ac].status='A' or g_vob[l_ac].status='D' THEN 
                  LET g_msg = " apmt420 '", g_vob[l_ac].vob13,"'"
                  CALL cl_cmdrun_wait(g_msg CLIPPED)
               END IF
            ELSE
               CALL cl_err('','aps-712',1)
            END IF
 
         WHEN "pr_closing"    
            IF g_vob[l_ac].vaz24 =0 THEN  #FUN-870153
               LET g_msg = " apmp451 "
               CALL cl_cmdrun_wait(g_msg CLIPPED)
            ELSE
              CALL cl_err('','aps-712',1)
            END IF
 
         WHEN "po_detail"   
            #FUN-870153
            IF g_vob[l_ac].vaz24 = 1 THEN 
               IF g_vob[l_ac].status='B' or g_vob[l_ac].status='C' or
                  g_vob[l_ac].status='D' THEN 
                  LET g_msg = " apmt540 '", g_vob[l_ac].vob13,"'"
                  CALL cl_cmdrun_wait(g_msg CLIPPED)
               END IF
            ELSE
               CALL cl_err('','aps-713',1)
            END IF
 
         WHEN "po_change"
            IF g_vob[l_ac].vaz24 = 1 THEN   #FUN-870153     
               LET g_msg = " apmt910 "               
               CALL cl_cmdrun_wait(g_msg CLIPPED)   
            ELSE
              CALL cl_err('','aps-713',1)
            END IF 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t810_q()
 
   LET g_row_count = 0
   LET mi_curs_index = 0
   CALL cl_navigator_setting(mi_curs_index,g_row_count)
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL t810_curs()                           #取得查詢條件
 
   IF INT_FLAG THEN                           #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t810_count
    FETCH t810_count INTO g_row_count                           
    DISPLAY g_row_count TO FORMONLY.cnt                         
 
   OPEN t810_b_curs                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                      #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_vob01 TO NULL
      INITIALIZE g_vob02 TO NULL
   ELSE
      CALL t810_fetch('F')                    #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t810_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,     #處理方式                          
            l_abso   LIKE type_file.num10     #絕對的筆數                       
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t810_b_curs INTO g_vob01,g_vob02
      WHEN 'P' FETCH PREVIOUS t810_b_curs INTO g_vob01,g_vob02
      WHEN 'F' FETCH FIRST    t810_b_curs INTO g_vob01,g_vob02
      WHEN 'L' FETCH LAST     t810_b_curs INTO g_vob01,g_vob02
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
      FETCH ABSOLUTE mi_jump t810_b_curs INTO g_vob01,g_vob02
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
         WHEN 'L' LET mi_curs_index = g_row_count #No.FUN-580092 HCN
         WHEN '/' LET mi_curs_index = mi_jump
      END CASE
 
      CALL cl_navigator_setting(mi_curs_index, g_row_count) 
      CALL t810_show()
   END IF
 
END FUNCTION
 
FUNCTION t810_show()
 
   CLEAR FROM
   CALL g_vob.clear()
   DISPLAY g_vob01 TO FORMONLY.vob01              #單頭
   DISPLAY g_vob02 TO FORMONLY.vob02              #單頭
 
   CALL t810_b_fill()                   #單身 FUN-870099
 
   CALL cl_show_fld_cont()            
END FUNCTION
 
FUNCTION t810_b()
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
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t810_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
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
            OPEN t810_b_curl USING g_plant,g_vob01,g_vob02,g_vob[l_ac].vob03 
            IF STATUS THEN
               CALL cl_err("OPEN t810_b_cur1:",STATUS,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t810_b_curl INTO g_vob[l_ac].vob36
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
            CLOSE t810_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_vob[l_ac].vob36,-263,1)
            LET g_vob[l_ac].* = g_vob_t.*
         ELSE
            UPDATE vob_file SET vob36=g_vob[l_ac].vob36
             WHERE vob00=g_plant
               AND vob01=g_vob01
               AND vob02=g_vob02
               AND vob03=g_vob[l_ac].vob03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","vob_file",g_vob01,g_vob_t.vob36,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_vob[l_ac].* = g_vob_t.*
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
               LET g_vob[l_ac].* = g_vob_t.*
            END IF
            CLOSE t810_b_curl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE t810_b_curl
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
 
   CLOSE t810_b_curl
   COMMIT WORK
 
END FUNCTION
 
#FUNCTION t810_b_askkey()
#DEFINE
#   l_begin_key     LIKE vob_file.vob03
#
#   CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
#            LET INT_FLAG = 0  ######add for prompt bug
#   PROMPT g_msg CLIPPED,': ' FOR l_begin_key
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
# 
#      ON ACTION about                    
#         CALL cl_about()                 
# 
#      ON ACTION help                     
#         CALL cl_show_help()             
# 
#      ON ACTION controlg                 
#         CALL cl_cmdask()                
# 
#   END PROMPT
#
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      RETURN
#   END IF
#
#   IF l_begin_key IS NULL THEN
#      LET l_begin_key = 0
#   END IF
#
#   CALL t810_b_fill(l_begin_key)
#
#END FUNCTION
 
FUNCTION t810_b_fill()              #BODY FILL UP
DEFINE g_wc  STRING
 
DEFINE l_pmk25 LIKE pmk_file.pmk25,
       l_pml20 LIKE pml_file.pml20,
       l_pmm25 LIKE pmm_file.pmm25,
       l_pmn50 LIKE pmn_file.pmn50,
       l_pmn20 LIKE pmn_file.pmn20,
       l_pml21 LIKE pml_file.pml21, #FUN-860060  add
       #l_pml35 LIKE pml_file.pml35, #FUN-860060  add  #FUN-8A0149 MARK
       l_pml34 LIKE pml_file.pml34,  #FUN-8A0149  add
       l_pmn5358 LIKE pmn_file.pmn53, #FUN-860060 add
       #l_pmn35 LIKE pmn_file.pmn35    #FUN-8A0149 MARK
       l_pmn34 LIKE pmn_file.pmn34   #FUN-8A0149 add 
 
   #FUN-870099
   IF (g_vob[1].vaz24='0') or (g_vob[1].vaz24='') or (g_vob[1].vaz24 is NULL) THEN
   LET g_sql = "SELECT vob36,'',vaz24,vob13,gen01,pmc01,vaz23,vob07,'', ",
               "  vob11,'',vob08,'',vob33,'',vob04,'',vob03,vob20,voc05,vob14  ", #FUN-860060 
               "  FROM voc_file,vaz_file,vob_file LEFT OUTER JOIN ",
        " (pmk_file LEFT OUTER JOIN pmc_file ON pmk09=pmc01 ",
        " LEFT OUTER JOIN gen_file ON pmk12=gen01) ON vob13=pmk01         ",
               " WHERE voc00=vob00          ",
               "   AND voc01=vob01          ",
               "   AND voc02=vob02          ",
               "   AND voc03=vob03          ",
               "   AND vaz01=vob03          ",
               "   AND vob05='0'            ",
               "   AND vaz10=vob13          ",
               "   AND vob01 = '",g_vob01,"'",
               "   AND vob02 = '",g_vob02,"'",  
               "   AND vob00 = '",g_plant,"'",
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND (voc04<>'0' or voc05<>'0') " #FUN-860060
   ELSE
   LET g_sql = "SELECT vob36,'',vaz24,vob13,gen01,pmc01,vaz23,vob07,'', ",
               " vob11,'',vob08,'',vob33,'',vob04,'',vob03,vob20,voc05,vob14  ",
               "  FROM voc_file,vaz_file,vob_file LEFT OUTER JOIN ( ",
        " pmm_file LEFT OUTER JOIN pmc_file ON pmm09=pmc01 ",
        " LEFT OUTER JOIN gen_file ON pmm12=gen01) ",
        " ON vob13=pmm01 ",
               " WHERE voc00=vob00",
               "   AND voc01=vob01          ",
               "   AND voc02=vob02          ",
               "   AND voc03=vob03          ",
               "   AND vaz01=vob03          ",
               "   AND vob05='0'            ",
               "   AND vaz10=vob13          ",
               "   AND vob01 = '",g_vob01,"'",
               "   AND vob02 = '",g_vob02,"'",
               "   AND vob00 = '",g_plant,"'",
               "   AND ",tm.wc CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND (voc04<>'0' or voc05<>'0') " #FUN-860060
   END IF
 
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
 
     #來源項次  mark by FUN-860060 duke
     # SELECT vaz23 INTO g_vob[g_cnt].vaz23
     #   FROM vaz_file,vob_file 
     #  WHERE vaz01=vob03 AND vaz10=g_vob[g_cnt].vob13
 
     #品名
      SELECT ima02 INTO g_vob[g_cnt].ima02
        FROM ima_file 
       WHERE ima01=g_vob[g_cnt].vob07
 
     #FUN-860060 建議交貨日期
      if g_vob[g_cnt].voc05='1' then 
         let g_vob[g_cnt].sdate=g_vob[g_cnt].vob14
      else
         let g_vob[g_cnt].sdate=''
      end if
     #FUN-860060 建議調整數量
      LET g_vob[g_cnt].qty=g_vob[g_cnt].vob33 - g_vob[g_cnt].vob08
 
     #FUN-870099  請採購人員
      IF g_vob[g_cnt].vaz24='0' THEN 
         
         SELECT  pmk12 into g_vob[g_cnt].gen01 
           FROM pmk_file
         WHERE pmk01=g_vob[g_cnt].vob13 
      ELSE
         SELECT  pmm12 into g_vob[g_cnt].gen01
           FROM pmm_file
         WHERE  pmm01=g_vob[g_cnt].vob13
      END IF
 
     #FUN-870099 廠商
     IF g_vob[g_cnt].vaz24='0' THEN
       #SELECT  pmc09 into g_vob[g_cnt].pmc01  #EXT-940017 MARK  #MOD-940217 MOD
       SELECT pmk09 into g_vob[g_cnt].pmc01  #EXT-940017 ADD     #MOD-940217 MOD
          FROM pmk_file
        WHERE  pmk01=g_vob[g_cnt].vob13
          
     ELSE
        SELECT  pmm09 into g_vob[g_cnt].pmc01
          FROM pmm_file
        WHERE  pmm01=g_vob[g_cnt].vob13
          
     END IF
 
 
      CASE g_vob[g_cnt].vaz24  
        WHEN '0'  
          #l_pml20,unst_qty,sdate
          # FUN-860060  add pml21, pml35, ischange by duke
           
           SELECT pml20,
                  (pml20-pml21),
                  pml21,
                  #pml35   #FUN-8A0149 MARK
                  pml34    #FUN-8A0149 ADD
                  INTO 
                  l_pml20,
                  g_vob[g_cnt].unst_qty,
                  l_pml21,
                  #l_pml35  #FUN-8A0149 MARK
                  l_pml34   #FUN-8A0149 ADD
             FROM pml_file 
            WHERE pml01=g_vob[g_cnt].vob13 
              AND pml02=g_vob[g_cnt].vaz23
 
           if l_pml20<>g_vob[g_cnt].vob08 or 
              l_pml21<>g_vob[g_cnt].vob20 or 
              #l_pml35<>g_vob[g_cnt].vob04 then  #FUN-8A0149 MARK
              l_pml34<>g_vob[g_cnt].vob04 then   #FUN-8A0149 ADD
              let g_vob[g_cnt].ischange='Y'
           else 
              let g_vob[g_cnt].ischange='N'
           end if
 
          #status
           SELECT pmk25 INTO l_pmk25 FROM pmk_file WHERE pmk01=g_vob[g_cnt].vob13
                  IF l_pmk25='0' OR l_pmk25='1' then    
                     LET g_vob[g_cnt].status='A'
                  ELSE 
                     LET g_vob[g_cnt].status='D'
                  END IF                   
           
        WHEN '1'
          #unst_qty,sdate  mark by duke  FUN-860060
          # SELECT (pmn50-pmn55),pmn20,(pmn20-pmn50+pmn55),pmn33 
          #   INTO l_pmn50,l_pmn20,g_vob[g_cnt].unst_qty,g_vob[g_cnt].sdate
          #   FROM pmn_file 
          #  WHERE pmn01=g_vob[g_cnt].vob13 
          #    AND pmn02=g_vob[g_cnt].vaz23  
 
          # FUN-860060 ischange, unst_qty
          #  select pmn20,pmn53-pmn58,pmn35,pmn20-pmn53+pmn58  #FUN-8A0149 MARK
          #    into l_pmn20,l_pmn5358,l_pmn35, g_vob[g_cnt].unst_qty  #FUN-8A0149 MARK
 
            SELECT pmn20,pmn53-pmn58,pmn34,pmn20-pmn53+pmn58  #FUN-8A0149 ADD
              INTO l_pmn20,l_pmn5358,l_pmn34, g_vob[g_cnt].unst_qty  #FUN-8A0149 ADD
              FROM pmn_file
             WHERE pmn01=g_vob[g_cnt].vob13
               AND pmn02=g_vob[g_cnt].vaz23 
            IF l_pmn20<>g_vob[g_cnt].vob08 OR 
               l_pmn5358<>g_vob[g_cnt].vob20 OR 
               #l_pmn35<>g_vob[g_cnt].vob04 then   #FUN-8A0149 MARK
               l_pmn34<>g_vob[g_cnt].vob04 THEN    #FUN-8A0149 ADD
               LET g_vob[g_cnt].ischange='Y'
            ELSE
               LET g_vob[g_cnt].ischange='N'
            END IF
 
          #status
           SELECT pmm25 INTO l_pmm25 FROM pmm_file WHERE pmm01=g_vob[g_cnt].vob13
                  IF l_pmm25='1' or l_pmm25='0' then  #FUN-860060  add pmm25  
                     LET g_vob[g_cnt].status='B'
                  ELSE 
                     #FUN-8A0149 MARK
                     ##IF l_pmm25='2' AND g_vob[g_cnt].vob33>l_pmn20 THEN  #FUN-860060 change l_pmn55 to l_pmn20   
                     IF l_pmm25='2' AND g_vob[g_cnt].vob33>=l_pmn20 THEN #FUN-8A0149 ADD
                        LET g_vob[g_cnt].status='C'
                     ELSE
                        IF l_pmm25='2' AND g_vob[g_cnt].vob33<l_pmn20 THEN    
                           #FUN-860060
                           #MOD-870293--mod--str--
                           IF g_vob[g_cnt].unst_qty>=l_pmn20-g_vob[g_cnt].vob33 then
                              LET g_vob[g_cnt].status='C'
                           ELSE
                              LET g_vob[g_cnt].status='D'
                           END IF
                           #MOD-870293--mod--end--
                        END IF  
                        #FUN-860060 add
                        IF l_pmm25 <>'0' and l_pmm25<>'1' and l_pmm25<>'2' then
                           LET g_vob[g_cnt].status='D'
                        END IF
                     END IF                          
                  END IF
      END CASE
      LET g_rec_b = g_rec_b + 1 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_vob.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t810_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1                           
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_vob TO s_vob.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
          CALL cl_navigator_setting(mi_curs_index,g_row_count) 
 
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
         CALL t810_fetch('F')
         CALL cl_navigator_setting(mi_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)                     
         END IF
         ACCEPT DISPLAY                                          
 
      ON ACTION previous
         CALL t810_fetch('P')
         CALL cl_navigator_setting(mi_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)                     
           END IF
	 ACCEPT DISPLAY                                          
 
      ON ACTION jump
         CALL t810_fetch('/')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)                                      
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)                     
         END IF
	 ACCEPT DISPLAY                                          
 
      ON ACTION last
         CALL t810_fetch('L')
         CALL cl_navigator_setting(mi_curs_index, g_row_count)                                      
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)                     
         END IF
	 ACCEPT DISPLAY                                          
 
      ON ACTION next
         CALL t810_fetch('N')
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
 
      ON ACTION pr_detail #請購單維護
         #TQC-890023
         IF cl_null(g_rec_b) or g_rec_b = 0 THEN 
            LET g_action_choice=''
            CALL cl_err('','ain-070',0)
         ELSE LET g_action_choice="pr_detail"
         END IF
         EXIT DISPLAY
 
      ON ACTION pr_closing #請購單結案維護
         #TQC-890023
         IF cl_null(g_rec_b) or g_rec_b = 0 THEN 
            LET g_action_choice=''
            CALL cl_err('','ain-070',0)
         ELSE LET g_action_choice="pr_closing"
         END IF
         EXIT DISPLAY
 
      ON ACTION po_detail #採購單維護
         #TQC-890023
         IF cl_null(g_rec_b) or g_rec_b = 0 THEN 
            LET g_action_choice=''
            CALL cl_err('','ain-070',0)
         ELSE LET g_action_choice="po_detail"
         END IF
         EXIT DISPLAY
 
      ON ACTION po_change #開立採購變更單
         #TQC-890023
         IF cl_null(g_rec_b) or g_rec_b = 0 THEN 
            LET g_action_choice=''
            CALL cl_err('','ain-070',0)
         ELSE LET g_action_choice="po_change"
         END IF
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
