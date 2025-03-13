# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almt880.4gl
# Descriptions...: 廣告位合同變更作業
# Date & Author..: FUN-960081 08/08/13 By dxfwo  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0136 09/11/25 by dxfwo 有INFO页签的，在CONSTRUCT的时候要把 oriu和orig两个栏位开放
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30155 10/03/26 By Smapmin 新增時預設上筆資料的功能拿掉
# Modify.........: No:FUN-A60064 10/06/24 By wangxin 非T/S類table中的xxxplant替換成xxxstore 
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No.FUN-A80105 10/08/27 By huangtao 確認時產生費用單開窗
# Modify.........: No:FUN-A80148 10/09/03 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位 
# Modify.........: No.FUN-AC0062 10/12/22 By lixh1 因lua05欄位no use,故mark掉lua05的所有邏輯
# Modify.........: No.TQC-B30101 11/03/11 By baogc 隱藏簽核欄位,簽核狀態欄位,簽核按鈕
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0117 11/12/26 By chenwei  原來產生的2張費用單現合併到一張
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960081 
DEFINE g_lsd                RECORD LIKE lsd_file.*,
       g_lsd_t              RECORD LIKE lsd_file.*,
       g_lsd01_t            LIKE lsd_file.lsd01,
       g_lsd02_t            LIKE lsd_file.lsd02,  
       g_wc                 string,        # 
       g_sql                STRING
 
DEFINE g_forupd_sql         STRING         #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  SMALLINT       #
DEFINE g_chr                VARCHAR(1)
DEFINE g_chr2               VARCHAR(1)
DEFINE g_chr3               VARCHAR(1)
DEFINE g_cnt                INTEGER
DEFINE g_i                  SMALLINT       #count/index for any purpose
DEFINE g_msg                VARCHAR(72)
DEFINE g_curs_index         INTEGER
DEFINE g_row_count          INTEGER        #
DEFINE g_jump               INTEGER        #
DEFINE g_no_ask            SMALLINT       #  
#DEFINE g_t1                 LIKE lrk_file.lrkslip   #FUN-A70130  mark
#DEFINE g_kindtype           LIKE lrk_file.lrkkind   #FUN-A70130  mark
DEFINE g_t1                 LIKE oay_file.oayslip   #FUN-A70130 
DEFINE g_kindtype           LIKE oay_file.oaytype   #FUN-A70130
DEFINE g_lua01_1            LIKE lua_file.lua01          #No.FUN-A80105 
DEFINE g_lua01_2            LIKE lua_file.lua01          #No.FUN-A80105 
DEFINE g_dd                 LIKE lua_file.lua09          #No.FUN-A80105
DEFINE l_flag               LIKE type_file.chr1          #No.FUN-A80105
 
MAIN
 IF FGL_GETENV("FGLGUI")<>"0" THEN
    OPTIONS
        INPUT NO WRAP
 END IF
    DEFER INTERRUPT                            #
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   INITIALIZE g_lsd.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM lsd_file WHERE lsd01 = ? AND lsd02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t880_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW t880_w WITH FORM "alm/42f/almt880"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

##-TQC-B30101 ADD-BEGIN------
   CALL cl_set_comp_visible("lsd12,lsd13",FALSE)
   CALL cl_set_act_visible("ef_approval",FALSE)
##-TQC-B30101 ADD--END-------
 
   LET g_lsd.lsdplant = g_plant
   LET g_action_choice = ""
   CALL t880_menu()
 
   CLOSE WINDOW t880_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t880_curs()
DEFINE ls STRING
DEFINE p_cmd        VARCHAR(1)
 
 
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON                     # 
        lsd01,
        lsdplant,lsdlegal, 
        lsd02,lsd03,lsd04,
        lsd05,lsd06,lsd07,lsd08,
        lsd09,lsd12,lsd13,lsd14,
        lsd15,lsd16,lsd18,lsduser,
        lsdgrup,lsdcrat,lsdmodu,
        lsddate,lsdoriu,lsdorig    #No.FUN-9B0136
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(lsd01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsd01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsd01
                 NEXT FIELD lsd01
              WHEN INFIELD(lsdplant)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_lsdplant"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsdplant
                 NEXT FIELD lsdplant
 
              WHEN INFIELD(lsdlegal)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_lsdlegal"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsdlegal
                 NEXT FIELD lsdlegal
              WHEN INFIELD(lsd03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsd02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsd03
                 NEXT FIELD lsd03
              WHEN INFIELD(lsd04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsd03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsd04
                 NEXT FIELD lsd04                 
 
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
    #    IF g_priv2='4' THEN                           #
    #        LET g_wc = g_wc clipped," AND lsduser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #
    #        LET g_wc = g_wc clipped," AND lsdgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN   
    #        LET g_wc = g_wc clipped," AND lsdgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lsduser', 'lsdgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT lsd01,lsd02 FROM lsd_file ",# 
        " WHERE ",g_wc CLIPPED, 
#       "   AND lsdplant IN ",g_auth CLIPPED,    #dxfwo modify 08/10/27
        " ORDER BY lsd01,lsd02"
    PREPARE t880_prepare FROM g_sql
    DECLARE t880_cs                               # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t880_prepare
    LET g_sql=
#       "SELECT COUNT(*) FROM lsd_file WHERE ",g_wc CLIPPED
        "SELECT COUNT(*) FROM lsd_file ",
        " WHERE ",g_wc CLIPPED
#       "   AND lsdplant IN ",g_auth CLIPPED     #dxfwo modify 08/10/27
    PREPARE t880_precount FROM g_sql
    DECLARE t880_count CURSOR FOR t880_precount
END FUNCTION
 
FUNCTION t880_menu()
 
   DEFINE l_cmd  VARCHAR(100)
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t880_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t880_q()
            END IF
        ON ACTION next
            CALL t880_fetch('N')
        ON ACTION previous
            CALL t880_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
#              IF cl_chk_mach_auth(g_lsd.lsdplant,g_plant) THEN
                 CALL t880_u()
#              END IF   
            END IF
#        ON ACTION invalid
#            LET g_action_choice="invalid"
#            IF cl_chk_act_auth() THEN
#                 CALL t880_x()
#                 CALL t880_field_pic()
#            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
#              IF cl_chk_mach_auth(g_lsd.lsdplant,g_plant) THEN
                 CALL t880_r()
#              END IF   
            END IF
#      ON ACTION reproduce
#           LET g_action_choice="reproduce"
#           IF cl_chk_act_auth() THEN
#              IF cl_chk_mach_auth(g_lsd.lsdplant,g_plant) THEN
#                CALL t880_copy()
#              END IF   
#           END IF
                        
#      ON ACTION output
#           LET g_action_choice="output"
#           IF cl_chk_act_auth()
#              THEN CALL t880_out()
#           END IF
 
        ON ACTION ef_approval         #
            LET g_action_choice="ef_approval"
            IF cl_chk_act_auth() THEN
#             IF cl_chk_mach_auth(g_lsd.lsdplant,g_plant) THEN 
               CALL t880_ef()
#             END IF  
            END IF
 
        ON ACTION confirm 
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
#             IF cl_chk_mach_auth(g_lsd.lsdplant,g_plant) THEN
               CALL t880_y()         
#             END IF  
            END IF
              CALL t880_field_pic()
 
        ON ACTION undo_confirm      
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
#             IF cl_chk_mach_auth(g_lsd.lsdplant,g_plant) THEN 
               CALL t880_unconfirm()
               CALL t880_field_pic()
#             END IF  
            END IF
#
#        ON ACTION termination
#            LET g_action_choice="termination"
#            IF cl_chk_act_auth() THEN
#               CALL t880_termination()
#               CALL t880_field_pic()
#            END IF
 
        ON ACTION volid 
            LET g_action_choice="volid"
            IF cl_chk_act_auth() THEN
#             IF cl_chk_mach_auth(g_lsd.lsdplant,g_plant) THEN
               CALL t880_v()
               CALL t880_field_pic()
#             END IF  
            END IF
 
        ON ACTION change 
            LET g_action_choice="change"
            IF cl_chk_act_auth() THEN
#             IF cl_chk_mach_auth(g_lsd.lsdplant,g_plant) THEN
               CALL t880_change()
#             END IF  
            END IF
 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL t880_fetch('/')
        ON ACTION first
            CALL t880_fetch('F')
        ON ACTION last
            CALL t880_fetch('L')
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
              IF g_lsd.lsd01 IS NOT NULL THEN
                 LET g_doc.column1 = "lsd01"
                 LET g_doc.value1 = g_lsd.lsd01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE t880_cs
END FUNCTION
 
 
FUNCTION t880_a()
   DEFINE    l_n             LIKE type_file.num5
#  DEFINE    l_tqa06         LIKE tqa_file.tqa06
 
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
    CLEAR FORM                                   # ь茤贏戲弇囀□
    INITIALIZE g_lsd.* LIKE lsd_file.*
    INITIALIZE g_lsd_t.* LIKE lsd_file.*
    LET g_lsd01_t = NULL
    LET g_lsd02_t = NULL    
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lsd.lsdlegal = g_legal
        LET g_lsd.lsd07 = g_today
        LET g_lsd.lsd08 = '0'
        LET g_lsd.lsd09 = '0'
        LET g_lsd.lsd12 = 'N'
        LET g_lsd.lsd13 = '0'
        LET g_lsd.lsd14 = 'N'
        LET g_lsd.lsdplant = g_plant
        LET g_lsd.lsd18 = 'N'         
        LET g_lsd.lsduser = g_user
        LET g_lsd.lsdoriu = g_user #FUN-980030
        LET g_lsd.lsdorig = g_grup #FUN-980030
        LET g_lsd.lsdcrat = g_today
        LET g_lsd.lsdgrup = g_grup
        LET g_lsd.lsdplant = g_plant
        LET g_data_plant = g_plant  #No.FUN-A10060
 
         CALL t880_i("a")                         # 
         IF INT_FLAG THEN                         #
             INITIALIZE g_lsd.* TO NULL
             LET g_lsd01_t = NULL
             LET g_lsd02_t = NULL              
             LET INT_FLAG = 0
             CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        
        IF g_lsd.lsd01 IS NULL THEN               #
            CONTINUE WHILE
        END IF
#add by dxfwo---begin--
#       CALL t880_auno1()
#       RETURNING g_lsd.lsd02
#       DISPLAY BY NAME g_lsd.lsd02
#add by dxfwo---end------
        INSERT INTO lsd_file VALUES(g_lsd.*)      # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lsd_file",g_lsd.lsd01,g_lsd.lsd02,SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        ELSE
            SELECT lsd01,lsd02 INTO g_lsd.lsd01,g_lsd.lsd02 FROM lsd_file
                     WHERE lsd01 = g_lsd.lsd01
                       AND lsd02 = g_lsd.lsd02
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t880_i(p_cmd)
   DEFINE   p_cmd        VARCHAR(1),
            l_rtz13   LIKE rtz_file.rtz13,      #FUN-A80148
            l_lmb03   LIKE lmb_file.lmb03,
            l_lmc04   LIKE lmc_file.lmc04,
            l_maxno      VARCHAR(5),
            l_input      VARCHAR(1),
            l_n          SMALLINT
 
 
   DISPLAY BY NAME
      g_lsd.lsdplant,g_lsd.lsdlegal,
      g_lsd.lsd02,g_lsd.lsd03,g_lsd.lsd04,g_lsd.lsd05,
      g_lsd.lsd06,g_lsd.lsd12,g_lsd.lsd13,g_lsd.lsd14,
      g_lsd.lsd15,g_lsd.lsd16,g_lsd.lsd18,g_lsd.lsduser,
      g_lsd.lsdgrup,g_lsd.lsdcrat,g_lsd.lsdmodu,g_lsd.lsddate
 
   CALL t880_lsdplant(p_cmd)
   INPUT BY NAME g_lsd.lsdoriu,g_lsd.lsdorig,
      g_lsd.lsd01,g_lsd.lsd07,g_lsd.lsd08,g_lsd.lsd09
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL t880_set_entry(p_cmd)
          CALL t880_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
      
 
     AFTER FIELD lsd01
         IF g_lsd.lsd01 IS NOT NULL THEN
                SELECT count(*) INTO l_n  FROM lsc_file                                                                             
                  WHERE lsc01= g_lsd.lsd01                                                                                    
                    AND lsc14 = 'Y'                                                                                   
                IF l_n = 0 THEN                                                                                                    
                   CALL cl_err('','alm-938',1)                                                                                      
                   LET g_lsd.lsd01 = g_lsd_t.lsd01                                                                            
                   NEXT FIELD lsc04                                                                                                 
                END IF           
            IF p_cmd = "a" OR
               (p_cmd="u" AND g_lsd.lsd01 != g_lsd01_t)THEN
                 CALL t880_check_lsd01(g_lsd.lsd01)                 
                 CALL t880_lsd01("a")               
                  IF g_success = 'N' THEN                                               
                     LET g_lsd.lsd01 = g_lsd_t.lsd01                                                               
                    DISPLAY BY NAME g_lsd.lsd01                                                                     
                    NEXT FIELD lsd01                                                                                  
                  END IF
            END IF  
         ELSE
            CALL cl_err(g_lsd.lsd01,'alm-055',1)
            NEXT FIELD lsd01  
         END IF
          
      AFTER FIELD lsd08
        IF NOT cl_null(g_lsd.lsd08) THEN
           IF g_lsd.lsd08<0 THEN
             CALL cl_err('','alm-061',0)
             NEXT FIELD lsd08
           END IF
        END IF
        DISPLAY BY NAME g_lsd.lsd08
      
      AFTER FIELD lsd09
        IF NOT cl_null(g_lsd.lsd09) THEN
           IF g_lsd.lsd09<0 THEN
             CALL cl_err('','alm-061',0)
             NEXT FIELD lsd09
           END IF
        END IF
        DISPLAY BY NAME g_lsd.lsd09
 
      AFTER INPUT
         LET g_lsd.lsduser = s_get_data_owner("lsd_file") #FUN-C10039
         LET g_lsd.lsdgrup = s_get_data_group("lsd_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_lsd.lsd01  IS NULL THEN
               DISPLAY BY NAME g_lsd.lsd01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD lsd01
            END IF
 
      #-----MOD-A30155---------
      #ON ACTION CONTROLO                        # 
      #   IF INFIELD(lsd01) THEN
      #      LET g_lsd.* = g_lsd_t.*
      #      CALL t880_show()
      #      NEXT FIELD lsd01
      #   END IF
      #-----END MOD-A30155-----
 
     ON ACTION controlp
        CASE
            WHEN INFIELD(lsd01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lsc05"
                 LET g_qryparam.default1 = g_lsd.lsd01
                 LET g_qryparam.where = " lscstore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_lsd.lsd01
                 DISPLAY BY NAME g_lsd.lsd01
                 CALL t880_lsd01('d')
                 NEXT FIELD lsd01 
           OTHERWISE
              EXIT CASE
           END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 
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
#add by dxfwo--begin--------
#FUNCTION t880_auno1()
#DEFINE p_no      LIKE tc_boo_file.tc_boo04
#DEFINE l_lsd02   LIKE lsd_file.lsd02
#DEFINE p1        VARCHAR(4)
#DEFINE p2        VARCHAR(6)
#DEFINE l_mallno  LIKE azp_file.azp01
#
#  SELECT azp01 INTO l_mallno FROM azp_file WHERE azp03 = g_dbs
#  LET p1 = l_mallno[1,3],'-'
#  SELECT MAX(lsd02) INTO l_lsd02 FROM lsd_file   
#   WHERE SUBSTR(lsd02,1,4) = p1
#  LET p2 = l_lsd02[5,10]
#  IF l_lsd02 IS NULL THEN
#     LET p2 = '000001'
#  ELSE
#     LET p2 = p2+1 USING '&&&&&&'
#  END IF
#  LET p_no = p1,p2
#  RETURN p_no
#
#END FUNCTION
#add by dxfwo--end----------
FUNCTION t880_check_lsd01(p_cmd)
 DEFINE p_cmd    LIKE lsd_file.lsd01
 DEFINE l_count  LIKE type_file.num10
 DEFINE l_lsc02  LIKE lsc_file.lsc02
 DEFINE l_n      LIKE type_file.num5
 SELECT lsc02 INTO l_lsc02 FROM lsc_file 
  WHERE lsc01 = g_lsd.lsd01
  LET l_n = l_lsc02+1
 
 SELECT COUNT(*) INTO l_count FROM lsd_file
  WHERE lsd01 = p_cmd
    AND lsd02 = l_n      
 
 IF l_count > 0 THEN
    CALL cl_err('','alm-756',1)
    DISPLAY '' TO lsd01 
    LET g_success = 'N'
 ELSE
 	  LET g_success = 'Y'
 	  LET g_lsd.lsd02 = l_n
 	  DISPLAY BY NAME g_lsd.lsd02   
 END IF 
 
END FUNCTION
 
FUNCTION t880_lsd01(p_cmd)
DEFINE
   p_cmd        VARCHAR(01),
   l_lsc01      LIKE lsc_file.lsc01,
   l_lsc02      LIKE lsc_file.lsc02,
   l_lsc03      LIKE lsc_file.lsc03,
   l_lsc04      LIKE lsc_file.lsc04,
   l_lsc05      LIKE lsc_file.lsc05,
   l_lsc06      LIKE lsc_file.lsc06,
   l_lsc07      LIKE lsc_file.lsc07,
   l_lsc08      LIKE lsc_file.lsc08,
   l_lsc09      LIKE lsc_file.lsc09,   
   l_lsc14      LIKE lsc_file.lsc14,
   l_lscstore      LIKE lsc_file.lscstore,      
   l_lne01      LIKE lne_file.lne01,
   l_lne05      LIKE lne_file.lne05,
   l_lne14      LIKE lne_file.lne14,
   l_lne47      LIKE lne_file.lne47,
   l_lne15      LIKE lne_file.lne15,
   l_lne36      LIKE lne_file.lne36,
   l_lsbstore      LIKE lsb_file.lsbstore,
   l_lsb03      LIKE lsb_file.lsb03,
   l_lsb04      LIKE lsb_file.lsb04,
   l_lsb05      LIKE lsb_file.lsb05,
   l_lsb06      LIKE lsb_file.lsb06,
   l_lsb07      LIKE lsb_file.lsb07,
   l_lsb08      LIKE lsb_file.lsb08,
   l_lsb16      LIKE lsb_file.lsb16,
   l_lmb03      LIKE lmb_file.lmb03,
   l_lmc04      LIKE lmc_file.lmc04,
   l_gec02      LIKE gec_file.gec02,
   l_gec04      LIKE gec_file.gec04,
   l_gec07      LIKE gec_file.gec07,
   l_gecacti    LIKE gec_file.gecacti       
 
 
   LET g_errno=''
   
   SELECT lsc03,lsc04,lsc05,lsc06,lsc07,lsc08,lsc09,lscstore
     INTO g_lsd.lsd03,g_lsd.lsd04,g_lsd.lsd05,g_lsd.lsd06,g_lsd.lsd07,
          g_lsd.lsd08,g_lsd.lsd09,l_lscstore
     FROM lsc_file
    WHERE lsc01=g_lsd.lsd01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-976'
                                LET g_lsd.lsd03=NULL
       WHEN l_lscstore <> g_lsd.lsdplant   LET g_errno = 'alm-376'                         
                                
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE    
 
   SELECT lne01,lne05,lne14,lne47,lne15,lne36,lne40
     INTO l_lne01,l_lne05,l_lne14,l_lne47,l_lne15,l_lne36,g_lsd.lsd19
     FROM lne_file
    WHERE lne01=g_lsd.lsd03
      AND lne36= 'Y'  
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-921'
                                LET l_lne01=NULL
       WHEN l_lne36='N'         LET g_errno='alm-002'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   SELECT lsbstore,lsb03,lsb04,lsb05,lsb06,lsb07,lsb08,lsb16
     INTO l_lsbstore,l_lsb03,l_lsb04,l_lsb05,l_lsb06,l_lsb07,l_lsb08,l_lsb16
     FROM lsb_file
    WHERE lsb01=g_lsd.lsd04 
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
       WHEN l_lsb16='N'         LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE   
   
   IF p_cmd='d' OR cl_null(g_errno)THEN 
      DISPLAY BY NAME g_lsd.lsd03
      DISPLAY BY NAME g_lsd.lsd04
      DISPLAY BY NAME g_lsd.lsd05
      DISPLAY BY NAME g_lsd.lsd06
      DISPLAY BY NAME g_lsd.lsd07
      DISPLAY BY NAME g_lsd.lsd08
      DISPLAY BY NAME g_lsd.lsd09
      DISPLAY BY NAME g_lsd.lsd19
      DISPLAY l_lsb03 TO FORMONLY.lsb03
      DISPLAY l_lsb04 TO FORMONLY.lsb04
      DISPLAY l_lsb05 TO FORMONLY.lsb05
      DISPLAY l_lsb06 TO FORMONLY.lsb06
      DISPLAY l_lsb07 TO FORMONLY.lsb07
      DISPLAY l_lsb08 TO FORMONLY.lsb08
      DISPLAY l_lmb03 TO FORMONLY.lmb03
      DISPLAY l_lmc04 TO FORMONLY.lmc04
      DISPLAY l_lne05 TO FORMONLY.lne05
      DISPLAY l_lne14 TO FORMONLY.lne14
      DISPLAY l_lne47 TO FORMONLY.lne47
      DISPLAY l_lne15 TO FORMONLY.lne15
   END IF
   
   LET g_errno=''
   SELECT gec02,gec04,gec07
     INTO l_gec02,l_gec04,l_gec07
     FROM gec_file
    WHERE gec01=g_lsd.lsd19
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-921'
                                LET l_gec02=NULL
       WHEN l_gecacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      LET g_lsd.lsd20 = l_gec04
      LET g_lsd.lsd21 = l_gec07
      DISPLAY BY NAME g_lsd.lsd20
      DISPLAY BY NAME g_lsd.lsd21
      DISPLAY l_gec02 TO FORMONLY.gec02
   END IF    
END FUNCTION
 
FUNCTION t880_lsd01_1(p_cmd)
DEFINE
   p_cmd        VARCHAR(01),
   l_lsc01      LIKE lsc_file.lsc01,
   l_lsc02      LIKE lsc_file.lsc02,
   l_lsc03      LIKE lsc_file.lsc03,
   l_lsc04      LIKE lsc_file.lsc04,
   l_lsc05      LIKE lsc_file.lsc05,
   l_lsc06      LIKE lsc_file.lsc06,
   l_lsc07      LIKE lsc_file.lsc07,
   l_lsc08      LIKE lsc_file.lsc08,
   l_lsc09      LIKE lsc_file.lsc09,   
   l_lsc14      LIKE lsc_file.lsc14,
   l_lscstore      LIKE lsc_file.lscstore,      
   l_lne01      LIKE lne_file.lne01,
   l_lne05      LIKE lne_file.lne05,
   l_lne14      LIKE lne_file.lne14,
   l_lne47      LIKE lne_file.lne47,
   l_lne15      LIKE lne_file.lne15,
   l_lne36      LIKE lne_file.lne36,
   l_lsbstore      LIKE lsb_file.lsbstore,
   l_lsb03      LIKE lsb_file.lsb03,
   l_lsb04      LIKE lsb_file.lsb04,
   l_lsb05      LIKE lsb_file.lsb05,
   l_lsb06      LIKE lsb_file.lsb06,
   l_lsb07      LIKE lsb_file.lsb07,
   l_lsb08      LIKE lsb_file.lsb08,
   l_lsb16      LIKE lsb_file.lsb16,
   l_lmb03      LIKE lmb_file.lmb03,
   l_lmc04      LIKE lmc_file.lmc04,
   l_gec02      LIKE gec_file.gec02,
   l_gec04      LIKE gec_file.gec04,
   l_gec07      LIKE gec_file.gec07,
   l_gecacti    LIKE gec_file.gecacti       
 
 
   LET g_errno=''
   
#  SELECT lsc03,lsc04,lsc05,lsc06,lsc07,lsc08,lsc09,lscstore,lsc18,lsc19,lsc20
#    INTO g_lsd.lsd03,g_lsd.lsd04,g_lsd.lsd05,g_lsd.lsd06,g_lsd.lsd07,
#         g_lsd.lsd08,g_lsd.lsd09,l_lscstore,g_lsd.lsd19,g_lsd.lsd20,g_lsd.lsd21
#    FROM lsc_file
#   WHERE lsc01=g_lsd.lsd01
#  CASE
#      WHEN SQLCA.sqlcode=100   LET g_errno='alm-976'
#                               LET g_lsd.lsd03=NULL
#      WHEN l_lscstore <> g_lsd.lsdplant   LET g_errno = 'alm-376'                         
#                               
#      OTHERWISE
#           LET g_errno=SQLCA.sqlcode USING '------'
#  END CASE    
 
   SELECT lne01,lne05,lne14,lne47,lne15,lne36
     INTO l_lne01,l_lne05,l_lne14,l_lne47,l_lne15,l_lne36
     FROM lne_file
    WHERE lne01=g_lsd.lsd03
      AND lne36= 'Y'  
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-921'
                                LET l_lne01=NULL
       WHEN l_lne36='N'         LET g_errno='alm-002'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   SELECT lsbstore,lsb03,lsb04,lsb05,lsb06,lsb07,lsb08,lsb16
     INTO l_lsbstore,l_lsb03,l_lsb04,l_lsb05,l_lsb06,l_lsb07,l_lsb08,l_lsb16
     FROM lsb_file
    WHERE lsb01=g_lsd.lsd04 
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
       WHEN l_lsb16='N'         LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE   
   
   IF p_cmd='d' OR cl_null(g_errno)THEN 
      DISPLAY BY NAME g_lsd.lsd03
      DISPLAY BY NAME g_lsd.lsd04
      DISPLAY BY NAME g_lsd.lsd05
      DISPLAY BY NAME g_lsd.lsd06
      DISPLAY BY NAME g_lsd.lsd07
      DISPLAY BY NAME g_lsd.lsd08
      DISPLAY BY NAME g_lsd.lsd09
      DISPLAY BY NAME g_lsd.lsd19
      DISPLAY BY NAME g_lsd.lsd20
      DISPLAY BY NAME g_lsd.lsd21
      DISPLAY l_lsb03 TO FORMONLY.lsb03
      DISPLAY l_lsb04 TO FORMONLY.lsb04
      DISPLAY l_lsb05 TO FORMONLY.lsb05
      DISPLAY l_lsb06 TO FORMONLY.lsb06
      DISPLAY l_lsb07 TO FORMONLY.lsb07
      DISPLAY l_lsb08 TO FORMONLY.lsb08
      DISPLAY l_lmb03 TO FORMONLY.lmb03
      DISPLAY l_lmc04 TO FORMONLY.lmc04
      DISPLAY l_lne05 TO FORMONLY.lne05
      DISPLAY l_lne14 TO FORMONLY.lne14
      DISPLAY l_lne47 TO FORMONLY.lne47
      DISPLAY l_lne15 TO FORMONLY.lne15
   END IF
   
   LET g_errno=''
   SELECT gec02,gec04,gec07
     INTO l_gec02,l_gec04,l_gec07
     FROM gec_file
    WHERE gec01=g_lsd.lsd19
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-921'
                                LET l_gec02=NULL
       WHEN l_gecacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      LET g_lsd.lsd20 = l_gec04
      LET g_lsd.lsd21 = l_gec07
      DISPLAY BY NAME g_lsd.lsd20
      DISPLAY BY NAME g_lsd.lsd21
      DISPLAY l_gec02 TO FORMONLY.gec02
   END IF    
END FUNCTION
 
FUNCTION t880_q()
##CKP
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lsd.* TO NULL 
    MESSAGE ""
    CALL cl_msg("")
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t880_curs()                      #SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t880_count
    FETCH t880_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t880_cs                          # 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lsd.lsd01,SQLCA.sqlcode,0)
        INITIALIZE g_lsd.* TO NULL
    ELSE
        CALL t880_fetch('F')              # 
    END IF
END FUNCTION
 
FUNCTION t880_fetch(p_flag)
    DEFINE
        p_flag          VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t880_cs INTO g_lsd.lsd01,g_lsd.lsd02
        WHEN 'P' FETCH PREVIOUS t880_cs INTO g_lsd.lsd01,g_lsd.lsd02
        WHEN 'F' FETCH FIRST    t880_cs INTO g_lsd.lsd01,g_lsd.lsd02
        WHEN 'L' FETCH LAST     t880_cs INTO g_lsd.lsd01,g_lsd.lsd02
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
            FETCH ABSOLUTE g_jump t880_cs INTO g_lsd.lsd01,g_lsd.lsd02
            LET g_no_ask = FALSE      
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lsd.lsd01,SQLCA.sqlcode,0)
        INITIALIZE g_lsd.* TO NULL
        LET g_lsd.lsd01 = NULL 
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
 
    SELECT * INTO g_lsd.* FROM lsd_file    #
       WHERE lsd01 = g_lsd.lsd01
         AND lsd02 = g_lsd.lsd02
       
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lsd_file",g_lsd.lsd01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_lsd.lsduser
        LET g_data_group=g_lsd.lsdgrup
        LET g_data_plant = g_lsd.lsdplant  #No.FUn-A10060
        CALL t880_show()                   #
    END IF
END FUNCTION
 
FUNCTION t880_show()
DEFINE l_gen02 LIKE gen_file.gen02
    DISPLAY BY NAME g_lsd.lsdplant,g_lsd.lsdlegal,g_lsd.lsd01,g_lsd.lsd02,g_lsd.lsd03,g_lsd.lsd04,g_lsd.lsd05, g_lsd.lsdoriu,g_lsd.lsdorig,
                    g_lsd.lsd06,g_lsd.lsd07,g_lsd.lsd08,g_lsd.lsd09,g_lsd.lsd12,
                    g_lsd.lsd13,g_lsd.lsd14,g_lsd.lsd15,g_lsd.lsd16,g_lsd.lsd18,
                    g_lsd.lsd19,g_lsd.lsd20,g_lsd.lsd21,
                    g_lsd.lsduser,g_lsd.lsdgrup,g_lsd.lsdcrat,g_lsd.lsdmodu,g_lsd.lsddate
 
    CALL t880_lsdplant('d')
    CALL t880_lsd01_1('d')
    CALL t880_field_pic()
    CALL cl_show_fld_cont()              
END FUNCTION
 
FUNCTION t880_u()
    IF g_lsd.lsd01  IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_lsd.* FROM lsd_file 
     WHERE lsd01=g_lsd.lsd01
       AND lsd02=g_lsd.lsd02
       
    IF g_lsd.lsd14 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF 
 
    IF g_lsd.lsd14 = 'S' THEN
       CALL cl_err('','alm-929',0)
       RETURN
    END IF
 
   IF g_lsd.lsd18 = 'Y' THEN
      CALL cl_err('','alm-941',0)
      RETURN
   END IF
 
   IF g_lsd.lsd14='X' THEN             
      CALL cl_err(g_lsd.lsd01,'alm-134',1)
      RETURN
   END IF       
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN t880_cl USING g_lsd.lsd01,g_lsd.lsd02
    IF STATUS THEN
       CALL cl_err("OPEN t880_cl:", STATUS, 1)
       CLOSE t880_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t880_cl INTO g_lsd.*         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsd.lsd01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_lsd01_t = g_lsd.lsd01
    LET g_lsd02_t = g_lsd.lsd02
    LET g_lsd_t.*=g_lsd.*  
    LET g_lsd.lsdmodu=g_user                  #
    LET g_lsd.lsddate = g_today               #
    IF g_lsd.lsd13 MATCHES '[Ss11WwRr]' THEN 
       LET g_lsd.lsd13 = '0'
    END IF    
    CALL t880_show()                          #
    WHILE TRUE
        CALL t880_i("u")                      #
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_lsd.*=g_lsd_t.*       
            CALL t880_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF 
         IF g_lsd.* != g_lsd_t.* THEN 
        UPDATE lsd_file SET lsd_file.* = g_lsd.*    #DB
            WHERE lsd01 = g_lsd01_t
              AND lsd02 = g_lsd02_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lsd_file",g_lsd.lsd01,"",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
        END IF
        END IF 
        EXIT WHILE
    END WHILE
    CLOSE t880_cl
    COMMIT WORK
END FUNCTION
 
#FUNCTION t880_x()
#    IF g_lsd.lsd01 IS NULL THEN
#        CALL cl_err('',-400,0)
#        RETURN
#    END IF
#    IF g_lsd.lsd14 = 'Y' THEN
#       CALL cl_err('','9023',0)
#       RETURN
#    END IF  
#    
#    IF g_lsd.lsd14 = 'S' THEN
#       CALL cl_err('','alm-931',0)
#       RETURN
#    END IF    
#    
#    IF g_lsd.lsd14 = 'X' THEN 
#       CALL cl_err(g_lsd.lsd01,'alm-134',1)
#       RETURN 
#    END IF  
#    IF g_lsd.lsd13 MATCHES '[Ss11WwRr]' THEN 
#       CALL cl_err('','mfg3557',0)
#       RETURN
#    END IF       
#
#   IF g_lsd.lsd18 = 'Y' THEN
#      CALL cl_err('','alm-955',0)
#      RETURN
#   END IF
#
#    BEGIN WORK
#
#    OPEN t880_cl USING g_lsd_rowid
#    IF STATUS THEN
#       CALL cl_err("OPEN t880_cl:", STATUS, 1)
#       CLOSE t880_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    FETCH t880_cl INTO g_lsd.*
#    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_lsd.lsd01,SQLCA.sqlcode,1)
#       RETURN
#    END IF
#    CALL t880_show()
#    IF cl_exp(0,0,g_lsd.lsdacti) THEN
#        LET g_chr=g_lsd.lsdacti
#        IF g_lsd.lsdacti='Y' THEN
#            LET g_lsd.lsdacti='N'
#        ELSE
#            LET g_lsd.lsdacti='Y'
#        END IF
#        UPDATE lsd_file
#           SET lsdacti=g_lsd.lsdacti,
#               lsdmodu=g_user,
#               lsddate=g_today
#            WHERE ROWID=g_lsd_rowid
#        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_lsd.lsd01,SQLCA.sqlcode,0)
#            LET g_lsd.lsdacti=g_chr
#        ELSE
#           LET g_lsd.lsdmodu=g_user
#           LET g_lsd.lsddate=g_today
#           DISPLAY BY NAME g_lsd.lsdacti,g_lsd.lsdmodu,g_lsd.lsddate            
#        END IF
#    END IF
#    CLOSE t880_cl
#    COMMIT WORK
#END FUNCTION
 
FUNCTION t880_r()
    IF g_lsd.lsd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lsd.lsd14 = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END IF  
    IF g_lsd.lsd14 = 'X' THEN 
       CALL cl_err(g_lsd.lsd01,'alm-134',1)
       RETURN 
    END IF   
    
    IF g_lsd.lsd14 = 'S' THEN
       CALL cl_err('','alm-932',0)
       RETURN
    END IF
    
    IF g_lsd.lsd13 MATCHES '[Ss11WwRr]' THEN 
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF  
#    IF g_lsd.lsdacti = 'N' THEN
#       CALL cl_err('','alm-147',0)
#       RETURN
#    END IF
 
   IF g_lsd.lsd18 = 'Y' THEN
      CALL cl_err('','alm-945',0)
      RETURN
   END IF
       
    BEGIN WORK
 
    OPEN t880_cl USING g_lsd.lsd01,g_lsd.lsd02
    IF STATUS THEN
       CALL cl_err("OPEN t880_cl:", STATUS, 0)
       CLOSE t880_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t880_cl INTO g_lsd.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsd.lsd01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t880_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lsd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lsd.lsd01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lsd_file WHERE lsd01 = g_lsd.lsd01
                              AND lsd02 = g_lsd.lsd02   #MOD-A30155
       CLEAR FORM
       OPEN t880_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t880_cs
          CLOSE t880_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t880_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t880_cs
          CLOSE t880_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t880_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t880_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE        
          CALL t880_fetch('/')
       END IF
    END IF
    CLOSE t880_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t880_copy()
    DEFINE
        l_newno1         LIKE lsd_file.lsd01,
        l_oldno1         LIKE lsd_file.lsd01,
        p_cmd            VARCHAR(1),
        l_n              SMALLINT,
        l_input          VARCHAR(1)
 
    IF g_lsd.lsd01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL t880_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno1 FROM lsd01
 
        AFTER FIELD lsd01
         IF l_newno1 IS NOT NULL THEN
             CALL t880_check_lsd01(l_newno1)
             IF g_success = 'N' THEN                                                                                                
                  LET g_lsd.lsd01 = g_lsd_t.lsd01                                                                                     
                  DISPLAY BY NAME g_lsd.lsd01                                                                                         
                  NEXT FIELD lsd01                                                                                                    
              END IF  
         ELSE 
          	 CALL cl_err(l_newno1,'alm-055',1)
          	 NEXT FIELD lsd01    
         END IF
 
 
        ON ACTION controlp                        #
 
#add by dxfwo--begin-----------
#      	CALL t880_auno1()
#       RETURNING l_newno2
#       DISPLAY l_newno2 TO lsd02
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
        DISPLAY BY NAME g_lsd.lsd01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM lsd_file
        WHERE lsd01=g_lsd.lsd01
          AND lsd02=g_lsd.lsd02
        INTO TEMP x
    UPDATE x
        SET lsd01=l_newno1,    #
#            lsdacti='Y',      #
            lsd10='',
            lsd11='',
            lsd14='N',
            lsd13='0',
            lsd15='',
            lsd16='',
            lsduser=g_user,   #
            lsdgrup=g_grup,   #
            lsdmodu=NULL,     
            lsddate=NULL,     #□ぶ
            lsdcrat=g_today   #
    INSERT INTO lsd_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","lsd_file",g_lsd.lsd01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K'
        LET l_oldno1 = g_lsd.lsd01
        LET g_lsd.lsd01 = l_newno1
        SELECT lsd_file.* INTO g_lsd.* FROM lsd_file
               WHERE lsd01 = l_newno1 
                 AND  lsd02 = g_lsd.lsd02 
        CALL t880_u()
        UPDATE lsd_file SET lsddate=NULL,lsdmodu = NULL
                      WHERE lsd01 = l_newno1      
                       AND  lsd02 = g_lsd.lsd02 
        #SELECT  lsd_file.* INTO g_lsd.* FROM lsd_file #FUN-C30027
        #       WHERE lsd01 = l_oldno1                 #FUN-C30027
        #         AND lsd02 = g_lsd.lsd02              #FUN-C30027
    END IF
    #LET g_lsd.lsd01 = l_oldno1                        #FUN-C30027
    CALL t880_show()
END FUNCTION
 
#FUNCTION t880_out()
#    DEFINE
#        l_i             SMALLINT,
#        l_lsd           RECORD LIKE lsd_file.*,
#        l_gen           RECORD LIKE gen_file.*,
#        l_name          VARCHAR(20),           # External(Disk) file name
#        sr RECORD
#           lsd01 LIKE lsd_file.lsd01,
#           lsd02 LIKE lsd_file.lsd02,
#           lsd06 LIKE lsd_file.lsd06,
#           gen02 LIKE gen_file.gen02,
#           gen03 LIKE gen_file.gen03,
#           gen04 LIKE gen_file.gen04,
#           gem02 LIKE gem_file.gem02
#           END RECORD,
#        l_za05          VARCHAR(40)
#
#    #BugNO:4137
#    IF g_wc IS NULL THEN LET g_wc=" lsd01='",g_lsd.lsd01,"'" END IF
#    #蜊傖荂絞狟腔饒珨捩訧蹋囀□
#
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT lsd01,lsd02,lsd06,gen02,gen03,gen04,gem02 ",
#              " FROM lsd_file, OUTER(gen_file, OUTER(gem_file)) ",
#              " WHERE gen_file.gen01= lsd01 AND gem_file.gem01 = gen_file.gen03 ",
#              "   AND ",g_wc CLIPPED
#    
##   IF cl_null(g_wc) THEN
##       LET g_sql = g_sql CLIPPED," lsd01='",g_lsd.lsd01,"'"
##   ELSE
##       LET g_sql = g_sql CLIPPED, " AND ",g_wc CLIPPED
##   END IF
#   
#
#    PREPARE t880_p1 FROM g_sql                # RUNTIME 
#    DECLARE t880_curo                         # SCROLL CURSOR
#         CURSOR FOR t880_p1
#
#    CALL cl_outnam('aoot880') RETURNING l_name
#    START REPORT t880_rep TO l_name
#
#    FOREACH t880_curo INTO sr.*
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT t880_rep(sr.*)
#    END FOREACH
#
#    FINISH REPORT t880_rep
#
#    CLOSE t880_curo
#    ERROR ""
#    #CALL cl_prt(l_name,'g_prtway','g_copies',g_len)
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#END FUNCTION
#
#REPORT t880_rep(sr)
#    DEFINE
#        l_trailer_sw    VARCHAR(1),
#        sr RECORD
#           lsd01 LIKE lsd_file.lsd01,
#           lsd02 LIKE lsd_file.lsd02,
#           lsd06 LIKE lsd_file.lsd06,
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
#    ORDER BY sr.lsd01
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
#            PRINT COLUMN g_c[31],sr.lsd01,
#                  COLUMN g_c[32],sr.gen02,
#                  COLUMN g_c[33],sr.gen03,
#                  COLUMN g_c[34],sr.gen04,
#                  COLUMN g_c[35],cl_numfor(sr.lsd06,35,g_azi04)
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
 
 
FUNCTION t880_set_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lsd01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t880_set_no_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("lsd01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t880_auto_code()
   DEFINE l_lua01 LIKE lua_file.lua01
   DEFINE l_date  LIKE lua_file.luacrat
  #SELECT max(SUBSTR(lua01,10))+1 INTO l_lua01 FROM lua_file
   SELECT max(lua01[10,20])+1 INTO l_lua01 FROM lua_file      #FUN-B40029
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
 
FUNCTION t880_y()
    DEFINE l_newno    LIKE lua_file.lua01
    DEFINE l_msg      LIKE type_file.chr50
               
   IF g_lsd.lsd01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
#   IF g_lsd.lsdacti = 'N' THEN
#      CALL cl_err('','9028',0)      
#      RETURN
#   END IF
   
   IF g_lsd.lsd14 = 'S' THEN
      CALL cl_err('','alm-933',0)
      RETURN
   END IF   
   
   IF g_lsd.lsd14 ='Y' THEN
      CALL cl_err('','9023',0)      
      RETURN
   END IF
   IF g_lsd.lsd14 ='X' THEN
      CALL cl_err('','axr-103',0)      
      RETURN
   END IF
   IF g_lsd.lsd12 = 'Y'AND (cl_null(g_lsd.lsd13) OR  g_lsd.lsd13  ! = '1') THEN
      CALL cl_err('','alm-029',0)  
      RETURN
   END IF   
 
   IF g_lsd.lsd18 = 'Y' THEN
      CALL cl_err('','alm-942',0)
      RETURN
   END IF
 
#    IF NOT cl_null(g_lsd.lsd15) THEN
#    LET g_lsd.lsd15 = '1'
#    LET g_lsd.lsd14 = 'Y' 
#    DISPLAY BY NAME g_lsd.lsd14,g_lsd.lsd15
#    END IF 
   IF NOT cl_confirm('alm-006') THEN 
        RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t880_cl USING g_lsd.lsd01,g_lsd.lsd02
   IF STATUS THEN
       CALL cl_err("OPEN t880_cl:", STATUS, 1)
       CLOSE t880_cl
       ROLLBACK WORK
       RETURN
    END IF
    
    FETCH t880_cl INTO g_lsd.*               # DB
     IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsd.lsd01,SQLCA.sqlcode,0)      
       CLOSE t880_cl
       ROLLBACK WORK
       RETURN
     END IF    
    
#   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01= g_lsd.lsd16
    UPDATE lsd_file SET lsd14 = 'Y',
                        lsd15 = g_user, 
                        lsd16 = g_today  
                  WHERE lsd01 = g_lsd.lsd01
                    AND lsd02 = g_lsd.lsd02
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","lsd_file",g_lsd.lsd01,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N' 
   ELSE 
      LET g_lsd.lsd14 = 'Y'
      LET g_lsd.lsd15 = g_user
      LET g_lsd.lsd16 = g_today
      DISPLAY BY NAME g_lsd.lsd14,g_lsd.lsd15,g_lsd.lsd16
      CALL cl_set_field_pic(g_lsd.lsd14,"","","","","")                                                                       
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t880_v()
   IF g_lsd.lsd01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lsd.lsd14 ='Y' THEN
      CALL cl_err('','9023',0)      
      RETURN
   END IF
   
    IF g_lsd.lsd14 = 'S' THEN
       CALL cl_err('','alm-930',0)
       RETURN
    END IF
   
#   IF g_lsd.lsdacti = 'N' THEN
#      CALL cl_err('','9028',0)      
#      RETURN
#   END IF
   IF g_lsd.lsd13 MATCHES '[Ss11WwRr]' THEN 
      CALL cl_err('','mfg3557',0)
      RETURN
   END IF    
 
   BEGIN WORK
 
   OPEN t880_cl USING g_lsd.lsd01,g_lsd.lsd02
   IF STATUS THEN
       CALL cl_err("OPEN t880_cl:", STATUS, 1)
       CLOSE t880_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t880_cl INTO g_lsd.*               # DB
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsd.lsd01,SQLCA.sqlcode,0)
       CLOSE t880_cl
       ROLLBACK WORK
       RETURN
    END IF    
    
    IF g_lsd.lsd14 != 'X' THEN
       IF NOT cl_confirm('alm-085') THEN RETURN END IF
       LET g_lsd.lsd14 = 'X'
#       CALL cl_set_field_pic("","","","","Y",g_lsd.lsdacti)
    ELSE
       IF g_lsd.lsd14 = 'X' THEN
          IF NOT cl_confirm('alm-086') THEN RETURN END IF
          LET g_lsd.lsd14 = 'N'
          
 #         CALL cl_set_field_pic("","","","","N",g_lsd.lsdacti)
       END IF
    END IF
    UPDATE lsd_file SET lsd14 = g_lsd.lsd14,
                        lsd13 = g_lsd.lsd13,
                        lsdmodu=g_user,
                        lsddate=g_today                    
                  WHERE lsd01 = g_lsd.lsd01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","lsd_file",g_lsd.lsd01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
       ROLLBACK WORK
       RETURN
    END IF
    CLOSE t880_cl
    COMMIT WORK
   SELECT lsd13,lsdmodu,lsddate
   INTO g_lsd.lsd13,g_lsd.lsdmodu,g_lsd.lsddate FROM lsd_file
    WHERE lsd01=g_lsd.lsd01 
      AND lsd02=g_lsd.lsd02
    DISPLAY BY NAME g_lsd.lsd13,g_lsd.lsd14,g_lsd.lsdmodu,g_lsd.lsddate
END FUNCTION
 
FUNCTION t880_field_pic()
   DEFINE l_flag   VARCHAR(01)
 
   CASE
     #拸虴
#     WHEN g_lsd.lsdacti = 'N' 
#        CALL cl_set_field_pic("","","","","","N")
     #機瞄
     WHEN g_lsd.lsd14 = 'Y' 
        CALL cl_set_field_pic("Y","","","","","")
     #釬煙
     WHEN g_lsd.lsd14 = 'X' 
        CALL cl_set_field_pic("","","","","Y","")
     OTHERWISE
        CALL cl_set_field_pic("","","","","","")
   END CASE
END FUNCTION
 
FUNCTION t880_y_chk()
DEFINE l_str         VARCHAR(04)
 
   LET g_success = 'Y'
   IF g_lsd.lsd01 IS NULL  THEN RETURN END IF
    SELECT * INTO g_lsd.* FROM lsd_file 
     WHERE lsd01=g_lsd.lsd01
       AND lsd02=g_lsd.lsd02
   IF g_lsd.lsd14='Y' THEN                    #
       CALL cl_err('','9023',0)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_lsd.lsd14='X' THEN                    #
        CALL cl_err('','9024',0)
        LET g_success = 'N'
        RETURN
   END IF
END FUNCTION
 
#FUNCTION t880_y_upd()
#DEFINE l_gen02   LIKE gen_file.gen02
#   LET g_success = 'Y'
#
#   IF g_action_choice CLIPPED = "confirm" OR #
#      g_action_choice CLIPPED = "insert"     
#   THEN 
#      IF g_lsd.lsd14='Y' THEN            #
#         IF g_lsd.lsd15 != '1' THEN
#            CALL cl_err('','aws-078',1)
#            LET g_success = 'N'
#            RETURN
#         END IF
#      END IF
#      IF NOT cl_confirm('axm-108') THEN RETURN END IF  #
#   END IF
#
#   BEGIN WORK
#
#   OPEN t880_cl USING g_lsd_rowid
#   IF STATUS THEN
#      LET g_success = 'N'
#      CALL cl_err("OPEN t880_cl:", STATUS, 1)
#      CLOSE t880_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#   FETCH t880_cl INTO g_lsd.*               #
#   IF SQLCA.sqlcode THEN
#      LET g_success = 'N'
#      CALL cl_err(g_lsd.lsd01,SQLCA.sqlcode,0)
#      CLOSE t880_cl
#      ROLLBACK WORK
#      RETURN
#   END IF 
#
##  CALL t880_y1()
#      IF g_success='Y' THEN
#         LET g_lsd.lsd15='1'              #
#         LET g_lsd.lsd14='Y'              #
#         LET g_lsd.lsd16='Y'
#         LET g_lsd.lsdplant=g_user
#         LET g_lsd.lsd18=g_today
##  SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01= g_lsd.lsd16 
##  DISPLAY l_gen02 TO FORMONLY.aa
#         COMMIT WORK
##        CALL cl_flow_notify(g_lsd.lsd04,'Y')
#         DISPLAY BY NAME g_lsd.lsd14
#         DISPLAY BY NAME g_lsd.lsd15
#         DISPLAY BY NAME g_lsd.lsd16
#         DISPLAY BY NAME g_lsd.lsdplant
#         DISPLAY BY NAME g_lsd.lsd18
#      ELSE
#         LET g_lsd.lsd16='N'
#         LET g_success = 'N'
#         ROLLBACK WORK
#      END IF
#   
#   SELECT * INTO g_lsd.* FROM lsd_file WHERE lsd04 = g_lsd.lsd04
#   IF g_lsd.lsd16='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#   IF g_lsd.lsd15='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
#   CALL cl_set_field_pic(g_lsd.lsd16,g_chr2,"",g_chr3,g_chr,"")
#END FUNCTION
 
FUNCTION t880_unconfirm()
DEFINE l_n LIKE type_file.num5
   
    IF cl_null(g_lsd.lsd01) THEN 
      CALL cl_err('','-400',0) 
      RETURN 
   END IF
   
#   IF g_lsd.lsdacti='N' THEN
#      CALL cl_err('','alm-049',0)
#      RETURN
#   END IF
 
   IF g_lsd.lsd02='0' THEN 
      CALL cl_err('','alm-957',0)
      RETURN
   END IF 
   
   IF g_lsd.lsd14='N' THEN 
      CALL cl_err('','9025',0)
      RETURN
   END IF
 
   IF g_lsd.lsd14 ='X' THEN
      CALL cl_err('','axr-103',0)      
      RETURN
   END IF
 
   IF g_lsd.lsd18 = 'Y' THEN
      CALL cl_err('','alm-943',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('alm-008') THEN 
      RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t880_cl USING g_lsd.lsd01,g_lsd.lsd02
   IF STATUS THEN
      CALL cl_err("OPEN t880_cl:", STATUS, 1)
      CLOSE t880_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t880_cl INTO g_lsd.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lsd.lsd01,SQLCA.sqlcode,0)      
      CLOSE t880_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE lsd_file SET lsd14 = 'N',lsd15 = '',lsd16 = '' 
    WHERE lsd01 = g_lsd.lsd01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lsd_file",g_lsd.lsd01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_lsd.lsd14 = 'N'
      LET g_lsd.lsd15 = ''
      LET g_lsd.lsd16 = ''
      LET g_lsd.lsdmodu = g_user
      LET g_lsd.lsddate = g_today      
      DISPLAY BY NAME g_lsd.lsd14,g_lsd.lsd15,g_lsd.lsd16,g_lsd.lsdmodu,g_lsd.lsddate
      CALL cl_set_field_pic(g_lsd.lsd14,"","","","","")
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t880_termination()
DEFINE l_n LIKE type_file.num5
   
    IF cl_null(g_lsd.lsd01) THEN 
      CALL cl_err('','-400',0) 
      RETURN 
   END IF
   
#  IF g_lsd.lsdacti='N' THEN
#     CALL cl_err('','alm-049',0)
#     RETURN
#  END IF
   
   IF g_lsd.lsd14='N' THEN 
      CALL cl_err('','alm-928',0)
      RETURN
   END IF
 
   IF g_lsd.lsd14 = 'S' THEN
      CALL cl_err('','alm-935',0)
      RETURN
   END IF
 
   IF g_lsd.lsd14 ='X' THEN
      CALL cl_err('','axr-103',0)      
      RETURN
   END IF
 
#   SELECT COUNT(*) INTO l_n FROM lua_file 
#    WHERE lua12 = g_lsd.lsd01
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
 
   OPEN t880_cl USING g_lsd.lsd01,g_lsd.lsd02
   IF STATUS THEN
      CALL cl_err("OPEN t880_cl:", STATUS, 1)
      CLOSE t880_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t880_cl INTO g_lsd.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lsd.lsd01,SQLCA.sqlcode,0)      
      CLOSE t880_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE lsd_file SET lsd14 = 'S',lsd10 = g_user,lsd11 = g_today 
    WHERE lsd01 = g_lsd.lsd01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lsd_file",g_lsd.lsd01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_lsd.lsd14 = 'S'
      LET g_lsd.lsd10 = g_user
      LET g_lsd.lsd11 = g_today
      DISPLAY BY NAME g_lsd.lsd14,g_lsd.lsd10,g_lsd.lsd11
      CALL cl_set_field_pic(g_lsd.lsd14,"","","","","")
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t880_ef()
   IF cl_null(g_lsd.lsd01) THEN 
      CALL cl_err('','-400',0) 
      RETURN 
   END IF
   
   SELECT * INTO g_lsd.* FROM lsd_file
    WHERE lsd01=g_lsd.lsd01
      AND lsd02=g_lsd.lsd02
 
#   IF g_lsd.lsdacti='N' THEN
#      CALL cl_err('','alm-131',0)
#      RETURN
#   END IF
   
   IF g_lsd.lsd14 ='Y' THEN    
      CALL cl_err(g_lsd.lsd01,'alm-005',0)
      RETURN
   END IF
 
    IF g_lsd.lsd14 = 'S' THEN
       CALL cl_err('','alm-934',0)
       RETURN
    END IF
   
   IF g_lsd.lsd14='X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   
   IF g_lsd.lsd13 MATCHES '[Ss1WwRr]' THEN 
      CALL cl_err('','mfg3557',0)
      RETURN
   END IF
  
   IF g_lsd.lsd12='N' THEN 
      CALL cl_err('','mfg3549',0)
      RETURN
   END IF
 
   IF g_success = "N" THEN
      RETURN
   END IF
 
   CALL aws_condition()      #
   IF g_success = 'N' THEN
      RETURN
   END IF
 
##########
# CALL aws_efcli2()
#
#
##########k
 
   IF aws_efcli2(base.TypeInfo.create(g_lsd),'','','','','')
   THEN
       LET g_success = 'Y'
       LET g_lsd.lsd13 = 'S'
       LET g_lsd.lsd12 = 'Y' 
       DISPLAY BY NAME g_lsd.lsd15,g_lsd.lsd16
   ELSE
       LET g_success = 'N'
   END IF
END FUNCTION
#FUNCTION t880_y1()
#   DEFINE l_cmd         VARCHAR(400)
#   DEFINE l_str         VARCHAR(04)
#   DEFINE l_pml         RECORD LIKE pml_file.*
#   DEFINE l_pml04       LIKE pml_file.pml04
#   DEFINE l_imaacti     LIKE ima_file.imaacti
#   DEFINE l_ima140      LIKE ima_file.ima140
#   DEFINE l_pml20       LIKE pml_file.pml20
#
#   IF g_lsd.lsd14='N' AND (g_lsd.lsd15='0' ) THEN
#      LET g_lsd.lsd15='1'
#   END IF
#
#
#   UPDATE lsd_file SET
#          lsd15=g_lsd.lsd15,
#          lsd16='Y',
#          lsdplant=g_user,
#          lsd18=g_today
#    WHERE lsd01 = g_lsd.lsd01
#   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err('upd lsd16',STATUS,1)
#      LET g_success = 'N' RETURN
#   END IF
# 
#END FUNCTION
FUNCTION t880_change()
DEFINE l_n     LIKE type_file.num5
DEFINE l_lsc14 LIKE lsc_file.lsc14
DEFINE l_newno LIKE lua_file.lua01
DEFINE l_msg   LIKE type_file.chr50
DEFINE l_lne05 LIKE lne_file.lne05
DEFINE l_n3       LIKE type_file.chr50
DEFINE l_n1       LIKE type_file.chr2 
DEFINE li_result  LIKE type_file.num5    
IF cl_null(g_lsd.lsd01) THEN 
      CALL cl_err('','-400',0) 
      RETURN 
   END IF
   
#  IF g_lsd.lsdacti='N' THEN
#     CALL cl_err('','alm-049',0)
#     RETURN
#  END IF
 
   IF g_lsd.lsd02='0' THEN 
      CALL cl_err('','alm-956',0)
      RETURN
   END IF
   
   IF g_lsd.lsd14='N' THEN 
      CALL cl_err('','alm-936',0)
      RETURN
   END IF
 
   SELECT lsc14 INTO l_lsc14 FROM lsc_file 
    WHERE lsc01 = g_lsd.lsd01
      AND lsc02 = g_lsd.lsd02
   IF l_lsc14 = 'S' THEN
      CALL cl_err('','alm-939',1)
      RETURN
   END IF
 
   IF g_lsd.lsd18 = 'Y' THEN
      CALL cl_err('','alm-944',0)
      RETURN
   END IF
 
   IF g_lsd.lsd14 ='X' THEN
      CALL cl_err('','axr-103',0)      
      RETURN
   END IF 
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t880_cl USING g_lsd.lsd01,g_lsd.lsd02
   IF STATUS THEN
      CALL cl_err("OPEN t880_cl:", STATUS, 1)
      CLOSE t880_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t880_cl INTO g_lsd.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lsd.lsd01,SQLCA.sqlcode,0)      
      CLOSE t880_cl
      ROLLBACK WORK
      RETURN
   END IF
 
    UPDATE lsd_file SET lsd18 = 'Y',
                        lsdmodu = g_user,
                        lsddate = g_today   
                  WHERE lsd01 = g_lsd.lsd01
                    AND lsd02 = g_lsd.lsd02    
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","lsd_file",g_lsd.lsd01,g_lsd.lsd02,SQLCA.sqlcode,"","",1)
       LET g_success = 'N' 
   ELSE 
       CALL t880_auto_assign_no()
#No.FUN-A80105   --------mark--------------------------------
#
#  #      CALL t880_auto_code()RETURNING l_newno 
#     LET g_t1=s_get_doc_no(g_lsd.lsd01)  
# #FUN-A70130 --------------------start-------------------------------    
# #    SELECT lrkdmy3 INTO l_n3 FROM lrk_file 
# #     WHERE lrkslip = g_t1 
# #    SELECT lrkkind INTO l_n1 FROM lrk_file
# #     WHERE lrkslip = l_n3  
#         SELECT rye03 INTO l_n3 FROM rye_file
#            WHERE  rye02 = 'B9' AND rye01 ='art'
#          SELECT oaytype INTO l_n1 FROM oay_file
#            WHERE oayslip = l_n3
#        CALL s_check_no("alm",l_n3,"",l_n1,"lua_file","lua01","")
# #FUN-A70130----------------------end---------------------------------
#           RETURNING li_result,l_newno
#       CALL s_auto_assign_no("alm",l_newno,g_today,l_n1,"lua_file","lua01","","","")  
#           RETURNING li_result,l_newno   	
#     SELECT lne05 INTO l_lne05 FROM lne_file 
#      WHERE lne01 = g_lsd.lsd03 
#        AND lne36 = 'Y'
#     INSERT INTO lua_file(luaplant,lualegal,lua01,lua02,lua03,lua04,lua05,lua06,lua061,lua07,
#                          lua08,lua08t,lua09,lua10,lua11,lua12,lua13,lua14,lua15,lua16,
#                          lua17,lua18,lua19,luauser,luamodu,luagrup,luacrat,luadate,luaacti,
#                          lua20,lua21,lua22,lua23 ,luaoriu,luaorig)
#                          
#                   VALUES(g_plant,g_legal,l_newno,'01',NULL ,NULL ,'2',g_lsd.lsd03,l_lne05 ,NULL,
#                                 '0','0',g_today,'Y','2',g_lsd.lsd01,'N' ,'0','N',NULL ,
#                                 NULL ,NULL ,g_plant,g_user,'',g_grup,g_today,NULL,'Y',
#                                 ' ',g_lsd.lsd19,g_lsd.lsd20,g_lsd.lsd21  , g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#       IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","lua_file","","",SQLCA.sqlcode,"","",1)
#           LET g_success = 'N'       
#           LET g_lsd.lsd18 = 'N'
#           DISPLAY BY NAME g_lsd.lsd18 
#       ELSE 
#       	  CALL cl_getmsg('alm-922',g_lang) RETURNING l_msg
#         	CALL cl_msgany(1,1,l_msg)     
#       END IF  
#      CALL t880_auto_code()RETURNING l_newno                                       
#     LET g_t1=s_get_doc_no(g_lsd.lsd01)  
# #FUN-A70130 -------------------------start----------------------------------    
# #    SELECT lrkdmy3 INTO l_n3 FROM lrk_file 
# #     WHERE lrkslip = g_t1 
# #    SELECT lrkkind INTO l_n1 FROM lrk_file
# #     WHERE lrkslip = l_n3  
#     SELECT rye03 INTO l_n3 FROM rye_file
#            WHERE  rye02 = 'B9' AND rye01 ='art'
#          SELECT oaytype INTO l_n1 FROM oay_file
#            WHERE oayslip = l_n3
#        CALL s_check_no("alm",l_n3,"",l_n1,"lua_file","lua01","")
# #FUN-A70130 -------------------------end--------------------------------------
#           RETURNING li_result,l_newno
#       CALL s_auto_assign_no("alm",l_newno,g_today,l_n1,"lua_file","lua01","","","")   
#           RETURNING li_result,l_newno 
#     INSERT INTO lua_file( luaplant,lualegal,lua01,lua02,lua03,lua04,lua05,lua06,lua061,lua07,
#                           lua08,lua08t,lua09,lua10,lua11,lua12,lua13,lua14,lua15,lua16,
#                           lua17,lua18,lua19,luauser,luamodu,luagrup,luacrat,luadate,luaacti,
#                           lua20,lua21,lua22,lua23 ,luaoriu,luaorig)
#                   VALUES(g_plant,g_legal,l_newno,'02',NULL ,NULL ,'2',g_lsd.lsd03,l_lne05 ,NULL,
#                                 '0','0',g_today,'Y','2',g_lsd.lsd01,'N' ,'0','N',NULL ,
#                                 NULL ,NULL ,g_plant,g_user,'',g_grup,g_today,NULL,'Y',
#                                 ' ',g_lsd.lsd19,g_lsd.lsd20,g_lsd.lsd21  , g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
#       IF SQLCA.sqlcode THEN
#           CALL cl_err3("ins","lua_file","","",SQLCA.sqlcode,"","",1)
#           LET g_success = 'N'            
#           LET g_lsd.lsd18 = 'N'
#           DISPLAY BY NAME g_lsd.lsd18 
#       ELSE 
#       	  CALL cl_getmsg('alm-923',g_lang) RETURNING l_msg
#         	CALL cl_msgany(1,1,l_msg)         	    
#       END IF   

#    LET g_lsd.lsd18 = 'Y'
#    LET g_lsd.lsd10 = g_user
#    LET g_lsd.lsd11 = g_today
#    LET g_lsd.lsdmodu = g_user
#    LET g_lsd.lsddate = g_today      
#    DISPLAY BY NAME g_lsd.lsd18,g_lsd.lsdmodu,g_lsd.lsddate
#       
#  #MOD-A30155因為只能修改三個field,故將不必要的update拿掉
#  UPDATE lsc_file 
#     SET#lsc_file.lscstore = g_lsd.lsdplant,
#        #lsc_file.lsclegal = g_lsd.lsdlegal,
#        #lsc_file.lsc01 = g_lsd.lsd01,    # DB
#         lsc_file.lsc02 = g_lsd.lsd02,
#        #lsc_file.lsc03 = g_lsd.lsd03,
#        #lsc_file.lsc04 = g_lsd.lsd04,
#        #lsc_file.lsc05 = g_lsd.lsd05,
#        #lsc_file.lsc06 = g_lsd.lsd06,
#         lsc_file.lsc07 = g_lsd.lsd07,
#         lsc_file.lsc08 = g_lsd.lsd08,
#         lsc_file.lsc09 = g_lsd.lsd09
#        #lsc_file.lsc10 = g_lsd.lsd10,
#        #lsc_file.lsc11 = g_lsd.lsd11,
#        #lsc_file.lsc12 = g_lsd.lsd12,
#        #lsc_file.lsc13 = g_lsd.lsd13,
#        #lsc_file.lsc14 = g_lsd.lsd14,
#        #lsc_file.lsc15 = g_lsd.lsd15,
#        #lsc_file.lsc16 = g_lsd.lsd16,
#        #lsc_file.lsc18 = g_lsd.lsd19,
#        #lsc_file.lsc19 = g_lsd.lsd20,
#        #lsc_file.lsc20 = g_lsd.lsd21,
#        #lsc_file.lscuser = g_lsd.lsduser,
#        #lsc_file.lscgrup = g_lsd.lsdgrup,
#        #lsc_file.lsccrat = g_lsd.lsdcrat,
#        #lsc_file.lscmodu = g_lsd.lsdmodu,
#        #lsc_file.lscdate = g_lsd.lsddate          
#   WHERE lsc01 = g_lsd.lsd01
#  IF SQLCA.sqlcode THEN
#     CALL cl_err3("upd","lsc_file","","",STATUS,"","",1) 
#     LET g_success = 'N'
#  ELSE 
#    CALL cl_getmsg('alm-940',g_lang) RETURNING l_msg
#    CALL cl_msgany(1,1,l_msg)      
#  END IF  
#   
#No.FUN-A80105  ---------------------mark ------------------------------
  
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
   
#No.FUN-A80105 -------------------------start---------------------------------


#No.FUN-BB0117   -----mark-------------------------------------------
#FUNCTION t880_auto_assign_no()
#DEFINE l_msg      LIKE type_file.chr50
#DEFINE l_n1       LIKE type_file.num5
#DEFINE l_n        LIKE type_file.num5
#DEFINE li_result  LIKE type_file.num5
#DEFINE li_result1  LIKE type_file.num5
#DEFINE l_lua01_1   LIKE lua_file.lua01
#DEFINE l_lua01_2   LIKE lua_file.lua01
#DEFINE l_lne05    LIKE lne_file.lne05 
#DEFINE l_lsc05     LIKE lsc_file.lsc05   
#DEFINE l_lsc06     LIKE lsc_file.lsc06
#   LET l_flag = 'Y'
#   SELECT rye03 INTO g_lua01_1 FROM rye_file
#                 WHERE rye01 = 'art' AND rye02 = 'B9'
#                 LET g_dd = g_today
#   LET g_lua01_2 = g_lua01_1
#   LET g_dd = g_today
#   OPEN WINDOW t880_1_w WITH FORM "alm/42f/almt880_1"
#                   ATTRIBUTE(STYLE=g_win_style CLIPPED)
#                   CALL cl_ui_locale("almt880_1")   
#    DISPLAY g_lua01_1 TO FORMONLY.g_lua01_1
#    DISPLAY g_lua01_2 TO FORMONLY.g_lua01_2
#    DISPLAY g_dd TO FORMONLY.g_dd
#    INPUT  BY NAME g_lua01_1,g_lua01_2,g_dd   WITHOUT DEFAULTS
 #   BEFORE INPUT
 #   AFTER FIELD g_lua01_1
 #         SELECT COUNT(*) INTO  l_n1 FROM oay_file
 #            WHERE oaysys ='art' AND oaytype ='B9' AND oayslip = g_lua01_1
 #         IF l_n1 = 0 THEN 
 #             CALL cl_err(g_lua01_1,'art-800',0)
 #             NEXT FIELD g_lua01_1
 #         END IF
 #   AFTER FIELD g_lua01_2
 #         SELECT COUNT(*) INTO  l_n1 FROM oay_file
 #            WHERE oaysys ='art' AND oaytype ='B9' AND oayslip = g_lua01_2
 #         IF l_n1 = 0 THEN 
 #             CALL cl_err(g_lua01_2,'art-800',0)
#              NEXT FIELD g_lua01_2
#          END IF
#    AFTER FIELD g_dd
#        IF NOT cl_null(g_dd) THEN 
#          SELECT lsc05,lsc06 INTO l_lsc05,l_lsc06 FROM lsc_file
#            WHERE lsc01 = g_lsd.lsd01 
#          IF g_dd > l_lsc06 OR g_dd <l_lsc05 THEN
#             CALL cl_err(g_dd,'alm-768',0)
#             NEXT FIELD  g_dd
#          END IF  
#        ELSE
#             NEXT FIELD  g_dd
#        END IF          
#    ON ACTION CONTROLR
#        CALL cl_show_req_fields()
# 
#    ON ACTION CONTROLG
#        CALL cl_cmdask()
# 
#    ON ACTION CONTROLF
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)     
#    ON ACTION controlp
#        CASE
#           WHEN INFIELD(g_lua01_1)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_slip"
#              LET g_qryparam.default1 = g_lua01_1
#              CALL cl_create_qry() RETURNING g_lua01_1
#              DISPLAY BY NAME g_lua01_1
#              NEXT FIELD g_lua01_1
#           WHEN INFIELD(g_lua01_2)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_slip"
#              LET g_qryparam.default1 = g_lua01_2
#              CALL cl_create_qry() RETURNING g_lua01_2
#              DISPLAY BY NAME g_lua01_2
#              NEXT FIELD g_lua01_2
#        
#              OTHERWISE EXIT CASE
#        END CASE
#
#     ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
# 
#     ON ACTION about
#        CALL cl_about()
#  
#     ON ACTION HELP
#        CALL cl_show_help()
#     END INPUT  
#      IF INT_FLAG THEN
#          LET INT_FLAG=0
#          LET l_flag = 'N'
#          CALL cl_err('',9001,0)
#      END IF
#     CLOSE WINDOW t880_1_w 
#   IF l_flag = 'Y' THEN
#        CALL s_check_no("art",g_lua01_1,"",'B9',"lua_file","lua01","")        #FUN-A70130
#            RETURNING li_result,l_lua01_1
#        CALL s_auto_assign_no("art",g_lua01_1,g_dd,'B9',"lua_file","lua01","","","")
#            RETURNING li_result,l_lua01_1
#     IF li_result THEN 
#        SELECT lne05 INTO l_lne05 FROM lne_file 
#        WHERE lne01 = g_lsd.lsd03 
#          AND lne36 = 'Y'
#No.FUN-BB0117   -----end-------------------------------------------


#FUN-BB0117-add-start--
FUNCTION t880_auto_assign_no()
DEFINE l_msg      LIKE type_file.chr50
DEFINE l_n1       LIKE type_file.num5
DEFINE l_n        LIKE type_file.num5
DEFINE li_result  LIKE type_file.num5
DEFINE li_result1  LIKE type_file.num5
DEFINE l_lua01   LIKE lua_file.lua01
DEFINE l_lne05    LIKE lne_file.lne05 
DEFINE l_lsc05     LIKE lsc_file.lsc05   
DEFINE l_lsc06     LIKE lsc_file.lsc06
DEFINE g_lua01    LIKE lua_file.lua01
   LET l_flag = 'Y'

   #FUN-C90050 mark begin---
   #SELECT rye03 INTO g_lua01 FROM rye_file
   #  WHERE rye01 = 'art' AND rye02 = 'B9'
   #FUN-C90050 mark end-----

   CALL s_get_defslip('art','B9',g_plant,'N')  RETURNING g_lua01   #FUN-C90050 add

       LET g_dd = g_today
   IF l_flag = 'Y' THEN
        CALL s_check_no("art",g_lua01,"",'B9',"lua_file","lua01","")        #FUN-A70130
            RETURNING li_result,l_lua01
        CALL s_auto_assign_no("art",g_lua01,g_dd,'B9',"lua_file","lua01","","","")
            RETURNING li_result,l_lua01
   IF li_result THEN 
      SELECT lne05 INTO l_lne05 FROM lne_file 
        WHERE lne01 = g_lsd.lsd03 
          AND lne36 = 'Y'
#FUN-BB0117-add-end--


#No.FUN-BB0117   -----mark------------------------------------------- 
#        INSERT INTO lua_file(luaplant,lualegal,lua01,lua02,lua03,lua04,lua05,lua06,lua061,lua07,
#                           lua08,lua08t,lua09,lua10,lua11,lua12,lua13,lua14,lua15,lua16,
#                           lua17,lua18,lua19,luauser,luamodu,luagrup,luacrat,luadate,luaacti,
#                           lua20,lua21,lua22,lua23 ,luaoriu,luaorig,lua32)
#                           
#                   #VALUES(g_plant,g_legal,l_lua01_1,'01',NULL ,NULL ,'2',g_lsd.lsd03,l_lne05 ,NULL,    #FUN-AC0062
#                    VALUES(g_plant,g_legal,l_lua01_1,'01',NULL ,NULL ,' ',g_lsd.lsd03,l_lne05 ,NULL,    #FUN-AC0062
#                                  '0','0',g_dd,'Y','6',g_lsd.lsd01,'N' ,'0','N',NULL ,
#                                  NULL ,NULL ,g_plant,g_user,'',g_grup,g_today,NULL,'Y',
#                                  ' ',g_lsd.lsd19,g_lsd.lsd20,g_lsd.lsd21  , g_user, g_grup,'2')  
#        
#        IF SQLCA.sqlcode THEN
#            CALL cl_err3("ins","lua_file","","",SQLCA.sqlcode,"","",1)
#            LET g_success = 'N'       
#            LET g_lsd.lsd18 = 'N'
#            DISPLAY BY NAME g_lsd.lsd18 
#        ELSE 
#        	  CALL cl_getmsg('alm-922',g_lang) RETURNING l_msg
#          	CALL cl_msgany(1,1,l_msg)     
#        END IF  
#        CALL s_check_no("art",g_lua01_2,"",'B9',"lua_file","lua01","")        #FUN-A70130
#            RETURNING li_result1,l_lua01_2
#        CALL s_auto_assign_no("art",g_lua01_2,g_dd,'B9',"lua_file","lua01","","","")
#            RETURNING li_result1,l_lua01_2
#        IF li_result1 THEN 
#           INSERT INTO lua_file( luaplant,lualegal,lua01,lua02,lua03,lua04,lua05,lua06,lua061,lua07,
#                               lua08,lua08t,lua09,lua10,lua11,lua12,lua13,lua14,lua15,lua16,
#                               lua17,lua18,lua19,luauser,luamodu,luagrup,luacrat,luadate,luaacti,
#                               lua20,lua21,lua22,lua23 ,luaoriu,luaorig,lua32)
#                    #VALUES(g_plant,g_legal,l_lua01_2,'02',NULL ,NULL ,'2',g_lsd.lsd03,l_lne05 ,NULL,  #FUN-AC0062  
#                     VALUES(g_plant,g_legal,l_lua01_2,'02',NULL ,NULL ,' ',g_lsd.lsd03,l_lne05 ,NULL,  #FUN-AC0062
#                                  '0','0',g_dd,'Y','6',g_lsd.lsd01,'N' ,'0','N',NULL ,
#                                  NULL ,NULL ,g_plant,g_user,'',g_grup,g_today,NULL,'Y',
#                                  ' ',g_lsd.lsd19,g_lsd.lsd20,g_lsd.lsd21  , g_user, g_grup,'2')  
#No.FUN-BB0117   -----end------------------------------------------- 

#FUN-BB017-add-start--
            INSERT INTO lua_file(lua01,lua02,lua03,lua04,lua05,lua06,lua061,
                       lua08,lua08t,lua09,lua10,lua11,lua12,lua13,lua14,lua15,
                       lua16,lua17,lua18,lua19,lua20,lua21,lua22,lua23,lua24,
                       luaacti,luacrat,luadate,luagrup,lualegal,luaplant,luauser,
                       luaoriu,luaorig,lua32,lua33,lua34,lua35,lua36,lua37,lua38,
                       lua39)
                  VALUES (l_lua01,' ',' ',NULL,' ',g_lsd.lsd03,l_lne05,
                      '0','0',g_dd,'Y','6',g_lsd.lsd01,'N','0','N',
                       NULL,NULL,NULL,g_plant,' ',g_lsd.lsd19,g_lsd.lsd20,g_lsd.lsd21,NULL,
                       'Y',g_today,g_today,g_grup,g_legal,g_plant,g_user,
                       g_user,g_grup,'3',NULL,NULL,'0','0','Y',g_user,g_grup)
#FUN-BB0117-add-end--         

      IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lua_file","","",SQLCA.sqlcode,"","",1)
              LET g_success = 'N'            
              LET g_lsd.lsd18 = 'N'
              DISPLAY BY NAME g_lsd.lsd18 
           ELSE 
              CALL cl_getmsg('alm-922',g_lang) RETURNING l_msg
          	  CALL cl_msgany(1,1,l_msg)         	    
           END IF   
           LET g_lsd.lsd18 = 'Y'
           LET g_lsd.lsd10 = g_user
           LET g_lsd.lsd11 = g_today
           LET g_lsd.lsdmodu = g_user
           LET g_lsd.lsddate = g_today      
           DISPLAY BY NAME g_lsd.lsd18,g_lsd.lsdmodu,g_lsd.lsddate  
           UPDATE lsc_file  SET
                lsc_file.lsc02 = g_lsd.lsd02,
                lsc_file.lsc07 = g_lsd.lsd07,
                 lsc_file.lsc08 = g_lsd.lsd08,
                lsc_file.lsc09 = g_lsd.lsd09               
           WHERE lsc01 = g_lsd.lsd01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","lsc_file","","",STATUS,"","",1) 
              LET g_success = 'N'
           ELSE 
              CALL cl_getmsg('alm-940',g_lang) RETURNING l_msg
              CALL cl_msgany(1,1,l_msg)      
           END IF   

          END IF
     END IF

       IF NOT li_result  THEN 
          CALL cl_err('','alm-859',0)
          LET g_success = 'N'
       END IF
END FUNCTION    
#No.FUN-A80105 ------------------------------end--------------------------
     
FUNCTION t880_lsdplant(p_cmd)                                                                                                       
 DEFINE p_cmd     LIKE type_file.chr1                                                                                               
 DEFINE l_rtz13   LIKE rtz_file.rtz13                                                                                               
 DEFINE l_azt02   LIKE azt_file.azt02                                                                                               
                                                                                                                                    
   IF p_cmd <> 'u' THEN                                                                                                             
      SELECT rtz13 INTO l_rtz13 FROM rtz_file                                                                                       
       WHERE rtz01 = g_lsd.lsdplant                                                                                                 
      SELECT azt02 INTO l_azt02 FROM azt_file                                                                                       
       WHERE azt01 = g_lsd.lsdlegal                                                                                                 
      DISPLAY l_rtz13 TO FORMONLY.rtz13                                                                                             
      DISPLAY l_azt02 TO FORMONLY.azt02                                                                                             
   END IF                                                                                                                           
END FUNCTION  
#FUN-A60064 10/06/24 By wangxin 非T/S類table中的xxxplant替換成xxxstore

