# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi170.4gl
# Descriptions...: 非用人費項目維護作業
# Date & Author..: 03/10/22 By Jukey  
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........:No.FUN-4C0067 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-510025 05/01/17 By Smapmin 報表轉XML格式
# Modify.........: NO.MOD-580192 05/08/23 By Smapmin 修改權限控管
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確'
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/18 By jamie 1.FUNCTION i170()_q 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"  
 
#模組變數(Module Variables)
DEFINE 
   g_bgv00         LIKE bgv_file.bgv00,   #費用別
   g_bgv00_t       LIKE bgv_file.bgv00,   #費用別(舊值)
   g_bgv01         LIKE bgv_file.bgv01,   #版本
   g_bgv01_t       LIKE bgv_file.bgv01,   #版本(舊值)
   g_bgv02         LIKE bgv_file.bgv02,   #年度    
   g_bgv02_t       LIKE bgv_file.bgv02,   #年度(舊值)
   g_bgv03         LIKE bgv_file.bgv03,   #月份    
   g_bgv03_t       LIKE bgv_file.bgv03,   #月份(舊值)
   g_bgv04         LIKE bgv_file.bgv04,   #部門編號
   g_bgv04_t       LIKE bgv_file.bgv04,   #部門編號(舊值)
   g_bgvuser       LIKE bgv_file.bgvuser,    
   g_bgvgrup       LIKE bgv_file.bgvgrup,   
   g_tot           LIKE bgv_file.bgv10,   #總金額
   g_tot_t         LIKE bgv_file.bgv10,   #總金額(舊值)
   g_bgv           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
      bgv05        LIKE bgv_file.bgv05,   #費用項目
      bgs02        LIKE bgs_file.bgs02,   #細部分累
      bgv11        LIKE bgv_file.bgv11,   #細部分類
      bgv06        LIKE bgv_file.bgv06,   #直/間接
      bgv10        LIKE bgv_file.bgv10    #金額
                   END RECORD,
   g_bgv_t         RECORD                 #程式變數(舊值)
      bgv05        LIKE bgv_file.bgv05,   #費用項目
      bgs02        LIKE bgs_file.bgs02,   #細部分累
      bgv11        LIKE bgv_file.bgv11,   #細部分類
      bgv06        LIKE bgv_file.bgv06,   #直/間接
      bgv10        LIKE bgv_file.bgv10    #金額
                   END RECORD,
   g_wc,g_sql,g_wc2  LIKE type_file.chr1000,#No.FUN-680061 VARCHAR(1300)
   g_show          LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
   g_rec_b         LIKE type_file.num5,   #單身筆數 #No.FUN-680061 SMALLINT
   g_flag          LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
   g_ver           LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
   g_ss            LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
   l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
DEFINE p_row,p_col LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE g_forupd_sql  STRING               #SELECT ... FOR UPDATE SQL                         
DEFINE g_sql_tmp     STRING               #No.TQC-720019
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680061 SMALLINT
                                                                                
DEFINE g_cnt       LIKE type_file.num10   #No.FUN-680061 INTEGER
DEFINE g_i         LIKE type_file.num5    #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_msg       LIKE ze_file.ze03      #No.FUN-680061 VARCHAR(72)
DEFINE g_row_count LIKE type_file.num10   #No.FUN-680061 INTEGER
DEFINE g_curs_index LIKE type_file.num10  #No.FUN-680061 INTEGER
DEFINE g_jump      LIKE type_file.num10   #查詢指定的筆數 #No.FUN-680061 INTEGER
DEFINE mi_no_ask   LIKE type_file.num5    #是否開啟指定筆視窗 #No.FUN-680061 SMALLINT #No.FUN-6A0057 g_no_ask 
 
#主程式開始
MAIN
#  DEFINE     l_time      LIKE type_file.chr8           #No.FUN-6A0056
  
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log                                          
                                                                                
    IF (NOT cl_setup("ABG")) THEN                                               
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
                                                                                
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time                                                                                                            #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
    LET p_row = 2 LET p_col = 12      
 
    OPEN WINDOW i170_w AT p_row,p_col                                           
         WITH FORM "abg/42f/abgi170"                                            
          ATTRIBUTE (STYLE = g_win_style CLIPPED)                                         #No.FUN-580092 HCN
                                                                                
    CALL cl_ui_init()                                                           
 
    CALL i170_menu()      
 
    CLOSE WINDOW i170_w                      #結束畫面
    CALL  cl_used(g_prog,g_time,2)  #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i170_cs()
    CLEAR FORM                               #清除畫面
    CALL g_bgv.clear()
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_bgv01 TO NULL    #No.FUN-750051
   INITIALIZE g_bgv02 TO NULL    #No.FUN-750051
   INITIALIZE g_bgv03 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bgv01,bgv02,bgv03,bgv04,bgv05,bgv11,bgv06,bgv10
         FROM bgv01,bgv02,bgv03,bgv04,
              s_bgv[1].bgv05,s_bgv[1].bgv11,s_bgv[1].bgv06,s_bgv[1].bgv10
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
            ON ACTION CONTROLP                                                  
               CASE                                                             
                  WHEN INFIELD(bgv04) #產品名稱                                 
                       CALL cl_init_qry_var()                                   
                       LET g_qryparam.state = "c"                               
                       LET g_qryparam.form ="q_gem"                             
                       CALL cl_create_qry() RETURNING g_qryparam.multiret       
                       DISPLAY g_qryparam.multiret TO bgv04                     
                       NEXT FIELD bgv04
                  WHEN INFIELD(bgv05)                                 
                       CALL cl_init_qry_var()                                   
                       LET g_qryparam.state = "c"                               
                       LET g_qryparam.form ="q_bgs"                             
                       CALL cl_create_qry() RETURNING g_qryparam.multiret       
                       DISPLAY g_qryparam.multiret TO bgv05                     
                       NEXT FIELD bgv05                   
               END CASE
 
                ON IDLE g_idle_seconds                                          
                   CALL cl_on_idle()                                            
                   CONTINUE CONSTRUCT                                           
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                                                                                
             END CONSTRUCT               
             LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bgvuser', 'bgvgrup') #FUN-980030
      IF INT_FLAG THEN RETURN END IF
 
    LET g_sql = "SELECT UNIQUE bgv01,bgv02,bgv03,bgv04 ",
                "  FROM bgv_file ",
                " WHERE ", g_wc CLIPPED,
                " AND bgv00 = '2' ", 
                " ORDER BY bgv01"
    PREPARE i170_prepare FROM g_sql          #預備一下
    DECLARE i170_bcs                         #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i170_prepare
      
#LET g_sql = "SELECT UNIQUE bgv01, bgv02, bgv03 , bgv04 ",      #No.TQC-720019
 LET g_sql_tmp = "SELECT UNIQUE bgv01, bgv02, bgv03 , bgv04 ",  #No.TQC-720019
             "  FROM bgv_file ",
             " WHERE ", g_wc CLIPPED,
             "   AND bgv00='2'      ",
             " INTO TEMP x "
 DROP TABLE x
#PREPARE i170_pre_x FROM g_sql      #No.TQC-720019
 PREPARE i170_pre_x FROM g_sql_tmp  #No.TQC-720019
 EXECUTE i170_pre_x
 
 LET g_sql = "SELECT COUNT(*) FROM x"
 PREPARE i170_precnt FROM g_sql
 DECLARE i170_count CURSOR FOR i170_precnt
 
  
END FUNCTION
 
FUNCTION i170_menu()
   WHILE TRUE                                                                   
      CALL i170_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "insert"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i170_a()                                                    
            END IF                                                              
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i170_q()                                                    
            END IF                                                              
         WHEN "delete"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i170_r()                                                    
            END IF                                                              
#         WHEN "modify"                                                          
#            IF cl_chk_act_auth() THEN                                           
#               CALL i170_u()                                                    
#            END IF                
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i170_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i170_out()                                                  
            END IF                                                              
         WHEN "help"                                                            
            CALL cl_show_help()                                                    
         WHEN "exit"                                                            
            EXIT WHILE                                                          
         WHEN "controlg"                                                        
            CALL cl_cmdask()                                                    
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgv),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bgv01 IS NOT NULL THEN
                LET g_doc.column1 = "bgv01"
                LET g_doc.column2 = "bgv02"
                LET g_doc.column3 = "bgv03"
                LET g_doc.column4 = "bgv04" 
                LET g_doc.value1 = g_bgv01
                LET g_doc.value2 = g_bgv02
                LET g_doc.value3 = g_bgv03
                LET g_doc.value4 = g_bgv04
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0003-------add--------end----
      END CASE                                                                  
   END WHILE                                                                    
END FUNCTION          
 
 
 
FUNCTION i170_a()
    IF s_shut(0) THEN RETURN END IF               
   MESSAGE ""
   CLEAR FORM
   LET g_bgv01   = NULL
   LET g_bgv02   = NULL
   LET g_bgv03   = NULL
   LET g_bgv04   = NULL
   LET g_bgv01_t = NULL
   LET g_bgv02_t = NULL
   LET g_bgv03_t = NULL
   LET g_bgv04_t = NULL
   CALL g_bgv.clear()
   CALL cl_opmsg('a')
   WHILE TRUE
       LET g_bgvuser=g_user   #MOD-580192
       LET g_bgvgrup=g_grup   #MOD-580192
      CALL i170_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_bgv01 = NULL
         LET g_bgv02 = NULL
         LET g_bgv03 = NULL
         LET g_bgv04 = NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0                    #No.FUN-680064
      IF g_ss='N' THEN                                                        
         FOR g_cnt = 1 TO g_bgv.getLength()                                  
             INITIALIZE g_bgv[g_cnt].* TO NULL                               
         END FOR                                                             
      ELSE                                                                    
         CALL i170_b_fill(' 1=1')          #單身                             
      END IF     
 
      CALL i170_b()                      #輸入單身
      LET g_bgv01_t = g_bgv01
      LET g_bgv02_t = g_bgv02
      LET g_bgv03_t = g_bgv03
      LET g_bgv04_t = g_bgv04
      LET g_wc="     bgv01='",g_bgv01,"' ",
               " AND bgv02='",g_bgv02,"' "
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION i170_i(p_cmd)
   DEFINE
      p_cmd    LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680061 VARCHAR(01)
      l_n      LIKE type_file.num5,    #No.FUN-680061 SMALLINT
      l_str    LIKE type_file.chr50    #NO.FUN-680061 VARCHAR(40)
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0033 
   INPUT g_bgv01,g_bgv02,g_bgv03,g_bgv04 WITHOUT DEFAULTS
         FROM bgv01,bgv02,bgv03,bgv04 
 
      AFTER FIELD bgv01
         IF cl_null(g_bgv01) THEN LET g_bgv01 = ' ' END IF
 
      AFTER FIELD bgv02                    #年度
         IF NOT cl_null(g_bgv02) THEN
            IF g_bgv02 < 1 THEN
               NEXT FIELD bgv02
            END IF
         END IF 
 
      AFTER FIELD bgv03
         IF NOT cl_null(g_bgv03) THEN         #月份
            IF g_bgv03 < 1 OR g_bgv03 > 12 THEN
               NEXT FIELD bgv03
            END IF
         END IF
 
      AFTER FIELD bgv04                    #部門編號
         IF NOT cl_null(g_bgv04) THEN
            CALL i170_bgv04('a',g_bgv04)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD bgv04
            END IF
         END IF
 
        ON ACTION CONTROLP                                                     
           CASE                                                                 
              WHEN INFIELD(bgv04) #客戶編號                                     
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_gem"                                 
                   LET g_qryparam.default1 = g_bgv04                            
                   CALL cl_create_qry() RETURNING g_bgv04                       
                   NEXT FIELD bgv04                                             
            END CASE       
 
      ON ACTION CONTROLF               #欄位說明
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
 
FUNCTION i170_bgv04(p_cmd,p_key)  #部門編號
    DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bgv_file.bgv04,
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = " "
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file WHERE gem01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET l_gem02 = ' '
         WHEN l_gemacti='N'        LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
END FUNCTION
 
FUNCTION i170_bgv05(p_cmd)
DEFINE
    p_cmd       LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
    l_bgsacti   LIKE bgs_file.bgsacti
 
    LET g_errno = ' '
    SELECT bgs02,bgsacti INTO g_bgv[l_ac].bgs02,l_bgsacti
      FROM bgs_file
     WHERE bgs01 = g_bgv[l_ac].bgv05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-004'
                                   LET g_bgv[l_ac].bgs02   = NULL
                                   LET l_bgsacti = NULL
         WHEN l_bgsacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
 
#Query 查詢
FUNCTION i170_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    INITIALIZE g_bgv01  TO NULL       #No.FUN-6A0003
    INITIALIZE g_bgv02  TO NULL       #No.FUN-6A0003
    INITIALIZE g_bgv03  TO NULL       #No.FUN-6A0003
    INITIALIZE g_bgv04  TO NULL       #No.FUN-6A0003
    CLEAR FORM
    CALL g_bgv.clear()
 
   CALL i170_cs()                      #取得查詢條件
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_bgv01  TO NULL
      INITIALIZE g_bgv02  TO NULL
      INITIALIZE g_bgv03  TO NULL
      INITIALIZE g_bgv04  TO NULL
      RETURN
   END IF
   OPEN i170_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bgv01  TO NULL
      INITIALIZE g_bgv02  TO NULL
      INITIALIZE g_bgv03  TO NULL
      INITIALIZE g_bgv04  TO NULL
   ELSE
      OPEN i170_count
      FETCH i170_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i170_fetch('F')             #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i170_fetch(p_flag)
   DEFINE
      p_flag   LIKE type_file.chr1     #處理方式 #No.FUN-680061 VARCHAR(01)
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i170_bcs INTO g_bgv01,g_bgv02,g_bgv03,
                                            g_bgv04
      WHEN 'P' FETCH PREVIOUS i170_bcs INTO g_bgv01,g_bgv02,g_bgv03,
                                            g_bgv04
      WHEN 'F' FETCH FIRST    i170_bcs INTO g_bgv01,g_bgv02,g_bgv03,
                                            g_bgv04
      WHEN 'L' FETCH LAST     i170_bcs INTO g_bgv01,g_bgv02,g_bgv03,
                                            g_bgv04
      WHEN '/'
      IF (NOT mi_no_ask) THEN     #No.FUN-6A0057 g_no_ask 
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
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
      END IF
         FETCH ABSOLUTE g_jump i170_bcs INTO g_bgv01,g_bgv02,g_bgv03,
                                             g_bgv04
         LET mi_no_ask = FALSE    #No.FUN-6A0057 g_no_ask 
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_bgv01,SQLCA.sqlcode,0)
      INITIALIZE g_bgv01 TO NULL  #TQC-6B0105
      INITIALIZE g_bgv02 TO NULL  #TQC-6B0105
      INITIALIZE g_bgv03 TO NULL  #TQC-6B0105
      INITIALIZE g_bgv04 TO NULL  #TQC-6B0105
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
      LET g_data_owner = g_bgvuser   #FUN-4C0067
      LET g_data_group = g_bgvgrup   #FUN-4C0067
      CALL i170_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i170_show()
    
   DISPLAY g_bgv01 TO bgv01                 #單頭
   DISPLAY g_bgv02 TO bgv02                 #單頭
   DISPLAY g_bgv03 TO bgv03                 #單頭
   DISPLAY g_bgv04 TO bgv04                 #單頭
   CALL i170_bgv04('d',g_bgv04)
   CALL i170_b_fill(g_wc)                   #單身
   CALL i170_sum()
   CALL i170_bp("D")
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i170_r()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_bgv01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF   #No.FUN-6A0003
   BEGIN WORK
  
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bgv01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "bgv02"      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "bgv03"      #No.FUN-9B0098 10/02/24
       LET g_doc.column4 = "bgv04"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bgv01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_bgv02       #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_bgv03       #No.FUN-9B0098 10/02/24
       LET g_doc.value4 = g_bgv04       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM bgv_file 
      WHERE bgv00 = '2'
        AND bgv01 = g_bgv01
        AND bgv02 = g_bgv02
        AND bgv03 = g_bgv03
        AND bgv04 = g_bgv04
 #      AND bgv05 = g_bgv[l_ac].bgv05
 #      AND bgv06 = g_bgv[l_ac].bgv06
       IF SQLCA.sqlcode THEN
#         CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #FUN-660105
          CALL cl_err3("del","bgv_file",g_bgv01,g_bgv02,SQLCA.sqlcode,"","BODY DELETE:",1) #FUN-660105
       ELSE
         CLEAR FORM
         #MOD-5A0004 add
         DROP TABLE x
#        EXECUTE i170_pre_x                  #No.TQC-720019
         PREPARE i170_pre_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i170_pre_x2                 #No.TQC-720019
         #MOD-5A0004 end
         CALL g_bgv.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         OPEN i170_count                                            
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i170_bcs
            CLOSE i170_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--

         FETCH i170_count INTO g_row_count                          
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i170_bcs
            CLOSE i170_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt                        
         OPEN i170_bcs                                               
         IF g_curs_index = g_row_count + 1 THEN                     
            LET g_jump = g_row_count                                
            CALL i170_fetch('L')                                    
         ELSE                                                       
            LET g_jump = g_curs_index                               
            LET mi_no_ask = TRUE         #No.FUN-6A0057 g_no_ask                            
            CALL i170_fetch('/')                                    
         END IF                 
 
      END IF
      LET g_msg=TIME
     #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
            #VALUES ('abgi170',g_user,g_today,g_msg,g_bgv01,'delete') #FUN-980001 mark
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
             VALUES ('abgi170',g_user,g_today,g_msg,g_bgv01,'delete',g_plant,g_legal) #FUN-980001 add
   END IF
   COMMIT WORK
END FUNCTION
 
 
#單身
FUNCTION i170_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
      l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-680061 SMALLINT
      l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-680061 VARCHAR(01)
      p_cmd           LIKE type_file.chr1,    #處理狀態    #No.FUN-680061 VARCHAR(01)
      l_allow_insert  LIKE type_file.chr1,    #可新增否    #No.FUN-680061 VARCHAR(01)
      l_allow_delete  LIKE type_file.chr1     #可更改否 (含取消) #No.FUN-680061 VARCHAR(01)
 
    LET g_action_choice = ""        
 
   CALL cl_opmsg('b')
 
    LET g_forupd_sql =       
           "SELECT bgv05,'',bgv11,bgv06,bgv10 FROM bgv_file ",
           " WHERE bgv00 = '2' AND bgv01 = ? AND bgv02 = ? AND bgv03 = ? ",
           "  AND bgv04 = ? AND bgv05 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i170_b_cl CURSOR FROM g_forupd_sql    
 
 
    LET l_allow_insert = cl_detail_input_auth("insert")                         
    LET l_allow_delete = cl_detail_input_auth("delete")                         
                                                                                
    INPUT ARRAY g_bgv WITHOUT DEFAULTS FROM s_bgv.*                             
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,                
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,        
                    APPEND ROW=l_allow_insert)                                  
                                                                                
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
               LET p_cmd = 'u'
               LET g_bgv_t.* = g_bgv[l_ac].*  #BACKUP
               OPEN i170_b_cl USING g_bgv01,g_bgv02,g_bgv03,g_bgv04,
                                    g_bgv_t.bgv05
               IF STATUS THEN                                                   
                  CALL cl_err("OPEN i170_b_cl:", STATUS, 1)                      
                  LET l_lock_sw = "Y"                                           
               ELSE               
 
                  FETCH i170_b_cl INTO g_bgv[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_bgv01_t,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     LET g_bgv_t.* = g_bgv[l_ac].*
                  END IF
               END IF
            CALL i170_bgv05('d')
            CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_bgv[l_ac].* TO NULL
         LET g_bgv_t.* = g_bgv[l_ac].*               #新輸入資料
         LET g_bgv[l_ac].bgv10 = 0
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD bgv05
 
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               CANCEL INSERT                                                    
            END IF                                                              
               #MOD-790002.................begin
               INSERT INTO bgv_file(bgv00,bgv01,bgv02,bgv03,bgv04,
                                    bgv05,bgv06,     
                                    bgv07,bgv10,
                                    bgv11,
                                    bgv08,bgvoriu,bgvorig)   #FUN-980001 add bgv08
                             VALUES('2',g_bgv01,g_bgv02,g_bgv03,g_bgv04,
                                    g_bgv[l_ac].bgv05,g_bgv[l_ac].bgv06,
                                    ' ',g_bgv[l_ac].bgv10,
                                    g_bgv[l_ac].bgv11,
                                    0, g_user, g_grup)   #FUN-980001 add bgv08=0      #No.FUN-980030 10/01/04  insert columns oriu, orig
               #MOD-790002.................end
                  IF SQLCA.sqlcode THEN                                         
#                    CALL cl_err(g_bgv[l_ac].bgv05,SQLCA.sqlcode,0) #FUN-660105
                     CALL cl_err3("ins","bgv_file",g_bgv01,g_bgv[l_ac].bgv05,SQLCA.sqlcode,"","",1) #FUN-660105            
                     CANCEL INSERT
                  ELSE                                                          
                     CALL i170_sum()                                            
                     MESSAGE 'INSERT O.K'                                       
                     COMMIT WORK       
                  LET g_rec_b=g_rec_b+1                                            
                  END IF                
 
 
      AFTER FIELD bgv05                    #費用項目
         IF NOT cl_null(g_bgv[l_ac].bgv05) THEN
            CALL i170_bgv05('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD bgv05
            END IF
         END IF
 
      AFTER FIELD bgv06
         IF NOT cl_null(g_bgv[l_ac].bgv06) THEN
            IF g_bgv[l_ac].bgv06 NOT MATCHES '[12]' THEN
               NEXT FIELD bgv06
            END IF
          IF g_bgv_t.bgv06 IS  NULL OR g_bgv[l_ac].bgv06 ! = g_bgv_t.bgv06 THEN  
              SELECT COUNT(*) INTO g_cnt FROM bgv_file
                WHERE bgv01 = g_bgv01
	        AND bgv00 = '2'
                AND bgv02 = g_bgv02
                AND bgv03 = g_bgv03
                AND bgv04 = g_bgv04
                AND bgv05 = g_bgv[l_ac].bgv05
                AND bgv06 = g_bgv[l_ac].bgv06
              IF g_cnt > 0 THEN
              CALL cl_err('','abg-003',0)
              NEXT FIELD bgv06
              END IF 
          END IF    
       END  IF   
 
      AFTER FIELD bgv10
         IF g_bgv[l_ac].bgv10 < 0 THEN
            NEXT FIELD bgv10
         END IF 
 
      BEFORE DELETE                            #是否取消單身
         IF g_bgv_t.bgv05 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN                                         
               CALL cl_err("", -263, 1)                                     
               CANCEL DELETE                                                
            END IF         
            DELETE FROM bgv_file
                   WHERE bgv00 = '2'
                     AND bgv01 = g_bgv01 
                     AND bgv02 = g_bgv02 
                     AND bgv03 = g_bgv03 
                     AND bgv04 = g_bgv04 
                     AND bgv05 = g_bgv[l_ac].bgv05
                  #  AND bgv06 = g_bgv[l_ac].bgv06 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bgv_t.bgv05,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("del","bgv_file",g_bgv01,g_bgv_t.bgv05,SQLCA.sqlcode,"","",1) #FUN-660105
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            CALL i170_sum()
            LET g_rec_b=g_rec_b-1        
            COMMIT WORK 
        END IF
 
        ON ROW CHANGE                                                           
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               LET g_bgv[l_ac].* = g_bgv_t.*                                    
               CLOSE i170_b_cl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            IF l_lock_sw = 'Y' THEN                                             
               CALL cl_err(g_bgv[l_ac].bgv05,-263,1)                            
               LET g_bgv[l_ac].* = g_bgv_t.*                                    
            ELSE        
               UPDATE bgv_file SET bgv05 = g_bgv[l_ac].bgv05,                
                                   bgv06 = g_bgv[l_ac].bgv06,                
                                   bgv11 = g_bgv[l_ac].bgv11,                
                                   bgv10 = g_bgv[l_ac].bgv10                                          
                        WHERE CURRENT OF i170_b_cl  #要查一下
           {       WHERE bgv00 = '2'                                            
                     AND bgv01 = g_bgv01                                        
                     AND bgv02 = g_bgv02                                        
                     AND bgv03 = g_bgv03                                        
                     AND bgv04 = g_bgv04                                        
                     AND bgv05 = g_bgv[l_ac].bgv05   }
               IF SQLCA.sqlcode THEN                                         
#                 CALL cl_err(g_bgv[l_ac].bgv05,SQLCA.sqlcode,0) #FUN-660105
                  CALL cl_err3("upd","bgv_file",g_bgv[l_ac].bgv05,g_bgv[l_ac].bgv06,SQLCA.sqlcode,"","",1) #FUN-660105            
                  LET g_bgv[l_ac].* = g_bgv_t.*                              
               ELSE                                                          
                  CALL i170_sum()                                            
                  MESSAGE 'UPDATE O.K'                                       
                  COMMIT WORK 
               END IF
            END IF     
 
 
        AFTER ROW                                                               
            LET l_ac = ARR_CURR()                                               
           #LET l_ac_t = l_ac     #FUN-D30032 mark                                               
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN                                              
                  LET g_bgv[l_ac].* = g_bgv_t.*                                 
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgv.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF                                                           
               CLOSE i170_b_cl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                
            LET l_ac_t = l_ac     #FUN-D30032 add                              
            CLOSE i170_b_cl                                                      
            COMMIT WORK          
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bgv05) #幣別                                         
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_bgs"                                 
                   LET g_qryparam.default1 = g_bgv[l_ac].bgv05                  
                   CALL cl_create_qry() RETURNING g_bgv[l_ac].bgv05             
#                   CALL FGL_DIALOG_SETBUFFER( g_bgv[l_ac].bgv05 )               
                   NEXT FIELD bgv05            
           END CASE
      
      ON ACTION CONTROLN
         CALL i170_b_askkey()
         EXIT INPUT
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(bgv05) AND l_ac > 1 THEN
            LET g_bgv[l_ac].* = g_bgv[l_ac-1].*
            LET g_bgv[l_ac].bgv05 = NULL
            NEXT FIELD bgv05
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
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
      END INPUT
 
END FUNCTION
 
FUNCTION i170_b_askkey()
   DEFINE
      l_wc   LIKE type_file.chr1000#No.FUN-680061 VARCHAR(200)
 
   CONSTRUCT l_wc ON bgv05,bgv06,bgv11,bgv10          #螢幕上取條件
             FROM s_bgv[1].bgv05,s_bgv[1].bgv06,s_bgv[1].bgv11,s_bgv[1].bgv10
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE CONSTRUCT                                                    
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                                                                                
    END CONSTRUCT                
 
   IF INT_FLAG THEN RETURN END IF
   CALL i170_b_fill(l_wc)
END FUNCTION
 
FUNCTION i170_b_fill(p_wc)          #BODY FILL UP
   DEFINE
      p_wc   LIKE type_file.chr1000 #No.FUN-680061 VARCHAR(200)
 
   LET g_sql =
       "SELECT bgv05,bgs02,bgv11,bgv06,bgv10 ",
       "  FROM bgv_file, OUTER bgs_file ",
       " WHERE bgv01 = '",g_bgv01 CLIPPED,"'",
       "   AND bgv02 = ",g_bgv02," ",
       "   AND bgv03 = ",g_bgv03," ",
       "   AND bgv04 = '",g_bgv04 CLIPPED,"'",
       "   AND bgv_file.bgv05 = bgs_file.bgs01",
       "   AND bgv00 = '2'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY bgv05"
   PREPARE i170_prepare2 FROM g_sql       #預備一下
   DECLARE bgv_cs CURSOR FOR i170_prepare2
 
    CALL g_bgv.clear()                                                          
    LET g_cnt = 1       
 
   FOREACH bgv_cs INTO g_bgv[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN                                               
           CALL cl_err( '', 9035, 0 )                                           
           EXIT FOREACH                                                         
        END IF          
 
   END FOREACH
    CALL g_bgv.deleteElement(g_cnt)     
   LET g_rec_b = g_cnt-1
     
END FUNCTION
 
FUNCTION i170_bp(p_ud)
   DEFINE
      p_ud   LIKE type_file.chr1   #No.FUN-680061 VARCHAR(01)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_bgv TO s_bgv.* ATTRIBUTE(COUNT=g_rec_b)                      
                                                                                
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )               
                                                                                
      BEFORE ROW                                                                
         LET l_ac = ARR_CURR()        
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         CALL i170_fetch('F')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF       
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                            
      ON ACTION previous                                                        
         CALL i170_fetch('P')              
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF                                       
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                                                                
      ON ACTION jump                                                            
         CALL i170_fetch('/')                                                  
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF   
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                                                                
      ON ACTION next                                                            
         CALL i170_fetch('N')                                                  
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF   
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                                                                
      ON ACTION last                                                            
         CALL i170_fetch('L')                                                  
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF   
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
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
 
      ON ACTION close
      LET g_action_choice="exit"                                                
      EXIT DISPLAY                                                              
                                                                                
      ON IDLE g_idle_seconds                                                    
         CALL cl_on_idle()                                                      
         CONTINUE DISPLAY                                                       
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
                                                                                
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0003  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
   END DISPLAY                                                                  
   CALL cl_set_act_visible("accept,cancel", TRUE)                               
END FUNCTION                  
 
 
 
FUNCTION i170_sum()
   SELECT SUM(bgv10) INTO g_tot FROM bgv_file
    WHERE bgv01 = g_bgv01
      AND bgv02 = g_bgv02
      AND bgv03 = g_bgv03
      AND bgv04 = g_bgv04
   IF cl_null(g_tot) THEN LET g_tot = 0 END IF
   DISPLAY g_tot TO tot
END FUNCTION
 
FUNCTION i170_out()
   DEFINE
      l_i    LIKE type_file.num5,     #No.FUN-680061 SMALLINT
      l_name LIKE type_file.chr20,    # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
      l_za05 LIKE type_file.chr1000,  #NO.FUN-680061 VARCHAR(40)  
      sr RECORD
         bgv01      LIKE bgv_file.bgv01,
         bgv02      LIKE bgv_file.bgv02,
         bgv03      LIKE bgv_file.bgv03,
         bgv04      LIKE bgv_file.bgv04,
         bgv05      LIKE bgv_file.bgv05,
         bgv06      LIKE bgv_file.bgv06,
         bgv10      LIKE bgv_file.bgv10,
         bgv11      LIKE bgv_file.bgv11,
         tot        LIKE bgv_file.bgv10,
         gem02      LIKE gem_file.gem02,
         bgs02      LIKE bgs_file.bgs02
      END RECORD
 
   IF cl_null(g_bgv02) THEN RETURN END IF
   CALL cl_wait()
   CALL cl_outnam('abgi170') RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
LET g_sql="SELECT bgv01,bgv02,bgv03,bgv04,bgv05,bgv06, ",
             " bgv10,bgv11,'','',''",
             "  FROM bgv_file ",   # 組合出 SQL 指令
             " WHERE ",g_wc CLIPPED ,
             " AND bgv00 ='2' ",
             " ORDER BY bgv01,bgv02,bgv03,bgv04,bgv05,bgv06 "
   PREPARE i170_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i170_co CURSOR FOR i170_p1
 
   START REPORT i170_rep TO l_name
 
   FOREACH i170_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = sr.bgv04
      SELECT bgs02 INTO sr.bgs02 FROM bgs_file WHERE bgs01 = sr.bgv05
 
      OUTPUT TO REPORT i170_rep(sr.*)
   END FOREACH
 
   FINISH REPORT i170_rep
 
   CLOSE i170_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i170_rep(sr)
   DEFINE
      l_trailer_sw  LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
      l_azi03       LIKe azi_file.azi03,   #NO.FUN-680061 SMALLINT
      sr RECORD
         bgv01      LIKE bgv_file.bgv01,
         bgv02      LIKE bgv_file.bgv02,
         bgv03      LIKE bgv_file.bgv03,
         bgv04      LIKE bgv_file.bgv04,
         bgv05      LIKE bgv_file.bgv05,
         bgv06      LIKE bgv_file.bgv06,
         bgv10      LIKE bgv_file.bgv10,
         bgv11      LIKE bgv_file.bgv11,
         tot        LIKE bgv_file.bgv10,
         gem02      LIKE gem_file.gem02,
         bgs02      LIKE bgs_file.bgs02
      END RECORD
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.bgv01,sr.bgv02,sr.bgv03,sr.bgv04,sr.bgv05,
            sr.bgv06
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED, pageno_total
         DISPLAY "g_len=",g_len
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
               g_x[38],g_x[39],g_x[40]
         PRINT g_dash1
         LET l_trailer_sw = 'y'
   
      BEFORE GROUP OF sr.bgv01
         PRINT COLUMN g_c[31],sr.bgv01 CLIPPED;
 
      BEFORE GROUP OF sr.bgv02
         PRINT COLUMN g_c[32],sr.bgv02;
 
      BEFORE GROUP OF sr.bgv03
         PRINT COLUMN g_c[33],sr.bgv03;
 
      BEFORE GROUP OF sr.bgv04
         PRINT COLUMN g_c[34],sr.bgv04 CLIPPED,
               COLUMN g_c[35],sr.gem02 CLIPPED;
 
 #   BEFORE GROUP OF sr.bgv05
 #       PRINT COLUMN 57,sr.bgv05 CLIPPED,
 #             COLUMN 67,sr.bgs02 CLIPPED;
 
 #     BEFORE GROUP OF sr.bgv06
 #        PRINT COLUMN 92,sr.bgv06 CLIPPED;
 
      ON EVERY ROW
 
         PRINT COLUMN g_c[36],sr.bgv05 CLIPPED,
               COLUMN g_c[37],sr.bgs02 CLIPPED,
               COLUMN g_c[38],sr.bgv11 CLIPPED,
               COLUMN g_c[39],sr.bgv06 CLIPPED,
               COLUMN g_c[40],cl_numfor(sr.bgv10,40,g_azi04) 
 
      AFTER GROUP OF sr.bgv04
         PRINT COLUMN g_c[40],g_dash2[1,g_w[40]]
         PRINT COLUMN g_c[39],g_x[9] CLIPPED,
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr.bgv10),40,g_azi04)
         SKIP 1 LINE
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN
            PRINT g_dash[1,g_len]
         END IF
         PRINT g_dash[1,g_len]
         LET l_trailer_sw = 'n'
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
