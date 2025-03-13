# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almt160.4gl
# Descriptions...: 場攤關系維護作業
# Date & Author..: NO.FUN-870010 08/07/08 By lilingyu
# Modify.........: No.FUN-960134 09/06/30 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/25 By shiwuying 加oriu,orig
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30075 10/03/16 By shiwuying SQL后加SQLCA.SQLCODE判斷
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:TQC-A70076 10/07/16 By liuxqa call cl_err中的信息错误。
# Modify.........: No:TQC-A60124 10/08/03 By lilingyu 未錄入單身,取消單頭資料時,畫面上仍然有值
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lmg         RECORD LIKE lmg_file.*,     
       g_lmg_t       RECORD LIKE lmg_file.*,    
       g_lmg_o       RECORD LIKE lmg_file.*,   
       g_lmg01_t     LIKE lmg_file.lmg01, 
       g_lmg02_t     LIKE lmg_file.lmg02,    
       g_lmh         DYNAMIC ARRAY OF RECORD    
          lmh03      LIKE lmh_file.lmh03,
          lmh04      LIKE lmh_file.lmh04,
          lmh05      LIKE lmh_file.lmh05,
          lmh06      LIKE lmh_file.lmh06         
                     END RECORD,
       g_lmh_t       RECORD      
          lmh03      LIKE lmh_file.lmh03,
          lmh04      LIKE lmh_file.lmh04,
          lmh05      LIKE lmh_file.lmh05,
          lmh06      LIKE lmh_file.lmh06         
                     END RECORD,              
        g_lmh_o      RECORD         
          lmh03      LIKE lmh_file.lmh03,
          lmh04      LIKE lmh_file.lmh04,
          lmh05      LIKE lmh_file.lmh05,
          lmh06      LIKE lmh_file.lmh06         
                     END RECORD,       
       g_sql         STRING,                      
       g_wc          STRING,                       
       g_wc2         STRING,                     
       g_rec_b       LIKE type_file.num5,        
       l_ac          LIKE type_file.num5           
DEFINE g_lmh01             LIKE lmh_file.lmh01
DEFINE g_lmh02             LIKE lmh_file.lmh02
DEFINE g_lmh03             LIKE lmh_file.lmh03      
DEFINE g_forupd_sql        STRING                 
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE type_file.chr1   
DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_i                 LIKE type_file.num5    
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10   
DEFINE g_row_count         LIKE type_file.num10   
DEFINE g_jump              LIKE type_file.num10   
DEFINE g_no_ask           LIKE type_file.num5  
DEFINE g_void              LIKE type_file.chr1
DEFINE g_confirm           LIKE type_file.chr1
DEFINE g_newno             LIKE lmg_file.lmg01
DEFINE g_date              LIKE lmg_file.lmgdate
DEFINE g_modu              LIKE lmg_file.lmgmodu
#DEFINE g_kindtype          LIKE lrk_file.lrkkind     #FUN-A70130  mark
#DEFINE g_kindslip          LIKE lrk_file.lrkslip     #FUN-A70130  mark
DEFINE g_kindtype          LIKE oay_file.oaytype     #FUN-A70130 
DEFINE g_kindslip          LIKE oay_file.oayslip     #FUN-A70130
 
MAIN
   OPTIONS                               
      INPUT NO WRAP
   DEFER INTERRUPT              
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF 
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM lmg_file WHERE lmg01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t160_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t160_w WITH FORM "alm/42f/almt160"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()  
 
   #LET g_kindtype = '11' #FUN-A70130
   LET g_kindtype = 'K9' #FUN-A70130
   CALL t160_menu()
   CLOSE WINDOW t160_w 
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t160_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    
 
      CLEAR FORM 
      CALL g_lmh.clear()  
  
      CALL cl_set_head_visible("","YES")   
      INITIALIZE g_lmg.* TO NULL     
      CONSTRUCT BY NAME g_wc ON lmg01,lmg02,lmgstore,lmglegal,lmg04,lmg05,
                                lmg06,lmg07,lmg08,lmg09,lmg10,lmg12,lmg13,
                                lmg11,lmguser,lmggrup,lmgoriu,lmgorig,    #No:FUN-9B0136
                                lmgmodu,lmgdate,lmgcrat
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()       
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(lmg01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmg1"
                  LET g_qryparam.where = " lmgstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmg01
                  NEXT FIELD lmg01           
      
               WHEN INFIELD(lmg02) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmg2"
                  LET g_qryparam.where = " lmgstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmg02
                  NEXT FIELD lmg02  
                
               WHEN INFIELD(lmgstore) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmg3"
                  LET g_qryparam.where = " lmgstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmgstore
                  NEXT FIELD lmgstore        
 
               WHEN INFIELD(lmglegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmglegal"
                  LET g_qryparam.where = " lmgstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmglegal
                  NEXT FIELD lmglegal
 
               WHEN INFIELD(lmg04) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmg4"
                  LET g_qryparam.where = " lmgstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmg04
                  NEXT FIELD lmg04  
                  
               WHEN INFIELD(lmg05) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmg5"
                  LET g_qryparam.where = " lmgstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmg05
                  NEXT FIELD lmg05
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
      
        
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
      
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                         
   #      LET g_wc = g_wc clipped," AND lmguser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                 
   #      LET g_wc = g_wc clipped," AND lmggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    
   #      LET g_wc = g_wc clipped," AND lmggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lmguser', 'lmggrup')
   #End:FUN-980030
 
      CONSTRUCT g_wc2 ON lmh03,lmh04,lmh05,lmh06
              FROM s_lmh[1].lmh03,s_lmh[1].lmh04,s_lmh[1].lmh05,s_lmh[1].lmh06
                
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         ON ACTION CONTROLP
            CASE              
             WHEN INFIELD(lmh03) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lmh1"
               LET g_qryparam.where = " lmhstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmh03
               NEXT FIELD lmh03
          
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
    
        
         ON ACTION qbe_save
            CALL cl_qbe_save()
         
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
   
   
 
   LET g_wc2 = g_wc2 CLIPPED
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT lmg01 FROM lmg_file ",
                  " WHERE ", g_wc CLIPPED,
                  "   AND lmgstore in ",g_auth, #No.FUN-A10060
                  " ORDER BY lmg01"
   ELSE                                   # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE lmg01 ",
                  "  FROM lmg_file, lmh_file ",
                  " WHERE lmg01 = lmh01",
                  "   AND lmg02 = lmh02",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  "   and lmgstore IN ",g_auth, #No.FUN-A10060
                  " ORDER BY lmg01"
   END IF
 
   PREPARE t160_prepare FROM g_sql
   DECLARE t160_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t160_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM lmg_file WHERE ",g_wc CLIPPED,
                " and lmgstore IN ",g_auth  #No.FUN-A10060
                 
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lmg01) FROM lmg_file,lmh_file WHERE ",
                "lmg01=lmh01 AND lmg02 = lmh02 and ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " and lmgstore IN ",g_auth  #No.FUN-A10060
   END IF
 
   PREPARE t160_precount FROM g_sql
   DECLARE t160_count CURSOR FOR t160_precount
 
END FUNCTION
 
FUNCTION t160_menu()
#DEFINE  l_lrkdmy2       LIKE lrk_file.lrkdmy2    #FUN-A70130 mark
DEFINE  l_oayconf       LIKE oay_file.oayconf    #FUN-A70130
 
   WHILE TRUE
      CALL t160_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t160_a()
                ##自動審核                                                            
                LET g_kindslip=s_get_doc_no(g_lmg.lmg01)                                 
                 #單別設置里有維護單別，則找出是否需要自動審核                 
                IF NOT cl_null(g_kindslip) THEN 
           #FUN-A70130 -----------------------start-----------------------------                
           #        SELECT lrkdmy2 INTO l_lrkdmy2 FROM lrk_file                                      
           #         WHERE lrkslip = g_kindslip                                              
 
           #         IF l_lrkdmy2 = 'Y' THEN
                     SELECT oayconf INTO l_oayconf FROM oay_file   
                     WHERE oayslip = g_kindslip
                     IF l_oayconf = 'Y' THEN
           #FUN-A70130 -----------------------end-------------------------------           
                       CALL t160_confirm()                                                               
                       CALL t160_pic()
                    END IF                      
                END IF       
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t160_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
            # IF cl_chk_mach_auth(g_lmg.lmgstore,g_plant) THEN 
                 CALL t160_r()
            #  END IF   
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
            #IF cl_chk_mach_auth(g_lmg.lmgstore,g_plant) THEN  
                 CALL t160_u('w') 
            # END IF   
            END IF
             
        # WHEN "reproduce"
        #   IF cl_chk_act_auth() THEN
        #      CALL t160_copy()
        #   END IF
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lmg.lmgstore,g_plant) THEN 
                 CALL t160_confirm()
            #  END IF 
            END IF 
             CALL t160_pic() 
             
         WHEN "unconfirm"      
            IF cl_chk_act_auth() THEN
            #   IF cl_chk_mach_auth(g_lmg.lmgstore,g_plant) THEN 
                   CALL t160_unconfirm()
            #   END IF 
            END IF    
             CALL t160_pic() 
             
         WHEN "void"
            IF cl_chk_act_auth() THEN
            #   IF cl_chk_mach_auth(g_lmg.lmgstore,g_plant) THEN 
                   CALL t160_v()
            #   END IF    
            END IF 
            CALL t160_pic()                  
             
         WHEN "detail"
            IF cl_chk_act_auth() THEN
            # IF cl_chk_mach_auth(g_lmg.lmgstore,g_plant) THEN 
                CALL t160_b('d')
            #  END IF  
            ELSE
               LET g_action_choice = NULL
            END IF         
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"    
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lmh),'','')
            END IF
         
         WHEN "related_document"  
              IF cl_chk_act_auth() THEN
                 IF g_lmg.lmg01 IS NOT NULL THEN
                 LET g_doc.column1 = "lmg01"
                 LET g_doc.value1 = g_lmg.lmg01
                 CALL cl_doc()
               END IF
         END IF      
        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t160_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lmh TO s_lmh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
         
      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DISPLAY 
         
      ON ACTION unconfirm
         LET g_action_choice = "unconfirm"      
         EXIT DISPLAY 
         
      ON ACTION void
         LET g_action_choice = "void"
         EXIT DISPLAY 
         
      ON ACTION first
         CALL t160_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION previous
         CALL t160_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION jump
         CALL t160_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION next
         CALL t160_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION last
         CALL t160_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
    # ON ACTION reproduce
    #    LET g_action_choice="reproduce"
    #    EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
     
      AFTER DISPLAY
         CONTINUE DISPLAY    
 
      ON ACTION related_document              
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t160_bp_refresh()
  DISPLAY ARRAY g_lmh TO s_lmh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t160_a()
   DEFINE li_result   LIKE type_file.num5   
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
   DEFINE l_n         LIKE type_file.num5 
#  DEFINE l_tqa06     LIKE tqa_file.tqa06
#   
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
#   
#   SELECT COUNT(*) INTO l_n FROM rtz_file
#    WHERE rtz01 = g_plant
#      AND rtz28 = 'Y'
#    IF l_n < 1 THEN 
#       CALL cl_err('','alm-606',1)
#       RETURN 
#    END IF 
     
   MESSAGE ""
   CLEAR FORM
   LET g_success = 'Y'
   
   CALL g_lmh.clear()
   LET g_wc = NULL
   LET g_wc2= NULL 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lmg.* LIKE lmg_file.*         
   LET g_lmg01_t = NULL
   LET g_lmg02_t = NULL 
   LET g_lmg_t.* = g_lmg.*
   LET g_lmg_o.* = g_lmg.*
   CALL cl_opmsg('a')
   
   WHILE TRUE
      LET g_lmg.lmguser=g_user
      LET g_lmg.lmgoriu = g_user #FUN-980030
      LET g_lmg.lmgorig = g_grup #FUN-980030
      LET g_lmg.lmgcrat=g_today
      LET g_lmg.lmggrup=g_grup
      LET g_lmg.lmg08 = 'N'
      LET g_lmg.lmg06 = 0
      LET g_lmg.lmg07 = 0 
   #  LET g_lmg.lmglegal = g_legal
 
      CALL t160_i("a","")                   #輸入單頭
 
      IF INT_FLAG THEN                  
         INITIALIZE g_lmg.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_lmg.lmg01) THEN    
         CONTINUE WHILE
      END IF
 
      #####自動編號#############
      BEGIN WORK
      CALL s_auto_assign_no("alm",g_lmg.lmg01,g_lmg.lmgcrat,g_kindtype,"lmg_file","lmg01","","","")
         RETURNING li_result,g_lmg.lmg01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lmg.lmg01
      ##########################
 
      INSERT INTO lmg_file VALUES (g_lmg.*)    
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
      #   ROLLBACK WORK       # FUN-B80060 下移兩行
         CALL cl_err3("ins","lmg_file",g_lmg.lmg01,"",SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK       # FUN-B80060
         CONTINUE WHILE
      ELSE
         COMMIT WORK      
         CALL cl_flow_notify(g_lmg.lmg01,'I')
      END IF
 
      SELECT * INTO g_lmg.* FROM lmg_file
       WHERE lmg01 = g_lmg.lmg01
      LET g_lmg01_t = g_lmg.lmg01        #保留舊
      LET g_lmg02_t = g_lmg.lmg02
      LET g_lmg_t.* = g_lmg.*
      LET g_lmg_o.* = g_lmg.*
      CALL g_lmh.clear()
 
      LET g_rec_b = 0  
      CALL t160_b('a')                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t160_u(p_w)
 DEFINE  p_w     LIKE type_file.chr1
 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lmg.lmg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lmg.lmg08 = 'Y' THEN 
      CALL cl_err(g_lmg.lmg01,'alm-027',1)
      RETURN 
   END IF 
 
   IF g_lmg.lmg08 = 'X' THEN 
      CALL cl_err(g_lmg.lmg01,'alm-134',1)
      RETURN 
   END IF 
   IF g_lmg.lmg08 = 'S' THEN
      CALL cl_err('','alm-228',1)
      RETURN
   END IF 
 
   IF g_lmg.lmg08 = 'E' THEN
      CALL cl_err('','alm-653',1)
      RETURN
   END IF
   SELECT * INTO g_lmg.* FROM lmg_file
    WHERE lmg01=g_lmg.lmg01
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lmg01_t = g_lmg.lmg01
   LET g_lmg02_t = g_lmg.lmg02
   BEGIN WORK
 
   OPEN t160_cl USING g_lmg.lmg01
   IF STATUS THEN
      CALL cl_err("OPEN t160_cl:", STATUS, 1)
      CLOSE t160_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t160_cl INTO g_lmg.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmg.lmg01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t160_cl
       ROLLBACK WORK
       RETURN
   END IF
  
  LET g_date = g_lmg.lmgdate
  LET g_modu = g_lmg.lmgmodu  
                                                                      
   CALL t160_show()
 
   WHILE TRUE
      LET g_lmg01_t = g_lmg.lmg01
      LET g_lmg02_t = g_lmg.lmg02
      LET g_lmg_o.* = g_lmg.*
      IF p_w != 'c' THEN 
         LET g_lmg.lmgmodu=g_user
         LET g_lmg.lmgdate=g_today
      ELSE
      	LET g_lmg.lmgmodu=NULL
        LET g_lmg.lmgdate=NULL
      END IF  	   
      IF p_w = "c"  THEN 
         CALL t160_i("u","c")                      #欄位更改
      ELSE
      	 CALL t160_i("u","")
      END IF  	    
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lmg_t.lmgdate = g_date
         LET g_lmg_t.lmgmodu = g_modu
         LET g_lmg.*=g_lmg_t.*
         IF p_w = 'c' THEN 
            DELETE FROM lmg_file       
             WHERE  lmg01 = g_newno
            DELETE FROM lmh_file       
          WHERE lmh01 = g_newno                      
            COMMIT WORK                       
           
         END IF                           
         
         CALL t160_show()
         CALL cl_err('','9001',0)     
         RETURN        
         EXIT WHILE
      END IF
 
      IF g_lmg.lmg01 != g_lmg01_t THEN            # 更改單號
         UPDATE lmh_file SET lmh01 = g_lmg.lmg01
          WHERE lmh01 = g_lmg01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lmh_file",g_lmg01_t,"",SQLCA.sqlcode,"","pmx",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE lmg_file SET lmg_file.* = g_lmg.*
       WHERE lmg01 = g_lmg01_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lmg_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t160_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lmg.lmg01,'U')
 
   CALL t160_b_fill("1=1",p_w)
   CALL t160_bp_refresh()
 
END FUNCTION
 
FUNCTION t160_i(p_cmd,w_cmd)
DEFINE    l_n         LIKE type_file.num5
DEFINE    p_cmd       LIKE type_file.chr1    
DEFINE    w_cmd       LIKE type_file.chr1 
DEFINE    li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lmg.lmgoriu,g_lmg.lmgorig,g_lmg.lmg08,g_lmg.lmguser,g_lmg.lmgmodu,  
                   g_lmg.lmggrup,g_lmg.lmgdate,g_lmg.lmgcrat,
                   g_lmg.lmglegal
  
   INPUT BY NAME g_lmg.lmg01,g_lmg.lmg02,g_lmg.lmg11          
            WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t160_set_entry(p_cmd)
         CALL t160_set_no_entry(p_cmd)
         CALL cl_set_docno_format("lmg01")
         LET g_before_input_done = TRUE       
         CALL t160_bring()
 
      AFTER FIELD lmg01
       IF NOT cl_null(g_lmg.lmg01) THEN                                                                                          
            CALL s_check_no("alm",g_lmg.lmg01,g_lmg01_t,g_kindtype,"lmg_file","lmg01","")
                 RETURNING li_result,g_lmg.lmg01
            IF (NOT li_result) THEN
               LET g_lmg.lmg01=g_lmg_t.lmg01
               NEXT FIELD lmg01
            END IF
              DISPLAY BY NAME g_lmg.lmg01
            END IF    
 
        AFTER FIELD lmg02
         IF NOT cl_null(g_lmg.lmg02) THEN 
            IF p_cmd = "a" OR (p_cmd = "u" AND w_cmd = "c") 
               OR (p_cmd = 'u' AND g_lmg.lmg02 != g_lmg02_t) THEN            
               CALL t160_check_lmg02(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lmg.lmg02,g_errno,0)
                  NEXT FIELD lmg02
               END IF
             	  
               # CALL s_alm_valid(g_lmg.lmgstore,g_lmg.lmg04,g_lmg.lmg05,'','')                                               
               #  RETURNING l_rtz13,l_lmb03,l_lmc04                                                                                        
                                                                                                                                    
               #  IF NOT cl_null(g_errno) THEN                                                                                               
               #     CALL cl_err(g_lmg.lmg02,g_errno,1)                                                                                      
               #     NEXT FIELD lmg02                                                                                                        
               #  ELSE                                                                                                                       
               #     DISPLAY l_rtz13 TO FORMONLY.rtz13                                                                                 
               #     DISPLAY l_lmb03 TO FORMONLY.lmb03                                                                                 
               #     DISPLAY l_lmc04 TO FORMONLY.lmc04                                                                                 
               #  END IF        
           END IF 
            LET g_lmg_o.lmg02 = g_lmg.lmg02
         END IF
 
   AFTER INPUT
      LET g_lmg.lmguser = s_get_data_owner("lmg_file") #FUN-C10039
      LET g_lmg.lmggrup = s_get_data_group("lmg_file") #FUN-C10039
        IF INT_FLAG THEN
           EXIT INPUT
        ELSE
           IF p_cmd = "a" OR (p_cmd = "u" AND g_lmg.lmg02 ! = g_lmg02_t) THEN
              CALL t160_check_lmg02(p_cmd)
              IF g_success = 'N' THEN                                                                                            
                 LET g_lmg.lmg02 = g_lmg_t.lmg02                                                                                 
                 DISPLAY BY NAME g_lmg.lmg02                                                                                     
                 NEXT FIELD lmg02                                                                                                
              END IF  
           END IF    
        END IF  
   
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON ACTION controlp
         CASE    
            WHEN INFIELD(lmg01)
               LET g_kindslip = s_get_doc_no(g_lmg.lmg01)
              # CALL q_lrk(FALSE,FALSE,g_kindslip,g_kindtype,'ALM') RETURNING g_kindslip    #FUN-A70130 mark
               CALL q_oay(FALSE,FALSE,g_kindslip,g_kindtype,'ALM') RETURNING g_kindslip     #FUN-A70130  add
               LET g_lmg.lmg01 = g_kindslip
               DISPLAY BY NAME g_lmg.lmg01
               NEXT FIELD lmg01
                
            WHEN INFIELD(lmg02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lmf"
               LET g_qryparam.default1 = g_lmg.lmg02
               LET g_qryparam.arg1 = g_plant 
               CALL cl_create_qry() RETURNING g_lmg.lmg02
               DISPLAY BY NAME g_lmg.lmg02              
               NEXT FIELD lmg02       
 
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
   END INPUT
END FUNCTION
 
FUNCTION t160_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lmh.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t160_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lmg.* TO NULL
      RETURN
   END IF
 
   OPEN t160_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lmg.* TO NULL
   ELSE
      OPEN t160_count
      FETCH t160_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t160_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t160_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t160_cs INTO g_lmg.lmg01
      WHEN 'P' FETCH PREVIOUS t160_cs INTO g_lmg.lmg01
      WHEN 'F' FETCH FIRST    t160_cs INTO g_lmg.lmg01
      WHEN 'L' FETCH LAST     t160_cs INTO g_lmg.lmg01
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
            FETCH ABSOLUTE g_jump t160_cs INTO g_lmg.lmg01
            LET g_no_ask = FALSE    
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmg.lmg01,SQLCA.sqlcode,0)
      INITIALIZE g_lmg.* TO NULL              
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.idx   
   END IF
 
   SELECT * INTO g_lmg.* FROM lmg_file WHERE lmg01 = g_lmg.lmg01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lmg_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_lmg.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lmg.lmguser        
   LET g_data_group = g_lmg.lmggrup     
   CALL t160_show()
 
END FUNCTION
 
FUNCTION t160_show()
 
   LET g_lmg_t.* = g_lmg.*                
   LET g_lmg_o.* = g_lmg.*                
   LET g_lmg01_t = g_lmg.lmg01
   DISPLAY BY NAME g_lmg.lmg01,g_lmg.lmg02,g_lmg.lmgstore,g_lmg.lmg04,g_lmg.lmg05, g_lmg.lmgoriu,g_lmg.lmgorig,
                   g_lmg.lmg06,g_lmg.lmg07,g_lmg.lmg08,g_lmg.lmg09,g_lmg.lmg10,
                   g_lmg.lmg12,g_lmg.lmg13,
                   g_lmg.lmg11,g_lmg.lmguser,g_lmg.lmggrup,g_lmg.lmgmodu,
                   g_lmg.lmgdate,g_lmg.lmgcrat ,g_lmg.lmglegal
   
   CALL t160_pic()  
   CALL t160_lmg06() 
   CALL t160_bring()
   CALL t160_b_fill(g_wc2,'')                 #單身
   CALL cl_show_fld_cont()    
END FUNCTION
 
FUNCTION t160_bring()
  DEFINE l_rtz13     LIKE rtz_file.rtz13  #FUN-A80148 add
  DEFINE l_lmb03     LIKE lmb_file.lmb03
  DEFINE l_lmc04     LIKE lmc_file.lmc04
  DEFINE l_azt02     LIKE azt_file.azt02
 
  DISPLAY '' TO FORMONLY.rtz13
  DISPLAY '' TO FORMONLY.lmb03
  DISPLAY '' TO FORMONLY.lmc04
  
  IF NOT cl_null(g_lmg.lmgstore) THEN 
     SELECT rtz13 INTO l_rtz13 FROM rtz_file
      WHERE rtz28 = 'Y'
        AND rtz01 = g_lmg.lmgstore
     DISPLAY l_rtz13 TO FORMONLY.rtz13   
  END IF 
  IF NOT cl_null(g_lmg.lmg04) THEN 
      SELECT lmb03 INTO l_lmb03 FROM lmb_file
       WHERE lmb06 = 'Y'
         AND lmbstore = g_lmg.lmgstore
         AND lmb02 = g_lmg.lmg04
      DISPLAY l_lmb03 TO FORMONLY.lmb03   
  END IF 
  
  IF NOT cl_null(g_lmg.lmg05) THEN 
     SELECT lmc04 INTO l_lmc04 FROM lmc_file 
      WHERE lmc07 = 'Y'
        AND lmcstore = g_lmg.lmgstore
        AND lmc02 = g_lmg.lmg04
        AND lmc03 = g_lmg.lmg05
      DISPLAY l_lmc04 TO FORMONLY.lmc04   
  END IF 
  IF NOT cl_null(g_lmg.lmglegal) THEN
     SELECT azt02 INTO l_azt02 FROM azt_file
      WHERE azt01 = g_lmg.lmglegal
     DISPLAY l_azt02 TO FORMONLY.azt02
  END IF
END FUNCTION 
 
FUNCTION t160_lmg06()
DEFINE l_lmg06     LIKE lmg_file.lmg06
DEFINE l_lmg07     LIKE lmg_file.lmg07
 
 DISPLAY '' TO FORMONLY.lmg06
 DISPLAY '' TO FORMONLY.lmg07
 
 SELECT lmg06,lmg07 INTO l_lmg06,l_lmg07 
   FROM lmg_file
  WHERE lmg01 = g_lmg.lmg01
    AND lmg02 = g_lmg.lmg02
  DISPLAY l_lmg06 TO lmg06
  DISPLAY l_lmg07 TO lmg07     
END FUNCTION 
 
FUNCTION t160_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lmg.lmg01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   
   IF g_lmg.lmg08 = 'Y' THEN 
      CALL cl_err(g_lmg.lmg01,'alm-028',1)
      RETURN 
   END IF
 
   IF g_lmg.lmg08 = 'X' THEN 
      CALL cl_err(g_lmg.lmg01,'alm-134',1)
      RETURN 
   END IF
   
   IF g_lmg.lmg08 = 'S' THEN
      CALL cl_err('','alm-228',1)
      RETURN
   END IF 
 
   IF g_lmg.lmg08 = 'E' THEN
      CALL cl_err('','alm-653',1)
      RETURN
   END IF 
   SELECT * INTO g_lmg.* FROM lmg_file
    WHERE lmg01=g_lmg.lmg01
    BEGIN WORK
 
   OPEN t160_cl USING g_lmg.lmg01
   IF STATUS THEN
      CALL cl_err("OPEN t160_cl:", STATUS, 1)
      CLOSE t160_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t160_cl INTO g_lmg.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmg.lmg01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t160_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lmg01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lmg.lmg01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM lmg_file WHERE lmg01 = g_lmg.lmg01 
      DELETE FROM lmh_file WHERE lmh01 = g_lmg.lmg01 
                             AND lmh02 = g_lmg.lmg02
      CLEAR FORM
      CALL g_lmh.clear()
      OPEN t160_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t160_cs
         CLOSE t160_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      FETCH t160_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t160_cs
         CLOSE t160_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t160_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t160_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      #No.FUN-6A0067
         CALL t160_fetch('/')
      END IF
   END IF
 
   CLOSE t160_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lmg.lmg01,'D')
END FUNCTION
 
#單身
FUNCTION t160_b(p_w)
DEFINE   l_ac_t          LIKE type_file.num5                #未取消的ARRAY CNT  
DEFINE   l_n             LIKE type_file.num5                #檢查重複用             
DEFINE   l_cnt           LIKE type_file.num5                #檢查重複用 
DEFINE   l_lock_sw       LIKE type_file.chr1                #單身鎖住否  
DEFINE   p_cmd           LIKE type_file.chr1                #處理狀態      
DEFINE   l_allow_insert  LIKE type_file.num5               
DEFINE   l_allow_delete  LIKE type_file.num5     
DEFINE  l_lmdstore       LIKE lmd_file.lmdstore       
DEFINE  l_lmd05          LIKE lmd_file.lmd05
DEFINE  l_lmd06          LIKE lmd_file.lmd06
DEFINE  l_count          LIKE type_file.num5
DEFINE  l_count1         LIKE type_file.num5
DEFINE  l_lmg06          LIKE lmg_file.lmg06
DEFINE  l_lmg07          LIKE lmg_file.lmg07 
DEFINE  p_w              LIKE type_file.chr1
   
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_lmg.lmg01 IS NULL THEN
       RETURN
    END IF
    IF g_lmg.lmg08 = 'Y' THEN 
       CALL cl_err('','alm-097',1)
       RETURN
   END IF 
 
    IF g_lmg.lmg08 = 'X' THEN 
       CALL cl_err('','alm-134',1)
       RETURN
   END IF 
 
   IF g_lmg.lmg08 = 'S' THEN
      CALL cl_err('','alm-228',1)
      RETURN
   END IF 
   
   IF g_lmg.lmg08 = 'E' THEN
      CALL cl_err('','alm-653',1)
      RETURN
   END IF
    SELECT * INTO g_lmg.* FROM lmg_file
     WHERE lmg01=g_lmg.lmg01 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT lmh03,lmh04,lmh05,lmh06 from lmh_file", 
                       " WHERE lmh01 =? and lmh02 =? and lmh03 = ?",
                       "  FOR UPDATE "
                         
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t160_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_lmh WITHOUT DEFAULTS FROM s_lmh.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t160_cl USING g_lmg.lmg01
           IF STATUS THEN
              CALL cl_err("OPEN t160_cl:", STATUS, 1)
              CLOSE t160_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t160_cl INTO g_lmg.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lmg.lmg01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t160_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lmh_t.* = g_lmh[l_ac].*  #BACKUP
              LET g_lmh_o.* = g_lmh[l_ac].*  #BACKUP
              OPEN t160_bcl USING g_lmg.lmg01,g_lmg.lmg02,g_lmh_t.lmh03
              IF STATUS THEN
                 CALL cl_err("OPEN t160_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t160_bcl INTO g_lmh[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lmh_t.lmh03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF   
              END IF
              CALL cl_show_fld_cont()    
              CALL t160_set_entry_b(p_cmd)    
              CALL t160_set_no_entry_b(p_cmd) 
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lmh[l_ac].* TO NULL      
           LET g_lmh_t.* = g_lmh[l_ac].*         #新輸入資料
           LET g_lmh_o.* = g_lmh[l_ac].*         #新輸入資料
           LET g_lmh[l_ac].lmh06 = 'N'
           CALL cl_show_fld_cont()        
           CALL t160_set_entry_b(p_cmd)   
           CALL t160_set_no_entry_b(p_cmd)
           NEXT FIELD lmh03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF          
           IF cl_null(g_lmh[l_ac].lmh03) THEN
              CALL cl_err('','alm-062',1)
              NEXT FIELD lmh03 
           END IF
           LET g_lmh[l_ac].lmh06 = 'Y'
          INSERT INTO lmh_file(lmh01,lmh02,lmh03,lmh04,lmh05,lmh06,lmhstore,lmhlegal)
          VALUES(g_lmg.lmg01,g_lmg.lmg02,
                 g_lmh[l_ac].lmh03,g_lmh[l_ac].lmh04,
                 g_lmh[l_ac].lmh05,g_lmh[l_ac].lmh06,g_lmg.lmgstore,g_lmg.lmglegal)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lmh_file",g_lmg.lmg01,g_lmh[l_ac].lmh03,SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF      
 
        AFTER FIELD lmh03         
          IF NOT cl_null(g_lmh[l_ac].lmh03) THEN  
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lmh[l_ac].lmh03 != g_lmh_t.lmh03) THEN             
                SELECT count(*) INTO l_count  FROM lmd_file              
                 WHERE lmd01 = g_lmh[l_ac].lmh03
                IF l_count < 1 THEN
                   CALL cl_err('','alm-064',1)                       
                   NEXT FIELD lmh03
                ELSE
                	 SELECT COUNT(*) INTO l_count1 FROM lmd_file                    
                    WHERE lmd01 = g_lmh[l_ac].lmh03
                 	    AND lmdstore = g_lmg.lmgstore  
                      AND lmd03 = g_lmg.lmg04
                      AND lmd04 = g_lmg.lmg05
                    IF l_count1 < 1 THEN 
                       CALL cl_err('','alm-065',1)                         
                       NEXT FIELD lmh03
                     ELSE
                       LET l_count1 = 0
                       SELECT COUNT(*) INTO l_count1 FROM lmd_file                 
                	      WHERE lmd01 = g_lmh[l_ac].lmh03
                 	        AND lmdstore = g_lmg.lmgstore  
                          AND lmd03 = g_lmg.lmg04
                          AND lmd04 = g_lmg.lmg05
                          AND lmd10 = 'Y'
                       IF l_count1 < 1 THEN 
                          CALL cl_err('','alm-066',1)                                
                          NEXT FIELD lmh03
                        ELSE
                          LET l_count1 = 0 
                          SELECT COUNT(*) INTO l_count1 FROM lmd_file                      
                	         WHERE lmd01 = g_lmh[l_ac].lmh03
              	            AND lmdstore = g_lmg.lmgstore  
                            AND lmd03 = g_lmg.lmg04
                            AND lmd04 = g_lmg.lmg05
                            AND lmd10 = 'Y'
                            AND lmd07 = 'N'
                          IF l_count1 < 1 THEN 
                             CALL cl_err('','alm-067',1)                                    
                             NEXT FIELD lmh03
                           ELSE
                          	  LET l_count1 = 0
                           	  SELECT COUNT(lmd01) INTO l_count1 FROM lmd_file,lmh_file
                               WHERE lmd01 = g_lmh[l_ac].lmh03
              	                 AND lmdstore = g_lmg.lmgstore  
                                 AND lmd03 = g_lmg.lmg04
                                 AND lmd04 = g_lmg.lmg05
                                 AND lmd10 = 'Y'
                                 AND lmd07 = 'N'
                                 AND lmh03 = g_lmh[l_ac].lmh03
                                 AND lmh06 = 'Y'
                               IF l_count1 > 0 THEN 
                                  CALL cl_err('','alm-068',1)                                      
                                  NEXT FIELD lmh03
                               ELSE                             
                               	 SELECT lmd05,lmd06 INTO l_lmd05,l_lmd06
                               	   FROM lmd_file
                              	  WHERE lmd01 = g_lmh[l_ac].lmh03
                               		  AND lmdstore = g_lmg.lmgstore 
                               		  AND lmd03 = g_lmg.lmg04
                               		  AND lmd04 = g_lmg.lmg05
                              	  LET g_lmh[l_ac].lmh04 = l_lmd05 
                               	  LET g_lmh[l_ac].lmh05 = l_lmd06
                               	  DISPLAY g_lmh[l_ac].lmh04 TO s_lmh[l_ac].lmh04
                              	  DISPLAY g_lmh[l_ac].lmh05 TO s_lmh[l_ac].lmh05                             
                               END IF 	      
                           END IF 	   
                       END IF 	   
                   END IF 	  
                END IF  
             END IF            
         END IF 
       
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_lmh_t.lmh03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lmh_file
               WHERE lmh01 = g_lmg.lmg01
                 AND lmh03 = g_lmh_t.lmh03
                 AND lmh02 = g_lmg.lmg02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lmh_file",g_lmg.lmg01,g_lmh_t.lmh03,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lmh[l_ac].* = g_lmh_t.*
              CLOSE t160_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lmh[l_ac].lmh03,-263,1)
              LET g_lmh[l_ac].* = g_lmh_t.*
           ELSE             
              UPDATE lmh_file SET lmh03=g_lmh[l_ac].lmh03,
                                  lmh04=g_lmh[l_ac].lmh04,
                                  lmh05=g_lmh[l_ac].lmh05,
                                  lmh06=g_lmh[l_ac].lmh06  
               WHERE lmh01 = g_lmg.lmg01
                 AND lmh03 = g_lmh_t.lmh03
                 AND lmh02 = g_lmg.lmg02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lmh_file",g_lmg.lmg01,g_lmh_t.lmh03,SQLCA.sqlcode,"","",1)  
                 LET g_lmh[l_ac].* = g_lmh_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"      
           
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lmh[l_ac].* = g_lmh_t.*
              END IF
              CLOSE t160_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           ################################
           SELECT SUM(lmh04),SUM(lmh05) INTO l_lmg06,l_lmg07
             FROM lmh_file
            WHERE lmh01 = g_lmg.lmg01
              AND lmh02 = g_lmg.lmg02
              AND lmh03 IS NOT NULL
                
            UPDATE lmg_file SET lmg06 = l_lmg06,
                                lmg07 = l_lmg07        
             WHERE lmg01 = g_lmg.lmg01
               AND lmg02 = g_lmg.lmg02
           #No.TQC-A30075 -BEGIN-----
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               #CALL cl_err('upd_img',SQLCA.SQLCODE,0) #TQC-A70076 mark
               CALL cl_err('upd_lmg',SQLCA.SQLCODE,0)  #TQC-A70076 mod
               IF p_cmd = 'u' THEN
                  LET g_lmh[l_ac].* = g_lmh_t.*
               END IF
               CLOSE t160_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #No.TQC-A30075 -END-------
                                      
            DISPLAY l_lmg06 TO lmg06   
            DISPLAY l_lmg07 TO lmg07
            
           ################################
           CLOSE t160_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(lmh03) AND l_ac > 1 THEN
              LET g_lmh[l_ac].* = g_lmh[l_ac-1].*
              LET g_lmh[l_ac].lmh03 = g_rec_b + 1
              NEXT FIELD lmh03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()       
 
        ON ACTION controlp
           CASE          
             WHEN INFIELD(lmh03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lmd10" 
               LET g_qryparam.default1 = g_lmh[l_ac].lmh03
               LET g_qryparam.arg1 = g_lmg.lmgstore 
               LET g_qryparam.arg2 = g_lmg.lmg04
               LET g_qryparam.arg3 = g_lmg.lmg05           
               CALL cl_create_qry() RETURNING g_lmh[l_ac].lmh03
               DISPLAY BY NAME g_lmh[l_ac].lmh03
               NEXT FIELD lmh03            
            
               OTHERWISE EXIT CASE
            END CASE
 
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
  
   IF p_w != 'c' THEN 
      LET g_lmg.lmgmodu = g_user
      LET g_lmg.lmgdate = g_today
   ELSE
   	   LET g_lmg.lmgmodu = NULL
      LET g_lmg.lmgdate = NULL 
   	END IF     
    UPDATE lmg_file SET lmgmodu = g_lmg.lmgmodu,
                        lmgdate = g_lmg.lmgdate
     WHERE lmg01 = g_lmg.lmg01
    
    DISPLAY BY NAME g_lmg.lmgmodu,g_lmg.lmgdate
  
    CLOSE t160_bcl
    COMMIT WORK
    CALL t160_delall()
 
END FUNCTION
 
FUNCTION t160_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM lmh_file
    WHERE lmh01 = g_lmg.lmg01
      AND lmh02 = g_lmg.lmg02
      AND lmh03 IS NOT NULL 
      
   IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM lmg_file 
            WHERE lmg01 = g_lmg.lmg01
      CLEAR FORM    #TQC-A60124
   END IF
 
END FUNCTION
 
FUNCTION t160_b_fill(p_wc2,w_wc2)
DEFINE p_wc2     STRING
DEFINE w_wc2     STRING
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
  
   IF w_wc2 != 'c' AND g_lmg.lmg02 != g_lmg_t.lmg02 THEN 
      DELETE FROM lmh_file WHERE lmh01 = g_lmg.lmg01 
                             AND lmh02 = g_lmg_t.lmg02                                   
   END IF 
  
    LET g_sql = "SELECT lmh03,lmh04,lmh05,lmh06 from lmh_file",
                " WHERE lmh01 ='",g_lmg.lmg01,"' ",
                "   AND lmh02 ='",g_lmg.lmg02,"' "
     
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lmh03 "  
   DISPLAY g_sql
   PREPARE t160_pb FROM g_sql
   DECLARE lmh_cs CURSOR FOR t160_pb
 
   CALL g_lmh.clear()
   LET g_cnt = 1
 
   FOREACH lmh_cs INTO g_lmh[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lmh.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t160_copy()
   DEFINE l_newno     LIKE lmg_file.lmg01,
          l_oldno     LIKE lmg_file.lmg01
   DEFINE li_result   LIKE type_file.num5 
   DEFINE l_n         LIKE type_file.num5
   
   IF s_shut(0) THEN RETURN END IF
 
   IF g_lmg.lmg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
    SELECT COUNT(*) INTO l_n FROM rtz_file
     WHERE rtz01 = g_plant
     IF l_n < 1 THEN 
        CALL cl_err('','alm-559',1)
        RETURN 
     END IF 
   
   LET g_before_input_done = FALSE
   CALL t160_set_entry('a')
 
   CALL cl_set_head_visible("","YES")  
   CALL cl_set_docno_format("lmg01")     
   INPUT l_newno FROM lmg01   
        
       AFTER FIELD lmg01            
          IF NOT cl_null(l_newno) THEN                                                                                      
            CALL s_check_no("alm",l_newno,"",g_kindtype,"lmg_file","lmg01","")
              RETURNING li_result,l_newno
            IF (NOT li_result) THEN
               LET l_newno = NULL
               DISPLAY l_newno TO lmg01
               NEXT FIELD lmg01
            END IF
           ELSE                                         
              CALL cl_err(l_newno,'alm-055',1)                                               
              NEXT FIELD lmg01                                                                   
           END IF   
 
       ON ACTION controlp
          CASE
            WHEN INFIELD(lmg01)     #單據編號
               LET g_kindslip = s_get_doc_no(l_newno)
             #  CALL q_lrk(FALSE,FALSE,g_kindslip,g_kindtype,'ALM') RETURNING g_kindslip     #FUN-A70130  mark
              CALL q_oay(FALSE,FALSE,g_kindslip,g_kindtype,'ALM') RETURNING g_kindslip      #FUN-A70130 add
               LET l_newno = g_kindslip
               DISPLAY l_newno TO lmg01
               NEXT FIELD lmg01
            
              OTHERWISE EXIT CASE
           END CASE
 
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
      DISPLAY BY NAME g_lmg.lmg01      
      ROLLBACK WORK     
      RETURN
   ELSE
     #####自動編號############     
      BEGIN WORK
      CALL s_auto_assign_no("alm",l_newno,g_today,g_kindtype,"lmg_file","lmg01","","","")
         RETURNING li_result,l_newno
      IF (NOT li_result) THEN
         RETURN 
      END IF	
      DISPLAY l_newno TO lmg01
     ######################    
   END IF
  
   DROP TABLE y
 
   SELECT * FROM lmg_file         #單頭複製
       WHERE lmg01=g_lmg.lmg01
       INTO TEMP y
 
   UPDATE y
       SET lmg01  = l_newno,  
           lmguser= g_user,  
           lmgcrat= g_today,
           lmggrup= g_grup,  
           lmgmodu= NULL,    
           lmgdate= NULL,  
           lmg09  = NULL,
           lmg10  = NULL,
           lmg08  = 'N',
           lmg12  = NULL,
           lmg13  = NULL 
 
   INSERT INTO lmg_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","lmg_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM lmh_file         #單身複製
       WHERE lmh01=g_lmg.lmg01
         AND lmh02 = g_lmg.lmg02
        INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET lmh01=l_newno
   
   INSERT INTO lmh_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
   #   ROLLBACK WORK     # FUN-B80060 下移兩行
      CALL cl_err3("ins","lmh_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK     # FUN-B80060
      RETURN
   ELSE
       COMMIT WORK
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_lmg.lmg01
   SELECT lmg_file.* INTO g_lmg.* 
     FROM lmg_file
    WHERE lmg01 = l_newno
  
   LET g_newno = l_newno
  
   CALL t160_u('c')   
  
   CALL t160_b('c')
  
   SELECT lmg_file.* INTO g_lmg.* 
    FROM lmg_file
   WHERE lmg01 = l_oldno
   CALL t160_show()
 
END FUNCTION
 
FUNCTION t160_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lmg01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t160_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lmg01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t160_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
     IF p_cmd = 'a' AND (NOT g_before_input_done) THEN                                                                                
      CALL cl_set_comp_entry("lmh03",TRUE)                                                                                          
     END IF   
 
END FUNCTION
 
FUNCTION t160_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1   
 
  #IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
  #   CALL cl_set_comp_entry("lmh03",FALSE)                                                                                         
  #END IF  
   CALL cl_set_comp_entry("lmh06",FALSE)
END FUNCTION
 
FUNCTION t160_check_lmg02(p_cmd)
 DEFINE p_cmd    LIKE type_file.chr1
 DEFINE l_cnt    LIKE type_file.num10
 DEFINE l_lmfstore LIKE lmf_file.lmfstore
 DEFINE l_lmflegal LIKE lmf_file.lmflegal
 DEFINE l_lmf03  LIKE lmf_file.lmf03
 DEFINE l_lmf04  LIKE lmf_file.lmf04
 DEFINE l_lmf05  LIKE lmf_file.lmf05
 DEFINE l_lmf06  LIKE lmf_file.lmf06
 DEFINE l_rtz13  LIKE rtz_file.rtz13
 DEFINE l_lmb03  LIKE lmb_file.lmb03
 DEFINE l_lmc04  LIKE lmc_file.lmc04
 DEFINE l_azt02  LIKE azt_file.azt02
 
   LET g_errno = ''
 
   SELECT lmfstore,lmf03,lmf04,lmf05,lmf06,lmflegal
     INTO l_lmfstore,l_lmf03,l_lmf04,l_lmf05,l_lmf06,l_lmflegal
     FROM lmf_file
    WHERE lmf01 = g_lmg.lmg02
   CASE
      WHEN SQLCA.SQLCODE = 100      LET g_errno = 'alm-057'
                                    LET l_lmfstore = NULL
                                    LET l_lmf03 = NULL
                                    LET l_lmf04 = NULL
                                    LET l_lmf05 = NULL
                                    LET l_lmf06 = NULL
      WHEN l_lmf05 <> '0'           LET g_errno = 'alm-058'
      WHEN l_lmf06 <> 'Y'           LET g_errno = 'alm-0059'
      WHEN l_lmfstore <> g_plant    LET g_errno = 'alm-557'
      OTHERWISE                     LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
   IF cl_null(g_errno) AND (p_cmd = 'a' OR p_cmd = 'u') THEN
      SELECT COUNT(*) INTO l_cnt FROM lmg_file
       WHERE lmg02 = g_lmg.lmg02
         AND (lmg08 = 'Y' OR lmg08 = 'N')
      IF l_cnt > 0 THEN
         LET g_errno = 'alm-060'
         RETURN
      ELSE
      	 LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM lmh_file
          WHERE lmh02 = p_cmd
            AND lmh06 = 'Y'
         IF l_cnt > 0 THEN
            LET g_errno = 'alm-060'
            RETURN
         END IF
      END IF
   END IF
 
   IF cl_null(g_errno) or p_cmd = 'd' THEN
      LET g_lmg.lmgstore = l_lmfstore
      LET g_lmg.lmglegal = l_lmflegal
      LET g_lmg.lmg04 = l_lmf03
      LET g_lmg.lmg05 = l_lmf04
      
      SELECT rtz13 INTO l_rtz13 FROM rtz_file
       WHERE rtz01 = g_lmg.lmgstore
         AND rtz28 = 'Y'
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_lmg.lmglegal
      SELECT lmb03 INTO l_lmb03 FROM lmb_file
       WHERE lmb02 = g_lmg.lmg04
         AND lmb06 = 'Y'
         AND lmbstore = g_lmg.lmgstore
      SELECT lmc04 INTO l_lmc04 FROM lmc_file
       WHERE lmc07 ='Y'
         AND lmcstore = g_lmg.lmgstore
         AND lmc02 = g_lmg.lmg04
         AND lmc03 = g_lmg.lmg05
      
      DISPLAY BY NAME g_lmg.lmgstore,g_lmg.lmg04,g_lmg.lmg05,g_lmg.lmglegal
      DISPLAY l_rtz13 TO FORMONLY.rtz13
      DISPLAY l_azt02 TO FORMONLY.azt02
      DISPLAY l_lmb03 TO FORMONLY.lmb03
      DISPLAY l_lmc04 TO FORMONLY.lmc04
   END IF
END FUNCTION
 
FUNCTION t160_confirm()
  DEFINE l_lmg09         LIKE lmg_file.lmg09    
  DEFINE l_lmg10         LIKE lmg_file.lmg10
 
   IF cl_null(g_lmg.lmg01) THEN         
      CALL cl_err('',-400,0)             
      RETURN                                   
   END IF                                
   IF g_lmg.lmg08 = 'Y' THEN        
      CALL cl_err(g_lmg.lmg08,'alm-005',1)            
      RETURN                        
   END IF 
 
   IF g_lmg.lmg08 = 'X' THEN        
      CALL cl_err(g_lmg.lmg08,'alm-134',1)            
      RETURN                        
   END IF 
 
   IF g_lmg.lmg08 = 'S' THEN
      CALL cl_err('','alm-228',1)
      RETURN
   END IF 
 
   IF g_lmg.lmg08 = 'E' THEN
      CALL cl_err('','alm-653',1)
      RETURN
   END IF
   SELECT * INTO g_lmg.* FROM lmg_file                                                    
    WHERE lmg01 = g_lmg.lmg01                                                        
 
    LET l_lmg09 = g_lmg.lmg09                                     
    LET l_lmg10 = g_lmg.lmg10  
    
    BEGIN WORK
    OPEN t160_cl USING g_lmg.lmg01
    
    IF STATUS THEN 
       CALL cl_err("open t160_cl:",STATUS,1)
       CLOSE t160_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t160_cl INTO g_lmg.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lmg.lmg01,SQLCA.sqlcode,0)
      CLOSE t160_cl
      ROLLBACK WORK
      RETURN 
    END IF      
                                                                                                               
   IF NOT cl_confirm("alm-006") THEN                                                                                                
       RETURN                                                                                                                       
   ELSE                                                                                                                             
      LET g_lmg.lmg08 = 'Y'                                                                                                     
      LET g_lmg.lmg09 = g_user                                                                                                      
      LET g_lmg.lmg10 = g_today                                                                                                                                 
      UPDATE lmg_file                                                                                                               
         SET lmg08 = g_lmg.lmg08,                                                                                                   
             lmg09 = g_lmg.lmg09,                                                                                                   
             lmg10 = g_lmg.lmg10                                                                                              
       WHERE lmg01 = g_lmg.lmg01
       
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN                                                                                
         CALL cl_err('upd lmg:',SQLCA.SQLCODE,0)                                                                                    
         LET g_lmg.lmg08 = "N"                                                                                                      
         LET g_lmg.lmg09 = l_lmg09                                                                                                  
         LET g_lmg.lmg10 = l_lmg10                                                                                              
         DISPLAY BY NAME g_lmg.lmg08,g_lmg.lmg09,g_lmg.lmg10                                                                        
         RETURN                                                                                                                     
       ELSE         
       	##########################################
       	UPDATE lmd_file SET lmd07 = 'Y'
       	  WHERE lmd01 IN (SELECT lmh03 FROM lmh_file,lmg_file
       	                  WHERE lmh02 = g_lmg.lmg02
       	                    AND lmh01 = g_lmg.lmg01)
       #No.TQC-A30075 -BEGIN-----
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err('upd lmd:',SQLCA.SQLCODE,0)
           LET g_lmg.lmg08 = "N"
           LET g_lmg.lmg09 = l_lmg09
           LET g_lmg.lmg10 = l_lmg10
           DISPLAY BY NAME g_lmg.lmg08,g_lmg.lmg09,g_lmg.lmg10
           RETURN
        END IF
       #No.TQC-A30075 -END-------
        ###########################################                              
          DISPLAY BY NAME g_lmg.lmg08,g_lmg.lmg09,g_lmg.lmg10                                    
       END IF                                                                        
  END IF   
  
  CLOSE t160_cl
  COMMIT WORK
                     
END FUNCTION 
 
FUNCTION t160_unconfirm()                                                                                        
   DEFINE l_lmg09         LIKE lmg_file.lmg09       
   DEFINE l_lmg10         LIKE lmg_file.lmg10        
 
   IF cl_null(g_lmg.lmg01) THEN          
      CALL cl_err('',-400,0)               
      RETURN                          
   END IF                               
   IF g_lmg.lmg08 = 'N' THEN   
      CALL cl_err(g_lmg.lmg01,'alm-007',1)    
      RETURN                     
   END IF   
                                
   IF g_lmg.lmg08 = 'X' THEN   
      CALL cl_err(g_lmg.lmg01,'alm-134',1)    
      RETURN                     
   END IF   
  
   IF g_lmg.lmg08 = 'S' THEN
      CALL cl_err('','alm-228',1)
      RETURN
   END IF 
   IF g_lmg.lmg08 = 'E' THEN
      CALL cl_err('','alm-653',1)
      RETURN
   END IF
  
  SELECT * INTO g_lmg.* FROM lmg_file                   
    WHERE lmg01 = g_lmg.lmg01                                               
 
   LET l_lmg09 = g_lmg.lmg09                                                                               
   LET l_lmg10 = g_lmg.lmg10                                                                    
 
    BEGIN WORK
    OPEN t160_cl USING g_lmg.lmg01
    
    IF STATUS THEN 
       CALL cl_err("open t160_cl:",STATUS,1)
       CLOSE t160_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t160_cl INTO g_lmg.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lmg.lmg01,SQLCA.sqlcode,0)
      CLOSE t160_cl
      ROLLBACK WORK
      RETURN 
    END IF      
                                                                                                                                     
   IF NOT cl_confirm('alm-008') THEN                                                                                                
      RETURN                                                                                                                        
   ELSE                                                                                                                             
       LET g_lmg.lmg08 = 'N'                                                                                                        
       LET g_lmg.lmg09 = NULL  
       LET g_lmg.lmg10 = NULL                                                                                                   
       LET g_lmg.lmgmodu = g_user                                        
       LET g_lmg.lmgdate = g_today                                                                                                                             
       UPDATE lmg_file                                                                                                              
          SET lmg08 = g_lmg.lmg08,                                                                                                  
              lmg09 = g_lmg.lmg09,                                                                                                  
              lmg10 = g_lmg.lmg10,
              lmgmodu = g_lmg.lmgmodu,                                                      
              lmgdate = g_lmg.lmgdate                                                                       
        WHERE lmg01 = g_lmg.lmg01                                                                                                   
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN                                                                               
          CALL cl_err('upd lmg:',SQLCA.SQLCODE,0)                                                                                   
          LET g_lmg.lmg08 = "Y"                                                                                                     
          LET g_lmg.lmg09 = l_lmg09                                                                                                 
          LET g_lmg.lmg10 = l_lmg10                                                                                              
          DISPLAY BY NAME g_lmg.lmg08,g_lmg.lmg09,g_lmg.lmg10                                                                       
          RETURN                                                                                                                    
         ELSE   
            UPDATE lmd_file SET lmd07 = 'N'
       	     WHERE lmd01 IN (SELECT lmh03 FROM lmh_file,lmg_file
       	                      WHERE lmh02 = g_lmg.lmg02
       	                        AND lmh01 = g_lmg.lmg01)                                                                                                              
           #No.TQC-A30075 -BEGIN-----
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lmd:',SQLCA.SQLCODE,0)
               LET g_lmg.lmg08 = "Y"
               LET g_lmg.lmg09 = l_lmg09
               LET g_lmg.lmg10 = l_lmg10
               DISPLAY BY NAME g_lmg.lmg08,g_lmg.lmg09,g_lmg.lmg10
               RETURN
            END IF
           #No.TQC-A30075 -END-------
            DISPLAY BY NAME g_lmg.lmg08,g_lmg.lmg09,g_lmg.lmg10,g_lmg.lmgmodu,g_lmg.lmgdate                                                                
         END IF                                                                                                                     
   END IF     
   
    CLOSE t160_cl
  COMMIT WORK                     
END FUNCTION 
 
FUNCTION t160_pic()
   CASE g_lmg.lmg08
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void = ''
      WHEN 'X'  LET g_confirm = ''
                LET g_void = 'Y'
      OTHERWISE LET g_confirm = ''
                LET g_void = ''
   END CASE
 
   CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
END FUNCTION
 
FUNCTION t160_v()
DEFINE l_count   LIKE type_file.num5
 
   IF cl_null(g_lmg.lmg01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
  IF g_lmg.lmg08 = 'S' THEN
     CALL cl_err('','alm-228',1)
     RETURN
  END IF 
  IF g_lmg.lmg08 = 'E' THEN
     CALL cl_err('','alm-653',1)
     RETURN
  END IF
 
 
   SELECT * INTO g_lmg.* FROM lmg_file
    WHERE lmg01 = g_lmg.lmg01
 
   IF g_lmg.lmg08 = 'Y' THEN
      CALL cl_err(g_lmg.lmg01,'9023',0)
      RETURN
   END IF
     BEGIN WORK
    OPEN t160_cl USING g_lmg.lmg01
    
    IF STATUS THEN 
       CALL cl_err("open t160_cl:",STATUS,1)
       CLOSE t160_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH t160_cl INTO g_lmg.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lmg.lmg01,SQLCA.sqlcode,0)
      CLOSE t160_cl
      ROLLBACK WORK
      RETURN 
    END IF      
    
   IF g_lmg.lmg08 != 'Y' THEN
      IF g_lmg.lmg08 = 'X' THEN
         IF NOT cl_confirm('alm-086') THEN
            RETURN
         ELSE
         	  LET l_count = 0 
         	  SELECT COUNT(*) INTO l_count FROM lmg_file
         	   WHERE lmg02 = g_lmg.lmg02
         	     AND (lmg08 = 'Y' OR lmg08 = 'N')
         	   IF l_count > 0 THEN 
         	      CALL cl_err('','alm-624',1)
         	      RETURN 
         	   ELSE     
         	  #######
            LET g_lmg.lmg08 = 'N'
            LET g_lmg.lmgmodu = g_user
            LET g_lmg.lmgdate = g_today
            UPDATE lmg_file
               SET lmg08 = g_lmg.lmg08,
                   lmgmodu = g_lmg.lmgmodu,
                   lmgdate = g_lmg.lmgdate
             WHERE lmg01 = g_lmg.lmg01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lmg:',SQLCA.SQLCODE,0)
               LET g_lmg.lmg08 = "X"
               DISPLAY BY NAME g_lmg.lmg08
               RETURN
            ELSE
               DISPLAY BY NAME g_lmg.lmg08,g_lmg.lmgmodu,g_lmg.lmgdate
            END IF
            #############  
           END IF   
         END IF
      ELSE
         IF NOT cl_confirm('alm-085') THEN
            RETURN
         ELSE
            LET g_lmg.lmg08 = 'X'
            LET g_lmg.lmgmodu = g_user
            LET g_lmg.lmgdate = g_today
            UPDATE lmg_file
               SET lmg08 = g_lmg.lmg08,
                   lmgmodu = g_lmg.lmgmodu,
                   lmgdate = g_lmg.lmgdate
             WHERE lmg01 = g_lmg.lmg01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lmg:',SQLCA.SQLCODE,0)
               LET g_lmg.lmg08 = "N"
               DISPLAY BY NAME g_lmg.lmg08
               RETURN
            ELSE
               DISPLAY BY NAME g_lmg.lmg08,g_lmg.lmgmodu,g_lmg.lmgdate
            END IF
         END IF
      END IF
   END IF
  CLOSE t160_cl
  COMMIT WORK      
END FUNCTION 
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore 
 
 
 
 

