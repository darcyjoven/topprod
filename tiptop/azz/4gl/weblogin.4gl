# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: weblogin.4gl
# Descriptions...: Web 使用者登入作業
# Date & Author..: 03/10/30 By Brendan
# Modify.........: No.FUN-660149 06/06/23 By alexstar 比照整體系統參數進行閒置控管
# Modify.........: No.FUN-620044 06/07/03 By alexstar 改成執行udm7這支shell,讓user可以選擇為內部\外部連線到TIPTOP主機
# Modify.........: No.FUN-680135 06/09/18 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-690056 06/09/13 By Brendan 調整紀錄 WEB 執行時的 IP 為實際 Client IP, 而非紀錄 127.0.0.1
# Modify.........: No.FUN-7B0126 07/11/27 By Echo 與 Portal 採 SSO 進行整合 - By Web Service
# Modify.........: No.FUN-570135 08/03/03 By alex 更新修改日期, 判斷 user是否已失效
# Modify.........: No.FUN-830011 08/03/20 By alex 更新密碼修改機制
# Modify.........: No.TQC-870015 08/08/15 By saki 取消使用zxx_file
# Modify.........: No.TQC-880032 08/08/20 By alex 取消使用cl_err()
# Modify.........: NO.TQC-880043 08/08/22 By saki 取消使用zxx_file
# Modify.........: NO.FUN-8A0113 08/10/28 By Echo Genero 2.1 調整
# Modify.........: No.FUN-8A0096 08/10/29 by Vicky 新增For Production Portal整合-待辦事項
# Modify.........: NO.FUN-910094 09/01/20 By alex 新增zx10編碼機制
# Modify.........: No.FUN-930042 09/03/09 By alex 調整密碼修改機制
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No:FUN-990001 09/09/07 By alex 將錯誤訊息標示明確
# Modify.........: No.FUN-950082 10/05/03 By alex 新增ap server hostname設定 
# Modify.........: No:FUN-AA0003 10/10/01 By Jay 整合功能加入密碼過期驗證,增加SSO log
# Modify.........: No.FUN-AB0079 10/11/17 By Kevin 控管License
# Modify.........: No:CHI-A70014 10/11/25 By Summer 密碼檢核的訊息應依user慣用語系呈現
# Modify.........: No:FUN-AB0111 10/12/07 By Jay 增加在portal登入時,若已傳遞營運中心資料,則不再執行aoos901作業
# Modify.........: No:FUN-B10003 11/01/07 By Jay 增加TIPTOP SSOKey整合
# Modify.........: No:FUN-A80141 11/02/16 By Jay 新增AD整合帳號驗證功能 
# Modify.........: No:FUN-B30037 11/03/14 By jrg542 增加 "fglWrt -u" 清除占用license
# Modify.........: No:FUN-B40051 11/04/18 By Jay 利用4gl Java Interface改寫AD整合帳號驗證功能
# Modify.........: No.FUN-B40089 11/05/03 By Jay 將SSOKey轉換'_plus_'轉換回'+'號
# Modify.........: No.FUN-B50017 11/05/04 by Jay 在URL傳遞參數時,會重覆傳遞
# Modify.........: No:FUN-B40057 11/05/05 By jenjwu 增加判斷使用者資料庫權限
# Modify.........: No:MOD-B90015 11/09/05 By johung 拿掉zx19更新機制
# Modify.........: No.FUN-B80118 11/09/26 by Jay 因Genero版本升級,調整判斷式
# Modify.........: No:CHI-B50036 11/11/20 By Vampire 提示訊息依使用者語系顯示
# Modify.........: No.FUN-BA0084 11/12/15 By Jay 調整GAS版本判斷式
# Modify.........: No.FUN-BC0080 11/12/21 By Jay 新增多網域AD帳號驗證功能
# Modify.........: No:FUN-BC0002 11/12/29 By ka0132 增加從Portal登入TIPTOP程式時,UPDATE該使用者預設營運中心 
# Modify.........: No:FUN-C40035 12/05/15 By Kevin 增加 retry 機制
# Modify.........: No:MOD-C40161 12/05/18 By madey 新增zx_file lock機制
# Modify.........: No:FUN-C50055 12/05/18 By madey 調整密碼強度M規則:不可全部輸入數字
# Modify.........: No:FUN-C60025 12/06/12 By kevin 取消密碼規則
# Modify.........: NO:FUN-C70056 12/09/06 by zack 密碼過期時由強制離開改為強制修改密碼後仍可登入(但透過portal登入不做控管)
# Modify.........: NO:MOD-C70295 12/09/06 by zack 調整g_lang default規則:先check有無購買英文語言別,有的話g_lang維持1,沒有的話g_lang抓gay_file第1筆
# Modify.........: No:TQC-B90016 12/09/12 by madey 解決營運中心異常問題，清空 PARENTDB

#--FUN-B40051---start-----
#import Java class 
IMPORT JAVA java.lang.StringBuffer
IMPORT JAVA javax.naming.ldap.Control
IMPORT JAVA javax.naming.ldap.InitialLdapContext
IMPORT JAVA java.util.Hashtable
#--FUN-B40051---end-------

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS                              #FUN-C60025 start
DEFINE g_sso    LIKE type_file.chr1
END GLOBALS                          #FUN-C60025 end
 
DEFINE g_zx01	LIKE zx_file.zx01,
       g_zx10	LIKE zx_file.zx10,
       g_zz28   LIKE zz_file.zz28    #FUN-660149
DEFINE g_tryerr LIKE type_file.num5  #FUN-930042
DEFINE g_msg    STRING               #No:CHI-A70014 add
DEFINE g_forupd_sql   STRING         #FUN-BC0002
DEFINE g_pwd_expired LIKE type_file.num5 #FUN-C70056
DEFINE lr_gay       RECORD LIKE gay_file.*  # MOD-C70295
DEFINE ls_sql_gay   STRING                  # MOD-C70295
DEFINE li_cnt_gay   LIKE type_file.num5     # MOD-C70295


CONSTANT TIMEOUT INTEGER = 300
CONSTANT TRYERR SMALLINT = 5          #FUN-930042
 
MAIN
    OPTIONS
       ON CLOSE APPLICATION STOP,
       INPUT NO WRAP
    DEFER INTERRUPT 
    WHENEVER ERROR CONTINUE
 
 
    CALL cl_set_config_path()          #設定 TOPCONFIG 環境變數
    CALL cl_load_act_list("weblogin")  #載入ActionList
    CALL cl_load_style_list("weblogin")#載入 StyleList 

    #  LET g_lang = '1' #mark by MOD-C70295
    #MOD-C70295 --start-- #先check有無購買英文語言別,有的話g_lang維持1,沒有的話g_lang抓gay_file第1筆
    SELECT COUNT(*) INTO li_cnt_gay FROM gay_file WHERE gay01 = '1'
    IF li_cnt_gay = 1 THEN
        LET g_lang = '1'
    ELSE
       LET ls_sql_gay = "SELECT gay01 FROM gay_file ORDER BY gay01"
       PREPARE gay_pre FROM ls_sql_gay
       DECLARE gay_curs SCROLL CURSOR FOR gay_pre
       OPEN gay_curs
       FETCH FIRST gay_curs INTO lr_gay.gay01
       LET g_lang = lr_gay.gay01
    END IF
    #MOD-C70295 --end--

    LET g_prog = 'weblogin'
 
    CALL weblogin()
END MAIN
 
FUNCTION weblogin()
    DEFINE l_user	STRING
    DEFINE l_passwd	STRING 
    DEFINE ls_pic_url   STRING
    DEFINE l_notify     STRING
    DEFINE l_ch         base.Channel
    DEFINE l_cnt        LIKE type_file.num10   #FUN-680135 INTEGER
    DEFINE lc_gbq10     LIKE gbq_file.gbq10    #FUN-7B0126
    DEFINE l_strSOK     STRING
    DEFINE l_cmd        STRING
    DEFINE l_arg        STRING
    DEFINE l_i          LIKE type_file.num10   #FUN-680135 INTEGER
    DEFINE l_err_str    STRING
    DEFINE lc_fglserver LIKE gbq_file.gbq02    #TQC-880043
    DEFINE l_operation  STRING                 #FUN-8A0096
    DEFINE l_primaryKey LIKE gah_file.gah01    #FUN-8A0096
    DEFINE l_resetpass  LIKE type_file.num5    #FUN-930042
    DEFINE l_zx10_old   LIKE zx_file.zx10      #FUN-930042
    DEFINE l_zx10_new   LIKE zx_file.zx10      #FUN-930042
    DEFINE l_zx06       LIKE zx_file.zx06      #CHI-A70014 add
    DEFINE l_zx19       LIKE zx_file.zx19      #FUN-930042
    DEFINE l_ze03       LIKE ze_file.ze03      #FUN-B10003
    DEFINE l_ad_server  STRING                 #FUN-A80141
    DEFINE l_num        LIKE type_file.num5    #FUN-B50017  #實際傳遞參數個數 
    DEFINE l_zx         RECORD LIKE zx_file.*  #FUN-BC0002

    LET l_user = ARG_VAL(1)
    LET l_passwd = ARG_VAL(2)
 
#FUN-7B0126
    LET l_strSOK = ARG_VAL(3)
#   IF cl_null(l_user) OR cl_null(l_passwd) THEN
    CLOSE WINDOW SCREEN
    CASE
       WHEN ( NOT cl_null(l_strSOK) ) 
          DISPLAY "weblogin time_begin:",TIME

          LET g_plant = ARG_VAL(4)
          LET g_prog  = ARG_VAL(5)

          #---FUN-B50017---start---
          #因GAS 2.30.13版本會重覆傳遞參數,故需判斷是否為正確參數個數
          IF cl_get_fastcgidispatch_version() >= "2.30.13" AND cl_get_fastcgidispatch_version() < "2.32.14" THEN   #FUN-B80118   #FUN-BA0084增加判斷式
             LET l_num = NUM_ARGS() / 2
             IF l_num < 5 THEN
                LET g_prog  = ""
             END IF
          ELSE
             LET l_num = NUM_ARGS()
          END IF
          #---FUN-B50017---end-----

          LET g_gui_type = cl_fglgui()
          
          display "SSO_SERVER:",FGL_GETENV("SSO_SERVER")
          display "SSO_SOAP:",FGL_GETENV("SSO_SOAP")
    
          #------------------------------------------------------------------------
          # 進行 SOK 驗證並取得執行使用者代號
          #------------------------------------------------------------------------
          #---FUN-B10003---start-----
          #此時的l_user由於是取得URL的第一個參數
          #所以是儲存是否為"TIPTOPSSO"字串的傳入,而不是使用者帳號的傳入
          IF l_user = "TIPTOPSSO" THEN
             display "SOK:",l_strSOK
             #由於url的參數值若有'+'號在傳入時會被視為空白,所以需要再將空白字元轉換回'+'號字元
             LET l_strSOK = cl_replace_str(l_strSOK, "_plus_", "+")   #FUN-B40089 因目前已將'+'號字元先以'_plus_'取代,所以改變原先replace_str方法
             CALL cl_chk_ssokey(l_strSOK) RETURNING g_zx01,l_err_str
          ELSE
          #---FUN-B10003---end-----
             CALL web_javasso(l_strSOK) RETURNING g_zx01,l_err_str
          END IF   #FUN-B10003

          LET g_user = g_zx01                                              #CHI-B50036 add
          SELECT zx06 INTO g_lang FROM zx_file WHERE zx01 = g_user         #CHI-B50036 add
          
          display "g_zx01:",g_zx01
          IF NOT cl_null(l_err_str) THEN
             CALL web_err(l_err_str)             #TQC-880032
             EXIT PROGRAM
          ELSE
             IF cl_null(g_zx01) OR g_zx01 = "null" THEN
               #CHI-B50036 --- modify --- start ---
                LET g_msg = NULL
                LET g_msg = cl_getmsg('azz-401',g_lang)
                CALL web_err(g_msg)
                #CALL web_err("Authentication of Single Sign-on failed!")
               #CHI-B50036 --- modify ---  end  ---
                EXIT PROGRAM
             END IF
          END IF
 
          IF NOT user_validate() THEN
            #DISPLAY '有SOK，但取得的帳號不合法'   #TQC-880032
             EXIT PROGRAM
          END IF
          
          LET g_sso = "Y"        #FUN-C60025
          LET g_user = g_zx01
 
          SELECT zx06 INTO g_lang FROM zx_file WHERE zx01 = g_user
          
          #---FUN-AA0003---start------------------------------------------------
          #SELECT zx10 INTO g_zx10 FROM zx_file WHERE zx01 = g_user         #FUN-C60025
          #LET g_zx10= cl_uszx_10decod(g_zx10)                              #FUN-C60025
          IF NOT pwd_validate() THEN
             EXIT PROGRAM
          END IF
          #---FUN-AA0003---end--------------------------------------------------

          IF NOT cl_null(g_plant) THEN   #FUN-AB0111 
          
             #FUN-B40057-start-
             IF NOT s_chkdbs(g_user,g_plant,g_lang) THEN 
                 EXIT PROGRAM
             END IF
             #FUN-B40057-end- 

              IF NOT cl_null(g_prog) THEN
                #FOR l_i = 6 TO NUM_ARGS()        #FUN-B50017 mark
                 FOR l_i = 6 TO l_num              #FUN-B50017 因應可能發生參數個數重覆傳遞狀況 
                    LET l_arg = l_arg," '",ARG_VAL(l_i),"'"
                 END FOR
             #---FUN-AB0111---start-----
              ELSE
                LET g_prog = "udm_tree"
                LET l_arg = " '' ", FGL_GETPID()
             END IF
             #---FUN-AB0111---end-------

             #---------------------------------------------------------------------
             # 抓取對應資料庫 azp.* 資料
             #---------------------------------------------------------------------
             SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01 = g_plant

             #---FUN-B10003---start-----
             IF cl_null(g_dbs) THEN 
                SELECT ze03 INTO l_ze03 FROM ze_file 
                  WHERE ze01 = "mfg9142" AND ze02 = g_lang         
                CALL web_err(l_ze03) 
                EXIT PROGRAM
             END IF
             #---FUN-B10003---end-------
  #           CALL cl_ins_del_sid(2) #FUN-980030   #FUN-990069
             CALL cl_ins_del_sid(2,'') #FUN-980030   #FUN-990069
             CLOSE DATABASE 
             DATABASE g_dbs
    #         CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
             CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
             IF SQLCA.SQLCODE THEN
            #    CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069
                CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
                CLOSE DATABASE
                DATABASE ds
            #    CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
                CALL cl_ins_del_sid(1,'') #FUN-980030  #FUN-990069
                CALL cl_err3("sel","azp_file",g_plant,"","100","","sel azp:",1) 
                DISPLAY g_plant,":(azp_file) No record, related data or Master found !"
                EXIT PROGRAM
             END IF
             
#No.TQC-870015 --mark start--
             #---------------------------------------------------------------------
             # 更新 zxx_file 檔案, 以供後續執行作業程式選用正確的資料庫
             #---------------------------------------------------------------------
#            LET lc_zxx02 = fgl_getenv('FGLSERVER')
#            INSERT INTO zxx_file (zxx01, zxx02, zxx03) 
#                          VALUES (g_user, lc_zxx02, g_plant)
#            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-790021
#               UPDATE zxx_file SET zxx03 = g_plant
#                WHERE zxx01 = g_user AND zxx02 = lc_zxx02
#            END IF
#No.TQC-870015 ---mark end---
             
             #---------------------------------------------------------------------
             # 更新 gbq_file 檔案, 以供後續執行作業程式選用正確的資料庫(for GP 5.0)
             #---------------------------------------------------------------------
             #No.TQC-880043 --start--
             LET lc_fglserver = FGL_GETENV("FGLSERVER")
             LET lc_fglserver = cl_process_chg_iprec(lc_fglserver)
             #No.TQC-880043 ---end---
             LET lc_gbq10 = g_plant CLIPPED, "/", g_plant CLIPPED
             INSERT INTO gbq_file (gbq01, gbq02, gbq03, gbq04, gbq06, gbq10, gbq11)          #FUN-950082
#                          VALUES (FGL_GETPID(), lc_zxx02, g_user,g_prog , 2, lc_gbq10)      #No.TQC-880043 mark
                           VALUES (FGL_GETPID(), lc_fglserver, g_user,g_prog , 2, lc_gbq10,  #No.TQC-880043 modify
                                   cl_used_ap_hostname() )                                   #FUN-950082
             IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
                UPDATE gbq_file SET gbq10 = lc_gbq10
#                WHERE gbq02 = lc_zxx02 AND gbq03 = g_user   #No.TQC-880043 mark
                 WHERE gbq02 = lc_fglserver AND gbq03 = g_user   #No.TQC-880043 modify
             END IF

             #---FUN-BC0002-----start----------
             LET g_forupd_sql = "SELECT * FROM zx_file WHERE zx01 = ? FOR UPDATE " 
             DECLARE weblogin_cur CURSOR FROM g_forupd_sql 

             BEGIN WORK
             OPEN weblogin_cur USING g_zx01 
             IF SQLCA.sqlcode THEN
                LET l_err_str = cl_getmsg(SQLCA.sqlcode, g_lang)  
                ROLLBACK WORK
             ELSE
                FETCH weblogin_cur INTO l_zx.*               # 對DB鎖定
                IF SQLCA.sqlcode THEN
                   LET l_err_str = cl_getmsg(SQLCA.sqlcode, g_lang)
                   ROLLBACK WORK
                ELSE
                  UPDATE zx_file SET zx08 = g_plant WHERE zx01 = g_user
                  IF SQLCA.sqlcode THEN
                     LET l_err_str = cl_getmsg(SQLCA.sqlcode, g_lang)
                     ROLLBACK WORK
                  ELSE
                     COMMIT WORK
                  END IF
                END IF
             END IF
             CLOSE weblogin_cur
             
             IF NOT cl_null(l_err_str) THEN
                CALL web_err(l_err_str)
                LET l_err_str = ""
             END IF  
             #---FUN-BC0002-----end------------

             #--FUN-8A0096--start---
             #---------------------------------------------------------------------
             # For Product Portal 待辦事項
             #---------------------------------------------------------------------
             SELECT * INTO g_aza.* FROM aza_file WHERE aza01='0'
             LET g_today = TODAY
             LET l_operation = ARG_VAL(1)
             LET l_operation = l_operation.toLowerCase()
             LET l_primaryKey = ARG_VAL(2)
             IF l_operation = "todolist" THEN
                UPDATE gah_file SET gah09 = TODAY WHERE gah01= l_primaryKey
                #------------------------------------------------------------------
                # 呼叫 Product Portal 完成代辦事項結案
                #------------------------------------------------------------------
                CALL cl_ppcli_CloseToDoList(l_primaryKey CLIPPED)
             END IF
             #--FUN-8A0096--end---
             LET l_cmd = g_prog,l_arg
             display l_cmd
             DISPLAY "weblogin time_end:",TIME
             CALL cl_cmdrun_wait(l_cmd) 
             EXIT PROGRAM
          END IF   
 
       WHEN (( NOT cl_null(l_user)) AND (NOT cl_null(l_passwd))) 
          LET g_zx01 = l_user
          LET g_zx10 = l_passwd
          IF NOT user_validate() THEN
             EXIT PROGRAM
          END IF
          IF NOT pwd_validate() THEN
             EXIT PROGRAM
          END IF
          LET g_user = g_zx01
       
       OTHERWISE
          RUN "fglWrt -u"                #清除占用License的情況  #FUN-B30037
          OPEN WINDOW weblogin_w WITH FORM "azz/42f/weblogin"
             ATTRIBUTE(STYLE = "login")
 
          CLOSE WINDOW SCREEN
 
          LET ls_pic_url = FGL_GETENV("FGLASIP") || "/tiptop/pic/login.jpg"
          DISPLAY ls_pic_url TO FORMONLY.logo
 
          LET g_tryerr = 0

          #FUN-AB0079
          IF NOT cl_check_license() THEN 
            #CHI-B50036 --- modify --- start ---
             LET g_msg = NULL
             LET g_msg = cl_getmsg('azz1112',g_lang)
             CALL web_err(g_msg)
             #CALL web_err("INFO: Login Users Exceed Than TIPTOP License Allowed.\n Please Re-try Later or Cantact with System Administrators.")
            #CHI-B50036 --- modify ---  end  ---
             EXIT PROGRAM 
          END IF 
 
          INPUT g_zx01, g_zx10 WITHOUT DEFAULTS
           FROM FORMONLY.zx01, FORMONLY.zx10 ATTRIBUTE(UNBUFFERED)
 
              AFTER INPUT
                  IF INT_FLAG THEN 
                     EXIT INPUT 
                  END IF
                  
                  #-No.FUN-A80141 --begin--
                  LET l_ad_server = FGL_GETENV("AD_SERVER") CLIPPED
                  IF cl_null(l_ad_server) THEN
                     LET l_ad_server = 'N'
                  END IF
                  IF l_ad_server = 'Y' THEN
                     CALL web_javaad(g_zx01, g_zx10) RETURNING l_err_str   #透過AD SERVER驗證帳號、密碼

                     IF NOT cl_null(l_err_str) THEN
                        CALL web_err(l_err_str)
                        NEXT FIELD zx01
                     END IF

                     #檢查帳號是否不存在zx_file或為無效帳號
                     SELECT COUNT(zx01) INTO l_cnt FROM zx_file
                       WHERE zx01 = g_zx01 AND zxacti = "Y" 
                     IF l_cnt = 0 THEN
                       #CHI-B50036 --- modify --- start ---
                        LET g_msg = NULL
                        LET g_msg = cl_getmsg('azz1113',g_lang)
                        CALL web_err(g_msg)
                        #CALL web_err('zx_file get error. User account does not exist zx_file!')
                       #CHI-B50036 --- modify ---  end  ---
                        NEXT FIELD zx01
                     END IF
                  ELSE
                  #-No.FUN-A80141 --end--
                     IF NOT user_validate() THEN
                        IF g_tryerr >= TRYERR THEN LET INT_FLAG=TRUE EXIT INPUT END IF
                        NEXT FIELD zx01
                     END IF
                     IF NOT pwd_validate() THEN
                        IF g_tryerr >= TRYERR THEN LET INT_FLAG=TRUE EXIT INPUT END IF
                        NEXT FIELD zx10
                     END IF
                  END IF    #-No.FUN-A80141
 
              ON IDLE 30    #g_idle_seconds   #FUN-660149   TQC-880032
                 #CALL cl_on_idle()           
                 #CONTINUE INPUT
                 LET INT_FLAG = TRUE
                #CHI-B50036 --- modify --- start ---
                 LET g_msg = NULL
                 LET g_msg = cl_getmsg('azz1114',g_lang)
                 CALL web_err(g_msg)
                 #CALL web_err('Timeout for launching the program!')  #TQC-880032
                #CHI-B50036 --- modify ---  end  ---
                 EXIT INPUT                   #TQC-880032
 
          END INPUT
 
          CLOSE WINDOW weblogin_w
          CALL ui.Interface.refresh()
          IF INT_FLAG THEN 
             IF g_tryerr >= TRYERR THEN
               #CHI-B50036 --- modify --- start ---
                LET g_msg = NULL
                LET g_msg = cl_getmsg('azz1115',g_lang)
                LET g_msg = g_msg , g_tryerr USING "#&"
                LET g_msg = g_msg , cl_getmsg('azz1116',g_lang)
                CALL web_err(g_msg)
                #LET l_cmd = "Sorry, Error More Than ", g_tryerr USING "#&",  " Times!\n\n"
                #LET l_cmd = l_cmd,"If You Forget Username or Password, Please Confirm With System Administrators."
                #CALL web_err(l_cmd)
               #CHI-B50036 --- modify ---  end  ---
             END IF
             LET INT_FLAG = FALSE
             EXIT PROGRAM 
          END IF
          LET g_user = g_zx01
    END CASE     #FUN-AA0003將下面的END CASE往上挪,以利無論何種方式進入都會往下繼續檢查密碼各機制
 
          #FUN-930042 檢視是否應重設密碼
          LET l_resetpass = FALSE
          IF g_pwd_expired THEN LET l_resetpass = TRUE END IF #FUN-C70056 密碼過期要重設密碼
          LET l_zx06 = NULL            #CHI-A70014 add
          SELECT zx06,zx10,zx19 INTO l_zx06,l_zx10_old,l_zx19 FROM zx_file   #CHI-A70014 add zx06
           WHERE zx01 = g_zx01
 
           IF cl_null(l_zx06) THEN LET l_zx06 = '1' END IF       #CHI-A70014 add

          #密碼為空值
          #IF NOT l_resetpass THEN    #FUN-A80141 mark
          IF NOT l_resetpass AND l_ad_server <> 'Y' THEN     #FUN-A80141增加AD驗證判斷
             IF l_zx10_old IS NULL OR l_zx10_old= " " THEN
               #---------------CHI-A70014 modify
                 LET g_msg = NULL
                 LET g_msg = cl_getmsg('lib-061',l_zx06)
                 CALL web_err(g_msg)
                #CALL web_err("System Upgrade Security Level, Please Change Your Password For Required!")
               #---------------CHI-A70014 end
                LET l_resetpass = TRUE
             END IF
          END IF
 
          #密碼強度不符合現行規則
          #IF NOT l_resetpass THEN    #FUN-A80141 mark
          IF NOT l_resetpass AND l_ad_server <> 'Y' THEN     #FUN-A80141增加AD驗證判斷
             IF NOT weblogin_ver_passwd() THEN
               #---------------CHI-A70014 modify
                 LET g_msg = NULL
                 LET g_msg = cl_getmsg('lib-061',l_zx06)
                 CALL web_err(g_msg)
                #CALL web_err("System Upgrade Security Level, Please Change Your Password For Required!")
               #---------------CHI-A70014 end
                LET l_resetpass = TRUE
             END IF
          END IF
 
          #zx19強制要求改密碼
          #IF NOT l_resetpass THEN    #FUN-A80141 mark
          IF NOT l_resetpass AND l_ad_server <> 'Y' THEN     #FUN-A80141增加AD驗證判斷
             IF l_zx19 IS NOT NULL AND l_zx19 = "Y" THEN
               #---------------CHI-A70014 modify
                 LET g_msg = NULL
                 LET g_msg = cl_getmsg('lib-062',l_zx06)
                 CALL web_err(g_msg)
                #CALL web_err("System Needs User to Change Password!")
               #---------------CHI-A70014 end
                LET l_resetpass = TRUE
             END IF
          END IF
 
          IF l_resetpass THEN
             CALL FGL_SETENV("WEBUSER",g_zx01 CLIPPED)
             CALL cl_cmdrun_wait('webpasswd')
             CALL FGL_SETENV("PARENTDB","")                         #TQC-B90016
             display "webpasswd parentdb:",  FGL_GETENV("PARENTDB") #TQC-B90016

             SELECT zx10 INTO l_zx10_new FROM zx_file WHERE zx01 = g_zx01
             IF l_zx10_old = l_zx10_new OR l_zx10_new IS NULL THEN
               #---------------CHI-A70014 modify
                 LET g_msg = NULL
                 LET g_msg = cl_getmsg('lib-063',l_zx06)
                 CALL web_err(g_msg)
                #CALL web_err("Password Not Changed!, Please Re-Login Again")
               #---------------CHI-A70014 end
                EXIT PROGRAM 
             END IF
          END IF
 
    #END CASE     ##FUN-AA0003將END CASE往上挪
#END FUN-7B0126
 
    LET l_notify = FGL_GETPID()
    RUN "rm -f " || l_notify
    RUN "udm7 weblog " || g_user || " " || l_notify WITHOUT WAITING  #FUN-620044, FUN-690056
    
    DISPLAY "weblogin time_end:",TIME
 
    #Wait for menu program has been started, because of RUN ... WITHOUT WAITTING
    LET l_ch = base.Channel.create()
    LET l_cnt = 0
    WHILE TRUE
        CALL l_ch.openFile(l_notify, "r")
        IF NOT STATUS THEN
           RUN "rm -f " || l_notify
           EXIT WHILE
        END IF
        CALL l_ch.close()                  #FUN-C40035
        SLEEP 1
        LET l_cnt = l_cnt + 1
        IF l_cnt = TIMEOUT THEN
          #CHI-B50036 --- modify --- start ---
           LET g_msg = NULL
           LET g_msg = cl_getmsg('azz1114',g_lang)
           CALL web_err(g_msg)
           #CALL web_err('Timeout for launching menu program!')  #TQC-880032
          #CHI-B50036 --- modify ---  end  ---
           EXIT WHILE
        END IF
    END WHILE
    CALL l_ch.close()
    --#
END FUNCTION
 
FUNCTION user_validate()
    DEFINE l_cnt	LIKE type_file.num5    #No.FUN-680135 SMALLINT
    DEFINE l_zx		RECORD LIKE zx_file.*
    DEFINE l_gbt	RECORD LIKE gbt_file.*    #FUN-830011
 
    #帳號不存在或無效帳號
    SELECT COUNT(zx01) INTO l_cnt FROM zx_file
     WHERE zx01 = g_zx01
       AND zxacti = "Y"    #FUN-830011
    IF l_cnt = 0 THEN
       #CHI-B50036 --- modify --- start ---
       LET g_msg = NULL
       LET g_msg = cl_getmsg('lib-064',g_lang)
       CALL web_err(g_msg)
       #CALL web_err('Invalid user name or password!')   #TQC-880032
       #CHI-B50036 --- modify ---  end  ---
       LET g_tryerr = g_tryerr + 1
       RETURN FALSE
    END IF
 
    SELECT * INTO l_gbt.* FROM gbt_file WHERE gbt00 = "0"
    SELECT * INTO l_zx.* FROM zx_file WHERE zx01 = g_zx01
 
    #帳號Try Error次數太多被lock
    IF l_gbt.gbt10 IS NOT NULL AND l_gbt.gbt10 > 0 THEN
       IF l_zx.zx20 >= l_gbt.gbt10 THEN
          #CHI-B50036 --- modify --- start ---
          LET g_msg = NULL
          LET g_msg = cl_getmsg('azz1117',g_lang)
          LET g_msg = g_msg , l_gbt.gbt10
          LET g_msg = g_msg , cl_getmsg('azz1118',g_lang)
          CALL web_err(g_msg)
          #CALL web_err('Password Error More Than '|| l_gbt.gbt10 ||' Times.\nYour account has been locked!\Apply For a New Password!')        #FUN-930042
          #CHI-B50036 --- modify ---  end  ---
          RETURN FALSE
       END IF
    END IF
 
    #帳號 expired
    IF NOT cl_null(l_zx.zx18) AND l_zx.zx18 < TODAY THEN
       #CHI-B50036 --- modify --- start ---
       LET g_msg = NULL
       LET g_msg = cl_getmsg('azz1119',g_lang)
       CALL web_err(g_msg)
       #CALL web_err('Your account has expired!')        #FUN-930042
       #CHI-B50036 --- modify ---  end  ---
       RETURN FALSE
    END IF
 
    RETURN TRUE
END FUNCTION
 
FUNCTION pwd_validate()
    DEFINE l_zx		RECORD LIKE zx_file.*
    DEFINE l_gbt	RECORD LIKE gbt_file.*    #FUN-830011
    DEFINE ls_tmp       STRING
    DEFINE ls_zx_sql    STRING                    #MOD-C40161
 
    SELECT * INTO l_gbt.* FROM gbt_file WHERE gbt00 = "0"
    #SELECT * INTO l_zx.* FROM zx_file WHERE zx01 = g_zx01 #MOD-C40161 mark

    #MOD-C40161 --start--
    LET ls_zx_sql= "SELECT * FROM zx_file WHERE zx01 =? FOR UPDATE"
    LET ls_zx_sql= cl_forupd_sql(ls_zx_sql)
    DISPLAY "ls_zx_sql: ",ls_zx_sql
    DECLARE zx_u_curl CURSOR FROM ls_zx_sql
    BEGIN WORK

    OPEN zx_u_curl USING g_zx01
    IF SQLCA.sqlcode THEN
       LET g_msg = SQLCA.sqlcode
       SELECT zx06 into g_lang FROM zx_file WHERE zx01 = g_zx01
       LET g_msg = "OPEN zx_file: ",g_msg,"  ",cl_getmsg(g_msg,g_lang)
       CALL web_err(g_msg)
       ROLLBACK WORK
       RETURN FALSE
    END IF

    FETCH zx_u_curl INTO l_zx.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       LET g_msg = NULL
       LET g_msg = "FETCH zx_file:",SQLCA.sqlcode
       CALL web_err(g_msg)
       ROLLBACK WORK
       CLOSE zx_u_curl
       RETURN FALSE
    END IF
    #MOD-C40161 --end--
 
    #密碼錯誤
    IF NOT cl_webuser_validate(g_zx01,g_zx10) THEN      #FUN-910094
      #CALL cl_err('Invalid user name or password', '!', 1)
     #---------------CHI-A70014 modify
       LET g_msg = NULL
       LET g_msg = cl_getmsg('lib-064',l_zx.zx06)
       CALL web_err(g_msg)
      #CALL web_err('Invalid user name or password!')   #TQC-880032
     #---------------CHI-A70014 end
       LET g_tryerr = g_tryerr + 1
       IF l_gbt.gbt10 IS NOT NULL AND l_gbt.gbt10 > 0 THEN
          LET l_zx.zx20 = l_zx.zx20 + 1
          UPDATE zx_file SET zx20 = l_zx.zx20 WHERE zx01 = g_zx01
       END IF
       COMMIT WORK             #MOD-C40161
       CLOSE zx_u_curl         #MOD-C40161
       RETURN FALSE
    END IF
 
    #密碼 expired FUN-570135  #FUN-830011
    IF cl_null(l_zx.zx17) THEN
       LET l_zx.zx17 = 0
    END IF
    IF l_gbt.gbt01 = "2" AND l_gbt.gbt03 <> "0" THEN
       LET l_zx.zx17 = l_zx.zx17 + 1    #設定為依登入次數控管時才開始計次
    END IF
 
    IF cl_null(l_zx.zx16) THEN
       UPDATE zx_file SET zx16 = TODAY, zx17 = l_zx.zx17
        WHERE zx01=g_zx01
    ELSE
       UPDATE zx_file SET zx17 = l_zx.zx17
        WHERE zx01=g_zx01
    END IF
 
    #開啟密碼管制, 依週期管制
    LET g_pwd_expired = FALSE #FUN-C70056 檢查密碼是否過期
    IF g_sso = "Y" THEN       #FUN-C70056 portal登入不做控管
    ELSE                      #FUN-C70056  
    IF l_gbt.gbt01 = "1" AND l_gbt.gbt02 <> "0" THEN
       IF l_zx.zx16 + l_gbt.gbt02 < TODAY THEN
         LET g_pwd_expired = TRUE            #FUN-C70056
          #CHI-B50036 --- modify --- start ---
          LET g_msg = NULL
          LET g_msg = cl_getmsg('azz1120',g_lang)
          CALL web_err(g_msg)
          #CALL web_err('Your password has expired! \nApply for a new password')
         #CHI-B50036 --- modify ---  end  ---
          #COMMIT WORK             #MOD-C40161 #mark by FUN-C70056 
          #CLOSE zx_u_curl         #MOD-C40161 #mark by FUN-C70056
          #RETURN FALSE                        #mark by FUN-C70056
       END IF
       #IF l_zx.zx16 + l_gbt.gbt02 - l_gbt.gbt04 < TODAY THEN #mark by FUN-C70056 
       IF l_zx.zx16 + l_gbt.gbt02 - l_gbt.gbt04 < TODAY AND g_pwd_expired = FALSE THEN #FUN-C70056 密碼過期不進入
          #CHI-B50036 --- modify --- start ---
          LET g_msg = NULL
          LET g_msg = cl_getmsg('azz1121',g_lang)
          LET g_msg = g_msg ,((l_zx.zx16 + l_gbt.gbt02) - TODAY) UNITS DAY
          LET g_msg = g_msg , cl_getmsg('azz1122',g_lang)
          CALL web_err(g_msg)
          #LET ls_tmp = "Your password will be expired in ",
          #              ((l_zx.zx16 + l_gbt.gbt02) - TODAY) UNITS DAY,
          #             " days.\nPlease update before been disable."
          #CALL web_err(ls_tmp)
         #CHI-B50036 --- modify ---  end  ---
       END IF
    END IF
    END IF #FUN-C70056
 
    #開啟密碼管制, 依次數管制
   IF g_sso = "Y" THEN #FUN-C70056 portal登入不做控管 
   ELSE                #FUN-C70056
   IF l_gbt.gbt01 = "2" AND l_gbt.gbt03 <> "0" THEN
       IF l_gbt.gbt03 < l_zx.zx17 THEN
          LET g_pwd_expired = TRUE            #FUN-C70056
          #CHI-B50036 --- modify --- start ---
          LET g_msg = NULL
          LET g_msg = cl_getmsg('azz1120',g_lang)
          CALL web_err(g_msg)
          #CALL web_err('Your password has expired! Apply for a new password')
         #CHI-B50036 --- modify ---  end  ---
         # COMMIT WORK             #MOD-C40161 #mark by FUN-C70056 
         # CLOSE zx_u_curl         #MOD-C40161 #mark by FUN-C70056
         # RETURN FALSE                        #mark by FUN-C70056
       END IF
       #IF l_gbt.gbt03 - l_zx.zx17 <= l_gbt.gbt04 THEN #mark by FUN-C70056
        IF l_gbt.gbt03 - l_zx.zx17 <= l_gbt.gbt04 AND g_pwd_expired = FALSE THEN #FUN-C70056 密碼過期不進入
          #CHI-B50036 --- modify --- start ---
          LET g_msg = NULL
          LET g_msg = cl_getmsg('azz1121',g_lang)
          LET g_msg = g_msg , (l_gbt.gbt03 - l_zx.zx17)
          LET g_msg = g_msg , cl_getmsg('azz1122',g_lang)
          CALL web_err(g_msg) #FUN-C70056
          #LET ls_tmp = "Your password will be expired after next ",
          #             (l_gbt.gbt03 - l_zx.zx17), " login times.\n",
          #             "Please update before been disable."
          #CALL web_err(ls_tmp) #mark by FUN-C70056
         #CHI-B50036 --- modify ---  end  ---
       END IF
    END IF
  END IF #FUN-C70056
 
    #若有開啟試誤記錄, 則成功登入後清空
    IF l_gbt.gbt10 IS NOT NULL AND l_gbt.gbt10 > 0 THEN
#      LET l_zx.zx19 = "N"   #MOD-B90015 mark
       LET l_zx.zx20 = 0
#      UPDATE zx_file SET zx19 = l_zx.zx19, zx20 = l_zx.zx20   #MOD-B90015 mark
       UPDATE zx_file SET zx20 = l_zx.zx20                     #MOD-B90015
        WHERE zx01 = g_zx01
    END IF

    COMMIT WORK             #MOD-C40161
    CLOSE zx_u_curl         #MOD-C40161
 
    RETURN TRUE
END FUNCTION
 
#FUN-7B0126
#----------------------------
#取得 SSO 認證的 User
#----------------------------
FUNCTION web_javasso(p_strSOK)
DEFINE p_strSOK   STRING
DEFINE l_cmd      STRING
DEFINE lch_cmd    base.Channel
DEFINE l_user     STRING
DEFINE l_str      STRING
DEFINE l_xml      STRING
DEFINE l_err_str  STRING
DEFINE l_ch       base.Channel,
      l_xmlFile  STRING,
      l_doc      om.DomDocument,
      l_root     om.DomNode,
      l_list     om.NodeList,
      l_node     om.DomNode
DEFINE l_i        INTEGER
DEFINE l_file     STRING            #FUN-AA0003
DEFINE channel    base.Channel      #FUN-AA0003
 
   DISPLAY "javasso time_begin:",TIME
   LET l_cmd="sh ",FGL_GETENV("DS4GL"),"/bin/javasso/cmd.sh ",
             p_strSOK ," 2>/dev/null"
   LET lch_cmd = base.Channel.create()
   
   FOR l_i = 1 TO 3                          #FUN-C40035
      CALL lch_cmd.openPipe(l_cmd, "r")
      WHILE lch_cmd.read(l_str)
           display l_str
           LET l_xml = l_xml,l_str
      END WHILE
      CALL lch_cmd.close()
      display "xml:",l_xml
      display "l_cmd:",l_cmd

      #FUN-C40035 start
      IF( l_xml.getIndexOf("Error occurred",1) OR
         l_xml.getIndexOf("insufficient memory",1) )  THEN
        DISPLAY "WARNING:retry sleep 3"
        SLEEP 3
      ELSE
        EXIT FOR
      END IF
   END FOR  #FUN-C40035 end
 
   IF NOT cl_null(l_xml) THEN
      #-----------------------------------------------------------------------#
      # 產生 XML 暫存檔                                                       #
      #-----------------------------------------------------------------------#
      LET l_ch = base.Channel.create()
      LET l_xmlFile = fgl_getenv("TEMPDIR"), "/",
                      "ssoclient_", FGL_GETPID() USING '<<<<<<<<<<', ".xml"
      display l_xmlFile
      CALL l_ch.openFile(l_xmlFile, "w")
      CALL l_ch.setDelimiter("")                 #FUN-8A0113
      CALL l_ch.write(l_xml)
      CALL l_ch.close()
 
      #-----------------------------------------------------------------------#
      # 讀取 XML 文件                                                         #
      #-----------------------------------------------------------------------#
      LET l_doc = om.DomDocument.createFromXmlFile(l_xmlFile)
      #RUN "rm -f " || l_xmlFile || " >/dev/null 2>&1"
      INITIALIZE l_root TO NULL
      IF l_doc IS NULL THEN
        #CHI-B50036 --- modify --- start ---
         LET l_err_str = NULL
         LET l_err_str = cl_getmsg('azz-401',g_lang)
         #LET l_err_str = "Authentication of Single Sign-on failed!"   #FUN-AA0003 為了往下繼續執行log寫入,所以此處已不 RETURN "",""
        #CHI-B50036 --- modify ---  end  ---
      ELSE                                                            #FUN-AA0003 將原本END IF改成ELSE,以利繼續往下執行紀錄log,下面ELSE之內容往下調整縮排
         LET l_root = l_doc.getDocumentElement()
         LET l_list = l_root.selectByTagName("cas:user")
         IF l_list.getLength() > 0 THEN
            LET l_node = l_list.item(1)
            LET l_node = l_node.getFirstChild()
            LET l_user = l_node.getattribute("@chars")
         ELSE
            LET l_list = l_root.selectByTagName("cas:exception")
            IF l_list.getLength() >0 THEN
               LET l_node = l_list.item(1)
               LET l_node = l_node.getFirstChild()
               LET l_err_str = l_node.getattribute("@chars")
            END IF
         END IF
      END IF                                                          #FUN-AA0003 因將原本END IF改成ELSE,所以此處需多加END IF
   END IF
 
   DISPLAY "javasso time_end:",TIME
   LET g_user = l_user                                         #CHI-B50036 add
   SELECT zx06 INTO g_lang FROM zx_file WHERE zx01 = g_user    #CHI-B50036 add

   #---FUN-AA0003---start------------------------------------------------
   IF cl_null(l_xml) THEN
     #CHI-B50036 --- modify --- start ---
      LET l_err_str = NULL
      LET l_err_str = cl_getmsg('azz-401',g_lang)
      #LET l_err_str = "Authentication of Single Sign-on failed!"
     #CHI-B50036 --- modify ---  end  ---
   END IF
   #記錄此次呼叫的 method name
   LET l_file = "aws_ppcli-", TODAY USING 'YYYYMMDD', ".log"

   LET channel = base.Channel.create()
   CALL channel.setDelimiter(NULL)
   CALL channel.openFile(l_file,  "a")
   IF STATUS = 0 THEN
      CALL channel.setDelimiter("")
      LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
      CALL channel.write(l_str)
      CALL channel.write("")
      LET l_str = "Method: web_javasso."
      CALL channel.write(l_str)
      CALL channel.write("")
      LET l_str = "SSO_SOAP:", FGL_GETENV("SSO_SOAP")
      CALL channel.write(l_str)
      CALL channel.write("") 
      LET l_str = "Request:", l_cmd
      CALL channel.write(l_str)
      CALL channel.write("")
      LET l_str = "Response:", l_xml
      CALL channel.write(l_str)
      CALL channel.write("")
      LET l_str = "exception:", l_err_str
      CALL channel.write(l_str)
      CALL channel.write("#------------------------------------------------------------------------------#")

      CALL channel.write("")
      CALL channel.close()

      LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null"
      RUN l_cmd
      RUN "rm -f " || l_xmlFile || " >/dev/null 2>&1"           #FUN-C40035
   ELSE
      DISPLAY "Can't open log file."
   END IF
   CALL channel.close()
   
   #將上面讀檔錯誤直接return移來這裡
   IF l_doc IS NULL THEN
      RETURN "",""
   END IF
   #---FUN-AA0003---end--------------------------------------------------

   RETURN l_user,l_err_str
END FUNCTION
#END FUN-7B0126
 
FUNCTION web_err(ls_msg)
 
   DEFINE ls_msg   STRING
   DEFINE lw_curr  ui.Window
 
   OPEN WINDOW w_err WITH FORM "lib/42f/cl_err_msg"
        ATTRIBUTE(STYLE="show_log", TEXT="Warning")
   LET lw_curr = ui.Window.getCurrent()
   CALL lw_curr.setText("Warning")
   CALL cl_set_comp_visible("group02", FALSE)
   DISPLAY ls_msg CLIPPED TO ze03
 
   MENU ""
        ON IDLE 30
           EXIT MENU
        ON ACTION ok
           EXIT MENU
   END MENU
 
   CLOSE WINDOW w_err
 
END FUNCTION
 
 
 
FUNCTION weblogin_ver_passwd()
 
   DEFINE l_gbt   RECORD LIKE gbt_file.*
   DEFINE li_cnt  LIKE type_file.num5
   DEFINE li_ord  LIKE type_file.num5
   DEFINE ls_tmp  STRING
   DEFINE li_num_cnt  LIKE type_file.num5 #FUN-C50055
 
   LET ls_tmp = g_zx10 CLIPPED
   SELECT * INTO l_gbt.* FROM gbt_file WHERE gbt00="0"
 
   IF l_gbt.gbt05 > 0 THEN
      IF ls_tmp.getLength() < l_gbt.gbt05 THEN RETURN FALSE END IF
   END IF
 
   #FUN-850055  Weak Control
   IF l_gbt.gbt06 = "Y" OR l_gbt.gbt06 = "M" OR l_gbt.gbt06 = "S" THEN
      IF ls_tmp.getIndexOf(g_user,1) THEN RETURN FALSE END IF
   END IF
 
   #FUN-850055  Middle Control
   IF l_gbt.gbt06 = "M" OR l_gbt.gbt06 = "S" THEN
      WHILE TRUE
         FOR li_cnt=1 TO ls_tmp.getLength()
            LET li_ord = ORD(ls_tmp.subString(li_cnt,li_cnt)) 
            IF li_ord >= 48 AND li_ord <= 57 THEN
               EXIT WHILE
            END IF
         END FOR 
         RETURN FALSE
      END WHILE

      #不可全部輸入數字 #FUN-C50055 --start--
      LET li_num_cnt = 0
      FOR li_cnt=1 TO ls_tmp.getLength()
         LET li_ord = ORD(ls_tmp.subString(li_cnt,li_cnt))
         IF li_ord >= 48 AND li_ord <= 57 THEN
            LET li_num_cnt = li_num_cnt + 1
         END IF
      END FOR
      IF li_num_cnt = ls_tmp.getLength() THEN RETURN FALSE  END IF
      #不可全部輸入數字 #FUN-C50055 --end--
   END IF
 
   #FUN-850055  Strong Control
   IF l_gbt.gbt06 = "S" THEN
      WHILE TRUE
         FOR li_cnt=1 TO ls_tmp.getLength()
            LET li_ord = ORD(ls_tmp.subString(li_cnt,li_cnt)) 
            IF li_ord < 48 OR
              (li_ord > 57 AND li_ord < 65) OR 
              (li_ord > 90 AND li_ord < 97) OR li_ord > 122 THEN
               EXIT WHILE
            END IF
         END FOR 
         RETURN FALSE
      END WHILE
   END IF
 
   RETURN TRUE
END FUNCTION
 
 
#FUN-A80141
#------------------------------------------------------------------
#將使用者輸入之帳號、密碼透過java程式送到AD SERVER驗證
#傳回結果:(1)0:失敗. (2)1:成功. (3)還有其他錯誤代碼
#------------------------------------------------------------------
FUNCTION web_javaad(p_zx01, p_zx10)
DEFINE p_zx01     LIKE zx_file.zx01
DEFINE p_zx10     LIKE zx_file.zx10
DEFINE l_zx06     LIKE zx_file.zx06
DEFINE l_ze01     LIKE ze_file.ze01
DEFINE l_cmd      STRING
DEFINE lch_cmd    base.Channel
DEFINE l_status   STRING
DEFINE l_str      STRING
DEFINE l_xml      STRING
DEFINE l_err_str  STRING
DEFINE l_ch       base.Channel,
       l_xmlFile  STRING,
       l_doc      om.DomDocument,
       l_root     om.DomNode,
       l_list     om.NodeList,
       l_node     om.DomNode
DEFINE l_ip       STRING
DEFINE l_port     STRING
DEFINE l_domain   STRING
DEFINE l_file     STRING
DEFINE channel    base.Channel
DEFINE l_desc     STRING         #FUN-BC0080

   LET l_err_str = ''

   #抓取環境變數設定之AD資訊
   LET l_ip = FGL_GETENV("AD_ADDR")
   LET l_domain = FGL_GETENV("AD_DOMAIN")

   #抓取AD server port
   LET l_port = l_ip.subString(l_ip.getIndexOf(':', 1) + 1, l_ip.getLength())
   #抓取AD server IP
   LET l_ip = l_ip.subString(1, l_ip.getIndexOf(':', 1) - 1)

   #抓取使用者慣用語言別
   SELECT zx06 INTO l_zx06 FROM zx_file WHERE zx01 = p_zx01

   #若抓取不到以目前使用語言別為主
   IF cl_null(l_zx06) THEN
      LET l_zx06 = g_lang
   END IF

   IF cl_null(l_ip) OR cl_null(l_port) OR cl_null(l_domain) THEN
      LET l_err_str = cl_getmsg('azz1060', l_zx06)     #與AD整合帳號驗證參數未設定,請設定AD Server IP、AD Serve
   ELSE
      DISPLAY "javaad time_begin:",TIME
      #--FUN-B40051---start-----
      #改寫成Genero Java Interface實作
      ##執行$DS4GL/bin/javaad下的cmd.sh shell
      ##傳遞參數:(1)AD SERVER IP. (2)AD SERVER PORT. (3)AD SERVER DOMAIN NAME
      ##        (4)登入AD SERVER使用者帳號. (5)登入AD SERVER使用者密碼
      #LET l_cmd="sh ",FGL_GETENV("DS4GL"),"/bin/javaad/cmd.sh ",
      #          l_ip, ' ', l_port, ' ', l_domain, ' ', p_zx01, ' ', p_zx10
      
      #LET lch_cmd = base.Channel.create()
      #CALL lch_cmd.openPipe(l_cmd, "r")
            
      #WHILE lch_cmd.read(l_str)
      #    DISPLAY l_str
      #    LET l_xml = l_xml,l_str
      #END WHILE
      #CALL lch_cmd.close()

      #--FUN-BC0080---start-----
      #因為要改成階層式AD Server驗證需多傳參數,下面那二行mark
      #LET l_cmd = "web_check_ad_login(", p_zx01, " ", p_zx10, " ", l_ip, " ", l_port, " ", l_domain, ")"
      #LET l_xml = web_check_ad_login(p_zx01, p_zx10, l_ip, l_port, l_domain)
      LET l_xmlFile = fgl_getenv("TEMPDIR"), "/",
                      "ldap_login_", FGL_GETPID() USING '<<<<<<<<<<', ".xml"

      LET l_cmd = "p_ldap_login '", p_zx01, "' '", p_zx10, "' '", l_xmlFile, "'"

      #執行呼叫ldap驗證程序
      CALL cl_cmdrun_wait(l_cmd)
      #--FUN-BC0080---end------- 
      #--FUN-B40051---end-------

      #IF NOT cl_null(l_xml) THEN      #FUN-BC0080 mark 改變成下述判斷式
      IF NOT cl_null(l_xmlFile) THEN   #FUN-BC0080
         #--FUN-BC0080---start-----
         #因為目前驗證方式變更,已直接產生response xml file,所以下列程式mark
         ##-----------------------------------------------------------------------#
         ## 產生 XML 暫存檔                                                       #
         ##-----------------------------------------------------------------------#
         #LET l_ch = base.Channel.create()
         #LET l_xmlFile = fgl_getenv("TEMPDIR"), "/",
         #                "javaad_", FGL_GETPID() USING '<<<<<<<<<<', ".xml"
         #DISPLAY l_xmlFile
         #CALL l_ch.openFile(l_xmlFile, "w")
         #CALL l_ch.setDelimiter("")
         #CALL l_ch.write(l_xml)
         #CALL l_ch.close()
         #--FUN-BC0080---end------- 

         #-----------------------------------------------------------------------#
         # 讀取 XML 文件                                                         #
         #-----------------------------------------------------------------------#
         LET l_doc = om.DomDocument.createFromXmlFile(l_xmlFile)
         RUN "rm -f " || l_xmlFile || " >/dev/null 2>&1"

         INITIALIZE l_root TO NULL
         IF l_doc IS NULL THEN
            LET l_err_str = cl_getmsg('azz1063', l_zx06)     #讀取XML檔錯誤
         ELSE
            LET l_root = l_doc.getDocumentElement()
            LET l_list = l_root.selectByTagName("status")
            IF l_list.getLength() > 0 THEN
               LET l_node = l_list.item(1)
               LET l_node = l_node.getFirstChild()
               LET l_status = l_node.getattribute("@chars")
            END IF
            
            #---FUN-BC0080---start-----#
            LET l_list = l_root.selectByTagName("description")
            IF l_list.getLength() > 0 THEN
               LET l_node = l_list.item(1)
               LET l_node = l_node.getFirstChild()
               LET l_desc = l_node.getattribute("@chars")
            END IF
            #---FUN-BC0080---end-------#

            #l_status驗證回傳結果:(1)0:失敗. (2)1:成功. (3)還有其他錯誤代碼
            #帳號驗證成功
            IF l_status = '1' THEN
               RETURN ''
            END IF

            CASE l_status
                 WHEN '0'
                      LET l_ze01 = 'azz1061'     #AD帳號驗證失敗
                 WHEN '2'
                      LET l_ze01 = 'azz1062'     #呼叫java程式參數不足或過多
                 WHEN '3'
                      LET l_ze01 = 'azz1064'     #AD Server Connection refused
                 WHEN '525'
                      LET l_ze01 = 'azz1065'     #user not found
                 WHEN '52e'
                      LET l_ze01 = 'azz1066'     #nvalid credentials(密碼錯誤)
                 WHEN '530'
                      LET l_ze01 = 'azz1067'     #not permitted to logon at this time
                 WHEN '532'
                      LET l_ze01 = 'azz1068'     #password expired
                 WHEN '533'
                      LET l_ze01 = 'azz1069'     #account disabled
                 WHEN '701'
                      LET l_ze01 = 'azz1070'     #account expired
                 WHEN '773'
                      LET l_ze01 = 'azz1071'     #user must reset password
                 #---FUN-BC0080---start-----#
                 WHEN '4'
                      LET l_ze01 = 'azz1167'                                    #AD Server port指定錯誤
                 WHEN '5'
                      LET l_ze01 = 'azz1168'                                    #LDAP 管理帳號DN未輸入
                 WHEN '6'
                      LET l_ze01 = 'azz1169'                                    #LDAP Base DN未指定
                 WHEN '7'
                      LET l_ze01 = 'azz1170'                                    #java取得SSL Class失敗.
                 WHEN '8'
                      LET l_ze01 = 'azz1171'                                    #LDAP 管理者帳號DN連接失敗
                 WHEN '9'
                      LET l_ze01 = 'azz1172'                                    #LDAP管理者帳號輸入錯誤
                 WHEN '10'
                      LET l_ze01 = 'azz1173'                                    #LDAP管理者密碼輸入錯誤
                 WHEN '11'
                      LET l_ze01 = 'azz1174'                                    #LDAP 搜尋使用者帳號時發生錯誤
                 WHEN '12'
                      LET l_ze01 = 'azz1175'                                    #儲存AD Server管理者密碼的zx_file帳號不存在
                 WHEN '13'
                      LET l_ze01 = 'azz1176'                                    #使用者帳號或密碼未傳遞.
                 #---FUN-BC0080---end-------#
                 #--FUN-B40051---start-----
                 OTHERWISE
                     LET l_ze01 = l_status
                     LET l_list = l_root.selectByTagName("status")
                     IF l_list.getLength() > 0 THEN
                        LET l_node = l_list.item(1)
                        LET l_err_str = l_node.getattribute("description")
                     END IF
                 #--FUN-B40051---end-------
            END CASE

            IF cl_null(l_err_str) THEN   #FUN-B40051
               LET l_err_str = cl_getmsg(l_ze01, l_zx06)
            END IF                       #FUN-B40051
            
            IF cl_null(l_err_str) THEN
               LET l_err_str = "p_ze no error message description.\n(p_ze:", l_ze01, "; lang: ", l_zx06, "; User account: ", p_zx01, ")"
            END IF

            #---FUN-BC0080---start-----#
            IF l_status = "525" THEN
               LET l_err_str = l_err_str, " ", l_desc.substring(l_desc.getindexof("filter:", 1), l_desc.getindexof("))", 1) + 1)
            END IF
            #---FUN-BC0080---end-------#
         END IF
      END IF

      DISPLAY "javaad time_end:",TIME
   END IF

   #理論上執行到這裡應該要有err msg,如果沒有則是可能FUNCTION有什麼地方出錯
   IF cl_null(l_err_str) THEN
      LET l_err_str = 'web_javaad run failed!'
   END IF

   #記錄此次呼叫的 method name
   LET l_file = "weblogin_ad-", TODAY USING 'YYYYMMDD', ".log"

   LET channel = base.Channel.create()
   CALL channel.openFile(l_file,  "a")
   IF STATUS = 0 THEN
      CALL channel.setDelimiter("")
      #--FUN-BC0080---start-----
      #因為request log資訊已由p_ldap_login寫入,所以下列程式mark
      #LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
      #CALL channel.write(l_str)
      #CALL channel.write("")
      #LET l_str = "Method: Weblogin AD Certification."
      #CALL channel.write(l_str)
      #CALL channel.write("")
      #LET l_str = "Request:", cl_replace_str(l_cmd, p_zx01 || " " || p_zx10, p_zx01 || " " || "*****")
      #CALL channel.write(l_str)
      #CALL channel.write("")
      #LET l_str = "Response:", l_xml
      LET l_str = "Status:", l_status
      CALL channel.write(l_str)
      LET l_str = "Desc:", l_desc
      #--FUN-BC0080---end-------
      CALL channel.write(l_str)
      CALL channel.write("")
      LET l_str = "l_err_str:", l_err_str
      CALL channel.write(l_str)
      CALL channel.write("#------------------------------------------------------------------------------#")
      
      CALL channel.write("")
      CALL channel.close()

      LET l_cmd = "chmod 666 ", l_file CLIPPED, " >/dev/null 2>/dev/null"
      RUN l_cmd
   ELSE
      DISPLAY "Can't open log file."
   END IF

   RETURN l_err_str
END FUNCTION
#END FUN-A80141

#--FUN-B40051---start-----
#------------------------------------------------------------------
#將使用者輸入之帳號、密碼透過由AD SERVER驗證
#傳入參數:p_zx01(使用者AD帳號)
#傳入參數:p_zx10(使用者AD密碼)
#傳入參數:p_ip(AD Server IP)
#傳入參數:p_port(AD Server Port)
#傳入參數:p_domain(AD Server DOMAIN NAME)
#傳回結果:l_result:((1)0:失敗. (2)1:成功. (3)還有其他錯誤代碼)
#------------------------------------------------------------------
FUNCTION web_check_ad_login(p_zx01, p_zx10, p_ip, p_port, p_domain)
   DEFINE p_zx01     STRING
   DEFINE p_zx10     STRING
   DEFINE p_ip       STRING                    #AD Server IP位置
   DEFINE p_port     STRING                    #AD Server Port:Windows Windows AD預設是389
   DEFINE p_domain   STRING                    #AD Server DOMAIN NAME
   DEFINE l_adpar    java.util.Hashtable       #AD 登入資訊
   DEFINE l_user     STRING                    #AD 使用者帳號(帶網域)
   DEFINE l_sb       java.lang.StringBuffer    #LDAP URL
   DEFINE l_err      STRING                    #錯誤代碼
   DEFINE l_ad_path  STRING                    #AD 網域路徑
   DEFINE l_result   STRING                    #AD 驗證結果,為xml格式
   DEFINE l_control  ARRAY [] OF javax.naming.ldap.Control  #LDAP control
   DEFINE l_ctx      javax.naming.ldap.InitialLdapContext   #AD Server連結物件

   LET l_err = ""
   LET l_result = ""
   
   #create hashtable存AD登入資訊
   LET l_adpar = Hashtable.create()
   #AD帳號會帶網域
   LET l_user = p_zx01 CLIPPED, "@", p_domain.trim()
   
   TRY
      #取得AD Server路徑,範例:DC=dsc,DC=com,DC=tw
      LET l_ad_path = web_get_ad_path(p_domain)
      #組合ldap_url
      LET l_sb = StringBuffer.create()
      CALL l_sb.append("LDAP://")
      CALL l_sb.append(p_ip);
      CALL l_sb.append(":");
      CALL l_sb.append(p_port);
      CALL l_sb.append("/");
      CALL l_sb.append(l_ad_path);      
   
      CALL l_adpar.put("java.naming.factory.initial", "com.sun.jndi.ldap.LdapCtxFactory");
      CALL l_adpar.put("java.naming.provider.url", l_sb.toString());
      CALL l_adpar.put("java.naming.security.authentication", "simple");
      CALL l_adpar.put("java.naming.security.principal", l_user);
      CALL l_adpar.put("java.naming.security.credentials", p_zx10);
   CATCH
      LET l_result = "<status>4</status> \n"
      LET l_result = l_result, "<description>", ERR_GET(STATUS), "</description>"
      RETURN l_result
   END TRY

   TRY
      #開啟AD Server驗證
      LET l_ctx = InitialLdapContext.create(l_adpar, l_control)
      LET l_err = "1"
   CATCH
      #讀取AD驗證失敗訊息
      LET l_err = ERR_GET(STATUS)
      #讀取驗證錯誤代碼
      #Java exception thrown: javax.naming.AuthenticationException: [LDAP: error code 49 - 80090308: LdapErr: DSID-0C0903AA, comment: AcceptSecurityContext error, data 525, v1772.
      #以上面Java exception thrown例子來說就是會抓到525
      IF l_err.getIndexOf("Connection refused", 1) > 0 AND 
         l_err.getIndexOf(p_ip || ":" || p_port, 1) > 0 THEN
         LET l_err = "3"
      ELSE
         LET l_err = l_err.subString(l_err.getIndexOf("data", 1) + 5, l_err.getIndexOf("data", 1) + 7)
      END IF
   END TRY

   #記錄Java exception thrown訊息
   IF l_err = "1" THEN
      LET l_result = ""
   ELSE
      LET l_result = cl_replace_str(ERR_GET(STATUS), "\n", "")
   END IF
   LET l_result = '<status description="', l_result, '">'
   LET l_result = l_result, l_err.trim(), "</status>"
   RETURN l_result
END FUNCTION

#------------------------------------------------------------------
#將AD Server網域拆解成LDAP url所需之AD路徑
#傳入參數:p_domain(AD網域)
#傳回結果:l_domain_path(AD路徑)
#------------------------------------------------------------------
FUNCTION web_get_ad_path(p_domain)
   DEFINE p_domain        STRING                 #AD Server DOMAIN NAME
   DEFINE l_domain_path   STRING                 #AD 網域路徑
   DEFINE l_tok           base.StringTokenizer

   LET l_domain_path = ""
   LET l_tok = base.StringTokenizer.create(p_domain, ".")

   #取得AD path
   #@return	ex: wow.portal-wow.com ==> DC=wow,DC=portal-wow,DC=com
   WHILE l_tok.hasMoreTokens()
       LET l_domain_path = l_domain_path, "DC=", l_tok.nextToken(), ","
   END WHILE

   #去除最後一個逗點
   IF NOT cl_null(l_domain_path) THEN
      LET l_domain_path = l_domain_path.subString(1, l_domain_path.getLength() - 1)
   END IF

   LET l_domain_path = l_domain_path.trim()
   RETURN l_domain_path
END FUNCTION
#--FUN-B40051---end-------
