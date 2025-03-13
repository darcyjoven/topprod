# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almt675.4gl
# Descriptions...: 券核銷作業
# Date & Author..: 08/11/12 By Carrier
# Modify.........: No.FUN-960134 09/07/31 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/24 By shiwuying add oriu,orig
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:TQC-A10174 10/01/29 By shiwuying 新增時門店不開放
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80148 10/09/03 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位 
# Modify.........: No:TQC-B30101 11/03/11 By baogc 隱藏簽核欄位,簽核狀態欄位
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No.TQC-C20533 12/03/02 By nanbing 確認時，更新lqe_file表
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C90070 12/09/21 By xumm 添加GR打印功能
# Modify.........: No.FUN-CA0152 12/11/13 By xumm 券状态4改为已用增加7核销
# Modify.........: No:CHI-C80041 12/12/26 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No.FUN-D10040 13/01/18 By xumm 券状态改为4:已用
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_lqa               RECORD LIKE lqa_file.*        #簽核等級 (單頭)
DEFINE g_lqa_t             RECORD LIKE lqa_file.*        #簽核等級 (舊值)
DEFINE g_lqa_o             RECORD LIKE lqa_file.*        #簽核等級 (舊值)
DEFINE g_lqa01_t           LIKE lqa_file.lqa01           #簽核等級 (舊值)
#DEFINE g_t1                LIKE lrk_file.lrkslip        #FUN-A70130    mark
#DEFINE g_sheet             LIKE lrk_file.lrkslip        #FUN-A70130    mark
DEFINE g_t1                LIKE oay_file.oayslip
DEFINE g_sheet             LIKE oay_file.oayslip
DEFINE g_lqb               DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
                           lqb02   LIKE lqb_file.lqb02,  #券編號
                           lqb03   LIKE lqb_file.lqb03,  #券類型編號
                           lpx02   LIKE lpx_file.lpx02,  #券類型說明
                           lqb04   LIKE lqb_file.lqb04,  #券面額編號
                           lrz02   LIKE lrz_file.lrz02,  #券面額說明
                           lqb05   LIKE lqb_file.lqb05,  #券原始狀態
                           lqb06   LIKE lqb_file.lqb06,  #券原始狀態日期
                           lqb07   LIKE lqb_file.lqb07,  #核銷狀態
                           lqb08   LIKE lqb_file.lqb08   #核銷次數
                           END RECORD
DEFINE g_lqb_t             RECORD                        #程式變數 (舊值)
                           lqb02   LIKE lqb_file.lqb02,  #券編號
                           lqb03   LIKE lqb_file.lqb03,  #券類型編號
                           lpx02   LIKE lpx_file.lpx02,  #券類型說明
                           lqb04   LIKE lqb_file.lqb04,  #券面額編號
                           lrz02   LIKE lrz_file.lrz02,  #券面額說明
                           lqb05   LIKE lqb_file.lqb05,  #券原始狀態
                           lqb06   LIKE lqb_file.lqb06,  #券原始狀態日期
                           lqb07   LIKE lqb_file.lqb07,  #核銷狀態
                           lqb08   LIKE lqb_file.lqb08   #核銷次數
                           END RECORD
DEFINE g_lqb_o             RECORD                        #程式變數 (舊值)
                           lqb02   LIKE lqb_file.lqb02,  #券編號
                           lqb03   LIKE lqb_file.lqb03,  #券類型編號
                           lpx02   LIKE lpx_file.lpx02,  #券類型說明
                           lqb04   LIKE lqb_file.lqb04,  #券面額編號
                           lrz02   LIKE lrz_file.lrz02,  #券面額說明
                           lqb05   LIKE lqb_file.lqb05,  #券原始狀態
                           lqb06   LIKE lqb_file.lqb06,  #券原始狀態日期
                           lqb07   LIKE lqb_file.lqb07,  #核銷狀態
                           lqb08   LIKE lqb_file.lqb08   #核銷次數
                           END RECORD
DEFINE g_sql               STRING                        #CURSOR暫存
DEFINE g_wc                STRING                        #單頭CONSTRUCT結果
DEFINE g_wc2               STRING                        #單身CONSTRUCT結果
DEFINE g_rec_b             LIKE type_file.num5           #單身筆數
DEFINE l_ac                LIKE type_file.num5           #目前處理的ARRAY CNT
 
DEFINE g_forupd_sql        STRING                        #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5           #count/index for any purpose
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10          #總筆數
DEFINE g_jump              LIKE type_file.num10          #查詢指定的筆數
DEFINE g_no_ask           LIKE type_file.num5           #是否開啟指定筆視窗
DEFINE g_argv1             LIKE lqa_file.lqa01           #核銷單號
#DEFINE g_kindtype          LIKE lrk_file.lrkkind        #FUN-A70130  mark
DEFINE g_kindtype          LIKE oay_file.oaytype        #FUN-A70130
#FUN-C90070----add---str
DEFINE g_wc1             STRING
DEFINE g_wc3             STRING
DEFINE g_wc4             STRING
DEFINE l_table           STRING
TYPE sr1_t RECORD
    lqa01     LIKE lqa_file.lqa01, 
    lqa02     LIKE lqa_file.lqa02,
    lqaplant  LIKE lqa_file.lqaplant,
    lqa04     LIKE lqa_file.lqa04,
    lqa07     LIKE lqa_file.lqa07,
    lqa08     LIKE lqa_file.lqa08,
    lqa09     LIKE lqa_file.lqa09,
    lqb02     LIKE lqb_file.lqb02,
    lqb03     LIKE lqb_file.lqb03,
    lqb04     LIKE lqb_file.lqb04,
    lqb05     LIKE lqb_file.lqb05,
    lqb06     LIKE lqb_file.lqb06,
    lqb07     LIKE lqb_file.lqb07,
    lqb08     LIKE lqb_file.lqb08,
    rtz13     LIKE rtz_file.rtz13,
    lpx02     LIKE lpx_file.lpx02,
    lrz02     LIKE lrz_file.lrz02
END RECORD
#FUN-C90070----add---end
DEFINE g_void              LIKE type_file.chr1      #CHI-C80041
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP 
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   LET g_argv1=ARG_VAL(1)                #核銷單號
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   #FUN-C90070------add-----str
   LET g_pdate = g_today
   LET g_sql ="lqa01.lqa_file.lqa01,",
              "lqa02.lqa_file.lqa02,",
              "lqaplant.lqa_file.lqaplant,",
              "lqa04.lqa_file.lqa04,",
              "lqa07.lqa_file.lqa07,",
              "lqa08.lqa_file.lqa08,",
              "lqa09.lqa_file.lqa09,",
              "lqb02.lqb_file.lqb02,",
              "lqb03.lqb_file.lqb03,",
              "lqb04.lqb_file.lqb04,",
              "lqb05.lqb_file.lqb05,",
              "lqb06.lqb_file.lqb06,",
              "lqb07.lqb_file.lqb07,",
              "lqb08.lqb_file.lqb08,",
              "rtz13.rtz_file.rtz13,",
              "lpx02.lpx_file.lpx02,",
              "lrz02.lrz_file.lrz02"
   LET l_table = cl_prt_temptable('almt675',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-C90070------add-----end
   LET g_forupd_sql = "SELECT * FROM lqa_file WHERE lqa01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t675_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t675_w WITH FORM "alm/42f/almt675"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
##-TQC-B30101 ADD-BEGIN------
   CALL cl_set_comp_visible("lqa05,lqa06",FALSE)
##-TQC-B30101 ADD--END-------
 
   IF NOT cl_null(g_argv1) THEN
      IF cl_chk_act_auth() THEN
         CALL t675_q()
      END IF
   ELSE
      CALL t675_menu()
   END IF
 
   CLOSE WINDOW t675_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)    #FUN-C90070 add
END MAIN
 
#QBE 查詢資料
FUNCTION t675_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM
   CALL g_lqb.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " lqa01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_lqa.* TO NULL
      CONSTRUCT BY NAME g_wc ON lqa01,lqa02,lqa04,lqaplant,lqalegal,
                                lqa05,lqa06,lqa07,
                                lqa08,lqa09,lqauser,lqagrup,lqaoriu,lqaorig,#No:FUN-9B0136
                                lqacrat,lqamodu,lqaacti,lqadate
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(lqa01)               #單據編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lqa01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lqa01
                  NEXT FIELD lqa01
               WHEN INFIELD(lqaplant)               #門店
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lqaplant"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lqaplant
                  NEXT FIELD lqaplant
               WHEN INFIELD(lqalegal)               #法人
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lqalegal"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lqalegal
                  NEXT FIELD lqalegal
               WHEN INFIELD(lqa08)               #審核人
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lqa08"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lqa08
                  NEXT FIELD lqa08
               OTHERWISE EXIT CASE
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
 
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND lqauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND lqagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #
   #      LET g_wc = g_wc clipped," AND lqagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lqauser', 'lqagrup')
   #End:FUN-980030
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'
   ELSE
      CONSTRUCT g_wc2 ON lqb02,lqb03,lqb04,lqb05,lqb06,lqb07,lqb08
                FROM s_lqb[1].lqb02,s_lqb[1].lqb03,s_lqb[1].lqb04,
                     s_lqb[1].lqb05,s_lqb[1].lqb06,s_lqb[1].lqb07,
                     s_lqb[1].lqb08
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(lqb02)               #券編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lqb02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lqb02
                  NEXT FIELD lqb02
               WHEN INFIELD(lqb03)               #券類型編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lqb03"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lqb03
                  NEXT FIELD lqb03
               WHEN INFIELD(lqb04)               #券面額編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lqb04"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lqb04
                  NEXT FIELD lqb04
               OTHERWISE EXIT CASE
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT lqa01 FROM lqa_file ",
                  " WHERE ", g_wc CLIPPED,
                # "   AND lqaplant IN ",g_auth,
                  " ORDER BY lqa01"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE lqa01 ",
                  "  FROM lqa_file, lqb_file ",
                  " WHERE lqa01 = lqb01 ",
                # "   AND lqaplant IN ",g_auth,
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lqa01"
   END IF
 
   PREPARE t675_prepare FROM g_sql
   DECLARE t675_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t675_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM lqa_file WHERE ",g_wc CLIPPED
               #"   AND lqaplant IN ",g_auth
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lqa01) FROM lqa_file,lqb_file",
                " WHERE lqa01 = lqb01 ",
               #"   AND lqaplant IN ",g_auth,
                "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t675_precount FROM g_sql
   DECLARE t675_count CURSOR FOR t675_precount
 
END FUNCTION
 
FUNCTION t675_menu()
 
   WHILE TRUE
      CALL t675_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t675_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t675_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t675_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t675_u()
            END IF
 
#FUN-C90070------add------str
         WHEN "output"        
            IF cl_chk_act_auth() THEN
               CALL t675_out()
            END IF
#FUN-C90070------add------end

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t675_x()
            END IF
 
        #WHEN "reproduce"
        #   IF cl_chk_act_auth() THEN
        #      CALL t675_copy()
        #   END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t675_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
        #WHEN "output"
        #   IF cl_chk_act_auth() THEN
        #      CALL t675_out()
        #   END IF
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t675_y()
            END IF
 
        #WHEN "undo_confirm"
        #   IF cl_chk_act_auth() THEN
        #      CALL t675_z()
        #   END IF
 
         WHEN "gen_body"
            IF cl_chk_act_auth() THEN
               CALL t675_gen_body('u')
            END IF
 
         WHEN "delete_body"
            IF cl_chk_act_auth() THEN
               CALL t675_delete_body()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lqb),'','')
            END IF
 
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_lqa.lqa01 IS NOT NULL THEN
                  LET g_doc.column1 = "lqa01"
                  LET g_doc.value1 = g_lqa.lqa01
                  CALL cl_doc()
               END IF
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t675_v()
               IF g_lqa.lqa07='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_lqa.lqa07,g_lqa.lqa06,'','',g_void,g_lqa.lqaacti)
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t675_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lqb TO s_lqb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
     #ON ACTION modify
     #   LET g_action_choice="modify"
     #   EXIT DISPLAY
      
      #FUN-C90070---add---str
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      #FUN-C90070---add---end
 
      ON ACTION first
         CALL t675_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t675_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t675_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t675_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t675_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
     #ON ACTION reproduce
     #   LET g_action_choice="reproduce"
     #   EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
     #ON ACTION output
     #   LET g_action_choice="output"
     #   EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
     #ON ACTION undo_confirm
     #   LET g_action_choice="undo_confirm"
     #   EXIT DISPLAY
 
      ON ACTION gen_body
         LET g_action_choice="gen_body"
         EXIT DISPLAY
 
     #ON ACTION delete_body
     #   LET g_action_choice="delete_body"
     #   EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
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
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t675_bp_refresh()
  DISPLAY ARRAY g_lqb TO s_lqb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t675_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_lqb.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lqa.* LIKE lqa_file.*             #DEFAULT 設定
   LET g_lqa01_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_lqa_t.* = g_lqa.*
   LET g_lqa_o.* = g_lqa.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_lqa.lqa02 = '1'
      SELECT * FROM rtz_file WHERE rtz01 = g_plant
      IF SQLCA.sqlcode = 0 THEN  #若是門店login,非區域時
         LET g_lqa.lqaplant = g_plant
      END IF
      LET g_lqa.lqa04 = g_today
      LET g_lqa.lqa05 = 'N'      #簽核否
      LET g_lqa.lqa06 = '0'      #簽核狀態
      LET g_lqa.lqa07 = 'N'      #審核狀態
      LET g_lqa.lqauser=g_user
      LET g_lqa.lqaoriu = g_user #FUN-980030
      LET g_lqa.lqaorig = g_grup #FUN-980030
      LET g_lqa.lqagrup=g_grup
      LET g_lqa.lqacrat=g_today
      LET g_lqa.lqaacti='Y'              #資料有效
      LET g_lqa.lqaplant = g_plant       #No.TQC-A10174
      LET g_lqa.lqalegal = g_legal       #No.TQC-A10174
      LET g_data_plant = g_plant         #No.FUN-A10060
 
      CALL t675_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_lqa.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_lqa.lqa01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
      #CALL s_auto_assign_no("alm",g_lqa.lqa01,g_lqa.lqa04,'23',"lqa_file","lqa01",g_lqa.lqaplant,"","") #FUN-A70130
      CALL s_auto_assign_no("alm",g_lqa.lqa01,g_lqa.lqa04,'M2',"lqa_file","lqa01",g_lqa.lqaplant,"","") #FUN-A70130
           RETURNING li_result,g_lqa.lqa01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lqa.lqa01
 
      INSERT INTO lqa_file VALUES (g_lqa.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
      #   ROLLBACK WORK               # FUN-B80060 下移兩行
         CALL cl_err3("ins","lqa_file",g_lqa.lqa01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK               # FUN-B80060
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_lqa.lqa01,'I')
      END IF
 
      SELECT * INTO g_lqa.* FROM lqa_file
       WHERE lqa01 = g_lqa.lqa01
      LET g_lqa01_t = g_lqa.lqa01        #保留舊值
      LET g_lqa_t.* = g_lqa.*
      LET g_lqa_o.* = g_lqa.*
      CALL g_lqb.clear()
 
      LET g_rec_b = 0
      CALL t675_gen_body('a')
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t675_u()
   DEFINE l_lrz02       LIKE lrz_file.lrz02
   DEFINE l_lqb05       LIKE lqb_file.lqb05
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lqa.lqa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lqa.* FROM lqa_file
    WHERE lqa01=g_lqa.lqa01
   IF g_lqa.lqaplant <> g_plant THEN
      CALL cl_err(g_lqa.lqaplant,'alm-399',0)
      RETURN
   END IF
   IF g_lqa.lqaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lqa.lqa01,'mfg1000',0)
      RETURN
   END IF
   IF g_lqa.lqa07 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lqa.lqa07 = 'Y' THEN
      CALL cl_err(g_lqa.lqa01,'mfg1005',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lqa01_t = g_lqa.lqa01
   BEGIN WORK
 
   OPEN t675_cl USING g_lqa.lqa01
   IF STATUS THEN
      CALL cl_err("OPEN t675_cl:", STATUS, 1)
      CLOSE t675_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t675_cl INTO g_lqa.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lqa.lqa01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t675_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t675_show()
 
   WHILE TRUE
      LET g_lqa01_t = g_lqa.lqa01
      LET g_lqa_o.* = g_lqa.*
      LET g_lqa.lqamodu=g_user
      LET g_lqa.lqadate=g_today
 
      CALL t675_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lqa.*=g_lqa_t.*
         CALL t675_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      # 門店變化且原來是自動核銷
     #IF g_lqa_t.lqaplant <> g_lqa.lqaplant AND g_lqa_t.lqa02 = '0' THEN
      IF g_lqa_t.lqaplant <> g_lqa.lqaplant THEN
         DELETE FROM lqb_file WHERE lqb01 = g_lqa01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","lqb_file",g_lqa01_t,"",SQLCA.sqlcode,"","lqb",1)
            CONTINUE WHILE
         END IF
      END IF
      IF g_lqa.lqa01 != g_lqa01_t THEN            # 更改單號
         UPDATE lqb_file SET lqb01 = g_lqa.lqa01
          WHERE lqb01 = g_lqa01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lqb_file",g_lqa01_t,"",SQLCA.sqlcode,"","lqb",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE lqa_file SET lqa_file.* = g_lqa.*
       WHERE lqa01 = g_lqa01_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lqa_file",g_lqa01_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t675_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lqa.lqa01,'U')
 
   CALL t675_b_fill("1=1")
   CALL t675_bp_refresh()
 
END FUNCTION
 
FUNCTION t675_i(p_cmd)
   DEFINE l_n         LIKE type_file.num5 
   DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改
   DEFINE li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lqa.lqaoriu,g_lqa.lqaorig,g_lqa.lqa01,g_lqa.lqa02,g_lqa.lqaplant,g_lqa.lqa04,
                   g_lqa.lqa05,g_lqa.lqa06,g_lqa.lqa07,g_lqa.lqa08,
                   g_lqa.lqa09,
                   g_lqa.lqauser,g_lqa.lqamodu,g_lqa.lqacrat,
                   g_lqa.lqagrup,g_lqa.lqadate,g_lqa.lqaacti
                  ,g_lqa.lqaplant,g_lqa.lqalegal    #No.TQC-A10174
   CALL t675_lqaplant('d')                          #No.TQC-A10174
 
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_lqa.lqa01,g_lqa.lqa02,g_lqa.lqa04,g_lqa.lqaplant 
         WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t675_set_entry(p_cmd)
         CALL t675_set_no_entry(p_cmd)
         CALL cl_set_comp_entry("lqaplant",FALSE)   #No.TQC-A10174
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("lqa01")
 
      AFTER FIELD lqa01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(g_lqa.lqa01) THEN
            #CALL s_check_no("alm",g_lqa.lqa01,g_lqa01_t,'23',"lqa_file","lqa01","") #FUN-A70130
            CALL s_check_no("alm",g_lqa.lqa01,g_lqa01_t,'M2',"lqa_file","lqa01","") #FUN-A70130
                 RETURNING li_result,g_lqa.lqa01
            IF (NOT li_result) THEN
               LET g_lqa.lqa01=g_lqa_o.lqa01
               NEXT FIELD lqa01
            END IF
            DISPLAY BY NAME g_lqa.lqa01
            IF cl_null(g_lqa_o.lqa01) OR (g_lqa.lqa01 <> g_lqa_o.lqa01) THEN
          #     LET g_lqa.lqa05 = g_lrk.lrkapr  #簽核否     #FUN-A70130   mark
                LET g_lqa.lqa05 = g_oay.oayapr  #簽核否     #FUN-A70130 
            END IF
         END IF
 
      AFTER FIELD lqaplant                  #門店編號
         IF NOT cl_null(g_lqa.lqaplant) THEN
            IF g_lqa_o.lqaplant IS NULL OR g_lqa_o.lqaplant != g_lqa.lqaplant THEN
               CALL t675_lqaplant(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lqa.lqaplant,g_errno,0)
                  LET g_lqa.lqaplant = g_lqa_o.lqaplant
                  DISPLAY BY NAME g_lqa.lqaplant
                  NEXT FIELD lqaplant
               END IF
            END IF
            LET g_lqa_o.lqaplant = g_lqa.lqaplant
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lqa01)     #單據編號
               LET g_t1=s_get_doc_no(g_lqa.lqa01)
              # CALL q_lrk(FALSE,FALSE,g_t1,'23','ALM') RETURNING g_t1      #FUN-A70130  mark
               CALL q_oay(FALSE,FALSE,g_t1,'M2','ALM') RETURNING g_t1      #FUN-A70130  add
               LET g_lqa.lqa01 = g_t1
               DISPLAY BY NAME g_lqa.lqa01
               NEXT FIELD lqa01
            WHEN INFIELD(lqaplant)     #門店編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz_x"
               LET g_qryparam.default1 = g_lqa.lqaplant
               LET g_qryparam.where = " rtz01 IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_lqa.lqaplant
               DISPLAY BY NAME g_lqa.lqaplant
               CALL t675_lqaplant('d')
               NEXT FIELD lqaplant
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
FUNCTION t675_lqaplant(p_cmd)  #門店編號
    DEFINE l_rtz13      LIKE rtz_file.rtz13       #FUN-A80148
    DEFINE l_rtz28      LIKE rtz_file.rtz28
  # DEFINE l_rtzacti    LIKE rtz_file.rtzacti     #FUN-A80148 mark by vealxu
    DEFINE l_azwacti    LIKE azw_file.azwacti     #FUN-A80148 add  by vealxu 
    DEFINE p_cmd        LIKE type_file.chr1
    DEFINE l_cnt        LIKE type_file.num5
    DEFINE l_azt02      LIKE azt_file.azt02
 
   LET g_errno = ''
 
   SELECT rtz13,rtz28,azwacti                              #FUN-A80148 mod rtzacti -> azwacti by vealxu
     INTO l_rtz13,l_rtz28,l_azwacti                        #FUN-A80148 mod l_rtzacti -> l_azwacti by vealxu    
     FROM rtz_file INNER JOIN azw_file                     #FUN-A80148 add azw_file by vealxu
       ON rtz01 = azw01                                    #FUN-A80148 add by vealxu
    WHERE rtz01 = g_lqa.lqaplant
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-001'  #該門店編號不存在
                                  LET l_rtz13 = NULL
        WHEN l_rtz28 = 'N'        LET g_errno = 'alm-002'  #該筆門店資料未審核
      # WHEN l_rtzacti = 'N'      LET g_errno = 'aap-223'  #該門店編號無效!                 #FUN-A80148 mark by vealxu
        WHEN  l_azwacti = 'N'     LET g_errno = 'aap-223'  #該門店編號無效!                 #FUN-A80148 add  by vealxu
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) THEN
     #No.FUN-A10060 -BEGIN-------
     #SELECT COUNT(*) INTO l_cnt FROM azp_file
     # WHERE azp01 IN (SELECT azw01 FROM azw_file
     #                  WHERE azw07=g_lqa.lqaplant OR azw01=g_lqa.lqaplant)
      LET g_sql = " SELECT COUNT(*) FROM azp_file",
                  "  WHERE azp01 IN ",g_auth," ",
                  "    AND azp01 = '",g_lqa.lqaplant,"'"
      PREPARE sel_azp_pre01 FROM g_sql
      EXECUTE sel_azp_pre01 INTO l_cnt
     #No.FUN-A10060 -END-------
      IF l_cnt = 0  THEN
         LET g_errno = 'art-500'   #當前用戶不可存取此門店!
      END IF
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      IF p_cmd <> 'd' THEN
         SELECT azw02 INTO g_lqa.lqalegal FROM azw_file
          WHERE azw01 = g_lqa.lqaplant
         DISPLAY BY NAME g_lqa.lqalegal
      END IF
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_lqa.lqalegal
      DISPLAY l_azt02 TO FORMONLY.azt02
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   END IF
END FUNCTION
 
FUNCTION t675_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lqb.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t675_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lqa.* TO NULL
      RETURN
   END IF
 
   OPEN t675_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lqa.* TO NULL
   ELSE
      OPEN t675_count
      FETCH t675_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t675_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t675_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t675_cs INTO g_lqa.lqa01
      WHEN 'P' FETCH PREVIOUS t675_cs INTO g_lqa.lqa01
      WHEN 'F' FETCH FIRST    t675_cs INTO g_lqa.lqa01
      WHEN 'L' FETCH LAST     t675_cs INTO g_lqa.lqa01
      WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about
                      CALL cl_about()
 
                   ON ACTION help
                      CALL cl_show_help()
 
                   ON ACTION controlg
                      CALL cl_cmdask()
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t675_cs INTO g_lqa.lqa01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqa.lqa01,SQLCA.sqlcode,0)
      INITIALIZE g_lqa.* TO NULL
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
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
 
   SELECT * INTO g_lqa.* FROM lqa_file WHERE lqa01 = g_lqa.lqa01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lqa_file",g_lqa.lqa01,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lqa.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lqa.lqauser
   LET g_data_group = g_lqa.lqagrup
   LET g_data_plant = g_lqa.lqaplant #No.FUN-A10060

   CALL t675_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t675_show()
 
   LET g_lqa_t.* = g_lqa.*                #保存單頭舊值
   LET g_lqa_o.* = g_lqa.*                #保存單頭舊值
   DISPLAY BY NAME g_lqa.lqa01,g_lqa.lqa02,g_lqa.lqaplant,g_lqa.lqa04, g_lqa.lqaoriu,g_lqa.lqaorig,
                   g_lqa.lqa05,g_lqa.lqa06,g_lqa.lqa07,g_lqa.lqa08,
                   g_lqa.lqa09,g_lqa.lqalegal,
                   g_lqa.lqauser,g_lqa.lqagrup,g_lqa.lqamodu,
                   g_lqa.lqadate,g_lqa.lqaacti,g_lqa.lqacrat
 
   CALL t675_lqaplant('d')
   #CALL cl_set_field_pic(g_lqa.lqa07,g_lqa.lqa06,'','','',g_lqa.lqaacti)  #CHI-C80041
   IF g_lqa.lqa07='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_lqa.lqa07,g_lqa.lqa06,'','',g_void,g_lqa.lqaacti)  #CHI-C80041
   CALL t675_b_fill(g_wc2)                 #單身
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION t675_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lqa.lqa01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_lqa.lqaplant <> g_plant THEN
      CALL cl_err(g_lqa.lqaplant,'alm-399',0)
      RETURN
   END IF
   IF g_lqa.lqa07 = 'Y' THEN
      CALL cl_err(g_lqa.lqa01,'aap-019',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t675_cl USING g_lqa.lqa01
   IF STATUS THEN
      CALL cl_err("OPEN t675_cl:", STATUS, 1)
      CLOSE t675_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t675_cl INTO g_lqa.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqa.lqa01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t675_show()
 
   IF cl_exp(0,0,g_lqa.lqaacti) THEN                   #確認一下
      LET g_chr=g_lqa.lqaacti
      IF g_lqa.lqaacti='Y' THEN
         LET g_lqa.lqaacti='N'
      ELSE
         LET g_lqa.lqaacti='Y'
      END IF
 
      UPDATE lqa_file SET lqaacti=g_lqa.lqaacti,
                          lqamodu=g_user,
                          lqadate=g_today
       WHERE lqa01=g_lqa.lqa01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lqa_file",g_lqa.lqa01,"",SQLCA.sqlcode,"","",1)
         LET g_lqa.lqaacti=g_chr
      END IF
   END IF
 
   CLOSE t675_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lqa.lqa01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT lqaacti,lqamodu,lqadate
     INTO g_lqa.lqaacti,g_lqa.lqamodu,g_lqa.lqadate FROM lqa_file
    WHERE lqa01=g_lqa.lqa01
   DISPLAY BY NAME g_lqa.lqaacti,g_lqa.lqamodu,g_lqa.lqadate
   CALL cl_set_field_pic(g_lqa.lqa07,g_lqa.lqa06,'','','',g_lqa.lqaacti)
 
END FUNCTION
 
FUNCTION t675_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lqa.lqa01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lqa.* FROM lqa_file
    WHERE lqa01=g_lqa.lqa01
   IF g_lqa.lqaplant <> g_plant THEN
      CALL cl_err(g_lqa.lqaplant,'alm-399',0)
      RETURN
   END IF
   IF g_lqa.lqaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lqa.lqa01,'alm-147',0)
      RETURN
   END IF
   IF g_lqa.lqa07 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lqa.lqa07 = 'Y' THEN
      CALL cl_err(g_lqa.lqa01,'alm-028',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t675_cl USING g_lqa.lqa01
   IF STATUS THEN
      CALL cl_err("OPEN t675_cl:", STATUS, 1)
      CLOSE t675_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t675_cl INTO g_lqa.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqa.lqa01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t675_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lqa01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lqa.lqa01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM lqa_file WHERE lqa01 = g_lqa.lqa01
      DELETE FROM lqb_file WHERE lqb01 = g_lqa.lqa01
      CLEAR FORM
      CALL g_lqb.clear()
      OPEN t675_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t675_cs
         CLOSE t675_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t675_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t675_cs
         CLOSE t675_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t675_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t675_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t675_fetch('/')
      END IF
   END IF
 
   CLOSE t675_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lqa.lqa01,'D')
END FUNCTION
 
FUNCTION t675_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT lqb02,lqb03,'',lqb04,'',lqb05,lqb06,lqb07,lqb08",
               "  FROM lqb_file",
               " WHERE lqb01 ='",g_lqa.lqa01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lqb02 "
 
   PREPARE t675_pb FROM g_sql
   DECLARE lqb_cs CURSOR FOR t675_pb
 
   CALL g_lqb.clear()
   LET g_cnt = 1
 
   FOREACH lqb_cs INTO g_lqb[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT lpx02 INTO g_lqb[g_cnt].lpx02 FROM lpx_file
        WHERE lpx01 = g_lqb[g_cnt].lqb03
       SELECT lrz02 INTO g_lqb[g_cnt].lrz02 FROM lrz_file
        WHERE lrz01 = g_lqb[g_cnt].lqb04
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lqb.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t675_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lqa01,lqa04,lqaplant",TRUE)
    END IF
    CALL cl_set_comp_entry("lqa02",TRUE)
 
END FUNCTION
 
FUNCTION t675_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lqa01,lqa04,lqaplant",FALSE)
    END IF
    CALL cl_set_comp_entry("lqa02",FALSE)
 
END FUNCTION
 
FUNCTION t675_gen_body(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
 
   IF g_lqa.lqaplant <> g_plant THEN
      CALL cl_err(g_lqa.lqaplant,'alm-399',0)
      RETURN
   END IF
   IF g_lqa.lqa02 = '0' THEN
      CALL t675_gen_body_automatic(p_cmd)
   ELSE
      CALL t675_gen_body_manual() 
   END IF
 
END FUNCTION
 
FUNCTION t675_gen_body_manual()
   DEFINE l_lpx01        LIKE lpx_file.lpx01
   DEFINE l_begin_no     LIKE type_file.num20
   DEFINE l_end_no       LIKE type_file.num20
   DEFINE l_j            LIKE type_file.num20
   DEFINE l_format       LIKE type_file.chr20
   DEFINE l_lpx23        LIKE lpx_file.lpx23 
   DEFINE l_lpx24        LIKE lpx_file.lpx24 
   DEFINE l_lqb          RECORD LIKE lqb_file.*
   DEFINE l_lqe          RECORD LIKE lqe_file.*
 
   IF g_lqa.lqa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lqa.* FROM lqa_file
    WHERE lqa01=g_lqa.lqa01
 
   IF g_lqa.lqaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lqa.lqa01,'mfg1000',0)
      RETURN
   END IF
   IF g_lqa.lqa07 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lqa.lqa07 = 'Y' THEN
      CALL cl_err(g_lqa.lqa01,'mfg1005',0)
      RETURN
   END IF
 
   OPEN WINDOW t675_1w WITH FORM "alm/42f/almt675_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("almt675_1")
 
   INPUT l_lpx01 WITHOUT DEFAULTS FROM FORMONLY.lpx01
         
      AFTER FIELD lpx01
         IF NOT cl_null(l_lpx01) THEN
            CALL t675_lpx01(l_lpx01) RETURNING l_format,l_lpx23,l_lpx24
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(l_lpx01,g_errno,0)
               LET l_lpx01 = NULL
               DISPLAY l_lpx01 TO FORMONLY.lpx01
               NEXT FIELD lpx01
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lpx01)     #券類型編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lpx"
               LET g_qryparam.default1 = l_lpx01
               CALL cl_create_qry() RETURNING l_lpx01
               DISPLAY l_lpx01 TO FORMONLY.lpx01
               CALL t675_lpx01(l_lpx01) RETURNING l_format,l_lpx23,l_lpx24
               NEXT FIELD lpx01
         END CASE
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t675_1w
      RETURN
   END IF
 
   INPUT l_begin_no,l_end_no WITHOUT DEFAULTS 
         FROM FORMONLY.beg_no,FORMONLY.end_no
         
      AFTER FIELD beg_no
         IF NOT cl_null(l_begin_no) THEN
            IF l_begin_no < 0 THEN
               NEXT FIELD beg_no
            END IF
            IF LENGTH(l_begin_no) > l_lpx24 THEN
               CALL cl_err(l_begin_no,'alm-460',0)    #所key數字長度超過流水碼位數長度,請重新錄入
               LET l_begin_no = NULL
               DISPLAY l_begin_no TO FORMONLY.beg_no
               NEXT FIELD beg_no
            END IF
            IF NOT cl_null(l_end_no) THEN
               IF l_begin_no > l_end_no THEN
                  CALL cl_err(l_begin_no,'alm-461',0) #起始號不可大于終止號
                  LET l_begin_no = NULL
                  DISPLAY l_begin_no TO FORMONLY.beg_no
                  NEXT FIELD beg_no
               END IF
            END IF
         END IF
 
      AFTER FIELD end_no
         IF NOT cl_null(l_end_no) THEN
            IF l_end_no < 0 THEN
               NEXT FIELD end_no
            END IF
            IF LENGTH(l_end_no) > l_lpx24 THEN
               CALL cl_err(l_end_no,'alm-460',0)    #所key數字長度超過流水碼位數長度,請重新錄入
               LET l_end_no = NULL
               DISPLAY l_end_no TO FORMONLY.end_no
               NEXT FIELD end_no
            END IF
            IF NOT cl_null(l_begin_no) THEN
               IF l_end_no < l_begin_no THEN
                  CALL cl_err(l_end_no,'alm-461',0) #起始號不可大于終止號
                  LET l_end_no = NULL
                  DISPLAY l_end_no TO FORMONLY.end_no
                  NEXT FIELD end_no
               END IF
            END IF
         END IF
   END INPUT
 
   CLOSE WINDOW t675_1w
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   INITIALIZE l_lqb.* TO NULL
   LET l_lqb.lqb01 = g_lqa.lqa01
   LET l_lqb.lqb03 = l_lpx01
   LET l_lqb.lqb08 = 0
   LET l_lqb.lqbplant = g_lqa.lqaplant
   LET l_lqb.lqblegal = g_lqa.lqalegal
 
   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()
   LET l_j = l_begin_no
   WHILE TRUE
       LET l_lqb.lqb02 = l_lpx23 CLIPPED,l_j USING l_format    
       SELECT * INTO l_lqe.* FROM lqe_file WHERE lqe01 = l_lqb.lqb02
       IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN 
          LET g_success = 'N'
          CALL s_errmsg('lqe01',l_lqb.lqb02,'sel lqe',SQLCA.sqlcode,1)
       ELSE
          IF SQLCA.sqlcode = 100 THEN #未登記的券
             LET l_lqb.lqb03 = ''
             LET l_lqb.lqb04 = ''
             LET l_lqb.lqb05 = ''
             LET l_lqb.lqb06 = ''
             LET l_lqb.lqb07 = '2'
          ELSE
             LET l_lqb.lqb03 = l_lpx01
             LET l_lqb.lqb04 = l_lqe.lqe03
             LET l_lqb.lqb05 = l_lqe.lqe17
             CASE l_lqe.lqe17
                  WHEN '0' LET l_lqb.lqb06 = l_lqe.lqe05
                           LET l_lqb.lqb07 = '1'
                  WHEN '1' LET l_lqb.lqb06 = l_lqe.lqe07
                           #LET l_lqb.lqb07 = '0'        #FUN-CA0152 mark
                           LET l_lqb.lqb07 = '1'         #FUN-CA0152 add
                  WHEN '2' LET l_lqb.lqb06 = l_lqe.lqe10
                           LET l_lqb.lqb07 = '1'
                  WHEN '3' LET l_lqb.lqb06 = l_lqe.lqe12
                           LET l_lqb.lqb07 = '1'
                 #FUN-CA0152-------MARK------STR
                 #WHEN '4' LET l_lqb.lqb06 = l_lqe.lqe19
                 #         LET l_lqb.lqb07 = '1'
               #TQC-C20533 add sta---
                 #WHEN '5' LET l_lqb.lqb06 = l_lqe.lqe14
                 #         LET l_lqb.lqb07 = '1'
                 #WHEN '6' LET l_lqb.lqb06 = l_lqe.lqe16
                 #         LET l_lqb.lqb07 = '1'
               #TQC-C20533 add  end---           
                 #FUN-CA0152-------MARK------END 
                 #FUN-CA0152-------ADD-------STR
                 WHEN '4' LET l_lqb.lqb07 = '0'
                          LET l_lqb.lqb06 = l_lqe.lqe25   #FUN-D10040
                 WHEN '5' LET l_lqb.lqb06 = l_lqe.lqe14
                          LET l_lqb.lqb07 = '0'
                 WHEN '6' LET l_lqb.lqb06 = l_lqe.lqe16
                          LET l_lqb.lqb07 = '0'
                 WHEN '7' LET l_lqb.lqb06 = l_lqe.lqe19
                          LET l_lqb.lqb07 = '0'                  
                 #FUN-CA0152-------ADD-------END
             END CASE
          END IF
          SELECT lqc06 INTO l_lqb.lqb08 FROM lqc_file
           WHERE lqc01 = l_lqb.lqb02
          IF cl_null(l_lqb.lqb08) THEN LET l_lqb.lqb08 = 0 END IF
       END IF
 
       IF g_success = 'Y' THEN
          INSERT INTO lqb_file VALUES(l_lqb.*)
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
             LET g_success = 'N'
             CALL s_errmsg('lqb02',l_lqb.lqb02,'insert lqb',SQLCA.sqlcode,1)
          END IF
       END IF
       LET g_success = 'Y'    #Carrier 前面即使有部分資料出現錯誤，其他資料也要插入
 
       LET l_j = l_j + 1
       IF l_j > l_end_no THEN EXIT WHILE END IF
   END WHILE
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
      
   CALL t675_b_fill("1=1")
   CALL t675_bp_refresh()
 
END FUNCTION
 
FUNCTION t675_gen_body_automatic(p_cmd)
   DEFINE p_cmd          LIKE type_file.chr1
   DEFINE l_rxy          RECORD LIKE rxy_file.*
   DEFINE l_lqb          RECORD LIKE lqb_file.*
   DEFINE l_lqe          RECORD LIKE lqe_file.*
   DEFINE l_len1         LIKE type_file.num5
   DEFINE l_len2         LIKE type_file.num5
   DEFINE l_lpx24        LIKE lpx_file.lpx24
   DEFINE l_str          LIKE type_file.chr20
   DEFINE l_str1         LIKE type_file.chr20
   DEFINE l_str2         LIKE type_file.chr20
   DEFINE l_format       LIKE type_file.chr20
   DEFINE l_begin_no     LIKE type_file.num20
   DEFINE l_end_no       LIKE type_file.num20
   DEFINE l_j            LIKE rxy_file.rxy14 
   DEFINE l_i            LIKE type_file.num5
 
   IF g_lqa.lqa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lqa.* FROM lqa_file
    WHERE lqa01=g_lqa.lqa01
 
   IF g_lqa.lqaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lqa.lqa01,'mfg1000',0)
      RETURN
   END IF
   IF g_lqa.lqa07 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lqa.lqa07 = 'Y' THEN
      CALL cl_err(g_lqa.lqa01,'mfg1005',0)
      RETURN
   END IF
   IF g_lqa.lqa04 IS NULL THEN RETURN END IF
 
#  IF g_aza.aza87 = 'Y' THEN    #超市
#     IF p_cmd = 'u' AND g_rec_b > 0 THEN
#        IF NOT cl_confirm("alm-980") THEN RETURN END IF
#     END IF
#  END IF
 
   INITIALIZE l_lqb.* TO NULL
   LET l_lqb.lqb01 = g_lqa.lqa01
   LET l_lqb.lqb08 = 0
   LET l_lqb.lqbplant = g_lqa.lqaplant
   LET l_lqb.lqblegal = g_lqa.lqalegal
 
   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()
 
#  IF g_aza.aza87 = 'Y' THEN    #超市
#     DELETE FROM lqb_file WHERE lqb01 = g_lqa.lqa01
#     IF SQLCA.sqlcode THEN
#        CALL s_errmsg('lqb01',g_lqa.lqa01,'delete lqb',SQLCA.sqlcode,1)
#        LET g_success = 'N'
#     END IF
#  END IF
 
   LET g_sql = " SELECT * FROM rxy_file"
#  IF g_aza.aza87 = 'Y' THEN    #超市
#     LET g_sql = g_sql CLIPPED," WHERE (rxy00 = '02' OR rxy00 = '01') " #銷售
#  ELSE
      LET g_sql = g_sql CLIPPED," WHERE rxy00 = '02'  " #銷售
#  END IF
   LET g_sql = g_sql CLIPPED,
               "    AND rxy21 = '",g_lqa.lqa04,"'",   #日期
               "    AND rxyplant = '",g_lqa.lqaplant,"'",  #
               "    AND (rxy14 IS NOT NULL ",
               "    OR  rxy15 IS NOT NULL) "
   PREPARE t675_rxy_p1 FROM g_sql
   DECLARE t675_rxy_c1 CURSOR FOR t675_rxy_p1
 
   FOREACH t675_rxy_c1 INTO l_rxy.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','foreach t675_rxy_c1',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      IF NOT cl_null(l_rxy.rxy14) AND cl_null(l_rxy.rxy15) THEN
         LET l_rxy.rxy15 = l_rxy.rxy14 
      END IF
      IF NOT cl_null(l_rxy.rxy15) AND cl_null(l_rxy.rxy14) THEN
         LET l_rxy.rxy14 = l_rxy.rxy15 
      END IF
      #CKP#1   起始券/終止券的長度要一致
      LET l_len1 = LENGTH(l_rxy.rxy14)
      LET l_len2 = LENGTH(l_rxy.rxy15)
      IF l_len1 <> l_len2 THEN
         #券起始編號的總長度和券終止編號的總長度不一致,導致無法中間編號的信息!
         LET g_showmsg = l_rxy.rxy00,'/',l_rxy.rxy01,'/',l_rxy.rxy02,'/',
                         l_rxy.rxyplant,'/',l_len1,'/',l_len2
         CALL s_errmsg('rxy00,rxy01,rxy02,rxyplant,lpx21,lpx21',g_showmsg,'length','alm-481',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      
      #CKP#2  起始券的固定編碼和終止券的固定編碼要一致
      LET l_str = l_rxy.rxy14
      FOR l_i = l_len1 TO 1 STEP -1
          IF l_str[l_i,l_i] MATCHES '[0-9]' THEN
             LET l_str[l_i,l_i] = ''
          ELSE
             EXIT FOR
          END IF
      END FOR
      LET l_str1 = l_str CLIPPED
      LET l_str = l_rxy.rxy15
      FOR l_i = l_len1 TO 1 STEP -1
          IF l_str[l_i,l_i] MATCHES '[0-9]' THEN
             LET l_str[l_i,l_i] = ''
          ELSE
             EXIT FOR
          END IF
      END FOR
      LET l_str2 = l_str CLIPPED
    
      IF l_str1 <> l_str2 THEN
         #券起始編號的固定編碼值和券終止編號的固定編碼值不一致,導致無法中間編號的信息!
         LET g_showmsg = l_rxy.rxy00,'/',l_rxy.rxy01,'/',l_rxy.rxy02,'/',
                         l_rxy.rxyplant,'/',l_str1,'/',l_str2
         CALL s_errmsg('rxy00,rxy01,rxy02,rxyplant,lpx23,lpx23',g_showmsg,'fix code','alm-482',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
 
      LET l_len1 = LENGTH(l_str1)   #固定編碼長度
      IF l_len1 + 1 <= l_len2 THEN
         LET l_begin_no = l_rxy.rxy14[l_len1+1,l_len2]  #取流水碼
         LET l_end_no   = l_rxy.rxy15[l_len1+1,l_len2]  #取流水碼
         LET l_lpx24 = l_len2 - l_len1
      ELSE
         LET l_begin_no = ''
         LET l_end_no   = ''
         LET l_lpx24 = 0
      END IF
      LET l_format = ''
      FOR l_i = 1 TO l_lpx24 - 1
          LET l_format = l_format CLIPPED,'&'
      END FOR
      IF l_lpx24 > 0 THEN
         LET l_format = l_format CLIPPED,"<"
      END IF
 
      LET l_j = l_begin_no
      WHILE TRUE
          LET l_lqb.lqb02 = l_str1 CLIPPED,l_j USING l_format    
          SELECT * INTO l_lqe.* FROM lqe_file WHERE lqe01 = l_lqb.lqb02
          IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN 
             LET g_success = 'N'
             CALL s_errmsg('lqe01',l_lqb.lqb02,'sel lqe',SQLCA.sqlcode,1)
          ELSE
             IF SQLCA.sqlcode = 100 THEN #未登記的券
                LET l_lqb.lqb03 = ''
                LET l_lqb.lqb04 = ''
                LET l_lqb.lqb05 = ''
                LET l_lqb.lqb06 = ''
                LET l_lqb.lqb07 = '2'
             ELSE
                LET l_lqb.lqb03 = l_lqe.lqe02
                LET l_lqb.lqb04 = l_lqe.lqe03
                LET l_lqb.lqb05 = l_lqe.lqe17
                CASE l_lqe.lqe17
                     WHEN '0' LET l_lqb.lqb06 = l_lqe.lqe05
                              LET l_lqb.lqb07 = '1'
                     WHEN '1' LET l_lqb.lqb06 = l_lqe.lqe07
                              #LET l_lqb.lqb07 = '0'        #FUN-CA0152 mark
                              LET l_lqb.lqb07 = '1'         #FUN-CA0152 add
                     WHEN '2' LET l_lqb.lqb06 = l_lqe.lqe10
                              LET l_lqb.lqb07 = '1'
                     WHEN '3' LET l_lqb.lqb06 = l_lqe.lqe12
                              LET l_lqb.lqb07 = '1'
                     #WHEN '4' LET l_lqb.lqb06 = l_lqe.lqe19#FUN-CA0152 mark
                     #         LET l_lqb.lqb07 = '1'        #FUN-CA0152 mark
                     #FUN-CA0152------add----str
                     WHEN '4' LET l_lqb.lqb07 = '0'
                              LET l_lqb.lqb06 = l_lqe.lqe25   #FUN-D10040
                     WHEN '5' LET l_lqb.lqb06 = l_lqe.lqe14
                              LET l_lqb.lqb07 = '0'
                     WHEN '6' LET l_lqb.lqb06 = l_lqe.lqe16
                              LET l_lqb.lqb07 = '0'
                     WHEN '7' LET l_lqb.lqb06 = l_lqe.lqe19
                              LET l_lqb.lqb07 = '0'
                     #FUN-CA0152------add----end
                END CASE
             END IF
             SELECT lqc06 INTO l_lqb.lqb08 FROM lqc_file
              WHERE lqc01 = l_lqb.lqb02
             IF cl_null(l_lqb.lqb08) THEN LET l_lqb.lqb08 = 0 END IF
          END IF
 
          IF g_success = 'Y' THEN
             INSERT INTO lqb_file VALUES(l_lqb.*)
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
#               IF SQLCA.sqlcode = -239 AND g_rec_b >0 THEN  #今天產生過資料了#CHI-C30115 mark
                IF cl_sql_dup_value(SQLCA.sqlcode) AND g_rec_b >0 THEN #CHI-C30115 add
                ELSE
                   LET g_success = 'N'
                   CALL s_errmsg('lqb02',l_lqb.lqb02,'insert lqb',SQLCA.sqlcode,1)
                END IF
             END IF
          END IF
          LET g_success = 'Y'    #Carrier 前面即使有部分資料出現錯誤，其他資料也要插入
 
          LET l_j = l_j + 1
          IF l_j > l_end_no THEN EXIT WHILE END IF
      END WHILE
      LET g_success = 'Y'    #Carrier 前面即使有部分資料出現錯誤，其他資料也要插入
   END FOREACH
   
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
      
   CALL t675_b_fill("1=1")
   CALL t675_bp_refresh()
 
END FUNCTION
 
FUNCTION t675_delete_body()
   
   IF g_lqa.lqa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lqa.* FROM lqa_file
    WHERE lqa01=g_lqa.lqa01
 
   IF g_lqa.lqaplant <> g_plant THEN
      CALL cl_err(g_lqa.lqaplant,'alm-399',0)
      RETURN
   END IF
   IF g_lqa.lqaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lqa.lqa01,'mfg1000',0)
      RETURN
   END IF
   IF g_lqa.lqa07 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lqa.lqa07 = 'Y' THEN
      CALL cl_err(g_lqa.lqa01,'mfg1005',0)
      RETURN
   END IF
   IF l_ac <= 0 THEN
      RETURN
   END IF
 
   LET g_success = 'Y'
   BEGIN WORK
   IF NOT cl_null(g_lqb[l_ac].lqb02) THEN
      DELETE FROM lqb_file WHERE lqb01 = g_lqa.lqa01 
                             AND lqb02 = g_lqb[l_ac].lqb02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3('del','lqb_file',g_lqa.lqa01,g_lqb[l_ac].lqb02,SQLCA.sqlcode,'','',1)
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   CALL t675_b_fill("1=1")
   CALL t675_bp_refresh()
END FUNCTION
 
FUNCTION t675_y()
   DEFINE l_lqb    RECORD LIKE lqb_file.*
   DEFINE l_lqe    RECORD LIKE lqe_file.*
   DEFINE l_lqc    RECORD LIKE lqc_file.*
 
   IF g_lqa.lqa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
#CHI-C30107 --------------- add --------------- begin
   IF g_lqa.lqaplant <> g_plant THEN
      CALL cl_err(g_lqa.lqaplant,'alm-399',0)
      RETURN
   END IF
   IF g_lqa.lqaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lqa.lqa01,'mfg1000',0)
      RETURN
   END IF
   IF g_lqa.lqa07 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lqa.lqa07 = 'Y' THEN
      CALL cl_err(g_lqa.lqa01,'mfg1005',0)
      RETURN
   END IF
   IF NOT cl_confirm('aap-017') THEN RETURN END IF
#CHI-C30107 --------------- add --------------- end 
   SELECT * INTO g_lqa.* FROM lqa_file
    WHERE lqa01=g_lqa.lqa01
 
   IF g_lqa.lqaplant <> g_plant THEN
      CALL cl_err(g_lqa.lqaplant,'alm-399',0)
      RETURN
   END IF
   IF g_lqa.lqaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lqa.lqa01,'mfg1000',0)
      RETURN
   END IF
   IF g_lqa.lqa07 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lqa.lqa07 = 'Y' THEN
      CALL cl_err(g_lqa.lqa01,'mfg1005',0)
      RETURN
   END IF
   IF g_rec_b <= 0 THEN
      CALL cl_err(g_lqa.lqa01,'atm-228',0)
      RETURN
   END IF
 
#  IF NOT cl_confirm('aap-017') THEN RETURN END IF #CHI-C30107 mark
 
   BEGIN WORK
   OPEN t675_cl USING g_lqa.lqa01
   IF STATUS THEN
      CALL cl_err("OPEN t675_cl:", STATUS, 1)
      CLOSE t675_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t675_cl INTO g_lqa.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqa.lqa01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   DECLARE t675_y_cs CURSOR FOR
    SELECT * FROM lqb_file
     WHERE lqb01 = g_lqa.lqa01
 
   LET g_success = 'Y'
   CALL s_showmsg_init()
 
   INITIALIZE l_lqe.* TO NULL
   FOREACH t675_y_cs INTO l_lqb.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','foreach t675_y_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      INITIALIZE l_lqc.* TO NULL
 
      CASE l_lqb.lqb07   #核銷狀態
           WHEN '0'
                #UPDATE lqe_file SET lqe17 = '4',   #FUN-D10040 mark
                UPDATE lqe_file SET lqe17 = '7',    #FUN-D10040 add
                                    lqe18 = g_lqa.lqaplant,
                                    lqe19 = g_lqa.lqa04
                 WHERE lqe01 = l_lqb.lqb02
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('lqe01',l_lqb.lqb02,'upd lqe',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
 
           WHEN '1'
           #TQC-C20533 add sta---
                #UPDATE lqe_file SET lqe17 = '4',   #FUN-D10040 mark
                UPDATE lqe_file SET lqe17 = '7',    #FUN-D10040 add
                                    lqe18 = g_lqa.lqaplant,
                                    lqe19 = g_lqa.lqa04
                 WHERE lqe01 = l_lqb.lqb02
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('lqe01',l_lqb.lqb02,'upd lqe',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
          #TQC-C20533 add end---       
                CALL t675_ins_upd_lqc(l_lqb.*)
                
           WHEN '2'
                CALL t675_ins_upd_lqc(l_lqb.*)
      END CASE
      SELECT lqc06 INTO l_lqb.lqb08 FROM lqc_file
       WHERE lqc01 = l_lqb.lqb02
      IF cl_null(l_lqb.lqb08) THEN LET l_lqb.lqb08 = 0 END IF
      UPDATE lqb_file SET lqb08 = l_lqb.lqb08
      WHERE lqb01 = g_lqa.lqa01
        AND lqb02 = l_lqb.lqb02  #TQC-C20533
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lqb01',g_lqa.lqa01,'update lqb08',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
 
   END FOREACH
   
   UPDATE lqa_file SET lqa07 = 'Y',lqa08 = g_user,lqa09 = g_today
    WHERE lqa01=g_lqa.lqa01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('lqa01',g_lqa.lqa01,'update lqy',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
 
   CALL s_showmsg()
      
   CLOSE t675_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT lqa07,lqa08,lqa09 INTO g_lqa.lqa07,g_lqa.lqa08,g_lqa.lqa09
        FROM lqa_file
       WHERE lqa01=g_lqa.lqa01
      DISPLAY BY NAME g_lqa.lqa07,g_lqa.lqa08,g_lqa.lqa09
      CALL t675_show()
   ELSE
      ROLLBACK WORK
   END IF
   CALL cl_set_field_pic(g_lqa.lqa07,g_lqa.lqa06,'','','',g_lqa.lqaacti)
 
END FUNCTION
 
#FUNCTION t675_z()
#   DEFINE l_lqb         RECORD LIKE lqb_file.*
#   DEFINE l_lqe17       LIKE lqe_file.lqe17
#
#   IF g_lqa.lqa01 IS NULL THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#
#   SELECT * INTO g_lqa.* FROM lqa_file
#    WHERE lqa01=g_lqa.lqa01
#
#   IF g_lqa.lqa07 = 'N' THEN  #未審核
#      CALL cl_err(g_lqa.lqa01,'9025',0)
#      RETURN
#   END IF
#
#   #已發售/退回/作廢單據 不可取消審核!
#   IF g_lqa.lqa02 <> '0' THEN
#      CALL cl_err(g_lqa.lqa01,'alm-478',0)
#      RETURN
#   END IF
#
#   IF NOT cl_confirm('aim-302') THEN RETURN END IF
#
#   BEGIN WORK
#   OPEN t675_cl USING g_lqa.lqa01
#   IF STATUS THEN
#      CALL cl_err("OPEN t675_cl:", STATUS, 1)
#      CLOSE t675_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#   FETCH t675_cl INTO g_lqa.*               # 鎖住將被更改或取消的資料
#   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_lqa.lqa01,SQLCA.sqlcode,0)          #資料被他人LOCK
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#   LET g_success = 'Y'
#   DECLARE t675_z_cs CURSOR FOR
#    SELECT * FROM lqb_file
#     WHERE lqb01 = g_lqa.lqa01
#
#   CALL s_showmsg_init()
#
#   FOREACH t675_z_cs INTO l_lqb.*
#      IF SQLCA.sqlcode THEN
#         CALL s_errmsg('','','foreach t675_z_cs',SQLCA.sqlcode,1)
#         LET g_success = 'N'
#         EXIT FOREACH
#      END IF
#      SELECT lqe17 INTO l_lqe17 FROM lqe_file
#       WHERE lqe01 = l_lqb.lqb02
#      IF cl_null(l_lqe17) OR l_lqe17 <> '0' THEN
#         LET g_success = 'N'
#         LET g_showmsg = l_lqb.lqb02,'/',l_lqe17
#         #此券已經有使用資料,不得做取消登記
#         CALL s_errmsg('lqb02,lqe17',g_showmsg,'sel lqe17','alm-479',1)
#      END IF
#   END FOREACH
#
#   IF g_success = 'Y' THEN   
#      #1.刪除lqe_file的登記信息
#      DELETE FROM lqe_file WHERE lqe01 IN (SELECT lqb02 FROM lqb_file
#                                            WHERE lqb01 = g_lqa.lqa01)
#      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL s_errmsg('lqa01',g_lqa.lqa01,'delete lqe',SQLCA.sqlcode,1)
#         LET g_success = 'N'
#      END IF
#  
#      UPDATE lqa_file SET lqa07 = 'N',lqa08 = '',lqa09 = ''
#       WHERE lqa01=g_lqa.lqa01
#      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL s_errmsg('lqa01',g_lqa.lqa01,'update lqy',SQLCA.sqlcode,1)
#         LET g_success = 'N'
#      END IF
#   END IF
#   CALL s_showmsg()
#      
#   CLOSE t675_cl
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#      SELECT lqa07,lqa08,lqa09 INTO g_lqa.lqa07,g_lqa.lqa08,g_lqa.lqa09
#        FROM lqa_file
#       WHERE lqa01=g_lqa.lqa01
#      DISPLAY BY NAME g_lqa.lqa07,g_lqa.lqa08,g_lqa.lqa09
#   ELSE
#      ROLLBACK WORK
#   END IF
#   CALL cl_set_field_pic(g_lqa.lqa07,g_lqa.lqa06,'','','',g_lqa.lqaacti)
#
#END FUNCTION
 
FUNCTION t675_lpx01(p_lpx01)  #券類型編號
   DEFINE p_lpx01      LIKE lpx_file.lpx01
   DEFINE l_lpx15      LIKE lpx_file.lpx15
   DEFINE l_lpxacti    LIKE lpx_file.lpxacti
   DEFINE l_lpx21      LIKE lpx_file.lpx21 
   DEFINE l_lpx22      LIKE lpx_file.lpx22 
   DEFINE l_lpx23      LIKE lpx_file.lpx23 
   DEFINE l_lpx24      LIKE lpx_file.lpx24 
   DEFINE l_i          LIKE type_file.num5 
   DEFINE l_format     LIKE type_file.chr20
 
   LET g_errno = " "
 
   SELECT lpx21,lpx22,lpx23,lpx24,lpx15,lpxacti
     INTO l_lpx21,l_lpx22,l_lpx23,l_lpx24,l_lpx15,l_lpxacti
     FROM lpx_file WHERE lpx01 = p_lpx01
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-960'  #無此券類型編號
                                  LET l_lpx21 = NULL
                                  LET l_lpx22 = NULL
                                  LET l_lpx23 = NULL
                                  LET l_lpx24 = NULL
        WHEN l_lpx15 = 'N'        LET g_errno = '9029'     #此筆資料尚未審核, 不可使用
        WHEN l_lpxacti = 'N'      LET g_errno = 'mfg0301'  #本筆資料無效
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   LET l_format = ''
   FOR l_i = 1 TO l_lpx24 - 1
       LET l_format = l_format CLIPPED,'&'
   END FOR
   IF l_lpx24 > 0 THEN
      LET l_format = l_format CLIPPED,"<"
   END IF
   
   DISPLAY l_lpx21 TO FORMONLY.lpx21
   DISPLAY l_lpx22 TO FORMONLY.lpx22
   DISPLAY l_lpx23 TO FORMONLY.lpx23
   DISPLAY l_lpx24 TO FORMONLY.lpx24
 
   RETURN l_format,l_lpx23,l_lpx24
 
END FUNCTION
 
FUNCTION t675_b()
   DEFINE l_ac_t             LIKE type_file.num5
   DEFINE l_n                LIKE type_file.num5
   DEFINE l_cnt              LIKE type_file.num5
   DEFINE l_lock_sw          LIKE type_file.chr1
   DEFINE p_cmd              LIKE type_file.chr1
   DEFINE l_allow_insert     LIKE type_file.num5
   DEFINE l_allow_delete     LIKE type_file.num5
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lqa.lqa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lqa.* FROM lqa_file
    WHERE lqa01=g_lqa.lqa01
 
   IF g_lqa.lqaplant <> g_plant THEN
      CALL cl_err(g_lqa.lqaplant,'alm-399',0)
      RETURN
   END IF
   IF g_lqa.lqaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_lqa.lqa01,'mfg1000',0)
      RETURN
   END IF
   IF g_lqa.lqa07 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lqa.lqa07 = 'Y' THEN
      CALL cl_err(g_lqa.lqa01,'mfg1005',0)
      RETURN
   END IF
#  IF g_aza.aza87 = 'Y' THEN
#     IF g_lqa.lqa02 = '0' THEN
#        CALL cl_err(g_lqa.lqa02,'alm-979',0)
#        RETURN
#     END IF
#  END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT lqb02,lqb03,'',lqb04,'',lqb05,lqb06,lqb07,lqb08",
                      "  FROM lqb_file",
                      " WHERE lqb01=? AND lqb02=? ",
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t675_bcl CURSOR FROM g_forupd_sql      
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_lqb WITHOUT DEFAULTS FROM s_lqb.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          DISPLAY "BEFORE INPUT!"
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          DISPLAY "BEFORE ROW!"
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            
          LET l_n  = ARR_COUNT()
 
          BEGIN WORK
          OPEN t675_cl USING g_lqa.lqa01
          IF STATUS THEN
             CALL cl_err("OPEN t675_cl:", STATUS, 1)
             CLOSE t675_cl
             ROLLBACK WORK
             RETURN
          END IF
 
          FETCH t675_cl INTO g_lqa.*            
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_lqa.lqa01,SQLCA.sqlcode,0)      
             CLOSE t675_cl
             ROLLBACK WORK
             RETURN
          END IF
 
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_lqb_t.* = g_lqb[l_ac].*  
             LET g_lqb_o.* = g_lqb[l_ac].*  
             OPEN t675_bcl USING g_lqa.lqa01,g_lqb_t.lqb02
             IF STATUS THEN
                CALL cl_err("OPEN t675_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t675_bcl INTO g_lqb[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lqb_t.lqb02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                SELECT lpx02 INTO g_lqb[l_ac].lpx02 FROM lpx_file
                 WHERE lpx01 = g_lqb[l_ac].lqb03
                SELECT lrz02 INTO g_lqb[l_ac].lrz02 FROM lrz_file
                 WHERE lrz01 = g_lqb[l_ac].lqb04
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          DISPLAY "BEFORE INSERT!"
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_lqb[l_ac].* TO NULL      
          LET g_lqb[l_ac].lqb08 =  0            
          LET g_lqb_t.* = g_lqb[l_ac].*         
          LET g_lqb_o.* = g_lqb[l_ac].*         
          CALL cl_show_fld_cont()         
          NEXT FIELD lqb02
 
       AFTER INSERT
          DISPLAY "AFTER INSERT!"
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          
          INSERT INTO lqb_file(lqb01,lqb02,lqb03,lqb04,lqb05,lqb06,lqb07,lqb08,
                               lqbplant,lqblegal)
          VALUES(g_lqa.lqa01,g_lqb[l_ac].lqb02,
                 g_lqb[l_ac].lqb03,g_lqb[l_ac].lqb04,
                 g_lqb[l_ac].lqb05,g_lqb[l_ac].lqb06,
                 g_lqb[l_ac].lqb07,g_lqb[l_ac].lqb08,
                 g_lqa.lqaplant,g_lqa.lqalegal)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lqb_file",g_lqa.lqa01,g_lqb[l_ac].lqb02,SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
       AFTER FIELD lqb02                        
          IF NOT cl_null(g_lqb[l_ac].lqb02) THEN
             IF g_lqb[l_ac].lqb02 != g_lqb_o.lqb02 OR g_lqb_o.lqb02 IS NULL THEN
                SELECT COUNT(*) INTO l_n FROM lqb_file
                 WHERE lqb01 = g_lqa.lqa01
                   AND lqb02 = g_lqb[l_ac].lqb02
                IF l_n > 0 THEN
                   CALL cl_err(g_lqb[l_ac].lqb02,-239,0)
                   LET g_lqb[l_ac].lqb02 = g_lqb_t.lqb02
                   NEXT FIELD lqb02
                END IF
                CALL t675_lqb02(p_cmd)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_lqb[l_ac].lqb02,g_errno,0)
                   LET g_lqb[l_ac].lqb02 = g_lqb_t.lqb02
                   NEXT FIELD lqb02
                END IF
             END IF
          END IF
          LET g_lqb_o.lqb02 = g_lqb[l_ac].lqb02
   
      #AFTER FIELD lqb03                       
      #   IF NOT cl_null(g_lqb[l_ac].lqb03) THEN
      #      IF g_lqb_o.lqb03 IS NULL OR g_lqb[l_ac].lqb03 != g_lqb_o.lqb03 THEN
      #         CALL t675_lqb03(p_cmd)
      #         IF NOT cl_null(g_errno) THEN
      #            CALL cl_err(g_lqb[l_ac].lqb03,g_errno,0)
      #            LET g_lqb[l_ac].lqb03 = g_lqb_o.lqb03
      #            NEXT FIELD lqb03
      #         END IF
      #      END IF
      #      LET g_lqb_o.lqb03 = g_lqb[l_ac].lqb03
      #   END IF
   
       BEFORE DELETE                      
          DISPLAY "BEFORE DELETE"
          IF g_lqb_t.lqb02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM lqb_file
              WHERE lqb01 = g_lqa.lqa01
                AND lqb02 = g_lqb_t.lqb02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lqb_file",g_lqa.lqa01,g_lqb_t.lqb02,SQLCA.sqlcode,"","",1)  
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
          COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lqb[l_ac].* = g_lqb_t.*
             CLOSE t675_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_lqb[l_ac].lqb02,-263,1)
             LET g_lqb[l_ac].* = g_lqb_t.*
          ELSE
             UPDATE lqb_file SET lqb02=g_lqb[l_ac].lqb02,
                                 lqb03=g_lqb[l_ac].lqb03,
                                 lqb04=g_lqb[l_ac].lqb04,
                                 lqb05=g_lqb[l_ac].lqb05,
                                 lqb06=g_lqb[l_ac].lqb06,
                                 lqb07=g_lqb[l_ac].lqb07,
                                 lqb08=g_lqb[l_ac].lqb08
              WHERE lqb01=g_lqa.lqa01
                AND lqb02=g_lqb_t.lqb02
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","lqb_file",g_lqa.lqa01,g_lqb_t.lqb02,SQLCA.sqlcode,"","",1)  
                LET g_lqb[l_ac].* = g_lqb_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          DISPLAY  "AFTER ROW!!"
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac      #FUN-D30033 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_lqb[l_ac].* = g_lqb_t.*
             #FUN-D30033--add--str--
             ELSE
                CALL g_lqb.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033--add--end--
             END IF
             CLOSE t675_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac      #FUN-D30033 Add
          CLOSE t675_bcl
          COMMIT WORK
 
       ON ACTION CONTROLO                        
          IF INFIELD(lqb02) AND l_ac > 1 THEN
             LET g_lqb[l_ac].* = g_lqb[l_ac-1].*
             LET g_lqb[l_ac].lqb02 = g_rec_b + 1
             NEXT FIELD lqb02
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(lqb02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lqe01" 
               LET g_qryparam.default1 = g_lqb[l_ac].lqb02
               LET g_qryparam.arg1 = g_lqa.lqaplant
               CALL cl_create_qry() RETURNING g_lqb[l_ac].lqb02
               DISPLAY BY NAME g_lqb[l_ac].lqb02
               CALL t675_lqb02('d')
               NEXT FIELD lqb02
           END CASE
 
       ON ACTION CONTROLF
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
 
       ON ACTION controls                           
          CALL cl_set_head_visible("","AUTO")       
   END INPUT
   
   LET g_lqa.lqamodu = g_user
   LET g_lqa.lqadate = g_today
   UPDATE lqa_file SET lqamodu = g_lqa.lqamodu,lqadate = g_lqa.lqadate
    WHERE lqa01 = g_lqa.lqa01
   DISPLAY BY NAME g_lqa.lqamodu,g_lqa.lqadate
   
   CLOSE t675_bcl
   COMMIT WORK
   CALL t675_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t675_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lqa.lqa01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lqa_file ",
                  "  WHERE lqa01 LIKE '",l_slip,"%' ",
                  "    AND lqa01 > '",g_lqa.lqa01,"'"
      PREPARE t675_pb1 FROM l_sql 
      EXECUTE t675_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t675_v()
         IF g_lqa.lqa07='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_lqa.lqa07,g_lqa.lqa06,'','',g_void,g_lqa.lqaacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lqa_file WHERE lqa01 = g_lqa.lqa01
         INITIALIZE g_lqa.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t675_lqb02(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1
   DEFINE l_lqe        RECORD LIKE lqe_file.*
 
   LET g_errno = " "
 
   SELECT * INTO l_lqe.* FROM lqe_file WHERE lqe01 = g_lqb[l_ac].lqb02
   IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN
      LET g_errno = SQLCA.SQLCODE USING '-------'
      RETURN
   ELSE
      IF SQLCA.sqlcode = 100 THEN   #無此券信息
         LET g_lqb[l_ac].lqb03 =''
         LET g_lqb[l_ac].lpx02 =''
         LET g_lqb[l_ac].lqb04 =''
         LET g_lqb[l_ac].lrz02 =''
         LET g_lqb[l_ac].lqb05 =''
         LET g_lqb[l_ac].lqb06 =''
         LET g_lqb[l_ac].lqb07 ='2'
      ELSE
         LET g_lqb[l_ac].lqb03 =l_lqe.lqe02
         SELECT lpx02 INTO g_lqb[l_ac].lpx02 FROM lpx_file
          WHERE lpx01 = g_lqb[l_ac].lqb03
         LET g_lqb[l_ac].lqb04 =l_lqe.lqe03
         SELECT lrz02 INTO g_lqb[l_ac].lrz02 FROM lrz_file
          WHERE lrz01 = g_lqb[l_ac].lqb04
         LET g_lqb[l_ac].lqb05 =l_lqe.lqe17
         CASE l_lqe.lqe17
              WHEN '0' LET g_lqb[l_ac].lqb06 = l_lqe.lqe05
                       LET g_lqb[l_ac].lqb07 = '1'
              WHEN '1' LET g_lqb[l_ac].lqb06 = l_lqe.lqe07
                       #LET g_lqb[l_ac].lqb07 = '0'         #FUN-CA0152 mark
                       LET g_lqb[l_ac].lqb07 = '1'          #FUN-CA0152 add
              WHEN '2' LET g_lqb[l_ac].lqb06 = l_lqe.lqe10
                       LET g_lqb[l_ac].lqb07 = '1'
              WHEN '3' LET g_lqb[l_ac].lqb06 = l_lqe.lqe12
                       LET g_lqb[l_ac].lqb07 = '1'
              #WHEN '4' LET g_lqb[l_ac].lqb06 = l_lqe.lqe19 #FUN-CA0152 mark
              #         LET g_lqb[l_ac].lqb07 = '1'         #FUN-CA0152 mark
              #FUN-CA0152-------add-----str
              WHEN '4' LET g_lqb[l_ac].lqb07 = '0' 
                       LET g_lqb[l_ac].lqb06 = l_lqe.lqe25  #FUN-D10040 add
              WHEN '5' LET g_lqb[l_ac].lqb06 = l_lqe.lqe14
                       LET g_lqb[l_ac].lqb07 = '0' 
              WHEN '6' LET g_lqb[l_ac].lqb06 = l_lqe.lqe16
                       LET g_lqb[l_ac].lqb07 = '0'
              WHEN '7' LET g_lqb[l_ac].lqb06 = l_lqe.lqe19
                       LET g_lqb[l_ac].lqb07 = '0'
              #FUN-CA0152-------add-----end
         END CASE
      END IF
      SELECT lqc06 INTO g_lqb[l_ac].lqb08 FROM lqc_file
       WHERE lqc01 = g_lqb[l_ac].lqb02
      IF cl_null(g_lqb[l_ac].lqb08) THEN LET g_lqb[l_ac].lqb08 = 0 END IF
   END IF
   DISPLAY BY NAME g_lqb[l_ac].lqb03
   DISPLAY BY NAME g_lqb[l_ac].lpx02
   DISPLAY BY NAME g_lqb[l_ac].lqb04
   DISPLAY BY NAME g_lqb[l_ac].lrz02
   DISPLAY BY NAME g_lqb[l_ac].lqb05
   DISPLAY BY NAME g_lqb[l_ac].lqb06
   DISPLAY BY NAME g_lqb[l_ac].lqb07
   DISPLAY BY NAME g_lqb[l_ac].lqb08
 
END FUNCTION
 
FUNCTION t675_ins_upd_lqc(p_lqb)
   DEFINE p_lqb           RECORD LIKE lqb_file.*
   DEFINE l_lqc           RECORD LIKE lqc_file.*
 
   LET l_lqc.lqc01 = p_lqb.lqb02
   LET l_lqc.lqc02 = p_lqb.lqb05
   LET l_lqc.lqc03 = p_lqb.lqb06
   LET l_lqc.lqc04 = g_lqa.lqa04
   LET l_lqc.lqc05 = p_lqb.lqb07
   LET l_lqc.lqc06 = 1
   LET l_lqc.lqcplant = p_lqb.lqbplant
   LET l_lqc.lqclegal = p_lqb.lqblegal
   INSERT INTO lqc_file VALUES(l_lqc.*)
#  IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 AND SQLCA.sqlcode <> -268 THEN #TQC-C20533 add SQLCA.sqlcode <> -268 #CHI-C30115 mark
   IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
      CALL s_errmsg('lqc01',p_lqb.lqb02,'ins lqc',SQLCA.sqlcode,1)
      LET g_success = 'N'
   ELSE
#     IF SQLCA.sqlcode = -239 OR SQLCA.sqlcode = -268 THEN  #TQC-C20533 add SQLCA.sqlcode <> -268 #CHI-C30115 mark
      IF cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
         UPDATE lqc_file SET lqc06 = lqc06 + 1
          WHERE lqc01 = p_lqb.lqb02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('lqc01',p_lqb.lqb02,'upd lqc06',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
      END IF
   END IF
END FUNCTION
#No.FUN-960134                
#FUN-C90070-------add------str
FUNCTION t675_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_lpx02   LIKE lpx_file.lpx02,
       l_lrz02   LIKE lrz_file.lrz02,
       sr        RECORD
                 lqa01     LIKE lqa_file.lqa01, 
                 lqa02     LIKE lqa_file.lqa02,
                 lqaplant  LIKE lqa_file.lqaplant,
                 lqa04     LIKE lqa_file.lqa04,
                 lqa07     LIKE lqa_file.lqa07,
                 lqa08     LIKE lqa_file.lqa08,
                 lqa09     LIKE lqa_file.lqa09,
                 lqb02     LIKE lqb_file.lqb02,
                 lqb03     LIKE lqb_file.lqb03,
                 lqb04     LIKE lqb_file.lqb04,
                 lqb05     LIKE lqb_file.lqb05,
                 lqb06     LIKE lqb_file.lqb06,
                 lqb07     LIKE lqb_file.lqb07,
                 lqb08     LIKE lqb_file.lqb08
                 END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lqauser', 'lqagrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lqa01 = '",g_lqa.lqa01,"'" END IF
     IF cl_null(g_wc2) THEN LET g_wc2 = " lqb01 = '",g_lqa.lqa01,"'" END IF
     LET l_sql = "SELECT lqa01,lqa02,lqaplant,lqa04,lqa07,lqa08,lqa09,",
                 "       lqb02,lqb03,lqb04,lqb05,lqb06,lqb07,lqb08",
                 "  FROM lqa_file,lqb_file",
                 " WHERE lqa01 = lqb01",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
     PREPARE t675_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t675_cs1 CURSOR FOR t675_prepare1

     DISPLAY l_table
     FOREACH t675_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=sr.lqaplant
       LET l_lpx02 = ' '
       SELECT lpx02 INTO l_lpx02 FROM lpx_file WHERE lpx01=sr.lqb03
       LET l_lrz02 = ' '
       SELECT lrz02 INTO l_lrz02 FROM lrz_file WHERE lrz01=sr.lqb04
       EXECUTE insert_prep USING sr.*,l_rtz13,l_lpx02,l_lrz02
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lqa01,lqa02,lqaplant,lqa04,lqa07,lqa08,lqa09')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lqb01,lqb02,lqb03,lqb04,lqb05,lqb06,lqb07,lqb08')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1='' 
     END IF
     IF g_wc2 = " 1=1" THEN
        LET g_wc3='' 
     END IF            
     IF g_wc <> " 1=1" AND g_wc2 <> " 1=1" THEN 
        LET g_wc4 = g_wc1," AND ",g_wc3
     ELSE              
        IF g_wc = " 1=1" AND g_wc2 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE   
           LET g_wc4 = g_wc1,g_wc3
        END IF 
     END IF
     CALL t675_grdata()
END FUNCTION

FUNCTION t675_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF

   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt675")
       IF handler IS NOT NULL THEN
           START REPORT t675_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lqa01,lqb02"
           DECLARE t675_datacur1 CURSOR FROM l_sql
           FOREACH t675_datacur1 INTO sr1.*
               OUTPUT TO REPORT t675_rep(sr1.*)
           END FOREACH
           FINISH REPORT t675_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t675_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lqa02  STRING
    DEFINE l_lqb05  STRING
    DEFINE l_lqb07  STRING
    DEFINE l_lqa07  STRING
    
    ORDER EXTERNAL BY sr1.lqa01,sr1.lqb02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1,g_wc3,g_wc4
              
        BEFORE GROUP OF sr1.lqa01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.lqb02
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lqa02 = cl_gr_getmsg("gre-299",g_lang,sr1.lqa02)
            LET l_lqb05 = cl_gr_getmsg("gre-300",g_lang,sr1.lqb05)
            LET l_lqb07 = cl_gr_getmsg("gre-301",g_lang,sr1.lqb07)
            LET l_lqa07 = cl_gr_getmsg("gre-302",g_lang,sr1.lqa07)
            PRINTX sr1.*
            PRINTX l_lqa02
            PRINTX l_lqb05
            PRINTX l_lqb07
            PRINTX l_lqa07

        AFTER GROUP OF sr1.lqa01
        AFTER GROUP OF sr1.lqb02

        
        ON LAST ROW

END REPORT
#FUN-C90070-------add------end
#CHI-C80041---begin
FUNCTION t675_v()
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lqa.lqa01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t675_cl USING g_lqa.lqa01
   IF STATUS THEN
      CALL cl_err("OPEN t675_cl:", STATUS, 1)
      CLOSE t675_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t675_cl INTO g_lqa.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lqa.lqa01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t675_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_lqa.lqa07 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_lqa.lqa07)   THEN 
        LET g_chr=g_lqa.lqa07
        IF g_lqa.lqa07='N' THEN 
            LET g_lqa.lqa07='X' 
        ELSE
            LET g_lqa.lqa07='N'
        END IF
        UPDATE lqa_file
            SET lqa07=g_lqa.lqa07,  
                lqamodu=g_user,
                lqadate=g_today
            WHERE lqa01=g_lqa.lqa01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lqa_file",g_lqa.lqa01,"",SQLCA.sqlcode,"","",1)  
            LET g_lqa.lqa07=g_chr 
        END IF
        DISPLAY BY NAME g_lqa.lqa07 
   END IF
 
   CLOSE t675_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lqa.lqa01,'V')
 
END FUNCTION
#CHI-C80041---end
