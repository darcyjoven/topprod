# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axct610.4gl
# Descriptions...: 每月工單元件在製成本維護作業
# Date & Author..: 98/08/27 By Star
# Modify.........: No.FUN-4C0005 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No:-MOD-4B0209 04/12/03 By pengu 將原本列印月初結存數、金額、單價，改成月底結存數、金額、單價。
# Modify.........: No.FUN-4C0099 05/01/11 By kim 報表轉XML功能
# Modify.........: No.MOD-530850 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-5C0002 05/12/05 By Sarah (接下頁),(結束)的列印位置調整
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0019 06/10/27 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0101 08/01/07 By shiwuying 成本改善增加ccu06(成本計算類別),ccu07(類別編號)和各種制費
# Modify.........: No.FUN-840019 06/04/28 By lutingting報表轉為使用CR
# Modify.........: No.FUN-840202 08/05/07 By TSD.liquor 自定欄位功能修改
# Modify.........: No.MOD-920112 09/02/07 By Pengu 下階元件資料會無法查詢出來顯示
# Modify.........: No.MOD-970158 09/07/21 By mike 修改show()中l_ima02與l_ima25的資料型態
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-980066 09/08/25 By mike 用單頭的工單號碼與元件編號去select sfa的相關欄位display到畫面上對應的欄位         
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.TQC-970003 09/12/01 By jan 批次成本修改
# Modify.........: No.FUN-9C0073 10/01/13 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70136 10/07/29 By destiny 平行工艺
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1 LIKE type_file.chr20,                 #No.FUN-680122CHAR(16)
    g_argv2 LIKE type_file.num5,                  #No.FUN-680122SMALLINT
    g_argv3 LIKE type_file.num5,                  #No.FUN-680122SMALLINT
    g_argv4 LIKE ccu_file.ccu06,                  #No.FUN-7C0101 add
    g_argv5 LIKE ccu_file.ccu07,                  #No.FUN-7C0101 add
    g_sfb38 LIKE sfb_file.sfb38,
    g_sfb08 LIKE sfb_file.sfb08,
    g_ccu   RECORD LIKE ccu_file.*,
    g_ccu_t RECORD LIKE ccu_file.*,
    g_ccu01_t LIKE ccu_file.ccu01,
    g_ccu02_t LIKE ccu_file.ccu02,
    g_ccu03_t LIKE ccu_file.ccu03,
    g_ccu04_t LIKE ccu_file.ccu04,
    g_ccu06_t LIKE ccu_file.ccu06,                #No.FUN-7C0101 add
    g_ccu07_t LIKE ccu_file.ccu07,                #No.FUN-7C0101 add
    g_wc,g_sql          string,                   #No.FUN-580092 HCN
    g_ima   RECORD LIKE ima_file.*,
    g_cct   RECORD LIKE cct_file.*
 
DEFINE   g_forupd_sql STRING                      #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03        #No.FUN-680122CHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5  #No.FUN-680122 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10      #No.FUN-680122 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE   l_table        STRING     #No.FUN-840019
DEFINE   l_sql          STRING     #No.FUN-840019
DEFINE   g_str          STRING     #No.FUN-840019
 
MAIN
DEFINE   p_row,p_col     LIKE type_file.num5      #No.FUN-680122 SMALLINT
 
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
 
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)    #No.FUN-7C0101 add
    LET g_argv5 = ARG_VAL(5)    #No.FUN-7C0101 add
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
    LET l_sql = "l_ccu04.ccu_file.ccu04,", 
                "l_ima02.ima_file.ima02,", 
                "l_ima021.ima_file.ima21,", 
                "ima25.ima_file.ima25,",
                "l_ccu02.ccu_file.ccu02,",
                "l_ccu03.ccu_file.ccu03,",
                "l_ccu91.ccu_file.ccu91,", 
                "l_ccu92.ccu_file.ccu92,", 
                "l_avg.ccu_file.ccu12,",
                "ccu01.ccu_file.ccu01"  
    LET l_table = cl_prt_temptable('axct610',l_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    
    LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM l_sql
    IF STATUS THEN 
       CALL cl_err('insert prep:',STATUS,1) EXIT PROGRAM
    END IF
 
    INITIALIZE g_ccu.* TO NULL
    INITIALIZE g_ccu_t.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM ccu_file WHERE ccu01 = ? AND ccu02 = ? AND ccu03 = ? AND ccu04 = ? AND ccu06 = ? AND ccu07 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t610_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW t610_w AT p_row,p_col WITH FORM "axc/42f/axct610" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    IF NOT cl_null(g_argv1) THEN CALL t610_q() END IF
 
      LET g_action_choice=""
      CALL t610_menu()
 
    CLOSE WINDOW t610_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t610_cs()
DEFINE l_ccu06 LIKE ccu_file.ccu06 #NO.FUN-7C0101
    CLEAR FORM
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " ccu01='", g_argv1, "' AND ",
                  " ccu02=", g_argv2, " AND ccu03=", g_argv3
                 ," AND ccu06='",g_argv4,"'"
    ELSE
   INITIALIZE g_ccu.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          cct04, ccu01, ccu02, ccu03,ccu06,ccu07,   #No.FUN-7C0101 add ccu06,ccu07 
          cct12, cct22, cct32, cct42, cct92,
          ccu04, ccu05,
          ccu11, ccu12a, ccu12b, ccu12c, ccu12d, ccu12e, ccu12f, ccu12g, ccu12h, ccu12, #No.FUN-7C0101
          ccu21, ccu22a, ccu22b, ccu22c, ccu22d, ccu22e, ccu22f, ccu22g, ccu22h, ccu22, #No.FUN-7C0101
          ccu31, ccu32a, ccu32b, ccu32c, ccu32d, ccu32e, ccu32f, ccu32g, ccu32h, ccu32, #No.FUN-7C0101
          ccu41, ccu42a, ccu42b, ccu42c, ccu42d, ccu42e, ccu42f, ccu42g, ccu42h, ccu42, #No.FUN-7C0101
          ccu91, ccu92a, ccu92b, ccu92c, ccu92d, ccu92e, ccu92f, ccu92g, ccu92h, ccu92, #No.FUN-7C0101
          ccuud01,ccuud02,ccuud03,ccuud04,ccuud05,
          ccuud06,ccuud07,ccuud08,ccuud09,ccuud10,
          ccuud11,ccuud12,ccuud13,ccuud14,ccuud15
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
        AFTER FIELD ccu06
              LET l_ccu06 = get_fldbuf(ccu06)
     ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(cct04)                                                   
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form = "q_bma2"                                       
            LET g_qryparam.state = "c"                                          
            LET g_qryparam.default1 = g_cct.cct04                               
            CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            DISPLAY g_qryparam.multiret TO cct04                                
            NEXT FIELD cct04                                                    
          WHEN INFIELD(ccu04)                                                   
            CALL cl_init_qry_var()                                              
            LET g_qryparam.form = "q_bmb203"                                       
            LET g_qryparam.state = "c"                                          
            LET g_qryparam.default1 = g_ccu.ccu04                               
            CALL cl_create_qry() RETURNING g_qryparam.multiret                  
            DISPLAY g_qryparam.multiret TO ccu04                                
            NEXT FIELD ccu04
              WHEN INFIELD(ccu07)                                               
                 IF l_ccu06 MATCHES '[45]' THEN                             
                    CALL cl_init_qry_var()       
                    LET g_qryparam.state= "c"                                
                 CASE l_ccu06                                               
                    WHEN '4'                                                    
                      LET g_qryparam.form = "q_pja"                             
                    WHEN '5'                                                    
                      LET g_qryparam.form = "q_gem4"                            
                    OTHERWISE EXIT CASE                                         
                 END CASE                                                       
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                     
                 DISPLAY  g_qryparam.multiret TO ccu07                                   
                 NEXT FIELD ccu07                                               
                 END IF                                                         
         OTHERWISE                                                              
            EXIT CASE                                                           
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cctuser', 'cctgrup') #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
    LET g_sql="SELECT cct04,ccu01,ccu02,ccu03,ccu04,ccu06,ccu07",#No.FUN-7C0101
              "  FROM ccu_file,cct_file ",
              " WHERE ",g_wc CLIPPED,
              "   AND ccu01=cct01 AND ccu02=cct02 AND ccu03=cct03",
              "   AND ccu06=cct06 ",
              " ORDER BY cct04,ccu01,ccu02,ccu03,ccu04,ccu06,ccu07"  #No.FUN-7C0101
    PREPARE t610_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t610_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t610_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ccu_file,cct_file WHERE ",g_wc CLIPPED,
        "   AND ccu01=cct01 AND ccu02=cct02 AND ccu03=cct03",
        "   AND ccu06=cct06 "
    PREPARE t610_precount FROM g_sql
    DECLARE t610_count CURSOR FOR t610_precount
END FUNCTION
 
FUNCTION t610_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t610_q() 
            END IF
        ON ACTION next 
            CALL t610_fetch('N') 
        ON ACTION previous 
            CALL t610_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t610_u() 
            END IF 
       ON ACTION output 
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL t610_out()
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
            CALL t610_fetch('/')
        ON ACTION first
            CALL t610_fetch('F')
        ON ACTION last
            CALL t610_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_ccu.ccu01 IS NOT NULL THEN
                  LET g_doc.column1 = "ccu01"
                  LET g_doc.value1 = g_ccu.ccu01
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
 
    END MENU
    CLOSE t610_cs
END FUNCTION
 
 
FUNCTION g_ccu_zero()
	LET g_ccu.ccu11=0
	LET g_ccu.ccu12=0
	LET g_ccu.ccu12a=0
	LET g_ccu.ccu12b=0
	LET g_ccu.ccu12c=0
	LET g_ccu.ccu12d=0
	LET g_ccu.ccu12e=0
        LET g_ccu.ccu12f=0  #No.FUN-7C0101
        LET g_ccu.ccu12g=0  #No.FUN-7C0101
        LET g_ccu.ccu12h=0  #No.FUN-7C0101
	LET g_ccu.ccu21=0
	LET g_ccu.ccu22=0
	LET g_ccu.ccu22a=0
	LET g_ccu.ccu22b=0
	LET g_ccu.ccu22c=0
	LET g_ccu.ccu22d=0
	LET g_ccu.ccu22e=0
        LET g_ccu.ccu22f=0  #No.FUN-7C0101
        LET g_ccu.ccu22g=0  #No.FUN-7C0101
        LET g_ccu.ccu22h=0  #No.FUN-7C0101
	LET g_ccu.ccu31=0
	LET g_ccu.ccu32=0
	LET g_ccu.ccu32a=0
	LET g_ccu.ccu32b=0
	LET g_ccu.ccu32c=0
	LET g_ccu.ccu32d=0
	LET g_ccu.ccu32e=0
        LET g_ccu.ccu32f=0  #No.FUN-7C0101
        LET g_ccu.ccu32g=0  #No.FUN-7C0101
        LET g_ccu.ccu32h=0  #No.FUN-7C0101
	LET g_ccu.ccu41=0
	LET g_ccu.ccu42=0
	LET g_ccu.ccu42a=0
	LET g_ccu.ccu42b=0
	LET g_ccu.ccu42c=0
	LET g_ccu.ccu42d=0
	LET g_ccu.ccu42e=0
        LET g_ccu.ccu42f=0  #No.FUN-7C0101
        LET g_ccu.ccu42g=0  #No.FUN-7C0101
        LET g_ccu.ccu42h=0  #No.FUN-7C0101
	LET g_ccu.ccu91=0
	LET g_ccu.ccu92=0
	LET g_ccu.ccu92a=0
	LET g_ccu.ccu92b=0
	LET g_ccu.ccu92c=0
	LET g_ccu.ccu92d=0
	LET g_ccu.ccu92e=0
        LET g_ccu.ccu92f=0  #No.FUN-7C0101
        LET g_ccu.ccu92g=0  #No.FUN-7C0101
        LET g_ccu.ccu92h=0  #No.FUN-7C0101
END FUNCTION
 
FUNCTION t610_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,      #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,      #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5,      #No.FUN-680122 SMALLINT
        l_pja01         LIKE pja_file.pja01,      #No.FUN-7C0101 add
        l_gem01         LIKE gem_file.gem01       #No.FUN-7C0101 add
    
    INPUT BY NAME
        g_ccu.ccu01, g_ccu.ccu02, g_ccu.ccu03,  g_ccu.ccu04, g_ccu.ccu05,
        g_ccu.ccu06, g_ccu.ccu07,                 #No.FUN-7C0101 add ccu06,ccu07
        g_ccu.ccu11, g_ccu.ccu12a, g_ccu.ccu12b, g_ccu.ccu12c,
        g_ccu.ccu12d, g_ccu.ccu12e, g_ccu.ccu12f, g_ccu.ccu12g, g_ccu.ccu12h,g_ccu.ccu12,#No.FUN-7C0101
        g_ccu.ccu21, g_ccu.ccu22a, g_ccu.ccu22b, g_ccu.ccu22c,
        g_ccu.ccu22d, g_ccu.ccu22e, g_ccu.ccu22f, g_ccu.ccu22g, g_ccu.ccu22h,g_ccu.ccu22,#No.FUN-7C0101
        g_ccu.ccu31, g_ccu.ccu32a, g_ccu.ccu32b, g_ccu.ccu32c,
        g_ccu.ccu32d, g_ccu.ccu32e, g_ccu.ccu32f, g_ccu.ccu32g, g_ccu.ccu32h,g_ccu.ccu32,#No.FUN-7C0101
        g_ccu.ccu41, g_ccu.ccu42a, g_ccu.ccu42b, g_ccu.ccu42c,
        g_ccu.ccu42d, g_ccu.ccu42e, g_ccu.ccu42f, g_ccu.ccu42g, g_ccu.ccu42h,g_ccu.ccu42,#No.FUN-7C0101
        g_ccu.ccu91, g_ccu.ccu92a, g_ccu.ccu92b, g_ccu.ccu92c,
        g_ccu.ccu92d, g_ccu.ccu92e, g_ccu.ccu92f, g_ccu.ccu92g, g_ccu.ccu92h,g_ccu.ccu92,#No.FUN-7C0101
        g_ccu.ccuud01,g_ccu.ccuud02,g_ccu.ccuud03,g_ccu.ccuud04,
        g_ccu.ccuud05,g_ccu.ccuud06,g_ccu.ccuud07,g_ccu.ccuud08,
        g_ccu.ccuud09,g_ccu.ccuud10,g_ccu.ccuud11,g_ccu.ccuud12,
        g_ccu.ccuud13,g_ccu.ccuud14,g_ccu.ccuud15 
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t610_set_entry(p_cmd)
          CALL t610_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("ccu01")
 
        AFTER FIELD ccu01
          IF g_ccu.ccu01 IS NOT NULL THEN 
            SELECT * INTO g_cct.* FROM cct_file
             WHERE cct01=g_ccu.ccu01 AND cct02=g_ccu.ccu02 AND cct03=g_ccu.ccu03
            IF STATUS THEN
               CALL cl_err3("sel","cct_file",g_ccu.ccu01,g_ccu.ccu02,STATUS,"","sel cct:",1)  #No.FUN-660127
               NEXT FIELD ccu01
            END IF
            DISPLAY BY NAME g_cct.cct04
            INITIALIZE g_ima.* TO NULL
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_cct.cct04
            DISPLAY BY NAME g_ima.ima02,g_ima.ima25
            SELECT sfb38 INTO g_sfb38 FROM sfb_file
             WHERE sfb01=g_ccu.ccu01
            DISPLAY g_sfb38 TO sfb38
          END IF
 
        AFTER FIELD ccu03
          IF g_ccu.ccu03 IS NOT NULL THEN 
            SELECT cct01 FROM cct_file
                    WHERE cct01 = g_ccu.ccu01 AND cct02 = g_ccu.ccu02
                      AND cct03 = g_ccu.ccu03
            IF STATUS THEN
               CALL cl_err3("sel","cct_file",g_ccu.ccu01,g_ccu.ccu02,STATUS,"","sel cct:",1)  #No.FUN-660127
               NEXT FIELD ccu03
            END IF
          END IF
        AFTER FIELD ccu04
          IF g_ccu.ccu04 IS NOT NULL THEN 
           #FUN-AA0059 --------------------add start---------------------
            IF NOT s_chk_item_no(g_ccu.ccu04,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD ccu04
            END IF 
           #FUN-AA0059 ---------------------add end--------------------- 
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND 
               (g_ccu.ccu01 != g_ccu01_t OR g_ccu.ccu01 != g_ccu01_t OR
                g_ccu.ccu03 != g_ccu03_t OR g_ccu.ccu04 != g_ccu04_t OR
                g_ccu.ccu06 != g_ccu06_t OR g_ccu.ccu07 != g_ccu07_t)) THEN #No.FUN-7C0101
                SELECT count(*) INTO l_n FROM ccu_file
                    WHERE ccu01 = g_ccu.ccu01 AND ccu02 = g_ccu.ccu02
                      AND ccu03 = g_ccu.ccu03 AND ccu04 = g_ccu.ccu04
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD ccu01
                END IF
            END IF
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccu.ccu04
            IF STATUS THEN
               CALL cl_err3("sel","ima_file",g_ccu.ccu04,"",STATUS,"","sel cct:",1)  #No.FUN-660127
               NEXT FIELD ccu04
            END IF
            DISPLAY g_ima.ima02,g_ima.ima25 TO ima02b,ima25b
            LET g_ccu.ccu05 = g_ima.ima08
            DISPLAY BY NAME g_ccu.ccu05
          END IF
          CALL t610_ccu04() #CHI-980066   
        AFTER FIELD ccu05
            IF g_ccu.ccu05 NOT MATCHES '[RPM]' THEN NEXT FIELD ccu05 END IF
 
        AFTER FIELD ccu06
          IF g_ccu.ccu06 IS NOT NULL THEN
            IF g_ccu.ccu06 NOT MATCHES '[12345]' THEN
               NEXT FIELD ccu06
            END IF
          END IF
          
        AFTER FIELD ccu07
            IF NOT cl_null(g_ccu.ccu07) OR g_ccu.ccu07 != ' '  THEN
               IF g_ccu.ccu06='4'THEN
                  SELECT pja01 INTO l_pja01 FROM pja_file WHERE pja01=g_ccu.ccu07
                                                            AND pjaclose='N'             #FUN-960038
                  IF STATUS THEN
                     CALL cl_err3("sel","pja_file",g_ccu.ccu07,"",STATUS,"","sel pja:",1)
                     NEXT FIELD ccu07
                  END IF
               END IF
               IF g_ccu.ccu06='5'THEN
                  SELECT gem01 INTO l_gem01 FROM gem_file WHERE gem01=g_ccu.ccu07
                  IF STATUS THEN
                     CALL cl_err3("sel","gem_file",g_ccu.ccu07,"",STATUS,"","sel gem:",1)
                     NEXT FIELD ccu07
                  END IF
               END IF
            ELSE 
               LET g_ccu.ccu07 = ' '
            END IF
        
        AFTER FIELD #ccu02
        ccu11, ccu12a, ccu12b, ccu12c, ccu12d, ccu12e, ccu12f, ccu12g, ccu12h, ccu12, #No.FUN-7C0101
        ccu21, ccu22a, ccu22b, ccu22c, ccu22d, ccu22e, ccu22f, ccu22g, ccu22h, ccu22, #No.FUN-7C0101
        ccu31, ccu32a, ccu32b, ccu32c, ccu32d, ccu32e, ccu32f, ccu32g, ccu32h, ccu32, #No.FUN-7C0101
        ccu41, ccu42a, ccu42b, ccu42c, ccu42d, ccu42e, ccu42f, ccu42g, ccu42h, ccu42, #No.FUN-7C0101
        ccu91, ccu92a, ccu92b, ccu92c, ccu92d, ccu92e, ccu92f, ccu92g, ccu92h, ccu92  #No.FUN-7C0101
            CALL t610_u_cost()
 
        AFTER FIELD ccuud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ccuud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT  
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ccu01
            END IF
         ON ACTION controlp
           CASE
              WHEN INFIELD(ccu07)
                IF g_ccu.ccu06 MATCHES '[45]' THEN
                 CALL cl_init_qry_var()
                 CASE g_ccu.ccu06
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"                     
                    WHEN '5'
                      LET g_qryparam.form = "q_gem4"
                    OTHERWISE EXIT CASE
                 END CASE
                 LET g_qryparam.default1 = g_ccu.ccu07
                 CALL cl_create_qry() RETURNING g_ccu.ccu07
                 DISPLAY BY NAME g_ccu.ccu07
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
          
        ON KEY(F1) NEXT FIELD ccu11
        ON KEY(F2) NEXT FIELD ccu21
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    
    END INPUT
END FUNCTION
 
FUNCTION t610_u_cost()
    LET g_ccu.ccu91 =g_ccu.ccu11 +g_ccu.ccu21 +g_ccu.ccu31 +g_ccu.ccu41
    LET g_ccu.ccu92 =g_ccu.ccu12 +g_ccu.ccu22 +g_ccu.ccu32 +g_ccu.ccu42
    LET g_ccu.ccu92a=g_ccu.ccu12a+g_ccu.ccu22a+g_ccu.ccu32a+g_ccu.ccu42a
    LET g_ccu.ccu92b=g_ccu.ccu12b+g_ccu.ccu22b+g_ccu.ccu32b+g_ccu.ccu42b
    LET g_ccu.ccu92c=g_ccu.ccu12c+g_ccu.ccu22c+g_ccu.ccu32c+g_ccu.ccu42c
    LET g_ccu.ccu92d=g_ccu.ccu12d+g_ccu.ccu22d+g_ccu.ccu32d+g_ccu.ccu42d
    LET g_ccu.ccu92e=g_ccu.ccu12e+g_ccu.ccu22e+g_ccu.ccu32e+g_ccu.ccu42e
    LET g_ccu.ccu92f=g_ccu.ccu12f+g_ccu.ccu22f+g_ccu.ccu32f+g_ccu.ccu42f  #No.FUN-7C0101
    LET g_ccu.ccu92g=g_ccu.ccu12g+g_ccu.ccu22g+g_ccu.ccu32g+g_ccu.ccu42g  #No.FUN-7C0101
    LET g_ccu.ccu92h=g_ccu.ccu12h+g_ccu.ccu22h+g_ccu.ccu32h+g_ccu.ccu42h  #No.FUN-7C0101
    LET g_ccu.ccu12=g_ccu.ccu12a+g_ccu.ccu12b+g_ccu.ccu12c+g_ccu.ccu12d
                                +g_ccu.ccu12e
                                +g_ccu.ccu12f+g_ccu.ccu12g+g_ccu.ccu12h  #No.FUN-7C0101
    LET g_ccu.ccu22=g_ccu.ccu22a+g_ccu.ccu22b+g_ccu.ccu22c+g_ccu.ccu22d
                                +g_ccu.ccu22e
                                +g_ccu.ccu22f+g_ccu.ccu22g+g_ccu.ccu22h  #No.FUN-7C0101
    LET g_ccu.ccu32=g_ccu.ccu32a+g_ccu.ccu32b+g_ccu.ccu32c+g_ccu.ccu32d
                                +g_ccu.ccu32e
                                +g_ccu.ccu32f+g_ccu.ccu32g+g_ccu.ccu32h  #No.FUN-7C0101
    LET g_ccu.ccu42=g_ccu.ccu42a+g_ccu.ccu42b+g_ccu.ccu42c+g_ccu.ccu42d
                                +g_ccu.ccu42e
                                +g_ccu.ccu42f+g_ccu.ccu42g+g_ccu.ccu42h  #No.FUN-7C0101
    LET g_ccu.ccu92=g_ccu.ccu92a+g_ccu.ccu92b+g_ccu.ccu92c+g_ccu.ccu92d
                                +g_ccu.ccu92e
                                +g_ccu.ccu92f+g_ccu.ccu92g+g_ccu.ccu92h  #No.FUN-7C0101
    CALL t610_show_2()
END FUNCTION
 
FUNCTION t610_b_tot(p_cmd)
 DEFINE p_cmd		LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 DEFINE mcct		RECORD LIKE cct_file.*
 
 SELECT * INTO mcct.* FROM cct_file
       WHERE cct01=g_ccu.ccu01 AND cct02=g_ccu.ccu02 AND cct03=g_ccu.ccu03
         AND cct06=g_ccu.ccu06
 
 SELECT SUM(ccu12),SUM(ccu12a),SUM(ccu12b),SUM(ccu12c),SUM(ccu12d),SUM(ccu12e),SUM(ccu12f),SUM(ccu12g),SUM(ccu12h),#No.FUN-7C0101
        SUM(ccu22),SUM(ccu22a),SUM(ccu22b),SUM(ccu22c),SUM(ccu22d),SUM(ccu22e),SUM(ccu22f),SUM(ccu22g),SUM(ccu22h),#No.FUN-7C0101
        SUM(ccu32),SUM(ccu32a),SUM(ccu32b),SUM(ccu32c),SUM(ccu32d),SUM(ccu32e),SUM(ccu32f),SUM(ccu32g),SUM(ccu32h),#No.FUN-7C0101
        SUM(ccu42),SUM(ccu42a),SUM(ccu42b),SUM(ccu42c),SUM(ccu42d),SUM(ccu42e),SUM(ccu42f),SUM(ccu42g),SUM(ccu42h),#No.FUN-7C0101
        SUM(ccu92),SUM(ccu92a),SUM(ccu92b),SUM(ccu92c),SUM(ccu92d),SUM(ccu92e),SUM(ccu92f),SUM(ccu92g),SUM(ccu92h) #No.FUN-7C0101
   INTO mcct.cct12,mcct.cct12a,mcct.cct12b,mcct.cct12c,mcct.cct12d,mcct.cct12e,mcct.cct12f,mcct.cct12g,mcct.cct12h,#No.FUN-7C0101
        mcct.cct22,mcct.cct22a,mcct.cct22b,mcct.cct22c,mcct.cct22d,mcct.cct22e,mcct.cct22f,mcct.cct22g,mcct.cct22h,#No.FUN-7C0101
        mcct.cct32,mcct.cct32a,mcct.cct32b,mcct.cct32c,mcct.cct32d,mcct.cct32e,mcct.cct32f,mcct.cct32g,mcct.cct32h,#No.FUN-7C0101
        mcct.cct42,mcct.cct42a,mcct.cct42b,mcct.cct42c,mcct.cct42d,mcct.cct42e,mcct.cct42f,mcct.cct42g,mcct.cct42h,#No.FUN-7C0101
        mcct.cct92,mcct.cct92a,mcct.cct92b,mcct.cct92c,mcct.cct92d,mcct.cct92e,mcct.cct92f,mcct.cct92g,mcct.cct92h #No.FUN-7C0101
   FROM ccu_file 
  WHERE ccu01=g_ccu.ccu01 AND ccu02=g_ccu.ccu02 AND ccu03=g_ccu.ccu03
    AND ccu04=g_ccu.ccu04 AND ccu06=g_ccu.ccu06 AND ccu07=g_ccu.ccu07  #No.FUN-7C0101
 IF mcct.cct12 IS NULL THEN 
    LET mcct.cct12 = 0 LET mcct.cct12a= 0 LET mcct.cct12b= 0
    LET mcct.cct12c= 0 LET mcct.cct12d= 0 LET mcct.cct12e= 0
    LET mcct.cct12f= 0 LET mcct.cct12g= 0 LET mcct.cct12h= 0 #No.FUN-7C0101
    LET mcct.cct22 = 0 LET mcct.cct22a= 0 LET mcct.cct22b= 0
    LET mcct.cct22c= 0 LET mcct.cct22d= 0 LET mcct.cct22e= 0
    LET mcct.cct22f= 0 LET mcct.cct22g= 0 LET mcct.cct22h= 0 #No.FUN-7C0101
    LET mcct.cct32 = 0 LET mcct.cct32a= 0 LET mcct.cct32b= 0
    LET mcct.cct32c= 0 LET mcct.cct32d= 0 LET mcct.cct32e= 0
    LET mcct.cct32f= 0 LET mcct.cct32g= 0 LET mcct.cct32h= 0 #No.FUN-7C0101
    LET mcct.cct42 = 0 LET mcct.cct42a= 0 LET mcct.cct42b= 0
    LET mcct.cct42c= 0 LET mcct.cct42d= 0 LET mcct.cct42e= 0
    LET mcct.cct42f= 0 LET mcct.cct42g= 0 LET mcct.cct42h= 0 #No.FUN-7C0101
    LET mcct.cct92 = 0 LET mcct.cct92a= 0 LET mcct.cct92b= 0
    LET mcct.cct92c= 0 LET mcct.cct92d= 0 LET mcct.cct92e= 0
    LET mcct.cct92f= 0 LET mcct.cct92g= 0 LET mcct.cct92h= 0 #No.FUN-7C0101
 END IF
 
 SELECT SUM(ccu22),SUM(ccu22a),SUM(ccu22b),SUM(ccu22c),SUM(ccu22d),
        SUM(ccu22e),SUM(ccu22f),SUM(ccu22g),SUM(ccu22h)      #No.FUN-7C0101
   INTO mcct.cct23,mcct.cct23a,mcct.cct23b,mcct.cct23c,mcct.cct23d,mcct.cct23e,
        mcct.cct23f,mcct.cct23g,mcct.cct23h                  #No.FUN-7C0101
     FROM ccu_file 
  WHERE ccu01=g_ccu.ccu01 AND ccu02=g_ccu.ccu02 AND ccu03=g_ccu.ccu03
    AND ccu04=g_ccu.ccu04 AND ccu06=g_ccu.ccu06 AND ccu07=g_ccu.ccu07 #No.FUN-7C0101
    AND ccu05 IN ('M','R')
 IF mcct.cct23 IS NULL THEN 
    LET mcct.cct23 = 0 LET mcct.cct23a= 0 LET mcct.cct23b= 0
    LET mcct.cct23c= 0 LET mcct.cct23d= 0 LET mcct.cct23e= 0
    LET mcct.cct23f= 0 LET mcct.cct23g= 0 LET mcct.cct23h= 0 #No.FUN-7C0101
 END IF
 LET mcct.cct22 =mcct.cct22 -mcct.cct23
 LET mcct.cct22a=mcct.cct22a-mcct.cct23a
 LET mcct.cct22b=mcct.cct22b-mcct.cct23b
 LET mcct.cct22c=mcct.cct22c-mcct.cct23c
 LET mcct.cct22d=mcct.cct22d-mcct.cct23d
 LET mcct.cct22e=mcct.cct22e-mcct.cct23e
 LET mcct.cct22f=mcct.cct22f-mcct.cct23f                     #No.FUN-7C0101
 LET mcct.cct22g=mcct.cct22g-mcct.cct23g                     #No.FUN-7C0101
 LET mcct.cct22h=mcct.cct22h-mcct.cct23h                     #No.FUN-7C0101
 DISPLAY BY NAME
         mcct.cct12,mcct.cct22,mcct.cct23,mcct.cct32,mcct.cct42,mcct.cct92
 UPDATE cct_file SET cct_file.* = mcct.*
        WHERE cct01=g_ccu.ccu01 AND cct02=g_ccu.ccu02 AND cct03=g_ccu.ccu03
          AND cct06=g_ccu.ccu06
 IF STATUS THEN 
  CALL cl_err3("upd","cct_file",g_ccu.ccu01,g_ccu.ccu02,STATUS,"","upd cct.*:",1)  #No.FUN-660127
  
 RETURN END IF
END FUNCTION
 
FUNCTION t610_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ccu.* TO NULL              #No.FUN-6A0019
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t610_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t610_count
    FETCH t610_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t610_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t610_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_ccu.* TO NULL
    ELSE
        CALL t610_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t610_fetch(p_flccu)
    DEFINE
        p_flccu         LIKE type_file.chr1           #No.FUN-680122CHAR(01)
 
    CASE p_flccu
        WHEN 'N' FETCH NEXT     t610_cs INTO g_cct.cct04,g_ccu.ccu01,g_ccu.ccu02,g_ccu.ccu03,g_ccu.ccu04,g_ccu.ccu06,g_ccu.ccu07
        WHEN 'P' FETCH PREVIOUS t610_cs INTO g_cct.cct04,g_ccu.ccu01,g_ccu.ccu02,g_ccu.ccu03,g_ccu.ccu04,g_ccu.ccu06,g_ccu.ccu07
        WHEN 'F' FETCH FIRST    t610_cs INTO g_cct.cct04,g_ccu.ccu01,g_ccu.ccu02,g_ccu.ccu03,g_ccu.ccu04,g_ccu.ccu06,g_ccu.ccu07
        WHEN 'L' FETCH LAST     t610_cs INTO g_cct.cct04,g_ccu.ccu01,g_ccu.ccu02,g_ccu.ccu03,g_ccu.ccu04,g_ccu.ccu06,g_ccu.ccu07
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
            FETCH ABSOLUTE g_jump t610_cs INTO g_cct.cct04,g_ccu.ccu01,g_ccu.ccu02,g_ccu.ccu03,g_ccu.ccu04,g_ccu.ccu06,g_ccu.ccu07
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccu.ccu01,SQLCA.sqlcode,0)
        INITIALIZE g_ccu.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flccu
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ccu.* FROM ccu_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ccu01 = g_ccu.ccu01 AND ccu02 = g_ccu.ccu02 AND ccu03 = g_ccu.ccu03 AND ccu04 = g_ccu.ccu04 AND ccu06 = g_ccu.ccu06 AND ccu07 = g_ccu.ccu07
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ccu_file",g_ccu.ccu01,g_ccu.ccu02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE
 
        CALL t610_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t610_show()
    DEFINE mcct	RECORD LIKE cct_file.*
    DEFINE l_ima02              LIKE ima_file.ima02         #MOD-970158   
    DEFINE l_ima25              LIKE ima_file.ima25         #MOD-970158     
    DEFINE l_ima57		LIKE ima_file.ima57         #No.FUN-680122SMALLINT
    INITIALIZE mcct.* TO NULL
    SELECT * INTO mcct.* FROM cct_file
          WHERE cct01=g_ccu.ccu01 AND cct02=g_ccu.ccu02 AND cct03=g_ccu.ccu03
            AND cct06=g_ccu.ccu06
    DISPLAY BY NAME mcct.cct04,
            mcct.cct12,mcct.cct22,mcct.cct23,mcct.cct32,mcct.cct42,mcct.cct92
    LET g_ccu_t.* = g_ccu.*
    DISPLAY BY NAME
        g_ccu.ccu01, g_ccu.ccu02, g_ccu.ccu03, g_ccu.ccu04, g_ccu.ccu05, g_ccu.ccu06, g_ccu.ccu07 #No.FUN-7C0101
    LET l_ima02=NULL LET l_ima25=NULL
    SELECT ima02,ima25,ima57 INTO l_ima02,l_ima25,l_ima57
      FROM ima_file WHERE ima01 = mcct.cct04
    DISPLAY l_ima02,l_ima25,l_ima57 TO ima02,ima25,ima57
    LET l_ima02=NULL LET l_ima25=NULL
    SELECT ima02,ima25,ima57 INTO l_ima02,l_ima25,l_ima57
      FROM ima_file WHERE ima01=g_ccu.ccu04
    DISPLAY l_ima02,l_ima25,l_ima57 TO ima02b,ima25b,ima57b
    CALL t610_ccu04() #CHI-980066   
    SELECT sfb38,sfb08 INTO g_sfb38,g_sfb08 FROM sfb_file
     WHERE sfb01=g_ccu.ccu01
    DISPLAY g_sfb38,g_sfb08 TO sfb38,sfb08
 
    DISPLAY BY NAME
    g_ccu.ccuud01,g_ccu.ccuud02,g_ccu.ccuud03,g_ccu.ccuud04,
    g_ccu.ccuud05,g_ccu.ccuud06,g_ccu.ccuud07,g_ccu.ccuud08,
    g_ccu.ccuud09,g_ccu.ccuud10,g_ccu.ccuud11,g_ccu.ccuud12,
    g_ccu.ccuud13,g_ccu.ccuud14,g_ccu.ccuud15 
    CALL t610_show_2()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t610_ccu04()                                                                                                               
DEFINE l_sfa16  LIKE sfa_file.sfa16                                                                                                 
DEFINE l_sfa161 LIKE sfa_file.sfa161
   #No.FUN-A70136--begin                                                                                                
   #SELECT sfa16,sfa161 INTO l_sfa16,l_sfa161 FROM sfa_file                                                                          
   # WHERE sfa01=g_ccu.ccu01                                                                                                         
   #   AND sfa03=g_ccu.ccu04  
               
   DECLARE t610_sfa CURSOR FOR
    SELECT sfa16,sfa161                                                                          
      FROM sfa_file                                                                                                                  
    WHERE sfa01=g_ccu.ccu01                                                                                                         
      AND sfa03=g_ccu.ccu04   
   FOREACH t610_sfa INTO l_sfa16,l_sfa161 
      EXIT FOREACH 
   END FOREACH 
   #No.FUN-A70136--end                                                                                                   
   DISPLAY l_sfa16,l_sfa161 TO sfa16,sfa161                                                                                         
END FUNCTION                                                                                                                        
 
FUNCTION t610_show_2()
    DEFINE ccu12u,ccu22u,ccu32u,ccu42u,ccu92u	LIKE ccu_file.ccu12         #No.FUN-680122DEC(20,6)
    DISPLAY By NAME
        g_ccu.ccu11, g_ccu.ccu12a, g_ccu.ccu12b, g_ccu.ccu12c,
        g_ccu.ccu12d, g_ccu.ccu12e, g_ccu.ccu12f, g_ccu.ccu12g, g_ccu.ccu12h,g_ccu.ccu12,  #No.FUN-7C0101
        g_ccu.ccu21, g_ccu.ccu22a, g_ccu.ccu22b, g_ccu.ccu22c,
        g_ccu.ccu22d, g_ccu.ccu22e, g_ccu.ccu22f, g_ccu.ccu22g, g_ccu.ccu22h,g_ccu.ccu22,  #No.FUN-7C0101
        g_ccu.ccu31, g_ccu.ccu32a, g_ccu.ccu32b, g_ccu.ccu32c,
        g_ccu.ccu32d, g_ccu.ccu32e, g_ccu.ccu32f, g_ccu.ccu32g, g_ccu.ccu32h,g_ccu.ccu32,  #No.FUN-7C0101
        g_ccu.ccu41, g_ccu.ccu42a, g_ccu.ccu42b, g_ccu.ccu42c,
        g_ccu.ccu42d, g_ccu.ccu42e, g_ccu.ccu42f, g_ccu.ccu42g, g_ccu.ccu42h,g_ccu.ccu42,  #No.FUN-7C0101
        g_ccu.ccu91, g_ccu.ccu92a, g_ccu.ccu92b, g_ccu.ccu92c,
        g_ccu.ccu92d, g_ccu.ccu92e, g_ccu.ccu92f, g_ccu.ccu92g, g_ccu.ccu92h,g_ccu.ccu92   #No.FUN-7C0101
    LET ccu12u=0 LET ccu22u=0 LET ccu32u=0 LET ccu42u=0 LET ccu92u=0
    IF g_ccu.ccu11 <> 0 THEN LET ccu12u=g_ccu.ccu12/g_ccu.ccu11 END IF
    IF g_ccu.ccu21 <> 0 THEN LET ccu22u=g_ccu.ccu22/g_ccu.ccu21 END IF
    IF g_ccu.ccu31 <> 0 THEN LET ccu32u=g_ccu.ccu32/g_ccu.ccu31 END IF
    IF g_ccu.ccu41 <> 0 THEN LET ccu42u=g_ccu.ccu42/g_ccu.ccu41 END IF
    IF g_ccu.ccu91 <> 0 THEN LET ccu92u=g_ccu.ccu92/g_ccu.ccu91 END IF
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    DISPLAY BY NAME ccu12u,ccu22u,ccu32u,ccu42u,ccu92u
END FUNCTION
 
FUNCTION t610_u()
    IF g_ccu.ccu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ccu01_t = g_ccu.ccu01
    LET g_ccu02_t = g_ccu.ccu02
    LET g_ccu03_t = g_ccu.ccu03
    LET g_ccu04_t = g_ccu.ccu04
    LET g_ccu06_t = g_ccu.ccu06  #No.FUN-7C0101
    LET g_ccu07_t = g_ccu.ccu07  #No.FUN-7C0101
    BEGIN WORK
 
    OPEN t610_cl USING g_ccu.ccu01,g_ccu.ccu02,g_ccu.ccu03,g_ccu.ccu04,g_ccu.ccu06,g_ccu.ccu07
    IF STATUS THEN
       CALL cl_err("OPEN t610_cl:", STATUS, 1)
       CLOSE t610_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t610_cl INTO g_ccu.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t610_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t610_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ccu.*=g_ccu_t.*
            CALL t610_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ccu_file SET ccu_file.* = g_ccu.*    # 更新DB
            WHERE ccu01 = g_ccu_t.ccu01 AND ccu02 = g_ccu_t.ccu02 AND ccu03 = g_ccu_t.ccu03 AND ccu04 = g_ccu_t.ccu04 AND ccu06 = g_ccu_t.ccu06 AND ccu07 = g_ccu_t.ccu07            # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ccu_file",g_ccu01_t,g_ccu02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        CALL t610_b_tot('u')
        EXIT WHILE
    END WHILE
    CLOSE t610_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t610_r()
    IF g_ccu.ccu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t610_cl USING g_ccu.ccu01,g_ccu.ccu02,g_ccu.ccu03,g_ccu.ccu04,g_ccu.ccu06,g_ccu.ccu07
    IF STATUS THEN
       CALL cl_err("OPEN t610_cl:", STATUS, 1)
       CLOSE t610_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t610_cl INTO g_ccu.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccu.ccu01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t610_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ccu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ccu.ccu01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ccu_file WHERE ccu01 = g_ccu.ccu01
                              AND ccu02 = g_ccu.ccu02 AND ccu03 = g_ccu.ccu03
                              AND ccu04=g_ccu.ccu04 AND ccu06=g_ccu.ccu06 AND ccu07=g_ccu.ccu07 #No.FUN-7C0101
       CALL t610_b_tot('u')
       CLEAR FORM
         OPEN t610_count
         FETCH t610_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t610_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t610_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t610_fetch('/')
         END IF
    END IF
    CLOSE t610_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t610_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_name          LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)   # External(Disk) file name
        l_za05          LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)          #
        l_ccu RECORD LIKE ccu_file.*,
        sr RECORD
           ima02 LIKE ima_file.ima02,
           ima25 LIKE ima_file.ima25
           END RECORD
           
    DEFINE  l_avg LIKE ccu_file.ccu12
    DEFINE  l_ima02 LIKE ima_file.ima02
    DEFINE  l_ima021 LIKE ima_file.ima021
    CALL cl_del_data(l_table)    #No.FUN-840019   
    IF g_wc IS NULL THEN
        CALL cl_err('',9057,0)
        RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axct610'  #No.FUN-840019
    LET g_sql="SELECT ccu_file.*, ima02,ima25 ",
              " FROM ccu_file LEFT OUTER JOIN ima_file ON ccu04=ima_file.ima01, cct_file ",
              " WHERE ",g_wc CLIPPED,
              "   AND ccu01=cct01 AND ccu02=cct02 AND ccu03=cct03 AND ccu06=cct06"
    PREPARE t610_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t610_co CURSOR FOR t610_p1
 
 
    FOREACH t610_co INTO l_ccu.*, sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
        IF l_ccu.ccu91 = 0 THEN 
             LET l_avg = 0
        ELSE LET l_avg = l_ccu.ccu92/l_ccu.ccu91
        END IF
        SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
            WHERE ima01=l_ccu.ccu04
        IF SQLCA.sqlcode THEN 
            LET l_ima02 = NULL 
            LET l_ima021 = NULL 
        END IF 
        EXECUTE insert_prep USING
            l_ccu.ccu04,l_ima02,l_ima021,sr.ima25,l_ccu.ccu02,l_ccu.ccu03,
            l_ccu.ccu91,l_ccu.ccu92,l_avg,l_ccu.ccu01      
    END FOREACH
 
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED
    
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'cct04, ccu01,ccu02,ccu03,cct12,cct22,cct32,                          
                           cct42, cct92,ccu04,ccu05,ccu11,ccu12a,ccu12b,                                        
                           ccu12c,ccu12d,ccu12e,ccu12,ccu21,ccu22a,ccu22b,
                           ccu22c,ccu22d,ccu22e,ccu22,ccu31,ccu32a,ccu32b,
                           ccu32c,ccu32d,ccu32e,ccu32,ccu41,ccu42a,ccu42b,
                           ccu42c,ccu42d,ccu42e,ccu42,ccu91,ccu92a,ccu92b,
                           ccu92c,ccu92d,ccu92e,ccu92')
            RETURNING  g_wc
            LET g_str = g_wc
    END IF
    
    LET g_str = g_str
    
    CALL cl_prt_cs3('axct610','axct610',l_sql,g_str)
 
    CLOSE t610_co
    ERROR ""
END FUNCTION
 
FUNCTION t610_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) OR INFIELD(ccu04) THEN
     CALL cl_set_comp_entry("ccu01,ccu02,ccu03,ccu04,ccu06,ccu07",TRUE)  #No.FUN-7C0101 add ccu06,ccu07
  END IF
END FUNCTION
 
FUNCTION t610_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) OR INFIELD(ccu04) THEN
     CALL cl_set_comp_entry("ccu01,ccu02,ccu03,ccu04,ccu06,ccu07",FALSE) #No.FUN-7C0101 add ccu06,ccu07
  END IF
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/13 
