# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmi712.4gl
# Descriptions...: 銀行合約條款及摘要維護作業
# Date & Author..: 98/10/29 by plum
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-590002 05/09/05 By vivien  查詢時欄位修改
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6A0011 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-710112 07/03/27 By Judy 項次不可為空
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.TQC-960315 09/06/23 By hongmei 合約編號相同,項次不同，只顯示第一筆
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C90227 12/09/28 By Polly 增加舊值清空動作
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_nnq01         LIKE nnq_file.nnq01,         #合約號碼 (假單頭) #TQC-840066
    g_nnq02         LIKE nnq_file.nnq02,         #合約項次 (假單頭)
    g_nnq01_t       LIKE nnq_file.nnq01,         #合約號碼   (舊值)
    g_nnq02_t       LIKE nnq_file.nnq02,         #合約項次   (舊值)
    l_cnt           LIKE type_file.num5,         #No.FUN-680107 SMALLINT
    l_cnt1          LIKE type_file.num5,         #No.FUN-680107 SMALLINT
    l_cmd           LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(100)
    g_nnq           DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
        nnq03       LIKE nnq_file.nnq03,         #行序
        nnq04       LIKE nnq_file.nnq04,         #限制條款
        nnq05       LIKE nnq_file.nnq05          #摘要性質
                    END RECORD,
    g_nnq_t         RECORD                       #程式變數 (舊值)
        nnq03       LIKE nnq_file.nnq03,         #行序
        nnq04       LIKE nnq_file.nnq04,         #限制條款
        nnq05       LIKE nnq_file.nnq05          #摘要性質
                    END RECORD,
    g_nnq04_o       LIKE nnq_file.nnq04,
  g_wc,g_wc2,g_sql  STRING,                      #No.FUN-580092 HCN 
    g_rec_b         LIKE type_file.num5,         #單身筆數 #No.FUN-680107 SMALLINT
    g_ss            LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
    g_succ          LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
    g_argv1         LIKE nnq_file.nnq01,
    g_argv2         LIKE nnq_file.nnq02,
    l_za05          LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(40)
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING                       #SELECT ... FOR UPDATE SQL 
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680107 SMALLINT
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_temp       STRING                       #No.TQC-960315 add
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
   OPTIONS                                       #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                               #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
   LET g_nnq01 = NULL                     #清除鍵值
   LET g_nnq02 = NULL                     #清除鍵值
   LET g_nnq01_t = NULL
   LET g_nnq02_t = NULL
   #取得參數
   LET g_argv1=ARG_VAL(1)       #合約號碼
   LET g_argv2=ARG_VAL(2)       #合約號碼:單身之項次
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW i712_w AT p_row,p_col
       WITH FORM "anm/42f/anmi712"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
   IF NOT cl_null(g_argv1) THEN
      CALL i712_q()
   END IF
 
   CALL i712_menu()
   CLOSE WINDOW i712_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
END MAIN
 
FUNCTION i712_cs()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc=" nnq01='",g_argv1,"'"
      IF not cl_null(g_argv2) THEN
         LET g_wc = g_wc clipped, " AND nnq02=",g_argv2
      END IF
   ELSE
      CLEAR FORM                             #清除畫面
      CALL g_nnq.clear()
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_nnq01 TO NULL    #No.FUN-750051
   INITIALIZE g_nnq02 TO NULL    #No.FUN-750051
      CONSTRUCT g_wc ON nnq01,nnq02,nnq03,nnq04,nnq05    #螢幕上取條件
         FROM nnq01,nnq02,s_nnq[1].nnq03,s_nnq[1].nnq04,s_nnq[1].nnq05
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON ACTION controlp
            CASE
               WHEN INFIELD(nnq01)
#                 CALL q_nnp1(10,3,g_nnq01) RETURNING g_nnq01,g_nnq02
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nnp1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_nnq01
#No.MOD-590002 --start
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnq01
#No.MOD-590002 --end
                  CALL i712_nnq01('1')
                  NEXT FIELD nnq01
               WHEN INFIELD(nnq02)
#                 CALL q_nnp1(10,3,g_nnq01) RETURNING g_nnq01,g_nnq02
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nnp1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_nnq01
                  CALL cl_create_qry() RETURNING g_nnq01,g_nnq02
                  DISPLAY BY NAME g_nnq01,g_nnq02
                  CALL i712_nnq01('2')
                  NEXT FIELD nnq02
               OTHERWISE
            END CASE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
   LET g_sql="SELECT UNIQUE nnq01,nnq02 FROM nnq_file ", # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED,
              " ORDER BY nnq01,nnq02"
   PREPARE i712_prepare FROM g_sql      #預備一下
   DECLARE i712_bcs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i712_prepare
 
#  LET g_sql="SELECT UNIQUE nnq01,nnq02 ",
#TQC-960315---Begin
#  LET g_sql="SELECT COUNT(DISTINCT nnq01) ",
#            "  FROM nnq_file WHERE ", g_wc CLIPPED
   LET g_temp="SELECT DISTINCT nnq01,nnq02 from nnq_file",
              " WHERE ",g_wc CLIPPED," INTO TEMP x"
   DROP TABLE x                                                                 
   PREPARE i712_pre_x FROM g_temp                                               
   EXECUTE i712_pre_x                                                           
   LET g_sql="SELECT COUNT(*) FROM x"                                           
#TQC-960315---End
   PREPARE i712_precount FROM g_sql
   DECLARE i712_count CURSOR FOR i712_precount
 
END FUNCTION
 
FUNCTION i712_menu()
 
   WHILE TRUE
      CALL i712_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i712_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i712_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i712_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i712_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i712_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nnq),'','')
            END IF
         #No.FUN-6A0011-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_nnq01 IS NOT NULL THEN
                LET g_doc.column1 = "nnq01"
                LET g_doc.column2 = "nnq02"
                LET g_doc.value1 = g_nnq01
                LET g_doc.value2 = g_nnq02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0011-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i712_a()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_nnq.clear()
   INITIALIZE g_nnq01 LIKE nnq_file.nnq01
   INITIALIZE g_nnq02 LIKE nnq_file.nnq02
   LET g_nnq01=g_argv1
   LET g_nnq02=g_argv2
   LET g_nnq01_t = NULL
   LET g_nnq02_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i712_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_rec_b = 0
      DISPLAY g_rec_b TO FORMONLY.cn2
 
      CALL i712_b()                      #輸入單身
 
      LET g_nnq01_t = g_nnq01            #保留舊值
      LET g_nnq02_t = g_nnq02            #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i712_u()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nnq01 IS NULL OR g_nnq02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_nnq01_t = g_nnq01
   LET g_nnq02_t = g_nnq02
 
   WHILE TRUE
      CALL i712_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET g_nnq01=g_nnq01_t
         LET g_nnq02=g_nnq02_t
         DISPLAY g_nnq01,g_nnq02 TO nnq01,nnq02  #單頭
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_nnq01 != g_nnq01_t OR g_nnq02 != g_nnq02_t THEN #更改單頭值
         UPDATE nnq_file SET nnq01 = g_nnq01,  #更新DB
                             nnq02 = g_nnq02
          WHERE nnq01 = g_nnq01_t          #COLAUTH?
            AND nnq02 = g_nnq02_t
         IF SQLCA.sqlcode THEN
            LET g_msg = g_nnq01 CLIPPED,' + ', g_nnq02 CLIPPED
#           CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("upd","nnq_file",g_nnq01_t,g_nnq02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
         END IF
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i712_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改  #No.FUN-680107 VARCHAR(1)
   l_nnq04         LIKE nnq_file.nnq04
 
   LET g_ss='Y'
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT g_nnq01,g_nnq02 WITHOUT DEFAULTS FROM nnq01,nnq02
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i712_set_entry(p_cmd)
         CALL i712_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD nnq01                # 合約號碼
         IF NOT cl_null(g_nnq01) THEN
            IF g_nnq01 != g_nnq01_t OR g_nnq01_t IS NULL THEN
               LET g_errno=' '
               CALL i712_nnq01('1')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nnq01,g_errno,0)
                  LET g_nnq01 = g_nnq01_t
                  DISPLAY g_nnq01 TO nnq01
                  NEXT FIELD nnq01
               END IF
            END IF
         END IF
 
      AFTER FIELD nnq02                # 合約項次
         IF NOT cl_null(g_nnq02) THEN
            IF g_nnq02 IS NOT NULL AND   # 若輸入或更改且改KEY
               (g_nnq01!=g_nnq01_t OR g_nnq02!=g_nnq02_t OR g_nnq02_t IS NULL)   THEN
               CALL i712_nnq01('2')
 
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nnq02,g_errno,0)
                  LET g_nnq02 = g_nnq02_t
                  DISPLAY g_nnq02 TO nnq02
                  NEXT FIELD nnq02
               END IF
 
               SELECT count(*) INTO g_cnt FROM nnq_file
                WHERE nnq01 = g_nnq01 AND nnq02 = g_nnq02
               IF g_cnt > 0 THEN        #資料重複
                  LET g_msg = g_nnq01 CLIPPED,' + ', g_nnq02 CLIPPED
                  CALL cl_err(g_msg,-239,0)
                  LET g_nnq01 = g_nnq01_t
                  LET g_nnq02 = g_nnq02_t
                  DISPLAY g_nnq01 TO nnq01
                  DISPLAY g_nnq02 TO nnq02
                  NEXT FIELD nnq01
               END IF
            END IF
         END IF
#TQC-710112.....begin
         IF cl_null(g_nnq02) THEN 
            CALL cl_err(g_nnq02,'anm-003',0)
            NEXT FIELD nnq02
         END IF
#TQC-710112.....end
      ON ACTION controlp
         CASE
            WHEN INFIELD(nnq01)
#              CALL q_nnp1(10,3,g_nnq01) RETURNING g_nnq01,g_nnq02
#              CALL FGL_DIALOG_SETBUFFER( g_nnq01 )
#              CALL FGL_DIALOG_SETBUFFER( g_nnq02 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nnp1"
               LET g_qryparam.default1 = g_nnq01
               CALL cl_create_qry() RETURNING g_nnq01,g_nnq02
#               CALL FGL_DIALOG_SETBUFFER( g_nnq01 )
#               CALL FGL_DIALOG_SETBUFFER( g_nnq02 )
               DISPLAY BY NAME g_nnq01,g_nnq02
               CALL i712_nnq01('1')
               NEXT FIELD nnq01
            WHEN INFIELD(nnq02)
#              CALL q_nnp1(10,3,g_nnq01) RETURNING g_nnq01,g_nnq02
#              CALL FGL_DIALOG_SETBUFFER( g_nnq01 )
#              CALL FGL_DIALOG_SETBUFFER( g_nnq02 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nnp1"
               LET g_qryparam.default1 = g_nnq01
               CALL cl_create_qry() RETURNING g_nnq01,g_nnq02
#               CALL FGL_DIALOG_SETBUFFER( g_nnq01 )
#               CALL FGL_DIALOG_SETBUFFER( g_nnq02 )
               DISPLAY BY NAME g_nnq01,g_nnq02
               CALL i712_nnq01('2')
               NEXT FIELD nnq02
            OTHERWISE
         END CASE
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
 
END FUNCTION
 
FUNCTION i712_nnq01(p_cmd)  #p_cmd='1': 合約 ,p_cmd='2':合約項次
    DEFINE p_cmd     LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
           l_nnq01   LIKE nnq_file.nnq01,
           l_nnq02   LIKE nnq_file.nnq02
 
    LET g_errno = ' '
 
    IF p_cmd ='1' THEN
       SELECT nno01 FROM nno_file
        WHERE nno01=g_nnq01 AND nnoacti='Y'
          AND nno09='N'  #NO:4417
    ELSE
       SELECT nnp01,nnp02  FROM nno_file,nnp_file
        WHERE nno01=nnp01 AND nno01 = g_nnq01 AND nnoacti='Y'
          AND nnp02=g_nnq02 AND nno09='N'  #NO:4417
    END IF
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-603'
                            LET l_nnq01 = NULL  LET l_nnq02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i712_q()
  DEFINE l_nnq01  LIKE nnq_file.nnq01,
         l_nnq02  LIKE nnq_file.nnq02,
         l_cnt    LIKE type_file.num10    #No.FUN-680107 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nnq01 TO NULL               #No.FUN-6A0011
    INITIALIZE g_nnq02 TO NULL               #No.FUN-6A0011
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL i712_cs()                            #取得查詢條件
 
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_nnq01 TO NULL
      INITIALIZE g_nnq02 TO NULL
      RETURN
   END IF
 
   OPEN i712_bcs                             #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                     #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_nnq01 TO NULL
      INITIALIZE g_nnq02 TO NULL
   ELSE
      CALL i712_fetch('F')                   #讀出TEMP第一筆並顯示
      OPEN i712_count
      FETCH i712_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
#     LET l_cnt = 0                #顯示合乎條件筆數
#     FOREACH i712_count INTO l_nnq01,l_nnq02
#        LET l_cnt = l_cnt + 1
#     END FOREACH
#     DISPLAY l_cnt TO FORMONLY.cnt
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i712_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,    #處理方式   #No.FUN-680107 VARCHAR(1)
   l_abso          LIKE type_file.num10    #絕對的筆數 #No.FUN-680107 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i712_bcs INTO g_nnq01,g_nnq02
      WHEN 'P' FETCH PREVIOUS i712_bcs INTO g_nnq01,g_nnq02
      WHEN 'F' FETCH FIRST    i712_bcs INTO g_nnq01,g_nnq02
      WHEN 'L' FETCH LAST     i712_bcs INTO g_nnq01,g_nnq02
      WHEN '/'
            IF (NOT mi_no_ask) THEN
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
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i712_bcs INTO g_nnq01,g_nnq02
            LET mi_no_ask = FALSE
   END CASE
 
   LET g_succ='Y'
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_nnq01,SQLCA.sqlcode,0)
      INITIALIZE g_nnq01 TO NULL  #TQC-6B0105
      INITIALIZE g_nnq02 TO NULL  #TQC-6B0105
      LET g_succ='N'
   ELSE
      CALL i712_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
FUNCTION i712_show()
 
   DISPLAY g_nnq01 TO nnq01      #單頭
   DISPLAY g_nnq02 TO nnq02      #單頭
 
   CALL i712_b_fill(g_wc)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i712_r()
 
   IF s_anmshut(0) THEN RETURN END IF                #檢查權限
 
   IF g_nnq01 IS NULL THEN
      CALL cl_err("",-400,0)                 #No.FUN-6A0011
      RETURN
   END IF
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nnq01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "nnq02"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nnq01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_nnq02       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM nnq_file WHERE nnq01 = g_nnq01 AND nnq02 = g_nnq02
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660148
         CALL cl_err3("del","nnq_file",g_nnq01,g_nnq02,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660148
      ELSE
         CLEAR FORM
         CALL g_nnq.clear()
         LET g_nnq01 = NULL
         LET g_nnq02 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN i712_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i712_bcs
            CLOSE i712_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i712_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i712_bcs
            CLOSE i712_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i712_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i712_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i712_fetch('/')
         END IF
      END IF
   END IF
 
END FUNCTION
 
#單身
FUNCTION i712_b()
DEFINE
   l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
   l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680107 SMALLINT
   l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680107 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680107 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680107 SMALLINT
   l_allow_delete  LIKE type_file.num5     #可刪除否          #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
   IF s_anmshut(0) THEN RETURN END IF                #檢查權限
 
   IF g_nnq01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT nnq03,nnq04,nnq05 FROM nnq_file",
                      " WHERE nnq01=? AND nnq02=? AND nnq03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i712_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nnq WITHOUT DEFAULTS FROM s_nnq.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
       IF g_rec_b!=0 THEN
         CALL fgl_set_arr_curr(l_ac)
       END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
        #LET g_nnq_t.* = g_nnq[l_ac].*      #BACKUP
        #LET g_nnq04_o = g_nnq[l_ac].nnq04  #BACKUP
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_nnq_t.* = g_nnq[l_ac].*      #BACKUP
            LET g_nnq04_o = g_nnq[l_ac].nnq04  #BACKUP
            BEGIN WORK
            OPEN i712_bcl USING g_nnq01,g_nnq02,g_nnq_t.nnq03
            IF STATUS THEN
               CALL cl_err("OPEN i712_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i712_bcl INTO g_nnq[l_ac].*
               IF SQLCA.sqlcode THEN
                 CALL cl_err(g_nnq_t.nnq03,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
        #NEXT FIELD nnq03
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_nnq[l_ac].* TO NULL      #900423
         LET g_nnq_t.* = g_nnq[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD nnq03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
           #CALL g_nnq.deleteElement(l_ac)   #取消 Array Element
           #IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
           #   LET g_action_choice = "detail"
           #   LET l_ac = l_ac_t
           #END IF
           #EXIT INPUT
         END IF
          INSERT INTO nnq_file (nnq01,nnq02,nnq03,nnq04,nnq05)  #No.MOD-470041
              VALUES(g_nnq01,g_nnq02,g_nnq[l_ac].nnq03,g_nnq[l_ac].nnq04,
                     g_nnq[l_ac].nnq05)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nnq[l_ac].nnq03,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","nnq_file",g_nnq01,g_nnq02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
           #LET g_nnq[l_ac].* = g_nnq_t.*
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD nnq03
        IF p_cmd='a' THEN
           SELECT max(nnq03)+1 INTO g_nnq[l_ac].nnq03
             FROM nnq_file
            WHERE nnq01 = g_nnq01 AND nnq02 = g_nnq02
            IF g_nnq[l_ac].nnq03 IS NULL THEN
                LET g_nnq[l_ac].nnq03 = 1
            END IF
            DISPLAY g_nnq[l_ac].nnq03 TO nnq03
       END IF
 
     AFTER FIELD nnq03                        #check 序號是否重複
        IF NOT cl_null(g_nnq[l_ac].nnq03) THEN
           IF p_cmd='a' OR  ( g_nnq[l_ac].nnq03 != g_nnq_t.nnq03) THEN
              SELECT count(*) INTO l_n FROM nnq_file
                WHERE nnq01 = g_nnq01
                  AND nnq02 = g_nnq02
                  AND nnq03 = g_nnq[l_ac].nnq03
               IF l_n > 0 THEN
                  CALL cl_err(g_nnq[l_ac].nnq03,-239,0)
                  LET g_nnq[l_ac].nnq03 = g_nnq_t.nnq03
                  NEXT FIELD nnq03
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_nnq_t.nnq03 > 0 AND g_nnq_t.nnq03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM nnq_file
             WHERE nnq01 = g_nnq01
               AND nnq02 = g_nnq02
               AND nnq03 = g_nnq_t.nnq03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nnq_t.nnq03,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","nnq_file",g_nnq01,g_nnq_t.nnq03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            COMMIT WORK
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_nnq[l_ac].* = g_nnq_t.*
            CLOSE i712_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nnq[l_ac].nnq03,-263,1)
            LET g_nnq[l_ac].* = g_nnq_t.*
         ELSE
            UPDATE nnq_file SET nnq03=g_nnq[l_ac].nnq03,
                                nnq04=g_nnq[l_ac].nnq04,
                                nnq05=g_nnq[l_ac].nnq05
             WHERE nnq01 = g_nnq01
               AND nnq02 = g_nnq02
               AND nnq03 = g_nnq_t.nnq03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nnq[l_ac].nnq03,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("upd","nnq_file",g_nnq01,g_nnq_t.nnq03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               LET g_nnq[l_ac].* = g_nnq_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
      #  LET l_ac_t = l_ac       #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nnq[l_ac].* = g_nnq_t.*
          #FUN-D30032--add--str--
            ELSE
               CALL g_nnq.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
          #FUN-D30032--add--end--
            END IF
            CLOSE i712_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac       #FUN-D30032 add
        #LET g_nnq_t.* = g_nnq[l_ac].*
         CLOSE i712_bcl
         COMMIT WORK
 
#     ON ACTION CONTROLN
#        CALL i712_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(nnq03) AND l_ac > 1 THEN
            LET g_nnq[l_ac].* = g_nnq[l_ac-1].*
            NEXT FIELD nnq03
         END IF
 
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
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
   END INPUT
 
   CLOSE i712_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i712_b_askkey()
DEFINE
    l_wc   LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
    CONSTRUCT l_wc ON nnq03,nnq04,nnq06             #螢幕上取條件
       FROM s_nnq[1].nnq03,s_nnq[1].nnq04,s_nnq[1].nnq06
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i712_b_fill(l_wc)
END FUNCTION
 
FUNCTION i712_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc  LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(200)
 
   LET g_sql = "SELECT nnq03,nnq04,nnq05 FROM nnq_file ",
               " WHERE nnq01 = '",g_nnq01,"' AND nnq02 = ",g_nnq02,
               "   AND ",p_wc CLIPPED ,
               " ORDER BY 1"
   PREPARE i712_prepare2 FROM g_sql      #預備一下
   DECLARE nnq_cs CURSOR FOR i712_prepare2
 
   CALL  g_nnq.clear()                  #MOD-C90227 add
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH nnq_cs INTO g_nnq[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_nnq.deleteElement(g_cnt)   #取消 Array Element
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i712_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nnq TO s_nnq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i712_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i712_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i712_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i712_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i712_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
     ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i712_copy()
DEFINE
    l_oldno1         LIKE nnq_file.nnq01,
    l_oldno2         LIKE nnq_file.nnq02,
    l_newno1         LIKE nnq_file.nnq01,
    l_newno2         LIKE nnq_file.nnq02
 
    IF s_anmshut(0) THEN RETURN END IF                #檢查權限
    IF g_nnq01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i712_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno1,l_newno2  FROM nnq01,nnq02
 
        AFTER FIELD nnq01
            IF cl_null(l_newno1) THEN
               NEXT FIELD nnq01
            ELSE
               SELECT count(*) INTO g_cnt FROM nnp_file WHERE nnp01 = l_newno1
               IF g_cnt = 0 THEN
                   CALL cl_err(l_newno1,'anm-603',0)
                   NEXT FIELD nnq01
               END IF
            END IF
 
        AFTER FIELD nnq02
            IF cl_null(l_newno2) THEN
                NEXT FIELD nnq02
            ELSE
               SELECT count(*) INTO g_cnt FROM nnp_file
                       WHERE nnp01 = l_newno1 AND nnp02 = l_newno2
               IF g_cnt = 0 THEN
                   CALL cl_err(l_newno1,'anm-603',0)
                   NEXT FIELD nnq01
               END IF
            END IF
            SELECT count(*) INTO g_cnt FROM nnq_file
             WHERE nnq01 = l_newno1 AND nnq02 = l_newno2
            IF g_cnt > 0 THEN
                LET g_msg = l_newno1 CLIPPED,'+',l_newno2 CLIPPED
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD nnq01
            END IF
        ON ACTION controlp
        CASE
           WHEN INFIELD(nnq01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_nnp1"
                LET g_qryparam.default1 =l_newno1
                CALL cl_create_qry() RETURNING l_newno1,l_newno2
#                CALL FGL_DIALOG_SETBUFFER( l_newno1 )
#                CALL FGL_DIALOG_SETBUFFER( l_newno2 )
                DISPLAY BY NAME l_newno1,l_newno2
                CALL i712_nnq01('1')
                NEXT FIELD nnq01
        END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
 
    IF INT_FLAG OR l_newno1 IS NULL THEN
       LET INT_FLAG = 0
       CALL i712_show()
       RETURN
    END IF
 
    DROP TABLE x
 
    SELECT * FROM nnq_file WHERE nnq01=g_nnq01 AND nnq02=g_nnq02 INTO TEMP x
 
    UPDATE x SET nnq01=l_newno1,nnq02=l_newno2
 
    INSERT INTO nnq_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_nnq01,SQLCA.sqlcode,0)   #No.FUN-660148
       CALL cl_err3("ins","nnq_file",g_nnq01,g_nnq02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
       LET g_msg = l_newno1 CLIPPED, ' + ', l_newno2 CLIPPED
       MESSAGE 'ROW(',g_msg,') O.K'
       LET l_oldno1 = g_nnq01
       LET l_oldno2 = g_nnq02
       LET g_nnq01 = l_newno1
       LET g_nnq02 = l_newno2
       CALL i712_b()
       #LET g_nnq01 = l_oldno1  #FUN-C80046
       #LET g_nnq02 = l_oldno2  #FUN-C80046
       #CALL i712_show()        #FUN-C80046
    END IF
 
END FUNCTION
 
FUNCTION i712_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nnq01,nnq02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i712_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nnq01,nnq02",FALSE)
   END IF
 
END FUNCTION
 
#Patch....NO.MOD-5A0095 <> #
#Patch....NO.TQC-610036 <001> #
