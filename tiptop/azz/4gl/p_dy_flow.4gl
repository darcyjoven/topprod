# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_dynamic_flow.4gl
# Descriptions...: 動態流程圖維護作業 Maintain gbk_file
# Date & Author..: 04/05/07 saki  
# Descriptions...: 限制：btn數小於總數60, 目錄名稱不可重複
#                  btn算法：第一層最大10組, 第二層最大20組, 第三層最大20組
# Modify.........: No.MOD-540120 05/04/20 By alex 修改 controlf 寫法
# Modify.........: No.MOD-540163 05/04/29 By alex 修改 order by 錯誤
# Modify.........: No.MOD-560220 05/06/28 By Carol 右上角的X功能無效
# Modify.........: No.MOD-560232 05/06/29 By saki  檢查第三層流程點是否存在p_zz或為dummy開頭
# Modify.........: No.MOD-580040 05/08/03 By saki 第一層目錄不可直接跳入第三層
# Modify.........: NO.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: NO.MOD-590329 05/10/03 By yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.FUN-610052 06/01/09 By saki 增加系統流程第一分類的按鍵數到20個
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-6B0081 07/04/09 By pengu 隱藏"更改"action按鈕
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"
# Modify.........: No.MOD-790012 07/09/10 By Smapmin 無法查詢
# Modify.........: No.TQC-860017 08/06/06 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-AA0127 10/10/21 By sabrina 進單身時單身資料會不見
# Modify.........: No:MOD-AB0214 10/11/23 By lilingyu 重新過賬
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gbk01               LIKE gbk_file.gbk01,   # 分類名稱  #MOD-AB0214
         g_gbk01_t             LIKE gbk_file.gbk01,   # 分類名稱
         g_gbk1                DYNAMIC ARRAY of RECORD  # 第一層
            gbk02_1            LIKE gbk_file.gbk02,
            gbk04_1            LIKE gbk_file.gbk04,
            gbk03_1            LIKE gbk_file.gbk03,
            gbk05_1            LIKE gbk_file.gbk05,
            gbk06_1            LIKE gbk_file.gbk06
                               END RECORD,
         g_gbk_t1              RECORD                 # 變數舊值
            gbk02_1            LIKE gbk_file.gbk02,
            gbk04_1            LIKE gbk_file.gbk04,
            gbk03_1            LIKE gbk_file.gbk03,
            gbk05_1            LIKE gbk_file.gbk05,
            gbk06_1            LIKE gbk_file.gbk06
                               END RECORD,
         g_gbk2                DYNAMIC ARRAY of RECORD  # 第一層
            gbk02_2            LIKE gbk_file.gbk02,
            gbk04_2            LIKE gbk_file.gbk04,
            gbk03_2            LIKE gbk_file.gbk03,
            gbk05_2            LIKE gbk_file.gbk05,
            gbk06_2            LIKE gbk_file.gbk06
                               END RECORD,
         g_gbk_t2              RECORD                 # 變數舊值
            gbk02_2            LIKE gbk_file.gbk02,
            gbk04_2            LIKE gbk_file.gbk04,
            gbk03_2            LIKE gbk_file.gbk03,
            gbk05_2            LIKE gbk_file.gbk05,
            gbk06_2            LIKE gbk_file.gbk06
                               END RECORD,
         g_gbk3                DYNAMIC ARRAY of RECORD  # 第一層
            gbk02_3            LIKE gbk_file.gbk02,
            gbk04_3            LIKE gbk_file.gbk04,
            gbk03_3            LIKE gbk_file.gbk03,
            gbk05_3            LIKE gbk_file.gbk05,
            gbk06_3            LIKE gbk_file.gbk06
                               END RECORD,
         g_gbk_t3              RECORD                 # 變數舊值
            gbk02_3            LIKE gbk_file.gbk02,
            gbk04_3            LIKE gbk_file.gbk04,
            gbk03_3            LIKE gbk_file.gbk03,
            gbk05_3            LIKE gbk_file.gbk05,
            gbk06_3            LIKE gbk_file.gbk06
                               END RECORD
DEFINE   g_cnt                 LIKE type_file.num10,          #No.FUN-680135 INTEGER
         g_wc                  string,  #No.FUN-580092 HCN
         g_sql                 string,  #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,           #FUN-680135       VARCHAR(1) # 決定後續步驟 
         g_rec_b1              LIKE type_file.num5,           # 單身筆數        #No.FUN-680135 SMALLINT
         g_rec_b2              LIKE type_file.num5,           # 單身筆數        #No.FUN-680135 SMALLINT
         g_rec_b3              LIKE type_file.num5,           # 單身筆數        #No.FUN-680135 SMALLINT
         l_ac1                 LIKE type_file.num5,           # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
         l_ac2                 LIKE type_file.num5,           # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
         l_ac3                 LIKE type_file.num5            # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
DEFINE   g_msg                 LIKE type_file.chr1000         #No.FUN-680135    VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5    #No.FUN-680135 SMALLINT
 DEFINE  g_row_count           LIKE type_file.num10,  #No.FUN-580092 HCN        #No.FUN-680135 INTEGER
         mi_curs_index         LIKE type_file.num10   #FUN-680135 INTEGER
DEFINE   mi_jump               LIKE type_file.num10,  #FUN-680135 INTEGER
         mi_no_ask             LIKE type_file.num5    #No.FUN-680135 SMALLINT
DEFINE   g_result              LIKE type_file.num5    #FUN-680135 SMALLINT
DEFINE   ms_layer0             LIKE gbk_file.gbk01
DEFINE   ms_layer1             LIKE gbk_file.gbk03
DEFINE   ms_layer2             LIKE gbk_file.gbk03
DEFINE   g_b_flag              LIKE type_file.num5    #FUN-680135 SMALLINT
# 2004/06/25 by saki : 預覽流程圖
DEFINE   mr_btn                DYNAMIC ARRAY OF RECORD
            btn_name           STRING,                 # btn原名, ex. btn1,btn2...
            chg_name           STRING                  # btn更換名, ex. axm,axm01...
                               END RECORD
DEFINE   ms_pic_url            STRING
 
 
MAIN
   DEFINE   p_row,p_col    LIKE type_file.num5          #No.FUN-680135 SMALLINT 
#     DEFINE   l_time   LIKE type_file.chr8             #No.FUN-6A0096
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET g_gbk01_t = NULL
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW p_dynamic_flow_w AT p_row,p_col WITH FORM "azz/42f/p_dy_flow"
      ATTRIBUTE(STYLE='sm1')
   
   CALL cl_ui_init()
 
   CALL cl_set_combo_lang("gbk04_1")
   CALL cl_set_combo_lang("gbk04_2")
   CALL cl_set_combo_lang("gbk04_3")
 
   CALL p_dynamic_flow_menu() 
 
   CLOSE WINDOW p_dynamic_flow_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_dynamic_flow_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_gbk1.clear()
   CALL g_gbk2.clear()
   CALL g_gbk3.clear()
   CALL cl_set_head_visible("grid01","YES")       #No.FUN-6A0092
 
   CONSTRUCT g_wc ON gbk01 FROM gbk01
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
              #No.FUN-580031 --start--     HCN
              ON ACTION qbe_select
                 CALL cl_qbe_select() 
              ON ACTION qbe_save
                 CALL cl_qbe_save()
              #No.FUN-580031 --end--       HCN
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE CONSTRUCT
#TQC-860017 end   
 
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql= "SELECT UNIQUE gbk01 FROM gbk_file ",
              " WHERE ", g_wc CLIPPED,
              #"   AND gbk01 NOT IN (SELECT gbk03 FROM gbk_file)",   #MOD-790012
              "   AND gbk01 != gbk03 ",   #MOD-790012
              " ORDER BY gbk01"
 
   PREPARE p_dynamic_flow_prepare FROM g_sql          # 預備一下
   DECLARE p_dynamic_flow_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_dynamic_flow_prepare
 
   LET g_sql = "SELECT COUNT(DISTINCT gbk01) FROM gbk_file ",
               " WHERE ",g_wc CLIPPED,
               #"   AND gbk01 NOT IN (SELECT gbk03 FROM gbk_file)"   #MOD-790012
               "   AND gbk01 != gbk03 "   #MOD-790012
 
   PREPARE p_dynamic_flow_precount FROM g_sql
   DECLARE p_dynamic_flow_count CURSOR FOR p_dynamic_flow_precount
END FUNCTION
 
FUNCTION p_dynamic_flow_menu()
 
   WHILE TRUE
 #MOD-560220-add
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
 #MOD-560220-end
 
      CASE g_b_flag
         WHEN 1
            CALL p_dynamic_flow_bp1()
         WHEN 2
            CALL p_dynamic_flow_bp2()
         WHEN 3
            CALL p_dynamic_flow_bp3()
         OTHERWISE
            CALL p_dynamic_flow_bp1()
      END CASE
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_dynamic_flow_a()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_dynamic_flow_copy()
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_dynamic_flow_q()
            ELSE
               LET mi_curs_index = 0
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CASE g_b_flag
                  WHEN 1
                     CALL p_dynamic_flow_b1()
                  WHEN 2
                     CALL p_dynamic_flow_b2()
                  WHEN 3
                     CALL p_dynamic_flow_b3()
               END CASE
            ELSE
               LET g_action_choice = NULL
            END IF
        #---------No.TQC-6B0081 mark
        #WHEN "modify"
        #   IF cl_chk_act_auth() THEN
        #      CALL p_dynamic_flow_u()
        #   END IF
        #---------No.TQC-6B0081 end
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 #MOD-560220
         WHEN "cancel"                          # Esc.結束
            EXIT WHILE
##
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_dynamic_flow_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_gbk1.clear()
   CALL g_gbk2.clear()
   CALL g_gbk3.clear()
 
   INITIALIZE g_gbk01 LIKE gbk_file.gbk01         # 預設值及將數值類變數清成零
   LET g_gbk01_t = NULL
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_dynamic_flow_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_gbk1.clear()
      CALL g_gbk2.clear()
      CALL g_gbk3.clear()
      LET g_rec_b1 = 0
      LET g_rec_b2 = 0
      LET g_rec_b3 = 0
 
      IF g_ss='N' THEN
         LET ms_layer0 = g_gbk01
         CALL g_gbk1.clear()
      ELSE
         CALL p_dynamic_flow_b_fill1('1=1')             # 單身
      END IF
 
      IF (NOT g_result) THEN
         CALL p_dynamic_flow_b1()                          # 輸入單身
      END IF
      LET g_gbk01_t=g_gbk01
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_dynamic_flow_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1           # a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)
 
   LET g_ss = 'N'
   DISPLAY g_gbk01 TO gbk01
   CALL cl_set_head_visible("grid01","YES")       #No.FUN-6A0092
 
   INPUT g_gbk01 WITHOUT DEFAULTS FROM gbk01
 
 
    #NO.MOD-580056------
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_dy_flow_set_entry(p_cmd)
         CALL p_dy_flow_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
   #--------END
 
      AFTER FIELD gbk01                         
         IF NOT cl_null(g_gbk01) THEN
            IF g_gbk01 != g_gbk01_t OR cl_null(g_gbk01_t) THEN
               LET g_cnt = 0
               SELECT COUNT(UNIQUE gbk01) INTO g_cnt FROM gbk_file
                WHERE gbk01 = g_gbk01
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  ELSE
                     NEXT FIELD gbk01
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gbk01,-239,0)
                     LET g_gbk01 = g_gbk01_t
                     NEXT FIELD gbk01
                  END IF
               END IF
 
#              CALL check_dir(g_gbk01) RETURNING g_result
#              IF (g_result) THEN
#                 EXIT INPUT
#              END IF
 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_gbk01,g_errno,0)
                  NEXT FIELD gbk01
               END IF
            END IF
         END IF
 
       ON ACTION controlf     #欄位說明 MOD-540140
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE INPUT
#TQC-860017 end
 
   END INPUT
END FUNCTION
 
FUNCTION check_dir(ps_gbk01)
   DEFINE   ps_gbk01    LIKE gbk_file.gbk01
   DEFINE   ls_gbk01    LIKE gbk_file.gbk01
   DEFINE   ls_unpass   LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   li_cnt      LIKE type_file.num10   #FUN-680135 INTEGER
 
   # 確定分類節點不是程式名稱 
   SELECT COUNT(*) INTO li_cnt FROM gaz_file,zz_file
    WHERE gaz01 = ps_gbk01 AND gaz01 = zz01 
   IF li_cnt > 0 THEN
      CALL cl_err(ps_gbk01,'azz-038',1)
      LET ls_unpass = TRUE
   END IF
 
   RETURN ls_unpass
         
END FUNCTION
 
FUNCTION p_dynamic_flow_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gbk01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gbk01_t = g_gbk01
 
   WHILE TRUE
      CALL p_dynamic_flow_i("u")
      IF INT_FLAG THEN
         LET g_gbk01 = g_gbk01_t
         DISPLAY g_gbk01 TO gbk01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gbk_file SET gbk01 = g_gbk01
       WHERE gbk01 = g_gbk01_t
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_gbk01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","gbk_file",g_gbk01_t,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_dynamic_flow_q()                            #Query 查詢
   MESSAGE ""
  #CLEAR FROM  #No.TQC-740075
   CLEAR FORM  #No.TQC-740075
   CALL g_gbk1.clear()
   CALL g_gbk2.clear()
   CALL g_gbk3.clear()
   LET mi_curs_index = 0
   DISPLAY '    ' TO FORMONLY.cnt
 
   CALL p_dynamic_flow_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_dynamic_flow_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gbk01 TO NULL
   ELSE
      CALL p_dynamic_flow_fetch('F')                 #讀出TEMP第一筆並顯示
      OPEN p_dynamic_flow_count
       FETCH p_dynamic_flow_count INTO g_row_count #No.FUN-580092 HCN
       DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
    END IF
END FUNCTION
 
FUNCTION p_dynamic_flow_fetch(p_flag)          #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1       #處理方式        #No.FUN-680135 VARCHAR(1) 
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_dynamic_flow_b_curs INTO g_gbk01 
      WHEN 'P' FETCH PREVIOUS p_dynamic_flow_b_curs INTO g_gbk01
      WHEN 'F' FETCH FIRST    p_dynamic_flow_b_curs INTO g_gbk01
      WHEN 'L' FETCH LAST     p_dynamic_flow_b_curs INTO g_gbk01
      WHEN '/' 
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR mi_jump
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
#TQC-860017 end
        
            END PROMPT
 
            IF INT_FLAG THEN
               LET INT_FLAG = FALSE
               RETURN
            END IF
         END IF
         LET mi_no_ask = FALSE
         FETCH ABSOLUTE mi_jump p_dynamic_flow_b_curs INTO g_gbk01
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gbk01,SQLCA.sqlcode,0)
      INITIALIZE g_gbk01 TO NULL  #TQC-6B0105
      LET g_gbk01 = NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET mi_curs_index = 1
         WHEN 'P' LET mi_curs_index = mi_curs_index - 1
         WHEN 'N' LET mi_curs_index = mi_curs_index + 1
          WHEN 'L' LET mi_curs_index = g_row_count #No.FUN-580092 HCN
         WHEN '/' LET mi_curs_index = mi_jump
      END CASE
 
       CALL cl_navigator_setting(mi_curs_index, g_row_count) #No.FUN-580092 HCN
 
      CALL p_dynamic_flow_show()
   END IF
END FUNCTION
 
FUNCTION p_dynamic_flow_show()                         # 將資料顯示在畫面上
   DEFINE   ls_msg       LIKE type_file.chr1000 #FUN-680135 VARCHAR(255)
   DEFINE   lwin_curr    ui.Window,
            lnode_item   om.DomNode,
            lnode_child  om.DomNode
 
 
   DISPLAY g_gbk01 TO gbk01
   LET ms_layer0 = g_gbk01
   # 2004/05/19 by saki : 為了在同一個table上設置多語言, 必須多TopFlow這個最根節點,
   #                      但他所屬的多語言實在沒有地方可以塞入了,而且只是提示功能, 
   #                      所以就不建在資料庫, 以最原始寫法表示多語言 
   CALL p_dynamic_flow_b_fill1(g_wc)                    # 單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
{
FUNCTION p_dynamic_flow_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_gbk   RECORD LIKE gbk_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gbk01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM gbk_file WHERE gbk01 = g_gbk01
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","gbk_file",g_gbk01,"",SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         OPEN p_dynamic_flow_count
         IF STATUS THEN
            CLOSE p_dynamic_flow_count
         ELSE
             FETCH p_dynamic_flow_count INTO g_row_count #No.FUN-580092 HCN
            IF SQLCA.sqlcode THEN
               CLOSE p_dynamic_flow_count
            ELSE
                DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
               OPEN p_dynamic_flow_b_curs
                IF mi_curs_index = g_row_count + 1 THEN #No.FUN-580092 HCN
                   LET mi_jump = g_row_count #No.FUN-580092 HCN
                  CALL p_dynamic_flow_fetch('L')
               ELSE
                  LET mi_jump = mi_curs_index
                  LET mi_no_ask = TRUE
                  CALL p_dynamic_flow_fetch('/')
               END IF
 #              MESSAGE 'Remove (',g_row_count USING '####&',') Row(s)' #No.FUN-580092 HCN
            END IF
         END IF
      END IF
   END IF
END FUNCTION
}
FUNCTION p_dynamic_flow_b1()                      # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,               # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,   #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_result       LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   li_cnt          LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE   ls_gbk05        STRING
   DEFINE   ls_gaz03        LIKE gaz_file.gaz03
   DEFINE   ls_max_rec      LIKE type_file.num5    #FUN-680135 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
    LET g_gbk01 = ms_layer0                        #No.MOD-580040
   IF cl_null(g_gbk01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gbk02,gbk04,gbk03,gbk05,gbk06",
                     "  FROM gbk_file",
                     "  WHERE gbk01 = ? AND gbk02 = ? AND gbk04 = ?",
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_dynamic_flow_bcl_1 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET ls_max_rec = 100 
   INPUT ARRAY g_gbk1 WITHOUT DEFAULTS FROM s_gbk1.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,      #MOD-AA0127 ls_max_rec modify g_max_rec
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(l_ac1)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac1 = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b1 >= l_ac1 THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gbk_t1.* = g_gbk1[l_ac1].*    #BACKUP
#NO.MOD-590329 MARK---------------
 #No.MOD-580056 --start
#            LET g_before_input_done = FALSE
#            CALL p_dy_flow_set_entry_b1(p_cmd)
#            CALL p_dy_flow_set_no_entry_b1(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK---------------
            OPEN p_dynamic_flow_bcl_1 USING g_gbk01,g_gbk_t1.gbk02_1,g_gbk_t1.gbk04_1
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_dynamic_flow_bcl_1:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_dynamic_flow_bcl_1 INTO g_gbk1[l_ac1].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gbk_t1.gbk02_1,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gbk1[l_ac1].* TO NULL       #900423
         LET g_gbk_t1.* = g_gbk1[l_ac1].*          #新輸入資料
#NO.MOD-590329 MARK---------------------
 #No.MOD-580056 --start
#         LET g_before_input_done = FALSE
#         CALL p_dy_flow_set_entry_b1(p_cmd)
#         CALL p_dy_flow_set_no_entry_b1(p_cmd)
#         LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK---------------------
         NEXT FIELD gbk02_1
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO gbk_file(gbk01,gbk02,gbk03,gbk04,gbk05,gbk06)
              VALUES (g_gbk01,g_gbk1[l_ac1].gbk02_1,g_gbk1[l_ac1].gbk03_1,
                      g_gbk1[l_ac1].gbk04_1,g_gbk1[l_ac1].gbk05_1,
                      g_gbk1[l_ac1].gbk06_1)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gbk01,SQLCA.sqlcode,0)
            CALL cl_err3("ins","gbk_file",g_gbk01,g_gbk1[l_ac1].gbk02_1,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b1 = g_rec_b1 + 1
         END IF
    
      BEFORE FIELD gbk02_1
         IF cl_null(g_gbk1[l_ac1].gbk02_1) THEN
            SELECT MAX(gbk02) + 1 INTO g_gbk1[l_ac1].gbk02_1 FROM gbk_file
             WHERE gbk01 = g_gbk01 
            IF cl_null(g_gbk1[l_ac1].gbk02_1) THEN
               LET g_gbk1[l_ac1].gbk02_1 = 1
            END IF
         END IF
 
      AFTER FIELD gbk02_1
         IF NOT cl_null(g_gbk1[l_ac1].gbk02_1) THEN
            IF ((g_gbk1[l_ac1].gbk02_1 != g_gbk_t1.gbk02_1) OR 
               (g_gbk_t1.gbk02_1 IS NULL)) THEN
               SELECT COUNT(*) INTO l_n FROM gbk_file
                WHERE gbk01 = g_gbk01 AND gbk02 = g_gbk1[l_ac1].gbk02_1
                  AND gbk04 = g_gbk1[l_ac1].gbk04_1
               IF l_n > 0 THEN
                  CALL cl_err(g_gbk1[l_ac1].gbk02_1,-239,0)
                  LET g_gbk1[l_ac1].gbk02_1 = g_gbk_t1.gbk02_1
                  NEXT FIELD gbk02_1
               END IF
               # 是否超過20筆
               SELECT COUNT(*) INTO li_cnt FROM gbk_file
                WHERE gbk01 = g_gbk01 AND gbk02 = g_gbk1[l_ac1].gbk02_1
               IF li_cnt <= 0 THEN
                  SELECT COUNT(UNIQUE gbk02) INTO li_cnt FROM gbk_file
                   WHERE gbk01 = g_gbk01
                  IF li_cnt >= 20 THEN         #No.FUN-610052
                     CALL cl_err('','azz-039',1)
                     CALL g_gbk1.deleteElement(l_ac1)
                  END IF
               END IF
             END IF
         END IF
 
      AFTER FIELD gbk04_1
         IF NOT cl_null(g_gbk1[l_ac1].gbk04_1) THEN
            IF g_gbk1[l_ac1].gbk04_1 != g_gbk_t1.gbk04_1 OR g_gbk_t1.gbk04_1 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM gbk_file
                WHERE gbk01 = g_gbk01 AND gbk02 = g_gbk1[l_ac1].gbk02_1
                  AND gbk04 = g_gbk1[l_ac1].gbk04_1
               IF l_n > 0 THEN
                  CALL cl_err(g_gbk1[l_ac1].gbk04_1,-239,0)
                  LET g_gbk1[l_ac1].gbk04_1 = g_gbk_t1.gbk04_1
                  NEXT FIELD gbk04_1
               END IF
            END IF
         END IF
 
      AFTER FIELD gbk03_1
         IF NOT cl_null(g_gbk1[l_ac1].gbk03_1) THEN
            IF g_gbk1[l_ac1].gbk03_1 = g_gbk01 THEN
               NEXT FIELD gbk03_1
            END IF
 
            # 如果為程式代碼, gbk05 button顯示名稱帶出program名稱
            SELECT COUNT(*) INTO l_n FROM gaz_file,zz_file
             WHERE zz01 = g_gbk1[l_ac1].gbk03_1 AND gaz01 = zz01
            IF l_n > 0 AND cl_null(g_gbk1[l_ac1].gbk05_1) THEN
 
 #              #MOD-540163
#              SELECT gaz03 INTO ls_gaz03 FROM gaz_file
#               WHERE gaz01 = g_gbk1[l_ac1].gbk03_1 AND gaz02 = g_gbk1[l_ac1].gbk04_1 order by gaz05
               CALL cl_get_progname(g_gbk1[l_ac1].gbk03_1,g_gbk1[l_ac1].gbk04_1) RETURNING ls_gaz03
 
               IF NOT cl_null(ls_gaz03) THEN
                  LET g_gbk1[l_ac1].gbk05_1 = ls_gaz03
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gbk_t1.gbk03_1) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gbk_file WHERE gbk01 = g_gbk01
                                   AND gbk02 = g_gbk1[l_ac1].gbk02_1
                                   AND gbk04 = g_gbk1[l_ac1].gbk04_1
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbk_t1.gbk02_1,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gbk_file",g_gbk01,g_gbk_t1.gbk02_1,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b1 = g_rec_b1 - 1
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gbk1[l_ac1].* = g_gbk_t1.*
            CLOSE p_dynamic_flow_bcl_1
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gbk1[l_ac1].gbk02_1,-263,1)
            LET g_gbk1[l_ac1].* = g_gbk_t1.*
         ELSE
            UPDATE gbk_file
               SET gbk02 = g_gbk1[l_ac1].gbk02_1,
                   gbk03 = g_gbk1[l_ac1].gbk03_1,
                   gbk04 = g_gbk1[l_ac1].gbk04_1,
                   gbk05 = g_gbk1[l_ac1].gbk05_1,
                   gbk06 = g_gbk1[l_ac1].gbk06_1
             WHERE gbk01 = g_gbk01
               AND gbk02 = g_gbk_t1.gbk02_1 AND gbk04 = g_gbk_t1.gbk04_1
            UPDATE gbk_file
               SET gbk01 = g_gbk1[l_ac1].gbk03_1
             WHERE gbk01 = g_gbk_t1.gbk03_1
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbk1[l_ac1].gbk02_1,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gbk_file",g_gbk_t1.gbk03_1,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gbk1[l_ac1].* = g_gbk_t1.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac1 = ARR_CURR()
        #LET l_ac_t = l_ac1  #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gbk1[l_ac1].* = g_gbk_t1.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gbk1.deleteElement(l_ac1)
               IF g_rec_b1 != 0 THEN
                  LET g_action_choice = "detail"
                  LET g_b_flag = '1'
                  LET l_ac1 = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_dynamic_flow_bcl_1
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac1   #FUN-D30034 add
         CLOSE p_dynamic_flow_bcl_1
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gbk02_1) AND l_ac1 > 1 THEN
            LET g_gbk1[l_ac1].* = g_gbk1[l_ac1-1].*
            NEXT FIELD gbk02_1
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
 
      ON ACTION controls                             #No.FUN-6A0092                                                                       
         CALL cl_set_head_visible("grid01","AUTO")   #No.FUN-6A0092 
 
   END INPUT
   CLOSE p_dynamic_flow_bcl_1
   COMMIT WORK
END FUNCTION
 
FUNCTION p_dynamic_flow_b2()                      # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,               # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,   #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_result       LIKE type_file.num5    #FUN-680135    SMALLINT
   DEFINE   li_cnt          LIKE type_file.num10   #FUN-680135    INTEGER
   DEFINE   ls_gbk05        STRING
   DEFINE   ls_gaz03        LIKE gaz_file.gaz03
   DEFINE   ls_max_rec      LIKE type_file.num5    #FUN-680135    SMALLINT
 
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
    LET g_gbk01 = ms_layer1                         #No.MOD-580040
   IF cl_null(g_gbk01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gbk02,gbk04,gbk03,gbk05,gbk06",
                     "  FROM gbk_file",
                     "  WHERE gbk01 = ? AND gbk02 = ? AND gbk04 = ?",
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_dynamic_flow_bcl_2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_gbk2 WITHOUT DEFAULTS FROM s_gbk2.*
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,      #MOD-AA0127 ls_max_rec modify g_max_rec
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac2 = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b2 >= l_ac2 THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gbk_t2.* = g_gbk2[l_ac2].*    #BACKUP
            OPEN p_dynamic_flow_bcl_2 USING g_gbk01,g_gbk_t2.gbk02_2,g_gbk_t2.gbk04_2
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_dynamic_flow_bcl_2:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_dynamic_flow_bcl_2 INTO g_gbk2[l_ac2].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gbk_t2.gbk02_2,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gbk2[l_ac2].* TO NULL       #900423
         LET g_gbk_t2.* = g_gbk2[l_ac2].*          #新輸入資料
         NEXT FIELD gbk02_2
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO gbk_file(gbk01,gbk02,gbk03,gbk04,gbk05,gbk06)
              VALUES (g_gbk01,g_gbk2[l_ac2].gbk02_2,g_gbk2[l_ac2].gbk03_2,
                      g_gbk2[l_ac2].gbk04_2,g_gbk2[l_ac2].gbk05_2,
                      g_gbk2[l_ac2].gbk06_2)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gbk01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gbk_file",g_gbk01,g_gbk2[l_ac2].gbk02_2,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b1 = g_rec_b1 + 1
         END IF
    
      BEFORE FIELD gbk02_2
         IF cl_null(g_gbk2[l_ac2].gbk02_2) THEN
            SELECT MAX(gbk02) + 1 INTO g_gbk2[l_ac2].gbk02_2 FROM gbk_file
             WHERE gbk01 = g_gbk01 
            IF cl_null(g_gbk2[l_ac2].gbk02_2) THEN
               LET g_gbk2[l_ac2].gbk02_2 = 1
            END IF
         END IF
 
      AFTER FIELD gbk02_2
         IF NOT cl_null(g_gbk2[l_ac2].gbk02_2) THEN
            IF g_gbk2[l_ac2].gbk02_2 != g_gbk_t2.gbk02_2 OR g_gbk_t2.gbk02_2 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM gbk_file
                WHERE gbk01 = g_gbk01 AND gbk02 = g_gbk2[l_ac2].gbk02_2
                  AND gbk04 = g_gbk2[l_ac2].gbk04_2
               IF l_n > 0 THEN
                  CALL cl_err(g_gbk2[l_ac2].gbk02_2,-239,0)
                  LET g_gbk2[l_ac2].gbk02_2 = g_gbk_t2.gbk02_2
                  NEXT FIELD gbk02_2
               END IF
               # 是否超過20筆
               SELECT COUNT(*) INTO li_cnt FROM gbk_file
                WHERE gbk01 = g_gbk01 AND gbk02 = g_gbk1[l_ac1].gbk02_1
               IF li_cnt <= 0 THEN
                  SELECT COUNT(UNIQUE gbk02) INTO li_cnt FROM gbk_file
                   WHERE gbk01 = g_gbk01
                  IF li_cnt >= 20 THEN
                     CALL cl_err('','azz-039',1)
                     CALL g_gbk1.deleteElement(l_ac1)
                  END IF
               END IF
             END IF
         END IF
 
      AFTER FIELD gbk04_2
         IF NOT cl_null(g_gbk2[l_ac2].gbk04_2) THEN
            IF g_gbk2[l_ac2].gbk04_2 != g_gbk_t2.gbk04_2 OR g_gbk_t2.gbk04_2 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM gbk_file
                WHERE gbk01 = g_gbk01 AND gbk02 = g_gbk2[l_ac2].gbk02_2
                  AND gbk04 = g_gbk2[l_ac2].gbk04_2
               IF l_n > 0 THEN
                  CALL cl_err(g_gbk2[l_ac2].gbk04_2,-239,0)
                  LET g_gbk2[l_ac2].gbk04_2 = g_gbk_t2.gbk04_2
                  NEXT FIELD gbk04_2
               END IF
            END IF
         END IF
 
      AFTER FIELD gbk03_2
         IF NOT cl_null(g_gbk2[l_ac2].gbk03_2) THEN
            IF g_gbk2[l_ac2].gbk03_2 = g_gbk01 THEN
               NEXT FIELD gbk03_2
            END IF
 
            # 如果為程式代碼, gbk05 button顯示名稱帶出program名稱
            SELECT COUNT(*) INTO l_n FROM gaz_file,zz_file
             WHERE zz01 = g_gbk2[l_ac2].gbk03_2 AND gaz01 = zz01
            IF l_n > 0 AND cl_null(g_gbk2[l_ac2].gbk05_2) THEN
 
 #              #MOD-540163
#              SELECT gaz03 INTO ls_gaz03 FROM gaz_file
#               WHERE gaz01 = g_gbk2[l_ac2].gbk03_2 AND gaz02 = g_gbk2[l_ac2].gbk04_2 order by gaz05
               CALL cl_get_progname(g_gbk2[l_ac2].gbk03_2,g_gbk2[l_ac2].gbk04_2) RETURNING ls_gaz03
 
               IF NOT cl_null(ls_gaz03) THEN
                  LET g_gbk2[l_ac2].gbk05_2 = ls_gaz03
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gbk_t2.gbk03_2) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gbk_file WHERE gbk01 = g_gbk01
                                   AND gbk02 = g_gbk2[l_ac2].gbk02_2
                                   AND gbk04 = g_gbk2[l_ac2].gbk04_2
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbk_t2.gbk02_2,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gbk_file",g_gbk01,g_gbk_t2.gbk02_2,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b2 = g_rec_b2 - 1
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gbk2[l_ac2].* = g_gbk_t2.*
            CLOSE p_dynamic_flow_bcl_2
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gbk2[l_ac2].gbk02_2,-263,1)
            LET g_gbk2[l_ac2].* = g_gbk_t2.*
         ELSE
            UPDATE gbk_file
               SET gbk02 = g_gbk2[l_ac2].gbk02_2,
                   gbk03 = g_gbk2[l_ac2].gbk03_2,
                   gbk04 = g_gbk2[l_ac2].gbk04_2,
                   gbk05 = g_gbk2[l_ac2].gbk05_2,
                   gbk06 = g_gbk2[l_ac2].gbk06_2
             WHERE gbk01 = g_gbk01
               AND gbk02 = g_gbk_t2.gbk02_2 AND gbk04 = g_gbk_t2.gbk04_2
            UPDATE gbk_file
               SET gbk01 = g_gbk2[l_ac2].gbk03_2
             WHERE gbk01 = g_gbk_t2.gbk03_2
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbk2[l_ac2].gbk02_2,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gbk_file",g_gbk_t2.gbk03_2,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gbk2[l_ac2].* = g_gbk_t2.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac2 = ARR_CURR()
        #LET l_ac_t = l_ac2   #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gbk2[l_ac2].* = g_gbk_t2.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gbk2.deleteElement(l_ac2)
               IF g_rec_b2 != 0 THEN
                  LET g_action_choice = "detail"
                  LET g_b_flag = '2'
                  LET l_ac2 = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_dynamic_flow_bcl_2
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac2  #FUN-D30034 add
         CLOSE p_dynamic_flow_bcl_2
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gbk02_2) AND l_ac2 > 1 THEN
            LET g_gbk2[l_ac2].* = g_gbk2[l_ac2-1].*
            NEXT FIELD gbk02_2
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
 
       ON ACTION controls                             #No.FUN-6A0092                                                                       
          CALL cl_set_head_visible("grid01","AUTO")   #No.FUN-6A0092 
 
   END INPUT
   CLOSE p_dynamic_flow_bcl_2
   COMMIT WORK
END FUNCTION
 
FUNCTION p_dynamic_flow_b3()                      # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,          # 未取消的ARRAY CNT  #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,          # 檢查重複用   #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,          # 單身鎖住否   #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,          # 處理狀態     #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5           #No.FUN-680135 SMALLINT
   DEFINE   ls_result       LIKE type_file.num5           #FUN-680135    SMALLINT
   DEFINE   li_cnt          LIKE type_file.num10          #FUN-680135    INTEGER
   DEFINE   ls_gbk05        STRING
   DEFINE   ls_gaz03        LIKE gaz_file.gaz03
   DEFINE   ls_max_rec      LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   ls_str          STRING                 #No.MOD-560232
 
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
    LET g_gbk01 = ms_layer2                        #No.MOD-580040
   IF cl_null(g_gbk01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gbk02,gbk04,gbk03,gbk05,gbk06",
                     "  FROM gbk_file",
                     "  WHERE gbk01 = ? AND gbk02 = ? AND gbk04 = ?",
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_dynamic_flow_bcl_3 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_gbk3 WITHOUT DEFAULTS FROM s_gbk3.*
         ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,      #MOD-AA0127 ls_max_rec modify g_max_rec
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b3 != 0 THEN
            CALL fgl_set_arr_curr(l_ac3)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac3 = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b3 >= l_ac3 THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gbk_t3.* = g_gbk3[l_ac3].*    #BACKUP
            OPEN p_dynamic_flow_bcl_3 USING g_gbk01,g_gbk_t3.gbk02_3,g_gbk_t3.gbk04_3
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_dynamic_flow_bcl_3:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_dynamic_flow_bcl_3 INTO g_gbk3[l_ac3].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gbk_t3.gbk02_3,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gbk3[l_ac3].* TO NULL       #900423
         LET g_gbk_t3.* = g_gbk3[l_ac3].*          #新輸入資料
         NEXT FIELD gbk02_3
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO gbk_file(gbk01,gbk02,gbk03,gbk04,gbk05,gbk06)
              VALUES (g_gbk01,g_gbk3[l_ac3].gbk02_3,g_gbk3[l_ac3].gbk03_3,
                      g_gbk3[l_ac3].gbk04_3,g_gbk3[l_ac3].gbk05_3,
                      g_gbk3[l_ac3].gbk06_3)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gbk01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gbk_file",g_gbk01,g_gbk3[l_ac3].gbk02_3,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b1 = g_rec_b1 + 1
         END IF
    
      BEFORE FIELD gbk02_3
         IF cl_null(g_gbk3[l_ac3].gbk02_3) THEN
            SELECT MAX(gbk02) + 1 INTO g_gbk3[l_ac3].gbk02_3 FROM gbk_file
             WHERE gbk01 = g_gbk01 
            IF cl_null(g_gbk3[l_ac3].gbk02_3) THEN
               LET g_gbk3[l_ac3].gbk02_3 = 1
            END IF
         END IF
 
      AFTER FIELD gbk02_3
         IF NOT cl_null(g_gbk3[l_ac3].gbk02_3) THEN
            IF g_gbk3[l_ac3].gbk02_3 != g_gbk_t3.gbk02_3 OR g_gbk_t3.gbk02_3 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM gbk_file
                WHERE gbk01 = g_gbk01 AND gbk02 = g_gbk3[l_ac3].gbk02_3
                  AND gbk04 = g_gbk3[l_ac3].gbk04_3
               IF l_n > 0 THEN
                  CALL cl_err(g_gbk3[l_ac3].gbk02_3,-239,0)
                  LET g_gbk3[l_ac3].gbk02_3 = g_gbk_t3.gbk02_3
                  NEXT FIELD gbk02_3
               END IF
               # 是否超過20筆
               SELECT COUNT(*) INTO li_cnt FROM gbk_file
                WHERE gbk01 = g_gbk01 AND gbk02 = g_gbk1[l_ac1].gbk02_1
               IF li_cnt <= 0 THEN
                  SELECT COUNT(UNIQUE gbk02) INTO li_cnt FROM gbk_file
                   WHERE gbk01 = g_gbk01
                  IF li_cnt >= 20 THEN
                     CALL cl_err('','azz-039',1)
                     CALL g_gbk1.deleteElement(l_ac1)
                  END IF
               END IF
             END IF
         END IF
 
      AFTER FIELD gbk04_3
         IF NOT cl_null(g_gbk3[l_ac3].gbk04_3) THEN
            IF g_gbk3[l_ac3].gbk04_3 != g_gbk_t3.gbk04_3 OR g_gbk_t3.gbk04_3 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM gbk_file
                WHERE gbk01 = g_gbk01 AND gbk02 = g_gbk3[l_ac3].gbk02_3
                  AND gbk04 = g_gbk3[l_ac3].gbk04_3
               IF l_n > 0 THEN
                  CALL cl_err(g_gbk3[l_ac3].gbk04_3,-239,0)
                  LET g_gbk3[l_ac3].gbk04_3 = g_gbk_t3.gbk04_3
                  NEXT FIELD gbk04_3
               END IF
            END IF
         END IF
 
      AFTER FIELD gbk03_3
         IF NOT cl_null(g_gbk3[l_ac3].gbk03_3) THEN
            IF g_gbk3[l_ac3].gbk03_3 = g_gbk01 THEN
               NEXT FIELD gbk03_3
            END IF
 
            # 如果為程式代碼, gbk05 button顯示名稱帶出program名稱
             #No.MOD-560232 --start--
            SELECT COUNT(*) INTO l_n FROM zz_file WHERE zz01 = g_gbk3[l_ac3].gbk03_3
            LET ls_str = g_gbk3[l_ac3].gbk03_3
            IF (l_n <= 0) AND
               ((ls_str.subString(1,5) != "dummy") OR (ls_str.subString(1,5) IS NULL)) THEN
               CALL cl_err(g_gbk3[l_ac3].gbk03_3,"azz-721",1)
               NEXT FIELD gbk03_3
            ELSE
               IF l_n > 0 AND cl_null(g_gbk3[l_ac3].gbk05_3) THEN
 #                 #MOD-540163
#                 SELECT gaz03 INTO ls_gaz03 FROM gaz_file
#                  WHERE gaz01 = g_gbk3[l_ac3].gbk03_3 AND gaz03 = g_gbk3[l_ac3].gbk04_3 order by gaz05
                  CALL cl_get_progname(g_gbk3[l_ac3].gbk03_3,g_gbk3[l_ac3].gbk04_3) RETURNING ls_gaz03
 
                  IF NOT cl_null(ls_gaz03) THEN
                     LET g_gbk3[l_ac3].gbk05_3 = ls_gaz03
                  END IF
               END IF
            END IF
             #No.MOD-560232 ---end---
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gbk_t3.gbk03_3) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gbk_file WHERE gbk01 = g_gbk01
                                    AND gbk02 = g_gbk3[l_ac3].gbk02_3    # MOD-4B0202
                                   AND gbk04 = g_gbk3[l_ac3].gbk04_3
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbk_t3.gbk02_3,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gbk_file",g_gbk01,g_gbk_t3.gbk02_3,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b3 = g_rec_b3 - 1
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gbk3[l_ac3].* = g_gbk_t3.*
            CLOSE p_dynamic_flow_bcl_3
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gbk3[l_ac3].gbk02_3,-263,1)
            LET g_gbk3[l_ac3].* = g_gbk_t3.*
         ELSE
            UPDATE gbk_file
               SET gbk02 = g_gbk3[l_ac3].gbk02_3,
                   gbk03 = g_gbk3[l_ac3].gbk03_3,
                   gbk04 = g_gbk3[l_ac3].gbk04_3,
                   gbk05 = g_gbk3[l_ac3].gbk05_3,
                   gbk06 = g_gbk3[l_ac3].gbk06_3
             WHERE gbk01 = g_gbk01
               AND gbk02 = g_gbk_t3.gbk02_3 AND gbk04 = g_gbk_t3.gbk04_3
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbk3[l_ac3].gbk02_3,SQLCA.sqlcode,0) #No.FUN-660081
               CALL cl_err3("upd","gbk_file",g_gbk01,g_gbk_t3.gbk02_3,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gbk3[l_ac3].* = g_gbk_t3.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac3 = ARR_CURR()
        #LET l_ac_t = l_ac3   #FUN-D3003 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gbk3[l_ac3].* = g_gbk_t3.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gbk3.deleteElement(l_ac3)
               IF g_rec_b3 != 0 THEN
                  LET g_action_choice = "detail"
                  LET g_b_flag = '3'
                  LET l_ac3 = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_dynamic_flow_bcl_3
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac3  #FUN-D30034 add
         CLOSE p_dynamic_flow_bcl_3
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gbk02_3) AND l_ac3 > 1 THEN
            LET g_gbk3[l_ac3].* = g_gbk3[l_ac3-1].*
            NEXT FIELD gbk02_3
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
 
      ON ACTION controls                             #No.FUN-6A0092                                                                       
         CALL cl_set_head_visible("grid01","AUTO")   #No.FUN-6A0092 
 
   END INPUT
   CLOSE p_dynamic_flow_bcl_3
   COMMIT WORK
END FUNCTION
 
FUNCTION p_dynamic_flow_b_fill1(p_wc)              #BODY FILL UP
   DEFINE   p_wc   LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(300)
 
    LET g_sql = "SELECT gbk02,gbk04,gbk03,gbk05,gbk06 ",
                "  FROM gbk_file ",
                " WHERE gbk01 = '",g_gbk01 CLIPPED,"' ",
                "   AND ",p_wc CLIPPED,
                " ORDER BY gbk02,gbk04"
 
    PREPARE p_dynamic_flow_prepare1 FROM g_sql           #預備一下
    DECLARE gbk_curs_1 CURSOR FOR p_dynamic_flow_prepare1
 
    CALL g_gbk1.clear()
     CALL g_gbk2.clear()                           #No.MOD-580040
     CALL g_gbk3.clear()                           #No.MOD-580040
 
    LET g_cnt = 1
    LET g_rec_b1 = 0
 
    FOREACH gbk_curs_1 INTO g_gbk1[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b1 = g_rec_b1 + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gbk1.deleteElement(g_cnt)
 
    LET g_rec_b1 = g_cnt - 1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_dynamic_flow_b_fill2(p_wc)              #BODY FILL UP
   DEFINE   p_wc       LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(300)
 
    LET g_sql = "SELECT gbk02,gbk04,gbk03,gbk05,gbk06 ",
                "  FROM gbk_file ",
                " WHERE ",p_wc CLIPPED,
                " ORDER BY gbk02,gbk04"
 
    PREPARE p_dynamic_flow_prepare2 FROM g_sql           #預備一下
    DECLARE gbk_curs_2 CURSOR FOR p_dynamic_flow_prepare2
 
    CALL g_gbk2.clear()
     CALL g_gbk3.clear()                           #No.MOD-580040
 
    LET g_cnt = 1
    LET g_rec_b2 = 0
 
    FOREACH gbk_curs_2 INTO g_gbk2[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b2 = g_rec_b2 + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gbk2.deleteElement(g_cnt)
 
    LET g_rec_b2 = g_cnt - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_dynamic_flow_b_fill3(p_wc)              #BODY FILL UP
   DEFINE   p_wc   LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(300)
 
   LET g_sql = "SELECT gbk02,gbk04,gbk03,gbk05,gbk06 ",
               "  FROM gbk_file ",
               " WHERE ",p_wc CLIPPED,
               " ORDER BY gbk02,gbk04"
 
   PREPARE p_dynamic_flow_prepare3 FROM g_sql           #預備一下
   DECLARE gbk_curs_3 CURSOR FOR p_dynamic_flow_prepare3
 
   CALL g_gbk3.clear()
 
   LET g_cnt = 1
   LET g_rec_b3 = 0
 
   FOREACH gbk_curs_3 INTO g_gbk3[g_cnt].*       #單身 ARRAY 填充
      LET g_rec_b3 = g_rec_b3 + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gbk3.deleteElement(g_cnt)
 
   LET g_rec_b3 = g_cnt - 1
   DISPLAY g_rec_b3 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p_dynamic_flow_bp1()
   DEFINE   ls_msg       LIKE type_file.chr1000 #FUN-680135 VARCHAR(255)
 
   IF g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   #DISPLAY g_rec_b1 TO FORMONLY.cn2   #MOD-790012
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gbk1 TO s_gbk1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
      # 2004/01/17 by Hiko : 上下筆資料的ToolBar控制.
      BEFORE DISPLAY
          CALL cl_navigator_setting(mi_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
 
      ON ACTION preview_flow
         CALL p_dy_flow_preview_flow()
         LET g_action_choice = ""
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL cl_set_combo_lang("gbk04_1")
         CALL cl_set_combo_lang("gbk04_2")
         CALL cl_set_combo_lang("gbk04_3")
         EXIT DISPLAY
 
      ON ACTION modify_layer2
         LET l_ac1 = ARR_CURR()
         IF l_ac1 > 0 THEN
            CALL p_dynamic_flow_b_fill2('gbk01 = "' || g_gbk1[l_ac1].gbk03_1 || '"')
            LET ms_layer1 = g_gbk1[l_ac1].gbk03_1
            LET g_b_flag = 2
          #No.MOD-580040 --start--
         ELSE
            LET ms_layer1 = NULL
            CALL g_gbk2.clear()
          #No.MOD-580040 ---end---
         END IF
         EXIT DISPLAY
 
       #No.MOD-580040 --start--
      ON ACTION modify_layer3
         LET g_b_flag = 3
         LET ms_layer2 = NULL
         CALL g_gbk3.clear()
         EXIT DISPLAY
       #No.MOD-580040 ---end---
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
     #----------No.TQC-6B0081 mark
     #ON ACTION modify
     #   LET g_action_choice="modify"
     #   EXIT DISPLAY
     #----------No.TQC-6B0081 end
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET g_b_flag = 1
         LET l_ac1 = 1
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET g_b_flag = 1
         LET l_ac1 = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL p_dynamic_flow_fetch('F')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION previous                         # P.上筆
         CALL p_dynamic_flow_fetch('P')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION jump                             # 指定筆
         CALL p_dynamic_flow_fetch('/')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION next                             # N.下筆
         CALL p_dynamic_flow_fetch('N')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION last                             # 最終筆
         CALL p_dynamic_flow_fetch('L')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controls                             #No.FUN-6A0092                                                                       
         CALL cl_set_head_visible("grid01","AUTO")   #No.FUN-6A0092 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_dynamic_flow_bp2()
   DEFINE   ls_msg      LIKE type_file.chr1000 #FUN-680135 VARCHAR(255)
 
   IF g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   DISPLAY ms_layer1 TO gbk01_1
   #DISPLAY g_rec_b2 TO FORMONLY.cn2   #MOD-790012
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gbk2 TO s_gbk2.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      # 2004/01/17 by Hiko : 上下筆資料的ToolBar控制.
      BEFORE DISPLAY
          CALL cl_navigator_setting(mi_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
 
      ON ACTION preview_flow
         CALL p_dy_flow_preview_flow()
         LET g_action_choice = ""
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL cl_set_combo_lang("gbk04_1")
         CALL cl_set_combo_lang("gbk04_2")
         CALL cl_set_combo_lang("gbk04_3")
         EXIT DISPLAY
 
      ON ACTION modify_layer3
         LET l_ac2 = ARR_CURR()
         IF l_ac2 > 0 THEN
            CALL p_dynamic_flow_b_fill3('gbk01 = "' || g_gbk2[l_ac2].gbk03_2 || '"')
            LET ms_layer2 = g_gbk2[l_ac2].gbk03_2
            LET g_b_flag = 3
          #No.MOD-580040 --start--
         ELSE
            LET ms_layer2 = NULL
            CALL g_gbk3.clear()
          #No.MOD-580040 ---end---
         END IF
         EXIT DISPLAY
 
      ON ACTION modify_layer1
         LET g_b_flag = 1
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
     #----------No.TQC-6B0081 mark
     #ON ACTION modify
     #   LET g_action_choice="modify"
     #   EXIT DISPLAY
     #----------No.TQC-6B0081 end
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET g_b_flag = 2
         LET l_ac2 = 1
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET g_b_flag = 2
         LET l_ac2 = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL p_dynamic_flow_fetch('F')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION previous                         # P.上筆
         CALL p_dynamic_flow_fetch('P')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION jump                             # 指定筆
         CALL p_dynamic_flow_fetch('/')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION next                             # N.下筆
         CALL p_dynamic_flow_fetch('N')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION last                             # 最終筆
         CALL p_dynamic_flow_fetch('L')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_dynamic_flow_bp3()
   DEFINE   ls_msg       LIKE type_file.chr1000 #FUN-680135 VARCHAR(255)
 
   IF g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   DISPLAY ms_layer2 TO gbk01_2
   #DISPLAY g_rec_b3 TO FORMONLY.cn2   #MOD-790012
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gbk3 TO s_gbk3.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
      # 2004/01/17 by Hiko : 上下筆資料的ToolBar控制.
      BEFORE DISPLAY
          CALL cl_navigator_setting(mi_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_ac3 = ARR_CURR()
 
      ON ACTION preview_flow
         CALL p_dy_flow_preview_flow()
         LET g_action_choice = ""
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CALL cl_set_combo_lang("gbk04_1")
         CALL cl_set_combo_lang("gbk04_2")
         CALL cl_set_combo_lang("gbk04_3")
         EXIT DISPLAY
 
      ON ACTION modify_layer1
         LET g_b_flag = 1
         EXIT DISPLAY
 
      ON ACTION modify_layer2
         LET g_b_flag = 2
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
     #----------No.TQC-6B0081 mark
     #ON ACTION modify
     #   LET g_action_choice="modify"
     #   EXIT DISPLAY
     #----------No.TQC-6B0081 end
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET g_b_flag = 3
         LET l_ac2 = 1
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET g_b_flag = 3
         LET l_ac2 = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL p_dynamic_flow_fetch('F')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b3 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION previous                         # P.上筆
         CALL p_dynamic_flow_fetch('P')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b3 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION jump                             # 指定筆
         CALL p_dynamic_flow_fetch('/')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b3 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION next                             # N.下筆
         CALL p_dynamic_flow_fetch('N')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b3 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION last                             # 最終筆
         CALL p_dynamic_flow_fetch('L')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b3 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controls                             #No.FUN-6A0092                                                                       
         CALL cl_set_head_visible("grid01","AUTO")   #No.FUN-6A0092 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_dynamic_flow_copy()
   DEFINE   l_n       LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_newfe   LIKE gbk_file.gbk01,
            l_newta   LIKE gbk_file.gbk02,
            l_oldfe   LIKE gbk_file.gbk01,
            l_oldta   LIKE gbk_file.gbk02
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_gbk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("grid01","YES")       #No.FUN-6A0092
 
   INPUT l_newfe WITHOUT DEFAULTS FROM gbk01
 
      AFTER FIELD gbk01
         IF cl_null(l_newfe) THEN
            NEXT FIELD gbk01
         END IF
         SELECT COUNT(*) INTO g_cnt FROM gbk_file
          WHERE gbk01 = l_newfe
         IF g_cnt > 0 THEN
            CALL cl_err(l_newfe,-239,0)
            NEXT FIELD gbk01
         END IF
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE INPUT
#TQC-860017 end      
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_gbk01 TO gbk01
      RETURN
   END IF
 
   DROP TABLE x
   SELECT * FROM gbk_file WHERE gbk01 = g_gbk01
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_gbk01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","x",g_gbk01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET gbk01 = l_newfe              # 資料鍵值
 
   INSERT INTO gbk_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      #CALL cl_err('gbk:',SQLCA.SQLCODE,0)  #No.FUN-660081
      CALL cl_err3("ins","gbk_file",l_newfe,"",SQLCA.sqlcode,"","gbk",0)   #No.FUN-660081
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldfe = g_gbk01
   LET g_gbk01 = l_newfe
   CALL p_dynamic_flow_b1()
   #LET g_gbk01 = l_oldfe      #FUN-C30027
   #CALL p_dynamic_flow_show() #FUN-C30027
END FUNCTION
 
FUNCTION p_dy_flow_preview_flow()
   DEFINE   li_btn_cnt         LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE   ls_sub_menu        STRING
   DEFINE   li_dir_layer       LIKE type_file.num10   #FUN-680135 INTEGER
 
   DEFINE   li_mdir_cnt        LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   li_sdir_cnt        LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   li_i               LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE   li_del_btn         LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE   li_btn_tmp         LIKE type_file.num10   #FUN-680135 INTEGER
 
   DEFINE   lwin_curr          ui.Window,
            lfrm_curr          ui.Form
   DEFINE   lnode_gp01         om.DomNode
   DEFINE   lnode_gd01         om.DomNode
   DEFINE   lnode_gp02         om.DomNode
   DEFINE   lnode_gd02         om.DomNode
   DEFINE   lnode_gp03         om.DomNode
   DEFINE   lnode_gd03         om.DomNode
 
 
   IF cl_null(g_gbk01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   OPEN WINDOW p_preview_flow_w AT 5,1 WITH FORM "azz/42f/p_preview_flow"
      ATTRIBUTE(STYLE='viewer')
   
   CALL cl_ui_locale("p_preview_flow")
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   
   WHILE TRUE
      IF g_action_choice = "locale" THEN
         LET lnode_gp01 = lwin_curr.findNode("Group","gp_flow01")
         LET lnode_gd01 = lnode_gp01.getFirstChild()
         LET lnode_gp02 = lwin_curr.findNode("Group","gp_flow02")
         LET lnode_gd02 = lnode_gp02.getFirstChild()
         LET lnode_gp03 = lwin_curr.findNode("Group","gp_flow03")
         LET lnode_gd03 = lnode_gp03.getFirstChild()
         IF (lnode_gp01.getChildCount() > 0) THEN
            CALL lnode_gp01.removeChild(lnode_gd01)
            LET lnode_gd01 = lnode_gp01.createChild("Grid")
         END IF
         IF (lnode_gp02.getChildCount() > 0) THEN
            CALL lnode_gp02.removeChild(lnode_gd02)
            LET lnode_gd02 = lnode_gp02.createChild("Grid")
         END IF
         IF (lnode_gp03.getChildCount() > 0) THEN
            CALL lnode_gp03.removeChild(lnode_gd03)
            LET lnode_gd03 = lnode_gp03.createChild("Grid")
         END IF
         LET li_dir_layer = "1"
         LET ls_sub_menu = ""
         LET g_action_choice = "" 
      END IF
      LET g_action_choice = ""
 
      MENU ""
         BEFORE MENU
            # 2004/05/06 by saki : 匯入動態流程圖
            SELECT COUNT(UNIQUE gbk02) INTO li_mdir_cnt FROM gbk_file
             WHERE gbk01 = g_gbk01 
 
            # 按第一層時將全部btn值重設
            IF li_dir_layer = 1 THEN
               CALL mr_btn.clear()
               LET li_btn_cnt = 1
               LET mr_btn[li_btn_cnt].btn_name = ""
               LET mr_btn[li_btn_cnt].chg_name = ""
            END IF
 
            CALL udmtree_flow_sheet_create_main_dir()
 
            # 在按第二層的時候, 把第三層的對應btn值刪除
            IF li_dir_layer = 2 THEN
               LET lnode_gp02 = lwin_curr.findNode("Group","gp_flow02")
               LET lnode_gd02 = lnode_gp02.getFirstChild()
               LET li_sdir_cnt = lnode_gd02.getChildCount()
              
               LET li_del_btn = li_mdir_cnt + li_sdir_cnt + 1 
               LET li_btn_tmp = mr_btn.getLength()
               FOR li_i = li_del_btn TO li_btn_tmp
                   CALL mr_btn.deleteElement(li_del_btn)
               END FOR
            END IF
               
            IF ls_sub_menu IS NOT NULL AND ls_sub_menu != "cmdrun" THEN
               CALL udmtree_flow_sheet_act_create(ls_sub_menu)
            END IF
 
            CALL udmtree_flow_btn_change()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()   #FUN-550037(smin)
            LET g_action_choice = "locale"
            EXIT MENU
 
         ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
         ON ACTION close
            LET g_action_choice = "exit"
            EXIT MENU
 
         # 2004/05/06 by saki : 動態流程所使用的button
         ON ACTION btn1
            CALL udmtree_flow_check_act_name("btn1") RETURNING ls_sub_menu,li_dir_layer 
	    IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn2
            CALL udmtree_flow_check_act_name("btn2") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn3
            CALL udmtree_flow_check_act_name("btn3") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn4
            CALL udmtree_flow_check_act_name("btn4") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn5
            CALL udmtree_flow_check_act_name("btn5") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn6
            CALL udmtree_flow_check_act_name("btn6") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn7
            CALL udmtree_flow_check_act_name("btn7") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn8
            CALL udmtree_flow_check_act_name("btn8") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn9
            CALL udmtree_flow_check_act_name("btn9") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn10
            CALL udmtree_flow_check_act_name("btn10") RETURNING ls_sub_menu,li_dir_layer 
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn11
            CALL udmtree_flow_check_act_name("btn11") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn12
            CALL udmtree_flow_check_act_name("btn12") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn13
            CALL udmtree_flow_check_act_name("btn13") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn14
            CALL udmtree_flow_check_act_name("btn14") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn15
            CALL udmtree_flow_check_act_name("btn15") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn16
            CALL udmtree_flow_check_act_name("btn16") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn17
            CALL udmtree_flow_check_act_name("btn17") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn18
            CALL udmtree_flow_check_act_name("btn18") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn19
            CALL udmtree_flow_check_act_name("btn19") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn20
            CALL udmtree_flow_check_act_name("btn20") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn21
            CALL udmtree_flow_check_act_name("btn21") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn22
            CALL udmtree_flow_check_act_name("btn22") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn23
            CALL udmtree_flow_check_act_name("btn23") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn24
            CALL udmtree_flow_check_act_name("btn24") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn25
            CALL udmtree_flow_check_act_name("btn25") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn26
            CALL udmtree_flow_check_act_name("btn26") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn27
            CALL udmtree_flow_check_act_name("btn27") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn28
            CALL udmtree_flow_check_act_name("btn28") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn29
            CALL udmtree_flow_check_act_name("btn29") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn30
            CALL udmtree_flow_check_act_name("btn30") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn31
            CALL udmtree_flow_check_act_name("btn31") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn32
            CALL udmtree_flow_check_act_name("btn32") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn33
            CALL udmtree_flow_check_act_name("btn33") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn34
            CALL udmtree_flow_check_act_name("btn34") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn35
            CALL udmtree_flow_check_act_name("btn35") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn36
            CALL udmtree_flow_check_act_name("btn36") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn37
            CALL udmtree_flow_check_act_name("btn37") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn38
            CALL udmtree_flow_check_act_name("btn38") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn39
            CALL udmtree_flow_check_act_name("btn39") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn40
            CALL udmtree_flow_check_act_name("btn40") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn41
            CALL udmtree_flow_check_act_name("btn41") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn42
            CALL udmtree_flow_check_act_name("btn42") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn43
            CALL udmtree_flow_check_act_name("btn43") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn44
            CALL udmtree_flow_check_act_name("btn44") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn45
            CALL udmtree_flow_check_act_name("btn45") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn46
            CALL udmtree_flow_check_act_name("btn46") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn47
            CALL udmtree_flow_check_act_name("btn47") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn48
            CALL udmtree_flow_check_act_name("btn48") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn49
            CALL udmtree_flow_check_act_name("btn49") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn50
            CALL udmtree_flow_check_act_name("btn50") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn51
            CALL udmtree_flow_check_act_name("btn51") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn52
            CALL udmtree_flow_check_act_name("btn52") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn53
            CALL udmtree_flow_check_act_name("btn53") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn54
            CALL udmtree_flow_check_act_name("btn54") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn55
            CALL udmtree_flow_check_act_name("btn55") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         #No.FUN-610052 --start-- 增加button數
         ON ACTION btn56
            CALL udmtree_flow_check_act_name("btn56") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn57
            CALL udmtree_flow_check_act_name("btn57") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn58
            CALL udmtree_flow_check_act_name("btn58") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn59
            CALL udmtree_flow_check_act_name("btn59") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn60
            CALL udmtree_flow_check_act_name("btn60") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn61
            CALL udmtree_flow_check_act_name("btn61") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn62
            CALL udmtree_flow_check_act_name("btn62") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn63
            CALL udmtree_flow_check_act_name("btn63") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn64
            CALL udmtree_flow_check_act_name("btn64") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         ON ACTION btn65
            CALL udmtree_flow_check_act_name("btn65") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT MENU
            END IF
         #No.FUN-610052 ---end---
     #TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE MENU
#TQC-860017 end
      END MENU
      IF g_action_choice = "exit" THEN
         EXIT WHILE
      END IF
   END WHILE
 
   CLOSE WINDOW p_preview_flow_w                       # 結束畫面
END FUNCTION
 
##################################################
# Description   : 建立流程圖主目錄
# Date & Author : 2004/05/06 by saki
# Parameter     : none
# Return        : void
# Memo          : 三個Group名稱分別是gp_flow1,gp_flow2,gp_flow3，必須與per檔對應
# Modify        :
##################################################
FUNCTION udmtree_flow_sheet_create_main_dir()
   DEFINE   ls_gbk03             LIKE gbk_file.gbk03
   DEFINE   ls_gbk05             LIKE gbk_file.gbk05
   DEFINE   ls_gbk02             LIKE gbk_file.gbk02
 
   DEFINE   lwin_curr            ui.Window,
            lfrm_curr            ui.Form
 
   DEFINE   lnode_win            om.DomNode
   DEFINE   lnode_gp01           om.DomNode
   DEFINE   lnode_gd01           om.DomNode
   DEFINE   lnode_btn            om.DomNode
 
   DEFINE   li_posY              LIKE type_file.num10   #FUN-680135 INTEGER 
   DEFINE   ls_create_main_dir   LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   li_cnt               LIKE type_file.num10   #FUN-680135 INTEGER 
 
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_win = lwin_curr.getNode()
   LET lnode_gp01 = lwin_curr.findNode("Group","gp_flow01")
   LET lnode_gd01 = lnode_gp01.getFirstChild()
 
   DECLARE lcurs_m_dir CURSOR FOR
                       SELECT UNIQUE gbk03,gbk05,gbk02 FROM gbk_file
                        WHERE gbk01 = g_gbk01 AND gbk04 = g_lang
                        ORDER by gbk02
 
   LET li_posY = 1
 
   FOREACH lcurs_m_dir INTO ls_gbk03,ls_gbk05,ls_gbk02
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
 
      IF (NOT ls_create_main_dir) THEN
         LET lnode_btn = lnode_gd01.createChild("Button")
         CALL lnode_btn.setAttribute("name",ls_gbk03 CLIPPED)
         CALL lnode_btn.setAttribute("text","   " || ls_gbk05 CLIPPED || "   ")
         CALL lnode_btn.setAttribute("gridWidth",20)
         LET li_posY = li_posY + 40
         CALL lnode_btn.setAttribute("posY",li_posY)
      END IF
 
      SELECT COUNT(*) INTO li_cnt FROM gbk_file
       WHERE gbk01 = ls_gbk03
      IF li_cnt > 0 THEN
         # 確認先前沒有置換過button的話, 將替換名存入 btn array
         CALL udmtree_flow_check_button_num(ls_gbk03 CLIPPED)
      END IF
 
   END FOREACH
   LET ls_create_main_dir = TRUE
END FUNCTION
 
##################################################
# Description   : 建立流程圖副目錄
# Date & Author : 2004/05/06 by saki
# Parameter     : ls_sub_dir  節點名稱
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION udmtree_flow_sheet_act_create(ls_sub_dir)
   DEFINE   ls_sub_dir     LIKE gbk_file.gbk01
 
   DEFINE   ls_gaz03       LIKE gaz_file.gaz03
 
   DEFINE   lr_gbk         DYNAMIC ARRAY OF RECORD
               gbk03       LIKE gbk_file.gbk03,
               gbk02       LIKE gbk_file.gbk02,
               gbk05       LIKE gbk_file.gbk05,
               gbk06       LIKE gbk_file.gbk06
                           END RECORD
   DEFINE   ls_clear       LIKE type_file.chr1    #FUN-680135 VARCHAR(1)
 
   DEFINE   li_i           LIKE type_file.num5    #FUN-680135 SMALLINT 
   DEFINE   li_j           LIKE type_file.num5    #FUN-680135 SMALLINT 
   DEFINE   li_cnt         LIKE type_file.num10,  #FUN-680135 INTEGER 
            li_cnt2        LIKE type_file.num10   #FUN-680135 INTEGER 
 
   DEFINE   lwin_curr      ui.Window,
            lfrm_curr      ui.Form
 
   DEFINE   lnode_win      om.DomNode
   DEFINE   lnode_gp02     om.DomNode
   DEFINE   lnode_gd02     om.DomNode
   DEFINE   lnode_gp03     om.DomNode
   DEFINE   lnode_gd03     om.DomNode
   DEFINE   lnode_btn      om.DomNode
   DEFINE   lnode_lab      om.DomNode
   DEFINE   lnode_item     om.DomNode
   DEFINE   ls_item_name   STRING
 
   DEFINE   li_posY        LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE   ls_count       LIKE type_file.num5    #FUN-680135 SMALLINT 
 
   DEFINE   lc_gbk06       LIKE gbk_file.gbk06
   DEFINE   lc_zz03        LIKE zz_file.zz03
   DEFINE   ls_prog_name   STRING
   DEFINE   ls_imgstr      STRING
   DEFINE   ls_node_name   STRING
   DEFINE   ls_sql         STRING
 
 
   LET ls_clear = ""
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_win = lwin_curr.getNode()
   LET lnode_gp02 = lwin_curr.findNode("Group","gp_flow02")
   LET lnode_gd02 = lnode_gp02.getFirstChild()
   LET lnode_gp03 = lwin_curr.findNode("Group","gp_flow03")
   LET lnode_gd03 = lnode_gp03.getFirstChild()
 
 
   # 若為主目錄則清除第二、三層目錄節點, 若為其他則刪除第三層節點
   SELECT COUNT(*) INTO li_cnt FROM gbk_file
    WHERE gbk01 = g_gbk01 AND gbk03 = ls_sub_dir AND gbk04 = g_lang
   IF li_cnt > 0 THEN
      LET ls_clear = "2"
   ELSE
      LET ls_clear = "3"
   END IF
 
   # 判斷目前在第幾層要clear哪幾層
   CASE ls_clear
      WHEN "2"
         IF (lnode_gp02.getChildCount() > 0) THEN
            CALL lnode_gp02.removeChild(lnode_gd02)
            LET lnode_gd02 = lnode_gp02.createChild("Grid")
         END IF
         IF (lnode_gp03.getChildCount() > 0) THEN
            CALL lnode_gp03.removeChild(lnode_gd03)
            LET lnode_gd03 = lnode_gp03.createChild("Grid")
         END IF
      WHEN "3"
         IF (lnode_gp03.getChildCount() > 0) THEN
            CALL lnode_gp03.removeChild(lnode_gd03)
            LET lnode_gd03 = lnode_gp03.createChild("Grid")
         END IF
      OTHERWISE
         MESSAGE "Directory structure error!"
   END CASE
   # 2004/05/20 by saki : 將button名稱全改為抓gbk05
   DECLARE lcurs_stack CURSOR FOR
                       SELECT UNIQUE gbk03,gbk02,gbk05,gbk06 FROM gbk_file
                        WHERE gbk01 = ls_sub_dir AND gbk04 = g_lang
                        ORDER BY gbk02
 
   LET li_i = 1
   FOREACH lcurs_stack INTO lr_gbk[li_i].*
      IF STATUS THEN
         EXIT FOREACH
      END IF
 
      LET li_i = li_i + 1
   END FOREACH
   CALL lr_gbk.deleteElement(li_i)
 
   LET li_posY = 1
 
   FOR li_j = 1 TO lr_gbk.getLength()
 
      SELECT COUNT(*) INTO ls_count FROM gbk_file
       WHERE gbk01 = lr_gbk[li_j].gbk03 AND gbk04 = g_lang
      IF (ls_count <= 0) THEN
         # 表示此節點以下沒有子節點(可能是分類點或是程式點)
         # 判斷是不是程式名稱
 
         SELECT COUNT(*) INTO li_cnt2 FROM gaz_file,zz_file
          WHERE gaz01 = lr_gbk[li_j].gbk03 AND gaz01 = zz01
         IF li_cnt2 > 0 THEN         # 程式點
 
            # 2004/05/14 by saki : 本來以p_zz的程式類別去分類，先改成以程式代碼第四碼作分別
            SELECT zz03 INTO lc_zz03 FROM zz_file
             WHERE zz01 = lr_gbk[li_j].gbk03
            LET ls_prog_name = lr_gbk[li_j].gbk03
            IF ls_prog_name.subString(1,1) != 'a' AND
               ls_prog_name.subString(1,1) != 'g' THEN
               LET lc_zz03 = 'i'
            ELSE
               LET lc_zz03 = ls_prog_name.subString(4,4)
            END IF
 
            # 確定程式資料無誤, 做最後一層button
            LET lnode_btn = lnode_gd03.createChild("Button")
            CALL lnode_btn.setAttribute("name",lr_gbk[li_j].gbk03 CLIPPED)
            CALL lnode_btn.setAttribute("text","   " || lr_gbk[li_j].gbk05 CLIPPED || "   ")
            CALL lnode_btn.setAttribute("gridWidth",20)
            LET li_posY = li_posY + 30
            CALL lnode_btn.setAttribute("posY",li_posY)
            IF lr_gbk[li_j].gbk06 IS NOT NULL THEN
               CALL lnode_btn.setAttribute("comment",lr_gbk[li_j].gbk06 CLIPPED)
            END IF
 
            LET ms_pic_url = FGL_GETENV("FGLASIP")
            CASE 
               WHEN (lc_zz03 = "I") OR (lc_zz03 = "i")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/I.png"
               WHEN (lc_zz03 = "T") OR (lc_zz03 = "t")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/T.png"
               WHEN (lc_zz03 = "P") OR (lc_zz03 = "p")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/P.png"
               WHEN (lc_zz03 = "R") OR (lc_zz03 = "r")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/R.png"
               WHEN (lc_zz03 = "Q") OR (lc_zz03 = "q")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/Q.png"
               WHEN (lc_zz03 = "S") OR (lc_zz03 = "s")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/S.png"
               WHEN (lc_zz03 = "U") OR (lc_zz03 = "u")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/U.png"
               OTHERWISE
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/T.png"
            END CASE
            CALL lnode_btn.setAttribute("image",ls_imgstr CLIPPED)
 
            # 確認先前沒有置換過button的話, 將替換名存入 btn array
            CALL udmtree_flow_check_button_num(lr_gbk[li_j].gbk03 CLIPPED)
 
            # 流程線製作
            LET li_posY = li_posY + 30
            LET lnode_lab = lnode_gd03.createChild("Label")
            CALL lnode_lab.setAttribute("text","|")
            CALL lnode_lab.setAttribute("posX",9)
            CALL lnode_lab.setAttribute("posY",li_posY)
            CONTINUE FOR
         ELSE                           # 流程中的敘述點或是沒有子節點的分類點
            LET ls_node_name = lr_gbk[li_j].gbk03
            IF ls_node_name.subString(1,5) = 'dummy' THEN       # 敘述點
               LET lnode_btn = lnode_gd03.createChild("Button")
               CALL lnode_btn.setAttribute("name",lr_gbk[li_j].gbk03 CLIPPED)
               CALL lnode_btn.setAttribute("text","   " || lr_gbk[li_j].gbk05 CLIPPED || "   ")
               CALL lnode_btn.setAttribute("gridWidth",20)
               LET li_posY = li_posY + 30
               CALL lnode_btn.setAttribute("posY",li_posY)
               IF lr_gbk[li_j].gbk06 IS NOT NULL THEN
                  CALL lnode_btn.setAttribute("comment",lr_gbk[li_j].gbk06 CLIPPED)
               END IF
 
               # 流程線製作
               LET li_posY = li_posY + 30
               LET lnode_lab = lnode_gd03.createChild("Label")
               CALL lnode_lab.setAttribute("text","|")
               CALL lnode_lab.setAttribute("posX",9)
               CALL lnode_lab.setAttribute("posY",li_posY)
               CONTINUE FOR
            ELSE                                 # 沒有子節點的節點
                IF ls_clear = "2" THEN            #No.MOD-560232
                  LET lnode_btn = lnode_gd02.createChild("Button")
                  CALL lnode_btn.setAttribute("name",lr_gbk[li_j].gbk03 CLIPPED)
                  CALL lnode_btn.setAttribute("text","   " || lr_gbk[li_j].gbk05 CLIPPED || "   ")
                  CALL lnode_btn.setAttribute("gridWidth",20)
                  LET li_posY = li_posY + 30
                  CALL lnode_btn.setAttribute("posY",li_posY)
               END IF
            END IF
         END IF
      ELSE
         # 做自己這層的button
         LET lnode_btn = lnode_gd02.createChild("Button")
         CALL lnode_btn.setAttribute("name",lr_gbk[li_j].gbk03 CLIPPED)
         CALL lnode_btn.setAttribute("text","   " || lr_gbk[li_j].gbk05 CLIPPED || "   ")
         CALL lnode_btn.setAttribute("gridWidth",20)
         LET li_posY = li_posY + 30
         CALL lnode_btn.setAttribute("posY",li_posY)
 
         # 確認先前沒有置換過button的話, 將替換名存入 btn array
         CALL udmtree_flow_check_button_num(lr_gbk[li_j].gbk03 CLIPPED)
      END IF
   END FOR
 
   # 最後若是流程線必須刪除
   IF (lnode_gd03.getChildCount() > 0) THEN
      LET lnode_item = lnode_gd03.getLastChild()
      LET ls_item_name = lnode_item.getTagName()
      IF (ls_item_name.equals("Label")) THEN
         CALL lnode_gd03.removeChild(lnode_item)
      END IF
   END IF
END FUNCTION
 
##################################################
# Description   : 將要替換btn的值存入暫存array
# Date & Author : 2004/05/06 by saki
# Parameter     : ps_chg_name  替換的name
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION udmtree_flow_check_button_num(ps_chg_name)
   DEFINE   ps_chg_name  STRING
 
   DEFINE   ls_btn_name  STRING
   DEFINE   ls_str_chg   STRING
   DEFINE   li_i         LIKE type_file.num10   #FUN-680135 INTEGER 
   DEFINE   ls_add_flag  LIKE type_file.num5    #FUN-680135 SMALLINT 
   DEFINE   li_btn_num   LIKE type_file.num10   #FUN-680135 INTEGER
 
 
   LET ls_add_flag = TRUE
   FOR li_i = 1 TO mr_btn.getLength()
       IF mr_btn[li_i].chg_name = ps_chg_name THEN
          LET ls_add_flag = FALSE
          EXIT FOR
       END IF
   END FOR
 
   IF ls_add_flag THEN
      IF mr_btn[1].btn_name IS NULL THEN
         LET li_btn_num = 1
         LET ls_str_chg = "1"
      ELSE
         LET li_btn_num = mr_btn.getLength() + 1
         LET ls_str_chg = mr_btn.getLength() + 1
      END IF
      LET ls_btn_name = "btn",ls_str_chg.trim()
      LET mr_btn[li_btn_num].btn_name = ls_btn_name
      LET mr_btn[li_btn_num].chg_name = ps_chg_name
   END IF
 
END FUNCTION
 
##################################################
# Description   : button name 替換
# Date & Author : 2004/05/06 by saki
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION udmtree_flow_btn_change()
   DEFINE   li_i           LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE   li_j           LIKE type_file.num10   #FUN-680135 INTEGER
 
   DEFINE   lnode_root     om.DomNode
   DEFINE   llst_items     om.NodeList
   DEFINE   lnode_item     om.DomNode
   DEFINE   ls_item_name   STRING
 
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_items = lnode_root.selectByTagName("MenuAction")
 
   FOR li_i = 1 TO mr_btn.getLength()
       FOR li_j = 1 TO llst_items.getLength()
           LET lnode_item = llst_items.item(li_j)
           LET ls_item_name = lnode_item.getAttribute("name")
           IF (ls_item_name.equals(mr_btn[li_i].btn_name)) THEN
                CALL lnode_item.setAttribute("name",mr_btn[li_i].chg_name CLIPPED)
                EXIT FOR
           END IF
       END FOR
   END FOR
END FUNCTION
 
##################################################
# Description   : 尋找Action名稱, 並判斷是不是程式名稱(最後一層)
# Date & Author : 2004/05/06 by saki
# Parameter     : ps_btn_name  節點名稱
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION udmtree_flow_check_act_name(ps_btn_name)
   DEFINE   ps_btn_name        LIKE type_file.chr20   #FUN-680135 VARCHAR(10)
   DEFINE   ls_dir_name        LIKE gbk_file.gbk03    #FUN-680135 VARCHAR(30) #No.FUN-610052
   DEFINE   li_dir_layer       LIKE type_file.num10   #FUN-680135 INTEGER 
   DEFINE   li_i               LIKE type_file.num10   #FUN-680135 INTEGER 
   DEFINE   li_cnt             LIKE type_file.num10   #FUN-680135 INTEGER 
   DEFINE   li_cnt2            LIKE type_file.num10   #FUN-680135 INTEGER 
 
   LET ls_dir_name = ""
   LET li_dir_layer = ""
 
   FOR li_i = 1 TO mr_btn.getLength()
       IF mr_btn[li_i].btn_name = ps_btn_name THEN
          LET ls_dir_name = mr_btn[li_i].chg_name
          EXIT FOR
       END IF
   END FOR
 
   # 判斷是不是程式名稱
   SELECT COUNT(*) INTO li_cnt FROM gaz_file,zz_file
    WHERE gaz01 = ls_dir_name AND gaz01 = zz01
   IF li_cnt > 0 THEN
      DISPLAY 'cmdrun:',ls_dir_name
      CALL cl_cmdrun(ls_dir_name CLIPPED)
      LET ls_dir_name = "cmdrun"
      LET li_dir_layer = 3
   END IF
 
   SELECT COUNT(*) INTO li_cnt2 FROM gbk_file
    WHERE gbk01 = g_gbk01 AND gbk03 = ls_dir_name
   IF li_cnt2 > 0 THEN
      LET li_dir_layer = 1
   END IF
 
   IF li_dir_layer IS NULL THEN
      LET li_dir_layer = 2
   END IF
 
   RETURN ls_dir_name,li_dir_layer
END FUNCTION
 
 #No.MOD-580056 --start
FUNCTION p_dy_flow_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gbk01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_dy_flow_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gbk01",FALSE)
   END IF
 
END FUNCTION
 
#NO.MOD-590329 MARK--------------------------
#FUNCTION p_dy_flow_set_entry_b1(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("gbk02_1,gbk04_1",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_dy_flow_set_no_entry_b1(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("gbk02_1,gbk04_1",FALSE)
#   END IF
#END FUNCTION
 
#FUNCTION p_dy_flow_set_entry_b2(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("gbk02_1,gbk04_2",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_dy_flow_set_no_entry_b2(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("gbk02_2,gbk04_2",FALSE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_dy_flow_set_entry_b3(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("gbk02_3,gbk04_3",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_dy_flow_set_no_entry_b3(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("gbk02_3,gbk04_3",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580056 --end
#NO.MOD-590329 MARK----------------------------
