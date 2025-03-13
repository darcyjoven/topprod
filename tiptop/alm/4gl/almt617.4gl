# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: almt617.4gl
# Descriptions...: 卡取消掛失作業
# Date & Author..: NO.FUN-960058 09/10/16 By  destiny   
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30075 10/03/15 By shiwuying 在SQL后加上SQLCA.sqlcode判斷
# Modify.........: No:MOD-A30216 10/03/26 By Smapmin 將單頭的預設上筆資料功能拿掉
# Modify.........: No:FUN-A70064 10/07/12 By shaoyong 發卡原因抓取代碼類別='2.理由碼'且理由碼用途類別='G.卡異動原因'
# Modify.........: No:FUN-A70130 10/08/09 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80148 10/09/02 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位   
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B70041 11/07/06 By guoch
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C90070 12/09/21 By xumeimei 添加GR打印功能
# Modify.........: No:FUN-CA0096 12/11/27 By pauline 開放開啟卡號重複申請取消掛失作業
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960058--begin 
DEFINE g_lrx       RECORD LIKE lrx_file.*,
       g_lrx_t     RECORD LIKE lrx_file.*,  #備份舊值
       g_lrx01_t   LIKE lrx_file.lrx01,     #Key值備份
       g_wc        STRING,                  #儲存 user 的查詢條件       
       g_sql       STRING                  #組 sql 用    
  
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL       
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        
DEFINE g_chr                 LIKE lrx_file.lrxacti        #No.FUN-682202 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-682202 INTEGER
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-682202 VARCHAR(72)  
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-682202 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數       
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        
DEFINE g_no_ask             LIKE type_file.num5          #是否開啟指定筆視窗        s
DEFINE g_void                LIKE type_file.chr1
DEFINE g_confirm             LIKE type_file.chr1
#DEFINE g_kindtype            LIKE lrk_file.lrkkind      #FUN-A70130     mark
#DEFINE g_t1                  LIKE lrk_file.lrkslip      #FUN-A70130     mark
#DEFINE g_kindslip            LIKE lrk_file.lrkslip      #FUN-A70130     mark
DEFINE g_kindtype            LIKE oay_file.oaytype      #FUN-A70130
DEFINE g_t1                  LIKE oay_file.oayslip      #FUN-A70130
DEFINE g_kindslip            LIKE oay_file.oayslip      #FUN-A70130
#FUN-C90070----add---str
DEFINE g_wc1                 STRING
DEFINE l_table               STRING
TYPE sr1_t RECORD
    lrxplant  LIKE lrx_file.lrxplant, 
    lrx01     LIKE lrx_file.lrx01,
    lrx02     LIKE lrx_file.lrx02,
    lrx03     LIKE lrx_file.lrx03,
    lrx04     LIKE lrx_file.lrx04,
    lrx05     LIKE lrx_file.lrx05,
    lrx06     LIKE lrx_file.lrx06,
    lrx07     LIKE lrx_file.lrx07,
    lrx08     LIKE lrx_file.lrx08,
    lrx09     LIKE lrx_file.lrx09,
    rtz13     LIKE rtz_file.rtz13,
    azf03     LIKE azf_file.azf03
END RECORD
#FUN-C90070----add---end

 
MAIN
    OPTIONS
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   INITIALIZE g_lrx.* TO NULL
   #LET g_kindtype = '44' #FUN-A70130
   LET g_kindtype = 'N9' #FUN-A70130
 
   #FUN-C90070------add-----str
   LET g_pdate = g_today
   LET g_sql ="lrxplant.lrx_file.lrxplant,",
              "lrx01.lrx_file.lrx01,",
              "lrx02.lrx_file.lrx02,",
              "lrx03.lrx_file.lrx03,",
              "lrx04.lrx_file.lrx04,",
              "lrx05.lrx_file.lrx05,",
              "lrx06.lrx_file.lrx06,",
              "lrx07.lrx_file.lrx07,",
              "lrx08.lrx_file.lrx08,",
              "lrx09.lrx_file.lrx09,",
              "rtz13.rtz_file.rtz13,",
              "azf03.azf_file.azf03"
   LET l_table = cl_prt_temptable('almt617',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-C90070------add-----end 
   LET g_forupd_sql = "SELECT * FROM lrx_file WHERE lrx01 = ? FOR UPDATE "       
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t617_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW t617_w WITH FORM "alm/42f/almt617"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL t617_menu()
 
   CLOSE WINDOW t617_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)    #FUN-C90070 add
END MAIN
 
FUNCTION t617_curs()
DEFINE ls      STRING
 
    CLEAR FORM
    INITIALIZE g_lrx.* TO NULL     
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        lrxplant,lrxlegal,lrx01,lrx02,lrx03,lrx04,lrx05,lrx06,lrx07,
        lrx08,lrx09,lrxuser,lrxgrup,lrxoriu,lrxcrat,lrxmodu,lrxorig,
        lrxacti,lrxdate
        
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE           
              WHEN INFIELD(lrxplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrxplant"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrxplant
                 NEXT FIELD lrxplant                 
 
              WHEN INFIELD(lrxlegal)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrxlegal"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrxlegal
                 NEXT FIELD lrxlegal
                 
              WHEN INFIELD(lrx01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrx01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrx01
                 NEXT FIELD lrx01   
                                                
              WHEN INFIELD(lrx02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrx02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrx02
                 NEXT FIELD lrx02
                 
              WHEN INFIELD(lrx03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrx03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrx03
                 NEXT FIELD lrx03
                 
              WHEN INFIELD(lrx04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrx04_1"                    #FUN-A70064 mod
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrx04
                 NEXT FIELD lrx04
             #TQC-B70041 --begin
              WHEN INFIELD(lrx07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lrx07"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lrx07
                 NEXT FIELD lrx07
             #TQC-B70041 --end
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
 
 
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
		     CALL cl_qbe_save()
 
    END CONSTRUCT
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND lrxuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND lrxgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN   
    #        LET g_wc = g_wc clipped," AND lrxgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lrxuser', 'lrxgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT lrx01 FROM lrx_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ",
#        " AND lrxplant in ",g_auth," ",               
        " ORDER BY lrx01"
    PREPARE t617_prepare FROM g_sql
    DECLARE t617_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t617_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM lrx_file WHERE ",g_wc CLIPPED
#        " AND lrxplant in ",g_auth," "             
    PREPARE t617_precount FROM g_sql
    DECLARE t617_count CURSOR FOR t617_precount
END FUNCTION
 
FUNCTION t617_menu()
   DEFINE l_cmd  LIKE type_file.chr1000      
 #  DEFINE l_lrkdmy2 LIKE lrk_file.lrkdmy2    #FUN-A70130  mark
   DEFINE l_oayconf LIKE oay_file.oayconf    #FUN-A70130
  
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t617_a()
                 LET g_t1=s_get_doc_no(g_lrx.lrx01)
                 IF NOT cl_null(g_t1) THEN
         #FUN-A70130 ----------------------start-------------------------        
         #           SELECT lrkdmy2
         #             INTO l_lrkdmy2
         #             FROM lrk_file
         #            WHERE lrkslip = g_t1  
         #           IF l_lrkdmy2 = 'Y' THEN
                    SELECT oayconf
                      INTO l_oayconf
                      FROM oay_file
                     WHERE oayslip = g_t1
                    IF l_oayconf = 'Y' THEN 
         #FUN-A70130 -----------------------end---------------------------
                       CALL t617_confirm()
                    END IF    
                 END IF 
            END IF
            
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t617_q()
            END IF
        ON ACTION next
            CALL t617_fetch('N')
        ON ACTION previous
            CALL t617_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t617_u('w')
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL t617_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t617_r()
            END IF
#FUN-C90070------add------str
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
             CALL t617_out()
           END IF
#FUN-C90070------add------end
            
        ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
                 CALL t617_confirm()
           END IF  
           CALL t617_pic() 
                   
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t617_fetch('/')
        ON ACTION first
            CALL t617_fetch('F')
        ON ACTION last
            CALL t617_fetch('L')
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
 
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION related_document   
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_lrx.lrx01 IS NOT NULL THEN
                 LET g_doc.column1 = "lrx01"
                 LET g_doc.value1 = g_lrx.lrx01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE t617_cs
END FUNCTION
 
 
FUNCTION t617_a()
DEFINE  l_count    LIKE type_file.num5
DEFINE  li_result  LIKE type_file.num5
DEFINE  l_rtz13    LIKE rtz_file.rtz13     #FUN-A80148
DEFINE  l_azt02    LIKE azt_file.azt02
   
   SELECT COUNT(*) INTO l_count FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
    IF l_count < 1 THEN 
       CALL cl_err('','alm-606',1)
       RETURN 
    END IF    
    
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_lrx.* LIKE lrx_file.*
    LET g_lrx_t.*=g_lrx.*
    LET g_lrx01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lrx.lrxplant=g_plant
        LET g_lrx.lrxlegal =g_legal
        LET g_lrx.lrxuser = g_user
        LET g_lrx.lrxoriu = g_user 
        LET g_lrx.lrxorig = g_grup
        LET g_lrx.lrxgrup = g_grup               #使用者所屬群
        LET g_lrx.lrxacti = 'Y'
        LET g_lrx.lrxcrat = g_today
        LET g_lrx.lrx05 = g_today
        LET g_lrx.lrx06 ='N'
        DISPLAY BY NAME g_lrx.lrxplant
        DISPLAY BY NAME g_lrx.lrxlegal
        SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lrx.lrxplant
        SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lrx.lrxlegal
        DISPLAY l_rtz13 TO FORMONLY.rtz13
        DISPLAY l_azt02 TO FORMONLY.azt02
        LET g_data_plant = g_plant  #No.FUN-A10060

        CALL t617_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_lrx.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_lrx.lrx01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK
        LET g_success = 'Y'
        CALL s_auto_assign_no("alm",g_lrx.lrx01,g_lrx.lrxcrat,g_kindtype,"lrx_file","lrx01",g_lrx.lrxplant,"","")
           RETURNING li_result,g_lrx.lrx01
        IF (NOT li_result) THEN               
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_lrx.lrx01
        INSERT INTO lrx_file VALUES(g_lrx.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lrx_file",g_lrx.lrx01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
#        ELSE
#            SELECT lrx01 INTO g_lrx.lrx01 FROM lrx_file
#                     WHERE lrx01 = g_lrx.lrx01
        END IF
        IF g_success = 'N' THEN
           ROLLBACK WORK
           CONTINUE WHILE
        ELSE
           COMMIT WORK
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t617_i(p_cmd)
   DEFINE   p_cmd      LIKE type_file.chr1,          
            l_input    LIKE type_file.chr1,         
            l_n        LIKE type_file.num5,        
            l_n1       LIKE type_file.num5        
   DEFINE   li_result  LIKE type_file.num5
 
   DISPLAY BY NAME
      g_lrx.lrx01,g_lrx.lrx02,g_lrx.lrx03,g_lrx.lrx04,
      g_lrx.lrx05,g_lrx.lrx06,g_lrx.lrx07,g_lrx.lrx08,
      g_lrx.lrx09,g_lrx.lrxuser,g_lrx.lrxgrup,g_lrx.lrxmodu,
      g_lrx.lrxdate,g_lrx.lrxacti,g_lrx.lrxcrat,g_lrx.lrxoriu,
      g_lrx.lrxorig
 
   INPUT BY NAME 
      g_lrx.lrx01,g_lrx.lrx02,g_lrx.lrx04,g_lrx.lrx09,
      g_lrx.lrxuser,g_lrx.lrxgrup,g_lrx.lrxmodu,
      g_lrx.lrxdate,g_lrx.lrxacti,g_lrx.lrxcrat,
      g_lrx.lrxoriu,g_lrx.lrxorig
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL t617_set_entry(p_cmd)
          CALL t617_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("lrx01")
 
      AFTER FIELD lrx01
         IF g_lrx.lrx01 IS NOT NULL THEN 
            CALL s_check_no("alm",g_lrx.lrx01,g_lrx01_t,g_kindtype,"lrx_file","lrx01","")
                 RETURNING li_result,g_lrx.lrx01
            IF (NOT li_result) THEN
               LET g_lrx.lrx01=g_lrx_t.lrx01
               NEXT FIELD lrx01
            END IF
            DISPLAY BY NAME g_lrx.lrx01            
         END IF
         
       AFTER FIELD lrx02
           IF NOT cl_null(g_lrx.lrx02) THEN                          
              IF g_lrx.lrx02 != g_lrx_t.lrx02 OR
                 g_lrx_t.lrx02 IS NULL THEN
                #FUN-CA0096 mark START
                #SELECT count(*) INTO l_n1 FROM lrx_file
                # WHERE lrx02 = g_lrx.lrx02
                # IF l_n1>0 THEN 
                #    CALL cl_err('','alm-812',1)
                #    LET g_lrx.lrx02 = g_lrx_t.lrx02                                                                          
                #    NEXT FIELD lrx02 
                # END IF  
                #FUN-CA0096 mark END
                  CALL t617_lrx02('a')
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err('',g_errno,1)
                     LET g_lrx.lrx02 = g_lrx_t.lrx02
                     NEXT FIELD lrx02
                 END IF 
              END IF
           ELSE
           	  LET g_lrx.lrx03=NULL
           	  DISPLAY '' TO lrx03
           END IF
           
      AFTER FIELD lrx04
           IF NOT cl_null(g_lrx.lrx04) THEN
              CALL t617_lrx04('a')
              IF NOT cl_null(g_errno) THEN 
                  IF g_errno = 'anm-027' THEN
                     CALL cl_err("",'alm-31',1)
                  ELSE
                     CALL cl_err('',g_errno,1)
                  END IF
                 LET g_lrx.lrx04 = g_lrx_t.lrx04
                 NEXT FIELD lrx04
              END IF               
           ELSE 
              DISPLAY '' TO azf03
           END IF
           
      AFTER INPUT
         LET g_lrx.lrxuser = s_get_data_owner("lrx_file") #FUN-C10039
         LET g_lrx.lrxgrup = s_get_data_group("lrx_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_lrx.lrx01 IS NULL THEN
               DISPLAY BY NAME g_lrx.lrx01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD lrx01
            END IF
 
      #-----MOD-A30216---------
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(lrx01) THEN
      #      LET g_lrx.* = g_lrx_t.*
      #      CALL t617_show()
      #      NEXT FIELD lrx01
      #   END IF
      #-----END MOD-A30216-----
 
     ON ACTION controlp
        CASE
            WHEN INFIELD(lrx01)     #單據編號
               LET g_t1=s_get_doc_no(g_lrx.lrx01)
              # CALL q_lrk(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1      #FUN-A70130  mark
               CALL q_oay(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1      #FUN-A70130   add
               LET g_lrx.lrx01 = g_t1
               DISPLAY BY NAME g_lrx.lrx01
               NEXT FIELD lrx01
                       
           WHEN INFIELD(lrx02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lpj1"
              LET g_qryparam.arg1='5'
              LET g_qryparam.default1 = g_lrx.lrx02
              CALL cl_create_qry() RETURNING g_lrx.lrx02
              DISPLAY BY NAME g_lrx.lrx02
              CALL t617_lrx02('d')
              NEXT FIELD lrx02
 
           WHEN INFIELD(lrx04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azf03"                    #FUN-A70064
              LET g_qryparam.arg1='2'                            #FUN-A70064
              LET g_qryparam.arg2 = 'G'                          #FUN-A70064
              LET g_qryparam.default1 = g_lrx.lrx04
              CALL cl_create_qry() RETURNING g_lrx.lrx04
              DISPLAY BY NAME g_lrx.lrx04  
              CALL t617_lrx04('d')
              NEXT FIELD lrx04
              
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
END FUNCTION
 
FUNCTION t617_lrx02(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_cnt      LIKE type_file.num5,
   l_lpj01    LIKE lpj_file.lpj01,
   l_lpj02    LIKE lpj_file.lpj02,
   l_lpj09    LIKE lpj_file.lpj09
 
      SELECT lpj01,lpj09,lpj02
        INTO l_lpj01,l_lpj09,l_lpj02
        FROM lpj_file 
       WHERE lpj03=g_lrx.lrx02
      CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                                  LET l_lpj01=null
                                  LET l_lpj09=null
           WHEN l_lpj09 !='5'     LET g_errno='alm-813'
      OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE 
      IF cl_null(g_errno) THEN
         SELECT COUNT(*) INTO l_cnt FROM lnk_file
          WHERE lnk01 = l_lpj02
            AND lnk02 = '1'   
            AND lnk03 = g_lrx.lrxplant
            AND lnk05 = 'Y'   
         IF l_cnt = 0 THEN    
            LET g_errno = 'alm-694'   
         END IF               
      END IF  

      IF cl_null(g_errno) OR p_cmd= 'd' THEN      
         LET g_lrx.lrx03=l_lpj01          
         DISPLAY BY NAME g_lrx.lrx03
      END IF 
END FUNCTION
 
FUNCTION t617_lrx04(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1, 
   l_azfacti  LIKE azf_file.azfacti,
   l_azf03    LIKE azf_file.azf03,
   l_azf02    LIKE azf_file.azf02
   
   SELECT azfacti,azf02,azf03 INTO l_azfacti,l_azf02,l_azf03 
     FROM azf_file
    WHERE azf01=g_lrx.lrx04 AND azf02='2' AND azf09='G'         #FUN-A70064
    
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='anm-027'
                               LET l_azf03=NULL
        WHEN l_azfacti='N'     LET g_errno='9028'
        WHEN l_azf02 !='2'     LET g_errno='alm-814'
   OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE  
   
   IF cl_null(g_errno) OR p_cmd= 'd' THEN 
      DISPLAY l_azf03 TO azf03
   END IF 
   
END FUNCTION   
FUNCTION t617_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lrx.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t617_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t617_count
    FETCH t617_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t617_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lrx.lrx01,SQLCA.sqlcode,0)
        INITIALIZE g_lrx.* TO NULL
    ELSE
        CALL t617_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t617_fetch(p_fllrx)
    DEFINE
        p_fllrx         LIKE type_file.chr1           
 
    CASE p_fllrx
        WHEN 'N' FETCH NEXT     t617_cs INTO g_lrx.lrx01
        WHEN 'P' FETCH PREVIOUS t617_cs INTO g_lrx.lrx01
        WHEN 'F' FETCH FIRST    t617_cs INTO g_lrx.lrx01
        WHEN 'L' FETCH LAST     t617_cs INTO g_lrx.lrx01
        WHEN '/'
            IF (NOT g_no_ask) THEN                   
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
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t617_cs INTO g_lrx.lrx01
            LET g_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lrx.lrx01,SQLCA.sqlcode,0)
        INITIALIZE g_lrx.* TO NULL 
        RETURN
    ELSE
      CASE p_fllrx
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_lrx.* FROM lrx_file    # 重讀DB,因TEMP有不被更新特性
       WHERE lrx01 = g_lrx.lrx01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lrx_file",g_lrx.lrx01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_lrx.lrxuser           
        LET g_data_group=g_lrx.lrxgrup
        LET g_data_plant = g_lrx.lrxplant #No.FUN-A10060
        CALL t617_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t617_show()
DEFINE  l_rtz13    LIKE rtz_file.rtz13
DEFINE  l_azt02    LIKE azt_file.azt02
    LET g_lrx_t.* = g_lrx.*
    DISPLAY BY NAME g_lrx.lrxplant,g_lrx.lrxlegal,g_lrx.lrx01,g_lrx.lrx02,g_lrx.lrx03,
                    g_lrx.lrx04,g_lrx.lrx05,g_lrx.lrx06,g_lrx.lrx07,g_lrx.lrx08,
                    g_lrx.lrx09,g_lrx.lrxuser,g_lrx.lrxgrup,g_lrx.lrxmodu,g_lrx.lrxdate,
                    g_lrx.lrxacti,g_lrx.lrxcrat,g_lrx.lrxoriu,g_lrx.lrxorig
    CALL t617_lrx02('d')
    CALL t617_lrx04('d')
    CALL t617_pic()
    SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lrx.lrxplant
    SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lrx.lrxlegal
    DISPLAY l_rtz13 TO FORMONLY.rtz13
    DISPLAY l_azt02 TO FORMONLY.azt02
    CALL cl_show_fld_cont()                 
END FUNCTION
 
FUNCTION t617_u(p_w)
DEFINE p_w   like type_file.chr1
 
    IF g_lrx.lrx01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
    END IF
    IF g_lrx.lrx06 = 'Y' THEN 
       CALL cl_err(g_lrx.lrx01,'alm-027',1)
       RETURN 
    END IF 
    IF g_lrx.lrxacti = 'N' THEN
       CALL cl_err(g_lrx.lrx01,'alm-147',1)
       RETURN
    END IF 
    SELECT * INTO g_lrx.* FROM lrx_file WHERE lrx01=g_lrx.lrx01
    IF g_lrx.lrxacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lrx01_t = g_lrx.lrx01
    BEGIN WORK
 
    OPEN t617_cl USING g_lrx01_t
    IF STATUS THEN
       CALL cl_err("OPEN t617_cl:", STATUS, 1)
       CLOSE t617_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t617_cl INTO g_lrx.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrx.lrx01,SQLCA.sqlcode,1)
        RETURN
    END IF
 
   IF p_w != 'c' THEN 
    LET g_lrx.lrxmodu=g_user                  #修改者
    LET g_lrx.lrxdate = g_today  
   ELSE
    LET g_lrx.lrxmodu=NULL                  #修改者
    LET g_lrx.lrxdate = NULL  
 
   END IF 
 
 
             #修改日期
    CALL t617_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t617_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_lrx.*=g_lrx_t.*
            CALL t617_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE lrx_file SET lrx_file.* = g_lrx.*    # 更新DB
            WHERE lrx01 = g_lrx01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lrx_file",g_lrx.lrx01,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t617_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t617_x()
 
    IF g_lrx.lrx01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lrx.lrx06 = 'Y' THEN 
      CALL cl_err(g_lrx.lrx01,'alm-027',1)
      RETURN 
    END IF 
    LET g_lrx_t.*=g_lrx.*
    BEGIN WORK
 
    OPEN t617_cl USING g_lrx.lrx01
    IF STATUS THEN
       CALL cl_err("OPEN t617_cl:", STATUS, 1)
       CLOSE t617_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t617_cl INTO g_lrx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrx.lrx01,SQLCA.sqlcode,1)
       RETURN
    END IF

    CALL t617_show()
    IF cl_exp(0,0,g_lrx.lrxacti) THEN
        LET g_chr=g_lrx.lrxacti
        IF g_lrx.lrxacti='Y' THEN
            LET g_lrx.lrxacti='N'
        ELSE
            LET g_lrx.lrxacti='Y'
        END IF
        LET g_lrx.lrxmodu=g_user                  
        LET g_lrx.lrxdate = g_today        
        UPDATE lrx_file
            SET lrxacti=g_lrx.lrxacti,
                lrxmodu=g_lrx.lrxmodu,
                lrxdate=g_lrx.lrxdate
            WHERE lrx01=g_lrx.lrx01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_lrx.lrx01,SQLCA.sqlcode,0)
            LET g_lrx.lrxacti=g_chr
            LET g_lrx.lrxmodu=g_lrx_t.lrxmodu
            LET g_lrx.lrxdate=g_lrx_t.lrxdate
        END IF
        DISPLAY BY NAME g_lrx.lrxacti,g_lrx.lrxmodu,g_lrx.lrxdate
    END IF
    CALL t617_pic()
    CLOSE t617_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t617_r()
 
    IF g_lrx.lrx01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lrx.lrx06 = 'Y' THEN 
      CALL cl_err(g_lrx.lrx01,'alm-027',1)
      RETURN 
    END IF 
 
    IF g_lrx.lrxacti = 'N' THEN  
       CALL cl_err(g_lrx.lrx01,'alm-147',1)                                                                                         
       RETURN                                                                                                                       
    END IF
    LET g_lrx01_t = g_lrx.lrx01
    BEGIN WORK
 
    OPEN t617_cl USING g_lrx01_t
    IF STATUS THEN
       CALL cl_err("OPEN t617_cl:", STATUS, 0)
       CLOSE t617_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t617_cl INTO g_lrx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lrx.lrx01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t617_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lrx01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lrx.lrx01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lrx_file WHERE lrx01 = g_lrx01_t
       CLEAR FORM
       OPEN t617_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t617_cs
          CLOSE t617_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t617_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t617_cs
          CLOSE t617_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t617_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t617_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL t617_fetch('/')
       END IF
    END IF
    CLOSE t617_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t617_confirm()
   DEFINE l_lrx07         LIKE lrx_file.lrx07
   DEFINE l_lrx08         LIKE lrx_file.lrx08 
   DEFINE l_lpjpos        LIKE lpj_file.lpjpos  #FUN-D30007 add
   DEFINE l_lpjpos_o      LIKE lpj_file.lpjpos  #FUN-D30007 add 
   
   IF cl_null(g_lrx.lrx01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lrx.* FROM lrx_file
    WHERE lrx01 = g_lrx.lrx01
   
    LET l_lrx07 = g_lrx.lrx07
    LET l_lrx08 = g_lrx.lrx08
    
   IF cl_null(g_lrx.lrx02) THEN 
      CALL cl_err('','alm-493',1)
      RETURN 
   END IF 
   
   IF g_lrx.lrxacti ='N' THEN
      CALL cl_err(g_lrx.lrx01,'alm-004',1)
      RETURN
   END IF
   IF g_lrx.lrx06 = 'Y' THEN
      CALL cl_err(g_lrx.lrx01,'alm-005',1)
      RETURN
   END IF

  #FUN-D30007 add START
   SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj03 = g_lrx.lrx02 
   IF l_lpjpos_o <> '1' THEN
      LET l_lpjpos = '2'
   ELSE
      LET l_lpjpos = '1'
   END IF
  #FUN-D30007 add END

   BEGIN WORK 
   OPEN t617_cl USING g_lrx.lrx01
   IF STATUS THEN 
       CALL cl_err("open t617_cl:",STATUS,1)
       CLOSE t617_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t617_cl INTO g_lrx.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lrx.lrx01,SQLCA.sqlcode,0)
      CLOSE t617_cl
      ROLLBACK WORK
      RETURN 
    END IF    
 
   IF NOT cl_confirm("alm-006") THEN
       RETURN
   ELSE
   	  LET g_lrx.lrx06 = 'Y'
      LET g_lrx.lrx07 = g_user
      LET g_lrx.lrx08 = g_today
      
      UPDATE lrx_file
         SET lrx06 = g_lrx.lrx06,
             lrx07 = g_lrx.lrx07,
             lrx08 = g_lrx.lrx08
       WHERE lrx01 = g_lrx.lrx01
       
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lrx:',SQLCA.SQLCODE,0)
         LET g_lrx.lrx08 = "N"
         LET g_lrx.lrx07 = l_lrx07
         LET g_lrx.lrx08 = l_lrx08
         DISPLAY BY NAME g_lrx.lrx06,g_lrx.lrx07,g_lrx.lrx08,g_lrx.lrxmodu,g_lrx.lrxdate
         CLOSE t617_cl
         ROLLBACK WORK
         RETURN
       ELSE
          DISPLAY BY NAME g_lrx.lrx06,g_lrx.lrx07,g_lrx.lrx08,g_lrx.lrxmodu,g_lrx.lrxdate
          UPDATE lpj_file
             SET lpj09='2',
                 lpjpos = l_lpjpos  #FUN-D30007 add
           WHERE lpj03=g_lrx.lrx02
         #No.TQC-A30075 -BEGIN-----
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","lpj_file",g_lrx.lrx02,"",SQLCA.sqlcode,"","",0)
             LET g_lrx.lrx08 = "N"
             LET g_lrx.lrx07 = l_lrx07
             LET g_lrx.lrx08 = l_lrx08
             DISPLAY BY NAME g_lrx.lrx06,g_lrx.lrx07,g_lrx.lrx08,g_lrx.lrxmodu,g_lrx.lrxdate
             CLOSE t617_cl
             ROLLBACK WORK
             RETURN
          END IF
         #No.TQC-A30075 -END-------
       END IF
    END IF 
   CLOSE t617_cl
   COMMIT WORK      
END FUNCTION
 
FUNCTION t617_pic()
   CASE g_lrx.lrx06
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void = ''
      WHEN 'X'  LET g_confirm = ''
                LET g_void = 'Y'
      OTHERWISE LET g_confirm = ''
                LET g_void = ''
   END CASE
 
   #圖形顯示
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lrx.lrxacti)
END FUNCTION
 
FUNCTION t617_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1   
          
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lrx01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t617_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("lrx01",FALSE)
    END IF
 
END FUNCTION

#FUN-C90070-------add------str
FUNCTION t617_out()
DEFINE l_sql    LIKE type_file.chr1000, 
       l_rtz13  LIKE rtz_file.rtz13,
       l_azf03  LIKE azf_file.azf03,
       sr       RECORD
                lrxplant  LIKE lrx_file.lrxplant, 
                lrx01     LIKE lrx_file.lrx01,
                lrx02     LIKE lrx_file.lrx02,
                lrx03     LIKE lrx_file.lrx03,
                lrx04     LIKE lrx_file.lrx04,
                lrx05     LIKE lrx_file.lrx05,
                lrx06     LIKE lrx_file.lrx06,
                lrx07     LIKE lrx_file.lrx07,
                lrx08     LIKE lrx_file.lrx08,
                lrx09     LIKE lrx_file.lrx09
                END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lrxuser', 'lrxgrup')
     IF cl_null(g_wc) THEN LET g_wc = " lrx01 = '",g_lrx.lrx01,"'" END IF
     LET l_sql = "SELECT lrxplant,lrx01,lrx02,lrx03,lrx04,lrx05,lrx06,lrx07,lrx08,lrx09",
                 "  FROM lrx_file",
                 " WHERE ",g_wc CLIPPED
     PREPARE t617_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t617_cs1 CURSOR FOR t617_prepare1

     DISPLAY l_table
     FOREACH t617_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
  
       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=sr.lrxplant
       LET l_azf03 = ' '
       SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.lrx04 AND azf02='2'AND azf09='G'
       EXECUTE insert_prep USING sr.*,l_rtz13,l_azf03
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lrxplant,lrx01,lrx02,lrx03,lrx04,lrx05,lrx06,lrx07,lrx08,lrx09')
          RETURNING g_wc1
     CALL t617_grdata() 
END FUNCTION

FUNCTION t617_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF

   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt617")
       IF handler IS NOT NULL THEN
           START REPORT t617_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lrx01"
           DECLARE t617_datacur1 CURSOR FROM l_sql
           FOREACH t617_datacur1 INTO sr1.*
               OUTPUT TO REPORT t617_rep(sr1.*)
           END FOREACH
           FINISH REPORT t617_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t617_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lrx06  STRING

    
    ORDER EXTERNAL BY sr1.lrx01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc,g_wc1
              
        BEFORE GROUP OF sr1.lrx01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lrx06 = cl_gr_getmsg("gre-302",g_lang,sr1.lrx06)
            PRINTX sr1.*
            PRINTX l_lrx06

        AFTER GROUP OF sr1.lrx01

        
        ON LAST ROW

END REPORT
#FUN-C90070-------add------end

