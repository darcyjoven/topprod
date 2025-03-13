# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: agli117.4gl
# Descriptions...: 報表結構資料維護作業
# Date & Author..: No.TQC-B50154 11/06/02 BY ZM
# Modify.........: No.TQC-C30136 12/03/08 By fengrui 處理ON ACITON衝突問題
# Modify.........: No.TQC-C40212 12/04/23 By Carrier mark report
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_mbi           RECORD LIKE mbi_file.*,       #報表編號 (假單頭)
    g_mbi_t         RECORD LIKE mbi_file.*,       #報表編號 (舊值)
    g_mbi_o         RECORD LIKE mbi_file.*,       #報表編號 (舊值)
    g_mbi01_t       LIKE mbi_file.mbi01,   #報表編號 (舊值)
    g_mbi00_t       LIKE mbi_file.mbi00,   #報表編號 (舊值)  #No.FUN-730020
    g_mbk02         LIKE mbk_file.mbk02,   #zm
    g_mbj           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        mbj02       LIKE mbj_file.mbj02,   # 項次
        mbj03       LIKE mbj_file.mbj03,   #列印碼
        mbj09       LIKE mbj_file.mbj09,   #
        mbj04       LIKE mbj_file.mbj04,   #空行數
        mbj05       LIKE mbj_file.mbj05,   #空格數
        mbj07       LIKE mbj_file.mbj07,   #餘額型態 (1.借餘/2.貸餘)
        mbj26       LIKE mbj_file.mbj26,   #No.FUN-570087
        mbj20       LIKE mbj_file.mbj20,   #Name
        mbj20e      LIKE mbj_file.mbj20e,  #Name(Extra)
        mbj11       LIKE mbj_file.mbj11,   #百分比基準科目
        mbj08       LIKE mbj_file.mbj08,   #合計階數
       #mbj23       LIKE mbj_file.mbj23,   # 1.B/S  2.I/S #No.MOD-460192 remark
        mbj23a1      LIKE type_file.chr1,   # 1.B/S   #MOD-460192 add    #No.FUN-680098   VARCHAR(1)
        mbj23b1      LIKE type_file.chr1,   # 2.I/S   #MOD-460192 add    #No.FUN-680098   VARCHAR(1)
#No.FUN-570087--begin
        mbj27       LIKE mbj_file.mbj27,
        mbj28       LIKE mbj_file.mbj28
#No.FUN-570087--end
                    END RECORD,
    g_mbj_t         RECORD    #程式變數(Program Variables)
        mbj02       LIKE mbj_file.mbj02,   # 項次
        mbj03       LIKE mbj_file.mbj03,   #列印碼
        mbj09       LIKE mbj_file.mbj09,   #列印碼
        mbj04       LIKE mbj_file.mbj04,   #空行數
        mbj05       LIKE mbj_file.mbj05,   #空格數
        mbj07       LIKE mbj_file.mbj07,   #餘額型態 (1.借餘/2.貸餘)
        mbj26       LIKE mbj_file.mbj26,   #No.FUN-570087
        mbj20       LIKE mbj_file.mbj20,   #Name
        mbj20e      LIKE mbj_file.mbj20e,  #Name(Extra)
        mbj11       LIKE mbj_file.mbj11,   #百分比基準科目
        mbj08       LIKE mbj_file.mbj08,   #合計階數
       #mbj23       LIKE mbj_file.mbj23,   # 1.B/S  2.I/S #No.MOD-460192 remark
        mbj23a1      LIKE type_file.chr1,   # 1.B/S   #MOD-460192 add     #No.FUN-680098  VARCHAR(1) 
        mbj23b1      LIKE type_file.chr1,   # 2.I/S   #MOD-460192 add     #No.FUN-680098  VARCHAR(1) 
#No.FUN-570087--begin
        mbj27       LIKE mbj_file.mbj27,
        mbj28       LIKE mbj_file.mbj28
#No.FUN-570087--end
                    END RECORD,
   #zm
    g_mbj2           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        mbj02       LIKE mbj_file.mbj02,   # 項次
        mbj03       LIKE mbj_file.mbj03,   #列印碼
        mbj09       LIKE mbj_file.mbj09,   #
        mbj04       LIKE mbj_file.mbj04,   #空行數
        mbj05       LIKE mbj_file.mbj05,   #空格數
        mbj07       LIKE mbj_file.mbj07,   #餘額型態 (1.借餘/2.貸餘)
        mbj26       LIKE mbj_file.mbj26,   #No.FUN-570087
        mbj20       LIKE mbj_file.mbj20,   #Name
        mbj20e      LIKE mbj_file.mbj20e,  #Name(Extra)
        mbj11       LIKE mbj_file.mbj11,   #百分比基準科目
        mbj08       LIKE mbj_file.mbj08,   #合計階數
        mbj23a2      LIKE type_file.chr1,   # 1.B/S   #MOD-460192 add    #No.FUN-680098   VARCHAR(1)
        mbj23b2      LIKE type_file.chr1,   # 2.I/S   #MOD-460192 add    #No.FUN-680098   VARCHAR(1)
        mbj27       LIKE mbj_file.mbj27,
        mbj28       LIKE mbj_file.mbj28
                    END RECORD,
    g_mbj2_t         RECORD    #程式變數(Program Variables)
        mbj02       LIKE mbj_file.mbj02,   # 項次
        mbj03       LIKE mbj_file.mbj03,   #列印碼
        mbj09       LIKE mbj_file.mbj09,   #列印碼
        mbj04       LIKE mbj_file.mbj04,   #空行數
        mbj05       LIKE mbj_file.mbj05,   #空格數
        mbj07       LIKE mbj_file.mbj07,   #餘額型態 (1.借餘/2.貸餘)
        mbj26       LIKE mbj_file.mbj26,   #No.FUN-570087
        mbj20       LIKE mbj_file.mbj20,   #Name
        mbj20e      LIKE mbj_file.mbj20e,  #Name(Extra)
        mbj11       LIKE mbj_file.mbj11,   #百分比基準科目
        mbj08       LIKE mbj_file.mbj08,   #合計階數
        mbj23a2      LIKE type_file.chr1,   # 1.B/S   #MOD-460192 add     #No.FUN-680098  VARCHAR(1) 
        mbj23b2      LIKE type_file.chr1,   # 2.I/S   #MOD-460192 add     #No.FUN-680098  VARCHAR(1) 
        mbj27       LIKE mbj_file.mbj27,
        mbj28       LIKE mbj_file.mbj28
                    END RECORD,
    #zm
    g_mbk           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        mbk03       LIKE mbk_file.mbk03,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        mbk04       LIKE mbk_file.mbk04, 
        mbk05       LIKE mbk_file.mbk05
                    END RECORD,
    g_mbk_t         RECORD                 #程式變數 (舊值)
        mbk03       LIKE mbk_file.mbk03,   #科目編號
        aag02       LIKE aag_file.aag02,   #科目名稱
        mbk04       LIKE mbk_file.mbk04, 
        mbk05       LIKE mbk_file.mbk05
                    END RECORD,
     g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN   
    t_sql1,t_sql2,t_sql3,t_sql4,t_sql5,t_sql6   LIKE type_file.chr1000,  #No.FUN-680098   VARCHAR(70)
    g_str           LIKE type_file.chr1,                                 #No.FUN-680098   VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680098   SMALLINT
    l_ac            LIKE type_file.num5,                 #目前處理的ARRAY CNT   #No.FUN-680098 SMALLINT
    l_ac3            LIKE type_file.num5,                 #目前處理的ARRAY CNT   #No.FUN-680098 SMALLINT
    g_rec_b2,g_rec_b3         LIKE type_file.num5,                #單身筆數        #No.FUN-680098   SMALLINT
    l_ac2            LIKE type_file.num5                 #目前處理的ARRAY CNT   #No.FUN-680098 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680098  SMALLINT
 
#主程式開始
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE   g_i             LIKE type_file.num5           #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680098 SMALLINT
DEFINE   l_str           STRING                       #No.FUN-760085 
MAIN
DEFINE
#       l_time   LIKE type_file.chr8            #No.FUN-6A0073
   p_row,p_col   LIKE type_file.num5                  #No.FUN-680098         SMALLINT
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

   LET g_mbk02 = NULL
 
   LET g_forupd_sql = "SELECT * FROM mbi_file WHERE mbi01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i117_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   LET p_row = 2 LET p_col = 9
 
   OPEN WINDOW i117_w AT p_row,p_col
     WITH FORM "agl/42f/agli117"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN # No.TQC-B50154
 
   CALL cl_ui_init()
   
   CALL cl_set_comp_visible("mbj23b1,mbj23b2",FALSE)
   CALL cl_set_comp_visible("mbj07,formonly.mbj07",FALSE)
   IF g_aza.aza26 MATCHES '[01]' THEN
      CALL cl_set_comp_visible("mbj26,mbj27,mbj28",FALSE)
   END IF

   CALL i117_menu()
   CLOSE WINDOW i117_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i117_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_mbj23         LIKE mbj_file.mbj23  #MOD-460192
 
    CLEAR FORM                             #清除畫面
    CALL g_mbj.clear()
    CALL g_mbj2.clear()
    CALL g_mbk.clear()
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0029 
 
    INITIALIZE g_mbi.* TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON mbi01,mbi02,mbi00,mbi03, mbiuser,mbigrup, mbioriu,mbiorig,        
                      mbimodu,mbidate,mbiacti,
                      mbj02,mbj03,mbj09,mbj04,mbj05,mbj07,mbj26,mbj20,mbj20e,
                      mbj11,mbj08,mbj27,mbj28,mbk03,mbk04,mbk05
                FROM  mbi01,mbi02,mbi00,mbi03, mbiuser,mbigrup, mbioriu,mbiorig,
                      mbimodu,mbidate,mbiacti,
                      s_mbj1[1].mbj02,s_mbj1[1].mbj03,s_mbj1[1].mbj09,
                      s_mbj1[1].mbj04,s_mbj1[1].mbj05,
                      s_mbj1[1].mbj07,s_mbj1[1].mbj26,s_mbj1[1].mbj20,s_mbj1[1].mbj20e,
                      s_mbj1[1].mbj11,s_mbj1[1].mbj08,s_mbj1[1].mbj27,s_mbj1[1].mbj28,
                      s_mbk[1].mbk03,s_mbk[1].mbk04,s_mbk[1].mbk05

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(mbi00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aaa"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO mbi00  
               WHEN INFIELD(mbj20)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag"     
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO mbj20
               OTHERWISE
                  EXIT CASE
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
 
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('mbiuser', 'mbigrup')
 
 
    LET g_sql = "SELECT DISTINCT  mbi01 ",
                "  FROM mbi_file, mbj_file,mbk_file ",
                " WHERE mbi01 = mbj01 AND mbk01=mbj01 AND mbk02=mbj02 ",
                "   AND ", g_wc CLIPPED, 
                " ORDER BY mbi01"
 
    PREPARE i117_prepare FROM g_sql
    DECLARE i117_cs SCROLL CURSOR WITH HOLD FOR i117_prepare
 
    LET g_sql="SELECT COUNT(DISTINCT mbi01) FROM mbi_file,mbj_file,mbk_file WHERE ",
              "mbj01=mbi01 AND mbk01=mbj01 AND mbk02=mbj02 AND ",g_wc CLIPPED
    PREPARE i117_precount FROM g_sql
    DECLARE i117_count CURSOR FOR i117_precount
END FUNCTION
 
FUNCTION i117_menu()
 
   WHILE TRUE
      CALL i117_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i117_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i117_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i117_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i117_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i117_x()
               CALL cl_set_field_pic("","","","","",g_mbi.mbiacti)
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i117_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i117_b1('u')
               CALL i117_b2('u')
            ELSE
               LET g_action_choice = NULL
            END IF
         #No.TQC-C40212  --Begin
         #WHEN "output"
         #   IF cl_chk_act_auth()
         #      THEN CALL i117_out()
         #   END IF
         #No.TQC-C40212  --End  
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "right"
            IF cl_chk_act_auth() THEN
               CALL i117_b2('u')
            END IF
         WHEN "re_sort"
            IF cl_chk_act_auth() THEN
               CALL i117_g()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_mbi.mbi01 IS NOT NULL THEN
                  LET g_doc.column1 = "mbi01"
                  LET g_doc.value1 = g_mbi.mbi01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mbj),'','')
            END IF
    #FUN-6C0068--begin
         WHEN "authorization"    #使用者設限
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_mbi.mbi01) THEN
                 CALL s_smu(g_mbi.mbi01,"RGL")  
                 LET g_msg = s_smu_d(g_mbi.mbi01,"RGL") 
                 DISPLAY g_msg TO smu02_display
              END IF
           END IF
 
         WHEN "dept_authorization"
            IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_mbi.mbi01) THEN
                CALL s_smv(g_mbi.mbi01,"RGL")  
                LET g_msg = s_smv_d(g_mbi.mbi01,"RGL")   
                DISPLAY g_msg TO smv02_display
              END IF
            END IF
    #FUN-6C0068--end
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i117_a()
   IF s_aglshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
    CALL g_mbj.clear()
   INITIALIZE g_mbi.* LIKE mbi_file.*             #DEFAULT 設定
   LET g_mbi01_t = NULL
   LET g_mbi00_t = NULL  #No.FUN-730020
   #預設值及將數值類變數清成零
   LET g_mbi_o.* = g_mbi.*
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_mbi.mbiuser=g_user
      LET g_mbi.mbioriu = g_user #FUN-980030
      LET g_mbi.mbiorig = g_grup #FUN-980030
      LET g_mbi.mbigrup=g_grup
      LET g_mbi.mbidate=g_today
      LET g_mbi.mbiacti='Y'              #資料有效
      CALL i117_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_mbi.mbi01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO mbi_file VALUES (g_mbi.*)
      IF SQLCA.sqlcode THEN      #置入資料庫不成功
#        CALL cl_err(g_mbi.mbi01,SQLCA.sqlcode,1)   #No.FUN-660123
         CALL cl_err3("ins","mbi_file",g_mbi.mbi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
      LET g_mbi_t.* = g_mbi.*
      SELECT mbi01 INTO g_mbi.mbi01 FROM mbi_file
       WHERE mbi01 = g_mbi.mbi01
      CALL g_mbj.clear()
      LET g_rec_b = 0
      LET g_rec_b2 = 0
      LET g_rec_b3 = 0
      CALL i117_b1('a')                   #輸入單身
      CALL i117_b2('a')                   #輸入單身
      LET g_mbi01_t = g_mbi.mbi01        #保留舊值
      LET g_mbi00_t = g_mbi.mbi00        #保留舊值  #No.FUN-730020
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i117_u()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_mbi.mbi01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_mbi.* FROM mbi_file WHERE mbi01=g_mbi.mbi01
   IF g_mbi.mbiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_mbi.mbi01,9027,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_mbi01_t = g_mbi.mbi01
   LET g_mbi00_t = g_mbi.mbi00
   LET g_mbi_o.* = g_mbi.*
   BEGIN WORK
   OPEN i117_cl USING g_mbi.mbi01
   FETCH i117_cl INTO g_mbi.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mbi.mbi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i117_cl ROLLBACK WORK RETURN
   END IF
   CALL i117_show()
   WHILE TRUE
      LET g_mbi01_t = g_mbi.mbi01
      LET g_mbi.mbimodu=g_user
      LET g_mbi.mbidate=g_today
      CALL i117_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_mbi.*=g_mbi_t.*
         CALL i117_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_mbi.mbi01 != g_mbi01_t THEN            # 更改單號
         UPDATE mbj_file SET mbj01 = g_mbi.mbi01
          WHERE mbj01 = g_mbi01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('mbj',SQLCA.sqlcode,0)  #No.FUN-660123
            CALL cl_err3("upd","mbj_file",g_mbi01_t,"",SQLCA.sqlcode,"","mbj",1)  #No.FUN-660123
            CONTINUE WHILE
         END IF
      END IF
      UPDATE mbi_file SET mbi_file.* = g_mbi.*
       WHERE mbi01 = g_mbi01_t
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_mbi.mbi01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("upd","mbi_file",g_mbi01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i117_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i117_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-680098 VARCHAR(1)
   l_aaaacti       LIKE aaa_file.aaaacti,  #No.FUN-730020
   p_cmd           LIKE type_file.chr1     #a:輸入 u:更改           #No.FUN-680098 VARCHAR(1)
 
   DISPLAY BY NAME g_mbi.mbiuser,g_mbi.mbimodu,
       g_mbi.mbigrup,g_mbi.mbidate,g_mbi.mbiacti
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0029 
 
   INPUT BY NAME g_mbi.mbioriu,g_mbi.mbiorig,g_mbi.mbi01,g_mbi.mbi02,g_mbi.mbi00,g_mbi.mbi03 WITHOUT DEFAULTS  #No.FUN-730020
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i117_set_entry(p_cmd)
         CALL i117_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD mbi01                  #報表編號
         IF NOT cl_null(g_mbi.mbi01) THEN
            IF g_mbi.mbi01 != g_mbi01_t OR g_mbi01_t IS NULL THEN
               SELECT count(*) INTO g_cnt FROM mbi_file
               WHERE mbi01 = g_mbi.mbi01
               IF g_cnt > 0 THEN   #資料重複
                  CALL cl_err(g_mbi.mbi01,-239,0)
                  LET g_mbi.mbi01 = g_mbi01_t
                  DISPLAY BY NAME g_mbi.mbi01
                  NEXT FIELD mbi01
               END IF
            END IF
         END IF
 
      #No.FUN-730020  --Begin
      AFTER FIELD mbi00
         IF NOT cl_null(g_mbi.mbi00) THEN                                      
            SELECT aaaacti INTO l_aaaacti FROM aaa_file                          
             WHERE aaa01=g_mbi.mbi00                                           
            IF SQLCA.SQLCODE=100 THEN                                            
               CALL cl_err3("sel","aaa_file",g_mbi.mbi00,"",100,"","",1)            
               NEXT FIELD mbi00                                                 
            END IF                                                               
            IF l_aaaacti='N' THEN                                                
               CALL cl_err(g_mbi.mbi00,"9028",1)                                    
               NEXT FIELD mbi00                                                 
            END IF                                                               
         END IF
         IF g_mbi.mbi00 != g_mbi00_t THEN
            CALL cl_err(g_mbi.mbi00,'agl-502',1)
         END IF
      #No.FUN-730020  --End  
 
      AFTER FIELD mbi03
         IF NOT cl_null(g_mbi.mbi03) THEN
            IF g_mbi.mbi03 NOT MATCHES '[1-4]' THEN
               NEXT FIELD mbi03
            END IF
         END IF
 
      #No.FUN-730020  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(mbi00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = g_mbi.mbi00
               CALL cl_create_qry() RETURNING g_mbi.mbi00
               DISPLAY BY NAME g_mbi.mbi00
               NEXT FIELD mbi00  
            OTHERWISE
               EXIT CASE
         END CASE
      #No.FUN-730020  --End  
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i117_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_mbi.* TO NULL               #No.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_mbj.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL i117_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i117_cs                            
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_mbi.* TO NULL
   ELSE
      OPEN i117_count
      FETCH i117_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i117_fetch('F')                  #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i117_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,    #處理方式          #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10    #絕對的筆數        #No.FUN-680098 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i117_cs INTO g_mbi.mbi01
      WHEN 'P' FETCH PREVIOUS i117_cs INTO g_mbi.mbi01
      WHEN 'F' FETCH FIRST    i117_cs INTO g_mbi.mbi01
      WHEN 'L' FETCH LAST     i117_cs INTO g_mbi.mbi01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
         FETCH ABSOLUTE g_jump i117_cs INTO g_mbi.mbi01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mbi.mbi01,SQLCA.sqlcode,0)
      INITIALIZE g_mbi.* TO NULL  #TQC-6B0105
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
   END IF
   SELECT * INTO g_mbi.* FROM mbi_file WHERE mbi01 = g_mbi.mbi01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_mbi.mbi01,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","mbi_file",g_mbi.mbi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
      INITIALIZE g_mbi.* TO NULL
      RETURN
   ELSE
      LET g_data_owner = g_mbi.mbiuser     #No.FUN-4C0048
      LET g_data_group = g_mbi.mbigrup     #No.FUN-4C0048
      CALL i117_show()
   END IF
 
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i117_show()
   LET g_mbi_t.* = g_mbi.*                #保存單頭舊值
   DISPLAY BY NAME g_mbi.mbioriu,g_mbi.mbiorig,                              # 顯示單頭值
       g_mbi.mbi01,g_mbi.mbi02,g_mbi.mbi03,g_mbi.mbi00,   #No.FUN-730020
       g_mbi.mbiuser,g_mbi.mbigrup,g_mbi.mbimodu,
       g_mbi.mbidate,g_mbi.mbiacti
 
   LET g_msg = s_smu_d(g_mbi.mbi01,"RGL")  
   DISPLAY g_msg TO smu02_display
   LET g_msg = s_smv_d(g_mbi.mbi01,"RGL")             
   DISPLAY g_msg TO smv02_display
 
   CALL i117_b1_fill(g_wc)                 #單身
   CALL i117_b2_fill(g_wc)                 #單身
   CALL cl_set_field_pic("","","","","",g_mbi.mbiacti)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i117_x()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_mbi.mbi01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   BEGIN WORK
   OPEN i117_cl USING g_mbi.mbi01
   FETCH i117_cl INTO g_mbi.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mbi.mbi01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i117_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i117_show()
   IF cl_exp(0,0,g_mbi.mbiacti) THEN           #確認一下
      LET g_chr=g_mbi.mbiacti
      IF g_mbi.mbiacti='Y' THEN
         LET g_mbi.mbiacti='N'
      ELSE
         LET g_mbi.mbiacti='Y'
      END IF
      UPDATE mbi_file                    #更改有效碼
         SET mbiacti=g_mbi.mbiacti
       WHERE mbi01=g_mbi.mbi01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_mbi.mbi01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("upd","mbi_file",g_mbi.mbi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         LET g_mbi.mbiacti=g_chr
      END IF
      DISPLAY BY NAME g_mbi.mbiacti
   END IF
   CLOSE i117_cl
   COMMIT WORK
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i117_r()
   IF s_aglshut(0) THEN RETURN END IF
   IF g_mbi.mbi01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
   END IF
#No.TQC-950006 --begin                                                          
   IF g_mbi.mbiacti = 'N' THEN                                                  
      CALL cl_err('','abm-950',0)                                               
      RETURN                                                                    
   END IF                                                                       
#No.TQC-950006 --end 
   BEGIN WORK
   OPEN i117_cl USING g_mbi.mbi01
   FETCH i117_cl INTO g_mbi.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mbi.mbi01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i117_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i117_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "mbi01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_mbi.mbi01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM mbi_file WHERE mbi01 = g_mbi.mbi01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_mbi.mbi01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("del","mbi_file",g_mbi.mbi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
      END IF
      DELETE FROM mbj_file WHERE mbj01 = g_mbi.mbi01
      DELETE FROM mbk_file WHERE mbk01 = g_mbi.mbi01
      CLEAR FORM
      CALL g_mbj.clear()
      CALL g_mbj2.clear()
      CALL g_mbk.clear()
      OPEN i117_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i117_cs
         CLOSE i117_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--

      FETCH i117_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i117_cs
         CLOSE i117_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i117_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i117_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i117_fetch('/')
      END IF
    #FUN-6C0068--begin
      DELETE FROM smv_file WHERE smv01 = g_mbi.mbi01 AND upper(smv03)='RGL'
      IF SQLCA.SQLCODE THEN
        CALL cl_err('smv_file',SQLCA.sqlcode,0)
      END IF
      DELETE FROM smu_file WHERE smu01 = g_mbi.mbi01 AND upper(smu03)='RGL'
      IF SQLCA.SQLCODE THEN
        CALL cl_err('smu_file',SQLCA.sqlcode,0)
      END IF
    #FUN-6C0068--end
   END IF
   CLOSE i117_cl
   COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i117_b1(p_key)
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680098 SMALLINT
   p_key           LIKE type_file.chr1,                #為確定是在新增或更新態,  #No.FUN-680098 VARCHAR(1)  
                                          #以判斷是否可建立第150~200筆的資料
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680098 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680098 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680098 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680098 SMALLINT
DEFINE l_ac3_t     LIKE type_file.num5

 
DEFINE   l_mbj23   LIKE  mbj_file.mbj23   #MOD-460192 add
  
   LET g_action_choice = ""
   IF s_aglshut(0) THEN RETURN END IF
   IF g_mbi.mbi01 IS NULL THEN
      RETURN
   END IF
   SELECT * INTO g_mbi.* FROM mbi_file WHERE mbi01=g_mbi.mbi01
   IF g_mbi.mbiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_mbi.mbi01,'aom-000',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')

   #zm
   LET g_forupd_sql = " SELECT mbk03,'',mbk04,mbk05 FROM mbk_file",
                      "  WHERE mbk01=? AND mbk02=? AND mbk03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i117_bcl_1 CURSOR FROM g_forupd_sql
   #zm
 
   LET g_forupd_sql = " SELECT mbj02,mbj03,mbj09,mbj04,mbj05,mbj07,mbj26,",
                      "        mbj20,mbj20e,mbj11,mbj08,mbj23[1,1] mbj23a1,mbj23[2,2] mbj23b1,mbj27,mbj28", #MOD-460192 將mbj23 拆成23a 23b  #No.TQC-9B0021
                      "   FROM mbj_file ",
                      "  WHERE mbj01=? AND mbj02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i117_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac3_t = 0
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   DIALOG ATTRIBUTES(UNBUFFERED)     #zm
   INPUT ARRAY g_mbj FROM s_mbj1.*   #zm
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
       #  BEGIN WORK
         OPEN i117_cl USING g_mbi.mbi01
         FETCH i117_cl INTO g_mbi.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_mbi.mbi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            LET l_lock_sw = "Y"
         END IF
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'
            LET g_mbj_t.* = g_mbj[l_ac].*  #BACKUP
            OPEN i117_bcl USING g_mbi.mbi01,g_mbj_t.mbj02
            FETCH i117_bcl INTO g_mbj[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_mbj_t.mbj02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            IF NOT cl_null(g_mbj[l_ac].mbj02) THEN 
               CALL i117_b3_fill(g_mbj[l_ac].mbj02)
            ELSE
               CALL g_mbk.clear()
               LET g_rec_b3=0
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         IF p_key =  'a' AND l_ac >= 150   THEN
            CALL cl_err('','agl-016',0)
            SLEEP 1
         END IF
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_mbj[l_ac].* TO NULL      #900423
         LET g_mbj[l_ac].mbj03 = '1'
         LET g_mbj[l_ac].mbj09 = '+'
         LET g_mbj[l_ac].mbj04 = 0
         LET g_mbj[l_ac].mbj05 = 0
         LET g_mbj[l_ac].mbj07 = '1'
         LET g_mbj[l_ac].mbj08 = 0
#         LET g_mbj[l_ac].mbj06 = '3'
         LET g_mbj[l_ac].mbj11 = 'N'
         IF l_ac > 1 THEN
           LET g_mbj[l_ac].mbj23a1 = g_mbj[l_ac-1].mbj23a1 #MOD-60192 
          # LET g_mbj[l_ac].mbj23b1 = g_mbj[l_ac-1].mbj23b1 #MOD-60192 
         END IF
         LET g_mbj[l_ac].mbj23b1 = '1'
         LET g_mbj[l_ac].mbj27 = ''
         LET g_mbj[l_ac].mbj28 = ''
         LET g_mbj_t.* = g_mbj[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     
         NEXT FIELD mbj02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err(g_mbj[l_ac].mbj02,9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
     
         #MOD-460192
         INITIALIZE l_mbj23 TO NULL
         LET g_mbj[l_ac].mbj23b1 = '1'
         LET l_mbj23 = g_mbj[l_ac].mbj23a1 CLIPPED,g_mbj[l_ac].mbj23b1 CLIPPED
 
         INSERT INTO mbj_file(mbj01,mbj02,mbj03,mbj04,mbj05,mbj07,mbj26,
                              mbj11,mbj08,mbj09,mbj20,mbj20e,
                              mbj23,mbj27,mbj28)
                       VALUES(g_mbi.mbi01,g_mbj[l_ac].mbj02,g_mbj[l_ac].mbj03,
                              g_mbj[l_ac].mbj04,g_mbj[l_ac].mbj05,
                              g_mbj[l_ac].mbj07,g_mbj[l_ac].mbj26,
                              g_mbj[l_ac].mbj11,g_mbj[l_ac].mbj08,
                              g_mbj[l_ac].mbj09,g_mbj[l_ac].mbj20,
                              g_mbj[l_ac].mbj20e,
                              l_mbj23,g_mbj[l_ac].mbj27,g_mbj[l_ac].mbj28)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_mbj[l_ac].mbj02,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","mbj_file",g_mbi.mbi01,g_mbj[l_ac].mbj02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
        BEFORE FIELD mbj02                        #default 序號
     #      IF NOT cl_null(g_mbj[l_ac].mbj02) THEN 
     #         CALL i117_b3_fill(g_mbj[l_ac].mbj02)
     #      ELSE
     #         CALL g_mbk.clear()
     #         LET g_rec_b3=0
     #      END IF
           IF cl_null(g_mbj[l_ac].mbj02) OR g_mbj[l_ac].mbj02 = 0 THEN
              SELECT max(mbj02)+1 INTO g_mbj[l_ac].mbj02 FROM mbj_file
               WHERE mbj02 > 0 AND mbj01 = g_mbi.mbi01
              IF g_mbj[l_ac].mbj02 IS NULL THEN
                 LET g_mbj[l_ac].mbj02 = 1
              END IF
           END IF
 
        AFTER FIELD mbj02                        #check 序號是否重複
           IF NOT cl_null(g_mbj[l_ac].mbj02) THEN
              IF g_mbj[l_ac].mbj02 != g_mbj_t.mbj02 OR g_mbj_t.mbj02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM mbj_file
                  WHERE mbj01 = g_mbi.mbi01 AND mbj02 = g_mbj[l_ac].mbj02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_mbj[l_ac].mbj02 = g_mbj_t.mbj02
                    NEXT FIELD mbj02
                 END IF
              END IF
           END IF
 
        AFTER FIELD mbj03
           IF NOT cl_null(g_mbj[l_ac].mbj03) THEN
              IF g_mbj[l_ac].mbj03 NOT MATCHES '[0123459H%]' THEN
                 NEXT FIELD mbj03
              ELSE
                 IF g_mbj[l_ac].mbj03 MATCHES "[012]" AND
                    (g_mbj[l_ac].mbj08 IS NULL OR g_mbj[l_ac].mbj08 = 0) THEN
                    LET g_mbj[l_ac].mbj08 = 1
                    #------MOD-5A0095 START----------
                    DISPLAY BY NAME g_mbj[l_ac].mbj08
                    #------MOD-5A0095 END------------
                 END IF
              END IF
           END IF
 
        AFTER FIELD mbj04
           IF NOT cl_null(g_mbj[l_ac].mbj04) THEN
               IF g_mbj[l_ac].mbj04 < 0 THEN
                   #輸入值不可小於零!
                   CALL cl_err('','aim-391',0)
                   LET g_mbj[l_ac].mbj04 = g_mbj_t.mbj04
                   #------MOD-5A0095 START----------
                   DISPLAY BY NAME g_mbj[l_ac].mbj04
                   #------MOD-5A0095 END------------
                   NEXT FIELD mbj04
               END IF
           END IF
 
        AFTER FIELD mbj05
           IF NOT cl_null(g_mbj[l_ac].mbj05) THEN
               IF g_mbj[l_ac].mbj05 < 0 THEN
                   #輸入值不可小於零!
                   CALL cl_err('','aim-391',0)
                   LET g_mbj[l_ac].mbj05 = g_mbj_t.mbj05
                   #------MOD-5A0095 START----------
                   DISPLAY BY NAME g_mbj[l_ac].mbj05
                   #------MOD-5A0095 END------------
                   NEXT FIELD mbj05
               END IF
           END IF
 
        AFTER FIELD mbj09
           IF NOT cl_null(g_mbj[l_ac].mbj09) THEN
              IF g_mbj[l_ac].mbj09 NOT MATCHES '[+-]' THEN
               NEXT FIELD mbj09
              END IF
           END IF
 
        AFTER FIELD mbj07
           IF NOT cl_null(g_mbj[l_ac].mbj07) THEN
              IF g_mbj[l_ac].mbj07 NOT MATCHES "[12]" THEN
                 NEXT FIELD mbj07
              END IF
           END IF
 
        AFTER FIELD mbj20
           IF NOT cl_null(g_mbj[l_ac].mbj20) THEN
              IF g_mbj[l_ac].mbj20[1,1]='.' THEN
                 LET g_msg=g_mbj[l_ac].mbj20[2,20]
                 CALL i117_mbj20(g_msg)
              END IF
           END IF
 
        #FUN-6C0012 --begin
        AFTER FIELD mbj20e
           IF NOT cl_null(g_mbj[l_ac].mbj20e) THEN
              IF g_mbj[l_ac].mbj20e[1,1]='.' THEN
                 LET g_msg=g_mbj[l_ac].mbj20e[2,20]
                 CALL i117_mbj20e(g_msg)
              END IF
           END IF
        #FUN-6C0012 --end  
 
        AFTER FIELD mbj11
            IF NOT cl_null(g_mbj[l_ac].mbj11) THEN
               IF g_mbj[l_ac].mbj11 = 'Y' THEN
                  SELECT COUNT(*) INTO g_cnt FROM mbj_file
                   WHERE mbj01= g_mbi.mbi01 AND mbj11 = 'Y'
                     AND mbj02 != g_mbj[l_ac].mbj02
                  IF g_cnt > 0 THEN
                     CALL cl_err('','agl-130',0)
                     NEXT FIELD mbj11
                  END IF
               END IF
            END IF
 
        AFTER FIELD mbj08
            IF g_mbj[l_ac].mbj03  MATCHES "[012]" AND
               (g_mbj[l_ac].mbj08 IS NULL OR g_mbj[l_ac].mbj08 = 0) THEN
               LET g_mbj[l_ac].mbj08 = 1
               DISPLAY BY NAME g_mbj[l_ac].mbj08
               NEXT FIELD mbj08
            END IF
            IF g_mbj[l_ac].mbj08 IS NULL THEN
               LET g_mbj[l_ac].mbj08 = 0
            END IF
 
        AFTER FIELD mbj23a1
           IF cl_null(g_mbj[l_ac].mbj23a1) AND g_mbj[l_ac].mbj03 matches'[0125]' THEN
              NEXT FIELD mbj23a1
           END IF
           IF NOT cl_null(g_mbj[l_ac].mbj23a1) AND g_mbj[l_ac].mbj23a1 NOT  matches'[12]' THEN
              NEXT FIELD mbj23a1
           END IF
        
        AFTER FIELD mbj23b1
           IF NOT cl_null(g_mbj[l_ac].mbj23b1) AND g_mbj[l_ac].mbj23b1 NOT matches'[12]' THEN
              NEXT FIELD mbj23b1
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_mbj_t.mbj02 > 0 AND g_mbj_t.mbj02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
              DELETE FROM mbj_file
               WHERE mbj01 = g_mbi.mbi01 AND mbj02 = g_mbj_t.mbj02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_mbj_t.mbj02,SQLCA.sqlcode,0)   #No.FUN-660123
                 CALL cl_err3("del","mbj_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660123
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
            #  COMMIT WORK
           END IF
 
        ON ROW CHANGE
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_mbj[l_ac].mbj02,-263,1)
               LET g_mbj[l_ac].* = g_mbj_t.*
            ELSE
               INITIALIZE l_mbj23 TO NULL
               LET g_mbj[l_ac].mbj23b1 = '1'
               LET l_mbj23 = g_mbj[l_ac].mbj23a1 CLIPPED,g_mbj[l_ac].mbj23b1 CLIPPED
               
               UPDATE mbj_file SET mbj02 = g_mbj[l_ac].mbj02,
                                   mbj03 = g_mbj[l_ac].mbj03,
                                   mbj04 = g_mbj[l_ac].mbj04,
                                   mbj05 = g_mbj[l_ac].mbj05,
                                   mbj07 = g_mbj[l_ac].mbj07,
                                   mbj26 = g_mbj[l_ac].mbj26,
                                   mbj11 = g_mbj[l_ac].mbj11,
                                   mbj08 = g_mbj[l_ac].mbj08,
                                   mbj09 = g_mbj[l_ac].mbj09,
                                   mbj20 = g_mbj[l_ac].mbj20,
                                   mbj20e = g_mbj[l_ac].mbj20e,
                                   mbj23 = l_mbj23,           #MOD-460192 add
                                   mbj27 = g_mbj[l_ac].mbj27,
                                   mbj28 = g_mbj[l_ac].mbj28
                WHERE mbj01=g_mbi.mbi01 AND mbj02=g_mbj_t.mbj02   #No.FUN-570087  --add mbj26,27,28
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_mbj[l_ac].mbj02,SQLCA.sqlcode,0)   #No.FUN-660123
                  CALL cl_err3("upd","mbj_file",g_mbi.mbi01,g_mbj_t.mbj02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                  LET g_mbj[l_ac].* = g_mbj_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
               #   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF p_cmd='u' THEN
              CLOSE i117_bcl
           END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(mbj20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"     #No:MOD-460190    #MOD-B30629 mod q_aag01 -> q_aag
                 LET g_qryparam.default1 = g_mbj[l_ac].mbj20
                 LET g_qryparam.arg1 = g_mbi.mbi00  #No.FUN-730020
                 CALL cl_create_qry() RETURNING g_mbj[l_ac].mbj20
                  DISPLAY BY NAME g_mbj[l_ac].mbj20           #No.MOD-490344
                 NEXT FIELD mbj20
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(mbj02) AND l_ac > 1 THEN
                LET g_mbj[l_ac].* = g_mbj[l_ac-1].*
                LET g_mbj[l_ac].mbj11 = 'N'
                LET g_mbj[l_ac].mbj02 = NULL
                NEXT FIELD mbj02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        #TQC-C30136--mark--str--
        #ON ACTION CONTROLG
        #    CALL cl_cmdask()
        #TQC-C30136--mark--end--

        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #TQC-C30136--mark--str--
        #ON ACTION about         #MOD-4C0121
        #   CALL cl_about()      #MOD-4C0121
        #
        #ON ACTION help          #MOD-4C0121
        #   CALL cl_show_help()  #MOD-4C0121
        #TQC-C30136--mark--end--

        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
 
        END INPUT

        #zm
      INPUT ARRAY g_mbk FROM s_mbk.*                   #FUN-B50001 
         ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE, #FUN-B50001 
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

      BEFORE INPUT

         IF cl_null(g_mbj[l_ac].mbj02) THEN
            CONTINUE DIALOG
         ELSE
            LET g_mbk02 = g_mbj[l_ac].mbj02
         END IF

         IF g_rec_b3!=0 THEN
            CALL fgl_set_arr_curr(l_ac3)
         END IF
   
      BEFORE ROW
         LET p_cmd=''
         LET l_ac3 = ARR_CURR()
         LET l_lock_sw = 'N'                  
         LET l_n  = ARR_COUNT()
         IF g_rec_b3 >= l_ac3 THEN
            LET p_cmd='u'                   
            LET g_mbk_t.* = g_mbk[l_ac3].*  
            OPEN i117_bcl_1 USING g_mbi.mbi01,g_mbk02,g_mbk_t.mbk03
            IF STATUS THEN
               CALL cl_err("OPEN i117_bcl_1:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i117_bcl_1 INTO g_mbk_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock mbk',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
   
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_mbk[l_ac3].* TO NULL         #900423
         INITIALIZE g_mbk_t.* TO NULL  
         LET g_mbk[l_ac3].mbk05 = '3'
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD mbk03
   
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF l_ac3 = 1 THEN 
            UPDATE mbk_file SET mbk03 = g_mbk[l_ac3].mbk03, mbk04 = g_mbk[l_ac3].mbk04, mbk05 = g_mbk[l_ac3].mbk05
             WHERE mbk01 = g_mbi.mbi01 AND mbk02 = g_mbk02
         ELSE
            INSERT INTO mbk_file (mbk01,mbk02,mbk03,mbk04,mbk05)
               VALUES(g_mbi.mbi01,g_mbk02,g_mbk[l_ac3].mbk03,g_mbk[l_ac3].mbk04,g_mbk[l_ac3].mbk05)
         END IF 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","mbk_file",g_mbk02,g_mbk[l_ac3].mbk03,SQLCA.sqlcode,"","",1)  #No.FUN-660123 #No.FUN-740020
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b3=g_rec_b3+1
            DISPLAY g_rec_b3 TO FORMONLY.cn2  
         END IF
   
      AFTER FIELD mbk03
         IF NOT cl_null(g_mbk[l_ac3].mbk03) THEN
            CALL i117_aag()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD mbk03
            END IF
         END IF
   
      AFTER FIELD mbk05
           IF NOT cl_null(g_mbk[l_ac].mbk05) THEN
              IF g_mbk[l_ac].mbk05 NOT MATCHES '[123456789]' THEN      #FUN-630090 
                 NEXT FIELD mbk05
              END IF
           END IF

      AFTER FIELD mbk04
           IF NOT cl_null(g_mbk[l_ac].mbk04) THEN
              IF g_mbk[l_ac].mbk04 NOT MATCHES '[+-]' THEN
               NEXT FIELD mbk04
              END IF
           END IF

      BEFORE DELETE                                    #modify:Mandy
         #判斷是否可以刪除此ROW,因為此ROW可能和其它file有key值的關聯性,
         #所以不能隨便亂刪掉
         IF g_mbk_t.mbk03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN   #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM mbk_file 
             WHERE mbk01 = g_mbi.mbi01 AND mbk02 = g_mbk02
               AND mbk03 = g_mbk[l_ac3].mbk03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","mbk_file",g_mbk02,g_mbk_t.mbk03,SQLCA.sqlcode,"","",1)  
            END IF
            LET g_rec_b3=g_rec_b3-1
            DISPLAY g_rec_b3 TO FORMONLY.cn2  
         END IF
   
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_mbk[l_ac3].* = g_mbk_t.*
            CLOSE i117_bcl_1
            EXIT DIALOG   #FUN-B50001 
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_mbk[l_ac3].mbk03,-263,1)
            LET g_mbk[l_ac3].* = g_mbk_t.*
         ELSE
            UPDATE mbk_file SET mbk03 = g_mbk[l_ac3].mbk03,
                                mbk04 = g_mbk[l_ac3].mbk04,
                                mbk05 = g_mbk[l_ac3].mbk05
             WHERE mbk01 = g_mbi.mbi01 AND mbk02 = g_mbk02
               AND mbk03 = g_mbk_t.mbk03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","mbk_file",g_mbk02,g_mbk_t.mbk03,SQLCA.sqlcode,"","",1)  
               LET g_mbk[l_ac3].* = g_mbk_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
            END IF
         END IF
   
      AFTER ROW
         LET l_ac3 = ARR_CURR()
         LET l_ac3_t = l_ac3
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_mbk[l_ac3].* = g_mbk_t.*
            END IF
            CLOSE i117_bcl_1
            EXIT DIALOG     #FUN-B50001 
         END IF
         CLOSE i117_bcl_1
   
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(mbk03) AND l_ac3 > 1 THEN
            LET g_mbk[l_ac3].* = g_mbk[l_ac3-1].*
            NEXT FIELD mbk03
         END IF
   
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
   
      #TQC-C30136--mark--str--
      #ON ACTION CONTROLG
      #   CALL cl_cmdask()
      #TQC-C30136--mark--end--
   
      ON ACTION controlp
         CASE
            WHEN INFIELD(mbk03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.where = "aag00 = '",g_mbi.mbi00,"' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL i117_insmbk()
               CALL i117_b3_fill(g_mbj[l_ac].mbj02)
               EXIT DIALOG
            OTHERWISE
               EXIT CASE
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  

      #TQC-C30136--mark--str--
      #ON ACTION about    
      #   CALL cl_about()  
      # 
      #ON ACTION help     
      #   CALL cl_show_help() 
      #TQC-C30136--mark--end---

      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   
   END INPUT

   BEFORE DIALOG
      CALL cl_set_act_visible("close,append", FALSE)
      BEGIN WORK

   ON ACTION accept
      ACCEPT DIALOG

   ON ACTION cancel
      LET INT_FLAG = 1
      EXIT DIALOG

   ON ACTION CONTROLG
      CALL cl_cmdask()

   ON ACTION about
      CALL cl_about()

   ON ACTION help
      CALL cl_show_help()

   END DIALOG

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE i117_bcl_1
      ROLLBACK WORK
      RETURN
   END IF
        #zm
 
   UPDATE mbi_file SET mbimodu=g_user,mbidate=g_today
    WHERE mbi01=g_mbi.mbi01
 
    CLOSE i117_cl
    CLOSE i117_bcl
    COMMIT WORK
END FUNCTION
 
#zm
FUNCTION i117_b2(p_key)
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680098 SMALLINT
   p_key           LIKE type_file.chr1,                #為確定是在新增或更新態,  #No.FUN-680098 VARCHAR(1)  
                                          #以判斷是否可建立第150~200筆的資料
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680098 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680098 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680098 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680098 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680098 SMALLINT
DEFINE l_ac3_t     LIKE type_file.num5
DEFINE l_ac2_t     LIKE type_file.num5

 
DEFINE   l_mbj23   LIKE  mbj_file.mbj23   #MOD-460192 add
  
   LET g_action_choice = ""
   IF s_aglshut(0) THEN RETURN END IF
   IF g_mbi.mbi01 IS NULL THEN
      RETURN
   END IF
   SELECT * INTO g_mbi.* FROM mbi_file WHERE mbi01=g_mbi.mbi01
   IF g_mbi.mbiacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_mbi.mbi01,'aom-000',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')

   #zm
   LET g_forupd_sql = " SELECT mbk03,'',mbk04,mbk05 FROM mbk_file",
                      "  WHERE mbk01=? AND mbk02=? AND mbk03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i117_bcl2_1 CURSOR FROM g_forupd_sql
   #zm
 
   LET g_forupd_sql = " SELECT mbj02,mbj03,mbj09,mbj04,mbj05,mbj07,mbj26,",
                      "        mbj20,mbj20e,mbj11,mbj08,mbj23[1,1] mbj23a1,mbj23[2,2] mbj23b1,mbj27,mbj28", #MOD-460192 將mbj23 拆成23a 23b  #No.TQC-9B0021
                      "   FROM mbj_file ",
                      "  WHERE mbj01=? AND mbj02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i117_bcl2 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac3_t = 0
   LET l_ac2_t = 0
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   DIALOG ATTRIBUTES(UNBUFFERED)     #zm
   INPUT ARRAY g_mbj2 FROM s_mbj2.*   #zm
         ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b2!=0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac2 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         OPEN i117_cl USING g_mbi.mbi01
         FETCH i117_cl INTO g_mbi.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_mbi.mbi01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            LET l_lock_sw = "Y"
         END IF
         IF g_rec_b2>=l_ac2 THEN
            LET p_cmd='u'
            LET g_mbj2_t.* = g_mbj2[l_ac2].*  #BACKUP
            OPEN i117_bcl2 USING g_mbi.mbi01,g_mbj2_t.mbj02
            FETCH i117_bcl2 INTO g_mbj2[l_ac2].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_mbj2_t.mbj02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            IF NOT cl_null(g_mbj2[l_ac2].mbj02) THEN 
               CALL i117_b3_fill(g_mbj2[l_ac2].mbj02)
            ELSE
               CALL g_mbk.clear()
               LET g_rec_b3=0
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         IF p_key =  'a' AND l_ac2 >= 150   THEN
            CALL cl_err('','agl-016',0)
            SLEEP 1
         END IF
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_mbj2[l_ac2].* TO NULL      #900423
         LET g_mbj2[l_ac2].mbj03 = '1'
         LET g_mbj2[l_ac2].mbj09 = '+'
         LET g_mbj2[l_ac2].mbj04 = 0
         LET g_mbj2[l_ac2].mbj05 = 0
         LET g_mbj2[l_ac2].mbj07 = '1'
         LET g_mbj2[l_ac2].mbj08 = 0
         LET g_mbj2[l_ac2].mbj11 = 'N'
         IF l_ac2 > 1 THEN
           LET g_mbj2[l_ac2].mbj23a2 = g_mbj2[l_ac2-1].mbj23a2 #MOD-60192 
          # LET g_mbj2[l_ac2].mbj23b2 = g_mbj2[l_ac2-1].mbj23b2 #MOD-60192 
         END IF
#No.FUN-570087--begin
         LET g_mbj2[l_ac2].mbj23b2 ='2'
         LET g_mbj2[l_ac2].mbj27 = ''
         LET g_mbj2[l_ac2].mbj28 = ''
#No.FUN-570087--end
         LET g_mbj2_t.* = g_mbj2[l_ac2].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD mbj02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err(g_mbj2[l_ac2].mbj02,9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
     
         #MOD-460192
         INITIALIZE l_mbj23 TO NULL
         LET g_mbj2[l_ac2].mbj23b2 = '2'
         LET l_mbj23 = g_mbj2[l_ac2].mbj23a2 CLIPPED,g_mbj2[l_ac2].mbj23b2 CLIPPED
 
         INSERT INTO mbj_file(mbj01,mbj02,mbj03,mbj04,mbj05,mbj07,mbj26,
                              mbj11,mbj08,mbj09,mbj20,mbj20e,
                              mbj23,mbj27,mbj28)
                       VALUES(g_mbi.mbi01,g_mbj2[l_ac2].mbj02,g_mbj2[l_ac2].mbj03,
                              g_mbj2[l_ac2].mbj04,g_mbj2[l_ac2].mbj05,
                              g_mbj2[l_ac2].mbj07,g_mbj2[l_ac2].mbj26,
                              g_mbj2[l_ac2].mbj11,g_mbj2[l_ac2].mbj08,
                              g_mbj2[l_ac2].mbj09,g_mbj2[l_ac2].mbj20,
                              g_mbj2[l_ac2].mbj20e,
                              l_mbj23,g_mbj2[l_ac2].mbj27,g_mbj2[l_ac2].mbj28)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_mbj2[l_ac2].mbj02,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","mbj_file",g_mbi.mbi01,g_mbj2[l_ac2].mbj02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b2=g_rec_b2+1
            DISPLAY g_rec_b2 TO FORMONLY.cn2
         END IF
 
        BEFORE FIELD mbj02                        #default 序號
      #     IF NOT cl_null(g_mbj2[l_ac2].mbj02) THEN 
      #        CALL i117_b3_fill(g_mbj2[l_ac2].mbj02)
      #     ELSE
      #        CALL g_mbk.clear()
      #        LET g_rec_b3=0
      #     END IF
           IF cl_null(g_mbj2[l_ac2].mbj02) OR g_mbj2[l_ac2].mbj02 = 0 THEN
              SELECT max(mbj02)+1 INTO g_mbj2[l_ac2].mbj02 FROM mbj_file
               WHERE mbj02 > 0 AND mbj01 = g_mbi.mbi01
              IF g_mbj2[l_ac2].mbj02 IS NULL THEN
                 LET g_mbj2[l_ac2].mbj02 = 1
              END IF
           END IF
 
        AFTER FIELD mbj02                        #check 序號是否重複
           IF NOT cl_null(g_mbj2[l_ac2].mbj02) THEN
              IF g_mbj2[l_ac2].mbj02 != g_mbj2_t.mbj02 OR g_mbj2_t.mbj02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM mbj_file
                  WHERE mbj01 = g_mbi.mbi01 AND mbj02 = g_mbj2[l_ac2].mbj02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_mbj2[l_ac2].mbj02 = g_mbj2_t.mbj02
                    NEXT FIELD mbj02
                 END IF
              END IF
           END IF
 
        AFTER FIELD mbj03
           IF NOT cl_null(g_mbj2[l_ac2].mbj03) THEN
              IF g_mbj2[l_ac2].mbj03 NOT MATCHES '[0123459H%]' THEN
                 NEXT FIELD mbj03
              ELSE
                 IF g_mbj2[l_ac2].mbj03 MATCHES "[012]" AND
                    (g_mbj2[l_ac2].mbj08 IS NULL OR g_mbj2[l_ac2].mbj08 = 0) THEN
                    LET g_mbj2[l_ac2].mbj08 = 1
                    #------MOD-5A0095 START----------
                    DISPLAY BY NAME g_mbj2[l_ac2].mbj08
                    #------MOD-5A0095 END------------
                 END IF
              END IF
           END IF
 
        AFTER FIELD mbj04
           IF NOT cl_null(g_mbj2[l_ac2].mbj04) THEN
               IF g_mbj2[l_ac2].mbj04 < 0 THEN
                   #輸入值不可小於零!
                   CALL cl_err('','aim-391',0)
                   LET g_mbj2[l_ac2].mbj04 = g_mbj2_t.mbj04
                   #------MOD-5A0095 START----------
                   DISPLAY BY NAME g_mbj2[l_ac2].mbj04
                   #------MOD-5A0095 END------------
                   NEXT FIELD mbj04
               END IF
           END IF
 
        AFTER FIELD mbj05
           IF NOT cl_null(g_mbj2[l_ac2].mbj05) THEN
               IF g_mbj2[l_ac2].mbj05 < 0 THEN
                   #輸入值不可小於零!
                   CALL cl_err('','aim-391',0)
                   LET g_mbj2[l_ac2].mbj05 = g_mbj2_t.mbj05
                   #------MOD-5A0095 START----------
                   DISPLAY BY NAME g_mbj2[l_ac2].mbj05
                   #------MOD-5A0095 END------------
                   NEXT FIELD mbj05
               END IF
           END IF
 
        AFTER FIELD mbj09
           IF NOT cl_null(g_mbj2[l_ac2].mbj09) THEN
              IF g_mbj2[l_ac2].mbj09 NOT MATCHES '[+-]' THEN
               NEXT FIELD mbj09
              END IF
           END IF
 
        AFTER FIELD mbj07
           IF NOT cl_null(g_mbj2[l_ac2].mbj07) THEN
              IF g_mbj2[l_ac2].mbj07 NOT MATCHES "[12]" THEN
                 NEXT FIELD mbj07
              END IF
           END IF
 
        AFTER FIELD mbj20
           IF NOT cl_null(g_mbj2[l_ac2].mbj20) THEN
              IF g_mbj2[l_ac2].mbj20[1,1]='.' THEN
                 LET g_msg=g_mbj2[l_ac2].mbj20[2,20]
                 CALL i117_mbj20(g_msg)
              END IF
           END IF
 
        #FUN-6C0012 --begin
        AFTER FIELD mbj20e
           IF NOT cl_null(g_mbj2[l_ac2].mbj20e) THEN
              IF g_mbj2[l_ac2].mbj20e[1,1]='.' THEN
                 LET g_msg=g_mbj2[l_ac2].mbj20e[2,20]
                 CALL i117_mbj20e(g_msg)
              END IF
           END IF
        #FUN-6C0012 --end  
 
        AFTER FIELD mbj11
            IF NOT cl_null(g_mbj2[l_ac2].mbj11) THEN
               IF g_mbj2[l_ac2].mbj11 = 'Y' THEN
                  SELECT COUNT(*) INTO g_cnt FROM mbj_file
                   WHERE mbj01= g_mbi.mbi01 AND mbj11 = 'Y'
                     AND mbj02 != g_mbj2[l_ac2].mbj02
                  IF g_cnt > 0 THEN
                     CALL cl_err('','agl-130',0)
                     NEXT FIELD mbj11
                  END IF
               END IF
            END IF
 
        AFTER FIELD mbj08
            IF g_mbj2[l_ac2].mbj03  MATCHES "[012]" AND
               (g_mbj2[l_ac2].mbj08 IS NULL OR g_mbj2[l_ac2].mbj08 = 0) THEN
               LET g_mbj2[l_ac2].mbj08 = 1
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_mbj2[l_ac2].mbj08
               #------MOD-5A0095 END------------
               NEXT FIELD mbj08
            END IF
            IF g_mbj2[l_ac2].mbj08 IS NULL THEN
               LET g_mbj2[l_ac2].mbj08 = 0
            END IF
 
        AFTER FIELD mbj23a2
           IF cl_null(g_mbj2[l_ac2].mbj23a2) AND g_mbj2[l_ac2].mbj03 matches'[0125]' THEN
              NEXT FIELD mbj23a2
           END IF
           IF NOT cl_null(g_mbj2[l_ac2].mbj23a2) AND g_mbj2[l_ac2].mbj23a2 NOT  matches'[12]' THEN
              NEXT FIELD mbj23a2
           END IF
        
        AFTER FIELD mbj23b2
           IF NOT cl_null(g_mbj2[l_ac2].mbj23b2) AND g_mbj2[l_ac2].mbj23b2 NOT matches'[12]' THEN
              NEXT FIELD mbj23b2
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_mbj2_t.mbj02 > 0 AND g_mbj2_t.mbj02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
              DELETE FROM mbj_file
               WHERE mbj01 = g_mbi.mbi01 AND mbj02 = g_mbj2_t.mbj02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_mbj2_t.mbj02,SQLCA.sqlcode,0)   #No.FUN-660123
                 CALL cl_err3("del","mbj_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660123
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
 
        ON ROW CHANGE
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_mbj2[l_ac2].mbj02,-263,1)
               LET g_mbj2[l_ac2].* = g_mbj2_t.*
            ELSE
               INITIALIZE l_mbj23 TO NULL
               LET g_mbj2[l_ac2].mbj23b2 = '2'
               LET l_mbj23 = g_mbj2[l_ac2].mbj23a2 CLIPPED,g_mbj2[l_ac2].mbj23b2 CLIPPED
               
               UPDATE mbj_file SET mbj02 = g_mbj2[l_ac2].mbj02,
                                   mbj03 = g_mbj2[l_ac2].mbj03,
                                   mbj04 = g_mbj2[l_ac2].mbj04,
                                   mbj05 = g_mbj2[l_ac2].mbj05,
                                   mbj07 = g_mbj2[l_ac2].mbj07,
                                   mbj26 = g_mbj2[l_ac2].mbj26,
                                   mbj11 = g_mbj2[l_ac2].mbj11,
                                   mbj08 = g_mbj2[l_ac2].mbj08,
                                   mbj09 = g_mbj2[l_ac2].mbj09,
                                   mbj20 = g_mbj2[l_ac2].mbj20,
                                   mbj20e = g_mbj2[l_ac2].mbj20e,
                                   mbj23 = l_mbj23,           #MOD-460192 add
                                   mbj27 = g_mbj2[l_ac2].mbj27,
                                   mbj28 = g_mbj2[l_ac2].mbj28
                WHERE mbj01=g_mbi.mbi01 AND mbj02=g_mbj2_t.mbj02   #No.FUN-570087  --add mbj26,27,28
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_mbj2[l_ac2].mbj02,SQLCA.sqlcode,0)   #No.FUN-660123
                  CALL cl_err3("upd","mbj_file",g_mbi.mbi01,g_mbj2_t.mbj02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
                  LET g_mbj2[l_ac2].* = g_mbj2_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
               END IF
            END IF
 
        AFTER ROW
           LET l_ac2 = ARR_CURR()
           LET l_ac2_t = l_ac2
           IF p_cmd='u' THEN
              CLOSE i117_bcl2
           END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(mbj20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"    
                 LET g_qryparam.default1 = g_mbj2[l_ac2].mbj20
                 LET g_qryparam.arg1 = g_mbi.mbi00 
                 CALL cl_create_qry() RETURNING g_mbj2[l_ac2].mbj20
                  DISPLAY BY NAME g_mbj2[l_ac2].mbj20 
                 NEXT FIELD mbj20
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(mbj02) AND l_ac2 > 1 THEN
                LET g_mbj2[l_ac2].* = g_mbj2[l_ac2-1].*
                LET g_mbj2[l_ac2].mbj11 = 'N'
                LET g_mbj2[l_ac2].mbj02 = NULL
                NEXT FIELD mbj02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        #TQC-C30136--mark--str--
        #ON ACTION CONTROLG
        #    CALL cl_cmdask()
        #TQC-C30136--mark--end--
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #TQC-C30136--mark--str-- 
        #ON ACTION about         #MOD-4C0121
        #   CALL cl_about()      #MOD-4C0121
        # 
        #ON ACTION help          #MOD-4C0121
        #   CALL cl_show_help()  #MOD-4C0121
        #TQC-C30136--mark--end--

        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
 
        END INPUT

        #zm
      INPUT ARRAY g_mbk FROM s_mbk.*                   #FUN-B50001 
         ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE, #FUN-B50001 
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)

      BEFORE INPUT

         IF cl_null(g_mbj2[l_ac2].mbj02) THEN
            CONTINUE DIALOG
         ELSE
            LET g_mbk02 = g_mbj2[l_ac2].mbj02
         END IF

         IF g_rec_b3!=0 THEN
            CALL fgl_set_arr_curr(l_ac3)
         END IF
   
      BEFORE ROW
         LET p_cmd=''
         LET l_ac3 = ARR_CURR()
         LET l_lock_sw = 'N'                  
         LET l_n  = ARR_COUNT()
         IF g_rec_b3 >= l_ac3 THEN
            LET p_cmd='u'                   
            LET g_mbk_t.* = g_mbk[l_ac3].*  
            OPEN i117_bcl2_1 USING g_mbi.mbi01,g_mbk02,g_mbk_t.mbk03
            IF STATUS THEN
               CALL cl_err("OPEN i117_bcl2_1:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH i117_bcl2_1 INTO g_mbk_t.* 
            IF SQLCA.sqlcode THEN
               CALL cl_err('lock mbk',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
   
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_mbk[l_ac3].* TO NULL         #900423
         INITIALIZE g_mbk_t.* TO NULL  
         LET g_mbk[l_ac3].mbk05 = '3'
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD mbk03
   
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF l_ac3 = 1 THEN 
            UPDATE mbk_file SET mbk03 = g_mbk[l_ac3].mbk03,
                                mbk04 = g_mbk[l_ac3].mbk04,
                                mbk05 = g_mbk[l_ac3].mbk05
             WHERE mbk01 = g_mbi.mbi01 AND mbk02 = g_mbk02
         ELSE
            INSERT INTO mbk_file (mbk01,mbk02,mbk03,mbk04,mbk05)
               VALUES(g_mbi.mbi01,g_mbk02,g_mbk[l_ac3].mbk03,g_mbk[l_ac3].mbk04,g_mbk[l_ac3].mbk05)
         END IF 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","mbk_file",g_mbk02,g_mbk[l_ac3].mbk03,SQLCA.sqlcode,"","",1)  #No.FUN-660123 #No.FUN-740020
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b3=g_rec_b3+1
            DISPLAY g_rec_b3 TO FORMONLY.cn2  
         END IF
   
      AFTER FIELD mbk03
         IF NOT cl_null(g_mbk[l_ac3].mbk03) THEN
            CALL i117_aag()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD mbk03
            END IF
         END IF
   
      AFTER FIELD mbk05
           IF NOT cl_null(g_mbk[l_ac].mbk05) THEN
              IF g_mbk[l_ac].mbk05 NOT MATCHES '[123456789]' THEN      #FUN-630090 
                 NEXT FIELD mbk05
              END IF
           END IF

      AFTER FIELD mbk04
           IF NOT cl_null(g_mbk[l_ac].mbk04) THEN
              IF g_mbk[l_ac].mbk04 NOT MATCHES '[+-]' THEN
               NEXT FIELD mbk04
              END IF
           END IF

      BEFORE DELETE                                    #modify:Mandy
         #判斷是否可以刪除此ROW,因為此ROW可能和其它file有key值的關聯性,
         #所以不能隨便亂刪掉
         IF g_mbk_t.mbk03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN   #詢問是否確定
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM mbk_file 
             WHERE mbk01 = g_mbi.mbi01 AND mbk02 = g_mbk02
               AND mbk03 = g_mbk[l_ac3].mbk03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","mbk_file",g_mbk02,g_mbk_t.mbk03,SQLCA.sqlcode,"","",1)  
            END IF
            LET g_rec_b3=g_rec_b3-1
            DISPLAY g_rec_b3 TO FORMONLY.cn2  
         END IF
   
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_mbk[l_ac3].* = g_mbk_t.*
            CLOSE i117_bcl2_1
            EXIT DIALOG   #FUN-B50001 
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_mbk[l_ac3].mbk03,-263,1)
            LET g_mbk[l_ac3].* = g_mbk_t.*
         ELSE
            UPDATE mbk_file SET mbk03 = g_mbk[l_ac3].mbk03,                             
                                mbk04 = g_mbk[l_ac3].mbk04,
                                mbk05 = g_mbk[l_ac3].mbk05
             WHERE mbk01 = g_mbi.mbi01 AND mbk02 = g_mbk02
               AND mbk03 = g_mbk_t.mbk03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","mbk_file",g_mbk02,g_mbk_t.mbk03,SQLCA.sqlcode,"","",1)  
               LET g_mbk[l_ac3].* = g_mbk_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
            END IF
         END IF
   
      AFTER ROW
         LET l_ac3 = ARR_CURR()
         LET l_ac3_t = l_ac3
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_mbk[l_ac3].* = g_mbk_t.*
            END IF
            CLOSE i117_bcl2_1
            EXIT DIALOG     #FUN-B50001 
         END IF
         CLOSE i117_bcl2_1
   
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(mbk03) AND l_ac3 > 1 THEN
            LET g_mbk[l_ac3].* = g_mbk[l_ac3-1].*
            NEXT FIELD mbk03
         END IF
   
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
   
      #TQC-C30136--mark--str--
      #ON ACTION CONTROLG
      #   CALL cl_cmdask()
      #TQC-C30136--mark--end--
   
      ON ACTION controlp
         CASE
            WHEN INFIELD(mbk03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.where = "aag00 = '",g_mbi.mbi00,"' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret   #g_mbk[l_ac3].mbk03
               CALL i117_insmbk()
               CALL i117_b3_fill(g_mbj2[l_ac2].mbj02)
               EXIT DIALOG
          #     CALL i117_aag()
            OTHERWISE
               EXIT CASE
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG  

      #TQC-C30136--mark--str--
      #ON ACTION about    
      #   CALL cl_about()  
      # 
      #ON ACTION help     
      #   CALL cl_show_help() 
      #TQC-C30136--mark--end--
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   
   END INPUT

   BEFORE DIALOG
      CALL cl_set_act_visible("close,append", FALSE)
      BEGIN WORK

   ON ACTION accept
      ACCEPT DIALOG

   ON ACTION cancel
      LET INT_FLAG = 1
      EXIT DIALOG

   ON ACTION CONTROLG
      CALL cl_cmdask()

   ON ACTION about
      CALL cl_about()

   ON ACTION help
      CALL cl_show_help()

   END DIALOG

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE i117_bcl2_1
      ROLLBACK WORK
      RETURN
   END IF
        #zm
 
   UPDATE mbi_file SET mbimodu=g_user,mbidate=g_today
    WHERE mbi01=g_mbi.mbi01
 
    CLOSE i117_cl
    CLOSE i117_bcl2
    COMMIT WORK
END FUNCTION
#zm

FUNCTION i117_mbj20(p_code)
DEFINE p_code     LIKE aag_file.aag01,
       l_aag02    LIKE aag_file.aag02,
       l_aag07    LIKE aag_file.aag07,
       l_aag13    LIKE aag_file.aag13,
       l_aagacti  LIKE aag_file.aagacti,
       l_point    LIKE type_file.chr1           #No.FUN-680098   VARCHAR(1)
 
   SELECT aag02,aag07,aag13,aagacti INTO l_aag02,l_aag07,l_aag13,l_aagacti
     FROM aag_file WHERE aag01=p_code
                     AND aag00=g_mbi.mbi00  #No.FUN-730020
 
   CASE
      WHEN SQLCA.sqlcode   LET l_aag02  = NULL LET l_aag13  = NULL
                           LET g_errno = 'agl-001'
      WHEN l_aagacti = 'N' LET g_errno = '9028'
     #WHEN l_aag07 = '1'   LET g_errno = 'agl-134' #不可輸入統制科目! #MOD-B40063 mark
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
   LET l_point = g_mbj[l_ac].mbj20[1,1]
   IF l_point = '.'  OR g_mbj[l_ac].mbj20 IS NULL OR g_mbj[l_ac].mbj20 = ' ' THEN
      LET g_mbj[l_ac].mbj20 = l_aag02
   END IF
   IF cl_null(g_mbj[l_ac].mbj20e) THEN
      LET g_mbj[l_ac].mbj20e = l_aag13
   END IF
   #------MOD-5A0095 START----------
   DISPLAY BY NAME g_mbj[l_ac].mbj20
   DISPLAY BY NAME g_mbj[l_ac].mbj20e
   #------MOD-5A0095 END------------
END FUNCTION
 
#TQC-960117--Begin--#                                                                                                               
FUNCTION i117_mbj22(p_code)                                                                                                         
DEFINE p_code     LIKE aag_file.aag01,                                                                                              
       l_aag02    LIKE aag_file.aag02,                                                                                              
       l_aag07    LIKE aag_file.aag07,                                                                                              
       l_aag13    LIKE aag_file.aag13,                                                                                              
       l_aagacti  LIKE aag_file.aagacti                                                                                             
                                                                                                                                    
   LET g_errno = ''                                                                                                                 
                                                                                                                                    
   SELECT aag02,aag07,aag13,aagacti INTO l_aag02,l_aag07,l_aag13,l_aagacti                                                          
     FROM aag_file WHERE aag01=p_code                                                                                               
                     AND aag00=g_mbi.mbi00                                                                                          
                                                                                                                                    
   CASE                                                                                                                             
      WHEN SQLCA.sqlcode   LET l_aag02  = NULL LET l_aag13  = NULL                                                                  
                           LET g_errno = 'agl-001'                                                                                  
      WHEN l_aagacti = 'N' LET g_errno = '9028'                                                                                     
     #WHEN l_aag07 = '1'   LET g_errno = 'agl-134' #不可輸入統制科目! #MOD-B40063 mark
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING '----------'                                                           
   END CASE                                                                                                                         
END FUNCTION                                                                                                                        
#TQC-960117--End--#
 
#FUN-6C0012 --begin
FUNCTION i117_mbj20e(p_code)
DEFINE p_code     LIKE aag_file.aag01,
       l_aag07    LIKE aag_file.aag07,
       l_aag13    LIKE aag_file.aag13,
       l_aagacti  LIKE aag_file.aagacti,
       l_point    LIKE type_file.chr1
 
   SELECT aag07,aag13,aagacti INTO l_aag07,l_aag13,l_aagacti
     FROM aag_file WHERE aag01=p_code
                     AND aag00=g_mbi.mbi00  #No.FUN-730020
 
   CASE
      WHEN SQLCA.sqlcode   LET l_aag13  = NULL
                           LET g_errno = 'agl-001'
      WHEN l_aagacti = 'N' LET g_errno = '9028'
     #WHEN l_aag07 = '1'   LET g_errno = 'agl-134' #不可輸入統制科目! #MOD-B40063 mark
      OTHERWISE            LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
   LET l_point = g_mbj[l_ac].mbj20e[1,1]
   LET g_mbj[l_ac].mbj20e = l_aag13
   DISPLAY BY NAME g_mbj[l_ac].mbj20e
END FUNCTION
#FUN-6C0012 --end   
 
FUNCTION i117_g()
DEFINE  l_sql    LIKE type_file.chr1000,       #No.FUN-680098 VARCHAR(200)
        l_cnt    LIKE type_file.num5,          #No.FUN-680098 SMALLINT
        l_mbj02  LIKE mbj_file.mbj02
 
   IF s_aglshut(0) THEN RETURN END IF
   CALL cl_wait()
   LET l_sql = " UPDATE mbj_file SET mbj02 = mbj02 + 10000 ",
               " WHERE mbj01 = '",g_mbi.mbi01,"'"
   PREPARE i117_pre1  FROM l_sql
   EXECUTE i117_pre1
   DECLARE i117_mbj CURSOR FOR
           SELECT mbj02 FROM mbj_file
            WHERE mbj02 > 0 AND mbj01 = g_mbi.mbi01
            ORDER BY mbj02
   LET l_cnt = 1
   FOREACH i117_mbj INTO l_mbj02
      UPDATE mbj_file SET mbj02 = l_cnt
       WHERE mbj01 = g_mbi.mbi01 AND mbj02 = l_mbj02
      LET l_cnt  = l_cnt + 1
   END FOREACH
   CALL i117_show()
   ERROR 'O.K.'
END FUNCTION
 
FUNCTION i117_b1_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2    LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(200)
 
   LET g_sql = "SELECT DISTINCT mbj02,mbj03,mbj09,mbj04,mbj05,mbj07,mbj26,",
               "       mbj20,mbj20e,mbj11,mbj08,mbj23[1,1] mbj23a1,mbj23[2,2] mbj23b1,mbj27,mbj28", #MOD-460192 將mbj23 拆成 mbj23a1及 mbj23b1  #No.TQC-9B0021
               " FROM mbj_file,mbi_file,mbk_file",
               " WHERE mbi01 = mbj01 ",
               "   AND mbj01 = mbk01 AND mbj02 = mbk02 ",
               "   AND mbj02 > 0 AND mbj01 ='",g_mbi.mbi01,"' AND mbj23[2,2]='1' "  #單頭
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
   END IF 
   LET g_sql=g_sql CLIPPED," ORDER BY 1 " 
   DISPLAY g_sql
 
   PREPARE i117_pb FROM g_sql
   DECLARE mbj_curs                       #SCROLL CURSOR
       CURSOR FOR i117_pb
 
   CALL g_mbj.clear()
   LET g_cnt = 1
   MESSAGE " Waiting "
   FOREACH mbj_curs INTO g_mbj[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_mbj.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
#zm
FUNCTION i117_b2_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2    LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(200)
 
   LET g_sql = "SELECT DISTINCT mbj02,mbj03,mbj09,mbj04,mbj05,mbj07,mbj26,",
               "       mbj20,mbj20e,mbj11,mbj08,mbj23[1,1] mbj23a1,mbj23[2,2] mbj23b1,mbj27,mbj28", #MOD-460192 將mbj23 拆成 mbj23a1及 mbj23b1  #No.TQC-9B0021
               "  FROM mbj_file,mbi_file,mbk_file ",
               " WHERE mbi01 = mbj01 ",
               "   AND mbj01 = mbk01 AND mbj02 = mbk02 ",
               "   AND mbj02 > 0 AND mbj01 ='",g_mbi.mbi01,"' AND mbj23[2,2]='2' "  #單頭
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
   END IF 
   LET g_sql=g_sql CLIPPED," ORDER BY 1 " 
   DISPLAY g_sql
 
   PREPARE i117_pb2 FROM g_sql
   DECLARE mbj_curs2 CURSOR FOR i117_pb2
 
   CALL g_mbj2.clear()
   LET g_cnt = 1
   MESSAGE " Waiting "
   FOREACH mbj_curs2 INTO g_mbj2[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_mbj2.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b2 = g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION i117_b3_fill(l_mbk02)              #BODY FILL UP
DEFINE
   l_mbk02   LIKE mbk_file.mbk02
 
   LET g_sql = "SELECT mbk03,'',mbk04,mbk05  FROM mbk_file ",
               " WHERE mbk01 ='",g_mbi.mbi01,"' AND mbk02 = ",l_mbk02," ",
               " ORDER BY mbk03 " 
   PREPARE i117_pb3 FROM g_sql
   DECLARE mbk_curs2 CURSOR FOR i117_pb3
 
   CALL g_mbk.clear()
   LET g_cnt = 1
   MESSAGE " Waiting "
   FOREACH mbk_curs2 INTO g_mbk[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT aag02 INTO g_mbk[g_cnt].aag02 FROM aag_file
       WHERE aag00 = g_mbi.mbi00 AND aag01 = g_mbk[g_cnt].mbk03
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_mbk.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b3 = g_cnt-1
   DISPLAY g_rec_b3 TO FORMONLY.cn2
END FUNCTION
#zm

FUNCTION i117_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680098  VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_mbj TO s_mbj1.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF l_ac>0 THEN 
            CALL i117_b3_fill(g_mbj[l_ac].mbj02)
         END IF
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION first
         CALL i117_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i117_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i117_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i117_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i117_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      #No.TQC-C40212  --Begin
      #ON ACTION output
      #   LET g_action_choice="output"
      #   EXIT DIALOG
      #No.TQC-C40212  --Begin
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic("","","","","",g_mbi.mbiacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION right
         LET g_action_choice="right"
         EXIT DIALOG
      ON ACTION re_sort
         LET g_action_choice="re_sort"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DIALOG
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON ACTION authorization
         LET g_action_choice="authorization"
         EXIT DIALOG
         
      ON ACTION dept_authorization
         LET g_action_choice="dept_authorization"
         EXIT DIALOG        
 
      AFTER DISPLAY
         CONTINUE DIALOG
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   #zm
   DISPLAY ARRAY g_mbj2 TO s_mbj2.* ATTRIBUTE(COUNT=g_rec_b2)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF l_ac2>0 THEN 
            CALL i117_b3_fill(g_mbj2[l_ac2].mbj02)
         END IF
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION first
         CALL i117_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i117_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i117_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i117_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i117_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac2 = 1
         EXIT DIALOG
      #No.TQC-C40212  --Begin
      #ON ACTION output
      #   LET g_action_choice="output"
      #   EXIT DIALOG
      #No.TQC-C40212  --Begin
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic("","","","","",g_mbi.mbiacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION right
         LET g_action_choice="right"
         EXIT DIALOG
      ON ACTION re_sort
         LET g_action_choice="re_sort"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac2 = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DIALOG
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
    #FUN-6C0068--begin
      ON ACTION authorization
         LET g_action_choice="authorization"
         EXIT DIALOG
         
      ON ACTION dept_authorization
         LET g_action_choice="dept_authorization"
         EXIT DIALOG        
    #FUN-6C0068--end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DIALOG
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY

   DISPLAY ARRAY g_mbk TO s_mbk.* ATTRIBUTE(COUNT=g_rec_b3)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac3 = ARR_CURR()
#         CALL i117_b3_fill('1=1')
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION first
         CALL i117_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b3 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i117_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b3 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i117_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b3 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i117_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b3 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i117_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b3 != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac3 = 1
         EXIT DIALOG
      #No.TQC-C40212  --Begin
      #ON ACTION output
      #   LET g_action_choice="output"
      #   EXIT DIALOG
      #No.TQC-C40212  --Begin
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic("","","","","",g_mbi.mbiacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION right
         LET g_action_choice="right"
         EXIT DIALOG
      ON ACTION re_sort
         LET g_action_choice="re_sort"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac3 = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DIALOG
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
    #FUN-6C0068--begin
      ON ACTION authorization
         LET g_action_choice="authorization"
         EXIT DIALOG
         
      ON ACTION dept_authorization
         LET g_action_choice="dept_authorization"
         EXIT DIALOG        
    #FUN-6C0068--end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DIALOG
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
  END DIALOG
   #zm
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i117_t()
  DEFINE l_wc           LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(300)
  DEFINE l_aag01        LIKE aag_file.aag01          #No.FUN-680098 VARCHAR(24)  
  DEFINE l_aag02        LIKE aag_file.aag02          #No.FUN-680098 VARCHAR(30)  
#  DEFINE l_aag13           VARCHAR(30)   #FUN-590122
  DEFINE l_aag13        LIKE aag_file.aag13  #FUN-590122 #No.FUN-680098    VARCHAR(50)
  DEFINE l_aag04        LIKE aag_file.aag04            #No.FUN-680098   VARCHAR(01)  
  DEFINE l_aag06        LIKE aag_file.aag06            #No.FUN-680098   VARCHAR(01)
  DEFINE l_aag09        LIKE aag_file.aag09            #No.FUN-680098   VARCHAR(01)
  DEFINE l_success      LIKE type_file.chr1            #No.FUN-680098   VARCHAR(1)
  DEFINE a1,a2,a3,a4    LIKE type_file.chr20           #No.FUN-680098   VARCHAR(10)
  DEFINE s1,s2,s3,s4    LIKE type_file.chr20           #No.FUN-680098   VARCHAR(10)
  DEFINE ord1           LIKE type_file.chr4            #No.FUN-680098   VARCHAR(4)
  DEFINE seq,i          LIKE mbj_file.mbj02            #No.FUN-680098   DECIMAL(8,4)
  DEFINE j,sum_level,space_col LIKE type_file.num5     #No.FUN-680098   SMALLINT 
 
{    IF g_mbi.mbi01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
 
  OPEN WINDOW i117_w_t AT 6,3 WITH FORM "agl/42f/agli1062"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("agli1062")
 
 
  SELECT MAX(mbj02) INTO seq FROM mbj_file WHERE mbj01 = g_mbi.mbi01
  IF seq IS NULL THEN LET seq=0 END IF
  LET seq=seq+1
  LET i=1
  LET space_col=0
  CONSTRUCT BY NAME l_wc ON aag07,aag04,aag01,aag223,aag224,aag225,aag226
     #No.FUN-580031 --start--     HCN
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
     #No.FUN-580031 --end--       HCN
 
     ON IDLE g_idle_seconds   #MOD-840631
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
  IF NOT INT_FLAG THEN
      INPUT BY NAME s1,s2,s3,s4,seq,i,space_col WITHOUT DEFAULTS
      AFTER INPUT
         LET ord1 = s1[1,1],s2[1,1],s3[1,1],s4[1,1]
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
  END IF
  CLOSE WINDOW i117_w_t
  IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
  LET g_sql="SELECT aag223,aag224,aag225,aag226,aag01,aag02,aag13,aag04,aag06",
              " FROM aag_file WHERE aagacti <> 'N' AND ",l_wc CLIPPED,
              "  AND aag00 = '",g_mbi.mbi00,"'"  #No.FUN-730020
  IF ord1 IS NOT NULL THEN
    LET g_sql = g_sql CLIPPED," ORDER BY"
    FOR j = 1 TO 4
      IF ord1[j,j] != ' ' THEN LET g_sql=g_sql CLIPPED," ",ord1[j,j],"," END IF
    END FOR
    LET g_sql = g_sql CLIPPED," 5"
  #No.B504 010517 add by linda
  ELSE
    LET g_sql = g_sql CLIPPED," ORDER BY  5"
  #No.B504 end---
  END IF
  PREPARE t116_t_p FROM g_sql
  IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) RETURN END IF
  DECLARE t116_t_c CURSOR FOR t116_t_p
  BEGIN WORK
  LET l_success = 'Y'
  FOREACH t116_t_c INTO a1,a2,a3,a4,l_aag01,l_aag02,l_aag13,l_aag04,l_aag06
     IF STATUS THEN
        CALL cl_err('foreach error:',STATUS,0)
        LET l_success = 'N'
        EXIT FOREACH
     END IF
     LET g_chr = NULL
     SELECT aag03,aag09 INTO g_chr,l_aag09 FROM aag_file WHERE aag01 = l_aag01
                                            AND aag00 = g_mbi.mbi00  #No.FUN-730020
     IF g_chr = '3' THEN LET sum_level=10 ELSE LET sum_level= 0 END IF
     IF l_aag09 = 'N' THEN CONTINUE FOREACH END IF #no.7098
     MESSAGE "SEQ:",seq," ",l_aag01
     INSERT INTO mbj_file(mbj01,mbj02,mbj03,mbj09,mbj04,mbj05,
                           mbj07,mbj08,mbj20,mbj20e,mbj21,mbj22, mbj23,mbj11)   #No.MOD-510153
                   VALUES(g_mbi.mbi01,seq,'1','+',0,space_col,
                           l_aag06,1,l_aag02,l_aag13,l_aag01,l_aag01,l_aag04,'N')    #No.MOD-510153
     IF SQLCA.sqlcode THEN
#       CALL cl_err('insert mbj error:',STATUS,0)   #No.FUN-660123
        CALL cl_err3("ins","mbj_file",g_mbi.mbi01,seq,STATUS,"","insert mbj error:",1)  #No.FUN-660123
        LET l_success = 'N'
        EXIT FOREACH
     END IF
     LET seq = seq+i
  END FOREACH
  IF l_success = 'Y' THEN
     COMMIT WORK
  ELSE
     ROLLBACK WORK
   END IF
    CALL i117_b1_fill('1=1')                 #單身
}
END FUNCTION
 
FUNCTION i117_copy()
DEFINE
    l_mbi               RECORD LIKE mbi_file.*,
    l_oldno,l_newno     LIKE mbi_file.mbi01,
    l_i,l_n             LIKE type_file.num5,          #No.FUN-680098  SMALLINT
    l_mbj               RECORD LIKE mbj_file.*,
    l_mbk               RECORD LIKE mbk_file.*
 
    IF s_aglshut(0) THEN RETURN END IF
    IF g_mbi.mbi01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE      #FUN-580026
    CALL i117_set_entry('a')             #FUN-580026
    LET g_before_input_done = TRUE       #FUN-580026
   #DISPLAY "" AT 1,1
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0029 
 
    INPUT l_newno FROM mbi01
        AFTER FIELD mbi01
            IF l_newno IS NULL THEN
                NEXT FIELD mbi01
            END IF
            SELECT count(*) INTO g_cnt FROM mbi_file
                WHERE mbi01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD mbi01
            END IF
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_mbi.mbi01
        RETURN
    END IF
    LET l_mbi.* = g_mbi.*
    LET l_mbi.mbi01  =l_newno   #新的鍵值
    LET l_mbi.mbiuser=g_user    #資料所有者
    LET l_mbi.mbigrup=g_grup    #資料所有者所屬群
    LET l_mbi.mbimodu=NULL      #資料修改日期
    LET l_mbi.mbidate=g_today   #資料建立日期
    LET l_mbi.mbiacti='Y'       #有效資料
    LET l_mbi.mbioriu = g_user      #No.FUN-980030 10/01/04
    LET l_mbi.mbiorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO mbi_file VALUES (l_mbi.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('mbi:',SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","mbi_file",l_newno,"",SQLCA.sqlcode,"","mbi:",1)  #No.FUN-660123
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM mbj_file         #單身複製
     WHERE mbj01=g_mbi.mbi01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_mbi.mbi01,SQLCA.sqlcode,0)   #No.FUN-660123
        CALL cl_err3("ins","x",g_mbi.mbi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
        RETURN
    END IF
    UPDATE x
        SET mbj01=l_newno
    LET g_sql = 'SELECT * FROM x'
    PREPARE i117_p2 FROM g_sql
    DECLARE i117_copy_c CURSOR FOR i117_p2
    LET g_cnt=0
    FOREACH i117_copy_c INTO l_mbj.*
       LET g_cnt=g_cnt+1
       INSERT INTO mbj_file VALUES (l_mbj.*)
    END FOREACH

    DROP TABLE y 
    SELECT * FROM mbk_file         #單身複製
     WHERE mbk01=g_mbi.mbi01
      INTO TEMP y
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x",g_mbi.mbi01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
       RETURN
    END IF
    UPDATE y SET mbk01=l_newno
    LET g_sql = 'SELECT * FROM y'
    PREPARE i117_p3 FROM g_sql
    DECLARE i117_copy_c1 CURSOR FOR i117_p3
    LET g_cnt=0
    FOREACH i117_copy_c1 INTO l_mbk.*
       LET g_cnt=g_cnt+1
       INSERT INTO mbk_file VALUES (l_mbk.*)
    END FOREACH

    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_mbi.mbi01
     SELECT mbi_file.* INTO g_mbi.* FROM mbi_file WHERE mbi01 = l_newno
     CALL i117_u()
     CALL i117_b1('a')
     CALL i117_b2('a')
     #SELECT mbi_file.* INTO g_mbi.* FROM mbi_file WHERE mbi01 = l_oldno  #FUN-C30027
     #CALL i117_show()  #FUN-C30027
END FUNCTION
 
FUNCTION i117_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("mbj01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i117_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("mbj01",FALSE)
    END IF
 
END FUNCTION
 
#No.TQC-C40212  --Begin
#FUNCTION i117_out()
#DEFINE l_i             LIKE type_file.num5,   #No.FUN-680098  SMALLIT
#       mbi             RECORD LIKE mbi_file.*,
#       mbj             RECORD LIKE mbj_file.*,
#       l_name          LIKE type_file.chr20,  #External(Disk) file name   #No.FUN-680098 VARCHAR(20)
#       l_msg           LIKE type_file.chr1000 #No.FUN-680098   VARCHAR(22)
# 
#   IF g_wc IS NULL THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
# 
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-760085
#   LET g_sql = "SELECT mbi_file.*, mbj_file.*",
#               "  FROM mbi_file,mbj_file",
#               " WHERE mbi01 = mbj01 AND ",g_wc CLIPPED,
#               "   AND ",g_wc CLIPPED
#   CALL cl_wait()
# 
#   IF g_zz05 = 'Y' THEN                                                         
#      CALL cl_wcchp(g_wc,'mbi01,mbi02,mbi00,mbi03')           
#           RETURNING l_str                                                      
#   END IF                                                                       
#   CALL cl_prt_cs1('agli117','agli117',g_sql,l_str)
#END FUNCTION
#No.TQC-C40212  --End
 
FUNCTION i117_aag()
DEFINE 
   l_aagacti    LIKE aag_file.aagacti 

   LET g_errno = ' '
   SELECT aag02,aagacti INTO g_mbk[l_ac3].aag02,l_aagacti FROM aag_file
    WHERE aag01 = g_mbk[l_ac3].mbk03 
      AND aag00 = g_mbi.mbi00
   CASE WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-001'
        WHEN l_aagacti = 'N'     LEt g_errno = '9028'
        OTHERWISE
   END CASE
END FUNCTION

FUNCTION i117_insmbk()
   DEFINE l_str     STRING
   DEFINE tok base.StringTokenizer
   DEFINE l_mbk03   LIKE mbk_file.mbk03

   LET l_str=g_qryparam.multiret         
   LET tok = base.StringTokenizer.create(l_str,"|")
   WHILE tok.hasMoreTokens()
      LET l_mbk03 = tok.nextToken()
      INSERT INTO mbk_file VALUES(g_mbi.mbi01,g_mbk02,l_mbk03,'+','3')
   END WHILE
 
END FUNCTION
