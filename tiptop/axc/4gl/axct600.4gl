# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axct600.4gl
# Descriptions...: 每月拆件式工單主件在製成本維護作業
# Date & Author..: 98/08/27 By Star
# Modify.........: No.FUN-4C0005 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
#
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/27 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0101 08/01/11 By lala  成本改善增加cct06(成本計算類別),cct07(類別編號)和各種制費
# Modify.........: No.FUN-840202 08/05/07 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970003 09/07/01 By jan 批次成本修改
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1 LIKE cct_file.cct01,
    g_argv2 LIKE cct_file.cct02,
    g_argv3 LIKE cct_file.cct03,
    g_argv4 LIKE cct_file.cct04,
    g_argv5 LIKE cct_file.cct06,     #成本計算類別 #No.FUN-7C0101
    g_argv6 LIKE cct_file.cct07,     #類別編號     #No.FUN-7C0101
    g_cct   RECORD LIKE cct_file.*,
    g_cct_t RECORD LIKE cct_file.*,
    g_cct01_t LIKE cct_file.cct01,
    g_cct02_t LIKE cct_file.cct02,
    g_cct03_t LIKE cct_file.cct03,
    g_cct06_t LIKE cct_file.cct06,    #FUN-7C0101
    g_cct07_t LIKE cct_file.cct07,    #FUN-7C0101
    g_wc,g_sql          string,    #No.FUN-580092 HCN
    g_ima   RECORD LIKE ima_file.*,
    g_sfb   RECORD LIKE sfb_file.*
 
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680122 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
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
 
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)
    LET g_argv5 = ARG_VAL(5)   #No.FUN-7C0101 #成本計算類別
    LET g_argv6 = ARG_VAL(6)   #No.FUN-7C0101 #類別編號
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    INITIALIZE g_cct.* TO NULL
    INITIALIZE g_cct_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM cct_file WHERE cct01 = ? AND cct02 = ? AND cct03 = ? AND cct06 = ? AND cct07 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW t600_w AT p_row,p_col
        WITH FORM "axc/42f/axct600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    IF NOT cl_null(g_argv1) THEN CALL t600_q() END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL t600_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW t600_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t600_cs()
DEFINE l_cct06 LIKE cct_file.cct06   #No.FUN-7C0101
    CLEAR FORM
    IF NOT cl_null(g_argv1) AND g_argv1 != '@' THEN
       LET g_wc="cct01='",g_argv1,"' AND cct02=",g_argv2," AND cct03=",g_argv3
                 ," AND cct06 = '",g_argv5,"' AND cct07 = '",g_argv6,"'"        #No.FUN-7C01011 add
    END IF
    IF NOT cl_null(g_argv1) AND g_argv1  = '@' THEN
       LET g_wc="cct04='",g_argv4,"' AND cct02=",g_argv2," AND cct03=",g_argv3
                ," AND cct06 = '",g_argv5,"' AND cct07 = '",g_argv6,"'"        #No.FUN-7C01011 add
    END IF
    IF cl_null(g_argv1) THEN
    INITIALIZE g_cct.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        cct04, cct01, cct02, cct03, cct06, cct07,                    #FUN-7C0101
               cct12a, cct12b, cct12c, cct12d, cct12e, cct12f, cct12g, cct12h, cct12,       #FUN-7C0101
        cct20,
               cct22a, cct22b, cct22c, cct22d, cct22e, cct22f, cct22g, cct22h, cct22,    #FUN-7C0101
               cct32a, cct32b, cct32c, cct32d, cct32e, cct32f, cct32g, cct32h, cct32,    #FUN-7C0101
               cct42a, cct42b, cct42c, cct42d, cct42e, cct42f, cct42g, cct42h, cct42,    #FUN-7C0101
               cct92a, cct92b, cct92c, cct92d, cct92e, cct92f, cct92g, cct92h, cct92,    #FUN-7C0101
        cctuser, cctdate,ccttime,
            #FUN-840202   ---start---
               cctud01,cctud02,cctud03,cctud04,cctud05,cctud06,cctud07,
               cctud08,cctud09,cctud10,cctud11,cctud12,cctud13,cctud14,
               cctud15
            #FUN-840202    ----end----
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
      #No.FUN-7C0101--start--
        AFTER FIELD cct06
              LET l_cct06 = get_fldbuf(cct06)
      #No.FUN-7C0101---end---
 
       #MOD-530850
      ON ACTION CONTROLP
        CASE
          WHEN INFIELD(cct04)
#FUN-AA0059---------mod------------str-----------------
#           CALL cl_init_qry_var()
#           LET g_qryparam.form = "q_ima"
#           LET g_qryparam.state = "c"
#           LET g_qryparam.default1 = g_cct.cct04
#           CALL cl_create_qry() RETURNING g_qryparam.multiret
            CALL q_sel_ima(TRUE, "q_ima","",g_cct.cct04,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

            DISPLAY g_qryparam.multiret TO cct04
            NEXT FIELD cct04
          #No.FUN-7C0101--start--                                           
          WHEN INFIELD(cct07)                                               
             IF l_cct06 MATCHES '[45]' THEN                             
                CALL cl_init_qry_var()       
                LET g_qryparam.state= "c"                                
             CASE l_cct06                                               
                WHEN '4'                                                    
                  LET g_qryparam.form = "q_pja"                             
                WHEN '5'                                                    
                  LET g_qryparam.form = "q_gem4"                            
                OTHERWISE EXIT CASE                                         
             END CASE                                                       
             CALL cl_create_qry() RETURNING g_qryparam.multiret                     
             DISPLAY  g_qryparam.multiret TO cct07                                   
             NEXT FIELD cct07                                               
             END IF                                                         
       #No.FUN-7C0101---end---
         OTHERWISE
            EXIT CASE
       END CASE
     #--
 
      # ON KEY(F1) NEXT FIELD cct12a
      # ON KEY(F2) NEXT FIELD cct20
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
       #--NO.MOD-860078 start--
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
       #--NO.MOD-860078 end----
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cctuser', 'cctgrup') #FUN-980030
    END IF
 
    IF INT_FLAG THEN RETURN END IF
    LET g_sql="SELECT cct04,cct01,cct02,cct03,cct06,cct07 FROM cct_file ",     #FUN-7C0101
        " WHERE ",g_wc CLIPPED," ORDER BY cct04,cct01,cct02,cct03,cct06,cct07"       #FUN-7C0101
    PREPARE t600_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t600_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t600_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM cct_file WHERE ",g_wc CLIPPED
    PREPARE t600_precount FROM g_sql
    DECLARE t600_count CURSOR FOR t600_precount
END FUNCTION
 
FUNCTION t600_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #  ON ACTION insert
     #      IF cl_chk_act_auth() THEN
     #         CALL t600_a()
     #      END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t600_q()
            END IF
        ON ACTION next
            CALL t600_fetch('N')
        ON ACTION previous
            CALL t600_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t600_u()
            END IF
#       ON ACTION 元件單身
        ON ACTION component_detail
            LET g_action_choice="component_detail"
            IF cl_chk_act_auth() THEN
               LET g_msg="axct610 ",g_cct.cct01," ",g_cct.cct02," ",g_cct.cct03
                        #," ",g_cct.cct06," ",g_cct.cct07        #No.FUN-7C0101 add#TQC-970003
                         ," ",g_cct.cct06    #TQC-970003
               #CALL cl_cmdrun(g_msg)      #FUN-660216 remark
               CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
            END IF
            SELECT * INTO g_cct.* FROM cct_file WHERE cct01 = g_cct.cct01 AND cct02 = g_cct.cct02 AND cct03 = g_cct.cct03 AND cct06 = g_cct.cct06 AND cct07 = g_cct.cct07
            CALL t600_show()
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
            CALL t600_fetch('/')
        ON ACTION first
            CALL t600_fetch('F')
        ON ACTION last
            CALL t600_fetch('L')

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
               IF g_cct.cct04 IS NOT NULL THEN
                  LET g_doc.column1 = "cct04"
                  LET g_doc.value1 = g_cct.cct04
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0019-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE t600_cs
END FUNCTION
 
 
FUNCTION g_cct_zero()
   LET g_cct.cct11=0
   LET g_cct.cct12=0   LET g_cct.cct12a=0  LET g_cct.cct12b=0
   LET g_cct.cct12c=0  LET g_cct.cct12d=0  LET g_cct.cct12e=0
   LET g_cct.cct12f=0  LET g_cct.cct12g=0  LET g_cct.cct12h=0                   #FUN-7C0101
   LET g_cct.cct20=0   LET g_cct.cct21=0
   LET g_cct.cct22=0   LET g_cct.cct22a=0  LET g_cct.cct22b=0
   LET g_cct.cct22c=0  LET g_cct.cct22d=0  LET g_cct.cct22e=0
   LET g_cct.cct22f=0  LET g_cct.cct22g=0  LET g_cct.cct22h=0                   #FUN-7C0101
   #LET g_cct.cct23=0   LET g_cct.cct23a=0  LET g_cct.cct23b=0
   #LET g_cct.cct23c=0  LET g_cct.cct23d=0  LET g_cct.cct23e=0
   LET g_cct.cct31=0
   LET g_cct.cct32=0   LET g_cct.cct32a=0  LET g_cct.cct32b=0
   LET g_cct.cct32c=0  LET g_cct.cct32d=0  LET g_cct.cct32e=0
   LET g_cct.cct32f=0  LET g_cct.cct32g=0  LET g_cct.cct32h=0                   #FUN-7C0101
   LET g_cct.cct41=0
   LET g_cct.cct42=0   LET g_cct.cct42a=0  LET g_cct.cct42b=0
   LET g_cct.cct42c=0  LET g_cct.cct42d=0  LET g_cct.cct42e=0
   LET g_cct.cct42f=0  LET g_cct.cct42g=0  LET g_cct.cct42h=0                   #FUN-7C0101
   LET g_cct.cct91=0
   LET g_cct.cct92=0   LET g_cct.cct92a=0  LET g_cct.cct92b=0
   LET g_cct.cct92c=0  LET g_cct.cct92d=0  LET g_cct.cct92e=0
   LET g_cct.cct92f=0  LET g_cct.cct92g=0  LET g_cct.cct92h=0                   #FUN-7C0101
END FUNCTION
 
 
FUNCTION t600_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_cct.* LIKE cct_file.*

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          RETURN
       END IF
#FUN-BC0062 --end--

    LET g_cct.cct06=g_ccz.ccz28     #FUN-7C0101
    CALL g_cct_zero()
    LET g_cct.cct02=g_cct_t.cct02
    LET g_cct.cct03=g_cct_t.cct03
    LET g_cct01_t = NULL
    LET g_cct02_t = NULL
    LET g_cct03_t = NULL
   #LET g_cct.cctplant = g_plant  #FUN-980009 add     #FUN-A50075
    LET g_cct.cctlegal = g_legal  #FUN-980009 add
    LET g_cct_t.*=g_cct.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL t600_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_cct.cct01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_cct.cctoriu = g_user      #No.FUN-980030 10/01/04
        LET g_cct.cctorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cct_file VALUES(g_cct.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err('ins cct:',SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","cct_file",g_cct.cct01,g_cct.cct02,SQLCA.sqlcode,"","ins cct:",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            LET g_cct_t.* = g_cct.*                # 保存上筆資料
            SELECT cct01,cct02,cct03,cct06,cct07 INTO g_cct.cct01,g_cct.cct02,g_cct.cct03,g_cct.cct06,g_cct.cct07 FROM cct_file
                WHERE cct01 = g_cct.cct01
                  AND cct02 = g_cct.cct02 AND cct03 = g_cct.cct03
                  AND cct06 = g_cct.cct06 AND cct07 = g_cct.cct07         #FUN-7C0101
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
 
FUNCTION t600_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    INPUT BY NAME
        g_cct.cct04, g_cct.cct01, g_cct.cct02, g_cct.cct03, g_cct.cct06, g_cct.cct07,     #FUN-7C0101
                     g_cct.cct12a, g_cct.cct12b, g_cct.cct12c,
                     g_cct.cct12d, g_cct.cct12e, g_cct.cct12f,                            #FUN-7C0101
                     g_cct.cct12g, g_cct.cct12h, g_cct.cct12,                             #FUN-7C0101
        g_cct.cct20,
                     g_cct.cct22a, g_cct.cct22b, g_cct.cct22c,
                     g_cct.cct22d, g_cct.cct22e, g_cct.cct22f,                            #FUN-7C0101
                     g_cct.cct22g, g_cct.cct22h, g_cct.cct22,                             #FUN-7C0101
                 #   g_cct.cct23a, g_cct.cct23b, g_cct.cct23c,
                 #   g_cct.cct23d, g_cct.cct23e, g_cct.cct23,
                     g_cct.cct32a, g_cct.cct32b, g_cct.cct32c,
                     g_cct.cct32d, g_cct.cct32e, g_cct.cct32f,                            #FUN-7C0101
                     g_cct.cct32g, g_cct.cct32h, g_cct.cct32,                             #FUN-7C0101
                     g_cct.cct42a, g_cct.cct42b, g_cct.cct42c,
                     g_cct.cct42d, g_cct.cct42e, g_cct.cct42f,                            #FUN-7C0101
                     g_cct.cct42g, g_cct.cct42h, g_cct.cct42,                             #FUN-7C0101
                     g_cct.cct92a, g_cct.cct92b, g_cct.cct92c,
                     g_cct.cct92d, g_cct.cct92e, g_cct.cct92f,                            #FUN-7C0101
                     g_cct.cct92g, g_cct.cct92h, g_cct.cct92,                             #FUN-7C0101
        g_cct.cctuser,g_cct.cctdate,g_cct.ccttime,
                   #FUN-840202     ---start---
                     g_cct.cctud01,g_cct.cctud02,g_cct.cctud03,g_cct.cctud04,
                     g_cct.cctud05,g_cct.cctud06,g_cct.cctud07,g_cct.cctud08,
                     g_cct.cctud09,g_cct.cctud10,g_cct.cctud11,g_cct.cctud12,
                     g_cct.cctud13,g_cct.cctud14,g_cct.cctud15
                   #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t600_set_entry(p_cmd)
          CALL t600_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
            #No.FUN-550025 --start--
          CALL cl_set_docno_format("cct01")
            #No.FUN-550025 ---end---
 
        AFTER FIELD cct01
          IF g_cct.cct01 IS NOT NULL THEN
            SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=g_cct.cct01
            IF STATUS THEN
#              CALL cl_err('sel sfb:',STATUS,0)    #No.FUN-660127
               CALL cl_err3("sel","sfb_file",g_cct.cct01,"",STATUS,"","sel sfb:",1)  #No.FUN-660127
               NEXT FIELD cct01
            END IF
            LET g_cct.cct04=g_sfb.sfb05
            DISPLAY BY NAME g_cct.cct04
            INITIALIZE g_ima.* TO NULL
            SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_cct.cct04
            DISPLAY BY NAME g_ima.ima02,g_ima.ima25
          END IF
 
        AFTER FIELD cct03
          IF g_cct.cct03 IS NOT NULL THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND
               (g_cct.cct01 != g_cct01_t OR
                g_cct.cct02 != g_cct02_t OR g_cct.cct03 != g_cct03_t OR
                g_cct.cct06 != g_cct06_t OR g_cct.cct07 != g_cct07_t)) THEN       #FUN-7C0101
                SELECT count(*) INTO l_n FROM cct_file
                    WHERE cct01 = g_cct.cct01
                      AND cct02 = g_cct.cct02 AND cct03 = g_cct.cct03
                      AND cct06 = g_cct.cct06 AND cct07 = g_cct.cct07           #FUN-7C0101
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD cct01
                END IF
            END IF
          END IF
 
        #No.FUN-7C0101---start---
        AFTER FIELD cct07
           IF g_cct.cct07 IS NULL THEN
              LET g_cct.cct07=' '
              NEXT FIELD cct07
           END IF
        #No.FUN-7C0101---end---
 
        AFTER FIELD
               cct12a, cct12b, cct12c, cct12d, cct12e, cct12f, cct12g, cct12h, cct12,       #FUN-7C0101
        cct20,
               cct22a, cct22b, cct22c, cct22d, cct22e, cct22f, cct22g, cct22h, cct22,       #FUN-7C0101
            #  cct23a, cct23b, cct23c, cct23d, cct23e, cct23,
               cct32a, cct32b, cct32c, cct32d, cct32e, cct32f, cct32g, cct32h, cct32,       #FUN-7C0101
               cct42a, cct42b, cct42c, cct42d, cct42e, cct42f, cct42g, cct42h, cct42,       #FUN-7C0101
               cct92a, cct92b, cct92c, cct92d, cct92e, cct92f, cct92g, cct92h, cct92        #FUN-7C0101
            CALL t600_u_cost()
 
        #FUN-840202     ---start---
        AFTER FIELD cctud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cctud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-840202     ----end----
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD cct01
            END IF
 
       #MOD-650015 --start
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(cct01) THEN
       #         LET g_cct.* = g_cct_t.*
       #         DISPLAY BY NAME g_cct.*
       #         NEXT FIELD cct01
       #     END IF
       #MOD-650015 --end
       
     #No.FUN-7C0101--start--
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(cct07)
                  IF g_cct.cct06 MATCHES '[45]' THEN                
                     CALL cl_init_qry_var()
                     CASE g_cct.cct06
                        WHEN '4'
                           LET g_qryparam.form = "q_pja" 
                        WHEN '5'
                           LET g_qryparam.form = "q_gem4"
                        OTHERWISE EXIT CASE
                     END CASE
                     LET g_qryparam.default1 = g_cct.cct07
                     CALL cl_create_qry() RETURNING g_cct.cct07
                     DISPLAY BY NAME g_cct.cct07
                     NEXT FIELD cct07
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
 
        ON KEY(F1) NEXT FIELD cct12a
        ON KEY(F2) NEXT FIELD cct20
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t600_u_cost()
#   LET g_cct.cct91=g_cct.cct11+g_cct.cct21+g_cct.cct31+g_cct.cct41
    LET g_cct.cct92=g_cct.cct12+g_cct.cct22+g_cct.cct32+g_cct.cct42
    LET g_cct.cct92a=g_cct.cct12a+g_cct.cct22a+g_cct.cct23a
                                 +g_cct.cct32a+g_cct.cct42a
    LET g_cct.cct92b=g_cct.cct12b+g_cct.cct22b+g_cct.cct23b
                                 +g_cct.cct32b+g_cct.cct42b
    LET g_cct.cct92c=g_cct.cct12c+g_cct.cct22c+g_cct.cct23c
                                 +g_cct.cct32c+g_cct.cct42c
    LET g_cct.cct92d=g_cct.cct12d+g_cct.cct22d+g_cct.cct23d
                                 +g_cct.cct32d+g_cct.cct42d
    LET g_cct.cct92e=g_cct.cct12e+g_cct.cct22e+g_cct.cct23e
                                 +g_cct.cct32e+g_cct.cct42e
    LET g_cct.cct92f=g_cct.cct12f+g_cct.cct22f+g_cct.cct23f                     #FUN-7C0101
                                 +g_cct.cct32f+g_cct.cct42f                     #FUN-7C0101
    LET g_cct.cct92g=g_cct.cct12g+g_cct.cct22g+g_cct.cct23g                     #FUN-7C0101
                                 +g_cct.cct32g+g_cct.cct42g                     #FUN-7C0101
    LET g_cct.cct92h=g_cct.cct12h+g_cct.cct22h+g_cct.cct23h                     #FUN-7C0101
                                 +g_cct.cct32h+g_cct.cct42h                     #FUN-7C0101
    LET g_cct.cct12=g_cct.cct12a+g_cct.cct12b+g_cct.cct12c+g_cct.cct12d
                   +g_cct.cct12e+g_cct.cct12f+g_cct.cct12g+g_cct.cct12h         #FUN-7C0101
    LET g_cct.cct22=g_cct.cct22a+g_cct.cct22b+g_cct.cct22c+g_cct.cct22d
                   +g_cct.cct22e+g_cct.cct22f+g_cct.cct22g+g_cct.cct22h         #FUN-7C0101
    LET g_cct.cct32=g_cct.cct32a+g_cct.cct32b+g_cct.cct32c+g_cct.cct32d
                   +g_cct.cct32e+g_cct.cct32f+g_cct.cct32g+g_cct.cct32h         #FUN-7C0101
    LET g_cct.cct42=g_cct.cct42a+g_cct.cct42b+g_cct.cct42c+g_cct.cct42d
                   +g_cct.cct42e+g_cct.cct42f+g_cct.cct42g+g_cct.cct42h         #FUN-7C0101
    LET g_cct.cct92=g_cct.cct92a+g_cct.cct92b+g_cct.cct92c+g_cct.cct92d
                   +g_cct.cct92e+g_cct.cct92f+g_cct.cct92g+g_cct.cct92h         #FUN-7C0101
    CALL t600_show_2()
END FUNCTION
 
FUNCTION t600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cct.* TO NULL              #No.FUN-6A0019
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t600_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t600_count
    FETCH t600_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t600_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_cct.* TO NULL
    ELSE
        CALL t600_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t600_fetch(p_flcct)
    DEFINE
        p_flcct           LIKE type_file.chr1           #No.FUN-680122CHAR(01)
 
    CASE p_flcct
        WHEN 'N' FETCH NEXT     t600_cs INTO g_cct.cct04,g_cct.cct01,g_cct.cct02,g_cct.cct03,g_cct.cct06,g_cct.cct07     #FUN-7C0101
        WHEN 'P' FETCH PREVIOUS t600_cs INTO g_cct.cct04,g_cct.cct01,g_cct.cct02,g_cct.cct03,g_cct.cct06,g_cct.cct07     #FUN-7C0101
        WHEN 'F' FETCH FIRST    t600_cs INTO g_cct.cct04,g_cct.cct01,g_cct.cct02,g_cct.cct03,g_cct.cct06,g_cct.cct07     #FUN-7C0101
        WHEN 'L' FETCH LAST     t600_cs INTO g_cct.cct04,g_cct.cct01,g_cct.cct02,g_cct.cct03,g_cct.cct06,g_cct.cct07     #FUN-7C0101
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
            FETCH ABSOLUTE g_jump t600_cs INTO g_cct.cct04,g_cct.cct01,g_cct.cct02,g_cct.cct03,g_cct.cct06,g_cct.cct07     #FUN-7C0101
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cct.cct01,SQLCA.sqlcode,0)
        INITIALIZE g_cct.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcct
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cct.* FROM cct_file            # 重讀DB,因TEMP有不被更新特性
       WHERE cct01 = g_cct.cct01 AND cct02 = g_cct.cct02 AND cct03 = g_cct.cct03 AND cct06 = g_cct.cct06 AND cct07 = g_cct.cct07
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cct.cct01,SQLCA.sqlcode,0)   #No.FUN-660127
        CALL cl_err3("sel","cct_file",g_cct.cct01,g_cct.cct02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE
        CALL t600_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t600_show()
    LET g_cct_t.* = g_cct.*
    DISPLAY BY NAME
        g_cct.cct04, g_cct.cct01, g_cct.cct02, g_cct.cct03, g_cct.cct06, g_cct.cct07,     #FUN-7C0101
        g_cct.cct12a, g_cct.cct12b, g_cct.cct12c,g_cct.cct12d, g_cct.cct12e,
        g_cct.cct12f, g_cct.cct12g, g_cct.cct12h, g_cct.cct12,                            #FUN-7C0101
        g_cct.cct20,
        g_cct.cctuser, g_cct.cctdate, g_cct.ccttime,
      #FUN-840202     ---start---
        g_cct.cctud01,g_cct.cctud02,g_cct.cctud03,g_cct.cctud04,
        g_cct.cctud05,g_cct.cctud06,g_cct.cctud07,g_cct.cctud08,
        g_cct.cctud09,g_cct.cctud10,g_cct.cctud11,g_cct.cctud12,
        g_cct.cctud13,g_cct.cctud14,g_cct.cctud15
      #FUN-840202     ----end----
    CALL t600_show_2()
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_cct.cct04
    DISPLAY BY NAME g_ima.ima25,g_ima.ima02
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01 = g_cct.cct01
    DISPLAY BY NAME g_sfb.sfb08
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t600_show_2()
    DISPLAY By NAME
        g_cct.cct22a, g_cct.cct22b, g_cct.cct22c, g_cct.cct22d, g_cct.cct22e, 
        g_cct.cct22f, g_cct.cct22g, g_cct.cct22h, g_cct.cct22,                  #FUN-7C0101
        g_cct.cct32a, g_cct.cct32b, g_cct.cct32c, g_cct.cct32d, g_cct.cct32e, 
        g_cct.cct32f, g_cct.cct32g, g_cct.cct32h, g_cct.cct32,                  #FUN-7C0101
        g_cct.cct42a, g_cct.cct42b, g_cct.cct42c, g_cct.cct42d, g_cct.cct42e, 
        g_cct.cct42f, g_cct.cct42g, g_cct.cct42h, g_cct.cct42,                  #FUN-7C0101
        g_cct.cct92a, g_cct.cct92b, g_cct.cct92c, g_cct.cct92d, g_cct.cct92e, 
        g_cct.cct92f, g_cct.cct92g, g_cct.cct92h, g_cct.cct92                   #FUN-7C0101
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t600_u()
    IF g_cct.cct01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cct01_t = g_cct.cct01
    LET g_cct02_t = g_cct.cct02
    LET g_cct03_t = g_cct.cct03
    LET g_cct06_t = g_cct.cct06  #FUN-7C0101
    LET g_cct07_t = g_cct.cct07  #FUN-7C0101
    BEGIN WORK
 
    OPEN t600_cl USING g_cct.cct01,g_cct.cct02,g_cct.cct03,g_cct.cct06,g_cct.cct07
    IF STATUS THEN
       CALL cl_err("OPEN t600_cl:", STATUS, 1)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t600_cl INTO g_cct.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t600_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t600_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cct.*=g_cct_t.*
            CALL t600_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cct_file SET cct_file.* = g_cct.*    # 更新DB
            WHERE cct01 = g_cct.cct01 AND cct02 = g_cct.cct02 AND cct03 = g_cct.cct03 AND cct06 = g_cct.cct06 AND cct07 = g_cct.cct07             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cct.cct01,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("upd","cct_file",g_cct01_t,g_cct02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t600_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t600_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("cct04,cct01,cct02,cct03,cct06,cct07",TRUE)
  END IF
END FUNCTION
 
FUNCTION t600_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("cct04,cct01,cct02,cct03,cct06,cct07",FALSE)
  END IF
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
