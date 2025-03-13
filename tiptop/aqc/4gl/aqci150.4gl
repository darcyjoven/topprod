# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aqci150.4gl
# Descriptions...: 料件客戶檢驗資料維護作業
# Date & Author..: 05/12/27 By Rayven
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-690023 06/09/08 By jamie 判斷occacti
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0160 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-780095 07/09/03 By Melody Primary key
# Modify.........: No.MOD-7A0106 07/10/17 By Pengu COMBOBOX"級數"欄位的選項改由程式動態設定
# Modify.........: No.MOD-7A0197 07/10/31 By Pengu 單身新增資料時會出現"必要輸入"的欄位卻塞進了NULL值的錯誤
# Modify.........: No.FUN-7C0043 07/12/17 By Sunyanchun    老報表改成p_query
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.TQC-980084 09/08/12 By sherry 1、輸入無效的料件編號后，沒有做控管    
#                                                   2、客戶編號輸入無效值，報錯信息不對
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A40003 10/04/07 By Summer 修改obk12的值後程式段並不會跑到OR ROW CHANGE，在AFTER FIELD obk12再重新display一次obk12的值 
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:CHI-BB0007 12/02/08 By jt_chen 料件客戶(aqci150)畫面上只顯示一筆資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C30124 13/01/22 By pauline axmt410輸入料號後後,若為須檢驗的料號,則開啟aqci150直接進入編輯狀態
# Modify.........: No:FUN-D30034 13/04/16 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_obk01          LIKE obk_file.obk01,       #類別代號 (假單頭)
    g_obk01_t        LIKE obk_file.obk01,       #類別代號 (舊值)
    g_obk            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                obk02       LIKE obk_file.obk02,
		occ02       LIKE occ_file.occ02,
		obk11       LIKE obk_file.obk11,
		obk12       LIKE obk_file.obk12,
		obk13       LIKE obk_file.obk13,
		obk14       LIKE obk_file.obk14
                     END RECORD,
    g_obk_t          RECORD                     #程式變數 (舊值)
                obk02       LIKE obk_file.obk02,
		occ02       LIKE occ_file.occ02,
		obk11       LIKE obk_file.obk11,
		obk12       LIKE obk_file.obk12,
		obk13       LIKE obk_file.obk13,
		obk14       LIKE obk_file.obk14
                    END RECORD,
    g_argv1          LIKE obk_file.obk01,
    g_argv2          LIKE obk_file.obk02,    #FUN-C30124 add
    g_argv3          LIKE type_file.chr1,    #FUN-C30124 add  #是否直接進入修改狀態
    g_wc,g_wc2,g_sql STRING,
    g_cmd            LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(200)
    g_ss             LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)  #決定後續步驟
    g_rec_b          LIKE type_file.num5,                    #單身筆數        #No.FUN-680104 SMALLINT
    l_ac             LIKE type_file.num5                     #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
 
#主程式開始
DEFINE   g_forupd_sql   STRING                 #SELECT ... FOR UPDATE SQL        #No.FUN-680104
DEFINE   g_cnt          LIKE type_file.num10            #No.FUN-680104 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0085
    p_row,p_col   LIKE type_file.num5          #No.FUN-680104 SMALLINT
DEFINE l_n        LIKE type_file.num5          #FUN-C30124 add
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AQC")) THEN
       EXIT PROGRAM
    END IF
 
 
    CALL  cl_used(g_prog,g_time,1)         #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
    LET g_argv1 = ARG_VAL(1)              #料件編號
    LET g_argv2 = ARG_VAL(2)      #FUN-C30124 add #客戶編號
    LET g_argv3 = ARG_VAL(3)      #FUN-C30124 add
    LET g_obk01 = NULL                    #清除鍵值
    LET g_obk01_t = NULL
    LET g_obk01 = g_argv1

   #FUN-C30124 add START
    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND g_argv3 = 'Y' THEN
       SELECT COUNT(*) INTO l_n FROM obk_file
          WHERE obk01 = g_argv1 AND obk02 = g_argv2
       IF l_n = 0 OR cl_null(l_n) THEN
          BEGIN WORK
          INSERT INTO obk_file(obk01,obk02,obk05,obk11,obk12,obk13,obk14,obkoriu,obkorig)
             VALUES(g_argv1,g_argv2,' ','N',' ',' ',' ',g_user,g_grup)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","obk_file",g_obk01,g_obk[l_ac].obk02,SQLCA.sqlcode,"","",1) 
             RETURN 
          ELSE
             COMMIT WORK
          END IF
       END IF
    END IF
   #FUN-C30124 add END
 
    LET p_row = 4 LET p_col = 6 
    OPEN WINDOW i150_w AT p_row,p_col
         WITH FORM "aqc/42f/aqci150" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
   #IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN  #FUN-C30124 mark 
    IF NOT cl_null(g_argv1) THEN  #FUN-C30124 add 
	CALL  i150_q()
    END IF
    CALL i150_menu()
    CLOSE WINDOW i150_w                   #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION i150_curs()
    CLEAR FORM                            #清除畫面
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_obk01 TO NULL    #No.FUN-750051
    IF cl_null(g_argv1) THEN  #FUN-C30124 add   #當料號為空值時才進入construct
       CONSTRUCT g_wc ON obk01,
                         obk02,obk11,obk12,obk13,obk14
            FROM obk01,
                 s_obk[1].obk02,s_obk[1].obk11,s_obk[1].obk12,s_obk[1].obk13,s_obk[1].obk14      
  
                 #No.FUN-580031 --start--     HCN
                 BEFORE CONSTRUCT
                    CALL cl_qbe_init()
                 #No.FUN-580031 --end--       HCN
         ON ACTION CONTROLP                                                                                                          
            CASE                                                                                                                    
               WHEN INFIELD(obk01)
#FUN-AA0059---------mod------------str-----------------                                                                                                 
#                 CALL cl_init_qry_var()                                                                                         
#                 LET g_qryparam.form = "q_ima"                                                                                  
#                 LET g_qryparam.state = 'c'                                                                                     
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                             
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO obk01                                                                           
                  NEXT FIELD obk01
               WHEN INFIELD(obk02)                                                                                                    
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form = "q_occ"                                                                                     
                  LET g_qryparam.state = 'c'                                                                                        
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO obk02                                                                              
                  NEXT FIELD obk02                                                                                               
               OTHERWISE EXIT CASE                                                                                                 
            END CASE  
  
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
  
         ON ACTION about         
            CALL cl_about()    
  
         ON ACTION help         
            CALL cl_show_help()  
  
         ON ACTION controlg     
            CALL cl_cmdask()    
  
       
           	#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_select
            	   CALL cl_qbe_select() 
                    ON ACTION qbe_save
           	   CALL cl_qbe_save()
           	#No.FUN-580031 --end--       HCN
       END CONSTRUCT
   #FUN-C30124 add START
    ELSE
       LET g_wc = " obk01 = '",g_argv1,"' AND obk02 = '",g_argv2,"' " 
    END IF   
   #FUN-C30124 add
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('obkuser', 'obkgrup') #FUN-980030
 
    IF g_wc IS NULL THEN
       LET g_wc = "1=1"
    END IF
    LET g_sql = "SELECT UNIQUE obk01 ",                                                                  
                "  FROM obk_file ",                                                                                                 
                " WHERE ", g_wc CLIPPED,                                                                                            
                " ORDER BY obk01"                                                                                                   
    PREPARE i150_prepare FROM g_sql                                                                                                 
    DECLARE i150_b_curs                            #SCROLL CURSOR                                                                     
        SCROLL CURSOR WITH HOLD FOR i150_prepare                                                                                    
                                                                                                                                    
    LET g_sql = "SELECT COUNT(UNIQUE obk01) ",                                                                  
                "  FROM obk_file ",                                                                                                 
                " WHERE ", g_wc CLIPPED                                                                                            
    PREPARE i150_precnt FROM g_sql 
    DECLARE i150_count CURSOR FOR i150_precnt                                                                                         
END FUNCTION 
 
FUNCTION i150_menu()
DEFINE l_cmd  LIKE type_file.chr1000     #FUN-7C0043----add-----
   WHILE TRUE
      CALL i150_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i150_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i150_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i150_r()
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL i150_copy()
            END IF
         WHEN "output"                                                                                                            
            IF cl_chk_act_auth() THEN                                                                                              
               CALL i150_out() 
            END IF               
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i150_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_obk),'','')
            END IF
         #No.FUN-6A0160-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_obk01 IS NOT NULL THEN
                 LET g_doc.column1 = "obk01"
                 LET g_doc.value1 = g_obk01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0160-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i150_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_obk.clear()
    LET g_wc = NULL                                                                                               
    LET g_wc2= NULL                                                                                                    
                                                                                                                                    
    IF s_shut(0) THEN                                                                                                                
       RETURN                                                                                                                        
    END IF     
 
    INITIALIZE g_obk01 LIKE obk_file.obk01
    LET g_obk01_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i150_i("a")                #輸入單頭
   
        IF INT_FLAG THEN       
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
            CALL g_obk.clear()
        ELSE
            CALL i150_b_fill('1=1')     #單身
        END IF
        LET g_rec_b = 0
        CALL i150_b()                   #輸入單身
        LET g_obk01_t = g_obk01         #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i150_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改  #No.FUN-680104 VARCHAR(1)
    l_n             LIKE type_file.num5          #No.FUN-680104 SMALLINT
    ,l_cnt          LIKE type_file.num5          #No.TQC-980084 add                
    LET g_ss='Y'
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT g_obk01
        WITHOUT DEFAULTS
        FROM obk01
 
        AFTER FIELD obk01                    #類別代號
          IF NOT cl_null(g_obk01) THEN                 
#FUN-AA0059 ---------------------start----------------------------
             IF NOT s_chk_item_no(g_obk01,"") THEN
                CALL cl_err('',g_errno,1)
                LET g_obk01= g_obk01_t
                NEXT FIELD obk01
            END IF
#FUN-AA0059 ---------------------end-------------------------------                                                                                
             IF p_cmd = "a" OR                                                                                                         
                (p_cmd = "u" AND g_obk01 != g_obk01_t) THEN                        
                #TQC-980084---Begin                                                                                                 
                SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = g_obk01                                                      
                IF l_cnt = 0 THEN                                                                                                   
                   CALL cl_err(g_obk01,'apm-168',1)                                                                                 
                   NEXT FIELD obk01                                                                                                 
                END IF                                                                                                              
                #TQC-980084---End                                                           
                SELECT count(*) INTO l_n FROM obk_file WHERE obk01 = g_obk01                                                           
                IF l_n > 0 THEN                                                                                                        
                   CALL cl_err(g_obk01,-239,1)                                                                                         
                   LET g_obk01=g_obk01_t                                                                                               
                   DISPLAY BY NAME g_obk01                                                                                             
                   NEXT FIELD obk01                                                                                                    
                END IF                                                                                                                 
             END IF                                                                                                                   
          END IF               
          CALL i150_obk01('d') 
 
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name  
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(obk01)
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                LET g_qryparam.default1 = g_obk01 
#                CALL cl_create_qry() RETURNING g_obk01
                 CALL q_sel_ima(FALSE, "q_ima","",g_obk01,"","","","","",'' ) 
                   RETURNING g_obk01  
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_obk01 
                 NEXT FIELD obk01
              OTHERWISE EXIT CASE
           END CASE
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
         #MOD-860081------add-----end---
    END INPUT
END FUNCTION
   
FUNCTION  i150_obk01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,       #No.FUN-680104 VARCHAR(01)
    l_desc          LIKE ima_file.ima06,       #No.FUN-680104 VARCHAR(04)
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021
 
    LET g_errno = ' '
    SELECT ima02, ima021
        INTO l_ima02, l_ima021
        FROM ima_file
        WHERE ima01 = g_obk01
    CASE WHEN STATUS=100       
            LET g_errno = 'mfg0002' 
            LET l_ima02 = NULL LET l_ima021 = NULL 
         OTHERWISE 
            LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02  TO FORMONLY.ima02 
       DISPLAY l_ima021 TO FORMONLY.ima021 
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i150_q()
    
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obk01 TO NULL          #No.FUN-6A0160
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_obk.clear()                                                                                                               
    DISPLAY ' ' TO FORMONLY.cnt
    CALL i150_curs()                    #取得查詢條件
    IF INT_FLAG THEN            
       LET INT_FLAG = 0
       INITIALIZE g_obk01 TO NULL
       RETURN
    END IF
    OPEN i150_b_curs                  
    IF SQLCA.sqlcode THEN        
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_obk01 TO NULL
    ELSE
       CALL i150_fetch('F')            #讀出TEMP第一筆並顯示
       OPEN i150_count
       FETCH i150_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
   #FUN-C30124 add START
    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) AND g_argv3 = 'Y' THEN
       CALL i150_b()
    END IF
   #FUN-C30124 add END
END FUNCTION
 
#處理資料的讀取
FUNCTION i150_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                 #處理方式        #No.FUN-680104 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i150_b_curs INTO g_obk01
        WHEN 'P' FETCH PREVIOUS i150_b_curs INTO g_obk01
        WHEN 'F' FETCH FIRST    i150_b_curs INTO g_obk01
        WHEN 'L' FETCH LAST     i150_b_curs INTO g_obk01
        WHEN '/' 
           IF (NOT mi_no_ask) THEN
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
           FETCH ABSOLUTE g_jump i150_b_curs INTO g_obk01
          LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                   
        CALL cl_err(g_obk01,SQLCA.sqlcode,0)
        INITIALIZE g_obk01 TO NULL
    ELSE
       CALL i150_show()
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
 
#將資料顯示在畫面上
FUNCTION i150_show()
    DISPLAY g_obk01 TO obk01          
    CALL i150_obk01('d')            
    CALL i150_b_fill(g_wc)            
    CALL cl_show_fld_cont()           
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i150_r()
    IF s_shut(0) THEN
       RETURN
    END IF
    IF g_obk01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6A0160
       RETURN
    END IF
    BEGIN WORK
    IF cl_delh(0,0) THEN                  #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "obk01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_obk01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()               #No.FUN-9B0098 10/02/24
       DELETE FROM obk_file WHERE obk01 = g_obk01
       IF SQLCA.sqlcode THEN
#         CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660115
          CALL cl_err3("del","obk_file",g_obk01,"",SQLCA.sqlcode,"","BODY DELETE",1)  #No.FUN-660115
       ELSE
          CLEAR FORM
          CALL g_obk.clear()
          LET g_cnt=SQLCA.SQLERRD[3]
          MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
          OPEN i150_count
          #FUN-B50064-add-start--
          IF STATUS THEN
             CLOSE i150_b_curs
             CLOSE i150_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          FETCH i150_count INTO g_row_count
          #FUN-B50064-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i150_b_curs
             CLOSE i150_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i150_b_curs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i150_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL i150_fetch('/')
          END IF
       END IF
       LET g_msg=TIME
    END IF
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i150_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680104 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,             #可新增否          #No.FUN-680104 VARCHAR(80)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680104 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680104 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_obk01 IS NULL THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT obk02,'',obk11,obk12,obk13,obk14,'' ",
      "   FROM obk_file ",
      "   WHERE obk01= ? ",
      "    AND obk02= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i150_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_obk WITHOUT DEFAULTS FROM s_obk.*
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
          INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
       LET p_cmd = ''
       LET l_ac = ARR_CURR()
       LET l_lock_sw = 'N'           
       LET l_n  = ARR_COUNT()
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_obk_t.* = g_obk[l_ac].*  #BACKUP
             BEGIN WORK
 
             OPEN i150_bcl USING g_obk01,g_obk_t.obk02
             IF STATUS THEN
                CALL cl_err("OPEN i150_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i150_bcl INTO g_obk[l_ac].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_obk_t.obk02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      LET g_obk_t.*=g_obk[l_ac].*
                      CALL i150_obk02('d')
                   END IF
              END IF
              CALL cl_show_fld_cont()     
           END IF
 
    AFTER INSERT
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          CANCEL INSERT
       END IF
      #TQC-780095 
       IF cl_null(g_obk[l_ac].obk02) THEN LET g_obk[l_ac].obk02=' ' END IF
      #TQC-780095 
 
      #---------No.MOD-7A0197 modify
      #INSERT INTO obk_file(obk01,obk02,obk11,obk12,obk13,obk14)
      #   VALUES(g_obk01,g_obk[l_ac].obk02,g_obk[l_ac].obk11,
      #          g_obk[l_ac].obk12,g_obk[l_ac].obk13,
      #          g_obk[l_ac].obk14)
 
       INSERT INTO obk_file(obk01,obk02,obk05,obk11,obk12,obk13,obk14,obkoriu,obkorig)
          VALUES(g_obk01,g_obk[l_ac].obk02,' ',g_obk[l_ac].obk11,
                 g_obk[l_ac].obk12,g_obk[l_ac].obk13,
                 g_obk[l_ac].obk14, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
      #---------No.MOD-7A0197 end
 
       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_obk[l_ac].obk02,SQLCA.sqlcode,0)   #No.FUN-660115
          CALL cl_err3("ins","obk_file",g_obk01,g_obk[l_ac].obk02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
          CANCEL INSERT
       ELSE
          MESSAGE 'INSERT O.K'
          COMMIT WORK
          LET g_rec_b=g_rec_b +1
          DISPLAY g_rec_b TO FORMONLY.cn2  
       END IF
 
    BEFORE INSERT
       LET l_n = ARR_COUNT()
       LET p_cmd='a'
       INITIALIZE g_obk[l_ac].* TO NULL      
       LET g_obk_t.* = g_obk[l_ac].*         #新輸入資料
       LET g_obk[l_ac].obk11 = 'N'
       CALL cl_show_fld_cont()  
       NEXT FIELD obk02
 
    AFTER FIELD obk02                        #check 序號是否重複
       IF NOT cl_null(g_obk[l_ac].obk02) THEN
          IF (g_obk[l_ac].obk02 != g_obk_t.obk02 OR
             g_obk_t.obk02 IS NULL) THEN
             SELECT count(*)
                INTO l_n
                FROM obk_file
                WHERE obk01 = g_obk01 AND
                      obk02 = g_obk[l_ac].obk02
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_obk[l_ac].obk02 = g_obk_t.obk02
                      NEXT FIELD obk02
                   ELSE
                      CALL i150_obk02('a')
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err(g_obk[l_ac].obk02,g_errno,0)
                         NEXT FIELD obk02
                      END IF
                   END IF
           END IF
        END IF
 
   #--------------No.MOD-7A0106 add
    BEFORE FIELD obk14 
      CALL i150_combo()
   #--------------No.MOD-7A0106 end
 
    BEFORE FIELD obk11
       CALL cl_set_comp_entry("obk12",TRUE)
       CALL cl_set_comp_entry("obk13",TRUE)
       CALL cl_set_comp_entry("obk14",TRUE)
 
    AFTER FIELD obk11
       IF NOT cl_null(g_obk[l_ac].obk11) THEN
          LET g_obk[l_ac].obk12 = 'N'
          LET g_obk[l_ac].obk13 = '1'
          IF g_obk[l_ac].obk11 NOT MATCHES'[yYnN]' THEN
             NEXT FIELD obk11
          ELSE
             IF g_obk[l_ac].obk11 MATCHES'[nN]' THEN
                LET g_obk[l_ac].obk12 = NULL
                LET g_obk[l_ac].obk13 = NULL
                LET g_obk[l_ac].obk14 = NULL
                CALL cl_set_comp_entry("obk12",FALSE)
                CALL cl_set_comp_entry("obk13",FALSE)
                CALL cl_set_comp_entry("obk14",FALSE)
              END IF
          END IF
       END IF
 
    AFTER FIELD obk12
       IF NOT cl_null(g_obk[l_ac].obk12) THEN
          IF g_obk[l_ac].obk12 NOT MATCHES'[TRN]' THEN
             NEXT FIELD obk12
          END IF
          DISPLAY BY NAME g_obk[l_ac].obk12 #MOD-A40003 add
       END IF
 
    BEFORE FIELD obk13
       CALL cl_set_comp_entry("obk14",TRUE)
 
    AFTER FIELD obk13
       IF g_obk[l_ac].obk13 IS NULL THEN
          LET g_obk[l_ac].obk14 = NULL 
          CALL cl_set_comp_entry("obk14",FALSE)
       END IF
 
       IF NOT cl_null(g_obk[l_ac].obk13) THEN
          IF g_obk[l_ac].obk13 NOT MATCHES'[12]' THEN
             NEXT FIELD obk13
          END IF
       END IF
 
    AFTER FIELD obk14
       IF NOT cl_null(g_obk[l_ac].obk14) THEN
          IF g_obk[l_ac].obk13 = '1' THEN
             IF g_obk[l_ac].obk14 NOT MATCHES'[123]' THEN
                CALL cl_err("","aqc-513",1)
                NEXT FIELD obk14
             END IF
          END IF
          IF g_obk[l_ac].obk13 = '2' THEN
             IF g_obk[l_ac].obk14 NOT MATCHES'[1234]' THEN
                CALL cl_err("","aqc-513",1)
                NEXT FIELD obk14
             END IF
          END IF
       END IF
 
    BEFORE DELETE                            #是否取消單身
       IF g_obk_t.obk02 IS NOT NULL THEN
          IF NOT cl_delb(0,0) THEN
             CANCEL DELETE
          END IF
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             CANCEL DELETE 
          END IF 
          DELETE FROM obk_file
             WHERE obk01 = g_obk01 AND
                   obk02 = g_obk_t.obk02
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_obk_t.obk02,SQLCA.sqlcode,0)   #No.FUN-660115
             CALL cl_err3("del","obk_file",g_obk01,g_obk_t.obk02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
             ROLLBACK WORK
             CANCEL DELETE 
          END IF
          LET g_rec_b=g_rec_b-1
          DISPLAY g_rec_b TO FORMONLY.cn2  
       END IF
       COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_obk[l_ac].* = g_obk_t.*
             CLOSE i150_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF g_obk[l_ac].obk13 = '1'                                                                                  
             AND g_obk[l_ac].obk14 NOT MATCHES'[123]' THEN                                                                      
                CALL cl_err("","aqc-513",1)                                                                                   
                NEXT FIELD obk14                                                                                              
          END IF
 
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_obk[l_ac].obk02,-263,1)
             LET g_obk[l_ac].* = g_obk_t.*
          ELSE
             UPDATE obk_file SET
                    obk02=g_obk[l_ac].obk02,
                    obk11=g_obk[l_ac].obk11,
                    obk12=g_obk[l_ac].obk12,
                    obk13=g_obk[l_ac].obk13,
                    obk14=g_obk[l_ac].obk14
              WHERE obk01=g_obk01 
                AND obk02=g_obk_t.obk02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_obk[l_ac].obk02,SQLCA.sqlcode,0)   #No.FUN-660115
                 CALL cl_err3("upd","obk_file",g_obk01,g_obk_t.obk02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
                 LET g_obk[l_ac].* = g_obk_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
       #  LET l_ac_t = l_ac   #FUN-D30034
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_obk[l_ac].* = g_obk_t.*
                CALL i150_obk02('d')
            #FUN-D30034--add--str--
             ELSE
                CALL g_obk.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
            #FUN-D30034--add--end--
             END IF
             CLOSE i150_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac   #FUN-D30034
          CLOSE i150_bcl
          COMMIT WORK
 
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(obk02)     #廠商編號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_occ"
                LET g_qryparam.default1 = g_obk[l_ac].obk02
                CALL cl_create_qry() RETURNING g_obk[l_ac].obk02
                DISPLAY g_obk[l_ac].obk02 TO obk02
                NEXT FIELD obk02
             OTHERWISE EXIT CASE
          END CASE
 
       ON ACTION CONTROLO            #沿用所有欄位
          IF INFIELD(obk02) AND l_ac > 1 THEN
             LET g_obk[l_ac].* = g_obk[l_ac-1].*
             NEXT FIELD obk02
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
 
       ON ACTION about         
          CALL cl_about()  
 
       ON ACTION help          
          CALL cl_show_help() 
 
       ON ACTION controls                           #No.FUN-6B0032             
          CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
       END INPUT
 
    CLOSE i150_bcl
    COMMIT WORK
END FUNCTION
   
FUNCTION i150_obk02(p_cmd)  #供應廠商
    DEFINE p_cmd	LIKE type_file.chr1          #No.FUN-680104 VARCHAR(01)
    DEFINE l_occacti    LIKE occ_file.occacti        #No.FUN-680104 VARCHAR(01)
 
    LET g_errno = ' '
    SELECT occ02,occacti
       INTO g_obk[l_ac].occ02,l_occacti
       FROM occ_file
       WHERE occ01 = g_obk[l_ac].obk02
 
    CASE WHEN STATUS=100    
           #LET g_errno = 'mfg3001'     #TQC-980084 mark                                                                            
           LET g_errno = 'mfg2732'      #TQC-980084 add  
           LET  g_obk[l_ac].occ02 = NULL
         WHEN l_occacti ='N' 
           LET g_errno = '9028'
           LET  g_obk[l_ac].occ02 = NULL
        #FUN-690023------mod-------
         WHEN l_occacti MATCHES '[PH]'
              LET g_errno = '9038'
              LET  g_obk[l_ac].occ02 = NULL
        #FUN-690023------mod-------
         OTHERWISE
           LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd='d' THEN
       DISPLAY g_obk[l_ac].occ02 TO FORMONLY.occ02
    END IF
END FUNCTION
 
FUNCTION i150_b_askkey()
DEFINE
    l_wc2            LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON obk02,obk11,obk12,obk13,obk14
                 FROM s_obk[1].obk02,s_obk[1].obk11,
                      s_obk[1].obk12,s_obk[1].obk13,
                      s_obk[1].obk14
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
   
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
    
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
    CALL i150_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i150_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2            LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    LET g_sql =
       "SELECT DISTINCT obk02,occ02,obk11,obk12,obk13,obk14 ",   #CHI-BB0007 add DISTINCT 
       " FROM obk_file LEFT OUTER JOIN occ_file ON obk02 = occ01 ",
       " WHERE obk01 = '",g_obk01,"'",
       "   AND ",p_wc2 CLIPPED ,
       " ORDER BY obk02"
 
    PREPARE i150_prepare2 FROM g_sql      #預備一下
    DECLARE obk_curs CURSOR FOR i150_prepare2
    CALL g_obk.clear()
    LET g_cnt = 1
    FOREACH obk_curs INTO g_obk[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_obk.deleteElement(g_cnt)
    LET g_rec_b= g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i150_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ""
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_obk TO s_obk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()               
 
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
         CALL i150_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY       
 
      ON ACTION previous
         CALL i150_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1) 
           END IF
         ACCEPT DISPLAY         
                              
      ON ACTION jump
         CALL i150_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
         ACCEPT DISPLAY                
 
      ON ACTION next
         CALL i150_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1) 
           END IF
           ACCEPT DISPLAY            
                              
      ON ACTION last
         CALL i150_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
         ACCEPT DISPLAY                 
 
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
         CALL cl_show_fld_cont()            
         EXIT DISPLAY
 
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
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION related_document                #No.FUN-6A0160  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i150_copy()
DEFINE l_newno,l_oldno1  LIKE obk_file.obk01,
       l_n           LIKE type_file.num5,          #No.FUN-680104 SMALLINT
       l_ima02       LIKE ima_file.ima02,
       l_ima021      LIKE ima_file.ima021
 
    IF s_shut(0) THEN RETURN END IF
    IF g_obk01 IS NULL 
       THEN CALL cl_err('',-400,0)
            RETURN
    END IF
 
    DISPLAY ' ' TO obk01 
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT l_newno FROM obk01 
  
       AFTER FIELD obk01 
          IF NOT cl_null(l_newno) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(l_newno,"") THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD obk01
            END IF
#FUN-AA0059 ---------------------end-------------------------------
             SELECT count(*)
               INTO l_n
               FROM obk_file
              WHERE obk01 = l_newno 
                 IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     NEXT FIELD obk01
	         END IF	 
                 SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
                  WHERE ima01 = l_newno 
 
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err('','mfg0002',0)   #No.FUN-660115
                    CALL cl_err3("sel","ima_file",l_newno,"","mfg0002","","",1)  #No.FUN-660115
                    LET l_newno= NULL
                    NEXT FIELD obk01
                 ELSE 
                    DISPLAY l_ima02 TO FORMONLY.ima02 
                    DISPLAY l_ima021 TO FORMONLY.ima021
                 END IF
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(obk01)
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima"
#               LET g_qryparam.default1 = l_newno
#               CALL cl_create_qry() RETURNING l_newno
                CALL q_sel_ima(FALSE, "q_ima","",l_newno,"","","","","",'' ) 
                  RETURNING l_newno  
#FUN-AA0059---------mod------------end-----------------
                DISPLAY l_newno TO obk01 
                NEXT FIELD obk01
             OTHERWISE EXIT CASE
          END CASE
  
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
    IF INT_FLAG 
       THEN LET INT_FLAG = 0
          DISPLAY  g_obk01 TO obk01  
          RETURN
    END IF
 
    DROP TABLE z
    SELECT * FROM obk_file         #單身複製
     WHERE obk01 = g_obk01
      INTO TEMP z
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_obk01,SQLCA.sqlcode,0)   #No.FUN-660115
       CALL cl_err3("ins","z",g_obk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
       RETURN
    END IF
    UPDATE z
       SET obk01 = l_newno
    INSERT INTO obk_file
       SELECT * FROM z
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660115
       CALL cl_err3("ins","obk_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        
    LET l_oldno1= g_obk01
    LET g_obk01=l_newno 
    CALL i150_b()
    #LET g_obk01=l_oldno1  #FUN-C80046
    #CALL i150_show()      #FUN-C80046
END FUNCTION
 
#--------------No.MOD-7A0106 add
FUNCTION i150_combo()
   DEFINE comb_value LIKE type_file.chr1000
   DEFINE comb_item  LIKE type_file.chr1000
  
   IF g_obk[l_ac].obk13 = '1' THEN
      LET comb_value = '1,2,3'   
      SELECT ze03 INTO comb_item FROM ze_file
                  WHERE ze01='aqc-042' AND ze02=g_lang
   ELSE
      LET comb_value = '1,2,3,4'   
      SELECT ze03 INTO comb_item FROM ze_file
                  WHERE ze01='aqc-043' AND ze02=g_lang
  END IF
 
  CALL cl_set_combo_items('obk14',comb_value,comb_item)
END FUNCTION
#--------------No.MOD-7A0106 end
 
FUNCTION i150_out() 
DEFINE l_cmd  LIKE type_file.chr1000     #FUN-7C0043----add-----
#  DEFINE                                                                      
#       sr              RECORD  
#           obk01       LIKE obk_file.obk01,
#           ima02       LIKE ima_file.ima02,
#           ima021      LIKE ima_file.ima021,
#           obk02       LIKE obk_file.obk02,
#           occ02       LIKE occ_file.occ02,
#           obk11       LIKE obk_file.obk11,
#           obk12       LIKE obk_file.obk12,
#           obk13       LIKE obk_file.obk13,
#           obk14       LIKE obk_file.obk14
#                       END RECORD,
#       l_i             LIKE type_file.num5,            #No.FUN-680104 SMALLINT
#       l_name          LIKE type_file.chr20            #No.FUN-680104 VARCHAR(20)
    #FUN-7C0043---Begin
    IF cl_null(g_wc) AND NOT cl_null(g_obk01) THEN                              
       LET g_wc = " obk01 = '",g_obk01,"'"                                      
    END IF                                                                      
    IF cl_null(g_wc) THEN                                                       
       CALL cl_err('','9057',0)                                                 
       RETURN                                                                   
    END IF                                                                      
    LET l_cmd = 'p_query "aqci150" "',g_wc CLIPPED,'"'                          
    CALL cl_cmdrun(l_cmd)
    #FUN-7C0043---Begin
#   IF cl_null(g_obk01) THEN 
#      CALL cl_err('','9057',0) 
#      RETURN 
#   END IF
#   IF cl_null(g_wc) THEN
#      LET g_wc =" obk01='",g_obk01,"'"
#   END IF 
 
#   CALL cl_wait()
#   CALL cl_outnam('aqci150') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT obk01,ima02,ima021, ",
#             "obk02,occ02,obk11,obk12,obk13,obk14",
#             "  FROM obk_file,OUTER ima_file,OUTER occ_file ",
#             " WHERE obk01 = ima_file.ima01 ",
#             "   AND obk02 = occ_file.occ01 AND ",g_wc CLIPPED
#   PREPARE i150_p1 FROM g_sql              
#   IF STATUS THEN CALL cl_err('i150_p1',STATUS,0) END IF    
 
#   DECLARE i150_curs                   
#       CURSOR FOR i150_p1
 
#   START REPORT i150_rep TO l_name
 
#   FOREACH i150_curs INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i150_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i150_rep
 
#   CLOSE i150_curs
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION                                                                    
                                                                                
#REPORT i150_rep(sr)  
#  DEFINE                                                                      
#       sr              RECORD                                                                                                      
#           obk01       LIKE obk_file.obk01,                                                                                        
#           ima02       LIKE ima_file.ima02,                                                                                        
#           ima021      LIKE ima_file.ima021,                                                                                       
#           obk02       LIKE obk_file.obk02,                                                                                        
#           occ02       LIKE occ_file.occ02,                                                                                        
#           obk11       LIKE obk_file.obk11,                                                                                        
#           obk12       LIKE obk_file.obk12,                                                                                        
#           obk13       LIKE obk_file.obk13,                                                                                        
#           obk14       LIKE obk_file.obk14                                                                                         
#                       END RECORD, 
#       l_trailer_sw    LIKE type_file.chr1         #No.FUN-680104 VARCHAR(1)
#  OUTPUT                                        
#     TOP MARGIN g_top_margin                                                             
#     LEFT MARGIN g_left_margin                                                            
#     BOTTOM MARGIN g_bottom_margin                                                          
#     PAGE LENGTH g_page_line                                                  
#                                                                               
#  ORDER BY sr.obk01,sr.obk02
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno" 
#        PRINT g_head CLIPPED,pageno_total 
 
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#        PRINT ' '                                                           
#        PRINT g_dash[1,g_len]  
 
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#              g_x[36],g_x[37],g_x[38],g_x[39]
#        PRINT g_dash1 
#        LET l_trailer_sw = 'y'
#            
#     BEFORE GROUP OF sr.obk01
#        LET sr.ima02 = NULL
#        LET sr.ima021 = NULL
#        SELECT ima02,ima021 INTO sr.ima02,sr.ima021 FROM ima_file
#         WHERE ima01 = sr.obk01  
#         PRINT COLUMN g_c[31],sr.obk01,
#               COLUMN g_c[32],sr.ima02,
#               COLUMN g_c[33],sr.ima021;
#  
#       ON EVERY ROW
#          LET sr.occ02 =null  
#          SELECT occ02 INTO sr.occ02 FROM occ_file 
#           WHERE occ01 = sr.obk02
#           PRINT COLUMN g_c[34],sr.obk02,
#                 COLUMN g_c[35],sr.occ02,
#                 COLUMN g_c[36],sr.obk11,
#                 COLUMN g_c[37],sr.obk12,
#                 COLUMN g_c[38],sr.obk13,
#                 COLUMN g_c[39],sr.obk14
 
#       ON LAST ROW
#          PRINT g_dash[1,g_len]
#          LET l_trailer_sw = 'n'
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#       PAGE TRAILER
#          IF l_trailer_sw = 'y' THEN
#             PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#          ELSE
#             SKIP 2 LINE
#          END IF 
 
#END REPORT                     
