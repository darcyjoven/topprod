# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmi701.4gl
# Descriptions...: 潛在客戶主檔維護作業
# Date & Author..: 02/11/12 by Leagh
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: NO.MOD-570109 05/07/12 By Nicola 只有指派時，可以修改業務員與分配日期
# Modify.........: NO.FUN-590051 05/09/09 By Kevin 改結案的action id 為close_the_case_i701
# Modify.........: NO.FUN-5A0152 05/10/24 By Sarah
#                  1.將"結案日期"(ofd39),"成交競爭廠商代號"(ofd40)及"廠商簡稱"(ofd41)欄位開放在畫面供查詢檢視
#                  2.當狀態為"結案"時,應不可再執行"結案"ACTION去更改資料
#                  3.點選"結案"ACTION後,應控制"成交競爭廠商編號"欄位不可空白
#                  4.點選"指派"ACTION後,應控制"業務員"欄位不可空白才可按確認存檔
#                  5.將"客戶等級調整"與"指派"二個ACTION位置對調
#                  6."身分證號"及"統一編號"欄位要做合理性檢查及警告
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-650089 06/05/22 By Sarah 將CALL axmi706改成用cl_cmdrun_wait
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740234 07/04/23 By Sarah 按ACTION"業務員工作日報"時,應列出該業務員所有相關工作日報
# Modify.........: No.TQC-740317 07/04/26 By bnlent 打印時加一個有效標志位
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790064 07/09/14 By dxfwo 關于大陸和台灣身份証號碼問題的修改
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-980064 09/08/11 By lilingyu 無效資料不可刪除
# Modify.........: No.TQC-980271 09/08/27 By lilingyu "資本額 年營業額 員工人數 預計成交金額 成交幾率"欄位輸入負數沒有控管
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-BA0107 11/10/19 By destiny oriu,orig不能查询

 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30099 12/04/09 by Sakura 查詢時廠商編號要可以開窗篩選
# Modify.........: No:MOD-C70162 12/07/13 By Elise 只留下查詢可開窗
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-D10017 13/01/05 By qirl 單頭客戶來源後面增加來源說明的顯示，客戶類型後面增加類型名稱的顯示，區域編號後面增加區域名稱的顯示

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ofd   RECORD LIKE ofd_file.*,
    g_ofd_t RECORD LIKE ofd_file.*,
    g_ofd_o RECORD LIKE ofd_file.*,
    g_ofd01_t           LIKE ofd_file.ofd01,
    g_gen02             LIKE gen_file.gen02,
 
     g_wc,g_sql         STRING,  #No.FUN-580092 HCN  
    l_cmd               LIKE gbc_file.gbc05     #No.FUN-680137 VARCHAR(100)
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE g_cmd            LIKE gbc_file.gbc05     #No.FUN-680137 VARCHAR(100)
 
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   
DEFINE   g_before_input_done    STRING
 
DEFINE   g_chr           LIKE type_file.chr1           #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10          #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5           #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(72)
#---TQC-D10017--add--star--
DEFINE   g_ofq02         LIKE ofq_file.ofq02
DEFINE   g_oca02         LIKE oca_file.oca02
DEFINE   g_gea02         LIKE gea_file.gea02
#---TQC-D10017--add-end- 
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_close        LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0094
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    INITIALIZE g_ofd.* TO NULL
    INITIALIZE g_ofd_t.* TO NULL
    INITIALIZE g_ofd_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ofd_file WHERE ofd01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i701_cl CURSOR FROM g_forupd_sql             # LOCK CURSOR
    LET p_row = 2 LET p_col = 2
 
    OPEN WINDOW i701_w AT p_row,p_col
        WITH FORM "axm/42f/axmi701"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i701_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i701_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION i701_cs()
    CLEAR FORM
   INITIALIZE g_ofd.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON
        ofd01,ofd02,ofd03,ofd04,ofd05,
        ofd22,ofd17,ofd171,ofd37,ofd38,
        ofd13,ofd14,ofd15,ofd16,ofd161,ofd162,
        ofd06,ofd07,ofd08,ofd09,ofd10,
        ofd23,ofd24,ofd25,ofd26,
        ofd27,ofd28,ofd29,ofd30,
        ofd31,ofd32,ofd33,ofd34,ofd35,
        ofd36,ofd18,ofd19,ofd20,ofd21,
        ofd39,ofd40,ofd41,   #FUN-5A0152
        ofduser,ofdgrup,ofdmodu,ofddate,ofdacti
        ,ofdoriu,ofdorig  #TQC-BA0107

              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE WHEN INFIELD(ofd03) #潛在客戶來源
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ofq"
                  LET g_qryparam.default1 = g_ofd.ofd03
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ofd03
                  NEXT FIELD ofd03
               #FUN-C30099---add---START
                WHEN INFIELD(ofd01) #廠商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_ofd"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ofd01
                  NEXT FIELD ofd01
               #FUN-C30099---end---START
                WHEN INFIELD(ofd04) #客戶類別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_oca"
                  LET g_qryparam.default1 = g_ofd.ofd04
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ofd04
                  NEXT FIELD ofd04
                WHEN INFIELD(ofd05) #區域
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_gea"
                  LET g_qryparam.default1 = g_ofd.ofd05
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ofd05
                  NEXT FIELD ofd05
                WHEN INFIELD(ofd10) #客戶等級
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ofc"
                  LET g_qryparam.default1 = g_ofd.ofd10
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ofd10
                  NEXT FIELD ofd10
                WHEN INFIELD(ofd23) #業務員
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_ofd.ofd23
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ofd23
                  NEXT FIELD ofd23
               #start FUN-5A0152
                WHEN INFIELD(ofd40) #成交競爭廠商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ofr"
                  LET g_qryparam.default1 = g_ofd.ofd40
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ofd40
                  NEXT FIELD ofd40
               #end FUN-5A0152
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
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN
    #        LET g_wc = g_wc clipped," AND ofduser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #        LET g_wc = g_wc clipped," AND ofdgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND ofdgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ofduser', 'ofdgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT ofd01 FROM ofd_file ",
              " WHERE ",g_wc CLIPPED, " ORDER BY ofd01"
    PREPARE i701_prepare FROM g_sql           # RUNTIME
    DECLARE i701_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i701_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ofd_file WHERE ",g_wc CLIPPED
    PREPARE i701_precount FROM g_sql
    DECLARE i701_count CURSOR FOR i701_precount
END FUNCTION
 
FUNCTION i701_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i701_a()
            END IF
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i701_q()
            END IF
            NEXT OPTION "next"
 
        ON ACTION next
           CALL i701_fetch('N')
 
        ON ACTION previous
           CALL i701_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i701_u()
            END IF
 
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i701_x()
            END IF
            #圖形顯示
            IF g_ofd.ofd22 = '4' THEN
               LET g_close = 'Y'
            ELSE
               LET g_close = 'N'
            END IF
            CALL cl_set_field_pic("","","",g_close,"",g_ofd.ofdacti)
 
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i701_r()
            END IF
 
       #start FUN-5A0152
#       ON ACTION 指派
        ON ACTION assigned
            LET g_action_choice="assigned"
            IF cl_chk_act_auth() THEN
               CALL i7011()
            END IF
       #end FUN-5A0152
 
#       ON ACTION 客戶等級調整
        ON ACTION customer_adjust
            IF g_ofd.ofd22 != '1' THEN
               CALL cl_err(g_ofd.ofd01,'axm-464',0)
            END IF
            IF NOT cl_null(g_ofd.ofd01) AND g_ofd.ofdacti ='Y'
               AND g_ofd.ofd22 = '1' THEN
               LET l_cmd ='axmi706 "',g_ofd.ofd01,'" "',g_ofd.ofd10,
                           '" "',g_ofd.ofd23,'"'
               CALL cl_cmdrun_wait(l_cmd CLIPPED)   #FUN-650089 cl_cmdrun改成cl_cmdrun_wait
               SELECT * INTO g_ofd.* FROM ofd_file WHERE ofd01 = g_ofd.ofd01
               DISPLAY BY NAME g_ofd.ofd10,g_ofd.ofd22,g_ofd.ofd23,g_ofd.ofd24
               SELECT gen02 INTO g_gen02 FROM gen_file WHERE gen01 = g_ofd.ofd23
               DISPLAY g_gen02 TO FORMONLY.gen02
            END IF
 
#       ON ACTION 開放
        ON ACTION open
            LET g_action_choice="open"
            IF cl_chk_act_auth() THEN
               CALL i7012()
            END IF
 
#       ON ACTION 成交
        ON ACTION sign_contract
            LET g_action_choice="sign_contract"
            IF cl_chk_act_auth() THEN
               CALL i701_2()
            END IF
 
#       ON ACTION 結案
#        ON ACTION close_the_case
#FUN-590051
        ON ACTION close_the_case_i701
           LET g_action_choice="close_the_case_i701"
           IF cl_chk_act_auth() THEN
              CALL i701_4()
           END IF
           #圖形顯示
           IF g_ofd.ofd22 = '4' THEN
              LET g_close = 'Y'
           ELSE
              LET g_close = 'N'
           END IF
           CALL cl_set_field_pic("","","",g_close,"",g_ofd.ofdacti)
 
#       ON ACTION 業務員工作日報
        ON ACTION salesman_daily_work_report
           IF NOT cl_null(g_ofd.ofd23) AND g_ofd.ofdacti = 'Y' THEN
              LET l_cmd = 'axmi705 "',g_ofd.ofd23, '" "" "',
                                      g_ofd.ofd01,'" "',
                                      g_ofd.ofd29,'"'
              CALL cl_cmdrun(l_cmd CLIPPED)
              SELECT * INTO g_ofd.* FROM ofd_file WHERE ofd01 = g_ofd.ofd01
              DISPLAY BY NAME g_ofd.ofd26,g_ofd.ofd29
           END IF
 
#       ON ACTION 取消成交
        ON ACTION cancel_contract
           LET g_action_choice="cancel_contract"
           IF cl_chk_act_auth() THEN
              CALL i701_6()
           END IF
 
#       ON ACTION 取消結案
        ON ACTION undo_close
           LET g_action_choice="undo_close"
           IF cl_chk_act_auth() THEN
              CALL i701_7()
           END IF
           #圖形顯示
           IF g_ofd.ofd22 = '4' THEN
              LET g_close = 'Y'
           ELSE
              LET g_close = 'N'
           END IF
           CALL cl_set_field_pic("","","",g_close,"",g_ofd.ofdacti)
 
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL i701_out()
            END IF
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #圖形顯示
           IF g_ofd.ofd22 = '4' THEN
              LET g_close = 'Y'
           ELSE
              LET g_close = 'N'
           END IF
           CALL cl_set_field_pic("","","",g_close,"",g_ofd.ofdacti)
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i701_fetch('/')
 
        ON ACTION first
           CALL i701_fetch('F')
 
        ON ACTION last
           CALL i701_fetch('L')
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0020-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
             IF cl_chk_act_auth() THEN
                IF g_ofd.ofd01 IS NOT NULL THEN
                LET g_doc.column1 = "ofd01"
                LET g_doc.value1 = g_ofd.ofd01
                CALL cl_doc()
              END IF
           END IF
        #No.FUN-6A0020-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE i701_cs
END FUNCTION
 
 
 
FUNCTION i701_a()
    DEFINE l_cmd     LIKE gbc_file.gbc05        #No.FUN-680137  VARCHAR(100)
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_ofd.* LIKE ofd_file.*
    LET g_ofd01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ofd.ofd22 = '0'
        LET g_ofd.ofd28 = 0
        LET g_ofd.ofd29 = 0
        LET g_ofd.ofdacti = 'Y'
        LET g_ofd.ofduser = g_user
        LET g_ofd.ofdoriu = g_user #FUN-980030
        LET g_ofd.ofdorig = g_grup #FUN-980030
        LET g_ofd.ofdgrup = g_grup
        LET g_ofd.ofddate = g_today
        LET g_ofd_t.*=g_ofd.*
        CALL i701_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ofd.ofd01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO ofd_file VALUES(g_ofd.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ofd.ofd01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","ofd_file",g_ofd.ofd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        ELSE
           SELECT ofd01 INTO g_ofd.ofd01 FROM ofd_file
              WHERE ofd01 = g_ofd.ofd01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i701_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入  #No.FUN-680137 VARCHAR(1)
        l_n             LIKE type_file.num5           #No.FUN-680137 SMALLINT
#MOD-C70162---mark-S---
#DEFINE  l_pmc01         LIKE pmc_file.pmc01           #FUN-C30099 add
#DEFINE  l_pmcacti       LIKE pmc_file.pmc01           #FUN-C30099 add
#DEFINE  l_pmc03         LIKE pmc_file.pmc03           #FUN-C30099 add
#MOD-C70162---mark-E---
 
   IF p_cmd = 'a' THEN CALL i701_ofd22_show() END IF
   INPUT BY NAME g_ofd.ofdoriu,g_ofd.ofdorig,
        g_ofd.ofd01,g_ofd.ofd02,g_ofd.ofd03,g_ofd.ofd04,g_ofd.ofd05,
        g_ofd.ofd17,g_ofd.ofd171,g_ofd.ofd37,g_ofd.ofd38,
        g_ofd.ofd13,g_ofd.ofd14,g_ofd.ofd15,
        g_ofd.ofd16,g_ofd.ofd161,g_ofd.ofd162,
        g_ofd.ofd06,g_ofd.ofd07,g_ofd.ofd08,g_ofd.ofd09,g_ofd.ofd10,
        g_ofd.ofd22,g_ofd.ofd23,g_ofd.ofd24,g_ofd.ofd25,g_ofd.ofd26,
        g_ofd.ofd27,g_ofd.ofd28,g_ofd.ofd29,g_ofd.ofd30,
        g_ofd.ofd31,g_ofd.ofd32,g_ofd.ofd33,g_ofd.ofd34,g_ofd.ofd35,
        g_ofd.ofd36,g_ofd.ofd18,g_ofd.ofd19,g_ofd.ofd20,g_ofd.ofd21,
        g_ofd.ofduser,g_ofd.ofdgrup,g_ofd.ofdmodu,g_ofd.ofddate,g_ofd.ofdacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i701_set_entry(p_cmd)
           CALL i701_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD ofd01
          IF g_ofd.ofd01 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_ofd.ofd01 != g_ofd01_t) THEN
       #MOD-C70162---mark-S---
       ##FUN-C30099---add---START
       #       SELECT pmc01,pmcacti INTO l_pmc01,l_pmcacti FROM pmc_file
       #        WHERE pmc01 = g_ofd.ofd01
       #       IF cl_null(l_pmc01) OR l_pmcacti != 'Y'THEN
       #          CALL cl_err('','axm-233',0)
       #          NEXT FIELD ofd01
       #       END IF
       ##FUN-C30099---end---START
       #MOD-C70162---mark-E---
               SELECT COUNT(*) INTO l_n FROM ofd_file
                WHERE ofd01 = g_ofd.ofd01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_ofd.ofd01,-239,0)
                  LET g_ofd.ofd01 = g_ofd01_t
                  DISPLAY BY NAME g_ofd.ofd01
                  NEXT FIELD ofd01
             #MOD-C70162---mark-S---
             ##FUN-C30099---add---START
             # ELSE
             #    LET g_ofd.ofd02 = NULL
             #    DISPLAY BY NAME g_ofd.ofd02
             #    SELECT pmc03 INTO l_pmc03 FROM pmc_file
             #      WHERE pmc01 = g_ofd.ofd01
             #    LET g_ofd.ofd02 = l_pmc03
             #    DISPLAY BY NAME g_ofd.ofd02
             ##FUN-C30099---end---START
             #MOD-C70162---mark-E---
               END IF
            END IF
          END IF
 
        #檢查客戶簡稱是否重覆
        AFTER FIELD ofd02
          IF g_ofd.ofd02 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_ofd.ofd02 != g_ofd_t.ofd02) THEN
               SELECT COUNT(*) INTO l_n FROM ofd_file
                WHERE ofd02 = g_ofd.ofd02
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_ofd.ofd02,-239,0)
                  NEXT FIELD ofd02
               END IF
            END IF
          END IF
 
        #start FUN-5A0152
        #檢查身分證號是否重複
         AFTER FIELD ofd14
#No.TQC-790064---Begin 
#           IF NOT cl_null(g_ofd.ofd14) THEN
#                IF NOT s_chkidn(g_ofd.ofd14) THEN
#                   CALL cl_err('','apy-032',0)
#                   NEXT FIELD ofd14
#                END IF 
#              IF g_ofd.ofd14 != g_ofd_t.ofd14 OR g_ofd_t.ofd14 IS NULL THEN
#                 SELECT COUNT(*) INTO g_cnt FROM ofd_file
#                  WHERE ofd14 = g_ofd.ofd14
#                 IF g_cnt > 0 THEN
#                    CALL cl_err(g_ofd.ofd14,'apy-689',1)
#                 END IF
#              END IF
#           END IF
#       #end FUN-5A0152
   case g_aza.aza26 
     WHEN '0'  
            IF NOT cl_null(g_ofd.ofd14) THEN                                                                                        
                 IF NOT s_chkidn(g_ofd.ofd14) THEN                                                                                  
#                    CALL cl_err('','apy-032',0)    #CHI-B40058
                    CALL cl_err('','axm-432',0)     #CHI-B40058 
                    NEXT FIELD ofd14                                                                                                
                 END IF                                                                                                             
               IF g_ofd.ofd14 != g_ofd_t.ofd14 OR g_ofd_t.ofd14 IS NULL THEN                                                        
                  SELECT COUNT(*) INTO g_cnt FROM ofd_file                                                                          
                   WHERE ofd14 = g_ofd.ofd14                                                                                        
                  IF g_cnt > 0 THEN                                                                                                 
#                     CALL cl_err(g_ofd.ofd14,'apy-689',1)     #CHI-B40058
                     CALL cl_err(g_ofd.ofd14,'axm-433',1)      #CHI-B40058 
                  END IF                                                                                                            
               END IF                                                                                                               
            END IF               
         WHEN '2'
        IF g_ofd.ofd14 != g_ofd_t.ofd14 OR g_ofd_t.ofd14 IS NULL THEN                                                        
         SELECT COUNT(*) INTO g_cnt FROM ofd_file                                                                          
          WHERE ofd14 = g_ofd.ofd14                                                                                        
           IF g_cnt > 0 THEN                                                                                                 
#              CALL cl_err(g_ofd.ofd14,'apy-689',1)     #CHI-B40058
              CALL cl_err(g_ofd.ofd14,'axm-433',1)      #CHI-B40058 
           END IF                                                                                                            
         END IF   
    END CASE
#No.TQC-790064---End
        #檢查統一編號是否重覆
        AFTER FIELD ofd15
            IF NOT cl_null(g_ofd.ofd15) THEN
              #start FUN-5A0152
              #IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              #  (p_cmd = "u" AND g_ofd.ofd15 != g_ofd_t.ofd15) THEN
              #   SELECT COUNT(*) INTO l_n FROM ofd_file
              #    WHERE ofd15 = g_ofd.ofd15
              #   IF l_n > 0 THEN                  # Duplicated
              #      CALL cl_err(g_ofd.ofd15,-239,0)
              #      NEXT FIELD ofd15
              #   END IF
              #END IF
               SELECT count(*) INTO l_n FROM ofd_file
                WHERE ofd15 = g_ofd.ofd15 AND ofd01 != g_ofd.ofd01
               IF l_n > 0 THEN
                  CALL cl_err(g_ofd.ofd15,'axm-028',1)
               END IF
               IF g_aza.aza21 = 'Y' THEN   #是否以邏輯方式檢查營利事業統一編號
                  IF NOT s_chkban(g_ofd.ofd15) THEN
                     CALL cl_err(g_ofd.ofd15,'aoo-080',0)
                     NEXT FIELD ofd15
                  END IF
               END IF
              #end FUN-5A0152
            END IF
 
        #檢查公司全名是否重覆
        AFTER FIELD ofd17
          IF g_ofd.ofd17 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_ofd.ofd17 != g_ofd_t.ofd17) THEN
               SELECT COUNT(*) INTO l_n FROM ofd_file
                WHERE ofd17 = g_ofd.ofd17
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_ofd.ofd17,-239,0)
                  NEXT FIELD ofd17
               END IF
            END IF
          END IF
 
        AFTER FIELD ofd03
	  IF g_ofd.ofd03 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM ofq_file WHERE ofq01 = g_ofd.ofd03
                                                      AND ofqacti='Y' #MOD-530581
            IF l_n = 0 THEN
               CALL cl_err(g_ofd.ofd03,'axm-455',0)
               NEXT FIELD ofd03
            END IF
#---TQC-D10017--add--star--
            SELECT ofq02 INTO g_ofq02 FROM ofq_file WHERE ofq01 = g_ofd.ofd03
                                                          AND ofqacti='Y'
            DISPLAY g_ofq02   TO FORMONLY.ofq02
#---TQC-D10017--add--end---
          END IF
 
        AFTER FIELD ofd04
          IF g_ofd.ofd04 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM oca_file WHERE oca01 = g_ofd.ofd04
            IF l_n = 0 THEN
               CALL cl_err(g_ofd.ofd04,'axm-456',0)
               NEXT FIELD ofd04
            END IF
#---TQC-D10017--add--star--
            SELECT oca02 INTO g_oca02 FROM oca_file WHERE oca01 = g_ofd.ofd04
            DISPLAY g_oca02   TO FORMONLY.oca02
#---TQC-D10017--add--end---
          END IF
 
        AFTER FIELD ofd05
          IF g_ofd.ofd05 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM gea_file WHERE gea01 = g_ofd.ofd05
                                                      AND geaacti = 'Y' #MOD-530581
            IF l_n = 0 THEN
               CALL cl_err(g_ofd.ofd05,'mfg3139',0)
               NEXT FIELD ofd05
            END IF
#---TQC-D10017--add--star--
            SELECT gea02 INTO g_gea02 FROM gea_file WHERE gea01 = g_ofd.ofd05
                                                      AND geaacti = 'Y'
            DISPLAY g_gea02   TO FORMONLY.gea02
#---TQC-D10017--add--end---
          END IF
 
#TQC-980271 --begin--
        AFTER FIELD ofd07
           IF NOT cl_null(g_ofd.ofd07) THEN 
              IF g_ofd.ofd07 < 0 THEN 
                 CALL cl_err('','aim-223',0)
                 NEXT FIELD ofd07
              END IF 
           END IF 
 
        AFTER FIELD ofd08
           IF NOT cl_null(g_ofd.ofd08) THEN 
              IF g_ofd.ofd08 < 0 THEN 
                 CALL cl_err('','aim-223',0)
                 NEXT FIELD ofd08
              END IF 
           END IF         
 
        AFTER FIELD ofd09
           IF NOT cl_null(g_ofd.ofd09) THEN 
              IF g_ofd.ofd09 < 0 THEN 
                 CALL cl_err('','aim-223',0)
                 NEXT FIELD ofd09
              END IF 
           END IF            
#TQC-980271 --END--
 
        AFTER FIELD ofd10
          IF g_ofd.ofd10 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_n FROM ofc_file WHERE ofc01 = g_ofd.ofd10
            IF l_n = 0 THEN
               CALL cl_err(g_ofd.ofd10,'axm-457',0)
               NEXT FIELD ofd10
            END IF
          END IF
 
        AFTER FIELD ofd28
          IF cl_null(g_ofd.ofd28) THEN LET g_ofd.ofd28 = 0 END IF
#TQC-980271 --begin--
           IF NOT cl_null(g_ofd.ofd28) THEN 
              IF g_ofd.ofd28 < 0 THEN 
                 CALL cl_err('','aim-223',0)
                 NEXT FIELD ofd28
              END IF 
           END IF            
#TQC-980271 --END--  
          
 
        AFTER FIELD ofd29
          IF cl_null(g_ofd.ofd29) THEN LET g_ofd.ofd29 = 0 END IF
#TQC-980271 --begin-- 
           IF NOT cl_null(g_ofd.ofd29) THEN 
              IF g_ofd.ofd29 < 0 THEN 
                 CALL cl_err('','aim-223',0)
                 NEXT FIELD ofd29
              END IF 
           END IF            
#TQC-980271 --END--
          
          
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(ofd01) THEN
      #         LET g_ofd.* = g_ofd_t.*
      #         CALL i701_show()
      #         NEXT FIELD ofd01
      #      END IF
      #MOD-650015 --end
 
        AFTER INPUT
           LET g_ofd.ofduser = s_get_data_owner("ofd_file") #FUN-C10039
           LET g_ofd.ofdgrup = s_get_data_group("ofd_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(ofd03) #潛在客戶來源
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ofq"
                  LET g_qryparam.default1 = g_ofd.ofd03
                  CALL cl_create_qry() RETURNING g_ofd.ofd03
#                  CALL FGL_DIALOG_SETBUFFER( g_ofd.ofd03 )
                  DISPLAY BY NAME g_ofd.ofd03
                  NEXT FIELD ofd03
              #MOD-C70162---mark-S---
              ##FUN-C30099---add---START
              # WHEN INFIELD(ofd01)                                                                                          
              #   CALL cl_init_qry_var()                                                                                               
              #   LET g_qryparam.form ="q_ofr1"                                                                                         
              #   LET g_qryparam.default1 = g_ofd.ofd01                                                                           
              #   CALL cl_create_qry() RETURNING g_ofd.ofd01                                                                           
              #   DISPLAY BY NAME g_ofd.ofd01                                                                                                                                                                                         
              #   NEXT FIELD ofd01                 
              ##FUN-C30099---end---START
              #MOD-C70162---mark-E---
                WHEN INFIELD(ofd04) #客戶類別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oca"
                  LET g_qryparam.default1 = g_ofd.ofd04
                  CALL cl_create_qry() RETURNING g_ofd.ofd04
#                  CALL FGL_DIALOG_SETBUFFER( g_ofd.ofd04 )
                  DISPLAY BY NAME g_ofd.ofd04
                  NEXT FIELD ofd04
                WHEN INFIELD(ofd05) #區域
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gea"
                  LET g_qryparam.default1 = g_ofd.ofd05
                  CALL cl_create_qry() RETURNING g_ofd.ofd05
#                  CALL FGL_DIALOG_SETBUFFER( g_ofd.ofd05 )
                  DISPLAY BY NAME g_ofd.ofd05
                  NEXT FIELD ofd05
                WHEN INFIELD(ofd10) #客戶等級
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ofc"
                  LET g_qryparam.default1 = g_ofd.ofd10
                  CALL cl_create_qry() RETURNING g_ofd.ofd10
#                  CALL FGL_DIALOG_SETBUFFER( g_ofd.ofd10 )
                  DISPLAY BY NAME g_ofd.ofd10
                  NEXT FIELD ofd10
                WHEN INFIELD(ofd23) #業務員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_ofd.ofd23
                  CALL cl_create_qry() RETURNING g_ofd.ofd23
#                  CALL FGL_DIALOG_SETBUFFER( g_ofd.ofd23 )
                  DISPLAY BY NAME g_ofd.ofd23
                  NEXT FIELD ofd23
           END CASE
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                         # 欄位說明
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
 
FUNCTION i701_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ofd.* TO NULL               #No.FUN-6A0020
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i701_cs()                           # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
 
    OPEN i701_count
    FETCH i701_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i701_cs                             # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofd.ofd01,SQLCA.sqlcode,0)
        INITIALIZE g_ofd.* TO NULL
    ELSE
        CALL i701_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i701_fetch(p_flofd)
    DEFINE
        p_flofd         LIKE type_file.chr1     #No.FUN-680137  VARCHAR(1)
 
    CASE p_flofd
        WHEN 'N' FETCH NEXT     i701_cs INTO g_ofd.ofd01
        WHEN 'P' FETCH PREVIOUS i701_cs INTO g_ofd.ofd01
        WHEN 'F' FETCH FIRST    i701_cs INTO g_ofd.ofd01
        WHEN 'L' FETCH LAST     i701_cs INTO g_ofd.ofd01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i701_cs INTO g_ofd.ofd01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofd.ofd01,SQLCA.sqlcode,0)
        INITIALIZE g_ofd.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flofd
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ofd.* FROM ofd_file          # 重讀DB,因TEMP有不被更新特性
       WHERE ofd01 = g_ofd.ofd01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_ofd.ofd01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","ofd_file",g_ofd.ofd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       INITIALIZE g_ofd.* TO NULL            #FUN-4C0057 add
    ELSE
       LET g_data_owner = g_ofd.ofduser      #FUN-4C0057 add
       LET g_data_group = g_ofd.ofdgrup      #FUN-4C0057 add
       CALL i701_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i701_show()
    LET g_ofd_t.* = g_ofd.*
    DISPLAY BY NAME g_ofd.ofdoriu,g_ofd.ofdorig,
        g_ofd.ofd01,g_ofd.ofd02,g_ofd.ofd03,g_ofd.ofd04,g_ofd.ofd05,
        g_ofd.ofd06,g_ofd.ofd07,g_ofd.ofd08,g_ofd.ofd09,g_ofd.ofd10,
        g_ofd.ofd13,g_ofd.ofd14,g_ofd.ofd15,
        g_ofd.ofd16,g_ofd.ofd161,g_ofd.ofd162,
        g_ofd.ofd17,g_ofd.ofd171,
        g_ofd.ofd18,g_ofd.ofd19,g_ofd.ofd20,g_ofd.ofd21,
        g_ofd.ofd22,g_ofd.ofd23,g_ofd.ofd24,
        g_ofd.ofd25,g_ofd.ofd26,g_ofd.ofd27,g_ofd.ofd28,g_ofd.ofd29,
        g_ofd.ofd30,g_ofd.ofd31,g_ofd.ofd32,g_ofd.ofd33,g_ofd.ofd34,
        g_ofd.ofd35,g_ofd.ofd36,g_ofd.ofd37,g_ofd.ofd38,
        g_ofd.ofd39,g_ofd.ofd40,g_ofd.ofd41,   #FUN-5A0152
        g_ofd.ofduser,g_ofd.ofdgrup,g_ofd.ofdmodu,g_ofd.ofddate,
        g_ofd.ofdacti
    CALL i701_ofd22_show()
    CALL i701_ofd23('d')
 
#---TQC-D10017--add--star--
     SELECT ofq02 INTO g_ofq02 FROM ofq_file WHERE ofq01 = g_ofd.ofd03
                                               AND ofqacti='Y'
     SELECT oca02 INTO g_oca02 FROM oca_file WHERE oca01 = g_ofd.ofd04
     SELECT gea02 INTO g_gea02 FROM gea_file WHERE gea01 = g_ofd.ofd05
                                               AND geaacti = 'Y'
     DISPLAY g_ofq02   TO FORMONLY.ofq02
     DISPLAY g_oca02   TO FORMONLY.oca02
     DISPLAY g_gea02   TO FORMONLY.gea02

#---TQC-D10017--add--end---
    #圖形顯示
    IF g_ofd.ofd22 = '4' THEN
       LET g_close = 'Y'
    ELSE
       LET g_close = 'N'
    END IF
    CALL cl_set_field_pic("","","",g_close,"",g_ofd.ofdacti)
    CALL cl_show_fld_cont()   #FUN-550037(smin)
END FUNCTION
 
FUNCTION i701_ofd23(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
           l_genacti LIKE gen_file.genacti,
           l_gen02   LIKE gen_file.gen02
 
    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
      WHERE gen01 = g_ofd.ofd23
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                   LET l_gen02 = NULL
                                   LET l_genacti = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02   TO FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION i701_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ofd.ofd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ofd.ofd22 = '4' THEN CALL cl_err(g_ofd.ofd01,'9004',0) RETURN END IF
    SELECT * INTO g_ofd.* FROM ofd_file WHERE ofd01=g_ofd.ofd01
    IF g_ofd.ofdacti ='N' THEN     #檢查資料是否為無效
        CALL cl_err(g_ofd.ofd01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ofd01_t = g_ofd.ofd01
    LET g_ofd_o.*=g_ofd.*
    BEGIN WORK
 
    OPEN i701_cl USING g_ofd.ofd01
    IF STATUS THEN
       CALL cl_err("OPEN i701_cl:", STATUS, 1)
       CLOSE i701_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i701_cl INTO g_ofd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofd.ofd01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    LET g_ofd.ofdmodu=g_user                     #修改者
    LET g_ofd.ofddate = g_today                  #修改日期
    CALL i701_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_ofd_t.*=g_ofd.*
        CALL i701_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ofd.*=g_ofd_t.*
            CALL i701_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE ofd_file SET ofd_file.* = g_ofd.*    # 更新DB
            WHERE ofd01 = g_ofd01_t        # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ofd.ofd01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","ofd_file",g_ofd01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    MESSAGE " "
    CLOSE i701_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i701_x()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofd.ofd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i701_cl USING g_ofd.ofd01
    IF STATUS THEN
       CALL cl_err("OPEN i701_cl:", STATUS, 1)
       CLOSE i701_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i701_cl INTO g_ofd.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofd.ofd01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i701_show()
    IF cl_exp(15,12,g_ofd.ofdacti) THEN
        LET g_chr=g_ofd.ofdacti
        IF g_ofd.ofdacti='Y' THEN
            LET g_ofd.ofdacti='N'
        ELSE
            LET g_ofd.ofdacti='Y'
        END IF
        UPDATE ofd_file
            SET ofdacti=g_ofd.ofdacti,
                ofdmodu=g_user, ofddate=g_today
            WHERE ofd01=g_ofd.ofd01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_ofd.ofd01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","ofd_file",g_ofd.ofd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_ofd.ofdacti=g_chr
        END IF
        DISPLAY BY NAME g_ofd.ofdacti
    END IF
    CLOSE i701_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i701_r()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofd.ofd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#TQC-980064 --BEGIN--
    IF g_ofd.ofdacti = 'N' THEN
       CALL cl_err('','abm-033',0)
       RETURN
    END IF 
#TQC-980064 --END--
    BEGIN WORK
 
    OPEN i701_cl USING g_ofd.ofd01
    IF STATUS THEN
       CALL cl_err("OPEN i701_cl:", STATUS, 1)
       CLOSE i701_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i701_cl INTO g_ofd.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ofd.ofd01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i701_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ofd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ofd.ofd01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ofd_file WHERE ofd01 = g_ofd.ofd01
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_ofd.ofd01,SQLCA.sqlcode,0)   #No.FUN-660167
          CALL cl_err3("del","ofd_file",g_ofd.ofd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
          ROLLBACK WORK RETURN
       END IF
       CLEAR FORM
       INITIALIZE g_ofd.* TO NULL
       OPEN i701_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i701_cs
          CLOSE i701_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i701_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i701_cs
          CLOSE i701_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i701_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i701_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i701_fetch('/')
       END IF
    END IF
    CLOSE i701_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i701_copy()
   DEFINE l_ofd           RECORD LIKE ofd_file.*,
          l_oldno,l_newno LIKE ofd_file.ofd01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofd.ofd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    INPUT l_newno FROM ofd01
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i701_set_entry("a")
           CALL i701_set_no_entry("a")
           LET g_before_input_done = TRUE
 
        AFTER FIELD ofd01
          IF l_newno IS NOT NULL THEN
            SELECT COUNT(*) INTO g_cnt FROM ofd_file
             WHERE ofd01 = l_newno
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD ofd01
            END IF
          END IF
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_ofd.ofd01
        RETURN
    END IF
    LET l_ofd.* = g_ofd.*
    LET l_ofd.ofd01  =l_newno  #資料鍵值
    LET l_ofd.ofdoriu = g_user      #No.FUN-980030 10/01/04
    LET l_ofd.ofdorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO ofd_file VALUES (l_ofd.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("ins","ofd_file",l_ofd.ofd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_ofd.ofd01
        SELECT ofd_file.* INTO g_ofd.* FROM ofd_file 
                       WHERE ofd01 = l_newno
        CALL i701_u()
        #SELECT ofd_file.* INTO g_ofd.* FROM ofd_file #FUN-C80046
        #               WHERE ofd01 = l_oldno         #FUN-C80046
    END IF
    CALL i701_show()
END FUNCTION
 
FUNCTION i701_2()
    DEFINE l_ofd   RECORD LIKE ofd_file.*,
           l_ofd_o RECORD LIKE ofd_file.*,
           l_occ02        LIKE occ_file.occ02,
           l_no    LIKE type_file.num10  #No.FUN-680137 INTEGER
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofd.ofd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ofd.ofdacti != 'Y' THEN RETURN END IF
    IF cl_null(g_ofd.ofd23) THEN
       CALL cl_err(g_ofd.ofd01,'axm-462',0) RETURN
    END IF
    IF g_ofd.ofd22='4' THEN
       CALL cl_err(g_ofd.ofd01,'axm-463',0) RETURN
    END IF
 
    LET p_row = 7 LET p_col = 23
    OPEN WINDOW i701_2_w AT p_row,p_col WITH FORM "axm/42f/axmi701_2"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmi701_2")
 
 
    INPUT BY NAME g_ofd.ofd30 WITHOUT DEFAULTS
 
      BEFORE FIELD ofd30
        IF NOT cl_null(g_ofd.ofd30) THEN
           SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=g_ofd.ofd30
           DISPLAY l_occ02 TO FORMONLY.occ02
        END IF
 
      AFTER FIELD ofd30
        IF g_ofd.ofd30 IS NOT NULL THEN
           SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=g_ofd.ofd30
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_ofd.ofd30,SQLCA.sqlcode,0)   #No.FUN-660167
              CALL cl_err3("sel","occ_file",g_ofd.ofd30,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
              NEXT FIELD ofd30
           END IF
           DISPLAY l_occ02 TO FORMONLY.occ02
        END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
 
      ON ACTION controlp
         IF INFIELD(ofd30) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_occ"
            LET g_qryparam.default1 = g_ofd.ofd30
            CALL cl_create_qry() RETURNING g_ofd.ofd30
#            CALL FGL_DIALOG_SETBUFFER( g_ofd.ofd30 )
            DISPLAY BY NAME g_ofd.ofd30
            NEXT FIELD ofd30
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG=0 CLOSE WINDOW i701_2_w RETURN
    END IF
    LET g_ofd.ofd22 = '3'
 
    UPDATE ofd_file SET ofd22=g_ofd.ofd22,
                        ofd30=g_ofd.ofd30
     WHERE ofd01 = g_ofd.ofd01
    IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd ofd',STATUS,0)   #No.FUN-660167
       CALL cl_err3("upd","ofd_file",g_ofd.ofd01,"",STATUS,"","upd ofd",1)  #No.FUN-660167
       CLOSE WINDOW i701_2_w
       RETURN
    END IF
 
    CLOSE WINDOW i701_2_w
 
    DISPLAY BY NAME g_ofd.ofd22,g_ofd.ofd30
    CALL i701_ofd22_show()
END FUNCTION
 
FUNCTION i701_4()
    DEFINE l_ofd   RECORD LIKE ofd_file.*,
           l_ofd_o RECORD LIKE ofd_file.*,
           l_no    LIKE type_file.num10  #No.FUN-680137 INTEGER
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofd.ofd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ofd.ofdacti != 'Y' THEN RETURN END IF
    IF g_ofd.ofd22='3' THEN
       CALL cl_err(g_ofd.ofd01,'axm-470',0) RETURN
    END IF
   #start FUN-5A0152
    IF g_ofd.ofd22='4' THEN
       CALL cl_err('','axm-355',0)
       RETURN
    END IF
   #end FUN-5A0152
 
    LET p_row = 7 LET p_col = 23
    OPEN WINDOW i701_4_w AT p_row,p_col WITH FORM "axm/42f/axmi701_4"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axmi701_4")
 
    CALL cl_set_comp_required("ofd40",TRUE)   #FUN-5A0152
 
    INPUT BY NAME g_ofd.ofd39,g_ofd.ofd40,g_ofd.ofd41
                  WITHOUT DEFAULTS
 
      BEFORE FIELD ofd39
           LET g_ofd.ofd39 = g_today
 
      AFTER FIELD ofd40
        IF NOT cl_null(g_ofd.ofd40) THEN
           SELECT ofr02 INTO g_ofd.ofd41 FROM ofr_file WHERE ofr01 = g_ofd.ofd40
           IF STATUS THEN
#             CALL cl_err(g_ofd.ofd40,'mfg3001',0)  #No.FUN-660167
              CALL cl_err3("sel","ofr_file",g_ofd.ofd40,"","mfg3001","","",1)  #No.FUN-660167
              NEXT FIELD ofd40  
           END IF
           DISPLAY BY NAME g_ofd.ofd41
        END IF
 
{--應該不用一定要打吧..
      AFTER FIELD ofd41
        IF cl_null(g_ofd.ofd41) THEN NEXT FIELD ofd41 END IF
}
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
 
      ON ACTION controlp
         IF INFIELD(ofd40) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ofr"
            LET g_qryparam.default1 = g_ofd.ofd40
            CALL cl_create_qry() RETURNING g_ofd.ofd40
#            CALL FGL_DIALOG_SETBUFFER( g_ofd.ofd40 )
            DISPLAY BY NAME g_ofd.ofd40
            NEXT FIELD ofd40
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG=0 CLOSE WINDOW i701_4_w RETURN
    END IF
    LET g_ofd.ofd22 = '4'
    UPDATE ofd_file SET ofd22=g_ofd.ofd22,ofd39=g_ofd.ofd39,
                        ofd40=g_ofd.ofd40,ofd41=g_ofd.ofd41
     WHERE ofd01 = g_ofd.ofd01
    IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd ofd',STATUS,0)   #No.FUN-660167
       CALL cl_err3("upd","ofd_file",g_ofd.ofd01,"",STATUS,"","upd ofd",1)  #No.FUN-660167
       CLOSE WINDOW i701_4_w
       RETURN
    END IF
    CLOSE WINDOW i701_4_w
    DISPLAY BY NAME g_ofd.ofd22
    CALL i701_ofd22_show()
END FUNCTION
 
FUNCTION i701_6()              #取消成交
    DEFINE l_ofd   RECORD LIKE ofd_file.*,
           l_ofd_o RECORD LIKE ofd_file.*,
           l_occ02        LIKE occ_file.occ02,
           l_no    LIKE type_file.num10  #No.FUN-680137 INTEGER
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofd.ofd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ofd.ofdacti != 'Y' THEN RETURN END IF
    IF g_ofd.ofd22!='3' THEN
       CALL cl_err(g_ofd.ofd01,'axm-468',0) RETURN
    END IF
 
    LET g_ofd.ofd22 = '1'
    LET g_ofd.ofd30 = ' '
    UPDATE ofd_file SET ofd22=g_ofd.ofd22,
                        ofd30=g_ofd.ofd30
     WHERE ofd01 = g_ofd.ofd01
    IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd ofd',STATUS,0)   #No.FUN-660167
       CALL cl_err3("upd","ofd_file",g_ofd.ofd01,"",STATUS,"","upd ofd",1)  #No.FUN-660167
       RETURN
    END IF
    DISPLAY BY NAME g_ofd.ofd22,g_ofd.ofd30
    CALL i701_ofd22_show()
END FUNCTION
 
FUNCTION i701_7()               #取消結案
    DEFINE l_ofd   RECORD LIKE ofd_file.*,
           l_ofd_o RECORD LIKE ofd_file.*,
           l_occ02        LIKE occ_file.occ02,
           l_no    LIKE type_file.num10  #No.FUN-680137 INTEGER
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofd.ofd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ofd.ofdacti != 'Y' THEN RETURN END IF
    IF g_ofd.ofd22!='4' THEN
       CALL cl_err(g_ofd.ofd01,'axm-468',0) RETURN
    END IF
 
    IF NOT cl_null(g_ofd.ofd30) THEN
       LET g_ofd.ofd22 = '3'
    ELSE
      IF NOT cl_null(g_ofd.ofd23) THEN
         LET g_ofd.ofd22 = '1'
      ELSE
         LET g_ofd.ofd22='2'            #取消結案時,不知前一狀況,只好大約判斷
      END IF
    END IF
    LET g_ofd.ofd39 = ' '
    LET g_ofd.ofd40 = ' '
    LET g_ofd.ofd41 = ' '
    UPDATE ofd_file SET ofd22=g_ofd.ofd22,ofd39=g_ofd.ofd39,
                        ofd40=g_ofd.ofd40,ofd41=g_ofd.ofd41
     WHERE ofd01 = g_ofd.ofd01
    IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd ofd',STATUS,0)   #No.FUN-660167
       CALL cl_err3("upd","ofd_file",g_ofd.ofd01,"",STATUS,"","upd ofd",1)  #No.FUN-660167
       RETURN
    END IF
    DISPLAY BY NAME g_ofd.ofd22
    CALL i701_ofd22_show()
END FUNCTION
 
FUNCTION i7011()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofd.ofd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ofd.ofdacti != 'Y' THEN RETURN END IF
    IF g_ofd.ofd22 NOT MATCHES '[02]' THEN
       CALL cl_err(g_ofd.ofd01,'axm-459',0) RETURN
    END IF
 
    LET g_ofd_o.* = g_ofd.*
    LET g_ofd.ofd22 = '1'
    LET g_ofd.ofd24 = g_today
    CALL i701_ofd22_show()
 
    CALL cl_set_comp_entry("ofd23,ofd24",TRUE)   #No.MOD-570109
 
    CALL cl_set_comp_required("ofd23",TRUE)   #FUN-5A0152
 
    INPUT BY NAME g_ofd.ofd22,g_ofd.ofd23,g_ofd.ofd24 WITHOUT DEFAULTS
 
      AFTER FIELD ofd23
       IF g_ofd.ofd23 IS NOT NULL THEN
         CALL i701_ofd23('d')
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_ofd.ofd23,g_errno,0)
            NEXT FIELD ofd23
         END IF
       END IF
 
       AFTER INPUT      #No.MOD-570109
         CALL cl_set_comp_entry("ofd23,ofd24",FALSE)
 
      ON ACTION controlp
         IF INFIELD(ofd23) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.default1 = g_ofd.ofd23
            CALL cl_create_qry() RETURNING g_ofd.ofd23
#            CALL FGL_DIALOG_SETBUFFER( g_ofd.ofd23 )
            DISPLAY BY NAME g_ofd.ofd23
            NEXT FIELD ofd23
         END IF
 
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_ofd.*  = g_ofd_o.*
       DISPLAY BY NAME g_ofd.ofd22,g_ofd.ofd23,g_ofd.ofd24
       CALL i701_ofd23('d')
       CALL i701_ofd22_show()
       RETURN
    END IF
    UPDATE ofd_file SET ofd22=g_ofd.ofd22,
                        ofd23=g_ofd.ofd23,
                        ofd24=g_ofd.ofd24
     WHERE ofd01 = g_ofd.ofd01
    IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd ofd',STATUS,0)   #No.FUN-660167
       CALL cl_err3("upd","ofd_file",g_ofd.ofd01,"",STATUS,"","upd ofd",1)  #No.FUN-660167
    END IF
END FUNCTION
 
#開放
FUNCTION i7012()
 DEFINE l_gen02     LIKE gen_file.gen02
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ofd.ofd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_ofd.ofdacti != 'Y' THEN RETURN END IF
    IF g_ofd.ofd22 NOT MATCHES '[1]' THEN
       CALL cl_err(g_ofd.ofd01,'axm-467',0) RETURN
    END IF
    IF NOT cl_confirm('axm-460') THEN RETURN END IF
    LET g_ofd.ofd22 = '2'
    LET g_ofd.ofd23 = ''
    LET g_ofd.ofd24 = ''
    LET l_gen02     = ''
    UPDATE ofd_file SET ofd22=g_ofd.ofd22,
                        ofd23=g_ofd.ofd23,
                        ofd24=g_ofd.ofd24
     WHERE ofd01 = g_ofd.ofd01
    IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd ofd',STATUS,0)    #No.FUN-660167
       CALL cl_err3("upd","ofd_file",g_ofd.ofd01,"",STATUS,"","upd ofd",1)  #No.FUN-660167
       RETURN
    END IF
    DISPLAY BY NAME g_ofd.ofd22,g_ofd.ofd23,g_ofd.ofd24
    DISPLAY l_gen02 TO FORMONLY.gen02
    CALL i701_ofd22_show()
 
END FUNCTION
 
FUNCTION i701_ofd22_show()
   #圖形顯示
   IF g_ofd.ofd22 = '4' THEN
      LET g_close = 'Y'
   ELSE
      LET g_close = 'N'
   END IF
   CALL cl_set_field_pic("","","",g_close,"",g_ofd.ofdacti)
   LET g_msg = ""
   CASE WHEN g_ofd.ofd22 = '0' CALL cl_getmsg('axm-450',g_lang) RETURNING g_msg
        WHEN g_ofd.ofd22 = '1' CALL cl_getmsg('axm-451',g_lang) RETURNING g_msg
        WHEN g_ofd.ofd22 = '2' CALL cl_getmsg('axm-452',g_lang) RETURNING g_msg
        WHEN g_ofd.ofd22 = '3' CALL cl_getmsg('axm-453',g_lang) RETURNING g_msg
        WHEN g_ofd.ofd22 = '4' CALL cl_getmsg('axm-454',g_lang) RETURNING g_msg
         OTHERWISE
    END CASE
    DISPLAY g_msg TO FORMONLY.ofd22_ds
    CALL cl_show_fld_cont()   #FUN-550037(smin)
END FUNCTION
#No.FUN-7C0043--start--
FUNCTION i701_out()
 DEFINE l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name      LIKE type_file.chr20,         #No.FUN-680137 VARCHAR(20)
        l_za05      LIKE ima_file.ima01,          #No.FUN-680137 VARCHAR(40)
        sr          RECORD
                    ofd     RECORD LIKE ofd_file.*
                    END RECORD
 DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                    
   IF cl_null(g_wc) AND NOT cl_null(g_ofd.ofd01) THEN                                                                               
      LET g_wc = " ofd01 = '",g_ofd.ofd01,"' "                                                                                      
   END IF                                                                                                                           
   IF cl_null(g_wc) THEN CALL cl_err(' ','9057',0) RETURN END IF                                                                    
   LET l_cmd = 'p_query "axmi701" "',g_wc CLIPPED,'"'                                                                               
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN
#  IF cl_null(g_wc) THEN CALL cl_err(' ','9057',0) RETURN END IF
#  CALL cl_wait()
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01=g_lang
 
#  LET g_sql="SELECT ofd_file.* ",
#            "  FROM ofd_file ",
#            " WHERE ",g_wc CLIPPED
#  PREPARE i701_pl FROM g_sql
#  DECLARE i701_co SCROLL CURSOR FOR i701_pl
 
#  LET g_rlang = g_lang                               #FUN-4C0096 add
#  CALL cl_outnam('axmi701') RETURNING l_name
#  START REPORT i701_rep TO l_name
#  FOREACH i701_co INTO sr.*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach2:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#      OUTPUT TO REPORT i701_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i701_rep
#   CLOSE i701_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i701_rep(sr)
#  DEFINE l_last_sw       LIKE type_file.chr1,      #No.FUN-680137 VARCHAR(1) 
#         sr              RECORD
#                         ofd     RECORD LIKE ofd_file.*
#                         END RECORD
#  DEFINE l_desc,l_desc2  LIKE type_file.chr8      #No.FUN-680137 VARCHAR(08)
#  DEFINE l_gen02         LIKE gen_file.gen02
 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.ofd.ofd01
#  FORMAT
#     PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  #NO.TQC-6A0091
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           #PRINT ''  #NO.TQC-6A0091
 
#           PRINT g_dash
#           PRINT g_x[31],
#                 g_x[32],
#                 g_x[33],
#                 g_x[34],
#                 g_x[35],
#                 g_x[36],
#                 g_x[37],
#                 g_x[38],
#                 g_x[39],
#                 g_x[40],
#                 g_x[41]                #No.TQC-740317
#           PRINT g_dash1
#     ON EVERY ROW
#
#        LET l_gen02 = ''
#        SELECT gen02 INTO l_gen02 FROM gen_file
#         WHERE gen01 = sr.ofd.ofd23
#        #No.TQC-740317  --Begin
#        IF sr.ofd.ofdacti = 'N' THEN
#        PRINT COLUMN g_c[31],'*';
#        END IF
#        #No.TQC-740317  --End
#        PRINT COLUMN g_c[32],sr.ofd.ofd01 CLIPPED,
#              COLUMN g_c[33],sr.ofd.ofd02[1,10] CLIPPED,  #No.TQC-6A0091
#              COLUMN g_c[34],sr.ofd.ofd03 CLIPPED,
#              COLUMN g_c[35],sr.ofd.ofd05 CLIPPED,
#              COLUMN g_c[36],sr.ofd.ofd33 CLIPPED,
#              COLUMN g_c[37],sr.ofd.ofd35 CLIPPED,
#              COLUMN g_c[38],sr.ofd.ofd23 CLIPPED,
#              COLUMN g_c[39],l_gen02 CLIPPED,
#              COLUMN g_c[40],sr.ofd.ofd31 CLIPPED,
#              COLUMN g_c[41],sr.ofd.ofd37 CLIPPED
#
#     ON LAST ROW
#        PRINT g_dash
#        PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED   #No.TQC-6A0091
#        LET l_last_sw = 'n'
 
#     PAGE TRAILER
#          IF l_last_sw = 'y' THEN
#             PRINT g_dash
#             PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED   #No.TQC-6A0091
#          ELSE
#             SKIP 2 LINE
#          END IF
#END REPORT
#No.FUN-7C0043--end--
 
FUNCTION i701_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ofd01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i701_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ofd01",FALSE)
  END IF
END FUNCTION
 

