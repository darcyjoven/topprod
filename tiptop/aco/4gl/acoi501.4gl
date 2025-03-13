# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: acoi501.4gl
# Descriptions...: 進口材料明細資料維護作業
# Date & Author..: 00/06/15 By Kammy
# Modify.........: No.MOD-490398 04/11/22 By Carrier
#                  新增海關編號 cop10-->1/2/3/4/5/6/7
# Modify.........: No.MOD-530224 05/03/29 By Carrier add cop21/cop22
# Modify.........: No.FUN-550036 05/05/23 By Trisy 單據編號加大
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660045 06/06/12 By Carrier cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-690024 06/09/14 By jamie 判斷pmcacti
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/08 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.CHI-A80036 10/08/30 By wuxj  整批确认时应对所有资料做检查 
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改 
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.TQC-B10069 11/01/18 By lixh1  整批確認時,使用彙總訊息方式呈現批次確認範圍內的所有錯誤訊息
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BB0083 11/12/26 By xujing 增加數量欄位小數取位 cop_file

DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE
    g_cop   RECORD LIKE cop_file.*,
    g_cop_t RECORD LIKE cop_file.*,
    g_cop01_t LIKE cop_file.cop01,
    g_cop02_t LIKE cop_file.cop02,
    l_ac                LIKE type_file.num5,          #No.FUN-680069 SMALLINT
     g_wc,g_wc2,g_sql   STRING  #No.FUN-580092 HCN        #No.FUN-680069
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE   g_before_input_done   STRING     #No.FUN-680069
DEFINE   g_chr          LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
#CKP3
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_cop15_t      LIKE cop_file.cop15          #FUN-BB0083 add
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680069 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0063
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
    INITIALIZE g_cop.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM cop_file WHERE cop01 = ?  AND cop02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i501_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW i501_w AT p_row,p_col WITH FORM "aco/42f/acoi501"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL i501_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i501_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION i501_curs()
    CLEAR FORM
   INITIALIZE g_cop.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                      # 螢幕上取條件
         #No.MOD-490398
        cop01,cop02,cop03,cop05,cop06,cop04,cop14,cop15,cop12,
         copconf,cop20,cop22,cop19,cop11,cop07,cop08,cop18,cop09, #No.MOD-530224
         cop21,cop16,cop17, #No.MOD-530224
        cop10,copuser,copgrup,copmodu,copdate,copacti,
       #FUN-840202   ---start---
        copud01,copud02,copud03,copud04,copud05,
        copud06,copud07,copud08,copud09,copud10,
        copud11,copud12,copud13,copud14,copud15
       #FUN-840202    ----end----
         #No.MOD-490398 end
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
              WHEN INFIELD(cop05)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_pmc"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cop05
              WHEN INFIELD(cop04)
#FUN-AA0059 --Begin--
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.state= "c"
             #   LET g_qryparam.form = "q_ima"
             #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO cop04
              WHEN INFIELD(cop15)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_gfe"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cop15
               #No.MOD-490398
              WHEN INFIELD(cop11) #商品編號
                CALL cl_init_qry_var()
                LET g_qryparam.state ="c"
                LET g_qryparam.form ="q_cob"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cop11
                NEXT FIELD cop11
              WHEN INFIELD(cop09)      #合同編號
                CALL q_coc2(TRUE,TRUE,g_cop.cop18,g_cop.cop11,
                            g_cop.cop03,'1',g_cop.cop19,g_cop.cop04)
                     RETURNING g_cop.cop18
                SELECT coc04 INTO g_cop.cop09 FROM coc_file
                 WHERE coc03 = g_cop.cop18
                DISPLAY BY NAME g_cop.cop09
                NEXT FIELD cop09
              WHEN INFIELD(cop18)      #手冊編號
                CALL q_coc2(TRUE,TRUE,g_cop.cop18,g_cop.cop11,
                            g_cop.cop03,'1',g_cop.cop19,g_cop.cop04)
                     RETURNING g_cop.cop18
                DISPLAY BY NAME g_cop.cop18
                NEXT FIELD cop18
              WHEN INFIELD(cop19)      #海關代號
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_cna"
                LET g_qryparam.default1 = g_cop.cop19
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cop19
                NEXT FIELD cop19
               #No.MOD-490398 end
              OTHERWISE EXIT CASE
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
    IF INT_FLAG THEN RETURN END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND copuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND copgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND copgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('copuser', 'copgrup')
    #End:FUN-980030
 
 
 
    LET g_sql="SELECT cop01,cop02 FROM cop_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY cop01,cop02"
    PREPARE i501_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i501_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i501_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cop_file WHERE ",g_wc CLIPPED
    PREPARE i501_precount FROM g_sql
    DECLARE i501_count CURSOR FOR i501_precount
END FUNCTION
 
FUNCTION i501_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
 
#       ON ACTION insert
#           LET g_action_choice="insert"
#           IF cl_chk_act_auth() THEN
#                CALL i501_a()
#           END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i501_q()
            END IF
        ON ACTION next
            CALL i501_fetch('N')
        ON ACTION previous
            CALL i501_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i501_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i501_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i501_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()    #TQC-B10069
               CALL i501_y()
               CALL s_showmsg()         #TQC-B10069
            END IF
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i501_z()
            END IF
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
            CALL i501_fetch('/')
        ON ACTION first
            CALL i501_fetch('F')
        ON ACTION last
            CALL i501_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0168-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_cop.cop01 IS NOT NULL THEN            
                  LET g_doc.column1 = "cop01"               
                  LET g_doc.column2 = "cop02"               
                  LET g_doc.value1 = g_cop.cop01            
                  LET g_doc.value2 = g_cop.cop02           
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
         #No.FUN-6A0168-------add--------end---- 
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
    CLOSE i501_cs
END FUNCTION
 
 
 
FUNCTION i501_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_cop.* LIKE cop_file.*
    LET g_cop01_t = NULL
    LET g_cop02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cop.cop03 = g_today
        LET g_cop.cop20 = 'N'
        LET g_cop.copconf = 'N'
         LET g_cop.cop22   = 'N' #No.MOD-530224
        LET g_cop.copuser = g_user
        LET g_cop.coporiu = g_user #FUN-980030
        LET g_cop.coporig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_cop.copgrup = g_grup               #用戶所屬群
        LET g_cop.copdate = g_today
        LET g_cop.copacti = 'Y'
        LET g_cop.cop10 = '1'
        LET g_cop.copplant = g_plant  #FUN-980002
        LET g_cop.coplegal = g_legal  #FUN-980002
 
        CALL i501_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_cop.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_cop.cop01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO cop_file VALUES(g_cop.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            #CALL cl_err(g_cop.cop01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("ins","cop_file",g_cop.cop01,g_cop.cop02,SQLCA.sqlcode,"","",1) #No.TQC-660045
            CONTINUE WHILE
        ELSE
            SELECT cop01,cop02 INTO g_cop.cop01,g_cop.cop02 FROM cop_file
                     WHERE cop01 = g_cop.cop01
                       AND cop02 = g_cop.cop02
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i501_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
        l_coa04         LIKE coa_file.coa04,      #No.MOD-490398
        l_n             LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    INPUT BY NAME g_cop.coporiu,g_cop.coporig,
        g_cop.cop01,g_cop.cop02,g_cop.cop03,g_cop.cop05,g_cop.cop06,
        g_cop.cop04,g_cop.cop14,g_cop.cop15,
         g_cop.copconf,g_cop.cop20,g_cop.cop22,g_cop.cop12, #No:BUG-490398 #No.MOD-530224
        g_cop.cop19,g_cop.cop11,g_cop.cop07,
        g_cop.cop08,g_cop.cop18,g_cop.cop09,
         g_cop.cop21,#No.MOD-530224
         g_cop.cop16,g_cop.cop17,g_cop.cop10,                 #No.MOD-490398 end
        g_cop.copuser,g_cop.copgrup,g_cop.copmodu,g_cop.copdate,g_cop.copacti,
       #FUN-840202     ---start---
        g_cop.copud01,g_cop.copud02,g_cop.copud03,g_cop.copud04,
        g_cop.copud05,g_cop.copud06,g_cop.copud07,g_cop.copud08,
        g_cop.copud09,g_cop.copud10,g_cop.copud11,g_cop.copud12,
        g_cop.copud13,g_cop.copud14,g_cop.copud15
       #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i501_set_entry(p_cmd)
           CALL i501_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
         #No.FUN-550036 --start--
         CALL cl_set_docno_format("cop01")
         CALL cl_set_docno_format("cop07")
         #No.FUN-550036 ---end---
         #FUN-BB0083---add---str
         IF p_cmd = 'a' THEN
            LET g_cop15_t = NULL
         END IF
         IF p_cmd = 'u' THEN
            LET g_cop15_t = g_cop.cop15
         END IF
         #FUN-BB0083---add---end
 
        BEFORE FIELD cop02
            IF p_cmd = 'u' AND g_chkey = 'N' THEN
               NEXT FIELD cop03
            END IF
            IF cl_null(g_cop.cop02) THEN
               SELECT MAX(cop02)+1 INTO g_cop.cop02 FROM cop_file
                WHERE cop01 = g_cop.cop01
               IF cl_null(g_cop.cop02) THEN LET g_cop.cop02 = 1 END IF
               DISPLAY BY NAME g_cop.cop02
            END IF
 
        AFTER FIELD cop02
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND (g_cop.cop01 != g_cop01_t
               OR g_cop.cop02 != g_cop02_t )) THEN
                SELECT count(*) INTO l_n FROM cop_file
                    WHERE cop01 = g_cop.cop01
                      AND cop02 = g_cop.cop02
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_cop.cop01,-239,0)
                    LET g_cop.cop01 = g_cop01_t
                    LET g_cop.cop02 = g_cop02_t
                    DISPLAY BY NAME g_cop.cop01
                    DISPLAY BY NAME g_cop.cop02
                    NEXT FIELD cop01
                END IF
            END IF
 
        AFTER FIELD cop05
          IF g_cop.cop05 IS NOT NULL THEN
            CALL i501_cop05('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cop.cop05,g_errno,0)
               LET g_cop.cop05 = g_cop_t.cop05
               DISPLAY BY NAME g_cop.cop05
               NEXT FIELD cop05
            END IF
          END IF
 
        AFTER FIELD cop04
            IF g_cop.cop04 IS NOT NULL THEN
               #FUN-AA0059 --------------------------add start--------------------
               IF NOT s_chk_item_no(g_cop.cop04,'') THEN
                  CALL cl_err('',g_errno,1)
                  LET g_cop.cop04 = g_cop_t.cop04
                  DISPLAY BY NAME g_cop.cop04
                  NEXT FIELD cop04
               END IF 
               #FUN-AA0059 -------------------------add end----------------------   
               CALL i501_cop04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_cop.cop04,g_errno,0)
                  LET g_cop.cop04 = g_cop_t.cop04
                  DISPLAY BY NAME g_cop.cop04
                  NEXT FIELD cop04
               END IF
            END IF
 
        AFTER FIELD cop14
           #FUN-BB0083---add---str
            IF NOT i501_cop14_check() THEN
               NEXT FIELD cop14               
            END IF
           #FUN-BB0083---add---end
          #FUN-BB0083---mark---str  
          #IF g_cop.cop14 IS NOT NULL THEN
          #  IF g_cop.cop14 < 0 THEN NEXT FIELD cop14 END IF
          #END IF
          #FUN-BB0083---mark---end
 
        AFTER FIELD cop15
          IF g_cop.cop15 IS NOT NULL THEN
            CALL i501_gfe(g_cop.cop15)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cop.cop15,g_errno,0)
               NEXT FIELD cop15
            END IF
            #FUN-BB0083---add---str
            IF NOT i501_cop14_check() THEN
               LET g_cop15_t = g_cop.cop15
               NEXT FIELD cop14               
            END IF
            LET g_cop15_t = g_cop.cop15
            #FUN-BB0083---add---end
          END IF
 
        AFTER FIELD cop11
          IF g_cop.cop11 IS NOT NULL THEN
               CALL i501_cop11('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_cop.cop11,g_errno,0)
                  LET g_cop.cop11 = g_cop_t.cop11
                  DISPLAY BY NAME g_cop.cop11
                   NEXT FIELD cop11                #No.MOD-490398
               END IF
          END IF
 
         #No.MOD-490398
        AFTER FIELD cop09
          IF NOT cl_null(g_cop.cop09) THEN
             SELECT coc04 FROM coc_file WHERE coc04 = g_cop.cop09
             IF STATUS THEN
                #No.TQC-660045  --Begin
                #CALL cl_err(g_cop.cop09,'aco-026',0) #No.TQC-660045
                CALL cl_err3("sel","coc_file",g_cop.cop09,"","aco-026","","",1) 
                NEXT FIELD cop09
                #No.TQC-660045  --End  
             END IF
             CALL i501_cop09_cop18('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_cop.cop09,g_errno,0)
                NEXT FIELD cop09
             END IF
          END IF
 
        AFTER FIELD cop18
          IF NOT cl_null(g_cop.cop18) THEN
             SELECT coc03 FROM coc_file WHERE coc03 = g_cop.cop18
             IF STATUS THEN
                #No.TQC-660045 --Begin
                #CALL cl_err(g_cop.cop18,'aco-062',0) #No.TQC-660045
                CALL cl_err3("sel","coc_file",g_cop.cop18,"","aco-062","","",1) 
                NEXT FIELD cop18
                #No.TQC-660045 --End  
             END IF
             CALL i501_cop09_cop18('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_cop.cop18,g_errno,0)
                NEXT FIELD cop18
             END IF
          END IF
         #No.MOD-490398 end
 
         #No.MOD-490398 --begin
        #AFTER FIELD cop10
        #    IF g_cop.cop10 NOT MATCHES '[123]' THEN
        #       NEXT FIELD cop10
        #    END IF
         #No.MOD-490398 --end
 
         #No.MOD-490398
        AFTER FIELD cop19               #海關代號
            IF NOT cl_null(g_cop.cop19) THEN
              CALL i501_cop19('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_cop.cop19,g_errno,0)
                 NEXT FIELD cop19
              END IF
            END IF
         #No.MOD-490398  end
 
        #FUN-840202     ---start---
        AFTER FIELD copud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD copud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        #FUN-840202     ----end----
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
              WHEN INFIELD(cop05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmc"
                LET g_qryparam.default1 = g_cop.cop05
                CALL cl_create_qry() RETURNING g_cop.cop05
#                CALL FGL_DIALOG_SETBUFFER( g_cop.cop05 )
                DISPLAY BY NAME g_cop.cop05
              WHEN INFIELD(cop04)
#FUN-AA0059 --Begin--
              #  CALL cl_init_qry_var()
              #  LET g_qryparam.form = "q_ima"
              #  LET g_qryparam.default1 = g_cop.cop04
              #  CALL cl_create_qry() RETURNING g_cop.cop04
                 CALL q_sel_ima(FALSE, "q_ima", "",g_cop.cop04, "", "", "", "" ,"",'' )  RETURNING g_cop.cop04
#FUN-AA0059 --End--
#                CALL FGL_DIALOG_SETBUFFER( g_cop.cop04 )
                DISPLAY BY NAME g_cop.cop04
              WHEN INFIELD(cop15)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_cop.cop15
                CALL cl_create_qry() RETURNING g_cop.cop15
#                CALL FGL_DIALOG_SETBUFFER( g_cop.cop15 )
                DISPLAY BY NAME g_cop.cop15
               #No.MOD-490398
              WHEN INFIELD(cop11) #商品編號
                CALL q_coa(FALSE,FALSE,g_cop.cop11,l_coa04,g_cop.cop04,
                           g_cop.cop19)
                     RETURNING g_cop.cop11,l_coa04
                DISPLAY BY NAME g_cop.cop11
                NEXT FIELD cop11
              WHEN INFIELD(cop09)          #合同編號
                CALL q_coc2(FALSE,FALSE,g_cop.cop18,g_cop.cop11,
                            g_cop.cop03,'1',g_cop.cop19,g_cop.cop04)
                     RETURNING g_cop.cop18,g_cop.cop09
                DISPLAY BY NAME g_cop.cop09,g_cop.cop18
                NEXT FIELD cop09
              WHEN INFIELD(cop18)          #手冊編號
                CALL q_coc2(FALSE,FALSE,g_cop.cop18,g_cop.cop11,
                            g_cop.cop03,'1',g_cop.cop19,g_cop.cop04)
                     RETURNING g_cop.cop18,g_cop.cop09
                DISPLAY BY NAME g_cop.cop09,g_cop.cop18
                NEXT FIELD cop18
              WHEN INFIELD(cop19)          #海關代號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cna"
                LET g_qryparam.default1 = g_cop.cop19
                CALL cl_create_qry() RETURNING g_cop.cop19
#                CALL FGL_DIALOG_SETBUFFER( g_cop.cop19 )
                DISPLAY BY NAME g_cop.cop19
                NEXT FIELD cop19
               #No.MOD-490398  end
              OTHERWISE EXIT CASE
            END CASE
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(cop01) THEN
        #        LET g_cop.* = g_cop_t.*
        #        CALL i501_show()
        #        NEXT FIELD cop01
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
 #No.MOD-490398
FUNCTION i501_cop19(p_cmd)  #
    DEFINE l_cna02   LIKE cna_file.cna02,
           l_cnaacti LIKE cna_file.cnaacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
    LET g_errno = ' '
    SELECT cna02,cnaacti INTO l_cna02,l_cnaacti
      FROM cna_file WHERE cna01 = g_cop.cop19
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-016'
         WHEN l_cnaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 #No.MOD-490398 end
 
FUNCTION i501_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cop.* TO NULL                #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i501_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i501_count
    FETCH i501_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i501_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cop.cop01,SQLCA.sqlcode,0)
        INITIALIZE g_cop.* TO NULL
    ELSE
        CALL i501_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i501_fetch(p_flcop)
    DEFINE
        p_flcop          LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
        l_abso           LIKE type_file.num10         #No.FUN-680069 INTEGER
 
    CASE p_flcop
        WHEN 'N' FETCH NEXT     i501_cs INTO g_cop.cop01,g_cop.cop02
        WHEN 'P' FETCH PREVIOUS i501_cs INTO g_cop.cop01,g_cop.cop02
        WHEN 'F' FETCH FIRST    i501_cs INTO g_cop.cop01,g_cop.cop02
        WHEN 'L' FETCH LAST     i501_cs INTO g_cop.cop01,g_cop.cop02
        WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump i501_cs INTO g_cop.cop01,g_cop.cop02
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cop.cop01,SQLCA.sqlcode,0)
        INITIALIZE g_cop.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcop
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cop.* FROM cop_file            # 重讀DB,因TEMP有不被更新特性
       WHERE cop01 = g_cop.cop01 AND cop02 = g_cop.cop02
    IF SQLCA.sqlcode THEN
        #CALL cl_err(g_cop.cop01,SQLCA.sqlcode,0)  #No.TQC-660045
        CALL cl_err3("sel","cop_file",g_cop.cop01,g_cop.cop02,SQLCA.sqlcode,"","",1)  #No.TQC-660045
    ELSE
#       LET g_data_owner = g_cop.copuser
#       LET g_data_group = g_cop.copgrup
        CALL i501_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i501_show()
    LET g_cop_t.* = g_cop.*
    DISPLAY BY NAME g_cop.coporiu,g_cop.coporig,
        g_cop.cop01,g_cop.cop02,g_cop.cop03,g_cop.cop05,g_cop.cop06,
        g_cop.cop04,g_cop.cop14,g_cop.cop15,g_cop.cop11,
        g_cop.cop07,g_cop.cop08,g_cop.cop09,g_cop.cop18,
         g_cop.cop12,g_cop.cop19,               #No.MOD-490398
         g_cop.cop21,#No.MOD-530224
        g_cop.cop16,g_cop.cop17,g_cop.cop10,g_cop.copconf,g_cop.cop20,
         g_cop.cop22, #No.MOD-530224
        g_cop.copuser,g_cop.copgrup,g_cop.copmodu,g_cop.copdate,g_cop.copacti,
       #FUN-840202     ---start---
        g_cop.copud01,g_cop.copud02,g_cop.copud03,g_cop.copud04,
        g_cop.copud05,g_cop.copud06,g_cop.copud07,g_cop.copud08,
        g_cop.copud09,g_cop.copud10,g_cop.copud11,g_cop.copud12,
        g_cop.copud13,g_cop.copud14,g_cop.copud15
       #FUN-840202     ----end----
 
    CALL i501_cop04('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i501_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cop.cop01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_cop.* FROM cop_file
     WHERE cop01=g_cop.cop01 AND cop02=g_cop.cop02
    IF g_cop.copacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cop.copconf='Y' THEN RETURN END IF
     #No.MOD-530224  --begin
    IF g_cop.cop22 ='Y' THEN    #檢查資料是否衝帳
       CALL cl_err(g_msg,'aco-228',0) RETURN
    END IF
     #No.MOD-530224  --end
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cop01_t = g_cop.cop01
    BEGIN WORK
 
    OPEN i501_cl USING g_cop.cop01,g_cop.cop02
    IF STATUS THEN
       CALL cl_err("OPEN i501_cl:", STATUS, 1)
       CLOSE i501_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i501_cl INTO g_cop.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cop.cop01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_cop.copmodu=g_user                     #更改者
    LET g_cop.copdate = g_today                  #更改日期
    CALL i501_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i501_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cop.*=g_cop_t.*
            CALL i501_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cop_file SET cop_file.* = g_cop.*    # 更新DB
            WHERE cop01 = g_cop.cop01 AND cop02 = g_cop.cop02             # COLAUTH?
        IF SQLCA.sqlcode THEN
            #CALL cl_err(g_cop.cop01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cop_file",g_cop.cop01,g_cop.cop02,SQLCA.sqlcode,"","",1)  #No.TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i501_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i501_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cop.cop01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_cop.copconf='Y' THEN RETURN END IF
     #No.MOD-530224  --begin
    IF g_cop.cop22 ='Y' THEN    #檢查資料是否衝帳
       CALL cl_err(g_msg,'aco-228',0) RETURN
    END IF
     #No.MOD-530224  --end
    BEGIN WORK
 
    OPEN i501_cl USING g_cop.cop01,g_cop.cop02
    IF STATUS THEN
       CALL cl_err("OPEN i501_cl:", STATUS, 1)
       CLOSE i501_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i501_cl INTO g_cop.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cop.cop01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i501_show()
    IF cl_exp(0,0,g_cop.copacti) THEN
        LET g_chr=g_cop.copacti
        IF g_cop.copacti='Y' THEN
            LET g_cop.copacti='N'
        ELSE
            LET g_cop.copacti='Y'
        END IF
        UPDATE cop_file
            SET copacti=g_cop.copacti
            WHERE cop01 = g_cop.cop01 AND cop02 = g_cop.cop02
        IF SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err(g_cop.cop01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cop_file",g_cop.cop01,g_cop.cop02,SQLCA.sqlcode,"","",1) #No.TQC-660045
            LET g_cop.copacti=g_chr
        END IF
        DISPLAY BY NAME g_cop.copacti
    END IF
    CLOSE i501_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i501_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cop.cop01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_cop.copacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_cop.copconf='Y' THEN RETURN END IF
     #No.MOD-530224  --begin
    IF g_cop.cop22 ='Y' THEN    #檢查資料是否衝帳
       CALL cl_err(g_msg,'aco-228',0) RETURN
    END IF
     #No.MOD-530224  --end
    BEGIN WORK
 
    OPEN i501_cl USING g_cop.cop01,g_cop.cop02
    IF STATUS THEN
       CALL cl_err("OPEN i501_cl:", STATUS, 1)
       CLOSE i501_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i501_cl INTO g_cop.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cop.cop01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i501_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cop01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "cop02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cop.cop01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_cop.cop02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM cop_file WHERE cop01 = g_cop.cop01 AND cop02=g_cop.cop02
       IF STATUS THEN
          #CALL cl_err('del cop:',STATUS,1)  #No.TQC-660045
          CALL cl_err3("del","cop_file",g_cop.cop01,g_cop.cop02,STATUS,"","del cop",1)  #No.TQC-660045
          ROLLBACK WORK CLOSE i501_cl RETURN
       END IF
       MESSAGE "update tlf910 ..."
        #No.MOD-490398  --begin
       IF g_cop.cop10 MATCHES '[123]' THEN  #1.直接進口 2.轉廠進口 3.國內采購
          UPDATE tlf_file SET tlf910=NULL
           WHERE tlf036=g_cop.cop01 AND tlf037=g_cop.cop02
             AND ((tlf02=10 OR tlf02=11 OR tlf02=14 OR tlf02=16) AND tlf03=20)
          IF SQLCA.SQLCODE THEN
             #CALL cl_err('upd tlf910:',STATUS,1)  #No.TQC-660045
             CALL cl_err3("upd","tlf_file",g_cop.cop01,g_cop.cop02,STATUS,"","upd tlf910",1)  #No.TQC-660045
             ROLLBACK WORK CLOSE i501_cl RETURN
          END IF
       END IF
       IF g_cop.cop10 MATCHES '[456]' THEN  #4.國外退貨 5.轉廠退貨 6.內購退貨
          UPDATE tlf_file SET tlf910=NULL
           WHERE tlf026=g_cop.cop01 AND tlf027=g_cop.cop02
             AND (tlf02 = 50 OR tlf02 = 20) AND tlf03 = 31
          IF SQLCA.SQLCODE THEN
             #CALL cl_err('upd tlf910:',STATUS,1)  #No.TQC-660045
             CALL cl_err3("upd","tlf_file",g_cop.cop01,g_cop.cop02,STATUS,"","upd tlf910",1)  #No.TQC-660045
             ROLLBACK WORK CLOSE i501_cl RETURN
          END IF
       END IF
       IF g_cop.cop10 = '7' THEN            #7.報廢
          UPDATE tlf_file SET tlf910=NULL
           WHERE tlf026=g_cop.cop01 AND tlf027=g_cop.cop02
             AND tlf02 = 50 AND tlf03 = 40
          IF SQLCA.SQLCODE THEN
             #CALL cl_err('upd tlf910:',STATUS,1)  #No.TQC-660045
             CALL cl_err3("upd","tlf_file",g_cop.cop01,g_cop.cop02,STATUS,"","upd tlf910",1)  #No.TQC-660045
             ROLLBACK WORK CLOSE i501_cl RETURN
          END IF
       END IF
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     #FUN-980002 add azoplant,azolegal
          VALUES ('acoi501',g_user,g_today,g_msg,g_cop.cop01,'delete',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
        #No.MOD-490398  --end
       CLEAR FORM
         #CKP3
         OPEN i501_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i501_cs
            CLOSE i501_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i501_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i501_cs
            CLOSE i501_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i501_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i501_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i501_fetch('/')
         END IF
    END IF
    CLOSE i501_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i501_gfe(p_key)
    DEFINE p_key     LIKE gfe_file.gfe01,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfeacti INTO l_gfeacti
           FROM gfe_file WHERE gfe01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2605'
                                   LET l_gfeacti = NULL
         WHEN l_gfeacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i501_cop05(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_pmc03   LIKE pmc_file.pmc03,
           l_pmcacti LIKE pmc_file.pmcacti
 
    LET g_errno = ' '
    SELECT pmcacti,pmc03 INTO l_pmcacti,l_pmc03
           FROM pmc_file WHERE pmc01 = g_cop.cop05
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4106'
                                   LET l_pmc03 = ' '
                                   LET l_pmcacti = NULL
         WHEN l_pmcacti='N'        LET g_errno = '9028'
                                   LET l_pmc03 = ' '
         #FUN-690024------mod-------
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
                                             LET l_pmc03 = ' '   
         #FUN-690024------mod-------
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'a' AND cl_null(g_cop.cop06) THEN
       LET g_cop.cop06 = l_pmc03
    END IF
    DISPLAY BY NAME g_cop.cop06
END FUNCTION
 
FUNCTION i501_cop04(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_cnt     LIKE type_file.num5,                   #No.MOD-490398        #No.FUN-680069 SMALLINT
           l_ima02   LIKE ima_file.ima02,
           l_imaacti LIKE ima_file.imaacti,
           l_cob01   LIKE cob_file.cob01,
           l_cobacti LIKE cob_file.cobacti
 
    LET g_errno = ' '
     #No.MOD-490398
    SELECT ima02,imaacti INTO l_ima02,l_imaacti
      FROM ima_file WHERE ima01 = g_cop.cop04
     #No.MOD-490398 end
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'axm-297'
                                   LET l_ima02 = ' '
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N'        LET g_errno = '9028'
                                   LET l_ima02 = ' '
         #FUN-690022------mod-------       
         WHEN l_imaacti MATCHES '[PH]' LET g_errno = '9028'
                                       LET l_ima02 = ' '
         #FUN-690022------mod-------       
         OTHERWISE
              #No.MOD-490398
             #商品編號
             SELECT COUNT(*) INTO l_cnt FROM coa_file WHERE coa01 = g_cop.cop04
             IF l_cnt > 1 THEN                      #對應多個商品編號
                LET l_cob01 = 'MISC'
             ELSE
                SELECT cob01,cobacti INTO l_cob01,l_cobacti
                  FROM cob_file,coa_file
                 WHERE cob01 = coa03
                   AND coa01 = g_cop.cop04
             END IF
              #No.MOD-490398 end
             CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-012'
                                            LET l_cobacti = NULL
                                            LET l_cob01 = ''
                  WHEN l_cobacti='N'        LET g_errno = '9028'
                                            LET l_cob01 = ''
                  OTHERWISE                 LET g_errno = SQLCA.SQLCODE
                                                             USING '-------'
             END CASE
    END CASE
 
    IF p_cmd = 'a' AND cl_null(g_cop.cop11) THEN
       LET g_cop.cop11 = l_cob01
       DISPLAY BY NAME g_cop.cop11
    END IF
    IF p_cmd='d' OR cl_null(g_errno) THEN
       DISPLAY l_ima02 TO FORMONLY.ima02
    END IF
END FUNCTION
 
 #No.MOD-490398
FUNCTION i501_cop11(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_coaacti LIKE coa_file.coaacti,
           l_cob02   LIKE cob_file.cob02,
           l_coa04   LIKE coa_file.coa04,
           l_cobacti LIKE cob_file.cobacti,
           l_fac     LIKE tlf_file.tlf60,
           l_w_qty   LIKE cop_file.cop14
 
    LET g_errno = ' '
    SELECT cob02,cobacti INTO l_cob02,l_cobacti
      FROM cob_file WHERE cob01 = g_cop.cop11
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-001'
                                   LET l_cobacti = NULL
                                   LET l_cob02 = ''
         WHEN l_cobacti='N'        LET g_errno = '9028'
                                   LET l_cob02 = ''
         OTHERWISE
             SELECT coa04,coaacti INTO l_coa04,l_coaacti FROM coa_file
              WHERE coa01 = g_cop.cop04 AND coa03 = g_cop.cop11
                AND coa05 = g_cop.cop19
             CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-002'
                                            LET l_coaacti = NULL
                  WHEN l_coaacti='N'        LET g_errno = '9028'
                  OTHERWISE                 LET g_errno = SQLCA.SQLCODE
                                                             USING '-------'
             END CASE
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
 #    IF g_cop.cop11 != g_cop_t.cop11 THEN #No.MOD-530224
       #異動數量對庫存單位的換算
        #No.MOD-490398  --begin
       SELECT UNIQUE tlf60 INTO l_fac FROM tlf_file
        WHERE (tlf036=g_cop.cop01 AND tlf037=g_cop.cop02)
           OR (tlf026=g_cop.cop01 AND tlf027=g_cop.cop02)
        #No.MOD-490398  --end
       IF cl_null(l_fac) THEN LET l_fac = 1 END IF
       LET l_w_qty = g_cop.cop14 * l_fac
       #庫存數量對合同單位的換算
       IF cl_null(l_coa04) THEN LET l_coa04 = 1 END IF
        #No.MOD-530224  --begin
       LET g_cop.cop21 = l_coa04 * l_fac
       DISPLAY BY NAME g_cop.cop21
        #No.MOD-530224  --end
       LET g_cop.cop16 = l_w_qty * l_coa04
       LET g_cop.cop16 = s_digqty(g_cop.cop16,g_cop.cop17)   #FUN-BB0083 add
       DISPLAY BY NAME g_cop.cop16
 #    END IF  #No.MOD-530224
END FUNCTION
 #No.MOD-490398 end
 
 FUNCTION i501_cop09_cop18(p_cmd)             #No.MOD-490398
    DEFINE p_cmd      LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_coc01    LIKE coc_file.coc01,
           l_sum      LIKE coe_file.coe05,
           l_qty      LIKE coe_file.coe09,
           l_tot      LIKE cop_file.cop16,
           l_tot2     LIKE cop_file.cop16,
           l_w_qty    LIKE cod_file.cod09,
           l_ima25    LIKE ima_file.ima25,
           l_fac      LIKE cop_file.cop21,
           l_unit_fac LIKE cop_file.cop21,
           l_seq      LIKE type_file.num5,         #No.FUN-680069 SMALLINT
           l_cop16    LIKE cop_file.cop16
 
    LET g_errno = ' '
    #抓出申請編號
     #No.MOD-490398
    SELECT coc01,coc04 INTO l_coc01,g_cop.cop09 FROM coc_file
     WHERE coc03 = g_cop.cop18 AND cocacti = 'Y'
    IF STATUS THEN
       LET g_errno = 'aco-005' 
       RETURN
    END IF
    DISPLAY BY NAME g_cop.cop09
 
    #異動數量對庫存單位的換算
    SELECT UNIQUE tlf60 INTO l_fac FROM tlf_file
     WHERE (tlf036=g_cop.cop01 AND tlf037=g_cop.cop02)
        OR (tlf026=g_cop.cop01 AND tlf027=g_cop.cop02)
    IF cl_null(l_fac) THEN LET l_fac = 1 END IF
    LET l_w_qty = g_cop.cop14 * l_fac
    #庫存數量對合同單位的換算
    SELECT coa04 INTO l_unit_fac FROM coa_file
     WHERE coa01 = g_cop.cop04 AND coa03 = g_cop.cop11 AND coa05 = g_cop.cop19
     #No.MOD-490398 end
 
    IF cl_null(l_unit_fac) OR l_unit_fac = 0 THEN
       LET g_errno = 'abm-731' 
       RETURN
    END IF
    LET g_cop.cop16 = l_w_qty * l_unit_fac
    LET g_cop.cop16 = s_digqty(g_cop.cop16,g_cop.cop17)   #FUN-BB0083 add
    DISPLAY BY NAME g_cop.cop16
     #No.MOD-530224  --begin
    LET g_cop.cop21 = l_unit_fac * l_fac
    DISPLAY BY NAME g_cop.cop21
     #No.MOD-530224  --end
 
    SELECT coe02,coe06 INTO l_seq,g_cop.cop17
      FROM coe_file
     WHERE coe01 = l_coc01
       AND coe03 = g_cop.cop11
    IF STATUS = 100 THEN 
       LET g_errno = 'aco-006' 
       RETURN
    END IF
    DISPLAY BY NAME g_cop.cop17
 
     #No.MOD-490398  --begin
    IF g_cop.cop10 MATCHES '[123456]' THEN
       CALL s_coeqty(g_cop.cop18,l_seq) RETURNING l_qty     #已進口剩餘量
       #材料進口-已確認未報關
       SELECT SUM(cop16) INTO l_tot FROM cop_file
        WHERE cop18 = g_cop.cop18 AND copconf='Y'
          AND cop11 = g_cop.cop11 AND cop20 = 'N'
          AND cop10 IN ('1','2','3')
       IF cl_null(l_tot) THEN LET l_tot = 0 END IF
 
       #材料倉退-已確認未報關
       SELECT SUM(cop16) INTO l_tot2 FROM cop_file
        WHERE cop18 = g_cop.cop18 AND copconf='Y'
          AND cop11 = g_cop.cop11 AND cop20 = 'N'
          AND cop10 IN ('4','5','6')
       IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
 
       LET l_tot = l_tot - l_tot2
       LET l_cop16 = g_cop.cop16
       IF g_cop.cop10 MATCHES '[456]' THEN LET l_cop16 = l_cop16 * -1 END IF
       IF l_tot + l_cop16 > l_qty THEN 
          LET g_errno = 'aco-004' 
       END IF
    ELSE
       CALL s_chkcoe1(g_cop.cop18,l_seq) RETURNING l_qty     #進口可用量
       #材料報廢-已確認未報關
       SELECT SUM(cop16) INTO l_tot FROM cop_file
        WHERE cop18 = g_cop.cop18 AND copconf='Y'
          AND cop11 = g_cop.cop11 AND cop20 = 'N'
          AND cop10 = '7'
       IF cl_null(l_tot) THEN LET l_tot = 0 END IF
       IF l_tot + g_cop.cop16 > l_qty THEN
          LET g_errno = 'aco-004' 
       END IF
    END IF
     #No.MOD-490398  --end
END FUNCTION
 
FUNCTION i501_y()
 DEFINE l_cop    RECORD LIKE cop_file.*
 DEFINE only_one LIKE type_file.chr1         #No.FUN-680069 VARCHAR(01)
 DEFINE l_sum    LIKE cod_file.cod05
 DEFINE l_qty    LIKE cod_file.cod09
 DEFINE l_tot    LIKE cop_file.cop16
 DEFINE l_tot2   LIKE cop_file.cop16
 DEFINE l_seq    LIKE type_file.num5         #No.FUN-680069 SMALLINT
 DEFINE l_cop16  LIKE cop_file.cop16
 DEFINE l_coc01  LIKE coc_file.coc01
 
   LET g_success='Y'
   IF g_cop.cop01 IS NULL THEN RETURN END IF
   SELECT * INTO g_cop.* FROM cop_file
     WHERE cop01=g_cop.cop01 AND cop02=g_cop.cop02
   IF g_cop.copconf='Y' THEN RETURN END IF
     #No.MOD-530224  --begin
    IF g_cop.cop22 ='Y' THEN    #檢查資料是否衝帳
    #  CALL cl_err(g_msg,'aco-228',0) RETURN                #TQC-B10069
       CALL s_errmsg('cop01',g_cop.cop01,g_msg,'aco-228',1) #TQC-B10069
       LET g_success='N'                                    #TQC-B10069 
       RETURN        #TQC-B10069
    END IF
     #No.MOD-530224  --end
   IF g_cop.copacti = 'N' THEN
   #    CALL cl_err('',9027,0)                                    #TQC-B10069
        CALL s_errmsg('cop01',g_cop.cop01,g_cop.copacti,'9027',1) #TQC-B10069
        LET g_success='N'                                         #TQC-B10069 
        RETURN
   END IF
   #開窗整批審核....
   OPEN WINDOW i501_y AT 9,29 WITH FORM "aco/42f/acoi501_y"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("acoi501_y")
 
 
   LET only_one = '1'
   INPUT BY NAME only_one WITHOUT DEFAULTS
     AFTER FIELD only_one
      IF only_one IS NULL THEN NEXT FIELD only_one END IF
      IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i501_y RETURN END IF
   IF only_one = '1'
      THEN LET g_wc = " cop01 = '",g_cop.cop01,"' ",
                      "  AND cop02 =",g_cop.cop02
   ELSE
      CONSTRUCT BY NAME g_wc ON cop01,cop03,cop05,cop11
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp                        # 沿用所有欄位
            CASE
              WHEN INFIELD(cop05)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_pmc"
                LET g_qryparam.default1 = g_cop.cop05
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cop05
              WHEN INFIELD(cop11) #商品編號
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_cob"
                LET g_qryparam.default1 = g_cop.cop11
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO cop11
                NEXT FIELD cop11
              OTHERWISE EXIT CASE
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
      IF INT_FLAG THEN LET INT_FLAG=0 
         CLOSE WINDOW i501_y 
         LET g_success='N'                                    #TQC-B10069
         RETURN 
      END IF
   END IF
 
   IF NOT cl_confirm('aap-222') THEN 
      CLOSE WINDOW i501_y 
      LET g_success='N'                                    #TQC-B10069
      RETURN 
   END IF
 
   LET g_sql = " SELECT * FROM cop_file" ,
               "  WHERE copconf='N' ",
               "    AND ",g_wc CLIPPED
   PREPARE firm_pre FROM g_sql
   DECLARE firm_cs CURSOR FOR firm_pre
 
   BEGIN WORK
 
   OPEN i501_cl USING g_cop.cop01,g_cop.cop02
   IF STATUS THEN
   #  CALL cl_err("OPEN i501_cl:", STATUS, 1)                     #TQC-B10069 
      CALL s_errmsg('cop01',g_cop.cop01,"OPEN i501_cl:",STATUS,1) #TQC-B10069
      LET g_success='N'                                           #TQC-B10069
      CLOSE i501_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i501_cl INTO g_cop.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
   #   CALL cl_err(g_cop.cop01,SQLCA.sqlcode,0)              #TQC-B10069
       CALL s_errmsg('cop01',g_cop.cop01,"",SQLCA.sqlcode,1) #TQC-B10069
       LET g_success='N'                                     #TQC-B10069
       CLOSE i501_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   LET g_cnt = 0
   FOREACH firm_cs INTO l_cop.*
      IF STATUS THEN LET g_success='N' EXIT FOREACH END IF
#No.CHI-A80036  --begin---
      IF l_cop.cop22 = 'Y' THEN
      #  CALL cl_err(l_cop.cop01,'aco-228',1)                       #TQC-B10069
         CALL s_errmsg('cop01',l_cop.cop01,l_cop.cop22,'aco-228',1) #TQC-B10069
         LET g_success = 'N'
         CONTINUE FOREACH 
      END IF
      IF l_cop.copacti = 'N' THEN
      #  CALL cl_err(l_cop.cop01,9027,1)                           #TQC-B10069
         CALL s_errmsg('cop01',l_cop.cop01,l_cop.copacti,'9027',1) #TQC-B10069
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
#No.CHI-A80036  ---end--- 
      IF cl_null(l_cop.cop18) OR cl_null(l_cop.cop07) THEN #No.MOD-490398
      #  CALL cl_err(l_cop.cop01,'aco-064',1)              #TQC-B10069
         CALL s_errmsg('cop01',l_cop.cop01,"",'aco-064',1) #TQC-B10069
         IF only_one='1' THEN LET g_success='N' END IF
         CONTINUE FOREACH
      END IF
      #檢查合同數量是否已大於申請數量....
      SELECT coc01 INTO l_coc01 FROM coc_file
        WHERE coc03 = l_cop.cop18 AND cocacti = 'Y' #No.MOD-490398
 
      SELECT coe02 INTO l_seq
        FROM coe_file
       WHERE coe01 = l_coc01 AND coe03 = l_cop.cop11
      IF STATUS THEN
         #CALL cl_err(l_cop.cop01,'aco-006',1) #No.TQC-660045
         #CALL cl_err3("sel","coe_file",l_coc01,l_cop.cop11,"aco-006","","",1)  #No.TQC-660045  #TQC-B10069
         CALL s_errmsg("",l_coc01,"sel",'aco-006',1)      #TQC-B10069
         LET g_success='N'                                #TQC-B10069
         CONTINUE FOREACH
      END IF
 
       #No.MOD-490398  --begin
      IF l_cop.cop10 MATCHES '[123456]' THEN
         CALL s_coeqty(l_cop.cop18,l_seq) RETURNING l_qty   #已進口剩餘量
         #材料進口-已確認未報關
         SELECT SUM(cop16) INTO l_tot FROM cop_file
          WHERE cop18 = l_cop.cop18 AND copconf='Y'
            AND cop11 = l_cop.cop11 AND cop20 = 'N'
            AND cop10 IN ('1','2','3')
         IF cl_null(l_tot) THEN LET l_tot = 0 END IF
 
         #材料倉退-已確認未報關
         SELECT SUM(cop16) INTO l_tot2 FROM cop_file
          WHERE cop18 = l_cop.cop18 AND copconf='Y'
            AND cop11 = l_cop.cop11 AND cop20 = 'N'
            AND cop10 IN ('4','5','6')
         IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
         LET l_tot = l_tot - l_tot2
         LET l_cop16 = l_cop.cop16
         IF l_cop.cop10 MATCHES '[456]' THEN LET l_cop16 = l_cop16 * -1 END IF
         IF l_tot + l_cop16 > l_qty THEN
         #  CALL cl_err(l_cop.cop01,'aco-004',1)           #TQC-B10069
            CALL s_errmsg("",l_cop.cop01,"",'aco-004',1)   #TQC-B10069
            LET g_success='N'                              #TQC-B10069
            CONTINUE FOREACH
         END IF
      ELSE
         CALL s_chkcoe1(l_cop.cop18,l_seq) RETURNING l_qty     #進口可用量
         #材料報廢-已確認未報關
         SELECT SUM(cop16) INTO l_tot FROM cop_file
          WHERE cop18 = l_cop.cop18 AND copconf='Y'
            AND cop11 = l_cop.cop11 AND cop20 = 'N'
            AND cop10 = '7'
         IF cl_null(l_tot) THEN LET l_tot = 0 END IF
         IF l_tot + l_cop.cop16 > l_qty THEN LET g_errno = 'aco-004' 
            CALL s_errmsg("",l_cop.cop01,"",'aco-004',1)   #TQC-B10069
            LET g_success='N'                              #TQC-B10069
         END IF
      END IF
       #No.MOD-490398  --begin
 
      LET g_cnt = g_cnt + 1
      UPDATE cop_file SET copconf='Y'
       WHERE cop01 = l_cop.cop01
         AND cop02 = l_cop.cop02
      IF STATUS THEN
         #CALL cl_err('upd copconf',STATUS,0)  #No.TQC-660045
         CALL cl_err3("upd","cop_file",l_cop.cop01,l_cop.cop02,STATUS,"","upd copconf",1)  #No.TQC-660045
         LET g_success='N'
      END IF
   END FOREACH
   CLOSE WINDOW i501_y
   IF g_cnt = 0 THEN LET g_success='N' END IF
  IF g_success = 'Y' THEN        
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT copconf INTO g_cop.copconf FROM cop_file
    WHERE cop01 = g_cop.cop01 AND cop02=g_cop.cop02
   DISPLAY BY NAME g_cop.copconf
END FUNCTION
 
FUNCTION i501_z()
   DEFINE l_cnt  LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   IF g_cop.cop01 IS NULL THEN RETURN END IF
   SELECT * INTO g_cop.* FROM cop_file WHERE cop01=g_cop.cop01
       AND cop02=g_cop.cop02  #No.MOD-490398
   IF g_cop.copconf='N' THEN RETURN END IF
     #No.MOD-530224  --begin
    IF g_cop.cop22 ='Y' THEN    #檢查資料是否衝帳
       CALL cl_err(g_msg,'aco-228',0) RETURN
    END IF
     #No.MOD-530224  --end
   IF g_cop.copacti = 'N' THEN CALL cl_err('',9027,0) RETURN END IF
   IF g_cop.cop20 = 'Y' THEN
      CALL cl_err(g_cop.cop01,'aco-069',0) RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM cnp_file
    WHERE cnp12 = g_cop.cop01 AND cnp13 = g_cop.cop02
   IF l_cnt > 0 THEN
      CALL cl_err(g_cop.cop01,'aco-030',0) RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   LET g_success='Y'
   BEGIN WORK
 
   OPEN i501_cl USING g_cop.cop01,g_cop.cop02
   IF STATUS THEN
      CALL cl_err("OPEN i501_cl:", STATUS, 1)
      CLOSE i501_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i501_cl INTO g_cop.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_cop.cop01,SQLCA.sqlcode,0)
       CLOSE i501_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   UPDATE cop_file SET copconf='N'
    WHERE cop01 = g_cop.cop01
      AND cop02 = g_cop.cop02
   IF STATUS THEN
      #CALL cl_err('upd cofconf',STATUS,0)  #No.TQC-660045
      CALL cl_err3("upd","cop_file",g_cop.cop01,g_cop.cop02,STATUS,"","upd copconf",1)  #No.TQC-660045
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT copconf INTO g_cop.copconf FROM cop_file
    WHERE cop01 = g_cop.cop01 AND cop02 = g_cop.cop02
   DISPLAY BY NAME g_cop.copconf
END FUNCTION
 
FUNCTION i501_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("cop01,cop02,cop03,cop05,cop06,cop04,
                              cop14,cop15,cop12",TRUE)
   END IF
END FUNCTION
 
FUNCTION i501_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("cop01,cop02,cop03,cop05,cop06,cop04,
                              cop14,cop15,cop12",FALSE)
 
   END IF
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #

#FUN-BB0083---add---str
FUNCTION i501_cop14_check()
#cop14 的單位 cop15 

   IF NOT cl_null(g_cop.cop15) AND NOT cl_null(g_cop.cop14) THEN
      IF cl_null(g_cop_t.cop14) OR cl_null(g_cop15_t) OR g_cop_t.cop14 != g_cop.cop14 
         OR g_cop15_t != g_cop.cop15 THEN 
         LET g_cop.cop14=s_digqty(g_cop.cop14,g_cop.cop15)
         DISPLAY BY NAME g_cop.cop14  
      END IF  
   END IF
   IF g_cop.cop14 IS NOT NULL THEN
      IF g_cop.cop14 < 0 THEN 
         RETURN FALSE 
      END IF
   END IF
RETURN TRUE 
END FUNCTION
#FUN-BB0083---add---end
