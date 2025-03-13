# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almi370.4gl
# Descriptions...: 戰盟連鎖優惠設置作業
# Date & Author..: FUN-870015 2008/07/07 By shiwuying
# Modify.........: No.FUN-960134 09/07/13 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/24 By shiwuying add oriu,orig
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No:TQC-A10120 10/01/15 By shiwuying lnn04+lnn05+lnn06=100
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30114 10/03/17 By Smapmin 複製時,lnp_file的資料沒有一併複製
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No.FUN-AA0006 10/10/12 By vealxu 重新規劃 lnt_file、lnu_file 資料檔, 檔案類別由原 B類(基本資料檔) 改成 T類(交易檔). 並在 lnt_file、lnu_file 加 PlantCode 欄位
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode,是另外一組的,在五行以外
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-C80041 12/11/27 By 取消單頭資料時刪除相關table
# Modify.........: No:FUN-D20039 13/01/19 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No.FUN-D30033 13/04/12 By minpp 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lnn         RECORD LIKE lnn_file.*,
       g_lnn_t       RECORD LIKE lnn_file.*,
       g_lnn_o       RECORD LIKE lnn_file.*,
       g_lnnstore_t     LIKE lnn_file.lnnstore,
       g_lnn02_t     LIKE lnn_file.lnn02,
       g_lno         DYNAMIC ARRAY OF RECORD
           lno03     LIKE lno_file.lno03,
           lno04     LIKE lno_file.lno04
                     END RECORD,
       g_lno_t       RECORD
           lno03     LIKE lno_file.lno03,
           lno04     LIKE lno_file.lno04
                     END RECORD,
       g_lno_o       RECORD 
           lno03     LIKE lno_file.lno03,
           lno04     LIKE lno_file.lno04
                     END RECORD,
       g_sql,g_str   STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_cmd           LIKE type_file.chr1000,
       l_ac          LIKE type_file.num5
 
DEFINE g_void              LIKE type_file.chr1 
DEFINE g_confirm           LIKE type_file.chr1
DEFINE g_forupd_sql        STRING              #SELECT ... FOR UPDATE 
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE type_file.chr1   
DEFINE g_chr2              LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10  
DEFINE g_i                 LIKE type_file.num5    
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10   
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask           LIKE type_file.num5
 
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
 
   INITIALIZE g_lnn.* TO NULL
   LET g_forupd_sql = "SELECT * FROM lnn_file WHERE lnnstore = ? AND lnn02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i370_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i370_w WITH FORM "alm/42f/almi370"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_pdate = g_today  
   LET g_action_choice=""
   CALL i370_menu()
   CLOSE WINDOW i370_w 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i370_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM 
   CALL g_lno.clear()
   CALL cl_set_head_visible("","YES")          
   INITIALIZE g_lnn.* TO NULL      
   CONSTRUCT BY NAME g_wc ON lnnstore,lnnlegal,lnn02,lnn03,lnn04,lnn05,lnn06,lnn07,lnn08,
                             lnn09,lnnuser,lnngrup,lnnoriu,lnnorig,  #No:FUN-9B0136
                             lnncrat,lnnmodu,lnnacti,lnndate
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(lnnstore)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_lnnstore"
                  LET g_qryparam.where = " lnnstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnnstore
                  NEXT FIELD lnnstore
                  
               WHEN INFIELD(lnnlegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_lnnlegal"
                  LET g_qryparam.where = " lnnstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnnlegal
                  NEXT FIELD lnnlegal
 
               WHEN INFIELD(lnn03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_lnn03"
                  LET g_qryparam.where = " lnnstore IN ",g_auth," "  #No.FUN-A10060
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lnn03
                  NEXT FIELD lnn03
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
           CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF
                                                
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                       
   #      LET g_wc = g_wc clipped," AND lnnuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                     
   #      LET g_wc = g_wc clipped," AND lnngrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN       
   #      LET g_wc = g_wc clipped," AND lnngrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lnnuser', 'lnngrup')
   #End:FUN-980030
 
   CONSTRUCT g_wc2 ON lno03,lno04
              FROM s_lno[1].lno03,s_lno[1].lno04
       
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
       
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
  
   IF g_wc2 = " 1=1" THEN              
      LET g_sql = "SELECT lnnstore,lnn02",
                  "  FROM lnn_file WHERE ", g_wc CLIPPED,
                  "   AND lnnstore IN ",g_auth,  #No.FUN-A10060
                  " ORDER BY lnnstore,lnn02"
   ELSE                              
      LET g_sql = "SELECT UNIQUE lnnstore,lnn02",
                  "  FROM lnn_file, lno_file ",
                  " WHERE lnnstore = lnostore",
                  "   AND lnnstore IN ",g_auth,  #No.FUN-A10060
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lnnstore,lnn02"
   END IF
 
   PREPARE i370_prepare FROM g_sql
   DECLARE i370_cs SCROLL CURSOR WITH HOLD FOR i370_prepare
   IF g_wc2 = " 1=1" THEN           
      LET g_sql="SELECT COUNT(*) FROM lnn_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND lnnstore IN ",g_auth     #No.FUN-A10060
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lnnstore,lnn02) FROM lnn_file,lno_file",
                " WHERE lnnstore = lnostore",
                "  AND lnnstore IN ",g_auth,     #No.FUN-A10060
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i370_precount FROM g_sql
   DECLARE i370_count CURSOR FOR i370_precount
END FUNCTION
 
FUNCTION i370_menu()
   WHILE TRUE
      CALL i370_bp("G")
      CASE g_action_choice
         
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i370_q()
            END IF
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i370_a()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lnn.lnnstore,g_plant) THEN
                  CALL i370_u()
            #  END IF
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lnn.lnnstore,g_plant) THEN
                  CALL i370_r()
            #  END IF
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lnn.lnnstore,g_plant) THEN
                  CALL i370_x()
            #  END IF
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lnn.lnnstore,g_plant) THEN
                  CALL i370_copy()
            #  END IF
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lnn.lnnstore,g_plant) THEN
                  CALL i370_b("u")
            #  END IF
            ELSE
               LET g_action_choice=NULL
            END IF
         
         WHEN "confirm" 
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lnn.lnnstore,g_plant) THEN
                  CALL i370_y()
            #  END IF
            END IF 
 
         WHEN "undo_confirm"      
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lnn.lnnstore,g_plant) THEN
                  CALL i370_z()
            #  END IF
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
           #    CALL i370_out()
            END IF
        
         WHEN "void"
            IF cl_chk_act_auth() THEN
            #  IF cl_chk_mach_auth(g_lnn.lnnstore,g_plant) THEN
                  CALL i370_v(1)
            #  END IF
            END IF
         #FUN-D20039 -------------sta
         WHEN "undo_void" 
            IF cl_chk_act_auth() THEN
               CALL i370_v(2)
            END IF
         #FUN-D20039 -------------end
 
         WHEN "regional"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_lnn.lnnstore) THEN
                  LET l_cmd="almi3701 '",g_lnn.lnnstore,"' '",g_lnn.lnn02,"' '",g_lnn.lnn03,"' " 
                  CALL cl_cmdrun_wait(l_cmd)
               END IF
            END IF
            
         WHEN "other_regional"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_lnn.lnnstore) THEN
                  LET l_cmd="almi3702 '",g_lnn.lnnstore,"' '",g_lnn.lnn02,"' " 
                  CALL cl_cmdrun_wait(l_cmd)
               END IF
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lno),'','')
            END IF
        
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lnn.lnnstore IS NOT NULL THEN
                 LET g_doc.column1 = "lnnstore"
                 LET g_doc.value1 = g_lnn.lnnstore
                 CALL cl_doc()
               END IF
         END IF
       END CASE
   END WHILE
END FUNCTION
 
FUNCTION i370_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lno TO s_lno.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
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
          
      ON ACTION reproduce 
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail 
         LET g_action_choice="detail"
         LET l_ac=1
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION first
         CALL i370_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL i370_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION jump
         CALL i370_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL i370_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION last
         CALL i370_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
  
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
 
      #FUN-D20039 ------------sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20039 ------------end
      ON ACTION regional
         LET g_action_choice="regional"
         EXIT DISPLAY
  
      ON ACTION other_regional
         LET g_action_choice="other_regional"
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
 
FUNCTION i370_a()
 DEFINE l_cnt       LIKE type_file.num5
#DEFINE l_tqa06     LIKE tqa_file.tqa06 
 
####判斷當前組織機構是否是門店，只能在門店錄資料######
#  SELECT tqa06 INTO l_tqa06 FROM tqa_file
#   WHERE tqa03 = '14'
#     AND tqaacti = 'Y'
#     AND tqa01 IN(SELECT tqb03 FROM tqb_file
#                   WHERE tqbacti = 'Y'
#                     AND tqb09 = '2'
#                     AND tqb01 = g_plant)
#  IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN
#     CALL cl_err('','alm-600',1)
#     RETURN
#  END IF 
 
   SELECT COUNT(*) INTO l_cnt FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
   IF l_cnt < 1 THEN
      CALL cl_err('','alm-606',1)
      RETURN
   END IF
######################################################
 
    MESSAGE ""
    CLEAR FORM
    CALL g_lno.clear()
    LET g_wc = NULL
    LET g_wc2 = NULL
    
    IF s_shut(0) THEN
       RETURN
    END IF
    INITIALIZE g_lnn.* LIKE lnn_file.*
    LET g_lnnstore_t = NULL
    #-----MOD-A30114---------
    IF cl_null(g_lnn.lnn03) THEN 
       LET g_lnn.lnn03 = ' '
    END IF
    #-----END MOD-A30114-----
    LET g_lnn_t.* = g_lnn.*
    LET g_lnn_o.* = g_lnn.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lnn.lnnstore = g_plant
        LET g_lnn.lnnlegal = g_legal
        LET g_lnn.lnn07 = 'N'
        LET g_lnn.lnnuser = g_user
        LET g_lnn.lnnoriu = g_user #FUN-980030
        LET g_lnn.lnnorig = g_grup #FUN-980030
        LET g_lnn.lnngrup = g_grup 
        LET g_lnn.lnnacti = 'Y'
        LET g_lnn.lnncrat = g_today
        CALL i370_i("a") 
        IF INT_FLAG THEN 
            INITIALIZE g_lnn.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_lnn.lnnstore IS NULL THEN 
            CONTINUE WHILE
        END IF
        
        BEGIN WORK
        INSERT INTO lnn_file VALUES(g_lnn.*)
        IF SQLCA.sqlcode THEN
        #   ROLLBACK WORK     #FUN-B80060 下移兩行
           CALL cl_err3("ins","lnn_file",g_lnn.lnnstore,"",SQLCA.sqlcode,"","",0)
           ROLLBACK WORK      #FUN-B80060
           CONTINUE WHILE
        ELSE
           COMMIT WORK
        END IF
        SELECT * INTO g_lnn.* FROM lnn_file
                    WHERE lnnstore = g_lnn.lnnstore
                      AND lnn02 = g_lnn.lnn02
        LET g_lnnstore_t = g_lnn.lnnstore
        LET g_lnn02_t = g_lnn.lnn02
        LET g_lnn_t.* = g_lnn.*
        LET g_lnn_o.* = g_lnn.*
 
        CALL g_lno.clear()
        LET g_rec_b = 0
        CALL i370_b("a")
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i370_u()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_lnn.lnnstore IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lnn.* FROM lnn_file
    WHERE lnnstore = g_lnn.lnnstore
      AND lnn02 = g_lnn.lnn02
      
   IF g_lnn.lnnacti ='N' THEN
      CALL cl_err(g_lnn.lnnstore,'mfg1000',0)
      RETURN
   END IF
   
   IF g_lnn.lnn07='Y' THEN
      CALL cl_err(g_lnn.lnn07,'9003',0)
      RETURN
   END IF
 
   IF g_lnn.lnn07='X' THEN
      CALL cl_err(g_lnn.lnn07,'9024',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lnnstore_t = g_lnn.lnnstore
   LET g_lnn02_t = g_lnn.lnn02
      
   BEGIN WORK
   OPEN i370_cl USING g_lnn.lnnstore,g_lnn.lnn02
   IF STATUS THEN
      CALL cl_err("OPEN i370_cl:", STATUS, 1)
      CLOSE i370_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i370_cl INTO g_lnn.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lnn.lnnstore,SQLCA.sqlcode,0)
       CLOSE i370_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i370_show()
   WHILE TRUE
      LET g_lnn_o.* = g_lnn.*
      LET g_lnn.lnnmodu=g_user
      LET g_lnn.lnndate=g_today
      CALL i370_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lnn.*=g_lnn_t.*
         CALL i370_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lnnstore_t <> g_lnn.lnnstore OR g_lnn02_t <> g_lnn.lnn02 THEN
         UPDATE lno_file SET lnostore = g_lnn.lnnstore,
                             lno02 = g_lnn.lnn02
          WHERE lnostore = g_lnnstore_t
            AND lno02 = g_lnn02_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lno_file","","",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF
 
         UPDATE lnp_file SET lnpstore = g_lnn.lnnstore,
                             lnp02 = g_lnn.lnn02
          WHERE lnpstore = g_lnnstore_t
            AND lnp02 = g_lnn02_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lnp_file","","",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF
 
         UPDATE lnq_file SET lnqstore = g_lnn.lnnstore,
                             lnq02 = g_lnn.lnn02
          WHERE lnqstore = g_lnnstore_t
            AND lnq02 = g_lnn02_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lnq_file","","",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE lnn_file SET lnn_file.* = g_lnn.*
       WHERE lnnstore = g_lnnstore_t
         AND lnn02 = g_lnn02_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lnn_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i370_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lnn.lnnstore,'U')
   CALL i370_show()
   CALL i370_b_fill("1=1")
END FUNCTION
 
FUNCTION  i370_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5,
   l_input   LIKE type_file.chr1,    
   p_cmd     LIKE type_file.chr1     
   DEFINE    li_result   LIKE type_file.num5    
   DEFINE    l_lno04     LIKE lno_file.lno04
   DEFINE    l_lnp05     LIKE lnp_file.lnp05
   DEFINE    l_lnq04     LIKE lnq_file.lnq04
   
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lnn.lnnoriu,g_lnn.lnnorig,g_lnn.lnn07,g_lnn.lnn08,g_lnn.lnn09,g_lnn.lnnuser,
                   g_lnn.lnnmodu,g_lnn.lnngrup,g_lnn.lnndate,g_lnn.lnnacti,
                   g_lnn.lnncrat,g_lnn.lnnlegal
   CALL i370_lnnstore('d')
   CALL i370_lnnlegal(p_cmd)
 
   CALL cl_set_head_visible("","YES")          
   INPUT BY NAME g_lnn.lnnstore,g_lnn.lnn02,g_lnn.lnn04,g_lnn.lnn05,g_lnn.lnn06 
                 WITHOUT DEFAULTS
 
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i370_set_entry(p_cmd)
        CALL i370_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
 
     AFTER FIELD lnnstore
         IF g_lnn.lnnstore  IS NOT NULL THEN
            CALL i370_lnnstore(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lnn.lnnstore,g_errno,1)
               IF g_errno = 'alm-001' THEN
                  LET INT_FLAG = 1
                  EXIT INPUT
               END IF
               LET g_lnn.lnnstore = g_lnn_o.lnnstore
               NEXT FIELD lnnstore
            END IF
         END IF
         
     AFTER FIELD lnn02
         IF g_lnn.lnn02  IS NOT NULL THEN
            IF g_lnn.lnn02 != g_lnn_o.lnn02
                 OR g_lnn_o.lnn02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM lnn_file
                  WHERE lnnstore = g_lnn.lnnstore
                    AND lnn02 = g_lnn.lnn02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lnn.lnn02 = g_lnn_o.lnn02
                    NEXT FIELD lnn02
                 END IF
              END IF
         END IF
     
     AFTER FIELD lnn04
        IF NOT cl_null(g_lnn.lnn04) THEN 
           IF g_lnn.lnn04 < 0 OR g_lnn.lnn04 > 100 THEN
              CALL cl_err(g_lnn.lnn04,'mfg4013',0)
              NEXT FIELD lnn04
           END IF
        END IF
    
     AFTER FIELD lnn05
        IF NOT cl_null(g_lnn.lnn05) THEN 
           IF g_lnn.lnn05 < 0 OR g_lnn.lnn05 > 100 THEN
              CALL cl_err(g_lnn.lnn05,'mfg4013',0)
              NEXT FIELD lnn05
           END IF
        END IF
     
     AFTER FIELD lnn06
        IF NOT cl_null(g_lnn.lnn06) THEN 
           IF g_lnn.lnn06 < 0 OR g_lnn.lnn06 > 100THEN
              CALL cl_err(g_lnn.lnn06,'mfg4013',0)
              NEXT FIELD lnn06
           END IF
        END IF
    
     AFTER INPUT
        LET g_lnn.lnnuser = s_get_data_owner("lnn_file") #FUN-C10039
        LET g_lnn.lnngrup = s_get_data_group("lnn_file") #FUN-C10039
        IF INT_FLAG THEN
           EXIT INPUT
        END IF
        IF g_lnn.lnn04+g_lnn.lnn05+g_lnn.lnn06 <> 100 THEN #No.TQC-A10120
           CALL cl_err('','alm-704',0)
           NEXT FIELD lnn04
        END IF

        SELECT MAX(lno04) INTO l_lno04 FROM lno_file 
         WHERE lnostore = g_lnn.lnnstore
           AND lno02 = g_lnn.lnn02
 
        SELECT MAX(lnp05) INTO l_lnp05 FROM lnp_file 
         WHERE lnpstore = g_lnn.lnnstore
           AND lnp02 = g_lnn.lnn02
           AND lnp03 = g_lnn.lnn03 
 
        SELECT MAX(lnq04) INTO l_lnq04 FROM lnq_file 
         WHERE lnqstore = g_lnn.lnnstore
           AND lnq02 = g_lnn.lnn02
 
        IF cl_null(l_lno04) THEN LET l_lno04=0 END IF
        IF cl_null(l_lnp05) THEN LET l_lnp05=0 END IF
        IF cl_null(l_lnq04) THEN LET l_lnq04=0 END IF
        IF ((g_lnn.lnn04/100)*(l_lno04/100) + (g_lnn.lnn05/100)*(l_lnp05/100) + (g_lnn.lnn06/100)*(l_lnq04/100)) >1 THEN
           CALL cl_err('','alm-163',1)
           NEXT FIELD lnn04
        END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(lnnstore)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rtz"
              LET g_qryparam.default1 =g_lnn.lnnstore
              CALL cl_create_qry() RETURNING g_lnn.lnnstore
              DISPLAY BY NAME g_lnn.lnnstore
              NEXT FIELD lnnstore
           OTHERWISE EXIT CASE
        END CASE       
           
      ON ACTION CONTROLO                 
         IF INFIELD(lnnstore) THEN
            LET g_lnn.* = g_lnn_t.*
            CALL i370_show()
            NEXT FIELD lnnstore
         END IF
    
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
 
FUNCTION i370_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lno.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i370_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lnn.* TO NULL
      RETURN
   END IF
 
   OPEN i370_cs                            
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lnn.* TO NULL
   ELSE
      OPEN i370_count
      FETCH i370_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i370_fetch('F')
   END IF
END FUNCTION
 
FUNCTION i370_fetch(p_flag)
DEFINE         p_flag         LIKE type_file.chr1                 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i370_cs INTO g_lnn.lnnstore,g_lnn.lnn02
      WHEN 'P' FETCH PREVIOUS i370_cs INTO g_lnn.lnnstore,g_lnn.lnn02
      WHEN 'F' FETCH FIRST    i370_cs INTO g_lnn.lnnstore,g_lnn.lnn02
      WHEN 'L' FETCH LAST     i370_cs INTO g_lnn.lnnstore,g_lnn.lnn02
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
          FETCH ABSOLUTE g_jump i370_cs INTO g_lnn.lnnstore,g_lnn.lnn02
          LET g_no_ask = FALSE    
     END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnn.lnnstore,SQLCA.sqlcode,0)
      INITIALIZE g_lnn.* TO NULL               
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
 
   SELECT * INTO g_lnn.* FROM lnn_file
    WHERE lnnstore = g_lnn.lnnstore
      AND lnn02 = g_lnn.lnn02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lnn_file","","",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_lnn.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lnn.lnnuser      
   LET g_data_group = g_lnn.lnngrup      
   CALL i370_show()
END FUNCTION
 
FUNCTION i370_show()
   LET g_lnn_t.* = g_lnn.* 
   LET g_lnn_o.* = g_lnn.*
   DISPLAY BY NAME g_lnn.lnnstore,g_lnn.lnn02,g_lnn.lnn03,g_lnn.lnn04,g_lnn.lnn05, g_lnn.lnnoriu,g_lnn.lnnorig,
                   g_lnn.lnn06,g_lnn.lnn07,g_lnn.lnn08,g_lnn.lnn09,
                   g_lnn.lnnuser,g_lnn.lnnmodu,g_lnn.lnngrup,g_lnn.lnndate,
                   g_lnn.lnnacti,g_lnn.lnncrat,g_lnn.lnnlegal
   CALL i370_lnnstore('d')
   CALL i370_lnnlegal('d')
   CALL i370_b_fill(g_wc2)
   CALL i370_field_pic() 
   CALL cl_show_fld_cont()  
END FUNCTION
 
FUNCTION i370_field_pic()
     LET g_void=NULL
     LET g_confirm=NULL
     IF g_lnn.lnn07 MATCHES '[Yy]' THEN
           LET g_confirm='Y'
           LET g_void='N'
     ELSE
        IF g_lnn.lnn07 ='X' THEN
           LET g_confirm='N'
           LET g_void='Y'
        ELSE
           LET g_confirm='N'
           LET g_void='N'
        END IF
     END IF
     CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lnn.lnnacti)
END FUNCTION
 
FUNCTION i370_lnnstore(p_cmd)  
   DEFINE l_rtz01   LIKE rtz_file.rtz01   #FUN-A80148 add
   DEFINE l_rtz13   LIKE rtz_file.rtz13   #FUN-A80148 add
  #DEFINE l_lma04   LIKE rtz_file.lma04 #FUN-A80148 ---mark---
   DEFINE l_azw07   LIKE azw_file.azw07 #FUN-A80148
   DEFINE l_rtz28   LIKE rtz_file.rtz28
   DEFINE p_cmd     LIKE type_file.chr1 
 # DEFINE l_rtzacti LIKE rtz_file.rtzacti      #FUN-A80148 mark by vealxu
   DEFINE l_azwacti LIKE azw_file.azwacti      #FUN-A80148 add  by vealxu 
   DEFINE l_azp02   LIKE azp_file.azp02
   LET g_errno=''
 
   SELECT rtz01,rtz13,rtz28,azwacti                   #FUN-A80148 mod rtzacti ->azwacti by vealxu 
     INTO l_rtz01,l_rtz13,l_rtz28,l_azwacti           #FUN-A80148 mod l_rtzacti -> l_azwacti by vealxu  
     FROM rtz_file INNER JOIN azw_file                #FUN-A80148 add azw_file by vealxu 
       ON rtz01 = azw01                               #FUN-A80148 add by vealxu 
    WHERE rtz01=g_lnn.lnnstore
  #FUN-A80148 ----------------mark start--------------------- 
  #SELECT azw07 
  #  INTO l_azw07 
  #  FROM AZEW_FILE       
  # WHERE azw01=l_rtz01
  #FUN-A80148 ---------------mark end-------------------------
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-001'
                               LET l_rtz13=NULL
                               LET l_azw07=NULL
      # WHEN l_rtzacti='N'     LET g_errno='9028'              #FUN-A80148 mark by vealxu 
        WHEN l_azwacti = 'N'   LET g_errno='9028'              #FUN-A80148 add  by vealxu 
        WHEN l_rtz28='N'       LET g_errno='alm-002'
        WHEN l_rtz01 <> g_plant LET g_errno = 'alm-376'
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
   SELECT azw07 INTO l_azw07 FROM azw_file WHERE azw01=l_rtz01         #FUN-A80148 add 
   SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=l_azw07
   
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      LET g_lnn.lnn03=l_azw07
      #-----MOD-A30114---------
      IF cl_null(g_lnn.lnn03) THEN 
         LET g_lnn.lnn03 = ' '
      END IF
      #-----END MOD-A30114-----
      DISPLAY l_rtz13 TO FORMONLY.rtz13
      DISPLAY BY NAME g_lnn.lnn03
      DISPLAY l_azp02 TO FORMONLY.azp02
   END IF
END FUNCTION
 
FUNCTION i370_lnnlegal(p_cmd)
 DEFINE p_cmd     LIKE type_file.chr1
 DEFINE l_azt02   LIKE azt_file.azt02
 
   IF p_cmd <> 'u' THEN
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_lnn.lnnlegal
      DISPLAY l_azt02 TO FORMONLY.azt02
   END IF
END FUNCTION
FUNCTION i370_b(p_c)
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    p_c             LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
 
DEFINE  l_lnq04     LIKE lnq_file.lnq04
DEFINE  l_lnp05     LIKE lnp_file.lnp05 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_lnn.lnnstore IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_lnn.* FROM lnn_file
     WHERE lnnstore=g_lnn.lnnstore
       AND lnn02=g_lnn.lnn02
 
    IF g_lnn.lnnacti ='N' THEN 
       CALL cl_err(g_lnn.lnnstore,'mfg1000',0)
       RETURN
    END IF
 
   IF g_lnn.lnn07='Y' THEN            #眒機瞄, 祥褫黨蜊訧蹋!
      CALL cl_err(g_lnn.lnn09,'9003',0)
      RETURN
   END IF
 
   IF g_lnn.lnn07='X' THEN             #釬煙, 祥褫黨蜊訧蹋!
      CALL cl_err(g_lnn.lnn09,'9024',0)
      RETURN
   END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT lno03,lno04",
                       "  FROM lno_file",
                       " WHERE lnostore=? AND lno02=? AND lno03=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i370_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_lno WITHOUT DEFAULTS FROM s_lno.*
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
 
           OPEN i370_cl USING g_lnn.lnnstore,g_lnn.lnn02
           IF STATUS THEN
              CALL cl_err("OPEN i370_cl:", STATUS, 1)
              CLOSE i370_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i370_cl INTO g_lnn.* 
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lnn.lnnstore,SQLCA.sqlcode,0) 
              CLOSE i370_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lno_t.* = g_lno[l_ac].*  #BACKUP
              LET g_lno_o.* = g_lno[l_ac].*  #BACKUP
              OPEN i370_bcl USING g_lnn.lnnstore,g_lnn.lnn02,g_lno_t.lno03
              IF STATUS THEN
                 CALL cl_err("OPEN i370_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i370_bcl INTO g_lno[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lno_t.lno03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lno[l_ac].* TO NULL
           LET g_lno_t.* = g_lno[l_ac].* 
           LET g_lno_o.* = g_lno[l_ac].* 
           CALL cl_show_fld_cont()
           NEXT FIELD lno03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO lno_file(lnostore,lnolegal,lno02,lno03,lno04)
           VALUES(g_lnn.lnnstore,g_lnn.lnnlegal,
                  g_lnn.lnn02,g_lno[l_ac].lno03,g_lno[l_ac].lno04)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lno_file",g_lnn.lnnstore,g_lno[l_ac].lno03,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        
        AFTER FIELD lno03
           IF NOT cl_null(g_lno[l_ac].lno03) THEN
              IF g_lno[l_ac].lno03 != g_lno_t.lno03
                 OR g_lno_t.lno03 IS NULL THEN
                 IF g_lno[l_ac].lno03 <0 THEN
                    CALL cl_err(g_lno[l_ac].lno03,'alm-061',0)
                    NEXT FIELD lno03
                 END IF
                 SELECT count(*)
                   INTO l_n
                   FROM lno_file
                  WHERE lnostore = g_lnn.lnnstore
                    AND lno02 = g_lnn.lnn02 
                    AND lno03 = g_lno[l_ac].lno03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lno[l_ac].lno03 = g_lno_t.lno03
                    NEXT FIELD lno03
                 END IF
              END IF
           END IF
 
        AFTER FIELD lno04
           IF NOT cl_null(g_lno[l_ac].lno04) THEN
              IF g_lno[l_ac].lno04 < 0 OR g_lno[l_ac].lno04 >100 THEN
                 CALL cl_err('','atm-070',0)
                 LET g_lno[l_ac].lno04 = g_lno_t.lno04
                 NEXT FIELD lno04
              END IF
 
              SELECT MAX(lnp05) INTO l_lnp05 FROM lnp_file
               WHERE lnpstore = g_lnn.lnnstore 
                 AND lnp02 = g_lnn.lnn02 
                 AND lnp03 = g_lnn.lnn03
 
              SELECT MAX(lnq04) INTO l_lnq04 FROM lnq_file 
               WHERE lnqstore = g_lnn.lnnstore
                 AND lnq02 = g_lnn.lnn02
 
              IF cl_null(l_lnp05) THEN LET l_lnp05=0 END IF
              IF cl_null(l_lnq04) THEN LET l_lnq04=0 END IF
              IF ((g_lnn.lnn04/100)*(g_lno[l_ac].lno04/100) + (g_lnn.lnn05/100)*(l_lnp05/100) + (g_lnn.lnn06/100)*(l_lnq04/100)) >1 THEN
                 CALL cl_err('','alm-163',1) 
                 NEXT FIELD lno04
              END IF
           END IF
 
        BEFORE DELETE 
           DISPLAY "BEFORE DELETE"
           IF g_lno_t.lno03 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lno_file
               WHERE lnostore = g_lnn.lnnstore
                 AND lno02 = g_lnn.lnn02 
                 AND lno03 = g_lno_t.lno03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lno_file",g_lnn.lnnstore,g_lno_t.lno03,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_lno[l_ac].* = g_lno_t.*
              CLOSE i370_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lno[l_ac].lno03,-263,1)
              LET g_lno[l_ac].* = g_lno_t.*
           ELSE
             UPDATE lno_file SET lno03=g_lno[l_ac].lno03,lno04=g_lno[l_ac].lno04
               WHERE lnostore=g_lnn.lnnstore
                 AND lno02 = g_lnn.lnn02
                 AND lno03=g_lno_t.lno03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lno_file",g_lnn.lnnstore,g_lno_t.lno03,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_lno[l_ac].* = g_lno_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac       #FUN-D30033
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lno[l_ac].* = g_lno_t.*
              #FUN-D30033----add--str
              ELSE
                 CALL g_lno.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033---add--end
              END IF
              CLOSE i370_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac       #FUN-D30033
           CLOSE i370_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(lno03) AND l_ac > 1 THEN
              LET g_lno[l_ac].* = g_lno[l_ac-1].*
              LET g_lno[l_ac].lno03 = g_rec_b + 1
              NEXT FIELD lno02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
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
    IF p_c="u" THEN
       LET g_lnn.lnnmodu = g_user
       LET g_lnn.lnndate = g_today
       UPDATE lnn_file SET lnnmodu = g_lnn.lnnmodu,lnndate = g_lnn.lnndate
        WHERE lnnstore = g_lnn.lnnstore
          AND lno02 = g_lnn.lnn02
       DISPLAY BY NAME g_lnn.lnnmodu,g_lnn.lnndate
    END IF
 
    CLOSE i370_bcl
    COMMIT WORK
    
    SELECT COUNT(*) INTO g_cnt FROM lno_file
     WHERE lnostore = g_lnn.lnnstore AND lno02 = g_lnn.lnn02 
    IF g_cnt = 0 THEN
#CHI-C30002 -------- mark -------- begin
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM lnn_file WHERE lnnstore = g_lnn.lnnstore
#                             AND lnn02 = g_lnn.lnn02
#      
#      CLEAR FORM
#CHI-C30002 -------- mark -------- end
       CALL i370_delHeader()     #CHI-C30002 add
       IF g_row_count > 0 THEN
          OPEN i370_count
          FETCH i370_count INTO g_row_count
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i370_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i370_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET g_no_ask = TRUE      
             CALL i370_fetch('/')
          END IF
       END IF
    END IF
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i370_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN  
         #CHI-C80041---begin
         DELETE FROM lnp_file WHERE lnpstore=g_lnn.lnnstore         #所屬區域資料
                                AND lnp02=g_lnn.lnn02
                                AND lnp03=g_lnn.lnn03
         DELETE FROM lnq_file WHERE lnqstore=g_lnn.lnnstore         #其他區域資料
                                AND lnq02=g_lnn.lnn02
         #CHI-C80041---end
         DELETE FROM lnn_file WHERE lnnstore = g_lnn.lnnstore
                             AND lnn02 = g_lnn.lnn02
         INITIALIZE g_lnn.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i370_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lnn.lnnstore IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lnn.* FROM lnn_file
    WHERE lnnstore=g_lnn.lnnstore
      AND lnn02=g_lnn.lnn02
   
   IF g_lnn.lnn07='X' THEN
      CALL cl_err('','9024',0) 
      RETURN 
   END IF
   
   IF g_lnn.lnn07='Y' THEN
      CALL cl_err('','9023',0) 
      RETURN 
   END IF
    
   BEGIN WORK
 
   OPEN i370_cl USING g_lnn.lnnstore,g_lnn.lnn02
   IF STATUS THEN
      CALL cl_err("OPEN i370_cl:", STATUS, 1)
      CLOSE i370_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i370_cl INTO g_lnn.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnn.lnnstore,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   LET g_success = 'Y'
   CALL i370_show()
   IF cl_exp(0,0,g_lnn.lnnacti) THEN
      LET g_chr=g_lnn.lnnacti
      IF g_lnn.lnnacti='Y' THEN
         LET g_lnn.lnnacti='N'
      ELSE
         LET g_lnn.lnnacti='Y'
      END IF
 
      UPDATE lnn_file SET lnnacti=g_lnn.lnnacti,
                          lnnmodu=g_user,
                          lnndate=g_today
       WHERE lnnstore=g_lnn.lnnstore
         AND lnn02=g_lnn.lnn02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lnn_file",g_lnn.lnnstore,"",SQLCA.sqlcode,"","",1)
         LET g_lnn.lnnacti=g_chr
      END IF
   END IF
   CLOSE i370_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lnn.lnnstore,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT lnnacti,lnnmodu,lnndate
     INTO g_lnn.lnnacti,g_lnn.lnnmodu,g_lnn.lnndate FROM lnn_file
    WHERE lnnstore = g_lnn.lnnstore
      AND lnn02=g_lnn.lnn02
   DISPLAY BY NAME g_lnn.lnnacti,g_lnn.lnnmodu,g_lnn.lnndate
   CALL i370_field_pic()
END FUNCTION
 
FUNCTION i370_y()
   IF cl_null(g_lnn.lnnstore) THEN 
        CALL cl_err('','-400',0) 
        RETURN 
   END IF
#CHI-C30107 ---------------- add -------------------- begin
   IF g_lnn.lnnacti='N' THEN       #拸虴
        CALL cl_err('','alm-048',0)
        RETURN
   END IF

   IF g_lnn.lnn07='Y' THEN #眒機瞄
        CALL cl_err('','9023',0)
        RETURN
   END IF

   IF g_lnn.lnn07='X' THEN #眒釬煙
        CALL cl_err('','9024',0)
        RETURN
   END IF
   
   IF NOT cl_confirm('alm-006') THEN
      RETURN
   END IF
#CHI-C30107 ---------------- add ------------------ end
   SELECT * INTO g_lnn.* FROM lnn_file
    WHERE lnnstore=g_lnn.lnnstore
      AND lnn02=g_lnn.lnn02
      
#CHI-C30107 ---------------- add ------------------ begin
   IF cl_null(g_lnn.lnnstore) THEN
        CALL cl_err('','-400',0)
        RETURN
   END IF
#CHI-C30107 ---------------- add ------------------ end
   IF g_lnn.lnnacti='N' THEN       #拸虴
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
   
   IF g_lnn.lnn07='Y' THEN #眒機瞄
        CALL cl_err('','9023',0)
        RETURN
   END IF
   
   IF g_lnn.lnn07='X' THEN #眒釬煙
        CALL cl_err('','9024',0)
        RETURN
   END IF
 
#CHI-C30107 ---------------- mark --------------- begin
#  IF NOT cl_confirm('alm-006') THEN 
#     RETURN
#  END IF
#CHI-C30107 ---------------- mark --------------- end
   
   BEGIN WORK
   LET g_success = 'Y'
   
   OPEN i370_cl USING g_lnn.lnnstore,g_lnn.lnn02
   IF STATUS THEN
      CALL cl_err("OPEN i370_cl:", STATUS, 1)
      CLOSE i370_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i370_cl INTO g_lnn.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnn.lnnstore,SQLCA.sqlcode,0)      
      CLOSE i370_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE lnn_file SET lnn07 = 'Y',lnn08 = g_user,lnn09 = g_today
    WHERE lnnstore = g_lnn.lnnstore
      AND lnn02 = g_lnn.lnn02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lnn_file",g_lnn.lnnstore,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_lnn.lnn07 = 'Y'
      LET g_lnn.lnn08 = g_user
      LET g_lnn.lnn09 = g_today
      DISPLAY BY NAME g_lnn.lnn07,g_lnn.lnn08,g_lnn.lnn09
      CALL i370_field_pic()
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION i370_z()
   DEFINE l_cnt LIKE type_file.num5
   IF cl_null(g_lnn.lnnstore) THEN 
        CALL cl_err('','-400',0) 
        RETURN 
   END IF
   
   SELECT * INTO g_lnn.* FROM lnn_file
    WHERE lnnstore=g_lnn.lnnstore
      AND lnn02=g_lnn.lnn02
   
   IF g_lnn.lnnacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
   
   IF g_lnn.lnn07='X' THEN 
        CALL cl_err('','9024',0)
        RETURN
   END IF
   
   IF g_lnn.lnn07='N' THEN 
        CALL cl_err('','9025',0)
        RETURN
   END IF
  
   IF g_lnn.lnn02='0' THEN  #合同優惠標准里有使用該戰盟連鎖優惠信息，不允許取消審核
      SELECT count(*) INTO l_cnt FROM lnt_file 
     # WHERE lntstore = g_lnn.lnnstore              #FUN-AA0006 mark
       WHERE lntplant = g_lnn.lnnstore              #FUN-AA0006
         AND lnt05 = 'Y'
      IF l_cnt > 0 THEN
         CALL cl_err('','alm-087',1)
         RETURN
      END IF
   END IF
   IF g_lnn.lnn02 = '1' THEN
      SELECT count(*) INTO l_cnt FROM lnt_file
     # WHERE lntstore=g_lnn.lnnstore               #FUN-AA0006 mark
       WHERE lntplant = g_lnn.lnnstore             #FUN-AA0006
         AND lnt05='N'
      IF l_cnt > 0 THEN
         CALL cl_err('','alm-087',1)
         RETURN
      END IF
   END IF
 
   IF NOT cl_confirm('alm-008') THEN 
      RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i370_cl USING g_lnn.lnnstore,g_lnn.lnn02
   IF STATUS THEN
      CALL cl_err("OPEN i370_cl:", STATUS, 1)
      CLOSE i370_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i370_cl INTO g_lnn.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnn.lnnstore,SQLCA.sqlcode,0)      
      CLOSE i370_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   #UPDATE lnn_file SET lnn07 = 'N',lnn08 = '',lnn09 = '',             #CHI-D20015 mark
   UPDATE lnn_file SET lnn07 = 'N',lnn08 = g_user,lnn09 = g_today,  #CHI-D20015 add
                       lnnmodu = g_user,lnndate = g_today
    WHERE lnnstore = g_lnn.lnnstore
      AND lnn02=g_lnn.lnn02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lnn_file",g_lnn.lnnstore,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_lnn.lnn07 = 'N'
      #CHI-D20015--modify--str--
      #LET g_lnn.lnn08 = ''
      #LET g_lnn.lnn09 = ''
      LET g_lnn.lnn08 = g_user
      LET g_lnn.lnn09 = g_today
      #CHI-D20015--modify--end--
      LET g_lnn.lnnmodu = g_user
      LET g_lnn.lnndate = g_today
      DISPLAY BY NAME g_lnn.lnn07,g_lnn.lnn08,g_lnn.lnn09,
                      g_lnn.lnnmodu,g_lnn.lnndate
      CALL i370_field_pic()
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION i370_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废

  IF g_lnn.lnnstore IS NULL THEN RETURN END IF
   
   SELECT * INTO g_lnn.* FROM lnn_file
    WHERE lnnstore=g_lnn.lnnstore
      AND lnn02=g_lnn.lnn02
      
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_lnn.lnn07='X' THEN RETURN END IF
    ELSE
       IF g_lnn.lnn07<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
   IF g_lnn.lnn07='Y' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_lnn.lnnacti='N' THEN CALL cl_err('','alm-004',0) RETURN END IF

   BEGIN WORK
   LET g_success = 'Y'
   
   OPEN i370_cl USING g_lnn.lnnstore,g_lnn.lnn02
   IF STATUS THEN
      CALL cl_err("OPEN i255_cl:", STATUS, 1)
      CLOSE i370_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i370_cl INTO g_lnn.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnn.lnnstore,SQLCA.sqlcode,0) 
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_lnn.lnn07) THEN
      IF g_lnn.lnn07 ='N' THEN
         LET g_lnn.lnn07='X'
      ELSE
         LET g_lnn.lnn07='N'
      END IF
      UPDATE lnn_file SET
             lnn07=g_lnn.lnn07,
             lnnmodu=g_user,
             lnndate=g_today
       WHERE lnnstore=g_lnn.lnnstore
         AND lnn02=g_lnn.lnn02
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","lnn_file",g_lnn.lnnstore,"","apm-266","","upd lnn_file",1)
         LET g_success='N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lnn.lnnstore,'V')
      DISPLAY BY NAME g_lnn.lnn07
      CALL i370_field_pic()
   ELSE
      LET g_lnn.lnn07= g_lnn_t.lnn07
      DISPLAY BY NAME g_lnn.lnn07
      ROLLBACK WORK
   END IF
 
   SELECT lnn07,lnnmodu,lnndate
     INTO g_lnn.lnn07,g_lnn.lnnmodu,g_lnn.lnndate FROM lnn_file
    WHERE lnnstore=g_lnn.lnnstore AND lnn02=g_lnn.lnn02 
 
    DISPLAY BY NAME g_lnn.lnn07,g_lnn.lnnmodu,g_lnn.lnndate
    CALL i370_field_pic()
END FUNCTION
 
FUNCTION i370_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lnn.lnnstore IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lnn.* FROM lnn_file
    WHERE lnnstore=g_lnn.lnnstore
      AND lnn02=g_lnn.lnn02
   IF g_lnn.lnnacti ='N' THEN    
      CALL cl_err(g_lnn.lnnstore,'mfg1000',0)
      RETURN
   END IF
   
   IF g_lnn.lnn07 ='Y' THEN    
      CALL cl_err(g_lnn.lnnstore,'9023',0)
      RETURN
   END IF
 
   IF g_lnn.lnn07 ='X' THEN    
      CALL cl_err(g_lnn.lnnstore,'9024',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i370_cl USING g_lnn.lnnstore,g_lnn.lnn02
   IF STATUS THEN
      CALL cl_err("OPEN i370_cl:", STATUS, 1)
      CLOSE i370_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i370_cl INTO g_lnn.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lnn.lnnstore,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i370_show()
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL             #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lnnstore"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lnn.lnnstore      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
      DELETE FROM lnn_file WHERE lnnstore=g_lnn.lnnstore
                             AND lnn02=g_lnn.lnn02
      DELETE FROM lno_file WHERE lnostore=g_lnn.lnnstore
                             AND lno02=g_lnn.lnn02
      DELETE FROM lnp_file WHERE lnpstore=g_lnn.lnnstore         #所屬區域資料
                             AND lnp02=g_lnn.lnn02
                             AND lnp03=g_lnn.lnn03
      DELETE FROM lnq_file WHERE lnqstore=g_lnn.lnnstore         #其他區域資料
                             AND lnq02=g_lnn.lnn02
      CLEAR FORM
      CALL g_lno.clear()
      OPEN i370_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i370_cs
         CLOSE i370_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      FETCH i370_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i370_cs
         CLOSE i370_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i370_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i370_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      
         CALL i370_fetch('/')
      END IF
   END IF
   CLOSE i370_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lnn.lnnstore,'D')
END FUNCTION
 
FUNCTION i370_copy()
    DEFINE
        l_newno1    LIKE lnn_file.lnnstore,
        l_newno2    LIKE lnn_file.lnn02,
        l_oldno1    LIKE lnn_file.lnnstore,
        l_oldno2    LIKE lnn_file.lnn02,
        p_cmd       LIKE type_file.chr1,
        l_n         LIKE type_file.num5,
        l_input     LIKE type_file.chr1 
 
    IF g_lnn.lnnstore IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i370_set_entry('a')
    CALL cl_set_comp_entry("lnnstore",FALSE)
    LET g_before_input_done = TRUE
    INPUT l_newno1,l_newno2 FROM lnnstore,lnn02
        BEFORE INPUT
           LET l_newno1 = g_plant
           DISPLAY l_newno1 TO lnnstore
           CALL i370_lnnstore('d')
           CALL i370_lnnlegal('d')
 
       #BEFORE FIELD lnnstore
       #   LET l_newno1 = g_plant
       #   DISPLAY l_newno1 TO lnnstore
    
       #AFTER FIELD lnnstore
       #   IF l_newno1 IS NOT NULL THEN
       #      LET l_oldno1 = g_lnn.lnnstore
       #      LET g_lnn.lnnstore=l_newno1
       #      CALL i370_lnnstore(p_cmd)
       #      LET g_lnn.lnnstore=l_oldno1
       #      IF NOT cl_null(g_errno) THEN
       #         CALL cl_err(l_newno1,g_errno,0)
       #         NEXT FIELD lnnstore
       #      END IF
       #   END IF
        
        AFTER FIELD lnn02
           IF l_newno2 IS NOT NULL THEN
              SELECT count(*) INTO l_n FROM lnn_file
                  WHERE lnnstore = l_newno1
                    AND lnn02 = l_newno2
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD lnn02
              END IF
           END IF
 
       ON ACTION controlp
        CASE
           WHEN INFIELD(lnnstore)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_rtz"
              LET g_qryparam.default1 = l_newno1
              CALL cl_create_qry() RETURNING l_newno1
              DISPLAY BY NAME l_newno1
              NEXT FIELD lnnstore
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
        DISPLAY BY NAME g_lnn.lnnstore,g_lnn.lnn02
        RETURN
    END IF
    
    DROP TABLE y
    SELECT * FROM lnn_file  
        WHERE lnnstore = g_lnn.lnnstore
          AND lnn02 = g_lnn.lnn02
        INTO TEMP y
    UPDATE y
        SET lnnstore=l_newno1,
            lnn02=l_newno2,
            lnnlegal = g_legal,
            lnn07 = 'N',
            lnn08='',
            lnn09='',
            lnnacti='Y', 
            lnnuser=g_user,
            lnngrup=g_grup, 
            lnnmodu=NULL,  
            lnndate=NULL,
            lnncrat=g_today 
      
    INSERT INTO lnn_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","lnn_file",g_lnn.lnnstore,"",SQLCA.sqlcode,"","",1)
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    
    DROP TABLE x
    SELECT * FROM lno_file WHERE lnostore = g_lnn.lnnstore
                             AND lno02 = g_lnn.lnn02
                       INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    UPDATE x SET lnostore = l_newno1,lno02 = l_newno2,lnolegal = g_legal
    INSERT INTO lno_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
    #   ROLLBACK WORK       #FUN-B80060  下移兩行
       CALL cl_err3("ins","lno_file","","",SQLCA.sqlcode,"","",1)
       ROLLBACK WORK       #FUN-B80060
       RETURN
    ELSE 
       COMMIT WORK
    END IF
 
    DROP TABLE r1   #復制所屬區域資料
    SELECT * FROM lnp_file WHERE lnpstore = g_lnn.lnnstore
                             AND lnp02 = g_lnn.lnn02
                             AND lnp03 = g_lnn.lnn03
                       INTO TEMP r1
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","r1","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    UPDATE r1 SET lnpstore = l_newno1,lnp02 = l_newno2,lnplegal = g_legal
    
    INSERT INTO lnp_file SELECT * FROM r1
    IF SQLCA.sqlcode THEN
    #   ROLLBACK WORK       #FUN-B80060  下移兩行
       CALL cl_err3("ins","lnp_file","","",SQLCA.sqlcode,"","",1)
       ROLLBACK WORK       #FUN-B80060
       RETURN
    ELSE 
       COMMIT WORK
    END IF
 
    DROP TABLE r2    #復制其他區域資料
    SELECT * FROM lnq_file WHERE lnqstore = g_lnn.lnnstore
                             AND lnq02 = g_lnn.lnn02
                       INTO TEMP r2
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","r2","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    UPDATE r2 SET lnqstore = l_newno1,lnq02 = l_newno2,lnqlegal = g_legal
    
    INSERT INTO lnq_file SELECT * FROM r2
    IF SQLCA.sqlcode THEN
    #   ROLLBACK WORK    #FUN-B80060  下移兩行
       CALL cl_err3("ins","lnq_file","","",SQLCA.sqlcode,"","",1)
       ROLLBACK WORK       #FUN-B80060
       RETURN
    ELSE 
       COMMIT WORK
    END IF
 
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE'(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
    
    LET l_oldno1 = g_lnn.lnnstore
    LET l_oldno2 = g_lnn.lnn02
    LET g_lnn.lnnstore = l_newno1
    LET g_lnn.lnn02 = l_newno2
    SELECT lnn_file.* INTO g_lnn.* FROM lnn_file
     WHERE lnnstore = l_newno1
       AND lnn02 = l_newno2
    CALL i370_u()
    CALL i370_b("a")
    UPDATE lnn_file set lnndate=NULL,lnnmodu=NULL
                    WHERE lnnstore = l_newno1
                      AND lnn02 = l_newno2
    #FUN-C30027---begin                 
    #SELECT lnn_file.* INTO g_lnn.* FROM lnn_file
    # WHERE lnnstore = l_oldno1
    #   AND lnn02 = l_oldno2
    #CALL i370_show()
    #FUN-C30027---end
END FUNCTION
 
FUNCTION i370_b_fill(p_wc2)
   DEFINE p_wc2   STRING
   LET g_sql = "SELECT lno03,lno04 FROM lno_file",
               " WHERE lnostore ='",g_lnn.lnnstore,"' ",
               "   AND lno02 ='",g_lnn.lnn02,"' "
  
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lno02 "
   DISPLAY g_sql
   PREPARE i370_pb FROM g_sql
   DECLARE lno_cs CURSOR FOR i370_pb
   CALL g_lno.clear()
   LET g_cnt = 1
   FOREACH lno_cs INTO g_lno[g_cnt].* 
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
   CALL g_lno.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i370_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lnnstore,lnn02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i370_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("lnnstore,lnn02",FALSE)
   END IF
   CALL cl_set_comp_entry("lnnstore",FALSE)
END FUNCTION
#No.FUN-960134
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore

