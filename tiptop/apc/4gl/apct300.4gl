# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: apct300.4gl
# Descriptions...: Webservice差異调整单
# Date & Author..: No.FUN-C70116 12/08/08 By suncx
# Modify.........: No.FUN-C70116 12/08/08 By suncx 新增程序
# Modify.........: No.FUN-CB0028 12/11/20 By xumm 审核过账改为传两个参数
# Modify.........: No.FUN-CC0135 13/01/07 By xumm 增加异动单号栏位
# Modify.........: No.FUN-D40001 13/04/01 By xumm 添加一个传入参数

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapct300.global"

DEFINE g_argv1       STRING    #FUN-D40001 Add
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵

    LET g_argv1 = ARG_VAL(1)   #FUN-D40001 Add
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("APC")) THEN
        EXIT PROGRAM
    END IF
    LET p_row = 4 LET p_col = 2
   
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
    INITIALIZE g_rxs.* TO NULL
    LET g_forupd_sql = "SELECT * FROM rxs_file WHERE rxs01 = ? FOR UPDATE "    
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t300_cl CURSOR FROM g_forupd_sql 
 
    LET p_row = 5 LET p_col = 10
 
    OPEN WINDOW t300_w AT p_row,p_col WITH FORM "apc/42f/apct300"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
    LET g_action_choice = ""
   #CALL t300_menu()     #FUN-D40001 Mark

    #FUN-D40001----Add----Str 
    IF NOT cl_null(g_argv1) THEN 
       CALL t300_show()          
       CALL t300_menu()          
    ELSE                         
       CALL t300_menu()
    END IF                       
    #FUN-D40001----Add----End
    CLOSE WINDOW t300_w
 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION t300_cs()
DEFINE  lc_qbe_sn   LIKE  gbm_file.gbm01 
    CLEAR FORM
    INITIALIZE g_rxs.* TO NULL   
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        rxs01,rxs02,rxs03,rxs04,rxs05,rxsconf,rxsconu,rxscond,
        rxscont,rxsplant,rxsuser,rxsgrup,rxsoriu,rxsorig,
        rxsmodu,rxsdate,rxsacti,rxscrat          
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
        ON ACTION controlp
            CASE
                WHEN INFIELD(rxs01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form   ="q_rxs01"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rxs01
                    NEXT FIELD rxs01
                WHEN INFIELD(rxs03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form   ="q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rxs03
                    NEXT FIELD rxs03
                WHEN INFIELD(rxsconu)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form   ="q_rxsconu"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rxsconu
                    NEXT FIELD rxsconu
                WHEN INFIELD(rxsplant)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form   ="q_rxsplant"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rxsplant
                    NEXT FIELD rxsplant
                OTHERWISE
                    EXIT CASE
            END CASE
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
        ON ACTION about         
            CALL cl_about()      
        ON ACTION HELP          
            CALL cl_show_help()  
        ON ACTION controlg      
            CALL cl_cmdask()     

        ON ACTION qbe_select
            CALL cl_qbe_select()
        ON ACTION qbe_save
            CALL cl_qbe_save()
    END CONSTRUCT   
    IF INT_FLAG THEN RETURN END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rxsuser', 'rxsgrup')
    
    CONSTRUCT g_wc2 ON rxt02,rxt03,rxt04,rxt05,rxt06,rxt16,rxt07,rxt08,
                       rxt09,rxt10,rxt11,rxt12,rxt13,rxt18,rxt14,rxt15,rxt17     #FUN-CC0135 add rxt18
                  FROM s_rxt[1].rxt02,s_rxt[1].rxt03,s_rxt[1].rxt04,
                       s_rxt[1].rxt05,s_rxt[1].rxt06,s_rxt[1].rxt16,
                       s_rxt[1].rxt07,s_rxt[1].rxt08,s_rxt[1].rxt09,
                       s_rxt[1].rxt10,s_rxt[1].rxt11,s_rxt[1].rxt12,
                       s_rxt[1].rxt13,s_rxt[1].rxt18,s_rxt[1].rxt14,s_rxt[1].rxt15,  #FUN-CC0135 add s_rxt[1].rxt18
                       s_rxt[1].rxt17
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
        ON ACTION controlp
            CASE 
                WHEN INFIELD(rxt03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form   = "q_azw01_2"
                    LET g_qryparam.arg1   = g_plant
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rxt03
                    NEXT FIELD rxt03
                OTHERWISE
                    EXIT CASE
            END CASE 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
        ON ACTION about         
            CALL cl_about()      
 
        ON ACTION HELP         
            CALL cl_show_help()
 
        ON ACTION controlg   
            CALL cl_cmdask() 
 
        ON ACTION qbe_save                        
            CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN 
        RETURN
    END IF
    
    LET g_wc2 = g_wc2 CLIPPED
    IF g_wc2 = " 1=1" THEN        
       LET g_sql = "SELECT DISTINCT rxs01 FROM rxs_file ", 
                   " WHERE ",g_wc CLIPPED,
                   " ORDER BY rxs01"
    ELSE                                 
       LET g_sql = "SELECT UNIQUE rxs01",
                   " FROM rxs_file,rxt_file",
                   " WHERE rxs01 = rxt01 ",
                   "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " ORDER BY rxs01"
    END IF    
    PREPARE t300_prepare FROM g_sql
    DECLARE t300_cs SCROLL CURSOR WITH HOLD FOR t300_prepare
    IF g_wc2=" 1=1" THEN
       LET g_sql="SELECT COUNT(*) FROM rxs_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(*) FROM ",
                 "(SELECT DISTINCT rxs_file.rxs01 ",
                 "   FROM rxs_file,rxt_file ",
                 "  WHERE rxs01 = rxt01 ",
                 "    AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,")"
    END IF 
    PREPARE t300_precount FROM g_sql
    DECLARE t300_count CURSOR FOR t300_precount  
END FUNCTION

FUNCTION t300_menu()
   WHILE TRUE
      CALL t300_bp("G")
      CASE g_action_choice
         WHEN "get_data"
            IF cl_chk_act_auth() THEN
                CALL t300_get_data()
            END IF
         WHEN "confirm"          #審核
            IF cl_chk_act_auth() THEN
                #CALL t300sub_y(g_rxs.rxs01)      #FUN-CB0028 mark
                CALL t300sub_y(g_rxs.rxs01,TRUE)  #FUN-CB0028 add
                CALL t300_refresh()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t300sub_z(g_rxs.rxs01)
               CALL t300_refresh()
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               #CALL t300sub_s(g_rxs.rxs01)       #FUN-CB0028 mark
               CALL t300sub_s(g_rxs.rxs01,TRUE)   #FUN-CB0028 add
               CALL t300_refresh()
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t300sub_w()
               CALL t300_refresh()
            END IF
         WHEN "related_document"   
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_rxs.rxs01) THEN
                  LET g_doc.column1 = "rxs01"
                  LET g_doc.value1 = g_rxs.rxs01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t300_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t300_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t300_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t300_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t300_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t300_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rxt),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION 

FUNCTION t300_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF 
   LET g_action_choice = '' 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rxt TO s_rxt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
      ON ACTION get_data
         lET g_action_choice="get_data"   #抓取數據
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"   #確認
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"   #取消確認
         EXIT DISPLAY
      ON ACTION post
         LET g_action_choice="post"   #過賬
         EXIT DISPLAY
      ON ACTION undo_post
         LET g_action_choice="undo_post"   #過賬
         EXIT DISPLAY  
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t300_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
            CALL t300_fetch('P')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL t300_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
            CALL t300_fetch('N')
            CALL cl_navigator_setting(g_curs_index,g_row_count)
            CALL fgl_set_arr_curr(1)
            ACCEPT DISPLAY 
         END IF
      ON ACTION LAST
         CALL t300_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY     
      ON ACTION related_document
         LET g_action_choice="related_document"
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
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about         
         CALL cl_about() 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION controls                    
         CALL cl_set_head_visible("","AUTO")  
      AFTER DISPLAY
         CONTINUE DISPLAY 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)  
END FUNCTION

FUNCTION t300_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    CLEAR FORM 
    CALL g_rxt.clear()      
    MESSAGE ""   
    DISPLAY ' ' TO FORMONLY.cnt    
    CALL t300_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       CALL g_rxt.clear()
       RETURN
    END IF
    OPEN t300_cs 
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       CALL g_rxt.clear()
    ELSE
       OPEN t300_count
       FETCH t300_count INTO g_row_count
       IF g_row_count>0 THEN
          DISPLAY g_row_count TO FORMONLY.cn3                                 
          CALL t300_fetch('F') 
       ELSE 
          CALL cl_err('',100,0)
       END IF             
    END IF
END FUNCTION

FUNCTION t300_fetch(p_flrxs)
DEFINE p_flrxs         LIKE type_file.chr1           
    CASE p_flrxs
        WHEN 'N' FETCH NEXT     t300_cs INTO g_rxs.rxs01
        WHEN 'P' FETCH PREVIOUS t300_cs INTO g_rxs.rxs01
        WHEN 'F' FETCH FIRST    t300_cs INTO g_rxs.rxs01
        WHEN 'L' FETCH LAST     t300_cs INTO g_rxs.rxs01
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
                  LET g_jump = g_curs_index
                  EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t300_cs INTO g_rxs.rxs01
            LET g_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rxs.rxs01,SQLCA.sqlcode,0)
        INITIALIZE g_rxs.* TO NULL  
        RETURN
    ELSE
      CASE p_flrxs
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.cnt                 
    END IF
 
    SELECT * INTO g_rxs.* FROM rxs_file    
     WHERE rxs01 = g_rxs.rxs01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rxs_file","","",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_rxs.rxsuser           
        LET g_data_group=g_rxs.rxsgrup
        LET g_data_plant=g_rxs.rxsplant 
        CALL t300_show()                   
    END IF
END FUNCTION

FUNCTION t300_show()
    DEFINE  l_rxs03_desc    LIKE gen_file.gen02
    DEFINE  l_rxsconu_desc  LIKE gen_file.gen02
    DEFINE  l_gen03         LIKE gen_file.gen03 
    DEFINE  l_gen03_desc    LIKE gem_file.gem03
    DEFINE  l_rxsplant_desc LIKE azp_file.azp02
    LET g_rxs_t.* = g_rxs.*
    #FUN-D40001------Add-----Str
    IF NOT cl_null(g_argv1) THEN
       LET g_sql = " SELECT * FROM rxs_file ",
                   "  WHERE rxs01 = '",g_argv1,"'"
       PREPARE t300_argv1_pb FROM g_sql
       EXECUTE t300_argv1_pb INTO g_rxs.*
       LET g_argv1 = NULL
    END IF
    #FUN-D40001------Add-----End
    DISPLAY BY NAME g_rxs.rxs01,g_rxs.rxs02,g_rxs.rxs03,g_rxs.rxs04,
                    g_rxs.rxs05,g_rxs.rxsconf,g_rxs.rxsconu,g_rxs.rxscond,
                    g_rxs.rxscont,g_rxs.rxspost,g_rxs.rxsplant,g_rxs.rxsuser,
                    g_rxs.rxsgrup,g_rxs.rxsoriu,g_rxs.rxsorig,g_rxs.rxsmodu,
                    g_rxs.rxsdate,g_rxs.rxsacti,g_rxs.rxscrat
    SELECT gen02,gen03 INTO l_rxs03_desc,l_gen03 FROM gen_file WHERE gen01=g_rxs.rxs03
    SELECT gem02 INTO l_gen03_desc FROM gem_file WHERE gem01=l_gen03
    SELECT gen02 INTO l_rxsconu_desc FROM gen_file WHERE gen01=g_rxs.rxsconu
    SELECT azp02 INTO l_rxsplant_desc FROM azp_file WHERE azp01=g_rxs.rxsplant

    DISPLAY l_rxs03_desc TO FORMONLY.rxs03_desc
    DISPLAY l_gen03 TO gen03
    DISPLAY l_gen03_desc TO FORMONLY.gen03_desc
    DISPLAY l_rxsconu_desc TO FORMONLY.rxsconu_desc
    DISPLAY l_rxsplant_desc TO FORMONLY.rxsplant_desc
    CALL t300_b_fill(g_wc2) 
    CALL cl_show_fld_cont() 
    CALL t300_pic()    
END FUNCTION

FUNCTION t300_refresh()
    DEFINE  l_rxs03_desc    LIKE gen_file.gen02
    DEFINE  l_rxsconu_desc  LIKE gen_file.gen02
    DEFINE  l_gen03         LIKE gen_file.gen03 
    DEFINE  l_gen03_desc    LIKE gem_file.gem03
    DEFINE  l_rxsplant_desc LIKE azp_file.azp02
    
    SELECT * INTO g_rxs.* FROM rxs_file WHERE rxs01=g_rxs.rxs01
    DISPLAY BY NAME g_rxs.rxs01,g_rxs.rxs02,g_rxs.rxs03,g_rxs.rxs04,
                    g_rxs.rxs05,g_rxs.rxsconf,g_rxs.rxsconu,g_rxs.rxscond,
                    g_rxs.rxscont,g_rxs.rxspost,g_rxs.rxsplant,g_rxs.rxsuser,
                    g_rxs.rxsgrup,g_rxs.rxsoriu,g_rxs.rxsorig,g_rxs.rxsmodu,
                    g_rxs.rxsdate,g_rxs.rxsacti,g_rxs.rxscrat
    SELECT gen02,gen03 INTO l_rxs03_desc,l_gen03 FROM gen_file WHERE gen01=g_rxs.rxs03
    SELECT gem02 INTO l_gen03_desc FROM gem_file WHERE gem01=l_gen03
    SELECT gen02 INTO l_rxsconu_desc FROM gen_file WHERE gen01=g_rxs.rxsconu
    SELECT azp02 INTO l_rxsplant_desc FROM azp_file WHERE azp01=g_rxs.rxsplant

    DISPLAY l_rxs03_desc TO FORMONLY.rxs03_desc
    DISPLAY l_gen03 TO gen03
    DISPLAY l_gen03_desc TO FORMONLY.gen03_desc
    DISPLAY l_rxsconu_desc TO FORMONLY.rxsconu_desc
    DISPLAY l_rxsplant_desc TO FORMONLY.rxsplant_desc
    CALL t300_pic()
END FUNCTION

FUNCTION t300_b_fill(p_wc2)              
    DEFINE   p_wc2       STRING
    DEFINE   l_sql       STRING

    LET g_sql = "SELECT rxt02,rxt03,rxt04,rxt05,rxt06,rxt16,rxt07,rxt08,rxt09,",
                "       rxt10,rxt11,rxt12,rxt13,rxt18,rxt14,rxt15,rxt17 ",        #FUN-CC0135 add rxt18
                "  FROM rxt_file ",
                " WHERE rxt01 = '",g_rxs.rxs01,"'"
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql =g_sql CLIPPED,' ORDER BY rxt02'
    PREPARE t300_pb FROM g_sql
    DECLARE rxt_cs1 CURSOR FOR t300_pb 
    CALL g_rxt.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"

    FOREACH rxt_cs1 INTO g_rxt[g_cnt].*  
       IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH 
    CALL g_rxt.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION 

FUNCTION t300_a()
   DEFINE  li_result  LIKE type_file.num5
   DEFINE  l_gen02    LIKE gen_file.gen02 
   DEFINE  l_azp02    LIKE azp_file.azp02
   DEFINE  l_azp02_1  LIKE azp_file.azp02
   DEFINE  l_gen03      LIKE gen_file.gen03,
           l_rxs03_desc LIKE gen_file.gen02,
           l_gen03_desc LIKE gem_file.gem02 
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rxt.clear()
   LET g_wc = NULL 
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF   
 
   INITIALIZE g_rxs.* LIKE rxs_file.*                  
   LET g_rxs_t.* = g_rxs.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_rxs.rxs02 = g_today
      LET g_rxs.rxs03 = g_user 
      LET l_gen03 = g_grup    
      LET g_rxs.rxs05 = '0'   
      LET g_rxs.rxsconf = 'N'      #審核碼
      LET g_rxs.rxsplant = g_plant #所屬營運中心
      LET g_rxs.rxsacti  ='Y'
      LET g_rxs.rxsoriu = g_user     
      LET g_rxs.rxsorig = g_grup 
      LET g_rxs.rxsuser  = g_user
      LET g_rxs.rxsgrup  = g_grup
      LET g_rxs.rxscrat  = g_today
      LET g_rxs.rxslegal = g_legal
      LET g_rxs.rxsmksg = 'N'
      LET g_rxs.rxspost = 'N'
      SELECT gen02 INTO l_rxs03_desc
        FROM gen_file WHERE gen01=g_rxs.rxs03
      SELECT gem02 INTO l_gen03_desc 
        FROM gem_file WHERE gem01=l_gen03
      DISPLAY l_rxs03_desc TO FORMONLY.rxs03_desc
      DISPLAY l_gen03 TO gen03
      DISPLAY l_gen03_desc TO FORMONLY.gen03_desc
      
      CALL t300_i("a")                          
      IF INT_FLAG THEN                          
         INITIALIZE g_rxs.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rxs.rxs01) THEN       
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
      CALL s_auto_assign_no("art",g_rxs.rxs01,g_today,"F4","rxs_file","rxs01","","","") 
      RETURNING li_result,g_rxs.rxs01 
      IF (NOT li_result) THEN  CONTINUE WHILE  END IF 
      DISPLAY BY NAME g_rxs.rxs01
      INSERT INTO rxs_file VALUES (g_rxs.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                     
         CALL cl_err3("ins","rxs_file",g_rxs.rxs01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF 
      LET g_rxs_t.* = g_rxs.*
      CALL g_rxt.clear()
 
      LET g_rec_b = 0  
      CALL t300sub_b_g()                  
      EXIT WHILE
   END WHILE
   CALL t300_show()
END FUNCTION

FUNCTION t300_i(p_cmd) 
DEFINE p_cmd        LIKE type_file.chr1
DEFINE li_result    LIKE type_file.num5
DEFINE l_gen03      LIKE gen_file.gen03,
       l_rxs03_desc LIKE gen_file.gen02,
       l_gen03_desc LIKE gem_file.gem02 
       
    DISPLAY BY NAME g_rxs.rxs01,g_rxs.rxs02,g_rxs.rxs03,g_rxs.rxs04,
                    g_rxs.rxs05,g_rxs.rxsconf,g_rxs.rxsconu,g_rxs.rxscond,
                    g_rxs.rxscont,g_rxs.rxsplant,g_rxs.rxsuser,g_rxs.rxsgrup,
                    g_rxs.rxsoriu,g_rxs.rxsorig,g_rxs.rxsmodu,g_rxs.rxsdate,
                    g_rxs.rxsacti,g_rxs.rxscrat
    INPUT BY NAME g_rxs.rxs01,g_rxs.rxs02,g_rxs.rxs03,g_rxs.rxs04,
                  g_rxs.rxsuser,g_rxs.rxsgrup,g_rxs.rxsmodu,
                  g_rxs.rxsdate,g_rxs.rxsacti
        WITHOUT DEFAULTS

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t300_set_entry(p_cmd)
            CALL t300_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("rxs01")

        AFTER FIELD rxs01
            IF g_rxs.rxs01 IS NOT NULL THEN 
                IF p_cmd = "a" OR (p_cmd = "u" AND g_rxs.rxs01 != g_rxs_t.rxs01) THEN      
                    CALL s_check_no("art",g_rxs.rxs01,g_rxs_t.rxs01,"F4","rxs_file","rxs01","")
                        RETURNING li_result,g_rxs.rxs01
                    IF (NOT li_result) THEN
                        LET g_rxs.rxs01=g_rxs_t.rxs01
                        NEXT FIELD rxs01
                    END IF
                END IF  
            END IF

        AFTER FIELD rxs03
            IF NOT cl_null(g_rxs.rxs03) THEN 
               IF p_cmd = "a" OR (p_cmd = "u" AND g_rxs.rxs03 != g_rxs_t.rxs03) THEN
                   SELECT gen02,gen03 INTO l_rxs03_desc,l_gen03 
                     FROM gen_file WHERE gen01=g_rxs.rxs03
                   SELECT gem02 INTO l_gen03_desc 
                     FROM gem_file WHERE gem01=l_gen03
                   DISPLAY l_rxs03_desc TO FORMONLY.rxs03_desc
                   DISPLAY l_gen03 TO gen03
                   DISPLAY l_gen03_desc TO FORMONLY.gen03_desc
               END IF 
            END IF 

        AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_rxs.rxs01 IS NULL THEN
               DISPLAY BY NAME g_rxs.rxs01
            END IF

        ON ACTION CONTROLO                        # 沿用所有欄位
            IF INFIELD(rxs01) THEN
                LET g_rxs.* = g_rxs_t.*
                CALL t300_show()
                NEXT FIELD rxs01
            END IF

        ON ACTION controlp
            CASE
                WHEN INFIELD(rxs01)
                    LET g_rxs.rxs01=s_get_doc_no(g_rxs.rxs01)
                    CALL q_oay(FALSE,FALSE,g_rxs.rxs01,'F4','art') RETURNING g_rxs.rxs01
                    DISPLAY BY NAME g_rxs.rxs01
                    NEXT FIELD rxs01
                WHEN INFIELD(rxs03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_rxs.rxs03
                    CALL cl_create_qry() RETURNING g_rxs.rxs03
                    DISPLAY BY NAME g_rxs.rxs03
                    NEXT FIELD rxs03
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

        ON ACTION HELP        
            CALL cl_show_help()

    END INPUT
END FUNCTION

FUNCTION t300_b() 
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,    #檢查重複用
    l_i             LIKE type_file.num10,
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  
    p_cmd           LIKE type_file.chr1,    #處理狀態 
    l_allow_insert  LIKE type_file.num5,    #可新增否 
    l_allow_delete  LIKE type_file.num5     #可刪除否
DEFINE l_rxt07      LIKE rxt_file.rxt07

    LET g_action_choice = ""
    IF s_shut(0) THEN
        RETURN
    END IF
 
    IF g_rxs.rxs01 IS NULL THEN
        RETURN
    END IF
 
    SELECT * INTO g_rxs.* FROM rxs_file
     WHERE rxs01=g_rxs.rxs01
 
    #檢查資料是否已確認
    IF g_rxs.rxsconf='Y' THEN
        CALL cl_err(g_rxs.rxsconf,'9003',0)
        RETURN
    END IF
 
    #檢查資料是否已作廢
    IF g_rxs.rxsconf='X' THEN
        CALL cl_err(g_rxs.rxsconf,'9024',0)
        RETURN
    END IF
 
    IF g_rxs.rxs05 MATCHES '[Ss1]' THEN   
        CALL cl_err("","mfg3557",0)
        RETURN
    END IF
 
    IF g_rxs.rxsacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_rxs.rxs01,'mfg1000',0)
        RETURN
    END IF

    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT rxt02,rxt03,rxt04,rxt05,rxt06,rxt16,rxt07,rxt08,rxt09,",
                       "       rxt10,rxt11,rxt12,rxt13,rxt18,rxt14,rxt15,rxt17 ",        #FUN-CC0135 add rxt18
                       "  FROM rxt_file ",
                       " WHERE rxt01 = ? AND rxt02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = cl_detail_input_auth("delete")
    
    INPUT ARRAY g_rxt WITHOUT DEFAULTS FROM s_rxt.*
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
           BEGIN WORK
           OPEN t300_cl USING g_rxs.rxs01
           IF STATUS THEN
              CALL cl_err("OPEN t300_cl:", STATUS, 1)
              CLOSE t300_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t300_cl INTO g_rxs.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_rxs.rxs01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t300_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_rxt_t.* = g_rxt[l_ac].*  #BACKUP
              LET g_rxt_o.* = g_rxt[l_ac].*  #BACKUP
              OPEN t300_bcl USING g_rxs.rxs01,g_rxt_t.rxt02
              IF STATUS THEN
                 CALL cl_err("OPEN t300_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t300_bcl INTO g_rxt[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_rxt_t.rxt02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL t300_set_entry_b(p_cmd)      
              CALL t300_set_no_entry_b(p_cmd)   
              CALL cl_show_fld_cont()
           END IF 
           
        BEFORE DELETE                            #是否取消單身
            IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
            END IF
            LET g_success = 'Y'
            DELETE FROM rxt_file
             WHERE rxt01=g_rxs.rxs01
               AND rxt07=g_rxt_t.rxt07
            LET l_i = SQLCA.sqlerrd[3]
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rxt_file",g_rxs.rxs01,g_rxt_t.rxt07,SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
            END IF

            LET l_rxt07 = "'",g_rxt_t.rxt07,"'"
            CALL t300sub_upd_tk_wslog(l_rxt07,'2')
            IF g_success = 'N' THEN 
                ROLLBACK WORK
                CANCEL DELETE 
            END IF

            CALL t300sub_upd_rxu(l_rxt07,'2')
            IF g_success = 'N' THEN  
                ROLLBACK WORK
                CANCEL DELETE 
            END IF

            LET g_rec_b=g_rec_b-l_i
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
            CALL t300_b_fill(g_wc2) 
            
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd = 'u' THEN
                   LET g_rxt[l_ac].* = g_rxt_t.*
                END IF
                CLOSE t300_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             CLOSE t300_bcl
             COMMIT WORK
             
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rxt02) AND l_ac > 1 THEN
                LET g_rxt[l_ac].* = g_rxt[l_ac-1].*
                LET g_rxt[l_ac].rxt02 = NULL 
                NEXT FIELD rxt02
            END IF
            
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
 
        ON ACTION controls   
            CALL cl_set_head_visible("","AUTO") 
    END INPUT 
    CLOSE t300_bcl
    COMMIT WORK
    CALL t300_delHeader()
END FUNCTION

FUNCTION t300_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM rxs_file WHERE rxs01 = g_rxs.rxs01
         INITIALIZE g_rxs.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION

FUNCTION t300_u()  

    IF s_shut(0) THEN RETURN END IF
    IF g_rxs.rxs01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_rxs.* FROM rxs_file WHERE rxs01=g_rxs.rxs01
    IF g_rxs.rxsconf = 'Y' THEN CALL cl_err('','9023',1) RETURN END IF 
    IF g_rxs.rxspost = 'Y' THEN CALL cl_err('','mfg0175',1) RETURN END IF
    IF g_rxs.rxsconf = 'X'   THEN CALL cl_err('','9024',1) RETURN END IF
    IF g_rxs.rxs05 MATCHES '[Ss]' THEN
         CALL cl_err('','apm-030',0) #送簽中, 不可修改資料!
         RETURN
    END IF
    IF g_rxs.rxsconf='Y' AND g_rxs.rxs05 = "1" AND g_rxs.rxsmksg = "Y"  THEN
       CALL cl_err('','mfg3168',0)   #此張單據已核准, 不允許更改或取消
       RETURN
    END IF

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rxs_o.* = g_rxs.*
 
    BEGIN WORK
 
    OPEN t300_cl USING g_rxs.rxs01                
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_rxs.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rxs.rxs01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t300_cl ROLLBACK WORK RETURN
    END IF
    CALL t300_show()
    WHILE TRUE
        LET g_rxs.rxsmodu=g_user           
        LET g_rxs.rxsdate=g_today             
        CALL t300_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rxs.*=g_rxs_t.*
            CALL t300_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF          

        UPDATE rxs_file SET * = g_rxs.* WHERE rxs01 = g_rxs_o.rxs01     
        IF STATUS THEN 
           CALL cl_err3("upd","rxs_file",g_rxs_t.rxs01,"",STATUS,"","",1)
           CONTINUE WHILE END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t300_cl
    COMMIT WORK
    CALL t300_show()                          #顯示最新資料 
    CALL cl_flow_notify(g_rxs.rxs01,'U')
END FUNCTION

FUNCTION t300_r()
DEFINE l_rxt07     LIKE rxt_file.rxt07
DEFINE l_rxt07_rxu STRING 
DEFINE l_rxt07_tk  STRING 
DEFINE l_n         LIKE type_file.num5

    IF s_shut(0) THEN
        RETURN
    END IF
 
    IF g_rxs.rxs01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF

    SELECT * INTO g_rxs.* FROM rxs_file
     WHERE rxs01=g_rxs.rxs01
 
    #檢查資料是否已確認
    IF g_rxs.rxsconf='Y' THEN CALL cl_err('','9003',0) RETURN END IF
    #檢查資料是否已作廢
    IF g_rxs.rxsconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_rxs.rxspost='Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_rxs.rxs05 MATCHES '[Ss]' THEN CALL cl_err("","aws-200",0) RETURN END IF

    BEGIN WORK

    LET g_success = 'Y'
 
    OPEN t300_cl USING g_rxs.rxs01
    IF STATUS THEN
        CALL cl_err("OPEN t300_cl:", STATUS, 1)
        CLOSE t300_cl
        ROLLBACK WORK
        RETURN
    END IF

    FETCH t300_cl INTO g_rxs.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rxs.rxs01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t300_show() 
    
    IF cl_delh(0,0) THEN
        CALL t300_b_upd()
        IF g_success = 'N' THEN
            ROLLBACK WORK
            RETURN
        END IF 

        DELETE FROM rxs_file WHERE rxs01 = g_rxs.rxs01
        DELETE FROM rxt_file WHERE rxt01 = g_rxs.rxs01
        CLEAR FORM
        CALL g_rxt.clear()
        OPEN t300_count
        IF STATUS THEN
            CLOSE t300_cs
            CLOSE t300_count
            COMMIT WORK
            RETURN
        END IF
    
        FETCH t300_count INTO g_row_count
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t300_cs
            CLOSE t300_count
            COMMIT WORK
            RETURN
        END IF
        DISPLAY g_row_count TO FORMONLY.cn3
        OPEN t300_cs
        IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t300_fetch('L')
        ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t300_fetch('/')
        END IF
    END IF 
 
    CLOSE t300_cl
    COMMIT WORK
    
END FUNCTION

FUNCTION t300_b_upd()
DEFINE l_rxt07     LIKE rxt_file.rxt07
DEFINE l_rxt07_rxu STRING 
DEFINE l_rxt07_tk  STRING 
DEFINE l_n         LIKE type_file.num5

    IF g_rxs.rxs01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    
    INITIALIZE l_rxt07_tk TO NULL
    INITIALIZE l_rxt07_rxu TO NULL
    
    SELECT COUNT(*) INTO l_n FROM rxt_file
      WHERE rxt01=g_rxs.rxs01
    IF l_n = 0 THEN RETURN END IF 
      
    DECLARE rxt_curs CURSOR WITH HOLD FOR 
     SELECT DISTINCT rxt07 FROM rxt_file
      WHERE rxt01=g_rxs.rxs01
    FOREACH rxt_curs INTO l_rxt07
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #組rxu01條件
        IF cl_null(l_rxt07_rxu) THEN 
           LET l_rxt07_rxu = "'",l_rxt07,"'"
        ELSE 
           LET l_rxt07_rxu = l_rxt07_rxu,",'",l_rxt07,"'"
        END IF 
        #組中間庫trans_id條件
        CALL cl_replace_str(l_rxt07, "-", "") RETURNING l_rxt07
        IF cl_null(l_rxt07_tk) THEN 
           LET l_rxt07_tk = "'",l_rxt07,"'"
        ELSE 
           LET l_rxt07_tk = l_rxt07_tk,",'",l_rxt07,"'"
        END IF 
    END FOREACH 
    CALL t300sub_upd_tk_wslog(l_rxt07_tk,'2')
    IF g_success = 'N' THEN RETURN END IF 
    CALL t300sub_upd_rxu(l_rxt07_rxu,'2')
    IF g_success = 'N' THEN RETURN END IF 
END FUNCTION 

FUNCTION t300_out()
END FUNCTION

FUNCTION t300_x()
   DEFINE  l_rxt           RECORD LIKE rxt_file.*
 
    IF g_rxs.rxs01 IS NULL THEN RETURN END IF
    SELECT * INTO g_rxs.* FROM rxs_file
     WHERE rxs01=g_rxs.rxs01
    IF g_rxs.rxsconf='Y' THEN CALL cl_err('','atm-046',1) RETURN END IF   
    #非開立狀態，不可異動！             
    IF g_rxs.rxs05 MATCHES '[Ss1]' THEN         
        CALL cl_err("","mfg3557",0)
        RETURN
    END IF
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t300_cl USING g_rxs.rxs01
    IF STATUS THEN
        CALL cl_err("OPEN t300_cl:", STATUS, 1)
        CLOSE t300_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    FETCH t300_cl INTO g_rxs.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rxs.rxs01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    IF cl_void(0,0,g_rxs.rxsconf) THEN
        IF g_rxs.rxsconf ='N' THEN
            LET g_rxs.rxsconf='X'
            LET g_rxs.rxs05='9'           
        ELSE
            LET g_rxs.rxsconf='N'
            LET g_rxs.rxs05='0'           
        END IF
        UPDATE rxs_file SET
               rxsconf=g_rxs.rxsconf,
               rxsmodu=g_user,
               rxsdate=g_today,
               rxs05  =g_rxs.rxs05         
         WHERE rxs01=g_rxs.rxs01
        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","rxs_file",g_rxs.rxs01,"","apm-266","","upd rxs_file",1) 
            LET g_success='N'
        END IF
    END IF
 
    IF g_success = 'Y' THEN
        COMMIT WORK
        CALL cl_flow_notify(g_rxs.rxs01,'V')
        DISPLAY BY NAME g_rxs.rxsconf
        DISPLAY BY NAME g_rxs.rxs05
    ELSE
        LET g_rxs.rxsconf= g_rxs_t.rxsconf
        LET g_rxs.rxs05 = g_rxs_t.rxs05
        DISPLAY BY NAME g_rxs.rxsconf
        DISPLAY BY NAME g_rxs.rxs05
        ROLLBACK WORK
    END IF
 
    SELECT rxsconf,rxsmodu,rxsdate
      INTO g_rxs.rxsconf,g_rxs.rxsmodu,g_rxs.rxsdate FROM rxs_file
     WHERE rxs01=g_rxs.rxs01
 
    DISPLAY BY NAME g_rxs.rxsconf,g_rxs.rxsmodu,g_rxs.rxsdate
    CALL t300_pic()      
END FUNCTION 

FUNCTION t300_set_entry(p_cmd) 
DEFINE p_cmd   LIKE type_file.chr1  
   IF p_cmd = 'a' THEN 
      CALL cl_set_comp_entry("rxs01,rxs02,rxs03,rxs04",TRUE) 
   END IF 
   IF p_cmd = 'u' THEN 
      CALL cl_set_comp_entry("rxs02,rxs03,rxs04",TRUE) 
   END IF 
END FUNCTION

FUNCTION t300_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1 
   IF p_cmd = 'u' THEN 
      CALL cl_set_comp_entry("rxs01",FALSE) 
   END IF 
END FUNCTION

FUNCTION t300_pic()
 
    IF g_rxs.rxsconf='X' THEN
        LET g_chr='Y'
    ELSE
        LET g_chr='N'
    END IF
 
    IF g_rxs.rxs05='1' THEN
        LET g_chr2='Y'
    ELSE
        LET g_chr2='N'
    END IF
 
    CALL cl_set_field_pic(g_rxs.rxsconf,g_chr2,g_rxs.rxspost,"",g_chr,g_rxs.rxsacti)
END FUNCTION

FUNCTION t300_set_entry_b(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    
    CALL cl_set_comp_entry("rxt03,rxt04,rxt05,rxt06,rxt07,rxt08,rxt09,
                           rxt10,rxt11,rxt12,rxt13,rxt14,rxt15,rxt16,rxt17",TRUE) 
END FUNCTION
 
FUNCTION t300_set_no_entry_b(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    
    CALL cl_set_comp_entry("rxt03,rxt04,rxt05,rxt06,rxt07,rxt08,rxt09,
                           rxt10,rxt11,rxt12,rxt13,rxt14,rxt15,rxt16,rxt17",FALSE)
END FUNCTION

FUNCTION t300_get_data()
DEFINE l_cnt LIKE type_file.num10

    IF cl_null(g_rxs.rxs01) THEN 
        CALL cl_err('',-400,0)
        RETURN 
    END IF 
     SELECT * INTO g_rxs.* FROM rxs_file
     WHERE rxs01=g_rxs.rxs01
 
    #檢查資料是否已確認
    IF g_rxs.rxsconf='Y' THEN
        CALL cl_err(g_rxs.rxsconf,'9003',0)
        RETURN
    END IF
 
    #檢查資料是否已作廢
    IF g_rxs.rxsconf='X' THEN
        CALL cl_err(g_rxs.rxsconf,'9024',0)
        RETURN
    END IF
 
    IF g_rxs.rxsacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_rxs.rxs01,'mfg1000',0)
        RETURN
    END IF
    
    IF g_rxs.rxs05 MATCHES '[Ss1]' THEN   
        CALL cl_err("","mfg3557",0)
        RETURN
    END IF

    SELECT COUNT(*) INTO l_cnt FROM rxt_file WHERE rxt01= g_rxs.rxs01
    IF l_cnt>0 THEN 
       IF cl_confirm('apc-205') THEN
           BEGIN WORK 
           LET g_success = 'Y'
           OPEN t300_cl USING g_rxs.rxs01
           IF STATUS THEN
               CALL cl_err("OPEN t300_cl:", STATUS, 1)
               CLOSE t300_cl
               ROLLBACK WORK
               RETURN
           END IF

           FETCH t300_cl INTO g_rxs.*               # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
               CALL cl_err(g_rxs.rxs01,SQLCA.sqlcode,0)          #資料被他人LOCK
               ROLLBACK WORK
               RETURN
           END IF
           CALL t300_b_upd() 
           IF g_success = 'N' THEN 
               ROLLBACK WORK
               RETURN
           END IF
        
           DELETE FROM rxt_file WHERE rxt01=g_rxs.rxs01 
           IF SQLCA.sqlcode THEN 
               CALL cl_err(g_rxs.rxs01,SQLCA.sqlcode,0)    
               ROLLBACK WORK
               RETURN
           END IF
           COMMIT WORK 
       END IF
    END IF 
   
    CALL t300sub_b_g()
    CALL t300_show()
END FUNCTION  
#FUN-C70116
