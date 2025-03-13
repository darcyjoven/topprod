# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: asdi101.4gl
# Descriptions...: 成本未結工單開帳作業
# Date & Author..: 00/08/14 By Byron
# Modify.........: NO.FUN-550066 05/05/24 By vivien 單據編號加大
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660120 06/06/16 By CZH cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0150 06/10/26 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760143 07/06/15 By jamie 按'u'修改時，會當掉
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980008 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ste   RECORD LIKE ste_file.*,
    g_ste_t RECORD LIKE ste_file.*,
    g_ste01_t LIKE ste_file.ste01,
    g_ste02_t LIKE ste_file.ste02,
    g_ste03_t LIKE ste_file.ste03,
    g_ste04_t LIKE ste_file.ste04,
    g_sfb   RECORD LIKE sfb_file.*,
     g_wc,g_sql          string,  #No.FUN-580092 HCN
    g_ima   RECORD LIKE ima_file.*
 #  g_sfb03 LIKE sfb_file.sfb03
 
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-690010INTEGER   
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-690010CHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-690010INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-690010INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-690010INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-690010SMALLINT
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-690010SMALLINT,
#       l_time        LIKE type_file.chr8              #No.FUN-6A0089
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
    INITIALIZE g_ste.* TO NULL
    INITIALIZE g_ste_t.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM ste_file WHERE ste02 = ? AND ste03 = ? AND ste04 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_cl CURSOR FROM g_forupd_sql    
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i101_w AT p_row,p_col
        WITH FORM "asd/42f/asdi101" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    #WHILE TRUE      ####040512
 
    LET g_action_choice=""
    CALL i101_menu()
 
    #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i101_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
END MAIN
 
FUNCTION i101_cs()
    CLEAR FORM
   INITIALIZE g_ste.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ste04,ste01,ste05, ste02,ste03,ste31,
        ste06,ste07,ste08,ste09,ste10,
        ste11,ste12,ste13,ste14,ste15, ste32,
        ste16, ste17, ste18, ste19, ste20,
        ste22, ste23, ste24, ste25, 
        ste26, ste27, ste28, ste29, ste30
      #  steuser,stegrup,stemodu,stedate 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp                        # 查詢其他主檔資料
           CASE
            WHEN INFIELD(ste04) #工單單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_sfb"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ste04
                 NEXT FIELD ste04
 
            WHEN INFIELD(ste05)   #料號
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.state="c"
#                 LET g_qryparam.default1 = g_ste.ste05
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","",g_ste.ste05,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO ste05
                 NEXT FIELD ste05
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
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    LET g_sql="SELECT ste02,ste03,ste04 FROM ste_file ",
        " WHERE ",g_wc CLIPPED, " ORDER BY ste02,ste03,ste04"
    PREPARE i101_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i101_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i101_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ste_file WHERE ",g_wc CLIPPED
    PREPARE i101_precount FROM g_sql
    DECLARE i101_count CURSOR FOR i101_precount
END FUNCTION
 
FUNCTION i101_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i101_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i101_q()
            END IF
        ON ACTION next 
            CALL i101_fetch('N') 
        ON ACTION previous 
            CALL i101_fetch('P')
        ON ACTION modify 
          #  IF cl_chk_act_auth() THEN
                 CALL i101_u()
          #  END IF
        ON ACTION delete 
          #  IF cl_chk_act_auth() THEN
                 CALL i101_r()
          #  END IF
      { ON ACTION output 
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i101_out()
            END IF}
        ON ACTION help 
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #圖形顯示
           CALL cl_set_field_pic("","","",g_ste.ste31,"","")

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i101_fetch('/')
        ON ACTION first
            CALL i101_fetch('F')
        ON ACTION last
            CALL i101_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #No.FUN-6A0150-------add--------str----
      ON ACTION related_document             #相關文件"                        
       LET g_action_choice="related_document"           
          IF cl_chk_act_auth() THEN                     
             IF g_ste.ste02 IS NOT NULL THEN            
                LET g_doc.column1 = "ste02"               
                LET g_doc.column2 = "ste03"     
                LET g_doc.column3 = "ste04"          
                LET g_doc.value1 = g_ste.ste02            
                LET g_doc.value2 = g_ste.ste03   
                LET g_doc.value3 = g_ste.ste04         
                CALL cl_doc()                             
             END IF                                        
          END IF                                           
       #No.FUN-6A0150-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i101_cs
END FUNCTION
 
 
FUNCTION i101_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_ste.* TO NULL
    LET g_ste_t.* = g_ste.*
    LET g_ste.ste31 = 'N'
    LET g_ste.ste06 = 0
    LET g_ste.ste07 = 0
    LET g_ste.ste08 = 0
    LET g_ste.ste09 = 0
    LET g_ste.ste10 = 0
    LET g_ste.ste11 = 0
    LET g_ste.ste12 = 0
    LET g_ste.ste13 = 0
    LET g_ste.ste14 = 0
    LET g_ste.ste15 = 0
    LET g_ste.ste32 = 0
    LET g_ste.ste16 = 0
    LET g_ste.ste17 = 0
    LET g_ste.ste18 = 0
    LET g_ste.ste19 = 0
    LET g_ste.ste20 = 0
    LET g_ste.ste22 = 0
    LET g_ste.ste23 = 0
    LET g_ste.ste24 = 0
    LET g_ste.ste25 = 0
    LET g_ste.ste26 = 0
    LET g_ste.ste27 = 0
    LET g_ste.ste28 = 0
    LET g_ste.ste29 = 0
    LET g_ste.ste30 = 0
    CALL cl_opmsg('a')
    WHILE TRUE
	{LET g_ste.steacti ='Y'                   #有效的資料
	LET g_ste.steuser = g_user
	LET g_data_plant = g_plant #FUN-980030
	LET g_ste.stegrup = g_grup               #使用者所屬群
	LET g_ste.stedate = g_today}
 
	LET g_ste.steplant= g_plant         #FUN-980008 add
	LET g_ste.stelegal= g_legal         #FUN-980008 add
 
        CALL i101_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_ste.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ste.ste02 IS NULL OR g_ste.ste03 IS NULL OR
           g_ste.ste04 IS NULL THEN # KEY 不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO ste_file VALUES(g_ste.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err('ins ste:',SQLCA.sqlcode,0)   #No.FUN-660120
            CALL cl_err3("ins","ste_file",g_ste.ste02,g_ste.ste03,SQLCA.sqlcode,"","ins ste:",1)  #No.FUN-660120
            CONTINUE WHILE
        ELSE
            LET g_ste_t.* = g_ste.*                # 保存上筆資料
            SELECT ste02,ste03,ste04 INTO g_ste.ste02,g_ste.ste03,g_ste.ste04 FROM ste_file
                WHERE ste02 = g_ste.ste02
                  AND ste03 = g_ste.ste03 AND ste04 = g_ste.ste04
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i101_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
        l_flag          LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
        l_n             LIKE type_file.num5          #No.FUN-690010SMALLINT
 
    INPUT BY NAME 
        g_ste.ste04,g_ste.ste01,g_ste.ste05,
        g_ste.ste02,g_ste.ste03,g_ste.ste31,
        g_ste.ste06,g_ste.ste07, g_ste.ste08, g_ste.ste09, g_ste.ste10,
        g_ste.ste11,g_ste.ste12, g_ste.ste13, g_ste.ste14, g_ste.ste15,
        g_ste.ste32,
        g_ste.ste16,g_ste.ste17, g_ste.ste18, g_ste.ste19, g_ste.ste20,
        g_ste.ste22,g_ste.ste23, g_ste.ste24, g_ste.ste25, 
        g_ste.ste26,g_ste.ste27, g_ste.ste28, g_ste.ste29, g_ste.ste30 
       # g_ste.steuser,g_ste.stegrup,g_ste.stemodu,g_ste.stedate 
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i101_set_entry(p_cmd)
          CALL i101_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
         #No.FUN-550066 --start--
          CALL cl_set_docno_format("ste04")
         #No.FUN-550066 ---end---
 
        AFTER FIELD ste03
          IF g_ste.ste03 IS NOT NULL THEN 
            IF g_ste.ste03 < 1 OR g_ste.ste03 > 12 THEN
               NEXT FIELD ste03
            END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND
                  (g_ste.ste02 != g_ste02_t OR
                   g_ste.ste03 != g_ste03_t OR g_ste.ste04 != g_ste04_t)) THEN
                   SELECT count(*) INTO l_n FROM ste_file
                       WHERE ste02 = g_ste.ste02
                         AND ste03 = g_ste.ste03 AND ste04 = g_ste.ste04
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err('count:',-239,0)
                       NEXT FIELD ste01
                   END IF
            END IF
          END IF
 
        AFTER FIELD ste04
          CALL i101_ste04(p_cmd)
          IF g_errno IS NOT NULL THEN
             CALL cl_err(g_ste.ste04,g_errno,0)
             NEXT FIELD ste04
          END IF
 
        AFTER FIELD ste05
          #FUN-A0059 -------------------------add start-----------------------------------
          IF NOT cl_null(g_ste.ste05) THEN
             IF NOT s_chk_item_no(g_ste.ste05,'') THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD ste05
             END IF 
          END IF 
          #FUN-AA0059 -----------------------add end-------------------------------------- 
          CALL i101_ste05(p_cmd) 
          IF g_errno IS NOT NULL THEN
             CALL cl_err(g_ste.ste05,g_errno,0)
             NEXT FIELD ste05
          END IF
 
       AFTER FIELD ste31
            IF cl_null(g_ste.ste31) OR g_ste.ste31 NOT MATCHES '[YN]' THEN
                 CALL cl_err('','9061',0)
                 NEXT FIELD ste31
            END IF
 
       AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           IF INT_FLAG THEN
               EXIT INPUT  
           END IF
 
       #MOD-650015 --start
       #  ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(ste01) THEN
       #         LET g_ste.* = g_ste_t.*
       #         DISPLAY BY NAME g_ste.* 
       #         NEXT FIELD ste01
       #     END IF
       #MOD-650015 --end
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp                        # 查詢其他主檔資料
           CASE 
             WHEN INFIELD(ste04)   #料號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfb"
                  LET g_qryparam.default1 = g_ste.ste04
                  CALL cl_create_qry() RETURNING g_ste.ste04
#                  CALL FGL_DIALOG_SETBUFFER( g_ste.ste04 )
                  DISPLAY BY NAME g_ste.ste04
                  NEXT FIELD ste04
 
             WHEN INFIELD(ste05)  #料號
#                 CALL q_ima(10,3,g_ste.ste05) RETURNING g_ste.ste05
#                 CALL FGL_DIALOG_SETBUFFER( g_ste.ste05 )
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = g_ste.ste05
#                  CALL cl_create_qry() RETURNING g_ste.ste05
                   CALL q_sel_ima(FALSE, "q_ima","",g_ste.ste05,"","","","","",'' ) 
                        RETURNING  g_ste.ste05
#FUN-AA0059---------mod------------end-----------------
#                  CALL FGL_DIALOG_SETBUFFER( g_ste.ste05 )
                  DISPLAY BY NAME g_ste.ste05  
                  NEXT FIELD ste05
            END CASE
 
 
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
 
FUNCTION i101_ste04(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
          l_sfb02  LIKE sfb_file.sfb02,
          l_sfb05  LIKE sfb_file.sfb05,
          l_ima02  LIKE ima_file.ima02
 
   Let g_errno=''     #TQC-760143 add
   IF p_cmd='u' THEN RETURN END IF
  #Let g_errno=''     #TQC-760143 mod
   LET g_ste.ste05=''
   SELECT sfb05,sfb02 INTO l_sfb05,l_sfb02 FROM sfb_file
      WHERE sfb01 = g_ste.ste04 
   CASE
     WHEN SQLCA.sqlcode=100 Let g_errno='asf-312'
          DISPLAY BY NAME g_ste.ste05
          LET l_ima02=''
          DISPLAY l_ima02 To FORMONLY.ima02
     OTHERWISE LET g_errno=''
   END CASE
   IF g_errno IS NULL or p_cmd='d' THEN
     LET g_ste.ste05=l_sfb05
     LET g_ste.ste01=l_sfb02
     DISPLAY BY NAME g_ste.ste05
     DISPLAY BY NAME g_ste.ste01
   END IF
  
END FUNCTION
 
FUNCTION i101_ste05(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,         #No.FUN-690010CHAR(01), 
          l_ima02 LIKE ima_file.ima02
   Let g_errno=''
   SELECT ima02 INTO l_ima02 FROM ima_file
      WHERE ima01 = g_ste.ste05   
   CASE 
     WHEN SQLCA.sqlcode=100 Let g_errno='asf-677' 
          LET l_ima02=''
          DISPLAY l_ima02 To FORMONLY.ima02
     OTHERWISE LET g_errno=''
   END CASE
   IF g_errno IS NULL  THEN
     DISPLAY l_ima02  To FORMONLY.ima02
   END IF
END FUNCTION
 
FUNCTION i101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ste.* TO NULL              #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i101_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i101_count
    FETCH i101_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN i101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open i101_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_ste.* TO NULL
    ELSE
        CALL i101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i101_fetch(p_flste)
    DEFINE
        p_flste         LIKE type_file.chr1,         #No.FUN-690010 VARCHAR(1),
        l_abso          LIKE type_file.num10         #No.FUN-690010INTEGER
 
    CASE p_flste
        WHEN 'N' FETCH NEXT     i101_cs INTO g_ste.ste02, 
                                             g_ste.ste03,g_ste.ste04
 
        WHEN 'P' FETCH PREVIOUS     i101_cs INTO g_ste.ste02, 
                                             g_ste.ste03,g_ste.ste04
 
        WHEN 'F' FETCH FIRST     i101_cs INTO g_ste.ste02, 
                                             g_ste.ste03,g_ste.ste04
        
        WHEN 'L' FETCH LAST     i101_cs INTO g_ste.ste02, 
                                             g_ste.ste03,g_ste.ste04
 
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
            FETCH ABSOLUTE g_jump i101_cs INTO g_ste.ste02, g_ste.ste03,g_ste.ste04
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ste.ste02,SQLCA.sqlcode,0)
        INITIALIZE g_ste.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flste
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ste.* FROM ste_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ste02=g_ste.ste02 AND ste03=g_ste.ste03 AND ste04=g_ste.ste04
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ste.ste02,SQLCA.sqlcode,0)   #No.FUN-660120
        CALL cl_err3("sel","ste_file",g_ste.ste02,g_ste.ste03,SQLCA.sqlcode,"","",1)  #No.FUN-660120
    ELSE
#       LET g_data_owner = g_ste.steuser
#       LET g_data_group = g_ste.stegrup
        CALL i101_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i101_show()
    LET g_ste_t.* = g_ste.*
    DISPLAY BY NAME
        g_ste.ste04,g_ste.ste01,g_ste.ste05,
        g_ste.ste02,g_ste.ste03,g_ste.ste31,
        g_ste.ste06,g_ste.ste07, g_ste.ste08, g_ste.ste09, g_ste.ste10,
        g_ste.ste11,g_ste.ste12, g_ste.ste13, g_ste.ste14, g_ste.ste15,
        g_ste.ste32,
        g_ste.ste16,g_ste.ste17, g_ste.ste18, g_ste.ste19, g_ste.ste20,
        g_ste.ste22,g_ste.ste23, g_ste.ste24, g_ste.ste25,
        g_ste.ste26,g_ste.ste27, g_ste.ste28, g_ste.ste29, g_ste.ste30
     #   g_ste.steuser,g_ste.stegrup,g_ste.stemodu,g_ste.stedate
    INITIALIZE g_sfb.* TO NULL
    INITIALIZE g_ima.* TO NULL
 
    #圖形顯示
    CALL cl_set_field_pic("","","",g_ste.ste31,"","")
 
    CALL i101_ste05('d')
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i101_u()
    IF cl_null(g_ste.ste02) OR cl_null(g_ste.ste03) OR cl_null(g_ste.ste04) THEN
       CALL cl_err('',-101,0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ste02_t = g_ste.ste02
    LET g_ste03_t = g_ste.ste03
    LET g_ste04_t = g_ste.ste04
    BEGIN WORK
 
    OPEN i101_cl USING g_ste.ste02,g_ste.ste03,g_ste.ste04
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_ste.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i101_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i101_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ste.*=g_ste_t.*
            CALL i101_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ste.ste04 IS NULL THEN LET g_ste.ste04 = ' ' END IF
        UPDATE ste_file SET ste_file.* = g_ste.*    # 更新DB
            WHERE ste02=g_ste.ste02 AND ste03=g_ste.ste03 AND ste04=g_ste.ste04             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ste.ste01,SQLCA.sqlcode,0)   #No.FUN-660120
            CALL cl_err3("upd","ste_file",g_ste02_t,g_ste03_t,SQLCA.sqlcode,"","",1)  #No.FUN-660120
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_r()
    IF cl_null(g_ste.ste02) OR cl_null(g_ste.ste03) OR cl_null(g_ste.ste04) THEN
       #CALL cl_err('',-101,0)                 #No.FUN-6A0150
        CALL cl_err("",-400,0)                 #No.FUN-6A0150
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i101_cl USING g_ste.ste02,g_ste.ste03,g_ste.ste04
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_ste.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ste.ste04,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i101_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ste02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "ste03"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "ste04"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ste.ste02      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_ste.ste03      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_ste.ste04      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ste_file WHERE ste02 = g_ste.ste02
                              AND ste03 = g_ste.ste03 AND ste04 = g_ste.ste04
       CLEAR FORM
       OPEN i101_count
       FETCH i101_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i101_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i101_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i101_fetch('/')
       END IF
    END IF
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
 {FUNCTION i101_out()
    DEFINE
        l_i             LIKE type_file.num5,         #No.FUN-690010SMALLINT,
        l_name          LIKE type_file.chr20,        #No.FUN-690010CHAR(20),                # External(Disk) file name
        l_za05          LIKE type_file.chr1000,      #No.FUN-690010CHAR(40),                #
        l_ste RECORD LIKE ste_file.*,
        sr RECORD
           ima02 LIKE ima_file.ima02,
           ima25 LIKE ima_file.ima25
           END RECORD
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-101,0)
#       RETURN
#   END IF
    CALL cl_wait()
    LET l_name = 'asdi101.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'asdi101'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT ste_file.*, ima02,ima25 FROM ste_file LEFT OUTER JOIN ima_file ON ste_file.ste04=ima_file.ima01  ",
              " WHERE ",g_wc CLIPPED
    PREPARE i101_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i101_co CURSOR FOR i101_p1
 
    START REPORT i101_rep TO l_name
 
    FOREACH i101_co INTO l_ste.*, sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i101_rep(l_ste.*, sr.*)
    END FOREACH
 
    FINISH REPORT i101_rep
 
    CLOSE i101_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i101_rep(l_ste,sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
        l_ste RECORD LIKE ste_file.*,
        l_price      LIKE ste_file.ste12a , 
        sr RECORD
           ima02 LIKE ima_file.ima02,
           ima25 LIKE ima_file.ima25
           END RECORD
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
    ORDER BY l_ste.ste01,l_ste.ste02,l_ste.ste03,l_ste.ste04
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today ,'  ',TIME,
              COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT g_x[11],g_x[12]
            PRINT "-------------------- ---- ------------- ",
                  "------------- -------------"
            LET l_trailer_sw = 'y'
        BEFORE GROUP OF l_ste.ste01
            PRINT g_x[13] CLIPPED,l_ste.ste01,' ',
                  g_x[14] CLIPPED,l_ste.ste02 USING '&&&&','  ',
                  g_x[15] CLIPPED,l_ste.ste03 USING '&&'
            PRINT 
        ON EVERY ROW
            NEED 2 LINES
            IF l_ste.ste11 = 0 THEN 
               LET l_price = 0
            ELSE 
               LET l_price = l_ste.ste12/l_ste.ste11
            END IF 
            PRINT l_ste.ste04,' ',sr.ima25,
#                 l_ste.ste02 USING '#####',l_ste.ste03 USING '###',
                  l_ste.ste11 USING '###,###,###.##',
                  l_ste.ste12 USING '###,###,###.##',
                  l_price USING '#,###,###.####'
            PRINT sr.ima02
        AFTER GROUP OF l_ste.ste01
            PRINT COLUMN 34,g_x[16] CLIPPED, 
                  GROUP SUM(l_ste.ste12) USING '####,###,###.##'
            PRINT
        ON LAST ROW
            PRINT
            PRINT COLUMN 34,g_x[17] CLIPPED,
                  SUM(l_ste.ste12) USING '####,###,###.##'
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
 
FUNCTION i101_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-690010CHAR(01)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ste02,ste03,ste04,ste031",TRUE)
  END IF
END FUNCTION
 
FUNCTION i101_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-690010CHAR(01)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' THEN
     CALL cl_set_comp_entry("ste02,ste03,ste04,ste031",FALSE)
  END IF
END FUNCTION
 
