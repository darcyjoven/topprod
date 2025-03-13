# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almi840.4gl
# Descriptions...: 商品維護作業珛 
# Date & Author..: No.FUN-A90049 10/09/25 By lixh1
# Modify.........: No.FUN-AB0011 10/11/01 By lixh1  BUG处理
# Modify.........: No.FUN-AB0025 10/11/11 By chenying 修改料號開窗改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0059 10/11/15 By lixh1 还原FUN-AA0059 系統開窗管控
# Modify.........: No.TQC-AC0129 10/12/13 By huangtao ima910改為not null 插入ima_file時給空白
# Modify.........: No.TQC-B20101 11/02/18 By lilingyu 銷售單位錄入任何值都可以過,未作有效性檢查
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60013 11/06/03 By lixia ima25,ima31_fac給予默認值
# Modify.........: No:FUN-B70060 11/07/18 By zhangll 控管料號前不能有空格
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode,是另外一組的,在五行以外
# Modify.........: No.FUN-B80032 11/10/31 By yangxf ima_file 更新揮寫rtepos
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20094 12/02/09 by fanbj ima159,ima928賦初值
# Modify.........: No:FUN-C20065 12/02/10 By lixh1 在insert into ima_file之前，當ima159為null時要給'3'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_ima                RECORD LIKE ima_file.*,
       g_ima_t              RECORD LIKE ima_file.*,
       g_ima_o              RECORD LIKE ima_file.*,  
       g_ima01_t            LIKE ima_file.ima01,
       g_wc,g_sql           STRING
DEFINE g_forupd_sql         STRING  #SELECT ... FOR UPDATE SQL
DEFINE p_row,p_col          LIKE type_file.num5 
DEFINE g_before_input_done  LIKE type_file.num5        
DEFINE g_cnt                LIKE type_file.num10       
DEFINE g_i                  LIKE type_file.num5       
DEFINE g_msg                LIKE type_file.chr1000     
DEFINE i                    LIKE type_file.num5  
DEFINE g_row_count          LIKE type_file.num10       
DEFINE g_curs_index         LIKE type_file.num10       
DEFINE g_jump               LIKE type_file.num10       
DEFINE mi_no_ask            LIKE type_file.num5        
DEFINE l_ac                 LIKE type_file.num5        #--目前處理的ARRAY CNT
DEFINE g_chr                LIKE type_file.chr1   
DEFINE g_chr1               LIKE type_file.chr1     
DEFINE g_chr2               LIKE type_file.chr1
DEFINE g_rec_b              LIKE type_file.num5
DEFINE g_flag2              LIKE type_file.chr1 
DEFINE g_rec_b1             LIKE type_file.num10 
DEFINE g_ima_l             DYNAMIC ARRAY OF RECORD                              
                           ima01_l    LIKE ima_file.ima01,                      
                           ima02_l    LIKE ima_file.ima02,                      
                           ima021_l   LIKE ima_file.ima021,                     
                           ima06_l    LIKE ima_file.ima06,                      
                           ima08_l    LIKE ima_file.ima08,                      
                           ima130_l   LIKE ima_file.ima130,                     
                           ima109_l   LIKE ima_file.ima109,                     
                           ima25_l    LIKE ima_file.ima25,                      
                           ima37_l    LIKE ima_file.ima37,                      
                           ima1010_l  LIKE ima_file.ima1010,                    
                           imaacti_l  LIKE ima_file.imaacti,                    
                           ima906_l   LIKE ima_file.ima906                      
                           END RECORD 

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    
    LET g_forupd_sql = " SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i840_cl CURSOR FROM g_forupd_sql    
 
    OPEN WINDOW i840_w WITH FORM "alm/42f/almi840"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
   LET g_action_choice = ""
   CALL i840_menu()
 
   CLOSE WINDOW i840_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0074
END MAIN    

FUNCTION i840_menu()
 DEFINE l_cmd   LIKE type_file.chr1000   
   MENU ""                                                                      
      BEFORE MENU                                                               
         CALL cl_navigator_setting( g_curs_index, g_row_count ) 
         
      ON ACTION insert       #新增
         LET g_action_choice="insert"
             IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
                  CALL i840_a()
             END IF
      ON ACTION query        #查詢
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i840_q()
         END IF
      ON ACTION delete       #刪除
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            IF i840_r() THEN
               CALL i840_AFTER_DEL()
            END IF
         END IF         
      ON ACTION modify       #修改
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i840_u()
         END IF
 
      ON ACTION first        #第一筆
         CALL i840_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN                   
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
 
      ON ACTION previous      #前一筆
         CALL i840_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN                   
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
 
      ON ACTION jump           #指定筆
         CALL i840_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN                  
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF 
         
     ON ACTION next            #下一筆
         CALL i840_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN                   
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
 
      ON ACTION last           #最後一筆
         CALL i840_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN                   
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF

       ON ACTION locale        #語言別
          LET g_action_choice = "locale"
          IF cl_chk_act_auth() THEN          
             CALL cl_dynamic_locale()
             CALL i840_show_pic() 
             CALL cl_show_fld_cont()    
          END IF
 
      ON ACTION invalid         #無效
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL i840_x()
            CALL i840_show()           
         END IF
 
      ON ACTION reproduce        #複製
         LET g_action_choice="reproduce"
             IF cl_chk_act_auth() THEN
                CALL i840_copy()
                CALL i840_show() 
             END IF
 
      ON ACTION output            #列印
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
            CALL i840_out()
         END IF

      ON ACTION confirm            #確認  
         LET g_action_choice="confirm"    
         IF cl_chk_act_auth() THEN
            CALL i840_confirm()
            CALL i840_show()
         END IF
 
 
      ON ACTION notconfirm         #取消確認
         LET g_action_choice="notconfirm"
         IF cl_chk_act_auth() THEN
            CALL i840_notconfirm()
            CALL i840_show()
         END IF         
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION exit                #結束       
         LET g_action_choice='exit'
         EXIT MENU
         
      ON ACTION CONTROLR            #必要自段                                               
         CALL cl_show_req_fields()          
 
      ON ACTION controlg            
         CALL cl_cmdask() 
         
      ON ACTION update
         IF NOT cl_null(g_ima.ima01) THEN
            LET g_doc.column1 = "ima01"
            LET g_doc.value1 = g_ima.ima01
            CALL cl_fld_doc("ima04")
         END IF 
         
      ON ACTION close   
          LET INT_FLAG=FALSE                 
          LET g_action_choice = "exit"
          EXIT MENU           
   END MENU
   CLOSE i840_cl         
END FUNCTION   

FUNCTION i840_curs()
DEFINE   l_ima151                LIKE ima_file.ima151               
DEFINE   l_n                     LIKE type_file.num5
 
   CLEAR FORM
   INITIALIZE g_ima.* TO NULL
   CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021,ima31,ima128,ima1010,ima916,
                             imauser,imagrup,imaoriu,imaorig,imamodu,
                             imadate,imaacti,   
                             ima1005,ima1006,ima1004,ima1007,ima1008,ima1009,
                             ima131,ima09,ima10,ima11,
                             imaud01,imaud02,imaud03,imaud04,imaud05,
                             imaud06,imaud07,imaud08,imaud09,imaud10,
                             imaud11,imaud12,imaud13,imaud14,imaud15
 
   BEFORE CONSTRUCT
      CALL cl_qbe_init()
   ON ACTION controlp
      CASE      
         WHEN INFIELD(ima01)      #料件編號   
#FUN-AB0059-----------Begin-----------------------------remark
#FUN-AB0025---------mod---------------str---------------- 
           CALL cl_init_qry_var()
           LET g_qryparam.form     = "q_ima1"
           LET g_qryparam.state    = "c"
           LET g_qryparam.where    = "ima120 = '2'"            
           CALL cl_create_qry() RETURNING g_qryparam.multiret
#          CALL q_sel_ima(TRUE, "q_ima1","ima120 = '2'","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AB0025--------mod---------------end----------------
#FUN-AB0059-----------End------------------------------reamrk
            DISPLAY g_qryparam.multiret TO ima01
            NEXT FIELD ima01
            
         WHEN INFIELD(ima31)      #銷售單位   
            CALL cl_init_qry_var()
            LET g_qryparam.form     = "q_gfe"
            LET g_qryparam.state    = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima31
            NEXT FIELD ima31        

         WHEN INFIELD(ima1005)    #品牌   
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_tqa_01"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1  = "2"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima1005
            NEXT FIELD ima1005  

         WHEN INFIELD(ima1006)    #系列   
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_tqa_01"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1  = "3"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima1006
            NEXT FIELD ima1006

         WHEN INFIELD(ima1004)     #特性分群碼一   
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_tqa_01"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1  = "1"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima1004
            NEXT FIELD ima1004

         WHEN INFIELD(ima1007)     #特性分群碼二 
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_tqa_01"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1  = "4"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima1007
            NEXT FIELD ima1007

         WHEN INFIELD(ima1008)     #特性分群碼三 
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_tqa_01"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1  = "5"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima1008
            NEXT FIELD ima1008

         WHEN INFIELD(ima1009)     #特性分群碼四  
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_tqa_01"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1  = "6"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima1009
            NEXT FIELD ima1009 

         WHEN INFIELD(ima131)      #產品分類編號
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_oba"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima131
            NEXT FIELD ima131

         WHEN INFIELD(ima09)       #其他分群碼一  
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_azf_01"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1  = "D"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima09
            NEXT FIELD ima09    

         WHEN INFIELD(ima10)       #其他分群碼二  
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_azf_01"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1  = "E"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima10
            NEXT FIELD ima10  

         WHEN INFIELD(ima11)       #其他分群碼三  
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_azf_01"
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1  = "F"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima11
            NEXT FIELD ima11   
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

     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT        
 
     ON ACTION qbe_select
        CALL cl_qbe_select()
     ON ACTION qbe_save
        CALL cl_qbe_save()
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW almi840_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      RETURN
   END IF
   IF cl_null(g_wc) THEN
      LET g_wc = " 1=1"
   END IF   
   CALL i840_declare_curs()   
END FUNCTION

FUNCTION i840_declare_curs()
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
 
   LET g_sql = "SELECT ima01 FROM ima_file ",     # 組合出 SQL 指令
               " WHERE ima120 = '2' AND ",g_wc CLIPPED,
               " ORDER BY ima01"
   PREPARE aimi840_prepare FROM g_sql
   DECLARE aimi840_curs SCROLL CURSOR WITH HOLD FOR aimi840_prepare
 
   DECLARE aimi840_list_cur CURSOR FOR aimi840_prepare
 
   LET g_sql= "SELECT COUNT(*) FROM ima_file WHERE ima120 = '2' AND ",g_wc CLIPPED
   PREPARE aimi840_precount FROM g_sql
   DECLARE aimi840_count CURSOR FOR aimi840_precount
END FUNCTION

FUNCTION i840_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i840_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_ima.* TO NULL
        INITIALIZE g_ima_t.* TO NULL
        CLEAR FORM
        RETURN
    END IF
    MESSAGE "Searching!"
    OPEN aimi840_count
    FETCH aimi840_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi840_curs                         # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL
    ELSE
        CALL i840_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION

FUNCTION i840_AFTER_DEL()
   OPEN aimi840_count
   #FUN-B50063-add-start--
   IF STATUS THEN
      CLOSE aimi840_count
      RETURN
   END IF
   #FUN-B50063-add-end-- 
   FETCH aimi840_count INTO g_row_count
   #FUN-B50063-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE aimi840_count
      RETURN
   END IF
   #FUN-B50063-add-end--
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN aimi840_curs
   IF g_curs_index = g_row_count + 1 THEN
      LET g_jump = g_row_count
      CALL i840_fetch('L')
   ELSE
      LET g_jump = g_curs_index
      LET mi_no_ask = TRUE     
      CALL i840_fetch('/')
   END IF
END FUNCTION

FUNCTION i840_fetch(p_flima)
    DEFINE
        p_flima          LIKE type_file.chr1    
 
    CASE p_flima
        WHEN 'N' FETCH NEXT     aimi840_curs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS aimi840_curs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    aimi840_curs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     aimi840_curs INTO g_ima.ima01
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
            FETCH ABSOLUTE g_jump aimi840_curs INTO g_ima.ima01
            LET mi_no_ask = FALSE    
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  
        RETURN
    ELSE
      CASE p_flima
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_ima.* FROM ima_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  
    ELSE
        LET g_data_owner = g_ima.imauser      
        LET g_data_group = g_ima.imagrup      
        CALL i840_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i840_show()
   DISPLAY BY NAME g_ima.ima01  ,g_ima.ima02  ,g_ima.ima021 , 
                   g_ima.imaoriu,g_ima.imaorig,
                   g_ima.ima31  ,g_ima.ima128 ,g_ima.ima1010,
                   g_ima.ima916 ,g_ima.ima1005,g_ima.ima1006,
                   g_ima.ima1004,g_ima.ima1007,g_ima.ima1008,
                   g_ima.ima1009,g_ima.ima131 ,g_ima.ima09  ,
                   g_ima.ima10  ,g_ima.ima11  ,g_ima.imauser,
                   g_ima.imagrup,g_ima.imamodu,g_ima.imadate,
                   g_ima.imaacti,g_ima.imaud01,g_ima.imaud02,
                   g_ima.imaud03,g_ima.imaud04,g_ima.imaud05,
                   g_ima.imaud06,g_ima.imaud07,g_ima.imaud08,
                   g_ima.imaud09,g_ima.imaud10,g_ima.imaud11,
                   g_ima.imaud12,g_ima.imaud13,g_ima.imaud14,
                   g_ima.imaud15
   CALL i840_ima131("d")                
   CALL i840_ima(g_ima.ima1004,'1')                                                                                                
   CALL i840_ima(g_ima.ima1005,'2')                                                                                                
   CALL i840_ima(g_ima.ima1006,'3')                                                                                                
   CALL i840_ima(g_ima.ima1007,'4')                                                                                                
   CALL i840_ima(g_ima.ima1008,'5')                                                                                                
   CALL i840_ima(g_ima.ima1009,'6')
   CALL i840_show_pic() 
   CALL cl_set_act_visible("accept,cancel", TRUE)   
   CALL cl_show_fld_cont()     
END FUNCTION

FUNCTION i840_ima(p_key1,p_key2)
    DEFINE p_key1   LIKE tqa_file.tqa01
    DEFINE p_key2   LIKE tqa_file.tqa03
    DEFINE l_tqa02  LIKE tqa_file.tqa02
 
    SELECT tqa02 INTO l_tqa02 FROM tqa_file
     WHERE tqa01 = p_key1 AND tqa03 = p_key2
 
    CASE p_key2
         WHEN '1'
           DISPLAY l_tqa02 TO FORMONLY.tqa02b
         WHEN '2'
           DISPLAY l_tqa02 TO FORMONLY.tqa02
         WHEN '3'
           DISPLAY l_tqa02 TO FORMONLY.tqa02a
         WHEN '4'
           DISPLAY l_tqa02 TO FORMONLY.tqa02c
         WHEN '5'
           DISPLAY l_tqa02 TO FORMONLY.tqa02d
         WHEN '6'
           DISPLAY l_tqa02 TO FORMONLY.tqa02e
    END CASE
END FUNCTION
FUNCTION i840_ima131(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE l_oba02         LIKE oba_file.oba02
   DEFINE l_azf03         LIKE azf_file.azf03
   DEFINE l_azf03a        LIKE azf_file.azf03
   DEFINE l_azf03b        LIKE azf_file.azf03   
   SELECT oba02 INTO l_oba02 FROM oba_file  
    WHERE oba01 = g_ima.ima131
   DISPLAY l_oba02 TO FORMONLY.oba02
   SELECT azf03 INTO l_azf03 FROM azf_file
    WHERE azf01 = g_ima.ima09
      AND azf02 = 'D'
   DISPLAY l_azf03 TO FORMONLY.azf03
   SELECT azf03 INTO l_azf03a FROM azf_file
    WHERE azf01 = g_ima.ima10
      AND azf02 = 'E'
   DISPLAY l_azf03a TO FORMONLY.azf03a
   SELECT azf03 INTO l_azf03b FROM azf_file
    WHERE azf01 = g_ima.ima11
      AND azf02 = 'F'
   DISPLAY l_azf03b TO FORMONLY.azf03b   
END FUNCTION   

FUNCTION i840_a()
   MESSAGE ""
   IF s_shut(0) THEN RETURN END IF
   CLEAR FORM
   INITIALIZE g_ima.* TO NULL
   CALL ima_default()
   LET g_ima01_t = NULL
   
  #預設值及將數值變數清成零
   LET g_ima_t.* = g_ima.*   
   LET g_ima_o.* = g_ima.*   
   CALL cl_opmsg('a')
   
#   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'a') THEN                                                                          
#      CALL cl_err(g_ima.ima916,'aoo-078',1)                                                                                        
#      RETURN                                                                                                                       
#   END IF      
 
   WHILE TRUE
      CALL i840_i("a")                      # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         INITIALIZE g_ima.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF g_ima.ima01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      LET g_ima.ima120 = '2'    
      LET g_ima.ima916 = g_plant 
      LET g_ima.imaoriu = g_user      
      LET g_ima.imaorig = g_grup
      LET g_ima.ima910 = ' '                     #TQC-AC0129
#      LET g_ima.ima911 = 'N'    
#      LET g_ima.ima601 = 1      
 
      LET g_ima.ima915 = '0'      
      LET g_ima.ima916 = g_plant      
      LET g_ima.ima150 = ' '              
      LET g_ima.ima151 = ' '                   
      LET g_ima.ima152 = ' '                   
      LET g_ima.ima159 = '3'              #TQC-C20094  add
     #LET g_ima.ima928 = ' '              #TQC-C20094  add  #TQC-C20131 mark
      IF cl_null(g_ima.ima928) THEN LET g_ima.ima928 = 'N' END IF      #TQC-C20131  add
#     IF cl_null(g_ima.ima918) THEN LET g_ima.ima918 = 'N' END IF
#     IF cl_null(g_ima.ima919) THEN LET g_ima.ima919 = 'N' END IF
#     IF cl_null(g_ima.ima921) THEN LET g_ima.ima921 = 'N' END IF
#     IF cl_null(g_ima.ima922) THEN LET g_ima.ima922 = 'N' END IF
#     IF cl_null(g_ima.ima924) THEN LET g_ima.ima924 = 'N' END IF
     IF cl_null(g_ima.ima926) THEN LET g_ima.ima926 = 'N' END IF
     IF cl_null(g_ima.ima022) THEN LET g_ima.ima022  = 0 END IF 
     IF cl_null(g_ima.ima156) THEN LET g_ima.ima156  = 'N' END IF 
     IF cl_null(g_ima.ima158) THEN LET g_ima.ima158  = 'N' END IF 
     IF cl_null(g_ima.ima927) THEN LET g_ima.ima927  = 'N' END IF 

      IF cl_null(g_ima.ima156) THEN 
         LET g_ima.ima156 = 'N'
      END IF
      IF cl_null(g_ima.ima158) THEN 
         LET g_ima.ima158 = 'N'
      END IF
   
#FUN-C20065 ---------Begin---------
      IF cl_null(g_ima.ima159) THEN
         LET g_ima.ima159 = '3'
      END IF 
#FUN-C20065 ---------End-----------
      IF cl_null(g_ima.ima160) THEN LET g_ima.ima160 = 'N' END IF      #FUN-C50036  add
      INSERT INTO ima_file VALUES(g_ima.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
END FUNCTION

FUNCTION i840_i(p_cmd)
   DEFINE p_cmd          LIKE type_file.chr1,        
          l_flag         LIKE type_file.chr1,        
          l_smd          RECORD LIKE smd_file.*,
          l_ima31_fac    LIKE pml_file.pml09,       
          l_n            LIKE type_file.num5        
   DEFINE lc_sma119      LIKE sma_file.sma119, 
          li_len         LIKE type_file.num5,        
          l_cnt          LIKE type_file.num5,       
          li_result      LIKE type_file.num5
   DEFINE l_ima128       LIKE ima_file.ima128, 
          l_ima120       LIKE ima_file.ima120,
          l_oba02        LIKE oba_file.oba02,
          l_azf03        LIKE azf_file.azf03,
          l_azf03a       LIKE azf_file.azf03,
          l_azf03b       LIKE azf_file.azf03,
          l_tqa02        LIKE tqa_file.tqa02, 
          l_tqa02a       LIKE tqa_file.tqa02, 
          l_tqa02b       LIKE tqa_file.tqa02, 
          l_tqa02c       LIKE tqa_file.tqa02, 
          l_tqa02d       LIKE tqa_file.tqa02, 
          l_tqa02e       LIKE tqa_file.tqa02,           
          l_tqaacti      LIKE tqa_file.tqaacti, 
          l_tqaactia     LIKE tqa_file.tqaacti, 
          l_tqaactib     LIKE tqa_file.tqaacti, 
          l_tqaactic     LIKE tqa_file.tqaacti, 
          l_tqaactid     LIKE tqa_file.tqaacti, 
          l_tqaactie     LIKE tqa_file.tqaacti,
          l_azfacti      LIKE azf_file.azfacti,
          l_azfactia     LIKE azf_file.azfacti,
          l_azfactib     LIKE azf_file.azfacti, 
          l_obaacti      LIKE oba_file.obaacti
  DEFINE  l_gfeacti      LIKE gfe_file.gfeacti     #TQC-B20101
          
   DISPLAY BY NAME g_ima.ima1010
   INPUT BY NAME 
                 g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima31,g_ima.ima128,
                 g_ima.ima916,
                 g_ima.imauser,g_ima.imagrup,g_ima.imaoriu,g_ima.imaorig,g_ima.imamodu,
                 g_ima.imadate,g_ima.imaacti,
                 g_ima.ima1005,g_ima.ima1006,g_ima.ima1004,
                 g_ima.ima1007,g_ima.ima1008,g_ima.ima1009,g_ima.ima131,g_ima.ima09,
                 g_ima.ima10,g_ima.ima11,
                 g_ima.imaud01,g_ima.imaud02,g_ima.imaud03,g_ima.imaud04,g_ima.imaud05,
                 g_ima.imaud06,g_ima.imaud07,g_ima.imaud08,g_ima.imaud09,g_ima.imaud10,
                 g_ima.imaud11,g_ima.imaud12,g_ima.imaud13,g_ima.imaud14,g_ima.imaud15

                 
       WITHOUT DEFAULTS
 
       BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i840_set_entry(p_cmd)
          CALL i840_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_chg_comp_att("ima01","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
 
       AFTER FIELD ima01
          IF NOT cl_null(g_ima.ima01) THEN
         # 若輸入或更改且改KEY
#            IF cl_null(g_ima_t.ima01) THEN
#               LET g_ima_t.ima01 =' '
#            END IF
             IF cl_null(g_ima_t.ima01) OR (p_cmd = "u" AND g_ima.ima01 != g_ima_t.ima01) THEN
                SELECT count(*) INTO l_n FROM ima_file
                 WHERE ima01 = g_ima.ima01
                IF l_n > 0 THEN                  # Duplicated
                   SELECT ima120 INTO l_ima120 FROM ima_file 
                    WHERE ima01 = g_ima.ima01
                    IF l_ima120 = '2' THEN
                       CALL cl_err(g_ima.ima01,'alm1012',0) 
                    ELSE
                       CALL cl_err(g_ima.ima01,'alm1008',0)
                    END IF   
                    LET g_ima.ima01 = g_ima_t.ima01
                    DISPLAY BY NAME g_ima.ima01
                    NEXT FIELD ima01
                END IF
                #FUN-B70060 add
                IF g_ima.ima01[1,1] = ' ' THEN
                   CALL cl_err(g_ima.ima01,"aim-671",0)
                   NEXT FIELD ima01
                END IF
                #FUN-B70060 add--end
             END IF
          END IF   

#TQC-B20101 --begin--
      AFTER FIELD ima31 
          LET l_cnt = 0 
          LET l_gfeacti = 'N'
          IF NOT cl_null(g_ima.ima31) THEN 
             SELECT COUNT(*),gfeacti INTO l_cnt,l_gfeacti FROM gfe_file
              WHERE gfe01 = g_ima.ima31
              GROUP BY gfeacti
             IF l_cnt = 0 THEN 
                CALL cl_err('','mfg0019',0)
                NEXT FIELD CURRENT 
             END IF  
             IF l_gfeacti = 'N' THEN 
                CALL cl_err('','alm-004',0)
                NEXT FIELD CURRENT 
             END IF 
             #TQC-B60013--add--str--
             LET g_ima.ima25 = g_ima.ima31
             LET g_ima.ima31_fac = '1'
             #TQC-B60013--add--end--
          END IF 
#TQC-B20101 --end--
          
       AFTER FIELD ima128
          IF NOT cl_null(g_ima.ima128) THEN
             IF g_ima.ima128 < 0 THEN
                CALL cl_err(g_ima.ima128,'alm1007',0)  
                NEXT FIELD ima128
             END IF
          END IF
       AFTER FIELD ima1005
          IF NOT cl_null(g_ima.ima1005) THEN
             SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti FROM tqa_file
              WHERE tqa01 = g_ima.ima1005
                AND tqa03 = '2'
             IF SQLCA.SQLCODE = 100 THEN
                CALL cl_err('','alm1010',0)
                NEXT FIELD ima1005
             END IF
             IF l_tqaacti ='N' THEN
                CALL cl_err('','alm1011',0)
                NEXT FIELD ima1005                
             END IF
             DISPLAY l_tqa02 TO formonly.tqa02
          ELSE
             DISPLAY '' TO formonly.tqa02    
          END IF   

       AFTER FIELD ima1006
          IF NOT cl_null(g_ima.ima1006) THEN
             SELECT tqa02,tqaacti INTO l_tqa02a,l_tqaactia FROM tqa_file
              WHERE tqa01 = g_ima.ima1006
                AND tqa03 = '3'
            IF SQLCA.SQLCODE = 100 THEN
                CALL cl_err('','alm1010',0)
                NEXT FIELD ima1006
             END IF
             IF l_tqaactia ='N' THEN
                CALL cl_err('','alm1011',0)
                NEXT FIELD ima1006                
             END IF
             DISPLAY l_tqa02a TO formonly.tqa02a
          ELSE
             DISPLAY '' TO formonly.tqa02a 
          END IF             
             
       AFTER FIELD ima1004
          IF NOT cl_null(g_ima.ima1004) THEN
             SELECT tqa02,tqaacti INTO l_tqa02b,l_tqaactib FROM tqa_file
              WHERE tqa01 = g_ima.ima1004
                AND tqa03 = '1'
            IF SQLCA.SQLCODE = 100 THEN
                CALL cl_err('','alm1010',0)
                NEXT FIELD ima1004
             END IF
             IF l_tqaactib ='N' THEN
                CALL cl_err('','alm1011',0)
                NEXT FIELD ima1004                
             END IF
             DISPLAY l_tqa02b TO formonly.tqa02b
          ELSE
             DISPLAY '' TO formonly.tqa02b 
          END IF                
                
        AFTER FIELD ima1007
          IF NOT cl_null(g_ima.ima1007) THEN
             SELECT tqa02,tqaacti INTO l_tqa02c,l_tqaactic FROM tqa_file
              WHERE tqa01 = g_ima.ima1007
                AND tqa03 = '4'
            IF SQLCA.SQLCODE = 100 THEN
                CALL cl_err('','alm1010',0)
                NEXT FIELD ima1007
             END IF
             IF l_tqaactic ='N' THEN
                CALL cl_err('','alm1011',0)
                NEXT FIELD ima1007                
             END IF
             DISPLAY l_tqa02c TO formonly.tqa02c
          ELSE
             DISPLAY '' TO formonly.tqa02c 
          END IF 
       AFTER FIELD ima1008
          IF NOT cl_null(g_ima.ima1008) THEN
             SELECT tqa02,tqaacti INTO l_tqa02d,l_tqaactid FROM tqa_file
              WHERE tqa01 = g_ima.ima1008
                AND tqa03 = '5'
            IF SQLCA.SQLCODE = 100 THEN
                CALL cl_err('','alm1010',0)
                NEXT FIELD ima1008
             END IF
             IF l_tqaactid ='N' THEN
                CALL cl_err('','alm1011',0)
                NEXT FIELD ima1008                
             END IF
             DISPLAY l_tqa02d TO formonly.tqa02d
          ELSE
             DISPLAY '' TO formonly.tqa02d 
          END IF 
          
       AFTER FIELD ima1009
          IF NOT cl_null(g_ima.ima1009) THEN
             SELECT tqa02,tqaacti INTO l_tqa02e,l_tqaactie FROM tqa_file
              WHERE tqa01 = g_ima.ima1009
                AND tqa03 = '6'
            IF SQLCA.SQLCODE = 100 THEN
                CALL cl_err('','alm1010',0)
                NEXT FIELD ima1009
             END IF
             IF l_tqaactie ='N' THEN
                CALL cl_err('','alm1011',0)
                NEXT FIELD ima1009                
             END IF
             DISPLAY l_tqa02e TO formonly.tqa02e
          ELSE
             DISPLAY '' TO formonly.tqa02e 
          END IF  

       AFTER FIELD ima131
          IF NOT cl_null(g_ima.ima131) THEN
             SELECT oba02,obaacti INTO l_oba02,l_obaacti FROM oba_file
              WHERE oba01 = g_ima.ima131
             IF SQLCA.SQLCODE = 100 THEN
                CALL cl_err('','alm1010',0)
                NEXT FIELD ima131
             END IF
             IF l_obaacti ='N' THEN
                CALL cl_err('','alm1011',0)
                NEXT FIELD ima131                
             END IF
             DISPLAY l_oba02 TO formonly.oba02
          ELSE
             DISPLAY '' TO formonly.oba02 
          END IF   

       AFTER FIELD ima09
          IF NOT cl_null(g_ima.ima09) THEN
             SELECT azf03,azfacti INTO l_azf03,l_azfacti FROM azf_file
              WHERE azf01 = g_ima.ima09
                AND azf02 = 'D'
             IF SQLCA.SQLCODE = 100 THEN
                CALL cl_err('','alm1010',0)
                NEXT FIELD ima09
             END IF
             IF l_azfacti ='N' THEN
                CALL cl_err('','alm1011',0)
                NEXT FIELD ima09                
             END IF
             DISPLAY l_azf03 TO formonly.azf03
          ELSE
             DISPLAY '' TO formonly.azf03
          END IF 

       AFTER FIELD ima10
          IF NOT cl_null(g_ima.ima10) THEN
             SELECT azf03,azfacti INTO l_azf03a,l_azfactia FROM azf_file
              WHERE azf01 = g_ima.ima10
                AND azf02 = 'E'
             IF SQLCA.SQLCODE = 100 THEN
                CALL cl_err('','alm1010',0)
                NEXT FIELD ima10
             END IF
             IF l_azfactia ='N' THEN
                CALL cl_err('','alm1011',0)
                NEXT FIELD ima10                
             END IF
             DISPLAY l_azf03a TO formonly.azf03a
          ELSE
             DISPLAY '' TO formonly.azf03a
          END IF    

       AFTER FIELD ima11
          IF NOT cl_null(g_ima.ima11) THEN
             SELECT azf03,azfacti INTO l_azf03b,l_azfactib FROM azf_file
              WHERE azf01 = g_ima.ima11
                AND azf02 = 'F'
             IF SQLCA.SQLCODE = 100 THEN
                CALL cl_err('','alm1010',0)
                NEXT FIELD ima11
             END IF
             IF l_azfactib ='N' THEN
                CALL cl_err('','alm1011',0)
                NEXT FIELD ima11                
             END IF
             DISPLAY l_azf03b TO formonly.azf03b
          ELSE
             DISPLAY '' TO formonly.azf03b
          END IF      
          AFTER FIELD imaud01
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud02
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud03
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud04
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud05
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud06
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud07
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud08
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud09
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud10
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud11
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud12
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud13
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud14
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud15
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
          LET g_ima.imauser = s_get_data_owner("ima_file") #FUN-C10039
          LET g_ima.imagrup = s_get_data_group("ima_file") #FUN-C10039
           IF INT_FLAG THEN 
              EXIT INPUT  
           END IF
       ON ACTION controlp
          CASE
             WHEN INFIELD(ima25)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_ima.ima25
                  CALL cl_create_qry() RETURNING g_ima.ima25
                  DISPLAY BY NAME g_ima.ima25
                  NEXT FIELD ima25
             WHEN INFIELD(ima31)    #銷售單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_ima.ima31
                  CALL cl_create_qry() RETURNING g_ima.ima31
                  DISPLAY BY NAME g_ima.ima31
                  NEXT FIELD ima31
             WHEN INFIELD(ima1004)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa_01"
                  LET g_qryparam.arg1 ="1"
                  LET g_qryparam.default1 = g_ima.ima1004
                  CALL cl_create_qry() RETURNING g_ima.ima1004
                  DISPLAY BY NAME g_ima.ima1004
                  NEXT FIELD ima1004
             WHEN INFIELD(ima1005)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa_01"
                  LET g_qryparam.arg1 ="2"
                  LET g_qryparam.default1 = g_ima.ima1005
                  CALL cl_create_qry() RETURNING g_ima.ima1005
                  DISPLAY BY NAME g_ima.ima1005
                  NEXT FIELD ima1005
             WHEN INFIELD(ima1006)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa_01"
                  LET g_qryparam.arg1 ="3"
                  LET g_qryparam.default1 = g_ima.ima1006
                  CALL cl_create_qry() RETURNING g_ima.ima1006
                  DISPLAY BY NAME g_ima.ima1006
                  NEXT FIELD ima1006
             WHEN INFIELD(ima1007)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa_01"
                  LET g_qryparam.arg1 ="4"
                  LET g_qryparam.default1 = g_ima.ima1007
                  CALL cl_create_qry() RETURNING g_ima.ima1007
                  DISPLAY BY NAME g_ima.ima1007
                  NEXT FIELD ima1007
             WHEN INFIELD(ima1008)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa_01"
                  LET g_qryparam.arg1 ="5"
                  LET g_qryparam.default1 = g_ima.ima1008
                  CALL cl_create_qry() RETURNING g_ima.ima1008
                  DISPLAY BY NAME g_ima.ima1008
                  NEXT FIELD ima1008
             WHEN INFIELD(ima1009)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa_01"
                  LET g_qryparam.arg1 ="6"
                  LET g_qryparam.default1 = g_ima.ima1009
                  CALL cl_create_qry() RETURNING g_ima.ima1009
                  DISPLAY BY NAME g_ima.ima1009
                  NEXT FIELD ima1009
             WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_oba"
                  LET g_qryparam.where = "obaacti = 'Y'"
                  LET g_qryparam.default1 = g_ima.ima131
                  CALL cl_create_qry() RETURNING g_ima.ima131
                  DISPLAY BY NAME g_ima.ima131
                  NEXT FIELD ima131
             WHEN INFIELD(ima09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf_01"
                  LET g_qryparam.default1 = g_ima.ima09
                  LET g_qryparam.arg1 = 'D'
                  CALL cl_create_qry() RETURNING g_ima.ima09
                  DISPLAY BY NAME g_ima.ima09
                  NEXT FIELD ima09
             WHEN INFIELD(ima10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf_01"
                  LET g_qryparam.default1 = g_ima.ima10
                  LET g_qryparam.arg1 = 'E'
                  CALL cl_create_qry() RETURNING g_ima.ima10
                  DISPLAY BY NAME g_ima.ima10
                  NEXT FIELD ima10
             WHEN INFIELD(ima11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf_01"
                  LET g_qryparam.default1 = g_ima.ima11
                  LET g_qryparam.arg1 = 'F'
                  CALL cl_create_qry() RETURNING g_ima.ima11
                  DISPLAY BY NAME g_ima.ima11
                  NEXT FIELD ima11
         END CASE           
      ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
           CALL cl_cmdask()
           
      ON ACTION CONTROLF                        # 欄位說明
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
 
END FUNCTION

FUNCTION i840_u()
   DEFINE l_ima   RECORD  LIKE ima_file.*          #FUN-B80032  
   IF s_shut(0) THEN 
      RETURN 
   END IF
 
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ima.ima01
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN							
      CALL cl_err(g_ima.ima916,'aoo-045',1)							
      RETURN							
   END IF   
   IF g_ima.imaacti = 'N' THEN
       CALL cl_err('',9027,0)
       RETURN
   END IF
            
   MESSAGE ""
   CALL cl_opmsg('u')
   
   BEGIN WORK
   OPEN i840_cl USING g_ima.ima01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      CLOSE i840_cl
      RETURN
   END IF
 
   FETCH i840_cl INTO g_ima.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      CLOSE i840_cl
      RETURN
   END IF   
   LET g_ima01_t = g_ima.ima01  
   LET g_ima_t.*=g_ima.*
   LET g_ima_o.*=g_ima.*   
   LET g_ima.imamodu = g_user                #修改者
   LET g_ima.imadate = g_today               #修改日期
 
   CALL i840_show()                          # 顯示最新資料
   WHILE TRUE
      CALL i840_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ima.*=g_ima_t.*
         CALL i840_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF 
      #FUN-B80032---------STA-------
       SELECT * INTO l_ima.*
         FROM ima_file
        WHERE ima01 = g_ima.ima01
        IF l_ima.ima02 <> g_ima.ima02 OR l_ima.ima021 <> g_ima.ima021
           OR l_ima.ima25 <> g_ima.ima25 OR l_ima.ima45 <> g_ima.ima45
           OR l_ima.ima131 <> g_ima.ima131 OR l_ima.ima151 <> g_ima.ima151
           OR l_ima.ima154 <> g_ima.ima154 OR l_ima.ima1004 <> g_ima.ima1004 
           OR l_ima.ima1005 <> g_ima.ima1005 OR l_ima.ima1006 <> g_ima.ima1006
           OR l_ima.ima1007 <> g_ima.ima1007 OR l_ima.ima1008 <> g_ima.ima1008
           OR l_ima.ima1009 <> g_ima.ima1009 THEN        
           IF g_aza.aza88 = 'Y' THEN
              UPDATE rte_file SET rtepos = '2' WHERE rte03 = g_ima.ima01 AND rtepos = '3'
           END IF
        END IF 
      #FUN-B80032---------END-------      
      LET g_ima.ima93[2,2] = 'Y'
      UPDATE ima_file SET * = g_ima.*  # 更新DB
       WHERE ima01 = g_ima.ima01             
      IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","ima_file",g_ima01_t,"",SQLCA.sqlcode,"","",1)  
          CONTINUE WHILE
      END IF

      EXIT WHILE
   END WHILE
 
   CLOSE i840_cl
   COMMIT WORK
END FUNCTION  

FUNCTION i840_x()
   DEFINE g_chr LIKE ima_file.imaacti
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_ima.ima1010 = '1' THEN 
      CALL cl_err(g_ima.ima01,'alm1013',1)
      RETURN
   END IF   
   
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN							
      CALL cl_err(g_ima.ima916,'aoo-045',1)							
      RETURN							
   END IF							
 
   BEGIN WORK
 
   OPEN i840_cl USING g_ima.ima01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      CLOSE i840_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i840_cl INTO g_ima.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      CLOSE i840_cl
      RETURN
   END IF
 
   CALL i840_show()
 
     IF cl_exp(0,0,g_ima.imaacti) THEN
#      LET g_chr = g_ima.imaacti
      LET g_chr2 = g_ima.ima1010   
     #CASE g_ima.ima1010
     #  WHEN '0' #開立
     #          LET g_ima.imaacti='N'
     #  WHEN '1' #確認
     #       IF g_ima.imaacti='N' THEN
     #          LET g_ima.imaacti='Y'
     #       ELSE
     #          LET g_ima.imaacti='N'
     #       END IF
     #END CASE
      IF g_ima.imaacti = 'Y' THEN
         LET g_ima.imaacti = 'N'
      ELSE
         LET g_ima.imaacti = 'Y'
      END IF
      UPDATE ima_file SET imaacti = g_ima.imaacti,
                          imamodu = g_user, 
                          imadate = g_today
       WHERE ima01 = g_ima.ima01
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  
         LET g_ima.imaacti = g_chr
      END IF
 
     #IF g_ima.imaacti='N' THEN 
     #   LET g_ima.imaacti='Y'
     #END IF
 
      DISPLAY BY NAME g_ima.imaacti
   END IF
 
   CLOSE i840_cl
   COMMIT WORK
 
END FUNCTION    


FUNCTION i840_confirm()
 DEFINE l_imaag    LIKE ima_file.imaag    
 DEFINE l_sql      STRING     
 DEFINE l_prog     LIKE type_file.chr8    
 DEFINE l_gew03   LIKE gew_file.gew03    
 DEFINE l_i       LIKE type_file.num10   
 
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
      CALL cl_err(g_ima.ima916,'aoo-045',1)
      RETURN
   END IF
   IF g_ima.ima1010='1' THEN 
      CALL cl_err("",9023,1)
      RETURN
   END IF
   IF g_ima.imaacti='N' THEN
      #此筆資料已無效, 不可異動
      CALL cl_err(g_ima.ima01,'alm1014',1)
      RETURN
   ELSE
    IF cl_confirm('aap-222') THEN
      BEGIN WORK
      UPDATE ima_file
         SET ima1010 = '1',  #'1':確認
             imaacti = 'Y'   #'Y':確認
       WHERE ima01 = g_ima.ima01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
                      "ima1010",1)  
         ROLLBACK WORK
      ELSE
        LET g_ima.ima1010 = '1'
        LET g_ima.imaacti = 'Y'
        DISPLAY BY NAME g_ima.ima1010
        DISPLAY BY NAME g_ima.imaacti
      END IF
    
      SELECT imaag INTO l_imaag
        FROM ima_file
       WHERE ima01 = g_ima.ima01
      IF l_imaag IS NULL OR l_imaag = '@CHILD' THEN
         COMMIT WORK 
         RETURN
      ELSE
         LET l_sql = " UPDATE ima_file SET ima1010 = '1',imaacti='Y' ",
                     "  WHERE ima01 LIKE '",g_ima.ima01,"_%'"
         PREPARE ima_cs3 FROM l_sql
         EXECUTE ima_cs3
         IF STATUS THEN
            CALL cl_err('ima1010',STATUS,1) 
            ROLLBACK WORK                   
            RETURN
         END IF
      END IF
     
      COMMIT WORK  
    END IF
 END IF
END FUNCTION
 
FUNCTION i840_notconfirm()
 DEFINE l_imaag    LIKE ima_file.imaag    
 DEFINE l_sql      STRING        
 DEFINE l_n        LIKE type_file.num5    
 DEFINE l_n1       LIKE type_file.num5   
 
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
      CALL cl_err(g_ima.ima916,'aoo-045',1)
      RETURN
   END IF
 #FUN-AB0011 ----------------------Begin-----------------------
 #   SELECT COUNT(*) INTO l_n FROM imx_file WHERE imx00 = g_ima.ima01
 #   IF l_n > 0 THEN 
 #     CALL cl_err('','aim-451',1)
 #     RETURN 
 #   END  IF                                                                 
 #FUN-AB0011  -----------------------End------------------------- 
    SELECT COUNT(*) INTO l_n1 FROM lmv_file WHERE lmv02 = g_ima.ima01
    IF l_n1 > 0 THEN 
      CALL cl_err('','alm-000',1)
      RETURN 
    END  IF      
   IF g_ima.ima1010 != '1' OR g_ima.imaacti='N' THEN 
      #無效或尚未確認，不能取消確認
      CALL cl_err('','atm-365',0)
   ELSE
     #-料件取消確認時，比照刪除邏輯判斷
 #    CALL s_chkitmdel(g_ima.ima01) RETURNING g_errno      #FUN-AB0011
 #    IF NOT cl_null(g_errno) THEN
 #         CALL cl_err('',g_errno,1) RETURN
 #    END IF
     IF cl_confirm('aap-224') THEN
      BEGIN WORK
      UPDATE ima_file
         SET ima1010 = '0' 
       WHERE ima01 = g_ima.ima01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"",
                      "ima1010",1)  
         ROLLBACK WORK
      ELSE
        LET g_ima.ima1010 = '0'
        DISPLAY BY NAME g_ima.ima1010
        DISPLAY BY NAME g_ima.imaacti
      END IF
      SELECT imaag INTO l_imaag
        FROM ima_file
       WHERE ima01 = g_ima.ima01
      IF l_imaag IS NULL OR l_imaag = '@CHILD' THEN    ##多属性料件
         COMMIT WORK 
         RETURN
      ELSE
         LET l_sql = " UPDATE ima_file SET ima1010 = '0'",  
                     "  WHERE ima01 LIKE '",g_ima.ima01,"_%'"
         PREPARE ima_cs4        FROM l_sql
         EXECUTE ima_cs4
         IF STATUS THEN
            CALL cl_err('ima1010',STATUS,0)
            ROLLBACK WORK   
            RETURN
         END IF
      END IF
      COMMIT WORK  
    END IF
   END IF
END FUNCTION

FUNCTION i840_copy()
   DEFINE l_flag LIKE type_file.num5
   DEFINE l_ima   RECORD LIKE ima_file.*
   DEFINE l_newno,l_oldno LIKE ima_file.ima01
 
   CALL i840_copy_input() RETURNING l_flag,l_newno
   IF l_flag THEN
      CALL i840_copy_default(l_newno) RETURNING l_ima.*
      IF i840_copy_insert(l_ima.*,l_newno) THEN
         LET l_oldno = g_ima.ima01
         SELECT ima_file.* INTO g_ima.* FROM ima_file
                        WHERE ima01 = l_newno
         CALL i840_u()
         UPDATE ima_file SET imamodu = '', imadate = '' WHERE ima01 = l_newno
         #SELECT ima_file.* INTO g_ima.* FROM ima_file #FUN-C30027
         # WHERE ima01 = l_oldno   #FUN-C30027
      END IF
   END IF
END FUNCTION

FUNCTION i840_copy_input()
   DEFINE l_newno LIKE ima_file.ima01
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_ima120 LIKE ima_file.ima120
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN FALSE,NULL
    END IF
 
    LET g_before_input_done = FALSE
    CALL i840_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM ima01
      BEFORE FIELD ima01
          IF g_sma.sma60 = 'Y' THEN      # 若須分段輸入
             CALL s_inp5(6,14,l_newno) RETURNING l_newno
             DISPLAY l_newno TO ima01
          END IF
 
      AFTER FIELD ima01
          IF l_newno IS NULL THEN
              NEXT FIELD ima01
          END IF
          SELECT count(*) INTO g_cnt FROM ima_file
           WHERE ima01 = l_newno
          IF g_cnt > 0 THEN                  # Duplicated
             SELECT ima120 INTO l_ima120 FROM ima_file 
             WHERE ima01 = l_newno
             IF l_ima120 = '2' THEN
                CALL cl_err(l_newno,'alm1012',0) 
             ELSE
                CALL cl_err(l_newno,'alm1008',0)
             END IF
          END IF
          #FUN-B70060 add
          IF l_newno[1,1] = ' ' THEN
             CALL cl_err(l_newno,"aim-671",0)
             NEXT FIELD ima01
          END IF
          #FUN-B70060 add--end
          CALL s_field_chk(l_newno,'1',g_plant,'ima01') RETURNING g_flag2
          IF g_flag2 = '0' THEN
             CALL cl_err(l_newno,'aoo-043',1)
             NEXT FIELD ima01
          END IF
          IF l_newno[1,4]='MISC' AND
              (NOT cl_null(l_newno[5,10])) THEN        #NO:6808(養生)
              SELECT COUNT(*) INTO l_n FROM ima_file   #至少要有一筆'MISC'先存
               WHERE ima01='MISC'                      #才可以打其它MISCXX資料
              IF l_n=0 THEN
                 CALL cl_err('','aim-806',1)
                 NEXT FIELD ima01
              END IF
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
        DISPLAY BY NAME g_ima.ima01
        RETURN FALSE,NULL
    END IF
   #--增加再次詢問的確定,以免不必要的新增
    IF NOT cl_confirm('mfg-003') THEN
       RETURN FALSE,NULL
    END IF
   #--MESSAGE '新增料件基本資料中....!'
    CALL cl_err('','aim-993','0')
    RETURN TRUE,l_newno
END FUNCTION
 
FUNCTION i840_copy_default(l_newno)
   DEFINE l_ima RECORD LIKE ima_file.*
   DEFINE l_newno LIKE ima_file.ima01
 
   #-- 將漏掉的補入,參考i840_default
    LET l_ima.* = g_ima.*
    LET l_ima.ima01  =l_newno   #資料鍵值
#    LET l_ima.ima05  =NULL      #目前使用版本
#    LET l_ima.ima18  =0
#    LET l_ima.ima16  =99         #NO:6973
#    LET l_ima.ima29  =NULL      #最近易動日期
#    LET l_ima.ima30  =NULL      #最近盤點日期
#    LET l_ima.ima32  =0         #標準售價
#    LET l_ima.ima33  =0         #最近售價
#    LET l_ima.ima40  =0         #累計使用數量 期間
#    LET l_ima.ima41  =0         #累計使用數量 年度
#    LET l_ima.ima47  =0         #採購損耗率
#    LET l_ima.ima52  =1         #平均訂購量
#    LET l_ima.ima140 ='N'       #phase out
#    LET l_ima.ima53  =0         #最近採購單價
#    LET l_ima.ima531 =0         #市價
#    LET l_ima.ima532 =NULL      #市價最近異動日期
#    LET l_ima.ima562 =0         #生產損耗率
#    LET l_ima.ima73  =NULL      #最近入庫日期
#    LET l_ima.ima74  =NULL      #最近出庫日期
#    LET l_ima.ima75  =''        #海關編號
#    LET l_ima.ima76  =''        #商品類別
#    LET l_ima.ima77  =0         #在途量
#    LET l_ima.ima78  =0         #在驗量
#    LET l_ima.ima80  =0         #未耗預測量
#    LET l_ima.ima81  =0         #確認生產量
#    LET l_ima.ima82  =0         #計劃量
#    LET l_ima.ima83  =0         #MRP需求量
#    LET l_ima.ima84  =0         #OM 銷單備置量
#    LET l_ima.ima85  =0         #MFP銷單備置量
#    LET l_ima.ima881 =NULL      #期間採購最近採購日期
#    LET l_ima.ima91  =0         #平均採購單價
#    LET l_ima.ima92  ='N'       #net change status
#    LET l_ima.ima93  ='NNNNNNNN'#new parts status
#    LET l_ima.ima94  =''        #
#    LET l_ima.ima95  =0         #
#    LET l_ima.ima96  =0         #A. T. P. 量
#    LET l_ima.ima97  =0         #MFG 接單量
#    LET l_ima.ima98  =0         #OM 接單量
#    LET l_ima.ima104 =0         #廠商分配起始量
#    LET l_ima.ima901 = g_today  #料件建檔日期
#    LET l_ima.ima902 = NULL     #NO:6973
#    LET l_ima.ima9021 = NULL    #No.FUN-8C0131
#    LET l_ima.ima121 = 0        #單位材料成本
#    LET l_ima.ima122 = 0        #單位人工成本
#    LET l_ima.ima123 = 0        #單位製造費用
#    LET l_ima.ima124 = 0        #單位管銷成本
#    LET l_ima.ima125 = 0        #單位成本
#    LET l_ima.ima126 = 0        #單位利潤率
#    LET l_ima.ima127 = 0        #未稅訂價(本幣)
#    LET l_ima.ima128 = 0        #含稅訂價(本幣)
#    LET l_ima.ima132 = NULL     #費用科目編號
#    LET l_ima.ima133 = NULL     #產品預測料號
#    LET l_ima.ima134 = NULL     #主要包裝方式編號
#    LET l_ima.ima135 = NULL     #產品條碼編號
#    LET l_ima.ima139 = 'N'
#    LET l_ima.ima913 = 'N'      #No.MOD-640061
    LET l_ima.ima1010 = '0'                    
    LET l_ima.imauser=g_user    #資料所有者
    LET l_ima.imagrup=g_grup    #資料所有者所屬群
    LET l_ima.imaoriu=g_user    #資料建立者
    LET l_ima.imaorig=g_grup    #資料建立部門
    LET l_ima.imamodu=''        #資料修改者
    LET l_ima.imadate=''        #最近更改日
    LET l_ima.imaacti='Y'       #有效資料 
    LET l_ima.ima1001 = NULL    #中文名 
    LET l_ima.ima1002 = NULL    #英文名 
    LET l_ima.ima120 = '2'  
    LET l_ima.ima916 = g_plant   
 
#    IF l_ima.ima06 IS NULL THEN
#       LET l_ima.ima871 =0         #間接物料分攤率
#       LET l_ima.ima872 =''        #材料製造費用成本項目
#       LET l_ima.ima873 =0         #間接人工分攤率
#       LET l_ima.ima874 =''        #人工製造費用成本項目
#       LET l_ima.ima88  =0         #期間採購數量
#       LET l_ima.ima89  =0         #期間採購使用的期間(月)
#       LET l_ima.ima90  =0         #期間採購使用的期間(日)
#    END IF
#    IF l_ima.ima01[1,4]='MISC' THEN #NO:6808(養生)
#        LET l_ima.ima08='Z'
#    END IF
#    IF l_ima.ima35 is null THEN LET l_ima.ima35=' ' END IF
#    IF l_ima.ima36 is null THEN LET l_ima.ima36=' ' END IF
#    IF cl_null(l_ima.ima903) THEN LET l_ima.ima903 = 'N' END IF 
#    IF cl_null(l_ima.ima905) THEN LET l_ima.ima905 = 'N' END IF
#    IF cl_null(l_ima.ima910) THEN LET l_ima.ima910 = ' ' END IF 
#    LET l_ima.ima916 = g_plant
#    LET l_ima.ima917 = 0
#    IF l_ima.ima131 IS NULL THEN LET l_ima.ima131 = ' ' END IF  
#    IF l_ima.ima926 IS NULL THEN LET l_ima.ima926 = 'N' END IF  
    RETURN l_ima.*
END FUNCTION
 
FUNCTION i840_copy_insert(l_ima,l_newno)
   DEFINE l_ima RECORD LIKE ima_file.*
   DEFINE l_newno LIKE ima_file.ima01
   DEFINE l_smd   RECORD LIKE smd_file.*
   DEFINE l_imt   RECORD LIKE imt_file.*       
   DEFINE l_gbc   RECORD LIKE gbc_file.*
    BEGIN WORK
    LET l_ima.ima571 = l_newno 
#FUN-C20065 --------Begin---------
    IF cl_null(l_ima.ima159) THEN
       LET l_ima.ima159 = '3'
    END IF
#FUN-C20065 --------End-----------
    IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF      #TQC-C20131  add
    IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF      #FUN-C50036  add
    INSERT INTO ima_file VALUES (l_ima.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err(l_ima.ima01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN FALSE
    ELSE
       CALL s_zero(l_newno)
       COMMIT WORK
       RETURN TRUE
    END IF
END FUNCTION

FUNCTION i840_r()
    DEFINE l_chr    LIKE type_file.chr1    
    DEFINE l_azo06  LIKE azo_file.azo06
    DEFINE l_n      LIKE type_file.num5    
    
 
    IF s_shut(0) THEN RETURN FALSE END IF
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN FALSE
    END IF
    IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'r') THEN
       CALL cl_err(g_ima.ima916,'aoo-044',1)
       RETURN FALSE
    END IF
    IF g_ima.ima1010 = '1' THEN
       #此筆資料已確認
       CALL cl_err(g_ima.ima01,'9023',1)
       RETURN FALSE
    END IF
 
    BEGIN WORK
    OPEN i840_cl USING g_ima.ima01
    IF SQLCA.sqlcode THEN
    #   ROLLBACK WORK    #FUN-B80060  下移兩行
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       ROLLBACK WORK    #FUN-B80060
       RETURN
       
    END IF
    FETCH i840_cl INTO g_ima.*
    IF SQLCA.sqlcode THEN
    #   ROLLBACK WORK    #FUN-B80060  下移兩行
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       ROLLBACK WORK    #FUN-B80060
       RETURN
    END IF
    CALL s_chkitmdel(g_ima.ima01) RETURNING g_errno
    IF NOT cl_null(g_errno) THEN
       ROLLBACK WORK    
       CALL cl_err('',g_errno,0)
       RETURN
    END IF
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          
        LET g_doc.column1 = "ima01"         
        LET g_doc.value1 = g_ima.ima01      
        CALL cl_del_doc()                                         
        #No.FUN-550103 Start,如果當前料件是子料件則要刪除其在imx_file中對應的紀錄
        IF g_ima.imaag = '@CHILD' THEN
           DELETE FROM imx_file WHERE imx000 = g_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imx_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  
              ROLLBACK WORK
              RETURN
           END IF
        END IF

        IF (NOT cl_del_itemname("ima_file","ima02", g_ima.ima01)) THEN   
           ROLLBACK WORK
           RETURN             
        END IF
        IF (NOT cl_del_itemname("ima_file","ima021",g_ima.ima01)) THEN   
           ROLLBACK WORK
           RETURN              
        END IF
 
        DELETE FROM ima_file WHERE ima01 = g_ima.ima01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)   
           ROLLBACK WORK  
           RETURN     
        ELSE
           CALL cl_del_pic("ima01",g_ima.ima01,"ima04") 
            UPDATE ima_file SET imadate=g_today WHERE ima01 = g_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","imc_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  
              ROLLBACK WORK
              RETURN 
           END IF
           UPDATE ima_file SET imadate=g_today WHERE ima01 = g_ima.ima01
           LET g_msg=TIME
           CLEAR FORM
           CALL i840_list_fill()            
        END IF
       COMMIT WORK    
       CLOSE i840_cl  
       RETURN TRUE 
    END IF
    CLOSE i840_cl
    RETURN FALSE
END FUNCTION

FUNCTION i840_list_fill()
  DEFINE l_ima01         LIKE ima_file.ima01
  DEFINE l_i             LIKE type_file.num10
 
    CALL g_ima_l.clear()
    LET l_i = 1
    FOREACH aimi840_list_cur INTO l_ima01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT ima01,ima02,ima021,ima06,ima08,ima130,ima109,
              ima25,ima37,ima1010,imaacti,ima916
         INTO g_ima_l[l_i].*
         FROM ima_file
        WHERE ima01=l_ima01
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH

    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_ima_l TO s_ima_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
 
END FUNCTION

FUNCTION i840_out()        #--打印
    DEFINE l_cmd           LIKE type_file.chr1000         
 
    IF cl_null(g_wc) AND NOT cl_null(g_ima.ima01) THEN
        LET g_wc=" ima01='",g_ima.ima01,"'"
    END IF
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN
    END IF
 
    #報表轉為使用 p_query
    LET l_cmd = ' p_query "almi840" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
    RETURN
END FUNCTION

FUNCTION i840_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1        
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ima01",TRUE)                
   END IF
 
END FUNCTION
 
FUNCTION i840_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1        
   DEFINE l_errno LIKE type_file.chr1 

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ima01",FALSE)
   END IF
   #當參數設定使用料件申請作業時,修改時不可更改料號/品名/規格
   IF g_aza.aza60 = 'Y' AND p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ima01,ima02,ima021",FALSE)
   END IF
 
END FUNCTION

FUNCTION ima_default()
 
#   LET g_ima.ima07 = 'A'
#   LET g_ima.ima08 = 'M'
#   LET g_ima.ima108='N'
#   LET g_ima.ima14 = 'N'
#   LET g_ima.ima15 = 'N'
#   LET g_ima.ima16 = 99
#   LET g_ima.ima18 = 0
#   LET g_ima.ima09 = ' '
#   LET g_ima.ima10 = ' '
#   LET g_ima.ima11 = ' '
#   LET g_ima.ima23 = ' '
#   LET g_ima.ima24 = 'N'
#   LET g_ima.ima27 = 0
#   LET g_ima.ima271 = 0
#   LET g_ima.ima28 = 0
#   LET g_ima.ima30= g_today    
#   LET g_ima.ima31_fac = 1
#   LET g_ima.ima32 = 0
#   LET g_ima.ima33 = 0     
#   LET g_ima.ima37 = '0'
#   LET g_ima.ima38 = 0
#   LET g_ima.ima40 = 0
#   LET g_ima.ima41 = 0
#   LET g_ima.ima42 = '0'
#   LET g_ima.ima44_fac = 1
#   LET g_ima.ima45 = 0
#   LET g_ima.ima46 = 0
#   LET g_ima.ima47 = 0
#   LET g_ima.ima48 = 0
#   LET g_ima.ima49 = 0
#   LET g_ima.ima491 = 0
#   LET g_ima.ima50 = 0
#   LET g_ima.ima51 = 1
#   LET g_ima.ima52 = 1
#   LET g_ima.ima140='N'
#   LET g_ima.ima53 = 0
#   LET g_ima.ima531 = 0
#   LET g_ima.ima55_fac = 1
#   LET g_ima.ima56 = 1
#   LET g_ima.ima561 = 1  #最少生產數量
#   LET g_ima.ima562 = 0  #生產時損耗率
#   LET g_ima.ima57 = 0
#   LET g_ima.ima58 = 0
#   LET g_ima.ima59 = 0
#   LET g_ima.ima60 = 0
#   LET g_ima.ima61 = 0
#   LET g_ima.ima62 = 0
#   LET g_ima.ima63_fac = 1
#   LET g_ima.ima64 = 0
#   LET g_ima.ima641 = 0   #最少發料數量
#   LET g_ima.ima65 = 0
#   LET g_ima.ima66 = 0
#   LET g_ima.ima68 = 0
#   LET g_ima.ima69 = 0
#   LET g_ima.ima70 = 'N'
#   LET g_ima.ima107='N'
#   LET g_ima.ima71 = 0
#   LET g_ima.ima72 = 0
#   LET g_ima.ima75 = ''
#   LET g_ima.ima76 = ''
#   LET g_ima.ima77 = 0
#   LET g_ima.ima78 = 0
#   LET g_ima.ima80 = 0
#   LET g_ima.ima81 = 0
#   LET g_ima.ima82 = 0
#   LET g_ima.ima83 = 0
#   LET g_ima.ima84 = 0
#   LET g_ima.ima85 = 0
#   LET g_ima.ima852= 'N'
#   LET g_ima.ima853= 'N'
#   LET g_ima.ima86_fac = 1
#   LET g_ima.ima871 = 0
#   LET g_ima.ima873 = 0
#   LET g_ima.ima88 = 1
#   LET g_ima.ima91 = 0
#   LET g_ima.ima92 = 'N'
#   LET g_ima.ima93 = "NNNNNNNN"
#   LET g_ima.ima94 = ' '
#   LET g_ima.ima95 = 0
#   LET g_ima.ima96 = 0
#   LET g_ima.ima97 = 0
#   LET g_ima.ima98 = 0
#   LET g_ima.ima33 = 0        
#   LET g_ima.ima99 = 0
#   LET g_ima.ima100 = 'N'
#   LET g_ima.ima101 ='1'
#   LET g_ima.ima102 = '1'
#   LET g_ima.ima103 = '0'
#   LET g_ima.ima104 = '0'
#   LET g_ima.ima105 = 'N'
#   LET g_ima.ima110 = '1'
#   LET g_ima.ima139 = 'N'
#   LET g_ima.ima154 = 'N'  
#   LET g_ima.ima155 = 'N'  
   LET g_ima.ima916 = g_plant
   LET g_ima.ima901 = g_today
   LET g_ima.imauser = g_user
   LET g_ima.imaoriu = g_user 
   LET g_ima.imaorig = g_grup 
   LET g_ima.imadate = ''
   LET g_ima.imagrup = g_grup
  #新增料件時,狀況碼為0:開立,有效碼為Y
   LET g_ima.imaacti = 'Y' 
#產品資料
#   LET g_ima.ima130 = '1'
#   LET g_ima.ima121 = 0
#   LET g_ima.ima122 = 0
#   LET g_ima.ima123 = 0
#   LET g_ima.ima124 = 0
#   LET g_ima.ima125 = 0
#   LET g_ima.ima126 = 0
#   LET g_ima.ima127 = 0
#   LET g_ima.ima128 = 0
#   LET g_ima.ima129 = 0
#   LET g_ima.ima141 = '0'
#   LET g_ima.ima145 = 'N'
#   LET g_ima.ima148 = 0  
#   LET g_ima.ima1017 = 0                                                                                                            
#   LET g_ima.ima1018 = 0       
   LET g_ima.ima1010= '0' 
 
END FUNCTION
FUNCTION i840_show_pic()
     LET g_chr='N'
     LET g_chr1='N'
     LET g_chr2='N'
     IF g_ima.ima1010='1' THEN
         LET g_chr='Y'
     END IF
     CALL cl_set_field_pic1(g_chr,""  ,""  ,""  ,""  ,g_ima.imaacti,""    ,"")
                           #確認 ,核准,過帳,結案,作廢,有效   
     #圖形顯示
END FUNCTION                        
#No.FUN-A90049

