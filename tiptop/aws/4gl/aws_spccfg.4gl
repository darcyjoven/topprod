# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aws_spccfg.4gl
# Descriptions...: SPC 整合設定作業
# Date & Author..: 95/08/01 By Kevin
# Modify.........: No.FUN-680130 06/09/05 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-6A0075 06/10/23 By bnlent g_no_ask --> mi_no_ask
# Modify.........: No.FUN-6A0091 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-710090 07/04/14 By Echo 更改 Action 名稱
# Modify.........: No.TQC-740155 07/04/26 By kim zz02以gaz03取代
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-860022 08/06/10 By Echo 調整程式遺漏 ON IDLE 程式段
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.           09/10/21 By lilingyu r.c2 fail
# Modify.........: No:CHI-9C0016 09/12/09 By Dido gae_file key值調整 
# Modify.........: No:TQC-9C0193 09/12/30 By Dido 邏輯調整 
# Modify.........: No.FUN-A90024 10/11/15 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B90032 11/09/05 By minpp 程序撰写规范修改 
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"
DEFINE
   g_wca     RECORD LIKE wca_file.*,       #SPC 整合設定主檔
   g_wcb     RECORD LIKE wcb_file.*,       #單頭檔設定
 
   g_wce     RECORD LIKE wce_file.*,
   g_wca_t   RECORD LIKE wca_file.*,
   g_wcb_t   RECORD LIKE wcb_file.*,
 
 
   g_wce_t   RECORD LIKE wce_file.*,
   g_wce_o   RECORD LIKE wce_file.*,
   g_wca01_t LIKE wca_file.wca01,
   g_wcb01_t LIKE wcb_file.wcb01,
 
   g_wc,g_sql,g_beforeinput  STRING,
   g_row_cnt       LIKE type_file.num10,   #No.FUN-680130 INTEGER
  # g_wc2           STRING,               #091021
    g_wc2           STRING               #091021
DEFINE g_cnt LIKE type_file.num10          #No.FUN-680130 INTEGER
DEFINE g_exc_cnt LIKE type_file.num10      #No.FUN-680130 INTEGER
DEFINE g_bwce  DYNAMIC ARRAY OF RECORD
      bwce06  LIKE wce_file.wce06,
      bwce04  LIKE wce_file.wce04,
      bwce02  LIKE wce_file.wce02,
      bwce03  LIKE wce_file.wce03
      END RECORD
DEFINE
    g_wcc          DYNAMIC ARRAY of RECORD  #程式變數(Program Variables)
        wcc02       LIKE wcc_file.wcc02,
        gae04       LIKE gae_file.gae04,    #FUN-640182    
        wcc03       LIKE wcc_file.wcc03        
        
                    END RECORD,
    g_wcc_t         RECORD                  #程式變數 (舊值)
        wcc02       LIKE wcc_file.wcc02,
        gae04       LIKE gae_file.gae04,    #FUN-640182    
        wcc03       LIKE wcc_file.wcc03        
                    END RECORD,
    g_wcd          DYNAMIC ARRAY of RECORD  #程式變數(Program Variables)
        wcd01       LIKE wcd_file.wcd01,
        wcd02       LIKE wcd_file.wcd02,
        gae04       LIKE gae_file.gae04               
        
                    END RECORD,
    g_wcd_t         RECORD                  #程式變數 (舊值)
        wcd01       LIKE wcd_file.wcd01,
        wcd02       LIKE wcd_file.wcd02,        
        gae04       LIKE gae_file.gae04
 
                    END RECORD,   
    g_trans         DYNAMIC ARRAY of RECORD 
        chk01       LIKE type_file.chr1,    #No.FUN-680130 VARCHAR(1)
        wcd01       LIKE wcd_file.wcd01,
        gat03       LIKE gat_file.gat03     #No.FUN-680130 VARCHAR(36)        
        
                    END RECORD,                                      
    g_rec_b         LIKE type_file.num5,    #單身筆數            #No.FUN-680130 SMALLINT
    l_ac            LIKE type_file.num5,    #目前處理的ARRAY CNT #No.FUN-680130 SMALLINT
    g_forupd_sql    STRING
DEFINE mi_no_ask    LIKE type_file.num5     #是否開啟指定筆視窗  #No.FUN-680130 SMALLINT  #No.FUN-6A0075
DEFINE g_jump       LIKE type_file.num10    #查詢指定的筆數      #No.FUN-680130 INTEGER
DEFINE g_curs_index LIKE type_file.num10    #計算筆數給是否隱藏toolbar按鈕用  #No.FUN-680130 INTEGER
DEFINE g_row_count  LIKE type_file.num10    #總筆數計算          #No.FUN-680130 INTEGER
DEFINE g_zz02       STRING
DEFINE g_zz03       STRING
DEFINE g_gat03      LIKE gat_file.gat03     #No.FUN-680130 VARCHAR(36)
DEFINE g_gaq03      LIKE gaq_file.gaq03     #FUN-640182
 #### MOD-490275 ####
 
DEFINE g_channel     base.Channel,
       g_cmd         STRING
 
 #### END MOD-490275 ####
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5    #No.FUN-680130 SMALLINT
#       l_time          LIKE type_file.chr8    #No.FUN-680130 VARCHAR(8)  #No.FUN-6A0091
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AWS")) THEN
       EXIT PROGRAM
    END IF
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #No.FUN-6A0091
 
    LET p_row = 4 LET p_col = 6
 
    OPEN WINDOW spccfg_w AT p_row,p_col
        WITH FORM "aws/42f/aws_spccfg" ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    CALL spccfg_menu()
 
    CLOSE WINDOW spccfg_w
 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #No.FUN-6A0091
END MAIN
 
FUNCTION spccfg_curs()
    CLEAR FORM
 
   INITIALIZE g_wca.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        wca01,wca02,wcb02,wcb03,wcb04,wcb05,wcb06,wcb07,
        wcb08,wcb09,        
        wcauser,wcagrup,wcamodu,wcadate,wcaacti
 
        BEFORE CONSTRUCT
            CALL cl_set_combo_items("wcb03",NULL,NULL)
            CALL cl_set_combo_items("wcb04",NULL,NULL)
            CALL cl_set_combo_items("wcb05",NULL,NULL)
            CALL cl_set_combo_items("wcb06",NULL,NULL)
            CALL cl_set_combo_items("wcb07",NULL,NULL)
            CALL cl_set_combo_items("wcb08",NULL,NULL)
            CALL cl_set_combo_items("wcb09",NULL,NULL)
 
            CALL cl_qbe_init()           #No.FUN-580031
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(wca01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_wca.wca01
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO wca01
                WHEN INFIELD(wcb02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_wcb.wcb02
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO wcb02
                
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
             CALL cl_qbe_select()
         ON ACTION qbe_save
             CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
    END CONSTRUCT
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND wcbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND wcbgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND wcbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('wcbuser', 'wcbgrup')
    #End:FUN-980030
 
#   LET g_sql="SELECT wca01 FROM wca_file,OUTER wcb_file ", # 組合出 SQL 指令   #091021
    LET g_sql="SELECT wca01 FROM wca_file LEFT OUTER JOIN wcb_file ON wca01 = wcb01 ", # 組合出 SQL 指令  #091021
#       " WHERE wca01=wcb_file.wcb01 AND ",      #091021  
        " WHERE ",  g_wc CLIPPED, " ORDER BY wca01"   #091021 add WEHRE 
 
    PREPARE spccfg_prepare FROM g_sql
    DECLARE spccfg_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR spccfg_prepare
 
    LET g_sql=
#       "SELECT COUNT(*) FROM wca_file,OUTER wcb_file ",  #091021
        "SELECT COUNT(*) FROM wca_file LEFT OUTER JOIN wcb_file ON wca01 = wcb01  ",  #091021 
#        " WHERE wca01=wcb_file.wcb01 AND ",g_wc CLIPPED    #091021 
         " WHERE ",g_wc CLIPPED    #091021 
    PREPARE spccfg_precount FROM g_sql
    DECLARE spccfg_count CURSOR FOR spccfg_precount
END FUNCTION
 
FUNCTION spccfg_menu()
 
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        LET g_action_choice = ""
 
        ON ACTION insert
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
                  CALL spccfg_a()
            END IF
 
        ON ACTION query
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
                 CALL spccfg_q()
            END IF
 
        ON ACTION previous
            CALL spccfg_fetch('P')
 
        ON ACTION next
            CALL spccfg_fetch('N')
 
        ON ACTION first
            CALL spccfg_fetch('F')
 
        ON ACTION last
            CALL spccfg_fetch('L')
 
        ON ACTION jump
            CALL spccfg_fetch('/')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL spccfg_u()
            END IF
 
        ON ACTION spc_masfield                           #No.TQC-710090
            CALL spccfg_h()
 
        ON ACTION basefield                              #No.TQC-710090
            CALL spccfg_d()
 
        ON ACTION delete
            LET g_action_choice = "delete"
            IF cl_chk_act_auth() THEN
                 CALL spccfg_r()
            END IF
 
        ON ACTION reproduce
            LET g_action_choice = "reproduce"
            IF cl_chk_act_auth() THEN
                 CALL spccfg_copy()
            END IF
 
        ON ACTION help
            CALL cl_show_help()
 
        ON ACTION base_traninfo                      #No.TQC-710090
            #CALL aws_spccli_base('','','insert')  
            CALL aws_spc_trans()         
 
        ON ACTION spc_exception                      #No.TQC-710090
            LET g_action_choice = "spc_exception"    #No.TQC-710090  
            IF cl_chk_act_auth() THEN                  
               CALL aws_spccfg_exception()
            END IF
 
 
        ON ACTION exit
            EXIT MENU
 
        ON ACTION controlg
            CALL cl_cmdask()
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            EXIT MENU
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
 
         ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
        ON ACTION locale
            CALL cl_dynamic_locale()
 
    END MENU
    CLOSE spccfg_cs
END FUNCTION
 
FUNCTION spccfg_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE " "
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_wca.* LIKE wca_file.*
    INITIALIZE g_wcb.* LIKE wcb_file.*
    
    LET g_wca01_t = NULL
    LET g_wcb01_t = NULL
    
    LET g_wc = NULL #因為BugNO:4137的原故所以在此要讓g_wc變回NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        
        LET g_wca.wcauser = g_user
        LET g_wca.wcagrup = g_grup               #使用者所屬群
        LET g_wca.wcadate = g_today
        LET g_wca.wcaacti = 'Y'
        CALL spccfg_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_wca.* TO NULL
            INITIALIZE g_wcb.* TO NULL
        
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_wca.wca01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        LET g_wcb.wcb01=g_wca.wca01
 
 
        BEGIN WORK
 
        LET g_wca.wcaoriu = g_user      #No.FUN-980030 10/01/04
        LET g_wca.wcaorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO wca_file VALUES(g_wca.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","wca_file",g_wca.wca01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155     #FUN-B80064  ADD
            ROLLBACK WORK
#           CALL cl_err(g_wca.wca01,SQLCA.sqlcode,0)   #No.FUN-660155
           # CALL cl_err3("ins","wca_file",g_wca.wca01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155    #FUN-B80064  MARK
            CONTINUE WHILE
        END IF
        INSERT INTO wcb_file VALUES(g_wcb.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","wcb_file",g_wcb.wcb01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155     #FUN-B80064  ADD
            ROLLBACK WORK
#           CALL cl_err(g_wcb.wcb02,SQLCA.sqlcode,0)   #No.FUN-660155
         #   CALL cl_err3("ins","wcb_file",g_wcb.wcb01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155    #FUN-B80064  MARK
            CONTINUE WHILE
        END IF        
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION spccfg_i(p_cmd)
DEFINE p_cmd	     LIKE type_file.chr1,        #No.FUN-680130 VARCHAR(1)
       l_cnt	     LIKE type_file.num5,        #No.FUN-680130 SMALLINT
       l_zz02	     LIKE zz_file.zz02,
       l_items       STRING,
       l_beforeinput LIKE type_file.chr1         #No.FUN-680130 VARCHAR(1)
DEFINE l_message     STRING
DEFINE l_ze03        LIKE ze_file.ze03
 
DEFINE l_change      LIKE type_file.num10        #No.FUN-680130 INTEGER
DEFINE l_zz01        LIKE zz_file.zz01,          #FUN-5A0207
       l_zz011       LIKE zz_file.zz011          #FUN-5A0207
 
    MESSAGE " "
    DISPLAY BY NAME
        g_wca.wca01,g_wca.wca02,g_wcb.wcb02,g_wcb.wcb03,g_wcb.wcb04,
        g_wcb.wcb05,g_wcb.wcb06,g_wcb.wcb07,g_wcb.wcb08,g_wcb.wcb09,        
        g_wca.wcauser,g_wca.wcagrup,g_wca.wcamodu,g_wca.wcadate,g_wca.wcaacti
 
 
    INPUT BY NAME
        g_wca.wca01,g_wca.wca02,g_wcb.wcb02,g_wcb.wcb03,g_wcb.wcb04,
        g_wcb.wcb05,g_wcb.wcb06,g_wcb.wcb07,g_wcb.wcb08,g_wcb.wcb09,        
        g_wca.wcagrup,g_wca.wcamodu,g_wca.wcadate,g_wca.wcaacti
        WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
        BEFORE INPUT
          
            CALL spccfg_set_no_entry()
            CALL spccfg_set_entry()
            IF p_cmd='a' THEN
               LET g_wca.wca02 = 'N'
            ELSE
               LET l_beforeinput = "N"
               
 
               NEXT FIELD wcb02
            END IF
 
        BEFORE FIELD wca01
            IF p_cmd = 'u' AND g_chkey = 'N' THEN
               NEXT FIELD wca02
            END IF
 
        AFTER FIELD wca01
            IF g_wca.wca01 IS NULL THEN
              DISPLAY '' TO FORMONLY.zz02
              NEXT FIELD wca01
            END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_wca.wca01 != g_wca01_t) THEN
               SELECT zz01,zz011 INTO l_zz01,l_zz011
                  FROM zz_file WHERE zz01 = g_wca.wca01   #FUN-5A0207
               IF SQLCA.SQLCODE THEN
                 CALL cl_err(g_wca.wca01,NOTFOUND,0)   
                  DISPLAY '' TO FORMONLY.zz02
                  NEXT FIELD wca01
               END IF
               SELECT COUNT(*) INTO l_cnt FROM wca_file WHERE wca01 = g_wca.wca01
               IF l_cnt > 0 THEN                  # Duplicated
                  CALL cl_err(g_wca.wca01,-239,0)
                  DISPLAY '' TO FORMONLY.zz02
                  NEXT FIELD wca01
               END IF
               CALL spccfg_zz02(g_wca.wca01)
              
            END IF
            LET g_wcb.wcb01 = g_wca.wca01
            
 
        BEFORE FIELD wcb02
            
            LET l_change = FALSE
 
        ON CHANGE wcb02
            LET l_change = TRUE
 
        AFTER FIELD wcb02
            IF g_wcb.wcb02 IS NULL THEN
               CALL cl_err(NULL,"aws-067", 0)
               NEXT FIELD wcb02
            END IF
 
            IF l_change THEN
               IF NOT spccfg_tab(g_wcb.wcb02) THEN
                  NEXT FIELD wcb02
               END IF
               
 
               LET g_gat03 = NULL
               SELECT gat03 INTO g_gat03 FROM gat_file
                 WHERE gat01 = g_wcb.wcb02
                       AND gat02 = g_lang
               DISPLAY g_gat03 TO FORMONLY.zz03
 
               LET g_wcb.wcb03 = NULL
               LET g_wcb.wcb04 = NULL
               LET g_wcb.wcb05 = NULL
               LET g_wcb.wcb06 = NULL
               LET g_wcb.wcb07 = NULL
               LET g_wcb.wcb08 = NULL
               LET g_wcb.wcb09 = NULL
               
               DELETE FROM wsi_file where wsi01 = g_wcb.wcb01
                  AND wsi02 = g_wcb_t.wcb02 AND wsi05 = g_wcb_t.wcb03
               LET l_items = spccfg_combobox(g_wcb.wcb02)
               CALL cl_set_combo_items("wcb03",l_items,l_items)
               CALL cl_set_combo_items("wcb04",l_items,l_items)
               CALL cl_set_combo_items("wcb05",l_items,l_items)
               CALL cl_set_combo_items("wcb06",l_items,l_items)
               CALL cl_set_combo_items("wcb07",l_items,l_items)
               CALL cl_set_combo_items("wcb08",l_items,l_items)
               CALL cl_set_combo_items("wcb09",l_items,l_items)
               
               CALL spccfg_set_no_entry()
               CALL spccfg_set_entry()
            END IF
 
        ON CHANGE wcb03
            IF g_wcb.wcb03 IS NOT NULL THEN
               CALL cl_set_comp_entry("wcb04", TRUE)
            ELSE
               LET g_wcb.wcb04 = NULL
               LET g_wcb.wcb05 = NULL
               LET g_wcb.wcb06 = NULL
               LET g_wcb.wcb07 = NULL
               CALL cl_set_comp_entry("wcb04", FALSE)
               CALL cl_set_comp_entry("wcb05", FALSE)
               CALL cl_set_comp_entry("wcb06", FALSE)
               CALL cl_set_comp_entry("wcb07", FALSE)
            END IF
 
        AFTER FIELD wcb03
            IF g_wcb.wcb03 IS NOT NULL THEN
               IF NOT spccfg_field_wcb(g_wcb.wcb03) THEN
                  CALL cl_err(g_wcb.wcb03,-239,0)
                  NEXT FIELD wcb03
               END IF
            END IF
            CALL spccfg_set_no_entry()
            CALL spccfg_set_entry()
 
        ON CHANGE wcb04
            IF g_wcb.wcb04 IS NOT NULL THEN
               CALL cl_set_comp_entry("wcb05", TRUE)
            ELSE
               LET g_wcb.wcb05 = NULL
               LET g_wcb.wcb06 = NULL
               LET g_wcb.wcb07 = NULL
               CALL cl_set_comp_entry("wcb05", FALSE)
               CALL cl_set_comp_entry("wcb06", FALSE)
               CALL cl_set_comp_entry("wcb07", FALSE)
            END IF
 
        AFTER FIELD wcb04
            IF g_wcb.wcb04 IS NOT NULL THEN
               IF NOT spccfg_field_wcb(g_wcb.wcb04) THEN
                     CALL cl_err(g_wcb.wcb04,-239,0)
                     NEXT FIELD wcb04
               END IF
            END IF
            CALL spccfg_set_no_entry()
            CALL spccfg_set_entry()
 
        ON CHANGE wcb05
            IF g_wcb.wcb05 IS NOT NULL THEN
               CALL cl_set_comp_entry("wcb06", TRUE)
            ELSE
               LET g_wcb.wcb06 = NULL
               LET g_wcb.wcb07 = NULL
               CALL cl_set_comp_entry("wcb06", FALSE)
               CALL cl_set_comp_entry("wcb07", FALSE)
            END IF
 
        AFTER FIELD wcb05
            IF g_wcb.wcb05 IS NOT NULL THEN
               IF NOT spccfg_field_wcb(g_wcb.wcb05) THEN
                     CALL cl_err(g_wcb.wcb05,-239,0)
                     NEXT FIELD wcb05
               END IF
            END IF
            CALL spccfg_set_no_entry()
            CALL spccfg_set_entry()
 
        ON CHANGE wcb06
            IF g_wcb.wcb06 IS NOT NULL THEN
               CALL cl_set_comp_entry("wcb07", TRUE)
            ELSE
               LET g_wcb.wcb07 = NULL
               CALL cl_set_comp_entry("wcb07", FALSE)
            END IF
 
        AFTER FIELD wcb06
            IF g_wcb.wcb06 IS NOT NULL THEN
               IF NOT spccfg_field_wcb(g_wcb.wcb06) THEN
                     CALL cl_err(g_wcb.wcb06,-239,0)
                     NEXT FIELD wcb07
               END IF
            END IF
            CALL spccfg_set_no_entry()
            CALL spccfg_set_entry()
 
        AFTER FIELD wcb07
            IF g_wcb.wcb07 IS NOT NULL THEN
               IF NOT spccfg_field_wcb(g_wcb.wcb07) THEN
                     CALL cl_err(g_wcb.wcb07,-239,0)
                     NEXT FIELD wcb07
               END IF
            END IF
 
        AFTER FIELD wcb08
            IF g_wcb.wcb08 IS NOT NULL THEN
               IF NOT spccfg_field_wcb(g_wcb.wcb08) THEN
                     CALL cl_err(g_wcb.wcb08,-239,0)
                     NEXT FIELD wcb08
               END IF
            END IF
 
        AFTER FIELD wcb09
            IF g_wcb.wcb09 IS NOT NULL THEN
               IF NOT spccfg_field_wcb(g_wcb.wcb09) THEN
                     CALL cl_err(g_wcb.wcb09,-239,0)
                     NEXT FIELD wcb09
               END IF
            END IF
 
        
 
        AFTER INPUT
               IF INT_FLAG THEN                            # 使用者不玩了
                   EXIT INPUT
               END IF
              
              
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(wca01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz1"
                  LET g_qryparam.default1 = g_wca.wca01
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wca.wca01,g_zz02
                  DISPLAY BY NAME g_wca.wca01
                  DISPLAY g_zz02 TO FORMONLY.zz02
                WHEN INFIELD(wcb02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.default1 = g_wcb.wcb02
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wcb.wcb02,g_zz03
                  DISPLAY BY NAME g_wcb.wcb02
                  DISPLAY g_zz03 TO FORMONLY.zz03
                
            END CASE
 
        ON ACTION CONTROLF                   # 欄位說明    #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913     
 
              
       ON ACTION controlg
           CALL cl_cmdask()
 
       #TQC-860022
       ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
    
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
    
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
       #END TQC-860022
 
    END INPUT
    
 
END FUNCTION
 
FUNCTION spccfg_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL spccfg_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
 
    OPEN spccfg_count
    FETCH spccfg_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt #ATTRIBUTE(MAGENTA)
 
    OPEN spccfg_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_wca.wca01,SQLCA.sqlcode,0)
        INITIALIZE g_wca.* TO NULL
    ELSE
        CALL spccfg_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION spccfg_fetch(p_flwcb)
    DEFINE
        p_flwcb          LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
    INITIALIZE g_wca.* TO NULL
    INITIALIZE g_wcb.* TO NULL
 
    CASE p_flwcb
        WHEN 'N' FETCH NEXT     spccfg_cs INTO g_wca.wca01
        WHEN 'P' FETCH PREVIOUS spccfg_cs INTO g_wca.wca01
        WHEN 'F' FETCH FIRST    spccfg_cs INTO g_wca.wca01
        WHEN 'L' FETCH LAST     spccfg_cs INTO g_wca.wca01
        WHEN '/' IF (NOT mi_no_ask) THEN   #No.FUN-6A0075
                    CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
 
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
 
                 FETCH ABSOLUTE g_jump spccfg_cs INTO g_wca.wca01
                 LET mi_no_ask = FALSE   #No.FUN-6A0075
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(NULL,SQLCA.sqlcode,0)
        INITIALIZE g_wca.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
        CASE p_flwcb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
        END CASE
        CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
     SELECT * INTO g_wca.* FROM wca_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wca01=g_wca.wca01
     SELECT * INTO g_wcb.* FROM wcb_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wcb01=g_wca.wca01
     
 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_wca.wca01,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("sel","wsg_file",g_wca.wca01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
    ELSE
        CALL spccfg_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION spccfg_show()
 
    LET g_wca_t.* = g_wca.*
    LET g_wcb_t.* = g_wcb.*
    
    LET g_beforeinput = "FALSE"
    CALL spccfg_combo_list()
    LET g_beforeinput = "TRUE"
    DISPLAY BY NAME
        g_wca.wca01,g_wca.wca02,g_wcb.wcb02,g_wcb.wcb03,g_wcb.wcb04,
        g_wcb.wcb05,g_wcb.wcb06,g_wcb.wcb07,g_wcb.wcb08,g_wcb.wcb09,
        g_wca.wcauser,g_wca.wcagrup,g_wca.wcamodu,g_wca.wcadate,g_wca.wcaacti
 
    CALL spccfg_zz02(g_wca.wca01)
    LET g_gat03 = ""
    IF g_wcb.wcb02 IS NOT NULL OR g_wcb.wcb02 <> "" THEN
       LET g_gat03 = NULL
       SELECT gat03 INTO g_gat03 FROM gat_file
         WHERE gat01 = g_wcb.wcb02
               AND gat02 = g_lang
       DISPLAY g_gat03 TO FORMONLY.zz03
    ELSE
       DISPLAY "" TO FORMONLY.zz03
    END IF
 
END FUNCTION
 
FUNCTION spccfg_zz02(p_wca01)
   #DEFINE l_zz02 LIKE zz_file.zz02 #TQC-740155
    DEFINE p_wca01 LIKE wca_file.wca01
   #SELECT zz02 INTO l_zz02 FROM zz_file WHERE zz01 = p_wca01 #TQC-740155
   #DISPLAY l_zz02 TO FORMONLY.zz02 #TQC-740155
    DISPLAY cl_get_progdesc(p_wca01,g_lang) TO FORMONLY.zz02 #TQC-740155
END FUNCTION
 
FUNCTION spccfg_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_wca.wca01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
     SELECT * INTO g_wca.* FROM wca_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wca01=g_wca.wca01
     SELECT * INTO g_wcb.* FROM wcb_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wcb01=g_wca.wca01
     
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_wca.wca01,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("sel","wsg_file",g_wca.wca01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        RETURN
    END IF
 
    IF g_wca.wcaacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
 
    LET g_wca_t.*=g_wca.*
    LET g_wcb_t.*=g_wcb.*
    
    LET g_wca01_t = g_wca.wca01
    BEGIN WORK
    LET g_wca.wcamodu=g_user                  #修改者
    LET g_wca.wcadate = g_today               #修改日期
    CALL spccfg_show()                          # 顯示最新資料
    WHILE TRUE
        CALL spccfg_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_wca.*=g_wca_t.*
            LET g_wcb.*=g_wcb_t.*
            
            CALL spccfg_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE wca_file SET wca_file.* = g_wca.*    # 更新DB
            WHERE wca01 = g_wca.wca01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wca.wca01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wca_file",g_wca_t.wca01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
            CONTINUE WHILE
        END IF
        UPDATE wcb_file SET wcb_file.* = g_wcb.*    # 更新DB
            WHERE wcb01 = g_wca.wca01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wcb.wcb02,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wcb_file",g_wcb_t.wcb01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
            CONTINUE WHILE
        END IF
        
 
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
FUNCTION spccfg_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_wca.wca01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
     SELECT * INTO g_wca.* FROM wca_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wca01=g_wca.wca01
     SELECT * INTO g_wcb.* FROM wcb_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wcb01=g_wca.wca01
     
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_wca.wca01,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("sel","wsg_file",g_wca.wca01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
    CALL spccfg_show()
    IF cl_delete() THEN
       DELETE FROM wca_file WHERE wca01 = g_wca.wca01
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('del wca: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("del","wca_file",g_wca.wca01,"",SQLCA.sqlcode,"","del wca:", 0)   #No.FUN-660155)   #No.FUN-660155
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM wcb_file WHERE wcb01 = g_wcb.wcb01
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('del wcb: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("del","wcb_file",g_wcb.wcb01,"",SQLCA.sqlcode,"","del wcb:", 0)   #No.FUN-660155)   #No.FUN-660155
          ROLLBACK WORK
          RETURN
       END IF
       
       DELETE FROM wcc_file WHERE wcc01 = g_wca.wca01
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('del wcc: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("del","wcc_file",g_wca.wca01,"",SQLCA.sqlcode,"","del wcc:", 0)   #No.FUN-660155)   #No.FUN-660155
          ROLLBACK WORK
          RETURN
       END IF
 
       CLEAR FORM
 
       OPEN spccfg_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE spccfg_cs
          CLOSE spccfg_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH spccfg_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE spccfg_cs
          CLOSE spccfg_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
 
       IF g_row_count != 0 THEN
          OPEN spccfg_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL spccfg_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE   #No.FUN-6A0075
             CALL spccfg_fetch('/')
          END IF
       ELSE
          INITIALIZE g_wca.* TO NULL
       END IF
    END IF
    COMMIT WORK
END FUNCTION
 
FUNCTION spccfg_tab(p_tabname)
    DEFINE p_tabname	LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20)
           l_cnt	LIKE type_file.num5    #No.FUN-680130 SMALLINT

    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構 
    ##FUN-5A0136
    #CASE cl_db_get_database_type()
    #  WHEN "ORA"
    #      SELECT COUNT(*) INTO l_cnt FROM ALL_TABLES WHERE  #FUN-5A0136
    #      TABLE_NAME = UPPER(p_tabname) AND OWNER = 'DS'
    # 
    #  WHEN "IFX"
    #       SELECT COUNT(*) INTO l_cnt FROM ds:systables
    #        WHERE tabname = p_tabname
    #END CASE
    ##END FUN-5A0136
    SELECT COUNT(*) INTO l_cnt FROM sch_file 
      WHERE sch01 = p_tabname
    #---FUN-A90024---end-------
 
    IF l_cnt = 0 THEN
       CALL cl_err(p_tabname,NOTFOUND,0)
       RETURN 0
    ELSE
       RETURN 1
    END IF
END FUNCTION
 
FUNCTION spccfg_col(p_colname,p_tabname)
    DEFINE p_tabname    LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20)
           p_colname	LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20)
           l_cnt	LIKE type_file.num5,   #No.FUN-680130 SMALLINT
           l_name       STRING
 
    #FUN-5A0136
    IF p_tabname IS NULL THEN
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構   
      #CASE cl_db_get_database_type()
      #WHEN "ORA"
      #   SELECT COUNT(*) INTO l_cnt FROM ALL_TAB_COLUMNS
      #     WHERE COLUMN_NAME = UPPER(p_colname) AND OWNER = 'DS'
      #WHEN "IFX"
      #   SELECT COUNT(*) INTO l_cnt FROM ds:syscolumns
      #     WHERE colname = p_colname
      #END CASE
      SELECT COUNT(*) INTO l_cnt FROM sch_file
        WHERE sch02 = p_colname
      #---FUN-A90024---end-------
    ELSE
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構   
      #CASE cl_db_get_database_type()
      #WHEN "ORA"
      #   SELECT COUNT(*) INTO l_cnt FROM ALL_TAB_COLUMNS
      #     WHERE TABLE_NAME = UPPER(p_tabname) AND COLUMN_NAME = UPPER(p_colname)
      #       AND OWNER = 'DS'
      #WHEN "IFX"
      #   SELECT COUNT(*) INTO l_cnt FROM ds:syscolumns col, ds:systables tab
      #     WHERE tab.tabname =  p_tabname AND tab.tabid = col.tabid
      #     AND colname = p_colname
      #END CASE
      SELECT COUNT(*) INTO l_cnt FROM sch_file
        WHERE sch01 = p_tabname AND sch02 = p_colname
      #---FUN-A90024---end-------
    END IF
    #END FUN-5A0136
 
   # SELECT COUNT(*) INTO l_cnt FROM syscolumns WHERE colname = p_colname
    IF l_cnt = 0 THEN
       LET l_name= p_tabname,"+",p_colname
       CALL cl_err(l_name,NOTFOUND,0)
       RETURN 0
    ELSE
       RETURN 1
    END IF
END FUNCTION
 
FUNCTION spccfg_h()
    IF g_wca.wca01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_wcb.wcb02 IS NULL THEN
       CALL cl_err(NULL,"aws-067",0)
       RETURN
    END IF
    OPEN WINDOW spccfg_w1 AT 4, 16
        WITH FORM "aws/42f/aws_spccfg_field" ATTRIBUTE(STYLE = g_win_style)
 
   # CALL cl_ui_init()
    CALL cl_ui_locale("aws_spccfg_field")
    CALL spccfg_b_fill('M')
    CALL spccfg_b('M')
 
    CLOSE WINDOW spccfg_w1
END FUNCTION
 
FUNCTION spccfg_d()
   
    OPEN WINDOW spccfg_w1 AT 4, 16
        WITH FORM "aws/42f/aws_spccfg_basic" ATTRIBUTE(STYLE = g_win_style)
 
    #CALL cl_ui_init()
    CALL cl_ui_locale("aws_spccfg_basic")
    CALL wcd_b_fill(null)
    CALL wcd_menu()
 
    CLOSE WINDOW spccfg_w1
END FUNCTION
 
FUNCTION wcd_menu()
   WHILE TRUE      
      CALL wcd_bp("G")
      CASE g_action_choice
         WHEN "query"
               CALL wcd_query()
         WHEN "detail"                         
               CALL wcd_b()      
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION wcd_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_wcd TO s_wcd.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
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
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION wcd_b_fill(p_wc2)
DEFINE   
    l_cnt            LIKE type_file.num5,          #No.FUN-680130 SMALLINT
    l_i              LIKE type_file.num5,          #No.FUN-680130 SMALLINT
    l_item           STRING,
    p_wc2            STRING    
    
    IF p_wc2 is not null THEN
      LET g_sql =
        "SELECT wcd01,wcd02,'' ",
        " FROM wcd_file",                  
        " WHERE ", p_wc2 CLIPPED, 
        " ORDER BY wcd01,wcd02 "
    ELSE
      LET g_sql =
        "SELECT wcd01,wcd02,'' ",
        " FROM wcd_file",                  
        " ORDER BY wcd01,wcd02 "
    END IF 
    
    PREPARE wcd_sql FROM g_sql
    DECLARE spcwcd_curs CURSOR FOR wcd_sql
 
    CALL g_wcd.clear() #單身 ARRAY 乾洗
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH spcwcd_curs INTO g_wcd[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        
        IF cl_null(g_wcd[g_cnt].gae04) THEN
           SELECT gaq03 INTO g_wcd[g_cnt].gae04
           FROM gaq_file
           WHERE gaq01 = g_wcd[g_cnt].wcd02
             and gaq02 = g_lang        
        END IF
        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    
    CALL g_wcd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION wcd_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #No.FUN-680130 SMALLINT
    l_n             LIKE type_file.num5,   #No.FUN-680130 SMALLINT
    l_items         STRING,
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否  #No.FUN-680130 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態    #No.FUN-680130 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #可新增否    #No.FUN-680130 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1    #可刪除否    #No.FUN-680130 VARCHAR(1)
    
DEFINE l_message    STRING
DEFINE l_ze03       LIKE ze_file.ze03
DEFINE l_cnt        LIKE type_file.num10   #No.FUN-680130 INTEGER
 
    IF s_shut(0) THEN RETURN END IF
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
 LET g_forupd_sql = " SELECT wcd01,wcd02,'' ",
       " FROM wcd_file ",
      "   WHERE wcd01=?  AND wcd02= ?  ",
      "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE wcd_bc1 CURSOR FROM g_forupd_sql    # LOCK CURSOR
 
    INPUT ARRAY g_wcd WITHOUT DEFAULTS FROM s_wcd.*
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
        BEFORE INPUT
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
            END IF
       
        BEFORE ROW        
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
 
               LET p_cmd='u'
               LET g_wcd_t.* = g_wcd[l_ac].*  #BACKUP
 
               OPEN wcd_bc1 USING g_wcd_t.wcd01, g_wcd_t.wcd02
               IF STATUS THEN
                  CALL cl_err("OPEN spccfg_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH wcd_bc1 INTO g_wcd[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_wcd_t.wcd01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               
               SELECT gaq03 INTO g_wcd[l_ac].gae04
                 FROM gaq_file
                WHERE gaq01 = g_wcd[l_ac].wcd02
                  and gaq02 = g_lang          
              
              LET g_wcd_t.gae04 = g_wcd[l_ac].gae04
               
            END IF
 
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_wcd[l_ac].* TO NULL      #900423
            LET g_wcd_t.* = g_wcd[l_ac].*         #新輸入資料
            NEXT FIELD wcd01
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_wcd[l_ac].wcd01 IS NULL THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            
            SELECT COUNT(*) INTO l_n FROM wcd_file
             WHERE wcd01 = g_wcd[l_ac].wcd01 AND
                   wcd02 = g_wcd[l_ac].wcd02 
 
            IF l_n > 0 THEN
               CALL cl_err(g_wcd[l_ac].wcd01,-239,0)
               NEXT FIELD wcd01
            END IF
            
            INSERT INTO wcd_file (wcd01,wcd02)
                 VALUES (g_wcd[l_ac].wcd01,g_wcd[l_ac].wcd02)
                 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","wcd_file",g_wcd[l_ac].wcd01,g_wcd[l_ac].wcd02,SQLCA.sqlcode,"","",1)   #No.FUN-660155
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER FIELD wcd01
           IF g_wcd[l_ac].wcd01 IS NOT NULL AND NOT spccfg_tab(g_wcd[l_ac].wcd01) THEN           
              NEXT FIELD wcd01
           END IF           
           
           
        AFTER FIELD wcd02
           IF g_wcd[l_ac].wcd02 IS NULL THEN
              CONTINUE INPUT
           END IF   
           
           IF NOT spccfg_col(g_wcd[l_ac].wcd02,g_wcd[l_ac].wcd01) THEN
              NEXT FIELD wcd02
           END IF           
           
           IF (g_wcd_t.wcd02 IS NULL AND g_wcd[l_ac].wcd02 IS NOT NULL) OR
                 (g_wcd[l_ac].wcd02 != g_wcd_t.wcd02) THEN
                 
               SELECT COUNT(*) INTO l_n FROM wcd_file
                WHERE wcd01 = g_wcd[l_ac].wcd01 AND
                      wcd02 = g_wcd[l_ac].wcd02 
 
               IF l_n > 0 THEN
                  CALL cl_err(g_wcd[l_ac].wcd02,-239,0)
                  NEXT FIELD wcd02
               END IF
           END IF  
            
           SELECT gaq03 INTO g_wcd[l_ac].gae04
             FROM gaq_file
            WHERE gaq01 = g_wcd[l_ac].wcd02
              and gaq02 = g_lang
           
           DISPLAY g_wcd[l_ac].gae04 TO FORMONLY.gae04   
           LET g_wcd_t.gae04 = g_wcd[l_ac].gae04
           
        
        BEFORE DELETE                            #是否取消單身
            IF g_wcd_t.wcd01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
{ckp#1}           DELETE FROM wcd_file
                  WHERE wcd01 = g_wcd_t.wcd01 AND
                      wcd02 = g_wcd_t.wcd02 
                      
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wcd_t.wcd01,SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete Ok"
               CLOSE wcd_bc1
               COMMIT WORK
            END IF
 
        AFTER ROW
                LET l_ac = ARR_CURR()
                LET l_ac_t = l_ac
                IF INT_FLAG THEN                 #900423
                   CALL cl_err('',9001,0)
                   LET INT_FLAG = 0
                   IF p_cmd = 'u' THEN
                      LET g_wcd[l_ac].* = g_wcd_t.*
                   END IF
                   CLOSE wcd_bc1
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
                CLOSE wcd_bc1
                COMMIT WORK
 
        ON ROW CHANGE
                IF INT_FLAG THEN                 #900423
                   CALL cl_err('',9001,0)
                   LET INT_FLAG = 0
                   LET g_wcd[l_ac].* = g_wcd_t.*
                   CLOSE wcd_bc1
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
                IF l_lock_sw = 'Y' THEN
                   CALL cl_err(g_wcd[l_ac].wcd02,-263,1)
                   LET g_wcd[l_ac].* = g_wcd_t.*
                ELSE
                    ## MOD-490275
                   IF g_wcd[l_ac].wcd01 IS NULL THEN
                     CALL cl_err('',9001,0)
                     LET INT_FLAG = 0
                     LET g_wcd[l_ac].* = g_wcd_t.*
                     CLOSE wcd_bc1
                     ROLLBACK WORK
                   END IF
                    ## END MOD-490275
                   UPDATE wcd_file SET wcd01 = g_wcd[l_ac].wcd01,
                                       wcd02 = g_wcd[l_ac].wcd02                                      
                      WHERE wcd01 = g_wcd_t.wcd01 AND
                            wcd02 = g_wcd_t.wcd02 
 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","wcd_file",g_wcd[l_ac].wcd01,g_wcd[l_ac].wcd02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                      LET g_wcd[l_ac].* = g_wcd_t.*
                      CLOSE wcd_bc1
                      ROLLBACK WORK
                   ELSE
                      MESSAGE 'UPDATE O.K'
                      CLOSE wcd_bc1
                      COMMIT WORK
                   END IF
                END IF
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(wcd01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta01"                  
                  LET g_qryparam.default1 = g_wcd[l_ac].wcd01
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wcd[l_ac].wcd01                  
                  DISPLAY BY NAME g_wcd[l_ac].wcd01
                  
            END CASE                  
                  
                  
        ON ACTION CONTROLF                   # 欄位說明    #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913 
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
    
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
    
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
    
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
 
    END INPUT
    
    CLOSE wcd_bc1
    COMMIT WORK
END FUNCTION
 
FUNCTION wcd_query()
    CLEAR FORM
    CALL g_wcd.clear()
 
    CONSTRUCT g_wc2 ON wcd01,wcd02  
     FROM s_wcd[1].wcd01,s_wcd[1].wcd02
 
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(wcd01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta01"
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_wcd[1].wcd01                               
 
              OTHERWISE
                   EXIT CASE
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
 
    
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    CALL wcd_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION spccfg_b_fill(p_wcc02)             #BODY FILL UP
DEFINE
    p_wcc02          LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1)
    l_cnt            LIKE type_file.num5,   #No.FUN-680130 SMALLINT
    l_i              LIKE type_file.num5,   #No.FUN-680130 SMALLINT
    l_item           STRING
    LET g_sql =
        "SELECT wcc02,'',wcc03", #FUN-640182
        " FROM wcc_file",          
        " WHERE wcc01 = '", g_wca.wca01 CLIPPED, "'",                  #單身        
        " ORDER BY wcc02"
    PREPARE spccfg_pb FROM g_sql
    DECLARE spccfg_curs CURSOR FOR spccfg_pb
 
    CALL g_wcc.clear() #單身 ARRAY 乾洗
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH spccfg_curs INTO g_wcc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        
        IF cl_null(g_wcc[g_cnt].wcc03) THEN
           LET g_wcc[g_cnt].wcc03 ='N'
        END IF
 
        #FUN-640182---start---
         SELECT gae04 INTO g_wcc[g_cnt].gae04    
           FROM gae_file
         WHERE gae01 = g_wca.wca01 
           and gae02 = g_wcc[g_cnt].wcc02
           and gae03 = g_lang
           and gae11 = 'Y'                           #CHI-9C0016
           and gae12 = g_sma.sma124                  #CHI-9C0016
        #-CHI-9C0016-add- 
         IF SQLCA.sqlcode THEN 
           SELECT gae04 INTO g_wcc[g_cnt].gae04 
             FROM gae_file 
            WHERE gae01 = g_wca.wca01 
              AND gae02 = g_wcc[g_cnt].wcc02 
              AND gae03 = g_lang
              AND (gae11 IS NULL OR gae11 = 'N')
              AND gae12 = g_sma.sma124 
         END IF
         IF SQLCA.SQLCODE THEN   #失敗的話以欄位名稱當作欄位的說明
            SELECT gaq03 INTO g_wcc[g_cnt].gae04 
              FROM gaq_file 
             WHERE gaq01 = g_wcc[g_cnt].wcc02 
               AND gaq02 = g_lang 
       
            IF SQLCA.SQLCODE THEN
               LET g_wcc[g_cnt].gae04 = g_wcc[g_cnt].wcc02 
            END IF
         END IF
        #-CHI-9C0016-end- 
 
         IF cl_null(g_wcc[g_cnt].gae04) THEN
           SELECT gaq03 INTO g_wcc[g_cnt].gae04
           FROM gaq_file
            WHERE gaq01 = g_wcc[g_cnt].wcc02
              and gaq02 = g_lang
         END IF
        #FUN-640182---end---
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    
    CALL g_wcc.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION spccfg_b(p_wcc02)
DEFINE
    l_ac_t          LIKE type_file.num5,               #No.FUN-680130 SMALLINT
    l_n             LIKE type_file.num5,               #No.FUN-680130 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否 #No.FUN-680130 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態   #No.FUN-680130 VARCHAR(1)
    p_wcc02	    LIKE type_file.chr1,               #No.FUN-680130 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #可新增否   #No.FUN-680130 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1    #可刪除否   #No.FUN-680130 VARCHAR(1)
DEFINE l_message    STRING
DEFINE l_ze03       LIKE ze_file.ze03
DEFINE l_cnt        LIKE type_file.num10   #No.FUN-680130 INTEGER
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
 LET g_forupd_sql = " SELECT wcc02,'',wcc03",
       " FROM wcc_file ",
      "   WHERE wcc01=?  AND wcc02= ?  ",
      "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE spccfg_bcl CURSOR FROM g_forupd_sql    # LOCK CURSOR
 
    INPUT ARRAY g_wcc WITHOUT DEFAULTS FROM s_wcc.*
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
 
               LET p_cmd='u'
               LET g_wcc_t.* = g_wcc[l_ac].*  #BACKUP
 
               OPEN spccfg_bcl USING g_wca.wca01, g_wcc_t.wcc02
               IF STATUS THEN
                  CALL cl_err("OPEN spccfg_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH spccfg_bcl INTO g_wcc[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_wcc_t.wcc02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               
               IF cl_null(g_wcc[l_ac].wcc03) THEN
                   LET g_wcc[g_cnt].wcc03 ='N'
               END IF
        
               #FUN-640182 ---start
                SELECT gae04 INTO g_wcc[l_ac].gae04    
                  FROM gae_file
                WHERE gae01 = g_wca.wca01 
                  and gae02 = g_wcc[l_ac].wcc02
                  and gae03 = g_lang
                  and gae11 = 'Y'                           #CHI-9C0016
                  and gae12 = g_sma.sma124                  #CHI-9C0016
               #-CHI-9C0016-add- 
                IF SQLCA.sqlcode THEN 
                 #SELECT gae04 INTO g_wcc[g_cnt].gae04      #TQC-9C0193 mark 
                  SELECT gae04 INTO g_wcc[l_ac].gae04       #TQC-9C0193
                    FROM gae_file 
                   WHERE gae01 = g_wca.wca01 
                    #AND gae02 = g_wcc[g_cnt].wcc02         #TQC-9C0193 mark 
                     AND gae02 = g_wcc[l_ac].wcc02          #TQC-9C0193
                     AND gae03 = g_lang
                     AND (gae11 IS NULL OR gae11 = 'N')
                     AND gae12 = g_sma.sma124 
                END IF
                IF SQLCA.SQLCODE THEN   #失敗的話以欄位名稱當作欄位的說明
                  #SELECT gaq03 INTO g_wcc[g_cnt].gae04     #TQC-9C0193 mark 
                   SELECT gaq03 INTO g_wcc[l_ac].gae04      #TQC-9C0193
                     FROM gaq_file 
                   #WHERE gaq01 = g_wcc[g_cnt].wcc02        #TQC-9C0193 mark 
                    WHERE gaq01 = g_wcc[l_ac].wcc02         #TQC-9C0193
                      AND gaq02 = g_lang 
              
                   IF SQLCA.SQLCODE THEN
                     #LET g_wcc[g_cnt].gae04 = g_wcc[g_cnt].wcc02   #TQC-9C0193 mark
                      LET g_wcc[l_ac].gae04 = g_wcc[l_ac].wcc02     #TQC-9C0193
                   END IF
                END IF
               #-CHI-9C0016-end- 
 
                IF NOT cl_null(g_wcc[l_ac].gae04) THEN
                  LET g_wcc_t.gae04 = g_wcc[l_ac].gae04
                ELSE
                   SELECT gaq03 INTO g_wcc[l_ac].gae04
                   FROM gaq_file
                   WHERE gaq01 = g_wcc[l_ac].wcc02
                     and gaq02 = g_lang
                   LET g_wcc_t.gae04 =g_wcc[l_ac].gae04
                END IF
                #FUN-640182 ---end
            END IF
 
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
         INITIALIZE g_wcc[l_ac].* TO NULL      #900423
            LET g_wcc_t.* = g_wcc[l_ac].*         #新輸入資料
            LET g_wcc[l_ac].wcc03 ='N'
            NEXT FIELD wcc02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_wcc[l_ac].wcc03 IS NULL THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            
            SELECT COUNT(*) INTO l_n FROM wcc_file
             WHERE wcc01 = g_wca.wca01 AND
                   wcc02 = g_wcc[l_ac].wcc02 
 
            IF l_n > 0 THEN
               CALL cl_err(g_wcc[l_ac].wcc02,-239,0)
               NEXT FIELD wcc02
            END IF
            INSERT INTO wcc_file (wcc01,wcc02,wcc03)
                 VALUES (g_wca.wca01,g_wcc[l_ac].wcc02,g_wcc[l_ac].wcc03)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_wcc[l_ac].wcc03,SQLCA.sqlcode,1)   #No.FUN-660155
               CALL cl_err3("ins","wcc_file",g_wca.wca01,g_wcc[l_ac].wcc02,SQLCA.sqlcode,"","",1)   #No.FUN-660155
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
 
 
        AFTER FIELD wcc02
               IF (g_wcc[l_ac].wcc02 != g_wcc_t.wcc02) OR (g_wcc_t.wcc02 IS NULL ) THEN
                 
                 SELECT COUNT(*) INTO l_n FROM wcc_file
                  WHERE wcc01 = g_wca.wca01 AND
                        wcc02 = g_wcc[l_ac].wcc02
                         
                 IF l_n > 0 THEN
                    CALL cl_err(g_wcc[l_ac].wcc02,-239,0)
                    NEXT FIELD wcc02
                 END IF
               END IF
           
               #FUN-640182 ---start
                LET g_wcc[l_ac].gae04="" 
                SELECT gae04 INTO g_wcc[l_ac].gae04    
                  FROM gae_file
                WHERE gae01 = g_wca.wca01 
                  and gae02 = g_wcc[l_ac].wcc02
                  and gae03 = g_lang
                  and gae11 = 'Y'                           #CHI-9C0016
                  and gae12 = g_sma.sma124                  #CHI-9C0016
               #-CHI-9C0016-add- 
                IF SQLCA.sqlcode THEN 
                 #SELECT gae04 INTO g_wcc[g_cnt].gae04      #TQC-9C0193 mark
                  SELECT gae04 INTO g_wcc[l_ac].gae04       #TQC-9C0193
                    FROM gae_file 
                   WHERE gae01 = g_wca.wca01 
                    #AND gae02 = g_wcc[g_cnt].wcc02         #TQC-9C0193 mark
                     AND gae02 = g_wcc[l_ac].wcc02          #TQC-9C0193
                     AND gae03 = g_lang
                     AND (gae11 IS NULL OR gae11 = 'N')
                     AND gae12 = g_sma.sma124 
                END IF
                IF SQLCA.SQLCODE THEN   #失敗的話以欄位名稱當作欄位的說明
                  #SELECT gaq03 INTO g_wcc[g_cnt].gae04     #TQC-9C0193 mark 
                   SELECT gaq03 INTO g_wcc[l_ac].gae04      #TQC-9C0193
                     FROM gaq_file 
                   #WHERE gaq01 = g_wcc[g_cnt].wcc02        #TQC-9C0193 mark 
                    WHERE gaq01 = g_wcc[l_ac].wcc02         #TQC-9C0193
                      AND gaq02 = g_lang 
              
                   IF SQLCA.SQLCODE THEN
                     #LET g_wcc[g_cnt].gae04 = g_wcc[g_cnt].wcc02   #TQC-9C0193 mark 
                      LET g_wcc[l_ac].gae04 = g_wcc[l_ac].wcc02     #TQC-9C0193
                   END IF
                END IF
               #-CHI-9C0016-end- 
 
                IF NOT cl_null(g_wcc[l_ac].gae04) THEN
                  DISPLAY g_wcc[l_ac].gae04 TO FORMONLY.gae04
                  LET g_wcc_t.gae04 =g_wcc[l_ac].gae04
                ELSE
                  SELECT gaq03 INTO g_wcc[l_ac].gae04
                  FROM gaq_file
                  WHERE gaq01 = g_wcc[l_ac].wcc02
                    and gaq02 = g_lang
                  DISPLAY g_wcc[l_ac].gae04 TO FORMONLY.gae04
                  LET g_wcc_t.gae04 =g_wcc[l_ac].gae04
                END IF
                #FUN-640182 ---end 
 
        
        BEFORE DELETE                            #是否取消單身
            IF g_wcc_t.wcc02 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
{ckp#1}           DELETE FROM wcc_file
                  WHERE wcc01 = g_wca.wca01 AND
                      wcc02 = g_wcc_t.wcc02 
                      
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wcc_t.wcc02,SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete Ok"
               CLOSE spccfg_bcl
               COMMIT WORK
            END IF
 
        AFTER ROW
                CALL spccfg_set_entry_b()
                LET l_ac = ARR_CURR()
                LET l_ac_t = l_ac
                IF INT_FLAG THEN                 #900423
                   CALL cl_err('',9001,0)
                   LET INT_FLAG = 0
                   IF p_cmd = 'u' THEN
                      LET g_wcc[l_ac].* = g_wcc_t.*
                   END IF
                   CLOSE spccfg_bcl
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
                CLOSE spccfg_bcl
                COMMIT WORK
 
        ON ROW CHANGE
                IF INT_FLAG THEN                 #900423
                   CALL cl_err('',9001,0)
                   LET INT_FLAG = 0
                   LET g_wcc[l_ac].* = g_wcc_t.*
                   CLOSE spccfg_bcl
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
                IF l_lock_sw = 'Y' THEN
                   CALL cl_err(g_wcc[l_ac].wcc02,-263,1)
                   LET g_wcc[l_ac].* = g_wcc_t.*
                ELSE
                    ## MOD-490275
                   IF g_wcc[l_ac].wcc02 IS NULL THEN
                     CALL cl_err('',9001,0)
                     LET INT_FLAG = 0
                     LET g_wcc[l_ac].* = g_wcc_t.*
                     CLOSE spccfg_bcl
                     ROLLBACK WORK
                   END IF
                    ## END MOD-490275
                   UPDATE wcc_file SET wcc02 = g_wcc[l_ac].wcc02,
                                       wcc03 = g_wcc[l_ac].wcc03                                       
                      WHERE wcc01 = g_wca.wca01 AND
                            wcc02 = g_wcc_t.wcc02 
 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","wcc_file",g_wca.wca01,g_wcc[l_ac].wcc02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                      LET g_wcc[l_ac].* = g_wcc_t.*
                      CLOSE spccfg_bcl
                      ROLLBACK WORK
                   ELSE
                      MESSAGE 'UPDATE O.K'
                      CLOSE spccfg_bcl
                      COMMIT WORK
                   END IF
                END IF
 
        ON ACTION CONTROLF                   # 欄位說明    #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
    
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
    
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
    
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
 
    END INPUT
    
    CLOSE spccfg_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION spccfg_copy()
 DEFINE l_newno         LIKE wca_file.wca01,
        l_oldno         LIKE wca_file.wca01,
	l_cnt		LIKE type_file.num5    #No.FUN-680130 SMALLINT
 DEFINE l_zz01          LIKE zz_file.zz01,     #FUN-5A0207
        l_zz011         LIKE zz_file.zz011     #FUN-5A0207
 
    IF s_shut(0) THEN RETURN END IF
    IF g_wca.wca01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    INPUT l_newno FROM wca01
         BEFORE INPUT
            DISPLAY '' TO zz02
 
         AFTER FIELD wca01
            IF l_newno IS NULL THEN
                NEXT FIELD wca01
            END IF
            SELECT zz01,zz011 INTO l_zz01,l_zz011
               FROM zz_file WHERE zz01 = l_newno       #FUN-5A0207
            IF SQLCA.SQLCODE THEN
              CALL cl_err(l_newno,SQLCA.SQLCODE,0)   
               NEXT FIELD wca01
            END IF
            SELECT COUNT(*) INTO l_cnt FROM wca_file WHERE wca01 = l_newno
            IF l_cnt > 0 THEN                  # Duplicated
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD wca01
            END IF
            CALL spccfg_zz02(l_newno)
 
         ON ACTION controlp
             CASE
                 WHEN INFIELD(wca01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gaz1"
                   LET g_qryparam.default1 = l_newno
                   LET g_qryparam.default2 = NULL
                   LET g_qryparam.arg1 = g_lang CLIPPED
                   CALL cl_create_qry() RETURNING l_newno,g_zz02
                   DISPLAY l_newno TO wca01
                   DISPLAY g_zz02 TO FORMONLY.zz02
             END CASE
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
    
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
    
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
    
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_wca.wca01
        CALL spccfg_zz02(g_wca.wca01)
        RETURN
    END IF
 
    BEGIN WORK
 
    DROP TABLE x
    SELECT * FROM wca_file WHERE wca01 = g_wca.wca01 INTO TEMP x
    UPDATE x SET wca01 = l_newno,
                 wcaacti = 'Y',
                 wcauser = g_user,
                 wcagrup= g_grup,
                 wcamodu = NULL,
                 wcadate = g_today
    INSERT INTO wca_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("ins","wca_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM wcb_file WHERE wcb01 = g_wca.wca01 INTO TEMP x
    UPDATE x SET wcb01 = l_newno
    INSERT INTO wcb_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("ins","wcb_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM wcc_file WHERE wcc01 = g_wca.wca01 INTO TEMP x
    UPDATE x SET wcc01 = l_newno
    INSERT INTO wcc_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("ins","wcc_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
 
    
    
    COMMIT WORK
 
    MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
    LET l_oldno = g_wca.wca01
    LET g_wca.wca01 = l_newno
    SELECT wca_file.* INTO g_wca.* FROM wca_file
           WHERE wca01 = l_newno
    CALL spccfg_u()
    #FUN-C80046---begin
    #SELECT wca_file.* INTO g_wca.* FROM wca_file
    #       WHERE wca01 = l_oldno
    #
    #LET g_wca.wca01 = l_oldno
    #CALL spccfg_show()
    #FUN-C80046---end
    OPEN spccfg_count
    FETCH spccfg_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    IF l_newno < l_oldno THEN
       LET g_curs_index = g_curs_index + 1
    END IF
    CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    OPEN spccfg_cs
    LET g_jump = g_curs_index
    LET mi_no_ask = TRUE   #No.FUN-6A0075
    CALL spccfg_fetch('/')
    #FUN-C80046---begin
    SELECT wca_file.* INTO g_wca.* FROM wca_file
           WHERE wca01 = l_newno
    CALL spccfg_show()     
    #FUN-C80046---end
END FUNCTION
 
FUNCTION spccfg_set_entry()
   IF g_wcb.wcb03 IS NOT NULL THEN
       CALL cl_set_comp_entry("wcb04", TRUE)
   END IF
   IF g_wcb.wcb04 IS NOT NULL THEN
       CALL cl_set_comp_entry("wcb05", TRUE)
   END IF
   IF g_wcb.wcb05 IS NOT NULL THEN
       CALL cl_set_comp_entry("wcb06", TRUE)
   END IF
   IF g_wcb.wcb06 IS NOT NULL THEN
       CALL cl_set_comp_entry("wcb07", TRUE)
   END IF
   
END FUNCTION
 
FUNCTION spccfg_set_no_entry()
   IF g_wcb.wcb03 IS NULL THEN
       CALL cl_set_comp_entry("wcb04,wcb05,wcb06,wcb07", FALSE)
       LET g_wcb.wcb04 = NULL
       LET g_wcb.wcb05 = NULL
       LET g_wcb.wcb06 = NULL
       LET g_wcb.wcb07 = NULL
   END IF
   IF g_wcb.wcb04 IS NULL THEN
       CALL cl_set_comp_entry("wcb05,wcb06,wcb07", FALSE)
       LET g_wcb.wcb05 = NULL
       LET g_wcb.wcb06 = NULL
       LET g_wcb.wcb07 = NULL
   END IF
   IF g_wcb.wcb05 IS NULL THEN
       CALL cl_set_comp_entry("wcb06,wcb07", FALSE)
       LET g_wcb.wcb06 = NULL
       LET g_wcb.wcb07 = NULL
   END IF
   IF g_wcb.wcb06 IS NULL THEN
       CALL cl_set_comp_entry("wcb07", FALSE)
       LET g_wcb.wcb07 = NULL
   END IF
   
END FUNCTION
 
FUNCTION spccfg_set_entry_b()
       #CALL cl_set_comp_entry("wcc04,wcc06,wcc07", TRUE)
END FUNCTION
 
FUNCTION spccfg_set_no_entry_b()
       #CALL cl_set_comp_entry("wcc04,wcc06,wcc07", FALSE)
END FUNCTION
 
FUNCTION spccfg_field_wcb(p_colname)
   DEFINE p_colname STRING
 
   IF NOT INFIELD(wcb03) AND g_wcb.wcb03 IS NOT NULL THEN
      IF g_wcb.wcb03 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wcb04) AND g_wcb.wcb04 IS NOT NULL THEN
     IF g_wcb.wcb04 CLIPPED = p_colname CLIPPED THEN
        RETURN 0
     END IF
   END IF
   IF NOT INFIELD(wcb05) AND g_wcb.wcb05 IS NOT NULL THEN
      IF g_wcb.wcb05 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wcb06) AND g_wcb.wcb06 IS NOT NULL THEN
      IF g_wcb.wcb06 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wcb07) AND g_wcb.wcb07 IS NOT NULL THEN
      IF g_wcb.wcb07 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wcb08) AND g_wcb.wcb08 IS NOT NULL THEN
      IF g_wcb.wcb08 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF
   IF NOT INFIELD(wcb09) AND g_wcb.wcb09 IS NOT NULL THEN
      IF g_wcb.wcb09 CLIPPED = p_colname CLIPPED THEN
         RETURN 0
      END IF
   END IF   
   RETURN 1
END FUNCTION
 
 
FUNCTION spccfg_combobox(p_tabname)
    DEFINE p_tabname    LIKE type_file.chr20   #No.FUN-680130 VARCHAR(20)
    DEFINE l_colname    LIKE type_file.chr20   #No.FUN-680130 VARCHAR(20)
    DEFINE l_items      STRING 
    DEFINE l_i          LIKE type_file.num5    #No.FUN-680130 SMALLINT

    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構 
    ##FUN-5A0136
    #CASE cl_db_get_database_type()
    #    WHEN "ORA"
    #         LET g_sql= "SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = UPPER('",p_tabname CLIPPED,"') AND OWNER='DS' ORDER BY COLUMN_ID"
    #    WHEN "IFX"
    #         LET g_sql = "SELECT colname FROM ds:syscolumns col, systables tab WHERE tab.tabname = '",p_tabname CLIPPED ,"' AND tab.tabid = col.tabid ORDER BY colno"
    #END CASE
    ##END FUN-5A0136
    LET g_sql= "SELECT sch02 FROM sch_file ", 
               "  WHERE sch01 = '",p_tabname CLIPPED,"' ",
               " ORDER BY sch05"
    #---FUN-A90024---end-------  
 
    DECLARE spccfg_cur5 CURSOR FROM g_sql
    LET l_i=0
    INITIALIZE l_items TO NULL
    FOREACH spccfg_cur5 INTO l_colname
            LET l_i = l_i + 1
            IF l_i = 1 THEN
               LET l_items = l_colname CLIPPED
            ELSE
               LET l_items = l_items,",",l_colname CLIPPED
            END IF
    END FOREACH
    LET l_items = l_items.toLowerCase()
    RETURN l_items
END FUNCTION
 
FUNCTION spccfg_combo_list()
DEFINE   l_items      STRING
      IF INFIELD(wcb02) OR g_beforeinput="FALSE" THEN
               LET l_items = spccfg_combobox(g_wcb.wcb02)
               CALL cl_set_combo_items("wcb03",l_items,l_items)
               CALL cl_set_combo_items("wcb04",l_items,l_items)
               CALL cl_set_combo_items("wcb05",l_items,l_items)
               CALL cl_set_combo_items("wcb06",l_items,l_items)
               CALL cl_set_combo_items("wcb07",l_items,l_items)
               CALL cl_set_combo_items("wcb08",l_items,l_items)
               CALL cl_set_combo_items("wcb09",l_items,l_items)
      END IF     
END FUNCTION
 
FUNCTION aws_spccfg_exception()
 
    LET l_ac = 1
    CALL aws_exc_fill()
    OPEN WINDOW spccfg_exc AT 4, 16
        WITH FORM "aws/42f/aws_spccfg_plant" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_locale("aws_spccfg_plant")
    CALL exception_menu()
    CLOSE WINDOW spccfg_exc
END FUNCTION
 
FUNCTION exception_menu()
   WHILE TRUE      
      CALL exception_bp("G")
      CASE g_action_choice         
         WHEN "detail"
             IF l_ac != 0 THEN
                CALL aws_exc_maintain("modify")
             END IF     
             
         WHEN "insert"          
                CALL aws_exc_maintain("insert")             
             
         WHEN "modify"
             IF l_ac != 0 THEN
                CALL aws_exc_maintain("modify")
             END IF 
             
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()         
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION exception_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130 VARCHAR(1)
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "    
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_bwce TO s_bwce.* ATTRIBUTE(COUNT=g_exc_cnt,UNBUFFERED)
 
      BEFORE ROW
          LET l_ac = ARR_CURR()
          IF l_ac != 0 THEN
             DISPLAY g_bwce[l_ac].bwce06 TO wce06
             DISPLAY g_bwce[l_ac].bwce04 TO wce04
             DISPLAY g_bwce[l_ac].bwce02 TO wce02
             DISPLAY g_bwce[l_ac].bwce03 TO wce03
          END IF
 
      AFTER DISPLAY
          CONTINUE DISPLAY
 
      ON ACTION insert
          LET g_action_choice="insert"              
          EXIT DISPLAY
 
      ON ACTION modify
          LET g_action_choice="modify"
          LET l_ac = ARR_CURR()          
          EXIT DISPLAY
          
      ON ACTION delete
         IF l_ac != 0 THEN
             IF cl_delete() THEN
               DELETE FROM wce_file WHERE wce01 = 'E' AND wce05 = '*'
                   AND wce06 = g_bwce[l_ac].bwce06 AND wce07='*'
               IF SQLCA.SQLCODE THEN
#                 CALL cl_err('del wca: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
                  CALL cl_err3("del","wce_file",g_bwce[l_ac].bwce06,"",SQLCA.sqlcode,"","del wca:", 0)   #No.FUN-660155)   #No.FUN-660155
               END IF
               CALL aws_exc_fill()
               IF g_bwce.getLength() = 0 THEN
                  DISPLAY '' TO wce06
                  DISPLAY '' TO wce04
                  DISPLAY '' TO wce02
                  DISPLAY '' TO wce03
               END IF
               ACCEPT DISPLAY
             END IF
          END IF
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
    IF INT_FLAG THEN                         # 若按了DEL鍵
        LET INT_FLAG = 0
    END IF
   
END FUNCTION
 
 
 
FUNCTION aws_exc_fill()
    LET g_sql = "SELECT wce06,wce04,wce02,wce03 FROM wce_file where wce01='E'"
 
    PREPARE spccfg_pp FROM g_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90032
       EXIT PROGRAM
    END IF
    DECLARE spccfg_cs2 CURSOR FOR spccfg_pp
    CALL g_bwce.clear()
    LET g_exc_cnt=1
    FOREACH spccfg_cs2 INTO g_bwce[g_exc_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_exc_cnt=g_exc_cnt+1
   END FOREACH
   CALL g_bwce.deleteElement(g_exc_cnt)
   
END FUNCTION
 
FUNCTION aws_exc_maintain(p_cmd)
DEFINE p_cmd       LIKE type_file.chr20   #No.FUN-680130 VARCHAR(10) 
DEFINE l_cnt       LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_wce06     LIKE wce_file.wce06
 
    INITIALIZE g_wce.* TO NULL
    LET g_action_choice = ""
    
    IF p_cmd = "modify" THEN
       LET g_wce.wce06 = g_bwce[l_ac].bwce06
       LET g_wce.wce04 = g_bwce[l_ac].bwce04
       LET g_wce.wce02 = g_bwce[l_ac].bwce02
       LET g_wce.wce03 = g_bwce[l_ac].bwce03
       LET l_wce06 = g_bwce[l_ac].bwce06
       CALL cl_set_comp_entry("wce06", FALSE)
    END IF
 
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
    INPUT BY NAME g_wce.wce06,g_wce.wce04,g_wce.wce02,g_wce.wce03
        WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
        BEFORE INPUT
           LET g_wce.wce01 = 'E'
           LET g_wce.wce05 = '*'
           LET g_wce.wce07 = '*'
 
        AFTER FIELD wce06
           IF g_wce.wce06 IS NOT NULL THEN
                SELECT COUNT(*) INTO l_cnt FROM azp_file
                        where azp01 = g_wce.wce06
                IF l_cnt = 0 THEN
                   CALL cl_err(g_wce.wce06,"-827",0)
                   NEXT FIELD wce06
                END IF
           END IF
 
        AFTER INPUT
           IF p_cmd = "insert" THEN
              SELECT COUNT(*) INTO l_cnt FROM wce_file
                WHERE wce01 = g_wce.wce01 AND wce05 = g_wce.wce05 AND
                      wce06 = g_wce.wce06 AND wce07 = g_wce.wce07
              IF l_cnt > 0 THEN
                  CALL cl_err(g_wce.wce06,-239,0)
                  NEXT FIELD wce06
              END IF
           END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(wce06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azp"
              LET g_qryparam.default1 = g_wce.wce06
              CALL cl_create_qry() RETURNING g_wce.wce06
              DISPLAY BY NAME g_wce.wce06
              NEXT FIELD wce06
           END CASE
 
        ON ACTION CONTROLF                   # 欄位說明    #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
    
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
    
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
    
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CALL aws_exc_fill()
        IF p_cmd = "modify" THEN
           CALL cl_set_comp_entry("wce06", TRUE)
        END IF
        CALL cl_set_act_visible("accept,cancel", FALSE)
        RETURN
    END IF
    IF p_cmd ="insert" THEN
        INSERT INTO wce_file VALUES(g_wce.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wce.wce01,SQLCA.sqlcode,0)   #No.FUN-660155
           CALL cl_err3("ins","wce_file",g_wce.wce01,g_wce.wce05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
        END IF
    ELSE
        UPDATE wce_file SET wce06 = g_wce.wce06,
                            wce04 = g_wce.wce04,
                            wce02 = g_wce.wce02,
                            wce03 = g_wce.wce03
            WHERE wce01 = g_wce.wce01 AND wce05 = g_wce.wce05 AND
                  wce06 = l_wce06 AND wce07 = g_wce.wce07
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsf.wsf01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wce_file",g_wce.wce01,g_wce.wce05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
        END IF
    END IF
    CALL aws_exc_fill()
 
    IF p_cmd = "modify" THEN
       CALL cl_set_comp_entry("wce06", TRUE)
    END IF
    CALL cl_set_act_visible("accept,cancel", FALSE)
END FUNCTION
 
 
FUNCTION aws_spc_trans()
    LET l_ac = 1
    OPEN WINDOW spccfg_trans AT 4, 16
        WITH FORM "aws/42f/aws_spc_trans" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_locale("aws_spc_trans")    
    CALL trans_b_fill()
    CALL trans_bp(null)
    CLOSE WINDOW spccfg_trans
END FUNCTION
 
FUNCTION trans_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
            l_i    LIKE type_file.num5,          #No.FUN-680130 SMALLINT
            l_n    LIKE type_file.num5,          #No.FUN-680130 SMALLINT
            l_str  STRING
            
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
    INPUT ARRAY g_trans WITHOUT DEFAULTS FROM s_trans.*
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=0,DELETE ROW=0,APPEND ROW=0)
                  
        BEFORE INPUT
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
            END IF
            
        BEFORE ROW     
            LET l_ac = ARR_CURR()         
            LET l_n  = ARR_COUNT()     
            
       ON ROW CHANGE
       
       ON ACTION selectAll       
          FOR l_i = 1 TO l_n
              LET g_trans[l_i].chk01='Y'
              DISPLAY BY NAME g_trans[l_i].chk01
          END FOR
          
       ON ACTION deSelect
          FOR l_i = 1 TO l_n
              LET g_trans[l_i].chk01='N'
              DISPLAY BY NAME g_trans[l_i].chk01
          END FOR 
 
       #TQC-860022
       ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
       
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
       
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
       
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
       #END TQC-860022      
   END INPUT     
   IF INT_FLAG THEN
      LET INT_FLAG = 0   
      CALL cl_set_act_visible("accept,cancel", FALSE)
      RETURN
   END IF       
   
   FOR l_i = 1 TO l_n
       IF g_trans[l_i].chk01='Y' THEN
          IF l_str is null THEN
             LET l_str = g_trans[l_i].wcd01 
          ELSE
             LET l_str = l_str , "|" ,  g_trans[l_i].wcd01
          END IF   
       END IF          
   END FOR
   
   IF l_str is null THEN
      RETURN
   ELSE
      CALL aws_spccli_base(l_str,'','insert')
   END IF
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
END FUNCTION
 
FUNCTION trans_b_fill()
DEFINE   
    l_cnt            LIKE type_file.num10,         #No.FUN-680130 INTEGER
    l_i              LIKE type_file.num10,         #No.FUN-680130 INTEGER
    l_item           STRING   
    
   
    LET g_sql =
        "SELECT distinct 'N',wcd01,'' ",
        " FROM wcd_file",                  
        " ORDER BY wcd01 "
 
    PREPARE trans_sql FROM g_sql
    DECLARE spctrans_curs CURSOR FOR trans_sql
 
    CALL g_trans.clear() #單身 ARRAY 乾洗
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH spctrans_curs INTO g_trans[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        
        IF  g_trans[g_cnt].wcd01  IS NOT NULL THEN       
            SELECT gat03 INTO g_trans[g_cnt].gat03 
            FROM gat_file   
             WHERE gat01 = g_trans[g_cnt].wcd01    
               AND gat02 = g_lang
               
        END IF       
          
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    
    CALL g_trans.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
#Patch....NO.TQC-610037 <001,002> #
