# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi123.4gl     
# Descriptions...: 產品替代群組維護作業
# Date & Author..: 05/12/23 By cl 
# Modify.........: No.FUN-640188 06/04/13 By Sarah 增加判斷,當oaz23=Y AND oaz42=1時,不可執行此程式show訊息提示
# Modify.........: No.FUN-640187 06/05/22 By Sarah 1.單頭加客戶代碼,可指定客戶,也可敲'*'表所有客戶都通用
#                                                  2.單身增加一替代順序, 只能找順序在該料號前面的料號替代
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0079 06/10/23 By Czl g_no_ask改成mi_no_ask
# Modify.........: No.FUN-6A0094 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-780095 07/09/03 By Melody Primary key
# Modify.........: No.TQC-790067 07/09/11 By lumxa 打印出的報表中，表名在制表日期下面
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出 
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: No.MOD-960292 09/06/30 By Smapmin 單頭無法update資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改	
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE                                                                          
        g_ocm01         LIKE ocm_file.ocm01,   #替代群組 (假單頭)
        g_ocm01_t       LIKE ocm_file.ocm01,   #替代群組   (舊值)
        g_ocm05         LIKE ocm_file.ocm05,   #客戶編號 (假單頭)   #FUN-640187 add
        g_ocm05_t       LIKE ocm_file.ocm05,   #客戶編號   (舊值)   #FUN-640187 add
        g_ocm03         LIKE ocm_file.ocm03,   #生效日期 (假單頭)
        g_ocm03_t       LIKE ocm_file.ocm03,   #生效日期   (舊值)
        g_ocm04         LIKE ocm_file.ocm04,   #失效日期 (假單頭)
        g_ocm04_t       LIKE ocm_file.ocm04,   #失效日期   (舊值)
        g_row_count     LIKE type_file.num5,                        #No.FUN-680137 SMALLINT
        g_ocm           DYNAMIC ARRAY OF RECORD 
             ocm02      LIKE ocm_file.ocm02,      #產品編號
             ima02      LIKE ima_file.ima02,      #品名
             ima021     LIKE ima_file.ima021,     #規格
             ocm06      LIKE ocm_file.ocm06       #替代順序   #FUN-640187 add
                        END RECORD,
        g_ocm_t         RECORD                    #(舊值)
             ocm02      LIKE ocm_file.ocm02,      #產品編號
             ima02      LIKE ima_file.ima02,      #品名
             ima021     LIKE ima_file.ima021,     #規格
             ocm06      LIKE ocm_file.ocm06       #替代順序   #FUN-640187 add
                        END RECORD, 
        g_ocm02_o       LIKE ocm_file.ocm02,    
        g_ocm06_o       LIKE ocm_file.ocm06,      #FUN-640187 add   
        g_wc,g_sql      STRING,    
        g_delete        LIKE type_file.chr1,      #No.FUN-680137   #若刪除資料,則要重新顯示筆數
        g_rec_b         LIKE type_file.num5,      #單身筆數                   #No.FUN-680137 SMALLINT
        l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
        l_ls            LIKE type_file.num5       #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE  p_row,p_col     LIKE type_file.num5       #No.FUN-680137 SMALLINT
DEFINE  g_forupd_sql    LIKE type_file.chr1000    #No.FUN-680137 SMALLINT
DEFINE  g_before_input_done LIKE type_file.num5   #No.FUN-680137 SMALLINT
#主程式開始  
DEFINE  g_cnt           LIKE type_file.num10             #總筆數              #No.FUN-680137 INTEGER
DEFINE  g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE  g_msg           LIKE type_file.chr1000                                #No.FUN-680137 VARCHAR(72)
DEFINE  g_curs_index    LIKE type_file.num10                                  #No.FUN-680137 INTEGER
DEFINE  g_jump          LIKE type_file.num10                                  #No.FUN-680137 INTEGER
DEFINE  mi_no_ask       LIKE type_file.num5                                   #No.FUN-680137 SMALLINT #No.FUN-6A0079
DEFINE  g_cnd           LIKE type_file.num10             #單身筆數            #No.FUN-680137 INTEGER
                                                                                
MAIN
 
#DEFINE                                                                           #NO.FUN-6A0094
#        l_time          LIKE type_file.chr8                #計算被使用時間    #No.FUN-680137 VARCHAR(8)  #NO.FUN-6A0094
   
    OPTIONS                                  #改變一些系統預設值 
       INPUT NO WRAP
    DEFER INTERRUPT                          #擷取中斷鍵, 由程式處理
                                                                                
    IF (NOT cl_user()) THEN  
       EXIT PROGRAM     
    END IF       
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log
                                      
    IF (NOT cl_setup("AXM")) THEN   
       EXIT PROGRAM          
    END IF   
 
    #判定產品是否可被替代(oaz23),出貨時成品替代方式(oaz42)
    SELECT oaz23,oaz42 INTO g_oaz.oaz23,g_oaz.oaz42 FROM oaz_file  #FUN-640188 add oaz42
    IF g_oaz.oaz23 = "N" THEN
       CALL cl_err("","axm-519",1)
       EXIT PROGRAM
   #start FUN-640188 add
    ELSE
       IF g_oaz.oaz23 = "Y" AND g_oaz.oaz42 = "1" THEN   #1.依產品類別
          CALL cl_err("","axm-525",1)
          EXIT PROGRAM
       END IF
   #end FUN-640188 add
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time            #計算使用時間 (進入時間)     #NO.FUN-6A0094
    LET g_ocm01   = NULL                      #清除鍵值
    LET g_ocm01_t = NULL
    LET p_row = 3 LET p_col = 17 
    OPEN WINDOW i123_w AT p_row,p_col         #顯示畫面
       WITH FORM "axm/42f/axmi123"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    LET g_delete='N'  
    CALL i123_menu() 
    CLOSE WINDOW i123_w                       #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time         #計算使用時間 (退出時間)    #NO.FUN-6A0094
END MAIN    
 
FUNCTION i123_cs()
 
    CLEAR FORM                                #清除畫面 
    CALL g_ocm.clear()  
    #螢幕上取條件
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_ocm01 TO NULL    #No.FUN-750051
   INITIALIZE g_ocm05 TO NULL    #No.FUN-750051
   INITIALIZE g_ocm03 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON ocm01,ocm05,ocm03,ocm04,ocm02            #FUN-640187 add ocm05
                 FROM ocm01,ocm05,ocm03,ocm04,s_ocm[1].ocm02   #FUN-640187 add ocm05
      
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ocm02)
#FUN-AA0059---------mod------------str-----------------             
#                  CALL cl_init_qry_var()    
#                  LET g_qryparam.form ="q_ima"
#                  LET g_qryparam.state = "c" 
#                  LET g_qryparam.default1 = g_ocm[1].ocm02 
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","",g_ocm[1].ocm02,"","","","","",'')  
                     RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO ocm02 
                  NEXT FIELD ocm02
            #start FUN-640187 add
             WHEN INFIELD(ocm05)   #客戶編號
                  CALL cl_init_qry_var()    
                  LET g_qryparam.form ="q_occ"
                  LET g_qryparam.state = "c" 
                  LET g_qryparam.default1 = g_ocm05
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ocm05 
                  NEXT FIELD ocm05
            #end FUN-640187 add
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN 
       RETURN 
    END IF
 
    LET g_sql="SELECT DISTINCT ocm01,ocm05,ocm03 ",    #FUN-640187 add ocm05,ocm03              
              "  FROM ocm_file ",                      # 組合出 SQL 指令
              " WHERE ", g_wc CLIPPED, 
              " ORDER BY ocm01 "
    PREPARE i123_prepare FROM g_sql    
    DECLARE i123_bcs          
        SCROLL CURSOR WITH HOLD FOR i123_prepare 
 
   #start FUN-640187 modify        
   #LET g_sql = "SELECT COUNT(UNIQUE ocm01) ",
   #            " FROM ocm_file WHERE ", g_wc CLIPPED
   #PREPARE i123_precount FROM g_sql   
   #DECLARE i123_count CURSOR FOR i123_precount   
    DROP TABLE count_tmp
    LET g_sql="SELECT DISTINCT ocm01,ocm05,ocm03 ",
              "  FROM ocm_file ",
              " WHERE ", g_wc CLIPPED,
              " INTO TEMP count_tmp"
    PREPARE i123_cnt_tmp FROM g_sql
    EXECUTE i123_cnt_tmp
    DECLARE i123_count CURSOR FOR SELECT COUNT(*) FROM count_tmp
   #end FUN-640187 modify        
                                                                                
END FUNCTION                           
 
FUNCTION i123_menu()
    WHILE TRUE
       CALL i123_bp("G")
       CASE g_action_choice 
            WHEN "insert"                                                        
               IF cl_chk_act_auth() THEN 
                   CALL i123_a()     
               END IF        
            WHEN "query"                
               IF cl_chk_act_auth() THEN  
                   CALL i123_q()                
               END IF                                                              
            WHEN "modify"                                                       
               IF cl_chk_act_auth() THEN  
                    CALL i123_u()                                                  
               END IF                                                              
            WHEN "detail"                                                        
               IF cl_chk_act_auth() THEN                                           
                   CALL i123_b()                                                   
               ELSE                                                                
                  LET g_action_choice = NULL  
               END IF                         
            WHEN "delete"                  
               IF cl_chk_act_auth() THEN                                           
                   CALL i123_r()                                                   
               END IF                                                              
            WHEN "reproduce"     
               IF cl_chk_act_auth() THEN                                          
                  CALL i123_copy()                                                
               END IF                                                             
            WHEN "output"          
               IF cl_chk_act_auth()  THEN 
                  CALL i123_out()                                             
               END IF                                                              
            WHEN "help"                                                          
               CALL cl_show_help()                                                 
            WHEN "exit"                                                          
               EXIT WHILE                                                          
            WHEN "controlg"                                                      
               CALL cl_cmdask()    
            #No.FUN-6A0020-------add--------str----
            WHEN "related_document"           #相關文件
             IF cl_chk_act_auth() THEN
                IF g_ocm01 IS NOT NULL THEN
                   LET g_doc.column1 = "ocm01"
                   LET g_doc.column2 = "ocm03"
                   LET g_doc.column3 = "ocm05"
                   LET g_doc.value1 = g_ocm01
                   LET g_doc.value2 = g_ocm03
                   LET g_doc.value3 = g_ocm05
                   CALL cl_doc()
                END IF 
             END IF
            #No.FUN-6A0020-------add--------end----                                                                 
       END CASE   
    END WHILE  
END FUNCTION   
 
FUNCTION i123_a()
    
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    LET g_row_count  = 0
    LET g_curs_index = 0 
    CALL cl_navigator_setting( g_curs_index, g_row_count )  
 
    MESSAGE ""      
    CLEAR FORM 
    CALL g_ocm.clear()   
    LET g_ocm01 = NULL
    LET g_ocm05 = '*'   #FUN-640187 add
    LET g_ocm03 = g_today
    LET g_ocm04 = NULL
    LET g_ocm04_t = NULL
    LET g_cnt   = 1 
    DISPLAY g_cnt TO cnt
    DISPLAY g_ocm05 TO ocm05   #FUN-640187 add 
    DISPLAY g_ocm03 TO ocm03    
    DISPLAY g_ocm04 TO ocm04  
    #預設值及將數值類變數清成零   
    CALL cl_opmsg('a')
          
    WHILE TRUE      
        CALL i123_i("a")                   #輸入單頭     
 
        IF INT_FLAG THEN                   #使用者不玩
           CLEAR FORM     
           LET INT_FLAG = 0     
           CALL cl_err('',9001,0)
           EXIT WHILE    
        END IF     
 
        IF cl_null(g_ocm01) THEN
           CONTINUE WHILE
        END IF
 
        LET g_rec_b = 0   
        CALL i123_b()                      #輸入單身
        LET g_ocm01_t = g_ocm01            #保留舊
        EXIT WHILE                              
    END WHILE 
END FUNCTION    
 
FUNCTION i123_u()
                     
    IF s_shut(0) THEN RETURN END IF                #檢查權限   
    IF g_ocm01 IS NULL THEN    
        CALL cl_err('',-400,0)   
        RETURN
    END IF         
    MESSAGE "" 
    CALL cl_opmsg('u')
    LET g_ocm01_t = g_ocm01
    #-----MOD-960292---------
    LET g_ocm05_t = g_ocm05
    LET g_ocm03_t = g_ocm03
    LET g_ocm04_t = g_ocm04
    #-----END MOD-960292-----
    BEGIN WORK
    
    WHILE TRUE    
       CALL i123_i("u")                      #欄位更改
       IF INT_FLAG THEN
          LET g_ocm01= g_ocm01_t 
          #-----MOD-960292---------
          LET g_ocm05= g_ocm05_t 
          LET g_ocm03= g_ocm03_t 
          LET g_ocm04= g_ocm04_t 
          #-----END MOD-960292----- 
          LET INT_FLAG = 0 
          CALL cl_err('',9001,0)
          EXIT WHILE      
       END IF 
      
      #start FUN-640187 modify                                 
      #IF g_ocm01 != g_ocm01_t OR g_ocm03 != g_ocm03_t OR g_ocm04 != g_ocm04_t THEN
       #IF g_ocm01 != g_ocm01_t OR g_ocm05 != g_ocm05_t OR    #MOD-960292
       #   g_ocm03 != g_ocm03_t OR g_ocm04 != g_ocm04_t THEN   #MOD-960292
      #end FUN-640187 modify                                 
          UPDATE ocm_file SET ocm01 = g_ocm01,
                              ocm05 = g_ocm05,   #FUN-640187 add 
                              ocm03 = g_ocm03, 
                              ocm04 = g_ocm04  
                        WHERE ocm01 = g_ocm01_t   
                          AND ocm05 = g_ocm05_t   
                          AND ocm03 = g_ocm03_t   
          IF SQLCA.sqlcode THEN   
#            CALL cl_err('',SQLCA.sqlcode,0)      #No.FUN-660167
             CALL cl_err3("upd","ocm_file",g_ocm01_t,g_ocm05_t,SQLCA.sqlcode,"","",1)  #No.FUN-660167
             CONTINUE WHILE  
          END IF
          MESSAGE'UPDATE O.K!!!'  
       #END IF   #MOD-960292 
          EXIT WHILE  
    END WHILE  
    COMMIT WORK 
END FUNCTION             
 
 
#處理INPUT                                                                      
FUNCTION i123_i(p_cmd)
DEFINE  p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改             #No.FUN-680137 VARCHAR(1)
        l_ocm02         LIKE ocm_file.ocm02,
        l_n             LIKE type_file.num5,                 #No.FUN-680137 SMALLINT
        l_occ02         LIKE occ_file.occ02                  #FUN-640187 add 
 
    DISPLAY g_ocm01,g_ocm05,g_ocm03,g_ocm04                  #FUN-640187 add g_ocm05
         TO ocm01,ocm05,ocm03,ocm04                          #FUN-640187 add ocm05
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT g_ocm01,g_ocm05,g_ocm03,g_ocm04  WITHOUT DEFAULTS   #FUN-640187 add g_ocm05 
          FROM ocm01,ocm05,ocm03,ocm04                        #FUN-640187 add ocm05
    
        BEFORE INPUT     
           LET g_before_input_done = FALSE    
           CALL i123_set_entry(p_cmd)      
           CALL i123_set_no_entry(p_cmd)    
           LET g_before_input_done = TRUE 
         
        AFTER FIELD ocm01       #替代群組
           IF cl_null(g_ocm01) THEN
              CALL cl_err(g_ocm01,"lib-033",0)
              LET g_ocm01=g_ocm01_t
              DISPLAY BY NAME g_ocm01
              NEXT FIELD ocm01
           END IF
           IF NOT cl_null(g_ocm01) THEN
             #start FUN-640187 mark
             #IF p_cmd = "a" OR        
             #   (p_cmd = "u" AND g_ocm01 != g_ocm01_t) THEN
             #   SELECT count(*) INTO l_n FROM ocm_file WHERE ocm01 = g_ocm01
             #   IF l_n > 0 THEN
             #      CALL cl_err(g_ocm01,-239,1)
             #      LET g_ocm01=g_ocm01_t
             #      DISPLAY BY NAME g_ocm01
             #      NEXT FIELD ocm01    
             #   END IF
             #END IF
             #end FUN-640187 mark
           END IF   
 
       #start FUN-640187 add
        AFTER FIELD ocm05
           IF NOT cl_null(g_ocm05) THEN
              IF g_ocm05 != '*' THEN
                 LET l_occ02 = ' '
                 SELECT occ02 INTO l_occ02 FROM occ_file
                  WHERE occ01=g_ocm05 AND occacti='Y'
                 IF SQLCA.SQLCODE  THEN  #No.7926
#                   CALL cl_err('select occ',SQLCA.SQLCODE,1)   #No.FUN-660167
                    CALL cl_err3("sel","occ_file",g_ocm05,"",SQLCA.SQLCODE,"","select occ",1)  #No.FUN-660167
                    NEXT FIELD ocm05
                 END IF
                 MESSAGE l_occ02 CLIPPED
              END IF
           END IF
       #end FUN-640187 add
           
        AFTER FIELD ocm03     #生效日期不可為空
           IF g_ocm03 IS NULL THEN
              LET g_ocm03 = g_today
              DISPLAY BY NAME g_ocm03
              NEXT FIELD ocm03
             #start FUN-640187 mark
              IF p_cmd = "a" OR        
                 (p_cmd = "u" AND (g_ocm01 != g_ocm01_t OR 
                                   g_ocm05 != g_ocm05_t OR
                                   g_ocm03 != g_ocm03_t)) THEN
                 SELECT count(*) INTO l_n FROM ocm_file 
                  WHERE ocm01 = g_ocm01 AND ocm05 = g_ocm05 AND ocm03 = g_ocm03
                 IF l_n > 0 THEN
                    CALL cl_err(g_ocm01,-239,1)
                    LET g_ocm03=g_ocm03_t
                    DISPLAY BY NAME g_ocm03
                    NEXT FIELD ocm03    
                 END IF
              END IF
             #end FUN-640187 mark
           END IF
      
        AFTER INPUT
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
 
           #失效日期不可早于生效日期  
           #LET g_ocm04_t = g_ocm04   #MOD-960292                                                              
           IF g_ocm04 < g_ocm03 THEN                                                                                                
              LET g_ocm04 = g_ocm04_t                                                                                               
              DISPLAY BY NAME g_ocm04                                                                                               
              CALL cl_err(g_ocm04,"axm-522",1)                                                                                      
              NEXT FIELD ocm04                                                                                                      
           END IF         
    
       #start FUN-640187 add  
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ocm05)   #客戶編號
                   CALL cl_init_qry_var()    
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.default1 = g_ocm05
                   CALL cl_create_qry() RETURNING g_ocm05
                   DISPLAY BY NAME g_ocm05
                   NEXT FIELD ocm05
           END CASE     
       #end FUN-640187 add  
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLF                  #欄位說明      
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #add on 040913   
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
       
        #--NO.MOD-860078---                                                                        
        ON IDLE g_idle_seconds                                                   
           CALL cl_on_idle()                                                     
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg      
           CALL cl_cmdask()     
        #--NO.MOD-860078---                                                                        
 
    END INPUT                                                                   
END FUNCTION            
 
FUNCTION i123_q()    
     
    IF s_shut(0) THEN RETURN END IF                #檢查權限 
 
    LET g_row_count  = 0  
    LET g_curs_index = 0          
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ocm01 TO NULL             #No.FUN-6A0020 
    INITIALIZE g_ocm03 TO NULL             #No.FUN-6A0020 
    INITIALIZE g_ocm05 TO NULL             #No.FUN-6A0020 
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_ocm.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    DISPLAY '   ' TO FORMONLY.cnd
    CALL i123_cs()                         #取得查詢條件 
 
    IF INT_FLAG THEN                       #使用者不玩了
       LET INT_FLAG = 0 
       CLEAR FORM 
       RETURN  
    END IF                         
 
    OPEN i123_count          
  
    FETCH i123_count INTO g_row_count 
    DISPLAY g_row_count TO FORMONLY.cnt 
    IF g_row_count != 0 THEN
       OPEN i123_bcs                    #從DB產生合乎條件TEMP(0-30秒)
 
       IF SQLCA.sqlcode  THEN        #有問題  
          CALL cl_err('',SQLCA.sqlcode,0)   
          INITIALIZE g_ocm01 TO NULL        
        ELSE 
          CALL i123_fetch('F')            #讀出TEMP第一筆并顯示
        END IF
     ELSE
        MESSAGE 'NO FOUND!'
        LET g_ocm01 = NULL
        DISPLAY g_ocm01 TO ocm01
        DISPLAY ' ' TO cnt
     END IF
END FUNCTION                                    
                      
FUNCTION i123_fetch(p_flag)                
DEFINE    p_flag          LIKE type_file.chr1                  #處理方式          #No.FUN-680137 VARCHAR(1)
 
    MESSAGE ""    
    CASE p_flag            
        WHEN 'N' FETCH NEXT     i123_bcs INTO g_ocm01,g_ocm05,g_ocm03   #FUN-640187 add g_ocm05,g_ocm03
        WHEN 'P' FETCH PREVIOUS i123_bcs INTO g_ocm01,g_ocm05,g_ocm03   #FUN-640187 add g_ocm05,g_ocm03
        WHEN 'F' FETCH FIRST    i123_bcs INTO g_ocm01,g_ocm05,g_ocm03   #FUN-640187 add g_ocm05,g_ocm03
        WHEN 'L' FETCH LAST     i123_bcs INTO g_ocm01,g_ocm05,g_ocm03   #FUN-640187 add g_ocm05,g_ocm03
        WHEN '/'    
           IF (NOT mi_no_ask) THEN     #No.FUN-6A0079
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
           
           FETCH ABSOLUTE g_jump i123_bcs INTO g_ocm01,g_ocm05,g_ocm03   #FUN-640187 add g_ocm05,g_ocm03
           LET mi_no_ask = FALSE                #No.FUN-6A0079
    END CASE
                                                                                
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_ocm01,SQLCA.sqlcode,0)       
       INITIALIZE g_ocm01 TO NULL  #TQC-6B0105
       INITIALIZE g_ocm03 TO NULL  #TQC-6B0105
       INITIALIZE g_ocm05 TO NULL  #TQC-6B0105
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
    
    SELECT UNIQUE ocm03,ocm04
             INTO g_ocm03,g_ocm04
      FROM ocm_file
     WHERE ocm01= g_ocm01
       AND ocm05= g_ocm05 AND ocm03 = g_ocm03   #FUN-640187 add
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ocm01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","ocm_file",g_ocm01,g_ocm05,SQLCA.sqlcode,"","",1)  #No.FUN-660167
       RETURN 
    END IF
 
    CALL i123_show()                                                                      
END FUNCTION   
 
FUNCTION i123_show() 
    DISPLAY g_ocm01 TO ocm01
    DISPLAY g_ocm05 TO ocm05   #FUN-640187 add
    DISPLAY g_ocm03 TO ocm03
    DISPLAY g_ocm04 TO ocm04
    CALL i123_b_fill(g_wc)                 #單身 
END FUNCTION  
 
FUNCTION i123_ima(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021
    
    SELECT ima02, ima021 INTO l_ima02, l_ima021 FROM ima_file 
    WHERE ima01=g_ocm[l_ac].ocm02
   
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-118'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
         OTHERWISE LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       LET g_ocm[l_ac].ima02 = l_ima02
       LET g_ocm[l_ac].ima021= l_ima021   
    END IF
 
END FUNCTION
 
FUNCTION i123_r()  
                                                                                
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_ocm01 IS NULL THEN
       CALL cl_err('',-400,1)
       RETURN       
    END IF
 
    BEGIN WORK  
    CALL i123_show() 
    IF cl_delh(0,0) THEN             #del group一下 
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ocm01"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ocm03"      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "ocm05"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ocm01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ocm03       #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_ocm05       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()          #No.FUN-9B0098 10/02/24
       DELETE FROM ocm_file   
        WHERE ocm01 = g_ocm01
          AND ocm05 = g_ocm05 AND ocm03 = g_ocm03   #FUN-640187 add 
       IF SQLCA.sqlcode THEN 
#         CALL cl_err(g_ocm01,SQLCA.sqlcode,0)      #No.FUN-660167
          CALL cl_err3("del","ocm_file",g_ocm01,g_ocm05,SQLCA.sqlcode,"","",1)  #No.FUN-660167
       ELSE 
          CLEAR FORM  
          CALL g_ocm.clear()
          LET g_delete='Y' 
          MESSAGE 'DELETE O.K!!!'    
          OPEN i123_count
          #FUN-B50064-add-start--
          IF STATUS THEN
             CLOSE i123_bcs
             CLOSE i123_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          FETCH i123_count INTO g_row_count
          #FUN-B50064-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i123_bcs
             CLOSE i123_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i123_bcs
          IF g_curs_index = g_row_count + 1 THEN 
             LET g_jump = g_row_count 
             CALL i123_fetch('L')
          ELSE   
             LET g_jump = g_curs_index  
             LET mi_no_ask = TRUE           #No.FUN-6A0079
             CALL i123_fetch('/')   
          END IF                              
       END IF                        
    END IF
    COMMIT WORK                     
END FUNCTION                  
                                                                                
#單身                                                                           
FUNCTION i123_b()                                                               
DEFINE                                  
          l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680137 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重復用         #No.FUN-680137 SMALLINT
          l_str           LIKE type_file.chr20,                                   #No.FUN-680137 VARCHAR(20) 
          l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680137 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,                #可新增否           #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5,                #可刪除             #No.FUN-680137 SMALLINT
          l_no            LIKE type_file.num5                                     #No.FUN-680137 SMALLINT
    
    LET g_action_choice = ""              
    IF s_shut(0) THEN RETURN END IF                #檢查權限  
    IF g_ocm01 IS NULL  THEN
       CALL cl_err('',-400,1) 
       RETURN      
    END IF    
          
    CALL cl_opmsg('b')                      
   
    LET g_forupd_sql = "SELECT ocm02,'','',ocm06 ",    #FUN-640187 add ocm06
                       "  FROM ocm_file ", 
                       "  WHERE ocm01=? ",
                       "   AND ocm05=? ",   #FUN-640187 add
                       "   AND ocm03=? ",   #FUN-640187 add 
                       "   AND ocm02=? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i123_bcl CURSOR FROM g_forupd_sql 
    
    LET l_ac_t=0           
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete") 
 
    INPUT ARRAY g_ocm WITHOUT DEFAULTS FROM s_ocm.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
    
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
              LET g_ocm_t.* = g_ocm[l_ac].*      #BACKUP    
              LET g_ocm02_o = g_ocm[l_ac].ocm02  #BACKUP
              LET g_ocm06_o = g_ocm[l_ac].ocm06  #BACKUP   #FUN-640187 add
              OPEN i123_bcl USING g_ocm01,g_ocm05,g_ocm03,g_ocm_t.ocm02   #FUN-640187 add g_ocm05,g_ocm03
              IF STATUS THEN
                  CALL cl_err("OPEN i123_bcl:",STATUS,1)
                  LET l_lock_sw = "Y"
              ELSE               
              FETCH i123_bcl INTO g_ocm[l_ac].*  
                IF SQLCA.sqlcode THEN 
                   CALL cl_err(g_ocm_t.ocm02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"            
                ELSE
                   LET g_ocm_t.* = g_ocm[l_ac].*      #BACKUP 
                   LET g_ocm02_o = g_ocm[l_ac].ocm02  #BACKUP
                   LET g_ocm06_o = g_ocm[l_ac].ocm06  #BACKUP   #FUN-640187 add
                END IF
              END IF  
              CALL i123_ima('d')
           END IF  
    
        BEFORE INSERT    
           LET l_n = ARR_COUNT()  
           LET p_cmd='a'    
           INITIALIZE g_ocm[l_ac].* TO NULL      
           LET g_ocm[l_ac].ocm06 = 99   #FUN-640187 add
           LET g_ocm_t.* = g_ocm[l_ac].*         #新輸入資料
           NEXT FIELD ocm02 
             
        AFTER FIELD ocm02
            IF NOT cl_null(g_ocm[l_ac].ocm02) AND
               (g_ocm[l_ac].ocm02 != g_ocm_t.ocm02 OR
                g_ocm_t.ocm02 IS NULL) THEN
#FUN-AA0059 ---------------------start----------------------------
                IF NOT s_chk_item_no(g_ocm[l_ac].ocm02,"") THEN
                   CALL cl_err('',g_errno,1)
                   LET g_ocm[l_ac].ocm02= g_ocm_t.ocm02
                   NEXT FIELD ocm02
                END IF
#FUN-AA0059 ---------------------end-------------------------------
                LET l_no=0
               
                SELECT COUNT(*) INTO l_no FROM ima_file 
                      WHERE ima01= g_ocm[l_ac].ocm02
                IF l_no= 0 THEN 
                    CALL cl_err(g_ocm[l_ac].ocm02,"mfg9329",1)
                    LET g_ocm[l_ac].ocm02 = g_ocm_t.ocm02 
                    NEXT FIELD ocm02
                END IF    
 
                SELECT count(*) INTO l_no FROM ocm_file
                 WHERE ocm01 = g_ocm01
                   AND ocm05 = g_ocm05   #FUN-640187 add
                   AND ocm03 = g_ocm03   #FUN-640187 add
                   AND ocm02 = g_ocm[l_ac].ocm02
                IF l_no > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ocm[l_ac].ocm02 = g_ocm_t.ocm02
                    NEXT FIELD ocm02
                END IF
                CALL i123_ima('d')   #FUN-640187 add
            END IF       
 
       #start FUN-640187 add
        AFTER FIELD ocm06
           IF g_ocm[l_ac].ocm06 <0 THEN
              CALL cl_err(g_ocm[l_ac].ocm06,'mfg3291',1)
              NEXT FIELD ocm06
           END IF
       #end FUN-640187 add
        
        AFTER INSERT 
           IF INT_FLAG THEN 
              CALL cl_err('',9001,0)   
              LET INT_FLAG = 0 
              CANCEL INSERT  
           END IF 
          #TQC-780095 
           IF cl_null(g_ocm01) THEN LET g_ocm01=' ' END IF
           IF cl_null(g_ocm[l_ac].ocm02) THEN LET g_ocm[l_ac].ocm02=' ' END IF
           IF cl_null(g_ocm03) THEN LET g_ocm03=0 END IF #日期 default 給0 (kim)#
           IF cl_null(g_ocm05) THEN LET g_ocm05=' ' END IF
          #TQC-780095 
           INSERT INTO ocm_file(ocm01,ocm02,ocm03,ocm04,ocm05,ocm06)                            #FUN-640187 add ocm05,ocm06
                  VALUES(g_ocm01,g_ocm[l_ac].ocm02,g_ocm03,g_ocm04,g_ocm05,g_ocm[l_ac].ocm06)   #FUN-640187 add g_ocm05,g_ocm[l_ac].ocm06
           IF SQLCA.sqlcode THEN                    
#             CALL cl_err(g_ocm[l_ac].ocm02,SQLCA.sqlcode,0)   #No.FUN-660167
              CALL cl_err3("ins","ocm_file",g_ocm01,g_ocm[l_ac].ocm02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
              LET g_ocm[l_ac].* = g_ocm_t.*
              CANCEL INSERT 
           ELSE
              CALL i123_ima('d') 
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO cnd
              COMMIT WORK
           END IF 
           
        BEFORE DELETE                         #是否取消單身
           IF g_ocm[l_ac].ocm02 IS NOT NULL AND g_ocm_t.ocm02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN 
                 CANCEL DELETE       
              END IF     
              IF l_lock_sw = "Y" THEN       
                 CALL cl_err("", -263, 1)  
                 CANCEL DELETE      
              END IF
              DELETE FROM ocm_file  
               WHERE ocm01 = g_ocm01  
                 AND ocm02 = g_ocm_t.ocm02  
              IF SQLCA.sqlcode THEN 
#                CALL cl_err(g_ocm_t.ocm02,SQLCA.sqlcode,0)    #No.FUN-660167
                 CALL cl_err3("del","ocm_file",g_ocm01,g_ocm_t.ocm02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                 ROLLBACK WORK 
                 CANCEL DELETE 
              END IF 
              LET g_rec_b=g_rec_b-1 
              MESSAGE "Delete Ok" 
              DISPLAY g_rec_b TO FORMONLY.cnd
           END IF 
           COMMIT WORK 
                                                                                
        ON ROW CHANGE
           CALL i123_ima('d')  
           IF INT_FLAG THEN 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ocm[l_ac].* = g_ocm_t.*
              CALL i123_ima('d') 
              CLOSE i123_bcl
              ROLLBACK WORK  
              EXIT INPUT
           END IF         
           IF l_lock_sw = 'Y' THEN   
              CALL cl_err(g_ocm[l_ac].ocm02,-263,1)  
              LET g_ocm[l_ac].* = g_ocm_t.*
           ELSE
              UPDATE ocm_file SET ocm02 = g_ocm[l_ac].ocm02, 
                                  ocm06 = g_ocm[l_ac].ocm06   #FUN-640187 add
                WHERE ocm01=g_ocm01 
                  AND ocm05=g_ocm05
                  AND ocm03=g_ocm03
                  AND ocm02=g_ocm02_o
 
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_ocm[l_ac].ocm02,SQLCA.sqlcode,0)   #No.FUN-660167
                 CALL cl_err3("upd","ocm_file",g_ocm01,g_ocm02_o,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                 LET g_ocm[l_ac].* = g_ocm_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K' 
                 COMMIT WORK 
              END IF 
           END IF                                                               
                                                                                
        AFTER ROW  
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30034 mark
           IF INT_FLAG THEN 
              CALL cl_erR('',9001,0)  
              LET INT_FLAG = 0 
              IF p_cmd = 'u' THEN 
                 LET g_ocm[l_ac].* = g_ocm_t.* 
                 CALL i123_ima('d') 
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_ocm.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF 
              CLOSE i123_bcl  
              ROLLBACK WORK   
              EXIT INPUT 
           END IF
           LET l_ac_t = l_ac   #FUN-D30034 add 
           CLOSE i123_bcl 
           COMMIT WORK
      
        ON ACTION CONTROLP   
           CASE                                                                 
              WHEN INFIELD(ocm02) 
#FUN-AA0059---------mod------------str-----------------                                   
#                 CALL cl_init_qry_var()                                         
#                 LET g_qryparam.form ="q_ima" 
#                 LET g_qryparam.default1 = g_ocm[l_ac].ocm02
#                 CALL cl_create_qry() RETURNING g_ocm[l_ac].ocm02  
                  CALL q_sel_ima(FALSE, "q_ima","",g_ocm[l_ac].ocm02,"","","","","",'' )
                    RETURNING  g_ocm[l_ac].ocm02
#FUN-AA0059---------mod------------end-----------------
  
                 DISPLAY BY NAME g_ocm[l_ac].ocm02
                 CALL i123_ima('d')
                 NEXT FIELD ocm02
           END CASE
 
        ON ACTION controls                             #No.FUN-6A0092
           CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
                                                                        
        ON ACTION CONTROLR  
           CALL cl_show_req_fields() 
 
        ON ACTION CONTROLG 
           CALL cl_cmdask() 
 
        ON ACTION CONTROLF  
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
    
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about        
           CALL cl_about()  
                                                                             
        ON ACTION help         
           CALL cl_show_help()  
                                                                                
                                                                                
    END INPUT                                                                   
                                                                                
    CLOSE i123_bcl
    COMMIT WORK  
#   CALL i123_delall() #CHI-C30002 mark
    CALL i123_delHeader()     #CHI-C30002 add
END FUNCTION        
 
#CHI-C30002 -------- add -------- begin
FUNCTION i123_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM ocm_file WHERE ocm01 = g_ocm01
         LET g_ocm01 = NULL
         LET g_ocm03 = NULL
         LET g_ocm04 = NULL
         LET g_ocm05 = NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i123_delall()
#   SELECT COUNT(*) INTO g_cnt
#     FROM ocm_file  
#    WHERE ocm01 = g_ocm01 
#   IF g_cnt = 0 THEN                      # 未輸入單身資料, 是否取消單頭資料 
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg 
#      ERROR g_msg CLIPPED 
#      DELETE FROM ocm_file
#       WHERE ocm01 = g_ocm01 
#      CLEAR FORM
#   END IF   
#END FUNCTION    
#CHI-C30002 -------- mark -------- end
 
FUNCTION i123_b_fill(p_wc)            
DEFINE
        p_wc            LIKE type_file.chr1000,        #No.FUN-680137  VARCHAR(200)
        l_aa            LIKE type_file.chr4              #No.FUN-680137  VARCHAR(4)
      
    LET g_sql = "SELECT ocm02,'','',ocm06 ",    #FUN-640187 add ocm06
                "  FROM ocm_file ",                                             
                " WHERE ocm01 = '",g_ocm01,"'",
                "   AND ocm05 = '",g_ocm05,"'",   #FUN-640187 add
                "   AND ocm03 = '",g_ocm03,"'",   #FUN-640187 add
                "   AND ",p_wc CLIPPED ,
                " ORDER BY ocm02" 
    PREPARE i123_prepare2 FROM g_sql      #預備一下 
    DECLARE ocm_cs CURSOR FOR i123_prepare2 
    CALL g_ocm.clear()
    LET g_cnt = 1 
    LET g_rec_b=0 
   
    FOREACH ocm_cs INTO g_ocm[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
 
       LET l_ac= g_cnt
       CALL i123_ima('d')
 
       IF g_cnt > g_max_rec THEN  
       CALL cl_err( '', 9035, 0 )   
          EXIT FOREACH            
       END IF  
 
       LET g_cnt = g_cnt + 1    
    END FOREACH 
 
    CALL g_ocm.deleteElement(g_cnt) 
    LET g_rec_b = g_cnt - 1              
    DISPLAY g_rec_b TO FORMONLY.cnd 
    LET g_cnt = 0 
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i123_bp(p_ud) 
DEFINE         p_ud            LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
    
    IF p_ud <> "G" OR g_action_choice = "detail" THEN 
        RETURN   
    END IF  
    
    LET g_action_choice = " " 
    
    CALL cl_set_act_visible("accept,cancel", FALSE) 
    DISPLAY ARRAY g_ocm TO s_ocm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
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
      ON ACTION modify                                                          
         LET g_action_choice="modify"                                           
         EXIT DISPLAY                                                           
      ON ACTION first                                                           
         CALL i123_fetch('F')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN                                                 
         CALL fgl_set_arr_curr(1) 
           END IF  
         ACCEPT DISPLAY                 
                                                                                
      ON ACTION previous                                                        
         CALL i123_fetch('P') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN    
         CALL fgl_set_arr_curr(1)  
           END IF                                                               
         ACCEPT DISPLAY                  
                                                                                
      ON ACTION jump                                                            
         CALL i123_fetch('/')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN 
         CALL fgl_set_arr_curr(1) 
           END IF        
         ACCEPT DISPLAY                  
 
      ON ACTION next 
         CALL i123_fetch('N') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN 
         CALL fgl_set_arr_curr(1) 
           END IF                                                               
         ACCEPT DISPLAY                 
                                                                                
      ON ACTION last  
         CALL i123_fetch('L') 
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
 
      ON ACTION exit              
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION controlg                                                        
         LET g_action_choice="controlg"                                         
         EXIT DISPLAY                                                           
                                                                                
      #--NO.MOD-860078---                                                                        
      ON IDLE g_idle_seconds                                                   
         CALL cl_on_idle()                                                     
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      #--NO.MOD-860078---                                                                        
 
      ON ACTION accept                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION cancel 
         LET INT_FLAG=FALSE                
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                                                                                   
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY                                                                            
 
      AFTER DISPLAY   
         CONTINUE DISPLAY     
                                                                                
         EXIT DISPLAY  
    END DISPLAY 
    CALL cl_set_act_visible("accept,cancel", TRUE)    
END FUNCTION         
 
FUNCTION i123_copy()
DEFINE  l_newno    LIKE ocm_file.ocm01,
        l_oldno    LIKE ocm_file.ocm01, 
        l_ocm05    LIKE ocm_file.ocm05,   #FUN-640187 add
        l_ocm05_e  LIKE ocm_file.ocm05,   #FUN-640187 add 
        l_ocm03    LIKE ocm_file.ocm03, 
        l_ocm03_e  LIKE ocm_file.ocm03,  
        l_ocm04    LIKE ocm_file.ocm04, 
        l_ocm04_e  LIKE ocm_file.ocm04,
        l_n        LIKE type_file.num5                 #FUN-640187 add        #No.FUN-680137 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ocm01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
  
    LET g_before_input_done =  FALSE
    CALL i123_set_entry('a')
 
    LET l_oldno   = g_ocm01 # BACKUP
    LET l_ocm05_e = g_ocm05   #FUN-640187 add
    LET l_ocm03_e = g_ocm03
    LET l_ocm04_e = g_ocm04
    LET l_newno   = g_ocm01
    LET l_ocm05   = g_ocm05   #FUN-640187 add
    LET l_ocm03   = g_ocm03
    LET l_ocm04   = g_ocm04
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT l_newno,l_ocm05,l_ocm03,l_ocm04 WITHOUT DEFAULTS   #FUN-640187 add l_ocm05
          FROM ocm01,ocm05,ocm03,ocm04                       #FUN-640187 add ocm05
       
       #start FUN-640187 add  
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ocm05)   #客戶編號
                   CALL cl_init_qry_var()    
                   LET g_qryparam.form ="q_occ"
                   LET g_qryparam.default1 = l_ocm05
                   CALL cl_create_qry() RETURNING l_ocm05
                   DISPLAY BY NAME l_ocm05
                   NEXT FIELD ocm05
           END CASE     
       #end FUN-640187 add  
 
        AFTER FIELD ocm01
          #start FUN-640187 modify
          #IF NOT cl_null(l_newno) THEN
          #   SELECT count(*) INTO g_cnt FROM ocm_file WHERE ocm01=l_newno
          #   IF g_cnt > 0 THEN
          #      CALL cl_err(l_newno,-239,0)
          #      NEXT FIELD ocm01
          #   END IF
          #END IF
           IF cl_null(l_newno) THEN
              CALL cl_err(l_newno,"lib-033",1)
              NEXT FIELD ocm01
           END IF
          #end FUN-640187 modify
 
       #start FUN-640187 add
        AFTER FIELD ocm05     #客戶編號不可為空  
           IF l_ocm05 IS NULL THEN    
              LET l_ocm05 = g_today  
              DISPLAY BY NAME l_ocm05 
              NEXT FIELD ocm05  
           END IF             
       #end FUN-640187 add
 
        AFTER FIELD ocm03     #生效日期不可為空  
           IF l_ocm03 IS NULL THEN    
              SELECT count(*) INTO l_n FROM ocm_file 
               WHERE ocm01 = l_newno AND ocm05 = l_ocm05 AND ocm03 = l_ocm03
              IF l_n > 0 THEN
                 CALL cl_err(l_newno,-239,1)
                 NEXT FIELD ocm03    
              ELSE
                 LET l_ocm03 = g_today  
                 DISPLAY BY NAME l_ocm03 
                 NEXT FIELD ocm03  
              END IF
           END IF             
      
        AFTER INPUT
     #   AFTER FIELD ocm04      #失效日期不可早于生效日期  
           IF l_ocm04 < l_ocm03 THEN    
              LET g_ocm04 = l_ocm04_e  
              DISPLAY BY NAME l_ocm04 
              CALL cl_err(l_ocm04,"axm-522",1) 
              NEXT FIELD ocm04    
           END IF           
 
        #--NO.MOD-860078---                                                                        
        ON IDLE g_idle_seconds                                                   
           CALL cl_on_idle()                                                     
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg      
           CALL cl_cmdask()     
        #--NO.MOD-860078---                                                                        
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_ocm01 = l_oldno
       CALL i123_show()
       RETURN
    END IF
 
    BEGIN WORK
 
    DROP TABLE x
    SELECT * FROM ocm_file
       WHERE ocm01=g_ocm01 
     INTO TEMP x
 
    IF STATUS THEN                                                              
#      CALL cl_err('',STATUS,0)                                             #No.FUN-660167
       CALL cl_err3("ins","x",g_ocm01,"",STATUS,"","",1)  #No.FUN-660167
       ROLLBACK WORK                                                            
       RETURN                                                                   
    END IF 
 
    UPDATE x
       SET ocm01= l_newno,
           ocm05= l_ocm05,   #FUN-640187 add
           ocm03= l_ocm03,
           ocm04= l_ocm04 
 
    INSERT INTO ocm_file
         SELECT * FROM x
    IF SQLCA.sqlcode THEN 
       CALL cl_err3("ins","ocm_file",l_newno,l_ocm05,SQLCA.sqlcode,"","",1)
       ROLLBACK WORK
#      CALL cl_err(g_ocm01,SQLCA.sqlcode,0)   #No.FUN-660167
   #   CALL cl_err3("ins","ocm_file",l_newno,l_ocm05,SQLCA.sqlcode,"","",1)  #No.FUN-660167   #FUN-B80089   MARK
       RETURN   
    ELSE
       COMMIT WORK
       DROP TABLE x
    END IF
    MESSAGE'COPY O.K!!!'
    LET l_oldno = g_ocm01
    LET g_ocm01 = l_newno
    CALL i123_b()
    #LET g_ocm01 = l_oldno #FUN-C80046
    #CALL i123_show()      #FUN-C80046
END FUNCTION
 
FUNCTION i123_set_entry(p_cmd) 
    DEFINE p_cmd   LIKE type_file.chr1              #No.FUN-680137 VARCHAR(1)
  
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN     
       CALL cl_set_comp_entry("ocm01,ocm05,ocm03",TRUE)   #FUN-640187 add ocm05,ocm03
    END IF                                                                      
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i123_set_no_entry(p_cmd) 
    DEFINE p_cmd   LIKE type_file.chr1              #No.FUN-680137 VARCHAR(1)
                                                                                
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("ocm01,ocm05,ocm03",FALSE)  #FUN-640187 add ocm05,ocm03      
    END IF                                                                      
                 
END FUNCTION      
#No.FUN-7C0043--start-- 
FUNCTION i123_out() 
 DEFINE                                                                      
        l_i             LIKE type_file.num5,       #No.FUN-680137 SMALLINT
        l_ocm           RECORD LIKE ocm_file.*,  
        l_name          LIKE type_file.chr20       #No.FUN-680137 VARCHAR(20)
 DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                    
                                                                                                                                    
    IF g_ocm01 IS NULL THEN                                                                                                         
       CALL cl_err('',-400,1)                                                                                                       
       RETURN                                                                                                                       
    END IF                                                                                                                          
                                                                                                                                    
    IF g_wc IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_cmd = 'p_query "axmi123" "',g_wc CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN     
#   IF g_ocm01 IS NULL THEN
#      CALL cl_err('',-400,1)
#      RETURN
#   END IF 
 
#   IF g_wc IS NULL THEN 
#      CALL cl_err('','9057',0) 
#      RETURN 
#   END IF
#
#   CALL cl_wait()
#   CALL cl_outnam('axmi123') RETURNING l_name
 
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#   LET g_sql="SELECT * ",
#             "  FROM ocm_file ",  
#             " WHERE ",g_wc CLIPPED,
#             " ORDER BY ocm01,ocm05,ocm03,ocm02 "   #FUN-640187 modify
#   PREPARE i123_p1 FROM g_sql              
#   DECLARE i123_co                         # CURSOR
#       CURSOR FOR i123_p1
 
#   START REPORT i123_rep TO l_name
 
#   FOREACH i123_co INTO l_ocm.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i123_rep(l_ocm.*)
#   END FOREACH
 
#   FINISH REPORT i123_rep
 
#   CLOSE i123_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION                                                                    
#                                                                                
#REPORT i123_rep(sr)  
#DEFINE                                                                      
#      sr              RECORD LIKE ocm_file.* , 
#       l_trailer_sw     LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1) 
#       l_ima02         LIKE ima_file.ima02,
#       l_ima021        LIKE ima_file.ima021
 
#   OUTPUT                                        
#      TOP MARGIN g_top_margin                                                             
#      LEFT MARGIN g_left_margin                                                            
#      BOTTOM MARGIN g_bottom_margin                                                          
#      PAGE LENGTH g_page_line                                                  
#                                                                               
#   ORDER EXTERNAL BY sr.ocm01   #FUN-640187 modify
 
#   FORMAT
#       PAGE HEADER
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]  #TQC-790067
#          LET g_pageno = g_pageno + 1
#          LET pageno_total = PAGENO USING '<<<',"/pageno" 
#          PRINT g_head CLIPPED,pageno_total 
 
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]  #TQC-790067
#          PRINT ' '                                                           
#          PRINT g_dash[1,g_len]  
 
#          PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#                g_x[37],g_x[38]   #FUN-640187 add
#          PRINT g_dash1 
#          LET l_trailer_sw = 'y'
#            
#       BEFORE GROUP OF sr.ocm03   #FUN-640187 modify 
#          PRINT COLUMN g_c[31],sr.ocm01 CLIPPED ,
#                COLUMN g_c[32],sr.ocm05,   #FUN-640187 add
#                COLUMN g_c[33],sr.ocm03,
#                COLUMN g_c[34],sr.ocm04;
 
#       AFTER GROUP OF sr.ocm03
#          PRINT ' '
 
#       ON EVERY ROW
#          LET l_ima02 =null  
#          LET l_ima021=null
#          SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
#           WHERE ima01 = sr.ocm02
#          PRINT COLUMN g_c[35],sr.ocm02 CLIPPED ,
#                COLUMN g_c[36],l_ima02  CLIPPED ,
#                COLUMN g_c[37],l_ima021 CLIPPED ,
#                COLUMN g_c[38],sr.ocm06 CLIPPED    #FUN-640187 add
 
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
#No.FUN-7C0043--end--
