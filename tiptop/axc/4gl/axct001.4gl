# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axct001.4gl
# Descriptions...: 庫存開帳金額維護作業
# Date & Author..: 95/10/18 By Roger
# Modify ........: No:9484 04/04/23 Melody t001_show()..SELECT...前需加一行 INITIALIZE g_ima.* TO NULL避免轉入的資料,
#                :        尚無對應的料件資料,品號會錯亂
# Modify.........: No.FUN-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-4C0099 05/01/10 By kim 報表轉XML功能
# Modify.........: No.FUN-5C0002 05/12/05 By Sarah 補印ima021
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件" 
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.MOD-710001 07/03/07 By pengu  考慮成本參數-成本計算庫存金額小數位數(ccz26)的設定
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-770056 07/07/12 By Carol 列印時數量取至小數3位
# Modify.........: No.TQC-790064 07/09/17 By sherry 錄入"月份"為負數無控管
# Modify.........: No.FUN-7C0034 07/12/18 By shiwuying 報表轉CR
# Modify.........: No.FUN-7C0101 08/01/09 By shiwuying 成本改善增加cca06(成本計算類別),cca07(類別編號)和各種制費
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830135 08/03/27 By shiwuying 成本改善增加cca06(成本計算類別),cca07(類別編號)
# Modify.........: No.FUN-840202 08/04/29 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-910073 09/02/02 By jan 成本計算類別為"1or2"時,類別編號應noentry且自動給' '
# Modify.........: No.MOD-950013 09/05/20 By Pengu 選擇分倉成本時，應判斷imd09是否存在
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.TQC-970211 09/09/25 By baofei 料件主檔不存在時,修改會死循環  
# Modify.........: No.TQC-9C0028 09/12/09 By liuxqa 调整录入顺序。
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No:MOD-A10178 10/01/27 By sherry 計算類別為5 分倉成本時，類別編號開窗應該開成本庫類別資料
# Modify.........: No:TQC-A20054 10/02/23 By sherry 增加控管，日期在關賬日期之前的資料不可以修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50064 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BC0082 12/01/20 By shiwuying p_ze修改
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-CA0137 12/11/30 By Elise 期別先call s_azm()再進行判斷
# Modify.........: No:FUN-BC0062 12/02/20 By fengrui 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No:MOD-D20071 13/03/13 By Alberti 在after field cca02/cca03 加上clm-012的控卡
# Modify.........: No:190110     19/01/10 By pulf 算12月成本开帐开在11月，检核12月是否有凭证即可

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cca   RECORD LIKE cca_file.*,
    g_cca_t RECORD LIKE cca_file.*,
    g_cca01_t LIKE cca_file.cca01,
    g_cca02_t LIKE cca_file.cca02,
    g_cca03_t LIKE cca_file.cca03,
    g_cca06_t LIKE cca_file.cca06,  #No.FUN-7C0101
    g_cca07_t LIKE cca_file.cca07,  #No.FUN-7C0101
    g_wc,g_sql          string,     #No.FUN-580092 HCN
    u_cost              LIKE type_file.num20_6,       #No.FUN-680122 DEC(20,6)   #FUN-4C0005
    g_ima   RECORD LIKE ima_file.*
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680122 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03           #No.FUN-680122 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680122 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680122 SMALLINT
DEFINE   g_str          STRING                       #No.FUN-7C0034 
DEFINE   l_table        STRING                       #No.FUN-7C0034 
 
 
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
 
   LET g_sql = "cca01.cca_file.cca01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima25.ima_file.ima25,",
               "cca02.cca_file.cca02,",
               "cca03.cca_file.cca03,",
               "cca06.cca_file.cca06,",  #No.FUN-830135 ADD
               "cca07.cca_file.cca07,",  #No.FUN-830135 ADD
               "cca11.cca_file.cca11,",
               "cca12.cca_file.cca12 " 
   LET l_table = cl_prt_temptable('axct001',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF 
   
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    INITIALIZE g_cca.* TO NULL
    INITIALIZE g_cca_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM cca_file WHERE cca01 = ? AND cca02 = ? AND cca03 = ? AND cca06 = ? AND cca07 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t001_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 4 LET p_col = 14
 
    OPEN WINDOW t001_w AT p_row,p_col WITH FORM "axc/42f/axct001" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL t001_menu()
 
    CLOSE WINDOW t001_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t001_cs()
DEFINE l_cca06 LIKE cca_file.cca06  #No.FUN-7C0101
    CLEAR FORM
   INITIALIZE g_cca.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        cca01,cca02,cca03,cca06,cca07,cca11,     #No.FUN-7C0101 add cca06,cca07
        cca12a, cca12b, cca12c, cca12d, cca12e,cca12f,cca12g,cca12h, cca12,   #No.FUN-7C0101 add cca12f,cca12g,cca12h       
        cca23a, cca23b, cca23c, cca23d, cca23e,cca23f,cca23g,cca23h, cca23,   #No.FUN-7C0101 add cca23f,cca23g,cca23h
        ccauser,ccagrup,ccamodu,ccadate,ccaoriu,ccaorig,   #TQC-9C0028 mod
        ccaud01,ccaud02,ccaud03,ccaud04,ccaud05,
        ccaud06,ccaud07,ccaud08,ccaud09,ccaud10,
        ccaud11,ccaud12,ccaud13,ccaud14,ccaud15
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
        AFTER FIELD cca06
              LET l_cca06 = get_fldbuf(cca06)
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
       ON ACTION controlp
          CASE WHEN INFIELD(cca01) #item
#FUN-AA0059---------mod------------str-----------------          
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.state    = "c"
#                     LET g_qryparam.form     = "q_ima"
#                     LET g_qryparam.default1 = g_cca.cca01
#                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","",g_cca.cca01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                     DISPLAY g_qryparam.multiret TO cca01
                     NEXT FIELD cca01
              WHEN INFIELD(cca07)                                               
                 IF l_cca06 MATCHES '[45]' THEN                             
                    CALL cl_init_qry_var()       
                    LET g_qryparam.state= "c"                                
                 CASE l_cca06                                               
                    WHEN '4'                                                    
                      LET g_qryparam.form = "q_pja"                             
                    WHEN '5'                                                    
                      #LET g_qryparam.form = "q_gem4"                            
                      LET g_qryparam.form = "q_imd3"  #MOD-A10178                          
                    OTHERWISE EXIT CASE                                         
                 END CASE                                                       
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                     
                 DISPLAY  g_qryparam.multiret TO cca07                                   
                 NEXT FIELD cca07                                               
                 END IF                                                         
         END CASE
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ccauser', 'ccagrup') #FUN-980030
 
    LET g_sql="SELECT cca01,cca02,cca03,cca06,cca07 FROM cca_file ", # 組合出 SQL 指令#No.FUN-7C0101 add cca06,cca07
        " WHERE ",g_wc CLIPPED, " ORDER BY cca01,cca02,cca03,cca06,cca07"  #No.FUN-7C0101
 
    PREPARE t001_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t001_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t001_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cca_file WHERE ",g_wc CLIPPED
    PREPARE t001_precount FROM g_sql
    DECLARE t001_count CURSOR FOR t001_precount
END FUNCTION
 
FUNCTION t001_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t001_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t001_q()
            END IF
        ON ACTION next 
            CALL t001_fetch('N') 
        ON ACTION previous 
            CALL t001_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t001_u()
            END IF
        ON ACTION delete 
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t001_r()
            END IF
       ON ACTION output 
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL t001_out()
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
            CALL t001_fetch('/')
        ON ACTION first
            CALL t001_fetch('F')
        ON ACTION last
            CALL t001_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_cca.cca01 IS NOT NULL THEN
                  LET g_doc.column1 = "cca01"
                  LET g_doc.value1 = g_cca.cca01
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
    CLOSE t001_cs
END FUNCTION
 
 
FUNCTION t001_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_cca.* TO NULL
    LET g_cca.cca02=g_cca_t.cca02
    LET g_cca.cca03=g_cca_t.cca03
    LET g_cca.cca11=0 LET g_cca.cca12=0
    LET g_cca.cca12a=0 LET g_cca.cca12b=0 LET g_cca.cca12c=0
    LET g_cca.cca12d=0 LET g_cca.cca12e=0
    LET g_cca.cca12f=0 LET g_cca.cca12g=0 LET g_cca.cca12h=0    #No.FUN-7C0101
    LET g_cca.cca23a=0 LET g_cca.cca23b=0 LET g_cca.cca23c=0
    LET g_cca.cca23d=0 LET g_cca.cca23e=0 
    LET g_cca.cca23f=0 LET g_cca.cca23g=0 LET g_cca.cca23h=0    #No.FUN-7C0101
    LET g_cca.cca23 =0
    LET g_cca.cca06 = g_ccz.ccz28                               #No.FUN-7C0101 
    LET g_cca01_t = NULL
    LET g_cca02_t = NULL
    LET g_cca03_t = NULL
    LET g_cca06_t = NULL   #No.FUN-7C0101
    LET g_cca07_t = NULL   #No.FUN-7C0101
    CALL cl_opmsg('a')
    WHILE TRUE
	LET g_cca.ccaacti ='Y'                   #有效的資料
	LET g_cca.ccauser = g_user
	LET g_cca.ccaoriu = g_user #FUN-980030
	LET g_cca.ccaorig = g_grup #FUN-980030
	LET g_data_plant = g_plant #FUN-980030
	LET g_cca.ccagrup = g_grup               #使用者所屬群
	LET g_cca.ccadate = g_today
	#LET g_cca.ccaplant= g_plant #FUN-980009 add    #FUN-A50075
        LET g_cca.ccalegal= g_legal #FUN-980009 add
        CALL t001_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_cca.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_cca.cca01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO cca_file VALUES(g_cca.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","cca_file",g_cca.cca01,g_cca.cca02,SQLCA.sqlcode,"","ins cca",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            LET g_cca_t.* = g_cca.*                # 保存上筆資料
            SELECT cca01,cca02,cca03,cca06,cca07 INTO g_cca.cca01,g_cca.cca02,g_cca.cca03,g_cca.cca06,g_cca.cca07 FROM cca_file
                WHERE cca01 = g_cca.cca01
                  AND cca02 = g_cca.cca02 AND cca03 = g_cca.cca03
                  AND cca06 = g_cca.cca06 AND cca07 = g_cca.cca07 #No.FUN-7C0101
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t001_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_pja01         LIKE pja_file.pja01,          #No.FUN-7C0101 add
        l_imd09         LIKE imd_file.imd09,          #No.MOD-950013 add
        l_gem01         LIKE gem_file.gem01           #No.FUN-7C0101 add
DEFINE  l_chr    LIKE type_file.chr1,  #MOD-D20071
        l_bdate  LIKE sma_file.sma53,  #MOD-D20071
        l_edate  LIKE sma_file.sma53   #MOD-D20071    
        
    INPUT BY NAME 
        g_cca.cca01,g_cca.cca02,g_cca.cca03,g_cca.cca06,g_cca.cca07,g_cca.cca11, #No.FUN-7C0101 add cca06,cca07
        g_cca.cca12a, g_cca.cca12b, g_cca.cca12c, g_cca.cca12d, g_cca.cca12e,
        g_cca.cca12f,g_cca.cca12g,g_cca.cca12h,  #No.FUN-7C0101
        g_cca.cca12,
        g_cca.cca23a, g_cca.cca23b, g_cca.cca23c, g_cca.cca23d, g_cca.cca23e,
        g_cca.cca23f,g_cca.cca23g,g_cca.cca23h,   #No.FUN-7C0101
        g_cca.cca23,
        g_cca.ccauser,g_cca.ccagrup,g_cca.ccamodu,g_cca.ccadate,g_cca.ccaoriu,g_cca.ccaorig,  #TQC-9C0028 mod
        g_cca.ccaud01,g_cca.ccaud02,g_cca.ccaud03,g_cca.ccaud04,
        g_cca.ccaud05,g_cca.ccaud06,g_cca.ccaud07,g_cca.ccaud08,
        g_cca.ccaud09,g_cca.ccaud10,g_cca.ccaud11,g_cca.ccaud12,
        g_cca.ccaud13,g_cca.ccaud14,g_cca.ccaud15
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t001_set_entry(p_cmd)
          CALL t001_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
        AFTER FIELD cca01
          IF g_cca.cca01 IS NOT NULL THEN
            #FUN-AA0059 ---------------------------add start------------------------
            IF NOT s_chk_item_no(g_cca.cca01,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD cca01
            END IF 
            #FUN-AA0059 ---------------------------add end------------------------------   
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_cca.cca01
            IF STATUS THEN
               CALL cl_err3("sel","ima_file",g_cca.cca01,"",STATUS,"","sel ima:",1)  #No.FUN-660127
               IF p_cmd = 'u' AND  g_cca.cca01 = g_cca01_t  THEN          #TQC-970211                                               
               ELSE                                           #TQC-970211                                                           
                NEXT FIELD cca01                                                                                                    
               END IF                                         #TQC-970211  
            END IF
            DISPLAY BY NAME g_ima.ima02,g_ima.ima25
          END IF
 
        AFTER FIELD cca02
          IF g_cca.cca02 <= 0 THEN 
             CALL cl_err(g_cca.cca02,'axc-207',0)
             NEXT FIELD cca02
          END IF 
          #MOD-D20071---begin
          IF NOT cl_null(g_cca.cca02) AND NOT cl_null(g_cca.cca03) THEN 
             SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
             CALL s_azm(g_cca.cca02,g_cca.cca03+1) RETURNING l_chr,l_bdate,l_edate #No:190110 add +1  
             IF l_edate <= g_sma.sma53 THEN           
                CALL cl_err('','alm1561',1)
                NEXT FIELD cca02
             END IF
          END IF 
          #MOD-D20071---end
 
        AFTER FIELD cca03
          IF g_cca.cca03 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND 
               (g_cca.cca01 != g_cca01_t OR
                g_cca.cca02 != g_cca02_t OR g_cca.cca03 != g_cca03_t OR
                g_cca.cca06 != g_cca06_t OR g_cca.cca07 != g_cca07_t)) THEN #No.FUN-7C0101
                SELECT count(*) INTO l_n FROM cca_file
                    WHERE cca01 = g_cca.cca01
                      AND cca02 = g_cca.cca02 AND cca03 = g_cca.cca03
                      AND cca06 = g_cca.cca06 AND cca07 = g_cca.cca07  #No.FUN-7C0101
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD cca01
                END IF
            END IF
            IF g_cca.cca03 <= 0 THEN 
               CALL cl_err(g_cca.cca03,'axc-207',0)
               NEXT FIELD cca03
            END IF
            #MOD-D20071---begin
            IF NOT cl_null(g_cca.cca02) AND NOT cl_null(g_cca.cca03) THEN 
               SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
               CALL s_azm(g_cca.cca02,g_cca.cca03+1) RETURNING l_chr,l_bdate,l_edate  #No:190110 add +1 
               IF l_edate <= g_sma.sma53 THEN           
                  CALL cl_err('','alm1561',1)
                  NEXT FIELD cca03
               END IF
            END IF 
            #MOD-D20071---end
          END IF
        AFTER FIELD cca06
          IF g_cca.cca06 IS NOT NULL THEN
          # IF g_cca.cca06 NOT MATCHES '[12345]' THEN     #FUN-BC0062
            IF g_cca.cca06 NOT MATCHES '[123456]' THEN    #FUN-BC0062
               NEXT FIELD cca06
            END IF
            #  IF g_cca.cca06 MATCHES'[12]' THEN          #FUN-BC0062
               IF g_cca.cca06 MATCHES'[126]' THEN         #FUN-BC0062 
                  CALL cl_set_comp_entry("cca07",FALSE)
                  LET g_cca.cca07 = ' '
               ELSE
                  CALL cl_set_comp_entry("cca07",TRUE)
               END IF
          END IF
          
        AFTER FIELD cca07
            IF NOT cl_null(g_cca.cca07) OR g_cca.cca07 != ' '  THEN
               IF g_cca.cca06='4'THEN
                  SELECT pja01 INTO l_pja01 FROM pja_file WHERE pja01=g_cca.cca07
                                                            AND pjaclose='N' #No.FUN-960038
                  IF STATUS THEN
                     CALL cl_err3("sel","pja_file",g_cca.cca07,"",STATUS,"","sel pja:",1)
                     NEXT FIELD cca07
                  END IF
               END IF
               IF g_cca.cca06='5'THEN
                  SELECT UNIQUE imd09 INTO l_imd09 FROM imd_file WHERE imd09=g_cca.cca07
                  IF STATUS THEN
                     CALL cl_err3("sel","imd_file",g_cca.cca07,"",STATUS,"","sel imd:",1)    #No.MOD-950013 add
                     NEXT FIELD cca07
                  END IF
               END IF
            ELSE 
               LET g_cca.cca07 = ' '
            END IF
        AFTER FIELD cca11,cca12a,cca12b,cca12c,cca12d,cca12e,cca12f,cca12g,cca12h #No.FUN-7C0101
            CALL t001_u_cost()
 
        AFTER FIELD cca23a,cca23b,cca23c,cca23d,cca23e,cca23f,cca23g,cca23h       #No.FUN-7C0101
            CALL t001_u_23()
 
        AFTER FIELD ccaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_cca.ccauser = s_get_data_owner("cca_file") #FUN-C10039
           LET g_cca.ccagrup = s_get_data_group("cca_file") #FUN-C10039
           LET l_flag='N'
           IF INT_FLAG THEN
               EXIT INPUT  
           END IF
           IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD cca01
           END IF
           #20131202 add by suncx sta-------
           IF NOT t001_chk(g_cca.cca02,g_cca.cca03) THEN
              CALL cl_err('','axc-809',1)
              NEXT FIELD cca02
           END IF
           #20131202 add by suncx end-------
 
         ON ACTION controlp
           CASE
              WHEN INFIELD(cca01) #料號
#FUN-AA0059---------mod------------str-----------------              
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     = "q_ima"
#                 LET g_qryparam.default1 = g_cca.cca01
#                 CALL cl_create_qry() RETURNING g_cca.cca01
                 CALL q_sel_ima(FALSE, "q_ima","",g_cca.cca01,"","","","","",'' ) 
                  RETURNING  g_cca.cca01
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_cca.cca01
                 NEXT FIELD cca01
              WHEN INFIELD(cca07)
                IF g_cca.cca06 MATCHES '[45]' THEN
                 CALL cl_init_qry_var()
                 CASE g_cca.cca06
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"                     
                    WHEN '5'
                      #LET g_qryparam.form = "q_gem4"
                      LET g_qryparam.form = "q_imd3"   #MOD-A10178 
                    OTHERWISE EXIT CASE
                 END CASE
                 LET g_qryparam.default1 = g_cca.cca07
                 CALL cl_create_qry() RETURNING g_cca.cca07
                 DISPLAY BY NAME g_cca.cca07
                END IF
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
 
FUNCTION t001_u_cost()
    IF cl_null(g_cca.cca11) THEN LET g_cca.cca11 = 0 END IF
    IF cl_null(g_cca.cca12) THEN LET g_cca.cca12 = 0 END IF
    IF cl_null(g_cca.cca12a) THEN LET g_cca.cca12a= 0 END IF
    IF cl_null(g_cca.cca12b) THEN LET g_cca.cca12b= 0 END IF
    IF cl_null(g_cca.cca12c) THEN LET g_cca.cca12c= 0 END IF
    IF cl_null(g_cca.cca12d) THEN LET g_cca.cca12d= 0 END IF
    IF cl_null(g_cca.cca12e) THEN LET g_cca.cca12e= 0 END IF
    IF cl_null(g_cca.cca12f) THEN LET g_cca.cca12f= 0 END IF   #No.FUN-7C0101
    IF cl_null(g_cca.cca12g) THEN LET g_cca.cca12g= 0 END IF   #NO.FUN-7C0101
    IF cl_null(g_cca.cca12h) THEN LET g_cca.cca12h= 0 END IF   #NO.FUN-7C0101
    LET g_cca.cca12a = cl_digcut(g_cca.cca12a,g_ccz.ccz26) 
    LET g_cca.cca12b = cl_digcut(g_cca.cca12b,g_ccz.ccz26) 
    LET g_cca.cca12c = cl_digcut(g_cca.cca12c,g_ccz.ccz26) 
    LET g_cca.cca12d = cl_digcut(g_cca.cca12d,g_ccz.ccz26) 
    LET g_cca.cca12e = cl_digcut(g_cca.cca12e,g_ccz.ccz26) 
    LET g_cca.cca12f = cl_digcut(g_cca.cca12f,g_ccz.ccz26)    #NO.FUN-7C0101 
    LET g_cca.cca12g = cl_digcut(g_cca.cca12g,g_ccz.ccz26)    #NO.FUN-7C0101
    LET g_cca.cca12h = cl_digcut(g_cca.cca12h,g_ccz.ccz26)    #NO.FUN-7C0101
    LET g_cca.cca12 = g_cca.cca12a+g_cca.cca12b+g_cca.cca12c 
                    + g_cca.cca12d+g_cca.cca12e
                    + g_cca.cca12f+g_cca.cca12g+g_cca.cca12h  #No.FUN-7C0101 add
    DISPLAY BY NAME g_cca.cca12
    IF g_cca.cca11 != 0
       THEN LET u_cost=g_cca.cca12/g_cca.cca11
       ELSE LET u_cost=NULL
    END IF
    DISPLAY BY NAME u_cost
    IF g_cca.cca11<>0 THEN
       LET g_cca.cca23a=g_cca.cca12a/g_cca.cca11
       LET g_cca.cca23b=g_cca.cca12b/g_cca.cca11
       LET g_cca.cca23c=g_cca.cca12c/g_cca.cca11
       LET g_cca.cca23d=g_cca.cca12d/g_cca.cca11
       LET g_cca.cca23e=g_cca.cca12e/g_cca.cca11
       LET g_cca.cca23f=g_cca.cca12f/g_cca.cca11    #No.FUN-7C0101
       LET g_cca.cca23g=g_cca.cca12g/g_cca.cca11    #No.FUN-7C0101
       LET g_cca.cca23h=g_cca.cca12h/g_cca.cca11    #No.FUN-7C0101
       LET g_cca.cca23 =g_cca.cca12 /g_cca.cca11
       DISPLAY BY NAME g_cca.cca23,g_cca.cca23a,g_cca.cca23b,g_cca.cca23c,
                                   g_cca.cca23d,g_cca.cca23e,
                                   g_cca.cca23f,g_cca.cca23g,g_cca.cca23h  #No.FUN-7C0101                                   
    END IF
END FUNCTION
   
FUNCTION t001_u_23()   
    LET g_cca.cca23=g_cca.cca23a+g_cca.cca23b+g_cca.cca23c+
                    g_cca.cca23d+g_cca.cca23e
                    +g_cca.cca23f+g_cca.cca23g+g_cca.cca23h  #No.FUN-7C0101 add
    DISPLAY BY NAME g_cca.cca23
END FUNCTION
 
FUNCTION t001_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cca.* TO NULL              #No.FUN-6A0019
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t001_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t001_count
    FETCH t001_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t001_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t001_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_cca.* TO NULL
    ELSE
        CALL t001_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t001_fetch(p_flcca)
    DEFINE
        p_flcca          LIKE type_file.chr1          #No.FUN-680122CHAR(01)
 
    CASE p_flcca
        WHEN 'N' FETCH NEXT     t001_cs INTO g_cca.cca01,g_cca.cca02,g_cca.cca03,g_cca.cca06,g_cca.cca07
        WHEN 'P' FETCH PREVIOUS t001_cs INTO g_cca.cca01,g_cca.cca02,g_cca.cca03,g_cca.cca06,g_cca.cca07
        WHEN 'F' FETCH FIRST    t001_cs INTO g_cca.cca01,g_cca.cca02,g_cca.cca03,g_cca.cca06,g_cca.cca07
        WHEN 'L' FETCH LAST     t001_cs INTO g_cca.cca01,g_cca.cca02,g_cca.cca03,g_cca.cca06,g_cca.cca07
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
            FETCH ABSOLUTE g_jump t001_cs INTO g_cca.cca01,g_cca.cca02,g_cca.cca03,g_cca.cca06,g_cca.cca07
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cca.cca01,SQLCA.sqlcode,0)
        INITIALIZE g_cca.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcca
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cca.* FROM cca_file            # 重讀DB,因TEMP有不被更新特性
       WHERE cca01=g_cca.cca01 AND cca02=g_cca.cca02 ANd cca03=g_cca.cca03 AND cca06 = g_cca.cca06 AND cca07=g_cca.cca07 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","cca_file",g_cca.cca01,g_cca.cca02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE                                           #FUN-4C0061權限控管
       LET g_data_owner = g_cca.ccauser
       LET g_data_group = g_cca.ccagrup
      #LET g_data_plant = g_cca.ccaplant #FUN-980030    #FUN-A50075
       LET g_data_plant = g_plant        #FUN-A50075
        CALL t001_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t001_show()
    LET g_cca_t.* = g_cca.*
    DISPLAY BY NAME g_cca.ccaoriu,g_cca.ccaorig,
        g_cca.cca01,g_cca.cca02,g_cca.cca03,g_cca.cca11,
        g_cca.cca06,g_cca.cca07,                      #No.FUN-7C0101 add
        g_cca.cca12a, g_cca.cca12b, g_cca.cca12c, g_cca.cca12d, g_cca.cca12e,
        g_cca.cca12f,g_cca.cca12g,g_cca.cca12h,       #No.FUN-7C0101 add
        g_cca.cca12, 
        g_cca.cca23a, g_cca.cca23b, g_cca.cca23c, g_cca.cca23d, g_cca.cca23e,
        g_cca.cca23f,g_cca.cca23g,g_cca.cca23h,        #No.FUN-7C0101 add
        g_cca.cca23, 
        g_cca.ccauser,g_cca.ccagrup,g_cca.ccamodu,g_cca.ccadate, 
        g_cca.ccaud01,g_cca.ccaud02,g_cca.ccaud03,g_cca.ccaud04,
        g_cca.ccaud05,g_cca.ccaud06,g_cca.ccaud07,g_cca.ccaud08,
        g_cca.ccaud09,g_cca.ccaud10,g_cca.ccaud11,g_cca.ccaud12,
        g_cca.ccaud13,g_cca.ccaud14,g_cca.ccaud15
 
    INITIALIZE g_ima.* TO NULL  #No:9484
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_cca.cca01
    LET u_cost=NULL
    IF g_cca.cca11 != 0 THEN LET u_cost=g_cca.cca12/g_cca.cca11 END IF
    DISPLAY BY NAME g_ima.ima25,g_ima.ima02,u_cost
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t001_u()
DEFINE l_date   LIKE sma_file.sma53  #TQC-A20054
DEFINE l_chr    LIKE type_file.chr1,  #MOD-CA0137 add
       l_bdate  LIKE sma_file.sma53, #MOD-CA0137 add
       l_edate  LIKE sma_file.sma53  #MOD-CA0137 add
DEFINE l_cca03  LIKE cca_file.cca03  #131129 add by suncx
DEFINE l_cca02  LIKE cca_file.cca02  #131129 add by suncx

    IF g_cca.cca01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

    #TQC-A20054---Begin
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   #LET l_date = MDY(g_cca.cca03,1,g_cca.cca02)  #MOD-CA0137 mark
    #131129 add by suncx str------------
    IF g_cca.cca03 >= 12 THEN
       LET l_cca02 = g_cca.cca02 + 1
       LET l_cca03 = 1
    ELSE
       LET l_cca02 = g_cca.cca02
       LET l_cca03 = g_cca.cca03 + 1 
    END IF
    #131129 add by suncx end------------
   #CALL s_azm(g_cca.cca02,g_cca.cca03) RETURNING l_chr,l_bdate,l_edate  #MOD-CA0137
    CALL s_azm(l_cca02,l_cca03) RETURNING l_chr,l_bdate,l_edate  #131129 g_cca.cca02,g_cca.cca03 -> l_cca02,l_cca03 by suncx
   #CALL s_last(l_date) RETURNING l_date         #MOD-CA0137 mark 
   #IF l_date <= g_sma.sma53 THEN                #MOD-CA0137 mark
    IF l_edate <= g_sma.sma53 THEN               #MOD-CA0137
      #CALL cl_err('','clm-012',1) #FUN-BC0082
       CALL cl_err('','alm1561',1) #FUN-BC0082
       RETURN
    END IF
    #TQC-A20054---End
    #20131202 add by suncx sta-------
    IF NOT t001_chk(g_cca.cca02,g_cca.cca03) THEN
       CALL cl_err('','axc-809',1)
       RETURN
    END IF
    #20131202 add by suncx end-------

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cca01_t = g_cca.cca01
    LET g_cca02_t = g_cca.cca02
    LET g_cca03_t = g_cca.cca03
    LET g_cca06_t = g_cca.cca06 #No.FUN-7C0101 add
    LET g_cca07_t = g_cca.cca07 #No.FUN-7C0101 add
    BEGIN WORK
 
    OPEN t001_cl USING g_cca.cca01,g_cca.cca02,g_cca.cca03,g_cca.cca06,g_cca.cca07
    IF STATUS THEN
       CALL cl_err("OPEN t001_cl:", STATUS, 1)
       CLOSE t001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t001_cl INTO g_cca.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
     IF cl_null(g_cca.ccaacti) THEN LET g_cca.ccaacti ='Y' END IF 
     IF cl_null(g_cca.ccauser) THEN LET g_cca.ccauser = g_user END IF 
     IF cl_null(g_cca.ccagrup) THEN LET g_cca.ccagrup = g_grup END IF  
	LET g_cca.ccamodu=g_user                     #修改者
	LET g_cca.ccadate = g_today                  #修改日期
    CALL t001_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t001_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cca.*=g_cca_t.*
            CALL t001_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cca_file SET cca_file.* = g_cca.*    # 更新DB
            WHERE cca01 = g_cca_t.cca01 AND cca02 = g_cca_t.cca02 AND cca03 = g_cca_t.cca03 AND cca06=g_cca_t.cca06 AND cca07 = g_cca_t.cca07              # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","cca_file",g_cca01_t,g_cca02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t001_r()

    DEFINE l_chr   LIKE type_file.chr1,  #MOD-CA0137 add
           l_bdate  LIKE sma_file.sma53, #MOD-CA0137 add
           l_edate  LIKE sma_file.sma53  #MOD-CA0137 add
    DEFINE l_cca03  LIKE cca_file.cca03  #20131209 add by suncx
    DEFINE l_cca02  LIKE cca_file.cca02  #20131209 add by suncx

   #TQC-A20054---Begin
    DEFINE l_date     LIKE sma_file.sma53
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   #LET l_date = MDY(g_cca.cca03,1,g_cca.cca02)  #MOD-CA0137 mark
   #CALL s_azm(g_cca.cca02,g_cca.cca03) RETURNING l_chr,l_bdate,l_edate  #MOD-CA0137
    #131129 add by suncx str------------
    IF g_cca.cca03 >= 12 THEN
       LET l_cca02 = g_cca.cca02 + 1
       LET l_cca03 = 1
    ELSE
       LET l_cca02 = g_cca.cca02
       LET l_cca03 = g_cca.cca03 + 1 
    END IF
    #131129 add by suncx end------------
    CALL s_azm(l_cca02,l_cca03) RETURNING l_chr,l_bdate,l_edate  #20131209 g_cca.cca02,g_cca.cca03->l_cca02,l_cca03 by suncx
   #CALL s_last(l_date) RETURNING l_date         #MOD-CA0137 mark
   #IF l_date <= g_sma.sma53 THEN                #MOD-CA0137 mark
    IF l_edate <= g_sma.sma53 THEN               #MOD-CA0137
      #CALL cl_err('','clm-012',1) #FUN-BC0082
       CALL cl_err('','alm1561',1) #FUN-BC0082
       RETURN
    END IF
    #TQC-A20054---End

    IF g_cca.cca01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    #20131202 add by suncx sta-------
    IF NOT t001_chk(g_cca.cca02,g_cca.cca03) THEN
       CALL cl_err('','axc-809',1)
       RETURN
    END IF
    #20131202 add by suncx end-------

    BEGIN WORK
 
    OPEN t001_cl USING g_cca.cca01,g_cca.cca02,g_cca.cca03,g_cca.cca06,g_cca.cca07
    IF STATUS THEN
       CALL cl_err("OPEN t001_cl:", STATUS, 1)
       CLOSE t001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t001_cl INTO g_cca.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cca.cca01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t001_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cca01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cca.cca01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM cca_file WHERE cca01 = g_cca.cca01
                              AND cca02 = g_cca.cca02 AND cca03 = g_cca.cca03
                              AND cca06 = g_cca.cca06 AND cca07 = g_cca.cca07 #No.FUN-7C0101 add
       CLEAR FORM
       OPEN t001_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t001_cl
          CLOSE t001_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t001_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t001_cl
          CLOSE t001_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t001_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t001_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t001_fetch('/')
       END IF
    END IF
    CLOSE t001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t001_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)               # External(Disk) file name
        l_za05          LIKE ima_file.ima01,        #No.FUN-680122 VARCHAR(40)               #
        l_cca RECORD LIKE cca_file.*,
        sr RECORD
           ima02  LIKE ima_file.ima02,
           ima021 LIKE ima_file.ima021,   #FUN-5C0002
           ima25  LIKE ima_file.ima25
           END RECORD
 
    IF g_wc IS NULL THEN
       IF cl_null(g_cca.cca01) THEN 
          CALL cl_err('','9057',0) RETURN 
       ELSE
          LET g_wc=" cca01='",g_cca.cca01,"'"
       END IF
       IF NOT cl_null(g_cca.cca02) THEN
          LET g_wc=g_wc," and cca02=",g_cca.cca02
       END IF
       IF NOT cl_null(g_cca.cca03) THEN
          LET g_wc=g_wc," and cca03=",g_cca.cca03
       END IF 
       IF NOT cl_null(g_cca.cca06) THEN
          LET g_wc=g_wc," and cca06=",g_cca.cca06
       END IF
       IF NOT cl_null(g_cca.cca07) THEN
          LET g_wc=g_wc," and cca07=",g_cca.cca07
       END IF
    END IF
 
    CALL cl_wait()
    CALL cl_outnam('axct001') RETURNING l_name 
 
    CALL cl_del_data(l_table) 
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,? )"    #No.FUN-830135 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT cca_file.*, ima02,ima021,ima25 ",   #FUN-5C0002
              "  FROM cca_file LEFT OUTER JOIN ima_file ON cca01=ima_file.ima01 ",
              " WHERE  ",g_wc CLIPPED
    PREPARE t001_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t001_co CURSOR FOR t001_p1
 
 
    FOREACH t001_co INTO l_cca.*, sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        EXECUTE insert_prep USING l_cca.cca01,sr.ima02,sr.ima021,sr.ima25, #No.FUN-7C0034
                            l_cca.cca02,l_cca.cca03,l_cca.cca06,l_cca.cca07,l_cca.cca11,l_cca.cca12 #No.FUN-830135
    END FOREACH

          LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          CALL cl_wcchp(g_wc,'cca01,cca02,cca03,cca06,cca07,cca11,    #No.FUN-830135 add cca06,cca07 
                        cca12a, cca12b, cca12c, cca12d, cca12e, cca12,
                        cca23a, cca23b, cca23c, cca23d, cca23e, cca23,
                        ccauser,ccagrup,ccamodu,ccadate')
               RETURNING g_wc      
           LET g_str=g_wc clipped 
           CALL cl_prt_cs3('axct001','axct001',g_sql,g_str)
    CLOSE t001_co
    ERROR ""
END FUNCTION
 
FUNCTION t001_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("cca01,cca02,cca03,cca06,cca07",TRUE) #No.FUN-7C0101 add cca06,cca07
  END IF
END FUNCTION
 
FUNCTION t001_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("cca01,cca02,cca03,cca06,cca07",FALSE) #No.FUN-7C0101 add cca06,cca07
  END IF
  IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND
     (NOT g_before_input_done) THEN
  #  IF g_cca.cca06 MATCHES'[12]' THEN       #FUN-BC0062
     IF g_cca.cca06 MATCHES'[126]' THEN      #FUN-BC0062
        CALL cl_set_comp_entry("cca07",FALSE)
     ELSE
        CALL cl_set_comp_entry("cca07",TRUE)
     END IF
  END IF
     
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/12

#20131202 add by suncx begin--------------------------------
FUNCTION t001_chk(p_yy,p_mm)
DEFINE p_yy        LIKE type_file.num5,
       p_mm        LIKE type_file.num5
DEFINE l_bdate     LIKE type_file.dat,
       l_edate     LIKE type_file.dat
DEFINE l_sql       STRING
DEFINE l_n         LIKE type_file.num5
DEFINE l_correct   LIKE type_file.chr1 

      LET l_n = 0
      #CALL s_azm(p_yy,p_mm) RETURNING l_correct, l_bdate, l_edate  #No:190110 mark
      CALL s_azm(p_yy,p_mm+1) RETURNING l_correct, l_bdate, l_edate #No:190110 add
      LET l_sql = " SELECT COUNT(*) FROM npp_file",
                  "  WHERE nppsys  = 'CA'",
                  "    AND npp011  = '1'",
                  "    AND npp00 >= 2 AND npp00 <= 7 ",
                  "    AND npp00 <> 6 ",
                  "    AND nppglno IS NOT NULL ",
                  "    AND YEAR(npp02) = ",p_yy,  
                 # "    AND MONTH(npp02) = ",p_mm,   #No:190110 mark 
                  "    AND MONTH(npp02) = ",p_mm+1,  #No:190110 add
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
#20131202 add by suncx end----------------------------------
