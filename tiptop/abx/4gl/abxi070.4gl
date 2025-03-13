# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: abxi070.4gl
# Descriptions...: 保稅系統料件特性資料維護作業
# Date & Author..: 97/08/13 By connie
# Modify.........: No.FUN-4C0003 04/12/01 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0092 04/12/20 By pengu Data and Group權限控管
# Modify.........: No.FUN-570109 05/07/13 By day   修正建檔程式key值是否可更改
# Modify.........: No.FUN-580177 05/09/07 By Nicola 查詢時，增加保稅欄位
# Modify.........: No.MOD-650115 06/05/19 By sam_lin按更改後,是update資料更改者!
# Modify.........: No.FUN-660052 05/06/15 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-6A0046 06/10/16 By jamie 1.FUNCTION i070()_q 一開始應清空g_bna.bna01的值
#                                                  2.新增action"相關文件.
# Modify.........: No.FUN-6A0007 06/10/16 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-840165 保稅否ima15要可以修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990086 09/10/10 By lilingyu "狀態"頁簽不可以下查詢條件
# Modify.........: No.TQC-990085 09/10/10 By lilingyu "盤差容許率 應補稅稅率 保稅單價 推廣貿易服務費"欄位沒有控管負數 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ima   RECORD LIKE ima_file.*,                 
    g_ima_t RECORD LIKE ima_file.*,                  #CHI-710051
    g_wc,g_sql          STRING                       #No.FUN-580092 HCN   
DEFINE g_bxe RECORD LIKE bxe_file.*
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680062  INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680062  VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680062  INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680062  INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680062  INTEGER
DEFINE mi_no_ask       LIKE type_file.num5          #No.FUN-680062  SMALLINT
DEFINE g_before_input_done   STRING                 #No.FUN-570109 
MAIN
    DEFINE
        p_row,p_col    LIKE type_file.num5          #No.FUN-680062 SMALLINT
#       l_time         LIKE type_file.chr8          #No.FUN-6A0062
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
   INITIALIZE g_ima.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i070_cl CURSOR FROM g_forupd_sql          # LOCK CURSOR
 
   LET p_row = 4 LET p_col = 5
   OPEN WINDOW i070_w AT p_row,p_col WITH FORM "abx/42f/abxi070"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
   #WHILE TRUE      ####040512
     LET g_action_choice=""
     CALL i070_menu()
     #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
   #END WHILE    ####040512
 
   CLOSE WINDOW i070_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
END MAIN
 
FUNCTION i070_curs()
    CLEAR FORM
    #FUN-6A0007...............begin
    #CONSTRUCT BY NAME g_wc ON ima01,ima15   #No.FUN-580177 #FUN-6A0007
   INITIALIZE g_ima.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021,ima25,ima15,ima06,ima08,
                              ima1916,ima19,ima20,ima21,ima22,ima106,
                              ima1911,ima95,ima1912,ima1913,ima1914,
                              ima1915,ima1919
                             ,imauser,imagrup,imaoriu,imaorig,imamodu,imadate,imaacti  #TQC-990086                              
    #FUN-6A0007...............end
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       #FUN-6A0007...............begin
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ima1916) #保稅群組代碼
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_bxe01"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima1916
                NEXT FIELD ima1916
 
              OTHERWISE EXIT CASE
          END CASE
       #FUN-6A0007...............end
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND imauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ima01 FROM ima_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY ima01 "
    PREPARE i070_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i070_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i070_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED
    PREPARE i070_pre_count FROM g_sql
    DECLARE i070_count CURSOR FOR i070_pre_count
END FUNCTION
 
FUNCTION i070_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
 
#       ON ACTION insert
#           IF cl_chk_act_auth() THEN
#                CALL i070_a()
#           END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i070_q()
            END IF
        ON ACTION next
            CALL i070_fetch('N')
        ON ACTION previous
            CALL i070_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i070_u()
            END IF
#       ON ACTION invalid
#           IF cl_chk_act_auth() THEN
#                CALL i070_x()
#           END IF
#       ON ACTION delete
#           IF cl_chk_act_auth() THEN
#                CALL i070_r()
#           END IF
#       ON ACTION reproduce
#           IF cl_chk_act_auth() THEN
#                CALL i070_copy()
#           END IF
#       ON ACTION output
#           IF cl_chk_act_auth()
#              THEN CALL i070_out()
#           END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","","","",g_ima.imaacti)
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
       ON ACTION jump
           CALL i070_fetch('/')
       ON ACTION first
           CALL i070_fetch('F')
       ON ACTION last
           CALL i070_fetch('L')
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        #No.FUN-6A0046-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_ima.ima01 IS NOT NULL THEN            
                  LET g_doc.column1 = "ima01"               
                  LET g_doc.value1 = g_ima.ima01            
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
         #No.FUN-6A0046-------add--------end----
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i070_cs
END FUNCTION
 
 
 
FUNCTION i070_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680062  VARCHAR(1)
        l_n             LIKE type_file.num5           #No.FUN-680062 SMALLINT
 
    DISPLAY BY NAME g_ima.imauser,g_ima.imagrup,g_ima.imadate,g_ima.imaacti, 
                    g_ima.imamodu                                           #NO.MOD-650115	
    INPUT BY NAME g_ima.imaoriu,g_ima.imaorig,
        #FUN-6A0007...............begin
        #g_ima.ima01,g_ima.ima15 ,g_ima.ima19,g_ima.ima20,g_ima.ima21,g_ima.ima22,  #No.FUN-570109
        #g_ima.ima106,g_ima.ima95
        g_ima.ima01,g_ima.ima15,g_ima.ima1916,g_ima.ima19,g_ima.ima20,g_ima.ima21, #MOD-840165 add ima15
        g_ima.ima22,g_ima.ima106,g_ima.ima1911,g_ima.ima95,g_ima.ima1912,
        g_ima.ima1913,g_ima.ima1914,g_ima.ima1915,
        g_ima.ima1919
        #FUN-6A0007...............end
        WITHOUT DEFAULTS
#No.FUN-570109-begin
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i070_set_entry(p_cmd)
        CALL i070_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
#No.FUN-570109-end
 
        #FUN-6A0007...............begin
        AFTER FIELD ima1919 #委託成品加工否
           IF NOT cl_null(g_ima.ima1919) THEN
              IF g_ima.ima1919 NOT MATCHES '[YN]' THEN
                 NEXT FIELD ima1919
              END IF
           END IF
 
        AFTER FIELD ima1916 #保稅群組代碼
           IF NOT cl_null(g_ima.ima1916) THEN
              SELECT * INTO g_bxe.* FROM bxe_file
               WHERE bxe01 = g_ima.ima1916
              IF SQLCA.SQLCODE THEN
                 CALL cl_err(g_ima.ima1916,SQLCA.SQLCODE,0)
                 LET g_ima.ima1916 = g_ima_t.ima1916
                 DISPLAY BY NAME g_ima.ima1916
                 NEXT FIELD ima1916
              END IF
              IF g_bxe.bxeacti = 'N' THEN
                 CALL cl_err(g_ima.ima1916,9028,0)
                 LET g_ima.ima1916 = g_ima_t.ima1916
                 DISPLAY BY NAME g_ima.ima1916
                 NEXT FIELD ima1916
              END IF
              DISPLAY g_bxe.bxe02,g_bxe.bxe03,g_bxe.bxe04,
                      g_bxe.bxe05
                   TO FORMONLY.bxe02,FORMONLY.bxe03,FORMONLY.bxe04,
                      FORMONLY.bxe05
           END IF
 
        AFTER FIELD ima1911 #保稅料區分
           IF NOT cl_null(g_ima.ima1911) THEN
              IF g_ima.ima1911 NOT MATCHES'[123]' THEN
                 LET g_ima.ima1911 = g_ima_t.ima1911
                 DISPLAY BY NAME g_ima.ima1911
                 NEXT FIELD ima1911
              END IF
           END IF
 
#TQC-990085 --begin--
       AFTER FIELD ima20
         IF NOT cl_null(g_ima.ima20) THEN
            IF g_ima.ima20 < 0 THEN 
               CALL cl_err('','aec-020',0)
               NEXT FIELD ima20
            END IF 
         END IF 
       
       AFTER FIELD ima22
         IF NOT cl_null(g_ima.ima22) THEN
            IF g_ima.ima22 < 0 THEN 
               CALL cl_err('','aec-020',0)
               NEXT FIELD ima22
            END IF 
         END IF           
 
       AFTER FIELD ima95
         IF NOT cl_null(g_ima.ima95) THEN
            IF g_ima.ima95 < 0 THEN 
               CALL cl_err('','aec-020',0)
               NEXT FIELD ima95
            END IF 
         END IF            
 
       AFTER FIELD ima1913
         IF NOT cl_null(g_ima.ima1913) THEN
            IF g_ima.ima1913 < 0 THEN 
               CALL cl_err('','aec-020',0)
               NEXT FIELD ima1913
            END IF 
         END IF            
#TQC-990085 --end--
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ima1916) #保稅群組代碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_bxe01"
                  LET g_qryparam.default1 = g_ima.ima1916
                  CALL cl_create_qry() RETURNING g_ima.ima1916
                  DISPLAY BY NAME g_ima.ima1916
                  NEXT FIELD ima1916
 
                OTHERWISE EXIT CASE
            END CASE
 
        #FUN-6A0007...............end
{
        ON ACTION CONTROLP                        # 沿用所有欄位
            CASE
               OTHERWISE
                    EXIT CASE
            END CASE }
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i070_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   #INITIALIZE g_bna.bna01 TO NULL           #No.FUN-6A0046
    INITIALIZE g_ima.* TO NULL           #FUN-6A0007
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i070_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i070_count
    FETCH i070_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i070_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bna.bna01,SQLCA.sqlcode,0)
       #INITIALIZE g_bna.* TO NULL
        INITIALIZE g_ima.* TO NULL           #FUN-6A0007
    ELSE
        CALL i070_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i070_fetch(p_flbna)
    DEFINE
        p_flbna         LIKE type_file.chr1,         #No.FUN-680062 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680062 INTEGER
 
    CASE p_flbna
        WHEN 'N' FETCH NEXT     i070_cs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS i070_cs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    i070_cs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     i070_cs INTO g_ima.ima01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i070_cs INTO g_ima.ima01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbna
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ima.* FROM ima_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)   #No.FUN-660052
        CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)
    ELSE
 
       #FUN-4C0092
       LET g_data_owner = g_ima.imauser
       LET g_data_group = g_ima.imagrup
        CALL i070_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i070_show()
    LET g_ima_t.* = g_ima.*
  # DISPLAY BY NAME g_ima.imauser,g_ima.imagrup,g_ima.imadate,g_ima.imaacti #NO.MOD-650115
    DISPLAY BY NAME g_ima.imauser,g_ima.imagrup,g_ima.imadate,g_ima.imaacti, g_ima.imaoriu,g_ima.imaorig,
                    g_ima.imamodu                                           #NO.MOD-650115             
    DISPLAY BY NAME g_ima.ima01,g_ima.ima15,g_ima.ima19,g_ima.ima20,
                    g_ima.ima21,g_ima.ima22,g_ima.ima106,g_ima.ima95
    #FUN-6A0007...............begin
    DISPLAY BY NAME g_ima.ima02,g_ima.ima021,g_ima.ima25,g_ima.ima06,
                    g_ima.ima08,g_ima.ima1911,g_ima.ima1912,
                    g_ima.ima1913,g_ima.ima1914,g_ima.ima1915,
                    g_ima.ima1916,g_ima.ima1919
    INITIALIZE g_bxe.* TO NULL
    SELECT * INTO g_bxe.* FROM bxe_file
     WHERE bxe01 = g_ima.ima1916
    DISPLAY g_bxe.bxe02,g_bxe.bxe03,g_bxe.bxe04,
            g_bxe.bxe05
         TO FORMONLY.bxe02,FORMONLY.bxe03,FORMONLY.bxe04,
            FORMONLY.bxe05
    #FUN-6A0007...............end
    CALL cl_set_field_pic("","","","","",g_ima.imaacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i070_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    {
    IF g_bna.bnaacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    }
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN i070_cl USING g_ima.ima01
    IF STATUS THEN
       CALL cl_err("OPEN i070_cl:", STATUS, 1)
       CLOSE i070_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i070_cl INTO g_ima.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        RETURN
    END IF
   #LET g_ima.imauser = g_user               #NO.MOD-650115 
   #LET g_ima.imagrup = g_grup               #NO.MOD-650015 #使用者所屬群
    LET g_ima.imamodu = g_user               #NO.MOD-650115 
    LET g_ima.imadate = g_today
    LET g_ima.imaacti = 'Y'
    CALL i070_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i070_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ima.*=g_ima_t.*
            CALL i070_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
     UPDATE ima_file SET ima_file.* = g_ima.*    # 更新DB
      WHERE ima01 = g_ima_t.ima01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)   #No.FUN-660052
           CALL cl_err3("upd","ima_file",g_ima_t.ima01,"",SQLCA.sqlcode,"","",1)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i070_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i070_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_bna.bna01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i070_cl USING g_ima.ima01
    IF STATUS THEN
       CALL cl_err("OPEN i070_cl:", STATUS, 1)
       CLOSE i070_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i070_cl INTO g_bna.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bna.bna01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i070_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ima01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ima.ima01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM bna_file WHERE bna01=g_bna.bna01
       CLEAR FORM
       OPEN i070_count
       FETCH i070_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i070_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i070_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i070_fetch('/')
       END IF
 
    END IF
    CLOSE i070_cl
    COMMIT WORK
END FUNCTION
#No.FUN-570109-begin
FUNCTION i070_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680062  VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ima01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i070_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680062 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ima01",FALSE)
   END IF
END FUNCTION
#No.FUN-570109-end
#Patch....NO.TQC-610035 <001> #
