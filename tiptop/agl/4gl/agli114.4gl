# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli114.4gl
# Descriptions...: 列印族群權限維護
# Date & Author..: 96/10/14 By Danny  
# Modify.........: No.MOD-490435 93/09/27 By Yuna 單頭使用者要有可開窗查詢的功能
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510007 05/01/25 By Nicola 報表架構修改
# Modify.........: No.FUN-580026 05/08/10 By Sarah 在複製裡增加set_entry段
# Modify.........: No.TQC-630104 06/03/14 By Smapmin DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750022 07/05/09 By Lynn 復制時,用戶編號無法開窗選擇
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760085 07/08/01 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.TQC-790077 07/09/14 By Carrier 進入單身前,判斷單頭key值是否為NULL,若為NULL則不得進入
  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-960188 10/11/05 By sabrina 畫面上無cn3這個欄位 
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-BB0094 11/11/10 By Polly 調整錯誤訊息判斷迴圈
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
   g_abf01         LIKE abf_file.abf01,  
   g_abf01_t       LIKE abf_file.abf01, 
   g_abf01_o       LIKE abf_file.abf01,
   g_abf           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
       abf02       LIKE abf_file.abf02,                 
       abe02       LIKE abe_file.abe02                  
                   END RECORD,
   g_abf_t         RECORD                 #程式變數 (舊值)
       abf02       LIKE abf_file.abf02,                 
       abe02       LIKE abe_file.abe02                  
                   END RECORD,
   g_buf           LIKE zx_file.zx02,           #No.FUN-680098 VARCHAR(20)
   i               LIKE type_file.num5,         #No.FUN-680098 SMALLINT
    g_wc,g_sql,g_wc2    STRING,  #No.FUN-580092 HCN     
   g_rec_b         LIKE type_file.num5,         #單身筆數            #No.FUN-680098  SMALLINT
   l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT #No.FUN-680098  SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_before_input_done   LIKE type_file.num5       #No.FUN-680098   SMALLINT
DEFINE g_cnt                 LIKE type_file.num10      #No.FUN-680098  INTEGER
DEFINE g_i                   LIKE type_file.num5       #count/index for any purpose #No.FUN-680098 SMALLLINT
DEFINE g_msg                 LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10      #No.FUN-680098 INTEGER
DEFINE g_curs_index          LIKE type_file.num10      #No.FUN-680098 INTEGER
DEFINE g_jump                LIKE type_file.num10      #No.FUN-680098 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5       #No.FUN-680098 SMALLINT
#No.FUN-760085---Begin                                                          
DEFINE   g_str           STRING                                                 
DEFINE   l_sql           STRING                                                 
DEFINE   l_table         STRING                                                 
#No.FUN-760085---End   
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0073
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680098       SMALLINT
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                    #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   #No.FUN-760085---Begin
   LET g_sql = "abf01.abf_file.abf01,",
               "zx02.zx_file.zx02,",
               "abf02.abf_file.abf02,",
               "gem02.gem_file.gem02 "
   
   LET l_table = cl_prt_temptable('agli114',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?) "                            
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
   #NO.FUN-760085---End   
 
   LET i=0
   LET g_abf01_t = NULL
 
   LET p_row = 4 LET p_col = 30
   OPEN WINDOW i114_w AT p_row,p_col
     WITH FORM "agl/42f/agli114"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL i114_menu()
 
   CLOSE FORM i114_w                      #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i114_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_abf.clear()
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0029 
 
   INITIALIZE g_abf01 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON abf01,abf02 FROM abf01,s_abf[1].abf02  #螢幕上取單頭條件
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP     #查詢列印族群
         CASE
             #--No.MOD-490435
            WHEN INFIELD(abf01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_zx"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_abf01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO abf01
                 NEXT FIELD abf01
            #--END
            WHEN INFIELD(abf02)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_abe"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret 
               DISPLAY g_qryparam.multiret to abf02 
               NEXT FIELD abf02
            OTHERWISE EXIT CASE
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('abfuser', 'abfgrup') #FUN-980030
 
   IF INT_FLAG THEN RETURN END IF
   LET g_sql= "SELECT UNIQUE abf01 FROM abf_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY 1"
   PREPARE i114_prepare FROM g_sql        #預備一下
   DECLARE i114_bcs                       #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i114_prepare
 
   LET g_sql="SELECT COUNT(DISTINCT abf01)  ",
             " FROM abf_file WHERE ", g_wc CLIPPED
   PREPARE i114_precount FROM g_sql
   DECLARE i114_count CURSOR FOR i114_precount
 
END FUNCTION
 
FUNCTION i114_menu()
 
   WHILE TRUE
      CALL i114_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i114_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i114_q()
            END IF 
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i114_r()
            END IF 
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL i114_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i114_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i114_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_abf01 IS NOT NULL THEN
                  LET g_doc.column1 = "abf01"
                  LET g_doc.value1 = g_abf01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abf),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i114_a()
 
   IF s_aglshut(0) THEN RETURN END IF                #判斷目前系統是否可用
 
   MESSAGE ""
   CLEAR FORM
   CALL g_abf.clear()
   INITIALIZE g_abf01 LIKE abf_file.abf01         #DEFAULT 設定
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i114_i("a")                           #輸入單頭
 
      IF INT_FLAG THEN                           #使用者不玩了
         LET g_abf01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_abf01 IS NULL THEN # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      CALL g_abf.clear()
       LET g_rec_b = 0                            #MOD-470036
 
      CALL i114_b()                              #輸入單身
 
      LET g_abf01_t = g_abf01                    #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i114_i(p_cmd)
DEFINE l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入 #No.FUN-680098 VARCHAR(1)
       l_n1            LIKE type_file.num5,          #No.FUN-680098  SMALLINT
       p_cmd           LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680098  VARCHAR(1)
 
   DISPLAY g_abf01 TO abf01
   CALL cl_set_head_visible("","YES")                #No.FUN-6B0029 
   INPUT g_abf01 FROM abf01 
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i114_set_entry(p_cmd)
         CALL i114_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD abf01
         IF NOT cl_null(g_abf01) THEN 
            SELECT COUNT(*) INTO g_cnt FROM abf_file WHERE abf01 = g_abf01
            IF g_cnt > 0 THEN
               CALL cl_err(g_abf01,-239,0)
               NEXT FIELD abf01
            END IF
            SELECT zx02 INTO g_buf FROM zx_file WHERE zx01 = g_abf01 
            IF STATUS THEN
#              CALL cl_err('sel zx',STATUS,1)   #No.FUN-660123
               CALL cl_err3("sel","zx_file",g_abf01,"",STATUS,"","sel zx",1)  #No.FUN-660123
               NEXT FIELD abf01
            END IF
            DISPLAY g_buf TO zx02
            LET g_abf01_o = g_abf01
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       #--No.MOD-490435
      ON ACTION CONTROLP
        CASE
           WHEN INFIELD(abf01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zx"
              LET g_qryparam.default1 = g_abf01
              CALL cl_create_qry() RETURNING g_abf01
              DISPLAY BY NAME g_abf01
              NEXT FIELD abf01
 
           OTHERWISE
              EXIT CASE
           END CASE
      #--END
    
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
 
FUNCTION i114_copy()
   DEFINE l_n            LIKE type_file.num5,          #No.FUN-680098  SMALLINT
          l_newno        LIKE abf_file.abf01,
          l_oldno        LIKE abf_file.abf01
 
   IF s_aglshut(0) THEN RETURN END IF
 
   IF g_abf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE       #FUN-580026
   CALL i114_set_entry('a')              #FUN-580026
   LET g_before_input_done = TRUE        #FUN-580026
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
   INPUT l_newno FROM abf01
 
      AFTER FIELD abf01
         IF cl_null(l_newno) THEN
            NEXT FIELD abf01
         END IF
# No.TQC-750022-- begin
      ON ACTION CONTROLP                                                                                                            
        CASE                                                                                                                        
           WHEN INFIELD(abf01)                                                                                                      
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form = "q_zx"                                                                                          
              LET g_qryparam.default1 = g_abf01                                                                                     
              CALL cl_create_qry() RETURNING l_newno                                                                                
              DISPLAY BY NAME l_newno                                                                                               
              NEXT FIELD abf01                                                                                                      
                                                                                                                                    
           OTHERWISE                                                                                                                
              EXIT CASE                                                                                                             
           END CASE
# No.TQC-750022-- end
 
         SELECT COUNT(*) INTO g_cnt FROM abf_file WHERE abf01=l_newno 
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD abf01
         END IF
 
         LET g_buf = ''
 
         SELECT zx02 INTO g_buf FROM zx_file WHERE zx01 = l_newno
         IF STATUS THEN 
#           CALL cl_err('sel zx',STATUS,1)   #No.FUN-660123
            CALL cl_err3("sel","zx_file",l_newno,"",STATUS,"","sel zx",1)  #No.FUN-660123
            NEXT FIELD abf01 
         END IF
 
         DISPLAY g_buf TO zx02
 
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
      DISPLAY g_abf01 TO abf01 
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM abf_file WHERE abf01=g_abf01 INTO TEMP x
 
   UPDATE x SET abf01 = l_newno,    #資料鍵值
                abfuser = g_user,   #資料所有者
                abfgrup = g_grup,   #資料所有者所屬群
                abfmodu = NULL,     #資料修改日期
                abfdate = g_today,  #資料建立日期
                abfacti = 'Y'       #有效資料
 
   INSERT INTO abf_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_abf01,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("ins","abf_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
   ELSE
      MESSAGE 'ROW(',l_newno,') O.K' 
      LET g_abf01 = l_newno
 
      CALL i114_b()
 
      CALL i114_show()
 
   END IF
 
   DISPLAY g_abf01 TO abf01 
 
END FUNCTION
 
FUNCTION i114_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_abf01 TO NULL                #No.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_abf.clear()
 
   CALL i114_cs()                            #取得查詢條件
 
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i114_bcs                             #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                     #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_abf01 TO NULL
   ELSE
      CALL i114_fetch('F')                   #讀出TEMP第一筆並顯示
      OPEN i114_count
      FETCH i114_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
 
END FUNCTION
 
FUNCTION i114_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1,     #處理方式        #No.FUN-680098 VARCHAR(1)
       l_abso          LIKE type_file.num10     #絕對的筆數      #No.FUN-680098 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i114_bcs INTO g_abf01
      WHEN 'P' FETCH PREVIOUS i114_bcs INTO g_abf01
      WHEN 'F' FETCH FIRST    i114_bcs INTO g_abf01
      WHEN 'L' FETCH LAST     i114_bcs INTO g_abf01
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
 
         FETCH ABSOLUTE g_jump i114_bcs INTO g_abf01
 
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_abf01,SQLCA.sqlcode,0)
      INITIALIZE g_abf01 TO NULL  #TQC-6B0105
   ELSE
      CALL i114_show()
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
 
FUNCTION i114_show()
 
   DISPLAY g_abf01 TO abf01               #單頭
 
   SELECT zx02 INTO g_buf FROM zx_file WHERE zx01 = g_abf01
   IF STATUS THEN
      LET g_buf = ''
   END IF
   DISPLAY g_buf TO zx02 
 
   CALL i114_bf(g_wc)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i114_r()
   DEFINE l_chr LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF s_aglshut(0) THEN RETURN END IF
 
   IF g_abf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
 
   BEGIN WORK
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "abf01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_abf01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM abf_file WHERE abf01=g_abf01 
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_abf01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("del","abf_file",g_abf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
      ELSE
         CLEAR FORM
         CALL g_abf.clear()
      END IF
 
      CALL g_abf.clear()
      OPEN i114_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i114_bcs
         CLOSE i114_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH i114_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i114_bcs
         CLOSE i114_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
 
      OPEN i114_bcs
       #MOD-470036
      IF g_row_count > 0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i114_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i114_fetch('/')
         END IF
      END IF
      #--
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i114_b()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680098 SMALLINT
       l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680098 SMALLINT
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680098 VARCHAR(1)
       l_sql           LIke type_file.chr1000,  #No.FUN-680098     VARCHAR(300)
       p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680098  VARCHAR(1)
       l_allow_insert  LIKE type_file.chr1,     #可新增否          #No.FUN-680098  VARCHAR(1) 
       l_allow_delete  LIKE type_file.chr1      #可刪除否          #No.FUN-680098  VARCHAR(1) 
 
   #No.TQC-790077  --Begin
   IF g_abf01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_action_choice = ""   #MOD-BB0094 add
      RETURN
   END IF
   #No.TQC-790077  --End  
 
   LET g_action_choice = ""
   IF s_aglshut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT abf02 FROM abf_file ",
                      " WHERE abf01=? AND abf02 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i114_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   INPUT ARRAY g_abf WITHOUT DEFAULTS FROM s_abf.*
      ATTRIBUTE (COUNT =g_rec_b,MAXCOUNT =g_max_rec,UNBUFFERED, 
                 INSERT ROW = l_allow_insert,DELETE ROW =l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_abf_t.* = g_abf[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i114_bcl USING g_abf01,g_abf_t.abf02
            IF STATUS THEN
               CALL cl_err("OPEN i114_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
           #END IF                                                 #MOD-BB0094 mark
            ELSE                                                   #MOD-BB0094 add
              FETCH i114_bcl INTO g_abf[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_abf_t.abf02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
            END IF                                                  #MOD-BB0094 add
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         IF l_ac <= l_n then                   #DISPLAY NEWEST
            SELECT gem02 INTO g_abf[l_ac].abe02 FROM gem_file          
             WHERE gem01=g_abf[l_ac].abf02 AND gem05='Y' AND gemacti='Y'
            IF STATUS = 100 THEN
               LET l_sql = "SELECT abe02 FROM abe_file ",
                           " WHERE abe01= ? AND abeacti='Y' "
               PREPARE abe_pred FROM l_sql
               DECLARE abe_cursd CURSOR FOR abe_pred
               OPEN abe_cursd USING g_abf[l_ac].abf02
               FETCH abe_cursd INTO g_abf[l_ac].abe02
            END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_abf[l_ac].* TO NULL      #900423
         LET g_abf_t.* = g_abf[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD abf02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err(g_abf[l_ac].abf02,9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO abf_file(abf01,abf02,abfacti,abfuser,abfgrup,abfmodu,abfdate,abforiu,abforig)
                       VALUES(g_abf01,g_abf[l_ac].abf02,'Y',g_user,g_grup,'',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_abf[l_ac].abf02,SQLCA.sqlcode,0)   #No.FUN-660123
            CALL cl_err3("ins","abf_file",g_abf01,g_abf[l_ac].abf02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            SELECT COUNT(*) INTO g_rec_b FROM abf_file
            WHERE abf01=g_abf01
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD abf02
         IF g_abf[l_ac].abf02 != g_abf_t.abf02 OR 
            (g_abf[l_ac].abf02 IS NOT NULL AND g_abf_t.abf02 IS NULL) THEN
            SELECT COUNT(*) INTO l_n
              FROM abf_file
             WHERE abf01 = g_abf01 AND abf02 = g_abf[l_ac].abf02
            IF l_n > 0 THEN
               CALL cl_err(g_abf[l_ac].abf02,-239,0)
               LET g_abf[l_ac].abf02 = g_abf_t.abf02
               NEXT FIELD abf02
            ELSE
               SELECT gem02 INTO g_abf[l_ac].abe02 FROM gem_file
                WHERE gem01=g_abf[l_ac].abf02 AND gem05='Y' AND gemacti='Y'
               IF STATUS=100 THEN   #資料不存在
                  DECLARE abe_curs CURSOR FOR 
                   SELECT abe02 FROM abe_file
                    WHERE abe01=g_abf[l_ac].abf02 AND abeacti='Y'
                  OPEN abe_curs
                  FETCH abe_curs INTO g_abf[l_ac].abe02
                  IF STATUS=100 THEN
                     CALL cl_err(g_abf[l_ac].abf02,100,0)  
                     LET g_abf[l_ac].abf02 = g_abf_t.abf02
                     NEXT FIELD abf02
                  END IF
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_abf_t.abf02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM abf_file
             WHERE abf01 = g_abf01 AND abf02 = g_abf[l_ac].abf02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_abf_t.abf02,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("del","abf_file",g_abf01,g_abf[l_ac].abf02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err(g_abf[l_ac].abf02,9001,0)
            LET INT_FLAG = 0
            LET g_abf[l_ac].* = g_abf_t.*
            CLOSE i114_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_abf[l_ac].abf02,-263,1)
            LET g_abf[l_ac].* = g_abf_t.*
         ELSE
            UPDATE abf_file SET abf02 = g_abf[l_ac].abf02,
                                abfmodu = g_user,
                                abfdate = g_today
             WHERE abf01=g_abf01 AND abf02=g_abf_t.abf02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_abf[l_ac].abf02,SQLCA.sqlcode,0)   #No.FUN-660123
               CALL cl_err3("upd","abf_file",g_abf01,g_abf_t.abf02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_abf[l_ac].* = g_abf_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err(g_abf[l_ac].abf02,9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_abf[l_ac].* = g_abf_t.*
            #FUN-D30032--add--begin--
            ELSE
               CALL g_abf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF
            CLOSE i114_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30032 add
         CLOSE i114_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP     #查詢列印族群
         CASE
            WHEN INFIELD(abf02)  
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_abe"
               LET g_qryparam.default1 = g_abf[l_ac].abf02
               CALL cl_create_qry() RETURNING g_abf[l_ac].abf02
                DISPLAY BY NAME g_abf[l_ac].abf02                #MOD-470036
#               CALL FGL_DIALOG_SETBUFFER( g_abf[l_ac].abf02 )
               NEXT FIELD abf02
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION qry_department   #查詢列印部門
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_gem"
         LET g_qryparam.default1 = g_abf[l_ac].abf02
         CALL cl_create_qry() RETURNING g_abf[l_ac].abf02
         NEXT FIELD abf02
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(abf02) AND l_ac > 1 THEN
            LET g_abf[l_ac].* = g_abf[l_ac-1].*
            DISPLAY g_abf[l_ac].* TO s_abf[l_ac].*
            NEXT FIELD abf02
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end    
 
   END INPUT
 
   CLOSE i114_bcl
   COMMIT WORK
 
END FUNCTION
   
FUNCTION i114_b_askkey()
DEFINE l_wc     LIKE type_file.chr1000 #No.FUN-680098 VARCHAR(200)
 
   CONSTRUCT l_wc ON abf02 FROM s_abf[1].abf02
 
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
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   CALL i114_bf(l_wc)
 
END FUNCTION
 
FUNCTION i114_bf(p_wc)              #BODY FILL UP
DEFINE p_wc,l_sql   LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(200)
 
   LET g_sql = "SELECT abf02 FROM abf_file ",
               " WHERE abf01 = '",g_abf01,"' AND ", p_wc CLIPPED ,
               " ORDER BY 1"
   PREPARE i114_prepare2 FROM g_sql      #預備一下
   IF STATUS THEN
      CALL cl_err('i114_prepare2',STATUS,0)
      RETURN
   END IF
   DECLARE abf_cs CURSOR FOR i114_prepare2
 
   CALL g_abf.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
   LET l_sql = "SELECT abe02 FROM abe_file ",
               " WHERE abe01= ? AND abeacti='Y' "
   PREPARE abe_pre2 FROM l_sql
   DECLARE abe_curs2 CURSOR FOR abe_pre2
 
   FOREACH abf_cs INTO g_abf[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT gem02 INTO g_abf[g_cnt].abe02 FROM gem_file          
       WHERE gem01 = g_abf[g_cnt].abf02
         AND gem05 = 'Y'
         AND gemacti = 'Y'
      IF STATUS = 100 THEN
         OPEN abe_curs2 USING g_abf[g_cnt].abf02
         FETCH abe_curs2 INTO g_abf[g_cnt].abe02
      END IF
      LET g_cnt = g_cnt + 1
      #-----TQC-630104---------
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
      #-----END TQC-630104-----
   END FOREACH
 
   CALL g_abf.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
  #DISPLAY g_cnt TO FORMONLY.cn3      #TQC-960188 mark 
 
END FUNCTION
 
FUNCTION i114_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_abf TO s_abf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i114_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i114_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL i114_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i114_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL i114_fetch('L')
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
 
   
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i114_set_entry(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("abf01",TRUE)
   END IF 
 
END FUNCTION
 
FUNCTION i114_set_no_entry(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("abf01",FALSE) 
   END IF 
 
END FUNCTION
 
FUNCTION i114_out()
   DEFINE l_i             LIKE type_file.num5,       #No.FUN-680098 SMALLINT
          l_name          LIKE type_file.chr20,      # External(Disk) file name    #No.FUN-680098 VARCHAR(20)
          l_chr           LIKE type_file.chr1,       #No.FUN-680098  VARCHAR(1)
          l_abf           RECORD LIKE abf_file.*
   DEFINE l_zx02          LIKE zx_file.zx02          #No.FUN-760085 
   DEFINE l_gem02         LIKE gem_file.gem02        #No.FUN-760085        
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
 
   CALL cl_wait()
   #CALL cl_outnam('agli114') RETURNING l_name           #No.FUN-760085
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-760085  
   LET g_sql="SELECT * FROM abf_file ",          # 組合出 SQL 指令
             " WHERE ",g_wc CLIPPED
   PREPARE i114_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i114_co CURSOR FOR i114_p1
 
   #START REPORT i114_rep TO l_name          #No.FUN-760085                    
    CALL cl_del_data(l_table)                #No.FUN-760085 
 
   FOREACH i114_co INTO l_abf.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)  
         EXIT FOREACH
      END IF
      #No.FUN-760085---Begin
      #OUTPUT TO REPORT i114_rep(l_abf.*)
      LET l_zx02 = ''                                                         
         SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=l_abf.abf01                
         IF STATUS THEN                                                         
            LET l_zx02 = ''                                                      
         END IF     
      LET l_gem02= ''                                                         
         SELECT gem02 INTO l_gem02 FROM gem_file                                  
          WHERE gem01 = l_abf.abf02                                                
            AND gem05 = 'Y'                                                     
            AND gemacti = 'Y'                                                   
         IF STATUS = 100 THEN                                                   
            DECLARE abe_curs3 CURSOR FOR SELECT abe02 FROM abe_file             
                                         WHERE abe01 = l_abf.abf02                 
                                           AND abeacti = 'Y'                    
            OPEN abe_curs3                                                      
            FETCH abe_curs3 INTO l_gem02                                          
         END IF               
      EXECUTE insert_prep USING l_abf.abf01,l_zx02,l_abf.abf02,l_gem02
      #No.FUN-760085---End  
   END FOREACH
 
   #FINISH REPORT i114_rep                   #No.FUN-760085   
 
   CLOSE i114_co
   ERROR "" 
   #No.FUN-760085---Begin
   IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'abf01,abf02')          
            RETURNING g_str                                                      
    END IF                                                                      
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
    #CALL cl_prt(l_name,' ','1',g_len)
    CALL cl_prt_cs3('agli114','agli114',l_sql,g_str)                            
   #No.FUN-760085---End     
 
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT i114_rep(sr)
   DEFINE l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680098   VARCHAR(1)
          sr RECORD LIKE abf_file.*, 
          l_chr           LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
          l_buf           LIKE zx_file.zx02        #No.FUN-680098  VARCHAR(20)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.abf01,sr.abf02
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34]
         PRINT g_dash1 
         LET l_trailer_sw = 'y'
 
      BEFORE GROUP OF sr.abf01
         LET l_buf = ''
         SELECT zx02 INTO l_buf FROM zx_file WHERE zx01=sr.abf01
         IF STATUS THEN 
            LET l_buf = '' 
         END IF
         PRINT COLUMN g_c[31],sr.abf01,
               COLUMN g_c[32],l_buf CLIPPED;
 
      ON EVERY ROW
         LET l_buf = ''
         SELECT gem02 INTO l_buf FROM gem_file
          WHERE gem01 = sr.abf02
            AND gem05 = 'Y'
            AND gemacti = 'Y'
         IF STATUS = 100 THEN
            DECLARE abe_curs3 CURSOR FOR SELECT abe02 FROM abe_file 
                                         WHERE abe01 = sr.abf02
                                           AND abeacti = 'Y' 
            OPEN abe_curs3
            FETCH abe_curs3 INTO l_buf
         END IF
         PRINT COLUMN g_c[33],sr.abf02,
               COLUMN g_c[34],l_buf CLIPPED 
 
      AFTER GROUP OF sr.abf01
         PRINT ''
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
         LET l_trailer_sw = 'n'
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT}
#No.FUN-760085---End
