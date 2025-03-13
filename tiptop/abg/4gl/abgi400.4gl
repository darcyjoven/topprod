# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi400.4gl
# Descriptions...: 費用基礎金額維護作業 
# Date & Author..: 02/09/20 By nicola 
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/17 By Smapmin 報表轉XML格式
# Modify.........: NO.MOD-580078 05/08/09 BY yiting key 可更改
# Modify.........: NO.MOD-590329 05/10/03 BY yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0003 06/10/17 By jamie 1.FUNCTION i400()_q 一開始應清空g_bgk01的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 g_no_ask
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 07/12/17 By lala   報表轉為使用p_query
# Modify.........: No.TQC-920079 09/02/24 By destiny 單身資料顯示有問題，上下筆跳動時單身資料不隨單頭變化
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"  
 
#模組變數(Module Variables)
DEFINE 
   g_bgk01         LIKE bgk_file.bgk01,   #版本
   g_bgk01_t       LIKE bgk_file.bgk01,   #版本(舊值)
   g_bgk02         LIKE bgk_file.bgk02,   #部門編號                                                                                 
   g_bgk02_t       LIKE bgk_file.bgk02,   #部門編號(舊值)                                                                           
   g_bgk03         LIKE bgk_file.bgk03,   #分攤編號                                                                                 
   g_bgk03_t       LIKE bgk_file.bgk03,   #分攤編號(舊值) 
   g_bgk           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
      bgk02        LIKE bgk_file.bgk02,   #部門編號
      gem02        LIKE gem_file.gem02,   #部門名稱
      bgk03        LIKE bgk_file.bgk03,   #分攤編號
      aca02        LIKE aca_file.aca02,   #類別名稱
      bgk04        LIKE bgk_file.bgk04   #金額
                   END RECORD,
   g_bgk_t         RECORD                 #程式變數(舊值)
      bgk02        LIKE bgk_file.bgk02,   #部門編號
      gem02        LIKE gem_file.gem02,   #部門名稱
      bgk03        LIKE bgk_file.bgk03,   #分攤編號
      aca02        LIKE aca_file.aca02,   #類別名稱
      bgk04        LIKE bgk_file.bgk04    #金額
                   END RECORD,
   g_wc,g_sql,g_wc2    string,             #No.FUN-580092 HCN
   g_show          LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
   g_ss            LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
   g_rec_b         LIKE type_file.num5,    #單身筆數  #No.FUN-680061 SMALLINT
   g_flag          LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
   g_ver           LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
   l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680061 SMALLINT
DEFINE p_row,p_col    LIKE type_file.num5         #No.FUN-680061 SMALLINT
DEFINE g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL                         
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE g_cnt          LIKE type_file.num10      #No.FUN-680061 INTEGER
DEFINE g_i            LIKE type_file.num5       #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_msg          LIKE ze_file.ze03         #No.FUN-680061 VARCHAR(72) 
DEFINE g_row_count    LIKE type_file.num10      #No.FUN-680061 INTEGER
DEFINE g_curs_index   LIKE type_file.num10      #No.FUN-680061 INTEGER
DEFINE g_jump         LIKE type_file.num10      #查詢指定的筆數     #No.FUN-680061 INTEGER
DEFINE g_no_ask       LIKE type_file.num5       #是否開啟指定筆視窗 #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask 
 
MAIN
   OPTIONS                                   #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                           #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log                                          
                                                                                
    IF (NOT cl_setup("ABG")) THEN                                               
       EXIT PROGRAM                                                             
    END IF                                                                      
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
                                                                                
    OPEN WINDOW i400_w WITH FORM "abg/42f/abgi400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
                                                                                
    CALL cl_ui_init()                                                           
                                                                                
    CALL i400_menu()                                                            
                                                                                
    CLOSE WINDOW i400_w                 #結束畫面                               
    CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                           #No.FUN-6A0056
END MAIN             
 
 
#QBE 查詢資料
FUNCTION i400_cs()
    CLEAR FORM                               #清除畫面
    CALL g_bgk.clear()
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_bgk01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bgk01,bgk02,bgk03,bgk04
    FROM bgk01,s_bgk[1].bgk02,s_bgk[1].bgk03,s_bgk[1].bgk04
 
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
 
    LET g_sql= "SELECT UNIQUE bgk01 FROM bgk_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY bgk01"
    PREPARE i400_prepare FROM g_sql          #預備一下
    DECLARE i400_bcs                         #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i400_prepare
      
    LET g_sql="SELECT COUNT(DISTINCT bgk01) FROM bgk_file ",
              " WHERE ", g_wc CLIPPED
    PREPARE i400_precount FROM g_sql
    DECLARE i400_count CURSOR FOR i400_precount
  
    CALL i400_show()
END FUNCTION
 
FUNCTION i400_menu()
DEFINE l_cmd  LIKE type_file.chr1000            #No.FUN-820002 
   WHILE TRUE                                                                   
      CALL i400_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "insert"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i400_a()                                                    
            END IF                                                              
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i400_q()                                                    
            END IF                                                              
         WHEN "delete"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i400_r()                                                    
            END IF                                                              
         WHEN "reproduce"                                                       
                                                                                
            IF cl_chk_act_auth() THEN                                           
               CALL i400_copy()                                                 
            END IF       
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i400_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
         IF cl_chk_act_auth()                                                   
            THEN CALL i400_out()                                            
         END IF                                                                 
         WHEN "help"                                                            
            CALL cl_show_help()                                                    
         WHEN "exit"                                                            
            EXIT WHILE                                                          
         WHEN "controlg"                                                        
            CALL cl_cmdask()                                                    
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgk),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_bgk01 IS NOT NULL THEN
                 LET g_doc.column1 = "bgk01"
                 LET g_doc.value1 = g_bgk01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0003-------add--------end----
      END CASE                                                                  
   END WHILE                                                                    
END FUNCTION      
 
 
 
FUNCTION i400_a()
   IF s_shut(0) THEN RETURN END IF         
   MESSAGE ""
   CLEAR FORM
   LET g_bgk01    = NULL
   LET g_bgk01_t  = NULL
   CALL g_bgk.clear()
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i400_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_bgk01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_bgk01 IS NULL THEN
         CONTINUE WHILE
      END IF
      LET g_rec_b = 0                    #No.FUN-680064
      IF g_ss='N' THEN                                                        
         FOR g_cnt = 1 TO g_bgk.getLength()                                  
             INITIALIZE g_bgk[g_cnt].* TO NULL                               
         END FOR                                                             
      ELSE                                                                    
         CALL i400_b_fill(' 1=1')          #單身                             
      END IF            
 
      CALL i400_b()                      #輸入單身
      LET g_bgk01_t = g_bgk01
      LET g_wc=" bgk01='",g_bgk01,"' "
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
FUNCTION i400_i(p_cmd)
   DEFINE
      p_cmd      LIKE type_file.chr1,   #a:輸入 u:更改 #No.FUN-680061 VARCHAR(01)
      l_n        LIKE type_file.num5,   #No.FUN-680061 SMALLINT
      l_str      LIKE type_file.chr50   #NO.FUN-680061 VARCHAR(40)
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0033 
   INPUT g_bgk01 WITHOUT DEFAULTS
         FROM bgk01 
       
      AFTER FIELD bgk01
         IF cl_null(g_bgk01) THEN LET g_bgk01 = ' ' END IF
         SELECT COUNT(*) INTO g_cnt
                FROM bgk_file
                WHERE bgk01=g_bgk01
         IF g_cnt > 0 THEN
            CALL cl_err('','ams-712',0)
            NEXT FIELD bgk01
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
FUNCTION i400_q()
    LET g_row_count = 0                                                        
    LET g_curs_index = 0                                                       
    CALL cl_navigator_setting( g_curs_index, g_row_count )  
   INITIALIZE g_bgk01 TO NULL         #No.FUN-6A0003
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_bgk.clear()
 
   CALL i400_cs()                      #取得查詢條件
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_bgk01 TO NULL
      RETURN
   END IF
   OPEN i400_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bgk01 TO NULL
   ELSE
      OPEN i400_count
      FETCH i400_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i400_fetch('F')             #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i400_fetch(p_flag)
   DEFINE
      p_flag     LIKE type_file.chr1      #處理方式   #No.FUN-680061 VARCHAR(01)
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i400_bcs INTO g_bgk01
      WHEN 'P' FETCH PREVIOUS i400_bcs INTO g_bgk01
      WHEN 'F' FETCH FIRST    i400_bcs INTO g_bgk01
      WHEN 'L' FETCH LAST     i400_bcs INTO g_bgk01
      WHEN '/' 
      IF (NOT g_no_ask) THEN       #No.FUN-6A0057 g_no_ask 
         CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
         LET INT_FLAG = 0
         PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds                                           
                  CALL cl_on_idle()                                             
#                  CONTINUE PROMPT                                              
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                                                                                
            END PROMPT      
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
      END IF
         FETCH ABSOLUTE g_jump i400_bcs INTO g_bgk01
         LET g_no_ask = FALSE       #No.FUN-6A0057 g_no_ask 
   END CASE
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_bgk01,SQLCA.sqlcode,0)
      INITIALIZE g_bgk01 TO NULL  #TQC-6B0105
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
      CALL i400_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i400_show()
    
   DISPLAY g_bgk01 TO bgk01                #單頭
   CALL i400_b_fill(g_wc)                      #單身
   CALL i400_bp("D")
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i400_r()
 
   IF s_shut(0) THEN RETURN END IF
#  IF cl_null(g_wc) AND g_bgk01 IS NULL  THEN   #No.FUN-6A0003 
   IF g_bgk01 IS NULL  THEN                     #No.FUN-6A0003 
       CALL cl_err('',-400,0) 
       RETURN 
   END IF
   BEGIN WORK
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bgk01"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bgk01       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM bgk_file 
      WHERE bgk01=g_bgk01
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0) #FUN-660105
         CALL cl_err3("del","bgk_file",g_bgk01,"",SQLCA.sqlcode,"","BODY DELETE:",1) #FUN-660105  
      ELSE
         CLEAR FORM
         CALL g_bgk.clear()
         OPEN i400_count                                                           
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i400_bcs
            CLOSE i400_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i400_count INTO g_row_count   
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i400_bcs
            CLOSE i400_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--                                      
         DISPLAY g_row_count TO FORMONLY.cnt                                       
         OPEN i400_bcs                                                              
         IF g_curs_index = g_row_count + 1 THEN                                    
            LET g_jump = g_row_count                                               
            CALL i400_fetch('L')                                                   
         ELSE                                                                      
            LET g_jump = g_curs_index                                              
            LET g_no_ask = TRUE        #No.FUN-6A0057 g_no_ask                                             
            CALL i400_fetch('/')                                                   
         END IF      
      END IF
      LET g_msg=TIME
     #INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06) #FUN-980001 mark
            #VALUES ('abgi400',g_user,g_today,g_msg,g_bgk01,'delete') #FUN-980001 mark
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add
             VALUES ('abgi400',g_user,g_today,g_msg,g_bgk01,'delete',g_plant,g_legal) #FUN-980001 add
   END IF
   COMMIT WORK 
END FUNCTION
 
 
#單身
FUNCTION i400_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680061SMALLINT 
      l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680061 SMALLINT
      l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680061 VARCHAR(01)
      p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680061 VARCHAR(01)
      l_allow_insert  LIKE type_file.num5,    #可新增否          #NO.FUN-680061 VARCHAR(1)
      l_allow_delete  LIKE type_file.num5,    #可更改否 (含取消) #NO.FUN-680061 VARCHAR(1)
      l_aaz64         LIKE aaz_file.aaz64     #No.FUN-670039
 
    LET g_action_choice = ""   
 
   IF cl_null(g_wc) AND g_bgk01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
    LET g_forupd_sql =         
        "SELECT bgk02,'',bgk03,'',bgk04 FROM bgk_file ",
        "WHERE bgk01 = ? AND bgk02 = ? AND bgk03 = ? FOR UPDATE"
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i400_b_cl CURSOR FROM g_forupd_sql        
 
 
    LET l_allow_insert = cl_detail_input_auth("insert")                         
    LET l_allow_delete = cl_detail_input_auth("delete")                         
                                                                                
    INPUT ARRAY g_bgk WITHOUT DEFAULTS FROM s_bgk.*                             
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
               LET g_bgk_t.* = g_bgk[l_ac].*  #BACKUP
#NO.NO.MOD-590329 MARK-------------------
 #No.MOD-580078 --start
#               LET g_before_input_done = FALSE
#               CALL i601_set_entry_b(p_cmd)
#               CALL i601_set_no_entry_b(p_cmd)
#               LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.NO.MOD-590329 MARK--------------------
               OPEN i400_b_cl USING g_bgk01,g_bgk_t.bgk02,g_bgk_t.bgk03
                    IF STATUS THEN                                                   
                       CALL cl_err("OPEN i400_b_cl:", STATUS, 1)                     
                       LET l_lock_sw = "Y"                                           
                    ELSE   
                       IF SQLCA.sqlcode THEN
                          CALL cl_err(g_bgk01_t,SQLCA.sqlcode,1)
                          LET l_lock_sw = "Y"
                       ELSE
                          LET g_bgk_t.*=g_bgk[l_ac].*
                       END IF
                       FETCH i400_b_cl INTO g_bgk[l_ac].* 
                    END IF
                SELECT gem02 into g_bgk[l_ac].gem02 FROM gem_file    #取科目名稱
                   WHERE gem01=g_bgk[l_ac].bgk02
            IF g_bgk[l_ac].bgk02 = 'ALL' THEN
               LET g_bgk[l_ac].gem02 = 'ALL'
            END IF
            SELECT aca02 into g_bgk[l_ac].aca02 FROM aca_file
                   WHERE aca01 = g_bgk[l_ac].bgk03
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_bgk[l_ac].* TO NULL
         LET g_bgk[l_ac].bgk04=0
         LET g_bgk_t.* = g_bgk[l_ac].*               #新輸入資料
#NO.NO.MOD-590329 MARK----------------
 #No.MOD-580078 --start
#         LET g_before_input_done = FAL0SE
#         CALL i601_set_entry_b(p_cmd)
#         CALL i601_set_no_entry_b(p_cmd)
#         LET g_before_input_done = TRUE
 #No.MOD-580078 --end
#NO.NO.MOD-590329 MARK----------------
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD bgk02
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               CANCEL INSERT                                                    
            END IF                                                              
                  INSERT INTO bgk_file(bgk01,bgk02,bgk03,bgk04)                 
                         VALUES(g_bgk01,g_bgk[l_ac].bgk02,                      
                                g_bgk[l_ac].bgk03,g_bgk[l_ac].bgk04)            
                  IF SQLCA.sqlcode THEN                                         
#                    CALL cl_err(g_bgk[l_ac].bgk02,SQLCA.sqlcode,0) #FUN-660105
                     CALL cl_err3("ins","bgk_file",g_bgk01,g_bgk[l_ac].bgk02,SQLCA.sqlcode,"","",1) #FUN-660105              
                     CANCEL INSERT
                  ELSE                                                          
                     MESSAGE 'INSERT O.K'                                       
                     COMMIT WORK
                     LET g_rec_b=g_rec_b+1                                            
                  END IF                
 
 
 
      AFTER FIELD bgk02                    #部門編號
         IF NOT cl_null(g_bgk[l_ac].bgk02) THEN
            CALL i400_bgk02('a',g_bgk[l_ac].bgk02)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD bgk02
            END IF
            IF g_bgk[l_ac].bgk02 = 'ALL' THEN
               SELECT COUNT(*) INTO g_cnt       #檢查是否有all 也許g_cnt會錯
                 FROM bgk_file
                WHERE bgk01 = g_bgk01
                  AND bgk02 != 'ALL'
               IF g_cnt > 0 THEN
                  CALL cl_err('','abg-016',0)
                  NEXT FIELD bgk02
               END IF
            END IF
         END IF
 
      AFTER FIELD bgk03                    #分攤類別
            IF NOT cl_null(g_bgk[l_ac].bgk03) THEN
               CALL i400_bgk03('a',g_bgk[l_ac].bgk03)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD bgk03
               END IF 
               IF g_bgk[l_ac].bgk03 != g_bgk_t.bgk03 OR
                  g_bgk[l_ac].bgk02 != g_bgk_t.bgk02 OR
                  g_bgk_t.bgk03 IS NULL OR
                  g_bgk_t.bgk02 IS NULL THEN
                  SELECT COUNT(*) INTO g_cnt FROM bgk_file
                    WHERE bgk01 = g_bgk01
                      AND bgk02 = g_bgk[l_ac].bgk02
                      AND bgk03 = g_bgk[l_ac].bgk03
                  IF g_cnt > 0 THEN         #索引值重覆
                     CALL cl_err(g_bgk[l_ac].bgk03,-239,0)
                     NEXT FIELD bgk03
                  END IF
                  SELECT COUNT(*) INTO g_cnt  
                    FROM bgk_file
                    WHERE bgk01=g_bgk01 AND bgk02 = 'ALL'
                  IF g_cnt > 0 THEN
                     CALL cl_err('','abg-014',0)
                     NEXT FIELD bgk02
                  END IF
               END IF
            END IF
 
      AFTER FIELD bgk04
         IF g_bgk[l_ac].bgk04 < 0 THEN
            NEXT FIELD bgk04
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_bgk_t.bgk02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN                                         
               CALL cl_err("", -263, 1)                                     
               CANCEL DELETE                                                
            END IF       
            DELETE FROM bgk_file
                   WHERE bgk01 = g_bgk01 
                     AND bgk02 = g_bgk_t.bgk02
                     AND bgk03 = g_bgk_t.bgk03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bgk_t.bgk02,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("del","bgk_file",g_bgk01,g_bgk_t.bgk02,SQLCA.sqlcode,"","",1) #FUN-660105
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
               LET g_bgk[l_ac].* = g_bgk_t.*                                    
               CLOSE i400_b_cl                                                  
                                                                                
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            IF l_lock_sw = 'Y' THEN                                             
               CALL cl_err(g_bgk[l_ac].bgk02,-263,1)                            
               LET g_bgk[l_ac].* = g_bgk_t.*                                    
            ELSE     
                  UPDATE bgk_file SET bgk02=g_bgk[l_ac].bgk02,                  
                                      bgk03=g_bgk[l_ac].bgk03,                  
                                      bgk04=g_bgk[l_ac].bgk04                   
                         WHERE CURRENT OF i400_b_cl  #要查一下                  
                                                                                
                  IF SQLCA.sqlcode THEN                                         
#                    CALL cl_err(g_bgk[l_ac].bgk02,SQLCA.sqlcode,0) #FUN-660105
                     CALL cl_err3("upd","bgk_file",g_bgk[l_ac].bgk02,g_bgk[l_ac].bgk03,SQLCA.sqlcode,"","",1) #FUN-660105            
                     LET g_bgk[l_ac].* = g_bgk_t.*                              
                  ELSE                                                          
                     MESSAGE 'UPDATE O.K'                                       
                     COMMIT WORK 
                  END IF    
            END IF
                   
 
      AFTER ROW
            LET l_ac = ARR_CURR()                                               
           #LET l_ac_t = l_ac        #FUN-D30032 mark                                           
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN                                              
                  LET g_bgk[l_ac].* = g_bgk_t.*                                 
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgk.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF                                                           
               CLOSE i400_b_cl                                                  
                                                                                
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                   
            LET l_ac_t = l_ac        #FUN-D30032 add                           
            CLOSE i400_b_cl                                                     
                                                                                
            COMMIT WORK      
 
 
      ON ACTION CONTROLP
         CASE
              WHEN INFIELD(bgk02)                                       
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_gem"                                 
                   LET g_qryparam.default1 = g_bgk[l_ac].bgk02                  
                   CALL cl_create_qry() RETURNING g_bgk[l_ac].bgk02             
#                   CALL FGL_DIALOG_SETBUFFER( g_bgk[l_ac].bgk02 )               
                   NEXT FIELD bgk02
              WHEN INFIELD(bgk03)                                               
                   CALL cl_init_qry_var()                                       
                   LET g_qryparam.form ="q_aca"                                 
                   LET g_qryparam.default1 = g_bgk[l_ac].bgk03                 
                   CALL cl_create_qry() RETURNING g_bgk[l_ac].bgk03             
#                   CALL FGL_DIALOG_SETBUFFER( g_bgk[l_ac].bgk03 )               
                   NEXT FIELD bgk03      
         END CASE
 
 
      ON ACTION CONTROLN
         CALL i400_b_askkey()
         EXIT INPUT
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(bgk02) AND l_ac > 1 THEN
            LET g_bgk[l_ac].* = g_bgk[l_ac-1].*
            LET g_bgk[l_ac].bgk02=NULL
            NEXT FIELD bgk02
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
 
FUNCTION i400_bgk02(p_cmd,p_key)  #部門編號
    DEFINE p_cmd     LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bgk_file.bgk02,
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = " "
    SELECT gem02,gemacti INTO g_bgk[l_ac].gem02,l_gemacti
      FROM gem_file WHERE gem01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET l_gem02 = ' '
         WHEN l_gemacti='N'        LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_key = 'ALL' THEN 
       LET g_errno = ' ' LET g_bgk[l_ac].gem02 = 'ALL'
    END IF
END FUNCTION
 
FUNCTION i400_bgk03(p_cmd,p_key)  #分攤類別
    DEFINE p_cmd     LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bgk_file.bgk02,
           l_aca02   LIKE aca_file.aca02,
           l_acaacti LIKE aca_file.acaacti
 
    LET g_errno = " "
    SELECT aca02,acaacti INTO g_bgk[l_ac].aca02,l_acaacti
      FROM aca_file WHERE aca01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-084'
                                   LET l_aca02 = ' '
         WHEN l_acaacti='N'        LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i400_b_askkey()
   DEFINE
      l_wc            LIKE type_file.chr1000       #No.FUN-680061 VARCHAR(200)
 
   CONSTRUCT l_wc ON bgk02,bgk03,bgk04                      #螢幕上取條件
             FROM s_bgk[1].bgk02,s_bgk[1].bgk03,s_bgk[1].bgk04
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
   CALL i400_b_fill(l_wc)
END FUNCTION
 
FUNCTION i400_b_fill(p_wc)                     #BODY FILL UP
   DEFINE
      p_wc            LIKE type_file.chr1000        #No.FUN-680061 VARCHAR(200)
 
   LET g_sql =
       "SELECT bgk02,'',bgk03,'',bgk04 ",
       "  FROM bgk_file ",
       " WHERE bgk01 = '",g_bgk01,"'",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY bgk02"
   PREPARE i400_prepare2 FROM g_sql       #預備一下
   DECLARE bgk_cs CURSOR FOR i400_prepare2
 
    CALL g_bgk.clear()        
 
   LET g_cnt = 1
 
   FOREACH bgk_cs INTO g_bgk[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT gem02 into g_bgk[g_cnt].gem02 FROM gem_file    #取科目名稱
             WHERE gem01=g_bgk[g_cnt].bgk02
      IF g_bgk[g_cnt].bgk02 = 'ALL' THEN
         LET g_bgk[g_cnt].gem02 = 'ALL'
      END IF
      SELECT aca02 into g_bgk[g_cnt].aca02 FROM aca_file
             WHERE aca01 = g_bgk[g_cnt].bgk03 
 
      LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN                                               
           CALL cl_err( '', 9035, 0 )                                           
           EXIT FOREACH                                                         
        END IF      
 
   END FOREACH
 
   CALL g_bgk.deleteElement(g_cnt)       
   LET g_rec_b=g_cnt-1
     
END FUNCTION
 
FUNCTION i400_bp(p_ud)
   DEFINE p_ud            LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   #DISPLAY ARRAY g_bgk TO s_bgk.* ATTRIBUTE(COUNT=g_rec_b)              #No.TQC-920079                  
   DISPLAY ARRAY g_bgk TO s_bgk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)    #No.TQC-920079                   
                                                                                
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
      ON ACTION reproduce                                                       
                                                                                
         LET g_action_choice="reproduce"                                        
                                                                                
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION first                                                           
         CALL i400_fetch('F')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF        
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous                                                        
         CALL i400_fetch('P')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF        
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                                                                
      ON ACTION jump                                                            
         CALL i400_fetch('/')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF        
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                                                                
      ON ACTION next                                                            
         CALL i400_fetch('N')                                 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  ######add in 040505                       
           END IF                          
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                                                                                
      ON ACTION last                                                            
         CALL i400_fetch('L')                                                  
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
 
              
 
FUNCTION i400_copy()
   DEFINE
      old_ver   LIKE bgm_file.bgm01,     #原版本 #No.FUN-680061 VARCHAR(10)
      new_ver   LIKE bgm_file.bgm01,     #新版本 #No.FUN-680061 VARCHAR(10)  
      l_i       LIKE type_file.num10,    #拷貝筆數  #No.FUN-680061 INTEGER
      l_bgk     RECORD  LIKE bgk_file.*  #複製用buffer
 
   LET old_ver = g_bgk01 
   LET new_ver = NULL
 
   IF cl_null(g_wc) AND g_bgk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INPUT new_ver WITHOUT DEFAULTS FROM bgk01
     AFTER FIELD bgk01
        IF cl_null(new_ver) THEN LET new_ver = ' '  END IF
        SELECT COUNT(*) INTO g_cnt FROM bgk_file
         WHERE bgk01=new_ver
        IF g_cnt > 0 THEN 
           CALL cl_err(new_ver,-239,0)
           NEXT FIELD bgk01
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
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   BEGIN WORK
   LET g_success='Y'
   DECLARE i400_c CURSOR FOR
      SELECT *
         FROM bgk_file
         WHERE bgk01 = old_ver
   LET l_i = 0
   FOREACH i400_c INTO l_bgk.*
      LET l_i = l_i+1
      LET l_bgk.bgk01 = new_ver
      INSERT INTO bgk_file VALUES(l_bgk.*)
      IF STATUS THEN
#        CALL cl_err('ins bgk:',STATUS,1) #FUN-660105
         CALL cl_err3("ins","bgk_file",l_bgk.bgk01,l_bgk.bgk02,STATUS,"","ins bgk:",1) #FUN-660105
         LET g_success='N'
      END IF
   END FOREACH
   IF g_success='Y' THEN
      COMMIT WORK
      #FUN-C30027---begin
      LET g_bgk01=new_ver
      LET g_wc = '1=1'
      CALL i400_show()          
      #FUN-C30027---end   
      MESSAGE l_i, ' rows copied!'
   ELSE
      ROLLBACK WORK
      MESSAGE 'rollback work!'
      #FUN-C30027---begin
      LET g_bgk01=old_ver
      LET g_wc=' 1=1'
      CALL i400_show()
      #FUN-C30027---end
   END IF
   #FUN-C30027---begin
   #LET g_bgk01=old_ver
   #LET g_wc=' 1=1'
   #CALL i400_show()
   #FUN-C30027---end
END FUNCTION
 
#No.FUN-820002--start--
FUNCTION i400_out()
DEFINE l_cmd  LIKE type_file.chr1000 
#   DEFINE
#      l_i    LIKE type_file.num5,     #No.FUN-680061 SMALLINT
#      l_name LIKE type_file.chr20,    # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
#      l_za05 LIKE type_file.chr1000,  #NO.FUN-680061 VARCHAR(40)  
#      sr RECORD
#         bgk01      LIKE bgk_file.bgk01,
#         bgk02      LIKE bgk_file.bgk02,
#         gem02      LIKE gem_file.gem02,
#         bgk03      LIKE bgk_file.bgk03,
#         aca02      LIKE aca_file.aca02,
#         bgk04      LIKE bgk_file.bgk04
#      END RECORD
    IF cl_null(g_wc) AND NOT cl_null(g_bgk01) AND NOT cl_null(g_bgk02) AND NOT cl_null(g_bgk03) THEN                                
       LET g_wc = " bgk01 = '",g_bgk01,"' AND bgk02 = '",g_bgk02,"' AND bgk03 = '",g_bgk03,"'"                                      
    END IF                                                                                                                          
    IF g_wc IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF                                                                                                                          
    LET l_cmd = 'p_query "abgi400" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)
#   IF cl_null(g_wc) AND g_bgk01 IS NULL  THEN 
#       CALL cl_err('',-400,0) 
#       RETURN 
#   END IF
#   CALL cl_wait()
#   CALL cl_outnam('abgi400') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#LET g_sql="SELECT bgk01,bgk02,'',bgk03,'',bgk04 FROM bgk_file ",   # 組合出 SQL 指令
#             " WHERE ",g_wc CLIPPED ,
#             " ORDER BY bgk01,bgk02 "
#   PREPARE i400_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i400_co CURSOR FOR i400_p1
 
#   START REPORT i400_rep TO l_name
 
#   FOREACH i400_co INTO sr.*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#      SELECT gem02 into sr.gem02 FROM gem_file    #取科目名稱
#             WHERE gem01=sr.bgk02
#      IF sr.bgk02 = 'ALL' THEN
#         LET sr.gem02 = 'ALL' 
#      END IF
#      SELECT aca02 into sr.aca02 FROM aca_file
#                      WHERE aca01 = sr.bgk03 
 
#      OUTPUT TO REPORT i400_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i400_rep
 
#   CLOSE i400_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i400_rep(sr)
#   DEFINE
#      l_trailer_sw  LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(1),
#      sr RECORD
#         bgk01      LIKE bgk_file.bgk01,
#         bgk02      LIKE bgk_file.bgk02,
#         gem02      LIKE gem_file.gem02,
#         bgk03      LIKE bgk_file.bgk03,
#         aca02      LIKE aca_file.aca02,
#         bgk04      LIKE bgk_file.bgk04
#      END RECORD
 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.bgk01,sr.bgk02
 
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED, pageno_total
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#         PRINT g_dash1
#         LET l_trailer_sw = 'y'
   
#      BEFORE GROUP OF sr.bgk01
#         PRINT COLUMN g_c[31],sr.bgk01 CLIPPED;
 
#      ON EVERY ROW
#         PRINT COLUMN g_c[32],sr.bgk02 CLIPPED,
#               COLUMN g_c[33],sr.gem02 CLIPPED,
#               COLUMN g_c[34],sr.bgk03 CLIPPED,
#               COLUMN g_c[35],sr.aca02 CLIPPED,
#               COLUMN g_c[36],cl_numfor(sr.bgk04,36,g_azi04)
 
#      ON LAST ROW
#         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#            PRINT g_dash[1,g_len]
#         END IF
#         PRINT g_dash[1,g_len]
#         LET l_trailer_sw = 'n'
#         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#      PAGE TRAILER
#         IF l_trailer_sw = 'y' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINE
#         END IF
#END REPORT
#No.FUN-820002--end--
 
#NO.NO.MOD-590329 MARK------------------------------
 #NO.MOD-580078
#FUNCTION i601_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("bgk02,bgk03",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION i601_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("bgk02,bgk03",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580078 --end
#NO.NO.MOD-590329 MARK
