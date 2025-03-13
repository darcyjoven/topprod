# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfi413.4gl
# Descriptions...: PBI製程料件明細維護作業
# Date & Author..: No.FUN-A80054 10/09/10 By jan
# Modify.........: No:FUN-AA0060 10/10/21 By zhangll 控制只能查询和选择属于该营运中心的仓库
# Modify.........: No.FUN-AB0025 10/11/12 By chenying 修改料號開窗改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0059 10/11/15 By huangtao 添加料號after field 管控
# Modify.........: No:FUN-AB0058 10/11/19 By yinhy 倉庫權限檢查使報錯更了然
# Modify.........: No:TQC-B30104 11/03/14 By destiny 审核后单据不能修改 
# Modify.........: No:TQC-DC0018 13/12/05 By wangrr 修改儲位開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_edh   RECORD LIKE edh_file.*,
    g_edh_t RECORD LIKE edh_file.*,
    g_edh_o RECORD LIKE edh_file.*,
    g_edh01_t LIKE edh_file.edh01,
    g_edh011_t LIKE edh_file.edh011,
    g_edh013_t LIKE edh_file.edh013,
    g_edh02_t LIKE edh_file.edh02,
    g_edh03_t LIKE edh_file.edh03,
    g_edh04_t LIKE edh_file.edh04,
    g_edh29_t LIKE edh_file.edh29,
    g_edh10_t LIKE edh_file.edh10,
    g_edh25_t LIKE edh_file.edh25,
    g_edh26_t LIKE edh_file.edh26,
    g_ima08_b LIKE ima_file.ima08,
    g_ima37_b LIKE ima_file.ima37,
    g_ima70_b LIKE ima_file.ima70,
    g_ima25_b LIKE ima_file.ima25,
    g_ima63_b LIKE ima_file.ima63,
    g_ima86_b LIKE ima_file.ima86,
    g_ima63_fac LIKE ima_file.ima63_fac,
    g_argv1     LIKE edh_file.edh01,     
    g_argv2     LIKE edh_file.edh011,      
    g_argv3     LIKE edh_file.edh013, 
    g_argv4     LIKE edh_file.edh03,     
    g_sw        LIKE type_file.num5,   
    g_ecd03     LIKE ecd_file.ecd03,
    g_factor    LIKE pml_file.pml09,   
    g_wc,g_sql  string,              
    g_ima08     LIKE ima_file.ima08,
    g_ima70     LIKE ima_file.ima70  
DEFINE g_forupd_sql          STRING                  
DEFINE g_before_input_done   STRING
DEFINE   g_chr           LIKE type_file.chr1    
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_msg           LIKE ze_file.ze03          
DEFINE   g_row_count     LIKE type_file.num10       
DEFINE   g_curs_index    LIKE type_file.num10      
DEFINE   g_jump          LIKE type_file.num10      
DEFINE   g_no_ask        LIKE type_file.num5       
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    INITIALIZE g_edh.* TO NULL
    INITIALIZE g_edh_t.* TO NULL
    INITIALIZE g_edh_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM edh_file WHERE edh01 = ? AND edh011 = ? AND edh013 = ? ",
                       "   AND edh02 = ?  AND edh03= ? AND edh04= ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i413_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
 
    OPEN WINDOW i413_w WITH FORM "asf/42f/asfi413"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("edh14,edh15,edh16,edh19,group05",FALSE)
    
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3) 
    LET g_argv4 = ARG_VAL(4) 
    
    
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL i413_q()
    END IF
    
    LET g_action_choice=""
    CALL i413_menu()
 
    CLOSE WINDOW i413_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i413_curs()
DEFINE  l_cmd     LIKE type_file.chr1000  
    CLEAR FORM
    DISPLAY BY NAME  g_edh.edh01
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN LET g_sql="SELECT edh01,edh011,edh013,edh02,edh03,edh04 ", 
                      "  FROM edh_file ",                      # 組合出 SQL 指令
                      " WHERE edh01 ='",g_argv1,"'",
                      "   AND edh011= ",g_argv2,
                      "   AND edh013= ",g_argv3,
                      "   AND edh03= '",g_argv4,"' "
     
            IF g_argv2 IS NOT NULL AND g_argv2 != ' ' THEN
               LET  g_sql = g_sql  CLIPPED,
                         " AND (edh04 <='", g_today,"'"," OR edh04 IS NULL )",
                         " AND (edh05 > '",g_today,"'"," OR edh05 IS NULL )"
            END IF
            CASE g_sma.sma65
              WHEN '1'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edh01,edh011,edh013,edh02,edh03,edh04" 
              WHEN '2'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edh01,edh011,edh013,edh03,edh02,edh04" 
              WHEN '3'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edh01,edh011,edh013,edh13,edh02,edh03,edh04" 
              OTHERWISE LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edh01,edh011,edh013,edh02,edh03,edh04"
            END CASE
   ELSE
     INITIALIZE g_edh.* TO NULL    
     CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
              edh01,edh011,edh013,edh02,edh03,edh04,edh05,edh10,edh10_fac, 
              edh10_fac2, edh06,edh07,edh08,edh23,edh11,edh13,
              edh27,edh09,edh18,edh28,edh25,edh26,edh24,
              edhmodu,edhdate,edhcomm    
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            ON ACTION controlp
               CASE
                  WHEN INFIELD(edh01) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_sfb85"   
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_edh.edh01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO edh01
                     NEXT FIELD edh01                                                              
                  WHEN INFIELD(edh03) #料件主檔
#FUN-AB0025---------mod---------------str----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.state = "c"
#                    LET g_qryparam.default1 = g_edh.edh03
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","",g_edh.edh03,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AB0025--------mod---------------end----------------
                     DISPLAY g_qryparam.multiret TO edh03
                     NEXT FIELD edh03
                  WHEN INFIELD(edh09) #作業主檔
                     CALL q_ecd(TRUE,TRUE,g_edh.edh09)
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO edh09
                     NEXT FIELD edh09
                  WHEN INFIELD(edh10) #單位檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gfe"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_edh.edh10
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO edh10
                     NEXT FIELD edh10
                  WHEN INFIELD(edh25) #倉庫
                    #No.FUN-AA0060 --mod beg
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form = "q_imfd"
                    #LET g_qryparam.state = "c"
                    #LET g_qryparam.default1 = g_edh.edh25
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_imd_1(TRUE,TRUE,g_edh.edh25,"",g_plant,"","")  #只能开当前门店的
                          RETURNING g_qryparam.multiret
                    #No.FUN-AA0060 --mod end
                     DISPLAY g_qryparam.multiret TO edh25
                     NEXT FIELD edh25
                  WHEN INFIELD(edh26) #儲位
                     #TQC-DC0018--MOD--str--
                     #CALL cl_init_qry_var()
                     #LET g_qryparam.form = "q_imfe"
                     #LET g_qryparam.state = "c"
                     #LET g_qryparam.default1 = g_edh.edh26
                     #CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                          RETURNING g_qryparam.multiret
                     #TQC-DC0018--MOD--end
                     DISPLAY g_qryparam.multiret TO edh26
                     NEXT FIELD edh26
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
            LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, NULL)
 
             LET g_sql="SELECT edh01,edh011,edh013,edh02,edh03,edh04 ",
                       " FROM edh_file ",                      
                       " WHERE ",g_wc CLIPPED
            CASE g_sma.sma65
              WHEN '1'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edh01,edh011,edh013,edh02,edh03,edh04" 
              WHEN '2'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edh01,edh011,edh013,edh03,edh02,edh04"
              WHEN '3'  LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edh01,edh011,edh013,edh13,edh02,edh03,edh04"
              OTHERWISE LET g_sql = g_sql CLIPPED,
                                    " ORDER BY edh01,edh011,edh013,edh02,edh03,edh04"
            END CASE
   END IF
 
    PREPARE i413_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i413_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i413_prepare
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
       THEN LET g_sql =
                "SELECT COUNT(*) FROM edh_file WHERE edh01 ='",g_argv1,"'",
                                               " AND edh03 ='",g_argv4,"'",  
                                               " AND edh011='",g_argv2,"' ",
                                               " AND edh013='",g_argv3,"' " 
    ELSE LET g_sql=
                "SELECT COUNT(*) FROM edh_file WHERE ",g_wc CLIPPED
    END IF
    PREPARE i413_precount FROM g_sql
    DECLARE i413_count CURSOR FOR i413_precount
END FUNCTION
 
FUNCTION i413_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i413_q()
            END IF
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i413_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i413_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()       

        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
         ON ACTION first
            CALL i413_fetch('F')
         ON ACTION next
            CALL i413_fetch('N')
         ON ACTION jump
            CALL i413_fetch('/')
         ON ACTION previous
            CALL i413_fetch('P')
         ON ACTION last
            CALL i413_fetch('L')
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about       
         CALL cl_about()     
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION CLOSE 
             LET INT_FLAG=FALSE 	
            LET g_action_choice = "exit"
            EXIT MENU
 
          ON ACTION related_document                
            LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_edh.edh01 IS NOT NULL THEN
                  LET g_doc.column1 = "edh01"
                  LET g_doc.value1  = g_edh.edh01
                  LET g_doc.column2 = "edh02"
                  LET g_doc.value2  = g_edh.edh02
                  LET g_doc.column3 = "edh03"
                  LET g_doc.value3  = g_edh.edh03
                  LET g_doc.column4 = "edh04"
                  LET g_doc.value4  = g_edh.edh04
                  LET g_doc.column5= "edh011" 
                  LET g_doc.value5 = g_edh.edh011
                  CALL cl_doc()
               END IF
            END IF

      &include "qry_string.4gl"
    END MENU
    CLOSE i413_curs
END FUNCTION
  
FUNCTION i413_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    
        l_cmd           LIKE type_file.chr1000,
        l_dir1          LIKE type_file.chr1,   
        l_n             LIKE type_file.num5,    
        l_ima08         LIKE ima_file.ima08,
        l_edh01         LIKE edh_file.edh01,
        l_ime09         LIKE ime_file.ime09,
        l_qpa           LIKE edh_file.edh06,
        l_code          LIKE type_file.num5,   
        l_flag          LIKE type_file.chr1,   
        l_cnt           LIKE type_file.num5,   
        l_bmd02  LIKE bmd_file.bmd02 

    DISPLAY BY NAME
      g_edh.edh01,g_edh.edh011,g_edh.edh013,g_edh.edh02,
      g_edh.edh03,g_edh.edh04,
      g_edh.edh05,g_edh.edh10,g_edh.edh10_fac,g_edh.edh10_fac2,
      g_edh.edh06,g_edh.edh07,g_edh.edh08,g_edh.edh23,
      g_edh.edh11,g_edh.edh13,g_edh.edh27,
      g_edh.edh09,g_edh.edh18,
      g_edh.edh28,g_edh.edh25,g_edh.edh26,g_edh.edh24,
      g_edh.edhmodu,g_edh.edhdate,g_edh.edhcomm

 
    INPUT BY NAME
      g_edh.edh01,g_edh.edh011,g_edh.edh013,g_edh.edh02,g_edh.edh03,
      g_edh.edh04,g_edh.edh05,g_edh.edh10,g_edh.edh10_fac,g_edh.edh10_fac2,
      g_edh.edh06,g_edh.edh07,g_edh.edh08,g_edh.edh23,
      g_edh.edh11,g_edh.edh13,g_edh.edh27,
      g_edh.edh09,g_edh.edh18,
      g_edh.edh28,g_edh.edh25,g_edh.edh26,g_edh.edh24,
      g_edh.edhmodu,g_edh.edhdate,g_edh.edhcomm
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i413_set_entry(p_cmd)
            CALL i413_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD edh01                 
            IF g_argv1 IS NOT NULL AND g_argv1 != ' '
               AND g_edh.edh01 != g_edh_t.edh01 THEN
               CALL cl_err('','mfg2627',0)
               NEXT FIELD edh01
            END IF
            IF NOT cl_null(g_edh.edh01) THEN
              IF p_cmd = "a" OR                    # 若輸入或更改且改KEY 
                 (p_cmd = "u" AND g_edh.edh01 != g_edh_t.edh01) THEN
                 LET l_cnt=0
                 SELECT COUNT(*) INTO l_cnt FROM sfd_file
                  WHERE sfd01=g_edh.edh01
                    AND sfdconf='N'
                 IF l_cnt = 0 THEN CALL cl_err('','asf-432',1) NEXT FIELD edh01 END IF
                 CALL i413_edh01('a')
                 IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_edh.edh01,g_errno,0) 
                  LET g_edh.edh01=g_edh_t.edh01
                  DISPLAY BY NAME g_edh.edh01
                  NEXT FIELD edh01
               END IF 
              END IF  
            END IF
            
        AFTER FIELD edh011
           IF NOT cl_null(g_edh.edh011) AND NOT cl_null(g_edh.edh01) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM sfd_file
               WHERE sfd01=g_edh.edh01 AND sfd02=g_edh.edh011
                 AND sfdconf='N'
              IF l_cnt = 0 THEN CALL cl_err('','abx-064',1) NEXT FIELD edh011 END IF
           END IF
       
       AFTER FIELD edh013
           IF NOT cl_null(g_edh.edh011) AND NOT cl_null(g_edh.edh01)
              AND NOT cl_null(g_edh.edh013) THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM edg_file,sfd_file
               WHERE edg01=g_edh.edh01 AND edg02=g_edh.edh011
                 AND edg03=g_edh.edh013
                 AND sfd01=edg01 AND sfd02=edg02 AND sfdconf='N'
              IF l_cnt = 0 THEN CALL cl_err('','abm-215',1) NEXT FIELD edh011 END IF
           END IF    
        
 
        BEFORE FIELD edh02                        #default 項次
            IF g_edh.edh02 IS NULL OR
               g_edh.edh02 = 0 THEN
                SELECT max(edh02)+1
                   INTO g_edh.edh02
                   FROM edh_file
                   WHERE edh01 = g_edh.edh01
                     AND edh011 = g_edh.edh011
                     AND edh013 = g_edh.edh013
                IF g_edh.edh02 IS NULL
                   THEN LET g_edh.edh02 = 1
                END IF
                DISPLAY BY NAME g_edh.edh02
            END IF
 
        BEFORE FIELD edh03
	        IF g_sma.sma60 = 'Y'		# 若須分段輸入
	           THEN CALL s_inp5(10,15,g_edh.edh03) RETURNING g_edh.edh03
	           DISPLAY BY NAME g_edh.edh03
	        END IF
          LET g_edh03_t = g_edh.edh03
 
        AFTER FIELD edh03                  #元件料號
            IF NOT cl_null(g_edh.edh03) THEN
#FUN-AB0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_edh.edh03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_edh.edh03= g_edh_t.edh03
                  NEXT FIELD edh03
               END IF
#FUN-AB0059 ---------------------end-------------------------------
               CALL i413_edh03(p_cmd)   #必需讀取料件主檔
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_edh.edh03,g_errno,0) 
                  LET g_edh.edh03=g_edh_t.edh03
                  DISPLAY BY NAME g_edh.edh03
                  NEXT FIELD edh03
               END IF
            END IF
 
        AFTER FIELD edh04                        #check 是否重複
            IF NOT cl_null(g_edh.edh04) THEN
               IF g_edh.edh01 != g_edh01_t OR g_edh01_t IS NULL
                  OR g_edh.edh02 != g_edh02_t OR g_edh02_t IS NULL
                  OR g_edh.edh03 != g_edh03_t OR g_edh03_t IS NULL
                  OR g_edh.edh04 != g_edh04_t OR g_edh04_t IS NULL 
                  OR g_edh.edh011 != g_edh011_t OR g_edh011_t IS NULL 
                  OR g_edh.edh013 != g_edh013_t OR g_edh013_t IS NULL THEN  
                   SELECT count(*) INTO g_cnt FROM edh_file
                       WHERE edh01 = g_edh.edh01 AND edh02 = g_edh.edh02
                         AND edh03 = g_edh.edh03 AND edh04 = g_edh.edh04
                         AND edh011 = g_edh.edh011 AND edh013=g_edh.edh013
                   IF g_cnt > 0 THEN   #資料重複
                       LET g_msg = g_edh.edh01 CLIPPED,'+',g_edh.edh02
                                   CLIPPED,'+',g_edh.edh03 CLIPPED,'+',
                                   g_edh.edh04,'+',g_edh.edh011,'+',g_edh.edh013 
                       CALL cl_err(g_msg,-239,0)
                       LET g_edh.edh02 = g_edh02_t
                       LET g_edh.edh03 = g_edh03_t
                       LET g_edh.edh04 = g_edh04_t
                       LET g_edh.edh011 = g_edh011_t 
                       LET g_edh.edh013 = g_edh011_t 
                       DISPLAY BY NAME g_edh.edh01
                       DISPLAY BY NAME g_edh.edh02
                       DISPLAY BY NAME g_edh.edh03
                       DISPLAY BY NAME g_edh.edh04
                       DISPLAY BY NAME g_edh.edh011 
                       DISPLAY BY NAME g_edh.edh013
                       NEXT FIELD edh01
                   END IF
               END IF
               CALL i413_bdate(p_cmd)     #生效日
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_edh.edh04,g_errno,0)
                  LET g_edh.edh04 = g_edh_t.edh04
                  DISPLAY BY NAME g_edh.edh04
                  NEXT FIELD edh04
               END IF
            END IF
 
        AFTER FIELD edh05   #check失效日小於生效日
            IF NOT cl_null(g_edh.edh05) THEN
               IF g_edh.edh05 < g_edh.edh04 THEN
                  CALL cl_err(g_edh.edh05,'mfg2604',0)
                  NEXT FIELD edh04
               END IF
            END IF
            CALL i413_edate(p_cmd)     #生效日
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_edh.edh05,g_errno,0)
               LET g_edh.edh05 = g_edh_t.edh05
               DISPLAY BY NAME g_edh.edh05
               NEXT FIELD edh04
            END IF
 
        AFTER FIELD edh06    #組成用量不可小於零
           IF g_edh.edh06 <= 0 THEN
              CALL cl_err(g_edh.edh06,'mfg2614',0)
              LET g_edh.edh06 = g_edh_o.edh06
              DISPLAY BY NAME g_edh.edh06
              NEXT FIELD edh06
           END IF
           LET g_edh_o.edh06 = g_edh.edh06
 
        AFTER FIELD edh07    #底數不可小於等於零
            IF g_edh.edh07 <= 0  THEN
               CALL cl_err(g_edh.edh07,'mfg2615',0)
               LET g_edh.edh07 = g_edh_o.edh07
               DISPLAY BY NAME g_edh.edh07
               NEXT FIELD edh07
            END IF
            LET g_edh_o.edh07 = g_edh.edh07
 
        AFTER FIELD edh08    #損耗率
            IF g_edh.edh08 < 0 OR g_edh.edh08 > 100 THEN
               CALL cl_err(g_edh.edh08,'mfg0013',0)
               LET g_edh.edh08 = g_edh_o.edh08
               DISPLAY BY NAME g_edh.edh08
               NEXT FIELD edh08
            END IF
            LET g_edh_o.edh08 = g_edh.edh08
 
        AFTER FIELD edh10   #發料單位
          IF NOT cl_null(g_edh.edh10) THEN
             IF (g_edh_o.edh10 IS NULL) OR (g_edh.edh10 != g_edh_o.edh10)
             THEN SELECT gfe01 FROM gfe_file
                   WHERE gfe01 = g_edh.edh10 AND
                         gfeacti IN ('Y','y')  
                   IF SQLCA.sqlcode != 0 THEN
                      CALL cl_err3("sel","gfe_file",g_edh.edh10,"","mfg2605","","",1)  
                      LET g_edh.edh10 = g_edh_o.edh10
                      DISPLAY BY NAME g_edh.edh10
                      LET g_edh.edh10_fac = g_edh_o.edh10_fac
                      DISPLAY BY NAME g_edh.edh10_fac
                      LET g_edh.edh10_fac2= g_edh_o.edh10_fac2
                      DISPLAY BY NAME g_edh.edh10_fac2
                      NEXT FIELD edh10
                   ELSE IF g_edh.edh10 != g_ima25_b
                        THEN CALL s_umfchk(g_edh.edh03,g_edh.edh10,
                                            g_ima25_b)
                              RETURNING g_sw,g_edh.edh10_fac #發料/庫存單位
                              IF g_sw = '1' THEN
                                 CALL cl_err(g_edh.edh10,'mfg2721',0)
                                 LET g_edh.edh10 = g_edh_o.edh10
                                 DISPLAY BY NAME g_edh.edh10
                                 LET g_edh.edh10_fac = g_edh_o.edh10_fac
                                 DISPLAY BY NAME g_edh.edh10_fac
                                 LET g_edh.edh10_fac2= g_edh_o.edh10_fac2
                                 DISPLAY BY NAME g_edh.edh10_fac2
                                 NEXT FIELD edh10
                              END IF
                        ELSE LET g_edh.edh10_fac  = 1
                        END  IF
                        IF g_edh.edh10 != g_ima86_b  #發料/成本單位
                        THEN CALL s_umfchk(g_edh.edh03,g_edh.edh10,
                                             g_ima86_b)
                             RETURNING g_sw,g_edh.edh10_fac2
                             IF g_sw = '1' THEN
                                CALL cl_err(g_edh.edh03,'mfg2722',0)
                                LET g_edh.edh10 = g_edh_o.edh10
                                DISPLAY BY NAME g_edh.edh10
                                LET g_edh.edh10_fac = g_edh_o.edh10_fac
                                DISPLAY BY NAME g_edh.edh10_fac
                                LET g_edh.edh10_fac2 = g_edh_o.edh10_fac2
                                DISPLAY BY NAME g_edh.edh10_fac2
                                NEXT FIELD edh10
                             END IF
                        ELSE LET g_edh.edh10_fac2 = 1
                        END IF
                   END IF
             END IF
          END IF
          DISPLAY BY NAME g_edh.edh10_fac
          DISPLAY BY NAME g_edh.edh10_fac2
          LET g_edh_o.edh10 = g_edh.edh10
          LET g_edh_o.edh10_fac = g_edh.edh10_fac
          LET g_edh_o.edh10_fac2 = g_edh.edh10_fac2
 
        AFTER FIELD edh10_fac   #發料/料件庫存轉換率
            IF g_edh.edh10_fac <= 0
               THEN CALL cl_err(g_edh.edh10_fac,'mfg1322',0)
                    LET g_edh.edh10_fac = g_edh_o.edh10_fac
                    DISPLAY BY NAME g_edh.edh10_fac
                    NEXT FIELD edh10_fac
            END IF
            LET g_edh_o.edh10_fac = g_edh.edh10_fac
 
        AFTER FIELD edh10_fac2   #發料/料件成本轉換率
            IF g_edh.edh10_fac2 <= 0
               THEN CALL cl_err(g_edh.edh10_fac2,'mfg1322',0)
                    LET g_edh.edh10_fac2 = g_edh_o.edh10_fac2
                    DISPLAY BY NAME g_edh.edh10_fac2
                    NEXT FIELD edh10_fac2
            END IF
            LET g_edh_o.edh10_fac2 = g_edh.edh10_fac2
 
        AFTER FIELD edh09    #作業編號
             #有使用製程(sma54='Y')
             IF NOT cl_null(g_edh.edh09) THEN
                SELECT COUNT(*) INTO g_cnt FROM ecd_file
                 WHERE ecd01=g_edh.edh09
                IF g_cnt=0 THEN
                   CALL cl_err('sel ecd_file',100,0)
                   NEXT FIELD edh09
                END IF
             END IF
 
        AFTER FIELD edh27  #軟體物件
            LET g_edh_o.edh27 = g_edh.edh27
 
          AFTER FIELD edh18     #投料時距
             LET l_dir1 = 'U'
             IF g_edh.edh18 < 0 THEN
                CALL cl_err(g_edh.edh18,'aim-223',0)
                NEXT FIELD edh18
             END IF
             IF cl_null(g_edh.edh18)
             THEN LET g_edh.edh18 = 0
                  DISPLAY BY NAME g_edh.edh18
             END IF
 
        AFTER FIELD edh23    #選中率
            IF g_edh.edh23 < 0 OR g_edh.edh23 > 100
               THEN CALL cl_err(g_edh.edh23,'mfg0013',0)
                    LET g_edh.edh23 = g_edh_o.edh23
                    DISPLAY BY NAME g_edh.edh23
                    NEXT FIELD edh23
            END IF
            LET g_edh_o.edh23 = g_edh.edh23
 
       AFTER FIELD edh28
            IF g_edh.edh28 < 0 OR g_edh.edh28 > 100
               THEN CALL cl_err(g_edh.edh28,'mfg0013',0)
                    LET g_edh.edh28 = g_edh_o.edh28
                    DISPLAY BY NAME g_edh.edh28
                    NEXT FIELD edh28
            END IF
            LET g_edh_o.edh28 = g_edh.edh28

          AFTER FIELD edh25     # Warehouse
            IF NOT cl_null(g_edh.edh25) THEN
               CALL i413_edh25('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_edh.edh25,g_errno,0)
                  LET g_edh.edh25 = g_edh_o.edh25
                  DISPLAY BY NAME g_edh.edh25
                  NEXT FIELD edh25
               END IF
               IF NOT s_imfchk1(g_edh.edh03,g_edh.edh25)
                  THEN CALL cl_err(g_edh.edh25,'mfg9036',0)
                       NEXT FIELD edh25
               END IF
               CALL s_stkchk(g_edh.edh25,'A') RETURNING l_code
               IF NOT l_code THEN
                   CALL cl_err(g_edh.edh25,'mfg1100',0)
                   NEXT FIELD edh25
               END IF
               #No.FUN-AA0060 --beg add
               IF NOT s_chk_ware(g_edh.edh25) THEN  #检查仓库是否属于当前门店
                  NEXT FIELD edh25
               END IF
               #No.FUN-AA0060 --end add
            END IF
 
          AFTER FIELD edh26     # Location
            IF g_edh.edh26 IS NOT NULL AND g_edh.edh26 != ' ' THEN
               IF NOT s_imfchk(g_edh.edh03,g_edh.edh25,g_edh.edh26)
                 THEN CALL cl_err(g_edh.edh26,'mfg6095',0)
                      NEXT FIELD edh26
               END IF
            END IF
            IF g_edh.edh26 IS NULL THEN LET g_edh.edh26 = ' ' END IF
 
        AFTER INPUT
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF cl_null(g_edh.edh05) THEN
               IF g_edh.edh05 < g_edh.edh04 THEN
                  CALL cl_err(g_edh.edh05,'mfg2604',0)
                  LET l_flag = 'Y'
               END IF
            END IF
            IF cl_null(g_edh.edh10_fac) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_edh.edh10_fac
            END IF
            IF cl_null(g_edh.edh10_fac2) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_edh.edh10_fac2
            END IF
            IF cl_null(g_edh.edh27) OR g_edh.edh27 NOT MATCHES'[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_edh.edh27
            END IF
            IF cl_null(g_edh.edh18) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_edh.edh18
            END IF
            IF cl_null(g_edh.edh23) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME g_edh.edh23
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD  edh01
            END IF
		 ON KEY(F1)
			NEXT FIELD edh01
		 ON KEY(F2)
			NEXT FIELD edh06
			NEXT FIELD edh13
			NEXT FIELD edh25
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(edh01) OR INFIELD(edh011) OR INFIELD(edh013) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfd01"   
                  LET g_qryparam.default1 = g_edh.edh01
                  LET g_qryparam.default2 = g_edh.edh011
                  LET g_qryparam.default3 = g_edh.edh013
                  CALL cl_create_qry() RETURNING g_edh.edh01,g_edh.edh011,g_edh.edh013
                  DISPLAY BY NAME g_edh.edh01,g_edh.edh011,g_edh.edh013
                  NEXT FIELD CURRENT
               WHEN INFIELD(edh03) #料件主檔
#FUN-AB0025---------mod---------------str----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.default1 = g_edh.edh03
#                 CALL cl_create_qry() RETURNING g_edh.edh03
                  CALL q_sel_ima(FALSE, "q_ima","",g_edh.edh03,"","","","","",'' )
                    RETURNING g_edh.edh03
#FUN-AB0025--------mod---------------end----------------
                  DISPLAY BY NAME g_edh.edh03
                  NEXT FIELD edh03
               WHEN INFIELD(edh09) #作業主檔
                  CALL q_ecd(FALSE,TRUE,g_edh.edh09)
                       RETURNING g_edh.edh09
                  DISPLAY BY NAME g_edh.edh09
                  NEXT FIELD edh09
               WHEN INFIELD(edh10) #單位檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_edh.edh10
                  CALL cl_create_qry() RETURNING g_edh.edh10
                  DISPLAY BY NAME g_edh.edh10
                  NEXT FIELD edh10
               WHEN INFIELD(edh25) #倉庫
                 #No.FUN-AA0060 --mod beg
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_imfd"
                 #LET g_qryparam.default1 = g_edh.edh25
                 #CALL cl_create_qry() RETURNING g_edh.edh25
                  CALL q_imd_1(FALSE,TRUE,g_edh.edh25,"",g_plant,"","")  #只能开当前门店的
                    RETURNING g_edh.edh25
                 #No.FUN-AA0060 --mod end
                  DISPLAY BY NAME g_edh.edh25
                  NEXT FIELD edh25
               WHEN INFIELD(edh26) #儲位
                  #TQC-DC0018--MOD--str--
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_imfe"
                  #LET g_qryparam.default1 = g_edh.edh26
                  #CALL cl_create_qry() RETURNING g_edh.edh26
                  CALL q_ime_1(FALSE,TRUE,g_edh.edh26,g_edh.edh25,"",g_plant,"","","")
                       RETURNING g_edh.edh26
                  #TQC-DC0018--MOD--end
                  DISPLAY BY NAME g_edh.edh26
                  NEXT FIELD edh26
            END CASE

        ON ACTION CONTROLF                    # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help() 
 
 
    END INPUT
END FUNCTION
 
FUNCTION i413_edh03(p_cmd)  #元件料件
    DEFINE p_cmd     LIKE type_file.chr1,    
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima04   LIKE ima_file.ima04,
           l_ima105  LIKE ima_file.ima105,
           l_ima110  LIKE ima_file.ima110,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima04,ima25,ima63,ima37,ima08,ima70,ima105,
           ima110,imaacti,ima86,ima70 
      INTO l_ima02,l_ima021,l_ima04,g_ima25_b,g_ima63_b,g_ima37_b,
           g_ima08_b,g_ima70_b,l_ima105,l_ima110,l_imaacti,g_ima86_b,g_ima70 
      FROM ima_file WHERE ima01 = g_edh.edh03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_ima02 = NULL LET l_ima021= NULL
                                   LET l_ima105= NULL LET l_ima110= NULL
                                   LET l_imaacti = NULL
                                   LET g_ima70=NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_ima08_b = 'D' THEN LET g_edh.edh17 = 'Y'      #元件為feature flag
                       ELSE LET g_edh.edh17 = 'N'
    END IF
    #--->來源碼為'Z':雜項料件
    IF g_ima08_b ='Z' THEN LET g_errno = 'mfg2752' RETURN END IF
    IF p_cmd = 'a' THEN
      LET g_edh.edh10 = g_ima63_b
      LET g_edh.edh27 = l_ima105
      LET g_edh.edh11 = l_ima04
      DISPLAY BY NAME g_edh.edh10
      DISPLAY BY NAME g_edh.edh27
      DISPLAY BY NAME g_edh.edh11
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02 TO FORMONLY.ima02_h2
       DISPLAY l_ima021 TO FORMONLY.ima021_h2
       DISPLAY g_ima08_b TO FORMONLY.ima08_2
    END IF
END FUNCTION
 
FUNCTION i413_bdate(p_cmd)
  DEFINE   l_edh04_a,l_edh04_i LIKE edh_file.edh04,
           l_edh05_a,l_edh05_i LIKE edh_file.edh05,
           p_cmd   LIKE type_file.chr1,     
           l_n     LIKE type_file.num10      
 
    LET g_errno = " "
    IF p_cmd = 'a' THEN
       SELECT COUNT(*) INTO l_n FROM edh_file
                            WHERE edh01 = g_edh.edh01   #主件
                              AND edh011 = g_edh.edh011 
                              AND edh013 = g_edh.edh013 
                              AND  edh02 = g_edh.edh02   #項次
                              AND  edh04 = g_edh.edh04
       IF l_n >= 1 THEN  LET g_errno = 'mfg2737' RETURN END IF
    END IF
    SELECT MAX(edh04),MAX(edh05) INTO l_edh04_a,l_edh05_a
                       FROM edh_file
                      WHERE edh01 = g_edh.edh01         #主件
                        AND edh011 = g_edh.edh011 
                        AND edh013 = g_edh.edh013 
                        AND  edh02 = g_edh.edh02         #項次
                        AND  edh04 < g_edh.edh04         #生效日
    IF g_edh.edh04 <  l_edh04_a THEN LET g_errno = 'mfg2737' END IF
 
    SELECT MIN(edh04),MIN(edh05) INTO l_edh04_i,l_edh05_i
                       FROM edh_file
                      WHERE edh01 = g_edh.edh01         #主件
                        AND edh011 = g_edh.edh011 
                        AND edh013 = g_edh.edh013
                        AND  edh02 = g_edh.edh02         #項次
                        AND  edh04 > g_edh.edh04         #生效日
 
    IF l_edh04_i IS NULL AND l_edh05_i IS NULL THEN RETURN END IF
    IF l_edh04_a IS NULL AND l_edh05_a IS NULL THEN
       IF g_edh.edh04 < l_edh04_i THEN LET g_errno = 'mfg2737' END IF
    END IF
    IF g_edh.edh04 > l_edh04_i THEN LET g_errno = 'mfg2737' END IF
END FUNCTION
 
FUNCTION i413_edate(p_cmd)
  DEFINE   l_edh04_i   LIKE edh_file.edh04,
           l_edh04_a   LIKE edh_file.edh04,
           p_cmd       LIKE type_file.chr1,   
           l_n         LIKE type_file.num5     
 
    IF p_cmd = 'u' THEN
       SELECT COUNT(*) INTO l_n FROM edh_file
                      WHERE edh01 = g_edh.edh01         #主件
                        AND edh011 = g_edh.edh011 
                        AND edh013 = g_edh.edh013 
                        AND edh02 = g_edh.edh02   #項次
       IF l_n =1 THEN RETURN END IF
    END IF
    LET g_errno = " "
    SELECT MIN(edh04) INTO l_edh04_i
                       FROM edh_file
                      WHERE edh01 = g_edh.edh01         #主件
                        AND edh011 = g_edh.edh011 
                        AND edh013 = g_edh.edh013 
                       AND  edh02 = g_edh.edh02         #項次
                       AND  edh04 > g_edh.edh04         #生效日
   SELECT MAX(edh04) INTO l_edh04_a
                       FROM edh_file
                      WHERE edh01 = g_edh.edh01         #主件
                        AND edh011 = g_edh.edh011 
                        AND edh013 = g_edh.edh013 
                        AND  edh02 = g_edh.edh02         #項次
                        AND  edh04 > g_edh.edh04         #生效日
   IF l_edh04_i IS NULL THEN RETURN END IF
   IF g_edh.edh05 > l_edh04_i THEN LET g_errno = 'mfg2738' END IF
END FUNCTION
 
FUNCTION i413_edh25(p_cmd)  
    DEFINE p_cmd     LIKE type_file.chr1,      
           l_imd02   LIKE imd_file.imd02,
           l_imdacti LIKE imd_file.imdacti
 
    LET g_errno = ' '
    SELECT imd02,imdacti INTO l_imd02,l_imdacti FROM imd_file
     WHERE imd01 = g_edh.edh25
      #AND imd20 = g_plant  #No.FUN-AA0060 add  #Mark No.FUN-AB0058
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
                            LET l_imd02 = NULL
                            LET l_imdacti= NULL
         WHEN l_imdacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION i413_edh01(p_cmd)  
    DEFINE p_cmd     LIKE type_file.chr1,      
           l_sfc02   LIKE sfc_file.sfc02
 
    LET g_errno = ' '
    SELECT  sfc02 INTO l_sfc02 FROM sfc_file
            WHERE sfc01 = g_edh.edh01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-432'
                            LET l_sfc02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_sfc02 TO FORMONLY.eda02
    END IF
END FUNCTION
 
#=====>此FUNCTION 目的在update 上一筆的失效日
FUNCTION i413_update(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1,     
         l_edh02   LIKE edh_file.edh02,
         l_edh03   LIKE edh_file.edh03,
         l_edh04   LIKE edh_file.edh04,
         l_edh29   LIKE edh_file.edh29 

    DECLARE i413_update SCROLL CURSOR  FOR
            SELECT edh02,edh03,edh04,edh29 FROM edh_file
                   WHERE edh01 = g_edh.edh01 AND
                         edh011 = g_edh.edh011 AND
                         edh013 = g_edh.edh013 AND                   
                         edh02 = g_edh.edh02 AND
                         (edh04 < g_edh.edh04)       #生效日
                   ORDER BY edh04
    OPEN i413_update
    FETCH LAST i413_update INTO l_edh02,l_edh03,l_edh04,l_edh29 
    IF SQLCA.sqlcode = 0
       THEN UPDATE edh_file SET edh05 = g_edh.edh04,
                                edhmodu = g_user,    
                                edhdate = g_today, 
                                edhcomm = "asfi413" 
                          WHERE edh01 = g_edh.edh01 AND
                                edh011 = g_edh.edh011 AND
                                edh013 = g_edh.edh013 AND
                                edh02 = l_edh02 AND
                                edh03 = l_edh03 AND
                                edh04 = l_edh04 
           IF SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","edh_file",g_edh.edh01,l_edh02,"mfg2635","","",1)  
           END IF

    END IF
    CLOSE i413_update
END FUNCTION
 
FUNCTION i413_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_edh.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i413_curs()                          
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_edh.* TO NULL
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i413_count
    FETCH i413_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i413_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        LET g_msg=g_edh.edh01 CLIPPED,'+',g_edh.edh011 CLIPPED,'+',
                      g_edh.edh013 CLIPPED,'+',g_edh.edh02 CLIPPED,'+',g_edh.edh03 CLIPPED,'+',g_edh.edh04                                       
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_edh.* TO NULL
    ELSE
        CALL i413_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE " "
END FUNCTION
 
FUNCTION i413_fetch(p_fledh)
    DEFINE
        p_fledh      LIKE type_file.chr1     
 
    CASE p_fledh
        WHEN 'N' FETCH NEXT     i413_curs INTO g_edh.edh01,g_edh.edh011,g_edh.edh013,g_edh.edh02,g_edh.edh03,g_edh.edh04
        WHEN 'P' FETCH PREVIOUS i413_curs INTO g_edh.edh01,g_edh.edh011,g_edh.edh013,g_edh.edh02,g_edh.edh03,g_edh.edh04                                          
        WHEN 'F' FETCH FIRST    i413_curs INTO g_edh.edh01,g_edh.edh011,g_edh.edh013,g_edh.edh02,g_edh.edh03,g_edh.edh04                                           
        WHEN 'L' FETCH LAST     i413_curs INTO g_edh.edh01,g_edh.edh011,g_edh.edh013,g_edh.edh02,g_edh.edh03,g_edh.edh04                                              
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i413_curs INTO g_edh.edh01,g_edh.edh011,g_edh.edh013,g_edh.edh02,g_edh.edh03,g_edh.edh04                                             
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_edh.edh01 CLIPPED,'+',g_edh.edh011 CLIPPED,'+',
                  g_edh.edh013 CLIPPED,'+',g_edh.edh02 CLIPPED,'+',g_edh.edh03 CLIPPED,'+',g_edh.edh04
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_edh.* TO NULL  
        RETURN
    ELSE
       CASE p_fledh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_edh.* FROM edh_file            # 重讀DB,因TEMP有不被更新特性
     WHERE edh01=g_edh.edh01 AND edh011 = g_edh.edh011 AND edh013 = g_edh.edh013 
       AND edh02=g_edh.edh02 AND edh03=g_edh.edh03 AND edh04=g_edh.edh04 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_edh.edh01 CLIPPED,'+',g_edh.edh011 CLIPPED,'+',
                  g_edh.edh013 CLIPPED,'+',g_edh.edh02 CLIPPED,'+',g_edh.edh03 CLIPPED,'+',g_edh.edh04
        CALL cl_err3("sel","edh_file",g_msg,"",SQLCA.sqlcode,"","",1) 
    ELSE
        CALL i413_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i413_show()
DEFINE  l_ecu014   LIKE ecu_file.ecu014
DEFINE  l_ecu03    LIKE ecu_file.ecu03 

    LET g_edh_t.* = g_edh.*
    LET g_edh_o.* = g_edh.*
    DISPLAY BY NAME g_edh.edh01,g_edh.edh011,g_edh.edh013,
                    g_edh.edh02,g_edh.edh03,g_edh.edh04, 
                    g_edh.edh05,g_edh.edh10,g_edh.edh10_fac,
                    g_edh.edh10_fac2,g_edh.edh06,g_edh.edh07,
                    g_edh.edh08,g_edh.edh23,g_edh.edh11,g_edh.edh13,
                    g_edh.edh09,g_edh.edh18,g_edh.edh27,g_edh.edh28,                    
                    g_edh.edh25,g_edh.edh26,g_edh.edh24,
                    g_edh.edhmodu,g_edh.edhdate,g_edh.edhcomm
    CALL i413_edh03('d')
    CALL i413_edh01('d')
    CALL cl_show_fld_cont()                 
END FUNCTION
 
FUNCTION i413_u()
DEFINE l_sfdconf  LIKE sfd_file.sfdconf
 
    IF cl_null(g_edh.edh01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT sfdconf INTO l_sfdconf FROM sfd_file
    #WHERE sfd01=g_edh.edh01 AND sfd02=g_edh.edh02        #TQC-B30104
     WHERE sfd01=g_edh.edh01 AND sfd02=g_edh.edh011       #TQC-B30104
    IF l_sfdconf MATCHES '[YX]' THEN CALL cl_err(g_edh.edh01,'alm-638',1) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_edh01_t = g_edh.edh01
    LET g_edh011_t = g_edh.edh011
    LET g_edh013_t = g_edh.edh013
    LET g_edh02_t = g_edh.edh02
    LET g_edh03_t = g_edh.edh03
    LET g_edh04_t = g_edh.edh04
    LET g_edh_o.* = g_edh.*
 
    BEGIN WORK
    OPEN i413_curl USING g_edh.edh01,g_edh.edh011,g_edh.edh013,g_edh.edh02,g_edh.edh03,g_edh.edh04
 
    IF STATUS THEN
       CALL cl_err("OPEN i413_curl:", STATUS, 1)
       CLOSE i413_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i413_curl INTO g_edh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        LET g_msg=g_edh.edh01 CLIPPED,'+',g_edh.edh011 CLIPPED,'+',
                  g_edh.edh013 CLIPPED,'+',g_edh.edh02 CLIPPED,'+',g_edh.edh03 CLIPPED,'+',g_edh.edh04 
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i413_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_edh.edhmodu = g_user    
        LET g_edh.edhdate = g_today  
        LET g_edh.edhcomm = 'asfi413'
        CALL i413_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_edh.*=g_edh_t.*
            CALL i413_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE edh_file SET edh_file.* = g_edh.*    # 更新DB
         WHERE edh01=g_edh01_t AND edh011=g_edh011_t  AND edh013=g_edh013_t 
          AND edh02=g_edh02_t AND edh03=g_edh03_t AND edh04=g_edh04_t  
        IF SQLCA.SQLERRD[3] = 0 THEN
            LET g_msg=g_edh.edh01 CLIPPED,'+',g_edh.edh011 CLIPPED,'+',
                      g_edh.edh013 CLIPPED,'+',g_edh.edh02 CLIPPED,'+',g_edh.edh03 CLIPPED,'+',g_edh.edh04  
             CALL cl_err3("upd","edh_file",g_edh01_t,g_edh02_t,SQLCA.sqlcode,"",g_msg,1) 
            CONTINUE WHILE
        END IF
        #--->上筆生效日之處理/BOM 說明檔(bmc_file) unique key
        CALL i413_update('u')
        EXIT WHILE
    END WHILE
    CLOSE i413_curl
	COMMIT WORK
END FUNCTION
 
FUNCTION i413_r()
    DEFINE l_chr      LIKE type_file.chr1  
    DEFINE l_sfdconf  LIKE sfd_file.sfdconf
            
 
    IF cl_null(g_edh.edh01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT sfdconf INTO l_sfdconf FROM sfd_file
     WHERE sfd01=g_edh.edh01 AND sfd02=g_edh.edh02
    IF l_sfdconf MATCHES '[YX]' THEN CALL cl_err(g_edh.edh01,'alm-638',1) RETURN END IF

    BEGIN WORK
    OPEN i413_curl USING g_edh.edh01,g_edh.edh011,g_edh.edh013,g_edh.edh02,g_edh.edh03,g_edh.edh04
    IF STATUS THEN
       CALL cl_err("OPEN i413_curl:", STATUS, 1)
       CLOSE i413_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i413_curl INTO g_edh.*
    IF SQLCA.sqlcode THEN
       LET g_msg=g_edh.edh01 CLIPPED,'+',g_edh.edh011 CLIPPED,'+',g_edh.edh013 CLIPPED,'+',
                 g_edh.edh02 CLIPPED,'+',g_edh.edh03 CLIPPED,'+',g_edh.edh04 CLIPPED                
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i413_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL            
        LET g_doc.column1 = "edh01"           
        LET g_doc.value1  = g_edh.edh01       
        LET g_doc.column2 = "edh02"           
        LET g_doc.value2  = g_edh.edh02       
        LET g_doc.column3 = "edh03"           
        LET g_doc.value3  = g_edh.edh03       
        LET g_doc.column4 = "edh04"           
        LET g_doc.value4  = g_edh.edh04       
        LET g_doc.column5 = "edh011" 
        LET g_doc.value5 = g_edh.edh011
        CALL cl_del_doc()                                        
 
       DELETE FROM edh_file WHERE edh01 = g_edh.edh01
                              AND edh011= g_edh.edh011
                              AND edh013= g_edh.edh013
                              AND edh02 = g_edh.edh02
                              AND edh03 = g_edh.edh03
                              AND edh04 = g_edh.edh04

       LET g_edh.edh01 = NULL LET g_edh.edh011 = NULL LET g_edh.edh013= NULL 
       LET g_edh.edh02 = NULL LET g_edh.edh03  = NULL LET g_edh.edh04 = NULL        
       INITIALIZE g_edh.* TO NULL
       CLEAR FORM
       OPEN i413_count
       FETCH i413_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i413_curs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i413_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i413_fetch('/')
       END IF
       LET g_msg=TIME
    END IF
    CLOSE i413_curl
	COMMIT WORK
END FUNCTION

FUNCTION i413_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("edh01,edh011,edh013,edh02,edh03,edh04",TRUE)
   END IF
END FUNCTION
 
FUNCTION i413_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1     
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("edh01,edh011,edh013,edh02,edh03,edh04",FALSE) 
   END IF
   IF NOT cl_null(g_argv1) AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("edh01,edh011,edh013",FALSE)
   END IF
   IF g_sma.sma12 = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("edh26",FALSE)
   END IF

END FUNCTION
#FUN-A80054 

