# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: almi350.4gl
# Descriptions...: 費用明細參數設置作業 
# Date & Author..: NO:FUN-870010 08/07/11 By lilingyu 
# Modify.........: No:FUN-960134 09/07/09 By shiwuying 市場移植
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0136 09/11/24 By shiwuying add oriu,orig
# Modify.........: No:MOD-9C0364 09/12/24 By shiwuying 開放門店編號
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No:MOD-B10050 11/01/07 By shiwuying entry控管
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B90121 11/09/23 By baogc 招商歐亞達回收,部份邏輯修改

 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20078 12/02/14 by nanbing 單身定義方式增加 5.比例
# Modify.........: No:TQC-C20383 12/02/22 by nanbing 選擇方法為比例，定義方式如果不是比例自動轉換為比例
# Modify.........: No:TQC-C30290 12/03/28 by fanbj 定義方法為分段，定義方式只能選擇經營面積和測量面積 
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_lnl       RECORD   LIKE lnl_file.*,  
        g_lnl_t     RECORD   LIKE lnl_file.*,					
        g_lnl_o     RECORD   LIKE lnl_file.*,    
        g_lnl01_t            LIKE lnl_file.lnl01,
        g_lnlstore_t         LIKE lnl_file.lnlstore             
DEFINE g_wc                  STRING 
DEFINE g_sql                 STRING                 
DEFINE g_forupd_sql          STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5   
DEFINE g_chr                 LIKE type_file.chr1 
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5       #count/index for any purpose
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10 
DEFINE g_jump                LIKE type_file.num10             
DEFINE g_no_ask              LIKE type_file.num5 
DEFINE g_date                LIKE lnl_file.lnldate
DEFINE g_modu                LIKE lnl_file.lnlmodu
DEFINE g_flag                LIKE type_file.chr1 #No.MOD-9C0364
#FUN-B90121 Add Begin ---
DEFINE g_lik    DYNAMIC ARRAY OF RECORD
                    lik02    LIKE lik_file.lik02,
                    lik03    LIKE lik_file.lik03,
                    lmb03    LIKE lmb_file.lmb03,
                    lik04    LIKE lik_file.lik04,
                    lmc04    LIKE lmc_file.lmc04,
                    lik05    LIKE lik_file.lik05,
                    lmy04    LIKE lmy_file.lmy04,
                    lik06    LIKE lik_file.lik06,
                    oba02    LIKE oba_file.oba02,
                    lik07    LIKE lik_file.lik07,
                    tqa02    LIKE tqa_file.tqa02,
                    lik08    LIKE lik_file.lik08,
                    lik09    LIKE lik_file.lik09,
                    lik10    LIKE lik_file.lik10
                END RECORD 
DEFINE g_lik_t  RECORD
                    lik02    LIKE lik_file.lik02,
                    lik03    LIKE lik_file.lik03,
                    lmb03    LIKE lmb_file.lmb03,
                    lik04    LIKE lik_file.lik04,
                    lmc04    LIKE lmc_file.lmc04,
                    lik05    LIKE lik_file.lik05,
                    lmy04    LIKE lmy_file.lmy04,
                    lik06    LIKE lik_file.lik06,
                    oba02    LIKE oba_file.oba02,
                    lik07    LIKE lik_file.lik07,
                    tqa02    LIKE tqa_file.tqa02,
                    lik08    LIKE lik_file.lik08,
                    lik09    LIKE lik_file.lik09,
                    lik10    LIKE lik_file.lik10
                END RECORD
DEFINE tm       RECORD
                    wc1      STRING,
                    wc2      STRING,
                    wc3      STRING,
                    wc4      STRING,
                    lik07    LIKE lik_file.lik07,
                    lik08    LIKE lik_file.lik08,
                    lik09    LIKE lik_file.lik09,
                    lik10    LIKE lik_file.lik10,
                    detail   LIKE type_file.chr1
                END RECORD
DEFINE    g_wc2              STRING
DEFINE    g_rec_b            LIKE type_file.num5
DEFINE    l_ac               LIKE type_file.num5
DEFINE    g_lmb02            LIKE lmb_file.lmb02
DEFINE    g_lmc03            LIKE lmc_file.lmc03
DEFINE    g_lmy03            LIKE lmy_file.lmy03
DEFINE    g_oba01            LIKE oba_file.oba01
DEFINE    g_sel_sql          STRING
DEFINE    g_del_sql          STRING
DEFINE    g_ins_sql          STRING
DEFINE    g_err_str1         LIKE type_file.chr1
DEFINE    g_err_str2         LIKE type_file.chr1
DEFINE    g_success_sum      LIKE type_file.num5 #成功新增筆數
DEFINE    g_check_str        LIKE type_file.chr3 
#FUN-B90121 Add End -----
 
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
 
   LET g_forupd_sql = "SELECT * FROM lnl_file WHERE lnl01 = ? AND lnlstore = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i350_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i350_w WITH FORM "alm/42f/almi350"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()   

   CALL cl_set_comp_visible('lik02',FALSE) #FUN-B90121 Add  #隱藏項次欄位
 
   LET g_action_choice = ""
   CALL i350_menu()
 
   CLOSE WINDOW i350_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i350_curs()
 
   CLEAR FORM    
   CONSTRUCT BY NAME g_wc ON  
                    #lnl01,lnlstore,lnllegal,lnl03,lnl04,lnl05,lnl06, #FUN-B90121 Mark
                     lnl01,lnlstore,lnllegal,lnl03,lnl04,lnl05,lnl09, #FUN-B90121 Add
                    #lnl07,lnl08,lnl09,lnl10,                         #FUN-B90121 Mark
                     lnluser,lnlgrup,lnloriu,lnlorig,lnlmodu,lnldate,lnlacti,lnlcrat#No:FUN-9B0136
                     
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lnl01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lnl01"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lnlstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lnl01
               NEXT FIELD lnl01 
                                   
            WHEN INFIELD(lnlstore)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lnlstore"
               LET g_qryparam.state = "c"             
               LET g_qryparam.where = " lnlstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lnlstore
               NEXT FIELD lnlstore
   
            WHEN INFIELD(lnllegal)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lnllegal"
               LET g_qryparam.state = "c"     
               LET g_qryparam.where = " lnlstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lnllegal
               NEXT FIELD lnllegal
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
   IF INT_FLAG THEN
      RETURN
   END IF
   
 
   #Begin:FUN-980030
   #    IF g_priv2='4' THEN   
   #        LET g_wc = g_wc clipped," AND lnluser = '",g_user,"'"
   #    END IF
   #    IF g_priv3='4' THEN   
   #        LET g_wc = g_wc clipped," AND lnlgrup MATCHES '",g_grup CLIPPED,"*'"
   #    END IF
   #    IF g_priv3 MATCHES "[5678]" THEN 
   #        LET g_wc = g_wc clipped," AND lnlgrup IN",cl_chk_tgrup_list()
   #    END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lnluser', 'lnlgrup')
   #End:FUN-980030

  #FUN-B90121 Add Begin ---
   CONSTRUCT g_wc2 ON lik03,lik04,lik05,lik06,lik07,lik08,lik09,lik10
                 FROM s_lik[1].lik03,s_lik[1].lik04,s_lik[1].lik05,
                      s_lik[1].lik06,s_lik[1].lik07,s_lik[1].lik08,
                      s_lik[1].lik09,s_lik[1].lik10       
 
      BEFORE CONSTRUCT
   
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(lik03) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_lik03" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lik03
                 NEXT FIELD lik03
                 
            WHEN INFIELD(lik04) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_lik04"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lik04
                 NEXT FIELD lik04

            WHEN INFIELD(lik05) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_lik05"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lik05
                 NEXT FIELD lik05
                 
            WHEN INFIELD(lik06) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_lik06"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lik06
                 NEXT FIELD lik06
                 
            WHEN INFIELD(lik07) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_lik07"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lik07
                 NEXT FIELD lik07
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
  #FUN-B90121 Add End -----

   IF g_wc2 = " 1=1" THEN #FUN-B90121 Add 
      LET g_sql = "SELECT lnl01,lnlstore FROM lnl_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   and lnlstore in ",g_auth,  #No.FUN-A10060
                  " ORDER BY lnl01"
  #FUN-B90121 Add Begin ---
   ELSE
      LET g_sql = "SELECT UNIQUE lnl01,lnlstore ",
                  "  FROM lnl_file,lik_file ",
                  " WHERE lnl01 = lik01 AND lnlstore = likstore ",
                  "   AND lnlstore IN ",g_auth,
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lnl01"
   END IF
  #FUN-B90121 Add End -----
 
   PREPARE i350_prepare FROM g_sql
   DECLARE i350_cs                                # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i350_prepare

  #FUN-B90121 Mark Begin ---
  #LET g_sql = "SELECT COUNT(*) FROM lnl_file WHERE ",g_wc CLIPPED,
  #            "   and lnlstore in ",g_auth   #No.FUN-A10060
  #PREPARE i350_precount FROM g_sql
  #DECLARE i350_count CURSOR FOR i350_precount
  #FUN-B90121 Mark End -----
END FUNCTION

#FUN-B90121 Add Begin ---
FUNCTION i350_count()
DEFINE l_lnl01    LIKE lnl_file.lnl01
DEFINE l_lnlstore LIKE lnl_file.lnlstore
DEFINE l_count    LIKE type_file.num10

   LET l_count = 0
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT UNIQUE lnl01,lnlstore FROM lnl_file WHERE ",g_wc CLIPPED,
                  "   AND lnlstore in ",g_auth
   ELSE
      LET g_sql = "SELECT UNIQUE lnl01,lnlstore ",
                  "  FROM lnl_file,lik_file ",
                  " WHERE lnl01 = lik01 AND lnlstore = likstore ",
                  "   AND lnlstore IN ",g_auth,
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
   END IF
   PREPARE i350_precount FROM g_sql
   DECLARE i350_count CURSOR FOR i350_precount
   FOREACH i350_count INTO l_lnl01,l_lnlstore
      LET l_count = l_count + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET l_count = l_count - 1
         EXIT FOREACH
      END IF
   END FOREACH
   LET g_row_count = l_count
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Mark Begin --- 
#FUNCTION i350_menu()
#   
#    MENU ""
#        BEFORE MENU
#           CALL cl_navigator_setting(g_curs_index,g_row_count)
#        
#        ON ACTION insert
#           LET g_action_choice="insert"
#           IF cl_chk_act_auth() THEN
#              CALL i350_a()
#           END IF
# 
#        ON ACTION query
#           LET g_action_choice="query"
#           IF cl_chk_act_auth() THEN
#              CALL i350_q()
#           END IF
# 
#        ON ACTION next
#           CALL i350_fetch('N')
# 
#        ON ACTION previous
#           CALL i350_fetch('P')
# 
#        ON ACTION modify
#           LET g_action_choice="modify"
#           IF cl_chk_act_auth() THEN
#           #  IF cl_chk_mach_auth(g_lnl.lnlstore,g_plant) THEN 
#                 CALL i350_u('w')
#           #  END IF    
#           END IF   
#   
#        ON ACTION invalid
#           LET g_action_choice="invalid"
#           IF cl_chk_act_auth() THEN
#           #   IF cl_chk_mach_auth(g_lnl.lnlstore,g_plant) THEN 
#                 CALL i350_x()
#           #   END IF   
#           END IF
# 
#        ON ACTION delete
#           LET g_action_choice="delete"
#           IF cl_chk_act_auth() THEN
#           #   IF cl_chk_mach_auth(g_lnl.lnlstore,g_plant) THEN 
#                  CALL i350_r()
#           #   END IF    
#           END IF
# 
#        ON ACTION reproduce
#           LET g_action_choice="reproduce"
#           IF cl_chk_act_auth() THEN
#              CALL i350_copy()
#           END IF   
#                
#        ON ACTION help
#           CALL cl_show_help()
# 
#        ON ACTION exit
#           LET g_action_choice = "exit"
#           EXIT MENU
# 
#        ON ACTION jump
#           CALL i350_fetch('/')
# 
#        ON ACTION first
#           CALL i350_fetch('F')
# 
#        ON ACTION last
#           CALL i350_fetch('L')
# 
#        ON ACTION controlg
#           CALL cl_cmdask()
# 
#        ON ACTION locale
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont() 
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE MENU
# 
#        ON ACTION about 
#           CALL cl_about() 
# 
#        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
#           LET INT_FLAG = FALSE 
#           LET g_action_choice = "exit"
#           EXIT MENU
# 
#        ON ACTION related_document 
#           LET g_action_choice="related_document"
#           IF cl_chk_act_auth() THEN
#              IF NOT cl_null(g_lnl.lnl01) THEN
#                 LET g_doc.column1 = "lnl01"
#                 LET g_doc.column2 = "lnlstore"
#                 LET g_doc.value1 = g_lnl.lnl01
#                 LET g_doc.value2 = g_lnl.lnlstore
#                 CALL cl_doc()
#              END IF
#           END IF
# 
#    END MENU
#    CLOSE i350_cs
#END FUNCTION
#FUN-B90121 Mark End -----

#FUN-B90121 Add Begin ---
FUNCTION i350_menu()
 
   WHILE TRUE
      CALL i350_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i350_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i350_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i350_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i350_u('w')
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i350_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i350_copy()
            END IF

         WHEN "p_produce"  #批次產生費用標準參數
            IF cl_chk_act_auth() THEN
               CALL i350_p_produce()
               CALL i350_b_fill(g_wc2)
               CALL i350_bp_refresh()
            END IF

         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lik),'','')
            END IF
 
         WHEN "related_document" 
              IF cl_chk_act_auth() THEN
                 IF g_lnl.lnl01 IS NOT NULL THEN
                 LET g_doc.column1 = "lnl01"
                 LET g_doc.column2 = "lnlstore"
                 LET g_doc.value1 = g_lnl.lnl01
                 LET g_doc.value2 = g_lnl.lnlstore
                 CALL cl_doc()
               END IF
         END IF
 
      END CASE
   END WHILE
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
FUNCTION i350_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lik TO s_lik.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()

      ON ACTION first
         CALL i350_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL i350_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION jump
         CALL i350_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i350_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL i350_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION p_produce   #批次產生費用標準參數
         LET g_action_choice="p_produce"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
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
 
      ON ACTION controls         
         CALL cl_set_head_visible("","AUTO")     
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-B90121 Add End -----
 
FUNCTION i350_a()
   DEFINE l_count      LIKE type_file.num5
   DEFINE l_n          LIKE type_file.num5 
#  DEFINE l_tqa06      LIKE tqa_file.tqa06 
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

   #No.MOD-9C0364 -BEGIN-----
    LET g_flag = 'N'
    SELECT COUNT(*) INTO l_n FROM rtz_file
     WHERE rtz01 = g_plant
       AND rtz28 = 'Y'
     IF l_n = 1 THEN 
        LET g_flag = 'Y'
     END IF 
   #No.MOD-9C0364 -END-------
   
    MESSAGE ""
    CLEAR FORM    
   #FUN-B90121 Add Begin ---
    CALL g_lik.clear()
    CALL cl_set_comp_visible("lik03,lmb03,lik04,lmc04,lik05,lmy04,lik06,oba02",TRUE)
    CALL cl_set_comp_required("lik03,lik04,lik05,lik06",FALSE)
   #FUN-B90121 Add End -----
    INITIALIZE g_lnl.*    LIKE lnl_file.*       
    INITIALIZE g_lnl_t.*  LIKE lnl_file.*
    INITIALIZE g_lnl_o.*  LIKE lnl_file.*     
   
     LET g_lnl01_t = NULL
     LET g_lnlstore_t = NULL 
     LET g_wc = NULL
     LET g_wc2 = NULL #FUN-B90121 Add
     CALL cl_opmsg('a')     
     
     WHILE TRUE
        IF g_flag = 'Y' THEN    #No.MOD-9C0364
           LET g_lnl.lnlstore = g_plant
           LET g_lnl.lnllegal = g_legal
        END IF                  #No.MOD-9C0364
        LET g_lnl.lnluser = g_user
        LET g_lnl.lnloriu = g_user #FUN-980030
        LET g_lnl.lnlorig = g_grup #FUN-980030
        LET g_lnl.lnlgrup = g_grup       
        LET g_lnl.lnlacti = 'Y'  
        LET g_lnl.lnlcrat = g_today  
        LET g_lnl.lnl03 = 'N'
        LET g_lnl.lnl04 = 'N'
        LET g_lnl.lnl05 = 'N'
       #FUN-B90121 Add&Mark Begin ---        
       #LET g_lnl.lnl06 = 'N'
       #LET g_lnl.lnl07 = 'N'
       #LET g_lnl.lnl08 = 'N'   
        LET g_lnl.lnl09 = 'N'
        LET g_lnl.lnldate = g_today
       #FUN-B90121 Add&Mark End -----       
        CALL i350_i("a")           
        
        IF INT_FLAG THEN  
           LET INT_FLAG = 0
           INITIALIZE g_lnl.* TO NULL
           LET g_lnl01_t = NULL
           LET g_lnlstore_t = NULL 
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF cl_null(g_lnl.lnl01) THEN    
           CONTINUE WHILE
        END IF
        IF cl_null(g_lnl.lnlstore) THEN    
           CONTINUE WHILE
        END IF                
         
        INSERT INTO lnl_file VALUES(g_lnl.*)                   
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lnl.lnl01,SQLCA.SQLCODE,0)
           CONTINUE WHILE
        ELSE
           SELECT * INTO g_lnl.* FROM lnl_file
            WHERE lnl01 = g_lnl.lnl01
              AND lnlstore = g_lnl.lnlstore        
        END IF

       #FUN-B90121 Add Begin ---
        LET g_rec_b = 0
        CALL i350_p_produce()  #批次產生費用標準參數邏輯
        CALL i350_b_fill(" 1=1")
        CALL i350_bp_refresh()
        CALL i350_b()
       #FUN-B90121 Add End -----
        
        EXIT WHILE
    END WHILE
    LET g_wc = NULL
END FUNCTION
 
FUNCTION i350_lnlstore(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1
 DEFINE   l_rtz13    LIKE rtz_file.rtz13   #FUN-A80148 add
 DEFINE   l_azt02    LIKE azt_file.azt02
 
   SELECT rtz13 INTO l_rtz13 FROM rtz_file
    WHERE rtz01 = g_lnl.lnlstore
   SELECT azt01,azt02 INTO g_lnl.lnllegal,l_azt02
     FROM azt_file,azw_file
    WHERE azt01 = azw02
      AND azw01 = g_lnl.lnlstore
   DISPLAY l_rtz13 TO FORMONLY.rtz13
   DISPLAY l_azt02 TO FORMONLY.azt02
   DISPLAY BY NAME g_lnl.lnllegal
END FUNCTION
 
FUNCTION i350_i(p_cmd)
DEFINE   p_cmd      LIKE type_file.chr1 
DEFINE   l_cnt      LIKE type_file.num5 
DEFINE   l_oaj02    LIKE oaj_file.oaj02
DEFINE   l_rtz13    LIKE rtz_file.rtz13   #FUN-A80148 add
DEFINE   l_count    LIKE type_file.num5
 
  #DISPLAY BY NAME  g_lnl.lnl03,g_lnl.lnl04,g_lnl.lnl05,g_lnl.lnl06,g_lnl.lnl07,g_lnl.lnl08,      #FUN-B90121 Mark
   DISPLAY BY NAME  g_lnl.lnl03,g_lnl.lnl04,g_lnl.lnl05,g_lnl.lnl09,g_lnl.lnloriu,g_lnl.lnlorig,  #FUN-B90121 Add
                    g_lnl.lnluser,g_lnl.lnlgrup,g_lnl.lnlmodu,g_lnl.lnldate,g_lnl.lnlacti,
                    g_lnl.lnlcrat,g_lnl.lnllegal,g_lnl.lnlstore   
   CALL i350_lnlstore(p_cmd)

  #FUN-B90121 Add&Mark Begin --- 
  #INPUT BY NAME    g_lnl.lnl01,g_lnl.lnlstore,g_lnl.lnl03, g_lnl.lnloriu,g_lnl.lnlorig,
  #                 g_lnl.lnl04,g_lnl.lnl05,g_lnl.lnl06,
  #                 g_lnl.lnl07,g_lnl.lnl08,g_lnl.lnl09,g_lnl.lnl10     
   INPUT BY NAME g_lnl.lnl01,g_lnl.lnlstore,g_lnl.lnl03,g_lnl.lnl04,g_lnl.lnl05,g_lnl.lnl09
  #FUN-B90121 Add&Mark End -----                    
           WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE  
          CALL i350_set_entry(p_cmd)
          CALL i350_set_no_entry(p_cmd) 
        #FUN-B90121 Mark Begin ---
        # CALL cl_set_comp_entry("lnl10",TRUE)       
        ##MOD-B10050 Begin---
        # IF g_lnl.lnl09 = '0' THEN
        #    CALL cl_set_comp_entry('lnl10',FALSE)
        # END IF
        ##MOD-B10050 End-----
        #FUN-B90121 Mark End -----
         #No.MOD-9C0364 -BEGIN-----
          IF g_flag = 'Y' THEN
             CALL cl_set_comp_entry("lnlstore",FALSE)
          END IF
         #No.MOD-9C0364 -END-------
          LET g_before_input_done = TRUE
          
      AFTER FIELD lnl01
          IF NOT cl_null(g_lnl.lnl01) THEN          
             IF p_cmd = "a" OR 
                (p_cmd="u" AND g_lnl.lnl01 != g_lnl01_t) THEN                       
                 CALL i350_check_lnl01(g_lnl.lnl01) 
                 IF g_success = 'N' THEN                                               
                    LET g_lnl.lnl01 = g_lnl_t.lnl01                                                               
                    DISPLAY BY NAME g_lnl.lnl01                                                                     
                    NEXT FIELD lnl01                                                                                  
                 ELSE
                    SELECT oaj02 INTO l_oaj02 FROM oaj_file
                     WHERE oaj01 = g_lnl.lnl01
                    DISPLAY l_oaj02 TO FORMONLY.oaj02  
                 END IF
               END IF  
            ELSE
               DISPLAY ' ' TO FORMONLY.oaj02   
               NEXT FIELD lnlstore
            END IF      
          
     AFTER FIELD lnlstore
         IF NOT cl_null(g_lnl.lnlstore) THEN          
             IF p_cmd = "a" OR 
                (p_cmd="u" AND g_lnl.lnlstore != g_lnlstore_t) THEN                       
                 CALL i350_check_lnlstore(g_lnl.lnlstore) 
                 IF g_success = 'N' THEN                                               
                    LET g_lnl.lnlstore = g_lnl_t.lnlstore                                                               
                    DISPLAY BY NAME g_lnl.lnlstore                                                                     
                    NEXT FIELD lnl01
                 ELSE
                 #No.MOD-9C0364 BEGIN -----
                 #  SELECT rtz13 INTO l_rtz13 FROM rtz_file
                 #   WHERE rtz01 = g_lnl.lnlstore
                 #  DISPLAY l_rtz13 TO FORMONLY.rtz13
                    CALL i350_lnlstore(p_cmd)
                 #No.MOD-9C0364 END -------
                 END IF
               END IF  
            ELSE
               DISPLAY ' ' TO FORMONLY.rtz13  
            END IF      

#FUN-B90121 Mark Begin ---
#    AFTER FIELD lnl04
#       IF g_lnl.lnl04 = 'Y' THEN 
#          IF g_lnl.lnl03 != 'Y' THEN 
#             CALL cl_err('','alm-078',1)
#             NEXT FIELD lnl03 
#          END IF 
#       END IF 
#    
#   #AFTER FIELD lnl09  #MOD-B10050
#    ON CHANGE lnl09    #MOD-B10050
#      IF NOT cl_null(g_lnl.lnl09) THEN
#         IF g_lnl.lnl09 = '0' THEN
#            LET g_lnl.lnl10 = '1'
#            DISPLAY BY NAME g_lnl.lnl10
#            CALL cl_set_comp_entry('lnl10',FALSE)
#         ELSE
#            CALL cl_set_comp_entry('lnl10',TRUE)
#         END IF 
#      END IF    
#      
#    BEFORE FIELD lnl10 
#      IF cl_null(g_lnl.lnl09) THEN
#         CALL cl_err('','alm-234',1)
#         NEXT FIELD lnl09
#      END IF 
#      
#    AFTER FIELD lnl10
#      IF NOT cl_null(g_lnl.lnl10) THEN 
#         IF g_lnl.lnl09 = '1' THEN
#            IF g_lnl.lnl10 = '1' THEN 
#               CALL cl_err('','alm-235',1)
#               NEXT FIELD lnl09 
#            END IF  
#         END IF 
#      END IF    
#FUN-B90121 Mark End -----
 
     AFTER INPUT   
        LET g_lnl.lnluser = s_get_data_owner("lnl_file") #FUN-C10039
        LET g_lnl.lnlgrup = s_get_data_group("lnl_file") #FUN-C10039
       IF INT_FLAG THEN 
          EXIT INPUT 
        ELSE               
          #FUN-B90121 Add&Mark Begin ---        
          #IF (g_lnl.lnl03='N' AND g_lnl.lnl04='N' AND g_lnl.lnl04='N' AND
          #    g_lnl.lnl05='N' AND g_lnl.lnl06='N' AND g_lnl.lnl07='N' AND
          #    g_lnl.lnl08='N')  THEN 
          #    CALL cl_err('','alm-079',1)
          #    NEXT FIELD lnl03
          # END IF
          #IF g_lnl.lnl04 = 'Y' THEN 
          #  IF g_lnl.lnl03 != 'Y' THEN 
          #     CALL cl_err('','alm-078',1)
          #     NEXT FIELD lnl03 
          #  END IF 
          #END IF   
          #IF NOT cl_null(g_lnl.lnl10) THEN 
          #  IF g_lnl.lnl09 = '1' THEN
          #    IF g_lnl.lnl10 = '1' THEN 
          #       CALL cl_err('','alm-235',1)
          #       NEXT FIELD lnl09 
          #    END IF  
          #  END IF 
          #END IF
           
           IF (g_lnl.lnl03='N' AND g_lnl.lnl04='N' AND 
               g_lnl.lnl05='N' AND g_lnl.lnl09='N') THEN
               CALL cl_err('','alm-852',1) #樓棟、樓層、區域、小類至少要選擇一項
               NEXT FIELD lnl03
           END IF
          #FUN-B90121 Add&Mark End -----
        END IF  
       
     ON ACTION CONTROLP
        CASE
        WHEN INFIELD(lnl01)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_oaj5"  
            LET g_qryparam.default1 = g_lnl.lnl01
            CALL cl_create_qry()  RETURNING g_lnl.lnl01
            DISPLAY BY NAME g_lnl.lnl01
            NEXT FIELD lnl01
            
        WHEN INFIELD(lnlstore)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_rtz7"  
            LET g_qryparam.default1 = g_lnl.lnlstore
            LET g_qryparam.where = " rtz01 IN ",g_auth," "  #No.FUN-A10060
            CALL cl_create_qry()  RETURNING g_lnl.lnlstore
            DISPLAY BY NAME g_lnl.lnlstore
            NEXT FIELD lnlstore    
            
          OTHERWISE
            EXIT CASE
        END CASE       
      
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION CONTROLF  
        CALL cl_set_focus_form(ui.Interface.getRootNode())
             RETURNING g_fld_name,g_frm_name 
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
 
FUNCTION i350_q()
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    INITIALIZE g_lnl.* TO NULL
    INITIALIZE g_lnl_t.* TO NULL
    INITIALIZE g_lnl_o.* TO NULL
    
    LET g_lnl01_t = NULL
    LET g_lnlstore_t = NULL 
    LET g_wc = NULL
    
    MESSAGE ""
   #FUN-B90121 Add Begin ---
    CLEAR FORM
    CALL g_lik.clear()
    CALL cl_set_comp_visible("lik03,lmb03,lik04,lmc04,lik05,lmy04,lik06,oba02",TRUE)
    CALL cl_set_comp_required("lik03,lik04,lik05,lik06",FALSE)
   #FUN-B90121 Add End -----
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    
    CALL i350_curs()  
          
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_lnl.* TO NULL
       LET g_lnl01_t = NULL
       LET g_lnlstore_t = NULL 
       LET g_wc = NULL
       RETURN
    END IF
   #FUN-B90121 Add&Mark Begin --- 
   #OPEN i350_count
   #FETCH i350_count INTO g_row_count
    CALL i350_count()
   #FUN-B90121 Add&Mark End -----
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i350_cs   
         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lnl.lnl01,SQLCA.sqlcode,0)
       INITIALIZE g_lnl.* TO NULL
       LET g_lnl01_t = NULL
       LET g_lnlstore_t = NULL 
       LET g_wc = NULL
    ELSE
       CALL i350_fetch('F')  
    END IF
END FUNCTION
 
FUNCTION i350_fetch(p_icb)
 DEFINE p_icb LIKE type_file.chr1 
 
    CASE p_icb
        WHEN 'N' FETCH NEXT     i350_cs INTO g_lnl.lnl01,g_lnl.lnlstore
        WHEN 'P' FETCH PREVIOUS i350_cs INTO g_lnl.lnl01,g_lnl.lnlstore
        WHEN 'F' FETCH FIRST    i350_cs INTO g_lnl.lnl01,g_lnl.lnlstore
        WHEN 'L' FETCH LAST     i350_cs INTO g_lnl.lnl01,g_lnl.lnlstore
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
            FETCH ABSOLUTE g_jump i350_cs INTO g_lnl.lnl01,g_lnl.lnlstore
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lnl.lnl01,SQLCA.sqlcode,0)
       INITIALIZE g_lnl.* TO NULL
       LET g_lnl01_t = NULL
       LET g_lnlstore_t = NULL 
       RETURN
    ELSE
      CASE p_icb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO  FORMONLY.idx
    END IF
 
    SELECT * INTO g_lnl.* FROM lnl_file  
     WHERE lnl01 = g_lnl.lnl01
       AND lnlstore = g_lnl.lnlstore
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lnl.lnl01,SQLCA.sqlcode,0)
    ELSE
       LET g_data_owner = g_lnl.lnluser 
       LET g_data_group = g_lnl.lnlgrup
       CALL i350_show() 
    END IF
END FUNCTION
 
FUNCTION i350_show() 
 DEFINE l_oaj02          LIKE oaj_file.oaj02
 
    LET g_lnl_t.* = g_lnl.*
    LET g_lnl_o.* = g_lnl.*
   #FUN-B90121 Add&Mark Begin ---
   #DISPLAY BY NAME g_lnl.lnl01,g_lnl.lnlstore,g_lnl.lnl03,g_lnl.lnl04, g_lnl.lnloriu,g_lnl.lnlorig,
   #                g_lnl.lnl05,g_lnl.lnl06,g_lnl.lnl07,g_lnl.lnl08,
   #                g_lnl.lnl09,g_lnl.lnl10,g_lnl.lnluser,g_lnl.lnlgrup,
   #                g_lnl.lnlmodu,g_lnl.lnldate,g_lnl.lnlacti,g_lnl.lnlcrat,
   #                g_lnl.lnllegal
    DISPLAY BY NAME g_lnl.lnl01,g_lnl.lnlstore,g_lnl.lnllegal,g_lnl.lnl03,
                    g_lnl.lnl04,g_lnl.lnl05,g_lnl.lnl09,
                    g_lnl.lnluser,g_lnl.lnlgrup,g_lnl.lnloriu,
                    g_lnl.lnlmodu,g_lnl.lnldate,g_lnl.lnlorig,
                    g_lnl.lnlacti,g_lnl.lnlcrat
   #FUN-B90121 Add&Mark End -----
    
    CALL cl_show_fld_cont() 
          
    SELECT oaj02 INTO l_oaj02 FROM oaj_file
     WHERE oaj01 = g_lnl.lnl01
     DISPLAY l_oaj02 TO FORMONLY.oaj02
  
    CALL i350_lnlstore('d')
    CALL i350_b_set_visible() #動態顯示或隱藏單身的樓棟、樓層、區域、小類欄位
    CALL i350_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i350_u(p_w)
DEFINE  p_w   LIKE type_file.chr1
DEFINE  l_n   LIKE type_file.num5 #No.MOD-9C0364
 
    IF cl_null(g_lnl.lnl01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF    
    IF cl_null(g_lnl.lnlstore) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF    
     IF g_lnl.lnlacti = 'N' THEN
       CALL cl_err(g_lnl.lnl01,9027,0)
       RETURN
    END IF 
       
    SELECT * INTO g_lnl.* FROM lnl_file 
     WHERE lnl01 = g_lnl.lnl01
       AND lnlstore = g_lnl.lnlstore                                   
       
   #No.MOD-9C0364 -BEGIN-----
    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt FROM rtz_file
     WHERE rtz01 = g_plant
       AND rtz28 = 'Y'
    IF g_cnt = 1 THEN
       IF g_lnl.lnlstore <> g_plant THEN
          CALL cl_err('','alm-708',0)
          RETURN
       END IF
    END IF
   #No.MOD-9C0364 -END-------

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lnl01_t = g_lnl.lnl01
    LET g_lnlstore_t = g_lnl.lnlstore
    BEGIN WORK
 
    OPEN i350_cl USING g_lnl.lnl01,g_lnl.lnlstore
    IF STATUS THEN
       CALL cl_err("OPEN i350_cl:",STATUS,1)
       CLOSE i350_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i350_cl INTO g_lnl.*  
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lnl.lnl01,SQLCA.sqlcode,1)
       CLOSE i350_cl
       ROLLBACK WORK
       RETURN
    END IF
    ##########
    LET g_date = g_lnl.lnldate
    LET g_modu = g_lnl.lnlmodu
    ##########
    IF p_w != 'c' THEN 
       LET g_lnl.lnlmodu = g_user  
       LET g_lnl.lnldate = g_today 
    ELSE
     	 LET g_lnl.lnlmodu = NULL  
       LET g_lnl.lnldate = NULL 
    END IF    
    CALL i350_show()                 
   #No.MOD-9C0364 -BEGIN-----
    LET g_flag = 'N'
    SELECT COUNT(*) INTO l_n FROM rtz_file
     WHERE rtz01 = g_plant
       AND rtz28 = 'Y'
    IF l_n = 1 THEN
       LET g_flag = 'Y'
    END IF
   #No.MOD-9C0364 -END-------
    WHILE TRUE
       CALL i350_i("u")          
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          #################
          LET g_lnl_t.lnldate = g_date
          LET g_lnl_t.lnlmodu = g_modu
         ################## 
          LET g_lnl.*=g_lnl_t.*
          CALL i350_show()
          CALL cl_err('',9001,0)        
          EXIT WHILE
       END IF

      #FUN-B90121 Add Begin ---
       IF g_lnl.lnl01 != g_lnl01_t THEN       
          UPDATE lik_file SET lik01 = g_lnl.lnl01
           WHERE lik01 = g_lnl01_t AND lnlstore = g_lnlstore_t
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err3("upd","lik_file",g_lnl_t.lnl01,g_lnl_t.lnlstore,SQLCA.sqlcode,"","lik",1)  
             CONTINUE WHILE
          END IF
       END IF
      #FUN-B90121 Add End -----
 
       UPDATE lnl_file SET lnl_file.* = g_lnl.* 
        WHERE lnl01 = g_lnl01_t
          AND lnlstore = g_lnlstore_t
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lnl.lnl01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i350_cl
    COMMIT WORK
END FUNCTION

FUNCTION i350_x()
    IF cl_null(g_lnl.lnl01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF cl_null(g_lnl.lnlstore) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF    
        
    BEGIN WORK
 
    OPEN i350_cl USING g_lnl.lnl01,g_lnl.lnlstore
    IF STATUS THEN
       CALL cl_err("OPEN i350_cl:",STATUS,1)
       CLOSE i350_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i350_cl INTO g_lnl.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lnl.lnl01,SQLCA.sqlcode,1)
       CLOSE i350_cl
       ROLLBACK WORK  
       RETURN
    END IF
    CALL i350_show()
    IF cl_exp(0,0,g_lnl.lnlacti) THEN
       LET g_chr=g_lnl.lnlacti
       IF g_lnl.lnlacti='Y' THEN
          LET g_lnl.lnlacti='N'
          LET g_lnl.lnlmodu = g_user
          LET g_lnl.lnldate = g_today
       ELSE
          LET g_lnl.lnlacti='Y'
          LET g_lnl.lnlmodu = g_user
          LET g_lnl.lnldate = g_today
       END IF
       UPDATE lnl_file SET lnlacti = g_lnl.lnlacti,
                           lnlmodu = g_lnl.lnlmodu,
                           lnldate = g_lnl.lnldate
        WHERE lnl01 = g_lnl.lnl01
          AND lnlstore = g_lnl.lnlstore
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err(g_lnl.lnl01,SQLCA.sqlcode,0)
          LET g_lnl.lnlacti = g_chr
          DISPLAY BY NAME g_lnl.lnlacti
          CLOSE i350_cl
          ROLLBACK WORK
          RETURN 
       END IF
       DISPLAY BY NAME g_lnl.lnlmodu,g_lnl.lnldate,g_lnl.lnlacti
    END IF
    CLOSE i350_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i350_r()
DEFINE l_count     LIKE type_file.num5 
DEFINE l_lik03     LIKE lik_file.lik03
DEFINE l_lik04     LIKE lik_file.lik04
DEFINE l_lik05     LIKE lik_file.lik05
DEFINE l_lik06     LIKE lik_file.lik06
DEFINE l_lik07     LIKE lik_file.lik07
 
   IF cl_null(g_lnl.lnl01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF cl_null(g_lnl.lnlstore) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF     
   IF g_lnl.lnlacti = 'N' THEN 
      CALL cl_err('','alm-147',1)
      RETURN  
   END IF 

  #FUN-B90121 Add&Mark Begin ---
  #SELECT COUNT(*) INTO l_count FROM lnm_file
  # WHERE lnm01 = g_lnl.lnl01 
  #   AND lnmstore = g_lnl.lnlstore
  #IF l_count > 0 THEN 
  #   CALL cl_err('','alm-501',1)
  #   RETURN 
  #END IF    

   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
   IF g_cnt = 1 THEN
      IF g_lnl.lnlstore <> g_plant THEN
         CALL cl_err('','alm-708',0)
         RETURN
      END IF
   END IF

   LET g_sql = "SELECT lik03,lik04,lik05,lik06,lik07 FROM lik_file WHERE lik01 = '",g_lnl.lnl01,"' "
   PREPARE sel_lik_pre FROM g_sql
   DECLARE sel_lik_cs CURSOR FOR sel_lik_pre
   FOREACH sel_lik_cs INTO l_lik03,l_lik04,l_lik05,l_lik06,l_lik07
      IF STATUS then
         CALL cl_err('',STATUS,1)
         RETURN
      END IF
      IF NOT i350_chk_upd(l_lik03,l_lik04,l_lik05,l_lik06,l_lik07) THEN
         CALL cl_err('','alm1517',0)
         RETURN
      END IF
   END FOREACH

  #FUN-B90121 Add&Mark End -----
       
    BEGIN WORK
 
    OPEN i350_cl USING g_lnl.lnl01,g_lnl.lnlstore
    IF STATUS THEN
       CALL cl_err("OPEN i350_cl:",STATUS,0)
       CLOSE i350_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i350_cl INTO g_lnl.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lnl.lnl01,SQLCA.sqlcode,0)
       CLOSE i350_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL i350_show()
   #IF cl_delete() THEN  #FUN-B90121 Mark
    IF cl_delh(0,0) THEN #FUN-B90121 Add
        INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lnl01"            #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "lnlstore"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lnl.lnl01         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_lnl.lnlstore      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       DELETE FROM lnl_file WHERE lnl01 = g_lnl.lnl01
                              AND lnlstore = g_lnl.lnlstore
      #FUN-B90121 Add Begin ---
       DELETE FROM lik_file WHERE lik01 = g_lnl.lnl01 
                              AND likstore = g_lnl.lnlstore
      #FUN-B90121 Add End -----
       CLEAR FORM
       CALL g_lik.clear()  #FUN-B90121 Add
      #FUN-B90121 Add&Mark Begin ---
      #OPEN i350_count
      ##FUN-B50063-add-start--
      #IF STATUS THEN
      #   CLOSE i350_cs
      #   CLOSE i350_count
      #   COMMIT WORK
      #   RETURN
      #END IF
      ##FUN-B50063-add-end--
      #FETCH i350_count INTO g_row_count
      ##FUN-B50063-add-start--
      #IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      #   CLOSE i350_cs
      #   CLOSE i350_count
      #   COMMIT WORK
      #   RETURN
      #END IF
      ##FUN-B50063-add-end--

       CALL i350_count()
      #FUN-B90121 Add&Mark End -----
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i350_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i350_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i350_fetch('/')
       END IF
    END IF
    CLOSE i350_cl
    COMMIT WORK
END FUNCTION

#FUN-B90121 Add Begin ---
FUNCTION i350_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                
    l_n             LIKE type_file.num5,                
    l_cnt           LIKE type_file.num5,                
    l_lock_sw       LIKE type_file.chr1,                
    p_cmd           LIKE type_file.chr1,                
    l_allow_insert  LIKE type_file.num5,               
    l_allow_delete  LIKE type_file.num5
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_lnl.lnl01 IS NULL THEN
       RETURN
    END IF 
 
    SELECT * INTO g_lnl.* FROM lnl_file
     WHERE lnl01 = g_lnl.lnl01 AND lnlstore = g_lnl.lnlstore
 
    IF g_lnl.lnlacti ='N' THEN    
       CALL cl_err(g_lnl.lnl01,'mfg1000',0)
       RETURN
    END IF

    LET g_cnt = 0
    SELECT COUNT(*) INTO g_cnt FROM rtz_file
     WHERE rtz01 = g_plant
       AND rtz28 = 'Y'
    IF g_cnt = 1 THEN
       IF g_lnl.lnlstore <> g_plant THEN
          CALL cl_err('','alm-708',0)
          RETURN
       END IF
    END IF

    CALL i350_b_set_visible() #動態顯示或隱藏單身的樓棟、樓層、區域、小類欄位
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT lik02,lik03,'',lik04,'',lik05,'', ",
                       "       lik06,'',lik07,'',lik08,lik09,lik10 ",
                       "  FROM lik_file ",
                       " WHERE lik01= ? AND lik02 = ? AND likstore = ? FOR UPDATE"  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i350_bcl CURSOR FROM g_forupd_sql      
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_lik WITHOUT DEFAULTS FROM s_lik.*
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
           LET l_lock_sw = 'N'            
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i350_cl USING g_lnl.lnl01,g_lnl.lnlstore
           IF STATUS THEN
              CALL cl_err("OPEN i350_cl:", STATUS, 1)
              CLOSE i350_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i350_cl INTO g_lnl.*            
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lnl.lnl01,SQLCA.sqlcode,0)      
              CLOSE i350_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd = 'u'
              LET g_lik_t.* = g_lik[l_ac].*  
              OPEN i350_bcl USING g_lnl.lnl01,g_lik_t.lik02,g_lnl.lnlstore
              IF STATUS THEN
                 CALL cl_err("OPEN i350_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i350_bcl INTO g_lik[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lik_t.lik02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i350_valid_chk()
                 CALL i350_lik06()
                 CALL i350_lik07() 
                 CALL i350_lik09(g_lik[l_ac].lik09) #FUN-C20078 add
              END IF
              CALL cl_show_fld_cont()
           END IF

        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd = 'a'
           INITIALIZE g_lik[l_ac].* TO NULL          
           LET g_lik_t.* = g_lik[l_ac].*         
           CALL cl_show_fld_cont() 
           CALL i350_get_lik02()
           NEXT FIELD lik03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO lik_file(lik01,lik02,lik03,lik04,lik05,lik06,lik07,
                                lik08,lik09,lik10,likstore,liklegal)  
           VALUES(g_lnl.lnl01,g_lik[l_ac].lik02,g_lik[l_ac].lik03,
                  g_lik[l_ac].lik04,g_lik[l_ac].lik05,g_lik[l_ac].lik06,
                  g_lik[l_ac].lik07,g_lik[l_ac].lik08,g_lik[l_ac].lik09,
                  g_lik[l_ac].lik10,g_lnl.lnlstore,g_lnl.lnllegal)                      
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lik_file",g_lnl.lnl01,g_lik[l_ac].lik02,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b = g_rec_b + 1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        AFTER FIELD lik03                       
           IF NOT cl_null(g_lik[l_ac].lik03) THEN
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lik[l_ac].lik03 <> g_lik_t.lik03) THEN
                 CALL i350_valid_chk()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lik[l_ac].lik03 = g_lik_t.lik03
                    NEXT FIELD lik03
                 END IF
                 IF NOT cl_null(g_lik[l_ac].lik07) THEN
                    CALL i350_chk_repeat(p_cmd)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_lik[l_ac].lik03 = g_lik_t.lik03
                       NEXT FIELD lik03
                    END IF
                 END IF
              END IF
           ELSE
              LET g_lik[l_ac].lmb03 = NULL
           END IF

        AFTER FIELD lik04     
           IF NOT cl_null(g_lik[l_ac].lik04) THEN
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lik[l_ac].lik04 <> g_lik_t.lik04) THEN
                 CALL i350_valid_chk()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lik[l_ac].lik04 = g_lik_t.lik04
                    NEXT FIELD lik04
                 END IF
                 IF NOT cl_null(g_lik[l_ac].lik07) THEN
                    CALL i350_chk_repeat(p_cmd)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_lik[l_ac].lik04 = g_lik_t.lik04
                       NEXT FIELD lik04
                    END IF           
                 END IF              
              END IF
           ELSE
              LET g_lik[l_ac].lmc04 = NULL
           END IF 

        AFTER FIELD lik05
           IF NOT cl_null(g_lik[l_ac].lik05) THEN
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lik[l_ac].lik05 <> g_lik_t.lik05) THEN
                 CALL i350_valid_chk()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lik[l_ac].lik05 = g_lik_t.lik05
                    NEXT FIELD lik05
                 END IF
                 IF NOT cl_null(g_lik[l_ac].lik07) THEN
                    CALL i350_chk_repeat(p_cmd)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_lik[l_ac].lik05 = g_lik_t.lik05
                       NEXT FIELD lik05
                    END IF           
                 END IF              
              END IF
           ELSE
              LET g_lik[l_ac].lmy04 = NULL
           END IF 

        AFTER FIELD lik06     
           IF NOT cl_null(g_lik[l_ac].lik06) THEN
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lik[l_ac].lik06 <> g_lik_t.lik06) THEN
                 CALL i350_lik06()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lik[l_ac].lik06 = g_lik_t.lik06
                    NEXT FIELD lik06
                 END IF
                 IF NOT cl_null(g_lik[l_ac].lik07) THEN
                    CALL i350_chk_repeat(p_cmd)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       LET g_lik[l_ac].lik06 = g_lik_t.lik06
                       NEXT FIELD lik06
                    END IF           
                 END IF              
              END IF
           ELSE
              LET g_lik[l_ac].oba02 = NULL
           END IF 

        AFTER FIELD lik07
           IF NOT cl_null(g_lik[l_ac].lik07) THEN
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lik[l_ac].lik07 <> g_lik_t.lik07) THEN
                 CALL i350_chk_repeat(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lik[l_ac].lik07 = g_lik_t.lik07
                    NEXT FIELD lik07
                 END IF
                 CALL i350_lik07()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_lik[l_ac].lik07 = g_lik_t.lik07
                    NEXT FIELD lik07
                 END IF
              END IF
           ELSE
              LET g_lik[l_ac].tqa02 = NULL
           END IF
        #FUN-C20078 STA  --- 
        ON CHANGE lik09
           IF g_lik[l_ac].lik09 = '5' THEN 
              LET g_lik[l_ac].lik10 = '2'
           END IF    
           CALL i350_lik09(g_lik[l_ac].lik09)
           
        #FUN-C20078 END  --- 

        #TQC-C30290--start add-------------------------------
        AFTER FIELD lik09
           IF NOT cl_null(g_lik[l_ac].lik09) THEN
              IF NOT cl_null(g_lik[l_ac].lik10) THEN
                 IF g_lik[l_ac].lik10 = '2' AND g_lik[l_ac].lik09 <> 5 THEN
                    CALL cl_err('','alm1617',0)
                    NEXT FIELD lik10
                 END IF 
                 IF g_lik[l_ac].lik10 ='3' THEN
                    IF g_lik[l_ac].lik09 <> '1' AND g_lik[l_ac].lik09 <> '2' THEN
                       CALL cl_err('','alm1613',0)
                       NEXT FIELD lik09
                    END IF
                 END IF 
              END IF 
           END IF    
        #TQC-C30290--end add---------------------------------

        #TQC-C20383 STA ---
        ON CHANGE lik10
           IF g_lik[l_ac].lik10 = '2' THEN 
              LET g_lik[l_ac].lik09 = '5'
           END IF
           CALL i350_lik09(g_lik[l_ac].lik09)
        AFTER FIELD lik10
           IF g_lik[l_ac].lik10 = '2' THEN 
              LET g_lik[l_ac].lik09 = '5'
           END IF
           #TQC-C30290--start add-------------------------------
           IF NOT cl_null(g_lik[l_ac].lik10) THEN
              IF NOT cl_null(g_lik[l_ac].lik09) THEN
                IF g_lik[l_ac].lik10 = '3' THEN
                   IF g_lik[l_ac].lik09 <> '1' AND g_lik[l_ac].lik09 <> '2' THEN
                      CALL cl_err('','alm1613',0)
                      NEXT FIELD lik09
                   END IF  
                END IF       
              END IF   
           END IF     
           #TQC-C30290--end add---------------------------------       
           CALL i350_lik09(g_lik[l_ac].lik09)
        #TQC-C20383 END ---    
        BEFORE DELETE                      
           DISPLAY "BEFORE DELETE"
           IF g_lik_t.lik02 > 0 AND g_lik_t.lik02 IS NOT NULL THEN
              IF NOT i350_chk_upd(g_lik_t.lik03,g_lik_t.lik04,g_lik_t.lik05,g_lik_t.lik06,g_lik_t.lik07) THEN
                 CALL cl_err('','alm1517',0)
                 CANCEL DELETE
              END IF
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lik_file
               WHERE lik01 = g_lnl.lnl01
                 AND lik02 = g_lik_t.lik02
                 AND likstore = g_lnl.lnlstore
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lik_file",g_lnl.lnl01,g_lik_t.lik02,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b = g_rec_b - 1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lik[l_ac].* = g_lik_t.*
              CLOSE i350_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lik[l_ac].lik02,-263,1)
              LET g_lik[l_ac].* = g_lik_t.*
           ELSE
              IF NOT i350_chk_upd(g_lik_t.lik03,g_lik_t.lik04,g_lik_t.lik05,g_lik_t.lik06,g_lik_t.lik07) THEN
                 CALL cl_err('','alm1517',0)
                 LET g_lik[l_ac].* = g_lik_t.*
              ELSE
                 UPDATE lik_file SET lik02=g_lik[l_ac].lik02,
                                     lik03=g_lik[l_ac].lik03,
                                     lik04=g_lik[l_ac].lik04,
                                     lik05=g_lik[l_ac].lik05,
                                     lik06=g_lik[l_ac].lik06,
                                     lik07=g_lik[l_ac].lik07,
                                     lik08=g_lik[l_ac].lik08,
                                     lik09=g_lik[l_ac].lik09,
                                     lik10=g_lik[l_ac].lik10
                  WHERE lik01=g_lnl.lnl01
                    AND lik02=g_lik_t.lik02
                    AND likstore = g_lnl.lnlstore
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","lik_file",g_lnl.lnl01,g_lik_t.lik02,SQLCA.sqlcode,"","",1)  
                    LET g_lik[l_ac].* = g_lik_t.*
                 ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                 END IF
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
                 LET g_lik[l_ac].* = g_lik_t.*
              END IF
              IF p_cmd = 'a' THEN 
                 CALL g_lik.deleteElement(l_ac)
              END IF 
              CLOSE i350_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i350_bcl
           COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(lik03) #樓棟開窗
                 CALL cl_init_qry_var()
                 IF NOT cl_null(g_lik[l_ac].lik04) AND g_lik[l_ac].lik04 <> '*' THEN
                    IF NOT cl_null(g_lik[l_ac].lik05) AND g_lik[l_ac].lik05 <> '*' THEN
                       LET g_qryparam.form = "q_lmy01"
                       LET g_qryparam.where = " lmy02 = '",g_lik[l_ac].lik04,"' AND lmy03 = '",g_lik[l_ac].lik05,"' AND lmystore = '",g_lnl.lnlstore,"' "
                    ELSE
                       LET g_qryparam.form = "q_lmc02"
                       LET g_qryparam.where = " lmc03 = '",g_lik[l_ac].lik04,"' AND lmcstore = '",g_lnl.lnlstore,"' "
                    END IF
                 ELSE
                    IF NOT cl_null(g_lik[l_ac].lik05) AND g_lik[l_ac].lik05 <> '*' THEN
                       LET g_qryparam.form = "q_lmy01"
                       LET g_qryparam.where = " lmy03 = '",g_lik[l_ac].lik05,"' AND lmystore = '",g_lnl.lnlstore,"' "
                    ELSE
                       LET g_qryparam.form = "q_lmb02"
                       LET g_qryparam.where = " lmbstore = '",g_lnl.lnlstore,"' "
                    END IF
                 END IF
                 CALL cl_create_qry() RETURNING g_lik[l_ac].lik03
                 DISPLAY g_lik[l_ac].lik03 TO lik03
                 NEXT FIELD lik03
              WHEN INFIELD(lik04) #樓層開窗
                 CALL cl_init_qry_var()
                 IF NOT cl_null(g_lik[l_ac].lik03) AND g_lik[l_ac].lik03 <> '*' THEN
                    IF NOT cl_null(g_lik[l_ac].lik05) AND g_lik[l_ac].lik05 <> '*' THEN
                       LET g_qryparam.form ="q_lmy02"
                       LET g_qryparam.where = " lmy01 = '",g_lik[l_ac].lik03,"' AND lmy03 = '",g_lik[l_ac].lik05,"' AND lmystore = '",g_lnl.lnlstore,"' "
                    ELSE
                       LET g_qryparam.form ="q_lmc03"
                       LET g_qryparam.where = " lmc02 = '",g_lik[l_ac].lik03,"' AND lmcstore = '",g_lnl.lnlstore,"' "
                    END IF
                 ELSE
                    IF NOT cl_null(g_lik[l_ac].lik05) AND g_lik[l_ac].lik05 <> '*' THEN
                       LET g_qryparam.form ="q_lmy02"
                       LET g_qryparam.where = " lmy03 = '",g_lik[l_ac].lik05,"' AND lmystore = '",g_lnl.lnlstore,"' "
                    ELSE
                       LET g_qryparam.form ="q_lmc03"
                       LET g_qryparam.where = " lmcstore = '",g_lnl.lnlstore,"' "
                    END IF
                 END IF
                 CALL cl_create_qry() RETURNING g_lik[l_ac].lik04
                 DISPLAY g_lik[l_ac].lik04 TO lik04
                 NEXT FIELD lik04
              WHEN INFIELD(lik05) #區域開窗
                 CALL cl_init_qry_var()
                 IF NOT cl_null(g_lik[l_ac].lik03) AND g_lik[l_ac].lik03 <> '*' THEN
                    IF NOT cl_null(g_lik[l_ac].lik04) AND g_lik[l_ac].lik04 <> '*' THEN
                       LET g_qryparam.form ="q_lmy03"
                       LET g_qryparam.where = " lmy01 = '",g_lik[l_ac].lik03,"' AND lmy02 = '",g_lik[l_ac].lik04,"' AND lmystore = '",g_lnl.lnlstore,"' "
                    ELSE
                       LET g_qryparam.form ="q_lmy03"
                       LET g_qryparam.where = " lmy01 = '",g_lik[l_ac].lik03,"' AND lmystore = '",g_lnl.lnlstore,"' "
                    END IF
                 ELSE
                    IF NOT cl_null(g_lik[l_ac].lik04) AND g_lik[l_ac].lik04 <> '*' THEN
                       LET g_qryparam.form ="q_lmy03"
                       LET g_qryparam.where = " lmy02 = '",g_lik[l_ac].lik04,"' AND lmystore = '",g_lnl.lnlstore,"' "
                    ELSE
                       LET g_qryparam.form ="q_lmy03"
                       LET g_qryparam.where = " lmystore = '",g_lnl.lnlstore,"' "
                    END IF
                 END IF
                 CALL cl_create_qry() RETURNING g_lik[l_ac].lik05
                 DISPLAY g_lik[l_ac].lik05 TO lik05
                 NEXT FIELD lik05
              WHEN INFIELD(lik06) #小類開窗
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_oba01"
                 CALL cl_create_qry() RETURNING g_lik[l_ac].lik06
                 DISPLAY g_lik[l_ac].lik06 TO lik06
                 NEXT FIELD lik06
              WHEN INFIELD(lik07) #攤位用途開窗
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '30'
                 LET g_qryparam.form ="q_tqa"
                 CALL cl_create_qry() RETURNING g_lik[l_ac].lik07
                 DISPLAY g_lik[l_ac].lik07 TO lik07
                 NEXT FIELD lik07
           END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION HELP          
           CALL cl_show_help()  
 
        ON ACTION controls                           
           CALL cl_set_head_visible("","AUTO")       
    END INPUT
 
    LET g_lnl.lnlmodu = g_user
    LET g_lnl.lnldate = g_today
    UPDATE lnl_file SET lnlmodu = g_lnl.lnlmodu,lnldate = g_lnl.lnldate
     WHERE lnl01 = g_lnl.lnl01 AND lnlstore = g_lnl.lnlstore
    DISPLAY BY NAME g_lnl.lnlmodu,g_lnl.lnldate
 
    CLOSE i350_bcl
    COMMIT WORK
#   CALL i350_delall() #CHI-C30002 mark
    CALL i350_delHeader()     #CHI-C30002 add
 
END FUNCTION

#FUN-B90121 Add End -----

#CHI-C30002 -------- add -------- begin
FUNCTION i350_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM lnl_file WHERE lnl01 = g_lnl.lnl01 AND lnlstore = g_lnl.lnlstore
         INITIALIZE g_lnl.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUN-B90121 Add Begin ---
#單身無資料時刪除單頭資料
#FUNCTION i350_delall()

#  SELECT COUNT(*) INTO g_cnt FROM lik_file
#   WHERE lik01 = g_lnl.lnl01 AND likstore = g_lnl.lnlstore

#  IF g_cnt = 0 THEN                   
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM lnl_file WHERE lnl01 = g_lnl.lnl01 AND lnlstore = g_lnl.lnlstore
#  END IF

#END FUNCTION
#FUN-B90121 Add End -----
#CHI-C30002 -------- mark -------- end 

#FUN-B90121 Add Begin ---
#獲取項次欄位的值
FUNCTION i350_get_lik02()

   IF g_lik[l_ac].lik02 IS NULL OR g_lik[l_ac].lik02 = 0 THEN
      SELECT MAX(lik02) + 1
        INTO g_lik[l_ac].lik02
        FROM lik_file
       WHERE lik01 = g_lnl.lnl01 AND likstore = g_lnl.lnlstore
      IF g_lik[l_ac].lik02 IS NULL THEN
         LET g_lik[l_ac].lik02 = 1
      END IF
   END IF
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#樓棟、樓層、區域、小類值有效性的判斷
FUNCTION i350_valid_chk()
DEFINE l_lmb06   LIKE lmb_file.lmb06    #樓棟資料有效碼
DEFINE l_lmc07   LIKE lmc_file.lmc07    #樓層資料有效碼
DEFINE l_lmyacti LIKE lmy_file.lmyacti  #區域資料有效碼

   LET g_errno = ''  #初始化報錯信息
   IF NOT cl_null(g_lik[l_ac].lik03) AND g_lik[l_ac].lik03 <> '*' THEN
      SELECT lmb03,lmb06 INTO g_lik[l_ac].lmb03,l_lmb06 
        FROM lmb_file 
       WHERE lmb02 = g_lik[l_ac].lik03 AND lmbstore = g_lnl.lnlstore
      CASE 
         WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-904'  #當前門店下不存在該樓棟
                                  LET g_lik[l_ac].lmb03 = NULL
         WHEN SQLCA.sqlcode = -284 LET g_errno = ''        #當存在多筆資料時，錯誤信息不做處理
                                   LET g_lik[l_ac].lmb03 = NULL
         WHEN l_lmb06 = 'N'       LET g_errno = 'alm-905'  #該樓棟已無效
         OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
      END CASE
      IF NOT cl_null(g_errno) THEN RETURN END IF
      IF NOT cl_null(g_lik[l_ac].lik04) AND g_lik[l_ac].lik04 <> '*' THEN
         #判断楼层是否正确（存在于当前门店+楼栋，且有效）
         SELECT lmc04,lmc07 INTO g_lik[l_ac].lmc04,l_lmc07 
           FROM lmc_file 
          WHERE lmc02 = g_lik[l_ac].lik03 AND lmc03 = g_lik[l_ac].lik04 AND lmcstore = g_lnl.lnlstore
         CASE
            WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-907'  #當前門店+樓棟下不存在該樓層
                                     LET g_lik[l_ac].lmc04 = NULL
            WHEN SQLCA.sqlcode = -284 LET g_errno = ''        #當存在多筆資料時，錯誤信息不做處理
                                      LET g_lik[l_ac].lmc04 = NULL
            WHEN l_lmc07 = 'N'       LET g_errno = 'alm-908'  #該樓層已無效
            OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
         END CASE
         IF NOT cl_null(g_errno) THEN RETURN END IF
         IF NOT cl_null(g_lik[l_ac].lik05) AND g_lik[l_ac].lik05 <> '*' THEN
            #判断区域是否正确（存在于当前门店+楼栋+楼层，且有效）
            SELECT lmy04,lmyacti INTO g_lik[l_ac].lmy04,l_lmyacti 
              FROM lmy_file 
             WHERE lmy01 = g_lik[l_ac].lik03 AND lmy02 = g_lik[l_ac].lik04 
               AND lmy03 = g_lik[l_ac].lik05 AND lmystore = g_lnl.lnlstore
            CASE
               WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-745'  #當前門店+樓棟+樓層下不存在該區域
                                        LET g_lik[l_ac].lmy04 = NULL
               WHEN SQLCA.sqlcode = -284 LET g_errno = ''        #當存在多筆資料時，錯誤信息不做處理
                                         LET g_lik[l_ac].lmy04 = NULL
               WHEN l_lmyacti = 'N'     LET g_errno = 'alm-746'  #該區域已無效
               OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
            END CASE
         ELSE
            LET g_lik[l_ac].lmy04 = NULL
         END IF
      ELSE
         LET g_lik[l_ac].lmc04 = NULL
         IF NOT cl_null(g_lik[l_ac].lik05) AND g_lik[l_ac].lik05 <> '*' THEN
            #判断区域是否正确（存在于当前门店+楼栋，且有效）
            SELECT lmy04,lmyacti INTO g_lik[l_ac].lmy04,l_lmyacti 
              FROM lmy_file 
             WHERE lmy01 = g_lik[l_ac].lik03 AND lmy03 = g_lik[l_ac].lik05 AND lmystore = g_lnl.lnlstore
            CASE
               WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-747'  #當前門店+樓棟下不存在該區域
                                        LET g_lik[l_ac].lmy04 = NULL
               WHEN SQLCA.sqlcode = -284 LET g_errno = ''        #當存在多筆資料時，錯誤信息不做處理
                                         LET g_lik[l_ac].lmy04 = NULL
               WHEN l_lmyacti = 'N'     LET g_errno = 'alm-746'  #該區域已無效
               OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
            END CASE
         END IF
      END IF
   ELSE
      LET g_lik[l_ac].lmb03 = NULL
      IF NOT cl_null(g_lik[l_ac].lik04) AND g_lik[l_ac].lik04 <> '*' THEN
         #判断楼层是否正确（存在于当前门店，且有效）
         SELECT lmc04,lmc07 INTO g_lik[l_ac].lmc04,l_lmc07 
           FROM lmc_file 
          WHERE lmc03 = g_lik[l_ac].lik04 AND lmcstore = g_lnl.lnlstore
         CASE
            WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-748'  #當前門店下不存在該樓層
                                     LET g_lik[l_ac].lmc04 = NULL
            WHEN SQLCA.sqlcode = -284 LET g_errno = ''        #當存在多筆資料時，錯誤信息不做處理
                                      LET g_lik[l_ac].lmc04 = NULL
            WHEN l_lmc07 = 'N'       LET g_errno = 'alm-908'  #該樓層已無效
            OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
         END CASE
         IF NOT cl_null(g_errno) THEN RETURN END IF
         IF NOT cl_null(g_lik[l_ac].lik05) AND g_lik[l_ac].lik05 <> '*' THEN
            #判断区域是否正确（存在于当前门店+楼层，且有效）
            SELECT lmy04,lmyacti INTO g_lik[l_ac].lmy04,l_lmyacti 
              FROM lmy_file 
             WHERE lmy02 = g_lik[l_ac].lik04 AND lmy03 = g_lik[l_ac].lik05 AND lmystore = g_lnl.lnlstore
            CASE
               WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-749'  #當前門店+樓層下不存在該區域
                                        LET g_lik[l_ac].lmy04 = NULL
               WHEN SQLCA.sqlcode = -284 LET g_errno = ''        #當存在多筆資料時，錯誤信息不做處理
                                         LET g_lik[l_ac].lmy04 = NULL
               WHEN l_lmyacti = 'N'     LET g_errno = 'alm-746'  #該區域已無效
               OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
            END CASE
         ELSE
            LET g_lik[l_ac].lmy04 = NULL
         END IF
      ELSE
         LET g_lik[l_ac].lmc04 = NULL
         IF NOT cl_null(g_lik[l_ac].lik05) AND g_lik[l_ac].lik05 <> '*' THEN
            #判断区域是否正确（存在于当前门店，且有效）
            SELECT lmy04,lmyacti INTO g_lik[l_ac].lmy04,l_lmyacti 
              FROM lmy_file 
             WHERE lmy03 = g_lik[l_ac].lik05 AND lmystore = g_lnl.lnlstore
            CASE
               WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-767'  #當前門店下不存在該區域
                                        LET g_lik[l_ac].lmy04 = NULL
               WHEN SQLCA.sqlcode = -284 LET g_errno = ''        #當存在多筆資料時，錯誤信息不做處理
                                         LET g_lik[l_ac].lmy04 = NULL
               WHEN l_lmyacti = 'N'     LET g_errno = 'alm-746'  #該區域已無效
               OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
            END CASE
         ELSE
            LET g_lik[l_ac].lmy04 = NULL
         END IF
      END IF
   END IF
END FUNCTION
#FUN-B90121 Add End -----
 
#FUN-B90121 Add Begin ---
#判斷是否存在重複資料(包括相同資料和交集資料)
FUNCTION i350_chk_repeat(p_cmd)
DEFINE l_n   LIKE type_file.num5
DEFINE p_cmd LIKE type_file.chr1

   LET g_errno = ''
   LET l_n = 0
   IF g_lnl.lnl03 = 'Y' AND cl_null(g_lik[l_ac].lik03) THEN RETURN END IF
   IF g_lnl.lnl04 = 'Y' AND cl_null(g_lik[l_ac].lik04) THEN RETURN END IF
   IF g_lnl.lnl05 = 'Y' AND cl_null(g_lik[l_ac].lik05) THEN RETURN END IF
   IF g_lnl.lnl09 = 'Y' AND cl_null(g_lik[l_ac].lik06) THEN RETURN END IF
   LET g_sel_sql = "SELECT COUNT(*) ",
                   "  FROM lik_file ",
                   " WHERE lik01 = '",g_lnl.lnl01,"' ",
                   "   AND likstore = '",g_lnl.lnlstore,"' AND lik07 = '",g_lik[l_ac].lik07,"' ",
                   "   AND lik02 <> '",g_lik[l_ac].lik02,"' "
   IF NOT cl_null(g_lik[l_ac].lik03) AND g_lik[l_ac].lik03 <> '*' THEN
      LET g_sel_sql = g_sel_sql," AND (lik03 = '",g_lik[l_ac].lik03,"' OR lik03 = '*') "
   END IF
   IF NOT cl_null(g_lik[l_ac].lik04) AND g_lik[l_ac].lik04 <> '*' THEN
      LET g_sel_sql = g_sel_sql," AND (lik04 = '",g_lik[l_ac].lik04,"' OR lik04 = '*') "
   END IF
   IF NOT cl_null(g_lik[l_ac].lik05) AND g_lik[l_ac].lik05 <> '*' THEN
      LET g_sel_sql = g_sel_sql," AND (lik05 = '",g_lik[l_ac].lik05,"' OR lik05 = '*') "
   END IF
   IF NOT cl_null(g_lik[l_ac].lik06) AND g_lik[l_ac].lik06 <> '*' THEN
      LET g_sel_sql = g_sel_sql," AND (lik06 = '",g_lik[l_ac].lik06,"' OR lik06 = '*') "
   END IF

   PREPARE sel_count_pre3 FROM g_sel_sql
   EXECUTE sel_count_pre3 INTO l_n
   IF (p_cmd = 'a' AND l_n > 0) OR (p_cmd = 'u' AND l_n > 0) THEN 
      LET g_errno = 'alm-799' #此筆資料已存在或已存在交集資料
   END IF
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#小類欄位邏輯檢查
FUNCTION i350_lik06()
DEFINE l_obaacti  LIKE oba_file.obaacti
DEFINE l_oba14    LIKE oba_file.oba14

   IF g_lik[l_ac].lik06 = '*' THEN RETURN END IF
   LET g_errno = ''
   SELECT oba02,oba14,obaacti INTO g_lik[l_ac].oba02,l_oba14,l_obaacti
     FROM oba_file
    WHERE oba01 = g_lik[l_ac].lik06
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-104' #無此產品分類
                               LET g_lik[l_ac].oba02 = NULL
      WHEN l_oba14 <> 0        LET g_errno = 'alm-846' #此產品分類非最小類
      WHEN l_obaacti = 'N'     LET g_errno = 'alm-781' #產品分類已無效
      OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#攤位用途欄位邏輯檢查
FUNCTION i350_lik07()   
DEFINE l_tqaacti LIKE tqa_file.tqaacti

   LET g_errno = ''
   SELECT tqa02,tqaacti INTO g_lik[l_ac].tqa02,l_tqaacti
     FROM tqa_file 
    WHERE tqa01 = g_lik[l_ac].lik07 AND tqa03 = '30'
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-780' #攤位用途不存在
                                  LET g_lik[l_ac].tqa02 = NULL
        WHEN l_tqaacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#根據單頭的勾選情況來動態顯示或隱藏單身的欄位以及必輸屬性的開啟和關閉
FUNCTION i350_b_set_visible()

   IF g_lnl.lnl03 = 'Y' THEN
      CALL cl_set_comp_visible("lik03,lmb03",TRUE)
      CALL cl_set_comp_required("lik03",TRUE)
   ELSE
      CALL cl_set_comp_required("lik03",FALSE)
      CALL cl_set_comp_visible("lik03,lmb03",FALSE)
   END IF
   IF g_lnl.lnl04 = 'Y' THEN
      CALL cl_set_comp_visible("lik04,lmc04",TRUE)
      CALL cl_set_comp_required("lik04",TRUE)
   ELSE
      CALL cl_set_comp_required("lik04",FALSE)
      CALL cl_set_comp_visible("lik04,lmc04",FALSE)
   END IF
   IF g_lnl.lnl05 = 'Y' THEN
      CALL cl_set_comp_visible("lik05,lmy04",TRUE)
      CALL cl_set_comp_required("lik05",TRUE)
   ELSE
      CALL cl_set_comp_required("lik05",FALSE)
      CALL cl_set_comp_visible("lik05,lmy04",FALSE)
   END IF
   IF g_lnl.lnl09 = 'Y' THEN
      CALL cl_set_comp_visible("lik06,oba02",TRUE)
      CALL cl_set_comp_required("lik06",TRUE)
   ELSE
      CALL cl_set_comp_required("lik06",FALSE)
      CALL cl_set_comp_visible("lik06,oba02",FALSE)
   END IF
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
FUNCTION i350_bp_refresh()

   DISPLAY ARRAY g_lik TO s_lik.* ATTRIBUTE(UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#單身填充
FUNCTION i350_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT lik02,lik03,'',lik04,'',lik05,'',lik06,'',lik07,'',lik08,lik09,lik10 ",
               "  FROM lik_file",    
               " WHERE lik01 ='",g_lnl.lnl01,"' ",
               "   AND likstore = '",g_lnl.lnlstore,"' "   
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lik03,lik04,lik05,lik06,lik07 "
   DISPLAY g_sql
 
   PREPARE i350_pb FROM g_sql
   DECLARE lik_cs CURSOR FOR i350_pb
 
   CALL g_lik.clear()
   LET g_cnt = 1
 
   FOREACH lik_cs INTO g_lik[g_cnt].*   
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i350_b_fill_1()
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_lik.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION 
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
FUNCTION i350_b_fill_1()

   SELECT lmb03 INTO g_lik[g_cnt].lmb03 
     FROM lmb_file 
    WHERE lmb02 = g_lik[g_cnt].lik03 AND lmbstore = g_lnl.lnlstore
   IF NOT cl_null(g_lik[g_cnt].lik03) AND g_lik[g_cnt].lik03 <> '*' THEN
      SELECT lmc04 INTO g_lik[g_cnt].lmc04 
        FROM lmc_file 
       WHERE lmc02 = g_lik[g_cnt].lik03 AND lmc03 = g_lik[g_cnt].lik04 AND lmcstore = g_lnl.lnlstore
      IF NOT cl_null(g_lik[g_cnt].lik04) AND g_lik[g_cnt].lik04 <> '*' THEN
         SELECT lmy04 INTO g_lik[g_cnt].lmy04 
           FROM lmy_file 
          WHERE lmy01 = g_lik[g_cnt].lik03 AND lmy02 = g_lik[g_cnt].lik04 
            AND lmy03 = g_lik[g_cnt].lik05 AND lmystore = g_lnl.lnlstore
      ELSE
         SELECT lmy04 INTO g_lik[g_cnt].lmy04 
           FROM lmy_file 
          WHERE lmy01 = g_lik[g_cnt].lik03 AND lmy03 = g_lik[g_cnt].lik05 AND lmystore = g_lnl.lnlstore
      END IF
   ELSE
      SELECT lmc04 INTO g_lik[g_cnt].lmc04 
        FROM lmc_file 
       WHERE lmc03 = g_lik[g_cnt].lik04 AND lmcstore = g_lnl.lnlstore
      IF NOT cl_null(g_lik[g_cnt].lik04) AND g_lik[g_cnt].lik04 <> '*' THEN
         SELECT lmy04 INTO g_lik[g_cnt].lmy04 
           FROM lmy_file 
          WHERE lmy02 = g_lik[g_cnt].lik04 AND lmy03 = g_lik[g_cnt].lik05 AND lmystore = g_lnl.lnlstore
      ELSE
         SELECT lmy04 INTO g_lik[g_cnt].lmy04 
           FROM lmy_file 
          WHERE lmy03 = g_lik[g_cnt].lik05 AND lmystore = g_lnl.lnlstore
      END IF
   END IF
   SELECT oba02 INTO g_lik[g_cnt].oba02
     FROM oba_file
    WHERE oba01 = g_lik[g_cnt].lik06
   SELECT tqa02 INTO g_lik[g_cnt].tqa02
     FROM tqa_file
    WHERE tqa01 = g_lik[g_cnt].lik07 AND tqa03 = '30'
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#批次處理畫面條件處理
FUNCTION i350_p_askkey()
DEFINE l_tqaacti  LIKE tqa_file.tqaacti

   CALL i350_set_cs_visible()

   DIALOG ATTRIBUTE(UNBUFFERED)
      CONSTRUCT BY NAME tm.wc1 ON lmb02
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(lmb02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmb02"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " lmbstore = '",g_lnl.lnlstore,"' "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmb02
                  NEXT FIELD lmb02
               OTHERWISE
                  EXIT CASE
            END CASE
      END CONSTRUCT

      CONSTRUCT BY NAME tm.wc2 ON lmc03
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(lmc03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmc03"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " lmcstore = '",g_lnl.lnlstore,"' "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmc03
                  NEXT FIELD lmc03
               OTHERWISE
                  EXIT CASE
            END CASE
      END CONSTRUCT

      CONSTRUCT BY NAME tm.wc3 ON lmy03
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(lmy03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmy03"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " lmystore = '",g_lnl.lnlstore,"' "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmy03
                  NEXT FIELD lmy03
               OTHERWISE
                  EXIT CASE
            END CASE
      END CONSTRUCT

      CONSTRUCT BY NAME tm.wc4 ON oba01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(oba01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oba01"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " oba14 = 0"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oba01
                  NEXT FIELD oba01
               OTHERWISE
                  EXIT CASE
            END CASE
      END CONSTRUCT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

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

      ON ACTION accept
         ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG
   END DIALOG

   IF INT_FLAG THEN
      RETURN
   END IF

   LET tm.detail = 'N'
   #如果費用設置勾選，畫面條件給了除空和*以外的值，則只能產生明細資料
   IF ((g_lnl.lnl03 = 'Y' AND tm.wc1 <> " 1=1") OR g_lnl.lnl03 = 'N') AND
      ((g_lnl.lnl04 = 'Y' AND tm.wc2 <> " 1=1") OR g_lnl.lnl04 = 'N') AND
      ((g_lnl.lnl05 = 'Y' AND tm.wc3 <> " 1=1") OR g_lnl.lnl05 = 'N') AND
      ((g_lnl.lnl09 = 'Y' AND tm.wc4 <> " 1=1") OR g_lnl.lnl09 = 'N') THEN
      LET tm.detail = 'Y'
   END IF
   DISPLAY BY NAME tm.detail
   INPUT BY NAME tm.lik07,tm.lik08,tm.lik09,tm.lik10,tm.detail WITHOUT DEFAULTS
      #FUN-C20078 STA
      BEFORE INPUT 
         CALL i350_lik09(tm.lik09)
      #FUN-C20078 END
      AFTER FIELD lik07
         IF NOT cl_null(tm.lik07) THEN
            LET g_errno = ''
            SELECT tqaacti INTO l_tqaacti
              FROM tqa_file
             WHERE tqa01 = tm.lik07 AND tqa03 = '30'
            CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-780' #攤位用途不存在
                 WHEN l_tqaacti='N'        LET g_errno = '9028'
                 OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD lik07
            END IF
         END IF
      #FUN-C20078 STA---   
      ON CHANGE lik09
         IF tm.lik09 = '5' THEN 
            LET tm.lik10 = '2'
            DISPLAY BY NAME tm.lik10
         END IF 
         CALL i350_lik09(tm.lik09)
      #FUN-C20078 END ---  
   
      #TQC-C30290--start add-------------------------------
      AFTER FIELD lik09
         IF NOT cl_null(tm.lik09) THEN
            IF NOT cl_null(tm.lik10) THEN
               IF tm.lik10 ='3' THEN
                  IF tm.lik09 <> '1' AND tm.lik09 <> '2' THEN
                     CALL cl_err('','alm1613',0)
                     NEXT FIELD lik09
                  END IF
               END IF
            END IF
         END IF
      #TQC-C30290--end add---------------------------------

      #TQC-C20383 STA ---
      ON CHANGE lik10
         IF tm.lik10 = '2' THEN 
            LET tm.lik09 = '5'
            DISPLAY BY NAME tm.lik09
         END IF
         CALL i350_lik09(tm.lik09)
      AFTER FIELD lik10
         IF tm.lik10 = '2' THEN 
            LET tm.lik09 = '5'
            DISPLAY BY NAME tm.lik09
         END IF

         #TQC-C30290--start add-------------------------------
         IF NOT cl_null(tm.lik10) THEN
            IF NOT cl_null(tm.lik09) THEN
              IF tm.lik10 = '3' THEN
                 IF tm.lik09 <> '1' AND tm.lik09 <> '2' THEN
                    CALL cl_err('','alm1613',0)
                    NEXT FIELD lik09
                 END IF
              END IF
            END IF
         END IF
         #TQC-C30290--end add---------------------------------

         CALL i350_lik09(tm.lik09)
      #TQC-C20383 END ---   
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         ELSE
            #如果費用設置勾選，畫面條件給了除空和*以外的值，則只能產生明細資料
            IF ((g_lnl.lnl03 = 'Y' AND tm.wc1 <> " 1=1") OR g_lnl.lnl03 = 'N') AND
               ((g_lnl.lnl04 = 'Y' AND tm.wc2 <> " 1=1") OR g_lnl.lnl04 = 'N') AND
               ((g_lnl.lnl05 = 'Y' AND tm.wc3 <> " 1=1") OR g_lnl.lnl05 = 'N') AND
               ((g_lnl.lnl09 = 'Y' AND tm.wc4 <> " 1=1") OR g_lnl.lnl09 = 'N') THEN
               IF tm.detail = 'N' THEN
                  CALL cl_err('','alm-853',1)
                  NEXT FIELD detail
               END IF
            END IF
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(lik07)
               CALL cl_init_qry_var()
               LET g_qryparam.arg1 = '30'
               LET g_qryparam.form ="q_tqa"
               CALL cl_create_qry() RETURNING tm.lik07
               DISPLAY tm.lik07 TO lik07
               NEXT FIELD lik07
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION qbe_save
         CALL cl_qbe_save()
   END INPUT

   IF INT_FLAG THEN
      RETURN
   END IF
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#動態顯示或隱藏QBE條件中的欄位
FUNCTION i350_set_cs_visible()

   IF g_lnl.lnl03 = 'Y' THEN
      CALL cl_set_comp_visible('lmb02',TRUE)
   ELSE
      CALL cl_set_comp_visible('lmb02',FALSE)
   END IF
   IF g_lnl.lnl04 = 'Y' THEN
      CALL cl_set_comp_visible('lmc03',TRUE)
   ELSE
      CALL cl_set_comp_visible('lmc03',FALSE)
   END IF
   IF g_lnl.lnl05 = 'Y' THEN
      CALL cl_set_comp_visible('lmy03',TRUE)
   ELSE
      CALL cl_set_comp_visible('lmy03',FALSE)
   END IF
   IF g_lnl.lnl09 = 'Y' THEN
      CALL cl_set_comp_visible('oba01',TRUE)
   ELSE
      CALL cl_set_comp_visible('oba01',FALSE)
   END IF
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
FUNCTION i350_p_produce()
DEFINE l_n   LIKE type_file.num5

   IF cl_null(g_lnl.lnl01) OR cl_null(g_lnl.lnlstore) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF s_shut(0) THEN RETURN END IF
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
   IF g_cnt = 1 THEN
      IF g_lnl.lnlstore <> g_plant THEN
         CALL cl_err('','alm-708',0)
         RETURN
      END IF
   END IF

   BEGIN WORK
   OPEN i350_cl USING g_lnl.lnl01,g_lnl.lnlstore
   IF STATUS THEN
      CALL cl_err("OPEN i350_cl:",STATUS,0)
      CLOSE i350_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i350_cl INTO g_lnl.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnl.lnl01,SQLCA.sqlcode,0)
      CLOSE i350_cl
      ROLLBACK WORK
      RETURN
   END IF

   OPEN WINDOW i350_wp WITH FORM "alm/42f/almi350_p"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("almi350_p")

   CALL i350_p_askkey()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i350_wp
      RETURN
   END IF

   CLOSE WINDOW i350_wp

   CALL s_showmsg_init()

   LET g_success = 'Y'    #是否成功執行
   LET g_err_str1 = 'N'   #錯誤變量1-產生明細資料下使用
   LET g_err_str2 = 'N'   #錯誤變量2-產生匯總資料下使用
   LET g_success_sum = 0  #成功操作資料的筆數

   #產生數據邏輯
   CALL i350_pro_data()
   IF g_success_sum = 0 THEN
      CALL cl_err('','anm-050',0) #查詢條件未抓出資料
      RETURN
   END IF
   IF g_success = 'Y' THEN
      CASE tm.detail
         WHEN 'Y'
            IF g_err_str1 = 'Y' THEN
               IF cl_confirm('alm-828') THEN
                  COMMIT WORK
                  CALL cl_err('','alm-838',0) #批次產生費用標準參數成功
               ELSE
                  ROLLBACK WORK
                  CALL cl_err('','alm-849',0)   #批次產生費用標準參數失敗
               END IF
            ELSE
               COMMIT WORK
               CALL cl_err('','alm-838',0) #批次產生費用標準參數成功
            END IF
         WHEN 'N'
            IF g_err_str2 = 'Y' THEN
               IF cl_confirm('alm-828') THEN
                  COMMIT WORK
                  CALL cl_err('','alm-838',0) #批次產生費用標準參數成功
               ELSE
                  ROLLBACK WORK
                  CALL cl_err('','alm-849',0)   #批次產生費用標準參數失敗
               END IF
            ELSE
               COMMIT WORK
               CALL cl_err('','alm-838',0) #批次產生費用標準參數成功
            END IF
      END CASE
   ELSE
      CALL s_showmsg()
      ROLLBACK WORK
      CALL cl_err('','alm-849',0)   #批次產生費用標準參數失敗
   END IF
   CLOSE i350_cl
   COMMIT WORK
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#楼栋、楼层、区域的取值逻辑1
FUNCTION i350_get_data1()

   IF g_lnl.lnl03 = 'Y' THEN  #勾選按樓棟設定費用標準
      IF g_lnl.lnl04 = 'Y' THEN  #勾選按樓層設定費用標準
         IF g_lnl.lnl05 = 'Y' THEN  #勾選按區域設定費用標準
            LET g_sql = "SELECT UNIQUE lmy01,lmy02,lmy03 FROM lmy_file,lmc_file,lmb_file ",
                        " WHERE lmy01 = lmb02 AND lmy01 = lmc02 AND lmy02 = lmc03 ",
                        "   AND lmbstore = lmystore AND lmbstore = lmcstore ",
                        "   AND lmystore = '",g_lnl.lnlstore,"' ",
                        "   AND lmb06 = 'Y' AND lmc07 = 'Y' AND lmyacti = 'Y' ",
                        "   AND ",tm.wc1 CLIPPED," AND ",tm.wc2 CLIPPED," AND ",tm.wc3 CLIPPED,
                        " ORDER BY lmy01,lmy02,lmy03 "
         ELSE
            LET g_sql = "SELECT UNIQUE lmc02,lmc03,'' FROM lmc_file,lmb_file ",
                        " WHERE lmc02 = lmb02 ",
                        "   AND lmcstore = lmbstore AND lmcstore = '",g_lnl.lnlstore,"' ",
                        "   AND lmb06 = 'Y' AND lmc07 = 'Y' ",
                        "   AND ",tm.wc1 CLIPPED," AND ",tm.wc2 CLIPPED,
                        " ORDER BY lmc02,lmc03 "
         END IF
      ELSE
         IF g_lnl.lnl05 = 'Y' THEN
            LET g_sql = "SELECT UNIQUE lmy01,'',lmy03 FROM lmy_file,lmb_file ",
                        " WHERE lmy01 = lmb02 ",
                        "   AND lmystore = lmbstore AND lmystore = '",g_lnl.lnlstore,"' ",
                        "   AND lmb06 = 'Y' AND lmyacti = 'Y' ",
                        "   AND ",tm.wc1 CLIPPED," AND ",tm.wc3 CLIPPED,
                        " ORDER BY lmy01,lmy03 "
         ELSE
            LET g_sql = "SELECT UNIQUE lmb02,'','' FROM lmb_file ",
                        " WHERE lmbstore = '",g_lnl.lnlstore,"' AND ",tm.wc1 CLIPPED,
                        "   AND lmb06 = 'Y' ",
                        " ORDER BY lmb02 "
         END IF
      END IF
   ELSE
      IF g_lnl.lnl04 = 'Y' THEN
         IF g_lnl.lnl05 = 'Y' THEN
            LET g_sql = "SELECT UNIQUE '',lmy02,lmy03 FROM lmy_file,lmc_file ",
                        " WHERE lmy01 = lmc02 AND lmy02 = lmc03",
                        "   AND lmystore = lmcstore AND lmystore = '",g_lnl.lnlstore,"' ",
                        "   AND lmc07 = 'Y' AND lmyacti = 'Y' ",
                        " AND ",tm.wc2 CLIPPED," AND ",tm.wc3 CLIPPED,
                        " ORDER BY lmy02,lmy03 "
         ELSE
            LET g_sql = "SELECT UNIQUE '',lmc03,'' FROM lmc_file ",
                        " WHERE lmcstore = '",g_lnl.lnlstore,"' AND ",tm.wc2 CLIPPED,
                        "   AND lmc07 = 'Y' ",
                        " ORDER BY lmc03 "
         END IF
      ELSE
         IF g_lnl.lnl05 = 'Y' THEN
            LET g_sql = "SELECT UNIQUE '','',lmy03 FROM lmy_file ",
                        " WHERE lmystore = '",g_lnl.lnlstore,"' AND ",tm.wc3 CLIPPED,
                        "   AND lmyacti = 'Y' ",
                        " ORDER BY lmy03 "
         ELSE
            LET g_check_str = 'NNN'
         END IF
      END IF
   END IF
   IF g_check_str = 'NNN' THEN
      LET g_lmb02 = NULL  #樓棟
      LET g_lmc03 = NULL  #樓層
      LET g_lmy03 = NULL  #區域
      CALL i350_ins_chk1()  #檢查原lik_file中是否有匯總資料
      CALL i350_ins_lik()   #將資料插入lik_file中
   ELSE
      PREPARE sel_xxx_pre1 FROM g_sql
      DECLARE sel_xxx_cs1 CURSOR FOR sel_xxx_pre1
      FOREACH sel_xxx_cs1 INTO g_lmb02,g_lmc03,g_lmy03
         IF STATUS THEN
            CALL cl_err('foreach :',STATUS,1)
            EXIT FOREACH
         END IF
         CALL i350_ins_chk1()  #檢查原lik_file中是否有匯總資料
         CALL i350_ins_lik()   #將資料插入lik_file中
      END FOREACH
   END IF
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#楼栋、楼层、区域的取值逻辑2
FUNCTION i350_get_data2()

   IF g_lnl.lnl03 = 'Y' THEN
      IF g_lnl.lnl04 = 'Y' THEN
         IF g_lnl.lnl05 = 'Y' THEN
            CALL i350_check_sql1()  #勾選情況為YYY
         ELSE
            CALL i350_check_sql2()  #勾選情況為YYN
         END IF
      ELSE
         IF g_lnl.lnl05 = 'Y' THEN
            CALL i350_check_sql3()  #勾選情況為YNY
         ELSE
            CALL i350_check_sql4()  #勾選情況為YNN
         END IF
      END IF
   ELSE
      IF g_lnl.lnl04 = 'Y' THEN
         IF g_lnl.lnl05 = 'Y' THEN
            CALL i350_check_sql5()  #勾選情況為NYY
         ELSE
            CALL i350_check_sql6()  #勾選情況為NYN
         END IF
      ELSE
         IF g_lnl.lnl05 = 'Y' THEN  #勾選情況為NNY
            CALL i350_check_sql7()
         ELSE
            LET g_check_str = 'NNN'    #判斷樓棟、樓層、區域是否都未勾選(Y-是 N-否)
         END IF
      END IF
   END IF
   IF g_check_str = 'NNN' THEN
      LET g_lmb02 = NULL  #樓棟
      LET g_lmc03 = NULL  #樓層
      LET g_lmy03 = NULL  #區域
      CALL i350_ins_chk2()  #檢查原lik_file中是否有匯總資料 
      CALL i350_ins_lik()   #將資料插入lik_file中
   ELSE
      IF NOT cl_null(g_sql) THEN
         PREPARE sel_xxx_pre2 FROM g_sql
         DECLARE sel_xxx_cs2 CURSOR FOR sel_xxx_pre2
         FOREACH sel_xxx_cs2 INTO g_lmb02,g_lmc03,g_lmy03
            IF STATUS THEN
               CALL cl_err('foreach :',STATUS,1)
               EXIT FOREACH
            END IF
            CALL i350_ins_chk2()  #檢查原lik_file中是否存在明細資料
            CALL i350_ins_lik()   #將資料插入lik_file中
         END FOREACH
      ELSE
         CALL i350_ins_chk2()  #檢查原lik_file中是否存在明細資料
         CALL i350_ins_lik()   #將資料插入lik_file中
      END IF
   END IF
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#產生單身數據
FUNCTION i350_pro_data()

   CASE tm.detail
      WHEN 'Y'
         IF g_lnl.lnl09 = 'Y' THEN #勾選了按小類設定費用標準
            LET g_sql = "SELECT oba01 FROM oba_file WHERE obaacti = 'Y' AND oba14 = 0 AND ",tm.wc4 CLIPPED,
                        " ORDER BY oba01 "
            PREPARE sel_oba01_pre1 FROM g_sql
            DECLARE sel_oba01_cs1 CURSOR FOR sel_oba01_pre1
            FOREACH sel_oba01_cs1 INTO g_oba01
               IF STATUS THEN
                  CALL cl_err('foreach oba:',STATUS,1)
                  EXIT FOREACH
               END IF
               LET g_check_str = NULL    #判斷樓棟、樓層、區域是否勾選(Y-勾選 N-未勾選)
   
               CALL i350_get_data1()     #楼栋、楼层、区域的取值逻辑1
            END FOREACH
         ELSE
            LET g_check_str = NULL
            LET g_oba01 = NULL
            CALL i350_get_data1()        #楼栋、楼层、区域的取值逻辑1
         END IF
   
      WHEN 'N'
         IF g_lnl.lnl09 = 'Y' THEN
            IF tm.wc4 = " 1=1" THEN
               LET g_oba01 = '*'
               LET g_check_str = NULL
               CALL i350_get_data2()     #楼栋、楼层、区域的取值逻辑2
            ELSE
               LET g_sql = "SELECT oba01 FROM oba_file WHERE obaacti = 'Y' AND oba14 = 0 AND ",tm.wc4 CLIPPED,
                           " ORDER BY oba01 "
               PREPARE sel_oba01_pre2 FROM g_sql
               DECLARE sel_oba01_cs2 CURSOR FOR sel_oba01_pre2
               FOREACH sel_oba01_cs2 INTO g_oba01
                  IF STATUS THEN
                     CALL cl_err('foreach oba:',STATUS,1)
                     EXIT FOREACH
                  END IF
                  LET g_check_str = NULL    #判斷樓棟、樓層、區域是否都未勾選(Y-是 N-否)
   
                  CALL i350_get_data2()     #楼栋、楼层、区域的取值逻辑2
               END FOREACH
            END IF
         ELSE
            LET g_check_str = NULL
            LET g_oba01 = NULL
            CALL i350_get_data2()           #楼栋、楼层、区域的取值逻辑2
         END IF
   END CASE
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#根據勾選條件的不同組合出不同的Sql語句
FUNCTION i350_check_sql1()  #勾選情況為YYY

   IF tm.wc1 = " 1=1" THEN
      IF tm.wc2 = " 1=1" THEN
         IF tm.wc3 = " 1=1" THEN  #條件為全不下條件
            LET g_lmb02 = '*'
            LET g_lmc03 = '*'
            LET g_lmy03 = '*'
            LET g_sql = NULL
         ELSE                     #僅區域下了明細條件
            LET g_sql = "SELECT UNIQUE '*','*',lmy03 ",
                        "  FROM lmy_file ",
                        " WHERE lmystore = '",g_lnl.lnlstore,"' AND ",tm.wc3 CLIPPED,
                        "   AND lmyacti = 'Y' ",
                        " ORDER BY lmy03 "
         END IF
      ELSE
         IF tm.wc3 = " 1=1" THEN  #僅樓層下了明細條件
            LET g_sql = "SELECT UNIQUE '*',lmc03,'*' ",
                        "  FROM lmc_file ",
                        " WHERE lmcstore = '",g_lnl.lnlstore,"' AND ",tm.wc2 CLIPPED,
                        "   AND lmc07 = 'Y' ",
                        " ORDER BY lmc03 "
         ELSE                     #樓層與區域都下了明細條件
            LET g_sql = "SELECT UNIQUE '*',lmc03,lmy03 ",
                        "  FROM lmc_file,lmy_file ",
                        " WHERE lmc03 = lmy02 AND lmcstore = lmystore ",
                        "   AND lmc07 = 'Y' AND lmyacti = 'Y' ",
                        "   AND lmystore = '",g_lnl.lnlstore,"' AND ",tm.wc2 CLIPPED," AND ",tm.wc3 CLIPPED,
                        " ORDER BY lmc03,lmy03 "
         END IF
      END IF
   ELSE
      IF tm.wc2 = " 1=1" THEN
         IF tm.wc3 = " 1=1" THEN  #僅樓棟下了明細條件
            LET g_sql = "SELECT UNIQUE lmb02,'*','*' ",
                        "  FROM lmb_file ",
                        " WHERE lmbstore = '",g_lnl.lnlstore,"' AND ",tm.wc1 CLIPPED,
                        "   AND lmb06 = 'Y' ",
                        " ORDER BY lmb02 "
                      
         ELSE                     #樓棟與區域下了明細條件
            LET g_sql = "SELECT UNIQUE lmb02,'*',lmy03 ",
                        "  FROM lmb_file,lmy_file ",
                        " WHERE lmb02 = lmy01 AND lmbstore = lmystore ",
                        "   AND lmb06 = 'Y' AND lmyacti = 'Y' ",
                        "   AND lmystore = '",g_lnl.lnlstore,"' AND ",tm.wc1 CLIPPED," AND ",tm.wc3 CLIPPED,
                        " ORDER BY lmb02,lmy03 "
         END IF
      ELSE
         IF tm.wc3 = " 1=1" THEN  #樓棟與樓層下了明細條件
            LET g_sql = "SELECT UNIQUE lmb02,lmc03,'*' ",
                        "  FROM lmb_file,lmc_file ",
                        " WHERE lmb02 = lmc02 AND lmbstore = lmcstore ",
                        "   AND lmb06 = 'Y' AND lmc07 = 'Y' ",
                        "   AND lmcstore = '",g_lnl.lnlstore,"' AND ",tm.wc1 CLIPPED," AND ",tm.wc2 CLIPPED,
                        " ORDER BY lmb02,lmc03 "
         ELSE                     #樓棟、樓層、區域都下了明細條件
            LET g_sql = "SELECT UNIQUE lmb02,lmc03,lmy03 ",
                        "  FROM lmb_file,lmc_file,lmy_file ",
                        " WHERE lmb02 = lmc02 AND lmb02 = lmy01 AND lmc03 = lmy02 ",
                        "   AND lmbstore = lmcstore AND lmcstore = lmystore AND lmystore = '",g_lnl.lnlstore,"' ",
                        "   AND lmb06 = 'Y' AND lmc07 = 'Y' AND lmyacti = 'Y' ",
                        "   AND ",tm.wc1 CLIPPED," AND ",tm.wc2 CLIPPED," AND ",tm.wc3 CLIPPED,
                        " ORDER BY lmb02,lmc03,lmy03 "
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i350_check_sql2()  #勾選情況為YYN

   IF tm.wc1 = " 1=1" THEN
      IF tm.wc2 = " 1=1" THEN  #都未下明細條件
         LET g_lmb02 = '*'
         LET g_lmc03 = '*'
         LET g_lmy03 = NULL
         LET g_sql = NULL
      ELSE                     #僅樓層下了明細條件
         LET g_sql = "SELECT UNIQUE '*',lmc03,'' ",
                     "  FROM lmc_file ",
                     " WHERE lmcstore = '",g_lnl.lnlstore,"' AND ",tm.wc2 CLIPPED,
                     "   AND lmc07 = 'Y' ",
                     " ORDER BY lmc03 "
      END IF
   ELSE                        
      IF tm.wc2 = " 1=1" THEN  #僅樓棟下了明細條件
         LET g_sql = "SELECT UNIQUE lmb02,'*','' ",
                     "  FROM lmb_file ",
                     " WHERE lmbstore = '",g_lnl.lnlstore,"' AND ",tm.wc1 CLIPPED,
                     "   AND lmb06 = 'Y' ",
                     " ORDER BY lmb02 "
      ELSE                     #樓棟與樓層下了明細條件
         LET g_sql = "SELECT UNIQUE lmb02,lmc03,'' ",
                     "  FROM lmb_file,lmc_file ",
                     " WHERE lmb02 = lmc02 AND lmbstore = lmcstore ",
                     "   AND lmb06 = 'Y' AND lmc07 = 'Y' ",
                     "   AND lmcstore = '",g_lnl.lnlstore,"' AND ",tm.wc1 CLIPPED," AND ",tm.wc2 CLIPPED,
                     " ORDER BY lmb02,lmc03 "
      END IF
   END IF
END FUNCTION

FUNCTION i350_check_sql3()  #勾選情況為YNY

   IF tm.wc1 = " 1=1" THEN
      IF tm.wc3 = " 1=1" THEN  #都未下明細條件
         LET g_lmb02 = '*'
         LET g_lmc03 = NULL
         LET g_lmy03 = '*'
         LET g_sql = NULL
      ELSE                     #僅區域下了明細條件
         LET g_sql = "SELECT UNIQUE '*','',lmy03 ",
                     "  FROM lmy_file ",
                     " WHERE lmystore = '",g_lnl.lnlstore,"' AND ",tm.wc3 CLIPPED,
                     "   AND lmyacti = 'Y' ",
                     " ORDER BY lmy03 "
      END IF
   ELSE  
      IF tm.wc3 = " 1=1" THEN  #僅樓棟下了明細條件
         LET g_sql = "SELECT UNIQUE lmb02,'','*' ",
                     "  FROM lmb_file ",
                     " WHERE lmbstore = '",g_lnl.lnlstore,"' AND ",tm.wc1 CLIPPED,
                     "   AND lmb06 = 'Y' ",
                     " ORDER BY lmb02 "
      ELSE                     #樓棟與區域下了明細條件
         LET g_sql = "SELECT UNIQUE lmb02,'',lmy03 ",
                     "  FROM lmb_file,lmy_file ",
                     " WHERE lmb02 = lmy01 AND lmbstore = lmystore ",
                     "   AND lmb06 = 'Y' AND lmyacti = 'Y' ",
                     "   AND lmystore = '",g_lnl.lnlstore,"' AND ",tm.wc1 CLIPPED," AND ",tm.wc3 CLIPPED,
                     " ORDER BY lmb02,lmy03 "
      END IF
   END IF 
END FUNCTION

FUNCTION i350_check_sql4()  #勾選情況為YNN

   IF tm.wc1 = " 1=1" THEN  #樓棟未下明細條件
      LET g_lmb02 = '*'
      LET g_lmc03 = NULL
      LET g_lmy03 = NULL
      LET g_sql = NULL
   ELSE                     #樓棟下了明細條件
      LET g_sql = "SELECT UNIQUE lmb02,'','' ",
                  "  FROM lmb_file ",
                  " WHERE lmbstore = '",g_lnl.lnlstore,"' AND ",tm.wc1 CLIPPED,
                  "   AND lmb06 = 'Y' ",
                  " ORDER BY lmb02 "
   END IF
END FUNCTION

FUNCTION i350_check_sql5()  #勾選情況為NYY

   IF tm.wc2 = " 1=1" THEN
      IF tm.wc3 = " 1=1" THEN  #都未下明細條件
         LET g_lmb02 = NULL
         LET g_lmc03 = '*'
         LET g_lmy03 = '*'
         LET g_sql = NULL
      ELSE                     #僅區域下了明細條件
         LET g_sql = "SELECT UNIQUE '','*',lmy03 ",
                     "  FROM lmy_file ",
                     " WHERE lmystore = '",g_lnl.lnlstore,"' AND ",tm.wc3 CLIPPED,
                     "   AND lmyacti = 'Y' ",
                     " ORDER BY lmy03 "
      END IF
   ELSE
      IF tm.wc3 = " 1=1" THEN  #僅樓層下了明細條件
         LET g_sql = "SELECT UNIQUE '',lmc03,'*' ",
                     "  FROM lmc_file ",
                     " WHERE lmcstore = '",g_lnl.lnlstore,"' AND ",tm.wc2 CLIPPED,
                     "   AND lmc07 = 'Y' ",
                     " ORDER BY lmc03 "
      ELSE                     #樓層與區域下了明細條件
         LET g_sql = "SELECT UNIQUE '',lmc03,lmy03 ",
                     "  FROM lmc_file,lmy_file ",
                     " WHERE lmc02 = lmy01 AND lmc03 = lmy02 AND lmcstore = lmystore ",
                     "   AND lmc07 = 'Y' AND lmyacti = 'Y' ",
                     "   AND lmystore = '",g_lnl.lnlstore,"' AND ",tm.wc2 CLIPPED," AND ",tm.wc3 CLIPPED,
                     " ORDER BY lmc03,lmy03 "
      END IF
   END IF 
END FUNCTION

FUNCTION i350_check_sql6()  #勾選情況為NYN

   IF tm.wc2 = " 1=1" THEN  #都未下明細條件
      LET g_lmb02 = NULL
      LET g_lmc03 = '*'
      LET g_lmy03 = NULL
      LET g_sql = NULL
   ELSE                     #樓層下了明細條件
      LET g_sql = "SELECT UNIQUE '',lmc03,'' ",
                  "  FROM lmc_file ",
                  " WHERE lmcstore = '",g_lnl.lnlstore,"' AND ",tm.wc2 CLIPPED,
                  "   AND lmc07 = 'Y' ",
                  " ORDER BY lmc03 "
   END IF
END FUNCTION

FUNCTION i350_check_sql7()  #勾選情況為NNY

   IF tm.wc3 = " 1=1" THEN  #都未下明細條件
      LET g_lmb02 = NULL
      LET g_lmc03 = NULL
      LET g_lmy03 = '*'
      LET g_sql = NULL
   ELSE                     #區域下了明細條件
      LET g_sql = "SELECT UNIQUE '','',lmy03 ",
                  "  FROM lmy_file ",
                  " WHERE lmystore = '",g_lnl.lnlstore,"' AND ",tm.wc3 CLIPPED,
                  "   AND lmyacti = 'Y' ",
                  " ORDER BY lmy03 "
   END IF
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#檢查是否有重複資料或者交集資料
FUNCTION i350_ins_chk1()
DEFINE l_n   LIKE type_file.num5

   LET g_sel_sql = "SELECT COUNT(*) ",
                   "  FROM lik_file ",
                   " WHERE lik01 = '",g_lnl.lnl01,"' ",
                   "   AND lik07 = '",tm.lik07,"' AND likstore = '",g_lnl.lnlstore,"' "
   LET g_del_sql = "DELETE FROM lik_file ",
                   " WHERE lik01 = '",g_lnl.lnl01,"' ",
                   "   AND lik07 = '",tm.lik07,"' AND likstore = '",g_lnl.lnlstore,"' "
   IF NOT cl_null(g_lmb02) THEN  #樓棟
      LET g_sel_sql = g_sel_sql," AND (lik03 = '",g_lmb02,"' OR lik03 = '*') "
      LET g_del_sql = g_del_sql," AND (lik03 = '",g_lmb02,"' OR lik03 = '*') "
   END IF
   IF NOT cl_null(g_lmc03) THEN  #樓層
      LET g_sel_sql = g_sel_sql," AND (lik04 = '",g_lmc03,"' OR lik04 = '*') "
      LET g_del_sql = g_del_sql," AND (lik04 = '",g_lmc03,"' OR lik04 = '*') "
   END IF
   IF NOT cl_null(g_lmy03) THEN  #區域
      LET g_sel_sql = g_sel_sql," AND (lik05 = '",g_lmy03,"' OR lik05 = '*') "
      LET g_del_sql = g_del_sql," AND (lik05 = '",g_lmy03,"' OR lik05 = '*') "
   END IF
   IF NOT cl_null(g_oba01) THEN  #小類
      LET g_sel_sql = g_sel_sql," AND (lik06 = '",g_oba01,"' OR lik06 = '*') "
      LET g_del_sql = g_del_sql," AND (lik06 = '",g_oba01,"' OR lik06 = '*') "
   END IF

   PREPARE sel_count_pre1 FROM g_sel_sql
   EXECUTE sel_count_pre1 INTO l_n
   IF l_n > 0 THEN 
   #若存在重複或交集資料則將之刪除
      LET g_err_str1 = 'Y'
      PREPARE del_sql_pre1 FROM g_del_sql
      EXECUTE del_sql_pre1
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('lik01',g_lnl.lnl01,'del lik',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION

#檢查是否有重複資料或者交集資料
FUNCTION i350_ins_chk2()
DEFINE l_n   LIKE type_file.num5

   LET g_sel_sql = "SELECT COUNT(*) ",
                   "  FROM lik_file ",
                   " WHERE lik01 = '",g_lnl.lnl01,"' ",
                   "   AND lik07 = '",tm.lik07,"' AND likstore = '",g_lnl.lnlstore,"' "
   LET g_del_sql = "DELETE FROM lik_file ",
                   " WHERE lik01 = '",g_lnl.lnl01,"' ",
                   "   AND lik07 = '",tm.lik07,"' AND likstore = '",g_lnl.lnlstore,"' "
   IF NOT cl_null(g_lmb02) AND g_lmb02 <> '*' THEN  #樓棟
      LET g_sel_sql = g_sel_sql," AND (lik03 = '",g_lmb02,"' OR lik03 = '*') "
      LET g_del_sql = g_del_sql," AND (lik03 = '",g_lmb02,"' OR lik03 = '*') "
   END IF
   IF NOT cl_null(g_lmc03) AND g_lmc03 <> '*' THEN  #樓層
      LET g_sel_sql = g_sel_sql," AND (lik04 = '",g_lmc03,"' OR lik04 = '*') "
      LET g_del_sql = g_del_sql," AND (lik04 = '",g_lmc03,"' OR lik04 = '*') "
   END IF
   IF NOT cl_null(g_lmy03) AND g_lmy03 <> '*' THEN  #區域
      LET g_sel_sql = g_sel_sql," AND (lik05 = '",g_lmy03,"' OR lik05 = '*') "
      LET g_del_sql = g_del_sql," AND (lik05 = '",g_lmy03,"' OR lik05 = '*') "
   END IF
   IF NOT cl_null(g_oba01) AND g_oba01 <> '*' THEN  #小類
      LET g_sel_sql = g_sel_sql," AND (lik06 = '",g_oba01,"' OR lik06 = '*') "
      LET g_del_sql = g_del_sql," AND (lik06 = '",g_oba01,"' OR lik06 = '*') "
   END IF

   PREPARE sel_count_pre2 FROM g_sel_sql
   EXECUTE sel_count_pre2 INTO l_n
   IF l_n > 0 THEN 
      #若存在重複或交集資料則將之刪除
      LET g_err_str2 = 'Y'
      PREPARE del_sql_pre2 FROM g_del_sql
      EXECUTE del_sql_pre2
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('lik01',g_lnl.lnl01,'del lik',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION
#FUN-B90121 Add End -----

#FUN-B90121 Add Begin ---
#將取得的數據插入到lik_file中
FUNCTION i350_ins_lik()
DEFINE l_lik02    LIKE lik_file.lik02
DEFINE l_lik_str1 STRING
DEFINE l_lik_str2 STRING

   #檢查是否已被使用
   IF NOT i350_chk_upd(g_lmb02,g_lmc03,g_lmy03,g_oba01,tm.lik07) THEN
      LET l_lik_str1 = "lik01"
      LET l_lik_str2 = g_lnl.lnl01
      IF NOT cl_null(g_lmb02) THEN
         LET l_lik_str1 = l_lik_str1,",","lik03"
         LET l_lik_str2 = l_lik_str2,"/",g_lmb02
      END IF
      IF NOT cl_null(g_lmc03) THEN
         LET l_lik_str1 = l_lik_str1,",","lik04"
         LET l_lik_str2 = l_lik_str2,"/",g_lmc03
      END IF
      IF NOT cl_null(g_lmy03) THEN
         LET l_lik_str1 = l_lik_str1,",","lik05"
         LET l_lik_str2 = l_lik_str2,"/",g_lmy03
      END IF
      IF NOT cl_null(g_oba01) THEN
         LET l_lik_str1 = l_lik_str1,",","lik06"
         LET l_lik_str2 = l_lik_str2,"/",g_oba01
      END IF
      IF NOT cl_null(tm.lik07) THEN
         LET l_lik_str1 = l_lik_str1,",","lik07"
         LET l_lik_str2 = l_lik_str2,"/",tm.lik07
      END IF
      CALL s_errmsg(l_lik_str1,l_lik_str2,'ins lik','alm1517',1)
      LET g_success = 'N'
   END IF
   #取項次
   SELECT MAX(lik02)+1 INTO l_lik02 
     FROM lik_file 
    WHERE lik01 = g_lnl.lnl01 AND likstore = g_lnl.lnlstore
   IF cl_null(l_lik02) THEN LET l_lik02 = 1 END IF
   LET g_ins_sql = "INSERT INTO lik_file(lik01,lik02,lik03,lik04,lik05,lik06, ",
                   "                     lik07,lik08,lik09,lik10,likstore,liklegal) ",
                   "VALUES(?,?,?, ?,?,?, ?,?,?, ?,?,?)"
   PREPARE ins_lik_pre FROM g_ins_sql
   EXECUTE ins_lik_pre USING g_lnl.lnl01,l_lik02,g_lmb02,g_lmc03,g_lmy03,g_oba01,
                             tm.lik07,tm.lik08,tm.lik09,tm.lik10,g_lnl.lnlstore,g_lnl.lnllegal
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('lik02',l_lik02,'ins lik',SQLCA.sqlcode,1)
      LET g_success = 'N'
   ELSE
      LET g_success_sum = g_success_sum + 1  #成功新增筆數
   END IF
END FUNCTION
#FUN-B90121 Add End -----
 
FUNCTION i350_copy()
DEFINE l_new      LIKE lnl_file.lnl01
DEFINE l_newno    LIKE lnl_file.lnlstore
DEFINE l_old      LIKE lnl_file.lnl01
DEFINE l_oldno    LIKE lnl_file.lnlstore
DEFINE l_oaj02    LIKE oaj_file.oaj02
DEFINE l_rtz13    LIKE rtz_file.rtz13
DEFINE l_count    LIKE type_file.num5
DEFINE l_n        LIKE type_file.num5
DEFINE l_azt01    LIKE azt_file.azt01 #No.MOD-9C0364
DEFINE l_azt02    LIKE azt_file.azt02 #No.MOD-9C0364
 
    IF cl_null(g_lnl.lnl01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
     IF cl_null(g_lnl.lnlstore) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF    
    
  #No.MOD-9C0364 -BEGIN-----
  # SELECT COUNT(*) INTO l_n FROM rtz_file
  #  WHERE rtz01 = g_plant
  # IF l_n < 1 THEN 
  #    CALL cl_err('','alm-559',1)
  #    RETURN 
  # END IF
  #No.MOD-9C0364 -END-------
   
    LET g_before_input_done = FALSE
    CALL i350_set_entry('a')
    LET g_before_input_done = TRUE
    DISPLAY '' TO FORMONLY.oaj02
    DISPLAY '' TO FORMONLY.rtz13 
 
    INPUT l_new,l_newno FROM lnl01,lnlstore
       #No.MOD-9C0364 BEGIN -----
       ##No.FUN-9B0136 BEGIN -----
       #BEFORE INPUT
       #   CALL cl_set_comp_entry('lnlstore',FALSE)
       #   LET l_newno = g_plant
       #   DISPLAY l_newno TO lnlstore
       #   SELECT rtz13 INTO l_rtz13 FROM rtz_file
       #    WHERE rtz01 = g_plant
       #   DISPLAY l_rtz13 TO FORMONLY.rtz13
       ##No.FUN-9B0136 END -------
       #No.MOD-9C0364 END -------

       #No.MOD-9C0364 -BEGIN-----
        BEFORE INPUT
           SELECT COUNT(*) INTO l_n FROM rtz_file
            WHERE rtz01 = g_plant
           IF l_n = 1 THEN
              CALL cl_set_comp_entry('lnlstore',FALSE)
              LET l_newno = g_plant
              SELECT rtz13 INTO l_rtz13 FROM rtz_file
               WHERE rtz01 = l_newno
              SELECT azt01,azt02 INTO l_azt01,l_azt02
                FROM azt_file,azw_file
               WHERE azt01 = azw02
                 AND azw01 = l_newno
              DISPLAY l_newno TO lnlstore
              DISPLAY l_rtz13 TO FORMONLY.rtz13
              DISPLAY l_azt02 TO FORMONLY.azt02
              DISPLAY l_azt01 TO lnllegal
           END IF
       #No.MOD-9C0364 -END-------
 
        AFTER FIELD lnl01 
          IF NOT cl_null(l_new) THEN
             CALL copy_check_lnl01(l_new)
             IF g_success = 'N' THEN                                           
                LET g_lnl.lnl01 = g_lnl_t.lnl01                                       
                DISPLAY BY NAME g_lnl.lnl01                                           
                NEXT FIELD lnl01  
              ELSE
              	  SELECT oaj02 INTO l_oaj02 FROM oaj_file
               	 WHERE oaj01 = l_new
               	DISPLAY l_oaj02 TO FORMONLY.oaj02                                          
              END IF  
          ELSE 
          	 CALL cl_err(l_new,'alm-062',1)
          	 NEXT FIELD lnl01    
          END IF
        
        AFTER FIELD lnlstore
             IF NOT cl_null(l_newno) THEN          
                 CALL copy_check_lnlstore(l_newno) 
                 IF g_success = 'N' THEN                                               
                    LET g_lnl.lnlstore = g_lnl_t.lnlstore                                                               
                    DISPLAY BY NAME g_lnl.lnlstore                                                                     
                    NEXT FIELD lnlstore                                                                                  
                 ELSE
                 #No.MOD-9C0364 BEGIN -----
                 #  SELECT rtz13 INTO l_rtz13 FROM rtz_file
                 #   WHERE rtz01 = l_newno
                 #  DISPLAY l_rtz13 TO FORMONLY.rtz13  
                    CALL i350_lnlstore('a')
                 #No.MOD-9C0364 END -------
                 END IF
             ELSE
               CALL cl_err(l_newno,'alm-062',1)
               NEXT FIELD lnlstore  
            END IF      
        
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          ELSE 
          	 SELECT COUNT(*) INTO l_count FROM lnl_file
              WHERE lnl01 = l_new 
                AND lnlstore = l_newno          
              IF l_count >0 THEN 
                 CALL cl_err('','alm-081',1)
                 NEXT FIELD lnl01 
               END IF 
          END IF        
        
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(lnl01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oaj5"  
               LET g_qryparam.default1 = l_new
               CALL cl_create_qry()  RETURNING l_new
               DISPLAY l_new TO lnl01
               NEXT FIELD lnl01
            
            WHEN INFIELD(lnlstore)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rtz7"  
               LET g_qryparam.default1 = l_newno
               CALL cl_create_qry()  RETURNING l_newno
               DISPLAY l_newno TO lnlstore
               NEXT FIELD lnlstore    
 
            OTHERWISE
              EXIT CASE
          END CASE
           
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION about 
          CALL cl_about() 
 
       ON ACTION help 
          CALL cl_show_help() 
  
       ON ACTION controlg 
          CALL cl_cmdask() 
 
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_lnl.lnl01
       DISPLAY BY NAME g_lnl.lnlstore
       RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM lnl_file
     WHERE lnl01 = g_lnl.lnl01
       AND lnlstore = g_lnl.lnlstore
      INTO TEMP x
    UPDATE x
        SET lnl01      = l_new,  
            lnlstore      = l_newno,
            lnlacti    = 'Y',     
            lnluser    = g_user, 
            lnlcrat    = g_today,
            lnlgrup    = g_grup, 
            lnlmodu    = NULL, 
            lnldate    = NULL               
    INSERT INTO lnl_file SELECT * FROM x
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err(l_new,SQLCA.sqlcode,0)
    ELSE
       MESSAGE 'ROW(',l_new,') O.K'
      #FUN-B90121 Add Begin ---
       DROP TABLE y
       SELECT * FROM lik_file
        WHERE lik01 = g_lnl.lnl01
          AND likstore = g_lnl.lnlstore
         INTO TEMP y
       UPDATE y
          SET lik01 = l_new,
              likstore = l_newno
       INSERT INTO lik_file SELECT * FROM y
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err(l_new,SQLCA.sqlcode,0)
       ELSE
          LET g_cnt=SQLCA.SQLERRD[3]
          MESSAGE '(',g_cnt USING '##&',') ROW of (',l_new,') O.K'
      #FUN-B90121 Add End -----
          LET l_old = g_lnl.lnl01
          LET l_oldno = g_lnl.lnlstore
          LET g_lnl.lnl01 = l_new
          LET g_lnl.lnlstore = l_newno
          
          SELECT lnl_file.* INTO g_lnl.*
            FROM lnl_file
           WHERE lnl01 = l_new
             AND lnlstore = l_newno
 
         #CALL i350_u('c') #FUN-B90121 Mark
          CALL i350_b()    #FUN-B90121 Add
          #FUN-C30027---begin
          #SELECT lnl_file.* INTO g_lnl.*
          #  FROM lnl_file
          # WHERE lnl01 = l_old
          #   AND lnlstore = l_oldno
          #FUN-C30027---end
       END IF
    END IF
    #LET g_lnl.lnl01 = l_old      #FUN-C30027
    #LET g_lnl.lnlstore = l_oldno #FUN-C30027
    CALL i350_show()
END FUNCTION
 
FUNCTION i350_set_entry(p_cmd)
DEFINE   p_cmd    LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lnl01,lnlstore",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i350_set_no_entry(p_cmd)                                                                     
 DEFINE   p_cmd     LIKE type_file.chr1                                                           
 
  IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN                
      CALL cl_set_comp_entry("lnl01,lnlstore",FALSE)                                                        
  END IF                                                                                             
# CALL cl_set_comp_entry('lnlstore',FALSE)  #No.MOD-9C0364
END FUNCTION
 
FUNCTION i350_check_lnl01(p_cmd)
 DEFINE p_cmd    LIKE lnl_file.lnl01
 DEFINE l_count  LIKE type_file.num10
 DEFINE l_count1 LIKE type_file.num5
 DEFINE l_oajacti  LIKE oaj_file.oajacti
 
  SELECT COUNT(*) INTO l_count1 FROM lnl_file
   WHERE lnl01 = g_lnl.lnl01 
     AND lnlstore = g_lnl.lnlstore          
     IF l_count1 >0 THEN 
         CALL cl_err('','alm-081',1)
         LET g_success = 'N' 
     ELSE    
  
    LET l_count = 0 
    SELECT COUNT(*) INTO l_count FROM oaj_file
     WHERE oaj01 = p_cmd 
    IF l_count < 1 THEN 
       CALL cl_err(g_lnl.lnl01,'alm-075',0)
       DISPLAY '' TO lnl01
       LET g_success = 'N'
    ELSE
       SELECT oajacti INTO l_oajacti FROM oaj_file
        WHERE oaj01 = p_cmd
        IF l_oajacti != 'Y' THEN 
           CALL cl_err(g_lnl.lnl01,'alm-076',0)
           DISPLAY '' TO lnl01
           LET g_success = 'N'
        ELSE 	
    	     LET g_success = 'Y'   
    	  END IF    
    END IF  	
 END IF
END FUNCTION 
FUNCTION copy_check_lnl01(p_cmd)
 DEFINE p_cmd    LIKE lnl_file.lnl01
 DEFINE l_count  LIKE type_file.num10
 DEFINE l_count1 LIKE type_file.num5
 DEFINE l_oajacti  LIKE oaj_file.oajacti
 
 
    LET l_count = 0 
    SELECT COUNT(*) INTO l_count FROM oaj_file
     WHERE oaj01 = p_cmd 
    IF l_count < 1 THEN 
       CALL cl_err(p_cmd,'alm-075',0)
       DISPLAY '' TO lnl01
       LET g_success = 'N'
    ELSE
       SELECT oajacti INTO l_oajacti FROM oaj_file
        WHERE oaj01 = p_cmd
        IF l_oajacti != 'Y' THEN 
           CALL cl_err(p_cmd,'alm-076',0)
           DISPLAY '' TO lnl01
           LET g_success = 'N'
        ELSE 	
    	     LET g_success = 'Y'   
    	  END IF    
    END IF  	
# END IF
END FUNCTION 
 
FUNCTION i350_check_lnlstore(p_cmd)
 DEFINE p_cmd    LIKE lnl_file.lnlstore
 DEFINE l_count  LIKE type_file.num10
 DEFINE l_count1 LIKE type_file.num10
 DEFINE l_rtz28  LIKE rtz_file.rtz28
 
  SELECT COUNT(*) INTO l_count1 FROM lnl_file
   WHERE lnl01 = g_lnl.lnl01 
     AND lnlstore = g_lnl.lnlstore          
     IF l_count1 >0 THEN 
         CALL cl_err('','alm-081',1)
         LET g_success = 'N' 
     ELSE    
     	
    SELECT COUNT(*) INTO l_count FROM rtz_file
     WHERE rtz01 = p_cmd 
    IF l_count < 1 THEN 
       CALL cl_err('','alm-077',0)
       DISPLAY '' TO lnlstore
       LET g_success = 'N'
    ELSE
       SELECT rtz28 INTO l_rtz28 FROM rtz_file
        WHERE rtz01 = p_cmd
        IF l_rtz28 != 'Y' THEN 
           CALL cl_err('','alm-007',0)
           DISPLAY '' TO lnlstore
           LET g_success = 'N'
        ELSE 
        #  LET l_count = 0 
        #  SELECT COUNT(*) INTO l_count FROM rtz_file
        #   WHERE rtz01 = p_cmd
        #     AND rtz28 = 'Y'
        #     AND rtz01 = g_plant	
        # IF l_count < 1 THEN 
        #    CALL cl_err('','alm-555',1)
        #    LET g_success = 'N'        	    
        # ELSE   
        #    LET g_success = 'Y'   
        # END IF  
       END IF    
    END IF  	
END IF 
END FUNCTION 
 
FUNCTION copy_check_lnlstore(p_cmd)
 DEFINE p_cmd    LIKE lnl_file.lnlstore
 DEFINE l_count  LIKE type_file.num10
 DEFINE l_count1 LIKE type_file.num10
 DEFINE l_rtz28  LIKE rtz_file.rtz28
 
    	
    SELECT COUNT(*) INTO l_count FROM rtz_file
     WHERE rtz01 = p_cmd 
    IF l_count < 1 THEN 
       CALL cl_err(p_cmd,'alm-077',0)
       DISPLAY '' TO lnlstore
       LET g_success = 'N'
    ELSE
       SELECT rtz28 INTO l_rtz28 FROM rtz_file
        WHERE rtz01 = p_cmd
        IF l_rtz28 != 'Y' THEN 
           CALL cl_err(p_cmd,'alm-007',0)
           DISPLAY '' TO lnlstore
           LET g_success = 'N'
        ELSE 	
       	#LET l_count = 0 
       	#SELECT COUNT(*) INTO l_count FROM rtz_file
       	# WHERE rtz01 = p_cmd
       	#   AND rtz28 = 'Y'
       	#   AND rtz01 = g_plant	
       	#IF l_count < 1 THEN 
       	#   CALL cl_err('','alm-555',1)
       	#   LET g_success = 'N'        	    
       	#ELSE   
        #   LET g_success = 'Y'   
        #END IF      	       
      END IF    
    END IF  	
END FUNCTION 

#FUN-B90121 Add Begin ---
#檢查当前费用类型是否已被使用
FUNCTION i350_chk_upd(p_lik03,p_lik04,p_lik05,p_lik06,p_lik07)
DEFINE p_lik03 LIKE lik_file.lik03
DEFINE p_lik04 LIKE lik_file.lik04
DEFINE p_lik05 LIKE lik_file.lik05
DEFINE p_lik06 LIKE lik_file.lik06
DEFINE p_lik07 LIKE lik_file.lik07
DEFINE l_n     LIKE type_file.num5

   LET l_n = 0
   LET g_sql = "SELECT COUNT(*) ",
               "  FROM lil_file ",
               " WHERE lil04 = '",g_lnl.lnl01,"' ",
               "   AND lil09 = '",p_lik07,"' ",
               "   AND lilconf <> 'S' "
   IF g_lnl.lnl03 = 'Y' AND p_lik03 <> '*' THEN
      LET g_sql = g_sql CLIPPED," AND lil05 = '",p_lik03,"' "
   END IF
   IF g_lnl.lnl04 = 'Y' AND p_lik04 <> '*' THEN
      LET g_sql = g_sql CLIPPED," AND lil06 = '",p_lik04,"' "
   END IF
   IF g_lnl.lnl05 = 'Y' AND p_lik05 <> '*' THEN
      LET g_sql = g_sql CLIPPED," AND lil07 = '",p_lik05,"' "
   END IF
   IF g_lnl.lnl09 = 'Y' AND p_lik06 <> '*' THEN
      LET g_sql = g_sql CLIPPED," AND lil08 = '",p_lik06,"' "
   END IF
   PREPARE sel_lil_pre FROM g_sql
   EXECUTE sel_lil_pre INTO l_n
   IF l_n > 0 THEN
      RETURN FALSE
   ELSE
      LET l_n = 0
      LET g_sql = "SELECT COUNT(*) ",
                  "  FROM lip_file ",
                  " WHERE lip06 = '",g_lnl.lnl01,"' ",
                  "   AND lip11 = '",p_lik07,"' ",
                  "   AND lipconf <> 'S' "
      IF g_lnl.lnl03 = 'Y' AND p_lik03 <> '*' THEN
         LET g_sql = g_sql CLIPPED," AND lip07 = '",p_lik03,"' "
      END IF
      IF g_lnl.lnl04 = 'Y' AND p_lik04 <> '*' THEN
         LET g_sql = g_sql CLIPPED," AND lip08 = '",p_lik04,"' "
      END IF
      IF g_lnl.lnl05 = 'Y' AND p_lik05 <> '*' THEN
         LET g_sql = g_sql CLIPPED," AND lip09 = '",p_lik05,"' "
      END IF
      IF g_lnl.lnl09 = 'Y' AND p_lik06 <> '*' THEN
         LET g_sql = g_sql CLIPPED," AND lip10 = '",p_lik06,"' "
      END IF
      PREPARE sel_lip_pre FROM g_sql
      EXECUTE sel_lip_pre INTO l_n
      IF l_n > 0 THEN
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
   
END FUNCTION
#FUN-B90121 Add End -----
#FUN-C20078 STA ---
FUNCTION i350_lik09(l_lik09)
DEFINE l_lik09     LIKE lik_file.lik09

   IF l_lik09 = '5' THEN 
      CALL cl_set_comp_entry('lik10',FALSE)
   ELSE
      CALL cl_set_comp_entry('lik10',TRUE) 
   END IF
END FUNCTION 
#FUN-C20078 END ---
#No.FUN-960134 
 
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore 

