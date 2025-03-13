# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axct401.4gl
# Descriptions...: 在製成本調整資料維護作業
# Date & Author..: 96/02/18 By Roger
# Update & Date..: 97/02/18 By Hack
# Modify.........: No.FUN-4C0005 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-4C0099 05/01/11 By kim 報表轉XML功能
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.MOD-580253 05/08/23 By kim 在製成本調整, 按更改鍵游標會成漏斗狀無法作業
# Modify.........: No.FUN-610080 06/01/23 By Sarah
#                  1.以傳入參數g_argv1判斷,g_argv1=1執行axct401,g_argv1=2執行axct402
#                  2.增加ccl00(調整類別),axct401時寫入ccl00='1',axct402時寫入ccl00='2',隱藏sfb05,ccl21
#                  3.ccl01(料件編號)增加開窗功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-740178 07/06/20 By Carol 加工單單號的開窗查詢的功能
# Modify.........: No.FUN-810099 07/12/19 By Sunyanchun    老報表改成p_query 
# Modify.........: No.FUN-7C0101 08/01/09 By ChenMoyan     增加ccl06,ccl07,ccl22f,ccl22g,ccl22h,更改ccl22
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830032 08/03/10 By lutingting p_query中將成本改善打印增加字段!
# Modify.........: No.FUN-810099 08/04/18 By ChenMoyan 修改g_argv1的默認值
# Modify.........: No.FUN-840202 08/04/29 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-910073 09/02/02 By jan 成本計算類別為"1or2"時,類別編號應noentry且自動給' '
# Modify.........: No.TQC-970214 09/07/20 By dxfwo  1.類別_q()段的查詢：未做init                                                    
#                   2.803行: LET g_ccl.ccl06 = g_ccz.ccz28  為key值                                                                 
#                     804行: LET g_ccl.ccl07 = ' '                   為key值                                                        
#                     805行:CALL t401_show()段，會把畫面更新，同時儲存舊值 g_ccl                                                    
#                        以上是在 _u()的程序，這樣給 ccl06跟ccl07的值會有問題吧
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-9C0073 10/01/13 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.TQC-AA0066 10/10/11 By xiaofeizhu 調整錄入順序
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ccl   RECORD LIKE ccl_file.*,
    g_ccl_t RECORD LIKE ccl_file.*,
    g_ccl01_t LIKE ccl_file.ccl01,
    g_ccl02_t LIKE ccl_file.ccl02,
    g_ccl03_t LIKE ccl_file.ccl03,
    g_ccl04_t LIKE ccl_file.ccl04,
    g_ccl06_t LIKE ccl_file.ccl06,
    g_ccl07_t LIKE ccl_file.ccl07,
    g_wc,g_sql          STRING,  #No.FUN-580092 HCN
    g_ima   RECORD LIKE ima_file.*,
    g_sfb   RECORD LIKE sfb_file.*,
    g_argv1             LIKE type_file.chr1           #No.FUN-680122 VARCHAR(01)   #FUN-610080
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03       #No.FUN-680122CHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680122 SMALLINT
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)
   CASE g_argv1
      WHEN "1" LET g_prog = 'axct401'
      WHEN "2" LET g_prog = 'axct402'
      OTHERWISE EXIT PROGRAM
   END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
   INITIALIZE g_ccl.* TO NULL
   INITIALIZE g_ccl_t.* TO NULL
 
   LET g_forupd_sql = " SELECT * FROM ccl_file WHERE ccl01 = ? AND ccl02 = ? AND ccl03 = ? AND ccl04 = ? AND ccl06 = ? AND ccl07 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t401_cl CURSOR FROM g_forupd_sql              
 
   LET p_row = 3 LET p_col = 14
   OPEN WINDOW t401_w AT p_row,p_col
       WITH FORM "axc/42f/axct401" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   IF g_argv1 = "2" THEN
      CALL cl_set_comp_visible("sfb05,ccl21",FALSE)
      #將ccl01的欄位顯示名稱改為"料件編號"
       CALL t401_change()   #FUN-810099
   END IF
 
   LET g_action_choice=""
   CALL t401_menu()
 
   CLOSE WINDOW t401_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t401_cs()
   DEFINE l_ccl06 LIKE ccl_file.ccl06            #FUN-7C0101
    CLEAR FORM
   INITIALIZE g_ccl.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ccl01,ccl02,ccl03,ccl06,ccl07,ccl05,ccl04,ccl21,         
        ccl22a,ccl22b,ccl22c,ccl22d,ccl22e,ccl22f,ccl22g,ccl22h,ccl22,
        ccluser,cclgrup,cclmodu,ccldate,
        cclud01,cclud02,cclud03,cclud04,cclud05,
        cclud06,cclud07,cclud08,cclud09,cclud10,
        cclud11,cclud12,cclud13,cclud14,cclud15
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       AFTER FIELD ccl06                                                                                                           
                  LET l_ccl06 = FGL_DIALOG_GETBUFFER()        #No.TQC-970214 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ccl01)   #料件編號/工單編號
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
 
                  IF g_argv1 = '2' THEN
#                    LET g_qryparam.form = "q_ima"
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                  ELSE 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_sfb05"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                  END IF 
 
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO ccl01
                  NEXT FIELD ccl01
              WHEN INFIELD(ccl07)                                                                            
                  IF l_ccl06 MATCHES '[45]' THEN 
                     CALL cl_init_qry_var()       
                     LET g_qryparam.state = "c"
                     IF l_ccl06 = '4' THEN                                                                                     
                        LET g_qryparam.form = "q_pja"                                                                                  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO ccl07                                                                              
                  NEXT FIELD ccl07                                                                                                  
                     ELSE                                                                                                              
                        LET g_qryparam.form = "q_gem4"            
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                
                  DISPLAY g_qryparam.multiret TO ccl07                                                                              
                  NEXT FIELD ccl07                                                                                                  
                     END IF                                                                    
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ccluser', 'cclgrup') #FUN-980030
 
    LET g_sql="SELECT ccl01,ccl02,ccl03,ccl04,ccl06,ccl07 FROM ccl_file ", #No.FUN-7C0101
        " WHERE ",g_wc CLIPPED
    CASE g_argv1
       WHEN "1"
          LET g_sql = g_sql CLIPPED," AND ccl00 ='1' "
       WHEN "2"
          LET g_sql = g_sql CLIPPED," AND ccl00 ='2' "
    END CASE
    LET g_sql = g_sql CLIPPED," ORDER BY ccl01,ccl02,ccl03,ccl04,ccl06,ccl07"    #No.FUN-7C0101
    PREPARE t401_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t401_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t401_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ccl_file WHERE ",g_wc CLIPPED
    CASE g_argv1
       WHEN "1"
          LET g_sql = g_sql CLIPPED," AND ccl00 ='1' "
       WHEN "2"
          LET g_sql = g_sql CLIPPED," AND ccl00 ='2' "
    END CASE
    PREPARE t401_precount FROM g_sql
    DECLARE t401_count CURSOR FOR t401_precount
END FUNCTION
 
FUNCTION t401_menu()
DEFINE l_cmd  LIKE type_file.chr1000           #No.FUN-810099---add---
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t401_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t401_q()
            END IF
        ON ACTION next 
            CALL t401_fetch('N') 
        ON ACTION previous 
            CALL t401_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t401_u()
            END IF
        ON ACTION delete 
            LET g_action_choice="delete" 
            IF cl_chk_act_auth() THEN
                 CALL t401_r()
            END IF
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
               CALL t401_copy()
            END IF
        ON ACTION output 
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CASE g_argv1                                                                                                         
                  WHEN "1" CALL t401_out()                                                                                          
                  WHEN "2" CALL t402_out()                                                                                          
               END CASE
            END IF
        ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            CALL t401_change()                        #FUN-810099
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t401_fetch('/')
        ON ACTION first
            CALL t401_fetch('F')
        ON ACTION last
            CALL t401_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_ccl.ccl01 IS NOT NULL THEN
                  LET g_doc.column1 = "ccl01"
                  LET g_doc.value1 = g_ccl.ccl01
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
    CLOSE t401_cs
END FUNCTION
 
 
FUNCTION t401_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_ccl.* TO NULL
    LET g_ccl.ccl02=g_ccl_t.ccl02
    LET g_ccl.ccl03=g_ccl_t.ccl03
    LET g_ccl.ccl04=g_ccl_t.ccl04
    LET g_ccl.ccl06=g_ccl_t.ccl06                #No.FUN-7C0101
    LET g_ccl.ccl07=g_ccl_t.ccl07                #No.FUN-7C0101
    LET g_ccl.ccl22=0
    LET g_ccl.ccl22a=0 LET g_ccl.ccl22b=0 LET g_ccl.ccl22c=0
    LET g_ccl.ccl22d=0 LET g_ccl.ccl22e=0
    LET g_ccl.ccl22f=0 LET g_ccl.ccl22g=0 LET g_ccl.ccl22h=0  #No.FUN-7C0101 
    LET g_ccl01_t = NULL
    LET g_ccl02_t = NULL
    LET g_ccl03_t = NULL
    LET g_ccl04_t = NULL
    LET g_ccl06_t = NULL                         #No.FUN-7C0101
    LET g_ccl07_t = NULL                         #No.FUN-7C0101 
    LET g_ccl_t.*=g_ccl.*
    CALL cl_opmsg('a')
    WHILE TRUE

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          EXIT WHILE
       END IF
#FUN-BC0062 --end--

        LET g_ccl.cclacti ='Y'                   #有效的資料
        LET g_ccl.ccluser = g_user
        LET g_ccl.ccloriu = g_user #FUN-980030
        LET g_ccl.cclorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_ccl.cclgrup = g_grup               #使用者所屬群
        LET g_ccl.ccldate = g_today
        LET g_ccl.ccl06 = g_ccz.ccz28            #No.FUN-7C0101
        LET g_ccl.ccl07 = ' '                    #No.FUN-7C0101
       #LET g_ccl.cclplant = g_plant #FUN-980009 add    #FUN-A50075
        LET g_ccl.ccllegal = g_legal #FUN-980009 add
        CASE g_argv1
           WHEN "1" LET g_ccl.ccl00 ='1'
           WHEN "2" LET g_ccl.ccl00 ='2'
        END CASE
        DISPLAY BY NAME g_ccl.ccl00
        CALL t401_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_ccl.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ccl.ccl01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_ccl.ccl04 IS NULL THEN LET g_ccl.ccl04 = ' ' END IF
        INSERT INTO ccl_file VALUES(g_ccl.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ccl_file",g_ccl.ccl01,g_ccl.ccl02,SQLCA.sqlcode,"","ins ccl:",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            LET g_ccl_t.* = g_ccl.*                # 保存上筆資料
            SELECT ccl01,ccl02,ccl03,ccl04,ccl06,ccl07 INTO g_ccl.ccl01,g_ccl.ccl02,g_ccl.ccl03,g_ccl.ccl04,g_ccl.ccl06,g_ccl.ccl07 FROM ccl_file
                WHERE ccl01 = g_ccl.ccl01 AND ccl02 = g_ccl.ccl02
                  AND ccl03 = g_ccl.ccl03 AND ccl04 = g_ccl.ccl04
                  AND ccl06 = g_ccl.ccl06 AND ccl07 = g_ccl.ccl07  #No.FUN-7C0101 
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t401_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    INPUT BY NAME #g_ccl.ccloriu,g_ccl.cclorig,       #TQC-AA0066 Mark 
        g_ccl.ccl01,g_ccl.ccl02,g_ccl.ccl03,g_ccl.ccl06,g_ccl.ccl07,g_ccl.ccl05,
        g_ccl.ccl04,g_ccl.ccl21,
        g_ccl.ccl22a, g_ccl.ccl22b, g_ccl.ccl22c, g_ccl.ccl22d, g_ccl.ccl22e,
        g_ccl.ccl22f,g_ccl.ccl22g,g_ccl.ccl22h,        #No.FUN-7C0101 
        g_ccl.ccl22, 
        g_ccl.ccluser,g_ccl.cclgrup,g_ccl.cclmodu,g_ccl.ccldate,
        g_ccl.cclud01,g_ccl.cclud02,g_ccl.cclud03,g_ccl.cclud04,
        g_ccl.cclud05,g_ccl.cclud06,g_ccl.cclud07,g_ccl.cclud08,
        g_ccl.cclud09,g_ccl.cclud10,g_ccl.cclud11,g_ccl.cclud12,
        g_ccl.cclud13,g_ccl.cclud14,g_ccl.cclud15
       ,g_ccl.ccloriu,g_ccl.cclorig       #TQC-AA0066 Add
        WITHOUT DEFAULTS 
 
       BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t401_set_entry(p_cmd)
          CALL t401_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          IF g_ccl.ccl00 = '1' THEN   #FUN-610080
             CALL cl_set_docno_format("ccl01")
          END IF                      #FUN-610080
          CALL cl_set_docno_format("ccl04")
 
       AFTER FIELD ccl01
          IF g_ccl.ccl01 IS NOT NULL THEN 
            #FUN-AA0059 ----------------------add start------------------------
             IF g_ccl.ccl00 != '1' THEN 
                IF NOT s_chk_item_no(g_ccl.ccl01,'') THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD ccl01
                END IF 
             END IF 
            #FUN-AA0059 -------------------------add end------------------------ 
             IF (p_cmd='a') OR (p_cmd='u' AND g_ccl.ccl01!=g_ccl_t.ccl01) THEN #MOD-580253
                IF g_ccl.ccl00 = '1' THEN   #FUN-610080
                   SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=g_ccl.ccl01 
                   IF STATUS THEN
                      CALL cl_err3("sel","sfb_file",g_ccl.ccl01,"",STATUS,"","sel sfb:",1)  #No.FUN-660127
                      NEXT FIELD ccl01
                   END IF
                   SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_sfb.sfb05
                ELSE
                   SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccl.ccl01
                END IF
                IF STATUS THEN
                    CALL cl_err3("sel","ima_file",g_ccl.ccl01,"",STATUS,"","sel ima:",1)  #No.FUN-660127
                   NEXT FIELD ccl01
                END IF
                DISPLAY BY NAME g_sfb.sfb05,g_ima.ima02,g_ima.ima25
             END IF
          END IF
 
       AFTER FIELD ccl04
          IF g_ccl.ccl04 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND 
               (g_ccl.ccl01 != g_ccl01_t OR g_ccl.ccl02 != g_ccl02_t OR
                g_ccl.ccl06 != g_ccl06_t OR g_ccl.ccl07 != g_ccl07_t OR  #No.FUN-7C0101
                g_ccl.ccl03 != g_ccl03_t OR g_ccl.ccl04 != g_ccl04_t)) THEN
                SELECT count(*) INTO l_n FROM ccl_file
                WHERE ccl01 = g_ccl.ccl01 AND ccl02 = g_ccl.ccl02
                  AND ccl03 = g_ccl.ccl03 AND ccl04 = g_ccl.ccl04
                  AND ccl06 = g_ccl.ccl06 AND ccl07 = g_ccl.ccl07        #No.FUN-7C0101
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD ccl01
                END IF
            END IF
          END IF
 
      AFTER FIELD ccl06
        IF g_ccl.ccl06 IS NOT NULL THEN
           IF g_ccl.ccl06 MATCHES'[12]' THEN
              CALL cl_set_comp_entry("ccl07",FALSE)
              LET g_ccl.ccl07 = ' '
           ELSE 
              CALL cl_set_comp_entry("ccl07",TRUE)
           END IF
        END IF
 
      AFTER FIELD ccl07                                                                                                          
          IF cl_null(g_ccl.ccl07) THEN              
            LET g_ccl.ccl07 = " " 
          ELSE                                                                           
            IF g_ccl.ccl06='4'THEN                                                                                               
              SELECT pja01 FROM pja_file WHERE pja01=g_ccl.ccl07                                                   
                                           AND pjaclose='N'     #FUN-960038
              IF STATUS THEN                                                                                                    
                  CALL cl_err3("sel","pja_file",g_ccl.ccl07,"",STATUS,"","sel pja:",1)                                           
                  NEXT FIELD ccl07                                                                                               
               END IF                                                                                                            
            END IF                                                                                                               
            IF g_ccl.ccl06='5'THEN                                                                                               
              SELECT gem01 FROM gem_file WHERE gem01=g_ccl.ccl07                                                   
              IF STATUS THEN                                                                                                    
                  CALL cl_err3("sel","gem_file",g_ccl.ccl07,"",STATUS,"","sel gem:",1)                                           
                  NEXT FIELD ccl07                                                                                               
              END IF                                                                                                            
            END IF                                                                                                               
          END IF      
       AFTER FIELD ccl22a,ccl22b,ccl22c,ccl22d,ccl22e
             ,ccl22f,ccl22g,ccl22h               #No.FUN-7C0101 
          CALL t401_u_cost()
 
       AFTER FIELD cclud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF  
 
       AFTER FIELD cclud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER FIELD cclud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF 
 
       AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
          LET g_ccl.ccluser = s_get_data_owner("ccl_file") #FUN-C10039
          LET g_ccl.cclgrup = s_get_data_group("ccl_file") #FUN-C10039
          LET l_flag='N'
          IF INT_FLAG THEN
              EXIT INPUT  
          END IF
          IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD ccl01
          END IF
          #20131209 add by suncx sta-------
          IF NOT t401_chk(g_ccl.ccl02,g_ccl.ccl03) THEN
             CALL cl_err('','axc-809',1)
             NEXT FIELD ccl02
          END IF
          #20131209 add by suncx end-------
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ccl01)   #元件料號
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
                  
                  IF g_argv1 = '2' THEN
#                    LET g_qryparam.form = "q_ima"
                     CALL q_sel_ima(FALSE, "q_ima","",g_ccl.ccl01,"","","","","",'' ) 
                       RETURNING  g_ccl.ccl01
                  ELSE 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_sfb05"
                     LET g_qryparam.default1 = g_ccl.ccl01
                     CALL cl_create_qry() RETURNING g_ccl.ccl01
                  END IF 
 
#               LET g_qryparam.default1 = g_ccl.ccl01
#               CALL cl_create_qry() RETURNING g_ccl.ccl01
#FUN-AA0059---------mod------------end-----------------
                DISPLAY BY NAME g_ccl.ccl01
                NEXT FIELD ccl01
             WHEN INFIELD(ccl07)
                IF g_ccl.ccl06 MATCHES '[45]' THEN
                   CALL cl_init_qry_var()
                   IF g_ccl.ccl06 = '4' THEN
                      LET g_qryparam.form = "q_pja"
                   END IF 
                   IF g_ccl.ccl06 = '5' THEN
                      LET g_qryparam.form = "q_gem4"
                   END IF
                   LET g_qryparam.default1 = g_ccl.ccl07
                   CALL cl_create_qry() RETURNING g_ccl.ccl07
                   DISPLAY BY NAME g_ccl.ccl07
                END IF
                NEXT FIELD ccl07
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
 
FUNCTION t401_u_cost()
    LET g_ccl.ccl22=g_ccl.ccl22a+g_ccl.ccl22b+g_ccl.ccl22c+
                    g_ccl.ccl22d+g_ccl.ccl22e
                    +g_ccl.ccl22f+g_ccl.ccl22g+g_ccl.ccl22h    #No.FUN-7C0034
    DISPLAY BY NAME g_ccl.ccl22
END FUNCTION
 
FUNCTION t401_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ccl.* TO NULL              #No.FUN-6A0019
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t401_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t401_count
    FETCH t401_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t401_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t401_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_ccl.* TO NULL
    ELSE
        CALL t401_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t401_fetch(p_flccl)
    DEFINE
        p_flccl          LIKE type_file.chr1          #No.FUN-680122CHAR(01)
 
    CASE p_flccl
        WHEN 'N' FETCH NEXT     t401_cs INTO g_ccl.ccl01,g_ccl.ccl02,g_ccl.ccl03,g_ccl.ccl04,g_ccl.ccl06,g_ccl.ccl07
        WHEN 'P' FETCH PREVIOUS t401_cs INTO g_ccl.ccl01,g_ccl.ccl02,g_ccl.ccl03,g_ccl.ccl04,g_ccl.ccl06,g_ccl.ccl07
        WHEN 'F' FETCH FIRST    t401_cs INTO g_ccl.ccl01,g_ccl.ccl02,g_ccl.ccl03,g_ccl.ccl04,g_ccl.ccl06,g_ccl.ccl07
        WHEN 'L' FETCH LAST     t401_cs INTO g_ccl.ccl01,g_ccl.ccl02,g_ccl.ccl03,g_ccl.ccl04,g_ccl.ccl06,g_ccl.ccl07
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
            FETCH ABSOLUTE g_jump t401_cs INTO g_ccl.ccl01,g_ccl.ccl02,g_ccl.ccl03,g_ccl.ccl04,g_ccl.ccl06,g_ccl.ccl07
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccl.ccl01,SQLCA.sqlcode,0)
        INITIALIZE g_ccl.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flccl
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ccl.* FROM ccl_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ccl01 = g_ccl.ccl01 AND ccl02 = g_ccl.ccl02 AND ccl03 = g_ccl.ccl03 AND ccl04 = g_ccl.ccl04 AND ccl06 = g_ccl.ccl06 AND ccl07 = g_ccl.ccl07
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ccl_file",g_ccl.ccl01,g_ccl.ccl02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE                                     #FUN-4C0061權限控管
       LET g_data_owner = g_ccl.ccluser
       LET g_data_group = g_ccl.cclgrup
      #LET g_data_plant = g_ccl.cclplant #FUN-980030    #FUN-A50075
       LET g_data_plant = g_plant #FUN-A50075
       CALL t401_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t401_show()
    LET g_ccl_t.* = g_ccl.*
    DISPLAY BY NAME g_ccl.ccloriu,g_ccl.cclorig,
        g_ccl.ccl00,   #FUN-610080
        g_ccl.ccl01,g_ccl.ccl02,g_ccl.ccl03,g_ccl.ccl04,g_ccl.ccl05,g_ccl.ccl21,
        g_ccl.ccl22a, g_ccl.ccl22b, g_ccl.ccl22c, g_ccl.ccl22d, g_ccl.ccl22e,
        g_ccl.ccl06, g_ccl.ccl07, g_ccl.ccl22f, g_ccl.ccl22g, g_ccl.ccl22h,           #No.FUN-7C0101 
        g_ccl.ccl22, 
        g_ccl.ccluser,g_ccl.cclgrup,g_ccl.cclmodu,g_ccl.ccldate, 
        g_ccl.cclud01,g_ccl.cclud02,g_ccl.cclud03,g_ccl.cclud04,
        g_ccl.cclud05,g_ccl.cclud06,g_ccl.cclud07,g_ccl.cclud08,
        g_ccl.cclud09,g_ccl.cclud10,g_ccl.cclud11,g_ccl.cclud12,
        g_ccl.cclud13,g_ccl.cclud14,g_ccl.cclud15
 
    INITIALIZE g_sfb.* TO NULL
    INITIALIZE g_ima.* TO NULL
 
    IF g_ccl.ccl00 = '1' THEN   #FUN-610080
       SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=g_ccl.ccl01
       SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_sfb.sfb05
    ELSE
       SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccl.ccl01
    END IF
    DISPLAY BY NAME g_sfb.sfb05,g_ima.ima25,g_ima.ima02
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t401_u()
    IF g_ccl.ccl01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

    #20131209 add by suncx sta-------
    IF NOT t401_chk(g_ccl.ccl02,g_ccl.ccl03) THEN
       CALL cl_err('','axc-809',1)
       RETURN
    END IF
    #20131209 add by suncx end-------

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ccl01_t = g_ccl.ccl01
    LET g_ccl02_t = g_ccl.ccl02
    LET g_ccl03_t = g_ccl.ccl03
    LET g_ccl04_t = g_ccl.ccl04
    LET g_ccl06_t = g_ccl.ccl06              #No.FUN-7C0101 
    LET g_ccl07_t = g_ccl.ccl07              #No.FUN-7C0101 
    BEGIN WORK
 
    OPEN t401_cl USING g_ccl.ccl01,g_ccl.ccl02,g_ccl.ccl03,g_ccl.ccl04,g_ccl.ccl06,g_ccl.ccl07
    IF STATUS THEN
       CALL cl_err("OPEN t401_cl:", STATUS, 1)
       CLOSE t401_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t401_cl INTO g_ccl.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
     IF cl_null(g_ccl.cclacti) THEN LET g_ccl.cclacti ='Y' END IF 
     IF cl_null(g_ccl.ccluser) THEN LET g_ccl.ccluser = g_user END IF 
     IF cl_null(g_ccl.cclgrup) THEN LET g_ccl.cclgrup = g_grup END IF  
        LET g_ccl.cclmodu=g_user                     #修改者
        LET g_ccl.ccldate = g_today                  #修改日期
    CALL t401_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t401_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ccl.*=g_ccl_t.*
            CALL t401_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ccl.ccl04 IS NULL THEN LET g_ccl.ccl04 = ' ' END IF
        UPDATE ccl_file SET ccl_file.* = g_ccl.*    # 更新DB
            WHERE ccl01 = g_ccl_t.ccl01 AND ccl02 = g_ccl_t.ccl02 AND ccl03 = g_ccl_t.ccl03 AND ccl04 = g_ccl_t.ccl04 AND ccl06 = g_ccl_t.ccl06 AND ccl07 = g_ccl_t.ccl07            # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ccl_file",g_ccl01_t,g_ccl02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t401_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t401_r()
    IF g_ccl.ccl01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    #20131209 add by suncx sta-------
    IF NOT t401_chk(g_ccl.ccl02,g_ccl.ccl03) THEN
       CALL cl_err('','axc-809',1)
       RETURN
    END IF
    #20131209 add by suncx end-------
    BEGIN WORK
 
    OPEN t401_cl USING g_ccl.ccl01,g_ccl.ccl02,g_ccl.ccl03,g_ccl.ccl04,g_ccl.ccl06,g_ccl.ccl07
    IF STATUS THEN
       CALL cl_err("OPEN t401_cl:", STATUS, 1)
       CLOSE t401_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t401_cl INTO g_ccl.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccl.ccl01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t401_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ccl01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ccl.ccl01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ccl_file
                WHERE ccl01 = g_ccl.ccl01 AND ccl02 = g_ccl.ccl02
                  AND ccl03 = g_ccl.ccl03 AND ccl04 = g_ccl.ccl04
                  AND ccl06 = g_ccl.ccl06 AND ccl07 = g_ccl.ccl07     #No.FUN-7C0101 
       CLEAR FORM
         OPEN t401_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t401_cs
            CLOSE t401_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t401_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t401_cs
            CLOSE t401_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t401_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t401_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t401_fetch('/')
         END IF
    END IF
    CLOSE t401_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t401_copy()    #複製
DEFINE l_n       LIKE type_file.num5,          #No.FUN-680122 SMALLINT
       l_ccl     RECORD LIKE ccl_file.*,
       l_newno1  LIKE ccl_file.ccl01,
       l_newno2  LIKE ccl_file.ccl02,
       l_newno3  LIKE ccl_file.ccl03,
       l_newno6  LIKE ccl_file.ccl06,          #No.FUN-7C0101 
       l_newno7  LIKE ccl_file.ccl07,          #No.FUN-7C0101 
       l_newno4  LIKE ccl_file.ccl04
 
  IF s_shut(0) THEN RETURN END IF
  IF g_ccl.ccl01 IS NULL OR g_ccl.ccl02 IS NULL OR
     g_ccl.ccl06 IS NULL OR g_ccl.ccl07 IS NULL OR           #No.FUN-7C0101 
     g_ccl.ccl03 IS NULL OR g_ccl.ccl04 IS NULL THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
 
  LET g_before_input_done = FALSE
  CALL t401_set_entry('a')
  CALL t401_set_no_entry('a')
  LET g_before_input_done = TRUE
  INPUT l_newno1,l_newno2,l_newno3,l_newno4,l_newno6,l_newno7 FROM ccl01,ccl02,ccl03,ccl04,ccl06,ccl07 #No.FUN-7C0101
     BEFORE INPUT
        IF g_ccl.ccl00 = "1" THEN
           CALL cl_set_docno_format("ccl01")
        END IF
 
     AFTER FIELD ccl01
        IF cl_null(l_newno1) THEN
           NEXT FIELD ccl01
        ELSE
           IF g_ccl.ccl00 = "2" THEN
             #FUN-AA0059 ---------------------add start---------------------
              IF NOT s_chk_item_no(l_newno1,'') THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD ccl01
              END IF 
            #FUN-AA0059 -----------------------add end---------------------                           
              SELECT * INTO g_ima.* FROM ima_file WHERE ima01=l_newno1
              IF STATUS THEN
                 CALL cl_err3("sel","ima_file",l_newno1,"",STATUS,"","sel ima:",1)  #No.FUN-660127
                 NEXT FIELD ccl01 
              END IF
              DISPLAY g_ima.ima02,g_ima.ima25 TO ima02,ima25
           END IF
        END IF
 
     AFTER FIELD ccl02
        IF cl_null(l_newno2) THEN
           NEXT FIELD ccl02
        END IF
 
     AFTER FIELD ccl03
        IF cl_null(l_newno3) THEN
           NEXT FIELD ccl03
        END IF
 
     AFTER FIELD ccl04
        IF cl_null(l_newno4) THEN
           NEXT FIELD ccl04
        END IF
 
      AFTER FIELD ccl06                                                                                                              
        IF cl_null(l_newno6) OR l_newno6 NOT MATCHES '[12345]' THEN                                                                                                   
           NEXT FIELD ccl06
        END IF   
        IF l_newno6 IS NOT NULL THEN
           IF l_newno6 MATCHES'[12]' THEN
              CALL cl_set_comp_entry("ccl07",FALSE)
              LET l_newno7 = ' '
           ELSE 
              CALL cl_set_comp_entry("ccl07",TRUE)
           END IF
        END IF
 
     AFTER FIELD ccl07                                                                                                              
        IF cl_null(l_newno7) THEN                                                                                                   
           LET l_newno7 = " "       
        ELSE
           IF g_ccl.ccl06='4'THEN                                                                                                  
              SELECT pja01 FROM pja_file WHERE pja01=g_ccl.ccl07                                                       
                                           AND pjaclose='N'     #FUN-960038
              IF STATUS THEN                                                                                                        
                  CALL cl_err3("sel","pja_file",g_ccl.ccl07,"",STATUS,"","sel pja:",1)                                              
                  NEXT FIELD ccl07                                                                                                  
               END IF                                                                                                               
           END IF                                                                                                                  
           IF g_ccl.ccl06='5'THEN                                                                                                  
              SELECT gem01 FROM gem_file WHERE gem01=g_ccl.ccl07                                                       
              IF STATUS THEN                                                                                                        
                  CALL cl_err3("sel","gem_file",g_ccl.ccl07,"",STATUS,"","sel gem:",1)                                              
                  NEXT FIELD ccl07                                                                                                  
              END IF                                                                                                                
           END IF                                                                                                                  
        END IF                                                                                                                    
 
     AFTER INPUT
        LET g_cnt = 0
        SELECT count(*) INTO g_cnt FROM ccl_file
         WHERE ccl01 = l_newno1 AND ccl02 = l_newno2
           AND ccl03 = l_newno3 AND ccl04 = l_newno4
           AND ccl06 = l_newno6 AND ccl07 = l_newno7     #No.FUN-7C0101 
        IF g_cnt > 0 THEN
           CALL cl_err(l_newno1,-239,0)
           NEXT FIELD ccl01
        END IF
        LET g_cnt = 0
        #20131209 add by suncx sta-------
        IF NOT t401_chk(l_newno2,l_newno3) THEN
           CALL cl_err('','axc-809',1)
           NEXT FIELD ccl02
        END IF
        #20131209 add by suncx end-------
 
     ON ACTION CONTROLP
       CASE
          WHEN INFIELD(ccl01)   #元件料號
#FUN-AA0059---------mod------------str-----------------
#            CALL cl_init_qry_var()
               
             IF g_argv1 = '2' THEN
#               LET g_qryparam.form = "q_ima"
                CALL q_sel_ima(FALSE, "q_ima","","","","","","","",'' ) 
                  RETURNING l_newno1  
             ELSE 
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb05"
                CALL cl_create_qry() RETURNING l_newno1
             END IF 
 
#            CALL cl_create_qry() RETURNING l_newno1
#FUN-AA0059---------mod------------end-----------------
             DISPLAY l_newno1 TO ccl01
             NEXT FIELD ccl01
             WHEN INFIELD(ccl07)                                                                                                    
                CALL cl_init_qry_var()                                                                                              
                IF g_ccl.ccl06 = '4' THEN                                                                                           
                   LET g_qryparam.form = "q_pja"                                                                                    
                END IF                                                                                                              
                IF g_ccl.ccl06 = '5' THEN                                                                                           
                   LET g_qryparam.form = "q_gem4"                                                                                   
                END IF                                                                                                              
                LET g_qryparam.default1 = g_ccl.ccl07                                                                               
                CALL cl_create_qry() RETURNING g_ccl.ccl07                                                                          
                DISPLAY BY NAME g_ccl.ccl07                                                                                         
                NEXT FIELD ccl07                                                                                                    
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
      DISPLAY BY NAME g_ccl.ccl01,g_ccl.ccl02,g_ccl.ccl03,g_ccl.ccl04
                      ,g_ccl.ccl06,g_ccl.ccl07                  #No.FUN-7C0101 
      RETURN
  END IF
 
  LET l_ccl.* = g_ccl.*
  CASE g_argv1
     WHEN "1" LET l_ccl.ccl00 = '1'
     WHEN "2" LET l_ccl.ccl00 = '2'
  END CASE
  LET l_ccl.ccl01 = l_newno1
  LET l_ccl.ccl02 = l_newno2
  LET l_ccl.ccl03 = l_newno3
  LET l_ccl.ccl04 = l_newno4
  LET l_ccl.ccl06 = l_newno6    #No.FUN-7C0101 
  LET l_ccl.ccl07 = l_newno7    #No.FUN-7C0101 
  LET l_ccl.ccluser = g_user    #資料所有者
  LET l_ccl.cclgrup = g_grup    #資料所有者所屬群
  LET l_ccl.cclmodu = NULL      #資料修改日期
  LET l_ccl.ccldate = g_today   #資料建立日期
  LET l_ccl.cclacti = 'Y'       #有效資料
 #LET l_ccl.cclplant= g_plant  #FUN-980009 add    #FUN-A50075
  LET l_ccl.ccllegal= g_legal  #FUN-980009 add
  IF cl_null(l_ccl.ccl05)  THEN LET l_ccl.ccl05 =' ' END IF
  IF cl_null(l_ccl.ccl22)  THEN LET l_ccl.ccl22 = 0  END IF
  IF cl_null(l_ccl.ccl22a) THEN LET l_ccl.ccl22a= 0  END IF
  IF cl_null(l_ccl.ccl22b) THEN LET l_ccl.ccl22b= 0  END IF
  IF cl_null(l_ccl.ccl22c) THEN LET l_ccl.ccl22c= 0  END IF
  IF cl_null(l_ccl.ccl22d) THEN LET l_ccl.ccl22d= 0  END IF
  IF cl_null(l_ccl.ccl22e) THEN LET l_ccl.ccl22e= 0  END IF
 
  LET l_ccl.ccloriu = g_user      #No.FUN-980030 10/01/04
  LET l_ccl.cclorig = g_grup      #No.FUN-980030 10/01/04
  INSERT INTO ccl_file VALUES (l_ccl.*)
  IF SQLCA.sqlcode THEN
     CALL cl_err3("ins","ccl_file",l_ccl.ccl01,l_ccl.ccl02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
  ELSE
      MESSAGE 'ROW(',l_newno1,') O.K'
  END IF
  #FUN-C80046---begin
  #SELECT * INTO g_ccl.* FROM ccl_file
  # WHERE ccl01 = g_ccl.ccl01 AND ccl02 = g_ccl.ccl02
  #   AND ccl03 = g_ccl.ccl03 AND ccl04 = g_ccl.ccl04
  #   AND ccl06 = g_ccl.ccl06 AND ccl07 = g_ccl.ccl07  #No.FUN-7C0101
  SELECT * INTO g_ccl.* FROM ccl_file
   WHERE ccl01 = l_newno1 AND ccl02 = l_newno2
     AND ccl03 = l_newno3 AND ccl04 = l_newno4
     AND ccl06 = l_newno6 AND ccl07 = l_newno7
  #FUN-C80046---end
  CALL t401_show()
 
END FUNCTION
FUNCTION t401_out()
 
    DEFINE l_cmd  LIKE type_file.chr1000
    IF cl_null(g_wc) AND NOT cl_null(g_ccl.ccl01) AND NOT cl_null(g_ccl.ccl02)  
       AND NOT cl_null(g_ccl.ccl03) AND NOT cl_null(g_ccl.ccl04) THEN           
       LET g_wc = " ccl01 = '",g_ccl.ccl01,"' AND ccl02 = '",g_ccl.ccl02,       
                  "' AND ccl03 = '",g_ccl.ccl03,"' AND ccl04 = '",g_ccl.ccl04,"'"
    END IF                                                                      
    IF g_wc IS NULL THEN                                                        
       CALL cl_err('','9057',0)                                                 
       RETURN                                                                   
    END IF                                                                      
    LET l_cmd = 'p_query "axct401" "',g_wc CLIPPED,'"'                   
    CALL cl_cmdrun(l_cmd)                                                
    RETURN 
 
 
END FUNCTION
FUNCTION t402_out()
    DEFINE l_cmd  LIKE type_file.chr1000                                                                                            
    IF cl_null(g_wc) AND NOT cl_null(g_ccl.ccl01) AND NOT cl_null(g_ccl.ccl02)                                                      
       AND NOT cl_null(g_ccl.ccl03) AND NOT cl_null(g_ccl.ccl04) THEN                                                               
       LET g_wc = " ccl01 = '",g_ccl.ccl01,"' AND ccl02 = '",g_ccl.ccl02,                                                           
                  "' AND ccl03 = '",g_ccl.ccl03,"' AND ccl04 = '",g_ccl.ccl04,"'"                                                   
    END IF                                                                                                                          
    IF g_wc IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_cmd = 'p_query "axct402" "',g_wc CLIPPED,'"'                                                                       
    CALL cl_cmdrun(l_cmd)                                                                                                    
 
END FUNCTION
 
 
FUNCTION t401_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ccl01,ccl02,ccl03,ccl04,ccl06,ccl07",TRUE)     #No.FUN-7C0101  
  END IF
END FUNCTION
 
FUNCTION t401_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ccl01,ccl02,ccl03,ccl04,ccl06,ccl07",FALSE)    #No.FUN-7C0101
  END IF
  IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND
     (NOT g_before_input_done) THEN
     IF g_ccl.ccl06 MATCHES'[12]' THEN
        CALL cl_set_comp_entry("ccl07",FALSE)
     ELSE
        CALL cl_set_comp_entry("ccl07",TRUE)
     END IF
  END IF
END FUNCTION
 
FUNCTION t401_change()
 DEFINE        lwin_curr     ui.window,                                                                               
               lnode_win     om.DomNode,                                                                          
               lnode_child   om.DomNode,                                                                        
               lnode_pre     om.DomNode,                                                                         
               ls_item_pre_tag STRING           
 
      CALL cl_getmsg('mfg1015',g_lang) RETURNING g_msg                                                                              
      LET lwin_curr = ui.Window.getCurrent()                                                                                        
      LET lnode_win = lwin_curr.findNode("FormField","ccl_file.ccl01")                                                              
      LET lnode_child = lnode_win.getFirstChild()                                                                                   
      CALL lnode_child.setAttribute("comment",g_msg CLIPPED)                                                                        
      WHILE TRUE                                                                                                                    
        LET lnode_pre = lnode_win.getPrevious()                                                                                     
        LET ls_item_pre_tag = lnode_pre.getTagName()                                                                                
        IF ls_item_pre_tag.equals("Label") THEN                                                                                     
           CALL lnode_pre.setAttribute("text",g_msg CLIPPED)                                                                        
           EXIT WHILE                                                                                                               
        ELSE                                                                                                                        
           LET lnode_win = lnode_pre                                                                                                
        END IF                                                                                                                      
      END WHILE                                                                                                                     
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/13


#20131209 add by suncx begin--------------------------------
FUNCTION t401_chk(p_yy,p_mm)
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
