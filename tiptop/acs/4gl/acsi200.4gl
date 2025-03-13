# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: acsi200.4gl
# Descriptions...: 料件成本模擬資料維護作業
# Date & Author..: 92/01/15 By Lin
# 4.0 release....: 92/07/23 By Jones
# Modify.........: No.FUN-510039 05/03/02 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-580110 05/08/26 By jackie 報表轉XML格式
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-660089 06/06/16 By cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680071 06/09/05 By chen 類型轉換
# Modify.........: No.FUN-6A0150 06/10/26 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-860021 08/06/11 By Sarah INPUT漏了ON IDLE控制
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_csa   RECORD LIKE csa_file.*,
    g_csa_t RECORD LIKE csa_file.*,
    g_csa_o RECORD LIKE csa_file.*,
    g_csa01_t LIKE csa_file.csa01,
    g_csa02_t LIKE csa_file.csa02,
    g_imaacti LIKE ima_file.imaacti,
    g_argv1   LIKE csa_file.csa01,
    g_wc,g_sql          LIKE type_file.chr1000#TQC-630166  #No.FUN-680071 VARCHAR(300)
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done      LIKE type_file.num5            #No.FUN-570110  #No.FUN-680071 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680071 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680071 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680071 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680071 INTEGER
MAIN
     DEFINE  #  l_time LIKE type_file.chr8              #No.FUN-6A0064
           p_argv1         LIKE ima_file.ima01
   DEFINE p_row,p_col	LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACS")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
    INITIALIZE g_csa.* TO NULL
    INITIALIZE g_csa_t.* TO NULL
    LET g_argv1 = ARG_VAL(1)
 
    LET g_forupd_sql = "SELECT * FROM csa_file WHERE csa01 = ? AND csa02 = ?   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE acsi200_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW acsi200_w AT p_row,p_col WITH FORM "acs/42f/acsi200"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
       CALL acsi200_q()
    END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL acsi200_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW acsi200_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
END MAIN
 
FUNCTION acsi200_curs()
   DEFINE l_cost     LIKE type_file.chr1,            #No.FUN-680071  VARCHAR(1)
          p_cost     LIKE type_file.chr1             #No.FUN-680071  VARCHAR(1)
 
    CLEAR FORM
    IF g_argv1 IS NULL OR g_argv1 = ' ' THEN
   INITIALIZE g_csa.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
                      csa01, csa02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(csa01) #料件編號
#                 CALL q_ima(10,3,g_csa.csa01) RETURNING g_csa.csa01
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = "q_ima"
                #  LET g_qryparam.state = "c"
                #  LET g_qryparam.default1 = g_csa.csa01
                #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","",g_csa.csa01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO csa01
                  CALL acsi200_csa01('d')
                  NEXT FIELD csa01
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
 
       IF INT_FLAG THEN  RETURN END IF
    ELSE LET g_csa.csa01 = g_argv1
         DISPLAY g_csa.csa01 TO csa01
         CALL acsi200_csa01('d')
         LET g_wc = " csa01 = '",g_argv1,"'"
    END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND csauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND csagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND csagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('csauser', 'csagrup')
    #End:FUN-980030
 
    LET g_sql="SELECT csa01,csa02 FROM csa_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED,
        " ORDER BY csa01 "
    PREPARE acsi200_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE acsi200_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR acsi200_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM csa_file WHERE ",g_wc CLIPPED
    PREPARE acsi200_precount FROM g_sql
    DECLARE acsi200_count CURSOR FOR acsi200_precount
END FUNCTION
 
FUNCTION acsi200_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL acsi200_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL acsi200_fetch('N')
        ON ACTION previous
            CALL acsi200_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL acsi200_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL acsi200_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL acsi200_r()
            END IF
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL acsi200_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
       ON ACTION jump
           CALL acsi200_fetch('/')
       ON ACTION first
           CALL acsi200_fetch('F')
       ON ACTION last
           CALL acsi200_fetch('L')
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0150-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_csa.csa01 IS NOT NULL THEN            
                  LET g_doc.column1 = "csa01"               
                  LET g_doc.column2 = "csa02"               
                  LET g_doc.value1 = g_csa.csa01            
                  LET g_doc.value2 = g_csa.csa02           
                  CALL cl_doc()                             
               END IF                                        
            END IF                                           
         #No.FUN-6A0150-------add--------end----
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE acsi200_curs
END FUNCTION
 
 
FUNCTION acsi200_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
    DISPLAY BY NAME g_csa.csauser,g_csa.csagrup,
        g_csa.csadate, g_csa.csaacti
#     INPUT g_csa.csa0301,g_csa.csa0302,g_csa.csa0303,g_csa.csa0304,
      INPUT g_csa.csa01,g_csa.csa02,g_csa.csa0301,g_csa.csa0302,g_csa.csa0303,g_csa.csa0304,         #No.FUN-570110
           g_csa.csa0305,g_csa.csa0306,g_csa.csa0307,g_csa.csa0308,
           g_csa.csa0309,g_csa.csa0310,g_csa.csa0312,g_csa.csa0311,
           g_csa.csa0321,g_csa.csa0322,g_csa.csa0323,g_csa.csa0324,
           g_csa.csa0325,g_csa.csa0326,g_csa.csa0327,g_csa.csa0328,
           g_csa.csa0329,g_csa.csa0330,g_csa.csa0331
           WITHOUT DEFAULTS
#      FROM csa0301      ,csa0302      ,csa0303      ,csa0304      ,
      FROM csa01,csa02,csa0301      ,csa0302      ,csa0303      ,csa0304      ,   #No.FUN-570110
           csa0305      ,csa0306      ,csa0307      , csa0308     ,
           csa0309      ,csa0310     ,csa0312      ,csa0311      ,
           csa0321      ,csa0322, csa0323, csa0324, csa0325,
           csa0326,csa0327, csa0328, csa0329, csa0330, csa0331
 
#No.FUN-570110--begin
    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i200_set_entry(p_cmd)
        CALL i200_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
#No.FUN-570110--end
 
        AFTER FIELD csa0301
             IF g_csa.csa0301 < 0
                THEN CALL cl_err(g_csa.csa0301,'mfg0013',0)
                     LET g_csa.csa0301 = g_csa_o.csa0301
                     DISPLAY BY NAME g_csa.csa0301
                     NEXT FIELD csa0301
             END IF
             LET g_csa_o.csa0301 = g_csa.csa0301
 
        AFTER FIELD csa0302
             IF g_csa.csa0302 < 0
                THEN CALL cl_err(g_csa.csa0302,'mfg0013',0)
                     LET g_csa.csa0302 = g_csa_o.csa0302
                     DISPLAY BY NAME g_csa.csa0302
                     NEXT FIELD csa0302
             END IF
             LET g_csa_o.csa0302 = g_csa.csa0302
 
        AFTER FIELD csa0303
             IF  g_csa.csa0303 < 0
                THEN CALL cl_err(g_csa.csa0303,'mfg0013',0)
                     LET g_csa.csa0303 = g_csa_o.csa0303
                     DISPLAY BY NAME g_csa.csa0303
                     NEXT FIELD csa0303
             END IF
             LET g_csa_o.csa0303 = g_csa.csa0303
 
        AFTER FIELD csa0304
             IF g_csa.csa0304 < 0
                THEN CALL cl_err(g_csa.csa0304,'mfg0013',0)
                     LET g_csa.csa0304 = g_csa_o.csa0304
                     DISPLAY BY NAME g_csa.csa0304
                     NEXT FIELD csa0304
             END IF
             LET g_csa_o.csa0304 = g_csa.csa0304
 
        AFTER FIELD csa0305
             IF g_csa.csa0305 < 0
                THEN CALL cl_err(g_csa.csa0305,'mfg0013',0)
                     LET g_csa.csa0305 = g_csa_o.csa0305
                     DISPLAY BY NAME g_csa.csa0305
                     NEXT FIELD csa0305
             END IF
             LET g_csa_o.csa0305 = g_csa.csa0305
 
        AFTER FIELD csa0307
             IF g_csa.csa0307 < 0
                THEN CALL cl_err(g_csa.csa0307,'mfg0013',0)
                     LET g_csa.csa0307 = g_csa_o.csa0307
                     DISPLAY BY NAME g_csa.csa0307
                     NEXT FIELD csa0307
             END IF
             LET g_csa_o.csa0307 = g_csa.csa0307
 
        AFTER FIELD csa0308
             IF g_csa.csa0308 < 0
                THEN CALL cl_err(g_csa.csa0308,'mfg0013',0)
                     LET g_csa.csa0308 = g_csa_o.csa0308
                     DISPLAY BY NAME g_csa.csa0308
                     NEXT FIELD csa0308
             END IF
             LET g_csa_o.csa0308 = g_csa.csa0308
 
        AFTER FIELD csa0309
             IF g_csa.csa0309 < 0
                THEN CALL cl_err(g_csa.csa0309,'mfg0013',0)
                     LET g_csa.csa0309 = g_csa_o.csa0309
                     DISPLAY BY NAME g_csa.csa0309
                     NEXT FIELD csa0309
             END IF
             LET g_csa_o.csa0309 = g_csa.csa0309
 
        AFTER FIELD csa0310
             IF g_csa.csa0310 < 0
                THEN CALL cl_err(g_csa.csa0310,'mfg0013',0)
                     LET g_csa.csa0310 = g_csa_o.csa0310
                     DISPLAY BY NAME g_csa.csa0310
                     NEXT FIELD csa0310
             END IF
             LET g_csa_o.csa0310 = g_csa.csa0310
 
        AFTER FIELD csa0306
             IF g_csa.csa0306 < 0
                THEN CALL cl_err(g_csa.csa0306,'mfg0013',0)
                     LET g_csa.csa0306 = g_csa_o.csa0306
                     DISPLAY BY NAME g_csa.csa0306
                     NEXT FIELD csa0306
             END IF
             LET g_csa_o.csa0306 = g_csa.csa0306
 
        AFTER FIELD csa0311
             IF g_csa.csa0311 < 0
                THEN CALL cl_err(g_csa.csa0311,'mfg0013',0)
                     LET g_csa.csa0311 = g_csa_o.csa0311
                     DISPLAY BY NAME g_csa.csa0311
                     NEXT FIELD csa0311
             END IF
             LET g_csa_o.csa0311 = g_csa.csa0311
 
        AFTER FIELD csa0321
             IF g_csa.csa0321 < 0
                THEN CALL cl_err(g_csa.csa0321,'mfg0013',0)
                     LET g_csa.csa0321 = g_csa_o.csa0321
                     DISPLAY BY NAME g_csa.csa0321
                     NEXT FIELD csa0321
             END IF
             LET g_csa_o.csa0321 = g_csa.csa0321
 
        AFTER FIELD csa0322
             IF g_csa.csa0322 < 0
                THEN CALL cl_err(g_csa.csa0322,'mfg0013',0)
                     LET g_csa.csa0322 = g_csa_o.csa0322
                     DISPLAY BY NAME g_csa.csa0322
                     NEXT FIELD csa0322
             END IF
             LET g_csa_o.csa0322 = g_csa.csa0322
 
        AFTER FIELD csa0323
             IF g_csa.csa0323 < 0
                THEN CALL cl_err(g_csa.csa0323,'mfg0013',0)
                     LET g_csa.csa0323 = g_csa_o.csa0323
                     DISPLAY BY NAME g_csa.csa0323
                     NEXT FIELD csa0323
             END IF
             LET g_csa_o.csa0323 = g_csa.csa0323
 
        AFTER FIELD csa0324
             IF g_csa.csa0324 < 0
                THEN CALL cl_err(g_csa.csa0324,'mfg0013',0)
                     LET g_csa.csa0324 = g_csa_o.csa0324
                     DISPLAY BY NAME g_csa.csa0324
                     NEXT FIELD csa0324
             END IF
             LET g_csa_o.csa0324 = g_csa.csa0324
 
        AFTER FIELD csa0326
             IF g_csa.csa0326 < 0
                THEN CALL cl_err(g_csa.csa0326,'mfg0013',0)
                     LET g_csa.csa0326 = g_csa_o.csa0326
                     DISPLAY BY NAME g_csa.csa0326
                     NEXT FIELD csa0326
             END IF
             LET g_csa_o.csa0326 = g_csa.csa0326
 
        AFTER FIELD csa0327
             IF g_csa.csa0327 < 0
                THEN CALL cl_err(g_csa.csa0327,'mfg0013',0)
                     LET g_csa.csa0327 = g_csa_o.csa0327
                     DISPLAY BY NAME g_csa.csa0327
                     NEXT FIELD csa0327
             END IF
             LET g_csa_o.csa0327 = g_csa.csa0327
 
        AFTER FIELD csa0328
             IF g_csa.csa0328 < 0
                THEN CALL cl_err(g_csa.csa0328,'mfg0013',0)
                     LET g_csa.csa0328 = g_csa_o.csa0328
                     DISPLAY BY NAME g_csa.csa0328
                     NEXT FIELD csa0328
             END IF
             LET g_csa_o.csa0328 = g_csa.csa0328
 
        AFTER FIELD csa0329
             IF g_csa.csa0329 < 0
                THEN CALL cl_err(g_csa.csa0329,'mfg0013',0)
                     LET g_csa.csa0329 = g_csa_o.csa0329
                     DISPLAY BY NAME g_csa.csa0329
                     NEXT FIELD csa0329
             END IF
             LET g_csa_o.csa0329 = g_csa.csa0329
 
        AFTER FIELD csa0330
             IF g_csa.csa0330 < 0
                THEN CALL cl_err(g_csa.csa0330,'mfg0013',0)
                     LET g_csa.csa0330 = g_csa_o.csa0330
                     DISPLAY BY NAME g_csa.csa0330
                     NEXT FIELD csa0330
             END IF
             LET g_csa_o.csa0330 = g_csa.csa0330
 
        AFTER FIELD csa0325
             IF g_csa.csa0325 < 0
                THEN CALL cl_err(g_csa.csa0325,'mfg0013',0)
                     LET g_csa.csa0325 = g_csa_o.csa0325
                     DISPLAY BY NAME g_csa.csa0325
                     NEXT FIELD csa0325
             END IF
             LET g_csa_o.csa0325 = g_csa.csa0325
 
        AFTER FIELD csa0312
             IF g_csa.csa0312 < 0
                THEN CALL cl_err(g_csa.csa0312,'mfg0013',0)
                     LET g_csa.csa0312 = g_csa_o.csa0312
                     DISPLAY BY NAME g_csa.csa0312
                     NEXT FIELD csa0312
             END IF
             LET g_csa_o.csa0312 = g_csa.csa0312
 
        AFTER FIELD csa0331
             IF g_csa.csa0331 < 0
                THEN CALL cl_err(g_csa.csa0331,'mfg0013',0)
                     LET g_csa.csa0331 = g_csa_o.csa0331
                     DISPLAY BY NAME g_csa.csa0331
                     NEXT FIELD csa0331
             END IF
             LET g_csa_o.csa0331 = g_csa.csa0331
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(csa01) #料件編號
#                 CALL q_ima(10,3,g_csa.csa01) RETURNING g_csa.csa01
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = "q_ima"
                #  LET g_qryparam.default1 = g_csa.csa01
                #  CALL cl_create_qry() RETURNING g_csa.csa01
                   CALL q_sel_ima(FALSE, "q_ima", "", g_csa.csa01, "", "", "", "" ,"",'' )  RETURNING g_csa.csa01
#FUN-AA0059 --End--
                  DISPLAY BY NAME g_csa.csa01
                  CALL acsi200_csa01('d')
                  NEXT FIELD csa01
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds   #TQC-860021
           CALL cl_on_idle()     #TQC-860021
           CONTINUE INPUT        #TQC-860021
 
        ON ACTION about          #TQC-860021
           CALL cl_about()       #TQC-860021
 
        ON ACTION help           #TQC-860021
           CALL cl_show_help()   #TQC-860021 
    END INPUT
END FUNCTION
 
FUNCTION acsi200_csa01(p_cmd)
    DEFINE p_cmd    LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
           l_ima05  LIKE ima_file.ima05,
           l_ima08  LIKE ima_file.ima08,
           l_ima25   LIKE ima_file.ima25,
           l_ima02  LIKE ima_file.ima02,
           l_ima03  LIKE ima_file.ima03,
           l_ima86  LIKE ima_file.ima86,
           l_ima86_fac  LIKE ima_file.ima86_fac
 
  LET g_chr = ' '
  IF g_csa.csa01 IS NULL THEN
     LET g_chr = 'E'
     LET l_ima02  = NULL   LET l_ima03 = NULL
     LET l_ima05  = NULL   LET l_ima08 = NULL
     LET l_ima25  = NULL   LET l_ima86 = NULL
     LET l_ima86_fac = 0
  ELSE SELECT ima02,ima03,ima05,ima08,ima25,ima86,ima86_fac,imaacti
         INTO l_ima02,l_ima03,l_ima05,l_ima08,l_ima25,
              l_ima86,l_ima86_fac,g_imaacti
         FROM ima_file
         WHERE ima01 = g_csa.csa01
        IF SQLCA.sqlcode
           THEN LET g_chr = 'E'
                LET l_ima02  = NULL   LET l_ima03 = NULL
                LET l_ima05  = NULL   LET l_ima08 = NULL
                LET l_ima25  = NULL   LET l_ima86 = NULL
                LET l_ima86_fac = 0
           ELSE IF g_imaacti='N' THEN
                   LET g_chr='E'
                END IF
        END IF
  END IF
  IF cl_null(g_chr) OR p_cmd = 'd' THEN
   DISPLAY l_ima02 TO ima02
   DISPLAY l_ima05 TO ima05
   DISPLAY l_ima08 TO ima08
   DISPLAY l_ima25 TO ima25
   DISPLAY l_ima86 TO ima86
   DISPLAY l_ima86_fac TO ima86_fac
  END IF
END FUNCTION
 
FUNCTION acsi200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_csa.* TO NULL                   #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL acsi200_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN acsi200_count
    FETCH acsi200_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN acsi200_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_csa.csa01,SQLCA.sqlcode,0)
        INITIALIZE g_csa.* TO NULL
    ELSE
        CALL acsi200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION acsi200_fetch(p_flcsa)
    DEFINE
        p_flcsa         LIKE type_file.chr1,   #No.FUN-680071 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-680071 INTEGER
 
    CASE p_flcsa
        WHEN 'N' FETCH NEXT     acsi200_curs INTO g_csa.csa01,
                                                  g_csa.csa02
        WHEN 'P' FETCH PREVIOUS acsi200_curs INTO g_csa.csa01,
                                                  g_csa.csa02
        WHEN 'F' FETCH FIRST    acsi200_curs INTO g_csa.csa01,
                                                  g_csa.csa02
        WHEN 'L' FETCH LAST     acsi200_curs INTO g_csa.csa01,
                                                  g_csa.csa02
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
            FETCH ABSOLUTE l_abso acsi200_curs INTO g_csa.csa01,
                                                  g_csa.csa02
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_csa.csa01,SQLCA.sqlcode,0)
        INITIALIZE g_csa.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcsa
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_csa.* FROM csa_file            # 重讀DB,因TEMP有不被更新特性
       WHERE csa01 = g_csa.csa01 AND csa02 = g_csa.csa02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_csa.csa01,SQLCA.sqlcode,0)   #No.FUN-660089
        CALL cl_err3("sel","csa_file",g_csa.csa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
    ELSE
        CALL acsi200_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION acsi200_show()
    DEFINE   l_str       LIKE ze_file.ze03           #No.FUN-680071 VARCHAR(8)
    LET g_csa_t.* = g_csa.*
    CALL acsi200_csa01('d')
    CASE g_csa.csa03
         WHEN '1'  CALL cl_getmsg('mfg1315',g_lang) RETURNING l_str
         WHEN '2'  CALL cl_getmsg('mfg1316',g_lang) RETURNING l_str
         WHEN '3'  CALL cl_getmsg('mfg1317',g_lang) RETURNING l_str
         OTHERWISE EXIT CASE
    END CASE
    DISPLAY l_str   TO FORMONLY.csa03
    DISPLAY BY NAME g_csa.csauser,g_csa.csagrup,
        g_csa.csadate, g_csa.csaacti
    DISPLAY  g_csa.csa01  ,g_csa.csa02  ,g_csa.csa0301,
             g_csa.csa0302,g_csa.csa0303,g_csa.csa0304,
             g_csa.csa0305,g_csa.csa0306,g_csa.csa0307,
             g_csa.csa0308,g_csa.csa0309,g_csa.csa0310,
             g_csa.csa0311,g_csa.csa0321,g_csa.csa0322,
             g_csa.csa0323,g_csa.csa0324,g_csa.csa0325,
             g_csa.csa0326,g_csa.csa0327,g_csa.csa0328,
             g_csa.csa0329,g_csa.csa0330,g_csa.csa0312,g_csa.csa0331
       TO   csa01   ,csa02  ,csa0301,
            csa0302 ,csa0303,csa0304,
            csa0305 ,csa0306,csa0307,
            csa0308 ,csa0309,csa0310,
            csa0311 ,csa0321,csa0322,
            csa0323 ,csa0324,csa0325,
            csa0326 ,csa0327,csa0328,
            csa0329 ,csa0330,csa0312,csa0331
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION acsi200_u()
DEFINE l_ima93    like ima_file.ima93
 
    IF s_shut(0) THEN RETURN END IF
    IF g_csa.csa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_csa.* FROM csa_file
     WHERE csa01=g_csa.csa01
    IF g_csa.csaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_csa.csa01,'9027',0)
        RETURN
    END IF
    IF g_imaacti ='N' THEN        #檢查資料是否為無效
        CALL cl_err(g_csa.csa01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_csa01_t = g_csa.csa01
    LET g_csa02_t = g_csa.csa02
    LET g_csa_o.* = g_csa.*
    LET g_success = 'Y'    # 預設異動更新成功(若失敗時再令此flag為'N')
    BEGIN WORK
 
    OPEN acsi200_curl USING g_csa.csa01,g_csa.csa02
    IF STATUS THEN
       CALL cl_err("OPEN acsi200_curl:", STATUS, 1)
       CLOSE acsi200_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH acsi200_curl INTO g_csa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_csa.csa01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_csa.csamodu=g_user                     #修改者
    LET g_csa.csadate = g_today                  #修改日期
    CALL acsi200_show()                          # 顯示最新資料
    WHILE TRUE
        CALL acsi200_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_csa.*=g_csa_t.*
            CALL acsi200_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE csa_file SET
      csa0301=g_csa.csa0301,csa0302=g_csa.csa0302,csa0303=g_csa.csa0303,
      csa0304=g_csa.csa0304,csa0306=g_csa.csa0306,csa0307=g_csa.csa0307,
      csa0308=g_csa.csa0308,csa0309=g_csa.csa0309,csa0310=g_csa.csa0310,
      csa0305=g_csa.csa0305,csa0311=g_csa.csa0311,csa0312=g_csa.csa0312,
      csa0321=g_csa.csa0321,csa0322=g_csa.csa0322,csa0323=g_csa.csa0323,
      csa0324=g_csa.csa0324,csa0326=g_csa.csa0326,csa0327=g_csa.csa0327,
      csa0328=g_csa.csa0328,csa0329=g_csa.csa0329,csa0330=g_csa.csa0330,
      csa0325=g_csa.csa0325,csa0331=g_csa.csa0331,
      csaacti=g_csa.csaacti,csauser=g_csa.csauser,csagrup=g_csa.csagrup,
      csamodu=g_csa.csamodu,csadate=g_csa.csadate
               WHERE csa01 = g_csa.csa01 AND csa02 = g_csa.csa02             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_csa.csa01,SQLCA.sqlcode,0)   #No.FUN-660089
            CALL cl_err3("upd","csa_file",g_csa.csa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
            CONTINUE WHILE
        ELSE
        #--020613 ORACLE會產生-201 須改寫 #ELSE UPDATE ima_file SET ima93[6,6] = 'Y'
                                          # WHERE ima01 = g_csa.csa01 會產生-201
            SELECT ima93 INTO l_ima93 FROM ima_file
             WHERE ima01 = g_csa.csa01
             LET  l_ima93[6,6]='Y'
             UPDATE ima_file SET ima93=l_ima93,
                                 imadate = g_today     #FUN-C30315 add
                             WHERE ima01 = g_csa.csa01
        #--020613
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_csa.csa01,SQLCA.sqlcode,0)   #No.FUN-660089
               CALL cl_err3("upd","ima_file",g_csa.csa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
            END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE acsi200_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION acsi200_x()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_csa.csa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN acsi200_curl USING g_csa.csa01,g_csa.csa02
    IF STATUS THEN
       CALL cl_err("OPEN acsi200_curl:", STATUS, 1)
       CLOSE acsi200_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH acsi200_curl INTO g_csa.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_csa.csa01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL acsi200_show()
    IF cl_exp(15,21,g_csa.csaacti) THEN
        LET g_chr=g_csa.csaacti
        IF g_csa.csaacti='Y' THEN
            LET g_csa.csaacti='N'
        ELSE
            LET g_csa.csaacti='Y'
        END IF
        UPDATE csa_file
            SET csaacti=g_csa.csaacti,
                csamodu=g_user, csadate=g_today
            WHERE csa01 = g_csa.csa01 AND csa02 = g_csa.csa02
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_csa.csa01,SQLCA.sqlcode,0)   #No.FUN-660089
            CALL cl_err3("upd","csa_file",g_csa.csa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
            LET g_csa.csaacti=g_chr
        END IF
        DISPLAY BY NAME g_csa.csaacti
    END IF
    CLOSE acsi200_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION acsi200_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_csa.csa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN acsi200_curl USING g_csa.csa01,g_csa.csa02
    IF STATUS THEN
       CALL cl_err("OPEN acsi200_curl:", STATUS, 1)
       CLOSE acsi200_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH acsi200_curl INTO g_csa.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_csa.csa01,SQLCA.sqlcode,0) RETURN END IF
    CALL acsi200_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "csa01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "csa02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_csa.csa01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_csa.csa02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM csa_file WHERE csa01 = g_csa.csa01 AND csa02 = g_csa.csa02
        IF SQLCA.SQLERRD[3]=0
            THEN
  #                CALL cl_err(g_csa.csa01,SQLCA.sqlcode,0)   #No.FUN-660089
  #          THEN
  #                CALL cl_err(g_csa.csa01,SQLCA.sqlcode,0)   #No.FUN-660089
             CALL cl_err3("del","csa_file",g_csa.csa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
           ELSE CLEAR FORM
        END IF
    END IF
    CLOSE acsi200_curl
    COMMIT WORK
END FUNCTION
 
 
 
FUNCTION acsi200_out()
    DEFINE
        sr    RECORD  LIKE  csa_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-680071 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-680071 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,               #  #No.FUN-680071 VARCHAR(40)
        l_chr           LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
    IF g_wc IS NULL THEN
    #   CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM csa_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE acsi200_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE acsi200_curo CURSOR FOR acsi200_p1
    CALL cl_outnam('acsi200') RETURNING l_name
 
    START REPORT acsi200_rep TO l_name
 
    FOREACH acsi200_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT acsi200_rep(sr.*)
    END FOREACH
 
    FINISH REPORT acsi200_rep
 
    CLOSE acsi200_curo
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT acsi200_rep(sr)
    DEFINE
        sr RECORD LIKE csa_file.*,
        l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680071 VARCHAR(1)
        l_str1          LIKE ze_file.ze03,           #No.FUN-680071 VARCHAR(8)
        l_str2          LIKE ze_file.ze03,           #No.FUN-680071 VARCHAR(8)
        l_str3          LIKE ze_file.ze03,           #No.FUN-680071 VARCHAR(8)
        l_str4          LIKE oea_file.oea01,             #No.FUN-680071 VARCHAR(12)
        l_chr           LIKE type_file.chr1              #No.FUN-680071 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.csa01,sr.csa02
 
    FORMAT
        PAGE HEADER
#No.FUN-580110 --start--
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[30],g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
                  g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
                  g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],
                  g_x[54],g_x[55]
            PRINT g_dash1
            LET l_trailer_sw = 'n'
 
        ON EVERY ROW
#            PRINT  g_x[11] clipped,sr.csa01
#            PRINT  g_x[12] clipped,sr.csa02
#            PRINT ' '
            CASE sr.csa03
                 WHEN '1'
                    CALL cl_getmsg('mfg1315',g_lang) RETURNING l_str1
                 WHEN '2'
                    CALL cl_getmsg('mfg1316',g_lang) RETURNING l_str1
                 WHEN '3'
                    CALL cl_getmsg('mfg1317',g_lang) RETURNING l_str1
                 OTHERWISE EXIT CASE
            END CASE
           # IF sr.csaacti = 'N' THEN PRINT '*'; END IF
#             CALL cl_getmsg('mfg0021',g_lang) RETURNING l_str2
#             CALL cl_getmsg('mfg0022',g_lang) RETURNING l_str3
#             PRINT l_str1,COLUMN 11,'-----------------------------------',
#                   l_str2,'----------------',l_str3,'-------'
             PRINT COLUMN g_c[30],l_str1 CLIPPED,
                   #COLUMN g_c[31],sr.csa01[1,20] CLIPPED,#FUN-5B0013 mark
                   COLUMN g_c[31],sr.csa01 CLIPPED, #FUN-5B0013 add
                   COLUMN g_c[32],sr.csa02 CLIPPED,
                   COLUMN g_c[33],cl_numfor(sr.csa0301,33,g_azi04),
                   COLUMN g_c[34],cl_numfor(sr.csa0321,34,g_azi04),
                   COLUMN g_c[35],cl_numfor(sr.csa0302,35,g_azi04),
                   COLUMN g_c[36],cl_numfor(sr.csa0322,36,g_azi04),
                   COLUMN g_c[37],cl_numfor(sr.csa0303,37,g_azi04),
                   COLUMN g_c[38],cl_numfor(sr.csa0323,38,g_azi04),
                   COLUMN g_c[39],cl_numfor(sr.csa0304,39,g_azi04),
                   COLUMN g_c[40],cl_numfor(sr.csa0324,40,g_azi04),
                   COLUMN g_c[41],cl_numfor(sr.csa0305,41,g_azi04),
                   COLUMN g_c[42],cl_numfor(sr.csa0325,42,g_azi04),
                   COLUMN g_c[43],cl_numfor(sr.csa0306,43,g_azi04),
                   COLUMN g_c[44],cl_numfor(sr.csa0326,44,g_azi04),
                   COLUMN g_c[45],cl_numfor(sr.csa0307,45,g_azi04),
                   COLUMN g_c[46],cl_numfor(sr.csa0327,46,g_azi04),
                   COLUMN g_c[47],cl_numfor(sr.csa0308,47,g_azi04),
                   COLUMN g_c[48],cl_numfor(sr.csa0328,48,g_azi04),
                   COLUMN g_c[49],cl_numfor(sr.csa0309,49,g_azi04),
                   COLUMN g_c[50],cl_numfor(sr.csa0329,50,g_azi04),
                   COLUMN g_c[51],cl_numfor(sr.csa0310,51,g_azi04),
                   COLUMN g_c[52],cl_numfor(sr.csa0330,52,g_azi04),
                   COLUMN g_c[53],cl_numfor(sr.csa0312,53,g_azi04),
                   COLUMN g_c[54],cl_numfor(sr.csa0331,54,g_azi04),
                   COLUMN g_c[55],cl_numfor(sr.csa0311,55,g_azi04)
#No.FUN-580110 --end--
        PRINT ' '
 
        ON LAST ROW
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN PRINT g_dash[1,g_len]
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
                   #IF g_wc[001,080] > ' ' THEN
		   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'n' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
#No.FUN-570110--begin
FUNCTION i200_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("csa01,csa02",TRUE)
   END IF
END FUNCTION
 
FUNCTION i200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("csa01,csa02",FALSE)
   END IF
END FUNCTION
#No.FUN-570110--end
 
#Patch....NO.TQC-610035 <> #
