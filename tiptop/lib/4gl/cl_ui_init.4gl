# Prog. Version..: '5.30.07-13.05.16(00010)'     #
#
# Program name...: cl_ui_init.4gl
# Descriptions...: 程式設定初始化.
# Date & Author..: 03/06/27 by Hiko
# Memo...........: 顯示"%客戶名稱","%日期","%使用者"於上方程式列.
# Usage..........: CALL cl_ui_init()
# Modify.........: 04/03/31 By Brendan
# Modify.........: 04/08/27 By alex 新增 mc_g_bookno 帳別顯示代碼 
# Modify.........: No.MOD-530219 05/03/23 By alex 修正共用程式 TaskBar Name
# Modify.........: No.FUN-560233 05/06/28 By saki 更改縮小視窗後的功能列名稱顯示
# Modify.........: No.FUN-560038 05/10/17 By alex 處理 TOPCONFIG,CUSTCONFIG
# Modify.........: No.TQC-640176 06/04/21 By alexstar 動態語言切換功能(dynamic_locale) 加強, 當沒有其他語言可供切換時, action 應 disable
#                  1. 當 p_lang 設定只有一種語言別時, 則動態語言切換應 disable
#                  2. 當只有簡/繁兩種語言別且非國際版時, 則除 "udm_tree" 外的其他程式動態語言切換應 disable
# Modify.........: No.FUN-660048 06/06/26 By Echo 新增 TOPMENU 可串接 EXPRESS 報表
# Modify.........: No.FUN-680095 06/09/19 By alexstar 執行程式前讀取不到p_perlang相關語言資料時
#                  open window顯示[讀取不到xxxx語言畫面介面資料,所以將以預設的xxx語言顯示畫面]
# Modify.........: No.FUN-690005 06/09/15 By cheunl 欄位型態定義，改為LIKE 
# Modify.........: No.TQC-6B0165 06/08/30 By alexstar 修正ls_pername長度的問題
# Modify.........: No.TQC-740052 07/04/13 By saki 無畫面時，警告錯誤訊息
# Modify.........: No.FUN-740138 07/04/23 By Brendan 整合 Crystal Report 的報表作業, 其 "特殊列印條件" 欄位應隱藏(待串 CR 報表可指定背景執行後再開放)
# Modify.........: No.TQC-760001 07/06/01 By Smapmin 修復shell造成的錯誤
# Modify.........: No.FUN-770010 07/07/04 By saki 改變顯示logo
# Modify.........: No.FUN-7A0029 07/10/18 By Echo 調整 p_ze 訊息，將"lib-353"改為"lib-356"
# Modify.........: No.FUN-7B0028 07/11/12 By alex 修訂註解以配合自動抓取機制
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7C0078 07/12/25 By jacklai 配合CrystalReports背景作業功能,開放 "特殊列印條件" 欄位
# Modify.........: No.FUN-830021 08/03/06 By alex 取消gay02使用
# Modify.........: No.MOD-840144 08/04/18 By Dido 若 p_perlang 查無語言別時改抓取 gay01 為預設值
# Modify.........: No.FUN-840065 08/04/15 By kevin 新增menu(BI關聯報表)
# Modify.........: No.TQC-890052 08/09/25 By clover 執行程式前讀取不到p_per資料時,警告錯誤訊息
# Modify.........: No.FUN-920064 09/02/09 By alex 有開啟時區者於日期title後加時區表示式
# Modify.........: No.FUN-960141 09/07/15 By dongbg Gp5.2:title顯示g_plant
# Modify.........: No.FUN-970004 09/07/27 By Hiko 縮小視窗後的功能列名稱顯示營運中心
# Modify.........: No.FUN-980097 09/09/10 By alex 將wos合併入msv
# Modify.........: No.FUN-9B0156 09/11/30 By alex 調整ATTRIBUTES
# Modify.........: No.FUN-A10029 10/01/06 By alex 抓取formname 含.tmp字樣時自動刪除
# Modify.........: No:FUN-A10027 10/01/08 By tsai_yen 當agls103不顯示帳別時title bar也顯示營運中心
# Modify.........: No:FUN-A10041 10/01/08 By Hiko title bar也顯示營運中心的說明
# Modify.........: No.FUN-B50102 11/05/17 By tsai_yen 函式說明
# Modify.........: No:FUN-B70007 11/07/05 By jrg542 在EXIT PROGRAM前加上CALL cl_used(2)
# Modify.........: No:FUN-BB0005 11/11/07 BY LeoChang 新增報表TITLE是否呈現營運中心的參數讓user做選擇
# Modify.........: No.MOD-C40107 12/04/17 By madey 修正取時區(azp052)時的where condition
# Modify.........: No:FUN-CB0113 12/11/26 By benson 當CRIP變數為空值時，隱藏output的action
 
IMPORT os    #FUN-980097
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
# 2004/02/03 by Hiko : cl_dynamic_locale呼叫時的判斷依據.
GLOBALS
   DEFINE   mi_call_by_dynamic_locale   LIKE type_file.num5    #No.FUN-690005 SMALLINT
   DEFINE   ms_locale                   STRING,   #TQC-640176
            ms_codeset                  STRING,   #TQC-640176
            ms_b5_gb                    STRING    #TQC-640176
 
END GLOBALS
 
DEFINE   ms_frm_name   STRING                 # 04/02/06 Hiko共用畫面時的畫面名稱
DEFINE   mc_g_bookno   LIKE aaf_file.aaf01    # 04/08/27 alex s_dsmark帳別編號
DEFINE   cl_langcount  LIKE type_file.num5    #No.FUN-690005 SMALLINT            #TQC-640176
 
##################################################
# Descriptions...: 作業程式首次執行 OPEN WINDOWS 時需叫用此函式以初始化畫面變數值
# Date & Author..: 2003/10/31 by Hiko
# Input Parameter: none
# Return code....: void
# Modify.........: 04/03/31 by Brendan
# Modify.........: 04/08/27 by alex
# Modify.........: No.FUN-7B0028 07/11/12 alex 修訂註解以配合自動抓取機制
##################################################
 
FUNCTION cl_ui_init()
 
   DEFINE     lc_zz25     LIKE zz_file.zz25
   DEFINE     lc_gaz03    LIKE gaz_file.gaz03
   DEFINE     ls_win_name STRING
   DEFINE     l_sql       STRING   #TQC-640176
   DEFINE     l_lang1     LIKE type_file.num5    #TQC-640176   #No.FUN-690005 SMALLINT
   DEFINE     l_lang2     LIKE type_file.num5    #TQC-640176   #No.FUN-690005 SMALLINT
   DEFINE     ls_lang_check LIKE type_file.num5        #FUN-680095  #No.FUN-690005 SMALLINT 
   DEFINE     ls_lang_sql     STRING                       #FUN-680095
   DEFINE     ls_msg1         LIKE gay_file.gay03          #FUN-680095
   DEFINE     ls_msg2         LIKE gay_file.gay03          #FUN-680095
   DEFINE     ls_sellang      LIKE gay_file.gay03          #FUN-680095
   DEFINE     ls_sys_lang     STRING                       #FUN-680095
   DEFINE     ls_default_lang LIKE gay_file.gay01          #FUN-680095 #FUN-830021
   DEFINE     ls_pername      LIKE gae_file.gae01          #FUN-680095 #TQC-6B0165
   DEFINE     lw_window       ui.Window                    #FUN-680095
   DEFINE     lf_form         ui.Form                      #FUN-680095
   DEFINE     lnode_frm       om.DomNode                   #FUN-680095
   DEFINE     ls_formName     STRING                       #FUN-680095
   DEFINE     li_idx          LIKE type_file.num10         #FUN-680095  #No.FUN-690005 INTEGER
   DEFINE     li_cnt          LIKE type_file.num5          #FUN-740138
   DEFINE     ls_data_sql     STRING
   DEFINE     ls_data_check   LIKE type_file.num5          #TQC-890052
 
   WHENEVER ERROR CALL cl_err_msg_log
 
  #FUN-680095---start---
--Getting node of UI & Form, for later job ...
   LET lw_window = ui.Window.getCurrent()
   LET lf_form = lw_window.getForm()
   IF lf_form IS NULL THEN
      #No.TQC-740052 --start--
#     RETURN
      CALL cl_err("","lib-361",1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
      EXIT PROGRAM
      #No.TQC-740052 ---end---
   END IF
   LET lnode_frm = lf_form.getNode()
--#
--Condition: same program id with different opened form
   LET ls_formName = lnode_frm.getAttribute("name")
   LET li_idx = ls_formName.getIndexOf(".tmp", 1)   #FUN-A10029
   IF li_idx != 0 THEN
      LET ls_formName = ls_formName.subString(1, li_idx - 1)
   END IF
   LET li_idx = ls_formName.getIndexOf("T", 1)
   IF li_idx != 0 THEN
      LET ls_formName = ls_formName.subString(1, li_idx - 1)
   END IF
 
   LET ls_pername = ls_formName.trim()
  #---MOD-840144---start---
  #LET ls_sys_lang = FGL_GETENV("LANG")
  #IF ls_sys_lang.getIndexOF("big5",1) THEN
  #   LET ls_default_lang = '0'
  #ELSE   
  #   LET ls_default_lang = '1'
  #END IF
   LET l_sql = "SELECT gay01 FROM gay_file ",
               " ORDER BY gay01"  
   PREPARE l_defpre FROM l_sql 
   DECLARE l_defcur SCROLL CURSOR FOR l_defpre
   OPEN l_defcur
   FETCH FIRST l_defcur INTO ls_default_lang
   CLOSE l_defcur 
   FREE l_defpre 
  #--END-MOD-840144---end---
 
   LET ls_lang_sql="SELECT count(*) FROM gae_file WHERE gae01=? AND gae03=?"    #count lang_num about the per
   DECLARE cur_lang CURSOR FROM ls_lang_sql
   IF cl_null(ls_pername) THEN
      OPEN cur_lang USING g_prog,g_lang
   ELSE
      OPEN cur_lang USING ls_pername,g_lang
   END IF
 
   IF STATUS THEN
      CLOSE cur_lang
   END IF
   FETCH cur_lang INTO ls_lang_check
   IF SQLCA.sqlcode THEN
      CLOSE cur_lang
   END IF
   CLOSE cur_lang
 
   IF ls_lang_check = 0 THEN
      LET ls_sellang = g_lang
#     #FUN-830021
#     LET ls_lang_sql="SELECT gay03 FROM gay_file WHERE gay01=? AND gay02=?"       #catch message about the lang that need to display
      LET ls_lang_sql="SELECT gay03 FROM gay_file WHERE gay01=? AND gayacti=?"       #catch message about the lang that need to display
      DECLARE cur_msg CURSOR FROM ls_lang_sql
#     OPEN cur_msg USING ls_default_lang,ls_default_lang 
      OPEN cur_msg USING ls_default_lang,"Y"
 
      IF STATUS THEN
         CLOSE cur_msg
      END IF
 
      FETCH cur_msg INTO ls_msg2
 
      IF SQLCA.sqlcode THEN
         CLOSE cur_msg
      END IF
      CLOSE cur_msg
 
      SELECT gay03 INTO ls_msg1 FROM gay_file
       WHERE gay01=ls_sellang AND gayacti="Y"  #gay02=ls_default_lang #FUN-830021
 
      LET g_lang = ls_default_lang
      UPDATE zx_file SET zx06 = g_lang WHERE zx01 = g_user
      CALL cl_err_msg(NULL, "lib-356", ls_msg1 || "|" || ls_msg2, 10)  #FUN-7A0029
   END IF
 
  #FUN-680095---end---
 
  #TQC-890052 --start--
   LET ls_data_sql="SELECT count(*) FROM gav_file WHERE gav01=? "    #count lang_num about the per
   DECLARE cur_lang2 CURSOR FROM ls_data_sql
   IF cl_null(ls_pername) THEN
      OPEN cur_lang2 USING g_prog
   ELSE
      OPEN cur_lang2 USING ls_pername
   END IF
 
   IF STATUS THEN
      CLOSE cur_lang2
   END IF
   FETCH cur_lang2 INTO ls_data_check
   IF SQLCA.sqlcode THEN
      CLOSE cur_lang2
   END IF
   CLOSE cur_lang2
 
   IF ls_data_check = 0 THEN
      CALL cl_err('','lib-509',1)
   END IF
 
  #TQC-890052 --end--
   IF (NOT mi_call_by_dynamic_locale) THEN
      CLOSE WINDOW screen
 
      CALL cl_set_config_path()
 
      #No.FUN-7C0078 --start--
#      #-- No.FUN-740138 BEGIN -------------------------------------------------#
#      # 暫時隱藏整合 Crystal Report 報表程式其 "特殊列印條件" 欄位             #
#      #------------------------------------------------------------------------#
#      LET li_cnt = 0
#      SELECT COUNT(*) INTO li_cnt FROM zaw_file WHERE zaw01 = g_prog
#      IF li_cnt > 0 THEN
#         CALL cl_set_comp_visible("more", FALSE)
#      END IF
#      #-- No.FUN-740138 END ---------------------------------------------------#
      #No.FUN-7C0078 --end--
   END IF
 
   #載入系統標準的 Windows Title.
   CALL cl_dsmark(1)
 
   # 選擇 Explain SW (zz_file.zz25)
   SELECT zz25 INTO lc_zz25 FROM zz_file WHERE zz01=g_prog
 
   IF g_gui_type MATCHES "[123]" THEN
 
      IF (lc_zz25 = 'Y') THEN
         RUN "rm -f sqexplain.out"
         SET EXPLAIN ON
      END IF
 
      IF (NOT mi_call_by_dynamic_locale) THEN    
         #載入StyleList.
         CALL cl_load_style_list(NULL)
      END IF
 
 #     #MOD-530129
      #No.FUN-560233 --start-- 顯示程式名稱
      CALL cl_get_progname(g_prog,g_lang) RETURNING lc_gaz03
      LET ls_win_name = lc_gaz03 CLIPPED," (",g_prog CLIPPED,")(",g_plant CLIPPED,")" #FUN-970004
      CALL ui.Interface.setText(ls_win_name)
      #No.FUN-560233 ---end---
 
      CALL ui.Interface.setImage("logo")   #No.FUN-770010  改變顯示logo
 
      #載入系統標準的 ActionDefaultList  2004/04/24 修改
      CALL cl_set_act_lang(NULL)
      CALL cl_load_act_sys(NULL)
      CALL cl_load_act_list(NULL)
 
      #載入TopMenu與ToolBar. 
      CALL cl_load_action_view()
 
      #插入程式群組資料. 
      CALL cl_insert_top_menu(NULL)
      # Added by Leagh 2006.01.02 Express
      CALL cl_insert_express_menu(g_prog,'Y')      #FUN-660048 #FUN-840065      
      CALL cl_insert_express_menu(g_prog,'N')      #FUN-840065 BI
 
      # FUN-4B0029 隱藏無權限Action
       # MOD-4B0312 判斷系統設定決定是否隱藏
      IF g_aza.aza22 = "Y" THEN
         CALL cl_act_noauth_disable()
      END IF
      #TQC-640176---start---
      SELECT COUNT(*) INTO cl_langcount FROM gay_file  
       WHERE gayacti = "Y"    #gay02 = trim(g_lang)  #FUN-830021
      IF cl_langcount > 1 THEN
        LET l_sql = "SELECT gay01 FROM gay_file WHERE gayacti='Y' ",
                   #" WHERE gay02 = '",g_lang CLIPPED,"'",   #FUN-830021
                    " ORDER BY gay01"  
        PREPARE lang_pre FROM l_sql 
        DECLARE lang_cur SCROLL CURSOR FOR lang_pre
        OPEN lang_cur
        FETCH FIRST lang_cur INTO l_lang1
        FETCH NEXT  lang_cur INTO l_lang2
        CLOSE lang_cur 
        FREE lang_pre 
        IF cl_langcount = 2 AND (l_lang1 = 0 AND l_lang2 = 2) THEN 
          IF (ms_codeset.getIndexOf("BIG5", 1) OR
             (ms_codeset.getIndexOf("GB2312", 1) OR ms_codeset.getIndexOf("GBK", 1) OR ms_codeset.getIndexOf("GB18030", 1) ) ) AND
               g_prog CLIPPED != "udm_tree" THEN
             CALL  cl_set_act_visible("locale",FALSE)
          END IF
        END IF
      ELSE
        CALL  cl_set_act_visible("locale",FALSE)
      END IF
      #TQC-640176---end---
 
   END IF
 
   # 2004/02/06 by Hiko : 共用程式時才有辦法轉換到畫面.
   #                      其實可以直接寫成CALL cl_ui_locale(ms_frm_name)即可
   #                      (ms_frm_name預設為NULL),但是這樣比較清楚.
   IF (cl_null(ms_frm_name)) THEN
      CALL cl_ui_locale(NULL)
   ELSE
      CALL cl_ui_locale(ms_frm_name)
   END IF

   ###FUN-CB0113 START ###
   IF cl_null(FGL_GETENV("CRIP")) THEN
      CALL cl_set_toolbaritem_visible('output',FALSE)
   ELSE
      CALL cl_set_toolbaritem_visible('output',TRUE)
   END IF
   ###FUN-CB0113 END ###

END FUNCTION
 
 
##################################################
# Descriptions...: 製作 Windows Title 資訊
# Date & Author..: 2004/08/27 by alex
# Input Parameter: li_call_by_ui_init   SMALLINT
#                  TRUE  由 cl_ui_init() 呼叫
#                  FALSE 由其他 function 呼叫
# Return code....: void
# Modify.........: No.MOD-4B0108 04/11/12 alex 加秀客製訊息及沒抓到gaz也要
#                  秀其他程式及執行者的訊息
# Modify.........: No.MOD-510103 05/01/14 alex 模組部門代碼抓取修正
##################################################
 
FUNCTION cl_dsmark(li_call_by_init)
 
   DEFINE lc_zo02       LIKE zo_file.zo02
   DEFINE lc_zx02       LIKE zx_file.zx02 
#  DEFINE lc_zz03       LIKE zz_file.zz03
   DEFINE lc_zz011      LIKE zz_file.zz011
   DEFINE lc_gaz03      LIKE gaz_file.gaz03
   DEFINE li_pos        LIKE type_file.num5    #FUN-690005 SMALLINT
   DEFINE ls_msg        STRING
   DEFINE lwin_curr     ui.Window
   DEFINE ls_ze031      LIKE ze_file.ze03
   DEFINE ls_ze032      LIKE ze_file.ze03
   DEFINE ls_ze033      LIKE ze_file.ze03
   DEFINE lc_aaz69      LIKE aaz_file.aaz69    #帳別是否顯示資料
   DEFINE li_call_by_init  LIKE type_file.num5  #.FUN-690005 SMALLINT
   DEFINE ls_tmp        STRING
   DEFINE lc_azz05      LIKE azz_file.azz05
   DEFINE lc_azp052     LIKE azp_file.azp052
   DEFINE lc_azp02      LIKE azp_file.azp02 #FUN-A10041
   DEFINE lc_plant      STRING              #FUN-BB0005
 
   # 選擇 公司對內全名(zo_file.zo02) 或 帳別公司別(aaf_file.aaf03)
   #      2004/08/27 當 mc_g_bookno <> NULL 時, 表示由 s_dsmark 發動,
   #                 要抓取帳別公司
   #
   IF mc_g_bookno IS NULL OR mc_g_bookno = " " THEN
      SELECT zo02 INTO lc_zo02 FROM zo_file WHERE zo01=g_lang
      IF (SQLCA.SQLCODE) THEN
         LET lc_zo02 = "Empty"
      END IF
   ELSE
      SELECT aaf03 INTO lc_zo02 FROM aaf_file
       WHERE aaf01=mc_g_bookno
         AND aaf02=g_lang
      IF (SQLCA.SQLCODE) THEN
         LET lc_zo02 = "Empty"
      END IF
   END IF
 
   # 選擇 使用者名稱(zx_file.zx02)
   SELECT zx02 INTO lc_zx02 FROM zx_file WHERE zx01=g_user
   IF (SQLCA.SQLCODE) THEN
      LET lc_zx02 = g_user
   END IF
 
#  # 選擇 程式類別(zz_file.zz03) 
#  SELECT zz03 INTO lc_zz03 FROM zz_file WHERE zz01=g_prog
 
    # 選擇 程式模組(zz_file.zz011) MOD-510103
   SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01=g_prog
   LET ls_ze031=""
   IF lc_zz011[1]="C" THEN
      SELECT ze03 INTO ls_ze031 FROM ze_file
       WHERE ze01 = 'lib-051' AND ze02 = g_lang
   END IF
 
   # 選擇 程式名稱(gaz_file.gaz03) MOD-4B0229
   SELECT gaz03 INTO lc_gaz03 FROM gaz_file
    WHERE gaz01=g_prog AND gaz02=g_lang AND gaz05="Y"
   IF lc_gaz03 is null OR lc_gaz03=" " THEN
      SELECT gaz03 INTO lc_gaz03 FROM gaz_file
       WHERE gaz01=g_prog AND gaz02=g_lang AND gaz05="N"
   END IF
 
   IF g_gui_type MATCHES "[123]" THEN
      ###FUN-A10027 mark START ###
      #LET ls_msg = lc_gaz03 CLIPPED, "(", g_prog CLIPPED,ls_ze031 CLIPPED, ")"
      #
      ## 2004/08/27 帳別資料的 show 法要看 aaz69 資料設定是否顯示帳別
      #IF mc_g_bookno IS NULL OR mc_g_bookno = " " THEN
      ##FUN-960141 modify
      ##  LET ls_tmp = "[" || lc_zo02 CLIPPED || "](" || g_dbs CLIPPED || ")"
      #   LET ls_tmp = "[" || lc_zo02 CLIPPED || "](" || g_plant CLIPPED || ")" || "(" || g_dbs CLIPPED || ")"
      ##FUN-960141 end
      #ELSE
      #   SELECT aaz69 INTO lc_aaz69 FROM aaz_file
      #   IF lc_aaz69 = "Y" OR lc_aaz69 = "y"  THEN
      #      LET ls_tmp = "[" || lc_zo02 CLIPPED || "](" || mc_g_bookno CLIPPED || ")"
      #   ELSE
      #      LET ls_tmp = "[" || lc_zo02 CLIPPED || "]"
      #   END IF
      #END IF
      ###FUN-A10027 mark END ###
      ###FUN-A10027 START ###
      SELECT azp02 INTO lc_azp02 FROM azp_file WHERE azp01 = g_plant #FUN-A10041
      #LET ls_msg = lc_gaz03 CLIPPED, "(", g_prog CLIPPED,ls_ze031 CLIPPED, ")[",lc_zo02 CLIPPED,"][", g_plant CLIPPED,":",lc_azp02 CLIPPED, "](",g_dbs CLIPPED,")"
      
      #------------FUN-BB0005------------
      #依aoos010參數設定作業的設定，報表TITLE是否呈現營運中心
      IF g_aza.aza124="Y" THEN
         LET lc_plant="[", g_plant CLIPPED,":",lc_azp02 CLIPPED, "]"
      ELSE
         LET lc_plant=""
      END IF
      LET ls_msg = lc_gaz03 CLIPPED, "(", g_prog CLIPPED,ls_ze031 CLIPPED, ")[",lc_zo02 CLIPPED,"]", lc_plant CLIPPED, "(",g_dbs CLIPPED,")"
      #------------FUN-BB0005------------

      #依agls103中aaz69的設定，是否將帳別顯示於螢幕
      IF NOT cl_null(mc_g_bookno) THEN
         SELECT aaz69 INTO lc_aaz69 FROM aaz_file
         IF lc_aaz69 = "Y" OR lc_aaz69 = "y"  THEN
            LET ls_tmp = "(",mc_g_bookno CLIPPED,")"
         END IF
      END IF
      ###FUN-A10027 END ###
      LET ls_msg = ls_msg.trim(), ls_tmp.trim()
      
      LET ls_ze031="" LET ls_ze032=""
      SELECT ze03 INTO ls_ze031 FROM ze_file     # 日期
       WHERE ze01 = 'lib-035' AND ze02 = g_lang
      SELECT ze03 INTO ls_ze032 FROM ze_file     # 使用者
       WHERE ze01 = 'lib-036' AND ze02 = g_lang
 
      # 時間顯示 (若開時區則加 show GMT表示式)  #FUN-920064
      LET ls_tmp = "  " || ls_ze031 CLIPPED || ":" || g_today CLIPPED 
      SELECT azz05 INTO lc_azz05 FROM azz_file WHERE azz01 = "0"
      IF lc_azz05 IS NOT NULL AND lc_azz05 = "Y" THEN
         #SELECT azp052 INTO lc_azp052 FROM azp_file WHERE azp03 = g_dbs  #MOD-C40107 mark
         SELECT azp052 INTO lc_azp052 FROM azp_file WHERE azp01 = g_plant #MOD-C40107
         IF NOT SQLCA.SQLCODE THEN
           IF NOT cl_null(lc_azp052) THEN
              LET ls_tmp = ls_tmp.trimRight(),"(",lc_azp052 CLIPPED,")"
           END IF
         END IF
      END IF
 
      LET ls_msg = ls_msg.trim(), ls_tmp.trimRight()
 
      LET ls_tmp = "  " || ls_ze032 CLIPPED || ":" || lc_zx02 CLIPPED
      LET ls_msg = ls_msg.trim(), ls_tmp.trimRight()
 
      LET lwin_curr = ui.window.getCurrent()
      CALL lwin_curr.setText(ls_msg)
 
      IF NOT li_call_by_init THEN
         CALL ui.Interface.refresh()
      END IF
 
   ELSE

      DISPLAY "ERROR: TIPTOP GP NOT FGL_GUI=0"   #FUN-9B0156
#      # lib-037:製作單位名稱
#      SELECT ze03 INTO ls_ze033 FROM ze_file
#       WHERE ze01 = 'lib-037' AND ze02 = g_lang
#      DISPLAY ls_ze033 CLIPPED AT 1,1 
# 
#      DISPLAY g_today AT 2,71 ATTRIBUTE(GREEN)
# 
#      LET li_pos = (80 - LENGTH(lc_zo02)) / 2
#      DISPLAY lc_zo02 AT 1,li_pos ATTRIBUTE(YELLOW)
# 
#      LET li_pos = 72 - LENGTH(lc_zx02)
#      
#      # lib-032:使用者
#      DISPLAY ls_ze032 CLIPPED || ":" AT 1,li_pos ATTRIBUTE(GREEN)
# 
#      LET li_pos = 79 - LENGTH(lc_zx02)
#      DISPLAY lc_zx02 CLIPPED AT 1,li_pos ATTRIBUTE(REVERSE)
   END IF
   RETURN
 
END FUNCTION
 
 
##################################################
# Descriptions...: s_dsmark抓到g_bookno帳別編號時要指定cl_ui_init
#                  將公司對內全名 zo_file 換成帳別中的公司別 aaf_file.aaf03
# Date & Author..: 04/08/27 by alex
# Input Parameter: p_bookno
# Return code....: void
##################################################
 
FUNCTION cl_call_by_s_dsmark(p_bookno)
   DEFINE p_bookno LIKE aaf_file.aaf01
   LET mc_g_bookno = p_bookno
END FUNCTION
 
##################################################
# Descriptions...: cl_dynamic_locale設定註標.
# Date & Author..: 2004/02/03 by Hiko
# Input Parameter: none
# Return code....: void
##################################################
 
#FUNCTION cl_call_by_dynamic_locale()
#   LET mi_call_by_dynamic_locale = TRUE
#END FUNCTION
 
##################################################
# Descriptions...: 指定轉換語言別時的畫面名稱. (必用在主程式屬共用時)
# Date & Author..: 2004/02/06 by Hiko
# Input Parameter: ps_frm_name   STRING   畫面名稱
# Return code....: void
# Memo...........: 共用畫面時應該要呼叫的FUNCTION.
##################################################
 
FUNCTION cl_set_locale_frm_name(ps_frm_name)
   DEFINE   ps_frm_name   STRING
 
   LET ms_frm_name = ps_frm_name.trim()
   CALL cl_ui_locale_mainfrm(1)
 
END FUNCTION
 
##################################################
# Descriptions...: 指定轉換config路徑
# Date & Author..: 2004/02/06 by Hiko
# Input Parameter: void
# Return code....: void
# Modify.........: 04/09/02 hjwang 新增 TOPCONFIG 判斷
##################################################
 
FUNCTION cl_set_config_path()
 
   # 2004/09/02 新增 TOPCONFIG 環境變數
   LET gs_config_path = FGL_GETENV("TOPCONFIG")         # config資料夾的路徑.  #FUN-980097
   IF cl_null(gs_config_path) THEN
      LET gs_config_path = os.Path.join(FGL_GETENV("TOP"),"config")
   END IF
 
   LET gs_4sm_path = os.Path.join(gs_config_path, "4sm")          # 4sm檔案預設路徑
   LET gs_4tb_path = os.Path.join(gs_config_path, "4tb")          # 4tb檔案預設路徑
   LET gs_4st_path = os.Path.join(gs_config_path, "4st")          # 4st檔案預設路徑
 
   # 2004/09/07 判別代碼
   IF g_sys[1]="C" THEN                                 # g_sys 必為大寫
      LET gs_config_path = FGL_GETENV("CUSTCONFIG")     # config資料夾的路徑.
      IF cl_null(gs_config_path) THEN
         LET gs_config_path = os.Path.join(FGL_GETENV("CUST"),"config")
      END IF
   END IF
 
   LET gs_4ad_path = os.Path.join(gs_config_path, "4ad")          # 4ad檔案預設路徑
   LET gs_4tm_path = os.Path.join(gs_config_path, "4tm")          # 4tm檔案預設路徑
 
END FUNCTION
 

#FUN-B50102 函式說明
##################################################
# Descriptions...: 載入ActionList,即CALL cl_load_act_sys(NULL)
# Date & Author..: 
# Input Parameter: none
# Return code....: void
# Usage..........: CALL cl_ui_act()
# Memo...........:
# Modify.........: 
##################################################
FUNCTION cl_ui_act()
 
   CALL cl_load_act_sys(NULL)
 
   RETURN
 
END FUNCTION
#TQC-760001
