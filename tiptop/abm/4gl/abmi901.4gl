# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmi901.4gl
# Descriptions...: 設計變更單資料維護作業
# Date & Author..: 91/05/15 By Lin
# Memo...........: 1992/05/15: 單號的判斷改用smy_file(原pmu_file),
#                  並呼叫s_mfgslip()(判斷單別), s_smyauno()(自動編號)
#                  1992/10/29(Lee): 新增若自動編號又輸入流水號的檢查s_mfgckno()
# Modify.........: 92/11/04  BY Apple (測試修改)
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: MOD-480279 04/08/12 By ching  remove 列印之open window
# Modify.........: No.MOD-4B0058 04/12/06 By Echo  aoos010設定不使用 EasyFlow 但單據設定需簽核(使用tiptop簡易簽核)
# Modify.........: No.FUN-4C0054 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510033 05/01/20 By Mandy 報表轉XML
# Modify.........: No.MOD-530327 05/03/26 By kim 若先輸入申請人後不會將該申請人所對應之部門帶出
# Modify.........: No.FUN-550032 05/05/17 By yoyo單據編號格式放大
# Modify         : No.MOD-4A0299 05/04/20 by Echo 複製功能，無判斷單別是否簽核
#                                                 將確認與簽核流程拆開獨立。
# Modify.........: No.MOD-560007 05/06/02 By Echo   重新定義整合FUN名稱
# Modify.........: No.MOD-550055 05/06/10 By pengu 變更申請單號(bmr01)開窗修改
# Modify.........: No.MOD-570173 05/07/12 By kim 進入後直接新增後存檔,執行列印功能,會出現請重新執行QBE條件查詢
# Modify.........: No.FUN-560051 05/08/03 By Rosayu 增加相關文件功能
# Modify.........: No.FUN-580158 05/08/24 By yiting 以 EF 為 backend engine, 由TIPTOP 處理前端簽核動作
# Modify..........:NO.MOD-590167 05/09/14 BY yiting 單別放大到5碼
# Modify.........: No.TQC-5A0056 05/10/21 By Rosayu 按右邊的變更說明後,畫面帶至abmi902,但單投中的申請單號不會自動帶出
# Modify.........: No.FUN-5A0097 05/10/18 By Claire 顯示部門及申請人名稱
# Modify.........: No.MOD-5A0405 05/10/31 By Pengu 1.ECN單號欄位太小，造成單號錯誤
# Modify.........: No.TQC-610068 06/01/20 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-630070 06/03/07 By Dido 流程訊息通知功能
# Modify.........: No.TQC-630177 06/03/17 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.MOD-650015 06/06/13 By douzh cl_err----->cl_err3
# Modify.........: No.TQC-660072 06/06/15 By Dido 補充TQC-630070
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-690023 06/09/14 By jamie 判斷occacti
# Modify.........: No.FUN-6A0002 06/10/20 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-710062 07/01/16 By chenl  增加對bmr01欄位的判斷。
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 07/12/18 By lala   報表轉為使用p_query            
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: NO.MOD-840333 08/04/21 by yiting bmr02需大於bmr03
# Modify.........: No.TQC-830038 08/05/22 by sherry 增加 部門名稱 DISPLAY
# Modify.........: No.TQC-830035 08/05/21 By xiaofeizhu 增加日期錄入時希望完成日期不可小於填單申請日期的警告
# Modify.........: No.TQC-8C0079 08/12/29 By claire  (1) 修改action choice          
#                                                    (2) 修改簽核確認仍可修改
# Modify.........: No.TQC-920056 09/02/20 By xiaofeizhu 已有ECN單號不可刪除
# Modify.........: No.TQC-970092 09/07/09 By lilingyu 無效資料不可刪除
# Modify.........: No.FUN-980001 09/08/06 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-960270 09/08/14 By destiny 打印時增加放棄按鈕 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No:FUN-950045 10/01/05 By jan 增加確認碼欄位及相關處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A60008 10/06/24 by destiny 增加abmi911逻辑 
# Modify.........: No.TQC-A80047 10/08/11 by destiny 审核时应考虑单据是否已签核
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.TQC-AB0099 10/12/13 by destiny 已有工程变更单的资料不能取消审核
# Modify.........: No.TQC-AC0170 10/12/14 By vealxu 1.不走製程BOM應該控卡不可執行
#                                                   2.執行後的程式代號和程式名稱錯誤，不應該用abmi901的
#                                                   3.在abmi911新增一筆資料後，bmr50='1' (應該為2才對)
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B50107 11/05/20 By vampire 申請人與申請部門位置對調
# Modify.........: No.TQC-B60274 11/06/22 By xianghui 錄入時更換bmr06和bmr05兩欄位的順序
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:CHI-B80034 11/10/06 By johung 修改申請人的開窗查詢不控卡一定要選擇部門
# Modify.........: No:FUN-C20011 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:FUN-C30017 12/03/07 By Mandy(1)TP端簽核時,[取消確認] ACTION要隱藏
#                                                 (2)單據已作廢時,不可送簽 
#                                                 (3)送簽中的單據,不可以執行作廢
# Modify.........: No:MOD-C60059 12/06/12 By ck2yuan 避免串查失敗,將第三參數往前放
# Modify.........: No:MOD-BA0153 12/06/15 By ck2yuan unconfirm的g_action_choice資料打錯
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR 
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-CA0161 12/11/23 By Nina 調整確認段及增加EasyFlow自動確認功能
# Modify.........: No:CHI-CA0035 13/01/28 By Elise 調整MOD-C60059參數避免串查錯誤,g_argv1:固定參數 g_argv2:單號 g_argv3:執行功能
# Modify.........: No:CHI-D20010 13/02/19 By yangtt 將作廢功能分成作廢與取消作廢2個action

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bmr01t         LIKE oay_file.oayslip,#單別(temp)  #No.FUN-680096 VARCHAR(5)
    g_bmr   RECORD LIKE bmr_file.*,
    g_bmr_t RECORD LIKE bmr_file.*,
    g_bmr_o RECORD LIKE bmr_file.*,
    g_bmr01_t LIKE bmr_file.bmr01,
    g_wc,g_sql          STRING,     #TQC-630166
    g_t1                LIKE oay_file.oayslip,   #No.FUN-550032   #No.FUN-680096 VARCHAR(5)
    g_sheet             LIKE type_file.chr5,     #No.FUN-680096 VARCHAR(5)           
    g_ydate             LIKE type_file.dat,      #No.FUN-680096 DATE
    g_statu             LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
    g_sta               LIKE cre_file.cre08,     #No.FUN-680096 VARCHAR(10)
    g_flag              LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
DEFINE   g_forupd_sql          STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done   STRING
DEFINE   g_argv2               LIKE bmr_file.bmr01  #NO.FUN-5801580  #CHI-CA0035 mod g_argv1->g_argv2
DEFINE   g_argv3               STRING               #NO.TQC-630070      #執行功能  #CHI-CA0035 mod g_argv2->g_argv3
DEFINE   g_laststage   LIKE type_file.chr1        #FUN-580158    #No.FUN-680096 VARCHAR(1) 
DEFINE   g_chr         LIKE type_file.chr1        #No.FUN-680096 VARCHAR(1)
DEFINE   g_chr2        LIKE type_file.chr1        #FUN-580158        #No.FUN-680096 VARCHAR(1)
DEFINE   g_approve     LIKE type_file.chr1        #No.FUN-680096 VARCHAR(1)
DEFINE   g_cnt         LIKE type_file.num10       #No.FUN-680096 INTEGER
DEFINE   g_i           LIKE type_file.num5        #count/index for any purpose    #No.FUN-680096 SMALLINT
DEFINE   g_msg         LIKE type_file.chr1000     #No.FUN-680096 VARCHAR(120)
DEFINE   g_row_count   LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_curs_index  LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_jump        LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5          #No.FUN-680096 SMALLINT
DEFINE   g_argv1       LIKE type_file.chr1        #No.FUN-A60008   #CHI-CA0035 mod g_argv3->g_argv1

MAIN
    IF FGL_GETENV("FGLGUI") <> "0" THEN  #FUN-CA0161 add
       OPTIONS
           INPUT NO WRAP
       DEFER INTERRUPT
    END IF                               #FUN-CA0161 add

   #CHI-CA0035---MOD---S
   #LET g_argv1 = ARG_VAL(2)                    #FUN-580158 ECR No.   #MOD-C60059 modify  ARG_VAL(1)->ARG_VAL(2)      
   #LET g_argv2 = ARG_VAL(3)   #執行功能        #TQC-63007            #MOD-C60059 modify  ARG_VAL(2)->ARG_VAL(3)
   ##No.FUN-A60008--begin 
   #LET g_argv3 = ARG_VAL(1)                    #MOD-C60059 modify  ARG_VAL(3)->ARG_VAL(1) 
   ##No.FUN-A60008--end

    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
   #CHI-CA0035---MOD---E
    
    #TQC-AC0170 --------------add start---------
    CASE g_argv1   #CHI-CA0035 mod g_argv3->g_argv1 
       WHEN '1'OR ''  LET g_prog = 'abmi901'
       WHEN '2'  LET g_prog = 'abmi911'
       OTHERWISE EXIT CASE
    END CASE
    #TQC-AC0170 --------------add end--------------
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABM")) THEN
       EXIT PROGRAM
    END IF
 
    #TQC-AC0170 ------------add start------------
    IF g_prog = 'abmi911' AND g_sma.sma542 = 'N' THEN 
       CALL cl_err('','abm-213',1)
       EXIT PROGRAM
    END IF  
    #TQC-AC0170 -----------add end---------------
    CALL cl_used(g_prog,g_time,1) RETURNING g_time
    #No.FUN-A60008--begin
    IF g_prog='abmi901' THEN 
       LET g_argv1='1'   #CHI-CA0035 mod g_argv3->g_argv1
    END IF 
    IF g_prog='abmi911' THEN
       LET g_argv1='2'   #CHI-CA0035 mod g_argv3->g_argv1
    END IF
    IF cl_null(g_argv1) THEN   #CHI-CA0035 mod g_argv3->g_argv1
       LET g_argv1='1'         #CHI-CA0035 mod g_argv3->g_argv1
    END IF 
    #No.FUN-A60008--end 
    INITIALIZE g_bmr.* TO NULL
    INITIALIZE g_bmr_t.* TO NULL
    INITIALIZE g_bmr_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM bmr_file WHERE bmr01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i901_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    IF fgl_getenv('EASYFLOW') = "1" THEN
          LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1  #CHI-CA0035 mod g_argv1->g_argv2
    END IF

    IF g_bgjob = 'N' OR cl_null(g_bgjob) THEN  #FUN-CA0161 add 
       OPEN WINDOW i901_w WITH FORM "abm/42f/abmi901"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
       CALL cl_ui_init()
    END IF                                     #FUN-CA0161 add
   
    #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
    #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
    CALL aws_efapp_toolbar()    #FUN-580158
 
    # 先以g_argv3判斷直接執行哪種功能：  #CHI-CA0035 mod g_argv2->g_argv3
    IF NOT cl_null(g_argv2) THEN         #CHI-CA0035 mod g_argv1->g_argv2
       CASE g_argv3                      #CHI-CA0035 mod g_argv2->g_argv3
         #FUN-CA0161 add str---
          WHEN "efconfirm"
             CALL i901_q()
             CALL i901_y_chk()       #CALL 原確認的 check 段
             IF g_success = 'Y' THEN
                CALL i901_y_upd()    #CALL 原確認的 update 段
             END IF
             EXIT PROGRAM
         #FUN-CA0161 add end---
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i901_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i901_a()
             END IF
          OTHERWISE          #TQC-660072
             CALL i901_q()   #TQC-660072
       END CASE
    END IF
 
   #FUN-CA0161 mark str---
   #IF NOT cl_null(g_argv1) THEN
   #   CALL i901_q()
   #END IF
   #FUN-CA0161 mark end---
 
    LET g_action_choice=""
    CALL i901_menu()
 
    CLOSE WINDOW i901_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i901_cs()
 
 IF NOT cl_null(g_argv2) THEN            #CHI-CA0035 mod g_argv1->g_argv2
     LET g_wc = "bmr01 = '",g_argv2,"'"  #CHI-CA0035 mod g_argv1->g_argv2
 ELSE
    CLEAR FORM
   INITIALIZE g_bmr.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        #基本資料
        # bmr01,bmr02,bmr03,bmr05,bmr06,     #MOD-B50107 mark
        bmr01,bmr02,bmr03,bmr06,bmr05,       #MOD-B50107 add
        bmr07,bmr04,bmrconf,bmr48,bmr49,  #FUN-950045
        #狀態
        bmruser,bmrgrup,bmrmodu,bmrdate,bmracti,
        #屬性
        bmr08,bmr09, bmr10,bmr11,
        bmr12,bmr13, bmr14,bmr141,
        bmr15,bmr151,
        #變更範圍
        bmr26,bmr27,
        #建議處理方式
        bmr16, bmr17,bmr18,
        bmr19,bmr20, bmr21,bmr22,
        bmr23,bmr24, bmr25,
        #變更後設計影響
        bmr36,bmr37, bmr38,bmr39,
        bmr40,bmr41, bmr42,bmr43,
        bmr44,bmr45,bmr46,
        #變更後工程影響
        bmr30,bmr31,bmr32, bmr33,bmr34,
        bmr35
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION CONTROLP
           CASE
                WHEN INFIELD(bmr01)

                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bmr"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bmr01
                    NEXT FIELD bmr01
               WHEN INFIELD(bmr05) #申請部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_bmr.bmr05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bmr05
                    NEXT FIELD bmr05
               WHEN INFIELD(bmr06) #申請人
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_dgen"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_bmr.bmr06
                   #LET g_qryparam.where = " gen03 MATCHES '",g_bmr.bmr05,"'"   #CHI-B80034 mark
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bmr06
                    NEXT FIELD bmr06
               WHEN INFIELD(bmr07) #料件編號
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.state = "c"
                 #   LET g_qryparam.default1 = g_bmr.bmr07
                 #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","",g_bmr.bmr07,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO bmr07
                    NEXT FIELD bmr07
               WHEN INFIELD(bmr04) #相關客戶
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_occ"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_bmr.bmr04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bmr04
                    NEXT FIELD bmr04
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
 END IF  #FUN-580158
    IF INT_FLAG THEN RETURN END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmruser', 'bmrgrup')
 
    LET g_sql="SELECT bmr01 FROM bmr_file ", # 組合出 SQL 指令
#        " WHERE ",g_wc CLIPPED, " ORDER BY bmr01"                           #No.FUN-A60008
        " WHERE bmr50= '",g_argv1,"' AND ",g_wc CLIPPED, " ORDER BY bmr01"   #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
    DISPLAY g_sql
    PREPARE i901_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i901_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i901_prepare
    LET g_sql=
#        "SELECT COUNT(*) FROM bmr_file WHERE ",g_wc CLIPPED                           #No.FUN-A60008
        "SELECT COUNT(*) FROM bmr_file WHERE bmr50= '",g_argv1,"' AND ",g_wc CLIPPED   #No.FUN-A60008  #CHI-CA0035 mod g_argv3->g_argv1
    PREPARE i901_precount FROM g_sql
    DECLARE i901_count CURSOR FOR i901_precount
END FUNCTION
 
FUNCTION i901_menu()
    DEFINE l_cmd        LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(200)
    DEFINE l_creator    LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
    DEFINE l_flowuser   LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
    DEFINE l_wc         STRING                  #No.FUN-820002
 
    LET l_flowuser = "N"
 
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail,, query,locale, void, undo_void, confirm, undo_confirm,easyflow_approval,invalid,unconfirm") #FUN-C30017 add unconfirm  #CHI-D20010 add undo_void
               RETURNING g_laststage
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i901_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i901_q()
            END IF
        ON ACTION next
            CALL i901_fetch('N')
        ON ACTION previous
            CALL i901_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i901_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i901_x()
                #FUN-950045--begin--mod-----
                #IF g_bmr.bmr48='Y' AND g_bmr.bmr49='1' THEN
                #   LET g_approve = "Y"
                #ELSE
                #   LET g_approve = "N"
                #END IF
                #CALL cl_set_field_pic("",g_approve,"","","",g_bmr.bmracti)
                 CALL i901_pic()
                #FUN-950045--end--mod-----
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i901_r()
            END IF
        ON ACTION change_description
            IF g_bmr.bmr01 IS NOT NULL AND g_bmr.bmr01 != ' '
               THEN  LET l_cmd = "abmi902 '",g_bmr.bmr01,"'" CLIPPED  #TQC-5A0056 add
                     CALL cl_cmdrun(l_cmd)
                END IF
 
         ON ACTION easyflow_approval            #MOD-4A0299
            LET g_action_choice="easyflow_approval" #TQC-8C0079
            IF cl_chk_act_auth() THEN
              #FUN-C20011 add str---
               SELECT * INTO g_bmr.* FROM bmr_file
                WHERE bmr01 = g_bmr.bmr01
               CALL i901_show()
              #FUN-C20011 add end---
               CALL i901_ef()                            #No:6686
               CALL i901_show()  #FUN-C20011 add
            END IF
 
         ON ACTION approval_status                 #MOD-4A0299
            LET g_action_choice="approval_status"
            IF cl_chk_act_auth() THEN
               IF aws_condition2() THEN
                    CALL aws_efstat2()        #MOD-560007
               END IF
            END IF
 
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i901_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i901_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i901_fetch('/')
        ON ACTION first
            CALL i901_fetch('F')
        ON ACTION last
            CALL i901_fetch('L')
        ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          #FUN-950045--begin--mod-----
          # IF g_bmr.bmr48='Y' AND g_bmr.bmr49='1' THEN
          #    LET g_approve = "Y"
          # ELSE
          #    LET g_approve = "N"
          # END IF
          # CALL cl_set_field_pic("",g_approve,"","","",g_bmr.bmracti)
            CALL i901_pic()
          #FUN-950045--end--mod-------
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
            LET g_action_choice = "exit"
            CONTINUE MENU
        #"准"
        ON ACTION agree
            LET g_action_choice="agree"
              IF g_laststage = "Y" AND l_flowuser = 'N' THEN #最後一關
                 CALL i901_y_upd()      #CALL 原確認的 update 段
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                    IF cl_confirm('aws-081') THEN
                       IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1  #CHI-CA0035 mod g_argv1->g_argv2
                          IF NOT cl_null(g_argv2) THEN     #CHI-CA0035 mod g_argv1->g_argv2
                                CALL i901_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                CALL aws_efapp_flowaction("insert, modify,
                                delete, reproduce, detail, query, locale,
                                void, undo_void, confirm, undo_confirm,easyflow_approval,unconfirm") #FUN-C30017 add unconfirm  #CHI-D20010 add undo_void
                                      RETURNING g_laststage
                          ELSE
                              EXIT MENU
                          END IF
                        ELSE
                            EXIT MENU
                        END IF
                    ELSE
                        EXIT MENU
                    END IF
              END IF
 
         #"不准"
         ON ACTION deny
            LET g_action_choice="deny"
             IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN
                IF aws_efapp_formapproval() THEN
                   IF l_creator = "Y" THEN
                      LET g_bmr.bmr49 = 'R'
                      DISPLAY BY NAME g_bmr.bmr49
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                          LET l_flowuser = 'N'
                          LET g_argv2 = aws_efapp_wsk(1)   #參數:key-1  #CHI-CA0035 mod g_argv1->g_argv2
                          IF NOT cl_null(g_argv2) THEN     #CHI-CA0035 mod g_argv1->g_argv2
                                CALL i901_q()
                                #設定簽核功能及哪些 action 在簽核狀態時是不可被>
                                CALL aws_efapp_flowaction("insert, modify,
                                delete,reproduce, detail, query, locale,void,undo_void,   #CHI-D20010 add undo_void
                                confirm, undo_confirm,easyflow_approval,unconfirm") #FUN-C30017 add unconfirm
                                      RETURNING g_laststage
                          ELSE
                                 EXIT MENU
                          END IF
                      ELSE
                             EXIT MENU
                      END IF
                   ELSE
                       EXIT MENU
                   END IF
                END IF
              END IF
        
         #FUN-950045--begin--add-------
         ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
              #FUN-CA0161 mod str---
              #CALL i901_confirm()
               CALL i901_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL i901_y_upd()       #CALL 原確認的 update 段
               END IF
              #FUN-CA0161 mod end---
            END IF
            CALL i901_pic()

         ON ACTION unconfirm
           #LET g_action_choice="confirm"      #MOD-BA0153 mark
            LET g_action_choice="unconfirm"    #MOD-BA0153 add
            IF cl_chk_act_auth() THEN
                CALL i901_unconfirm()
            END IF
            CALL i901_pic()
  
         ON ACTION void
            LET g_action_choice="void"
            IF cl_chk_act_auth() THEN
               #CALL i901_void()      #CHI-D20010
                CALL i901_void(1)      #CHI-D20010
            END IF
            CALL i901_pic()
         #FUN-950045--end--add---
        
         #CHI-D20010---begin
         ON ACTION undo_void
            IF cl_chk_act_auth() THEN
             # CALL i901_void()    #CHI-D20010
               CALL i901_void(2)   #CHI-D20010
            END IF
            CALL i901_pic()
         #CHI-D20010---end

         #@WHEN "加簽"
         ON ACTION modify_flow
            LET g_action_choice="modify_flow"
              IF aws_efapp_flowuser() THEN
                 LET g_laststage = 'N'
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
         #"撤簽"
         ON ACTION withdraw
            LET g_action_choice="withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT MENU
                 END IF
              END IF
 
         #"抽單"
         ON ACTION org_withdraw
            LET g_action_choice="org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT MENU
                 END IF
              END IF
 
        #"簽核意見"
         ON ACTION phrase
            LET g_action_choice="phrase"
              CALL aws_efapp_phrase()
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_bmr.bmr01 IS NOT NULL THEN
                 LET g_doc.column1 = "bmr01"
                 LET g_doc.value1  = g_bmr.bmr01
                 CALL cl_doc()
              END IF
           END IF
 
      &include "qry_string.4gl"
    END MENU
    CLOSE i901_cs
END FUNCTION
 
 
FUNCTION i901_a()
    DEFINE li_result LIKE type_file.num5         #No.FUN-550032        #No.FUN-680096 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_bmr.* LIKE bmr_file.*
    INITIALIZE g_bmr_o.* LIKE bmr_file.*
    LET g_bmr01_t = NULL
    LET g_bmr.bmr01=NULL
    LET g_bmr.bmr02=g_today
    LET g_bmr.bmr08='N'
    LET g_bmr.bmr09='N'
    LET g_bmr.bmr10='N'
    LET g_bmr.bmr11='N'
    LET g_bmr.bmr12='N'
    LET g_bmr.bmr13='N'
    LET g_bmr.bmr14='N'
    LET g_bmr.bmr15='N'
    LET g_bmr.bmr17= 0
    LET g_bmr.bmr19= 0
    LET g_bmr.bmr21= 0
    LET g_bmr.bmr23= 0
    LET g_bmr.bmr25= 0
    LET g_bmr.bmr26='N'
    LET g_bmr.bmr27='N'
    LET g_bmr.bmr30='N'
    LET g_bmr.bmr31='N'
    LET g_bmr.bmr32='N'
    LET g_bmr.bmr33='N'
    LET g_bmr.bmr34='N'
    LET g_bmr.bmr36='N'
    LET g_bmr.bmr37='N'
    LET g_bmr.bmr38='N'
    LET g_bmr.bmr39='N'
    LET g_bmr.bmr40='N'
    LET g_bmr.bmr41='N'
    LET g_bmr.bmr42='N'
    LET g_bmr.bmr43='N'
    LET g_bmr.bmr44='N'
    LET g_bmr.bmr45='N'
    LET g_bmr.bmr48='N'
    LET g_bmr.bmr49='0'
    LET g_bmr.bmrconf = 'N'   #FUN-950045
    LET g_bmr.bmrsseq=0
    LET g_bmr.bmrsmax=0
    #No.FUN-A60008--begin
    IF g_argv1='1' THEN   #CHI-CA0035 mod g_argv3->g_argv1
       LET g_bmr.bmr50='1'
    ELSE 
       LET g_bmr.bmr50='2'
    END IF 
    #No.FUN-A60008--end 
    LET g_bmr.bmrplant = g_plant 
    LET g_bmr.bmrlegal = g_legal 
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_bmr.bmracti ='Y'                   #有效的資料
        LET g_bmr.bmruser = g_user
        LET g_bmr.bmroriu = g_user #FUN-980030
        LET g_bmr.bmrorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_bmr.bmrgrup = g_grup               #使用者所屬群
        LET g_bmr.bmrdate = g_today
 
        IF NOT cl_null(g_argv2) AND (g_argv3 = "insert") THEN  #CHI-CA0035 mod g_argv1->g_argv2,g_argv2->g_argv3
           LET g_bmr.bmr01 = g_argv2                           #CHI-CA0035 mod g_argv1->g_argv2
        END IF
 
        CALL i901_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_bmr.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_bmr.bmr01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK #No:7857
        CALL s_auto_assign_no("abm",g_bmr.bmr01,g_bmr.bmr02,"2","bmr_file","bmr01","","","") RETURNING li_result,g_bmr.bmr01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_bmr.bmr01
 

 
        INSERT INTO bmr_file VALUES(g_bmr.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","bmr_file",g_bmr.bmr01,"",SQLCA.sqlcode,"","",1) # TQC-660046  #No.FUN-B80100---上移一行調整至回滾事務前---
            ROLLBACK WORK #No:7857
            CONTINUE WHILE
        ELSE
            COMMIT WORK #No:7857
            CALL cl_flow_notify(g_bmr.bmr01,'I')
            LET g_bmr_t.* = g_bmr.*                # 保存上筆資料
            SELECT bmr01 INTO g_bmr.bmr01 FROM bmr_file
                WHERE bmr01 = g_bmr.bmr01
            LET g_ydate = g_bmr.bmr02                #備份上一筆交貨日期
            CALL s_get_doc_no(g_bmr.bmr01) RETURNING g_sheet
        END IF
        MESSAGE ""
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i901_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
	l_cmd           LIKE type_file.chr20,      #No.FUN-680096 VARCHAR(20)
        l_flag          LIKE type_file.chr1,       #判斷必要欄位是否有輸入    #No.FUN-680096 VARCHAR(1)
        l_direct        LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
        l_dir1          LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
        l_dir2          LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
        l_dir3          LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
        l_dir4          LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
        l_dir5          LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
        l_n             LIKE type_file.num5        #No.FUN-680096 SMALLINT
        DEFINE  li_result  LIKE type_file.num5     #No.FUN-550032      #No.FUN-680096 SMALLINT
 
    DISPLAY BY NAME g_bmr.bmr49,g_bmr.bmracti,g_bmr.bmruser,g_bmr.bmrgrup,
                    g_bmr.bmrdate,g_bmr.bmrconf   #FUN-950045
 
    INPUT BY NAME g_bmr.bmroriu,g_bmr.bmrorig,
        #基本資料
        # g_bmr.bmr01,g_bmr.bmr02, g_bmr.bmr03,g_bmr.bmr05,g_bmr.bmr06,     #MOD-B50107 mark
       #g_bmr.bmr01,g_bmr.bmr02, g_bmr.bmr03,g_bmr.bmr05,g_bmr.bmr06,       #MOD-B50107 add   #TQC-B60274 mark
        g_bmr.bmr01,g_bmr.bmr02, g_bmr.bmr03,g_bmr.bmr06,g_bmr.bmr05,       #TQC-B60274 
        g_bmr.bmr07, g_bmr.bmr04,g_bmr.bmr48,
        #狀態
        g_bmr.bmruser,g_bmr.bmrgrup,g_bmr.bmrmodu,g_bmr.bmrdate,g_bmr.bmracti,
        #屬性
        g_bmr.bmr08,g_bmr.bmr09, g_bmr.bmr10,g_bmr.bmr11,
        g_bmr.bmr12,g_bmr.bmr13, g_bmr.bmr14,g_bmr.bmr141,
        g_bmr.bmr15,g_bmr.bmr151,
        #變更範圍
        g_bmr.bmr26,g_bmr.bmr27,
        #建議處理方式
        g_bmr.bmr16, g_bmr.bmr17,g_bmr.bmr18,
        g_bmr.bmr19,g_bmr.bmr20, g_bmr.bmr21,g_bmr.bmr22,
        g_bmr.bmr23,g_bmr.bmr24, g_bmr.bmr25,
        #變更後設計影響
        g_bmr.bmr36,g_bmr.bmr37, g_bmr.bmr38,g_bmr.bmr39,
        g_bmr.bmr40,g_bmr.bmr41, g_bmr.bmr42,g_bmr.bmr43,
        g_bmr.bmr44,g_bmr.bmr45,g_bmr.bmr46,
        #變更後工程影響
        g_bmr.bmr30,g_bmr.bmr31,g_bmr.bmr32, g_bmr.bmr33,g_bmr.bmr34,
        g_bmr.bmr35
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i901_set_entry(p_cmd)
            CALL i901_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("bmr01")
 
        BEFORE FIELD bmr03                                                    #TQC-830035                                           
            CALL cl_err('',369,0)                                             #TQC-830035
 
        AFTER FIELD bmr01

            IF NOT cl_null(g_bmr.bmr01) THEN
               IF p_cmd='a' OR (p_cmd='u' AND g_bmr.bmr01!=g_bmr01_t) THEN  #No.TQC-710062
                  CALL s_check_no("abm",g_bmr.bmr01,g_bmr01_t,"2","bmr_file","bmr01","")
                  RETURNING li_result,g_bmr.bmr01
                  DISPLAY BY NAME g_bmr.bmr01
                  IF (NOT li_result) THEN
                     LET g_bmr.bmr01=g_bmr_o.bmr01
                     NEXT FIELD bmr01
                  END IF
               END IF    #No.TQC-710062
 
             IF g_bmr_o.bmr01 IS NULL OR g_bmr.bmr01 != g_bmr_o.bmr01

                THEN  LET g_bmr.bmr48=g_smy.smyapr          #No.FUN-550032
                      LET g_bmr.bmrsign=g_smy.smysign
                      DISPLAY BY NAME g_bmr.bmr48
             END IF

           END IF
           LET g_bmr_o.bmr01=g_bmr.bmr01
 
        AFTER FIELD bmr02  #申請日期
           IF NOT cl_null(g_bmr.bmr03) AND NOT cl_null(g_bmr.bmr02) THEN
               IF g_bmr.bmr03 < g_bmr.bmr02 THEN
                   CALL cl_err('','abm-903',0)
                   NEXT FIELD bmr03
               END IF
           END IF
 
        AFTER FIELD bmr03  #希望完成日期
           IF NOT cl_null(g_bmr.bmr03) AND NOT cl_null(g_bmr.bmr02) THEN
               IF g_bmr.bmr03 < g_bmr.bmr02 THEN
                   CALL cl_err('','abm-903',0)
                   NEXT FIELD bmr03
               END IF
           END IF
 
        AFTER FIELD bmr05  #部門
           IF NOT cl_null(g_bmr.bmr05) THEN
              IF (g_bmr_o.bmr05 IS NULL) OR (g_bmr.bmr05 != g_bmr_o.bmr05) THEN
                  CALL i901_bmr05('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_bmr.bmr05,g_errno,0)
                     LET g_bmr.bmr05 = g_bmr_o.bmr05
                     DISPLAY BY NAME g_bmr.bmr05
                     NEXT FIELD bmr05
                  END IF
              END IF
           END IF
           LET g_bmr_o.bmr05 = g_bmr.bmr05
 
        AFTER FIELD bmr06  #申請人
           IF NOT cl_null(g_bmr.bmr06) THEN
              IF (g_bmr_o.bmr06 IS NULL) OR (g_bmr.bmr06 != g_bmr_o.bmr06) THEN
                  CALL i901_bmr06('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_bmr.bmr06,g_errno,0)
                     LET g_bmr.bmr06 = g_bmr_o.bmr06
                     DISPLAY BY NAME g_bmr.bmr06
                     NEXT FIELD bmr06
                  ELSE
                     SELECT gen03 INTO g_bmr.bmr05 FROM gen_file WHERE
                        gen01=g_bmr.bmr06
                        DISPLAY BY NAME g_bmr.bmr05
                        CALL i901_bmr05('a')        #No.TQC-830038
                     END IF
                  END IF
           END IF
           LET g_bmr_o.bmr06 = g_bmr.bmr06
 
        BEFORE FIELD bmr07  #料件編號
	   IF g_sma.sma60 = 'Y' THEN	# 若須分段輸入
	      CALL s_inp5(12,11,g_bmr.bmr07) RETURNING g_bmr.bmr07
	      DISPLAY BY NAME g_bmr.bmr07
	   END IF
 
        AFTER FIELD bmr07  #料件編號
           IF NOT cl_null(g_bmr.bmr07) THEN
              #FUN-AA0059 ----------------------------add start-------------------------
              IF NOT s_chk_item_no(g_bmr.bmr07,'') THEN
                 CALL cl_err('',g_errno,1)
                 LET g_bmr.bmr07 = g_bmr_o.bmr07
                 DISPLAY BY NAME g_bmr.bmr07
                 NEXT FIELD bmr07
              END IF 
              #FUN-AA0059 ----------------------------add end-------------------------
              IF (g_bmr_o.bmr07 IS NULL) OR (g_bmr.bmr07 != g_bmr_o.bmr07) THEN
                  CALL i901_bmr07('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_bmr.bmr07,g_errno,0)
                     LET g_bmr.bmr07 = g_bmr_o.bmr07
                     DISPLAY BY NAME g_bmr.bmr07
                     NEXT FIELD bmr07
                  END IF
              END IF
           END IF
           LET g_bmr_o.bmr07 = g_bmr.bmr07
 
        AFTER FIELD bmr04  #相關客戶
           IF g_bmr.bmr04 IS NOT NULL THEN
              IF ((g_bmr_o.bmr04 IS NULL) OR (g_bmr.bmr04 != g_bmr_o.bmr04)) AND
		   g_sma.sma02 MATCHES '[Yy]' THEN  #與銷售管理連線時才check
                   CALL i901_bmr04('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_bmr.bmr04,g_errno,0)
                      LET g_bmr.bmr04 = g_bmr_o.bmr04
                      DISPLAY BY NAME g_bmr.bmr04
                      NEXT FIELD bmr04
                   END IF
              END IF
           END IF
           LET g_bmr_o.bmr04 = g_bmr.bmr04
        AFTER FIELD bmr08  #圖面修正
            LET g_bmr_o.bmr08 = g_bmr.bmr08
 
        AFTER FIELD bmr09  #產品性能改進
            LET g_bmr_o.bmr09 = g_bmr.bmr09
 
        AFTER FIELD bmr10  #製造困難
            LET g_bmr_o.bmr10 = g_bmr.bmr10
 
        AFTER FIELD bmr11  #採購困難
            LET g_bmr_o.bmr11 = g_bmr.bmr11
 
        AFTER FIELD bmr12  #降低製造成本
            LET g_bmr_o.bmr12 = g_bmr.bmr12
 
        AFTER FIELD bmr13  #重新設計
            LET g_bmr_o.bmr13 = g_bmr.bmr13
 
        BEFORE FIELD bmr14  #應客戶需求
            CALL i901_set_entry(p_cmd)
 
        AFTER FIELD bmr14  #應客戶需求
            LET g_bmr_o.bmr14 = g_bmr.bmr14
	    IF g_bmr.bmr14='N' THEN
	       LET g_bmr.bmr141=''
	       DISPLAY BY NAME g_bmr.bmr141
            END IF
            CALL i901_set_no_entry(p_cmd)
 
        BEFORE FIELD bmr15  #其它
            CALL i901_set_entry(p_cmd)
 
        AFTER FIELD bmr15  #圖面修正
            LET g_bmr_o.bmr15 = g_bmr.bmr15
	    IF g_bmr.bmr15='N' THEN
	       LET g_bmr.bmr151=''
	       DISPLAY BY NAME g_bmr.bmr151
            END IF
            CALL i901_set_no_entry(p_cmd)
 
        AFTER FIELD bmr26  #變更申請範圍
           LET g_bmr_o.bmr26 = g_bmr.bmr26
 
        AFTER FIELD bmr27  #變更申請範圍
           LET g_bmr_o.bmr27 = g_bmr.bmr27
 
        BEFORE FIELD bmr16
           CALL i901_set_entry(p_cmd)
 
        AFTER FIELD bmr16  #供應商庫存
           IF cl_null(g_bmr.bmr16) THEN
               LET g_bmr.bmr17 = 0
               DISPLAY BY NAME g_bmr.bmr17
           END IF
  	   IF g_bmr.bmr16 NOT MATCHES '[A-E]' THEN
	      LET g_bmr.bmr16=g_bmr_o.bmr16
	      DISPLAY BY NAME g_bmr.bmr16
	      NEXT FIELD bmr16
           END IF
           LET g_bmr_o.bmr16 = g_bmr.bmr16
           CALL i901_set_no_entry(p_cmd)
 
        AFTER FIELD bmr17  #供應商庫存成本耗用
   	   IF g_bmr.bmr17 IS NULL OR g_bmr.bmr17 < 0 THEN
	      LET g_bmr.bmr17=g_bmr_o.bmr17
	      DISPLAY BY NAME g_bmr.bmr17
	      NEXT FIELD bmr17
           END IF
           LET g_bmr_o.bmr17 = g_bmr.bmr17
 
        BEFORE FIELD bmr18  #零件庫存
           CALL i901_set_entry(p_cmd)
 
        AFTER FIELD bmr18  #零件庫存
           IF cl_null(g_bmr.bmr18) THEN
               LET g_bmr.bmr19 = 0
               DISPLAY BY NAME g_bmr.bmr19
           END IF
           IF g_bmr.bmr18 NOT MATCHES '[A-E]' THEN
	      LET g_bmr.bmr18=g_bmr_o.bmr18
	      DISPLAY BY NAME g_bmr.bmr18
	      NEXT FIELD bmr18
           END IF
           LET g_bmr_o.bmr18 = g_bmr.bmr18
           CALL i901_set_no_entry(p_cmd)
 
        AFTER FIELD bmr19  #零件庫存成本耗用
	   IF g_bmr.bmr19 IS NULL OR g_bmr.bmr19 < 0 THEN
	      LET g_bmr.bmr19=g_bmr_o.bmr19
	      DISPLAY BY NAME g_bmr.bmr19
	      NEXT FIELD bmr19
           END IF
           LET g_bmr_o.bmr19 = g_bmr.bmr19
 
        BEFORE FIELD bmr20    #在製品庫存
           CALL i901_set_entry(p_cmd)
 
        AFTER FIELD bmr20  #在製品庫存
           IF cl_null(g_bmr.bmr20) THEN
               LET g_bmr.bmr21 = 0
               DISPLAY BY NAME g_bmr.bmr21
           END IF
	   IF g_bmr.bmr20 NOT MATCHES '[A-E]' THEN
	      LET g_bmr.bmr20=g_bmr_o.bmr20
	      DISPLAY BY NAME g_bmr.bmr20
	      NEXT FIELD bmr20
           END IF
           LET g_bmr_o.bmr20 = g_bmr.bmr20
           CALL i901_set_no_entry(p_cmd)
 
        AFTER FIELD bmr21  #在製品庫存成本耗用
	   IF g_bmr.bmr21 IS NULL OR g_bmr.bmr21 < 0 THEN
	      LET g_bmr.bmr21=g_bmr_o.bmr21
	      DISPLAY BY NAME g_bmr.bmr21
	      NEXT FIELD bmr21
           END IF
           LET g_bmr_o.bmr21 = g_bmr.bmr21
 
        BEFORE FIELD bmr22  #成品庫存
           CALL i901_set_entry(p_cmd)
 
        AFTER FIELD bmr22  #成品庫存
           IF cl_null(g_bmr.bmr22) THEN
               LET g_bmr.bmr23 = 0
               DISPLAY BY NAME g_bmr.bmr23
           END IF
	   IF g_bmr.bmr22 NOT MATCHES '[A-E]' THEN
	      LET g_bmr.bmr22=g_bmr_o.bmr22
	      DISPLAY BY NAME g_bmr.bmr22
	      NEXT FIELD bmr22
           END IF
           LET g_bmr_o.bmr22 = g_bmr.bmr22
           CALL i901_set_no_entry(p_cmd)
 
        AFTER FIELD bmr23  #成品庫存成本耗用
	   IF g_bmr.bmr23 IS NULL OR g_bmr.bmr23 < 0 THEN
	      LET g_bmr.bmr23=g_bmr_o.bmr23
	      DISPLAY BY NAME g_bmr.bmr23
	      NEXT FIELD bmr23
            END IF
            LET g_bmr_o.bmr23 = g_bmr.bmr23
 
        BEFORE FIELD bmr24  #已出貨庫存
           CALL i901_set_entry(p_cmd)
 
        AFTER FIELD bmr24  #已出貨庫存
           IF cl_null(g_bmr.bmr24) THEN
               LET g_bmr.bmr25 = 0
               DISPLAY BY NAME g_bmr.bmr25
           END IF
           IF g_bmr.bmr24 NOT MATCHES '[A-E]' THEN
	      LET g_bmr.bmr24=g_bmr_o.bmr24
	      DISPLAY BY NAME g_bmr.bmr24
	      NEXT FIELD bmr24
           END IF
           LET g_bmr_o.bmr24 = g_bmr.bmr24
           CALL i901_set_no_entry(p_cmd)
 
        AFTER FIELD bmr25  #已出貨庫存成本耗用
   	   IF g_bmr.bmr25 IS NULL OR g_bmr.bmr25 < 0 THEN
	      LET g_bmr.bmr25=g_bmr_o.bmr25
	      DISPLAY BY NAME g_bmr.bmr25
	      NEXT FIELD bmr25
           END IF
           LET g_bmr_o.bmr25 = g_bmr.bmr25
 
        AFTER FIELD bmr36  #Firmware
            LET g_bmr_o.bmr36 = g_bmr.bmr36
 
        AFTER FIELD bmr37  #Sckematic
            LET g_bmr_o.bmr37 = g_bmr.bmr37
 
        AFTER FIELD bmr38  #PACKING
            LET g_bmr_o.bmr38 = g_bmr.bmr38
 
        AFTER FIELD bmr39  #QVL
            LET g_bmr_o.bmr39 = g_bmr.bmr39
 
        AFTER FIELD bmr40  #UL.CSA.ECC.VDE
            LET g_bmr_o.bmr40 = g_bmr.bmr40
 
        AFTER FIELD bmr41  #S/W
            LET g_bmr_o.bmr41 = g_bmr.bmr41
 
        AFTER FIELD bmr42  #BOM
            LET g_bmr_o.bmr42 = g_bmr.bmr42
 
        AFTER FIELD bmr43  #PCB
            LET g_bmr_o.bmr43 = g_bmr.bmr43
 
        AFTER FIELD bmr44  #產品規格
            LET g_bmr_o.bmr44 = g_bmr.bmr44
 
        BEFORE FIELD bmr45
            CALL i901_set_entry(p_cmd)
 
        AFTER FIELD bmr45  #其它
            LET g_bmr_o.bmr45 = g_bmr.bmr45
	    IF g_bmr.bmr45='N' THEN
	       LET g_bmr.bmr46 =''
	       DISPLAY BY NAME g_bmr.bmr46
            END IF
            CALL i901_set_no_entry(p_cmd)
 
        AFTER FIELD bmr30  #製具
    	   IF g_bmr.bmr30 IS NULL OR g_bmr.bmr30 NOT MATCHES '[YN]' THEN
	      LET g_bmr.bmr30=g_bmr_o.bmr30
	      DISPLAY BY NAME g_bmr.bmr30
	      NEXT FIELD bmr30
           END IF
           LET g_bmr_o.bmr30 = g_bmr.bmr30
 
        AFTER FIELD bmr31  #測試方式
  	   IF g_bmr.bmr31 IS NULL OR g_bmr.bmr31 NOT MATCHES '[YN]' THEN
	      LET g_bmr.bmr31=g_bmr_o.bmr31
	      DISPLAY BY NAME g_bmr.bmr31
	      NEXT FIELD bmr31
           END IF
           LET g_bmr_o.bmr31 = g_bmr.bmr31
 
        AFTER FIELD bmr32  #工時
   	   IF g_bmr.bmr32 IS NULL OR g_bmr.bmr32 NOT MATCHES '[YN]' THEN
	      LET g_bmr.bmr32=g_bmr_o.bmr32
	      DISPLAY BY NAME g_bmr.bmr32
	      NEXT FIELD bmr32
           END IF
           LET g_bmr_o.bmr32 = g_bmr.bmr32
 
        AFTER FIELD bmr33  #製造
   	   IF g_bmr.bmr33 IS NULL OR g_bmr.bmr33 NOT MATCHES '[YN]' THEN
	      LET g_bmr.bmr33=g_bmr_o.bmr33
	      DISPLAY BY NAME g_bmr.bmr33
	      NEXT FIELD bmr33
           END IF
           LET g_bmr_o.bmr33 = g_bmr.bmr33
 
        BEFORE FIELD bmr34  #其它
           CALL i901_set_entry(p_cmd)
 
        AFTER FIELD bmr34  #其它
   	   IF g_bmr.bmr34 IS NULL OR g_bmr.bmr34 NOT MATCHES '[YN]' THEN
	      LET g_bmr.bmr34=g_bmr_o.bmr34
	      DISPLAY BY NAME g_bmr.bmr34
	      NEXT FIELD bmr34
           END IF
           LET g_bmr_o.bmr34 = g_bmr.bmr34
   	   IF g_bmr.bmr34 = 'N' THEN
	      LET g_bmr.bmr35=''
	      DISPLAY BY NAME g_bmr.bmr35
           END IF
           CALL i901_set_no_entry(p_cmd)

 
        ON ACTION CONTROLP
           CASE
                WHEN INFIELD(bmr01)
                    LET g_t1=s_get_doc_no(g_bmr.bmr01)   #No.FUN-550032
                    CALL q_smy(FALSE,FALSE,g_t1,'ABM','2') RETURNING g_t1 #TQC-670008
                    LET g_bmr.bmr01 = g_t1            #No.FUN-550032
                    DISPLAY BY NAME g_bmr.bmr01
                    NEXT FIELD bmr01
               WHEN INFIELD(bmr05) #申請部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_bmr.bmr05
                    CALL cl_create_qry() RETURNING g_bmr.bmr05
                    DISPLAY BY NAME g_bmr.bmr05
                    CALL i901_bmr05('d')
                    NEXT FIELD bmr05
               WHEN INFIELD(bmr06) #申請人
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_dgen"
                    LET g_qryparam.default1 = g_bmr.bmr06
                   #LET g_qryparam.where = " gen03 MATCHES '",g_bmr.bmr05,"'"   #CHI-B80034 mark
                    CALL cl_create_qry() RETURNING g_bmr.bmr06
                    DISPLAY BY NAME g_bmr.bmr06
                    CALL i901_bmr06('d')
                    NEXT FIELD bmr06
               WHEN INFIELD(bmr07) #料件編號
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.default1 = g_bmr.bmr07
                 #   CALL cl_create_qry() RETURNING g_bmr.bmr07
                    CALL q_sel_ima(FALSE, "q_ima", "",g_bmr.bmr07, "", "", "", "" ,"",'' )  RETURNING g_bmr.bmr07
#FUN-AA0059 --End--
                    DISPLAY BY NAME g_bmr.bmr07
                    CALL i901_bmr07('d')
                    NEXT FIELD bmr07
               WHEN INFIELD(bmr04) #相關客戶
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_occ"
                    LET g_qryparam.default1 = g_bmr.bmr04
                    CALL cl_create_qry() RETURNING g_bmr.bmr04
                    DISPLAY BY NAME g_bmr.bmr04
                    CALL i901_bmr04('d')
                    NEXT FIELD bmr04
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION mntn_doc_pty
	   LET l_cmd="asmi300 'abm' "
	   CALL cl_cmdrun(l_cmd CLIPPED)
 
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
 
FUNCTION i901_bmr05(p_cmd)  #部門代號
    DEFINE p_cmd	LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_gem02 LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti
           INTO l_gem02,l_gemacti
           FROM gem_file WHERE gem01 = g_bmr.bmr05
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                            LET l_gem02 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
 
END FUNCTION
 
FUNCTION i901_bmr06(p_cmd)  #人員代號
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_gen02   LIKE gen_file.gen02,
           l_gen03   LIKE gen_file.gen03,
           l_genacti LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti
           INTO l_gen02,l_gen03,l_genacti
           FROM gen_file WHERE gen01 = g_bmr.bmr06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                            LET l_gen02 = NULL
        #WHEN l_gen03 !=g_bmr.bmr05 LET g_errno='mfg3202'   #CHI-B80034 mark
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.gen02  #FUN-5A0097
    END IF
END FUNCTION
 
FUNCTION i901_bmr07(p_cmd)  #料件編號
    DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ima02     LIKE ima_file.ima02,
           l_ima021    LIKE ima_file.ima021,
           l_imaacti   LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti
           INTO l_ima02,l_ima021,l_imaacti
           FROM ima_file WHERE ima01 = g_bmr.bmr07
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL
                            LET l_ima021= NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02 TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
    END IF
END FUNCTION
 
FUNCTION i901_bmr04(p_cmd)  #相關客戶
    DEFINE p_cmd	LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_occ02      LIKE occ_file.occ02,
           l_occacti    LIKE occ_file.occacti
 
    LET g_errno = ' '
    SELECT occ02,occacti
           INTO l_occ02,l_occacti
           FROM occ_file WHERE occ01 = g_bmr.bmr04
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2732'
                            LET l_occ02 = NULL
         WHEN l_occacti='N' LET g_errno = '9028'
         WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_occ02 TO FORMONLY.occ02
    END IF
END FUNCTION
 
 
 
FUNCTION i901_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmr.* TO NULL              #No.FUN-6A0002
   #MESSAGE ""            #FUN-CA0161 mark
    CALL cl_msg("")       #FUN-CA0161 add
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i901_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i901_count
    FETCH i901_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i901_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0)
        INITIALIZE g_bmr.* TO NULL
    ELSE
        CALL i901_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i901_fetch(p_flbmr)
    DEFINE
        p_flbmr    LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
 
    CASE p_flbmr
        WHEN 'N' FETCH NEXT     i901_cs INTO g_bmr.bmr01
        WHEN 'P' FETCH PREVIOUS i901_cs INTO g_bmr.bmr01
        WHEN 'F' FETCH FIRST    i901_cs INTO g_bmr.bmr01
        WHEN 'L' FETCH LAST     i901_cs INTO g_bmr.bmr01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i901_cs INTO g_bmr.bmr01
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0)
        INITIALIZE g_bmr.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbmr
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bmr.* FROM bmr_file            # 重讀DB,因TEMP有不被更新特性
       WHERE bmr01 = g_bmr.bmr01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","bmr_file",g_bmr.bmr01,"",SQLCA.sqlcode,"","",1) #No.TQC-660046
    ELSE
        LET g_data_owner = g_bmr.bmruser      #FUN-4C0054
        LET g_data_group = g_bmr.bmrgrup      #FUN-4C0054
        LET g_data_plant = g_bmr.bmrplant #FUN-980030
        CALL i901_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i901_show()
    DEFINE l_str  LIKE bmx_file.bmx01     #No.MOD-5A0405 add
    LET g_bmr_t.* = g_bmr.*
    DISPLAY BY NAME g_bmr.bmroriu,g_bmr.bmrorig,
        #基本資料
        g_bmr.bmr01,g_bmr.bmr02, g_bmr.bmr03,g_bmr.bmr05,g_bmr.bmr06,
        g_bmr.bmr07, g_bmr.bmr04,g_bmr.bmr48,g_bmr.bmr49,g_bmr.bmrconf, #FUN-950045
        #狀態
        g_bmr.bmruser,g_bmr.bmrgrup,g_bmr.bmrmodu,g_bmr.bmrdate,g_bmr.bmracti,
        #屬性
        g_bmr.bmr08,g_bmr.bmr09, g_bmr.bmr10,g_bmr.bmr11,
        g_bmr.bmr12,g_bmr.bmr13, g_bmr.bmr14,g_bmr.bmr141,
        g_bmr.bmr15,g_bmr.bmr151,
        #變更範圍
        g_bmr.bmr26,g_bmr.bmr27,
        #建議處理方式
        g_bmr.bmr16, g_bmr.bmr17,g_bmr.bmr18,
        g_bmr.bmr19,g_bmr.bmr20, g_bmr.bmr21,g_bmr.bmr22,
        g_bmr.bmr23,g_bmr.bmr24, g_bmr.bmr25,
        #變更後設計影響
        g_bmr.bmr36,g_bmr.bmr37, g_bmr.bmr38,g_bmr.bmr39,
        g_bmr.bmr40,g_bmr.bmr41, g_bmr.bmr42,g_bmr.bmr43,
        g_bmr.bmr44,g_bmr.bmr45,g_bmr.bmr46,
        #變更後工程影響
        g_bmr.bmr30,g_bmr.bmr31,g_bmr.bmr32, g_bmr.bmr33,g_bmr.bmr34,
        g_bmr.bmr35
        CALL i901_bmr04('d')
        CALL i901_bmr07('d')
        CALL i901_bmr05('d') #FUN-5A0097
        CALL i901_bmr06('d') #FUN-5A0097
        #圖形顯示
       #FUN-950045--begin--mod----------
       #IF g_bmr.bmr48='Y' AND g_bmr.bmr49='1' THEN
       #   LET g_approve = "Y"
       #ELSE
       #   LET g_approve = "N"
       #END IF
       #CALL cl_set_field_pic("",g_approve,"","","",g_bmr.bmracti)
        CALL i901_pic()
       #FUN-950045--end--mod-------    
 

    DECLARE i901_ecn CURSOR FOR
            SELECT bmx01 FROM bmx_file WHERE bmx05 = g_bmr.bmr01 ORDER BY 1
    LET g_msg = NULL
    FOREACH i901_ecn INTO l_str
       LET g_msg = g_msg CLIPPED,l_str CLIPPED,','
    END FOREACH
    DISPLAY g_msg TO ecnno
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i901_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_bmr.bmr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_bmr.bmracti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_bmr.bmr01,'9027',0)
        RETURN
    END IF

     IF g_bmr.bmr49 matches '[Ss]' THEN              #TQC-8C0079 
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF
    #FUN-950045--begin--add----
    IF g_bmr.bmrconf = 'Y' THEN
       CALL cl_err('','aap-086',0)
       RETURN
    END IF
    
    IF g_bmr.bmrconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
    #FUN-950045--end--add------
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bmr01_t = g_bmr.bmr01
    LET g_bmr_o.*=g_bmr.*
    BEGIN WORK
    OPEN i901_cl USING g_bmr.bmr01
    IF STATUS THEN
       CALL cl_err("OPEN i901_cl:", STATUS, 1)
       CLOSE i901_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i901_cl INTO g_bmr.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_bmr.bmrmodu=g_user                     #修改者
    LET g_bmr.bmrdate = g_today                  #修改日期
    CALL i901_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i901_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bmr.*=g_bmr_t.*
            CALL i901_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
         LET g_bmr.bmr49 = '0'                  #MOD-4A0299
        UPDATE bmr_file SET bmr_file.* = g_bmr.*    # 更新DB
            WHERE bmr01 = g_bmr01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","bmr_file",g_bmr.bmr01,"",SQLCA.sqlcode,"","",1) #TQC-660046
            CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_bmr.bmr49
       # CALL cl_set_field_pic("",g_approve,"","","",g_bmr.bmracti) #FUN-950045
         CALL i901_pic()   #FUN-950045
        EXIT WHILE
    END WHILE
    CLOSE i901_cl
    COMMIT WORK
    CALL cl_flow_notify(g_bmr.bmr01,'U')
END FUNCTION
 
FUNCTION i901_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_bmr.bmr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
     IF g_bmr.bmr49 matches '[Ss]' THEN         #TQC-8C0079
       CALL cl_err("","mfg3557",0)
       RETURN
    END IF
 
    #FUN-950045--begin--add----
    IF g_bmr.bmrconf = 'Y' THEN
       CALL cl_err('','aap-086',0)
       RETURN
    END IF
    
    IF g_bmr.bmrconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
    #FUN-950045--end--add------

    BEGIN WORK
    OPEN i901_cl USING g_bmr.bmr01
    IF STATUS THEN
       CALL cl_err("OPEN i901_cl:", STATUS, 1)
       CLOSE i901_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i901_cl INTO g_bmr.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i901_show()
    IF cl_exp(0,0,g_bmr.bmracti) THEN
        LET g_chr=g_bmr.bmracti
        IF g_bmr.bmracti='Y' THEN
            LET g_bmr.bmracti='N'
        ELSE
            LET g_bmr.bmracti='Y'
        END IF
        UPDATE bmr_file
            SET bmracti=g_bmr.bmracti,
               bmrmodu=g_user, bmrdate=g_today
            WHERE bmr01=g_bmr.bmr01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","bmr_file",g_bmr.bmr01,"",SQLCA.sqlcode,"","",1) #TQC-660046
            LET g_bmr.bmracti=g_chr
        END IF
        DISPLAY BY NAME g_bmr.bmracti
    END IF
    CLOSE i901_cl
    COMMIT WORK
    CALL cl_flow_notify(g_bmr.bmr01,'V')
END FUNCTION
 
FUNCTION i901_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
    DEFINE l_cnt LIKE type_file.num10         #No.TQC-920056
 
    IF s_shut(0) THEN RETURN END IF
    IF g_bmr.bmr01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
     IF g_bmr.bmr49 matches '[Ss]' THEN     #  #TQC-8C0079 
       CALL cl_err("","mfg3557",0)
       RETURN
    END IF
 
    IF g_bmr.bmracti = 'N' THEN
       CALL cl_err('','abm-033',0)
       RETURN
    END IF 
 
    #FUN-950045--begin--add----
    IF g_bmr.bmrconf = 'Y' THEN
       CALL cl_err('','aap-086',0)
       RETURN
    END IF
    
    IF g_bmr.bmrconf = 'X' THEN
       CALL cl_err('',9024,0)
       RETURN
    END IF
    #FUN-950045--end--add------

    SELECT count(*) INTO l_cnt FROM bmx_file
     WHERE bmx05 = g_bmr.bmr01
    IF l_cnt > 0 THEN
       CALL cl_err(g_bmr.bmr01,'mfg0008',1)
       RETURN
    END IF
 
    BEGIN WORK
    OPEN i901_cl USING g_bmr.bmr01
    IF STATUS THEN
       CALL cl_err("OPEN i901_cl:", STATUS, 1)
       CLOSE i901_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i901_cl INTO g_bmr.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0) RETURN END IF
    CALL i901_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bmr01"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1  = g_bmr.bmr01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
        DELETE FROM bmr_file WHERE bmr01=g_bmr.bmr01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","bmr_file",g_bmr.bmr01,"",SQLCA.sqlcode,"","",1) #TQC-660046
        ELSE
           CLEAR FORM
           INITIALIZE g_bmr.* TO NULL
           OPEN i901_count
           #FUN-B50062-add-start--
           IF STATUS THEN
              CLOSE i901_cs  
              CLOSE i901_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end--
           FETCH i901_count INTO g_row_count
           #FUN-B50062-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i901_cs  
              CLOSE i901_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50062-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i901_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i901_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET g_no_ask = TRUE
              CALL i901_fetch('/')
           END IF
        END IF
    END IF
    CLOSE i901_cl
    COMMIT WORK
    CALL cl_flow_notify(g_bmr.bmr01,'D')
END FUNCTION
 
FUNCTION i901_copy()
   DEFINE l_bmr           RECORD LIKE bmr_file.*,
	  l_t1            LIKE aac_file.aac02,
          l_oldno,l_newno LIKE bmr_file.bmr01
   DEFINE li_result  LIKE type_file.num5          #No.FUN-550032  #No.FUN-680096 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_bmr.bmr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i901_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM bmr01
        BEFORE INPUT
            CALL cl_set_docno_format("bmr01")
        AFTER FIELD bmr01
           IF l_newno IS NOT NULL THEN
           CALL s_check_no("abm",l_newno,"","2","bmr_file","bmr01","")
           RETURNING li_result,l_newno
           DISPLAY l_newno TO bmr01
           IF (NOT li_result) THEN
              LET g_bmr.bmr01 = g_bmr_o.bmr01
              NEXT FIELD bmr01
           END IF
 

 
            BEGIN WORK #No:7857
             CALL s_auto_assign_no("abm",l_newno,g_bmr.bmr02,"2","bmr_file","bmr01","","","")
             RETURNING li_result,l_newno
             IF (NOT li_result) THEN
                NEXT FIELD bmr01
             END IF
             DISPLAY l_newno TO bmr01

        END IF
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bmr01)
                    LET l_t1=s_get_doc_no(l_newno)       #No.FUN-550032
                    CALL q_smy(FALSE,FALSE,l_t1,'ABM','2') RETURNING l_t1 #TQC-670008
                     LET l_newno=l_t1                    #No.FUN-550032
                    DISPLAY l_newno TO bmr01
                    NEXT FIELD bmr01
            END CASE
 
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
        LET INT_FLAG = 0
        DISPLAY BY NAME g_bmr.bmr01
        ROLLBACK WORK
        RETURN
    END IF
    LET l_bmr.* = g_bmr.*
    LET l_bmr.bmr01  =l_newno   #資料鍵值
    LET l_bmr.bmrsseq=0         #已簽核順序
    LET l_bmr.bmruser=g_user    #資料所有者
    LET l_bmr.bmrgrup=g_grup    #資料所有者所屬群
    LET l_bmr.bmrmodu=NULL      #資料修改日期
    LET l_bmr.bmrdate=g_today   #資料建立日期
    LET l_bmr.bmracti='Y'       #有效資料
    LET l_bmr.bmr48=g_smy.smyapr                #MOD-4A0299
    LET l_bmr.bmr49='0'                         #MOD-4A0299
    LET l_bmr.bmrconf = 'N'     #FUN-950045
 
    LET l_bmr.bmrplant = g_plant 
    LET l_bmr.bmrlegal = g_legal 
 
 
    LET l_bmr.bmroriu = g_user      #No.FUN-980030 10/01/04
    LET l_bmr.bmrorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO bmr_file VALUES (l_bmr.*)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","bmr_file",l_newno,"",SQLCA.sqlcode,"","",1) # TQC-660046  #No.FUN-B80100---上移一行調整至回滾事務前---
        ROLLBACK WORK #No:7857
    ELSE
        COMMIT WORK #No:7857
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_bmr.bmr01
        SELECT bmr_file.* INTO g_bmr.* FROM bmr_file
                       WHERE bmr01 = l_newno
        CALL i901_u()
        #SELECT bmr_file.* INTO g_bmr.* FROM bmr_file  #FUN-C30027
        #               WHERE bmr01 = l_oldno          #FUN-C30027
    END IF
    CALL i901_show()
END FUNCTION
 
FUNCTION i901_out()
DEFINE l_cmd  LIKE type_file.chr1000
DEFINE l_wc          STRING

 
     MENU ""
        ON ACTION brief_report_print
           CALL i901_out1()
 
        ON ACTION engineering_change_requisite

             LET g_msg = 'bmr01 = "',g_bmr.bmr01,'"'
            # LET g_msg = "abmr901 '",g_today,"' '",g_user,"' '",g_lang,"' ", #FUN-C30085 mark
             LET g_msg = "abmg901 '",g_today,"' '",g_user,"' '",g_lang,"' ", #FUN-C30085 mark
                         " 'Y' ' ' '1' ", 
                         " '",g_msg,"' 'Y' 'Y'"
           CALL cl_cmdrun(g_msg)
 
        ON ACTION exit
           EXIT MENU
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION cancel        #NO.TQC-960270                                                                                        
         EXIT MENU            #NO.TQC-960270 
 
 
         -- for Windows close event trapped
         ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
              LET INT_FLAG=FALSE 		#MOD-570244	mars
             LET g_action_choice = "exit"
             EXIT MENU
 
     END MENU

 
END FUNCTION
 
FUNCTION i901_out1()
DEFINE l_cmd  LIKE type_file.chr1000

     IF cl_null(g_wc) AND NOT cl_null(g_bmr.bmr01) THEN                                                                             
        LET g_wc = " bmr01 = '",g_bmr.bmr01,"'"                                                                                     
     END IF                                                                                                                         
     IF g_wc IS NULL THEN                                                                                                           
        CALL cl_err('','9057',0)                                                                                                    
        RETURN                                                                                                                      
     END IF                                                                                                                         
     LET l_cmd = 'p_query "abmi901" "',g_wc CLIPPED,'"'                                                                             
     CALL cl_cmdrun(l_cmd)

END FUNCTION
 

 
FUNCTION i901_g()
   DEFINE l_cmd		LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(200)
          l_prog	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(10)
          l_wc,l_wc2	LIKE type_file.chr50,   #No.FUN-680096 VARCHAR(50)
          l_prtway	LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
   DEFINE l_sw          LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_n           LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_buf         LIKE type_file.chr6,    #No.FUN-680096 VARCHAR(6)
          l_name        LIKE type_file.chr20    #No.FUN-680096 VARCHAR(20)
   DEFINE l_easycmd     LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(4096)
          l_updsql_0    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
          l_updsql_1    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
          l_updsql_2    LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
          l_upload      LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
 
   IF g_aza.aza23 matches '[ Nn]'
     THEN
     CALL cl_err('aza23','mfg3551',0)
     RETURN
   END IF
 
   IF g_bmr.bmr01 IS NULL OR g_bmr.bmr01 = ' '
     THEN RETURN
   END IF
 
   IF g_bmr.bmr48 IS NULL OR g_bmr.bmr48 matches '[Nn]'
     THEN
     CALL cl_err('','mfg3549',0)
     RETURN
   END IF
 
   IF g_bmr.bmr49 matches '[Ss]'    #TQC-8C0079
     THEN
     CALL cl_err('','mfg3557',0)  #本單據目前已送簽或已核准
     RETURN
   END IF
 
#--- 產生本張單據之報表檔
 #   LET l_prog='abmr901'  #FUN-C30085 mark
   LET l_prog='abmg901' #FUN-C30085 add
 
#---- 抓報表檔名  l_name
   CALL cl_outnam(l_prog) RETURNING l_name
   LET l_cmd = l_prog CLIPPED,
               " '",g_bmr.bmr01,"' 'Y' 'N' '",g_today,"'",
               " '",g_user,"' '0' 'Y' '0' '1' '",l_name CLIPPED,"'"
 
    CALL cl_cmdrun(l_cmd)
 
 
#---- 更新[目前狀態] 為 'S.送簽中'

   LET l_updsql_0="UPDATE bmr_file SET bmr49='S' WHERE bmr01='",g_bmr.bmr01,"';"
   LET l_updsql_1="UPDATE bmr_file SET bmr49='1' WHERE bmr01='",g_bmr.bmr01,"';"
   LET l_updsql_2="UPDATE bmr_file SET bmr49='R' WHERE bmr01='",g_bmr.bmr01,"';"
   LET l_easycmd='ef ',
                 '"','TIPTOP_ECR','" ',                  #E-Form單別
                 '"','abmi901','" ',                    #程式代號
                 '"',g_bmr.bmr01 CLIPPED,'" ',          #單號
                 '"',g_dbs CLIPPED,'" ',                #資料庫(連線字串)
                 '"',l_updsql_0 CLIPPED,'" ',           #更新狀況碼-送簽中
                 '"',l_updsql_1 CLIPPED,'" ',           #簽核同意
                 '"',l_updsql_2 CLIPPED,'" ',           #簽核不同意
                 '"','1','" ',                          #附件總數
                 '"',l_name CLIPPED,'" ',               #報表檔徑名
                 '"','1','" ',                          #條件欄位總數
                 '"CA1" '         #條件1: 簽核等級
  RUN l_easycmd
END FUNCTION
 
FUNCTION i901_ef()
 
   CALL i901_y_chk()
   IF g_success = "N" THEN
      RETURN
   END IF
 
   CALL aws_condition()                            #判斷送簽資料
   IF g_success = 'N' THEN
         RETURN
   END IF
 
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
 
   IF aws_efcli2(base.TypeInfo.create(g_bmr),'','','','','')
   THEN
       LET g_success = 'Y'
       LET g_bmr.bmr49 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
       DISPLAY BY NAME g_bmr.bmr49
   ELSE
       LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION i901_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bmr01",TRUE)
   END IF
   IF INFIELD(bmr14) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bmr141",TRUE)
   END IF
   IF INFIELD(bmr15) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bmr151",TRUE)
   END IF
   IF INFIELD(bmr16) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bmr17",TRUE)
   END IF
   IF INFIELD(bmr18) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bmr19",TRUE)
   END IF
   IF INFIELD(bmr20) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bmr21",TRUE)
   END IF
   IF INFIELD(bmr22) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bmr23",TRUE)
   END IF
   IF INFIELD(bmr24) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bmr25",TRUE)
   END IF
   IF INFIELD(bmr34) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bmr35",TRUE)
   END IF
   IF INFIELD(bmr45) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("bmr46",TRUE)
   END IF
END FUNCTION
 
FUNCTION i901_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("bmr01",FALSE)
   END IF
   IF INFIELD(bmr14) OR (NOT g_before_input_done) THEN
       IF g_bmr.bmr14 = 'N' THEN
           CALL cl_set_comp_entry("bmr141",FALSE)
       END IF
   END IF
   IF INFIELD(bmr15) OR (NOT g_before_input_done) THEN
       IF g_bmr.bmr15 = 'N' THEN
           CALL cl_set_comp_entry("bmr151",FALSE)
       END IF
   END IF
   IF INFIELD(bmr16) OR (NOT g_before_input_done) THEN
       IF cl_null(g_bmr.bmr16) THEN
           CALL cl_set_comp_entry("bmr17",FALSE)
       END IF
   END IF
   IF INFIELD(bmr18) OR (NOT g_before_input_done) THEN
       IF cl_null(g_bmr.bmr18) THEN
           CALL cl_set_comp_entry("bmr19",FALSE)
       END IF
   END IF
   IF INFIELD(bmr20) OR (NOT g_before_input_done) THEN
       IF cl_null(g_bmr.bmr20) THEN
           CALL cl_set_comp_entry("bmr21",FALSE)
       END IF
   END IF
   IF INFIELD(bmr22) OR (NOT g_before_input_done) THEN
       IF cl_null(g_bmr.bmr22) THEN
           CALL cl_set_comp_entry("bmr23",FALSE)
       END IF
   END IF
   IF INFIELD(bmr24) OR (NOT g_before_input_done) THEN
       IF cl_null(g_bmr.bmr24) THEN
           CALL cl_set_comp_entry("bmr25",FALSE)
       END IF
   END IF
   IF INFIELD(bmr34) OR (NOT g_before_input_done) THEN
      IF g_bmr.bmr34 = 'N' THEN
          CALL cl_set_comp_entry("bmr35",FALSE)
      END IF
   END IF
   IF INFIELD(bmr45) OR (NOT g_before_input_done) THEN
       IF g_bmr.bmr45 = 'N' THEN
           CALL cl_set_comp_entry("bmr46",FALSE)
       END IF
   END IF
END FUNCTION
 
FUNCTION i901_y_chk()
DEFINE l_cnt       LIKE type_file.num5          #No.FUN-680096 SMALLINT
DEFINE l_str       LIKE type_file.chr4          #No.FUN-680096 VARCHAR(4)
DEFINE l_pml04     LIKE pml_file.pml04
DEFINE l_imaacti   LIKE ima_file.imaacti
DEFINE l_ima140    LIKE ima_file.ima140
 
   LET g_success = 'Y'
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_bmr.* FROM bmr_file WHERE bmr01 = g_bmr.bmr01
   IF cl_null(g_bmr.bmr01) THEN CALL cl_err('',-400,0) LET g_success = 'N' RETURN END IF   #FUN-C30017 add g_success 
   IF g_bmr.bmrconf = 'X' THEN CALL cl_err('','9024',0) LET g_success = 'N' RETURN END IF  #FUN-C30017--add
   IF g_bmr.bmrconf = 'Y' THEN CALL cl_err('','9023',1) LET g_success = 'N' RETURN END IF  #FUN-CA0161 add
   IF g_bmr.bmracti='N' THEN CALL cl_err('','mfg0301',1) LET g_success = 'N' RETURN END IF #FUN-C30017 add g_success 

 
END FUNCTION
 
FUNCTION i901_y_upd()
 
   LET g_success = 'Y'

  #FUN-CA0161 add str---
    IF g_action_choice CLIPPED = "confirm" OR  #執行 "確認" 功能(非簽核模式呼叫)
       g_action_choice CLIPPED = "insert"
    THEN
       IF g_bmr.bmr48 = 'Y' THEN        #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
          IF g_bmr.bmr49 != '1' THEN
             CALL cl_err('','aws-078',1)  #此狀況碼不為「1.已核准」，不可確認!!
             LET g_success = 'N'
             RETURN
          END IF
       END IF
       IF NOT cl_confirm('axm-108') THEN RETURN END IF  #詢問是否執行確認功能
    END IF
  #FUN-CA0161 add end---

   BEGIN WORK
 
   OPEN i901_cl USING g_bmr.bmr01
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN i901_cl:", STATUS, 1)
      CLOSE i901_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i901_cl INTO g_bmr.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0)
      CLOSE i901_cl
      ROLLBACK WORK
      RETURN
   END IF

  #FUN-CA0161 add str---
   UPDATE bmr_file
      SET bmrconf = 'Y',
          bmr49 = '1'
   WHERE bmr01 = g_bmr.bmr01

   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_success = 'N'
      CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
  #FUN-CA0161 add end---

   IF g_success = 'Y' THEN
      IF g_bmr.bmr48 = 'Y' THEN
         CASE aws_efapp_formapproval()
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   ROLLBACK WORK
                   RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET g_bmr.bmr49='1'
         LET g_bmr.bmrconf='Y'  #FUN-CA0161 add
         CLOSE i901_cl          #FUN-CA0161 add
         COMMIT WORK
         CALL cl_flow_notify(g_bmr.bmr01,'Y')
         DISPLAY BY NAME g_bmr.bmr49
         DISPLAY BY NAME g_bmr.bmrconf  #FUN-CA0161 add
      ELSE
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
   SELECT * INTO g_bmr.* FROM bmr_file WHERE bmr01 = g_bmr.bmr01
   IF g_bmr.bmr49='1' OR
      g_bmr.bmr49='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic('',g_chr2,'','','',g_bmr.bmracti)
END FUNCTION

#FUN-CA0161 mark str---拆解至y_chk()及y_upd()
##FUN-950045--begin--add--
#FUNCTION i901_confirm()
#
#   IF s_shut(0) THEN RETURN END IF
#
#   IF cl_null(g_bmr.bmr01) THEN
#      CALL cl_err('','-400',0)
#      RETURN
#   END IF
#
#   IF g_bmr.bmrconf = 'Y' THEN CALL cl_err('','9023',1) RETURN END IF
#   IF g_bmr.bmrconf = 'X' THEN CALL cl_err('','9024',1) RETURN END IF
#
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#   #No.TQC-A80047--begin
#   IF g_bmr.bmr48='Y' THEN
#      IF g_bmr.bmr49 != '1' THEN
#          CALL cl_err('','aws-078',1)
#          RETURN
#      END IF
#   END IF
#   #No.TQC-A80047--end
#   BEGIN WORK
#
#    OPEN i901_cl USING g_bmr.bmr01
#    IF STATUS THEN
#       CALL cl_err("OPEN i901_cl:", STATUS, 1)
#       CLOSE i901_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    FETCH i901_cl INTO g_bmr.*               # 對DB鎖定
#    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0)
#        CLOSE i901_cl
#        ROLLBACK WORK
#        RETURN
#    END IF
#
#    UPDATE bmr_file
#       SET bmrconf = 'Y',
#           bmr49 = '1'
#     WHERE bmr01 = g_bmr.bmr01
#    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#       CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0)
#       ROLLBACK WORK
#       RETURN
#    END IF
#    LET g_bmr.bmrconf = 'Y'
#    LET g_bmr.bmr49 ='1'
#    DISPLAY BY NAME g_bmr.bmrconf,g_bmr.bmr49
#    CLOSE i901_cl
#    COMMIT WORK
#END FUNCTION
#FUN-CA0161 mark end---

FUNCTION i901_unconfirm()
DEFINE  l_n   LIKE type_file.num5  #TQC-AB0099

   IF s_shut(0) THEN RETURN END IF

   IF cl_null(g_bmr.bmr01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF

   IF g_bmr.bmrconf = 'N' THEN CALL cl_err('','9002',1) RETURN END IF
   IF g_bmr.bmrconf = 'X' THEN CALL cl_err('','9024',1) RETURN END IF
   IF g_bmr.bmr49 <> '1' THEN RETURN END IF
   #TQC-AB0099--begin
   SELECT count(*) INTO l_n FROM bmx_file WHERE bmx05=g_bmr.bmr01
   IF l_n>0 THEN
      CALL cl_err('','abm-301',1)
      RETURN
   END IF
   #TQC-AB0099--end
   IF NOT cl_confirm('axm-109') THEN RETURN END IF

   BEGIN WORK

    OPEN i901_cl USING g_bmr.bmr01
    IF STATUS THEN
       CALL cl_err("OPEN i901_cl:", STATUS, 1)
       CLOSE i901_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i901_cl INTO g_bmr.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0)
        CLOSE i901_cl
        ROLLBACK WORK
        RETURN
    END IF

    UPDATE bmr_file
       SET bmrconf = 'N',
           bmr49 = '0'
     WHERE bmr01 = g_bmr.bmr01
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
    END IF
    LET g_bmr.bmrconf = 'N'
    LET g_bmr.bmr49 = '0'
    DISPLAY BY NAME g_bmr.bmrconf,g_bmr.bmr49
    CLOSE i901_cl
    COMMIT WORK
END FUNCTION

#FUNCTION i901_void()   #CHI-D20010
FUNCTION i901_void(p_type)    #CHI-D20010
DEFINE l_chr    LIKE bmr_file.bmrconf
DEFINE l_void   LIKE bmr_file.bmr49
DEFINE l_flag   LIKE type_file.chr1  #CHI-D20010
DEFINE p_type   LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF

   IF cl_null(g_bmr.bmr01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF
   #FUN-C30017---add---str---
   IF g_bmr.bmr49 matches '[Ss]' THEN     
       CALL cl_err("","mfg3557",0) #本單據目前已送簽或已核准
       RETURN
   END IF
   #FUN-C30017---add---end---

   IF g_bmr.bmrconf = 'Y' THEN CALL cl_err('','9023',1) RETURN END IF
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_bmr.bmrconf ='X' THEN RETURN END IF
   ELSE
      IF g_bmr.bmrconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

    BEGIN WORK

    OPEN i901_cl USING g_bmr.bmr01
    IF STATUS THEN
       CALL cl_err("OPEN i901_cl:", STATUS, 1)
       CLOSE i901_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i901_cl INTO g_bmr.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmr.bmr01,SQLCA.sqlcode,0)
        CLOSE i901_cl
        ROLLBACK WORK
        RETURN
    END IF
    IF g_bmr.bmrconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010

  # Prog. Version..: '5.30.06-13.03.12(0,0,g_bmr.bmrconf) THEN  #CHI-D20010
   IF cl_void(0,0,l_flag) THEN         #CHI-D20010
      LET l_chr = g_bmr.bmrconf
      LET l_void = g_bmr.bmr49
     #IF g_bmr.bmrconf = 'N' THEN   #CHI-D20010
      IF p_type = 1 THEN            #CHI-D20010
         LET g_bmr.bmrconf = 'X'
         LET g_bmr.bmr49 = 'X'
      ELSE
         LET g_bmr.bmrconf = 'N'
         LET g_bmr.bmr49 = '0'
      END IF
      UPDATE bmr_file
         SET bmrconf = g_bmr.bmrconf,
             bmr49 = g_bmr.bmr49
       WHERE bmr01 = g_bmr.bmr01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","bmr_file",g_bmr.bmr01,"",SQLCA.sqlcode,"","",1)
          LET g_bmr.bmrconf=l_chr
          LET g_bmr.bmr49 = l_void
          ROLLBACK WORK
      END IF
      DISPLAY BY NAME g_bmr.bmrconf,g_bmr.bmr49
   END IF 
   CLOSE i901_cl
   COMMIT WORK
END FUNCTION

FUNCTION i901_pic()
DEFINE l_confirm   LIKE type_file.chr1
DEFINE l_void      LIKE type_file.chr1

   CASE g_bmr.bmrconf
        WHEN 'Y'   LET l_confirm = 'Y' LET l_void = ''
        WHEN 'N'   LET l_confirm = 'N' LET l_void = ''
        WHEN 'X'   LET l_confirm = '' LET l_void = 'Y'
   END CASE
   IF g_bmr.bmr48='Y' AND g_bmr.bmr49='1' THEN
      LET g_approve = "Y"
   ELSE
      LET g_approve = "N"
   END IF
   CALL cl_set_field_pic(l_confirm,g_approve,"","",l_void,g_bmr.bmracti)      
END FUNCTION
#FUN-950045--end--add-------
#No:FUN-9C0077 
