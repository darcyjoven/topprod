# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi160.4gl
# Descriptions...: 部門用人費項目維護作業
# Date & Author..: 02/10/02 By nicola 
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/17 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530265 05/03/28 By ice 單身資料打完查詢不到
# Modify.........: NO.MOD-580078 05/08/09 BY yiting key 可更改
# Modify.........: NO.MOD-590329 05/10/03 BY yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/14 By jamie i160()_q 將 key清空 
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 mi_no_ask 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.FUN-7C0023 07/12/07 By Nicole 報表列印改由p_query產出
# Modify.........: No.FUN-820002 07/12/17 By lala   報表轉為使用p_query
# Modify.........: No.MOD-840178 08/05/20 By rainy  按上下筆時，單身資料沒變
# Modify.........: No.TQC-860021 08/06/10 By Sarah PROMPT段漏了ON IDLE控制
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990195 09/09/22 By mike 畫面增加USER,GRUP,MODU,DATE四個欄位      
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
   g_bgv05         LIKE bgv_file.bgv05,   #費用項目
   g_bgv05_t       LIKE bgv_file.bgv05,   #費用項目(舊值)
   g_bgv06         LIKE bgv_file.bgv06,   #直間接
   g_bgv06_t       LIKE bgv_file.bgv06,   #直間接(舊值)
   g_bgv07         LIKE bgv_file.bgv07,   #職等                                                                                     
   g_bgv07_t       LIKE bgv_file.bgv07,   #職等(舊值)                                                                               
   g_bgv08         LIKE bgv_file.bgv08,   #職級                                                                                     
   g_bgv08_t       LIKE bgv_file.bgv08,   #職級(舊值) 
   g_tot           LIKE bgv_file.bgv10,   #總金額
   g_tot_t         LIKE bgv_file.bgv10,   #總金額(舊值)
   g_bgv           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
      bgv07        LIKE bgv_file.bgv07,   #職等
      bgv08        LIKE bgv_file.bgv08,   #職級
      bgv09        LIKE bgv_file.bgv09,   #職稱說明
      bgv10        LIKE bgv_file.bgv10,   #平均金額
      bgvuser      LIKE bgv_file.bgvuser, #MOD-990195                                                                               
      bgvgrup      LIKE bgv_file.bgvgrup, #MOD-990195                                                                               
      bgvmodu      LIKE bgv_file.bgvmodu, #MOD-990195                                                                               
      bgvdate      LIKE bgv_file.bgvdate  #MOD-990195       
                   END RECORD,
   g_bgv_t         RECORD                 #程式變數(舊值)
      bgv07        LIKE bgv_file.bgv07,   #職等
      bgv08        LIKE bgv_file.bgv08,   #職級
      bgv09        LIKE bgv_file.bgv09,   #職稱說明
      bgv10        LIKE bgv_file.bgv10,   #平均金額
      bgvuser      LIKE bgv_file.bgvuser, #MOD-990195                                                                               
      bgvgrup      LIKE bgv_file.bgvgrup, #MOD-990195                                                                               
      bgvmodu      LIKE bgv_file.bgvmodu, #MOD-990195                                                                               
      bgvdate      LIKE bgv_file.bgvdate  #MOD-990195       
                   END RECORD,
   g_wc,g_sql,g_wc2 LIKE type_file.chr1000,#No.FUN-680061 VARCHAR(1300)
   g_rec_b         LIKE type_file.num5,   #單身筆數  #No.FUN-680061 SMALLINT
   l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
DEFINE p_row,p_col LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE g_forupd_sql STRING                #SELECT ... FOR UPDATE SQL 
DEFINE g_sql_tmp    STRING                #No.TQC-720019
DEFINE g_cnt       LIKE type_file.num10   #No.FUN-680061 INTEGER
DEFINE g_i         LIKE type_file.num5    #count/index for any purpose  #No.FUN-680061 SMALLINT
DEFINE g_msg       LIKE ze_file.ze03      #No.FUN-680061 VARCHAR(72)
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE g_row_count  LIKE type_file.num10  #No.FUN-680061 INTEGER
DEFINE g_curs_index LIKE type_file.num10  #No.FUN-680061 INTEGER
DEFINE g_jump       LIKE type_file.num10  #查詢指定的筆數 #No.FUN-680061 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5   #是否開啟指定筆視窗 #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask 
 
#主程式開始
MAIN
#  DEFINE     l_time      LIKE type_file.chr8            #No.FUN-6A0056
  
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
     CALL  cl_used(g_prog,g_time,1)        #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time     #No.FUN-6A0056
         LET g_bgv01 = NULL
         LET g_bgv02 = NULL
         LET g_bgv03 = NULL
         LET g_bgv04 = NULL
         LET g_bgv05 = NULL
         LET g_bgv06 = NULL
    LET p_row = 2 LET p_col = 30
 
 OPEN WINDOW i160_w AT p_row,p_col
       WITH FORM "abg/42f/abgi160" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init() 
 
    CALL i160_menu() 
 
    CLOSE WINDOW i160_w                      #結束畫面
      CALL  cl_used(g_prog,g_time,2)  #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i160_cs()
    CLEAR FORM                               #清除畫面
    CALL g_bgv.clear() 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_bgv01 TO NULL    #No.FUN-750051
   INITIALIZE g_bgv02 TO NULL    #No.FUN-750051
   INITIALIZE g_bgv03 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bgv01,bgv02,bgv03,bgv04,bgv05,bgv06,
                      bgv07,bgv08,bgv09,bgv10,
                      bgvuser,bgvgrup,bgvmodu,bgvdate #MOD-990195          
         FROM bgv01,bgv02,bgv03,bgv04,bgv05,bgv06,
              s_bgv[1].bgv07,s_bgv[1].bgv08,s_bgv[1].bgv09,s_bgv[1].bgv10,
              s_bgv[1].bgvuser,s_bgv[1].bgvgrup,s_bgv[1].bgvmodu,s_bgv[1].bgvdate #MOD-990195 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP                       #沿用所有欄位
         CASE 
            WHEN INFIELD(bgv04)
               CALL cl_init_qry_var()            
               LET g_qryparam.state = "c" 
               LET g_qryparam.form = "q_gem"             
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bgv04
            WHEN INFIELD(bgv05)
               CALL cl_init_qry_var()                                     
               LET g_qryparam.state = "c" 
               LET g_qryparam.form = 'q_bgs'                                
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bgv05
            WHEN INFIELD(bgv07)
               CALL cl_init_qry_var()        
               LET g_qryparam.state = "c" 
               LET g_qryparam.form ="q_bgd"         
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bgv07
            WHEN INFIELD(bgv08)
               CALL cl_init_qry_var()        
               LET g_qryparam.state = "c" 
               LET g_qryparam.form ="q_bgd"         
               LET g_qryparam.multiret_index = 2
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bgv08
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
   #MOD-990195   ---start                                                                                                           
   #資料權限的檢查                                                                                                                  
    IF g_priv2='4' THEN #只能使用自己的資料                                                                                          
       LET g_wc = g_wc clipped," AND bgvuser = '",g_user,"'"                                                                         
    END IF                                                                                                                           
                                                                                                                                    
    IF g_priv3='4' THEN #只能使用相同群的資料                                                                                        
       LET g_wc = g_wc clipped," AND bgvgrup MATCHES '",g_grup CLIPPED,"*'"                                                          
    END IF                                                                                                                           
                                                                                                                                    
    IF g_priv3 MATCHES "[5678]" THEN                                                                                                 
       LET g_wc = g_wc clipped," AND bgvgrup IN ",cl_chk_tgrup_list()                                                                
    END IF                                                                                                                           
   #MOD-990195   ---end                
    LET g_sql = "SELECT UNIQUE bgv01,bgv02,bgv03,bgv04,bgv05,bgv06 ",
                "  FROM bgv_file ",
                " WHERE bgv00='1' AND ", g_wc CLIPPED,
                " ORDER BY bgv01"
    PREPARE i160_prepare FROM g_sql          #預備一下
    DECLARE i160_bcs                         #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i160_prepare
      
# LET g_sql = "SELECT UNIQUE bgv01, bgv02, bgv03 , bgv04 ,",      #No.TQC-720019
  LET g_sql_tmp = "SELECT UNIQUE bgv01, bgv02, bgv03 , bgv04 ,",  #No.TQC-720019
              "              bgv05, bgv06",
              "  FROM bgv_file ",
              " WHERE ", g_wc CLIPPED,
              "   AND bgv00='1'      ",
              " INTO TEMP x "
  DROP TABLE x
# PREPARE i160_pre_x FROM g_sql      #No.TQC-720019
  PREPARE i160_pre_x FROM g_sql_tmp  #No.TQC-720019
  EXECUTE i160_pre_x
 
  LET g_sql = "SELECT COUNT(*) FROM x"
  PREPARE i160_precnt FROM g_sql
  DECLARE i160_count CURSOR FOR i160_precnt
END FUNCTION
 
FUNCTION i160_menu()
   DEFINE l_cmd LIKE type_file.chr1000   #FUN-7C0023
 
   WHILE TRUE
      CALL i160_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i160_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i160_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i160_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i160_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i160_out() 
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
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i160_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_bgv.clear()
   LET g_bgv01 = NULL
   LET g_bgv02 = NULL
   LET g_bgv03 = NULL
   LET g_bgv04 = NULL
   LET g_bgv05 = NULL
   LET g_bgv06 = NULL
   LET g_bgv01_t = NULL
   LET g_bgv02_t = NULL
   LET g_bgv03_t = NULL
   LET g_bgv04_t = NULL
   LET g_bgv05_t = NULL
   LET g_bgv06_t = NULL
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i160_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_bgv01 = NULL
         LET g_bgv02 = NULL
         LET g_bgv03 = NULL
         LET g_bgv04 = NULL
         LET g_bgv05 = NULL
         LET g_bgv06 = NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF cl_null(g_bgv02)  OR   
         cl_null(g_bgv03)  OR 
         cl_null(g_bgv04)  OR  
         cl_null(g_bgv05)  OR 
         cl_null(g_bgv06)  THEN 
         CONTINUE WHILE 
      END IF
      CALL g_bgv.clear() 
      LET g_rec_b = 0                    #No.FUN-680064
      CALL i160_b_fill('1=1')            #單身
      CALL i160_b()                      #輸入單身
      LET g_bgv01_t = g_bgv01
      LET g_bgv02_t = g_bgv02
      LET g_bgv03_t = g_bgv03
      LET g_bgv04_t = g_bgv04
      LET g_bgv05_t = g_bgv05
      LET g_bgv06_t = g_bgv06 
      LET g_wc="     bgv01='",g_bgv01,"' ",
               " AND bgv02='",g_bgv02,"' "
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION i160_i(p_cmd)
   DEFINE
      p_cmd   LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680061 VARCHAR(01)
      l_n     LIKE type_file.num5     #No.FUN-680061 SMALLINT
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INPUT g_bgv01,g_bgv02,g_bgv03,g_bgv04,g_bgv05,g_bgv06 WITHOUT DEFAULTS
         FROM bgv01,bgv02,bgv03,bgv04,bgv05,bgv06 HELP 1
 
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
            CALL i160_bgv04('a',g_bgv04)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD bgv04
            END IF
         END IF
 
      AFTER FIELD bgv05
         IF NOT cl_null(g_bgv05) THEN
            CALL i160_bgv05('a',g_bgv05)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD bgv05
            END IF
         END IF
 
      AFTER FIELD bgv06
         IF NOT cl_null(g_bgv06) THEN
            IF g_bgv06 NOT MATCHES '[12]' THEN
               NEXT FIELD bgv06
            END IF
         END IF
         SELECT COUNT(*) INTO g_cnt FROM bgv_file
          WHERE bgv00='1' AND bgv01 = g_bgv01
            AND bgv02 = g_bgv02
            AND bgv03 = g_bgv03
            AND bgv04 = g_bgv04
            AND bgv05 = g_bgv05
         IF g_cnt > 0 THEN
            CALL cl_err('','abg-003',0)
            NEXT FIELD bgv06
         END IF 
 
       ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bgv04)
            #  CALL q_gem(05,11,g_bgv04) RETURNING g_bgv04
               CALL cl_init_qry_var()            
               LET g_qryparam.form = "q_gem"             
               LET g_qryparam.default1 = g_bgv04
               CALL cl_create_qry() RETURNING g_bgv04
               DISPLAY g_bgv04 TO bgv04
               NEXT FIELD bgv04
            WHEN INFIELD(bgv05)
            #  CALL q_bgs(05,11,g_bgv05) RETURNING g_bgv05
               CALL cl_init_qry_var()                                     
               LET g_qryparam.form = 'q_bgs'                                
               LET g_qryparam.default1 = g_bgv05
               CALL cl_create_qry() RETURNING g_bgv05
               DISPLAY g_bgv05 TO bgv05
               NEXT FIELD bgv05
         END CASE
 
       ON ACTION CONTROLF                #欄位說明
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
 
FUNCTION i160_bgv04(p_cmd,p_key)            #部門編號
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
 
FUNCTION i160_bgv05(p_cmd,p_key)
DEFINE
    p_cmd        LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
    p_key        LIKE bgs_file.bgs01,
    l_bgs02      LIKE bgs_file.bgs02,
    l_bgsacti    LIKE bgs_file.bgsacti
 
    LET g_errno = ' '
    SELECT bgs02,bgsacti INTO l_bgs02,l_bgsacti
      FROM bgs_file
     WHERE bgs01 = g_bgv05
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-004'
                                   LET l_bgs02   = NULL
                                   LET l_bgsacti = NULL
         WHEN l_bgsacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_bgs02 TO bgs02
    END IF
END FUNCTION
 
 
#Query 查詢
FUNCTION i160_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
       INITIALIZE g_bgv01  TO NULL       #No.FUN-6A0003
       INITIALIZE g_bgv02  TO NULL       #No.FUN-6A0003
       INITIALIZE g_bgv03  TO NULL       #No.FUN-6A0003
       INITIALIZE g_bgv04  TO NULL       #No.FUN-6A0003 
       INITIALIZE g_bgv05  TO NULL       #No.FUN-6A0003
       INITIALIZE g_bgv06  TO NULL       #No.FUN-6A000:
 
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_bgv.clear() 
   CALL i160_cs()                      #取得查詢條件
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_bgv01  TO NULL
      INITIALIZE g_bgv02  TO NULL
      INITIALIZE g_bgv03  TO NULL
      INITIALIZE g_bgv04  TO NULL
      INITIALIZE g_bgv05  TO NULL
      INITIALIZE g_bgv06  TO NULL
      RETURN
   END IF
   OPEN i160_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bgv01  TO NULL
      INITIALIZE g_bgv02  TO NULL
      INITIALIZE g_bgv03  TO NULL
      INITIALIZE g_bgv04  TO NULL
      INITIALIZE g_bgv05  TO NULL
      INITIALIZE g_bgv06  TO NULL
   ELSE
      OPEN i160_count
      FETCH i160_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i160_fetch('F')             #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i160_fetch(p_flag)
   DEFINE
      p_flag   LIKE type_file.chr1     #處理方式 #No.FUN-680061 VARCHAR(01)
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i160_bcs INTO g_bgv01,g_bgv02,g_bgv03,
                                            g_bgv04,g_bgv05,g_bgv06
      WHEN 'P' FETCH PREVIOUS i160_bcs INTO g_bgv01,g_bgv02,g_bgv03,
                                            g_bgv04,g_bgv05,g_bgv06
      WHEN 'F' FETCH FIRST    i160_bcs INTO g_bgv01,g_bgv02,g_bgv03,
                                            g_bgv04,g_bgv05,g_bgv06
      WHEN 'L' FETCH LAST     i160_bcs INTO g_bgv01,g_bgv02,g_bgv03,
                                            g_bgv04,g_bgv05,g_bgv06
      WHEN '/' 
      IF (NOT mi_no_ask) THEN      #No.FUN-6A0057 g_no_ask 
         CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
         LET INT_FLAG = 0  ######add for prompt bug
         PROMPT g_msg CLIPPED,': ' FOR g_jump
            ON IDLE g_idle_seconds  #TQC-860021
               CALL cl_on_idle()    #TQC-860021
 
            ON ACTION about         #TQC-860021
               CALL cl_about()      #TQC-860021
 
            ON ACTION help          #TQC-860021
               CALL cl_show_help()  #TQC-860021
 
            ON ACTION controlg      #TQC-860021
               CALL cl_cmdask()     #TQC-860021
         END PROMPT                 #TQC-860021
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
      END IF
         FETCH ABSOLUTE g_jump i160_bcs INTO g_bgv01,g_bgv02,g_bgv03,
                                             g_bgv04,g_bgv05,g_bgv06
         LET mi_no_ask = FALSE     #No.FUN-6A0057 g_no_ask 
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_bgv01,SQLCA.sqlcode,0)
      INITIALIZE g_bgv01 TO NULL  #TQC-6B0105
      INITIALIZE g_bgv02 TO NULL  #TQC-6B0105
      INITIALIZE g_bgv03 TO NULL  #TQC-6B0105
      INITIALIZE g_bgv04 TO NULL  #TQC-6B0105
      INITIALIZE g_bgv05 TO NULL  #TQC-6B0105
      INITIALIZE g_bgv06 TO NULL  #TQC-6B0105
   ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       CALL i160_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i160_show()
    
   DISPLAY g_bgv01 TO bgv01                 #單頭
   DISPLAY g_bgv02 TO bgv02                 #單頭
   DISPLAY g_bgv03 TO bgv03                 #單頭
   DISPLAY g_bgv04 TO bgv04                 #單頭
   DISPLAY g_bgv05 TO bgv05                 #單頭
   DISPLAY g_bgv06 TO bgv06                 #單頭
   CALL i160_bgv04('d',g_bgv04)
   CALL i160_bgv05('d',g_bgv05)
   CALL i160_b_fill(g_wc)                   #單身
   CALL i160_sum()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i160_r()
 
   IF s_shut(0) THEN RETURN END IF
#  IF cl_null(g_bgv02) THEN RETURN END IF     #No.FUN-6A0003
   IF g_bgv02 IS NULL THEN           #No.FUN-6A0003
      CALL cl_err("",-400,0) 
      RETURN 
   END IF   
   BEGIN WORK
   IF cl_delh(15,16) THEN
      DELETE FROM bgv_file 
      WHERE bgv00='1' AND bgv01 = g_bgv01
        AND bgv02 = g_bgv02
        AND bgv03 = g_bgv03
        AND bgv04 = g_bgv04
        AND bgv05 = g_bgv05
        AND bgv06 = g_bgv06
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #FUN-660105
         CALL cl_err3("del","bgv_file",g_bgv01,g_bgv02,SQLCA.sqlcode,"","BODY DELETE:",1) #FUN-660105
      ELSE
         CLEAR FORM
         #MOD-5A0004 add
         DROP TABLE x
#        EXECUTE i160_pre_x                  #No.TQC-720019
         PREPARE i160_pre_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i160_pre_x2                 #No.TQC-720019
         #MOD-5A0004 end
         CALL g_bgv.clear()
         OPEN i160_count                                                           
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i160_bcs
             CLOSE i160_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--

         FETCH i160_count INTO g_row_count              
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i160_bcs
            CLOSE i160_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--                           
         DISPLAY g_row_count TO FORMONLY.cnt                                       
         OPEN i160_bcs                                                              
         IF g_curs_index = g_row_count + 1 THEN                                    
            LET g_jump = g_row_count                                               
            CALL i160_fetch('L')                                                   
         ELSE                                                                      
            LET g_jump = g_curs_index                                              
            LET mi_no_ask = TRUE            #No.FUN-6A0057 g_no_ask                                       
            CALL i160_fetch('/')                                                   
         END IF             
      END IF
      LET g_msg=TIME
     #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
            #VALUES ('abgi160',g_user,g_today,g_msg,g_bgv01,'delete') #FUN-980001 mark
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
             VALUES ('abgi160',g_user,g_today,g_msg,g_bgv01,'delete',g_plant,g_legal) #FUN-980001 add
   END IF
   COMMIT WORK 
END FUNCTION
 
 
#單身
FUNCTION i160_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
      l_n             LIKE type_file.num5,     #檢查重複用 #No.FUN-680061 SMALLINT
      l_lock_sw       LIKE type_file.chr1,     #單身鎖住否 #No.FUN-680061 VARCHAR(01)
      p_cmd           LIKE type_file.chr1,     #處理狀態   #No.FUN-680061 VARCHAR(01)
      l_allow_insert  LIKE type_file.num5,     #可新增否   #No.FUN-680061 SMALLINT
      l_allow_delete  LIKE type_file.num5      #可刪除否   #No.FUN-680061 SMALLINT
    
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_bgv01) AND cl_null(g_bgv02) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =
           "SELECT bgv07,bgv08,bgv09,bgv10,bgvuser,bgvgrup,bgvmodu,bgvdate FROM bgv_file ", #MOD-990195 add user--date  
           "  WHERE bgv00='1' AND bgv01 = ? AND bgv02 = ? ",
           "   AND bgv03 = ? AND bgv04 = ? AND bgv05 = ? ",
           "   AND bgv06 = ? AND bgv07 = ? AND bgv08 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i160_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_bgv WITHOUT DEFAULTS FROM s_bgv.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEn
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
#NO.MOD-590329 MARK------------
 #No.MOD-580078 --start
#            LET g_before_input_done = FALSE
#            CALL i601_set_entry_b(p_cmd)
#            CALL i601_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329 ----------------
            OPEN i160_b_cl USING g_bgv01,g_bgv02,g_bgv03,g_bgv04,g_bgv05,g_bgv06,g_bgv_t.bgv07,g_bgv_t.bgv08
            IF STATUS THEN
               CALL cl_err("OPEN i160_b_cl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_bgv01_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               FETCH i160_b_cl INTO g_bgv[l_ac].* 
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_bgv[l_ac].* TO NULL
         LET g_bgv_t.* = g_bgv[l_ac].*               #新輸入資料
         LET g_bgv[l_ac].bgv10 = 0
#------NO.MOD-590329 MARK--------------
 #No.MOD-580078 --start
#         LET g_before_input_done = FALSE
#         CALL i601_set_entry_b(p_cmd)
#         CALL i601_set_no_entry_b(p_cmd)
#         LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#------NO.MOD-590329 MARK--------------
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD bgv07
 
      AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
 
          #MOD-790002.................begin
          IF cl_null(g_bgv[l_ac].bgv07)  THEN
             LET g_bgv[l_ac].bgv07=' '
          END IF
          #MOD-790002.................end
 
          INSERT INTO bgv_file(bgv00,bgv01,bgv02,bgv03,bgv04,bgv05,
                               bgv06,bgv07,bgv08,bgv09,bgv10,bgvuser,bgvgrup,bgvoriu,bgvorig) #MOD-990195 add user,grup       
                 VALUES('1',g_bgv01,g_bgv02,g_bgv03,g_bgv04,g_bgv05,
                        g_bgv06,g_bgv[l_ac].bgv07,g_bgv[l_ac].bgv08,
                        g_bgv[l_ac].bgv09,g_bgv[l_ac].bgv10,g_user,g_grup, g_user, g_grup) #MOD-990195 add user,grup             #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_bgv[l_ac].bgv07,SQLCA.sqlcode,0) #FUN-660105
             CALL cl_err3("ins","bgv_file",g_bgv01,g_bgv[l_ac].bgv07,SQLCA.sqlcode,"","",1) #FUN-660105
             CANCEL INSERT
          ELSE
             CALL i160_sum()
             MESSAGE 'INSERT O.K'
             COMMIT WORK
             LET g_rec_b = g_rec_b+1
          END IF
 
      AFTER FIELD bgv07                    #職等
         IF NOT cl_null(g_bgv[l_ac].bgv07) THEN
            IF g_bgv_t.bgv07 IS NULL OR g_bgv[l_ac].bgv07 != g_bgv_t.bgv07 THEN
               SELECT COUNT(*) INTO g_cnt
                 FROM bgd_file
                WHERE bgd01 = g_bgv01
                  AND bgd02 = g_bgv[l_ac].bgv07
               IF g_cnt = 0 THEN
                  CALL cl_err('','abg-007',0)
                  NEXT FIELD bgv07
               END IF
            END IF
         END IF
 
      AFTER FIELD bgv08               #職級
         IF NOT cl_null(g_bgv[l_ac].bgv08) THEN
            IF g_bgv_t.bgv07 IS NULL OR g_bgv[l_ac].bgv07 != g_bgv_t.bgv07
               AND g_bgv[l_ac].bgv08 != g_bgv_t.bgv08 THEN
               SELECT COUNT(*) INTO g_cnt
                 FROM bgd_file
                WHERE bgd01 = g_bgv01
                  AND bgd02 = g_bgv[l_ac].bgv07
                  AND bgd03 = g_bgv[l_ac].bgv08
               IF g_cnt = 0 THEN
                  CALL cl_err('','abg-007',0)
                  NEXT FIELD bgv08
               END IF
               SELECT COUNT(*) INTO g_cnt
                 FROM bgv_file
                WHERE bgv00='1' AND bgv01 = g_bgv01
                  AND bgv02 = g_bgv02
                  AND bgv03 = g_bgv03
                  AND bgv04 = g_bgv04
                  AND bgv05 = g_bgv05
                  AND bgv06 = g_bgv06
                  AND bgv07 = g_bgv[l_ac].bgv07
                  AND bgv08 = g_bgv[l_ac].bgv08
               IF g_cnt > 0 THEN
                  CALL cl_err('','abg-003',0)
                  NEXT FIELD bgv08
               END IF
            END IF
         END IF
 
      AFTER FIELD bgv10
         IF g_bgv[l_ac].bgv10 < 0 THEN
            NEXT FIELD bgv10
         END IF 
 
      BEFORE DELETE                            #是否取消單身
         IF g_bgv_t.bgv07 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM bgv_file
                   WHERE bgv00='1' AND bgv01 = g_bgv01 
                     AND bgv02 = g_bgv02 
                     AND bgv03 = g_bgv03 
                     AND bgv04 = g_bgv04 
                     AND bgv05 = g_bgv05 
                     AND bgv06 = g_bgv06 
                     AND bgv07 = g_bgv_t.bgv07
                     AND bgv08 = g_bgv_t.bgv08
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bgv_t.bgv07,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("del","bgv_file",g_bgv01,g_bgv_t.bgv07,SQLCA.sqlcode,"","",1) #FUN-660105
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            CALL i160_sum()
            LET g_rec_b = g_rec_b-1
            COMMIT WORK 
         END IF
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_bgv[l_ac].* = g_bgv_t.*
             CLOSE i160_b_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_bgv[l_ac].bgv07,-263,1)
             LET g_bgv[l_ac].* = g_bgv_t.*
          ELSE
             UPDATE bgv_file SET bgv07 = g_bgv[l_ac].bgv07,
                                 bgv08 = g_bgv[l_ac].bgv08,
                                 bgv09 = g_bgv[l_ac].bgv09,
                                 bgv10 = g_bgv[l_ac].bgv10,
                                 bgvmodu=g_user, #MOD-990195                                                                        
                                 bgvdate=g_today #MOD-990195   
                    WHERE CURRENT OF i160_b_cl  #要查一下
 
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bgv[l_ac].bgv07,SQLCA.sqlcode,0) #FUN-660105
                CALL cl_err3("upd","bgv_file",g_bgv[l_ac].bgv07,g_bgv[l_ac].bgv08,SQLCA.sqlcode,"","",1) #FUN-660105
                LET g_bgv[l_ac].* = g_bgv_t.*
             ELSE
                CALL i160_sum()
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
      AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032 mark
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
             CLOSE i160_b_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac     #FUN-D30032 add 
          CLOSE i160_b_cl
          COMMIT WORK
 
      ON ACTION CONTROLP                       #沿用所有欄位
         CASE 
            WHEN INFIELD(bgv07)
            #  CALL q_bgd(3,10,g_bgv[l_ac].bgv07) 
            #       RETURNING g_bgv[l_ac].bgv07,g_bgv[l_ac].bgv08
               CALL cl_init_qry_var()        
               LET g_qryparam.form ="q_bgd"         
                LET g_qryparam.where = "bgd01 = '",g_bgv01,"' "      #No.MOD-530265
               CALL cl_create_qry() RETURNING g_bgv[l_ac].bgv07,g_bgv[l_ac].bgv08  
               NEXT FIELD bgv07
            WHEN INFIELD(bgv08)
            #  CALL q_bgd(3,10,g_bgv[l_ac].bgv07) 
            #       RETURNING g_bgv[l_ac].bgv07,g_bgv[l_ac].bgv08
               CALL cl_init_qry_var()        
               LET g_qryparam.form ="q_bgd"         
               CALL cl_create_qry() RETURNING g_bgv[l_ac].bgv07,g_bgv[l_ac].bgv08  
               NEXT FIELD bgv08
         END CASE
 
     ON ACTION CONTROLN                       #沿用所有欄位
        CALL i160_b_askkey()
        EXIT INPUT
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(bgv05) AND l_ac > 1 THEN
            LET g_bgv[l_ac].* = g_bgv[l_ac-1].*
            LET g_bgv[l_ac].bgv07 = NULL
            NEXT FIELD bgv07
         END IF
 
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()                                            
                                                                                
        ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                       #沿用所有欄位
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
 
   CLOSE i160_b_cl
   COMMIT WORK 
END FUNCTION
 
FUNCTION i160_b_askkey()
   DEFINE
      l_wc   LIKE type_file.chr1000#No.FUN-680061 VARCHAR(200)
 
   CONSTRUCT l_wc ON bgv07,bgv08,bgv09,bgv10,          #螢幕上取條件
                     bgvuser,bgvgrup,bgvmodu,bgvdate  #MOD-990195      
             FROM s_bgv[1].bgv07,s_bgv[1].bgv08,s_bgv[1].bgv09,s_bgv[1].bgv10,
                  s_bgv[1].bgvuser,s_bgv[1].bgvgrup,s_bgv[1].bgvmodu,s_bgv[1].bgvdate #MOD-990195 
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
   IF INT_FLAG THEN RETURN END IF
   CALL i160_b_fill(l_wc)
END FUNCTION
 
FUNCTION i160_b_fill(p_wc)            #BODY FILL UP
   DEFINE
      p_wc   LIKE type_file.chr1000   #No.FUN-680061  VARCHAR(200)
 
   LET g_sql =
       "SELECT bgv07,bgv08,bgv09,bgv10,bgvuser,bgvgrup,bgvmodu,bgvdate ", #MOD-990195 add user---date 
       "  FROM bgv_file ",
       " WHERE bgv00='1' AND bgv01 = '",g_bgv01 CLIPPED,"'",
       "   AND bgv02 = ",g_bgv02," ",
       "   AND bgv03 = ",g_bgv03," ",
       "   AND bgv04 = '",g_bgv04 CLIPPED,"'",
       "   AND bgv05 = '",g_bgv05 CLIPPED,"'",
       "   AND bgv06 = '",g_bgv06,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY bgv07"
   PREPARE i160_prepare2 FROM g_sql       #預備一下
   DECLARE bgv_cs CURSOR FOR i160_prepare2
 
   CALL g_bgv.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH bgv_cs INTO g_bgv[g_cnt].*     #單身 ARRAY 填充
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
   CALL g_bgv.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   IF g_cnt > g_max_rec THEN
      LET g_msg = g_bgv01 CLIPPED
      CALL cl_err(g_msg,9036,0)
   END IF
     
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i160_bp(p_ud)
   DEFINE  p_ud   LIKE type_file.chr1   #No.FUN-680061 VARCHAR(01)
   DEFINE l_cmd  LIKE type_file.chr1000      #No.FUN-820002 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bgv TO s_bgv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #MOD-840178  add UNBUFFERED
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
         CALL i160_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF 
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                  #No.MOD-530265
 
      ON ACTION previous
         CALL i160_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF 
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                  #No.MOD-530265
 
      ON ACTION jump 
         CALL i160_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF 
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                  #No.MOD-530265
 
      ON ACTION next
         CALL i160_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF 
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                  #No.MOD-530265
 
      ON ACTION last 
         CALL i160_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF 
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
          EXIT DISPLAY                  #No.MOD-530265
 
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i160_sum()
   SELECT SUM(bgv10) INTO g_tot FROM bgv_file
    WHERE bgv00='1' AND bgv01 = g_bgv01
      AND bgv02 = g_bgv02
      AND bgv03 = g_bgv03
      AND bgv04 = g_bgv04
      AND bgv05 = g_bgv05
      AND bgv06 = g_bgv06
   IF cl_null(g_tot) THEN LET g_tot = 0 END IF
   DISPLAY g_tot TO tot
END FUNCTION
 
#No.FUN-820002--start-- 
FUNCTION i160_out()
DEFINE l_cmd LIKE type_file.chr1000
#   DEFINE
#      l_i    LIKE type_file.num5,    #No.FUN-680061 SMALLINT
#      l_name LIKE type_file.chr20,   # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
#      l_za05 LIKE type_file.chr1000, #NO.FUN-680061 VARCHAR(40)  
#      sr RECORD
#         bgv01      LIKE bgv_file.bgv01,
#         bgv02      LIKE bgv_file.bgv02,
#         bgv03      LIKE bgv_file.bgv03,
#         bgv04      LIKE bgv_file.bgv04,
#         bgv05      LIKE bgv_file.bgv05,
#         bgv06      LIKE bgv_file.bgv06,
#         bgv07      LIKE bgv_file.bgv07,
#         bgv08      LIKE bgv_file.bgv08,
#         bgv09      LIKE bgv_file.bgv09,
#         bgv10      LIKE bgv_file.bgv10,
#         tot        LIKE bgv_file.bgv10,
#         gem02      LIKE gem_file.gem02,
#         bgs02      LIKE bgs_file.bgs02
#      END RECORD
    IF cl_null(g_wc) AND NOT cl_null(g_bgv00) AND NOT cl_null(g_bgv01)                                                              
       AND NOT cl_null(g_bgv02) AND NOT cl_null(g_bgv03)                                                                            
       AND NOT cl_null(g_bgv04) AND NOT cl_null(g_bgv05)                                                                            
       AND NOT cl_null(g_bgv06) AND NOT cl_null(g_bgv07)                                                                            
       AND NOT cl_null(g_bgv08) THEN                                                                                                
       LET g_wc = " bgp01 = '",g_bgv01,"' AND bgv02 = '",g_bgv02,                                                                   
                  "' AND bgv03 = '",g_bgv03,"' AND bgv04 = '",g_bgv04,                                                              
                  "' AND bgv05 = '",g_bgv05,"' AND bgv06 = '",g_bgv06,                                                              
                  "' AND bgv07 = '",g_bgv07,"' AND bgv08 = '",g_bgv08,"'"                                                           
    END IF                                                                                                                          
    IF g_wc IS NULL THEN CALL cl_err('','9057',0)  RETURN END IF                                                                    
    LET l_cmd = 'p_query "abgi160" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)
#   IF cl_null(g_bgv02) THEN RETURN END IF
#   CALL cl_wait()
#   CALL cl_outnam('abgi160') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#
#LET g_sql="SELECT bgv01,bgv02,bgv03,bgv04,bgv05,bgv06, ",
#             " bgv07,bgv08,bgv09,bgv10,'','',''",
#             "  FROM bgv_file ",   # 組合出 SQL 指令
#             " WHERE bgv00='1' AND ",g_wc CLIPPED ,
#             " ORDER BY bgv01,bgv02,bgv03,bgv04,bgv05,bgv06,bgv07,bgv08 "
#   PREPARE i160_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i160_co CURSOR FOR i160_p1
#
#   START REPORT i160_rep TO l_name
#
#   FOREACH i160_co INTO sr.*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#
#      SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = sr.bgv04
#      SELECT bgs02 INTO sr.bgs02 FROM bgs_file WHERE bgs01 = sr.bgv05
#
#      OUTPUT TO REPORT i160_rep(sr.*)
#   END FOREACH
#
#   FINISH REPORT i160_rep
#
#   CLOSE i160_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i160_rep(sr)
#   DEFINE
#      l_trailer_sw  LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
#      sr RECORD
#         bgv01      LIKE bgv_file.bgv01,
#         bgv02      LIKE bgv_file.bgv02,
#         bgv03      LIKE bgv_file.bgv03,
#         bgv04      LIKE bgv_file.bgv04,
#         bgv05      LIKE bgv_file.bgv05,
#         bgv06      LIKE bgv_file.bgv06,
#         bgv07      LIKE bgv_file.bgv07,
#         bgv08      LIKE bgv_file.bgv08,
#         bgv09      LIKE bgv_file.bgv09,
#         bgv10      LIKE bgv_file.bgv10,
#         tot        LIKE bgv_file.bgv10,
#         gem02      LIKE gem_file.gem02,
#         bgs02      LIKE bgs_file.bgs02
#      END RECORD
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.bgv01,sr.bgv02,sr.bgv03,sr.bgv04,sr.bgv05,
#            sr.bgv06,sr.bgv07,sr.bgv08
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED, pageno_total
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#               g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
#         PRINT g_dash1
#         LET l_trailer_sw = 'y'
#   
#      BEFORE GROUP OF sr.bgv01
#         PRINT COLUMN g_c[31],sr.bgv01 CLIPPED;
#
#      BEFORE GROUP OF sr.bgv02
#         PRINT COLUMN g_c[32],sr.bgv02;
#
#      BEFORE GROUP OF sr.bgv03
#         PRINT COLUMN g_c[33],sr.bgv03;
#
#      BEFORE GROUP OF sr.bgv04
#         PRINT COLUMN g_c[34],sr.bgv04 CLIPPED,
#               COLUMN g_c[35],sr.gem02 CLIPPED;
#
#      BEFORE GROUP OF sr.bgv05
#         PRINT COLUMN g_c[36],sr.bgv05 CLIPPED,
#               COLUMN g_c[37],sr.bgs02 CLIPPED;
#
#      BEFORE GROUP OF sr.bgv06
#         PRINT COLUMN g_c[38],sr.bgv06 CLIPPED;
#
#      ON EVERY ROW
#         PRINT COLUMN g_c[39],sr.bgv07 CLIPPED,
#               COLUMN g_c[40],sr.bgv08 CLIPPED,
#               COLUMN g_c[41],sr.bgv09 CLIPPED,
#               COLUMN g_c[42],cl_numfor(sr.bgv10,42,g_azi04) 
#
#      AFTER GROUP OF sr.bgv05
#         PRINT COLUMN g_c[42],g_dash2[1,g_w[42]]
#         PRINT COLUMN g_c[41],g_x[9] CLIPPED,
#               COLUMN g_c[42],cl_numfor(GROUP SUM(sr.bgv10),42,g_azi04)
#         SKIP 1 LINE
#
#      ON LAST ROW
#         IF g_zz05 = 'Y' THEN
#            PRINT g_dash[1,g_len]
#         END IF
#         PRINT g_dash[1,g_len]
#         LET l_trailer_sw = 'n'
#         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#      PAGE TRAILER
#         IF l_trailer_sw = 'y' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINE
#         END IF
#
#END REPORT
#No.FUN-820002--end--
 
 
#--------NO.MOD-590329 MARK--------------------
 #NO.MOD-580078
#FUNCTION i601_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("bgv07,bgv08",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION i601_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("bgv07,bgv08",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580078 --end
#--------NO.MOD-590329 MARK---------------------
