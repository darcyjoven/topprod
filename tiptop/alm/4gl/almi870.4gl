# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almi870.4gl
# Descriptions...: 廣告位合同維護作業 
# Date & Author..: FUN-960081 08/08/06 By dxfwo  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0136 09/11/25 by dxfwo 有INFO页签的，在CONSTRUCT的时候要把 oriu和orig两个栏位开放
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30156 10/04/19 By Smapmin 商戶號的檢核與錯誤訊息的修正 
# Modify.........: No:FUN-A60064 10/06/24 By wangxin 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/09 By huangtao 取消lrk_file所有相關資料
# Modify.........: No.FUN-A80105 10/08/27 By huangtao 確認時產生費用單開窗
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No.FUN-AC0062 10/12/22 By lixh1 因lua05欄位no use,故mark掉lua05的所有邏輯
# Modify.........: No.TQC-B30101 11/03/11 By baogc 隱藏簽核欄位,簽核狀態欄位,簽核按鈕
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.MOD-B40138 11/04/15 By zhangll sql缺少唯一性条件
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0117 11/12/26 By chenwei  原來產生的2張費用單現合併到一張


# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20355 12/02/21 By nanbing BUG 更改，產生確認的lsd_file資料
# Modify.........: No:TQC-C20351 12/02/22 By nanbing BUG更改 “AND lsc14 <> 's'” 改為 “AND lsc14 <> 'S'”
# Modify.........: No:FUN-C30137 12/03/13 By fanbj 添加查詢費用單功能，產生費用單單身資料
# Modify.........: No:TQC-C30290 12/03/28 By fanbj 金額取位修改為按azi04,以及複製時報錯修改
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960081 
DEFINE g_lsc                RECORD LIKE lsc_file.*,
       g_lsc_t              RECORD LIKE lsc_file.*,
       g_lsc01_t            LIKE lsc_file.lsc01,  
       g_wc                 string,        
       g_sql                STRING       
 
DEFINE g_forupd_sql         STRING         #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  SMALLINT       
DEFINE g_chr                VARCHAR(1)
DEFINE g_chr2               VARCHAR(1)
DEFINE g_chr3               VARCHAR(1)
DEFINE g_cnt                INTEGER
DEFINE g_i                  SMALLINT       #count/index for any purpose
DEFINE g_msg                VARCHAR(72)
DEFINE g_curs_index         INTEGER
DEFINE g_row_count          INTEGER        
DEFINE g_jump               INTEGER        
DEFINE g_no_ask            SMALLINT         
#DEFINE g_t1                 LIKE lrk_file.lrkslip        #FUN-A70130  mark
#DEFINE g_kindtype           LIKE lrk_file.lrkkind        #FUN-A70130  mark
DEFINE g_t1                 LIKE oay_file.oayslip        #FUN-A70130  
DEFINE g_kindtype           LIKE oay_file.oaytype        #FUN-A70130
DEFINE g_lua01_1            LIKE lua_file.lua01          #No.FUN-A80105 
DEFINE g_lua01_2            LIKE lua_file.lua01          #No.FUN-A80105 
DEFINE g_dd                 LIKE lua_file.lua09          #No.FUN-A80105
#DEFINE g_lla04              LIKE lla_file.lla04          #FUN-C30137 add   #TQC-C30290 mark
DEFINE g_azi04              LIKE azi_file.azi04          #TQC-C30290 add

MAIN
 IF FGL_GETENV("FGLGUI")<>"0" THEN
    OPTIONS
        INPUT NO WRAP
 END IF
    DEFER INTERRUPT                            
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   INITIALIZE g_lsc.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM lsc_file WHERE lsc01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i870_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i870_w WITH FORM "alm/42f/almi870"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
##-TQC-B30101 ADD-BEGIN------
   CALL cl_set_comp_visible("lsc12,lsc13",FALSE)
   CALL cl_set_act_visible("ef_approval",FALSE)
##-TQC-B30101 ADD--END-------
 
   #LET g_kindtype = '33' #FUN-A70130
   LET g_kindtype = 'M7' #FUN-A70130
   IF cl_null(g_lsc.lscstore) THEN
      LET g_lsc.lscstore = g_plant
   END IF
   #TQC-C30290--start mark--------------
   ##FUN-C30137--start add--------------
   #SELECT lla04 INTO g_lla04 
   #  FROM lla_file
   # WHERE llastore = g_plant  
   ##FUN-C30137--end add----------------
   #TQC-C30290--end mark----------------
   #TQC-C30290--start add---------------
   SELECT azi04 INTO g_azi04
     FROM azi_file
    WHERE azi01 = g_aza.aza17 
   #TQC-C30290--end add----------------- 

   LET g_action_choice = ""
   CALL i870_menu()
 
   CLOSE WINDOW i870_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i870_curs()
DEFINE ls STRING
DEFINE p_cmd        VARCHAR(1)
 
 
    CLEAR FORM
    #FUN-C30137--start mark-----------------------------------
    #CONSTRUCT BY NAME g_wc ON                    
    #    lscstore,lsclegal, 
    #    lsc01,lsc02,lsc03,lsc04,
    #    lsc05,lsc06,lsc07,lsc08,
    #    lsc09,lsc10,lsc11,lsc12,
    #    lsc13,lsc14,lsc15,lsc16,
    #    lsc18,lsc19,lsc20,
    #    lscuser,lscgrup,lsccrat,
    #    lscmodu,lscdate,lscoriu,lscorig    #No.FUN-9B0136
    #FUN-C30137--end mark------------------------------------- 
    #FUN-C30137--start add------------------------------------
    CONSTRUCT BY NAME g_wc ON
       lscstore,lsclegal,lsc01,lsc02,lsc03,lsc04,
       lsc18,lsc19,lsc20,lsc05,lsc06,lsc07,lsc21,
       lsc08,lsc22,lsc09,lsc23,lsc10,lsc11,lsc12,
       lsc13,lsc14,lsc15,lsc16,lscuser,lscgrup,
       lscoriu,lscorig,lsccrat,lscmodu,lscdate     
    #FUN-C30137--end add-------------------------------------- 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(lsc01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsc01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lscstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsc01
                 NEXT FIELD lsc01
              WHEN INFIELD(lscstore)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_lscstore"
                 LET g_qryparam.where = " lscstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lscstore
                 NEXT FIELD lscstore
 
              WHEN INFIELD(lsclegal)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_lsclegal"
                 LET g_qryparam.where = " lscstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsclegal
                 NEXT FIELD lsclegal
              WHEN INFIELD(lsc03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsc03"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lscstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsc03
                 NEXT FIELD lsc03
              WHEN INFIELD(lsc04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsc04"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lscstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsc04
                 NEXT FIELD lsc04                 
              WHEN INFIELD(lsc18)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsc18"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lscstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsc18
                 NEXT FIELD lsc18
              #FUN-C30137--start add-------------------------------------------------
              WHEN INFIELD(lsc21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsc21"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lscstore IN ",g_auth," "  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsc21
                 NEXT FIELD lsc21
              WHEN INFIELD(lsc22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsc22"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lscstore IN ",g_auth," "  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsc22
                 NEXT FIELD lsc22 
              #FUN-C30137--end add-----------------------------------------------------
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
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           
    #        LET g_wc = g_wc clipped," AND lscuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           
    #        LET g_wc = g_wc clipped," AND lscgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN             
    #        LET g_wc = g_wc clipped," AND lscgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lscuser', 'lscgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT lsc01 FROM lsc_file ",
        " WHERE ",g_wc CLIPPED, 
        "   AND lscstore IN ",g_auth CLIPPED,    #No.FUN-A10060
        " ORDER BY lsc01"
    PREPARE i870_prepare FROM g_sql
    DECLARE i870_cs                               # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i870_prepare
    LET g_sql=
#        "SELECT COUNT(*) FROM lsc_file WHERE ",g_wc CLIPPED 
         "SELECT COUNT(*) FROM lsc_file ",
         " WHERE ",g_wc CLIPPED,
         "   AND lscstore IN ",g_auth CLIPPED     #No.FUN-A10060
    PREPARE i870_precount FROM g_sql
    DECLARE i870_count CURSOR FOR i870_precount
END FUNCTION
 
FUNCTION i870_menu()
 
   DEFINE l_msg     STRING          #FUN-C30137 add
   DEFINE l_cmd     VARCHAR(100)
 #  DEFINE l_lrkdmy2 LIKE lrk_file.lrkdmy2   #add by dxfwo 081125  #FUN-A70130
    DEFINE l_oayconf LIKE oay_file.oayconf   #FUN-A70130
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN           
                 CALL i870_a()
              #add by dxfwo 081125 --begin 增加根據單別設置自動審核功能
              LET g_t1=s_get_doc_no(g_lsc.lsc01)
              #單別設置里有維護單別，則找出是否需要自動審核
              IF NOT cl_null(g_t1) THEN
        #FUN-A70130 ------------------start------------------------------      
        #         SELECT lrkdmy2
        #           INTO l_lrkdmy2
        #           FROM lrk_file
        #          WHERE lrkslip = g_t1
        #         #需要自動審核，則調用審核段
        #         IF l_lrkdmy2 = 'Y' THEN
                 SELECT oayconf  INTO l_oayconf FROM oay_file
                 WHERE oayslip = g_t1
                 IF l_oayconf = 'Y' THEN
        #FUN-A70130 ---------------------end--------------------------------
                    #自動審核傳2
                    CALL i870_y()
                 END IF
              END IF
              #add by dxfwo 081125 --end 增加根據單別設置自動審核功能
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i870_q()
            END IF
        ON ACTION next
            CALL i870_fetch('N')
        ON ACTION previous
            CALL i870_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
#              IF cl_chk_mach_auth(g_lsc.lscstore,g_plant) THEN 
                 CALL i870_u("w")
#              END IF   
            END IF
#        ON ACTION invalid
#            LET g_action_choice="invalid"
#            IF cl_chk_act_auth() THEN
#                 CALL i870_x()
#                 CALL i870_field_pic()
#            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
#              IF cl_chk_mach_auth(g_lsc.lscstore,g_plant) THEN
                 CALL i870_r()
#              END IF   
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
#              IF cl_chk_mach_auth(g_lsc.lscstore,g_plant) THEN
                 CALL i870_copy()
#              END IF   
            END IF
                        
#      ON ACTION output
#           LET g_action_choice="output"
#           IF cl_chk_act_auth()
#              THEN CALL i870_out()
#           END IF

       #FUN-C30137--start add--------------------------
       #费用单查询
       ON ACTION check_expense
          LET g_action_choice="check_expense"
          IF cl_chk_act_auth() THEN
             IF NOT cl_null(g_lsc.lsc23) THEN
                LET l_msg = "artt610  '1' '",g_lsc.lsc23,"'"
                CALL cl_cmdrun_wait(l_msg)
             END IF
          ELSE
             CALL cl_err('',-4001,1)
          END IF
       #FUN-C30137--end add---------------------------- 

        ON ACTION ef_approval        
            LET g_action_choice="ef_approval"
            IF cl_chk_act_auth() THEN
#             IF cl_chk_mach_auth(g_lsc.lscstore,g_plant) THEN
               CALL i870_ef()
#             END IF  
            END IF
 
        ON ACTION confirm 
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
#             IF cl_chk_mach_auth(g_lsc.lscstore,g_plant) THEN
               CALL i870_y()         
#             END IF  
            END IF
              CALL i870_field_pic()
 
#        ON ACTION undo_confirm      
#            LET g_action_choice="undo_confirm"
#            IF cl_chk_act_auth() THEN
#               CALL i870_unconfirm()
#               CALL i870_field_pic()
#            END IF
 
        ON ACTION termination
            LET g_action_choice="termination"
            IF cl_chk_act_auth() THEN
#             IF cl_chk_mach_auth(g_lsc.lscstore,g_plant) THEN
               CALL i870_termination()
               CALL i870_field_pic()
#             END IF  
            END IF
 
        ON ACTION volid 
            LET g_action_choice="volid"
            IF cl_chk_act_auth() THEN
#             IF cl_chk_mach_auth(g_lsc.lscstore,g_plant) THEN 
               CALL i870_v()
               CALL i870_field_pic()
#             END IF  
            END IF
 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL i870_fetch('/')
        ON ACTION first
            CALL i870_fetch('F')
        ON ACTION last
            CALL i870_fetch('L')
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
              IF g_lsc.lsc01 IS NOT NULL THEN
                 LET g_doc.column1 = "lsc01"
                 LET g_doc.value1 = g_lsc.lsc01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE i870_cs
END FUNCTION
 
 
FUNCTION i870_a()
   DEFINE    l_n             LIKE type_file.num5
#  DEFINE    l_tqa06         LIKE tqa_file.tqa06
   DEFINE    li_result       LIKE type_file.num5
   
#  SELECT tqa06 INTO l_tqa06 FROM tqa_file
#   WHERE tqa03 = '14'       	 
#     AND tqaacti = 'Y'
#     AND tqa01 IN(SELECT tqb03 FROM tqb_file
#    	              WHERE tqbacti = 'Y'
#    	                AND tqb09 = '2'
#    	                AND tqb01 = g_plant) 
#  IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN 
#     CALL cl_err('','alm-600',1)
#     RETURN 
#  END IF 
   
   SELECT COUNT(*) INTO l_n FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
    IF l_n < 1 THEN 
       CALL cl_err('','alm-606',1)
       RETURN 
    END IF
#############################  
    MESSAGE ""
    CLEAR FORM                                   
    INITIALIZE g_lsc.* LIKE lsc_file.*
#   INITIALIZE g_lsc_t.* LIKE lsc_file.*
    LET g_lsc01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lsc.lsc02 = '0'
        LET g_lsc.lsc07 = g_today
        #LET g_lsc.lsc08 = '0'     #FUN-C30137 mark
        #LET g_lsc.lsc09 = '0'     #FUN-C30137 mark
        LET g_lsc.lsc12 = 'N'
        LET g_lsc.lsc13 = '0'
        LET g_lsc.lsc14 = 'N' 
        LET g_lsc.lscstore = g_plant
        LET g_lsc.lsclegal = g_legal
        LET g_lsc.lsc20 = 'N'       
        LET g_lsc.lscuser = g_user
        LET g_lsc.lscoriu = g_user #FUN-980030
        LET g_lsc.lscorig = g_grup #FUN-980030
        LET g_lsc.lsccrat = g_today
        LET g_lsc.lscgrup = g_grup
 
         CALL i870_i("a","a")                         
         IF INT_FLAG THEN                        
             INITIALIZE g_lsc.* TO NULL
             LET INT_FLAG = 0
             CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        
        IF g_lsc.lsc01 IS NULL THEN               
            CONTINUE WHILE
        END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
      CALL s_auto_assign_no("alm",g_lsc.lsc01,g_today,g_kindtype,"lsc_file","lsc01","","","") #FUN-A70130

           RETURNING li_result,g_lsc.lsc01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lsc.lsc01
#add by dxfwo---begin--
#       CALL i870_auno1()
#       RETURNING g_lsc.lsc02
#       DISPLAY BY NAME g_lsc.lsc02
#add by dxfwo---end------
        INSERT INTO lsc_file VALUES(g_lsc.*)      # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lsc_file",g_lsc.lsc01,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        ELSE
            SELECT lsc01 INTO g_lsc.lsc01 FROM lsc_file
                     WHERE lsc01 = g_lsc.lsc01
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK 
    LET g_wc=' '
END FUNCTION
 
FUNCTION i870_i(p_cmd,p_wc)
   DEFINE   p_cmd        VARCHAR(1),
            p_wc         VARCHAR(1),
            l_rtz13   LIKE rtz_file.rtz13,  #FUN-A80148 add
            l_lmb03   LIKE lmb_file.lmb03,
            l_lmc04   LIKE lmc_file.lmc04,
            l_maxno      VARCHAR(5),
            l_input      VARCHAR(1),
            l_n          SMALLINT,
            l_n1         SMALLINT
   DEFINE li_result   LIKE type_file.num5
 
   #FUN-C30137--start mark--------------------------------
   #DISPLAY BY NAME
   #   g_lsc.lscstore, g_lsc.lsclegal,
   #   g_lsc.lsc02,g_lsc.lsc19,
   #   g_lsc.lsc20,g_lsc.lsc10,g_lsc.lsc11,
   #   g_lsc.lsc12,g_lsc.lsc13,g_lsc.lsc14,
   #   g_lsc.lsc15,g_lsc.lsc16,g_lsc.lscuser,g_lsc.lscgrup,
   #   g_lsc.lsccrat,g_lsc.lscmodu,g_lsc.lscdate
   #FUN-C30137--end mark------------------------------------
   #FUN-C30137--start add-----------------------------------
   DISPLAY BY NAME
      g_lsc.lscstore,g_lsc.lsclegal,g_lsc.lsc02,
      g_lsc.lsc19,g_lsc.lsc20,g_lsc.lsc21,g_lsc.lsc22,
      g_lsc.lsc23,g_lsc.lsc10,g_lsc.lsc11,g_lsc.lsc12,
      g_lsc.lsc13,g_lsc.lsc14,g_lsc.lsc15,g_lsc.lsc16,
      g_lsc.lscuser,g_lsc.lscgrup,
      g_lsc.lsccrat,g_lsc.lscmodu,g_lsc.lscdate
   #FUN-C30137--end add-------------------------------------
 
   CALL i870_lscstore(p_cmd)
   #FUN-C30137--start mark----------------------------------------
   #INPUT BY NAME g_lsc.lscoriu,g_lsc.lscorig,
   #   g_lsc.lsc01,g_lsc.lsc03,g_lsc.lsc18,g_lsc.lsc04,g_lsc.lsc05,
   #   g_lsc.lsc06,g_lsc.lsc07,g_lsc.lsc08,g_lsc.lsc09
   #   WITHOUT DEFAULTS
   #FUN-C30137--end mark-------------------------------------------
   #FUN-C30137--start add------------------------------------------
   INPUT BY NAME g_lsc.lsc01,
                 g_lsc.lsc03,g_lsc.lsc04,g_lsc.lsc18,
                 g_lsc.lsc05,g_lsc.lsc06,g_lsc.lsc07,
                 g_lsc.lsc21,g_lsc.lsc08,g_lsc.lsc22,g_lsc.lsc09,
                 g_lsc.lsc23
   WITHOUT DEFAULTS
   #FUN-C30137--end add--------------------------------------------
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i870_set_entry(p_cmd)
          CALL i870_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("lsc01")       
 
     AFTER FIELD lsc01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
#        IF g_lsc.lsc01 IS NOT NULL THEN
#           IF p_cmd = "a" OR
#              (p_cmd="u" AND g_lsc.lsc01 != g_lsc01_t)THEN
#                CALL i870_check_lsc01(g_lsc.lsc01) 
#                 IF g_success = 'N' THEN                                               
#                    LET g_lsc.lsc01 = g_lsc_t.lsc01                                                               
#                   DISPLAY BY NAME g_lsc.lsc01                                                                     
#                   NEXT FIELD lsc01                                                                                  
#                 END IF
#           END IF  
#         ELSE
#            CALL cl_err(g_lsc.lsc01,'alm-055',1)
#        END IF
         IF NOT cl_null(g_lsc.lsc01) THEN
            CALL s_check_no("alm",g_lsc.lsc01,g_lsc01_t,g_kindtype,"lsc_file","lsc01","")
                 RETURNING li_result,g_lsc.lsc01
            IF (NOT li_result) THEN
               LET g_lsc.lsc01=g_lsc_t.lsc01
               NEXT FIELD lsc01
            END IF
            DISPLAY BY NAME g_lsc.lsc01
         END IF
 
 
      AFTER FIELD lsc03
          IF NOT cl_null(g_lsc.lsc03) THEN                                                                                    
             IF g_lsc.lsc03 != g_lsc_t.lsc03
             OR g_lsc_t.lsc03 IS NULL THEN  
                CALL i870_lsc03(p_cmd)                                                                           
                #-----MOD-A30156---------
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   LET g_lsc.lsc03 = g_lsc_t.lsc03
                   NEXT FIELD lsc03
                END IF
                #SELECT count(*) INTO l_n  FROM lne_file                                                                             
                #  WHERE lne01= g_lsc.lsc03                                                                                    
                #    AND lne36 = 'Y'                                                                                   
                #IF l_n = 0 THEN                                                                                                    
                #   CALL cl_err('','alm-921',1)                                                                                   
                #   LET g_lsc.lsc03 = g_lsc_t.lsc03                                                                            
                #   NEXT FIELD lsc03                                                                                                 
                #END IF
                #-----END MOD-A30156-----
              END IF
         END IF
 
      AFTER FIELD lsc18
          IF NOT cl_null(g_lsc.lsc18) THEN                                                                                    
             IF g_lsc.lsc18 != g_lsc_t.lsc18
             OR g_lsc_t.lsc18 IS NULL THEN  
                CALL i870_lsc18(p_cmd)                                                                           
                #-----MOD-A30156---------
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   LET g_lsc.lsc18 = g_lsc_t.lsc18
                   NEXT FIELD lsc18
                END IF
                #SELECT count(*) INTO l_n  FROM gec_file                                                                             
                #  WHERE gec01= g_lsc.lsc18                                                                                    
                #    AND gecacti = 'Y'                                                                                   
                #IF l_n = 0 THEN                                                                                                    
                #   CALL cl_err('','alm-921',1)                                                                                      
                #   LET g_lsc.lsc18 = g_lsc_t.lsc18                                                                            
                #   NEXT FIELD lsc18                                                                                                 
                #END IF
                #-----END MOD-A30156-----
              END IF
         END IF        
         
      AFTER FIELD lsc04
          IF NOT cl_null(g_lsc.lsc04) THEN  
#          IF  g_lsc.lsc04 != g_lsc_t.lsc04 
#              OR g_lsc_t.lsc04 IS NULL  THEN 
#                SELECT count(*) INTO l_n FROM lsc_file
#                 WHERE lsc04 = g_lsc.lsc04
#                   AND lsc05 ! = g_lsc.lsc05
#                   AND ((lsc05 <= g_lsc.lsc05 AND lsc06 >= g_lsc.lsc05)
#                    OR (lsc05 <= g_lsc.lsc06 AND lsc06 >= g_lsc.lsc06)
#                    OR (lsc05 >= g_lsc.lsc05 AND lsc06 <= g_lsc.lsc06)) 
#                IF l_n > 0 THEN
#                   CALL cl_err('','alm-924',1)
#                   NEXT FIELD lsc04
#                END IF 
                CALL i870_lsc04(p_cmd)                                                                            
                SELECT count(*) INTO l_n  FROM lsb_file                                                                             
                  WHERE lsb01= g_lsc.lsc04                                                                                    
                    AND lsb16 = 'Y'                                                                                   
                    AND lsbstore = g_lsc.lscstore
                IF l_n = 0 THEN                                                                                                    
                   CALL cl_err('','alm-918',1)                                                                                      
                   LET g_lsc.lsc04 = g_lsc_t.lsc04                                                                            
                   NEXT FIELD lsc04                                                                                                 
                END IF                                                           
 #             END IF
                IF p_wc='c' AND  g_lsc.lsc04 = g_lsc_t.lsc04 THEN 
                   CALL cl_err('','alm-924',1)
                   NEXT FIELD lsc04
                END IF                                                                                                                                                              
                SELECT COUNT(*) INTO l_n1 FROM lsc_file 
                 WHERE lsc04 = g_lsc.lsc04
                 IF l_n1 > 0 THEN  
                  LET g_lsc.lsc05 = NULL 
                  LET g_lsc.lsc06 = NULL
                 END IF 
          END IF 
           
 
      AFTER FIELD lsc05
          IF NOT cl_null(g_lsc.lsc05) THEN                                                                                  
                IF g_lsc.lsc05 >  g_lsc.lsc06 THEN                                                                                                    
                   CALL cl_err('','alm-919',1)                                                                           
                   NEXT FIELD lsc05                                                                                                 
                END IF                                                                                                                                 
         IF  g_lsc.lsc04 != g_lsc_t.lsc04 
             OR g_lsc_t.lsc04 IS NULL  THEN 
               SELECT count(*) INTO l_n FROM lsc_file
                WHERE lsc04 = g_lsc.lsc04
                  AND ((lsc05 <= g_lsc.lsc05 AND lsc06 >= g_lsc.lsc05)
                   OR (lsc05 <= g_lsc.lsc06 AND lsc06 >= g_lsc.lsc06)
                   OR (lsc05 >= g_lsc.lsc05 AND lsc06 <= g_lsc.lsc06)) 
                  #AND lsc14 <> 's' #TQC-C20351 MARK
                   AND lsc14 <> 'S'  #TQC-C20351 ADD 
               IF l_n > 0 THEN
                  CALL cl_err('','alm-924',1)
                  NEXT FIELD lsc05
               END IF       
          END IF 
          END IF
 
 
      AFTER FIELD lsc06  
          IF NOT cl_null(g_lsc.lsc06) THEN                                                                                  
                IF g_lsc.lsc06 <  g_lsc.lsc05 THEN                                                                                                    
                   CALL cl_err('','alm-919',1)                                                                           
                   NEXT FIELD lsc06                                                                                                 
                END IF 
          IF  g_lsc.lsc04 != g_lsc_t.lsc04 
              OR g_lsc_t.lsc04 IS NULL  THEN 
                SELECT count(*) INTO l_n FROM lsc_file
                 WHERE lsc04 = g_lsc.lsc04
                   AND lsc05 ! = g_lsc.lsc05
                   AND ((lsc05 <= g_lsc.lsc05 AND lsc06 >= g_lsc.lsc05)
                    OR (lsc05 <= g_lsc.lsc06 AND lsc06 >= g_lsc.lsc06)
                    OR (lsc05 >= g_lsc.lsc05 AND lsc06 <= g_lsc.lsc06)) 
                   #AND lsc14 <> 's' #TQC-C20351 MARK
                   AND lsc14 <> 'S'  #TQC-C20351 ADD 
                IF l_n > 0 THEN
                   CALL cl_err('','alm-924',1)
                   NEXT FIELD lsc05
                END IF 
           END IF                                                                                                                                                                   
          END IF 
         
      #FUN-C30137--start mark-------------------------
     # AFTER FIELD lsc08
     #   IF NOT cl_null(g_lsc.lsc08) THEN
     #      IF g_lsc.lsc08<0 THEN
     #        CALL cl_err(g_lsc.lsc08,'alm-061',0)
     #        NEXT FIELD lsc08
     #      END IF
     #   END IF
     #   DISPLAY BY NAME g_lsc.lsc08
     # 
     # AFTER FIELD lsc09
     #   IF NOT cl_null(g_lsc.lsc09) THEN
     #      IF g_lsc.lsc09<0 THEN
     #        CALL cl_err(g_lsc.lsc09,'alm-061',0)
     #        NEXT FIELD lsc09
     #      END IF
     #   END IF
     #   DISPLAY BY NAME g_lsc.lsc09
      #FUN-C30137--end mark--------------------------  
      
      #FUN-C30137--start add-----------------------------------------
      AFTER FIELD lsc21
         IF NOT cl_null(g_lsc.lsc21) THEN
            CALL i870_lsc21(p_cmd)
            IF NOT cl_null (g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lsc.lsc21 = g_lsc_t.lsc21
               DISPLAY BY NAME g_lsc.lsc21
               NEXT FIELD lsc21
            END IF
         END IF 
 
      AFTER FIELD lsc08
         IF NOT cl_null(g_lsc.lsc21) THEN
            IF g_lsc.lsc08 <= 0 THEN
               CALL cl_err('','alm1607',0) 
               LET g_lsc.lsc08 = g_lsc_t.lsc08
               NEXT FIELD lsc08
            END IF 
         ELSE
            IF NOT cl_null(g_lsc.lsc08) THEN
               IF g_lsc.lsc08 < 0 THEN
                  CALL cl_err('','alm-342',0)
                  LET g_lsc.lsc08 = g_lsc_t.lsc08  
                  NEXT FIELD lsc08
               END IF 
            END IF
         END IF 
 
      AFTER FIELD lsc22
         IF NOT cl_null(g_lsc.lsc22) THEN
            CALL i870_lsc22(p_cmd)
            IF NOT cl_null (g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lsc.lsc22 = g_lsc_t.lsc22
               DISPLAY BY NAME g_lsc.lsc22
               NEXT FIELD lsc22
            END IF 
         END IF   
       
      AFTER FIELD lsc09
         IF NOT cl_null(g_lsc.lsc22) THEN
            IF g_lsc.lsc09 <= 0 THEN
               CALL cl_err('','alm1608',0)
               LET g_lsc.lsc09 = g_lsc_t.lsc09
               NEXT FIELD lsc09
            END IF
         ELSE
            IF NOT cl_null(g_lsc.lsc09) THEN
               IF g_lsc.lsc09 < 0 THEN
                  CALL cl_err('','alm-342',0)
                  LET g_lsc.lsc09 = g_lsc_t.lsc09
                  NEXT FIELD lsc09
               END IF 
            END IF 
         END IF 
      #FUN-C30137--end add------------------------------------------- 
 
      AFTER INPUT
         LET g_lsc.lscuser = s_get_data_owner("lsc_file") #FUN-C10039
         LET g_lsc.lscgrup = s_get_data_group("lsc_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         #FUN-C30137--start add--------------------------------------
         CASE
            WHEN NOT cl_null(g_lsc.lsc21) AND cl_null(g_lsc.lsc08)
               CALL cl_err('','alm1605',0)
               NEXT FIELD lsc08
            WHEN cl_null(g_lsc.lsc21) AND NOT cl_null(g_lsc.lsc08)
               CALL cl_err('','alm1610',0)
               NEXT FIELD lsc21
            WHEN NOT cl_null(g_lsc.lsc22) AND cl_null(g_lsc.lsc09)
               CALL cl_err('','alm1606',0)
               NEXT FIELD lsc09
            WHEN cl_null(g_lsc.lsc22) AND NOT cl_null(g_lsc.lsc09)
               CALL cl_err('','alm1611',0)
               NEXT FIELD lsc22
            OTHERWISE
               EXIT CASE
         END CASE
         #FUN-C30137--end add---------------------------------------- 

            IF g_lsc.lsc01  IS NULL THEN
             CALL cl_err(g_lsc.lsc01,'alm-055',1)
             NEXT FIELD lsc01
               DISPLAY BY NAME g_lsc.lsc01
               LET l_input='Y'
            END IF
#           IF  g_lsc.lsc04 != g_lsc_t.lsc04 
#              OR g_lsc_t.lsc04 IS NULL  THEN 
#                SELECT count(*) INTO l_n FROM lsc_file
#                 WHERE lsc05 ! = g_lsc.lsc05
#                   AND ((lsc05 <= g_lsc.lsc05 AND lsc06 >= g_lsc.lsc05)
#                    OR (lsc05 <= g_lsc.lsc06 AND lsc06 >= g_lsc.lsc06)
#                    OR (lsc05 >= g_lsc.lsc05 AND lsc06 <= g_lsc.lsc06)) 
#                IF l_n > 0 THEN
#                   CALL cl_err('','alm-924',1)
#                   NEXT FIELD lsc05
#                END IF 
#           END IF
            IF l_input='Y' THEN
               NEXT FIELD lsc01
            END IF
 
      ON ACTION CONTROLO                       
         IF INFIELD(lsc01) THEN
            LET g_lsc.* = g_lsc_t.*
            CALL i870_show()
            NEXT FIELD lsc01
         END IF
 
     ON ACTION controlp
        CASE
            WHEN INFIELD(lsc01)     #單據編號
               LET g_t1=s_get_doc_no(g_lsc.lsc01)
               #CALL q_lrk(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1     #FUN-A70130 mark
               CALL q_oay(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1     #FUN-A70130  add
               LET g_lsc.lsc01 = g_t1
               DISPLAY BY NAME g_lsc.lsc01
               NEXT FIELD lsc01
            WHEN INFIELD(lsc03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lne01"
                 LET g_qryparam.default1 = g_lsc.lsc03
                 CALL cl_create_qry() RETURNING g_lsc.lsc03
                 DISPLAY BY NAME g_lsc.lsc03
                 CALL i870_lsc03('d')
                 NEXT FIELD lsc03 
            WHEN INFIELD(lsc04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lsb"
                 LET g_qryparam.where = " lsbstore IN ",g_auth," "  #No.FUN-A10060
                 LET g_qryparam.default1 = g_lsc.lsc04
                 CALL cl_create_qry() RETURNING g_lsc.lsc04
                 DISPLAY BY NAME g_lsc.lsc04
                 CALL i870_lsc04('d')
                 NEXT FIELD lsc04
            WHEN INFIELD(lsc18)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gec001"
                 LET g_qryparam.default1 = g_lsc.lsc18
                 CALL cl_create_qry() RETURNING g_lsc.lsc18
                 DISPLAY BY NAME g_lsc.lsc04        #FUN-C30137 mark
                 DISPLAY BY NAME g_lsc.lsc18        #FUN-C30137 add
                 CALL i870_lsc18('d')
                 NEXT FIELD lsc18
           #FUN-C30137--start add--------------------------------
           WHEN INFIELD(lsc21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oaj"
                 LET g_qryparam.default1 = g_lsc.lsc21
                 LET g_qryparam.where = " oajacti = 'Y' AND oaj05='01' " 
                 CALL cl_create_qry() RETURNING g_lsc.lsc21
                 DISPLAY BY NAME g_lsc.lsc21
                 NEXT FIELD lsc21
           WHEN INFIELD(lsc22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oaj"
                 LET g_qryparam.default1 = g_lsc.lsc22
                 LET g_qryparam.where = " oajacti = 'Y' AND oaj05='02' "
                 CALL cl_create_qry() RETURNING g_lsc.lsc22
                 DISPLAY BY NAME g_lsc.lsc22
                 NEXT FIELD lsc22
           #FUN-C30137--end add----------------------------------- 
 
           OTHERWISE
              EXIT CASE
           END CASE
 
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
END FUNCTION

#FUN-C30137--start add----------------------------
FUNCTION i870_lsc21(p_cmd)
   DEFINE l_oaj05    LIKE oaj_file.oaj05
   DEFINE l_oajacti  LIKE oaj_file.oajacti
   DEFINE l_oaj02    LIKE oaj_file.oaj02 
   DEFINE p_cmd      LIKE type_file.chr1

   LET g_errno = ""
    
   SELECT oaj02,oaj05,oajacti INTO l_oaj02,l_oaj05,l_oajacti
     FROM oaj_file
    WHERE oaj01 = g_lsc.lsc21

   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno = 'alm1031'
      WHEN l_oajacti <> 'Y'
         LET g_errno ='alm1032'
      WHEN l_oaj05<>'01'
         LET g_errno = 'alm1058'
       OTHERWISE
          LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
  
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_oaj02 TO FORMONLY.oaj02    
      DISPLAY BY NAME g_lsc.lsc21
   END IF

END FUNCTION

FUNCTION i870_lsc22(p_cmd)
   DEFINE l_oaj05    LIKE oaj_file.oaj05
   DEFINE l_oajacti  LIKE oaj_file.oajacti
   DEFINE l_oaj02    LIKE oaj_file.oaj02
   DEFINE p_cmd      LIKE type_file.chr1

   LET g_errno = ""

   SELECT oaj02,oaj05,oajacti INTO l_oaj02,l_oaj05,l_oajacti
     FROM oaj_file
    WHERE oaj01 = g_lsc.lsc22

   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno = 'alm1031'
      WHEN l_oajacti <> 'Y'
         LET g_errno ='alm1032'
      WHEN l_oaj05<>'02'
         LET g_errno = 'alm1609'
       OTHERWISE
          LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_oaj02 TO FORMONLY.oaj02_1 
      DISPLAY BY NAME g_lsc.lsc21
   END IF
END FUNCTION
#FUN-C30137--end add------------------------------

#add by dxfwo--begin--------
#FUNCTION i870_auno1()
#DEFINE p_no      LIKE tc_boo_file.tc_boo04
#DEFINE l_lsc02   LIKE lsc_file.lsc02
#DEFINE p1        VARCHAR(4)
#DEFINE p2        VARCHAR(6)
#DEFINE l_mallno  LIKE azp_file.azp01
#
#  SELECT azp01 INTO l_mallno FROM azp_file WHERE azp03 = g_dbs
#  LET p1 = l_mallno[1,3],'-'
#  SELECT MAX(lsc02) INTO l_lsc02 FROM lsc_file   
#   WHERE SUBSTR(lsc02,1,4) = p1
#  LET p2 = l_lsc02[5,10]
#  IF l_lsc02 IS NULL THEN
#     LET p2 = '000001'
#  ELSE
#     LET p2 = p2+1 USING '&&&&&&'
#  END IF
#  LET p_no = p1,p2
#  RETURN p_no
#
#END FUNCTION
#add by dxfwo--end----------
FUNCTION i870_check_lsc01(p_cmd)
 DEFINE p_cmd    LIKE lsc_file.lsc01
 DEFINE l_count  LIKE type_file.num10
 
 SELECT COUNT(lsc01) INTO l_count FROM lsc_file
  WHERE lsc01 = p_cmd
  
 IF l_count > 0 THEN
    CALL cl_err(g_lsc.lsc01,'alm-054',1)
    DISPLAY '' TO lsc01 
    LET g_success = 'N'
 ELSE
 	  LET g_success = 'Y'   
 END IF 
 
END FUNCTION
FUNCTION i870_lsc03(p_cmd)
DEFINE
   p_cmd        VARCHAR(01),
   l_lne01      LIKE lne_file.lne01,
   l_lne05      LIKE lne_file.lne05,
#   l_lneacti    LIKE lne_file.lneacti,
   l_lne14      LIKE lne_file.lne14,
   l_lne47      LIKE lne_file.lne47,
   l_lne15      LIKE lne_file.lne15,
   l_lne36      LIKE lne_file.lne36,
   l_gec02      LIKE gec_file.gec02,
   l_gec04      LIKE gec_file.gec04,
   l_gec07      LIKE gec_file.gec07,
   l_gecacti    LIKE gec_file.gecacti
   LET g_errno=''
   SELECT lne01,lne05,lne14,lne47,lne15,lne36,lne40
     INTO l_lne01,l_lne05,l_lne14,l_lne47,l_lne15,l_lne36,g_lsc.lsc18
     FROM lne_file
    WHERE lne01=g_lsc.lsc03
      #AND lne36= 'Y'   #MOD-A30156
#      AND lneacti= 'Y'  
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-982'   #MOD-A30156 alm-921-->alm-982
                                LET l_lne01=NULL
#       WHEN l_lneacti='N'       LET g_errno='9028'
       WHEN l_lne36='N'         LET g_errno='alm-002'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY BY NAME g_lsc.lsc18
      DISPLAY l_lne05 TO FORMONLY.lne05
      DISPLAY l_lne14 TO FORMONLY.lne14
      DISPLAY l_lne47 TO FORMONLY.lne47
      DISPLAY l_lne15 TO FORMONLY.lne15
   END IF
   
   #-----MOD-A30156---------
   #LET g_errno=''
   IF NOT cl_null(g_errno) THEN 
      RETURN
   END IF
   #-----END MOD-A30156-----
   SELECT gec02,gec04,gec07
     INTO l_gec02,l_gec04,l_gec07
     FROM gec_file
    WHERE gec01=g_lsc.lsc18
      AND gec011 = '2'   #MOD-B40138 add
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-921'
                                LET l_gec02=NULL
       WHEN l_gecacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      LET g_lsc.lsc19 = l_gec04
      LET g_lsc.lsc20 = l_gec07
      DISPLAY BY NAME g_lsc.lsc19
      DISPLAY BY NAME g_lsc.lsc20
      DISPLAY l_gec02 TO FORMONLY.gec02
   END IF   
END FUNCTION
 
FUNCTION i870_lsc03_1(p_cmd)
DEFINE
   p_cmd        VARCHAR(01),
   l_lne01      LIKE lne_file.lne01,
   l_lne05      LIKE lne_file.lne05,
   l_lne14      LIKE lne_file.lne14,
   l_lne47      LIKE lne_file.lne47,
   l_lne15      LIKE lne_file.lne15,
   l_lne36      LIKE lne_file.lne36,
   l_gec02      LIKE gec_file.gec02,
   l_gec04      LIKE gec_file.gec04,
   l_gec07      LIKE gec_file.gec07,
   l_gecacti    LIKE gec_file.gecacti
   LET g_errno=''
   SELECT lne01,lne05,lne14,lne47,lne15,lne36
     INTO l_lne01,l_lne05,l_lne14,l_lne47,l_lne15,l_lne36
     FROM lne_file
    WHERE lne01=g_lsc.lsc03
      AND lne36= 'Y'
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-982'   #MOD-A30156 alm-921-->alm-982
                                LET l_lne01=NULL
       WHEN l_lne36='N'         LET g_errno='alm-002'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_lne05 TO FORMONLY.lne05
      DISPLAY l_lne14 TO FORMONLY.lne14
      DISPLAY l_lne47 TO FORMONLY.lne47
      DISPLAY l_lne15 TO FORMONLY.lne15
   END IF
      
END FUNCTION
 
FUNCTION i870_lsc04(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1, 
   l_lsbstore    LIKE lsb_file.lsbstore,
   l_lsb03    LIKE lsb_file.lsb03,
   l_lsb04    LIKE lsb_file.lsb04,
   l_lsb05    LIKE lsb_file.lsb05,
   l_lsb06    LIKE lsb_file.lsb06,
   l_lsb07    LIKE lsb_file.lsb07,
   l_lsb08    LIKE lsb_file.lsb08,
   l_lsb16    LIKE lsb_file.lsb16,
   l_lmb03    LIKE lmb_file.lmb03,
   l_lmc04    LIKE lmc_file.lmc04 
 
   LET g_errno=''
   SELECT lsbstore,lsb03,lsb04,lsb05,lsb06,lsb07,lsb08,lsb16
     INTO l_lsbstore,l_lsb03,l_lsb04,l_lsb05,l_lsb06,l_lsb07,l_lsb08
     FROM lsb_file
    WHERE lsb01=g_lsc.lsc04 
   SELECT lmb03 INTO l_lmb03 FROM lmb_file
    WHERE lmb02 = l_lsb03
      AND lmbstore = l_lsbstore 
   SELECT lmc04 INTO l_lmc04 FROM lmc_file
    WHERE lmc03 = l_lsb04
      AND lmc02 = l_lsb03
      AND lmcstore = l_lsbstore
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-003'
                                LET l_lsb03=NULL
       WHEN l_lsbstore<>g_lsc.lscstore  LET g_errno = 'alm-376'                         
       WHEN l_lsb16='N'         LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_lsb03 TO FORMONLY.lsb03
      DISPLAY l_lsb04 TO FORMONLY.lsb04
      DISPLAY l_lsb05 TO FORMONLY.lsb05
      DISPLAY l_lsb06 TO FORMONLY.lsb06
      DISPLAY l_lsb07 TO FORMONLY.lsb07
      DISPLAY l_lsb08 TO FORMONLY.lsb08
      DISPLAY l_lmb03 TO FORMONLY.lmb03
      DISPLAY l_lmc04 TO FORMONLY.lmc04
   END IF
END FUNCTION
 
FUNCTION i870_lsc18(p_cmd)
DEFINE
   p_cmd        VARCHAR(01),
   l_gec02      LIKE gec_file.gec02,
   l_gec04      LIKE gec_file.gec04,
   l_gec07      LIKE gec_file.gec07,
   l_gecacti    LIKE gec_file.gecacti
 
   LET g_errno=''
   SELECT gec02,gec04,gec07
     INTO l_gec02,l_gec04,l_gec07
     FROM gec_file
    WHERE gec01=g_lsc.lsc18
      AND gec011 = '2'  #MOD-B40138 add
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-921'
                                LET l_gec02=NULL
       WHEN l_gecacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      LET g_lsc.lsc19 = l_gec04
      LET g_lsc.lsc20 = l_gec07
      DISPLAY BY NAME g_lsc.lsc19
      DISPLAY BY NAME g_lsc.lsc20
      DISPLAY l_gec02 TO FORMONLY.gec02
   END IF
END FUNCTION
 
FUNCTION i870_q()
##CKP
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lsc.* TO NULL 
    MESSAGE ""
    CALL cl_msg("")
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i870_curs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i870_count
    FETCH i870_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i870_cs                          #
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lsc.lsc01,SQLCA.sqlcode,0)
        INITIALIZE g_lsc.* TO NULL
    ELSE
        CALL i870_fetch('F')            
    END IF
END FUNCTION
 
FUNCTION i870_fetch(p_flag)
    DEFINE
        p_flag          VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i870_cs INTO g_lsc.lsc01
        WHEN 'P' FETCH PREVIOUS i870_cs INTO g_lsc.lsc01
        WHEN 'F' FETCH FIRST    i870_cs INTO g_lsc.lsc01
        WHEN 'L' FETCH LAST     i870_cs INTO g_lsc.lsc01
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
            FETCH ABSOLUTE g_jump i870_cs INTO g_lsc.lsc01
            LET g_no_ask = FALSE      
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lsc.lsc01,SQLCA.sqlcode,0)
        INITIALIZE g_lsc.* TO NULL
        LET g_lsc.lsc01 = NULL 
        RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx 
    END IF
 
    SELECT * INTO g_lsc.* FROM lsc_file    
       WHERE lsc01 = g_lsc.lsc01
       
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lsc_file",g_lsc.lsc01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_lsc.lscuser     #
        LET g_data_group=g_lsc.lscgrup
        CALL i870_show()                   
    END IF
END FUNCTION
 
FUNCTION i870_show()
DEFINE l_gen02 LIKE gen_file.gen02
    DISPLAY BY NAME g_lsc.lscstore,g_lsc.lsclegal,g_lsc.lsc01,g_lsc.lsc02,g_lsc.lsc03,g_lsc.lsc04,g_lsc.lsc05, g_lsc.lscoriu,g_lsc.lscorig,
                    g_lsc.lsc06,g_lsc.lsc07,g_lsc.lsc08,g_lsc.lsc09,g_lsc.lsc10,
                    g_lsc.lsc11,g_lsc.lsc12,g_lsc.lsc13,g_lsc.lsc14,g_lsc.lsc15,
                    g_lsc.lsc21,g_lsc.lsc22,g_lsc.lsc23,                          #FUN-C30137 add                 
                    g_lsc.lsc16,g_lsc.lsc18,g_lsc.lsc19,g_lsc.lsc20,g_lsc.lscuser,
                    g_lsc.lscgrup,g_lsc.lsccrat,g_lsc.lscmodu,g_lsc.lscdate
 
    CALL i870_lscstore('d')
    CALL i870_lsc03_1('d')
    CALL i870_lsc04('d')
    CALL i870_lsc18('d')
    CALL i870_lsc21('d')         #FUN-C30137 add
    CALL i870_lsc22('d')         #FUN-C30137 add 
    CALL i870_field_pic()
    CALL cl_show_fld_cont()              
END FUNCTION
 
FUNCTION i870_u(p_wc)
DEFINE   p_wc        LIKE type_file.chr1
DEFINE   l_n         LIKE type_file.num5
 
    IF g_lsc.lsc01  IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_lsc.* FROM lsc_file 
     WHERE lsc01=g_lsc.lsc01
       
 
    IF g_lsc.lsc14 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF 
 
    IF g_lsc.lsc14 = 'S' THEN
       CALL cl_err('','alm-929',0)
       RETURN
    END IF
 
   IF g_lsc.lsc14='X' THEN             
      CALL cl_err(g_lsc.lsc01,'alm-134',1)
      RETURN
   END IF       
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN i870_cl USING g_lsc.lsc01
    IF STATUS THEN
       CALL cl_err("OPEN i870_cl:", STATUS, 1)
       CLOSE i870_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i870_cl INTO g_lsc.*         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsc.lsc01,SQLCA.sqlcode,1)
        RETURN
    END IF
 
    LET g_lsc01_t = g_lsc.lsc01
    LET g_lsc_t.*=g_lsc.*        
    IF p_wc != 'c' THEN 
       LET g_lsc.lscmodu=g_user                  
       LET g_lsc.lscdate = g_today             
    ELSE
       LET g_lsc.lscmodu= NULL                  
       LET g_lsc.lscdate = NULL                 
    END IF      
 
    IF g_lsc.lsc13 MATCHES '[Ss11WwRr]' THEN 
       LET g_lsc.lsc13 = '0'
    END IF    
    CALL i870_show()                         
    WHILE TRUE
        IF p_wc != 'c' THEN
           CALL i870_i("u","u")
        ELSE
        	 CALL i870_i("u","c")
        END IF                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0         
#           IF p_wc = 'c' THEN 
#             LET g_lsc_t.lsc04 = g_lsc.lsc04
               
#             CALL i870_lsc04_1(g_lsc.lsc04)
#             IF g_success = 'N' THEN 
#                LET g_lsc.lsc04 = g_lsc_t.lsc04
#                DISPLAY BY NAME g_lsc.lsc04
#                CONTINUE WHILE 
#             END IF                   
#              DELETE FROM lsc_file WHERE lsc01 = g_lsc.lsc01
#           END IF 
###########################################################################################            
            LET g_lsc.*=g_lsc_t.*            
            CALL i870_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF 
                
        UPDATE lsc_file SET lsc_file.* = g_lsc.*    #
            WHERE lsc01 = g_lsc01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lsc_file",g_lsc.lsc01,"",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i870_cl
    COMMIT WORK
END FUNCTION
 
#FUNCTION i870_x()
#    IF g_lsc.lsc01 IS NULL THEN
#        CALL cl_err('',-400,0)
#        RETURN
#    END IF
#    IF g_lsc.lsc14 = 'Y' THEN
#       CALL cl_err('','9023',0)
#       RETURN
#    END IF  
#    
#    IF g_lsc.lsc14 = 'S' THEN
#       CALL cl_err('','alm-931',0)
#       RETURN
#    END IF    
#    
#    IF g_lsc.lsc14 = 'X' THEN 
#       CALL cl_err(g_lsc.lsc01,'alm-134',1)
#       RETURN 
#    END IF  
#    IF g_lsc.lsc13 MATCHES '[Ss11WwRr]' THEN 
#       CALL cl_err('','mfg3557',0)
#       RETURN
#    END IF       
#    BEGIN WORK
#
#    OPEN i870_cl USING g_lsc_rowid
#    IF STATUS THEN
#       CALL cl_err("OPEN i870_cl:", STATUS, 1)
#       CLOSE i870_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    FETCH i870_cl INTO g_lsc.*
#    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_lsc.lsc01,SQLCA.sqlcode,1)
#       RETURN
#    END IF
#    CALL i870_show()
#    IF cl_exp(0,0,g_lsc.lscacti) THEN
#        LET g_chr=g_lsc.lscacti
#        IF g_lsc.lscacti='Y' THEN
#            LET g_lsc.lscacti='N'
#        ELSE
#            LET g_lsc.lscacti='Y'
#        END IF
#        UPDATE lsc_file
#           SET lscacti=g_lsc.lscacti,
#               lscmodu=g_user,
#               lscdate=g_today
#            WHERE ROWID=g_lsc_rowid
#        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_lsc.lsc01,SQLCA.sqlcode,0)
#            LET g_lsc.lscacti=g_chr
#        ELSE
#           LET g_lsc.lscmodu=g_user
#           LET g_lsc.lscdate=g_today
#           DISPLAY BY NAME g_lsc.lscacti,g_lsc.lscmodu,g_lsc.lscdate            
#        END IF
#    END IF
#    CLOSE i870_cl
#    COMMIT WORK
#END FUNCTION
 
FUNCTION i870_r()
    IF g_lsc.lsc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lsc.lsc14 = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END IF  
    IF g_lsc.lsc14 = 'X' THEN 
       CALL cl_err(g_lsc.lsc01,'alm-134',1)
       RETURN 
    END IF   
    
    IF g_lsc.lsc14 = 'S' THEN
       CALL cl_err('','alm-932',0)
       RETURN
    END IF
    
    IF g_lsc.lsc13 MATCHES '[Ss11WwRr]' THEN 
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF  
 
       
    BEGIN WORK
 
    OPEN i870_cl USING g_lsc.lsc01
    IF STATUS THEN
       CALL cl_err("OPEN i870_cl:", STATUS, 0)
       CLOSE i870_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i870_cl INTO g_lsc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsc.lsc01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i870_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lsc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lsc.lsc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lsc_file WHERE lsc01 = g_lsc.lsc01
       CLEAR FORM
       OPEN i870_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i870_cs
          CLOSE i870_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH i870_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i870_cs
          CLOSE i870_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i870_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i870_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE        
          CALL i870_fetch('/')
       END IF
    END IF
    CLOSE i870_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i870_copy()
    DEFINE
        l_newno1         LIKE lsc_file.lsc01,
        l_oldno1         LIKE lsc_file.lsc01,
        p_cmd            VARCHAR(1),
        l_n              SMALLINT,
        l_input          VARCHAR(1)
   DEFINE li_result   LIKE type_file.num5  
    IF g_lsc.lsc01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i870_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno1 FROM lsc01
 
#        AFTER FIELD lsc01
#         IF l_newno1 IS NOT NULL THEN
#             CALL i870_check_lsc01(l_newno1)
#             IF g_success = 'N' THEN                                                                                                
#                  LET g_lsc.lsc01 = g_lsc_t.lsc01                                                                                     
#                  DISPLAY BY NAME g_lsc.lsc01                                                                                         
#                  NEXT FIELD lsc01                                                                                                    
#              END IF  
#         ELSE 
#          	 CALL cl_err(l_newno1,'alm-055',1)
#          	 NEXT FIELD lsc01    
#         END IF
 
#        ON ACTION controlp                       
 
       BEFORE INPUT
          CALL cl_set_docno_format("lsc01")

       #TQC-C30290--start mark-------------------------------------------------------------------- 
       #AFTER FIELD lsc01
       #   CALL s_check_no("alm",l_newno1,"",g_kindtype,"lsc_file","lsc01","")
       #        RETURNING li_result,l_newno1
       #   DISPLAY l_newno1 TO lsc01
       #   IF (NOT li_result) THEN
       #      LET g_lsc.lsc01 = g_lsc_t.lsc01  
       #      NEXT FIELD lsc01
       #   END IF
 
       #   BEGIN WORK #No:7857
       #   CALL s_auto_assign_no("alm",l_newno1,g_today,g_kindtype,"lsc_file","lsc01","","","")
       #        RETURNING li_result,l_newno1
       #   IF (NOT li_result) THEN
       #      NEXT FIELD lsc01
       #   END IF
       #   DISPLAY l_newno1 TO lsc01
       #TQC-C30290--end mark-------------------------------------------------------------------- 
       #TQC-C30290--start add----------------------------------------------------
       AFTER FIELD lsc01 
          IF NOT cl_null(l_newno1) THEN
            CALL s_check_no("alm",l_newno1,"",g_kindtype,"lsc_file","lsc01","") 
              RETURNING li_result,l_newno1
            IF (NOT li_result) THEN
               LET l_newno1 = NULL
               DISPLAY l_newno1 TO lsc01
               NEXT FIELD lsc01
            END IF
          ELSE
             CALL cl_err('','alm-055',1)
             NEXT FIELD lsc01
          END IF

       AFTER INPUT 
          IF INT_FLAG THEN
             EXIT INPUT
          ELSE
         ###自動編號#############
             BEGIN WORK
             CALL s_auto_assign_no("alm",l_newno1,g_today,g_kindtype,"lsc_file","lsc01","","","") 
                  RETURNING li_result,l_newno1
             IF (NOT li_result) THEN
                RETURN
             END IF
             DISPLAY l_newno1 TO lsc01
          ######################
          END IF

       #TQC-C30290--end add------------------------------------------------------ 

 
       ON ACTION controlp
         CASE
            WHEN INFIELD(lsc01)     #單據編號
               LET g_t1=s_get_doc_no(g_lsc.lsc01)
            #  CALL q_lrk(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1   #FUN-A70130  mark
              CALL q_oay(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1    #FUN-A70130
               LET l_newno1 = g_t1
               DISPLAY l_newno1 TO lsc01
               NEXT FIELD lsc01
            OTHERWISE EXIT CASE
          END CASE
 
#add by dxfwo--begin-----------
#      	CALL i870_auno1()
#       RETURNING l_newno2
#       DISPLAY l_newno2 TO lsc02
#add by dxfwo--end-------------
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
        DISPLAY BY NAME g_lsc.lsc01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM lsc_file
        #WHERE lsc=g_lsc.lsc01    #TQC-C30290 mark
     WHERE lsc01 = g_lsc.lsc01    #TQC-C30290 add
        INTO TEMP x
    UPDATE x
        SET lsc01=l_newno1,  
            lsc04=NULL ,
            lsc10='',
            lsc11='',
            lsc14='N',
            lsc13='0',
            lsc15='',
            lsc16='',
            lscuser=g_user,   
            lscgrup=g_grup,   
            lscmodu=NULL,     
            lscdate=NULL, 
            lsccrat=g_today
    INSERT INTO lsc_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","lsc_file",g_lsc.lsc01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K'
        LET l_oldno1 = g_lsc.lsc01
        LET g_lsc.lsc01 = l_newno1
        SELECT lsc_file.* INTO g_lsc.* FROM lsc_file
               WHERE lsc01 = l_newno1 
        CALL i870_u("c")
        UPDATE lsc_file SET lscdate=NULL,lscmodu = NULL
                      WHERE lsc01 = l_newno1      
        #SELECT lsc_file.* INTO g_lsc.* FROM lsc_file #FUN-C30027
        #       WHERE lsc01 = l_oldno1                #FUN-C30027
    END IF
    #LET g_lsc.lsc01 = l_oldno1                       #FUN-C30027
    CALL i870_show()
END FUNCTION
 
#FUNCTION i870_out()
#    DEFINE
#        l_i             SMALLINT,
#        l_lsc           RECORD LIKE lsc_file.*,
#        l_gen           RECORD LIKE gen_file.*,
#        l_name          VARCHAR(20),           # External(Disk) file name
#        sr RECORD
#           lsc01 LIKE lsc_file.lsc01,
#           lsc02 LIKE lsc_file.lsc02,
#           lsc06 LIKE lsc_file.lsc06,
#           gen02 LIKE gen_file.gen02,
#           gen03 LIKE gen_file.gen03,
#           gen04 LIKE gen_file.gen04,
#           gem02 LIKE gem_file.gem02
#           END RECORD,
#        l_za05          VARCHAR(40)
#
#    #BugNO:4137
#    IF g_wc IS NULL THEN LET g_wc=" lsc01='",g_lsc.lsc01,"'" END IF
#  
#
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT lsc01,lsc02,lsc06,gen02,gen03,gen04,gem02 ",
#              " FROM lsc_file, OUTER(gen_file, OUTER(gem_file)) ",
#              " WHERE gen_file.gen01= lsc01 AND gem_file.gem01 = gen_file.gen03 ",
#              "   AND ",g_wc CLIPPED
#    
##   IF cl_null(g_wc) THEN
##       LET g_sql = g_sql CLIPPED," lsc01='",g_lsc.lsc01,"'"
##   ELSE
##       LET g_sql = g_sql CLIPPED, " AND ",g_wc CLIPPED
##   END IF
#   
#
#    PREPARE i870_p1 FROM g_sql                # RUNTIME 晤祒
#    DECLARE i870_curo                         # SCROLL CURSOR
#         CURSOR FOR i870_p1
#
#    CALL cl_outnam('aooi870') RETURNING l_name
#    START REPORT i870_rep TO l_name
#
#    FOREACH i870_curo INTO sr.*
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i870_rep(sr.*)
#    END FOREACH
#
#    FINISH REPORT i870_rep
#
#    CLOSE i870_curo
#    ERROR ""
#    #CALL cl_prt(l_name,'g_prtway','g_copies',g_len)
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#END FUNCTION
#
#REPORT i870_rep(sr)
#    DEFINE
#        l_trailer_sw    VARCHAR(1),
#        sr RECORD
#           lsc01 LIKE lsc_file.lsc01,
#           lsc02 LIKE lsc_file.lsc02,
#           lsc06 LIKE lsc_file.lsc06,
#           gen02 LIKE gen_file.gen02,
#           gen03 LIKE gen_file.gen03,
#           gen04 LIKE gen_file.gen04,
#           gem02 LIKE gem_file.gem02
#           END RECORD
#   OUTPUT
#       TOP MARGIN 0
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN 6
#       PAGE LENGTH g_page_line   #No.MOD-580242
#
#    ORDER BY sr.lsc01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            PRINT COLUMN g_c[31],sr.lsc01,
#                  COLUMN g_c[32],sr.gen02,
#                  COLUMN g_c[33],sr.gen03,
#                  COLUMN g_c[34],sr.gen04,
#                  COLUMN g_c[35],cl_numfor(sr.lsc06,35,g_azi04)
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
#                  g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
#                      g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
 
 
FUNCTION i870_set_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lsc01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i870_set_no_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("lsc01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i870_auto_code()
   DEFINE l_lua01 LIKE lua_file.lua01
   DEFINE l_date  LIKE lua_file.luacrat
   
  #SELECT max(SUBSTR(lua01,10))+1 INTO l_lua01 FROM lua_file
   SELECT max(lua01[10,20])+1 INTO l_lua01 FROM lua_file    #FUN-B40029
    WHERE luacrat=g_today 
     
   IF cl_null(l_lua01) THEN
      LET l_lua01 = l_lua01 using '&&&&'
      LET l_lua01 = YEAR(g_today) USING '&&&&' ,MONTH(g_today) USING '&&',DAY(g_today) USING '&&',"0001"
   ELSE
      LET l_lua01 = l_lua01 using '&&&&' 
      LET l_lua01 = YEAR(g_today) USING '&&&&' ,MONTH(g_today) USING '&&',DAY(g_today) USING '&&',l_lua01 
   END IF
   RETURN l_lua01
END FUNCTION
 
FUNCTION i870_y()
    DEFINE l_newno    LIKE lua_file.lua01
    DEFINE l_msg      LIKE type_file.chr50
    DEFINE l_lne05    LIKE lne_file.lne05 
    DEFINE l_n        LIKE type_file.num5
    DEFINE l_n3        LIKE type_file.chr50
    DEFINE l_n1       LIKE type_file.chr2 
    DEFINE li_result  LIKE type_file.num5 
   IF g_lsc.lsc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   IF g_lsc.lsc14 = 'S' THEN
      CALL cl_err('','alm-933',0)
      RETURN
   END IF   
   
   IF g_lsc.lsc14 ='Y' THEN
      CALL cl_err('','9023',0)      
      RETURN
   END IF
   IF g_lsc.lsc14 ='X' THEN
      CALL cl_err('','axr-103',0)      
      RETURN
   END IF
   IF g_lsc.lsc12 = 'Y'AND (cl_null(g_lsc.lsc13) OR  g_lsc.lsc13  ! = '1') THEN
      CALL cl_err('','alm-029',0)  
      RETURN
   END IF  
   IF g_lsc.lsc04 IS  NULL THEN 
      CALL cl_err('','alm-961',0)
      RETURN
   END IF        
#    IF NOT cl_null(g_lsc.lsc15) THEN
#    LET g_lsc.lsc15 = '1'
#    LET g_lsc.lsc14 = 'Y' 
#    DISPLAY BY NAME g_lsc.lsc14,g_lsc.lsc15
#    END IF 
   IF NOT cl_confirm('alm-006') THEN 
        RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'
   OPEN i870_cl USING g_lsc.lsc01
   IF STATUS THEN
       CALL cl_err("OPEN i870_cl:", STATUS, 1)
       CLOSE i870_cl
       ROLLBACK WORK
       RETURN
    END IF
    
    FETCH i870_cl INTO g_lsc.*              
     IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsc.lsc01,SQLCA.sqlcode,0)      
       CLOSE i870_cl
       ROLLBACK WORK
       RETURN
     END IF    
    
#   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01= g_lsc.lsc16
    UPDATE lsc_file SET lsc14 = 'Y',
                        lsc15 = g_user, 
                        lsc16 = g_today  
                  WHERE lsc01 = g_lsc.lsc01
                    
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","lsc_file",g_lsc.lsc01,"",SQLCA.sqlcode,"","",1)
       LET l_n='1'
       LET g_success = 'N' 
    ELSE
       
      CALL i870_auto_assign_no()
   
    END IF
#No.FUN-A80105   -----mark-------------------------------------------
#  
#   LET g_t1=s_get_doc_no(g_lsc.lsc01) 
# #FUN-A70130 --------------------start-----------------------------
# #    SELECT lrkdmy3 INTO l_n3 FROM lrk_file 
# #     WHERE lrkslip = g_t1 
# #    SELECT lrkkind INTO l_n1 FROM lrk_file
# #     WHERE lrkslip = l_n3
#       SELECT rye03 INTO l_n3 FROM rye_file 
#         WHERE  rye02 = 'B9' AND rye01 ='art'
#      SELECT oaytype INTO l_n1 FROM oay_file
#        WHERE oayslip = l_n3
# #FUN-A70130 ----------------------end---------------------  
#       CALL s_check_no("alm",l_n3,"",l_n1,"lua_file","lua01","")
#           RETURNING li_result,l_newno
#       CALL s_auto_assign_no("alm",l_newno,g_today,l_n1,"lua_file","lua01","","","")
#           RETURNING li_result,l_newno                        
#      CALL i870_auto_code()RETURNING l_newno
#     SELECT lne05 INTO l_lne05 FROM lne_file 
#      WHERE lne01 = g_lsc.lsc03 
#        AND lne36 = 'Y'
#     INSERT INTO lua_file(luaplant,lualegal,lua01,lua02,lua03,lua04,lua05,lua06,lua061,lua07,
#                          lua08,lua08t,lua09,lua10,lua11,lua12,lua13,lua14,lua15,lua16,
#                          lua17,lua18,lua19,luauser,luamodu,luagrup,luacrat,luadate,luaacti,
#                          lua20,lua21,lua22,lua23 ,luaoriu,luaorig)
#                          
#                   VALUES(g_plant,g_legal,l_newno,'01',NULL ,NULL ,'2',g_lsc.lsc03,l_lne05 ,NULL,
#                                 '0','0',g_today,'Y','2',g_lsc.lsc01,'N' ,'0','N',NULL ,
#                                 NULL ,NULL ,g_plant,g_user,'',g_grup,g_today,NULL,'Y',
#                                 ' ',g_lsc.lsc18,g_lsc.lsc19,g_lsc.lsc20  , g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#       IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","lua_file","","",SQLCA.sqlcode,"","",1)
#           LET l_n='1'
#           LET g_success = 'N'       
#       ELSE 
#       	  CALL cl_getmsg('alm-922',g_lang) RETURNING l_msg
#         	CALL cl_msgany(1,1,l_msg)     
#       END IF  
#      CALL i870_auto_code()RETURNING l_newno  
#     LET g_t1=s_get_doc_no(g_lsc.lsc01)
# #FUN-A70130 -----------------------start------------------------------     
# #   SELECT lrkdmy3 INTO l_n3 FROM lrk_file 
# #     WHERE lrkslip = g_t1 
# #    SELECT lrkkind INTO l_n1 FROM lrk_file
# #     WHERE lrkslip = l_n3 
#       SELECT rye03 INTO l_n3 FROM rye_file  
#         WHERE  rye02 = 'B9' AND rye01 ='art'
#      SELECT oaytype INTO l_n1 FROM oay_file
#        WHERE oayslip = l_n3 
# #FUN-A70130 -------------------------end-------------------------------- 
#       CALL s_check_no("alm",l_n3,"",l_n1,"lua_file","lua01","")        #FUN-A70130
#           RETURNING li_result,l_newno
#       CALL s_auto_assign_no("alm",l_newno,g_today,l_n1,"lua_file","lua01","","","")
#           RETURNING li_result,l_newno                                     
#     INSERT INTO lua_file( luaplant,lualegal,lua01,lua02,lua03,lua04,lua05,lua06,lua061,lua07,
#                           lua08,lua08t,lua09,lua10,lua11,lua12,lua13,lua14,lua15,lua16,
#                           lua17,lua18,lua19,luauser,luamodu,luagrup,luacrat,luadate,luaacti,
#                           lua20,lua21,lua22,lua23 ,luaoriu,luaorig)
#                   VALUES( g_plant,g_legal,l_newno,'02',' ',' ','2',g_lsc.lsc03,l_lne05 ,NULL,
#                           '0','0',g_today,'Y','2',g_lsc.lsc01,'N' ,'0','N',NULL ,
#                           NULL ,NULL ,g_plant,g_user,'',g_grup,g_today,NULL,'Y',
#                           ' ',g_lsc.lsc18,g_lsc.lsc19,g_lsc.lsc20  , g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#       IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","lua_file","","",SQLCA.sqlcode,"","",1)
#           LET g_success = 'N'            
#       ELSE 
#       	IF  l_n='1' THEN 
#       	  LET g_success = 'N'
#       	ELSE    
#       	  CALL cl_getmsg('alm-923',g_lang) RETURNING l_msg
#         	CALL cl_msgany(1,1,l_msg) 
#         END IF 		        	    
#       END IF   
#       
#     INSERT INTO lsd_file( lsdplant,lsdlegal,lsd01,lsd02,lsd03,lsd04,lsd05,
#                           lsd06,lsd07,lsd08,lsd09,lsd10,
#                           lsd11,lsd12,lsd13,lsd14,lsd15,
#                           lsd16,lsduser,lsdcrat,lsdmodu,lsdgrup,lsddate,lsd17,lsd18,
#                           lsd19,lsd20,lsd21 ,lsdoriu,lsdorig)
#                   VALUES( g_plant,g_legal,g_lsc.lsc01,g_lsc.lsc02,g_lsc.lsc03,g_lsc.lsc04,g_lsc.lsc05,
#                           g_lsc.lsc06,g_lsc.lsc07,g_lsc.lsc08,g_lsc.lsc09,g_lsc.lsc10,
#                           g_lsc.lsc11,g_lsc.lsc12,g_lsc.lsc13,g_lsc.lsc14,g_lsc.lsc15,
#                           g_lsc.lsc16,g_user,g_today,NULL ,g_grup,NULL,g_lsc.lscstore,NULL,
#                           g_lsc.lsc18,g_lsc.lsc19,g_lsc.lsc20 , g_user, g_grup)       #No.FUN-980030 10/01/04  insert columns oriu, orig
#       IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","lsd_file","","",SQLCA.sqlcode,"","",1)
#           LET g_success = 'N'       
#       ELSE 
#       	  CALL cl_getmsg('alm-926',g_lang) RETURNING l_msg
#         	CALL cl_msgany(1,1,l_msg)         	    
#       END IF                                                      
#  END IF 
#
#No.FUN-A80105  -------------------mark-------------------------------------
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_lsc.lsc14 = 'Y'
      LET g_lsc.lsc15 = g_user
      LET g_lsc.lsc16 = g_today
      DISPLAY BY NAME g_lsc.lsc14,g_lsc.lsc15,g_lsc.lsc16
      CALL cl_set_field_pic(g_lsc.lsc14,"","","","","")
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
#No.FUN-A80105 ---start
FUNCTION i870_auto_assign_no()
DEFINE l_msg      LIKE type_file.chr50
DEFINE l_n1       LIKE type_file.num5
DEFINE l_n        LIKE type_file.num5
DEFINE li_result  LIKE type_file.num5
DEFINE li_result1  LIKE type_file.num5
DEFINE l_lua01_1   LIKE lua_file.lua01
DEFINE l_lua01_2   LIKE lua_file.lua01
DEFINE l_lne05    LIKE lne_file.lne05 
DEFINE l_lsc05     LIKE lsc_file.lsc05   
DEFINE l_lsc06     LIKE lsc_file.lsc06
DEFINE l_lua01 LIKE lua_file.lua01 
DEFINE g_lua01 LIKE lua_file.lua01 #FUN-BB0117  add  
#FUN-C30137--start add---------------------------
DEFINE l_lub RECORD LIKE lub_file.*   
DEFINE l_lua RECORD LIKE lua_file.*
DEFINE l_lua08      LIKE lua_file.lua08
DEFINE l_lua08t     LIKE lua_file.lua08t
#FUN-C30137--end add-----------------------------

#No.FUN-BB0117   -----mark-------------------------------------------
#   SELECT rye03 INTO g_lua01_1 FROM rye_file
#                 WHERE rye01 = 'art' AND rye02 = 'B9'
#                 LET g_dd = g_today
#   LET g_lua01_2 = g_lua01_1
#   LET g_dd = g_today
#   OPEN WINDOW i870_1_w WITH FORM "alm/42f/almi870_1"
#                   ATTRIBUTE(STYLE=g_win_style CLIPPED)
#                   CALL cl_ui_locale("almi870_1")   
#    DISPLAY g_lua01_1 TO FORMONLY.g_lua01_1
#    DISPLAY g_lua01_2 TO FORMONLY.g_lua01_2
#    DISPLAY g_dd TO FORMONLY.g_dd
#    INPUT  BY NAME g_lua01_1,g_lua01_2,g_dd   WITHOUT DEFAULTS
#       BEFORE INPUT
#       AFTER FIELD g_lua01_1
## #        SELECT COUNT(*) INTO  l_n1 FROM oay_file
# #           WHERE oaysys ='art' AND oaytype ='B9' AND oayslip = g_lua01_1
# #        IF l_n1 = 0 THEN 
# #            CALL cl_err(g_lua01_1,'art-800',0)
# #            NEXT FIELD g_lua01_1
# #        END IF
#          CALL s_check_no("art",g_lua01_1,"",'B9',"lua_file","lua01","")        
#               RETURNING li_result,l_lua01_1 
#          IF NOT li_result THEN
#             CALL cl_err(g_lua01_1,'art-800',0)
#             NEXT FIELD g_lua01_1
#          END IF
#       AFTER FIELD g_lua01_2
# #        SELECT COUNT(*) INTO  l_n1 FROM oay_file
# #           WHERE oaysys ='art' AND oaytype ='B9' AND oayslip = g_lua01_2
# #        IF l_n1 = 0 THEN 
# #            CALL cl_err(g_lua01_2,'art-800',0)
# #            NEXT FIELD g_lua01_2
# #        END IF
#          CALL s_check_no("art",g_lua01_2,"",'B9',"lua_file","lua01","")        
#               RETURNING li_result1,l_lua01_2   
#          IF NOT li_result1 THEN
#             CALL cl_err(g_lua01_2,'art-800',0)
#             NEXT FIELD g_lua01_2
#          END IF
#       AFTER FIELD g_dd
#          IF NOT cl_null(g_dd) THEN 
#             SELECT lsc05,lsc06 INTO l_lsc05,l_lsc06 FROM lsc_file
#              WHERE lsc01 = g_lsc.lsc01  
#             IF g_dd > l_lsc06 OR g_dd <l_lsc05 THEN
#                CALL cl_err(g_dd,'alm-768',0)
#                NEXT FIELD  g_dd
#             END IF  
#          ELSE
#             NEXT FIELD  g_dd
#          END IF          
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
# 
#       ON ACTION CONTROLG
#          CALL cl_cmdask()
#    
#       ON ACTION CONTROLF
#          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
#          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)     
#       ON ACTION controlp
#          CASE
#            WHEN INFIELD(g_lua01_1)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_slip"
#              LET g_qryparam.default1 = g_lua01_1
#              CALL cl_create_qry() RETURNING g_lua01_1
#              DISPLAY BY NAME g_lua01_1
#              NEXT FIELD g_lua01_1
#            WHEN INFIELD(g_lua01_2)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_slip"
#              LET g_qryparam.default1 = g_lua01_2
#              CALL cl_create_qry() RETURNING g_lua01_2
#              DISPLAY BY NAME g_lua01_2
#              NEXT FIELD g_lua01_2
#        
#              OTHERWISE EXIT CASE
#         END CASE
#No.FUN-BB0117   ----end-------------------------------------------

#FUN-BB0117-add-begin----
   IF NOT cl_null(g_lsc.lsc21) OR NOT cl_null(g_lsc.lsc22) THEN       #FUN-C30137 add 
      #FUN-C90050 mark begin---
      #SELECT rye03 INTO g_lua01 FROM rye_file
      #              WHERE rye01 = 'art' AND rye02 = 'B9'
      #FUN-C90050 mark end-----
      CALL s_get_defslip('art','B9',g_plant,'N') RETURNING g_lua01   #FUN-C90050 add


      LET g_dd = g_today
      #FUN-C30137--start add--------------------------------------
      IF cl_null(g_lua01) THEN
         CALL cl_err('','art-330',0)   
         LET g_success = 'N'
         RETURN
      END IF 
      #FUN-C30137--end add----------------------------------------
      LET g_dd = g_today
   #FUN-C30137--start mark-------------------------------------
#   OPEN WINDOW i870_1_w WITH FORM "alm/42f/almi870_1"
#                   ATTRIBUTE(STYLE=g_win_style CLIPPED)
#                   CALL cl_ui_locale("almi870_1")   
#    DISPLAY g_lua01 TO FORMONLY.g_lua01
#    DISPLAY g_dd TO FORMONLY.g_dd
#    INPUT  BY NAME g_lua01,g_dd   WITHOUT DEFAULTS
#       BEFORE INPUT
#       AFTER FIELD g_lua01
#          CALL s_check_no("art",g_lua01,"",'B9',"lua_file","lua01","")        
#               RETURNING li_result,l_lua01
#          IF NOT li_result THEN
#             CALL cl_err(g_lua01,'art-800',0)
#             NEXT FIELD g_lua01
#          END IF
#
#       AFTER FIELD g_dd
#          IF NOT cl_null(g_dd) THEN 
#             SELECT lsc05,lsc06 INTO l_lsc05,l_lsc06 FROM lsc_file
#              WHERE lsc01 = g_lsc.lsc01  
#             IF g_dd > l_lsc06 OR g_dd <l_lsc05 THEN
#                CALL cl_err(g_dd,'alm-768',0)
#                NEXT FIELD  g_dd
#             END IF  
#          ELSE
#             NEXT FIELD  g_dd
#          END IF          
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
# 
#       ON ACTION CONTROLG
#          CALL cl_cmdask()
#    
#       ON ACTION CONTROLF
#          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)     
#       ON ACTION controlp
#          CASE
#            WHEN INFIELD(g_lua01)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_slip"
#              LET g_qryparam.default1 = g_lua01
#              CALL cl_create_qry() RETURNING g_lua01
#              DISPLAY BY NAME g_lua01
#              NEXT FIELD g_lua01
#        
#              OTHERWISE EXIT CASE
#         END CASE
##FUN-BB0117-add-end-----
#       ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#       ON ACTION about
#          CALL cl_about()
#  
#       ON ACTION HELP
#          CALL cl_show_help()
#    END INPUT  
#      IF INT_FLAG THEN
#          LET INT_FLAG=0
#          RETURN
#          CALL cl_err('',9001,0)
#      END IF
#     CLOSE WINDOW i870_1_w 
     #FUN-C30137--end mark-------------------------------------------------------
#No.FUN-BB0117   -----mark-------------------------------------------
#     CALL s_check_no("art",g_lua01_1,"",'B9',"lua_file","lua01","")        #FUN-A70130
#          RETURNING li_result,l_lua01_1
#     CALL s_auto_assign_no("art",g_lua01_1,g_dd,'B9',"lua_file","lua01","","","")
#          RETURNING li_result,l_lua01_1  
#No.FUN-BB0117   ----end-------------------------------------------  

#FUN-BB0117-add-start--
     CALL s_check_no("art",g_lua01,"",'B9',"lua_file","lua01","")
          RETURNING li_result,l_lua01   
     CALL s_auto_assign_no("art",g_lua01,g_dd,'B9',"lua_file","lua01","","","")
          RETURNING li_result,l_lua01
#FUN-BB0117-add-end--   
     IF li_result THEN 
        SELECT lne05 INTO l_lne05 FROM lne_file 
        WHERE lne01 = g_lsc.lsc03 
          AND lne36 = 'Y'
#No.FUN-BB0117   -----mark-------------------------------------------         
#        INSERT INTO lua_file(luaplant,lualegal,lua01,lua02,lua03,lua04,lua05,lua06,lua061,lua07,
#                           lua08,lua08t,lua09,lua10,lua11,lua12,lua13,lua14,lua15,lua16,
#                           lua17,lua18,lua19,luauser,luamodu,luagrup,luacrat,luadate,luaacti,
#                           lua20,lua21,lua22,lua23 ,luaoriu,luaorig,lua32)
#                           
#                  # VALUES(g_plant,g_legal,l_lua01_1,'01',NULL ,NULL ,'2',g_lsc.lsc03,l_lne05 ,NULL,   #FUN-AC0062
#                    VALUES(g_plant,g_legal,l_lua01_1,'01',NULL ,NULL ,' ',g_lsc.lsc03,l_lne05 ,NULL,  #FUN-AC0062
#                                  '0','0',g_dd,'Y','6',g_lsc.lsc01,'N' ,'0','N',NULL ,
#                                  NULL ,NULL ,g_plant,g_user,'',g_grup,g_today,NULL,'Y',
#                                  ' ',g_lsc.lsc18,g_lsc.lsc19,g_lsc.lsc20 , g_user, g_grup,'2') 
#        
#        IF SQLCA.sqlcode THEN
#            CALL cl_err3("ins","lua_file","","",SQLCA.sqlcode,"","",1)
#            LET l_n='1'
#            LET g_success = 'N'       
#        ELSE 
#       	    CALL cl_getmsg('alm-922',g_lang) RETURNING l_msg
#            CALL cl_msgany(1,1,l_msg)     
#        END IF  
#     
#        CALL s_check_no("art",g_lua01_2,"",'B9',"lua_file","lua01","")        #FUN-A70130
#            RETURNING li_result1,l_lua01_2
#        CALL s_auto_assign_no("art",g_lua01_2,g_dd,'B9',"lua_file","lua01","","","")
#            RETURNING li_result1,l_lua01_2
#        IF li_result1 THEN 
#        
#           INSERT INTO lua_file( luaplant,lualegal,lua01,lua02,lua03,lua04,lua05,lua06,lua061,lua07,
#                                lua08,lua08t,lua09,lua10,lua11,lua12,lua13,lua14,lua15,lua16,
#                                lua17,lua18,lua19,luauser,luamodu,luagrup,luacrat,luadate,luaacti,
#                                lua20,lua21,lua22,lua23 ,luaoriu,luaorig,lua32)
#                  # VALUES( g_plant,g_legal,l_lua01_2,'02',' ',' ','2',g_lsc.lsc03,l_lne05 ,NULL,    #FUN-AC0062
#                    VALUES( g_plant,g_legal,l_lua01_2,'02',' ',' ',' ',g_lsc.lsc03,l_lne05 ,NULL,    #FUN-AC0062
#                            '0','0',g_dd,'Y','6',g_lsc.lsc01,'N' ,'0','N',NULL ,
#                            NULL ,NULL ,g_plant,g_user,'',g_grup,g_today,NULL,'Y',
#                            ' ',g_lsc.lsc18,g_lsc.lsc19,g_lsc.lsc20  , g_user, g_grup,'2')                          
#           IF SQLCA.sqlcode THEN
#               CALL cl_err3("ins","lua_file","","",SQLCA.sqlcode,"","",1)
#               LET g_success = 'N'            
#           ELSE 
#               IF  l_n='1' THEN 
#                  LET g_success = 'N'
#               ELSE    
#                  CALL cl_getmsg('alm-923',g_lang) RETURNING l_msg
#                  CALL cl_msgany(1,1,l_msg) 
#               END IF 		        	    
#           END IF 
#No.FUN-BB0117   -----end-------------------------------------------  
         
          #FUN-C30137--start add--------------------------------------------
             LET l_lub.lub01 = l_lua01
             SELECT MAX(lub02) +1 INTO l_lub.lub02
               FROM lub_file
              WHERE lub01 = l_lua01
             IF cl_null(l_lub.lub02) THEN
                LET l_lub.lub02 = 1
             END IF 
             LET l_lub.lub03 = g_lsc.lsc21
             IF g_lsc.lsc20 = 'Y' THEN
                LET l_lub.lub04t = g_lsc.lsc08
                LET l_lub.lub04 = g_lsc.lsc08/(1+g_lsc.lsc19/100)
                #LET l_lub.lub04 =  cl_digcut(l_lub.lub04,g_lla04)   #TQC-C30290 mark
                LET l_lub.lub04 =  cl_digcut(l_lub.lub04,g_azi04)    #TQC-C30290 add 
             ELSE
                LET l_lub.lub04 = g_lsc.lsc08
                LET l_lub.lub04t = g_lsc.lsc08*(1+g_lsc.lsc19/100)
                #LET l_lub.lub04t =  cl_digcut(l_lub.lub04t,g_lla04) #TQC-C30290 mark
                LET l_lub.lub04t =  cl_digcut(l_lub.lub04t,g_azi04)  #TQC-C30290 add
                  
             END IF 
             LET l_lub.lub07 = g_lsc.lsc05
             LET l_lub.lub08 = g_lsc.lsc06
             LET l_lub.lublegal = g_legal
             LET l_lub.lubplant = g_plant

             SELECT oaj05 INTO l_lub.lub09
               FROM oaj_file
              WHERE oaj01 = g_lsc.lsc21 
       
             LET l_lub.lub10 = g_today
             IF l_lub.lub10 <= g_ooz.ooz09 THEN
                LET l_lub.lub10 = g_ooz.ooz09 + 1
             END IF           
             LET l_lub.lub11 = 0
             LET l_lub.lub12 = 0
             LET l_lub.lub13 = 'N'

             IF NOT cl_null(g_lsc.lsc21) THEN
                INSERT INTO lub_file VALUES l_lub.*  
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                   CALL cl_err('insert lub_file:',SQLCA.SQLCODE,0)
                   LET g_success = 'N'
                END IF
             END IF 
              
             SELECT MAX(lub02) +1 INTO l_lub.lub02
               FROM lub_file
              WHERE lub01 = l_lua01
             IF cl_null(l_lub.lub02) THEN
                LET l_lub.lub02 = 1
             END IF

             LET l_lub.lub03 = g_lsc.lsc22
             IF g_lsc.lsc20 = 'Y' THEN
                LET l_lub.lub04t = g_lsc.lsc09
                LET l_lub.lub04 = g_lsc.lsc09/(1+g_lsc.lsc19/100)
                #LET l_lub.lub04 =  cl_digcut(l_lub.lub04,g_lla04)   #TQC-C30290 mark
                LET l_lub.lub04 =  cl_digcut(l_lub.lub04,g_azi04)    #TQC-C30290 add
             ELSE
                LET l_lub.lub04 = g_lsc.lsc09
                LET l_lub.lub04t = g_lsc.lsc09*(1+g_lsc.lsc19/100)
                #LET l_lub.lub04t = cl_digcut(l_lub.lub04t,g_lla04)  #TQC-C30290 mark
                LET l_lub.lub04t = cl_digcut(l_lub.lub04t,g_azi04)   #TQC-C30290 add
             END IF           
             SELECT oaj05 INTO l_lub.lub09
               FROM oaj_file
              WHERE oaj01 = g_lsc.lsc22
             IF NOT cl_null(g_lsc.lsc22) THEN
                INSERT INTO lub_file VALUES l_lub.*
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                   CALL cl_err('insert lub_file:',SQLCA.SQLCODE,0)
                   LET g_success = 'N'
                END IF
             END IF 
   
             SELECT SUM(lub04) INTO l_lua.lua08 
               FROM lub_file
              WHERE lub01 = l_lua01

             SELECT SUM(lub04t) INTO l_lua.lua08t
               FROM lub_file
              WHERE lub01 =l_lua01  

             LET l_lua.lua01 = l_lua01
             LET l_lua.lua02 = ' '
             LET l_lua.lua03 = ' '
             LET l_lua.lua04 = NULL
             IF s_chk_own(g_lsc.lsc03) THEN
               LET l_lua.lua05 = 'Y'
             ELSE
                LET l_lua.lua05 = 'N'
             END IF
             LET l_lua.lua06 = g_lsc.lsc03
             LET l_lua.lua061 = l_lne05
             LET l_lua.lua09 = g_dd
             LET l_lua.lua10 = 'Y'
             LET l_lua.lua11 = '6'
             LET l_lua.lua12 = g_lsc.lsc01
             LET l_lua.lua13 = 'N'
             LET l_lua.lua14 = '0'
             LET l_lua.lua15 = 'N'
             LET l_lua.lua16 = NULL
             LET l_lua.lua17 = NULL
             LET l_lua.lua18 = NULL 
             LET l_lua.lua19 = g_plant
             LET l_lua.lua20 = ' '
             LET l_lua.lua21 = g_lsc.lsc18
             LET l_lua.lua22 = g_lsc.lsc19
             LET l_lua.lua23 = g_lsc.lsc20
             LET l_lua.lua24 = NULL
             LET l_lua.luaacti = 'Y'
             LET l_lua.luacrat = g_today
             LET l_lua.luadate = g_today
             LET l_lua.luagrup = g_grup
             LET l_lua.lualegal = g_legal
             LET l_lua.luaplant = g_plant
             LET l_lua.luauser = g_user
             LET l_lua.luaoriu = g_user
             LET l_lua.luaorig = g_grup
             LET l_lua.lua32 = '3'
             LET l_lua.lua33 = NULL
             LET l_lua.lua34 = NULL
             LET l_lua.lua35 = '0'
             LET l_lua.lua36 = '0'
             LET l_lua.lua37 = 'N'
             LET l_lua.lua38 = g_user
             LET l_lua.lua39 = g_grup
             INSERT INTO lua_file VALUES l_lua.*
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","lua_file","","",SQLCA.sqlcode,"","",1)
                LET g_success = 'N'
             ELSE
                IF l_n='1' THEN
                   LET g_success = 'N'
                END IF  
             END IF  
          #FUN-C30137--end add----------------------------------------------
           
#FUN-C30137--start add--------------------------------------------------------
##FUN-BB0117-add-start--
#           INSERT INTO lua_file(lua01,lua02,lua03,lua04,lua05,lua06,lua061,
#                       lua08,lua08t,lua09,lua10,lua11,lua12,lua13,lua14,lua15,
#                       lua16,lua17,lua18,lua19,lua20,lua21,lua22,lua23,lua24,
#                       luaacti,luacrat,luadate,luagrup,lualegal,luaplant,luauser,
#                       luaoriu,luaorig,lua32,lua33,lua34,lua35,lua36,lua37,lua38,
#                       lua39)
#                  VALUES (l_lua01,' ',' ',NULL,' ',g_lsc.lsc03,l_lne05,
#                    #  '0','0',g_dd,'Y','6',g_lsc.lsc01,'N','0','N',                     #FUN-C30137 mark
#                       l_lua08,l_lua08t,g_dd,'Y','6',g_lsc.lsc01,'N','0','N',            #FUN-C30137 add
#                       NULL,NULL,NULL,g_plant,' ',g_lsc.lsc18,g_lsc.lsc19,g_lsc.lsc20,NULL,
#                       'Y',g_today,g_today,g_grup,g_legal,g_plant,g_user,
#                       #g_user,g_grup,'3',NULL,NULL,'0','0','Y',g_user,g_grup)      #FUN-C30137    mark
#                       g_user,g_grup,'3',NULL,NULL,'0','0','N',g_user,g_grup)       #FUN-C30137    add
#
#                 IF SQLCA.sqlcode THEN
#                    CALL cl_err3("ins","lua_file","","",SQLCA.sqlcode,"","",1)
#                    LET g_success = 'N'            
#                 ELSE 
#                    IF l_n='1' THEN 
#                       LET g_success = 'N'
#                    ELSE    
#                       CALL cl_getmsg('alm-923',g_lang) RETURNING l_msg
#                       CALL cl_msgany(1,1,l_msg) 
#                    END IF 		        	    
#                 END IF           
##FUN-C30137--end mark--------------------------------------------------------------
             #FUN-C30137--start add------------------------------------
             LET g_lsc.lsc23 = l_lua01                            #FUN-C30137 add
             DISPLAY BY NAME g_lsc.lsc23                          #FUN-C30137 add
                                   
             UPDATE lsc_file
                SET lsc23 = g_lsc.lsc23  
              WHERE lsc01 = g_lsc.lsc01
                AND lscstore = g_plant
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                CALL cl_err('UPDATE lsc_file:',SQLCA.SQLCODE,0)
                LET g_success = 'N'
             END IF   
             #FUN-C30137--end add-------------------------------------
#FUN-BB0117-add-end--                                
             
           #FUN-C30137--start add------------------------------------------------------------------------------------
           #INSERT INTO lsd_file( lsdplant,lsdlegal,lsd01,lsd02,lsd03,lsd04,lsd05,
           #                 lsd06,lsd07,lsd08,lsd09,lsd10,
           #                 lsd11,lsd12,lsd13,lsd14,lsd15,
           #                 lsd16,lsduser,lsdcrat,lsdmodu,lsdgrup,lsddate,lsd17,lsd18,
           #                 lsd19,lsd20,lsd21 ,lsdoriu,lsdorig)
           #         VALUES( g_plant,g_legal,g_lsc.lsc01,g_lsc.lsc02,g_lsc.lsc03,g_lsc.lsc04,g_lsc.lsc05,
           #                 g_lsc.lsc06,g_lsc.lsc07,g_lsc.lsc08,g_lsc.lsc09,g_lsc.lsc10,
           #              #   g_lsc.lsc11,g_lsc.lsc12,g_lsc.lsc13,g_lsc.lsc14,g_lsc.lsc15,        # TQC-C20355 mark
           #              #   g_lsc.lsc16,g_user,g_today,NULL ,g_grup,NULL,g_lsc.lscstore,NULL,    # TQC-C20355 mark
           #                 g_lsc.lsc11,g_lsc.lsc12,g_lsc.lsc13,'Y',g_user,                 #TQC-C20355 add        
           #                 g_today,g_user,g_today,NULL ,g_grup,NULL,g_lsc.lscstore,NULL,   #TQC-C20355 add 
           #                 g_lsc.lsc18,g_lsc.lsc19,g_lsc.lsc20 , g_user, g_grup)       #No.FUN-980030 10/01/04  insert columns oriu, orig
           #IF SQLCA.sqlcode THEN
           #   CALL cl_err3("ins","lsd_file","","",SQLCA.sqlcode,"","",1)
           #   LET g_success = 'N'       
           #ELSE 
           #   CALL cl_getmsg('alm-926',g_lang) RETURNING l_msg
           #   CALL cl_msgany(1,1,l_msg)         	    
           #END IF         
           #FUN-C30137--end mark-----------------------------------------------------------------------------------------                                               
        END IF 

       IF NOT li_result  THEN 
          CALL cl_err('','alm-859',0)
          LET g_success = 'N'
       END IF
   END IF       #FUN-C30137 add
END FUNCTION
#No.FUN-A80105  ---end 
FUNCTION i870_v()
   IF g_lsc.lsc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lsc.lsc14 ='Y' THEN
      CALL cl_err('','9023',0)      
      RETURN
   END IF
   
    IF g_lsc.lsc14 = 'S' THEN
       CALL cl_err('','alm-930',0)
       RETURN
    END IF
   
   IF g_lsc.lsc13 MATCHES '[Ss11WwRr]' THEN 
      CALL cl_err('','mfg3557',0)
      RETURN
   END IF    
 
   BEGIN WORK
 
   OPEN i870_cl USING g_lsc.lsc01
   IF STATUS THEN
       CALL cl_err("OPEN i870_cl:", STATUS, 1)
       CLOSE i870_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i870_cl INTO g_lsc.*               
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsc.lsc01,SQLCA.sqlcode,0)
       CLOSE i870_cl
       ROLLBACK WORK
       RETURN
    END IF    
    
    IF g_lsc.lsc14 != 'X' THEN
       IF NOT cl_confirm('alm-085') THEN RETURN END IF
       LET g_lsc.lsc14 = 'X'
        CALL cl_set_field_pic("","","","","Y","") 
 #      CALL cl_set_field_pic()
    ELSE
       IF g_lsc.lsc14 = 'X' THEN
          IF NOT cl_confirm('alm-086') THEN RETURN END IF
          LET g_lsc.lsc14 = 'N'
          LET g_lsc.lsc13 = '0'
 #         CALL cl_set_field_pic()
       END IF
    END IF
    UPDATE lsc_file SET lsc14 = g_lsc.lsc14,
                        lsc13 = g_lsc.lsc13,
                        lscmodu=g_user,
                        lscdate=g_today
                  WHERE lsc01 = g_lsc.lsc01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","lsc_file",g_lsc.lsc01,"",SQLCA.sqlcode,"","",0) 
       ROLLBACK WORK
       RETURN
    END IF
    CLOSE i870_cl
    COMMIT WORK
   SELECT lsc13,lscmodu,lscdate
   INTO g_lsc.lsc13,g_lsc.lscmodu,g_lsc.lscdate FROM lsc_file
    WHERE lsc01=g_lsc.lsc01 
    DISPLAY BY NAME g_lsc.lsc13,g_lsc.lsc14,g_lsc.lscmodu,g_lsc.lscdate
END FUNCTION
 
FUNCTION i870_field_pic()
   DEFINE l_flag   VARCHAR(01)
 
   CASE
 
#     WHEN g_lsc.lscacti = 'N' 
#        CALL cl_set_field_pic("","","","","","N")
 
     WHEN g_lsc.lsc14 = 'Y' 
        CALL cl_set_field_pic("Y","","","","","")
 
     WHEN g_lsc.lsc14 = 'X' 
        CALL cl_set_field_pic("","","","","Y","")
     OTHERWISE
        CALL cl_set_field_pic("","","","","","")
   END CASE
END FUNCTION
 
FUNCTION i870_y_chk()
DEFINE l_str         VARCHAR(04)
 
   LET g_success = 'Y'
   IF g_lsc.lsc01 IS NULL  THEN RETURN END IF
    SELECT * INTO g_lsc.* FROM lsc_file 
     WHERE lsc01=g_lsc.lsc01
   IF g_lsc.lsc14='Y' THEN                   
       CALL cl_err('','9023',0)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_lsc.lsc14='X' THEN                  
        CALL cl_err('','9024',0)
        LET g_success = 'N'
        RETURN
   END IF
END FUNCTION
 
#FUNCTION i870_unconfirm()
#DEFINE l_n LIKE type_file.num5
#   
#    IF cl_null(g_lsc.lsc01) THEN 
#      CALL cl_err('','-400',0) 
#      RETURN 
#   END IF
#   
#   IF g_lsc.lscacti='N' THEN
#      CALL cl_err('','alm-049',0)
#      RETURN
#   END IF
#   
#   IF g_lsc.lsc14='N' THEN 
#      CALL cl_err('','9025',0)
#      RETURN
#   END IF
#
#   IF g_lsc.lsc14 ='X' THEN
#      CALL cl_err('','axr-103',0)      
#      RETURN
#   END IF
#
#   SELECT COUNT(*) INTO l_n FROM lua_file 
#    WHERE lua12 = g_lsc.lsc01
#      IF l_n > 0 THEN
#        CALL cl_err('','alm-925',1) 
#       RETURN 
#      END IF  
# 
#   IF NOT cl_confirm('alm-008') THEN 
#      RETURN
#   END IF
#   
#   BEGIN WORK
#   LET g_success = 'Y'
#
#   OPEN i870_cl USING g_lsc_rowid
#   IF STATUS THEN
#      CALL cl_err("OPEN i870_cl:", STATUS, 1)
#      CLOSE i870_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#   FETCH i870_cl INTO g_lsc.*    
#      IF SQLCA.sqlcode THEN
#      CALL cl_err(g_lsc.lsc01,SQLCA.sqlcode,0)      
#      CLOSE i870_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#   
#   UPDATE lsc_file SET lsc14 = 'N',lsc15 = '',lsc16 = '' 
#    WHERE lsc01 = g_lsc.lsc01
#   IF SQLCA.sqlcode THEN
#      CALL cl_err3("upd","lsc_file",g_lsc.lsc01,"",STATUS,"","",1) 
#      LET g_success = 'N'
#   ELSE 
#      LET g_lsc.lsc14 = 'N'
#      LET g_lsc.lsc15 = ''
#      LET g_lsc.lsc16 = ''
#      DISPLAY BY NAME g_lsc.lsc14,g_lsc.lsc15,g_lsc.lsc16
#      CALL cl_set_field_pic(g_lsc.lsc14,"","","","","")
#   END IF
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#   ELSE
#      ROLLBACK WORK
#   END IF
#END FUNCTION
 
FUNCTION i870_termination()
DEFINE l_n LIKE type_file.num5
   
    IF cl_null(g_lsc.lsc01) THEN 
      CALL cl_err('','-400',0) 
      RETURN 
   END IF
   
   IF g_lsc.lsc14='N' THEN 
      CALL cl_err('','alm-928',0)
      RETURN
   END IF
 
   IF g_lsc.lsc14 = 'S' THEN
      CALL cl_err('','alm-935',0)
      RETURN
   END IF
 
   IF g_lsc.lsc14 ='X' THEN
      CALL cl_err('','axr-103',0)      
      RETURN
   END IF
 
#   SELECT COUNT(*) INTO l_n FROM lua_file 
#    WHERE lua12 = g_lsc.lsc01
#      IF l_n > 0 THEN
#        CALL cl_err('','alm-925',1) 
#       RETURN 
#      END IF  
# 
#   IF NOT cl_confirm('alm-008') THEN 
#      RETURN
#   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i870_cl USING g_lsc.lsc01
   IF STATUS THEN
      CALL cl_err("OPEN i870_cl:", STATUS, 1)
      CLOSE i870_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i870_cl INTO g_lsc.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lsc.lsc01,SQLCA.sqlcode,0)      
      CLOSE i870_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE lsc_file SET lsc14 = 'S',lsc10 = g_user,lsc11 = g_today 
    WHERE lsc01 = g_lsc.lsc01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lsc_file",g_lsc.lsc01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_lsc.lsc14 = 'S'
      LET g_lsc.lsc10 = g_user
      LET g_lsc.lsc11 = g_today
      DISPLAY BY NAME g_lsc.lsc14,g_lsc.lsc10,g_lsc.lsc11
      CALL cl_set_field_pic(g_lsc.lsc14,"","","","","")
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION i870_ef()
   IF cl_null(g_lsc.lsc01) THEN 
      CALL cl_err('','-400',0) 
      RETURN 
   END IF
   
   SELECT * INTO g_lsc.* FROM lsc_file
    WHERE lsc01=g_lsc.lsc01
   
   IF g_lsc.lsc14 ='Y' THEN    
      CALL cl_err(g_lsc.lsc01,'alm-005',0)
      RETURN
   END IF
 
    IF g_lsc.lsc14 = 'S' THEN
       CALL cl_err('','alm-934',0)
       RETURN
    END IF
   
   IF g_lsc.lsc14='X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   
   IF g_lsc.lsc13 MATCHES '[Ss1WwRr]' THEN 
      CALL cl_err('','mfg3557',0)
      RETURN
   END IF
  
   IF g_lsc.lsc12='N' THEN 
      CALL cl_err('','mfg3549',0)
      RETURN
   END IF
 
   IF g_success = "N" THEN
      RETURN
   END IF
 
   CALL aws_condition()      
   IF g_success = 'N' THEN
      RETURN
   END IF
 
##########
# CALL aws_efcli2()
 
##########k
 
   IF aws_efcli2(base.TypeInfo.create(g_lsc),'','','','','')
   THEN
       LET g_success = 'Y'
       LET g_lsc.lsc13 = 'S'
       LET g_lsc.lsc12 = 'Y' 
       DISPLAY BY NAME g_lsc.lsc15,g_lsc.lsc16
   ELSE
       LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION i870_lscstore(p_cmd)                                                                                                       
 DEFINE p_cmd     LIKE type_file.chr1                                                                                               
 DEFINE l_rtz13   LIKE rtz_file.rtz13      #FUN-A80148 add                                                                                        
 DEFINE l_azt02   LIKE azt_file.azt02                                                                                               
                                                                                                                                    
   IF p_cmd <> 'u' THEN                                                                                                             
      SELECT rtz13 INTO l_rtz13 FROM rtz_file                                                                                       
       WHERE rtz01 = g_lsc.lscstore                                                                                                 
      SELECT azt02 INTO l_azt02 FROM azt_file                                                                                       
       WHERE azt01 = g_lsc.lsclegal                                                                                                 
      DISPLAY l_rtz13 TO FORMONLY.rtz13                                                                                             
      DISPLAY l_azt02 TO FORMONLY.azt02                                                                                             
   END IF                                                                                                                           
END FUNCTION
#FUNCTION i870_y1()
#   DEFINE l_cmd         VARCHAR(400)
#   DEFINE l_str         VARCHAR(04)
#   DEFINE l_pml         RECORD LIKE pml_file.*
#   DEFINE l_pml04       LIKE pml_file.pml04
#   DEFINE l_imaacti     LIKE ima_file.imaacti
#   DEFINE l_ima140      LIKE ima_file.ima140
#   DEFINE l_pml20       LIKE pml_file.pml20
#
#   IF g_lsc.lsc14='N' AND (g_lsc.lsc15='0' ) THEN
#      LET g_lsc.lsc15='1'
#   END IF
#
#
#   UPDATE lsc_file SET
#          lsc15=g_lsc.lsc15,
#          lsc16='Y',
#          lscstore=g_user,
#          lsc18=g_today
#    WHERE lsc01 = g_lsc.lsc01
#      AND plant_code = g_plant_code
#   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err('upd lsc16',STATUS,1)
#      LET g_success = 'N' RETURN
#   END IF
# 
#END FUNCTION
FUNCTION i870_lsc04_1(p_cmd)
DEFINE p_cmd          LIKE lsc_file.lsc04
DEFINE l_count        LIKE type_file.num5
 
  SELECT COUNT(lsc04) INTO l_count FROM lsc_file
   WHERE  lsc04 = p_cmd
  IF l_count > 0 THEN 
     CALL cl_err('','alm-924',1)
     LET g_success = 'N'
  ELSE
  	 LET g_success = 'Y'
  END IF            
END FUNCTION
#FUN-A60064 10/06/24 By wangxin 非T/S類table中的xxxplant替換成xxxstore 

