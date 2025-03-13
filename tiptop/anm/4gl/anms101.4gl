# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anms101.4gl
# Descriptions...: 票據管理系統參數(一)設定作業-連線參數
# Date & Author..: 92/02/17 By MAY
# Modify.........: No.MOD-470168 04/07/22 Kammy 補 nmz52 欄位
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0163 04/10/12 By Nicola 異動碼設定必須檢核存提別
# Modify.........: NO.FUN-550057 05/05/27 By jackie 單據編號加大
# Modify.........: No.FUN-5A0197 05/11/08 By Smampin 取消nmz53整批轉帳付款預設支出異動碼這一個參數
# Modify.........: NO.FUN-5B0134 05/11/25 BY yiting  modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.TQC-640148 06/04/20 By Smapmin 隱藏nmz41,nmz42
# Modify.........: No.MOD-660060 06/06/15 By Smapmin 隱藏nmz40
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳別權限修改
# Modify.........: No.FUN-680034 06/08/17 By flowld 兩套帳修改及alter table --ANM模塊,前端基礎數據,融資
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-740032 07/04/12 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.TQC-790077 07/09/18 By Carrier 天數,比率非負控制
# Modify.........: No.MOD-870157 08/07/17 By xiaofeizhu 去掉有關nmz03的處理
# Modify.........: No.FUN-840015 08/09/04 By xiaofeizhu 增加欄位nmz53
# Modify.........: No.MOD-8B0154 08/11/14 By chenyu nmz31,nmz32,nmz33,nmz34開窗和AFTER FIELD處理不一樣
# Modify.........: No.MOD-930025 09/03/03 By chenl  銀行核算項應根據匯盈和匯差來限定核算項存提別.
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-990031 09/10/21 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下 
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No:MOD-9C0386 09/12/24 By sherry 刪除nmz51/nmz55時又會自動跳出原值.
# Modify.........: No:TQC-A70005 10/07/01 By xiaofeizhu nmz54处mfg3045改为aap-917 
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B10052 11/01/24 By lilingyu 科目查詢自動過濾
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
# Modify.........: No:MOD-B40073 11/04/11 By Sarah nmz35開窗應只有nmc03='1'的資料,nmz53開窗應只有nmc03='2'的資料
# Modify.........: No:FUN-B40056 11/04/26 By guoch 設置現金流量表來源的參數
# Modify.........: No:FUN-B60069 11/06/10 By guoch mark設置現金流量表來源的參數
# Modify.........: No.FUN-B50039 11/07/07 By fengrui 增加自定義欄位
# Modify.........: No.FUN-BC0110 11/12/29 By SunLM 增加nmz71(現金流量表功能),nmz72(現金變動碼錄入控制)兩個參數控制
# Modify.........: No.FUN-D80115 13/08/29 By yangtt 票据參數里加個重評价默認現金异動碼(nmz73)，gnmp600產生分錄的時候，帶出默認值

DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_nmz_t         RECORD LIKE nmz_file.*,  # 預留參數檔
        g_nmz_o         RECORD LIKE nmz_file.*   # 預留參數檔
    DEFINE g_forupd_sql STRING
 
DEFINE  t_dbss          LIKE azp_file.azp03      #No.FUN-740032
DEFINE  g_bookno1       LIKE aza_file.aza81      #No.FUN-740032
DEFINE  g_bookno2       LIKE aza_file.aza82      #No.FUN-740032
DEFINE  g_flag          LIKE type_file.chr1      #No.FUN-740032
 
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
    LET g_nmz.nmz00='0' INSERT INTO nmz_file VALUES(g_nmz.*) #No.MOD-480421
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   CALL s101(4,12)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN  
 
FUNCTION s101(p_row,p_col)
    DEFINE
        p_row,p_col LIKE type_file.num5     #No.FUN-680107 SMALLINT
#       l_time        LIKE type_file.chr8          #No.FUN-6A0082
 
 
    LET p_row = 4 LET p_col = 12
    OPEN WINDOW s101_w AT p_row,p_col
        WITH FORM "anm/42f/anms101" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_comp_visible("nmz03",FALSE)    #No.MOD-870157
# No.FUN-680034 --start--
    CALL cl_set_comp_visible("nmz02c,nmz581", g_aza.aza63 = "Y")
# No.FUN-680034 ---end---
    CALL s101_show()
    WHILE TRUE
      LET g_action_choice = "" 
      CALL s101_menu()
      IF g_action_choice = "exit" THEN 
         EXIT WHILE 
      END IF 
    END WHILE 
    CLOSE WINDOW s101_w
 
END FUNCTION
 
FUNCTION s101_show()
 
    SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00 = '0'
 
    IF SQLCA.sqlcode OR g_nmz.nmz01 IS NULL THEN
        LET g_nmz.nmz01 = "N"
        LET g_nmz.nmz02 = "N"
        LET g_nmz.nmz02p = g_plant
        LET g_nmz.nmz05  = "Y" 
        LET g_nmz.nmz06  = "Y" 
        LET g_nmz.nmz09  = "2" 
        LET g_nmz.nmz11 = "Y"
        LET g_nmz.nmz07 = "Y"
        LET g_nmz.nmz08 = "Y"
        IF SQLCA.sqlcode THEN
           INSERT INTO nmz_file VALUES (g_nmz.*) 
        ELSE
           UPDATE nmz_file SET * = g_nmz.* 
            WHERE nmz00 = '0'
        END IF
        IF SQLCA.sqlcode THEN
#          CALL cl_err('',SQLCA.sqlcode,0) #FUN-660148
           CALL cl_err3("sel","nmz_file","","",SQLCA.sqlcode,"","",0) #FUN-660148
           RETURN
        END IF
    END IF
#  FUN-BC0110  BEGIN
     IF g_nmz.nmz71='Y' THEN 
              CALL cl_set_comp_visible("dummy01,dummy02,nmz70,nmz72",TRUE) 
                    ELSE 
              CALL cl_set_comp_visible("dummy01,dummy02,nmz70,nmz72",FALSE)
    END IF  
#  FUN-BC0110  END    
   #FUN-D80115---add---str--
    IF g_nmz.nmz71 = 'Y' AND g_nmz.nmz70 = '3' THEN
       CALL cl_set_comp_visible("nmz73",TRUE)
    ELSE
       CALL cl_set_comp_visible("nmz73",FALSE)
    END IF
   #FUN-D80115---add---end--
    DISPLAY BY NAME g_nmz.nmz01,g_nmz.nmz02,g_nmz.nmz02p,
                    g_nmz.nmz02b,g_nmz.nmz02c,                # No.FUN-680034  add g_nmz.nmz02c
                    g_nmz.nmz11,g_nmz.nmz05,g_nmz.nmz06,
                   #g_nmz.nmz10, g_nmz.nmz41, g_nmz.nmz42, g_nmz.nmz04,    #TQC-640148
                    g_nmz.nmz10, g_nmz.nmz04,    #TQC-640148
#                   g_nmz.nmz03, g_nmz.nmz08, g_nmz.nmz07,                 #MOD-870157
                    g_nmz.nmz08, g_nmz.nmz07,                              #MOD-870157 
                     g_nmz.nmz52, g_nmz.nmz51,             #No.MOD-470168
#                    g_nmz.nmz55, g_nmz.nmz53, g_nmz.nmz54, g_nmz.nmz40,   #FUN-5A0197
                    #g_nmz.nmz55, g_nmz.nmz54, g_nmz.nmz40,   #FUN-5A0197   #MOD-660060
                    g_nmz.nmz55, g_nmz.nmz54,  #MOD-660060
                    g_nmz.nmz56, g_nmz.nmz57, g_nmz.nmz58,g_nmz.nmz581,
                    g_nmz.nmz31, g_nmz.nmz32, g_nmz.nmz37, g_nmz.nmz33,
                    g_nmz.nmz34, g_nmz.nmz36, g_nmz.nmz35, g_nmz.nmz53,g_nmz.nmz39,        #FUN-840015 Add nmz53
                    g_nmz.nmz14, g_nmz.nmz15, g_nmz.nmz16, g_nmz.nmz17, 
                    g_nmz.nmz18, g_nmz.nmz19, g_nmz.nmz23, g_nmz.nmz27, 
                    g_nmz.nmz24, g_nmz.nmz28, g_nmz.nmz25, g_nmz.nmz29,
                    g_nmz.nmz26, g_nmz.nmz30, g_nmz.nmz20, g_nmz.nmz21, 
                    g_nmz.nmz22, g_nmz.nmz09, g_nmz.nmz59, g_nmz.nmz60,
                    g_nmz.nmz61, g_nmz.nmz62, g_nmz.nmz63, g_nmz.nmz64, 
                    g_nmz.nmz65, g_nmz.nmz66,
                    #FUN-B60069  --begin  mark
                    g_nmz.nmz70,               #No.FUN-B40056 add nmz70
                   #FUN-B60069  --end    mark         
                    #FUN-B50039-add-str--
                    g_nmz.nmz71,g_nmz.nmz72 , #No.FUN-BC0110 add
                    g_nmz.nmz73,       #FUN-D80115 add
                    g_nmz.nmzud01,g_nmz.nmzud02,g_nmz.nmzud03,
                    g_nmz.nmzud04,g_nmz.nmzud05,g_nmz.nmzud06,
                    g_nmz.nmzud07,g_nmz.nmzud08,g_nmz.nmzud09,
                    g_nmz.nmzud10,g_nmz.nmzud11,g_nmz.nmzud12,
                    g_nmz.nmzud13,g_nmz.nmzud14,g_nmz.nmzud15
                    #FUN-B50039-add-end-
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s101_menu()
    MENU ""
    ON ACTION modify     
       #NO.FUN-5B0134 START---
       LET g_action_choice="modify"
       IF cl_chk_act_auth() THEN
           CALL s101_u()
       END IF
       #NO.FUN-5B0134 END-----
    ON ACTION reset 
       LET g_action_choice="reset"
       IF cl_chk_act_auth() THEN
          CALL s101_y()
       END IF
    ON ACTION help   
       CALL cl_show_help()
    ON ACTION locale
       CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    ON ACTION exit      
       LET g_action_choice = 'exit'
       EXIT MENU
    ON ACTION cancel      
       LET g_action_choice = 'exit'
       EXIT MENU
    ON ACTION CONTROLG
       CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
       LET g_action_choice = 'exit'
          CONTINUE MENU
    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
FUNCTION s101_u()
 
    CALL cl_opmsg('u')
 
    MESSAGE ""
    LET g_forupd_sql = "SELECT * FROM nmz_file WHERE nmz00 = '0' FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE nmz_curl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN nmz_curl
    IF STATUS  THEN CALL cl_err('OPEN nmz_curl',STATUS,1) RETURN END IF
    FETCH nmz_curl INTO g_nmz.*
    IF SQLCA.sqlcode  THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
    END IF
    LET g_nmz_t.* = g_nmz.*
    LET g_nmz_o.* = g_nmz.*
    WHILE TRUE
        CALL s101_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           LET g_nmz.* = g_nmz_t.*
           CALL s101_show()
           EXIT WHILE
        END IF
        UPDATE nmz_file SET * = g_nmz.* 
         WHERE nmz00='0'
        IF SQLCA.sqlcode THEN
#          CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660148
           CALL cl_err3("upd","nmz_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660148
           CONTINUE WHILE
        END IF
        CLOSE nmz_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s101_i()
    DEFINE l_aza          LIKE type_file.chr1      #No.FUN-680107 VARCHAR(01)
    DEFINE l_n            LIKE type_file.num5,     #No.FUN-680107 SMALLINT
           l_ans          LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1) #判斷BEFORE FIELD nmz32 時的走向
    DEFINE l_dbs          LIKE type_file.chr21     #No.FUN-740032
    DEFINE l_plant        LIKE type_file.chr10     #No.FUN-980020
    DEFINE li_result      LIKE type_file.num5      #No.FUN-550057  #No.FUN-680107 SMALLINT
    DEFINE li_chk_bookno  LIKE type_file.num5,     #No.FUN-680107 SMALLINT #No.FUN-670006
           l_sql          STRING                   #No.FUN-670006  -add
    DEFINE l_nmc03        LIKE nmc_file.nmc03      #No.MOD-930025
 
    INPUT BY NAME g_nmz.nmz01,g_nmz.nmz02,g_nmz.nmz02p,
                  g_nmz.nmz02b,g_nmz.nmz02c,                           # No.FUN-680034  add g_nmz.nmz02c
                  g_nmz.nmz11,g_nmz.nmz05,g_nmz.nmz06,
                 #g_nmz.nmz10, g_nmz.nmz41,g_nmz.nmz42, g_nmz.nmz04,   #TQC-640148
                  g_nmz.nmz10, g_nmz.nmz04,                            #TQC-640148
#                 g_nmz.nmz03, g_nmz.nmz08, g_nmz.nmz07,               #MOD-870157 Mark
                  g_nmz.nmz08, g_nmz.nmz07,                            #MOD-870157  
                  g_nmz.nmz52, g_nmz.nmz51,                            #No.MOD-470168
#                 g_nmz.nmz55, g_nmz.nmz53, g_nmz.nmz54, g_nmz.nmz40,  #FUN-5A0197
                 #g_nmz.nmz55, g_nmz.nmz54, g_nmz.nmz40,               #FUN-5A0197 #MOD-660060
                  g_nmz.nmz55, g_nmz.nmz54,                            #MOD-660060
                  g_nmz.nmz56, g_nmz.nmz57, g_nmz.nmz58,g_nmz.nmz581,
                  g_nmz.nmz31, g_nmz.nmz32, g_nmz.nmz37, g_nmz.nmz33,
                  g_nmz.nmz34, g_nmz.nmz36, g_nmz.nmz35, g_nmz.nmz53,g_nmz.nmz39,   #FUN-840015 Add nmz53
                  g_nmz.nmz14, g_nmz.nmz15, g_nmz.nmz16, g_nmz.nmz17,
                  g_nmz.nmz18, g_nmz.nmz19, g_nmz.nmz23, g_nmz.nmz27,
                  g_nmz.nmz24, g_nmz.nmz28, g_nmz.nmz25, g_nmz.nmz29,
                  g_nmz.nmz26, g_nmz.nmz30, g_nmz.nmz20, g_nmz.nmz21,
                  g_nmz.nmz22, g_nmz.nmz09, g_nmz.nmz59, g_nmz.nmz60,
                  g_nmz.nmz61, g_nmz.nmz62, g_nmz.nmz63, g_nmz.nmz64,
                  g_nmz.nmz65, g_nmz.nmz66,
                #FUN-B60069  --begin mark
                  g_nmz.nmz70,                                          #FUN-B40056
                #FUN-B60069  --end mark
                  #FUN-B50039-add-str--
                  g_nmz.nmz71,g_nmz.nmz72 , #No.FUN-BC0110 add
                  g_nmz.nmz73,       #FUN-D80115 add
                  g_nmz.nmzud01,g_nmz.nmzud02,g_nmz.nmzud03,
                  g_nmz.nmzud04,g_nmz.nmzud05,g_nmz.nmzud06,
                  g_nmz.nmzud07,g_nmz.nmzud08,g_nmz.nmzud09,
                  g_nmz.nmzud10,g_nmz.nmzud11,g_nmz.nmzud12,
                  g_nmz.nmzud13,g_nmz.nmzud14,g_nmz.nmzud15
                  #FUN-B50039-add-end-
          WITHOUT DEFAULTS 
 
    AFTER FIELD nmz01
       IF NOT cl_null(g_nmz.nmz01) THEN
          IF g_nmz.nmz01 NOT MATCHES '[YN]' THEN 
             LET g_nmz.nmz01=g_nmz_o.nmz01
             DISPLAY BY NAME g_nmz.nmz01
             NEXT FIELD nmz01
          END IF
       END IF
       LET g_nmz_o.nmz01=g_nmz.nmz01
 
 
    AFTER FIELD nmz02
       IF NOT cl_null(g_nmz.nmz02) THEN 
          IF g_nmz.nmz02 NOT MATCHES "[YN]" THEN
             LET g_nmz.nmz02=g_nmz_o.nmz02
             DISPLAY BY NAME g_nmz.nmz02
             NEXT FIELD nmz02
          END IF
       END IF
       LET g_nmz_o.nmz02=g_nmz.nmz02
 
    AFTER FIELD nmz02p
       IF NOT cl_null(g_nmz.nmz02p) THEN
          #FUN-990031--mod--str--營運中心要控制在當前法人下
          #SELECT COUNT(*) INTO l_n FROM azp_file   #工廠編號存在否
          # WHERE azp01 = g_nmz.nmz02p 
          SELECT COUNT(*) INTO l_n FROM azw_file WHERE azw01 = g_nmz.nmz02p 
             AND azw02 = g_legal
          #FUN-990031--mod--end
          IF l_n = 0  THEN 
             #CALL cl_err('sel_azp','mfg9142',0) #FUN-990031 mark
             CALL cl_err('sel_azw','agl-171',0) #FUN-990031 
             LET g_nmz.nmz02p=g_nmz_o.nmz02p
             DISPLAY BY NAME g_nmz.nmz02p
             NEXT FIELD nmz02p 
          END IF 
       END IF
       #No.FUN-740032  --Begin
       LET l_dbs = NULL
       LET l_plant = g_nmz.nmz02p                   #FUN-980020
       SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=g_nmz.nmz02p
       LET t_dbss = l_dbs
       LET l_dbs = s_dbstring(l_dbs CLIPPED)   #FUN-9B0106 

#      CALL s_get_bookno1(NULL,l_dbs)               #FUN-980020 mark
       CALL s_get_bookno1(NULL,l_plant)             #FUN-980020
            RETURNING g_flag,g_bookno1,g_bookno2
       IF g_flag =  '1' THEN  #抓不到帳別
          CALL cl_err(l_dbs,'aoo-081',1)
          NEXT FIELD nmz02p
       END IF
       #No.FUN-740032  --End  
       LET g_nmz_o.nmz02p=g_nmz.nmz02p
 
    AFTER FIELD nmz02b
       IF NOT cl_null(g_nmz.nmz02b) THEN
          #No.FUN-670006--begin
          CALL s_check_bookno(g_nmz.nmz02b,g_user,g_nmz.nmz02p) 
               RETURNING li_chk_bookno
          IF (NOT li_chk_bookno) THEN
              NEXT FIELD nmz02b
          END IF 
          LET g_plant_new = g_nmz.nmz02p  #工廠編號
          #CALL s_getdbs()   #FUN-A50102
          LET l_sql = "SELECT COUNT(*) ",
                      #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                      "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                      " WHERE aaa01 = '",g_nmz.nmz02b,"' ",
                      "   AND aaaacti IN ('Y','y') "
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
          PREPARE s101_pre2 FROM l_sql
          DECLARE s101_cur2 CURSOR FOR s101_pre2
          OPEN s101_cur2
          FETCH s101_cur2 INTO l_n
#         SELECT COUNT(*) INTO l_n FROM aaa_file   #帳別存在否
#          WHERE aaa01 = g_nmz.nmz02b 
          #No.FUN-670006--end
          IF l_n = 0  THEN 
             CALL cl_err('sel_aaa','anm-062',0) 
             LET g_nmz.nmz02b=g_nmz_o.nmz02b
             DISPLAY BY NAME g_nmz.nmz02b
             NEXT FIELD nmz02b 
          END IF 
          IF g_nmz.nmz02c=g_nmz.nmz02b THEN
          CALL cl_err(g_nmz.nmz02b,'afa-888',0)
          NEXT FIELD nmz02b
          END IF     
          #No.FUN-740032  --Begin
          IF g_nmz.nmz02b <> g_bookno1 THEN
             CALL cl_err(g_nmz.nmz02b,"axc-531",1)
          END IF
          #No.FUN-740032  --End  
       END IF
       LET g_nmz_o.nmz02b=g_nmz.nmz02b
 
# No.FUN-680034 --start--
         AFTER FIELD nmz02c
              IF NOT cl_null(g_nmz.nmz02c) THEN
               IF g_nmz.nmz02c <> g_nmz.nmz02b THEN
                CALL s_check_bookno(g_nmz.nmz02c,g_user,g_nmz.nmz02p)
                 RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                      NEXT FIELD nmz02c
               END IF
                LET g_plant_new = g_nmz.nmz02p  #工廠編號
                #CALL s_getdbs()   #FUN-A50102
                LET l_sql = "SELECT COUNT(*) ",
                            #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                            "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                            " WHERE aaa01 = '",g_nmz.nmz02c,"' ",
                            "   AND aaaacti IN ('Y','y') "
 	            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                PREPARE s101_pre3 FROM l_sql
                DECLARE s101_cur3 CURSOR FOR s101_pre3
                OPEN s101_cur3
                FETCH s101_cur3 INTO l_n
 
               IF l_n = 0  THEN
                 CALL cl_err('sel_aaa','anm-062',0)
               LET g_nmz.nmz02c=g_nmz_o.nmz02c
               DISPLAY BY NAME g_nmz.nmz02c
               NEXT FIELD nmz02c
               END IF
             ELSE 
               CALL cl_err(g_nmz.nmz02c,'axr-090',0)
               NEXT FIELD nmz02c
             END IF
             #No.FUN-740032  --Begin
             IF g_nmz.nmz02c <> g_bookno2 THEN
                CALL cl_err(g_nmz.nmz02c,"axc-531",1)
             END IF
             #No.FUN-740032  --End  
            END IF
            LET g_nmz_o.nmz02c=g_nmz.nmz02c
 
# No.FUN-680034 ---end---
# FUN-BC0110  BEGIN
    ON CHANGE nmz71  
         IF g_nmz.nmz71  = 'Y' THEN #對nmz72賦初始值
              LET g_nmz.nmz72 = '1'
              DISPLAY BY NAME g_nmz.nmz72
              CALL cl_set_comp_visible("dummy01,dummy02,nmz70,nmz72",TRUE)     
         ELSE 
              LET g_nmz.nmz72 = '3'
              DISPLAY BY NAME g_nmz.nmz72
              CALL cl_set_comp_visible("dummy01,dummy02,nmz70,nmz72",FALSE)
         END IF         
#FUN-BC0110 END
         #FUN-D80115---add---str---
         IF g_nmz.nmz71  = 'Y' AND g_nmz.nmz70 = '3' THEN
            CALL cl_set_comp_visible("nmz73",TRUE)
         ELSE
            CALL cl_set_comp_visible("nmz73",FALSE)
         END IF
         #FUN-D80115---add---end---

   #FUN-D80115---add---str---
    ON CHANGE nmz70
       IF g_nmz.nmz71  = 'Y' AND g_nmz.nmz70 = '3' THEN
          CALL cl_set_comp_visible("nmz73",TRUE)
       ELSE
          CALL cl_set_comp_visible("nmz73",FALSE)
       END IF
   #FUN-D80115---add---end---

    AFTER FIELD nmz05
       IF NOT cl_null(g_nmz.nmz05) THEN 
          IF g_nmz.nmz05 NOT MATCHES "[YN]" THEN 
             LET g_nmz.nmz05=g_nmz_o.nmz05
             DISPLAY BY NAME g_nmz.nmz05
             NEXT FIELD nmz05
          END IF
       END IF
       LET g_nmz_o.nmz05=g_nmz.nmz05
 
    AFTER FIELD nmz06
       IF NOT cl_null(g_nmz.nmz06) THEN 
          IF g_nmz.nmz06 NOT MATCHES "[YN]" THEN
             LET g_nmz.nmz06=g_nmz_o.nmz06
             DISPLAY BY NAME g_nmz.nmz06
             NEXT FIELD nmz06
          END IF
       END IF
       LET g_nmz_o.nmz06=g_nmz.nmz06
 
    AFTER FIELD nmz10
       IF cl_null(g_nmz.nmz10) THEN
          LET g_nmz.nmz10=g_nmz_o.nmz10
          DISPLAY BY NAME g_nmz.nmz10
          NEXT FIELD nmz10
       END IF
       LET g_nmz_o.nmz10 = g_nmz.nmz10
 
    AFTER FIELD nmz11
       IF NOT cl_null(g_nmz.nmz11) THEN 
          IF g_nmz.nmz11 NOT MATCHES '[YN]' THEN 
             LET g_nmz.nmz11=g_nmz_o.nmz11
             DISPLAY BY NAME g_nmz.nmz11
             NEXT FIELD nmz11
          END IF
       END IF
       LET g_nmz_o.nmz11=g_nmz.nmz11
 
    #-----MOD-660060---------
    #AFTER FIELD nmz40    
    #   IF NOT cl_null(g_nmz.nmz40) THEN 
    #      IF g_nmz.nmz40 NOT MATCHES '[12]' THEN
    #         LET g_nmz.nmz40=g_nmz_o.nmz40
    #         DISPLAY BY NAME g_nmz.nmz40
    #         NEXT FIELD nmz40
    #      END IF 
    #   END IF 
    #   LET g_nmz_o.nmz40=g_nmz.nmz40
    #-----END MOD-660060-----
 
    #-----TQC-640148---------
    #AFTER FIELD nmz42
    #   IF NOT cl_null(g_nmz.nmz42) THEN
    #      IF (g_nmz.nmz42 >13 OR g_nmz.nmz42 < 1) THEN
    #         LET g_nmz.nmz42=g_nmz_o.nmz42
    #         DISPLAY BY NAME g_nmz.nmz42
    #         NEXT FIELD nmz42
    #      END IF
    #   END IF
    #   LET g_nmz_o.nmz42=g_nmz.nmz42
    #-----END TQC-640148-----
 
    #No.MOD-870157-Mark--Begin--#
#   AFTER FIELD nmz03
#      IF NOT cl_null(g_nmz.nmz03) THEN
#         IF g_nmz.nmz03 NOT MATCHES '[YN]' THEN
#            LET g_nmz.nmz03=g_nmz_o.nmz03
#            DISPLAY BY NAME g_nmz.nmz03
#            NEXT FIELD nmz03
#         END IF
#      END IF
#      LET g_nmz_o.nmz03=g_nmz.nmz03
    #No.MOD-870157-Mark--End--#    
 
    AFTER FIELD nmz04    #00/05/22 modify
       IF NOT cl_null(g_nmz.nmz04) THEN
          IF g_nmz.nmz04 NOT MATCHES '[12]' THEN
             LET g_nmz.nmz04=g_nmz_o.nmz04
             DISPLAY BY NAME g_nmz.nmz04
             NEXT FIELD nmz04
          END IF 
       END IF 
       LET g_nmz_o.nmz04=g_nmz.nmz04
 
    AFTER FIELD nmz51    #支票付款預設開票單別
       IF cl_null(g_nmz.nmz51) THEN
          #LET g_nmz.nmz51=g_nmz_o.nmz51 #MOD-9C0386 mark
          #DISPLAY BY NAME g_nmz.nmz51   #MOD-9C0386 mark
       ELSE 
#No.FUN-550057 --start--
       CALL s_check_no("anm",g_nmz.nmz51,"","1","","","")
          RETURNING li_result,g_nmz.nmz51
       LET g_nmz.nmz51= s_get_doc_no(g_nmz.nmz51)
       DISPLAY BY NAME g_nmz.nmz51
        IF (NOT li_result) THEN
           NEXT FIELD nmz51
        END IF
 
#          CALL s_nmyslip(g_nmz.nmz51,'1',g_sys)	#檢查單別 NO:6842
#          IF NOT cl_null(g_errno) THEN	
#             CALL cl_err(g_nmz.nmz51,g_errno,0)
#             NEXT FIELD nmz51  
#          END IF
#No.FUN-550057 ---end--
       END IF
       LET g_nmz_o.nmz51=g_nmz.nmz51
 
#FUN-5A0197
#   AFTER FIELD nmz53  #轉帳付款預設支出異動碼
#      IF cl_null(g_nmz.nmz53) THEN
#         LET g_nmz.nmz53=g_nmz_o.nmz53
#         DISPLAY BY NAME g_nmz.nmz53
#      ELSE 
#         SELECT COUNT(*) INTO l_n FROM nmc_file 
#          WHERE nmc01 = g_nmz.nmz53 AND nmc03 = '2' 
#         IF l_n = 0  THEN 
#            CALL cl_err('sel_nmc','anm-024',0) 
#            LET g_nmz.nmz53=g_nmz_o.nmz53 
#            DISPLAY BY NAME g_nmz.nmz53
#            NEXT FIELD nmz53
#         END IF 
#      END IF
#      LET g_nmz_o.nmz53=g_nmz.nmz53
#END FUN-5A0197
 
    AFTER FIELD nmz54  #廠商聯絡人類別
       IF NOT cl_null(g_nmz.nmz54) THEN
          SELECT COUNT(*) INTO l_n FROM pmd_file  
           WHERE pmd06 = g_nmz.nmz54 
          IF l_n = 0  THEN 
#            CALL cl_err('sel_pmd','mfg3045',0)       #TQC-A70005 Mark                                                              
             CALL cl_err('sel_pmd','axr-917',0)       #TQC-A70005 add              
             LET g_nmz.nmz54=g_nmz_o.nmz54
             DISPLAY BY NAME g_nmz.nmz54
             NEXT FIELD nmz54
          END IF 
       END IF
       LET g_nmz_o.nmz54=g_nmz.nmz54
 
    AFTER FIELD nmz55    #預設現金變動碼
       IF cl_null(g_nmz.nmz55) THEN
          #LET g_nmz.nmz55=g_nmz_o.nmz55  #MOD-9C0386 mark
          #DISPLAY BY NAME g_nmz.nmz55    #MOD-9C0386 mark
       ELSE 
          SELECT COUNT(*) INTO l_n FROM nml_file 
           WHERE nml01 = g_nmz.nmz55 AND nmlacti = 'Y'
          IF l_n = 0  THEN 
             CALL cl_err('sel_nml','mfg3045',0) 
             LET g_nmz.nmz55=g_nmz_o.nmz55
             DISPLAY BY NAME g_nmz.nmz55
             NEXT FIELD nmz55
          END IF 
       END IF
       LET g_nmz_o.nmz55=g_nmz.nmz55
 
    AFTER FIELD nmz56
       IF cl_null(g_nmz.nmz56) THEN
          LET g_nmz.nmz56='0'
       END IF
       IF g_nmz.nmz56 < '0' THEN
          NEXT FIELD nmz56
       END IF
 
    AFTER FIELD nmz57
       IF cl_null(g_nmz.nmz57) THEN
          LET g_nmz.nmz57='0'
       END IF
       IF g_nmz.nmz57 < '0' THEN
          NEXT FIELD nmz57
       END IF
 
    AFTER FIELD nmz58
       IF NOT cl_null(g_nmz.nmz58) THEN
          SELECT  aag01 FROM aag_file 
           WHERE aag01 = g_nmz.nmz58
             AND aag00 = g_nmz.nmz02b      #NO.FUN-740032
          IF SQLCA.sqlcode THEN
#            CALL cl_err('nmz58','aap-021',0)   #No.FUN-660148
             CALL cl_err3("sel","aag_file",g_nmz.nmz58,g_nmz.nmz02b,"aap-021","","nmz58",0) #No.FUN-660148  #No.FUN-740032
#FUN-B10052 --begin--
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_nmz.nmz58
               LET g_qryparam.arg1 = g_nmz.nmz02b          
               LET g_qryparam.construct = 'N'
               LET g_qryparam.where = " aag01 LIKE '",g_nmz.nmz58 CLIPPED,"%'"               
               CALL cl_create_qry() RETURNING g_nmz.nmz58
               DISPLAY BY NAME g_nmz.nmz58 
#FUN-B10052 --end--             
             NEXT FIELD nmz58
          END IF
          LET g_nmz_o.nmz58 = g_nmz.nmz58    
       END IF
# No.FUN-680034 --start--
     AFTER FIELD nmz581
        IF NOT cl_null(g_nmz.nmz581) THEN
          SELECT  aag01 FROM aag_file
           WHERE aag01 = g_nmz.nmz581
             AND aag00 = g_nmz.nmz02c  #No.FUN-740032
          IF SQLCA.sqlcode THEN
             CALL cl_err3("sel","aag_file",g_nmz.nmz581,g_nmz.nmz02c,"aap-021","","nmz581",0)     #No.FUN-740032
#FUN-B10052 --begin--
               CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_nmz.nmz581
                 LET g_qryparam.arg1 = g_nmz.nmz02c        
               LET g_qryparam.construct = 'N'
               LET g_qryparam.where = " aag01 LIKE '",g_nmz.nmz581 CLIPPED,"%'"                     
                  CALL cl_create_qry() RETURNING g_nmz.nmz581
                 DISPLAY BY NAME g_nmz.nmz581          
#FUN-B10052 --end--             
             NEXT FIELD nmz581
          END IF
          LET g_nmz_o.nmz581 = g_nmz.nmz581   
       END IF
 
 
# No.FUN-680034 ---end---
 
    AFTER FIELD nmz31
       IF NOT cl_null(g_nmz.nmz31) THEN
          SELECT * FROM nmc_file WHERE nmc01 = g_nmz.nmz31
          IF SQLCA.sqlcode THEN
             CALL s101_pro(g_nmz.nmz31) RETURNING l_ans
             IF l_ans MATCHES '[Yy]' THEN
                INSERT INTO nmc_file(nmc01,nmc02,nmc03,nmcacti,
                                     nmcuser,nmcgrup,nmcmodu,nmcdate,nmcoriu,nmcorig)
                  VALUES(g_nmz.nmz31,"應付兌現碼",'2',
                         'Y',g_user,g_grup,' ',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                IF SQLCA.sqlcode THEN 
                   LET g_success = 'N'
#                  CALL cl_err('(s103_i:ckp#1)',SQLCA.sqlcode,1)   #No.FUN-660148
                   CALL cl_err3("ins","nmc_file",g_nmz.nmz31,"",SQLCA.sqlcode,"","(s103_i:ckp#1)",1) #No.FUN-660148
                   LET g_nmz.nmz31=g_nmz_o.nmz31 DISPLAY BY NAME g_nmz.nmz31
                   NEXT FIELD nmz31
                END IF
             ELSE CALL cl_err(g_nmz.nmz31,'anm-024',0)
                  LET g_nmz.nmz31=g_nmz_o.nmz31 DISPLAY BY NAME g_nmz.nmz31
                  NEXT FIELD nmz31
             END IF
          END IF
          #No.MOD-8B0154 add --begin
          SELECT COUNT(*) INTO l_n FROM nmc_file 
           WHERE nmc01=g_nmz.nmz31 AND nmcacti='Y' AND nmc03='2'
          IF l_n = 0 THEN
             CALL cl_err(g_nmz.nmz31,'anm-292',0)
             NEXT FIELD nmz31
          END IF
          #No.MOD-8B0154 add --end
       END IF
       LET g_nmz_o.nmz31=g_nmz.nmz31 
 
    AFTER FIELD nmz32
       IF NOT cl_null(g_nmz.nmz32) THEN
          SELECT * FROM nmc_file WHERE nmc01 = g_nmz.nmz32
          IF SQLCA.sqlcode THEN
             CALL s101_pro(g_nmz.nmz32) RETURNING l_ans
             IF l_ans MATCHES '[Yy]' THEN
                INSERT INTO nmc_file(nmc01,nmc02,nmc03,nmcacti,
                                     nmcuser,nmcgrup,nmcmodu,nmcdate,nmcoriu,nmcorig)
                                     VALUES(g_nmz.nmz32,"應付退票碼",'1',
                                            'Y',g_user,g_grup,' ',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                IF SQLCA.sqlcode THEN 
                   LET g_success = 'N'
#                  CALL cl_err('(s103_i:ckp#2)',SQLCA.sqlcode,1)   #No.FUN-660148
                   CALL cl_err3("ins","nmc_file",g_nmz.nmz32,"",SQLCA.sqlcode,"","(s103_i:ckp#2)",1) #No.FUN-660148
                   LET g_nmz.nmz32=g_nmz_o.nmz32 DISPLAY BY NAME g_nmz.nmz32
                   NEXT FIELD nmz32
                END IF
             ELSE CALL cl_err(g_nmz.nmz32,'anm-024',0)
                  LET g_nmz.nmz32=g_nmz_o.nmz32 DISPLAY BY NAME g_nmz.nmz32
                  NEXT FIELD nmz32
             END IF
          END IF
          #No.MOD-8B0154 add --begin
          SELECT COUNT(*) INTO l_n FROM nmc_file 
           WHERE nmc01=g_nmz.nmz32 AND nmcacti='Y' AND nmc03='1'
          IF l_n = 0 THEN
             CALL cl_err(g_nmz.nmz32,'anm-292',0)
             NEXT FIELD nmz32
          END IF
          #No.MOD-8B0154 add --end
       END IF
       LET g_nmz_o.nmz32=g_nmz.nmz32 
 
    AFTER FIELD nmz33
       IF NOT cl_null(g_nmz.nmz33) THEN
          SELECT * FROM nmc_file WHERE nmc01 = g_nmz.nmz33
          IF SQLCA.sqlcode THEN
             CALL s101_pro(g_nmz.nmz33) RETURNING l_ans
             IF l_ans MATCHES '[Yy]' THEN
                INSERT INTO nmc_file(nmc01,nmc02,nmc03,nmcacti,
                                     nmcuser,nmcgrup,nmcmodu,nmcdate,nmcoriu,nmcorig)
                                     VALUES(g_nmz.nmz33,"應收兌現碼",'1',
                                            'Y',g_user,g_grup,' ',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                IF SQLCA.sqlcode THEN 
                   LET g_success = 'N'
#                  CALL cl_err('(s103_i:ckp#3)',SQLCA.sqlcode,1)   #No.FUN-660148
                   CALL cl_err3("ins","nmc_file",g_nmz.nmz33,"",SQLCA.sqlcode,"","(s103_i:ckp#3)",1) #No.FUN-660148
                   LET g_nmz.nmz33=g_nmz_o.nmz33 DISPLAY BY NAME g_nmz.nmz33
                   NEXT FIELD nmz33
                END IF
             ELSE CALL cl_err(g_nmz.nmz33,'anm-024',0)
                  LET g_nmz.nmz33=g_nmz_o.nmz33 DISPLAY BY NAME g_nmz.nmz33
                  NEXT FIELD nmz33
             END IF
          END IF
          #No.MOD-8B0154 add --begin
          SELECT COUNT(*) INTO l_n FROM nmc_file 
           WHERE nmc01=g_nmz.nmz33 AND nmcacti='Y' AND nmc03='1'
          IF l_n = 0 THEN
             CALL cl_err(g_nmz.nmz33,'anm-292',0)
             NEXT FIELD nmz33
          END IF
          #No.MOD-8B0154 add --end
       END IF
       LET g_nmz_o.nmz33=g_nmz.nmz33 
 
    AFTER FIELD nmz34
       IF NOT cl_null(g_nmz.nmz34) THEN
          SELECT * FROM nmc_file WHERE nmc01 = g_nmz.nmz34
          IF SQLCA.sqlcode THEN
             CALL s101_pro(g_nmz.nmz34) RETURNING l_ans
             IF l_ans MATCHES '[Yy]' THEN
                INSERT INTO nmc_file(nmc01,nmc02,nmc03,nmcacti,
                                     nmcuser,nmcgrup,nmcmodu,nmcdate,nmcoriu,nmcorig)
                                     VALUES(g_nmz.nmz34,"應收退票碼",'2',
                                            'Y',g_user,g_grup,' ',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                IF SQLCA.sqlcode THEN 
                   LET g_success = 'N'
#                  CALL cl_err('(s103_i:ckp#4)',SQLCA.sqlcode,1)   #No.FUN-660148
                   CALL cl_err3("ins","nmc_file",g_nmz.nmz34,"",SQLCA.sqlcode,"","(s103_i:ckp#4)",1) #No.FUN-660148
                  LET g_nmz.nmz34=g_nmz_o.nmz34 DISPLAY BY NAME g_nmz.nmz34
                   NEXT FIELD nmz34
                END IF
             ELSE CALL cl_err(g_nmz.nmz34,'anm-024',0)
                  LET g_nmz.nmz34=g_nmz_o.nmz34 DISPLAY BY NAME g_nmz.nmz34
                  NEXT FIELD nmz34
             END IF
          END IF
          #No.MOD-8B0154 add --begin
          SELECT COUNT(*) INTO l_n FROM nmc_file 
           WHERE nmc01=g_nmz.nmz34 AND nmcacti='Y' AND nmc03='2'
          IF l_n = 0 THEN
             CALL cl_err(g_nmz.nmz34,'anm-292',0)
             NEXT FIELD nmz34
          END IF
          #No.MOD-8B0154 add --end
       END IF
       LET g_nmz_o.nmz34=g_nmz.nmz34 
 
    AFTER FIELD nmz35
       IF NOT cl_null(g_nmz.nmz35) THEN
         #SELECT * FROM nmc_file WHERE nmc01 = g_nmz.nmz35      #No.MOD-930025 mark
          LET l_nmc03 = NULL #No.MOD-930025
          SELECT nmc03 INTO l_nmc03 FROM nmc_file WHERE nmc01 = g_nmz.nmz35  #No.MOD-930025
          IF SQLCA.sqlcode THEN
             CALL s101_pro(g_nmz.nmz35) RETURNING l_ans
             IF l_ans MATCHES '[Yy]' THEN
                INSERT INTO nmc_file(nmc01,nmc02,nmc03,nmcacti,
                                     nmcuser,nmcgrup,nmcmodu,nmcdate,nmcoriu,nmcorig)
                                     VALUES(g_nmz.nmz35,"銀行匯差",'1',
                                            'Y',g_user,g_grup,' ',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                IF SQLCA.sqlcode THEN 
                   LET g_success = 'N'
#                  CALL cl_err('(s103_i:ckp#5)',SQLCA.sqlcode,1)   #No.FUN-660148
                   CALL cl_err3("ins","nmc_file",g_nmz.nmz35,"",SQLCA.sqlcode,"","(s103_i:ckp#5)",1) #No.FUN-660148
                  LET g_nmz.nmz35=g_nmz_o.nmz35 DISPLAY BY NAME g_nmz.nmz35
                   NEXT FIELD nmz35
                END IF
             ELSE CALL cl_err(g_nmz.nmz35,'anm-024',0)
                  LET g_nmz.nmz35=g_nmz_o.nmz35 DISPLAY BY NAME g_nmz.nmz35
                  NEXT FIELD nmz35
             END IF
         #No.MOD-930025--begin--
          ELSE 
             IF l_nmc03 <> '1' THEN 
                CALL cl_err('','anm-334',0)
                NEXT FIELD nmz35
             END IF 
         #No.MOD-930025---end---
          END IF
       END IF
       LET g_nmz_o.nmz35=g_nmz.nmz35
       
#No.FUN-840015--Add--Begin--#
    AFTER FIELD nmz53
       IF NOT cl_null(g_nmz.nmz53) THEN
         #SELECT * FROM nmc_file WHERE nmc01 = g_nmz.nmz53      #No.MOD-930025 mark
          LET l_nmc03 = NULL   #No.MOD-930025
          SELECT nmc03 INTO l_nmc03 FROM nmc_file WHERE nmc01 = g_nmz.nmz53
          IF SQLCA.sqlcode THEN
             CALL s101_pro(g_nmz.nmz53) RETURNING l_ans
             IF l_ans MATCHES '[Yy]' THEN
                INSERT INTO nmc_file(nmc01,nmc02,nmc03,nmcacti,
                                     nmcuser,nmcgrup,nmcmodu,nmcdate,nmcoriu,nmcorig)
                                    #VALUES(g_nmz.nmz53,"銀行匯差",'1',   #No.MOD-930025 mark
                                     VALUES(g_nmz.nmz53,"銀行匯差",'2',   #No.MOD-930025
                                            'Y',g_user,g_grup,' ',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                IF SQLCA.sqlcode THEN 
                   LET g_success = 'N'
                   CALL cl_err3("ins","nmc_file",g_nmz.nmz53,"",SQLCA.sqlcode,"","(s103_i:ckp#5)",1) 
                  LET g_nmz.nmz53=g_nmz_o.nmz53 DISPLAY BY NAME g_nmz.nmz53
                   NEXT FIELD nmz53
                END IF
             ELSE CALL cl_err(g_nmz.nmz53,'anm-024',0)
                  LET g_nmz.nmz53=g_nmz_o.nmz53 DISPLAY BY NAME g_nmz.nmz53
                  NEXT FIELD nmz53
             END IF
         #No.MOD-930025--begin--
          ELSE 
             IF l_nmc03 <> '2' THEN 
                CALL cl_err('','anm-333',0)
                NEXT FIELD nmz53
             END IF 
         #No.MOD-930025---end---
          END IF
       END IF
       LET g_nmz_o.nmz53=g_nmz.nmz53
#No.FUN-840015--Add--End--#        
 
 
    AFTER FIELD nmz36
       IF NOT cl_null(g_nmz.nmz36) THEN
          SELECT * FROM nmc_file WHERE nmc01 = g_nmz.nmz36
          IF SQLCA.sqlcode THEN
             CALL s101_pro(g_nmz.nmz36) RETURNING l_ans
             IF l_ans MATCHES '[Yy]' THEN
                INSERT INTO nmc_file(nmc01,nmc02,nmc03,nmcacti,
                                     nmcuser,nmcgrup,nmcmodu,nmcdate,nmcoriu,nmcorig)
                                     VALUES(g_nmz.nmz36,"應收匯差",'1',
                                            'Y',g_user,g_grup,' ',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                IF SQLCA.sqlcode THEN 
                   LET g_success = 'N'
#                  CALL cl_err('(s103_i:ckp#4)',SQLCA.sqlcode,1)   #No.FUN-660148
                   CALL cl_err3("ins","nmc_file",g_nmz.nmz36,"",SQLCA.sqlcode,"","(s103_i:ckp#4)",1) #No.FUN-660148
                  LET g_nmz.nmz36=g_nmz_o.nmz36 DISPLAY BY NAME g_nmz.nmz36
                   NEXT FIELD nmz36
                END IF
             ELSE CALL cl_err(g_nmz.nmz36,'anm-024',0)
                  LET g_nmz.nmz36=g_nmz_o.nmz36 DISPLAY BY NAME g_nmz.nmz36
                  NEXT FIELD nmz36
             END IF
          END IF
       END IF
       LET g_nmz_o.nmz36=g_nmz.nmz36 
 
    AFTER FIELD nmz37
       IF NOT cl_null(g_nmz.nmz37) THEN
          SELECT * FROM nmc_file WHERE nmc01 = g_nmz.nmz37
          IF SQLCA.sqlcode THEN
             CALL s101_pro(g_nmz.nmz37) RETURNING l_ans
             IF l_ans MATCHES '[Yy]' THEN
                INSERT INTO nmc_file(nmc01,nmc02,nmc03,nmcacti,
                                     nmcuser,nmcgrup,nmcmodu,nmcdate,nmcoriu,nmcorig)
                                     VALUES(g_nmz.nmz37,"應付匯差",'2',
                                            'Y',g_user,g_grup,' ',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                IF SQLCA.sqlcode THEN 
                   LET g_success = 'N'
#                  CALL cl_err('(s103_i:ckp#4)',SQLCA.sqlcode,1)   #No.FUN-660148
                   CALL cl_err3("ins","nmc_file",g_nmz.nmz37,"",SQLCA.sqlcode,"","(s103_i:ckp#4)",1) #No.FUN-660148
                  LET g_nmz.nmz37=g_nmz_o.nmz37 DISPLAY BY NAME g_nmz.nmz37
                   NEXT FIELD nmz37
                END IF
             ELSE CALL cl_err(g_nmz.nmz37,'anm-024',0)
                  LET g_nmz.nmz37=g_nmz_o.nmz37 DISPLAY BY NAME g_nmz.nmz37
                  NEXT FIELD nmz37
             END IF
          END IF
       END IF
       LET g_nmz_o.nmz37=g_nmz.nmz37 
 
    #No.TQC-790077  --Begin
    AFTER FIELD nmz14
       IF NOT cl_null(g_nmz.nmz14) THEN
          IF g_nmz.nmz14 < 0 THEN
             CALL cl_err(g_nmz.nmz14,'aim-223',0)
             LET g_nmz.nmz14=g_nmz_o.nmz14
             DISPLAY BY NAME g_nmz.nmz14
             NEXT FIELD nmz14
          END IF
       END IF
 
    AFTER FIELD nmz15
       IF NOT cl_null(g_nmz.nmz15) THEN
          IF g_nmz.nmz15 < 0 THEN
             CALL cl_err(g_nmz.nmz15,'aim-223',0)
             LET g_nmz.nmz15=g_nmz_o.nmz15
             DISPLAY BY NAME g_nmz.nmz15
             NEXT FIELD nmz15
          END IF
       END IF
 
    AFTER FIELD nmz16
       IF NOT cl_null(g_nmz.nmz16) THEN
          IF g_nmz.nmz16 < 0 THEN
             CALL cl_err(g_nmz.nmz16,'aim-223',0)
             LET g_nmz.nmz16=g_nmz_o.nmz16
             DISPLAY BY NAME g_nmz.nmz16
             NEXT FIELD nmz16
          END IF
       END IF
 
    AFTER FIELD nmz17
       IF NOT cl_null(g_nmz.nmz17) THEN
          IF g_nmz.nmz17 < 0 THEN
             CALL cl_err(g_nmz.nmz17,'aim-223',0)
             LET g_nmz.nmz17=g_nmz_o.nmz17
             DISPLAY BY NAME g_nmz.nmz17
             NEXT FIELD nmz17
          END IF
       END IF
 
    AFTER FIELD nmz18
       IF NOT cl_null(g_nmz.nmz18) THEN
          IF g_nmz.nmz18 < 0 THEN
             CALL cl_err(g_nmz.nmz18,'aim-223',0)
             LET g_nmz.nmz18=g_nmz_o.nmz18
             DISPLAY BY NAME g_nmz.nmz18
             NEXT FIELD nmz18
          END IF
       END IF
 
    AFTER FIELD nmz19
       IF NOT cl_null(g_nmz.nmz19) THEN
          IF g_nmz.nmz19 < 0 THEN
             CALL cl_err(g_nmz.nmz19,'aim-223',0)
             LET g_nmz.nmz19=g_nmz_o.nmz19
             DISPLAY BY NAME g_nmz.nmz19
             NEXT FIELD nmz19
          END IF
       END IF
 
    AFTER FIELD nmz23
       IF NOT cl_null(g_nmz.nmz23) THEN
          IF g_nmz.nmz23 < 0 THEN
             CALL cl_err(g_nmz.nmz23,'aim-223',0)
             LET g_nmz.nmz23=g_nmz_o.nmz23
             DISPLAY BY NAME g_nmz.nmz23
             NEXT FIELD nmz23
          END IF
       END IF
 
    AFTER FIELD nmz24
       IF NOT cl_null(g_nmz.nmz24) THEN
          IF g_nmz.nmz24 < 0 THEN
             CALL cl_err(g_nmz.nmz24,'aim-223',0)
             LET g_nmz.nmz24=g_nmz_o.nmz24
             DISPLAY BY NAME g_nmz.nmz24
             NEXT FIELD nmz24
          END IF
       END IF
 
    AFTER FIELD nmz25
       IF NOT cl_null(g_nmz.nmz25) THEN
          IF g_nmz.nmz25 < 0 THEN
             CALL cl_err(g_nmz.nmz25,'aim-223',0)
             LET g_nmz.nmz25=g_nmz_o.nmz25
             DISPLAY BY NAME g_nmz.nmz25
             NEXT FIELD nmz25
          END IF
       END IF
 
    AFTER FIELD nmz26
       IF NOT cl_null(g_nmz.nmz26) THEN
          IF g_nmz.nmz26 < 0 THEN
             CALL cl_err(g_nmz.nmz26,'aim-223',0)
             LET g_nmz.nmz26=g_nmz_o.nmz26
             DISPLAY BY NAME g_nmz.nmz26
             NEXT FIELD nmz26
          END IF
       END IF
 
    AFTER FIELD nmz27
       IF NOT cl_null(g_nmz.nmz27) THEN
          IF g_nmz.nmz27 < 0 THEN
             CALL cl_err(g_nmz.nmz27,'aim-223',0)
             LET g_nmz.nmz27=g_nmz_o.nmz27
             DISPLAY BY NAME g_nmz.nmz27
             NEXT FIELD nmz27
          END IF
       END IF
 
    AFTER FIELD nmz28
       IF NOT cl_null(g_nmz.nmz28) THEN
          IF g_nmz.nmz28 < 0 THEN
             CALL cl_err(g_nmz.nmz28,'aim-223',0)
             LET g_nmz.nmz28=g_nmz_o.nmz28
             DISPLAY BY NAME g_nmz.nmz28
             NEXT FIELD nmz28
          END IF
       END IF
 
    AFTER FIELD nmz29
       IF NOT cl_null(g_nmz.nmz29) THEN
          IF g_nmz.nmz29 < 0 THEN
             CALL cl_err(g_nmz.nmz29,'aim-223',0)
             LET g_nmz.nmz29=g_nmz_o.nmz29
             DISPLAY BY NAME g_nmz.nmz29
             NEXT FIELD nmz29
          END IF
       END IF
 
    AFTER FIELD nmz30
       IF NOT cl_null(g_nmz.nmz30) THEN
          IF g_nmz.nmz30 < 0 THEN
             CALL cl_err(g_nmz.nmz30,'aim-223',0)
             LET g_nmz.nmz30=g_nmz_o.nmz30
             DISPLAY BY NAME g_nmz.nmz30
             NEXT FIELD nmz30
          END IF
       END IF
    #No.TQC-790077  --End  
 
    AFTER FIELD nmz39
       IF NOT cl_null(g_nmz.nmz39) THEN
          SELECT * FROM nmc_file WHERE nmc01 = g_nmz.nmz39
          IF SQLCA.sqlcode THEN
             CALL s101_pro(g_nmz.nmz39) RETURNING l_ans
             IF l_ans MATCHES '[Yy]' THEN
                INSERT INTO nmc_file(nmc01,nmc02,nmc03,nmcacti,
                                     nmcuser,nmcgrup,nmcmodu,nmcdate,nmcoriu,nmcorig)
                                     VALUES(g_nmz.nmz39,"Fee",'2',
                                            'Y',g_user,g_grup,' ',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
                IF SQLCA.sqlcode THEN 
                   LET g_success = 'N'
#                  CALL cl_err('(s103_i:ckp#4)',SQLCA.sqlcode,1)   #No.FUN-660148
                   CALL cl_err3("ins","nmc_file",g_nmz.nmz39,"",SQLCA.sqlcode,"","(s103_i:ckp#4)",1) #No.FUN-660148
                  LET g_nmz.nmz39=g_nmz_o.nmz39 DISPLAY BY NAME g_nmz.nmz39
                   NEXT FIELD nmz39
                END IF
             ELSE CALL cl_err(g_nmz.nmz39,'anm-024',0)
                  LET g_nmz.nmz39=g_nmz_o.nmz39 DISPLAY BY NAME g_nmz.nmz39
                  NEXT FIELD nmz39
             END IF
          END IF
       END IF
       LET g_nmz_o.nmz39=g_nmz.nmz39 
 
#gnms105......
      AFTER FIELD nmz20
         IF NOT cl_null(g_nmz.nmz20) THEN
            IF g_nmz.nmz20 NOT MATCHES '[YN]' THEN
               LET g_nmz.nmz20=g_nmz_o.nmz20
               DISPLAY BY NAME g_nmz.nmz20
               NEXT FIELD nmz20
            END IF
         END IF
         LET g_nmz_o.nmz20=g_nmz.nmz20 
 
      AFTER FIELD nmz22
         IF NOT cl_null(g_nmz.nmz22) THEN
            IF (g_nmz.nmz22 > 12 OR g_nmz.nmz22 < 1 ) THEN
               LET g_nmz.nmz22=g_nmz_o.nmz22
               DISPLAY BY NAME g_nmz.nmz22
               NEXT FIELD nmz22
            END IF
         END IF
         LET g_nmz_o.nmz22=g_nmz.nmz22 
 
      AFTER FIELD nmz09
         IF NOT cl_null(g_nmz.nmz09) THEN
            IF g_nmz.nmz09 NOT MATCHES '[12]' THEN
               LET g_nmz.nmz09=g_nmz_o.nmz09 
               DISPLAY BY NAME g_nmz.nmz09
               NEXT FIELD nmz09
            END IF
         END IF
         LET g_nmz_o.nmz09=g_nmz.nmz09 
 
      AFTER FIELD nmz59
         IF NOT cl_null(g_nmz.nmz59) THEN 
            IF g_nmz.nmz59 NOT MATCHES '[YN]' THEN
               LET g_nmz.nmz59=g_nmz_o.nmz59
               DISPLAY BY NAME g_nmz.nmz59
               NEXT FIELD nmz59
            END IF
         END IF
         LET g_nmz_o.nmz59=g_nmz.nmz59 
 
      AFTER FIELD nmz61
         IF NOT cl_null(g_nmz.nmz61) THEN 
            IF (g_nmz.nmz61 > 12 OR g_nmz.nmz61 < 1 ) THEN
               LET g_nmz.nmz61=g_nmz_o.nmz61
               DISPLAY BY NAME g_nmz.nmz61
               NEXT FIELD nmz61
            END IF
         END IF
         LET g_nmz_o.nmz61=g_nmz.nmz61 
 
      AFTER FIELD nmz62
         IF NOT cl_null(g_nmz.nmz62) THEN 
            IF g_nmz.nmz62 NOT MATCHES '[123]' THEN
               LET g_nmz.nmz62=g_nmz_o.nmz62 
               DISPLAY BY NAME g_nmz.nmz62
               NEXT FIELD nmz62
            END IF
         END IF
         LET g_nmz_o.nmz62=g_nmz.nmz62 
 
      AFTER FIELD nmz63
         IF NOT cl_null(g_nmz.nmz63) THEN 
            IF g_nmz.nmz63 NOT MATCHES '[YN]' THEN
               LET g_nmz.nmz63=g_nmz_o.nmz63
               DISPLAY BY NAME g_nmz.nmz63
               NEXT FIELD nmz63
            END IF
         END IF
         LET g_nmz_o.nmz63=g_nmz.nmz63 
 
      AFTER FIELD nmz65
         IF NOT cl_null(g_nmz.nmz65) THEN 
            IF (g_nmz.nmz65 > 12 OR g_nmz.nmz65 < 1 ) THEN
               LET g_nmz.nmz65=g_nmz_o.nmz65
               DISPLAY BY NAME g_nmz.nmz65
               NEXT FIELD nmz65
            END IF
         END IF
         LET g_nmz_o.nmz65=g_nmz.nmz65 
 
      AFTER FIELD nmz66
         IF NOT cl_null(g_nmz.nmz66) THEN
            IF g_nmz.nmz66 NOT MATCHES '[123]' THEN
               LET g_nmz.nmz66=g_nmz_o.nmz66 
               DISPLAY BY NAME g_nmz.nmz66
               NEXT FIELD nmz66
            END IF
         END IF
         LET g_nmz_o.nmz66=g_nmz.nmz66 
 
      #FUN-B50039-add-str--
      AFTER FIELD nmzud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nmzud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--

      
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(nmz55)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nml"
               LET g_qryparam.default1 = g_nmz.nmz55
               CALL cl_create_qry() RETURNING g_nmz.nmz55
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz55 )
                DISPLAY BY NAME g_nmz.nmz55               #No.MOD-490344
               NEXT FIELD nmz55
          WHEN INFIELD(nmz51) #查詢單据
              #CALL q_nmy(FALSE,FALSE,g_nmz.nmz51,'1',g_sys) RETURNING g_nmz.nmz51  #TQC-670008
               CALL q_nmy(FALSE,FALSE,g_nmz.nmz51,'1','ANM') RETURNING g_nmz.nmz51  #TQC-670008
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz51 )
               DISPLAY BY NAME g_nmz.nmz51
               NEXT FIELD nmz51               
          WHEN INFIELD(nmz58)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.default1 = g_nmz.nmz58
               LET g_qryparam.arg1 = g_nmz.nmz02b                  #NO.FUN-740032              
               CALL cl_create_qry() RETURNING g_nmz.nmz58
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz58 )
               DISPLAY BY NAME g_nmz.nmz58 
               NEXT FIELD nmz58
          WHEN INFIELD(nmz02b)
               CALL cl_init_qry_var()
               #No.FUN-740032  --Begin
#              LET g_qryparam.form = "q_aaa"
               LET g_qryparam.form = "q_m_aaa"
               LET g_qryparam.default1 = g_nmz.nmz02b
#              LET g_qryparam.arg1 = t_dbss         #No.FUN-980025 mark 
               LET g_qryparam.plant = g_nmz.nmz02p  #No.FUN-980025 add
               #No.FUN-740032  --End   
               CALL cl_create_qry() RETURNING g_nmz.nmz02b
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz02b )
               DISPLAY BY NAME g_nmz.nmz02b 
               NEXT FIELD nmz02b
# No.FUN-680034 --start--
          WHEN INFIELD(nmz02c)
               CALL cl_init_qry_var()
               #No.FUN-740032  --Begin
#              LET g_qryparam.form = "q_aaa"
               LET g_qryparam.form = "q_m_aaa"
               LET g_qryparam.default1 = g_nmz.nmz02c
#              LET g_qryparam.arg1 = t_dbss         #No.FUN-980025 mark
               LET g_qryparam.plant = g_nmz.nmz02p  #No.FUN-980025 add
               #No.FUN-740032  --End   
               CALL cl_create_qry() RETURNING g_nmz.nmz02c
               DISPLAY BY NAME g_nmz.nmz02c
               NEXT FIELD nmz02c
 
          WHEN INFIELD(nmz581)
               CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_nmz.nmz581
                 LET g_qryparam.arg1 = g_nmz.nmz02c                   #NO.FUN-740032                        
                  CALL cl_create_qry() RETURNING g_nmz.nmz581
                 DISPLAY BY NAME g_nmz.nmz581
               NEXT FIELD nmz581
 
 
# No.FUN-780034 ---end--- 
          WHEN INFIELD(nmz02p)
               CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_azp"   #FUN-990031 mark
               LET g_qryparam.form = "q_azw"     #FUN-990031 add
               LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add
               LET g_qryparam.default1 = g_nmz.nmz02p
               CALL cl_create_qry() RETURNING g_nmz.nmz02p
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz02p )
               DISPLAY BY NAME g_nmz.nmz02p 
               NEXT FIELD nmz02p
          WHEN INFIELD(nmz31)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_nmc01"    #No.MOD-4A0163
                LET g_qryparam.arg1 = "2"     #No.MOD-4A0163
               LET g_qryparam.default1 = g_nmz.nmz31
               CALL cl_create_qry() RETURNING g_nmz.nmz31
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz31 )
               DISPLAY BY NAME g_nmz.nmz31 
               NEXT FIELD nmz31
          WHEN INFIELD(nmz32)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_nmc01"    #No.MOD-4A0163
                LET g_qryparam.arg1 = "1"     #No.MOD-4A0163
               LET g_qryparam.default1 = g_nmz.nmz32
               CALL cl_create_qry() RETURNING g_nmz.nmz32
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz32 )
               DISPLAY BY NAME g_nmz.nmz32 
               NEXT FIELD nmz32
          WHEN INFIELD(nmz33)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_nmc01"    #No.MOD-4A0163
                LET g_qryparam.arg1 = "1"     #No.MOD-4A0163
               LET g_qryparam.default1 = g_nmz.nmz33
               CALL cl_create_qry() RETURNING g_nmz.nmz33
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz33 )
               DISPLAY BY NAME g_nmz.nmz33 NEXT FIELD nmz33
          WHEN INFIELD(nmz34)
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_nmc01"    #No.MOD-4A0163
                LET g_qryparam.arg1 = "2"     #No.MOD-4A0163
               LET g_qryparam.default1 = g_nmz.nmz34
               CALL cl_create_qry() RETURNING g_nmz.nmz34
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz34 )
               DISPLAY BY NAME g_nmz.nmz34 NEXT FIELD nmz34
          WHEN INFIELD(nmz35)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmc01"     #MOD-B40073 mod q_nmc->q_nmc01
               LET g_qryparam.arg1 = "1"           #MOD-B40073 add
               LET g_qryparam.default1 = g_nmz.nmz35
               CALL cl_create_qry() RETURNING g_nmz.nmz35
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz35 )
               DISPLAY BY NAME g_nmz.nmz35 NEXT FIELD nmz35
#No.FUN-840015--Add--Begin--#
          WHEN INFIELD(nmz53)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmc01"     #MOD-B40073 mod q_nmc->q_nmc01
               LET g_qryparam.arg1 = "2"           #MOD-B40073 add
               LET g_qryparam.default1 = g_nmz.nmz53
               CALL cl_create_qry() RETURNING g_nmz.nmz53
               DISPLAY BY NAME g_nmz.nmz53 NEXT FIELD nmz53
#No.FUN-840015--Add--End--#               
          WHEN INFIELD(nmz36)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmc"
               LET g_qryparam.default1 = g_nmz.nmz36
               CALL cl_create_qry() RETURNING g_nmz.nmz36
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz36 )
               DISPLAY BY NAME g_nmz.nmz36 NEXT FIELD nmz36
          WHEN INFIELD(nmz37)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmc"
               LET g_qryparam.default1 = g_nmz.nmz37
               CALL cl_create_qry() RETURNING g_nmz.nmz37
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz37 )
               DISPLAY BY NAME g_nmz.nmz37 NEXT FIELD nmz37
          WHEN INFIELD(nmz39)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmc"
               LET g_qryparam.default1 = g_nmz.nmz39
               CALL cl_create_qry() RETURNING g_nmz.nmz39
#               CALL FGL_DIALOG_SETBUFFER( g_nmz.nmz39 )
               DISPLAY BY NAME g_nmz.nmz39 NEXT FIELD nmz39
         #FUN-D80115---add---str--
          WHEN INFIELD(nmz73)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nml"
               LET g_qryparam.default1 = g_nmz.nmz73
               CALL cl_create_qry() RETURNING g_nmz.nmz73
               DISPLAY BY NAME g_nmz.nmz73
               NEXT FIELD nmz73
         #FUN-D80115---add---end--
          OTHERWISE EXIT CASE
       END CASE
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
    ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
    ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    AFTER INPUT
       IF INT_FLAG THEN EXIT INPUT END IF
#FUN-B60069  --begin mark
#FUN-B40056--begin--
       IF cl_null(g_nmz.nmz70) THEN
          CALL cl_err('','anm-714',0)
          DISPLAY BY NAME g_nmz.nmz70
          NEXT FIELD nmz70
       END IF
#FUN-B40056--end--
#FUN-B60069  --end mark
  
  END INPUT
END FUNCTION
 
FUNCTION s101_y()
 DEFINE   l_nmz01  LIKE nmz_file.nmz01   #No.FUN-680107 VARCHAR(01)
     SELECT nmz01 INTO l_nmz01 FROM nmz_file WHERE nmz00='0'
     IF l_nmz01 = 'Y' THEN RETURN END IF
     UPDATE nmz_file SET nmz01='Y' WHERE nmz00='0'
     IF STATUS THEN
        LET g_nmz.nmz01='N'
#       CALL cl_err('upd nmz01:',STATUS,0)   #No.FUN-660148
        CALL cl_err3("upd","nmz_file","","",STATUS,"","upd nmz01:",0) #No.FUN-660148
     ELSE
        LET g_nmz.nmz01='Y'
     END IF
     DISPLAY BY NAME g_nmz.nmz01 
END FUNCTION
 
FUNCTION s101_pro(p_key)
DEFINE   l_ans   LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
         p_key   LIKE type_file.chr2,    #No.FUN-680107 VARCHAR(02)
         l_msg   LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(40)
 
        LET l_ans = ' '
        CALL cl_getmsg('anm-023',0) RETURNING l_msg
        WHILE l_ans NOT MATCHES '[yYnN]' 
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT l_msg FOR CHAR l_ans
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE WHILE 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            END PROMPT
        END WHILE
        RETURN l_ans
END FUNCTION
