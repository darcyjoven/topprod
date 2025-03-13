# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acot810.4gl
# Descriptions...: 免稅進口設備出口報關維護作業
# Date & Author..: 00/08/01 By Carol
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-550036 05/05/25 By Trisy 單據編號加大
# Modify.........: No.FUN-570273 05/07/29 By Dido  單身未輸入確認無法跳出視窗
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-630014 06/03/07 By Carol 流程訊息通知功能
# MOdify.........: No.TQC-660045 06/06/13 By hellen  cl_err --> cl_err3
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
# Modify.........: No.FUN-840202 08/05/09 By TSD.sar2436 自定欄位功能修改
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-960257 09/07/14 By baofei  修改單身備案序號開窗中的傳值 
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BB0086 12/01/06 By tanxc 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cow           RECORD LIKE cow_file.*,       #單頭
    g_cow_t         RECORD LIKE cow_file.*,       #單頭(舊值)
    g_cow_o         RECORD LIKE cow_file.*,       #單頭(舊值)
    g_cow01_t       LIKE cow_file.cow01,          #單頭 (舊值)
    g_t1            LIKE oay_file.oayslip,        #No.FUN-550036        #No.FUN-680069 VARCHAR(05)
    g_cox           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        cox02       LIKE cox_file.cox02,          #項次
        cox03       LIKE cox_file.cox03,   #
        cox04       LIKE cox_file.cox04,   #
        cox05       LIKE cox_file.cox05,   #
        cox06       LIKE cox_file.cox06,   #
        cox07       LIKE cox_file.cox07,   #
        cox08       LIKE cox_file.cox08,    #
        #FUN-840202 --start---
        coxud01 LIKE cox_file.coxud01,
        coxud02 LIKE cox_file.coxud02,
        coxud03 LIKE cox_file.coxud03,
        coxud04 LIKE cox_file.coxud04,
        coxud05 LIKE cox_file.coxud05,
        coxud06 LIKE cox_file.coxud06,
        coxud07 LIKE cox_file.coxud07,
        coxud08 LIKE cox_file.coxud08,
        coxud09 LIKE cox_file.coxud09,
        coxud10 LIKE cox_file.coxud10,
        coxud11 LIKE cox_file.coxud11,
        coxud12 LIKE cox_file.coxud12,
        coxud13 LIKE cox_file.coxud13,
        coxud14 LIKE cox_file.coxud14,
        coxud15 LIKE cox_file.coxud15
        #FUN-840202 --end--
                    END RECORD,
    g_cox_t         RECORD                 #程式變數 (舊值)
        cox02       LIKE cox_file.cox02,   #項次
        cox03       LIKE cox_file.cox03,   #
        cox04       LIKE cox_file.cox04,   #
        cox05       LIKE cox_file.cox05,   #
        cox06       LIKE cox_file.cox06,   #
        cox07       LIKE cox_file.cox07,   #
        cox08       LIKE cox_file.cox08,    #
        #FUN-840202 --start---
        coxud01 LIKE cox_file.coxud01,
        coxud02 LIKE cox_file.coxud02,
        coxud03 LIKE cox_file.coxud03,
        coxud04 LIKE cox_file.coxud04,
        coxud05 LIKE cox_file.coxud05,
        coxud06 LIKE cox_file.coxud06,
        coxud07 LIKE cox_file.coxud07,
        coxud08 LIKE cox_file.coxud08,
        coxud09 LIKE cox_file.coxud09,
        coxud10 LIKE cox_file.coxud10,
        coxud11 LIKE cox_file.coxud11,
        coxud12 LIKE cox_file.coxud12,
        coxud13 LIKE cox_file.coxud13,
        coxud14 LIKE cox_file.coxud14,
        coxud15 LIKE cox_file.coxud15
       #FUN-840202 --end--
                    END RECORD,
    g_cox_o         RECORD                 #程式變數 (舊值)
        cox02       LIKE cox_file.cox02,   #項次
        cox03       LIKE cox_file.cox03,   #
        cox04       LIKE cox_file.cox04,   #
        cox05       LIKE cox_file.cox05,   #
        cox06       LIKE cox_file.cox06,   #
        cox07       LIKE cox_file.cox07,   #
        cox08       LIKE cox_file.cox08,    #
        #FUN-840202 --start---
        coxud01 LIKE cox_file.coxud01,
        coxud02 LIKE cox_file.coxud02,
        coxud03 LIKE cox_file.coxud03,
        coxud04 LIKE cox_file.coxud04,
        coxud05 LIKE cox_file.coxud05,
        coxud06 LIKE cox_file.coxud06,
        coxud07 LIKE cox_file.coxud07,
        coxud08 LIKE cox_file.coxud08,
        coxud09 LIKE cox_file.coxud09,
        coxud10 LIKE cox_file.coxud10,
        coxud11 LIKE cox_file.coxud11,
        coxud12 LIKE cox_file.coxud12,
        coxud13 LIKE cox_file.coxud13,
        coxud14 LIKE cox_file.coxud14,
        coxud15 LIKE cox_file.coxud15
       #FUN-840202 --end--
                    END RECORD,
    g_argv1         LIKE cox_file.cox01,   # 詢價單號
    g_argv2         STRING,                #No.FUN-680069  STRING    #FUN-630014 指定執行的功能
    g_wc,g_wc2,g_sql    STRING,            #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_sl            LIKE type_file.num5    #No.FUN-680069 SMALLINT           #目前處理的SCREEN LINE
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   #No.FUN-680069
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_i                   LIKE type_file.num5          #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680069 INTEGER
 
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680069 SMALLINT
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0063
    p_row,p_col     LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
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
 
    LET g_forupd_sql = " SELECT * FROM cow_file WHERE cow01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t810_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 15
    OPEN WINDOW t810_w AT p_row,p_col
        WITH FORM "aco/42f/acot810"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-630014 --start--
   #IF g_argv1 IS NOT NULL AND g_argv1 != ' '
   #THEN CALL t810_q()
   #END IF
   # 先以g_argv2判斷直接執行哪種功能
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t810_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t810_a()
            END IF
         OTHERWISE
            CALL t810_q()
      END CASE
   END IF
   #FUN-630014 ---end---
 
   CALL t810_menu()
   CLOSE WINDOW t810_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION t810_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_cox.clear()
 
 #IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN    #FUN-630014 mark
  IF NOT cl_null(g_argv1) THEN                      #FUN-630014 add
     LET g_wc = " cow01 = '",g_argv1,"'"
     LET g_wc2 = " 1=1"
  ELSE
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
   INITIALIZE g_cow.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
        cow01,cow02,cow03,cow04,cow16,cow05,cow06,cow07,cow08,cow09,cow10,
        cow11,cow12,cow13,cow14,cow15,
        cowuser,cowgrup,cowmodu,cowdate,cowacti,
       #FUN-840202   ---start---
        cowud01,cowud02,cowud03,cowud04,cowud05,
        cowud06,cowud07,cowud08,cowud09,cowud10,
        cowud11,cowud12,cowud13,cowud14,cowud15
       #FUN-840202    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
     ON ACTION controlp
           CASE
               WHEN INFIELD(cow01) #單別
                    #CALL q_coy( FALSE, TRUE,g_cow.cow01,'17',g_sys)  #TQC-670008
                    CALL q_coy( FALSE, TRUE,g_cow.cow01,'17','ACO')   #TQC-670008
                         RETURNING g_cow.cow01
                    DISPLAY BY NAME g_cow.cow01
                    NEXT FIELD cow01
               WHEN INFIELD(cow10) #國別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_geb"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cow10
                    NEXT FIELD cow10
               WHEN INFIELD(cow11) #幣別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_azi"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cow11
                   NEXT FIELD cow11
               WHEN INFIELD(cow03) #備案編號
                     CALL q_cos( FALSE, TRUE,g_cow.cow03)
                          RETURNING g_cow.cow03
                     DISPLAY BY NAME g_cow.cow03
                     NEXT FIELD cow03
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
    CONSTRUCT g_wc2 ON cox02,cox03,cox04,cox05,cox06,cox07,cox08,
                     #No.FUN-840202 --start--
                      coxud01,coxud02,coxud03,coxud04,coxud05,
                      coxud06,coxud07,coxud08,coxud09,coxud10,
                      coxud11,coxud12,coxud13,coxud14,coxud15
                     #No.FUN-840202 ---end---
            FROM s_cox[1].cox02,s_cox[1].cox03,s_cox[1].cox04,
                 s_cox[1].cox05,s_cox[1].cox06,s_cox[1].cox07,
                 s_cox[1].cox08,
              #No.FUN-840202 --start--
                s_cox[1].coxud01,s_cox[1].coxud02,s_cox[1].coxud03,s_cox[1].coxud04,s_cox[1].coxud05,
                s_cox[1].coxud06,s_cox[1].coxud07,s_cox[1].coxud08,s_cox[1].coxud09,s_cox[1].coxud10,
                s_cox[1].coxud11,s_cox[1].coxud12,s_cox[1].coxud13,s_cox[1].coxud14,s_cox[1].coxud15
              #No.FUN-840202 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       ON ACTION controlp
            CASE
               WHEN INFIELD(cox03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_cot"
        #            LET g_qryparam.where = "cos08=g_cow.cow03 "     #TQC-960257 
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cox03
                    NEXT FIELD cox03
               WHEN INFIELD(cox05)  #國別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_geb"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cox05
                    NEXT FIELD cox05
               WHEN INFIELD(cox07) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cox07
                    NEXT FIELD cox07
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
  #     LET g_wc = g_wc clipped," AND cowuser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND cowgrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND cowgrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cowuser', 'cowgrup')
  #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT cow01 FROM cow_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY cow01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cow01 ",
                   "  FROM cow_file,cox_file ",
                   " WHERE cow01 = cox01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY cow01"
    END IF
 
    PREPARE t810_prepare FROM g_sql
    DECLARE t810_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t810_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM cow_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM cow_file,cox_file WHERE ",
                  "cox01=cow01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t810_precount FROM g_sql
    DECLARE t810_count CURSOR FOR t810_precount
END FUNCTION
 
FUNCTION t810_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069  VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL t810_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t810_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t810_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t810_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t810_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t810_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t810_b()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cox),'','')
             END IF
         #--
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_cow.cow01 IS NOT NULL THEN
                 LET g_doc.column1 = "cow01"
                 LET g_doc.value1 = g_cow.cow01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t810_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550036        #No.FUN-680069 SMALLINT
    MESSAGE ""
    CLEAR FORM
    CALL g_cox.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_cow.* LIKE cow_file.*             #DEFAULT 設置
    LET g_cow01_t = NULL
    LET g_cow_t.* = g_cow.*
    LET g_cow_o.* = g_cow.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cow.cowuser=g_user
        LET g_data_plant = g_plant #FUN-980030
        LET g_cow.cowgrup=g_grup
        LET g_cow.cowdate=g_today
        LET g_cow.cowacti='Y'              #資料有效
        LET g_cow.cowplant = g_plant  #FUN-980002
        LET g_cow.cowlegal = g_legal  #FUN-980002
 
        BEGIN WORK
        CALL t810_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            INITIALIZE g_cow.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cow.cow01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
      #No.FUN-550036 --start--
#       IF cl_null(g_cow.cow01[g_no_sp,g_no_ep]) THEN
           CALL s_auto_assign_no("aco",g_cow.cow01,g_today,"17","cow_file","cow01","17","","")
           RETURNING li_result,g_cow.cow01
           IF (NOT li_result) THEN
              CONTINUE WHILE
           END IF
#       IF cl_null(g_cow.cow01[5,10]) THEN              #自動編號
#          CALL s_acoauno(g_cow.cow01,g_today,'17')
#            RETURNING g_i,g_cow.cow01
#          IF g_i THEN CONTINUE WHILE END IF
           DISPLAY BY NAME g_cow.cow01
#       END IF
        LET g_cow.coworiu = g_user      #No.FUN-980030 10/01/04
        LET g_cow.coworig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cow_file VALUES (g_cow.*)
#       LET g_t1 = g_cow.cow01[1,3]           #備份上一筆單別
        LET g_t1 = s_get_doc_no(g_cow.cow01)
    #No.FUN-550036 ---end---
        IF SQLCA.sqlcode THEN                      #置入資料庫不成功
#           CALL cl_err(g_cow.cow01,SQLCA.sqlcode,1) #No.TQC-660045
            CALL cl_err3("ins","cow_file",g_cow.cow01,"",SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_cow.cow01,'I')
        SELECT cow01 INTO g_cow.cow01 FROM cow_file
            WHERE cow01 = g_cow.cow01
        LET g_cow01_t = g_cow.cow01        #保留舊值
        LET g_cow_t.* = g_cow.*
        LET g_cow_o.* = g_cow.*
        FOR g_cnt = 1 TO g_cox.getLength()
            INITIALIZE g_cox[g_cnt].* TO NULL
        END FOR
 
        LET g_rec_b=0
        CALL t810_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t810_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cow.cow01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_cow.* FROM cow_file WHERE cow01=g_cow.cow01
    IF g_cow.cowacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cow.cow01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cow01_t = g_cow.cow01
    BEGIN WORK
 
    OPEN t810_cl USING g_cow.cow01
    IF STATUS THEN
       CALL cl_err("OPEN t810_cl:", STATUS, 1)
       CLOSE t810_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t810_cl INTO g_cow.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cow.cow01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t810_cl
        RETURN
    END IF
    CALL t810_show()
    WHILE TRUE
        LET g_cow01_t = g_cow.cow01
        LET g_cow_o.* = g_cow.*
        LET g_cow.cowmodu=g_user
        LET g_cow.cowdate=g_today
        CALL t810_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cow.*=g_cow_t.*
            CALL t810_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_cow.cow01 != g_cow01_t THEN            # 更改單號
            UPDATE cox_file SET cox01 = g_cow.cow01
                WHERE cox01 = g_cow01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('cox',SQLCA.sqlcode,0)  #No.TQC-660045
                CALL cl_err3("upd","cox_file",g_cow01_t,"",SQLCA.sqlcode,"","cox",1) #TQC-660045
                CONTINUE WHILE
            END IF
        END IF
        UPDATE cow_file SET cow_file.* = g_cow.*
            WHERE cow01 = g_cow01_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cow.cow01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cow_file",g_cow01_t,"",SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t810_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cow.cow01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t810_i(p_cmd)
DEFINE   li_result   LIKE type_file.num5         #No.FUN-550036        #No.FUN-680069 SMALLINT
DEFINE
    l_desc    LIKE type_file.chr1000,            #No.FUN-680069  VARCHAR(70)
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_n	      LIKE type_file.num5,               #No.FUN-680069 SMALLINT
    p_cmd     LIKE type_file.chr1                #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
 
    DISPLAY BY NAME
        g_cow.cow01,g_cow.cow02,g_cow.cow03,g_cow.cow04,g_cow.cow16,
        g_cow.cow05,g_cow.cow06,g_cow.cow07,g_cow.cow08,g_cow.cow09,
        g_cow.cow10,g_cow.cow11,g_cow.cow12,g_cow.cow13,g_cow.cow14,
        g_cow.cow15,g_cow.cowuser,g_cow.cowgrup,
        g_cow.cowmodu,g_cow.cowdate,g_cow.cowacti
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
 
    INPUT BY NAME
        g_cow.cow01,g_cow.cow02,g_cow.cow03,g_cow.cow04,g_cow.cow16,g_cow.cow05,
        g_cow.cow06,g_cow.cow07,g_cow.cow08,g_cow.cow09,g_cow.cow10,
        g_cow.cow11,g_cow.cow12,g_cow.cow13,g_cow.cow14,g_cow.cow15,
     #FUN-840202     ---start---
        g_cow.cowud01,g_cow.cowud02,g_cow.cowud03,g_cow.cowud04,
        g_cow.cowud05,g_cow.cowud06,g_cow.cowud07,g_cow.cowud08,
        g_cow.cowud09,g_cow.cowud10,g_cow.cowud11,g_cow.cowud12,
        g_cow.cowud13,g_cow.cowud14,g_cow.cowud15 
     #FUN-840202     ----end----
 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t810_set_entry(p_cmd)
            CALL t810_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550036 --start--
         CALL cl_set_docno_format("cow01")
         CALL cl_set_docno_format("cow02")
         CALL cl_set_docno_format("cow12")
         #No.FUN-550036 ---end---
 
       {
        BEFORE FIELD cow01    #本系統不允許更改key
            IF p_cmd = 'u'  AND g_chkey = 'N' THEN
               NEXT FIELD cow02
            END IF
       }
        AFTER FIELD cow01
         #No.FUN-550036 --start--
         IF NOT cl_null(g_cow.cow01) THEN
            CALL s_check_no("aco",g_cow.cow01,g_cow01_t,"17","cow_file","cow01","")
            RETURNING li_result,g_cow.cow01
            DISPLAY BY NAME g_cow.cow01
            IF (NOT li_result) THEN
               LET g_cow.cow01=g_cow_o.cow01
               NEXT FIELD cow01
            END IF
 
#           IF NOT cl_null(g_cow.cow01) THEN
#              LET g_t1=g_cow.cow01[1,3]
#              CALL s_acoslip(g_t1,'17',g_sys)             #檢查單別
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 LET g_cow.cow01=g_cow_o.cow01
#                 NEXT FIELD cow01
#              END IF
#              IF p_cmd = 'a'  THEN
#          IF g_cow.cow01[1,3] IS NOT NULL AND       #並且單號空白時,
#          	  cl_null(g_cow.cow01[5,10]) THEN           #請用戶自行輸入
#             IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
#                NEXT FIELD cow01
#             ELSE					 #要不, 則單號不用
#                NEXT FIELD NEXT 			 #輸入
# 	             END IF
#           END IF
#           IF g_cow.cow01[1,3] IS NOT NULL AND	 #並且單號空白時,
#          	   NOT cl_null(g_cow.cow01[5,10]) THEN	 #請用戶自行輸入
#                     IF NOT cl_chk_data_continue(g_cow.cow01[5,10]) THEN
#                        CALL cl_err('','9056',0)
#                        NEXT FIELD cow01
#                     END IF
#                  END IF
#              END IF
#              IF g_cow.cow01 != g_cow01_t OR g_cow01_t IS NULL THEN
#                  SELECT COUNT(*) INTO l_n FROM cow_file
#                      WHERE cow01 = g_cow.cow01
#                  IF l_n > 0 THEN   #單據編號重複
#                      CALL cl_err(g_cow.cow01,-239,0)
#                      LET g_cow.cow01 = g_cow01_t
#                      DISPLAY BY NAME g_cow.cow01
#                      NEXT FIELD cow01
#                  END IF
#              END IF
 #No.FUN-550036 ---end---
            END IF
 
        AFTER FIELD cow03                  #備案編號
            IF NOT cl_null(g_cow.cow03) THEN
               IF g_cow_o.cow03 IS NULL OR
                  (g_cow_o.cow03 != g_cow.cow03) THEN
                  CALL t810_cow03()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cow.cow03,g_errno,0)
                     LET g_cow.cow03 = g_cow_o.cow03
                     DISPLAY BY NAME g_cow.cow03
                     NEXT FIELD cow03
                  END IF
               END IF
            END IF
            LET g_cow_o.cow03 = g_cow.cow03
 
        AFTER FIELD cow04                  #合同編號
            IF NOT cl_null(g_cow.cow04) THEN
                  CALL t810_cow04()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cow.cow04,g_errno,0)
                     LET g_cow.cow04 = g_cow_o.cow04
                     DISPLAY BY NAME g_cow.cow04
                     NEXT FIELD cow04
                  END IF
            END IF
            LET g_cow_o.cow04 = g_cow.cow04
 
        BEFORE FIELD cow06
            IF cl_null(g_cow.cow06)  THEN
               LET g_cow.cow06=g_today
               DISPLAY BY NAME g_cow.cow06
            END IF
        BEFORE FIELD cow08
            IF cl_null(g_cow.cow08)  THEN
               LET g_cow.cow08=g_today
               DISPLAY BY NAME g_cow.cow08
            END IF
        AFTER FIELD cow10
            IF NOT cl_null(g_cow.cow10) THEN
               IF g_cow_o.cow10 IS NULL OR
                  (g_cow_o.cow10 != g_cow.cow10) THEN
                     CALL t810_cow10()
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_cow.cow10,g_errno,0)
                        LET g_cow.cow10 = g_cow_o.cow10
                        DISPLAY BY NAME g_cow.cow10
                        NEXT FIELD cow10
                     END IF
               END IF
            END IF
            LET g_cow_o.cow10 = g_cow.cow10
 
        AFTER FIELD cow11
            IF NOT cl_null(g_cow.cow11) THEN
               IF g_cow_o.cow11 IS NULL OR
                  (g_cow_o.cow11 != g_cow.cow11) THEN
                     CALL t810_cow11()
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_cow.cow11,g_errno,0)
                        LET g_cow.cow11 = g_cow_o.cow11
                        DISPLAY BY NAME g_cow.cow11
                        NEXT FIELD cow11
                     END IF
               END IF
            END IF
            LET g_cow_o.cow11 = g_cow.cow11
 
        #FUN-840202     ---start---
        AFTER FIELD cowud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cowud15
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
               WHEN INFIELD(cow01) #單別
                   #CALL q_coy( FALSE, TRUE,g_cow.cow01,'17',g_sys)  #TQC-670008
                    CALL q_coy( FALSE, TRUE,g_cow.cow01,'17','ACO')  #TQC-670008
                         RETURNING g_cow.cow01
#                    CALL FGL_DIALOG_SETBUFFER( g_cow.cow01 )
                    DISPLAY BY NAME g_cow.cow01
                    NEXT FIELD cow01
               WHEN INFIELD(cow10) #國別
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_geb"
                    LET g_qryparam.default1 = g_cow.cow10
                    CALL cl_create_qry() RETURNING g_cow.cow10
#                    CALL FGL_DIALOG_SETBUFFER( g_cow.cow10 )
                    DISPLAY BY NAME g_cow.cow10
                    CALL t810_cow10()
                    NEXT FIELD cow10
               WHEN INFIELD(cow11) #幣別
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azi"
                    LET g_qryparam.default1 = g_cow.cow11
                    CALL cl_create_qry() RETURNING g_cow.cow11
#                    CALL FGL_DIALOG_SETBUFFER( g_cow.cow11 )
                    DISPLAY BY NAME g_cow.cow11
                    CALL t810_cow11()
                    NEXT FIELD cow11
               WHEN INFIELD(cow03) #備案編號
                    CALL q_cos( FALSE, TRUE,g_cow.cow03)
                         RETURNING g_cow.cow03
#                    CALL FGL_DIALOG_SETBUFFER( g_cow.cow03 )
                    DISPLAY BY NAME g_cow.cow03
                    NEXT FIELD cow03
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
FUNCTION t810_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("cow01",TRUE)
    END IF
 
 
END FUNCTION
FUNCTION t810_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cow01",FALSE)
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t810_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cow.* TO NULL               #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_cox.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t810_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_cow.* TO NULL
        RETURN
    END IF
    OPEN t810_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cow.* TO NULL
    ELSE
        OPEN t810_count
        FETCH t810_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t810_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t810_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t810_cs INTO g_cow.cow01
        WHEN 'P' FETCH PREVIOUS t810_cs INTO g_cow.cow01
        WHEN 'F' FETCH FIRST    t810_cs INTO g_cow.cow01
        WHEN 'L' FETCH LAST     t810_cs INTO g_cow.cow01
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
         FETCH ABSOLUTE g_jump t810_cs INTO g_cow.cow01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cow.cow01,SQLCA.sqlcode,0)
        INITIALIZE g_cow.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_cow.* FROM cow_file WHERE cow01 = g_cow.cow01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cow.cow01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cow_file",g_cow.cow01,"",SQLCA.sqlcode,"","",1) #TQC-660045
        INITIALIZE g_cow.* TO NULL
        RETURN
    END IF
 
    CALL t810_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t810_show()
    LET g_cow_t.* = g_cow.*                #保存單頭舊值
    LET g_cow_o.* = g_cow.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
 
        g_cow.cow01,g_cow.cow02,g_cow.cow03,g_cow.cow04,g_cow.cow16,
        g_cow.cow05,g_cow.cow06,g_cow.cow07,g_cow.cow08,g_cow.cow09,
        g_cow.cow10,g_cow.cow11,g_cow.cow12,g_cow.cow13,
        g_cow.cow14,g_cow.cow15,
        g_cow.cowuser,g_cow.cowgrup,g_cow.cowmodu,
        g_cow.cowdate,g_cow.cowacti,
      #FUN-840202     ---start---
        g_cow.cowud01,g_cow.cowud02,g_cow.cowud03,g_cow.cowud04,
        g_cow.cowud05,g_cow.cowud06,g_cow.cowud07,g_cow.cowud08,
        g_cow.cowud09,g_cow.cowud10,g_cow.cowud11,g_cow.cowud12,
        g_cow.cowud13,g_cow.cowud14,g_cow.cowud15 
      #FUN-840202     ----end----
    CALL cl_set_field_pic("","","","","",g_cow.cowacti)
 
    CALL t810_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t810_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cow.cow01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t810_cl USING g_cow.cow01
    IF STATUS THEN
       CALL cl_err("OPEN t810_cl:", STATUS, 1)
       CLOSE t810_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t810_cl INTO g_cow.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cow.cow01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t810_show()
    IF cl_exp(0,0,g_cow.cowacti) THEN                   #審核一下
        LET g_chr=g_cow.cowacti
        IF g_cow.cowacti='Y' THEN
            LET g_cow.cowacti='N'
        ELSE
            LET g_cow.cowacti='Y'
        END IF
        UPDATE cow_file                    #更改有效碼
            SET cowacti=g_cow.cowacti
            WHERE cow01=g_cow.cow01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_cow.cow01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cow_file",g_cow.cow01,"",SQLCA.sqlcode,"","",1) #TQC-660045
            LET g_cow.cowacti=g_chr
        END IF
        DISPLAY BY NAME g_cow.cowacti
    END IF
    CLOSE t810_cl
    COMMIT WORK
 
    CALL cl_set_field_pic("","","","","",g_cow.cowacti)
 
    CALL cl_flow_notify(g_cow.cow01,'V')
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t810_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cow.cow01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t810_cl USING g_cow.cow01
    IF STATUS THEN
       CALL cl_err("OPEN t810_cl:", STATUS, 1)
       CLOSE t810_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t810_cl INTO g_cow.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cow.cow01,SQLCA.sqlcode,0)        #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t810_show()
    IF cl_delh(0,0) THEN                                #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cow01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cow.cow01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                             #No.FUN-9B0098 10/02/24
       DELETE FROM cow_file WHERE cow01 = g_cow.cow01
       IF SQLCA.sqlerrd[3]=0  THEN
#         CALL cl_err('del_cow',SQLCA.sqlcode,0)        #無資料 #No.TQC-660045
          CALL cl_err3("del","cow_file",g_cow.cow01,"",SQLCA.sqlcode,"","del_cow",1) #TQC-660045
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM cox_file WHERE cox01 = g_cow.cow01
       IF SQLCA.sqlerrd[3]=0  THEN
#         CALL cl_err('del_cox',SQLCA.sqlcode,0)        #無資料 #No.TQC-660045
          CALL cl_err3("del","cox_file",g_cow.cow01,"",SQLCA.sqlcode,"","del_cox",1) #TQC-660045
          ROLLBACK WORK
          RETURN
       END IF
       CLEAR FORM
       CALL g_cox.clear()
 
         OPEN t810_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE t810_cs
            CLOSE t810_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH t810_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t810_cs
            CLOSE t810_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t810_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t810_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t810_fetch('/')
         END IF
    END IF
    CLOSE t810_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cow.cow01,'D')
END FUNCTION
 
#單身
FUNCTION t810_b()
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
    IF g_cow.cow01 IS NULL THEN RETURN END IF
    SELECT * INTO g_cow.* FROM cow_file WHERE cow01=g_cow.cow01
    IF g_cow.cowacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_cow.cow01,'mfg1000',0)
       RETURN
    END IF
    LET g_cow.cowmodu=g_user
    LET g_cow.cowdate=g_today
    DISPLAY BY NAME g_cow.cowmodu,g_cow.cowdate
    LET g_success='Y'
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql = " SELECT cox02,cox03,cox04,cox05,cox06,cox07,cox08, ",
                       #No.FUN-840202 --start--
                       "       coxud01,coxud02,coxud03,coxud04,coxud05,",
                       "       coxud06,coxud07,coxud08,coxud09,coxud10,",
                       "       coxud11,coxud12,coxud13,coxud14,coxud15", 
                       #No.FUN-840202 ---end---
                       " FROM cox_file ",
                       " WHERE cox01=? AND cox02=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t810_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
   IF g_rec_b=0 THEN CALL g_cox.clear() END IF
 
   INPUT ARRAY g_cox WITHOUT DEFAULTS FROM s_cox.*
 
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
 
            OPEN t810_cl USING g_cow.cow01
            IF STATUS THEN
               CALL cl_err("OPEN t810_cl:", STATUS, 1)
               CLOSE t810_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t810_cl INTO g_cow.*     #鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_cow.cow01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t810_cl
              ROLLBACK WORK
              RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_cox_t.* = g_cox[l_ac].*  #BACKUP
                LET g_cox_o.* = g_cox[l_ac].*  #BACKUP
 
                OPEN t810_bcl USING g_cow.cow01,g_cox_t.cox02
                IF STATUS THEN
                   CALL cl_err("OPEN t810_bcl:", STATUS, 1)
                   CLOSE t810_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t810_bcl INTO g_cox[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cox_t.cox02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
           #NEXT FIELD cox02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
              INITIALIZE g_cox[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_cox[l_ac].* TO s_cox.*
              CALL g_cox.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO cox_file(cox01,cox02,cox03,cox04,cox05,
                                 cox06,cox07,cox08,
                                  #FUN-840202 --start--
                                  coxud01,coxud02,coxud03,
                                  coxud04,coxud05,coxud06,
                                  coxud07,coxud08,coxud09,
                                  coxud10,coxud11,coxud12,
                                  coxud13,coxud14,coxud15,coxplant,coxlegal) #FUN-980002 add coxplant,coxlegal
                                  #FUN-840202 --end--
            VALUES(g_cow.cow01,g_cox[l_ac].cox02,
                   g_cox[l_ac].cox03,g_cox[l_ac].cox04,
                   g_cox[l_ac].cox05,g_cox[l_ac].cox06,
                   g_cox[l_ac].cox07,g_cox[l_ac].cox08,
                                  #FUN-840202 --start--
                                  g_cox[l_ac].coxud01,
                                  g_cox[l_ac].coxud02,
                                  g_cox[l_ac].coxud03,
                                  g_cox[l_ac].coxud04,
                                  g_cox[l_ac].coxud05,
                                  g_cox[l_ac].coxud06,
                                  g_cox[l_ac].coxud07,
                                  g_cox[l_ac].coxud08,
                                  g_cox[l_ac].coxud09,
                                  g_cox[l_ac].coxud10,
                                  g_cox[l_ac].coxud11,
                                  g_cox[l_ac].coxud12,
                                  g_cox[l_ac].coxud13,
                                  g_cox[l_ac].coxud14,
                                  g_cox[l_ac].coxud15,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
                                  #FUN-840202 --end--
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cox[l_ac].cox02,SQLCA.sqlcode,0) #No.TQC-660045
               CALL cl_err3("ins","cox_file",g_cow.cow01,g_cox[l_ac].cox02,SQLCA.sqlcode,"","",1) #TQC-660045
               ROLLBACK WORK
               CANCEL INSERT
               LET g_cox[l_ac].* = g_cox_t.*
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
 
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_cox[l_ac].* TO NULL       #900423
            LET g_cox[l_ac].cox06 = 0              #Body default
            LET g_cox[l_ac].cox08 = 0              #Body default
            LET g_cox_t.* = g_cox[l_ac].*          #新輸入資料
            LET g_cox_o.* = g_cox[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cox02
 
        BEFORE FIELD cox02                        #default 序號
            IF g_cox[l_ac].cox02 IS NULL OR g_cox[l_ac].cox02 = 0 THEN
                SELECT max(cox02)+1 INTO g_cox[l_ac].cox02 FROM cox_file
                 WHERE cox01 = g_cow.cow01
                IF g_cox[l_ac].cox02 IS NULL THEN
                    LET g_cox[l_ac].cox02 = 1
                END IF
#               DISPLAY g_cox[l_ac].cox02 TO s_cox[l_sl].cox02 #No.FUN-570273預設值不可使用
            END IF
 
        AFTER FIELD cox02                        #check 序號是否重複
            IF NOT cl_null(g_cox[l_ac].cox02) THEN
               IF g_cox[l_ac].cox02 != g_cox_t.cox02 OR
                  g_cox_t.cox02 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM cox_file
                       WHERE cox01 = g_cow.cow01 AND
                             cox02 = g_cox[l_ac].cox02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cox[l_ac].cox02 = g_cox_t.cox02
                       NEXT FIELD cox02
                   END IF
               END IF
            END IF
 
        AFTER FIELD cox03                  #備案序號
            IF NOT cl_null(g_cox[l_ac].cox03) THEN
               IF g_cox_o.cox03 IS NULL OR
                 (g_cox[l_ac].cox03 !=g_cox_t.cox03 ) THEN
                  CALL t810_cox03('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cox[l_ac].cox03,g_errno,0)
                     LET g_cox[l_ac].cox03 = g_cox_o.cox03
                     LET g_cox[l_ac].cox04 = g_cox_o.cox04
                     DISPLAY g_cox[l_ac].cox03 TO s_cox[l_sl].cox03
                     DISPLAY g_cox[l_ac].cox04 TO s_cox[l_sl].cox04
                     NEXT FIELD cox03
                  END IF
               END IF
            END IF
 
        AFTER FIELD cox05                  #國別
            IF NOT cl_null(g_cox[l_ac].cox05) THEN
               IF g_cox_o.cox05 IS NULL OR
                 (g_cox[l_ac].cox05 !=g_cox_t.cox05 ) THEN
                  CALL t810_cox05('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cox[l_ac].cox05,g_errno,0)
                     LET g_cox[l_ac].cox07 = g_cox_o.cox05
                     LET g_cox[l_ac].cox06 = s_digqty(g_cox[l_ac].cox06,g_cox[l_ac].cox07)   #No.FUN-BB0086
                     DISPLAY BY NAME g_cox[l_ac].cox06   #No.FUN-BB0086
                     DISPLAY g_cox[l_ac].cox05 TO s_cox[l_sl].cox05
                     NEXT FIELD cox05
                  END IF
               END IF
            END IF
            
        #No.FUN-BB0086--add--begin--
        AFTER FIELD cox06
           LET g_cox[l_ac].cox06 = s_digqty(g_cox[l_ac].cox06,g_cox[l_ac].cox07)
           DISPLAY BY NAME g_cox[l_ac].cox06
        #No.FUN-BB0086--add--end--
        
        AFTER FIELD cox07                  #單位
            IF NOT cl_null(g_cox[l_ac].cox07) THEN
               IF g_cox_o.cox07 IS NULL OR
                 (g_cox[l_ac].cox05 !=g_cox_t.cox07 ) THEN
                  CALL t810_cox07('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cox[l_ac].cox07,g_errno,0)
                     LET g_cox[l_ac].cox07 = g_cox_o.cox07
                     DISPLAY g_cox[l_ac].cox07 TO s_cox[l_sl].cox07
                     NEXT FIELD cox07
                  END IF
               END IF
               #No.FUN-BB0086--add--begin--
               LET g_cox[l_ac].cox06 = s_digqty(g_cox[l_ac].cox06,g_cox[l_ac].cox07)
               DISPLAY BY NAME g_cox[l_ac].cox06
               #No.FUN-BB0086--add--end--
            END IF
 
        #No.FUN-840202 --start--
        AFTER FIELD coxud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD coxud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
        BEFORE DELETE                            #是否撤銷單身
            IF g_cox_t.cox02 > 0 AND g_cox_t.cox02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM cox_file
                    WHERE cox01 = g_cow.cow01 AND
                          cox02 = g_cox_t.cox02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cox_t.cox02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("del","cox_file",g_cow.cow01,g_cox_t.cox02,SQLCA.sqlcode,"","",1) #TQC-660045
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
               LET g_cox[l_ac].* = g_cox_t.*
               CLOSE t810_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cox[l_ac].cox02,-263,1)
               LET g_cox[l_ac].* = g_cox_t.*
            ELSE
               UPDATE cox_file SET
                 (cox02,cox03,cox04,cox05,cox06,cox07,cox08,
                   #FUN-840202 --start--
                  coxud01,coxud02,coxud03,
                  coxud04,coxud05,coxud06,
                  coxud07,coxud08,coxud09,
                  coxud10,coxud11,coxud12,
                  coxud13,coxud14,coxud15)
                   #FUN-840202 --end--
                =(g_cox[l_ac].cox02,g_cox[l_ac].cox03,
                  g_cox[l_ac].cox04,g_cox[l_ac].cox05,
                  g_cox[l_ac].cox06,g_cox[l_ac].cox07,
                  g_cox[l_ac].cox08,
                #FUN-840202 --start--
                  g_cox[l_ac].coxud01,
                  g_cox[l_ac].coxud02,
                  g_cox[l_ac].coxud03,
                  g_cox[l_ac].coxud04,
                  g_cox[l_ac].coxud05,
                  g_cox[l_ac].coxud06,
                  g_cox[l_ac].coxud07,
                  g_cox[l_ac].coxud08,
                  g_cox[l_ac].coxud09,
                  g_cox[l_ac].coxud10,
                  g_cox[l_ac].coxud11,
                  g_cox[l_ac].coxud12,
                  g_cox[l_ac].coxud13,
                  g_cox[l_ac].coxud14,
                  g_cox[l_ac].coxud15)
                 #FUN-840202 --end--
                WHERE cox01=g_cow.cow01 AND cox02=g_cox_t.cox02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_cox[l_ac].cox02,SQLCA.sqlcode,0) #No.TQC-660045
                   CALL cl_err3("upd","cox_file",g_cow.cow01,g_cox_t.cox02,SQLCA.sqlcode,"","",1) #TQC-660045
                   LET g_cox[l_ac].* = g_cox_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   LET g_cow.cowmodu=g_user
                   LET g_cow.cowdate=g_today
                   UPDATE cow_file SET cow_file.* = g_cow.*
                    WHERE cow01 = g_cow01_t
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_cox[l_ac].* = g_cox_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cox.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end-- 
               END IF
               CLOSE t810_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add
          #LET g_cox_t.* = g_cox[l_ac].*          # 900423
            CLOSE t810_bcl
            COMMIT WORK
 
           #CALL g_cox.deleteElement(g_rec_b+1)   #FUN-D30034 Mark
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cox02) AND l_ac > 1 THEN
                LET g_cox[l_ac].* = g_cox[l_ac-1].*
                NEXT FIELD cox02
            END IF
        ON ACTION controls                       # No.FUN-6B0033
           CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
        ON ACTION CONTROLZ
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(cox03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_cot"
                    LET g_qryparam.default1 = g_cox[l_ac].cox03
         #           LET g_qryparam.where = "cos08=g_cow.cow03 "   #TQC-960257 
                    LET g_qryparam.arg1 = g_cow.cow03               #TQC-960257 
                    CALL cl_create_qry() RETURNING g_cox[l_ac].cox03
#                    CALL FGL_DIALOG_SETBUFFER( g_cox[l_ac].cox03 )
                    DISPLAY BY NAME g_cox[l_ac].cox03
                    CALL t810_cox03('a')
                    NEXT FIELD cox03
               WHEN INFIELD(cox05)  #國別
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_geb"
                    LET g_qryparam.default1 = g_cox[l_ac].cox05
                    CALL cl_create_qry() RETURNING g_cox[l_ac].cox05
#                    CALL FGL_DIALOG_SETBUFFER( g_cox[l_ac].cox05 )
                    DISPLAY BY NAME g_cox[l_ac].cox05
                    NEXT FIELD cox05
               WHEN INFIELD(cox07) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_cox[l_ac].cox07
                    CALL cl_create_qry() RETURNING g_cox[l_ac].cox07
#                    CALL FGL_DIALOG_SETBUFFER( g_cox[l_ac].cox07 )
                    DISPLAY BY NAME g_cox[l_ac].cox07
                    NEXT FIELD cox07
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
    LET g_cow.cowmodu = g_user
    LET g_cow.cowdate = g_today
    UPDATE cow_file SET cowmodu = g_cow.cowmodu,cowdate = g_cow.cowdate
     WHERE cow01 = g_cow.cow01
    DISPLAY BY NAME g_cow.cowmodu,g_cow.cowdate
    #FUN-5B0043-end
 
    CLOSE t810_bcl
    COMMIT WORK
    CALL t810_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t810_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM cow_file WHERE cow01 = g_cow.cow01
         INITIALIZE g_cow.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t810_delall()
    SELECT COUNT(*) INTO g_cnt FROM cox_file
        WHERE cox01 = g_cow.cow01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否撤銷單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM cow_file WHERE cow01 = g_cow.cow01
    END IF
END FUNCTION
 
FUNCTION t810_cow10()  #國別
   DEFINE l_gebacti  LIKE geb_file.gebacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gebacti INTO l_gebacti FROM geb_file
                WHERE geb01 = g_cow.cow10
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-152'
                            LET l_gebacti = NULL
         WHEN l_gebacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t810_cow11()  #幣別
    DEFINE l_aziacti LIKE azi_file.aziacti
 
    LET g_errno = " "
    SELECT aziacti INTO l_aziacti FROM azi_file
     WHERE azi01 = g_cow.cow11
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                   LET l_aziacti = NULL
         WHEN l_aziacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t810_cow03()  #備案編號
    DEFINE l_cosacti LIKE cos_file.cosacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT cosacti INTO l_cosacti
      FROM cos_file WHERE cos08 = g_cow.cow03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-024'
                                   LET l_cosacti = NULL
         WHEN l_cosacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t810_cow04()  #合同編號
    DEFINE l_cnt     LIKE type_file.num5,          #No.FUN-680069 SMALLINT
           p_cmd     LIKE type_file.chr1           #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt
      FROM coc_file WHERE coc04 = g_cow.cow04 AND cocacti='Y'
    IF l_cnt=0 THEN  LET g_errno = 'aco-026' END IF
END FUNCTION
 
FUNCTION t810_cox03(p_cmd)  #備案序號
   DEFINE l_cot06    LIKE cos_file.cos02,
          l_n        LIKE type_file.num5,          #No.FUN-680069 SMALLINT
          p_cmd      LIKE type_file.chr1           #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  LET l_n = 0
  SELECT COUNT(*) INTO l_n FROM cox_file
   WHERE cox01=g_cow.cow01 AND cox03=g_cox[l_ac].cox03
  IF l_n > 0  THEN
     LET g_errno='-239'
  ELSE
     SELECT cot06 INTO l_cot06 FROM cot_file,cos_file
      WHERE cos08=g_cow.cow03
        AND cot01=cos01
        AND cot02=g_cox[l_ac].cox03
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno='aco-024'
                                      LET l_cot06=NULL
            OTHERWISE                 LET g_errno=SQLCA.SQLCODE USING '-------'
       END CASE
 
  END IF
 
  IF cl_null(g_errno) OR p_cmd='d' THEN
     LET g_cox[l_ac].cox04=l_cot06
     DISPLAY l_cot06 TO s_cox[l_sl].cox04
  END IF
END FUNCTION
 
FUNCTION t810_cox07(p_cmd)  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti,
          l_price    LIKE cox_file.cox07,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
   WHERE gfe01 = g_cox[l_ac].cox07
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t810_cox05(p_cmd)  #產國
   DEFINE l_gebacti  LIKE geb_file.gebacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gebacti INTO l_gebacti FROM geb_file
                WHERE geb01 = g_cox[l_ac].cox05
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-152'
                            LET l_gebacti = NULL
         WHEN l_gebacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t810_b_askkey()
DEFINE
    l_wc2        LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(200)
 
 # 螢幕上取單身條件
    CONSTRUCT l_wc2 ON cox02,cox03,cox04,cox05,cox06,cox07,cox08
            FROM s_cox[1].cox02,s_cox[1].cox03,s_cox[1].cox04,
                 s_cox[1].cox05,s_cox[1].cox06,s_cox[1].cox07,
                 s_cox[1].cox08
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
    CALL t810_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t810_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2      LIKE type_file.chr1000    #No.FUN-680069 VARCHAR(200)
 
    LET g_sql =
        "SELECT cox02,cox03,cox04,cox05,cox06,cox07,cox08,",
        #No.FUN-840202 --start--
        "       coxud01,coxud02,coxud03,coxud04,coxud05,",
        "       coxud06,coxud07,coxud08,coxud09,coxud10,",
        "       coxud11,coxud12,coxud13,coxud14,coxud15", 
        #No.FUN-840202 ---end---
        " FROM cox_file ",
    #No.FUN-8B0123---Begin
        " WHERE cox01 ='",g_cow.cow01,"'"                  # AND ",#單頭
    #         p_wc2 CLIPPED," ORDER BY 1" CLIPPED          #單身
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1" 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE t810_pb FROM g_sql
    DECLARE cox_cs                       #SCROLL CURSOR
        CURSOR FOR t810_pb
 
    CALL g_cox.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH cox_cs INTO g_cox[g_cnt].*   #單身 ARRAY 填充
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
 
    CALL g_cox.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t810_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cox TO s_cox.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t810_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t810_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t810_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t810_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t810_fetch('L')
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
 
         CALL cl_set_field_pic("","","","","",g_cow.cowacti)
 
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
FUNCTION t810_copy()
DEFINE
    l_n             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    l_newno         LIKE cow_file.cow01,
    l_oldno         LIKE cow_file.cow01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cow.cow01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    DISPLAY "" AT 1,1
    CALL cl_getmsg('copy',g_lang) RETURNING g_msg
    DISPLAY g_msg AT 2,1
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
 
    INPUT l_newno FROM cow01
 
        AFTER FIELD cow01
#           IF l_newno[1,3] IS NULL THEN
            IF l_newno[1,g_doc_len] IS NULL THEN   #No.FUN-560002
                NEXT FIELD cow01
            END IF
            SELECT COUNT(*) INTO g_cnt FROM cow_file WHERE cow01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD cow01
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
        DISPLAY BY NAME g_cow.cow01
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM cow_file         #單頭複製
        WHERE cow01=g_cow.cow01
        INTO TEMP y
    UPDATE y
        SET cow01=l_newno,    #新的鍵值
            cowuser=g_user,   #資料所有者
            cowgrup=g_grup,   #資料所有者所屬群
            cowmodu=NULL,     #資料更改日期
            cowdate=g_today,  #資料建立日期
            cowacti='Y'       #有效資料
    INSERT INTO cow_file
        SELECT * FROM y
 
    DROP TABLE x
    SELECT * FROM cox_file         #單身複製
     WHERE cox01=g_cow.cow01 INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_cow.cow01,SQLCA.sqlcode,0) #No.TQC-660045
       CALL cl_err3("ins","x",g_cow.cow01,"",SQLCA.sqlcode,"","",1) #TQC-660045
       RETURN
    END IF
    UPDATE x SET cox01=l_newno
 
    INSERT INTO cox_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cow.cow01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("ins","cox_file",g_cow.cow01,"",SQLCA.sqlcode,"","",1) #TQC-660045
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_cow.cow01
     SELECT cow_file.* INTO g_cow.* FROM cow_file WHERE cow01 = l_newno
     CALL t810_u()
     CALL t810_b()
     SELECT cow_file.* INTO g_cow.* FROM cow_file WHERE cow01 = l_oldno
     CALL t810_show()
END FUNCTION
}
