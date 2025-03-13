# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axct403.4gl
# Descriptions...: 製程在製成本調整資料維護作業
# Date & Author..: 96/02/18 By Roger
# Update & Date..: 97/02/18 By Hack
# Modify.........: No.A088 03/08/22 By Wiky 程式中沒有menu2
# Modify.........: No.FUN-4C0005 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660160 06/06/23 By Sarah t403_r()DELETE子句WHERE條件句調整,t403_i()增加AFTER FIELD cxl012
# Modify.........: No.FUN-660201 06/06/29 By Sarah 增加作業編號cxl012,移除cxl04參考單號為key值
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0101 08/01/11 By lala  成本改善增加cxl06(成本計算類別),cxl07(類別編號)和各種制費
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/07 By TSD.liquor 自定欄位功能修改
# Modify.........: No.FUN-910073 09/02/02 By jan 成本計算類別為"1or2"時,類別編號應noentry且自動給' '
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-970226 09/08/28 By destiny 修改工單編號和類別編號的檢查邏輯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/10/15 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cxl   RECORD LIKE cxl_file.*,
    g_cxl_t RECORD LIKE cxl_file.*,
    g_cxl01_t  LIKE cxl_file.cxl01,
    g_cxl012_t LIKE cxl_file.cxl012,   #FUN-660201 add
    g_cxl02_t  LIKE cxl_file.cxl02,
    g_cxl03_t  LIKE cxl_file.cxl03,
    #g_cxl04_t  LIKE cxl_file.cxl04,    #FUN-660201 mark
    g_cxl04_t  LIKE cxl_file.cxl04,    #FUN-7C0101
    g_cxl06_t  LIKE cxl_file.cxl06,    #FUN-7C0101
    g_cxl07_t  LIKE cxl_file.cxl07,    #FUN-7C0101
    g_wc,g_sql          string,  #No.FUN-580092 HCN
    g_ima   RECORD LIKE ima_file.*,
    g_sfb   RECORD LIKE sfb_file.*
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680122CHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5      #No.FUN-680122 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680122 SMALLINT
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680122 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0146
 
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
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    INITIALIZE g_cxl.* TO NULL
    INITIALIZE g_cxl_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM cxl_file WHERE cxl01 = ? AND cxl012 = ? AND cxl02 = ? AND cxl03 = ? AND cxl04 = ? AND cxl06 = ? AND cxl07 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t403_cl CURSOR FROM g_forupd_sql
    LET p_row = 3 LET p_col = 13
 
    OPEN WINDOW t403_w AT p_row,p_col
        WITH FORM "axc/42f/axct403"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t403_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t403_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t403_cs()
DEFINE l_cxl06 LIKE cxl_file.cxl06   #No.FUN-7C0101
    CLEAR FORM
   INITIALIZE g_cxl.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        cxl01,cxl012,cxl02,cxl03,cxl06,cxl05,cxl04,cxl07, cxl21,                #FUN-7C0101
        cxl22a,cxl22b,cxl22c,cxl22d,cxl22e,cxl22f,cxl22g,cxl22h,cxl22,          #FUN-7C0101
        cxluser,cxlgrup,cxlmodu,cxldate,
        #FUN-840202   ---start---
        cxlud01,cxlud02,cxlud03,cxlud04,cxlud05,
        cxlud06,cxlud07,cxlud08,cxlud09,cxlud10,
        cxlud11,cxlud12,cxlud13,cxlud14,cxlud15
        #FUN-840202    ----end----
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      #No.FUN-7C0101--start--
        AFTER FIELD cxl06
              LET l_cxl06 = get_fldbuf(cxl06)
 
        ON ACTION controlp
           CASE   
              WHEN INFIELD(cxl07)
                 IF l_cxl06 MATCHES '[45]' THEN  
                    CALL cl_init_qry_var() 
                    LET g_qryparam.state= "c"  
                 CASE l_cxl06  
                    WHEN '4'   
                      LET g_qryparam.form = "q_pja"  
                    WHEN '5'  
                      LET g_qryparam.form = "q_gem4" 
                    OTHERWISE EXIT CASE  
                 END CASE 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret  
                 DISPLAY  g_qryparam.multiret TO cxl07 
                 NEXT FIELD cxl07                                               
                 END IF 
              OTHERWISE EXIT CASE
           END CASE
       #No.FUN-7C0101---end---
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cxluser', 'cxlgrup') #FUN-980030
 
   #LET g_sql="SELECT cxl01,cxl02,cxl03,cxl04",    #FUN-660201 mark
    LET g_sql="SELECT cxl01,cxl012,cxl02,cxl03,cxl04,cxl06,cxl07",   #FUN-660201  #FUN-7C0101
              "  FROM cxl_file ",
              " WHERE ",g_wc CLIPPED,
             #" ORDER BY cxl01,cxl02,cxl03,cxl04"        #FUN-660201 mark
              " ORDER BY cxl01,cxl012,cxl02,cxl03,cxl04,cxl06,cxl07"       #FUN-660201
    PREPARE t403_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t403_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t403_prepare
    LET g_sql="SELECT COUNT(*) FROM cxl_file WHERE ",g_wc CLIPPED
    PREPARE t403_precount FROM g_sql
    DECLARE t403_count CURSOR FOR t403_precount
END FUNCTION
 
FUNCTION t403_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t403_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t403_q()
            END IF
        ON ACTION next
            CALL t403_fetch('N')
        ON ACTION previous
            CALL t403_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t403_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t403_r()
            END IF
        ON ACTION help
                     CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t403_fetch('/')
        ON ACTION first
            CALL t403_fetch('F')
        ON ACTION last
            CALL t403_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0019-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_cxl.cxl01 IS NOT NULL THEN
                  LET g_doc.column1 = "cxl01"
                  LET g_doc.value1 = g_cxl.cxl01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0019-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
    END MENU
    CLOSE t403_cs
END FUNCTION
 
#No:A088
##
FUNCTION t403_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_cxl.* TO NULL

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          RETURN
       END IF
#FUN-BC0062 --end--

    LET g_cxl.cxl01=g_cxl_t.cxl01   #FUN-7C0101
    LET g_cxl.cxl012=g_cxl_t.cxl012 #FUN-7C0101
    LET g_cxl.cxl02=g_cxl_t.cxl02
    LET g_cxl.cxl03=g_cxl_t.cxl03
    LET g_cxl.cxl04=g_cxl_t.cxl04
    LET g_cxl.cxl06=g_ccz.ccz28     #FUN-7C0101
    LET g_cxl.cxl07=g_cxl_t.cxl07   #FUN-7C0101
    LET g_cxl.cxl22=0
    LET g_cxl.cxl22a=0 LET g_cxl.cxl22b=0 LET g_cxl.cxl22c=0
    LET g_cxl.cxl22d=0 LET g_cxl.cxl22e=0 LET g_cxl.cxl22f=0
    LET g_cxl.cxl22g=0 LET g_cxl.cxl22h=0
    LET g_cxl01_t = NULL
    LET g_cxl012_t= NULL   #FUN-660201 add
    LET g_cxl02_t = NULL
    LET g_cxl03_t = NULL
   #LET g_cxl04_t = NULL   #FUN-660201 mark
    LET g_cxl04_t = NULL    #FUN-7C0101
    LET g_cxl06_t = NULL    #FUN-7C0101
    LET g_cxl07_t = NULL    #FUN-7C0101
    LET g_cxl_t.*=g_cxl.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cxl.cxlacti ='Y'                   #有效的資料
        LET g_cxl.cxluser = g_user
        LET g_cxl.cxloriu = g_user #FUN-980030
        LET g_cxl.cxlorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_cxl.cxlgrup = g_grup               #使用者所屬群
        LET g_cxl.cxldate = g_today
       #LET g_cxl.cxlplant= g_plant  #FUN-980009 add    #FUN-A50075
        LET g_cxl.cxllegal= g_legal  #FUN-980009 add
        CALL t403_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_cxl.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_cxl.cxl01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_cxl.cxl04 IS NULL THEN LET g_cxl.cxl04 = ' ' END IF
        INSERT INTO cxl_file VALUES(g_cxl.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err('ins cxl:',SQLCA.sqlcode,0)
            CONTINUE WHILE
        ELSE
            LET g_cxl_t.* = g_cxl.*                # 保存上筆資料
            SELECT cxl01,cxl012,cxl02,cxl03,cxl04,cxl06,cxl07 INTO g_cxl.cxl01,g_cxl.cxl012,g_cxl.cxl02,g_cxl.cxl03,g_cxl.cxl04,g_cxl.cxl06,g_cxl.cxl07 FROM cxl_file
             WHERE cxl01 = g_cxl.cxl01 
               AND cxl012= g_cxl.cxl012   #FUN-660201 add
               AND cxl02 = g_cxl.cxl02
               AND cxl03 = g_cxl.cxl03 
              #AND cxl04 = g_cxl.cxl04    #FUN-660201 mark
               AND cxl04 = g_cxl.cxl04    #FUN-7C0101
               AND cxl06 = g_cxl.cxl06    #FUN-7C0101
               AND cxl07 = g_cxl.cxl07    #FUN-7C0101
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t403_i(p_cmd)
    DEFINE l_cxl06 LIKE cxl_file.cxl06   #No.FUN-7C0101
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    INPUT BY NAME g_cxl.cxloriu,g_cxl.cxlorig,
        g_cxl.cxl01,g_cxl.cxl012,g_cxl.cxl02,g_cxl.cxl03,g_cxl.cxl06,g_cxl.cxl05,g_cxl.cxl04,g_cxl.cxl07,
        g_cxl.cxl21,
        g_cxl.cxl22a,g_cxl.cxl22b,g_cxl.cxl22c,g_cxl.cxl22d,g_cxl.cxl22e,
        g_cxl.cxl22f,g_cxl.cxl22g,g_cxl.cxl22h,g_cxl.cxl22,
        g_cxl.cxluser,g_cxl.cxlgrup,g_cxl.cxlmodu,g_cxl.cxldate,
        #FUN-840202     ---start---
        g_cxl.cxlud01,g_cxl.cxlud02,g_cxl.cxlud03,g_cxl.cxlud04,
        g_cxl.cxlud05,g_cxl.cxlud06,g_cxl.cxlud07,g_cxl.cxlud08,
        g_cxl.cxlud09,g_cxl.cxlud10,g_cxl.cxlud11,g_cxl.cxlud12,
        g_cxl.cxlud13,g_cxl.cxlud14,g_cxl.cxlud15 
        #FUN-840202     ----end----
 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t403_set_entry(p_cmd)
          CALL t403_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
            #No.FUN-550025 --start--
          CALL cl_set_docno_format("cxl01")
          CALL cl_set_docno_format("cxl04")
            #No.FUN-550025 ---end---
 
        AFTER FIELD cxl01
          IF g_cxl.cxl01 IS NOT NULL THEN
             IF (p_cmd='u' AND g_cxl.cxl01 !=g_cxl_t.cxl01) OR g_cxl_t.cxl01 IS NULL THEN      #No.TQC-970226
                SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=g_cxl.cxl01
                IF STATUS THEN
                   CALL cl_err('sel sfb:',STATUS,0) NEXT FIELD cxl01
                END IF
                SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_sfb.sfb05
                IF STATUS THEN
                   CALL cl_err('sel ima:',STATUS,0) NEXT FIELD cxl01
                END IF
                DISPLAY BY NAME g_sfb.sfb05,g_ima.ima02,g_ima.ima25
             END IF                                                            #No.TQC-970226
          END IF
 
       #start FUN-660160 add
        AFTER FIELD cxl012
          IF NOT cl_null(g_cxl.cxl012) THEN
            SELECT COUNT(*) INTO g_cnt FROM ecm_file
            WHERE ecm01=g_cxl.cxl01 AND ecm04=g_cxl.cxl012
            IF g_cnt=0 THEN
               CALL cl_err(g_cxl.cxl012,'aec-015',1)
               NEXT FIELD cxl012
            END IF
         # ELSE                                            #FUN-7C0101
          #  CALL cl_err(g_cxl.cxl012,'mfg0037',1)         #FUN-7C0101
           # NEXT FIELD cxl012                             #FUN-7C0101
          END IF
       #end FUN-660160 add
 
       #start FUN-660201 modify
       #AFTER FIELD cxl04
       #  IF g_cxl.cxl04 IS NOT NULL THEN
        AFTER FIELD cxl03
          IF g_cxl.cxl03 IS NOT NULL THEN
       #end FUN-660201 modify
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND
               (g_cxl.cxl01 != g_cxl01_t OR g_cxl.cxl02 != g_cxl02_t OR
                g_cxl.cxl03 != g_cxl03_t OR g_cxl.cxl012!= g_cxl012_t OR
                g_cxl.cxl06 != g_cxl06_t OR g_cxl.cxl07 != g_cxl07_t)) THEN   #FUN-660201 modify  #FUN-7C0101
                SELECT count(*) INTO l_n FROM cxl_file
                 WHERE cxl01 = g_cxl.cxl01 
                   AND cxl012= g_cxl.cxl012   #FUN-660201 add
                   AND cxl02 = g_cxl.cxl02
                   AND cxl03 = g_cxl.cxl03
                   AND cxl06 = g_cxl.cxl06    #FUN-7C0101
                   AND cxl07 = g_cxl.cxl07    #FUN-7C0101
                  #AND cxl04 = g_cxl.cxl04    #FUN-660201 mark
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD cxl01
                END IF
            END IF
          END IF
 
      #FUN-910073--BEGIN--
      AFTER FIELD cxl06
        IF g_cxl.cxl06 IS NOT NULL THEN 
           IF g_cxl.cxl06 MATCHES'[12]' THEN  
              CALL cl_set_comp_entry("cxl07",FALSE)
              LET g_cxl.cxl07 = ' '
           ELSE 
              CALL cl_set_comp_entry("cxl07",TRUE)
           END IF
        END IF
      #FUN-910073--END--
 
        #No.FUN-7C0101---start---
        AFTER FIELD cxl07
        IF g_cxl.cxl07 IS NULL THEN 
           LET g_cxl.cxl07 = ' '
           NEXT FIELD cxl07
        END IF   
#       IF l_cxl06='4' THEN                                                                   #No.TQC-970226
        IF g_cxl.cxl06='4' THEN                                                               #No.TQC-970226
           IF g_cxl.cxl07 IS NOT NULL THEN                                                    #No.TQC-970226
#            IF g_cxl.cxl07 != g_cxl_t.cxl07 OR g_cxl_t.cxl07 IS NULL THEN                    #No.TQC-970226
             IF (p_cmd='u' AND g_cxl.cxl07 != g_cxl_t.cxl07) OR p_cmd='a' THEN                #No.TQC-970226  
                SELECT COUNT(*) INTO l_n FROM pja_file
                 WHERE pjaacti='Y'
                   AND pjaclose='N'             #FUN-960038
                   AND pja01=g_cxl.cxl07                                                      #No.TQC-970226
                 IF l_n = 0 THEN
                    CALL cl_err(g_cxl.cxl07,'axc-004',0)                                      #No.TQC-970226
#                   CALL cl_err(g_cxl.cxl07,'apj-004',0)                                      #No.TQC-970226
                    LET g_cxl.cxl07 = g_cxl_t.cxl07
                    NEXT FIELD cxl07
                 END IF
             END IF
          END IF                                                                              #No.TQC-970226
        END IF
#       IF l_cxl06='5' THEN                                                                    #No.TQC-970226 
        IF g_cxl.cxl06='5' THEN                                                                #No.TQC-970226
           IF g_cxl.cxl07 IS NOT NULL THEN                                                     #No.TQC-970226
#             IF g_cxl.cxl07 != g_cxl_t.cxl07 OR g_cxl_t.cxl07 IS NULL THEN                    #No.TQC-970226
              IF (p_cmd='u' AND g_cxl.cxl07 != g_cxl_t.cxl07) OR p_cmd='a' THEN                #No.TQC-970226
                 SELECT COUNT(*) INTO l_n FROM gem_file
                 WHERE gem09 in ('1','2') AND gemacti = 'Y'
                   AND gem01=g_cxl.cxl07                                                       #No.TQC-970226 
                 IF l_n = 0 THEN
#                   CALL cl_err(g_cxl.cxl07,'axc-005',0)                                       #No.TQC-970226
                    CALL cl_err(g_cxl.cxl07,'apj-004',0)                                       #No.TQC-970226
                    LET g_cxl.cxl07 = g_cxl_t.cxl07
                    NEXT FIELD cxl07
                 END IF
              END IF
           END IF                                                                              #No.TQC-970226
        END IF
        #No.FUN-7C0101---end---
 
        AFTER FIELD cxl22a,cxl22b,cxl22c,cxl22d,cxl22e,cxl22f,cxl22g,cxl22h
            CALL t403_u_cost()
 
        #FUN-840202     ---start---
        AFTER FIELD cxlud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cxlud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_cxl.cxluser = s_get_data_owner("cxl_file") #FUN-C10039
           LET g_cxl.cxlgrup = s_get_data_group("cxl_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD cxl01
            END IF
      #MOD-650015 --start
      #   ON ACTION CONTROLO                        # 沿用所有欄位
      #       IF INFIELD(cxl01) THEN
      #           LET g_cxl.* = g_cxl_t.*
      #           DISPLAY BY NAME g_cxl.*
      #           NEXT FIELD cxl01
      #       END IF
      #MOD-650015 --end
      
#No.FUN-7C0101--start--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(cxl07)
               IF g_cxl.cxl06 MATCHES '[45]' THEN                
                  CALL cl_init_qry_var()
                  CASE g_cxl.cxl06
                     WHEN '4'
                        LET g_qryparam.form = "q_pja"                     
                     WHEN '5'
                        LET g_qryparam.form = "q_gem4"
                     OTHERWISE EXIT CASE
                  END CASE
                  LET g_qryparam.default1 = g_cxl.cxl07
                  CALL cl_create_qry() RETURNING g_cxl.cxl07
                  DISPLAY BY NAME g_cxl.cxl07
                  NEXT FIELD cxl07
               END IF
         END CASE
#No.FUN-7C0101---end---
 
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
 
FUNCTION t403_u_cost()
    LET g_cxl.cxl22=g_cxl.cxl22a+g_cxl.cxl22b+g_cxl.cxl22c+g_cxl.cxl22d+
        g_cxl.cxl22e+g_cxl.cxl22f+g_cxl.cxl22g+g_cxl.cxl22h
    DISPLAY BY NAME g_cxl.cxl22
END FUNCTION
 
FUNCTION t403_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cxl.* TO NULL              #No.FUN-6A0019 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t403_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t403_count
    FETCH t403_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t403_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t403_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_cxl.* TO NULL
    ELSE
        CALL t403_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t403_fetch(p_flcxl)
    DEFINE
        p_flcxl          LIKE type_file.chr1          #No.FUN-680122CHAR(01)
 
    CASE p_flcxl
        WHEN 'N' FETCH NEXT     t403_cs INTO g_cxl.cxl01,g_cxl.cxl012,g_cxl.cxl02,g_cxl.cxl03,g_cxl.cxl04,g_cxl.cxl06,g_cxl.cxl07     #FUN-7C0101
        WHEN 'P' FETCH PREVIOUS t403_cs INTO g_cxl.cxl01,g_cxl.cxl012,g_cxl.cxl02,g_cxl.cxl03,g_cxl.cxl04,g_cxl.cxl06,g_cxl.cxl07     #FUN-7C0101
        WHEN 'F' FETCH FIRST    t403_cs INTO g_cxl.cxl01,g_cxl.cxl012,g_cxl.cxl02,g_cxl.cxl03,g_cxl.cxl04,g_cxl.cxl06,g_cxl.cxl07     #FUN-7C0101
        WHEN 'L' FETCH LAST     t403_cs INTO g_cxl.cxl01,g_cxl.cxl012,g_cxl.cxl02,g_cxl.cxl03,g_cxl.cxl04,g_cxl.cxl06,g_cxl.cxl07     #FUN-7C0101
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
            FETCH ABSOLUTE g_jump t403_cs INTO g_cxl.cxl01,g_cxl.cxl012,g_cxl.cxl02,g_cxl.cxl03,g_cxl.cxl04,g_cxl.cxl06,g_cxl.cxl07     #FUN-7C0101
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cxl.cxl01,SQLCA.sqlcode,0)
        INITIALIZE g_cxl.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcxl
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cxl.* FROM cxl_file            # 重讀DB,因TEMP有不被更新特性
       WHERE cxl01 = g_cxl.cxl01 AND cxl012 = g_cxl.cxl012 AND cxl02 = g_cxl.cxl02 AND cxl03 = g_cxl.cxl03 AND cxl04 = g_cxl.cxl04 AND cxl06 = g_cxl.cxl06 AND cxl07 = g_cxl.cxl07
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cxl.cxl01,SQLCA.sqlcode,0)
    ELSE                                         #FUN-4C0061權限控管
       LET g_data_owner = g_cxl.cxluser
       LET g_data_group = g_cxl.cxlgrup
      #LET g_data_plant = g_cxl.cxlplant #FUN-980030     #FUN-A50075
       LET g_data_plant = g_plant #FUN-A50075
        CALL t403_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t403_show()
    LET g_cxl_t.* = g_cxl.*
    DISPLAY BY NAME g_cxl.cxloriu,g_cxl.cxlorig,
        g_cxl.cxl01,g_cxl.cxl02,g_cxl.cxl03,g_cxl.cxl04,g_cxl.cxl012,
        g_cxl.cxl21,g_cxl.cxl05,g_cxl.cxl06,g_cxl.cxl07,                        #FUN-7C0101
        g_cxl.cxl22a,g_cxl.cxl22b,g_cxl.cxl22c,g_cxl.cxl22d,g_cxl.cxl22e,
        g_cxl.cxl22f,g_cxl.cxl22g,g_cxl.cxl22h,g_cxl.cxl22,                     #FUN-7C0101
        g_cxl.cxluser,g_cxl.cxlgrup,g_cxl.cxlmodu,g_cxl.cxldate,
        #FUN-840202     ---start---
        g_cxl.cxlud01,g_cxl.cxlud02,g_cxl.cxlud03,g_cxl.cxlud04,
        g_cxl.cxlud05,g_cxl.cxlud06,g_cxl.cxlud07,g_cxl.cxlud08,
        g_cxl.cxlud09,g_cxl.cxlud10,g_cxl.cxlud11,g_cxl.cxlud12,
        g_cxl.cxlud13,g_cxl.cxlud14,g_cxl.cxlud15 
        #FUN-840202     ----end----
    INITIALIZE g_sfb.* TO NULL
    INITIALIZE g_ima.* TO NULL
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=g_cxl.cxl01
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_sfb.sfb05
    DISPLAY BY NAME g_sfb.sfb05,g_ima.ima25,g_ima.ima02
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t403_u()
    IF g_cxl.cxl01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cxl01_t = g_cxl.cxl01
    LET g_cxl012_t= g_cxl.cxl012   #FUN-660201 add
    LET g_cxl02_t = g_cxl.cxl02
    LET g_cxl03_t = g_cxl.cxl03
   #LET g_cxl04_t = g_cxl.cxl04    #FUN-660201 mark
    LET g_cxl04_t = g_cxl.cxl04    #FUN-7C0101
    LET g_cxl06_t = g_cxl.cxl06    #FUN-7C0101
    LET g_cxl07_t = g_cxl.cxl07    #FUN-7C0101
    BEGIN WORK
 
    OPEN t403_cl USING g_cxl.cxl01,g_cxl.cxl012,g_cxl.cxl02,g_cxl.cxl03,g_cxl.cxl04,g_cxl.cxl06,g_cxl.cxl07
    IF STATUS THEN
       CALL cl_err("OPEN t403_cl:", STATUS, 1)
       CLOSE t403_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t403_cl INTO g_cxl.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
     IF cl_null(g_cxl.cxlacti) THEN LET g_cxl.cxlacti ='Y' END IF
     IF cl_null(g_cxl.cxluser) THEN LET g_cxl.cxluser = g_user END IF
     IF cl_null(g_cxl.cxlgrup) THEN LET g_cxl.cxlgrup = g_grup END IF
        LET g_cxl.cxlmodu=g_user                     #修改者
        LET g_cxl.cxldate = g_today                  #修改日期
    CALL t403_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t403_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cxl.*=g_cxl_t.*
            CALL t403_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cxl.cxl04 IS NULL THEN LET g_cxl.cxl04 = ' ' END IF
        UPDATE cxl_file SET cxl_file.* = g_cxl.*    # 更新DB
         WHERE cxl01 = g_cxl_t.cxl01 AND cxl012 = g_cxl_t.cxl012 AND cxl02 = g_cxl_t.cxl02 AND cxl03 = g_cxl_t.cxl03 AND cxl04 = g_cxl_t.cxl04 AND cxl06 = g_cxl_t.cxl06 AND cxl07 = g_cxl_t.cxl07            # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_cxl.cxl01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t403_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t403_r()
    IF g_cxl.cxl01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t403_cl USING g_cxl.cxl01,g_cxl.cxl012,g_cxl.cxl02,g_cxl.cxl03,g_cxl.cxl04,g_cxl.cxl06,g_cxl.cxl07
    IF STATUS THEN
       CALL cl_err("OPEN t403_cl:", STATUS, 1)
       CLOSE t403_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t403_cl INTO g_cxl.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cxl.cxl01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t403_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cxl01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cxl.cxl01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM cxl_file
        WHERE cxl01 = g_cxl.cxl01 
          AND cxl012= g_cxl.cxl012   #FUN-660160 add
          AND cxl02 = g_cxl.cxl02
          AND cxl03 = g_cxl.cxl03 
         #AND cxl04 = g_cxl.cxl04    #FUN-660160 mark
          AND cxl04 = g_cxl.cxl04    #FUN-7C0101
          AND cxl06 = g_cxl.cxl06    #FUN-7C0101
          AND cxl07 = g_cxl.cxl07    #FUN-7C0101
       CLEAR FORM
         OPEN t403_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t403_cs
            CLOSE t403_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t403_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t403_cs
            CLOSE t403_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t403_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t403_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t403_fetch('/')
         END IF
    END IF
    CLOSE t403_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t403_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("cxl01,cxl02,cxl03,cxl04,cxl06,cxl07,cxl012",TRUE)
  END IF
END FUNCTION
 
FUNCTION t403_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("cxl01,cxl02,cxl03,cxl04,cxl06,cxl07,cxl012",FALSE)
  END IF
  #FUN-910073--BENGIN--
  IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND
     (NOT g_before_input_done) THEN
     IF g_cxl.cxl06 MATCHES'[12]' THEN  
        CALL cl_set_comp_entry("cxl07",FALSE)
     ELSE
        CALL cl_set_comp_entry("cxl07",TRUE)
     END IF
  END IF
  #FUN-910073--END--
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #

