# Prog. Version..: '5.25.13-13.04.12(00000)'     #
#
# Pattern name...: ghri035.4gl
# Descriptions...: 考勤机型号规格
# Date & Author..: 13/05/13 By lifang

IMPORT os                                                #模組匯入 匯入os package
DATABASE ds                                              #建立與資料庫的連線
 
GLOBALS "../../config/top.global"                        #存放的為TIPTOP GP系統整體全域變數定義
 
DEFINE g_hrbu                 RECORD LIKE hrbu_file.*
DEFINE g_hrbu_t               RECORD LIKE hrbu_file.*      #備份舊值
DEFINE g_hrbu01_t             LIKE hrbu_file.hrbu01         #Key值備份
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680102
DEFINE g_sql                 STRING                      #組 sql 用 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_chr                 LIKE hrbu_file.hrbuacti
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗 

MAIN

    OPTIONS
#       FIELD ORDER FORM,                      #依照FORM上面的順序定義做欄位跳動 (預設為依指令順序)
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔
 
   IF (NOT cl_setup("GHR")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   INITIALIZE g_hrbu.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM hrbu_file WHERE hrbu01 = ? FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i035_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i035_w WITH FORM "ghr/42f/ghri035"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊


   LET g_action_choice = ""
   CALL i035_menu()                                         #進入選單 Menu

   CLOSE WINDOW i035_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN
 


FUNCTION i035_curs()

    CLEAR FORM
    INITIALIZE g_hrbu.* TO NULL   
    CONSTRUCT BY NAME g_wc ON                               #螢幕上取條件
        hrbu01,hrbu02,hrbu03,hrbu04,hrbu05,hrbu06,hrbu07,hrbu08,hrbu09,hrbu10,
        hrbu11,hrbu12,hrbu13,hrbu14,hrbu15,hrbu16,hrbu17,hrbu18,hrbu19,hrbu20,
        hrbu21,hrbu22,hrbu23,hrbu24,hrbu25,hrbu26,hrbu27,hrbu28,hrbu29,hrbu30,
        hrbu31,hrbu32,hrbu33,  
        hrbuuser,hrbugrup,hrbumodu,hrbudate,hrbuacti

        BEFORE CONSTRUCT                                    #預設查詢條件
           CALL cl_qbe_init()                               #讀回使用者存檔的預設條件
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(hrbu01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbu01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbu.hrbu01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbu01
                 NEXT FIELD hrbu01
 
              OTHERWISE
                 EXIT CASE
           END CASE
 
      ON IDLE g_idle_seconds                                #Idle控管（每一交談指令皆要加入）
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about                                       #程式資訊（每一交談指令皆要加入）
         CALL cl_about()  
 
      ON ACTION help                                        #程式說明（每一交談指令皆要加入）
         CALL cl_show_help()  
 
      ON ACTION controlg                                    #開啟其他作業（每一交談指令皆要加入）
         CALL cl_cmdask()  
 
      ON ACTION qbe_select                                  #選擇儲存的查詢條件
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #儲存畫面上欄位條件
         CALL cl_qbe_save()
    END CONSTRUCT
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbuuser', 'hrbugrup')  #整合權限過濾設定資料
                                                                     #若本table無此欄位

    LET g_sql = "SELECT hrbu01 FROM hrbu_file ",                       #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY hrbu01"
    PREPARE i035_prepare FROM g_sql
    DECLARE i035_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i035_prepare

    LET g_sql = "SELECT COUNT(*) FROM hrbu_file WHERE ",g_wc CLIPPED
    PREPARE i035_precount FROM g_sql
    DECLARE i035_count CURSOR FOR i035_precount
END FUNCTION
 

FUNCTION i035_menu()
    DEFINE l_cmd    STRING 

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i035_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i035_q()
            END IF

        ON ACTION next
            CALL i035_fetch('N')

        ON ACTION previous
            CALL i035_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i035_u()
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i035_x()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i035_r()
            END IF

       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i035_copy()
            END IF

     #  ON ACTION output
     #       LET g_action_choice="output"
     #       IF cl_chk_act_auth() THEN 
     #          IF cl_null(g_wc) THEN LET g_wc='1=1' END IF
     #          LET l_cmd = 'p_query "ghri035" "',g_wc CLIPPED,'"'
     #          CALL cl_cmdrun(l_cmd)                             
     #       END IF
 
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i035_fetch('/')

        ON ACTION first
            CALL i035_fetch('F')

        ON ACTION last
            CALL i035_fetch('L')

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about      
           CALL cl_about() 
 
        ON ACTION close 
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
       # ON ACTION related_document
       #    LET g_action_choice="related_document"
       #    IF cl_chk_act_auth() THEN
       #       IF g_hrbu.hrbu01 IS NOT NULL THEN
       #          LET g_doc.column1 = "hrbu01"
       #          LET g_doc.value1 = g_hrbu.hrbu01
       #          CALL cl_doc()
       #       END IF
       #    END IF
       
       ON ACTION ghri035_a
            LET g_action_choice="ghri035_a"
            IF cl_chk_act_auth() THEN
                 CALL i035_explain()
            END IF
            
    END MENU
    CLOSE i035_cs
END FUNCTION
 
 
FUNCTION i035_a()

    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_hrbu.* LIKE hrbu_file.*
    LET g_hrbu01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrbu.hrbuuser = g_user
        LET g_hrbu.hrbuoriu = g_user 
        LET g_hrbu.hrbuorig = g_grup 
        LET g_hrbu.hrbugrup = g_grup               #使用者所屬群
        LET g_hrbu.hrbudate = g_today
        LET g_hrbu.hrbuacti = 'Y'
#        LET g_hrbu.hrbu03 = '1'
#        LET g_hrbu.hrbu04 = '1'
#        LET g_hrbu.hrbu05 = '1'
#        LET g_hrbu.hrbu06 = '1'
#        LET g_hrbu.hrbu07 = '1'
#        LET g_hrbu.hrbu08 = '1'
#        LET g_hrbu.hrbu09 = '1'
#        LET g_hrbu.hrbu10 = '1'
#        LET g_hrbu.hrbu11 = '1'
#        LET g_hrbu.hrbu12 = '1'
#        LET g_hrbu.hrbu13 = '1'
#        LET g_hrbu.hrbu14 = '1'
#        LET g_hrbu.hrbu15 = '1'
#        LET g_hrbu.hrbu16 = '1'
#        LET g_hrbu.hrbu17 = '1'
#        LET g_hrbu.hrbu18 = '-1'
#        LET g_hrbu.hrbu19 = '-1'
#        LET g_hrbu.hrbu20 = '-1'
#        LET g_hrbu.hrbu21 = '-1' 
       
        
        CALL i035_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_hrbu.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrbu.hrbu01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO hrbu_file VALUES(g_hrbu.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrbu_file",g_hrbu.hrbu01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrbu01 INTO g_hrbu.hrbu01 FROM hrbu_file WHERE hrbu01 = g_hrbu.hrbu01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION


 
FUNCTION i035_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1 
   DEFINE l_input       LIKE type_file.chr1 
   DEFINE l_n           LIKE type_file.num5 
   DEFINE l_j           LIKE type_file.num5
   DEFINE l_i           LIKE type_file.num5
   DEFINE l_return      LIKE type_file.num5
 
   LET l_i=3
   LET l_return = 0
   DISPLAY BY NAME
        g_hrbu.hrbu01,g_hrbu.hrbu02,g_hrbu.hrbu23,g_hrbu.hrbu03,g_hrbu.hrbu04,g_hrbu.hrbu05,
        g_hrbu.hrbu06,g_hrbu.hrbu07,g_hrbu.hrbu08,g_hrbu.hrbu09,g_hrbu.hrbu10,
        g_hrbu.hrbu11,g_hrbu.hrbu12,g_hrbu.hrbu13,g_hrbu.hrbu14,g_hrbu.hrbu15,
        g_hrbu.hrbu16,g_hrbu.hrbu17,g_hrbu.hrbu18,g_hrbu.hrbu19,g_hrbu.hrbu20,
        g_hrbu.hrbu21,g_hrbu.hrbu22,g_hrbu.hrbu24,g_hrbu.hrbu25,g_hrbu.hrbu26,
        g_hrbu.hrbu27,g_hrbu.hrbu28,g_hrbu.hrbu31,g_hrbu.hrbu32,g_hrbu.hrbu33,g_hrbu.hrbu29,g_hrbu.hrbu30,    
        g_hrbu.hrbuuser,g_hrbu.hrbugrup,g_hrbu.hrbumodu,g_hrbu.hrbudate,g_hrbu.hrbuacti
 
   INPUT BY NAME
        g_hrbu.hrbu01,g_hrbu.hrbu02,g_hrbu.hrbu23,g_hrbu.hrbu30,g_hrbu.hrbu04,g_hrbu.hrbu05,
        g_hrbu.hrbu06,g_hrbu.hrbu07,g_hrbu.hrbu08,g_hrbu.hrbu09,g_hrbu.hrbu10,
        g_hrbu.hrbu11,g_hrbu.hrbu12,g_hrbu.hrbu13,g_hrbu.hrbu14,g_hrbu.hrbu15,
        g_hrbu.hrbu16,g_hrbu.hrbu17,
        g_hrbu.hrbu18,g_hrbu.hrbu19,g_hrbu.hrbu20,
        g_hrbu.hrbu21,g_hrbu.hrbu03,
        g_hrbu.hrbu24,g_hrbu.hrbu25,g_hrbu.hrbu26,
        g_hrbu.hrbu27,g_hrbu.hrbu28,g_hrbu.hrbu31,g_hrbu.hrbu32,g_hrbu.hrbu33,g_hrbu.hrbu29,g_hrbu.hrbu22,  
        g_hrbu.hrbuuser,g_hrbu.hrbugrup,g_hrbu.hrbumodu,g_hrbu.hrbudate,g_hrbu.hrbuacti


     WITHOUT DEFAULTS
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i035_set_entry(p_cmd)
          CALL i035_set_no_entry(p_cmd)
          CALL i035_set_required()
          LET g_before_input_done = TRUE
 
      AFTER FIELD hrbu01
         IF g_hrbu.hrbu01 IS NOT NULL THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND g_hrbu.hrbu01 != g_hrbu01_t) THEN # 若輸入或更改且改KEY
               SELECT count(*) INTO l_n FROM hrbu_file WHERE hrbu01 = g_hrbu.hrbu01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_hrbu.hrbu01,-239,1)
                  LET g_hrbu.hrbu01 = g_hrbu01_t
                  DISPLAY BY NAME g_hrbu.hrbu01
                  NEXT FIELD hrbu01
               END IF
            END IF
         END IF
      ON CHANGE hrbu23
         IF g_hrbu.hrbu23 IS NOT NULL THEN
         	 IF g_hrbu.hrbu23='1' THEN 
         	 	CALL cl_set_comp_entry("hrbu24,hrbu25,hrbu26,hrbu27,hrbu28,hrbu29,hrbu30,hrbu31,hrbu32,hrbu33",FALSE)
         	 	CALL cl_set_comp_entry("hrbu03,hrbu04,hrbu05,hrbu06,hrbu07,hrbu08,hrbu09,hrbu10,
                      hrbu11,hrbu12,hrbu13,hrbu14,hrbu15,hrbu16,hrbu17,hrbu18,hrbu19,hrbu20,
                      hrbu21",TRUE)
         	 ELSE 
         	 	CALL cl_set_comp_entry("hrbu03,hrbu04,hrbu05,hrbu06,hrbu07,hrbu08,hrbu09,hrbu10,
                      hrbu11,hrbu12,hrbu13,hrbu14,hrbu15,hrbu16,hrbu17,hrbu18,hrbu19,hrbu20,
                      hrbu21",FALSE)
            CALL cl_set_comp_entry("hrbu24,hrbu25,hrbu26,hrbu27,hrbu28,hrbu29,hrbu30,hrbu31,hrbu32,hrbu33",TRUE)
            
         	 END IF 
         END IF 
      ON CHANGE hrbu30
         IF g_hrbu.hrbu30 IS NOT NULL THEN
          IF g_hrbu.hrbu30='1' THEN 
          	CALL cl_set_comp_entry("hrbu27,hrbu28",FALSE)
         	 	CALL cl_set_comp_entry("hrbu26",TRUE)
         	 	LET g_hrbu.hrbu27=NULL
         	 	LET g_hrbu.hrbu28=NULL
         	 	DISPLAY BY NAME g_hrbu.hrbu27
         	 	DISPLAY BY NAME g_hrbu.hrbu28
           ELSE 
           	CALL cl_set_comp_entry("hrbu26",FALSE)
         	 	CALL cl_set_comp_entry("hrbu27,hrbu28",TRUE)
         	 	LET g_hrbu.hrbu26=NULL
         	 	DISPLAY BY NAME g_hrbu.hrbu26
          END IF 
         END IF 
    
     {    
         AFTER FIELD hrbu03
         IF g_hrbu.hrbu03 IS NOT NULL THEN 
         	 LET l_j = 3           
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
             NEXT FIELD hrbu03            	
           END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu03
         END IF
         
         AFTER FIELD hrbu04
         IF g_hrbu.hrbu04 IS NOT NULL THEN 
         	 LET l_j = 4          
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
             NEXT FIELD hrbu04            	
           END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu04
         END IF
         
         AFTER FIELD hrbu05
         IF g_hrbu.hrbu05 IS NOT NULL THEN 
         	 LET l_j = 5           
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
            	NEXT FIELD hrbu05            	
           END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu05  
         END IF
         
         AFTER FIELD hrbu06
         IF g_hrbu.hrbu06 IS NOT NULL THEN 
         	 LET l_j = 6           
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
            	NEXT FIELD hrbu06            	
           END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu06
         END IF         
         
         AFTER FIELD hrbu07
         IF g_hrbu.hrbu07 IS NOT NULL THEN
         	 LET l_j = 7            
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
            	NEXT FIELD hrbu07            	
           END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu07  
         END IF         
         
         AFTER FIELD hrbu08        
         IF g_hrbu.hrbu08 IS NOT NULL THEN  
         	 LET l_j = 8          
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
            	NEXT FIELD hrbu08            	
           END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu08
         END IF
         
         AFTER FIELD hrbu09        
         IF g_hrbu.hrbu09 IS NOT NULL THEN 
         	    LET l_j = 9           
            	CALL i035_judge(l_j) RETURNING l_return
            	IF l_return THEN 
            	  NEXT FIELD hrbu09            	
              END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu09
         END IF
         
         AFTER FIELD hrbu10        
         IF g_hrbu.hrbu10 IS NOT NULL THEN 
         	 LET l_j = 10           
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
             NEXT FIELD hrbu10            	
           END IF
         ELSE
             CALL cl_err('','asm-609',0) 
             NEXT FIELD hrbu10
         END IF
         
         AFTER FIELD hrbu11         
         IF g_hrbu.hrbu11 IS NOT NULL THEN 
         	    LET l_j = 11           
            	CALL i035_judge(l_j) RETURNING l_return
            	IF l_return THEN 
            	  NEXT FIELD hrbu11            	
              END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu11     
         END IF
         
         AFTER FIELD hrbu12         
         IF g_hrbu.hrbu12 IS NOT NULL THEN
         	 LET l_j = 12            
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
            	NEXT FIELD hrbu12            	
           END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu12
         END IF
         
         AFTER FIELD hrbu13        
         IF g_hrbu.hrbu13 IS NOT NULL THEN 
         	 LET l_j = 13           
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
            	NEXT FIELD hrbu13            	
           END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu13
         END IF
         
         AFTER FIELD hrbu14         
         IF g_hrbu.hrbu14 IS NOT NULL THEN  
         	 LET l_j = 14          
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
            	NEXT FIELD hrbu14            	
           END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu14
         END IF
         
         AFTER FIELD hrbu15         
         IF g_hrbu.hrbu15 IS NOT NULL THEN  
         	 LET l_j = 15          
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
            	NEXT FIELD hrbu15            	
           END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu15
         END IF
         
         AFTER FIELD hrbu16        
         IF g_hrbu.hrbu16 IS NOT NULL THEN
         	 LET l_j = 16            
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
            	NEXT FIELD hrbu16            	
            END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu16
         END IF
         
         AFTER FIELD hrbu17         
         IF g_hrbu.hrbu17 IS NOT NULL THEN
         	 LET l_j = 17            
           CALL i035_judge(l_j) RETURNING l_return
           IF l_return THEN 
            	NEXT FIELD hrbu17            	
           END IF
         ELSE 
             CALL cl_err('','asm-609',0)
             NEXT FIELD hrbu17
         END IF
 }        
         BEFORE FIELD hrbu18
           CALL i035_set_required()
  {         
         AFTER FIELD hrbu18         
         IF g_hrbu.hrbu18 IS NOT NULL THEN 
         	 IF g_hrbu.hrbu18 <> -1 THEN  
         	 	 LET l_j = 18        
             CALL i035_judge(l_j) RETURNING l_return
             IF l_return THEN 
            	  NEXT FIELD hrbu18            	
             END IF
           END IF 
         ELSE 
            LET g_hrbu.hrbu18 = -1
         END IF
   }    
         BEFORE FIELD hrbu19
           CALL i035_set_required()
    {       
         AFTER FIELD hrbu19         
         IF g_hrbu.hrbu19 IS NOT NULL THEN 
         	 IF g_hrbu.hrbu19 <> -1 THEN  
         	 	 LET l_j = 19        
             CALL i035_judge(l_j) RETURNING l_return
             IF l_return THEN 
            	  NEXT FIELD hrbu19            	
             END IF
           END IF 
         ELSE 
           LET g_hrbu.hrbu19 = -1
         END IF
     }    
         BEFORE FIELD hrbu20
            CALL i035_set_required()
      {   AFTER FIELD hrbu20         
         IF g_hrbu.hrbu20 IS NOT NULL THEN 
         	 IF g_hrbu.hrbu20 <> -1 THEN   
         	 	 LET l_j = 20       
             CALL i035_judge(l_j) RETURNING l_return
             IF l_return THEN 
            	  NEXT FIELD hrbu20            	
             END IF
           END IF 
         ELSE 
           LET g_hrbu.hrbu20 = -1
         END IF
       }  
         BEFORE FIELD hrbu21
           CALL i035_set_required()
        {   
         AFTER FIELD hrbu21         
         IF g_hrbu.hrbu21 IS NOT NULL THEN 
         	 IF g_hrbu.hrbu21 <> -1 THEN  
         	 	 LET l_j = 21        
             CALL i035_judge(l_j) RETURNING l_return
             IF l_return THEN 
            	  NEXT FIELD hrbu21            	
             END IF
           END IF 
         ELSE 
           LET g_hrbu.hrbu21 = -1
         END IF
    }     
      AFTER INPUT
         LET g_hrbu.hrbuuser = s_get_data_owner("hrbu_file") #FUN-C10039
         LET g_hrbu.hrbugrup = s_get_data_group("hrbu_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_hrbu.hrbu01 IS NULL THEN
               DISPLAY BY NAME g_hrbu.hrbu01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD hrbu01
            END IF
          # FOR l_i=3 TO l_i=21
         IF g_hrbu.hrbu23='1' THEN 
           WHILE l_i <= 21
            CALL i035_judge(l_i) RETURNING l_return
            CASE l_return
              WHEN 3   NEXT FIELD hrbu03
              WHEN 4   NEXT FIELD hrbu04
              WHEN 5   NEXT FIELD hrbu05
              WHEN 6   NEXT FIELD hrbu06
              WHEN 7   NEXT FIELD hrbu07
              WHEN 8   NEXT FIELD hrbu08
              WHEN 9   NEXT FIELD hrbu09
              WHEN 10  NEXT FIELD hrbu10
              WHEN 11  NEXT FIELD hrbu11
              WHEN 12  NEXT FIELD hrbu12
              WHEN 13  NEXT FIELD hrbu13
              WHEN 14  NEXT FIELD hrbu14
              WHEN 15  NEXT FIELD hrbu15
              WHEN 16  NEXT FIELD hrbu16
              WHEN 17  NEXT FIELD hrbu17
              WHEN 18  NEXT FIELD hrbu18
              WHEN 19  NEXT FIELD hrbu19
              WHEN 20  NEXT FIELD hrbu20
              WHEN 21  NEXT FIELD hrbu21
             OTHERWISE 
                EXIT CASE
             END CASE
             LET l_i = l_i+1
            END WHILE
           ELSE 
           	IF NOT cl_null(g_hrbu.hrbu24) AND NOT cl_null(g_hrbu.hrbu25)  AND 
           	   NOT cl_null(g_hrbu.hrbu26) AND NOT cl_null(g_hrbu.hrbu29)  THEN 
           	 IF g_hrbu.hrbu24=g_hrbu.hrbu25 OR g_hrbu.hrbu24=g_hrbu.hrbu26 OR 
           	 	  g_hrbu.hrbu24=g_hrbu.hrbu29 OR g_hrbu.hrbu25=g_hrbu.hrbu26  OR 
           	 	  g_hrbu.hrbu25=g_hrbu.hrbu29 OR g_hrbu.hrbu26=g_hrbu.hrbu29 THEN 
         		   CALL cl_err('序号不可重复,请重新输入','!',0)
         		   NEXT FIELD hrbu24
           	  END IF 
           	END IF 
         	  IF NOT cl_null(g_hrbu.hrbu24) AND NOT cl_null(g_hrbu.hrbu25) AND  
            	 NOT cl_null(g_hrbu.hrbu27) AND NOT cl_null(g_hrbu.hrbu28) AND NOT cl_null(g_hrbu.hrbu29)THEN 
            	IF g_hrbu.hrbu24=g_hrbu.hrbu25 OR g_hrbu.hrbu24=g_hrbu.hrbu27 OR g_hrbu.hrbu24=g_hrbu.hrbu28 OR 
            		 g_hrbu.hrbu24=g_hrbu.hrbu29 OR g_hrbu.hrbu25=g_hrbu.hrbu27 OR g_hrbu.hrbu25=g_hrbu.hrbu28 OR 
           		   g_hrbu.hrbu25=g_hrbu.hrbu29 OR g_hrbu.hrbu27=g_hrbu.hrbu28 OR g_hrbu.hrbu27=g_hrbu.hrbu28 OR 
           		   g_hrbu.hrbu28=g_hrbu.hrbu29 THEN 
         		     CALL cl_err('序号不可重复,请重新输入','!',0)
         		     NEXT FIELD hrbu24
            	END IF 
            END IF 		
          END IF 
      #    END FOR   
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(hrbu01) THEN
            LET g_hrbu.* = g_hrbu_t.*
            CALL i035_show()
            NEXT FIELD hrbu01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(hrbu01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbu01"
              LET g_qryparam.default1 = g_hrbu.hrbu01
              CALL cl_create_qry() RETURNING g_hrbu.hrbu01
              DISPLAY BY NAME g_hrbu.hrbu01
              NEXT FIELD hrbu01
 
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help   
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION

FUNCTION i035_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrbu.* TO NULL    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i035_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i035_count
    FETCH i035_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i035_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbu.hrbu01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbu.* TO NULL
    ELSE
        CALL i035_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION


 
FUNCTION i035_fetch(p_flhrbu)
    DEFINE p_flhrbu         LIKE type_file.chr1
 
    CASE p_flhrbu
        WHEN 'N' FETCH NEXT     i035_cs INTO g_hrbu.hrbu01
        WHEN 'P' FETCH PREVIOUS i035_cs INTO g_hrbu.hrbu01
        WHEN 'F' FETCH FIRST    i035_cs INTO g_hrbu.hrbu01
        WHEN 'L' FETCH LAST     i035_cs INTO g_hrbu.hrbu01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about       
                     CALL cl_about()    
 
                  ON ACTION help        
                     CALL cl_show_help()
 
                  ON ACTION controlg    
                     CALL cl_cmdask()   
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i035_cs INTO g_hrbu.hrbu01
            LET g_no_ask = FALSE   
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbu.hrbu01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbu.* TO NULL  
        LET g_hrbu.hrbu01 = NULL      
        RETURN
    ELSE
      CASE p_flhrbu
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx     
    END IF
 
    SELECT * INTO g_hrbu.* FROM hrbu_file    # 重讀DB,因TEMP有不被更新特性
       WHERE hrbu01 = g_hrbu.hrbu01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrbu_file",g_hrbu.hrbu01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_hrbu.hrbuuser           #FUN-4C0044權限控管
        LET g_data_group=g_hrbu.hrbugrup
        CALL i035_show()                   # 重新顯示
    END IF
END FUNCTION
 


FUNCTION i035_show()
    LET g_hrbu_t.* = g_hrbu.*
    DISPLAY BY NAME g_hrbu.hrbu01,g_hrbu.hrbu02,g_hrbu.hrbu03,g_hrbu.hrbu04,g_hrbu.hrbu05,
        g_hrbu.hrbu06,g_hrbu.hrbu07,g_hrbu.hrbu08,g_hrbu.hrbu09,g_hrbu.hrbu10,
        g_hrbu.hrbu11,g_hrbu.hrbu12,g_hrbu.hrbu13,g_hrbu.hrbu14,g_hrbu.hrbu15,
        g_hrbu.hrbu16,g_hrbu.hrbu17,g_hrbu.hrbu18,g_hrbu.hrbu19,g_hrbu.hrbu20,
        g_hrbu.hrbu21,g_hrbu.hrbu22,g_hrbu.hrbu23,g_hrbu.hrbu24,g_hrbu.hrbu25,g_hrbu.hrbu26,
        g_hrbu.hrbu27,g_hrbu.hrbu28,g_hrbu.hrbu29,g_hrbu.hrbu30,  
        g_hrbu.hrbuuser,g_hrbu.hrbugrup,g_hrbu.hrbumodu,g_hrbu.hrbudate,g_hrbu.hrbuacti
    CALL cl_show_fld_cont()
END FUNCTION
 


FUNCTION i035_u()
    IF g_hrbu.hrbu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrbu.* FROM hrbu_file WHERE hrbu01=g_hrbu.hrbu01
    IF g_hrbu.hrbuacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    IF g_hrbu.hrbu23='1' THEN 
    	  CALL cl_set_comp_entry("hrbu24,hrbu25,hrbu26,hrbu27,hrbu28,hrbu29,hrbu30",FALSE)
        CALL cl_set_comp_entry("hrbu03,hrbu04,hrbu05,hrbu06,hrbu07,hrbu08,hrbu09,hrbu10,
                      hrbu11,hrbu12,hrbu13,hrbu14,hrbu15,hrbu16,hrbu17,hrbu18,hrbu19,hrbu20,
                      hrbu21",TRUE)
    ELSE 
    	 CALL cl_set_comp_entry("hrbu03,hrbu04,hrbu05,hrbu06,hrbu07,hrbu08,hrbu09,hrbu10,
                      hrbu11,hrbu12,hrbu13,hrbu14,hrbu15,hrbu16,hrbu17,hrbu18,hrbu19,hrbu20,
                      hrbu21",FALSE)
       CALL cl_set_comp_entry("hrbu24,hrbu25,hrbu26,hrbu27,hrbu28,hrbu29,hrbu30",TRUE)
    END IF 
    IF g_hrbu.hrbu30='1' THEN 
          	CALL cl_set_comp_entry("hrbu27,hrbu28",FALSE)
         	 	CALL cl_set_comp_entry("hrbu26",TRUE)
           ELSE 
           	CALL cl_set_comp_entry("hrbu26",FALSE)
         	 	CALL cl_set_comp_entry("hrbu27,hrbu28",TRUE)
          END IF 
    CALL cl_opmsg('u')
    LET g_hrbu01_t = g_hrbu.hrbu01
    BEGIN WORK
 
    OPEN i035_cl USING g_hrbu.hrbu01
    IF STATUS THEN
       CALL cl_err("OPEN i035_cl:", STATUS, 1)
       CLOSE i035_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i035_cl INTO g_hrbu.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbu.hrbu01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_hrbu.hrbumodu=g_user                  #修改者
    LET g_hrbu.hrbudate = g_today               #修改日期
    CALL i035_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i035_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrbu.*=g_hrbu_t.*
            CALL i035_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE hrbu_file SET hrbu_file.* = g_hrbu.*    # 更新DB
            #WHERE hrbu01 = g_hrbu.hrbu01     #MOD-BB0113 mark
            WHERE hrbu01 = g_hrbu_t.hrbu01    #MOD-BB0113 add
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrbu_file",g_hrbu.hrbu01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i035_cl
    COMMIT WORK
END FUNCTION


 
FUNCTION i035_x()
    IF g_hrbu.hrbu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i035_cl USING g_hrbu.hrbu01
    IF STATUS THEN
       CALL cl_err("OPEN i035_cl:", STATUS, 1)
       CLOSE i035_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i035_cl INTO g_hrbu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbu.hrbu01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i035_show()
    IF cl_exp(0,0,g_hrbu.hrbuacti) THEN
        LET g_chr = g_hrbu.hrbuacti
        IF g_hrbu.hrbuacti='Y' THEN
            LET g_hrbu.hrbuacti='N'
        ELSE
            LET g_hrbu.hrbuacti='Y'
        END IF
        UPDATE hrbu_file
            SET hrbuacti=g_hrbu.hrbuacti
            WHERE hrbu01=g_hrbu.hrbu01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrbu.hrbu01,SQLCA.sqlcode,0)
            LET g_hrbu.hrbuacti = g_chr
        END IF
        DISPLAY BY NAME g_hrbu.hrbuacti
    END IF
    CLOSE i035_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i035_r()
    IF g_hrbu.hrbu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i035_cl USING g_hrbu.hrbu01
    IF STATUS THEN
       CALL cl_err("OPEN i035_cl:", STATUS, 0)
       CLOSE i035_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i035_cl INTO g_hrbu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbu.hrbu01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i035_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrbu01"   
       LET g_doc.value1 = g_hrbu.hrbu01 

       CALL cl_del_doc()
       DELETE FROM hrbu_file WHERE hrbu01 = g_hrbu.hrbu01

       CLEAR FORM
       OPEN i035_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i035_cl
          CLOSE i035_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       FETCH i035_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i035_cl
          CLOSE i035_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i035_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i035_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i035_fetch('/')
       END IF
    END IF
    CLOSE i035_cl
    COMMIT WORK
END FUNCTION
 


FUNCTION i035_copy()

    DEFINE l_newno         LIKE hrbu_file.hrbu01
    DEFINE l_oldno         LIKE hrbu_file.hrbu01
    DEFINE p_cmd           LIKE type_file.chr1
    DEFINE l_input         LIKE type_file.chr1 
 
    IF g_hrbu.hrbu01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i035_set_entry('a')
    LET g_before_input_done = TRUE

    INPUT l_newno FROM hrbu01
 
        AFTER FIELD hrbu01
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM hrbu_file WHERE hrbu01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD hrbu01
              END IF

         #     SELECT gen01 FROM gen_file WHERE gen01= l_newno
              IF SQLCA.sqlcode THEN
                  DISPLAY BY NAME g_hrbu.hrbu01
                  LET l_newno = NULL
                  NEXT FIELD hrbu01
              END IF
           END IF
 
        ON ACTION controlp                        # 沿用所有欄位
           IF INFIELD(hrbu01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbu01"
              LET g_qryparam.default1 = g_hrbu.hrbu01
              CALL cl_create_qry() RETURNING l_newno
              DISPLAY l_newno TO hrbu01

              SELECT gen01 FROM gen_file WHERE gen01= l_newno
              IF SQLCA.sqlcode THEN
                 DISPLAY BY NAME g_hrbu.hrbu01
                 LET l_newno = NULL
                 NEXT FIELD hrbu01
              END IF
              NEXT FIELD hrbu01
           END IF

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

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_hrbu.hrbu01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM hrbu_file
        WHERE hrbu01=g_hrbu.hrbu01
        INTO TEMP x
    UPDATE x
        SET hrbu01=l_newno,    #資料鍵值
            hrbuacti='Y',      #資料有效碼
            hrbuuser=g_user,   #資料所有者
            hrbugrup=g_grup,   #資料所有者所屬群
            hrbumodu=NULL,     #資料修改日期
            hrbudate=g_today   #資料建立日期

    INSERT INTO hrbu_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","hrbu_file",g_hrbu.hrbu01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_hrbu.hrbu01
        LET g_hrbu.hrbu01 = l_newno
        SELECT hrbu_file.* INTO g_hrbu.* FROM hrbu_file
               WHERE hrbu01 = l_newno
        CALL i035_u()
        SELECT hrbu_file.* INTO g_hrbu.* FROM hrbu_file
               WHERE hrbu01 = l_oldno
    END IF
    LET g_hrbu.hrbu01 = l_oldno
    CALL i035_show()
END FUNCTION

 
PRIVATE FUNCTION i035_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrbu01",TRUE)
   END IF
END FUNCTION

 
PRIVATE FUNCTION i035_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("hrbu01",FALSE)
   END IF
#SELECT rowid FROM zz_file WhERE zz01=g_zz01        #No.TQC-B60372
   CALL cl_set_comp_entry("hrbuacti",FALSE) 
END FUNCTION

FUNCTION i035_explain()
   DEFINE l_msg     STRING
   IF cl_null(g_hrbu.hrbu01) THEN RETURN END IF
   LET l_msg="ghri035_1 '",g_hrbu.hrbu01,"'"
   CALL cl_cmdrun(l_msg)
END FUNCTION
         
FUNCTION i035_judge(p_j)
  DEFINE l_return       LIKE type_file.num5
  DEFINE l_j            LIKE type_file.num5 
  DEFINE p_j                   LIKE type_file.num5
   
   LET l_return = 0
   LET l_j = p_j
   CASE l_j
   WHEN 3
   IF g_hrbu.hrbu03 < 1 THEN 
       LET l_return =3
       CALL cl_err('此栏位需大于1','!',1)
   ELSE 
       LET l_return =0
   END IF
    RETURN l_return
   
   WHEN 4
   IF g_hrbu.hrbu04 < 0 THEN
        LET l_return =4
        CALL cl_err('此栏位需大于0','!',1)
   ELSE 
     IF  g_hrbu.hrbu04 >= g_hrbu.hrbu03 THEN 
        LET l_return =4
        CALL cl_err('','ghr-077',0)
     ELSE  
       CALL i035_check(g_hrbu.hrbu04,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       4)
       RETURNING l_return
       IF l_return > 0 THEN
         CALL cl_err('在区间内重复','!',1)
       END IF
      # LET l_return =0  #mark by lifang 130529
     END IF 
   END IF
    RETURN l_return 

   WHEN 5 
   IF g_hrbu.hrbu05 > g_hrbu.hrbu03 THEN 
   	   LET l_return =5
        CALL cl_err('','ghr-077',0)
   ELSE 
     IF g_hrbu.hrbu05 < g_hrbu.hrbu04 THEN 
        LET l_return =5
        CALL cl_err('','ghr-075',0)
     ELSE 
       CALL i035_check(g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       5)
       RETURNING l_return
       IF l_return > 0 THEN
         CALL cl_err('在区间内重复','!',1)
       END IF
      # LET l_return =0  #mark by lifang 130529
     END IF 
   END IF 
   RETURN l_return
  
   WHEN 6
  # IF g_hrbu.hrbu06 <= g_hrbu.hrbu05 THEN 
  #     LET l_return =6
  #     CALL cl_err('','ghr-076',0)
  # ELSE
  #mod by lifang 130529
       CALL i035_check(g_hrbu.hrbu06,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       6)
       RETURNING l_return
       IF l_return > 0 THEN
         CALL cl_err('在区间内重复','!',1)
       END IF
      # LET l_return =0  #mark by lifang 130529
   #END IF    #mod by lifang 130529
    RETURN l_return
  
   WHEN 7
   IF g_hrbu.hrbu07 > g_hrbu.hrbu03 THEN 
   	   LET l_return =7
        CALL cl_err('','ghr-077',0)
   ELSE 
     IF g_hrbu.hrbu07 < g_hrbu.hrbu06 THEN 
         LET l_return =7
         CALL cl_err('','ghr-075',0)
     ELSE 
        CALL i035_check(g_hrbu.hrbu07,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       7)
       RETURNING l_return
       IF l_return > 0 THEN
         CALL cl_err('在区间内重复','!',1)
       END IF
       #  LET l_return =0  #mark by lifang 130529
     END IF 
   END IF
    RETURN l_return

   WHEN 8
   #IF g_hrbu.hrbu08 <= g_hrbu.hrbu07 THEN 
   #    LET l_return =8
   #    CALL cl_err('','ghr-076',0)
   #ELSE
   #mod by lifang 130529 
       CALL i035_check(g_hrbu.hrbu08,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       8)
       RETURNING l_return
       IF l_return > 0 THEN
         CALL cl_err('在区间内重复','!',1)
       END IF
      # LET l_return =0  #mark by lifang 130529
  # END IF     #mod by lifang 130529
    RETURN l_return
   
   WHEN 9
   IF g_hrbu.hrbu09 > g_hrbu.hrbu03 THEN 
   	    LET l_return =9
        CALL cl_err('','ghr-077',0)
   ELSE 
     IF g_hrbu.hrbu09 < g_hrbu.hrbu08 THEN 
         LET l_return =9
         CALL cl_err('','ghr-075',0)
     ELSE 
         CALL i035_check(g_hrbu.hrbu09,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       9)
         RETURNING l_return
         IF l_return > 0 THEN
           CALL cl_err('在区间内重复','!',1)
         END IF
        # LET l_return =0   #mark by lifang 130529
     END IF
   END IF
    RETURN l_return
   
   WHEN 10 
 #  IF g_hrbu.hrbu10 <= g_hrbu.hrbu09 THEN 
 #      LET l_return =10
 #      CALL cl_err('','ghr-076',0)
 #  ELSE 
 #mod by lifang 130529
       CALL i035_check(g_hrbu.hrbu10,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       10)
         RETURNING l_return
         IF l_return > 0 THEN
           CALL cl_err('在区间内重复','!',1)
         END IF
    #   LET l_return =0  #mark by lifang 130529
 #  END IF  #mod by lifang 130529
    RETURN l_return
   
  WHEN 11
  IF g_hrbu.hrbu11 > g_hrbu.hrbu03 THEN 
   	    LET l_return =11
        CALL cl_err('','ghr-077',0)
  ELSE 
    IF g_hrbu.hrbu11 < g_hrbu.hrbu10 THEN 
         LET l_return =11
         CALL cl_err('','ghr-075',0)
    ELSE 
       CALL i035_check(g_hrbu.hrbu11,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       11)
         RETURNING l_return
         IF l_return > 0 THEN
           CALL cl_err('在区间内重复','!',1)
         END IF         
       #  LET l_return =0    #mark by lifang 130529
    END IF
  END IF
    RETURN l_return

   WHEN 12 
  # IF g_hrbu.hrbu12 <= g_hrbu.hrbu11 THEN 
  #     LET l_return =12
  #     CALL cl_err('','ghr-076',0)
  # ELSE
  #mod by lifang 130529
       CALL i035_check(g_hrbu.hrbu12,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       12)
         RETURNING l_return
         IF l_return > 0 THEN
           CALL cl_err('在区间内重复','!',1)
         END IF         
    #   LET l_return =0  #mark by lifang 130528
  # END IF    #mod by lifang 130529
    RETURN l_return

   WHEN 13
   IF g_hrbu.hrbu13 > g_hrbu.hrbu03 THEN 
   	   LET l_return =13
        CALL cl_err('','ghr-077',0)
   ELSE 
     IF g_hrbu.hrbu13 < g_hrbu.hrbu12 THEN 
         LET l_return =13
         CALL cl_err('','ghr-075',0)
     ELSE
       CALL i035_check(g_hrbu.hrbu13,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       13)
         RETURNING l_return
         IF l_return > 0 THEN
           CALL cl_err('在区间内重复','!',1)
         END IF 
       #  LET l_return =0
     END IF
   END IF  
    RETURN l_return

   WHEN 14
  # IF g_hrbu.hrbu14 <= g_hrbu.hrbu13 THEN 
  #     LET l_return =14
  #     CALL cl_err('','ghr-076',0)
  # ELSE
  #mod by lifang 130529 
      CALL i035_check(g_hrbu.hrbu14,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       14)
         RETURNING l_return
         IF l_return > 0 THEN
           CALL cl_err('在区间内重复','!',1)
         END IF
     #  LET l_return =0   #mark by lifang 130529
   #END IF     #mod by lifang 130529
    RETURN l_return
 
   WHEN 15
   IF g_hrbu.hrbu15 > g_hrbu.hrbu03 THEN 
   	   LET l_return =15
        CALL cl_err('','ghr-077',0)
   ELSE 
     IF g_hrbu.hrbu15 < g_hrbu.hrbu14 THEN 
         LET l_return =15
         CALL cl_err('','ghr-075',0)
     ELSE 
       CALL i035_check(g_hrbu.hrbu15,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       15)
         RETURNING l_return
         IF l_return > 0 THEN
           CALL cl_err('在区间内重复','!',1)
         END IF
       #  LET l_return =0   #mark by lifang 130529
     END IF 
   END IF
    RETURN l_return

   WHEN 16
   #IF g_hrbu.hrbu16 <= g_hrbu.hrbu15 THEN 
   #    LET l_return =16
   #    CALL cl_err('','ghr-076',0)
   #ELSE 
   #mod by lifang 130529
      CALL i035_check(g_hrbu.hrbu16,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       16)
         RETURNING l_return
         IF l_return > 0 THEN
           CALL cl_err('在区间内重复','!',1)
         END IF
    #   LET l_return =0    #mark by lifang 130529
   #END IF  #mod by lifang 130529 
    RETURN l_return
 
   WHEN 17
   IF g_hrbu.hrbu17 > g_hrbu.hrbu03 THEN
       LET l_return =17
       CALL cl_err('','ghr-077',0)
   ELSE 
     IF g_hrbu.hrbu17 < g_hrbu.hrbu16 THEN 
       LET l_return =17
       CALL cl_err('','ghr-075',0)
     ELSE 
       CALL i035_check(g_hrbu.hrbu17,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       17)
         RETURNING l_return
         IF l_return > 0 THEN
           CALL cl_err('在区间内重复','!',1)
         END IF
     #  LET l_return =0   #mark by lifang 130529
    END IF 
   END IF   
    RETURN l_return

   WHEN 18
   IF g_hrbu.hrbu18 > -1 THEN
     IF g_hrbu.hrbu18 > g_hrbu.hrbu03 THEN
         LET l_return =18
         CALL cl_err('','ghr-077',0)
     ELSE   
        # IF g_hrbu.hrbu18 <= g_hrbu.hrbu17 THEN 
        #   LET l_return =18
        #   CALL cl_err('','ghr-076',0)
        # ELSE 
        #mod by lifang 130529
           CALL i035_check(g_hrbu.hrbu18,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       18)
           RETURNING l_return
           IF l_return > 0 THEN
             CALL cl_err('在区间内重复','!',1)
           END IF
         #  LET l_return =0  #mark by lifang 130529
        # END IF    #mod by lifang 130529
     END IF  
   END IF
    RETURN l_return
 
   WHEN 19
   IF g_hrbu.hrbu19 > -1 THEN
     IF g_hrbu.hrbu19 > g_hrbu.hrbu03 THEN
         LET l_return =19
         CALL cl_err('','ghr-077',0)
     ELSE 
        #IF g_hrbu.hrbu19 <= g_hrbu.hrbu18 THEN  #mark by lifang 130701
         IF g_hrbu.hrbu19 < g_hrbu.hrbu18 THEN   #add by lifang 130701
           LET l_return =19
           CALL cl_err('','ghr-076',0)
         ELSE 
           IF g_hrbu.hrbu19 > 0 AND g_hrbu.hrbu18 < 0 THEN
              CALL cl_err('后位数字大于0时前位数字也需大于0','!','0')
              LET l_return = 18 
           ELSE
             CALL i035_check(g_hrbu.hrbu19,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu20,g_hrbu.hrbu21,
                       19)
             RETURNING l_return
             IF l_return > 0 THEN
               CALL cl_err('在区间内重复','!',1)
             END IF
            #  LET l_return = 0   #mark by lifang 130529
           END IF
         END IF 
     END IF
   END IF
    RETURN l_return

   WHEN 20
   IF g_hrbu.hrbu20 > -1 THEN
     IF g_hrbu.hrbu20 > g_hrbu.hrbu03 THEN
         LET l_return =20
         CALL cl_err('','ghr-077',0)
     ELSE 
       #  IF g_hrbu.hrbu20 <= g_hrbu.hrbu19 THEN 
       #    LET l_return =20
       #    CALL cl_err('','ghr-076',0)
       #  ELSE
       #mod by lifang 130529 
           CALL i035_check(g_hrbu.hrbu20,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       20)
           RETURNING l_return
             IF l_return > 0 THEN
               CALL cl_err('在区间内重复','!',1)
             END IF
          # LET l_return =0  #mark by lifang 130529
       #  END IF   #mod by lifang 130529
     END IF
   END IF
    RETURN l_return
 
   WHEN 21
   IF g_hrbu.hrbu21 > -1 THEN
     IF g_hrbu.hrbu21 > g_hrbu.hrbu03 THEN
         LET l_return =21
         CALL cl_err('','ghr-077',0)
     ELSE 
       # IF g_hrbu.hrbu21 <= g_hrbu.hrbu20 THEN   #mark by lifang 130701
         IF g_hrbu.hrbu21 < g_hrbu.hrbu20 THEN    #add by lifang 130701
           LET l_return =21
           CALL cl_err('','ghr-076',0)
         ELSE 
           IF g_hrbu.hrbu21 > 0 AND g_hrbu.hrbu20 < 0 THEN
              CALL cl_err('后位数字大于0时前位数字也需大于0','!','0')
              LET l_return = 20 
           ELSE
              CALL i035_check(g_hrbu.hrbu21,
                       g_hrbu.hrbu04,g_hrbu.hrbu05,
                       g_hrbu.hrbu06,g_hrbu.hrbu07,
                       g_hrbu.hrbu08,g_hrbu.hrbu09,
                       g_hrbu.hrbu10,g_hrbu.hrbu11,
                       g_hrbu.hrbu12,g_hrbu.hrbu13,
                       g_hrbu.hrbu14,g_hrbu.hrbu15,
                       g_hrbu.hrbu16,g_hrbu.hrbu17,
                       g_hrbu.hrbu18,g_hrbu.hrbu19,
                       21)
           RETURNING l_return
           IF l_return > 0 THEN
             CALL cl_err('在区间内重复','!',1)
           END IF
          #   LET l_return =0
           END IF
         END IF 
     END IF
   END IF
    RETURN l_return
   END CASE
   
END FUNCTION

FUNCTION i035_check(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p_j)
DEFINE p1   LIKE type_file.num5,
       p2   LIKE type_file.num5,
       p3   LIKE type_file.num5,
       p4   LIKE type_file.num5,
       p5   LIKE type_file.num5,
       p6   LIKE type_file.num5,
       p7   LIKE type_file.num5,
       p8   LIKE type_file.num5,
       p9   LIKE type_file.num5,
       p10  LIKE type_file.num5,
       p11  LIKE type_file.num5,
       p12  LIKE type_file.num5,
       p13  LIKE type_file.num5,
       p14  LIKE type_file.num5,
       p15  LIKE type_file.num5,
       p16  LIKE type_file.num5,
       p17  LIKE type_file.num5,
       p_j  LIKE type_file.num5

DEFINE l_j1 LIKE type_file.num5
       
       LET l_j1 = p_j
       IF p2<= p1 AND p1<=p3 THEN 
       	 RETURN l_j1
       ELSE 
         IF p4<= p1 AND p1<=p5 THEN 
         	 RETURN l_j1
         ELSE 
           IF p6<= p1 AND p1<=p7 THEN 
         	    RETURN l_j1
           ELSE
              IF p8<= p1 AND p1<=p9 THEN
       	         RETURN l_j1
              ELSE 
                 IF p10<= p1 AND p1<=p11 THEN
       	            RETURN l_j1
                 ELSE 
                    IF p12<= p1 AND p1<=p13 THEN
       	               RETURN l_j1
                    ELSE 
                       IF p14<= p1 AND p1<=p15 THEN
       	                  RETURN l_j1
                       ELSE 
                          IF p16<= p1 AND p1<=p17 THEN
       	                     RETURN l_j1
       	                  ELSE 
       	                     LET l_j1 = 0
       	                     RETURN l_j1
       	                  END IF
                       END IF
                    END IF
                  END IF
                END IF
              END IF  
           END IF
         END IF
END FUNCTION

FUNCTION i035_set_required()

    CALL cl_set_comp_required("hrbu04,hrbu05,hrbu06,hrbu07,hrbu08,hrbu09,
                               hrbu10,hrbu11,hrbu12,hrbu13,hrbu14,hrbu15,
                               hrbu16,hrbu17",TRUE)
    IF g_hrbu.hrbu18 > 0 THEN 
    	CALL cl_set_comp_required("hrbu18",TRUE)
    END IF
    IF g_hrbu.hrbu19 > 0 THEN 
    	CALL cl_set_comp_required("hrbu19",TRUE)
    END IF
    IF g_hrbu.hrbu20 > 0 THEN 
    	CALL cl_set_comp_required("hrbu20",TRUE)
    END IF
    IF g_hrbu.hrbu21 > 0 THEN 
    	CALL cl_set_comp_required("hrbu21",TRUE)
    END IF
END FUNCTION
