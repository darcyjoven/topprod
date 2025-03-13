# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aoos901.4gl
# Descriptions...: 工廠選擇作業
# Date & Author..: 
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470151 04/07/23 By Nicola Welcome 字句顯示不同語言別
# Modify.........: No.MOD-4B0011 04/11/02 By saki   udm7進來若按取消不繼續跑udm_tree
# Modify.........: No.MOD-4B0235 04/11/26 By Nicola 放大l_dbs變數為char(20)
# Modify.........: No.MOD-530114 05/03/16 By alex 在無多工廠變換權限下秀提示訊息
# Modify.........: No.MOD-540146 05/04/30 By alex 刪除無效的 g_action_choice
# Modify.........: No.FUN-580135 05/08/25 By alex 若 azz05=Y 則顯示時區資料
# Modify.........: No.MOD-580319 05/08/26 By alex modi err msg
# Modify.........: No.MOD-590023 05/09/05 By alex zxx_file modify
# Modify.........: No.TQC-5A0069 05/10/19 By qazzaq p_zta呼叫aoos901則不更新zx及zxx
# Modify.........: No.TQC-5A0085 05/10/31 By qazzaq informix及oracle統一取得g_user的
#                                         方法
# Modify.........: No.TQC-620096 06/02/20 By qazzaq 將p_zta所使用的aoos901.xxxx改權限
#                                為777
# Modify.........: No.FUN-630079 06/06/15 By alexstar 當執行 aoos901 的 user 已經設為單一營運中心時:
#                  1.取銷錯誤訊息的顯示的 Window
#                  2.進到 aoos901 主劃面, 並將下列訊息段加到歡迎視窗中
#                    "已幫您設好預設的營運中心, 請按確認鍵繼續"
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-660135 06/07/13 By saki 記錄最後選擇資料庫到process列表
# Modify.........: No.TQC-680021 06/08/08 By saki 不同帳號用同電腦登入，切換資料庫互相不影響
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.TQC-690031 06/10/14 By Sarah 執行aoos901的畫面時變更語言別，重新顯示欄位時未將說明也改用英文顯示
# Modify.........: No.TQC-6A0036 06/10/20 By saki 增加cl_used呼叫,修正開啟aoos901按下取消後會關閉主程式的問題
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-740179 07/06/11 By saki 將process的資料庫by 不同的登入記錄
# Modify.........: No.TQC-790078 07/09/12 By saki 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.FUN-7A0086 07/11/01 By saki 限制資料庫上線人數
# Modify.........: No.MOD-810216 08/01/28 By alexstar 修正切工廠別後部門上線人數無限制問題
# Modify.........: No.FUN-830019 08/03/06 By alexstar 非多工廠使用者不開aoos901
# Modify.........: No.TQC-870015 08/08/14 By saki 取消使用zxx_file, 補cl_used()
# Modify.........: No.MOD-8A0136 08/10/15 By alexstar 非多工廠使用者也要記錄工廠別
# Modify.........: No.FUN-910028 09/01/08 By alex 調整開暫存檔的指令(MSV)
# Modify.........: No.FUN-980014 09/08/04 By rainy GP5.2 新增抓取 g_legal 值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No:CHI-9C0018 09/12/09 By saki 資料庫上線人數控管排除aoos901的process
# Modify.........: No:MOD-9C0156 09/12/18 By Dido 部門上線人數控管異常 
# Modify.........: No.FUN-AB0079 10/11/17 By Kevin 修正EXIT PROGRAM
# Modify.........: No.FUN-BA0018 11/10/05 By jrg542 新增使用者進入本作業 / 離開本作業時，均需要進行系統層級的 log，除記錄時間外，應增加 client PC 登入的 IP 位置
# Modify.........: No.FUN-C20060 12/02/10 By jrg542 因應資安專案, 調整aoos901的登入說明，加註警語
# Modify.........: No:MOD-BC0109 12/03/16 By madey 切換工廠後re-load aza_file更新aza18狀態值,解決程式執行log與aza18設定不一致情況
 
IMPORT os
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_zx07           LIKE type_file.chr1          #TQC-690031 add
DEFINE g_zx02           LIKE zx_file.zx02
 
MAIN
   DEFINE l_zx07	LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
   DEFINE l_zx06	LIKE zx_file.zx06
   DEFINE l_azz02	LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
   DEFINE p_flag        STRING            #TQC-5A0069
   DEFINE l_cmd         STRING            #TQC-5A0069
   DEFINE ls_welcome    STRING            #CHAR(1000) #FUN-580135
   DEFINE g_plant_t     LIKE zx_file.zx08           #No.FUN-680102 VARCHAR(10)
#  DEFINE g_msg         LIKE type_file.chr1000       #No.FUN-680102 VARCHAR(72)
   DEFINE lc_tty_no     LIKE type_file.chr50         #No.FUN-680102 VARCHAR(32)                    #MOD-590023 #g_tty
   DEFINE ls_tty_no     STRING                       #MOD-590023
   DEFINE g_cnt         LIKE type_file.num5          #No.FUN-680102 SMALLINT
   DEFINE g_azp052      LIKE azp_file.azp052
   DEFINE l_ze031       LIKE ze_file.ze03
   DEFINE l_ze032       LIKE ze_file.ze03
   DEFINE lc_azz05      LIKE azz_file.azz05           #FUN-580135
   DEFINE ls_fglserver  STRING                        #No.FUN-660135
   DEFINE ls_sql        STRING                        #No.FUN-660135   
   DEFINE ls_gbq10      STRING                        #No.FUN-660135
   DEFINE lc_gbq01      LIKE gbq_file.gbq01           #No.FUN-660135
   DEFINE lc_gbq10      LIKE gbq_file.gbq10           #No.FUN-660135
   DEFINE l_lang_t      LIKE type_file.chr1           #TQC-690031 add
   DEFINE ps_exe_cmd    STRING                        #No.TQC-6A0036
   DEFINE li_cnt        LIKE type_file.num5           #No.TQC-790078
   DEFINE lc_channel    base.Channel                  #No.FUN-910028
   DEFINE l_client      STRING                        #No.FUN-BA0018 
   DEFINE ls_msg        STRING                        #No.FUN-BA0018 

   IF (NOT cl_user()) THEN
       #MOD-530114
      IF g_user IS NULL OR g_user = " " THEN LET g_user="NULL" END IF
      DISPLAY " "       #MOD-580319
      DISPLAY "Info: User of ",g_user CLIPPED," Fail in Reading System Parameter."
#     DISPLAY "Info: User of ",g_user CLIPPED," Cannot be Found in p_zx "
      EXIT PROGRAM (1)  #FUN-AB0079
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM (1)  #FUN-AB0079
   END IF

   IF NOT cl_check_license() THEN
      CALL cl_err(g_user,'INFO: Login Users Exceed Than TIPTOP License Allowed!',0)
      EXIT PROGRAM (1)  #FUN-AB0079
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #No.TQC-6A0036  #No.FUN-6A0081

   LET l_client = cl_getClientIP()   #FUN-BA0018

    IF cl_fglgui() MATCHES "[23]" THEN
       IF cl_null(g_user) THEN 
          LET g_user = FGL_GETENV('WEBUSER') 
       END IF
       CALL cl_err(g_user,'!',0)
    ELSE
#      SELECT USER,COUNT(*) INTO g_user,g_cnt FROM azp_file
       LET g_user=FGL_GETENV('LOGNAME')    #TQC-5A0085
    END IF
 
    LET ps_exe_cmd = ARG_VAL(1)   #No.TQC-6A0036
    LET p_flag = ARG_VAL(2)       #TQC-5A0069  #No.TQC-6A0036
 
    SELECT zx07,zx08 INTO l_zx07,g_plant FROM zx_file WHERE zx01=g_user
    IF STATUS=100 THEN
#       LET g_msg='[user:',g_user CLIPPED,' ] No such user code!'
#       CALL cl_err(g_msg,'!',1)    #No.FUN-660131
        CALL cl_err3("sel","zx_file",g_user,"","!","","",1)   #No.FUN-660131
    END IF
    IF STATUS THEN
       ERROR '(error no:',SQLCA.sqlcode,')[user:',g_user CLIPPED,
             '] select zx_file error:'
       CALL cl_used(g_prog,g_time,2) RETURNING g_time            #No.TQC-6A0036  #No.FUN-6A0081#No.FUN-6A0081
       EXIT PROGRAM (1)  #FUN-AB0079
    END IF
    
    SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_plant #FUN-980014 add (抓出該營運中心所屬法人)
 
 
     #MOD-530114
    IF l_zx07 = 'N' THEN
#      LET g_msg="[user:",g_user CLIPPED," ] Have No Changing Plants Authority!"
#      CALL cl_err(g_msg,'!',1)
      #FUN-630079---start---
      #CALL cl_err_msg(NULL,"aoo-008",g_user CLIPPED || "|" || g_plant CLIPPED, 10)
       LET g_idle_seconds = 3
      #FUN-630079---end---
       CALL cl_used(g_prog,g_time,2) RETURNING g_time            #No.TQC-870015
#MOD-8A0136 FUN-910028 ---start---
#      LET l_cmd='echo "',g_plant CLIPPED,'">$TEMPDIR/aoos901.',p_flag CLIPPED
#      RUN l_cmd
 
       LET l_cmd = "aoos901.",p_flag CLIPPED  
       LET l_cmd = os.Path.join(FGL_GETENV("TEMPDIR"),l_cmd.trim())
       LET lc_channel = base.Channel.create()
       CALL lc_channel.openFile( l_cmd.trim(), "a" )
       CALL lc_channel.setDelimiter("")
       CALL lc_channel.write(g_plant CLIPPED)
       CALL lc_channel.close()
       IF os.Path.chrwx( l_cmd.trim(), 511) THEN END IF
 
#MOD-8A0136 FUN-910028 ---end---
       EXIT PROGRAM           #FUN-830019
    END IF
 
    # Default PLANT 不check資料庫權限(zxy_file)
    LET g_plant_t=g_plant
 
    WHILE TRUE
#      CLOSE DATABASE
#      DATABASE ds_init
 
       OPEN WINDOW aoos901_w WITH FORM "aoo/42f/aoos901"
       ATTRIBUTE(STYLE = g_win_style CLIPPED)
    
       CALL cl_ui_init()
       SELECT zx02 INTO g_zx02 FROM zx_file
        WHERE zx01=g_user
 
#      LET ls_welcome ="Hello ",g_zx02," , Welcome to TIPTOP",
#                      " This is a beta Version of TIPTOP ERP Base on Genero",
#                      " All the application in this version is still under",
#                      " construct, Should you have any questions or suggestions relating ",
#                      " to anything that I have enclosed",
#                      ", please do not hesitate to contact us ",
#                      " mailto : raymon@dsc.com.tw"
 
 #-----No.MOD-470151----------------
#      LET ls_welcome ="使用者:",g_zx02," ,歡迎使用鼎新TIPTOP GP系統,",
#                      "在使用中若有任何問題,請與貴公司的MIS人員連絡,",
#                      "祝您使用愉快!  "
#      
      #start TQC-690031 modify
      #SELECT ze03 INTO l_ze031 FROM ze_file
      # WHERE ze01 = "aoo-006"
      #   AND ze02 = g_lang
      #
      #IF l_zx07 = 'N' THEN      #FUN-630079
      #   SELECT ze03 INTO l_ze032 FROM ze_file
      #    WHERE ze01 = "aoo-228"
      #     AND ze02 = g_lang
      #ELSE
      #   SELECT ze03 INTO l_ze032 FROM ze_file
      #    WHERE ze01 = "aoo-007"
      #      AND ze02 = g_lang
      #END IF
      #
      #LET ls_welcome = l_ze031 CLIPPED,g_zx02 CLIPPED,l_ze032 CLIPPED
       LET l_lang_t = g_lang   #TQC-690031 add   #先將原來的語言別記錄起來
       CALL s901_welcome(g_lang) RETURNING ls_welcome
      #end TQC-690031 modify
 
#-----END--------------------------
 
       IF l_zx07 = 'N' THEN  #FUN-630079
         CALL cl_set_act_visible("accept,cancel",FALSE)
       END IF
 
       INPUT g_plant,ls_welcome WITHOUT DEFAULTS
         FROM FORMONLY.g_plant,FORMONLY.welcome
 
            BEFORE INPUT                       #FUN-580135
               SELECT azz05 INTO lc_azz05 FROM azz_file WHERE azz01='0'
               IF STATUS OR lc_azz05 IS NULL OR lc_azz05 <> "Y" THEN
                  CALL cl_set_comp_visible("azp052",FALSE)
               ELSE
                  CALL cl_set_comp_visible("azp052",TRUE)
               END IF

            BEFORE FIELD g_plant
                    IF g_plant IS NULL THEN
                       # Hiko 2003/05/09 產生查詢畫面的參數初始化.
                       CALL cl_init_qry_var()
#                      LET g_qryparam.form = "q_azp"
# FUN-4A0087
                       LET g_qryparam.form = "q_zxy"
                       LET g_qryparam.default1 = g_plant
                       LET g_qryparam.arg1 = g_user
                       LET g_qryparam.construct = 'N'
                       CALL cl_create_qry() RETURNING g_plant 
                       DISPLAY BY NAME g_plant
                    END IF
                    SELECT azp052 INTO g_azp052 FROM azp_file 
                     WHERE azp01=g_plant
                    DISPLAY g_azp052 TO FORMONLY.azp052
              
            AFTER FIELD g_plant
                    IF g_plant IS NULL THEN NEXT FIELD g_plant END IF
                    SELECT azp02 FROM azp_file WHERE azp01=g_plant
                    IF STATUS THEN
 #                      CALL cl_err('sel azp:',STATUS,0)    #No.FUN-660131
                        CALL cl_err3("sel","azp_file",g_plant,"",STATUS,"","sel azp:",0)   #No.FUN-660131
                        NEXT FIELD g_plant
                    END IF
## 99/04/30 
                    SELECT zx06 INTO l_zx06 FROM zx_file WHERE zx01=g_user
                    IF STATUS THEN
 #                      CALL cl_err('sel zx06:',STATUS,0)  #No.FUN-660131
                        CALL cl_err3("sel","zx_file",g_user,"",STATUS,"","sel zx06:",0)  #No.FUN-660131
                    END IF   #NO:6106
                     
                    IF g_plant_t<>g_plant THEN
                       IF s_chkdbs(g_user,g_plant,l_zx06)=FALSE THEN 
                          #FUN-BA0018 ---start 
                          #進行系統紀錄
                          LET ls_msg = g_user CLIPPED," logon ",g_plant CLIPPED," fail from ",l_client CLIPPED
                          IF cl_syslog("E","S",ls_msg) THEN END IF
                          #FUN-BA0018 ---end  
    
                          NEXT FIELD g_plant
                       END IF
                    END IF
 
                    IF NOT cl_null(g_plant) THEN EXIT INPUT END IF
            ON ACTION controlp
                    CASE WHEN INFIELD(g_plant)
                       CALL cl_init_qry_var()
#                      LET g_qryparam.form = "q_azp"
# FUN-4A0087
                       LET g_qryparam.form = "q_zxy"
                       LET g_qryparam.arg1 = g_user
                       LET g_qryparam.construct = 'N'
                       LET g_qryparam.default1 = g_plant
                       CALL cl_create_qry() RETURNING g_plant 
                       DISPLAY BY NAME g_plant
                       SELECT azp052 INTO g_azp052 FROM azp_file 
                        WHERE azp01=g_plant
                       DISPLAY g_azp052 TO FORMONLY.azp052
                       NEXT FIELD g_plant
                    END CASE
 
       ON ACTION help 
          # 2004/07/15 加上 help
          CALL cl_show_help()
 
 #-----No.MOD-470151----------------
       ON ACTION locale
 #         LET g_action_choice="locale"   #MOD-540146
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CALL cl_dynamic_locale()
         #start TQC-690031 add
          IF l_lang_t != g_lang THEN
             CALL s901_welcome(g_lang) RETURNING ls_welcome
             DISPLAY ls_welcome TO FORMONLY.welcome
             LET l_lang_t = g_lang
          END IF
         #end TQC-690031 add
 #         EXIT INPUT                     #MOD-540146
 
       ON IDLE g_idle_seconds
          IF g_idle_seconds = 3 AND l_zx07 = 'N' THEN #FUN-630079 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time            #No.TQC-6A0036   #No.FUN-6A0081
             EXIT PROGRAM (1)  #FUN-AB0079
          ELSE
             CALL cl_on_idle()
             CONTINUE INPUT
          END IF
 
       END INPUT
 
 
 #      IF g_action_choice ="locale" THEN #MOD-540146
#         LET g_action_choice=""
#         CONTINUE WHILE
#      END IF
#-----END--------------------------
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CALL cl_used(g_prog,g_time,2) RETURNING g_time            #No.TQC-6A0036  #No.FUN-6A0081
          #No.TQC-6A0036 --start--
          IF ps_exe_cmd = "continue" THEN
             EXIT PROGRAM
          ELSE
             EXIT PROGRAM (1)          # MOD-4B0011
          END IF
          #No.TQC-6A0036 ---end---
       END IF
 
       CLOSE WINDOW aoos901_w
 
       CALL s_chkplt(g_plant,'') RETURNING g_dbs
       IF g_dbs IS NULL THEN LET g_plant = NULL CONTINUE WHILE END IF

       SELECT aza18 INTO g_aza.aza18 FROM aza_file WHERE aza01 = '0'  #No.MOD-BC0109

       #Begin:FUN-980030
       CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069 
       CLOSE DATABASE
       DATABASE g_dbs
       IF SQLCA.SQLCODE THEN
           ERROR '(error no:',SQLCA.sqlcode,')[dbs.',g_dbs CLIPPED,
                '] Database open error!'
          RETURN ''
       END IF
       CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069 
       #End:FUN-980030

       #No.FUN-7A0086 --start--
       IF NOT s901_online_limit() THEN
          CONTINUE WHILE
       END IF
       #No.FUN-7A0086 ---end---
       CALL cl_process_check()              #MOD-810216
       IF NOT udmtree_online_limit() THEN   #MOD-810216
          CONTINUE WHILE
       END IF
       EXIT WHILE
    END WHILE
    #CLOSE DATABASE
    #DATABASE ds_init
    # Mark By Raymon
 
#   #MOD-590023
    CASE
       WHEN (g_gui_type = 0) OR (g_gui_type = 1)
          CALL FGL_GETENV('LOGTTY') RETURNING lc_tty_no
       WHEN (g_gui_type = 2) OR (g_gui_type = 3)
          LET ls_tty_no = FGL_GETENV('FGLSERVER')
          LET lc_tty_no = ls_tty_no.trim()
    END CASE
 
    IF lc_tty_no IS NULL THEN
       LET lc_tty_no = '-'
    END IF
 
    IF p_flag IS NULL THEN  #TQC-5A0069
       UPDATE zx_file SET zx08=g_plant WHERE zx01=g_user
 
       #No.TQC-790078 --start--
       #No.TQC-870015 --mark start--
#      SELECT COUNT(*) INTO li_cnt FROM zxx_file WHERE zxx01=g_user AND zxx02=lc_tty_no
#      IF li_cnt > 0 THEN
#         UPDATE zxx_file SET zxx03=g_plant
#          WHERE zxx01=g_user AND zxx02=lc_tty_no    #g_tty
#      ELSE
#         INSERT INTO zxx_file(zxx01,zxx02,zxx03)  #No.MOD-470041
#              VALUES(g_user,lc_tty_no,g_plant)  # VALUES(g_user,g_tty,g_plant)
#      END IF
       #No.TQC-870015 ---mark end---
#      INSERT INTO zxx_file(zxx01,zxx02,zxx03)  #No.MOD-470041
#           VALUES(g_user,lc_tty_no,g_plant)  # VALUES(g_user,g_tty,g_plant)
#      IF SQLCA.SQLCODE=-239 THEN
#         UPDATE zxx_file SET zxx03=g_plant
#          WHERE zxx01=g_user AND zxx02=lc_tty_no    #g_tty
#      END IF
       #No.TQC-790078 ---end---
 
       #No.FUN-660135 --start--
       #成功更動資料庫後，將process裡面最後選擇資料庫改正
       LET ls_fglserver = FGL_GETENV("FGLSERVER")
       LET ls_fglserver = cl_process_chg_iprec(ls_fglserver)   #No.FUN-740179
       LET ls_sql = "SELECT gbq01,gbq10 FROM gbq_file WHERE gbq02 = '",ls_fglserver,"' AND gbq03 = '",g_user,"'"
       PREPARE gbq10_pre FROM ls_sql
       DECLARE gbq10_curs CURSOR FOR gbq10_pre
       FOREACH gbq10_curs INTO lc_gbq01,lc_gbq10
          LET ls_gbq10 = lc_gbq10 CLIPPED
          LET ls_gbq10 = ls_gbq10.subString(1,ls_gbq10.getIndexOf("/",1)),g_plant CLIPPED
          LET lc_gbq10 = ls_gbq10
          UPDATE gbq_file SET gbq10 = lc_gbq10 WHERE gbq01 = lc_gbq01
       END FOREACH
       #No.FUN-660135 ---end---
    ELSE
#      #FUN-910028
#      LET l_cmd='echo "',g_plant CLIPPED,'">$TEMPDIR/aoos901.',p_flag CLIPPED
#      RUN l_cmd
#      LET l_cmd='chmod 777 $TEMPDIR/aoos901.',p_flag CLIPPED
#      RUN l_cmd
 
       LET l_cmd = "aoos901.",p_flag CLIPPED  
       LET l_cmd = os.Path.join(FGL_GETENV("TEMPDIR"),l_cmd.trim())
       LET lc_channel = base.Channel.create()
       CALL lc_channel.openFile( l_cmd.trim(), "a" )
       CALL lc_channel.setDelimiter("")
       CALL lc_channel.write(g_plant CLIPPED)
       CALL lc_channel.close()
       IF os.Path.chrwx( l_cmd.trim(), 511) THEN END IF
#      #FUN-910028
    END IF
 
    #FUN-BA0018 ---start 
    #進行系統紀錄
    LET ls_msg = g_user CLIPPED," logon ",g_plant CLIPPED," from ",l_client CLIPPED
    IF cl_syslog("A","S",ls_msg) THEN END IF
    #FUN-BA0018 ---end  

    CALL cl_used(g_prog,g_time,2) RETURNING g_time            #No.TQC-6A0036   #No.FUN-6A0081

END MAIN
 
FUNCTION s_chkplt(p_plant,p_sys)
 
   DEFINE p_plant		LIKE azq_file.azq01           #No.FUN-680102 VARCHAR(10)
   DEFINE p_sys  		LIKE azq_file.azq03           #No.FUN-680102 VARCHAR(3) 
   DEFINE l_dbs  		LIKE type_file.chr21          #No.FUN-680102 VARCHAR(20)
   #No.MOD-4B0235
 
   SELECT azp03 INTO l_dbs FROM azp_file
          WHERE azp01 = p_plant
   IF SQLCA.SQLCODE THEN
      ERROR '(error no:',SQLCA.sqlcode,')[plant:',p_plant CLIPPED,
            '] No such plant or No permission to access!'
      RETURN ''
   END IF
   IF p_sys IS NOT NULL THEN
      SELECT azq03 FROM azq_file WHERE azq01 = p_plant AND azq03 = p_sys
      IF SQLCA.SQLCODE THEN
         ERROR '(error no:',SQLCA.sqlcode,
               ')[plant:',p_plant CLIPPED,
               '][system:',p_sys CLIPPED,
               '] System not available in this plant'
         RETURN ''
      END IF
   END IF
   #Begin:FUN-980030
   ##  CALL cl_ins_del_sid(2) #FUN-980030  #FUN-990069 
   #  CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069 
   #  CLOSE DATABASE
   #  DATABASE l_dbs
   ##   CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069 
   #  CALL cl_ins_del_sid(1,p_plant) #FUN-980030  #FUN-990069 
   #  IF SQLCA.SQLCODE THEN
   #      ERROR '(error no:',SQLCA.sqlcode,')[dbs.',l_dbs CLIPPED,
   #           '] Database open error!'
   #     RETURN ''
   #  END IF
   #End:FUN-980030
   RETURN l_dbs
END FUNCTION
 
#start TQC-690031 add
FUNCTION s901_welcome(p_lang)
   DEFINE p_lang        LIKE type_file.chr1        #CHAR(1)
   DEFINE l_ze031       LIKE ze_file.ze03
   DEFINE l_ze032       LIKE ze_file.ze03
   DEFINE l_welcome     STRING
 
   #No.FUN-C20060 -- start --
   #SELECT ze03 INTO l_ze031 FROM ze_file
   # WHERE ze01 = "aoo-006"
   #   AND ze02 = p_lang
    
   LET l_welcome = cl_getmsg('aoo-006',g_lang),g_zx02,          #No.FUN-C20060
       cl_getmsg('aoo1003',g_lang),cl_getmsg('aoo1004',g_lang), #No.FUN-C20060
       cl_getmsg('aoo1005',g_lang)                              #No.FUN-C20060
       
   #IF g_zx07 = 'N' THEN      #FUN-630079
   #   SELECT ze03 INTO l_ze032 FROM ze_file
   #    WHERE ze01 = "aoo-228"
   #      AND ze02 = p_lang
   #ELSE
   #   SELECT ze03 INTO l_ze032 FROM ze_file
   #    WHERE ze01 = "aoo-007"
   #      AND ze02 = p_lang
   #END IF
 
   #LET l_welcome = l_ze031 CLIPPED,g_zx02 CLIPPED,l_ze032 CLIPPED
   # No.FUN-C20060 ---end ---
   RETURN l_welcome
END FUNCTION
#end TQC-690031 add
 
#No.FUN-7A0086 --start--
FUNCTION s901_online_limit()
   DEFINE   lc_azp09        LIKE azp_file.azp09
   DEFINE   lc_azp10        LIKE azp_file.azp10
   DEFINE   li_result       LIKE type_file.num5
   DEFINE   ls_sql          STRING
   DEFINE   ls_fglserver    STRING
   DEFINE   li_cnt          LIKE type_file.num5
   DEFINE   li_i            LIKE type_file.num5
   DEFINE   lr_gbq          DYNAMIC ARRAY OF RECORD
               gbq02        LIKE gbq_file.gbq02,
               gbq03        LIKE gbq_file.gbq03,
               gbq10        LIKE gbq_file.gbq10
                            END RECORD
   DEFINE   li_repeat_flag  LIKE type_file.num5
   DEFINE   ls_cur_dbs      STRING
   DEFINE   li_dbs_cnt      LIKE type_file.num5
 
   LET li_result = TRUE
 
   SELECT azp09,azp10 INTO lc_azp09,lc_azp10 FROM azp_file WHERE azp01=g_plant
   IF lc_azp09 = "Y" THEN
      IF lc_azp10 <= 0 THEN
         CALL cl_err(g_plant,"azz-745",1)
         LET li_result = FALSE
      ELSE
         LET ls_fglserver = FGL_GETENV("FGLSERVER")
         LET ls_fglserver = cl_process_chg_iprec(ls_fglserver)
         LET ls_sql = "SELECT gbq02,gbq03,gbq10 FROM gbq_file WHERE gbq10 IS NOT NULL AND gbq04 != 'aoos901'"   #No:CHI-9C0018 add condition
         PREPARE gbq_pre FROM ls_sql
         DECLARE gbq_curs CURSOR FOR gbq_pre
         LET li_cnt = 1
         FOREACH gbq_curs INTO lr_gbq[li_cnt].*
            IF (lr_gbq[li_cnt].gbq02 CLIPPED = ls_fglserver) THEN
               CONTINUE FOREACH
            END IF
            LET li_repeat_flag = FALSE
            FOR li_i = 1 TO lr_gbq.getLength() - 1
                IF (lr_gbq[li_cnt].gbq03 CLIPPED = lr_gbq[li_i].gbq03 CLIPPED) AND
                   (lr_gbq[li_cnt].gbq02 CLIPPED = lr_gbq[li_i].gbq02 CLIPPED) AND
                   (lr_gbq[li_cnt].gbq10 CLIPPED = lr_gbq[li_i].gbq10 CLIPPED) THEN
                   LET li_repeat_flag = TRUE
                   EXIT FOR
                END IF
            END FOR
            IF NOT li_repeat_flag THEN
               LET li_cnt = li_cnt + 1
            END IF
         END FOREACH
         CALL lr_gbq.deleteElement(li_cnt)
 
         FOR li_cnt = 1 TO lr_gbq.getLength()
             LET ls_cur_dbs = lr_gbq[li_cnt].gbq10
             IF ls_cur_dbs.getIndexOf("/",1) THEN
                LET ls_cur_dbs = ls_cur_dbs.subString(1,ls_cur_dbs.getIndexOf("/",1)-1)
             END IF
             IF ls_cur_dbs = g_plant THEN
                LET li_dbs_cnt = li_dbs_cnt + 1
             END IF
         END FOR
         IF li_dbs_cnt >= lc_azp10 THEN
            CALL cl_err(g_plant,"azz-745",1)
            LET li_result = FALSE
         END IF
      END IF
   END IF
 
   RETURN li_result
END FUNCTION
#No.FUN-7A0086 ---end---
 
FUNCTION udmtree_online_limit()                         #MOD-810216
   DEFINE   lc_zx01          LIKE zx_file.zx01
   DEFINE   lc_user_zx03     LIKE zx_file.zx03
   DEFINE   lc_other_zx03    LIKE zx_file.zx03
   DEFINE   lc_gbo02         LIKE gbo_file.gbo02
   DEFINE   lc_gbo03         LIKE gbo_file.gbo03
   DEFINE   ls_cmd           STRING
   DEFINE   lc_channel       base.Channel
   DEFINE   ls_result        STRING
   DEFINE   lr_user          DYNAMIC ARRAY OF STRING
   DEFINE   li_cnt           LIKE type_file.num10  
   DEFINE   li_i             LIKE type_file.num10  
   DEFINE   li_repeat_flag   LIKE type_file.num5  
 
   DEFINE   ls_sql           STRING
   DEFINE   lr_gbq           DYNAMIC ARRAY OF RECORD
               gbq02         LIKE gbq_file.gbq02,
               gbq03         LIKE gbq_file.gbq03,
               gbq05         LIKE gbq_file.gbq05,
               gbq10         LIKE gbq_file.gbq10  
                             END RECORD
   DEFINE   ls_fglserver     STRING  
   DEFINE   ls_cur_dbs       STRING              
   DEFINE   li_result        LIKE type_file.num5
 
   LET li_result = TRUE
 
   SELECT zx03 INTO lc_user_zx03 FROM zx_file WHERE zx01 = g_user
   SELECT gbo02,gbo03 INTO lc_gbo02,lc_gbo03 FROM gbo_file WHERE gbo01 = lc_user_zx03
   IF (lc_gbo02 = "Y") AND (lc_gbo03 >= 0) THEN 
      LET ls_fglserver = FGL_GETENV("FGLSERVER")
      LET ls_fglserver = cl_process_chg_iprec(ls_fglserver)   
      LET ls_sql = "SELECT gbq02,gbq03,gbq05,gbq10 FROM gbq_file ORDER BY gbq03"  
      PREPARE gbq_pre2 FROM ls_sql
      DECLARE gbq_curs2 CURSOR FOR gbq_pre2
      LET li_cnt = 1
      FOREACH gbq_curs2 INTO lr_gbq[li_cnt].*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
 
         IF (lr_gbq[li_cnt].gbq02 CLIPPED = ls_fglserver) THEN
            CONTINUE FOREACH
         END IF
 
         LET li_repeat_flag = FALSE
         FOR li_i = 1 TO lr_gbq.getLength() - 1
             IF (lr_gbq[li_cnt].gbq03 CLIPPED = lr_gbq[li_i].gbq03 CLIPPED) AND
                (lr_gbq[li_cnt].gbq02 CLIPPED = lr_gbq[li_i].gbq02 CLIPPED) THEN
                LET li_repeat_flag = TRUE
                EXIT FOR
             END IF
         END FOR
         IF li_repeat_flag THEN
            CALL lr_user.deleteElement(li_cnt)
         ELSE
            LET li_cnt = li_cnt + 1
         END IF
      END FOREACH
      CALL lr_gbq.deleteElement(li_cnt)
 
      LET li_cnt = 0
      FOR li_i = 1 TO lr_gbq.getLength()
          LET ls_cur_dbs = lr_gbq[li_i].gbq10
          IF ls_cur_dbs.getIndexOf("/",1) THEN
             LET ls_cur_dbs = ls_cur_dbs.subString(1,ls_cur_dbs.getIndexOf("/",1)-1)
          END IF
          SELECT zx03 INTO lc_other_zx03 FROM zx_file WHERE zx01 = lr_gbq[li_i].gbq03
          IF lc_other_zx03 = lc_user_zx03 AND ls_cur_dbs = g_plant THEN   
             LET li_cnt = li_cnt + 1
          END IF
      END FOR
     #IF (li_cnt >= lc_gbo03) THEN          #MOD-9C0156 mark
      IF (li_cnt > lc_gbo03) THEN           #MOD-9C0156
         CALL cl_err("","azz-728",30)
         LET li_result = FALSE
      END IF
   END IF
 
   RETURN li_result
END FUNCTION
