# Prog. Version..: '5.30.06-13.03.29(00010)'     #
#
# Pattern name...: aapi103.4gl
# Descriptions...: 單據性質維護作業
# Date & Author..: 92/02/18 BY  MAY
#                  1.單據性質31.預付,32.沖帳->取消
#                  2.增加立即確認欄位
#                  3.年度,期別,最大單號拿掉
#                  4.單號編號方式改為1.流水號2.依年月,已用單號欄位取消
#                  5.menu bar之detail及G.產生單身功能取消
#                  6.簽核處理default 'N',由螢幕取消
# Modify.........: 2004/10/19 MOD-4A0253 echo 新增簽核欄位
#                  2004/11/22 MOD-4B0210 alex 修正切換語言別會跳離程式
# Modify.........: No.FUN-4C0047 04/12/08 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0097 04/12/22 By Nicola 報表架構修改
# Modify.........: No.MOD-510116 05/01/17 By Kitty 切換語言程式CRASH
# Modify.........: No.FUN-550030 05/05/11 By ice 編碼方法增加3.依年周
# Modify.........: No.FUN-560150 05/06/21 By ice 編碼方法增加4.依年月日,
#                                                輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-580012 05/08/02 By elva 大陸版新增紅衝功能
# Modify.........: No.FUN-580126 05/08/24 By Smapmin "應簽核" & "自動確認" 應為互斥的選項
# Modify.........: No.MOD-5B0044 05/11/24 By Smapmin 連續刪除二筆會有錯
# Modify.........: No.MOD-5C0144 05/12/23 By Smapmin 對應單別(apydmy4)欄位資料不可重複於其他單別(apyslip)中
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.FUN-640240 06/05/16 By Echo 取消"立即確認"與"應簽核"欄位為互斥的選項
# Modify.........: No.TQC-660133 06/07/03 By rainy s_xxxslip(),s_smu(),s_smv()中的參數 g_sys 改寫死系統別(ex:AAP)
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-670060 06/07/19 By xiake 在“拋轉憑証”后加“系統自動拋轉總帳”和“自動拋轉總帳單別”兩欄位;
# Modify.........: No.FUN-670060 06/08/01 By wujie 自動拋轉總帳單別開窗采用q_m_acc跨庫到總帳營運中心取單別   
# Modify.........: No.FUN-680110 06/08/29 By Sarah 單據性質(apykind)增加16.暫估應付,26.暫估倉退
# Modify.........: No.FUN-680088 06/08/30 By Ray 新增自動拋轉總帳第二單別
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-690090 06/10/10 By Rayven 新增內部帳戶功能
# Modify.........: No.FUN-690080 06/10/10 By Czl 新增(aapi010)零用金單據性質維護作業
# Modify.........: No.FUN-6A0055 06/10/25 By ice l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/08 By baogui 結束位置調整
# Modify.........: No.FUN-6A0016 06/11/15 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730073 07/03/20 By Smapmin 修改紅沖輸入否的控管
# Modify.........: No.MOD-740122 07/04/22 By chenl 修正：設定系統自動拋轉總帳,會開出第二組單別,但參數未設定兩套帳。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770005 07/06/25 By ve      報表改為使用crystal report
# Modify.........: No.MOD-7A0206 07/10/31 By chenl   修正sql語句錯誤。
# Modify.........: No.FUN-860107 08/07/31 By sherry  『系統自動拋轉總帳(apyglcr)』 = 'N'時，自動拋轉總帳單別(apyglsp)開放可為輸入
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-8B0087 08/11/19 By chenl    調整"立即審核","拋轉憑証","直接拋轉總賬"，三者可同時勾選，并放開對"總賬單別"的控制。
# Modify.........: No.MOD-8C0218 08/11/23 By chenl    調整FUN-8B0087遺漏功能。
# Modify.........: No.TQC-940056 09/04/22 By Cockroach 當資料有效碼（apyacti)='N'時，不可刪除資料！
#                                                      mark cl_outnam()
# Modify.........: No.MOD-970051 09/07/06 By sabrina (1)CALL q_m_aac()時，第六個參數改傳'0'
#                                                    (2)AFTER FIELD apygslp與AFTER FIELD apygslp1多增加一個判斷條件 aac03='0'
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-990014 09/09/08 By hongmei add apyvcode 申報統編
# Modify.........: No:FUN-990053 09/09/16 By hongmei s_chkban前先检查aza21 = 'Y'
# Modify.........: No.FUN-9B0053 09/11/06 By wujie   5.2SQL转标准语法
# Modify.........: No.FUN-9C0077 09/12/16 By chenmoyan 程式精簡
# Modify.........: No.FUN-A10109 10/02/22 By TSD.zeak 取消編碼方式，單據性質改成動態combobox
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-AC0235 10/12/20 by Dido 由於與 aapi010 共用,因此 g_prog 需轉換 
# Modify.........: No.TQC-AC0352 10/12/24 By yinhy "單別性質"apydmy4增加开窗功能
# Modify.........: No.MOD-B10166 11/01/21 By 檢核統編應用當下輸入資料作檢核 
# Modify.........: No.TQC-B50028 11/05/06 By yinhy 狀態頁簽的“資料建立者”和“資料建立部門”無法下查詢條件查詢資料
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60070 11/06/15 By lixiang  增加單別欄位的控管
# Modify.........: No.MOD-B80313 11/08/29 By Polly 修正AFTER FIELD apygslp/apygslp1長度的抓取，採用aza102長度為主
# Modify.........: No.MOD-BA0163 11/10/25 By Polly 調整單別的輸入長度抓取aza41而非aza102
# Modify.........: No.TQC-BA0167 11/10/27 By lixiang 修正TQC-B60070的錯誤
# Modify.........: No.MOD-C10045 12/01/08 By Dido apyapr 與 apydmy1 不可同時為 'Y' 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C10048 12/02/13 By yinhy 單據性質為35，不可維護apydmy3
# Modify.........: No:FUN-C70075 12/07/19 By xuxz 單據性質為11,12,開放apydmy4
# Modify.........: No:MOD-C70278 12/07/30 By Polly 增加控卡，該單別已存在交易時不可修改
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C70093 12/08/27 By minpp 單據性質為41並且為大陸版時，紅沖可以輸入
# Modify.........: No:FUN-C90028 12/09/24 By xuxz 大陸版應酬申報稅號欄位
# Modify.........: NO.TQC-CC0081 12/12/14 By lutingting apydmy4管控增加21可維護
# Modify.........: No.FUN-D10058 13/03/07 By lujh aza70不勾選時，隱藏apydmy7和35性質的單別

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_apy_t RECORD LIKE apy_file.*,
    g_apy_o RECORD LIKE apy_file.*,
    g_apyslip_t LIKE apy_file.apyslip,
    g_before_input_done LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    g_wc,g_wc2,g_sql    STRING,   #TQC-630166
    g_cnt2              LIKE type_file.num5     # No.FUN-690028 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   g_argv1         LIKE type_file.chr1    #No.FUN-690080
DEFINE   g_str           STRING                 #No.FUN-770005
DEFINE   l_sql           STRING                 #NO.FUN-9B0053 mod
DEFINE   g_comb           ui.ComboBox           #FUN-D10058 add
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)                                                                                                         

   IF g_argv1 = "2" THEN                                                                                                            
      LET g_prog = 'aapi010'                                                                                                        
   ELSE                                                                                                                             
      LET g_prog = 'aapi103'                                                                                                        
   END IF                                                                     
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   INITIALIZE g_apy.* TO NULL
   INITIALIZE g_apy_t.* TO NULL
 
   LET g_forupd_sql = " SELECT * FROM apy_file WHERE apyslip = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE i103_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   IF g_argv1 = "2" THEN                                                                                                            
      OPEN WINDOW i103_w WITH FORM "aap/42f/aapi010"                                                                 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)                                                                  
   ELSE                                                                                                                             
      OPEN WINDOW i103_w WITH FORM "aap/42f/aapi103"                                                                 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)                                                                    
   END IF     
   CALL cl_ui_init()

   #FUN-C90028--add--str
   IF g_argv1 = '2' THEN 
      CALL cl_set_comp_visible('gb10',g_aza.aza26 !='2') #FUN-C90028 add
   ELSE
      CALL cl_set_comp_visible('group02_1',g_aza.aza26 !='2') #FUN-C90028 add
   END IF
   #FUN-C90028--add--end

   #FUN-D10058--add--str--
   IF g_aza.aza26 = '2' AND g_aza.aza70 = 'N' THEN
      CALL cl_set_comp_visible("apydmy7",FALSE)
   END IF
   #FUN-D10058--add--end--

   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("apygslp1",FALSE)
   END IF
 
   IF g_aza.aza26 != '2' THEN
      CALL cl_set_comp_visible("apydmy6",FALSE)
   END IF
 
   LET g_action_choice=""
   CALL i103_menu()
 
   CLOSE WINDOW i103_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i103_cs()
 
   CLEAR FORM
 
   CALL s_getgee(g_prog,g_lang,'apykind') #FUN-A10109
   #FUN-D10058--add--str--
   IF g_aza.aza26 = '2' AND g_aza.aza70 = 'N' THEN
      LET g_comb = ui.ComboBox.forName("apykind")
      CALL g_comb.removeItem('35')
   END IF
   #FUN-D10058--add--end--

   INITIALIZE g_apy.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
       apykind,apyslip,apydesc,apyauno,
       #apydmy2, #FUN-A10109 TSD.zeak
       apydmy4, # No.MOD-4A0253
       apyvcode,                 #FUN-990014 add code
       apyapr,apyprint,apydmy1,apydmy3,apyglcr,apygslp,apygslp1,apydmy5,apydmy6,apydmy7, #FUN-580012  #NO.FUN-670060      #No.FUN-680088  #No.FUN-690090 add apydmy7
       apyuser,apygrup,apymodu,apydate,apyacti,
       apyoriu,apyorig           #TQC-B50028
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('apyuser', 'apygrup')
 
   IF g_argv1 = "2" THEN
      LET g_sql="SELECT apyslip FROM apy_file ", # 組合出 SQL 指令           
            " WHERE ",g_wc CLIPPED,                                            
            "   AND apykind IN ('13','17','25','34') ",                        
            " ORDER BY apyslip"
   ELSE 
      LET g_sql="SELECT apyslip FROM apy_file ", # 組合出 SQL 指令
            " WHERE ",g_wc CLIPPED,
            "   AND apykind NOT IN ('13','17','25','34') ",
            " ORDER BY apyslip"
   END IF
   PREPARE i103_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i103_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i103_prepare
 
  IF g_argv1 = "2" THEN
     LET g_sql= "SELECT COUNT(*) FROM apy_file WHERE ",g_wc CLIPPED,              
             "   AND apykind IN ('13','17','25','34') "
  ELSE
     LET g_sql= "SELECT COUNT(*) FROM apy_file WHERE ",g_wc CLIPPED,
             "   AND apykind NOT IN ('13','17','25','34') "
  END IF
  PREPARE i103_precount FROM g_sql
  DECLARE i103_count CURSOR FOR i103_precount
 
END FUNCTION
 
FUNCTION i103_menu()
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL i103_a()
         END IF
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i103_q()
         END IF
      ON ACTION next
         CALL i103_fetch('N')
      ON ACTION previous
         CALL i103_fetch('P')
      ON ACTION authorization
         IF NOT cl_null(g_apy.apyslip) THEN
            LET g_action_choice="authorization"
            IF cl_chk_act_auth() THEN
               CALL s_smu(g_apy.apyslip,"AAP")  #TQC-660133
            END IF
            LET g_msg = s_smu_d(g_apy.apyslip,"AAP") #TQC-660133 
            DISPLAY g_msg TO smu02_display
         ELSE
            CALL cl_err('','-400',0)
         END IF
      ON ACTION dept_authorization
         IF NOT cl_null(g_apy.apyslip) THEN
            LET g_action_choice="dept_authorization"
            IF cl_chk_act_auth() THEN
               CALL s_smv(g_apy.apyslip,"AAP")  #TQC-660133
            END IF
            LET g_msg = s_smv_d(g_apy.apyslip,"AAP")   #TQC-660133
            DISPLAY g_msg TO smv02_display
         ELSE
            CALL cl_err('','-400',0)
         END IF
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
              CALL i103_u()
         END IF
      ON ACTION invalid
         LET g_action_choice="invalid"
         IF cl_chk_act_auth() THEN
            CALL i103_x()
            CALL cl_set_field_pic("","","","","",g_apy.apyacti)
         END IF
      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL i103_r()
         END IF
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         IF cl_chk_act_auth() THEN
            CALL i103_copy()
         END IF
      ON ACTION output
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
            CALL i103_out()
         END IF
      ON ACTION help
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic("","","","","",g_apy.apyacti)
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT MENU
      ON ACTION jump
         CALL i103_fetch('/')
      ON ACTION first
         CALL i103_fetch('F')
      ON ACTION last
         CALL i103_fetch('L')
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION related_document       #相關文件
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
             IF g_apy.apyslip IS NOT NULL THEN
                LET g_doc.column1 = "apyslip"
                LET g_doc.value1 = g_apy.apyslip
                CALL cl_doc()
             END IF
         END IF
 
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT MENU
 
   END MENU
   CLOSE i103_cs
END FUNCTION
 
FUNCTION i103_a()
 
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   INITIALIZE g_apy.* TO NULL
   LET g_apyslip_t = NULL
   LET g_apy_o.*=g_apy.*
   LET g_apy_t.*=g_apy.*
   LET g_apy.apyatsg= 'Y'
   LET g_apy.apyapr = 'N'
   LET g_apy.apyauno= 'Y'
   LET g_apy.apykind= ' '   #NO:6842
   #LET g_apy.apydmy2= '2'   #NO:6842 #FUN-A10109 TSD.zeak 
   LET g_apy.apydmy1= 'N'   #NO:6842
   LET g_apy.apydmy3= 'N'   #NO:6842
   LET g_apy.apyglcr= 'N'   #NO.FUN-670060
   LET g_apy.apygslp= NULL  #NO.FUN-670060
   LET g_apy.apygslp1= NULL #No.FUN-680088
   LET g_apy.apydmy5= 'N'
   LET g_apy.apydmy6= 'N'   #NO.FUN-580012
   LET g_apy.apydmy7= 'N'   #NO.FUN-690090
   LET g_apy.apyprint = 'N'
   LET g_apy.apyvcode = g_apz.apz63 #FUN-990014 add
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_apy.apyacti ='Y'                   #有效的資料
      LET g_apy.apyuser = g_user
      LET g_apy.apyoriu = g_user #FUN-980030
      LET g_apy.apyorig = g_grup #FUN-980030
      LET g_apy.apygrup = g_grup               #使用者所屬群
      LET g_apy.apydate = g_today
 
      CALL i103_i("a")                      # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         INITIALIZE g_apy.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF g_apy.apyslip IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      INSERT INTO apy_file VALUES(g_apy.*)       # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_apy.apyslip,SQLCA.sqlcode,0)
         CONTINUE WHILE
      ELSE
         #FUN-A10109  ===S===
         CALL s_access_doc('a',g_apy.apyauno,g_apy.apykind,
                           g_apy.apyslip,'AAP',g_apy.apyacti)
         #FUN-A10109  ===E===

         LET g_apy_t.* = g_apy.*                # 保存上筆資料
         SELECT apyslip INTO g_apy.apyslip FROM apy_file
          WHERE apyslip = g_apy.apyslip
      END IF
 
      EXIT WHILE
 
   END WHILE
 
END FUNCTION
 
FUNCTION i103_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,     #No.FUN-690028 VARCHAR(1)
        l_sw            LIKE type_file.chr1,     #判斷重要欄位是否沒有輸入  #No.FUN-690028 VARCHAR(1)
        l_dir1          LIKE type_file.chr1,     # No.FUN-690028 VARCHAR(1),   #判斷CURSOR JUMP DIRECTION
        l_cnt           LIKE type_file.num5,     #No.FUN-690028 SMALLINT
        l_n             LIKE type_file.num5      #No.FUN-690028 SMALLINT
    DEFINE l_i          LIKE type_file.num5      #No.FUN-560150  #No.FUN-690028 SMALLINT
    DEFINE g_dbs_gl     STRING                   #No.FUN-670060
    DEFINE g_plant_gl   STRING                   #No.FUN-980059
    DEFINE l_apy        STRING,                  #No.TQC-B60070
           l_cn         LIKE type_file.num5      #No.TQC-B60070
    DEFINE g_doc_len2   LIKE type_file.num5      #No.MOD-B80313 add
    DEFINE lc_doc_set   LIKE aza_file.aza41      #No.MOD-B80313 add 
    DEFINE l_apyname    LIKE apy_file.apydesc    #FUN-C70075 add
    DEFINE l_len        LIKE type_file.num10     #MOD-C70278 add

    INPUT BY NAME g_apy.apyoriu,g_apy.apyorig,
        g_apy.apykind,g_apy.apyslip,g_apy.apydesc,g_apy.apyauno,
        #g_apy.apydmy2, #FUN-A10109 TSD.zeak 
        g_apy.apydmy4,g_apy.apyvcode,g_apy.apyapr,  # No.MOD-4A0253 #FUN-990014 add code
        g_apy.apyprint,g_apy.apydmy1,g_apy.apydmy3,g_apy.apyglcr,g_apy.apygslp,g_apy.apygslp1,g_apy.apydmy5,g_apy.apydmy6,g_apy.apydmy7, #FUN-580012   #NO.FUN-670060      #No.FUN-680088  #No.FUN-690090 add apydmy7
        g_apy.apyuser,g_apy.apygrup,g_apy.apymodu,g_apy.apydate,g_apy.apyacti
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i103_set_entry(p_cmd)
         CALL i103_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
        #--------No.MOD-B80313-------------------start
         LET lc_doc_set = g_aza.aza102
         CASE lc_doc_set
            WHEN "1"   LET g_doc_len = 3
            WHEN "2"   LET g_doc_len = 4
            WHEN "3"   LET g_doc_len = 5
         END CASE
        #--------No.MOD-B80313-------------------end
        #CALL cl_set_doctype_format("apyslip")         #No.MOD-BA0163 移至aza41後
         CALL cl_set_doctype_format("apygslp")         #No.TQC-B60070
         CALL cl_set_doctype_format("apygslp1")        #No.TQC-B60070
        #--------No.MOD-B80313-------------------start
         LET lc_doc_set = g_aza.aza41
         CASE lc_doc_set
            WHEN "1"   LET g_doc_len = 3
            WHEN "2"   LET g_doc_len = 4
            WHEN "3"   LET g_doc_len = 5
         END CASE
        #--------No.MOD-B80313-------------------end
         CALL cl_set_doctype_format("apyslip")         #MOD-BA0163 add

    AFTER FIELD apyslip    #單別, 不可空白, 不可重複
        IF cl_null(g_apy_o.apyslip) OR                #若輸入
            g_apy.apyslip != g_apy_o.apyslip THEN    #更改鍵值
            IF p_cmd='a' OR
            (p_cmd='u' AND g_apy.apyslip != g_apy_t.apyslip) THEN
                #檢查是否重複
                SELECT count(*) INTO l_n FROM apy_file
                    WHERE apyslip=g_apy.apyslip
                IF l_n > 0 THEN    #Duplicated
                    CALL cl_err(g_apy.apyslip,-239,0)
                    LET g_apy.apyslip = g_apy_o.apyslip
                    DISPLAY BY NAME g_apy.apyslip
                    NEXT FIELD apyslip
                END IF
                SELECT count(*) INTO l_n FROM ooy_file #檢查是否和axri010單別
                    WHERE ooyslip=g_apy.apyslip        #重覆
                IF l_n > 0 THEN    #Duplicated
                    CALL cl_err(g_apy.apyslip,'axr-909',0)
                    LET g_apy.apyslip = g_apy_o.apyslip
                    DISPLAY BY NAME g_apy.apyslip
                    NEXT FIELD apyslip
                END IF
            FOR l_i = 1 TO g_doc_len
               IF cl_null(g_apy.apyslip[l_i,l_i]) THEN
                  CALL cl_err('','sub-146',0)
                  LET g_apy.apyslip = g_apy_o.apyslip
                  NEXT FIELD apyslip
               END IF
            END FOR
            END IF
        END IF
 
    BEFORE FIELD apykind  
        CALL s_getgee(g_prog,g_lang,'apykind') #FUN-A10109
        CALL i103_set_entry(p_cmd)   
        #FUN-D10058--add--str--
        IF g_aza.aza26 = '2' AND g_aza.aza70 = 'N' THEN
           LET g_comb = ui.ComboBox.forName("apykind")
           CALL g_comb.removeItem('35')
        END IF
        #FUN-D10058--add--end--
 
    AFTER FIELD apykind
       #IF g_apy_o.apykind IS NULL OR                #若輸入               #MOD-C70278 mark
       #    g_apy.apykind != g_apy_o.apykind THEN    #更改鍵值             #MOD-C70278 mark
       #    IF p_cmd='a' OR                                                #MOD-C70278 mark
       #       (p_cmd='u' AND g_apy.apykind != g_apy_t.apykind) THEN       #MOD-C70278 mark
               #FUN-A10109    START  
               #CALL i103_kind('a')
               #IF NOT cl_null(g_errno) THEN    #有誤
               #    CALL cl_err(g_apy.apykind,g_errno,0)
               #    LET g_apy.apykind = g_apy_o.apykind
               #    DISPLAY BY NAME g_apy.apykind
               #    NEXT FIELD apykind
               #END IF
               #FUN-A10109    END
       #    END IF                                                         #MOD-C70278 mark
       #END IF                                                             #MOD-C70278 mark
       #LET g_apy_o.apykind = g_apy.apykind                                    #MOD-C70278 mark
       #--------------------MOD-C70278---------------------------(S)
        IF p_cmd='u' AND g_apy.apykind != g_apy_o.apykind THEN
           LET l_n = 0
           LET l_len = 0
           LET l_len = length(g_apy.apyslip)
           CASE WHEN (g_apy_o.apykind MATCHES '1*' OR g_apy_o.apykind MATCHES '2*')
                     LET l_sql = "SELECT COUNT(*) FROM apa_file ",
                                 " WHERE apa01[1,",l_len,"] = '",g_apy.apyslip,"'"
                WHEN (g_apy_o.apykind MATCHES '3*')
                     LET l_sql = "SELECT COUNT(*) FROM apf_file ",
                                 " WHERE apf01[1,",l_len,"] = '",g_apy.apyslip,"'"
                WHEN (g_apy_o.apykind MATCHES '4*')
                     LET l_sql = "SELECT COUNT(*) FROM aqa_file ",
                                 " WHERE aqa01[1,",l_len,"] = '",g_apy.apyslip,"'"
           END CASE
           PREPARE i103_apy_pre FROM l_sql
           DECLARE i103_apy_cur CURSOR FOR i103_apy_pre
           OPEN i103_apy_cur
           FETCH i103_apy_cur INTO l_n
           IF l_n > 0 THEN
              CALL cl_err("",'aap-171',0)
              LET g_apy.apykind = g_apy_o.apykind
              DISPLAY BY NAME g_apy.apykind
              NEXT FIELD apykind
           ELSE
              LET g_apy_o.apykind = g_apy.apykind
           END IF
        END IF
       #--------------------MOD-C70278---------------------------(E)
        IF g_argv1 = '1' THEN
          IF g_apy.apykind = '35' THEN
             LET g_apy.apydmy3 = 'N'
             DISPLAY BY NAME g_apy.apydmy3
          ELSE
             LET g_apy.apydmy7 = 'N'
             DISPLAY BY NAME g_apy.apydmy7
          END IF
        END IF
        CALL i103_set_entry(p_cmd)   
        CALL i103_set_no_entry(p_cmd)   
 
    ON CHANGE apykind
       CALL i103_set_entry(p_cmd)  
       CALL i103_set_no_entry(p_cmd)
       IF g_apy.apydmy3='N' OR g_apy.apykind[1,1]!='2' THEN 
          LET g_apy.apydmy6='N' 
          DISPLAY BY NAME g_apy.apydmy6  
       END IF  
 
 
    AFTER FIELD apydmy4
        IF NOT cl_null(g_apy.apydmy4) THEN
           IF g_argv1 = "2" THEN
             SELECT count(*) INTO g_cnt FROM apy_file                           
              WHERE apyslip = g_apy.apydmy4                                     
                AND (apykind = '25')
           ELSE 
             SELECT count(*) INTO g_cnt FROM apy_file
              WHERE apyslip = g_apy.apydmy4
                AND (apykind = '23' OR apykind ='24'  OR apykind = '33')  #FUN-C70075 add 33
           END IF
             IF g_cnt = 0 THEN
                CALL cl_err(g_apy.apydmy4,'aap-010',0)
                NEXT FIELD apydmy4
             END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM apy_file
             WHERE apydmy4 = g_apy.apydmy4
            IF g_apy.apykind <> '11' AND g_apy.apykind <> '12' AND g_apy.apykind <> '21' THEN  #TQC-CC0081
               IF g_apy_t.apydmy4 = g_apy.apydmy4 THEN
                  IF l_cnt > 1 THEN
                     CALL cl_err('','aap-802',0)
                     NEXT FIELD apydmy4
                  END IF
               ELSE
                  IF l_cnt > 0 THEN
                     CALL cl_err('','aap-802',0)
                     NEXT FIELD apydmy4
                  END IF
               END IF
            END IF  #TQC-CC0081
        END IF
        
     AFTER FIELD apyvcode
       IF NOT cl_null(g_apy.apyvcode) THEN 
          SELECT COUNT(*) INTO g_cnt FROM ama_file
             WHERE ama02 = g_apy.apyvcode
          IF g_cnt = 0 THEN 
             CALL cl_err("","mfg9329",1) 
          END IF
         #IF g_aza.aza21 = 'Y' AND NOT s_chkban(g_apz.apz63) THEN #FUN-990053 mod #MOD-B10166 mark
          IF g_aza.aza21 = 'Y' AND NOT s_chkban(g_apy.apyvcode) THEN              #MOD-B10166
          END IF
       END IF    
    
   #-MOD-C10045-add-
    AFTER FIELD apyapr
       IF NOT cl_null(g_apy.apyapr)  THEN
          IF g_apy.apyapr NOT MATCHES'[YyNn]' THEN
             CALL cl_err(g_apy.apyapr ,'mfg3017',0)
             LET g_apy.apyapr  = g_apy_o.apyapr
             DISPLAY BY NAME g_apy.apyapr
             NEXT FIELD apyapr
          END IF
          IF g_apy.apydmy1 = 'Y' AND g_apy.apyapr = 'Y' THEN
             CALL cl_err('','axm-066',0) 
             LET g_apy.apyapr = 'N'
             DISPLAY BY NAME g_apy.apyapr
             NEXT FIELD apyapr
          END IF
       END IF
   #-MOD-C10045-end-

    AFTER FIELD apydmy1
      IF NOT cl_null(g_apy.apydmy1)  THEN
        IF g_apy.apydmy1  NOT MATCHES'[YyNn]' THEN
            CALL cl_err(g_apy.apydmy1 ,'mfg3017',0)
            LET g_apy.apydmy1  = g_apy_o.apydmy1
            DISPLAY BY NAME g_apy.apydmy1
            NEXT FIELD apydmy1
        END IF
        #-MOD-C10045-add-
          IF g_apy.apydmy1 = 'Y' AND g_apy.apyapr = 'Y' THEN
             CALL cl_err('','axm-066',0) 
             LET g_apy.apydmy1 = 'N'
             DISPLAY BY NAME g_apy.apydmy1
             NEXT FIELD apydmy1
          END IF
        #-MOD-C10045-end-
        LET l_dir1 = 'D'
        LET g_apy_o.apydmy1  = g_apy.apydmy1
      END IF
 
    AFTER FIELD apydmy3
      IF NOT cl_null(g_apy.apydmy3)   THEN
        IF g_apy.apydmy3  NOT MATCHES'[YyNn]' THEN
            CALL cl_err(g_apy.apydmy3 ,'mfg3017',0)
            LET g_apy.apydmy3  = g_apy_o.apydmy3
            DISPLAY BY NAME g_apy.apydmy3
            NEXT FIELD apydmy3
        END IF
        IF g_apy_t.apydmy3='Y' AND g_apy.apydmy3='N' THEN
           LET l_sql="SELECT COUNT(*) FROM apa_file ",
           " WHERE apa01[1,",g_doc_len,"]='",g_apy.apyslip,"' AND apa44 IS NOT NULL " #No.FUN-9B0053   
          
           PREPARE i300_count1  FROM l_sql
           EXECUTE i300_count1 INTO g_cnt
           LET l_sql="SELECT COUNT(*) FROM apf_file ",
           " WHERE apf01[1,",g_doc_len,"]='",g_apy.apyslip,"' AND apf44 IS NOT NULL " #No.FUN-9B0053
      
           PREPARE i300_count2  FROM l_sql
           EXECUTE i300_count2 INTO g_cnt2  
           IF g_cnt+g_cnt2 > 0 THEN
              CALL cl_err('','aap-764',0) NEXT FIELD apydmy3
           END IF
        END IF
        
                       
        LET l_dir1 = 'D'
        LET g_apy_o.apydmy3  = g_apy.apydmy3
      END IF
     ON CHANGE apydmy3	
      IF g_apy.apydmy3="N" THEN                                                 
         LET g_apy.apyglcr="N"        
       # LET g_apy.apygslp=NULL        #No.TQC-B60070    #No.TQC-BA0167 mark
       # LET g_apy.apygslp1=NULL       #No.TQC-B60070    #No.TQC-BA0167 mark                               
         DISPLAY BY NAME g_apy.apyglcr #,g_apy.apygslp,g_apy.apygslp1  #No.TQC-BA0167 mark
      END IF   
      CALL i103_set_entry(p_cmd)
      CALL i103_set_no_entry(p_cmd)  
      IF g_apy.apydmy3='N' OR g_apy.apykind[1,1]!='2' THEN 
         LET g_apy.apydmy6='N' 
         DISPLAY BY NAME g_apy.apydmy6  
      END IF  
 
    ON CHANGE apyglcr
       #IF g_apy.apyglcr='Y' THEN LET g_apy.apydmy3='Y' END IF                            #TQC-C10048 mark
       IF g_apy.apyglcr='Y' AND g_apy.apykind != '35'  THEN LET g_apy.apydmy3='Y' END IF  #TQC-C10048
       DISPLAY BY NAME g_apy.apydmy3
    
    AFTER FIELD apyglcr
         IF g_apy.apyglcr="N" THEN
         #  LET g_apy.apygslp=NULL        #No.TQC-B60070      #No.TQC-BA0167 mark
         #  LET g_apy.apygslp1=NULL       #No.TQC-B60070      #No.TQC-BA0167 mark
            DISPLAY BY NAME g_apy.apygslp
            DISPLAY BY NAME g_apy.apygslp1      #No.FUN-680088
            CALL i103_set_no_entry(p_cmd) 
         END IF 
         IF g_apy.apyglcr="Y" THEN
            CALL cl_set_comp_required("apygslp",TRUE)
            IF g_aza.aza63 = 'Y' THEN 
               CALL cl_set_comp_required("apygslp1",TRUE)
            END IF
         ELSE 
         	  CALL cl_set_comp_required("apygslp",FALSE)
         	  IF g_aza.aza63 = 'Y' THEN 
               CALL cl_set_comp_required("apygslp1",FALSE)
            END IF   
         END IF 
    AFTER FIELD apygslp
         IF NOT cl_null(g_apy.apygslp)  THEN
            SELECT aac01 FROM aac_file
                   WHERE aac01=g_apy.apygslp AND aacacti = 'Y' AND aac11 = '1'
                     AND aac03 = '0'        #MOD-970051 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aac_file",g_apy.apygslp,"",SQLCA.sqlcode,"","",1)
               NEXT FIELD apygslp
            END IF 
           #--------No.MOD-B80313-------------------start
            LET lc_doc_set = g_aza.aza102
            CASE lc_doc_set
               WHEN "1"   LET g_doc_len2 = 3
               WHEN "2"   LET g_doc_len2 = 4
               WHEN "3"   LET g_doc_len2 = 5
            END CASE
           #--------No.MOD-B80313-------------------end
            #No.TQC-B60070--add--
            LET l_apy=g_apy.apygslp
            LET l_cn=l_apy.getlength()
           #IF l_cn=g_doc_len THEN                 #No.MOD-B80313 mark
            IF l_cn=g_doc_len2 THEN                #No.MOD-B80313 add
              #FOR l_i = 1 TO g_doc_len            #No.MOD-B80313 mark
               FOR l_i = 1 TO g_doc_len2           #No.MOD-B80313 add
                  IF cl_null(g_apy.apygslp[l_i,l_i]) THEN
                     CALL cl_err(g_apy.apygslp,'sub-146',0)
                     NEXT FIELD apygslp
                  END IF
               END FOR
            ELSE
               CALL cl_err(g_apy.apygslp,'sub-146',0)
               NEXT FIELD apygslp 
            END IF
            #No.TQC-B60070--end--
         END IF  
 
    AFTER FIELD apygslp1
         IF NOT cl_null(g_apy.apygslp1)  THEN
            SELECT aac01 FROM aac_file
                   WHERE aac01=g_apy.apygslp1 AND aacacti = 'Y' AND aac11 = '1'
                     AND aac03 = '0'        #MOD-970051 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","aac_file",g_apy.apygslp1,"",SQLCA.sqlcode,"","",1)
               NEXT FIELD apygslp1
            END IF
           #--------No.MOD-B80313-------------------start
            LET lc_doc_set = g_aza.aza102
            CASE lc_doc_set
               WHEN "1"   LET g_doc_len2 = 3
               WHEN "2"   LET g_doc_len2 = 4
               WHEN "3"   LET g_doc_len2 = 5
            END CASE
           #--------No.MOD-B80313-------------------end
            #No.TQC-B60070--add--
            LET l_apy=g_apy.apygslp1
            LET l_cn=l_apy.getlength()
           #IF l_cn=g_doc_len THEN                   #No.MOD-B80313 mark
            IF l_cn=g_doc_len2 THEN                  #No.MOD-B80313 add
              #FOR l_i = 1 TO g_doc_len              #No.MOD-B80313 mark
               FOR l_i = 1 TO g_doc_len2             #No.MOD-B80313 add
                  IF cl_null(g_apy.apygslp1[l_i,l_i]) THEN
                     CALL cl_err(g_apy.apygslp1,'sub-146',0)
                     NEXT FIELD apygslp1
                  END IF
               END FOR
            ELSE
               CALL cl_err(g_apy.apygslp1,'sub-146',0)
               NEXT FIELD apygslp1
            END IF
            #No.TQC-B60070--end-- 
         END IF  
 
    BEFORE FIELD apydmy7                                                                                                            
        CALL i103_set_entry(p_cmd) 
        CALL i103_set_no_entry(p_cmd) 
 
        ON ACTION controlp                                                      
           CASE                                                                 
               WHEN INFIELD(apygslp)                
                    # 得出總帳 database name                                                                                                
                     LET g_plant_new= g_apz.apz02p
                     CALL s_getdbs()                                                                                                        
                     LET g_dbs_gl=g_dbs_new CLIPPED                                                                                         
                     LET g_plant_gl = g_apz.apz02p    #No.FUN-980059
                    IF g_aaz.aaz70 MATCHES '[yY]' THEN                          
                       CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_apy.apygslp,'1','0',g_user,'AGL')     #MOD-970051 add #No.FUN-980059
                       RETURNING g_apy.apygslp                          
                    ELSE                                                        
                       CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_apy.apygslp,'1','0',' ','AGL')        #MOD-970051 add #No.FUN-980059
                       RETURNING g_apy.apygslp                          
                    END IF                                                      
                    DISPLAY BY NAME g_apy.apygslp                       
                    NEXT FIELD apygslp                                          
               WHEN INFIELD(apygslp1)
                    # 得出總帳 database name                                                                                                
                     LET g_plant_new= g_apz.apz02p
                     CALL s_getdbs()                                                                                                        
                     LET g_dbs_gl=g_dbs_new CLIPPED                                                                                         
                    IF g_aaz.aaz70 MATCHES '[yY]' THEN                          
                       CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_apy.apygslp1,'1','0',g_user,'AGL')    #MOD-970051 add #No.FUN-980059
                       RETURNING g_apy.apygslp1                          
                    ELSE                                                        
                       CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_apy.apygslp1,'1','0',' ','AGL')       #MOD-970051 add #No.FUN-980059
                       RETURNING g_apy.apygslp1                          
                    END IF                                                      
                    DISPLAY BY NAME g_apy.apygslp1                       
                    NEXT FIELD apygslp1                                          
               WHEN INFIELD(apyvcode)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ama02"
                    LET g_qryparam.default1 = g_apy.apyvcode
                    CALL cl_create_qry() RETURNING g_apy.apyvcode
                    DISPLAY BY NAME g_apy.apyvcode
                    NEXT FIELD apyvcode
               #No.TQC-AC0352  --Begin
               WHEN INFIELD(apydmy4)
                    IF g_argv1 = "2" THEN
                       CALL q_apy(FALSE,FALSE,g_apy.apydmy4,'25','AAP') RETURNING g_apy.apydmy4
                    ELSE
                      #FUN-C70075--add--str
                       IF g_apy.apykind = '11' OR g_apy.apykind = '12' OR g_apy.apykind = '21' THEN  #TQC-CC0081
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_apy8"
                          LET g_qryparam.arg1 = "33"
                          LET g_qryparam.default1 = g_apy.apydmy4
                          CALL cl_create_qry() RETURNING g_apy.apydmy4,l_apyname
                       ELSE
                      #FUN-C70075--add--end
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_apy9"
                          LET g_qryparam.default1 = g_apy.apydmy4
                          CALL cl_create_qry() RETURNING g_apy.apydmy4
                       END IF #FUN-C70075 add
                    END IF
                    DISPLAY BY NAME g_apy.apydmy4
                    NEXT FIELD apydmy4
               OTHERWISE EXIT CASE                                              
               #No.TQC-AC0352  --End
           END CASE   
      
    AFTER INPUT
       LET g_apy.apyuser = s_get_data_owner("apy_file") #FUN-C10039
       LET g_apy.apygrup = s_get_data_group("apy_file") #FUN-C10039
        IF INT_FLAG THEN EXIT INPUT END IF
        LET l_sw = 'N'
        IF g_apy.apyauno IS NULL THEN   #自動編號否
            DISPLAY BY NAME g_apy.apyauno
            LET l_sw = 'Y'
        END IF
        IF g_apy.apykind IS NULL THEN     #簽核處理
            DISPLAY BY NAME g_apy.apykind
            LET l_sw = 'Y'
        END IF
        IF g_apy.apyprint IS NULL THEN   #直接列印
            DISPLAY BY NAME g_apy.apyprint
            LET l_sw = 'Y'
        END IF
        IF g_apy.apydmy1  IS NULL THEN   #直接確認
            DISPLAY BY NAME g_apy.apydmy1
            LET l_sw = 'Y'
        END IF
        IF l_sw = 'Y' THEN
            LET l_sw = 'N'
            CALL cl_err('','9033',0)
            NEXT FIELD apyslip
        END IF
 
                                                                       
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
 
FUNCTION i103_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apyslip",TRUE)
   END IF
   IF INFIELD(apykind) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apydmy4",TRUE)
   END IF
  #IF g_apy.apykind[1,1] = '2' AND g_apy.apydmy3 = 'Y' THEN    #MOD-730073   #FUN-C70093 
   IF (g_apy.apykind[1,1] = '2' OR g_apy.apykind='41') AND g_apy.apydmy3 = 'Y' THEN  #FUN-C70093
      CALL cl_set_comp_entry("apydmy6",TRUE)  #FUN-580012
   END IF   #MOD-730073
 
   IF g_apy.apykind = '35' THEN
      CALL cl_set_comp_entry("apydmy7",TRUE)
   ELSE
      CALL cl_set_comp_entry("apydmy3",TRUE)
   END IF
END FUNCTION
 
FUNCTION i103_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("apyslip",FALSE)
   END IF
 
   IF INFIELD(apykind) OR (NOT g_before_input_done) THEN
    IF g_argv1 = "2" THEN
      IF g_apy.apykind != '17'  THEN                                            
         CALL cl_set_comp_entry("apydmy4",FALSE)
      END IF
    ELSE
      IF g_apy.apykind != '15' AND g_apy.apykind != '33'  AND g_apy.apykind != '11' AND g_apy.apykind != '12' AND g_apy.apykind != '21' THEN#FUN-C70075 add 11,12 #TQC-CC0081 add 21
         CALL cl_set_comp_entry("apydmy4",FALSE)
      END IF
    END IF
   END IF
   
   #FUN-C70093--MOD--STR
   #IF g_apy.apykind[1,1]!='2'  OR g_apy.apydmy3 ='N' THEN     
   #   CALL cl_set_comp_entry("apydmy6",FALSE)
   #END IF
   IF g_apy.apydmy3 ='Y' THEN
      IF g_apy.apykind != '41'  AND g_apy.apykind[1,1] !='2'  THEN
         CALL cl_set_comp_entry("apydmy6",FALSE)
      END IF
   ELSE
      CALL cl_set_comp_entry("apydmy6",FALSE)
   END IF
   #FUN-C70093--MOD--END

   IF g_apy.apykind = '35' THEN
      CALL cl_set_comp_entry("apydmy3",FALSE)
   ELSE
      CALL cl_set_comp_entry("apydmy7",FALSE)
   END IF
END FUNCTION
 
FUNCTION i103_kind(p_cmd)
    DEFINE
           p_cmd LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           l_str LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(200)
           l_cnt LIKE type_file.num5     #No.FUN-690028 SMALLINT
 IF  g_argv1 = "2" THEN 
    LET l_str = '13,17,25,34'
 ELSE
    LET l_str = '11,12,13,14,15,16,21,22,23,24,26,33,35,41'   #No.B564 mod   #FUN-680110
 END IF
    LET g_errno = 'afa-095'
    FOR l_cnt = 1 TO 61 STEP 3
        IF g_apy.apykind = l_str[l_cnt,l_cnt+1] THEN
            LET g_errno = ' '
            EXIT FOR
        END IF
    END FOR
END FUNCTION
 
FUNCTION i103_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_apy.* TO NULL              #No.FUN-6A0016
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i103_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i103_count
    FETCH i103_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i103_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_apy.apyslip,SQLCA.sqlcode,0)
        INITIALIZE g_apy.* TO NULL
    ELSE
        CALL i103_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i103_fetch(p_flapy)
    DEFINE
        p_flapy         LIKE type_file.chr1,   # No.FUN-690028 VARCHAR(1),
        l_abso          LIKE type_file.num10   #No.FUN-690028 INTEGER
 
    CASE p_flapy
        WHEN 'N' FETCH NEXT     i103_cs INTO g_apy.apyslip
        WHEN 'P' FETCH PREVIOUS i103_cs INTO g_apy.apyslip
        WHEN 'F' FETCH FIRST    i103_cs INTO g_apy.apyslip
        WHEN 'L' FETCH LAST     i103_cs INTO g_apy.apyslip
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
            FETCH ABSOLUTE g_jump i103_cs INTO g_apy.apyslip
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_apy.apyslip,SQLCA.sqlcode,0)
       INITIALIZE g_apy.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flapy
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_apy.* FROM apy_file            # 重讀DB,因TEMP有不被更新特性
       WHERE apyslip = g_apy.apyslip
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_apy.apyslip,SQLCA.sqlcode,0)
    ELSE
       LET g_data_owner = g_apy.apyuser     #No.FUN-4C0047
       LET g_data_group = g_apy.apygrup     #No.FUN-4C0047
       CALL i103_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i103_show()
    LET g_apy_t.* = g_apy.*
     DISPLAY BY NAME g_apy.apyoriu,g_apy.apyorig,                                          # No.MOD-4A0253
        g_apy.apyslip,g_apy.apydesc,g_apy.apyauno,
        #g_apy.apydmy2, #FUN-A10109 TSD.zeak
        g_apy.apykind,g_apy.apydmy4,g_apy.apyvcode,     #FUN-990014 add code
        g_apy.apyapr,g_apy.apyprint,g_apy.apydmy1,
        g_apy.apydmy3,g_apy.apyglcr,g_apy.apygslp,g_apy.apygslp1,           #NO.FUN-670060      #No.FUN-680088
        g_apy.apydmy5,g_apy.apydmy6,g_apy.apydmy7, #FUN-580012 #No.FUN-690090 add apydmy7
        g_apy.apyuser,g_apy.apygrup,g_apy.apymodu,g_apy.apydate,
        g_apy.apyacti
    LET g_msg = s_smu_d(g_apy.apyslip,"AAP")  #TQC-660133
    DISPLAY g_msg TO smu02_display
    LET g_msg = s_smv_d(g_apy.apyslip,"AAP")            #TQC-660133 
    DISPLAY g_msg TO smv02_display
    CALL cl_set_field_pic("","","","","",g_apy.apyacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i103_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_apy.apyslip IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_apy.* FROM apy_file
     WHERE apyslip=g_apy.apyslip
    IF g_apy.apyacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_apy.apyslip,9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_apyslip_t = g_apy.apyslip
    BEGIN WORK
 
    OPEN i103_cl USING g_apy.apyslip
    IF STATUS THEN
       CALL cl_err("OPEN i103_cl:", STATUS, 1)
       CLOSE i103_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i103_cl INTO g_apy.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_apy.apyslip,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_apy.apymodu=g_user                     #修改者
    LET g_apy.apydate = g_today                  #修改日期
    CALL i103_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_apy_o.* = g_apy.*
        LET g_apy_t.* = g_apy.*
        CALL i103_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_apy.*=g_apy_t.*
            CALL i103_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE apy_file SET apy_file.* = g_apy.*    # 更新DB
         WHERE apyslip = g_apy_t.apyslip             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_apy.apyslip,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        #FUN-A10109  ===S===
        CALL s_access_doc('u',g_apy.apyauno,g_apy.apykind,
                          g_apy_t.apyslip,'AAP',g_apy.apyacti)
        #FUN-A10109 ===E===
        EXIT WHILE
    END WHILE
    CLOSE i103_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i103_x()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_apy.apyslip IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
      BEGIN WORK
 
    OPEN i103_cl USING g_apy.apyslip
    IF STATUS THEN
       CALL cl_err("OPEN i103_cl:", STATUS, 1)
       CLOSE i103_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i103_cl INTO g_apy.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_apy.apyslip,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i103_show()
    IF cl_exp(15,21,g_apy.apyacti) THEN
        LET g_chr=g_apy.apyacti
        IF g_apy.apyacti='Y' THEN
            LET g_apy.apyacti='N'
        ELSE
            LET g_apy.apyacti='Y'
        END IF
        UPDATE apy_file
            SET apyacti=g_apy.apyacti,
               apymodu=g_user, apydate=g_today
            WHERE apyslip = g_apy.apyslip
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_apy.apyslip,SQLCA.sqlcode,0)
            LET g_apy.apyacti=g_chr
        END IF
        #FUN-A10109  ===S===
        CALL s_access_doc('u',g_apy.apyauno,g_apy.apykind,
                          g_apy.apyslip,'AAP',g_apy.apyacti)
        #FUN-A10109 ===E===
        DISPLAY BY NAME g_apy.apyacti
    END IF
    CLOSE i103_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i103_r()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_apy.apyslip IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    IF g_apy.apyacti = 'N' THEN                                                                                                     
       CALL cl_err('','abm-950',0)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
 
      BEGIN WORK
 
    OPEN i103_cl USING g_apy.apyslip
    IF STATUS THEN
       CALL cl_err("OPEN i103_cl:", STATUS, 1)
       CLOSE i103_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i103_cl INTO g_apy.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_apy.apyslip,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i103_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL            #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "apyslip"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_apy.apyslip      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
       DELETE FROM apy_file WHERE apyslip = g_apy.apyslip
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err(g_apy.apyslip,SQLCA.sqlcode,0)
       ELSE
          #FUN-A10109  ===S===
          CALL s_access_doc('r','','',g_apy.apyslip,'AAP','')
          #FUN-A10109  ===E===
          CLEAR FORM
          OPEN i103_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i103_cl
             CLOSE i103_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          FETCH i103_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i103_cl
             CLOSE i103_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i103_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i103_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET g_no_ask = TRUE
             CALL i103_fetch('/')
          END IF
       END IF
    END IF
    DELETE FROM smv_file WHERE smv01 = g_apy.apyslip AND upper(smv03)='AAP'
    IF SQLCA.SQLCODE THEN
       CALL cl_err('smv_file',SQLCA.sqlcode,0)
    END IF
    DELETE FROM smu_file WHERE smu01 = g_apy.apyslip AND upper(smu03)='AAP'
   IF SQLCA.SQLCODE THEN
       CALL cl_err('smu_file',SQLCA.sqlcode,0)
    END IF
    CLOSE i103_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i103_copy()
    DEFINE
        l_n             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_newno         LIKE apy_file.apyslip,
        l_oldno         LIKE apy_file.apyslip
    DEFINE l_i          LIKE type_file.num5     #No.FUN-560150  #No.FUN-690028 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF  g_apy.apyslip IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i103_set_entry('a')
    CALL i103_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM apyslip
 
        BEFORE FIELD apyslip
           CALL cl_set_doctype_format("apyslip")
 
        AFTER FIELD apyslip
            IF l_newno IS NULL THEN
                NEXT FIELD apyslip
            END IF
            SELECT count(*) INTO g_cnt FROM apy_file
                WHERE apyslip = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD apyslip
            END IF
            FOR l_i = 1 TO g_doc_len
               IF cl_null(l_newno[l_i,l_i]) THEN
                  CALL cl_err('','sub-146',0)
                  NEXT FIELD apyslip
               END IF
            END FOR
 
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
        DISPLAY BY NAME g_apy.apyslip
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM apy_file
        WHERE apyslip = g_apy.apyslip
        INTO TEMP x
    UPDATE x
        SET apyslip=l_newno,   #資料鍵值
            apyuser=g_user,   #資料所有者
            apygrup=g_grup,   #資料所有者所屬群
            apymodu=NULL,     #資料修改日期
            apydate=g_today,  #資料建立日期
            apyacti='Y'       #有效資料
    INSERT INTO apy_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_apy.apyslip,SQLCA.sqlcode,0)
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno= g_apy.apyslip
        SELECT apy_file.* INTO g_apy.* FROM apy_file
               WHERE apyslip =  l_newno
        #FUN-A10109  ===S===
        CALL s_access_doc('a',g_apy.apyauno,g_apy.apykind,
                          g_apy.apyslip,'AAP',g_apy.apyacti)
        #FUN-A10109  ===E===
        CALL  i103_u()
        CALL i103_show()
        #FUN-C30027---begin
        #LET g_apy.apyslip = l_oldno
        #SELECT apy_file.* INTO g_apy.* FROM apy_file
        #       WHERE apyslip = g_apy.apyslip
        #CALL i103_show()
        #FUN-C30027---end
    END IF
    DISPLAY BY NAME g_apy.apyslip
END FUNCTION
 
FUNCTION i103_out()                                                                                                                 
   DEFINE                                                                                                                           
      sr   RECORD LIKE apy_file.*,                                                                                                  
      l_i             LIKE type_file.num5,      #No.FUN-690028 SMALLINT
      l_name          LIKE type_file.chr20,     # External(Disk) file name    #No.FUN-690028 VARCHAR(20)
      l_chr           LIKE type_file.chr1       #No.FUN-690028 VARCHAR(1)
   DEFINE   l_prog    LIKE zz_file.zz01         #MOD-AC0235
                                                                                                                                    
   IF g_wc IS NULL THEN                                                                                                             
      CALL cl_err('','9057',0)                                                                                                      
      RETURN                                                                                                                        
   END IF                                                                                                                           
                                                                                                                                    
   CALL cl_wait()                                                                                                                   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang                                                                      
                                                                                                                                    
   IF g_argv1 = "2" THEN
      LET g_sql="SELECT * FROM apy_file ",          # 組合出 SQL 指令                                                                  
                " WHERE ",g_wc CLIPPED," ",                                                                                                 
                "   AND apykind IN ('13','17','25','34') "
   ELSE
      LET g_sql="SELECT * FROM apy_file ",          # 組合出 SQL 指令                                                                  
                " WHERE ",g_wc CLIPPED," ",                                                                                                 
                "   AND apykind NOT IN ('13','17','25','34') "
   END IF
   LET g_str=g_wc   

   LET l_prog = g_prog                                             #MOD-AC0235
   LET g_prog = 'aapi103'                                          #MOD-AC0235
   CALL cl_prt_cs1('aapi103','aapi103',g_sql,g_str)                #NO.Fun-770005                                                                                                                                     
   LET g_prog = l_prog                                             #MOD-AC0235 

END FUNCTION                        
#No.FUN-9C0077 程式精簡

