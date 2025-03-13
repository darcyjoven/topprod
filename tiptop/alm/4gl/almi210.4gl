# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almi210.4gl
# Descriptions...: 戰盟基本資料維護作業
# Date & Author..: FUN-870015 2008/07/07 By shiwuying
# Modify.........: No.FUN-960134 09/07/20 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/24 By shiwuying add oriu,orig
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70063 10/07/12 by chenying azf02 = '3' 抓取品牌代碼,改抓tqa_file.tqa03 = '2';
#                                                     欄位azf03改抓tqa02,azf01改抓tqa01
# Modify.........: No.FUN-A70063 10/07/14 by chenying q_azfq替換成q_tqaq_1,q_azfr替換成q_tqar
#                                                     q_lmm02替換成q_lmm02_1,q_lmn02替換成q_lmn02_1
# Modify.........: No:FUN-A70130 10/08/09 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-AA0006 10/10/12 By vealxu 重新規劃 lmm_file、lmn_file 資料檔, 檔案類別由原 T類(交易檔) 改成 B類(基本資料檔). 並取消 lmm01 取單據編號功能, 改由使用者自行輸入代號
# Modify.........: No.FUN-AA0071 10/10/29 By chenying 明確顯示錯誤訊息
# Modify.........: No.TQC-B20052 11/02/15 By lilingyu 已經終止的協議中的品牌編號,應該可以出現在新的戰盟協議中
# Modify.........: No.TQC-B30101 11/03/11 By baogc 隱藏簽核欄位,簽核狀態欄位,簽核按鈕
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80060 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode,是另外一組的,在五行以外
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30027 12/08/20 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No.FUN-D30033 13/04/12 By minpp 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lmm         RECORD LIKE lmm_file.*,
       g_lmm_t       RECORD LIKE lmm_file.*,
       g_lmm_o       RECORD LIKE lmm_file.*,
       g_lmm01_t     LIKE lmm_file.lmm01,
       g_lmn         DYNAMIC ARRAY OF RECORD
           lmn02     LIKE lmn_file.lmn02,
#           azf03     LIKE azf_file.azf03       #FUN-A70063 mark
           tqa02     LIKE tqa_file.tqa02        #FUN-A70063
                     END RECORD,
       g_lmn_t       RECORD
           lmn02     LIKE lmn_file.lmn02,
#           azf03     LIKE azf_file.azf03       #FUN-A70063 mark
           tqa02     LIKE tqa_file.tqa02        #FUN-A70063
                     END RECORD,
       g_lmn_o       RECORD 
           lmn02     LIKE lmn_file.lmn02,
#           azf03     LIKE azf_file.azf03       #FUN-A70063 mark
           tqa02     LIKE tqa_file.tqa02        #FUN-A70063 
                     END RECORD,
       g_sql,g_str   STRING,
       g_wc          STRING,
       g_wc2         STRING,
       g_rec_b       LIKE type_file.num5,
       l_ac          LIKE type_file.num5
 
DEFINE g_void              LIKE type_file.chr1 
DEFINE g_approve           LIKE type_file.chr1 
DEFINE g_confirm           LIKE type_file.chr1
DEFINE g_flag              LIKE type_file.chr1
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
DEFINE g_no_ask            LIKE type_file.num5
#DEFINE g_t1                LIKE lrk_file.lrkslip         #FUN-A70130
 DEFINE g_t1                LIKE oay_file.oayslip         #FUN-A70130
MAIN
   DEFINE cb ui.ComboBox
   
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
 
   INITIALIZE g_lmm.* TO NULL
   LET g_forupd_sql= "SELECT * FROM lmm_file WHERE lmm01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i210_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i210_w WITH FORM "alm/42f/almi210"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
##-TQC-B30101 ADD-BEGIN------
   CALL cl_set_comp_visible("lmm07,lmm08",FALSE)
   CALL cl_set_act_visible("ef_approval",FALSE)
##-TQC-B30101 ADD--END-------
 
   LET g_pdate = g_today  
 
   LET cb = ui.ComboBox.forname("lmm09")
   CALL cb.removeitem("X")
 
   LET g_action_choice=""
   CALL i210_menu()
   CLOSE WINDOW i210_w 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i210_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM 
   CALL g_lmn.clear()
   CALL cl_set_head_visible("","YES")          
   INITIALIZE g_lmm.* TO NULL      
   CONSTRUCT BY NAME g_wc ON lmm01,lmm02,lmm03,lmm04,lmm07,lmm08,
                             lmm09,lmm10,lmm11,lmm05,lmm06,lmm12,
                             lmmuser,lmmgrup,lmmoriu,lmmorig,     #No:FUN-9B0136
                             lmmmodu,lmmdate,lmmacti,lmmcrat
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(lmm01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_lmm01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmm01
                  NEXT FIELD lmm01
                  
               WHEN INFIELD(lmm02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
#                 LET g_qryparam.form = "q_lmm02"               #NO.FUN-70063
                  LET g_qryparam.form = "q_lmm02_1"             #NO.FUN-70063
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmm02
                  NEXT FIELD lmm02
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
   #      LET g_wc = g_wc clipped," AND lmmuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                     
   #      LET g_wc = g_wc clipped," AND lmmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN       
   #      LET g_wc = g_wc clipped," AND lmmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lmmuser', 'lmmgrup')
   #End:FUN-980030
 
   CONSTRUCT g_wc2 ON lmn02
              FROM s_lmn[1].lmn02
       
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
       
      ON ACTION controlp
         CASE
            WHEN INFIELD(lmn02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
#              LET g_qryparam.form = "q_lmn02"                #NO.FUN-70063
               LET g_qryparam.form = "q_lmn02_1"                #NO.FUN-70063
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmn02
               NEXT FIELD lmn02
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
  
   IF g_wc2 = " 1=1" THEN              
      LET g_sql = "SELECT lmm01",
                  " FROM lmm_file WHERE ", g_wc CLIPPED,
                  " ORDER BY lmm01"
   ELSE                              
      LET g_sql = "SELECT UNIQUE lmm01",
                  "  FROM lmm_file, lmn_file ",
                  " WHERE lmm01 = lmn01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lmm01"
   END IF
 
   PREPARE i210_prepare FROM g_sql
   DECLARE i210_cs SCROLL CURSOR WITH HOLD FOR i210_prepare
   IF g_wc2 = " 1=1" THEN           
      LET g_sql="SELECT COUNT(*) FROM lmm_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lmm01) FROM lmm_file,lmn_file",
                " WHERE lmm01 = lmn01",
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i210_precount FROM g_sql
   DECLARE i210_count CURSOR FOR i210_precount
END FUNCTION
 
FUNCTION i210_menu()
# DEFINE l_lrkdmy2 LIKE lrk_file.lrkdmy2             #FUN-A70130
  DEFINE l_oayconf LIKE oay_file.oayconf             #FUN-A70130
 
   WHILE TRUE
      CALL i210_bp("G")
      CASE g_action_choice
         
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i210_q()
            END IF
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i210_a()
               LET g_t1=s_get_doc_no(g_lmm.lmm01)
               #單別設置里有維護單別，則找出是否需要自動審核
               IF NOT cl_null(g_t1) THEN
#FUN-A70130 ---------------------start-----------------------
#                  SELECT lrkdmy2
#                    INTO l_lrkdmy2
#                    FROM lrk_file
#                   WHERE lrkslip = g_t1
#                  #需要自動審核，則調用審核段
#                  IF l_lrkdmy2 = 'Y' THEN
#                     #自動審核傳2
             SELECT oayconf INTO l_oayconf FROM oay_file
                WHERE oayslip = g_t1
             IF l_oayconf = 'Y' THEN
#FUN-A70130-----------------------end-------------------------
                     CALL i210_y()
                  END IF
               END IF
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i210_u()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i210_r()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i210_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i210_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i210_b("u")
            ELSE
               LET g_action_choice=NULL
            END IF
         
         WHEN "ef_approval"
            IF cl_chk_act_auth() THEN
               CALL i210_ef()
            END IF
 
         WHEN "confirm" 
            IF cl_chk_act_auth() THEN
               CALL i210_y()
            END IF 
 
         WHEN "undo_confirm"      
            IF cl_chk_act_auth() THEN
               CALL i210_z()
            END IF
    
         WHEN "termination"
            IF cl_chk_act_auth() THEN
               CALL i210_t()
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i210_out()
            END IF
        
        #WHEN "void"
        #   IF cl_chk_act_auth() THEN
        #      CALL i210_v()
        #   END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lmn),'','')
            END IF
        
         WHEN "related_document"
              IF cl_chk_act_auth() THEN
                 IF g_lmm.lmm01 IS NOT NULL THEN
                 LET g_doc.column1 = "lmm01"
                 LET g_doc.value1 = g_lmm.lmm01
                 CALL cl_doc()
               END IF
         END IF
       END CASE
   END WHILE
END FUNCTION
 
FUNCTION i210_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lmn TO s_lmn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL i210_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL i210_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION jump
         CALL i210_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL i210_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION last
         CALL i210_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION ef_approval 
         LET g_action_choice="ef_approval"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
  
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
     #ON ACTION void
     #   LET g_action_choice="void"
     #   EXIT DISPLAY
 
      ON ACTION termination
         LET g_action_choice="termination"
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
 
FUNCTION i210_a()
 DEFINE li_result   LIKE type_file.num5
 
    MESSAGE ""
    CLEAR FORM
    CALL g_lmn.clear()
    LET g_wc = NULL
    LET g_wc2 = NULL
    
    IF s_shut(0) THEN
       RETURN
    END IF
    INITIALIZE g_lmm.* LIKE lmm_file.*
    LET g_lmm01_t = NULL
    LET g_lmm_t.* = g_lmm.*
    LET g_lmm_o.* = g_lmm.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lmm.lmm04 = g_today
        LET g_lmm.lmm07 = 'N'
        LET g_lmm.lmm08 = '0'
        LET g_lmm.lmm09 = 'N'
        LET g_lmm.lmmuser = g_user
        LET g_lmm.lmmoriu = g_user #FUN-980030
        LET g_lmm.lmmorig = g_grup #FUN-980030
        LET g_lmm.lmmgrup = g_grup 
        LET g_lmm.lmmacti = 'Y'
        LET g_lmm.lmmcrat = g_today
        CALL i210_i("a") 
        IF INT_FLAG THEN 
            INITIALIZE g_lmm.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_lmm.lmm01 IS NULL THEN 
            CONTINUE WHILE
        END IF
        
        BEGIN WORK
        #FUN-AA0006 -----------------------mark start--------------------------
        #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
        ##CALL s_auto_assign_no("alm",g_lmm.lmm01,g_today,'14',"lmm_file","lmm01","","","") #FUN-A70130
        #CALL s_auto_assign_no("alm",g_lmm.lmm01,g_today,'L3',"lmm_file","lmm01","","","") #FUN-A70130        
        #   RETURNING li_result,g_lmm.lmm01                                                            
        #IF (NOT li_result) THEN
        #   CONTINUE WHILE
        #END IF
        #DISPLAY BY NAME g_lmm.lmm01
        #FUN-AA0006 ----------------------mark end----------------------------

        INSERT INTO lmm_file VALUES(g_lmm.*)
        IF SQLCA.sqlcode THEN
        #   ROLLBACK WORK           #FUN-B80060  下移兩行
           CALL cl_err3("ins","lmm_file",g_lmm.lmm01,"",SQLCA.sqlcode,"","",0)
           ROLLBACK WORK            #FUN-B80060
           CONTINUE WHILE
        ELSE
           COMMIT WORK
        END IF
        SELECT * INTO g_lmm.* FROM lmm_file
                    WHERE lmm01 = g_lmm.lmm01
        LET g_lmm01_t = g_lmm.lmm01
        LET g_lmm_t.* = g_lmm.*
        LET g_lmm_o.* = g_lmm.*
 
        CALL g_lmn.clear()
        LET g_rec_b = 0
        CALL i210_b("a")
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i210_u()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_lmm.lmm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lmm.* FROM lmm_file
    WHERE lmm01 = g_lmm.lmm01
      
   IF g_lmm.lmmacti ='N' THEN
      CALL cl_err(g_lmm.lmm01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_lmm.lmm09 ='S' THEN 
      CALL cl_err(g_lmm.lmm01,'alm-052',0)
      RETURN
   END IF
   
   IF g_lmm.lmm09='Y' THEN
      CALL cl_err(g_lmm.lmm09,'9003',0)
      RETURN
   END IF
 
   IF g_lmm.lmm09='X' THEN
      CALL cl_err(g_lmm.lmm09,'9024',0)
      RETURN
   END IF
 
#   IF g_lmm.lmm08 matches '[Ss1]' THEN
#      CALL cl_err('','mfg3557',0)
#      RETURN
#   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
      
   BEGIN WORK
   OPEN i210_cl USING g_lmm.lmm01
   IF STATUS THEN
      CALL cl_err("OPEN i210_cl:", STATUS, 1)
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i210_cl INTO g_lmm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmm.lmm01,SQLCA.sqlcode,0)
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i210_show()
   WHILE TRUE
      LET g_lmm01_t = g_lmm.lmm01
      LET g_lmm_o.* = g_lmm.*
      LET g_lmm.lmmmodu=g_user
      LET g_lmm.lmmdate=g_today
      LET g_flag = 'N'
      CALL i210_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lmm.*=g_lmm_t.*
         CALL i210_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lmm.lmm08 MATCHES '[SsWwRr1]' THEN
         LET g_lmm.lmm08 = '0'
      END IF
 
      IF g_lmm01_t <> g_lmm.lmm01 THEN
         UPDATE lmn_file SET lmn01 = g_lmm.lmm01
          WHERE lmn01 = g_lmm.lmm01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lmm_file","","",SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE lmm_file SET lmm_file.* = g_lmm.*
       WHERE lmm01 = g_lmm.lmm01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lmm_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i210_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lmm.lmm01,'U')
   CALL i210_show()
   IF g_flag = 'Y' THEN
      CALL i210_b('u')
   END IF
   CALL i210_b_fill("1=1")
END FUNCTION
 
FUNCTION i210_i(p_cmd)
 DEFINE l_n       LIKE type_file.num5,
        l_input   LIKE type_file.chr1,    
        p_cmd     LIKE type_file.chr1     
 DEFINE li_result LIKE type_file.num5    
 DEFINE l_count   LIKE type_file.num5          #FUN-AA0006 add	 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lmm.lmmoriu,g_lmm.lmmorig,g_lmm.lmm04,g_lmm.lmm05,g_lmm.lmm06,g_lmm.lmm07,
                   g_lmm.lmm08,g_lmm.lmm09,g_lmm.lmmuser,g_lmm.lmmmodu,
                   g_lmm.lmmgrup,g_lmm.lmmdate,g_lmm.lmmacti,g_lmm.lmmcrat
 
   CALL cl_set_head_visible("","YES")          
   INPUT BY NAME g_lmm.lmm01,g_lmm.lmm02,g_lmm.lmm04,g_lmm.lmm07,g_lmm.lmm12 
                 WITHOUT DEFAULTS
 
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i210_set_entry(p_cmd)
        CALL i210_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
     #  CALL cl_set_docno_format("lmm01")                  #FUN-AA0006 mark
 
     AFTER FIELD lmm01
        #FUN-AA0006 -------------------------mod start----------------------
        ##單號處理方式:
        ##在輸入單別後, 至單據性質檔中讀取該單別資料;
        ##若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
        ##若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
        #IF NOT cl_null(g_lmm.lmm01) THEN
        #   #CALL s_check_no("alm",g_lmm.lmm01,g_lmm01_t,'14',"lmm_file","lmm01","") #FUN-A70130
        #    CALL s_check_no("alm",g_lmm.lmm01,g_lmm01_t,'L3',"lmm_file","lmm01","") #FUN-A70130
        #        RETURNING li_result,g_lmm.lmm01
        #   IF (NOT li_result) THEN
        #      LET g_lmm.lmm01=g_lmm_o.lmm01
        #      NEXT FIELD lmm01
        #   END IF
        #   DISPLAY BY NAME g_lmm.lmm01
        #END IF
        LET l_count = 0
        IF NOT cl_null(g_lmm.lmm01) THEN
           IF p_cmd = 'a' OR ( p_cmd = 'u' AND g_lmm.lmm01 != g_lmm_t.lmm01) THEN  
              SELECT count(*) INTO l_count FROM lmm_file WHERE lmm01 = g_lmm.lmm01
              IF l_count > 0 THEN
                 CALL cl_err('','-239',0)
                 LET g_lmm.lmm01=g_lmm_o.lmm01  
                 NEXT FIELD lmm01
              END IF 
              DISPLAY BY NAME g_lmm.lmm01    
           END IF      
        END IF
        #FUN-AA0006 ------------------------mod end---------------------------       
 
      AFTER FIELD lmm02
         IF g_lmm.lmm02  IS NOT NULL THEN
            IF g_lmm.lmm02 != g_lmm_o.lmm02
                 OR g_lmm_o.lmm02 IS NULL THEN
                 CALL i210_lmm02(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_lmm.lmm02,g_errno,1)
                    LET g_lmm.lmm02 = g_lmm_o.lmm02
                    NEXT FIELD lmm02
                 END IF
              END IF
            IF g_lmm.lmm02 <> g_lmm_o.lmm02 AND p_cmd = 'u' THEN
               IF cl_confirm('alm-382') THEN
                  DELETE FROM lmn_file WHERE lmn01 = g_lmm.lmm01
                  LET g_flag = 'Y'
                  LET g_lmm_o.lmm02 = g_lmm.lmm02
               ELSE 
                  LET g_lmm.lmm02 = g_lmm_o.lmm02
                  DISPLAY BY NAME g_lmm.lmm02
               END IF
            END IF
         END IF     
 
#     AFTER FIELD lmm04
#        IF NOT cl_null(g_lmm.lmm04) THEN 
#           IF g_lmm.lmm04 > g_today THEN
#              CALL cl_err(g_lmm.lmm04,'alm-072',0)
#              NEXT FIELD lmm04
#           END IF
#        END IF
    
     ON ACTION controlp
        CASE
           WHEN INFIELD(lmm01)                                        
         #     LET g_t1=s_get_doc_no(g_lmm.lmm01)                                              #FUN-AA0006 mark
         #   #  CALL q_lrk(FALSE,FALSE,g_t1,'14','ALM') RETURNING g_t1    # FUN-A70130 mark    #FUN-AA0006 mark
         #     CALL q_oay(FALSE,FALSE,g_t1,'L3','ALM') RETURNING g_t1    # FUN-A70130 add      #FUN-AA0006 mark 
         #     LET g_lmm.lmm01 = g_t1                                                          #FUN-AA0006 mark
         #     DISPLAY BY NAME g_lmm.lmm01                                                     #FUN-AA0006 mark
         #     NEXT FIELD lmm01                                                                #FUN-AA0006 mark 
            
           WHEN INFIELD(lmm02)
              CALL cl_init_qry_var()
#             LET g_qryparam.form="q_azfr"              #FUN-A70063 mark
              LET g_qryparam.form="q_tqar"              #FUN-A70063
              LET g_qryparam.default1 =g_lmm.lmm02
              CALL cl_create_qry() RETURNING g_lmm.lmm02
              DISPLAY BY NAME g_lmm.lmm02
              NEXT FIELD lmm02
           OTHERWISE EXIT CASE
        END CASE       
           
      ON ACTION CONTROLO                 
         IF INFIELD(lmm01) THEN
            LET g_lmm.* = g_lmm_t.*
            CALL i210_show()
            NEXT FIELD lmm01
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
 
FUNCTION i210_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lmn.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i210_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lmm.* TO NULL
      RETURN
   END IF
 
   OPEN i210_cs                            
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lmm.* TO NULL
   ELSE
      OPEN i210_count
      FETCH i210_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i210_fetch('F')
   END IF
END FUNCTION
 
FUNCTION i210_fetch(p_flag)
DEFINE         p_flag         LIKE type_file.chr1                 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i210_cs INTO g_lmm.lmm01
      WHEN 'P' FETCH PREVIOUS i210_cs INTO g_lmm.lmm01
      WHEN 'F' FETCH FIRST    i210_cs INTO g_lmm.lmm01
      WHEN 'L' FETCH LAST     i210_cs INTO g_lmm.lmm01
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
          FETCH ABSOLUTE g_jump i210_cs INTO g_lmm.lmm01
          LET g_no_ask = FALSE    
     END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmm.lmm01,SQLCA.sqlcode,0)
      INITIALIZE g_lmm.* TO NULL               
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
 
   SELECT * INTO g_lmm.* FROM lmm_file WHERE lmm01 = g_lmm.lmm01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lmm_file","","",SQLCA.sqlcode,"","",1) 
      INITIALIZE g_lmm.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lmm.lmmuser      
   LET g_data_group = g_lmm.lmmgrup      
   CALL i210_show()
END FUNCTION
 
FUNCTION i210_show()
   LET g_lmm_t.* = g_lmm.* 
   LET g_lmm_o.* = g_lmm.*
   DISPLAY BY NAME g_lmm.lmm01,g_lmm.lmm02,g_lmm.lmm03,g_lmm.lmm04,g_lmm.lmm05, g_lmm.lmmoriu,g_lmm.lmmorig,
                   g_lmm.lmm06,g_lmm.lmm07,g_lmm.lmm08,g_lmm.lmm09,g_lmm.lmm10,
                   g_lmm.lmm11,g_lmm.lmm12,g_lmm.lmmuser,g_lmm.lmmmodu,
                   g_lmm.lmmgrup,g_lmm.lmmdate,g_lmm.lmmacti,g_lmm.lmmcrat
   CALL i210_lmm02('d')
   CALL i210_b_fill(g_wc2)
   CALL i210_field_pic() 
   CALL cl_show_fld_cont()  
END FUNCTION
 
FUNCTION i210_field_pic()
     LET g_void=NULL
     LET g_approve=NULL
     LET g_confirm=NULL
     IF g_lmm.lmm09 MATCHES '[Yy]' THEN
        IF g_lmm.lmm08 MATCHES '[SsRrWw0]' THEN
           LET g_confirm='Y'
           LET g_approve='N'
           LET g_void='N'
        END IF
        IF g_lmm.lmm08 MATCHES '[1]' THEN
           LET g_confirm='Y'
           LET g_approve='Y'
           LET g_void='N'
        END IF
     ELSE
        IF g_lmm.lmm09 ='X' THEN
           LET g_confirm='N'
           LET g_approve='N'
           LET g_void='Y'
        ELSE
           LET g_confirm='N'
           LET g_approve='N'
           LET g_void='N'
        END IF
     END IF
     CALL cl_set_field_pic(g_confirm,g_approve,"","",g_void,g_lmm.lmmacti)
END FUNCTION
 
FUNCTION i210_lmm02(p_cmd)  
#  DEFINE l_azf16     LIKE azf_file.azf16                   #FUN-A70063 mark
#  DEFINE l_azf17     LIKE azf_file.azf17                   #FUN-A70063 mark
   DEFINE l_tqa02_n2  LIKE tqa_file.tqa02                   #FUN-A70063 
   DEFINE p_cmd       LIKE type_file.chr1 
   DEFINE l_cnt       LIKE type_file.num5
#  DEFINE l_azfacti   LIKE azf_file.azfacti                 #FUN-A70063 mark
   DEFINE l_tqaacti   LIKE tqa_file.tqaacti                 #FUN-A70063 
   LET g_errno=''

  #NO.FUN-A70063---begin
  #SELECT DISTINCT azf17,azfacti INTO l_azf17,l_azfacti
  #  FROM azf_file
  # WHERE azf16=g_lmm.lmm02
  #    AND azf02 = '3'
   SELECT DISTINCT tqa02,tqaacti INTO l_tqa02_n2,l_tqaacti  
     FROM tqa_file                                     
    WHERE tqa01=g_lmm.lmm02
       AND tqa03='28'          
  #NO.FUN-A70063---end
  

   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-047'
                               LET l_tqa02_n2 = NULL        #FUN-A70063
#                              LET l_azf17=NULL             #FUN-A70063 mark
#       WHEN l_azfacti='N'     LET g_errno='9028'           #FUN-A70063 mark
        WHEN l_tqaacti='N'     LET g_errno='9028'           #FUN-A70063
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
   IF g_errno = '9028' THEN
#     SELECT COUNT(*) INTO l_cnt FROM azf_file              #FUN-A70063 mark   
#      WHERE azf16 = g_lmm.lmm02                            #FUN-A70063 mark
#        AND azfacti = 'Y'                                  #FUN-A70063 mark
#        AND azf02 = '3'                                    #FUN-A70063 mark
      #NO.FUN-A70063---begin
      SELECT COUNT(*) INTO l_cnt FROM tqa_file              
       WHERE tqa01 = g_lmm.lmm02                           
         AND tqaacti = 'Y'                                
         AND tqa03 = '28'                                
      #NO.FUN-A70063---end 

     IF l_cnt > 0 THEN
         LET g_errno = ''
      END IF
   END IF
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
#     DISPALY l_azf17 TO FORMONLY.azf17                     #FUN-A70063 mark
      DISPLAY l_tqa02_n2 TO FORMONLY.tqa02_n2               #FUN-A70063 
   END IF
END FUNCTION
 
 
FUNCTION i210_lmn02(p_cmd) 
#  DEFINE l_azf03   LIKE azf_file.azf03,                    #FUN-A70063 mark
#         l_azf16   LIKE azf_file.azf16,                    #FUN-A70063 mark
   DEFINE l_tqa02   LIKE tqa_file.tqa02,                    #FUN-A70063 
          l_tqa01   LIKE tqa_file.tqa01,                    #FUN-A70063
          l_tqa08   LIKE tqa_file.tqa08,                    #FUN-A70063
          p_cmd     LIKE type_file.chr1, 
#         l_azfacti LIKE azf_file.azfacti                   #FUN-A70063 mark
          l_tqaacti LIKE tqa_file.tqaacti                   #FUN-A70063 
   DEFINE l_cnt     LIKE type_file.num5
 
   LET g_errno=''
 
#  SELECT azf03,azf16,azfacti INTO l_azf03,l_azf16,l_azfacti #FUN-A70063 mark
#    FROM azf_file                                           #FUN-A70063 mark
#   WHERE azf01=g_lmn[l_ac].lmn02                            #FUN-A70063 mark
#     AND azf02 = '3'                                        #FUN-A70063 mark
   #NO.FUN-A70063---begin
   SELECT * FROM tqa_file WHERE tqa01=g_lmn[l_ac].lmn02 AND tqa03 = '2'
   IF SQLCA.sqlcode=100 THEN
      LET g_errno='alm1002'
      LET l_tqa02=NULL   
   ELSE
      #FUN-AA0071----------add---------------str---------
      SELECT COUNT(*) INTO l_cnt FROM tqa_file
        WHERE tqa01 = g_lmn[l_ac].lmn02 AND tqa03 = '2' AND tqa08 = g_lmm.lmm02
        IF l_cnt = 0 THEN 
           LET g_errno='alm1015'
           LET l_tqa02=NULL
        ELSE
      #FUN-AA0071---------add--------------end-------  
          SELECT DISTINCT tqa02,tqa01,tqa08,tqaacti INTO l_tqa02,l_tqa01,l_tqa08,l_tqaacti FROM tqa_file
            WHERE tqa01=g_lmn[l_ac].lmn02 AND tqa03 = '2'
              AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
              OR  (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))  
          CASE WHEN  SQLCA.sqlcode=100  LET g_errno='alm1004'
                                        LET l_tqa02=NULL
               WHEN l_tqaacti='N'       LET g_errno='9028'
               WHEN l_tqa08 != g_lmm.lmm02 OR cl_null(l_tqa08) 
                                        LET g_errno='alm-071'

         OTHERWISE                LET g_errno=SQLCA.SQLCODE USING '-------'
       END CASE
       END IF  #FUN-AA0071  add
   END IF
                                  
   #NO.FUN-A70063---end
   IF cl_null(g_errno) THEN
      SELECT COUNT(*) INTO l_cnt FROM lmn_file,lmm_file          #TQC-B20052 add lmm_file
       WHERE lmn02 = g_lmn[l_ac].lmn02
         AND lmn01 <> g_lmm.lmm01
         AND lmm01 = lmn01                                       #TQC-B20052 add
         AND lmm09 <> 'S'                                        #TQC-B20052
      IF l_cnt > 0 THEN
         LET g_errno = 'alm-435'
      END IF
   END IF
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      LET g_lmn[l_ac].tqa02 = l_tqa02
      DISPLAY BY NAME g_lmn[l_ac].tqa02
   END IF
END FUNCTION
 
 
FUNCTION i210_b(p_c)
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    p_c             LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
 
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE  i1       LIKE type_file.num5
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_lmm.lmm01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_lmm.* FROM lmm_file
     WHERE lmm01=g_lmm.lmm01
 
    IF g_lmm.lmmacti ='N' THEN 
       CALL cl_err(g_lmm.lmm01,'mfg1000',0)
       RETURN
    END IF
 
    IF g_lmm.lmm09 ='S' THEN    
       CALL cl_err(g_lmm.lmm01,'alm-052',0)
       RETURN
    END IF
 
    IF g_lmm.lmm09='Y' THEN            #眒機瞄, 祥褫黨蜊訧蹋!
       CALL cl_err(g_lmm.lmm09,'9003',0)
       RETURN
    END IF
 
    IF g_lmm.lmm09='X' THEN             #釬煙, 祥褫黨蜊訧蹋!
       CALL cl_err(g_lmm.lmm09,'9024',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT lmn02,''",
                       "  FROM lmn_file",
                       " WHERE lmn01=? AND lmn02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i210_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_lmn WITHOUT DEFAULTS FROM s_lmn.*
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
 
           OPEN i210_cl USING g_lmm.lmm01
           IF STATUS THEN
              CALL cl_err("OPEN i210_cl:", STATUS, 1)
              CLOSE i210_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i210_cl INTO g_lmm.* 
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lmm.lmm01,SQLCA.sqlcode,0) 
              CLOSE i210_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lmn_t.* = g_lmn[l_ac].*  #BACKUP
              LET g_lmn_o.* = g_lmn[l_ac].*  #BACKUP
              OPEN i210_bcl USING g_lmm.lmm01,g_lmn_t.lmn02
              IF STATUS THEN
                 CALL cl_err("OPEN i210_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i210_bcl INTO g_lmn[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lmn_t.lmn02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i210_lmn02('d')
              END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lmn[l_ac].* TO NULL
           LET g_lmn_t.* = g_lmn[l_ac].* 
           LET g_lmn_o.* = g_lmn[l_ac].* 
           CALL cl_show_fld_cont()
           NEXT FIELD lmn02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO lmn_file(lmn01,lmn02)
           VALUES(g_lmm.lmm01,g_lmn[l_ac].lmn02)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lmn_file",g_lmm.lmm01,g_lmn[l_ac].lmn02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        
        AFTER FIELD lmn02 
           IF NOT cl_null(g_lmn[l_ac].lmn02) THEN
              IF g_lmn[l_ac].lmn02 != g_lmn_t.lmn02
                 OR g_lmn_t.lmn02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM lmn_file
                  WHERE lmn01 = g_lmm.lmm01
                    AND lmn02 = g_lmn[l_ac].lmn02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lmn[l_ac].lmn02 = g_lmn_t.lmn02
                    NEXT FIELD lmn02
                 END IF
                 CALL i210_lmn02(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_lmn[l_ac].lmn02,g_errno,1)
                    LET g_lmn[l_ac].lmn02 = g_lmn_t.lmn02
                    NEXT FIELD lmn02
                 END IF
              END IF
           END IF
 
        BEFORE DELETE 
           DISPLAY "BEFORE DELETE"
           IF g_lmn_t.lmn02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lmn_file
               WHERE lmn01 = g_lmm.lmm01
                 AND lmn02 = g_lmn_t.lmn02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lmn_file",g_lmm.lmm01,g_lmn_t.lmn02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_lmn[l_ac].* = g_lmn_t.*
              CLOSE i210_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lmn[l_ac].lmn02,-263,1)
              LET g_lmn[l_ac].* = g_lmn_t.*
           ELSE
              UPDATE lmn_file SET lmn02=g_lmn[l_ac].lmn02
               WHERE lmn01=g_lmm.lmm01
                 AND lmn02=g_lmn_t.lmn02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lmn_file",g_lmm.lmm01,g_lmn_t.lmn02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_lmn[l_ac].* = g_lmn_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac    #FUN-D30033
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lmn[l_ac].* = g_lmn_t.*
              #FUN-D30033----add--str
              ELSE
                 CALL g_lmn.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033---add--end
              END IF
              CLOSE i210_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D30033
           CLOSE i210_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(lmn02) AND l_ac > 1 THEN
              LET g_lmn[l_ac].* = g_lmn[l_ac-1].*
              LET g_lmn[l_ac].lmn02 = g_rec_b + 1
              NEXT FIELD lmn02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(lmn02)
               CALL cl_init_qry_var()
#              LET g_qryparam.form ="q_azfq"              #NO.FUN-A70063 mark
               LET g_qryparam.form ="q_tqaq_1"             #NO.FUN-A70063
               LET g_qryparam.arg1 = g_lmm.lmm02
               LET g_qryparam.arg2 = g_lmm.lmm01
               LET g_qryparam.default1 = g_lmn[l_ac].lmn02
               CALL cl_create_qry() RETURNING g_lmn[l_ac].lmn02
               DISPLAY BY NAME g_lmn[l_ac].lmn02
               CALL i210_lmn02('d')
               NEXT FIELD lmn02
               OTHERWISE EXIT CASE
            END CASE
 
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
       LET g_lmm.lmmmodu = g_user
       LET g_lmm.lmmdate = g_today
       LET g_lmm.lmm08 = '0'
       UPDATE lmm_file SET lmmmodu = g_lmm.lmmmodu,lmmdate = g_lmm.lmmdate,
                           lmm08 = '0'
        WHERE lmm01 = g_lmm.lmm01
       DISPLAY BY NAME g_lmm.lmmmodu,g_lmm.lmmdate,g_lmm.lmm08
    END IF
 
    CLOSE i210_bcl
    COMMIT WORK
    
#CHI-C30002 -------- mark -------- begin
#   SELECT COUNT(*) INTO g_cnt FROM lmn_file
#    WHERE lmn01 = g_lmm.lmm01 
#   IF g_cnt = 0 THEN
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM lmm_file WHERE lmm01 = g_lmm.lmm01
#   END IF
#CHI-C30002 -------- mark -------- end
    CALL i210_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i210_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM lmm_file WHERE lmm01 = g_lmm.lmm01
         INITIALIZE g_lmm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION i210_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lmm.lmm01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lmm.* FROM lmm_file
    WHERE lmm01=g_lmm.lmm01
   
   IF g_lmm.lmm09 ='S' THEN    
      CALL cl_err(g_lmm.lmm01,'alm-052',0)
      RETURN
   END IF
   
   IF g_lmm.lmm09='X' THEN
      CALL cl_err('','9024',0) 
      RETURN 
   END IF
   
   IF g_lmm.lmm09='Y' THEN
      CALL cl_err('','9023',0) 
      RETURN 
   END IF
    
   IF g_lmm.lmm08 MATCHES '[Ss1]' THEN
      CALL cl_err('','mfg3557',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i210_cl USING g_lmm.lmm01
   IF STATUS THEN
      CALL cl_err("OPEN i210_cl:", STATUS, 1)
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i210_cl INTO g_lmm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmm.lmm01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   LET g_success = 'Y'
   CALL i210_show()
   IF cl_exp(0,0,g_lmm.lmmacti) THEN
      LET g_chr=g_lmm.lmmacti
      IF g_lmm.lmmacti='Y' THEN
         LET g_lmm.lmmacti='N'
      ELSE
         LET g_lmm.lmmacti='Y'
      END IF
 
      UPDATE lmm_file SET lmmacti=g_lmm.lmmacti,
                          lmmmodu=g_user,
                          lmmdate=g_today
       WHERE lmm01=g_lmm.lmm01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lmm_file",g_lmm.lmm01,"",SQLCA.sqlcode,"","",1)
         LET g_lmm.lmmacti=g_chr
      END IF
   END IF
   CLOSE i210_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lmm.lmm01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT lmmacti,lmmmodu,lmmdate
     INTO g_lmm.lmmacti,g_lmm.lmmmodu,g_lmm.lmmdate FROM lmm_file
    WHERE lmm01 = g_lmm.lmm01
   DISPLAY BY NAME g_lmm.lmmacti,g_lmm.lmmmodu,g_lmm.lmmdate
   CALL i210_field_pic()
END FUNCTION
 
FUNCTION i210_y()
   DEFINE l_lmn02 LIKE lmn_file.lmn02
   IF cl_null(g_lmm.lmm01) THEN 
        CALL cl_err('','-400',0) 
        RETURN 
   END IF
   
#CHI-C30107 -------------- add ---------------- begin
   IF g_lmm.lmmacti='N' THEN       #拸虴
        CALL cl_err('','alm-048',0)
        RETURN
   END IF

   IF g_lmm.lmm09 ='S' THEN
      CALL cl_err(g_lmm.lmm01,'alm-052',0)
      RETURN
   END IF

   IF g_lmm.lmm09='Y' THEN #眒機瞄
        CALL cl_err('','9023',0)
        RETURN
   END IF

   IF g_lmm.lmm09='X' THEN #眒釬煙
        CALL cl_err('','9024',0)
        RETURN
   END IF

  IF NOT cl_confirm('alm-006') THEN
     RETURN
  END IF
#CHI-C30107 -------------- add ---------------- end
   SELECT * INTO g_lmm.* FROM lmm_file
    WHERE lmm01=g_lmm.lmm01
#CHI-C30107 -------------- add ---------------- begin
   IF cl_null(g_lmm.lmm01) THEN
        CALL cl_err('','-400',0)
        RETURN
   END IF
#CHI-C30107 -------------- add ---------------- end
      
   IF g_lmm.lmmacti='N' THEN       #拸虴
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
   
   IF g_lmm.lmm09 ='S' THEN    
      CALL cl_err(g_lmm.lmm01,'alm-052',0)
      RETURN
   END IF
   
   IF g_lmm.lmm09='Y' THEN #眒機瞄
        CALL cl_err('','9023',0)
        RETURN
   END IF
   
   IF g_lmm.lmm09='X' THEN #眒釬煙
        CALL cl_err('','9024',0)
        RETURN
   END IF
 
  # IF g_lmm.lmm08 != '1' THEN
  #    CALL cl_err('','alm-029',0)  
  #    RETURN
  # END IF
#CHI-C30107 -------------- mark ---------------- begin 
#  IF NOT cl_confirm('alm-006') THEN 
#     RETURN
#  END IF
#CHI-C30107 -------------- mark ---------------- end
   
   BEGIN WORK
   LET g_success = 'Y'
   
   OPEN i210_cl USING g_lmm.lmm01
   IF STATUS THEN
      CALL cl_err("OPEN i210_cl:", STATUS, 1)
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i210_cl INTO g_lmm.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmm.lmm01,SQLCA.sqlcode,0)      
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE lmm_file SET lmm09 = 'Y',lmm10 = g_user,lmm11 = g_today
    WHERE lmm01 = g_lmm.lmm01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lmm_file",g_lmm.lmm01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_sql = "SELECT lmn02 FROM lmn_file",
                  " WHERE lmn01 ='",g_lmm.lmm01,"' ",
                  " ORDER BY lmn02 "
      DISPLAY g_sql
      PREPARE i210_pb1 FROM g_sql
      DECLARE lmn_cs1 CURSOR FOR i210_pb1
      FOREACH lmn_cs1 INTO l_lmn02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         UPDATE lne_file SET lne31 = 'Y' WHERE lne08=l_lmn02
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lme_file",l_lmn02,"",STATUS,"","",1) 
            LET g_success = 'N'
         END IF
      END FOREACH
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_lmm.lmm09 = 'Y'
      LET g_lmm.lmm10 = g_user
      LET g_lmm.lmm11 = g_today
      DISPLAY BY NAME g_lmm.lmm09,g_lmm.lmm10,g_lmm.lmm11
      CALL i210_field_pic()
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION i210_z()
   DEFINE l_lmn02 LIKE lmn_file.lmn02
   IF cl_null(g_lmm.lmm01) THEN 
        CALL cl_err('','-400',0) 
        RETURN 
   END IF
   
   SELECT * INTO g_lmm.* FROM lmm_file
    WHERE lmm01=g_lmm.lmm01
   
   IF g_lmm.lmmacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
   
   IF g_lmm.lmm09 ='S' THEN    
      CALL cl_err(g_lmm.lmm01,'alm-052',0)
      RETURN
   END IF
   
   IF g_lmm.lmm09='X' THEN 
        CALL cl_err('','9024',0)
        RETURN
   END IF
   
   IF g_lmm.lmm09='N' THEN 
        CALL cl_err('','9025',0)
        RETURN
   END IF
   
   IF NOT cl_confirm('alm-008') THEN 
      RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i210_cl USING g_lmm.lmm01
   IF STATUS THEN
      CALL cl_err("OPEN i210_cl:", STATUS, 1)
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i210_cl INTO g_lmm.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmm.lmm01,SQLCA.sqlcode,0)      
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   #UPDATE lmm_file SET lmm09 = 'N',lmm10 = '',lmm11 = '',          #CHI-D20015 mark
   UPDATE lmm_file SET lmm09 = 'N',lmm10 = g_user,lmm11 = g_today,   #CHI-D20015 add
                       lmmmodu = g_user,lmmdate = g_today
    WHERE lmm01 = g_lmm.lmm01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lmm_file",g_lmm.lmm01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_sql = "SELECT lmn02 FROM lmn_file",
                  " WHERE lmn01 ='",g_lmm.lmm01,"' ",
                  " ORDER BY lmn02 "
      DISPLAY g_sql
      PREPARE i210_pb2 FROM g_sql
      DECLARE lmn_cs2 CURSOR FOR i210_pb2
      FOREACH lmn_cs2 INTO l_lmn02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         UPDATE lne_file SET lne31 = 'N' WHERE lne08=l_lmn02
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lme_file",l_lmn02,"",STATUS,"","",1) 
            LET g_success = 'N'
         END IF
      END FOREACH
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_lmm.lmm09 = 'N'
      #CHI-D20015--modify--str--
      #LET g_lmm.lmm10 = ''
      #LET g_lmm.lmm11 = ''
      LET g_lmm.lmm10 = g_user
      LET g_lmm.lmm11 = g_today 
      #CHI-D20015--modify--str--
      LET g_lmm.lmmmodu = g_user
      LET g_lmm.lmmdate = g_today
      DISPLAY BY NAME g_lmm.lmm09,g_lmm.lmm10,g_lmm.lmm11,g_lmm.lmmmodu,g_lmm.lmmdate
      CALL i210_field_pic()
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION i210_ef()
   IF cl_null(g_lmm.lmm01) THEN 
      CALL cl_err('','-400',0) 
      RETURN 
   END IF
   
   SELECT * INTO g_lmm.* FROM lmm_file
    WHERE lmm01=g_lmm.lmm01
   
   IF g_lmm.lmmacti='N' THEN
      CALL cl_err('','alm-131',0)
      RETURN
   END IF
   
   IF g_lmm.lmm09 ='S' THEN    
      CALL cl_err(g_lmm.lmm01,'alm-052',0)
      RETURN
   END IF
   
   IF g_lmm.lmm09='X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   
   IF g_lmm.lmm08 MATCHES '[Ss1]' THEN 
      CALL cl_err('','mfg3557',0)
      RETURN
   END IF
  
   IF g_lmm.lmm07='N' THEN 
      CALL cl_err('','mfg3549',0)
      RETURN
   END IF
 
   IF g_success = "N" THEN
      RETURN
   END IF
 
   CALL aws_condition()      #瓚剿冞ワ訧蹋
   IF g_success = 'N' THEN
      RETURN
   END IF
 
##########
# CALL aws_efcli2()
# 換□□杅: (1)等芛訧蹋, (2-6)等旯訧蹋料
# 隙換硉  : 0 羲等囮啖; 1 羲等傖髡功
##########
 
   IF aws_efcli2(base.TypeInfo.create(g_lmm),base.TypeInfo.create(g_lmn),'','','','')
   THEN
       LET g_success = 'Y'
       LET g_lmm.lmm08 = 'S' 
       DISPLAY BY NAME g_lmm.lmm08
   ELSE
       LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION i210_v()
  IF g_lmm.lmm01 IS NULL THEN RETURN END IF
   
   SELECT * INTO g_lmm.* FROM lmm_file
    WHERE lmm01=g_lmm.lmm01
      
   IF g_lmm.lmm09 ='S' THEN    
      CALL cl_err(g_lmm.lmm01,'alm-052',0)
      RETURN
   END IF
   
   IF g_lmm.lmm09='Y' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_lmm.lmmacti='N' THEN CALL cl_err('','alm-004',0) RETURN END IF
   IF g_lmm.lmm08 MATCHES '[Ss1]' THEN CALL cl_err('','mfg3557',0) RETURN END IF   
   IF g_lmm.lmm08 matches '[Ss1]' THEN 
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y' 
 
   OPEN i210_cl USING g_lmm.lmm01
   IF STATUS THEN
      CALL cl_err("OPEN i255_cl:", STATUS, 1)
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i210_cl INTO g_lmm.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmm.lmm01,SQLCA.sqlcode,0) 
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_lmm.lmm09) THEN
      IF g_lmm.lmm09 ='N' THEN
         LET g_lmm.lmm09='X'
      ELSE
         LET g_lmm.lmm09='N'
         LET g_lmm.lmm08='0'
      END IF
      UPDATE lmm_file SET
             lmm09=g_lmm.lmm09,
             lmmmodu=g_user,
             lmmdate=g_today,
             lmm08 =g_lmm.lmm08
       WHERE lmm01=g_lmm.lmm01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","lmm_file",g_lmm.lmm01,"","apm-266","","upd lmm_file",1)
         LET g_success='N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lmm.lmm01,'V')
      DISPLAY BY NAME g_lmm.lmm09
      DISPLAY BY NAME g_lmm.lmm08
      CALL i210_field_pic()
   ELSE
      LET g_lmm.lmm09= g_lmm_t.lmm09
      LET g_lmm.lmm08 = g_lmm_t.lmm08
      DISPLAY BY NAME g_lmm.lmm09
      DISPLAY BY NAME g_lmm.lmm08
      ROLLBACK WORK
   END IF
 
   SELECT lmm09,lmmmodu,lmmdate
     INTO g_lmm.lmm09,g_lmm.lmmmodu,g_lmm.lmmdate FROM lmm_file
    WHERE lmm01=g_lmm.lmm01 
 
    DISPLAY BY NAME g_lmm.lmm09,g_lmm.lmmmodu,g_lmm.lmmdate
    IF g_lmm.lmm09='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_lmm.lmm08='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_lmm.lmm09,g_chr2,"","",g_chr,"") 
END FUNCTION
 
FUNCTION i210_t()
   DEFINE l_lmn02 LIKE lmn_file.lmn02
   IF cl_null(g_lmm.lmm01) THEN 
        CALL cl_err('','-400',0) 
        RETURN 
   END IF
 
   SELECT * INTO g_lmm.* FROM lmm_file
    WHERE lmm01=g_lmm.lmm01
   
   IF g_lmm.lmmacti='N' THEN
        CALL cl_err('','alm-050',0)
        RETURN
   END IF
 
   IF g_lmm.lmm09='S' THEN
      CALL cl_err('','alm-052',0)
      RETURN
   END IF
 
   IF g_lmm.lmm09!='Y' THEN 
        CALL cl_err('','alm-051',0)
        RETURN
   END IF
   
   IF NOT cl_confirm('alm-070') THEN 
        RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i210_cl USING g_lmm.lmm01
   IF STATUS THEN
      CALL cl_err("OPEN i210_cl:", STATUS, 1)
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i210_cl INTO g_lmm.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmm.lmm01,SQLCA.sqlcode,0)      
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE lmm_file SET lmm09 = 'S',lmm05 = g_user,lmm06 = g_today 
    WHERE lmm01 = g_lmm.lmm01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lmm_file",g_lmm.lmm01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_sql = "SELECT lmn02 FROM lmn_file",
                  " WHERE lmn01 ='",g_lmm.lmm01,"' ",
                  " ORDER BY lmn02 "
      DISPLAY g_sql
      PREPARE i210_pb3 FROM g_sql
      DECLARE lmn_cs3 CURSOR FOR i210_pb3
      FOREACH lmn_cs3 INTO l_lmn02
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         UPDATE lne_file SET lne31 = 'N' WHERE lne08=l_lmn02
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lme_file",l_lmn02,"",STATUS,"","",1) 
            LET g_success = 'N'
         END IF
      END FOREACH
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_lmm.lmm09 = 'S'
      LET g_lmm.lmm05 = g_user
      LET g_lmm.lmm06 = g_today
      DISPLAY BY NAME g_lmm.lmm09,g_lmm.lmm05,g_lmm.lmm06
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION i210_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lmm.lmm01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lmm.* FROM lmm_file
    WHERE lmm01=g_lmm.lmm01
   IF g_lmm.lmmacti ='N' THEN    
      CALL cl_err(g_lmm.lmm01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_lmm.lmm09 ='S' THEN    
      CALL cl_err(g_lmm.lmm01,'alm-052',0)
      RETURN
   END IF
  
   IF g_lmm.lmm09 ='Y' THEN    
      CALL cl_err(g_lmm.lmm01,'9023',0)
      RETURN
   END IF
 
   IF g_lmm.lmm08 MATCHES '[Ss1]' THEN
      CALL cl_err(g_lmm.lmm01,'mfg3557',0)
      RETURN
   END IF   
 
   IF g_lmm.lmm09 ='X' THEN    
      CALL cl_err(g_lmm.lmm01,'9024',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i210_cl USING g_lmm.lmm01
   IF STATUS THEN
      CALL cl_err("OPEN i210_cl:", STATUS, 1)
      CLOSE i210_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i210_cl INTO g_lmm.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lmm.lmm01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i210_show()
   IF cl_delh(0,0) THEN 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lmm01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lmm.lmm01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
      DELETE FROM lmm_file WHERE lmm01=g_lmm.lmm01
      DELETE FROM lmn_file WHERE lmn01=g_lmm.lmm01
      CLEAR FORM
      CALL g_lmn.clear()
      OPEN i210_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i210_cs
         CLOSE i210_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      FETCH i210_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i210_cs
         CLOSE i210_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i210_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i210_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      
         CALL i210_fetch('/')
      END IF
   END IF
   CLOSE i210_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lmm.lmm01,'D')
END FUNCTION
 
FUNCTION i210_copy()
 DEFINE l_newno    LIKE lmm_file.lmm01,
        l_oldno    LIKE lmm_file.lmm01,
        p_cmd      LIKE type_file.chr1,
        l_n        LIKE type_file.num5,
        l_input    LIKE type_file.chr1 
 DEFINE li_result  LIKE type_file.num5
 DEFINE l_count    LIKE type_file.num5          #FUN-AA0006 add   
 
    IF g_lmm.lmm01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i210_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM lmm01
 
         BEFORE INPUT
          # CALL cl_set_docno_format("lmm01")               #FUN-AA0006 mark 
 
         AFTER FIELD lmm01
         #FUN-AA0006 ---------------------------------------mod start-----------------------------------
         ##單號處理方式:
         ##在輸入單別後, 至單據性質檔中讀取該單別資料;
         ##若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         ##若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         #IF NOT cl_null(l_newno) THEN 
         #   #CALL s_check_no("alm",l_newno,'','14',"lmm_file","lmm01","") #FUN-A70130
         #    CALL s_check_no("alm",l_newno,'','L3',"lmm_file","lmm01","") #FUN-A70130
         #        RETURNING li_result,l_newno
         #   IF (NOT li_result) THEN
         #      NEXT FIELD lmm01
         #   END IF
         #   DISPLAY l_newno TO lmm01
         #END IF
          LET l_count = 0  
          IF NOT cl_null(l_newno) THEN
             SELECT COUNT(*) INTO l_count FROM lmm_file WHERE lmm01 = l_newno
             IF l_count > 0 THEN
                CALL cl_err('','-239',0)
                NEXT FIELD lmm01
             END IF   
             DISPLAY l_newno TO lmm01
          END IF 
         #FUN-AA0006 --------------------------mod end-----------------------

  
        ON ACTION controlp
        CASE
           WHEN INFIELD(lmm01)
             #FUN-AA0006 ------------------mark start------------------------------
             # LET g_t1=s_get_doc_no(l_newno)
             ## CALL q_lrk(FALSE,FALSE,g_t1,'14','ALM') RETURNING g_t1   #FUN-A70130 mark
             #CALL q_oay(FALSE,FALSE,g_t1,'L3','ALM') RETURNING g_t1    #FUN-A70130
             # LET l_newno = g_t1
             # DISPLAY l_newno TO lmm01
             # NEXT FIELD lmm01
             #FUN-AA0006 -------------------mark end------------------------------
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
        DISPLAY BY NAME g_lmm.lmm01
        RETURN
    END IF
 
    #FUN-AA0006 -------------------------mark start-----------------------------------
    ##輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
    ##CALL s_auto_assign_no("alm",l_newno,g_today,'14',"lmm_file","lmm01","","","") #FUN-A70130
    #CALL s_auto_assign_no("alm",l_newno,g_today,'L3',"lmm_file","lmm01","","","") #FUN-A70130
    #   RETURNING li_result,l_newno
    #IF (NOT li_result) THEN
    #   RETURN
    #END IF
    #FUN-AA0006 -------------------------mark end---------------------------------- 
    DISPLAY l_newno TO lmm01
    
    DROP TABLE y
    SELECT * FROM lmm_file  
        WHERE lmm01=g_lmm.lmm01
        INTO TEMP y
    UPDATE y
        SET lmm01=l_newno,
            lmm05='',
            lmm06='',
            lmm07 = 'N',
            lmm08 = '0',
            lmm09 = 'N',
            lmm10='',
            lmm11='',
            lmmacti='Y', 
            lmmuser=g_user,
            lmmgrup=g_grup, 
            lmmmodu=NULL,  
            lmmdate=NULL,
            lmmcrat=g_today
      
    INSERT INTO lmm_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","lmm_file",g_lmm.lmm01,"",SQLCA.sqlcode,"","",1)
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    
    DROP TABLE x
    SELECT * FROM lmn_file WHERE lmn01 = g_lmm.lmm01
                       INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
    UPDATE x SET lmn01 = l_newno 
    
    INSERT INTO lmn_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
    #   ROLLBACK WORK       #FUN-B80060 下移兩行
       CALL cl_err3("ins","lmn_file","","",SQLCA.sqlcode,"","",1)
       ROLLBACK WORK        #FUN-B80060
       RETURN
    ELSE 
       COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE'(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
    
    LET l_oldno = g_lmm.lmm01
    LET g_lmm.lmm01 = l_newno
    SELECT lmm_file.* INTO g_lmm.* FROM lmm_file
     WHERE lmm01 = l_newno
    CALL i210_u()
    CALL i210_b("a")
    UPDATE lmm_file SET lmmdate=NULL,lmmmodu=NULL
                    WHERE lmm01 = l_newno
    #SELECT lmm_file.* INTO g_lmm.* FROM lmm_file  #FUN-C30027
    # WHERE lmm01 = l_oldno  #FUN-C30027
    #CALL i210_show()        #FUN-C30027
END FUNCTION
 
FUNCTION i210_b_fill(p_wc2)
   DEFINE p_wc2   STRING
   LET g_sql = "SELECT lmn02,'' FROM lmn_file",
               " WHERE lmn01 ='",g_lmm.lmm01,"' "
  
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lmn02 "
   DISPLAY g_sql
   PREPARE i210_pb FROM g_sql
   DECLARE lmn_cs CURSOR FOR i210_pb
   CALL g_lmn.clear()
   LET g_cnt = 1
   FOREACH lmn_cs INTO g_lmn[g_cnt].* 
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#      SELECT azf03 INTO g_lmn[g_cnt].azf03 FROM azf_file    #NO.FUN-A70063 mark
#       where azf01 = g_lmn[g_cnt].lmn02                     #NO.FUN-A70063 mark 
#         AND azf02 = '3'                                    #NO.FUN-A70063 mark
       #NO.FUN-A70063---begin
       SELECT tqa02 INTO g_lmn[g_cnt].tqa02 FROM tqa_file
         WHERE tqa01 = g_lmn[g_cnt].lmn02 
           AND tqa03='2'
           AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                 OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
       #NO.FUN-A70063---end
       IF SQLCA.sqlcode THEN
#         CALL cl_err3("sel","azf_file",g_lmn[g_cnt].lmn02,"",SQLCA.sqlcode,"","",0)   #FUN-A70063 mark
          CALL cl_err3("sel","tqa_file",g_lmn[g_cnt].lmn02,"",SQLCA.sqlcode,"","",0)   #FUN-A70063 
          LET g_lmn[g_cnt].tqa02 = NULL
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lmn.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i210_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lmm01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i210_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("lmm01",FALSE)
    END IF
END FUNCTION
 
FUNCTION i210_out()
 
   IF cl_null(g_lmm.lmm01) THEN 
       CALL cl_err('',9057,0)
       RETURN
   END IF 
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#NO.FUN-A70063---mark begin
#  LET g_sql="SELECT lmm01,lmm02,lmm03,lmm04,lmm05,lmm06,",
#            " lmm07,lmm08,lmm09,lmm10,lmm11,lmm12,lmn02,azf03 ",
#            " FROM lmm_file,lmn_file,azf_file",
#            " WHERE lmm01 = lmn01",
#            "   AND lmm01 = lmn01",
#            "   AND lmn02 = azf01",
#            "   AND azf_file.azf02 = '3'  ",
#            "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
#            " ORDER BY lmm01,lmm02,lmn02"
#NO.FUN-A70063---mark end 

   #NO.FUN-A70063---begin
   LET g_sql="SELECT lmm01,lmm02,lmm03,lmm04,lmm05,lmm06,",
             " lmm07,lmm08,lmm09,lmm10,lmm11,lmm12,lmn02,tqa02 ",
             " FROM lmm_file,lmn_file,tqa_file",
             " WHERE lmm01 = lmn01",
             "   AND lmm01 = lmn01",
             "   AND lmn02 = tqa01",
             "   AND tqa_file.tqa02 = '3'  ",
             "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
             " ORDER BY lmm01,lmm02,lmn02"
   #NO.FUN-A70063---end 
   LET g_str=g_wc clipped
   IF g_zz05='Y' THEN
      CALL cl_wcchp(g_str,'lmm01,lmm02,lmm03,lmm04,lmm05,lmm06,lmm07,lmm08,lmm09,lmm10,lmm11,lmm12,lmn02')
         RETURNING g_str
   ELSE 
      LET g_str=''
   END IF
   CALL cl_prt_cs1('almi210','almi210',g_sql,g_str)
 END FUNCTION
#No.FUN-960134
