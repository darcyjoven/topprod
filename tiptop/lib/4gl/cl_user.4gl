# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Program name...: cl_user.4gl
# Descriptions...: 設定關於使用者與系統公用變數的設定.
# Date & Author..: 03/08/27 by Hiko
# Usage..........: CALL cl_user()
# Modify.........: 05/01/13 by Brendan: Automatically doing BIG5/GB2312 conversion
# Modify.........: No.MOD-540082 05/04/12 by Brendan: Fix BIG5/GB2312 can't automatically switch in HP-UX
# Modify.........: No.MOD-540177 05/04/26 by Brendan: Fix BIG5/GB2312 switch issue under direct connection(telnet)
# Modify.........: No.MOD-550021 05/05/05 by Brendan: Take GBK/GB18030 into account.
# Modify.........: No.MOD-550152 05/07/29 by Brendan: Fix 使用簡/繁轉換機制時, 當執行的程式代號本身在 p_zz 即有指定參數時(zz08) 導致參數會重複累積帶入
# Modify.........: No.MOD-580216 05/08/17 alex rmzb
# Modify.........: No.MOD-590023 05/08/30 alex 修改錯誤訊息, mod zxx_file
# Modify.........: No.MOD-590056 05/09/05 by Brendan: Javamail xml file encoding type error in HP-UX OS
# Modify.........: No.FUN-580093 05/09/09 by saki:紀錄process資訊
# Modify.........: No.FUN-640184 06/04/20 by Echo 自動執行確認功能
# Modify.........: No.FUN-660135 06/07/12 by saki 不同電腦使用同user登入，切換資料庫時互相不影響
# Modify.........: No.TQC-680021 06/08/08 by saki 不同帳號用同電腦登入，切換資料庫互相不影響
# Modify.........: No.FUN-680011 06/08/22 by Echo SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-690005 06/09/18 By chen 類型轉換
# Modify.........: No.TQC-6A0036 06/10/20 by saki:移動紀錄process位置,避免check簡繁體重開程式時會紀錄兩筆資料
# Modify.........: No.FUN-710055 07/03/06 by saki 多行業別程式代碼更動
# Modify.........: No.TQC-760068 07/06/07 by Echo 當背景執行時，不需要重新啟動以執行簡繁轉換功能 
# Modify.........: No.FUN-740179 07/06/11 by saki 同一台電腦不同telnet連線,分別記錄資料庫來使用
# Modify.........: No.FUN-760049 07/06/21 by saki 行業別代碼更動
# Modify.........: No.FUN-750068 07/07/26 by saki 一開始無使用者的db, 要得到後才可抓sma_file的值
# Modify.........: No.FUN-7B0109 07/12/11 by Brendan 調整取得系統目前語系等資料的方式 --> 呼叫 sub function
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-810089 08/03/05 By saki 行業別架構更動
# Modify.........: No.FUN-840077 08/04/22 By saki 限制使用者執行程式數量
# Modify.........: No.FUN-840004 08/07/07 by Echo TIPTOP GateWay 自動執行確認功能
# Modify.........: NO.TQC-870015 08/08/14 By saki 取消使用zxx_file
# Modify.........: NO.FUN-870142 08/08/18 By alex 新增zxacti功能
# Modify.........: No.TQC-880043 08/08/22 By saki 取消使用zxx_file
# Modify.........: No.FUN-880019 08/09/18 By alex 註冊方式變更
# Modify.........: No.FUN-8B0090 08/11/27 By Echo 整合:調整背景執行cmdrun時也要再指定為背景執行(WSBGJOB 判斷是否為整合背景程式)
# Modify.........: No.FUN-910051 09/01/12 By alex 由progA folk起來的process都要取得g_dbs的繼承
# Modify.........: No.TQC-920009 09/02/05 By alexstar aoos901的ParentDB會set到舊的
# Modify.........: No.TQC-920011 09/02/11 By alex aoos901的ParentDB會set到舊的做法調整
# Modify.........: No.FUN-930154 09/03/25 By alex 新增單引轉雙引的函式
# Modify.........: No.FUN-930132 09/04/03 By Vicky 整合背景執行cmdrun時 LET g_user = $WSUSER
# Modify.........: No.FUN-940084 09/04/15 By Vicky 錯誤訊息只DISPLAY到背景但會RETURN FALSE的，都改成 CALL cl_err
# Modify.........: No.FUN-960141 09/07/13 By dongbg GP5.2 g_azw變量賦值
# Modify.........: No.FUN-970098 09/08/04 By alex 因應view作業,將PARENTDB改為使用g_plant
# Modify.........: No.FUN-980014 09/08/04 By rainy GP5.2 新增抓取 g_legal 值
# Modify.........: No.FUN-980030 09/08/04 By Hiko 增加新增sid_file的設定
# Modify.........: No.FUN-980097 09/09/09 By alex 合併 wos 檔內容
# Modify.........: No.FUN-9A0015 09/10/06 By kevin 設定時區(timezone)
# Modify.........: No.FUN-A10055 10/01/12 By Hiko g_auth改為取得使用者對應所有營運中心階層清單
# Modify.........: No.FUN-A20050 10/02/24 By Hiko 調整關於azw_file的錯誤訊息
# Modify.........: No.FUN-A50080 10/05/21 By Hiko cl_get_plant_tree rename s_get_plant_tree
# Modify.........: No.FUN-A60043 10/06/10 By Jay 去除跨資料庫語法
# Modify.........: No.FUN-A70009 10/07/02 By alex 轉雙引號時要看切截參數段是否就已帶雙引號，若是則須用三個反斜線處理過
# Modify.........: No.FUN-B50108 11/05/18 By Kevin 維護function的資訊(p_findfunc)
# Modify.........: No.FUN-B50017 11/05/24 By Jay 新增抓取fastcgidispatch 版本資訊function
# Modify.........: No.FUN-B60068 11/06/10 By alex 處理bgjob=y時的資料庫取法
# Modify.........: No.FUN-B60158 11/07/05 By alex Genero2.32取消fpi改用fglrun -V
# Modify.........: No:FUN-BA0116 11/10/31 By joyce 新增繁簡體資料轉換功能
# Modify.........: No:FUN-BB0007 11/11/01 By Hiko g_plant還要判斷是否使用者有權限設定
# Modify.........: No:FUN-BB0125 11/11/23 By Hiko 將echo指令改為writeLine,以解決單引號問題.
# Modify.........: No:FUN-BB0152 11/11/30 By Hiko 檢核簡繁字串時,要先剔除特殊符號.
# Modify.........: No:FUN-BC0055 11/12/20 By jrg542 依照aoos900設定的內容，使cl_chk_act_auth能夠將使用者選用 action 的動作，寫入 gdp_file
# Modify.........: No:FUN-BC0055 11/12/20 By jrg542 依照aoos900設定的內容，使cl_chk_act_auth能夠將使用者選用 action 的動作，寫入 gdp_file
# Modify.........: No:TQC-BC0104 11/12/20 By jrg542 將webpasswd設定為不抓取PARENTDB環境變數即可
# Modify.........: No:FUN-CA0016 12/12/28 By joyce 將取得g_user值的程式段獨立成一個FUNCTION，好讓其他程式可以呼叫
# Modify.........: No:CHI-D40017 13/04/11 By madey 處理EASY FLOW簽核會有lib-507問題
# Modify.........: No:FUN-D40075 13/04/19 By madey 修正cl_err呼叫sub-118取不到ze_file問題

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053  
 
#----------
# FUN-510030
#----------
  GLOBALS
     DEFINE ms_locale    STRING,
            ms_codeset   STRING,
            ms_b5_gb     STRING
  END GLOBALS
#----------
 
DEFINE   g_fglserver   STRING   #No.FUN-840077
 
##################################################
# Descriptions...: 設定關於使用者與系統公用變數的設定.
# Date & Author..: 2003/08/27 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   是否設定成功
# Modify.........: No.MOD-4C0140 04/12/20 alex 增加 g_rlang 的初始設定
##################################################
 
FUNCTION cl_user()
   DEFINE  ls_err_log_dir    STRING,
           ls_err_log_cmd    STRING,
#          ls_today          STRING,
           ls_err_log_name   STRING
   DEFINE  ls_cmd            STRING,
           li_invalid_sn     LIKE type_file.num5,           #No.FUN-690005 SMALLINT
           ls_tty_no         STRING
#  DEFINE  lc_zb02           LIKE zb_file.zx02   #CHAR(1), #BUG-580216 MOD-550152
   DEFINE  lc_zz28           LIKE zz_file.zz28,  #CHAR(1), #MOD-550152
           lc_zw04           LIKE zw_file.zw04   #CHAR(1)  #MOD-550152
   DEFINE  ch_cmd            base.Channel
   DEFINE  li_i              LIKE type_file.num10       #No.FUN-690005 INTEGER   #FUN-510030
   DEFINE  ls_proc           STRING    #FUN-510030
   DEFINE  ls_udm7           STRING    #MOD-540177
   DEFINE  lc_zz08           LIKE zz_file.zz08,
           lst_tok           base.StringTokenizer,
           li_zz08_para      LIKE type_file.num10       #No.FUN-690005 INTEGER
   DEFINE  ls_prog           STRING                     #No.FUN-710055
   DEFINE  ls_str            STRING                     #No.FUN-710055
   DEFINE  lc_smb04          LIKE smb_file.smb04        #No.FUN-710055
   DEFINE  lc_zxacti         LIKE zx_file.zxacti        #FUN-870142
   DEFINE  lc_zx18           LIKE zx_file.zx18          #FUN-870142
   DEFINE  li_psover_flag    LIKE type_file.num5        #No.FUN-840077
   DEFINE  ls_sql            STRING                     #No.FUN-840077
   DEFINE  l_str             STRING                     #FUN-940084
 
   WHENEVER ERROR CONTINUE
 
   #No.FUN-810089 --remark--
   #No.FUN-750068 --mark--  因為要搜尋非synonym的行業別代碼table, 所以必須在得到dbs以後才能執行此程式段
   IF (cl_null(g_prog)) THEN
#     #No.FUN-710055 --start--
      LET g_prog = ui.Interface.getName()
#     #No.FUN-760049 --start--
#     SELECT sma124 INTO g_sma.sma124 FROM sma_file WHERE sma00='0'
#     LET ls_str = "_",g_sma.sma124 CLIPPED
#     #No.FUN-760049 ---end---
#     IF ls_prog.subString(ls_prog.getLength()-3,ls_prog.getLength()) = ls_str THEN
#        LET g_prog = ls_prog.subString(1,ls_prog.getIndexOf(ls_str,1)-1)
#     ELSE
#        LET g_prog = ls_prog
#     END IF
#     #No.FUN-710055 ---end---
   END IF
   #No.FUN-750068 --mark--
   #No.FUN-810089 --remark--

#  LET ls_cmd = FGL_GETENV('TOP'),'/bin/keychk'   #FUN-880019
#  RUN ls_cmd RETURNING li_invalid_sn
#  IF (li_invalid_sn > 0) THEN
   IF NOT cl_key_check0() THEN
#     CALL ERRORLOG("Invaild installation key. Please contact your provider.")
      #DISPLAY "Invaild installation key. Please contact your provider."    #FUN-940084 mark
      LET l_str = "Invaild installation key. Please contact your provider"  #FUN-940084
      CALL cl_err(l_str,"!",1)       #FUN-940084
      RETURN FALSE
   END IF

#----------
# FUN-510030
#----------
#-- No: FUN-7B0109 BEGIN -------------------------------------------------------
# 原 FUN-510030 寫法改為呼叫 sub function 
#-------------------------------------------------------------------------------
#   LET ms_locale = FGL_GETENV("LANG")
#   LET li_i = ms_locale.getIndexOf(".", 1)
#   IF li_i != 0 THEN
#      LET ms_locale = ms_locale.subString(1, li_i - 1)
#   END IF
#   LET ms_locale = ms_locale.toUpperCase()

   LET ms_locale = cl_get_locale()
 
#   LET lch_cmd = base.Channel.create()
#   CALL lch_cmd.openPipe("locale charmap | cut -d. -f1 | tr -d \"'\"'\"'", "r")   #MOD-590056
#   WHILE lch_cmd.read(ms_codeset)
#   END WHILE
#   LET ms_codeset = ms_codeset.toUpperCase()
   LET ms_codeset = cl_get_codeset()

#   LET ms_b5_gb = NULL
#   CALL lch_cmd.openPipe("COLUMNS=132;export COLUMNS;ps -ef | grep " || FGL_GETPID(), "r")
#   WHILE lch_cmd.read(ls_proc)
#       IF ls_proc.getIndexOf("-t big5", 1) THEN
#          LET ms_b5_gb = "BIG5"
#          EXIT WHILE
#       END IF
#       IF ls_proc.getIndexOf("-t gb2312", 1) THEN
#          LET ms_b5_gb = "GB2312"
#          EXIT WHILE
#       END IF
#   END WHILE
#   CALL lch_cmd.close()

   LET ms_b5_gb = cl_get_b5_gb()
#-- No: FUN-7B0109 END ---------------------------------------------------------
 
 #  SELECT zb02 INTO lc_zb02 FROM zb_file WHERE zb00='0'   #MOD-580216
 
   LET g_gui_type = cl_fglgui()
   
   #No.FUN-840077 --start--  必須先得到gui type才可以組出正確的IP字串
   LET g_fglserver = FGL_GETENV("FGLSERVER")
   LET g_fglserver = cl_process_chg_iprec(g_fglserver)
   RUN "fglWrt -u"
   #No.FUN-840077 ---end---
 
   #FUN-640184
   IF (fgl_getenv("EASYFLOW") = '1' OR fgl_getenv("SPC")='1' OR  #FUN-680011
       fgl_getenv("TPGateWay") = '1' OR fgl_getenv("WSBGJOB")='1' )  #FUN-840004 #FUN-8B0090
       AND g_gui_type = 0 
   THEN
        LET g_bgjob = 'Y'
   END IF
   #END FUN-640184

   # No:FUN-CA0016 ---modify start---
   # 為了便於讓其他程式段可以取得g_user的值，把以下程式段獨立成FUNCTION cl_get_user()

   CALL cl_get_user()

#  CASE
#     WHEN (g_gui_type = 0) AND (FGL_GETENV("BGJOB") = '1') AND (FGL_GETENV("WEBMODE") = '1') #Background Job from WEB Mode
#        LET g_user = FGL_GETENV("WEBUSER")
#     WHEN (g_gui_type = 0) OR (g_gui_type = 1)
#        IF g_bgjob='N' OR cl_null(g_bgjob) THEN        #FUN-640184
#        END IF
#     #   #MOD-580216
#     #  IF (lc_zb02 = '2') THEN
#     #     LET ls_tty_no = FGL_GETENV("LOGTTY")
#     #     LET g_user = ls_tty_no.subString(6,20)
#     #  ELSE #Login user
#           #LET g_user=fgl_getenv('LOGNAME')
#           LET g_user = FGL_GETENV("LOGNAME")
#     #  END IF
#     WHEN (g_gui_type = 2) OR (g_gui_type = 3)
#        LET g_user = FGL_GETENV("WEBUSER")
#  END CASE
   # No:FUN-CA0016 --- modify end ---

   # 2004/01/12 by Hiko : 因為參數設定與資料庫有很大的關係,因此將此段程式碼從cl_setup搬移過來.
   IF (NOT cl_set_default_plant()) THEN
      RETURN FALSE 
   END IF

   #No.FUN-840077 --start-- 必須要先得到資料庫後才可check process是否超過aza83設定
   LET ls_sql = "SELECT COUNT(*) FROM gbq_file ",
                " WHERE gbq02 = '",g_fglserver,"' AND gbq03 = '",g_user,"'"     #No.TQC-680021
   PREPARE aza83_pre FROM ls_sql
   EXECUTE aza83_pre INTO li_i
   SELECT aza83 INTO g_aza.aza83 FROM aza_file WHERE aza01 = '0'
   IF li_i >= g_aza.aza83 AND NOT cl_null(g_aza.aza83) AND g_aza.aza83 > 0 THEN
      LET li_psover_flag = TRUE
   END IF
   #No.FUN-840077 ---end---
 
   #No.FUN-810089 --mark start--
#  #No.FUN-750068 --start--  因為要搜尋非synonym的行業別代碼table, 所以必須在得到dbs以後才能執行此程式段
#  IF (cl_null(g_prog)) THEN
#     LET ls_prog = ui.Interface.getName()
#     SELECT sma124 INTO g_sma.sma124 FROM sma_file WHERE sma00='0'
#     LET ls_str = "_",g_sma.sma124 CLIPPED
#     IF ls_prog.subString(ls_prog.getLength()-3,ls_prog.getLength()) = ls_str THEN
#        LET g_prog = ls_prog.subString(1,ls_prog.getIndexOf(ls_str,1)-1)
#     ELSE
#        LET g_prog = ls_prog
#     END IF
#  END IF
#  #No.FUN-750068 --end--
   #No.FUN-810089 ---mark end---
 
   # 2004/01/09 by Hiko : 因為cl_err_msg.4gl需要用到g_need_err_log,g_trace,g_idle_seconds,
   #                      因此在cl_chk_err_setting前就要先設定好.
   SELECT zz26 INTO g_need_err_log FROM zz_file WHERE zz01=g_prog
   IF (SQLCA.SQLCODE) THEN
      LET g_need_err_log = 'N' #是否要將錯誤訊息寫入log檔內,預設為'N'.(by 程式)
   END IF
 
   # 2004/05/03 by saki : 把這段從最後搬上來, 因為idle需要用到g_clas
   # 05/05/09 FUN-540024
   SELECT zx03,zx04,zx06,zx14,zx18,zxacti       #FUN-870142
     INTO g_grup,g_clas,g_lang,g_zx14,lc_zx18,lc_zxacti
     FROM zx_file WHERE zx01=g_user
   IF (SQLCA.SQLCODE) THEN
#     CALL ERRORLOG(g_user CLIPPED || " has no data in zx_file.")
      #DISPLAY g_user CLIPPED," has no data in zx_file."   #FUN-940084 mark
      LET l_str = g_user CLIPPED," has no data in zx_file" #FUN-940084
      CALL cl_err(l_str,"!",1)                             #FUN-940084
      RETURN FALSE
   END IF
 
   #FUN-870142
   IF lc_zxacti<>"Y" OR lc_zx18 < TODAY THEN
      #DISPLAY g_user CLIPPED," has expired."     #FUN-940084 mark
      LET l_str = g_user CLIPPED," has expired"   #FUN-940084
      CALL cl_err(l_str,"!",1)                    #FUN-940084
      RETURN FALSE
   END IF
 
   #No.FUN-840077 --start--
   IF li_psover_flag THEN
      IF g_bgjob = 'Y' THEN #CHI-D40017
      ELSE                  #CHI-D40017
         LET li_psover_flag = FALSE
         CALL cl_err_msg("","lib-507",g_aza.aza83,1)
         RETURN FALSE
      END IF                #CHI-D40017
   END IF
   #No.FUN-840077 ---end---
 
#----------
# FUN-510030
#----------
 
   IF NOT (g_bgjob = 'Y' AND g_gui_type NOT MATCHES "[13]")  THEN   #TQC-760068
      #----------
      # MOD-540082
      # MOD-550021
      #----------
       IF ms_codeset.getIndexOf("BIG5", 1) OR 
          ( ms_codeset.getIndexOf("GB2312", 1) OR ms_codeset.getIndexOf("GBK", 1) OR ms_codeset.getIndexOf("GB18030", 1) ) THEN
      #----------
          IF ( ms_locale = "ZH_TW" AND g_lang = '2' AND ( ( ms_b5_gb != "GB2312" AND ms_b5_gb != "GBK" ) OR ms_b5_gb IS NULL ) ) OR   #No.FUN-7B0109 加入 GBK 判斷
             ( ms_locale = "ZH_CN" AND g_lang = '0' AND ( ms_b5_gb != "BIG5" OR ms_b5_gb IS NULL ) ) OR 
             ( ms_locale = "ZH_TW" AND g_lang = '0' AND ms_b5_gb IS NOT NULL ) OR 
             ( ms_locale = "ZH_CN" AND g_lang = '2' AND ms_b5_gb IS NOT NULL ) THEN
      
            #--- MOD-550152
             SELECT zz08 INTO lc_zz08 FROM zz_file WHERE zz01 = g_prog
             IF SQLCA.SQLCODE OR SQLCA.SQLCODE = NOTFOUND THEN
                LET li_zz08_para = 0
             ELSE
                LET lst_tok = base.StringTokenizer.create(lc_zz08 CLIPPED, " ")
                LET li_zz08_para = lst_tok.countTokens() - 2
             END IF
            #--- MOD-550152 END
      
             LET ls_udm7 = FGL_GETENV("UDM7")   #Set by udm7 shell
             LET ls_cmd = g_prog CLIPPED
             FOR li_i = 1 TO NUM_ARGS()
                #--- MOD-550152
                 IF li_i <= li_zz08_para THEN
                    CONTINUE FOR
                 END IF
                #--- MOD-550152 END
                 LET ls_cmd = ls_cmd CLIPPED, " '", ARG_VAL(li_i), "'"
             END FOR
             IF g_prog CLIPPED = "aoos901" THEN
                CALL cl_cmdrun_wait(ls_cmd CLIPPED)
             ELSE
               #--- MOD-540177
                IF g_prog CLIPPED = "udm_tree" THEN
                   IF ls_udm7 IS NULL OR ls_udm7 != "Y" THEN
                      CALL cl_cmdrun(ls_cmd CLIPPED)
                   END IF
                ELSE
                   CALL cl_cmdrun(ls_cmd CLIPPED)
                END IF
              #----------
             END IF
            #--- MOD-540177
             IF g_prog CLIPPED = "udm_tree" AND ls_udm7 = "Y" THEN
                EXIT PROGRAM (g_lang + 10)
             ELSE
                EXIT PROGRAM
             END IF
           #----------
          END IF
       END IF
   END IF                                                    #TQC-760068
#----------
 
   #No.FUN-660135 --start--
   #No.FUN-580093
   CALL cl_process_login()
   #No.FUN-660135 ---end---
 
   # 2004/12/22 alex:在cl_user 中增加判斷,若g_rlang為null or empty就給予初始值
   IF g_rlang IS NULL OR g_rlang=" " THEN
      LET g_rlang = g_lang CLIPPED
   END IF
 
   # 2004/05/03 by saki : idle sec秒數以程式設定為先, 其次是權限, 系統設定
   # 2004/05/27 by saki : modify
   SELECT zz28,zz30 INTO lc_zz28,g_idle_seconds FROM zz_file WHERE zz01 = g_prog
   CASE lc_zz28
      WHEN '1'
         DISPLAY 'No idle control'
      WHEN '2'
         IF cl_null(g_idle_seconds) THEN
            LET g_idle_seconds = 10
         END IF
      WHEN '3'
         SELECT zw04,zw06 INTO lc_zw04,g_idle_seconds FROM zw_file WHERE zw01 = g_clas
         CASE lc_zw04
            WHEN '1'
               DISPLAY 'No idle control'
            WHEN '2'
               IF cl_null(g_idle_seconds) THEN
                  LET g_idle_seconds = 10
               END IF
            WHEN '3'
               SELECT aza33 INTO g_idle_seconds FROM aza_file WHERE aza01 = '0'
               IF (SQLCA.SQLCODE) THEN
                  LET g_idle_seconds = 10
               END IF
         END CASE
   END CASE
 
#  SELECT aza32 INTO g_trace FROM aza_file WHERE aza01='0'
#  IF (SQLCA.SQLCODE) THEN
#     LET g_trace = 'N' #是否顯現除錯訊息,預設為'N'.(by 系統)
#     LET g_idle_seconds = 10 #預設的 IDLE 秒數(by 系統)
#  END IF
 
   CALL cl_chk_err_setting()
 
#  WHENEVER ERROR CALL cl_err_msg_log
 
#  IF (g_trace = 'Y') THEN
#     DISPLAY "cl_user : g_idle_seconds = ",g_idle_seconds
#     DISPLAY "cl_user : g_need_err_log = ",g_need_err_log
#     DISPLAY "cl_user : g_bgjob = ",g_bgjob
#  END IF
 
   RETURN TRUE
END FUNCTION
 
# Descriptions...: 設定起始工廠.
# Date & Author..: 03/09/10 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
 
FUNCTION cl_set_default_plant()
   DEFINE   l_azz02      LIKE azz_file.azz02         #No.FUN-690005 VARCHAR(1)
   DEFINE   l_zx07       LIKE zx_file.zx07           #No.FUN-690005 VARCHAR(1)
#  DEFINE   lc_tty_no    LIKE zxx_file.zxx02         #No.FUN-690005 VARCHAR(32)   #No.TQC-880043 mark
   DEFINE   ls_tty_no    STRING
   DEFINE   li_cnt       LIKE type_file.num5           #No.FUN-690005 SMALLINT #No.FUN-660135
   DEFINE   ls_fglserver STRING   #No.FUN-660135
   DEFINE   ls_sql       STRING   #No.FUN-660135
   DEFINE   ls_gbq10     STRING   #No.FUN-660135
   DEFINE   lc_gbq10     LIKE gbq_file.gbq10   #No.FUN-660135
   DEFINE l_sid01   LIKE type_file.num20 #FUN-980030
   DEFINE l_pid     LIKE type_file.num10 #FUN-980030
   DEFINE l_sid_cnt SMALLINT #FUN-980030
   DEFINE   mi_timezone  LIKE type_file.num5   #FUN-9A0015
   DEFINE   l_azz05      LIKE azz_file.azz05   #FUN-9A0015 
   DEFINE   lc_timezone  LIKE azp_file.azp052  #FUN-9A0015 
   DEFINE   ls_cmd       STRING                #FUN-9A0015   
   DEFINE l_err_msg STRING #FUN-A20050
   DEFINE   li_zxy03_cnt SMALLINT #FUN-BB0007

   # No:FUN-BC0055 --- START ---
   #SELECT azz02,azz03,azz04,azz05 INTO l_azz02,g_plant,g_dbs,l_azz05 FROM azz_file WHERE azz01 = '0'   #FUN-9A0015
   #IF (SQLCA.SQLCODE) THEN
   #   CALL cl_err("azz_file get error.", SQLCA.SQLCODE, 2)
   #   RETURN FALSE
   #END IF
   #

   SELECT * INTO g_azz.* FROM azz_file WHERE azz01 = '0' 
   IF (SQLCA.SQLCODE) THEN
      CALL cl_err("azz_file get error.", SQLCA.SQLCODE, 2)
      RETURN FALSE
   ELSE
      LET l_azz02 = g_azz.azz02
      LET g_plant = g_azz.azz03
      LET g_dbs   = g_azz.azz04
      LET l_azz05 = g_azz.azz05
   END IF   
   # No:FUN-BC0055 --- END  ---  

   #FUN-980014 add begin
   SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_plant  #FUN-980014 add(抓出該營運中心所屬法人) 
   IF (SQLCA.SQLCODE) THEN
      #CALL cl_err("azw_file get error.", SQLCA.SQLCODE, 1)
      LET l_err_msg = "azw_file does not exist the plant : ",g_plant CLIPPED,"\n" #FUN-A20050:這裡無法用多語言,因為g_lang是在此method之後才設定的.
      CALL cl_err(l_err_msg, SQLCA.SQLCODE, 1) #FUN-A20050
      RETURN FALSE
   END IF
   #FUN-980014 add end
 
   LET g_multpl = l_azz02
   IF (g_multpl = 'N') THEN
      CLOSE DATABASE
      DATABASE g_dbs
      CALL cl_ins_del_sid(1, g_plant) #FUN-980030
 
      IF (SQLCA.SQLCODE) THEN
         RETURN FALSE
      ELSE
         RETURN TRUE
      END IF
   END IF
 
#----------
# While it's background job, switch database to setting one
#----------
   IF ( g_gui_type = 0 ) AND 
      ((FGL_GETENV("BGJOB")='1') OR (FGL_GETENV("EASYFLOW")='1')  #FUN-640184
    OR (FGL_GETENV("SPC")='1') OR (FGL_GETENV("TPGateWay") ='1')  #FUN-840004
    OR (FGL_GETENV("WSBGJOB")='1'))                               #FUN-8B0090
   THEN
      #--FUN-930132--start--
      IF FGL_GETENV("WSBGJOB") = '1' THEN
         LET g_user = FGL_GETENV("WSUSER")
      END IF
      #--FUN-930132--end--

      #FUN-D40075  --start--
      SELECT zx06 INTO g_lang FROM zx_file WHERE zx01=g_user
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err("zx_file get error.", SQLCA.SQLCODE, 2)
         RETURN FALSE
      END IF
      #FUN-D40075  --end--

      LET g_plant = FGL_GETENV("PARENTDB")    #FUN-B60068
      IF cl_null(g_plant) THEN
         LET g_dbs = FGL_GETENV("DB")
         SELECT azp01 INTO g_plant FROM azp_file WHERE azp03 = g_dbs
         #Begin:FUN-BB0007
         IF (SQLCA.SQLCODE) THEN
            CALL cl_err("azp_file get error.", SQLCA.SQLCODE, 2)
            RETURN FALSE
         END IF

         #判斷是否有權限,可避免後台更改資料造成問題.
         SELECT COUNT(*) INTO li_zxy03_cnt FROM zxy_file WHERE zxy01=g_user AND zxy03 = g_plant
         IF li_zxy03_cnt=0 THEN
            CALL cl_err("","sub-118",1)
            RETURN FALSE
         END IF
         #End:FUN-BB0007
      ELSE
         #Begin:FUN-BB0007
         #判斷是否有權限,可避免後台更改資料造成問題.
         SELECT COUNT(*) INTO li_zxy03_cnt FROM zxy_file WHERE zxy01=g_user AND zxy03 = g_plant
         IF li_zxy03_cnt=0 THEN
            CALL cl_err("","sub-118",1)
            RETURN FALSE
         END IF
         #End:FUN-BB0007
         SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01 = g_plant
      END IF                                  #FUN-B60068 end

      SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_plant  #FUN-980014 add(抓出該營運中心所屬法人) 
   ELSE
      #No.TQC-870015 --start-- 
     #SELECT zx07,zx08 INTO l_zx07,g_plant FROM zx_file WHERE zx01=g_user              #mark by FUN-D40075
      SELECT zx06,zx07,zx08 INTO g_lang, l_zx07,g_plant FROM zx_file WHERE zx01=g_user #FUN-D40075
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err("zx_file get error.", SQLCA.SQLCODE, 2)
         RETURN FALSE
      END IF
 
      #Begin:FUN-BB0007
      #判斷是否有權限,可避免後台更改資料造成問題.
      SELECT COUNT(*) INTO li_zxy03_cnt FROM zxy_file WHERE zxy01=g_user AND zxy03 = g_plant
      IF li_zxy03_cnt=0 THEN
         CALL cl_err("","sub-118",1)
         RETURN FALSE
      END IF
      #End:FUN-BB0007

     #FUN-980014 add begin
      SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_plant  #FUN-980014 add(抓出該營運中心所屬法人) 
      IF (SQLCA.SQLCODE) THEN
         #CALL cl_err("azw_file get error.", SQLCA.SQLCODE, 1) #FUN-A20050
         LET l_err_msg = "azw_file does not exist the plant : ",g_plant CLIPPED,"\n" #FUN-A20050:這裡無法用多語言,因為g_lang是在此method之後才設定的.
         CALL cl_err(l_err_msg, SQLCA.SQLCODE, 1) #FUN-A20050
         RETURN FALSE
      END IF
     #FUN-980014 add end
 
      IF (l_zx07 = 'Y') THEN
      #No.TQC-870015 ---end---
         #No.FUN-660135 --start--
         #查process裡面是否有記錄最後選擇的資料庫，沒有的話代表第一次進來，還是抓zx設定
         LET ls_fglserver = FGL_GETENV("FGLSERVER")
         LET ls_fglserver = cl_process_chg_iprec(ls_fglserver)   #No.FUN-740179
   
         LET ls_sql = "SELECT COUNT(*) FROM gbq_file ",
                      " WHERE gbq02 = '",ls_fglserver,"' AND gbq10 IS NOT NULL",
                      "   AND gbq03 = '",g_user,"'"     #No.TQC-680021
         PREPARE gbq_cnt_pre FROM ls_sql
         EXECUTE gbq_cnt_pre INTO li_cnt
         IF li_cnt > 0 THEN
            LET ls_sql = "SELECT gbq10 FROM gbq_file ",
                         " WHERE gbq02 = '",ls_fglserver,"' AND gbq10 IS NOT NULL",
                         "   AND gbq03 = '",g_user,"'"  #No.TQC-680021
            PREPARE gbq10_pre FROM ls_sql
            DECLARE gbq10_curs CURSOR FOR gbq10_pre
            FOREACH gbq10_curs INTO lc_gbq10
               LET ls_gbq10 = lc_gbq10 CLIPPED
               LET ls_gbq10 = ls_gbq10.subString(ls_gbq10.getIndexOf("/",1) + 1,ls_gbq10.getLength())
               LET g_plant = ls_gbq10
               EXIT FOREACH
            END FOREACH
            CLOSE gbq10_curs   #TQC-B60011
            FREE gbq10_curs    #TQC-B60011
#        ELSE                #No.TQC-870015 mark
         END IF              #No.TQC-870015
      #No.FUN-660135 ---end---
#No.TQC-870015 ---mark start--
#        SELECT zx07,zx08 INTO l_zx07,g_plant FROM zx_file WHERE zx01=g_user
#        IF (SQLCA.SQLCODE) THEN
#           CALL cl_err("zx_file get error.", SQLCA.SQLCODE, 2)
#           RETURN FALSE
#        END IF
#
#        # Mark By Raymon 多工廠的切換機制需要再調整(1. 取消 zxx_file 2.預設工廠 ...)
#        IF (l_zx07 = 'Y') THEN
#           #MOD-590023
#           CASE
#              WHEN (g_gui_type = 0) OR (g_gui_type = 1)
#                 LET lc_tty_no = FGL_GETENV('LOGTTY')
#              WHEN (g_gui_type = 2) OR (g_gui_type = 3)
#                 LET ls_tty_no = FGL_GETENV('FGLSERVER')
#                 LET lc_tty_no = ls_tty_no.trim()
#           END CASE
##
#           IF (lc_tty_no IS NULL) THEN
#              LET lc_tty_no = '-'
#           END IF
#           SELECT zxx03 INTO g_plant FROM zxx_file
#            WHERE zxx01=g_user AND zxx02=lc_tty_no
#           IF (g_plant IS NULL) THEN
#              IF (SQLCA.SQLCODE) THEN
#                 CALL cl_err("","lib-215",1)
#                 RETURN FALSE
#              ELSE
#                 ERROR "Please choose the plant code first!"
#              END IF
#           ELSE
#              SELECT * FROM azp_file WHERE azp01=g_plant  #MOD-590023
#              IF SQLCA.SQLCODE THEN
#                 CALL cl_err("zxx_file error! Use User's Default Data of Plant! Contact to Administrator","!",1)
#                 SELECT zx08 INTO g_plant FROM zx_file WHERE zx01=g_user
#              END IF
#           END IF
#        ELSE
#           IF (g_multpl = 'Y') THEN
#              LET g_multpl = 'N'
#           END IF
#        END IF
#No.TQC-870015 ---mark end---
      END IF     #No.FUN-660135
 
#     #FUN-910051
      IF FGL_GETENV("PARENTDB") IS NULL OR FGL_GETENV("PARENTDB") = " " THEN
      ELSE
#        IF g_prog <> "aoos901" THEN  #TQC-920009  TQC-920011
#           LET g_dbs = FGL_GETENV("PARENTDB")     #FUN-970098
#           SELECT azp01 INTO g_plant FROM azp_file WHERE azp03 = g_dbs
            IF g_prog <> "webpasswd" THEN          #TQC-BC0104
               LET g_plant = FGL_GETENV("PARENTDB")
               CALL FGL_SETENV("PARENTDB","")
            END IF 
#        END IF  #TQC-920009  TQC-920011
      END IF
#     #FUN-910051 End

      #Begin:FUN-BB0007
      #判斷是否有權限,可避免後台更改資料造成問題.
      SELECT COUNT(*) INTO li_zxy03_cnt FROM zxy_file WHERE zxy01=g_user AND zxy03 = g_plant
      IF li_zxy03_cnt=0 THEN
         CALL cl_err("","sub-118",1)
         RETURN FALSE
      END IF
      #End:FUN-BB0007
         
      SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01=g_plant
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err("azp_file get error", SQLCA.SQLCODE, 2)
      END IF
   END IF
 
#  # 2003/09/19 by Hiko : 變更現行工廠.
#  CLOSE DATABASE
#  DATABASE ds
#  IF (SQLCA.SQLCODE) THEN
#     RETURN FALSE
#  END IF
#
#  SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01=g_plant
#  IF (SQLCA.SQLCODE) THEN
#     CALL cl_err("azp_file get error", SQLCA.SQLCODE, 2)
#  END IF
 
   CLOSE DATABASE
   DATABASE g_dbs
   CALL cl_ins_del_sid(1, g_plant) #FUN-980030
 
   IF (SQLCA.SQLCODE) THEN
      RETURN FALSE
   END IF
   #FUN-960141 add
   SELECT * INTO g_azw.* FROM azw_file WHERE azw01 = g_plant    #FUN-A60043
   #Begin:FUN-A10055
   #LET g_auth = '"',g_plant,'"'
   #LET g_auth = " (",g_auth CLIPPED,")" 
   #LET g_auth =cl_replace_str(g_auth, "\"", "'")
   #LET g_auth = "(",cl_get_plant_tree(g_user, g_plant),")"
   LET g_auth = "(",s_get_plant_tree(g_plant),")" #FUN-A50080
   #End:FUN-A10055
   #FUN-960141 end
   
   #FUN-9A0015 start
   IF STATUS OR l_azz05 <> "Y" OR l_azz05 IS NULL THEN
      LET mi_timezone = FALSE
   ELSE
      LET mi_timezone = TRUE
   END IF
      
   IF (mi_timezone) THEN
      SELECT azp052 INTO lc_timezone FROM azp_file WHERE azp01=g_plant
      IF STATUS OR cl_null(lc_timezone) THEN
         LET lc_timezone = "GMT+8"    #Default Time Zone Direct to Taiwan.
      END IF
      DISPLAY 'INFO: Your Plant (',g_plant CLIPPED,') is setting in ',lc_timezone CLIPPED,' time zone.' 
      LET ls_cmd = lc_timezone  CLIPPED
      IF ls_cmd.getIndexOf("+",1) THEN
         LET lc_timezone = ls_cmd.subString(1,ls_cmd.getIndexOf("+",1)-1),"-",ls_cmd.subString(ls_cmd.getIndexOf("+",1)+1,ls_cmd.getLength())
      ELSE
         IF ls_cmd.getIndexOf("-",1) THEN
            LET lc_timezone = ls_cmd.subString(1,ls_cmd.getIndexOf("-",1)-1),"+",ls_cmd.subString(ls_cmd.getIndexOf("-",1)+1,ls_cmd.getLength())
         END IF
      END IF
      
      CALL fgl_setenv("TZ",lc_timezone CLIPPED)
   END IF
   #FUN-9A0015 end
   RETURN TRUE
END FUNCTION
 
# Descriptions...: 判斷目前使用者所使用的前端介面為何種模式.
# Date & Author..: 03/09/10 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   前端介面的代碼
 
FUNCTION cl_fglgui()
   DEFINE   li_gui_type   LIKE type_file.num5           #No.FUN-690005 SMALLINT
   DEFINE   ls_arg        STRING
 
   CASE 
      WHEN FGL_GETENV('FGLGUI') = '1' AND FGL_GETENV('WEBMODE') = '1'
         LET li_gui_type = 3   #WEB(ActiveX, Java)
      WHEN FGL_GETENV('FGLGUI') = '1' AND FGL_GETENV('GWC') = '1'
         LET li_gui_type = 2   #WEB(Browser)
      WHEN FGL_GETENV('FGLGUI') = '1'
         LET li_gui_type = 1   #WINDOWS(GUI)  
      WHEN FGL_GETENV('FGLGUI') = '0'
         LET li_gui_type = 0   #ASCII(TEXT) 
   END CASE
 
   RETURN li_gui_type
END FUNCTION
 
#-- No.FUN-7B0109 BEGIN --------------------------------------------------------
 
# Descriptions...: 取得主機端系統 DVM 版本資訊
# Date & Author..: 2007/11/23 by Brendan
# Input Parameter: none
# Return Code....: ls_verion - DVM 版本(e.x. 1.33.2f)
 
FUNCTION cl_get_dvm_version()
    DEFINE li_idx     INTEGER
    DEFINE lch_cmd    base.Channel
    DEFINE ls_buf     STRING,
           ls_version STRING,
           ls_str     STRING
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    #---------------------------------------------------------------------------
    # 利用 'fpi' 指令擷取 DVM 版本
    #---------------------------------------------------------------------------
    INITIALIZE ls_version TO NULL
    LET lch_cmd = base.Channel.create()
#   CALL lch_cmd.openPipe("fpi", "r")        #FUN-B60158 Genero 2.32起取消 fpi
    CALL lch_cmd.openPipe("fglrun -V", "r")
    WHILE lch_cmd.read(ls_buf)
        LET ls_str = ls_buf
        LET ls_buf = ls_buf.toUpperCase()
#       IF ( li_idx := ls_buf.getIndexOf("VERSION", 1) ) THEN
#          LET ls_version = ls_str.subString(li_idx + 7, ls_str.getLength())
        IF ( li_idx := ls_buf.getIndexOf("BUILD", 1) ) THEN
           LET ls_version = ls_str.subString(li_idx - 9, li_idx - 1 )
           LET ls_version = ls_version.trim()
           EXIT WHILE
        END IF
    END WHILE
    CALL lch_cmd.close()
     
    RETURN ls_version
END FUNCTION
 
# Descriptions...: 取得使用者 GDC 版本資訊
# Date & Author..: 07/11/23 by Brendan
# Input Parameter: none
# Return Code....: ls_verion - GDC 版本(e.x. 1.33.1b)
 
FUNCTION cl_get_gdc_version()
    DEFINE ls_version STRING
 
 
    INITIALIZE ls_version TO NULL
    LET ls_version = ui.Interface.getFrontEndVersion()
 
    RETURN ls_version
END FUNCTION
 
# Descriptions...: 取得主機端系統目前設定的語系(一律轉成大寫)
# Date & Author..: 07/11/23 by Brendan
# Input Parameter: none
# Return Code....: ls_locale - 系統語系(e.x. ZH_TW)
 
FUNCTION cl_get_locale()
    DEFINE ls_locale STRING
    DEFINE li_i      INTEGER
 
    INITIALIZE ls_locale TO NULL
    LET ls_locale = FGL_GETENV("LANG")
    LET li_i = ls_locale.getIndexOf(".", 1)
    IF li_i != 0 THEN
       LET ls_locale = ls_locale.subString(1, li_i - 1)
    END IF
    LET ls_locale = ls_locale.toUpperCase()
 
    RETURN ls_locale
END FUNCTION
 
# Descriptions...: 取得主機端系統目前設定的語言別(一律轉成大寫)
# Date & Author..: 07/11/23 by Brendan
# Input Parameter: none
# Return Code....: ls_codeset - 語言別(e.x. BIG5)
 
FUNCTION cl_get_codeset()
 
    DEFINE ls_codeset STRING
    DEFINE lch_cmd    base.Channel
    DEFINE ls_tmp1    STRING                    #FUN-980097
    DEFINE ls_tmp2    STRING                    #FUN-980097
    DEFINE li_pos     LIKE type_file.num5
 
    #---------------------------------------------------------------------------
    # 利用 locale charmap 指令取得系統設定的語言別
    #---------------------------------------------------------------------------
    INITIALIZE ls_codeset TO NULL
    LET lch_cmd = base.Channel.create()
 
    IF os.Path.separator() = "/" THEN
       CALL lch_cmd.openPipe("locale charmap | cut -d. -f1 | tr -d \"'\"'\"'", "r")   #MOD-590056  FUN-980097 
       WHILE lch_cmd.read(ls_codeset)
       END WHILE
    ELSE 
       LET ls_tmp1 = FGL_GETENV("FGLRUN")
       IF ls_tmp1.getLength() = 0 THEN
          LET ls_tmp1 = os.Path.join(os.Path.join(FGL_GETENV("FGLDIR"),"bin"),"fglrun")
       END IF
       LET ls_tmp2 = os.Path.join(FGL_GETENV("TEMPDIR"),FGL_GETENV("LOGNAME")||".loc")
#      CALL lch_cmd.openPipe(ls_tmp1.trim()||" -i mbcs 2>"||ls_tmp2.trim()||"|cut -d : -f2", "r")
       CALL lch_cmd.openPipe(ls_tmp1.trim()||" -i mbcs 2>"||ls_tmp2.trim()||"|type "||ls_tmp2.trim(), "r")
       WHILE lch_cmd.read(ls_codeset)
          LET ls_codeset = DOWNSHIFT(ls_codeset)
          LET li_pos = ls_codeset.getIndexOf("charmap",1) 
          IF li_pos > 0 THEN
             LET ls_codeset = ls_codeset.subString(ls_codeset.getIndexOf(":",1)+1,ls_codeset.getLength())
             LET ls_codeset = ls_codeset.trim()
             EXIT WHILE
          ELSE
             LET ls_codeset = "UTF-8"    #當找不到時預設為 UTF-8
          END IF
       END WHILE
    END IF 
    CALL lch_cmd.close()
 
    IF os.Path.delete(ls_tmp2) THEN END IF         #FUN-980097
    
    LET ls_codeset = UPSHIFT(ls_codeset.trim())    #FUN-980097
 
    #---------------------------------------------------------------------------
    # HP-UX 上 UTF-8 會表示為 UTF8
    #---------------------------------------------------------------------------
    IF ls_codeset = "UTF8" THEN
       LET ls_codeset = "UTF-8"
    END IF
 
    RETURN ls_codeset.trim()     #FUN-980097
END FUNCTION
 
# Descriptions...: 取得目前採用的簡繁轉碼機制類別(一律大寫)
# Date & Author..: 07/11/23 by Brendan
# Input Parameter: none
# Return Code....: ls_b5_gb - (1)NULL 值:無使用簡繁轉換機制執行程式 (2)"BIG5":使用 fglrun -t big5 執行程式 (3)"GB2312":使用 fglrun -t gb2312 執行程式 (4)"GBK":使用 fglrun -t gbk 執行程式
 
FUNCTION cl_get_b5_gb()
 
    DEFINE ls_b5_gb STRING
    DEFINE lch_cmd  base.Channel
    DEFINE ls_proc  STRING
 
    #---------------------------------------------------------------------------
    # 利用 ps 指令取得目前 runtime 執行的方式(是否有 -t big5 / -t gb2312 / -t gbk 參數)
    #---------------------------------------------------------------------------
    INITIALIZE ls_b5_gb TO NULL

    #Windows平台均以UNICODE進行作業執行
    IF NOT os.Path.separator() = "/" THEN
       RETURN ls_b5_gb
    END IF

    LET lch_cmd = base.Channel.create()
 
   #CALL lch_cmd.openPipe("COLUMNS=132;export COLUMNS;ps -ef | grep " || FGL_GETPID(), "r")   #FUN-980097
 
    CALL FGL_SETENV("COLUMNS","132")
    CALL lch_cmd.openPipe("ps -ef | grep " || FGL_GETPID(), "r") 

    WHILE lch_cmd.read(ls_proc)
        CASE
            WHEN ls_proc.getIndexOf("-t big5", 1)
                 LET ls_b5_gb = "BIG5"
                 EXIT WHILE
            WHEN ls_proc.getIndexOf("-t gb2312", 1)
                 LET ls_b5_gb = "GB2312"
                 EXIT WHILE
            WHEN ls_proc.getIndexOf("-t gbk", 1)
                 LET ls_b5_gb = "GBK"
                 EXIT WHILE
        END CASE
    END WHILE

    CALL lch_cmd.close()
 
    RETURN ls_b5_gb
END FUNCTION
 
#-- No.FUN-7B0109 END ----------------------------------------------------------
 
# Descriptions...: 當傳入的參數是用單引號括住時,改為使用雙引號括住
# Date & Author..: 09/03/25 by alex  #FUN-930154
# Input Parameter: ls_param STRING參數
# Return Code....: ls_param STRING參數
 
FUNCTION cl_trans_singlequota(ls_param)
 
    DEFINE ls_param  STRING
    DEFINE ls_new    STRING
    DEFINE li_cnt    LIKE type_file.num5
    DEFINE li_end    LIKE type_file.num5
    DEFINE lc_chr    LIKE type_file.chr1
    DEFINE ls_tmp    STRING               #FUN-A70009
 
    LET ls_param = ls_param.trim()
    IF ls_param.getLength() <= 1 THEN RETURN ls_param END IF
 
    LET li_cnt = 1
    WHILE TRUE
       LET lc_chr = ls_param.subString(li_cnt,li_cnt)
       IF lc_chr = "'" OR lc_chr = '"' THEN
          LET li_end = ls_param.getIndexOf(lc_chr,li_cnt+1)
          CASE li_end
             WHEN 0
                LET ls_new = ls_new," ",ls_param.subString(li_cnt,ls_param.getLength())
                EXIT WHILE
             WHEN li_cnt + 1
                LET ls_new = ls_new,' ""'
             OTHERWISE
                LET ls_tmp = cl_trans_singlequota_inside(ls_param.subString(li_cnt+1,li_end-1))  #FUN-A70009 處理中間段
                LET ls_new = ls_new,' "',ls_tmp,'"'  
#               LET ls_new = ls_new,' "',ls_param.subString(li_cnt+1,li_end-1),'"'
          END CASE
          IF li_end = ls_param.getLength() THEN
             EXIT WHILE
          ELSE
             LET ls_param = ls_param.subString(li_end+1,ls_param.getLength())
             LET ls_param = ls_param.trim()
             IF ls_param.getLength() <= 1 THEN
                LET ls_new = ls_new," ",ls_param
                EXIT WHILE
             END IF
          END IF
       ELSE
          LET li_end = ls_param.getIndexOf(" ",li_cnt+1)
          IF li_end = 0 THEN
             LET ls_new = ls_new," ",ls_param.trim()
             EXIT WHILE
          ELSE
             LET ls_new = ls_new," ",ls_param.subString(1,li_end-1)
             LET ls_param = ls_param.subString(li_end+1,ls_param.getLength())
             LET ls_param = ls_param.trim()
          END IF
       END IF
    END WHILE
    RETURN ls_new.trim()
 
END FUNCTION
 
# Private Func...: TRUE          #FUN-B50108
# Descriptions...: 置換成雙引號
# Input Parameter: ls_str - 來源字串
# Return Code....: ls_new - 新字串 
# Memo...........:

PRIVATE FUNCTION cl_trans_singlequota_inside(ls_str)   #FUN-A70009

   DEFINE ls_str   STRING
   DEFINE ls_new   STRING
   DEFINE li_pos   LIKE type_file.num5

   LET li_pos = ls_str.getIndexOf('"',1)
   IF li_pos = 0 THEN RETURN ls_str END IF

   WHILE TRUE
      LET li_pos = ls_str.getIndexOf('"',1)
      CASE
         WHEN li_pos = 0
            LET ls_new = ls_new,ls_str
            EXIT WHILE
         WHEN li_pos = 1
            LET ls_new = '\\\"'
            LET ls_str = ls_str.subString(2,ls_str.getLength())
         WHEN li_pos > 1
            LET ls_new = ls_new,ls_str.subString(1,li_pos - 1),'\\\"'
            LET ls_str = ls_str.subString(li_pos+1,ls_str.getLength())
      END CASE
   END WHILE

   RETURN ls_new
END FUNCTION

#---FUN-B50017---start--
#[ 
# Descriptions...: 取得主機端系統 fastcgidispatch 版本資訊
# Date & Author..: 2011/05/20 by Jay
# Input Parameter: none
# Return Code....: ls_verion - DVM 版本(e.x. 2.30.13)
# Memo...........:
# Modify.........:
#  
#] 
FUNCTION cl_get_fastcgidispatch_version()
    DEFINE li_idx     INTEGER
    DEFINE lch_cmd    base.Channel
    DEFINE ls_buf     STRING,
           ls_version STRING,
           ls_str     STRING,
           l_key      STRING
    DEFINE l_str      INTEGER,
           l_end      INTEGER


    WHENEVER ERROR CALL cl_err_msg_log

    #---------------------------------------------------------------------------
    # 利用 'fastcgidispatch -V' 指令擷取 fastcgi和GAS 版本
    #---------------------------------------------------------------------------
    INITIALIZE ls_version TO NULL
    LET lch_cmd = base.Channel.create()
    LET l_key = "fastcgidispatch"
    CALL lch_cmd.openPipe(l_key || " -V", "r")
    WHILE lch_cmd.read(ls_buf)
        LET ls_str = ls_buf
        LET ls_buf = ls_buf.toLowerCase()
        IF ( li_idx := ls_buf.getIndexOf(l_key, 1) ) THEN
        	 LET l_str = li_idx + l_key.getLength()
        	 LET l_end = ls_buf.getIndexOf(" ", l_str + 1) - 1
           LET ls_version = ls_str.subString(l_str, l_end)
           LET ls_version = ls_version.trim()
           EXIT WHILE
        END IF
    END WHILE
    CALL lch_cmd.close()

    RETURN ls_version
END FUNCTION
#---FUN-B50017---end-----


# No:FUN-BA0116 --- start---
# Descriptions...: Unicode碼別中，提供繁簡體資料轉換功能
# Date & Author..: 11/10/31 By alex
# Input Parameter: lc_gay01 目前所在的語言別(僅限於繁簡體轉換)
#                  ls_str  欲參考的繁體或簡體字串
# Return Code....: ls_str  轉換完碼別的繁體或簡體字串

FUNCTION cl_trans_utf8_twzh(lc_gay01,ls_str)

   DEFINE lc_gay01   LIKE gay_file.gay01
   DEFINE ls_str     STRING
   DEFINE ls_cmd     STRING
   DEFINE ls_path    STRING
   DEFINE lc_channel base.Channel
   DEFINE l_str_ch     base.Channel #FUN-BB0125
   #Begin:FUN-BB0152
   DEFINE l_rep_key   STRING,   #要取代特殊字元的key
          l_sbuf      base.StringBuffer, #最後要透過StringBuffer來合併l_sym_arr的資料
          l_char_idx  SMALLINT, #來源字串的字元索引
          l_char      STRING,   #依據l_char_idx取得的字元
          l_more      SMALLINT, #為了避免特殊字元取替代時會有過多的空白,所以要記錄特殊字元還有多少長度
          l_char_trim STRING,   #為了檢查方便,所以將字元trim空白
          l_chk_sql   STRING,   #判斷l_char是否為特殊字元的SQL
          l_sp_cnt    SMALLINT, #執行l_chk_sql的回傳值
          l_chk_str   STRING,   #真正需要檢查的字串
          l_sym_arr   DYNAMIC ARRAY OF STRING, #儲存特殊字元的字串陣列
          l_sym_idx   SMALLINT  #l_sym_arr所需的陣列索引
   #End:FUN-BB0152

   #判斷何種情況不做
   IF cl_null(ls_str) THEN RETURN NULL END IF
   LET ls_path = os.Path.join(FGL_GETENV("TEMPDIR"),FGL_GETPID())

   #準備轉檔
   LET ls_cmd = "\\rm -rf ",ls_path,"_a.txt ",ls_path,"_b.txt ",ls_path,"_c.txt ",ls_path,"_d.txt"
   RUN ls_cmd

   #Begin:FUN-BB0152:此段與cl_about.4gl內的FUNCTION cl_get_check_string雷同,但因為這裡還需要做最後的取替代,因此無法共用,所以就寫在這裡.
   LET ls_str = ls_str.trim()
   LET l_rep_key = "Φ" #此字元符合unicode,且ERP應該很少用到,就拿來當作替代的key.
   LET l_sbuf = base.StringBuffer.create()

   FOR l_char_idx=1 TO ls_str.getLength()
      IF l_more>0 THEN #這裡是參考cl_set_data_mask的做法.
         LET l_more = l_more - 1
      ELSE
         LET l_char = ls_str.getCharAt(l_char_idx)
         IF l_char IS NOT NULL THEN
            IF l_char.getLength()>1 THEN
               LET l_more = l_char.getLength() - 1 #這裡很重要,決定了之後替代字串時是否正確.
               LET l_char_trim = l_char.trim()
               #因為包含特殊符號的資料畢竟少數,因此先以SQL檢查速度會比較快.
               LET l_chk_sql = "SELECT COUNT(*) FROM gfq_file WHERE gfq02='",l_char_trim,"'"
               PREPARE chk_sp_pre FROM l_chk_sql
               EXECUTE chk_sp_pre INTO l_sp_cnt
               FREE chk_sp_pre
               IF l_sp_cnt > 0 THEN #表示要檢查的字串包含了特殊符號,所以要剃除此特殊字元.
                  CALL l_sbuf.append(l_rep_key) #為了之後要取替代,所以先以此符號替代特殊符號.
                  LET l_sym_idx = l_sym_idx + 1
                  LET l_sym_arr[l_sym_idx] = l_char_trim #將特殊符號暫存,待之後替代.
               ELSE
                  CALL l_sbuf.append(l_char_trim) #這裡是暫存中文字.
               END IF
            ELSE
               CALL l_sbuf.append(l_char) #這裡是暫存非中文字,且非特殊符號.
            END IF
         END IF
      END IF
   END FOR

   LET l_chk_str = l_sbuf.toString()
   #End:FUN-BB0152

   CASE
      WHEN lc_gay01 = '2'
         #Begin:FUN-BB0105
         #LET ls_cmd = "echo '",ls_str,"' > ",ls_path,"_a.txt"
         #RUN ls_cmd
         LET l_str_ch = base.Channel.create()
         CALL l_str_ch.openFile(ls_path||"_a.txt", "w")
         #CALL l_str_ch.writeLine(ls_str.trim()) #FUN-BB0152
         CALL l_str_ch.writeLine(l_chk_str) #FUN-BB0152
         CALL l_str_ch.close()
         #End:FUN-BB0105
         LET ls_cmd = "iconv -f UTF-8 -t BIG5 ",ls_path,"_a.txt > ",ls_path,"_b.txt "
         RUN ls_cmd
         LET ls_cmd = "iconv -f BIG5 -t GB2312 ",ls_path,"_b.txt > ",ls_path,"_c.txt "
         RUN ls_cmd
         LET ls_cmd = "iconv -f GB2312 -t UTF-8 ",ls_path,"_c.txt > ",ls_path,"_d.txt "
         RUN ls_cmd
      WHEN lc_gay01 = '0'
         #Begin:FUN-BB0105
         #LET ls_cmd = "echo '",ls_str,"' > ",ls_path,"_a.txt"
         #RUN ls_cmd
         LET l_str_ch = base.Channel.create()
         CALL l_str_ch.openFile(ls_path||"_a.txt", "w")
         #CALL l_str_ch.writeLine(ls_str.trim()) #FUN-BB0152
         CALL l_str_ch.writeLine(l_chk_str) #FUN-BB0152
         CALL l_str_ch.close()
         #End:FUN-BB0105
         LET ls_cmd = "iconv -f UTF-8 -t GB2312 ",ls_path,"_a.txt > ",ls_path,"_b.txt "
         RUN ls_cmd
         LET ls_cmd = "iconv -f GB2312 -t BIG5 ",ls_path,"_b.txt > ",ls_path,"_c.txt "
         RUN ls_cmd
         LET ls_cmd = "iconv -f BIG5 -t UTF-8 ",ls_path,"_c.txt > ",ls_path,"_d.txt "
         RUN ls_cmd
      OTHERWISE
         RETURN ls_str
   END CASE
   IF os.Path.size(ls_path||"_a.txt") = 0 OR
      os.Path.size(ls_path||"_b.txt") = 0 OR
      os.Path.size(ls_path||"_c.txt") = 0 OR
      os.Path.size(ls_path||"_d.txt") = 0 THEN
      CALL cl_err("Treanlate Error!","!",1)
      LET ls_cmd = "\\rm -rf ",ls_path,"_a.txt ",ls_path,"_b.txt ",ls_path,"_c.txt ",ls_path,"_d.txt"
      RUN ls_cmd
      RETURN ls_str
   END IF

   #讀回轉完檔的資料
   LET lc_channel = base.Channel.create()
   CALL lc_channel.setDelimiter("")
   CALL lc_channel.openPipe("cat "||ls_path||"_d.txt","r")
   WHILE lc_channel.read(ls_str)
      EXIT WHILE
   END WHILE
   CALL lc_channel.close()

   #刪除不需要的暫存檔案
   LET ls_cmd = "\\rm -rf ",ls_path,"_a.txt ",ls_path,"_b.txt ",ls_path,"_c.txt ",ls_path,"_d.txt"
   RUN ls_cmd

   #Begin:FUN-BB0152:將特殊字元與檢查過後的字串合併.
   CALL l_sbuf.clear()
   CALL l_sbuf.append(ls_str) #將檢查過後的字串塞入到StringBuffer內.

   FOR l_sym_idx=1 TO l_sym_arr.getLength()
      CALL l_sbuf.replace(l_rep_key,l_sym_arr[l_sym_idx],1)
   END FOR

   LET ls_str = l_sbuf.toString()
   #End:FUN-BB0152

   RETURN ls_str
END FUNCTION
# No:FUN-BA0116 --- end ---

# No:FUN-CA0016 ---start---
FUNCTION cl_get_user()

   # 此FUNCTION的程式段由cl_user搬移過來，
   # 將此段寫成獨立FUNCTION是因為以便於讓其他程式段呼叫以取得g_user的值

   LET g_gui_type = cl_fglgui()

   #FUN-640184
   IF (fgl_getenv("EASYFLOW") = '1' OR fgl_getenv("SPC")='1' OR  #FUN-680011
       fgl_getenv("TPGateWay") = '1' OR fgl_getenv("WSBGJOB")='1' )  #FUN-840004 #FUN-8B0090
       AND g_gui_type = 0
   THEN
        LET g_bgjob = 'Y'
   END IF
   #END FUN-640184

   CASE
      WHEN (g_gui_type = 0) AND (FGL_GETENV("BGJOB") = '1') AND (FGL_GETENV("WEBMODE") = '1') #Background Job from WEB Mode
         LET g_user = FGL_GETENV("WEBUSER")
      WHEN (g_gui_type = 0) OR (g_gui_type = 1)
         IF g_bgjob='N' OR cl_null(g_bgjob) THEN        #FUN-640184
         END IF
      #   #MOD-580216
      #  IF (lc_zb02 = '2') THEN
      #     LET ls_tty_no = FGL_GETENV("LOGTTY")
      #     LET g_user = ls_tty_no.subString(6,20)
      #  ELSE #Login user
            #LET g_user=fgl_getenv('LOGNAME')
            LET g_user = FGL_GETENV("LOGNAME")
      #  END IF
      WHEN (g_gui_type = 2) OR (g_gui_type = 3)
         LET g_user = FGL_GETENV("WEBUSER")
   END CASE
END FUNCTION
# No:FUN-CA0016 --- end ---
