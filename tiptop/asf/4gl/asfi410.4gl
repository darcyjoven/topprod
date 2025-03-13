# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asfi410.4gl
# Descriptions...: 料表批號
# Date & Author..: 91/10/12 By Keith
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-550067 05/05/30 By Trisy 單據編號加大
# Modify.........: No.TQC-630068 06/03/07 By Sarah 指定單據編號、執行功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660067 06/06/14 By Sarah p_flow功能補強
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0164 06/11/13 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740125 07/04/17 By Rayven 單據錄入時單據名稱沒有帶出
# Modify.........: No.TQC-740341 07/04/30 By johnray 5.0版更,添加復制時PBI號碼欄位的開窗功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780177 07/09/18 By pengu 刪除時先判斷是否有對應的sfd_file資料,若有則不能刪除
# Modify.........: No.TQC-790077 07/09/19 By Carrier _show()中漏了顯示sfcgrup
# Modify.........: No.FUN-840096 08/01/15 By ve007 增加欄位：版單否，預計齊料日，實際齊料日，審核碼，
                                               #狀態碼，制單號;asfi410.4gl -> asfi410.src.4gl
# Modify.........: No.FUN-7B0018 08/02/16 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-870117 08/09/25 by ve007 解決copy的BUG， 增加審核圖
# Modify.........: No.TQC-970108 09/07/13 By lilingyu 1.無效資料不可刪除 2.查詢時開窗錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-B50080 11/05/18 by destiny 不能controlg  
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-BC0166 11/12/29 By yuhuabao BUG修改，刪除時應一併刪除 sfci_file
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-D10251 13/01/29 By bart 改為cl_get_extra_cond('sfcuser', 'sfcgrup') 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sfc   RECORD LIKE sfc_file.*,
    g_sfc_t RECORD LIKE sfc_file.*,
    g_sfc01_t LIKE sfc_file.sfc01,
    g_t1                LIKE oay_file.oayslip,                     #No.FUN-550067        #No.FUN-680121 VARCHAR(05)
    g_wc,g_sql          string,  #No.FUN-580092 HCN
    g_aa                LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_bb                LIKE type_file.chr1         #No.FUN-680121 VARCHAR(1)
DEFINE g_argv1          LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(16) #料表批號    #TQC-630068
       g_argv2          STRING      #執行功能         #TQC-630068
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_chr            LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_cnt            LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_i              LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_msg            LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE   g_row_count      LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_curs_index     LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_jump           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_no_ask        LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
  #start TQC-630068
   LET g_argv1=ARG_VAL(1)   #料表批號
   LET g_argv2=ARG_VAL(2)   #執行功能
  #end TQC-630068
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    INITIALIZE g_sfc.* TO NULL
    INITIALIZE g_sfc_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM sfc_file WHERE sfc01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i410_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
 
    OPEN WINDOW i410_w WITH FORM "asf/42f/asfi410"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
   #start TQC-630068
    # 先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i410_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i410_a()
             END IF
          OTHERWISE          #TQC-660067 add
             CALL i410_q()   #TQC-660067 add
       END CASE
    END IF
   #end TQC-630068
 
   #No.FUN-840096 --begin--
     CALL cl_set_act_visible("confirm,notconfirm",FALSE)
     CALL cl_set_comp_visible("sfcislk04,sfcislk05",FALSE)
   #No.FUN-840096 --end--
      
    LET g_action_choice=""
    CALL i410_menu()
 
    CLOSE WINDOW i410_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i410_curs()
  CLEAR FORM
 
 #start TQC-630068
  IF NOT cl_null(g_argv1) THEN
     LET g_wc = " sfc01='",g_argv1,"'"
  ELSE
 #end TQC-630068
   INITIALIZE g_sfc.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        sfc01,sfc02,
        sfcuser,sfcgrup,sfcmodu,sfcdate,sfcacti
        
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
               WHEN INFIELD(sfc01)                                                                   
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.state = 'c'                                                                                        
                  LET g_qryparam.form ="q_sfc02"                                                                                    
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO sfc01                                                                              
                  NEXT FIELD sfc01       
                 
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
  END IF   #TQC-630068
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND sfcser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND sfcgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND sfcgrup IN ",cl_chk_tgrup_list()
    #    END IF
    #LET g_wc = g_wc CLIPPED,cl_get_extra_cond(',g_user', ',g_grup')  #MOD-D10251
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfcuser', 'sfcgrup')  #MOD-D10251

    	 LET g_sql="SELECT sfc01 FROM sfc_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY sfc01"
    PREPARE i410_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i410_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i410_prepare
      LET g_sql="SELECT COUNT(*) FROM sfc_file WHERE ",g_wc CLIPPED  
   PREPARE i410_precount FROM g_sql
   DECLARE i410_count CURSOR FOR i410_precount
END FUNCTION
 
FUNCTION i410_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i410_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i410_q()
            END IF
        ON ACTION next
            CALL i410_fetch('N')
        ON ACTION previous
            CALL i410_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i410_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i410_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i410_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i410_copy()
            END IF
            #TQC-B50080--begin
        ON ACTION controlg
           CALL cl_cmdask()
        #TQC-B50080--end
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
         ON ACTION jump
            CALL i410_fetch('/')
        ON ACTION first
            CALL i410_fetch('F')
        ON ACTION last
            CALL i410_fetch('L')
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
         
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_sfc.sfc01 IS NOT NULL THEN
                  LET g_doc.column1 = "sfc01"
                  LET g_doc.value1 = g_sfc.sfc01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0164-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i410_cs
END FUNCTION
 
 
FUNCTION i410_a()
    DEFINE li_result   LIKE type_file.num5      #No.FUN-550067        #No.FUN-680121 SMALLINT
 
 
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_sfc.* LIKE sfc_file.*
    LET g_sfc01_t = NULL
    LET g_sfc_t.*=g_sfc.* 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_sfc.sfcuser = g_user
        LET g_sfc.sfcoriu = g_user #FUN-980030
        LET g_sfc.sfcorig = g_grup #FUN-980030
        LET g_sfc.sfcgrup = g_grup               #使用者所屬群
        LET g_sfc.sfcdate = g_today
        LET g_sfc.sfcacti = 'Y'
        CALL i410_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_sfc.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_sfc.sfc01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK   #No:7829
       #No.FUN-550067 --start--
        CALL s_auto_assign_no("asf",g_sfc.sfc01,g_today,"8","sfc_file","sfc01","","","")
        RETURNING li_result,g_sfc.sfc01
      IF (NOT li_result) THEN
 
#       IF g_smy.smyauno='Y' THEN
#           CALL s_smyauno(g_sfc.sfc01,g_today) RETURNING g_i,g_sfc.sfc01
#           IF g_i THEN #有問題
       #No.FUN-550067 ---end---
               ROLLBACK WORK   #No:7829
               CONTINUE WHILE
            END IF
            DISPLAY BY NAME g_sfc.sfc01
#       END IF   #No.FUN-550067
        
          INSERT INTO sfc_file VALUES(g_sfc.*)       # DISK WRITE
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_sfc.sfc01,SQLCA.sqlcode,0)   #No.FUN-660128
             CALL cl_err3("ins","sfc_file",g_sfc.sfc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
             ROLLBACK WORK   #No:7829
             CONTINUE WHILE
          END IF   
          COMMIT WORK     #No:7829
          CALL cl_flow_notify(g_sfc.sfc01,'I')
          LET g_sfc_t.* = g_sfc.*                # 保存上筆資料
          SELECT sfc01 INTO g_sfc.sfc01 FROM sfc_file
           WHERE sfc01 = g_sfc.sfc01
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i410_i(p_cmd)
  DEFINE li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_cmd           LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(70)
#       l_sfc01         VARCHAR(3),
        l_sfc01         LIKE oay_file.oayslip,        # Prog. Version..: '5.30.06-13.03.12(05)#No.FUN-550067
        l_desc          LIKE smy_file.smydesc,
        l_n             LIKE type_file.num5           #No.FUN-680121 SMALLINT
 
    DISPLAY BY NAME
        g_sfc.sfc01,g_sfc.sfc02,
        g_sfc.sfcuser,g_sfc.sfcgrup,g_sfc.sfcmodu,g_sfc.sfcdate,g_sfc.sfcacti
    INPUT BY NAME g_sfc.sfcoriu,g_sfc.sfcorig,
        g_sfc.sfc01,g_sfc.sfc02,
        g_sfc.sfcuser,g_sfc.sfcgrup,g_sfc.sfcmodu,g_sfc.sfcdate,g_sfc.sfcacti
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i410_set_entry(p_cmd)
            CALL i410_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550067 --start--
         CALL cl_set_docno_format("sfc01")
         #No.FUN-550067 ---end---
 
        AFTER FIELD sfc01
        #No.FUN-550067 --start--
         IF g_sfc.sfc01 != g_sfc01_t OR g_sfc01_t IS NULL THEN
            CALL s_check_no("asf",g_sfc.sfc01,g_sfc01_t,"8","sfc_file","sfc01","")
            RETURNING li_result,g_sfc.sfc01
            DISPLAY BY NAME g_sfc.sfc01
            IF (NOT li_result) THEN
               LET g_sfc.sfc01=g_sfc01_t
               NEXT FIELD sfc01
            END IF
#           DISPLAY g_smy.smydesc TO smydesc      #No.TQC-740125 mark
            DISPLAY g_smy.smydesc TO FORMONLY.d1  #No.TQC-740125
 
#           IF NOT cl_null(g_sfc.sfc01) THEN
#              LET g_sfc.sfc01[4,4] = '-'
#              LET g_t1=g_sfc.sfc01[1,3]
#              IF cl_null(g_sfc.sfc01[5,10]) THEN
#                 CALL s_mfgslip(g_t1,'asf','8')    #檢查單別
#                 IF NOT cl_null(g_errno) THEN             #抱歉, 有問題
#                     CALL cl_err(g_t1,g_errno,0)
#                     NEXT FIELD sfc01
#                 END IF
#              END IF
#              IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
#                (p_cmd = "u" AND g_sfc.sfc01 != g_sfc01_t) THEN
#                  #進行輸入之單號檢查
#                  CALL s_mfgchno(g_sfc.sfc01) RETURNING g_i,g_sfc.sfc01
#                  DISPLAY BY NAME g_sfc.sfc01
#                  IF NOT g_i THEN NEXT FIELD sfc01 END IF
#                  SELECT count(*) INTO l_n FROM sfc_file
#                      WHERE sfc01 = g_sfc.sfc01
#                  IF l_n > 0 THEN                  # Duplicated
#                      CALL cl_err(g_sfc.sfc01,-239,0)
#                      LET g_sfc.sfc01 = g_sfc01_t
#                      DISPLAY BY NAME g_sfc.sfc01
#                      NEXT FIELD sfc01
#                  END IF
#              END IF
#              LET l_desc = ' '
#              LET l_sfc01 = g_sfc.sfc01[1,3]
#              SELECT smydesc INTO l_desc FROM smy_file
#                     WHERE smyslip = l_sfc01
#              DISPLAY l_desc TO FORMONLY.d1
         #No.FUN-550067 ---end---
            END IF
        AFTER INPUT    #97/06/03 modify
           LET g_sfc.sfcuser = s_get_data_owner("sfc_file") #FUN-C10039
           LET g_sfc.sfcgrup = s_get_data_group("sfc_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(sfc01)
                 #CALL q_smy(FALSE,FALSE,g_t1,'asf','8') RETURNING g_t1  #TQC-670008
                 CALL q_smy(FALSE,FALSE,g_t1,'ASF','8') RETURNING g_t1   #TQC-670008
#                 CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                 LET g_sfc.sfc01[1,3]=g_t1
                  LET g_sfc.sfc01=g_t1        #No.FUN-550067
#                 LET g_sfc.sfc01[4,4]='-'    #No.FUN-550067
                  DISPLAY BY NAME g_sfc.sfc01
           END CASE
 
        ON ACTION mntn_doc_pty
               LET l_cmd="asmi300", " '",g_sfc.sfc01 clipped,"'"
               CALL cl_cmdrun(l_cmd)
 
       #MOD-650015 --start
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(sfc01) THEN
        #        LET g_sfc.* = g_sfc_t.*
        #        DISPLAY BY NAME g_sfc.*
        #        NEXT FIELD sfc01
        #    END IF
       #MOD-650015 --end
 
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
 
    END INPUT
END FUNCTION
 
FUNCTION i410_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sfc.* TO NULL               #No.FUN-6A0164
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i410_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
        OPEN i410_count
        FETCH i410_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i410_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfc.sfc01,SQLCA.sqlcode,0)
        INITIALIZE g_sfc.* TO NULL
    ELSE
        CALL i410_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i410_fetch(p_flsfc)
    DEFINE
        p_flsfc         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680121 INTEGER
 
    CASE p_flsfc
        WHEN 'N' FETCH NEXT     i410_cs INTO g_sfc.sfc01
        WHEN 'P' FETCH PREVIOUS i410_cs INTO g_sfc.sfc01
        WHEN 'F' FETCH FIRST    i410_cs INTO g_sfc.sfc01
        WHEN 'L' FETCH LAST     i410_cs INTO g_sfc.sfc01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i410_cs INTO g_sfc.sfc01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfc.sfc01,SQLCA.sqlcode,0)
        INITIALIZE g_sfc.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsfc
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_sfc.* FROM sfc_file            # 重讀DB,因TEMP有不被更新特性
       WHERE sfc01 = g_sfc.sfc01
       
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_sfc.sfc01,SQLCA.sqlcode,0)   #No.FUN-660128
        CALL cl_err3("sel","sfc_file",g_sfc.sfc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
    ELSE
        LET g_data_owner = g_sfc.sfcuser      #FUN-4C0035
        LET g_data_group = g_sfc.sfcgrup      #FUN-4C0035
        CALL i410_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i410_show()
    DEFINE
       l_desc     LIKE smy_file.smydesc,
       l_sfc01    LIKE oea_file.oea01             #No.FUN-680121 VARCHAR(16) #No.FUN-550067

    LET g_sfc_t.* = g_sfc.*
        
    DISPLAY BY NAME g_sfc.sfc01, g_sfc.sfcoriu,g_sfc.sfcorig
#   LET l_sfc01 = g_sfc.sfc01[1,3]
    LET l_sfc01 = s_get_doc_no(g_sfc.sfc01)       #No.FUN-550067
    SELECT smydesc INTO l_desc FROM smy_file
                 WHERE smyslip = l_sfc01
    DISPLAY l_desc TO FORMONLY.d1
    DISPLAY BY NAME g_sfc.sfc02
    DISPLAY BY NAME g_sfc.sfcuser
    DISPLAY BY NAME g_sfc.sfcgrup   #No.TQC-790077
    DISPLAY BY NAME g_sfc.sfcmodu
    DISPLAY BY NAME g_sfc.sfcdate
    DISPLAY BY NAME g_sfc.sfcacti
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i410_u()
    DEFINE l_flag LIKE type_file.chr1         #NO.fun-7b0018
    IF s_shut(0) THEN RETURN END IF
    IF g_sfc.sfc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_sfc.* FROM sfc_file WHERE sfc01 = g_sfc.sfc01
    IF g_sfc.sfcacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_sfc01_t = g_sfc.sfc01
    BEGIN WORK
   
    OPEN i410_cl USING g_sfc.sfc01
 
    IF STATUS THEN
       CALL cl_err("OPEN i410_cl:", STATUS, 1)
       CLOSE i410_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i410_cl INTO g_sfc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfc.sfc01,SQLCA.sqlcode,0)
        RETURN
    END IF
 
 
    LET g_sfc.sfcmodu=g_user                     #修改者
    LET g_sfc.sfcdate = g_today                  #修改日期
    CALL i410_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i410_i("u")                      # 欄位更改
        IF INT_FLAG THEN
          if g_bb = 'Y' then
            DELETE FROM sfc_file where sfc01 = g_sfc01_t
            let g_bb = "N"
            let INT_FLAG = 0
            exit while
          else
            LET INT_FLAG = 0
            LET g_sfc.*=g_sfc_t.*
            CALL i410_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
          end if
        END IF
        UPDATE sfc_file SET sfc_file.* = g_sfc.*    # 更新DB
            WHERE sfc01 = g_sfc_t.sfc01             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_sfc.sfc01,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","sfc_file",g_sfc01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            CONTINUE WHILE
        END IF
       EXIT WHILE
    END WHILE
    CLOSE i410_cl
    
    COMMIT WORK
    CALL cl_flow_notify(g_sfc.sfc01,'U')
END FUNCTION
 
FUNCTION i410_x()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_sfc.sfc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i410_cl USING g_sfc.sfc01
 
    IF STATUS THEN
       CALL cl_err("OPEN i410_cl:", STATUS, 1)
       CLOSE i410_cl
 
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i410_cl INTO g_sfc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfc.sfc01,SQLCA.sqlcode,0)
       RETURN
    END IF
 
    
    CALL i410_show()
 
    IF cl_exp(0,0,g_sfc.sfcacti) THEN
        LET g_chr=g_sfc.sfcacti
        IF g_sfc.sfcacti='Y' THEN
            LET g_sfc.sfcacti='N'
        ELSE
            LET g_sfc.sfcacti='Y'
        END IF
        UPDATE sfc_file
            SET sfcacti=g_sfc.sfcacti
            WHERE sfc01=g_sfc.sfc01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_sfc.sfc01,SQLCA.sqlcode,0)   #No.FUN-660128
            CALL cl_err3("upd","sfc_file",g_sfc01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            LET g_sfc.sfcacti=g_chr
        END IF
        DISPLAY BY NAME g_sfc.sfcacti
    END IF
 
    CLOSE i410_cl
 
    COMMIT WORK
    CALL cl_flow_notify(g_sfc.sfc01,'V')
 
END FUNCTION
 
FUNCTION i410_r()
    DEFINE
       l_sfb01       like   sfb_file.sfb01,
       l_sfb39       like   sfb_file.sfb39,
       l_sfb04       like   sfb_file.sfb04,
       l_sfa06       like   sfa_file.sfa06,
       l_sfa061      like   sfa_file.sfa061
DEFINE l_cnt         LIKE type_file.num5             #No.MOD-780177 add
    IF s_shut(0) THEN RETURN END IF
 
    IF g_sfc.sfc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
#TQC-970108 --begin--
    IF g_sfc.sfcacti = 'N' THEN
       CALL cl_err('','abm-033',0)
       RETURN
    END IF 
#TQC-970108 --end--
    
    BEGIN WORK
 
    OPEN i410_cl USING g_sfc.sfc01
    IF STATUS THEN
       CALL cl_err("OPEN i410_cl:", STATUS, 1)
       CLOSE i410_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i410_cl INTO g_sfc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfc.sfc01,SQLCA.sqlcode,0)
       RETURN
    END IF
 
    
    CALL i410_show()
 
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sfc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sfc.sfc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
 
     DECLARE sfb85_cur CURSOR FOR SELECT sfb01 FROM sfb_file
             WHERE sfb85 = g_sfc.sfc01 AND sfb87!='X'
     FOREACH sfb85_cur INTO l_sfb01
        IF SQLCA.sqlcode = 0 THEN    #找到sfb_file中的工單單號
             SELECT sfb39,sfb04 INTO l_sfb39,l_sfb04 FROM sfb_file
                   WHERE sfb01 = l_sfb01
             IF l_sfb39 = '1' THEN     #發料
                DECLARE sfa_cur CURSOR FOR SELECT sfa06
                    FROM sfa_file WHERE sfa01 = l_sfb01
                FOREACH sfa_cur INTO l_sfa06
                    IF l_sfa06 > 0 THEN #已有發料量,不可刪除
                        CALL cl_err('','asf-417',0)   #No.FUN-660128
                       RETURN
                    END IF
                END FOREACH
                CONTINUE FOREACH      # sfb85_cur
                IF s_delsfc(0,0) THEN
                   EXIT FOREACH
                ELSE
                   RETURN
                END IF
             END IF
             IF l_sfb39 = '2' THEN     #領料
                DECLARE sfa_cur1 CURSOR FOR SELECT sfa061
                    FROM sfa_file WHERE sfa01 = l_sfb01
                FOREACH sfa_cur1 INTO l_sfa061
                    IF l_sfa061 > 0 THEN #已有領料量,不可刪除
                       CALL cl_err('','asf-417',0)
                       RETURN
                    END IF
                END FOREACH
                CONTINUE FOREACH    # sfb85_cur
                IF s_delsfc(0,0) THEN
                   EXIT FOREACH
                ELSE
                   RETURN
                END IF
             END If
             IF l_sfb04 = '8' THEN
                IF s_delsfc(0,0) THEN
                   EXIT FOREACH
                ELSE
                   RETURN
                END If
             END IF
         END IF
      END FOREACH
 
     #------------No.MOD-780177 add
      SELECT COUNT(*) INTO l_cnt FROM sfd_file WHERE sfd01 = g_sfc.sfc01
      IF l_cnt > 0 THEN
         CALL cl_err(g_sfc.sfc01,'asf-422',1)
         RETURN
      END IF   
     #------------No.MOD-780177 end
 
      DELETE FROM sfc_file WHERE sfc01 = g_sfc.sfc01
      CLEAR FORM
      OPEN i410_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i410_cs
         CLOSE i410_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      FETCH i410_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i410_cs
         CLOSE i410_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i410_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i410_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i410_fetch('/')
      END IF
 
    END IF
 
    CLOSE i410_cl
 
 
    COMMIT WORK
    CALL cl_flow_notify(g_sfc.sfc01,'D')
 
END FUNCTION
 
FUNCTION i410_copy()
    DEFINE li_result LIKE type_file.num5      #No.FUN-550067        #No.FUN-680121 SMALLINT
    DEFINE l_newno   LIKE sfc_file.sfc01,
           l_oldno   LIKE sfc_file.sfc01,
#          l_sfc01   VARCHAR(3),
           l_sfc01   LIKE oea_file.oea01,     #No.FUN-680121 VARCHAR(16) #No.FUN-550067
           l_desc    LIKE smy_file.smydesc
    IF s_shut(0) THEN RETURN END IF
    LET l_oldno = g_sfc.sfc01
    IF g_sfc.sfc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    DISPLAY "" AT 1,1
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    DISPLAY g_msg AT 2,1
 
    BEGIN WORK  #No:7829
 
    LET g_before_input_done = FALSE
    CALL i410_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM sfc01
        AFTER FIELD sfc01
        #No.FUN-550067 --start--
         IF g_sfc.sfc01 != g_sfc01_t OR g_sfc01_t IS NULL THEN
 #           CALL s_check_no("asf",g_sfc.sfc01,g_sfc01_t,"8","sfc_file","sfc01","")
            CALL s_check_no("asf",l_newno,g_sfc01_t,"8","sfc_file","sfc01","")  #No.FUN-870117
            RETURNING li_result,g_sfc.sfc01
            DISPLAY BY NAME g_sfc.sfc01
            IF (NOT li_result) THEN
               LET g_sfc.sfc01=g_sfc01_t
               NEXT FIELD sfc01
            END IF
#           DISPLAY g_smy.smydesc TO smydesc      #No.TQC-740125 mark
            DISPLAY g_smy.smydesc TO FORMONLY.d1  #No.TQC-740125
 
#           IF NOT cl_null(l_newno) THEN
#              LET g_t1=l_newno[1,3]
#              CALL s_mfgslip(g_t1,'asf','8')    #檢查單別
#              IF NOT cl_null(g_errno) THEN             #抱歉, 有問題
#                  CALL cl_err(g_t1,g_errno,0)
#                  NEXT FIELD sfc01
#              END IF
#
#              #新增並要不自動編號,並且單號空白時,請使用者自行輸入
#              IF g_smy.smyauno = 'N' THEN
#                 IF NOT cl_null(l_newno[1,3]) AND cl_null(l_newno[5,10]) THEN
#                     NEXT FIELD sfc01
#                  END IF
#              END IF
#              IF NOT cl_null(l_newno[1,3]) AND cl_null(l_newno[5,10]) AND
#                 g_smy.smyauno='Y' THEN
#                 CALL s_smyauno(l_newno,g_today) RETURNING g_i,g_sfc.sfc01
#                 LET l_newno = g_sfc.sfc01
#                 IF g_i THEN NEXT FIELD sfc01 END IF    #有問題
#                 DISPLAY BY NAME g_sfc.sfc01
#
#                 SELECT count(*) INTO g_cnt FROM sfc_file
#                  WHERE sfc01 = l_newno
#                 IF g_cnt > 0 THEN
#                    CALL cl_err(l_newno,-239,0)
#                    NEXT FIELD sfc01
#                 END IF
#              END IF
#              LET l_desc = ' '
#              LET l_sfc01 = g_sfc.sfc01[1,3]
#              SELECT smydesc INTO l_desc FROM smy_file
#               WHERE smyslip = l_sfc01
#              DISPLAY l_desc TO FORMONLY.d1
 
            END IF
#No.TQC-740341 -- begin --
        ON ACTION controlp
           CASE
              WHEN INFIELD(sfc01)
                 CALL q_smy(FALSE ,FALSE,g_t1,'ASF','8') RETURNING g_t1
                 LET g_sfc.sfc01=g_t1
                 LET g_sfc.sfc01[g_doc_len+1,g_doc_len+1]='-'
                 LET l_newno = g_sfc.sfc01
                 DISPLAY  l_newno TO sfc01
           END CASE
#No.TQC-740341 -- end --
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_aa = "N"
        DISPLAY l_oldno TO sfc01
 #       initialize g_sfc.* to null   #No.FUN-870117
        ROLLBACK WORK   #No:7829
        RETURN
 
    ELSE
        LET g_aa = "Y"
        CALL s_auto_assign_no("asf",l_newno,g_today,"8","sfc_file","sfc01","","","")
        RETURNING li_result,l_newno
    END IF
    IF g_aa = "Y" THEN
       DROP TABLE x
       SELECT * FROM sfc_file
           WHERE sfc01=g_sfc.sfc01
           INTO TEMP x
       UPDATE x
           SET sfc01=l_newno,    #資料鍵值
               sfcacti='Y',      #資料有效碼
               sfcuser=g_user,   #資料所有者
               sfcgrup=g_grup,   #資料所有者所屬群
               sfcmodu=NULL,     #資料修改日期
               sfcdate=g_today   #資料建立日期
       INSERT INTO sfc_file
           SELECT * FROM x
       IF SQLCA.sqlcode THEN
#          CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660128
           CALL cl_err3("ins","sfc_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
           ROLLBACK WORK   #No:7829
           RETURN
       END IF
       COMMIT WORK
       LET g_cnt=SQLCA.SQLERRD[3]
       MESSAGE 'ROW(',l_newno,') O.K'
       LET g_sfc.sfc01 = l_newno
       SELECT sfc_file.* INTO g_sfc.* FROM sfc_file
               WHERE sfc01 = l_newno
      let g_bb = "Y"        #若按DEL鍵,到u()中可DELETE新值
 
       CALL i410_u()
       #FUN-C80046---begin
       #SELECT sfc_file.* INTO g_sfc.* FROM sfc_file
       #         WHERE sfc01 = l_oldno
       #LET g_sfc.sfc01 = l_oldno
       #CALL i410_show()
       #FUN-C80046---end
       MESSAGE ' '
    END IF
 
END FUNCTION
 
FUNCTION i410_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_sfc           RECORD LIKE sfc_file.*,
        l_name          LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20) # External(Disk) file name
        sr RECORD
                sfc01 LIKE sfc_file.sfc01, #料表批號
                sfc02 LIKE sfc_file.sfc02  #描述
           END RECORD,
        l_za05          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(40)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
    LET l_name = 'asfi410.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'asfi410'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT sfc01,sfc02 ",
              " FROM sfc_file ",
              " WHERE ",
              g_wc CLIPPED
    PREPARE i410_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i410_curo                         # SCROLL CURSOR
        CURSOR FOR i410_p1
 
    START REPORT i410_rep TO l_name
 
    FOREACH i410_curo INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT i410_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i410_rep
 
    CLOSE i410_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i410_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        sr RECORD
                sfc01 LIKE sfc_file.sfc01,
                sfc02 LIKE sfc_file.sfc02
           END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.sfc01
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT ' '
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT COLUMN 6,g_x[11] CLIPPED ,COLUMN 17,g_x[12] CLIPPED
            PRINT '     ---------- -------------------------------',
                  '------------------------------'
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN 6,sr.sfc01,COLUMN 17,sr.sfc02
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
FUNCTION i410_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sfc01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i410_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("sfc01",FALSE)
   END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
 

