# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acoi800.4gl
# Descriptions...: 進口設備征免證明申請維護作業
# Date & Author..: 00/07/25 By Carol
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-550002 05/06/03 By Trisy 單據編號加大
# Modify.........: NO.FUN-560002 05/06/06 By jackie 單據編號修改
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.TQC-630070 06/03/07 By Dido 流程訊息通知功能
# MOdify.........: No.TQC-660045 06/06/09 BY hellen  cl_err --> cl_err3
# Modify.........: No.TQC-660072 06/06/15 By Dido 補充TQC-630070
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/09 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-960251 09/08/07 By destiny 在copy()段去掉ROLLBACK WORK
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->ACO
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60350 11/06/28 By yinhy 報錯aom-160改為aap-039
# Modify.........: No:FUN-BB0086 12/01/06 By tanxc 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C70236 12/07/25 By ck2yuan 刪除時,單身可能無資料,所以應該看SQLCA.sqlcode
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cos           RECORD LIKE cos_file.*,       #單頭
    g_cos_t         RECORD LIKE cos_file.*,       #單頭(舊值)
    g_cos_o         RECORD LIKE cos_file.*,       #單頭(舊值)
    g_cos01_t       LIKE cos_file.cos01,   #單頭 (舊值)
    g_t1            LIKE oay_file.oayslip,          #No.FUN-550002        #No.FUN-680069 VARCHAR(05)
    g_cot           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        cot02       LIKE cot_file.cot02,   #項次
        cot03       LIKE cot_file.cot03,   #
        cot04       LIKE cot_file.cot04,   #
        cot05       LIKE cot_file.cot05,   #
        cot06       LIKE cot_file.cot06,   #
        cot07       LIKE cot_file.cot07,   #
        cot08       LIKE cot_file.cot08,   #
        cot09       LIKE cot_file.cot09,   #
        cot10       LIKE cot_file.cot10,   #
        cot11       LIKE cot_file.cot11,   #
        cot12       LIKE cot_file.cot12,   #
        cot13       LIKE cot_file.cot13,   #
        cot14       LIKE cot_file.cot14,   #
        cot15       LIKE cot_file.cot15,   #
        cot16       LIKE cot_file.cot16,   #
        cot17       LIKE cot_file.cot17,   #
        cot18       LIKE cot_file.cot18,   #
        cot19       LIKE cot_file.cot19,   #
        cot191      LIKE cot_file.cot191,  #
        cot20       LIKE cot_file.cot20,   #
        cot21       LIKE cot_file.cot21    #
        #FUN-840202 --start---
        ,cotud01 LIKE cot_file.cotud01,
        cotud02 LIKE cot_file.cotud02,
        cotud03 LIKE cot_file.cotud03,
        cotud04 LIKE cot_file.cotud04,
        cotud05 LIKE cot_file.cotud05,
        cotud06 LIKE cot_file.cotud06,
        cotud07 LIKE cot_file.cotud07,
        cotud08 LIKE cot_file.cotud08,
        cotud09 LIKE cot_file.cotud09,
        cotud10 LIKE cot_file.cotud10,
        cotud11 LIKE cot_file.cotud11,
        cotud12 LIKE cot_file.cotud12,
        cotud13 LIKE cot_file.cotud13,
        cotud14 LIKE cot_file.cotud14,
        cotud15 LIKE cot_file.cotud15
        #FUN-840202 --end--
                    END RECORD,
    g_cot_t         RECORD                 #程式變數 (舊值)
        cot02       LIKE cot_file.cot02,   #項次
        cot03       LIKE cot_file.cot03,   #
        cot04       LIKE cot_file.cot04,   #
        cot05       LIKE cot_file.cot05,   #
        cot06       LIKE cot_file.cot06,   #
        cot07       LIKE cot_file.cot07,   #
        cot08       LIKE cot_file.cot08,   #
        cot09       LIKE cot_file.cot09,   #
        cot10       LIKE cot_file.cot10,   #
        cot11       LIKE cot_file.cot11,   #
        cot12       LIKE cot_file.cot12,   #
        cot13       LIKE cot_file.cot13,   #
        cot14       LIKE cot_file.cot14,   #
        cot15       LIKE cot_file.cot15,   #
        cot16       LIKE cot_file.cot16,   #
        cot17       LIKE cot_file.cot17,   #
        cot18       LIKE cot_file.cot18,   #
        cot19       LIKE cot_file.cot19,   #
        cot191      LIKE cot_file.cot191,  #
        cot20       LIKE cot_file.cot20,   #
        cot21       LIKE cot_file.cot21    #
        #FUN-840202 --start---
        ,cotud01 LIKE cot_file.cotud01,
        cotud02 LIKE cot_file.cotud02,
        cotud03 LIKE cot_file.cotud03,
        cotud04 LIKE cot_file.cotud04,
        cotud05 LIKE cot_file.cotud05,
        cotud06 LIKE cot_file.cotud06,
        cotud07 LIKE cot_file.cotud07,
        cotud08 LIKE cot_file.cotud08,
        cotud09 LIKE cot_file.cotud09,
        cotud10 LIKE cot_file.cotud10,
        cotud11 LIKE cot_file.cotud11,
        cotud12 LIKE cot_file.cotud12,
        cotud13 LIKE cot_file.cotud13,
        cotud14 LIKE cot_file.cotud14,
        cotud15 LIKE cot_file.cotud15
        #FUN-840202 --end--
                    END RECORD,
    g_cot_o         RECORD                 #程式變數 (舊值)
        cot02       LIKE cot_file.cot02,   #項次
        cot03       LIKE cot_file.cot03,   #
        cot04       LIKE cot_file.cot04,   #
        cot05       LIKE cot_file.cot05,   #
        cot06       LIKE cot_file.cot06,   #
        cot07       LIKE cot_file.cot07,   #
        cot08       LIKE cot_file.cot08,   #
        cot09       LIKE cot_file.cot09,   #
        cot10       LIKE cot_file.cot10,   #
        cot11       LIKE cot_file.cot11,   #
        cot12       LIKE cot_file.cot12,   #
        cot13       LIKE cot_file.cot13,   #
        cot14       LIKE cot_file.cot14,   #
        cot15       LIKE cot_file.cot15,   #
        cot16       LIKE cot_file.cot16,   #
        cot17       LIKE cot_file.cot17,   #
        cot18       LIKE cot_file.cot18,   #
        cot19       LIKE cot_file.cot19,   #
        cot191      LIKE cot_file.cot191,  #
        cot20       LIKE cot_file.cot20,   #
        cot21       LIKE cot_file.cot21    #
        #FUN-840202 --start---
        ,cotud01 LIKE cot_file.cotud01,
        cotud02 LIKE cot_file.cotud02,
        cotud03 LIKE cot_file.cotud03,
        cotud04 LIKE cot_file.cotud04,
        cotud05 LIKE cot_file.cotud05,
        cotud06 LIKE cot_file.cotud06,
        cotud07 LIKE cot_file.cotud07,
        cotud08 LIKE cot_file.cotud08,
        cotud09 LIKE cot_file.cotud09,
        cotud10 LIKE cot_file.cotud10,
        cotud11 LIKE cot_file.cotud11,
        cotud12 LIKE cot_file.cotud12,
        cotud13 LIKE cot_file.cotud13,
        cotud14 LIKE cot_file.cotud14,
        cotud15 LIKE cot_file.cotud15
        #FUN-840202 --end--
                    END RECORD,
    g_argv1         LIKE cos_file.cos01,        # 詢價單號
    g_argv2         STRING,   #No.FUN-680069    #TQC-630070      #執行功能
    g_wc,g_wc2,g_sql    STRING,                #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_sl            LIKE type_file.num5         #No.FUN-680069 SMALLINT #目前處理的SCREEN LINE
 
#主程式開始
DEFINE g_forupd_sql      STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680069 INTEGER
#CKP3
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680069 SMALLINT
MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5          #No.FUN-680069 SMALLINT
#       l_time    LIKE type_file.chr8              #No.FUN-6A0063
 
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
 
 
 
    LET g_argv1 = ARG_VAL(1)              #參數-1(詢價單號)
    LET g_argv2 = ARG_VAL(2)              #執行功能   #TQC-630070
 
    LET g_forupd_sql = " SELECT * FROM cos_file WHERE cos01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i800_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW i800_w AT p_row,p_col
        WITH FORM "aco/42f/acoi800"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #start TQC-630070
    # 先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i800_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i800_a()
             END IF
          OTHERWISE          #TQC-660072
             CALL i800_q()   #TQC-660072
       END CASE
    END IF
    #end TQC-630070
 
    CALL i800_menu()
    CLOSE WINDOW i800_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION i800_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_cot.clear()
 
   #TQC-630070
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   INITIALIZE g_cos.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
          cos01,cos02,cos03,cos04,cos05,cos06,cos13,cos07,cos08,cos09,cos10,
          cos11,cos12,cosuser,cosgrup,cosmodu,cosdate,cosacti
          #FUN-840202   ---start---
          ,cosud01,cosud02,cosud03,cosud04,cosud05,
          cosud06,cosud07,cosud08,cosud09,cosud10,
          cosud11,cosud12,cosud13,cosud14,cosud15
          #FUN-840202    ----end----
                 #No.FUN-580031 --start--     HCN
                 BEFORE CONSTRUCT
                    CALL cl_qbe_init()
                 #No.FUN-580031 --end--       HCN
       ON ACTION controlp
             CASE
                WHEN INFIELD(cos01) #單別
                     #CALL q_coy( TRUE, FALSE,g_cos.cos01,'11',g_sys) #TQC-670008
                     CALL q_coy( TRUE, FALSE,g_cos.cos01,'11','ACO')  #TQC-670008
                          RETURNING g_cos.cos01
                     DISPLAY BY NAME g_cos.cos01
                     NEXT FIELD cos01
                 WHEN INFIELD(cos02) #公司別
                     CALL cl_init_qry_var()
                     LET g_qryparam.state ="c"
                     LET g_qryparam.form ="q_cnb"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO cos02
                     NEXT FIELD cos02
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
      CONSTRUCT g_wc2 ON cot02,cot03,cot04,cot05,cot06,cot07,cot08,cot09,
                         cot10,cot11,cot12,cot13,cot14,cot15,cot16,cot17,
                         cot18,cot19,cot191,cot20,cot21
                         #No.FUN-840202 --start--
                         ,cotud01,cotud02,cotud03,cotud04,cotud05,
                         cotud06,cotud07,cotud08,cotud09,cotud10,
                         cotud11,cotud12,cotud13,cotud14,cotud15
                         #No.FUN-840202 ---end---
              FROM s_cot[1].cot02,s_cot[1].cot03,s_cot[1].cot04,
                   s_cot[1].cot05,s_cot[1].cot06,s_cot[1].cot07,
                   s_cot[1].cot08,s_cot[1].cot09,s_cot[1].cot10,
                   s_cot[1].cot11,s_cot[1].cot12,s_cot[1].cot13,
                   s_cot[1].cot14,s_cot[1].cot15,s_cot[1].cot16,
                   s_cot[1].cot17,s_cot[1].cot18,s_cot[1].cot19,
                   s_cot[1].cot191,s_cot[1].cot20,s_cot[1].cot21
                   #No.FUN-840202 --start--
                   ,s_cot[1].cotud01,s_cot[1].cotud02,s_cot[1].cotud03,s_cot[1].cotud04,s_cot[1].cotud05,
                   s_cot[1].cotud06,s_cot[1].cotud07,s_cot[1].cotud08,s_cot[1].cotud09,s_cot[1].cotud10,
                   s_cot[1].cotud11,s_cot[1].cotud12,s_cot[1].cotud13,s_cot[1].cotud14,s_cot[1].cotud15
                   #No.FUN-840202 ---end---
          	#No.FUN-580031 --start--     HCN
          	BEFORE CONSTRUCT
          	   CALL cl_qbe_display_condition(lc_qbe_sn)
          	#No.FUN-580031 --end--       HCN
         ON ACTION controlp #ok
              CASE
                 WHEN INFIELD(cot03) #海關代號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_cna"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO cot03
                   NEXT FIELD cot03
                 WHEN INFIELD(cot09) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_gfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO cot09
                   NEXT FIELD cot09
                WHEN INFIELD(cot07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_geb"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO cot07
                   NEXT FIELD cot07
                 WHEN INFIELD(cot19)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_faj"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO cot19
                   NEXT FIELD cot19
                 WHEN INFIELD(cot21)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state ="c"
                   LET g_qryparam.form ="q_gem"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO cot21
                   NEXT FIELD cot21
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
    ELSE 
       LET g_wc=" cos01='",g_argv1,"'"
    END IF
   #TQC-630070 end
 
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND cosuser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND cosgrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND cosgrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cosuser', 'cosgrup')
  #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT cos01 FROM cos_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY cos01"
     ELSE					# 若單身有輸入條件
       LET g_sql = " SELECT UNIQUE cos01 ",
                   " FROM cos_file,cot_file ",
                   " WHERE cos01 = cot01",
                   " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY cos01"
    END IF
 
    PREPARE i800_prepare FROM g_sql
    DECLARE i800_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i800_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM cos_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM cos_file,cot_file WHERE ",
                  "cot01=cos01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i800_precount FROM g_sql
    DECLARE i800_count CURSOR FOR i800_precount
END FUNCTION
 
FUNCTION i800_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069 VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL i800_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i800_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i800_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i800_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i800_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i800_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i800_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i800_b()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cot),'','')
             END IF
         #--
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_cos.cos01 IS NOT NULL THEN
                 LET g_doc.column1 = "cos01"
                 LET g_doc.value1 = g_cos.cos01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i800_a()
#No.FUN-560002--begin
  DEFINE li_result   LIKE type_file.num5          #No.FUN-680069 SMALLINT
#No.FUN-560002--end
    MESSAGE ""
    CLEAR FORM
    CALL g_cot.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_cos.* LIKE cos_file.*             #DEFAULT 設置
    LET g_cos01_t = NULL
    LET g_cos_t.* = g_cos.*
    LET g_cos_o.* = g_cos.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cos.cos03  = g_today
        LET g_cos.cosuser=g_user
        LET g_data_plant = g_plant #FUN-980030
        LET g_cos.cosgrup=g_grup
        LET g_cos.cosdate=g_today
        LET g_cos.cosacti='Y'              #資料有效
        LET g_cos.cosplant = g_plant  #FUN-980002
        LET g_cos.coslegal = g_legal  #FUN-980002
 
        #TQC-630070 --start--
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_cos.cos01 = g_argv1
        END IF
        #TQC-630070 ---end---
 
        BEGIN WORK
        CALL i800_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            INITIALIZE g_cos.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cos.cos01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
#No.FUN-560002--begin
        BEGIN WORK
        CALL s_auto_assign_no("ACO",g_cos.cos01,g_cos.cos03,"11","cos_file","cos01","","","")
        RETURNING li_result,g_cos.cos01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
           DISPLAY BY NAME g_cos.cos01
 
#       IF cl_null(g_cos.cos01[5,10]) THEN              #自動編號
#          CALL s_acoauno(g_cos.cos01,g_cos.cos03,'11')
#            RETURNING g_i,g_cos.cos01
#          IF g_i THEN CONTINUE WHILE END IF
#          DISPLAY BY NAME g_cos.cos01
#       END IF
#No.FUN-560002--end
        LET g_cos.cosoriu = g_user      #No.FUN-980030 10/01/04
        LET g_cos.cosorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cos_file VALUES (g_cos.*)
#        LET g_t1 = g_cos.cos01[1,3]                #備份上一筆單別
        LET g_t1 = s_get_doc_no(g_cos.cos01)       #No.FUN-560002
        IF SQLCA.sqlcode THEN                      #置入資料庫不成功
#           CALL cl_err(g_cos.cos01,SQLCA.sqlcode,1)
            CALL cl_err3("ins","cos_file",g_cos.cos01,"",SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_cos.cos01,'I')
        SELECT cos01 INTO g_cos.cos01 FROM cos_file
            WHERE cos01 = g_cos.cos01
        LET g_cos01_t = g_cos.cos01        #保留舊值
        LET g_cos_t.* = g_cos.*
        LET g_cos_o.* = g_cos.*
        LET g_rec_b=0
        CALL i800_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i800_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cos.cos01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_cos.* FROM cos_file WHERE cos01=g_cos.cos01
    IF g_cos.cosacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cos.cos01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cos01_t = g_cos.cos01
    BEGIN WORK
 
    OPEN i800_cl USING g_cos.cos01
    IF STATUS THEN
       CALL cl_err("OPEN i800_cl:", STATUS, 1)
       CLOSE i800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i800_cl INTO g_cos.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cos.cos01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i800_cl
        RETURN
    END IF
    CALL i800_show()
    WHILE TRUE
        LET g_cos01_t = g_cos.cos01
        LET g_cos_o.* = g_cos.*
        LET g_cos.cosmodu=g_user
        LET g_cos.cosdate=g_today
        CALL i800_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cos.*=g_cos_t.*
            CALL i800_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_cos.cos01 != g_cos01_t THEN            # 更改單號
            UPDATE cot_file SET cot01 = g_cos.cos01
                WHERE cot01 = g_cos01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('cot',SQLCA.sqlcode,0) 
                CALL cl_err3("upd","cot_file",g_cos01_t,"",SQLCA.sqlcode,"","cot",1) #TQC-660045
                CONTINUE WHILE
            END IF
        END IF
UPDATE cos_file SET cos_file.* = g_cos.* 
WHERE cos01 =g_cos01_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cos.cos01,SQLCA.sqlcode,0)
            CALL cl_err3("upd","cos_file",g_cos01_t,"",SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i800_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cos.cos01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION i800_i(p_cmd)
#No.FUN-560002--begin
    DEFINE li_result   LIKE type_file.num5          #No.FUN-680069 SMALLINT
#No.FUN-560002--end
DEFINE
    l_desc    LIKE ze_file.ze03,            #No.FUN-680069 VARCHAR(70)
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_n	      LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    p_cmd     LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0033
    DISPLAY BY NAME
        g_cos.cos01,g_cos.cos02,g_cos.cos03,g_cos.cos04,g_cos.cos05,
        g_cos.cos06,g_cos.cos13,g_cos.cos07,g_cos.cos08,g_cos.cos09,g_cos.cos10,
        g_cos.cos11,g_cos.cos12,g_cos.cosuser,g_cos.cosgrup,
        g_cos.cosmodu,g_cos.cosdate,g_cos.cosacti
        #FUN-840202     ---start---
        ,g_cos.cosud01,g_cos.cosud02,g_cos.cosud03,g_cos.cosud04,
        g_cos.cosud05,g_cos.cosud06,g_cos.cosud07,g_cos.cosud08,
        g_cos.cosud09,g_cos.cosud10,g_cos.cosud11,g_cos.cosud12,
        g_cos.cosud13,g_cos.cosud14,g_cos.cosud15 
        #FUN-840202     ----end----
 
    INPUT BY NAME
        g_cos.cos01,g_cos.cos02,g_cos.cos03,g_cos.cos04,g_cos.cos05,
        g_cos.cos06,g_cos.cos13,g_cos.cos07,g_cos.cos08,g_cos.cos09,g_cos.cos10,
        g_cos.cos11,g_cos.cos12
        #FUN-840202     ---start---
        ,g_cos.cosud01,g_cos.cosud02,g_cos.cosud03,g_cos.cosud04,
        g_cos.cosud05,g_cos.cosud06,g_cos.cosud07,g_cos.cosud08,
        g_cos.cosud09,g_cos.cosud10,g_cos.cosud11,g_cos.cosud12,
        g_cos.cosud13,g_cos.cosud14,g_cos.cosud15 
        #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i800_set_entry(p_cmd)
            CALL i800_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-550002--begin
            CALL cl_set_docno_format("cos01")
#No.FUN-550002--end
        AFTER FIELD cos01
#No.FUN-550002--begin
           IF NOT cl_null(g_cos.cos01) AND (g_cos.cos01!=g_cos_t.cos01) THEN
#               CALL s_check_no(g_sys,g_cos.cos01,g_cos_t.cos03,"11","cos_file","","")
#              CALL s_check_no(g_sys,g_cos.cos01,g_cos_t.cos01,"11","cos_file","","")    #No.FUN-560002
               CALL s_check_no("aco",g_cos.cos01,g_cos_t.cos01,"11","cos_file","","")    #No.FUN-560002  #No.FUN-A40041
               RETURNING li_result,g_cos.cos01
               IF (NOT li_result) THEN
                   LET g_cos.cos01 = g_cos_o.cos01
                   NEXT FIELD cos01
               END IF
 
#              LET g_t1=g_cos.cos01[1,3]
#              CALL s_acoslip(g_t1,'11',g_sys)           #檢查單別
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 LET g_cos.cos01=g_cos_o.cos01
#                 NEXT FIELD cos01
#              END IF
#              IF p_cmd = 'a'  THEN
#          IF g_cos.cos01[1,3] IS NOT NULL AND       #並且單號空白時,
#          	  cl_null(g_cos.cos01[5,10]) THEN           #請用戶自行輸入
#             IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
#                NEXT FIELD cos01
#             ELSE					 #要不, 則單號不用
#                NEXT FIELD cos02			 #輸入
# 	             END IF
#           END IF
#           IF g_cos.cos01[1,3] IS NOT NULL AND	 #並且單號空白時,
#          	   NOT cl_null(g_cos.cos01[5,10]) THEN	 #請用戶自行輸入
#                     IF NOT cl_chk_data_continue(g_cos.cos01[5,10]) THEN
#                        CALL cl_err('','9056',0)
#                        NEXT FIELD cos01
#                     END IF
#                  END IF
#              END IF
#              IF g_cos.cos01 != g_cos01_t OR g_cos01_t IS NULL THEN
#                  SELECT count(*) INTO l_n FROM cos_file
#                      WHERE cos01 = g_cos.cos01
#                  IF l_n > 0 THEN   #單據編號重複
#                      CALL cl_err(g_cos.cos01,-239,0)
#                      LET g_cos.cos01 = g_cos01_t
#                      DISPLAY BY NAME g_cos.cos01
#                      NEXT FIELD cos01
#                  END IF
#              END IF
           END IF
      #No.FUN-550002---end---
 
 
        AFTER FIELD cos02                  #公司別
            IF NOT cl_null(g_cos.cos02) THEN
               IF g_cos_o.cos02 IS NULL OR
                  (g_cos_o.cos02 != g_cos.cos02) THEN
                  CALL i800_cos02(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cos.cos02,g_errno,0)
                     LET g_cos.cos02 = g_cos_o.cos02
                     DISPLAY BY NAME g_cos.cos02
                     NEXT FIELD cos02
                  END IF
               END IF
            END IF
            LET g_cos_o.cos02 = g_cos.cos02
 
        AFTER FIELD cos08
            IF NOT cl_null(g_cos.cos08) THEN
               IF g_cos_o.cos08 IS NULL OR
                  (g_cos_o.cos08 != g_cos.cos08) THEN
                  SELECT COUNT(*) INTO l_n FROM cos_file
                   WHERE cos08=g_cos.cos08
                  IF l_n > 0  THEN
                     CALL cl_err(g_cos.cos08,'-239',0)
                     NEXT FIELD cos08
                  END IF
               END IF
               LET g_cos_o.cos08 = g_cos.cos08
            END IF
 
        AFTER FIELD cos10
            IF NOT cl_null(g_cos.cos10) THEN
               IF  g_cos.cos10 NOT MATCHES '[1-7]' THEN
                  NEXT FIELD cos10
               END IF
               LET g_cos_o.cos10 = g_cos.cos10
               CALL i800_cos10()
            END IF
        #FUN-840202     ---start---
        AFTER FIELD cosud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cosud15
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
              WHEN INFIELD(cos01) #單別
                    #CALL q_coy(FALSE, FALSE,g_cos.cos01,'11',g_sys)  #TQC-670008
                    CALL q_coy(FALSE, FALSE,g_cos.cos01,'11','ACO')   #TQC-670008
                               RETURNING g_cos.cos01
#                    CALL FGL_DIALOG_SETBUFFER( g_cos.cos01 )
                    DISPLAY BY NAME g_cos.cos01
                    NEXT FIELD cos01
               WHEN INFIELD(cos02) #公司別
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_cnb"
                    LET g_qryparam.default1 = g_cos.cos02
                    CALL cl_create_qry() RETURNING g_cos.cos02
#                    CALL FGL_DIALOG_SETBUFFER( g_cos.cos02 )
                    DISPLAY BY NAME g_cos.cos02
                    CALL i800_cos02('d')
                    NEXT FIELD cos02
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
FUNCTION i800_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("cos01",TRUE)
    END IF
 
END FUNCTION
FUNCTION i800_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cos01",FALSE)
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION i800_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cos.* TO NULL               #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_cot.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i800_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_cos.* TO NULL
        RETURN
    END IF
    OPEN i800_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cos.* TO NULL
    ELSE
        OPEN i800_count
        FETCH i800_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i800_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i800_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i800_cs INTO g_cos.cos01
        WHEN 'P' FETCH PREVIOUS i800_cs INTO g_cos.cos01
        WHEN 'F' FETCH FIRST    i800_cs INTO g_cos.cos01
        WHEN 'L' FETCH LAST     i800_cs INTO g_cos.cos01
        WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump i800_cs INTO g_cos.cos01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cos.cos01,SQLCA.sqlcode,0)
        INITIALIZE g_cos.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_cos.* FROM cos_file WHERE cos01 = g_cos.cos01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cos.cos01,SQLCA.sqlcode,0)
        CALL cl_err3("sel","cos_file",g_cos.cos01,"",SQLCA.sqlcode,"","",1) #TQC-660045
        INITIALIZE g_cos.* TO NULL
        RETURN
    END IF
 
    CALL i800_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i800_show()
    LET g_cos_t.* = g_cos.*                #保存單頭舊值
    LET g_cos_o.* = g_cos.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_cos.cos01,g_cos.cos02,g_cos.cos03,g_cos.cos04,g_cos.cos05,
        g_cos.cos06,g_cos.cos07,g_cos.cos08,g_cos.cos09,
        g_cos.cos10,g_cos.cos11,g_cos.cos12,g_cos.cos13,
        g_cos.cosuser,g_cos.cosgrup,g_cos.cosmodu,
        g_cos.cosdate,g_cos.cosacti
        #FUN-840202     ---start---
        ,g_cos.cosud01,g_cos.cosud02,g_cos.cosud03,g_cos.cosud04,
        g_cos.cosud05,g_cos.cosud06,g_cos.cosud07,g_cos.cosud08,
        g_cos.cosud09,g_cos.cosud10,g_cos.cosud11,g_cos.cosud12,
        g_cos.cosud13,g_cos.cosud14,g_cos.cosud15 
        #FUN-840202     ----end----
 
    CALL i800_cos02('d')
    CALL i800_cos10()
    CALL i800_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i800_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cos.cos01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i800_cl USING g_cos.cos01
    IF STATUS THEN
       CALL cl_err("OPEN i800_cl:", STATUS, 1)
       CLOSE i800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i800_cl INTO g_cos.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cos.cos01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i800_show()
    IF cl_exp(0,0,g_cos.cosacti) THEN                   #審核一下
        LET g_chr=g_cos.cosacti
        IF g_cos.cosacti='Y' THEN
            LET g_cos.cosacti='N'
        ELSE
            LET g_cos.cosacti='Y'
        END IF
        UPDATE cos_file                    #更改有效碼
            SET cosacti=g_cos.cosacti
            WHERE cos01=g_cos.cos01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_cos.cos01,SQLCA.sqlcode,0)
            CALL cl_err3("upd","cos_file",g_cos.cos01,"",SQLCA.sqlcode,"","",1) #TQC-660045
            LET g_cos.cosacti=g_chr
        END IF
        DISPLAY BY NAME g_cos.cosacti
    END IF
    CLOSE i800_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cos.cos01,'V')
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION i800_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cos.cos01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i800_cl USING g_cos.cos01
    IF STATUS THEN
       CALL cl_err("OPEN i800_cl:", STATUS, 1)
       CLOSE i800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i800_cl INTO g_cos.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cos.cos01,SQLCA.sqlcode,0)        #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i800_show()
    IF cl_delh(0,0) THEN                                #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cos01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cos.cos01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                             #No.FUN-9B0098 10/02/24
       DELETE FROM cos_file WHERE cos01 = g_cos.cos01
       IF SQLCA.sqlerrd[3]=0  THEN
#         CALL cl_err('del_cos',SQLCA.sqlcode,0)        #無資料
          CALL cl_err3("del","cos_file",g_cos.cos01,"",SQLCA.sqlcode,"","del_cos",1) #TQC-660045
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM cot_file WHERE cot01 = g_cos.cos01
#      IF SQLCA.sqlerrd[3]=0  THEN                #MOD-C70236 mark
       IF SQLCA.sqlcode THEN                      #MOD-C70236 add
#         CALL cl_err('del_cot',SQLCA.sqlcode,0)        #無資料
          CALL cl_err3("del","cot_file",g_cos.cos01,"",SQLCA.sqlcode,"","del_cot",1) #TQC-660045
          ROLLBACK WORK
          RETURN
       END IF
       CLEAR FORM
       CALL g_cot.clear()
         #CKP3
         OPEN i800_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i800_cs
            CLOSE i800_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i800_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i800_cs
            CLOSE i800_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i800_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i800_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i800_fetch('/')
         END IF
    END IF
    CLOSE i800_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cos.cos01,'D')
END FUNCTION
 
#單身
FUNCTION i800_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680069 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_cos.cos01 IS NULL THEN RETURN END IF
    SELECT * INTO g_cos.* FROM cos_file WHERE cos01=g_cos.cos01
    IF g_cos.cosacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_cos.cos01,'mfg1000',0)
       RETURN
    END IF
    LET g_cos.cosmodu=g_user
    LET g_cos.cosdate=g_today
    DISPLAY BY NAME g_cos.cosmodu,g_cos.cosdate
    LET g_success='Y'
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT cot02,cot03,cot04,cot05,cot06,cot07,cot08,cot09,cot10, ",
                       " cot11,cot12,cot13,cot14,cot15,cot16,cot17,cot18,cot19,cot191, ",
                       " cot20,cot21 FROM cot_file ",
                       " WHERE cot01=? AND cot02=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i800_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        #CKP2
        IF g_rec_b=0 THEN CALL g_cot.clear() END IF
 
        INPUT ARRAY g_cot WITHOUT DEFAULTS FROM s_cot.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN i800_cl USING g_cos.cos01
            IF STATUS THEN
               CALL cl_err("OPEN i800_cl:", STATUS, 1)
               CLOSE i800_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i800_cl INTO g_cos.*     #鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_cos.cos01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i800_cl
              ROLLBACK WORK
              RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_cot_t.* = g_cot[l_ac].*  #BACKUP
                LET g_cot_o.* = g_cot[l_ac].*  #BACKUP
                OPEN i800_bcl USING g_cos.cos01,g_cot_t.cot02
                IF STATUS THEN
                   CALL cl_err("OPEN i800_bcl:", STATUS, 1)
                   CLOSE i800_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i800_bcl INTO g_cot[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cot_t.cot02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD cot02


           
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_cot[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_cot[l_ac].* TO s_cot.*
              CALL g_cot.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO cot_file(cot01,cot02,cot03,cot04,cot05,
                                 cot06,cot07,cot08,cot09,cot10,
                                 cot11,cot12,cot13,cot14,cot15,
                                 cot16,cot17,cot18,cot19,cot191,
                                 cot20,cot21
                                 #No.FUN-840202 --start--
                                 ,cotud01,cotud02,cotud03,cotud04,cotud05,
                                 cotud06,cotud07,cotud08,cotud09,cotud10,
                                 #cotud11,cotud12,cotud13,cotud14,cotud15) #FUN-980002
                                 #No.FUN-840202 ---end---
                                 cotud11,cotud12,cotud13,cotud14,cotud15,  #FUN-980002
                                 cotplant,cotlegal) #FUN-980002
            VALUES(g_cos.cos01,g_cot[l_ac].cot02,
                   g_cot[l_ac].cot03,g_cot[l_ac].cot04,
                   g_cot[l_ac].cot05,g_cot[l_ac].cot06,
                   g_cot[l_ac].cot07,g_cot[l_ac].cot08,
                   g_cot[l_ac].cot09,
                   g_cot[l_ac].cot10,g_cot[l_ac].cot11,
                   g_cot[l_ac].cot12,g_cot[l_ac].cot13,
                   g_cot[l_ac].cot14,g_cot[l_ac].cot15,
                   g_cot[l_ac].cot16,g_cot[l_ac].cot17,
                   g_cot[l_ac].cot18,g_cot[l_ac].cot19,
                   g_cot[l_ac].cot191,
                   g_cot[l_ac].cot20,g_cot[l_ac].cot21
                   #No.FUN-840202 --start--
                   ,g_cot[l_ac].cotud01,g_cot[l_ac].cotud02,g_cot[l_ac].cotud03,
                   g_cot[l_ac].cotud04,g_cot[l_ac].cotud05,g_cot[l_ac].cotud06,
                   g_cot[l_ac].cotud07,g_cot[l_ac].cotud08,g_cot[l_ac].cotud09,
                   g_cot[l_ac].cotud10,g_cot[l_ac].cotud11,g_cot[l_ac].cotud12,
                   #g_cot[l_ac].cotud13,g_cot[l_ac].cotud14,g_cot[l_ac].cotud15) #FUN-980002
                   #No.FUN-840202 ---end---
                   g_cot[l_ac].cotud13,g_cot[l_ac].cotud14,g_cot[l_ac].cotud15,  #FUN-980002
                   g_plant,g_legal)  #FUN-980002
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cot[l_ac].cot02,SQLCA.sqlcode,0)
               CALL cl_err3("ins","cot_file",g_cos.cos01,g_cot[l_ac].cot02,SQLCA.sqlcode,"","",1) #TQC-660045
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
               LET g_cot[l_ac].* = g_cot_t.*
               DISPLAY g_cot[l_ac].* TO s_cot[l_sl].*
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_cot[l_ac].* TO NULL       #900423
            LET g_cot[l_ac].cot08 = 0              #Body default
            LET g_cot[l_ac].cot10 = 0              #Body default
            LET g_cot[l_ac].cot12 = 0              #Body default
            LET g_cot[l_ac].cot13 = 0              #Body default
            LET g_cot[l_ac].cot15 = 0              #Body default
            LET g_cot[l_ac].cot16 = 0              #Body default
            LET g_cot[l_ac].cot17 = 0              #Body default
            LET g_cot[l_ac].cot18 = 'Y'            #Body default
            LET g_cot_t.* = g_cot[l_ac].*          #新輸入資料
            LET g_cot_o.* = g_cot[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cot02
 
        BEFORE FIELD cot02                        #default 序號
            IF g_cot[l_ac].cot02 IS NULL OR g_cot[l_ac].cot02 = 0 THEN
                SELECT max(cot02)+1 INTO g_cot[l_ac].cot02 FROM cot_file
                WHERE cot01 = g_cos.cos01
                IF g_cot[l_ac].cot02 IS NULL THEN
                    LET g_cot[l_ac].cot02 = 1
                END IF
                DISPLAY g_cot[l_ac].cot02 TO s_cot[l_sl].cot02
            END IF
 
        AFTER FIELD cot02                        #check 序號是否重複
            IF NOT cl_null(g_cot[l_ac].cot02) THEN
               IF g_cot[l_ac].cot02 != g_cot_t.cot02 OR
                  g_cot_t.cot02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM cot_file
                       WHERE cot01 = g_cos.cos01 AND
                             cot02 = g_cot[l_ac].cot02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cot[l_ac].cot02 = g_cot_t.cot02
                       NEXT FIELD cot02
                   END IF
               END IF
            END IF
 
        AFTER FIELD cot03                  #海關編號
            IF NOT cl_null(g_cot[l_ac].cot03) THEN
               IF g_cot_o.cot03 IS NULL OR
                 (g_cot[l_ac].cot03 !=g_cot_t.cot03 ) THEN
                  CALL i800_cot03('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cot[l_ac].cot03,g_errno,0)  
                     LET g_cot[l_ac].cot03 = g_cot_o.cot03
                     LET g_cot[l_ac].cot04 = g_cot_o.cot04
                     DISPLAY g_cot[l_ac].cot03 TO s_cot[l_sl].cot03
                     DISPLAY g_cot[l_ac].cot04 TO s_cot[l_sl].cot04
                     NEXT FIELD cot03
                  END IF
               END IF
            END IF
 
        AFTER FIELD cot07                  #產地
            IF NOT cl_null(g_cot[l_ac].cot07) THEN
               IF g_cot_o.cot07 IS NULL OR
                 (g_cot[l_ac].cot07 !=g_cot_t.cot07 ) THEN
                  CALL i800_cot07('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cot[l_ac].cot07,g_errno,0)
                     LET g_cot[l_ac].cot07 = g_cot_o.cot07
                     DISPLAY g_cot[l_ac].cot07 TO s_cot[l_sl].cot07
                     NEXT FIELD cot07
                  END IF
               END IF
            END IF
            
        #No.FUN-BB0086--add--begin---
        AFTER FIELD cot08
           LET g_cot[l_ac].cot08=s_digqty(g_cot[l_ac].cot08,g_cot[l_ac].cot09)
           DISPLAY BY NAME g_cot[l_ac].cot08
        #No.FUN-BB0086--add--end--- 
        
        AFTER FIELD cot09
            IF NOT cl_null(g_cot[l_ac].cot09) THEN
               IF g_cot_o.cot09 IS NULL OR
                 (g_cot[l_ac].cot09 != g_cot_o.cot09 ) THEN
                 CALL i800_cot09('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_cot[l_ac].cot09,g_errno,0)
                    NEXT FIELD cot09
                 END IF
               END IF
               #No.FUN-BB0086--add--begin--- 
               LET g_cot[l_ac].cot08=s_digqty(g_cot[l_ac].cot08,g_cot[l_ac].cot09)
               DISPLAY BY NAME g_cot[l_ac].cot08
               #No.FUN-BB0086--add--end--- 
            END IF
 
        BEFORE FIELD cot18
            CALL i800_set_entry_b()
 
        AFTER FIELD cot18
            IF NOT cl_null(g_cot[l_ac].cot18) THEN
               IF g_cot[l_ac].cot18 NOT MATCHES '[YyNn]' THEN
                  NEXT FIELD cot18
               END IF
               IF g_cot[l_ac].cot18='N' THEN
                  LET g_cot[l_ac].cot19=''
                  LET g_cot[l_ac].cot191=''
                  DISPLAY g_cot[l_ac].cot19 TO cot19
                  DISPLAY g_cot[l_ac].cot191 TO cot191
                  NEXT FIELD cot20
               END IF
            END IF
            CALL i800_set_no_entry_b()
 
#        BEFORE FIELD cot191
# genero  script marked             IF cl_ku() THEN
#               IF g_cot[l_ac].cot18='N' THEN
#                  NEXT FIELD cot18
#               ELSE
#                  NEXT FIELD cot19
#               END IF
#            END IF
 
        AFTER FIELD cot21
            IF NOT cl_null(g_cot[l_ac].cot21) THEN
               IF g_cot_o.cot21 IS NULL OR
                 (g_cot[l_ac].cot21 != g_cot_o.cot21 ) THEN
                 CALL i800_cot21('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_cot[l_ac].cot21,g_errno,0)
                    NEXT FIELD cot21
                 END IF
               END IF
            END IF
        #No.FUN-840202 --start--
        AFTER FIELD cotud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cotud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_cot_t.cot02 > 0 AND g_cot_t.cot02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM cot_file
                    WHERE cot01 = g_cos.cos01 AND
                          cot02 = g_cot_t.cot02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cot_t.cot02,SQLCA.sqlcode,0)
                    CALL cl_err3("del","cot_file",g_cos.cos01,g_cot_t.cot02,SQLCA.sqlcode,"","",1) #TQC-660045
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
               LET g_cot[l_ac].* = g_cot_t.*
               CLOSE i800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cot[l_ac].cot02,-263,1)
               LET g_cot[l_ac].* = g_cot_t.*
            ELSE
               UPDATE cot_file SET
                      cot02=g_cot[l_ac].cot02,cot03=g_cot[l_ac].cot03,
                      cot04=g_cot[l_ac].cot04,cot05=g_cot[l_ac].cot05,
                      cot06=g_cot[l_ac].cot06,cot07=g_cot[l_ac].cot07,
                      cot08=g_cot[l_ac].cot08,cot09=g_cot[l_ac].cot09,
                      cot10=g_cot[l_ac].cot10,cot11=g_cot[l_ac].cot11,
                      cot12=g_cot[l_ac].cot12,cot13=g_cot[l_ac].cot13,
                      cot14=g_cot[l_ac].cot14,cot15=g_cot[l_ac].cot15,
                      cot16=g_cot[l_ac].cot16,cot17=g_cot[l_ac].cot17,
                      cot18=g_cot[l_ac].cot18,cot19=g_cot[l_ac].cot19,
                      cot191=g_cot[l_ac].cot191,cot20=g_cot[l_ac].cot20,
                      cot21=g_cot[l_ac].cot21
                      #No.FUN-840202 --start--
                      ,cotud01 = g_cot[l_ac].cotud01,
                      cotud02 = g_cot[l_ac].cotud02,
                      cotud03 = g_cot[l_ac].cotud03,
                      cotud04 = g_cot[l_ac].cotud04,
                      cotud05 = g_cot[l_ac].cotud05,
                      cotud06 = g_cot[l_ac].cotud06,
                      cotud07 = g_cot[l_ac].cotud07,
                      cotud08 = g_cot[l_ac].cotud08,
                      cotud09 = g_cot[l_ac].cotud09,
                      cotud10 = g_cot[l_ac].cotud10,
                      cotud11 = g_cot[l_ac].cotud11,
                      cotud12 = g_cot[l_ac].cotud12,
                      cotud13 = g_cot[l_ac].cotud13,
                      cotud14 = g_cot[l_ac].cotud14,
                      cotud15 = g_cot[l_ac].cotud15
                      #No.FUN-840202 ---end---
                      WHERE cot01=g_cos.cos01 AND cot02=g_cot_t.cot02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_cot[l_ac].cot02,SQLCA.sqlcode,0)
                   CALL cl_err3("upd","cot_file",g_cos.cos01,g_cot[l_ac].cot02,SQLCA.sqlcode,"","",1) #TQC-660045
                   LET g_cot[l_ac].* = g_cot_t.*
                   DISPLAY g_cot[l_ac].* TO s_cot[l_sl].*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   LET g_cos.cosmodu=g_user
                   LET g_cos.cosdate=g_today
UPDATE cos_file SET cos_file.* = g_cos.* 
WHERE cos01 =g_cos01_t
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_cot[l_ac].* = g_cot_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cot.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE i800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
          #LET g_cot_t.* = g_cot[l_ac].*          # 900423
            LET l_ac_t = l_ac     #FUN-D30034 Add  
            CLOSE i800_bcl
            COMMIT WORK
            #CKP2
           #CALL g_cot.deleteElement(g_rec_b+1)   #FUN-D30034 Mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cot02) AND l_ac > 1 THEN
                LET g_cot[l_ac].* = g_cot[l_ac-1].*
                NEXT FIELD cot02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON ACTION controlp
            CASE
               WHEN INFIELD(cot03) #海關代號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_cna"
                    LET g_qryparam.default1 = g_cot[l_ac].cot03
                    CALL cl_create_qry() RETURNING g_cot[l_ac].cot03
#                    CALL FGL_DIALOG_SETBUFFER( g_cot[l_ac].cot03 )
                    DISPLAY g_cot[l_ac].cot03 TO cot03
                    NEXT FIELD cot03
               WHEN INFIELD(cot09) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_cot[l_ac].cot09
                    CALL cl_create_qry() RETURNING g_cot[l_ac].cot09
#                    CALL FGL_DIALOG_SETBUFFER( g_cot[l_ac].cot09 )
                    DISPLAY BY NAME g_cot[l_ac].cot09
                    NEXT FIELD cot09
               WHEN INFIELD(cot07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_geb"
                    LET g_qryparam.default1 = g_cot[l_ac].cot07
                    CALL cl_create_qry() RETURNING g_cot[l_ac].cot07
#                    CALL FGL_DIALOG_SETBUFFER( g_cot[l_ac].cot07 )
                    DISPLAY BY NAME g_cot[l_ac].cot07
                    NEXT FIELD cot07
               WHEN INFIELD(cot19)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_faj"
                    LET g_qryparam.default1 = g_cot[l_ac].cot19
                    LET g_qryparam.default2 = ''
                    CALL cl_create_qry() RETURNING g_cot[l_ac].cot19,g_cot[l_ac].cot191
#                    CALL FGL_DIALOG_SETBUFFER( g_cot[l_ac].cot19 )
#                    CALL FGL_DIALOG_SETBUFFER( g_cot[l_ac].cot191 )
                    DISPLAY BY NAME g_cot[l_ac].cot19
                    DISPLAY BY NAME g_cot[l_ac].cot191
                    NEXT FIELD cot19
               WHEN INFIELD(cot21)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_cot[l_ac].cot21
                    CALL cl_create_qry() RETURNING g_cot[l_ac].cot21
#                    CALL FGL_DIALOG_SETBUFFER( g_cot[l_ac].cot21 )
                    DISPLAY BY NAME g_cot[l_ac].cot21
                    NEXT FIELD cot21
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
 
        #FUN-5B0043-begin
         LET g_cos.cosmodu = g_user
         LET g_cos.cosdate = g_today
         UPDATE cos_file SET cosmodu = g_cos.cosmodu,cosdate = g_cos.cosdate
          WHERE cos01 = g_cos.cos01
         DISPLAY BY NAME g_cos.cosmodu,g_cos.cosdate
        #FUN-5B0043-end
 
        CLOSE i800_bcl
        CALL i800_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i800_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM cos_file WHERE cos01 = g_cos.cos01
         INITIALIZE g_cos.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i800_set_entry_b()
    IF INFIELD(cot18) THEN
       CALL cl_set_comp_entry("cot19",TRUE)
    END IF
END FUNCTION
 
FUNCTION i800_set_no_entry_b()
 
    IF INFIELD(cot18) THEN
       IF g_cot[l_ac].cot18='N' THEN
          CALL cl_set_comp_entry("cot19",FALSE)
       END IF
    END IF
END FUNCTION
 
FUNCTION i800_delall()
    SELECT COUNT(*) INTO g_cnt FROM cot_file
        WHERE cot01 = g_cos.cos01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否撤銷單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM cos_file WHERE cos01 = g_cos.cos01
    END IF
END FUNCTION
 
FUNCTION i800_cos02(p_cmd)  #公司別
    DEFINE l_cnb04   LIKE cnb_file.cnb04,
           l_cnbacti LIKE cnb_file.cnbacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT cnb04,cnbacti INTO l_cnb04,l_cnbacti
      FROM cnb_file WHERE cnb01 = g_cos.cos02
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-025'
                                   LET l_cnb04 = NULL
         WHEN l_cnbacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd='d' THEN
       DISPLAY l_cnb04 TO FORMONLY.cnb04
    END IF
END FUNCTION
 
FUNCTION i800_cos10()
    DEFINE l_desc      LIKE zaa_file.zaa08        #No.FUN-680069 VARCHAR(06)
    CASE g_cos.cos10
         WHEN '1'  CALL cl_getmsg('aco-017',g_lang) RETURNING l_desc
         WHEN '2'  CALL cl_getmsg('aco-018',g_lang) RETURNING l_desc
         WHEN '3'  CALL cl_getmsg('aco-019',g_lang) RETURNING l_desc
         WHEN '4'  CALL cl_getmsg('aco-020',g_lang) RETURNING l_desc
         WHEN '5'  CALL cl_getmsg('aco-021',g_lang) RETURNING l_desc
         WHEN '6'  CALL cl_getmsg('aco-022',g_lang) RETURNING l_desc
         WHEN '7'  CALL cl_getmsg('aco-023',g_lang) RETURNING l_desc
    END CASE
    DISPLAY l_desc TO FORMONLY.desc
 
END FUNCTION
 
 
FUNCTION i800_cot03(p_cmd)  #公司別
    DEFINE l_cna02   LIKE cna_file.cna02,
           l_cnaacti LIKE cna_file.cnaacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT cna02,cnaacti INTO l_cna02,l_cnaacti
      FROM cna_file WHERE cna01 = g_cot[l_ac].cot03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-016'
                                   LET l_cna02 = NULL
         WHEN l_cnaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd='d' THEN
       LET g_cot[l_ac].cot04=l_cna02
       DISPLAY l_cna02 TO s_cot[l_sl].cot04
    END IF
END FUNCTION
 
FUNCTION i800_cot09(p_cmd)  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti,
          l_price    LIKE cot_file.cot07,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
   WHERE gfe01 = g_cot[l_ac].cot09
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i800_cot07(p_cmd)  #產絡地
   DEFINE l_gebacti  LIKE geb_file.gebacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gebacti INTO l_gebacti FROM geb_file
                WHERE geb01 = g_cot[l_ac].cot07
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-152'
                            LET l_gebacti = NULL
         WHEN l_gebacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i800_cot19(p_cmd)  #資產代碼
   DEFINE l_fajconf  LIKE faj_file.fajconf,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT fajconf INTO l_fajconf FROM faj_file
   WHERE faj02 = g_cot[l_ac].cot19
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-911'
                                   LET l_fajconf = NULL
         WHEN l_fajconf='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i800_cot191(p_cmd)  #附號
   DEFINE l_fajconf  LIKE faj_file.fajconf,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT fajconf INTO l_fajconf FROM faj_file
   WHERE faj02 = g_cot[l_ac].cot19 AND faj022=g_cot[l_ac].cot191
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-911'
                                   LET l_fajconf = NULL
         WHEN l_fajconf='N'        LET g_errno = 'afa-918'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i800_cot21(p_cmd)  #部門
   DEFINE l_gemacti  LIKE gem_file.gemacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gemacti INTO l_gemacti FROM gem_file
                WHERE gem01 = g_cot[l_ac].cot21
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-039' #No.TQC-B60350 aom-160 改為 aap-039
                            LET l_gemacti = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i800_b_askkey()
DEFINE
    l_wc2   LIKE type_file.chr1000 #No.FUN-680069 VARCHAR(200)
 
 # 螢幕上取單身條件
    CONSTRUCT l_wc2 ON cot02,cot03,cot04,cot05,cot06,
                       cot07,cot08,cot09,cot11,cot12,
                       cot13,cot14,cot15,cot16,cot17,
                       cot18,cot19,cot20,cot21
            FROM s_cot[1].cot02,s_cot[1].cot03,s_cot[1].cot04,
                 s_cot[1].cot05,s_cot[1].cot06,s_cot[1].cot07,
                 s_cot[1].cot08,s_cot[1].cot09,s_cot[1].cot10,
                 s_cot[1].cot11,s_cot[1].cot12,s_cot[1].cot13,
                 s_cot[1].cot14,s_cot[1].cot15,s_cot[1].cot16,
                 s_cot[1].cot17,s_cot[1].cot18,s_cot[1].cot19,
                 s_cot[1].cot20,s_cot[1].cot21
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
    CALL i800_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i800_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2     LIKE type_file.chr1000 #No.FUN-680069 VARCHAR(200)
 
    LET g_sql =
         "SELECT cot02,cot03,cot04,cot05,cot06,cot07,cot08,cot09,cot10,",
         " cot11,cot12,cot13,cot14,cot15,cot16,cot17,cot18,cot19,",
         " cot191,cot20,cot21 ",
         #No.FUN-840202 --start--
         "       ,cotud01,cotud02,cotud03,cotud04,cotud05,",
         "       cotud06,cotud07,cotud08,cotud09,cotud10,",
         "       cotud11,cotud12,cotud13,cotud14,cotud15", 
         #No.FUN-840202 ---end---
         " FROM cot_file ",
    #No.FUN-8B0123---Begin
         " WHERE cot01 ='",g_cos.cos01,"'"            #AND ", #單頭
    #    p_wc2 CLIPPED," ORDER BY 1" CLIPPED          #單身
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1,2 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE i800_pb FROM g_sql
    DECLARE cot_cs                       #SCROLL CURSOR
        CURSOR FOR i800_pb
 
    CALL g_cot.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH cot_cs INTO g_cot[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    #CKP
    CALL g_cot.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i800_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cot TO s_cot.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i800_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i800_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i800_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i800_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i800_copy()
#No.FUN-560002--begin
    DEFINE li_result   LIKE type_file.num5          #No.FUN-680069 SMALLINT
#No.FUN-560002--end
DEFINE
    l_n             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    l_newno         LIKE cos_file.cos01,
    l_oldno         LIKE cos_file.cos01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cos.cos01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   #DISPLAY "" AT 1,1
    LET g_before_input_done = FALSE
    CALL i800_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
    INPUT l_newno FROM cos01
 
        AFTER FIELD cos01
#No.FUN-560002--begin
            IF NOT cl_null(l_newno) THEN
#              CALL s_check_no(g_sys,l_newno,"","11","cos_file","cos01","")
               CALL s_check_no("aco",l_newno,"","11","cos_file","cos01","")   #No.FUN-A40041
               RETURNING li_result,l_newno
               DISPLAY l_newno TO cos01
               IF (NOT li_result) THEN
                  NEXT FIELD cos01
               END IF
#              CALL s_auto_assign_no(g_sys,l_newno,g_cos.cos03,"11","cos_file","cos01","","","")
               CALL s_auto_assign_no("aco",l_newno,g_cos.cos03,"11","cos_file","cos01","","","")   #No.FUN-A40041
               RETURNING li_result,l_newno
               DISPLAY l_newno TO cos01
               IF (NOT li_result) THEN
                  NEXT FIELD cos01
               END IF
 
#           IF NOT cl_null(l_newno) THEN
#              LET g_t1=l_newno[1,3]
#              CALL s_acoslip(g_t1,'11',g_sys)           #檢查單別
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 NEXT FIELD coc01
#              END IF
#       IF l_newno[1,3] IS NOT NULL AND           #並且單號空白時,
#                 cl_null(l_newno[5,10]) THEN               #請用戶自行輸入
#          IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
#             NEXT FIELD coc01
#                 END IF
#              END IF
#              IF l_newno[1,3] IS NOT NULL AND           #並且單號空白時,
#                 NOT cl_null(l_newno[5,10]) THEN	      #請用戶自行輸入
#                 IF NOT cl_chk_data_continue(l_newno[5,10]) THEN
#                    CALL cl_err('','9056',0)
#                    NEXT FIELD coc01
#                 END IF
#              END IF
#              IF g_coy.coyauno = 'Y' THEN              #自動編號
#                 CALL s_acoauno(l_newno,g_today,'11')
#                   RETURNING g_i,l_newno
#                 IF g_i THEN NEXT FIELD coc01 END IF
#                 DISPLAY l_newno TO coc01
#              END IF
#              SELECT count(*) INTO g_cnt FROM cos_file WHERE cos01 = l_newno
#              IF g_cnt > 0 THEN
#                  CALL cl_err(l_newno,-239,0)
#                  NEXT FIELD cos01
#              END IF
#No.FUN-560002--end
           END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(cos01) #單別
                    #CALL q_coy( FALSE, FALSE,l_newno,'11',g_sys) RETURNING l_newno   #TQC-670008
                    CALL q_coy( FALSE, FALSE,l_newno,'11','ACO') RETURNING l_newno    #TQC-670008
#                    CALL FGL_DIALOG_SETBUFFER( l_newno )
                    DISPLAY l_newno TO cos01
                    NEXT FIELD cos01
              OTHERWISE EXIT CASE
            END CASE
 
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
        DISPLAY BY NAME g_cos.cos01
#No.FUN-560002--begin
#       ROLLBACK WORK                  #No.TQC-960251 
#No.FUN-560002--end
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM cos_file         #單頭複製
        WHERE cos01=g_cos.cos01
        INTO TEMP y
    UPDATE y
        SET cos01=l_newno,    #新的鍵值
            cosuser=g_user,   #資料所有者
            cosgrup=g_grup,   #資料所有者所屬群
            cosmodu=NULL,     #資料更改日期
            cosdate=g_today,  #資料建立日期
            cosacti='Y'       #有效資料
    INSERT INTO cos_file
        SELECT * FROM y
 
    DROP TABLE x
    SELECT * FROM cot_file         #單身複製
     WHERE cot01=g_cos.cos01 INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_cos.cos01,SQLCA.sqlcode,0)
       CALL cl_err3("sel","cot_file",g_cos.cos01,"",SQLCA.sqlcode,"","",1) #TQC-660045
       RETURN
    END IF
    UPDATE x SET cot01=l_newno
 
    INSERT INTO cot_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cos.cos01,SQLCA.sqlcode,0)
        CALL cl_err3("ins","cot_file",g_cos.cos01,"",SQLCA.sqlcode,"","",1) #TQC-660045
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_cos.cos01
      SELECT cos_file.* INTO g_cos.* FROM cos_file WHERE cos01 = l_newno
     CALL i800_u()
     CALL i800_b()
     #SELECT cos_file.* INTO g_cos.* FROM cos_file WHERE cos01 = l_oldno #FUN-C30027
     #CALL i800_show()  #FUN-C30027
END FUNCTION
