# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: apjt500.4gl
# Descriptions...: 專案里程碑活動設定檔
# Date & Author..: 07/10/26 By Dxfwo  FUN-790025
# Modify.........: No.TQC-840009 08/04/02 By dxfwo bug修改
# Modify.........: No.TQC-840018 08/04/02 By dxfwo bug修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-790025---Begin
#模組變數(Module Variables)
DEFINE 
    g_pjn01         LIKE pjn_file.pjn01,
    g_pjn01_t       LIKE pjn_file.pjn01,
    g_pjnuser       LIKE pjn_file.pjnuser,                                                                                          
    g_pjnuser_t     LIKE pjn_file.pjnuser,                                                                                          
    g_pjngrup       LIKE pjn_file.pjnuser,                                                                                          
    g_pjngrup_t     LIKE pjn_file.pjnuser,                                                                                          
    g_pjnmodu       LIKE pjn_file.pjnmodu,                                                                                          
    g_pjnmodu_t     LIKE pjn_file.pjnmodu,                                                                                          
    g_pjndate       LIKE pjn_file.pjndate,                                                                                          
    g_pjndate_t     LIKE pjn_file.pjndate, 
    g_pja           RECORD   LIKE pja_file.*,
    g_pja_t         RECORD   LIKE pja_file.*,
    g_pjj           RECORD   LIKE pjj_file.*,                                                                                       
    g_pjj_t         RECORD   LIKE pjj_file.*, 
    g_pjn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    pjn02     LIKE pjn_file.pjn02,
                    pjn03     LIKE pjn_file.pjn03,
                    pjn04     LIKE pjn_file.pjn04,
                    pjn05     LIKE pjn_file.pjn05,
                    pjb03     LIKE pjb_file.pjb03,
                    pjn06     LIKE pjn_file.pjn06,
                    pjn07     LIKE pjn_file.pjn07,
                    pjn08     LIKE pjn_file.pjn08,
                    pjn09     LIKE pjn_file.pjn09,
                    pjnacti   LIKE pjn_file.pjnacti
                    END RECORD,
    g_pjn_t         RECORD    #程式變數(Program Variables)
                    pjn02     LIKE pjn_file.pjn02,
                    pjn03     LIKE pjn_file.pjn03,
                    pjn04     LIKE pjn_file.pjn04,
                    pjn05     LIKE pjn_file.pjn05,
                    pjb03     LIKE pjb_file.pjb03,
                    pjn06     LIKE pjn_file.pjn06,
                    pjn07     LIKE pjn_file.pjn07,
                    pjn08     LIKE pjn_file.pjn08,
                    pjn09     LIKE pjn_file.pjn09,
                    pjnacti   LIKE pjn_file.pjnacti
                    END RECORD,
    g_wc,g_wc2,g_sql     STRING,     #NO.TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數  
    g_buf           LIKE pjn_file.pjn01,  
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  
    l_cmd           LIKE type_file.chr1000  
DEFINE p_row,p_col          LIKE type_file.num5  
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5   
 
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_chr           LIKE type_file.chr1   
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000 
 
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10 
DEFINE   g_jump         LIKE type_file.num10  
DEFINE   mi_no_ask      LIKE type_file.num5 
DEFINE   l_table        STRING                          #No.TQC-840018 
DEFINE   l_sql          STRING                          #No.TQC-840018                                                            
DEFINE   g_str          STRING                          #No.TQC-840018   
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
#No.TQC-840018---Begin 
   LET g_sql = " pjnacti.pjn_file.pjnacti,",
               " pjn01.pjn_file.pjn01,",
               " pja02.pja_file.pja02,",
               " pjj01.pjj_file.pjj01,",
               " pjj02.pjj_file.pjj02,",
               " pjn02.pjn_file.pjn02,",
               " pjn03.pjn_file.pjn03,",
               " pjn04.pjn_file.pjn04,",
               " pjn05.pjn_file.pjn05,",
               " pjb03.pjb_file.pjb03,",
               " pjn06.pjn_file.pjn06,",
               " pjn07.pjn_file.pjn07,",
               " pjn08.pjn_file.pjn08,",
               " pjn09.pjn_file.pjn09 "
   LET l_table = cl_prt_temptable('apjt500',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,? )"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
            
#No.TQC-840018---End
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
      RETURNING g_time                 #NO.FUN-6A0094
 
   LET g_forupd_sql = "SELECT * FROM pjn_file WHERE pjn01 = ? FOR UPDATE"                                                           
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t500_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 12
 
   OPEN WINDOW t500_w AT p_row,p_col              #顯示畫面
        WITH FORM "apj/42f/apjt500"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
        
   CALL t500_menu()
 
   CLOSE WINDOW t500_w                 #結束畫面
     CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
        RETURNING g_time             #NO.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION t500_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_pjn.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    CONSTRUCT g_wc ON pjn01,pjn02,pjn03,pjn04,pjn05,pjn06,pjn07,
                      pjn08,pjn09,pjnacti
                 FROM pjn01,tb4[1].pjn02,tb4[1].pjn03,tb4[1].pjn04,
                      tb4[1].pjn05,tb4[1].pjn06,tb4[1].pjn07,
                      tb4[1].pjn08,tb4[1].pjn09,tb4[1].pjnacti
     
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
    
       ON ACTION controlp
          CASE 
             WHEN INFIELD(pjn01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pja3"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjn01
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjnuser', 'pjngrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql = "SELECT DISTINCT pjn01 FROM pjn_file",
                " WHERE ", g_wc CLIPPED 
 
    PREPARE t500_prepare FROM g_sql
    DECLARE t500_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t500_prepare
 
    LET g_sql="SELECT COUNT(DISTINCT pjn01) FROM pjn_file",
              " WHERE ",g_wc CLIPPED
    PREPARE t500_precount FROM g_sql
    DECLARE t500_count CURSOR FOR t500_precount
 
END FUNCTION
 
FUNCTION t500_menu()
 
   WHILE TRUE
      CALL t500_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t500_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t500_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t500_r()
            END IF
#        WHEN "invalid" 
#           IF cl_chk_act_auth() THEN
#              CALL t500_x()
#           END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t500_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t500_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL t500_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjn),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pjn01 IS NOT NULL THEN
                 LET g_doc.column1 = "pjn01"
                 LET g_doc.value1 = g_pjn01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
#Insert 錄入
FUNCTION t500_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_pjn.clear()
 
   INITIALIZE g_pjn01    LIKE pjn_file.pjn01
   INITIALIZE g_pjnuser  LIKE pjn_file.pjnuser
   INITIALIZE g_pjngrup  LIKE pjn_file.pjngrup
   INITIALIZE g_pjnmodu  LIKE pjn_file.pjnmodu
   INITIALIZE g_pjndate  LIKE pjn_file.pjndate
    
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_pjnuser=g_user
      LET g_pjngrup=g_grup 
      LET g_pjndate=g_today 
 
      CALL t500_i('a')
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_pjn01=NULL
         LET g_pjnuser=NULL
         LET g_pjnmodu=NULL 
         LET g_pjngrup=NULL 
         LET g_pjndate=NULL 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      CALL t500_b()                          # 輸入單身
      LET g_pjn01_t=g_pjn01
      LET g_pjnuser_t=g_pjnuser
      LET g_pjnmodu_t=g_pjnmodu 
      LET g_pjngrup_t=g_pjngrup 
      LET g_pjndate_t=g_pjndate 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
#Query 查詢
FUNCTION t500_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
 
    CALL t500_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! " 
    OPEN t500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       LET g_pjn01 = NULL 
       LET g_pjnuser = NULL 
       LET g_pjngrup = NULL 
       LET g_pjnmodu = NULL 
       INITIALIZE g_pjj.* TO NULL
    ELSE
       OPEN t500_count
       FETCH t500_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL t500_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t500_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                  #處理方式  #No.FUN-680137 VARCHAR(1)
    l_pjnuser       LIKE pjn_file.pjnuser,  #FUN-4C0057  add
    l_pjngrup       LIKE pjn_file.pjngrup   #FUN-4C0057  add
 
  CASE p_flag
    WHEN 'N' FETCH NEXT     t500_cs INTO g_pjn01
    WHEN 'P' FETCH PREVIOUS t500_cs INTO g_pjn01
    WHEN 'F' FETCH FIRST    t500_cs INTO g_pjn01
    WHEN 'L' FETCH LAST     t500_cs INTO g_pjn01
    WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                   LET INT_FLAG = 0 
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
            FETCH ABSOLUTE g_jump t500_cs INTO g_pjn01
            LET mi_no_ask = FALSE
  END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pjn01,SQLCA.sqlcode,0)
        INITIALIZE g_pja.* TO NULL             #No.FUN-6B0079 add
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump        # --改g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       DISPLAY g_curs_index TO FORMONLY.idx
    END IF
#    SELECT pjn01,pjnuser,pjngrup,pjnmodu,pjndate
#      INTO g_pjn01,g_pjnuser,
#           g_pjngrup,g_pjnmodu,g_pjndate
#      FROM pjn_file 
#     WHERE pjn01 = g_pjn01
#    IF SQLCA.sqlcode THEN
#       CALL cl_err3("sel","pjn_file",g_pjn01,"",SQLCA.sqlcode,"","",1) 
#       INITIALIZE g_pjn01 TO NULL
#       RETURN
#    END IF
#    LET g_data_owner = l_pjnuser      #FUN-4C0057 add
#    LET g_data_group = l_pjngrup      #FUN-4C0057 add
    CALL t500_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t500_show()
 
    LET g_pja_t.* = g_pja.*                #保存單頭舊值
    DISPLAY g_pjn01 TO pjn01
                    
    CALL t500_pjn01('d')
    CALL t500_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t500_pjn01(p_cmd)
DEFINE  
    p_cmd           LIKE type_file.chr1                  #處理狀態 
DEFINE   l_pja01    LIKE pja_file.pja01
DEFINE   l_pja02    LIKE pja_file.pja02
DEFINE   l_pjj01    LIKE pjj_file.pjj01
DEFINE   l_pjj02    LIKE pjj_file.pjj02
 
 
    LET g_errno = " "
 
    SELECT pja02,pjj01,pjj02  INTO l_pja02,l_pjj01,l_pjj02 FROM pja_file,pjj_file
      WHERE pja01=g_pjn01 AND pja01 = pjj04
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
         WHEN g_pja.pjaacti='N' LET g_errno = '9028'
         OTHERWISE   LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd ='d' THEN
       DISPLAY l_pja02 TO FORMONLY.pja02
       DISPLAY l_pjj01 TO FORMONLY.pjj01
       DISPLAY l_pjj02 TO FORMONLY.pjj02
    END IF
 
END FUNCTION
 
FUNCTION t500_i(p_cmd)
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)
   DEFINE   l_count      LIKE type_file.num5   
   DEFINE   l_n          LIKE type_file.num5    
 
   DISPLAY g_pjn01,g_pja.pja02,g_pjj.pjj01,g_pjj.pjj02
        TO pjn01,pja02,pjj01,pjj02
 
   INPUT   g_pjn01  WITHOUT DEFAULTS FROM  pjn01
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t500_set_entry(p_cmd)
         CALL t500_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD pjn01
         IF NOT cl_null(g_pjn01) THEN
            IF g_pjn01 != g_pjn01_t OR cl_null(g_pjn01_t) THEN
               SELECT COUNT(*) INTO l_n FROM pjn_file
                WHERE pjn01=g_pjn01
               IF l_n > 0 THEN
                  CALL cl_err(g_pjn01,-239,0)
                  LET g_pjn01 = g_pjn01_t
                  NEXT FIELD pjn01
               END IF
               SELECT COUNT(UNIQUE pja01) INTO l_n FROM pja_file                                                                    
                WHERE pja01=g_pjn01 AND pjaacti='Y'               
                                    AND pjaclose='N'             #FUN-960038
               IF l_n = 0 THEN                                                                                                       
                  CALL cl_err('','pjn-001',0)                                                                                        
                  NEXT FIELD pjn01                                                                                                  
               END IF                               
               CALL t500_pjn01('d')
               DISPLAY g_pjn01 TO pjn01
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjn01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pjb3"
               LET g_qryparam.default1= g_pjn01
               CALL cl_create_qry() RETURNING g_pjn01
               CALL t500_pjn01('d')
               NEXT FIELD pjn01
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
 
   END INPUT
 
END FUNCTION
 
FUNCTION t500_r()
   DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
   DEFINE   l_cnt   LIKE type_file.num5           #No.FUN-680135 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_pjn01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose FROM pja_file,pjj_file
    WHERE pja01=g_pjn01 AND pja01 = pjj04
   IF l_pjaclose='Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
 
   BEGIN WORK
 
   OPEN t500_cl USING g_pjn01
   IF STATUS THEN
      CALL cl_err("OPEN t500_cl:", STATUS, 1)
      CLOSE t500_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t500_cl INTO g_pjn01,g_pjnuser,g_pjngrup,g_pjnmodu,g_pjndate              # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjn01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pjn01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pjn01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM pjn_file WHERE pjn01 = g_pjn01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","pjn_file",g_pjn01,"",SQLCA.sqlcode,"","BODY DELETE",0)  
      ELSE
         CLEAR FORM
         CALL g_pjn.clear()
         OPEN t500_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t500_cs
            CLOSE t500_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t500_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t500_cs
            CLOSE t500_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t500_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t500_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE         
            CALL t500_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
 
END FUNCTION
 
 FUNCTION t500_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pjn01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t500_cl USING g_pjn01
   IF STATUS THEN
      CALL cl_err("OPEN t500_cl:", STATUS, 1)
      CLOSE t500_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t500_cl INTO g_pjn01,g_pjnuser,g_pjngrup,g_pjnmodu,g_pjndate              # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjn01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t500_show()
 
   IF cl_exp(0,0,g_pjn[l_ac].pjnacti) THEN                  
      LET g_chr=g_pjn[l_ac].pjnacti
      IF g_pjn[l_ac].pjnacti='Y' THEN
         LET g_pjn[l_ac].pjnacti='N'
      ELSE
         LET g_pjn[l_ac].pjnacti='Y'
      END IF
 
 
      UPDATE pjn_file SET pjnacti=g_pjn[l_ac].pjnacti,
                          pjnmodu=g_user,
                          pjndate=g_today
       WHERE pjn01=g_pjn01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","pjn_file",g_pjn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         LET g_pjn[l_ac].pjnacti = g_chr
      END IF
    END IF
 
   CLOSE t500_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_pjn01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
 END FUNCTION
 
FUNCTION t500_b()
DEFINE
    l_pjaclose      LIKE pja_file.pjaclose,             #No.FUN-960038
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,                #檢查重複用 
    l_n2            LIKE type_file.num5,                #取字段長度 
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否 
    p_cmd           LIKE type_file.chr1,                #處理狀態 
    l_pjb03         LIKE pjb_file.pjb03, 
    l_pjn04         LIKE pjn_file.pjn04,
    l_pjj01         LIKE pjj_file.pjj01,
    l_allow_insert  LIKE type_file.num5,                #可新增否
    l_allow_delete  LIKE type_file.num5                 #可刪除否 
 
    LET g_action_choice = ""
    IF g_pjn01 IS NULL THEN RETURN END IF
#No.FUN-960038 --Begin
   SELECT pjaclose INTO l_pjaclose FROM pja_file,pjj_file
    WHERE pja01=g_pjn01 AND pja01 = pjj04
   IF l_pjaclose='Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
#No.FUN-960038 --End
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql = 
        " SELECT pjn02,pjn03,pjn04,pjn05,'',pjn06,pjn07,pjn08,pjn09, ", 
        "        pjnacti FROM pjn_file ",  
        " WHERE pjn01 = ? AND pjn02 = ? FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pjn WITHOUT DEFAULTS FROM tb4.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd =''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_pjn_t.* = g_pjn[l_ac].*  #BACKUP
 
               OPEN t500_bcl USING g_pjn01,g_pjn_t.pjn02
               IF STATUS THEN
                  CALL cl_err("OPEN t500_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t500_bcl INTO g_pjn[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_pjn_t.pjn02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               IF g_pjn[l_ac].pjn04 = 'W' THEN                      #No.TQC-840018
                 SELECT pjb03 INTO g_pjn[l_ac].pjb03 FROM pjb_file WHERE g_pjn[l_ac].pjn05 = ltrim(rtrim(pjb02))                                              
               ELSE          
                 SELECT pjj01 INTO l_pjj01 FROM pjj_file
                  WHERE pjj04 = g_pjn01         
                 SELECT pjk03 INTO g_pjn[l_ac].pjb03 FROM pjk_file  #No.TQC-840009 
                  WHERE ltrim(rtrim(g_pjn[l_ac].pjn05)) = ltrim(rtrim(pjk02))       #No.TQC-840009   
                    AND pjk01 = l_pjj01                             #No.TQC-840009                                                
               END IF    
               END IF
               CALL cl_show_fld_cont()    
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pjn[l_ac].* TO NULL      #900423
             LET g_pjn[l_ac].pjnacti = 'Y'           #Default
             LET g_pjn_t.* = g_pjn[l_ac].*         #新輸入資料
             LET g_pjn[l_ac].pjn09 = 'N'           #Default
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pjn02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
       IF cl_null(g_pjn[l_ac].pjn02) THEN LET g_pjn[l_ac].pjn02=' ' END IF
            INSERT INTO pjn_file(pjn01,pjn02,pjn03,pjn04,pjn05,
                                 pjn06,pjn07,pjn08,pjn09,pjnacti,
                                 pjnuser,pjngrup,pjnmodu,pjndate,pjnoriu,pjnorig) 
                          VALUES(g_pjn01,g_pjn[l_ac].pjn02,
                                 g_pjn[l_ac].pjn03,g_pjn[l_ac].pjn04,
                                 g_pjn[l_ac].pjn05,g_pjn[l_ac].pjn06,
                                 g_pjn[l_ac].pjn07,g_pjn[l_ac].pjn08,
                                 g_pjn[l_ac].pjn09,g_pjn[l_ac].pjnacti,
                                 g_pjnuser,g_pjngrup,g_pjnmodu, 
                                 g_pjndate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","pjn_file",g_pjn01,g_pjn[l_ac].pjn02,SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
            ELSE
               LET g_rec_b = g_rec_b + 1
               MESSAGE 'INSERT O.K'
               DISPLAY g_rec_b TO FORMONLY.cnt2
            END IF
 
#        BEFORE FIELD pjn02                        #default 序號
#          IF g_pjn[l_ac].pjn02 IS NULL OR g_pjn[l_ac].pjn02 = 0 THEN
#             SELECT max(pjn02)+1
#               INTO g_pjn[l_ac].pjn02
#               FROM pjn_file
#              WHERE pjn01 = g_pjn01
#             IF g_pjn[l_ac].pjn02 IS NULL THEN
#                LET g_pjn[l_ac].pjn02 = 1
#             END IF
#          END IF
 
        AFTER FIELD pjn02                        #check 序號是否重複
           IF NOT cl_null(g_pjn[l_ac].pjn02) THEN
              IF g_pjn[l_ac].pjn02 != g_pjn_t.pjn02
                 OR g_pjn_t.pjn02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM pjn_file
                  WHERE pjn01 = g_pjn01
                    AND pjn02 = g_pjn[l_ac].pjn02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_pjn[l_ac].pjn02 = g_pjn_t.pjn02
                    NEXT FIELD pjn02
                 END IF
                 IF g_pjn[l_ac].pjn02 <=0 THEN 
                    CALL cl_err('','apj-036',0)
                    LET g_pjn[l_ac].pjn02 = g_pjn_t.pjn02
                    NEXT FIELD pjn02
                 END IF
              END IF
           END IF
 
         AFTER FIELD pjn03                                                                                                            
             IF  cl_null(g_pjn[l_ac].pjn03) THEN
                   CALL cl_err('','azz-310',0)
                NEXT FIELD pjn03
             END IF 
           
         AFTER FIELD pjn04                                                                                                         
             IF  cl_null(g_pjn[l_ac].pjn04) THEN                                                                               
                   CALL cl_err('','azz-310',0)                                                                                      
                NEXT FIELD pjn04 
              IF g_pjn[l_ac].pjn04 = 'W' THEN 
                SELECT count(*) INTO l_n FROM pjb_file      
                 WHERE pjb01 = g_pjn01                       
                 AND pjb02 = g_pjn[l_ac].pjn05             
                  AND pjbacti = 'Y'                         
              IF l_n = 0 THEN 
                   CALL cl_err('','apj-004',0)                                                                                        
                 NEXT FIELD pjn04       
              END IF
                 SELECT COUNT(*) INTO l_n FROM pjk_file                                                                                
                 WHERE pjk11 = g_pjn[l_ac].pjn05                                                                                                
               IF l_n > 0 THEN                                                                                                      
                  CALL cl_err('','apj-009',0)                                                                                       
                  NEXT FIELD pjn04                                                                                                  
             END IF   
             END IF
              IF g_pjn[l_ac].pjn04 = 'A' THEN
                SELECT count(*) INTO l_n FROM pjk_file ,pjj_file                                                                            
                 WHERE pjk01 = pjj01 AND pjk02 = g_pjn[l_ac].pjn05                                                                              
                  AND pjjacti = 'Y'
              IF l_n = 0 THEN                                                                                                       
                   CALL cl_err('','apj-004',0)                                                                                      
                 NEXT FIELD pjn04                                                                                                   
              END IF  
              END IF                                                                                                      
             END IF
          
 
         AFTER FIELD pjn05 
             IF cl_null(g_pjn[l_ac].pjn05) THEN 
                    NEXT FIELD pjn05
                END IF
             IF g_pjn[l_ac].pjn04 = 'W' THEN 
                SELECT count(*) INTO l_n FROM pjb_file                                                                                                    
                 WHERE pjb02 = g_pjn[l_ac].pjn05                                                                                    
                IF l_n = 0 THEN                                                                                                    
                CALL cl_err('','ask-008',1)                                                                                          
                LET g_pjn[l_ac].pjn05 = g_pjn_t.pjn05                                                                           
                NEXT FIELD pjn05 
                END IF
               SELECT pjb03 INTO l_pjb03 FROM pjb_file WHERE g_pjn[l_ac].pjn05 = pjb02 
               LET g_pjn[l_ac].pjb03 = l_pjb03 
               DISPLAY BY NAME g_pjn[l_ac].pjb03  
             END IF
             IF g_pjn[l_ac].pjn04 = 'A' THEN  
                SELECT count(*) INTO l_n FROM pjk_file                                                                                                    
                 WHERE pjk02 = g_pjn[l_ac].pjn05                                                                                    
                IF l_n = 0 THEN                                                                                                    
                CALL cl_err('','ask-008',1)                                                                                          
                LET g_pjn[l_ac].pjn05 = g_pjn_t.pjn05                                                                           
                NEXT FIELD pjn05                           
                END IF
                SELECT pjj01 INTO l_pjj01 FROM pjj_file
                 WHERE pjj04 = g_pjn01         
                SELECT pjk03 INTO l_pjb03 FROM pjk_file  #No.TQC-840009 
                 WHERE ltrim(rtrim(g_pjn[l_ac].pjn05)) = ltrim(rtrim(pjk02))       #No.TQC-840009   
                   AND pjk01 = l_pjj01                             #No.TQC-840009 
               LET g_pjn[l_ac].pjb03 = l_pjb03
               DISPLAY BY NAME g_pjn[l_ac].pjb03                                                                                                                    
             END IF
 
         AFTER FIELD pjn06
             IF  cl_null(g_pjn[l_ac].pjn06) THEN                                                                                    
                   CALL cl_err('','azz-310',0)                                                                                      
                NEXT FIELD pjn03                                                                                                    
             END IF
          IF g_pjn[l_ac].pjn06 > 100 OR g_pjn[l_ac].pjn06 <  0  THEN                                                                                 
           CALL cl_err('','afa-995',1)                                                                                                 
             NEXT FIELD pjn06                                                                                                          
           ELSE                                                                                                                        
          END IF 
 
         AFTER FIELD pjn07
             IF  cl_null(g_pjn[l_ac].pjn07) THEN                                                                                    
                   CALL cl_err('','azz-310',0)                                                                                      
                NEXT FIELD pjn03                                                                                                    
             END IF
          IF g_pjn[l_ac].pjn07 > 100 OR g_pjn[l_ac].pjn07 <  0  THEN                                                                            
           CALL cl_err('','afa-995',1)                                                                                              
             NEXT FIELD pjn07                                                                                                       
           ELSE                                                                                                                     
          END IF
 
         AFTER FIELD pjn08
             IF  cl_null(g_pjn[l_ac].pjn08) THEN                                                                                    
                   CALL cl_err('','azz-310',0)                                                                                      
                NEXT FIELD pjn03                                                                                                    
             END IF
          IF g_pjn[l_ac].pjn08 <  0  THEN                                                                            
           CALL cl_err('','aim-223',1)                                                                                              
             NEXT FIELD pjn08                                                                                                       
           ELSE                                                                                                                     
          END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_pjn_t.pjn02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN 
                  CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM pjn_file 
                 WHERE pjn01 = g_pjn01 
                   AND pjn02 = g_pjn_t.pjn02
                IF SQLCA.SQLERRD[3] = 0 THEN
                   CALL cl_err3("del","pjn_file",g_pjn01,g_pjn_t.pjn02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                ELSE
                   LET g_rec_b = g_rec_b -1 
                   DISPLAY g_rec_b TO FORMONLY.cnt2  
                END IF
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pjn[l_ac].* = g_pjn_t.*
               CLOSE t500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_pjn[l_ac].pjn02,-263,1)
               LET g_pjn[l_ac].* = g_pjn_t.*
            ELSE
               UPDATE pjn_file SET pjn02=g_pjn[l_ac].pjn02,
                                   pjn03=g_pjn[l_ac].pjn03,
                                   pjn04=g_pjn[l_ac].pjn04,
                                   pjn05=g_pjn[l_ac].pjn05,
                                 # pjb03=g_pjn[l_ac].pjb03,
                                   pjn06=g_pjn[l_ac].pjn06,
                                   pjn07=g_pjn[l_ac].pjn07,
                                   pjn08=g_pjn[l_ac].pjn08,
                                   pjn09=g_pjn[l_ac].pjn09,
                                   pjnacti=g_pjn[l_ac].pjnacti 
                WHERE pjn01 = g_pjn01 
                  AND pjn02 = g_pjn_t.pjn02  
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","pjn_file",g_pjn01,g_pjn_t.pjn02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_pjn[l_ac].* = g_pjn_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_pjn[l_ac].* = g_pjn_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_pjn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE t500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE t500_bcl
            COMMIT WORK
 
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pjn02) AND l_ac > 1 THEN
                LET g_pjn[l_ac].* = g_pjn[l_ac-1].*
                NEXT FIELD pjn04
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE 
              WHEN INFIELD(pjn05)
                   CALL cl_init_qry_var()
                   IF g_pjn[l_ac].pjn04 = 'W' THEN 
                      LET g_qryparam.arg1 = g_pjn01
                      LET g_qryparam.form ="q_pjb"
                   ELSE 
                     IF g_pjn[l_ac].pjn04 = 'A' THEN 
                       SELECT pjj01 INTO l_pjj01 FROM pjj_file
                        WHERE pjj04 = g_pjn01
                        LET g_qryparam.arg1 = l_pjj01                                                                                           
                        LET g_qryparam.form ="q_pjk"
                     END IF 
                   END IF 
                   CALL cl_create_qry() RETURNING g_pjn[l_ac].pjn05
                   DISPLAY g_pjn[l_ac].pjn05 TO pjn05            #No.MOD-490371
                   NEXT FIELD pjn05
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
 
    
    END INPUT
 
    CLOSE t500_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t500_b_askkey()
DEFINE    l_wc           LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(200)
 
    CONSTRUCT l_wc  ON pjn02,pjn03,pjn04,pjn05,pjn06,
                       pjn07,pjn08,pjn09,pjnacti
            FROM tb4[1].pjn02, tb4[1].pjn03, 
                 tb4[1].pjn04, tb4[1].pjn05,tb4[1].pjn06, 
                 tb4[1].pjn07, tb4[1].pjn08,tb4[1].pjn09,
                 tb4[1].pjnacti
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL t500_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION t500_b_fill(p_wc)              #BODY FILL UP
#DEFINE p_wc     LIKE type_file.chr1000 
DEFINE p_wc     STRING     #NO.FUN-910082
DEFINE l_pjb03  LIKE pjb_file.pjb03
DEFINE l_pjj01  LIKE pjj_file.pjj01
 
   LET g_sql = "SELECT pjn02,pjn03,pjn04,pjn05,'',pjn06,pjn07,pjn08, ",
               "       pjn09,pjnacti  ",
               " FROM pjn_file",
               " WHERE pjn01 ='",g_pjn01,"'",               #單頭
               "   AND ",p_wc CLIPPED,                      #單身
               " ORDER BY pjn02"
 
 
   PREPARE t500_pb FROM g_sql
   DECLARE pjn_curs CURSOR FOR t500_pb
 
   CALL g_pjn.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH pjn_curs INTO g_pjn[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
 
      IF g_pjn[g_cnt].pjn04 = 'W' THEN  
        SELECT pjb03 INTO g_pjn[g_cnt].pjb03 FROM pjb_file WHERE ltrim(rtrim(g_pjn[g_cnt].pjn05)) = ltrim(rtrim(pjb02))                                              
      ELSE 
      	SELECT pjj01 INTO l_pjj01 FROM pjj_file
         WHERE pjj04 = g_pjn01         
        SELECT pjk03 INTO g_pjn[g_cnt].pjb03 FROM pjk_file  #No.TQC-840009 
         WHERE ltrim(rtrim(g_pjn[g_cnt].pjn05)) = ltrim(rtrim(pjk02))       #No.TQC-840009   
           AND pjk01 = l_pjj01                              #No.TQC-840009                   
      END IF 
       LET g_cnt = g_cnt + 1
     
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    
   END FOREACH
   CALL g_pjn.deleteElement(g_cnt)
   LET g_rec_b =g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t500_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_pjn TO tb4.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL t500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL t500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL t500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL t500_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
#     ON ACTION invalid
#        LET g_action_choice="invalid"
#        EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
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
#No.TQC-840009---Begin         
#     ON ACTION  Project                                                                                          
#        IF NOT cl_null(g_pjn01) THEN                                                                                           
#           LET l_cmd="apjt501 '",g_pjn01,"' "                                                                                  
#           CALL cl_cmdrun_wait(l_cmd)                                                                                              
#        END IF                                                                                                                     
#                                                                                                                                   
#     ON ACTION  Pay                                                                                              
#        IF NOT cl_null(g_pjn01) THEN                                                                                           
#           LET l_cmd="apjt502 '",g_pjn01,"' "                                                                                  
#           CALL cl_cmdrun_wait(l_cmd)                                                                                              
#        END IF                                                                                                                     
#                                                                                                                                   
#     ON ACTION  WBS                                                                                    
#        IF NOT cl_null(g_pjn01) THEN                                                                                           
#           LET l_cmd="apjt503 '",g_pjn01,"' "                                                                                  
#           CALL cl_cmdrun_wait(l_cmd)                                                                                              
#        END IF                                                                                                                     
#                                                                                                                                   
#     ON ACTION  WORK                                                                                             
#        IF NOT cl_null(g_pjn01) THEN                                                                                           
#           LET l_cmd="apjt504 '",g_pjn01,"' "                                                                                  
#           CALL cl_cmdrun_wait(l_cmd)                                                                                              
#        END IF         
#No.TQC-840009---End
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
   
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t500_copy()
   DEFINE   l_n       LIKE type_file.num5,          #No.FUN-680135 SMALLINT                                                         
            l_new01   LIKE pjn_file.pjn01,                                                                                        
            l_old01   LIKE pjn_file.pjn01 
   IF s_shut(0) THEN                             # 檢查權限                                                                         
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   IF g_pjn01 IS NULL THEN                                                                                                         
      CALL cl_err('',-400,0)                                                                                                        
      RETURN                                                                                                                        
   END IF                                                                                                                           
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092                                                                              
   INPUT l_new01 WITHOUT DEFAULTS FROM pjn01   #No.FUN-710055                                                                      
                                                                                                                                    
     AFTER FIELD pjn01                                                                                                           
         IF NOT cl_null(l_new01) THEN                                                                                               
               SELECT COUNT(*) INTO l_n FROM pjn_file                                                                               
                WHERE pjn01=g_pjn01                                                                                                 
               IF l_n = 0 THEN                                                                                                      
                  CALL cl_err(g_pjn01,-239,1)                                                                                       
                  LET g_pjn01 = g_pjn01_t                                                                                           
                  NEXT FIELD pjn01                                                                                                  
               END IF                                                                                                               
     #         CALL t500_pjn01('d')                                                                                                 
               DISPLAY g_pjn01 TO pjn01                                                                                             
            END IF                 
 
       ON ACTION controlp                                                                                                           
          CASE                                                                                                                      
             WHEN INFIELD(pjn01)                                                                                                   
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.form = "q_pjb3"                                                                                       
                LET g_qryparam.default1 = g_pjn01                                                                                  
                CALL cl_create_qry() RETURNING l_new01                                                                              
                DISPLAY l_new01 TO pjn01                                                                                           
                NEXT FIELD pjn01                                                                                                   
              OTHERWISE EXIT CASE                                                                                                   
           END CASE
 
      AFTER INPUT                                                                                                                   
         IF INT_FLAG THEN                                                                                                           
            EXIT INPUT                                                                                                              
         END IF                                                                                                                     
         IF cl_null(l_new01) THEN                                                                                                   
            NEXT FIELD pjn01                                                                                                       
         END IF                                                                                                                     
#         SELECT COUNT(*) INTO g_cnt FROM pjn_file
#          WHERE pjn01 = l_new01                                       
#         IF g_cnt > 0 THEN                                                                                                         
#            CALL cl_err_msg(NULL,"azz-110",l_new01,10)                                                                             
#         END IF                                                                                                                    
 
      ON IDLE g_idle_seconds                                                                                                        
         CALL cl_on_idle()                                                                                                          
         CONTINUE INPUT                                                                                                             
                                                                                                                                    
      ON ACTION help                                                                                                                
         CALL cl_show_help()                                                                                                        
      ON ACTION controlg                                                                                                            
         CALL cl_cmdask()                                                                                                           
      ON ACTION about                                                                                                               
         CALL cl_about()                                                                                                            
                                                                                                                                    
   END INPUT                                                                                                                        
                                                                                                                                    
   BEGIN WORK 
   IF INT_FLAG THEN
      LET INT_FLAG = 0                                                                                                              
      DISPLAY g_pjn01 TO pjn01 #No.FUN-710055                                                                                     
      ROLLBACK WORK
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   DROP TABLE x                                                                                                                     
   SELECT * FROM pjn_file                                                                                                          
     WHERE pjn01=g_pjn01 and (pjn02 NOT IN   #No.FUN-710055                                                                      
     (SELECT pjn02 FROM pjn_file WHERE pjn01=l_new01)    #No.FUN-710055                                                          
     or( pjn02 IN (SELECT pjn02 FROM pjn_file WHERE pjn01=l_new01)))  #No.FUN-710055                                            
   INTO TEMP x                                                                                                                      
                                                                                                                                    
   IF SQLCA.sqlcode THEN                                                                                                            
      #CALL cl_err(g_pjn01,SQLCA.sqlcode,0)  #No.FUN-660081                                                                        
      CALL cl_err3("ins","x",g_pjn01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081                                                    
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   UPDATE x                                                                                                                         
      SET pjn01 = l_new01,
          pjnmodu = g_user,
          pjndate = g_today
 
   INSERT INTO pjn_file SELECT * FROM x                                                                                            
                                                                                                                                    
   IF SQLCA.SQLCODE THEN                                                                                                            
      CALL cl_err3("ins","pjn_file",l_new01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081                                             
   ELSE 
      COMMIT WORK                                                                                                                         
   END IF                                                                                                                           
   LET g_cnt = SQLCA.SQLERRD[3]                                                                                                     
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'                                                                         
                                                                                                                                    
   LET l_old01 = g_pjn01                                                                                                           
   LET g_pjn01 = l_new01                                                                                                           
   CALL t500_b()            
   #FUN-C80046---begin
   #SELECT pjn01 INTO g_pjn01                                                                                                      
   #FROM pjn_file WHERE pjn01 = l_oldno
   #LET g_pjn01 = l_old01                                                                                                           
   #CALL t500_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION t500_out()
DEFINE l_i      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       l_pjb03  LIKE pjb_file.pjb03, 
       l_pjk03  LIKE pjk_file.pjk03,
       l_pjj01  LIKE pjj_file.pjj01,
       sr       RECORD
                pjnacti LIKE pjn_file.pjnacti,
                pjn01   LIKE pjn_file.pjn01,
                pja02   LIKE pja_file.pja02,
                pjj01   LIKE pjj_file.pjj01,
                pjj02   LIKE pjj_file.pjj02,
                pjn02   LIKE pjn_file.pjn02,
                pjn03   LIKE pjn_file.pjn03,
                pjn04   LIKE pjn_file.pjn04,
                pjn05   LIKE pjn_file.pjn05,
                pjb03   LIKE pjb_file.pjb03,
                pjn06   LIKE pjn_file.pjn06,
                pjn07   LIKE pjn_file.pjn07,
                pjn08   LIKE pjn_file.pjn08,
                pjn09   LIKE pjn_file.pjn09                
                END RECORD,
       l_name   LIKE type_file.chr20,   #No.FUN-680137 VARCHAR(20)
       l_za05   LIKE type_file.chr1000 #No.FUN-680137CHAR(45)
DEFINE l_cmd    LIKE type_file.chr1000 
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
 
   CALL cl_wait()
#  CALL cl_outnam('apjt500') RETURNING l_name           #No.TQC-840018
   CALL cl_del_data(l_table)                            #No.TQC-840018
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
	 
      LET g_sql=" SELECT pjnacti,pjn01,pja02,pjj01,pjj02,pjn02,pjn03,pjn04,pjn05,'',pjn06,",
                " pjn07,pjn08,pjn09", 
                " FROM pjn_file,pja_file,pjj_file",
                " WHERE pjn01 = pja01 AND pja01 = pjj04 ",
                "   AND ",g_wc CLIPPED,
                " ORDER BY pjn01 "           	         
  PREPARE t500_p1 FROM g_sql                # RUNTIME 編譯
  DECLARE t500_co CURSOR FOR t500_p1
 
  FOREACH t500_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
       END IF  
      IF sr.pjn04 = 'W' THEN  
        SELECT pjb03 INTO l_pjb03 FROM pjb_file WHERE ltrim(rtrim(g_pjn[l_ac].pjn05)) = ltrim(rtrim(pjb02))                                              
        EXECUTE insert_prep USING sr.pjnacti, sr.pjn01, sr.pja02, sr.pjj01, sr.pjj02, sr.pjn02,
                                  sr.pjn03,   sr.pjn04, sr.pjn05, l_pjb03,  sr.pjn06, sr.pjn07,
                                  sr.pjn08,   sr.pjn09  
      END IF 
       IF sr.pjn04 = 'A' THEN
      	SELECT pjj01 INTO l_pjj01 FROM pjj_file WHERE pjj04 = sr.pjn01         
        SELECT pjk03 INTO l_pjb03 FROM pjk_file  #No.TQC-840009 
         WHERE ltrim(rtrim(g_pjn[l_ac].pjn05)) = ltrim(rtrim(pjk02))       #No.TQC-840009   
           AND pjk01 = l_pjj01                              #No.TQC-840009 
         EXECUTE insert_prep USING sr.pjnacti, sr.pjn01, sr.pja02, sr.pjj01, sr.pjj02, sr.pjn02,
                                   sr.pjn03,   sr.pjn04, sr.pjn05, l_pjb03, sr.pjn06, sr.pjn07,
                                   sr.pjn08,   sr.pjn09 
       END IF                                  
 
  END FOREACH
 
  CLOSE t500_co
  ERROR ""
# CALL cl_prt(l_name,' ','1',g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'pjn01,pjn02,pjn03,pjn04,pjn05,pjn06,pjn07,
                      pjn08,pjn09,pjnacti')         
            RETURNING g_wc                                                     
       LET g_str = g_wc                                                        
    END IF
#              p1  
   LET g_str = g_wc
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED   
   CALL cl_prt_cs3('apjt500','apjt500',l_sql,g_str)
 
END FUNCTION
 
FUNCTION t500_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1        
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("pjn01",TRUE) 
   END IF
 
END FUNCTION
 
FUNCTION t500_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("pjn01",FALSE) 
   END IF
END FUNCTION
#No.FUN-790025---End
