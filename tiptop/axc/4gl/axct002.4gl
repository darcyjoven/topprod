# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axct002.4gl
# Descriptions...: 入庫成本調整資料維護作業
# Date & Author..: 95/10/18 By Roger
# Modify.........: No:9581 04/05/19 By Melody 應以 USING '---,---,--&.&&' 才能印
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-4B0279 04/11/26 By Smapmin 料號開窗
# Modify.........: No.FUN-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-4C0099 05/01/10 By kim 報表轉XML功能
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.FUN-640066 06/04/09 By Sarah 執行新增時,料件編號的開窗請CALL q_ima
# Modify.........: No.MOD-640094 06/04/09 By Carol 執行新增時,料件編號的開窗請CALL q_ima
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/09/07 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780048 07/07/20 By dxfwo _out()轉p_query實現
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7C0101 08/03/03 By douzh 成本改善
# Modify.........: No.FUN-840202 08/04/29 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-910073 09/02/02 By jan 成本計算類別為"1or2"時,類別編號應noentry且自動給' '
# Modify.........: No.MOD-950013 09/05/20 By Pengu 選擇分倉成本時，應判斷imd09是否存在
# Modify.........: No.TQC-950110 09/06/02 By destiny 應將g_dbs賦給l_fromplant的而不是g_plant
# Modify.........: No.TQC-970246 09/07/23 By dxfwo  ccb01,ccb07的input開窗沒有給default1值
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-9C0073 10/01/12 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A80135 10/08/25 By xiaofeizhu 增加字段ccb23
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B70067 11/07/08 By Vampire (1) 處理ccb22a~ccb22e的程式段,都要再加上ccb22f,ccb22g,ccg22h等欄位
#                                                    (2) ccb22應等於g_ccb.ccb22a+g_ccb.ccb22b+g_ccb.ccb22c+g_ccb.ccb22d+g_ccb.ccb22e+g_ccb.ccb22f+g_ccb.ccb22g+g_ccb.ccb22h
# Modify.........: No:FUN-BB0038 11/11/14 By elva 成本改善
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No:MOD-C40034 12/04/05 By ck2yuan 增加控管，不可修改小於關帳日期的資料
# Modify.........: No:FUN-C70093 12/07/23 By minpp 删除判断ccbglno是否为空，若不为空不可删除
# Modify.........: No:MOD-D10099 13/01/17 By Bart 期別先call s_azm()再進行判斷
# Modify.........: No:MOD-D10247 13/01/29 By bart 1.在after field ccb01/ccb02/ccb03/ccb06/ccb07 加上與ccb04相同的檢核(-239)。
#                                                 2.年度期別控卡
# Modify.........: No:FUN-D60130 13/06/28 By fengrui 對axcp500產生的加工費用調整單做相應控管

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ccb               RECORD LIKE ccb_file.*,
    g_ccb_t             RECORD LIKE ccb_file.*,
    g_ccb01_t           LIKE ccb_file.ccb01,
    g_ccb02_t           LIKE ccb_file.ccb02,
    g_ccb03_t           LIKE ccb_file.ccb03,
    g_ccb04_t           LIKE ccb_file.ccb04,
    g_ccb06_t           LIKE ccb_file.ccb06,       #No.FUN-7C0101
    g_ccb07_t           LIKE ccb_file.ccb07,       #No.FUN-7C0101
    g_wc,g_sql          string,  #No.FUN-580092 HCN
    g_ima   RECORD LIKE ima_file.*
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03            #No.FUN-680122CHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE   l_cmd          LIKE type_file.chr1000       #No.FUN-780048
#FUN-BB0038 --begin
DEFINE   g_argv1        LIKE ccb_file.ccb01 
DEFINE   g_argv2        LIKE ccb_file.ccb02
DEFINE   g_argv3        LIKE ccb_file.ccb03
DEFINE   g_argv4        LIKE ccb_file.ccb04
DEFINE   g_argv5        LIKE ccb_file.ccb06
DEFINE   g_argv6        LIKE ccb_file.ccb07 
#FUN-BB0038 --end

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
 
 
   #FUN-BB0038 --BEGIN
   #LET p_row = ARG_VAL(1)
   #LET p_col = ARG_VAL(2)
    LET g_argv1 = ARG_VAL(1)  
    LET g_argv2 = ARG_VAL(2) 
    LET g_argv3 = ARG_VAL(3) 
    LET g_argv4 = ARG_VAL(4) 
    LET g_argv5 = ARG_VAL(5) 
    LET g_argv6 = ARG_VAL(6) 
   #FUN-BB0038 --END
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    INITIALIZE g_ccb.* TO NULL
    INITIALIZE g_ccb_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ccb_file WHERE ccb01 = ? AND ccb02 = ? AND ccb03 = ? AND ccb04 = ? AND ccb06 = ? AND ccb07 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t002_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 4 LET p_col = 14
    OPEN WINDOW t002_w AT p_row,p_col
        WITH FORM "axc/42f/axct002" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
      LET g_action_choice="" 
    #FUN-BB0038 --begin 
    #CALL t002_menu() 
     IF NOT cl_null(g_argv1) THEN
        LET g_action_choice = "query"
        IF cl_chk_act_auth() THEN
           CALL t002_q() 
        END IF
     END IF
     CALL t002_menu() 
    #FUN-BB0038 --end
 
    CLOSE WINDOW t002_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t002_cs()
DEFINE l_ccb06      LIKE ccb_file.ccb06           #No.FUN-7C0101
    CLEAR FORM
   INITIALIZE g_ccb.* TO NULL    #No.FUN-750051
    #FUN-BB0038 --begin
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " ccb01='",g_argv1,"' AND ccb02=",g_argv2," AND ccb03=",g_argv3,
                  " AND ccb04='",g_argv4,"' AND ccb06='",g_argv5,"' AND ccb07='",g_argv6,"'"     
    ELSE
    #FUN-BB0038 --end
       
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ccb01,ccb02,ccb03,ccb05,ccb04,ccb06,ccb07,       #No.FUN-7C0101
        ccb22a, ccb22b, ccb22c, ccb22d, ccb22e,ccb22f,ccb22g,ccb22h, ccb22,   #No.FUN-7C0101
        ccbuser,ccbgrup,ccbmodu,ccbdate,     #MOD-4B0279
        ccbud01,ccbud02,ccbud03,ccbud04,ccbud05,
        ccbud06,ccbud07,ccbud08,ccbud09,ccbud10,
        ccbud11,ccbud12,ccbud13,ccbud14,ccbud15
        ,ccb23,ccbglno                               #FUN-A80135 Add   #FUN-C70093 add--ccbglno
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       AFTER FIELD ccb06
           LET l_ccb06 = get_fldbuf(ccb06)
       ON ACTION CONTROLP
          IF INFIELD(ccb01) THEN
#FUN-AA0059---------mod------------str-----------------          
#             CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_ccb"
#             LET g_qryparam.state = 'c'
#             CALL cl_create_qry() RETURNING g_qryparam.multiret
             CALL q_sel_ima(TRUE, "q_ccb","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
             DISPLAY g_qryparam.multiret TO ccb01 
             NEXT FIELD ccb01
          END IF
              IF INFIELD(ccb07) THEN                                                                                                   
                 IF l_ccb06 MATCHES '[45]' THEN                                                                                     
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.state= "c"                                                                                       
                 CASE l_ccb06                                                                                                       
                    WHEN '4'                                                                                                        
                      LET g_qryparam.form = "q_pja"                                                                                 
                    WHEN '5'                                                                                                        
                      LET g_qryparam.form = "q_gem4"                                                                                
                    OTHERWISE EXIT CASE                                                                                             
                 END CASE                                                                                                           
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY  g_qryparam.multiret TO ccb07                                                                              
                 NEXT FIELD ccb07                                                                                                   
                 END IF     
              END IF                                                                                                        
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
    END IF  #FUN-BB0038
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ccbuser', 'ccbgrup') #FUN-980030
    LET g_sql="SELECT ccb01,ccb02,ccb03,ccb04,ccb06,ccb07 FROM ccb_file ",
        " WHERE ",g_wc CLIPPED, " ORDER BY ccb01,ccb02,ccb03,ccb04,ccb06,ccb07"
    PREPARE t002_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t002_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t002_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ccb_file WHERE ",g_wc CLIPPED
    PREPARE t002_precount FROM g_sql
    DECLARE t002_count CURSOR FOR t002_precount
END FUNCTION
 
FUNCTION t002_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#@      ON ACTION 撥入擷取
        ON ACTION retrieve_transfer_in
            LET g_action_choice="retrieve_transfer_in"
            IF cl_chk_act_auth() THEN
                 CALL t002_g()
            END IF
        ON ACTION insert 
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t002_a()
            END IF
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t002_q()
            END IF
        ON ACTION next 
            CALL t002_fetch('N') 
        ON ACTION previous 
            CALL t002_fetch('P')
        ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t002_u()
            END IF
        ON ACTION delete 
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t002_r()
            END IF
       ON ACTION output 
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
            IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF   
            LET l_cmd = 'p_query "axct002" "',g_wc CLIPPED,'"'                                                                          
            CALL cl_cmdrun(l_cmd)                                                                                                   
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
            CALL t002_fetch('/')
        ON ACTION first
            CALL t002_fetch('F')
        ON ACTION last
            CALL t002_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_ccb.ccb01 IS NOT NULL THEN
                  LET g_doc.column1 = "ccb01"
                  LET g_doc.value1 = g_ccb.ccb01
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
    CLOSE t002_cs
END FUNCTION
   
FUNCTION t002_g()
  DEFINE  l_cmd        LIKE type_file.chr1000,       #No.FUN-680122CHAR(600)
        tm RECORD
            yy         LIKE type_file.num5,          #No.FUN-680122SMALLINT
            mm         LIKE type_file.num5,          #No.FUN-680122SMALLINT   
            plant      LIKE azp_file.azp01
           END RECORD,
          l_correct    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)   
          l_fromplant  LIKE azp_file.azp03,
          l_bdate,l_edate LIKE type_file.dat,           #No.FUN-680122 DATE  
          l_ccb04      LIKE ccb_file.ccb04,
          l_ccb05      LIKE ccb_file.ccb05,
          l_ccb22      LIKE ccb_file.ccb22,
          l_price      LIKE ccb_file.ccb22,
        sr RECORD
           tlf01 LIKE tlf_file.tlf01,
           tlf10 LIKE tlf_file.tlf10,
           tlf026 LIKE tlf_file.tlf026,
           tlf027 LIKE tlf_file.tlf027,
           tlf036 LIKE tlf_file.tlf036,
           tlf037 LIKE tlf_file.tlf037
           END RECORD
  DEFINE l_plant LIKE type_file.chr10          #FUN-A50102
    OPEN WINDOW t002_g AT 4,27          #條件畫面
        WITH FORM "axc/42f/axct002_g"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axct002_g")
 
    CONSTRUCT BY NAME g_wc ON ima01,ima08  
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
    IF INT_FLAG THEN CLOSE WINDOW t002_g RETURN  END IF
    INPUT BY NAME tm.plant,tm.yy,tm.mm WITHOUT DEFAULTS 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
        AFTER INPUT 
           IF INT_FLAG THEN EXIT INPUT END IF
           #20131209 add by suncx sta-------
           IF NOT t002_chk(tm.yy,tm.mm) THEN
              CALL cl_err('','axc-809',1)
              NEXT FIELD ccb02
           END IF
           #20131209 add by suncx end-------
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
   IF INT_FLAG THEN  CLOSE WINDOW t002_g RETURN END IF
 
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_bdate, l_edate 
 
   SELECT azp03 INTO l_fromplant FROM azp_file WHERE azp01 =tm.plant  #FUN-A50102
   LET l_plant = tm.plant 
   IF cl_null(l_fromplant) THEN 
      #LET l_fromplant = g_dbs                   #FUN-A50102
      LET l_plant = g_plant                      #FUN-A50102
   END IF            #NO.TQC-950110 
   #LET l_fromplant = s_dbstring(l_fromplant)    #FUN-A50102                            
   LET l_cmd = "SELECT ccc23  ",
               #" FROM ",s_dbstring(l_fromplant CLIPPED),"ccc_file ",              #NO.TQC-950110
               " FROM ",cl_get_target_table(l_plant,'ccc_file'),  #FUN-A50102
               " WHERE  ccc01 =  ? ",
               "   AND  ccc02 = ",tm.yy,
               "   AND  ccc03 = ",tm.mm
    CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd              #FUN-A50102									
    CALL cl_parse_qry_sql(l_cmd,l_plant) RETURNING l_cmd      #FUN-A50102	
    PREPARE t002_preccc FROM l_cmd  
    DECLARE t002_cuccc             
        SCROLL CURSOR WITH HOLD FOR t002_preccc
 
   LET l_cmd = "SELECT tlf01,tlf10,tlf026,tlf027,tlf036,tlf037",
               "  FROM ima_file, tlf_file",
               "  WHERE tlf01 = ima01 ",
               "  AND  tlf13  = 'aimp701' ",
               "  AND (tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"')",
               "  AND ",g_wc CLIPPED
    PREPARE t002_pregen FROM l_cmd  
    DECLARE t002_cugen             
        SCROLL CURSOR WITH HOLD FOR t002_pregen
    FOREACH t002_cugen INTO  sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:t002_cugen',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        message sr.tlf01
        OPEN t002_cuccc USING sr.tlf01
        FETCH t002_cuccc INTO l_price
        IF SQLCA.sqlcode THEN LET l_price = 0 END IF
        LET l_ccb04 = sr.tlf036,'-',sr.tlf037 using '<<<<'
        LET l_ccb05 = sr.tlf026,'-',sr.tlf027 using '<<<<'
        LET l_ccb22 = sr.tlf10 * l_price
        DELETE FROM ccb_file WHERE ccb01 = sr.tlf01
                               AND ccb02 = tm.yy
                               AND ccb03 = tm.mm
                               AND ccb03 = tm.mm
                               AND ccb04 = l_ccb04
         INSERT INTO ccb_file(ccb01,ccb02,ccb03,ccb04,ccb05,  #No.MOD-470041
                             ccb22,ccb22a,ccb22b,ccb22c,ccb22d,ccb22e,
                            #ccbacti,ccbuser,ccbgrup,ccbmodu,ccbdate,ccbplant,ccblegal,ccboriu,ccborig)  #FUN-980009 add ccbplant,ccblegal 
                             ccbacti,ccbuser,ccbgrup,ccbmodu,ccbdate,ccblegal,ccboriu,ccborig,ccb23)  #FUN-A50075  #FUN-A80135 Add ccb23
                      VALUES(sr.tlf01,tm.yy,tm.mm,
                             l_ccb04,l_ccb05,l_ccb22,l_ccb22,
                            #0,0,0,0,'Y',g_user,g_grup,'',g_today,g_plant,g_legal, g_user, g_grup) #FUN-980009 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
                             0,0,0,0,'Y',g_user,g_grup,'',g_today,g_legal, g_user, g_grup,'1') #FUN-980009 add g_plant,g_legal      #No.FUN-A50075 #FUN-A80135 Add '1'
        IF SQLCA.sqlcode THEN 
           CALL cl_err3("ins","ccb_file",sr.tlf01,tm.yy,SQLCA.sqlcode,"","insert error",1)  #No.FUN-660127
        END IF
        CLOSE t002_cuccc 
    END FOREACH 
    CLOSE WINDOW t002_g
END FUNCTION
   
FUNCTION t002_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_ccb.* TO NULL
    #carrier 20130618  --Begin
    IF cl_null(g_ccb_t.ccb02) THEN
       LET g_ccb.ccb02=g_ccz.ccz01  
       LET g_ccb.ccb03=g_ccz.ccz02  
    ELSE
       LET g_ccb.ccb02=g_ccb_t.ccb02
       LET g_ccb.ccb03=g_ccb_t.ccb03
    END IF
    #carrier 20130618  --End  
#   LET g_ccb.ccb04=g_ccb_t.ccb04                ##FUN-A80135 Mark
    LET g_ccb.ccb06=g_ccb_t.ccb06                #No.FUN-7C0101  
    LET g_ccb.ccb07=g_ccb_t.ccb07                #No.FUN-7C0101
    LET g_ccb.ccb22=0
    LET g_ccb.ccb22a=0 LET g_ccb.ccb22b=0 LET g_ccb.ccb22c=0
    LET g_ccb.ccb22d=0 LET g_ccb.ccb22e=0
    LET g_ccb.ccb22f=0 LET g_ccb.ccb22g=0 LET g_ccb.ccb22h=0   #No.FUN-7C0101
    LET g_ccb.ccb23='1'                                        #FUN-A80135 Add
    LET g_ccb01_t = NULL
    LET g_ccb02_t = NULL
    LET g_ccb03_t = NULL
    LET g_ccb04_t = NULL
    LET g_ccb06_t = NULL                         #No.FUN-7C0101
    LET g_ccb07_t = NULL                         #No.FUN-7C0101
    LET g_ccb_t.*=g_ccb.*
    CALL cl_opmsg('a')
    WHILE TRUE

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          EXIT WHILE
       END IF
#FUN-BC0062 --end--

        LET g_ccb.ccb06 = g_ccz.ccz28            #No.FUN-7C0101
        LET g_ccb.ccb07 = ' '                    #No.FUN-7C0101
	LET g_ccb.ccbacti ='Y'                   #有效的資料
	LET g_ccb.ccbuser = g_user
	LET g_ccb.ccboriu = g_user #FUN-980030
	LET g_ccb.ccborig = g_grup #FUN-980030
	LET g_data_plant = g_plant #FUN-980030
	LET g_ccb.ccbgrup = g_grup               #使用者所屬群
	LET g_ccb.ccbdate = g_today
        #LET g_ccb.ccbplant= g_plant  #FUN-980009 add    #FUN-A50075
	LET g_ccb.ccblegal= g_legal  #FUN-980009 add
        CALL t002_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_ccb.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ccb.ccb01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_ccb.ccb04 IS NULL THEN LET g_ccb.ccb04 = ' ' END IF
        INSERT INTO ccb_file VALUES(g_ccb.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ccb_file",g_ccb.ccb01,g_ccb.ccb02,SQLCA.sqlcode,"","ins ccb:",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            LET g_ccb_t.* = g_ccb.*                # 保存上筆資料
            SELECT ccb01,ccb02,ccb03,ccb04,ccb06,ccb07 INTO g_ccb.ccb01,g_ccb.ccb02,g_ccb.ccb03,g_ccb.ccb04,g_ccb.ccb06,g_ccb.ccb07 FROM ccb_file
                WHERE ccb01 = g_ccb.ccb01 AND ccb02 = g_ccb.ccb02
                  AND ccb03 = g_ccb.ccb03 AND ccb04 = g_ccb.ccb04
                  AND ccb06 = g_ccb.ccb06 AND ccb07 = g_ccb.ccb07           #No.FUN-7C0101         
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t002_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5           #No.FUN-680122 SMALLINT
    DEFINE l_pja01      LIKE pja_file.pja01           #No.FUN-7C0101
    DEFINE l_imd09      LIKE imd_file.imd09           #No.MOD-950013 add
    DEFINE l_gem01      LIKE gem_file.gem01           #No.FUN-7C0101
    DEFINE l_azm02      LIKE azm_file.azm02           #MOD-D10247
 
    INPUT BY NAME g_ccb.ccboriu,g_ccb.ccborig,
        g_ccb.ccb01,g_ccb.ccb02,g_ccb.ccb03,g_ccb.ccb06,g_ccb.ccb07,g_ccb.ccb05,g_ccb.ccb04,     #No.FUN-7C0101
        g_ccb.ccb22a, g_ccb.ccb22b, g_ccb.ccb22c, g_ccb.ccb22d, g_ccb.ccb22e,
        g_ccb.ccb22f,g_ccb.ccb22g,g_ccb.ccb22h,                                                  #No.FUN-7C0101
        g_ccb.ccb22,
        g_ccb.ccbuser,g_ccb.ccbgrup,g_ccb.ccbmodu,g_ccb.ccbdate,
        g_ccb.ccbud01,g_ccb.ccbud02,g_ccb.ccbud03,g_ccb.ccbud04,
        g_ccb.ccbud05,g_ccb.ccbud06,g_ccb.ccbud07,g_ccb.ccbud08,
        g_ccb.ccbud09,g_ccb.ccbud10,g_ccb.ccbud11,g_ccb.ccbud12,
        g_ccb.ccbud13,g_ccb.ccbud14,g_ccb.ccbud15
        ,g_ccb.ccb23                                                                              #FUN-A80135 Add
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t002_set_entry(p_cmd)
          CALL t002_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("ccb04")
 
 
        AFTER FIELD ccb01
            #FUN-AA0059 ----------------------------add start---------------------------
            IF NOT cl_null(g_ccb.ccb01) THEN
               IF NOT s_chk_item_no(g_ccb.ccb01,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD ccb01
               END IF 
               #MOD-D10247---begin
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND 
                  (g_ccb.ccb01 != g_ccb01_t OR g_ccb.ccb02 != g_ccb02_t OR
                   g_ccb.ccb03 != g_ccb03_t OR g_ccb.ccb06 != g_ccb06_t OR               
                   g_ccb.ccb07 != g_ccb07_t OR g_ccb.ccb04 != g_ccb04_t)) THEN         
                   SELECT count(*) INTO l_n FROM ccb_file
                   WHERE ccb01 = g_ccb.ccb01 AND ccb02 = g_ccb.ccb02
                     AND ccb03 = g_ccb.ccb03 AND ccb04 = g_ccb.ccb04
                     AND ccb06 = g_ccb.ccb06 AND ccb07 = g_ccb.ccb07                     
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err('count:',-239,0)
                       NEXT FIELD ccb01
                   END IF
               END IF
               #MOD-D10247---end
            END IF 
            #FUN-AA0059 -------------------------------add end-------------------------
            IF g_ccb.ccb01 IS NOT NULL OR g_ccb01_t <> g_ccb.ccb01 THEN   #No.TQC-970246 
               SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccb.ccb01
               IF STATUS THEN
                  CALL cl_err3("sel","ima_file",g_ccb.ccb01,"",STATUS,"","sel ima:",1)  #No.FUN-660127
                  NEXT FIELD ccb01
               END IF
               DISPLAY BY NAME g_ima.ima02,g_ima.ima25
            END IF
        #MOD-D10247---begin
        AFTER FIELD ccb02
          IF g_ccb.ccb02 IS NOT NULL THEN 
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND 
               (g_ccb.ccb01 != g_ccb01_t OR g_ccb.ccb02 != g_ccb02_t OR
                g_ccb.ccb03 != g_ccb03_t OR g_ccb.ccb06 != g_ccb06_t OR             
                g_ccb.ccb07 != g_ccb07_t OR g_ccb.ccb04 != g_ccb04_t)) THEN           
                SELECT count(*) INTO l_n FROM ccb_file
                WHERE ccb01 = g_ccb.ccb01 AND ccb02 = g_ccb.ccb02
                  AND ccb03 = g_ccb.ccb03 AND ccb04 = g_ccb.ccb04
                  AND ccb06 = g_ccb.ccb06 AND ccb07 = g_ccb.ccb07                    
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD ccb02
                END IF
            END IF
            IF NOT cl_null(g_ccb.ccb03) THEN 
               SELECT azm02 INTO l_azm02
                 FROM azm_file
                WHERE azm01 = g_ccb.ccb02
               IF l_azm02 = 1 THEN 
                  IF g_ccb.ccb03 < 1 OR g_ccb.ccb03 > 12 THEN
                     CALL cl_err(g_ccb.ccb02,'mfg9287',0)
                     NEXT FIELD ccb03
                  END IF 
               END IF 
               IF l_azm02 = 2 THEN 
                  IF g_ccb.ccb03 < 1 OR g_ccb.ccb03 > 13 THEN
                     CALL cl_err(g_ccb.ccb02,'mfg9288',0)
                     NEXT FIELD ccb03
                  END IF 
               END IF 
            END IF 
          END IF
          
        AFTER FIELD ccb03
          IF g_ccb.ccb03 IS NOT NULL THEN 
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND 
               (g_ccb.ccb01 != g_ccb01_t OR g_ccb.ccb02 != g_ccb02_t OR
                g_ccb.ccb03 != g_ccb03_t OR g_ccb.ccb06 != g_ccb06_t OR             
                g_ccb.ccb07 != g_ccb07_t OR g_ccb.ccb04 != g_ccb04_t)) THEN           
                SELECT count(*) INTO l_n FROM ccb_file
                WHERE ccb01 = g_ccb.ccb01 AND ccb02 = g_ccb.ccb02
                  AND ccb03 = g_ccb.ccb03 AND ccb04 = g_ccb.ccb04
                  AND ccb06 = g_ccb.ccb06 AND ccb07 = g_ccb.ccb07                    
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD ccb03
                END IF
            END IF
            IF NOT cl_null(g_ccb.ccb02) THEN 
               SELECT azm02 INTO l_azm02
                 FROM azm_file
                WHERE azm01 = g_ccb.ccb02
               IF l_azm02 = 1 THEN 
                  IF g_ccb.ccb03 < 1 OR g_ccb.ccb03 > 12 THEN
                     CALL cl_err(g_ccb.ccb02,'mfg9287',0)
                     NEXT FIELD ccb03
                  END IF 
               END IF 
               IF l_azm02 = 2 THEN 
                  IF g_ccb.ccb03 < 1 OR g_ccb.ccb03 > 13 THEN
                     CALL cl_err(g_ccb.ccb02,'mfg9288',0)
                     NEXT FIELD ccb03
                  END IF 
               END IF 
            END IF 
          END IF
             
        #MOD-D10247---end
        AFTER FIELD ccb06
          IF g_ccb.ccb06 IS NOT NULL THEN
            IF g_ccb.ccb06 NOT MATCHES '[12345]' THEN
               NEXT FIELD ccb06
            END IF
            IF g_ccb.ccb06 MATCHES'[12]' THEN
               CALL cl_set_comp_entry("ccb07",FALSE)
               LET g_ccb.ccb07 = ' '
            ELSE
               CALL cl_set_comp_entry("ccb07",TRUE)
            END IF
            #MOD-D10247---begin
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND 
               (g_ccb.ccb01 != g_ccb01_t OR g_ccb.ccb02 != g_ccb02_t OR
                g_ccb.ccb03 != g_ccb03_t OR g_ccb.ccb06 != g_ccb06_t OR               
                g_ccb.ccb07 != g_ccb07_t OR g_ccb.ccb04 != g_ccb04_t)) THEN         
                SELECT count(*) INTO l_n FROM ccb_file
                WHERE ccb01 = g_ccb.ccb01 AND ccb02 = g_ccb.ccb02
                  AND ccb03 = g_ccb.ccb03 AND ccb04 = g_ccb.ccb04
                  AND ccb06 = g_ccb.ccb06 AND ccb07 = g_ccb.ccb07                     
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD ccb01
                END IF
             END IF
             #MOD-D10247---end
          END IF
          
        AFTER FIELD ccb07
            IF NOT cl_null(g_ccb.ccb07) OR g_ccb.ccb07 != ' '  THEN
               IF g_ccb.ccb06='4'THEN
                  SELECT pja01 INTO l_pja01 FROM pja_file WHERE pja01=g_ccb.ccb07
                                             AND pjaclose='N'     #FUN-960038
                  IF STATUS THEN
                     CALL cl_err3("sel","pja_file",g_ccb.ccb07,"",STATUS,"","sel pja:",1)
                     NEXT FIELD ccb07
                  END IF
               END IF
               IF g_ccb.ccb06='5'THEN
                  SELECT UNIQUE imd09 INTO l_imd09 FROM imd_file WHERE imd09=g_ccb.ccb07
                  IF STATUS THEN
                     CALL cl_err3("sel","imd_file",g_ccb.ccb07,"",STATUS,"","sel imd:",1)     #No.MOD-950013 add
                     NEXT FIELD ccb07
                  END IF
               END IF
               #MOD-D10247---begin
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND 
                  (g_ccb.ccb01 != g_ccb01_t OR g_ccb.ccb02 != g_ccb02_t OR
                   g_ccb.ccb03 != g_ccb03_t OR g_ccb.ccb06 != g_ccb06_t OR               
                   g_ccb.ccb07 != g_ccb07_t OR g_ccb.ccb04 != g_ccb04_t)) THEN         
                   SELECT count(*) INTO l_n FROM ccb_file
                   WHERE ccb01 = g_ccb.ccb01 AND ccb02 = g_ccb.ccb02
                     AND ccb03 = g_ccb.ccb03 AND ccb04 = g_ccb.ccb04
                     AND ccb06 = g_ccb.ccb06 AND ccb07 = g_ccb.ccb07                     
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err('count:',-239,0)
                       NEXT FIELD ccb07
                   END IF
               END IF
               #MOD-D10247---end
            ELSE 
               LET g_ccb.ccb07 = ' '
            END IF
 
        AFTER FIELD ccb04
          #yemy 20130517  --Begin
          IF cl_null(g_ccb.ccb04) THEN LET g_ccb.ccb04 = ' ' END IF
          #yemy 20130517  --End  
          IF g_ccb.ccb04 IS NOT NULL THEN 
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND 
               (g_ccb.ccb01 != g_ccb01_t OR g_ccb.ccb02 != g_ccb02_t OR
                g_ccb.ccb03 != g_ccb03_t OR g_ccb.ccb06 != g_ccb06_t OR               #No.FUN-7C0101
                g_ccb.ccb07 != g_ccb07_t OR g_ccb.ccb04 != g_ccb04_t)) THEN           #No.FUN-7C0101 
                SELECT count(*) INTO l_n FROM ccb_file
                WHERE ccb01 = g_ccb.ccb01 AND ccb02 = g_ccb.ccb02
                  AND ccb03 = g_ccb.ccb03 AND ccb04 = g_ccb.ccb04
                  AND ccb06 = g_ccb.ccb06 AND ccb07 = g_ccb.ccb07                     #No.FUN-7C0101
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD ccb01
                END IF
            END IF
          END IF
 
       #AFTER FIELD ccb22a,ccb22b,ccb22c,ccb22d,ccb22e                        #MOD-B70067 mark
        AFTER FIELD ccb22a,ccb22b,ccb22c,ccb22d,ccb22e,ccb22f,ccb22g,ccb22h   #MOD-B70067 add
            CALL t002_u_cost()
 
        AFTER FIELD ccbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_ccb.ccbuser = s_get_data_owner("ccb_file") #FUN-C10039
           LET g_ccb.ccbgrup = s_get_data_group("ccb_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT  
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ccb01
            END IF
            #20131209 add by suncx sta-------
            IF NOT t002_chk(g_ccb.ccb02,g_ccb.ccb03) THEN
               CALL cl_err('','axc-809',1)
               NEXT FIELD ccb02
            END IF
            #20131209 add by suncx end-------
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(ccb01) 
#FUN-AA0059---------mod------------str-----------------           
#                CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"   #FUN-640066 MOD-640094
#                 LET g_qryparam.state = 'i'
#                 LET g_qryparam.default1 = g_ccb.ccb01   #No.TQC-970246 
#                 CALL cl_create_qry() RETURNING g_ccb.ccb01 
                 CALL q_sel_ima(FALSE, "q_ima","",g_ccb.ccb01,"","","","","",'' ) 
                  RETURNING  g_ccb.ccb01

#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_ccb.ccb01
                 NEXT FIELD ccb01
               WHEN INFIELD(ccb07)                                               
                 IF g_ccb.ccb06 MATCHES '[45]' THEN                             
                    CALL cl_init_qry_var()       
                 CASE g_ccb.ccb06                                               
                    WHEN '4'                                                    
                      LET g_qryparam.form = "q_pja"                             
                    WHEN '5'                                                    
                      LET g_qryparam.form = "q_gem4"                            
                    OTHERWISE EXIT CASE                                         
                 END CASE                                                       
                 LET g_qryparam.default1 = g_ccb.ccb07   #No.TQC-970246
                 CALL cl_create_qry() RETURNING g_ccb.ccb07                     
                 DISPLAY BY NAME  g_ccb.ccb07                                   
                 NEXT FIELD ccb07                                               
                 END IF                                                         
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
 
FUNCTION t002_u_cost()
    LET g_ccb.ccb22=g_ccb.ccb22a+g_ccb.ccb22b+g_ccb.ccb22c+
                    g_ccb.ccb22d+g_ccb.ccb22e+                       #MOD-B70067 add +
                    g_ccb.ccb22f+g_ccb.ccb22g+g_ccb.ccb22h           #MOD-B70067 add
    DISPLAY BY NAME g_ccb.ccb22
END FUNCTION
 
FUNCTION t002_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ccb.* TO NULL              #No.FUN-6A0019
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL t002_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t002_count
    FETCH t002_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN t002_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open t002_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_ccb.* TO NULL
    ELSE
        CALL t002_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t002_fetch(p_flccb)
    DEFINE
        p_flccb          LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)  
 
    CASE p_flccb
        WHEN 'N' FETCH NEXT     t002_cs INTO g_ccb.ccb01,g_ccb.ccb02,g_ccb.ccb03,g_ccb.ccb04,g_ccb.ccb06,g_ccb.ccb07
        WHEN 'P' FETCH PREVIOUS t002_cs INTO g_ccb.ccb01,g_ccb.ccb02,g_ccb.ccb03,g_ccb.ccb04,g_ccb.ccb06,g_ccb.ccb07
        WHEN 'F' FETCH FIRST    t002_cs INTO g_ccb.ccb01,g_ccb.ccb02,g_ccb.ccb03,g_ccb.ccb04,g_ccb.ccb06,g_ccb.ccb07
        WHEN 'L' FETCH LAST     t002_cs INTO g_ccb.ccb01,g_ccb.ccb02,g_ccb.ccb03,g_ccb.ccb04,g_ccb.ccb06,g_ccb.ccb07
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
            FETCH ABSOLUTE g_jump t002_cs INTO g_ccb.ccb01,g_ccb.ccb02,g_ccb.ccb03,g_ccb.ccb04,g_ccb.ccb06,g_ccb.ccb07
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccb.ccb01,SQLCA.sqlcode,0)
        INITIALIZE g_ccb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flccb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ccb.* FROM ccb_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ccb01 = g_ccb.ccb01 AND ccb02 = g_ccb.ccb02 AND ccb03 = g_ccb.ccb03 AND ccb04 = g_ccb.ccb04 AND ccb06 = g_ccb.ccb06 AND ccb07 = g_ccb.ccb07 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ccb_file",g_ccb.ccb01,g_ccb.ccb02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE                                     #FUN-4C0061權限控管
       LET g_data_owner = g_ccb.ccbuser
       LET g_data_group = g_ccb.ccbgrup
      #LET g_data_plant = g_ccb.ccbplant #FUN-980030   #FUN-A50075
       LET g_data_plant = g_plant        #FUN-A50075
        CALL t002_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t002_show()
    LET g_ccb_t.* = g_ccb.*
    DISPLAY BY NAME g_ccb.ccboriu,g_ccb.ccborig,
        g_ccb.ccb01,g_ccb.ccb02,g_ccb.ccb03,g_ccb.ccb06,g_ccb.ccb07,g_ccb.ccb04,g_ccb.ccb05,    #No.FUN-7C0101
        g_ccb.ccb22a, g_ccb.ccb22b, g_ccb.ccb22c, g_ccb.ccb22d, g_ccb.ccb22e,
        g_ccb.ccb22f, g_ccb.ccb22g, g_ccb.ccb22h,                                               #No.FUN-7C0101 
        g_ccb.ccb22, 
        g_ccb.ccbuser,g_ccb.ccbgrup,g_ccb.ccbmodu,g_ccb.ccbdate, 
        g_ccb.ccbud01,g_ccb.ccbud02,g_ccb.ccbud03,g_ccb.ccbud04,
        g_ccb.ccbud05,g_ccb.ccbud06,g_ccb.ccbud07,g_ccb.ccbud08,
        g_ccb.ccbud09,g_ccb.ccbud10,g_ccb.ccbud11,g_ccb.ccbud12,
        g_ccb.ccbud13,g_ccb.ccbud14,g_ccb.ccbud15
        ,g_ccb.ccb23 ,g_ccb.ccbglno                #FUN-A80135 Add   #FUN-C70093 add--ccbglno
 
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ccb.ccb01
    DISPLAY BY NAME g_ima.ima25,g_ima.ima02
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t002_u()
    DEFINE l_date  LIKE sma_file.sma53  #MOD-C40034 add
    DEFINE l_chr   LIKE type_file.chr1,  #MOD-D10099
           l_bdate  LIKE sma_file.sma53, #MOD-D10099
           l_edate  LIKE sma_file.sma53  #MOD-D10099
           
    IF g_ccb.ccb23 = '4' THEN CALL cl_err('','axc-808',1) RETURN END IF  #FUN-D60130 add
    IF g_ccb.ccb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

    #MOD-C40034 str add-----
     SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
     #LET l_date = MDY(g_ccb.ccb03,1,g_ccb.ccb02)  #MOD-D10099
     CALL s_azm(g_ccb.ccb02,g_ccb.ccb03) RETURNING l_chr,l_bdate,l_edate  #MOD-D10099
     #CALL s_last(l_date) RETURNING l_date  #MOD-D10099
     #IF l_date <= g_sma.sma53 THEN  #MOD-D10099
     IF l_edate <= g_sma.sma53 THEN  #MOD-D10099
        CALL cl_err('','axc-087',1)
        RETURN
     END IF
    #MOD-C40034 end add-----

    #20131209 add by suncx sta-------
    IF NOT t002_chk(g_ccb.ccb02,g_ccb.ccb03) THEN
       CALL cl_err('','axc-809',1)
       RETURN
    END IF
    #20131209 add by suncx end-------

    #FUN-A80135--Add--Begin
    IF g_ccb.ccb23 = '2' OR g_ccb.ccb23 = '3' THEN     #FUN-C70093-ADD--ccb23 = '3'
       CALL cl_err('','axc-919','1')
       RETURN
    END IF    
    #FUN-A80135--Add--End
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ccb01_t = g_ccb.ccb01
    LET g_ccb02_t = g_ccb.ccb02
    LET g_ccb03_t = g_ccb.ccb03
    LET g_ccb06_t = g_ccb.ccb06              #No.FUN-7C0101
    LET g_ccb07_t = g_ccb.ccb07              #No.FUN-7C0101
    LET g_ccb04_t = g_ccb.ccb04
    BEGIN WORK
 
    OPEN t002_cl USING g_ccb.ccb01,g_ccb.ccb02,g_ccb.ccb03,g_ccb.ccb04,g_ccb.ccb06,g_ccb.ccb07
    IF STATUS THEN
       CALL cl_err("OPEN t002_cl:", STATUS, 1)
       CLOSE t002_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t002_cl INTO g_ccb.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
     IF cl_null(g_ccb.ccbacti) THEN LET g_ccb.ccbacti ='Y' END IF 
     IF cl_null(g_ccb.ccbuser) THEN LET g_ccb.ccbuser = g_user END IF 
     IF cl_null(g_ccb.ccbgrup) THEN LET g_ccb.ccbgrup = g_grup END IF  
	LET g_ccb.ccbmodu=g_user                     #修改者
	LET g_ccb.ccbdate = g_today                  #修改日期
    CALL t002_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t002_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ccb.*=g_ccb_t.*
            CALL t002_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ccb.ccb04 IS NULL THEN LET g_ccb.ccb04 = ' ' END IF
        UPDATE ccb_file SET ccb_file.* = g_ccb.*    # 更新DB
            WHERE ccb01 = g_ccb_t.ccb01 AND ccb02 = g_ccb_t.ccb02 AND ccb03 = g_ccb_t.ccb03 AND ccb04 = g_ccb_t.ccb04 AND ccb06 = g_ccb_t.ccb06 AND ccb07 = g_ccb_t.ccb07
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ccb_file",g_ccb01_t,g_ccb02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t002_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t002_r()
    DEFINE l_date  LIKE sma_file.sma53  #MOD-C40034 add
    DEFINE l_chr   LIKE type_file.chr1,  #MOD-D10099
           l_bdate  LIKE sma_file.sma53, #MOD-D10099
           l_edate  LIKE sma_file.sma53  #MOD-D10099
           
    IF g_ccb.ccb23 = '4' THEN CALL cl_err('','axc-808',1) RETURN END IF  #FUN-D60130 add
    IF g_ccb.ccb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    #FUN-C70093--ADD--STR
    IF NOT cl_null(g_ccb.ccbglno) THEN
       CALL cl_err('','afa-973',1)
       RETURN
    END IF
    #FUN-C70093--ADD--END


    #MOD-C40034 str add-----
     SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
     #LET l_date = MDY(g_ccb.ccb03,1,g_ccb.ccb02)  #MOD-D10099
     #CALL s_last(l_date) RETURNING l_date  #MOD-D10099
     #IF l_date <= g_sma.sma53 THEN  #MOD-D10099
     CALL s_azm(g_ccb.ccb02,g_ccb.ccb03) RETURNING l_chr,l_bdate,l_edate  #MOD-D10099
     IF l_edate <= g_sma.sma53 THEN  #MOD-D10099
        CALL cl_err('','axc-087',1)
        RETURN
     END IF
    #MOD-C40034 end add-----    

    #20131209 add by suncx sta-------
    IF NOT t002_chk(g_ccb.ccb02,g_ccb.ccb03) THEN
       CALL cl_err('','axc-809',1)
       RETURN
    END IF
    #20131209 add by suncx end-------

    #FUN-A80135--Add--Begin
    IF g_ccb.ccb23 = '2' OR g_ccb.ccb23 = '3' THEN     #FUN-C70093-ADD--ccb23=3
       CALL cl_err('','axc-919','1')
       RETURN
    END IF    
    #FUN-A80135--Add--End    
    
    BEGIN WORK
 
    OPEN t002_cl USING g_ccb.ccb01,g_ccb.ccb02,g_ccb.ccb03,g_ccb.ccb04,g_ccb.ccb06,g_ccb.ccb07
    IF STATUS THEN
       CALL cl_err("OPEN t002_cl:", STATUS, 1)
       CLOSE t002_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t002_cl INTO g_ccb.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ccb.ccb01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t002_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ccb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ccb.ccb01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ccb_file
                WHERE ccb01 = g_ccb.ccb01 AND ccb02 = g_ccb.ccb02
                  AND ccb03 = g_ccb.ccb03 AND ccb04 = g_ccb.ccb04
                  AND ccb06 = g_ccb.ccb06 AND ccb07 = g_ccb.ccb07         #No.FUN-7C0101
       CLEAR FORM
       OPEN t002_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t002_cs
          CLOSE t002_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t002_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t002_cs
          CLOSE t002_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t002_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t002_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t002_fetch('/')
       END IF
    END IF
    CLOSE t002_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t002_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ccb01,ccb02,ccb03,ccb06,ccb07,ccb04",TRUE)               #No.FUN-7C0101
  END IF
END FUNCTION
 
FUNCTION t002_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
  IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
     (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ccb01,ccb02,ccb03,ccb06,ccb07,ccb04",FALSE)               #No.FUN-7C0101 
  END IF
  IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND 
     (NOT g_before_input_done) THEN
     IF g_ccb.ccb06 MATCHES'[12]' THEN
        CALL cl_set_comp_entry("ccb07",FALSE)
     ELSE
        CALL cl_set_comp_entry("ccb07",TRUE)
     END IF
  END IF
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/12 

#20131209 add by suncx begin--------------------------------
FUNCTION t002_chk(p_yy,p_mm)
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
