# Prog. Version..: '5.30.06-13.04.17(00006)'     #
#
# Pattern name...: axct004.4gl
# Descriptions...: 庫齡開帳維護作業
# Date & Author..: 97/05/05 By Sarah
# Modify.........: No.FUN-7B0121 08/05/05 By Sarah 新增"庫齡開帳維護作業"
# Modify.........: No.FUN-910024 09/01/08 By kim cao02加入key值
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970216 09/09/25 By baofei 料件主檔不存在時,修改會死循環 
# Modify.........: No.CHI-9C0025 09/12/28 By jan 新增cao07/cao08欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_cao        RECORD LIKE cao_file.*,
       g_cao_t      RECORD LIKE cao_file.*,
       g_cao01_t    LIKE cao_file.cao01,
       g_cao02_t    LIKE cao_file.cao02,  #FUN-910024
       g_cao07_t    LIKE cao_file.cao07,  #CHI-9C0025
       g_cao08_t    LIKE cao_file.cao08,  #CHI-9C0025
       g_wc,g_sql   STRING,                     #No.FUN-580092 HCN
       g_ima02      LIKE ima_file.ima02
DEFINE g_forupd_sql STRING                      #SELECT ... FOR UPDATE SQL
DEFINE g_msg        LIKE ze_file.ze03
DEFINE g_chr        LIKE cao_file.caoacti
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_row_count  LIKE type_file.num10
DEFINE g_curs_index LIKE type_file.num10
DEFINE g_jump       LIKE type_file.num10
DEFINE g_no_ask     LIKE type_file.num5
 
MAIN
   DEFINE p_row,p_col  LIKE type_file.num5
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
   INITIALIZE g_cao.* TO NULL
   INITIALIZE g_cao_t.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM cao_file WHERE cao01 = ? AND cao02 = ? AND cao07=? AND cao08 = ? FOR UPDATE " #CHI-9C0025
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t004_cl CURSOR FROM g_forupd_sql               # LOCK CURSOR
 
   LET p_row = 4 LET p_col = 14
 
   OPEN WINDOW t004_w AT p_row,p_col WITH FORM "axc/42f/axct004" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL t004_menu()
 
   CLOSE WINDOW t004_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t004_cs()
DEFINE l_cao07    LIKE cao_file.cao07   #CHI-9C0025
   CLEAR FORM
 
   INITIALIZE g_cao.* TO NULL
 
   #螢幕上取條件
   CONSTRUCT BY NAME g_wc ON cao01,cao02,cao07,cao08,cao03, #CHI-9C0025
                             caouser,caomodu,caoacti,caogrup,caodate 
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      #CHI-9C0025--begin--add--
      AFTER FIELD cao07
        LET l_cao07 = get_fldbuf(cao07)
      #CHI-9C0025--end--add-----

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
    
      ON ACTION controlp
         CASE 
            WHEN INFIELD(cao01) #item
#FUN-AA0059---------mod------------str-----------------            
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state    = "c"
#                 LET g_qryparam.form     = "q_ima"
#                 LET g_qryparam.default1 = g_cao.cao01
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","",g_cao.cao01,"","","","","",'')  
                  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO cao01
                 NEXT FIELD cao01
             #CHI-9C0025--begin--add---
               WHEN INFIELD(cao08)
                 IF l_cao07 MATCHES '[45]' THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                 CASE l_cao07
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"
                    WHEN '5'
                      LET g_qryparam.form = "q_imd09"
                    OTHERWISE EXIT CASE
                 END CASE
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY  g_qryparam.multiret TO cao08
                 NEXT FIELD cao08
                 END IF
             #CHI-9C0025--end--add------
         END CASE
 
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('caouser', 'caogrup') #FUN-980030
 
   #組合出 SQL 指令
   LET g_sql="SELECT cao01,cao02,cao07,cao08 FROM cao_file ", #FUN-910024#CHI-9C0025
             " WHERE ",g_wc CLIPPED,
             " ORDER BY cao01,cao02,cao07,cao08"  #FUN-910024 #CHI-9C0024
   PREPARE t004_prepare FROM g_sql                            # RUNTIME 編譯
   DECLARE t004_cs SCROLL CURSOR WITH HOLD FOR t004_prepare   # SCROLL CURSOR
   LET g_sql="SELECT COUNT(*) FROM cao_file WHERE ",g_wc CLIPPED
   PREPARE t004_precount FROM g_sql
   DECLARE t004_count CURSOR FOR t004_precount
END FUNCTION
 
FUNCTION t004_menu()
   MENU ""
      BEFORE MENU
          CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION insert 
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL t004_a()
         END IF
 
      ON ACTION query 
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL t004_q()
         END IF
 
      ON ACTION modify 
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL t004_u()
         END IF
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL t004_x()
         END IF
 
      ON ACTION delete 
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL t004_r()
         END IF
 
      ON ACTION output 
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
            CALL t004_out()
         END IF
 
      ON ACTION first
         CALL t004_fetch('F')
 
      ON ACTION previous 
         CALL t004_fetch('P')
 
      ON ACTION jump
         CALL t004_fetch('/')
 
      ON ACTION next 
         CALL t004_fetch('N') 
 
      ON ACTION last
         CALL t004_fetch('L')
 
      ON ACTION help 
         CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document       #相關文件
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
             IF g_cao.cao01 IS NOT NULL THEN
                LET g_doc.column1 = "cao01"
                LET g_doc.value1 = g_cao.cao01
                CALL cl_doc()
             END IF
         END IF
         LET g_action_choice = "exit"
         CONTINUE MENU
 
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE
         LET g_action_choice = "exit"
         EXIT MENU
   END MENU
   CLOSE t004_cs
END FUNCTION
 
FUNCTION t004_a()
   MESSAGE ""
   CLEAR FORM                                   # 清螢幕欄位內容
   INITIALIZE g_cao.* TO NULL
   LET g_cao01_t = NULL
   LET g_cao02_t = NULL  #FUN-910024
   LET g_cao07_t = NULL  #CHI-9C0025
   LET g_cao08_t = NULL  #CHI-9C0025
   CALL cl_opmsg('a')
   WHILE TRUE

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          EXIT WHILE
       END IF
#FUN-BC0062 --end--

      LET g_cao.cao07 = g_ccz.ccz28   #CHI-9C0025
      LET g_cao.cao08 = ' '           #CHI-9C0025
     #LET g_cao.cao02   = g_today              #日期  #FUN-910024
      LET g_cao.cao03   = 0                    #數量
      LET g_cao.caoacti ='Y'                   #有效的資料
      LET g_cao.caouser = g_user               #資料所有者
      LET g_cao.caooriu = g_user #FUN-980030
      LET g_cao.caoorig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_cao.caogrup = g_grup               #資料所有部門
      LET g_cao.caodate = g_today              #最近修改日
     #LET g_cao.caoplant = g_plant  #FUN-980009 add   #FUN-A50075
      LET g_cao.caolegal = g_legal  #FUN-980009 add
      CALL t004_i("a")                         #各欄位輸入
      IF INT_FLAG THEN                         #若按了DEL鍵
         LET INT_FLAG = 0
         INITIALIZE g_cao.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
      IF g_cao.cao01 IS NULL OR g_cao.cao02 IS NULL THEN              #KEY 不可空白 #FUN-910024
         CONTINUE WHILE
      END IF
      IF cl_null(g_cao.cao08) THEN LET g_cao.cao08 = ' ' END IF  #CHI-9C0025
      INSERT INTO cao_file VALUES(g_cao.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","cao_file",g_cao.cao01,g_cao.cao02,SQLCA.sqlcode,"","ins cao",1)
         CONTINUE WHILE
      ELSE
         LET g_cao_t.* = g_cao.*                # 保存上筆資料
         SELECT cao01,cao02,cao07,cao08 INTO g_cao.cao01, #CHI-9C0025 add 02/07/08
                g_cao.cao02,g_cao.cao07,g_cao.cao08       #CHI-9C0025
           FROM cao_file 
          WHERE cao01 = g_cao.cao01
            AND cao02 = g_cao.cao02
            AND cao07 = g_cao.cao07  #CHI-9C0025
            AND cao08 = g_cao.cao08  #CHI-9C0025
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t004_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,
          l_n          LIKE type_file.num5
   DEFINE l_n1         LIKE type_file.num5  #CHI-9C0025
 
   INPUT BY NAME g_cao.cao01,g_cao.cao02,g_cao.cao07,g_cao.cao08,  #CHI-9C0025 add 07/08
                 g_cao.cao03, g_cao.caooriu,g_cao.caoorig,
                 g_cao.caouser,g_cao.caogrup,g_cao.caomodu,g_cao.caodate 
                 WITHOUT DEFAULTS 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t004_set_entry(p_cmd)
         CALL t004_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD cao01    #料號
         IF g_cao.cao01 IS NOT NULL THEN
           #FUN-AA0059 ------------------------add start--------------------------
            IF NOT s_chk_item_no(g_cao.cao01,'') THEN 
               CALL cl_err('',g_errno,1)
               NEXT FIELD cao01
            END IF 
           #FUN-AAA0059 -----------------------add end -----------------------  
            IF p_cmd = "a" OR           #若新增或更改且改KEY
              (p_cmd = "u" AND g_cao.cao01 != g_cao01_t) THEN
               SELECT COUNT(*) INTO l_n FROM cao_file
                WHERE cao01 = g_cao.cao01
                  AND cao02 = g_cao.cao02  #FUN-910024
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err('count:',-239,0)
                  NEXT FIELD cao01
               END IF
            END IF
            SELECT ima02 INTO g_ima02 FROM ima_file WHERE ima01=g_cao.cao01
            IF STATUS THEN
               CALL cl_err3("sel","ima_file",g_cao.cao01,"",STATUS,"","sel ima:",1)
               IF p_cmd = 'u' AND  g_cao.cao01 = g_cao01_t  THEN          #TQC-970216                                               
               ELSE                                           #TQC-970216                                                           
                NEXT FIELD cao01                                                                                                    
               END IF                                         #TQC-970216  
            END IF
            DISPLAY g_ima02 TO ima02
         END IF
 
      AFTER FIELD cao02    #日期
         IF cl_null(g_cao.cao02) THEN 
            CALL cl_err('','mfg0037',0)
            NEXT FIELD cao02
         #FUN-910024............begin
         ELSE
            IF p_cmd = "a" OR           #若新增或更改且改KEY
              (p_cmd = "u" AND g_cao.cao02 != g_cao02_t) THEN
               SELECT COUNT(*) INTO l_n FROM cao_file
                WHERE cao01 = g_cao.cao01
                  AND cao02 = g_cao.cao02
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err('count:',-239,0)
                  NEXT FIELD cao02
               END IF
            END IF
         #FUN-910024............end
         END IF 
 
       #CHI-9C0025--begin--add-------
        AFTER FIELD cao07
          IF g_cao.cao07 IS NOT NULL THEN
             IF g_cao.cao07 NOT MATCHES '[12345]' THEN
                NEXT FIELD cao07
             END IF
               IF g_cao.cao07 MATCHES'[12]' THEN
                  CALL cl_set_comp_entry("cao08",FALSE)
                  LET g_cao.cao08 = ' '
               ELSE
                  CALL cl_set_comp_entry("cao08",TRUE)
               END IF
          END IF

       AFTER FIELD cao08
          IF NOT cl_null(g_cao.cao08) THEN
             IF p_cmd = "a" OR
              (p_cmd = "u" AND
               (g_cao.cao01 != g_cao01_t OR g_cao.cao02 != g_cao02_t OR
                g_cao.cao07 != g_cao07_t OR g_cao.cao08 != g_cao08_t)) THEN

                CASE g_cao.cao07
                 WHEN 4
                  SELECT pja02 FROM pja_file WHERE pja01 = g_cao.cao08
                                               AND pjaclose='N'
                  IF SQLCA.sqlcode!=0 THEN
                     CALL cl_err3('sel','pja_file',g_cao.cao08,'',SQLCA.sqlcode,'','',1)
                     NEXT FIELD cao08
                  END IF
                 WHEN 5
                   LET l_n1 = 0
                   SELECT count(*) INTO l_n1
                     FROM imd_file 
                    WHERE imd09 = g_cao.cao08 
                      AND imdacti = 'Y'
                   IF l_n1=0 THEN
                     CALL cl_err3('sel','imd_file',g_cao.cao08,'',100,'','',1)
                     NEXT FIELD cao08
                  END IF
                 OTHERWISE EXIT CASE
                END CASE
                SELECT count(*) INTO l_n FROM cao_file
                 WHERE cao01 = g_cao.cao01
                   AND cao02 = g_cao.cao02
                   AND cao07 = g_cao.cao07 AND cao08 = g_cao.cao08
                IF l_n > 0 THEN
                   CALL cl_err('count:',-239,0)
                   NEXT FIELD cao01
                END IF
             END IF
          ELSE
             LET g_cao.cao08=' '
          END IF
        #CHI-9C0025--end--add--------

      AFTER FIELD cao03    #數量
         IF g_cao.cao03 <= 0 THEN 
            CALL cl_err(g_cao.cao03,'axc-207',0)
            NEXT FIELD cao03
         END IF 
 
      AFTER INPUT
         LET g_cao.caouser = s_get_data_owner("cao_file") #FUN-C10039
         LET g_cao.caogrup = s_get_data_group("cao_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(cao01) #料號
#FUN-AA0059---------mod------------str-----------------            
#               CALL cl_init_qry_var()
#               LET g_qryparam.form     = "q_ima"
#               LET g_qryparam.default1 = g_cao.cao01
#               CALL cl_create_qry() RETURNING g_cao.cao01
                CALL q_sel_ima(FALSE, "q_ima","",g_cao.cao01,"","","","","",'' ) 
                   RETURNING  g_cao.cao01
#FUN-AA0059---------mod------------end-----------------

               DISPLAY BY NAME g_cao.cao01
               NEXT FIELD cao01
            #CHI-9C0025--begin--add--------
               WHEN INFIELD(cao08)
                 IF g_cao.cao07 MATCHES '[45]' THEN
                    CALL cl_init_qry_var()
                 CASE g_cao.cao07
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"
                    WHEN '5'
                      LET g_qryparam.form = "q_imd09"
                    OTHERWISE EXIT CASE
                 END CASE
                 LET g_qryparam.default1 =g_cao.cao08
                 CALL cl_create_qry() RETURNING g_cao.cao08
                 DISPLAY BY NAME g_cao.cao08
                 NEXT FIELD cao08
                 END IF
           #CHI-9C0025--end--add-------
            OTHERWISE EXIT CASE
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
   END INPUT
END FUNCTION
 
FUNCTION t004_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cao.* TO NULL              #No.FUN-6A0019
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t004_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN t004_count
    FETCH t004_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t004_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('open t004_cs:',SQLCA.sqlcode,0)
       INITIALIZE g_cao.* TO NULL
    ELSE
       CALL t004_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t004_fetch(p_flcao)
   DEFINE p_flcao       LIKE type_file.chr1
 
   CASE p_flcao
      WHEN 'N' FETCH NEXT     t004_cs INTO g_cao.cao01,g_cao.cao02,  #FUN-910024
                                           g_cao.cao07,g_cao.cao08   #CHI-9C0025
      WHEN 'P' FETCH PREVIOUS t004_cs INTO g_cao.cao01,g_cao.cao02,  #FUN-910024
                                           g_cao.cao07,g_cao.cao08   #CHI-9C0025
      WHEN 'F' FETCH FIRST    t004_cs INTO g_cao.cao01,g_cao.cao02,  #FUN-910024
                                           g_cao.cao07,g_cao.cao08   #CHI-9C0025
      WHEN 'L' FETCH LAST     t004_cs INTO g_cao.cao01,g_cao.cao02,  #FUN-910024
                                           g_cao.cao07,g_cao.cao08   #CHI-9C0025
      WHEN '/'
           IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                    #CONTINUE PROMPT
 
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
           FETCH ABSOLUTE g_jump t004_cs INTO g_cao.cao01,g_cao.cao02,  #FUN-910024
                                              g_cao.cao07,g_cao.cao08   #CHI-9C0025
           LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cao.cao01,SQLCA.sqlcode,0)
      INITIALIZE g_cao.* TO NULL
      RETURN
   ELSE
      CASE p_flcao
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   #重讀DB,因TEMP有不被更新特性
   SELECT * INTO g_cao.* FROM cao_file WHERE cao01 = g_cao.cao01
                                         AND cao02 = g_cao.cao02  #CHI-9C0025  
                                         AND cao07 = g_cao.cao07  #CHI-9C0025  
                                         AND cao08 = g_cao.cao08  #CHI-9C0025  
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","cao_file",g_cao.cao01,g_cao.cao02,SQLCA.sqlcode,"","",1)
   ELSE                                     #權限控管
      LET g_data_owner = g_cao.caouser
      LET g_data_group = g_cao.caogrup
     #LET g_data_plant = g_cao.caoplant #FUN-980030    #FUN-A50075
      LET g_data_plant = g_plant        #FUN-A50075
      CALL t004_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t004_show()
   LET g_cao_t.* = g_cao.*
   DISPLAY BY NAME g_cao.caooriu,g_cao.caoorig,
      g_cao.cao01,g_cao.cao02,g_cao.cao03,g_cao.cao07,g_cao.cao08,   #CHI-9C0025
      g_cao.caouser,g_cao.caomodu,g_cao.caoacti,g_cao.caogrup,g_cao.caodate 
   SELECT ima02 INTO g_ima02 FROM ima_file WHERE ima01=g_cao.cao01
   DISPLAY g_ima02 TO ima02
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t004_u()
   IF g_cao.cao01 IS NULL OR g_cao.cao02 IS NULL THEN #FUN-910024
      CALL cl_err('',-400,0) 
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_cao01_t = g_cao.cao01
   LET g_cao02_t = g_cao.cao02  #FUN-910024
   LET g_cao07_t = g_cao.cao07  #CHI-9C0025
   LET g_cao08_t = g_cao.cao08  #CHI-9C0025
   BEGIN WORK
 
   OPEN t004_cl USING g_cao.cao01,g_cao.cao02,g_cao.cao07,g_cao.cao08  #CHI-9C0025 add 02/07/08
   IF STATUS THEN
      CALL cl_err("OPEN t004_cl:", STATUS, 1)
      CLOSE t004_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t004_cl INTO g_cao.*                #對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
   IF cl_null(g_cao.caoacti) THEN LET g_cao.caoacti ='Y' END IF 
   IF cl_null(g_cao.caouser) THEN LET g_cao.caouser = g_user END IF 
   IF cl_null(g_cao.caogrup) THEN LET g_cao.caogrup = g_grup END IF 
   LET g_cao.caomodu=g_user                  #修改者
   LET g_cao.caodate=g_today                 #修改日期
   CALL t004_show()                          #顯示最新資料
   WHILE TRUE
      CALL t004_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_cao.*=g_cao_t.*
         CALL t004_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      #更新DB
      UPDATE cao_file SET cao_file.* = g_cao.* WHERE cao01 = g_cao_t.cao01
         AND cao02 = g_cao_t.cao02  #CHI-9C0025
         AND cao07 = g_cao_t.cao07  #CHI-9C0025
         AND cao08 = g_cao_t.cao08  #CHI-9C0025
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","cao_file",g_cao01_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t004_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t004_x()
   IF g_cao.cao01 IS NULL OR g_cao.cao02 IS NULL THEN  #FUN-910024
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t004_cl USING g_cao.cao01,g_cao.cao02,g_cao.cao07,g_cao.cao08  #CHI-9C0025
   IF STATUS THEN
      CALL cl_err("OPEN t004_cl:", STATUS, 1)
      CLOSE t004_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t004_cl INTO g_cao.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cao.cao01,SQLCA.sqlcode,1)
      RETURN
   END IF
   CALL t004_show()
   IF cl_exp(0,0,g_cao.caoacti) THEN
      LET g_chr=g_cao.caoacti
      IF g_cao.caoacti='Y' THEN
         LET g_cao.caoacti='N'
      ELSE
         LET g_cao.caoacti='Y'
      END IF
      UPDATE cao_file SET caoacti=g_cao.caoacti WHERE cao01=g_cao.cao01
         AND cao02 = g_cao.cao02   #CHI-9C0025
         AND cao07 = g_cao.cao07   #CHI-9C0025
         AND cao08 = g_cao.cao08   #CHI-9C0025
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(g_cao.cao01,SQLCA.sqlcode,0)
         LET g_cao.caoacti=g_chr
      END IF
      DISPLAY BY NAME g_cao.caoacti
   END IF
   CLOSE t004_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t004_r()
   IF g_cao.cao01 IS NULL OR g_cao.cao02 IS NULL THEN  #FUN-910024
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t004_cl USING g_cao.cao01,g_cao.cao02,g_cao.cao07,g_cao.cao08   #CHI-9C0025
   IF STATUS THEN
      CALL cl_err("OPEN t004_cl:", STATUS, 1)
      CLOSE t004_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t004_cl INTO g_cao.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cao.cao01,SQLCA.sqlcode,0)
      RETURN
   END IF
   CALL t004_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "cao01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_cao.cao01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM cao_file WHERE cao01 = g_cao.cao01
                             AND cao02 = g_cao.cao02 #FUN-910024
                             AND cao07 = g_cao.cao07 #CHI-9C0025
                             AND cao08 = g_cao.cao08 #CHI-9C0025
      CLEAR FORM
      OPEN t004_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE t004_cs
         CLOSE t004_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      FETCH t004_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t004_cs
         CLOSE t004_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t004_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t004_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t004_fetch('/')
      END IF
   END IF
   CLOSE t004_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t004_out()
   IF g_wc IS NULL THEN
      IF cl_null(g_cao.cao01) OR cl_null(g_cao.cao02) THEN  #FUN-910024
         #無列印條件，請重新做QBE查詢後再開始列印報表!
         CALL cl_err('','9057',0) RETURN  
      ELSE
         LET g_wc=" cao01='",g_cao.cao01,"'",
                  " AND cao02='",g_cao.cao02,"'",  #FUN-910024
                  " AND cao07='",g_cao.cao07,"'",  #CHI-9C0025
                  " AND cao08='",g_cao.cao08,"'"   #CHI-9C0025
      END IF
   END IF
   CALL cl_wait()
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_sql="SELECT cao01,cao02,cao03,ima02 ",
             "  FROM cao_file LEFT OUTER JOIN ima_file ON cao01 = ima01 ",
             " WHERE 1 = 1",
             "   AND caoacti='Y'",
             "   AND ",g_wc CLIPPED
 
   CALL cl_wcchp(g_wc,'cao01,cao02,cao03,caouser,caomodu,caoacti,caogrup,caodate')
        RETURNING g_wc
   CALL cl_prt_cs1('axct004','axct004',g_sql,g_wc)
   ERROR ""
END FUNCTION
 
FUNCTION t004_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("cao01,cao02,cao07,cao08",TRUE)  #FUN-910024 #CHI-9C0025
   END IF
END FUNCTION
 
FUNCTION t004_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("cao01,cao02,cao07,cao08",FALSE)  #FUN-910024 #CHI-9C0025
   END IF
   #CHI-9C0025--begin--add----
    IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND
       (NOT g_before_input_done) THEN
       IF g_cao.cao07 MATCHES'[12]' THEN
          CALL cl_set_comp_entry("cao08",FALSE)
       ELSE
          CALL cl_set_comp_entry("cao08",TRUE)
       END IF
    END IF
    #CHI-9C0025--end--add---
END FUNCTION
#FUN-7B0121

