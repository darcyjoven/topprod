# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acot610.4gl
# Descriptions...: 內銷申請資料維護作業
# Date & Author..: 03/08/26 By Danny
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/11/22 By Carrier
# Modify.........: No.FUN-550036 05/05/25 By Trisy 單據編號加大
# Modify.........: No.FUN-560002 05/06/06 By day   單據編號修改
# Modify.........: No.FUN-570273 05/07/29 By Dido  單身未輸入確認無法跳出視窗
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-630014 06/03/07 By Carol 流程訊息通知功能
# Modify.........: No.TQC-660045 06/06/12 By CZH cl_err-->cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/08 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0084 11/12/28 By lixh1 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 12/12/21 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cnu           RECORD LIKE cnu_file.*,       #單頭
    g_cnu_t         RECORD LIKE cnu_file.*,       #單頭(舊值)
    g_cnu_o         RECORD LIKE cnu_file.*,       #單頭(舊值)
    g_cnu01_t       LIKE cnu_file.cnu01,          #單頭 (舊值)
    g_cnu07_t       LIKE cnu_file.cnu07,          #No.MOD-490398
    g_cnu05_t       LIKE cnu_file.cnu01,          #手冊編號
    g_tabname       STRING,                       #No.FUN-680069 STRING     #No.TQC-660045
    g_t1            LIKE oay_file.oayslip,        #No.FUN-550036      #No.FUN-680069 VARCHAR(05)
    g_cnv           DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
        cnv02       LIKE cnv_file.cnv02,   #行序
        cnv03       LIKE cnv_file.cnv03,   #公司序號
        cnv04       LIKE cnv_file.cnv04,   #商品編號
        cob02       LIKE cob_file.cob02,   #品名規格
        cnv041      LIKE cnv_file.cnv041,  #版本
        cnv05       LIKE cnv_file.cnv05,   #申請數量
        cnv06       LIKE cnv_file.cnv06,   #單位
        cnv07       LIKE cnv_file.cnv07,   #單價
        cnv08       LIKE cnv_file.cnv08,   #總價
       #FUN-840202 --start---
        cnvud01     LIKE cnv_file.cnvud01,
        cnvud02     LIKE cnv_file.cnvud02,
        cnvud03     LIKE cnv_file.cnvud03,
        cnvud04     LIKE cnv_file.cnvud04,
        cnvud05     LIKE cnv_file.cnvud05,
        cnvud06     LIKE cnv_file.cnvud06,
        cnvud07     LIKE cnv_file.cnvud07,
        cnvud08     LIKE cnv_file.cnvud08,
        cnvud09     LIKE cnv_file.cnvud09,
        cnvud10     LIKE cnv_file.cnvud10,
        cnvud11     LIKE cnv_file.cnvud11,
        cnvud12     LIKE cnv_file.cnvud12,
        cnvud13     LIKE cnv_file.cnvud13,
        cnvud14     LIKE cnv_file.cnvud14,
        cnvud15     LIKE cnv_file.cnvud15
       #FUN-840202 --end--
                    END RECORD,
    g_cnv_t         RECORD                 #程式變數 (舊值)
        cnv02       LIKE cnv_file.cnv02,   #行序
        cnv03       LIKE cnv_file.cnv03,   #公司序號
        cnv04       LIKE cnv_file.cnv04,   #商品編號
        cob02       LIKE cob_file.cob02,   #品名規格
        cnv041      LIKE cnv_file.cnv041,  #版本
        cnv05       LIKE cnv_file.cnv05,   #申請數量
        cnv06       LIKE cnv_file.cnv06,   #單位
        cnv07       LIKE cnv_file.cnv07,   #單價
        cnv08       LIKE cnv_file.cnv08,   #總價
       #FUN-840202 --start---
        cnvud01     LIKE cnv_file.cnvud01,
        cnvud02     LIKE cnv_file.cnvud02,
        cnvud03     LIKE cnv_file.cnvud03,
        cnvud04     LIKE cnv_file.cnvud04,
        cnvud05     LIKE cnv_file.cnvud05,
        cnvud06     LIKE cnv_file.cnvud06,
        cnvud07     LIKE cnv_file.cnvud07,
        cnvud08     LIKE cnv_file.cnvud08,
        cnvud09     LIKE cnv_file.cnvud09,
        cnvud10     LIKE cnv_file.cnvud10,
        cnvud11     LIKE cnv_file.cnvud11,
        cnvud12     LIKE cnv_file.cnvud12,
        cnvud13     LIKE cnv_file.cnvud13,
        cnvud14     LIKE cnv_file.cnvud14,
        cnvud15     LIKE cnv_file.cnvud15
       #FUN-840202 --end--
                    END RECORD,
    g_cnv_o         RECORD                 #程式變數 (舊值)
        cnv02       LIKE cnv_file.cnv02,   #行序
        cnv03       LIKE cnv_file.cnv03,   #公司序號
        cnv04       LIKE cnv_file.cnv04,   #商品編號
        cob02       LIKE cob_file.cob02,   #品名規格
        cnv041      LIKE cnv_file.cnv041,  #版本
        cnv05       LIKE cnv_file.cnv05,   #申請數量
        cnv06       LIKE cnv_file.cnv06,   #單位
        cnv07       LIKE cnv_file.cnv07,   #單價
        cnv08       LIKE cnv_file.cnv08,   #總價
       #FUN-840202 --start---
        cnvud01     LIKE cnv_file.cnvud01,
        cnvud02     LIKE cnv_file.cnvud02,
        cnvud03     LIKE cnv_file.cnvud03,
        cnvud04     LIKE cnv_file.cnvud04,
        cnvud05     LIKE cnv_file.cnvud05,
        cnvud06     LIKE cnv_file.cnvud06,
        cnvud07     LIKE cnv_file.cnvud07,
        cnvud08     LIKE cnv_file.cnvud08,
        cnvud09     LIKE cnv_file.cnvud09,
        cnvud10     LIKE cnv_file.cnvud10,
        cnvud11     LIKE cnv_file.cnvud11,
        cnvud12     LIKE cnv_file.cnvud12,
        cnvud13     LIKE cnv_file.cnvud13,
        cnvud14     LIKE cnv_file.cnvud14,
        cnvud15     LIKE cnv_file.cnvud15
       #FUN-840202 --end--
                    END RECORD,
    g_argv1         LIKE cnv_file.cnv01,   #詢價單號 ?????
    g_argv2         STRING,                #No.FUN-680069 STRING    #FUN-630014 指定執行的功能
     g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN         #No.FUN-680069
    g_rec_b         LIKE type_file.num5,                     #單身筆數      #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5,                     #目前處理的ARRAY CNT   #No.FUN-680069 SMALLINT
    g_coc01         LIKE coc_file.coc01    #申請編號
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL      #No.FUN-680069
DEFINE   g_before_input_done LIKE type_file.num5             #No.FUN-680069 SMALLINT
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose    #No.FUN-680069 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680069
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680069 INTEGER
 
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_void          LIKE type_file.chr1          #CHI-C80041

MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5              #No.FUN-680069 SMALLINT
#       l_time    LIKE type_file.chr8            #No.FUN-6A0063
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
    LET g_argv1 = ARG_VAL(1)               #參數-1(詢價單號)
    LET g_argv2 = ARG_VAL(2)               #參數-2(指定執行的功能) FUN-630014 add
 
    LET g_forupd_sql = " SELECT * FROM cnu_file WHERE cnu01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t610_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 4
    OPEN WINDOW t610_w AT p_row,p_col
        WITH FORM "aco/42f/acot610"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   #FUN-630014 --start--
   #IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
   #    CALL t610_q()
   #END IF
   # 先以g_argv2判斷直接執行哪種功能
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t610_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t610_a()
            END IF
         OTHERWISE
            CALL t610_q()
      END CASE
   END IF
   #FUN-630014 ---end---
 
    CALL t610_menu()
    CLOSE WINDOW t610_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION t610_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_cnv.clear()
 
 
#   IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN  #FUN-630014  modify
    IF NOT cl_null(g_argv1) THEN                    #FUN-630014  modify
        LET g_wc = " cnu01 = '",g_argv1,"'"
        LET g_wc2 = " 1=1"
    ELSE
        CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
   INITIALIZE g_cnu.* TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
             cnu01,cnu02,cnu03,cnu04,cnu05,cnu07,cnu06,#No.MOD-490398
            cnuconf,cnuuser,cnugrup,cnumodu,cnudate,cnuacti,
            #FUN-840202   ---start---
             cnuud01,cnuud02,cnuud03,cnuud04,cnuud05,
             cnuud06,cnuud07,cnuud08,cnuud09,cnuud10,
             cnuud11,cnuud12,cnuud13,cnuud14,cnuud15
            #FUN-840202    ----end----
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(cnu01) #單別
                     #CALL q_coy(FALSE, TRUE,g_cnu.cnu01,'18',g_sys)  #TQC-670008
                     CALL q_coy(FALSE, TRUE,g_cnu.cnu01,'18','ACO')   #TQC-670008
                         RETURNING g_cnu.cnu01
                     DISPLAY BY NAME g_cnu.cnu01
                     NEXT FIELD cnu01
                 #No.MOD-490398  --begin
                WHEN INFIELD(cnu07) #custom
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_cna"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO cnu07
                     NEXT FIELD cnu07
                WHEN INFIELD(cnu05) #手冊編號
                     CALL q_coc2(TRUE,TRUE,g_cnu.cnu05,'',
                                 g_cnu.cnu02,'',g_cnu.cnu07,'')
                          RETURNING g_cnu.cnu05
                     DISPLAY BY NAME g_cnu.cnu05
                     NEXT FIELD cnu05
                 #No.MOD-490398  --end
                OTHERWISE EXIT CASE
            END CASE
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
        IF INT_FLAG THEN RETURN END IF
        CONSTRUCT g_wc2 ON cnv02,cnv03,cnv04,cnv041,cnv05,   #螢幕上取單身條件
                           cnv06,cnv07,cnv08
                         #No.FUN-840202 --start--
                          ,cnvud01,cnvud02,cnvud03,cnvud04,cnvud05
                          ,cnvud06,cnvud07,cnvud08,cnvud09,cnvud10
                          ,cnvud11,cnvud12,cnvud13,cnvud14,cnvud15
                         #No.FUN-840202 ---end---
            FROM s_cnv[1].cnv02,s_cnv[1].cnv03,s_cnv[1].cnv04,s_cnv[1].cnv041,
                 s_cnv[1].cnv05,s_cnv[1].cnv06,s_cnv[1].cnv07,s_cnv[1].cnv08
               #No.FUN-840202 --start--
                ,s_cnv[1].cnvud01,s_cnv[1].cnvud02,s_cnv[1].cnvud03
                ,s_cnv[1].cnvud04,s_cnv[1].cnvud05,s_cnv[1].cnvud06
                ,s_cnv[1].cnvud07,s_cnv[1].cnvud08,s_cnv[1].cnvud09
                ,s_cnv[1].cnvud10,s_cnv[1].cnvud11,s_cnv[1].cnvud12
                ,s_cnv[1].cnvud13,s_cnv[1].cnvud14,s_cnv[1].cnvud15
               #No.FUN-840202 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
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
      ON ACTION qbe_save
         CALL cl_qbe_save()
     #No.FUN-580031 --end--       HCN
 
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
    END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND cnuuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND cnugrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND cnugrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnuuser', 'cnugrup')
    #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
        LET g_sql = "SELECT cnu01 FROM cnu_file ",
                    " WHERE ", g_wc CLIPPED,
                    " ORDER BY cnu01"
    ELSE					# 若單身有輸入條件
        LET g_sql = "SELECT UNIQUE cnu01 ",
                    "  FROM cnu_file, cnv_file ",
                    " WHERE cnu01 = cnv01",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                    " ORDER BY cnu01"
    END IF
 
    PREPARE t610_prepare FROM g_sql
    DECLARE t610_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t610_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM cnu_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM cnu_file,cnv_file WHERE ",
                  "cnv01=cnu01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t610_precount FROM g_sql
    DECLARE t610_count CURSOR FOR t610_precount
END FUNCTION
 
FUNCTION t610_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069 VARCHAR(100)
 
 
   WHILE TRUE
      CALL t610_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t610_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t610_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t610_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t610_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t610_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t610_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0023
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cnv),'','')
             END IF
         #--
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t610_firm1()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t610_firm2()
            END IF
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_cnu.cnu01 IS NOT NULL THEN
                 LET g_doc.column1 = "cnu01"
                 LET g_doc.value1 = g_cnu.cnu01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t610_v()
               IF g_cnu.cnuconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_cnu.cnuconf,"","","",g_void,g_cnu.cnuacti)
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t610_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550036        #No.FUN-680069 SMALLINT
    MESSAGE ""
    CLEAR FORM
    CALL g_cnv.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_cnu.* LIKE cnu_file.*  #DEFAULT 設置
    LET g_cnu01_t = NULL
    LET g_cnu05_t = NULL
    LET g_cnu_t.* = g_cnu.*
    LET g_cnu_o.* = g_cnu.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cnu.cnu02   = g_today     #單據日期
        LET g_cnu.cnuuser = g_user      #資料所有者
        LET g_data_plant = g_plant #FUN-980030
        LET g_cnu.cnugrup = g_grup      #資料所有部門
        LET g_cnu.cnudate = g_today     #最近更改日
        LET g_cnu.cnuacti = 'Y'         #資料有效碼
        LET g_cnu.cnuconf = 'N'         #資料審核碼
        LET g_cnu.cnuplant = g_plant  #FUN-980002
        LET g_cnu.cnulegal = g_legal  #FUN-980002
 
        BEGIN WORK
        CALL t610_i("a")                #輸入單頭
        IF INT_FLAG THEN                #用戶不玩了
            INITIALIZE g_cnu.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cnu.cnu01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
#No.FUN-550036 --start--
        IF cl_null(g_cnu.cnu01[g_no_sp,g_no_ep]) THEN
           CALL s_auto_assign_no("aco",g_cnu.cnu01,g_cnu.cnu02,"18","cnu_file","cnu01","","","")     #No.FUN-560002
                RETURNING li_result,g_cnu.cnu01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
#       IF cl_null(g_cnu.cnu01[5,10]) THEN              #自動編號
#          CALL s_acoauno(g_cnu.cnu01,g_cnu.cnu02,'18')
#               RETURNING g_i,g_cnu.cnu01
#          IF g_i THEN CONTINUE WHILE END IF
#No.FUN-550036 ---end---
           DISPLAY BY NAME g_cnu.cnu01
        END IF
        LET g_cnu.cnuoriu = g_user      #No.FUN-980030 10/01/04
        LET g_cnu.cnuorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cnu_file VALUES (g_cnu.*)
        LET g_t1 = s_get_doc_no(g_cnu.cnu01)  #No.FUN-550036
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
#            CALL cl_err(g_cnu.cnu01,SQLCA.sqlcode,1) #No.TQC-660045
             CALL cl_err3("ins","cnu_file",g_cnu.cnu01,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
            CONTINUE WHILE
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_cnu.cnu01,'I')
        SELECT cnu01 INTO g_cnu.cnu01 FROM cnu_file
            WHERE cnu01 = g_cnu.cnu01
        LET g_cnu01_t = g_cnu.cnu01        #保留舊值
        LET g_cnu05_t = g_cnu.cnu05        #保留舊值
        LET g_cnu07_t = g_cnu.cnu07        #No.MOD-490398
        LET g_cnu_t.* = g_cnu.*
        LET g_cnu_o.* = g_cnu.*
        LET g_rec_b=0
        CALL t610_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t610_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cnu.cnu01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_cnu.cnuconf = 'X' THEN RETURN END IF #CHI-C80041
    IF g_cnu.cnuconf = 'Y' THEN CALL cl_err('','9003',1) RETURN END IF
    SELECT * INTO g_cnu.* FROM cnu_file WHERE cnu01=g_cnu.cnu01
    IF g_cnu.cnuacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cnu.cnu01,'mfg1000',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cnu01_t = g_cnu.cnu01
    LET g_cnu05_t = g_cnu.cnu05
    LET g_cnu07_t = g_cnu.cnu07  #No.MOD-490398
    BEGIN WORK
 
    OPEN t610_cl USING g_cnu.cnu01
    IF STATUS THEN
       CALL cl_err("OPEN t610_cl:", STATUS, 1)
       CLOSE t610_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t610_cl INTO g_cnu.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnu.cnu01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t610_cl
        RETURN
    END IF
    CALL t610_show()
    WHILE TRUE
        LET g_cnu01_t = g_cnu.cnu01
        LET g_cnu05_t = g_cnu.cnu05
        LET g_cnu07_t = g_cnu.cnu07   #No.MOD-490398
        LET g_cnu_o.* = g_cnu.*
        LET g_cnu.cnumodu=g_user
        LET g_cnu.cnudate=g_today
        CALL t610_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cnu.*=g_cnu_t.*
            CALL t610_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_cnu.cnu01 != g_cnu01_t THEN            # 更改單號
            UPDATE cnv_file SET cnv01 = g_cnu.cnu01
                WHERE cnv01 = g_cnu01_t
            IF SQLCA.sqlcode THEN
#                CALL cl_err('cnv',SQLCA.sqlcode,0) #No.TQC-660045
                 CALL cl_err3("upd","cnv_file",g_cnu01_t,"",SQLCA.SQLCODE,"","cnv",1)       #NO.TQC-660045
                 CONTINUE WHILE
            END IF
        END IF
         #No.MOD-490398  begin
        IF g_cnu.cnu07 != g_cnu07_t THEN            # 更改單號
            UPDATE cnv_file SET cnv09 = g_cnu.cnu07
                WHERE cnv01 = g_cnu01_t
            IF SQLCA.sqlcode THEN
#                CALL cl_err('cnv',SQLCA.sqlcode,0)  #No.TQC-660045
                 CALL cl_err3("upd","cnv_file",g_cnu01_t,"",SQLCA.SQLCODE,"","cnv",1)       #NO.TQC-660045
                 CONTINUE WHILE
            END IF
        END IF
         #No.MOD-490398  --end
        UPDATE cnu_file SET cnu_file.* = g_cnu.*
            WHERE cnu01 = g_cnu01_t
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_cnu.cnu01,SQLCA.sqlcode,0) #No.TQC-660045
             CALL cl_err3("upd","cnu_file",g_cnu01_t,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t610_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cnu.cnu01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t610_i(p_cmd)
DEFINE   li_result   LIKE type_file.num5       #No.FUN-550036        #No.FUN-680069 SMALLINT
DEFINE
    l_coc05   LIKE coc_file.coc05,
    l_coc07   LIKE coc_file.coc07,
    l_n	      LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    l_type    LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(01)  #No.MOD-490398
    l_coc04   LIKE coc_file.coc04,          #No.MOD-490398
    p_cmd     LIKE type_file.chr1           #a:輸入 u:更改 #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
 
    INPUT BY NAME
        g_cnu.cnu01,g_cnu.cnu02,g_cnu.cnu03,g_cnu.cnu04,g_cnu.cnu05,
        g_cnu.cnu06,g_cnu.cnuconf,g_cnu.cnuuser,g_cnu.cnugrup,
        g_cnu.cnumodu,g_cnu.cnudate,g_cnu.cnuacti,
       #FUN-840202     ---start---
        g_cnu.cnuud01,g_cnu.cnuud02,g_cnu.cnuud03,g_cnu.cnuud04,
        g_cnu.cnuud05,g_cnu.cnuud06,g_cnu.cnuud07,g_cnu.cnuud08,
        g_cnu.cnuud09,g_cnu.cnuud10,g_cnu.cnuud11,g_cnu.cnuud12,
        g_cnu.cnuud13,g_cnu.cnuud14,g_cnu.cnuud15
       #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
        BEFORE INPUT
             LET g_before_input_done = FALSE
             CALL t610_set_entry(p_cmd)
             CALL t610_set_no_entry(p_cmd)
             LET g_before_input_done = TRUE
 
         #No.FUN-550036 --start--
         CALL cl_set_docno_format("cnu01")
         #No.FUN-550036 ---end---
 
 
#       BEFORE FIELD cnu01    #本系統不允許更改key
#           IF p_cmd = 'u'  AND g_chkey = 'N' THEN
#              NEXT FIELD cnu02
#           END IF
#   }
         AFTER FIELD cnu01
         #No.FUN-550036 --start--
         IF g_cnu.cnu01 != g_cnu01_t OR g_cnu01_t IS NULL THEN
            CALL s_check_no("aco",g_cnu.cnu01,g_cnu01_t,"18","cnu_file","cnu01","")
            RETURNING li_result,g_cnu.cnu01
            DISPLAY BY NAME g_cnu.cnu01
            IF (NOT li_result) THEN
               LET g_cnu.cnu01=g_cnu_o.cnu01
               NEXT FIELD cnu01
            END IF
#           IF NOT cl_null(g_cnu.cnu01) THEN
#              LET g_t1=g_cnu.cnu01[1,3]
#              CALL s_acoslip(g_t1,'18',g_sys)             #檢查單別
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 LET g_cnu.cnu01=g_cnu_o.cnu01
#                 NEXT FIELD cnu01
#              END IF
#              IF p_cmd = 'a'  THEN
#          IF g_cnu.cnu01[1,3] IS NOT NULL AND       #並且單號空白時,
#          	  cl_null(g_cnu.cnu01[5,10]) THEN           #請用戶自行輸入
#             IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
#                NEXT FIELD cnu01
#             ELSE					 #要不, 則單號不用
#                NEXT FIELD cnu02			 #輸入
# 	             END IF
#           END IF
#           IF g_cnu.cnu01[1,3] IS NOT NULL AND	 #並且單號空白時,
#          	   NOT cl_null(g_cnu.cnu01[5,10]) THEN	 #請用戶自行輸入
#                     IF NOT cl_chk_data_continue(g_cnu.cnu01[5,10]) THEN
#                        CALL cl_err('','9056',0)
#                        NEXT FIELD cnu01
#                     END IF
#                  END IF
#              END IF
#              IF g_cnu.cnu01 != g_cnu01_t OR g_cnu01_t IS NULL THEN
#                  SELECT count(*) INTO l_n FROM cnu_file
#                      WHERE cnu01 = g_cnu.cnu01
#                  IF l_n > 0 THEN   #單據編號重複
#                      CALL cl_err(g_cnu.cnu01,-239,0)
#                      LET g_cnu.cnu01 = g_cnu01_t
#                      DISPLAY BY NAME g_cnu.cnu01
#                      NEXT FIELD cnu01
#                  END IF
#              END IF
#No.FUN-550036 ---end---
            END IF
 
        AFTER FIELD cnu04                  #內銷類型
            IF NOT cl_null(g_cnu.cnu04) THEN
               IF g_cnu.cnu04 NOT MATCHES "[12]" THEN
                  NEXT FIELD cnu04
               END IF
               CALL t610_cnu04()
            END IF
 
        AFTER FIELD cnu05                  #手冊編號
            IF NOT cl_null(g_cnu.cnu05) THEN
               IF g_cnu.cnu05 != g_cnu05_t OR g_cnu05_t IS NULL THEN
                   #No.MOD-490398
                  SELECT coc01,coc02,coc05,coc07,coc10
                    INTO g_coc01,g_cnu.cnu06,l_coc05,l_coc07,g_cnu.cnu07
                    FROM coc_file
                   WHERE coc03 = g_cnu.cnu05 AND cocacti !='N'
                  IF STATUS THEN
#                     CALL cl_err(g_cnu.cnu05,'aco-062',0) #No.TQC-660045
                      CALL cl_err3("sel","coc_file",g_cnu.cnu05,"","aco-062","","",1)       #NO.TQC-660045
                      NEXT FIELD cnu05
                  END IF
                  DISPLAY BY NAME g_cnu.cnu06,g_cnu.cnu07
                   #No.MOD-490398  --end
                  IF l_coc05 < g_today THEN
                     CALL cl_err('','aco-056',0) NEXT FIELD cnu05
                  END IF
                  IF NOT cl_null(l_coc07) THEN
                     CALL cl_err('','aco-057',0) NEXT FIELD cnu05
                  END IF
               END IF
            END IF
 
        AFTER FIELD cnu06                  #幣別
            IF NOT cl_null(g_cnu.cnu06) THEN
               SELECT azi01
                   FROM azi_file WHERE azi01 = g_cnu.cnu06
               IF STATUS THEN
#                   CALL cl_err('select azi',STATUS,0) #No.TQC-660045
                    CALL cl_err3("sel","azi_file",g_cnu.cnu06,"",STATUS,"","select azi",1)       #NO.TQC-660045
                   NEXT FIELD cnu06
               END IF
            END IF
 
        #FUN-840202     ---start---
        AFTER FIELD cnuud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnuud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(cnu01) #單別
                    #CALL q_coy(FALSE, TRUE,g_cnu.cnu01,'18',g_sys)  #TQC-670008
                     CALL q_coy(FALSE, TRUE,g_cnu.cnu01,'18','ACO')  #TQC-670008
                         RETURNING g_cnu.cnu01
#                     CALL FGL_DIALOG_SETBUFFER( g_cnu.cnu01 )
                     DISPLAY BY NAME g_cnu.cnu01
                     NEXT FIELD cnu01
                 #No.MOD-490398
                WHEN INFIELD(cnu05) #手冊編號
                     IF g_cnu.cnu04 = '1' THEN
                        LET l_type = '0'        #成品
                     ELSE
                        LET l_type = '1'        #材料
                     END IF
                     CALL q_coc2(FALSE,FALSE,g_cnu.cnu05,'',
                                 g_cnu.cnu02,l_type,g_cnu.cnu07,'')
                          RETURNING g_cnu.cnu05,l_coc04
                     DISPLAY BY NAME g_cnu.cnu05
                     NEXT FIELD cnu05
                 #No.MOD-490398 end
                OTHERWISE EXIT CASE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
FUNCTION t610_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
 CALL cl_set_comp_entry("cnu01",TRUE)
 END IF
 
END FUNCTION
FUNCTION t610_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cnu01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t610_cnu04()       #內銷類型
    DEFINE l_chr     LIKE ze_file.ze03       #No.FUN-680069 VARCHAR(8)
    CASE g_cnu.cnu04
         WHEN '1'    LET l_chr = cl_getmsg('aco-047',0)
         WHEN '2'    LET l_chr = cl_getmsg('aco-048',0)
    END CASE
    DISPLAY l_chr TO FORMONLY.desc
END FUNCTION
 
#Query 查詢
FUNCTION t610_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cnu.* TO NULL               #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_cnv.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t610_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_cnu.* TO NULL
        RETURN
    END IF
    OPEN t610_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cnu.* TO NULL
    ELSE
        OPEN t610_count
        FETCH t610_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t610_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t610_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t610_cs INTO g_cnu.cnu01
        WHEN 'P' FETCH PREVIOUS t610_cs INTO g_cnu.cnu01
        WHEN 'F' FETCH FIRST    t610_cs INTO g_cnu.cnu01
        WHEN 'L' FETCH LAST     t610_cs INTO g_cnu.cnu01
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
         FETCH ABSOLUTE g_jump t610_cs INTO g_cnu.cnu01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnu.cnu01,SQLCA.sqlcode,0)
        INITIALIZE g_cnu.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_cnu.* FROM cnu_file WHERE cnu01 = g_cnu.cnu01
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_cnu.cnu01,SQLCA.sqlcode,0) #No.TQC-660045
         CALL cl_err3("sel","cnu_file",g_cnu.cnu01,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
        INITIALIZE g_cnu.* TO NULL
        RETURN
    END IF
 
    CALL t610_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t610_show()
    DEFINE
           l_desc1   LIKE cnb_file.cnb04,   #公司名稱
           l_desc2   LIKE pmc_file.pmc03    #廠商名稱
    LET g_cnu_t.* = g_cnu.*                 #保存單頭舊值
    LET g_cnu_o.* = g_cnu.*                 #保存單頭舊值
    DISPLAY BY NAME
 
        g_cnu.cnu01 ,g_cnu.cnu02 ,g_cnu.cnu03  ,g_cnu.cnu04  ,g_cnu.cnu05,
         g_cnu.cnu07 ,#No.MOD-490398
        g_cnu.cnu06 ,g_cnu.cnuconf,g_cnu.cnuuser,g_cnu.cnugrup,
        g_cnu.cnumodu,g_cnu.cnudate,g_cnu.cnuacti,
       #FUN-840202     ---start---
        g_cnu.cnuud01,g_cnu.cnuud02,g_cnu.cnuud03,g_cnu.cnuud04,
        g_cnu.cnuud05,g_cnu.cnuud06,g_cnu.cnuud07,g_cnu.cnuud08,
        g_cnu.cnuud09,g_cnu.cnuud10,g_cnu.cnuud11,g_cnu.cnuud12,
        g_cnu.cnuud13,g_cnu.cnuud14,g_cnu.cnuud15
       #FUN-840202     ----end----
 
    #CALL cl_set_field_pic(g_cnu.cnuconf,"","","","",g_cnu.cnuacti)  #CHI-C80041
    IF g_cnu.cnuconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cnu.cnuconf,"","","",g_void,g_cnu.cnuacti)  #CHI-C80041
    CALL t610_cnu04()
    CALL t610_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t610_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cnu.cnu01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN t610_cl USING g_cnu.cnu01
    IF STATUS THEN
       CALL cl_err("OPEN t610_cl:", STATUS, 1)
       CLOSE t610_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t610_cl INTO g_cnu.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnu.cnu01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    IF g_cnu.cnuconf='Y' THEN RETURN END IF
    CALL t610_show()
    IF cl_exp(0,0,g_cnu.cnuacti) THEN                   #審核一下
        LET g_chr=g_cnu.cnuacti
        IF g_cnu.cnuacti='Y' THEN
            LET g_cnu.cnuacti='N'
        ELSE
            LET g_cnu.cnuacti='Y'
        END IF
        UPDATE cnu_file                    #更改有效碼
            SET cnuacti=g_cnu.cnuacti
            WHERE cnu01=g_cnu.cnu01
        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_cnu.cnu01,SQLCA.sqlcode,0) #No.TQC-660045
             CALL cl_err3("upd","cnu_file",g_cnu.cnu01,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
            LET g_cnu.cnuacti=g_chr
        END IF
        DISPLAY BY NAME g_cnu.cnuacti
    END IF
    CLOSE t610_cl
    COMMIT WORK
 
 
    #CALL cl_set_field_pic(g_cnu.cnuconf,"","","","",g_cnu.cnuacti)  #CHI-C80041
    IF g_cnu.cnuconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cnu.cnuconf,"","","",g_void,g_cnu.cnuacti)  #CHI-C80041
    CALL cl_flow_notify(g_cnu.cnu01,'V')
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t610_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cnu.cnu01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_cnu.cnuconf = 'X' THEN RETURN END IF #CHI-C80041
    IF g_cnu.cnuconf = 'Y' THEN CALL cl_err('','9003',1) RETURN END IF
    IF g_cnu.cnuacti = 'N' THEN CALL cl_err('','9024',1) RETURN END IF
    BEGIN WORK
 
    OPEN t610_cl USING g_cnu.cnu01
    IF STATUS THEN
       CALL cl_err("OPEN t610_cl:", STATUS, 1)
       CLOSE t610_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t610_cl INTO g_cnu.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnu.cnu01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t610_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cnu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cnu.cnu01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
            DELETE FROM cnu_file WHERE cnu01 = g_cnu.cnu01
            DELETE FROM cnv_file WHERE cnv01 = g_cnu.cnu01
        #No.MOD-490398
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980002 add azoplant,azolegal
          VALUES ('acot610',g_user,g_today,g_msg,g_cnu.cnu01,'delete',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
        #No.MOD-490398 end
            CLEAR FORM
            CALL g_cnv.clear()
 
         OPEN t610_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE t610_cs
             CLOSE t610_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH t610_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t610_cs
             CLOSE t610_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
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
    CALL cl_flow_notify(g_cnu.cnu01,'D')
END FUNCTION
 
#單身
FUNCTION t610_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680069 VARCHAR(1)
    l_cnv04         LIKE cnv_file.cnv04,   #商品編號
    l_cnv05         LIKE cnv_file.cnv05,   #申請數量
    l_cnv06         LIKE cnv_file.cnv06,   #單位
    l_cnv07         LIKE cnv_file.cnv07,   #單價
    l_cnv08         LIKE cnv_file.cnv08,   #總價
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_cnu.cnu01 IS NULL THEN RETURN END IF
    SELECT * INTO g_cnu.* FROM cnu_file WHERE cnu01 = g_cnu.cnu01
    IF g_cnu.cnuacti = 'N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cnu.cnu01,'mfg1000',0) RETURN
    END IF
    IF g_cnu.cnuconf = 'X' THEN RETURN END IF #CHI-C80041
    IF g_cnu.cnuconf = 'Y' THEN CALL cl_err('','9003',1) RETURN END IF
    LET g_success = 'Y'
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql = " SELECT cnv02,cnv03,cnv04,'',cnv041,cnv05,cnv06,cnv07,cnv08, ",
                      #No.FUN-840202 --start--
                       "       cnvud01,cnvud02,cnvud03,cnvud04,cnvud05,",
                       "       cnvud06,cnvud07,cnvud08,cnvud09,cnvud10,",
                       "       cnvud11,cnvud12,cnvud13,cnvud14,cnvud15 ",
                      #No.FUN-840202 ---end---
                       "   FROM cnv_file ",
                       "  WHERE cnv01 = ? AND cnv02 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t610_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
   IF g_rec_b=0 THEN CALL g_cnv.clear() END IF
   INPUT ARRAY g_cnv WITHOUT DEFAULTS FROM s_cnv.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
 
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
 
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t610_cl USING g_cnu.cnu01
            IF STATUS THEN
               CALL cl_err("OPEN t610_cl:", STATUS, 1)
               CLOSE t610_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t610_cl INTO g_cnu.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_cnu.cnu01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t610_cl
              RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_cnv_t.* = g_cnv[l_ac].*  #BACKUP
                LET g_cnv_o.* = g_cnv[l_ac].*  #BACKUP
                OPEN t610_bcl USING g_cnu.cnu01, g_cnv_t.cnv02
                IF STATUS THEN
                   CALL cl_err("OPEN t610_bcl:", STATUS, 1)
                   CLOSE t610_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t610_bcl INTO g_cnv[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cnv_t.cnv02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   SELECT cob02 INTO g_cnv[l_ac].cob02 FROM cob_file
                       WHERE cob01 = g_cnv[l_ac].cnv04
                   END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
           #NEXT FIELD cnv02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
              INITIALIZE g_cnv[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_cnv[l_ac].* TO s_cnv.*
              CALL g_cnv.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
             #No.MOD-490398  --end
            INSERT INTO cnv_file(cnv01,cnv02,cnv03,cnv04,cnv041,
                                 cnv05,cnv051,cnv06,cnv07,cnv08,cnv09,
                               #FUN-840202 --start--
                                 cnvud01,cnvud02,cnvud03,
                                 cnvud04,cnvud05,cnvud06,
                                 cnvud07,cnvud08,cnvud09,
                                 cnvud10,cnvud11,cnvud12,
                                 cnvud13,cnvud14,cnvud15,cnvplant,cnvlegal) #FUN-980002 add cnvplant,cnvlegal
                               #FUN-840202 --end--
            VALUES(g_cnu.cnu01,
                   g_cnv[l_ac].cnv02,g_cnv[l_ac].cnv03,
                   g_cnv[l_ac].cnv04,g_cnv[l_ac].cnv041,
                   g_cnv[l_ac].cnv05,0,g_cnv[l_ac].cnv06,
                   g_cnv[l_ac].cnv07,g_cnv[l_ac].cnv08,g_cnu.cnu07,
                  #FUN-840202 --start--
                   g_cnv[l_ac].cnvud01, g_cnv[l_ac].cnvud02,
                   g_cnv[l_ac].cnvud03, g_cnv[l_ac].cnvud04,
                   g_cnv[l_ac].cnvud05, g_cnv[l_ac].cnvud06,
                   g_cnv[l_ac].cnvud07, g_cnv[l_ac].cnvud08,
                   g_cnv[l_ac].cnvud09, g_cnv[l_ac].cnvud10,
                   g_cnv[l_ac].cnvud11, g_cnv[l_ac].cnvud12,
                   g_cnv[l_ac].cnvud13, g_cnv[l_ac].cnvud14,
                   g_cnv[l_ac].cnvud15, g_plant, g_legal) #FUN-980002 add g_plant,g_legal
                  #FUN-840202 --end--
 
             #No.MOD-493098  --end
            IF SQLCA.sqlcode THEN
#                CALL cl_err(g_cnv[l_ac].cnv02,SQLCA.sqlcode,0) #No.TQC-660045
                 CALL cl_err3("ins","cnv_file",g_cnv[l_ac].cnv02,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
 
               ROLLBACK WORK
               CANCEL INSERT
                LET g_cnv[l_ac].* = g_cnv_t.*
            ELSE
                IF g_success='Y' THEN
                   COMMIT WORK
                ELSE
                   CALL cl_rbmsg(1) ROLLBACK WORK
                END IF
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
 
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_cnv[l_ac].* TO NULL       #900423
            LET g_cnv_t.* = g_cnv[l_ac].*          #新輸入資料
            LET g_cnv_o.* = g_cnv[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnv02
 
        BEFORE FIELD cnv02                        #default 序號
            IF g_cnv[l_ac].cnv02 IS NULL OR g_cnv[l_ac].cnv02 = 0 THEN
                SELECT max(cnv02)+1
                   INTO g_cnv[l_ac].cnv02
                   FROM cnv_file
                   WHERE cnv01 = g_cnu.cnu01
                IF g_cnv[l_ac].cnv02 IS NULL THEN
                    LET g_cnv[l_ac].cnv02 = 1
                END IF
#               DISPLAY g_cnv[l_ac].cnv02 TO cnv02 #No.FUN-570273預設值不可使用
            END IF
 
        AFTER FIELD cnv02                        #check 序號是否重複
            IF NOT g_cnv[l_ac].cnv02 IS NULL THEN
               IF g_cnv[l_ac].cnv02 != g_cnv_t.cnv02 OR
                  g_cnv_t.cnv02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM cnv_file
                       WHERE cnv01 = g_cnu.cnu01 AND
                             cnv02 = g_cnv[l_ac].cnv02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cnv[l_ac].cnv02 = g_cnv_t.cnv02
                       NEXT FIELD cnv02
                   END IF
               END IF
            END IF
 
        BEFORE FIELD cnv03
            SELECT coc01 INTO g_coc01 FROM coc_file
              WHERE coc03 = g_cnu.cnu05 AND cocacti !='N'       #No.MOD-490398
 
        AFTER FIELD cnv03
            IF NOT cl_null(g_cnv[l_ac].cnv03) THEN
               IF g_cnv[l_ac].cnv03 != g_cnv_t.cnv03 OR
                  g_cnv_t.cnv03 IS NULL THEN
                   SELECT count(*) INTO l_n FROM cnv_file
                       WHERE cnv01 = g_cnu.cnu01 AND
                             cnv03 = g_cnv[l_ac].cnv03
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cnv[l_ac].cnv03 = g_cnv_t.cnv03
                       NEXT FIELD cnv03
                   END IF
                   CALL t610_cnv03('a')
                   IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                      NEXT FIELD cnv03
                   END IF
               END IF
               SELECT cob02 INTO g_cnv[l_ac].cob02 FROM cob_file
                WHERE cob01 = g_cnv[l_ac].cnv04
                #DISPLAY g_cnv[l_ac].cob02 TO cob02  #No.MOD-490398
            END IF
 
        AFTER FIELD cnv05
            IF NOT cl_null(g_cnv[l_ac].cnv05) THEN
            #FUN-BB0084 -------------Begin--------------
               IF NOT cl_null(g_cnv[l_ac].cnv06) THEN
                  LET g_cnv[l_ac].cnv05 = s_digqty(g_cnv[l_ac].cnv05,g_cnv[l_ac].cnv06)
                  DISPLAY BY NAME g_cnv[l_ac].cnv05
               END IF
            #FUN-BB0084 -------------End----------------
               CALL t610_cnv03('d')
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0) 
                   NEXT FIELD cnv05
               END IF
            END IF
 
        BEFORE FIELD cnv08
            LET g_cnv[l_ac].cnv08 = g_cnv[l_ac].cnv05 * g_cnv[l_ac].cnv07
            DISPLAY g_cnv[l_ac].cnv08 TO cnv08
 
        #No.FUN-840202 --start--
        AFTER FIELD cnvud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnvud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_cnv_t.cnv02 > 0 AND
               g_cnv_t.cnv02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM cnv_file
                 WHERE cnv01 = g_cnu.cnu01 AND cnv02 = g_cnv_t.cnv02
                IF SQLCA.sqlcode THEN
     #              CALL cl_err(g_cnv_t.cnv02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("del","cnv_file",g_cnv_t.cnv02,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cnv[l_ac].* = g_cnv_t.*
               CLOSE t610_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cnv[l_ac].cnv02,-263,1)
               LET g_cnv[l_ac].* = g_cnv_t.*
            ELSE
               UPDATE cnv_file SET cnv02=g_cnv[l_ac].cnv02,
                                   cnv03=g_cnv[l_ac].cnv03,
                                   cnv04=g_cnv[l_ac].cnv04,
                                   cnv041=g_cnv[l_ac].cnv041,
                                   cnv05=g_cnv[l_ac].cnv05,
                                   cnv06=g_cnv[l_ac].cnv06,
                                   cnv07=g_cnv[l_ac].cnv07,
                                   cnv08=g_cnv[l_ac].cnv08,
                                  #FUN-840202 --start--
                                   cnvud01 = g_cnv[l_ac].cnvud01,
                                   cnvud02 = g_cnv[l_ac].cnvud02,
                                   cnvud03 = g_cnv[l_ac].cnvud03,
                                   cnvud04 = g_cnv[l_ac].cnvud04,
                                   cnvud05 = g_cnv[l_ac].cnvud05,
                                   cnvud06 = g_cnv[l_ac].cnvud06,
                                   cnvud07 = g_cnv[l_ac].cnvud07,
                                   cnvud08 = g_cnv[l_ac].cnvud08,
                                   cnvud09 = g_cnv[l_ac].cnvud09,
                                   cnvud10 = g_cnv[l_ac].cnvud10,
                                   cnvud11 = g_cnv[l_ac].cnvud11,
                                   cnvud12 = g_cnv[l_ac].cnvud12,
                                   cnvud13 = g_cnv[l_ac].cnvud13,
                                   cnvud14 = g_cnv[l_ac].cnvud14,
                                   cnvud15 = g_cnv[l_ac].cnvud15
                                  #FUN-840202 --end-- 
               WHERE cnv01 = g_cnu.cnu01 AND cnv02 = g_cnv_t.cnv02
               IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cnv[l_ac].cnv02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("upd","cnv_file",g_cnv[l_ac].cnv02,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
                   LET g_cnv[l_ac].* = g_cnv_t.*
               ELSE
                   IF g_success='Y' THEN
                      COMMIT WORK
                   ELSE
                      CALL cl_rbmsg(1) ROLLBACK WORK
                   END IF
                   MESSAGE 'UPDATE O.K'
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_cnv[l_ac].* = g_cnv_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cnv.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t610_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30034 Add
          #LET g_cnv_t.* = g_cnv[l_ac].*          # 900423
            CLOSE t610_bcl
            COMMIT WORK
 
           #CALL g_cnv.deleteElement(g_rec_b+1)   #FUN-D30034 Mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cnv02) AND l_ac > 1 THEN
                LET g_cnv[l_ac].* = g_cnv[l_ac-1].*
                NEXT FIELD cnv02
            END IF
        ON ACTION controls                       # No.FUN-6B0033
           CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(cnv03) #公司序號
                     CASE
                         WHEN g_cnu.cnu04 = 1
                              CALL q_cod(FALSE,TRUE,g_coc01,g_cnv[l_ac].cnv03)
                                  RETURNING g_coc01,g_cnv[l_ac].cnv03
#                              CALL FGL_DIALOG_SETBUFFER( g_coc01 )
#                              CALL FGL_DIALOG_SETBUFFER( g_cnv[l_ac].cnv03 )
                              DISPLAY g_coc01,g_cnv[l_ac].cnv03 TO coc01,cnv03
                              NEXT FIELD cnv03
                         WHEN g_cnu.cnu04 = 2
                              CALL q_coe(FALSE,TRUE,g_coc01,g_cnv[l_ac].cnv03)
                                  RETURNING g_coc01,g_cnv[l_ac].cnv03
#                              CALL FGL_DIALOG_SETBUFFER( g_coc01 )
#                              CALL FGL_DIALOG_SETBUFFER( g_cnv[l_ac].cnv03 )
                              DISPLAY g_coc01,g_cnv[l_ac].cnv03 TO coc01,cnv03
                              NEXT FIELD cnv03
                         OTHERWISE EXIT CASE
                     END CASE
               OTHERWISE EXIT CASE
            END CASE
 
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
 
 
        END INPUT
 
        #FUN-5B0043-begin
         LET g_cnu.cnumodu = g_user
         LET g_cnu.cnudate = g_today
         UPDATE cnu_file SET cnumodu = g_cnu.cnumodu,cnudate = g_cnu.cnudate
          WHERE cnu01 = g_cnu.cnu01
         DISPLAY BY NAME g_cnu.cnumodu,g_cnu.cnudate
        #FUN-5B0043-end
 
        CLOSE t610_bcl
        COMMIT WORK
        CALL t610_delHeader()     #CHI-C30002 add
END FUNCTION
 

#CHI-C30002 -------- add -------- begin
FUNCTION t610_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_cnu.cnu01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM cnu_file ",
                  "  WHERE cnu01 LIKE '",l_slip,"%' ",
                  "    AND cnu01 > '",g_cnu.cnu01,"'"
      PREPARE t610_pb1 FROM l_sql 
      EXECUTE t610_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t610_v()
         IF g_cnu.cnuconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_cnu.cnuconf,"","","",g_void,g_cnu.cnuacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM cnu_file WHERE cnu01 = g_cnu.cnu01
         INITIALIZE g_cnu.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t610_cnv03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_qty     LIKE cnv_file.cnv05
 
    LET g_errno = ' '
    LET g_tabname = NULL  #No.TQC-660045
    #按型態判斷不同檔案(出口/進口)
    IF g_cnu.cnu04 = '1' THEN  #成品
       SELECT cod03,cod041,cod05+cod10,cod06,cod07
         INTO g_cnv[l_ac].cnv04,g_cnv[l_ac].cnv041,
              l_qty,g_cnv[l_ac].cnv06,
              g_cnv[l_ac].cnv07
         FROM cod_file
        WHERE cod01=g_coc01 AND cod02=g_cnv[l_ac].cnv03
        LET g_tabname = "cod_file"          #NO.TQC-660045
        CALL s_codqty(g_cnu.cnu05,g_cnv[l_ac].cnv03) RETURNING l_qty  #剩餘量
        #------MOD-5A0095 START----------
        DISPLAY BY NAME g_cnv[l_ac].cnv04
        DISPLAY BY NAME g_cnv[l_ac].cnv041
        DISPLAY BY NAME g_cnv[l_ac].cnv06
        DISPLAY BY NAME g_cnv[l_ac].cnv07
        #------MOD-5A0095 END------------
    END IF
    IF g_cnu.cnu04 = '2' THEN  #材料
       SELECT coe03,coe05+coe10,coe06,coe07
         INTO g_cnv[l_ac].cnv04,
              l_qty,g_cnv[l_ac].cnv06,
              g_cnv[l_ac].cnv07
         FROM coe_file
        WHERE coe01 = g_coc01 AND coe02=g_cnv[l_ac].cnv03
        LET g_tabname = "coe_file"          #NO.TQC-660045
       CALL s_coeqty(g_cnu.cnu05,g_cnv[l_ac].cnv03) RETURNING l_qty  #剩餘量
    END IF
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-026'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'a' THEN
       LET g_cnv[l_ac].cnv05 = l_qty
        #No.MOD-490398   --begin
       #DISPLAY g_cnv[l_ac].cnv04 TO cnv04
       #DISPLAY g_cnv[l_ac].cnv041 TO cnv041
       #DISPLAY g_cnv[l_ac].cnv05  TO cnv05
       #DISPLAY g_cnv[l_ac].cnv06  TO cnv06
       #DISPLAY g_cnv[l_ac].cnv07  TO cnv07
        #No.MOD-490398   --end
    END IF
    LET g_cnv[l_ac].cnv05 = s_digqty(g_cnv[l_ac].cnv05,g_cnv[l_ac].cnv06)   #FUN-BB0084 
    DISPLAY BY NAME g_cnv[l_ac].cnv05     #FUN-BB0084
    DISPLAY BY NAME g_cnv[l_ac].cnv06     #FUN-BB0084 
    IF p_cmd='d' THEN
       IF g_cnv[l_ac].cnv05 > l_qty THEN LET g_errno = 'aco-046' END IF
    END IF
END FUNCTION
 
FUNCTION t610_delall()
    SELECT COUNT(*) INTO g_cnt FROM cnv_file
        WHERE cnv01 = g_cnu.cnu01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否撤銷單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM cnu_file WHERE cnu01 = g_cnu.cnu01
    END IF
END FUNCTION
 
FUNCTION t610_b_askkey()
DEFINE
    l_wc2         LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON cnv02,cnv03,cnv04,cnv041,cnv05,cnv06,
                       cnv07,cnv08        # 螢幕上取單身條件
                      #No.FUN-840202 --start--
                      ,cnvud01,cnvud02,cnvud03,cnvud04,cnvud05
                      ,cnvud06,cnvud07,cnvud08,cnvud09,cnvud10
                      ,cnvud11,cnvud12,cnvud13,cnvud14,cnvud15
                      #No.FUN-840202 ---end---
            FROM s_cnv[1].cnv02 ,s_cnv[1].cnv03,s_cnv[1].cnv04,
                 s_cnv[1].cnv041,s_cnv[1].cnv05,s_cnv[1].cnv06,
                 s_cnv[1].cnv07, s_cnv[1].cnv08
               #No.FUN-840202 --start--
                ,s_cnv[1].cnvud01,s_cnv[1].cnvud02,s_cnv[1].cnvud03
                ,s_cnv[1].cnvud04,s_cnv[1].cnvud05,s_cnv[1].cnvud06
                ,s_cnv[1].cnvud07,s_cnv[1].cnvud08,s_cnv[1].cnvud09
                ,s_cnv[1].cnvud10,s_cnv[1].cnvud11,s_cnv[1].cnvud12
                ,s_cnv[1].cnvud13,s_cnv[1].cnvud14,s_cnv[1].cnvud15
               #No.FUN-840202 ---end---
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL t610_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t610_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2     LIKE type_file.chr1000     #No.FUN-680069 VARCHAR(200)
 
    LET g_sql =
        "SELECT cnv02,cnv03,cnv04,'',cnv041,cnv05,cnv06,cnv07,cnv08,",
        #No.FUN-840202 --start--
        "       cnvud01,cnvud02,cnvud03,cnvud04,cnvud05,",
        "       cnvud06,cnvud07,cnvud08,cnvud09,cnvud10,",
        "       cnvud11,cnvud12,cnvud13,cnvud14,cnvud15 ",
        #No.FUN-840202 ---end---
        "    FROM cnv_file ",
        "    WHERE cnv01 ='",g_cnu.cnu01,"'"    #單頭
    #No.FUN-8B0123---Begin
    #   "      AND ", p_wc2 CLIPPED,            #單身
    #   "    ORDER BY 1,2"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1,2 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE t610_pb FROM g_sql
    DECLARE cnv_cs                       #SCROLL CURSOR
        CURSOR FOR t610_pb
    CALL g_cnv.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH cnv_cs INTO g_cnv[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT cob02 INTO g_cnv[g_cnt].cob02 FROM cob_file
            WHERE cob01 = g_cnv[g_cnt].cnv04
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
 
    CALL g_cnv.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cnv TO s_cnv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t610_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         #CALL cl_set_field_pic(g_cnu.cnuconf,"","","","",g_cnu.cnuacti)  #CHI-C80041
         IF g_cnu.cnuconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_cnu.cnuconf,"","","",g_void,g_cnu.cnuacti)  #CHI-C80041
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                       # No.FUN-6B0033
       CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0023
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6A0168  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY     
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t610_firm1()
DEFINE l_cnu01_old LIKE cnu_file.cnu01
 
   LET l_cnu01_old=g_cnu.cnu01    # backup old key value cnu01
   IF g_cnu.cnu01 IS NULL THEN RETURN END IF
#CHI-C30107 --------- add ----------- begin
   IF g_cnu.cnuconf = 'X' THEN RETURN END IF #CHI-C80041
   IF g_cnu.cnuconf='Y' THEN RETURN END IF
   IF g_cnu.cnuacti='N' THEN CALL cl_err('','9024',0) RETURN END IF

   SELECT COUNT(*) INTO g_cnt FROM cnv_file
    WHERE cnv01 = g_cnu.cnu01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 --------- add ----------- end
   SELECT * INTO g_cnu.* FROM cnu_file WHERE cnu01=g_cnu.cnu01
   IF g_cnu.cnuconf = 'X' THEN RETURN END IF #CHI-C80041
   IF g_cnu.cnuconf='Y' THEN RETURN END IF
   IF g_cnu.cnuacti='N' THEN CALL cl_err('','9024',0) RETURN END IF
 
   SELECT COUNT(*) INTO g_cnt FROM cnv_file
    WHERE cnv01 = g_cnu.cnu01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
    #No.MOD-490398
   #check單頭手冊編號與單身商品編號是否相符
   IF t610_firm1_chk() THEN CALL cl_err(g_cnu.cnu01,'aco-090',1) RETURN END IF
    #No.MOD-490398  end
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   LET g_success='Y'
   BEGIN WORK
   IF g_success='N' THEN
      ROLLBACK WORK RETURN
   END IF
   UPDATE cnu_file SET cnuconf = 'Y' WHERE cnu01 = g_cnu.cnu01
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd cnuconf',STATUS,1) #No.TQC-660045
       CALL cl_err3("upd","cnu_file",g_cnu.cnu01,"",STATUS,"","upd cnuconf",1)       #NO.TQC-660045
      SELECT * INTO g_cnu.* FROM cnu_file WHERE cnu01 = l_cnu01_old
      ROLLBACK WORK
      RETURN
   END IF
   IF g_success='N' THEN
      SELECT * INTO g_cnu.* FROM cnu_file WHERE cnu01 = l_cnu01_old
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
      CALL cl_flow_notify(g_cnu.cnu01,'Y')
      CALL cl_cmmsg(1)
   END IF
   SELECT * INTO g_cnu.* FROM cnu_file WHERE cnu01 = l_cnu01_old
   DISPLAY g_cnu.cnuconf TO cnuconf
   #CALL cl_set_field_pic(g_cnu.cnuconf,"","","","",g_cnu.cnuacti)  #CHI-C80041
   IF g_cnu.cnuconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_cnu.cnuconf,"","","",g_void,g_cnu.cnuacti)  #CHI-C80041
END FUNCTION
 
 #No.MOD-490398
FUNCTION t610_firm1_chk()
   DEFINE l_cnv     RECORD LIKE cnv_file.*
   DEFINE l_coc01   LIKE coc_file.coc01
   DEFINE l_cnt     LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   SELECT coc01 INTO l_coc01 FROM coc_file WHERE coc03 = g_cnu.cnu05
 
   DECLARE firm1_curs CURSOR FOR
     SELECT * FROM cnv_file WHERE cnv01 = g_cnu.cnu01
 
   FOREACH firm1_curs INTO l_cnv.*
       IF g_cnu.cnu04 = '1' THEN       #成品
          SELECT COUNT(*) INTO l_cnt FROM cod_file
           WHERE cod01 = l_coc01 AND cod03 = l_cnv.cnv04
             AND cod041= l_cnv.cnv041 AND cod04 = l_cnv.cnv09
       ELSE                            #材料
          SELECT COUNT(*) INTO l_cnt FROM coe_file
           WHERE coe01 = l_coc01 AND coe03 = l_cnv.cnv04
             AND coe04 = l_cnv.cnv09
       END IF
       IF l_cnt = 0 THEN RETURN 1 END IF
   END FOREACH
   RETURN 0
END FUNCTION
 #No.MOD-490398 end
 
FUNCTION t610_firm2()
   DEFINE l_cnu01_old LIKE cnu_file.cnu01
 
   LET l_cnu01_old=g_cnu.cnu01    # backup old key value gsb01
   LET g_success='Y'
   BEGIN WORK
   IF g_cnu.cnuconf = 'X' THEN RETURN END IF #CHI-C80041
   IF g_cnu.cnuconf='N' THEN RETURN END IF
   IF g_cnu.cnuacti='N' THEN RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM cno_file
    WHERE cno05 = g_cnu.cnu01
   IF g_cnt > 0 THEN
      CALL cl_err(g_cnu.cnu01,'aco-079',0) LET g_success = 'N'
   END IF
   IF g_success='N'THEN ROLLBACK WORK RETURN END IF
   UPDATE cnu_file SET cnuconf = 'N' WHERE cnu01 = g_cnu.cnu01
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd cnuconf',STATUS,1) #No.TQC-660045
       CALL cl_err3("upd","cnu_file",g_cnu.cnu01,"",STATUS,"","upd cnuconf",1)       #NO.TQC-660045
      SELECT * INTO g_cnu.* FROM cnu_file WHERE cnu01 = l_cnu01_old
      ROLLBACK WORK
      RETURN
   END IF
   IF g_success='N' THEN
      SELECT * INTO g_cnu.* FROM cnu_file WHERE cnu01 = l_cnu01_old
      ROLLBACK WORK RETURN
   ELSE
      COMMIT WORK
      CALL cl_cmmsg(1)
   END IF
   SELECT * INTO g_cnu.* FROM cnu_file WHERE cnu01 = l_cnu01_old
   DISPLAY g_cnu.cnuconf TO cnuconf
   #CALL cl_set_field_pic(g_cnu.cnuconf,"","","","",g_cnu.cnuacti)  #CHI-C80041
   IF g_cnu.cnuconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_cnu.cnuconf,"","","",g_void,g_cnu.cnuacti)  #CHI-C80041
END FUNCTION
#Patch....NO.MOD-5A0095 <001> #
#Patch....NO.TQC-610035 <001> #
#CHI-C80041---begin
FUNCTION t610_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_cnu.cnu01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t610_cl USING g_cnu.cnu01
   IF STATUS THEN
      CALL cl_err("OPEN t610_cl:", STATUS, 1)
      CLOSE t610_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t610_cl INTO g_cnu.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cnu.cnu01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t610_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_cnu.cnuconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_cnu.cnuconf)   THEN 
        LET l_chr=g_cnu.cnuconf
        IF g_cnu.cnuconf='N' THEN 
            LET g_cnu.cnuconf='X' 
        ELSE
            LET g_cnu.cnuconf='N'
        END IF
        UPDATE cnu_file
            SET cnuconf=g_cnu.cnuconf,  
                cnumodu=g_user,
                cnudate=g_today
            WHERE cnu01=g_cnu.cnu01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","cnu_file",g_cnu.cnu01,"",SQLCA.sqlcode,"","",1)  
            LET g_cnu.cnuconf=l_chr 
        END IF
        DISPLAY BY NAME g_cnu.cnuconf 
   END IF
 
   CLOSE t610_cl
   COMMIT WORK
   CALL cl_flow_notify(g_cnu.cnu01,'V')
 
END FUNCTION
#CHI-C80041---end
