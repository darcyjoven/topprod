# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acot800.4gl
# Descriptions...: 進口設備報關維護作業
# Date & Author..: 00/07/26 By Carol
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-550036 05/05/26 By Trisy 單據編號加大
# Modify.........: No.FUN-560002 05/06/06 By vivien 單據編號修改
# Modify.........: No.FUN-570273 05/07/29 By Dido  單身未輸入確認無法跳出視窗
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-630014 06/03/07 By Carol 流程訊息通知功能
# MOdify.........: No.TQC-660045 06/06/09 BY hellen  cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7C0155 07/12/21 By Carol add t800_b() call q_cot() arg1傳入值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/09 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-960256 09/06/22 By baofei  Mark 掉LET g_qryparam.where = "cos08= g_cou.cou03"
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BB0086 12/01/06 By tanxc 增加數量欄位小數取位 
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C70236 12/07/25 By ck2yuan 刪除時,單身可能無資料,所以應該看SQLCA.sqlcode
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cou           RECORD LIKE cou_file.*,       #單頭
    g_cou_t         RECORD LIKE cou_file.*,       #單頭(舊值)
    g_cou_o         RECORD LIKE cou_file.*,       #單頭(舊值)
    g_cou01_t       LIKE cou_file.cou01,          #單頭 (舊值)
    g_t1            LIKE oay_file.oayslip,        #No.FUN-550036    #No.FUN-680069 VARCHAR(05)
    g_cov           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        cov02       LIKE cov_file.cov02,      #項次
        cov03       LIKE cov_file.cov03,      #
        cov04       LIKE cov_file.cov04,      #
        cov05       LIKE cov_file.cov05,      #
        cov06       LIKE cov_file.cov06,      #
        cov07       LIKE cov_file.cov07,      #
        cov08       LIKE cov_file.cov08       #
        #FUN-840202 --start---
        ,covud01    LIKE cov_file.covud01,
        covud02     LIKE cov_file.covud02,
        covud03     LIKE cov_file.covud03,
        covud04     LIKE cov_file.covud04,
        covud05     LIKE cov_file.covud05,
        covud06     LIKE cov_file.covud06,
        covud07     LIKE cov_file.covud07,
        covud08     LIKE cov_file.covud08,
        covud09     LIKE cov_file.covud09,
        covud10     LIKE cov_file.covud10,
        covud11     LIKE cov_file.covud11,
        covud12     LIKE cov_file.covud12,
        covud13     LIKE cov_file.covud13,
        covud14     LIKE cov_file.covud14,
        covud15     LIKE cov_file.covud15
        #FUN-840202 --end--
                    END RECORD,
    g_cov_t         RECORD                 #程式變數 (舊值)
        cov02       LIKE cov_file.cov02,   #項次
        cov03       LIKE cov_file.cov03,   #
        cov04       LIKE cov_file.cov04,   #
        cov05       LIKE cov_file.cov05,   #
        cov06       LIKE cov_file.cov06,   #
        cov07       LIKE cov_file.cov07,   #
        cov08       LIKE cov_file.cov08    #
        #FUN-840202 --start---
        ,covud01    LIKE cov_file.covud01,
        covud02     LIKE cov_file.covud02,
        covud03     LIKE cov_file.covud03,
        covud04     LIKE cov_file.covud04,
        covud05     LIKE cov_file.covud05,
        covud06     LIKE cov_file.covud06,
        covud07     LIKE cov_file.covud07,
        covud08     LIKE cov_file.covud08,
        covud09     LIKE cov_file.covud09,
        covud10     LIKE cov_file.covud10,
        covud11     LIKE cov_file.covud11,
        covud12     LIKE cov_file.covud12,
        covud13     LIKE cov_file.covud13,
        covud14     LIKE cov_file.covud14,
        covud15     LIKE cov_file.covud15
        #FUN-840202 --end--
                    END RECORD,
    g_cov_o         RECORD                 #程式變數 (舊值)
        cov02       LIKE cov_file.cov02,   #項次
        cov03       LIKE cov_file.cov03,   #
        cov04       LIKE cov_file.cov04,   #
        cov05       LIKE cov_file.cov05,   #
        cov06       LIKE cov_file.cov06,   #
        cov07       LIKE cov_file.cov07,   #
        cov08       LIKE cov_file.cov08    #
        #FUN-840202 --start---
        ,covud01    LIKE cov_file.covud01,
        covud02     LIKE cov_file.covud02,
        covud03     LIKE cov_file.covud03,
        covud04     LIKE cov_file.covud04,
        covud05     LIKE cov_file.covud05,
        covud06     LIKE cov_file.covud06,
        covud07     LIKE cov_file.covud07,
        covud08     LIKE cov_file.covud08,
        covud09     LIKE cov_file.covud09,
        covud10     LIKE cov_file.covud10,
        covud11     LIKE cov_file.covud11,
        covud12     LIKE cov_file.covud12,
        covud13     LIKE cov_file.covud13,
        covud14     LIKE cov_file.covud14,
        covud15     LIKE cov_file.covud15
        #FUN-840202 --end--
                    END RECORD,
    g_argv1         LIKE cov_file.cov01,   # 詢價單號
    g_argv2         STRING,                #No.FUN-680069 STRING   #FUN-630014 指定執行的功能
    g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN       #No.FUN-680069
    g_rec_b         LIKE type_file.num5,                  #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5,                  #目前處理的ARRAY CNT  #No.FUN-680069 SMALLINT
    l_sl            LIKE type_file.num5                   #No.FUN-680069 SMALLINT  #目前處理的SCREEN LINE
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   #No.FUN-680069
DEFINE g_before_input_done LIKE type_file.num5        #No.FUN-680069 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose  #No.FUN-680069 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680069 INTEGER
 
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680069 SMALLINT
MAIN
DEFINE
#       l_time    LIKE type_file.chr8                   #No.FUN-6A0063
    p_row,p_col           LIKE type_file.num5         #No.FUN-680069 SMALLINT
 
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
 
    LET g_forupd_sql = " SELECT * FROM cou_file WHERE cou01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t800_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 15
    OPEN WINDOW t800_w AT p_row,p_col
        WITH FORM "aco/42f/acot800"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   #FUN-630014 --start--
   #IF g_argv1 IS NOT NULL AND g_argv1 != ' '
   #THEN CALL t800_q()
   #END IF
   # 先以g_argv2判斷直接執行哪種功能
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t800_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t800_a()
            END IF
         OTHERWISE
            CALL t800_q()
      END CASE
   END IF
   #FUN-630014 ---end---
 
    CALL t800_menu()
    CLOSE WINDOW t800_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION t800_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  CLEAR FORM                             #清除畫面
  CALL g_cov.clear()
 
 #IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN  #FUN-630014 modify
  IF NOT cl_null(g_argv1) THEN                    #FUN-630014 
     LET g_wc = " cou01 = '",g_argv1,"'"
     LET g_wc2 = " 1=1"
  ELSE
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
   INITIALIZE g_cou.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
        cou01,cou02,cou03,cou04,cou06,cou05,cou07,cou08,cou09,cou10,
        cou11,cou12,cou13,cou14,cou15,
        couuser,cougrup,coumodu,coudate,couacti
        #FUN-840202   ---start---
        ,couud01,couud02,couud03,couud04,couud05,
        couud06,couud07,couud08,couud09,couud10,
        couud11,couud12,couud13,couud14,couud15
        #FUN-840202    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
     ON ACTION controlp  #ok
            CASE
               WHEN INFIELD(cou01) #單別
                    #CALL q_coy(FALSE,TRUE,g_cou.cou01,'16',g_sys) #TQC-670008
                    CALL q_coy(FALSE,TRUE,g_cou.cou01,'16','ACO')  #TQC-670008
                         RETURNING g_cou.cou01
                    DISPLAY BY NAME g_cou.cou01
                    NEXT FIELD cou01
               WHEN INFIELD(cou10) #國別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_geb"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cou10
                    NEXT FIELD cou10
               WHEN INFIELD(cou11) #幣別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_azi"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cou11
                    NEXT FIELD cou11
                WHEN INFIELD(cou03) #備案編號
                     CALL q_cos( FALSE, TRUE,g_cou.cou03)
                          RETURNING g_cou.cou03
                     DISPLAY BY NAME g_cou.cou03
                     NEXT FIELD cou03
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
 #螢幕上取單身條件
    CONSTRUCT g_wc2 ON cov02,cov03,cov04,cov05,cov06,cov07,cov08
                       #No.FUN-840202 --start--
                       ,covud01,covud02,covud03,covud04,covud05,
                       covud06,covud07,covud08,covud09,covud10,
                       covud11,covud12,covud13,covud14,covud15
                       #No.FUN-840202 ---end---
            FROM s_cov[1].cov02,s_cov[1].cov03,s_cov[1].cov04,
                 s_cov[1].cov05,s_cov[1].cov06,s_cov[1].cov07,
                 s_cov[1].cov08
                 #No.FUN-840202 --start--
                 ,s_cov[1].covud01,s_cov[1].covud02,s_cov[1].covud03,s_cov[1].covud04,s_cov[1].covud05,
                 s_cov[1].covud06,s_cov[1].covud07,s_cov[1].covud08,s_cov[1].covud09,s_cov[1].covud10,
                 s_cov[1].covud11,s_cov[1].covud12,s_cov[1].covud13,s_cov[1].covud14,s_cov[1].covud15
                 #No.FUN-840202 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       ON ACTION controlp
            CASE
               WHEN INFIELD(cov03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_cot"
      #              LET g_qryparam.where = "cos08= g_cou.cou03"    #TQC-960256    
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cov03
                    NEXT FIELD cov03
               WHEN INFIELD(cov05)  #國別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_geb"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cov05
                    NEXT FIELD cov05
               WHEN INFIELD(cov07) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cov07
                    NEXT FIELD cov07
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
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND couuser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND cougrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND cougrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('couuser', 'cougrup')
  #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT cou01 FROM cou_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY cou01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cou01 ",
                   "  FROM cou_file,cov_file ",
                   " WHERE cou01 = cov01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY cou01"
    END IF
 
    PREPARE t800_prepare FROM g_sql
    DECLARE t800_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t800_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM cou_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM cou_file,cov_file WHERE ",
                  "cov01=cou01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t800_precount FROM g_sql
    DECLARE t800_count CURSOR FOR t800_precount
END FUNCTION
 
FUNCTION t800_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069 VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL t800_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t800_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t800_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t800_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t800_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t800_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t800_b()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cov),'','')
             END IF
         #--
 
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_cou.cou01 IS NOT NULL THEN
                 LET g_doc.column1 = "cou01"
                 LET g_doc.value1 = g_cou.cou01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t800_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550036        #No.FUN-680069 SMALLINT
    MESSAGE ""
    CLEAR FORM
    CALL g_cov.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_cou.* LIKE cou_file.*             #DEFAULT 設置
    LET g_cou01_t = NULL
    LET g_cou_t.* = g_cou.*
    LET g_cou_o.* = g_cou.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cou.cou06  = g_today
        LET g_cou.couuser=g_user
        LET g_data_plant = g_plant #FUN-980030
        LET g_cou.cougrup=g_grup
        LET g_cou.coudate=g_today
        LET g_cou.couacti='Y'              #資料有效
        LET g_cou.couplant = g_plant  #FUN-980002
        LET g_cou.coulegal = g_legal  #FUN-980002
 
        BEGIN WORK
        CALL t800_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            INITIALIZE g_cou.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cou.cou01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
#No.FUN-550036 --start--
#       IF cl_null(g_cou.cou01[g_no_sp,g_no_ep]) THEN
        CALL s_auto_assign_no("aco",g_cou.cou01,g_today,"16","cou_file","cou01","","","")
        RETURNING li_result,g_cou.cou01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
#       IF cl_null(g_cou.cou01[5,10]) THEN              #自動編號
#          CALL s_acoauno(g_cou.cou01,g_today,'16')
#            RETURNING g_i,g_cou.cou01
#          IF g_i THEN CONTINUE WHILE END IF
           DISPLAY BY NAME g_cou.cou01
#       END IF
        LET g_cou.couoriu = g_user      #No.FUN-980030 10/01/04
        LET g_cou.couorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cou_file VALUES (g_cou.*)
#       LET g_t1 = g_cou.cou01[1,3]           #備份上一筆單別
        LET g_t1 = s_get_doc_no(g_cou.cou01)  #No.FUN-550036
#No.FUN-550036 ---end---
        IF SQLCA.sqlcode THEN                      #置入資料庫不成功
#           CALL cl_err(g_cou.cou01,SQLCA.sqlcode,1) #No.TQC-660045
            CALL cl_err3("ins","cou_file",g_cou.cou01,"",SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_cou.cou01,'I')
        SELECT cou01 INTO g_cou.cou01 FROM cou_file
            WHERE cou01 = g_cou.cou01
        LET g_cou01_t = g_cou.cou01        #保留舊值
        LET g_cou_t.* = g_cou.*
        LET g_cou_o.* = g_cou.*
        LET g_rec_b=0
        CALL t800_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t800_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cou.cou01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_cou.* FROM cou_file WHERE cou01=g_cou.cou01
    IF g_cou.couacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cou.cou01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cou01_t = g_cou.cou01
    BEGIN WORK
 
    OPEN t800_cl USING g_cou.cou01
    IF STATUS THEN
       CALL cl_err("OPEN t800_cl:", STATUS, 1)
       CLOSE t800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t800_cl INTO g_cou.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cou.cou01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t800_cl
        RETURN
    END IF
    CALL t800_show()
    WHILE TRUE
        LET g_cou01_t = g_cou.cou01
        LET g_cou_o.* = g_cou.*
        LET g_cou.coumodu=g_user
        LET g_cou.coudate=g_today
        CALL t800_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cou.*=g_cou_t.*
            CALL t800_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_cou.cou01 != g_cou01_t THEN            # 更改單號
            UPDATE cov_file SET cov01 = g_cou.cou01
                WHERE cov01 = g_cou01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('cov',SQLCA.sqlcode,0)  #No.TQC-660045
                CALL cl_err3("upd","cov_file",g_cou01_t,"",SQLCA.sqlcode,"","cov",1) #TQC-660045
                CONTINUE WHILE
            END IF
        END IF
        UPDATE cou_file SET cou_file.* = g_cou.*
            WHERE cou01 = g_cou01_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cou.cou01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cou_file",g_cou01_t,"",SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t800_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cou.cou01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t800_i(p_cmd)
DEFINE   li_result   LIKE type_file.num5    #No.FUN-550036  #No.FUN-680069 SMALLINT
DEFINE
    l_desc    LIKE type_file.chr1000,       #No.FUN-680069 VARCHAR(70)
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_n	      LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    p_cmd     LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
 
    DISPLAY BY NAME
        g_cou.cou01,g_cou.cou02,g_cou.cou03,g_cou.cou04,g_cou.cou05,
        g_cou.cou06,g_cou.cou07,g_cou.cou08,g_cou.cou09,g_cou.cou10,
        g_cou.cou11,g_cou.cou12,g_cou.cou13,g_cou.cou14,g_cou.cou15,
        g_cou.couuser,g_cou.cougrup,
        g_cou.coumodu,g_cou.coudate,g_cou.couacti
        #FUN-840202     ---start---
        ,g_cou.couud01,g_cou.couud02,g_cou.couud03,g_cou.couud04,
        g_cou.couud05,g_cou.couud06,g_cou.couud07,g_cou.couud08,
        g_cou.couud09,g_cou.couud10,g_cou.couud11,g_cou.couud12,
        g_cou.couud13,g_cou.couud14,g_cou.couud15 
        #FUN-840202     ----end----
 
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
 
    INPUT BY NAME
        g_cou.cou01,g_cou.cou02,g_cou.cou03,g_cou.cou04,g_cou.cou06,
        g_cou.cou05,g_cou.cou07,g_cou.cou08,g_cou.cou09,g_cou.cou10,
        g_cou.cou11,g_cou.cou12,g_cou.cou13,g_cou.cou14,g_cou.cou15
        #FUN-840202     ---start---
        ,g_cou.couud01,g_cou.couud02,g_cou.couud03,g_cou.couud04,
        g_cou.couud05,g_cou.couud06,g_cou.couud07,g_cou.couud08,
        g_cou.couud09,g_cou.couud10,g_cou.couud11,g_cou.couud12,
        g_cou.couud13,g_cou.couud14,g_cou.couud15 
        #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t800_set_entry(p_cmd)
            CALL t800_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550036 --start--
         CALL cl_set_docno_format("cou01")
         CALL cl_set_docno_format("cou02")
         CALL cl_set_docno_format("cou12")
         #No.FUN-550036 ---end---
 
#       BEFORE FIELD cou01    #本系統不允許更改key
#           IF p_cmd = 'u'  AND g_chkey = 'N' THEN
#              NEXT FIELD cou02
#           END IF
 
        AFTER FIELD cou01
#No.FUN-550036 --start--
        IF NOT cl_null(g_cou.cou01) THEN
            CALL s_check_no("aco",g_cou.cou01,g_cou01_t,"16","cou_file","cou01","")
            RETURNING li_result,g_cou.cou01
            DISPLAY BY NAME g_cou.cou01
            IF (NOT li_result) THEN
               LET g_cou.cou01=g_cou_o.cou01
               NEXT FIELD cou01
            END IF
 
#           IF NOT cl_null(g_cou.cou01) THEN
#              LET g_t1=g_cou.cou01[1,3]
#              CALL s_acoslip(g_t1,'16',g_sys)           #檢查單別
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 LET g_cou.cou01=g_cou_o.cou01
#                 NEXT FIELD cou01
#              END IF
#              IF p_cmd = 'a'  THEN
#          IF g_cou.cou01[1,3] IS NOT NULL AND       #並且單號空白時,
#          	  cl_null(g_cou.cou01[5,10]) THEN           #請用戶自行輸入
#             IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
#                NEXT FIELD cou01
#             ELSE					 #要不, 則單號不用
#                NEXT FIELD cou03			 #輸入
# 	             END IF
#           END IF
#           IF g_cou.cou01[1,3] IS NOT NULL AND	 #並且單號空白時,
#          	   NOT cl_null(g_cou.cou01[5,10]) THEN	 #請用戶自行輸入
#                     IF NOT cl_chk_data_continue(g_cou.cou01[5,10]) THEN
#                        CALL cl_err('','9056',0)
#                        NEXT FIELD cou01
#                     END IF
#                  END IF
#              END IF
#              IF g_cou.cou01 != g_cou01_t OR g_cou01_t IS NULL THEN
#                  SELECT count(*) INTO l_n FROM cou_file
#                      WHERE cou01 = g_cou.cou01
#                  IF l_n > 0 THEN   #單據編號重複
#                      CALL cl_err(g_cou.cou01,-239,0)
#                      LET g_cou.cou01 = g_cou01_t
#                      DISPLAY BY NAME g_cou.cou01
#                      NEXT FIELD cou01
#                  END IF
#              END IF
  #No.FUN-550036 ---end---
            END IF
 
       AFTER FIELD cou03                  #備案編號
            IF NOT cl_null(g_cou.cou03) THEN
               IF g_cou_o.cou03 IS NULL OR
                  (g_cou_o.cou03 != g_cou.cou03) THEN
                  CALL t800_cou03()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cou.cou03,g_errno,0)
                     LET g_cou.cou03 = g_cou_o.cou03
                     DISPLAY BY NAME g_cou.cou03
                     NEXT FIELD cou03
                  END IF
               END IF
            END IF
            LET g_cou_o.cou03 = g_cou.cou03
 
        AFTER FIELD cou04                  #合同編號
            IF NOT cl_null(g_cou.cou04) THEN
                  CALL t800_cou04()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cou.cou04,g_errno,0)
                     LET g_cou.cou04 = g_cou_o.cou04
                     DISPLAY BY NAME g_cou.cou04
                     NEXT FIELD cou04
                  END IF
            END IF
            LET g_cou_o.cou04 = g_cou.cou04
 
        BEFORE FIELD cou06
            IF cl_null(g_cou.cou06)  THEN
               LET g_cou.cou06=g_today
               DISPLAY BY NAME g_cou.cou06
            END IF
        BEFORE FIELD cou08
            IF cl_null(g_cou.cou08)  THEN
               LET g_cou.cou08=g_today
               DISPLAY BY NAME g_cou.cou08
            END IF
        AFTER FIELD cou10
            IF NOT cl_null(g_cou.cou10) THEN
               IF g_cou_o.cou10 IS NULL OR
                  (g_cou_o.cou10 != g_cou.cou10) THEN
                     CALL t800_cou10()
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_cou.cou10,g_errno,0)
                        LET g_cou.cou10 = g_cou_o.cou10
                        DISPLAY BY NAME g_cou.cou10
                        NEXT FIELD cou10
                     END IF
               END IF
            END IF
            LET g_cou_o.cou10 = g_cou.cou10
 
        AFTER FIELD cou11
            IF NOT cl_null(g_cou.cou11) THEN
               IF g_cou_o.cou11 IS NULL OR
                  (g_cou_o.cou11 != g_cou.cou11) THEN
                     CALL t800_cou11()
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_cou.cou11,g_errno,0)
                        LET g_cou.cou11 = g_cou_o.cou11
                        DISPLAY BY NAME g_cou.cou11
                        NEXT FIELD cou11
                     END IF
               END IF
            END IF
            LET g_cou_o.cou11 = g_cou.cou11
 
        #FUN-840202     ---start---
        AFTER FIELD couud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD couud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
        ON ACTION CONTROLZ
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(cou01) #單別
                     #CALL q_coy(FALSE,TRUE,g_cou.cou01,'16',g_sys) #TQC-670008
                     CALL q_coy(FALSE,TRUE,g_cou.cou01,'16','ACO')  #TQC-670008
                          RETURNING g_cou.cou01
#                     CALL FGL_DIALOG_SETBUFFER( g_cou.cou01 )
                     DISPLAY BY NAME g_cou.cou01
                     NEXT FIELD cou01
               WHEN INFIELD(cou10) #國別
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_geb"
                     LET g_qryparam.default1 = g_cou.cou10
                     CALL cl_create_qry() RETURNING g_cou.cou10
#                     CALL FGL_DIALOG_SETBUFFER( g_cou.cou10 )
                     DISPLAY BY NAME g_cou.cou10
                     CALL t800_cou10()
                     NEXT FIELD cou10
               WHEN INFIELD(cou11) #幣別
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_azi"
                     LET g_qryparam.default1 = g_cou.cou11
                     CALL cl_create_qry() RETURNING g_cou.cou11
#                     CALL FGL_DIALOG_SETBUFFER( g_cou.cou11 )
                     DISPLAY BY NAME g_cou.cou11
                     CALL t800_cou11()
                     NEXT FIELD cou11
                WHEN INFIELD(cou03) #備案編號
                     CALL q_cos(FALSE,TRUE,g_cou.cou03)
                          RETURNING g_cou.cou03
#                     CALL FGL_DIALOG_SETBUFFER( g_cou.cou03 )
                     DISPLAY BY NAME g_cou.cou03
                     NEXT FIELD cou03
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
FUNCTION t800_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("cou01",TRUE)
    END IF
 
END FUNCTION
FUNCTION t800_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cou01",FALSE)
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t800_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cou.* TO NULL             #No.FUN-6A0168   
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_cov.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t800_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_cou.* TO NULL
        RETURN
    END IF
    OPEN t800_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cou.* TO NULL
    ELSE
        OPEN t800_count
        FETCH t800_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t800_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t800_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t800_cs INTO g_cou.cou01
        WHEN 'P' FETCH PREVIOUS t800_cs INTO g_cou.cou01
        WHEN 'F' FETCH FIRST    t800_cs INTO g_cou.cou01
        WHEN 'L' FETCH LAST     t800_cs INTO g_cou.cou01
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
         FETCH ABSOLUTE g_jump  t800_cs INTO g_cou.cou01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cou.cou01,SQLCA.sqlcode,0)
        INITIALIZE g_cou.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_cou.* FROM cou_file WHERE cou01 = g_cou.cou01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cou.cou01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cou_file",g_cou.cou01,"",SQLCA.sqlcode,"","",1) #TQC-660045
        INITIALIZE g_cou.* TO NULL
        RETURN
    END IF
 
    CALL t800_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t800_show()
    LET g_cou_t.* = g_cou.*                #保存單頭舊值
    LET g_cou_o.* = g_cou.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
 
        g_cou.cou01,g_cou.cou02,g_cou.cou03,g_cou.cou04,g_cou.cou05,
        g_cou.cou06,g_cou.cou07,g_cou.cou08,g_cou.cou09,
        g_cou.cou10,g_cou.cou11,g_cou.cou12,g_cou.cou13,
        g_cou.cou14,g_cou.cou15,
        g_cou.couuser,g_cou.cougrup,g_cou.coumodu,
        g_cou.coudate,g_cou.couacti
        #FUN-840202     ---start---
        ,g_cou.couud01,g_cou.couud02,g_cou.couud03,g_cou.couud04,
        g_cou.couud05,g_cou.couud06,g_cou.couud07,g_cou.couud08,
        g_cou.couud09,g_cou.couud10,g_cou.couud11,g_cou.couud12,
        g_cou.couud13,g_cou.couud14,g_cou.couud15 
         #FUN-840202     ----end----
    CALL cl_set_field_pic("","","","","",g_cou.couacti)
 
    CALL t800_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t800_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cou.cou01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t800_cl USING g_cou.cou01
    IF STATUS THEN
       CALL cl_err("OPEN t800_cl:", STATUS, 1)
       CLOSE t800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t800_cl INTO g_cou.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cou.cou01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t800_show()
    IF cl_exp(0,0,g_cou.couacti) THEN                   #審核一下
        LET g_chr=g_cou.couacti
        IF g_cou.couacti='Y' THEN
            LET g_cou.couacti='N'
        ELSE
            LET g_cou.couacti='Y'
        END IF
        UPDATE cou_file                    #更改有效碼
            SET couacti=g_cou.couacti
            WHERE cou01=g_cou.cou01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_cou.cou01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cou_file",g_cou.cou01,"",SQLCA.sqlcode,"","",1) #TQC-660045
            LET g_cou.couacti=g_chr
        END IF
        DISPLAY BY NAME g_cou.couacti
    END IF
    CLOSE t800_cl
    COMMIT WORK
 
    CALL cl_set_field_pic("","","","","",g_cou.couacti)
 
    CALL cl_flow_notify(g_cou.cou01,'V')
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t800_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cou.cou01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t800_cl USING g_cou.cou01
    IF STATUS THEN
       CALL cl_err("OPEN t800_cl:", STATUS, 1)
       CLOSE t800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t800_cl INTO g_cou.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cou.cou01,SQLCA.sqlcode,0)        #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t800_show()
    IF cl_delh(0,0) THEN                                #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cou01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cou.cou01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                             #No.FUN-9B0098 10/02/24
       DELETE FROM cou_file WHERE cou01 = g_cou.cou01
       IF SQLCA.sqlerrd[3]=0  THEN
#         CALL cl_err('del_cou',SQLCA.sqlcode,0)        #無資料 #No.TQC-660045
          CALL cl_err3("del","cou_file",g_cou.cou01,"",SQLCA.sqlcode,"","",1) #TQC-660045
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM cov_file WHERE cov01 = g_cou.cou01
#      IF SQLCA.sqlerrd[3]=0  THEN                #MOD-C70236 mark
       IF SQLCA.sqlcode THEN                      #MOD-C70236 add
#         CALL cl_err('del_cov',SQLCA.sqlcode,0)        #無資料 #No.TQC-660045
          CALL cl_err3("del","cov_file",g_cou.cou01,"",SQLCA.sqlcode,"","del_cov",1) #TQC-660045
          ROLLBACK WORK
          RETURN
       END IF
       CLEAR FORM
       CALL g_cov.clear()
 
         OPEN t800_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE t800_cs
            CLOSE t800_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--

         FETCH t800_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t800_cs
            CLOSE t800_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t800_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t800_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t800_fetch('/')
         END IF
    END IF
    CLOSE t800_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cou.cou01,'D')
END FUNCTION
 
#單身
FUNCTION t800_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680069 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_cou.cou01 IS NULL THEN RETURN END IF
    SELECT * INTO g_cou.* FROM cou_file WHERE cou01=g_cou.cou01
    IF g_cou.couacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_cou.cou01,'mfg1000',0)
       RETURN
    END IF
    LET g_cou.coumodu=g_user
    LET g_cou.coudate=g_today
    DISPLAY BY NAME g_cou.coumodu,g_cou.coudate
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT cov02,cov03,cov04,cov05,cov06,cov07,cov08 ",
                       "   FROM cov_file ",
                       "  WHERE cov01=? AND cov02=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t800_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
    IF g_rec_b=0 THEN CALL g_cov.clear() END IF
 
        INPUT ARRAY g_cov WITHOUT DEFAULTS FROM s_cov.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
 
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
 
            LET p_cmd = ''
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t800_cl USING g_cou.cou01
            IF STATUS THEN
               CALL cl_err("OPEN t800_cl:", STATUS, 1)
               CLOSE t800_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t800_cl INTO g_cou.*     #鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_cou.cou01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t800_cl
              ROLLBACK WORK
              RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_cov_t.* = g_cov[l_ac].*  #BACKUP
                LET g_cov_o.* = g_cov[l_ac].*  #BACKUP
                OPEN t800_bcl USING g_cou.cou01,g_cov_t.cov02
                IF STATUS THEN
                   CALL cl_err("OPEN t800_bcl:", STATUS, 1)
                   CLOSE t800_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t800_bcl INTO g_cov[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cov_t.cov02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
           #NEXT FIELD cov02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
              INITIALIZE g_cov[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_cov[l_ac].* TO s_cov.*
              CALL g_cov.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO cov_file(cov01,cov02,cov03,cov04,cov05,
                                 cov06,cov07,cov08
                                #No.FUN-840202 --start--
                                ,covud01,covud02,covud03,covud04,covud05,
                                covud06,covud07,covud08,covud09,covud10,
                                #covud11,covud12,covud13,covud14,covud15) #FUN-980002
                                #No.FUN-840202 ---end---
                                covud11,covud12,covud13,covud14,covud15,  #FUN-980002
                                covplant,covlegal) #FUN-980002
            VALUES(g_cou.cou01,g_cov[l_ac].cov02,
                   g_cov[l_ac].cov03,g_cov[l_ac].cov04,
                   g_cov[l_ac].cov05,g_cov[l_ac].cov06,
                   g_cov[l_ac].cov07,g_cov[l_ac].cov08
                   #No.FUN-840202 --start--
                   ,g_cov[l_ac].covud01,g_cov[l_ac].covud02,g_cov[l_ac].covud03,
                   g_cov[l_ac].covud04,g_cov[l_ac].covud05,g_cov[l_ac].covud06,
                   g_cov[l_ac].covud07,g_cov[l_ac].covud08,g_cov[l_ac].covud09,
                   g_cov[l_ac].covud10,g_cov[l_ac].covud11,g_cov[l_ac].covud12,
                   #g_cov[l_ac].covud13,g_cov[l_ac].covud14,g_cov[l_ac].covud15) #FUN-980002
                   #No.FUN-840202 ---end---
                   g_cov[l_ac].covud13,g_cov[l_ac].covud14,g_cov[l_ac].covud15,  #FUN-980002
                   g_plant,g_legal) #FUN-980002
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cov[l_ac].cov02,SQLCA.sqlcode,0) #No.TQC-660045
               CALL cl_err3("ins","cov_file",g_cou.cou01,g_cov[l_ac].cov02,SQLCA.sqlcode,"","",1) #TQC-660045
               ROLLBACK WORK
               CANCEL INSERT
               LET g_cov[l_ac].* = g_cov_t.*
               DISPLAY g_cov[l_ac].* TO s_cov[l_sl].*
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
 
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_cov[l_ac].* TO NULL       #900423
            LET g_cov[l_ac].cov06 = 0              #Body default
            LET g_cov[l_ac].cov08 = 0              #Body default
            LET g_cov_t.* = g_cov[l_ac].*          #新輸入資料
            LET g_cov_o.* = g_cov[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cov02
 
        BEFORE FIELD cov02                        #default 序號
            IF g_cov[l_ac].cov02 IS NULL OR g_cov[l_ac].cov02 = 0 THEN
                SELECT max(cov02)+1 INTO g_cov[l_ac].cov02 FROM cov_file
                 WHERE cov01 = g_cou.cou01
                IF g_cov[l_ac].cov02 IS NULL THEN
                    LET g_cov[l_ac].cov02 = 1
                END IF
#               DISPLAY g_cov[l_ac].cov02 TO s_cov[l_sl].cov02 #No.FUN-570273預設值不可使用
            END IF
 
        AFTER FIELD cov02                        #check 序號是否重複
            IF NOT cl_null(g_cov[l_ac].cov02) THEN
               IF g_cov[l_ac].cov02 != g_cov_t.cov02 OR
                  g_cov_t.cov02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM cov_file
                       WHERE cov01 = g_cou.cou01 AND
                             cov02 = g_cov[l_ac].cov02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cov[l_ac].cov02 = g_cov_t.cov02
                       NEXT FIELD cov02
                   END IF
               END IF
            END IF
 
        AFTER FIELD cov03                  #備案序號
            IF NOT cl_null(g_cov[l_ac].cov03) THEN
               IF g_cov_o.cov03 IS NULL OR
                 (g_cov[l_ac].cov03 !=g_cov_t.cov03 ) THEN
                  CALL t800_cov03('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cov[l_ac].cov03,g_errno,0)
                     LET g_cov[l_ac].cov03 = g_cov_o.cov03
                     LET g_cov[l_ac].cov04 = g_cov_o.cov04
                     DISPLAY g_cov[l_ac].cov03 TO s_cov[l_sl].cov03
                     DISPLAY g_cov[l_ac].cov04 TO s_cov[l_sl].cov04
                     NEXT FIELD cov03
                  END IF
               END IF
            END IF
 
        AFTER FIELD cov05                  #國別
            IF NOT cl_null(g_cov[l_ac].cov05) THEN
               IF g_cov_o.cov05 IS NULL OR
                 (g_cov[l_ac].cov05 !=g_cov_t.cov05 ) THEN
                  CALL t800_cov05('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cov[l_ac].cov05,g_errno,0)
                     LET g_cov[l_ac].cov07 = g_cov_o.cov05
                     LET g_cov[l_ac].cov06 = s_digqty(g_cov[l_ac].cov06,g_cov[l_ac].cov07)   #No.FUN-BB0086
                     DISPLAY BY NAME g_cov[l_ac].cov06  #FUN-BB0086
                     DISPLAY g_cov[l_ac].cov05 TO s_cov[l_sl].cov05
                     NEXT FIELD cov05
                  END IF
               END IF
            END IF

        #No.FUN-BB0086--add--begin--
        AFTER FIELD cov06
           LET g_cov[l_ac].cov06 = s_digqty(g_cov[l_ac].cov06,g_cov[l_ac].cov07)
           DISPLAY BY NAME g_cov[l_ac].cov06
        #No.FUN-BB0086--add--end--
        
        AFTER FIELD cov07                  #單位
            IF NOT cl_null(g_cov[l_ac].cov07) THEN
               IF g_cov_o.cov07 IS NULL OR
                 (g_cov[l_ac].cov05 !=g_cov_t.cov07 ) THEN
                  CALL t800_cov07('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cov[l_ac].cov07,g_errno,0)
                     LET g_cov[l_ac].cov07 = g_cov_o.cov07
                     DISPLAY g_cov[l_ac].cov07 TO s_cov[l_sl].cov07
                     NEXT FIELD cov07
                  END IF
               END IF
               #No.FUN-BB0086--add--begin--
               LET g_cov[l_ac].cov06 = s_digqty(g_cov[l_ac].cov06,g_cov[l_ac].cov07)
               DISPLAY BY NAME g_cov[l_ac].cov06
               #No.FUN-BB0086--add--end--
            END IF
        #No.FUN-840202 --start--
        AFTER FIELD covud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD covud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_cov_t.cov02 > 0 AND g_cov_t.cov02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM cov_file
                    WHERE cov01 = g_cou.cou01 AND
                          cov02 = g_cov_t.cov02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cov_t.cov02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("del","cov_file",g_cou.cou01,g_cov_t.cov02,SQLCA.sqlcode,"","",1) #TQC-660045
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
               LET g_cov[l_ac].* = g_cov_t.*
               CLOSE t800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cov[l_ac].cov02,-263,1)
               LET g_cov[l_ac].* = g_cov_t.*
            ELSE
               UPDATE cov_file SET
                 (cov02,cov03,cov04,cov05,cov06,cov07,cov08
                  #No.FUN-840202 --start--
                  ,covud01,covud02,covud03,covud04,covud05,
                  covud06,covud07,covud08,covud09,covud10,
                  covud11,covud12,covud13,covud14,covud15
                  #No.FUN-840202 ---end---
                  )
                =(g_cov[l_ac].cov02,g_cov[l_ac].cov03,
                  g_cov[l_ac].cov04,g_cov[l_ac].cov05,
                  g_cov[l_ac].cov06,g_cov[l_ac].cov07,
                  g_cov[l_ac].cov08
                  #No.FUN-840202 --start--
                 ,g_cov[l_ac].covud01,g_cov[l_ac].covud02,g_cov[l_ac].covud03,
                  g_cov[l_ac].covud04,g_cov[l_ac].covud05,g_cov[l_ac].covud06,
                  g_cov[l_ac].covud07,g_cov[l_ac].covud08,g_cov[l_ac].covud09,
                  g_cov[l_ac].covud10,g_cov[l_ac].covud11,g_cov[l_ac].covud12,
                  g_cov[l_ac].covud13,g_cov[l_ac].covud14,g_cov[l_ac].covud15)
                  #No.FUN-840202 ---end---
                WHERE cov01=g_cou.cou01 AND cov02=g_cov_t.cov02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_cov[l_ac].cov02,SQLCA.sqlcode,0) #No.TQC-660045
                   CALL cl_err3("upd","cov_file",g_cou.cou01,g_cov_t.cov02,SQLCA.sqlcode,"","",1) #TQC-660045
                   LET g_cov[l_ac].* = g_cov_t.*
                   DISPLAY g_cov[l_ac].* TO s_cov[l_sl].*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   LET g_cou.coumodu=g_user
                   LET g_cou.coudate=g_today
                   UPDATE cou_file SET cou_file.* = g_cou.*
                    WHERE cou01 = g_cou01_t
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_cov[l_ac].* = g_cov_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cov.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end-- 
               END IF
               CLOSE t800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add 
          #LET g_cov_t.* = g_cov[l_ac].*          # 900423
            CLOSE t800_bcl
            COMMIT WORK
 
           #CALL g_cov.deleteElement(g_rec_b+1)   #FUN-D30034 Mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cov02) AND l_ac > 1 THEN
                LET g_cov[l_ac].* = g_cov[l_ac-1].*
                NEXT FIELD cov02
            END IF
        ON ACTION controls                       # No.FUN-6B0033
           CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp #ok2
            CASE
               WHEN INFIELD(cov03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_cot"
                    LET g_qryparam.default1 = g_cov[l_ac].cov03
                    LET g_qryparam.arg1     = g_cou.cou03        #MOD-7C0155-add
#                   LET g_qryparam.where = "cos08= g_cou.cou03"  #MOD-7C0155-mark
                    CALL cl_create_qry() RETURNING g_cov[l_ac].cov03
#                    CALL FGL_DIALOG_SETBUFFER( g_cov[l_ac].cov03 )
                    DISPLAY g_cov[l_ac].cov03 TO cov03
                    CALL t800_cov03('a')
                    NEXT FIELD cov03
               WHEN INFIELD(cov05)  #國別
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_geb"
                    LET g_qryparam.default1 = g_cov[l_ac].cov05
                    CALL cl_create_qry() RETURNING g_cov[l_ac].cov05
#                    CALL FGL_DIALOG_SETBUFFER( g_cov[l_ac].cov05 )
                    DISPLAY BY NAME g_cov[l_ac].cov05
                    NEXT FIELD cov05
               WHEN INFIELD(cov07) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_cov[l_ac].cov07
                    CALL cl_create_qry() RETURNING g_cov[l_ac].cov07
#                    CALL FGL_DIALOG_SETBUFFER( g_cov[l_ac].cov07 )
                    DISPLAY BY NAME g_cov[l_ac].cov07
                    NEXT FIELD cov07
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
    LET g_cou.coumodu = g_user
    LET g_cou.coudate = g_today
    UPDATE cou_file SET coumodu = g_cou.coumodu,coudate = g_cou.coudate
     WHERE cou01 = g_cou.cou01
    DISPLAY BY NAME g_cou.coumodu,g_cou.coudate
    #FUN-5B0043-end
 
    CLOSE t800_bcl
    COMMIT WORK
    CALL t800_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t800_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
          DELETE FROM cou_file WHERE cou01 = g_cou.cou01
         INITIALIZE g_cou.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t800_delall()
    SELECT COUNT(*) INTO g_cnt FROM cov_file
        WHERE cov01 = g_cou.cou01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否撤銷單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM cou_file WHERE cou01 = g_cou.cou01
    END IF
END FUNCTION
 
FUNCTION t800_cou10()  #國別
   DEFINE l_gebacti  LIKE geb_file.gebacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gebacti INTO l_gebacti FROM geb_file
                WHERE geb01 = g_cou.cou10
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-152'
                            LET l_gebacti = NULL
         WHEN l_gebacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t800_cou11()  #幣別
    DEFINE l_aziacti LIKE azi_file.aziacti
 
    LET g_errno = " "
    SELECT aziacti INTO l_aziacti FROM azi_file
     WHERE azi01 = g_cou.cou11
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                   LET l_aziacti = NULL
         WHEN l_aziacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t800_cou03()  #備案編號
    DEFINE l_cosacti LIKE cos_file.cosacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT cosacti INTO l_cosacti
      FROM cos_file WHERE cos08 = g_cou.cou03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-024'
                                   LET l_cosacti = NULL
         WHEN l_cosacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t800_cou04()  #合同編號
    DEFINE l_cnt     LIKE type_file.num5,          #No.FUN-680069 SMALLINT
           p_cmd     LIKE type_file.chr1           #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt
      FROM coc_file WHERE coc04 = g_cou.cou04 AND cocacti='Y'
    IF l_cnt=0 THEN  LET g_errno = 'aco-026' END IF
END FUNCTION
 
FUNCTION t800_cov03(p_cmd)  #備案序號
   DEFINE l_cot06    LIKE cos_file.cos02,
          l_n        LIKE type_file.num5,          #No.FUN-680069 SMALLINT
          p_cmd      LIKE type_file.chr1           #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  LET l_n = 0
  SELECT COUNT(*) INTO l_n FROM cov_file
   WHERE cov01=g_cou.cou01 AND cov03=g_cov[l_ac].cov03
  IF l_n > 0  THEN
     LET g_errno='-239'
  ELSE
     SELECT cot06 INTO l_cot06 FROM cot_file,cos_file
      WHERE cos08=g_cou.cou03
        AND cot01=cos01
        AND cot02=g_cov[l_ac].cov03
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno='aco-024'
                                      LET l_cot06=NULL
            OTHERWISE                 LET g_errno=SQLCA.SQLCODE USING '-------'
       END CASE
  END IF
 
  IF cl_null(g_errno) OR p_cmd='d' THEN
     LET g_cov[l_ac].cov04=l_cot06
     DISPLAY l_cot06 TO s_cov[l_sl].cov04
  END IF
END FUNCTION
 
FUNCTION t800_cov07(p_cmd)  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti,
          l_price    LIKE cov_file.cov07,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
   WHERE gfe01 = g_cov[l_ac].cov07
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t800_cov05(p_cmd)  #產國
   DEFINE l_gebacti  LIKE geb_file.gebacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gebacti INTO l_gebacti FROM geb_file
                WHERE geb01 = g_cov[l_ac].cov05
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-152'
                            LET l_gebacti = NULL
         WHEN l_gebacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t800_b_askkey()
DEFINE
    l_wc2    LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(200)
 
 # 螢幕上取單身條件
    CONSTRUCT l_wc2 ON cov02,cov03,cov04,cov05,cov06,cov07,cov08
                       #No.FUN-840202 --start--
                       ,covud01,covud02,covud03,covud04,covud05,
                       covud06,covud07,covud08,covud09,covud10,
                       covud11,covud12,covud13,covud14,covud15
                       #No.FUN-840202 ---end---
            FROM s_cov[1].cov02,s_cov[1].cov03,s_cov[1].cov04,
                 s_cov[1].cov05,s_cov[1].cov06,s_cov[1].cov07,
                 s_cov[1].cov08
                 #No.FUN-840202 --start--
                 ,s_cov[1].covud01,s_cov[1].covud02,s_cov[1].covud03,s_cov[1].covud04,s_cov[1].covud05,
                 s_cov[1].covud06,s_cov[1].covud07,s_cov[1].covud08,s_cov[1].covud09,s_cov[1].covud10,
                 s_cov[1].covud11,s_cov[1].covud12,s_cov[1].covud13,s_cov[1].covud14,s_cov[1].covud15
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
    CALL t800_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t800_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2     LIKE type_file.chr1000     #No.FUN-680069 VARCHAR(200)
 
    LET g_sql =
        "SELECT cov02,cov03,cov04,cov05,cov06,cov07,cov08 ",
        #No.FUN-840202 --start--
        "       ,covud01,covud02,covud03,covud04,covud05,",
        "       covud06,covud07,covud08,covud09,covud10,",
        "       covud11,covud12,covud13,covud14,covud15", 
        #No.FUN-840202 ---end---
        "  FROM cov_file ",
        " WHERE cov01 ='",g_cou.cou01,"'"                  #AND ",#單頭#No.FUN-8B0123
    #No.FUN-8B0123---Begin
    #         p_wc2 CLIPPED," ORDER BY 1" CLIPPED          #單身
    IF NOT cl_null(p_wc2) THEN
    LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1" 
    DISPLAY g_sql
    #No.FUN-8B0123---End
  
    PREPARE t800_pb FROM g_sql
    DECLARE cov_cs                       #SCROLL CURSOR
        CURSOR FOR t800_pb
 
    CALL g_cov.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH cov_cs INTO g_cov[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
 
    CALL g_cov.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t800_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cov TO s_cov.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t800_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t800_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t800_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t800_fetch('L')
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
 
         CALL cl_set_field_pic("","","","","",g_cou.couacti)
 
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
 
{
FUNCTION t800_copy()
DEFINE
    l_n             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    l_newno         LIKE cou_file.cou01,
    l_oldno         LIKE cou_file.cou01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cou.cou01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    DISPLAY "" AT 1,1
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    DISPLAY g_msg AT 2,1
    LET g_before_input_done = FALSE
    CALL t800_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM cou01
 
        AFTER FIELD cou01
#            IF NOT cl_null(l_newno[1,3])  THEN
            IF NOT cl_null(l_newno[1,g_doc_len])  THEN      #No.FUN-560002
               SELECT count(*) INTO g_cnt FROM cou_file WHERE cou01 = l_newno
               IF g_cnt > 0 THEN
                   CALL cl_err(l_newno,-239,0)
                   NEXT FIELD cou01
               END IF
            END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_cou.cou01
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM cou_file         #單頭複製
        WHERE cou01=g_cou.cou01
        INTO TEMP y
    UPDATE y
        SET cou01=l_newno,    #新的鍵值
            couuser=g_user,   #資料所有者
            cougrup=g_grup,   #資料所有者所屬群
            coumodu=NULL,     #資料更改日期
            coudate=g_today,  #資料建立日期
            couacti='Y'       #有效資料
    INSERT INTO cou_file
        SELECT * FROM y
 
    DROP TABLE x
    SELECT * FROM cov_file         #單身複製
     WHERE cov01=g_cou.cou01 INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_cou.cou01,SQLCA.sqlcode,0) #No.TQC-660045
       CALL cl_err3("ins","x",g_cou.cou01,"",SQLCA.sqlcode,"","",1) #TQC-660045
       RETURN
    END IF
    UPDATE x SET cov01=l_newno
 
    INSERT INTO cov_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cou.cou01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("ins","cov_file",g_cou.cou01,"",SQLCA.sqlcode,"","",1) #TQC-660045
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_cou.cou01
     SELECT cou_file.* INTO g_cou.* FROM cou_file WHERE cou01 = l_newno
     CALL t800_u()
     CALL t800_b()
     SELECT cou_file.* INTO g_cou.* FROM cou_file WHERE cou01 = l_oldno
     CALL t800_show()
END FUNCTION
}
