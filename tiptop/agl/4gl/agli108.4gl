# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: agli108.4gl
# Descriptions...: 傳票單別維護作業
# Date & Author..: 92/02/18 BY  MAY
# Modify.........: 修改BUG - 未區分帳別 (aac00) by Thmoas
#                  By Melody    aac00 改為 no-use
#                  By Melody    1.傳票性質 '8.底稿' 拿掉
#                               2.修改時check有無傳票資料,若有則不可修改重要欄位
# Modify.........: No.MOD-480016 04/08/03 By Nicola
#                                1.CONSTRUCT不能跳到簽核否的欄位
#                                2.有些單別無法進入作"U"更改且又無訊息,但修改人會被update掉
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4A0051 04/10/07 By Nicola 性質為現收/現支時,科目檢查要為貨幣性科目且不為統制帳戶且不為結轉科目
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: No.MOD-510107 05/01/17 By Kitty  連續刪除會出現-400的錯誤
# Modify.........: No.FUN-510007 05/02/16 By Nicola 報表架構修改
# Modify.........: No.MOD-520076 05/04/12 By Nicola 檢查單別一定要三碼，不可含null
# Modify.........: No.MOD-560012 05/06/08 By ching  fix 帳別切換
# Modify ........: No.FUN-560060 05/06/13 By wujie 單據編號加大
# Modify.........: No.FUN-560095 05/06/18 By ching  2.0功能修改
# Modify.........: No.FUN-560150 05/06/21 By ice 編碼方法增加4.依年月日,
#                                                輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-570024 05/07/29 By elva 新增審計調整內容
# Modify.........: No.FUN-580127 05/08/25 By Smapmin "應簽核" & "自動確認" 應為互斥選項
# Modify.........: No.TQC-5B0045 05/11/07 By Smapmin 新增單別時,錯誤訊息顯示有誤
# Modify.........: Mo:FUN-5B0078 05/11/17 by Brendan: 當走 EasyFlow 簽核時, 簽核等級等欄位不需輸入
# Modify.........: No.FUN-640244 06/05/03 By Echo 取消"立即確認"與"應簽核"欄位為互斥的選項
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-660133 06/07/03 By rainy s_xxxslip(),s_smu(),s_smv()中的參數 g_sys 改寫死系統別(ex:AAP)中的參數 g_sys 改寫死系統別(ex:AAP)
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0040 06/11/14 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730070 07/04/03 By Carrier 會計科目加帳套-財務
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-770095 07/07/20 By Smapmin EOM為結轉預設單別,不可刪除
# Modify.........: No.MOD-780077 07/08/15 By Smapmin 拿掉切換帳別功能
# Modify.........: No.FUN-820002 07/12/20 By lala   報表轉為使用p_query
# Modify.........: No.FUN-870025 09/01/20 By jan 語法修改
# Modify.........: No.MOD-950008 09/05/04 By Sarah 當g_aac.aac01=g_aaz.aaz65時,才卡agl-184訊息
# Modify.........: No.TQC-950007 09/05/05 By wujie   無效資料不能刪除  
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/10/19 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-9B0038 09/11/05 By wujie  5.2SQL转标准语法
# Modify.........: No.FUN-A10109 10/02/10 By TSD.zeak 取消編碼方式，單據性質改成動態combobox
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-A70162 10/07/21 by sabrina 當aza26='2'時才顯示aac12
# Modify.........: No.TQC-AB0269 10/12/01 by wuxj   大陆版时acc11 应该有B选项，mark s_get_gee() 
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0123 11/12/26 by Lori add aac16多帳別共用單別選項
# Modify.........: NO.TQC-BC0016 12/01/17 By Lor  增加aac16的QBE查詢
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20526 12/02/28 By Carrier Construct oriu/orig
# Modify.........: No.MOD-C30496 12/03/12 By wangrr 當已有傳票資料時可修改aac02和aacpass
# Modify.........: No.TQC-C40255 12/04/27 By lujh  新增資料aac16欄位沒有默認值，應賦予默認值N
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C90058 12/09/25 By xuxz add aac17
# Modify.........: No.MOD-CB0182 12/11/21 By Polly 抓取傳票增加是否為有效傳票條件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_aac                 RECORD LIKE aac_file.*,
       g_aac_t               RECORD LIKE aac_file.*,
       g_aac_o               RECORD LIKE aac_file.*,
       g_aac01_t             LIKE aac_file.aac01,
       g_bookno              LIKE aaa_file.aaa01,          #No.FUN-670039
       g_wc,g_wc2,g_sql      STRING      #TQC-630166     
DEFINE g_forupd_sql          STRING      #SELECT ... FOR UPDATE SQL     
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680098  SMALLINT
DEFINE g_chr                 LIKE type_file.chr8          #No.FUN-680098  VARCHAR(8) 
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680098  INTTEGER
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose     #No.FUN-680098  SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(72)   
DEFINE g_row_count           LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE g_jump                LIKE type_file.num10         #No.FUN-680098  INTEGER
DEFINE mi_no_ask             LIKE type_file.num5          #No.FUN-680098  SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8              #No.FUN-6A0073
   DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680098  SMALLINT
   DEFINE cb              ui.ComboBox  #FUN-570024
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_bookno = ARG_VAL(1)
 
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SElECT aaz64 INTO g_bookno  FROM aaz_file
   END IF
 
   INITIALIZE g_aac.* TO NULL
   INITIALIZE g_aac_t.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM aac_file      ",
                      " WHERE aac01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i108_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET p_row = 4 LET p_col = 10
   OPEN WINDOW i108_w AT p_row,p_col
     WITH FORM "agl/42f/agli108"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   #FUN-570024  --begin
   IF g_aza.aza26 = '2' THEN
      CALL cl_getmsg('ggl-001',g_lang) RETURNING g_msg
      LET cb = ui.ComboBox.forName("aac11")
      CALL cb.addItem('B',g_msg )
      CALL cl_set_comp_visible('aac12',TRUE)      #MOD-A70162 add
   ELSE                                           #MOD-A70162 add
      CALL cl_set_comp_visible('aac12',FALSE)     #MOD-A70162 add
   END IF
   #FUN-570024  --end
   CALL cl_ui_init()
 
   LET g_action_choice=""
 
   CALL i108_menu()
 
   CLOSE WINDOW i108_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION i108_cs()
 
   CLEAR FORM
 # CALL s_getgee('agli108',g_lang,'aac11') #FUN-A10109  #TQC-AB0269  
   INITIALIZE g_aac.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON aac01,aac02,aac11,aac03,aac04,aac17,aacauno,#FUN-C90058 add aac17
                             #aac06, #FUN-A10109
                              aac12,aac13,aac09,aac08,aacdays,aacprit,aacatsg,      #No.MOD-480016
                             aacsign,aacpass,aacuser,aacgrup,aacoriu,aacorig,aacmodu,aacdate,  #No.TQC-C20526
                             aacacti,aac16                                          #TQC-BC0016 add aac16
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aac04) #會計科目
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_aac.aac04
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aac04
               CALL i108_aac04('d')
               NEXT FIELD aac04
            WHEN INFIELD(aacsign)
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_aze"
               LET g_qryparam.default1 = g_aac.aacsign
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aacsign
               NEXT FIELD aacsign
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
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND aacuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND aacgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND aacgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aacuser', 'aacgrup')
   #End:FUN-980030
 
 
   LET g_sql = "SELECT aac01 FROM aac_file ", # 組合出 SQL 指令
               " WHERE ",g_wc CLIPPED,
               " ORDER BY aac01"
   PREPARE i108_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i108_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i108_prepare
 
   LET g_sql = "SELECT COUNT(*) FROM aac_file WHERE ",g_wc CLIPPED
   PREPARE i108_precount FROM g_sql
   DECLARE i108_count CURSOR FOR i108_precount
 
END FUNCTION
 
FUNCTION i108_menu()
DEFINE l_cmd  LIKE type_file.chr1000
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION insert
          LET g_action_choice="insert"
          IF cl_chk_act_auth() THEN
             CALL i108_a()
          END IF
 
#     ON ACTION 使用者設限
      ON ACTION authorization
         LET g_action_choice="authorization"
         IF cl_chk_act_auth() THEN
           #CALL s_smu(g_aac.aac01,g_sys)  #TQC-660133 remark
            CALL s_smu(g_aac.aac01,"AGL")  #TQC-660133
         END IF
        #LET g_msg = s_smu_d(g_aac.aac01,g_sys) #NO:6842  #TQC-660133 remark
         LET g_msg = s_smu_d(g_aac.aac01,"AGL")           #TQC-660133
         DISPLAY g_msg TO smu02_display
 
#     ON ACTION 部門設限                  #NO:6842
      ON ACTION dept_authorization                  #NO:6842
         LET g_action_choice="dept_authorization"
         IF cl_chk_act_auth() THEN
           #CALL s_smv(g_aac.aac01,g_sys) #TQC-660133 remark
            CALL s_smv(g_aac.aac01,"AGL") #TQC-660133
         END IF
        #LET g_msg = s_smv_d(g_aac.aac01,g_sys) #TQC-660133 remark
         LET g_msg = s_smv_d(g_aac.aac01,"AGL") #TQC-660133
         DISPLAY g_msg TO smv02_display
 
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i108_q()
         END IF

      #FUN-BB0123--Begin--
      ON ACTION i108_aac16
         LET g_action_choice="i108_aac16"
         IF cl_chk_act_auth() THEN
            CALL i108_aac16()
         END IF
      #FUN-BB0123---End---
 
      ON ACTION next
         CALL i108_fetch('N')
 
      ON ACTION previous
         CALL i108_fetch('P')
 
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i108_u()
         END IF
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL i108_x()
            CALL cl_set_field_pic("","","","","",g_aac.aacacti)
         END IF
 
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL i108_r()
         END IF
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         IF cl_chk_act_auth() THEN
            CALL i108_copy()
         END IF
 
      ON ACTION output
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
            CALL i108_out()
         END IF
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_set_field_pic("","","","","",g_aac.aacacti)
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
 
      ON ACTION jump
         CALL i108_fetch('/')
 
      ON ACTION first
         CALL i108_fetch('F')
 
      ON ACTION last
         CALL i108_fetch('L')
 
      #-----MOD-780077---------
      #ON ACTION enter_book_no #MOD-560012
      #  CALL s_selact(0,0,g_lang) RETURNING g_bookno
      #  CALL s_shwact(3,2,g_bookno)
      #  OPTIONS FORM LINE FIRST + 2
      #-----END MOD-780077-----
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT MENU
 
       ON ACTION related_document    #No.MOD-470515
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
            IF g_aac.aac01 IS NOT NULL THEN
               LET g_doc.column1 = "aac01"
               LET g_doc.value1 = g_aac.aac01
               CALL cl_doc()
            END IF
         END IF
 
   END MENU
 
   CLOSE i108_cs
 
END FUNCTION
 
FUNCTION i108_a()
 
   MESSAGE ""
 
   IF s_aglshut(0) THEN RETURN END IF
 
   CLEAR FORM                                   # 清螢墓欄位內容
   INITIALIZE g_aac.* LIKE aac_file.*
   LET g_aac01_t = NULL
   LET g_aac_o.*=g_aac.*
   LET g_aac.aacatsg = 'N'
   CALL cl_opmsg('a')
 
   WHILE TRUE
      #bugno:7002 add..........................
      LET g_aac.aac11   ='1'
      LET g_aac.aac03   ='0'
      LET g_aac.aacauno ='Y'
      #LET g_aac.aac06   ='2' #FUN-A10109
      LET g_aac.aac08   ='N'
      LET g_aac.aacatsg ='N'
      LET g_aac.aacpass ='N'
      #bugno:7002 end..........................
      LET g_aac.aac12   ='N'
      LET g_aac.aac13   ='N'
      LET g_aac.aac16   ='N'   #TQC-C40255  add
      LET g_aac.aacacti ='Y'                   #有效的資料
      LET g_aac.aacuser = g_user
      LET g_aac.aacoriu = g_user #FUN-980030
      LET g_aac.aacorig = g_grup #FUN-980030
      LET g_aac.aacgrup = g_grup               #使用者所屬群
      LET g_aac.aacdate = g_today
 
      CALL cl_set_comp_entry('aac17',FALSE)#FUN-C90058 add
      CALL i108_i("a")                      # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         INITIALIZE g_aac.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF g_aac.aac01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF

      LET g_aac.aac16 = 'N'                      #FUN-BB0123
 
      INSERT INTO aac_file VALUES(g_aac.*)       # DISK WRITE
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_aac.aac01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("ins","aac_file",g_aac.aac01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      ELSE
         #FUN-A10109  ===S===
         CALL s_access_doc('a',g_aac.aacauno,g_aac.aac11,g_aac.aac01,'AGL',g_aac.aacacti)
         #FUN-A10109  ===E===
         LET g_aac_t.* = g_aac.*                # 保存上筆資料
         SELECT aac01 INTO g_aac.aac01 FROM aac_file
          WHERE aac01 = g_aac.aac01
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i108_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,     #No.FUN-680098  VARCHAR(1)
          l_sw            LIKE type_file.chr1,     #判斷重要欄位是否沒有輸入  #No.FUN-680098    VARCHAR(1)
          l_dir1          LIKE type_file.chr1,     #判斷CURSOR JUMP DIRECTION  #No.FUN-680098   VARCHAR(1) 
          l_direct        LIKE type_file.chr1,     #判斷CURSOR JUMP DIRECTION  #No.FUN-680098   VARCHAR(1) 
          l_direct1       LIKE type_file.chr1,     #判斷CURSOR JUMP DIRECTION  #No.FUN-680098   VARCHAR(1) 
          l_aag02         LIKE aag_file.aag02,
          l_aac01         LIKE aac_file.aac01,      #No.FUN-560060
          li_result       LIKE type_file.num5,      #No.FUN-560060        #No.FUN-680098 SMALLINT
          l_n             LIKE type_file.num5       #No.FUN-680098         SMALLINT
    DEFINE l_i          LIKE type_file.num5         #No.FUN-560150        #No.FUN-680098 smallint
    DEFINE l_len        LIKE type_file.num10       #FUN-870025
    DEFINE l_sql        STRING                     #FUN-870025
 
   IF p_cmd='u' THEN
      LET l_n = 0
#No.FUN-870025--EBGIN--
#      SELECT COUNT(*) INTO l_n FROM aba_file
##      WHERE aba01[1,3]=g_aac.aac01
#       WHERE s_get_doc_no(aba01)=g_aac.aac01     #No.FUN-560060
 
      LET l_len=0
      LET l_len=length(g_aac.aac01)
      LET l_sql = "SELECT COUNT(*) FROM aba_file ", 
#                 " WHERE Substr(aba01,1,",l_len,") = '",g_aac.aac01,"'" 
                  " WHERE aba01[1,",l_len,"] = '",g_aac.aac01,"'",         #No.FUN-9B0038
                  "   AND abaacti = 'Y' "                                  #MOD-CB0182 add
      PREPARE i108_aba_pre FROM l_sql
      DECLARE i108_aba_cur CURSOR FOR i108_aba_pre
      OPEN i108_aba_cur
      FETCH i108_aba_cur INTO l_n
#No.FUN-870025--END--
      IF l_n > 0 THEN
         #CALL cl_err("",'agl-892',0)   #No.MOD-480016 #MOD-C30496 mark--
         #RETURN   #MOD-C30496 mark--
         CALL cl_set_comp_entry("aac01,aac11,aac03,aac04,aacoriu,aacorig,aacauno,aac12,aac13,aac09,aac08,aacdays,aacprit,aacatsg,aacsign",FALSE) #MOD-C30496 add
      END IF
   END IF
 
   INPUT BY NAME g_aac.aac01,g_aac.aac02,g_aac.aac11,g_aac.aac16,g_aac.aac03,g_aac.aac04,g_aac.aac17, g_aac.aacoriu,g_aac.aacorig,   #TQC-C40255  add g_aac.aac16#FUN-C90058 add aac17
                 g_aac.aacauno,
                 #g_aac.aac06, #FUN-A10109
                 g_aac.aac12,g_aac.aac13,g_aac.aac09,
                 g_aac.aac08,g_aac.aacdays,g_aac.aacprit,g_aac.aacatsg,
                 g_aac.aacsign,g_aac.aacpass,g_aac.aacuser,g_aac.aacgrup,
                 g_aac.aacmodu,g_aac.aacdate,g_aac.aacacti WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i108_set_entry(p_cmd)
         CALL i108_set_no_entry(p_cmd)
         CALL cl_set_comp_entry("aac16",false)     #TQC-C40255  add
         LET g_before_input_done = TRUE
         #NO.FUN-560150 --start--
         CALL cl_set_doctype_format("aac01")
         #NO.FUN-560150 --end--
 
#     BEFORE FIELD aac01
#        IF p_cmd='u' THEN
#           #--- 97/05/28 check 有無傳票資料
#           SELECT COUNT(*) INTO l_n FROM aba_file
#            WHERE aba01[1,3]=g_aac.aac01
#            IF l_n>0 THEN
#               NEXT FIELD aac01
#            END IF
#        END IF
 
      AFTER FIELD aac01
         IF NOT cl_null(g_aac.aac01) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_aac.aac01 != g_aac01_t) THEN
                #-----No.MOD-520076-----
               LET l_aac01 = g_aac.aac01,'   '
               LET l_aac01 = l_aac01[1,g_doc_len]  #No.FUN-560060
               CALL cl_chk_str_correct(l_aac01,1,g_doc_len) RETURNING g_errno #No.FUN-570024
               IF NOT g_errno THEN
#                  CALL cl_err(g_aac.aac01,'agl-927',0)   #TQC-5B0045
                  CALL cl_err(g_aac.aac01,'sub-146',0)   #TQC-5B0045
                  NEXT FIELD aac01
               END IF
                #-----No.MOD-520076 END-----
               SELECT COUNT(*) INTO l_n FROM aac_file
                WHERE aac01 = g_aac.aac01
               IF l_n > 0 THEN
                  CALL cl_err(g_aac.aac01,-239,0)
                  LET g_aac.aac01 = g_aac01_t
                  DISPLAY BY NAME g_aac.aac01
                  NEXT FIELD aac01
               END IF
               #NO.FUN-560150 --start--
               FOR l_i = 1 TO g_doc_len
                  IF cl_null(g_aac.aac01[l_i,l_i]) THEN
                     CALL cl_err('','sub-146',0)
                     LET g_aac.aac01 = g_aac01_t
                     NEXT FIELD aac01
                  END IF
               END FOR
               #NO.FUN-560150 --end--
            END IF
         END IF
 
      AFTER FIELD aac12              #2002.02.25 by flora
         IF NOT cl_null(g_aac.aac12) THEN
            IF g_aac.aac12 NOT MATCHES '[YN]' THEN
               LET g_aac.aac12="N"
               DISPLAY BY NAME g_aac.aac12
               NEXT FIELD aac12
            END IF
         END IF
 
      BEFORE FIELD aac11
 #       CALL s_getgee('agli108',g_lang,'aac11') #FUN-A10109  #TQC-AB0269
         CALL i108_set_entry(p_cmd)
        #IF p_cmd='u' THEN
        #   #--- 97/05/28 check 有無傳票資料
        #   SELECT COUNT(*) INTO l_n FROM aba_file
        #    WHERE aba01[1,3]=g_aac.aac01
        #   IF l_n>0 THEN
        #      NEXT FIELD aacauno
        #   END IF
        #END IF
 
      AFTER FIELD aac11
         IF NOT cl_null(g_aac.aac11) THEN
           #IF g_aac.aac11 NOT MATCHES '[12347AB]' OR   #FUN-A10109
            IF (g_aza.aza26 != '2' AND g_aac.aac11='B') THEN  #FUN-570024
               LET g_aac.aac11 = g_aac_t.aac11
               DISPLAY BY NAME g_aac.aac11
               NEXT FIELD aac11
            END IF
            IF g_aac.aac11 = 'A' THEN
               LET g_aac.aac03 = '0'
               DISPLAY BY NAME g_aac.aac03
            END IF
         END IF
         CALL i108_set_no_entry(p_cmd)
      #FUN-C90058--add--str
      ON CHANGE aac11
         IF g_aac.aac11 = '7' THEN 
            CALL cl_set_comp_entry('aac17',TRUE)
         ELSE
            LET g_aac.aac17 = ''
            CALL cl_set_comp_entry('aac17',FALSE)
         END IF 
      #FUN-C90058 add--end
 
      BEFORE  FIELD aac03
         CALL i108_set_entry(p_cmd)
 
      AFTER FIELD aac03
         IF NOT cl_null(g_aac.aac03) THEN
            IF g_aac.aac03 NOT MATCHES '[012]' THEN
               LET g_aac.aac03 = g_aac_t.aac03
               DISPLAY BY NAME g_aac.aac03
               NEXT FIELD aac03
            END IF
            IF g_aac.aac03 = '0' THEN
               LET g_aac.aac04 = ' '
               LET l_aag02 = ' '
               DISPLAY BY NAME g_aac.aac04
               DISPLAY l_aag02 TO FORMONLY.aag02
            END IF
            IF g_aac.aac11 = 'A' AND g_aac.aac03 != '0' THEN
               CALL cl_err(g_aac.aac03,'agl-018',0)
               NEXT FIELD aac03
            END IF
         END IF
         CALL i108_set_no_entry(p_cmd)
 
#     BEFORE FIELD aac04
#        IF g_aac.aac03 = '0' THEN
#           IF l_direct = 'D' THEN
#              NEXT FIELD aacauno
#           ELSE
#              NEXT FIELD aac03
#           END IF
#        END IF
 
      AFTER FIELD aac04
         IF NOT cl_null(g_aac.aac04) THEN
            CALL i108_aac04('a')
            IF NOT cl_null(g_chr) THEN     #No.MOD-4A0051
               CALL cl_err(g_aac.aac04,g_chr,0)     #No.MOD-4A0051
              #Mod No.FUN-B10048
              #LET g_aac.aac04 = g_aac_t.aac04
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = g_aac.aac04
               LET g_qryparam.arg1 = g_aza.aza81
               LET g_qryparam.where = " aag07 IN ('2','3') AND aag03='2' AND aag09='Y' AND aagacti='Y' AND aag01 LIKE '",g_aac.aac04 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING g_aac.aac04
              #End Mod No.FUN-B10048
               DISPLAY BY NAME g_aac.aac04
               NEXT FIELD aac04
            END IF
         END IF
 
      AFTER FIELD aacauno
        #IF p_cmd='u' THEN
        #   SELECT COUNT(*) INTO l_n FROM aba_file
        #      WHERE aba01[1,3]=g_aac.aac01
        #   IF l_n>0 THEN
        #      NEXT FIELD aac02
        #   END IF
        #END IF
        #IF g_aac.aacauno IS NULL THEN
        #   NEXT FIELD aacauno
        #END IF
         IF NOT cl_null(g_aac.aacauno) THEN
            IF g_aac.aacauno NOT MATCHES'[YN]' THEN
               CALL cl_err(g_aac.aacauno,'agl-061',0)
               LET g_aac.aacauno = g_aac_o.aacauno
               DISPLAY BY NAME g_aac.aacauno
               NEXT FIELD aacauno
            END IF
            LET g_aac_o.aacauno = g_aac.aacauno
         END IF
        #LET g_aac_o.aacauno = g_aac.aacauno
        #LET l_direct = 'U'
 
#No.FUN-560057-begin
#     AFTER FIELD aac06
#        IF NOT cl_null(g_aac.aac06) THEN
#           IF g_aac.aac06 NOT MATCHES'[1-2]' THEN
#              CALL cl_err(g_aac.aac06,'agl-111',0)
#              LET g_aac.aac06 = g_aac_o.aac06
#              DISPLAY BY NAME g_aac.aac06
#              NEXT FIELD aac06
#           END IF
#           LET g_aac_o.aac06 = g_aac.aac06
#        END IF
#No.FUN-560057-end
 
      AFTER FIELD aac08
         IF NOT cl_null(g_aac.aac08) THEN
            IF g_aac.aac08 NOT MATCHES'[YN]' THEN
               CALL cl_err(g_aac.aac08,'agl-061',0)
               LET g_aac.aac08 = g_aac_o.aac08
               DISPLAY BY NAME g_aac.aac08
               NEXT FIELD aac08
            END IF
            LET g_aac_o.aac08 = g_aac.aac08
#FUN-580127
#            IF g_aac.aac08 = 'Y' AND g_aac.aacpass= 'Y' THEN
#               LET g_aac.aacpass = NULL
#               DISPLAY BY NAME g_aac.aacpass
#            END IF
#END FUN-580127
            IF g_aac.aac08 = 'N' THEN
#FUN-580127
               LET g_aac.aacatsg = NULL
               LET g_aac.aacsign = NULL
               LET g_aac.aacdays = NULL
               LET g_aac.aacprit = NULL
               DISPLAY BY NAME g_aac.aacatsg,g_aac.aacsign,
                               g_aac.aacdays,g_aac.aacprit
#               LET g_aac.aacatsg = NULL
#               LET g_aac_o.aacatsg = NULL
#               LET g_aac.aacdays = NULL
#               LET g_aac.aacatsg = NULL
#               DISPLAY BY NAME g_aac.aacatsg
#               DISPLAY BY NAME g_aac.aacdays
#               DISPLAY BY NAME g_aac.aacatsg
#END FUN-580127
            END IF
            CALL i108_set_no_entry(p_cmd)
         END IF
 
#FUN-580127
         ON CHANGE aac08
         #FUN-640244
         #   IF g_aac.aac08 = 'Y' THEN
         #      LET g_aac.aacpass = 'N'
         #      DISPLAY BY NAME g_aac.aacpass
         #   END IF
         #END FUN-640244
             CALL i108_set_entry(p_cmd)      #FUN-5B0078
             CALL i108_set_no_entry(p_cmd)   #FUN-5B0078
#END FUN-580127
 
 
      BEFORE FIELD aacdays
         IF g_aac.aac08 = 'N' THEN
            LET g_aac.aacatsg = NULL
            LET g_aac_o.aacatsg = NULL
            DISPLAY BY NAME g_aac.aacatsg
         END IF
 
      AFTER FIELD aacdays
         IF g_aac.aac08 = 'N' THEN
            LET g_aac.aacdays = NULL
            DISPLAY BY NAME g_aac.aacdays
         END IF
 
    # BEFORE FIELD aacprit
    #    IF g_aac.aac08 = 'N' THEN
    #       NEXT FIELD aacpass
    #    END IF
 
      AFTER FIELD aacprit
         IF g_aac.aac08 = 'N' THEN
            LET g_aac.aacprit = NULL
            DISPLAY BY NAME g_aac.aacprit
         END IF
 
    # BEFORE FIELD aacatsg
    #    IF g_aac.aac08 = 'N' THEN
    #       NEXT FIELD aacpass
    #    END IF
 
      AFTER FIELD aacatsg    #是否自動賦予簽核等級
         IF g_aac.aac08 = 'N' THEN
            LET g_aac.aacatsg = NULL
            DISPLAY BY NAME g_aac.aacatsg
         END IF
         IF NOT cl_null(g_aac.aacatsg) AND
            g_aac.aacatsg NOT MATCHES'[yYnN]' THEN
            LET g_aac.aacatsg = g_aac_o.aacatsg
            DISPLAY BY NAME g_aac.aacatsg
            NEXT FIELD aacatsg
         END IF
         LET g_aac_o.aacatsg = g_aac.aacatsg
 
      BEFORE FIELD aacsign
         IF g_aac.aacatsg = 'N' THEN
            LET g_aac.aacsign = NULL
            LET g_aac_o.aacsign = NULL
            DISPLAY BY NAME g_aac.aacsign
         END IF
 
      AFTER FIELD aacsign    #簽核等級
         IF g_aac.aac08 = 'N' THEN
            LET g_aac.aacsign = NULL
            DISPLAY BY NAME g_aac.aacsign
         END IF
         IF NOT cl_null(g_aac.aacsign) THEN
            SELECT aze01 FROM aze_file WHERE aze01 = g_aac.aacsign
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_aac.aacsign,'agl-093',0)   #No.FUN-660123
               CALL cl_err3("sel","aze_file",g_aac.aacsign,"",SQLCA.sqlcode,"","agl-093",1)  #No.FUN-660123
               LET g_aac.aacsign = g_aac_o.aacsign
               DISPLAY BY NAME g_aac.aacsign
               NEXT FIELD aacsign
            END IF
            IF g_aac.aacatsg = 'N' THEN
               LET g_aac.aacsign = NULL
               DISPLAY BY NAME g_aac.aacsign
            END IF
            LET g_aac_o.aacsign = g_aac.aacsign
         END IF
 
     #BEFORE FIELD aacpass
        # IF g_aac.aac08 = 'Y' THEN
        #    NEXT FIELD aac09
        # END IF
 
#      AFTER FIELD aacpass    #FUN-580127
         #若不須簽核則自動確認，而之前又設定須簽
#         IF g_aac.aacpass = 'Y' AND g_aac.aac08 = 'Y' THEN   #FUN-580127
       #FUN-640244 
       #ON CHANGE aacpass   #FUN-580127
       #  IF g_aac.aacpass = 'Y' THEN   #FUN-580127
       #     LET g_aac.aac08   = 'N'
       #     LET g_aac.aacatsg = NULL
       #     LET g_aac.aacsign = NULL
       #     LET g_aac.aacdays = NULL
       #     LET g_aac.aacprit = NULL
       #     DISPLAY BY NAME g_aac.aac08,g_aac.aacatsg,g_aac.aacsign,
       #                     g_aac.aacdays,g_aac.aacprit
       #  END IF
       #  CALL i108_set_entry(p_cmd)      #FUN-5B0078
       #  CALL i108_set_no_entry(p_cmd)   #FUN-5B0078
       #END FUN-640244 
 
      AFTER INPUT
         LET g_aac.aacuser = s_get_data_owner("aac_file") #FUN-C10039
         LET g_aac.aacgrup = s_get_data_group("aac_file") #FUN-C10039
         IF INT_FLAG THEN EXIT INPUT END IF
#        IF cl_null(g_aac.aacauno) THEN   #自動編號否
#           DISPLAY BY NAME g_aac.aacauno
#           LET l_sw = 'Y'
#        END IF
#        IF cl_null(g_aac.aac06) THEN     #編號碼數
#           DISPLAY BY NAME g_aac.aac06
#           LET l_sw = 'Y'
#        END IF
#        IF g_aac.aac08 IS NULL THEN     #簽核處理
#           DISPLAY BY NAME g_aac.aac08
#           LET l_sw = 'Y'
#        END IF
#        IF l_sw = 'Y' THEN
#           LET l_sw = 'N'
#           CALL cl_err('','9033',0)
#           NEXT FIELD aac01
#         END IF
 
       # MOD-650040 -- start
       #ON ACTION CONTROLO                        # 沿用所有欄位
       #   IF INFIELD(aac01) THEN
       #      LET g_aac.* = g_aac_t.*
       #      LET g_aac.aacmodu = NULL
       #      LET g_aac.aacacti ='Y'                   #有效的資料
       #      LET g_aac.aacuser = g_user
       #      LET g_aac.aacgrup = g_grup               #使用者所屬群
       #      LET g_aac.aacdate = g_today
       #      DISPLAY BY NAME g_aac.aac01,g_aac.aac02,g_aac.aac11,g_aac.aac03,
       #                      g_aac.aac04,g_aac.aacauno,g_aac.aac06,g_aac.aac08,
       #                      g_aac.aacatsg,g_aac.aacsign,g_aac.aacpass,
       #                      g_aac.aac09,g_aac.aacuser,g_aac.aacgrup,
       #                      g_aac.aacdate, g_aac.aacacti
       #   END IF
       # MOD-650040 -- end
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aac04) #會計科目
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_aac.aac04
               LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730070
               CALL cl_create_qry() RETURNING g_aac.aac04
               DISPLAY BY NAME g_aac.aac04
               CALL i108_aac04('d')
               NEXT FIELD aac04
            WHEN INFIELD(aacsign)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aze"
               LET g_qryparam.default1 = g_aac.aacsign
               CALL cl_create_qry() RETURNING g_aac.aacsign
               DISPLAY BY NAME g_aac.aacsign
               NEXT FIELD aacsign
            OTHERWISE EXIT CASE
         END CASE
 
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
 
FUNCTION i108_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aac01,aac11,aac03,aac04",TRUE)
   END IF
 
   IF INFIELD(aac11) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aac03,aac04",TRUE)
   END IF
 
   IF INFIELD(aac03) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aac04",TRUE)
   END IF
 
#--- FUN-5B0078 begin
   IF INFIELD(aac08) OR ( NOT g_before_input_done ) THEN  #FUN-640244
      IF g_aac.aac08 = 'Y' AND g_aza.aza23 = 'N' THEN
         CALL cl_set_comp_entry("aacdays,aacprit,aacatsg,aacsign",TRUE)
      END IF
   END IF
#--- FUN-5B0078 end
END FUNCTION
 
FUNCTION i108_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1,         #No.FUN-680098  VARCHAR(1)
          l_n     LIKE type_file.num5          #No.FUN-680098  SMALLINT
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aac01,aac11,aac03,aac04",FALSE)
   END IF
 
#  IF (INFIELD(aac11) AND p_cmd='u') OR ( NOT g_before_input_done ) THEN
#     #--- 97/05/28 check 有無傳票資料
#     SELECT COUNT(*) INTO l_n FROM aba_file
#      WHERE aba01[1,3]=g_aac.aac01
#     IF l_n > 0 THEN
#        CALL cl_set_comp_entry("aac03,aac04",FALSE)
#     END IF
#  END IF
 
   IF INFIELD(aac11) THEN
      IF g_aac.aac11 <> '1' THEN
         CALL cl_set_comp_entry("aac03,aac04",FALSE)
      END IF
   END IF
 
   IF INFIELD(aac03) OR ( NOT g_before_input_done ) THEN
      IF g_aac.aac03 = '0' THEN
         CALL cl_set_comp_entry("aac04",FALSE)
      END IF
   END IF
 
#--- FUN-5B0078 begin
   IF INFIELD(aac08) OR ( NOT g_before_input_done ) THEN  #FUN-640244
      IF g_aac.aac08 = 'N' OR ( g_aac.aac08 = 'Y' AND  g_aza.aza23 = 'Y' ) THEN
         CALL cl_set_comp_entry("aacdays,aacprit,aacatsg,aacsign",FALSE)
      END IF
   END IF
#--- FUN-5B0078 end
END FUNCTION
 
FUNCTION i108_aac04(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
          l_aag02   LIKE aag_file.aag02,
          l_aag03   LIKE aag_file.aag03,
          l_aag07   LIKE aag_file.aag07,
          l_aag09   LIKE aag_file.aag09,
          l_aagacti LIKE aag_file.aagacti
 
   LET g_chr = ' '
   IF g_aac.aac04 IS NULL THEN
       LET l_aag02=NULL
   ELSE
       #-----No.MOD-4A0051-----
      SELECT aag02,aag03,aag07,aag09,aagacti
        INTO l_aag02,l_aag03,l_aag07,l_aag09,l_aagacti
        FROM aag_file
       WHERE aag01 = g_aac.aac04
         AND aag00 = g_aza.aza81  #No.FUN-730070
      IF SQLCA.sqlcode THEN
         LET g_chr = "agl-001"
         LET l_aag02 = NULL
      ELSE
         IF l_aagacti="N" THEN
            LET g_chr = "agl-001"
         END IF
         IF g_aac.aac03="1" OR g_aac.aac03="2" THEN
            CASE
               WHEN l_aag09="N"
                  LET g_chr="agl-214"
               WHEN l_aag03="4"
                  LET g_chr="agl-177"
               WHEN l_aag07="1"
                  LET g_chr="agl-015"
            END CASE
         END IF
       #-----No.MOD-4A0051 END-----
      END IF
   END IF
 
   IF cl_null(g_chr) OR p_cmd = 'd' THEN
      DISPLAY l_aag02 TO FORMONLY.aag02
   END IF
 
END FUNCTION
 
FUNCTION i108_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_aac.* TO NULL              #No.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i108_cs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
 
   OPEN i108_count
   FETCH i108_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i108_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aac.aac01,SQLCA.sqlcode,0)
      INITIALIZE g_aac.* TO NULL
   ELSE
      CALL i108_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i108_fetch(p_flaac)
   DEFINE p_flaac   LIKE type_file.chr1,         #No.FUN-680098    VARCHAR(1)
          l_abso    LIKE type_file.num10         #No.FUN-680098    INTEGER
 
    CASE p_flaac
        WHEN 'N' FETCH NEXT     i108_cs INTO g_aac.aac01
        WHEN 'P' FETCH PREVIOUS i108_cs INTO g_aac.aac01
        WHEN 'F' FETCH FIRST    i108_cs INTO g_aac.aac01
        WHEN 'L' FETCH LAST     i108_cs INTO g_aac.aac01
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
            FETCH ABSOLUTE g_jump i108_cs INTO g_aac.aac01
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aac.aac01,SQLCA.sqlcode,0)
        INITIALIZE g_aac.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flaac
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting(g_curs_index,g_row_count)
    END IF
    SELECT * INTO g_aac.* FROM aac_file            # 重讀DB,因TEMP有不被更新特性
     WHERE aac01 = g_aac.aac01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_aac.aac01,SQLCA.sqlcode,0)   #No.FUN-660123
       CALL cl_err3("sel","aac_file",g_aac.aac01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
    ELSE
       LET g_data_owner = g_aac.aacuser     #No.FUN-4C0048
       LET g_data_group = g_aac.aacgrup     #No.FUN-4C0048
       CALL i108_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i108_show()
 
   LET g_aac_t.* = g_aac.*
   DISPLAY BY NAME g_aac.aacoriu,g_aac.aacorig,
   #modify 020926  NO.A035
           g_aac.aac01,g_aac.aac02,g_aac.aac12,g_aac.aac13,g_aac.aac11,
           g_aac.aac03,g_aac.aac04,g_aac.aac17,g_aac.aacauno,#FUN-C90058  add aac17
           #g_aac.aac06, #FUN-A10109
           g_aac.aac08,g_aac.aacatsg,g_aac.aacdays,g_aac.aacprit,
           g_aac.aacsign,g_aac.aacpass,
           g_aac.aac09,g_aac.aacuser,g_aac.aacgrup,g_aac.aacmodu,
           g_aac.aacdate, g_aac.aacacti
           ,g_aac.aac16                    #FUN-BB0123
   CALL i108_aac04('d')
  #LET g_msg = s_smu_d(g_aac.aac01,g_sys) #TQC-660133 remark
   LET g_msg = s_smu_d(g_aac.aac01,"AGL") #TQC-660133
   DISPLAY g_msg TO smu02_display
  #LET g_msg = s_smv_d(g_aac.aac01,g_sys) #TQC-660133 remark
   LET g_msg = s_smv_d(g_aac.aac01,"AGL") #TQC-660133
   DISPLAY g_msg TO smv02_display
   CALL cl_set_field_pic("","","","","",g_aac.aacacti)
 
END FUNCTION
 
FUNCTION i108_u()
 
   IF s_aglshut(0) THEN RETURN END IF
 
   IF g_aac.aac01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_aac.* FROM aac_file WHERE aac01=g_aac.aac01
   IF g_aac.aacacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_aac.aac01,9027,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_aac01_t = g_aac.aac01
   BEGIN WORK
 
   OPEN i108_cl USING g_aac.aac01
   IF STATUS THEN
      CALL cl_err("OPEN i108_cl:", STATUS, 1)
      CLOSE i108_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i108_cl INTO g_aac.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aac.aac01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
    LET g_aac_o.* = g_aac.*  #No.MOD-480016
   LET g_aac.aacmodu=g_user                     #修改者
   LET g_aac.aacdate = g_today                  #修改日期
 
   CALL i108_show()                          # 顯示最新資料
 
   WHILE TRUE
      #FUN-C90058 add---str
      IF g_aac.aac11 = '7' THEN 
         CALL cl_set_comp_entry('aac17',TRUE)
      ELSE
         CALL cl_set_comp_entry('aac17',FALSE)
      END IF 
      #FUN-C90058--add--end
      CALL i108_i("u")                      # 欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
          LET g_aac.*=g_aac_o.*   #No.MOD-480016
         CALL i108_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE aac_file SET aac_file.* = g_aac.*    # 更新DB
       WHERE aac01 = g_aac01_t             # COLAUTH?
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_aac.aac01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("upd","aac_file",g_aac.aac01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
      #FUN-A10109  ===S===
      CALL s_access_doc('u',g_aac.aacauno,g_aac.aac11,g_aac01_t,'AGL',g_aac.aacacti)
      #FUN-A10109  ===E===
      EXIT WHILE
   END WHILE
 
   CLOSE i108_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i108_x()
   DEFINE l_chr LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF s_aglshut(0) THEN RETURN END IF
 
   IF g_aac.aac01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i108_cl USING g_aac.aac01
   IF STATUS THEN
      CALL cl_err("OPEN i108_cl:", STATUS, 1)
      CLOSE i108_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i108_cl INTO g_aac.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aac.aac01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL i108_show()
 
   IF cl_exp(15,21,g_aac.aacacti) THEN
      LET g_chr=g_aac.aacacti
      IF g_aac.aacacti='Y' THEN
         LET g_aac.aacacti='N'
      ELSE
         LET g_aac.aacacti='Y'
      END IF
 
      UPDATE aac_file SET aacacti = g_aac.aacacti,
                          aacmodu = g_user,
                          aacdate = g_today
       WHERE aac01 = g_aac.aac01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_aac.aac01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("upd","aac_file",g_aac.aac01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
         LET g_aac.aacacti=g_chr
      END IF
      #FUN-A10109  ===S===
      CALL s_access_doc('u',g_aac.aacauno,g_aac.aac11,g_aac.aac01,'AGL',g_aac.aacacti)
      #FUN-A10109  ===E===
      DISPLAY BY NAME g_aac.aacacti
   END IF
 
   CLOSE i108_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i108_r()
   DEFINE l_chr LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF s_aglshut(0) THEN RETURN END IF
 
   IF g_aac.aac01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #-----MOD-770095---------
  #IF g_aac.aac01 = 'EOM' THEN         #MOD-950008 mark
   IF g_aac.aac01 = g_aaz.aaz65 THEN   #MOD-950008
      CALL cl_err('','agl-184',0)
      RETURN
   END IF
#No.TQC-950007 --begin                                                          
   IF g_aac.aacacti = 'N' THEN                                                  
      CALL cl_err('','abm-950',0)                                               
      RETURN                                                                    
   END IF                                                                       
#No.TQC-950007 --end 
   #-----END MOD-770095-----
   BEGIN WORK
 
   OPEN i108_cl USING g_aac.aac01
   IF STATUS THEN
      CALL cl_err("OPEN i108_cl:", STATUS, 1)
      CLOSE i108_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i108_cl INTO g_aac.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aac.aac01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL i108_show()
 
   IF cl_delete() THEN   #NO:6842
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "aac01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_aac.aac01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()#No.FUN-9B0098 10/02/24
      DELETE FROM aac_file WHERE aac01 = g_aac.aac01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_aac.aac01,SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("del","aac_file",g_aac.aac01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
      ELSE
         CLEAR FORM
      END IF
 
      #DELETE FROM smv_file WHERE smv01 = g_aac.aac01 AND smv03=g_sys       #TQC-670008 remark
      DELETE FROM smv_file WHERE smv01 = g_aac.aac01 AND upper(smv03)='AGL' #TQC-670008
      IF SQLCA.SQLCODE THEN
#        CALL cl_err('smv_file',SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("del","smv_file",g_aac.aac01,g_sys,SQLCA.sqlcode,"","smv_file",1)  #No.FUN-660123
      END IF
 
      #DELETE FROM smu_file WHERE smu01 = g_aac.aac01 AND smu03=g_sys       #TQC-670008 remark
      DELETE FROM smu_file WHERE smu01 = g_aac.aac01 AND upper(smu03)='AGL' #TQC-670008
      IF SQLCA.SQLCODE THEN
#        CALL cl_err('smu_file',SQLCA.sqlcode,0)   #No.FUN-660123
         CALL cl_err3("del","smu_file",g_aac.aac01,g_sys,SQLCA.sqlcode,"","smu_file",1)  #No.FUN-660123
      END IF
      #FUN-A10109  ===S===
      CALL s_access_doc('r','','',g_aac.aac01,'AGL',g_aac.aacacti)
      #FUN-A10109  ===E===
 
      OPEN i108_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i108_cs
         CLOSE i108_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH i108_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i108_cs
         CLOSE i108_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
 
      OPEN i108_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i108_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i108_fetch('/')
      END IF
   END IF
 
   CLOSE i108_cl
   COMMIT WORK
    #INITIALIZE g_aac.* TO NULL        #No.MOD-510107
 
END FUNCTION
 
FUNCTION i108_s()
   DEFINE l_aba00          LIKE aaa_file.aaa01     #No.FUN-670039
   DEFINE l_aba01,new_no   LIKE aba_file.aba01     #No.FUN-560060   #No.FUN-680098   VARCHAR(16)
   DEFINE l_aba02          LIKE type_file.dat      #No.FUN-680098   date
#No.FUN-560060--begin
   DEFINE li_result        LIKE type_file.num5          #No.FUN-680098 smallint
#No.FUN-560060--end
 
   DECLARE i108_c9 CURSOR FOR SELECT aba00,aba01,aba02
                                FROM aba_file
                               ORDER BY aba02,aba01
 
   FOREACH i108_c9 INTO l_aba00,l_aba01,l_aba02
      IF STATUS THEN
         CALL cl_err('',status,1)
         EXIT FOREACH
      END IF
 
#No.FUN-560060--begin
      LET g_msg = l_aba01[1,g_doc_len]
     #CALL s_auto_assign_no("agl",g_msg,l_aba02,"2","aba_file","aba01",g_dbs,"",l_aba00) #FUN-980094 mark
      CALL s_auto_assign_no("agl",g_msg,l_aba02,"2","aba_file","aba01",g_plant,"",l_aba00) #FUN-980094 add
      RETURNING li_result,new_no
#     CALL s_m_aglau(g_dbs,l_aba00,g_msg,l_aba02,0,0,'2') RETURNING g_i,new_no
 
#     IF new_no[5,8] = l_aba01[5,8] THEN
      IF new_no[g_no_sp,g_no_ep] = l_aba01[g_no_sp,g_no_ep] THEN
#No.FUN-560060--end
         CONTINUE FOREACH
      END IF
 
      DISPLAY l_aba01,' ',l_aba02,' ',new_no
 
      UPDATE aba_file SET aba01 = new_no
       WHERE aba01 = l_aba01
         AND aba00 = l_aba00
 
      UPDATE abb_file SET abb01 = new_no
       WHERE abb01 = l_aba01
         AND abb00 = l_aba00
 
      UPDATE abc_file SET abc01 = new_no
       WHERE abc01 = l_aba01
         AND abc00 = l_aba00
   END FOREACH
 
END FUNCTION
 
FUNCTION i108_copy()
   DEFINE l_n       LIKE type_file.num5,    #No.FUN-680098 SMALLINT
          l_newno   LIKE aac_file.aac01,
          l_oldno   LIKE aac_file.aac01
   DEFINE l_i       LIKE type_file.num5     #No.FUN-560150        #No.FUN-680098 SMALLINT
 
   IF s_aglshut(0) THEN RETURN END IF
 
   IF g_aac.aac01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i108_set_entry('a')
   CALL i108_set_no_entry('a')
   LET g_before_input_done = TRUE
 
   INPUT l_newno FROM aac01
 
      BEFORE FIELD aac01
         #NO.FUN-560150 --start--
         CALL cl_set_doctype_format("aac01")
         #NO.FUN-560150 --end--
#        IF p_cmd='u' THEN
#           #--- 97/05/28 check 有無傳票資料
#           SELECT COUNT(*) INTO l_n FROM aba_file
 
      AFTER FIELD aac01
         IF NOT cl_null(l_newno) THEN
            SELECT COUNT(*) INTO g_cnt FROM aac_file
             WHERE aac01 = l_newno
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD aac01
            END IF
            #NO.FUN-560150 --start--
            FOR l_i = 1 TO g_doc_len
               IF cl_null(l_newno[l_i,l_i]) THEN
                  CALL cl_err('','sub-146',0)
                  NEXT FIELD aac01
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
 
   IF INT_FLAG OR cl_null(l_newno) THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_aac.aac01
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM aac_file
    WHERE aac01 = g_aac.aac01
     INTO TEMP x
 
   UPDATE x SET aac01 = l_newno,   #資料鍵值
                aacuser = g_user,   #資料所有者
                aacgrup = g_grup,   #資料所有者所屬群
                aacmodu = NULL,     #資料修改日期
                aacdate = g_today,  #資料建立日期
                aacacti = 'Y'       #有效資料
 
   INSERT INTO aac_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aac.aac01,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("ins","aac_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660123
   ELSE
      MESSAGE 'ROW(',l_newno,') O.K'
      LET l_oldno = g_aac.aac01
      SELECT aac_file.* INTO g_aac.* FROM aac_file
       WHERE aac01 =  l_newno

      #FUN-A10109  ===S===
      CALL s_access_doc('a',g_aac.aacauno,g_aac.aac11,g_aac.aac01,'AGL',g_aac.aacacti)
      #FUN-A10109  ===E===
 
      CALL i108_u()
 
      CALL i108_show()
      #FUN-C30027---begin
      #LET g_aac.aac01 = l_oldno
      #SELECT aac_file.* INTO g_aac.* FROM aac_file
      # WHERE aac01 = g_aac.aac01
      #
      #CALL i108_show()
      #FUN-C30027---end
   END IF
 
   DISPLAY BY NAME g_aac.aac01
 
END FUNCTION

#FUN-BB0123--Begin--
FUNCTION i108_aac16()

   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_aac.aac01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_aac.* FROM aac_file WHERE aac01=g_aac.aac01
   
   BEGIN WORK
   OPEN i108_cl USING g_aac.aac01
   IF STATUS THEN
      CALL cl_err("OPEN i108_cl:", STATUS, 1)
      CLOSE i108_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i108_cl INTO g_aac.*
   IF STATUS THEN
      CALL cl_err('Lock aac:',STATUS,0)
      ROLLBACK WORK
      RETURN
   END IF
   LET g_aac_t.*=g_aac.*
   LET g_aac_o.*=g_aac.*

   
   WHILE TRUE
   CALL cl_set_comp_entry("aac16",true)     #TQC-C40255  add
   INPUT BY NAME g_aac.aac16
         WITHOUT DEFAULTS

      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aac.*=g_aac_t.*
            DISPLAY BY NAME g_aac.aac16
            CALL cl_err('',9001,0)
            EXIT WHILE
         END IF
         UPDATE aac_file SET aac16=g_aac.aac16
          WHERE aac01=g_aac.aac01
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","aac_file",g_aac.aac01,"",STATUS,"","upd aac01",1)
            LET g_aac.*=g_aac_t.*
            DISPLAY BY NAME g_aac.aac16
            ROLLBACK WORK
            RETURN
         ELSE
            LET g_aac_o.*=g_aac.*
            LET g_aac_t.*=g_aac.*
         END IF

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()
      END INPUT
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
#FUN-BB0123---End---
 
#No.FUN-820002--start--
FUNCTION i108_out()
#  DEFINE sr       RECORD LIKE aac_file.*,
#         l_i      LIKE type_file.num5,      #No.FUN-680098  SMALLINT
#         l_name   LIKE type_file.chr20,     # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#         l_chr    LIKE type_file.chr1       #No.FUN-680098  VARCHAR(1)
DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-820002                                                                   
  IF cl_null(g_wc) AND NOT cl_null(g_aac.aac01) THEN                                                                                
     LET g_wc = " aac01 = '",g_aac.aac01,"' "                                                                                       
  END IF                                                                                                                            
  IF g_wc IS NULL THEN                                                                                                              
     CALL cl_err('','9057',0)                                                                                                       
     RETURN                                                                                                                         
  END IF                                                                                                                            
  LET l_cmd = 'p_query "agli108" "',g_wc CLIPPED,'"'                                                                                
  CALL cl_cmdrun(l_cmd)                                                                                                             
  RETURN
 
#  CALL cl_wait()
 
#  CALL cl_outnam('agli108') RETURNING l_name
#  SELECT aaf03 INTO g_company FROM aaf_file
#   WHERE aaf01 = g_bookno
#     AND aaf02 = g_lang
#
#  LET g_sql = "SELECT * FROM aac_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc CLIPPED
#  PREPARE i108_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE i108_co CURSOR FOR i108_p1
 
#  START REPORT i108_rep TO l_name
 
#  FOREACH i108_co INTO sr.*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#        EXIT FOREACH
#     END IF
 
#     OUTPUT TO REPORT i108_rep(sr.*)
 
#  END FOREACH
 
#  FINISH REPORT i108_rep
 
#  CLOSE i108_co
#  CALL cl_prt(l_name,' ','1',g_len)
#  MESSAGE ""
 
END FUNCTION
 
#REPORT i108_rep(sr)
#  DEFINE l_trailer_sw   LIKE type_file.chr1,          #No.FUN-680098    VARCHAR(1)
#         sr             RECORD LIKE aac_file.*,
#         l_chr          LIKE type_file.chr1,          #No.FUN-680098    VARCHAR(1)
#         l_aac01        VARCHAR(4)   #TQC-5B0045
#         l_aac01        LIKE aac_file.aac01   #TQC-5B0045   #No.FUN-680098   VARCHAR(6)
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.aac01
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<',"/pageno"
#        PRINT g_head CLIPPED,pageno_total
#        PRINT ' '
#        PRINT g_dash[1,g_len]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#              g_x[39],g_x[40]
#        PRINT g_dash1
#        LET l_trailer_sw = 'y'
 
#     ON EVERY ROW
#        IF sr.aacacti = 'N' THEN
#           LET l_aac01 = '*',sr.aac01 CLIPPED
#        ELSE
#           LET l_aac01 = ' ',sr.aac01 CLIPPED
#        END IF
#        PRINT COLUMN g_c[31],l_aac01,
#              COLUMN g_c[32],sr.aac02,
#              COLUMN g_c[33],sr.aac11,
#              COLUMN g_c[34],sr.aac03,
#              COLUMN g_c[35],sr.aac04,
#              COLUMN g_c[36],sr.aac06,
#              COLUMN g_c[37],sr.aac08,
#              COLUMN g_c[38],sr.aacsign,
#              COLUMN g_c[39],sr.aacpass,
#              COLUMN g_c[40],sr.aac12
#        SKIP 1 LINE
 
#     ON LAST ROW
#        IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#           CALL cl_wcchp(g_wc,'aac01,aac02,aac03,aac04,ac05,aac06,aac07') RETURNING g_sql
#           PRINT g_dash[1,g_len]
#         #TQC-630166
#         {
#           IF g_sql[001,080] > ' ' THEN
#              PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#                    COLUMN g_c[32],g_sql[001,070] CLIPPED
#           END IF
#           IF g_sql[071,140] > ' ' THEN
#              PRINT COLUMN g_c[32],g_sql[071,140] CLIPPED
#           END IF
#           IF g_sql[141,210] > ' ' THEN
#              PRINT COLUMN g_c[32],g_sql[141,210] CLIPPED
#           END IF
#         }
#           CALL cl_prt_pos_wc(g_sql)
#         #END TQC-630166
#        END IF
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#        LET l_trailer_sw = 'n'
 
#     PAGE TRAILER
#        IF l_trailer_sw = 'y' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#        ELSE
#           SKIP 2 LINE
#        END IF
 
#END REPORT
#No.FUN-820002--end--

