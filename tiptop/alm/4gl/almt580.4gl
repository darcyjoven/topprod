# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almt580.4gl
# Descriptions...: 會員補積分作業
# Date & Author..: NO.FUN-960058 09/06/12 By destiny 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/25 By destiny construct新增字段 
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A70118 10/07/28 By shiwuying 增加lsm07交易門店字段
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80148 10/09/02 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No:FUN-A90040 10/12/02 By shenyang  取消 defray(支付明細) Action
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BA0067 11/10/21 By pauline 刪除lsm07欄位,增加lsm08,lsmplant,lsmlegal

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C50057 12/05/15 by pauline 取消lpo05欄位 增加lpo11欄位
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No:CHI-C80011 12/08/07 By Lori  alm-830 '該卡號對應的會員編號為空，請重新輸入！' 的控卡須拿掉
# Modify.........: No:FUN-C90070 12/09/14 By xumeimei 添加GR打印功能
# Modify.........: No:FUN-C90102 12/11/06 By pauline 將lsm_file檔案類別改為B.基本資料,將lsmplant用lsmstore取代
# Modify.........: No:FUN-CB0098 12/11/23 By Sakura 增加卡種生效範圍判斷
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_lpo       RECORD LIKE lpo_file.*,
       g_lpo_t     RECORD LIKE lpo_file.*,  #備份舊值
       g_lpo01_t   LIKE lpo_file.lpo01,     #Key值備份
       g_wc        STRING,                  #儲存 user 的查詢條件       
       g_sql       STRING                  #組 sql 用    
  
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL       
DEFINE g_before_input_done   LIKE type_file.num5          #判斷是否已執行 Before Input指令        
DEFINE g_chr                 LIKE lpo_file.lpoacti        #No.FUN-682202 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-682202 INTEGER
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-682202 VARCHAR(72)  
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-682202 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數       
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        
DEFINE g_no_ask              LIKE type_file.num5          #是否開啟指定筆視窗        
DEFINE g_void                LIKE type_file.chr1
DEFINE g_confirm             LIKE type_file.chr1
DEFINE g_success             LIKE type_file.chr1
DEFINE g_argv1               LIKE lpo_file.lpo01
DEFINE g_date                LIKE lpo_file.lpodate
DEFINE g_modu                LIKE lpo_file.lpomodu
#DEFINE g_kindtype            LIKE lrk_file.lrkkind      #FUN-A70130  mark
#DEFINE g_t1                  LIKE lrk_file.lrkslip      #FUN-A70130  mark
DEFINE g_kindtype            LIKE oay_file.oaytype     #FUN-A70130
DEFINE g_t1                  LIKE oay_file.oayslip      #FUN-A70130
DEFINE l_title               LIKE ze_file.ze03          #FUN-C50057 add 
#FUN-C90070----add---str
DEFINE g_wc1                 STRING
DEFINE l_table               STRING
TYPE sr1_t RECORD
    lpo01     LIKE lpo_file.lpo01,
    lpoplant  LIKE lpo_file.lpoplant, 
    lpo02     LIKE lpo_file.lpo02,
    lpj02     LIKE lpj_file.lpj02,
    lpo04     LIKE lpo_file.lpo04,
    lpo06     LIKE lpo_file.lpo06,
    lpo11     LIKE lpo_file.lpo11,
    lpo03     LIKE lpo_file.lpo03,
    lpk02     LIKE lpk_file.lpk02,
    lpk03     LIKE lpk_file.lpk03,
    lpk04     LIKE lpk_file.lpk04,
    lpo07     LIKE lpo_file.lpo07,
    lpo08     LIKE lpo_file.lpo08,
    lpo09     LIKE lpo_file.lpo09,
    rtz13     LIKE rtz_file.rtz13,
    lph02     LIKE lph_file.lph02
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
   
   #LET g_kindtype = '19' #FUN-A70130
   LET g_kindtype = 'L7' #FUN-A70130
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   INITIALIZE g_lpo.* TO NULL

   #FUN-C90070------add-----str
   LET g_pdate = g_today
   LET g_sql ="lpo01.lpo_file.lpo01,",
              "lpoplant.lpo_file.lpoplant,",
              "lpo02.lpo_file.lpo02,",
              "lpj02.lpj_file.lpj02,",
              "lpo04.lpo_file.lpo04,",
              "lpo06.lpo_file.lpo06,",
              "lpo11.lpo_file.lpo11,",
              "lpo03.lpo_file.lpo03,",
              "lpk02.lpk_file.lpk02,",
              "lpk03.lpk_file.lpk03,",
              "lpk04.lpk_file.lpk04,",
              "lpo07.lpo_file.lpo07,",
              "lpo08.lpo_file.lpo08,",
              "lpo09.lpo_file.lpo09,",
              "rtz13.rtz_file.rtz13,",
              "lph02.lph_file.lph02"
   LET l_table = cl_prt_temptable('almt580',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-C90070------add-----end 
   LET g_forupd_sql = "SELECT * FROM lpo_file WHERE lpo01 = ? FOR UPDATE "       
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t580_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW t580_w WITH FORM "alm/42f/almt580"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("lpo10", FALSE)    #FUN-BA0067 add 
  #add START
   IF g_aza.aza26 = '2' THEN
      SELECT ze03 INTO l_title FROM ze_file WHERE ze01= 'alm-h27' AND ze02= g_lang
      CALL cl_set_comp_att_text("lpo11",l_title)
   END IF
  #add END
   LET g_action_choice = ""
   CALL t580_menu()
 
   CLOSE WINDOW t580_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)    #FUN-C90070 add
END MAIN
 
FUNCTION t580_curs()
DEFINE ls      STRING
 
  IF NOT cl_null(g_argv1) THEN 
     LET g_wc=" lpo01= '",g_argv1,"'" 
     LET g_argv1=NULL 
  ELSE    
     CLEAR FORM
     INITIALIZE g_lpo.* TO NULL     
     CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        #lpo01,lpoplant,lpolegal,lpo02,lpo03,lpo04,lpo05,lpo06,lpo10,lpo07,lpo08,lpo09,          #FUN-C50057 mark
         lpo01,lpoplant,lpolegal,lpo02,lpo03,lpo04,lpo11,lpo06,lpo10,lpo07,lpo08,lpo09,          #FUN-C50057 add 
         lpouser,lpogrup,lpomodu,lpodate,lpoacti,lpocrat,lpoorig,lpooriu       #No.FUN-9B0136
     
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
     
         ON ACTION controlp
            CASE
               WHEN INFIELD(lpo01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpo01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpo01
                  NEXT FIELD lpo01
     
               WHEN INFIELD(lpoplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpoplant"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpoplant
                  NEXT FIELD lpoplant
 
               WHEN INFIELD(lpolegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpolegal"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpolegal
                  NEXT FIELD lpolegal
                                                     
               WHEN INFIELD(lpo02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpo02"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpo02
                  NEXT FIELD lpo02
                  
               WHEN INFIELD(lpo03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpo03"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpo03
                  NEXT FIELD lpo03
                  
               OTHERWISE
                  EXIT CASE
            END CASE
     
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
     
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
     
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
     
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
     
     
     
       ON ACTION qbe_select
          CALL cl_qbe_select()
       ON ACTION qbe_save
		      CALL cl_qbe_save()
     
     END CONSTRUCT
  END IF   
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND lpouser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND lpogrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN   
    #        LET g_wc = g_wc clipped," AND lpogrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpouser', 'lpogrup')
    #End:FUN-980030
 
    LET g_sql = "SELECT lpo01 FROM lpo_file ", # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY lpo01"
    PREPARE t580_prepare FROM g_sql
    DECLARE t580_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t580_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM lpo_file WHERE ",g_wc CLIPPED
    PREPARE t580_precount FROM g_sql
    DECLARE t580_count CURSOR FOR t580_precount
END FUNCTION
 
FUNCTION t580_menu()
   DEFINE l_cmd  LIKE type_file.chr1000 
   DEFINE l_msg  LIKE type_file.chr1000    
 # DEFINE l_lrkdmy2 LIKE lrk_file.lrkdmy2      #FUN-A70130  mark
   DEFINE l_oayconf LIKE oay_file.oayconf      #FUN-A70130
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t580_a()
                 LET g_t1=s_get_doc_no(g_lpo.lpo01)
                 IF NOT cl_null(g_t1) THEN
      #FUN-A70130  ----------------------start---------------------------
      #              SELECT lrkdmy2
      #                INTO l_lrkdmy2
      #                FROM lrk_file
      #               WHERE lrkslip = g_t1  
      #              IF l_lrkdmy2 = 'Y' THEN
                     SELECT oayconf INTO l_oayconf FROM oay_file
                     WHERE oayslip = g_t1
                     IF l_oayconf = 'Y' THEN

      #FUN-A70130  -----------------------end----------------------------
                       CALL t580_confirm()
                    END IF    
                 END IF                  
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t580_q()
            END IF
        ON ACTION next
            CALL t580_fetch('N')
        ON ACTION previous
            CALL t580_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t580_u('w')
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL t580_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t580_r()
            END IF
            
        ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
              CALL t580_confirm()
           END IF  
           CALL t580_pic() 

#FUN-C90070------add------str
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
             CALL t580_out()
           END IF
#FUN-C90070------add------end
#NO.FUN-960058                                 
#        ON ACTION void
#           LET g_action_choice = "void"     
#           IF cl_chk_act_auth() THEN 
#              CALL t580_v()
#           END IF    
#           CALL t580_pic() 
#NO.FUN-960058     
#NO.FUN-A90040  ---begin -- mark        
 #       ON ACTION defray
  #         LET g_action_choice = "defray"           
  #          IF cl_chk_act_auth() THEN
   #            IF NOT cl_null(g_lpo.lpo01) THEN                                                                                                 
   #                LET l_msg = "almt5801  '",g_lpo.lpo01 CLIPPED,"' "                                                                                                                        
  #                 CALL cl_cmdrun_wait(l_msg)
#                   LET g_argv1 = g_lpo.lpo01
#                   CALL t580_q()           
   #                CALL t580_show()                                                                    
  #             ELSE                                                                                                                  
   #               CALL cl_err('',-400,1)    
   #            END IF                                                                                        
   #         END IF  
 #NO.FUN-A90040  ---end -- mark              
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t580_fetch('/')
        ON ACTION first
            CALL t580_fetch('F')
        ON ACTION last
            CALL t580_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION related_document   
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_lpo.lpo01 IS NOT NULL THEN
                 LET g_doc.column1 = "lpo01"
                 LET g_doc.value1 = g_lpo.lpo01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE t580_cs
END FUNCTION
 
FUNCTION t580_a()
DEFINE l_count    LIKE type_file.num5
#DEFINE l_tqa06    LIKE tqa_file.tqa06    #No.FUN-960058
DEFINE li_result  LIKE type_file.num5
DEFINE l_rtz13    LIKE rtz_file.rtz13     #FUN-A80148
DEFINE l_azt02    LIKE azt_file.azt02
 
#No.FUN-960058--begin
#   SELECT tqa06 INTO l_tqa06 FROM tqa_file
#    WHERE tqa03 = '14'       	 
#      AND tqaacti = 'Y'
#      AND tqa01 IN(SELECT tqb03 FROM tqb_file
#     	              WHERE tqbacti = 'Y'
#     	                AND tqb09 = '2'
#     	                AND tqb01 = g_plant) 
#   IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN 
#      CALL cl_err('','alm-600',1)
#      RETURN 
#   END IF 
#No.FUN-960058--end   
 
   SELECT COUNT(*) INTO l_count FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
    IF l_count < 1 THEN 
       CALL cl_err('','alm-606',1)
       RETURN 
    END IF    
   
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_lpo.* LIKE lpo_file.*
    LET g_lpo_t.*=g_lpo.*
    LET g_lpo01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lpo.lpolegal=g_legal
        LET g_lpo.lpoplant=g_plant
        LET g_data_plant = g_plant #No.FUN-A10060
        LET g_lpo.lpouser = g_user
        LET g_lpo.lpooriu = g_user #FUN-980030
        LET g_lpo.lpoorig = g_grup #FUN-980030
        LET g_lpo.lpogrup = g_grup               #使用者所屬群
        LET g_lpo.lpoacti = 'Y'
        LET g_lpo.lpocrat = g_today
        SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lpo.lpoplant
        SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lpo.lpolegal
        DISPLAY l_rtz13 TO FORMONLY.rtz13
        DISPLAY l_azt02 TO FORMONLY.azt02 
        LET g_lpo.lpo07 ='N'
        CALL t580_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_lpo.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_lpo.lpo01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        CALL s_auto_assign_no("alm",g_lpo.lpo01,g_lpo.lpocrat,g_kindtype,"lpo_file","lpo01",g_lpo.lpoplant,"","")
           RETURNING li_result,g_lpo.lpo01
        IF (NOT li_result) THEN               
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_lpo.lpo01
        
        INSERT INTO lpo_file VALUES(g_lpo.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lpo_file",g_lpo.lpo01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT lpo01 INTO g_lpo.lpo01 FROM lpo_file
                     WHERE lpo01 = g_lpo.lpo01
        END IF
        EXIT WHILE
    END WHILE
    MESSAGE ""           #FUN-BA0067 add
    LET g_wc=' '
END FUNCTION
 
FUNCTION t580_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          
            l_lnt26   LIKE lnt_file.lnt26,
            l_input   LIKE type_file.chr1,         
            l_n       LIKE type_file.num5,        
            l_n1      LIKE type_file.num5     
   DEFINE   li_result LIKE type_file.num5               
   DEFINE   l_j       LIKE type_file.num5   #FUN-C50057 add 
 
   DISPLAY BY NAME
      g_lpo.lpo01,g_lpo.lpoplant,g_lpo.lpolegal,g_lpo.lpo02,g_lpo.lpo03,g_lpo.lpo04,
     #g_lpo.lpo05,g_lpo.lpo06,g_lpo.lpo10,g_lpo.lpo07,g_lpo.lpo08,        #FUN-C50057 mark
      g_lpo.lpo11,g_lpo.lpo06,g_lpo.lpo10,g_lpo.lpo07,g_lpo.lpo08,        #FUN-C50057 add
      g_lpo.lpo09,
      g_lpo.lpouser,g_lpo.lpogrup,g_lpo.lpomodu,
      g_lpo.lpodate,g_lpo.lpoacti,g_lpo.lpocrat
 
   INPUT BY NAME g_lpo.lpooriu,g_lpo.lpoorig,
     #g_lpo.lpo01,g_lpo.lpo02,g_lpo.lpo04,g_lpo.lpo05,       #FUN-C50057 mark
      g_lpo.lpo01,g_lpo.lpo02,g_lpo.lpo04,g_lpo.lpo11,       #FUN-C50057 add
      g_lpo.lpo06,g_lpo.lpo10
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL t580_set_entry(p_cmd)
          CALL t580_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("lpo01")
 
      AFTER FIELD lpo01
         IF g_lpo.lpo01 IS NOT NULL THEN  
            CALL s_check_no("alm",g_lpo.lpo01,g_lpo01_t,g_kindtype,"lpo_file","lpo01","")
                 RETURNING li_result,g_lpo.lpo01
            IF (NOT li_result) THEN
               LET g_lpo.lpo01=g_lpo_t.lpo01
               NEXT FIELD lpo01
            END IF
            DISPLAY BY NAME g_lpo.lpo01            
         END IF
                    
       AFTER FIELD lpo02
           IF NOT cl_null(g_lpo.lpo02) THEN                          
              IF g_lpo.lpo02 != g_lpo_t.lpo02 OR
                 g_lpo_t.lpo02 IS NULL THEN           
                 CALL t580_lpo02(p_cmd)
                 IF NOT cl_null(g_errno) THEN 
                    CALL cl_err('',g_errno,1)
                    LET g_lpo.lpo02 = g_lpo_t.lpo02
                    NEXT FIELD lpo02
                 END IF 
              END IF 
           ELSE 
           	  DISPLAY '' TO lpj02
           	  DISPLAY '' TO lph02
           	  DISPLAY '' TO lpo03
           	  DISPLAY '' TO lpk02
           	  DISPLAY '' TO lpk03
           	  DISPLAY '' TO lpk04
           	  DISPLAY '' TO lpk05
           	  DISPLAY '' TO lpo04
           END IF 
     
     #FUN-C50057 add START
      AFTER FIELD lpo11
         IF NOT cl_null(g_lpo.lpo11) THEN
            LET l_n = 0 
            SELECT COUNT(*) INTO l_n FROM lpo_file
              WHERE lpo11 = g_lpo.lpo11 
                AND lpo01 <> g_lpo.lpo01
            IF l_n > 0 THEN
               CALL cl_err('','alm-h26',0) 
               NEXT FIELD lpo11
            END IF
            IF g_aza.aza26 = '0' THEN
               IF length(g_lpo.lpo11) <> '10' THEN
                  CALL cl_err('','axr-021',0)
                  NEXT FIELD lpo11 
               END IF
               FOR l_j = 1 TO 2
                  IF g_lpo.lpo11[l_j,l_j] NOT MATCHES '[A-Z]' THEN
                       CALL cl_err('','axr-017',0)
                       NEXT FIELD lpo11 
                  END IF
               END FOR
               FOR l_j = 3 TO 10
                   IF g_lpo.lpo11[l_j,l_j] NOT MATCHES '[0-9]' THEN
                      CALL cl_err('','axr-018',0)
                      NEXT FIELD lpo11 
                   END IF
               END FOR
            END IF
         END IF

      ON CHANGE lpo11
         IF NOT cl_null(g_lpo.lpo11) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM lpo_file
              WHERE lpo11 = g_lpo.lpo11
                AND lpo01 <> g_lpo.lpo01
            IF l_n > 0 THEN
               CALL cl_err('','alm-h26',0)
               NEXT FIELD lpo11
            END IF
            IF g_aza.aza26 = '0' THEN
               IF length(g_lpo.lpo11) <> '10' THEN
                  CALL cl_err('','axr-021',0)
                  NEXT FIELD lpo11
               END IF
               FOR l_j = 1 TO 2
                  IF g_lpo.lpo11[l_j,l_j] NOT MATCHES '[A-Z]' THEN
                       CALL cl_err('','axr-017',0)
                       NEXT FIELD lpo11
                  END IF
               END FOR
               FOR l_j = 3 TO 10
                   IF g_lpo.lpo11[l_j,l_j] NOT MATCHES '[0-9]' THEN
                      CALL cl_err('','axr-018',0)
                      NEXT FIELD lpo11
                   END IF
               END FOR
            END IF
         END IF
     #FUN-C50057 add END
                                             
      AFTER INPUT
         LET g_lpo.lpouser = s_get_data_owner("lpo_file") #FUN-C10039
         LET g_lpo.lpogrup = s_get_data_group("lpo_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_lpo.lpo01 IS NULL THEN
               DISPLAY BY NAME g_lpo.lpo01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD lpo01
            END IF
 
      ON ACTION CONTROLO                        # 沿用所有欄位
         IF INFIELD(lpo01) THEN
            LET g_lpo.* = g_lpo_t.*
            CALL t580_show()
            NEXT FIELD lpo01
         END IF
 
     ON ACTION controlp
        CASE
            WHEN INFIELD(lpo01)     #單據編號
               LET g_t1=s_get_doc_no(g_lpo.lpo01)
              # CALL q_lrk(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1     #FUN-A70130   mark
               CALL q_oay(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1     #FUN-A70130   add
               LET g_lpo.lpo01 = g_t1
               DISPLAY BY NAME g_lpo.lpo01
               NEXT FIELD lpo01
                                  
           WHEN INFIELD(lpo02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lpj3"
              LET g_qryparam.arg1 = g_today 
              LET g_qryparam.default1 = g_lpo.lpo02
              CALL cl_create_qry() RETURNING g_lpo.lpo02
              DISPLAY BY NAME g_lpo.lpo02
              NEXT FIELD lpo02                           
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
 
FUNCTION t580_lpo02(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,
   l_lpj01    LIKE lpj_file.lpj01,
   l_lpj02    LIKE lpj_file.lpj02,
   l_lpj04    LIKE lpj_file.lpj04,
   l_lpj05    LIKE lpj_file.lpj05,     
   l_lpj12    LIKE lpj_file.lpj12,
   l_lpj09    LIKE lpj_file.lpj09,
   l_lpk02    LIKE lpk_file.lpk02,
   l_lpk03    LIKE lpk_file.lpk03,
   l_lpk04    LIKE lpk_file.lpk04,
   l_lpk05    LIKE lpk_file.lpk05,
   l_lph02    LIKE lph_file.lph02,
   l_lph06    LIKE lph_file.lph06
 
  #SELECT lpm03,lpm04,lpm10,lpm12,lpm14,lpmacti 
  #  INTO l_lpm03,l_lpm04,l_lpm10,l_lpm12,l_lpm14,l_lpmacti 
  #  FROM lpm_file                                                                             
  # WHERE lpm09 = g_lpo.lpo02  
  #
  #CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-009'   
  #     WHEN l_lpm10='N'       LET g_errno='9029'
  #     WHEN l_lpm10='X'       LET g_errno='9024'                       
  #     WHEN l_lpmacti='N'     LET g_errno='9028'
  #     OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
  #END CASE 
  #IF cl_null(g_errno) AND (g_today<l_lpm12 OR g_today>l_lpm14) THEN 
  #   LET g_errno='alm-354'
  #END IF 
  #
  #IF cl_null(g_errno) THEN 
  #   SELECT lph02,lph06 INTO l_lph02,l_lph06 FROM lph_file WHERE lph01=l_lpm04
  #   IF l_lph06 !='Y' THEN 
  #      LET g_errno='alm-495'
  #   END IF 
  #END IF 

   SELECT lpj01,lpj02,lpj05,lpj04,lpj12,lpj09,lph02,lph06           
     INTO l_lpj01,l_lpj02,l_lpj05,l_lpj04,l_lpj12,l_lpj09,l_lph02,l_lph06 
      FROM lpj_file,lph_file                       
     WHERE lpj03 = g_lpo.lpo02  AND lpj02=lph01                                                  
    CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-202'                                     
     WHEN l_lpj09 != '2'    LET g_errno = 'alm-818'   
     WHEN l_lph06 !='Y'     LET g_errno = 'alm-829'
     WHEN l_lpj04 >g_today  LET g_errno = 'alm-827'
     WHEN l_lpj05 <g_today  LET g_errno = 'alm-827'                   
     OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'  
   END CASE         

   #CHI-C80011 mark begin---     
   #IF cl_null(l_lpj01) THEN 
   #   LET g_errno='alm-830'
   #END IF    
   #CHI-C80011 mark end-----

#FUN-CB0098---add---START
   IF cl_null(g_errno) THEN       #生效範圍判斷
      IF NOT s_chk_lni('0',l_lpj02,g_lpo.lpoplant,'') THEN
         LET g_errno = 'alm-694'
      END IF
   END IF 
#FUN-CB0098---add-----END
   
   IF cl_null(g_errno) OR p_cmd= 'd' THEN
      LET g_lpo.lpo03=l_lpj01
      SELECT lpk02,lpk03,lpk04,lpk05 
        INTO l_lpk02,l_lpk03,l_lpk04,l_lpk05
        FROM lpk_file 
       WHERE lpk01=g_lpo.lpo03
      IF cl_null(l_lpj12) THEN 
         LET l_lpj12=0
      END IF 
      LET g_lpo.lpo04=l_lpj12    
      DISPLAY l_lpj02 TO lpj02
      DISPLAY l_lph02 TO lph02
      DISPLAY BY NAME g_lpo.lpo03
      DISPLAY l_lpk02 TO lpk02
      DISPLAY l_lpk03 TO lpk03
      DISPLAY l_lpk04 TO lpk04
      DISPLAY l_lpk05 TO lpk05
      DISPLAY BY NAME g_lpo.lpo04   
   END IF
     
END FUNCTION
 
FUNCTION t580_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lpo.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t580_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t580_count
    FETCH t580_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t580_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lpo.lpo01,SQLCA.sqlcode,0)
        INITIALIZE g_lpo.* TO NULL
    ELSE
        CALL t580_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t580_fetch(p_fllpo)
    DEFINE
        p_fllpo         LIKE type_file.chr1           
 
    CASE p_fllpo
        WHEN 'N' FETCH NEXT     t580_cs INTO g_lpo.lpo01
        WHEN 'P' FETCH PREVIOUS t580_cs INTO g_lpo.lpo01
        WHEN 'F' FETCH FIRST    t580_cs INTO g_lpo.lpo01
        WHEN 'L' FETCH LAST     t580_cs INTO g_lpo.lpo01
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
            FETCH ABSOLUTE g_jump t580_cs INTO g_lpo.lpo01
            LET g_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lpo.lpo01,SQLCA.sqlcode,0)
        INITIALIZE g_lpo.* TO NULL 
        LET g_lpo.lpo01 = NULL     
        RETURN
    ELSE
      CASE p_fllpo
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_lpo.* FROM lpo_file    # 重讀DB,因TEMP有不被更新特性
       WHERE lpo01 = g_lpo.lpo01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lpo_file",g_lpo.lpo01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_lpo.lpouser           
        LET g_data_group=g_lpo.lpogrup
        LET g_data_plant = g_lpo.lpoplant  #No.FUN-A10060
        CALL t580_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t580_show()
DEFINE l_rtz13 LIKE rtz_file.rtz13
DEFINE l_azt02 LIKE azt_file.azt02
   #SELECT lpo05 INTO g_lpo.lpo05 FROM  lpo_file WHERE lpo01=g_lpo.lpo01  #FUN-C50057 mark
    LET g_lpo_t.* = g_lpo.*
    DISPLAY BY NAME g_lpo.lpo01,g_lpo.lpoplant,g_lpo.lpolegal,g_lpo.lpo02,g_lpo.lpo03,g_lpo.lpo04, g_lpo.lpooriu,g_lpo.lpoorig,
                   #g_lpo.lpo05,g_lpo.lpo06,g_lpo.lpo10,g_lpo.lpo07,g_lpo.lpo08,         #FUN-C50057 mark
                    g_lpo.lpo11,g_lpo.lpo06,g_lpo.lpo10,g_lpo.lpo07,g_lpo.lpo08,         #FUN-C50057 add
                    g_lpo.lpo09,
                    g_lpo.lpouser,g_lpo.lpogrup,g_lpo.lpomodu,
                    g_lpo.lpodate,g_lpo.lpoacti,g_lpo.lpocrat
    SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=g_lpo.lpoplant
    DISPLAY l_rtz13 TO rtz13    
    SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01=g_lpo.lpolegal
    DISPLAY l_azt02 TO azt02                             
    CALL t580_lpo02('d')
    CALL t580_pic()
    CALL cl_show_fld_cont()                 
END FUNCTION
 
FUNCTION t580_u(p_w)
DEFINE p_w   like type_file.chr1
 
    IF g_lpo.lpo01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
    END IF
    IF g_lpo.lpo07 = 'Y' THEN 
       CALL cl_err(g_lpo.lpo01,'alm-027',1)
       RETURN 
    END IF 
    IF g_lpo.lpoacti = 'N' THEN
       CALL cl_err(g_lpo.lpo01,'alm-147',1)
       RETURN
    END IF 
    SELECT * INTO g_lpo.* FROM lpo_file WHERE lpo01=g_lpo.lpo01
    IF g_lpo.lpoacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lpo01_t = g_lpo.lpo01
    BEGIN WORK
 
    OPEN t580_cl USING g_lpo01_t
    IF STATUS THEN
       CALL cl_err("OPEN t580_cl:", STATUS, 1)
       CLOSE t580_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t580_cl INTO g_lpo.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpo.lpo01,SQLCA.sqlcode,1)
        RETURN
    END IF
    
    LET g_date = g_lpo.lpodate
    LET g_modu = g_lpo.lpomodu
    
    CALL t580_show()    # 顯示最新資料
    
    WHILE TRUE
        IF p_w != 'c' THEN 
           LET g_lpo.lpomodu=g_user                  #修改者
           LET g_lpo.lpodate = g_today  
        ELSE
           LET g_lpo.lpomodu=NULL                  #修改者
           LET g_lpo.lpodate = NULL  
        END IF     
        CALL t580_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_lpo_t.lpomodu = g_modu
            LET g_lpo_t.lpodate = g_date            
            LET g_lpo.*=g_lpo_t.*
            CALL t580_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE lpo_file SET lpo_file.* = g_lpo.*    # 更新DB
            WHERE lpo01 = g_lpo01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lpo_file",g_lpo.lpo01,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t580_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t580_x()
 
    IF g_lpo.lpo01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lpo.lpo07 = 'Y' THEN 
      CALL cl_err(g_lpo.lpo01,'alm-027',1)
      RETURN 
    END IF 
    
    IF g_lpo.lpo07 = 'X' THEN 
      CALL cl_err(g_lpo.lpo01,'alm-134',1)
      RETURN 
    END IF 
    BEGIN WORK
 
    OPEN t580_cl USING g_lpo.lpo01
    IF STATUS THEN
       CALL cl_err("OPEN t580_cl:", STATUS, 1)
       CLOSE t580_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t580_cl INTO g_lpo.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpo.lpo01,SQLCA.sqlcode,1)
       RETURN
    END IF
    LET g_lpo.lpomodu=g_user                  
    LET g_lpo.lpodate = g_today
    CALL t580_show()
    IF cl_exp(0,0,g_lpo.lpoacti) THEN
        LET g_chr=g_lpo.lpoacti
        IF g_lpo.lpoacti='Y' THEN
            LET g_lpo.lpoacti='N'
            LET g_lpo.lpomodu=g_user
            LET g_lpo.lpodate=g_today
        ELSE
            LET g_lpo.lpoacti='Y'
            LET g_lpo.lpomodu=g_user
            LET g_lpo.lpodate=g_today
        END IF
        UPDATE lpo_file
            SET lpoacti=g_lpo.lpoacti,
                lpomodu=g_lpo.lpomodu,
                lpodate=g_lpo.lpodate
            WHERE lpo01=g_lpo.lpo01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_lpo.lpo01,SQLCA.sqlcode,0)
            LET g_lpo.lpoacti=g_chr
        END IF
        DISPLAY BY NAME g_lpo.lpoacti,g_lpo.lpomodu,g_lpo.lpodate
    END IF
    CALL t580_pic()
    CLOSE t580_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t580_r()
    IF g_lpo.lpo01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lpo.lpo07 = 'Y' THEN 
      CALL cl_err(g_lpo.lpo01,'art-023',1)
      RETURN 
    END IF 
    IF g_lpo.lpoacti = 'N' THEN  
       CALL cl_err(g_lpo.lpo01,'alm-147',1)                                                                                         
       RETURN                                                                                                                       
    END IF
    LET g_lpo01_t=g_lpo.lpo01
    BEGIN WORK
 
    OPEN t580_cl USING g_lpo01_t
    IF STATUS THEN
       CALL cl_err("OPEN t580_cl:", STATUS, 0)
       CLOSE t580_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t580_cl INTO g_lpo.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpo.lpo01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t580_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lpo01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lpo.lpo01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lpo_file WHERE lpo01 = g_lpo01_t
   #    DELETE FROM lpp_file WHERE lpp01 = g_lpo01_t   #NO.FUN-A90040   -- mark
       CLEAR FORM
       OPEN t580_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t580_cs
          CLOSE t580_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t580_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t580_cs
          CLOSE t580_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t580_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t580_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL t580_fetch('/')
       END IF
    END IF
    CLOSE t580_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t580_confirm()
   DEFINE l_lpo08         LIKE lpo_file.lpo08
   DEFINE l_lpo09         LIKE lpo_file.lpo09 
   DEFINE l_lph09         LIKE lph_file.lph09
   DEFINE l_lph10         LIKE lph_file.lph10
   DEFINE l_lph11         LIKE lph_file.lph11  
   DEFINE l_lpj12         LIKE lpj_file.lpj12  
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_lpjpos    LIKE lpj_file.lpjpos  #FUN-D30007 add
   DEFINE l_lpjpos_o  LIKE lpj_file.lpjpos  #FUN-D30007 add
   
   IF cl_null(g_lpo.lpo01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lpo.* FROM lpo_file
    WHERE lpo01 = g_lpo.lpo01
   
    LET l_lpo08 = g_lpo.lpo08
    LET l_lpo09 = g_lpo.lpo09
 #  SELECT COUNT(*) INTO l_n FROM lpp_file WHERE lpp01=g_lpo.lpo01    #NO.FUN-A90040   -- mark 
 
   IF g_lpo.lpoacti ='N' THEN
      CALL cl_err(g_lpo.lpo01,'alm-004',1)
      RETURN
   END IF
   IF g_lpo.lpo07 = 'Y' THEN
      CALL cl_err(g_lpo.lpo01,'alm-005',1)
      RETURN
   END IF
   IF g_lpo.lpo07 = 'X' THEN
      CALL cl_err(g_lpo.lpo01,'alm-134',1)
      RETURN
   END IF
   
 #  IF l_n<1 THEN                      #NO.FUN-A90040   -- mark
 #     CALL cl_err('','alm-494',1)     #NO.FUN-A90040   -- mark
 #     RETURN                          #NO.FUN-A90040   -- mark
 #  END IF                             #NO.FUN-A90040   -- mark 
   
   IF NOT cl_confirm("alm-006") THEN
      RETURN
   ELSE   
      BEGIN WORK 
      LET g_success='Y'
      OPEN t580_cl USING g_lpo.lpo01
      IF STATUS THEN 
          CALL cl_err("open t580_cl:",STATUS,1)
          CLOSE t580_cl
          ROLLBACK WORK 
          RETURN 
       END IF 
       FETCH t580_cl INTO g_lpo.*
       IF SQLCA.sqlcode  THEN 
         CALL cl_err(g_lpo.lpo01,SQLCA.sqlcode,0)
         CLOSE t580_cl
         ROLLBACK WORK
         RETURN 
       END IF    
 
       LET g_lpo.lpo07 = 'Y'
       LET g_lpo.lpo08 = g_user
       LET g_lpo.lpo09 = g_today

      #INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm07) #No.FUN-A70118  #FUN-BA0067 mark
      #VALUES (g_lpo.lpo02,'5',g_lpo.lpo01,g_lpo.lpo06,g_lpo.lpo09,g_lpo.lpo10,g_lpo.lpoplant) #No.FUN-A70118  #FUN-BA0067 mark
      #INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmplant,lsmlegal,lsm15) #No.FUN-A70118        #FUN-BA0067 add #FUN-C70045 add lsm15   #FUN-C90102 mark
       INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmstore,lsmlegal,lsm15) #FUN-C90102 add
#      VALUES (g_lpo.lpo02,'5',g_lpo.lpo01,g_lpo.lpo06,g_lpo.lpo09,g_lpo.lpo10,0,g_lpo.lpoplant,g_lpo.lpolegal) #No.FUN-A70118   #FUN-BA0067 add    #FUN-C70045 mark
       VALUES (g_lpo.lpo02,'2',g_lpo.lpo01,g_lpo.lpo06,g_lpo.lpo09,g_lpo.lpo10,0,g_lpo.lpoplant,g_lpo.lpolegal,'1')       #FUN-C70045 add
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                     
          LET g_success='N'    
          CALL cl_err3("ins","lsm_file",g_lpo.lpo02,"",SQLCA.sqlcode,"","",1)  
       END IF             	
      #FUN-D30007 add START
       SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj03 = g_lpo.lpo02 
       IF l_lpjpos_o <> '1' THEN
          LET l_lpjpos = '2'
       ELSE
          LET l_lpjpos = '1'
       END IF
      #FUN-D30007 add END
       LET l_lpj12=g_lpo.lpo06+g_lpo.lpo04
       UPDATE lpj_file
     	    SET lpj12=l_lpj12,
                lpjpos = l_lpjpos  #FUN-D30007 add
        WHERE lpj03=g_lpo.lpo02
           
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN  
          LET g_success='N'                      
          CALL cl_err3("upd","lpj_file",g_lpo.lpo03,"",SQLCA.sqlcode,"","",1)  
       END IF  
                 
       UPDATE lpo_file
          SET lpo07 = g_lpo.lpo07,
              lpo08 = g_lpo.lpo08,
              lpo09 = g_lpo.lpo09
        WHERE lpo01 = g_lpo.lpo01
        
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd lpo:',SQLCA.SQLCODE,0)
          LET g_success='N'
          LET g_lpo.lpo07 = "N"
          LET g_lpo.lpo08 = l_lpo08
          LET g_lpo.lpo09 = l_lpo09
          DISPLAY BY NAME g_lpo.lpo07,g_lpo.lpo08,g_lpo.lpo09
        ELSE                          
          DISPLAY BY NAME g_lpo.lpo07,g_lpo.lpo08,g_lpo.lpo09
        END IF
        IF g_success='N' THEN 
           ROLLBACK WORK
           RETURN 
        ELSE
           COMMIT WORK  
        END IF 
   END IF 
   CLOSE t580_cl
END FUNCTION
#NO.FUN-960058  
#FUNCTION t580_v()
#   IF cl_null(g_lpo.lpo01) THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
#
#   SELECT * INTO g_lpo.* FROM lpo_file
#    WHERE lpo01 = g_lpo.lpo01
#
#   IF g_lpo.lpoacti ='N' THEN
#      CALL cl_err(g_lpo.lpo01,'alm-084',0)
#      RETURN
#   END IF
#
#   IF g_lpo.lpo07 = 'Y' THEN
#      CALL cl_err(g_lpo.lpo01,'9023',0)
#      RETURN
#   END IF
#  BEGIN WORK 
#   OPEN t580_cl USING g_lpo.lpo01
#   IF STATUS THEN 
#       CALL cl_err("open t580_cl:",STATUS,1)
#       CLOSE t580_cl
#       ROLLBACK WORK 
#       RETURN 
#    END IF 
#    FETCH t580_cl INTO g_lpo.*
#    IF SQLCA.sqlcode  THEN 
#      CALL cl_err(g_lpo.lpo01,SQLCA.sqlcode,0)
#      CLOSE t580_cl
#      ROLLBACK WORK
#      RETURN 
#    END IF    
#   IF g_lpo.lpo07 != 'Y' THEN
#      IF g_lpo.lpo07 = 'X' THEN
#         IF NOT cl_confirm('alm-086') THEN
#            RETURN
#         ELSE
#            LET g_lpo.lpo07 = 'N'
#            UPDATE lpo_file
#               SET lpo07 = g_lpo.lpo07,
#                   lpomodu=g_user,
#                   lpodate=g_today               
#             WHERE lpo01 = g_lpo.lpo01
#            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#               CALL cl_err('upd lpo:',SQLCA.SQLCODE,0)
#               LET g_lpo.lpo07 = "X"
#               DISPLAY BY NAME g_lpo.lpo07,g_lpo.lpo08,g_lpo.lpo09,g_lpo.lpomodu,g_lpo.lpodate
#               RETURN
#            ELSE
#            	 UPDATE lpj_file
#            	    SET lpj10=NULL 
#            	  WHERE lpj01=g_lpo.lpo03 
#            	    AND lpj03=g_lpo.lpo02
#               IF SQLCA.sqlcode THEN                     
#                  ROLLBACK WORK      
#                  CALL cl_err3("upd","lpj_file",g_lpo.lpo03,"",SQLCA.sqlcode,"","",1)  
#                  RETURN 
#               END IF                  	
#               DISPLAY BY NAME g_lpo.lpo07,g_lpo.lpo08,g_lpo.lpo09,g_lpo.lpomodu,g_lpo.lpodate
#            END IF
#         END IF
#      ELSE
#         IF NOT cl_confirm('alm-085') THEN
#            RETURN
#         ELSE
#            LET g_lpo.lpo07 = 'X'
#            UPDATE lpo_file
#               SET lpo07 = g_lpo.lpo07,
#                   lpomodu=g_user,
#                   lpodate=g_today               
#             WHERE lpo01 = g_lpo.lpo01
#            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#               CALL cl_err('upd lpo:',SQLCA.SQLCODE,0)
#               LET g_lpo.lpo07 = "N"
#               DISPLAY BY NAME g_lpo.lpo07,g_lpo.lpo08,g_lpo.lpo09,g_lpo.lpomodu,g_lpo.lpodate
#               RETURN
#            ELSE
#            	 UPDATE lpj_file
#            	    SET lpj10=g_today
#            	  WHERE lpj01=g_lpo.lpo03 
#            	    AND lpj03=g_lpo.lpo02
#               IF SQLCA.sqlcode THEN                     
#                  ROLLBACK WORK      
#                  CALL cl_err3("upd","lpj_file",g_lpo.lpo03,"",SQLCA.sqlcode,"","",1)  
#                  RETURN 
#               END IF                    	    
#               DISPLAY BY NAME g_lpo.lpo07,g_lpo.lpo08,g_lpo.lpo09,g_lpo.lpomodu,g_lpo.lpodate
#            END IF
#         END IF
#      END IF
#   END IF
# CLOSE t580_cl
# COMMIT WORK 
#END FUNCTION 
#NO.FUN-960058  
FUNCTION t580_pic()
   CASE g_lpo.lpo07
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
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lpo.lpoacti)
END FUNCTION
 
FUNCTION t580_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1   
          
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lpo01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t580_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("lpo01",FALSE)
    END IF
 
END FUNCTION

#FUN-C90070-------add------str
FUNCTION t580_out()
DEFINE l_sql    LIKE type_file.chr1000, 
       l_rtz13  LIKE rtz_file.rtz13,
       l_lph02  LIKE lph_file.lph02,
       sr       RECORD
                lpo01     LIKE lpo_file.lpo01,
                lpoplant  LIKE lpo_file.lpoplant, 
                lpo02     LIKE lpo_file.lpo02,
                lpj02     LIKE lpj_file.lpj02,
                lpo04     LIKE lpo_file.lpo04,
                lpo06     LIKE lpo_file.lpo06,
                lpo11     LIKE lpo_file.lpo11,
                lpo03     LIKE lpo_file.lpo03,
                lpk02     LIKE lpk_file.lpk02,
                lpk03     LIKE lpk_file.lpk03,
                lpk04     LIKE lpk_file.lpk04,
                lpo07     LIKE lpo_file.lpo07,
                lpo08     LIKE lpo_file.lpo08,
                lpo09     LIKE lpo_file.lpo09
                END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpouser', 'lpogrup')
     IF cl_null(g_wc) THEN LET g_wc = " lpo01 = '",g_lpo.lpo01,"'" END IF
     LET l_sql = "SELECT lpo01,lpoplant,lpo02,lpj02,lpo04,lpo06,lpo11,lpo03,",
                 "       lpk02,lpk03,lpk04,lpo07,lpo08,lpo09",
                 "  FROM lpo_file",
                 "  LEFT OUTER JOIN lpk_file",
                 "    ON (lpk01 = lpo03)",
                 "  LEFT OUTER JOIN lpj_file",
                 "    ON (lpj03 = lpo02)",
                 " WHERE ",g_wc CLIPPED
     PREPARE t580_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t580_cs1 CURSOR FOR t580_prepare1

     DISPLAY l_table
     FOREACH t580_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       SELECT lpj12 INTO sr.lpo04 
         FROM lpj_file,lph_file
        WHERE lpj03 = sr.lpo02
          AND lpj02 = lph01
       IF cl_null(sr.lpo04) THEN
          LET sr.lpo04=0
       END IF
       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=sr.lpoplant
       LET l_lph02 = ' '
       SELECT lph02 INTO l_lph02 FROM lph_file WHERE lph01=sr.lpj02
       EXECUTE insert_prep USING sr.*,l_rtz13,l_lph02
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lpo01,lpoplant,lpo02,lpolegal,lpo03,lpo04,lpo11,lpo06,lpo07,lpo08,lpo09')
          RETURNING g_wc1
     CALL t580_grdata() 
END FUNCTION

FUNCTION t580_grdata()
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
       LET handler = cl_gre_outnam("almt580")
       IF handler IS NOT NULL THEN
           START REPORT t580_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lpo01"
           DECLARE t580_datacur1 CURSOR FROM l_sql
           FOREACH t580_datacur1 INTO sr1.*
               OUTPUT TO REPORT t580_rep(sr1.*)
           END FOREACH
           FINISH REPORT t580_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t580_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lpk02  STRING
    DEFINE l_lpo07  STRING

    
    ORDER EXTERNAL BY sr1.lpo01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc,g_wc1
              
        BEFORE GROUP OF sr1.lpo01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lpk02 = cl_gr_getmsg("gre-303",g_lang,sr1.lpk02)
            LET l_lpo07 = cl_gr_getmsg("gre-304",g_lang,sr1.lpo07)
            PRINTX sr1.*
            PRINTX l_lpk02
            PRINTX l_lpo07

        AFTER GROUP OF sr1.lpo01

        
        ON LAST ROW

END REPORT
#FUN-C90070-------add------end
