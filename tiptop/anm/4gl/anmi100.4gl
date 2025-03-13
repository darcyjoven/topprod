# Prog. Version..: '5.30.06-13.03.25(00010)'     #
#
# Pattern name...: anmi100.4gl
# Descriptions...: 票據資金系統-單據性質維護作業
# Date & Author..: 93/12/29 By Wenni
#                : By Lynn  已用單號欄位取消
#                :          單號編號(nmydmy2)方式改為1.流水號 2.依年月
#                :          增加立即確認(nmydmy1)一欄位
# Modify.........: No.FUN-4C0098 05/01/10 By pengu 報表轉XML
# Modify.........: No.FUN-550060 05/06/01 By jachie 單據編號加大
# Modify.........: No.FUN-560150 05/06/21 By ice 編碼方法增加4.依年月日,
#                                                輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-590109 05/09/01 By elva 大陸版新增紅衝功能
# Modify.........: No.FUN-620051 06/02/22 By Mandy 單據性質(nmykind)多一選項'H.集團間調撥, I.集團調撥還款'
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-660133 06/07/03 By rainy s_xxxslip(),s_smu(),s_smv()中的參數 g_sys 改寫死系統別(ex:ANM)中的參數 g_sys 改寫死系統別(ex:ANM)
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-670060 06/07/18 By xiake 拋轉總帳 nmyglcr,nmygslp                                                
# Modify.........: No.FUN-670060 06/07/19 By Hellen 在"拋轉憑証"欄位之后增加"系統自動拋轉總帳"以及"總帳單別"兩個攔位
# Modify.........: No.FUN-670060 06/08/02 By wujie  修改直接拋總帳單別開窗
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-680088 06/08/31 By Ray 新增自動拋轉總帳第二單別
# Modify.........: No.FUN-690090 06/10/16 By huchenghao 新增欄位nmydmy6
# Modify.........: No.FUN-6A0082 06/11/07 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0079 06/12/01 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-740122 07/04/22 By chenl 修正：未選擇多帳套功能時，勾選自動拋轉總帳，會出現第二帳套錄入框。
# Modify.........: No.FUN-790050 07/07/13 By Carrier _out()轉p_query實現
# Modify.........: No.MOD-870084 08/07/08 By Sarah CALL q_m_aac()的倒數第三個參數aac03應傳'0'轉帳傳票
# Modify.........: No.FUN-8B0013 08/11/10 By jan 單據性質(nmykind)多一選項'J.交割單'
# Modify.........: No.FUN-940036 09/05/05 By jan 『系統自動拋轉總帳(nmyglcr)』 = 'N'時，自動拋轉總帳單別(nmyglsp) 可輸入可不輸入
# Modify.........: No.TQC-950022 09/05/06 By xiaofeizhu 當資料有效碼(nmyacti)='N'時，不可刪除該筆資料
# Modify.........: No.MOD-950047 09/05/07 By lilingyu AFTER INPUT的訊息有錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-970118 09/08/15 By hongmei nmygslp,nmygslp1加入對nmz52判斷時的控管 
# Modify.........: No.MOD-980117 09/08/18 By Sarah nmydmy1,nmydmy3,nmyglcr,nmygslp四個欄位的卡關重新調整
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-A10109 10/02/10 By TSD.zeak 取消編碼方式，單據性質改成動態combobox
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A70008 10/07/02 By xiaofeizhu nmygslp,nmygslp1 change charge
# Modify.........: No:TQC-AB0321 10/11/30 By lixia 單別增加管控
# Modify.........: No:TQC-B30016 11/03/03 By yinhy 修正TQC-AB0321單別管控
# Modify.........: No:TQC-B60075 11/06/15 By lixiang 增加單別的控管
# Modify.........: No.FUN-B50039 11/07/07 By fengrui 增加自定義欄位
# Modify.........: No.TQC-C10024 11/01/05 By yinhy 資料建立者和資料建立部門無法下查詢條件
# Modify.........: No.MOD-C10210 12/02/01 By Polly 修正nmygslp/nmygslp長度的抓取，採用aza102長度為主
# Modify.........: No.MOD-C70192 12/07/19 By Elise 修正nmygslp/nmygslp1給值
# Modify.........: No:MOD-C70278 12/07/30 By Polly 增加控卡，該單別已存在交易時不可修改
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:MOD-CB0100 12/11/16 By Polly 刪除單據後需再重新顯示資料在畫面上

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nmy_t RECORD  LIKE nmy_file.*,
    g_nmy_o RECORD  LIKE nmy_file.*,
    g_nmyslip_f     LIKE nmy_file.nmyslip,
    g_d1            LIKE type_file.chr1000,     #FUN-680107
    g_wc,g_sql      LIKE type_file.chr1000      #No.FUN-680107 VARCHAR(100)
 
DEFINE g_forupd_sql STRING                      #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done STRING           
 
DEFINE g_chr        LIKE type_file.chr1         #No.FUN-680107 VARCHAR(1)
DEFINE g_cnt        LIKE type_file.num10        #No.FUN-680107 INTEGER
DEFINE g_row_count  LIKE type_file.num10        #No.FUN-680088
DEFINE g_curs_index LIKE type_file.num10        #No.FUN-680088
DEFINE g_abso       LIKE type_file.num10        #MOD-CB0100 add
DEFINE g_no_ask     LIKE type_file.num5         #MOD-CB0100 add
DEFINE g_i          LIKE type_file.num5         #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000      #No.FUN-680107 VARCHAR(72)
 
MAIN
DEFINE
       l_per        LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       l_za05       LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(40)
#       l_time       LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("ANM")) THEN
       EXIT PROGRAM
    END IF
    #測試使用者權限, 並設定相關參數值
 
 
    #記錄起始時間
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
    #先將顯示的值讀進來, 以便不時之需
 
    #初始相關變數並宣告一個會鎖住資料的cursor
    INITIALIZE g_nmy.* TO NULL
    INITIALIZE g_nmy_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM nmy_file WHERE nmyslip = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_cl CURSOR FROM g_forupd_sql        # LOCK CURSOR
 
    #顯示畫面
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW i100_w AT p_row,p_col
         WITH FORM "anm/42f/anmi100"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    #No.FUN-680088 --begin
    IF g_aza.aza63 <> 'Y' THEN
       CALL cl_set_comp_visible("nmygslp1",FALSE)
    END IF
    #No.FUN-680088 --end
 
   #FUN-590109  --begin
   IF g_aza.aza26 != '2' THEN
      CALL cl_set_comp_visible("nmydmy5",FALSE)
   END IF
   #FUN-590109  --end
 
    WHILE TRUE
      LET g_action_choice = ""
      CALL i100_menu()
      IF g_action_choice = "exit" THEN
         EXIT WHILE
      END IF
    END WHILE
    CLOSE WINDOW i100_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION i100_cs()
    CLEAR FORM
    CALL s_getgee('anmi100',g_lang,'nmykind') #FUN-A10109
    CONSTRUCT BY NAME g_wc ON        # 螢幕上取條件
        nmyslip,nmydesc,nmykind,nmyauno,
        #nmydmy2, #FUN-A10109
        nmydmy1,nmydmy3,nmyglcr,nmygslp,nmygslp1,nmydmy5,nmydmy6,  #FUN-590109 #No.FUN-670060 #No.FUN-680088   #NO.FUN-690090
        nmyuser,nmygrup,nmymodu,nmydate,nmyacti,
        nmyoriu,nmyorig,                         #TQC-C10024
        #FUN-B50039-add-str--
        nmyud01,nmyud02,nmyud03,nmyud04,nmyud05,
        nmyud06,nmyud07,nmyud08,nmyud09,nmyud10,
        nmyud11,nmyud12,nmyud13,nmyud14,nmyud15
        #FUN-B50039-add-end--
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    #    IF g_priv2='4' THEN        #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND nmyuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN        #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND nmygrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND nmygrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmyuser', 'nmygrup')
    #End:FUN-980030
 
 
    #組合出SQL指令
    LET g_sql="SELECT nmyslip FROM nmy_file",
         " WHERE ",g_wc CLIPPED, " ORDER BY nmyslip"
    PREPARE i100_prepare FROM g_sql        # RUNTIME 編譯
    DECLARE i100_cs        # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i100_prepare
 
    #計算筆數
    LET g_sql=
        "SELECT COUNT(*) FROM nmy_file WHERE ",g_wc CLIPPED
    PREPARE i100_recount FROM g_sql
    DECLARE i100_count CURSOR FOR i100_recount
END FUNCTION
 
FUNCTION i100_menu()
    MENU ""
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i100_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
        ON ACTION next
            CALL i100_f('N')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
        ON ACTION previous
            CALL i100_f('P')
            CALL cl_navigator_setting(g_curs_index, g_row_count)
        ON ACTION authorization    #NO:6842
            LET g_action_choice="authorization"
            IF cl_chk_act_auth() THEN
              #CALL s_smu(g_nmy.nmyslip,g_sys)  #TQC-660133 remark
               CALL s_smu(g_nmy.nmyslip,"ANM")  #TQC-660133
            END IF
           #LET g_msg = s_smu_d(g_nmy.nmyslip,g_sys) #TQC-660133 remark
            LET g_msg = s_smu_d(g_nmy.nmyslip,"ANM") #TQC-660133
            DISPLAY g_msg TO smu02_display
        ON ACTION dept_authorization     #NO:6842
            LET g_action_choice="dept_authorization"
            IF cl_chk_act_auth() THEN
              #CALL s_smv(g_nmy.nmyslip,g_sys)  #TQC-660133 remark
               CALL s_smv(g_nmy.nmyslip,"ANM")  #TQC-660133
            END IF
           #LET g_msg = s_smv_d(g_nmy.nmyslip,g_sys) #TQC-660133 remark
            LET g_msg = s_smv_d(g_nmy.nmyslip,"ANM") #TQC-660133
            DISPLAY g_msg TO smv02_display
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                CALL i100_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL i100_x()
               CALL cl_set_field_pic("","","","","",g_nmy.nmyacti)
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i100_r()
            END IF
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
               CALL i100_copy()
            END IF
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i100_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET g_msg = 'p_query "anmi100" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            CALL cl_set_field_pic("","","","","",g_nmy.nmyacti)
        ON ACTION exit
            LET g_action_choice = 'exit'
            EXIT MENU
      #No.MOD-480308
     #  ON ACTION cancel
     #      LET g_action_choice = 'exit'
     #      EXIT MENU
        ON ACTION jump
            CALL i100_f('/')
            CALL cl_navigator_setting(g_curs_index, g_row_count)       #No.FUN-680088
        ON ACTION first
            CALL i100_f('F')
            CALL cl_navigator_setting(g_curs_index, g_row_count)       #No.FUN-680088
        ON ACTION last
            CALL i100_f('L')
            CALL cl_navigator_setting(g_curs_index, g_row_count)       #No.FUN-680088
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6B0079-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
             IF cl_chk_act_auth() THEN
                IF g_nmy.nmyslip IS NOT NULL THEN
                LET g_doc.column1 = "nmyslip"
                LET g_doc.value1 = g_nmy.nmyslip
                CALL cl_doc()
              END IF
           END IF
        #No.FUN-6B0079-------add--------end----
            LET g_action_choice = "exit"
          CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i100_cs
END FUNCTION
 
FUNCTION i100_a()
    #若系統被停止使用, 則不繼續往下做
    IF s_anmshut(0) THEN RETURN END IF
 
    #螢幕處理
    MESSAGE ""
    CLEAR FORM
    CALL cl_opmsg('a')
 
    #初始變數值
    INITIALIZE g_nmy.* LIKE nmy_file.*
    LET g_nmyslip_f = NULL
    LET g_nmy_o.*=g_nmy.*
    LET g_nmy_t.*=g_nmy.*
    LET g_nmy.nmyauno='Y'
   #LET g_nmy.nmykind='3'
    #96-09-05 Modify By Lynn
    LET g_nmy.nmydmy1='N'
    #LET g_nmy.nmydmy2='1' #FUN-A10109
    LET g_nmy.nmydmy3='N'
    LET g_nmy.nmyglcr='N'                 #No.FUN-670060
    LET g_nmy.nmygslp=NULL                #No.FUN-670060
    LET g_nmy.nmygslp1=NULL               #No.FUN-680088
   
    LET g_nmy.nmydmy5='N'  #FUN-590109
    LET g_nmy.nmydmy6='N'  #NO.FUN-690090
 
   WHILE TRUE
        LET g_nmy.nmyacti ='Y'
        LET g_nmy.nmyuser = g_user
        LET g_nmy.nmyoriu = g_user #FUN-980030
        LET g_nmy.nmyorig = g_grup #FUN-980030
        LET g_nmy.nmygrup = g_grup
        LET g_nmy.nmydate = g_today
        #輸入資料
        CALL i100_i("a")
        IF INT_FLAG THEN            #若按了DEL鍵, 表示使用者放棄輸入
            LET INT_FLAG = 0
            INITIALIZE g_nmy.* TO NULL
            CALL cl_err('',9001,0)    #告訴使用者, 您按了放棄鍵
            CLEAR FORM
            EXIT WHILE                #結束
        END IF
        #將資料擺入資料庫中
        INSERT INTO nmy_file VALUES(g_nmy.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nmy.nmyslip,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","nmy_file",g_nmy.nmyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
         #FUN-A10109  ===S===
         CALL s_access_doc('a',g_nmy.nmyauno,g_nmy.nmykind,
                           g_nmy.nmyslip,'ANM',g_nmy.nmyacti)
         #FUN-A10109  ===E===
        #保存剛輸入的資料, 以備不時之需
        LET g_nmy_t.* = g_nmy.*
        SELECT nmyslip INTO g_nmy.nmyslip FROM nmy_file
            WHERE nmyslip = g_nmy.nmyslip
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i100_i(p_cmd)
   DEFINE
          p_cmd    LIKE type_file.chr1,      #判斷資料處理方式 #No.FUN-680107 VARCHAR(1)
          l_sw     LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1) #判斷重要欄位是否沒有輸入
          l_dir1   LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1) #判斷CURSOR JUMP DIRECTION
          l_n      LIKE type_file.num5       #No.FUN-680107 SMALLINT
   DEFINE l_i      LIKE type_file.num5       #No.FUN-560150 #No.FUN-680107 SMALLINT
   DEFINE g_dbs_gl STRING                    #No.FUN-670060 
   DEFINE g_plant_gl STRING                  #No.FUN-980059 
   DEFINE l_aac01  LIKE aac_file.aac01       #FUN-970118
   DEFINE l_nmy    STRING,                   #No.TQC-B60075
          l_cn     LIKE type_file.num5       #No.TQC-B60075
   DEFINE g_doc_len2   LIKE type_file.num5   #MOD-C10210 add
   DEFINE lc_doc_set   LIKE aza_file.aza41   #MOD-C10210 add
   DEFINE l_sql    STRING                    #MOD-C70278 add
   DEFINE l_len    LIKE type_file.num10      #MOD-C70278 add
 
    #96-09-05 Modify By Lynn
    INPUT BY NAME g_nmy.nmyoriu,g_nmy.nmyorig,
        g_nmy.nmyslip,g_nmy.nmydesc,g_nmy.nmykind,g_nmy.nmyauno,
        #g_nmy.nmydmy2, #FUN-A10109
        g_nmy.nmydmy1,g_nmy.nmydmy3,g_nmy.nmyglcr,g_nmy.nmygslp,g_nmy.nmygslp1,  #No.FUN-670060      #No.FUN-680088
        g_nmy.nmydmy5, #FUN-590109
        g_nmy.nmydmy6, #NO.FUN-690090
        g_nmy.nmyuser,g_nmy.nmygrup,g_nmy.nmymodu,
        g_nmy.nmydate,g_nmy.nmyacti,
        #FUN-B50039-add-str--
        g_nmy.nmyud01,g_nmy.nmyud02,g_nmy.nmyud03,
        g_nmy.nmyud04,g_nmy.nmyud05,g_nmy.nmyud06,
        g_nmy.nmyud07,g_nmy.nmyud08,g_nmy.nmyud09,
        g_nmy.nmyud10,g_nmy.nmyud11,g_nmy.nmyud12,
        g_nmy.nmyud13,g_nmy.nmyud14,g_nmy.nmyud15
        #FUN-B50039-add-end--
        WITHOUT DEFAULTS
 
    BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i100_set_entry(p_cmd)
        CALL i100_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
       #---------------------MOD-C10210------------------------start
        LET lc_doc_set = g_aza.aza102
        CASE lc_doc_set
           WHEN "1"   LET g_doc_len = 3
           WHEN "2"   LET g_doc_len = 4
           WHEN "3"   LET g_doc_len = 5
        END CASE
       ##NO.FUN-560150 --start--
       #CALL cl_set_doctype_format("nmyslip") #MOD-C10210移至445行
       ##NO.FUN-560150 --end--
       #---------------------MOD-C10210--------------------------end
        CALL cl_set_doctype_format("nmygslp")     #No.TQC-B60075
        CALL cl_set_doctype_format("nmygslp1")     #No.TQC-B60075
       #---------------------MOD-C10210------------------------start
        LET lc_doc_set = g_aza.aza41
        CASE lc_doc_set
           WHEN "1"   LET g_doc_len = 3
           WHEN "2"   LET g_doc_len = 4
           WHEN "3"   LET g_doc_len = 5
        END CASE
        CALL cl_set_doctype_format("nmyslip")
       #---------------------MOD-C10210--------------------------end
 
    AFTER FIELD nmyslip    #單別, 不可空白, 不可重複
        IF NOT cl_null(g_nmy.nmyslip) THEN
           IF p_cmd='a' OR
             (p_cmd='u' AND g_nmy.nmyslip != g_nmy_t.nmyslip) THEN
              #檢查是否重複
              SELECT count(*) INTO l_n FROM nmy_file
               WHERE nmyslip=g_nmy.nmyslip
              IF l_n > 0 THEN    #Duplicated
                 CALL cl_err(g_nmy.nmyslip,-239,0)
                 LET g_nmy.nmyslip = g_nmyslip_f
                 DISPLAY BY NAME g_nmy.nmyslip
                 NEXT FIELD nmyslip
              END IF
              #NO.FUN-560150 --start--
              #No.TQC-B30016  --Mark Begin
#TQC-AB0321--add--str--
             #SELECT aac01 FROM aac_file
             #   WHERE aac01=g_nmy.nmyslip AND aacacti = 'Y'
             #IF SQLCA.sqlcode THEN
             #   CALL cl_err3("sel","aac_file",g_nmy.nmyslip,"",SQLCA.sqlcode,"","",1)
             #   NEXT FIELD nmyslip
             #END IF
#TQC-AB0321--add--end--
              #No.TQC-B30016  --Mark End
              FOR l_i = 1 TO g_doc_len
                 IF cl_null(g_nmy.nmyslip[l_i,l_i]) THEN
                    CALL cl_err('','sub-146',0)
                    NEXT FIELD nmyslip
                 END IF
              END FOR
              #NO.FUN-560150 --end--
           END IF
        END IF
 
    AFTER FIELD nmyauno
        LET g_nmy_o.nmyauno = g_nmy.nmyauno
 
   #96-09-05 MOdify By Lynn
    #FUN-A10109 ===S===
    #AFTER FIELD nmydmy2   #編號方式
    #    LET g_nmy_o.nmydmy2 = g_nmy.nmydmy2
    #FUN-A10109 ===E===
 
    BEFORE FIELD nmydmy3   #編號方式
        CALL i100_set_entry(p_cmd)  #FUN-590109
       #str MOD-980117 mark
       #IF g_nmy.nmydmy1='Y' THEN
       #   LET g_nmy.nmydmy3='N'
       #   DISPLAY BY NAME g_nmy.nmydmy3
       #END IF
       #end MOD-980117 mark
        
    AFTER FIELD nmydmy3   #編號方式
        IF NOT cl_null(g_nmy.nmydmy3) THEN
           LET g_nmy_o.nmydmy3 = g_nmy.nmydmy3
          #str MOD-980117 mark
          #IF g_nmy.nmydmy3='Y' AND g_nmy.nmydmy1='Y' THEN
          #   CALL cl_err(g_nmy.nmydmy3,'aap-264',0)
          #   LET g_nmy.nmydmy3  = g_nmy_o.nmydmy3
          #   DISPLAY BY NAME g_nmy.nmydmy3
          #   NEXT FIELD nmydmy1
          #END IF
          #end MOD-980117 mark
          #No.+093 010427 by plum add
           IF g_nmy.nmykind='2' AND g_nmy.nmydmy3='Y' THEN
              CALL cl_err(g_nmy.nmykind,'axr-066',0)
           END IF
          #NO.+093..end
           LET g_nmy_o.nmydmy3  = g_nmy.nmydmy3
           IF g_nmy.nmydmy3='N' THEN 
              LET g_nmy.nmydmy5='N'    #FUN-590109
              LET g_nmy.nmyglcr = 'N'  #No.FUN-670060
             #LET g_nmy.nmygslp = NULL #No.FUN-670060  #MOD-980117 mark
             #LET g_nmy.nmygslp1= NULL #No.FUN-680088  #MOD-980117 mark
              CALL i100_set_no_entry(p_cmd)  #No.FUN-670060
           END IF
           DISPLAY BY NAME g_nmy.nmydmy5  #FUN-590109
        END IF
    #  CALL i100_set_no_entry(p_cmd)  #FUN-590109 #No.FUN-670060
   #str MOD-980117 add
    ON CHANGE nmydmy3
       IF g_nmy.nmydmy3 = 'N' THEN 
          LET g_nmy.nmyglcr = 'N'
         #LET g_nmy.nmygslp = NULL  #No.TQC-B60075  #MOD-C70192 mark
         #LET g_nmy.nmygslp1= NULL  #No.TQC-B60075  #MOD-C70192 mark
         #DISPLAY BY NAME g_nmy.nmyglcr,g_nmy.nmygslp,g_nmy.nmygslp1   #No.TQC-B60075 add g_nmy.nmygslp,g_nmy.nmygslp1  #MOD-C70192 mark 
          DISPLAY BY NAME g_nmy.nmyglcr  #MOD-C70192
       END IF 
   #end MOD-980117 add
 
#No.FUN-670060--start
    BEFORE FIELD nmyglcr 
        CALL  i100_set_entry(p_cmd)
 
    AFTER FIELD nmyglcr
        CALL i100_set_no_entry(p_cmd)
        IF g_nmy.nmyglcr='N' THEN
          #LET  g_nmy.nmygslp = NULL  #FUN-940036
          #LET  g_nmy.nmygslp1= NULL      #No.FUN-680088 #FUN-940036
          #LET g_nmy.nmygslp = NULL  #No.TQC-B60075    #MOD-C70192 mark
          #LET g_nmy.nmygslp1= NULL  #No.TQC-B60075    #MOD-C70192 mark
          #DISPLAY BY NAME g_nmy.nmygslp  #FUN-940036  #MOD-C70192 mark
          #DISPLAY BY NAME g_nmy.nmygslp1 #FUN-940036  #MOD-C70192 mark
        END IF 
       #No.MOD-740122--begin--
       #IF g_nmy.nmyglcr='Y' THEN 
       #   CALL cl_set_comp_required("nmygslp,nmygslp1",TRUE)      #No.FUN-680088
       #END IF 
        IF g_nmy.nmyglcr='Y' THEN
           CALL cl_set_comp_required("nmygslp",TRUE)
           IF g_aza.aza63='Y' THEN
              CALL cl_set_comp_required("nmygslp1",TRUE)
           END IF 
        #FUN-940036--begin--add--                                                                                                   
        ELSE 
           CALL cl_set_comp_required("nmygslp",FALSE)
           IF g_aza.aza63='Y' THEN
              CALL cl_set_comp_required("nmygslp1",FALSE)
           END IF
        END IF
       #No.MOD-740122--end--
 
    AFTER FIELD nmygslp
        IF NOT cl_null(g_nmy.nmygslp) THEN
           IF g_nmz.nmz52 = 'Y' THEN  #FUN-970118 add
              SELECT aac01 FROM aac_file
                 WHERE aac01=g_nmy.nmygslp AND aacacti = 'Y' 
                   AND (aac11='1' OR aac11='3') #FUN-970118 add'3'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","aac_file",g_nmy.nmygslp,"",SQLCA.sqlcode,"","",1)
                 NEXT FIELD nmygslp
              END IF
           #FUN-970118---Begin
           ELSE
              SELECT unique(aac01) INTO l_aac01 FROM aac_file                                        
               WHERE aac01=g_nmy.nmygslp AND aacacti = 'Y'                      
                 AND aac11='1'
              IF cl_null(l_aac01) THEN
                 CALL cl_err("","agl-035",0)
                 NEXT FIELD nmygslp
              END IF
           END IF  
           #FUN-970118---End  
          #---------------------MOD-C10210------------------------start
           LET lc_doc_set = g_aza.aza102
           CASE lc_doc_set
              WHEN "1"   LET g_doc_len2 = 3
              WHEN "2"   LET g_doc_len2 = 4
              WHEN "3"   LET g_doc_len2 = 5
           END CASE
          #---------------------MOD-C10210--------------------------end
           #No.TQC-B60075--add--
            LET l_nmy=g_nmy.nmygslp
            LET l_cn=l_nmy.getlength()
           #IF l_cn=g_doc_len THEN                             #MOD-C10210 mark
            IF l_cn=g_doc_len2 THEN                            #MOD-C10210 add
              #FOR l_i = 1 TO g_doc_len                        #MOD-C10210 mark
               FOR l_i = 1 TO g_doc_len2                       #MOD-C10210 add
                  IF cl_null(g_nmy.nmygslp[l_i,l_i]) THEN
                     CALL cl_err(g_nmy.nmygslp,'sub-146',0)
                     NEXT FIELD nmygslp
                  END IF
               END FOR
            ELSE
               CALL cl_err(g_nmy.nmygslp,'sub-146',0)
               NEXT FIELD nmygslp
            END IF
            #No.TQC-B60075--end-- 
        END IF
 #No.FUN-670060 --end             
              
    #No.FUN-680088 --begin
    AFTER FIELD nmygslp1
        IF NOT cl_null(g_nmy.nmygslp1) THEN
           IF g_nmz.nmz52 = 'Y' THEN  #FUN-970118 add
              SELECT aac01 FROM aac_file
                 WHERE aac01=g_nmy.nmygslp1 AND aacacti = 'Y' 
                   AND (aac11='1' OR aac11='3') #FUN-970118 add'3'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","aac_file",g_nmy.nmygslp1,"",SQLCA.sqlcode,"","",1)
                 NEXT FIELD nmygslp1
              END IF
           #FUN-970118---Begin
           ELSE
              SELECT unique(aac01) INTO l_aac01 FROM aac_file                                        
               WHERE aac01=g_nmy.nmygslp AND aacacti = 'Y'                      
                 AND aac11='1'
              IF cl_null(l_aac01) THEN
                 CALL cl_err("","agl-035",0)
                 NEXT FIELD nmygslp1
              END IF
           END IF 
           #FUN-970118---End  
           #--------MOD-C10210-------------------start
            LET lc_doc_set = g_aza.aza102
            CASE lc_doc_set
               WHEN "1"   LET g_doc_len2 = 3
               WHEN "2"   LET g_doc_len2 = 4
               WHEN "3"   LET g_doc_len2 = 5
            END CASE
           #--------MOD-C10210-------------------end
           #No.TQC-B60075--add--
            LET l_nmy=g_nmy.nmygslp1
            LET l_cn=l_nmy.getlength()
           #IF l_cn=g_doc_len THEN                      #MOD-C10210 mark
            IF l_cn=g_doc_len2 THEN                     #MOD-C10210 add
              #FOR l_i = 1 TO g_doc_len                 #MOD-C10210 mark
               FOR l_i = 1 TO g_doc_len2                #MOD-C10210 add
                  IF cl_null(g_nmy.nmygslp1[l_i,l_i]) THEN
                     CALL cl_err(g_nmy.nmygslp1,'sub-146',0)
                     NEXT FIELD nmygslp1
                  END IF
               END FOR
            ELSE
               CALL cl_err(g_nmy.nmygslp1,'sub-146',0)
               NEXT FIELD nmygslp1
            END IF
            #No.TQC-B60075--end-- 
        END IF
    #No.FUN-680088 --end
 
 #FUN-590109  --begin
    BEFORE FIELD nmykind
        CALL s_getgee('anmi100',g_lang,'nmykind') #FUN-A10109
        CALL i100_set_entry(p_cmd)  #FUN-590109
    #FUN-590109  --end
 
    AFTER FIELD nmykind

        #FUN-A10109   START  
        #IF g_nmy.nmykind NOT MATCHES '[123456789ABCDEFGHIJ]' THEN #FUN-620051 add H,I #FUN-8B0013 add J
        #   NEXT FIELD nmykind
        #END IF
        #FUN-A10109   END  
        IF NOT cl_null(g_nmy.nmykind) THEN
          #--------------------MOD-C70278---------------------------(S)
           IF p_cmd='u' AND g_nmy.nmykind != g_nmy_t.nmykind THEN
              LET l_n = 0
              LET l_len = 0
              LET l_len = length(g_nmy.nmyslip)
              CASE WHEN (g_nmy_t.nmykind = '1')
                        LET l_sql = "SELECT COUNT(*) FROM nmd_file ",
                                    " WHERE nmd01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = '2')
                        LET l_sql = "SELECT COUNT(*) FROM nmh_file ",
                                    " WHERE nmh01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = '3')
                        LET l_sql = "SELECT COUNT(*) FROM nmg_file ",
                                    " WHERE nmg00[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = '4')
                        LET l_sql = "SELECT COUNT(*) FROM nne_file ",
                                    " WHERE nne01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = '5')
                        LET l_sql = "SELECT COUNT(*) FROM nng_file ",
                                    " WHERE nng01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = '6')
                        LET l_sql = "SELECT COUNT(*) FROM nni_file ",
                                    " WHERE nni01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = '7')
                        LET l_sql = "SELECT COUNT(*) FROM nnk_file ",
                                    " WHERE nnk01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = '8')
                        LET l_sql = "SELECT COUNT(*) FROM gsb_file ",
                                    " WHERE gsb01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = '9')
                        LET l_sql = "SELECT COUNT(*) FROM gxc_file ",
                                    " WHERE gxc01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = 'A')
                        LET l_sql = "SELECT COUNT(*) FROM npl_file ",
                                    " WHERE npl01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = 'B')
                        LET l_sql = "SELECT COUNT(*) FROM npn_file ",
                                    " WHERE npn01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = 'C')
                        LET l_sql = "SELECT COUNT(*) FROM gse_file ",
                                    " WHERE gse01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = 'D')
                        LET l_sql = "SELECT COUNT(*) FROM gxi_file ",
                                    " WHERE gxi01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = 'E')
                        LET l_sql = "SELECT COUNT(*) FROM gxk_file ",
                                    " WHERE gxk01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = 'F')
                        LET l_sql = "SELECT COUNT(*) FROM gsh_file ",
                                    " WHERE gsh01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = 'G')
                        LET l_sql = "SELECT COUNT(*) FROM gxf_file ",
                                    " WHERE gxf01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = 'H')
                        LET l_sql = "SELECT COUNT(*) FROM nnv_file ",
                                    " WHERE nnv01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = 'I')
                        LET l_sql = "SELECT COUNT(*) FROM nnw_file ",
                                    " WHERE nnw01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
                   WHEN (g_nmy_t.nmykind = 'J')
                        LET l_sql = "SELECT COUNT(*) FROM gxe_file ",
                                    " WHERE gxe01[1,",l_len,"] = '",g_nmy.nmyslip,"'"
              END CASE
              PREPARE i100_nmy_pre FROM l_sql
              DECLARE i100_nmy_cur CURSOR FOR i100_nmy_pre
              OPEN i100_nmy_cur
              FETCH i100_nmy_cur INTO l_n
              IF l_n > 0 THEN
                 CALL cl_err("",'aap-171',0)
                 LET g_nmy.nmykind = g_nmy_t.nmykind
                 DISPLAY BY NAME g_nmy.nmykind
                 NEXT FIELD nmykind
              END IF
           END IF
          #--------------------MOD-C70278---------------------------(E)
           IF p_cmd='a' OR
             (p_cmd='u' AND g_nmy.nmykind != g_nmy_t.nmykind) THEN
              CALL i100_kind('i')
              IF NOT cl_null(g_errno) THEN    #有誤
                 CALL cl_err(g_nmy.nmykind,g_errno,0)
                 LET g_nmy.nmykind = g_nmy_o.nmykind
                 DISPLAY BY NAME g_nmy.nmykind
                 NEXT FIELD nmykind
              END IF
           END IF
        END IF
        LET g_nmy_o.nmykind = g_nmy.nmykind
        #FUN-590109  --begin
        IF g_nmy.nmykind NOT MATCHES '[AB3]' THEN LET g_nmy.nmydmy5='N' END IF
        DISPLAY BY NAME g_nmy.nmydmy5
        CALL i100_set_no_entry(p_cmd)
        #FUN-590109  --end
        
        #FUN-690090  --begin                                                    
        IF g_nmy.nmykind NOT MATCHES '[HI]' THEN LET g_nmy.nmydmy6='N' END IF  
        DISPLAY BY NAME g_nmy.nmydmy6                                           
        CALL i100_set_no_entry(p_cmd)  
        CALL i100_set_entry(p_cmd)
        #FUN-690090  --end 
 
   #96-09-05 MOdify By Lynn
    AFTER FIELD nmydmy1   #立即確認
        LET g_nmy_o.nmydmy1 = g_nmy.nmydmy1
        
      #FUN-B50039-add-str--
      AFTER FIELD nmyud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmyud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--
      
    AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
        IF g_nmy.nmyauno IS NULL THEN   #自動編號否
            DISPLAY BY NAME g_nmy.nmyauno
            LET l_sw = 'Y'
        END IF
        IF g_nmy.nmykind IS NULL THEN
           DISPLAY BY NAME g_nmy.nmykind
           LET l_sw = 'Y'
        END IF
       #str MOD-980117 mark
       #IF g_nmy.nmydmy3='Y' AND g_nmy.nmydmy1='Y' THEN
       #   DISPLAY BY NAME g_nmy.nmydmy1
       #   LET l_sw = 'Y'
       #END IF
       #end MOD-980117 mark
        IF l_sw = 'Y' THEN
           LET l_sw = 'N'
#          CALL cl_err('','9033',0)    #MOD-950047
#          NEXT FIELD nmyslip          #MOD-950047
#MOD-950047 --begin
          #str MOD-980117 mark
          #IF g_nmy.nmydmy3='Y' AND g_nmy.nmydmy1='Y' THEN
          #   CALL cl_err(g_nmy.nmydmy3,'aap-264',0)
          #   LET g_nmy.nmydmy3  = g_nmy_o.nmydmy3
          #   DISPLAY BY NAME g_nmy.nmydmy3
          #   NEXT FIELD nmydmy1
          #ELSE
          #   CALL cl_err('','9033',0)
          #   NEXT FIELD nmyslip
          #END IF
          #end MOD-980117 mark
#MOD-950047 --end
        END IF
 
    #MOD-650015 --start 
    #ON ACTION CONTROLO    # 沿用所有欄位
    #    IF INFIELD(nmyslip) THEN
    #        LET g_nmy.* = g_nmy_t.*
    #        DISPLAY BY NAME
    #            g_nmy.nmyslip,g_nmy.nmydesc,g_nmy.nmyauno,  #g_nmy.nmymxno,
    #            g_nmy.nmydmy2,g_nmy.nmydmy3,g_nmy.nmydmy5,g_nmy.nmykind,g_nmy.nmydmy1,  #FUN-590109
    #            g_nmy.nmyuser,g_nmy.nmygrup,g_nmy.nmydate, g_nmy.nmyacti
 
    #    END IF
    #MOD-650015 --end
 
#No.FUN-670060 --start--
    ON ACTION controlp
       CASE
          WHEN INFIELD(nmygslp)
               # 得出總帳 database name                                                                                        
               # g_nmz.nmz02p -> g_plant_new -> s_getdbs() -> g_dbs_new -->                                                    
                LET g_plant_new= g_nmz.nmz02p                                                                                  
                CALL s_getdbs()                                                                                                
                LET g_dbs_gl=g_dbs_new CLIPPED 
                LET g_plant_gl= g_nmz.nmz02p    #No.FUN-980059                                                                              
               IF g_aaz.aaz70 MATCHES '[yY]' THEN
                 #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_nmy.nmygslp,'1',' ',g_user,'AGL')   #MOD-870084 mark
               #  CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_nmy.nmygslp,'1','0',g_user,'AGL')   #MOD-870084   #No.FUN-980059
                  CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_nmy.nmygslp,'1','0',g_user,'AGL')   #MOD-870084 #No.FUN-980059
                  RETURNING g_nmy.nmygslp
                ELSE
                 #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_nmy.nmygslp,'1',' ',' ','AGL')   #MOD-870084 mark
               #  CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_nmy.nmygslp,'1','0',' ','AGL')   #MOD-870084       #No.FUN-980059
                  CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_nmy.nmygslp,'1','0',' ','AGL')   #MOD-870084     #No.FUN-980059
                  RETURNING g_nmy.nmygslp
                END IF
                DISPLAY BY NAME g_nmy.nmygslp
                NEXT FIELD nmygslp
          #No.FUN-680088 --begin
          WHEN INFIELD(nmygslp1)
               # 得出總帳 database name                                                                                        
               # g_nmz.nmz02p -> g_plant_new -> s_getdbs() -> g_dbs_new -->                                                    
                LET g_plant_new= g_nmz.nmz02p                                                                                  
                CALL s_getdbs()                                                                                                
                LET g_dbs_gl=g_dbs_new CLIPPED 
               IF g_aaz.aaz70 MATCHES '[yY]' THEN
                 #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_nmy.nmygslp1,'1',' ',g_user,'AGL')   #MOD-870084 mark
               #  CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_nmy.nmygslp1,'1','0',g_user,'AGL')   #MOD-870084    #No.FUN-980059
                  CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_nmy.nmygslp1,'1','0',g_user,'AGL')   #MOD-870084  #No.FUN-980059
                  RETURNING g_nmy.nmygslp1
                ELSE
                 #CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_nmy.nmygslp1,'1',' ',' ','AGL')   #MOD-870084 mark
              #   CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_nmy.nmygslp1,'1','0',' ','AGL')   #MOD-870084       #No.FUN-980059
                  CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_nmy.nmygslp1,'1','0',' ','AGL')   #MOD-870084     #No.FUN-980059
                  RETURNING g_nmy.nmygslp1
                END IF
                DISPLAY BY NAME g_nmy.nmygslp1
                NEXT FIELD nmygslp1
           #No.FUN-680088 --end
          OTHERWISE EXIT CASE
       END CASE
#No.FUN-670060 --end--
 
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
 
FUNCTION i100_kind(p_cmd)  # 單據性質
    DEFINE
           p_cmd LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1)
           l_str LIKE type_file.chr1000,   #No.FUN-680107 VARCHAR(41)
           l_cnt LIKE type_file.num5       #No.FUN-680107 SMALLINT
     LET g_errno = 'anm-084'
     IF g_nmy.nmykind MATCHES '[123456789ABCDEFGHIJ]' THEN #FUN-620051 add H,I #FUN-8B0013 add J
        LET g_errno = ' '
     END IF
END FUNCTION
 
FUNCTION i100_q()
 
    #No.FUN-680088 --begin
    LET g_row_count = 0                                                                                                              
    LET g_curs_index = 0                                                                                                             
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    #No.FUN-680088 --end
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL i100_cs()        # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
 
    OPEN i100_count
    FETCH i100_count INTO g_cnt
    DISPLAY g_cnt TO FORMONLY.cnt
 
    OPEN i100_cs        # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmy.nmyslip,SQLCA.sqlcode,0)
        INITIALIZE g_nmy.* TO NULL
    ELSE
        #No.FUN-680088 --begin
        OPEN i100_count
        FETCH i100_count INTO g_row_count
        #No.FUN-680088 --end
        CALL i100_f('F')    # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i100_f(p_flag)
DEFINE
    p_flag LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
   #l_abso LIKE type_file.num10         #No.FUN-680107 INTEGER #MOD-CB0100 mar
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i100_cs INTO g_nmy.nmyslip
        WHEN 'P' FETCH PREVIOUS i100_cs INTO g_nmy.nmyslip
        WHEN 'F' FETCH FIRST    i100_cs INTO g_nmy.nmyslip
        WHEN 'L' FETCH LAST     i100_cs INTO g_nmy.nmyslip
        WHEN '/'
             IF (NOT g_no_ask) THEN                         #MOD-CB0100 add
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_abso        #MOD-CB0100 l_abso mod g_abso
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
             END IF                                             #MOD-CB0100 add
             FETCH ABSOLUTE g_abso i100_cs INTO g_nmy.nmyslip   #MOD-CB0100 l_abso mod g_abso
             LET g_no_ask = FALSE                               #MOD-CB0100 add
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmy.nmyslip,SQLCA.sqlcode,0)
        INITIALIZE g_nmy.* TO NULL          #No.FUN-6B0079 add
        RETURN
    ELSE
    #No.FUN-680088 --begin
      CASE p_flag                                                                                                                   
         WHEN 'F' LET g_curs_index = 1                                                                                              
         WHEN 'P' LET g_curs_index = g_curs_index - 1                                                                               
         WHEN 'N' LET g_curs_index = g_curs_index + 1                                                                               
         WHEN 'L' LET g_curs_index = g_row_count                                                                                    
         WHEN '/' LET g_curs_index = g_abso                    #MOD-CB0100 l_abso mod g_abso
      END CASE                                                                                                                      
                                                                                                                                    
      CALL cl_navigator_setting( g_curs_index, g_row_count )
    #No.FUN-680088 --end
    END IF
    # 重讀DB,因TEMP有不被更新特性
    SELECT * INTO g_nmy.* FROM nmy_file
        WHERE nmyslip = g_nmy.nmyslip
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_nmy.nmyslip,SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("sel","nmy_file",g_nmy.nmyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
        INITIALIZE g_nmy.* TO NULL          #No.FUN-6B0079 add
    ELSE
#       LET g_data_owner = g_nmy.nmyuser
#       LET g_data_group = g_nmy.nmygrup
        CALL i100_show()
    END IF
END FUNCTION
 
FUNCTION i100_show()
    LET g_nmy_t.* = g_nmy.*
    #96-09-05 Modify By Lynn
    DISPLAY BY NAME g_nmy.nmyoriu,g_nmy.nmyorig,
        g_nmy.nmyslip,g_nmy.nmydesc,g_nmy.nmyauno, #g_nmy.nmymxno,
        #g_nmy.nmydmy2, #FUN-A10109
        g_nmy.nmydmy3,g_nmy.nmyglcr,g_nmy.nmygslp,g_nmy.nmygslp1,   #FUN-670060      #No.FUN-680088
        g_nmy.nmydmy5,g_nmy.nmykind,g_nmy.nmydmy1, #FUN-590109
        g_nmy.nmyuser,g_nmy.nmygrup,g_nmy.nmymodu,g_nmy.nmydate,
        g_nmy.nmyacti,
        g_nmy.nmydmy6,   #NO.FUN-690090
        #FUN-B50039-add-str--
        g_nmy.nmyud01,g_nmy.nmyud02,g_nmy.nmyud03,
        g_nmy.nmyud04,g_nmy.nmyud05,g_nmy.nmyud06,
        g_nmy.nmyud07,g_nmy.nmyud08,g_nmy.nmyud09,
        g_nmy.nmyud10,g_nmy.nmyud11,g_nmy.nmyud12,
        g_nmy.nmyud13,g_nmy.nmyud14,g_nmy.nmyud15
        #FUN-B50039-add-end--
   #LET g_msg = s_smu_d(g_nmy.nmyslip,g_sys)  #TQC-660133 remark
    LET g_msg = s_smu_d(g_nmy.nmyslip,"ANM")  #TQC-660133 
    DISPLAY g_msg TO smu02_display
   #LET g_msg = s_smv_d(g_nmy.nmyslip,g_sys)  #NO:6842 #TQC-660133 remark
    LET g_msg = s_smv_d(g_nmy.nmyslip,"ANM")           #TQC-660133
    DISPLAY g_msg TO smv02_display
    CALL cl_set_field_pic("","","","","",g_nmy.nmyacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i100_u()
    #檢查系統是否開放使用
    IF s_anmshut(0) THEN RETURN END IF
    #檢查是否有查詢資料
    IF g_nmy.nmyslip IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_nmy.nmyacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_nmy.nmyslip,9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_nmyslip_f = g_nmy.nmyslip
    BEGIN WORK
    OPEN i100_cl USING g_nmy.nmyslip
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_nmy.*    # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmy.nmyslip,SQLCA.sqlcode,0)
        RETURN
    END IF
 
    LET g_nmy.nmymodu=g_user        #修改者
    LET g_nmy.nmydate = g_today        #修改日期
    CALL i100_show()                # 顯示最新資料
 
    WHILE TRUE
        LET g_nmy_o.* = g_nmy.*
        #進行修改
        CALL i100_i("u")
        #使用者放棄修改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_nmy.*=g_nmy_t.*
            CALL i100_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE nmy_file SET nmy_file.* = g_nmy.*    # 更新DB
            WHERE nmyslip = g_nmyslip_f
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nmy.nmyslip,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("upd","nmy_file",g_nmy.nmyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        #FUN-A10109  ===S===
        CALL s_access_doc('u',g_nmy.nmyauno,g_nmy.nmykind,
                          g_nmyslip_f,'ANM',g_nmy.nmyacti)
        #FUN-A10109 ===E===
        EXIT WHILE
    END WHILE
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i100_x()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
    IF s_anmshut(0) THEN RETURN END IF
    IF g_nmy.nmyslip IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    #系統保留字, 不可取消
    IF (g_nmy.nmyslip='PLP' OR g_nmy.nmyslip='PLM') THEN
        CALL cl_err(g_nmy.nmyslip,'mfg0074',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i100_cl USING g_nmy.nmyslip
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_nmy.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nmy.nmyslip,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i100_show()
    IF cl_exp(15,21,g_nmy.nmyacti) THEN
        LET g_chr=g_nmy.nmyacti
        IF g_nmy.nmyacti='Y'
           THEN LET g_nmy.nmyacti='N'
           ELSE LET g_nmy.nmyacti='Y'
        END IF
        UPDATE nmy_file
            SET nmyacti=g_nmy.nmyacti,
               nmymodu=g_user, nmydate=g_today
            WHERE nmyslip = g_nmy.nmyslip
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_nmy.nmyslip,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("upd","nmy_file",g_nmy.nmyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            LET g_nmy.nmyacti=g_chr
        END IF
        #FUN-A10109  ===S===
        CALL s_access_doc('u',g_nmy.nmyauno,g_nmy.nmykind,
                          g_nmy.nmyslip,'ANM',g_nmy.nmyacti)
        #FUN-A10109 ===E===
        DISPLAY BY NAME g_nmy.nmyacti
    END IF
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i100_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
    IF s_anmshut(0) THEN RETURN END IF
    IF g_nmy.nmyslip IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_nmy.nmyacti = 'N' THEN CALL cl_err('','abm-950',0) RETURN END IF             #TQC-950022
    BEGIN WORK
    OPEN i100_cl USING g_nmy.nmyslip
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_nmy.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nmy.nmyslip,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i100_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL            #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "nmyslip"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_nmy.nmyslip      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
        DELETE FROM nmy_file WHERE nmyslip = g_nmy.nmyslip
       #--------------------MOD-CB0100-------------------------(S)
       #--MOD-CB0100--mark
       #IF SQLCA.SQLERRD[3]=0 THEN
       #  #CALL cl_err(g_nmy.nmyslip,SQLCA.sqlcode,0)   #No.FUN-660148
       #   CALL cl_err3("del","nmy_file",g_nmy.nmyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
       #ELSE CLEAR FORM
       #END IF
       ##FUN-A10109  ===S===
       #CALL s_access_doc('r','','',g_nmy.nmyslip,'ANM','')
       ##FUN-A10109  ===E===
       #--MOD-CB0100--mark
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","nmy_file",g_nmy.nmyslip,"",SQLCA.sqlcode,"","",1)
        ELSE
           CALL s_access_doc('r','','',g_nmy.nmyslip,'ANM','')
           CLEAR FORM
           OPEN i100_count
           IF STATUS THEN
              CLOSE i100_cl
              CLOSE i100_count
              COMMIT WORK
              RETURN
           END IF
           FETCH i100_count INTO g_row_count
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i100_cl
              CLOSE i100_count
              COMMIT WORK
              RETURN
           END IF
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i100_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_abso = g_row_count
              CALL i100_f('L')
           ELSE
              LET g_abso = g_curs_index
              LET g_no_ask = TRUE
              CALL i100_f('/')
           END IF
        END IF
       #--------------------MOD-CB0100-------------------------(E)
    END IF
    #DELETE FROM smv_file WHERE smv01=g_nmy.nmyslip AND smv03=g_sys  #NO:6842    #TQC-670008 remark
    DELETE FROM smv_file WHERE smv01=g_nmy.nmyslip AND upper(smv03)='ANM'        #TQC-670008 
    IF SQLCA.SQLCODE THEN
#        CALL cl_err('smv_file',SQLCA.sqlcode,0)   #No.FUN-660148
         CALL cl_err3("del","smv_file",g_nmy.nmyslip,g_sys,SQLCA.sqlcode,"","smv_file",1)  #No.FUN-660148
    END IF
    DELETE FROM smu_file WHERE smu01=g_nmy.nmyslip AND smu03=g_sys  #NO:6842  #TQC-670008 remark
    DELETE FROM smu_file WHERE smu01=g_nmy.nmyslip AND upper(smu03)='ANM'      #TQC-670008
    IF SQLCA.SQLCODE THEN
#        CALL cl_err('smu_file',SQLCA.sqlcode,0)   #No.FUN-660148
         CALL cl_err3("del","smu_file",g_nmy.nmyslip,g_sys,SQLCA.sqlcode,"","smu_file",1)  #No.FUN-660148
    END IF
    CLOSE i100_cl
    COMMIT WORK
    INITIALIZE g_nmy.* TO NULL
END FUNCTION
 
FUNCTION i100_copy()
DEFINE
    l_n        LIKE type_file.num5,    #No.FUN-680107 SMALLINT
    l_newno    LIKE nmy_file.nmyslip,
    l_oldno    LIKE nmy_file.nmyslip
    DEFINE l_i LIKE type_file.num5     #No.FUN-560150 #No.FUN-680107 SMALLINT
 
    IF s_anmshut(0) THEN RETURN END IF
    IF g_nmy.nmyslip IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   #DISPLAY "" AT 1,1
 
    LET g_before_input_done = FALSE
    CALL i100_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM nmyslip
 
        #NO.FUN-560150 --start--
        BEFORE FIELD nmyslip
           CALL cl_set_doctype_format("nmyslip")
        #NO.FUN-560150 --end--
        AFTER FIELD nmyslip
            IF NOT cl_null(l_newno) THEN
               SELECT count(*) INTO g_cnt FROM nmy_file
                WHERE nmyslip = l_newno
               IF g_cnt > 0 THEN
                  CALL cl_err(l_newno,-239,0)
                  NEXT FIELD nmyslip
               END IF
               #NO.FUN-560150 --start--
               FOR l_i = 1 TO g_doc_len
                  IF cl_null(l_newno[l_i,l_i]) THEN
                     CALL cl_err('','sub-146',0)
                     NEXT FIELD nmyslip
                  END IF
               END FOR
               #NO.FUN-560150 --end--
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
        DISPLAY BY NAME g_nmy.nmyslip
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM nmy_file
        WHERE nmyslip = g_nmy.nmyslip
        INTO TEMP x
    UPDATE x
        SET x.nmyslip=l_newno,    #資料鍵值
            x.nmyuser=g_user,   #資料所有者
            x.nmygrup=g_grup,   #資料所有者所屬群
            x.nmymodu=NULL,     #資料修改日期
            x.nmydate=g_today,  #資料建立日期
            x.nmyacti='Y'       #有效資料
    INSERT INTO nmy_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_nmy.nmyslip,SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("ins","nmy_file",g_nmy.nmyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_nmy.nmyslip
        SELECT nmy_file.* INTO g_nmy.* FROM nmy_file
            WHERE nmyslip =  l_newno
        CALL  i100_u()
        CALL i100_show()
        #FUN-C80046---begin
        #LET g_nmy.nmyslip = l_oldno
        #SELECT nmy_file.* INTO g_nmy.* FROM nmy_file
        #    WHERE nmyslip = g_nmy.nmyslip
        #CALL i100_show()
        #FUN-C80046---end
        #FUN-A10109  ===S===
        CALL s_access_doc('a',g_nmy.nmyauno,g_nmy.nmykind,
                          g_nmy.nmyslip,'ANM',g_nmy.nmyacti)
        #FUN-A10109  ===E===
    END IF
    DISPLAY BY NAME g_nmy.nmyslip
END FUNCTION
 
#No.FUN-790050  --Begin
#FUNCTION i100_out()
#DEFINE
#    sr     RECORD LIKE nmy_file.*,
#    l_i    LIKE type_file.num5,    #No.FUN-680107 SMALLINT
#    l_name LIKE type_file.chr20,   # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#    l_chr  LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
#
#    IF cl_null(g_wc) THEN LET g_wc=" nmyslip='",g_nmy.nmyslip,"'" END IF
#    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#
#    CALL cl_wait()
#    CALL cl_outnam('anmi100') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM nmy_file ",
#        " WHERE ",g_wc CLIPPED
#    PREPARE i100_p1 FROM g_sql        # RUNTIME 編譯
#    DECLARE i100_co CURSOR FOR i100_p1
#
#    START REPORT i100_rep TO l_name
#
#    FOREACH i100_co INTO sr.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#            EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i100_rep(sr.*)
#    END FOREACH
#
#    FINISH REPORT i100_rep
#
#    CLOSE i100_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i100_rep(sr)
#DEFINE
#    l_last_sw      LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
#    sr             RECORD LIKE nmy_file.*,
#    l_i,l_j,l_skip LIKE type_file.num5,       #No.FUN-680107 SMALLINT
#    l_chr          LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)
#
#    OUTPUT
#        TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
#
#    ORDER BY sr.nmyslip
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#                  g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED    #No.FUN-670060 #No.FUN-690090
#            PRINT g_dash1
#            LET l_last_sw = 'y'
#
#        ON EVERY ROW
#         #  IF sr.nmyacti = 'N' THEN PRINT '*'; END IF #No.FUN-690090
#            PRINT COLUMN g_c[31],sr.nmyslip,
#                  COLUMN g_c[32],sr.nmydesc,
#                  COLUMN g_c[33],sr.nmyauno,
#                  COLUMN g_c[34],sr.nmydmy2,
#                  COLUMN g_c[35],sr.nmykind,
#                  COLUMN g_c[36],sr.nmydmy1,
#                  COLUMN g_c[37],sr.nmydmy3,
#                  COLUMN g_c[38],sr.nmyglcr,    #No.FUN-670060
#                  COLUMN g_c[39],sr.nmygslp,    #No.FUN-670060
#                  COLUMN g_c[40],sr.nmygslp1,   #No.FUN-670060
#                  COLUMN g_c[41],sr.nmydmy6,    #No.FUN-690090  
#                  COLUMN g_c[42],sr.nmyacti     #No.FUN-690090                                  
#       ON LAST ROW
#            IF g_zz05 = 'Y' AND g_wc != ' 1=1' THEN
#                CALL cl_wcchp(g_wc,'nmyslip,nmydesc') RETURNING g_wc
#                PRINT g_dash[1,g_len]
#                PRINT g_x[8] CLIPPED;
#                LET l_i=(100/g_len)+0.9
#                LET l_skip=1
#                FOR l_j=1 TO l_i
#                    LET g_i=(l_j*g_len)-10
#                    IF g_i > 100 THEN LET g_i=100 END IF
#                    IF g_wc[l_skip,g_i] > ' ' THEN
#                        PRINT COLUMN 10,g_wc[l_skip,g_i]
#                    END IF
#                    LET l_skip=g_i+1
#                END FOR
#            END IF
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_last_sw = 'y'
#
#        PAGE TRAILER
#            IF l_last_sw = 'n' THEN           #No.FUN-550060
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-790050  --Begin
 
FUNCTION i100_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nmyslip",TRUE)
   END IF
   CALL cl_set_comp_entry("nmydmy5",TRUE)     #FUN-590109
#  CALL cl_set_comp_entry("nmydmy6",TRUE)     #NO.FUN-690090
#NO.FUN-690090  --begin                                                         
   IF g_nmy.nmykind  MATCHES '[HI]' THEN                                     
      CALL cl_set_comp_entry("nmydmy6",TRUE)                                   
   END IF                                                                       
#NO.FUN-690090  --end   
#FUN-670060--start
   IF INFIELD(nmydmy3) OR (NOT g_before_input_done)  THEN 
      CALL cl_set_comp_entry("nmyglcr",TRUE)
      CALL cl_set_comp_entry("nmygslp,nmygslp1",TRUE)      #No.FUN-680088
   END IF 
   IF INFIELD(nmyglcr) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nmygslp,nmygslp1",TRUE)      #No.FUN-680088
   END IF 
#FUN-670060 
 
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd='u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nmyslip",FALSE)
   END IF
   #FUN-590109  --begin
   IF g_nmy.nmydmy3 ='N' OR g_nmy.nmykind NOT MATCHES '[AB3]' THEN
      CALL cl_set_comp_entry("nmydmy5",FALSE)
   END IF
   #FUN-590109  --end
 
#No.FUN-670060 --start--
 IF INFIELD(nmydmy3) OR (NOT g_before_input_done) THEN
    IF g_nmy.nmydmy3 = "N" THEN
       CALL cl_set_comp_entry("nmyglcr",FALSE)
      #CALL cl_set_comp_entry("nmygslp,nmygslp1",FALSE)  #No.FUN-680088  #MOD-980117 mark
       CALL cl_set_comp_required("nmygslp,nmygslp1",FALSE)               #TQC-A70008 Add 
    END IF
 END IF
 #FUN-940036--begin--mark--
 #IF INFIELD(nmyglcr) OR (NOT g_before_input_done) THEN
 #   IF g_nmy.nmyglcr = "N" THEN
 #      CALL cl_set_comp_entry("nmygslp,nmygslp1",FALSE)      #No.FUN-680088
 #   END IF
 #END IF
 #FUN-940036--end--mark--
#No.FUN-670060 --end--
 
#NO.FUN-690090  --begin                                                         
   IF g_nmy.nmykind NOT MATCHES '[HI]' THEN              
      CALL cl_set_comp_entry("nmydmy6",FALSE)                                   
   END IF                                                                       
#NO.FUN-690090  --end 
 
END FUNCTION
 
