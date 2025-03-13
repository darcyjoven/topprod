# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: udm_tree.4gl
# Descriptions...: 依zx05帶入個人StartMenu的udm畫面.
# Date & Author..: 03/07/15 by Hiko
# Memo...........: 可帶入Menu節點(StartMenuGroup)參數
# Sample.........: 1. r.r2 udm_tree 
#                  2. r.r2 udm_tree m1
# Modify.........: No.MOD-470041 04/07/20 By Wiky 修改INSERT INTO...
# Modify.........: No.MOD-420715 04/12/10 By Ken 自動判斷user是採用 Telnet (VTCP)
#                                login or WEB Login
# Modify.........: No.FUN-510047 05/04/19 By alex 改load_startmenu 去掉 dbname
# Modify.........: No.MOD-540163 05/04/29 By alex 刪除錯誤的 order by 用法
# Modify.........: No.MOD-560232 05/06/29 By saki 修改系統流程頁面
# Modify.........: NO.FUN-570170 05/07/27 By Yiting 按ESC離開前先詢問再離開
# Modify.........: No.FUN-4A0081 05/08/01 By saki 代辦事項帶出程式指定單據編號及欲執行功能
# Modify.........: No.FUN-570271 05/08/04 By saki 離開、ON IDLE時偵測是否還有其他作業存在
#                                拿掉所有cl_chk_act_auth權限檢查
# Modify.........: No.MOD-580119 05/08/12 By saki check 存在的pid不存在時，此process就不在檢查udm_tree範圍內
# Modify.........: No.FUN-580093 05/08/22 By saki 部門上線人數限制
# Modify.........: No.FUN-580011 05/08/19 By echo 以 EF 為 backend engine, 由 TIPTOP 處理前端簽核動作  
# Modify.........: No.MOD-580173 05/08/16 By saki udmtree_detect_process 整個功能改寫
# Modify.........: No.MOD-5A0089 05/10/27 By echo 簽核段LET mi_easyflow_trigger = TRUE之後要還原為 FALSE
# Modify.........: No.FUN-5B0054 05/11/08 By saki 使用者按下離開後詢問是否要關閉所有作業? 整合離開時的所有訊息
# Modify.........: No.FUN-590112 05/11/21 By saki 將訊息傳送作業放到主畫面上，順便修改〝當g_idle_seconds沒有時，不檢查process的順序〞
# Modify.........: No.TQC-5B0218 05/12/05 By echo 檢查EasyFlow簽核整合部分改為點選「簽核表單」page時才check。
# Modify.........: No.FUN-610052 06/01/09 By saki 增加系統流程第一分類的按鍵數到20個
# Modify.........: No.MOD-630050 06/03/16 By saki 直接執行必須傳遞正確的帳別
# Modify.........: No.TQC-650095 06/05/22 By saki 減少ps指令執行次數以增進效能
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.TQC-660096 06/06/22 By saki 流程訊息通知功能
# Modify.........: No.TQC-660107 06/06/23 By saki 無力的將所有的ps指令拿掉
# Modify.........: No.FUN-620044 06/06/28 By alexstar 新增切換內部IP使用者\外部IP使用者的功能
# Modify.........: No.FUN-660135 06/07/14 By saki controlp切換資料庫時，更新process的使用資料庫
# Modify.........: No.FUN-670010 06/07/31 By alexstar 當使用者透過weblogin的方式登入的時候，才顯示切換內/外部使用者的功能
# Modify.........: No.MOD-670090 06/09/14 By saki kill process的時候 udm_tree的process不能先刪
# Modify.........: No.FUN-680135 06/09/19 By Hellen 欄位類型修改
# Modify.........: No.TQC-6A0036 06/10/23 By saki 修改切換工廠按下取消時會關閉程式
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-570225 05/11/01 By saki 搜尋引擎功能
# Modify.........: No.FUN-710010 07/03/01 By chingyuan TIPTOP與EasyFlow GP整合專案, 隱藏由TIPTOP簽核功能
# Modify.........: No.TQC-690003 06/03/05 By pengu 修改判斷權限zxw_file的sql語法
# Modify.........: No.FUN-690056 07/03/20 By Brendan 調整紀錄 WEB 執行時的 IP 為實際 Client IP, 而非紀錄 127.0.0.1
# Modify.........: No.FUN-6B0036 07/03/21 By Brendan 新增 ERP 與 Product Portal 整合功能
# Modify.........: No.FUN-670045 07/04/26 By saki 4sm重新整理
# Modify.........: No.MOD-750003 07/05/01 By saki 搜尋功能權限
# Modify.........: No.TQC-750054 07/06/07 By saki 搜尋功能調整
# Modify.........: No.FUN-740179 07/06/11 By saki 同一台電腦不同telnet連線,分別記錄資料庫來使用
# Modify.........: No.CHI-770027 07/07/26 By saki 部門權限控管設定為0時，此部門就無人可登入
# Modify.........: No.FUN-780070 07/08/27 By Echo wsk_file 調整 index :增加 wsk05(TIPTOP 表單單號) 
# Modify.........: No.FUN-7A0033 07/10/16 By Brendan 檢查 DEMO License 有效時間, 若少于或者等于 7 天, 則警示
# Modify.........: No.FUN-7A0086 07/11/02 By saki 營運中心上線人數控制
# Modify.........: No.TQC-7B0029 07/11/06 By Echo 調整 wsk_file 存取方式, 增加 SourceFormNum 環境變數
# Modify.........: No.FUN-7C0003 07/12/03 By Echo 「簽核表單」頁面，填表人、表單關係人欄位要顯示員工代號+員工姓名
# Modify.........: No.FUN-7C0094 07/12/26 By Echo 簽核完，取得下一筆資料時，呼叫 EasyFlow 取得資料時，不限制15筆.
# Modify.........: No.MOD-810155 08/01/21 By alexstar controp切換工廠別後global變數重新讀取
# Modify.........: No.MOD-810147 08/01/21 By alexstar udm7切換語言後可直接輸入程式並按Enter執行
# Modify.........: No.MOD-840097 08/04/11 By alex azz_set_win_title字串連結改回逗號
# Modify.........: No.FUN-830106 08/04/24 By saki 增加刪除常用程式紀錄功能
# Modify.........: No.FUN-840102 08/05/06 By hellen 解決點相關頁簽，不進入，再點其他頁簽，udm_tree不正常關閉的問題
# Modify.........: No.TQC-860016 08/06/11 By saki 修改ON IDLE段
# Modify.........: No.FUN-8A0057 08/10/15 By Smapmin 收件匣/原稿匣中,狀態為0時要顯示錯誤訊息.
# Modify.........: No.MOD-920213 09/02/17 By alexstar 部門上線人數控管異常
# Modify.........: No.MOD-920256 09/02/19 By alexstar controlp切換後,udm_tree的title要顯示時區
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.CHI-960079 09/07/01 By Dido 設定帳別的相關程式無法在樹狀架構中執行程式
# Modify.........: No.MOD-970062 09/07/07 By Dido 變數清空
# Modify.........: No.FUN-980014 09/08/04 By rainy GP5.2 新增抓取 g_legal 值
# Modify.........: No.FUN-920138 09/08/18 By tsai_yen 部門與部門群組上線人數控管
# Modify.........: No.CHI-980033 09/08/19 By Dido 改善 ms_msg_sec 小於 3sec 問題
# Modify.........: No.MOD-980264 09/09/01 By Dido 執行 aoos901 後更新 sma30
# Modify.........: No.FUN-980020 09/09/27 By douzh GP5.2集團架構調整,azp相關修改
# Modify.........: No.FUN-990069 09/09/28 By baofei 修改GP5.2的相關設定
# Modify.........: No.EXT-9C0145 10/01/05 By saki fglWrt 解析問題
# Modify.........: No:FUN-A40045 10/05/21 By Jay 列出該User待辦事項之SQL語法在gah02資料最後加上';'字元符號,以增加User正確性之Like判斷
# Modify.........: No:CHI-A40003 10/06/28 By Summer 在待辦事項頁簽的controlp重新讀取資料
# Modify.........: No:MOD-A60001 10/07/16 By Pengu 先點選待辦事項,再點回簽核表單page04後,重新整理的action會變成disable
# Modify.........: No.TQC-A70110 10/07/23 By alex 將aoos901規範在只有control-p才能點選
# Modify.........: No:FUN-880099 10/08/26 By Jay 整合EasyFlow GP 簽核功能
# Modify.........: No.MOD-AC0022 10/12/02 By Dido aglt110/aglt130 帳別使用參數二傳遞
# Modify.........: No.FUN-AC0036 10/12/28 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B30176 11/03/25 By xianghui 使用iconv須區分為FOR UNIX& FOR Windows,批量去除$TOP
# Modify.........: No.FUN-B50046 11/05/19 By abby APS GP5.25追版 str----------------------------
# Modify.........: No.FUN-A70128 10/07/30 By Mandy udm_tree執行關閉所有執行中的程式按鈕時，程式需判斷不能關閉背景程式apsp702程式
#                                                  apsp702程式應該要由APS背景排程程式關閉，否則會造成排程跑到一半中斷狀況
# Modify.........: No.FUN-B50046 11/05/19 By abby APS GP5.25追版 end----------------------------
# Mdofiy.........: No:MOD-B90137 11/09/20 By johung 修正部門上線人數控管的判斷
# Modify.........: No.FUN-BA0079 11/11/02 By tommas 動態圖表IT處理段,使用者自訂圖表 / 動態分析 
# Modify.........: No.FUN-C10041 12/01/12 By jrg542 在udm_tree執行起來前，顯示個資警告訊息
# Modify.........: No.TQC-C20485 12/02/27 By baogc s_gdk報錯
# Modify.........: No.MOD-C30123 12/03/10 By madey 修正l_msg在controlp前後title不一致,與cl_cl_ui_init.4gl一致
# Modify.........: No.FUN-C30122 12/03/12 By jrg542 在udm_tree 中的資安提示訊息，只要一次就好了
# Modify.........: No.MOD-C40107 12/04/17 By madey 修正取時區(azp052)時的where condition
# Modify.........: No.FUN-C30221 12/11/13 By zong-yi 新增切換營運中心按鈕
# Modify.........: No:FUN-CC0120 12/12/21 By Zong-Yi 資安程式段移動
# Modify.........: No:FUN-CA0113 13/01/03 By madey udm_tree關閉全部程式時kill -9改成kill -15避免透過web執行時gdc彈窗
# Modify.........: No:CHI-F20018 20/04/07 By lifang 修正部门群组人数控管计算错误的问题
# Modify.........: No:FUN-F70020 20/04/07 By lifang 解決udm_tree部門人數上限問題,以將會達到的u數做為判斷基礎

IMPORT os     #No.FUN-B30176
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
DEFINE  mi_easyflow_trigger   LIKE type_file.num10       #No.TQC-6A0036 INTEGER           #FUN-580011
END GLOBALS
 
DEFINE   mr_btn         DYNAMIC ARRAY OF RECORD
            btn_name    STRING,                 # btn原名, ex. btn1,btn2...
            chg_name    STRING                  # btn更換名, ex. axm,axm01...
                        END RECORD
DEFINE   ms_pic_url     STRING
# 2004/05/24 by saki : 加入on idle時的多種控制
DEFINE   ms_msg_sec     LIKE type_file.num5     #No.FUN-680135 SMALLINT #idle幾秒後偵測訊息是否該出現
DEFINE   ms_idle_sec    LIKE type_file.num5     #No.FUN-680135 SMALLINT #總idle幾秒後, 執行cl_on_idle
# 2004/05/25 by saki : 待辦事項page使用
DEFINE   g_gah     DYNAMIC ARRAY OF RECORD 
            gah03          LIKE gah_file.gah03,
            gah08          LIKE gah_file.gah08,
            gah01          LIKE gah_file.gah01,  
            gah04          LIKE gah_file.gah04,
            gah05          LIKE gah_file.gah05,
            gah06          LIKE gah_file.gah06,
            gah07          LIKE gah_file.gah07,
            gah11          LIKE gah_file.gah11  #No.FUN-4A0081
                      END RECORD,
         g_gah_t           RECORD 
            gah03          LIKE gah_file.gah03,
            gah08          LIKE gah_file.gah08,
            gah01          LIKE gah_file.gah01,  
            gah04          LIKE gah_file.gah04,
            gah05          LIKE gah_file.gah05,
            gah06          LIKE gah_file.gah06,
            gah07          LIKE gah_file.gah07,
            gah11          LIKE gah_file.gah11  #No.FUN-4A0081
                      END RECORD,
         g_gdn     DYNAMIC ARRAY OF RECORD 
            gah03_dn       LIKE gah_file.gah03,
            gah09_dn       LIKE gah_file.gah09,
            gah01_dn       LIKE gah_file.gah01,  
            gah04_dn       LIKE gah_file.gah04,
            gah05_dn       LIKE gah_file.gah05,
            gah06_dn       LIKE gah_file.gah06,
            gah07_dn       LIKE gah_file.gah07, #No.FUN-4A0081
            gah11_dn       LIKE gah_file.gah11  #No.FUN-4A0081
                      END RECORD,
         g_gdn_t           RECORD 
            gah03_dn       LIKE gah_file.gah03,
            gah09_dn       LIKE gah_file.gah09,
            gah01_dn       LIKE gah_file.gah01,  
            gah04_dn       LIKE gah_file.gah04,
            gah05_dn       LIKE gah_file.gah05,
            gah06_dn       LIKE gah_file.gah06,
            gah07_dn       LIKE gah_file.gah07, #No.FUN-4A0081
            gah11_dn       LIKE gah_file.gah11  #No.FUN-4A0081
                      END RECORD,
         g_sql            string,               #No.FUN-580092 HCN
         g_sql2           string,               #FUN-580011
         g_rec_b          LIKE type_file.num5,  #No.FUN-680135 SMALLINT # 單身筆數
         g_rec_b_dn       LIKE type_file.num5,  #No.FUN-680135 SMALLINT # 單身筆數
         l_ac             LIKE type_file.num5,  #No.FUN-680135 SMALLINT # 目前處理的ARRAY CNT
         l_sl             LIKE type_file.num5   #No.FUN-680135 SMALLINT # 目前處理的SCREEN LINE
DEFINE   p_row            LIKE type_file.num5,  #No.FUN-680135 SMALLINT
         p_col            LIKE type_file.num5   #No.FUN-680135 SMALLINT
DEFINE   g_cnt            LIKE type_file.num10  #No.FUN-680135 INTEGER   
DEFINE   g_cnt_dn         LIKE type_file.num10  #No.FUN-680135 INTEGER   
DEFINE   g_notify         STRING
DEFINE   g_wc             string                #No.FUN-580092 HCN
# 2004/05/27 by saki : 個人所使用的flow流程點
DEFINE   ms_flow_class    LIKE zx_file.zx11
# 2004/07/02 by saki : 帳別顯示
DEFINE   g_bookno         LIKE aaa_file.aaa01
DEFINE   g_bookno_old     LIKE aaa_file.aaa01
DEFINE   g_zxw_flag       LIKE type_file.num5   #No.FUN-680135 SMALLINT
 
#FUN-580011
DEFINE  g_forminfo        LIKE wsk_file.wsk14,  #No.FUN-680135 VARCHAR(10) #選擇資料夾 
        g_strfilter       LIKE type_file.chr50, #No.FUN-680135 VARCHAR(50) #表單顯示種類
        g_intfilter       LIKE type_file.chr50, #No.FUN-680135 VARCHAR(50) #簽核顯示種類
        g_curr_page       LIKE type_file.num10, #No.FUN-680135 INTEGER # Current Page Number
        g_total_page      LIKE type_file.num10  #No.FUN-680135 INTEGER # Total Pages
DEFINE  g_status          LIKE type_file.num10  #No.FUN-680135 INTEGER #TQC-5B0218
DEFINE  g_ef DYNAMIC ARRAY OF RECORD
           ef01     LIKE wsk_file.wsk04,        #TIPTOP 單別 #No.FUN-680135 VARCHAR(5)
           ef02     LIKE wsk_file.wsk05,        #TIPTOP 單號 #No.FUN-590076 #No.FUN-680135 VARCHAR(80)
           ef03     LIKE wsk_file.wsk03,        #TIPTOP 程式代號 #No.FUN-680135 VARCHAR(10)
           ef04     LIKE wsk_file.wsk08,        #EasyFlow 單別 #No.FUN-680135 VARCHAR(20)
           ef05     LIKE type_file.chr1,        #重要性 #No.FUN-680135 VARCHAR(1)
           ef06     LIKE type_file.chr4,        #簽核結果 #No.FUN-680135 VARCHAR(4)
           ef07     LIKE type_file.chr4,        #簽核狀態 #No.FUN-680135 VARCHAR(4) 
           ef08     STRING,                     #填表人 #No.FUN-680135 VARCHAR(10)  #FUN-7C0003
           ef09     STRING,                     #關係人 #No.FUN-680135 VARCHAR(10)  #FUN-7C0003
           ef10     STRING,                     #表單簡稱  
           ef11     LIKE wsk_file.wsk09,        #EasyFlow 表單單號 #No.FUN-680135 VARCHAR(10)
           ef12     STRING,                     #主旨 
           ef13     STRING,                     #收件日期時間 
           ef14     STRING,                     #表單來源 
           ef15     LIKE wsk_file.wsk10,        #關號 #No.FUN-680135 VARCHAR(4)
           ef16     LIKE wsk_file.wsk11,        #支號 #No.FUN-680135 VARCHAR(4)
           ef17     LIKE wsk_file.wsk12,        #流水號 #No.FUN-680135 VARCHAR(4)
           ef18     LIKE wsk_file.wsk13         #簽核序號 #No.FUN-680135 VARCHAR(4)
       END RECORD,
       g_items       STRING,             #combo items:EasyFlow 單別
       g_values      STRING,             #combo values:表單簡稱
       g_cmd         STRING
#END FUN-580011
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0096
DEFINE g_udmtree_pid STRING                   #No.FUN-580093
DEFINE g_udmtree_ip  STRING                   #No.FUN-580093
 
DEFINE g_user_pid    DYNAMIC ARRAY OF STRING  #No.FUN-5B0054
DEFINE g_udmtree_gbq02 LIKE gbq_file.gbq02    #No.FUN-740179
 
#No.FUN-570225 --start--
DEFINE l_zx07            LIKE type_file.chr1    #No.FUN-C30221
DEFINE g_method          LIKE type_file.chr1
DEFINE g_cate            STRING
DEFINE g_filepath        STRING
DEFINE g_filename        STRING
DEFINE g_where           STRING
DEFINE g_select          STRING
DEFINE g_siftfld         STRING
DEFINE g_siftcon         STRING
DEFINE gr_datagroup      DYNAMIC ARRAY OF RECORD
          gcm03          LIKE gcm_file.gcm03,
          gat03          LIKE gat_file.gat03,
          gcm04          LIKE gcm_file.gcm04,
          gaq03          LIKE gaq_file.gaq03,
          gcm11          LIKE gcm_file.gcm11,
          siftwhere      STRING
                         END RECORD
DEFINE gr_data           DYNAMIC ARRAY OF RECORD
          value          LIKE type_file.chr50,
          gcm05          LIKE gcm_file.gcm05,
          gaz03          LIKE gaz_file.gaz03,
          gcm06          LIKE gcm_file.gcm06,
          gcm07          LIKE gcm_file.gcm07
                         END RECORD
DEFINE gr_showdata       DYNAMIC ARRAY OF RECORD
          gaq01          LIKE gaq_file.gaq01,
          gaq03          LIKE gaq_file.gaq03,
          value          STRING
                         END RECORD
DEFINE gr_file           DYNAMIC ARRAY OF RECORD
          file_name      STRING,
          location       STRING,
          desc           STRING
                         END RECORD
DEFINE gr_openfile       DYNAMIC ARRAY OF STRING
#No.FUN-570225 ---end---

#FUN-880099  --start
DEFINE  g_efgp DYNAMIC ARRAY OF RECORD
            ef21     LIKE wsk_file.wsk04, #TIPTOP 單別 CHAR(5)
            ef22     LIKE wsk_file.wsk05, #TIPTOP 單號 CHAR(80)
            ef23     LIKE wsk_file.wsk03, #TIPTOP 程式代號 CHAR(10)
            ef24     LIKE wsk_file.wsk08, #EasyFlow 單別 CHAR(20)
            ef25     STRING,              #重要性
            ef26     STRING,              #關係人
            ef27     STRING,              #簽核狀態 CHAR(4)
            ef28     STRING,              #流程名稱
            ef29     STRING,              #workItemName
            ef30     STRING,              #流程序號 =>processSN 
            ef31     LIKE wsk_file.wsk09, #流程OID =>processOID
            ef32     STRING,              #主旨
            ef33     STRING,              #發起者
            ef331    STRING,              #流程關係人 =>relationshipName
            ef34     STRING,              #來源
            ef35     LIKE azg_file.azg06, #工作事項OID =>workItemOID
            ef36     STRING,              #建立時間 =>createdTime
            ef37     STRING               #讀取次數
       END RECORD
#FUN-880099  --end

 
MAIN
   DEFINE   lnode_root      om.DomNode,
            llst_act        om.NodeList,
            lnode_act       om.DomNode,
            ls_item_name    STRING,
            li_i            LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   l_wcpath        STRING #No.FUN-BA0079 WebComponent路徑
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   LET l_wcpath = FGL_GETENV("WEBSERVERIP"),"/components"                                 #No.FUN-BA0079
   CALL ui.interface.frontCall("standard", "setwebcomponentpath",[l_wcpath],[]) #No.FUN-BA0079

 #-- FUN-690056 begin
 #   For HTTP connection purpose.
 #--
   LET g_notify = ARG_VAL(2)
 #-- FUN-690056
 
   #No.FUN-580093 --start--
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0096
   CALL cl_process_check()
   CALL udmtree_getpid()               #No.TQC-650095 必要function
   CALL udmtree_online_limit()
   #No.FUN-580093 ---end---
 
 #-- FUN-690056 begin
 #   將此段往上移
 #--
 #  LET g_notify = ARG_VAL(2)
 #-- FUN-690056 end
 
 
   # 2004/05/24 by saki : 由cl_user抓出的idle秒數, 算偵測訊息秒數
   #                      訊息三分鐘至少偵測一次
   LET ms_msg_sec = 0
   LET ms_idle_sec = 0
  #-CHI-980033-add-
   IF g_idle_seconds < 3 THEN
      LET ms_msg_sec = g_idle_seconds
   ELSE
      LET ms_msg_sec = g_idle_seconds / 3
   END IF
  #-CHI-980033-end-
   IF (ms_msg_sec > 180) OR (g_idle_seconds IS NULL) OR (g_idle_seconds = 0) THEN
      LET ms_msg_sec = 180
   END IF
   LET ms_pic_url = FGL_GETENV("FGLASIP")
 
   # 2004/05/27 by saki : 使用者的流程圖,原本為'TopFlow'根節點變為ms_flow_class
   SELECT zx11 INTO ms_flow_class FROM zx_file WHERE zx01 = g_user
 
   CALL s_udsday()
   CALL load_start_menu()
#  LET ls_file_path = gs_4sm_path || "/" || g_lang || "/" || g_dbs CLIPPED || "_" || lc_menu_root CLIPPED || ".4sm"
 
#  CALL ui.Interface.loadStartMenu(ls_file_path)
#  IF (STATUS) THEN
#     DISPLAY ls_file_path || " load error."
#     EXIT PROGRAM
#  END IF
 
   OPEN WINDOW w_udm_tree WITH FORM "azz/42f/udm_tree"
                          ATTRIBUTE(STYLE="udm_tree", TEXT="udm_tree")
 
   CALL cl_ui_init()
   
   #No.FUN-710010 --start--
   #若與EasyFlow GP整合, 則隱藏簽核表單頁籤 
   IF g_aza.aza72 MATCHES '[Yy]' THEN
      CALL cl_set_comp_visible("page04",FALSE)
      CALL cl_set_comp_visible("page06",TRUE)         #FUN-880099
   ELSE
      CALL cl_set_comp_visible("page04",TRUE)
      CALL cl_set_comp_visible("page06",FALSE)        #FUN-880099
   END IF
   #No.FUN-710010 --end--

   #darcy:2024/05/08 add s---
   if g_user != 'tiptop' then
    call cl_set_act_visible("erphelp",false)
   end if
   #darcy:2024/05/08 add e---

   #No.FUN-C30221 start 
   SELECT zx07 INTO l_zx07 FROM zx_file WHERE zx01=g_user
   IF l_zx07 <> 'Y' THEN
      CALL cl_set_comp_visible("center",FALSE)
   END IF
   #No.FUN-C30221 end-----------------------------
 
#----genero--改變action accept的屬性
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_act = lnode_root.selectByTagName("ActionDefault")
   FOR li_i = 1 to llst_act.getLength()
      LET lnode_act = llst_act.item(li_i)
      LET ls_item_name = lnode_act.getAttribute("name")
      IF (ls_item_name.equals("accept")) THEN
         CALL lnode_act.setAttribute("acceleratorName","Return")
         CALL lnode_act.setAttribute("acceleratorName2","Enter")
      END IF
   END FOR
#-----------------------------------
 
   #TQC-5B0218
   #FUN-580011
   #LET g_curr_page = 1
   #LET g_total_page = 1
   #IF g_aza.aza23 matches '[ Nn]' THEN   #未設定與 EasyFlow 簽核
   #      LET g_status = 0
   #      CALL cl_set_act_visible("go,selectbox,efrefresh",FALSE)
   #ELSE
   #      LET g_forminfo = "Inbox"
   #      LET g_strfilter = "ALL"
   #      LET g_intfilter = "2"
   #      CALL aws_efapp_formID() RETURNING g_status
   #      CALL cl_set_comp_visible("ef01,ef02,ef03,ef04,ef05,ef15,ef16,ef17,ef18",FALSE)
   #END IF
   #END FUN-580011
   #END TQC-5B0218
 
   CALL azz_catch_recently_cmd()
 
   #-- FUN-7A0033 BEGIN --------------------------------------------------------
   # 若使用者為 'tiptop', 則呼叫檢查 DEMO License 有效時間並警示
   #----------------------------------------------------------------------------
   IF g_user CLIPPED = "tiptop" THEN
      CALL cl_license()
   END IF
   #-- FUN-7A0033 END ----------------------------------------------------------
 
   CALL azz_exec_cmd()
 
   #FUN-580011
   CALL cl_set_comp_visible("ef01,ef02,ef03,ef04,ef05,ef08,ef09,ef14,ef15,ef16,ef17,ef18,intfilter",TRUE)
   #END FUN-580011
 
   CALL udmtree_close()                        #No.FUN-570225
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-580093  #No.FUN-6A0096
 
   CLOSE WINDOW w_udm_tree
END MAIN
 
##################################################
# Description  	: 刪除不合權限的Menu節點
# Date & Author : 2004/06/11 by saki
# Parameter   	: 
# Return   	: 
# Memo        	:
# Modify   	:
##################################################
FUNCTION azz_check_no_auth_menu()
   DEFINE   lnode_root          om.DomNode
   DEFINE   llst_items          om.NodeList
   DEFINE   lnode_item          om.DomNode
   DEFINE   li_cnt              LIKE type_file.num10   #No.FUN-680135 INTEGER
   DEFINE   ls_zx12             LIKE zx_file.zx12
 
 
   SELECT COUNT(*) INTO li_cnt FROM zy_file,zw_file WHERE zy01 = g_clas AND zw01 = zy01
   SELECT zx12 INTO ls_zx12 FROM zx_file WHERE zx01 = g_user
   IF li_cnt <= 0 OR ls_zx12 = "N" THEN
      RETURN
   END IF
 
   DISPLAY "INFO:StartMenu Adjusting"   
 
   SELECT COUNT(*) INTO li_cnt FROM zxw_file WHERE zxw01 = g_user
   IF li_cnt > 0 THEN
      LET g_zxw_flag = TRUE
   ELSE
      LET g_zxw_flag = FALSE
   END IF
 
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_items = lnode_root.selectByPath("/UserInterface/StartMenu/StartMenuGroup")
   LET lnode_item = llst_items.item(1)
 
   CALL azz_remove_no_auth_menu(lnode_item)
END FUNCTION
 
FUNCTION azz_remove_no_auth_menu(lnode_item)
   DEFINE   lnode_item     om.DomNode
   DEFINE   lnode_child    om.DomNode
   DEFINE   lnode_next     om.DomNode
   DEFINE   lnode_parent   om.DomNode
   DEFINE   ls_item_name   LIKE zy_file.zy02
   DEFINE   li_cnt         LIKE type_file.num10   #No.FUN-680135 INTEGER
   DEFINE   li_cnt1        LIKE type_file.num10   #No.TQC-690003
   DEFINE   li_cnt2        LIKE type_file.num10   #No.TQC-690003
 
 
   LET lnode_child = lnode_item.getFirstChild()
   WHILE lnode_child IS NOT NULL
      LET lnode_next = lnode_child.getNext()
      LET ls_item_name = lnode_child.getAttribute("name")
 
      IF g_zxw_flag THEN
       #-----------No.TQC-690003 modify
        #SELECT COUNT(*) INTO li_cnt FROM zxw_file, zy_file
        # WHERE zxw01 = g_user
        #   AND (( zxw_file.zxw04 = zy_file.zy01 AND zy_file.zy02 = ls_item_name )
        #    OR zxw04 = ls_item_name )
 
         SELECT COUNT(*) INTO li_cnt1 FROM zxw_file, zy_file
          WHERE zxw01 = g_user
            AND zxw_file.zxw04 = zy_file.zy01 AND zy_file.zy02 = ls_item_name
         
         SELECT COUNT(*) INTO li_cnt2 FROM zxw_file
          WHERE zxw01 = g_user AND zxw04 = ls_item_name
         
         LET li_cnt = li_cnt1 + li_cnt2
       #-----------No.TQC-690003 end
      ELSE
          SELECT COUNT(*) INTO li_cnt FROM zy_file
           WHERE zy01 = g_clas AND zy02 = ls_item_name
      END IF
      IF li_cnt <= 0 THEN
         LET lnode_parent = lnode_child.getParent()
         CALL lnode_parent.removeChild(lnode_child)
      ELSE
         CALL azz_remove_no_auth_menu(lnode_child)
      END IF
      LET lnode_child = lnode_next
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 刪除多餘的Menu節點,並回傳是否有找到使用者所設定的根節點.
# Date & Author : 2003/07/15 by Hiko
# Parameter   	: ps_cust_menu_root STRING 使用者設定的根節點
# Return   	: SMALLINT 是否有找到
# Memo        	:
# Modify   	:
##################################################
FUNCTION azz_remove_surplus_menu(ps_cust_menu_root)
   DEFINE   ps_cust_menu_root   STRING
   DEFINE   li_find_cust_root   LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   lnode_root          om.DomNode
   DEFINE   llst_items          om.NodeList
   DEFINE   li_i                LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   lnode_item          om.DomNode
   DEFINE   ls_item_name        STRING
 
   LET ps_cust_menu_root = ps_cust_menu_root.trim()
 
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_items = lnode_root.selectByTagName("StartMenuGroup")
  
   FOR li_i = 1 to llst_items.getLength()
      LET lnode_item = llst_items.item(li_i)
      LET ls_item_name = lnode_item.getAttribute("name")
      IF (ls_item_name.equals(ps_cust_menu_root)) THEN
         CALL azz_del_none_ancesstry_node(lnode_item, ps_cust_menu_root)
         LET li_find_cust_root = TRUE
         EXIT FOR
      END IF
   END FOR
 
   RETURN li_find_cust_root
END FUNCTION
 
##################################################
# Description  	: 刪除非使用者所設定的根節點之世系節點.
# Date & Author : 2003/07/15 by Hiko
# Parameter     : pnode_del_target om.DomNode 所要刪除的節點
#               : ps_target_name STRING 所要刪除的節點名稱
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION azz_del_none_ancesstry_node(pnode_del_target, ps_target_name)
   DEFINE   pnode_del_target   om.DomNode
   DEFINE   ps_target_name     STRING
   DEFINE   lnode_parent       om.DomNode
   DEFINE   ls_parent_tag      STRING
   DEFINE   llst_items         om.nodeList
   DEFINE   li_i               LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   lnode_item         om.DomNode
   DEFINE   ls_item_name       STRING
 
 
   LET ps_target_name = ps_target_name.trim()
 
   LET lnode_parent = pnode_del_target.getParent()
   LET ls_parent_tag = lnode_parent.getTagName()
   LET llst_items = lnode_parent.selectByPath("//" || ls_parent_tag || "//*")
   FOR li_i = 1 to llst_items.getLength()
      LET lnode_item = llst_items.item(li_i)
      LET ls_item_name = lnode_item.getAttribute("name")
      IF (NOT ls_item_name.equals(ps_target_name)) THEN
         CALL lnode_parent.removeChild(lnode_item)
      END IF
   END FOR
 
   IF (NOT ls_parent_tag.equals("StartMenu")) THEN
      LET pnode_del_target = lnode_parent
      LET ps_target_name = pnode_del_target.getAttribute("name")
      CALL azz_del_none_ancesstry_node(pnode_del_target, ps_target_name)
   END IF
END FUNCTION
 
##################################################
# Description  	: 擷取資料庫內最近30筆已執行過的程式清單.
# Date & Author : 2003/07/15 by Hiko
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION azz_catch_recently_cmd()
   DEFINE   li_gaa_count   LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   lc_prog        LIKE gaa_file.gaa02
   DEFINE   lsb_item       base.StringBuffer
 
 
   #No.FUN-830106 --mark start--
#  SELECT COUNT(*) INTO li_gaa_count FROM gaa_file WHERE gaa01=g_user
#  IF (li_gaa_count = 0) THEN
#     RETURN
#  END IF
   #No.FUN-830106 ---mark end---
 
   LET lsb_item = base.StringBuffer.create()
   DECLARE l_cmdCurs CURSOR FOR
                     SELECT gaa02 FROM gaa_file WHERE gaa01=g_user ORDER BY gaa02
   FOREACH l_cmdCurs INTO lc_prog 
      CALL lsb_item.append(lc_prog CLIPPED || ",")
   END FOREACH
 
   CALL cl_set_combo_items("command_catch", lsb_item.toString(), lsb_item.toString())
END FUNCTION
 
##################################################
# Description  	: 擷取個人設定之常用程式代號名稱
# Date & Author : 2004/04/26 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION azz_catch_favorite_cmd()
   DEFINE   li_gbi_count   LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   lc_prog        LIKE gbi_file.gbi02
   DEFINE   lc_prog_name   LIKE gaz_file.gaz03
   DEFINE   lsb_item       base.StringBuffer
   DEFINE   lsb_item2      base.StringBuffer
 
   LET lsb_item  = base.StringBuffer.create()
   LET lsb_item2 = base.StringBuffer.create()
 {
   DECLARE l_cmdCurs2 CURSOR FOR
                      SELECT gbi02,gaz03 FROM gbi_file,gaz_file
                       WHERE gbi01=g_user AND gbi02=gaz01 AND gaz02=g_lang ORDER BY gbi02
}
 
   DECLARE l_cmdCurs2 CURSOR FOR
                      SELECT gbi02,' '  FROM gbi_file
                       WHERE gbi01=g_user ORDER BY gbi02
   FOREACH l_cmdCurs2 INTO lc_prog,lc_prog_name
 
 #     #MOD-540163
      CALL cl_get_progname(lc_prog,g_lang) RETURNING lc_prog_name
#     SELECT gaz03 INTO lc_prog_name FROM gaz_file
#      WHERE gaz01=lc_prog AND gaz02=g_lang order by gaz05
 
      CALL lsb_item.append(lc_prog CLIPPED || ",")
      CALL lsb_item2.append(lc_prog_name CLIPPED || " (" || lc_prog CLIPPED || "),")
   END FOREACH
 
   CALL cl_set_combo_items("favorite_prog", lsb_item.toString(), lsb_item2.toString())
END FUNCTION
 
##################################################
# Description  	: 執行所選擇的程式.
# Date & Author : 2003/07/15 by Hiko
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION azz_exec_cmd()
   DEFINE   ls_cmd_line        STRING
   DEFINE   ls_cmd_catch       STRING
   DEFINE   li_flow_act        LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   ls_msg_cnt         LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   li_result          LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   ls_field_key       STRING
 
   DEFINE   li_btn_cnt         LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   ls_sub_menu        STRING
   DEFINE   li_dir_layer       LIKE type_file.num10  #No.FUN-680135 INTEGER
 
   DEFINE   li_mdir_cnt        LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   li_sdir_cnt        LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   li_i               LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   li_del_btn         LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   li_btn_tmp         LIKE type_file.num10  #No.FUN-680135 INTEGER
 
   DEFINE   lwin_curr          ui.Window,
            lfrm_curr          ui.Form
   DEFINE   lnode_gp01         om.DomNode
   DEFINE   lnode_gd01         om.DomNode
   DEFINE   lnode_gp02         om.DomNode
   DEFINE   lnode_gd02         om.DomNode
   DEFINE   lnode_gp03         om.DomNode
   DEFINE   lnode_gd03         om.DomNode
   DEFINE   ls_lake_pic        STRING
   DEFINE   ls_flow_pic        STRING
   # 2004/05/24 by saki : 每次idle過後距離g_idle_seconds的秒數
   DEFINE   ls_remain_sec      LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   l_lang             LIKE type_file.chr1   #No.FUN-680135 VARCHAR(1)
   # 2004/07/02 by saki : 帳別顯示
   DEFINE   l_bookno           LIKE aaa_file.aaa01
   DEFINE   lc_zz01            LIKE zz_file.zz01     #No.MOD-630050
   DEFINE   lc_zz15            LIKE zz_file.zz15     #No.MOD-630050
   DEFINE   lnode_root         om.DomNode           #MOD-810147
   DEFINE   llst_act           om.NodeList,         #MOD-810147
            lnode_act          om.DomNode,          #MOD-810147
            ls_item_name       STRING               #MOD-810147
   DEFINE   l_sys_info_flag like type_file.num5     #No.FUN-C30122 系統通知警視訊息只顯示一次       
   define   ls_fglasip string #darcy:2024/05/08 add
 
 
   --2004/06/01 by Brendan, for HTTP connection purpose.
   CALL udmtree_notify()
   --#
 
   LET ls_remain_sec = 0
   # 2004/05/20 by saki : 在change語言的時候會碰到第二層結構沒辦法轉換語言,
   #                      所以變成當change語言的時候會重新清除所有資訊再重來
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET l_sys_info_flag = TRUE  #FUN-C30122
   WHILE TRUE
      IF g_action_choice = "locale" THEN
         LET lnode_gp01 = lwin_curr.findNode("Group","gp_flow01")
         LET lnode_gd01 = lnode_gp01.getFirstChild()
         LET lnode_gp02 = lwin_curr.findNode("Group","gp_flow02")
         LET lnode_gd02 = lnode_gp02.getFirstChild()
         LET lnode_gp03 = lwin_curr.findNode("Group","gp_flow03")
         LET lnode_gd03 = lnode_gp03.getFirstChild()
         IF (lnode_gp01.getChildCount() > 0) THEN
            CALL lnode_gp01.removeChild(lnode_gd01)
            LET lnode_gd01 = lnode_gp01.createChild("Grid")
         END IF
         IF (lnode_gp02.getChildCount() > 0) THEN
            CALL lnode_gp02.removeChild(lnode_gd02)
            LET lnode_gd02 = lnode_gp02.createChild("Grid")
         END IF
         IF (lnode_gp03.getChildCount() > 0) THEN
            CALL lnode_gp03.removeChild(lnode_gd03)
            LET lnode_gd03 = lnode_gp03.createChild("Grid")
         END IF
         LET li_dir_layer = "1"
         LET ls_sub_menu = ""
         LET g_action_choice = "" 
      END IF
         
      # 2003/12/19 by Hiko : 原本是INPUT ARRAY,但是為了可以在ComboBox上面編輯,因此才改為CONSTRUCT.
      CALL cl_set_act_visible("cancel", FALSE)
      CONSTRUCT BY NAME ls_cmd_catch ON command_catch,favorite_prog
         BEFORE CONSTRUCT
            LET g_action_choice = ""
            # 2004/05/17 by saki : 將顯示圖片由per改換到4gl顯示
            LET ls_lake_pic = ms_pic_url || "/tiptop/pic/tiptop_image.jpg"
            DISPLAY ls_lake_pic TO FORMONLY.image_lake

            LET ls_field_key = ""
            LET ls_cmd_catch = ""
            LET ls_cmd_line  = ""

            #FUN-CC0120 mark ---start---
            #FUN-C30122 -- start --
            #IF l_sys_info_flag THEN
            #   CALL udmtree_system_information()    #No.FUN-C10041
            #   LET l_sys_info_flag = FALSE
            #END IF
            #FUN-C30122 --end --
            #FUN-CC0120 mark --- end ---

            CALL azz_catch_favorite_cmd()
 
            # 2004/05/06 by saki : 匯入動態流程圖
            SELECT COUNT(UNIQUE gbk02) INTO li_mdir_cnt FROM gbk_file
             WHERE gbk01 = ms_flow_class
 
            # 按第一層時將全部btn值重設
            IF li_dir_layer = 1 THEN
               CALL mr_btn.clear()
               LET li_btn_cnt = 1
               LET mr_btn[li_btn_cnt].btn_name = ""
               LET mr_btn[li_btn_cnt].chg_name = ""
            END IF
 
            CALL udmtree_flow_sheet_create_main_dir()
 
            # 在按第二層的時候, 把第三層的對應btn值刪除
            IF li_dir_layer = 2 THEN
               LET lnode_gp02 = lwin_curr.findNode("Group","gp_flow02")
               LET lnode_gd02 = lnode_gp02.getFirstChild()
               LET li_sdir_cnt = lnode_gd02.getChildCount()
              
               LET li_del_btn = li_mdir_cnt + li_sdir_cnt + 1 
               LET li_btn_tmp = mr_btn.getLength()
               FOR li_i = li_del_btn TO li_btn_tmp
                   CALL mr_btn.deleteElement(li_del_btn)
               END FOR
            END IF
               
            IF ls_sub_menu IS NOT NULL AND ls_sub_menu != "cmdrun" THEN
               CALL udmtree_flow_sheet_act_create(ls_sub_menu)
            END IF
 
            CALL udmtree_flow_btn_change()
 
            IF cl_null(g_notify) THEN                     #FUN-670010  For HTTP connection purpose.
               CALL cl_set_act_visible("hostip",FALSE)
            END IF

            #FUN-CC0120 add ---start---
            #FUN-C30122 -- start --
            IF l_sys_info_flag THEN
               CALL udmtree_system_information()    #No.FUN-C10041
               LET l_sys_info_flag = FALSE
            END IF
            #FUN-C30122 --end --
            #FUN-CC0120 add --- end ---
 
         # 2004/05/01 by saki : 因為"執行"此button共用, 所以必須知道最後停留的
         #                      field是歷史清單還是我的最愛清單
         BEFORE FIELD command_catch
            LET ls_field_key = "c"
 
         BEFORE FIELD favorite_prog
            LET ls_field_key = "f"
 
         ON ACTION my_favorite
            CALL cl_cmdrun_wait('p_favorite')
            EXIT CONSTRUCT
          #--  MOD-420715
         ON ACTION chpasswd
            CALL cl_cmdrun_wait('webpasswd')
            EXIT CONSTRUCT
         #--

         #darcy:2024/05/08 add s---
         on action erphelp
            let ls_fglasip = FGL_GETENV("FGLASIP")
            let ls_fglasip = ls_fglasip.trim(),"/tiptop/help/2/czz/index.html"
            if not cl_open_url(ls_fglasip) then
                call cl_err_msg(null,"lib-052",g_prog clipped ||"|"|| g_lang clipped,10)
            end if
            continue construct
         #darcy:2024/05/08 add e---
 
         #No.FUN-590112 --start--
         ON ACTION message
            CALL cl_cmdrun("p_load_msg")
            EXIT CONSTRUCT
         #No.FUN-590112 ---end---

         #No.FUN-C30221 --start--
         ON ACTION center
            CALL cl_cmdrun_wait('aoos901 continue')    #No.TQC-6A0036
            CALL azz_set_win_title()
            CALL s_udsday()                            #MOD-980264
            EXIT CONSTRUCT
         #No.FUN-C30221 ---end---

         ON ACTION accept
            CASE ls_field_key
               WHEN "c"
                  CALL GET_FLDBUF(command_catch) RETURNING ls_cmd_catch
               WHEN "f"
                  CALL GET_FLDBUF(favorite_prog) RETURNING ls_cmd_catch
            END CASE
 
            IF (NOT cl_null(ls_cmd_catch)) THEN
               IF ls_cmd_catch.getIndexOf("aoos901",1)  OR      #TQC-A70110
                  ls_cmd_catch.getIndexOf("udm_tree",1) THEN  
                  CALL cl_err("","lib-510",1)
                  CONTINUE CONSTRUCT
               ELSE
                  LET ls_cmd_line = ls_cmd_catch
                  EXIT CONSTRUCT
               END IF
            ELSE 
               CONTINUE CONSTRUCT
            END IF
             
         ON ACTION locale
            --2004/06/30 by Brendan: fix bug while cancel the selection
            --          Description: While cancel the locale change, it will cause program exit.
            LET l_lang = g_lang
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()   #FUN-550037(smin)
            IF l_lang != g_lang THEN
               CALL load_start_menu()
               CALL azz_catch_favorite_cmd()
               LET g_action_choice = "locale"
 
               #MOD-810147---start---
             #----genero--改變action accept的屬性
                LET lnode_root = ui.Interface.getRootNode()
                LET llst_act = lnode_root.selectByTagName("ActionDefault")
                FOR li_i = 1 to llst_act.getLength()
                   LET lnode_act = llst_act.item(li_i)
                   LET ls_item_name = lnode_act.getAttribute("name")
                   IF (ls_item_name.equals("accept")) THEN
                      CALL lnode_act.setAttribute("acceleratorName","Return")
                      CALL lnode_act.setAttribute("acceleratorName2","Enter")
                   END IF
                END FOR
             #-----------------------------------
               #MOD-810147---end---
 
               EXIT CONSTRUCT
            END IF
            --#
 
         ON ACTION hostip #FUN-620044   
            CALL cl_sel_serip()   
 
         # 2004/05/25 by saki : 待辦事項
         ON ACTION needproc
            CALL udmtree_needproc_b_fill()
            CALL udmtree_needproc()
            LET g_action_choice = "" 
 
         ON ACTION easyflow                 #FUN-580011 簽核表單
            #TQC-5B0218
            LET g_curr_page = 1
            LET g_total_page = 1
            IF g_aza.aza23 matches '[ Nn]' THEN   #未設定與 EasyFlow 簽核
                  LET g_status = 0
                  CALL cl_set_act_visible("go,selectbox,efrefresh",FALSE)
                  CALL cl_err('aza23','mfg3551',1)
            ELSE
                IF (NOT g_status) OR g_status IS NULL THEN
                  LET g_forminfo = "Inbox"
                  LET g_strfilter = "ALL"
                  LET g_intfilter = "2"
                  CALL aws_efapp_formID() RETURNING g_status
                  CALL cl_set_comp_visible("ef01,ef02,ef03,ef04,ef05,ef15,ef16,ef17,ef18",FALSE)
                END IF
                CALL udmtree_efmenu()
            END IF
            #END TQC-5B0218
            LET g_action_choice = ""

         #FUN-880099  --start
         ON ACTION easyflowgp
            CALL udmtree_ef_action()
            LET g_action_choice = ""
         #FUN-880099  --end
 
         #No.FUN-570225 --start--
         ON ACTION search
            CALL udmtree_search()
            LET g_action_choice = ""
         #No.FUN-570225 ---end---
 
         # 2004/05/24 by saki : 訊息每ms_msg_sec偵測一次, 每idle一次ms_msg_rec
         #                      ms_idle_sec就累加ms_msg_rec一次, 直到g_idle_sec
         #                      後則去執行cl_on_idle
         ON IDLE ms_msg_sec
            SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
             WHERE gar02 = g_user AND gar06 = 'N'
            IF ls_msg_cnt > 0 THEN
               CALL user_getprocess() RETURNING li_result
               IF NOT li_result THEN
                  CALL cl_cmdrun('p_load_msg')
               END IF
            END IF
            #No.FUN-570271 --start--
            IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
               CALL udmtree_detect_process() RETURNING li_result
               IF (NOT li_result) THEN
                  LET ms_idle_sec = ms_idle_sec + ms_msg_sec
                  LET ls_remain_sec = g_idle_seconds - ms_idle_sec
                  IF ls_remain_sec < ms_msg_sec THEN
                     LET ms_msg_sec = ls_remain_sec
                  END IF
                  IF ms_idle_sec = g_idle_seconds THEN
                     LET ms_idle_sec = 0
                     LET ls_remain_sec = 0
                    #-CHI-980033-add-
                     IF g_idle_seconds < 3 THEN
                        LET ms_msg_sec = g_idle_seconds
                     ELSE
                        LET ms_msg_sec = g_idle_seconds / 3
                     END IF
                    #-CHI-980033-end-
                     IF ms_msg_sec > 180 THEN
                        LET ms_msg_sec = 180
                     END IF
                     CALL cl_on_idle()
                     CONTINUE CONSTRUCT
                  END IF
               END IF
            END IF
            #No.FUN-570271 ---end---
 
         ON ACTION controlp
            CALL cl_cmdrun_wait('aoos901 continue')    #No.TQC-6A0036
            CALL azz_set_win_title()
            CALL s_udsday()			       #MOD-980264
            EXIT CONSTRUCT
 
         ON ACTION controly
            CALL s_selact(0,0,g_lang) RETURNING l_bookno
            IF NOT cl_null(l_bookno) THEN
                LET g_bookno_old = g_bookno                  # MOD-4B0256
               LET g_bookno = l_bookno
               CALL udmtree_update_startmenu()
               #no.5713 6.0 UI
               IF cl_fglgui() MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
                  CALL s_dsmark(g_bookno)
               END IF
               #no.5713 (end)
            ELSE
#              DISPLAY g_bookno TO g_bookno
            END IF
 
         #No.FUN-670045 --start--
         ON ACTION startmenu_refresh
            CALL load_start_menu()
         #No.FUN-670045 ---end---
 
         #No.FUN-830106 --start--
         ON ACTION del_usual_prog
            CALL azz_delete_cmd()
            EXIT CONSTRUCT
         #No.FUN-830106 ---end---
 
         # 2004/05/06 by saki : 動態流程所使用的button
         ON ACTION btn1
            CALL udmtree_flow_check_act_name("btn1") RETURNING ls_sub_menu,li_dir_layer 
	    IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn2
            CALL udmtree_flow_check_act_name("btn2") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn3
            CALL udmtree_flow_check_act_name("btn3") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn4
            CALL udmtree_flow_check_act_name("btn4") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn5
            CALL udmtree_flow_check_act_name("btn5") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn6
            CALL udmtree_flow_check_act_name("btn6") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn7
            CALL udmtree_flow_check_act_name("btn7") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn8
            CALL udmtree_flow_check_act_name("btn8") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn9
            CALL udmtree_flow_check_act_name("btn9") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn10
            CALL udmtree_flow_check_act_name("btn10") RETURNING ls_sub_menu,li_dir_layer 
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn11
            CALL udmtree_flow_check_act_name("btn11") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn12
            CALL udmtree_flow_check_act_name("btn12") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn13
            CALL udmtree_flow_check_act_name("btn13") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn14
            CALL udmtree_flow_check_act_name("btn14") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn15
            CALL udmtree_flow_check_act_name("btn15") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn16
            CALL udmtree_flow_check_act_name("btn16") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn17
            CALL udmtree_flow_check_act_name("btn17") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn18
            CALL udmtree_flow_check_act_name("btn18") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn19
            CALL udmtree_flow_check_act_name("btn19") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn20
            CALL udmtree_flow_check_act_name("btn20") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn21
            CALL udmtree_flow_check_act_name("btn21") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn22
            CALL udmtree_flow_check_act_name("btn22") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn23
            CALL udmtree_flow_check_act_name("btn23") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn24
            CALL udmtree_flow_check_act_name("btn24") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn25
            CALL udmtree_flow_check_act_name("btn25") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn26
            CALL udmtree_flow_check_act_name("btn26") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn27
            CALL udmtree_flow_check_act_name("btn27") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn28
            CALL udmtree_flow_check_act_name("btn28") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn29
            CALL udmtree_flow_check_act_name("btn29") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn30
            CALL udmtree_flow_check_act_name("btn30") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn31
            CALL udmtree_flow_check_act_name("btn31") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn32
            CALL udmtree_flow_check_act_name("btn32") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn33
            CALL udmtree_flow_check_act_name("btn33") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn34
            CALL udmtree_flow_check_act_name("btn34") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn35
            CALL udmtree_flow_check_act_name("btn35") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn36
            CALL udmtree_flow_check_act_name("btn36") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn37
            CALL udmtree_flow_check_act_name("btn37") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn38
            CALL udmtree_flow_check_act_name("btn38") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn39
            CALL udmtree_flow_check_act_name("btn39") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn40
            CALL udmtree_flow_check_act_name("btn40") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn41
            CALL udmtree_flow_check_act_name("btn41") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn42
            CALL udmtree_flow_check_act_name("btn42") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn43
            CALL udmtree_flow_check_act_name("btn43") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn44
            CALL udmtree_flow_check_act_name("btn44") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn45
            CALL udmtree_flow_check_act_name("btn45") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn46
            CALL udmtree_flow_check_act_name("btn46") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn47
            CALL udmtree_flow_check_act_name("btn47") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn48
            CALL udmtree_flow_check_act_name("btn48") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn49
            CALL udmtree_flow_check_act_name("btn49") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn50
            CALL udmtree_flow_check_act_name("btn50") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn51
            CALL udmtree_flow_check_act_name("btn51") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn52
            CALL udmtree_flow_check_act_name("btn52") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn53
            CALL udmtree_flow_check_act_name("btn53") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn54
            CALL udmtree_flow_check_act_name("btn54") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn55
            CALL udmtree_flow_check_act_name("btn55") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         #No.FUN-610052 --start-- 增加button數
         ON ACTION btn56
            CALL udmtree_flow_check_act_name("btn56") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn57
            CALL udmtree_flow_check_act_name("btn57") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn58
            CALL udmtree_flow_check_act_name("btn58") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn59
            CALL udmtree_flow_check_act_name("btn59") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn60
            CALL udmtree_flow_check_act_name("btn60") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn61
            CALL udmtree_flow_check_act_name("btn61") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn62
            CALL udmtree_flow_check_act_name("btn62") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn63
            CALL udmtree_flow_check_act_name("btn63") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn64
            CALL udmtree_flow_check_act_name("btn64") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         ON ACTION btn65
            CALL udmtree_flow_check_act_name("btn65") RETURNING ls_sub_menu,li_dir_layer
            IF ls_sub_menu != "cmdrun" THEN
               EXIT CONSTRUCT
            END IF
         #No.FUN-610052 ---end---
 
         ON ACTION help                   # H.說明
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
          ON ACTION about     #MOD-510103
            CALL cl_about()
 
         ON ACTION exit
            CALL udmtree_exit_confirm()                    #No.FUN-5B005
#           #NO.FUN-570170
#           IF cl_confirm('azz-901') THEN
#              LET g_action_choice = "exit"      
#              CALL udmtree_close()                        #No.FUN-570225
#              CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-580093  #No.FUN-6A0096
#              CLOSE WINDOW w_udm_tree
#              EXIT PROGRAM
#           END IF
#           #--END
            EXIT CONSTRUCT
 
         ON ACTION cancel
            LET INT_FLAG = FALSE                           #No.FUN-5B0054
            CALL udmtree_exit_confirm()                    #No.FUN-5B0054
#           #NO.FUN-570170
#           IF cl_confirm('azz-901') THEN
#              LET g_action_choice = "exit"
#              CALL udmtree_close()                        #No.FUN-570225
#              CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-580093  #No.FUN-6A0096
#              CLOSE WINDOW w_udm_tree
#              EXIT PROGRAM
#           END IF
#           #--END
         
#         ON ACTION cascade_chart           #No.FUN-BA0079
#            CALL udm_tree_cascade_chart()  #No.FUN-BA0079
#            LET g_action_choice = ""
#
#         ON ACTION custom_chart            #No.FUN-BA0079
#            CALL udm_tree_custom_chart()   #No.FUN-BA0079
#            LET g_action_choice = ""

 
      END CONSTRUCT
      LET ls_cmd_catch = ls_cmd_catch CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      CALL cl_set_act_visible("cancel", TRUE)
 
      IF (INT_FLAG) OR g_action_choice = "exit" THEN 
         EXIT WHILE
      ELSE
         IF (NOT li_flow_act) THEN
            CALL azz_update_cmd(ls_cmd_line)
            CALL azz_catch_recently_cmd()
         ELSE
            LET li_flow_act = FALSE
         END IF
 
         IF NOT cl_null(ls_cmd_line) THEN
            IF (ls_cmd_line.getIndexOf("aoos901",1)) THEN    #No.TQC-6A0036
               CALL cl_cmdrun_wait(ls_cmd_line)
               CALL azz_set_win_title()
               CALL s_udsday()			       	     #MOD-980264
            ELSE
               #No.MOD-630050 --start--
               IF ls_cmd_line.getIndexOf(" ",1) <= 0 THEN
                  LET lc_zz01 = ls_cmd_line
                  SELECT zz15 INTO lc_zz15 FROM zz_file
                   WHERE zz01 = lc_zz01
                  IF lc_zz15 = "Y" THEN
                    #-MOD-AC0022-add-
                     IF ls_cmd_line = 'aglt110' OR ls_cmd_line = 'aglt130' THEN
                        LET ls_cmd_line = ls_cmd_line," '' '",g_bookno,"' ''"
                     ELSE
                        LET ls_cmd_line = ls_cmd_line," ",g_bookno	
                     END IF
                    #-MOD-AC0022-end-
                  END IF
               END IF
               #No.MOD-630050 ---end---
               CALL cl_cmdrun(ls_cmd_line)
            END IF
         END IF
      END IF
   END WHILE
END FUNCTION

PRIVATE FUNCTION udm_tree_cascade_chart() #No.FUN-BA0079
   DEFINE chart_sel   STRING        #主題的下拉選單
   DEFINE wc_1, wc_2, wc_3  STRING  #6個動態圖表
   DEFINE wc_4, wc_5, wc_6  STRING
   DEFINE   ls_msg_cnt           LIKE type_file.num5
   DEFINE   li_result            LIKE type_file.num5
   DEFINE   ls_remain_sec        LIKE type_file.num5

   CALL s_chart_linked_set("chart_sel")   #初始下拉選單主題的值
   #CALL s_chart_linked_m("下拉選單的第1個值","","") #初始化6個連動圖表
   DIALOG ATTRIBUTES(UNBUFFERED=TRUE)

      #接收圖表的回傳值
      INPUT BY NAME wc_1, wc_2, wc_3, wc_4, wc_5, wc_6 ATTRIBUTES(WITHOUT DEFAULTS=TRUE) END INPUT
      #下拉選單-圖表主題
      INPUT BY NAME chart_sel ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
         ON CHANGE chart_sel
            CALL s_chart_linked_m(chart_sel,"","") #主題變動後，初始化6個連動圖表
      END INPUT

      #點擊第1個圖表
      ON ACTION wc_1  
         CALL s_chart_linked_m(chart_sel, 1,wc_1)
      #點擊第2個圖表   
      ON ACTION wc_2 
        CALL s_chart_linked_m(chart_sel, 2,wc_2)
      #點擊第3個圖表   
      ON ACTION wc_3 
         CALL s_chart_linked_m(chart_sel, 3,wc_3)
      #點擊第4個圖表
      ON ACTION wc_4  
         CALL s_chart_linked_m(chart_sel, 4,wc_4)
      #點擊第5個圖表
      ON ACTION wc_5 
         CALL s_chart_linked_m(chart_sel, 5,wc_5)
      #點擊第6個圖表
      ON ACTION wc_6 
         CALL s_chart_linked_m(chart_sel, 6,wc_6)
    
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT DIALOG
     
      ON ACTION exit
         CALL udmtree_exit_confirm()


      ON ACTION controlp
         CALL cl_cmdrun_wait('aoos901 continue')        #No.TQC-6A0036
         CALL azz_set_win_title()
         CALL s_udsday()			       	#MOD-980264
         EXIT DIALOG

      ON ACTION needproc                    
         CALL udmtree_needproc_b_fill()
         CALL udmtree_needproc()
         LET g_action_choice = "exit"
         EXIT DIALOG

      ON ACTION info
         LET g_action_choice = "exit"
         EXIT DIALOG
 
      ON ACTION system_flow
         LET g_action_choice = "exit"
         EXIT DIALOG
 
      ON ACTION so_flow
         LET g_action_choice = "exit"
         EXIT DIALOG

      ON ACTION easyflow
         CALL udmtree_ef_action()
         LET g_action_choice = "exit"
         EXIT DIALOG

      ON ACTION easyflowgp
         CALL cl_set_comp_visible("easyflow",FALSE)
         CALL udmtree_ef_action()
         EXIT DIALOG

      ON IDLE ms_msg_sec
         SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
          WHERE gar02 = g_user AND gar06 = 'N'
         IF ls_msg_cnt > 0 THEN
            CALL user_getprocess() RETURNING li_result
            IF NOT li_result THEN
               CALL cl_cmdrun('p_load_msg')
            END IF
         END IF
         IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
            CALL udmtree_detect_process() RETURNING li_result
            IF (NOT li_result) THEN
               LET ms_idle_sec = ms_idle_sec + ms_msg_sec
               LET ls_remain_sec = g_idle_seconds - ms_idle_sec
               IF ls_remain_sec < ms_msg_sec THEN
                  LET ms_msg_sec = ls_remain_sec
               END IF
               IF ms_idle_sec = g_idle_seconds THEN
                  LET ms_idle_sec = 0
                  LET ls_remain_sec = 0
                 #-CHI-980033-add-
                  IF g_idle_seconds < 3 THEN
                     LET ms_msg_sec = g_idle_seconds
                  ELSE
                     LET ms_msg_sec = g_idle_seconds / 3
                  END IF
                 #-CHI-980033-end-
                  IF ms_msg_sec > 180 THEN
                     LET ms_msg_sec = 180
                  END IF
                  CALL cl_on_idle()
                  CONTINUE DIALOG
               END IF
            END IF
         END IF

      ON ACTION controlg 
        CALL cl_cmdask()
 
      ON ACTION about   
        CALL cl_about()
 
      ON ACTION help   
        CALL cl_show_help()
      
      ON ACTION search
         CALL udmtree_search()
         EXIT DIALOG

      ON ACTION custom_chart
         CALL udm_tree_custom_chart()
         EXIT DIALOG

      ON ACTION close
         LET INT_FLAG=FALSE
         CALL udmtree_exit_confirm()

   END DIALOG
END FUNCTION

#填充ComboBox有使用權限的圖表
PRIVATE FUNCTION udm_tree_chart_fill_sel()

END FUNCTION

PRIVATE FUNCTION udm_tree_custom_chart()  #No.FUN-BA0079
   DEFINE l_w      ui.Window
   DEFINE l_f      ui.Form
   DEFINE l_wc     STRING
   DEFINE l_comb1  STRING
   DEFINE l_comb2  STRING
   DEFINE l_values STRING,
          l_items  STRING
   DEFINE l_cnt   INTEGER,
          l_sql   STRING,
          l_gdk01 LIKE gdk_file.gdk01,
          l_gfp04 LIKE gfp_file.gfp04,
          l_gdk02 LIKE gdk_file.gdk02,
          l_gdk03 LIKE gdk_file.gdk03,
          l_ze03  LIKE ze_file.ze03
   DEFINE l_cus_wc  RECORD  
          wc_c1   STRING
          END RECORD 
   DEFINE l_gdk   RECORD
          cust_chart_sel LIKE gdk_file.gdk01, 
          wc_c1_gdk02, wc_c1_gdk03 STRING
          END RECORD
   DEFINE l_i   INTEGER
   DEFINE l_tmp STRING
   DEFINE   ls_msg_cnt           LIKE type_file.num5
   DEFINE   li_result            LIKE type_file.num5
   DEFINE   ls_remain_sec        LIKE type_file.num5

   LET l_sql = "SELECT gdk01, gfp04 FROM gdk_file LEFT JOIN gfp_file ON gdk01 = gfp01 and gfp02 = 'name' AND gfp03 = '",g_lang,"' ORDER BY gfp04"
   
   PREPARE udm_tree_cus_p1 FROM l_sql
   DECLARE udm_tree_cus_d1 CURSOR FOR udm_tree_cus_p1

   LET l_values = ""
   LET l_items = ""
   FOREACH udm_tree_cus_d1 INTO l_gdk01, l_gfp04  #填充使用者能使用的所有圖表ComboBox
      IF s_chart_auth(l_gdk01, g_user) THEN
         LET l_values = l_values, l_gdk01,","
         LET l_items = l_items, l_gfp04, ","
      END IF
         
   END FOREACH
   CALL cl_set_combo_items("cust_chart_sel",l_values, l_items)
   
#   FOR l_i = 1 TO 6
#      LET l_tmp = l_i
#      LET l_comb1 = "wc_c",l_tmp.trim(),"_comb"
#      LET l_wc = "wc_c", l_tmp CLIPPED

#      IF cl_null(l_gdl[l_i].gdl03) THEN
#         CALL l_f.setFieldHidden(l_wc, cl_null(l_gdl[l_i].gdl03))  #隱藏未設定圖表代碼的WebComponent
#         CALL cl_set_comp_visible(l_comb1 || "_1", 0)              #隱藏未設定圖表代碼的第1個ComboBox
#         CALL cl_set_comp_visible(l_comb1 || "_2", 0)              #隱藏未設定圖表代碼的第2個ComboBox
#      END IF
#      #CALL l_f.setElementHidden(l_comb1, cl_null(g_gdk[l_i].gdk02))  #隱藏沒有參數設定的ComboBox
#      #CALL l_f.setElementHidden(l_comb2, cl_null(g_gdk[l_i].gdk03))  #隱藏沒有參數設定的ComboBox
#      CALL cl_chart_set_combo_items(l_wc, l_gdl[l_i].gdl03) RETURNING l_r1, l_r2  #呼叫填充每個圖表自己擁有的2個ComboBox
#      CALL cl_udm_chart(l_gdl[l_i].gdl03, l_r1, l_r2, l_wc)
#   END FOR
 

   CALL cl_set_comp_visible("wc_c1_comb_1,wc_c1_comb_2,cust_cond1,cust_cond2",FALSE)
   CALL cl_set_property_comp("wc_c1","data" ,"<chart/>")
   DIALOG ATTRIBUTES(UNBUFFERED=TRUE)
      #接收動態圖表的回傳值，因為沒連動，所以不加ON ACTION
      INPUT l_cus_wc.* FROM s_cus_chart.* END INPUT
      
      #篩選條件的ComboBox
      INPUT l_gdk.* FROM s_gdk.* 
         ON CHANGE cust_chart_sel #重新選擇了圖表
            SELECT gdk02, gdk03  INTO l_gdk02, l_gdk03 FROM gdk_file WHERE gdk01 = l_gdk.cust_chart_sel
            IF NOT cl_null(l_gdk02) THEN 
               SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = l_gdk02 AND ze02 = g_lang
               CALL cl_set_comp_visible("cust_cond1",TRUE)
               DISPLAY l_ze03 TO FORMONLY.cust_cond1
            ELSE
               CALL cl_set_comp_visible("cust_cond1",FALSE)
            END IF
            IF NOT cl_null(l_gdk03) THEN
               SELECT ze03 INTO l_ze03 FROM ze_file WHERE ze01 = l_gdk03 AND ze02 = g_lang
               CALL cl_set_comp_visible("cust_cond2",TRUE)
               DISPLAY l_ze03 TO FORMONLY.cust_cond2
            ELSE
               CALL cl_set_comp_visible("cust_cond2",FALSE)
            END IF
            CALL cl_chart_set_combo_items("wc_c1", l_gdk.cust_chart_sel, "","") RETURNING l_gdk.wc_c1_gdk02, l_gdk.wc_c1_gdk03
            CALL cl_udm_chart(l_gdk.cust_chart_sel, l_gdk.wc_c1_gdk02, l_gdk.wc_c1_gdk03, "wc_c1")
         
         ON CHANGE wc_c1_comb_1
           #CALL cl_chart_set_combo_items("wc_c1", l_gdk.cust_chart_sel, s_gdk.wc_c1_comb_1, "") #TQC-C20485
            CALL cl_chart_set_combo_items("wc_c1",l_gdk.cust_chart_sel,l_gdk.wc_c1_gdk02,l_gdk.wc_c1_gdk03) RETURNING l_gdk.wc_c1_gdk02,l_gdk.wc_c1_gdk03 #TQC-C20485
            CALL cl_udm_chart(l_gdk.cust_chart_sel, l_gdk.wc_c1_gdk02, l_gdk.wc_c1_gdk03, "wc_c1")
            
         ON CHANGE wc_c1_comb_2
            CALL cl_udm_chart(l_gdk.cust_chart_sel, l_gdk.wc_c1_gdk02, l_gdk.wc_c1_gdk03, "wc_c1")
    
      END INPUT

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT DIALOG
      
      ON ACTION exit
         CALL udmtree_exit_confirm()
   
      ON ACTION controlp
         CALL cl_cmdrun_wait('aoos901 continue')  
         CALL azz_set_win_title()
         CALL s_udsday()
         EXIT DIALOG
   
      ON ACTION needproc                    
         CALL udmtree_needproc_b_fill()
         CALL udmtree_needproc()
         LET g_action_choice = "exit"
         EXIT DIALOG
   
      ON ACTION info
         LET g_action_choice = "exit"
         EXIT DIALOG
    
      ON ACTION system_flow
         LET g_action_choice = "exit"
         EXIT DIALOG
    
      ON ACTION so_flow
         LET g_action_choice = "exit"
         EXIT DIALOG
   
      ON ACTION easyflow
         CALL udmtree_ef_action()
         LET g_action_choice = "exit"
         EXIT DIALOG
   
      ON ACTION easyflowgp
         CALL cl_set_comp_visible("easyflow",FALSE)
         CALL udmtree_ef_action()
         EXIT DIALOG
   
      ON IDLE ms_msg_sec
         SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
          WHERE gar02 = g_user AND gar06 = 'N'
         IF ls_msg_cnt > 0 THEN
            CALL user_getprocess() RETURNING li_result
            IF NOT li_result THEN
               CALL cl_cmdrun('p_load_msg')
            END IF
         END IF
         IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN 
            CALL udmtree_detect_process() RETURNING li_result
            IF (NOT li_result) THEN
               LET ms_idle_sec = ms_idle_sec + ms_msg_sec
               LET ls_remain_sec = g_idle_seconds - ms_idle_sec
               IF ls_remain_sec < ms_msg_sec THEN
                  LET ms_msg_sec = ls_remain_sec
               END IF
               IF ms_idle_sec = g_idle_seconds THEN
                  LET ms_idle_sec = 0
                  LET ls_remain_sec = 0
                 #-CHI-980033-add-
                  IF g_idle_seconds < 3 THEN
                     LET ms_msg_sec = g_idle_seconds
                  ELSE
                     LET ms_msg_sec = g_idle_seconds / 3
                  END IF
                 #-CHI-980033-end-
                  IF ms_msg_sec > 180 THEN
                     LET ms_msg_sec = 180
                  END IF
                  CALL cl_on_idle()
                  CONTINUE DIALOG
               END IF
            END IF
         END IF
   
      ON ACTION controlg 
        CALL cl_cmdask()
    
      ON ACTION about   
        CALL cl_about()
    
      ON ACTION help   
        CALL cl_show_help()
      
      ON ACTION search
         CALL udmtree_search()
         EXIT DIALOG
   
      ON ACTION cascade_chart
         CALL udm_tree_cascade_chart()
         EXIT DIALOG    
         
      ON ACTION close
         LET INT_FLAG=FALSE
         CALL udmtree_exit_confirm()

   END DIALOG
END FUNCTION

##################################################
# Description  	: 更新最近30筆已執行過的程式清單.
# Date & Author : 2003/07/15 by Hiko
# Parameter   	: pc_prog VARCHAR(10) 程式名稱
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION azz_update_cmd(pc_prog)
   DEFINE   pc_prog        LIKE gaa_file.gaa02
   DEFINE   ld_curr_date   LIKE gaa_file.gaa03
   DEFINE   ld_curr_time   LIKE gaa_file.gaa04
   DEFINE   li_gaa_count   LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   lr_gaa         RECORD LIKE gaa_file.*
 
   LET ld_curr_date = CURRENT YEAR TO DAY
   LET ld_curr_time = CURRENT HOUR TO MINUTE
 
   SELECT COUNT(*) INTO li_gaa_count FROM gaa_file WHERE gaa01=g_user AND gaa02=pc_prog
   # 2003/11/19 by Hiko : 判斷目前執行的程式資料是否存在於資料庫.
   IF (li_gaa_count = 0) THEN
      SELECT COUNT(*) INTO li_gaa_count FROM gaa_file WHERE gaa01=g_user
      # 2003/07/16 By Hiko : 如果資料庫的資料筆數已經到達最大值,則必須刪除日期時間為最早的一筆資料.
      IF (li_gaa_count >= 30) THEN   
         DECLARE lcurs_gaa CURSOR FOR
                           SELECT * FROM gaa_file WHERE gaa01=g_user ORDER BY gaa03,gaa04 DESC
         
         FOREACH lcurs_gaa INTO lr_gaa.*
            DELETE FROM gaa_file WHERE gaa01=g_user AND gaa02=lr_gaa.gaa02
            
            LET li_gaa_count = li_gaa_count - 1
      
            IF (li_gaa_count < 30) THEN
               EXIT FOREACH
            END IF
         END FOREACH
      END IF
      # 2003/05/16 By Hiko : 執行到這裡,表示已經少於資料筆數最大值.
      IF NOT cl_null(pc_prog) THEN
          INSERT INTO gaa_file(gaa01,gaa02,gaa03,gaa04) #No.MOD-470041
                       VALUES(g_user,pc_prog,ld_curr_date,ld_curr_time)
      END IF
   ELSE
      # 2003/05/16 By Hiko : 資料庫存在此ls_cmd_line,就要更新日期時間.
      IF NOT cl_null(pc_prog) THEN
         UPDATE gaa_file SET gaa03=ld_curr_date, gaa04=ld_curr_time WHERE gaa01=g_user AND gaa02=pc_prog
      END IF
   END IF  
END FUNCTION
 
##################################################
# Description  	: 刪除已執行過的程式清單.
# Date & Author : 2008/04/24 by saki
# Parameter   	: none
# Return   	: void
# Memo        	: No.FUN-830106
# Modify   	:
##################################################
FUNCTION azz_delete_cmd()
   IF cl_confirm("azz-749") THEN
      DELETE FROM gaa_file WHERE gaa01=g_user
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gaa_file",g_user,"",SQLCA.sqlcode,"","",0)
      END IF
   END IF
END FUNCTION
 
# Modify....: 05/04/19 FUN-510047 alex 修改 load StartMenu 去除 dbname
 
FUNCTION load_start_menu()
   DEFINE   lc_menu_root    LIKE zx_file.zx05,
            lc_menu_key     LIKE zx_file.zx05
   DEFINE   ls_file_path    STRING
   DEFINE   ls_result       LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   ls_remain_sec   LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
 
 
   SELECT zx05 INTO lc_menu_root FROM zx_file WHERE zx01=g_user
   IF (SQLCA.SQLCODE) THEN
      LET lc_menu_root = "menu"
   END IF
 
   ## Add by Raymon
   CALL cl_set_config_path()
 
#  #FUN-510047
   LET ls_file_path = gs_4sm_path || "/" || g_lang || "/" || lc_menu_root CLIPPED || ".4sm"
 
   CALL ui.Interface.loadStartMenu(ls_file_path)
   IF (STATUS) THEN
      DISPLAY ls_file_path || " load error."
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-580093  #No.FUN-6A0096
      EXIT PROGRAM
   END IF
 
   # 2004/06/16 by saki : 若使用者所屬權限類別在zy內有定義使用哪些程式，需重整4sm
   CALL azz_check_no_auth_menu()
 
   LET lc_menu_key = ARG_VAL(1)
   IF (cl_null(lc_menu_key)) THEN
      LET lc_menu_key = "menu"
   END IF
 
   IF (NOT lc_menu_key CLIPPED = "menu") THEN
      IF (NOT azz_remove_surplus_menu(lc_menu_key CLIPPED)) THEN
         MENU "Exclamation" ATTRIBUTE(STYLE="dialog",
                                      COMMENT=lc_menu_key CLIPPED || " node not found. We will show all menus.",
                                      IMAGE="exclamation")
            #ON ACTION ok
            #   EXIT MENU
 
            COMMAND KEY(INTERRUPT)
               CALL udmtree_exit_confirm()                    #No.FUN-5B0054
#              IF cl_confirm('azz-901') THEN
#                  LET INT_FLAG=FALSE
#                  #LET g_action_choice = "exit"
#                  #EXIT MENU
#                  CALL udmtree_close()                        #No.FUN-570225
#                  CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-580093  #No.FUN-6A0096
#                  CLOSE WINDOW w_udm_tree
#                  EXIT PROGRAM
#              END IF
               #--END
 
            #No.FUN-570271 --start--
            ON IDLE ms_msg_sec
               IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
                  CALL udmtree_detect_process() RETURNING ls_result
                  IF (NOT ls_result) THEN
                     LET ms_idle_sec = ms_idle_sec + ms_msg_sec
                     LET ls_remain_sec = g_idle_seconds - ms_idle_sec
                     IF ls_remain_sec < ms_msg_sec THEN
                        LET ms_msg_sec = ls_remain_sec
                     END IF
                     IF ms_idle_sec = g_idle_seconds THEN
                        LET ms_idle_sec = 0
                        LET ls_remain_sec = 0
                       #-CHI-980033-add-
                        IF g_idle_seconds < 3 THEN
                           LET ms_msg_sec = g_idle_seconds
                        ELSE
                           LET ms_msg_sec = g_idle_seconds / 3
                        END IF
                       #-CHI-980033-end-
                        IF ms_msg_sec > 180 THEN
                           LET ms_msg_sec = 180
                        END IF
                        CALL cl_on_idle()
                        CONTINUE MENU
                     END IF
                  END IF
               END IF
            #No.FUN-570271 ---end---
 
            ON ACTION help
               CALL cl_show_help()
            ON ACTION controlg
               CALL cl_cmdask()
            ON ACTION about
               CALL cl_about()
 
         END MENU
      END IF
   END IF
 
END FUNCTION
 
##################################################
# Description   : 偵測使用者目前處理程序
# Date & Author : 2004/04/08 by saki
# Parameter     : none
# Return        : void
# Memo          : 用於是否呼叫p_load_msg
# Modify        : No.TQC-660107 整個function翻新
##################################################
FUNCTION user_getprocess()
   DEFINE   ls_cmd       STRING
   DEFINE   lc_channel   base.Channel
   DEFINE   ls_result    STRING
   DEFINE   li_result    LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   ls_fglserver STRING
   DEFINE   li_cnt       LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   li_i         LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   lc_gbq01     LIKE gbq_file.gbq01
   DEFINE   lc_gbq04     LIKE gbq_file.gbq04
 
 
   #找出此使用者目前所有的process
   RUN "fglWrt -u"              #No.MOD-670090
   LET ls_cmd = "fglWrt -a info user 2>&1"
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe(ls_cmd,"r")
   CALL lc_channel.setDelimiter("")
   LET li_i = 1
   CALL g_user_pid.clear()
   WHILE lc_channel.read(ls_result)
      LET li_cnt = ls_result.getIndexOf("GUI Server",1)
      IF li_cnt > 0 THEN
         #No.FUN-920138 saki  --start--
         IF ls_result.getIndexOf("Process Id",1) > 0 THEN
            LET ls_fglserver = ls_result.subString(ls_result.getIndexOf("GUI Server",1) + 11,ls_result.getIndexOf("Process Id",1)-4)
         ELSE
         #No.FUN-920138 saki  ---end---
            LET ls_fglserver = ls_result.subString(li_cnt + 11,ls_result.getLength())
            CONTINUE WHILE   #No:EXT-9C0145
         END IF  #No.FUN-920138 saki 
#        CONTINUE WHILE   #No:EXT-9C0145 mark
      END IF
 
      #只抓自己IP的各process id
      IF NOT g_udmtree_ip.equals(ls_fglserver) THEN
         CONTINUE WHILE
      END IF
 
      LET li_cnt = ls_result.getIndexOf("Process Id",1)
      IF li_cnt > 0 THEN
         LET g_user_pid[li_i] = ls_result.subString(li_cnt + 11,ls_result.getLength())
         LET li_i = li_i + 1
      END IF
   END WHILE
   CALL lc_channel.close()
   CALL g_user_pid.deleteElement(li_i)
 
   #判斷是否已經有啟動著p_load_msg
   LET li_result = FALSE
   FOR li_i = 1 TO g_user_pid.getLength()
       LET lc_gbq01 = g_user_pid[li_i]
       SELECT gbq04 INTO lc_gbq04 FROM gbq_file WHERE gbq01 = lc_gbq01
       IF NOT cl_null(lc_gbq04) AND lc_gbq04 = "p_load_msg" THEN
          LET li_result = TRUE
          EXIT FOR
       END IF
   END FOR
 
   RETURN li_result
END FUNCTION
 
##################################################
# Description   : 建立流程圖主目錄
# Date & Author : 2004/05/06 by saki
# Parameter     : none
# Return        : void
# Memo          : 三個Group名稱分別是gp_flow1,gp_flow2,gp_flow3，必須與per檔對應
# Modify        :
##################################################
FUNCTION udmtree_flow_sheet_create_main_dir()
   DEFINE   ls_gbk03             LIKE gbk_file.gbk03
   DEFINE   ls_gbk05             LIKE gbk_file.gbk05
   DEFINE   ls_gbk02             LIKE gbk_file.gbk02
 
   DEFINE   lwin_curr            ui.Window,
            lfrm_curr            ui.Form
 
   DEFINE   lnode_win            om.DomNode
   DEFINE   lnode_gp01           om.DomNode
   DEFINE   lnode_gd01           om.DomNode
   DEFINE   lnode_btn            om.DomNode
 
   DEFINE   li_posY              LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   ls_create_main_dir   LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   li_cnt               LIKE type_file.num10  #No.FUN-680135 INTEGER
 
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_win = lwin_curr.getNode()
   LET lnode_gp01 = lwin_curr.findNode("Group","gp_flow01")
   LET lnode_gd01 = lnode_gp01.getFirstChild()
 
   DECLARE lcurs_m_dir CURSOR FOR
                       SELECT UNIQUE gbk03,gbk05,gbk02 FROM gbk_file
                        WHERE gbk01 = ms_flow_class AND gbk04 = g_lang
                        ORDER BY gbk02
 
#  LET li_posY = 1   #No.FUN-670045
   LET li_posY = 0
 
   FOREACH lcurs_m_dir INTO ls_gbk03,ls_gbk05,ls_gbk02
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
 
      IF (NOT ls_create_main_dir) THEN
         LET lnode_btn = lnode_gd01.createChild("Button")
         CALL lnode_btn.setAttribute("name",ls_gbk03 CLIPPED)
         CALL lnode_btn.setAttribute("text","   " || ls_gbk05 CLIPPED || "   ")
         CALL lnode_btn.setAttribute("gridWidth",20)
#        LET li_posY = li_posY + 40  #No.FUN-670045
         LET li_posY = li_posY + 1
         CALL lnode_btn.setAttribute("posY",li_posY)
      END IF
 
      SELECT COUNT(*) INTO li_cnt FROM gbk_file
       WHERE gbk01 = ls_gbk03
      IF li_cnt > 0 THEN
         # 確認先前沒有置換過button的話, 將替換名存入 btn array
         CALL udmtree_flow_check_button_num(ls_gbk03 CLIPPED)
      END IF
 
   END FOREACH
   LET ls_create_main_dir = TRUE
END FUNCTION
 
##################################################
# Description   : 建立流程圖副目錄
# Date & Author : 2004/05/06 by saki
# Parameter     : ls_sub_dir  節點名稱
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION udmtree_flow_sheet_act_create(ls_sub_dir)
   DEFINE   ls_sub_dir     LIKE gbk_file.gbk01
 
   DEFINE   ls_gaz03       LIKE gaz_file.gaz03
 
   DEFINE   lr_gbk         DYNAMIC ARRAY OF RECORD
               gbk03       LIKE gbk_file.gbk03,
               gbk02       LIKE gbk_file.gbk02,
               gbk05       LIKE gbk_file.gbk05,
               gbk06       LIKE gbk_file.gbk06
                           END RECORD
   DEFINE   ls_clear       LIKE type_file.chr1   #No.FUN-680135 VARCHAR(1)
 
   DEFINE   li_i           LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   li_j           LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   li_cnt         LIKE type_file.num10, #No.FUN-680135 INTEGER
            li_cnt2        LIKE type_file.num10  #No.FUN-680135 INTEGER
 
   DEFINE   lwin_curr      ui.Window,
            lfrm_curr      ui.Form
 
   DEFINE   lnode_win      om.DomNode
   DEFINE   lnode_gp02     om.DomNode
   DEFINE   lnode_gd02     om.DomNode
   DEFINE   lnode_gd02_o   om.DomNode
   DEFINE   lnode_gp03     om.DomNode
   DEFINE   lnode_gd03     om.DomNode
   DEFINE   lnode_btn      om.DomNode
   DEFINE   lnode_lab      om.DomNode
   DEFINE   lnode_item     om.DomNode
   DEFINE   ls_item_name   STRING
 
   DEFINE   li_posY        LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   ls_count       LIKE type_file.num5   #No.FUN-680135 SMALLINT
 
   DEFINE   lc_gbk06       LIKE gbk_file.gbk06
   DEFINE   lc_zz03        LIKE zz_file.zz03
   DEFINE   ls_prog_name   STRING
   DEFINE   ls_imgstr      STRING
   DEFINE   ls_node_name   STRING
   DEFINE   ls_sql         STRING
 
 
   LET ls_clear = ""
 
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_win = lwin_curr.getNode()
   LET lnode_gp02 = lwin_curr.findNode("Group","gp_flow02")
   LET lnode_gd02 = lnode_gp02.getFirstChild()
   LET lnode_gp03 = lwin_curr.findNode("Group","gp_flow03")
   LET lnode_gd03 = lnode_gp03.getFirstChild()
 
 
   # 若為主目錄則清除第二、三層目錄節點, 若為其他則刪除第三層節點
   SELECT COUNT(*) INTO li_cnt FROM gbk_file
    WHERE gbk01 = ms_flow_class AND gbk03 = ls_sub_dir AND gbk04 = g_lang
   IF li_cnt > 0 THEN
      LET ls_clear = "2"
   ELSE
      LET ls_clear = "3"
   END IF
 
   # 判斷目前在第幾層要clear哪幾層
   CASE ls_clear
      WHEN "2"
         IF (lnode_gp02.getChildCount() > 0) THEN
            CALL lnode_gp02.removeChild(lnode_gd02)
            LET lnode_gd02 = lnode_gp02.createChild("Grid")
         END IF
         IF (lnode_gp03.getChildCount() > 0) THEN
            CALL lnode_gp03.removeChild(lnode_gd03)
            LET lnode_gd03 = lnode_gp03.createChild("Grid")
         END IF
      WHEN "3"
         IF (lnode_gp03.getChildCount() > 0) THEN
            CALL lnode_gp03.removeChild(lnode_gd03)
            LET lnode_gd03 = lnode_gp03.createChild("Grid")
         END IF
      OTHERWISE
         MESSAGE "Directory structure error!"
   END CASE
   # 2004/05/20 by saki : 將button名稱全改為抓gbk05
   DECLARE lcurs_stack CURSOR FOR
                       SELECT UNIQUE gbk03,gbk02,gbk05,gbk06 FROM gbk_file
                        WHERE gbk01 = ls_sub_dir AND gbk04 = g_lang
                        ORDER BY gbk02
 
   LET li_i = 1
   FOREACH lcurs_stack INTO lr_gbk[li_i].*
      IF STATUS THEN
         EXIT FOREACH
      END IF
 
      LET li_i = li_i + 1
   END FOREACH
   CALL lr_gbk.deleteElement(li_i)
 
#  LET li_posY = 1   #No.FUN-670045
   LET li_posY = 0
 
   FOR li_j = 1 TO lr_gbk.getLength()
 
      SELECT COUNT(*) INTO ls_count FROM gbk_file
       WHERE gbk01 = lr_gbk[li_j].gbk03 AND gbk04 = g_lang
      IF (ls_count <= 0) THEN
         # 表示此節點以下沒有子節點(可能是分類點或是程式點)
         # 判斷是不是程式名稱
 
         SELECT COUNT(*) INTO li_cnt2 FROM gaz_file,zz_file
          WHERE gaz01 = lr_gbk[li_j].gbk03 AND gaz01 = zz01
         IF li_cnt2 > 0 THEN         # 程式點
 
            # 2004/05/14 by saki : 本來以p_zz的程式類別去分類，先改成以程式代碼第四碼作分別
            SELECT zz03 INTO lc_zz03 FROM zz_file
             WHERE zz01 = lr_gbk[li_j].gbk03
            LET ls_prog_name = lr_gbk[li_j].gbk03
            IF ls_prog_name.subString(1,1) != 'a' AND
               ls_prog_name.subString(1,1) != 'g' THEN
               LET lc_zz03 = 'i'
            ELSE
               LET lc_zz03 = ls_prog_name.subString(4,4)
            END IF
 
            # 確定程式資料無誤, 做最後一層button
            LET lnode_btn = lnode_gd03.createChild("Button")
            CALL lnode_btn.setAttribute("name",lr_gbk[li_j].gbk03 CLIPPED)
            CALL lnode_btn.setAttribute("text","   " || lr_gbk[li_j].gbk05 CLIPPED || "   ")
            CALL lnode_btn.setAttribute("gridWidth",20)
#           LET li_posY = li_posY + 30  #No.FUN-670045
            LET li_posY = li_posY + 1
            CALL lnode_btn.setAttribute("posY",li_posY)
            IF lr_gbk[li_j].gbk06 IS NOT NULL THEN
               CALL lnode_btn.setAttribute("comment",lr_gbk[li_j].gbk06 CLIPPED)
            END IF
 
            LET ms_pic_url = FGL_GETENV("FGLASIP")
            CASE 
               WHEN (lc_zz03 = "I") OR (lc_zz03 = "i")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/I.png"
               WHEN (lc_zz03 = "T") OR (lc_zz03 = "t")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/T.png"
               WHEN (lc_zz03 = "P") OR (lc_zz03 = "p")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/P.png"
               WHEN (lc_zz03 = "R") OR (lc_zz03 = "r")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/R.png"
               WHEN (lc_zz03 = "Q") OR (lc_zz03 = "q")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/Q.png"
               WHEN (lc_zz03 = "S") OR (lc_zz03 = "s")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/S.png"
               WHEN (lc_zz03 = "U") OR (lc_zz03 = "u")
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/U.png"
               OTHERWISE
                  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/T.png"
            END CASE
            CALL lnode_btn.setAttribute("image",ls_imgstr CLIPPED)
 
            # 確認先前沒有置換過button的話, 將替換名存入 btn array
            CALL udmtree_flow_check_button_num(lr_gbk[li_j].gbk03 CLIPPED)
 
            # 流程線製作
#           LET li_posY = li_posY + 30  #No.FUN-670045
            LET li_posY = li_posY + 1
            LET lnode_lab = lnode_gd03.createChild("Label")
            CALL lnode_lab.setAttribute("text","|")
            CALL lnode_lab.setAttribute("posX",9)
            CALL lnode_lab.setAttribute("posY",li_posY)
            CONTINUE FOR
         ELSE                           # 流程中的敘述點或是沒有子節點的分類點
            LET ls_node_name = lr_gbk[li_j].gbk03
            IF ls_node_name.subString(1,5) = 'dummy' THEN       # 敘述點
               LET lnode_btn = lnode_gd03.createChild("Button")
               CALL lnode_btn.setAttribute("name",lr_gbk[li_j].gbk03 CLIPPED)
               CALL lnode_btn.setAttribute("text","   " || lr_gbk[li_j].gbk05 CLIPPED || "   ")
               CALL lnode_btn.setAttribute("gridWidth",20) 
#              LET li_posY = li_posY + 30  #No.FUN-670045
               LET li_posY = li_posY + 1
               CALL lnode_btn.setAttribute("posY",li_posY)
               IF lr_gbk[li_j].gbk06 IS NOT NULL THEN
                  CALL lnode_btn.setAttribute("comment",lr_gbk[li_j].gbk06 CLIPPED)
               END IF
 
               # 流程線製作
#              LET li_posY = li_posY + 30    #No.FUN-670045
               LET li_posY = li_posY + 1
               LET lnode_lab = lnode_gd03.createChild("Label")
               CALL lnode_lab.setAttribute("text","|")
               CALL lnode_lab.setAttribute("posX",9)
               CALL lnode_lab.setAttribute("posY",li_posY)
               CONTINUE FOR
            ELSE                                 # 沒有子節點的節點
                IF ls_clear = "2" THEN            #No.MOD-560232
                  LET lnode_btn = lnode_gd02.createChild("Button")
                  CALL lnode_btn.setAttribute("name",lr_gbk[li_j].gbk03 CLIPPED)
                  CALL lnode_btn.setAttribute("text","   " || lr_gbk[li_j].gbk05 CLIPPED || "   ")
                  CALL lnode_btn.setAttribute("gridWidth",20) 
#                 LET li_posY = li_posY + 30   #No.FUN-670045
                  LET li_posY = li_posY + 1
                  CALL lnode_btn.setAttribute("posY",li_posY)
               END IF
            END IF
         END IF
      ELSE
         # 做自己這層的button
         LET lnode_btn = lnode_gd02.createChild("Button")
         CALL lnode_btn.setAttribute("name",lr_gbk[li_j].gbk03 CLIPPED)
         CALL lnode_btn.setAttribute("text","   " || lr_gbk[li_j].gbk05 CLIPPED || "   ")
         CALL lnode_btn.setAttribute("gridWidth",20) 
#        LET li_posY = li_posY + 30  #No.FUN-670045
         LET li_posY = li_posY + 1
         CALL lnode_btn.setAttribute("posY",li_posY)
 
         # 確認先前沒有置換過button的話, 將替換名存入 btn array
         CALL udmtree_flow_check_button_num(lr_gbk[li_j].gbk03 CLIPPED)
      END IF
   END FOR
 
   # 最後若是流程線必須刪除
   IF (lnode_gd03.getChildCount() > 0) THEN
      LET lnode_item = lnode_gd03.getLastChild()
      LET ls_item_name = lnode_item.getTagName()
      IF (ls_item_name.equals("Label")) THEN
         CALL lnode_gd03.removeChild(lnode_item)
      END IF
   END IF
END FUNCTION
 
##################################################
# Description   : 將要替換btn的值存入暫存array
# Date & Author : 2004/05/06 by saki
# Parameter     : ps_chg_name  替換的name
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION udmtree_flow_check_button_num(ps_chg_name)
   DEFINE   ps_chg_name  STRING
 
   DEFINE   ls_btn_name  STRING
   DEFINE   ls_str_chg   STRING
   DEFINE   li_i         LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   ls_add_flag  LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   li_btn_num   LIKE type_file.num10  #No.FUN-680135 INTEGER
 
 
   LET ls_add_flag = TRUE
   FOR li_i = 1 TO mr_btn.getLength()
       IF mr_btn[li_i].chg_name = ps_chg_name THEN
          LET ls_add_flag = FALSE
          EXIT FOR
       END IF
   END FOR
 
   IF ls_add_flag THEN
      IF mr_btn[1].btn_name IS NULL THEN
         LET li_btn_num = 1
         LET ls_str_chg = "1"
      ELSE
         LET li_btn_num = mr_btn.getLength() + 1
         LET ls_str_chg = mr_btn.getLength() + 1
      END IF
      LET ls_btn_name = "btn",ls_str_chg.trim()
      LET mr_btn[li_btn_num].btn_name = ls_btn_name
      LET mr_btn[li_btn_num].chg_name = ps_chg_name
   END IF
 
END FUNCTION
 
##################################################
# Description   : button name 替換
# Date & Author : 2004/05/06 by saki
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION udmtree_flow_btn_change()
   DEFINE   li_i           LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   li_j           LIKE type_file.num10  #No.FUN-680135 INTEGER
 
   DEFINE   lnode_root     om.DomNode
   DEFINE   llst_items     om.NodeList
   DEFINE   lnode_item     om.DomNode
   DEFINE   ls_item_name   STRING
 
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_items = lnode_root.selectByTagName("Action")
 
   FOR li_i = 1 TO mr_btn.getLength()
       FOR li_j = 1 TO llst_items.getLength()
           LET lnode_item = llst_items.item(li_j)
           LET ls_item_name = lnode_item.getAttribute("name")
           IF (ls_item_name.equals(mr_btn[li_i].btn_name)) THEN
                CALL lnode_item.setAttribute("name",mr_btn[li_i].chg_name CLIPPED)
                EXIT FOR
           END IF
       END FOR
   END FOR
END FUNCTION
 
##################################################
# Description   : 尋找Action名稱, 並判斷是不是程式名稱(最後一層)
# Date & Author : 2004/05/06 by saki
# Parameter     : ps_btn_name  節點名稱
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION udmtree_flow_check_act_name(ps_btn_name)
   DEFINE   ps_btn_name        LIKE type_file.chr20  #No.FUN-680135 VARCHAR(10)
   DEFINE   ls_dir_name        LIKE gbk_file.gbk03   #No.FUN-680135 VARCHAR(30) #No.FUN-610052
   DEFINE   li_dir_layer       LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   li_i               LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   li_cnt             LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   li_cnt2            LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   ls_cmd_line        STRING                #MOD-AC0022
   DEFINE   lc_zz15            LIKE zz_file.zz15     #MOD-AC0022
 
   LET ls_dir_name = ""
   LET li_dir_layer = ""
 
   FOR li_i = 1 TO mr_btn.getLength()
       IF mr_btn[li_i].btn_name = ps_btn_name THEN
          LET ls_dir_name = mr_btn[li_i].chg_name
          EXIT FOR
       END IF
   END FOR
 
   # 判斷是不是程式名稱
   SELECT COUNT(*) INTO li_cnt FROM gaz_file,zz_file
    WHERE gaz01 = ls_dir_name AND gaz01 = zz01
   IF li_cnt > 0 THEN
     #CALL cl_cmdrun(ls_dir_name CLIPPED) #MOD-AC0022 mark
     #-MOD-AC0022-add-
      SELECT zz15 INTO lc_zz15 FROM zz_file
       WHERE zz01 = ls_dir_name 
      IF lc_zz15 = "Y" THEN
         IF ls_dir_name = 'aglt110' OR ls_dir_name = 'aglt130' THEN
            LET ls_cmd_line = ls_dir_name," '' '",g_bookno,"' ''"
         ELSE
            LET ls_cmd_line = ls_dir_name," ",g_bookno	
         END IF
      ELSE
         LET ls_cmd_line = ls_dir_name	
      END IF
      CALL cl_cmdrun(ls_cmd_line)
     #-MOD-AC0022-end-
      LET ls_dir_name = "cmdrun"
      LET li_dir_layer = 3
   END IF
 
   SELECT COUNT(*) INTO li_cnt2 FROM gbk_file
    WHERE gbk01 = ms_flow_class AND gbk03 = ls_dir_name
   IF li_cnt2 > 0 THEN
      LET li_dir_layer = 1
   END IF
 
   IF li_dir_layer IS NULL THEN
      LET li_dir_layer = 2
   END IF
 
   RETURN ls_dir_name,li_dir_layer
END FUNCTION
 
##################################################
# Description   : 待辦事項功能
# Date & Author : 2004/05/25 by saki
# Parameter     : 
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION udmtree_needproc()
   DEFINE   li_result       LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
   DEFINE   ls_remain_sec   LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
   DEFINE   ls_msg_cnt      LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
   DEFINE   ls_prog         STRING                #No.TQC-660096
   DEFINE   lc_zz15         LIKE zz_file.zz15     #No.TQC-660096
 
   WHILE TRUE
      LET g_action_choice = " "
 
      # 因為此支程式特殊會產生兩個dialog,所以無法完全鎖上accept,在此自己上鎖
      CALL udmtree_set_act_visible("accept",FALSE)
      DISPLAY ARRAY g_gah TO s_gah.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()   #FUN-550037(smin)
            EXIT DISPLAY
 
         ON ACTION exit                   # Esc.結束
            CALL udmtree_exit_confirm()                    #No.FUN-5B0054
 
         ON ACTION cancel
            LET INT_FLAG=FALSE
            CALL udmtree_exit_confirm()                    #No.FUN-5B0054
 
         ON ACTION controlp
            CALL cl_cmdrun_wait('aoos901 continue')        #No.TQC-6A0036
            CALL azz_set_win_title()
            CALL s_udsday()			       	   #MOD-980264
            #CHI-A40003 add --start-- 
            CALL udmtree_needproc_b_fill()
            CALL udmtree_needproc()
            LET g_action_choice = "exit" 
            #CHI-A40003 ad --end--
            EXIT DISPLAY
 
         ON ACTION accept
            LET l_ac = ARR_CURR()
            LET g_action_choice = "execute"
            #No.TQC-660096 --start--
            LET ls_prog = g_gah[l_ac].gah07
            IF ls_prog.getIndexOf(" ",1) <= 0 THEN
               SELECT zz15 INTO lc_zz15 FROM zz_file
                WHERE zz01 = g_gah[l_ac].gah07
               IF lc_zz15 = "Y" THEN
                  IF cl_null(g_bookno) THEN
                     LET ls_prog = ls_prog," ''"
                  ELSE
                    #-MOD-AC0022-add-
                     IF ls_prog <> 'aglt110' AND ls_prog <> 'aglt130' THEN
                        LET ls_prog = ls_prog," ",g_bookno
                     END IF
                    #-MOD-AC0022-end-
                  END IF
               END IF
            END IF
            #No.TQC-660096 ---end---
            #No.FUN-4A0081 --start--
            CASE g_gah[l_ac].gah11
               WHEN "1"
                 #-MOD-AC0022-add-
                  IF (ls_prog = 'aglt110' OR ls_prog = 'aglt130') AND NOT cl_null(g_bookno) THEN
                     CALL cl_cmdrun(ls_prog || " " || g_gah[l_ac].gah05 || " " || g_bookno || " query")   
                  ELSE
                     CALL cl_cmdrun(ls_prog || " " || g_gah[l_ac].gah05 || " query")   #No:TQC-660096
                  END IF
                 #-MOD-AC0022-end-
               WHEN "2"
                 #-MOD-AC0022-add-
                  IF (ls_prog = 'aglt110' OR ls_prog = 'aglt130') AND NOT cl_null(g_bookno) THEN
                     CALL cl_cmdrun(ls_prog || " " || g_gah[l_ac].gah05 || " " || g_bookno || " insert")   
                  ELSE
                     CALL cl_cmdrun(ls_prog || " " || g_gah[l_ac].gah05 || " insert")  #No:TQC-660096
                  END IF
                 #-MOD-AC0022-end-
               OTHERWISE
                 #-MOD-AC0022-add-
                  IF (ls_prog = 'aglt110' OR ls_prog = 'aglt130') AND NOT cl_null(g_bookno) THEN
                     CALL cl_cmdrun(ls_prog || " " || g_gah[l_ac].gah05 || " " || g_bookno )   
                  ELSE
                     CALL cl_cmdrun(ls_prog || " " || g_gah[l_ac].gah05)   #No:TQC-660096
                  END IF
                 #-MOD-AC0022-end-
            END CASE
            #No.FUN-4A0081 ---end---
            CALL udmtree_needproc_change()
  
         ON ACTION execute
            LET l_ac = ARR_CURR()
            LET g_action_choice = "execute"
           #-MOD-AC0022-add-
            LET ls_prog = g_gah[l_ac].gah07
            IF ls_prog.getIndexOf(" ",1) <= 0 THEN
               SELECT zz15 INTO lc_zz15 FROM zz_file
                WHERE zz01 = g_gah[l_ac].gah07
               IF lc_zz15 = "Y" THEN
                  IF cl_null(g_bookno) THEN
                     LET ls_prog = ls_prog," ''"
                  ELSE
                     IF ls_prog <> 'aglt110' AND ls_prog <> 'aglt130' THEN
                        LET ls_prog = ls_prog," ",g_bookno
                     END IF
                  END IF
               END IF
            END IF
           #-MOD-AC0022-end-
            #No.FUN-4A0081 --start--
            CASE g_gah[l_ac].gah11
               WHEN "1"
                 #CALL cl_cmdrun(g_gah[l_ac].gah07 || " " || g_gah[l_ac].gah05 || " query") #MOD-AC0022 mark
                 #-MOD-AC0022-add-
                  IF (ls_prog = 'aglt110' OR ls_prog = 'aglt130') AND NOT cl_null(g_bookno) THEN
                     CALL cl_cmdrun(ls_prog || " " || g_gah[l_ac].gah05 || " " || g_bookno || " query")   
                  ELSE
                     CALL cl_cmdrun(ls_prog || " " || g_gah[l_ac].gah05 || " query")  
                  END IF
                 #-MOD-AC0022-end-
               WHEN "2"
                 #CALL cl_cmdrun(g_gah[l_ac].gah07 || " " || g_gah[l_ac].gah05 || " insert") #MOD-AC0022 mark
                 #-MOD-AC0022-add-
                  IF (ls_prog = 'aglt110' OR ls_prog = 'aglt130') AND NOT cl_null(g_bookno) THEN
                     CALL cl_cmdrun(ls_prog || " " || g_gah[l_ac].gah05 || " " || g_bookno || " insert")   
                  ELSE
                     CALL cl_cmdrun(ls_prog || " " || g_gah[l_ac].gah05 || " insert")  
                  END IF
                 #-MOD-AC0022-end-
               OTHERWISE
                 #CALL cl_cmdrun(g_gah[l_ac].gah07 || " " || g_gah[l_ac].gah05) #MOD-AC0022 mark
                 #-MOD-AC0022-add-
                  IF (ls_prog = 'aglt110' OR ls_prog = 'aglt130') AND NOT cl_null(g_bookno) THEN
                     CALL cl_cmdrun(ls_prog || " " || g_gah[l_ac].gah05 || " " || g_bookno )   
                  ELSE
                     CALL cl_cmdrun(ls_prog || " " || g_gah[l_ac].gah05)   
                  END IF
                 #-MOD-AC0022-end-
            END CASE
            #No.FUN-4A0081 ---end---
            CALL udmtree_needproc_change()
 
         ON ACTION change_mode
            LET l_ac = ARR_CURR()
            LET g_action_choice = "change_mode"
            CALL udmtree_needproc_change()       #No.FUN-4A0081
 
         ON ACTION view_log
            CALL udmtree_needproc_view_log_b_fill("1=1")
            CALL udmtree_needproc_view_log()
            LET g_action_choice = ""
 
         ON ACTION info
            LET g_action_choice = "exit"
            EXIT DISPLAY
 
         ON ACTION system_flow
            LET g_action_choice = "exit"
            EXIT DISPLAY
 
         ON ACTION so_flow
            LET g_action_choice = "exit"
            EXIT DISPLAY

        #FUN-880099---start--- 解開此段ON ACTION 的mark
        #-----------------No:MOD-A60001 add
        ON ACTION easyflowgp
           CALL cl_set_comp_visible("easyflow",FALSE)
           CALL udmtree_ef_action()
           LET g_action_choice = "exit"
           EXIT DISPLAY
        #-----------------No:MOD-A60001 end
        #FUN-880099---end---

         ON ACTION easyflow                    #FUN-580011
            #TQC-5B0218
            LET g_curr_page = 1
            LET g_total_page = 1
            IF g_aza.aza23 matches '[ Nn]' THEN   #未設定與 EasyFlow 簽核
                  LET g_status = 0
                  CALL cl_set_act_visible("go,selectbox,efrefresh",FALSE)
                  CALL cl_err('aza23','mfg3551',1)
            ELSE
                IF (NOT g_status) OR g_status IS NULL THEN
                  LET g_forminfo = "Inbox"
                  LET g_strfilter = "ALL"
                  LET g_intfilter = "2"
                  CALL aws_efapp_formID() RETURNING g_status
                  CALL cl_set_comp_visible("ef01,ef02,ef03,ef04,ef05,ef15,ef16,ef17,ef18",FALSE)
                END IF
                CALL udmtree_efmenu()
            END IF
            #END TQC-5B0218
            LET g_action_choice = "exit"
            EXIT DISPLAY
 
         #No.FUN-570225 --start--
         ON ACTION search
            CALL udmtree_search()
            LET g_action_choice = "exit"
            EXIT DISPLAY
         #No.FUN-570225 ---end---
 
         #No.FUN-570271 --start--
         ON IDLE ms_msg_sec
            SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
             WHERE gar02 = g_user AND gar06 = 'N'
            IF ls_msg_cnt > 0 THEN
               CALL user_getprocess() RETURNING li_result
               IF NOT li_result THEN
                  CALL cl_cmdrun('p_load_msg')
               END IF
            END IF
            IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
               CALL udmtree_detect_process() RETURNING li_result
               IF (NOT li_result) THEN
                  LET ms_idle_sec = ms_idle_sec + ms_msg_sec
                  LET ls_remain_sec = g_idle_seconds - ms_idle_sec
                  IF ls_remain_sec < ms_msg_sec THEN
                     LET ms_msg_sec = ls_remain_sec
                  END IF
                  IF ms_idle_sec = g_idle_seconds THEN
                     LET ms_idle_sec = 0
                     LET ls_remain_sec = 0
                    #-CHI-980033-add-
                     IF g_idle_seconds < 3 THEN
                        LET ms_msg_sec = g_idle_seconds
                     ELSE
                        LET ms_msg_sec = g_idle_seconds / 3
                     END IF
                    #-CHI-980033-end-
                     IF ms_msg_sec > 180 THEN
                        LET ms_msg_sec = 180
                     END IF
                     CALL cl_on_idle()
                     CONTINUE DISPLAY
                  END IF
               END IF
            END IF
         #No.FUN-570271 ---end---
 
         #No.FUN-BA0079 ---start---
         ON ACTION cascade_chart
            CALL udm_tree_cascade_chart()
            LET g_action_choice = "exit"
            EXIT DISPLAY

         ON ACTION custom_chart
            CALL udm_tree_custom_chart()
            LET g_action_choice = "exit"
            EXIT DISPLAY
         #No.FUN-BA0079 ---end---


          ON ACTION controlg  #MOD-510103
            CALL cl_cmdask()
 
          ON ACTION about     #MOD-510103
            CALL cl_about()
 
          ON ACTION help      # H.說明 MOD-510103
            CALL cl_show_help()
 
       END DISPLAY
       CALL udmtree_set_act_visible("accept",TRUE)
       IF g_action_choice = "exit" THEN
          EXIT WHILE
       END IF
   END WHILE
END FUNCTION
 
FUNCTION udmtree_needproc_change()
 
   UPDATE gah_file SET gah09=TODAY WHERE gah01=g_gah[l_ac].gah01
 
   #-- No.FUN-6B0036 BEGIN -----------------------------------------------------
   # 呼叫 Product Portal 完成代辦事項結案
   #----------------------------------------------------------------------------
   CALL cl_ppcli_CloseToDoList(g_gah[l_ac].gah01 CLIPPED)
   #-- No.FUN-6B0036 END
 
   CALL udmtree_needproc_b_fill()
 
END FUNCTION
 
FUNCTION udmtree_needproc_b_fill() 
 
   #No:FUN-A40045 以下SQL語法因gah02加上';'字元符號以利g_user在MATCHES正確性判斷之調整----start
   # gah09 is null 未完成
   #LET g_sql = "SELECT gah03,gah08,gah01,gah04,gah05,gah06,gah07,gah11 ",  #No.FUN-4A0081
   #             " FROM gah_file",
   #            " WHERE gah02 MATCHES '*",g_user CLIPPED,"*'",
   #              " AND gah09 IS NULL ",
   #            " ORDER BY gah08 DESC, gah01"
               
   LET g_sql = "SELECT gah03,gah08,gah01,gah04,gah05,gah06,gah07,gah11 ",
               " FROM gah_file ",
               " WHERE (trim(gah02) || ';') MATCHES '*",g_user CLIPPED,";*'",
               "   AND gah09 IS NULL ",
               " ORDER BY gah08 DESC, gah01"
   #No:FUN-A40045 end----------------------------------------------------------------
 
   PREPARE udmtree_needproc_gah_pb FROM g_sql
   DECLARE gah_curs CURSOR FOR udmtree_needproc_gah_pb
 
   CALL g_gah.clear()
 
   LET g_cnt = 1
 
   MESSAGE "Searching!" 
 
   FOREACH gah_curs INTO g_gah[g_cnt].*
       IF SQLCA.SQLCODE THEN
          CALL cl_err('foreach:',SQLCA.SQLCODE,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
 
       IF g_cnt > g_max_rec THEN
           CALL cl_err('',9035,0)
           EXIT FOREACH
       END IF
   END FOREACH
 
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO cnt
   LET g_cnt=0
END FUNCTION
 
FUNCTION udmtree_needproc_view_log_b_fill(p_wc)
   DEFINE   p_wc   STRING
 
   IF cl_null(p_wc) THEN
      LET p_wc = "1=1"
   END IF
 
   # gah09 is not null 完成
   LET g_sql = "SELECT gah03,gah09,gah01,gah04,gah05,gah06,gah07,gah11 ", 
               "  FROM gah_file",
               " WHERE gah02 MATCHES '*",g_user CLIPPED,"*'",
               "   AND gah09 IS NOT NULL ",
               "   AND ",p_wc,
               " ORDER BY gah09 DESC, gah01"
 
   PREPARE udmtree_needproc_gdn_pb FROM g_sql
   DECLARE gdn_curs CURSOR FOR udmtree_needproc_gdn_pb
 
   CALL g_gdn.clear()
 
   LET g_cnt_dn = 1
 
   MESSAGE "Searching!" 
 
   FOREACH gdn_curs INTO g_gdn[g_cnt_dn].*
       IF SQLCA.SQLCODE THEN
          CALL cl_err('foreach:',SQLCA.SQLCODE,1)
          EXIT FOREACH
       END IF
       LET g_cnt_dn = g_cnt_dn + 1
 
       IF g_cnt_dn > g_max_rec THEN
           CALL cl_err('',9035,0)
           EXIT FOREACH
       END IF
   END FOREACH
 
   MESSAGE ""
 
   LET g_rec_b_dn = g_cnt_dn-1
   DISPLAY g_rec_b_dn TO cn2
   LET g_cnt_dn=0
 
END FUNCTION
 
FUNCTION udmtree_needproc_view_log()
   DEFINE   li_result       LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
   DEFINE   ls_remain_sec   LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
   DEFINE   ls_msg_cnt      LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
 
   OPEN WINDOW needproc_log_w WITH FORM "azz/42f/p_needproc_log"
                          ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_locale("p_needproc_log")
 
   WHILE TRUE
      CALL cl_set_act_visible("accept,cancel",FALSE)
      DISPLAY ARRAY g_gdn TO s_gdn.* ATTRIBUTE(COUNT=g_rec_b_dn,UNBUFFERED)
         BEFORE ROW
            LET l_ac = ARR_CURR()
 
         ON ACTION query
            LET g_action_choice = "query"
            EXIT DISPLAY
 
         ON ACTION delete
            LET g_action_choice = "delete"
            IF cl_delete() THEN
               DELETE FROM gah_file WHERE gah01 = g_gdn[l_ac].gah01_dn
               IF SQLCA.sqlcode THEN
                  #CALL cl_err(g_gah[l_ac].gah01,SQLCA.sqlcode,0)  #No.FUN-660081
                  CALL cl_err3("del","gah_file",g_gdn[l_ac].gah01_dn,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
               END IF
            END IF
            CALL udmtree_needproc_view_log_b_fill(g_wc)
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()   #FUN-550037(smin)
            EXIT DISPLAY
 
         #No.FUN-570271 --start--
         ON IDLE ms_msg_sec
            SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
             WHERE gar02 = g_user AND gar06 = 'N'
            IF ls_msg_cnt > 0 THEN
               CALL user_getprocess() RETURNING li_result
               IF NOT li_result THEN
                  CALL cl_cmdrun('p_load_msg')
               END IF
            END IF
            IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN  #No.FUN-590112
               CALL udmtree_detect_process() RETURNING li_result
               IF (NOT li_result) THEN
                  LET ms_idle_sec = ms_idle_sec + ms_msg_sec
                  LET ls_remain_sec = g_idle_seconds - ms_idle_sec
                  IF ls_remain_sec < ms_msg_sec THEN
                     LET ms_msg_sec = ls_remain_sec
                  END IF
                  IF ms_idle_sec = g_idle_seconds THEN
                     LET ms_idle_sec = 0
                     LET ls_remain_sec = 0
                    #-CHI-980033-add-
                     IF g_idle_seconds < 3 THEN
                        LET ms_msg_sec = g_idle_seconds
                     ELSE
                        LET ms_msg_sec = g_idle_seconds / 3
                     END IF
                    #-CHI-980033-end-
                     IF ms_msg_sec > 180 THEN
                        LET ms_msg_sec = 180
                     END IF
                     CALL cl_on_idle()
                     CONTINUE DISPLAY
                  END IF
               END IF
            END IF
         #No.FUN-570271 ---end---
 
         ON ACTION controlg 
            CALL cl_cmdask()
 
          ON ACTION help      # H.說明 MOD-510103
            CALL cl_show_help()
 
          ON ACTION about     #MOD-510103
            CALL cl_about()
 
         ON ACTION exit                   # Esc.結束
            LET g_action_choice = "exit"
            EXIT DISPLAY
 
         #No.FUN-570271 --start--
         ON ACTION cancel
            LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT DISPLAY
         #No.FUN-570271 ---end---
 
      END DISPLAY
      CALL cl_set_act_visible("accept,cancel",TRUE)
      
      CASE g_action_choice
         WHEN "exit"
            EXIT WHILE
         WHEN "query"
            CALL view_log_query()
      END CASE
   END WHILE
 
   CLOSE WINDOW needproc_log_w
END FUNCTION
 
FUNCTION view_log_query()
   DEFINE   li_result       LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
   DEFINE   ls_remain_sec   LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
   DEFINE   ls_msg_cnt      LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
 
 
   CONSTRUCT g_wc ON gah03,gah09,gah01,gah04,gah05,gah06,gah07,gah11
                FROM s_gdn[1].gah03_dn,s_gdn[1].gah09_dn,s_gdn[1].gah01_dn,
                     s_gdn[1].gah04_dn,s_gdn[1].gah05_dn,s_gdn[1].gah06_dn,
                     s_gdn[1].gah07_dn,s_gdn[1].gah11_dn     #No.FUN-4A0081
 
      #No.FUN-570271 --start--
      ON IDLE ms_msg_sec
         SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
          WHERE gar02 = g_user AND gar06 = 'N'
         IF ls_msg_cnt > 0 THEN
            CALL user_getprocess() RETURNING li_result
            IF NOT li_result THEN
               CALL cl_cmdrun('p_load_msg')
            END IF
         END IF
         IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
            CALL udmtree_detect_process() RETURNING li_result
            IF (NOT li_result) THEN
               LET ms_idle_sec = ms_idle_sec + ms_msg_sec
               LET ls_remain_sec = g_idle_seconds - ms_idle_sec
               IF ls_remain_sec < ms_msg_sec THEN
                  LET ms_msg_sec = ls_remain_sec
               END IF
               IF ms_idle_sec = g_idle_seconds THEN
                  LET ms_idle_sec = 0
                  LET ls_remain_sec = 0
                 #-CHI-980033-add-
                  IF g_idle_seconds < 3 THEN
                     LET ms_msg_sec = g_idle_seconds
                  ELSE
                     LET ms_msg_sec = g_idle_seconds / 3
                  END IF
                 #-CHI-980033-end-
                  IF ms_msg_sec > 180 THEN
                     LET ms_msg_sec = 180
                  END IF
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
               END IF
            END IF
         END IF
      #No.FUN-570271 ---end---
 
          ON ACTION help      #MOD-510103
            CALL cl_show_help()
          ON ACTION controlg  #MOD-510103
            CALL cl_cmdask()
          ON ACTION about     #MOD-510103
            CALL cl_about()
   
   END CONSTRUCT
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
   END IF
 
   CALL udmtree_needproc_view_log_b_fill(g_wc)
END FUNCTION
 
FUNCTION udmtree_set_act_visible(ps_act_names, pi_visible)
   DEFINE   ps_act_names    STRING,
            pi_visible      LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   la_act_type     DYNAMIC ARRAY OF STRING,
            lnode_root      om.DomNode,
            li_i            LIKE type_file.num5,  #No.FUN-680135 SMALLINT
            lst_act_names   base.StringTokenizer,
            ls_act_name     STRING,
            llst_items      om.NodeList,
            li_j            LIKE type_file.num5,  #No.FUN-680135 SMALLINT
            lnode_item      om.DomNode,
            ls_item_name    STRING,
            ls_item_tag     STRING
 
 
   IF (ps_act_names IS NULL) THEN
      RETURN
   ELSE
      LET ps_act_names = ps_act_names.toLowerCase()
   END IF
 
   LET la_act_type[1] = "ActionDefault"
   LET la_act_type[2] = "LocalAction"
   LET la_act_type[3] = "Action"
  
   LET lnode_root = ui.Interface.getRootNode()
 
   FOR li_i = 1 TO la_act_type.getLength()
      LET lst_act_names = base.StringTokenizer.create(ps_act_names, ",")
      WHILE lst_act_names.hasMoreTokens() 
         LET ls_act_name = lst_act_names.nextToken()
         LET ls_act_name = ls_act_name.trim()
         LET llst_items = lnode_root.selectByTagName(la_act_type[li_i])
 
         FOR li_j = 1 TO llst_items.getLength()
            LET lnode_item = llst_items.item(li_j)
            LET ls_item_name = lnode_item.getAttribute("name")
            IF (ls_item_name IS NULL) THEN
               CONTINUE FOR
            END IF
 
            IF (ls_item_name.equals(ls_act_name)) THEN
               IF (pi_visible) THEN
                  IF (li_i = 1) THEN #ActionDefault
                     CALL lnode_item.setAttribute("defaultView", "yes")
                  ELSE
                     CALL lnode_item.setAttribute("defaultView", "yes")
                     CALL lnode_item.setAttribute("hidden", "0")
                     CALL lnode_item.setAttribute("active", "1")
                  END IF
               ELSE
                  IF (li_i = 1) THEN #ActionDefault
                     CALL lnode_item.setAttribute("defaultView", "no")
                  ELSE
                     CALL lnode_item.setAttribute("defaultView", "no")
                     CALL lnode_item.setAttribute("hidden", "1")
                     CALL lnode_item.setAttribute("active", "0")
                  END IF
               END IF
 
               IF (li_i != 3) THEN
                  EXIT FOR
               END IF
            END IF
         END FOR
      END WHILE
   END FOR
END FUNCTION
 
FUNCTION udmtree_notify()
   DEFINE l_ch   base.Channel
 
  
   IF NOT cl_null(g_notify) THEN
      LET l_ch = base.Channel.create()
      CALL l_ch.openFile(g_notify, "w")
      CALL l_ch.close()
   END IF
END FUNCTION
 
FUNCTION azz_set_win_title()
   DEFINE   lc_zo02     LIKE zo_file.zo02, 
            lc_zx02     LIKE zx_file.zx02, 
            lc_zz02     LIKE zz_file.zz02,
            lc_zz011    LIKE zz_file.zz011,   #NO.MOD-C30123
            ls_ze031    LIKE ze_file.ze03,    #No.FUN-680135 VARCHAR(100)
            ls_ze032    LIKE ze_file.ze03,    #No.FUN-680135 VARCHAR(100)
            ls_msg      STRING 
   DEFINE   lwin_curr   ui.Window
   DEFINE   lc_gbq01    LIKE gbq_file.gbq01   #No.FUN-660135
   DEFINE   lc_gbq10    LIKE gbq_file.gbq10   #No.FUN-660135
   DEFINE   ls_gbq10    STRING                #No.FUN-660135
#MOD-920256 ---add---
   DEFINE   ls_tmp      STRING
   DEFINE   lc_azz05    LIKE azz_file.azz05
   DEFINE   lc_azp052   LIKE azp_file.azp052
#MOD-920256 ---end---
   DEFINE lc_azp02      LIKE azp_file.azp02 #MOD-C30123
 
 
   # 選擇  使用者名稱(zx_file.zx02)
   SELECT zx02,zx08 INTO lc_zx02,g_plant FROM zx_file WHERE zx01=g_user
   IF (SQLCA.SQLCODE) THEN
      LET lc_zx02 = g_user
   END IF

   # 選擇 程式模組(zz_file.zz011),判斷是否為"客製程式"  MOD-C30123 
   SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01=g_prog
   LET ls_ze031=""
   IF lc_zz011[1]="C" THEN
      SELECT ze03 INTO ls_ze031 FROM ze_file
       WHERE ze01 = 'lib-051' AND ze02 = g_lang
   END IF                               

   SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_plant  #FUN-980014 add(抓出該營運中心所屬法人)
 
   SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01=g_plant
   IF (SQLCA.SQLCODE) THEN
      #CALL cl_err("azp_file get error", SQLCA.SQLCODE, 2)  #No.FUN-660081
      CALL cl_err3("sel","azp_file",g_plant,"",SQLCA.sqlcode,"","azp_file get error", 2)  #No.FUN-660081)   #No.FUN-660081
   END IF
 
   CALL cl_ins_del_sid(2,'')   #FUN-990069 
   CLOSE DATABASE
   DATABASE g_dbs
   CALL cl_ins_del_sid(1,g_plant)   #FUN-990069 
   IF (SQLCA.SQLCODE) THEN
      RETURN FALSE
   END IF
 
 #  #MOD-540163
   # 選擇  程式名稱(gaz_file.gaz03)
   CALL cl_get_progname(g_prog,g_lang) RETURNING lc_zz02
#  SELECT gaz03 INTO lc_zz02 FROM gaz_file
#   WHERE gaz01=g_prog AND gaz02=g_lang order by gaz05
 
   # 選擇  公司對內全名(zo_file.zo02)
   SELECT zo02 INTO lc_zo02 FROM zo_file WHERE zo01=g_lang
   IF (SQLCA.SQLCODE) THEN
      LET lc_zo02 = "Empty"
   END IF
 
#  #MOD-840097
#  LET ls_msg = lc_zz02 CLIPPED, "(", g_prog CLIPPED, ")  [", lc_zo02 CLIPPED, "]", "(", g_dbs CLIPPED, ")"

#  MOD-C30123,修正ls_msg    ---start--- 
   SELECT azp02 INTO lc_azp02 FROM azp_file WHERE azp01 = g_plant  
   LET ls_msg = lc_zz02 CLIPPED, "(", g_prog CLIPPED,ls_ze031 CLIPPED, ")[", lc_zo02 CLIPPED, "][",g_plant CLIPPED,":",lc_azp02 CLIPPED, "](", g_dbs CLIPPED, ")"
#  MOD-C30123               ---end---
#  LET ls_msg = ls_msg, "  ", ls_ze031 CLIPPED, ":", g_today, "  ", ls_ze032 CLIPPED, ":", lc_zx02 CLIPPED #MOD-920256 mark
#  LET ls_msg = lc_zz02 CLIPPED || "(" || g_prog CLIPPED || ")  [" || lc_zo02 CLIPPED || "]" || "(" || g_dbs CLIPPED || ")"
#  LET ls_msg = ls_msg || "  " || ls_ze031 CLIPPED || ":" || g_today || "  " || ls_ze032 CLIPPED || ":" || lc_zx02 CLIPPED

   SELECT ze03 INTO ls_ze031 FROM ze_file WHERE ze01 = 'lib-035' AND ze02 = g_lang #日期   MOD-C30123
   SELECT ze03 INTO ls_ze032 FROM ze_file WHERE ze01 = 'lib-036' AND ze02 = g_lang #時間   MOD-C30123
   LET ls_tmp = "  " , ls_ze031 CLIPPED , ":" , g_today CLIPPED  #MOD-920256 add

#MOD-920256 ---add---
     SELECT azz05 INTO lc_azz05 FROM azz_file WHERE azz01 = "0"
     IF lc_azz05 IS NOT NULL AND lc_azz05 = "Y" THEN
       #SELECT azp052 INTO lc_azp052 FROM azp_file WHERE azp03 = g_dbs     #FUN-980020 mark
       #SELECT azp052 INTO lc_azp052 FROM azp_file WHERE azp03 = g_plant   #FUN-980020 #MOD-C30123 mark
       #SELECT azp052 INTO lc_azp052 FROM azp_file WHERE azp03 = g_dbs     #MOD-C30123 add,#MOD-C40107 mark
       SELECT azp052 INTO lc_azp052 FROM azp_file WHERE azp01 = g_plant   #MOD-C40107
        IF NOT SQLCA.SQLCODE THEN
          IF NOT cl_null(lc_azp052) THEN
             LET ls_tmp = ls_tmp.trimRight(),"(",lc_azp052 CLIPPED,")"
          END IF
        END IF
     END IF
 
     LET ls_msg = ls_msg.trim(), ls_tmp.trimRight()

     LET ls_tmp = "  " , ls_ze032 CLIPPED , ":" , lc_zx02 CLIPPED
     LET ls_msg = ls_msg.trim(), ls_tmp.trimRight()
#MOD-920256 ---end---
 
   LET lwin_curr = ui.Window.getCurrent()
   CALL lwin_curr.setText(ls_msg)
 
   #No.FUN-660135 --start--
   LET lc_gbq01 = g_udmtree_pid
   SELECT gbq10 INTO lc_gbq10 FROM gbq_file WHERE gbq01 = lc_gbq01
   LET ls_gbq10 = lc_gbq10 CLIPPED
   LET lc_gbq10 = g_plant CLIPPED,ls_gbq10.subString(ls_gbq10.getIndexOf("/",1),ls_gbq10.getLength())
   UPDATE gbq_file SET gbq10 = lc_gbq10 WHERE gbq01 = lc_gbq01
   #No.FUN-660135 ---end---
 
   #MOD-810155 ---start---
   # 共用模組參數 aza,sma,gas
   SELECT * INTO g_aza.* FROM aza_file WHERE aza01='0'
   IF SQLCA.SQLCODE THEN
      DISPLAY 'Select Parameter file of aza_file Error! Code:',SQLCA.SQLCODE CLIPPED
      DISPLAY 'Contact to System Administrator!'
      RETURN FALSE
   ELSE
      LET g_cuelang=FALSE
   END IF
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   IF SQLCA.SQLCODE THEN
      DISPLAY 'Select Parameter file of sma_file Error! Code:',SQLCA.SQLCODE CLIPPED
      DISPLAY 'Contact to System Administrator!'
      RETURN FALSE
   END IF
   SELECT * INTO g_gas.* FROM gas_file WHERE gas01='0'
   IF SQLCA.SQLCODE THEN
      DISPLAY 'Select Parameter file of gas_file Error! Code:',SQLCA.SQLCODE CLIPPED
      DISPLAY 'Notice to System Administrator! Program Continue..'
   END IF
   #MOD-810155 ---end---
END FUNCTION
 
FUNCTION udmtree_update_startmenu()
   DEFINE   lnode_root     om.DomNode
   DEFINE   lnode_item     om.DomNode
   DEFINE   ls_item_name   STRING
   DEFINE   ls_item_exec   STRING
   DEFINE   ls_zz01        LIKE zz_file.zz01
   DEFINE   ls_zz15        LIKE zz_file.zz15
   DEFINE   llst_sm_cmd    om.NodeList
   DEFINE   li_i           LIKE type_file.num5   #No.FUN-680135 INTEGER
   DEFINE   li_inx         LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   ls_exe_str     STRING
   DEFINE   ls_pam_str     STRING
   DEFINE   ls_bookno_old  STRING
 
 
   IF cl_null(g_bookno) THEN
      RETURN
   END IF
 
   LET lnode_root = ui.Interface.getRootNode()
   LET llst_sm_cmd = lnode_root.selectByTagName("StartMenuCommand")
   FOR li_i = 1 TO llst_sm_cmd.getLength()
       LET lnode_item = llst_sm_cmd.item(li_i)
       LET ls_item_name = lnode_item.getAttribute("name")
       IF (ls_item_name IS NOT NULL) THEN
          LET ls_zz01 = ls_item_name
          SELECT zz15 INTO ls_zz15 FROM zz_file
           WHERE zz01 = ls_zz01
          IF ls_zz15 = "Y" THEN
             LET ls_item_exec = ""
             LET ls_item_exec = lnode_item.getAttribute("exec")
            #LET li_inx = ls_item_exec.getIndexOf("$FGLRUN",1)	#CHI-960079 mark
             LET li_inx = ls_item_exec.getIndexOf("p_go",1)	#CHI-960079
             LET li_inx = ls_item_exec.getIndexOf(" ",li_inx + 8)
             IF li_inx = 0 THEN
                LET ls_exe_str = ls_item_exec
                LET ls_pam_str = ""
             ELSE
                LET ls_exe_str = ls_item_exec.subString(1,li_inx -1)
                LET ls_pam_str = ls_item_exec.subString(li_inx + 1,ls_item_exec.getLength())
             END IF
 
             IF g_bookno_old IS NOT NULL THEN
                LET li_inx = ls_pam_str.getIndexOf(g_bookno_old,1)
                LET ls_bookno_old = g_bookno_old
                LET ls_pam_str = ls_pam_str.subString(li_inx + ls_bookno_old.getLength() + 1,ls_pam_str.getLength())
             END IF
 
            #-MOD-AC0022-add-
             IF ls_zz01 = 'aglt110' OR ls_zz01 = 'aglt130' THEN
                LET ls_item_exec = ls_exe_str," '' ",g_bookno
             ELSE
                LET ls_item_exec = ls_exe_str," ",g_bookno," ",ls_pam_str	
             END IF
            #-MOD-AC0022-end-
             CALL lnode_item.setAttribute("exec",ls_item_exec)
          END IF
       END IF
   END FOR
END FUNCTION
 
#No.FUN-570271 --start--  偵測是否還有其他作業正在執行
#No.MOD-580173 --start--
FUNCTION udmtree_detect_process()
   DEFINE   ls_udmtree_pid      STRING
   #No.TQC-650095 ---mark---
#  DEFINE   ls_udmtree_ip       STRING
#  DEFINE   lr_process          DYNAMIC ARRAY OF RECORD
#              ip               STRING,               #IP
#              pid              STRING                #PID
#                               END RECORD
   #No.TQC-650095 ---mark---
   DEFINE   li_i                LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   li_cnt              LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   ls_cmd              STRING
   DEFINE   lc_channel          base.Channel
   DEFINE   ls_result           STRING
   DEFINE   ls_fglserver        STRING
   DEFINE   li_result           LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   li_j                LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-5B0054
   DEFINE   lc_gbq01            LIKE gbq_file.gbq01   #No.TQC-660107
   DEFINE   lc_gbq04            LIKE gbq_file.gbq04   #No.TQC-660107
   DEFINE   lc_gbq02            LIKE gbq_file.gbq02   #No.FUN-740179
 
 
   LET ls_udmtree_pid = FGL_GETPID()
 
   RUN "fglWrt -u"              #No.MOD-670090
   LET ls_cmd = "fglWrt -a info user 2>&1"
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe(ls_cmd,"r")
   CALL lc_channel.setDelimiter("")
   LET li_i = 1
   CALL g_user_pid.clear()                    #No.TQC-650095
   WHILE lc_channel.read(ls_result)
      LET li_cnt = ls_result.getIndexOf("GUI Server",1)
      IF li_cnt > 0 THEN
         #No.FUN-920138 saki  --start--
         IF ls_result.getIndexOf("Process Id",1) > 0 THEN
            LET ls_fglserver = ls_result.subString(ls_result.getIndexOf("GUI Server",1) + 11,ls_result.getIndexOf("Process Id",1)-4)
         ELSE
         #No.FUN-920138 saki  ---end---
            LET ls_fglserver = ls_result.subString(li_cnt + 11,ls_result.getLength())
            CONTINUE WHILE   #No:EXT-9C0145
         END IF   #No.FUN-920138 saki 
#        CONTINUE WHILE   #No:EXT-9C0145 mark
      END IF
 
      #No.TQC-650095 --start-- 修改只抓自己IP的各process id
      IF NOT g_udmtree_ip.equals(ls_fglserver) THEN
         CONTINUE WHILE
      END IF
      #No.TQC-650095 ---end---
 
      LET li_cnt = ls_result.getIndexOf("Process Id",1)
      IF li_cnt > 0 THEN
         #No.TQC-650095 --start--
         LET g_user_pid[li_i] = ls_result.subString(li_cnt + 11,ls_result.getLength())
         #No.TQC-650095 ---end---
         #No.FUN-740179 --start--
         LET lc_gbq01 = g_user_pid[li_i]
         SELECT gbq02 INTO lc_gbq02 FROM gbq_file WHERE gbq01=lc_gbq01
         IF lc_gbq02 != g_udmtree_gbq02 THEN
            CONTINUE WHILE
         END IF
         #No.FUN-740179 ---end---
         #No.TQC-650095 --mark--
#        LET lr_process[li_i].ip = ls_fglserver
#        LET lr_process[li_i].pid = ls_result.subString(li_cnt + 11,ls_result.getLength())
         #No.FUN-5B0054 --start--
#        IF (lr_process[li_i].pid.equals(ls_udmtree_pid)) THEN
#           LET ls_udmtree_ip = lr_process[li_i].ip
#        END IF
         #No.FUN-5B0054 ---end---
         #No.TQC-650095 --mark--
         LET li_i = li_i + 1
      END IF
   END WHILE
   CALL g_user_pid.deleteElement(li_i)       #No.TQC-650095
   CALL lc_channel.close()
 
   LET li_result = FALSE
#  CALL g_user_pid.clear()                          #No.FUN-5B0054 TQC-650095 mark
#  LET li_j = 1                                     #No.FUN-5B0054 TQC-650095 mark
   FOR li_i = 1 TO g_user_pid.getLength()           #No.TQC-650095 -> g_user_pid就是此使用者所有線上的process
#      IF lr_process[li_i].ip.equals(ls_udmtree_ip) THEN       #No.TQC-650095 mark
       #No.TQC-660107 --mark--start
#      LET ls_cmd = "ps -ef | grep ",g_user_pid[li_i]," | grep -v 'grep' | awk '{for(i=9;i<=NF;i+=1) printf $i}'"  #No.TQC-650095
#      LET lc_channel = base.Channel.create()
#      CALL lc_channel.openPipe(ls_cmd,"r")
#      CALL lc_channel.setDelimiter("")
#      LET ls_result = ""                        #No.MOD-580119
#      WHILE (lc_channel.read(ls_result))
#         LET li_cnt = ls_result.getIndexOf("udm_tree",1)
#         IF li_cnt <= 0 THEN
       #No.TQC-660107 --mark--end
       #No.TQC-660107 --start--
       LET lc_gbq01 = g_user_pid[li_i]
       SELECT gbq04 INTO lc_gbq04 FROM gbq_file WHERE gbq01 = lc_gbq01
       IF NOT cl_null(lc_gbq04) AND lc_gbq04 != "udm_tree" THEN
          LET li_result = TRUE
          EXIT FOR
       END IF
       #No.TQC-660107
#            EXIT WHILE                          #No.TQC-650095  No.TQC-660107 mark
       #No.FUN-5B0054 --start--
#            LET g_user_pid[li_j] = lr_process[li_i].pid       #No.TQC-650095 mark
#            LET li_j = li_j + 1                               #No.TQC-650095 mark
#            EXIT FOR
#         ELSE
#            CONTINUE FOR
       #No.FUN-5B0054 ---end---
       #No.TQC-660107 --mark--start
#         END IF
#      END WHILE
#      IF ls_result IS NULL THEN
#         CONTINUE FOR
#      END IF
#      CALL lc_channel.close()
#      #No.TQC-650095 --start--
#      IF li_result THEN
#         EXIT FOR
#      END IF
#      #No.TQC-650095 ---end---
#      END IF                                                  #No.TQC-650095 mark
       #No.TQC-660107 --mark--end
   END FOR
 
   RETURN li_result
END FUNCTION
#No.MOD-580173 ---end---
#No.FUN-570271 ---end---
 
#No.FUN-580093 --start--
FUNCTION udmtree_online_limit()
   DEFINE   lc_zx01          LIKE zx_file.zx01
   DEFINE   lc_user_zx03     LIKE zx_file.zx03
   DEFINE   lc_other_zx03    LIKE zx_file.zx03
   ###FUN-920138 START ###
   DEFINE   lc_user_zyw01    LIKE zyw_file.zyw01   #部門群組編號(登入者)
   DEFINE   lc_other_zyw01   LIKE zyw_file.zyw01   #部門群組編號(比對)
   DEFINE   lc_gbo02_grup    LIKE gbo_file.gbo02   #是否限制上線人數(部門)
   DEFINE   lc_gbo03_grup    LIKE gbo_file.gbo03   #可上線人數(部門)
   DEFINE   lc_gbo02_tgrup   LIKE gbo_file.gbo02   #是否限制上線人數(部門群組)
   DEFINE   lc_gbo03_tgrup   LIKE gbo_file.gbo03   #可上線人數(部門群組)
   ###FUN-920138 END ###
   #DEFINE   lc_gbo02         LIKE gbo_file.gbo02  #FUN-920138 mark
   DEFINE   lc_gbo03         LIKE gbo_file.gbo03
   DEFINE   ls_cmd           STRING
   DEFINE   lc_channel       base.Channel
   DEFINE   ls_result        STRING
   DEFINE   lr_user          DYNAMIC ARRAY OF STRING
   DEFINE   li_cnt           LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   li_cnt2          LIKE type_file.num10  #同部門群組上線人數   #FUN-920138
   DEFINE   l_chkonline      LIKE type_file.chr1   #上線人數是否合格 Y/N #FUN-920138
   DEFINE   li_i             LIKE type_file.num10  #No.FUN-680135 INTEGER
   DEFINE   li_repeat_flag   LIKE type_file.num5   #No.FUN-680135 SMALLINT
 
   DEFINE   ls_sql           STRING
   DEFINE   lr_gbq           DYNAMIC ARRAY OF RECORD
               gbq02         LIKE gbq_file.gbq02,
               gbq03         LIKE gbq_file.gbq03,
               gbq05         LIKE gbq_file.gbq05,
               gbq10         LIKE gbq_file.gbq10   #No.FUN-7A0086
                             END RECORD
   DEFINE   ls_fglserver     STRING   #-- FUN-690056
   DEFINE   ls_cur_dbs       STRING                #No.FUN-7A0086
 
 
   SELECT zx03 INTO lc_user_zx03 FROM zx_file WHERE zx01 = g_user
   
   ###FUN-920138 START ###
   SELECT zyw01 INTO lc_user_zyw01 FROM zyw_file WHERE zyw03 = lc_user_zx03   #部門群組編號   
   
   #部門-上線設定
   SELECT gbo02,gbo03 INTO lc_gbo02_grup,lc_gbo03_grup FROM gbo_file 
      WHERE gbo01 = lc_user_zx03
        AND gbo04 = "1"
   #部門群組-上線設定
   IF NOT cl_null(lc_user_zyw01) THEN
      SELECT gbo02,gbo03 INTO lc_gbo02_tgrup,lc_gbo03_tgrup FROM gbo_file 
         WHERE gbo01 = lc_user_zyw01
           AND gbo04 = "2"
   END IF
        
   #NULL時給預設值   
   IF cl_null(lc_gbo02_grup) THEN
      LET lc_gbo02_grup = "N"
   END IF
   IF cl_null(lc_gbo03_grup) THEN
      LET lc_gbo03_grup = 0
   END IF
   IF cl_null(lc_gbo02_tgrup) THEN
      LET lc_gbo02_tgrup = "N"
   END IF
   IF cl_null(lc_gbo03_tgrup) THEN
      LET lc_gbo03_tgrup = 0
   END IF
   
   IF ((lc_gbo02_grup = "Y" AND lc_gbo03_grup >=0) OR (lc_gbo02_tgrup = "Y" AND lc_gbo03_tgrup >=0)) THEN
   ###FUN-920138 END ###
   
   #SELECT gbo02,gbo03 INTO lc_gbo02,lc_gbo03 FROM gbo_file WHERE gbo01 = lc_user_zx03   #FUN-920138 mark
   #IF (lc_gbo02 = "Y") AND (lc_gbo03 >= 0) THEN   #No.CHI-770027                        #FUN-920138 mark   
    #-- FUN-690056 begin
    #   抓取目前 process 的 IP
    #--
      LET ls_fglserver = FGL_GETENV("FGLSERVER")
#No.FUN-740179 --mark--   由共用程式處理
#     IF ls_fglserver.getIndexOf("127.0.0.1", 1) > 0 AND FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR") IS NOT NULL THEN
#        LET li_cnt = ls_fglserver.getIndexOf(":", 1)
#        LET ls_fglserver = FGL_GETENV("FGL_WEBSERVER_REMOTE_ADDR"), ls_fglserver.subString(li_cnt, ls_fglserver.getLength())
#     END IF
#     IF ls_fglserver.getIndexOf(":", 1) = 0 THEN
#        LET ls_fglserver = ls_fglserver, ":0"
#     END IF
#No.FUN-740179 --mark--
    #-- FUN-690056 end
      LET ls_fglserver = cl_process_chg_iprec(ls_fglserver)    #No.FUN-740179
      LET ls_sql = "SELECT gbq02,gbq03,gbq05,gbq10 FROM gbq_file ORDER BY gbq03"  #No.FUN-7A0086
      PREPARE gbq_pre FROM ls_sql
      DECLARE gbq_curs CURSOR FOR gbq_pre
      LET li_cnt = 1
      FOREACH gbq_curs INTO lr_gbq[li_cnt].*
         IF SQLCA.sqlcode THEN
            EXIT FOREACH
         END IF
 
       #-- FUN-690056 begin
#         IF (lr_gbq[li_cnt].gbq02 CLIPPED = g_udmtree_ip) THEN
         IF (lr_gbq[li_cnt].gbq02 CLIPPED = ls_fglserver) THEN
            CONTINUE FOREACH
         END IF
       #-- FUN-690056 end
 
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
 
      LET li_cnt = 0         #同部門上線人數
      LET li_cnt2 = 0        #同部門群組上線人數     #FUN-920138
      LET l_chkonline = "N"  #上線人數是否合格 Y/N   #FUN-920138
      FOR li_i = 1 TO lr_gbq.getLength()
          #No.FUN-7A0086 --start--
          LET ls_cur_dbs = lr_gbq[li_i].gbq10
          IF ls_cur_dbs.getIndexOf("/",1) THEN
             LET ls_cur_dbs = ls_cur_dbs.subString(1,ls_cur_dbs.getIndexOf("/",1)-1)
          END IF
          #No.FUN-7A0086 ---end---
          LET lc_other_zx03 = ''	#MOD-970062 
          LET lc_other_zyw01 = ''       #CHI-F20018
          SELECT zx03 INTO lc_other_zx03 FROM zx_file WHERE zx01 = lr_gbq[li_i].gbq03
          SELECT DISTINCT zyw01 INTO lc_other_zyw01 FROM zyw_file WHERE zyw03 = lc_other_zx03   #部門群組編號(比對)  #FUN-920138
          
          #同部門上線人數
          IF lc_other_zx03 = lc_user_zx03 AND ls_cur_dbs = g_plant THEN   #No.FUN-7A0086
             LET li_cnt = li_cnt + 1
          END IF
          
          ###FUN-920138 START ###
          #同部門群組上線人數
          IF lc_other_zyw01 = lc_user_zyw01 AND ls_cur_dbs = g_plant THEN
             LET li_cnt2 = li_cnt2 + 1
          END IF
          ###FUN-920138 END ###
      END FOR
      
      ###FUN-920138 START ###      
      #限制上線人數
      CASE 
         #部門群組
         WHEN lc_gbo02_tgrup = "Y" AND lc_gbo02_grup = "N"
           #IF li_cnt2 < lc_gbo03_tgrup THEN    #MOD-B90137 mark
           #IF li_cnt2 <= lc_gbo03_tgrup THEN   #MOD-B90137    #FUN-F70020 mark
            IF (li_cnt2+1) <= lc_gbo03_tgrup THEN           #FUN-F70020
               LET l_chkonline = "Y"
            END IF 
         #部門
         WHEN lc_gbo02_tgrup = "N" AND lc_gbo02_grup = "Y"
           #IF li_cnt < lc_gbo03_grup THEN    #MOD-B90137 mark
           #IF li_cnt <= lc_gbo03_grup THEN   #MOD-B90137   #FUN-F70020 mark 
            IF (li_cnt+1) <= lc_gbo03_grup THEN             #FUN-F70020
               LET l_chkonline = "Y"
            END IF 
         #部門群組,部門
         WHEN lc_gbo02_tgrup = "Y" AND lc_gbo02_grup = "Y"          
           #IF (li_cnt2 < lc_gbo03_tgrup) AND (li_cnt < lc_gbo03_grup) THEN     #MOD-B90137 mark
           #IF (li_cnt2 <= lc_gbo03_tgrup) AND (li_cnt <= lc_gbo03_grup) THEN   #MOD-B90137  #FUN-F70020 mark 
            IF ((li_cnt2+1) <= lc_gbo03_tgrup) AND ((li_cnt+1) <= lc_gbo03_grup) THEN         #FUN-F70020 
               LET l_chkonline = "Y"
            END IF 
      END CASE
      
      DISPLAY "lc_gbo02_tgrup=",lc_gbo02_tgrup
      DISPLAY "lc_gbo02_grup=",lc_gbo02_grup
      DISPLAY "li_cnt=",li_cnt
      DISPLAY "li_cnt2=",li_cnt2
      DISPLAY "lc_gbo03_grup=",lc_gbo03_grup
      DISPLAY "lc_gbo03_tgrup=",lc_gbo03_tgrup
      ###FUN-920138 END ###
      
     #IF (li_cnt >= lc_gbo03) THEN  #MOD-920213 mark
     #IF (li_cnt > lc_gbo03) THEN  #MOD-920213   #FUN-920138 mark
     #若設定上線人數最多只能2人，則第3人進來看到p_process已經有2人，就不可以再執行程式
      IF l_chkonline = "N" THEN  #FUN-920138
         CALL udmtree_notify()   #-- FUN-690056 通知 weblogin 結束視窗
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-580093  #No.FUN-6A0096
         CALL cl_err("","azz-728",30)
         CLOSE WINDOW screen
         EXIT PROGRAM
      END IF
   END IF
END FUNCTION
 
FUNCTION udmtree_getpid()
   DEFINE   lr_process          DYNAMIC ARRAY OF RECORD
               ip               STRING,       #IP
               pid              STRING        #PID
                                END RECORD
   DEFINE   li_i                LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   li_cnt              LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   ls_cmd              STRING
   DEFINE   lc_channel          base.Channel
   DEFINE   ls_result           STRING
   DEFINE   ls_fglserver        STRING
 
 
   LET g_udmtree_pid = FGL_GETPID()
 
   RUN "fglWrt -u"              #No.MOD-670090
   LET ls_cmd = "fglWrt -a info user 2>&1"
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openPipe(ls_cmd,"r")
   CALL lc_channel.setDelimiter("")
   LET li_i = 1
   WHILE lc_channel.read(ls_result)
      LET li_cnt = ls_result.getIndexOf("GUI Server",1)
      IF li_cnt > 0 THEN
         #No.FUN-920138 saki  --start--
         IF ls_result.getIndexOf("Process Id",1) > 0 THEN
            LET ls_fglserver = ls_result.subString(ls_result.getIndexOf("GUI Server",1) + 11,ls_result.getIndexOf("Process Id",1)-4)
            #No:EXT-9C0145 --start--
            LET lr_process[li_i].ip = ls_fglserver
            LET lr_process[li_i].pid = ls_result.subString(ls_result.getIndexOf("Process Id",1)+11,ls_result.getLength())
            LET li_i = li_i + 1
            #No:EXT-9C0145 ---end---
         ELSE
         #No.FUN-920138 saki  ---end---
            LET ls_fglserver = ls_result.subString(li_cnt + 11,ls_result.getLength())
         END IF   #No.FUN-920138 saki 
         CONTINUE WHILE
      END IF
 
      LET li_cnt = ls_result.getIndexOf("Process Id",1)
      IF li_cnt > 0 THEN
         LET lr_process[li_i].ip = ls_fglserver
         LET lr_process[li_i].pid = ls_result.subString(li_cnt + 11,ls_result.getLength())
         LET li_i = li_i + 1
      END IF
   END WHILE
   CALL lr_process.deleteElement(li_i)
   CALL lc_channel.close()
 
   FOR li_i = 1 TO lr_process.getLength()
       IF (lr_process[li_i].pid.equals(g_udmtree_pid)) THEN
          LET g_udmtree_ip = lr_process[li_i].ip
          EXIT FOR
       END IF
   END FOR
 
   #No.TQC-650095 --start--
   IF g_udmtree_ip.getIndexOf(":",1) <= 0 THEN
      LET g_udmtree_ip = g_udmtree_ip,":0"
   END IF
   #No.TQC-650095 ---end---
 
   #No.FUN-740179 --start--
   LET ls_fglserver = cl_process_chg_iprec(g_udmtree_ip CLIPPED)
   LET g_udmtree_gbq02 = ls_fglserver
   #No.FUN-740179 ---end---
END FUNCTION
#No.FUN-580093 ---end---
 
#FUN-580011
FUNCTION udmtree_efmenu()
   DEFINE l_i               LIKE type_file.num10,  #No.FUN-680135 INTEGER
          l_tag             STRING,
          l_p1              LIKE type_file.num10,  #No.FUN-680135 INTEGER
          l_p2              LIKE type_file.num10,  #No.FUN-680135 INTEGER
          l_g_formNum       STRING,
          l_wc              STRING
   DEFINE l_formNum         LIKE type_file.chr20  #No.FUN-680135 VARCHAR(20)
   DEFINE l_argv            STRING                  #FUN-780070
   DEFINE l_FormOwnerID     LIKE gen_file.gen01    #FUN-7C0003
   DEFINE l_FormCreatorID   LIKE gen_file.gen01    #FUN-7C0003
   #-----FUN-8A0057---------
   DEFINE l_wse02      LIKE wse_file.wse02,
          l_wse03      LIKE wse_file.wse03,
          l_wse10      LIKE wse_file.wse10,
          l_sql        STRING,
          l_status     LIKE type_file.chr1
   #-----END FUN-8A0057-----
 
  #TQC-5B0218
  #IF g_aza.aza23 matches '[ Nn]' THEN   #未設定與 EasyFlow 簽核
  #   CALL cl_err('aza23','mfg3551',1)
  #   RETURN
  #END IF
  #END TQC-5B0218
 
  CASE g_forminfo
     WHEN "Inbox"
           CALL cl_set_comp_visible("intfilter",TRUE)
     WHEN "Info"
           CALL cl_set_comp_visible("intfilter",FALSE)
     WHEN "Sent"
           CALL cl_set_comp_visible("intfilter",FALSE)
  END CASE
 
  #CALL aws_efapp_formID() RETURNING g_status,g_items,g_values
  #CALL cl_set_combo_items("strfilter",g_items,g_values)
 
 
  DISPLAY g_forminfo TO forminfo
  DISPLAY g_strfilter TO strfilter
  DISPLAY g_intfilter TO intfilter
 
  LET l_ac = 1
 
  WHILE TRUE
     CALL udmtree_efmenu_bp("G")
     CASE g_action_choice
          WHEN "selectbox"
             CALL udmtree_efmenu_i()
          WHEN "detail"
             IF g_ef.getLength() > 0 THEN
 
                #No.FUN-780070 
                LET g_sql = "DELETE FROM wsk_file ",
                            " WHERE wsk01='",fgl_getenv('FGLSERVER') CLIPPED,"'",
                            "   AND wsk02='",g_user CLIPPED,"'",
                            "   AND wsk03='",g_ef[l_ac].ef03 CLIPPED,"'",
                            "   AND wsk05='",g_ef[l_ac].ef02 CLIPPED,"'"
                             
                #END No.FUN-780070 
                EXECUTE IMMEDIATE g_sql 
 
                LET l_FormCreatorID = aws_efapp_getid(g_ef[l_ac].ef08)   #FUN-7C0003
                LET l_FormOwnerID = aws_efapp_getid(g_ef[l_ac].ef09)     #FUN-7C0003
 
                LET g_sql2 = "INSERT INTO wsk_file",
                            "(wsk01,wsk02,wsk03,wsk04,wsk05,wsk06,wsk07,wsk08,wsk09,wsk10,wsk11,wsk12,wsk13,wsk14) VALUES('",
                            fgl_getenv('FGLSERVER') CLIPPED,"','",
                            g_user CLIPPED,"','", g_ef[l_ac].ef03 CLIPPED,"','",
                            g_ef[l_ac].ef01 CLIPPED,"','", g_ef[l_ac].ef02 CLIPPED,"','",
                           #g_ef[l_ac].ef08 CLIPPED,"','", g_ef[l_ac].ef09 CLIPPED,"','", #FUN-7C0003
                            l_FormCreatorID CLIPPED,"','", l_FormOwnerID CLIPPED,"','", #FUN-7C0003
                            g_ef[l_ac].ef04 CLIPPED,"','", g_ef[l_ac].ef11 CLIPPED,"','",
                            g_ef[l_ac].ef15 CLIPPED,"','", g_ef[l_ac].ef16 CLIPPED,"','",
                            g_ef[l_ac].ef17 CLIPPED,"','", g_ef[l_ac].ef18 CLIPPED,"','",
                            g_forminfo CLIPPED, "')"
                PREPARE insert_prep FROM g_sql2
                EXECUTE insert_prep
                IF STATUS THEN
                   #CALL cl_err('insert_prep:',status,1)  #No.FUN-660081
                   CALL cl_err3("ins","wsk_file",fgl_getenv('FGLSEVER'),g_user,SQLCA.sqlcode,"","insert_prep",1)   #No.FUN-660081
                ELSE
 
                   LET mi_easyflow_trigger = TRUE
 
                   LET g_cmd = g_ef[l_ac].ef03 CLIPPED
 
                   #FUN-780070  
                   FOR l_i = 1 TO 5
                     LET l_argv = aws_efapp_key_value(g_ef[l_ac].ef02 CLIPPED,l_i)
                     IF NOT cl_null(l_argv) OR l_argv != "" THEN
                        LET g_cmd = g_cmd ," '",l_argv CLIPPED,"'"
                     ELSE
                        EXIT FOR
                     END IF
                   END FOR
                   #END FUN-780070  
 
                   CALL FGL_SETENV("SourceFormNum",g_ef[l_ac].ef02 CLIPPED) #TQC-7B0029
 
                   #-----FUN-8A0057---------
                   #CALL cl_cmdrun_wait(g_cmd)
                   SELECT wse02,wse03,wse10 
                     INTO l_wse02,l_wse03,l_wse10 
                      FROM wse_file 
                     WHERE wse01 = g_ef[l_ac].ef03 
 
                   CALL aws_efapp_wc_key(g_ef[l_ac].ef02) RETURNING l_wc 
 
                   IF LENGTH(l_wc) != 0 THEN
                      LET l_g_formNum = aws_efapp_key(g_ef[l_ac].ef02,1)
                   ELSE
                      LET l_g_formNum = g_ef[l_ac].ef02 
                   END IF
 
                   LET l_sql = " SELECT ",l_wse10 CLIPPED," FROM ",l_wse02 CLIPPED,
                               "  WHERE ",l_wse03 CLIPPED," = '",l_g_formNum CLIPPED,"'"
                   
                   IF LENGTH(l_wc) != 0 THEN
                      LET l_sql = l_sql CLIPPED, l_wc
                   END IF
 
                   DECLARE wse_c CURSOR FROM l_sql
                   OPEN wse_c
                   FETCH wse_c INTO l_status
 
                   IF (g_forminfo='Inbox' OR g_forminfo='Sent') AND l_status='0' THEN 
                       CALL cl_err('','aws-516',1)
                   ELSE
                       CALL cl_cmdrun_wait(g_cmd)
                   END IF
                   #-----END FUN-8A0057-----
 
                   LET mi_easyflow_trigger = FALSE      #MOD-5A0089
 
                   EXECUTE IMMEDIATE g_sql 
 
                END IF
             END IF
          WHEN "exit"                            # Esc.結束
             EXIT WHILE
 
     END CASE
     IF g_action_choice = "exit" THEN
        EXIT WHILE
     END IF
  END WHILE
END FUNCTION
 
FUNCTION udmtree_efmenu_bp(p_ud)
  DEFINE li_result      LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
  DEFINE ls_remain_sec  LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
  DEFINE ls_msg_cnt     LIKE type_file.num5   #No.FUN-680135 SMALLINT
  DEFINE p_ud           LIKE type_file.chr1   #No.FUN-680135 VARCHAR(1)
 
  LET g_action_choice = " "
 
  #CALL cl_set_act_visible("accept,cancel", FALSE)
 
  CALL cl_set_comp_visible("ef01,ef02,ef03,ef04,ef05,ef08,ef09,ef14,ef15,ef16,ef17,ef18",TRUE)
  CASE g_forminfo
     WHEN "Inbox"
           CALL cl_set_comp_visible("ef01,ef02,ef03,ef04,ef05,ef15,ef16,ef17,ef18",FALSE)
     WHEN "Info"
           CALL cl_set_comp_visible("ef01,ef02,ef03,ef04,ef05,ef08,ef09,ef14,ef15,ef16,ef17,ef18",FALSE)
     WHEN "Sent"
           CALL cl_set_comp_visible("ef01,ef02,ef03,ef04,ef05,ef08,ef09,ef14,ef15,ef16,ef17,ef18",FALSE)
  END CASE
  WHILE TRUE
      CALL g_ef.clear()
      IF g_status THEN
        #CALL aws_efapp_formInfo(g_ef,g_forminfo, g_intfilter, g_strfilter,g_curr_page)
         CALL aws_efapp_formInfo(g_ef,g_forminfo, g_intfilter, g_strfilter,g_curr_page,'15')   #FUN-7C0094
           RETURNING g_status,g_curr_page,g_total_page
           IF g_ef.getLength() = 0 THEN
                 CALL cl_err('','mfg3382',1)
           END IF
      END IF
 
      DISPLAY g_total_page TO FORMONLY.total
      DISPLAY g_curr_page TO FORMONLY.curr
 
     # 因為此支程式特殊會產生兩個dialog,所以無法完全鎖上accept,在此自己上鎖
     CALL udmtree_set_act_visible("accept",FALSE)
 
     DISPLAY ARRAY g_ef TO  s_ef.*
        BEFORE DISPLAY
           CALL udmtree_efmenu_disableAction(DIALOG)
           CALL udmtree_efmenu_nodisableAction(DIALOG)
 
        ON ACTION selectbox
           LET g_action_choice="selectbox"
           LET INT_FLAG = 1
           EXIT DISPLAY
 
        ON ACTION  efrefresh
           EXIT DISPLAY
          
        ON ACTION accept
           IF ARR_COUNT() = 0 THEN
                CONTINUE DISPLAY
           END IF
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           LET INT_FLAG = 1
           EXIT DISPLAY
 
 
        ON ACTION first_page   # Jump to First Page
            LET g_curr_page = 1
            EXIT DISPLAY
 
        ON ACTION next_page    # Jump to Next Page
            LET g_curr_page = g_curr_page + 1
            EXIT DISPLAY
 
        ON ACTION prev_page    # Jump to Previous Page
            LET g_curr_page = g_curr_page - 1
            EXIT DISPLAY
 
        ON ACTION last_page    # Jump to Last Page
            LET g_curr_page = g_total_page
            EXIT DISPLAY
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            EXIT DISPLAY
 
         ON ACTION exit                   # Esc.結束
            CALL udmtree_exit_confirm()                    #No.FUN-5B0054
 
         ON ACTION cancel
            LET INT_FLAG=FALSE
            CALL udmtree_exit_confirm()                    #No.FUN-5B0054
 
        ON ACTION info
           LET g_action_choice = "exit"
           LET INT_FLAG = 1
           EXIT DISPLAY
 
        ON ACTION system_flow
           LET g_action_choice = "exit"
           LET INT_FLAG = 1
           EXIT DISPLAY
 
        ON ACTION so_flow
           LET g_action_choice = "exit"
           LET INT_FLAG = 1
           EXIT DISPLAY
 
        ON ACTION needproc                    
           CALL udmtree_needproc_b_fill()
           CALL udmtree_needproc()
           LET g_action_choice = "exit"
           LET INT_FLAG = 1
           EXIT DISPLAY
 
        #No.FUN-570225 --start--
        ON ACTION search
           CALL udmtree_search()
           LET g_action_choice = "exit"
           LET INT_FLAG = 1
           EXIT DISPLAY
        #No.FUN-570225 ---end---
 
        #No.FUN-570271 --start--
        ON IDLE ms_msg_sec
           SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
            WHERE gar02 = g_user AND gar06 = 'N'
           IF ls_msg_cnt > 0 THEN
              CALL user_getprocess() RETURNING li_result
              IF NOT li_result THEN
                 CALL cl_cmdrun('p_load_msg')
              END IF
           END IF
           IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
              CALL udmtree_detect_process() RETURNING li_result
              IF (NOT li_result) THEN
                 LET ms_idle_sec = ms_idle_sec + ms_msg_sec
                 LET ls_remain_sec = g_idle_seconds - ms_idle_sec
                 IF ls_remain_sec < ms_msg_sec THEN
                    LET ms_msg_sec = ls_remain_sec
                 END IF
                 IF ms_idle_sec = g_idle_seconds THEN
                    LET ms_idle_sec = 0
                    LET ls_remain_sec = 0
                   #-CHI-980033-add-
                    IF g_idle_seconds < 3 THEN
                       LET ms_msg_sec = g_idle_seconds
                    ELSE
                       LET ms_msg_sec = g_idle_seconds / 3
                    END IF
                   #-CHI-980033-end-
                    IF ms_msg_sec > 180 THEN
                       LET ms_msg_sec = 180
                    END IF
                    CALL cl_on_idle()
                    CONTINUE DISPLAY
                 END IF
              END IF
           END IF
        #No.FUN-570271 ---end---
 
         ON ACTION controlg  #MOD-510103
           CALL cl_cmdask()
 
         ON ACTION about     #MOD-510103
           CALL cl_about()
 
         ON ACTION help      # H.說明 MOD-510103
           CALL cl_show_help()
 
         #No.FUN-BA0079 ---start---
         ON ACTION cascade_chart
            CALL udm_tree_cascade_chart()
            LET g_action_choice = "exit"
            EXIT DISPLAY

         ON ACTION custom_chart
            CALL udm_tree_custom_chart()
            LET g_action_choice = "exit"
            EXIT DISPLAY
         #No.FUN-BA0079 ---end---

     END DISPLAY
     CALL udmtree_set_act_visible("accept",TRUE)
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
  END WHILE
 # CALL cl_set_act_visible("accept,cancel", TRUE)
  MESSAGE ''
END FUNCTION
 
FUNCTION udmtree_efmenu_i()
DEFINE li_result       LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
DEFINE ls_remain_sec   LIKE type_file.num5   #No.FUN-680135 SMALLINT #No.FUN-570271
DEFINE ls_msg_cnt      LIKE type_file.num5   #No.FUN-680135 SMALLINT
DEFINE l_p1            LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE l_forminfo_t    LIKE wsk_file.wsk14,  #No.FUN-680135 VARCHAR(50)
      l_strfilter_t    LIKE type_file.chr50, #No.FUN-680135 VARCHAR(50)
      l_intfilter_t    LIKE type_file.chr50  #No.FUN-680135 VARCHAR(50)
 
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
 
    LET l_forminfo_t = g_forminfo
    LET l_strfilter_t = g_strfilter
    LET l_intfilter_t = g_intfilter
    DISPLAY g_forminfo,g_strfilter,g_intfilter TO forminfo,strfilter,intfilter
 
    INPUT g_forminfo,g_strfilter,g_intfilter WITHOUT DEFAULTS
           FROM forminfo,strfilter,intfilter ATTRIBUTE(UNBUFFERED)
 
      ON CHANGE forminfo
          CASE g_forminfo
             WHEN "Inbox"
                   CALL cl_set_comp_visible("intfilter",TRUE)
                   LET g_intfilter = "2"
             WHEN "Info"
                   CALL cl_set_comp_visible("intfilter",FALSE)
                   LET g_intfilter = '0'
             WHEN "Sent"
                   CALL cl_set_comp_visible("intfilter",FALSE)
                   LET g_intfilter = '0'
          END CASE
 
      ON ACTION go
          LET g_curr_page = 1
          LET g_total_page = 1
          EXIT INPUT
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            EXIT INPUT
 
         ON ACTION exit                   # Esc.結束
            #No.FUN-570271 --start--
            CALL udmtree_detect_process() RETURNING li_result
            IF li_result THEN
               CALL cl_err("","azz-726",1)
            END IF
            IF cl_confirm('azz-901') THEN
               CALL udmtree_close()                        #No.FUN-570225
               CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-580093  #No.FUN-6A0096
               CLOSE WINDOW w_udm_tree
               EXIT PROGRAM
            END IF
            #No.FUN-570271 ---end---
 
         #No.FUN-570271 --start--
         ON ACTION cancel
            LET INT_FLAG=FALSE
            CALL udmtree_detect_process() RETURNING li_result
            IF li_result THEN
               CALL cl_err("","azz-726",1)
            END IF
            IF cl_confirm('azz-901') THEN
               CALL udmtree_close()                        #No.FUN-570225
               CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-580093  #No.FUN-6A0096
               CLOSE WINDOW w_udm_tree
               EXIT PROGRAM
            END IF
         #No.FUN-570271 ---end---
 
        ON ACTION info
           LET g_action_choice = "exit"
           EXIT INPUT
 
        ON ACTION system_flow
           LET g_action_choice = "exit"
           EXIT INPUT
 
        ON ACTION so_flow
           LET g_action_choice = "exit"
           EXIT INPUT
 
        ON ACTION needproc                    
           CALL udmtree_needproc_b_fill()
           CALL udmtree_needproc()
           LET g_action_choice = "exit"
           EXIT INPUT
 
         #No.FUN-570225 --start--
         ON ACTION search
            CALL udmtree_search()
            LET g_action_choice = "exit"
            EXIT INPUT
         #No.FUN-570225 ---end---
 
        #No.FUN-570271 --start--
        ON IDLE ms_msg_sec
           SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
            WHERE gar02 = g_user AND gar06 = 'N'
           IF ls_msg_cnt > 0 THEN
              CALL user_getprocess() RETURNING li_result
              IF NOT li_result THEN
                 CALL cl_cmdrun('p_load_msg')
              END IF
           END IF
           IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
              CALL udmtree_detect_process() RETURNING li_result
              IF (NOT li_result) THEN
                 LET ms_idle_sec = ms_idle_sec + ms_msg_sec
                 LET ls_remain_sec = g_idle_seconds - ms_idle_sec
                 IF ls_remain_sec < ms_msg_sec THEN
                    LET ms_msg_sec = ls_remain_sec
                 END IF
                 IF ms_idle_sec = g_idle_seconds THEN
                    LET ms_idle_sec = 0
                    LET ls_remain_sec = 0
                   #-CHI-980033-add-
                    IF g_idle_seconds < 3 THEN
                       LET ms_msg_sec = g_idle_seconds
                    ELSE
                       LET ms_msg_sec = g_idle_seconds / 3
                    END IF
                   #-CHI-980033-end-
                    IF ms_msg_sec > 180 THEN
                       LET ms_msg_sec = 180
                    END IF
                    CALL cl_on_idle()
                    CONTINUE INPUT
                 END IF
              END IF
           END IF
        #No.FUN-570271 ---end---
 
         ON ACTION controlg  #MOD-510103
           CALL cl_cmdask()
 
         ON ACTION about     #MOD-510103
           CALL cl_about()
 
         ON ACTION help      # H.說明 MOD-510103
           CALL cl_show_help()
 
    END INPUT
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION udmtree_efmenu_disableAction(pd_dialog)
   DEFINE pd_dialog ui.Dialog
 
# If on First Page, disable "First_Page" & "Prev_Page" Action
   IF g_curr_page = 1 THEN
      CALL pd_dialog.setActionActive("first_page", FALSE)
      CALL pd_dialog.setActionActive("prev_page", FALSE)
   END IF
###
 
# If on Last Page, disable "Lastt_Page" & "Next_Page" Action
   IF g_curr_page = g_total_page THEN
      CALL pd_dialog.setActionActive("last_page", FALSE)
      CALL pd_dialog.setActionActive("next_page", FALSE)
   END IF
###
END FUNCTION
 
FUNCTION udmtree_efmenu_nodisableAction(pd_dialog)
   DEFINE pd_dialog ui.Dialog
 
 
# If on First Page, disable "First_Page" & "Prev_Page" Action
   IF g_curr_page > 1 THEN
      CALL pd_dialog.setActionActive("first_page", TRUE)
      CALL pd_dialog.setActionActive("prev_page", TRUE)
   END IF
###
 
# If on Last Page, disable "Lastt_Page" & "Next_Page" Action
   IF g_curr_page < g_total_page THEN
      CALL pd_dialog.setActionActive("last_page", TRUE)
      CALL pd_dialog.setActionActive("next_page", TRUE)
   END IF
###
END FUNCTION
#END FUN-580011
 
#No.FUN-5B0054 --start--
#按下離開前，檢查是否有其他程式執行，讓使用者選擇要離開所有程式或只單離開udm_tree
FUNCTION udmtree_exit_confirm()
   DEFINE   lc_title   LIKE ze_file.ze03     #No.FUN-680135 VARCHAR(50)
   DEFINE   li_result  LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   ls_choice  STRING
   DEFINE   ls_msg     STRING
   DEFINE   li_i       LIKE type_file.num5   #No.FUN-680135 SMALLINT
   DEFINE   ls_remain_sec   LIKE type_file.num5   #No.TQC-860016
   DEFINE   lc_gbq01        LIKE gbq_file.gbq01   #FUN-A70128 add
   DEFINE   lc_gbq04        LIKE gbq_file.gbq04   #FUN-A70128 add 
 
   #No.FUN-570271 --start--
   CALL udmtree_detect_process() RETURNING li_result
   IF li_result THEN
      LET ls_msg = cl_getmsg("azz-726",g_lang)
   ELSE
      LET ls_msg = cl_getmsg("azz-901",g_lang)
   END IF
   #No.FUN-570271 ---end---
 
   SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-042' AND ze02 = g_lang
   IF SQLCA.SQLCODE THEN
      LET lc_title = "Confirm"
   END IF
 
   MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg.trim(), IMAGE="question")
      BEFORE MENU
         IF (NOT li_result) THEN
            CALL cl_set_act_visible("closeall",FALSE)
         END IF
      ON ACTION closeall
         FOR li_i = 1 TO g_user_pid.getLength()
             #No.MOD-670090 --start--
             IF g_user_pid[li_i]=g_udmtree_pid THEN
                CONTINUE FOR
             END IF
             #No.MOD-670090 ---end---
             #FUN-A70128--add---str---
             LET lc_gbq01 = g_user_pid[li_i]
             SELECT gbq04 INTO lc_gbq04
               FROM gbq_file
              WHERE gbq01 = lc_gbq01
             IF lc_gbq04 <> 'apsp702' THEN
             #FUN-A70128--add---end---
               #mark by FUN-CA0113 --(s)--
               #RUN "kill -9 " || g_user_pid[li_i] || " 2>/dev/null" RETURNING li_result
               #SLEEP 1
               #IF li_result THEN
               #   DISPLAY "PID:",g_user_pid[li_i]," Fail to kill"
               #END IF
               #mark by FUN-CA0113 --(e)--
               
               #FUN-CA0113 --(s)--
                RUN "kill -15 " || g_user_pid[li_i] || " 2>/dev/null" RETURNING li_result
                SLEEP 1
                IF li_result THEN
                   RUN "kill -9 " || g_user_pid[li_i] || " 2>/dev/null" RETURNING li_result
                   IF li_result THEN
                      DISPLAY "PID:",g_user_pid[li_i]," Fail to kill"
                   END IF
                END IF
               #FUN-CA0113 --(e)--
             END IF #FUN-A70128 add
         END FOR
         LET ls_choice = "exit"
         EXIT MENU
      ON ACTION close_udmtree
         LET ls_choice = "exit"
         EXIT MENU
      ON ACTION cancel
         EXIT MENU
 
      #No.TQC-860016 --start--
      ON IDLE ms_msg_sec
         IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
            CALL udmtree_detect_process() RETURNING li_result
            IF (NOT li_result) THEN
               LET ms_idle_sec = ms_idle_sec + ms_msg_sec
               LET ls_remain_sec = g_idle_seconds - ms_idle_sec
               IF ls_remain_sec < ms_msg_sec THEN
                  LET ms_msg_sec = ls_remain_sec
               END IF
               IF ms_idle_sec = g_idle_seconds THEN
                  LET ms_idle_sec = 0
                  LET ls_remain_sec = 0
                 #-CHI-980033-add-
                  IF g_idle_seconds < 3 THEN
                     LET ms_msg_sec = g_idle_seconds
                  ELSE
                     LET ms_msg_sec = g_idle_seconds / 3
                  END IF
                 #-CHI-980033-end-
                  IF ms_msg_sec > 180 THEN
                     LET ms_msg_sec = 180
                  END IF
                  CALL cl_on_idle()
                  CONTINUE MENU
               END IF
            END IF
         END IF
      #No.TQC-860016 ---end---
   END MENU
   CALL cl_set_act_visible("closeall",TRUE)
   IF ls_choice = "exit" THEN
      CALL udmtree_close()                        #No.FUN-570225
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.TQC-6A0036  #No.FUN-6A0096
      CLOSE WINDOW w_udm_tree
      EXIT PROGRAM
   END IF
END FUNCTION
#No.FUN-5B0054 ---end---
 
#No.FUN-570225 --start--
FUNCTION udmtree_search()
   DEFINE   lr_gcn               DYNAMIC ARRAY OF RECORD
               gcn01             LIKE gcn_file.gcn01,
               gcn03             LIKE gcn_file.gcn03,
               gcn04             LIKE gcn_file.gcn04
                                 END RECORD
   DEFINE   ls_value             STRING
   DEFINE   ls_desc              STRING
   DEFINE   ls_cmd               STRING
   DEFINE   li_i                 LIKE type_file.num5
   DEFINE   li_cnt               LIKE type_file.num5
   DEFINE   ls_msg_cnt           LIKE type_file.num5
   DEFINE   li_result            LIKE type_file.num5
   DEFINE   ls_remain_sec        LIKE type_file.num5
 
 
   LET li_cnt = 1
   DECLARE gcn_curs CURSOR FOR
                    SELECT gcn01,gcn03,gcn04 FROM gcn_file WHERE gcn02=g_lang
   FOREACH gcn_curs INTO lr_gcn[li_cnt].*
      SELECT COUNT(*) INTO li_i FROM gcm_file WHERE gcm02 = lr_gcn[li_cnt].gcn01
      IF li_i <= 0 THEN
         CONTINUE FOREACH
      END IF
      LET ls_value = ls_value,lr_gcn[li_cnt].gcn01 CLIPPED,","
      LET ls_desc = ls_desc,lr_gcn[li_cnt].gcn03 CLIPPED,","
      LET li_cnt = li_cnt + 1
   END FOREACH
   CALL lr_gcn.deleteElement(li_cnt)
   LET ls_value = ls_value.subString(1,ls_value.getLength()-1)
   LET ls_desc = ls_desc.subString(1,ls_desc.getLength()-1)
 
   CALL cl_set_combo_items("category",ls_value,ls_desc)
   CALL udmtree_set_act_visible("accept",FALSE)
   #No.TQC-750054 --start--
   IF g_method = "1" OR cl_null(g_method) THEN
      CALL cl_set_comp_visible("file_path,file_name",FALSE)
   END IF
   #No.TQC-750054 ---end---
 
   #No.TQC-750054 --start--
   IF cl_null(g_method) THEN
      LET g_method = "1"
   END IF
   #No.TQC-750054 ---end---
   INPUT g_method,g_cate,g_filepath,g_filename,g_where WITHOUT DEFAULTS
    FROM q_method,category,file_path,file_name,condition
 
      ON CHANGE q_method
         CASE g_method
            WHEN "1"
               CALL cl_set_comp_visible("group05",TRUE)
               CALL cl_set_comp_visible("category",TRUE)
               CALL cl_set_comp_visible("file_path,file_name",FALSE)
               DISPLAY "" TO q_memo
               FOR li_cnt = 1 TO lr_gcn.getLength()
                   IF g_cate.equals(lr_gcn[li_cnt].gcn01 CLIPPED) THEN
                      DISPLAY lr_gcn[li_cnt].gcn04 TO q_memo
                      EXIT FOR
                   END IF
               END FOR
            WHEN "2"
               CALL cl_set_comp_visible("file_path,file_name",TRUE)
               CALL cl_set_comp_visible("category",FALSE)
               #No.MOD-750003 --start--
               IF g_user != "tiptop" THEN
                  CALL cl_set_comp_visible("group05",FALSE)
               ELSE
                  CALL cl_set_comp_visible("group05",TRUE)
               END IF
               #No.MOD-750003 ---end---
               LET ls_desc = cl_getmsg("azz-742",g_lang),cl_getmsg("azz-743",g_lang)
               LET ls_desc = cl_replace_str(ls_desc,"%%","\n")
               DISPLAY ls_desc TO q_memo
         END CASE
 
      ON CHANGE category
         FOR li_cnt = 1 TO lr_gcn.getLength()
             IF g_cate.equals(lr_gcn[li_cnt].gcn01 CLIPPED) THEN
                DISPLAY lr_gcn[li_cnt].gcn04 TO q_memo
                EXIT FOR
             END IF
         END FOR
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT INPUT
 
      ON ACTION exit                   # Esc.結束
         CALL udmtree_exit_confirm()                    #No.FUN-5B0054
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         CALL udmtree_exit_confirm()                    #No.FUN-5B0054
 
      ON ACTION controlp
         CALL cl_cmdrun_wait('aoos901 continue')        #No.TQC-6A0036
         CALL azz_set_win_title()
         CALL s_udsday()			       	#MOD-980264
         EXIT INPUT
 
      ON ACTION accept
         CALL GET_FLDBUF(formonly.q_method)   RETURNING g_method
         CALL GET_FLDBUF(formonly.category)   RETURNING g_cate
         CALL GET_FLDBUF(formonly.file_path)  RETURNING g_filepath
         CALL GET_FLDBUF(formonly.file_name)  RETURNING g_filename
         CALL GET_FLDBUF(formonly.condition)  RETURNING g_where
         CASE g_method
            WHEN "1"
               IF (NOT cl_null(g_cate)) AND (NOT cl_null(g_where)) THEN
                  CALL udmtree_search_result_menu()
               ELSE
                  MESSAGE "!!"
               END IF
            WHEN "2"
               IF (NOT cl_null(g_filepath)) AND
                  (NOT cl_null(g_filename) OR NOT cl_null(g_where)) THEN
                  LET ls_cmd = "cd ",g_filepath," 2>/dev/null"
                  RUN ls_cmd RETURNING li_result
                  IF li_result THEN
                     MESSAGE "Path Error!"
                  ELSE
                     CALL udmtree_search_result_menu()
                  END IF
               ELSE
                  MESSAGE "!!"
               END IF
         END CASE
  
      ON ACTION needproc                    
         CALL udmtree_needproc_b_fill()
         CALL udmtree_needproc()
         LET g_action_choice = "exit"
#        LET INT_FLAG = 1       #No.FUN-840102 mark
         EXIT INPUT
 
      ON ACTION info
         LET g_action_choice = "exit"
         EXIT INPUT
 
      ON ACTION system_flow
         LET g_action_choice = "exit"
         EXIT INPUT
 
      ON ACTION so_flow
         LET g_action_choice = "exit"
         EXIT INPUT
 
      ON ACTION easyflow                    #FUN-580011
         #FUN-880099 --start--
         #因新增easyflowgp page改寫menu方式
         ##TQC-5B0218
         #LET g_curr_page = 1
         #LET g_total_page = 1
         #IF g_aza.aza23 matches '[ Nn]' THEN   #未設定與 EasyFlow 簽核
         #      LET g_status = 0
         #      CALL cl_set_act_visible("go,selectbox,efrefresh",FALSE)
         #      CALL cl_err('aza23','mfg3551',1)
         #ELSE
         #    IF (NOT g_status) OR g_status IS NULL THEN
         #      LET g_forminfo = "Inbox"
         #      LET g_strfilter = "ALL"
         #      LET g_intfilter = "2"
         #      CALL aws_efapp_formID() RETURNING g_status
         #      CALL cl_set_comp_visible("ef01,ef02,ef03,ef04,ef05,ef15,ef16,ef17,ef18",FALSE)
         #    END IF
         #    CALL udmtree_efmenu() 
         #END IF
         #END TQC-5B0218
         #LET g_action_choice = "exit"
         #EXIT INPUT
         CALL udmtree_ef_action()
         LET g_action_choice = "exit"
         EXIT INPUT

      ON ACTION easyflowgp
         CALL cl_set_comp_visible("easyflow",FALSE)
         CALL udmtree_ef_action()
         EXIT INPUT
      #FUN-880099 --end----
 
      #No.FUN-570271 --start--
      ON IDLE ms_msg_sec
         SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
          WHERE gar02 = g_user AND gar06 = 'N'
         IF ls_msg_cnt > 0 THEN
            CALL user_getprocess() RETURNING li_result
            IF NOT li_result THEN
               CALL cl_cmdrun('p_load_msg')
            END IF
         END IF
         IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
            CALL udmtree_detect_process() RETURNING li_result
            IF (NOT li_result) THEN
               LET ms_idle_sec = ms_idle_sec + ms_msg_sec
               LET ls_remain_sec = g_idle_seconds - ms_idle_sec
               IF ls_remain_sec < ms_msg_sec THEN
                  LET ms_msg_sec = ls_remain_sec
               END IF
               IF ms_idle_sec = g_idle_seconds THEN
                  LET ms_idle_sec = 0
                  LET ls_remain_sec = 0
                 #-CHI-980033-add-
                  IF g_idle_seconds < 3 THEN
                     LET ms_msg_sec = g_idle_seconds
                  ELSE
                     LET ms_msg_sec = g_idle_seconds / 3
                  END IF
                 #-CHI-980033-end-
                  IF ms_msg_sec > 180 THEN
                     LET ms_msg_sec = 180
                  END IF
                  CALL cl_on_idle()
                  CONTINUE INPUT
               END IF
            END IF
         END IF
      #No.FUN-570271 ---end---
 
      ON ACTION controlg  #MOD-510103
        CALL cl_cmdask()
 
      ON ACTION about     #MOD-510103
        CALL cl_about()
 
      ON ACTION help      # H.說明 MOD-510103
        CALL cl_show_help()
     
      #No.FUN-BA0079 ---start---
      ON ACTION cascade_chart
         CALL udm_tree_cascade_chart()
         LET g_action_choice = "exit"
         EXIT INPUT

      ON ACTION custom_chart
         CALL udm_tree_custom_chart()
         LET g_action_choice = "exit"
         EXIT INPUT
      #No.FUN-BA0079 ---end---

   END INPUT
   CALL udmtree_set_act_visible("accept",TRUE)
END FUNCTION
 
FUNCTION udmtree_search_result_menu()
   DEFINE lr_datagroup      RECORD
             gcm03          LIKE gcm_file.gcm03,
             gat03          LIKE gat_file.gat03,
             gcm04          LIKE gcm_file.gcm04,
             gaq03          LIKE gaq_file.gaq03,
             gcm11          LIKE gcm_file.gcm11,
             gcm01          LIKE gcm_file.gcm01,   #No.MOD-750003
             siftwhere      LIKE type_file.chr1
                            END RECORD
   DEFINE   ls_value        STRING
   DEFINE   ls_desc         STRING
   DEFINE   li_i            LIKE type_file.num5    #No.MOD-750003
 
   OPEN WINDOW search_result WITH FORM "azz/42f/udmtree_search"
      ATTRIBUTE(STYLE="create_qry")
   CALL cl_ui_locale("udmtree_search")
 
   CALL cl_set_comp_visible("page01,page02",TRUE)
   CASE g_method
      WHEN "1"
         CALL cl_set_comp_visible("page02",FALSE)
 
         LET g_sql = "SELECT gcm03,'',gcm04,'',gcm11,gcm01,''", #No.MOD-750003
                     "  FROM gcm_file WHERE gcm02 = '",g_cate,"'",
                     " ORDER BY gcm01"                          #No.MOD-750003
         PREPARE gcm01_pre FROM g_sql
         DECLARE gcm01_curs CURSOR FOR gcm01_pre
 
         CALL gr_datagroup.clear()
         LET l_ac = 1
         FOREACH gcm01_curs INTO lr_datagroup.*
            #No.MOD-750003 --start--
            FOR li_i = 1 TO gr_datagroup.getLength()
                IF lr_datagroup.gcm03 = gr_datagroup[li_i].gcm03 AND
                   lr_datagroup.gcm04 = gr_datagroup[li_i].gcm04 THEN
                   CONTINUE FOREACH
                END IF
            END FOR
            #No.MOD-750003 ---end---
            LET gr_datagroup[l_ac].gcm03 = lr_datagroup.gcm03
            LET gr_datagroup[l_ac].gcm04 = lr_datagroup.gcm04
            LET gr_datagroup[l_ac].gcm11 = lr_datagroup.gcm11
            SELECT gat03 INTO gr_datagroup[l_ac].gat03 FROM gat_file
             WHERE gat01=gr_datagroup[l_ac].gcm03 AND gat02=g_lang
            SELECT gaq03 INTO gr_datagroup[l_ac].gaq03 FROM gaq_file
             WHERE gaq01=gr_datagroup[l_ac].gcm04 AND gaq02=g_lang
            LET ls_value = ls_value,l_ac,","
            LET ls_desc = ls_desc,gr_datagroup[l_ac].gat03 CLIPPED,".",
                                  gr_datagroup[l_ac].gaq03 CLIPPED,"(",
                                  gr_datagroup[l_ac].gcm03 CLIPPED,".",
                                  gr_datagroup[l_ac].gcm04 CLIPPED,"),"
            LET l_ac = l_ac + 1
         END FOREACH
         LET ls_value = ls_value.subString(1,ls_value.getLength()-1)
         LET ls_desc = ls_desc.subString(1,ls_desc.getLength()-1)
         CALL cl_set_combo_items("q_select",ls_value,ls_desc)
 
         LET g_select = 1
         LET g_siftfld = "1"
         LET g_siftcon = ""
         CALL udmtree_search_result_01(g_select)
         CALL udmtree_search_result_bp01()
      WHEN "2"
         CALL cl_set_comp_visible("page01",FALSE)
         CALL udmtree_search_result_02()
         CALL udmtree_search_result_bp02()
   END CASE
 
   WHILE TRUE
      CASE g_action_choice
         WHEN "exec_prog"
            CALL udmtree_search_result_bp01()
         WHEN "sel_file"
            CALL udmtree_search_result_bp02()
         WHEN "exit"
            LET INT_FLAG = 1
      END CASE
      IF INT_FLAG THEN
         LET g_action_choice = ""
         LET INT_FLAG = FALSE
         EXIT WHILE
      END IF
   END WHILE
 
   CLOSE WINDOW search_result
END FUNCTION
 
FUNCTION udmtree_search_result_bp01()
   DEFINE   ls_cmd          STRING
   DEFINE   ls_msg_cnt      LIKE type_file.num5
   DEFINE   li_result       LIKE type_file.num5
   DEFINE   ls_remain_sec   LIKE type_file.num5
 
   WHILE TRUE
      LET g_action_choice = ""
      DISPLAY g_select TO formonly.q_select
      DISPLAY ARRAY gr_data TO s_data.* ATTRIBUTE(UNBUFFERED)
         #No.MOD-750003 --start--
         BEFORE DISPLAY
            IF g_user != "tiptop" THEN
               CALL cl_set_comp_visible("show_data",FALSE)
            ELSE
               CALL cl_set_comp_visible("show_data",TRUE)
            END IF
         #No.MOD-750003 ---end---
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
 
         ON ACTION re_sel
            LET g_siftfld = ""
            LET g_siftcon = ""
            DISPLAY g_siftfld,g_siftcon TO formonly.sift_fld,formonly.sift_con
            LET g_action_choice = "re_sel"
            EXIT DISPLAY
 
         ON ACTION sift_btn
            LET g_action_choice = "sift_btn"
            EXIT DISPLAY
 
         ON ACTION btn_detail
            LET l_ac = ARR_CURR()
            IF l_ac > 0 THEN
               MENU "udmtree_search_result" ATTRIBUTE(STYLE="popup")
                  BEFORE MENU
                     CALL udmtree_chg_acttext(gr_datagroup[g_select].gcm11,gr_data[l_ac].gcm05)
                  ON ACTION udmtree_search_act1
                     LET ls_cmd = gr_datagroup[g_select].gcm11," ",gr_data[l_ac].value
                     CALL cl_cmdrun(ls_cmd)
                  ON ACTION udmtree_search_act2
                     LET ls_cmd = gr_data[l_ac].gcm05," ",gr_data[l_ac].gcm06," ",gr_data[l_ac].gcm07
                     CALL cl_cmdrun(ls_cmd)
                  #No.TQC-860016 --start--
                  ON IDLE ms_msg_sec
                     IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
                        CALL udmtree_detect_process() RETURNING li_result
                        IF (NOT li_result) THEN
                           LET ms_idle_sec = ms_idle_sec + ms_msg_sec
                           LET ls_remain_sec = g_idle_seconds - ms_idle_sec
                           IF ls_remain_sec < ms_msg_sec THEN
                              LET ms_msg_sec = ls_remain_sec
                           END IF
                           IF ms_idle_sec = g_idle_seconds THEN
                              LET ms_idle_sec = 0
                              LET ls_remain_sec = 0
                             #-CHI-980033-add-
                              IF g_idle_seconds < 3 THEN
                                 LET ms_msg_sec = g_idle_seconds
                              ELSE
                                 LET ms_msg_sec = g_idle_seconds / 3
                              END IF
                             #-CHI-980033-end-
                              IF ms_msg_sec > 180 THEN
                                 LET ms_msg_sec = 180
                              END IF
                              CALL cl_on_idle()
                              CONTINUE MENU
                           END IF
                        END IF
                     END IF
                  #No.TQC-860016 ---end---
               END MENU
            END IF
 
         ON ACTION show_data
            LET l_ac = ARR_CURR()
            IF l_ac > 0 THEN
               CALL udmtree_showdata(gr_datagroup[g_select].gcm03,gr_datagroup[g_select].gcm04,l_ac)
            END IF
 
         ON IDLE ms_msg_sec
            SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
             WHERE gar02 = g_user AND gar06 = 'N'
            IF ls_msg_cnt > 0 THEN
               CALL user_getprocess() RETURNING li_result
               IF NOT li_result THEN
                  CALL cl_cmdrun('p_load_msg')
               END IF
            END IF
            IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
               CALL udmtree_detect_process() RETURNING li_result
               IF (NOT li_result) THEN
                  LET ms_idle_sec = ms_idle_sec + ms_msg_sec
                  LET ls_remain_sec = g_idle_seconds - ms_idle_sec
                  IF ls_remain_sec < ms_msg_sec THEN
                     LET ms_msg_sec = ls_remain_sec
                  END IF
                  IF ms_idle_sec = g_idle_seconds THEN
                     LET ms_idle_sec = 0
                     LET ls_remain_sec = 0
                    #-CHI-980033-add-
                     IF g_idle_seconds < 3 THEN
                        LET ms_msg_sec = g_idle_seconds
                     ELSE
                        LET ms_msg_sec = g_idle_seconds / 3
                     END IF
                    #-CHI-980033-end-
                     IF ms_msg_sec > 180 THEN
                        LET ms_msg_sec = 180
                     END IF
                     CALL cl_on_idle()
                     CONTINUE DISPLAY
                  END IF
               END IF
            END IF
 
         ON ACTION controlg  #MOD-510103
           CALL cl_cmdask()
 
         ON ACTION about     #MOD-510103
           CALL cl_about()
 
         ON ACTION help      # H.說明 MOD-510103
           CALL cl_show_help()
 
         ON ACTION exit
            LET g_action_choice = "exit"
            EXIT DISPLAY
 
         ON ACTION cancel
            LET g_action_choice = "exit"
            EXIT DISPLAY
      END DISPLAY
      CASE g_action_choice
         WHEN "re_sel"
            INPUT g_select WITHOUT DEFAULTS FROM q_select
               ON ACTION re_sel
                  CALL GET_FLDBUF(formonly.q_select) RETURNING g_select
                  EXIT INPUT
               #No.TQC-860016 --start--
               ON IDLE ms_msg_sec
                  IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
                     CALL udmtree_detect_process() RETURNING li_result
                     IF (NOT li_result) THEN
                        LET ms_idle_sec = ms_idle_sec + ms_msg_sec
                        LET ls_remain_sec = g_idle_seconds - ms_idle_sec
                        IF ls_remain_sec < ms_msg_sec THEN
                           LET ms_msg_sec = ls_remain_sec
                        END IF
                        IF ms_idle_sec = g_idle_seconds THEN
                           LET ms_idle_sec = 0
                           LET ls_remain_sec = 0
                          #-CHI-980033-add-
                           IF g_idle_seconds < 3 THEN
                              LET ms_msg_sec = g_idle_seconds
                           ELSE
                              LET ms_msg_sec = g_idle_seconds / 3
                           END IF
                          #-CHI-980033-end-
                           IF ms_msg_sec > 180 THEN
                              LET ms_msg_sec = 180
                           END IF
                           CALL cl_on_idle()
                           CONTINUE INPUT
                        END IF
                     END IF
                  END IF
 
               ON ACTION help
                  CALL cl_show_help()
               ON ACTION controlg
                  CALL cl_cmdask()
               ON ACTION about
                  CALL cl_about()
               #No.TQC-860016 ---end---
            END INPUT
            CALL udmtree_search_result_01(g_select)
         WHEN "sift_btn"
            INPUT g_siftfld,g_siftcon FROM sift_fld,sift_con
               ON ACTION sift_btn
                  CALL GET_FLDBUF(formonly.sift_fld) RETURNING g_siftfld
                  CALL GET_FLDBUF(formonly.sift_con) RETURNING g_siftcon
                  EXIT INPUT
               #No.TQC-860016 --start--
               ON IDLE ms_msg_sec
                  IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
                     CALL udmtree_detect_process() RETURNING li_result
                     IF (NOT li_result) THEN
                        LET ms_idle_sec = ms_idle_sec + ms_msg_sec
                        LET ls_remain_sec = g_idle_seconds - ms_idle_sec
                        IF ls_remain_sec < ms_msg_sec THEN
                           LET ms_msg_sec = ls_remain_sec
                        END IF
                        IF ms_idle_sec = g_idle_seconds THEN
                           LET ms_idle_sec = 0
                           LET ls_remain_sec = 0
                          #-CHI-980033-add-
                           IF g_idle_seconds < 3 THEN
                              LET ms_msg_sec = g_idle_seconds
                           ELSE
                              LET ms_msg_sec = g_idle_seconds / 3
                           END IF
                          #-CHI-980033-end-
                           IF ms_msg_sec > 180 THEN
                              LET ms_msg_sec = 180
                           END IF
                           CALL cl_on_idle()
                           CONTINUE INPUT
                        END IF
                     END IF
                  END IF
 
               ON ACTION help
                  CALL cl_show_help()
               ON ACTION controlg
                  CALL cl_cmdask()
               ON ACTION about
                  CALL cl_about()
               #No.TQC-860016 ---end---
            END INPUT
            CALL udmtree_search_result_01(g_select)
         WHEN "exit"
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION udmtree_chg_acttext(pc_prog01,pc_prog02)
   DEFINE pc_prog01       LIKE gaz_file.gaz01,
          pc_prog02       LIKE gaz_file.gaz01
   DEFINE lw_win          ui.Window,
          ln_win          om.DomNode
   DEFINE ln_menu         om.DomNode,
          ln_menuAction   om.DomNode
   DEFINE ll_menu         om.NodeList,
          ll_menuAction   om.NodeList
   DEFINE li_i            LIKE type_file.num10
   DEFINE lc_gaz03        LIKE gaz_file.gaz03
 
 
   LET lw_win = ui.Window.getCurrent()
   LET ln_win = lw_win.getNode()
 
   LET ll_menu = ln_win.selectByPath("//Menu[@text=\"udmtree_search_result\"]")
   LET ln_menu = ll_menu.item(1)
   IF ln_menu IS NULL THEN
      RETURN
   END IF
   LET ll_menuAction = ln_menu.selectByTagName("MenuAction")
   FOR li_i = 1 TO ll_menuAction.getLength()
       LET ln_menuAction = ll_menuAction.item(li_i)
       IF ln_menuAction.getAttribute("name") = "udmtree_search_act1" THEN
          LET g_sql = "SELECT gaz03 FROM gaz_file ",
                      " WHERE gaz01 = '",pc_prog01 CLIPPED,"' AND gaz02 = '",g_lang,"'"
          PREPARE gaz03_pre_01 FROM g_sql
          EXECUTE gaz03_pre_01 INTO lc_gaz03
          CALL ln_menuAction.setAttribute("text", lc_gaz03 CLIPPED||"("||pc_prog01 CLIPPED||")")
       END IF
       IF ln_menuAction.getAttribute("name") = "udmtree_search_act2" THEN
          LET lc_gaz03 = ""
          LET g_sql = "SELECT gaz03 FROM gaz_file ",
                      " WHERE gaz01 = '",pc_prog02 CLIPPED,"' AND gaz02 = '",g_lang,"'"
          PREPARE gaz03_pre_02 FROM g_sql
          EXECUTE gaz03_pre_02 INTO lc_gaz03
          CALL ln_menuAction.setAttribute("text", lc_gaz03 CLIPPED||"("||pc_prog02 CLIPPED||")")
       END IF
   END FOR
END FUNCTION
 
FUNCTION udmtree_search_result_bp02()
   DEFINE   ls_url          STRING
   DEFINE   li_status       LIKE type_file.num10
   DEFINE   ls_msg_cnt      LIKE type_file.num5
   DEFINE   li_result       LIKE type_file.num5
   DEFINE   ls_remain_sec   LIKE type_file.num5
 
   DISPLAY ARRAY gr_file TO s_file.* ATTRIBUTE(UNBUFFERED)
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION accept
         IF l_ac > 0 THEN
            LET ls_url = "cp -f ",gr_file[l_ac].location,"/",gr_file[l_ac].file_name," ",FGL_GETENV("TEMPDIR"),"/."
            RUN ls_url
            LET ls_url = "chmod 666 ",FGL_GETENV("TEMPDIR"),"/",gr_file[l_ac].file_name," 2>/dev/null"
            RUN ls_url
            CALL gr_openfile.appendElement()
            LET gr_openfile[gr_openfile.getlength()]=FGL_GETENV("TEMPDIR"),"/",gr_file[l_ac].file_name
            LET ls_url = FGL_GETENV("FGLASIP") CLIPPED, "/tiptop/out/",gr_file[l_ac].file_name
            CALL ui.Interface.frontCall("standard",
                                        "execute",
                                        ["EXPLORER \"" || ls_url || "\"",0],
                                        [li_status])
         END IF
 
      ON IDLE ms_msg_sec
         SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
          WHERE gar02 = g_user AND gar06 = 'N'
         IF ls_msg_cnt > 0 THEN
            CALL user_getprocess() RETURNING li_result
            IF NOT li_result THEN
               CALL cl_cmdrun('p_load_msg')
            END IF
         END IF
         IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
            CALL udmtree_detect_process() RETURNING li_result
            IF (NOT li_result) THEN
               LET ms_idle_sec = ms_idle_sec + ms_msg_sec
               LET ls_remain_sec = g_idle_seconds - ms_idle_sec
               IF ls_remain_sec < ms_msg_sec THEN
                  LET ms_msg_sec = ls_remain_sec
               END IF
               IF ms_idle_sec = g_idle_seconds THEN
                  LET ms_idle_sec = 0
                  LET ls_remain_sec = 0
                 #-CHI-980033-add-
                  IF g_idle_seconds < 3 THEN
                     LET ms_msg_sec = g_idle_seconds
                  ELSE
                     LET ms_msg_sec = g_idle_seconds / 3
                  END IF
                 #-CHI-980033-end-
                  IF ms_msg_sec > 180 THEN
                     LET ms_msg_sec = 180
                  END IF
                  CALL cl_on_idle()
                  CONTINUE DISPLAY
               END IF
            END IF
         END IF
 
      ON ACTION controlg  #MOD-510103
        CALL cl_cmdask()
 
      ON ACTION about     #MOD-510103
        CALL cl_about()
 
      ON ACTION help      # H.說明 MOD-510103
        CALL cl_show_help()
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice = "exit"
         EXIT DISPLAY
   END DISPLAY
END FUNCTION
 
FUNCTION udmtree_search_result_01(pi_select)
   DEFINE   pi_select      LIKE type_file.num5
   DEFINE   lr_data        RECORD
               value       LIKE type_file.chr50,
               gcm05       LIKE gcm_file.gcm05,
               gaz03       LIKE gaz_file.gaz03,
               gcm06       LIKE gcm_file.gcm06,
               gcm07       LIKE gcm_file.gcm07
                           END RECORD
   DEFINE   li_result      LIKE type_file.num5
   DEFINE   lwin_curr      ui.Window
   DEFINE   lfrm_curr      ui.Form
   DEFINE   lnode_item     om.DomNode
   DEFINE   ls_text        STRING
   DEFINE   ls_gcm06_names STRING
   DEFINE   ls_gcm07_names STRING
   DEFINE   lc_gaq03       LIKE gaq_file.gaq03
 
 
   #選擇要顯示的類別後，更動title顯示
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()
   LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.value")
   IF lnode_item IS NOT NULL THEN
      LET ls_text = lnode_item.getAttribute("text")
      IF ls_text.getIndexOf("(",1) > 0 THEN
         LET ls_text = ls_text.subString("1",ls_text.getIndexOf("(",1)-1)
      END IF
      CALL lnode_item.setAttribute("text",ls_text||"("||gr_datagroup[pi_select].gaq03||")")
   END IF
 
   LET g_sql = "SELECT '',gcm05,'',gcm06,gcm07 FROM gcm_file",
               " WHERE gcm02 = '",g_cate,"'",
               "   AND gcm03 = '",gr_datagroup[pi_select].gcm03 CLIPPED,"'",
               "   AND gcm04 = '",gr_datagroup[pi_select].gcm04 CLIPPED,"'"
   PREPARE datagroup_pre FROM g_sql
   DECLARE datagroup_curs CURSOR FOR datagroup_pre
 
   CALL gr_data.clear()
   LET l_ac = 1
   LET li_result = TRUE
   FOREACH datagroup_curs INTO lr_data.*
      SELECT gaz03 INTO lr_data.gaz03 FROM gaz_file
       WHERE gaz01=lr_data.gcm05 AND gaz02=g_lang
 
      CASE
         WHEN (NOT cl_null(lr_data.gcm06)) AND (cl_null(lr_data.gcm07))
            IF cl_db_get_database_type() = "ORA" THEN
               LET g_sql = "SELECT ",gr_datagroup[pi_select].gcm04 CLIPPED," a,",
                                     lr_data.gcm06 CLIPPED," b",
                           "  FROM ",gr_datagroup[pi_select].gcm03 CLIPPED,
                           " WHERE ",gr_datagroup[pi_select].gcm04 CLIPPED,
                           "  LIKE '%",g_where,"%'"
               IF (NOT cl_null(g_siftfld)) AND (NOT cl_null(g_siftcon)) THEN
                  CASE g_siftfld
                     WHEN "1"
                        LET gr_datagroup[pi_select].siftwhere =
                                          gr_datagroup[pi_select].siftwhere,
                                          " AND ",gr_datagroup[pi_select].gcm04 CLIPPED,
                                          " LIKE '%",g_siftcon,"%'"
                     WHEN "2"
                        LET gr_datagroup[pi_select].siftwhere =
                                          gr_datagroup[pi_select].siftwhere,
                                          " AND ",lr_data.gcm06 CLIPPED,
                                          " LIKE '%",g_siftcon,"%'"
                  END CASE
               END IF
               LET g_sql = g_sql,gr_datagroup[pi_select].siftwhere," ORDER BY a,b"
            ELSE
               LET g_sql = "SELECT ",gr_datagroup[pi_select].gcm04 CLIPPED," a,",
                                     lr_data.gcm06 CLIPPED," b",
                           "  FROM ",gr_datagroup[pi_select].gcm03 CLIPPED,
                           " WHERE ",gr_datagroup[pi_select].gcm04 CLIPPED,
                           "  MATCHES '*",g_where,"*'"
               IF (NOT cl_null(g_siftfld)) AND (NOT cl_null(g_siftcon)) THEN
                  CASE g_siftfld
                     WHEN "1"
                        LET gr_datagroup[pi_select].siftwhere =
                                          gr_datagroup[pi_select].siftwhere,
                                          " AND ",gr_datagroup[pi_select].gcm04 CLIPPED,
                                          " MATCHES '*",g_siftcon,"*'"
                     WHEN "2"
                        LET gr_datagroup[pi_select].siftwhere =
                                          gr_datagroup[pi_select].siftwhere,
                                          " AND ",lr_data.gcm06 CLIPPED,
                                          " MATCHES '*",g_siftcon,"*'"
                  END CASE
               END IF
               LET g_sql = g_sql,gr_datagroup[pi_select].siftwhere," ORDER BY a,b"
            END IF
            DISPLAY "SelectSQL:",g_sql
            PREPARE prog1_pre FROM g_sql
            DECLARE prog1_curs CURSOR FOR prog1_pre
            FOREACH prog1_curs INTO gr_data[l_ac].value,gr_data[l_ac].gcm06
               LET gr_data[l_ac].gcm05 = lr_data.gcm05
               LET gr_data[l_ac].gaz03 = lr_data.gaz03
               LET l_ac = l_ac + 1
               IF l_ac > g_max_rec THEN
                  CALL cl_err( '', 9035, 0 )
                  LET li_result = FALSE
                  EXIT FOREACH
               END IF
            END FOREACH
            CALL gr_data.deleteElement(l_ac)
 
            #置換gcm06,gcm07的title顯示
            SELECT gaq03 INTO lc_gaq03 FROM gaq_file
             WHERE gaq01=lr_data.gcm06 AND gaq02=g_lang
            LET ls_gcm06_names = ls_gcm06_names,lc_gaq03,"/"  #No.MOD-750003
            LET ls_gcm07_names = "NULL"
         WHEN (NOT cl_null(lr_data.gcm06)) AND (NOT cl_null(lr_data.gcm07))
            IF cl_db_get_database_type() = "ORA" THEN
               LET g_sql = "SELECT ",gr_datagroup[pi_select].gcm04 CLIPPED," a,",
                                     lr_data.gcm06 CLIPPED," b,",
                                     lr_data.gcm07 CLIPPED," c",
                           "  FROM ",gr_datagroup[pi_select].gcm03 CLIPPED,
                           " WHERE ",gr_datagroup[pi_select].gcm04 CLIPPED,
                           "  LIKE '%",g_where,"%' "
               IF (NOT cl_null(g_siftfld)) AND (NOT cl_null(g_siftcon)) THEN
                  CASE g_siftfld
                     WHEN "1"
                        LET gr_datagroup[pi_select].siftwhere =
                                          gr_datagroup[pi_select].siftwhere,
                                          " AND ",gr_datagroup[pi_select].gcm04 CLIPPED,
                                          " LIKE '%",g_siftcon,"%'"
                     WHEN "2"
                        LET gr_datagroup[pi_select].siftwhere =
                                          gr_datagroup[pi_select].siftwhere,
                                          " AND ",lr_data.gcm06 CLIPPED,
                                          " LIKE '%",g_siftcon,"%'"
                  END CASE
               END IF
               LET g_sql = g_sql,gr_datagroup[pi_select].siftwhere," ORDER BY a,b,c"
            ELSE
               LET g_sql = "SELECT ",gr_datagroup[pi_select].gcm04 CLIPPED," a,",
                                     lr_data.gcm06 CLIPPED," b,",
                                     lr_data.gcm07 CLIPPED," c",
                           "  FROM ",gr_datagroup[pi_select].gcm03 CLIPPED,
                           " WHERE ",gr_datagroup[pi_select].gcm04 CLIPPED,
                           "  MATCHES '*",g_where,"*' "
               IF (NOT cl_null(g_siftfld)) AND (NOT cl_null(g_siftcon)) THEN
                  CASE g_siftfld
                     WHEN "1"
                        LET gr_datagroup[pi_select].siftwhere =
                                          gr_datagroup[pi_select].siftwhere,
                                          " AND ",gr_datagroup[pi_select].gcm04 CLIPPED,
                                          " MATCHES '*",g_siftcon,"*'"
                     WHEN "2"
                        LET gr_datagroup[pi_select].siftwhere =
                                          gr_datagroup[pi_select].siftwhere,
                                          " AND ",lr_data.gcm06 CLIPPED,
                                          " MATCHES '*",g_siftcon,"*'"
                  END CASE
               END IF
               LET g_sql = g_sql,gr_datagroup[pi_select].siftwhere," ORDER BY a,b,c"
            END IF
            DISPLAY "SelectSQL:",g_sql
            PREPARE prog2_pre FROM g_sql
            DECLARE prog2_curs CURSOR FOR prog2_pre
            FOREACH prog2_curs INTO gr_data[l_ac].value,gr_data[l_ac].gcm06,gr_data[l_ac].gcm07
               LET gr_data[l_ac].gcm05 = lr_data.gcm05
               LET gr_data[l_ac].gaz03 = lr_data.gaz03
               LET l_ac = l_ac + 1
               IF l_ac > g_max_rec THEN
                  CALL cl_err( '', 9035, 0 )
                  LET li_result = FALSE
                  EXIT FOREACH
               END IF
            END FOREACH
            CALL gr_data.deleteElement(l_ac)
 
            #置換gcm06,gcm07的title顯示
            SELECT gaq03 INTO lc_gaq03 FROM gaq_file
             WHERE gaq01=lr_data.gcm06 AND gaq02=g_lang
            LET ls_gcm06_names = ls_gcm06_names,lc_gaq03,"/"   #No.MOD-750003
            SELECT gaq03 INTO lc_gaq03 FROM gaq_file
             WHERE gaq01=lr_data.gcm07 AND gaq02=g_lang
            LET ls_gcm07_names = ls_gcm07_names,lc_gaq03,"/"   #No.MOD-750003
      END CASE 
      IF NOT li_result THEN
         EXIT FOREACH
      END IF
   END FOREACH
 
   #選擇要顯示的類別後，更動title顯示
   LET ls_gcm06_names = ls_gcm06_names.subString(1,ls_gcm06_names.getLength()-1) #No.MOD-750003
   LET ls_gcm07_names = ls_gcm07_names.subString(1,ls_gcm07_names.getLength()-1) #No.MOD-750003
   LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.gcm06")
   IF lnode_item IS NOT NULL THEN
      LET ls_text = lnode_item.getAttribute("text")
      IF ls_text.getIndexOf("(",1) > 0 THEN
         LET ls_text = ls_text.subString("1",ls_text.getIndexOf("(",1)-1)
      END IF
      CALL lnode_item.setAttribute("text",ls_text||"("||ls_gcm06_names||")")
   END IF
   LET lnode_item = lfrm_curr.findNode("TableColumn","formonly.gcm07")
   IF lnode_item IS NOT NULL THEN
      LET ls_text = lnode_item.getAttribute("text")
      IF ls_text.getIndexOf("(",1) > 0 THEN
         LET ls_text = ls_text.subString("1",ls_text.getIndexOf("(",1)-1)
      END IF
      CALL lnode_item.setAttribute("text",ls_text||"("||ls_gcm07_names||")")
   END IF
END FUNCTION
 
FUNCTION udmtree_search_result_02()
   DEFINE   ls_cmd       STRING
   DEFINE   li_result    LIKE type_file.num5
   DEFINE   lc_channel   base.Channel
   DEFINE   l_ac         LIKE type_file.num5
   DEFINE   ls_result    STRING
   DEFINE   ls_tmp_str   STRING
   DEFINE   li_pos       LIKE type_file.num5
   DEFINE   ls_file      STRING
   DEFINE   li_file_ln   LIKE type_file.num10
   DEFINE   li_result2   LIKE type_file.num5
 
 
   LET ls_file = FGL_GETENV("TEMPDIR"),"/",g_udmtree_pid,"_udmtree_search_file.txt"
   IF NOT cl_null(g_filename) THEN
      CALL cl_replace_str(g_filename,","," -o -name ") RETURNING g_filename
     #LET ls_cmd = "cd $TOP;find ",g_filepath," -name ",g_filename," -type f > ",ls_file," 2>/dev/null"   #FUN-B30176 mark
      LET ls_cmd = "cd ",FGL_GETENV("TOP"),";find ",g_filepath," -name ",g_filename," -type f > ",ls_file," 2>", #FUN-B30176
                   os.Path.separator(),"dev",os.Path.separator(),"null"              #FUN-B30176
      RUN ls_cmd
   ELSE
     #LET ls_cmd = "cd $TOP;find ",g_filepath," -name '*.*' -type f > ",ls_file," 2>/dev/null"   #FUN-B30176 mark
      LET ls_cmd = "cd ",FGL_GETENV("TOP"),";find ",g_filepath," -name '*.*' -type f > ",ls_file," 2>",   #FUN-B30176
                   os.Path.separator(),"dev",os.Path.separator(),"null"        #FUN-B30176
      RUN ls_cmd
   END IF
 
   LET lc_channel = base.Channel.create()
   LET ls_cmd = "wc -l ",ls_file
   CALL lc_channel.openPipe(ls_cmd,"r")
   CALL lc_channel.setDelimiter("")
   WHILE lc_channel.read(ls_result)
      LET ls_tmp_str = ls_result.subString(1,ls_result.getIndexOf(ls_file,1)-2)
      LET li_file_ln = ls_tmp_str
   END WHILE
   CALL lc_channel.close()
 
   IF li_file_ln > 0 THEN
      CALL cl_progress_bar(li_file_ln)
   END IF
   LET lc_channel = base.Channel.create()
   LET ls_cmd = "cat ",ls_file
   CALL lc_channel.openPipe(ls_cmd,"r")
   CALL lc_channel.setDelimiter("")
 
   CALL gr_file.clear()
   LET li_result2 = TRUE
   LET l_ac = 1
   WHILE lc_channel.read(ls_result)
      CALL cl_progressing("檔案搜尋中")
      IF NOT cl_null(g_where) THEN
         IF l_ac > g_max_rec THEN
            LET li_result2 = FALSE
            CONTINUE WHILE
         ELSE
            LET ls_cmd = "grep -nil '",g_where,"' ",ls_result," 2>/dev/null"
            RUN ls_cmd RETURNING li_result
            IF NOT li_result THEN
               LET ls_tmp_str = ls_result
               WHILE ls_tmp_str.getIndexOf("/",1)
                  LET li_pos = ls_tmp_str.getIndexOf("/",1)
                  LET ls_tmp_str = ls_tmp_str.subString(li_pos+1,ls_tmp_str.getLength())
               END WHILE
               LET gr_file[l_ac].file_name = ls_tmp_str
               LET gr_file[l_ac].location  = ls_result.subString(1,ls_result.getLength()-ls_tmp_str.getLength()-1)
               LET l_ac = l_ac + 1
            END IF
         END IF
      ELSE
         IF l_ac > g_max_rec THEN
            LET li_result2 = FALSE
            CONTINUE WHILE
         ELSE
            LET ls_tmp_str = ls_result
            WHILE ls_tmp_str.getIndexOf("/",1)
               LET li_pos = ls_tmp_str.getIndexOf("/",1)
               LET ls_tmp_str = ls_tmp_str.subString(li_pos+1,ls_tmp_str.getLength())
            END WHILE
            LET gr_file[l_ac].file_name = ls_tmp_str
            LET gr_file[l_ac].location  = ls_result.subString(1,ls_result.getLength()-ls_tmp_str.getLength()-1)
            LET l_ac = l_ac + 1
         END IF
      END IF
   END WHILE
   IF NOT li_result2 THEN
      CALL cl_err('',9035,0)
   END IF
   CALL lc_channel.close()
END FUNCTION
 
FUNCTION udmtree_showdata(pc_gcm03,pc_gcm04,p_ac)
   DEFINE   pc_gcm03        LIKE gcm_file.gcm03,
            pc_gcm04        LIKE gcm_file.gcm04,
            p_ac            LIKE type_file.num5
   DEFINE   lr_zta          RECORD LIKE zta_file.*
   DEFINE   ls_msg_cnt      LIKE type_file.num5
   DEFINE   li_result       LIKE type_file.num5
   DEFINE   ls_remain_sec   LIKE type_file.num5
 
 
   SELECT * INTO lr_zta.* FROM zta_file
    WHERE zta01=pc_gcm03 AND zta02=g_dbs

   #---FUN-AC0036---start-----
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #目前統一用sch_file紀錄TIPTOP資料結構
   #IF lr_zta.zta07 = 'S' THEN
   #   IF cl_db_get_database_type()="IFX" THEN
   #      LET g_sql="SELECT colname,gaq03",
   #                "  FROM ",lr_zta.zta17 CLIPPED,":systables a,",
   #                          lr_zta.zta17 CLIPPED,":syscolumns b,OUTER ",
   #                          lr_zta.zta17 CLIPPED,":sysdefaults c,",
   #                " OUTER gaq_file",
   #                " WHERE tabname='",lr_zta.zta01 CLIPPED,"'",
   #                "   AND a.tabid=b.tabid",
   #                "   AND b.tabid=c.tabid",
   #                "   AND b.colno=c.colno",
   #                "   AND colname=gaq01 ",
   #                "   AND gaq02='",g_lang CLIPPED,"' ",
   #                " ORDER BY b.colname"
   #   ELSE
   #      LET g_sql="SELECT lower(column_name),gaq03",
   #                "  FROM all_tab_columns, gaq_file",
   #                " WHERE lower(table_name)='",lr_zta.zta01,"'",
   #                "   AND lower(column_name)=gaq01 (+) ",
   #                "   AND gaq02(+)='",g_lang CLIPPED,"' ",
   #                "   AND lower(owner)='",lr_zta.zta17 CLIPPED,"'",
   #                " ORDER BY column_name"
   #   END IF
   #ELSE
   #   IF cl_db_get_database_type()="IFX" THEN
   #      LET g_sql="SELECT colname,gaq03",
   #                "  FROM systables a,syscolumns b,OUTER sysdefaults c,",
   #                " OUTER gaq_file",
   #                " WHERE tabname='",lr_zta.zta01 CLIPPED,"'",
   #                "   AND a.tabid=b.tabid",
   #                "   AND b.tabid=c.tabid",
   #                "   AND b.colno=c.colno",
   #                "   AND colname=gaq01 ",
   #                "   AND gaq02='",g_lang CLIPPED,"' ",
   #                " ORDER BY b.colname"
   #   ELSE
   #      LET g_sql="SELECT lower(column_name),gaq03",
   #                "  FROM user_tab_columns, gaq_file",
   #                " WHERE lower(table_name)='",lr_zta.zta01 CLIPPED,"'",
   #                "   AND lower(column_name)=gaq01 (+) ",
   #                "   AND gaq02(+)='",g_lang CLIPPED,"' ",
   #                " ORDER BY column_name"
   #   END IF
   #END IF
   LET g_sql = "SELECT sch02, gaq03 ",
               "  FROM sch_file, gaq_file ",
               " WHERE sch01 = '",lr_zta.zta01 CLIPPED,"' ",
               "   AND sch02 = gaq01 ",
               "   AND gaq02 = '",g_lang CLIPPED,"' ",
               " ORDER BY sch02"
   #---FUN-AC0036---end-------
   DECLARE field_curs CURSOR FROM g_sql
 
   CALL gr_showdata.clear()
   LET l_ac = 1
   FOREACH field_curs INTO gr_showdata[l_ac].gaq01,gr_showdata[l_ac].gaq03
      LET l_ac = l_ac + 1
   END FOREACH
   CALL gr_showdata.deleteElement(l_ac)
 
   LET g_sql = "SELECT ROWID FROM ",pc_gcm03 CLIPPED,
               " WHERE ",pc_gcm04 CLIPPED,"='",gr_data[p_ac].value,"'"
   PREPARE data_pre FROM g_sql
   DECLARE data_curs SCROLL CURSOR FOR data_pre
   OPEN data_curs
   IF SQLCA.sqlcode THEN
      RETURN FALSE
   END IF
 
   OPEN WINDOW showdata_w WITH FORM "azz/42f/udmtree_showdbdata"
      ATTRIBUTE(STYLE="create_qry")
   CALL cl_ui_locale("udmtree_showdbdata")
 
   DISPLAY ARRAY gr_showdata TO s_showdata.* ATTRIBUTE(UNBUFFERED)
      BEFORE DISPLAY
         CALL udmtree_showdata_fetch("F",pc_gcm03 CLIPPED) RETURNING li_result
         IF NOT li_result THEN
            CALL cl_err("Search Data:",SQLCA.sqlcode,0)
         END IF
      ON ACTION previous
         CALL udmtree_showdata_fetch("P",pc_gcm03 CLIPPED) RETURNING li_result
         IF NOT li_result THEN
            CALL cl_err("Search Data:",SQLCA.sqlcode,0)
         END IF
      ON ACTION next
         CALL udmtree_showdata_fetch("N",pc_gcm03 CLIPPED) RETURNING li_result
         IF NOT li_result THEN
            CALL cl_err("Search Data:",SQLCA.sqlcode,0)
         END IF
      ON IDLE ms_msg_sec
         SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
          WHERE gar02 = g_user AND gar06 = 'N'
         IF ls_msg_cnt > 0 THEN
            CALL user_getprocess() RETURNING li_result
            IF NOT li_result THEN
               CALL cl_cmdrun('p_load_msg')
            END IF
         END IF
         IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN #No.FUN-590112
            CALL udmtree_detect_process() RETURNING li_result
            IF (NOT li_result) THEN
               LET ms_idle_sec = ms_idle_sec + ms_msg_sec
               LET ls_remain_sec = g_idle_seconds - ms_idle_sec
               IF ls_remain_sec < ms_msg_sec THEN
                  LET ms_msg_sec = ls_remain_sec
               END IF
               IF ms_idle_sec = g_idle_seconds THEN
                  LET ms_idle_sec = 0
                  LET ls_remain_sec = 0
                 #-CHI-980033-add-
                  IF g_idle_seconds < 3 THEN
                     LET ms_msg_sec = g_idle_seconds
                  ELSE
                     LET ms_msg_sec = g_idle_seconds / 3
                  END IF
                 #-CHI-980033-end-
                  IF ms_msg_sec > 180 THEN
                     LET ms_msg_sec = 180
                  END IF
                  CALL cl_on_idle()
                  CONTINUE DISPLAY
               END IF
            END IF
         END IF
 
      ON ACTION controlg  #MOD-510103
        CALL cl_cmdask()
 
      ON ACTION about     #MOD-510103
        CALL cl_about()
 
      ON ACTION help      # H.說明 MOD-510103
        CALL cl_show_help()
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice = "exit"
         EXIT DISPLAY
   END DISPLAY
 
   CLOSE WINDOW showdata_w
END FUNCTION
 
FUNCTION udmtree_showdata_fetch(pc_ud,pc_tableid)
   DEFINE   pc_ud        LIKE type_file.chr1
   DEFINE   pc_tableid   LIKE gcm_file.gcm03
   DEFINE   li_rowid_ifx LIKE type_file.num10
   DEFINE   lc_rowid_ora LIKE type_file.chr18 # saki 20070821 rowid chr18 -> num10   #No.TQC-950134
   DEFINE   lc_value     LIKE type_file.chr1000
   DEFINE   li_i         LIKE type_file.num5
 
   CASE pc_ud
      WHEN "F"
         IF cl_db_get_database_type()="ORA" THEN
            FETCH FIRST data_curs INTO lc_rowid_ora
         ELSE
            FETCH FIRST data_curs INTO li_rowid_ifx
         END IF
      WHEN "P"
         IF cl_db_get_database_type()="ORA" THEN
            FETCH PREVIOUS data_curs INTO lc_rowid_ora
         ELSE
            FETCH PREVIOUS data_curs INTO li_rowid_ifx
         END IF
      WHEN "N"
         IF cl_db_get_database_type()="ORA" THEN
            FETCH NEXT data_curs INTO lc_rowid_ora
         ELSE
            FETCH NEXT data_curs INTO li_rowid_ifx
         END IF
   END CASE
   IF SQLCA.sqlcode THEN
      RETURN FALSE
   END IF
   IF cl_db_get_database_type()="ORA" THEN
      FOR li_i = 1 TO gr_showdata.getLength()
          LET g_sql = "SELECT ",gr_showdata[li_i].gaq01 CLIPPED,
                      "  FROM ",pc_tableid CLIPPED,
                      " WHERE ROWID = '",lc_rowid_ora,"'"
          PREPARE showdata_ora_pre FROM g_sql
          EXECUTE showdata_ora_pre INTO lc_value
          LET gr_showdata[li_i].value = lc_value
      END FOR
   ELSE
      FOR li_i = 1 TO gr_showdata.getLength()
          LET g_sql = "SELECT ",gr_showdata[li_i].gaq01 CLIPPED,
                      "  FROM ",pc_tableid CLIPPED,
                      " WHERE ROWID = ",li_rowid_ifx
          PREPARE showdata_ifx_pre FROM g_sql
          EXECUTE showdata_ifx_pre INTO lc_value
          LET gr_showdata[li_i].value = lc_value
      END FOR
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION udmtree_close()
   DEFINE   ls_cmd       STRING
   DEFINE   li_result    LIKE type_file.num5
   DEFINE   li_i         LIKE type_file.num10
 
   LET ls_cmd = "test -s ",FGL_GETENV("TEMPDIR"),"/",g_udmtree_pid,"_udmtree_search_file.txt"
   RUN ls_cmd RETURNING li_result
   IF NOT li_result THEN
      LET ls_cmd = "rm ",FGL_GETENV("TEMPDIR"),"/",g_udmtree_pid,"_udmtree_search_file.txt"
      RUN ls_cmd
   END IF
 
   FOR li_i = 1 TO gr_openfile.getLength()
       LET ls_cmd = "rm ",gr_openfile[li_i]
       RUN ls_cmd
   END FOR
END FUNCTION
#No.FUN-570225 ---end---

#FUN-880099 ---start---
FUNCTION udmtree_ef_action()
   LET g_curr_page = 1
   LET g_total_page = 1
   IF g_aza.aza23 matches '[ Nn]' THEN   #未設定與 EasyFlow 簽核
         LET g_status = 0
         CALL cl_set_act_visible("go,selectbox,efrefresh",FALSE)
         CALL cl_err('aza23','mfg3551',1)
   ELSE
       IF (NOT g_status) OR g_status IS NULL THEN
         LET g_forminfo = "Inbox"
         LET g_strfilter = "ALL"
         LET g_intfilter = "2"
         CALL aws_efapp_formID() RETURNING g_status                  
       END IF
       
   	   IF g_aza.aza72 = "Y" THEN
   	   	  LET g_intfilter = "ALL"
   	   	  CALL udmtree_efgpmenu()
   	   ELSE
   	   	  CALL cl_set_comp_visible("ef11,ef12,ef13,ef14,ef15",FALSE)
   	  	  CALL udmtree_efmenu()
   	   END IF       
   END IF
  
END FUNCTION

FUNCTION udmtree_efgpmenu()
   DEFINE l_i               LIKE type_file.num10,  #INTEGER
          l_tag             STRING,
          l_p1              LIKE type_file.num10,  #INTEGER
          l_p2              LIKE type_file.num10,  #INTEGER
          l_g_formNum       STRING,
          l_wc              STRING
   DEFINE l_formNum         LIKE type_file.chr20   #CHAR(20)
   DEFINE l_argv            STRING   
   DEFINE l_FormOwnerID     LIKE gen_file.gen01
   DEFINE l_FormCreatorID   LIKE gen_file.gen01
   DEFINE l_wse02      LIKE wse_file.wse02,
          l_wse03      LIKE wse_file.wse03,
          l_wse10      LIKE wse_file.wse10,
          l_sql        STRING,
          l_status     LIKE type_file.chr1
  
  CASE g_forminfo
     WHEN "Inbox"
           CALL cl_set_comp_visible("intfilter_gp",FALSE)
     WHEN "Info"
           CALL cl_set_comp_visible("intfilter_gp",TRUE)
     WHEN "Sent"
           CALL cl_set_comp_visible("intfilter_gp",FALSE)
  END CASE

  DISPLAY g_forminfo TO forminfo_gp
  DISPLAY g_strfilter TO strfilter_gp
  DISPLAY g_intfilter TO intfilter_gp

  LET l_ac = 1

  WHILE TRUE
     CALL udmtree_efgpmenu_bp("G")
     CASE g_action_choice
          WHEN "selectbox"
             CALL udmtree_efgpmenu_i()
          WHEN "detail"
             IF g_efgp.getLength() > 0 THEN
                LET g_sql = "DELETE FROM wsk_file ",
                            " WHERE wsk01='",fgl_getenv('FGLSERVER') CLIPPED,"'",
                            "   AND wsk02='",g_user CLIPPED,"'",
                            "   AND wsk03='",g_efgp[l_ac].ef23 CLIPPED,"'",
                            "   AND wsk05='",g_efgp[l_ac].ef22 CLIPPED,"'"
                             
                EXECUTE IMMEDIATE g_sql 

                LET l_FormCreatorID = aws_efapp_getid(g_efgp[l_ac].ef33) 
                LET l_FormOwnerID = aws_efapp_getid(g_efgp[l_ac].ef26) 

                LET g_sql2 = "INSERT INTO wsk_file",
                            "(wsk01,wsk02,wsk03,wsk04,wsk05,wsk06,wsk07,wsk08,wsk09,wsk10,wsk11,wsk12,wsk13,wsk14,wsk16) VALUES('",
                            fgl_getenv('FGLSERVER') CLIPPED,"','",
                            g_user CLIPPED,"','", g_efgp[l_ac].ef23 CLIPPED,"','",
                            g_efgp[l_ac].ef21 CLIPPED,"','", g_efgp[l_ac].ef22 CLIPPED,"','",
                            l_FormCreatorID CLIPPED,"','", l_FormOwnerID CLIPPED,"','", 
                            g_efgp[l_ac].ef24 CLIPPED,"','", g_efgp[l_ac].ef31 CLIPPED,"'",                           
                            " ,'','','','','", g_forminfo CLIPPED, "','", g_efgp[l_ac].ef35 CLIPPED,"')"

                PREPARE insert_prep2 FROM g_sql2
                EXECUTE insert_prep2
                IF STATUS THEN
                   CALL cl_err3("ins","wsk_file",fgl_getenv('FGLSEVER'),g_user,SQLCA.sqlcode,"","insert_prep",1)
                ELSE
                   LET mi_easyflow_trigger = TRUE
                   LET g_cmd = g_efgp[l_ac].ef23 CLIPPED

                   FOR l_i = 1 TO 5
                     LET l_argv = aws_efapp_key_value(g_efgp[l_ac].ef22 CLIPPED,l_i)
                     IF NOT cl_null(l_argv) OR l_argv != "" THEN
                        LET g_cmd = g_cmd ," '",l_argv CLIPPED,"'"
                     ELSE
                        EXIT FOR
                     END IF
                   END FOR

                   CALL FGL_SETENV("SourceFormNum",g_efgp[l_ac].ef22 CLIPPED) 

                   SELECT wse02,wse03,wse10 
                     INTO l_wse02,l_wse03,l_wse10 
                      FROM wse_file 
                     WHERE wse01 = g_efgp[l_ac].ef23 

                   CALL aws_efapp_wc_key(g_efgp[l_ac].ef22) RETURNING l_wc 

                   IF LENGTH(l_wc) != 0 THEN
                      LET l_g_formNum = aws_efapp_key(g_efgp[l_ac].ef22,1)
                   ELSE
                      LET l_g_formNum = g_efgp[l_ac].ef22 
                   END IF

                   LET l_sql = " SELECT ",l_wse10 CLIPPED," FROM ",l_wse02 CLIPPED,
                               "  WHERE ",l_wse03 CLIPPED," = '",l_g_formNum CLIPPED,"'"
                   
                   IF LENGTH(l_wc) != 0 THEN
                      LET l_sql = l_sql CLIPPED, l_wc
                   END IF

                   DECLARE wse_c2 CURSOR FROM l_sql
                   OPEN wse_c2
                   FETCH wse_c2 INTO l_status

                   IF (g_forminfo='Inbox' OR g_forminfo='Sent') AND l_status='0' THEN 
                       CALL cl_err('','aws-516',1)
                   ELSE
                       CALL cl_cmdrun_wait(g_cmd)
                   END IF

                   LET mi_easyflow_trigger = FALSE

                   EXECUTE IMMEDIATE g_sql 

                END IF
             END IF
          WHEN "exit"                            # Esc.結束
             EXIT WHILE

     END CASE
     IF g_action_choice = "exit" THEN
        EXIT WHILE
     END IF
  END WHILE
END FUNCTION

FUNCTION udmtree_efgpmenu_bp(p_ud)
  DEFINE li_result      LIKE type_file.num5   #SMALLINT
  DEFINE ls_remain_sec  LIKE type_file.num5   #SMALLINT
  DEFINE ls_msg_cnt     LIKE type_file.num5   #SMALLINT
  DEFINE p_ud           LIKE type_file.chr1   #CHAR(1)
  DEFINE l_formkind     LIKE type_file.chr1000 
  
  LET g_action_choice = " "

  CALL cl_set_comp_visible("ef25,ef27,ef28,ef29,ef30,ef32,ef33,ef331,ef34,ef36,ef37",TRUE)
  CASE g_forminfo
     WHEN "Inbox"           
           CALL cl_set_comp_visible("ef21,ef22,ef23,ef24,ef26,ef31,ef331,ef32,ef35",FALSE)
           LET l_formkind = "PerformableWorkItems"   # 收件匣(待辦工作事項)        
     WHEN "Info"
           CALL cl_set_comp_visible("ef21,ef22,ef23,ef24,ef26,ef27,ef31,ef331,ef32,ef35",FALSE)
           LET l_formkind = "NoticeWorkItems"        # 通知匣
     WHEN "Sent"
           CALL cl_set_comp_visible("ef21,ef22,ef23,ef24,ef25,ef26,ef29,ef31,ef33,ef331,ef34,ef35,ef37",FALSE)
           LET l_formkind = "AbortableProcesses"     # 原稿匣(可撤銷流程)           
     WHEN "Withdraw"
           CALL cl_set_comp_visible("ef21,ef22,ef23,ef24,ef25,ef26,ef27,ef31,ef34,ef35,ef37",FALSE)          
           LET l_formkind = "RollackableWorkItems"   # 可取回重辦工作           
  END CASE
  WHILE TRUE
      CALL g_efgp.clear()
      IF g_status THEN        
         CALL aws_efgpapp_formInfo(g_efgp,l_formkind, g_intfilter, g_strfilter,g_curr_page,'15')
           RETURNING g_status,g_curr_page,g_total_page
           IF g_efgp.getLength() = 0 THEN
                 CALL cl_err('','mfg3382',1)
           END IF
      END IF

      DISPLAY g_total_page TO FORMONLY.total_gp
      DISPLAY g_curr_page TO FORMONLY.curr_gp

     # 因為此支程式特殊會產生兩個dialog,所以無法完全鎖上accept,在此自己上鎖
     CALL udmtree_set_act_visible("accept",FALSE)

     DISPLAY ARRAY g_efgp TO  s_efgp.*
        BEFORE DISPLAY
           CALL udmtree_efmenu_disableAction(DIALOG)
           CALL udmtree_efmenu_nodisableAction(DIALOG)

        ON ACTION selectbox
           LET g_action_choice="selectbox"
           LET INT_FLAG = 1
           EXIT DISPLAY

        ON ACTION  efrefresh
           EXIT DISPLAY
          
        ON ACTION accept
           IF ARR_COUNT() = 0 THEN
                CONTINUE DISPLAY
           END IF
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           LET INT_FLAG = 1
           EXIT DISPLAY


        ON ACTION first_page   # Jump to First Page
            LET g_curr_page = 1
            EXIT DISPLAY

        ON ACTION next_page    # Jump to Next Page
            LET g_curr_page = g_curr_page + 1
            EXIT DISPLAY

        ON ACTION prev_page    # Jump to Previous Page
            LET g_curr_page = g_curr_page - 1
            EXIT DISPLAY

        ON ACTION last_page    # Jump to Last Page
            LET g_curr_page = g_total_page
            EXIT DISPLAY

         ON ACTION locale
            CALL cl_dynamic_locale()
            EXIT DISPLAY

         ON ACTION exit                   # Esc.結束
            CALL udmtree_exit_confirm()  

         ON ACTION cancel
            LET INT_FLAG=FALSE
            CALL udmtree_exit_confirm()  

        ON ACTION info
           LET g_action_choice = "exit"
           LET INT_FLAG = 1
           EXIT DISPLAY

        ON ACTION system_flow
           LET g_action_choice = "exit"
           LET INT_FLAG = 1
           EXIT DISPLAY

        ON ACTION so_flow
           LET g_action_choice = "exit"
           LET INT_FLAG = 1
           EXIT DISPLAY

        ON ACTION needproc                    
           CALL udmtree_needproc_b_fill()
           CALL udmtree_needproc()
           LET g_action_choice = "exit"
           LET INT_FLAG = 1
           EXIT DISPLAY

        ON ACTION search
           CALL udmtree_search()
           LET g_action_choice = "exit"
           LET INT_FLAG = 1
           EXIT DISPLAY

        ON IDLE ms_msg_sec
           SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
            WHERE gar02 = g_user AND gar06 = 'N'
           IF ls_msg_cnt > 0 THEN
              CALL user_getprocess() RETURNING li_result
              IF NOT li_result THEN
                 CALL cl_cmdrun('p_load_msg')
              END IF
           END IF
           IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN 
              CALL udmtree_detect_process() RETURNING li_result
              IF (NOT li_result) THEN
                 LET ms_idle_sec = ms_idle_sec + ms_msg_sec
                 LET ls_remain_sec = g_idle_seconds - ms_idle_sec
                 IF ls_remain_sec < ms_msg_sec THEN
                    LET ms_msg_sec = ls_remain_sec
                 END IF
                 IF ms_idle_sec = g_idle_seconds THEN
                    LET ms_idle_sec = 0
                    LET ls_remain_sec = 0

                    IF g_idle_seconds < 3 THEN
                       LET ms_msg_sec = g_idle_seconds
                    ELSE
                       LET ms_msg_sec = g_idle_seconds / 3
                    END IF

                    IF ms_msg_sec > 180 THEN
                       LET ms_msg_sec = 180
                    END IF
                    CALL cl_on_idle()
                    CONTINUE DISPLAY
                 END IF
              END IF
           END IF


         ON ACTION controlg 
           CALL cl_cmdask()

         ON ACTION about
           CALL cl_about()

         ON ACTION help      # H.說明 
           CALL cl_show_help()

     END DISPLAY
     CALL udmtree_set_act_visible("accept",TRUE)
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF

  END WHILE
 # CALL cl_set_act_visible("accept,cancel", TRUE)
  MESSAGE ''
END FUNCTION

FUNCTION udmtree_efgpmenu_i()
DEFINE li_result       LIKE type_file.num5   #SMALLINT 
DEFINE ls_remain_sec   LIKE type_file.num5   #SMALLINT 
DEFINE ls_msg_cnt      LIKE type_file.num5   #SMALLINT
DEFINE l_p1            LIKE type_file.num10  #INTEGER
DEFINE l_forminfo_t    LIKE wsk_file.wsk14,  #CHAR(50)
      l_strfilter_t    LIKE type_file.chr50, #CHAR(50)
      l_intfilter_t    LIKE type_file.chr50  #CHAR(50)


    CALL cl_set_act_visible("accept,cancel", FALSE)

    LET l_forminfo_t = g_forminfo
    LET l_strfilter_t = g_strfilter
    LET l_intfilter_t = g_intfilter
    DISPLAY g_forminfo,g_strfilter,g_intfilter TO forminfo_gp,strfilter_gp,intfilter_gp

    INPUT g_forminfo,g_strfilter,g_intfilter WITHOUT DEFAULTS
           FROM forminfo_gp,strfilter_gp,intfilter_gp ATTRIBUTE(UNBUFFERED)

      ON CHANGE forminfo_gp
          CASE g_forminfo
             WHEN "Inbox"
                   CALL cl_set_comp_visible("intfilter_gp",FALSE)
                   LET g_intfilter = ""
             WHEN "Info"
                   CALL cl_set_comp_visible("intfilter_gp",TRUE)
                   LET g_intfilter = "ALL"
             WHEN "Sent"
                   CALL cl_set_comp_visible("intfilter_gp",FALSE)
                   LET g_intfilter = ""
             WHEN "Withdraw"      
             	     CALL cl_set_comp_visible("intfilter_gp",FALSE)
                   LET g_intfilter = ""
          END CASE
          
      ON ACTION go
          LET g_curr_page = 1
          LET g_total_page = 1
          EXIT INPUT

         ON ACTION locale
            CALL cl_dynamic_locale()
            EXIT INPUT

         ON ACTION exit                   # Esc.結束
            CALL udmtree_detect_process() RETURNING li_result
            IF li_result THEN
               CALL cl_err("","azz-726",1)
            END IF
            IF cl_confirm('azz-901') THEN
               CALL udmtree_close()   
               CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
               CLOSE WINDOW w_udm_tree
               EXIT PROGRAM
            END IF

         ON ACTION cancel
            LET INT_FLAG=FALSE
            CALL udmtree_detect_process() RETURNING li_result
            IF li_result THEN
               CALL cl_err("","azz-726",1)
            END IF
            IF cl_confirm('azz-901') THEN
               CALL udmtree_close()   
               CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
               CLOSE WINDOW w_udm_tree
               EXIT PROGRAM
            END IF

        ON ACTION info
           LET g_action_choice = "exit"
           EXIT INPUT

        ON ACTION system_flow
           LET g_action_choice = "exit"
           EXIT INPUT

        ON ACTION so_flow
           LET g_action_choice = "exit"
           EXIT INPUT

        ON ACTION needproc                    
           CALL udmtree_needproc_b_fill()
           CALL udmtree_needproc()
           LET g_action_choice = "exit"
           EXIT INPUT

         ON ACTION search
            CALL udmtree_search()
            LET g_action_choice = "exit"
            EXIT INPUT

        ON IDLE ms_msg_sec
           SELECT COUNT(*) INTO ls_msg_cnt FROM gar_file
            WHERE gar02 = g_user AND gar06 = 'N'
           IF ls_msg_cnt > 0 THEN
              CALL user_getprocess() RETURNING li_result
              IF NOT li_result THEN
                 CALL cl_cmdrun('p_load_msg')
              END IF
           END IF
           IF (g_idle_seconds IS NOT NULL) OR (g_idle_seconds != 0) THEN 
              CALL udmtree_detect_process() RETURNING li_result
              IF (NOT li_result) THEN
                 LET ms_idle_sec = ms_idle_sec + ms_msg_sec
                 LET ls_remain_sec = g_idle_seconds - ms_idle_sec
                 IF ls_remain_sec < ms_msg_sec THEN
                    LET ms_msg_sec = ls_remain_sec
                 END IF
                 IF ms_idle_sec = g_idle_seconds THEN
                    LET ms_idle_sec = 0
                    LET ls_remain_sec = 0
                   #-CHI-980033-add-
                    IF g_idle_seconds < 3 THEN
                       LET ms_msg_sec = g_idle_seconds
                    ELSE
                       LET ms_msg_sec = g_idle_seconds / 3
                    END IF

                    IF ms_msg_sec > 180 THEN
                       LET ms_msg_sec = 180
                    END IF
                    CALL cl_on_idle()
                    CONTINUE INPUT
                 END IF
              END IF
           END IF


         ON ACTION control
           CALL cl_cmdask()

         ON ACTION about 
           CALL cl_about()

         ON ACTION help      # H.說明 
           CALL cl_show_help()

    END INPUT
    CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION
#FUN-880099 ---end---
#FUN-B50046

#No.FUN-C10041 start --
FUNCTION udmtree_system_information()

     DEFINE   ls_msg         STRING
     DEFINE   lc_title       LIKE ze_file.ze03

     LET ls_msg   = cl_getmsg('azz1189',g_lang),"\n", cl_getmsg('azz1190',g_lang)
     LET lc_title = cl_getmsg('azz1191',g_lang)

       MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_msg.trim(), IMAGE="exclamation")
          ON ACTION yes
             EXIT MENU
       END MENU

END FUNCTION
#No.FUN-C10041 end --
