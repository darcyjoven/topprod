# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axci400.4gl
# Descriptions...: 在製開帳金額維護作業
# Date & Author..: 95/10/18 By Roger
# Modify.........: No.MOD-4C0005 04/12/01 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-4C0099 05/01/07 By kim 報表轉XML功能
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-610080 06/01/23 By Sarah 
#                  1.以傳入參數g_argv1判斷,g_argv1=1執行axci400,g_argv1=2執行axci402
#                  2.增加ccf00(開帳類別),axci400時寫入ccf00='1',axci402時寫入ccf00='2',LET ccf01=ccf04,隱藏ccf01
#                  3.ccf04(元件料號)增加開窗功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7B0218 07/11/26 By Carol add工單編號欄位開窗查詢
# Modify.........: No.FUN-7C0101 08/01/14 By Zhangyajun 成本改善增加ccf06(成本計算類別),ccf07(類別編號)和各種制費
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830135 08/03/27 By Zhangyajun Bug修改，報表增加字段
# Modify.........: No.FUN-840202 08/04/29 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-830164 08/09/22 By dxfwo   報表改由CR輸出
# Modify.........: No.FUN-910073 09/02/02 By jan 成本計算類別為"1or2"時,類別編號應noentry且自動給' '
# Modify.........: No.MOD-950013 09/05/20 By Pengu 選擇分倉成本時，應判斷imd09是否存在
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-970176 09/07/24 By dxfwo  復制段                                                                          
#1 工單編號的開窗沒有寫                                                                                                             
#2 組件料號沒有給default1值，開窗后放棄，字段會被清空                                                                               
#3 類別編號，若成本計算類別沒有選4 or 5，就不會給p_qry，會開不出窗而有錯誤訊息。                                                    
# Modify.........: No.FUN-960038 09/07/31 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-9C0073 10/01/11 By chenls 程序精简
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.TQC-B40094 11/04/13 By yinhy "資料建立者","資料建立部門"更改
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B90108 11/09/19 By yinhy 當【工單編號】欄位錄入值並回車後，【產品編號】欄位的值沒有立即show出
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No:FUN-C30190 12/03/30 By chenjing 將原報表轉成CR
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ccf   RECORD LIKE ccf_file.*,
    g_ccf_t RECORD LIKE ccf_file.*,
    g_ccf01_t LIKE ccf_file.ccf01,
    g_ccf02_t LIKE ccf_file.ccf02,
    g_ccf03_t LIKE ccf_file.ccf03,
    g_ccf04_t LIKE ccf_file.ccf04,
    g_ccf06_t LIKE ccf_file.ccf06,    #No.FUN-7C0101
    g_ccf07_t LIKE ccf_file.ccf07,    #No.FUN-7C0101
    g_sfb   RECORD LIKE sfb_file.*,
    g_wc,g_sql          STRING,  #No.FUN-580092 HCN
    g_ima   RECORD LIKE ima_file.*,
    g_argv1             LIKE type_file.chr1           #No.FUN-680122 VARCHAR(01)   #FUN-610080
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72) 
DEFINE   g_before_input_done LIKE type_file.num5      #No.FUN-680122 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680122 SMALLINT
DEFINE   l_table        STRING                       #No.FUN-830164                                                             
DEFINE   l_sql          STRING                       #No.FUN-830164                                                             
DEFINE   g_str          STRING                       #No.FUN-830164
DEFINE   l_table1       STRING                       #FUN-C30190
DEFINE   g_sql1         STRING                       #FUN-C30190
DEFINE   g_str1         STRING                       #FUN-C30190
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5         #No.FUN-680122 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
   
    CASE g_argv1
       WHEN "1" LET g_prog = 'axci400'
       WHEN "2" LET g_prog = 'axci402'
       OTHERWISE EXIT PROGRAM
    END CASE
  
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

   IF g_argv1 = '1' THEN            #FUN-C30190--add--
      LET g_sql = " ccf01.ccf_file.ccf01,",
                  " ccf02.ccf_file.ccf02,",
                  " ccf03.ccf_file.ccf03,", 
                  " ccf11.ccf_file.ccf11,",   
                  " ccf04.ccf_file.ccf04,",
                  " l_ima021.ima_file.ima021,",
                  " ima02.ima_file.ima02,",
                  " ima25.ima_file.ima25,",
                  " ccf12.ccf_file.ccf12 "
      LET l_table = cl_prt_temptable('axci400',g_sql) CLIPPED                                                                          
      IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
                  " VALUES(?,?,?,?,?,  ?,?,?,?)"  
      PREPARE insert_prep FROM g_sql                                                                                                   
      IF STATUS THEN                                                                                                                   
         CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
      END IF              
   END IF                             #FUN-C30190--add--
#FUN-C30190--add--start--
   IF  g_argv1 = '2' THEN
      LET g_sql1 = "ccf01.ccf_file.ccf01,     ccf02.ccf_file.ccf02,",
                   "ccf03.ccf_file.ccf03,     ccf04.ccf_file.ccf04,",
                   "ccf11.ccf_file.ccf11,     ccf12.ccf_file.ccf12,",
                   "l_ima021.ima_file.ima021, ima02.ima_file.ima02,",
                   "ima25.ima_file.ima25"
      LET l_table1 = cl_prt_temptable('axci402',g_sql1) CLIPPED
      IF l_table1 = -1 THEN EXIT PROGRAM END IF
      LET g_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                   " VALUES(?,?,?,?,?,?,?,?,?)"
      PREPARE insert_prep1 FROM g_sql1
      IF STATUS THEN
         CALL cl_err("insert_prep1:",status,1) EXIT PROGRAM
      END IF
   END IF
#FUN-C30190--add--end--
 
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    INITIALIZE g_ccf.* TO NULL
    INITIALIZE g_ccf_t.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM ccf_file WHERE ccf01=? AND ccf02=? AND ccf03=? AND ccf04=?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i400_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 14
    OPEN WINDOW i400_w AT p_row,p_col
        WITH FORM "axc/42f/axci400" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    IF g_argv1 = "2" THEN
       CALL cl_set_comp_visible("sfb05",FALSE)
       #將ccf01的欄位顯示名稱改為"料件編號"
       CALL cl_getmsg('mfg1015',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ccf01",g_msg CLIPPED)
    END IF
 
    LET g_action_choice=""
    CALL i400_menu()
 
    CLOSE WINDOW i400_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION i400_cs()
DEFINE l_ccf06 LIKE ccf_file.ccf06  #No.FUN-7C0101
    CLEAR FORM
   INITIALIZE g_ccf.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ccf01,ccf02,ccf03,ccf06,ccf07,ccf04,ccf05,ccf11,       #No.FUN-7C0101 add
        ccf12a, ccf12b, ccf12c, ccf12d, ccf12e, ccf12f,
        ccf12g, ccf12h, ccf12,                                 
        ccfuser,ccfgrup,ccfmodu,ccfdate, 
        ccforiu,ccforig,                                       #No.TQC-B40094
        ccfud01,ccfud02,ccfud03,ccfud04,ccfud05,
        ccfud06,ccfud07,ccfud08,ccfud09,ccfud10,
        ccfud11,ccfud12,ccfud13,ccfud14,ccfud15
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
   AFTER FIELD ccf06                       
         LET l_ccf06 = get_fldbuf(ccf06)
   ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ccf01)   #主件料號
                IF g_argv1 = "2" THEN
#FUN-AA0059---------mod------------str-----------------                
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_ima"
#                   LET g_qryparam.state = "c"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                   DISPLAY g_qryparam.multiret TO ccf01
                   NEXT FIELD ccf01
                ELSE 
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sfb3"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ccf01
                   NEXT FIELD ccf01
                END IF
             WHEN INFIELD(ccf04)   #元件料號
#FUN-AA0059---------mod------------str-----------------             
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                LET g_qryparam.state = "c"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                DISPLAY g_qryparam.multiret TO ccf04
                NEXT FIELD ccf04 
              WHEN INFIELD(ccf07)                                               
                 IF l_ccf06 MATCHES '[45]' THEN                                 
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.state= "c"                                   
                 CASE l_ccf06                                                   
                    WHEN '4'                                                    
                      LET g_qryparam.form = "q_pja"                             
                    WHEN '5'                                                    
                      LET g_qryparam.form = "q_gem4"                            
                    OTHERWISE EXIT CASE                                         
                 END CASE                                                       
                 CALL cl_create_qry() RETURNING g_qryparam.multiret             
                 DISPLAY g_qryparam.multiret TO ccf07                           
                 NEXT FIELD ccf07                                               
                 END IF                                                         
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ccfuser', 'ccfgrup') #FUN-980030
 
    LET g_sql="SELECT ccf01,ccf02,ccf03,ccf04,ccf06,ccf07 FROM ccf_file ",  #No.FUN-7C0101
              " WHERE ",g_wc CLIPPED
    CASE g_argv1
       WHEN "1" 
          LET g_sql = g_sql CLIPPED," AND ccf00 ='1' "
       WHEN "2"
          LET g_sql = g_sql CLIPPED," AND ccf00 ='2' "
    END CASE
    LET g_sql = g_sql CLIPPED," ORDER BY ccf01,ccf02,ccf03,ccf04,ccf06,ccf07"   #No.FUN-7C0101
    PREPARE i400_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i400_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i400_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ccf_file WHERE ",g_wc CLIPPED
    CASE g_argv1
       WHEN "1"
          LET g_sql = g_sql CLIPPED," AND ccf00 ='1' "
       WHEN "2"
          LET g_sql = g_sql CLIPPED," AND ccf00 ='2' "
    END CASE
    PREPARE i400_precount FROM g_sql
    DECLARE i400_count CURSOR FOR i400_precount
END FUNCTION
 
FUNCTION i400_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i400_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i400_q()
            END IF
        ON ACTION next 
            CALL i400_fetch('N') 
        ON ACTION previous 
            CALL i400_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i400_u()
            END IF
        ON ACTION delete 
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i400_r()
            END IF
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
               CALL i400_copy()
            END IF
        ON ACTION output 
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CASE g_argv1
                  WHEN "1" CALL i400_out()
                  WHEN "2" CALL i402_out()
               END CASE
            END IF
        ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i400_fetch('/')
        ON ACTION first
            CALL i400_fetch('F')
        ON ACTION last
            CALL i400_fetch('L')

        ON IDLE g_idle_seconds
            CALL cl_on_idle()

        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121

        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121

        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_ccf.ccf01 IS NOT NULL THEN
                  LET g_doc.column1 = "ccf01"
                  LET g_doc.value1 = g_ccf.ccf01
                  CALL cl_doc()
               END IF
           END IF

        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i400_cs
END FUNCTION
 
FUNCTION i400_a()
 
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_ccf.* TO NULL
    LET g_ccf_t.* = g_ccf.*
    LET g_ccf.ccf02=g_ccf_t.ccf02
    LET g_ccf.ccf03=g_ccf_t.ccf03
    LET g_ccf.ccf05='P'
    LET g_ccf.ccf11=0 LET g_ccf.ccf12=0
    LET g_ccf.ccf12a=0 LET g_ccf.ccf12b=0 LET g_ccf.ccf12c=0
    LET g_ccf.ccf12d=0 LET g_ccf.ccf12e=0 LET g_ccf.ccf12f=0
    LET g_ccf.ccf12g = 0 LET g_ccf.ccf12h = 0                 #No.FUN-7C0101
    LET g_ccf01_t = NULL
    LET g_ccf02_t = NULL
    LET g_ccf03_t = NULL
    LET g_ccf04_t = NULL
    LET g_ccf06_t = NULL    #No.FUN-7C0101 add
    LET g_ccf07_t = NULL    #No.FUN-7C0101 add
    CALL cl_opmsg('a')
    WHILE TRUE

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          EXIT WHILE
       END IF
#FUN-BC0062 --end--

        LET g_ccf.ccf06 = g_ccz.ccz28            #No.FUN-7C0101
        LET g_ccf.ccf07 = ' '                    #No.FUN-7C0101
	LET g_ccf.ccfacti ='Y'                   #有效的資料
	LET g_ccf.ccfuser = g_user
	LET g_ccf.ccforiu = g_user #FUN-980030
	LET g_ccf.ccforig = g_grup #FUN-980030
	LET g_data_plant = g_plant #FUN-980030
	LET g_ccf.ccfgrup = g_grup               #使用者所屬群
	LET g_ccf.ccfdate = g_today
	#LET g_ccf.ccfplant = g_plant  #FUN-980009 add   #FUN-A50075
	LET g_ccf.ccflegal = g_legal  #FUN-980009 add
        CASE g_argv1
           WHEN "1" LET g_ccf.ccf00 ='1'
           WHEN "2" LET g_ccf.ccf00 ='2'
        END CASE
        DISPLAY BY NAME g_ccf.ccf00
        CALL i400_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_ccf.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ccf.ccf01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_ccf.ccf04 IS NULL THEN LET g_ccf.ccf04 = ' ' END IF
        INSERT INTO ccf_file VALUES(g_ccf.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ccf_file",g_ccf.ccf01,g_ccf.ccf02,SQLCA.sqlcode,"","ins ccf",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            LET g_ccf_t.* = g_ccf.*                # 保存上筆資料
            SELECT ccf01,ccof02,ccf03,ccf04 INTO g_ccf.ccf01,g_ccf.ccf02,g_ccf.ccf03,g_ccf.ccf04 FROM ccf_file
                WHERE ccf01 = g_ccf.ccf01 AND ccf02 = g_ccf.ccf02
                  AND ccf03 = g_ccf.ccf03 AND ccf04 = g_ccf.ccf04
                  AND ccf06 = g_ccf.ccf06 AND ccf07 = g_ccf.ccf07         #No.FUN-7C0101 add
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i400_i(p_cmd)
DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5           #No.FUN-680122 SMALLINT
DEFINE  li_result   LIKE type_file.num5           #No.FUN-550025         #No.FUN-680122 SMALLINT
 
     INPUT BY NAME g_ccf.ccforiu,g_ccf.ccforig,  #091021
        g_ccf.ccf01,g_ccf.ccf02,g_ccf.ccf03,g_ccf.ccf06,g_ccf.ccf07,g_ccf.ccf04,g_ccf.ccf05,  #No.FUN-7C0101 add ccf06,ccf07
        g_ccf.ccf11,
        g_ccf.ccf12a, g_ccf.ccf12b, g_ccf.ccf12c, g_ccf.ccf12d, g_ccf.ccf12e,
        g_ccf.ccf12f, g_ccf.ccf12g, g_ccf.ccf12h, g_ccf.ccf12,               #No.FUN-7C0101
        g_ccf.ccfuser,g_ccf.ccfgrup,g_ccf.ccfmodu,g_ccf.ccfdate,
        g_ccf.ccfud01,g_ccf.ccfud02,g_ccf.ccfud03,g_ccf.ccfud04,
        g_ccf.ccfud05,g_ccf.ccfud06,g_ccf.ccfud07,g_ccf.ccfud08,
        g_ccf.ccfud09,g_ccf.ccfud10,g_ccf.ccfud11,g_ccf.ccfud12,
        g_ccf.ccfud13,g_ccf.ccfud14,g_ccf.ccfud15
 
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i400_set_entry(p_cmd)
          CALL i400_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          IF g_ccf.ccf00 = '1' THEN   #FUN-610080
             CALL cl_set_docno_format("ccf01")
          END IF                      #FUN-610080
 
        AFTER FIELD ccf01
            #CASE g_ccf.ccf01  #TQC-B90108
            CASE g_ccf.ccf00   #TQC-B90108
               WHEN "1"
                  SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=g_ccf.ccf01 
                  IF STATUS THEN
                     CALL cl_err3("sel","sfb_file",g_ccf.ccf01,"",STATUS,"","sel sfb",1)  #No.FUN-660127
                     NEXT FIELD ccf01
                  END IF
                  DISPLAY BY NAME g_sfb.sfb05
               WHEN "2"
                 #FUN-AA0059 -----------------------add start-------------------
                  IF NOT cl_null(g_ccf.ccf01) THEN
                     IF NOT s_chk_item_no(g_ccf.ccf01,'') THEN
                        CALL cl_err('',g_errno,1)
                        NEXT FIELD ccf01
                     END IF
                  END IF
                 #FUN-AA0059 -----------------------add end---------------------
 
                  SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccf.ccf01 
                  IF STATUS THEN
                     CALL cl_err3("sel","ima_file",g_ccf.ccf01,"",STATUS,"","sel ima",1)  #No.FUN-660127
                     NEXT FIELD ccf01
                  END IF
            END CASE

        AFTER FIELD ccf03
            IF g_ccf.ccf03 < 1 OR g_ccf.ccf03 > 12 THEN
               NEXT FIELD ccf03
            END IF
       
        BEFORE FIELD ccf04
          CALL i400_set_entry(p_cmd)
 
        AFTER FIELD ccf04
           #FUN-AA0059 -----------------------add start----------------
            IF NOT cl_null(g_ccf.ccf04) AND g_ccf.ccf04 != ' DL+OH+SUB' THEN
               IF NOT s_chk_item_no(g_ccf.ccf04,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD ccf04
               END IF 
            END IF 
           #FUN-AA0059 -----------------------add end------------------ 
            IF g_ccf.ccf04 IS NULL OR cl_null(g_ccf.ccf04) THEN
               LET g_ccf.ccf04 = ' '
               LET g_ccf.ccf05 = 'M'
               DISPLAY BY NAME g_ccf.ccf05
               CALL i400_set_no_entry(p_cmd)
            END IF
            IF NOT cl_null(g_ccf.ccf04) AND g_ccf.ccf04 != ' DL+OH+SUB' THEN 
               SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccf.ccf04
               IF STATUS THEN
                  CALL cl_err3("sel","ima_file",g_ccf.ccf04,"",STATUS,"","sel ima:",1)  #No.FUN-660127
                  NEXT FIELD ccf04
               END IF
               DISPLAY BY NAME g_ima.ima02,g_ima.ima25
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND 
                  (g_ccf.ccf01 != g_ccf01_t OR g_ccf.ccf02 != g_ccf02_t OR
                   g_ccf.ccf03 != g_ccf03_t OR g_ccf.ccf04 != g_ccf04_t OR
                   g_ccf.ccf06 != g_ccf06_t OR g_ccf.ccf07 != g_ccf07_t)) THEN  #No.FUN-7C0101 add
                   SELECT count(*) INTO l_n FROM ccf_file
                       WHERE ccf01 = g_ccf.ccf01 AND ccf02 = g_ccf.ccf02
                         AND ccf03 = g_ccf.ccf03 AND ccf04 = g_ccf.ccf04
                         AND ccf06 = g_ccf.ccf06 AND ccf07 = g_ccf.ccf07         #No.FUN-7C0101 add
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err('count:',-239,0)
                       NEXT FIELD ccf01
                   END IF
               END IF
            END IF
            IF g_ccf.ccf04 = ' DL+OH+SUB' THEN
               LET g_ccf.ccf05 = 'P'
               DISPLAY BY NAME g_ccf.ccf05
            END IF
 
        BEFORE FIELD ccf05
            IF cl_null(g_ccf.ccf04) OR g_ccf.ccf04 = ' DL+OH+SUB' THEN
            END IF
        AFTER FIELD ccf06
            IF NOT cl_null(g_ccf.ccf06) THEN
               IF g_ccf.ccf06 NOT MATCHES '[12345]' THEN
                  NEXT FIELD ccf06
               END IF
               IF g_ccf.ccf06 MATCHES'[12]' THEN
                  CALL cl_set_comp_entry("ccf07",FALSE) 
                  LET g_ccf.ccf07 = ' '
               ELSE
                  CALL cl_set_comp_entry("ccf07",TRUE)
               END IF
             END IF
        AFTER FIELD ccf07
            IF NOT cl_null(g_ccf.ccf07) THEN
               CASE g_ccf.ccf06                                                                                                    
                 WHEN 4                                                                                                             
                  SELECT pja02 FROM pja_file WHERE pja01 = g_ccf.ccf07                                                              
                                               AND pjaclose='N'     #FUN-960038 
                  IF SQLCA.sqlcode!=0 THEN                                                                                          
                     CALL cl_err3('sel','pja_file',g_ccf.ccf07,'',SQLCA.sqlcode,'','',1)                                            
                     NEXT FIELD ccf07                                                                                               
                  END IF                                                                                                            
                 WHEN 5    
                   SELECT UNIQUE imd09 FROM imd_file WHERE imd09 = g_ccf.ccf07
                   IF SQLCA.sqlcode!=0 THEN                                                                                         
                     CALL cl_err3('sel','imd_file',g_ccf.ccf07,'',SQLCA.sqlcode,'','',1)       #No.MOD-950013 add
                     NEXT FIELD ccf07                                                                                               
                  END IF                                                                                                            
                 OTHERWISE EXIT CASE                                                                                                
                END CASE
            ELSE
               LET g_ccf.ccf07 = ' ' 
            END IF
        AFTER FIELD ccf11,ccf12a,ccf12b,ccf12c,ccf12d,ccf12e,ccf12f,ccf12g,ccf12h    #No.FUN-7C0101
            CALL i400_u_cost()
 
        BEFORE FIELD ccf12a
            IF cl_null(g_ccf.ccf04) THEN
               LET g_ccf.ccf12 = 0
               LET g_ccf.ccf12a= 0
               LET g_ccf.ccf12b= 0
               LET g_ccf.ccf12c= 0
               LET g_ccf.ccf12d= 0
               LET g_ccf.ccf12e= 0
               LET g_ccf.ccf12f= 0    #No.FUN-7C0101 add
               LET g_ccf.ccf12g= 0    #No.FUN-7C0101 add             
               LET g_ccf.ccf12h= 0    #No.FUN-7C0101 add
               DISPLAY BY NAME g_ccf.ccf12, g_ccf.ccf12a, g_ccf.ccf12b,
                               g_ccf.ccf12c, g_ccf.ccf12d, g_ccf.ccf12e,
                               g_ccf.ccf12f, g_ccf.ccf12g, g_ccf.ccf12h    #No.FUN-7C0101 add
               EXIT INPUT
            END IF
 
        AFTER FIELD ccfud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccfud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_ccf.ccfuser = s_get_data_owner("ccf_file") #FUN-C10039
           LET g_ccf.ccfgrup = s_get_data_group("ccf_file") #FUN-C10039
            LET l_flag='N'
            IF g_ccf.ccf04 = ' DL+OH+SUB' THEN
               LET g_ccf.ccf05 = 'P'
               DISPLAY BY NAME g_ccf.ccf05
            END IF
            IF INT_FLAG THEN
                EXIT INPUT  
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD ccf01
            END IF
            #20131209 add by suncx sta-------
            IF NOT i400_chk(g_ccf.ccf02,g_ccf.ccf03) THEN
               CALL cl_err('','axc-809',1)
               NEXT FIELD ccf02
            END IF
            #20131209 add by suncx end-------
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ccf01)   #主件料號
                 IF g_ccf.ccf00 = "2" THEN
#FUN-AA0059---------mod------------str-----------------                 
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.default1 = g_ccf.ccf01
#                    CALL cl_create_qry() RETURNING g_ccf.ccf01
                    CALL q_sel_ima(FALSE, "q_ima","",g_ccf.ccf01,"","","","","",'' ) 
                     RETURNING  g_ccf.ccf01
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY BY NAME g_ccf.ccf01
                    NEXT FIELD ccf01
                 ELSE 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_sfb3"
                    LET g_qryparam.default1 = g_ccf.ccf01
                    CALL cl_create_qry() RETURNING g_ccf.ccf01
                    DISPLAY BY NAME g_ccf.ccf01
                    NEXT FIELD ccf01
                 END IF
              WHEN INFIELD(ccf04)   #元件料號
#FUN-AA0059---------mod------------str-----------------              
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.default1 = g_ccf.ccf04
#                 CALL cl_create_qry() RETURNING g_ccf.ccf04
                  CALL q_sel_ima(FALSE, "q_ima","",g_ccf.ccf04,"","","","","",'' ) 
                     RETURNING  g_ccf.ccf04
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_ccf.ccf04
                 NEXT FIELD ccf04
              WHEN INFIELD(ccf07)
                IF g_ccf.ccf06 MATCHES '[45]' THEN                
                 CALL cl_init_qry_var()
                 CASE g_ccf.ccf06
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"                     
                    WHEN '5'
                      LET g_qryparam.form = "q_gem4"
                    OTHERWISE EXIT CASE
                 END CASE
                 LET g_qryparam.default1 = g_ccf.ccf07
                 CALL cl_create_qry() RETURNING g_ccf.ccf07
                 DISPLAY BY NAME g_ccf.ccf07
                END IF
           END CASE
 
        ON KEY(F1)
            IF INFIELD(ccf04) THEN
               CALL i400_ccf04() DISPLAY BY NAME g_ccf.ccf04 NEXT FIELD ccf04
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
 
FUNCTION i400_ccf04()
   IF g_sfb.sfb05 MATCHES '5*99' THEN   # SMT-5*99 取下階料為'P*'者
     SELECT MAX(sfa03) INTO g_ccf.ccf04 FROM sfa_file
      WHERE sfa01=g_ccf.ccf01 AND sfa03 MATCHES 'P*'
   END IF
   IF g_sfb.sfb05 MATCHES '5*00' THEN   # Touch-Up 取下階料為'*99'者
     SELECT MAX(sfa03) INTO g_ccf.ccf04 FROM sfa_file
      WHERE sfa01=g_ccf.ccf01 AND sfa03 MATCHES '*99'
   END IF
   IF g_sfb.sfb05 MATCHES '2*00' THEN   # Packing 取下階料為'5*'者
     SELECT MAX(sfa03) INTO g_ccf.ccf04 FROM sfa_file
      WHERE sfa01=g_ccf.ccf01 AND sfa03 MATCHES '5*'
   END IF
   IF g_sfb.sfb05 MATCHES '8*' THEN             # 磁片委外取下階料為'KZ*'者
     SELECT MAX(sfa03) INTO g_ccf.ccf04 FROM sfa_file
      WHERE sfa01=g_ccf.ccf01 AND sfa03 MATCHES 'KZ*'
   END IF
END FUNCTION
 
FUNCTION i400_u_cost()
    LET g_ccf.ccf12=g_ccf.ccf12a+g_ccf.ccf12b+g_ccf.ccf12c+
                    g_ccf.ccf12d+g_ccf.ccf12e+g_ccf.ccf12f+
                    g_ccf.ccf12g+g_ccf.ccf12h                #No.FUN-7C0101
    DISPLAY BY NAME g_ccf.ccf12
END FUNCTION
 
FUNCTION i400_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ccf.* TO NULL              #No.FUN-6A0019
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i400_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i400_count
    FETCH i400_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN i400_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open i400_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_ccf.* TO NULL
    ELSE
        CALL i400_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i400_fetch(p_flccf)
    DEFINE
        p_flccf          LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)  
 
    CASE p_flccf
        WHEN 'N' FETCH NEXT     i400_cs INTO g_ccf.ccf01,g_ccf.ccf02,g_ccf.ccf03,g_ccf.ccf04
        WHEN 'P' FETCH PREVIOUS i400_cs INTO g_ccf.ccf01,g_ccf.ccf02,g_ccf.ccf03,g_ccf.ccf04
        WHEN 'F' FETCH FIRST    i400_cs INTO g_ccf.ccf01,g_ccf.ccf02,g_ccf.ccf03,g_ccf.ccf04
        WHEN 'L' FETCH LAST     i400_cs INTO g_ccf.ccf01,g_ccf.ccf02,g_ccf.ccf03,g_ccf.ccf04
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
            FETCH ABSOLUTE g_jump i400_cs INTO g_ccf.ccf01,g_ccf.ccf02,g_ccf.ccf03,g_ccf.ccf04
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccf.ccf01,SQLCA.sqlcode,0)
        INITIALIZE g_ccf.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flccf
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ccf.* FROM ccf_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ccf01=g_ccf.ccf01 AND ccf02=g_ccf.ccf02 AND ccf03=g_ccf.ccf03 AND ccf04=g_ccf.ccf04
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ccf_file",g_ccf.ccf01,g_ccf.ccf02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE                                     #FUN-4C0061權限控管
       LET g_data_owner = g_ccf.ccfuser
       LET g_data_group = g_ccf.ccfgrup
       #LET g_data_plant = g_ccf.ccfplant #FUN-980030   #FUN-A50075
       LET g_data_plant = g_plant         #FUN-A50075
       CALL i400_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i400_show()
    LET g_ccf_t.* = g_ccf.*
     DISPLAY BY NAME g_ccf.ccforiu,g_ccf.ccforig,  #091021 
        g_ccf.ccf00,   #FUN-610080
        g_ccf.ccf01,g_ccf.ccf02,g_ccf.ccf03,g_ccf.ccf04,g_ccf.ccf05,
        g_ccf.ccf06,g_ccf.ccf07,  #No.FUN-7C0101 add
        g_ccf.ccf11,
        g_ccf.ccf12a, g_ccf.ccf12b, g_ccf.ccf12c, g_ccf.ccf12d, g_ccf.ccf12e,
        g_ccf.ccf12f, g_ccf.ccf12g, g_ccf.ccf12h, g_ccf.ccf12,    #No.FUN-7C0101 add 
        g_ccf.ccfuser,g_ccf.ccfgrup,g_ccf.ccfmodu,g_ccf.ccfdate,
        g_ccf.ccfud01,g_ccf.ccfud02,g_ccf.ccfud03,g_ccf.ccfud04,
        g_ccf.ccfud05,g_ccf.ccfud06,g_ccf.ccfud07,g_ccf.ccfud08,
        g_ccf.ccfud09,g_ccf.ccfud10,g_ccf.ccfud11,g_ccf.ccfud12,
        g_ccf.ccfud13,g_ccf.ccfud14,g_ccf.ccfud15
 
    INITIALIZE g_sfb.* TO NULL
    INITIALIZE g_ima.* TO NULL
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=g_ccf.ccf01
    DISPLAY BY NAME g_sfb.sfb05
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccf.ccf04
    DISPLAY BY NAME g_ima.ima25,g_ima.ima02
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i400_u()
    IF g_ccf.ccf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    #20131209 add by suncx sta-------
    IF NOT i400_chk(g_ccf.ccf02,g_ccf.ccf03) THEN
       CALL cl_err('','axc-809',1)
       RETURN
    END IF
    #20131209 add by suncx end-------

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ccf01_t = g_ccf.ccf01
    LET g_ccf02_t = g_ccf.ccf02
    LET g_ccf03_t = g_ccf.ccf03
    LET g_ccf04_t = g_ccf.ccf04
    LET g_ccf06_t = g_ccf.ccf06       #No.FUN-7C0101
    LET g_ccf07_t = g_ccf.ccf07       #No.FUN-7C0101
    BEGIN WORK
 
    OPEN i400_cl USING g_ccf.ccf01,g_ccf.ccf02,g_ccf.ccf03,g_ccf.ccf04
    IF STATUS THEN
       CALL cl_err("OPEN i400_cl:", STATUS, 1)
       CLOSE i400_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i400_cl INTO g_ccf.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
     IF cl_null(g_ccf.ccfacti) THEN LET g_ccf.ccfacti ='Y' END IF 
     IF cl_null(g_ccf.ccfuser) THEN LET g_ccf.ccfuser = g_user END IF 
     IF cl_null(g_ccf.ccfgrup) THEN LET g_ccf.ccfgrup = g_grup END IF  
	LET g_ccf.ccfmodu=g_user                     #修改者
	LET g_ccf.ccfdate = g_today                  #修改日期
    CALL i400_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i400_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ccf.*=g_ccf_t.*
            CALL i400_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ccf.ccf04 IS NULL THEN LET g_ccf.ccf04 = ' ' END IF
        UPDATE ccf_file SET ccf_file.* = g_ccf.*    # 更新DB
            WHERE ccf01=g_ccf.ccf01 AND ccf02=g_ccf.ccf02 AND ccf03=g_ccf.ccf03 AND ccf04=g_ccf.ccf04             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ccf_file",g_ccf01_t,g_ccf02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i400_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i400_r()
    IF g_ccf.ccf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #20131209 add by suncx sta-------
    IF NOT i400_chk(g_ccf.ccf02,g_ccf.ccf03) THEN
       CALL cl_err('','axc-809',1)
       RETURN
    END IF
    #20131209 add by suncx end-------
    BEGIN WORK
 
    OPEN i400_cl USING g_ccf.ccf01,g_ccf.ccf02,g_ccf.ccf03,g_ccf.ccf04
    IF STATUS THEN
       CALL cl_err("OPEN i400_cl:", STATUS, 1)
       CLOSE i400_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i400_cl INTO g_ccf.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccf.ccf01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i400_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ccf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ccf.ccf01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ccf_file WHERE ccf01 = g_ccf.ccf01 AND ccf02 = g_ccf.ccf02
                              AND ccf03 = g_ccf.ccf03 AND ccf04 = g_ccf.ccf04
                              AND ccf06 = g_ccf.ccf06 AND ccf07 = g_ccf.ccf07    #No.FUN-7C0101 add
       CLEAR FORM
       OPEN i400_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i400_cs
          CLOSE i400_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i400_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i400_cs
          CLOSE i400_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i400_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i400_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i400_fetch('/')
       END IF
    END IF
    CLOSE i400_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i400_copy()    #複製
DEFINE  l_n       LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_ccf     RECORD LIKE ccf_file.*,
        l_newno1  LIKE ccf_file.ccf01,
        l_newno2  LIKE ccf_file.ccf02,
        l_newno3  LIKE ccf_file.ccf03,
        l_newno4  LIKE ccf_file.ccf04,
        l_newno5  LIKE ccf_file.ccf06,        #No.FUN-7C0101
        l_newno6  LIKE ccf_file.ccf07         #No.FUN-7C0101
   IF s_shut(0) THEN RETURN END IF
   IF g_ccf.ccf01 IS NULL OR g_ccf.ccf02 IS NULL OR 
      g_ccf.ccf03 IS NULL OR g_ccf.ccf04 IS NULL OR
      g_ccf.ccf06 IS NULL OR g_ccf.ccf07 IS NULL THEN  #No.FUN-7C0101      
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
   LET g_before_input_done = FALSE
   CALL i400_set_entry('a')
   CALL i400_set_no_entry('a')
   LET g_before_input_done = TRUE
 
   INPUT l_newno1,l_newno2,l_newno3,l_newno4,l_newno5,l_newno6      #No.FUN-7C0101 add
         FROM ccf01,ccf02,ccf03,ccf04,ccf06,ccf07                 
      BEFORE INPUT
         IF g_ccf.ccf00 = '1' THEN
            CALL cl_set_docno_format("ccf01")
         END IF
 
      AFTER FIELD ccf01
         #FUN-AA0059 -------------------add start--------------------
         IF NOT cl_null(l_newno1) AND g_ccf.ccf00 = '2' THEN
            IF NOT s_chk_item_no(l_newno1,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD ccf01
            END IF 
         END IF 
         #FUN-AA0059 ---------------------add end--------------------- 
         IF g_ccf.ccf00 = '1' THEN
            IF cl_null(l_newno1) THEN
               NEXT FIELD ccf01
            END IF
         END IF
  
      AFTER FIELD ccf02
         IF cl_null(l_newno2) THEN
            NEXT FIELD ccf02
         END IF
 
      AFTER FIELD ccf03
         IF cl_null(l_newno3) THEN
            NEXT FIELD ccf03
         END IF
  
      AFTER FIELD ccf04
         IF cl_null(l_newno4) THEN
            NEXT FIELD ccf04
         ELSE
           #FUN-AA0059 ----------------------add start-----------------
            IF NOT s_chk_item_no(l_newno4,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD ccf04
            END IF 
           #FUN-AA0059 -----------------------add end------------------ 
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=l_newno4
            IF STATUS THEN
               CALL cl_err3("sel","ima_file",l_newno4,"",STATUS,"","sel ima:",1)  #No.FUN-660127
               NEXT FIELD ccf04
            END IF
            DISPLAY g_ima.ima02,g_ima.ima25 TO ima02,ima25
         END IF
      AFTER FIELD ccf06
         IF cl_null(l_newno5) OR l_newno5 NOT MATCHES '[12345]' THEN
            NEXT FIELD ccf06
         END IF
         IF l_newno5 IS NOT NULL THEN                                                                                                
            IF l_newno5 MATCHES'[12]' THEN                                                                                           
               CALL cl_set_comp_entry("ccf07",FALSE)                                                                                 
               LET l_newno6 = ' '                                                                                                    
            ELSE                                                                                                                     
               CALL cl_set_comp_entry("ccf07",TRUE)                                                                                  
            END IF                                                                                                                   
         END IF                                                                                                                      
 
      AFTER INPUT
         LET g_cnt = 0
         SELECT count(*) INTO g_cnt FROM ccf_file
          WHERE ccf01 = l_newno1 AND ccf02 = l_newno2
            AND ccf03 = l_newno3 AND ccf04 = l_newno4
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno1,-239,0)
            NEXT FIELD ccf01
         END IF
         LET g_cnt = 0
         #20131209 add by suncx sta-------
         IF NOT i400_chk(l_newno2,l_newno3) THEN
            CALL cl_err('','axc-809',1)
            NEXT FIELD ccf02
         END IF
         #20131209 add by suncx end-------
  
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ccf01)   #工單編號                                                                                         
               IF g_ccf.ccf00 = "2" THEN
#FUN-AA0059---------mod------------str-----------------                                                                                                           
#                  CALL cl_init_qry_var()                                                                                            
#                  LET g_qryparam.form = "q_ima"                                                                                     
#                  LET g_qryparam.default1 = l_newno1                                                                                
#                  CALL cl_create_qry() RETURNING l_newno1
                  CALL q_sel_ima(FALSE, "q_ima","",l_newno1,"","","","","",'' ) 
                 RETURNING  l_newno1
#FUN-AA0059---------mod------------end-----------------                                                                           
                  DISPLAY l_newno1 TO ccf01                                                                                         
                  NEXT FIELD ccf01                                                                                                  
               ELSE                                                                                                                 
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form = "q_sfb3"                                                                                    
                  LET g_qryparam.default1 = l_newno1                                                                                
                  CALL cl_create_qry() RETURNING l_newno1                                                                           
                  DISPLAY l_newno1 TO ccf01                                                                                         
                  NEXT FIELD ccf01                                                                                                  
               END IF                                                                                                               
            WHEN INFIELD(ccf04)   #元件料號
#FUN-AA0059---------mod------------str-----------------            
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima"
#               LET g_qryparam.default1 = l_newno4     #No.TQC-970176  dxfwo  add
#               CALL cl_create_qry() RETURNING l_newno4
                 CALL q_sel_ima(FALSE, "q_ima","",l_newno4,"","","","","",'' ) 
                 RETURNING  l_newno4
#FUN-AA0059---------mod------------end-----------------   
               DISPLAY l_newno4 TO ccf04
               NEXT FIELD ccf04
              WHEN INFIELD(ccf07)
                 CALL cl_init_qry_var()
                 CASE l_newno5
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"                     
                      LET g_qryparam.default1 = l_newno6                                                                            
                      CALL cl_create_qry() RETURNING l_newno6                                                                       
                      DISPLAY l_newno6 TO ccf07                                                                                     
                      NEXT FIELD ccf07                                                                                              
                    WHEN '5'
                      LET g_qryparam.form = "q_gem4"
                      LET g_qryparam.default1 = l_newno6                                                                            
                      CALL cl_create_qry() RETURNING l_newno6                                                                       
                      DISPLAY l_newno6 TO ccf07                                                                                     
                      NEXT FIELD ccf07                                                                                              
                    OTHERWISE EXIT CASE
                 END CASE
          END CASE
 
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
       DISPLAY BY NAME g_ccf.ccf01,g_ccf.ccf02,g_ccf.ccf03,g_ccf.ccf04,
                       g_ccf.ccf06,g_ccf.ccf07      #No.FUN-7C0101
       RETURN
   END IF
 
   LET l_ccf.* = g_ccf.*
   CASE g_argv1
      WHEN "1" LET l_ccf.ccf00 = '1'
      WHEN "2" LET l_ccf.ccf00 = '2'
   END CASE
   LET l_ccf.ccf01 = l_newno1
   LET l_ccf.ccf02 = l_newno2
   LET l_ccf.ccf03 = l_newno3
   LET l_ccf.ccf04 = l_newno4
   LET l_ccf.ccf06 = l_newno5    #No.FUN-7C0101
   LET l_ccf.ccf07 = l_newno6    #No.FUN-7C0101
   LET l_ccf.ccfuser = g_user    #資料所有者
   LET l_ccf.ccfgrup = g_grup    #資料所有者所屬群
   LET l_ccf.ccfmodu = NULL      #資料修改日期
   LET l_ccf.ccfdate = g_today   #資料建立日期
   LET l_ccf.ccfacti = 'Y'       #有效資料
   #LET l_ccf.ccfplant = g_plant #FUN-980009 add    #FUN-A50075
   LET l_ccf.ccflegal = g_legal #FUN-980009 add
   IF cl_null(l_ccf.ccf05)  THEN LET l_ccf.ccf05 =' ' END IF
   IF cl_null(l_ccf.ccf11)  THEN LET l_ccf.ccf11 = 0  END IF
   IF cl_null(l_ccf.ccf12)  THEN LET l_ccf.ccf12 = 0  END IF
   IF cl_null(l_ccf.ccf12a) THEN LET l_ccf.ccf12a= 0  END IF
   IF cl_null(l_ccf.ccf12b) THEN LET l_ccf.ccf12b= 0  END IF
   IF cl_null(l_ccf.ccf12c) THEN LET l_ccf.ccf12c= 0  END IF
   IF cl_null(l_ccf.ccf12d) THEN LET l_ccf.ccf12d= 0  END IF
   IF cl_null(l_ccf.ccf12e) THEN LET l_ccf.ccf12e= 0  END IF
   IF cl_null(l_ccf.ccf12f) THEN LET l_ccf.ccf12f= 0  END IF     #No.FUN-7C0101
   IF cl_null(l_ccf.ccf12g) THEN LET l_ccf.ccf12g= 0  END IF     #No.FUN-7C0101
   IF cl_null(l_ccf.ccf12h) THEN LET l_ccf.ccf12h= 0  END IF     #No.FUN-7C0101   
   LET l_ccf.ccforiu = g_user      #No.FUN-980030 10/01/04
   LET l_ccf.ccforig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO ccf_file VALUES (l_ccf.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","ccf_file",l_ccf.ccf01,l_ccf.ccf02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
   ELSE
       MESSAGE 'ROW(',l_newno1,') O.K'
   END IF
   #FUN-C80046---begin
   #SELECT * INTO g_ccf.* FROM ccf_file
   # WHERE ccf01 = g_ccf.ccf01 AND ccf02 = g_ccf.ccf02
   #   AND ccf03 = g_ccf.ccf03 AND ccf04 = g_ccf.ccf04
   #   AND ccf06 = g_ccf.ccf06 AND ccf07 = g_ccf.ccf07     #No.FUN-7C0101
   SELECT * INTO g_ccf.* FROM ccf_file
    WHERE ccf01 = l_newno1 AND ccf02 = l_newno2
      AND ccf03 = l_newno3 AND ccf04 = l_newno4
      AND ccf06 = l_newno5 AND ccf07 = l_newno6
   #FUN-C80046---end
   CALL i400_show()
 
END FUNCTION
 
FUNCTION i400_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),               # External(Disk) file name
        l_za05          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40),               #
        l_ccf RECORD LIKE ccf_file.*,
        l_price      LIKE ccf_file.ccf12a ,           #No.FUN-830164
        sr RECORD
           ima02 LIKE ima_file.ima02,
           ima25 LIKE ima_file.ima25
           END RECORD
DEFINE l_ima021  LIKE ima_file.ima021                 #No.FUN-830164    
    IF g_wc IS NULL THEN
       LET g_wc=" ccf01='",g_ccf.ccf01,"'" 
       LET g_wc=" ccf00='1'"   #FUN-610080
    END IF 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT ccf_file.*, ima02,ima25 FROM ccf_file LEFT OUTER JOIN ima_file ON ccf04=ima01 ",
             " WHERE  ",g_wc CLIPPED," AND ccf00 = '1' "          #FUN-C30190   add"AND ccf00 = '1'"
    PREPARE i400_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i400_co CURSOR FOR i400_p1
 
    CALL cl_del_data(l_table)                 #No.FUN-830164
 
    FOREACH i400_co INTO l_ccf.*, sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
            IF l_ccf.ccf11 = 0 THEN 
               LET l_price = 0
            ELSE 
               LET l_price = l_ccf.ccf12/l_ccf.ccf11
            END IF 
            SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=l_ccf.ccf04
            IF SQLCA.sqlcode THEN LET l_ima021 = NULL END IF
        EXECUTE insert_prep USING  l_ccf.ccf01, l_ccf.ccf02, l_ccf.ccf03, l_ccf.ccf11,
                                   l_ccf.ccf04, l_ima021,    sr.ima02,    sr.ima25,
                                   l_ccf.ccf12  
    END FOREACH
 
    CLOSE i400_co
    ERROR ""
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
     IF    g_zz05 = 'Y' THEN                                                        
        CALL cl_wcchp(g_wc,'ccf01,ccf02,ccf03,ccf04,ccf05,ccf11,
        ccf12a, ccf12b, ccf12c, ccf12d, ccf12e, ccf12,
        ccfuser,ccfgrup,ccfmodu,ccfdate')
          RETURNING g_wc                                                                                                             
    END IF             
    LET g_str = g_wc                                                       
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
    CALL cl_prt_cs3('axci400','axci400',l_sql,g_str)
END FUNCTION
 
FUNCTION i402_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),               # External(Disk) file name
        l_za05          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40),               #
        l_ima021        LIKE ima_file.ima021,         #No.FUN-C30190
        l_ccf RECORD LIKE ccf_file.*,
        sr RECORD
           ima02 LIKE ima_file.ima02,
           ima25 LIKE ima_file.ima25
           END RECORD
 
    IF g_wc IS NULL THEN
       LET g_wc=" ccf01='",g_ccf.ccf01,"'"
       LET g_wc=" ccf00='2'"
    END IF 
    CALL cl_wait()
#   CALL cl_outnam('axci402') RETURNING l_name       #FUN-C30190--mark
    CALL cl_del_data(l_table1)       #FUN-C30190--add--
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT ccf_file.*, ima02,ima25 FROM ccf_file LEFT OUTER JOIN ima_file ON ccf04=ima01 ",
              " WHERE  ",g_wc CLIPPED," AND ccf00 = '2'"      #FUN-C30190  add"AND ccf00 = '2'"
    PREPARE i402_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i402_co CURSOR FOR i402_p1
 
#   START REPORT i402_rep TO l_name     #FUN-C30190--mark
 
    FOREACH i402_co INTO l_ccf.*, sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
#       OUTPUT TO REPORT i402_rep(l_ccf.*, sr.*)    #FUN-C30190--mark
   #FUN-C30190--add--start--
        SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=l_ccf.ccf04
        IF SQLCA.sqlcode THEN LET l_ima021 = NULL END IF
        EXECUTE insert_prep1 USING  l_ccf.ccf01,l_ccf.ccf02,l_ccf.ccf03,l_ccf.ccf04,
                                    l_ccf.ccf11,l_ccf.ccf12,l_ima021,sr.ima02,sr.ima25
   #FUN-C30190--add--end--
    END FOREACH
 
#   FINISH REPORT i402_rep        #FUN-C30190--mark
 
    CLOSE i402_co
    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)     #FUN-C30190--mark
  #FUN-C30190--add--start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'ccf01,ccf02,ccf03,ccf04,ccf05,ccf11,ccf12a,ccf12b,ccf12c,
                     ccf12c,ccf12d,ccf12e,ccf12,ccfuser,ccfgruo,ccfmodu,ccfdate')
       RETURNING g_wc
    END IF
    LET g_str = g_wc
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table1 CLIPPED," ORDER BY ccf02,ccf03,ccf04"
    CALL cl_prt_cs3('axci400','axci400_2',l_sql,g_str)
  #FUN-C30190--add--end--

END FUNCTION
 
#FUN-C30190--mark--start--
#REPORT i402_rep(l_ccf,sr)
#   DEFINE l_ima021  LIKE ima_file.ima021 
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)  
#       l_ccf RECORD LIKE ccf_file.*,
#       l_price      LIKE ccf_file.ccf12a , 
#       sr RECORD
#          ima02 LIKE ima_file.ima02,
#          ima25 LIKE ima_file.ima25
#          END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#
#   ORDER BY l_ccf.ccf02,l_ccf.ccf03,l_ccf.ccf04
#
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT 
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
#
#       BEFORE GROUP OF l_ccf.ccf03
#           PRINT COLUMN g_c[31],l_ccf.ccf02 USING '&&&&',
#                 COLUMN g_c[32],l_ccf.ccf03 USING '&&';
#
#       ON EVERY ROW
#           IF l_ccf.ccf11 = 0 THEN 
#              LET l_price = 0
#           ELSE 
#              LET l_price = l_ccf.ccf12/l_ccf.ccf11
#           END IF 
#           SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=l_ccf.ccf04
#           IF SQLCA.sqlcode THEN LET l_ima021 = NULL END IF
#
#           PRINT COLUMN g_c[33],l_ccf.ccf01,
#                 COLUMN g_c[34],l_ccf.ccf04,
#                 COLUMN g_c[35],l_ima021,
#                 COLUMN g_c[36],sr.ima02, 
#                 COLUMN g_c[37],sr.ima25,
#                 COLUMN g_c[38],cl_numfor(l_ccf.ccf11,38,2),
#                 COLUMN g_c[39],cl_numfor(l_ccf.ccf12,39,2),
#                 COLUMN g_c[40],cl_numfor(l_price,40,4)
#
#       AFTER GROUP OF l_ccf.ccf03
#           PRINT COLUMN g_c[38],g_x[11] CLIPPED, 
#                 COLUMN g_c[39],cl_numfor(GROUP SUM(l_ccf.ccf12),39,2)
#           PRINT
#
#       ON LAST ROW
#           PRINT
#           PRINT COLUMN g_c[38],g_x[12] CLIPPED,
#                 COLUMN g_c[39],cl_numfor(SUM(l_ccf.ccf12),39,2)
#           PRINT g_dash
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#FUN-C30190--mark--end--
 
FUNCTION i400_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ccf01,ccf02,ccf03,ccf04,ccf06,ccf07",TRUE)  #No.FUN-7C0101 add
  END IF
  CASE WHEN INFIELD(ccf04) OR ( NOT g_before_input_done )
              CALL cl_set_comp_entry("ccf05",TRUE)
  END CASE
END FUNCTION
 
FUNCTION i400_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ccf01,ccf02,ccf03,ccf04,ccf06,ccf07",FALSE)  #No.FUN-7C0101 add
  END IF
  CASE WHEN INFIELD(ccf04) OR ( NOT g_before_input_done )
            IF cl_null(g_ccf.ccf04) OR g_ccf.ccf04=' DL+OH+SUB' THEN
               CALL cl_set_comp_entry("ccf05",FALSE)
            END IF
  END CASE
  IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND 
     (NOT g_before_input_done) THEN 
     IF g_ccf.ccf06 MATCHES'[12]' THEN 
        CALL cl_set_comp_entry("ccf07",FALSE)
     ELSE
        CALL cl_set_comp_entry("ccf07",TRUE)
     END IF
  END IF
 
END FUNCTION
#No.FUN-9C0073 ----------------By chenls 10/01/11

#20131209 add by suncx begin--------------------------------
FUNCTION i400_chk(p_yy,p_mm)
DEFINE p_yy        LIKE type_file.num5,
       p_mm        LIKE type_file.num5
DEFINE l_bdate     LIKE type_file.dat,
       l_edate     LIKE type_file.dat
DEFINE l_sql       STRING
DEFINE l_n         LIKE type_file.num5
DEFINE l_correct   LIKE type_file.chr1

      LET l_n = 0
      CALL s_azm(p_yy,p_mm) RETURNING l_correct, l_bdate, l_edate
      LET l_sql = " SELECT COUNT(*) FROM npp_file",
                  "  WHERE nppsys  = 'CA'",
                  "    AND npp011  = '1'",
                  "    AND npp00 >= 2 AND npp00 <= 7 ",
                  "    AND npp00 <> 6 ",
                  "    AND nppglno IS NOT NULL ",
                  "    AND YEAR(npp02) = ",p_yy,
                  "    AND MONTH(npp02) = ",p_mm,
                  "    AND npp03 BETWEEN '",l_bdate,"' AND '",l_edate ,"' "

      PREPARE npq_pre FROM l_sql
      DECLARE npq_cs CURSOR FOR npq_pre
      OPEN npq_cs
      FETCH npq_cs INTO l_n
      CLOSE npq_cs

      IF l_n > 0 THEN
         RETURN FALSE
      END IF
      RETURN TRUE
END FUNCTION
#20131209 add by suncx end----------------------------------
