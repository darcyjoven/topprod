# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: axmi250_1.4gl
# Descriptions...: 客戶主檔--財務信息--維護作業
# Date & Author..: No.FUN-740193 07/05/10 By Mandy copy from axmi221_55.4gl 改寫
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"   
 
DEFINE
    l_occa           RECORD LIKE occa_file.*, #FUN-740193
    l_occa_t         RECORD LIKE occa_file.*,
    l_occa_ct        RECORD LIKE occa_file.*,
    l_occa01_t              LIKE occa_file.occa01,
    l_occano_t              LIKE occa_file.occano,
    l_occ06                 LIKE occ_file.occ06,
    l_wc,l_sql              LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(300)
    l_argv1                 LIKE occa_file.occano,
    g_buf                  LIKE ima_file.ima01,          #No.FUN-680137 VARCHAR(40)
    p_row,p_col            LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_forupd_sql           STRING,                       #SELECT ... FOR UPDATE  SQL  
    g_before_input_done    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    g_cmd                  LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(200)
 
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_chr1          LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_chr2          LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   i               LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   j               LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
FUNCTION i250_1(p_occano)
    DEFINE   p_occano    LIKE  occa_file.occano
 
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXM")) THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
 
    IF cl_null(p_occano) THEN
       RETURN
    ELSE
       LET l_argv1=p_occano
    END IF
    
    INITIALIZE l_occa.* TO NULL
    INITIALIZE l_occa_t.* TO NULL
    
    LET l_forupd_sql = " SELECT * FROM occa_file WHERE occa01 = ? FOR UPDATE "
    LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)
 
    DECLARE i250_1_cl CURSOR FROM l_forupd_sql     
    
    SELECT * INTO l_occa.*
      FROM  occa_file
     WHERE  occano=p_occano
    IF SQLCA.SQLCODE THEN
       RETURN
    END IF  
 
    LET p_row = 2 
    LET p_col = 2
 
    OPEN WINDOW i250_1_w AT p_row,p_col WITH FORM "axm/42f/axmi250_1" 
      ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
    IF NOT cl_null(p_occano) THEN
       CALL i250_1_q()
    END IF
 
    LET g_action_choice=""
    CALL i250_1_menu()
 
    CLOSE WINDOW i250_1_w
   
END FUNCTION
 
FUNCTION i250_1_curs()
    CLEAR FORM
 
    IF cl_null(l_argv1) THEN  #2581
   INITIALIZE l_occa.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME l_wc ON                    # 螢幕上取條件
          occa01,occa02,occa1004,
          occa1017,occa1018,occa1019,occa1020,
          occa1021,occa06,
          occa1022,occa1024,
          occa1025,occa1026,occa1028
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
            CASE
             WHEN INFIELD(occa1022)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occa6'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa1022  
                  NEXT FIELD occa1022  
             WHEN INFIELD(occa1024)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_tqb'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa1024
                  NEXT FIELD occa1024
             WHEN INFIELD(occa1025)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_tqb'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occa1025
                  NEXT FIELD occa1025
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
    ELSE
        LET l_wc = "occano='",l_argv1,"'"
    END IF
 
    IF INT_FLAG THEN RETURN END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET l_wc = l_wc clipped," AND occauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET l_wc = l_wc clipped," AND occagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET l_wc = l_wc clipped," AND occagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET l_wc = l_wc CLIPPED,cl_get_extra_cond('ccauser', 'ccagrup')
    #End:FUN-980030
 
    LET l_sql="SELECT occano FROM occa_file ", # 組合出 SQL 指令
              " WHERE ",l_wc CLIPPED, " ORDER BY occano"
 
    PREPARE i250_1_prepare FROM l_sql           # RUNTIME 編譯
    DECLARE i250_1_cs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i250_1_prepare
      LET l_sql= "SELECT COUNT(*) FROM occa_file WHERE ",l_wc CLIPPED
    PREPARE i221_precount FROM l_sql
    DECLARE i221_count CURSOR FOR i221_precount
END FUNCTION
 
FUNCTION i250_1_menu()
 
  DEFINE l_cmd           LIKE cob_file.cob08        #No.FUN-680137  VARCHAR(30)
 
    MENU " "
 
 
        ON ACTION query 
            LET g_action_choice="query"  
            IF cl_chk_act_auth() THEN    #cl_prichk('Q') THEN
                 CALL i250_1_q()
            END IF
 
 
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN    #cl_prichk('U') THEN
               CALL i250_1_u()
            END IF     
       
       #ON ACTION credit_hold
       #      IF NOT cl_null(l_occa.occa01) THEN                                  
       #       LET g_cmd = "atmi221 '",l_occa.occa01,"'"                          
       #       CALL cl_cmdrun(g_cmd CLIPPED)                                    
       #    END IF                              
              
        ON ACTION help 
            CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()               #No.FUN-590083
            #EXIT MENU
           #圖形顯示
           #FUN-690021--------mod---str---
           #CALL cl_set_field_pic("","","","","",l_occa.occaacti)
            CALL i250_1_show_pic()
           #FUN-690021--------mod---end---
           
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        #--NO.MOD-860078---
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
        #--NO.MOD-860078---
 
        ON ACTION about       
            CALL cl_about()    
 
        ON ACTION controlg     
            CALL cl_cmdask()    
 
          LET g_action_choice = "exit"
          CONTINUE MENU
    
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET g_action_choice = "exit"
            EXIT MENU
    END MENU
    
    CLOSE i250_1_cs
    
END FUNCTION
 
FUNCTION i250_1_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_msg           LIKE ima_file.ima01,          #No.FUN-680137 VARCHAR(40)
        l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_occ1004       LIKE occ_file.occ1004,
        l_imd02         LIKE imd_file.imd02
 
    DISPLAY BY NAME l_occa.occa1024,l_occa.occa1025
 
    INPUT BY NAME 
          l_occa.occa01, 
          l_occa.occa02,     l_occa.occa1004,  
          l_occa.occa1017,   l_occa.occa1018,       l_occa.occa1019,       l_occa.occa1020,       
          l_occa.occa1021,
          l_occa.occa06,
          l_occa.occa1022,    
          l_occa.occa1024,   l_occa.occa1025,       l_occa.occa1026,       l_occa.occa1028 
        WITHOUT DEFAULTS  
 
        BEFORE INPUT
            LET  g_before_input_done = FALSE
            CALL i250_1_set_entry(p_cmd)
            CALL i250_1_set_no_entry(p_cmd)
            CALL i250_1_set_no_required(p_cmd)
            CALL i250_1_set_required(p_cmd)
            LET g_before_input_done = TRUE
            
 
 
        AFTER FIELD occa1022 #發票客戶編號
           IF NOT cl_null(l_occa.occa1022) THEN 
               IF (l_occa.occa1022 != l_occa.occa01) THEN
                   IF cl_null(l_occa_t.occa1022) OR ( l_occa.occa1022 != l_occa_t.occa1022) THEN
                       SELECT occ1004,occ06  #occ1004狀態碼,occ06性質
                         INTO l_occ1004,l_occ06 
                         FROM occ_file
                        WHERE occ01 = l_occa.occa1022
#                      IF l_occ1004 !='3' THEN        #No.FUN-690025
                       IF l_occ1004 !='1' THEN        #No.FUN-690025 
                          #本資料尚未確認!
                          CALL cl_err('','aap-717',1) 
                          NEXT FIELD occa1022
                       END IF 
                       IF l_occ06 !='1' AND l_occ06!='3' THEN
                          #該客戶性質不符!
                          CALL cl_err('','atm-217',1)
                          NEXT FIELD occa1022                                         
                       END IF            
                       CALL i250_1_occa1022('a')
                       IF NOT cl_null(g_errno) THEN
                          NEXT FIELD occa1022
                       END IF
                   END IF
               ELSE
                   DISPLAY l_occa.occa02 TO FORMONLY.occa02a   
               END IF
          END IF
          LET l_occa_t.occa1022 = l_occa.occa1022
 
        BEFORE FIELD occa1024
           IF cl_null(l_occa.occa1024) THEN
              LET l_occa.occa1024 = l_occa.occa1005
           END IF
 
        AFTER FIELD occa1024
           IF NOT cl_null(l_occa.occa1024) THEN
              CALL i250_1_occa1024('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 NEXT FIELD occa1024
              END IF
           END IF
           
        BEFORE FIELD occa1025
           IF cl_null(l_occa.occa1025) THEN
              LET l_occa.occa1025 = l_occa.occa1005
           END IF
 
        AFTER FIELD occa1025
           IF NOT cl_null(l_occa.occa1025) THEN
              CALL i250_1_occa1025('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 NEXT FIELD occa1025
              END IF
           END IF               
 
       AFTER FIELD  occa1019
          IF  NOT cl_null(l_occa.occa1019) THEN
              IF   l_occa.occa1019<l_occa.occa1018 THEN
                   CALL cl_err('occa1019','mfg2604',0)
                   NEXT FIELD occa1019
              END IF               
          END IF 
         
       AFTER FIELD  occa1018
          IF  NOT cl_null(l_occa.occa1018) THEN
              IF   l_occa.occa1019<l_occa.occa1018 THEN
                   CALL cl_err('occa1018','mfg2604',0)
                   NEXT FIELD occa1018
              END IF               
          END IF 
 
 
        ON ACTION controlp
            CASE
             WHEN INFIELD(occa1024)      
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = 'q_tqb'
                  LET g_qryparam.default1 = l_occa.occa1024 
                  CALL cl_create_qry() RETURNING l_occa.occa1024 
                  DISPLAY BY NAME l_occa.occa1024 
                  NEXT FIELD occa1024
             WHEN INFIELD(occa1025)      
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = 'q_tqb'
                  LET g_qryparam.default1 = l_occa.occa1025 
                  CALL cl_create_qry() RETURNING l_occa.occa1025 
                  DISPLAY BY NAME l_occa.occa1025 
                  NEXT FIELD occa1025     
             WHEN INFIELD(occa1022)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_occ6'
                 LET g_qryparam.default1 = l_occa.occa1022
                 CALL cl_create_qry() RETURNING l_occa.occa1022
                 DISPLAY BY NAME l_occa.occa1022
                 NEXT FIELD occa1022    
 
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
 
 
 
FUNCTION i250_1_occa1022(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_occ02   LIKE occ_file.occ02,
        l_occacti LIKE occ_file.occacti
   IF l_occa.occa1022 <> l_occa.occa01 THEN
       SELECT occ02,occacti 
         INTO l_occ02,l_occacti 
         FROM occ_file
        WHERE occ01 = l_occa.occa1022
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9329'
                                      LET l_occ02 = NULL
            WHEN l_occacti='N'        LET g_errno='9028' 
                                      LET l_occ02 = NULL
            #FUN-690023------mod-------
            WHEN l_occacti MATCHES '[PH]'   LET g_errno = '9038'
                                            LET l_occ02 = NULL
            #FUN-690023------mod-------
       
            OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       IF NOT cl_null(g_errno) THEN                                      
          CALL cl_err('',g_errno,0)                                      
       ELSE
           DISPLAY l_occ02 TO FORMONLY.occa02a 
       END IF                   
    ELSE
       DISPLAY l_occa.occa02 TO FORMONLY.occa02a 
    END IF
    IF p_cmd = 'a' THEN
        SELECT occ1017,occ1018,occ1019,occ1020,occ1021
          INTO l_occa.occa1017,l_occa.occa1018,l_occa.occa1019,           
               l_occa.occa1020,l_occa.occa1021
          FROM occ_file                                                             
         WHERE occ01=l_occa.occa1022                                                  
    END IF
    DISPLAY BY NAME l_occa.occa1017,l_occa.occa1018,                  
                    l_occa.occa1019,l_occa.occa1020,l_occa.occa1021
END FUNCTION
 
 
FUNCTION i250_1_occa1024(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_tqb02   LIKE tqb_file.tqb02,
        l_tqbacti LIKE tqb_file.tqbacti
 
    SELECT tqb02,tqbacti INTO l_tqb02,l_tqbacti FROM tqb_file
     WHERE tqb01 = l_occa.occa1024
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9329'
                                   LET l_tqb02 = NULL
         WHEN l_tqbacti='N'        LET g_errno='9028' 
                                   LET l_tqb02 = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' OR p_cmd='u' THEN  
       DISPLAY l_tqb02 TO FORMONLY.tqb02  
    END IF
END FUNCTION
 
FUNCTION i250_1_occa1025(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_tqb02   LIKE tqb_file.tqb02,
        l_tqbacti LIKE tqb_file.tqbacti
 
    SELECT tqb02,tqbacti INTO l_tqb02,l_tqbacti FROM tqb_file
     WHERE tqb01 = l_occa.occa1025
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9329'
                                   LET l_tqb02 = NULL
         WHEN l_tqbacti='N'        LET g_errno='9028' 
                                   LET l_tqb02 = NULL
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' OR p_cmd='u' THEN  
       DISPLAY l_tqb02 TO FORMONLY.tqb02a  
    END IF
END FUNCTION
 
 
 
 
FUNCTION i250_1_q()
    LET g_row_count = 0
    LET g_curs_index = 0
#   CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""    
    CALL i250_1_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF 
    OPEN i221_count
    FETCH i221_count INTO g_row_count
    OPEN i250_1_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_occa.occa01,SQLCA.sqlcode,0)
        INITIALIZE l_occa.* TO NULL
    ELSE
        CALL i250_1_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
FUNCTION i250_1_fetch(p_flocca)
    DEFINE
        p_flocca    LIKE type_file.chr1        #No.FUN-680137 VARCHAR(1) 
 
    CASE p_flocca
        WHEN 'N' FETCH NEXT     i250_1_cs INTO l_occa.occano
        WHEN 'P' FETCH PREVIOUS i250_1_cs INTO l_occa.occano
        WHEN 'F' FETCH FIRST    i250_1_cs INTO l_occa.occano
        WHEN 'L' FETCH LAST     i250_1_cs INTO l_occa.occano
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
            FETCH ABSOLUTE g_jump i250_1_cs INTO l_occa.occano
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_occa.occano,SQLCA.sqlcode,0)
        INITIALIZE l_occa.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flocca
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump         # --改g_jump
       END CASE
    
#      CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO l_occa.* FROM occa_file
       WHERE occano = l_occa.occano
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_occa.occa01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","occa_file",l_occa.occano,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE l_occa.* TO NULL            
    ELSE
       CALL i250_1_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i250_1_show()
   DEFINE l_msg  LIKE ima_file.ima01         #No.FUN-680137  VARCHAR(40)
 
   DISPLAY BY NAME l_occa.occa01,l_occa.occa02,l_occa.occa1004,
                   l_occa.occa1017,l_occa.occa1018,l_occa.occa1019,
                   l_occa.occa1020,l_occa.occa1021,
                   l_occa.occa06,
                   l_occa.occa1022,l_occa.occa1024,
                   l_occa.occa1025,l_occa.occa1026,l_occa.occa1028
   CALL i250_1_occa1022('d')
   CALL i250_1_occa1024('a')
   CALL i250_1_occa1025('a')
 
  #圖形顯示
  #FUN-690021--------mod---str---
  #CALL cl_set_field_pic("","","","","",l_occa.occaacti)
   CALL i250_1_show_pic()
  #FUN-690021--------mod---end---
   CALL cl_show_fld_cont()               #No.FUN-590083
 
END FUNCTION
 
FUNCTION i250_1_u()
    IF s_shut(0) THEN RETURN END IF
    IF l_occa.occano IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF l_occa.occa00 = 'U' THEN
        #只有申請類別為'新增'時才能做!
        CALL cl_err(l_occa.occano,'aim-151',1)
        RETURN
    END IF
    IF l_occa.occaacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    #非開立狀態，不可異動！
    #狀況=>R:送簽退回,W:抽單 也要可以修改
    IF l_occa.occa1004 NOT MATCHES '[0RW]'  THEN CALL cl_err('','atm-046',1) RETURN END IF 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET l_occa01_t = l_occa.occa01
    LET l_occano_t = l_occa.occano
    BEGIN WORK
 
    OPEN i250_1_cl USING l_occa.occano
    IF STATUS THEN
       CALL cl_err("OPEN i250_1_cl:", STATUS, 1)
       CLOSE i250_1_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i250_1_cl INTO l_occa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_occa.occano,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET l_occa_t.*=l_occa.*
    LET l_occa.occamodu = g_user                #修改者
    LET l_occa.occadate = g_today               #修改日期
    CALL i250_1_show()                          # 顯示最新資料
    CALL i250_1_i("u")                      # 欄位更改
    IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET l_occa.*=l_occa_t.*
            CALL i250_1_show()
            CALL cl_err('',9001,0)
    END IF
    UPDATE occa_file SET occa_file.* = l_occa.*  # 更新DB
     WHERE occano = l_occano_t          # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(l_occa.occano,SQLCA.sqlcode,0)   #No.FUN-660167
           CALL cl_err3("upd","occa_file",l_occano_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        END IF
    CLOSE i250_1_cl
    COMMIT WORK
 
END FUNCTION
  
FUNCTION i250_1_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
    IF INFIELD(occa06) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("occa09,occa07",TRUE)
    END IF
 
END FUNCTION  
  
FUNCTION i250_1_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("occa01",FALSE)
    END IF
    IF l_occa.occa06 MATCHES '[4]' THEN
       CALL cl_set_comp_entry("occa1022",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i250_1_set_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  IF NOT g_before_input_done OR INFIELD(occa06) THEN
     IF l_occa.occa06 MATCHES '[13]' THEN
        CALL cl_set_comp_required("occa41",TRUE)
     END IF
  END IF
 
END FUNCTION
 
FUNCTION i250_1_set_no_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  IF NOT g_before_input_done OR INFIELD(occa06) THEN
     CALL cl_set_comp_required("occa41",FALSE)
  END IF
END FUNCTION
 
FUNCTION i250_1_show_pic()
     SELECT * INTO l_occa.* FROM occa_file 
      WHERE occano = l_occa.occano
     IF l_occa.occa1004 MATCHES '[12]' THEN 
         LET g_chr1='Y' 
         LET g_chr2='Y' 
     ELSE 
         LET g_chr1='N' 
         LET g_chr2='N' 
     END IF
     CALL cl_set_field_pic(g_chr1,g_chr2,"","","",l_occa.occaacti)
# Memo        	: ps_confirm 確認碼, ps_approve 核准碼, ps_post 過帳碼
#               : ps_close 結案碼, ps_void 作廢碼, ps_valid 有效碼
END FUNCTION
