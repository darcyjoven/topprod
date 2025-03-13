# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmi221.4gl 
# Descriptions...: 客戶債權維護作業
# Date & Author..: 05/12/02 By day    
# Modify.........: No.FUN-590083 06/03/15 By Alexstar 增加資料多語言功能
# Modify.........: No.FUN-660104 06/06/15 By cl Error Message 調整
# Modify.........: No.TQC-680115 06/08/23 By Sarah 原本更改會卡開立狀態才能更改,將此判斷拿掉
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0043 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730101 07/03/29 By Judy 審核前新增客戶債權關系，插入不到庫中
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790104 07/09/21 By Judy 客戶編號開窗沒有資料顯示
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-840068 08/04/21 By TSD.Wind 自定功能欄位修改
# Modify.........: No.TQC-8C0086 08/12/30 By Smapmin 將tqk06/tqk07隱藏起來
# Modify.........: No.TQC-940020 09/05/07 By mike 無效的資料不可以刪除 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10148 10/01/22 By lilingyu 已審核的客戶編號也可維護客戶債權關系
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_tqk       RECORD LIKE tqk_file.*,  
       g_tqk_t     RECORD LIKE tqk_file.*,       #備份舊值
       g_tqk01_t   LIKE tqk_file.tqk01,          #Key值備份
       g_tqk02_t   LIKE tqk_file.tqk02,          #Key值備份
       g_tqk03_t   LIKE tqk_file.tqk03,          #Key值備份
       g_wc        LIKE type_file.chr1000,       #儲存 user 的查詢條件  #No.FUN-680120 VARCHAR(1000)
       g_sql       STRING                       #組 sql 用
DEFINE g_argv1 LIKE tqk_file.tqk01 
DEFINE g_forupd_sql         STRING         #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  LIKE type_file.num5         #判斷是否已執行 Before Input指令        #No.FUN-680120 SMALLINT
DEFINE g_chr                LIKE type_file.chr1         #No.FUN-680120 VARCHAR(1)
DEFINE g_cnt                LIKE type_file.num10        #No.FUN-680120 INTEGER
DEFINE g_i                  LIKE type_file.num5         #count/index for any purpose            #No.FUN-680120 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000      #No.FUN-680120 VARCHAR(72)
DEFINE g_curs_index         LIKE type_file.num10        #No.FUN-680120 INTEGER
DEFINE g_row_count          LIKE type_file.num10        #總筆數         #No.FUN-680120 INTEGER
DEFINE g_jump               LIKE type_file.num10        #查詢指定的筆數 #No.FUN-680120 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5         #是否開啟指定筆視窗        #No.FUN-680120 SMALLINT   #No.FUN-6A0072
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5,          #No.FUN-680120 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6B0014
        l_cnt           LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   LET g_argv1=ARG_VAL(1) 
 
   INITIALIZE g_tqk.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM tqk_file WHERE tqk01 =? AND tqk02 =? AND tqk03 =?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i221_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW i221_w AT p_row,p_col WITH FORM "atm/42f/atmi221" 
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("tqk06,tqk07",FALSE)   #TQC-8C0086
 
    IF NOT cl_null(g_argv1) THEN                                                
       SELECT COUNT(*) INTO l_cnt FROM tqk_file                              
        WHERE tqk01=g_argv1                                                 
       IF l_cnt=0 THEN                                                          
          CALL i221_a()                                                         
       ELSE                                                                     
          CALL i221_q()                                                         
       END IF                                                                   
    END IF                    
 
   LET g_action_choice = ""
   CALL i221_menu()
 
   CLOSE WINDOW i221_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i221_curs()
DEFINE ls STRING
    CLEAR FORM
    IF g_argv1 IS NULL OR g_argv1 = " " THEN   
       INITIALIZE g_tqk.* TO NULL      #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
           tqk01,tqk02,tqk03,tqk04,tqk05,tqk06,tqk07,
           tqkuser,tqkgrup,tqkmodu,tqkdate,tqkacti,
           #FUN-840068   ---start---
           tqkud01,tqkud02,tqkud03,tqkud04,tqkud05,
           tqkud06,tqkud07,tqkud08,tqkud09,tqkud10,
           tqkud11,tqkud12,tqkud13,tqkud14,tqkud15
           #FUN-840068    ----end----
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tqk01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_occ9"   #TQC-790104          
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tqk.tqk01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqk01
                 NEXT FIELD tqk01
              WHEN INFIELD(tqk02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_tqa"
                 LET g_qryparam.arg1 ="20"        
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tqk.tqk02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqk02
                 NEXT FIELD tqk02
              WHEN INFIELD(tqk03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ10"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tqk.tqk03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqk03
                 NEXT FIELD tqk03
              WHEN INFIELD(tqk04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_tqk.tqk04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqk04
                 NEXT FIELD tqk04
              WHEN INFIELD(tqk05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_tqk.tqk05
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqk05
                 NEXT FIELD tqk05
              OTHERWISE
                 EXIT CASE
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
 
    IF INT_FLAG THEN RETURN END IF                                  
    ELSE                                                                        
      LET g_wc = "tqk01  = '",g_argv1,"'"                                   
    END IF         
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND tqkuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND tqkgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND tgkgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tqkuser', 'tqkgrup')
    #End:FUN-980030
    LET g_sql="SELECT tqk01,tqk02,tqk03 FROM tqk_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY tqk01"
    PREPARE i221_prepare FROM g_sql
    DECLARE i221_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i221_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM tqk_file WHERE ",g_wc CLIPPED
    PREPARE i221_precount FROM g_sql
    DECLARE i221_count CURSOR FOR i221_precount
END FUNCTION
 
FUNCTION i221_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(100)
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i221_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i221_q()
            END IF
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i221_u()
            END IF
        ON ACTION invalid 
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i221_x()
            END IF
        ON ACTION delete 
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i221_r()
            END IF
        ON ACTION help 
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION next 
            CALL i221_fetch('N')
        ON ACTION previous 
            CALL i221_fetch('P')
        ON ACTION jump
            CALL i221_fetch('/')
        ON ACTION first
            CALL i221_fetch('F')
        ON ACTION last
            CALL i221_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()               #No.FUN-590083
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about       
           CALL cl_about()   
 
        #No.FUN-6B0043-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_tqk.tqk01 IS NOT NULL THEN            
                  LET g_doc.column1 = "tqk01"               
                  LET g_doc.column2 = "tqk02"     
                  LET g_doc.column3 = "tqk03"          
                  LET g_doc.value1 = g_tqk.tqk01            
                  LET g_doc.value2 = g_tqk.tqk02   
                  LET g_doc.value3 = g_tqk.tqk03         
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
         #No.FUN-6B0043-------add--------end---- 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET g_action_choice = "exit"
           EXIT MENU
      #FUN-810046
      &include "qry_string.4gl"
    END MENU
    CLOSE i221_cs
END FUNCTION
 
FUNCTION i221_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_tqk.* LIKE tqk_file.*
    LET g_tqk01_t = NULL
    LET g_tqk02_t = NULL
    LET g_tqk03_t = NULL
    LET g_wc = NULL 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tqk.tqkuser = g_user
        LET g_tqk.tqkoriu = g_user #FUN-980030
        LET g_tqk.tqkorig = g_grup #FUN-980030
        LET g_tqk.tqkgrup = g_grup               #使用者所屬群
        LET g_tqk.tqkdate = g_today
        LET g_tqk.tqkacti = 'Y'
        CALL i221_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_tqk.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
 
        IF g_tqk.tqk01 IS NULL OR
           g_tqk.tqk02 IS NULL OR
           g_tqk.tqk03 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO tqk_file VALUES(g_tqk.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
        #   CALL cl_err(g_tqk.tqk01,SQLCA.sqlcode,0)   #No.FUN-660104
            CALL cl_err3("ins","tqk_file",g_tqk.tqk01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            CONTINUE WHILE
        ELSE
            MESSAGE "insert ok"
            SELECT tqk01,tqk02,tqk03 INTO g_tqk.tqk01,g_tqk.tqk02,g_tqk.tqk03 FROM tqk_file
                     WHERE tqk01 = g_tqk.tqk01
                       AND tqk02 = g_tqk.tqk02
                       AND tqk03 = g_tqk.tqk03
        END IF
        EXIT WHILE
    END WHILE 
    LET g_wc=' '
END FUNCTION
 
FUNCTION i221_i(p_cmd)
   DEFINE   p_cmd         LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
            l_occ02       LIKE occ_file.occ02,
            l_tqa02       LIKE tqa_file.tqa02,
            l_occ021      LIKE occ_file.occ02,
            l_oag02       LIKE oag_file.oag02,
            l_azi02       LIKE azi_file.azi02,
            l_input       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1) 
            l_n           LIKE type_file.num5,          #No.FUN-680120 SMALLINT
            l_occ1004     LIKE occ_file.occ1004, 
            l_tqaacti     LIKE tqa_file.tqaacti 
 
   DISPLAY BY NAME
      g_tqk.tqk01,g_tqk.tqk02,g_tqk.tqk03,
      g_tqk.tqk04,g_tqk.tqk05,
      g_tqk.tqk06,g_tqk.tqk07,
      g_tqk.tqkuser,g_tqk.tqkgrup,g_tqk.tqkmodu,
      g_tqk.tqkdate,g_tqk.tqkacti
       
   INPUT BY NAME g_tqk.tqkoriu,g_tqk.tqkorig,
      g_tqk.tqk01,g_tqk.tqk02,g_tqk.tqk03,
      g_tqk.tqk04,g_tqk.tqk05,
      g_tqk.tqk06,g_tqk.tqk07,
      g_tqk.tqkuser,g_tqk.tqkgrup,g_tqk.tqkmodu,
      g_tqk.tqkdate,g_tqk.tqkacti,
      #FUN-840068     ---start---
      g_tqk.tqkud01,g_tqk.tqkud02,g_tqk.tqkud03,g_tqk.tqkud04,
      g_tqk.tqkud05,g_tqk.tqkud06,g_tqk.tqkud07,g_tqk.tqkud08,
      g_tqk.tqkud09,g_tqk.tqkud10,g_tqk.tqkud11,g_tqk.tqkud12,
      g_tqk.tqkud13,g_tqk.tqkud14,g_tqk.tqkud15 
      #FUN-840068     ----end----
      WITHOUT DEFAULTS 
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i221_set_entry(p_cmd)
          CALL i221_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
      AFTER FIELD tqk01
         IF NOT cl_null(g_argv1) THEN                                           
            IF g_tqk.tqk01 !=g_argv1 THEN
               LET g_tqk.tqk01=g_argv1                                      
	       DISPLAY BY NAME g_tqk.tqk01                                  
               NEXT FIELD tqk01
               CALL i221_tqk01('a')
            END IF
         ELSE
            IF NOT cl_null(g_tqk.tqk01) THEN
               IF g_tqk.tqk01 != g_tqk01_t OR g_tqk01_t IS NULL THEN 
                  CALL i221_tqk01('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('tqk01:',g_errno,1)
                     LET g_tqk.tqk01 = g_tqk01_t
                     DISPLAY BY NAME g_tqk.tqk01 
                     NEXT FIELD tqk01
                  END IF
                  SELECT COUNT(*) INTO l_n 
                    FROM occ_file
                   WHERE occ01   = g_tqk.tqk01 
#                    AND occacti = 'Y'   #TQC-730101
                    #AND occacti = 'P'   #TQC-730101      #TQC-A10148
                     AND (occacti = 'P' OR occacti ='Y')  #TQC-A10148
#                    AND occ1004 = '3'
                     AND occ06   = '1' 
                  IF l_n = 0 THEN                                     
                     CALL cl_err('','mfg2732',1)                        
                     LET g_tqk.tqk01 = g_tqk01_t                        
                     DISPLAY BY NAME g_tqk.tqk01                            
                     NEXT FIELD tqk01                                          
                  END IF 
               END IF
             END IF
         END IF                 
 
      AFTER FIELD tqk02
         IF NOT cl_null(g_tqk.tqk02) THEN
            IF p_cmd = "a" OR  p_cmd="u" THEN        # 若輸入或更改且改KEY
               CALL i221_tqk02('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('tqk02:',g_errno,1)
                  LET g_tqk.tqk02 = g_tqk02_t
                  DISPLAY BY NAME g_tqk.tqk02 
                  NEXT FIELD tqk02
               END IF
               SELECT COUNT(*) INTO l_n FROM tqa_file
                WHERE tqa01   = g_tqk.tqk02 
                  AND tqa03   = '20'
                  AND tqaacti = 'Y'
               IF l_n = 0 THEN                                     
                  CALL cl_err('','atm-334',1)                        
                  DISPLAY BY NAME g_tqk.tqk02                            
                  NEXT FIELD tqk02                                          
               END IF 
            END IF
         END IF
 
      AFTER FIELD tqk03
         IF NOT cl_null(g_tqk.tqk03) THEN
            IF g_tqk.tqk03 != g_tqk03_t OR g_tqk03_t IS NULL THEN 
              IF g_tqk.tqk03 !=g_tqk.tqk01 THEN 
                 CALL i221_tqk03('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('tqk03:',g_errno,1)
                    LET g_tqk.tqk03 = g_tqk03_t
                    DISPLAY BY NAME g_tqk.tqk03 
                    NEXT FIELD tqk03
                 END IF
                 IF p_cmd='a' THEN
                    SELECT COUNT(*) INTO l_n FROM occ_file
                     WHERE occ01  = g_tqk.tqk03 
                       AND occacti = 'Y' 
#                      AND occ1004 = '3' 
                       AND (occ06 = '1' OR occ06 = '4')
                 END IF
                 IF p_cmd='u' THEN
                    SELECT COUNT(*) INTO l_n FROM occ_file
                     WHERE occ01  = g_tqk.tqk03 
                       AND occacti = 'Y' 
                       AND (occ06 = '1' OR occ06 = '4')
                 END IF
                 IF l_n = 0 THEN                                     
                    CALL cl_err('','mfg2732',1)                        
                    DISPLAY BY NAME g_tqk.tqk03                            
                    NEXT FIELD tqk03                                          
                 END IF 
               ELSE 
                 CALL i221_tqk03('a')
              END IF 
            END IF
         END IF
         IF NOT cl_null(g_tqk.tqk01) AND 
            NOT cl_null(g_tqk.tqk02) AND NOT cl_null(g_tqk.tqk03) THEN
            IF p_cmd = "a" OR     # 若輸入或更改且改KEY     
             (p_cmd = "u" AND (g_tqk.tqk03 != g_tqk03_t 
              OR g_tqk.tqk01 != g_tqk01_t 
              OR g_tqk.tqk02 != g_tqk02_t)) THEN       
               SELECT count(*) INTO l_n 
                 FROM tqk_file 
                WHERE tqk01 = g_tqk.tqk01
                  AND tqk02 = g_tqk.tqk02
                  AND tqk03 = g_tqk.tqk03
               IF l_n > 0  THEN   
                  CALL cl_err('',-239,1)                        
                  LET g_tqk.tqk01 = g_tqk01_t                      
                  LET g_tqk.tqk02 = g_tqk02_t                      
                  LET g_tqk.tqk03 = g_tqk03_t                      
                  DISPLAY BY NAME g_tqk.tqk01                         
                  DISPLAY BY NAME g_tqk.tqk02                          
                  DISPLAY BY NAME g_tqk.tqk03                          
                  LET l_occ02 = ' '
                  LET l_occ021= ' '
                  LET l_tqa02 = ' '
                  DISPLAY l_occ02,l_occ021,l_tqa02 TO FORMONLY.occ02,occ021,tqa02
                  NEXT FIELD tqk01                                        
                END IF    
             END IF
          END IF                                                
 
 
      AFTER FIELD tqk04
         IF NOT cl_null(g_tqk.tqk04) THEN
            IF p_cmd = "a" OR  p_cmd = "u" THEN            # 若輸入或更改
               SELECT count(*) INTO l_n FROM oag_file 
                WHERE oag01 = g_tqk.tqk04 
               IF l_n <= 0 THEN
                  CALL cl_err('','mfg9357',1)
                  LET g_tqk.tqk04 = g_tqk_t.tqk04                      
                  NEXT FIELD tqk04
               END IF
               CALL i221_tqk04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('tqk04:',g_errno,1)
                  DISPLAY BY NAME g_tqk.tqk04 
                  NEXT FIELD tqk04
               END IF
            END IF
         END IF
 
      AFTER FIELD tqk05
         IF NOT cl_null(g_tqk.tqk05) THEN
            IF p_cmd = "a" OR p_cmd = "u" THEN            
               CALL i221_tqk05('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('tqk05:',g_errno,1)
                  DISPLAY BY NAME g_tqk.tqk05 
                  NEXT FIELD tqk05
               END IF
               SELECT count(*) INTO l_n FROM azi_file 
                WHERE azi01   = g_tqk.tqk05 
                  AND aziacti = 'Y'
               IF l_n <= 0 THEN
                  CALL cl_err('','mfg3008',1)
                  LET g_tqk.tqk05 = g_tqk_t.tqk05                      
                  NEXT FIELD tqk05
               END IF
            END IF
         END IF
 
      AFTER FIELD tqk06
         IF NOT cl_null(g_tqk.tqk06) THEN
             IF g_tqk.tqk06 <= 0 THEN
                CALL cl_err('','atm-337',1)
                LET g_tqk.tqk06 = g_tqk_t.tqk06                     
                NEXT FIELD tqk06
             END IF
         END IF
 
      AFTER FIELD tqk07
         IF NOT cl_null(g_tqk.tqk07) THEN
             IF g_tqk.tqk07 <= 0 THEN
                CALL cl_err('','atm-338',1)
                LET g_tqk.tqk07 = g_tqk_t.tqk07                      
                NEXT FIELD tqk07
             END IF
         END IF
 
 
        #FUN-840068     ---start---
        AFTER FIELD tqkud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tqkud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
      AFTER INPUT
         LET g_tqk.tqkuser = s_get_data_owner("tqk_file") #FUN-C10039
         LET g_tqk.tqkgrup = s_get_data_group("tqk_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_tqk.tqk01) OR cl_null(g_tqk.tqk02) OR
               cl_null(g_tqk.tqk03) THEN     
               DISPLAY BY NAME g_tqk.tqk01 
               NEXT FIELD tqk01
            END IF              
            
     ON ACTION controlp
        CASE
           WHEN INFIELD(tqk01)
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_occ9"       #TQC-790104    
              LET g_qryparam.default1 = g_tqk.tqk01
              CALL cl_create_qry() RETURNING g_tqk.tqk01
              DISPLAY BY NAME g_tqk.tqk01
              NEXT FIELD tqk01
           WHEN INFIELD(tqk02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tqa"
              LET g_qryparam.arg1 ="20"        
              LET g_qryparam.default1 = g_tqk.tqk02
              CALL cl_create_qry() RETURNING g_tqk.tqk02
              DISPLAY BY NAME g_tqk.tqk02
              NEXT FIELD tqk02
           WHEN INFIELD(tqk03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ10"
              LET g_qryparam.default1 = g_tqk.tqk03
              CALL cl_create_qry() RETURNING g_tqk.tqk03
              DISPLAY BY NAME g_tqk.tqk03
              NEXT FIELD tqk03
           WHEN INFIELD(tqk04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oag"
              LET g_qryparam.default1 = g_tqk.tqk04
              CALL cl_create_qry() RETURNING g_tqk.tqk04
              DISPLAY BY NAME g_tqk.tqk04
              NEXT FIELD tqk04
           WHEN INFIELD(tqk05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azi"
              LET g_qryparam.default1 = g_tqk.tqk05
              CALL cl_create_qry() RETURNING g_tqk.tqk05
              DISPLAY BY NAME g_tqk.tqk05
              NEXT FIELD tqk05
           OTHERWISE
              EXIT CASE
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
 
FUNCTION i221_tqk01(p_cmd)
 DEFINE
   p_cmd          LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_occ02        LIKE occ_file.occ02,
   l_occacti      LIKE occ_file.occacti
 
   LET g_errno=''
   SELECT occ02,occacti INTO l_occ02,l_occacti FROM occ_file
    WHERE occ01   = g_tqk.tqk01
#     AND occacti = 'Y'   #TQC-730101                    
     #AND occacti = 'P'   #TQC-730101          #TQC-A10148
      AND (occacti = 'P' OR occacti = 'Y')     #TQC-A10148
   CASE                                                                         
       WHEN SQLCA.sqlcode=100   
            LET g_errno='anm-027'                           
            LET l_occ02=NULL                                
       WHEN l_occacti='N'       
            LET g_errno='9028'
   #FUN-690023------mod-------
#      WHEN l_occacti MATCHES '[PH]'      #No.TQC-730101
       WHEN l_occacti MATCHES '[H]'       #No.TQC-730101
            LET g_errno = '9038'
            LET l_occ02=NULL                                
   #FUN-690023------mod-------                              
       OTHERWISE                                                                
            LET g_errno=SQLCA.sqlcode USING '------'                            
   END CASE                 
 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_occ02 TO FORMONLY.occ02
   END IF
 
END FUNCTION
 
FUNCTION i221_tqk02(p_cmd)
DEFINE
   p_cmd          LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_tqa02    LIKE tqa_file.tqa02,
   l_tqaacti  LIKE tqa_file.tqaacti
 
   LET g_errno=''
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti FROM tqa_file
    WHERE tqa01   = g_tqk.tqk02
      AND tqa03   = '20'
      AND tqaacti = 'Y'
   CASE                                                                         
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'                           
                                LET l_tqa02=NULL                                
       WHEN l_tqaacti='N'       LET g_errno='9028'                              
       OTHERWISE                                                                
            LET g_errno=SQLCA.sqlcode USING '------'                            
   END CASE                 
 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_tqa02 TO FORMONLY.tqa02
   END IF
END FUNCTION
 
FUNCTION i221_tqk03(p_cmd)
 DEFINE
   p_cmd          LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_occ021       LIKE occ_file.occ02,
   l_occacti      LIKE occ_file.occacti
 
   LET g_errno=''
   SELECT occ02,occacti INTO l_occ021,l_occacti FROM occ_file
    WHERE occ01   = g_tqk.tqk03
      AND occacti = 'Y' 
   CASE                                                                         
       WHEN SQLCA.sqlcode=100   LET g_errno = 'anm-027'    
                                LET l_occ021= NULL  
       WHEN l_occacti='N'       LET g_errno = '9028'                              
   #FUN-690023------mod-------
       WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
   #FUN-690023------mod-------       
       OTHERWISE                                                                
            LET g_errno=SQLCA.sqlcode USING '------'                            
   END CASE                 
 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_occ021 TO FORMONLY.occ021
   END IF
 
END FUNCTION
 
FUNCTION i221_tqk04(p_cmd)
DEFINE
   p_cmd          LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_oag02        LIKE oag_file.oag02
 
   LET g_errno=''
   SELECT oag02 INTO l_oag02 FROM oag_file
    WHERE oag01=g_tqk.tqk04
   CASE                                                                         
       WHEN SQLCA.sqlcode=100   LET g_errno = 'anm-027'    
                                LET l_oag02= NULL  
       OTHERWISE                                                                
            LET g_errno=SQLCA.sqlcode USING '------'                            
   END CASE                 
 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_oag02 TO FORMONLY.oag02
   END IF
END FUNCTION
 
FUNCTION i221_tqk05(p_cmd)
DEFINE
   p_cmd          LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_azi02        LIKE azi_file.azi02,
   l_aziacti      LIKE azi_file.aziacti
 
   LET g_errno=''
   SELECT azi02,aziacti INTO l_azi02,l_aziacti FROM azi_file
    WHERE azi01   = g_tqk.tqk05
      AND aziacti = 'Y'
   CASE                                                                         
       WHEN SQLCA.sqlcode=100   LET g_errno = 'anm-027'    
                                LET l_azi02 = NULL  
       WHEN l_aziacti='N'       LET g_errno = '9028'                              
       OTHERWISE                                                                
            LET g_errno=SQLCA.sqlcode USING '------'                            
   END CASE                 
 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_azi02 TO FORMONLY.azi02
   END IF
END FUNCTION
 
FUNCTION i221_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_tqk.* TO NULL            #NO.FUN-6B0043
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i221_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i221_count
    FETCH i221_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN i221_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqk.tqk01,SQLCA.sqlcode,0)
        INITIALIZE g_tqk.* TO NULL
    ELSE
        CALL i221_fetch('F')              # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
FUNCTION i221_fetch(p_fltqk)
    DEFINE
        p_fltqk          LIKE type_file.chr1            #No.FUN-680120 VARCHAR(1)
 
    CASE p_fltqk
        WHEN 'N' FETCH NEXT     i221_cs INTO g_tqk.tqk01,g_tqk.tqk02,g_tqk.tqk03
        WHEN 'P' FETCH PREVIOUS i221_cs INTO g_tqk.tqk01,g_tqk.tqk02,g_tqk.tqk03
        WHEN 'F' FETCH FIRST    i221_cs INTO g_tqk.tqk01,g_tqk.tqk02,g_tqk.tqk03
        WHEN 'L' FETCH LAST     i221_cs INTO g_tqk.tqk01,g_tqk.tqk02,g_tqk.tqk03
        WHEN '/'
            IF (NOT mi_no_ask) THEN   #No.FUN-6A0072
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
            FETCH ABSOLUTE g_jump i221_cs INTO g_tqk.tqk01,g_tqk.tqk02,g_tqk.tqk03
            LET mi_no_ask = FALSE   #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqk.tqk01,SQLCA.sqlcode,0)
        INITIALIZE g_tqk.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_fltqk
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_tqk.* FROM tqk_file    # 重讀DB,因TEMP有不被更新特性
       WHERE tqk01 = g_tqk.tqk01 AND tqk02 = g_tqk.tqk02 AND tqk03 = g_tqk.tqk03
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_tqk.tqk01,SQLCA.sqlcode,0)   #No.FUN-660104
        CALL cl_err3("sel","tqk_file",g_tqk.tqk01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
    ELSE
        LET g_data_owner=g_tqk.tqkuser           #FUN-4C0044權限控管
        LET g_data_group=g_tqk.tqkgrup
        CALL i221_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i221_show()
    LET g_tqk_t.* = g_tqk.*
     DISPLAY BY NAME g_tqk.tqk01,g_tqk.tqk02,g_tqk.tqk03, g_tqk.tqkoriu,g_tqk.tqkorig,
                     g_tqk.tqk04,g_tqk.tqk05,
                     g_tqk.tqk06,g_tqk.tqk07,
                     g_tqk.tqkuser,g_tqk.tqkgrup,g_tqk.tqkmodu,
                     g_tqk.tqkdate,g_tqk.tqkacti,
                     #FUN-840068     ---start---
                     g_tqk.tqkud01,g_tqk.tqkud02,g_tqk.tqkud03,g_tqk.tqkud04,
                     g_tqk.tqkud05,g_tqk.tqkud06,g_tqk.tqkud07,g_tqk.tqkud08,
                     g_tqk.tqkud09,g_tqk.tqkud10,g_tqk.tqkud11,g_tqk.tqkud12,
                     g_tqk.tqkud13,g_tqk.tqkud14,g_tqk.tqkud15 
                     #FUN-840068     ----end----
    CALL i221_tqk01('d')
    CALL i221_tqk02('d')
    CALL i221_tqk03('d')
    CALL i221_tqk04('d')
    CALL i221_tqk05('d')
    CALL cl_show_fld_cont()               #No.FUN-590083
END FUNCTION
 
FUNCTION i221_u()
    DEFINE l_confirm  LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
    IF g_tqk.tqk01 IS NULL OR g_tqk.tqk02 IS NULL OR g_tqk.tqk03 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   
    SELECT * INTO g_tqk.*
      FROM tqk_file
     WHERE tqk01=g_tqk.tqk01
       AND tqk02=g_tqk.tqk02
       AND tqk03=g_tqk.tqk03
    IF g_tqk.tqkacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
 
   #start TQC-680115 mark
   #SELECT occ1004 INTO l_confirm 
   #  FROM occ_file 
   # WHERE occ01 = g_tqk.tqk01
   # 
   #IF l_confirm != '1' THEN
   #   CALL cl_err('','atm-340',1)
   #   RETURN
   #END IF     
   #end TQC-680115 mark
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tqk01_t = g_tqk.tqk01
    LET g_tqk02_t = g_tqk.tqk02
    LET g_tqk03_t = g_tqk.tqk03
    BEGIN WORK
 
    OPEN i221_cl USING g_tqk.tqk01,g_tqk.tqk02,g_tqk.tqk03
    IF STATUS THEN
       CALL cl_err("OPEN i221_cl:", STATUS, 1)
       CLOSE i221_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i221_cl INTO g_tqk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqk.tqk01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_tqk.tqkmodu=g_user                  #修改者
    LET g_tqk.tqkdate = g_today               #修改日期
    CALL i221_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i221_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tqk.*=g_tqk_t.*
            CALL i221_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE tqk_file SET tqk_file.* = g_tqk.*    # 更新DB
            WHERE tqk01 = g_tqk01_t AND tqk02 = g_tqk02_t AND tqk03 = g_tqk03_t
        IF SQLCA.sqlcode THEN
        #   CALL cl_err(g_tqk.tqk01,SQLCA.sqlcode,0)   #No.FUN-660104
            CALL cl_err3("upd","tqk_file",g_tqk.tqk01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            CONTINUE WHILE
        END IF
        MESSAGE "update ok"
        EXIT WHILE
    END WHILE
    CLOSE i221_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i221_x()
    DEFINE l_confirm  LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
    IF g_tqk.tqk01 IS NULL OR g_tqk.tqk02 IS NULL OR g_tqk.tqk03 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    BEGIN WORK
 
    OPEN i221_cl USING g_tqk.tqk01,g_tqk.tqk02,g_tqk.tqk03
    IF STATUS THEN
       CALL cl_err("OPEN i221_cl:", STATUS, 1)
       CLOSE i221_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i221_cl INTO g_tqk.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tqk.tqk01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i221_show()
    IF cl_exp(0,0,g_tqk.tqkacti) THEN
        LET g_chr=g_tqk.tqkacti
        IF g_tqk.tqkacti='Y' THEN
            LET g_tqk.tqkacti='N'
        ELSE
            LET g_tqk.tqkacti='Y'
        END IF
        UPDATE tqk_file
            SET tqkacti=g_tqk.tqkacti
            WHERE tqk01 = g_tqk.tqk01 AND tqk02 = g_tqk.tqk02 AND tqk03 = g_tqk.tqk03
        IF SQLCA.SQLERRD[3]=0 THEN
        #   CALL cl_err(g_tqk.tqk01,SQLCA.sqlcode,0)   #No.FUN-660104
            CALL cl_err3("upd","tqk_file",g_tqk.tqk01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            LET g_tqk.tqkacti=g_chr
        END IF
        DISPLAY BY NAME g_tqk.tqkacti 
    END IF
    CLOSE i221_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i221_r()
    DEFINE l_confirm  LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
    IF g_tqk.tqk01 IS NULL OR g_tqk.tqk02 IS NULL OR g_tqk.tqk03 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
#TQC-940020  ----start                                                                                                              
    IF g_tqk.tqkacti='N' THEN                                                                                                       
       CALL cl_err('','abm-950',0)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
#TQC-940020  ----end    
    SELECT occ1004 INTO l_confirm 
      FROM occ_file 
     WHERE occ01 = g_tqk.tqk01
     
#   IF l_confirm != '1' THEN   #TQC-730101
    IF l_confirm != '0' THEN   #TQC-730101
       CALL cl_err('','atm-340',1)
       RETURN
    END IF
                          
    BEGIN WORK
 
    OPEN i221_cl USING g_tqk.tqk01,g_tqk.tqk02,g_tqk.tqk03
    IF STATUS THEN
       CALL cl_err("OPEN i221_cl:", STATUS, 0)
       CLOSE i221_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i221_cl INTO g_tqk.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tqk.tqk01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i221_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tqk01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "tqk02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "tqk03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tqk.tqk01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_tqk.tqk02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_tqk.tqk03      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM tqk_file WHERE tqk01 = g_tqk.tqk01
                              AND tqk02 = g_tqk.tqk02
                              AND tqk03 = g_tqk.tqk03
       MESSAGE "delete ok"
       CLEAR FORM
       OPEN i221_count
       FETCH i221_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i221_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i221_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE   #No.FUN-6A0072
          CALL i221_fetch('/')
       END IF
    END IF
    CLOSE i221_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i221_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("tqk01,tqk02,tqk03",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i221_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("tqk01,tqk02,tqk03",FALSE)
    END IF
 
END FUNCTION

