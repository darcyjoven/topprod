# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: abgi301.4gl
# Descriptions...: 客戶應收科目維護作業
# Date & Author..: 03/10/22 ching No.8534
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/17 By Smapmin 報表轉XML格式
# Modify.........: NO.FUN-580078 05/09/13 by yiting key可更改
# Modify.........: NO.MOD-590329 05/10/03 BY yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/23 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-690024 06/09/15 By jamie 判斷pmcacti
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/19 By Carrier 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.TQC-860021 08/06/10 By Sarah CONSTRUCT段漏了ON IDLE控制 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"                                               
                                             
 
#模組變數(Module Variables)
DEFINE 
    g_bhe00         LIKE bhe_file.bhe00,  
    g_bhe00_t       LIKE bhe_file.bhe00, 
    g_bhe00_o       LIKE bhe_file.bhe00,
    g_bhe           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        bhe01       LIKE bhe_file.bhe01,                 
        bhe06       LIKE bhe_file.bhe06,                 
        aag02       LIKE aag_file.aag02                 
                    END RECORD,
    g_bhe_t         RECORD                   #程式變數 (舊值)
        bhe01       LIKE bhe_file.bhe01,                 
        bhe06       LIKE bhe_file.bhe06,                 
        aag02       LIKE aag_file.aag02                 
                    END RECORD,
    g_wc,g_sql,g_wc2 string,  #No.FUN-580092 HCN
    g_ss            LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(01)        
    g_rec_b         LIKE type_file.num5,     #單身筆數  #No.FUN-680061 SMALLINT
    l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5      #No.FUN-680061 SMALLINT
DEFINE g_forupd_sql STRING                   #SELECT ... FOR UPDATE SQL                         
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680061 SMALLINT
                                                                                
DEFINE g_cnt        LIKE type_file.num10     #No.FUN-680061 INTEGER
DEFINE g_i          LIKE type_file.num5      #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_msg        LIKE ze_file.ze03        #No.FUN-680061 VARCHAR(72) 
DEFINE g_row_count  LIKE type_file.num10     #No.FUN-680061 INTEGER
DEFINE g_curs_index LIKE type_file.num10     #No.FUN-680061 INTEGER
DEFINE g_jump       LIKE type_file.num10     #查詢指定的筆數 #No.FUN-680061 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5      #是否開啟指定筆視窗 #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask
 
#主程式開始
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0056
 
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
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time                            #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
                                                                                
    LET p_row = 2 LET p_col = 12                                                
                                                                                
    OPEN WINDOW i301_w AT p_row,p_col                                           
         WITH FORM "abg/42f/abgi301"                                            
          ATTRIBUTE (STYLE = g_win_style CLIPPED)                                         #No.FUN-580092 HCN
                                                                                
    CALL cl_ui_init()       
                                                                                
                                                                                
    CALL i301_menu()                                                            
                                                                                
    CLOSE WINDOW i301_w                 #結束畫面                               
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)              #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time                                                           #No.FUN-6A0056
                                                                                
END MAIN        
 
 
 
#QBE 查詢資料
FUNCTION i301_cs()
    CLEAR FORM                             #清除畫面
    CALL g_bhe.clear()
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_bhe00 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bhe00 FROM bhe00            #螢幕上取條件
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
             LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
    LET g_sql= "SELECT UNIQUE bhe00 FROM bhe_file ",
               " WHERE ", g_wc CLIPPED,
               "  AND (bhe00= '2' OR bhe00='3') ",
               " ORDER BY bhe00"
    PREPARE i301_prepare FROM g_sql        #預備一下
    DECLARE i301_bcs                       #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i301_prepare
 
    LET g_sql="SELECT COUNT(DISTINCT bhe00)  ",
              "  FROM bhe_file ",
              " WHERE ", g_wc CLIPPED,
              "   AND (bhe00= '2' OR bhe00='3') "
    PREPARE i301_precount FROM g_sql
    DECLARE i301_count CURSOR FOR i301_precount
 
END FUNCTION
 
 
FUNCTION i301_menu()
   WHILE TRUE                                                                   
      CALL i301_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "insert"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i301_a()                                                    
            END IF                                                              
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i301_q()                                                    
            END IF 
         WHEN "change_release"                                                  
            IF cl_chk_act_auth()THEN                                            
               CALL i301_g()                                                    
            END IF                                                                  
         WHEN "delete"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i301_r()                                                    
            END IF                      
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i301_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i301_out()                                                  
            END IF                                                              
         WHEN "help"                                                            
            CALL cl_show_help()                                                    
         WHEN "exit"                                                            
            EXIT WHILE                                                          
         WHEN "controlg"                                                        
            CALL cl_cmdask()                                                    
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bhe),'','')
            END IF
      END CASE                                                                  
   END WHILE                                                                    
END FUNCTION         
 
 
 
 
FUNCTION i301_a()
    IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_bhe00 LIKE bhe_file.bhe00         #DEFAULT 設定
    CALL g_bhe.clear()
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i301_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            LET g_bhe00=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_bhe00 IS NULL THEN # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_rec_b = 0                    #No.FUN-680064 
        IF g_ss='N' THEN                                                        
            FOR g_cnt = 1 TO g_bhe.getLength()                                  
                INITIALIZE g_bhe[g_cnt].* TO NULL                               
            END FOR                                                             
        ELSE                                                                    
            CALL i301_b_fill(' 1=1')          #單身                             
        END IF        
 
        CALL i301_b()                              #輸入單身
        LET g_bhe00_t = g_bhe00                    #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i301_i(p_cmd)
DEFINE
    l_flag    LIKE type_file.chr1,    #判斷必要欄位是否有輸入 #No.FUN-680061 VARCHAR(01)
    l_n1,l_n  LIKE type_file.num5,    #No.FUN-680061 SMALLINT
    p_cmd     LIKE type_file.chr1     #a:輸入 u:更改  #No.FUN-680061 VARCHAR(01)
 
    DISPLAY g_bhe00 TO bhe00 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT  g_bhe00 FROM bhe00 #WITHOUT DEFAULTS 
 
        AFTER FIELD bhe00 
          IF NOT cl_null(g_bhe00) THEN 
             IF g_bhe00 NOT MATCHES '[2]' THEN 
                NEXT FIELD bhe00 
             END IF
             SELECT COUNT(*) INTO l_n FROM bhe_file 
              WHERE bhe00=g_bhe00
              IF l_n>0 THEN 
                 CALL cl_err(g_bhe00,-239,0)
                 NEXT FIELD bhe00
              END IF
             LET g_bhe00_o = g_bhe00
          END IF
 
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
FUNCTION i301_q()
   LET g_row_count = 0                                                          
   LET g_curs_index = 0                                                         
   CALL cl_navigator_setting( g_curs_index, g_row_count )          
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_bhe.clear()
 
    CALL i301_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i301_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bhe00 TO NULL
    ELSE
      OPEN i301_count                                                           
      FETCH i301_count INTO g_row_count                                         
      DISPLAY g_row_count TO FORMONLY.cnt 
        CALL i301_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i301_fetch(p_flag)
DEFINE
    p_flag   LIKE type_file.chr1   #處理方式 #No.FUN-680061 VARCHAR(01)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i301_bcs INTO g_bhe00
        WHEN 'P' FETCH PREVIOUS i301_bcs INTO g_bhe00
        WHEN 'F' FETCH FIRST    i301_bcs INTO g_bhe00
        WHEN 'L' FETCH LAST     i301_bcs INTO g_bhe00
        WHEN '/' 
        IF (NOT mi_no_ask) THEN                     #No.FUN-6A0057 g_no_ask
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
            FETCH ABSOLUTE g_jump i301_bcs INTO g_bhe00
            LET mi_no_ask = FALSE            #No.FUN-6A0057 g_no_ask
    END CASE
    SELECT unique bhe00 FROM bhe_file WHERE bhe00 = g_bhe00
    IF SQLCA.sqlcode THEN                         #有麻煩
#       CALL cl_err(g_bhe00,SQLCA.sqlcode,0) #FUN-660105
        CALL cl_err3("sel","bhe_file",g_bhe00,"",SQLCA.sqlcode,"","",1) #FUN-660105  
        INITIALIZE g_bhe00 TO NULL  #TQC-6B0105
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
 
        CALL i301_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i301_show()
 
    DISPLAY g_bhe00 TO bhe00            #單頭
    CALL i301_b_fill(g_wc)              #單身
    CALL i301_bp("D")
    CALL cl_show_fld_cont()             #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i301_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_bhe00 IS NULL 
	THEN CALL cl_err('',-400,0) RETURN 
    END IF
    BEGIN WORK
    IF cl_delh(15,16) THEN
        DELETE FROM bhe_file WHERE bhe00=g_bhe00 
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_bhe00,SQLCA.sqlcode,0) #FUN-660105
           CALL cl_err3("del","bhe_file",g_bhe00,"",SQLCA.sqlcode,"","",1) #FUN-660105  
        ELSE 
           CLEAR FORM
           INITIALIZE g_bhe00 TO NULL
           CALL g_bhe.clear()
           OPEN i301_count                                                           
           #FUN-B50062-add-start--
           IF STATUS THEN
              CLOSE i301_bcs
              CLOSE i301_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end--
           FETCH i301_count INTO g_row_count       
           #FUN-B50062-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i301_bcs
              CLOSE i301_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end--                                  
           DISPLAY g_row_count TO FORMONLY.cnt                                       
           OPEN i301_bcs                                                              
           IF g_curs_index = g_row_count + 1 THEN                                    
              LET g_jump = g_row_count                                               
              CALL i301_fetch('L')                                                   
           ELSE                                                                      
              LET g_jump = g_curs_index                                              
              LET mi_no_ask = TRUE              #No.FUN-6A0057 g_no_ask                                            
              CALL i301_fetch('/')                                                   
           END IF                   
        END IF
    END IF
    COMMIT WORK 
END FUNCTION
 
#單身
FUNCTION i301_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用 #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否 #No.FUN-680061 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,    #處理狀態   #No.FUN-680061 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,    #可新增否   #NO.FUN-680061 VARCHAR(1)
    l_allow_delete  LIKE type_file.num5     #可更改否 (含取消) #NO.FUN-680061 VARCHAR(1)
 
    LET g_action_choice = ""           
 
    CALL cl_opmsg('b')
    LET g_forupd_sql =  
        "SELECT bhe01,bhe06,'' FROM bhe_file ",
        "WHERE bhe00 = ? AND bhe01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i301_b_cl CURSOR FROM g_forupd_sql  
 
 
 
    LET l_allow_insert = cl_detail_input_auth("insert")                         
    LET l_allow_delete = cl_detail_input_auth("delete")                         
                                                                                
    INPUT ARRAY g_bhe WITHOUT DEFAULTS FROM s_bhe.*                             
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
            LET p_cmd='u'
            LET g_bhe_t.* = g_bhe[l_ac].*  #BACKUP
#NO.MOD-590329 MARK--------------------
 #No.MOD-580078 --start
#            LET g_before_input_done = FALSE
#            CALL i301_set_entry_b(p_cmd)
#            CALL i301_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329 MARK--------------------
            OPEN i301_b_cl USING g_bhe00,g_bhe_t.bhe01             #表示更改狀態
               IF STATUS THEN                                                   
                  CALL cl_err("OPEN i301_b_cl:", STATUS, 1)                     
                                                                                
                  LET l_lock_sw = "Y"                                           
               ELSE           
 
                  FETCH i301_b_cl INTO g_bhe[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_bhe_t.bhe01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT aag02 INTO g_bhe[l_ac].aag02 FROM aag_file
                   WHERE aag01 = g_bhe[l_ac].bhe06
                     AND aag00 = g_aza.aza81  #No.FUN-730033
                  IF SQLCA.sqlcode THEN LET g_bhe[l_ac].aag02 = ' '
                     LET g_bhe_t.*=g_bhe[l_ac].*
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bhe[l_ac].* TO NULL      #900423
            LET g_bhe_t.* = g_bhe[l_ac].*         #新輸入資料
#NO.MOD-590329 MARK-------------------------
 #No.MOD-580078 --start
#            LET g_before_input_done = FALSE
#            CALL i301_set_entry_b(p_cmd)
#            CALL i301_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.MOD-590329 MARK------------------------
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bhe01
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               CANCEL INSERT                                                    
            END IF                                                              
 
            #MOD-790002.................begin
            IF cl_null(g_bhe00)  THEN
               LET g_bhe00=' '
            END IF
            #MOD-790002.................end
 
            INSERT INTO bhe_file(bhe00,bhe01,bhe06)                 
                          VALUES(g_bhe00,g_bhe[l_ac].bhe01,                    
                                 g_bhe[l_ac].bhe06)                                         IF SQLCA.sqlcode THEN                                   
#               CALL cl_err(g_bhe[l_ac].bhe01,SQLCA.sqlcode,0) #FUN-660105
                CALL cl_err3("ins","bhe_file",g_bhe00,g_bhe[l_ac].bhe01,SQLCA.sqlcode,"","",1) #FUN-660105       
                CANCEL INSERT
            ELSE                                                    
                MESSAGE 'INSERT O.K'                                
                COMMIT WORK
                LET g_rec_b=g_rec_b+1                                            
            END IF
 
 
 
        AFTER  FIELD bhe01
            IF NOT cl_null(g_bhe[l_ac].bhe01) THEN 
               IF g_bhe[l_ac].bhe01 != g_bhe_t.bhe01 OR 
                  (g_bhe[l_ac].bhe01 IS NOT NULL AND g_bhe_t.bhe01 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM bhe_file
                  WHERE bhe00 = g_bhe00 AND bhe01 = g_bhe[l_ac].bhe01
                  IF l_n > 0 THEN
                     CALL cl_err(g_bhe[l_ac].bhe01,-239,0)
                     LET g_bhe[l_ac].bhe01 = g_bhe_t.bhe01
                     NEXT FIELD bhe01
                  END IF
               END IF
               IF g_bhe00='2' THEN
                  CALL i301_bhe01('a') 
                 IF NOT cl_null(g_errno) AND g_bhe[l_ac].bhe01<>'*' THEN
                    CALL cl_err('',g_errno,0) NEXT FIELD bhe01
                 END IF
               END IF
               IF g_bhe00='3' AND g_bhe[l_ac].bhe01<>'*' THEN
                  NEXT FIELD bhe01
               END IF
            END IF
 
       AFTER FIELD bhe06
           IF NOT cl_null(g_bhe[l_ac].bhe06) THEN 
              CALL i301_bhe06(g_bhe[l_ac].bhe06)
              IF NOT cl_null(g_errno)  THEN
                 CALL cl_err('',g_errno,0) 
                 #FUN-B10049--begin
                 CALL cl_init_qry_var()                                         
                 LET g_qryparam.form ="q_aag"                                   
                 LET g_qryparam.default1 = g_bhe[l_ac].bhe06  
                 LET g_qryparam.construct = 'N'                
                 LET g_qryparam.arg1 = g_aza.aza81  
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 IN ('2') AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_bhe[l_ac].bhe06 CLIPPED,"%' "                                                                        
                 CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe06
                 DISPLAY BY NAME g_bhe[l_ac].bhe06    
                 #FUN-B10049--end                    
                 NEXT FIELD bhe06                 
              END IF
              SELECT aag02 INTO g_bhe[l_ac].aag02
                FROM aag_file
               WHERE aag01=g_bhe[l_ac].bhe06
                 AND aag00 = g_aza.aza81  #No.FUN-730033
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bhe_t.bhe01 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN                                         
                   CALL cl_err("", -263, 1)                                     
                   CANCEL DELETE                                                
                END IF          
                DELETE FROM bhe_file
                    WHERE bhe00 = g_bhe00 AND bhe01 = g_bhe[l_ac].bhe01
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bhe_t.bhe01,SQLCA.sqlcode,0) #FUN-660105
                    CALL cl_err3("del","bhe_file",g_bhe00,g_bhe[l_ac].bhe01,SQLCA.sqlcode,"","",1) #FUN-660105  
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                COMMIT WORK 
            END IF
 
        ON ROW CHANGE                                                           
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               LET g_bhe[l_ac].* = g_bhe_t.*                                    
               CLOSE i301_b_cl                                                  
                                                                                
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            IF l_lock_sw = 'Y' THEN                                             
               CALL cl_err(g_bhe[l_ac].bhe01,-263,1)                            
               LET g_bhe[l_ac].* = g_bhe_t.*                                    
            ELSE        
               UPDATE bhe_file                                         
                  SET bhe01=g_bhe[l_ac].bhe01,                         
                      bhe06=g_bhe[l_ac].bhe06                          
                WHERE CURRENT OF i301_b_cl                           
               IF SQLCA.sqlcode THEN                                   
#                 CALL cl_err(g_bhe[l_ac].bhe01,SQLCA.sqlcode,0) #FUN-660105
                  CALL cl_err3("upd","bhe_file",g_bhe00,g_bhe[l_ac].bhe01,SQLCA.sqlcode,"","",1) #FUN-660105       
                  LET g_bhe[l_ac].* = g_bhe_t.*                       
               ELSE                                                    
                  MESSAGE 'UPDATE O.K'                                
                  COMMIT WORK 
               END IF              
            END IF                                               
 
        AFTER ROW                                                               
            LET l_ac = ARR_CURR()                                               
           #LET l_ac_t = l_ac       #FUN-D30032 mark                                            
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN                                              
                  LET g_bhe[l_ac].* = g_bhe_t.*                                 
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bhe.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF                                                           
               CLOSE i301_b_cl                                                  
                                                                                
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                  
            LET l_ac_t = l_ac       #FUN-D30032 add                            
            CLOSE i301_b_cl                                                     
                                                                                
            COMMIT WORK                 
 
 
        ON ACTION CONTROLN
            CALL i301_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                      #沿用所有欄位
            IF INFIELD(bhe01) AND l_ac > 1 THEN
                LET g_bhe[l_ac].* = g_bhe[l_ac-1].*
                NEXT FIELD bhe01
            END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bhe01)
                IF g_bhe00='2' THEN
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_occ"                                 
                   LET g_qryparam.default1 = g_bhe[l_ac].bhe01                  
                   CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe01            
#                   CALL FGL_DIALOG_SETBUFFER( g_bhe[l_ac].bhe01 )               
                ELSE
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_occ"                                 
                   LET g_qryparam.default1 = g_bhe[l_ac].bhe01                  
                   CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe01             
#                   CALL FGL_DIALOG_SETBUFFER( g_bhe[l_ac].bhe01 )               
                END IF
                NEXT FIELD bhe01          
              WHEN INFIELD(bhe06)                                         
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_aag"                                 
                   LET g_qryparam.default1 = g_bhe[l_ac].bhe06                  
                   LET g_qryparam.arg1 = g_aza.aza81   #No.FUN-730033
                   LET g_qryparam.where = " aag07 IN ('2','3') ",             
                                          " AND aag03 IN ('2')"  
                   CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe06             
                   DISPLAY BY NAME g_bhe[l_ac].bhe06  #No.FUN-730033
#                   CALL FGL_DIALOG_SETBUFFER( g_bhe[l_ac].bhe06 )               
                   NEXT FIELD bhe06
             END CASE        
        
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
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
        END INPUT
 
END FUNCTION
 
FUNCTION i301_bhe01(p_cmd)
DEFINE
  p_cmd   LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
  l_pmc   RECORD LIKE pmc_file.*,
  l_occ   RECORD LIKE occ_file.*
  IF g_bhe00='2' THEN
     LET g_errno = ' '
     SELECT *       INTO l_occ.*    
       FROM occ_file
      WHERE occ01 = g_bhe[l_ac].bhe01
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
       WHEN l_occ.occacti='N'             LET g_errno = '9028'
      #FUN-690023------mod-------
       WHEN l_occ.occacti MATCHES '[PH]'  LET g_errno = '9038'
      #FUN-690023------mod------- 
       OTHERWISE                          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
  END IF
 
  IF g_bhe00='3' THEN
     LET g_errno = ' '
     SELECT *       INTO l_pmc.*    FROM pmc_file
      WHERE pmc01 = g_bhe[l_ac].bhe01
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
          WHEN l_pmc.pmcacti='N'    LET g_errno = '9028'
        #FUN-690024------mod-------
          WHEN l_pmc.pmcacti MATCHES '[PH]'       LET g_errno = '9038'
        #FUN-690024------mod-------
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
  END IF
END FUNCTION
 
 
FUNCTION i301_bhe06(p_code)
 DEFINE p_code     LIKE aag_file.aag01
 DEFINE l_aagacti  LIKE aag_file.aagacti
 DEFINE l_aag09    LIKE aag_file.aag09
 DEFINE l_aag03    LIKE aag_file.aag03
 DEFINE l_aag07    LIKE aag_file.aag07
 DEFINE l_aag02    LIKE aag_file.aag02
 
  LET g_errno=' '
  SELECT aag03,aag07,aag09,aagacti,aag02
    INTO l_aag03,l_aag07,l_aag09,l_aagacti,l_aag02
    FROM aag_file
   WHERE aag01=p_code
     AND aag00 = g_aza.aza81  #No.FUN-730033
  CASE WHEN STATUS=100         LET g_errno='agl-001'  #No.7926
       WHEN l_aagacti='N'      LET g_errno='9028'
        WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
        WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
        WHEN l_aag09  = 'N'      LET g_errno = 'agl-214'
       OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
  END CASE
END FUNCTION
   
FUNCTION i301_b_askkey()
DEFINE
    l_wc   LIKE type_file.chr1000#No.FUN-680061 VARCHAR(200)
 
    CONSTRUCT l_wc ON bhe01,bhe06  #螢幕上取條件
       FROM s_bhe[1].bhe01,
            s_bhe[1].bhe06
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
    CALL i301_b_fill(l_wc)
END FUNCTION
 
FUNCTION i301_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc   LIKE type_file.chr1000       #No.FUN-680061 VARCHAR(200)
 
    LET g_sql =
       "SELECT bhe01,bhe06,'' ",
       "  FROM bhe_file ",
       " WHERE bhe00= '",g_bhe00,"' ",
       "   AND ", p_wc CLIPPED ,
       "  ORDER BY bhe01"
    PREPARE i301_prepare2 FROM g_sql      #預備一下
    DECLARE bhe_cs CURSOR FOR i301_prepare2
 
    CALL g_bhe.clear()                                                          
    LET g_cnt = 1       
    FOREACH bhe_cs INTO g_bhe[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT aag02 INTO g_bhe[g_cnt].aag02 FROM aag_file
            WHERE aag01=g_bhe[g_cnt].bhe06  
              AND aag00 = g_aza.aza81  #No.FUN-730033
        IF SQLCA.sqlcode THEN LET g_bhe[g_cnt].aag02='' END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN                                               
           CALL cl_err( '', 9035, 0 )                                           
           EXIT FOREACH                                                         
        END IF           
 
    END FOREACH
    CALL g_bhe.deleteElement(g_cnt)             
 
    LET g_rec_b=g_cnt -1
END FUNCTION
 
FUNCTION i301_bp(p_ud)
DEFINE
   p_ud   LIKE type_file.chr1   #No.FUN-680061 VARCHAR(01)
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_bhe TO s_bhe.* ATTRIBUTE(COUNT=g_rec_b)                      
                                                                                
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
      ON ACTION modify                                                          
         LET g_action_choice="modify"                                           
         EXIT DISPLAY               
      ON ACTION first                                                           
         CALL i301_fetch('F')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF     
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous                                                        
         CALL i301_fetch('P')                                             
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF           
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                                                                
      ON ACTION jump                                                            
         CALL i301_fetch('/')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF                                                                                    
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                                                            
         CALL i301_fetch('N')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF    
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                                                            
         CALL i301_fetch('L')                                                   
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
   END DISPLAY                                                                  
   CALL cl_set_act_visible("accept,cancel", TRUE)                               
END FUNCTION               
 
                  
 
FUNCTION i301_out()
    DEFINE
        l_i    LIKE type_file.num5,    #No.FUN-680061 SMALLINT
        l_name LIKE type_file.chr20,   # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
        l_za05 LIKE type_file.chr1000, #NO.FUN-680061 VARCHAR(40)  
        l_chr  LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
        l_bhe  RECORD LIKE bhe_file.*
 
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 LET g_sql="SELECT * FROM bhe_file ",          # 組合出 SQL 指令
              " WHERE bhe00='",g_bhe00,"' ",
              "   AND ",g_wc CLIPPED
    PREPARE i301_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i301_co  CURSOR FOR i301_p1
 
    CALL cl_outnam('abgi301') RETURNING l_name
    START REPORT i301_rep TO l_name
 
    FOREACH i301_co INTO l_bhe.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i301_rep(l_bhe.*)
    END FOREACH
 
    FINISH REPORT i301_rep
 
    CLOSE i301_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i301_rep(sr)
    DEFINE
        l_trailer_sw   LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
        l_aag02        LIKE aag_file.aag02,
        sr RECORD LIKE bhe_file.*,
        l_chr          LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bhe00,sr.bhe01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
 
        ON EVERY ROW
           SELECT aag02 INTO l_aag02 FROM aag_file 
              WHERE aag01 = sr.bhe06
                AND aag00 = g_aza.aza81  #No.FUN-730033
           IF STATUS=100 THEN LET l_aag02='' END IF
 
           PRINT COLUMN g_c[31],sr.bhe00,
                 COLUMN g_c[32],sr.bhe01,
                 COLUMN g_c[33],sr.bhe06,
                 COLUMN g_c[34],l_aag02
 
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
FUNCTION i301_g()
    DEFINE l_row,l_col   LIKE type_file.num5   #NO.FUN-680061 SMALLINT
    DEFINE l_bhe  RECORD LIKE bhe_file.*
    DEFINE l_tm RECORD
           wc   LIKE type_file.chr1000         #NO.FUN-680061 VARCHAR(300)
            END RECORD
    DEFINE l_sql_g  LIKE type_file.chr1000,    #NO.FUN-680061 VARCHAR(600)
           l_occ01  LIKE occ_file.occ01,
           x RECORD
              bhe00 LIKE bhe_file.bhe00,
              bhe06 LIKE bhe_file.bhe06 
          END RECORD
    LET x.bhe00 = '2'          
    LET l_row = 4 LET l_col = 10
    OPEN WINDOW i301_gw AT l_row,l_col WITH FORM "abg/42f/abgi301_g"
        ATTRIBUTE(STYLE = g_win_style)  
    CALL cl_ui_locale("abgi301_g")  
 
 WHILE TRUE
    CONSTRUCT BY NAME l_tm.wc ON occ01,occ37 HELP 1
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION controlg       #TQC-860021
          CALL cl_cmdask()      #TQC-860021
 
       ON IDLE g_idle_seconds   #TQC-860021
          CALL cl_on_idle()     #TQC-860021
          CONTINUE CONSTRUCT    #TQC-860021
 
       ON ACTION about          #TQC-860021
          CALL cl_about()       #TQC-860021
 
       ON ACTION help           #TQC-860021
          CALL cl_show_help()   #TQC-860021
    END CONSTRUCT
    IF INT_FLAG THEN 
       LET INT_FLAG=0 
       CLOSE WINDOW i301_gw 
       RETURN 
    END IF
    IF l_tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
    INPUT BY NAME x.bhe00,x.bhe06 WITHOUT DEFAULTS
         AFTER FIELD bhe00
            IF cl_null(x.bhe00) THEN NEXT FIELD bhe00 END IF
            IF x.bhe00 <> '2' THEN NEXT FIELD bhe00 END IF
         AFTER FIELD bhe06
            IF NOT cl_null(x.bhe06) THEN
               CALL i301_bhe06(x.bhe06)
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0) NEXT FIELD bhe06
               END IF
            END IF
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bhe06)                                               
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_aag"                                 
                   LET g_qryparam.default1 = g_bhe[l_ac].bhe06                  
                   LET g_qryparam.arg1 = g_aza.aza81   #No.FUN-730033
                   LET g_qryparam.where = " aag07 IN ('2','3') ",             
                                          " AND aag03 IN ('2')"  
                   CALL cl_create_qry() RETURNING g_bhe[l_ac].bhe06             
                   DISPLAY BY NAME g_bhe[l_ac].bhe06  #No.FUN-730033
#                   CALL FGL_DIALOG_SETBUFFER( g_bhe[l_ac].bhe06 )               
                   NEXT FIELD bhe06                                             
             END CASE          
 
{             WHEN INFIELD(bhe06)
                CALL q_aag(10,3,x.bhe06,'23','2','')
                RETURNING x.bhe06
                NEXT FIELD bhe06
             OTHERWISE EXIT CASE
           END CASE
}
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
       LET INT_FLAG=0 
       CLOSE WINDOW i301_gw 
       RETURN
    END IF
    MESSAGE " Working ...." ATTRIBUTE(REVERSE)
    LET l_sql_g = "SELECT occ01 ",
                  "  FROM  occ_file",
                  "  WHERE occacti='Y' ",
                  "   AND ",l_tm.wc CLIPPED,
                  " ORDER BY occ01" 
    PREPARE i301_occ_pre1 FROM l_sql_g
    DECLARE occ_curs CURSOR FOR i301_occ_pre1
    FOREACH occ_curs INTO l_occ01
         LET l_bhe.bhe00=x.bhe00
         LET l_bhe.bhe01=l_occ01
         LET l_bhe.bhe06=x.bhe06
 
         #MOD-790002.................begin
         IF cl_null(l_bhe.bhe00)  THEN
            LET l_bhe.bhe00=' '
         END IF
         #MOD-790002.................end
 
         INSERT INTO bhe_file (bhe00,bhe01,bhe06)
                       VALUES (l_bhe.bhe00,l_bhe.bhe01,l_bhe.bhe06)
         IF STATUS THEN
            UPDATE bhe_file SET bhe06 = x.bhe06
               WHERE bhe00 = l_bhe.bhe00
                 AND bhe01 = l_bhe.bhe01
         END IF
    END FOREACH
    MESSAGE " Finished...." ATTRIBUTE(REVERSE)
    MESSAGE "             " ATTRIBUTE(REVERSE)
    EXIT WHILE
 END WHILE
    CLOSE WINDOW i301_gw
    LET g_bhe00=x.bhe00
    LET g_wc=' 1=1'     
    CALL i301_show()
END FUNCTION
 
#NO.MOD-590329 MARK------------------------
 #NO.MOD-580078
#FUNCTION i301_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("bhe01",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION i301_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("bhe01",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580078 --end
#NO.MOD-590329 MARK------------------------
