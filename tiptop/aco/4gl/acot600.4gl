# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acot600.4gl
# Descriptions...: 轉廠申請資料維護作業
# Date & Author..: 00/09/15 By Mandy
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/11/22 By Carrier 增加海關編號,將cnm05改成手冊編號
#                                         cnm04->1/2
# Modify.........: No.FUN-550036 05/05/25 By Trisy 單據編號加大
# Modify.........: NO.FUN-560002 05/06/06 By jackie 單據編號修改
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
# Modify.........: No.FUN-840202 08/05/07 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.MOD-8B0093 08/11/10 By Sarah 將AFTER FIELD cnm07段的EXIT INPUT給MARK掉
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.MOD-940083 09/04/14 By Smapmin 轉出方應抓客戶編號
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9C0333 09/12/21 By sabrina 在數量欄位按確定後, 金額要自動帶出, 不用再輸入一次 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0084 11/12/30 By lixh1 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 12/12/21 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cnm           RECORD LIKE cnm_file.*,       #單頭
    g_cnm_t         RECORD LIKE cnm_file.*,       #單頭(舊值)
    g_cnm_o         RECORD LIKE cnm_file.*,       #單頭(舊值)
    g_cnm01_t       LIKE cnm_file.cnm01,   #單頭 (舊值)
    g_cnm05_t       LIKE cnm_file.cnm01,   #購銷手冊編號
    g_cnm09_t       LIKE cnm_file.cnm01,   #海關代號 No.MOD-490398
    g_cnm071_t      LIKE cnm_file.cnm071,  #手冊編號
    g_cnm081_t      LIKE cnm_file.cnm081,  #手冊編號
    g_t1            LIKE oay_file.oayslip,              #No.FUN-550036        #No.FUN-680069
    g_cnn           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        cnn02       LIKE cnn_file.cnn02,   #行序
        cnn03       LIKE cnn_file.cnn03,   #公司序號
        cnn04       LIKE cnn_file.cnn04,   #商品編號
        cnn041      LIKE cnn_file.cnn041,  #版本
        cob02       LIKE cob_file.cob02,   #品名規格
        cnn05       LIKE cnn_file.cnn05,   #申請數量
        cnn06       LIKE cnn_file.cnn06,   #單位
        cnn07       LIKE cnn_file.cnn07,   #單價
        cnn08       LIKE cnn_file.cnn08,   #總價
      #FUN-840202 --start---
        cnnud01     LIKE cnn_file.cnnud01,
        cnnud02     LIKE cnn_file.cnnud02,
        cnnud03     LIKE cnn_file.cnnud03,
        cnnud04     LIKE cnn_file.cnnud04,
        cnnud05     LIKE cnn_file.cnnud05,
        cnnud06     LIKE cnn_file.cnnud06,
        cnnud07     LIKE cnn_file.cnnud07,
        cnnud08     LIKE cnn_file.cnnud08,
        cnnud09     LIKE cnn_file.cnnud09,
        cnnud10     LIKE cnn_file.cnnud10,
        cnnud11     LIKE cnn_file.cnnud11,
        cnnud12     LIKE cnn_file.cnnud12,
        cnnud13     LIKE cnn_file.cnnud13,
        cnnud14     LIKE cnn_file.cnnud14,
        cnnud15     LIKE cnn_file.cnnud15
      #FUN-840202 --end--
                    END RECORD,
    g_cnn_t         RECORD                 #程式變數 (舊值)
        cnn02       LIKE cnn_file.cnn02,   #行序
        cnn03       LIKE cnn_file.cnn03,   #公司序號
        cnn04       LIKE cnn_file.cnn04,   #商品編號
        cnn041      LIKE cnn_file.cnn041,  #版本
        cob02       LIKE cob_file.cob02,   #品名規格
        cnn05       LIKE cnn_file.cnn05,   #申請數量
        cnn06       LIKE cnn_file.cnn06,   #單位
        cnn07       LIKE cnn_file.cnn07,   #單價
        cnn08       LIKE cnn_file.cnn08,   #總價
      #FUN-840202 --start---
        cnnud01     LIKE cnn_file.cnnud01,
        cnnud02     LIKE cnn_file.cnnud02,
        cnnud03     LIKE cnn_file.cnnud03,
        cnnud04     LIKE cnn_file.cnnud04,
        cnnud05     LIKE cnn_file.cnnud05,
        cnnud06     LIKE cnn_file.cnnud06,
        cnnud07     LIKE cnn_file.cnnud07,
        cnnud08     LIKE cnn_file.cnnud08,
        cnnud09     LIKE cnn_file.cnnud09,
        cnnud10     LIKE cnn_file.cnnud10,
        cnnud11     LIKE cnn_file.cnnud11,
        cnnud12     LIKE cnn_file.cnnud12,
        cnnud13     LIKE cnn_file.cnnud13,
        cnnud14     LIKE cnn_file.cnnud14,
        cnnud15     LIKE cnn_file.cnnud15
      #FUN-840202 --end--
                    END RECORD,
    g_cnn_o         RECORD                 #程式變數 (舊值)
        cnn02       LIKE cnn_file.cnn02,   #行序
        cnn03       LIKE cnn_file.cnn03,   #公司序號
        cnn04       LIKE cnn_file.cnn04,   #商品編號
        cnn041      LIKE cnn_file.cnn041,  #版本
        cob02       LIKE cob_file.cob02,   #品名規格
        cnn05       LIKE cnn_file.cnn05,   #申請數量
        cnn06       LIKE cnn_file.cnn06,   #單位
        cnn07       LIKE cnn_file.cnn07,   #單價
        cnn08       LIKE cnn_file.cnn08,   #總價
      #FUN-840202 --start---
        cnnud01     LIKE cnn_file.cnnud01,
        cnnud02     LIKE cnn_file.cnnud02,
        cnnud03     LIKE cnn_file.cnnud03,
        cnnud04     LIKE cnn_file.cnnud04,
        cnnud05     LIKE cnn_file.cnnud05,
        cnnud06     LIKE cnn_file.cnnud06,
        cnnud07     LIKE cnn_file.cnnud07,
        cnnud08     LIKE cnn_file.cnnud08,
        cnnud09     LIKE cnn_file.cnnud09,
        cnnud10     LIKE cnn_file.cnnud10,
        cnnud11     LIKE cnn_file.cnnud11,
        cnnud12     LIKE cnn_file.cnnud12,
        cnnud13     LIKE cnn_file.cnnud13,
        cnnud14     LIKE cnn_file.cnnud14,
        cnnud15     LIKE cnn_file.cnnud15
      #FUN-840202 --end--
                    END RECORD,
    g_argv1         LIKE cnn_file.cnn01,   #詢價單號 ?????
    g_argv2         STRING,                #No.FUN-680069 STRING      #FUN-630014 指定執行的功能
    g_wc,g_wc2,g_sql    STRING,            #No.FUN-580092 HCN   #No.FUN-680069
    g_rec_b         LIKE type_file.num5,   #單身筆數    #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680069 SMALLINT
    g_coc01         LIKE coc_file.coc01    #申請編號
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE g_before_input_done   LIKE type_file.num5               #No.FUN-680069 SMALLINT
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
 
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680069 SMALLINT
DEFINE g_void          LIKE type_file.chr1          #CHI-C80041

MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5             #No.FUN-680069 SMALLINT
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
 
    LET g_forupd_sql = " SELECT * FROM cnm_file WHERE cnm01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 4
    OPEN WINDOW t600_w AT p_row,p_col
        WITH FORM "aco/42f/acot600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   #FUN-630014 --start--
   #IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
   #    CALL t600_q()
   #END IF
   # 先以g_argv2判斷直接執行哪種功能
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t600_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t600_a()
            END IF
         OTHERWISE
            CALL t600_q()
      END CASE
   END IF
   #FUN-630014 ---end---
    CALL t600_menu()
    CLOSE WINDOW t600_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION t600_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_cnn.clear()
 
    IF NOT cl_null(g_argv1) THEN 
        LET g_wc = " cnm01 = '",g_argv1,"'"
        LET g_wc2 = " 1=1"
    ELSE
        CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
   INITIALIZE g_cnm.* TO NULL    #No.FUN-750051
        CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
             cnm01,cnm02,cnm03,cnm04,cnm05,cnm09,cnm06,  #No.MOD-490398
             cnm07,cnm072,cnm08,cnm082,                  #No.MOD-490398
            cnmconf,cnmuser,cnmgrup,cnmmodu,cnmdate,cnmacti,
           #FUN-840202   ---start---
            cnmud01,cnmud02,cnmud03,cnmud04,cnmud05,
            cnmud06,cnmud07,cnmud08,cnmud09,cnmud10,
            cnmud11,cnmud12,cnmud13,cnmud14,cnmud15
           #FUN-840202    ----end----
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION controlp
            CASE
                WHEN INFIELD(cnm01) #單別
                     #CALL q_coy( FALSE, TRUE,g_cnm.cnm01,'15',g_sys) #TQC-670008
                     CALL q_coy( FALSE, TRUE,g_cnm.cnm01,'15','ACO')  #TQC-670008
                          RETURNING g_cnm.cnm01
                     DISPLAY BY NAME g_cnm.cnm01
                     NEXT FIELD cnm01
                WHEN INFIELD(cnm05) #手冊編號
                 #No.MOD-490398  --begin
                     CALL q_coc2(TRUE,TRUE,g_cnm.cnm05,'',g_cnm.cnm02,
                                 '',g_cnm.cnm09,'')
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO cnm05
                     NEXT FIELD cnm05
                WHEN INFIELD(cnm09) #custom
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     LET g_qryparam.form ="q_cna"
                     LET g_qryparam.default1 = g_cnm.cnm09
                     CALL cl_create_qry() RETURNING g_cnm.cnm09
                     DISPLAY BY NAME g_cnm.cnm09
                     NEXT FIELD cnm09
                 #No.MOD-490398  --end
                WHEN INFIELD(cnm06) #幣別
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     LET g_qryparam.form ="q_azi"
                     LET g_qryparam.default1 = g_cnm.cnm06
                     CALL cl_create_qry() RETURNING g_cnm.cnm06
                     DISPLAY BY NAME g_cnm.cnm06
                     NEXT FIELD cnm06
                WHEN INFIELD(cnm07) #轉出方
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     #LET g_qryparam.form ="q_cnb"   #MOD-940083
                     LET g_qryparam.form ="q_occ"   #MOD-940083
                     LET g_qryparam.default1 = g_cnm.cnm07
                     CALL cl_create_qry() RETURNING g_cnm.cnm07
                     DISPLAY BY NAME g_cnm.cnm07
                     NEXT FIELD cnm07
                 WHEN INFIELD(cnm08) #轉入方
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     LET g_qryparam.form ="q_pmc"
                     LET g_qryparam.default1 = g_cnm.cnm08
                     CALL cl_create_qry() RETURNING g_cnm.cnm08
                     DISPLAY BY NAME g_cnm.cnm08
                     NEXT FIELD cnm08
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
        CONSTRUCT g_wc2 ON cnn02,cnn03,cnn04,cnn041,cnn05,   #螢幕上取單身條件
                           cnn06,cnn07,cnn08
                         #No.FUN-840202 --start--
                          ,cnnud01,cnnud02,cnnud03,cnnud04,cnnud05
                          ,cnnud06,cnnud07,cnnud08,cnnud09,cnnud10
                          ,cnnud11,cnnud12,cnnud13,cnnud14,cnnud15
                         #No.FUN-840202 ---end---
            FROM s_cnn[1].cnn02,s_cnn[1].cnn03,s_cnn[1].cnn04,s_cnn[1].cnn041,
                 s_cnn[1].cnn05,s_cnn[1].cnn06,s_cnn[1].cnn07,s_cnn[1].cnn08
               #No.FUN-840202 --start--
                ,s_cnn[1].cnnud01,s_cnn[1].cnnud02,s_cnn[1].cnnud03
                ,s_cnn[1].cnnud04,s_cnn[1].cnnud05,s_cnn[1].cnnud06
                ,s_cnn[1].cnnud07,s_cnn[1].cnnud08,s_cnn[1].cnnud09
                ,s_cnn[1].cnnud10,s_cnn[1].cnnud11,s_cnn[1].cnnud12
                ,s_cnn[1].cnnud13,s_cnn[1].cnnud14,s_cnn[1].cnnud15
               #No.FUN-840202 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
            ON ACTION controlp
            CASE
                WHEN INFIELD(cnn03) #公司序號
                     CASE
                          WHEN g_cnm.cnm04 = 1  #No.MOD-490398
                              CALL q_coe(TRUE,TRUE,g_coc01,g_cnn[1].cnn03)
                                  RETURNING g_qryparam.multiret
                              DISPLAY g_qryparam.multiret TO cnn03
                              DISPLAY g_cnn[1].cnn03 TO cnn03
                              NEXT FIELD cnn03
                          WHEN g_cnm.cnm04 = 2  #No.MOD-490398
                              CALL q_cod(TRUE,TRUE,g_coc01,g_cnn[1].cnn03)
                                  RETURNING g_qryparam.multiret
                              DISPLAY g_qryparam.multiret TO cnn03
                              NEXT FIELD cnn03
                         OTHERWISE EXIT CASE
                     END CASE
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
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
        END CONSTRUCT
        IF INT_FLAG THEN RETURN END IF
    END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND cnmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND cnmgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND cnmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnmuser', 'cnmgrup')
    #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
        LET g_sql = "SELECT cnm01 FROM cnm_file ",
                    " WHERE ", g_wc CLIPPED,
                    " ORDER BY cnm01"
    ELSE					# 若單身有輸入條件
        LET g_sql = "SELECT UNIQUE cnm01 ",
                    "  FROM cnm_file, cnn_file ",
                    " WHERE cnm01 = cnn01",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                    " ORDER BY cnm01"
    END IF
 
    PREPARE t600_prepare FROM g_sql
    DECLARE t600_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t600_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM cnm_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM cnm_file,cnn_file WHERE ",
                  "cnn01=cnm01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t600_precount FROM g_sql
    DECLARE t600_count CURSOR FOR t600_precount
END FUNCTION
 
FUNCTION t600_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069  VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL t600_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t600_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t600_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t600_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t600_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t600_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t600_b()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cnn),'','')
             END IF
         #--
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t600_firm1()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t600_firm2()
            END IF
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_cnm.cnm01 IS NOT NULL THEN
                 LET g_doc.column1 = "cnm01"
                 LET g_doc.value1 = g_cnm.cnm01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t600_v()
               IF g_cnm.cnmconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_cnm.cnmconf,"","","",g_void,g_cnm.cnmacti)
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t600_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550036        #No.FUN-680069 SMALLINT
    MESSAGE ""
    CLEAR FORM
    CALL g_cnn.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_cnm.* LIKE cnm_file.*  #DEFAULT 設置
    LET g_cnm01_t = NULL
    LET g_cnm05_t = NULL
    LET g_cnm_t.* = g_cnm.*
    LET g_cnm_o.* = g_cnm.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cnm.cnm02   = g_today     #單據日期
        LET g_cnm.cnmuser = g_user      #資料所有者
        LET g_data_plant = g_plant #FUN-980030
        LET g_cnm.cnmgrup = g_grup      #資料所有部門
        LET g_cnm.cnmdate = g_today     #最近更改日
        LET g_cnm.cnmacti = 'Y'         #資料有效碼
        LET g_cnm.cnmconf = 'N'         #資料審核碼
        LET g_cnm.cnmplant = g_plant  #FUN-980002
        LET g_cnm.cnmlegal = g_legal  #FUN-980002
 
        BEGIN WORK
        CALL t600_i("a")                #輸入單頭
        IF INT_FLAG THEN                #用戶不玩了
            INITIALIZE g_cnm.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cnm.cnm01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
#No.FUN-550036 --start--
        IF cl_null(g_cnm.cnm01[g_no_sp,g_no_ep]) THEN
      CALL s_auto_assign_no("aco",g_cnm.cnm01,g_cnm.cnm02,"15","cnm_file","cnm01","","","")
        RETURNING li_result,g_cnm.cnm01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
#       IF cl_null(g_cnm.cnm01[5,10]) THEN              #自動編號
#          CALL s_acoauno(g_cnm.cnm01,g_cnm.cnm02,'15')
#            RETURNING g_i,g_cnm.cnm01
#          IF g_i THEN CONTINUE WHILE END IF
#No.FUN-550036 ---end---
           DISPLAY BY NAME g_cnm.cnm01
        END IF
        LET g_cnm.cnmoriu = g_user      #No.FUN-980030 10/01/04
        LET g_cnm.cnmorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cnm_file VALUES (g_cnm.*)
#       LET g_t1 = g_cnm.cnm01[1,3]           #備份上一筆單別
        LET g_t1 = s_get_doc_no(g_cnm.cnm01)  #No.FUN-550036
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
#            CALL cl_err(g_cnm.cnm01,SQLCA.sqlcode,1) #No.TQC-660045
             CALL cl_err3("ins","cnm_file",g_cnm.cnm01,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
            CONTINUE WHILE
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_cnm.cnm01,'I')
        SELECT cnm01 INTO g_cnm.cnm01 FROM cnm_file
            WHERE cnm01 = g_cnm.cnm01
	    LET g_cnm01_t = g_cnm.cnm01        #保留舊值
        LET g_cnm05_t = g_cnm.cnm05        #保留舊值
         LET g_cnm09_t = g_cnm.cnm09        #No.MOD-490398
        LET g_cnm_t.* = g_cnm.*
        LET g_cnm_o.* = g_cnm.*
        LET g_rec_b=0
        CALL t600_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t600_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cnm.cnm01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_cnm.cnmconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_cnm.cnmconf = 'Y' THEN CALL cl_err('','9003',1) RETURN END IF
    SELECT * INTO g_cnm.* FROM cnm_file WHERE cnm01=g_cnm.cnm01
    IF g_cnm.cnmacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cnm.cnm01,'mfg1000',0) #本資料為無效資料, 不可更改
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cnm01_t = g_cnm.cnm01
    LET g_cnm05_t = g_cnm.cnm05
     LET g_cnm09_t = g_cnm.cnm09     #No.MOD-490398
    BEGIN WORK
 
    OPEN t600_cl USING g_cnm.cnm01
    IF STATUS THEN
       CALL cl_err("OPEN t600_cl:", STATUS, 1)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t600_cl INTO g_cnm.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnm.cnm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t600_cl
        RETURN
    END IF
    CALL t600_show()
    WHILE TRUE
        LET g_cnm01_t = g_cnm.cnm01
        LET g_cnm05_t = g_cnm.cnm05
         LET g_cnm09_t = g_cnm.cnm09   #No.MOD-490398
        LET g_cnm_o.* = g_cnm.*
        LET g_cnm.cnmmodu=g_user
        LET g_cnm.cnmdate=g_today
        CALL t600_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cnm.*=g_cnm_t.*
            CALL t600_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_cnm.cnm01 != g_cnm01_t THEN            # 更改單號
            UPDATE cnn_file SET cnn01 = g_cnm.cnm01
                WHERE cnn01 = g_cnm01_t
            IF SQLCA.sqlcode THEN
#                CALL cl_err('cnn',SQLCA.sqlcode,0)  #No.TQC-660045
                 CALL cl_err3("upd","cnn_file",g_cnm01_t,"",SQLCA.SQLCODE,"","cnn",1)       #NO.TQC-660045
                 CONTINUE WHILE
            END IF
        END IF
        IF g_cnm.cnm09 != g_cnm09_t THEN            # 更改單號
            UPDATE cnn_file SET cnn09 = g_cnm.cnm09
                WHERE cnn01 = g_cnm01_t
            IF SQLCA.sqlcode THEN
#                CALL cl_err('cnn',SQLCA.sqlcode,0) #No.TQC-660045
                 CALL cl_err3("upd","cnn_file",g_cnm01_t,"",SQLCA.SQLCODE,"","cnn",1)       #NO.TQC-660045
                 CONTINUE WHILE
            END IF
        END IF
        UPDATE cnm_file SET cnm_file.* = g_cnm.*
            WHERE cnm01 = g_cnm01_t
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_cnm.cnm01,SQLCA.sqlcode,0) #No.TQC-660045
             CALL cl_err3("upd","cnm_file",g_cnm01_t,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t600_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cnm.cnm01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t600_i(p_cmd)
DEFINE   li_result   LIKE type_file.num5          #No.FUN-550036        #No.FUN-680069 SMALLINT
DEFINE
    #l_desc1   LIKE cnb_file.cnb04,   #公司名稱   #MOD-940083
    l_desc1   LIKE occ_file.occ02,   #公司名稱   #MOD-940083
    l_desc2   LIKE pmc_file.pmc03,   #廠商名稱
    l_coc05   LIKE coc_file.coc05,
    l_coc07   LIKE coc_file.coc07,
    l_n	      LIKE type_file.num5,           #No.FUN-680069 SMALLINT
    l_type    LIKE type_file.chr1,           #No.FUN-680069   VARCHAR(1)     #No.MOD-490398
    p_cmd     LIKE type_file.chr1            #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
 
    DISPLAY BY NAME
        g_cnm.cnm01,g_cnm.cnm02,g_cnm.cnm03,g_cnm.cnm04,g_cnm.cnm05,
         g_cnm.cnm09,g_cnm.cnm06,g_cnm.cnm07,g_cnm.cnm072,g_cnm.cnm08, #No.MOD-490398
        g_cnm.cnm082,g_cnm.cnmconf,g_cnm.cnmuser,g_cnm.cnmgrup,
        g_cnm.cnmmodu,g_cnm.cnmdate,g_cnm.cnmacti,
      #FUN-840202     ---start---
        g_cnm.cnmud01,g_cnm.cnmud02,g_cnm.cnmud03,g_cnm.cnmud04,
        g_cnm.cnmud05,g_cnm.cnmud06,g_cnm.cnmud07,g_cnm.cnmud08,
        g_cnm.cnmud09,g_cnm.cnmud10,g_cnm.cnmud11,g_cnm.cnmud12,
        g_cnm.cnmud13,g_cnm.cnmud14,g_cnm.cnmud15
      #FUN-840202     ----end----
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
 
    INPUT BY NAME
        g_cnm.cnm01,g_cnm.cnm02,g_cnm.cnm03,g_cnm.cnm04,g_cnm.cnm05,
         g_cnm.cnm09,g_cnm.cnm06,g_cnm.cnm07,g_cnm.cnm072,g_cnm.cnm08, #No.MOD-490398
        g_cnm.cnm082,g_cnm.cnmconf,g_cnm.cnmuser,g_cnm.cnmgrup,
        g_cnm.cnmmodu,g_cnm.cnmdate,g_cnm.cnmacti,
      #FUN-840202     ---start---
        g_cnm.cnmud01,g_cnm.cnmud02,g_cnm.cnmud03,g_cnm.cnmud04,
        g_cnm.cnmud05,g_cnm.cnmud06,g_cnm.cnmud07,g_cnm.cnmud08,
        g_cnm.cnmud09,g_cnm.cnmud10,g_cnm.cnmud11,g_cnm.cnmud12,
        g_cnm.cnmud13,g_cnm.cnmud14,g_cnm.cnmud15
      #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t600_set_entry(p_cmd)
           CALL t600_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
#No.FUN-560002--begin
           CALL cl_set_docno_format("cnm01")
#No.FUN-560002--end
 
         #No.FUN-550036 --start--
         CALL cl_set_docno_format("cnm01")
         #No.FUN-550036 ---end---
 
#       BEFORE FIELD cnm01    #本系統不允許更改key
#           IF p_cmd = 'u'  AND g_chkey = 'N' THEN
#               NEXT FIELD cnm02
#           END IF
        AFTER FIELD cnm01
         #No.FUN-550036 --start--
#         IF g_cnm.cnm01 != g_cnm01_t OR g_cnm01_t IS NULL THEN
         IF NOT cl_null(g_cnm.cnm01) AND g_cnm.cnm01!= g_cnm_o.cnm01 THEN   #No.FUN-560002
            CALL s_check_no("aco",g_cnm.cnm01,g_cnm01_t,"15","cnm_file","cnm01","")
            RETURNING li_result,g_cnm.cnm01
            DISPLAY BY NAME g_cnm.cnm01
            IF (NOT li_result) THEN
               LET g_cnm.cnm01=g_cnm_o.cnm01
               NEXT FIELD cnm01
            END IF
#           IF NOT cl_null(g_cnm.cnm01) THEN
#              LET g_t1=g_cnm.cnm01[1,3]
#              CALL s_acoslip(g_t1,'15',g_sys)             #檢查單別
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 LET g_cnm.cnm01=g_cnm_o.cnm01
#                 NEXT FIELD cnm01
#              END IF
#              IF p_cmd = 'a'  THEN
#          IF g_cnm.cnm01[1,3] IS NOT NULL AND       #並且單號空白時,
#          	  cl_null(g_cnm.cnm01[5,10]) THEN           #請用戶自行輸入
#             IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
#                NEXT FIELD cnm01
#             ELSE					 #要不, 則單號不用
#                NEXT FIELD cnm03			 #輸入
# 	             END IF
#           END IF
#           IF g_cnm.cnm01[1,3] IS NOT NULL AND	 #並且單號空白時,
#          	   NOT cl_null(g_cnm.cnm01[5,10]) THEN	 #請用戶自行輸入
#                     IF NOT cl_chk_data_continue(g_cnm.cnm01[5,10]) THEN
#                        CALL cl_err('','9056',0)
#                        NEXT FIELD cnm01
#                     END IF
#                  END IF
#              END IF
#              IF g_cnm.cnm01 != g_cnm01_t OR g_cnm01_t IS NULL THEN
#                  SELECT count(*) INTO l_n FROM cnm_file
#                      WHERE cnm01 = g_cnm.cnm01
#                  IF l_n > 0 THEN   #單據編號重複
#                      CALL cl_err(g_cnm.cnm01,-239,0)
#                      LET g_cnm.cnm01 = g_cnm01_t
#                      DISPLAY BY NAME g_cnm.cnm01
#                      NEXT FIELD cnm01
#                  END IF
#              END IF
#No.FUN-550036 ---end---
            END IF
 
        BEFORE FIELD cnm04
            CALL t600_set_entry(p_cmd)
 
        AFTER FIELD cnm04                  #轉廠類型
            IF NOT cl_null(g_cnm.cnm04) THEN
                IF g_cnm.cnm04 NOT MATCHES "[12]" THEN   #No.MOD-490398
                   NEXT FIELD cnm04
                END IF
                CALL t600_cnm04()
            END IF
            CALL t600_set_no_entry(p_cmd)
 
         #No.MOD-490398  --begin
        AFTER FIELD cnm05                  #購銷手冊編號
            IF NOT cl_null(g_cnm.cnm05) THEN
               IF g_cnm.cnm05 != g_cnm05_t OR g_cnm05_t IS NULL THEN
                   CASE
                       WHEN g_cnm.cnm04 = '1'
                            SELECT coc01,coc10,coc02,coc03,coc05,coc07
                              INTO g_coc01,g_cnm.cnm09,g_cnm.cnm06,g_cnm.cnm081,l_coc05,l_coc07
                              FROM coc_file
                              WHERE coc03 = g_cnm.cnm05  #No.MOD-490398
                               AND cocacti !='N'  #010807增
                            IF STATUS THEN #無此合同編號資料,請重新輸入!
#                                CALL cl_err(g_cnm.cnm05,'aco-062',0)  #No.MOD-490398 #No.TQC-660045
                                 CALL cl_err3("sel","coc_file",g_cnm.cnm05,"","aco-062","","",1)       #NO.TQC-660045
                               LET l_coc07 = NULL
                               NEXT FIELD cnm05
                            END IF
                            LET g_cnm.cnm082 = l_coc05
                            DISPLAY BY NAME g_cnm.cnm09,g_cnm.cnm06,g_cnm.cnm081,g_cnm.cnm082
                            IF l_coc05 < g_today THEN
                               CALL cl_err('','aco-056',0) NEXT FIELD cnm05
                            END IF
                            IF NOT cl_null(l_coc07) THEN
                               CALL cl_err('','aco-057',0) NEXT FIELD cnm05
                            END IF
                            NEXT FIELD cnm08
                       WHEN g_cnm.cnm04 = '2'
                            SELECT coc01,coc10,coc02,coc03,coc05,coc07
                              INTO g_coc01,g_cnm.cnm09,g_cnm.cnm06,g_cnm.cnm071,l_coc05,l_coc07
                              FROM coc_file
                              WHERE coc03 = g_cnm.cnm05  #No.MOD-490398
                               AND cocacti !='N'  #010807增
                            IF STATUS THEN #無此合同編號資料,請重新輸入!
#                                CALL cl_err(g_cnm.cnm05,'aco-062',0)  #No.MOD-490398 #No.TQC-660045
                                 CALL cl_err3("sel","coc_file",g_cnm.cnm05,"","aco-062","","",1)       #NO.TQC-660045
                               LET l_coc07 = NULL
                               NEXT FIELD cnm05
                            END IF
                            LET g_cnm.cnm072 = l_coc05
                            IF l_coc05 < g_today THEN
                               CALL cl_err('','aco-056',0) NEXT FIELD cnm05
                            END IF
                            IF NOT cl_null(l_coc07) THEN
                               CALL cl_err('','aco-057',0) NEXT FIELD cnm05
                            END IF
                            NEXT FIELD cnm07
                       OTHERWISE
                            EXIT CASE
                   END CASE
               END IF
            END IF
         #No.MOD-490398  --end
 
        AFTER FIELD cnm06                  #幣別
            IF not cl_null(g_cnm.cnm06) THEN
               SELECT azi01 FROM azi_file WHERE azi01 = g_cnm.cnm06
               IF STATUS THEN
#                   CALL cl_err('select azi',STATUS,0) #No.TQC-660045
                    CALL cl_err3("sel","azi_file",g_cnm.cnm06,"",STATUS,"","select azi",1)       #NO.TQC-660045
                   NEXT FIELD cnm06
               END IF
            END IF
       #BEFORE FIELD cnm07
       #    IF g_cnm.cnm04 MATCHES '[12]' THEN
       #       LET g_cnm.cnm07 = NULL
       #       LET g_cnm.cnm071= NULL
       #       LET g_cnm.cnm072= NULL
       #       DISPLAY BY NAME g_cnm.cnm07,g_cnm.cnm071,g_cnm.cnm072
       #       DISPLAY "" TO FORMONLY.desc1
       #       NEXT FIELD cnm08
       #    ELSE
       #       LET g_cnm.cnm08 = NULL
       #       LET g_cnm.cnm081= NULL
       #       LET g_cnm.cnm082= NULL
       #       DISPLAY BY NAME g_cnm.cnm08,g_cnm.cnm081,g_cnm.cnm082
       #       DISPLAY "" TO FORMONLY.desc2
       #    END IF
        AFTER FIELD cnm07                  #轉出方
            IF NOT cl_null(g_cnm.cnm07) THEN
               #-----MOD-940083---------
               #SELECT cnb04 INTO l_desc1 FROM cnb_file
               #    WHERE cnb01 = g_cnm.cnm07
               SELECT occ02 INTO l_desc1 FROM occ_file
                    WHERE occ01 = g_cnm.cnm07 
               #-----END MOD-940083-----
               IF STATUS THEN
#                   CALL cl_err(g_cnm.cnm07,STATUS,0) #No.TQC-660045
                    #CALL cl_err3("sel","cnb_file",g_cnm.cnm07,"",STATUS,"","",1)       #NO.TQC-660045   #MOD-940083
                    CALL cl_err3("sel","occ_file",g_cnm.cnm07,"",STATUS,"","",1)       #NO.TQC-660045   #MOD-940083
                   NEXT FIELD cnm07
               END IF
            END IF
            DISPLAY l_desc1 TO FORMONLY.desc1
           #EXIT INPUT   #MOD-8B0093 mark
 
 {#No.MOD-490398
        AFTER FIELD cnm071                  #手冊編號
            IF NOT cl_null(g_cnm.cnm071) THEN
               SELECT COUNT(*) INTO l_n FROM coc_file
                   WHERE coc03 = g_cnm.cnm071
                     AND cocacti !='N'  #010807增
               IF l_n <= 0 THEN
                   CALL cl_err(g_cnm.cnm071,'mfg9329',0)
                   NEXT FIELD cnm071
               END IF
            END IF
 }#No.MOD-490398 end
        AFTER FIELD cnm072                 #有效日期
            EXIT INPUT
 
        AFTER FIELD cnm08                  #轉入方
            IF NOT cl_null(g_cnm.cnm08) THEN
               SELECT pmc03 INTO l_desc2 FROM pmc_file
                   WHERE pmc01 = g_cnm.cnm08
               IF STATUS THEN
#                   CALL cl_err(g_cnm.cnm08,STATUS,0) #No.TQC-660045
                    CALL cl_err3("sel","pmc_file",g_cnm.cnm08,"",STATUS,"","",1)       #NO.TQC-660045
                   NEXT FIELD cnm08
               END IF
            END IF
            DISPLAY l_desc2 TO FORMONLY.desc2
 {#No.MOD-490398
        AFTER FIELD cnm081                  #手冊編號
            IF NOT cl_null(g_cnm.cnm08) THEN
               SELECT COUNT(*) INTO l_n FROM coc_file
                   WHERE coc03 = g_cnm.cnm081
                     AND cocacti !='N'  #010807增
 
               IF l_n <=0 THEN
                   CALL cl_err(g_cnm.cnm081,'mfg9329',0)
                   NEXT FIELD cnm081
               END IF
            END IF
 }#No.MOD-490398  end
 
        #FUN-840202     ---start---
        AFTER FIELD cnmud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnmud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
            ON ACTION controlp
            CASE
                WHEN INFIELD(cnm01) #單別
                     #CALL q_coy( FALSE, TRUE,g_cnm.cnm01,'15',g_sys) #TQC-670008
                     CALL q_coy( FALSE, TRUE,g_cnm.cnm01,'15','ACO')  #TQC-670008
                          RETURNING g_cnm.cnm01
#                     CALL FGL_DIALOG_SETBUFFER( g_cnm.cnm01 )
                     DISPLAY BY NAME g_cnm.cnm01
                     NEXT FIELD cnm01
                WHEN INFIELD(cnm05) #合同編號
                      #No.MOD-490398  --begin
                     IF g_cnm.cnm04 ='2' THEN
                        LET l_type = '0'        #成品
                     ELSE
                        LET l_type = '1'        #材料
                     END IF
                     CALL q_coc2(FALSE,TRUE,g_cnm.cnm05,'',g_cnm.cnm02,
                                 l_type,g_cnm.cnm09,'')
                          RETURNING g_cnm.cnm05,g_msg
                      #No.MOD-490398  --end
                     DISPLAY BY NAME g_cnm.cnm05
                     NEXT FIELD cnm05
                WHEN INFIELD(cnm06) #幣別
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_azi"
                     LET g_qryparam.default1 = g_cnm.cnm06
                     CALL cl_create_qry() RETURNING g_cnm.cnm06
#                     CALL FGL_DIALOG_SETBUFFER( g_cnm.cnm06 )
                     DISPLAY BY NAME g_cnm.cnm06
                     NEXT FIELD cnm06
                WHEN INFIELD(cnm07) #轉出方
                     CALL cl_init_qry_var()
                     #LET g_qryparam.form ="q_cnb"   #MOD-940083
                     LET g_qryparam.form ="q_occ"   #MOD-940083
                     LET g_qryparam.default1 = g_cnm.cnm07
                     CALL cl_create_qry() RETURNING g_cnm.cnm07
#                     CALL FGL_DIALOG_SETBUFFER( g_cnm.cnm07 )
                     DISPLAY BY NAME g_cnm.cnm07
                     NEXT FIELD cnm07
                WHEN INFIELD(cnm08) #轉入方
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_pmc"
                     LET g_qryparam.default1 = g_cnm.cnm08
                     CALL cl_create_qry() RETURNING g_cnm.cnm08
#                     CALL FGL_DIALOG_SETBUFFER( g_cnm.cnm08 )
                     DISPLAY BY NAME g_cnm.cnm08
                     NEXT FIELD cnm08
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
FUNCTION t600_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("cnm01",TRUE)
    END IF
    IF INFIELD(cnm04) OR (NOT g_before_input_done) THEN
        CALL cl_set_comp_entry("cnm07",TRUE)
    END IF
 
END FUNCTION
FUNCTION t600_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cnm01",FALSE)
    END IF
    IF INFIELD(cnm04) OR (NOT g_before_input_done) THEN
           IF g_cnm.cnm04 ='1' THEN                              #No.MOD-490398
               LET g_cnm.cnm07 = NULL
               LET g_cnm.cnm071= NULL
               LET g_cnm.cnm072= NULL
                DISPLAY BY NAME g_cnm.cnm07,g_cnm.cnm072          #No.MOD-490398
               DISPLAY "" TO FORMONLY.desc1
               CALL cl_set_comp_entry("cnm07",FALSE)
          ELSE
               LET g_cnm.cnm08 = NULL
               LET g_cnm.cnm081= NULL
               LET g_cnm.cnm082= NULL
                DISPLAY BY NAME g_cnm.cnm08,g_cnm.cnm082          #No.MOD-490398
               DISPLAY "" TO FORMONLY.desc2
          END IF
    END IF
END FUNCTION
 
FUNCTION t600_cnm04()       #轉廠類型
    DEFINE l_chr     LIKE ze_file.ze03       #No.FUN-680069  VARCHAR(8)
    CASE g_cnm.cnm04
         WHEN '1'    LET l_chr = cl_getmsg('aco-051',0)
         WHEN '2'    LET l_chr = cl_getmsg('aco-054',0)         #No.MOD-490398
    END CASE
    DISPLAY l_chr TO FORMONLY.desc
END FUNCTION
#Query 查詢
FUNCTION t600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cnm.* TO NULL             #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_cnn.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t600_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_cnm.* TO NULL
        RETURN
    END IF
    OPEN t600_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cnm.* TO NULL
    ELSE
        OPEN t600_count
        FETCH t600_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t600_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t600_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t600_cs INTO g_cnm.cnm01
        WHEN 'P' FETCH PREVIOUS t600_cs INTO g_cnm.cnm01
        WHEN 'F' FETCH FIRST    t600_cs INTO g_cnm.cnm01
        WHEN 'L' FETCH LAST     t600_cs INTO g_cnm.cnm01
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
         FETCH ABSOLUTE g_jump t600_cs INTO g_cnm.cnm01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnm.cnm01,SQLCA.sqlcode,0)
        INITIALIZE g_cnm.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_cnm.* FROM cnm_file WHERE cnm01 = g_cnm.cnm01
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_cnm.cnm01,SQLCA.sqlcode,0) #No.TQC-660045
         CALL cl_err3("sel","cnm_file",g_cnm.cnm01,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
        INITIALIZE g_cnm.* TO NULL
        RETURN
    END IF
 
    CALL t600_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t600_show()
    DEFINE
           #l_desc1   LIKE cnb_file.cnb04,   #公司名稱   #MOD-940083
           l_desc1   LIKE occ_file.occ02,   #公司名稱   #MOD-940083
           l_desc2   LIKE pmc_file.pmc03    #廠商名稱
    LET g_cnm_t.* = g_cnm.*                 #保存單頭舊值
    LET g_cnm_o.* = g_cnm.*                 #保存單頭舊值
     #No.MOD-490398
    DISPLAY BY NAME
        g_cnm.cnm01 ,g_cnm.cnm02 ,g_cnm.cnm03 ,g_cnm.cnm04  ,g_cnm.cnm05,
        g_cnm.cnm09 ,g_cnm.cnm06 ,g_cnm.cnm07 ,g_cnm.cnm072 ,g_cnm.cnm08,
        g_cnm.cnm082,g_cnm.cnmconf,g_cnm.cnmuser,g_cnm.cnmgrup,
        g_cnm.cnmmodu,g_cnm.cnmdate,g_cnm.cnmacti,
      #FUN-840202     ---start---
        g_cnm.cnmud01,g_cnm.cnmud02,g_cnm.cnmud03,g_cnm.cnmud04,
        g_cnm.cnmud05,g_cnm.cnmud06,g_cnm.cnmud07,g_cnm.cnmud08,
        g_cnm.cnmud09,g_cnm.cnmud10,g_cnm.cnmud11,g_cnm.cnmud12,
        g_cnm.cnmud13,g_cnm.cnmud14,g_cnm.cnmud15
      #FUN-840202     ----end----
     #No.MOD-490398 end
    #CALL cl_set_field_pic(g_cnm.cnmconf,"","","","",g_cnm.cnmacti)  #CHI-C80041
    IF g_cnm.cnmconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cnm.cnmconf,"","","",g_void,g_cnm.cnmacti)  #CHI-C80041
    CALL t600_cnm04()
    #-----MOD-940083---------
    #SELECT cnb04 INTO l_desc1 FROM cnb_file
    #    WHERE cnb01 = g_cnm.cnm07
    SELECT occ02 INTO l_desc1 FROM occ_file
        WHERE occ01 = g_cnm.cnm07
    #-----END MOD-940083----- 
    DISPLAY l_desc1 TO FORMONLY.desc1
    SELECT pmc03 INTO l_desc2 FROM pmc_file
        WHERE pmc01 = g_cnm.cnm08
    DISPLAY l_desc2 TO FORMONLY.desc2
    CALL t600_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t600_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cnm.cnm01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t600_cl USING g_cnm.cnm01
    IF STATUS THEN
       CALL cl_err("OPEN t600_cl:", STATUS, 1)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t600_cl INTO g_cnm.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnm.cnm01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    IF g_cnm.cnmconf='Y' THEN RETURN END IF
    CALL t600_show()
    IF cl_exp(0,0,g_cnm.cnmacti) THEN                   #審核一下
        LET g_chr=g_cnm.cnmacti
        IF g_cnm.cnmacti='Y' THEN
            LET g_cnm.cnmacti='N'
        ELSE
            LET g_cnm.cnmacti='Y'
        END IF
        UPDATE cnm_file                    #更改有效碼
            SET cnmacti=g_cnm.cnmacti
            WHERE cnm01=g_cnm.cnm01
        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_cnm.cnm01,SQLCA.sqlcode,0) #No.TQC-660045
             CALL cl_err3("upd","cnm_file",g_cnm.cnm01,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
            LET g_cnm.cnmacti=g_chr
        END IF
        DISPLAY BY NAME g_cnm.cnmacti
    END IF
    CLOSE t600_cl
    COMMIT WORK
 
    #CALL cl_set_field_pic(g_cnm.cnmconf,"","","","",g_cnm.cnmacti)  #CHI-C80041
    IF g_cnm.cnmconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cnm.cnmconf,"","","",g_void,g_cnm.cnmacti)  #CHI-C80041
    CALL cl_flow_notify(g_cnm.cnm01,'V')
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t600_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cnm.cnm01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_cnm.cnmconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_cnm.cnmconf = 'Y' THEN CALL cl_err('','9003',1) RETURN END IF
    IF g_cnm.cnmacti = 'N' THEN CALL cl_err('','9024',1) RETURN END IF
    BEGIN WORK
 
    OPEN t600_cl USING g_cnm.cnm01
    IF STATUS THEN
       CALL cl_err("OPEN t600_cl:", STATUS, 1)
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t600_cl INTO g_cnm.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cnm.cnm01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t600_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cnm01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cnm.cnm01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
            DELETE FROM cnm_file WHERE cnm01 = g_cnm.cnm01
            DELETE FROM cnn_file WHERE cnn01 = g_cnm.cnm01
        #No.MOD-490398
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980002 add azoplant,azolegal
          VALUES ('acot600',g_user,g_today,g_msg,g_cnm.cnm01,'delete',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
        #No.MOD-490398 end
            CLEAR FORM
            CALL g_cnn.clear()
 
         OPEN t600_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE t600_cs
            CLOSE t600_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH t600_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t600_cs
            CLOSE t600_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t600_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t600_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t600_fetch('/')
         END IF
    END IF
    CLOSE t600_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cnm.cnm01,'D')
END FUNCTION
 
#單身
FUNCTION t600_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT     #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680069 VARCHAR(1)
    l_cnn04         LIKE cnn_file.cnn04,   #商品編號
    l_cnn05         LIKE cnn_file.cnn05,   #申請數量
    l_cnn06         LIKE cnn_file.cnn06,   #單位
    l_cnn07         LIKE cnn_file.cnn07,   #單價
    l_cnn08         LIKE cnn_file.cnn08,   #總價
    l_allow_insert  LIKE type_file.num5,                #可新增否         #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否         #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_cnm.cnm01 IS NULL THEN RETURN END IF
    SELECT * INTO g_cnm.* FROM cnm_file WHERE cnm01 = g_cnm.cnm01
    IF g_cnm.cnmacti = 'N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cnm.cnm01,'mfg1000',0) #本資料為無效資料, 不可更改
        RETURN
    END IF
    IF g_cnm.cnmconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_cnm.cnmconf = 'Y' THEN RETURN END IF
    LET g_success = 'Y'
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql = "SELECT cnn02,cnn03,cnn04,cnn041,'',cnn05,cnn06,cnn07,cnn08, ",
                      #No.FUN-840202 --start--
                       "       cnnud01,cnnud02,cnnud03,cnnud04,cnnud05,",
                       "       cnnud06,cnnud07,cnnud08,cnnud09,cnnud10,",
                       "       cnnud11,cnnud12,cnnud13,cnnud14,cnnud15 ",
                      #No.FUN-840202 ---end---
                       "  FROM cnn_file ",
                       " WHERE cnn01 =?  AND cnn02 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
        IF g_rec_b=0 THEN CALL g_cnn.clear() END IF
 
        INPUT ARRAY g_cnn WITHOUT DEFAULTS FROM s_cnn.*
 
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
 
            OPEN t600_cl USING g_cnm.cnm01
            IF STATUS THEN
               CALL cl_err("OPEN t600_cl:", STATUS, 1)
               CLOSE t600_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t600_cl INTO g_cnm.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_cnm.cnm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t600_cl
              RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_cnn_t.* = g_cnn[l_ac].*  #BACKUP
                LET g_cnn_o.* = g_cnn[l_ac].*  #BACKUP
                OPEN t600_bcl USING g_cnm.cnm01,g_cnn_t.cnn02
                IF STATUS THEN
                   CALL cl_err("OPEN t600_bcl:", STATUS, 1)
                   CLOSE t600_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t600_bcl INTO g_cnn[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cnn_t.cnn02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   SELECT cob02 INTO g_cnn[l_ac].cob02 FROM cob_file
                       WHERE cob01 = g_cnn[l_ac].cnn04
                   END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
           #NEXT FIELD cnn02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
              INITIALIZE g_cnn[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_cnn[l_ac].* TO s_cnn.*
              CALL g_cnn.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO cnn_file(cnn01,cnn02,cnn03,cnn04,cnn041,
                                  cnn05,cnn051,cnn06,cnn07,cnn08,cnn09,#No.MOD-490398
                                #FUN-840202 --start--
                                  cnnud01,cnnud02,cnnud03,
                                  cnnud04,cnnud05,cnnud06,
                                  cnnud07,cnnud08,cnnud09,
                                  cnnud10,cnnud11,cnnud12,
                                  cnnud13,cnnud14,cnnud15,cnnplant,cnnlegal) #FUN-980002 add cnnplant,cnnlegal
                                #FUN-840202 --end--
            VALUES(g_cnm.cnm01,
                   g_cnn[l_ac].cnn02,g_cnn[l_ac].cnn03,
                   g_cnn[l_ac].cnn04,g_cnn[l_ac].cnn041,
                   g_cnn[l_ac].cnn05,0,g_cnn[l_ac].cnn06,
                    g_cnn[l_ac].cnn07,g_cnn[l_ac].cnn08,g_cnm.cnm09, #No.MOD-493098
                 #FUN-840202 --start--
                   g_cnn[l_ac].cnnud01, g_cnn[l_ac].cnnud02,
                   g_cnn[l_ac].cnnud03, g_cnn[l_ac].cnnud04,
                   g_cnn[l_ac].cnnud05, g_cnn[l_ac].cnnud06,
                   g_cnn[l_ac].cnnud07, g_cnn[l_ac].cnnud08,
                   g_cnn[l_ac].cnnud09, g_cnn[l_ac].cnnud10,
                   g_cnn[l_ac].cnnud11, g_cnn[l_ac].cnnud12,
                   g_cnn[l_ac].cnnud13, g_cnn[l_ac].cnnud14,
                   g_cnn[l_ac].cnnud15, g_plant, g_legal) #FUN-980002 add g_plant,g_legal
                 #FUN-840202 --end--
            IF SQLCA.sqlcode THEN
#                CALL cl_err(g_cnn[l_ac].cnn02,SQLCA.sqlcode,0) #No.TQC-660045
                 CALL cl_err3("ins","cnn_file",g_cnn[l_ac].cnn02,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
 
               ROLLBACK WORK
               CANCEL INSERT
                LET g_cnn[l_ac].* = g_cnn_t.*
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
            INITIALIZE g_cnn[l_ac].* TO NULL       #900423
            LET g_cnn_t.* = g_cnn[l_ac].*          #新輸入資料
            LET g_cnn_o.* = g_cnn[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnn02
 
        BEFORE FIELD cnn02                        #default 序號
            IF g_cnn[l_ac].cnn02 IS NULL OR g_cnn[l_ac].cnn02 = 0 THEN
                SELECT max(cnn02)+1
                   INTO g_cnn[l_ac].cnn02
                   FROM cnn_file
                   WHERE cnn01 = g_cnm.cnm01
                IF g_cnn[l_ac].cnn02 IS NULL THEN
                    LET g_cnn[l_ac].cnn02 = 1
                END IF
                 #DISPLAY g_cnn[l_ac].cnn02 TO cnn02  #No.MOD-490398
            END IF
 
        AFTER FIELD cnn02                        #check 序號是否重複
            IF NOT g_cnn[l_ac].cnn02 IS NULL THEN
               IF g_cnn[l_ac].cnn02 != g_cnn_t.cnn02 OR
                  g_cnn_t.cnn02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM cnn_file
                       WHERE cnn01 = g_cnm.cnm01 AND
                             cnn02 = g_cnn[l_ac].cnn02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cnn[l_ac].cnn02 = g_cnn_t.cnn02
                       NEXT FIELD cnn02
                   END IF
               END IF
            END IF
        BEFORE FIELD cnn03
            SELECT coc01 INTO g_coc01 FROM coc_file
                 #WHERE coc04 = g_cnm.cnm05  #No.MOD-490398
                 WHERE coc03 = g_cnm.cnm05  #No.MOD-490398
                  AND cocacti !='N'  #010807增
 
        AFTER FIELD cnn03
            IF NOT cl_null(g_cnn[l_ac].cnn03) THEN
               IF g_cnn[l_ac].cnn03 != g_cnn_t.cnn03 OR
                  g_cnn_t.cnn03 IS NULL THEN
                   SELECT count(*) INTO l_n FROM cnn_file
                       WHERE cnn01 = g_cnm.cnm01 AND
                             cnn03 = g_cnn[l_ac].cnn03
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cnn[l_ac].cnn03 = g_cnn_t.cnn03
                       NEXT FIELD cnn03
                   END IF
                   CALL t600_cnn03('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      NEXT FIELD cnn03
                   END IF
               END IF
               SELECT cob02 INTO g_cnn[l_ac].cob02 FROM cob_file
                   WHERE cob01 = g_cnn[l_ac].cnn04
                #DISPLAY g_cnn[l_ac].cob02 TO cob02  #No.MOD-493098
            END IF
 
        AFTER FIELD cnn05
            IF NOT cl_null(g_cnn[l_ac].cnn05) THEN
            #FUN-BB0084 ----------Begin-----------
               IF NOT cl_null(g_cnn[l_ac].cnn06) THEN
                  LET g_cnn[l_ac].cnn05 = s_digqty(g_cnn[l_ac].cnn05,g_cnn[l_ac].cnn06)
                  DISPLAY BY NAME g_cnn[l_ac].cnn05
               END IF
            #FUN-BB0084 ----------End-------------
               CALL t600_cnn03('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD cnn05
               END IF
            END IF
            LET g_cnn[l_ac].cnn08 = g_cnn[l_ac].cnn05 * g_cnn[l_ac].cnn07     #MOD-9C0333 add

        AFTER FIELD cnn07                                                     #MOD-9C0333 add
            LET g_cnn[l_ac].cnn08 = g_cnn[l_ac].cnn05 * g_cnn[l_ac].cnn07     #MOD-9C0333 add
        
        BEFORE FIELD cnn08
            LET g_cnn[l_ac].cnn08 = g_cnn[l_ac].cnn05 * g_cnn[l_ac].cnn07
            DISPLAY g_cnn[l_ac].cnn08 TO cnn08
 
        #No.FUN-840202 --start--
        AFTER FIELD cnnud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cnnud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_cnn_t.cnn02 > 0 AND
               g_cnn_t.cnn02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM cnn_file
                    WHERE cnn01 = g_cnm.cnm01 AND
                          cnn02 = g_cnn_t.cnn02
                IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_cnn_t.cnn02,SQLCA.sqlcode,0) #No.TQC-660045
                     CALL cl_err3("del","cnn_file",g_cnn_t.cnn02,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
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
               LET g_cnn[l_ac].* = g_cnn_t.*
               CLOSE t600_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cnn[l_ac].cnn02,-263,1)
               LET g_cnn[l_ac].* = g_cnn_t.*
            ELSE
               UPDATE cnn_file SET
                      cnn02=g_cnn[l_ac].cnn02,cnn03=g_cnn[l_ac].cnn03,
                      cnn04=g_cnn[l_ac].cnn04,cnn041=g_cnn[l_ac].cnn041,
                      cnn05=g_cnn[l_ac].cnn05,cnn06=g_cnn[l_ac].cnn06,
                      cnn07=g_cnn[l_ac].cnn07,cnn08=g_cnn[l_ac].cnn08,
                    #FUN-840202 --start--
                      cnnud01 = g_cnn[l_ac].cnnud01,
                      cnnud02 = g_cnn[l_ac].cnnud02,
                      cnnud03 = g_cnn[l_ac].cnnud03,
                      cnnud04 = g_cnn[l_ac].cnnud04,
                      cnnud05 = g_cnn[l_ac].cnnud05,
                      cnnud06 = g_cnn[l_ac].cnnud06,
                      cnnud07 = g_cnn[l_ac].cnnud07,
                      cnnud08 = g_cnn[l_ac].cnnud08,
                      cnnud09 = g_cnn[l_ac].cnnud09,
                      cnnud10 = g_cnn[l_ac].cnnud10,
                      cnnud11 = g_cnn[l_ac].cnnud11,
                      cnnud12 = g_cnn[l_ac].cnnud12,
                      cnnud13 = g_cnn[l_ac].cnnud13,
                      cnnud14 = g_cnn[l_ac].cnnud14,
                      cnnud15 = g_cnn[l_ac].cnnud15
                    #FUN-840202 --end-- 
               WHERE cnn01 = g_cnm.cnm01 AND cnn02 = g_cnn_t.cnn02
               IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cnn[l_ac].cnn02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("upd","cnn_file",g_cnn[l_ac].cnn02,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
                   LET g_cnn[l_ac].* = g_cnn_t.*
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
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
               IF p_cmd='u' THEN
                  LET g_cnn[l_ac].* = g_cnn_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cnn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t600_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add 
          #LET g_cnn_t.* = g_cnn[l_ac].*          # 900423
            CLOSE t600_bcl
            COMMIT WORK
 
           #CALL g_cnn.deleteElement(g_rec_b+1)   #FUN-D30034 Mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cnn02) AND l_ac > 1 THEN
                LET g_cnn[l_ac].* = g_cnn[l_ac-1].*
                NEXT FIELD cnn02
            END IF
        ON ACTION controls                       # No.FUN-6B0033
           CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(cnn03) #公司序號
                     CASE
                          WHEN g_cnm.cnm04 = 1   #No.MOD-490398
                              CALL q_coe(FALSE,TRUE,g_coc01,g_cnn[l_ac].cnn03)
                                  RETURNING g_coc01,g_cnn[l_ac].cnn03
#                              CALL FGL_DIALOG_SETBUFFER( g_coc01 )
#                              CALL FGL_DIALOG_SETBUFFER( g_cnn[l_ac].cnn03 )
                              DISPLAY g_coc01,g_cnn[l_ac].cnn03 TO coc01,cnn03
                              NEXT FIELD cnn03
                          WHEN g_cnm.cnm04 = 2   #No.MOD-490398
                              CALL q_cod(FALSE,TRUE,g_coc01,g_cnn[l_ac].cnn03)
                                  RETURNING g_coc01,g_cnn[l_ac].cnn03
#                              CALL FGL_DIALOG_SETBUFFER( g_coc01 )
#                              CALL FGL_DIALOG_SETBUFFER( g_cnn[l_ac].cnn03 )
                              DISPLAY g_coc01,g_cnn[l_ac].cnn03 TO coc01,cnn03
                              NEXT FIELD cnn03
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
    LET g_cnm.cnmmodu = g_user
    LET g_cnm.cnmdate = g_today
    UPDATE cnm_file SET cnmmodu = g_cnm.cnmmodu,cnmdate = g_cnm.cnmdate
     WHERE cnm01 = g_cnm.cnm01
    DISPLAY BY NAME g_cnm.cnmmodu,g_cnm.cnmdate
    #FUN-5B0043-end
 
    CLOSE t600_bcl
    COMMIT WORK
    CALL t600_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t600_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_cnm.cnm01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM cnm_file ",
                  "  WHERE cnm01 LIKE '",l_slip,"%' ",
                  "    AND cnm01 > '",g_cnm.cnm01,"'"
      PREPARE t600_pb1 FROM l_sql 
      EXECUTE t600_pb1 INTO l_cnt       
      
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
         CALL t600_v()
         IF g_cnm.cnmconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_cnm.cnmconf,"","","",g_void,g_cnm.cnmacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM cnm_file WHERE cnm01 = g_cnm.cnm01
         INITIALIZE g_cnm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t600_cnn03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_qty     LIKE cnn_file.cnn05
 
    LET g_errno = ' '
    #按型態判斷不同檔案(出口/進口)
     IF g_cnm.cnm04 ='2' THEN  #成品    #No.MOD-490398
       SELECT cod03,cod041,cod05+cod10,cod06,cod07
         INTO g_cnn[l_ac].cnn04,g_cnn[l_ac].cnn041,
              l_qty,g_cnn[l_ac].cnn06,
              g_cnn[l_ac].cnn07
         FROM cod_file
        WHERE cod01=g_coc01 AND cod02=g_cnn[l_ac].cnn03
        CALL s_codqty(g_cnm.cnm05,g_cnn[l_ac].cnn03) RETURNING l_qty  #剩餘量
        #------MOD-5A0095 START----------
        DISPLAY BY NAME g_cnn[l_ac].cnn04
        DISPLAY BY NAME g_cnn[l_ac].cnn041
        DISPLAY BY NAME g_cnn[l_ac].cnn06
        DISPLAY BY NAME g_cnn[l_ac].cnn07
        #------MOD-5A0095 END------------
    END IF
    IF g_cnm.cnm04 ='1' THEN  #材料   #No.MOD-490398
       SELECT coe03,coe05+coe10,coe06,coe07
         INTO g_cnn[l_ac].cnn04,
              l_qty,g_cnn[l_ac].cnn06,
              g_cnn[l_ac].cnn07
         FROM coe_file
        WHERE coe01 = g_coc01 AND coe02=g_cnn[l_ac].cnn03
       CALL s_coeqty(g_cnm.cnm05,g_cnn[l_ac].cnn03) RETURNING l_qty  #剩餘量
       #------MOD-5A0095 START----------
       DISPLAY BY NAME g_cnn[l_ac].cnn04
       DISPLAY BY NAME g_cnn[l_ac].cnn041
       DISPLAY BY NAME g_cnn[l_ac].cnn06
       DISPLAY BY NAME g_cnn[l_ac].cnn07
       #------MOD-5A0095 END------------
    END IF
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-062' #No.MOD-490398
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'a' THEN
       LET g_cnn[l_ac].cnn05 = l_qty
    END IF
    LET g_cnn[l_ac].cnn05 = s_digqty(g_cnn[l_ac].cnn05,g_cnn[l_ac].cnn06)   #FUN-BB0084
    DISPLAY BY NAME g_cnn[l_ac].cnn06      #FUN-BB0084
    #------MOD-5A0095 START----------
    DISPLAY BY NAME g_cnn[l_ac].cnn05
    #------MOD-5A0095 END------------
    IF p_cmd='d' THEN
       IF g_cnn[l_ac].cnn05 > l_qty THEN LET g_errno = 'aco-046' END IF
    END IF
END FUNCTION
 
FUNCTION t600_delall()
    SELECT COUNT(*) INTO g_cnt FROM cnn_file
        WHERE cnn01 = g_cnm.cnm01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否撤銷單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM cnm_file WHERE cnm01 = g_cnm.cnm01
    END IF
END FUNCTION
 
FUNCTION t600_b_askkey()
DEFINE
    l_wc2          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON cnn02,cnn03,cnn04,cnn041,cnn05,cnn06,
                       cnn07,cnn08        # 螢幕上取單身條件
                      #No.FUN-840202 --start--
                      ,cnnud01,cnnud02,cnnud03,cnnud04,cnnud05
                      ,cnnud06,cnnud07,cnnud08,cnnud09,cnnud10
                      ,cnnud11,cnnud12,cnnud13,cnnud14,cnnud15
                      #No.FUN-840202 ---end---
            FROM s_cnn[1].cnn02 ,s_cnn[1].cnn03,s_cnn[1].cnn04,
                 s_cnn[1].cnn041,s_cnn[1].cnn05,s_cnn[1].cnn06,
                 s_cnn[1].cnn07, s_cnn[1].cnn08
               #No.FUN-840202 --start--
                ,s_cnn[1].cnnud01,s_cnn[1].cnnud02,s_cnn[1].cnnud03
                ,s_cnn[1].cnnud04,s_cnn[1].cnnud05,s_cnn[1].cnnud06
                ,s_cnn[1].cnnud07,s_cnn[1].cnnud08,s_cnn[1].cnnud09
                ,s_cnn[1].cnnud10,s_cnn[1].cnnud11,s_cnn[1].cnnud12
                ,s_cnn[1].cnnud13,s_cnn[1].cnnud14,s_cnn[1].cnnud15
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
 
        #No.MOD-490398  --begin
       ON ACTION controlp
          CASE
              WHEN INFIELD(cnn03) #公司序號
                   CASE
                        WHEN g_cnm.cnm04 = 1 #No.MOD-490398
                            CALL q_coe(TRUE,TRUE,g_coc01,g_cnn[1].cnn03)
                                RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO cnn03
                            DISPLAY g_cnn[1].cnn03 TO cnn03
                            NEXT FIELD cnn03
                        WHEN g_cnm.cnm04 = 2 #No.MOD-490398
                            CALL q_cod(TRUE,TRUE,g_coc01,g_cnn[1].cnn03)
                                RETURNING g_qryparam.multiret
                            DISPLAY g_qryparam.multiret TO cnn03
                            NEXT FIELD cnn03
                       OTHERWISE EXIT CASE
                   END CASE
             OTHERWISE EXIT CASE
          END CASE
        #No.MOD-490398  --end
 
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
    CALL t600_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t600_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       LIKE type_file.chr1000     #No.FUN-680069 VARCHAR(200)
 
    LET g_sql =
        "SELECT cnn02,cnn03,cnn04,cnn041,'',cnn05,cnn06,cnn07,cnn08,",
        #No.FUN-840202 --start--
        "       cnnud01,cnnud02,cnnud03,cnnud04,cnnud05,",
        "       cnnud06,cnnud07,cnnud08,cnnud09,cnnud10,",
        "       cnnud11,cnnud12,cnnud13,cnnud14,cnnud15 ",
        #No.FUN-840202 ---end---
        "    FROM cnn_file ",
        "    WHERE cnn01 ='",g_cnm.cnm01,"'"    #單頭
    #No.FUN-8B0123---Begin
    #   "      AND ", p_wc2 CLIPPED,            #單身
    #   "    ORDER BY 1,2"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1,2 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE t600_pb FROM g_sql
    DECLARE cnn_cs                       #SCROLL CURSOR
        CURSOR FOR t600_pb
 
    CALL g_cnn.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH cnn_cs INTO g_cnn[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT cob02 INTO g_cnn[g_cnt].cob02 FROM cob_file
            WHERE cob01 = g_cnn[g_cnt].cnn04
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
 
    CALL g_cnn.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cnn TO s_cnn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t600_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t600_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t600_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t600_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t600_fetch('L')
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
 
         #CALL cl_set_field_pic(g_cnm.cnmconf,"","","","",g_cnm.cnmacti)  #CHI-C80041
         IF g_cnm.cnmconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_cnm.cnmconf,"","","",g_void,g_cnm.cnmacti)  #CHI-C80041
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
 
 
FUNCTION t600_firm1()
DEFINE l_cnm01_old LIKE cnm_file.cnm01
 
  LET l_cnm01_old=g_cnm.cnm01    # backup old key value cnm01
  IF g_cnm.cnm01 IS NULL THEN RETURN END IF
#CHI-C30107 ---------- add ---------- begin
  IF g_cnm.cnmconf = 'X' THEN RETURN END IF  #CHI-C80041
  IF g_cnm.cnmconf='Y' THEN RETURN END IF
  IF g_cnm.cnmacti='N' THEN CALL cl_err('','9024',0) RETURN END IF

   SELECT COUNT(*) INTO g_cnt FROM cnn_file
    WHERE cnn01 = g_cnm.cnm01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ---------- add ---------- end
  SELECT * INTO g_cnm.* FROM cnm_file WHERE cnm01=g_cnm.cnm01
  IF g_cnm.cnmconf = 'X' THEN RETURN END IF  #CHI-C80041
  IF g_cnm.cnmconf='Y' THEN RETURN END IF
  IF g_cnm.cnmacti='N' THEN CALL cl_err('','9024',0) RETURN END IF
 
   #no.7377
   SELECT COUNT(*) INTO g_cnt FROM cnn_file
    WHERE cnn01 = g_cnm.cnm01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   #no.7377(end)
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
    LET g_success='Y'
    BEGIN WORK
        IF g_success='N' THEN
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE cnm_file SET cnmconf = 'Y' WHERE cnm01 = g_cnm.cnm01
        IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('upd cnmconf',STATUS,1) #No.TQC-660045
             CALL cl_err3("upd","cnm_file",g_cnm.cnm01,"",STATUS,"","upd cnmconf",1)       #NO.TQC-660045
            SELECT * INTO g_cnm.* FROM cnm_file WHERE cnm01 = l_cnm01_old
            ROLLBACK WORK
            RETURN
        END IF
        IF g_success='N' THEN
            SELECT * INTO g_cnm.* FROM cnm_file WHERE cnm01 = l_cnm01_old
            ROLLBACK WORK
            RETURN
        ELSE
            COMMIT WORK
            CALL cl_flow_notify(g_cnm.cnm01,'Y')
            CALL cl_cmmsg(1)
        END IF
        SELECT * INTO g_cnm.* FROM cnm_file WHERE cnm01 = l_cnm01_old
        DISPLAY g_cnm.cnmconf TO cnmconf
        #CALL cl_set_field_pic(g_cnm.cnmconf,"","","","",g_cnm.cnmacti)  #CHI-C80041
        IF g_cnm.cnmconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
        CALL cl_set_field_pic(g_cnm.cnmconf,"","","",g_void,g_cnm.cnmacti)  #CHI-C80041
END FUNCTION
 
FUNCTION t600_firm2()
    DEFINE l_cnm01_old LIKE cnm_file.cnm01
 
    LET l_cnm01_old=g_cnm.cnm01    # backup old key value gsb01
    LET g_success='Y'
    BEGIN WORK
        IF g_cnm.cnmconf = 'X' THEN RETURN END IF  #CHI-C80041
        IF g_cnm.cnmconf='N' THEN RETURN END IF
        IF g_cnm.cnmacti='N' THEN RETURN END IF
        IF NOT cl_confirm('axm-109') THEN RETURN END IF
        SELECT COUNT(*) INTO g_cnt FROM cno_file
         WHERE cno05 = g_cnm.cnm01
        IF g_cnt > 0 THEN
           CALL cl_err(g_cnm.cnm01,'aco-079',0) LET g_success = 'N'
        END IF
        IF g_success='N'THEN ROLLBACK WORK RETURN END IF
        UPDATE cnm_file SET cnmconf = 'N' WHERE cnm01 = g_cnm.cnm01
        IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('upd cnmconf',STATUS,1) #No.TQC-660045
             CALL cl_err3("upd","cnm_file",g_cnm.cnm01,"",STATUS,"","upd cnmconf",1)       #NO.TQC-660045
            SELECT * INTO g_cnm.* FROM cnm_file WHERE cnm01 = l_cnm01_old
            ROLLBACK WORK
            RETURN
        END IF
        IF g_success='N' THEN
            SELECT * INTO g_cnm.* FROM cnm_file WHERE cnm01 = l_cnm01_old
            ROLLBACK WORK RETURN
        ELSE
            COMMIT WORK
            CALL cl_cmmsg(1)
        END IF
        SELECT * INTO g_cnm.* FROM cnm_file WHERE cnm01 = l_cnm01_old
        DISPLAY g_cnm.cnmconf TO cnmconf
        #CALL cl_set_field_pic(g_cnm.cnmconf,"","","","",g_cnm.cnmacti) #CHI-C80041
        IF g_cnm.cnmconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
        CALL cl_set_field_pic(g_cnm.cnmconf,"","","",g_void,g_cnm.cnmacti)  #CHI-C80041
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002,003> #
#Patch....NO.TQC-610035 <001> #
#CHI-C80041---begin
FUNCTION t600_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_cnm.cnm01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t600_cl USING g_cnm.cnm01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_cnm.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cnm.cnm01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t600_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_cnm.cnmconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_cnm.cnmconf)   THEN 
        LET l_chr=g_cnm.cnmconf
        IF g_cnm.cnmconf='N' THEN 
            LET g_cnm.cnmconf='X' 
        ELSE
            LET g_cnm.cnmconf='N'
        END IF
        UPDATE cnm_file
            SET cnmconf=g_cnm.cnmconf,  
                cnmmodu=g_user,
                cnmdate=g_today
            WHERE cnm01=g_cnm.cnm01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","cnm_file",g_cnm.cnm01,"",SQLCA.sqlcode,"","",1)  
            LET g_cnm.cnmconf=l_chr 
        END IF
        DISPLAY BY NAME g_cnm.cnmconf 
   END IF
 
   CLOSE t600_cl
   COMMIT WORK
   CALL cl_flow_notify(g_cnm.cnm01,'V')
 
END FUNCTION
#CHI-C80041---end
