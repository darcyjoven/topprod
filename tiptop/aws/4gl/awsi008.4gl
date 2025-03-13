# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Modify.........: 新建立 FUN-8A0122 binbin
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_waj01          LIKE waj_file.waj01,
         g_waj02          LIKE waj_file.waj02,
         g_waj03          LIKE waj_file.waj03,
         g_waj04          LIKE waj_file.waj04, 
         g_waj01_t        LIKE waj_file.waj01,   
         g_waj02_t        LIKE waj_file.waj02,   
         g_waj03_t        LIKE waj_file.waj03,   
         g_waj04_t        LIKE waj_file.waj04,   
         g_waj_lock RECORD LIKE waj_file.*,      
         g_waj    DYNAMIC ARRAY of RECORD     
            waj05          LIKE waj_file.waj05,
            waj06          LIKE waj_file.waj06,
            waj07          LIKE waj_file.waj07,
            wak05          LIKE wak_file.wak05 
                      END RECORD,
         g_waj_t           RECORD                
            waj05          LIKE waj_file.waj05,
            waj06          LIKE waj_file.waj06,
            waj07          LIKE waj_file.waj07,
            wak05          LIKE wak_file.wak05
                      END RECORD,
         g_cnt2                LIKE type_file.num5,
          g_wc                  string,  #No.FUN-580092 HCN
          g_sql                 string,  #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,              # 決定后續步驟
         g_rec_b               LIKE type_file.num5,              # 單身筆數
         l_ac                  LIKE type_file.num5               # 目前處理的ARRAY CNT
DEFINE   g_chr                 LIKE type_file.chr1
DEFINE   g_cnt                 LIKE type_file.num5   
DEFINE   g_msg                 LIKE type_file.chr100
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_argv1               LIKE waj_file.waj01
DEFINE   g_argv2               LIKE waj_file.waj02
DEFINE   g_argv3               LIKE waj_file.waj04
DEFINE   g_curs_index          LIKE type_file.num5
DEFINE   g_row_count           LIKE type_file.num5
DEFINE   g_jump                LIKE type_file.num5
DEFINE   g_no_ask              LIKE type_file.num5
DEFINE   g_type                LIKE type_file.num5
DEFINE   g_num                 LIKE type_file.num5
 
MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AWS")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_waj01_t = NULL
 
   OPEN WINDOW i008_w WITH FORM "aws/42f/awsi008"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * from waj_file WHERE waj01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i008_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      SELECT COUNT(*) INTO g_num FROM waj_file 
         WHERE waj01 = g_argv1 AND waj02 = g_argv2 AND waj04= g_argv3
      IF g_num = 0 THEN
         LET g_type = "1"
         CALL i008_a()
      ELSE 
         CALL i008_q()
      END IF 
      LET g_argv1 =""
      LET g_argv2 =""
      LET g_argv3 =""
   END IF
   
   LET g_type = ""
    
   CALL i008_menu() 
 
   CLOSE WINDOW i008_w                       # 結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i008_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_waj.clear()
 
   IF NOT cl_null(g_argv2) THEN
      LET g_wc = " waj01 = '",g_argv1 CLIPPED ,"' ",
                 " AND waj02 ='",g_argv2 CLIPPED,"'",
                 " AND waj04 ='",g_argv3 CLIPPED,"'"         
   ELSE
 
      CONSTRUCT g_wc ON waj01,waj02,waj04,waj05,waj06,waj07
                   FROM waj01,waj02,waj04,s_waj[1].waj05,
                        s_waj[1].waj06,s_waj[1].waj07
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(waj01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_wag"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  IF NOT cl_null(g_qryparam.multiret) THEN
                  DISPLAY g_qryparam.multiret TO waj01
                  END IF
                  NEXT FIELD waj01
 
               WHEN INFIELD(waj02)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form = "q_wah"                                                                                     
                  LET g_qryparam.state = "c"                                                                                        
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  IF NOT cl_null(g_qryparam.multiret) THEN
                  DISPLAY g_qryparam.multiret TO waj02                                                                              
                  END IF
                  NEXT FIELD waj02
{
               WHEN INFIELD(waj03)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form = "q_zta2"                                                                                    
                  LET g_qryparam.state = "c"                                                                                        
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO waj03                                                                              
                  NEXT FIELD waj03
}
               WHEN INFIELD(waj04)                                                                                                  
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form = "q_wai"                                                                                    
                  LET g_qryparam.state = "c"                                                                                        
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  IF NOT cl_null(g_qryparam.multiret) THEN
                  DISPLAY g_qryparam.multiret TO waj04                                                                              
                  END IF
                  NEXT FIELD waj04
               OTHERWISE
                  EXIT CASE
            END CASE
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION help
             CALL cl_show_help()
          ON ACTION controlg
             CALL cl_cmdask()
          ON ACTION about
             CALL cl_about()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql= "SELECT UNIQUE waj01,waj02,waj04 FROM waj_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY waj01"
   PREPARE i008_prepare FROM g_sql        
   DECLARE i008_b_curs                  
      SCROLL CURSOR WITH HOLD FOR i008_prepare
 
END FUNCTION
 
 
FUNCTION i008_count()
 
   DEFINE la_waj   DYNAMIC ARRAY of RECORD       
            waj01          LIKE waj_file.waj01
                   END RECORD
   DEFINE li_cnt   LIKE type_file.num5
   DEFINE li_rec_b LIKE type_file.num5
 
   LET g_sql= "SELECT UNIQUE waj01,waj02,waj04 FROM waj_file ",
              " WHERE ", g_wc CLIPPED,
              " GROUP BY waj01,waj02,waj04 ORDER BY waj01"
 
   PREPARE i008_precount FROM g_sql
   DECLARE i008_count CURSOR FOR i008_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH i008_count INTO g_waj[li_cnt].*  
       LET li_rec_b = li_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET li_rec_b = li_rec_b - 1
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_rec_b
 
END FUNCTION
 
FUNCTION i008_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_waj TO s_waj.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
#      ON ACTION reproduce                        # C.復制
#         LET g_action_choice='reproduce'
#         EXIT DISPLAY
 
     ON ACTION delete                           # R.取消
        LET g_action_choice='delete'
        EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
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
         CALL i008_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL i008_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL i008_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL i008_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL i008_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
#       ON ACTION showlog             
#         LET g_action_choice = "showlog"
#         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i008_menu()
 
   WHILE TRUE
      CALL i008_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL i008_a()
            END IF
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL i008_u()
            END IF
#         WHEN "reproduce"                       # C.復制
#            IF cl_chk_act_auth() THEN
#               CALL i008_copy()
#            END IF
        WHEN "delete"                          # R.取消
           IF cl_chk_act_auth() THEN
              CALL i008_r()
           END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL i008_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i008_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_waj),'','')
            END IF
 
          WHEN "showlog"           #MOD-440464
            IF cl_chk_act_auth() THEN
               CALL cl_show_log("i008")
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i008_a()                            
   MESSAGE ""
   IF g_type ="1" THEN
      LET g_waj01=g_argv1
      LET g_waj02=g_argv2
      LET g_waj04=g_argv3
   ELSE  
      CLEAR FORM
      CALL g_waj.clear()
      LET g_waj01 = ""
      LET g_waj02 = ""
#     LET g_waj03 = ""
      LET g_waj04 = ""
    END IF
 
#   INITIALIZE g_waj01 LIKE waj_file.waj01    
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i008_i("a")                       
 
      IF INT_FLAG THEN                         
         LET g_waj01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
#      IF g_ss='N' THEN
#         CALL g_waj.clear()
#      ELSE
#         CALL i008_b_fill(' 1=1')             
#      END IF
 
      CALL i008_b()                         
      LET g_waj01_t=g_waj01
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i008_i(p_cmd)                       # 處理INPUT
 
   DEFINE   p_cmd        LIKE type_file.chr1                  # a:輸入 u:更改
   DEFINE   l_count      LIKE type_file.num5
 
#   LET g_ss = 'Y'
 
   DISPLAY g_waj01,g_waj02,g_waj04 TO waj01,waj02,waj04
   INPUT g_waj01,g_waj02,g_waj04 WITHOUT DEFAULTS FROM waj01,waj02,waj04
 
      AFTER FIELD waj01                                                                                                            
      LET l_count ="0"                                                                                                             
      SELECT COUNT(*) INTO  l_count FROM wag_file WHERE wag01 = g_waj01                                                            
      IF l_count = "0" THEN                                                                                                        
         CALL cl_err("",'aws-189',0)                                                                                               
         NEXT FIELD waj01                                                                                                          
      END IF                                                                                                                       
                                                                                                                                    
      AFTER FIELD waj02                                                                                                            
      LET l_count ="0"                                                                                                             
      SELECT COUNT(*) INTO l_count FROM wah_file WHERE wah02 = g_waj02 AND wah01 = g_waj01                                         
      IF l_count = "0" THEN                                                                                                        
         CALL cl_err("",'aws-111',0)                                                                                               
         NEXT FIELD waj02                                                                                                          
      END IF                                                                                                                       
                                                                                                                                   
#     AFTER FIELD waj03                                                                                                             
#     LET l_count = "0"                                                                                                             
#     SELECT COUNT(*) INTO l_count FROM wai_file WHERE wai03 = g_waj03 AND wai01 = g_waj01                                          
#     IF l_count = "0" THEN                                                                                                         
#        CALL cl_err("",'aws-102',0)
#         NEXT FIELD waj03                                                                                                           
#     END IF                                                                                                                        
                                                                                                                                    
#     AFTER FIELD waj04                                                                                                             
#     LET l_count = "0"                                                                                                             
#     SELECT COUNT(*) INTO l_count FROM wai_file WHERE wai05 = g_waj04 AND wai01 = g_waj01 AND wai03 =g_waj02                                           
#     IF l_count = "0" THEN                                                                                                         
#        CALL cl_err("",'aws-103',0)                                                                                                
#        NEXT FIELD waj04                                                                                                           
#     END IF   
 
      AFTER INPUT
         IF NOT cl_null(g_waj01) THEN
            IF g_waj01 != g_waj01_t OR cl_null(g_waj01_t) THEN
               SELECT COUNT(UNIQUE waj01) INTO g_cnt FROM waj_file
                WHERE waj01 = g_waj01 
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_waj01,g_errno,0)
                  NEXT FIELD waj01
               END IF
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(waj01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_wag"
               LET g_qryparam.default1= g_waj01
               CALL cl_create_qry() RETURNING g_waj01
               NEXT FIELD waj01
 
            WHEN INFIELD(waj02)                                                                                                     
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_wah"                                                                                        
               LET g_qryparam.arg1 = g_waj01 CLIPPED
               LET g_qryparam.default1= g_waj02                                                                                     
               LET g_qryparam.arg1     = g_waj01                
               CALL cl_create_qry() RETURNING g_waj02                                                                               
               NEXT FIELD waj02
{            
            WHEN INFIELD(waj03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_wai"                                                                                       
               LET g_qryparam.default1= g_waj03   
               LET g_qryparam.arg1 = g_waj01
               LET g_qryparam.arg2 = g_waj02                                                                                  
               CALL cl_create_qry() RETURNING g_waj03                                                                               
               NEXT FIELD waj03 
 }             
            WHEN INFIELD(waj04)                                                                                                     
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_wai"                                                                                       
               LET g_qryparam.default1= g_waj04  
               LET g_qryparam.arg1 = g_waj02
               LET g_qryparam.arg2 = g_waj01                                                                                     
               CALL cl_create_qry() RETURNING g_waj04                                                                               
               NEXT FIELD waj04  
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
END FUNCTION
 
 
FUNCTION i008_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_waj01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_waj01_t = g_waj01
 
   BEGIN WORK
   OPEN i008_lock_u USING g_waj01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i008_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i008_lock_u INTO g_waj_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("waj01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i008_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL i008_i("u")
      IF INT_FLAG THEN
         LET g_waj01 = g_waj01_t
         DISPLAY g_waj01 TO waj01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE waj_file SET waj01 = g_waj01,waj02 = g_waj02,waj04 = g_waj04
       WHERE waj01 = g_waj01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_waj01,SQLCA.sqlcode,0)  #No.FUN-660081
#         CALL cl_err3("upd","waj_file",g_waj01_t,SQLCA.sqlcode,"","",1) #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION i008_q()                            #Query 查詢
 
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
#   CLEAR FROM
#   CALL g_waj.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i008_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i008_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_waj01 TO NULL
   ELSE
     OPEN i008_count
     FETCH i008_count INTO g_row_count
     CALL i008_count()
     DISPLAY g_row_count TO FORMONLY.cnt
     CALL i008_fetch('F')                 #讀出TEMP第一筆并顯示
   END IF
     
END FUNCTION
 
FUNCTION i008_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,                 #處理方式
            l_abso   LIKE type_file.num5                  #絕對的筆數
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i008_b_curs INTO g_waj01,g_waj02,g_waj04
      WHEN 'P' FETCH PREVIOUS i008_b_curs INTO g_waj01,g_waj02,g_waj04
      WHEN 'F' FETCH FIRST    i008_b_curs INTO g_waj01,g_waj02,g_waj04
      WHEN 'L' FETCH LAST     i008_b_curs INTO g_waj01,g_waj02,g_waj04
      WHEN '/' 
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i008_b_curs INTO g_waj01
         LET g_no_ask = FALSE   
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      CALL i008_show()
   END IF
END FUNCTION
 
FUNCTION i008_show()                         
   DISPLAY g_waj01,g_waj02,g_waj04 TO waj01,waj02,waj04
   CALL i008_b_fill(g_wc)                    
    CALL cl_show_fld_cont()                   
END FUNCTION
 
 
FUNCTION i008_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,
            l_waj   RECORD LIKE waj_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_waj01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM waj_file
       WHERE waj01 = g_waj01 AND waj02 = g_waj02 AND waj04 = g_waj04 
      IF SQLCA.sqlcode THEN
         CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
#         CALL cl_err3("del","waj_file",g_waj01,SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_waj.clear()
         OPEN i008_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i008_b_curs
            CLOSE i008_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end--
         FETCH i008_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i008_b_curs
            CLOSE i008_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         CALL i008_count()
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i008_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i008_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i008_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION i008_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,             # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,             # 檢查重復用
            l_gau01         LIKE type_file.num5,             # 檢查重復用
            l_lock_sw       LIKE type_file.chr1,             # 單身鎖住否
            p_cmd           LIKE type_file.chr1,             # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   l_count         LIKE type_file.num5
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
   DEFINE   l_tipid          LIKE wai_file.wai02,
            l_tipcol         LIKE wai_file.wai04,
            l_wak05          LIKE wak_file.wak05
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_waj01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT waj05,waj06,waj07 ",
                     "  FROM waj_file",
                     " WHERE waj01 = ? AND waj02 = ? AND waj04 = ? AND waj05 =?  ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i008_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_waj WITHOUT DEFAULTS FROM s_waj.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,
                        DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_waj_t.* = g_waj[l_ac].*    #BACKUP
            OPEN i008_bcl USING g_waj01,g_waj02,g_waj04,g_waj[l_ac].waj05
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN i008_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH i008_bcl INTO g_waj[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH i008_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            SELECT wai02,wai04 INTO l_tipid,l_tipcol FROM wai_file WHERE wai01=g_waj01                                                       
               AND wai03 =g_waj02 AND wai05 =g_waj04                                                                                          
            SELECT wak05 INTO g_waj[l_ac].wak05 FROM wak_file WHERE wak01 = l_tipid                                                        
               AND wak03=l_tipcol AND wak04 = g_waj[l_ac].waj07                                                                             
#            DISPLAY  g_waj[l_ac].wak05              
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD waj05
         END IF
#         IF g_waj[l_ac].waj02 = 'wintitle' THEN
#            CALL cl_set_comp_entry("waj04",FALSE)
#         ELSE
#            CALL cl_set_comp_entry("waj04",TRUE)
#         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_waj[l_ac].* TO NULL       #900423
         LET g_waj_t.* = g_waj[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD waj05
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO waj_file(waj01,waj02,waj04,waj05,waj06,waj07)
                      VALUES (g_waj01,g_waj02,g_waj04,
                              g_waj[l_ac].waj05,g_waj[l_ac].waj06,g_waj[l_ac].waj07)
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_waj01,SQLCA.sqlcode,0)  #No.FUN-660081
#            CALL cl_err3("ins","waj_file",g_waj01,g_waj[l_ac].waj02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
         ON CHANGE  waj07 
            SELECT wai02,wai04 INTO l_tipid,l_tipcol FROM wai_file WHERE wai01=g_waj01                                                       
               AND wai03 =g_waj02 AND wai05 =g_waj04                                                                                          
            SELECT wak05 INTO g_waj[l_ac].wak05 FROM wak_file WHERE wak01 = l_tipid                                                        
               AND wak03=l_tipcol AND wak04 = g_waj[l_ac].waj07                                                                             
#            DISPLAY  g_waj[l_ac].wak05              
                                                                                     
      BEFORE DELETE                            #是否取消單身
#         IF NOT cl_null(g_waj_t.waj02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
#            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
#               CALL cl_err(g_waj[l_ac].waj02,"azz-082",1)
#            END IF
            DELETE FROM waj_file WHERE waj01 = g_waj01
                                   AND waj05 = g_waj[l_ac].waj05
                                   AND waj06 = g_waj[l_ac].waj06
                                   AND waj02 = g_waj02
#                                   AND waj03 = g_waj03  
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_waj02,SQLCA.sqlcode,0)  #No.FUN-660081
#               CALL cl_err3("del","waj_file",g_waj01,g_waj_t.waj02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
#         END IF
         COMMIT WORK
     
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_waj[l_ac].* = g_waj_t.*
            CLOSE i008_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("g_waj[l_ac].waj02","azz-083",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_waj02,-263,1)
            LET g_waj[l_ac].* = g_waj_t.*
         ELSE
            UPDATE waj_file
               SET waj05 = g_waj[l_ac].waj05,
                   waj06 = g_waj[l_ac].waj06,
                   waj07 = g_waj[l_ac].waj07
             WHERE waj01 = g_waj01
               AND waj05 = g_waj_t.waj05
               AND waj06 = g_waj_t.waj06
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_waj02,SQLCA.sqlcode,0)  #No.FUN-660081
#               CALL cl_err3("upd","waj_file",g_waj01,g_waj_t.waj02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_waj[l_ac].* = g_waj_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
#               LET ls_msg_n = g_waj01 CLIPPED,"",g_waj[l_ac].waj02 CLIPPED,"",
#                              g_waj[l_ac].waj03 CLIPPED,"",g_waj[l_ac].waj04 CLIPPED,"",
#               LET ls_msg_o = g_waj01 CLIPPED,"",g_waj_t.waj02 CLIPPED,"",
#                              g_waj_t.waj03 CLIPPED,"",g_waj_t.waj04 CLIPPED,"",
#                              g_waj_t.waj05 CLIPPED,"",g_waj_t.waj10 CLIPPED,"",
#                CALL cl_log("i008","U",ls_msg_n,ls_msg_o)            # MOD-440464
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_waj[l_ac].* = g_waj_t.*
            END IF
            CLOSE i008_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i008_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(waj02) AND l_ac > 1 THEN
            LET g_waj[l_ac].* = g_waj[l_ac-1].*
            NEXT FIELD waj02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(waj04)
#               CALL s_keyrelat(g_waj04,g_waj03,g_waj[l_ac].waj02)
#                    RETURNING g_waj[l_ac].waj04
#               DISPLAY g_waj[l_ac].waj04 TO waj04
#               NEXT FIELD waj04
 
#            OTHERWISE
#               EXIT CASE
#         END CASE
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
 
   END INPUT
 
   CLOSE i008_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i008_b_fill(p_wc)              
   DEFINE l_tipid          LIKE wai_file.wai02,
          l_tipcol         LIKE wai_file.wai04
   DEFINE 
          #p_wc         LIKE type_file.chr300
          p_wc         STRING       #NO.FUN-910082
   DEFINE p_ac         LIKE type_file.num5
 
    LET g_sql = "SELECT waj05,waj06,waj07 ",
                 " FROM waj_file ",
                 " WHERE waj01 = '",g_waj01 CLIPPED,"' " ,
                 " AND waj02 = '",g_waj02 CLIPPED,"'",
                 " AND waj04 ='",g_waj04 CLIPPED,"'",
                 " AND ",p_wc CLIPPED,
                 " ORDER BY waj02"
 
    PREPARE i008_prepare2 FROM g_sql           #預備一下
    DECLARE waj_curs CURSOR FOR i008_prepare2
 
    CALL g_waj.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH waj_curs INTO g_waj[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT wai02,wai04 INTO l_tipid,l_tipcol FROM wai_file WHERE wai01=g_waj01 
          AND wai03 =g_waj02 AND wai05 =g_waj04
       SELECT wak05 INTO g_waj[g_cnt].wak05 FROM wak_file WHERE wak01 =l_tipid
          AND wak03=l_tipcol AND wak04 =g_waj[g_cnt].waj07
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_waj.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i008_copy()
   DEFINE   l_n       LIKE type_file.num5,
            l_new01   LIKE waj_file.waj01,
            l_old01   LIKE waj_file.waj01
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_waj01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INPUT l_new01 WITHOUT DEFAULTS FROM waj01
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         IF cl_null(l_new01) THEN
            NEXT FIELD waj01
            LET INT_FLAG = 1   #MOD-4A0311  mark
         END IF
#FUN-4C0020
          SELECT COUNT(*) INTO g_cnt FROM waj_file
           WHERE waj01 = l_new01 
#          IF g_cnt > 0 THEN
#             CALL cl_err_msg(NULL,"azz-110",l_new01||"|"||l_ew11,10)
##            CALL cl_err(l_new11,-239,0)
##            NEXT FIELD waj01
#          END IF
#FUN-4C0020(END)
 
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_waj01 TO waj01
      RETURN
   END IF
 
   DROP TABLE x
#FUN-4C0020
   SELECT * FROM waj_file 
     WHERE waj01=g_waj01 and (waj02 NOT IN 
     (SELECT waj02 FROM waj_file WHERE waj01=l_new01 )
     or( waj02 IN (SELECT waj02 FROM waj_file WHERE waj01=l_new01 )
     and waj03 NOT IN (SELECT waj03 FROM waj_file WHERE waj01=l_new01 )))
   INTO TEMP x
 
#  SELECT * FROM waj_file WHERE waj01 = g_waj01 
#    INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_waj01,SQLCA.sqlcode,0)  #No.FUN-660081
#      CALL cl_err3("ins","x",g_waj01,SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET waj01 = l_new01                        # 資料鍵值
 
   INSERT INTO waj_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('waj:',SQLCA.SQLCODE,0)  #No.FUN-660081
#      CALL cl_err3("ins","waj_file",l_new01,SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_waj01
   LET g_waj01 = l_new01
   CALL i008_b()
   #LET g_waj01 = l_old01  #FUN-C80046
   #CALL i008_show()       #FUN-C80046
END FUNCTION
 
#FUN-B80064 
#No.FUN-8A0122
