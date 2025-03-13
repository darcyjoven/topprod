# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_zaa
# Descriptions...: 報表標題定位點維護程式
# Date & Author..: 04/12/02 Echo
# Modify.........: 05/02/17 coco add zaa11 report template
# Modify.........: No.MOD-540161 05/04/25 By Echo 複製功能判斷錯誤
# Modify.........: No.MOD-530271 05/05/24 By Echo p_zaa開窗,新增p_zaa報表備註(頁尾、表尾)功能。
# Modify.........: No.MOD-560086 05/06/14 By Echo 修改controlf欄位說明
# Modify.........: No.FUN-560079 05/06/17 By CoCo add Program Class(zaa17)
# Modyfy.........: No.FUN-580020 05/08/03 By Rosayu 加一欄位zaa18-->單行順序(紀錄2行以上的表頭拉成一行十的欄位呈現順序)
# Modify.........: NO.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: NO.FUN-580131 05/09/08 By Echo 1.p_zaa計算出此張報表的寬度:報表寬度(不含隱藏)預估
#                                                 2.欄位調換修改
# Modify.........: NO.TQC-590051 05/09/29 By CoCo if g_zaa_width = 0 LET g_zaa_width = 0 LET g_zaa_width=80
# Modify.........: NO.FUN-5A0203 05/10/28 By Echo p_zaa增加單身preview的功能
# Modify.........: NO.FUN-5A0205 05/10/20 By Echo 新增「建議報表列印格式」
# Modify.........: NO.FUN-610033 06/01/06 By Kevin 報表連查
# Modify.........: NO.FUN-630057 06/04/06 By Echo 程式有 Global 變數重覆定義的問題,將g_zaa改為g_zaa_a
# Modify.........: NO.FUN-650175 06/05/23 By Echo 修正程式邏輯判斷
# Modify.........: NO.FUN-650017 06/06/15 By Echo 新增「報表左邊界」欄位
# Modify.........: No.FUN-660081 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: NO.MOD-690024 06/09/06 By yoyo 當導入的資料zaa13,zaa16為null時，復制并新增一筆單身時，此筆單身zaa13,zaa16也為空
# Modify.........: No.FUN-6A0092 06/11/23 By bnlent  新增單頭折疊功能
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: NO.TQC-6B0188 06/12/12 By claire 新增時,欄位順序選擇為第二項時,以下欄位並沒有累加
# Modify.........: NO.FUN-6C0048 07/01/09 By ching-yuan 新增TOP MARGIN g_top_margin& BOTTOM MARGIN g_bottom_margin設定欄位
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"                     
# Modify.........: No.FUN-760029 07/06/13 By Smapmin 增加匯出Excel功能
# Modify.........: No.MOD-7B0261 07/06/13 By alexstar 程式名稱 refresh
# Modify.........: No.FUN-830021 08/03/06 By alex 移除gay02使用
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0004 09/11/02 By Carrier r.c2不过
# Modify.........: No.FUN-B50065 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zaa01                LIKE zaa_file.zaa01,   # 程式代碼
         g_zaa01_t              LIKE zaa_file.zaa01,   # 程式代碼
         g_gaz03                LIKE gaz_file.gaz03,   #No.FUN-680135 VARCHAR(36) # 程式名稱
         g_zaa04                LIKE zaa_file.zaa04,   # 程式代碼
         g_zaa04_t              LIKE zaa_file.zaa04,   # 程式代碼
         g_zaa_lock             RECORD LIKE zaa_file.*,
         g_zaa10                LIKE zaa_file.zaa10,   # 客製否
         g_zaa10_t              LIKE zaa_file.zaa10,   # 客製否
         g_zaa11                LIKE zaa_file.zaa11,   # Report Template
         g_zaa11_t              LIKE zaa_file.zaa11,   # Report Template
         g_zaa12                LIKE zaa_file.zaa12,   # Report Length
         g_zaa12_t              LIKE zaa_file.zaa12,   # Report Length
         g_zaa19                LIKE zaa_file.zaa19,   # Left Margin    #FUN-650017
         g_zaa19_t              LIKE zaa_file.zaa19,   # Left Margin    #FUN-650017
         g_zaa20                LIKE zaa_file.zaa20,   # Top Margin #No.FUN-6C0048
         g_zaa20_t              LIKE zaa_file.zaa20,   # Top Margin #No.FUN-6C0048
         g_zaa21                LIKE zaa_file.zaa21,   # Bottom Margin #No.FUN-6C0048
         g_zaa21_t              LIKE zaa_file.zaa21,   # Bottom Margin #No.FUN-6C0048
         g_zaa13                LIKE zaa_file.zaa13,   # Field Position Exchange
         g_zaa13_t              LIKE zaa_file.zaa13,   # Field Position Exchange
         g_zaa16                LIKE zaa_file.zaa16,   # 列印備註(簽核)
         g_zaa16_t              LIKE zaa_file.zaa16,   # 列印備註(簽核)
         g_zaa17                LIKE zaa_file.zaa17,   # 權限類別  FUN-560079
         g_zaa17_t              LIKE zaa_file.zaa17,   # 權限類別  FUN-560079
         g_zaa_a                DYNAMIC ARRAY of RECORD
            zaa09               LIKE zaa_file.zaa09,
            zaa02               LIKE zaa_file.zaa02,
            zaa03               LIKE zaa_file.zaa03,
            zaa14               LIKE zaa_file.zaa14,
            zaa05               LIKE zaa_file.zaa05,
            zaa06               LIKE zaa_file.zaa06,
            zaa15               LIKE zaa_file.zaa15,
            zaa07               LIKE zaa_file.zaa07,
            zaa18               LIKE zaa_file.zaa18,   #FUN-580020
            zad09               LIKE zad_file.zad09,   #FUN-610033
            zaa08               LIKE zaa_file.zaa08,
             memo                LIKE zab_file.zab05   #MOD-530271
                               END RECORD,
         g_zaa_t                RECORD                 # 變數舊值
            zaa09               LIKE zaa_file.zaa09,
            zaa02               LIKE zaa_file.zaa02,
            zaa03               LIKE zaa_file.zaa03,
            zaa14               LIKE zaa_file.zaa14,
            zaa05               LIKE zaa_file.zaa05,
            zaa06               LIKE zaa_file.zaa06,
            zaa15               LIKE zaa_file.zaa15,
            zaa07               LIKE zaa_file.zaa07,
            zaa18               LIKE zaa_file.zaa18,   #FUN-580020
            zad09               LIKE zad_file.zad09,   #FUN-610033
            zaa08               LIKE zaa_file.zaa08,
             memo               LIKE zab_file.zab05    #MOD-530271
                               END RECORD
DEFINE   g_cnt                 LIKE type_file.num10,   #No.FUN-680135 INTEGER
         g_cnt2                LIKE type_file.num10,   #No.FUN-680135 INTEGER
         g_wc                  string,                 #No.FUN-580092 HCN
         g_sql                 string,                 #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1) # 決定後續步驟
         g_rec_b               LIKE type_file.num5,    # 單身筆數     #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_row_count           LIKE type_file.num10,   #No.FUN-580092 HCN     #No.FUN-680135 INTEGER
         mi_curs_index         LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   mi_jump               LIKE type_file.num10,   #No.FUN-680135 INTEGER
         mi_no_ask             LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_n                   LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_zaa02               LIKE zaa_file.zaa02
DEFINE   g_zaa07_seq           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_zaa18_seq           LIKE type_file.num10    #No.FUN-680135 INTEGER #FUN580020
DEFINE   g_zaa01_zz            LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE   g_zaa_width           LIKE type_file.num10    #No.FUN-680135 INTEGER #FUN-580131
#FUN-5A0203
DEFINE   g_zaa_b               DYNAMIC ARRAY of RECORD
            zaa09              LIKE zaa_file.zaa09,
            zaa02              LIKE zaa_file.zaa02,
            zaa03              LIKE zaa_file.zaa03,
            zaa14              LIKE zaa_file.zaa14,
            zaa05              LIKE zaa_file.zaa05,
            zaa06              LIKE zaa_file.zaa06,
            zaa15              LIKE zaa_file.zaa15,
            zaa07              LIKE zaa_file.zaa07,
            zaa18              LIKE zaa_file.zaa18,    #FUN-580020
            zaa08              LIKE zaa_file.zaa08,
            memo               LIKE zab_file.zab05     #MOD-530271
                               END RECORD
#END FUN-5A0203
#FUN-610033 start
DEFINE   g_zad        DYNAMIC ARRAY of RECORD
           zad08               LIKE zad_file.zad08,
           zad09               LIKE zad_file.zad09,
           zad10               LIKE zad_file.zad10,
            memo               LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(255)
           zad11               LIKE zad_file.zad11
                      END RECORD
DEFINE   g_zad_t      RECORD
           zad08               LIKE zad_file.zad08,
           zad09               LIKE zad_file.zad09,
           zad10               LIKE zad_file.zad10,
            memo               LIKE type_file.chr1000, #No.FUN-680135 VARCHAR(255)
           zad11               LIKE zad_file.zad11
                      END RECORD
DEFINE   g_zaa_ac              LIKE type_file.num10,   # 目前zaa的row指標 #No.FUN-680135 INTEGER
         g_zad_b               LIKE type_file.num5,    # zad單身筆數  #No.FUN-680135 SMALLINT
         g_row_count_zad       LIKE type_file.num5,    #No.FUN-680135 SMALLINT
         g_zad10_err           LIKE type_file.num5     #No.FUN-680135 SMALLINT
#FUN-610033 end
 
MAIN
   DEFINE   p_row,p_col        LIKE type_file.num5     #No.FUN-680135 SMALLINT
#     DEFINE   l_time   LIKE type_file.chr8                 #No.FUN-6A0096
 
   OPTIONS                                             # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                                  # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET g_zaa01_t = NULL
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW p_zaa_w AT p_row,p_col WITH FORM "azz/42f/p_zaa"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_set_combo_lang("zaa03")
 
   LET g_forupd_sql = "SELECT * from zaa_file  WHERE zaa01 = ? ",
                      " AND zaa04 = ? AND zaa10 = ? AND zaa11 = ? AND zaa17 = ? ",  ## FUN-560079 ##
                      " FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zaa_cl CURSOR FROM g_forupd_sql
 
   CALL p_zaa_menu()
 
   CLOSE WINDOW p_zaa_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_zaa_curs()                         # QBE 查詢資料
 
   CLEAR FORM                                    # 清除畫面
   CALL g_zaa_a.clear()
   CALL cl_set_head_visible("grid01","YES")   #No.FUN-6A0092
   #CONSTRUCT g_wc ON zaa01,zaa04,zaa17,zaa11,zaa12,zaa10,zaa13,zaa16,zaawidth,zaa09,zaa02,    #MOD-530271  #FUN-5A0203
   #                 zaa03,zaa14,zaa05,zaa06,zaa15,zaa07,zaa18,zaa08                           #FUN-580020
   #    FROM zaa01,zaa04,zaa17,zaa11,zaa12,zaa10,zaa13,zaa16,zaawidth,s_zaa[1].zaa09,s_zaa[1].zaa02, #FUN-560079 #FUN-5A0203
   #         s_zaa[1].zaa03,s_zaa[1].zaa14,s_zaa[1].zaa05,s_zaa[1].zaa06,s_zaa[1].zaa15,
   #         s_zaa[1].zaa07,s_zaa[1].zaa18,s_zaa[1].zaa08                                      #FUN-580020
    CONSTRUCT g_wc ON zaa01,zaa04,zaa17,zaa11,zaa12,zaa19,zaa20,zaa21,zaa10,zaa13,zaa16,zaa09,zaa02,       #MOD-530271    #FUN-650017 #No.FUN-6C0048
                     zaa03,zaa14,zaa05,zaa06,zaa15,zaa07,zaa18,zaa08                           #FUN-580020
        FROM zaa01,zaa04,zaa17,zaa11,zaa12,zaa19,zaa20,zaa21,zaa10,zaa13,zaa16,s_zaa[1].zaa09,s_zaa[1].zaa02, #FUN-560079 #FUN-650017 #No.FUN-6C0048
             s_zaa[1].zaa03,s_zaa[1].zaa14,s_zaa[1].zaa05,s_zaa[1].zaa06,s_zaa[1].zaa15,
             s_zaa[1].zaa07,s_zaa[1].zaa18,s_zaa[1].zaa08                                      #FUN-580020
 
        BEFORE FIELD zaa08
                CALL cl_set_action_active("controlp", FALSE)
 
        AFTER FIELD zaa08
               CALL cl_set_action_active("controlp", TRUE)
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(zaa01)                     #MOD-530267
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zz"
                  LET g_qryparam.arg1 =  g_lang
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1= g_zaa01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zaa01
                  NEXT FIELD zaa01
 
               WHEN INFIELD(zaa04)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_zx"          #No.MOD-530271
                  LET g_qryparam.default1 = g_zaa04
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zaa04
                  NEXT FIELD zaa04
 
               WHEN INFIELD(zaa17)                      ##FUN-560079##
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zw"
                  LET g_qryparam.default1 = g_zaa17
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO zaa17
                  NEXT FIELD zaa17
 
            OTHERWISE
               EXIT CASE
         END CASE
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
    display g_wc
    LET g_sql= "SELECT UNIQUE zaa01,zaa04,zaa10,zaa11,zaa17,zaa12,zaa13,zaa16,zaa19,zaa20,zaa21 FROM zaa_file ",  #MOD-530271 FUN-560079 #FUN-650017 #No.FUN-6C0048
              " WHERE ", g_wc CLIPPED,
              " ORDER BY zaa01"
 
   PREPARE p_zaa_prepare FROM g_sql          # 預備一下
   DECLARE p_zaa_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_zaa_prepare
 
END FUNCTION
 
FUNCTION p_zaa_count()
 
    LET g_sql= "SELECT UNIQUE zaa01,zaa04,zaa10,zaa11,zaa17,zaa12,zaa13,zaa16,zaa19,zaa20,zaa21 FROM zaa_file ",   #MOD-530271 FUN-560079 #FUN-650017
              " WHERE ", g_wc CLIPPED,
              " ORDER BY zaa01"
 
   PREPARE p_zaa_precount FROM g_sql
   DECLARE p_zaa_count CURSOR FOR p_zaa_precount
   LET g_cnt=1
   LET g_rec_b=0
   FOREACH p_zaa_count
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET g_rec_b = g_rec_b - 1
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
    END FOREACH
     LET g_row_count=g_rec_b #No.FUN-580092 HCN
END FUNCTION
 
FUNCTION p_zaa_menu()
 
   WHILE TRUE
      CALL p_zaa_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_zaa_a()
            END IF
 
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_zaa_copy()
            END IF
 
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_zaa_r()
            END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_zaa_q()
            ELSE
               LET mi_curs_index = 0
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_zaa_b()
               CALL p_zaa_width()              #計算報表寬度  #FUN-580131
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL p_zaa_u()
            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         WHEN "seq_afresh"                      #重排欄位順序
            IF cl_chk_act_auth() THEN
               CALL zaa_seq_afresh()
            END IF
 
         WHEN "sug_print"                       #建議報表列印寬度　#FUN-5A0205
            IF cl_chk_act_auth() THEN
                CALL cl_cmdrun_wait("p_suggzaa")
            END IF
 
         #-----FUN-760029---------
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_zaa_a),'','')
            END IF
         #-----END FUN-760029-----
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_zaa_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_zaa_a.clear()
 
   # 預設值及將數值類變數清成零
   LET g_zaa01_t = NULL
   LET g_zaa04_t = NULL
   LET g_zaa11_t = NULL
   LET g_zaa10_t = NULL
    LET g_zaa17_t = NULL                            #MOD-530271
   LET g_zaa12_t = NULL
   LET g_zaa13_t = NULL
   LET g_zaa16_t = NULL
   LET g_zaa19_t = NULL                            #FUN-650017
   LET g_zaa20_t = NULL                            #No.FUN-6C0048
   LET g_zaa21_t = NULL                            #No.FUN-6C0048 
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_zaa04=g_user
     #LET g_zaa17=g_clas                           #MOD-530271
      LET g_zaa17='default'                        #MOD-530271 #FUN-650175
      LET g_zaa10="N"
      LET g_zaa12=66
      LET g_zaa13="Y"
      LET g_zaa16="N"                              #MOD-530271
      LEt g_zaa19=0                                #FUN-650017
      LET g_zaa20=1                                #No.FUN-6C0048
      LET g_zaa21=5                                #No.FUN-6C0048
      CALL p_zaa_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         CLEAR FORM                                # 清單頭
         CALL g_zaa_a.clear()                        # 清單身
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_zaa_a.clear()
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_zaa_a.clear()
      ELSE
         CALL p_zaa_b_fill('1=1')             # 單身
      END IF
 
      CALL p_zaa_b()                          # 輸入單身
      LET g_zaa01_t=g_zaa01
      LET g_zaa10_t=g_zaa10
      LET g_zaa11_t=g_zaa11
      LET g_zaa12_t=g_zaa12
      LET g_zaa17_t=g_zaa17
      LET g_zaa19_t=g_zaa19                   #FUN-650017
      LET g_zaa20_t=g_zaa20                   #No.FUN-6C0048
      LET g_zaa21_t=g_zaa21                   #No.FUN-6C0048
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION p_zaa_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_zaa01) OR cl_null(g_zaa04) OR cl_null(g_zaa10) OR
      cl_null(g_zaa11) OR cl_null(g_zaa17) THEN  ##FUN-560079
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_zaa01_t = g_zaa01
   LET g_zaa04_t = g_zaa04
   LET g_zaa10_t = g_zaa10
   LET g_zaa11_t = g_zaa11
   LET g_zaa17_t = g_zaa17            #FUN-560079
   LET g_zaa12_t = g_zaa12
   LET g_zaa13_t = g_zaa13
   LET g_zaa16_t = g_zaa16            #MOD-530271
   LET g_zaa19_t = g_zaa19            #FUN-650017
   LET g_zaa20_t = g_zaa20            #No.FUN-6C0048
   LET g_zaa21_t = g_zaa21            #No.FUN-6C0048 
 
   BEGIN WORK
   OPEN p_zaa_cl USING g_zaa01,g_zaa04,g_zaa10,g_zaa11,g_zaa17   #FUN-560079
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_zaa_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_zaa_cl INTO g_zaa_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("zaa01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_zaa_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL p_zaa_i("u")
      IF INT_FLAG THEN
         LET g_zaa01 = g_zaa01_t
         LET g_zaa04 = g_zaa04_t
         LET g_zaa10 = g_zaa10_t
         LET g_zaa11 = g_zaa11_t
         LET g_zaa17 = g_zaa17_t        #FUN-560079
         LET g_zaa12 = g_zaa12_t
         LET g_zaa13 = g_zaa13_t
         LET g_zaa16 = g_zaa16_t        #MOD-530271
         LET g_zaa19 = g_zaa19_t        #FUN-650017
         LET g_zaa20 = g_zaa20_t        #FUN-6C0048
         LET g_zaa21 = g_zaa21_t        #FUN-6C0048
         DISPLAY g_zaa01,g_zaa04,g_zaa10,g_zaa11,g_zaa17,g_zaa12,g_zaa13,g_zaa16,g_zaa19,g_zaa20,g_zaa21    #MOD-530271 #FUN-560079  #FUN-650017 #No.FUN-6C0048
              TO zaa01,zaa04,zaa10,zaa11,zaa17,zaa12,zaa13,zaa16,zaa19,zaa20,zaa21     #FUN-6C0048
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE zaa_file SET zaa01 = g_zaa01, zaa04 = g_zaa04, zaa10 = g_zaa10,
                          zaa11 = g_zaa11, zaa12 = g_zaa12, zaa13 = g_zaa13,
                          zaa16 = g_zaa16, zaa17 = g_zaa17, zaa19 = g_zaa19, #MOD-530271 #FUN-560079  #FUN-650017
                          zaa20 = g_zaa20, zaa21 = g_zaa21                   #FUN-6C0048
       WHERE zaa01 = g_zaa01_t AND zaa04 = g_zaa04_t AND zaa10 = g_zaa10_t
             AND zaa11 = g_zaa11_t  AND zaa17 = g_zaa17_t     #FUN-560079
 
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_zaa01,SQLCA.sqlcode,0)   #No.FUN-660081
         CALL cl_err3("upd","zaa_file",g_zaa01_t,g_zaa04_t,SQLCA.sqlcode,"","",0)    #No.FUN-660081
         CONTINUE WHILE
      END IF
      OPEN p_zaa_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
      LET mi_jump = mi_curs_index
      LET mi_no_ask = TRUE
      CALL p_zaa_fetch('/')
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION p_zaa_i(p_cmd)                       # 處理INPUT
   DEFINE   p_cmd      LIKE type_file.chr1    # a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
   DEFINE   l_zwacti   LIKE zw_file.zwacti    #FUN-650175
 
   LET g_ss = 'N'
   DISPLAY g_zaa01 TO zaa01
    CALL cl_set_head_visible("grid01","YES")   #No.FUN-6A0092
    INPUT g_zaa01,g_zaa04,g_zaa17,g_zaa11,g_zaa12,g_zaa19,g_zaa20,g_zaa21,g_zaa10,g_zaa13,g_zaa16 WITHOUT DEFAULTS # #MOD-530271 #No.FUN-6C0048
    FROM zaa01,zaa04,zaa17,zaa11,zaa12,zaa19,zaa20,zaa21,zaa10,zaa13,zaa16  #FUN-560079 #FUN-650017 #No.FUN-6C0048
 
      BEFORE INPUT   #FUN-560079
    #NO.MOD-580056------
         LET g_before_input_done = FALSE
         CALL p_zaa_set_entry(p_cmd)
         CALL p_zaa_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
   #--------END
 
         IF p_cmd = 'u' THEN
            IF g_zaa04 = 'default' THEN
               IF g_zaa17 <> 'default' THEN
                  CALL cl_set_comp_entry("zaa17",TRUE)
                  CALL cl_set_comp_entry("zaa04",FALSE)
               ELSE
                  CALL cl_set_comp_entry("zaa17",TRUE)
                  CALL cl_set_comp_entry("zaa04",TRUE)
               END IF
            ELSE
               IF g_zaa17 = 'default' THEN
                  CALL cl_set_comp_entry("zaa04",TRUE)
                  CALL cl_set_comp_entry("zaa17",FALSE)
               END IF
            END IF
         END IF
 
      AFTER FIELD zaa01
         IF NOT cl_null(g_zaa01) THEN
            IF g_zaa01 != g_zaa01_t OR cl_null(g_zaa01_t) THEN
               CALL p_zaa_chkzaa01()
               IF g_zaa01_zz = "N" THEN
                      CALL cl_err(g_zaa01,'azz-052',1)
                      IF p_cmd = 'u' THEN
                           LET g_zaa04 = g_zaa04_t
                      END IF
                      NEXT FIELD zaa04
               END IF
               CALL p_zaa_desc()
 
               LET g_cnt = 0
              SELECT COUNT(*) INTO g_cnt FROM zaa_file
               WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04
               AND zaa10 = g_zaa10 AND zaa11=g_zaa11 AND zaa17=g_zaa17  #FUN-560079
               IF g_cnt >  0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                     CALL p_zaa_desc()
                  ELSE
                     NEXT FIELD zaa01
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_zaa01,g_errno,0)
                  NEXT FIELD zaa01
               END IF
            END IF
            SELECT COUNT(*) INTO g_cnt2 FROM zaa_file
             WHERE zaa01 = g_zaa01 AND zaa11 <> 'voucher'
            SELECT COUNT(*) INTO g_cnt FROM zaa_file
             WHERE zaa01 = g_zaa01 AND zaa11='voucher'
            IF g_cnt2 > 0 OR g_cnt > 0 THEN
                IF g_cnt > 0 THEN
                     LET g_zaa11 = 'voucher'
                     DISPLAY g_zaa11 TO zaa11
                END IF
                IF g_cnt = 0 AND g_zaa11 = 'voucher' THEN
                     LET g_zaa11 = ''
                     display g_zaa11 TO zaa11
                END IF
            END IF
         END IF
 
     BEFORE FIELD zaa04
        CALL p_zaa_set_entry(p_cmd)
 
     AFTER FIELD zaa04
         IF NOT cl_null(g_zaa04) THEN
            IF g_zaa04 != g_zaa04_t OR cl_null(g_zaa04_t) THEN
               IF g_zaa04_t CLIPPED = "default" and g_zaa17_t CLIPPED = "default" THEN #FUN-560079
                  SELECT COUNT(UNIQUE zaa04) INTO g_cnt FROM zaa_file
                   WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04_t AND zaa10 = g_zaa10_t   #FUN-650175
                     AND zaa11 <> g_zaa11_t  AND zaa17 = g_zaa17_t       #FUN-560079
                     IF g_cnt = 0 THEN
                        CALL cl_err(g_zaa04,'azz-086',0)
                        LET g_zaa04 = g_zaa04_t
                        NEXT FIELD zaa04
                     END IF
               END IF
            #FUN-650175
            IF g_zaa04 CLIPPED  <> 'default' THEN
               SELECT COUNT(*) INTO g_cnt FROM zx_file
                WHERE zx01 = g_zaa04
               IF g_cnt = 0 THEN
                   CALL cl_err(g_zaa04,'mfg1312',0)
                   NEXT FIELD zaa04
               END IF
            END IF
            IF g_zaa04 = 'default' THEN
               IF g_zaa17 <> 'default' THEN
                  CALL cl_set_comp_entry("zaa17",TRUE)
                  CALL cl_set_comp_entry("zaa04",FALSE)
               ELSE
                  CALL cl_set_comp_entry("zaa17",TRUE)
                  CALL cl_set_comp_entry("zaa04",TRUE)
               END IF
            ELSE
               IF g_zaa17 = 'default' THEN
                  CALL cl_set_comp_entry("zaa04",TRUE)
                  CALL cl_set_comp_entry("zaa17",FALSE)
               END IF
            END IF
            #END FUN-650175
##因為有多個key值,所以key值重複的check in AFTER INPUT
#               LET g_cnt = 0
#               SELECT COUNT(UNIQUE zaa04) INTO g_cnt FROM zaa_file
#                WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04 AND zaa10 = g_zaa10
#                      AND zaa11 = g_zaa11
 
#               IF g_cnt > 0 THEN
#                     CALL cl_err(g_zaa04,-239,0)
#                     LET g_zaa04 = g_zaa04_t
#                     NEXT FIELD zaa04
#               END IF
            END IF
         END IF
         CALL p_zaa_set_no_entry(p_cmd)
 
     AFTER FIELD zaa10
         LET g_cnt = 0
         IF g_zaa11 != g_zaa11_t OR cl_null(g_zaa11_t) THEN
 
            SELECT COUNT(*) INTO g_cnt FROM zaa_file
             WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04
               AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
               AND zaa17 = g_zaa17                      #FUN-560079
            IF g_cnt >  0 THEN
               CALL cl_err(" ",-239,1)
               NEXT FIELD zaa10
            END IF
         END IF
 
     BEFORE FIELD zaa11
         SELECT COUNT(*) INTO g_cnt2 FROM zaa_file
          WHERE zaa01 = g_zaa01 AND zaa11 <> 'voucher'
         SELECT COUNT(*) INTO g_cnt FROM zaa_file
          WHERE zaa01 = g_zaa01 AND zaa11='voucher'
         IF g_cnt2 > 0 OR g_cnt > 0 THEN
            IF g_zaa11 = 'voucher' THEN
                 CALL zaa_set_no_entry()
            END IF
         END IF
 
     AFTER FIELD zaa11
         IF NOT cl_null(g_zaa11) THEN
            IF g_zaa11 != g_zaa11_t OR cl_null(g_zaa11_t) THEN
               LET g_cnt = 0
               SELECT COUNT(UNIQUE zaa11) INTO g_cnt FROM zaa_file
                WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04
                  AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                  AND zaa17 = g_zaa17 #FUN-560079
               IF g_cnt > 0 THEN
                     CALL cl_err(g_zaa11,-239,0)
                     LET g_zaa11 = g_zaa11_t
                     NEXT FIELD zaa11
               END IF
            END IF
               IF g_zaa11 = 'voucher' THEN
                  SELECT COUNT(*) INTO g_cnt FROM zaa_file
                   WHERE zaa01 = g_zaa01 AND zaa11<>'voucher'
                  IF g_cnt > 0 THEN
                       CALL cl_err(g_zaa01,'azz-078',0)
                       IF p_cmd = 'a' THEN
                          LET g_zaa11 = ''
                       ELSE
                          LET g_zaa11 = g_zaa11_t
                       END IF
                       NEXT FIELD zaa11
                  ELSE
                       CALL zaa_set_entry()
                  END IF
               END IF
         END IF
 
     BEFORE FIELD zaa17        #FUN-560079
         CALL p_zaa_set_entry(p_cmd)
 
     AFTER FIELD zaa17         #FUN-560079
         IF NOT cl_null(g_zaa17) THEN
            IF g_zaa17 != g_zaa17_t OR cl_null(g_zaa17_t) THEN
               IF g_zaa04_t CLIPPED = "default" and g_zaa17_t CLIPPED = "default" THEN #FUN-560079
                  SELECT COUNT(UNIQUE zaa17) INTO g_cnt FROM zaa_file
                   WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04_t AND zaa10 = g_zaa10_t
                     AND zaa11 <> g_zaa11_t AND zaa17 = g_zaa17_t
                  IF g_cnt = 0 THEN
                     CALL cl_err(g_zaa17,'azz-086',0)
                     LET g_zaa17 = g_zaa17_t
                     NEXT FIELD zaa17
                  END IF
               END IF
            END IF
            #FUN-650175
            IF g_zaa17 CLIPPED  <> 'default' THEN
               SELECT zwacti INTO l_zwacti FROM zw_file
                WHERE zw01 = g_zaa17
               IF STATUS THEN
#                  CALL cl_err('select '||g_zaa17||" ",STATUS,0)   #No.FUN-660081
                   CALL cl_err3("sel","zw_file",g_zaa17,"",STATUS,"","SELECT "|| g_zaa17,0)    #No.FUN-660081
                   NEXT FIELD zaa17
               ELSE
                  IF l_zwacti != "Y" THEN   #MOD-560212
                     CALL cl_err_msg(NULL,"azz-218",g_zaa17 CLIPPED,10)
                     NEXT FIELD zaa17
                  END IF
               END IF
            END IF
            #END FUN-650175
         END IF
         CALL p_zaa_set_no_entry(p_cmd)
         #FUN-650175
         IF g_zaa17 = 'default' THEN
            IF g_zaa04 <> 'default' THEN
               CALL cl_set_comp_entry("zaa04",TRUE)
               CALL cl_set_comp_entry("zaa17",FALSE)
            ELSE
               CALL cl_set_comp_entry("zaa17",TRUE)
               CALL cl_set_comp_entry("zaa04",TRUE)
            END IF
         ELSE
            IF g_zaa04 = 'default' THEN
               CALL cl_set_comp_entry("zaa17",TRUE)
               CALL cl_set_comp_entry("zaa04",FALSE)
            END IF
         END IF
         #END FUN-650175
 
      AFTER FIELD zaa19                                 #FUN-650017
         IF g_zaa19 < 0 OR g_zaa19 IS NULL THEN
              NEXT FIELD zaa19
         END IF
      AFTER FIELD zaa20                                 #FUN-6C0048
         IF g_zaa20 < 0 OR g_zaa20 IS NULL THEN
              NEXT FIELD zaa20
         END IF
      AFTER FIELD zaa21                                 #FUN-6C0048
         IF g_zaa21 < 0 OR g_zaa21 IS NULL THEN
              NEXT FIELD zaa21
         END IF
      AFTER INPUT
           IF INT_FLAG THEN                            # 使用者不玩了
               EXIT INPUT
           END IF
           IF (p_cmd = 'a') THEN
             SELECT COUNT(*) INTO g_cnt FROM zaa_file
              WHERE zaa01 = g_zaa01 AND zaa04 = "default"
              AND zaa10 = g_zaa10
             IF g_cnt = 0 THEN
                IF (g_zaa04 <> "default")  THEN
                   CALL cl_err(g_zaa01,'azz-086',1)
                   LET g_zaa01 = g_zaa01_t
                   NEXT FIELD zaa01
                END IF
             END IF
             SELECT COUNT(*) INTO g_cnt FROM zaa_file
             WHERE zaa01=g_zaa01 AND zaa04 = g_zaa04
             AND zaa10=g_zaa10 AND zaa11 = g_zaa11 AND zaa17 = g_zaa17 #FUN-560079
             IF g_cnt > 0  THEN
               CALL cl_err(g_zaa01,-239,1)
               NEXT FIELD zaa01
             END IF
           ELSE
               IF g_zaa01_t <> g_zaa01 OR g_zaa04_t <> g_zaa04 OR
                  g_zaa10_t <> g_zaa10 OR g_zaa11_t <> g_zaa11 
               THEN
                  IF g_zaa04_t = "default" THEN
                    IF g_zaa01_t <> g_zaa01 OR g_zaa04_t <> g_zaa04 OR
                       g_zaa10_t <> g_zaa10 OR g_zaa11_t <> g_zaa11  THEN
 
                          SELECT COUNT(*) INTO g_cnt FROM zaa_file
                          WHERE zaa01=g_zaa01_t AND zaa04 <> "default"
                          AND zaa10=g_zaa10
 
                          SELECT COUNT(*) INTO g_cnt2 FROM zaa_file
                          WHERE zaa01=g_zaa01_t AND zaa04 = "default"
                          AND zaa10=g_zaa10 AND zaa11 <> g_zaa11
 
                          IF g_cnt > 0 AND g_cnt2 = 0 THEN
                            CALL cl_err(g_zaa01_t,'azz-086',1)
                            NEXT FIELD zaa01
                          ELSE IF g_zaa04_t <> g_zaa04 AND g_cnt2 = 0 THEN
                            CALL cl_err(g_zaa01_t,'azz-086',1)
                            NEXT FIELD zaa04
                          END IF
                          END IF
                          SELECT COUNT(*) INTO g_cnt FROM zaa_file
                          WHERE zaa01=g_zaa01 AND zaa04 = g_zaa04
                          AND zaa10=g_zaa10 AND zaa11 = g_zaa11
                          IF g_cnt > 0  THEN
                            CALL cl_err(g_zaa01,-239,1)
                            NEXT FIELD zaa01
                          END IF
                          IF g_zaa04 <> "default" THEN
                            SELECT COUNT(*) INTO g_cnt FROM zaa_file
                            WHERE zaa01=g_zaa01 AND zaa04 = "default"
                              AND zaa10=g_zaa10
                            IF g_cnt = 0  THEN
                               CALL cl_err(g_zaa01,'azz-086',1)
                               NEXT FIELD zaa01
                            END IF
                          END IF
                     END IF
                  ELSE
                    IF g_zaa01_t <> g_zaa01 OR g_zaa04_t <> g_zaa04 OR
                       g_zaa10_t <> g_zaa10 OR g_zaa11_t <> g_zaa11  THEN
                      SELECT COUNT(*) INTO g_cnt FROM zaa_file
                      WHERE zaa01 = g_zaa01 AND zaa04 = "default"
                      AND zaa10 = g_zaa10
                      IF g_cnt = 0 THEN
                           CALL cl_err(g_zaa01,'azz-086',1)
                           NEXT FIELD zaa01
                      END IF
                      SELECT COUNT(*) INTO g_cnt FROM zaa_file
                      WHERE zaa01=g_zaa01 AND zaa04 = g_zaa04
                      AND zaa10=g_zaa10 AND zaa11 = g_zaa11
                      AND zaa17 = g_zaa17                        #FUN-560079
                      IF g_cnt > 0  THEN
                        CALL cl_err(g_zaa01,-239,1)
                        NEXT FIELD zaa01
                      END IF
                    END IF
                  END IF
               END IF
            END IF
 
      ## No.MOD-530271
     ON ACTION controlp
         CASE
            WHEN INFIELD(zaa01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.arg1 =  g_lang
               LET g_qryparam.default1= g_zaa01
               CALL cl_create_qry() RETURNING g_zaa01
               DISPLAY g_zaa01 TO zaa01
               NEXT FIELD zaa01
 
            WHEN INFIELD(zaa04)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zx"          #MOD-530267
               LET g_qryparam.default1 = g_zaa04
               CALL cl_create_qry() RETURNING g_zaa04
               DISPLAY g_zaa04 TO zaa04
               NEXT FIELD zaa04
 
            WHEN INFIELD(zaa17)                      #FUN-560079
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zw"
               LET g_qryparam.default1 = g_zaa17
               CALL cl_create_qry() RETURNING g_zaa17
               DISPLAY g_zaa17 TO zaa17
               NEXT FIELD zaa17
 
            OTHERWISE
               EXIT CASE
         END CASE
       ## END No.MOD-530271
       ON ACTION CONTROLF                       #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
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
   CALL cl_set_comp_entry("zaa04,zaa17",TRUE)        #FUN-650175
 
END FUNCTION
 
FUNCTION p_zaa_q()                            #Query 查詢
    LET g_row_count = 0 #No.FUN-580092 HCN
   LET mi_curs_index = 0
    CALL cl_navigator_setting(mi_curs_index,g_row_count) #No.FUN-580092 HCN
   MESSAGE ""
  #CLEAR FROM   #No.TQC-740075
   CALL g_zaa_a.clear()
   DISPLAY '    ' TO FORMONLY.cnt
   CALL p_zaa_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_zaa_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_zaa01,g_gaz03 TO NULL
   ELSE
      CALL p_zaa_count()
       DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
      CALL p_zaa_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION p_zaa_fetch(p_flag)                #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1    #處理方式  #No.FUN-680135 VARCHAR(1)
 
   MESSAGE ""
   CASE p_flag
       #MOD-530271
      #No.FUN-6C0048 --start--
      WHEN 'N' FETCH NEXT     p_zaa_b_curs INTO g_zaa01,g_zaa04,g_zaa10,g_zaa11,g_zaa17,g_zaa12,g_zaa13,g_zaa16,g_zaa19,g_zaa20,g_zaa21 #FUN-560079 #FUN-650017
      WHEN 'P' FETCH PREVIOUS p_zaa_b_curs INTO g_zaa01,g_zaa04,g_zaa10,g_zaa11,g_zaa17,g_zaa12,g_zaa13,g_zaa16,g_zaa19,g_zaa20,g_zaa21
      WHEN 'F' FETCH FIRST    p_zaa_b_curs INTO g_zaa01,g_zaa04,g_zaa10,g_zaa11,g_zaa17,g_zaa12,g_zaa13,g_zaa16,g_zaa19,g_zaa20,g_zaa21
      WHEN 'L' FETCH LAST     p_zaa_b_curs INTO g_zaa01,g_zaa04,g_zaa10,g_zaa11,g_zaa17,g_zaa12,g_zaa13,g_zaa16,g_zaa19,g_zaa20,g_zaa21
      #No.FUN-6C0048 --end--
       #END MOD-530271
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR mi_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = FALSE
               RETURN
            END IF
         END IF
         FETCH ABSOLUTE mi_jump p_zaa_b_curs INTO g_zaa01,g_zaa04,g_zaa10,g_zaa11,g_zaa17,g_zaa12,g_zaa13,g_zaa16,g_zaa19,g_zaa20,g_zaa21 # FUN-560079 #No.FUN-6C0048
         LET mi_no_ask = FALSE
   END CASE
   INITIALIZE g_gaz03 TO NULL #MOD-7B0261
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_zaa01,SQLCA.sqlcode,0)
      LET g_zaa01 = NULL
      LET g_zaa04 = NULL
      LET g_zaa10 = NULL
      LET g_zaa11 = NULL
      LET g_zaa12 = NULL
      LET g_zaa13 = NULL
       LET g_zaa16 = NULL          #MOD-530271
      LET g_zaa17 = NULL          #FUN-560079
      LET g_zaa19 = NULL          #TQC-6B0105
      LET g_zaa20 = NULL          #TQC-6B0105
      LET g_zaa21 = NULL          #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET mi_curs_index = 1
         WHEN 'P' LET mi_curs_index = mi_curs_index - 1
         WHEN 'N' LET mi_curs_index = mi_curs_index + 1
          WHEN 'L' LET mi_curs_index = g_row_count #No.FUN-580092 HCN
         WHEN '/' LET mi_curs_index = mi_jump
      END CASE
 
       CALL cl_navigator_setting(mi_curs_index, g_row_count) #No.FUN-580092 HCN
      CALL p_zaa_show()
   END IF
END FUNCTION
 
FUNCTION p_zaa_show()                         # 將資料顯示在畫面上
   LET g_zaa01_t = g_zaa01
   LET g_zaa04_t = g_zaa04
   LET g_zaa10_t = g_zaa10
   LET g_zaa11_t = g_zaa11
   LET g_zaa12_t = g_zaa12
   LET g_zaa13_t = g_zaa13
   LET g_zaa16_t = g_zaa16          #MOD-530271
   LET g_zaa17_t = g_zaa17          #FUN-560079
   LET g_zaa19_t = g_zaa19          #FUN-650017
   LET g_zaa20_t = g_zaa20          #No.FUN-6C0048
   LET g_zaa21_t = g_zaa21          #No.FUN-6C0048
   DISPLAY g_zaa01 TO zaa01                    # 假單頭
   DISPLAY g_zaa04 TO zaa04                    # 假單頭
   DISPLAY g_zaa10 TO zaa10                    # 假單頭
   DISPLAY g_zaa11 TO zaa11                    # 假單頭
   DISPLAY g_zaa12 TO zaa12                    # 假單頭
   DISPLAY g_zaa13 TO zaa13                    # 假單頭
   DISPLAY g_zaa16 TO zaa16                    #MOD-530271
   DISPLAY g_zaa17 TO zaa17                    #FUN-560079
   DISPLAY g_zaa19 TO zaa19                    #FUN-650017
   DISPLAY g_zaa20 TO zaa20                    #No.FUN-6C0048
   DISPLAY g_zaa21 TO zaa21                    #No.FUN-6C0048
   CALL p_zaa_desc()
   CALL p_zaa_b_fill(g_wc)                    # 單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
FUNCTION p_zaa_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE  l_zaa    RECORD LIKE zaa_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zaa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN p_zaa_cl USING g_zaa01,g_zaa04,g_zaa10,g_zaa11,g_zaa17 #FUN-560079
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_zaa_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_zaa_cl INTO g_zaa_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("zaa01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_zaa_cl
      ROLLBACK WORK
      RETURN
   END IF
 
#   IF (g_zaa04 = "default") THEN
#      CALL cl_err(g_zaa04,'azz-033',1)
#   ELSE
    IF g_zaa04 = "default" and g_zaa17 = "default" THEN  #FUN-560079
       SELECT COUNT(*) INTO g_cnt FROM zaa_file
        WHERE zaa01 = g_zaa01 AND zaa10 = g_zaa10
          AND ((zaa04 <> "default" and zaa17 = "default") OR
               (zaa04 = "default" and zaa17 <> "default"))
 
       SELECT COUNT(*) INTO g_cnt2 FROM zaa_file
       WHERE zaa01 = g_zaa01 AND zaa10 = g_zaa10 AND zaa11 <> g_zaa11
         AND zaa04 = "default" AND zaa17 = "default"   #FUN-560079
 
      IF g_cnt > 0 AND g_cnt2 = 0 THEN
        CALL cl_err(g_zaa01,'azz-086',1)
        ROLLBACK WORK
        RETURN
      END IF
    END IF
    IF g_zaa04 = "default" and g_zaa17 = "default" THEN #FUN-560079
      IF cl_confirm("azz-077") THEN
         DELETE FROM zaa_file WHERE zaa01 = g_zaa01 AND zaa10 = g_zaa10 AND
                     zaa04 = g_zaa04 AND zaa11 = g_zaa11  AND zaa17 = g_zaa17 #FUN-560079
                 #  AND zaa12 = g_zaa12 AND zaa13 = g_zaa13
         IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660081
            CALL cl_err3("del","zaa_file",g_zaa01,g_zaa04,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         ELSE
            CLEAR FORM
            CALL g_zaa_a.clear()
            CALL p_zaa_count()
#FUN-B50065------begin---
            IF cl_null(g_row_count) OR g_row_count=0 THEN
               CLOSE p_zaa_cl
               COMMIT WORK  
               RETURN
            END IF
#FUN-B50065------end -----
             DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
            OPEN p_zaa_b_curs
             IF mi_curs_index = g_row_count + 1 THEN #No.FUN-580092 HCN
                LET mi_jump = g_row_count #No.FUN-580092 HCN
               CALL p_zaa_fetch('L')
            ELSE
               LET mi_jump = mi_curs_index
               LET mi_no_ask = TRUE
               CALL p_zaa_fetch('/')
            END IF
         END IF
      END IF
    ELSE
      IF cl_delh(0,0) THEN                   #確認一下
         DELETE FROM zaa_file WHERE zaa01 = g_zaa01 AND zaa10 = g_zaa10 AND
                     zaa04 = g_zaa04 AND zaa11 = g_zaa11 AND zaa17 = g_zaa17 #FUN-560079
         IF SQLCA.sqlcode THEN
#           CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660081
            CALL cl_err3("del","zaa_file",g_zaa01,g_zaa04,SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
         ELSE
            CLEAR FORM
            CALL g_zaa_a.clear()
            CALL p_zaa_count()
          
#FUN-B50065------begin---
            IF cl_null(g_row_count) OR g_row_count=0 THEN
               CLOSE p_zaa_cl
               COMMIT WORK
               RETURN
            END IF
#FUN-B50065------end -----
             DISPLAY g_row_count TO FORMONLY.cnt #No.FUN-580092 HCN
            OPEN p_zaa_b_curs
             IF mi_curs_index = g_row_count + 1 THEN #No.FUN-580092 HCN
                LET mi_jump = g_row_count #No.FUN-580092 HCN
               CALL p_zaa_fetch('L')
            ELSE
               LET mi_jump = mi_curs_index
               LET mi_no_ask = TRUE
               CALL p_zaa_fetch('/')
            END IF
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_zaa_b()                                 # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,   # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,   # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,   # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,   # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,   #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5    #No.FUN-680135      SMALLINT
   DEFINE k,i               LIKE type_file.num10   #No.FUN-680135      INTEGER
   DEFINE l_zaa02           LIKE zaa_file.zaa02
   DEFINE l_zaa07           LIKE zaa_file.zaa07
   DEFINE l_zab05           LIKE zab_file.zab05
   DEFINE l_num             LIKE type_file.num10   #No.FUN-680135      INTEGERE   # FUN-580020
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zaa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT zaa09,zaa02,zaa03,zaa14,zaa05,zaa06,zaa15,zaa07,zaa18,zaa08",
                     "  FROM zaa_file",
                     "  WHERE zaa01 = ? AND zaa02 = ? AND zaa03 = ? AND zaa04= ? AND zaa10= ? AND zaa11=? AND zaa17=?", #FUN-560079
                     "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zaa_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   CALL FGL_DIALOG_SETFIELDORDER(FALSE) #NO.FUN-610033
 
   INPUT ARRAY g_zaa_a WITHOUT DEFAULTS FROM s_zaa.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         CALL cl_set_action_active("controlp", FALSE)
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zaa_t.* = g_zaa_a[l_ac].*    #BACKUP
 #No.MOD-580056 --start
            LET g_before_input_done = FALSE
            CALL p_zaa_set_entry_b(p_cmd)
            CALL p_zaa_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 #No.MOD-580056 --end
 
            OPEN p_zaa_bcl USING g_zaa01,g_zaa_t.zaa02,g_zaa_t.zaa03,g_zaa04,g_zaa10,g_zaa11,g_zaa17 #FUN-560079
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_zaa_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_zaa_bcl INTO g_zaa_a[l_ac].zaa09,g_zaa_a[l_ac].zaa02,g_zaa_a[l_ac].zaa03,g_zaa_a[l_ac].zaa14,g_zaa_a[l_ac].zaa05,g_zaa_a[l_ac].zaa06,g_zaa_a[l_ac].zaa15,g_zaa_a[l_ac].zaa07,g_zaa_a[l_ac].zaa18,g_zaa_a[l_ac].zaa08
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zaa_t.zaa02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            IF g_zaa_a[l_ac].zaa09 = 1 THEN
               CALL zaa_set_no_entry()
            ELSE
               CALL zaa_set_entry()
            END IF
            #FUN-580020
            IF g_zaa_a[l_ac].zaa15 < 2 THEN
               LET l_num=0
               SELECT MAX(zaa15)INTO l_num FROM zaa_file WHERE
                  zaa01 = g_zaa01 AND zaa04 = g_zaa04 AND zaa10 = g_zaa10
                  AND zaa11 = g_zaa11 AND zaa17 = g_zaa17 AND zaa15 <> g_zaa_t.zaa15
               IF l_num > 1 THEN
                  CALL cl_set_comp_entry("zaa18",TRUE)
               ELSE
                  INITIALIZE g_zaa_a[l_ac].zaa18 TO NULL
                  CALL cl_set_comp_entry("zaa18",FALSE)
               END IF
            ELSE
               CALL cl_set_comp_entry("zaa18",TRUE)
            END IF
 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
 
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zaa_a[l_ac].* TO NULL       #900423
         LET g_zaa_t.* = g_zaa_a[l_ac].*          #新輸入資料
         LET g_zaa_a[l_ac].zaa06='N'
          LET g_zaa_a[l_ac].zaa14='G'               #MOD-530271
 #No.MOD-580056 --start
         LET g_before_input_done = FALSE
         CALL p_zaa_set_entry_b(p_cmd)
         CALL p_zaa_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
 #No.MOD-580056 --end
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD zaa09
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF (g_zaa_a[l_ac].zaa05 IS NULL) AND (g_zaa_a[l_ac].zaa09='2') THEN #NO.FUN-610033
             NEXT FIELD zaa05
         END IF
 
         INSERT INTO zaa_file(zaa01,zaa02,zaa03,zaa04,zaa05,zaa06,zaa07,zaa08,
                               zaa09,zaa10,zaa11,zaa12,zaa13,zaa16,zaa17,zaa14,zaa15,zaa18,zaa19,zaa20,zaa21) #MOD-530271 #FUN-560079 #FUN-580020 #FUN-650017 #No.FUN-6C0048
             VALUES (g_zaa01,g_zaa_a[l_ac].zaa02,g_zaa_a[l_ac].zaa03,
                     g_zaa04,g_zaa_a[l_ac].zaa05,g_zaa_a[l_ac].zaa06,
                     g_zaa_a[l_ac].zaa07,g_zaa_a[l_ac].zaa08,g_zaa_a[l_ac].zaa09,g_zaa10,
                      g_zaa11,g_zaa12,g_zaa13,g_zaa16,g_zaa17,g_zaa_a[l_ac].zaa14,g_zaa_a[l_ac].zaa15,g_zaa_a[l_ac].zaa18,g_zaa19,g_zaa20,g_zaa21) #MOD-530271  #FUN-560079  #FUN-580020 #No.FUN-6C0048
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_zaa01,SQLCA.sqlcode,0)   #No.FUN-660081
            CALL cl_err3("ins","zaa_file",g_zaa01,g_zaa_a[l_ac].zaa02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
  {       LET g_zaa_t.zaa07 = g_zaa_a[l_ac].zaa07
         LET g_zaa_t.zaa15 = g_zaa_a[l_ac].zaa15
         LET g_zaa07_seq = g_zaa_t.zaa07
         FOR k = 1 to g_zaa_a.getLength()
             IF (k <> l_ac) AND g_zaa_a[k].zaa15 = g_zaa_t.zaa15 AND g_zaa_a[k].zaa07 >= g_zaa_t.zaa07 THEN
                 LET g_zaa07_seq = g_zaa07_seq + 1
                 LET g_zaa_a[k].zaa07 = g_zaa07_seq
                 UPDATE zaa_file SET zaa07 = g_zaa_a[k].zaa07
                   WHERE zaa01 = g_zaa01 AND zaa03 = g_zaa_t.zaa03
                   AND zaa04 = g_zaa04 AND zaa02 = g_zaa_a[k].zaa02
                   AND zaa10 = g_zaa10
             END IF
         END FOR
   }
      AFTER FIELD zaa09
         IF g_zaa_a[l_ac].zaa09 = 1 THEN
           CALL zaa_set_no_entry()
           INITIALIZE g_zaa_a[l_ac].zaa05 TO NULL
           INITIALIZE g_zaa_a[l_ac].zaa07 TO NULL
           INITIALIZE g_zaa_a[l_ac].zaa15 TO NULL
           INITIALIZE g_zaa_a[l_ac].zaa18 TO NULL   #FUN-580020
           LET g_zaa_a[l_ac].zaa06="N"
         ELSE
           CALL zaa_set_entry()
         END IF
 
      BEFORE FIELD zaa02
         IF g_zaa_a[l_ac].zaa02 IS NULL OR g_zaa_a[l_ac].zaa02 = 0 THEN
            SELECT MAX(zaa02)+1 INTO g_zaa_a[l_ac].zaa02
               FROM zaa_file where zaa01 = g_zaa01 AND
                    zaa04 = g_zaa04 AND zaa10 = g_zaa10
                AND zaa11 = g_zaa11 AND zaa17 = g_zaa17 #FUN-560079
            IF g_zaa_a[l_ac].zaa02 IS NULL THEN
                 LET g_zaa_a[l_ac].zaa02 = 1
            END IF
         END IF
 
      AFTER FIELD zaa02
         IF g_zaa_a[l_ac].zaa02 < 1 THEN
             NEXT FIELD zaa02
         END IF
         IF NOT cl_null(g_zaa_a[l_ac].zaa02) THEN
            IF g_zaa_a[l_ac].zaa02 != g_zaa_t.zaa02 OR g_zaa_t.zaa02 IS NULL THEN
 
               SELECT COUNT(*) INTO l_n FROM zaa_file
                WHERE zaa01 = g_zaa01 AND zaa02 = g_zaa_a[l_ac].zaa02
                  AND zaa03 = g_zaa_a[l_ac].zaa03 AND zaa04 = g_zaa04
                  AND zaa10 = g_zaa10 AND zaa11= g_zaa11
                  AND zaa17 = g_zaa17                        #FUN-560079
               IF l_n > 0 THEN
                  CALL cl_err(g_zaa_a[l_ac].zaa02,-239,0)
                  LET g_zaa_a[l_ac].zaa02 = g_zaa_t.zaa02
                  NEXT FIELD zaa02
#FUN-650175               
#              ELSE
#                 IF g_zaa_a[l_ac].zaa09 = 2 THEN
#                   IF g_zaa_a[l_ac].zaa07 IS NULL OR g_zaa_a[l_ac].zaa07 = 0 THEN
#                     SELECT MAX(zaa07)+1 INTO g_zaa_a[l_ac].zaa07
#                       FROM zaa_file where zaa01 = g_zaa01 AND
#                            zaa04 = g_zaa04 AND zaa10 = g_zaa10
#                        AND zaa11 = g_zaa11 AND zaa17 = g_zaa17  #FUN-560079
#                      IF g_zaa_a[l_ac].zaa07 IS NULL THEN
#                           LET g_zaa_a[l_ac].zaa07 = 1
#                      END IF
#                   END IF
#                   #FUN-580020   先自動給值
#                    LET l_num = 0
#                    SELECT MAX(zaa15)INTO l_num FROM zaa_file WHERE
#                        zaa01 = g_zaa01 AND zaa04 = g_zaa04 AND zaa10 = g_zaa10
#                        AND zaa11 = g_zaa11 AND zaa17 = g_zaa17
#                   IF l_num >1 THEN
#                       IF g_zaa_a[l_ac].zaa18 IS NULL OR g_zaa_a[l_ac].zaa18 = 0 THEN
#                         SELECT MAX(zaa18)+1 INTO g_zaa_a[l_ac].zaa18
#                           FROM zaa_file where zaa01 = g_zaa01 AND
#                                zaa04 = g_zaa04 AND zaa10 = g_zaa10
#                            AND zaa11 = g_zaa11 AND zaa17 = g_zaa17
#
#                          IF g_zaa_a[l_ac].zaa18 IS NULL THEN
#                              LET g_zaa_a[l_ac].zaa18 = 1
#                          END IF
#                       END IF
#                    END IF
#                   #FUN-580020(end)
#                   IF g_zaa_a[l_ac].zaa15 IS NULL OR g_zaa_a[l_ac].zaa15 = 0 THEN
#                      LET g_zaa_a[l_ac].zaa15 = 1
#                   END IF
#                  END IF
#END FUN-650175               
               END IF
            END IF
         END IF
 
      AFTER FIELD zaa03
         IF NOT cl_null(g_zaa_a[l_ac].zaa03) THEN
            IF g_zaa_a[l_ac].zaa03 != g_zaa_t.zaa03 OR g_zaa_t.zaa03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM zaa_file
                WHERE zaa01 = g_zaa01 AND zaa02 = g_zaa_a[l_ac].zaa02
                  AND zaa03 = g_zaa_a[l_ac].zaa03 AND zaa04 = g_zaa04
                  AND zaa10 = g_zaa10 AND zaa11=g_zaa11
                  AND zaa17 = g_zaa17                        #FUN-560079
               IF l_n > 0 THEN
                  CALL cl_err(g_zaa_a[l_ac].zaa03,-239,0)
                  LET g_zaa_a[l_ac].zaa03 = g_zaa_t.zaa03
                  NEXT FIELD zaa03
               ELSE
#FUN-650175               
#                 SELECT COUNT(*) INTO l_n FROM zaa_file
#                 WHERE zaa01 = g_zaa01 AND zaa03= g_zaa_a[l_ac].zaa03
#                   AND zaa04 = g_zaa04 AND zaa07= g_zaa_a[l_ac].zaa07
#                   AND zaa10 = g_zaa10 AND zaa11=g_zaa11
#                   AND zaa17 = g_zaa17                        #FUN-560079
#                 IF l_n > 0 THEN
#                     NEXT FIELD zaa07
#                 END IF
#                 #FUN-580020
#                 SELECT COUNT(*) INTO l_n FROM zaa_file
#                 WHERE zaa01 = g_zaa01 AND zaa03= g_zaa_a[l_ac].zaa03
#                   AND zaa04 = g_zaa04 AND zaa18= g_zaa_a[l_ac].zaa18
#                   AND zaa10 = g_zaa10 AND zaa11=g_zaa11
#                   AND zaa17 = g_zaa17                        #FUN-560079
#                 IF l_n > 0 THEN
#                     NEXT FIELD zaa18
#                 END IF
                  IF g_zaa_a[l_ac].zaa09 = 2 THEN
                    IF g_zaa_a[l_ac].zaa15 IS NULL OR g_zaa_a[l_ac].zaa15 = 0 THEN
                       LET g_zaa_a[l_ac].zaa15 = 1
                    END IF
                    IF g_zaa_a[l_ac].zaa07 IS NULL OR g_zaa_a[l_ac].zaa07 = 0 THEN
                      SELECT MAX(zaa07)+1 INTO g_zaa_a[l_ac].zaa07 FROM zaa_file
                       WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04 
                         AND zaa10 = g_zaa10 AND zaa11 = g_zaa11 
                         AND zaa17 = g_zaa17 AND zaa03 = g_zaa_a[l_ac].zaa03 #FUN-560079
                         AND zaa15 = g_zaa_a[l_ac].zaa15
                       IF g_zaa_a[l_ac].zaa07 IS NULL THEN
                            LET g_zaa_a[l_ac].zaa07 = 1
                       END IF
                    ELSE
                       SELECT COUNT(*) INTO l_n FROM zaa_file
                        WHERE zaa01 = g_zaa01 AND zaa03 = g_zaa_a[l_ac].zaa03
                          AND zaa04 = g_zaa04 AND zaa07 = g_zaa_a[l_ac].zaa07
                          AND zaa10 = g_zaa10 AND zaa11 = g_zaa11  
                          AND zaa17 = g_zaa17                           #FUN-560079
                          AND zaa15= g_zaa_a[l_ac].zaa15
                       IF l_n > 0 THEN
                            NEXT FIELD zaa15
                       END IF
                    END IF
                    #FUN-580020   先自動給值
                     LET l_num = 0
                     SELECT MAX(zaa15)INTO l_num FROM zaa_file 
                     WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04 
                       AND zaa10 = g_zaa10 AND zaa11 = g_zaa11 
                       AND zaa17 = g_zaa17 AND zaa03 = g_zaa_a[l_ac].zaa03
                    IF l_num >1 THEN
                        IF g_zaa_a[l_ac].zaa18 IS NULL OR g_zaa_a[l_ac].zaa18 = 0 THEN
                          SELECT MAX(zaa18)+1 INTO g_zaa_a[l_ac].zaa18 FROM zaa_file 
                           WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04
                             AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                             AND zaa17 = g_zaa17 AND zaa03 = g_zaa_a[l_ac].zaa03
                           IF g_zaa_a[l_ac].zaa18 IS NULL THEN
                               LET g_zaa_a[l_ac].zaa18 = 1
                           END IF
                        END IF
                     END IF
                    #FUN-580020(end)
                   END IF
               END IF
            END IF
            IF (g_zaa_a[l_ac].zaa05 IS NULL) AND (g_zaa_a[l_ac].zaa09='2') THEN #NO.FUN-610033
                NEXT FIELD zaa05
            END IF
#END FUN-650175               
         END IF
        #MOD-530271
      AFTER FIELD zaa14
       IF g_zaa_a[l_ac].zaa14 != g_zaa_t.zaa14 OR g_zaa_t.zaa14 IS NULL THEN #FUN-650175
           IF g_zaa_a[l_ac].zaa14 = "H" OR g_zaa_a[l_ac].zaa14= "I" THEN
                IF (g_zaa_t.zaa14 != "H" AND g_zaa_t.zaa14 != "I") OR g_zaa_t.zaa14 IS NULL THEN  #FUN-650175
                    LET g_cnt = 0
                    select COUNT(*) INTO g_cnt from zaa_file where
                       zaa01 = g_zaa01 AND zaa03 =g_zaa_a[l_ac].zaa03 AND
                       zaa04 = g_zaa04 AND zaa10 = g_zaa10 AND
                       zaa11 = g_zaa11 AND zaa17 = g_zaa17 AND    #FUN-560079
                       zaa14 = "H"
                    IF g_cnt = 0 THEN
                       select COUNT(*) INTO g_cnt from zaa_file where
                          zaa01 = g_zaa01 AND zaa03 =g_zaa_a[l_ac].zaa03 AND
                          zaa04 = g_zaa04 AND zaa10 = g_zaa10 AND
                          zaa11 = g_zaa11 AND zaa17 = g_zaa17 AND #FUN-560079
                          zaa14 = "I"
                    END IF
                    IF g_cnt > 0 THEN
                          CALL cl_err(g_zaa_a[l_ac].zaa14,'azz-109',1)
                          LET g_zaa_a[l_ac].zaa14 = g_zaa_t.zaa14
                          NEXT FIELD zaa14
                    END IF
 
                    LET g_cnt = l_ac
                     CALL zaa_zaa08_memo()           #MOD-530271
                  END IF
            ELSE
              IF g_zaa_a[l_ac].zaa09 = "2" THEN
                IF g_zaa_a[l_ac].zaa05 IS NULL OR g_zaa_a[l_ac].zaa05 = 0 THEN
                 CASE
                   WHEN g_zaa_a[l_ac].zaa14 = "A"
                       LET g_zaa_a[l_ac].zaa05= 15
                   WHEN g_zaa_a[l_ac].zaa14 = "B"
                       LET g_zaa_a[l_ac].zaa05= 18
                   WHEN g_zaa_a[l_ac].zaa14 = "C"
                       LET g_zaa_a[l_ac].zaa05= 10
                   WHEN g_zaa_a[l_ac].zaa14 = "D"
                       LET g_zaa_a[l_ac].zaa05= 18
                   WHEN g_zaa_a[l_ac].zaa14 = "E"
                       LET g_zaa_a[l_ac].zaa05= 15
                  END CASE
                  #-------------NO.MOD-5A0095 START--------------
                  DISPLAY BY NAME g_zaa_a[l_ac].zaa05
                  #-------------NO.MOD-5A0095 END----------------
                 END IF
               END IF
             END IF
       END IF
       #MOD-530271
     BEFORE FIELD zaa05,zaa06,zaa15,zaa07,zaa18
        IF g_zaa_a[l_ac].zaa09 = 1 THEN
                NEXT FIELD next
        END IF
        IF INFIELD(zaa15) THEN
           CALL cl_set_comp_entry("zaa18",TRUE)    #FUN-580020
           IF (g_zaa13 = "N") THEN
               IF NOT cl_confirm("azz-087") THEN
                   LET g_zaa_a[l_ac].zaa15 = g_zaa_t.zaa15
                   NEXT FIELD zaa08
               END IF
           END IF
        END IF
        IF INFIELD (zaa07) THEN
           IF (g_zaa13 = "N") THEN
               IF NOT cl_confirm("azz-087") THEN
                   LET g_zaa_a[l_ac].zaa07 = g_zaa_t.zaa07
                   NEXT FIELD zaa08
               END IF
           END IF
        END IF
        #FUN-580020
        IF INFIELD (zaa18) THEN
            IF (g_zaa13 = "N") THEN
                IF NOT cl_confirm("azz-087") THEN
                    LET g_zaa_a[l_ac].zaa18 = g_zaa_t.zaa18
                    NEXT FIELD zaa08
                END IF
            END IF
        END IF
        #FUN-580020(end)
      AFTER FIELD zaa05
         IF (g_zaa_a[l_ac].zaa05 < 1) OR (g_zaa_a[l_ac].zaa05 IS NULL) THEN #NO.FUN-610033
             NEXT FIELD zaa05
         END IF
 
 
      AFTER FIELD zaa15
         IF NOT cl_null(g_zaa_a[l_ac].zaa15) THEN
            IF (g_zaa_a[l_ac].zaa15 < 1) THEN #NO.FUN-610033
                NEXT FIELD zaa15
            END IF
            IF g_zaa_a[l_ac].zaa15 != g_zaa_t.zaa15 OR g_zaa_t.zaa15 IS NULL THEN
               #FUN-650175
               IF g_zaa_a[l_ac].zaa07 IS NULL OR g_zaa_a[l_ac].zaa07 = 0 THEN 
                  SELECT MAX(zaa07)+1 INTO g_zaa_a[l_ac].zaa07 FROM zaa_file 
                   WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04 
                     AND zaa10 = g_zaa10 AND zaa11=g_zaa11
                     AND zaa17 = g_zaa17 AND zaa15 = g_zaa_a[l_ac].zaa15  #FUN-560079
                     AND zaa03 = g_zaa_a[l_ac].zaa03             
                  IF g_zaa_a[l_ac].zaa07 IS NULL THEN
                     LET g_zaa_a[l_ac].zaa07 = 1
                  END IF
                  DISPLAY BY NAME g_zaa_a[l_ac].zaa07      #FUN-650175
                 #NEXT FIELD zaa07
               END IF
               #END FUN-650175
            END IF
 
            #FUN-580020
            CALL p_zaa_zaa18_check()                 #FUN-650175
            DISPLAY BY NAME g_zaa_a[l_ac].zaa18      #FUN-650175
 
            IF g_zaa_a[l_ac].zaa15 != g_zaa_t.zaa15 OR g_zaa_a[l_ac].zaa07 != g_zaa_t.zaa07 OR  g_zaa_t.zaa07 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM zaa_file
                WHERE zaa01 = g_zaa01 AND zaa03 = g_zaa_a[l_ac].zaa03
                  AND zaa04 = g_zaa04 AND zaa07 = g_zaa_a[l_ac].zaa07
                  AND zaa10 = g_zaa10 AND zaa11 = g_zaa11  AND zaa17 = g_zaa17 #FUN-560079
                  AND zaa15= g_zaa_a[l_ac].zaa15
               IF l_n > 0 THEN
                    NEXT FIELD zaa07
               END IF
            END IF
         ELSE
            IF (g_zaa_a[l_ac].zaa15 IS NULL) THEN #NO.FUN-610033
               NEXT FIELD zaa15
            END IF
         END IF
 
 
      AFTER FIELD zaa07
         IF NOT cl_null(g_zaa_a[l_ac].zaa07) THEN
            IF (g_zaa_a[l_ac].zaa07 <1) THEN #NO.FUN-610033
               NEXT FIELD zaa07
            END IF
            IF g_zaa_a[l_ac].zaa15 != g_zaa_t.zaa15 OR g_zaa_a[l_ac].zaa07 != g_zaa_t.zaa07 OR  g_zaa_t.zaa07 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM zaa_file
                WHERE zaa01 = g_zaa01 AND zaa03 = g_zaa_a[l_ac].zaa03
                  AND zaa04 = g_zaa04 AND zaa07 = g_zaa_a[l_ac].zaa07
                  AND zaa10 = g_zaa10 AND zaa11 = g_zaa11  AND zaa17 = g_zaa17 #FUN-560079
                  AND zaa15= g_zaa_a[l_ac].zaa15
               IF l_n > 0 THEN
                 # CALL cl_err(g_zaa_a[l_ac].zaa07,-239,0)
                  LET g_n = 0
                  LET g_n = p_zaa_seq(p_cmd)
                  IF g_n = 0 THEN
                    LET g_zaa_a[l_ac].zaa07 = g_zaa_t.zaa07
                #    LET g_zaa_a[l_ac].zaa15 = g_zaa_t.zaa15
                    NEXT FIELD zaa07
                  END IF
               END IF
            END IF
         ELSE
            IF (g_zaa_a[l_ac].zaa07 IS NULL) THEN #NO.FUN-610033
               NEXT FIELD zaa07
            END IF
         END IF
 
         CALL p_zaa_zaa18_check()                 #FUN-650175
         DISPLAY BY NAME g_zaa_a[l_ac].zaa18      #FUN-650175
 
      #FUN-580020
      AFTER FIELD zaa18    # 欄位資料變更時 呼叫p_zaa_seq1(p_cmd)
         IF NOT cl_null(g_zaa_a[l_ac].zaa18) THEN
            IF g_zaa_a[l_ac].zaa18 != g_zaa_t.zaa18 OR g_zaa_t.zaa18 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM zaa_file
                WHERE zaa01 = g_zaa01 AND zaa03 = g_zaa_a[l_ac].zaa03
                  AND zaa04 = g_zaa04 AND zaa18 = g_zaa_a[l_ac].zaa18
                  AND zaa10 = g_zaa10 AND zaa11 = g_zaa11 AND zaa17 = g_zaa17
                 # AND zaa15= g_zaa_a[l_ac].zaa15
               IF l_n > 0 THEN
                  LET g_n = 0
                  LET g_n = p_zaa_seq1(p_cmd)
                  IF g_n = 0 THEN
                    LET g_zaa_a[l_ac].zaa18 = g_zaa_t.zaa18
                    NEXT FIELD zaa18
                  END IF
               END IF
            END IF
         END IF
#FUN-610033 start
        BEFORE FIELD zad09
           IF g_zaa_a[l_ac].zaa09='2' THEN
              CALL p_zaa_link_menu()
              CALL zad09_check(g_zaa_ac)
              LET l_ac = g_zaa_ac
           END IF
              NEXT FIELD zaa08
 
#FUN-610033 end
      #FUN-580020(end)
        BEFORE FIELD zaa08
             IF g_zaa_a[l_ac].zaa14='H' OR g_zaa_a[l_ac].zaa14='I' THEN   #MOD-530271
                CALL cl_set_action_active("controlp", TRUE)
            END IF
 
        AFTER FIELD zaa08
             IF g_zaa_a[l_ac].zaa14='H' OR g_zaa_a[l_ac].zaa14='I' THEN    #MOD-530271
               CALL cl_set_action_active("controlp", FALSE)
               LET g_cnt = l_ac
                CALL zaa_zaa08_memo()           #MOD-530271
             END IF
 
      BEFORE DELETE                            #是否取消單身
         IF (NOT cl_null(g_zaa_t.zaa02)) AND (NOT cl_null(g_zaa_t.zaa03)) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM zaa_file
              WHERE zaa01 = g_zaa01 AND zaa02 = g_zaa_a[l_ac].zaa02
                AND zaa03 = g_zaa_a[l_ac].zaa03 AND zaa04 = g_zaa04
                AND zaa10 = g_zaa10 AND zaa11 = g_zaa11 AND zaa17 = g_zaa17 #FUN-560079
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_zaa_a[l_ac].zaa02,SQLCA.sqlcode,0)   #No.FUN-660081
               CALL cl_err3("del","zaa_file",g_zaa01,g_zaa_a[l_ac].zaa02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
 
            LET g_zaa07_seq = g_zaa_a[l_ac].zaa07 - 1
            FOR k = 1 to g_zaa_a.getLength()
                IF g_zaa_a[k].zaa03 = g_zaa_t.zaa03 AND g_zaa_a[k].zaa15 = g_zaa_t.zaa15 AND g_zaa_a[k].zaa07 > g_zaa_a[l_ac].zaa07 THEN
                    LET g_zaa_a[k].zaa07 = g_zaa_a[k].zaa07 - 1
                    UPDATE zaa_file SET zaa07 = g_zaa_a[k].zaa07
                      WHERE zaa01 = g_zaa01 AND zaa03 = g_zaa_a[k].zaa03
                      AND zaa04 = g_zaa04 AND zaa02 = g_zaa_a[k].zaa02
                      AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                      AND zaa17 = g_zaa17    #FUN-560079
                END IF
            END FOR
            #FUN-580020  刪除時更新單行順序
            LET g_zaa18_seq = g_zaa_a[l_ac].zaa18 - 1
            FOR k = 1 to g_zaa_a.getLength()
                IF g_zaa_a[k].zaa03 = g_zaa_t.zaa03  AND g_zaa_a[k].zaa18 > g_zaa_a[l_ac].zaa18 THEN
                    LET g_zaa_a[k].zaa18 = g_zaa_a[k].zaa18 - 1
                    UPDATE zaa_file SET zaa18 = g_zaa_a[k].zaa18
                      WHERE zaa01 = g_zaa01 AND zaa03 = g_zaa_a[k].zaa03
                      AND zaa04 = g_zaa04 AND zaa02 = g_zaa_a[k].zaa02
                      AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                      AND zaa17 = g_zaa17
                     # AND zaa15 > 1
                END IF
            END FOR
 
            #FUN-580020(end)
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zaa_a[l_ac].* = g_zaa_t.*
            CLOSE p_zaa_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zaa_a[l_ac].zaa02,-263,1)
            LET g_zaa_a[l_ac].* = g_zaa_t.*
         ELSE
            UPDATE zaa_file
               SET zaa09 = g_zaa_a[l_ac].zaa09,
                   zaa02 = g_zaa_a[l_ac].zaa02,
                   zaa03 = g_zaa_a[l_ac].zaa03,
                   zaa14 = g_zaa_a[l_ac].zaa14,
                   zaa05 = g_zaa_a[l_ac].zaa05,
                   zaa06 = g_zaa_a[l_ac].zaa06,
                   zaa15 = g_zaa_a[l_ac].zaa15,
                   zaa07 = g_zaa_a[l_ac].zaa07,
                   zaa18 = g_zaa_a[l_ac].zaa18,   #FUN-580020
                   zaa08 = g_zaa_a[l_ac].zaa08
             WHERE zaa01 = g_zaa01 AND zaa02 = g_zaa_t.zaa02
               AND zaa03 = g_zaa_t.zaa03 AND zaa04 = g_zaa04
               AND zaa10 = g_zaa10 AND zaa11 = g_zaa11 AND zaa17 = g_zaa17 #FUN-560079
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_zaa_a[l_ac].zaa02,SQLCA.sqlcode,0)   #No.FUN-660081
               CALL cl_err3("upd","zaa_file",g_zaa01,g_zaa_t.zaa02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zaa_a[l_ac].* = g_zaa_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
          CALL zaa_set_entry()            #MOD-530271
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac       #FUN-D30034 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zaa_a[l_ac].* = g_zaa_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_zaa_a.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end-- 
            END IF
            CLOSE p_zaa_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac       #FUN-D30034 Add
 
#NO.FUN-610033 start
         IF (p_cmd='a') AND (g_zaa_a[l_ac].zaa05 IS NULL) AND (g_zaa_a[l_ac].zaa09='2') THEN
             NEXT FIELD zaa05
         END IF
        #CALL g_zaa_a.deleteElement(g_rec_b+1)    $FUN-D30034 Mark
#NO.FUN-610033 end
 
         CLOSE p_zaa_bcl
         COMMIT WORK
 
     ON ACTION controlp
         CASE
             WHEN INFIELD(zaa08)                     #MOD-530267
                 #MOD-530271
               CALL q_zab(g_zaa_a[l_ac].zaa08,g_zaa_a[l_ac].zaa03) RETURNING g_zaa_a[l_ac].zaa08,g_zaa_a[l_ac].memo
               DISPLAY BY NAME g_zaa_a[l_ac].zaa08
               IF g_zaa_a[l_ac].zaa08 = g_zaa_t.zaa08 THEN
                    LET g_zaa_a[l_ac].memo = g_zaa_t.memo
               END IF
               DISPLAY g_zaa_a[l_ac].memo TO FORMONLY.memo
                 #MOD-530271
               LET INT_FLAG = 0
               NEXT FIELD zaa08
         END CASE
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF l_ac > 1 THEN
            LET g_zaa_a[l_ac].* = g_zaa_a[l_ac-1].*
            LET g_zaa_a[l_ac].zaa03 = NULL  #NO.FUN-610033
            SELECT MAX(zaa02)+1 INTO g_zaa_a[l_ac].zaa02
               FROM zaa_file where zaa01 = g_zaa01 AND
                    zaa04 = g_zaa04 AND zaa10 = g_zaa10
                AND zaa11 = g_zaa11 AND zaa17 = g_zaa17 #FUN-560079
            NEXT FIELD zaa09
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   CLOSE p_zaa_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_zaa_b_fill(p_wc)                 #BODY FILL UP
   DEFINE   p_wc     LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(300)
   DEFINE   ls_sql2  STRING,
            l_zab05  LIKE zab_file.zab05
 
     LET g_sql = "SELECT zaa09, zaa02,zaa03,zaa14,zaa05,zaa06,zaa15,zaa07,zaa18,zaa08 ",    #FUN-580020
                   "  FROM zaa_file ",
                   " WHERE zaa01 = '",g_zaa01 CLIPPED,"' ",
                   "   AND zaa04 = '",g_zaa04 CLIPPED,"' ",
                   "   AND zaa10 = '",g_zaa10 CLIPPED,"' ",
                   "   AND zaa11 = '",g_zaa11 CLIPPED,"' ",
                   "   AND zaa17 = '",g_zaa17 CLIPPED,"' ",  #FUN-560079
                   "   AND ",p_wc CLIPPED,
                   " ORDER BY zaa02,zaa03"
 
    PREPARE p_zaa_prepare3 FROM g_sql           #預備一下
    DECLARE zaa_curs3 CURSOR FOR p_zaa_prepare3
 
    CALL g_zaa_a.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH zaa_curs3 INTO g_zaa_a[g_cnt].zaa09,g_zaa_a[g_cnt].zaa02,g_zaa_a[g_cnt].zaa03,g_zaa_a[g_cnt].zaa14,g_zaa_a[g_cnt].zaa05,g_zaa_a[g_cnt].zaa06,g_zaa_a[g_cnt].zaa15,g_zaa_a[g_cnt].zaa07,g_zaa_a[g_cnt].zaa18,g_zaa_a[g_cnt].zaa08   #FUN-580020
        IF g_zaa_a[g_cnt].zaa14='H' OR g_zaa_a[g_cnt].zaa14='I'    #MOD-530271
       THEN
           CALL zaa_zaa08_memo()
       END IF
#FUN-610033 start
       IF g_zaa_a[g_cnt].zaa09='2' THEN
          CALL zad09_check(g_cnt)
       END IF
#FUN-610033 start
       LET g_rec_b = g_rec_b + 1
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
    CALL g_zaa_a.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
    CALL p_zaa_width()                     #計算報表寬度  #FUN-580131
 
END FUNCTION
 
FUNCTION p_zaa_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_zaa_a TO s_zaa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
          CALL cl_navigator_setting(mi_curs_index, g_row_count) #No.FUN-580092 HCN
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_combo_lang("zaa03")
         INITIALIZE g_gaz03 TO NULL
         CALL p_zaa_desc()
         CALL p_zaa_width()              #計算報表寬度  #FUN-580131 #FUN-5A0203
         EXIT DISPLAY
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION first                            # 第一筆
         CALL p_zaa_fetch('F')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_zaa_fetch('P')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_zaa_fetch('/')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL p_zaa_fetch('N')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL p_zaa_fetch('L')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION seq_afresh                       #重排欄位順序
         LET g_action_choice="seq_afresh"
         EXIT DISPLAY
 
      ON ACTION sug_print                        #建議報表列印寬度 #FUN-5A0205
         LET g_action_choice="sug_print"
         EXIT DISPLAY
 
      #-----FUN-760029---------
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #-----END FUN-760029-----
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("grid01","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_zaa_copy()
   DEFINE   l_n        LIKE type_file.num5,       #No.FUN-680135 SMALLINT
            l_newfe    LIKE zaa_file.zaa01,
            l_oldfe    LIKE zaa_file.zaa01,
            l_newfe4   LIKE zaa_file.zaa04,
            l_oldfe4   LIKE zaa_file.zaa04,
            l_newfe10  LIKE zaa_file.zaa10,
            l_oldfe10  LIKE zaa_file.zaa10,
            l_newfe11  LIKE zaa_file.zaa11,
            l_oldfe11  LIKE zaa_file.zaa11,
            l_newfe12  LIKE zaa_file.zaa12,
            l_oldfe12  LIKE zaa_file.zaa12,
            l_newfe13  LIKE zaa_file.zaa13,
            l_oldfe13  LIKE zaa_file.zaa13,
             l_newfe16  LIKE zaa_file.zaa16,      #MOD-530271
            l_oldfe16  LIKE zaa_file.zaa16,
            l_newfe17  LIKE zaa_file.zaa17,       #FUN-560079
            l_oldfe17  LIKE zaa_file.zaa17,
            l_newfe19  LIKE zaa_file.zaa19,       #FUN-650017
            l_oldfe19  LIKE zaa_file.zaa19,       #FUN-650017
            l_newfe20  LIKE zaa_file.zaa20,       #No.FUN-6C0048
            l_oldfe20  LIKE zaa_file.zaa20,       #No.FUN-6C0048
            l_newfe21  LIKE zaa_file.zaa21,       #No.FUN-6C0048
            l_oldfe21  LIKE zaa_file.zaa21        #No.FUN-6C0048 
   DEFINE   l_zwacti   LIKE zw_file.zwacti        #FUN-650175
 
   IF s_shut(0) THEN                              # 檢查權限
      RETURN
   END IF
 
   IF g_zaa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("grid01","YES")   #No.FUN-6A0092
   INPUT l_newfe,l_newfe4,l_newfe17,l_newfe11,l_newfe12,l_newfe19,l_newfe20,l_newfe21,l_newfe10,l_newfe13 ,l_newfe16 #No.FUN-6C0048
      WITHOUT DEFAULTS FROM zaa01,zaa04,zaa17,zaa11,zaa12,zaa19,zaa20,zaa21,zaa10,zaa13,zaa16     #MOD-530271 #FUN-560079 #No.FUN-6C0048
 
      BEFORE INPUT
         DISPLAY g_zaa10 TO zaa10
         DISPLAY g_zaa04 TO zaa04               #MOD-540161
         DISPLAY g_zaa12 TO zaa12
         DISPLAY g_zaa13 TO zaa13
         DISPLAY g_zaa16 TO zaa16               #MOD-530271
         DISPLAY g_zaa17 TO zaa17               #FUN-560079
         DISPLAY g_zaa19 TO zaa19               #FUN-650017
         DISPLAY g_zaa20 TO zaa20               #No.FUN-6C0048
         DISPLAY g_zaa21 TO zaa21               #No.FUN-6C0048
 
         DISPLAY ' ' TO FORMONLY.gaz03
         LET l_newfe10 = g_zaa10
         LET l_newfe4 = g_zaa04                  #MOD-540161
         LET l_newfe12 = g_zaa12
         LET l_newfe13 = g_zaa13
         LET l_newfe16 = g_zaa16                 #MOD-530271
         LET l_newfe17 = g_zaa17                 #FUN-560079
         LET l_newfe19 = g_zaa19                 #FUN-650017
         LET l_newfe20 = g_zaa20                 #No.FUN-6C0048
         LET l_newfe21 = g_zaa21                 #No.FUN-6C0048
 
      AFTER FIELD zaa01
         IF cl_null(l_newfe) THEN
            NEXT FIELD zaa01
         END IF
 
         LET g_cnt = 0
         SELECT COUNT(UNIQUE zz01) INTO g_cnt FROM zz_file
          WHERE zz01 = l_newfe
         IF g_cnt = 0  THEN
             CALL cl_err(l_newfe,'azz-053',1)
             NEXT FIELD zaa01
         END IF
 #MOD-54016
#        LET g_cnt = 0
#        SELECT COUNT(*) INTO g_cnt FROM zaa_file
#         WHERE zaa01 = l_newfe AND zaa04 = l_newfe4
#         AND zaa10 = l_newfe10 AND zaa11 = l_newfe11
#
#        IF g_cnt > 0 THEN
#           CALL cl_err(l_newfe,-239,0)
#           NEXT FIELD zaa01
#        ELSE
           SELECT gaz03 INTO g_gaz03 FROM gaz_file WHERE gaz01 = l_newfe AND gaz02 = g_lang
           DISPLAY g_gaz03 TO FORMONLY.gaz03
#         END IF
 
     BEFORE FIELD zaa04        #FUN-560079
         IF l_newfe4 = 'default' THEN
            CALL cl_set_comp_entry("zaa04",TRUE)
         END IF
 
      AFTER FIELD zaa04
         IF cl_null(l_newfe4) THEN
            NEXT FIELD zaa04
         END IF
         #FUN-650175
         IF l_newfe4 CLIPPED  <>'default' THEN
            SELECT COUNT(*) INTO g_cnt FROM zx_file
             WHERE zx01 = l_newfe4
            IF g_cnt = 0 THEN
                CALL cl_err(l_newfe4,'mfg1312',0)
                NEXT FIELD zaa04
            END IF
         END IF
         IF l_newfe4 = 'default' THEN
            IF l_newfe17 <> 'default' THEN
               CALL cl_set_comp_entry("zaa17",TRUE)
               CALL cl_set_comp_entry("zaa04",FALSE)
            ELSE
               CALL cl_set_comp_entry("zaa17",TRUE)
               CALL cl_set_comp_entry("zaa04",TRUE)
            END IF
         ELSE
            IF l_newfe17 = 'default' THEN
               CALL cl_set_comp_entry("zaa04",TRUE)
               CALL cl_set_comp_entry("zaa17",FALSE)
            END IF
         END IF
         #END FUN-650175
 
#        SELECT COUNT(*) INTO g_cnt FROM zaa_file
#         WHERE zaa01 = l_newfe AND zaa04 = l_newfe4
#         AND zaa10 = l_newfe10 AND zaa11 = l_newfe11
#
#        IF g_cnt > 0 THEN
#           CALL cl_err(l_newfe4,-239,0)
#           NEXT FIELD zaa04
#        END IF
 # END MOD-540161
 
     BEFORE FIELD zaa17        #FUN-560079
         IF l_newfe17 = 'default' THEN
            CALL cl_set_comp_entry("zaa17",TRUE)
         END IF
 
     AFTER FIELD zaa17         #FUN-560079
         IF cl_null(l_newfe17) THEN
            NEXT FIELD zaa17
         END IF
         #FUN-650175
         IF l_newfe17 CLIPPED  <> 'default' THEN
            SELECT zwacti INTO l_zwacti FROM zw_file
             WHERE zw01 = l_newfe17
            IF STATUS THEN
#               CALL cl_err('select '||l_newfe17||" ",STATUS,0)   #No.FUN-660081
                CALL cl_err3("sel","zw_file",l_newfe17,"",STATUS,"","select "||l_newfe17,0)    #No.FUN-660081
                NEXT FIELD zaa17
            ELSE
               IF l_zwacti != "Y" THEN   #MOD-560212
                  CALL cl_err_msg(NULL,"azz-218",l_newfe17 CLIPPED,10)
                  NEXT FIELD zaa17
               END IF
            END IF
         END IF
         #END FUN-650175
 
         IF l_newfe17 = 'default' THEN
            IF l_newfe4 <> 'default' THEN
               CALL cl_set_comp_entry("zaa04",TRUE)
               CALL cl_set_comp_entry("zaa17",FALSE)
            ELSE
               CALL cl_set_comp_entry("zaa17",TRUE)
               CALL cl_set_comp_entry("zaa04",TRUE)
            END IF
         ELSE
            IF l_newfe4 = 'default' THEN
               CALL cl_set_comp_entry("zaa17",TRUE)
               CALL cl_set_comp_entry("zaa04",FALSE)
            END IF
         END IF
 
      AFTER INPUT
           IF INT_FLAG THEN                            # 使用者不玩了
               EXIT INPUT
           END IF
             SELECT COUNT(*) INTO g_cnt FROM zaa_file
             WHERE zaa01=l_newfe AND zaa04 = l_newfe4 AND zaa10=l_newfe10
               AND zaa11 = l_newfe11  AND zaa17=l_newfe17   #FUN-560079
             IF g_cnt > 0  THEN
               CALL cl_err(l_newfe,-239,1)
               NEXT FIELD zaa01
             END IF
             SELECT COUNT(*) INTO g_cnt FROM zaa_file
              WHERE zaa01 = l_newfe AND zaa04 = "default"
              AND zaa10 = l_newfe10
             IF g_cnt = 0 THEN
                IF (l_newfe4 <> "default")  THEN
                   CALL cl_err(l_newfe,'azz-086',1)
                   NEXT FIELD zaa01
                END IF
             END IF
 
     ON ACTION controlp
         CASE
            WHEN INFIELD(zaa01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.arg1 =  g_lang
               LET g_qryparam.default1= l_newfe
               CALL cl_create_qry() RETURNING l_newfe
               DISPLAY l_newfe TO zaa01
               NEXT FIELD zaa01
 
            WHEN INFIELD(zaa04)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zx"            #MOD-530267
               LET g_qryparam.default1 = l_newfe4
               CALL cl_create_qry() RETURNING l_newfe4
               DISPLAY l_newfe4 TO zaa04
               NEXT FIELD zaa04
 
            #FUN-650175
            WHEN INFIELD(zaa17)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zw"            #MOD-530267
               LET g_qryparam.default1 = l_newfe17
               CALL cl_create_qry() RETURNING l_newfe17
               DISPLAY l_newfe17 TO zaa17
               NEXT FIELD zaa17
            #END FUN-650175
 
            OTHERWISE
               EXIT CASE
         END CASE
 
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
   CALL cl_set_comp_entry("zaa04,zaa17",TRUE)        #FUN-650175
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_zaa01 TO zaa01
      DISPLAY g_zaa04 TO zaa04
      DISPLAY g_zaa10 TO zaa10
      DISPLAY g_zaa11 TO zaa11
      DISPLAY g_zaa12 TO zaa12
      DISPLAY g_zaa13 TO zaa13
      DISPLAY g_zaa16 TO zaa16            #MOD-530271
      DISPLAY g_zaa17 TO zaa17            #FUN-560079
      DISPLAY g_zaa19 TO zaa19            #FUN-650017
      DISPLAY g_zaa20 TO zaa20            #No.FUN-6C0048
      DISPLAY g_zaa21 TO zaa21            #No.FUN-6C0048
   END IF
 
   DROP TABLE x
   SELECT * FROM zaa_file
           WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04 AND zaa10 = g_zaa10
             AND zaa11 = g_zaa11  AND zaa17 = g_zaa17   #FUN-560079
     INTO TEMP x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_zaa01,SQLCA.sqlcode,0)   #No.FUN-660081
      CALL cl_err3("sel","zaa_file",g_zaa01,g_zaa04,SQLCA.sqlcode,"","",0)    #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET zaa01 = l_newfe,                              # 資料鍵值
          zaa04 = l_newfe4,
          zaa10 = l_newfe10,
          zaa11 = l_newfe11,
          zaa12 = l_newfe12,
          zaa13 = l_newfe13,                        #MOD-530271
          zaa16 = l_newfe16,
          zaa17 = l_newfe17,                        #FUN-560079
          zaa19 = l_newfe19,                        #FUN-650017
          zaa20 = l_newfe20,                        #No.FUN-6C0048
          zaa21 = l_newfe21                         #No.FUN-6C0048
 
   INSERT INTO zaa_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
#     CALL cl_err('zaa:',SQLCA.SQLCODE,0)   #No.FUN-660081
      CALL cl_err3("ins","zaa_file",l_newfe,l_newfe4,SQLCA.sqlcode,"","zaa",0)    #No.FUN-660081
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_oldfe = g_zaa01
   LET l_oldfe4 = g_zaa04
   LET l_oldfe10 = g_zaa10
   LET l_oldfe11 = g_zaa11
   LET l_oldfe12 = g_zaa12
   LET l_oldfe17 = g_zaa17       #FUN-560079
   LET l_oldfe19 = g_zaa19       #FUN-650017
   LET l_oldfe20 = g_zaa20       #No.FUN-6C0048
   LET l_oldfe21 = g_zaa21       #No.FUN-6C0048
   LET g_zaa01 = l_newfe
   LET g_zaa04 = l_newfe4
   LET g_zaa10 = l_newfe10
   LET g_zaa11 = l_newfe11
   LET g_zaa12 = l_newfe12
#No.MOD-690024--start
   LET g_zaa13 = l_newfe13 
   LET g_zaa16 = l_newfe16
#No.MOD-690024--end
   LET g_zaa17 = l_newfe17       #FUN-560079
   LET g_zaa19 = l_newfe19       #FUN-650017
   LET g_zaa20 = l_newfe20       #No.FUN-6C0048
   LET g_zaa21 = l_newfe21       #No.FUN-6C0048
   CALL p_zaa_b()
#FUN-C30027---begin
#   LET g_zaa01 = l_oldfe
#   LET g_zaa04 = l_oldfe4
#   LET g_zaa10 = l_oldfe10
#   LET g_zaa11 = l_oldfe11
#   LET g_zaa12 = l_oldfe12
##No.MOD-690024--start
#   LET g_zaa13 = l_oldfe13
#   LET g_zaa16 = l_oldfe16
##No.MOD-690024--end
#   LET g_zaa17 = l_oldfe17        #FUN-560079
#   LET g_zaa19 = l_oldfe19        #FUN-650017
#   LET g_zaa20 = l_oldfe20        #No.FUN-6C0048
#   LET g_zaa21 = l_oldfe21        #No.FUN-6C0048
#   CALL p_zaa_show()
#FUN-C30027---end
END FUNCTION
 
FUNCTION p_zaa_desc()
 
   SELECT gaz03 INTO g_gaz03 FROM gaz_file WHERE gaz01 = g_zaa01 AND gaz02 = g_lang
   DISPLAY g_gaz03 TO FORMONLY.gaz03
END FUNCTION
 
FUNCTION zaa_set_entry()
  IF INFIELD(zaa11)     THEN
       CALL cl_set_comp_entry("zaa11", TRUE)
  ELSE
       CALL cl_set_comp_entry("zaa05,zaa06,zaa07,zaa15,zaa18", TRUE)    #FUN-580020
  END IF
END FUNCTION
 
FUNCTION zaa_set_no_entry()
  IF INFIELD(zaa11)  THEN
       CALL cl_set_comp_entry("zaa11", FALSE)
  ELSE
       CALL cl_set_comp_entry("zaa05,zaa06,zaa07,zaa15,zaa18", FALSE)   #FUN-580020
  END IF
END FUNCTION
 
FUNCTION p_zaa_seq(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
DEFINE k         LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE l_zaa02   LIKE zaa_file.zaa02
DEFINE l_zaa07   LIKE zaa_file.zaa07
#No.TQC-9B0004  --Begin
#       FORM        LINE FIRST + 1,
#       MESSAGE     LINE LAST,
#       PROMPT      LINE LAST,
#       INPUT NO WRAP
#   DEFER INTERRUPT
#No.TQC-9B0004  --End  
 
             OPEN WINDOW p_zaa_1 AT 8,23 WITH FORM "azz/42f/p_zaa_1"
                  ATTRIBUTE (STYLE = g_win_style)
             CALL cl_ui_locale("p_zaa_1")
 
             LET g_n = 1                                #FUN-650175
 
             INPUT g_n WITHOUT DEFAULTS FROM a
                  ON ACTION cancel
                     LET g_n = 0
                     EXIT INPUT
 
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                     CONTINUE INPUT
 
              END INPUT
              BEGIN WORK
              CASE g_n
                   WHEN 1   #欄位順序調換
                      IF p_cmd = "a" THEN
                            SELECT MAX(zaa07)+1 INTO g_zaa_t.zaa07
                            FROM zaa_file where zaa01 = g_zaa01 AND
                                zaa04 = g_zaa04 AND zaa10 = g_zaa10 AND
                                zaa11 = g_zaa11 AND zaa17 = g_zaa17 AND  #FUN-560079
                                zaa15 = g_zaa_a[l_ac].zaa15
                            LET g_zaa_t.zaa15 = g_zaa_a[l_ac].zaa15
                      END IF
                      FOR k = 1 to g_zaa_a.getLength()
                          IF (k <> l_ac) AND g_zaa_a[k].zaa03=g_zaa_a[l_ac].zaa03 AND g_zaa_a[k].zaa15 = g_zaa_a[l_ac].zaa15 AND g_zaa_a[k].zaa07 = g_zaa_a[l_ac].zaa07 THEN
                            LET g_zaa_a[k].zaa07 = g_zaa_t.zaa07
                            LET g_zaa_a[k].zaa15 = g_zaa_t.zaa15
                            UPDATE zaa_file SET zaa07 = g_zaa_t.zaa07, zaa15 = g_zaa_t.zaa15
                             WHERE zaa01 = g_zaa01 AND zaa03 = g_zaa_a[k].zaa03
                               AND zaa04 = g_zaa04 AND zaa02 = g_zaa_a[k].zaa02
                               AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                               AND zaa17 = g_zaa17   #FUN-560079
                            EXIT FOR
                          END IF
                      END FOR
 
                    IF p_cmd = "u" THEN
                      UPDATE zaa_file SET zaa15 = g_zaa_a[l_ac].zaa15, zaa07 = g_zaa_a[l_ac].zaa07
                          WHERE zaa01 = g_zaa01 AND zaa02 = g_zaa_t.zaa02
                          AND zaa03 = g_zaa_t.zaa03 AND zaa04 = g_zaa04
                          AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                          AND zaa17 = g_zaa17         #FUN-560079
                      LET g_zaa_t.zaa07 = g_zaa_a[l_ac].zaa07
                      LET g_zaa_t.zaa15 = g_zaa_a[l_ac].zaa15
                    END IF
 
                   WHEN 2         #以下欄位順序自動往後遞增一位
                      #FUN-580131
                      FOR k = 1 to g_zaa_a.getLength()
                          IF (k <> l_ac) AND g_zaa_a[k].zaa03=g_zaa_a[l_ac].zaa03
                             AND g_zaa_a[k].zaa15 = g_zaa_a[l_ac].zaa15
                             AND g_zaa_a[k].zaa07 >= g_zaa_a[l_ac].zaa07
                             AND ((g_zaa_a[k].zaa07 <= g_zaa_t.zaa07) OR
                                  (g_zaa_t.zaa07 <= g_zaa_a[l_ac].zaa07))
                          THEN
                              LET g_zaa_a[k].zaa07 = g_zaa_a[k].zaa07 + 1
                              UPDATE zaa_file SET zaa07 = g_zaa_a[k].zaa07
                                WHERE zaa01 = g_zaa01 AND zaa03 = g_zaa_a[k].zaa03
                                AND zaa04 = g_zaa04 AND zaa02 = g_zaa_a[k].zaa02
                                AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                                AND zaa17 = g_zaa17         #FUN-560079
                          END IF
                      END FOR
                     #TQC-6B0188-begin-add
                      IF p_cmd = "a" THEN
                      FOR k = 1 to g_zaa_a.getLength()
                          IF (k <> l_ac) AND g_zaa_a[k].zaa03=g_zaa_a[l_ac].zaa03
                             AND g_zaa_a[k].zaa15 = g_zaa_a[l_ac].zaa15
                             AND g_zaa_a[k].zaa07 >= g_zaa_a[l_ac].zaa07
                          THEN
                              LET g_zaa_a[k].zaa07 = g_zaa_a[k].zaa07 + 1
                              UPDATE zaa_file SET zaa07 = g_zaa_a[k].zaa07
                                WHERE zaa01 = g_zaa01 AND zaa03 = g_zaa_a[k].zaa03
                                AND zaa04 = g_zaa04 AND zaa02 = g_zaa_a[k].zaa02
                                AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                                AND zaa17 = g_zaa17      
                          END IF
                      END FOR
                      END IF
                     #TQC-6B0188-end-add
                      IF p_cmd = "u" THEN
                        UPDATE zaa_file SET zaa15 = g_zaa_a[l_ac].zaa15, zaa07 = g_zaa_a[l_ac].zaa07
                            WHERE zaa01 = g_zaa01 AND zaa02 = g_zaa_t.zaa02
                            AND zaa03 = g_zaa_t.zaa03 AND zaa04 = g_zaa04
                            AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                            AND zaa17 = g_zaa17         #FUN-560079
                      END IF
                      LET g_zaa_t.zaa07 = g_zaa_a[l_ac].zaa07
                      LET g_zaa_t.zaa15 = g_zaa_a[l_ac].zaa15
                      #END FUN-580131
 
              END CASE
              CLOSE WINDOW p_zaa_1
              RETURN g_n
END FUNCTION
 
#FUN-580020
FUNCTION p_zaa_seq1(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
DEFINE k         LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE l_zaa02   LIKE zaa_file.zaa02
DEFINE l_zaa18   LIKE zaa_file.zaa18

    #No.TQC-9B0004  --Begin
#       FORM        LINE FIRST + 1,
#       MESSAGE     LINE LAST,
#       PROMPT      LINE LAST,
#       INPUT NO WRAP
#   DEFER INTERRUPT
    #No.TQC-9B0004  --End  
 
        OPEN WINDOW p_zaa_1 AT 8,23 WITH FORM "azz/42f/p_zaa_1"
            ATTRIBUTE (STYLE = g_win_style)
        CALL cl_ui_locale("p_zaa_1")
 
        LET g_n = 1                                #FUN-650175
 
        INPUT g_n WITHOUT DEFAULTS FROM a
            ON ACTION cancel
               LET g_n=0
               EXIT INPUT
            ON ACTION g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
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
        BEGIN WORK
        CASE g_n
                WHEN 1
                      IF p_cmd = "a" THEN
                            SELECT MAX(zaa18)+1 INTO g_zaa_t.zaa18
                            FROM zaa_file where zaa01=g_zaa01 AND
                               zaa04 = g_zaa04 AND zaa10 = g_zaa10 AND
                               zaa11 = g_zaa11 AND zaa17 = g_zaa17 # AND
                             #  zaa15 = g_zaa_a[l_ac].zaa15
                            # LET g_zaa_t.zaa15 = g_zaa_a[l_ac].zaa15
                      END IF
 
                      FOR k = 1 to g_zaa_a.getLength()
                          IF (k <> l_ac) AND g_zaa_a[k].zaa03=g_zaa_a[l_ac].zaa03 AND g_zaa_a[k].zaa18 = g_zaa_a[l_ac].zaa18 THEN
                             LET g_zaa_a[k].zaa18 = g_zaa_t.zaa18
                             # LET g_zaa_a[k].zaa15 = g_zaa_t.zaa15
                             UPDATE zaa_file SET zaa18 = g_zaa_t.zaa18
                              WHERE zaa01 = g_zaa01 AND zaa03 = g_zaa_a[k].zaa03
                                AND zaa04 = g_zaa04 AND zaa02 = g_zaa_a[k].zaa02
                                AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                                AND zaa17 = g_zaa17
                             EXIT FOR
                          END IF
                      END FOR
                      IF p_cmd = "u" THEN
                        UPDATE zaa_file SET zaa18 = g_zaa_a[l_ac].zaa18
                           WHERE zaa01 = g_zaa01 AND zaa02 = g_zaa_t.zaa02
                             AND zaa03 = g_zaa_t.zaa03 AND zaa04 = g_zaa04
                             AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                             AND zaa17 = g_zaa17
                        LET g_zaa_t.zaa18 = g_zaa_a[l_ac].zaa18
                        # LET g_zaa_t.zaa15 = g_zaa_a[l_ac].zaa15
                      END IF
                WHEN 2
                      #FUN-580131
                      FOR k = 1 to g_zaa_a.getLength()
                          IF (k <> l_ac) AND g_zaa_a[k].zaa03=g_zaa_a[l_ac].zaa03
                             AND g_zaa_a[k].zaa18 >= g_zaa_a[l_ac].zaa18
                             AND ((g_zaa_a[k].zaa18 <= g_zaa_t.zaa18) OR
                                  (g_zaa_t.zaa18 <= g_zaa_a[l_ac].zaa18))
                          THEN
                              LET g_zaa_a[k].zaa18 = g_zaa_a[k].zaa18 + 1
                              UPDATE zaa_file SET zaa18 = g_zaa_a[k].zaa18
                                WHERE zaa01 = g_zaa01 AND zaa03 = g_zaa_a[k].zaa03
                                AND zaa04 = g_zaa04 AND zaa02 = g_zaa_a[k].zaa02
                                AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                                AND zaa17 = g_zaa17         #FUN-560079
                          END IF
                      END FOR
                      IF p_cmd = "u" THEN
                        UPDATE zaa_file SET zaa18 = g_zaa_a[l_ac].zaa18
                            WHERE zaa01 = g_zaa01 AND zaa02 = g_zaa_t.zaa02
                            AND zaa03 = g_zaa_t.zaa03 AND zaa04 = g_zaa04
                            AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                            AND zaa17 = g_zaa17         #FUN-560079
                      END IF
                      LET g_zaa_t.zaa18 = g_zaa_a[l_ac].zaa18
                      #END FUN-580131
        END CASE
        CLOSE WINDOW p_zaa_1
        RETURN g_n
 
END FUNCTION
#FUN-580020(end)
FUNCTION zaa_seq_afresh()
   DEFINE k,i               LIKE type_file.num10   #No.FUN-680135 INTEGER
   DEFINE l_zaa02           LIKE zaa_file.zaa02
   DEFINE l_zaa07           LIKE zaa_file.zaa07
   DEFINE l_zaa03           LIKE zaa_file.zaa03
   DEFINE l_sql             LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(900)
   DEFINE l_zaa18           LIKE zaa_file.zaa18    #FUN-650175
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_zaa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT MAX(zaa15) INTO g_zaa_t.zaa15
   FROM zaa_file where zaa01 = g_zaa01 AND zaa04 = g_zaa04
    AND zaa10 = g_zaa10 AND zaa11 = g_zaa11 AND zaa17 = g_zaa17 #FUN-560079
   LET l_sql = "SELECT UNIQUE zaa03 FROM zaa_file ",
                " WHERE zaa01 = '",g_zaa01 CLIPPED,"' ",
                "   AND zaa04 = '",g_zaa04 CLIPPED,"' ",
                "   AND zaa10 = '",g_zaa10 CLIPPED,"' ",
                "   AND zaa11 = '",g_zaa11 CLIPPED,"' ",
                "   AND zaa17 = '",g_zaa17 CLIPPED,"' "   #FUN-560079
   PREPARE p_zaa_prepare4 FROM l_sql           #預備一下
   DECLARE zaa_curs4 CURSOR FOR p_zaa_prepare4
   FOREACH zaa_curs4 INTO l_zaa03       #單身 ARRAY 填充
      FOR k = 1 to g_zaa_t.zaa15
          LET g_sql = "SELECT zaa02,zaa07 FROM zaa_file ",
                        " WHERE zaa01 = '",g_zaa01 CLIPPED,"' ",
                        "   AND zaa04 = '",g_zaa04 CLIPPED,"' ",
                        "   AND zaa10 = '",g_zaa10 CLIPPED,"' ",
                        "   AND zaa11 = '",g_zaa11 CLIPPED,"' ",
                        "   AND zaa17 = '",g_zaa17 CLIPPED,"' ",  #FUN-560079
                        "   AND zaa03 = '",l_zaa03 CLIPPED,"' ",
                        "   AND zaa15 = ", k ,
                        " ORDER BY zaa07"
 
         PREPARE p_zaa_prepare2 FROM g_sql           #預備一下
         DECLARE zaa_curs CURSOR FOR p_zaa_prepare2
         LET i = 0
         FOREACH zaa_curs INTO l_zaa02,l_zaa07       #單身 ARRAY 填充
                  LET i = i + 1
                    UPDATE zaa_file SET zaa07 = i
                     WHERE zaa01 = g_zaa01 AND zaa03 = l_zaa03
                       AND zaa04 = g_zaa04 AND zaa02 = l_zaa02
                       AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                       AND zaa17 = g_zaa17 AND zaa15 = k       #FUN-560079
         END FOREACH
         #FUN-650175
          LET g_sql = "SELECT zaa02,zaa18 FROM zaa_file ",
                        " WHERE zaa01 = '",g_zaa01 CLIPPED,"' ",
                        "   AND zaa04 = '",g_zaa04 CLIPPED,"' ",
                        "   AND zaa10 = '",g_zaa10 CLIPPED,"' ",
                        "   AND zaa11 = '",g_zaa11 CLIPPED,"' ",
                        "   AND zaa17 = '",g_zaa17 CLIPPED,"' ",  
                        "   AND zaa03 = '",l_zaa03 CLIPPED,"' ",
                        "   AND zaa18 IS NOT NULL ",
                        " ORDER BY zaa18"
 
         PREPARE p_zaa18_prepare FROM g_sql           #預備一下
         DECLARE zaa18_curs CURSOR FOR p_zaa18_prepare
         LET i = 0
         FOREACH zaa18_curs INTO l_zaa02,l_zaa18       #單身 ARRAY 填充
                  LET i = i + 1
                    UPDATE zaa_file SET zaa18 = i
                     WHERE zaa01 = g_zaa01 AND zaa03 = l_zaa03
                       AND zaa04 = g_zaa04 AND zaa02 = l_zaa02
                       AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
                       AND zaa17 = g_zaa17                    
         END FOREACH
      END FOR
   END FOREACH
   CALL p_zaa_b_fill(g_wc)                    # 單身
END FUNCTION
 
 #MOD-530271
FUNCTION zaa_zaa08_memo()
DEFINE l_zab05 LIKE zab_file.zab05
               LET g_sql = "SELECT zab05 from zab_file ",
                        " WHERE zab01='",g_zaa_a[g_cnt].zaa08 CLIPPED,"' AND zab04='",g_zaa_a[g_cnt].zaa03,"' "
               DECLARE lcurs_qry2 CURSOR FROM g_sql
               LET g_zaa_a[g_cnt].memo = ""
               FOREACH lcurs_qry2 INTO l_zab05
                  IF g_zaa_a[g_cnt].memo = " " OR g_zaa_a[g_cnt].memo IS NULL THEN
                      LET g_zaa_a[g_cnt].memo = l_zab05
                  ELSE
                      LET g_zaa_a[g_cnt].memo = g_zaa_a[g_cnt].memo, ASCII 10,l_zab05
                  END IF
               END FOREACH
               LET l_zab05 = ""
               DISPLAY g_zaa_a[g_cnt].memo TO formonly.memo
END FUNCTION
 
FUNCTION p_zaa_chkzaa01()
 
 DEFINE li_i1    LIKE type_file.num5    #No.FUN-680135 SMALLINT
 DEFINE li_i2    LIKE type_file.num5    #No.FUN-680135 SMALLINT
 DEFINE lc_zz08  LIKE zz_file.zz08
 DEFINE lc_db    LIKE type_file.chr3    #No.FUN-680135 VARCHAR(3)
 DEFINE ls_str   STRING
 DEFINE lc_zaa01 LIKE zaa_file.zaa01
 
 LET lc_db=cl_db_get_database_type()
  CASE lc_db
     WHEN "ORA"
         LET lc_zz08="%",g_zaa01 CLIPPED,"%"
         SELECT COUNT(*) INTO li_i1 FROM zz_file
          WHERE zz08 LIKE lc_zz08
     WHEN "IFX"
         LET lc_zz08="*",g_zaa01 CLIPPED,"*"
         SELECT COUNT(*) INTO li_i1 FROM zz_file
          WHERE zz08 MATCHES lc_zz08
   END CASE
   SELECT COUNT(*) INTO g_cnt from zz_file where zz01= g_zaa01
   LET g_zaa01_zz ="N"
   IF li_i1 > 0 THEN
      select COUNT(*) INTO g_cnt2 from gak_file where gak01 = g_zaa01
      IF g_cnt2 > 0 THEN
         LET g_zaa01_zz = "Y"
      END IF
      RETURN
   ELSE
      IF (li_i1 = 0 AND g_cnt = 0 )THEN
         LET g_zaa01_zz = "N"
         RETURN
      ELSE
         SELECT zz08 INTO lc_zz08 FROM zz_file WHERE zz01=g_zaa01
         LET ls_str = DOWNSHIFT(lc_zz08) CLIPPED
         LET li_i1 = ls_str.getIndexOf("i/",1)
         LET li_i2 = ls_str.getIndexOf(" ",li_i1)
         IF li_i2 <= li_i1 THEN LET li_i2=ls_str.getLength() END IF
         LET lc_zaa01 = ls_str.subString(li_i1+2,li_i2)
         CALL cl_err_msg(NULL,"azz-060",g_zaa01 CLIPPED|| "|" || lc_zaa01 CLIPPED,10)
         LET g_zaa01 = lc_zaa01 CLIPPED
         LET g_zaa01_zz = "Y"
         DISPLAY g_zaa01 TO zaa01
      END IF
      END IF
END FUNCTION
 
#FUN-560079
FUNCTION p_zaa_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF INFIELD(zaa04) THEN
      IF g_zaa04 = 'default' THEN
         CALL cl_set_comp_entry("zaa04",TRUE)
      END IF
   END IF
   IF INFIELD(zaa17) THEN
      IF g_zaa17 = 'default' THEN
         CALL cl_set_comp_entry("zaa17",TRUE)
      END IF
   END IF
END FUNCTION
 
FUNCTION p_zaa_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   IF INFIELD(zaa04) THEN
      IF p_cmd = 'u' THEN
         IF g_zaa04 = 'default' THEN
            IF g_zaa17 <> 'default' THEN
               CALL cl_set_comp_entry("zaa17",TRUE)
               CALL cl_set_comp_entry("zaa04",FALSE)
            ELSE
               CALL cl_set_comp_entry("zaa17",TRUE)
               CALL cl_set_comp_entry("zaa04",TRUE)
            END IF
         ELSE
            IF g_zaa17 = 'default' THEN
               CALL cl_set_comp_entry("zaa04",TRUE)
               CALL cl_set_comp_entry("zaa17",FALSE)
            END IF
         END IF
      ELSE
         IF p_cmd='a' THEN
            IF NOT cl_null(g_zaa04) AND g_zaa04 <> 'default' THEN
               LET g_zaa17 = 'default'
               CALL cl_set_comp_entry("zaa17",FALSE)
            END IF
         END IF
      END IF
   END IF
 
   IF INFIELD(zaa17) THEN
      IF p_cmd = 'u' THEN
         IF g_zaa17 = 'default' THEN
            IF g_zaa04 <> 'default' THEN
               CALL cl_set_comp_entry("zaa04",TRUE)
               CALL cl_set_comp_entry("zaa17",FALSE)
            ELSE
               CALL cl_set_comp_entry("zaa17",TRUE)
               CALL cl_set_comp_entry("zaa04",TRUE)
            END IF
         ELSE
            IF g_zaa04 = 'default' THEN
               CALL cl_set_comp_entry("zaa17",TRUE)
               CALL cl_set_comp_entry("zaa04",FALSE)
            END IF
         END IF
      ELSE
         IF p_cmd='a' THEN
            IF NOT cl_null(g_zaa17) AND g_zaa17 <> 'default' THEN
               LET g_zaa04 = 'default'
               CALL cl_set_comp_entry("zaa04",FALSE)
            END IF
         END IF
      END IF
   END IF
END FUNCTION
#END FUN-560079
 
 #No.MOD-580056 --start
FUNCTION p_zaa_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("zaa02,zaa03",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_zaa_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("zaa02,zaa03",FALSE)
   END IF
 
END FUNCTION
 #No.MOD-580056 --end
 
#FUN-580131
FUNCTION p_zaa_width()
   DEFINE   l_zaa05  LIKE zaa_file.zaa05,
            l_i      LIKE type_file.num10,   #No.FUN-680135 INTEGER
            l_cnt    LIKE type_file.num10,   #No.FUN-680135 INTEGER
            l_str    STRING,                 #FUN-5A0203
            l_ze03   LIKE ze_file.ze03       #FUN-5A0203
    DISPLAY '' TO FORMONLY.content
 
    #FUN-5A0203
    IF g_zaa11 CLIPPED = "voucher" THEN
         SELECT zz17 INTO g_zaa_width FROM zz_file where zz01=g_zaa01
         IF g_zaa_width = 0 or g_zaa_width is null THEN ### TQC-590051 ###
            LET g_zaa_width = 80
         END IF
 
         SELECT ze03 INTO l_ze03 FROM ze_file
            where ze01='azz-120' AND ze02 = g_lang
         LET l_str = l_ze03
    ELSE
         LET g_sql = "SELECT UNIQUE zaa09,zaa02,zaa03,zaa14,zaa05,zaa06,zaa15,zaa07,zaa18,zaa08 FROM zaa_file ",
                    " WHERE zaa01='",g_zaa01 CLIPPED,
                    "'  AND zaa04='",g_zaa04 CLIPPED,
                    "'  AND zaa17='",g_zaa17 CLIPPED,
                    "'  AND zaa10='",g_zaa10 CLIPPED,
                    "'  AND zaa11='",g_zaa11 CLIPPED,
                    "'  AND zaa09='2' ORDER BY zaa02,zaa03"
 
         PREPARE zaa_title_prepare FROM g_sql          # 預備一下
         DECLARE zaa_title_curs                      # 宣告成可捲動的
           SCROLL CURSOR WITH HOLD FOR zaa_title_prepare
 
         CALL g_zaa_b.clear()
 
         LET l_cnt = 1
         FOREACH zaa_title_curs INTO g_zaa_b[l_cnt].zaa09,g_zaa_b[l_cnt].zaa02,g_zaa_b[l_cnt].zaa03,
                                   g_zaa_b[l_cnt].zaa14,g_zaa_b[l_cnt].zaa05,g_zaa_b[l_cnt].zaa06,
                                   g_zaa_b[l_cnt].zaa15,g_zaa_b[l_cnt].zaa07,g_zaa_b[l_cnt].zaa18,
                                   g_zaa_b[l_cnt].zaa08
 
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH:',SQLCA.sqlcode,1)  
               EXIT FOREACH
            END IF
            LET l_cnt = l_cnt + 1
         END FOREACH
         CALL g_zaa_b.deleteElement(l_cnt)
 
         CALL cl_view_report(g_zaa_b) RETURNING l_str,g_zaa_width
 
        #SELECT MAX(zaa15) INTO g_line_seq FROM zaa_file   ## 計算行序
        #WHERE zaa01 = g_zaa01 AND zaa03 = g_rlang AND zaa10= g_zaa10 AND
        #      zaa11 = g_zaa11 AND zaa04 = g_zaa04 AND zaa09='2' AND
        #      zaa06='N' AND zaa17 = g_zaa17
 
        #LET g_sql="SELECT zaa05 FROM zaa_file ",
        #          "WHERE zaa01= '",g_zaa01 CLIPPED,"' AND zaa03 = '",g_rlang,"'",
        #          "  AND zaa04= '",g_zaa04 CLIPPED,"' AND zaa09='2'",
        #          "  AND zaa10='", g_zaa10 CLIPPED,"' AND zaa11='",g_zaa11,
        #          "' AND zaa17='", g_zaa17 CLIPPED,"' AND zaa06= 'N' ",
        #          "  AND zaa15= ? ORDER BY zaa07"
        #PREPARE zaa_pre5 FROM g_sql
        #DECLARE zaa_cur5 CURSOR FOR zaa_pre5
        #LET g_zaa_width = 0
        ##多行列印
        #FOR l_i = 1 TO g_line_seq
        #    LET l_cnt = 0
        #    OPEN zaa_cur5 USING l_i
        #    FOREACH zaa_cur5 INTO l_zaa05
        #           LET l_cnt = l_cnt + l_zaa05 + 1
        #    END FOREACH
        #     CLOSE zaa_cur5                              #MOD-580254
        #    IF l_cnt> g_zaa_width THEN
        #       LET g_zaa_width = l_cnt - 1
        #    END IF
        #END FOR
    END IF
 
    DISPLAY l_str TO FORMONLY.content
 
    #END FUN-5A0203
    LET g_zaa_width = g_zaa_width + g_zaa19    #FUN-650017
 
    DISPLAY g_zaa_width TO zaawidth
END FUNCTION
#END FUN-580131
 
#報表連查menu入口
FUNCTION p_zaa_link_menu()
   OPEN WINDOW p_zaa_d AT 8,23 WITH FORM "azz/42f/p_zaa_d"
         ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_locale("p_zaa_d")
   LET g_zaa_ac = l_ac #傳入zaa的array pointer
   WHILE TRUE
      CALL p_zaa_link_bp("G")
      CASE g_action_choice
         WHEN "exit"           # Esc.結束
            LET INT_FLAG=FALSE 		
            EXIT WHILE
         WHEN "detail"
            CALL p_zad_b()
         WHEN "controlg" # KEY(CONTROL-G)
            CALL cl_cmdask()
      END CASE
   END WHILE
   CLOSE WINDOW p_zaa_d
END FUNCTION
 
FUNCTION p_zaa_link_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL p_zad_count() #傳入zaa單身
   DISPLAY ARRAY g_zad TO s_zad.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(mi_curs_index, g_row_count_zad)
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION exit    # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#TQC-860017 start
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                CONTINUE DISPLAY
#TQC-860017 end
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION p_zad_b()
   DEFINE   l_ac_t          LIKE type_file.num5,     # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,     # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,     # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,     # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,     #No.FUN-680135      SMALLINT
            l_allow_delete  LIKE type_file.num5      #No.FUN-680135      SMALLINT
 
   LET g_forupd_sql= "SELECT zad08,zad09,zad10,zad11",
                     "  FROM zad_file",
                     "  WHERE zad01 = ?",
                     "   AND zad02 = ?",
                     "   AND zad03 = ?",
                     "   AND zad04 = ?",
                     "   AND zad05 = ?",
                     "   AND zad06 = ?",
                     "   AND zad07 = ?",
                     "   AND zad08 = ?",
                     "   FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zad_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
 
   INPUT ARRAY g_zad WITHOUT DEFAULTS FROM s_zad.*
              ATTRIBUTE(COUNT=g_zad_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_zad_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_zad_b >= l_ac THEN
            LET g_zad_t.* = g_zad[l_ac].*    #BACKUP
            BEGIN WORK
            LET p_cmd='u'
            OPEN p_zad_bcl USING g_zaa01,g_zaa_a[g_zaa_ac].zaa02,g_zaa_a[g_zaa_ac].zaa03
                                ,g_zaa04,g_zaa10,g_zaa11,g_zaa17,g_zad_t.zad08
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_zad_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_zad_bcl INTO g_zad[l_ac].zad08,g_zad[l_ac].zad09,g_zad[l_ac].zad10
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_zaa01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL cl_set_comp_entry("zad11", TRUE)
               IF g_zad[l_ac].zad09 = '2' THEN
                  CALL cl_set_comp_entry("zad11", FALSE)
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            DELETE FROM zad_file
              WHERE zad01 = g_zaa01
                AND zad02= g_zaa_a[g_zaa_ac].zaa02
                AND zad03= g_zaa_a[g_zaa_ac].zaa03
                AND zad04= g_zaa04
                AND zad05= g_zaa10
                AND zad06= g_zaa11
                AND zad07= g_zaa17
                AND zad08 = g_zad[l_ac].zad08
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_zad[l_ac].zad08,SQLCA.sqlcode,0)   #No.FUN-660081
               CALL cl_err3("del","zad_file",g_zaa01,g_zaa_a[g_zaa_ac].zaa02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_zad_b = g_zad_b-1
            COMMIT WORK
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zad[l_ac].* TO NULL
         LET g_zad_t.* = g_zad[l_ac].*
         NEXT FIELD zad08
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO zad_file(zad01,zad02,zad03,zad04,zad05
                             ,zad06,zad07,zad08,zad09,zad10,zad11)
             VALUES (g_zaa01,g_zaa_a[g_zaa_ac].zaa02,g_zaa_a[g_zaa_ac].zaa03,
                     g_zaa04,g_zaa10,g_zaa11,
                     g_zaa17,g_zad[l_ac].zad08,g_zad[l_ac].zad09,
                     g_zad[l_ac].zad10, g_zad[l_ac].zad11)
 
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_zaa01,SQLCA.sqlcode,0)   #No.FUN-660081
            CALL cl_err3("ins","zad_file",g_zaa01,g_zaa_a[g_zaa_ac].zaa02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
	    LET g_zad_b = g_zad_b + 1
            COMMIT WORK
         END IF
 
      BEFORE FIELD zad08  #default 序號
         IF g_zad[l_ac].zad08 IS NULL THEN
            SELECT max(zad08)+1 INTO g_zad[l_ac].zad08
              FROM zad_file
             WHERE zad01 = g_zaa01
               AND zad02= g_zaa_a[g_zaa_ac].zaa02
               AND zad03= g_zaa_a[g_zaa_ac].zaa03
               AND zad04= g_zaa04
               AND zad05= g_zaa10
               AND zad06= g_zaa11
               AND zad07= g_zaa17
 
             IF g_zad[l_ac].zad08 IS NULL THEN
                LET g_zad[l_ac].zad08 = 1
             END IF
         END IF
 
      AFTER FIELD zad09
         CALL cl_set_comp_entry("zad11", TRUE)
         IF g_zad[l_ac].zad09 = '2' THEN
            CALL cl_set_comp_entry("zad11", FALSE)
         END IF
      
      AFTER FIELD zad10
         IF NOT cl_null(g_zad[l_ac].zad10) THEN
            IF g_zad[l_ac].zad10 != g_zad_t.zad10 OR
               g_zad_t.zad10 is null THEN
               SELECT count(*) INTO l_n FROM zad_file
               WHERE zad01 = g_zaa01
                AND zad02= g_zaa_a[g_zaa_ac].zaa02
                AND zad03= g_zaa_a[g_zaa_ac].zaa03
                AND zad04= g_zaa04
                AND zad05= g_zaa10
                AND zad06= g_zaa11
                AND zad07= g_zaa17
                AND zad09 = g_zad[l_ac].zad09
                AND zad10 = g_zad[l_ac].zad10
 
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_zad[l_ac].zad10 = g_zad_t.zad10
                   NEXT FIELD zad10
                END IF
            END IF
            CALL zad10_memo()
            IF g_zad10_err=-1 THEN
               NEXT FIELD zad10
            ELSE
               DISPLAY BY NAME g_zad[l_ac].memo
            END IF
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zad[l_ac].* = g_zad_t.*
            CLOSE p_zad_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zaa01,-263,1)
            LET g_zad[l_ac].* = g_zad_t.*
         ELSE
            UPDATE zad_file
               SET zad08 = g_zad[l_ac].zad08,
                   zad09 = g_zad[l_ac].zad09,
                   zad10 = g_zad[l_ac].zad10,
                   zad11 = g_zad[l_ac].zad11
             WHERE zad01 = g_zaa01
               AND zad02 = g_zaa_a[g_zaa_ac].zaa02
               AND zad03 = g_zaa_a[g_zaa_ac].zaa03
               AND zad04 = g_zaa04
               AND zad05 = g_zaa10
               AND zad06 = g_zaa11
               AND zad07 = g_zaa17
               AND zad08 = g_zad_t.zad08
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_zaa01,SQLCA.sqlcode,0)   #No.FUN-660081
               CALL cl_err3("upd","zad_file",g_zaa01,g_zaa_a[g_zaa_ac].zaa02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zad[l_ac].* = g_zad_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_zad[l_ac].* = g_zad_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_zad.deleteElement(l_ac)
               IF g_zad_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE p_zad_bcl
            ROLLBACK WORK
            EXIT INPUT
          END IF
          LET l_ac_t = l_ac    #FUN-D30034 Add
          CLOSE p_zad_bcl
          COMMIT WORK
 
       ON ACTION controlp
         CASE
            WHEN INFIELD(zad10)
               IF g_zad[l_ac].zad09='1' THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zz"
                  LET g_qryparam.arg1 =  g_lang
                  LET g_qryparam.default1= g_zad[l_ac].zad10
                  CALL cl_create_qry() RETURNING g_zad[l_ac].zad10
                  DISPLAY g_zad[l_ac].zad10 TO zad10
                  CALL zad10_memo()
                  DISPLAY BY NAME g_zad[l_ac].memo
                  NEXT FIELD zad10
               END IF
               IF g_zad[l_ac].zad09='2' THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zae"
                  LET g_qryparam.default1= g_zad[l_ac].zad10
                  CALL cl_create_qry() RETURNING g_zad[l_ac].zad10
                  DISPLAY g_zad[l_ac].zad10 TO zad10
                  CALL zad10_memo()
                  DISPLAY BY NAME g_zad[l_ac].memo
                  NEXT FIELD zad10
               END IF
             OTHERWISE
               EXIT CASE
         END CASE
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("grid01","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
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
 
FUNCTION p_zad_count()
   DEFINE l_lang LIKE gay_file.gay03
   LET g_sql= "SELECT zad08,zad09,zad10,zad11 FROM zad_file",
              " WHERE zad01='", g_zaa01 CLIPPED,"'",
              " AND zad02=", g_zaa_a[g_zaa_ac].zaa02 ,
              " AND zad03='", g_zaa_a[g_zaa_ac].zaa03 ,"'",
              " AND zad04='", g_zaa04 ,"'",
              " AND zad05='", g_zaa10 ,"'",
              " AND zad06='", g_zaa11 ,"'",
              " AND zad07='", g_zaa17 ,"'",
              " ORDER BY zad08"
 
   DISPLAY g_zaa_a[g_zaa_ac].zaa02 TO zaa02
   SELECT gay03 INTO l_lang  FROM gay_file
    WHERE gay01 = g_zaa_a[g_zaa_ac].zaa03 AND gayacti="Y" #AND gay02 = g_lang #FUN-830021
 
   DISPLAY l_lang TO zaa03
 
   DISPLAY g_zaa_a[g_zaa_ac].zaa08 TO zaa08
   DISPLAY g_zaa01 TO zaa01
   DISPLAY g_gaz03 TO gaz03
   DISPLAY g_zaa04 TO zaa04
   DISPLAY g_zaa10 TO zaa10
   DISPLAY g_zaa11 TO zaa11
   DISPLAY g_zaa17 TO zaa17
 
   PREPARE p_zad_precount FROM g_sql
   DECLARE p_zad_count CURSOR FOR p_zad_precount
   LET g_cnt=1
   LET g_zad_b=0
   CALL g_zad.clear()
   FOREACH p_zad_count INTO g_zad[g_cnt].zad08,g_zad[g_cnt].zad09,g_zad[g_cnt].zad10,g_zad[g_cnt].zad11
       LET g_zad_b = g_zad_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1) 
          LET g_zad_b = g_zad_b - 1
          EXIT FOREACH
       END IF
 
       IF  g_zad[g_cnt].zad09='1' THEN
           SELECT gaz03 INTO g_zad[g_cnt].memo FROM gaz_file
            WHERE gaz01= g_zad[g_cnt].zad10
              AND gaz02= g_lang
       END IF
 
       IF  g_zad[g_cnt].zad09='2' THEN
           SELECT distinct zae02 INTO g_zad[g_cnt].memo FROM zae_file
            WHERE zae01= g_zad[g_cnt].zad10
       END IF
       LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_zad.deleteElement(g_cnt)
   LET g_zad_b = g_cnt - 1
   LET g_cnt = 0
   LET g_row_count_zad =g_zad_b
END FUNCTION
 
FUNCTION zad09_check(l_row)
   DEFINE l_row  LIKE type_file.num10   #No.FUN-680135 INTEGER
   DEFINE l_cnt  LIKE type_file.num10   #No.FUN-680135 INTEGER
   LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM zad_file
     WHERE zad01= g_zaa01
       AND zad02= g_zaa_a[l_row].zaa02
       AND zad03= g_zaa_a[l_row].zaa03
       AND zad04= g_zaa04
       AND zad05= g_zaa10
       AND zad06= g_zaa11
       AND zad07= g_zaa17
 
    IF l_cnt >  0 THEN
       LET g_zaa_a[l_row].zad09 = "Y"
       DISPLAY g_zaa_a[l_row].zad09 TO FORMONLY.zad09
    ELSE
       LET g_zaa_a[l_row].zad09 = null
       DISPLAY g_zaa_a[l_row].zad09 TO FORMONLY.zad09
    END IF
END FUNCTION
 
FUNCTION zad10_memo()
    LET g_zad10_err = 0
         IF  g_zad[l_ac].zad09='1' THEN
             SELECT gaz03 INTO g_zad[l_ac].memo FROM gaz_file
              WHERE gaz01= g_zad[l_ac].zad10
                AND gaz02= g_lang
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_zad[l_ac].zad10,'azz-052',1)   #No.FUN-660081
               CALL cl_err3("sel","gaz_file",g_zad[l_ac].zad10,g_lang,"azz-052","","",1)    #No.FUN-660081
               LET g_zad10_err = -1
            END IF
 
            IF cl_null(g_zad[l_ac].zad11) THEN
               SELECT zad11 INTO g_zad[l_ac].zad11 FROM zad_file
                WHERE zad10= g_zad[l_ac].zad10
                  AND zad09= '1'
            END IF
 
         END IF
 
         IF  g_zad[l_ac].zad09='2' THEN
             SELECT distinct zae02 INTO g_zad[l_ac].memo FROM zae_file
             WHERE zae01= g_zad[l_ac].zad10
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_zad[l_ac].zad10,'azz-800',1)   #No.FUN-660081
               CALL cl_err3("sel","zae_file",g_zad[l_ac].zad10,"","azz-800","","",1)    #No.FUN-660081
               LET g_zad10_err = -1
            END IF
         END IF
END FUNCTION
 
FUNCTION p_zaa_zaa18_check()
DEFINE l_num LIKE type_file.num10   #No.FUN-680135 INTEGER
 
  #FUN-580020
  IF g_zaa_a[l_ac].zaa15 < 2 THEN
     LET l_num = 0
     SELECT MAX(zaa15) INTO l_num FROM zaa_file 
      WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04
        AND zaa10 = g_zaa10 AND zaa11 = g_zaa11 
        AND zaa17 = g_zaa17 AND zaa03 = g_zaa_a[l_ac].zaa03 #FUN-650175   
     IF l_num > 1 THEN
         CALL cl_set_comp_entry("zaa18",TRUE)
         #FUN-650175
         IF g_zaa_a[l_ac].zaa18 IS NULL OR g_zaa_a[l_ac].zaa18 = 0 THEN 
            SELECT MAX(zaa18)+1 INTO g_zaa_a[l_ac].zaa18 FROM zaa_file
             WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04
               AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
               AND zaa17 = g_zaa17 AND zaa03 = g_zaa_a[l_ac].zaa03 #FUN-650175   
            IF g_zaa_a[l_ac].zaa18 IS NULL THEN
                LET g_zaa_a[l_ac].zaa18 = 1
            END IF
         END IF
         #END FUN-650175
     ELSE
        INITIALIZE g_zaa_a[l_ac].zaa18 TO NULL
        CALL cl_set_comp_entry("zaa18",FALSE)
     END IF
  ELSE
     #FUN-650175
     IF g_zaa_a[l_ac].zaa18 IS NULL OR g_zaa_a[l_ac].zaa18 = 0 THEN 
        SELECT MAX(zaa18)+1 INTO g_zaa_a[l_ac].zaa18 FROM zaa_file
         WHERE zaa01 = g_zaa01 AND zaa04 = g_zaa04
           AND zaa10 = g_zaa10 AND zaa11 = g_zaa11
           AND zaa17 = g_zaa17 AND zaa03 = g_zaa_a[l_ac].zaa03 #FUN-650175   
        IF g_zaa_a[l_ac].zaa18 IS NULL THEN
            LET g_zaa_a[l_ac].zaa18 = 1
        END IF
     END IF
     #END FUN-650175
     CALL cl_set_comp_entry("zaa18",TRUE)
  END IF
END FUNCTION
#Patch....NO.MOD-5A0095 <001> #
