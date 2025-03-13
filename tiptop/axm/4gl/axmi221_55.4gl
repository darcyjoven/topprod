# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axmi221_5.4gl
# Descriptions...: 客戶主檔--財務信息--維護作業
# Date & Author..: 06/01/10 by yoyo 
# Modify         : No.FUN-590083 06/03/31 by Alexstar 新增資料多語言顯示功能
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-690025 06/09/20 By jamie 改判斷狀況碼occ1004
# Modify.........: No.FUN-690021 06/10/11 By Mandy 修改圖形顯示occ1004,應同axmi221
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740158 07/04/21 By Judy 資料審核仍可以修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0142 10/12/08 By wangxin 客戶財務資料維護時取消確認取消判斷邏輯
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"   
 
DEFINE
    l_occ           RECORD LIKE occ_file.*,
    l_occ_t         RECORD LIKE occ_file.*,
    l_occ_ct        RECORD LIKE occ_file.*,
    l_occ01_t              LIKE occ_file.occ01,
    l_occ06                LIKE occ_file.occ06,
    l_wc,l_sql             LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(300)
    l_argv1                LIKE occ_file.occ01,
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
 
FUNCTION i221_5(p_occ01)
    DEFINE   p_occ01    LIKE  occ_file.occ01
 
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXM")) THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
 
    IF cl_null(p_occ01) THEN
       RETURN
    ELSE
       LET l_argv1=p_occ01
    END IF
    
    INITIALIZE l_occ.* TO NULL
    INITIALIZE l_occ_t.* TO NULL
    
    LET l_forupd_sql = " SELECT * FROM occ_file  WHERE occ01 = ? FOR UPDATE "
    LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)
 
    DECLARE i221_5_cl CURSOR FROM l_forupd_sql     
    
    SELECT * INTO l_occ.*
      FROM  occ_file
     WHERE  occ01=p_occ01
    IF SQLCA.SQLCODE THEN
       RETURN
    END IF  
 
    LET p_row = 2 
    LET p_col = 2
 
    OPEN WINDOW i221_5_w AT p_row,p_col WITH FORM "axm/42f/axmi221_5" 
      ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
    IF NOT cl_null(p_occ01) THEN
       CALL i221_5_q()
    END IF
 
    LET g_action_choice=""
    CALL i221_5_menu()
 
    CLOSE WINDOW i221_5_w
   
END FUNCTION
 
FUNCTION i221_5_curs()
    CLEAR FORM
 
    IF cl_null(l_argv1) THEN  #2581
   INITIALIZE l_occ.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME l_wc ON                    # 螢幕上取條件
          occ01,occ02,occ1004,
          occ1017,occ1018,occ1019,occ1020,
          occ1021,occ06,
          occ1022,occ1024,
          occ1025,occ1026,occ1028
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
            CASE
             WHEN INFIELD(occ1022)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_occ6'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1022  
                  NEXT FIELD occ1022  
             WHEN INFIELD(occ1024)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_tqb'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1024
                  NEXT FIELD occ1024
             WHEN INFIELD(occ1025)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_tqb'
                  LET g_qryparam.state  = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO occ1025
                  NEXT FIELD occ1025
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
        LET l_wc = "occ01 ='",l_argv1,"'"
    END IF
 
    IF INT_FLAG THEN RETURN END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET l_wc = l_wc clipped," AND occuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET l_wc = l_wc clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET l_wc = l_wc clipped," AND occgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET l_wc = l_wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
    #End:FUN-980030
 
    LET l_sql="SELECT occ01 FROM occ_file ", # 組合出 SQL 指令
              " WHERE ",l_wc CLIPPED, " ORDER BY occ01"
 
    PREPARE i221_5_prepare FROM l_sql           # RUNTIME 編譯
    DECLARE i221_5_cs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i221_5_prepare
      LET l_sql= "SELECT COUNT(*) FROM occ_file WHERE ",l_wc CLIPPED
    PREPARE i221_precount FROM l_sql
    DECLARE i221_count CURSOR FOR i221_precount
END FUNCTION
 
FUNCTION i221_5_menu()
 
  DEFINE l_cmd           LIKE cob_file.cob08        #No.FUN-680137  VARCHAR(30)
 
    MENU " "
 
 
        ON ACTION query 
            LET g_action_choice="query"  
            IF cl_chk_act_auth() THEN    #cl_prichk('Q') THEN
                 CALL i221_5_q()
            END IF
 
 
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN    #cl_prichk('U') THEN
               CALL i221_5_u()
            END IF     
       
        ON ACTION credit_hold
              IF NOT cl_null(l_occ.occ01) THEN                                  
               LET g_cmd = "atmi221 '",l_occ.occ01,"'"                          
               CALL cl_cmdrun(g_cmd CLIPPED)                                    
            END IF                              
              
        ON ACTION help 
            CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()               #No.FUN-590083
            #EXIT MENU
           #圖形顯示
           #FUN-690021--------mod---str---
           #CALL cl_set_field_pic("","","","","",l_occ.occacti)
            CALL i221_5_show_pic()
           #FUN-690021--------mod---end---
           
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
 
        ON ACTION about       
            CALL cl_about()    
 
        ON ACTION controlg     
            CALL cl_cmdask()    
 
         #--NO.MOD-860078--
         ON IDLE g_idle_seconds                                                   
            CALL cl_on_idle()                                                     
         #--NO.MOD-860078 end---
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET g_action_choice = "exit"
            EXIT MENU
    END MENU
    
    CLOSE i221_5_cs
    
END FUNCTION
 
FUNCTION i221_5_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_msg           LIKE ima_file.ima01,          #No.FUN-680137 VARCHAR(40)
        l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_occ1004       LIKE occ_file.occ1004,
        l_imd02         LIKE imd_file.imd02
 
    DISPLAY BY NAME l_occ.occ1024,l_occ.occ1025
 
    INPUT BY NAME 
          l_occ.occ01, 
          l_occ.occ02,     l_occ.occ1004,  
          l_occ.occ1017,   l_occ.occ1018,       l_occ.occ1019,       l_occ.occ1020,       
          l_occ.occ1021,
          l_occ.occ06,
          l_occ.occ1022,    
          l_occ.occ1024,   l_occ.occ1025,       l_occ.occ1026,       l_occ.occ1028 
        WITHOUT DEFAULTS  
 
        BEFORE INPUT
            LET  g_before_input_done = FALSE
            CALL i221_5_set_entry(p_cmd)
            CALL i221_5_set_no_entry(p_cmd)
            CALL i221_5_set_no_required(p_cmd)
            CALL i221_5_set_required(p_cmd)
            LET g_before_input_done = TRUE
            
 
 
        AFTER FIELD occ1022
           IF NOT cl_null(l_occ.occ1022) THEN 
             IF  l_occ.occ1022 != l_occ.occ01 THEN
                  SELECT occ1004,occ06 INTO l_occ1004,l_occ06 FROM occ_file
                   WHERE occ01 = l_occ.occ1022
#                 IF l_occ1004 !='3' THEN        #No.FUN-690025
                  IF l_occ1004 !='1' THEN        #No.FUN-690025 
                     CALL cl_err('','aap-717',0) 
                     NEXT FIELD occ1022
                  END IF 
                  IF l_occ06 !='1' AND l_occ06!='3' THEN
                     CALL cl_err('','atm-217',0)
                     NEXT FIELD occ1022                                         
                  END IF            
                  CALL i221_5_occ1022('a')
                  IF NOT cl_null(g_errno) THEN
                     NEXT FIELD occ1022
                  END IF
              ELSE
                  DISPLAY l_occ.occ02 TO FORMONLY.occ02a   
             END IF
          END IF
 
        BEFORE FIELD occ1024
           IF cl_null(l_occ.occ1024) THEN
              LET l_occ.occ1024 = l_occ.occ1005
           END IF
 
        AFTER FIELD occ1024
           IF NOT cl_null(l_occ.occ1024) THEN
              CALL i221_5_occ1024('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 NEXT FIELD occ1024
              END IF
           END IF
           
        BEFORE FIELD occ1025
           IF cl_null(l_occ.occ1025) THEN
              LET l_occ.occ1025 = l_occ.occ1005
           END IF
 
        AFTER FIELD occ1025
           IF NOT cl_null(l_occ.occ1025) THEN
              CALL i221_5_occ1025('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) 
                 NEXT FIELD occ1025
              END IF
           END IF               
 
       AFTER FIELD  occ1019
          IF  NOT cl_null(l_occ.occ1019) THEN
              IF   l_occ.occ1019<l_occ.occ1018 THEN
                   CALL cl_err('occ1019','mfg2604',0)
                   NEXT FIELD occ1019
              END IF               
          END IF 
         
       AFTER FIELD  occ1018
          IF  NOT cl_null(l_occ.occ1018) THEN
              IF   l_occ.occ1019<l_occ.occ1018 THEN
                   CALL cl_err('occ1018','mfg2604',0)
                   NEXT FIELD occ1018
              END IF               
          END IF 
 
 
        ON ACTION controlp
            CASE
             WHEN INFIELD(occ1024)      
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = 'q_tqb'
                  LET g_qryparam.default1 = l_occ.occ1024 
                  CALL cl_create_qry() RETURNING l_occ.occ1024 
                  DISPLAY BY NAME l_occ.occ1024 
                  NEXT FIELD occ1024
             WHEN INFIELD(occ1025)      
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = 'q_tqb'
                  LET g_qryparam.default1 = l_occ.occ1025 
                  CALL cl_create_qry() RETURNING l_occ.occ1025 
                  DISPLAY BY NAME l_occ.occ1025 
                  NEXT FIELD occ1025     
             WHEN INFIELD(occ1022)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_occ6'
                 LET g_qryparam.default1 = l_occ.occ1022
                 CALL cl_create_qry() RETURNING l_occ.occ1022
                 DISPLAY BY NAME l_occ.occ1022
                 NEXT FIELD occ1022    
 
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
 
 
 
FUNCTION i221_5_occ1022(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_occ02   LIKE occ_file.occ02,
        l_occacti LIKE occ_file.occacti
 
    SELECT occ02,occacti INTO l_occ02,l_occacti FROM occ_file
     WHERE occ01 = l_occ.occ1022
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9329'
                                   LET l_occ02 = NULL
         WHEN l_occacti='N'        LET g_errno='9028' 
                                   LET l_occ02 = NULL
         #FUN-690023------mod-------
         #WHEN l_occacti MATCHES '[PH]'   LET g_errno = '9038'  #TQC-AB0142 mark
         #                                LET l_occ02 = NULL    #TQC-AB0142 mark
         #FUN-690023------mod-------
 
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(g_errno) THEN                                      
       CALL cl_err('',g_errno,0)                                      
       RETURN
    END IF                   
    DISPLAY l_occ02 TO FORMONLY.occ02a 
    SELECT occ11,occ1017,occ1018,occ1020,occ1021,occ1019,                 
           occ231,occ232,occ233                                                 
      INTO l_occ.occ11,l_occ.occ1017,l_occ.occ1018,l_occ.occ1020,           
           l_occ.occ1021,l_occ.occ1019,l_occ.occ231,l_occ.occ232,             
           l_occ.occ233                                                         
      FROM occ_file                                                             
     WHERE occ01=l_occ.occ1022                                                  
    DISPLAY BY NAME l_occ.occ11,l_occ.occ1017,l_occ.occ1018,                  
                    l_occ.occ1020,l_occ.occ1021,l_occ.occ1019,              
                    l_occ.occ231,l_occ.occ232,l_occ.occ233  
END FUNCTION
 
 
FUNCTION i221_5_occ1024(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_tqb02   LIKE tqb_file.tqb02,
        l_tqbacti LIKE tqb_file.tqbacti
 
    SELECT tqb02,tqbacti INTO l_tqb02,l_tqbacti FROM tqb_file
     WHERE tqb01 = l_occ.occ1024
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
 
FUNCTION i221_5_occ1025(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_tqb02   LIKE tqb_file.tqb02,
        l_tqbacti LIKE tqb_file.tqbacti
 
    SELECT tqb02,tqbacti INTO l_tqb02,l_tqbacti FROM tqb_file
     WHERE tqb01 = l_occ.occ1025
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
 
 
 
 
FUNCTION i221_5_q()
    LET g_row_count = 0
    LET g_curs_index = 0
#   CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""    
    CALL i221_5_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF 
    OPEN i221_count
    FETCH i221_count INTO g_row_count
    OPEN i221_5_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_occ.occ01,SQLCA.sqlcode,0)
        INITIALIZE l_occ.* TO NULL
    ELSE
        CALL i221_5_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
FUNCTION i221_5_fetch(p_flocc)
    DEFINE
        p_flocc    LIKE type_file.chr1        #No.FUN-680137 VARCHAR(1) 
 
    CASE p_flocc
        WHEN 'N' FETCH NEXT     i221_5_cs INTO l_occ.occ01
        WHEN 'P' FETCH PREVIOUS i221_5_cs INTO l_occ.occ01
        WHEN 'F' FETCH FIRST    i221_5_cs INTO l_occ.occ01
        WHEN 'L' FETCH LAST     i221_5_cs INTO l_occ.occ01
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
            FETCH ABSOLUTE g_jump i221_5_cs INTO l_occ.occ01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_occ.occ01,SQLCA.sqlcode,0)
        INITIALIZE l_occ.* TO NULL  #TQC-6B0105
        LET l_occ.occ01 = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_flocc
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump         # --改g_jump
       END CASE
    
#      CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO l_occ.* FROM occ_file
       WHERE occ01 = l_occ.occ01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_occ.occ01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","occ_file",l_occ.occ01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE l_occ.* TO NULL            
    ELSE
       CALL i221_5_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i221_5_show()
   DEFINE l_msg  LIKE ima_file.ima01         #No.FUN-680137  VARCHAR(40)
 
   DISPLAY BY NAME l_occ.occ01,l_occ.occ02,l_occ.occ1004,
                   l_occ.occ1017,l_occ.occ1018,l_occ.occ1019,
                   l_occ.occ1020,l_occ.occ1021,
                   l_occ.occ06,
                   l_occ.occ1022,l_occ.occ1024,
                   l_occ.occ1025,l_occ.occ1026,l_occ.occ1028
   CALL i221_5_occ1022('a')
   CALL i221_5_occ1024('a')
   CALL i221_5_occ1025('a')
 
  #圖形顯示
  #FUN-690021--------mod---str---
  #CALL cl_set_field_pic("","","","","",l_occ.occacti)
   CALL i221_5_show_pic()
  #FUN-690021--------mod---end---
   CALL cl_show_fld_cont()               #No.FUN-590083
 
END FUNCTION
 
FUNCTION i221_5_u()
    IF s_shut(0) THEN RETURN END IF
    IF l_occ.occ01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF l_occ.occacti='N' THEN
       CALL cl_err('','mfg0301',0)
       RETURN
    END IF
#TQC-740158.....begin mark
##   IF l_occ.occ1004!='1' THEN    #No.FUN-690025
#   IF l_occ.occ1004!='0' THEN    #No.FUN-690025
#      CALL cl_err('','atm-046',0)
#      RETURN
#   END IF
#TQC-740158.....end 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET l_occ01_t = l_occ.occ01
    BEGIN WORK
 
    OPEN i221_5_cl USING l_occ.occ01
    IF STATUS THEN
       CALL cl_err("OPEN i221_5_cl:", STATUS, 1)
       CLOSE i221_5_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i221_5_cl INTO l_occ.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_occ.occ01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET l_occ_t.*=l_occ.*
    LET l_occ.occmodu = g_user                #修改者
    LET l_occ.occdate = g_today               #修改日期
    CALL i221_5_show()                          # 顯示最新資料
    CALL i221_5_i("u")                      # 欄位更改
    IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET l_occ.*=l_occ_t.*
            CALL i221_5_show()
            CALL cl_err('',9001,0)
    END IF
    UPDATE occ_file SET occ_file.* = l_occ.*  # 更新DB
     WHERE occ01 = l_occ.occ01               # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(l_occ.occ01,SQLCA.sqlcode,0)   #No.FUN-660167
           CALL cl_err3("upd","occ_file",l_occ01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        END IF
    CLOSE i221_5_cl
    COMMIT WORK
 
END FUNCTION
  
FUNCTION i221_5_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
    IF INFIELD(occ06) OR ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("occ09,occ07",TRUE)
    END IF
 
END FUNCTION  
  
FUNCTION i221_5_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("occ01",FALSE)
    END IF
    IF l_occ.occ06 MATCHES '[4]' THEN
       CALL cl_set_comp_entry("occ1022",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i221_5_set_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  IF NOT g_before_input_done OR INFIELD(occ06) THEN
     IF l_occ.occ06 MATCHES '[13]' THEN
        CALL cl_set_comp_required("occ41",TRUE)
     END IF
  END IF
 
END FUNCTION
 
FUNCTION i221_5_set_no_required(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  IF NOT g_before_input_done OR INFIELD(occ06) THEN
     CALL cl_set_comp_required("occ41",FALSE)
  END IF
END FUNCTION
 
#FUN-690021------add----------
#show 圖示
FUNCTION i221_5_show_pic()
     LET g_chr='N'
     LET g_chr1='N'
     LET g_chr2='N'
     IF l_occ.occ1004='1' THEN                                                                                             
         LET g_chr='Y'                                                                                                      
     END IF                                                                                                                
     IF l_occ.occ1004='0' THEN
         LET g_chr1='Y'
     END IF
     IF l_occ.occ1004='2' THEN
         LET g_chr2='Y'
     END IF
     CALL cl_set_field_pic1(g_chr,""  ,""  ,""  ,""  ,l_occ.occacti,""    ,g_chr2)
                           #確認 ,核准,過帳,結案,作廢,有效         ,申請  ,留置
END FUNCTION
#FUN-690021------add--end-----
