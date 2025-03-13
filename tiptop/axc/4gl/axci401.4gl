# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axci401.4gl
# Descriptions...: 在製開帳金額維護作業
# Date & Author..: 95/10/18 By Roger
# Modify.........: No.A088 03/08/22 By Wiky 程式中沒有menu2
# Modify.........: No.MOD-4C0005 04/12/01 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660159 06/06/22 By Sarah 當月期末數量可以維護,但維護完重新查詢會不見
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660160 06/06/23 By Sarah 新增輸入工單編號後抓sfb_file的WHERE條件句需限定已確認且產生製程的工單
# Modify.........: No.FUN-660201 06/06/29 By Sarah 增加作業編號cxf012為key值
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780017 07/07/26 By dxfwo CR報表的制作
# Modify.........: No.TQC-780056 07/08/17 By Carrier oracle語法轉至ora文檔
# Modify.........: No.TQC-790077 07/09/19 By Carrier 工單/作業編號/元件編號加入開窗
# Modify.........: No.FUN-7C0101 08/01/10 By Cockroach 成本改善增加cxf06(成本計算類別),cxf07(類別編號)和各種制費
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830135 08/03/27 By Cockroach  成本改善CR報表增加列印字段cxf06(成本計算類別),cxf07(類別編號)
# Modify.........: No.FUN-840202 08/04/29 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT rowi,.....,rowi寫法會出現ORA-600的錯誤
# Modify.........: No.FUN-910073 09/02/02 By jan 成本計算類別為"1or2"時,類別編號應noentry且自動給' '
# Modify.........: No.MOD-950013 09/05/20 By Pengu 選擇分倉成本時，應判斷imd09是否存在
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.           09/10/21 By lilingyu r.c2 fail       
# Modify.........: No.FUN-9C0073 10/01/11 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cxf   RECORD LIKE cxf_file.*,
    g_cxf_t RECORD LIKE cxf_file.*,
    g_cxf01_t  LIKE cxf_file.cxf01,
    g_cxf012_t LIKE cxf_file.cxf012,         #FUN-660201 add
    g_cxf02_t  LIKE cxf_file.cxf02,
    g_cxf03_t  LIKE cxf_file.cxf03,
    g_cxf04_t  LIKE cxf_file.cxf04,
    g_cxf06_t  LIKE cxf_file.cxf06,           #FUN-7C0101 ADD 成本計算類別
    g_cxf07_t  LIKE cxf_file.cxf07,           #FUN-7C0101 ADD 類別編號
    g_sfb   RECORD LIKE sfb_file.*,
    g_wc,g_sql          string,               #No.FUN-580092 HCN
    l_sql               string,               #No.FUN-780017    
    g_ima   RECORD LIKE ima_file.*
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE   g_str          STRING                       #No.FUN-780017
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
    LET p_row = 4 LET p_col = 14
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    INITIALIZE g_cxf.* TO NULL
    INITIALIZE g_cxf_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM cxf_file WHERE cxf01 =? AND cxf02 = ? AND cxf03 = ? AND cxf04 = ? AND cxf06 =? AND cxf07 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i401_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    OPEN WINDOW i401_w AT p_row,p_col
        WITH FORM "axc/42f/axci401" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
 
      LET g_action_choice=""
    CALL i401_menu()
 
    CLOSE WINDOW i401_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION i401_cs()
DEFINE l_cxf06 LIKE cxf_file.cxf06  #No.FUN-7C0101
    CLEAR FORM
   INITIALIZE g_cxf.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        cxf01,cxf012,cxf02,cxf03,cxf06,cxf04,cxf05,cxf07,   #FUN-7C0101 ADD cxf06,cxf07
        cxf11, cxf12a, cxf12b, cxf12c, cxf12d, cxf12e,
        cxf12f,cxf12g,cxf12h,                    #FUN-7C0101 ADD
        cxf12,cxfuser,cxfgrup,cxfmodu,cxfdate,
        cxfud01,cxfud02,cxfud03,cxfud04,cxfud05,
        cxfud06,cxfud07,cxfud08,cxfud09,cxfud10,
        cxfud11,cxfud12,cxfud13,cxfud14,cxfud15
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
        AFTER FIELD cxf06
              LET l_cxf06 = get_fldbuf(cxf06)
       ON ACTION controlp
          CASE
             WHEN INFIELD(cxf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_sfb13"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cxf01
                  NEXT FIELD cxf01
             WHEN INFIELD(cxf012)
                  CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cxf012
                  NEXT FIELD cxf012
             WHEN INFIELD(cxf04)
#FUN-AA0059---------mod------------str-----------------             
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state = "c"
#                  LET g_qryparam.form = "q_ima"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO cxf04
                  NEXT FIELD cxf04
              WHEN INFIELD(cxf07)                                               
                 IF l_cxf06 MATCHES '[45]' THEN                             
                    CALL cl_init_qry_var()       
                    LET g_qryparam.state= "c"                                
                    CASE l_cxf06                                               
                       WHEN '4'                                                    
                         LET g_qryparam.form = "q_pja"                             
                       WHEN '5'                                                    
                         LET g_qryparam.form = "q_gem4"                            
                       OTHERWISE EXIT CASE                                         
                   END CASE                                                       
                   CALL cl_create_qry() RETURNING g_qryparam.multiret                     
                   DISPLAY  g_qryparam.multiret TO cxf07                                  
                   NEXT FIELD cxf07                                               
                 END IF                                                         
          END CASE
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cxfuser', 'cxfgrup') #FUN-980030
 
    LET g_sql="SELECT cxf01,cxf012,cxf02,cxf03,cxf06,cxf07,cxf04",  #FUN-7C0101 add cxf06,cxf07  #FUN-660201 add cxf012 #TQC-870018
              "  FROM cxf_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY cxf01,cxf012,cxf02,cxf03,cxf04"             #FUN-660201 add cxf012
    PREPARE i401_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i401_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i401_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cxf_file WHERE ",g_wc CLIPPED
    PREPARE i401_precount FROM g_sql
    DECLARE i401_count CURSOR FOR i401_precount
END FUNCTION
 
FUNCTION i401_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i401_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i401_q()
            END IF
        ON ACTION next 
            CALL i401_fetch('N') 
        ON ACTION previous 
            CALL i401_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i401_u()
            END IF
        ON ACTION delete 
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i401_r()
            END IF
       ON ACTION output 
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i401_out()
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
            CALL i401_fetch('/')
        ON ACTION first
            CALL i401_fetch('F')
        ON ACTION last
            CALL i401_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document             #相關文件"                        
       LET g_action_choice="related_document"           
          IF cl_chk_act_auth() THEN                     
             IF g_cxf.cxf01 IS NOT NULL THEN            
                LET g_doc.column1 = "cxf01"               
                LET g_doc.column2 = "cxf012" 
                LET g_doc.column3 = "cxf02"
                LET g_doc.column4 = "cxf03"  
                LET g_doc.column5 = "cxf04" 
                LET g_doc.value1 = g_cxf.cxf01            
                LET g_doc.value2 = g_cxf.cxf012
                LET g_doc.value3 = g_cxf.cxf02
                LET g_doc.value4 = g_cxf.cxf03
                LET g_doc.value5 = g_cxf.cxf04  
                CALL cl_doc()                             
             END IF                                        
          END IF                                           
 
            LET g_action_choice = "exit"
          CONTINUE MENU
    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i401_cs
END FUNCTION
 
FUNCTION i401_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_cxf.* TO NULL
    LET g_cxf_t.* = g_cxf.*
    LET g_cxf.cxf02=g_cxf_t.cxf02
    LET g_cxf.cxf03=g_cxf_t.cxf03
    LET g_cxf.cxf06=g_cxf_t.cxf06            #FUN-7C0101
    LET g_cxf.cxf07=g_cxf_t.cxf07            #FUN-7C0101 
    LET g_cxf.cxf05='P'
    LET g_cxf.cxf11=0 LET g_cxf.cxf12=0
    LET g_cxf.cxf12a=0 LET g_cxf.cxf12b=0 LET g_cxf.cxf12c=0
    LET g_cxf.cxf12d=0 LET g_cxf.cxf12e=0
    LET g_cxf.cxf12f=0 LET g_cxf.cxf12g=0 LET g_cxf.cxf12h=0    #FUN-7C0101
    LET g_cxf01_t = NULL
    LET g_cxf012_t= NULL   #FUN-660201 add
    LET g_cxf02_t = NULL
    LET g_cxf03_t = NULL
    LET g_cxf04_t = NULL
    LET g_cxf06_t = g_ccz.ccz28   #FUN-7C0101 add
    LET g_cxf07_t = NULL          #FUN-7C0101 add       
    CALL cl_opmsg('a')
    WHILE TRUE

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          EXIT WHILE
       END IF
#FUN-BC0062 --end--

        LET g_cxf.cxf07 = ' '                    #FUN-7C0101 ADD 
	LET g_cxf.cxfacti ='Y'                   #有效的資料
	LET g_cxf.cxfuser = g_user
	LET g_cxf.cxforiu = g_user #FUN-980030
	LET g_cxf.cxforig = g_grup #FUN-980030
	LET g_data_plant = g_plant #FUN-980030
	LET g_cxf.cxfgrup = g_grup               #使用者所屬群
	LET g_cxf.cxfdate = g_today
	#LET g_cxf.cxfplant=g_plant #FUN-980009 add    #FUN-A50075
	LET g_cxf.cxflegal=g_legal #FUN-980009 add
        CALL i401_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_cxf.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_cxf.cxf01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_cxf.cxf04 IS NULL THEN LET g_cxf.cxf04 = ' ' END IF
        INSERT INTO cxf_file VALUES(g_cxf.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","cxf_file",g_cxf.cxf01,g_cxf.cxf02,SQLCA.sqlcode,"","ins cxf",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            LET g_cxf_t.* = g_cxf.*                # 保存上筆資料
            SELECT cxf01,cxf02,cxf03,cxf04,cxf06,cxf07 INTO g_cxf.cxf01,g_cxf.cxf02,g_cxf.cxf03,g_cxf.cxf04,g_cxf.cxf06,g_cxf.cxf07 FROM cxf_file
             WHERE cxf01 = g_cxf.cxf01 
               AND cxf012= g_cxf.cxf012   #FUN-660201 add
               AND cxf02 = g_cxf.cxf02
               AND cxf03 = g_cxf.cxf03 
               AND cxf04 = g_cxf.cxf04
               AND cxf06 = g_cxf.cxf06    #FUN-7C0101  add  
               AND cxf07 = g_cxf.cxf07    #FUN-7C0101  add     
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i401_i(p_cmd)
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
         l_flag      LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
         l_n         LIKE type_file.num5           #No.FUN-680122 SMALLINT
  DEFINE li_result   LIKE type_file.num5           #No.FUN-550025         #No.FUN-680122 SMALLINT
  DEFINE l_ecm03     LIKE ecm_file.ecm03           #No.TQC-790077
 
     INPUT BY NAME g_cxf.cxforiu,g_cxf.cxforig, #091021
        g_cxf.cxf01,g_cxf.cxf012,g_cxf.cxf02,g_cxf.cxf03,g_cxf.cxf06,g_cxf.cxf07,  #FUN-7C0101  add cxf06,cxf07
        g_cxf.cxf04,g_cxf.cxf05,
        g_cxf.cxf11,
        g_cxf.cxf12a, g_cxf.cxf12b, g_cxf.cxf12c, g_cxf.cxf12d, g_cxf.cxf12e,
        g_cxf.cxf12f, g_cxf.cxf12g, g_cxf.cxf12h,                              #FUN-7C0101 add
        g_cxf.cxf12,
        g_cxf.cxfuser,g_cxf.cxfgrup,g_cxf.cxfmodu,g_cxf.cxfdate, 
        g_cxf.cxfud01,g_cxf.cxfud02,g_cxf.cxfud03,g_cxf.cxfud04,
        g_cxf.cxfud05,g_cxf.cxfud06,g_cxf.cxfud07,g_cxf.cxfud08,
        g_cxf.cxfud09,g_cxf.cxfud10,g_cxf.cxfud11,g_cxf.cxfud12,
        g_cxf.cxfud13,g_cxf.cxfud14,g_cxf.cxfud15
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i401_set_entry(p_cmd)
          CALL i401_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("cxf01")
 
        AFTER FIELD cxf01
            IF NOT cl_null(g_cxf.cxf01) THEN
               SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=g_cxf.cxf01
                  AND sfb87='Y' AND sfb93='Y'  # 需限定已確認且產生製程的工單   #FUN-660160 add
               IF STATUS THEN
                  CALL cl_err3("sel","sfb_file",g_cxf.cxf01,"",STATUS,"","sel sfb:",1)  #No.FUN-660127
                  NEXT FIELD cxf01
               END IF
               DISPLAY BY NAME g_sfb.sfb05
              END IF
 
        AFTER FIELD cxf012 
           IF NOT cl_null(g_cxf.cxf012) THEN 
              SELECT COUNT(*) INTO g_cnt FROM ecm_file 
               WHERE ecm01=g_cxf.cxf01 AND ecm04=g_cxf.cxf012 
              IF g_cnt=0 THEN 
                CALL cl_err(g_cxf.cxf012,'aec-015',1) 
                NEXT FIELD cxf012 
              END IF 
           ELSE
              CALL cl_err(g_cxf.cxf012,'mfg0037',1) 
              NEXT FIELD cxf012 
           END IF 
 
        AFTER FIELD cxf03
            IF g_cxf.cxf03 < 1 OR g_cxf.cxf03 > 12 THEN
               NEXT FIELD cxf03
            END IF
 
        AFTER FIELD cxf06
            IF g_cxf.cxf06 IS NOT NULL THEN
               IF g_cxf.cxf06 NOT  MATCHES '[12345]'  THEN
                  CALL cl_err(g_cxf.cxf06,'mfg0037',1)
                  NEXT FIELD  cxf06
                END IF
               IF g_cxf.cxf06 MATCHES'[12]' THEN                                                                                    
                  CALL cl_set_comp_entry("cxf07",FALSE)                                                                             
                  LET g_cxf.cxf07 = ' '                                                                                             
               ELSE                                                                                                                 
                  CALL cl_set_comp_entry("cxf07",TRUE)                                                                              
               END IF                                                                                                               
             END IF
 
        AFTER FIELD cxf07
 
            IF NOT cl_null(g_cxf.cxf07) THEN
               CASE g_cxf.cxf06
                 WHEN 4
                  SELECT pja02 FROM pja_file WHERE pja01 = g_cxf.cxf07
                                               AND pjaclose='N'     #FUN-960038
                  IF SQLCA.sqlcode!=0 THEN
                     CALL cl_err3('sel','pja_file',g_cxf.cxf07,'',SQLCA.sqlcode,'','',1)
                     NEXT FIELD cxf07
                  END IF
                 WHEN 5
                   SELECT UNIQUE imd09 FROM imd_file WHERE imd09 = g_cxf.cxf07
                   IF SQLCA.sqlcode!=0 THEN
                     CALL cl_err3('sel','imd_file',g_cxf.cxf07,'',SQLCA.sqlcode,'','',1)
                     NEXT FIELD cxf07
                  END IF
                 OTHERWISE EXIT CASE
                END CASE
            ELSE
               LET g_cxf.cxf07 = ' '
            END IF
     
        AFTER FIELD cxf04
           #FUN-AA0059 ---------------------------add start----------------
            IF NOT cl_null(g_cxf.cxf04) AND g_cxf.cxf04 != ' DL+OH+SUB'THEN
               IF NOT s_chk_item_no(g_cxf.cxf04,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD cxf04
               END IF 
            END IF 
           #FUN-AA0059 ----------------------------addd end------------------------ 
            IF g_cxf.cxf04 IS NULL OR g_cxf.cxf04 = ' ' THEN
               LET g_cxf.cxf04 = ' '
               LET g_cxf.cxf05 = 'M'
               DISPLAY BY NAME g_cxf.cxf05
            END IF
            IF g_cxf.cxf04 != ' ' AND g_cxf.cxf04 != ' DL+OH+SUB' THEN 
               SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_cxf.cxf04
               IF STATUS THEN
                  CALL cl_err3("sel","ima_file",g_cxf.cxf04,"",STATUS,"","sel ima:",1)  #No.FUN-660127
                  NEXT FIELD cxf04 
               END IF
               DISPLAY BY NAME g_ima.ima02,g_ima.ima25
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND 
                  (g_cxf.cxf01 != g_cxf01_t OR g_cxf.cxf012 != g_cxf012_t OR   #FUN-660102 add cxf012
                   g_cxf.cxf02 != g_cxf02_t OR
                   g_cxf.cxf03 != g_cxf03_t OR g_cxf.cxf06 != g_cxf06_t OR g_cxf.cxf07 != g_cxf07_t OR   #FUN-7C0101 ADD
                   g_cxf.cxf04 != g_cxf04_t)) THEN
                   SELECT count(*) INTO l_n FROM cxf_file
                    WHERE cxf01 = g_cxf.cxf01 
                      AND cxf012= g_cxf.cxf012   #FUN-660201 add
                      AND cxf02 = g_cxf.cxf02
                      AND cxf03 = g_cxf.cxf03 
                      AND cxf04 = g_cxf.cxf04
                      AND cxf06 = g_cxf.cxf06    #FUN-7C0101 add 
                      AND cxf07 = g_cxf.cxf07    #FUN-7C0101 add
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err('count:',-239,0)
                       NEXT FIELD cxf01
                   END IF
               END IF
            END IF
            IF g_cxf.cxf04 = ' DL+OH+SUB' THEN
               LET g_cxf.cxf05 = 'P'
               DISPLAY BY NAME g_cxf.cxf05
            END IF
        BEFORE FIELD cxf05
            IF g_cxf.cxf04 = ' ' OR g_cxf.cxf04 = ' DL+OH+SUB' THEN
            END IF
        AFTER FIELD cxf11,cxf12a,cxf12b,cxf12c,cxf12d,cxf12e,cxf12f,cxf12g,cxf12h   #FUN-7C0101 add cxf12f-cxf12h
            CALL i401_u_cost()
        BEFORE FIELD cxf12a
            IF g_cxf.cxf04 = ' ' THEN
               LET g_cxf.cxf12 = 0
               LET g_cxf.cxf12a= 0
               LET g_cxf.cxf12b= 0
               LET g_cxf.cxf12c= 0
               LET g_cxf.cxf12d= 0
               LET g_cxf.cxf12e= 0
               LET g_cxf.cxf12f= 0          #FUN-7C0101 add        
               LET g_cxf.cxf12g= 0          #FUN-7C0101 add   
               LET g_cxf.cxf12h= 0          #FUN-7C0101 add   
               DISPLAY BY NAME g_cxf.cxf12, g_cxf.cxf12a, g_cxf.cxf12b,
                               g_cxf.cxf12c, g_cxf.cxf12d, g_cxf.cxf12e,
                               g_cxf.cxf12f, g_cxf.cxf12g, g_cxf.cxf12h     #FUN-7C0101 add 
               EXIT INPUT
            END IF
 
        AFTER FIELD cxfud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cxfud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_cxf.cxfuser = s_get_data_owner("cxf_file") #FUN-C10039
           LET g_cxf.cxfgrup = s_get_data_group("cxf_file") #FUN-C10039
            LET l_flag='N'
            IF g_cxf.cxf04 = ' DL+OH+SUB' THEN
               LET g_cxf.cxf05 = 'P'
               DISPLAY BY NAME g_cxf.cxf05
            END IF
            IF INT_FLAG THEN
                EXIT INPUT  
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD cxf01
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(cxf01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sfb13"
                   LET g_qryparam.default1 = g_cxf.cxf01
                   CALL cl_create_qry() RETURNING g_cxf.cxf01
                   DISPLAY BY NAME g_cxf.cxf01
                   NEXT FIELD cxf01
              WHEN INFIELD(cxf012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ecm5"
                   LET g_qryparam.default2 = g_cxf.cxf012
                   LET g_qryparam.arg1 = g_cxf.cxf01
                   CALL cl_create_qry() RETURNING l_ecm03,g_cxf.cxf012
                   DISPLAY BY NAME g_cxf.cxf012
                   NEXT FIELD cxf012
              WHEN INFIELD(cxf07)
                   IF g_cxf.cxf06 MATCHES "[45]" THEN
                      CALL cl_init_qry_var()                                                                                              
                      CASE g_cxf.cxf06
                          WHEN  '4'
                              LET g_qryparam.form = "q_pja"                                                                                         
                          WHEN  '5'                                                                                    
                              LET g_qryparam.form = "q_gem4"       
                          OTHERWISE EXIT CASE
                      END CASE                                                                           
                      LET g_qryparam.default1 = g_cxf.cxf07                                                                         
                      CALL cl_create_qry() RETURNING g_cxf.cxf07 
                   ELSE 
                      LET g_cxf.cxf07 = ' '
                   END IF                                                                    
                      DISPLAY BY NAME g_cxf.cxf07                                                                                   
                      NEXT FIELD cxf07                                                                                              
                         
              WHEN INFIELD(cxf04)
#FUN-AA0059---------mod------------str-----------------              
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_ima"
#                   LET g_qryparam.default1 = g_cxf.cxf04
#                   CALL cl_create_qry() RETURNING g_cxf.cxf04
                   CALL q_sel_ima(FALSE, "q_ima","",g_cxf.cxf04,"","","","","",'' ) 
                   RETURNING g_cxf.cxf04

#FUN-AA0059---------mod------------end-----------------
                   DISPLAY BY NAME g_cxf.cxf04
                   NEXT FIELD cxf04
           END CASE
 
 
 
 
        ON KEY(F1)
            IF INFIELD(cxf04) THEN
               CALL i401_cxf04() DISPLAY BY NAME g_cxf.cxf04 NEXT FIELD cxf04
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
 
FUNCTION i401_cxf04()
   IF g_sfb.sfb05 MATCHES '5*99' THEN   # SMT-5*99 取下階料為'P*'者
     SELECT MAX(sfa03) INTO g_cxf.cxf04 FROM sfa_file
      WHERE sfa01=g_cxf.cxf01 AND sfa03 MATCHES 'P*'
   END IF
   IF g_sfb.sfb05 MATCHES '5*00' THEN   # Touch-Up 取下階料為'*99'者
     SELECT MAX(sfa03) INTO g_cxf.cxf04 FROM sfa_file
      WHERE sfa01=g_cxf.cxf01 AND sfa03 MATCHES '*99'
   END IF
   IF g_sfb.sfb05 MATCHES '2*00' THEN   # Packing 取下階料為'5*'者
     SELECT MAX(sfa03) INTO g_cxf.cxf04 FROM sfa_file
      WHERE sfa01=g_cxf.cxf01 AND sfa03 MATCHES '5*'
   END IF
   IF g_sfb.sfb05 MATCHES '8*' THEN             # 磁片委外取下階料為'KZ*'者
     SELECT MAX(sfa03) INTO g_cxf.cxf04 FROM sfa_file
      WHERE sfa01=g_cxf.cxf01 AND sfa03 MATCHES 'KZ*'
   END IF
END FUNCTION
 
FUNCTION i401_u_cost()
    LET g_cxf.cxf12=g_cxf.cxf12a+g_cxf.cxf12b+g_cxf.cxf12c+
                    g_cxf.cxf12d+g_cxf.cxf12e+
                    g_cxf.cxf12f+g_cxf.cxf12g+g_cxf.cxf12h    #FUN-7C0101 add
    DISPLAY BY NAME g_cxf.cxf12
END FUNCTION
 
FUNCTION i401_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cxf.* TO NULL              #No.FUN-6A0019
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt 
    CALL i401_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i401_count
    FETCH i401_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt 
    OPEN i401_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open i401_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_cxf.* TO NULL
    ELSE
        CALL i401_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i401_fetch(p_flcxf)
    DEFINE
        p_flcxf      LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
 
    CASE p_flcxf
        WHEN 'N' FETCH NEXT     i401_cs INTO g_cxf.cxf01,g_cxf.cxf012,   #FUN-660201 add g_cxf.cxf012
                                             g_cxf.cxf02,g_cxf.cxf03,
                                             g_cxf.cxf06,g_cxf.cxf07,                #FUN-7C0101 add    
                                             g_cxf.cxf04 #TQC-870018
        WHEN 'P' FETCH PREVIOUS i401_cs INTO g_cxf.cxf01,g_cxf.cxf012,   #FUN-660201 add g_cxf.cxf012
                                             g_cxf.cxf02,g_cxf.cxf03,
                                             g_cxf.cxf06,g_cxf.cxf07,                #FUN-7C0101 add 
                                             g_cxf.cxf04 #TQC-870018
        WHEN 'F' FETCH FIRST    i401_cs INTO g_cxf.cxf01,g_cxf.cxf012,   #FUN-660201 add g_cxf.cxf012
                                             g_cxf.cxf02,g_cxf.cxf03,
                                             g_cxf.cxf06,g_cxf.cxf07,                #FUN-7C0101 add      
                                             g_cxf.cxf04 #TQC-870018
        WHEN 'L' FETCH LAST     i401_cs INTO g_cxf.cxf01,g_cxf.cxf012,   #FUN-660201 add g_cxf.cxf012
                                             g_cxf.cxf02,g_cxf.cxf03,
                                             g_cxf.cxf06,g_cxf.cxf07,                #FUN-7C0101 add    
                                             g_cxf.cxf04 #TQC-870018
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
            FETCH ABSOLUTE g_jump i401_cs INTO g_cxf.cxf01,g_cxf.cxf012,   #FUN-660201 add g_cxf.cxf012
                                               g_cxf.cxf02,g_cxf.cxf03,
                                               g_cxf.cxf06,g_cxf.cxf07,                #FUN-7C0101 add    
                                               g_cxf.cxf04 #TQC-870018
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cxf.cxf01,SQLCA.sqlcode,0)
        INITIALIZE g_cxf.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcxf
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cxf.* FROM cxf_file            # 重讀DB,因TEMP有不被更新特性
WHERE cxf01=g_cxf.cxf01 AND  cxf02=g_cxf.cxf02 AND  cxf03=g_cxf.cxf03 AND  cxf04=g_cxf.cxf04 AND cxf06 = g_cxf.cxf06 AND cxf07 = g_cxf.cxf07
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","cxf_file",g_cxf.cxf01,g_cxf.cxf02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE                                      #FUN-4C0061權限控管
       LET g_data_owner = g_cxf.cxfuser
       LET g_data_group = g_cxf.cxfgrup
       #LET g_data_plant = g_cxf.cxfplant #FUN-980030   #FUN-A50075
       LET g_data_plant = g_plant     #FUN-A50075
        CALL i401_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i401_show()
    LET g_cxf_t.* = g_cxf.*
     DISPLAY BY NAME g_cxf.cxforiu,g_cxf.cxforig, #091021 
        g_cxf.cxf01,g_cxf.cxf012,g_cxf.cxf02,g_cxf.cxf03,g_cxf.cxf06,g_cxf.cxf07,     #FUN-7C0101 add g_cxf.cxf06,g_cxf.cxf07
        g_cxf.cxf04,g_cxf.cxf05,
        g_cxf.cxf11,   #FUN-660159 add
        g_cxf.cxf12a, g_cxf.cxf12b, g_cxf.cxf12c, g_cxf.cxf12d, g_cxf.cxf12e,
        g_cxf.cxf12f, g_cxf.cxf12g, g_cxf.cxf12h,                                     #FUN-7C0101 add 
        g_cxf.cxf12, 
        g_cxf.cxfuser,g_cxf.cxfgrup,g_cxf.cxfmodu,g_cxf.cxfdate,
        g_cxf.cxfud01,g_cxf.cxfud02,g_cxf.cxfud03,g_cxf.cxfud04,
        g_cxf.cxfud05,g_cxf.cxfud06,g_cxf.cxfud07,g_cxf.cxfud08,
        g_cxf.cxfud09,g_cxf.cxfud10,g_cxf.cxfud11,g_cxf.cxfud12,
        g_cxf.cxfud13,g_cxf.cxfud14,g_cxf.cxfud15
 
    INITIALIZE g_sfb.* TO NULL
    INITIALIZE g_ima.* TO NULL
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=g_cxf.cxf01
    DISPLAY BY NAME g_sfb.sfb05
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_cxf.cxf04
    DISPLAY BY NAME g_ima.ima25,g_ima.ima02
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i401_u()
    IF g_cxf.cxf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cxf01_t = g_cxf.cxf01
    LET g_cxf012_t= g_cxf.cxf012   #FUN-660201 add
    LET g_cxf02_t = g_cxf.cxf02
    LET g_cxf03_t = g_cxf.cxf03
    LET g_cxf04_t = g_cxf.cxf04
    LET g_cxf06_t = g_cxf.cxf06    #FUN-7C0101 add 
    LET g_cxf07_t = g_cxf.cxf07    #FUN-7C0101 add
    BEGIN WORK
 
    OPEN i401_cl USING g_cxf.cxf01,g_cxf.cxf02,g_cxf.cxf03,g_cxf.cxf04,g_cxf.cxf06,g_cxf.cxf07
    IF STATUS THEN
       CALL cl_err("OPEN i401_cl:", STATUS, 1)
       CLOSE i401_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i401_cl INTO g_cxf.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
     IF cl_null(g_cxf.cxfacti) THEN LET g_cxf.cxfacti ='Y' END IF 
     IF cl_null(g_cxf.cxfuser) THEN LET g_cxf.cxfuser = g_user END IF 
     IF cl_null(g_cxf.cxfgrup) THEN LET g_cxf.cxfgrup = g_grup END IF  
	LET g_cxf.cxfmodu=g_user                     #修改者
	LET g_cxf.cxfdate = g_today                  #修改日期
    CALL i401_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i401_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cxf.*=g_cxf_t.*
            CALL i401_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cxf.cxf04 IS NULL THEN LET g_cxf.cxf04 = ' ' END IF
        UPDATE cxf_file SET cxf_file.* = g_cxf.*    # 更新DB
            WHERE cxf01=g_cxf_t.cxf01 AND cxf02=g_cxf_t.cxf02 AND  cxf03=g_cxf_t.cxf03 AND  cxf04=g_cxf_t.cxf04 AND cxf06 = g_cxf_t.cxf06 AND cxf07 = g_cxf_t.cxf07          # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","cxf_file",g_cxf01_t,g_cxf02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i401_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i401_r()
    IF g_cxf.cxf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i401_cl USING g_cxf.cxf01,g_cxf.cxf02,g_cxf.cxf03,g_cxf.cxf04,g_cxf.cxf06,g_cxf.cxf07
    IF STATUS THEN
       CALL cl_err("OPEN i401_cl:", STATUS, 1)
       CLOSE i401_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i401_cl INTO g_cxf.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cxf.cxf01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i401_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cxf01"          #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "cxf012"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "cxf02"          #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "cxf03"          #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "cxf04"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cxf.cxf01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_cxf.cxf012      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_cxf.cxf02       #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_cxf.cxf03       #No.FUN-9B0098 10/02/24
        LET g_doc.value5 = g_cxf.cxf04       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
       DELETE FROM cxf_file 
        WHERE cxf01 = g_cxf.cxf01 
          AND cxf012= g_cxf.cxf012   #FUN-660201 add
          AND cxf02 = g_cxf.cxf02
          AND cxf03 = g_cxf.cxf03 
          AND cxf04 = g_cxf.cxf04
          AND cxf06 = g_cxf.cxf06    #FUN-7C0101 ADD
          AND cxf07 = g_cxf.cxf07    #FUN-7C0101 ADD
       CLEAR FORM
       OPEN i401_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i401_cs
          CLOSE i401_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i401_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i401_cs
          CLOSE i401_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i401_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i401_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i401_fetch('/')
       END IF
    END IF
    CLOSE i401_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i401_out()
    DEFINE
        l_i         LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_name      LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),               # External(Disk) file name
        l_za05      LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40),               #
        l_cxf       RECORD LIKE cxf_file.*,
        sr          RECORD
                     ima02  LIKE ima_file.ima02,
                     ima021 LIKE ima_file.ima021,
                     ima25  LIKE ima_file.ima25
                    END RECORD
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axci401') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT cxf_file.*, ima02,ima021,ima25 FROM cxf_file LEFT OUTER JOIN ima_file ON cxf04=ima01 ",
              " WHERE  ",g_wc CLIPPED
 
 
 
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'cxf01,cxf012,cxf02,cxf03,cxf04,cxf05,cxf06,cxf07,cxf11,cxf12a, cxf12b,   #No.FUN-830135 ADD cxf06,cxf07
       cxf12c, cxf12d, cxf12e, cxf12, cxfuser,cxfgrup,cxfmodu,cxfdate')         
            RETURNING g_str                                                     
    END IF
    LET l_sql="SELECT cxf_file.*, ima02,ima021,ima25 FROM cxf_file LEFT OUTER JOIN ima_file ON cxf04 = ima01 ",  #No.TQC-780056
              " WHERE  ",g_wc CLIPPED  #No.TQC-780056
    CALL cl_prt_cs1('axci401','axci401',l_sql,g_str)    
END FUNCTION
 
FUNCTION i401_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("cxf01,cxf012,cxf02,cxf03,cxf04,cxf06,cxf07",TRUE)
  END IF
END FUNCTION
 
FUNCTION i401_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("cxf01,cxf012,cxf02,cxf03,cxf04,cxf06,cxf07",FALSE)
  END IF
  IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND
     (NOT g_before_input_done) THEN
     IF g_cxf.cxf06 MATCHES'[12]' THEN
        CALL cl_set_comp_entry("cxf07",FALSE)
     ELSE
        CALL cl_set_comp_entry("cxf07",TRUE)
     END IF 
  END IF
END FUNCTION
#No.FUN-9C0073 ------------------By chenls  程序精簡 

