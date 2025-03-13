# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acot520.4gl
# Descriptions...: 手冊核銷報關單維護作業
# Date & Author..: 05/01/12 By Carrier
# Modify.........: No.MOD-530224 By Carrier 沒有單身資料,表示只做手冊核銷,沒有轉入的動作
# Modify.........: No.FUN-550036 05/05/25 By Trisy 單據編號加大
# Modify ........: No.FUN-560060 05/06/15 By vivien 單據編號加大返工				
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-630014 06/03/07 By Carol 流程訊息通知功能
# MOdify.........: No.TQC-660045 06/06/09 By hellen  cl_err --> cl_err3
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
# Modify.........: No.FUN-840202 08/05/09 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0084 11/12/14 By lixh1 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 12/12/21 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cno             RECORD LIKE cno_file.*,  #單頭
    g_cno_t           RECORD LIKE cno_file.*,  #單頭(舊值)
    g_cno_o           RECORD LIKE cno_file.*,  #單頭(舊值)
    g_cno01_t         LIKE cno_file.cno01,     #單頭 (舊值)
    g_cno20_t         LIKE cno_file.cno20,     #
    g_cno03           LIKE cno_file.cno03,
    g_cno04           LIKE cno_file.cno04,
    g_t1              LIKE oay_file.oayslip,   #No.FUN-550036   #No.FUN-680069 VARCHAR(05)
    g_cnp             DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        cnp012        LIKE cnp_file.cnp012,    #項號
        cnp02         LIKE cnp_file.cnp02,     #序號
        cnp03         LIKE cnp_file.cnp03,     #商品編號
        cob02         LIKE cob_file.cob02,     #品名規格
        cnp05         LIKE cnp_file.cnp05,     #數量
        cnp06         LIKE cnp_file.cnp06,     #單位
        cnp09         LIKE cnp_file.cnp09,     #單位
        cnp10         LIKE cnp_file.cnp10,     #毛重
        cnp14         LIKE cnp_file.cnp14,     #淨重
        cnp11         LIKE cnp_file.cnp11,     #國別
        cnp07         LIKE cnp_file.cnp07,     #單價
        cnp08         LIKE cnp_file.cnp08      #金額
        #FUN-840202 --start---
        ,cnpud01      LIKE cnp_file.cnpud01,
        cnpud02       LIKE cnp_file.cnpud02,
        cnpud03       LIKE cnp_file.cnpud03,
        cnpud04       LIKE cnp_file.cnpud04,
        cnpud05       LIKE cnp_file.cnpud05,
        cnpud06       LIKE cnp_file.cnpud06,
        cnpud07       LIKE cnp_file.cnpud07,
        cnpud08       LIKE cnp_file.cnpud08,
        cnpud09       LIKE cnp_file.cnpud09,
        cnpud10       LIKE cnp_file.cnpud10,
        cnpud11       LIKE cnp_file.cnpud11,
        cnpud12       LIKE cnp_file.cnpud12,
        cnpud13       LIKE cnp_file.cnpud13,
        cnpud14       LIKE cnp_file.cnpud14,
        cnpud15       LIKE cnp_file.cnpud15
        #FUN-840202 --end--
                      END RECORD,
    g_cnp_t           RECORD                   #程式變數 (舊值)
        cnp012        LIKE cnp_file.cnp012,    #項號
        cnp02         LIKE cnp_file.cnp02,     #序號
        cnp03         LIKE cnp_file.cnp03,     #商品編號
        cob02         LIKE cob_file.cob02,     #品名規格
        cnp05         LIKE cnp_file.cnp05,     #數量
        cnp06         LIKE cnp_file.cnp06,     #單位
        cnp09         LIKE cnp_file.cnp09,     #單位
        cnp10         LIKE cnp_file.cnp10,     #毛重
        cnp14         LIKE cnp_file.cnp14,     #淨重
        cnp11         LIKE cnp_file.cnp11,     #國別
        cnp07         LIKE cnp_file.cnp07,     #單價
        cnp08         LIKE cnp_file.cnp08      #金額
        #FUN-840202 --start---
        ,cnpud01      LIKE cnp_file.cnpud01,
        cnpud02       LIKE cnp_file.cnpud02,
        cnpud03       LIKE cnp_file.cnpud03,
        cnpud04       LIKE cnp_file.cnpud04,
        cnpud05       LIKE cnp_file.cnpud05,
        cnpud06       LIKE cnp_file.cnpud06,
        cnpud07       LIKE cnp_file.cnpud07,
        cnpud08       LIKE cnp_file.cnpud08,
        cnpud09       LIKE cnp_file.cnpud09,
        cnpud10       LIKE cnp_file.cnpud10,
        cnpud11       LIKE cnp_file.cnpud11,
        cnpud12       LIKE cnp_file.cnpud12,
        cnpud13       LIKE cnp_file.cnpud13,
        cnpud14       LIKE cnp_file.cnpud14,
        cnpud15       LIKE cnp_file.cnpud15
        #FUN-840202 --end--
                      END RECORD,
    g_cnp_o           RECORD                   #程式變數 (舊值)
        cnp012        LIKE cnp_file.cnp012,    #項號
        cnp02         LIKE cnp_file.cnp02,     #序號
        cnp03         LIKE cnp_file.cnp03,     #商品編號
        cob02         LIKE cob_file.cob02,     #品名規格
        cnp05         LIKE cnp_file.cnp05,     #數量
        cnp06         LIKE cnp_file.cnp06,     #單位
        cnp09         LIKE cnp_file.cnp09,     #單位
        cnp10         LIKE cnp_file.cnp10,     #毛重
        cnp14         LIKE cnp_file.cnp14,     #淨重
        cnp11         LIKE cnp_file.cnp11,     #國別
        cnp07         LIKE cnp_file.cnp07,     #單價
        cnp08         LIKE cnp_file.cnp08      #金額
        #FUN-840202 --start---
        ,cnpud01      LIKE cnp_file.cnpud01,
        cnpud02       LIKE cnp_file.cnpud02,
        cnpud03       LIKE cnp_file.cnpud03,
        cnpud04       LIKE cnp_file.cnpud04,
        cnpud05       LIKE cnp_file.cnpud05,
        cnpud06       LIKE cnp_file.cnpud06,
        cnpud07       LIKE cnp_file.cnpud07,
        cnpud08       LIKE cnp_file.cnpud08,
        cnpud09       LIKE cnp_file.cnpud09,
        cnpud10       LIKE cnp_file.cnpud10,
        cnpud11       LIKE cnp_file.cnpud11,
        cnpud12       LIKE cnp_file.cnpud12,
        cnpud13       LIKE cnp_file.cnpud13,
        cnpud14       LIKE cnp_file.cnpud14,
        cnpud15       LIKE cnp_file.cnpud15
        #FUN-840202 --end--
                      END RECORD,
    g_argv1           LIKE cnp_file.cnp01,     # 詢價單號
    g_argv2           STRING,                  #No.FUN-680069  STRING    #FUN-630014 指定執行的功能
    g_wc,g_wc2,g_sql  STRING,  #No.FUN-580092 HCN           #No.FUN-680069
    g_rec_b           LIKE type_file.num5,                  #單身筆數        #No.FUN-680069 SMALLINT
    l_ac              LIKE type_file.num5,                  #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
    g_coc01           LIKE coc_file.coc01,        #轉出單號
    t_coc01           LIKE coc_file.coc01,        #轉入單號
    g_qty             LIKE type_file.num5         #No.FUN-680069 SMALLINT
 
DEFINE g_forupd_sql   STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE g_before_input_done  LIKE type_file.num5                  #No.FUN-680069 SMALLINT
DEFINE g_chr          LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_i            LIKE type_file.num5          #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE mi_no_ask      LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE g_void         LIKE type_file.chr1          #CHI-C80041

#主程式開始
MAIN
DEFINE
    p_row,p_col       LIKE type_file.num5          #No.FUN-680069 SMALLINT
#       l_time    LIKE type_file.chr8                #No.FUN-6A0063
 
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
 
    LET g_forupd_sql = "SELECT * FROM cno_file WHERE cno01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t520_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 1 LET p_col = 2
 
    OPEN WINDOW t520_w AT p_row,p_col WITH FORM "aco/42f/acot520"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_cno03 = '2' #材料
    LET g_cno04 = '5' #核銷
 
   #FUN-630014 --start--
   # 先以g_argv2判斷直接執行哪種功能
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t520_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t520_a()
            END IF
         OTHERWISE
            CALL t520_q()
      END CASE
   END IF
   #FUN-630014 ---end---
 
    CALL t520_menu()
    CLOSE WINDOW t520_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION t520_cs()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01     #No.FUN-580031  HCN
DEFINE  l_type          LIKE type_file.chr1     #No.FUN-680069  VARCHAR(1)
 
    CLEAR FORM                                  #清除畫面
    CALL g_cnp.clear()
 
#FUN-630014-start 
  IF NOT cl_null(g_argv1) THEN
     LET g_wc = "cno01='",g_argv1 CLIPPED,"'"
     LET g_wc2= ' 1=1'
  ELSE
#FUN-630014-end
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
 
   INITIALIZE g_cno.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                              # 螢幕上取單頭條件
        cno01,cno03,cno031, cno04,cno02,cno05,cno06,cno07,
        cno08,cno09,cno10,  cno20,cno18,cno11,cno12,cno13,
        cno14,cno17,cnoconf,cno15,cno16,cno19,
        cnouser,cnogrup,cnomodu,cnodate,cnoacti
        #FUN-840202   ---start---
        ,cnoud01,cnoud02,cnoud03,cnoud04,cnoud05,
        cnoud06,cnoud07,cnoud08,cnoud09,cnoud10,
        cnoud11,cnoud12,cnoud13,cnoud14,cnoud15
        #FUN-840202    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP                        # 沿用所有欄位
           CASE
              WHEN INFIELD(cno01) #單別
                 #CALL q_coy(TRUE,TRUE,g_cno.cno01,'19',g_sys) #TQC-670008
                 CALL q_coy(TRUE,TRUE,g_cno.cno01,'19','ACO')  #TQC-670008
                      RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cno01
                 NEXT FIELD cno01
              WHEN INFIELD(cno05)
                 IF g_cno.cno04 = '2' THEN     #轉廠資料查詢
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_cnm"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cno05
                 END IF
                 IF g_cno.cno04 = '4' THEN     #內銷資料查詢
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_cnu"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cno05
                 END IF
                 NEXT FIELD cno05
              WHEN INFIELD(cno08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_cnb"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cno08
                 NEXT FIELD cno08
              WHEN INFIELD(cno10)
                 CALL q_coc2(TRUE,TRUE,g_cno.cno10,NULL,NULL,'1',NULL,NULL)
                      RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cno10
                 NEXT FIELD cno10
              WHEN INFIELD(cno11)
                 CALL q_coc2(TRUE,TRUE,g_cno.cno11,NULL,NULL,'1',NULL,NULL)
                      RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cno11
                 NEXT FIELD cno11
              WHEN INFIELD(cno20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_cna"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cno20
                 NEXT FIELD cno20
              WHEN INFIELD(cno13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_geb"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cno13
                 NEXT FIELD cno13
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
 
    CONSTRUCT g_wc2 ON cnp012,cnp02,cnp03,cnp05,     #螢幕上取單身條件
                       cnp06, cnp11,cnp09,cnp10,cnp14,cnp07,cnp08
         FROM s_cnp[1].cnp012,s_cnp[1].cnp02,s_cnp[1].cnp03,
              s_cnp[1].cnp05, s_cnp[1].cnp06,s_cnp[1].cnp11,
              s_cnp[1].cnp09, s_cnp[1].cnp10,s_cnp[1].cnp14,
              s_cnp[1].cnp07, s_cnp[1].cnp08
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(cnp02)              #備案序號
                    CALL q_coe(TRUE,TRUE,g_coc01,g_cnp[1].cnp02) RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cnp02
                    NEXT FIELD cnp02
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
  END IF  #FUN-630014 add
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND cnouser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND cnogrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET g_wc = g_wc clipped," AND cnogrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnouser', 'cnogrup')
    #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT cno01 FROM cno_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND cno03 = '",g_cno03,"'",
                   "   AND cno04 = '",g_cno04,"'",
                   " ORDER BY cno01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cno01 ",
                   "  FROM cno_file, cnp_file ",
                   " WHERE cno01 = cnp01",
                   "   AND cno03 = '",g_cno03,"'",
                   "   AND cno04 = '",g_cno04,"'",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY cno01"
    END IF
 
    PREPARE t520_prepare FROM g_sql
    DECLARE t520_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t520_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM cno_file WHERE ",g_wc CLIPPED,
                  "   AND cno03 = '",g_cno03,"'",
                  "   AND cno04 = '",g_cno04,"'"
    ELSE
        LET g_sql="SELECT COUNT(*) FROM cno_file,cnp_file WHERE ",
                  "cnp01=cno01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  "   AND cno03 = '",g_cno03,"'",
                  "   AND cno04 = '",g_cno04,"'"
    END IF
    PREPARE t520_precount FROM g_sql
    DECLARE t520_count CURSOR FOR t520_precount
END FUNCTION
 
FUNCTION t520_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069 VARCHAR(100) 
 
   WHILE TRUE
      CALL t520_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t520_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t520_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t520_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t520_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t520_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t520_b()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cnp),'','')
             END IF
         #--
 
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t520_y()
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t520_z()
            END IF
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_cno.cno01 IS NOT NULL THEN
                 LET g_doc.column1 = "cno01"
                 LET g_doc.value1 = g_cno.cno01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t520_v()
               IF g_cno.cnoconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_cno.cnoconf,"","","",g_void,g_cno.cnoacti)
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t520_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550036        #No.FUN-680069 SMALLINT
    CLEAR FORM
    CALL g_cnp.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_cno.* LIKE cno_file.*             #DEFAULT 設置
    LET g_cno01_t = NULL
    LET g_cno_t.* = g_cno.*
    LET g_cno_o.* = g_cno.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cno.cno03  = g_cno03
        LET g_cno.cno04  = g_cno04
        LET g_cno.cno15  = 0
        LET g_cno.cno16  = 0
        LET g_cno.cno19  = 0
        LET g_cno.cno02  = g_today
        LET g_cno.cnoconf= 'N'
        LET g_cno.cnouser= g_user
        LET g_data_plant = g_plant #FUN-980030
        LET g_cno.cnogrup= g_grup
        LET g_cno.cnodate= g_today
        LET g_cno.cnoacti= 'Y'          #資料有效
        LET g_cno.cnoplant = g_plant  #FUN-980002
        LET g_cno.cnolegal = g_legal  #FUN-980002
 
        BEGIN WORK
        CALL t520_i("a")                #輸入單頭
        IF INT_FLAG THEN                #用戶不玩了
            INITIALIZE g_cno.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cno.cno01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
#No.FUN-550036 --start--
      IF cl_null(g_cno.cno01[g_no_sp,g_no_ep]) THEN              #自動編號
      CALL s_auto_assign_no("aco",g_cno.cno01,g_cno.cno02,"19","cno_file","cno01","","","")
        RETURNING li_result,g_cno.cno01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
#       IF cl_null(g_cno.cno01[5,10]) THEN              #自動編號
#          CALL s_acoauno(g_cno.cno01,g_cno.cno02,'19')
#               RETURNING g_i,g_cno.cno01
#          IF g_i THEN CONTINUE WHILE END IF
#No.FUN-550036 ---end---
          DISPLAY BY NAME g_cno.cno01
        END IF
        LET g_cno.cnooriu = g_user      #No.FUN-980030 10/01/04
        LET g_cno.cnoorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cno_file VALUES (g_cno.*)
#       LET g_t1 = g_cno.cno01[1,3]           #備份上一筆單別
        LET g_t1 = s_get_doc_no(g_cno.cno01)  #No.FUN-550036
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
#           CALL cl_err(g_cno.cno01,SQLCA.sqlcode,1) #No.TQC-660045
            CALL cl_err3("ins","cno_file",g_cno.cno01,"",SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        COMMIT WORK
        CALL cl_flow_notify(g_cno.cno01,'I')
        SELECT cno01 INTO g_cno.cno01 FROM cno_file
         WHERE cno01 = g_cno.cno01
        LET g_cno01_t = g_cno.cno01        #保留舊值
        LET g_cno20_t = g_cno.cno20
        LET g_cno_t.* = g_cno.*
        LET g_cno_o.* = g_cno.*
        CALL g_cnp.clear()
 
        LET g_rec_b=0
        CALL t520_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t520_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cno.cno01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_cno.* FROM cno_file WHERE cno01=g_cno.cno01
    IF g_cno.cnoacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cno.cno01,'mfg1000',0)
        RETURN
    END IF
    IF g_cno.cnoconf ='X' THEN RETURN END IF #CHI-C80041
    IF g_cno.cnoconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_cno.cno01,'axm-101',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cno01_t = g_cno.cno01
    LET g_cno20_t = g_cno.cno20
    BEGIN WORK
 
    OPEN t520_cl USING g_cno.cno01
    IF STATUS THEN
       CALL cl_err("OPEN t520_cl:", STATUS, 1)
       CLOSE t520_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t520_cl INTO g_cno.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cno.cno01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t520_cl
        RETURN
    END IF
    CALL t520_show()
    WHILE TRUE
        LET g_cno01_t = g_cno.cno01
        LET g_cno_o.* = g_cno.*
        LET g_cno.cnomodu=g_user
        LET g_cno.cnodate=g_today
        CALL t520_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cno.*=g_cno_t.*
            CALL t520_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_cno.cno01 != g_cno01_t THEN            # 更改單號
            UPDATE cnp_file SET cnp01 = g_cno.cno01
             WHERE cnp01 = g_cno01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('cnp',SQLCA.sqlcode,0)  #No.TQC-660045
                CALL cl_err3("upd","cnp_file",g_cno01_t,"",SQLCA.sqlcode,"","cnp",1) #TQC-660045
                CONTINUE WHILE
            END IF
        END IF
        IF g_cno.cno20 != g_cno20_t THEN            # 更改海關編號
            UPDATE cnp_file SET cnp15 = g_cno.cno20
             WHERE cnp01 = g_cno01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('cnp',SQLCA.sqlcode,0)  #No.TQC-660045
                CALL cl_err3("upd","cnp_file",g_cno01_t,"",SQLCA.sqlcode,"","cnp",1) #TQC-660045
                CONTINUE WHILE
            END IF
        END IF
        UPDATE cno_file SET cno_file.* = g_cno.*
         WHERE cno01 = g_cno01_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cno.cno01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cno_file",g_cno01_t,"",SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t520_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cno.cno01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t520_i(p_cmd)
DEFINE li_result   LIKE type_file.num5         #No.FUN-550036        #No.FUN-680069 SMALLINT
DEFINE
    l_n	           LIKE type_file.num5,        #No.FUN-680069 SMALLINT
    p_cmd          LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
    l_type         LIKE type_file.chr1         #No.FUN-680069  VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
 
    INPUT BY NAME
        g_cno.cno01,g_cno.cno03,g_cno.cno031,g_cno.cno04,
        g_cno.cno02,g_cno.cno05,g_cno.cno06, g_cno.cno07,
        g_cno.cno08,g_cno.cno09,g_cno.cno10, g_cno.cno18,g_cno.cno11,
        g_cno.cno12,g_cno.cno13,g_cno.cno14, g_cno.cno15,g_cno.cno17,
        g_cno.cno16,g_cno.cno19,g_cno.cnoconf, g_cno.cnouser,
        g_cno.cnogrup,g_cno.cnomodu,g_cno.cnodate,g_cno.cnoacti
        #FUN-840202     ---start---
        ,g_cno.cnoud01,g_cno.cnoud02,g_cno.cnoud03,g_cno.cnoud04,
        g_cno.cnoud05,g_cno.cnoud06,g_cno.cnoud07,g_cno.cnoud08,
        g_cno.cnoud09,g_cno.cnoud10,g_cno.cnoud11,g_cno.cnoud12,
        g_cno.cnoud13,g_cno.cnoud14,g_cno.cnoud15 
        #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t520_set_entry(p_cmd)
            CALL t520_set_no_entry(p_cmd)
            CALL t520_set_no_required()
            CALL t520_set_required()
            LET g_before_input_done = TRUE
            CALL t520_cno03()
            CALL t520_cno04()
         #No.FUN-550036 --start--
         CALL cl_set_docno_format("cno01")
         CALL cl_set_docno_format("cno05")
         CALL cl_set_docno_format("cno06")
         CALL cl_set_docno_format("cno14")
         #No.FUN-550036 ---end---
 
        AFTER FIELD cno01
         #No.FUN-550036 --start--
          IF g_cno.cno01 != g_cno01_t OR g_cno01_t IS NULL THEN
            CALL s_check_no("aco",g_cno.cno01,g_cno01_t,"19","cno_file","cno01","")
            RETURNING li_result,g_cno.cno01
            DISPLAY BY NAME g_cno.cno01
            IF (NOT li_result) THEN
               LET g_cno.cno01=g_cno_o.cno01
               NEXT FIELD cno01
            END IF
#           IF NOT cl_null(g_cno.cno01) THEN
#              LET g_t1=g_cno.cno01[1,3]
#              CALL s_acoslip(g_t1,'19',g_sys)               #檢查單別
#              IF NOT cl_null(g_errno) THEN                  #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 LET g_cno.cno01=g_cno_o.cno01
#                 NEXT FIELD cno01
#              END IF
#              IF p_cmd = 'a'  THEN
#          IF g_cno.cno01[1,3] IS NOT NULL AND        #並且單號空白時,
#             cl_null(g_cno.cno01[5,10]) THEN         #請用戶自行輸入
#             IF g_coy.coyauno = 'N' THEN             #新增並要不自動編號
#                NEXT FIELD cno01
#             ELSE				     #要不, 則單號不用
#                NEXT FIELD cno03		     #輸入
# 	             END IF
#          END IF
#          IF g_cno.cno01[1,3] IS NOT NULL AND	     #並且單號空白時,
#             NOT cl_null(g_cno.cno01[5,10]) THEN     #請用戶自行輸入
#                    IF NOT cl_chk_data_continue(g_cno.cno01[5,10]) THEN
#                       CALL cl_err('','9056',0)
#                       NEXT FIELD cno01
#                    END IF
#                 END IF
#              END IF
#              IF g_cno.cno01 != g_cno01_t OR g_cno01_t IS NULL THEN
#                 SELECT count(*) INTO l_n FROM cno_file
#                  WHERE cno01 = g_cno.cno01
#                 IF l_n > 0 THEN   #單據編號重複
#                    CALL cl_err(g_cno.cno01,-239,0)
#                    LET g_cno.cno01 = g_cno01_t
#                    DISPLAY BY NAME g_cno.cno01
#                    NEXT FIELD cno01
#                 END IF
#              END IF
#No.FUN-550036 ---end---
            END IF
 
        BEFORE FIELD cno031
            CALL t520_set_no_required()
 
        AFTER FIELD cno031
            IF NOT cl_null(g_cno.cno031) THEN
               IF g_cno.cno031 NOT MATCHES '[12]' THEN
                  CALL cl_err(g_cno.cno031,'aco-184',0)
                  NEXT FIELD cno031
               ELSE
                  CALL t520_cno031()
               END IF
            END IF
            CALL t520_set_required()
 
{
        AFTER FIELD cno06
#stop
            IF NOT cl_null(g_cno.cno06) THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM cno_file
                WHERE cno01 <> g_cno.cno01
                  AND cno06 = g_cno.cno06
               IF l_n > 0 THEN
                  CALL cl_err(g_cno.cno06,'***',0)
                  NEXT FIELD cno06
               END IF
            END IF
}
 
        AFTER FIELD cno08
            IF NOT cl_null(g_cno.cno08) THEN
               CALL t520_cno08('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD cno08
                  LET g_cno.cno08 = g_cno_t.cno08
                  DISPLAY BY NAME g_cno.cno08
               END IF
            END IF
 
        AFTER FIELD cno10
            IF NOT cl_null(g_cno.cno10) THEN
               CALL t520_cno10('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_cno.cno10 = g_cno_t.cno10
                  DISPLAY BY NAME g_cno.cno10
                  NEXT FIELD cno10
               END IF
               #核銷轉出的時候,只能轉出一次,所以檢查此本手冊是否有過核銷轉出
               IF g_cno.cno031 = '1' THEN  #核銷轉出
                  IF p_cmd = 'a' OR
                    (p_cmd = 'u' AND g_cno.cno10 <> g_cno_t.cno10) THEN
                    SELECT COUNT(*) INTO g_i FROM cno_file
                     WHERE cno03 = '2' AND cno031= '1'
                       AND cno04 = '5' AND cno10 = g_cno.cno10
                       AND cnoconf='Y'
                    IF g_i > 0 THEN
                       CALL cl_err(g_cno.cno10,'aco-185',0)
                       NEXT FIELD cno10
                    END IF
                  END IF
               END IF
            END IF
 
        AFTER FIELD cno11
            IF NOT cl_null(g_cno.cno11) THEN
               #轉出時.此手冊不能為已核銷的手冊
               IF g_cno.cno031 = '1' THEN
                  CALL t520_cno11('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_cno.cno11 = g_cno_t.cno11
                     DISPLAY BY NAME g_cno.cno11
                     NEXT FIELD cno11
                  END IF
               END IF
               #轉入時.此手冊一定是已核銷的手冊
               IF g_cno.cno031 = '2' THEN
                  SELECT cno01 INTO g_cno.cno18 FROM cno_file
                   WHERE cno03 = '2' AND cno031 = '1'
                     AND cno04 = '5' AND cnoconf='Y'
                     AND cno10 = g_cno.cno11
                  IF SQLCA.sqlcode OR cl_null(g_cno.cno18) THEN
                     CALL cl_err(g_cno.cno11,'aco-187',0) 
                     NEXT FIELD cno11
                  END IF
                  DISPLAY BY NAME g_cno.cno18
               END IF
            END IF
 
        AFTER FIELD cno13
            IF NOT cl_null(g_cno.cno13) THEN
               CALL t520_cno13('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD cno13
                  LET g_cno.cno13 = g_cno_t.cno13
                  DISPLAY BY NAME g_cno.cno13
               END IF
            END IF
 
        AFTER FIELD cno15
            IF cl_null(g_cno.cno15) THEN
               LET g_cno.cno15 = 0
               DISPLAY BY NAME g_cno.cno15
            END IF
            IF g_cno.cno15 <= 0 THEN NEXT FIELD cno15 END IF
 
        AFTER FIELD cno16
            IF cl_null(g_cno.cno16) THEN
               LET g_cno.cno16 = 0
               DISPLAY BY NAME g_cno.cno16
            END IF
            IF g_cno.cno16 <= 0 THEN NEXT FIELD cno16 END IF
 
        AFTER FIELD cno19
            IF cl_null(g_cno.cno19) THEN
               LET g_cno.cno19 = 0
               DISPLAY BY NAME g_cno.cno19
            END IF
            IF g_cno.cno19 <= 0 THEN NEXT FIELD cno19 END IF
 
        #FUN-840202     ---start---
        AFTER FIELD cnoud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnoud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF g_cno.cno031 NOT MATCHES '[12]' THEN   #核銷時的狀態只能是進口/出口
               CALL cl_err(g_cno.cno01,'aco-184',0) NEXT FIELD cno031
            END IF
            #轉出和轉入的手冊不能為同一本
            IF NOT cl_null(g_cno.cno10) AND NOT cl_null(g_cno.cno11) THEN
               IF g_cno.cno10 = g_cno.cno11 THEN
                  CALL cl_err(g_cno.cno10,'aco-186',0)
                  NEXT FIELD cno10
               END IF
            END IF
            CALL t520_cno10_cno11()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD cno11
            END IF
 
        ON ACTION CONTROLP                        # 沿用所有欄位
           CASE
              WHEN INFIELD(cno01) #單別
                 #CALL q_coy(FALSE,FALSE,g_cno.cno01,'19',g_sys)  #TQC-670008
                 CALL q_coy(FALSE,FALSE,g_cno.cno01,'19','ACO')   #TQC-670008
                      RETURNING g_cno.cno01
                 DISPLAY BY NAME g_cno.cno01
                 NEXT FIELD cno01
              WHEN INFIELD(cno08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_cnb"
                 LET g_qryparam.default1 = g_cno.cno08
                 CALL cl_create_qry() RETURNING g_cno.cno08
                 DISPLAY BY NAME g_cno.cno08
                 NEXT FIELD cno08
              WHEN INFIELD(cno10)
                 CALL q_coc2(FALSE,TRUE,g_cno.cno10,NULL,NULL,'1',NULL,NULL)
                      RETURNING g_cno.cno10,g_msg
                 DISPLAY BY NAME g_cno.cno10
                 NEXT FIELD cno10
              WHEN INFIELD(cno11)
                 CALL q_coc2(FALSE,TRUE,g_cno.cno11,NULL,NULL,'1',NULL,NULL)
                      RETURNING g_cno.cno11,g_msg
                 DISPLAY BY NAME g_cno.cno11
                 NEXT FIELD cno11
              WHEN INFIELD(cno13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_geb"
                 LET g_qryparam.default1 = g_cno.cno13
                 CALL cl_create_qry() RETURNING g_cno.cno13
                 DISPLAY BY NAME g_cno.cno13
                 NEXT FIELD cno13
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
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
END FUNCTION
 
FUNCTION t520_cno03()       #型態
    DEFINE l_chr     LIKE zaa_file.zaa08       #No.FUN-680069  VARCHAR(06)
    CASE g_cno.cno03
         WHEN '1'    LET l_chr = cl_getmsg('aco-047',g_lang)   #成品
         WHEN '2'    LET l_chr = cl_getmsg('aco-048',g_lang)   #材料
         WHEN '3'    LET l_chr = cl_getmsg('aco-072',g_lang)   #半成品
    END CASE
    DISPLAY l_chr TO FORMONLY.d1
END FUNCTION
 
FUNCTION t520_cno031()       #狀況
    DEFINE l_chr     LIKE zaa_file.zaa08       #No.FUN-680069 VARCHAR(4)
    CASE g_cno.cno031
         WHEN '1'    LET l_chr = cl_getmsg('aco-039',g_lang)   #出口
         WHEN '2'    LET l_chr = cl_getmsg('aco-040',g_lang)   #進口
         WHEN '3'    LET l_chr = cl_getmsg('aco-071',g_lang)   #報廢
    END CASE
    DISPLAY l_chr TO FORMONLY.d2
END FUNCTION
 
FUNCTION t520_cno04()       #類別
    DEFINE l_chr     LIKE zaa_file.zaa08       #No.FUN-680069 VARCHAR(4)
    CASE g_cno.cno04
         WHEN '0'    LET l_chr = cl_getmsg('aco-071',g_lang)  #報廢
         WHEN '1'    LET l_chr = cl_getmsg('aco-041',g_lang)  #報關
         WHEN '2'    LET l_chr = cl_getmsg('aco-042',g_lang)  #轉廠
         WHEN '3'    LET l_chr = cl_getmsg('aco-043',g_lang)  #退港
         WHEN '4'    LET l_chr = cl_getmsg('aco-044',g_lang)  #內銷
         WHEN '5'    LET l_chr = cl_getmsg('aco-181',g_lang)  #核銷
         WHEN '6'    LET l_chr = cl_getmsg('aco-182',g_lang)  #內購
    END CASE
    DISPLAY l_chr TO FORMONLY.d3
END FUNCTION
 
FUNCTION t520_cno08(p_cmd)  #交易對象
    DEFINE l_cnb06   LIKE cnb_file.cnb06,
           l_cnbacti LIKE cnb_file.cnbacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT cnb06,cnbacti INTO l_cnb06,l_cnbacti
      FROM cnb_file WHERE cnb01 = g_cno.cno08
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-025'
                                   LET l_cnb06 = NULL
         WHEN l_cnbacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_cno.cno09) THEN
       LET g_cno.cno09 = l_cnb06
       DISPLAY BY NAME g_cno.cno09
    END IF
END FUNCTION
 
FUNCTION t520_cno10(p_cmd)  #手冊編號
    DEFINE l_coc02   LIKE coc_file.coc02,
           l_coc05   LIKE coc_file.coc05,
           l_coc07   LIKE coc_file.coc07,
           l_coc10   LIKE coc_file.coc10,
           l_cocacti LIKE coc_file.cocacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
 
    SELECT coc01,coc02,coc05,coc07,coc10,cocacti
      INTO g_coc01,l_coc02,l_coc05,l_coc07,l_coc10,l_cocacti
      FROM coc_file
     WHERE coc03 = g_cno.cno10
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-005'
                                   LET l_coc02 = NULL
                                   LET l_coc05 = NULL
                                   LET l_coc07 = NULL
         WHEN l_cocacti='N'        LET g_errno = '9028'
         WHEN l_coc05 < g_today    LET g_errno = 'aco-056'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF NOT cl_null(l_coc07) AND l_coc07 < g_today THEN
       LET g_errno='aco-057'
    END IF
    IF p_cmd = 'a' THEN
       LET g_cno.cno20 = l_coc10
       DISPLAY BY NAME g_cno.cno20
    END IF
    DISPLAY l_coc02 TO FORMONLY.coc02
END FUNCTION
 
FUNCTION t520_cno11(p_cmd)  #轉入手冊編號
    DEFINE l_coc05   LIKE coc_file.coc05,
           l_coc07   LIKE coc_file.coc07,
           l_coc10   LIKE coc_file.coc10,
           l_cocacti LIKE coc_file.cocacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
 
    SELECT coc05,coc07,cocacti
      INTO l_coc05,l_coc07,l_cocacti
      FROM coc_file
     WHERE coc03 = g_cno.cno11
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-005'
                                   LET l_coc05 = NULL
                                   LET l_coc07 = NULL
         WHEN l_cocacti='N'        LET g_errno = '9028'
         WHEN l_coc05 < g_today    LET g_errno = 'aco-056'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF NOT cl_null(l_coc07) AND l_coc07 < g_today THEN
       LET g_errno='aco-057'
    END IF
END FUNCTION
 
FUNCTION t520_cno13(p_cmd)  #貿易國別
    DEFINE l_gebacti LIKE geb_file.gebacti,
           l_geb02   LIKE geb_file.geb02,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT geb02,gebacti INTO l_geb02,l_gebacti
      FROM geb_file WHERE geb01 = g_cno.cno13
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-152'
                                   LET l_geb02 = NULL
         WHEN l_gebacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd='d' THEN
       DISPLAY l_geb02 TO FORMONLY.geb02
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t520_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cno.* TO NULL               #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_cnp.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t520_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_cno.* TO NULL
        RETURN
    END IF
    OPEN t520_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_cno.* TO NULL
    ELSE
       OPEN t520_count
       FETCH t520_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t520_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t520_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t520_cs INTO g_cno.cno01
        WHEN 'P' FETCH PREVIOUS t520_cs INTO g_cno.cno01
        WHEN 'F' FETCH FIRST    t520_cs INTO g_cno.cno01
        WHEN 'L' FETCH LAST     t520_cs INTO g_cno.cno01
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
         FETCH ABSOLUTE g_jump t520_cs INTO g_cno.cno01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cno.cno01,SQLCA.sqlcode,0)
       INITIALIZE g_cno.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_cno.* FROM cno_file WHERE cno01 = g_cno.cno01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_cno.cno01,SQLCA.sqlcode,0) #No.TQC-660045
       CALL cl_err3("sel","cno_file",g_cno.cno01,"",SQLCA.sqlcode,"","",1) #TQC-660045
       INITIALIZE g_cno.* TO NULL
       RETURN
    END IF
 
    CALL t520_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t520_show()
    LET g_cno_t.* = g_cno.*                #保存單頭舊值
    LET g_cno_o.* = g_cno.*                #保存單頭舊值
    DISPLAY BY NAME
        g_cno.cno01,g_cno.cno03,g_cno.cno031,g_cno.cno04,
        g_cno.cno02,g_cno.cno05,g_cno.cno06,g_cno.cno07,
        g_cno.cno08,g_cno.cno09,g_cno.cno10,g_cno.cno11,
        g_cno.cno12,g_cno.cno13,g_cno.cno14,g_cno.cno15,
        g_cno.cno16,g_cno.cno17,g_cno.cno18,g_cno.cno19,
        g_cno.cno20,g_cno.cnoconf,g_cno.cnouser,
        g_cno.cnogrup,g_cno.cnomodu,g_cno.cnodate,g_cno.cnoacti
        #FUN-840202     ---start---
        ,g_cno.cnoud01,g_cno.cnoud02,g_cno.cnoud03,g_cno.cnoud04,
        g_cno.cnoud05,g_cno.cnoud06,g_cno.cnoud07,g_cno.cnoud08,
        g_cno.cnoud09,g_cno.cnoud10,g_cno.cnoud11,g_cno.cnoud12,
        g_cno.cnoud13,g_cno.cnoud14,g_cno.cnoud15 
        #FUN-840202     ----end----
 
    #CALL cl_set_field_pic(g_cno.cnoconf,"","","","",g_cno.cnoacti)  #CHI-C80041
    IF g_cno.cnoconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cno.cnoconf,"","","",g_void,g_cno.cnoacti)   #CHI-C80041
    CALL t520_cno03()
    CALL t520_cno031()
    CALL t520_cno04()
    CALL t520_cno10('d')
    CALL t520_cno13('d')
    CALL t520_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t520_show_tot()
 
    SELECT SUM(cnp09),SUM(cnp10),SUM(cnp14)
      INTO g_cno.cno15,g_cno.cno16,g_cno.cno19
      FROM cnp_file
     WHERE cnp01 = g_cno.cno01
    UPDATE cno_file SET cno15 = g_cno.cno15,
                        cno16 = g_cno.cno16,
                        cno19 = g_cno.cno19
     WHERE cno01 = g_cno.cno01
    IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd cno16/cno19',STATUS,0)  #No.TQC-660045
       CALL cl_err3("upd","cno_file",g_cno.cno01,"",STATUS,"","upd cno16/cno19",1) #TQC-660045
       LET g_success = 'N' RETURN
    END IF
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    DISPLAY BY NAME g_cno.cno15,g_cno.cno16,g_cno.cno19
END FUNCTION
 
FUNCTION t520_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cno.cno01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t520_cl USING g_cno.cno01
    IF STATUS THEN
       CALL cl_err("OPEN t520_cl:", STATUS, 1)
       CLOSE t520_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t520_cl INTO g_cno.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cno.cno01,SQLCA.sqlcode,0)          #資料被他人LOCK
       ROLLBACK WORK
       RETURN
    END IF
    IF g_cno.cnoconf='Y' THEN RETURN END IF
 
    CALL t520_show()
    IF cl_exp(0,0,g_cno.cnoacti) THEN                   #審核一下
       LET g_chr=g_cno.cnoacti
       IF g_cno.cnoacti='Y' THEN
          LET g_cno.cnoacti='N'
       ELSE
          LET g_cno.cnoacti='Y'
       END IF
       UPDATE cno_file                    #更改有效碼
           SET cnoacti=g_cno.cnoacti
           WHERE cno01=g_cno.cno01
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_cno.cno01,SQLCA.sqlcode,0) #No.TQC-660045
          CALL cl_err3("upd","cno_file",g_cno.cno01,"",SQLCA.sqlcode,"","",1) #TQC-660045
          LET g_cno.cnoacti=g_chr
       END IF
       DISPLAY BY NAME g_cno.cnoacti
    END IF
    CLOSE t520_cl
    COMMIT WORK
 
    #CALL cl_set_field_pic(g_cno.cnoconf,"","","","",g_cno.cnoacti) #CHI-C80041
    IF g_cno.cnoconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cno.cnoconf,"","","",g_void,g_cno.cnoacti)   #CHI-C80041
    CALL cl_flow_notify(g_cno.cno01,'V')
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t520_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cno.cno01 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    SELECT * INTO g_cno.* FROM cno_file WHERE cno01=g_cno.cno01
    IF g_cno.cnoacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_cno.cno01,'mfg1000',0)
       RETURN
    END IF
    IF g_cno.cnoconf ='X' THEN RETURN END IF #CHI-C80041
    IF g_cno.cnoconf ='Y' THEN    #檢查資料是否為審核
       CALL cl_err(g_cno.cno01,'axm-101',0)
       RETURN
    END IF
 
    BEGIN WORK
    OPEN t520_cl USING g_cno.cno01
    IF STATUS THEN
       CALL cl_err("OPEN t520_cl:", STATUS, 1)
       CLOSE t520_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t520_cl INTO g_cno.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cno.cno01,SQLCA.sqlcode,0)          #資料被他人LOCK
       ROLLBACK WORK
       RETURN
    END IF
    CALL t520_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cno01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cno.cno01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM cno_file WHERE cno01 = g_cno.cno01
       DELETE FROM cnp_file WHERE cnp01 = g_cno.cno01
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980002 add azoplant,azolegal
       VALUES ('acot520',g_user,g_today,g_msg,g_cno.cno01,'delete',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
       CLEAR FORM
       CALL g_cnp.clear()
 
       OPEN t520_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE t520_cs
          CLOSE t520_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH t520_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t520_cs
          CLOSE t520_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t520_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t520_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t520_fetch('/')
       END IF
    END IF
    CLOSE t520_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cno.cno01,'D')
END FUNCTION
 
#單身
FUNCTION t520_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680069 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_cno.cno01 IS NULL THEN RETURN END IF
    SELECT * INTO g_cno.* FROM cno_file WHERE cno01=g_cno.cno01
    IF g_cno.cnoacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_cno.cno01,'mfg1000',0)
       RETURN
    END IF
    IF g_cno.cnoconf ='X' THEN RETURN END IF #CHI-C80041
    IF g_cno.cnoconf='Y' THEN RETURN END IF
    SELECT COUNT(*) INTO l_cnt FROM cnp_file
     WHERE cnp01 = g_cno.cno01
    IF l_cnt = 0 THEN
       CALL t520_g_b()                 #自動生成單身
    END IF
 
    LET g_success='Y'
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT cnp012,cnp02,cnp03,'',cnp05,cnp06,cnp09,cnp10, ",
      "        cnp14,cnp11,cnp07,cnp08 ",
      "   FROM cnp_file ",
      "  WHERE cnp01 = ? ",
      "    AND cnp012= ? ",
      " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t520_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_cnp WITHOUT DEFAULTS FROM s_cnp.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t520_cl USING g_cno.cno01
            IF STATUS THEN
               CALL cl_err("OPEN t520_cl:", STATUS, 1)
               CLOSE t520_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t520_cl INTO g_cno.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_cno.cno01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t520_cl
              RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_cnp_t.* = g_cnp[l_ac].*  #BACKUP
               LET g_cnp_o.* = g_cnp[l_ac].*  #BACKUP
               OPEN t520_bcl USING g_cno.cno01,g_cnp_t.cnp012
               IF STATUS THEN
                  CALL cl_err("OPEN t520_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t520_bcl INTO g_cnp[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_cnp_t.cnp012,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL t520_cob02()
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               INITIALIZE g_cnp[l_ac].* TO NULL  #重要欄位空白,無效
               DISPLAY g_cnp[l_ac].* TO s_cnp.*
               CALL g_cnp.deleteElement(g_rec_b+1)
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF cl_null(g_cnp[l_ac].cnp02) THEN
               INITIALIZE g_cnp[l_ac].* TO NULL
               NEXT FIELD cnp012
            END IF
            INSERT INTO cnp_file(cnp01,cnp012,cnp02,cnp03,
                                 cnp05,cnp06,cnp07,cnp08,cnp09,
                                 cnp10,cnp11,cnp14,cnp15
                                #No.FUN-840202 --start--
                                ,cnpud01,cnpud02,cnpud03,cnpud04,cnpud05,
                                cnpud06,cnpud07,cnpud08,cnpud09,cnpud10,
                                #cnpud11,cnpud12,cnpud13,cnpud14,cnpud15) #FUN-980002
                                #No.FUN-840202 ---end---
                                cnpud11,cnpud12,cnpud13,cnpud14,cnpud15,  #FUN-980002
                                cnpplant,cnplegal) #FUN-980002
            VALUES(g_cno.cno01,g_cnp[l_ac].cnp012,g_cnp[l_ac].cnp02,
                   g_cnp[l_ac].cnp03,g_cnp[l_ac].cnp05,
                   g_cnp[l_ac].cnp06,g_cnp[l_ac].cnp07,
                   g_cnp[l_ac].cnp08,g_cnp[l_ac].cnp09,
                   g_cnp[l_ac].cnp10,g_cnp[l_ac].cnp11,
                   g_cnp[l_ac].cnp14,g_cno.cno20
                   #No.FUN-840202 --start--
                   ,g_cnp[l_ac].cnpud01,g_cnp[l_ac].cnpud02,g_cnp[l_ac].cnpud03,
                   g_cnp[l_ac].cnpud04,g_cnp[l_ac].cnpud05,g_cnp[l_ac].cnpud06,
                   g_cnp[l_ac].cnpud07,g_cnp[l_ac].cnpud08,g_cnp[l_ac].cnpud09,
                   g_cnp[l_ac].cnpud10,g_cnp[l_ac].cnpud11,g_cnp[l_ac].cnpud12,
                   #g_cnp[l_ac].cnpud13,g_cnp[l_ac].cnpud14,g_cnp[l_ac].cnpud15) #FUN-980002
                   #No.FUN-840202 ---end---
                   g_cnp[l_ac].cnpud13,g_cnp[l_ac].cnpud14,g_cnp[l_ac].cnpud15,  #FUN-980002
                   g_plant,g_legal) #FUN-980002
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cnp[l_ac].cnp012,SQLCA.sqlcode,0) #No.TQC-660045
               CALL cl_err3("ins","cnp_file",g_cno.cno01,g_cnp[l_ac].cnp012,SQLCA.sqlcode,"","",1) #TQC-660045
               ROLLBACK WORK
               CANCEL INSERT
               LET g_cnp[l_ac].* = g_cnp_t.*
            ELSE
               CALL t520_show_tot()
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
            INITIALIZE g_cnp[l_ac].* TO NULL       #900423
            LET g_cnp_t.* = g_cnp[l_ac].*          #新輸入資料
            LET g_cnp_o.* = g_cnp[l_ac].*          #新輸入資料
            LET g_cnp[l_ac].cnp05 = 0
            LET g_cnp[l_ac].cnp07 = 0
            LET g_cnp[l_ac].cnp08 = 0
            LET g_cnp[l_ac].cnp09 = 0
            LET g_cnp[l_ac].cnp10 = 0
            LET g_cnp[l_ac].cnp14 = 0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnp012
 
        BEFORE FIELD cnp012                        #default 序號
            IF g_cnp[l_ac].cnp012 IS NULL OR g_cnp[l_ac].cnp012 = 0 THEN
               SELECT max(cnp012)+1
                 INTO g_cnp[l_ac].cnp012
                 FROM cnp_file
                WHERE cnp01 = g_cno.cno01
               IF g_cnp[l_ac].cnp012 IS NULL THEN
                  LET g_cnp[l_ac].cnp012 = 1
               END IF
            END IF
 
        AFTER FIELD cnp012                        #check 序號是否重複
            IF NOT g_cnp[l_ac].cnp012 IS NULL THEN
               IF g_cnp[l_ac].cnp012 != g_cnp_t.cnp012 OR
                  g_cnp_t.cnp012 IS NULL THEN
                  SELECT COUNT(*) INTO l_n
                    FROM cnp_file
                   WHERE cnp01 = g_cno.cno01 AND cnp012 = g_cnp[l_ac].cnp012
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_cnp[l_ac].cnp012 = g_cnp_t.cnp012
                     NEXT FIELD cnp012
                  END IF
               END IF
            END IF
 
        AFTER FIELD cnp02                  #備案序號
            IF NOT cl_null(g_cnp[l_ac].cnp02) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_cnp[l_ac].cnp02 != g_cnp_o.cnp02 ) THEN
                  CALL t520_cnp02(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cnp[l_ac].cnp02,g_errno,0)
                     LET g_cnp[l_ac].cnp02 = g_cnp_o.cnp02
                     NEXT FIELD cnp02
                  END IF
                  #備案序號不可重復
                  SELECT COUNT(*) INTO l_n FROM cnp_file
                   WHERE cnp01 = g_cno.cno01
                     AND cnp02 = g_cnp[l_ac].cnp02
                  IF l_n > 0 THEN
                     CALL cl_err('','aco-045',0)
                     NEXT FIELD cnp02
                  END IF
                  SELECT COUNT(*) INTO l_n FROM cno_file,cnp_file
                   WHERE cno01 = cnp01
                     AND cnp01 != g_cno.cno01
                     AND cno10 = g_cno.cno10
                     AND cnp02 = g_cnp[l_ac].cnp02
                     AND cnoconf = 'N'
                  IF l_n > 0 THEN
                     CALL cl_err('','anm-220',0)
                  END IF
               END IF
            END IF
            LET g_cnp_o.cnp02 = g_cnp[l_ac].cnp02
 
        AFTER FIELD cnp05                        #數量
            CALL t520_cnp02('d')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD cnp05
            END IF
            LET g_cnp[l_ac].cnp08 = g_cnp[l_ac].cnp05 * g_cnp[l_ac].cnp07
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_cnp[l_ac].cnp08
            #------MOD-5A0095 END------------
        #No.FUN-840202 --start--
        AFTER FIELD cnpud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnpud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_cnp_t.cnp012 > 0 AND
               g_cnp_t.cnp012 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM cnp_file
                WHERE cnp01  = g_cno.cno01
                  AND cnp012 = g_cnp_t.cnp012
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_cnp_t.cnp012,SQLCA.sqlcode,0) #No.TQC-660045
                  CALL cl_err3("del","cnp_file",g_cno.cno01,g_cnp_t.cnp012,SQLCA.sqlcode,"","",1) #TQC-660045
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
            CALL t520_show_tot()
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cnp[l_ac].* = g_cnp_t.*
               CLOSE t520_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cnp[l_ac].cnp012,-263,1)
               LET g_cnp[l_ac].* = g_cnp_t.*
            ELSE
               UPDATE cnp_file SET cnp012=g_cnp[l_ac].cnp012,
                                   cnp02 =g_cnp[l_ac].cnp02,
                                   cnp03 =g_cnp[l_ac].cnp03,
                                   cnp05 =g_cnp[l_ac].cnp05,
                                   cnp06 =g_cnp[l_ac].cnp06,
                                   cnp07 =g_cnp[l_ac].cnp07,
                                   cnp08 =g_cnp[l_ac].cnp08,
                                   cnp09 =g_cnp[l_ac].cnp09,
                                   cnp10 =g_cnp[l_ac].cnp10,
                                   cnp11 =g_cnp[l_ac].cnp11,
                                   cnp14 =g_cnp[l_ac].cnp14
                                   #No.FUN-840202 --start--
                                   ,cnpud01 = g_cnp[l_ac].cnpud01,
                                   cnpud02 = g_cnp[l_ac].cnpud02,
                                   cnpud03 = g_cnp[l_ac].cnpud03,
                                   cnpud04 = g_cnp[l_ac].cnpud04,
                                   cnpud05 = g_cnp[l_ac].cnpud05,
                                   cnpud06 = g_cnp[l_ac].cnpud06,
                                   cnpud07 = g_cnp[l_ac].cnpud07,
                                   cnpud08 = g_cnp[l_ac].cnpud08,
                                   cnpud09 = g_cnp[l_ac].cnpud09,
                                   cnpud10 = g_cnp[l_ac].cnpud10,
                                   cnpud11 = g_cnp[l_ac].cnpud11,
                                   cnpud12 = g_cnp[l_ac].cnpud12,
                                   cnpud13 = g_cnp[l_ac].cnpud13,
                                   cnpud14 = g_cnp[l_ac].cnpud14,
                                   cnpud15 = g_cnp[l_ac].cnpud15
                                   #No.FUN-840202 ---end---
                WHERE cnp01 =g_cno.cno01
                  AND cnp012=g_cnp_t.cnp012
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_cnp[l_ac].cnp012,SQLCA.sqlcode,0) #No.TQC-660045
                  CALL cl_err3("upd","cnp_file",g_cno.cno01,g_cnp_t.cnp012,SQLCA.sqlcode,"","",1) #TQC-660045
                  LET g_cnp[l_ac].* = g_cnp_t.*
               ELSE
                  CALL t520_show_tot()
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
                  LET g_cnp[l_ac].* = g_cnp_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cnp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t520_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add
            #LET g_cnp_t.* = g_cnp[l_ac].*          # 900423
            CLOSE t520_bcl
            COMMIT WORK
           #CALL g_cnp.deleteElement(g_rec_b+1)     #FUN-D30034 Mark
 
 
        ON ACTION CONTROLN
           CALL t520_b_askkey()
           EXIT INPUT
        ON ACTION controls                       # No.FUN-6B0033
           CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(cnp012) AND l_ac > 1 THEN
              LET g_cnp[l_ac].* = g_cnp[l_ac-1].*
              NEXT FIELD cnp012
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(cnp02)              #備案序號
                 CALL q_coe(FALSE,TRUE,g_coc01,g_cnp[l_ac].cnp02)
                      RETURNING g_coc01,g_cnp[l_ac].cnp02
                 NEXT FIELD cnp02
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
    LET g_cno.cnomodu = g_user
    LET g_cno.cnodate = g_today
    UPDATE cno_file SET cnomodu = g_cno.cnomodu,cnodate = g_cno.cnodate
     WHERE cno01 = g_cno.cno01
    DISPLAY BY NAME g_cno.cnomodu,g_cno.cnodate
    #FUN-5B0043-end
 
    CLOSE t520_bcl
    COMMIT WORK
    CALL t520_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t520_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_cno.cno01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM cno_file ",
                  "  WHERE cno01 LIKE '",l_slip,"%' ",
                  "    AND cno01 > '",g_cno.cno01,"'"
      PREPARE t520_pb1 FROM l_sql 
      EXECUTE t520_pb1 INTO l_cnt       
      
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
         CALL t520_v()
         IF g_cno.cnoconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_cno.cnoconf,"","","",g_void,g_cno.cnoacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM cno_file WHERE cno01 = g_cno.cno01
         INITIALIZE g_cno.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t520_delall()
#   SELECT COUNT(*) INTO g_cnt FROM cnp_file
#    WHERE cnp01 = g_cno.cno01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否撤銷單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM cno_file WHERE cno01 = g_cno.cno01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t520_cnp02(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_coe     RECORD LIKE coe_file.*,
           l_coc03   LIKE coc_file.coc03,
           l_qty     LIKE cnp_file.cnp05,
           l_qty2    LIKE cnp_file.cnp05
 
    LET g_errno = ' '
    IF g_cno.cno031 = '1' THEN
       LET l_coc03=g_cno.cno10
    ELSE
       LET l_coc03=g_cno.cno11
    END IF
    SELECT coe_file.* INTO l_coe.* FROM coe_file,coc_file
     WHERE coe01 = coc01 AND coe02=g_cnp[l_ac].cnp02
       AND coc03 = l_coc03
    IF SQLCA.sqlcode THEN
       LET g_errno = 'aco-026'
       RETURN
    END IF
    #核銷轉入的時候檢查此商品料號是否在轉出的手冊中有申報
    IF g_cno.cno031 = '2' THEN
       SELECT * FROM coe_file,coc_file
        WHERE coc03 = g_cno.cno11
          AND coc01 = coe01
          AND coe03 = l_coe.coe03
       IF SQLCA.sqlcode THEN
          LET g_errno='aco-188'
          RETURN
       END IF
    END IF
    #核銷轉出的時候檢查此商品料號是否在轉入的手冊中有申報
    IF g_cno.cno031 = '1' THEN
       IF NOT cl_null(g_cno.cno11) THEN
          SELECT coe_file.* FROM coe_file,coc_file
           WHERE coc03 = g_cno.cno11
             AND coc01 = coe01
             AND coe03 = l_coe.coe03
          IF SQLCA.sqlcode THEN
             LET g_errno='aco-189'
             RETURN
          END IF
       END IF
    END IF
    CALL s_chkcoe1(g_cno.cno11,l_coe.coe02) RETURNING l_qty
    IF cl_null(l_qty) THEN LET l_qty = 0 END IF
    IF p_cmd = 'a' THEN
       LET g_cnp[l_ac].cnp03 = l_coe.coe03
       LET g_cnp[l_ac].cnp05 = l_qty
       LET g_cnp[l_ac].cnp06 = l_coe.coe06
       LET g_cnp[l_ac].cnp05 = s_digqty(g_cnp[l_ac].cnp05,g_cnp[l_ac].cnp06)   #FUN-BB0084
       LET g_cnp[l_ac].cnp07 = l_coe.coe07
       LET g_cnp[l_ac].cnp11 = l_coe.coe11
       LET g_cnp[l_ac].cnp08 = g_cnp[l_ac].cnp05 * g_cnp[l_ac].cnp07
       #------MOD-5A0095 START----------
       DISPLAY BY NAME g_cnp[l_ac].cnp03
       DISPLAY BY NAME g_cnp[l_ac].cnp05
       DISPLAY BY NAME g_cnp[l_ac].cnp06
       DISPLAY BY NAME g_cnp[l_ac].cnp07
       DISPLAY BY NAME g_cnp[l_ac].cnp11
       DISPLAY BY NAME g_cnp[l_ac].cnp08
       #------MOD-5A0095 END------------
    END IF
    CALL t520_cob02()
 
    IF g_cnp[l_ac].cnp05 > l_qty THEN LET g_errno = 'aco-046' END IF
    IF g_cno.cno031 = '2' THEN
       CALL s_coeqty(g_cno.cno10,g_cnp[l_ac].cnp02) RETURNING l_qty2
       IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF
       IF l_qty2 > l_qty THEN
          LET g_errno='aco-046'
       END IF
    END IF
END FUNCTION
 
FUNCTION t520_cob02()
    SELECT cob02 INTO g_cnp[l_ac].cob02
     FROM cob_file WHERE cob01=g_cnp[l_ac].cnp03
END FUNCTION
 
FUNCTION t520_b_askkey()
DEFINE
    l_wc2     LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(200) 
 
    CONSTRUCT l_wc2 ON cnp012,cnp02,cnp03,cnp05,     #螢幕上取單身條件
                       cnp09, cnp11,cnp06,cnp10,
                       cnp14, cnp07,cnp08
                       #No.FUN-840202 --start--
                       ,cnpud01,cnpud02,cnpud03,cnpud04,cnpud05,
                       cnpud06,cnpud07,cnpud08,cnpud09,cnpud10,
                       cnpud11,cnpud12,cnpud13,cnpud14,cnpud15
                       #No.FUN-840202 ---end---
         FROM s_cnp[1].cnp012,s_cnp[1].cnp02,s_cnp[1].cnp03,
              s_cnp[1].cnp05, s_cnp[1].cnp09,s_cnp[1].cnp11,
              s_cnp[1].cnp06, s_cnp[1].cnp10,s_cnp[1].cnp14,
              s_cnp[1].cnp07, s_cnp[1].cnp08
              #No.FUN-840202 --start--
              ,s_cnp[1].cnpud01,s_cnp[1].cnpud02,s_cnp[1].cnpud03,s_cnp[1].cnpud04,s_cnp[1].cnpud05,
              s_cnp[1].cnpud06,s_cnp[1].cnpud07,s_cnp[1].cnpud08,s_cnp[1].cnpud09,s_cnp[1].cnpud10,
              s_cnp[1].cnpud11,s_cnp[1].cnpud12,s_cnp[1].cnpud13,s_cnp[1].cnpud14,s_cnp[1].cnpud15
              #No.FUN-840202 ---end---
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(cnp02)              #備案序號
                    CALL q_coe(TRUE,TRUE,g_coc01,g_cnp[1].cnp02)
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cnp02
                    NEXT FIELD cnp02
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t520_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t520_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       LIKE type_file.chr1000       #No.FUN-680069  VARCHAR(200) 
 
    LET g_sql =
        "SELECT cnp012,cnp02,cnp03,cob02,cnp05,cnp06,cnp09,cnp10,",
        "       cnp14, cnp11,cnp07,cnp08 ",
        #No.FUN-840202 --start--
        "       ,cnpud01,cnpud02,cnpud03,cnpud04,cnpud05,",
        "       cnpud06,cnpud07,cnpud08,cnpud09,cnpud10,",
        "       cnpud11,cnpud12,cnpud13,cnpud14,cnpud15", 
        #No.FUN-840202 ---end---
        "  FROM cnp_file LEFT OUTER JOIN cob_file ON cnp_file.cnp03 = cob_file.cob01",
        " WHERE cnp01 ='",g_cno.cno01,"' AND ",  #單頭
    #No.FUN-8B0123---Begin 
        "       cnp03 = cob_file.cob01 "         #AND ", p_wc2 CLIPPED, #單身
    #   " ORDER BY cnp012,cnp02"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1,2 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE t520_pb FROM g_sql
    DECLARE cnp_cs                       #SCROLL CURSOR
        CURSOR FOR t520_pb
 
    CALL g_cnp.clear()
    LET g_cnt = 1
    FOREACH cnp_cs INTO g_cnp[g_cnt].*   #單身 ARRAY 填充
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
 
    CALL g_cnp.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t520_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cnp TO s_cnp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL t520_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t520_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t520_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t520_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t520_fetch('L')
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
         #CALL cl_set_field_pic(g_cno.cnoconf,"","","","",g_cno.cnoacti)  #CHI-C80041
         IF g_cno.cnoconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_cno.cnoconf,"","","",g_void,g_cno.cnoacti)   #CHI-C80041
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
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
      ON ACTION controls                       # No.FUN-6B0033
       CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t520_y()
   IF g_cno.cno01 IS NULL THEN RETURN END IF
#CHI-C30107 -------- add ---------- begin
   IF g_cno.cnoconf ='X' THEN RETURN END IF #CHI-C80041
   IF g_cno.cnoconf='Y' THEN RETURN END IF
   IF g_cno.cnoacti='N' THEN CALL cl_err('','mfg1000',0) RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 -------- add ---------- end
   SELECT * INTO g_cno.* FROM cno_file WHERE cno01=g_cno.cno01
   IF g_cno.cnoconf ='X' THEN RETURN END IF #CHI-C80041
   IF g_cno.cnoconf='Y' THEN RETURN END IF
   IF g_cno.cnoacti='N' THEN CALL cl_err('','mfg1000',0) RETURN END IF
   #no.7377
    #MOD-530224  --begin
   #SELECT COUNT(*) INTO g_cnt FROM cnp_file
   # WHERE cnp01 = g_cno.cno01
   #IF g_cnt = 0 THEN
   #   CALL cl_err('','arm-034',1) RETURN
   #END IF
    ##MOD-530224  --end
   #no.7377(end)
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
 
   #找出原始的申請編號
   SELECT coc01 INTO g_coc01 FROM coc_file
    WHERE coc03 = g_cno.cno10 AND cocacti !='N'
   IF cl_null(g_coc01) THEN
#     CALL cl_err('sel coc01:','aco-005',1)  #No.TQC-660045
      CALL cl_err3("sel","coc_file",g_cno.cno10,"","aco-005","","sel coc01:",1) #TQC-660045
      RETURN
   END IF
   SELECT coc01 INTO t_coc01 FROM coc_file
    WHERE coc03 = g_cno.cno11 AND cocacti !='N'
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t520_cl USING g_cno.cno01
   IF STATUS THEN
      CALL cl_err("OPEN t520_cl:", STATUS, 1)
      CLOSE t520_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t520_cl INTO g_cno.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_cno.cno01,SQLCA.sqlcode,0)
       CLOSE t520_cl
       ROLLBACK WORK
       RETURN
   END IF
   UPDATE cno_file SET cnoconf='Y' WHERE cno01 = g_cno.cno01
   IF STATUS THEN
#     CALL cl_err('upd cofconf',STATUS,0)  #No.TQC-660045
      CALL cl_err3("upd","cno_file",g_cno.cno01,"",STATUS,"","upd cofconf",1) #TQC-660045
      LET g_success='N'
   END IF
   CALL t520_yz('0',g_cno.cno01,g_cno.cno03,g_cno.cno031,g_cno.cno04,'y')
   #自動生成核銷進口單據
   IF g_cno.cno031 = '1' AND NOT cl_null(g_cno.cno11) THEN
      CALL t520_gen()
      IF g_success = 'Y' THEN
         SELECT cno18 INTO g_cno.cno18 FROM cno_file
          WHERE cno01 = g_cno.cno01
         DISPLAY BY NAME g_cno.cno18
      END IF
   END IF
   #coc07(核銷日期)更新#
   IF g_cno.cno031 = '1' THEN
      UPDATE coc_file SET coc07=g_cno.cno02 WHERE coc03 = g_cno.cno10
      IF SQLCA.sqlcode THEN
#        CALL cl_err('update coc07',SQLCA.sqlcode,0) #No.TQC-660045
         CALL cl_err3("upd","coc_file",g_cno.cno10,"",SQLCA.sqlcode,"","update coc07",1) #TQC-660045
         LET g_success ='N'
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_cno.cno01,'Y')
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT cnoconf INTO g_cno.cnoconf FROM cno_file
    WHERE cno01 = g_cno.cno01
   DISPLAY BY NAME g_cno.cnoconf
   #CALL cl_set_field_pic(g_cno.cnoconf,"","","","",g_cno.cnoacti)  #CHI-C80041
   IF g_cno.cnoconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_cno.cnoconf,"","","",g_void,g_cno.cnoacti)   #CHI-C80041
END FUNCTION
 
FUNCTION t520_yz(p_flag,p_no,p_type,p_type1,p_type2,p_chr)
 DEFINE p_no       LIKE cno_file.cno01
 DEFINE p_flag     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 DEFINE p_chr      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 DEFINE p_type     LIKE cno_file.cno03
 DEFINE p_type1    LIKE cno_file.cno031
 DEFINE p_type2    LIKE cno_file.cno04
 DEFINE l_cnp      RECORD
                   cnp02 LIKE cnp_file.cnp02,
                   cnp05 LIKE cnp_file.cnp05,
                   cnp06 LIKE cnp_file.cnp06,
                   cnp07 LIKE cnp_file.cnp07,
                   cnp08 LIKE cnp_file.cnp08
                   END RECORD
 DEFINE l_qty      LIKE cnp_file.cnp05
 DEFINE l_cno10    LIKE cno_file.cno10
 DEFINE l_cnp05    LIKE cnp_file.cnp05
 DEFINE l_conf     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 DEFINE l_n1,l_n2  LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   SELECT cnoconf INTO l_conf FROM cno_file WHERE cno01 = p_no
 
   DECLARE firm_cs CURSOR FOR
    SELECT cnp02,SUM(cnp05),cnp06,cnp07,SUM(cnp08) FROM cnp_file
     WHERE cnp01 = p_no
     GROUP BY cnp02,cnp06,cnp07
   FOREACH firm_cs INTO l_cnp.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
 
      #---------------- 更新 cnq_file -----------------------------------
      CALL s_upd_cnq(p_no,l_cnp.cnp02,l_cnp.cnp05,l_cnp.cnp06,l_cnp.cnp07,l_cnp.cnp08,p_chr)
      IF g_success ='N' THEN RETURN END IF
      #---------------- 更新 cnq_file 結束-------------------------------
 
      #---------------- 更新 coe_file ---------------------------
      IF p_type='2' THEN               #型態:合同材料
         SELECT cno18 INTO g_cno.cno18 FROM cno_file WHERE cno01 = g_cno.cno01
         ##檢查已進口剩餘量
         IF p_chr = 'y' THEN           #審核
            IF g_cno.cno031 = '1' THEN #核銷撥出的時候
               IF p_type1 = '1' THEN   #核銷撥出單本身cno10
                  #檢查撥出數量不能超過材料的可用量
                  CALL s_chkcoe1(g_cno.cno10,l_cnp.cnp02) RETURNING l_qty
                  IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                  IF l_cnp.cnp05 > l_qty THEN
                     CALL cl_err(l_cnp.cnp02,'aco-029',1)
                     LET g_success='N' EXIT FOREACH
                   END IF
               ELSE                    #核銷撥入單cno11
                  #檢查撥入數量不能超過材料的可進口量
                  CALL s_coeqty(g_cno.cno11,l_cnp.cnp02) RETURNING l_qty
                  IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                  IF l_cnp.cnp05 > l_qty THEN
                     CALL cl_err(l_cnp.cnp02,'aco-046',1)
                     LET g_success='N' EXIT FOREACH
                  END IF
               END IF                  #
            ELSE                       #核銷撥入的時候
               #檢查撥數量不能超過材料的可進口量
               CALL s_coeqty(g_cno.cno10,l_cnp.cnp02) RETURNING l_qty
               IF cl_null(l_qty) THEN LET l_qty = 0 END IF
               IF l_cnp.cnp05 > l_qty THEN
                  CALL cl_err(l_cnp.cnp02,'aco-046',1)
                  LET g_success='N' EXIT FOREACH
               END IF
            END IF
         END IF
         #材料進口取消確認
         IF p_chr = 'z' THEN
            IF g_cno.cno031 = '1' THEN #核銷撥出的時候
               IF p_type1 = '1' THEN   #撥出
                  #撥出還原的時候檢查不能超過材料的撥出量
                  SELECT coe103 INTO l_qty FROM coc_file,coe_file
                   WHERE coc01 = coe01 AND coc03 = g_cno.cno10
                     AND coe02 = l_cnp.cnp02
                  IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                  IF l_cnp.cnp05 > l_qty THEN
                     CALL cl_err(l_cnp.cnp02,'aco-046',1)
                     LET g_success='N' EXIT FOREACH
                   END IF
               ELSE                    #撥入
                  #撥入還原的時候不能超過材料的撥入量
                  SELECT cno10 INTO l_cno10 FROM cno_file WHERE cno01 = p_no
                  SELECT coe051 INTO l_qty FROM coc_file,coe_file
                   WHERE coc01 = coe01 AND coc03 = l_cno10
                     AND coe02 = l_cnp.cnp02
                  IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                  IF l_cnp.cnp05 > l_qty THEN
                     CALL cl_err(l_cnp.cnp02,'aco-029',1)
                     LET g_success='N' EXIT FOREACH
                  END IF
               END IF
            END IF
         END IF
 
         SELECT cno10 INTO l_cno10 FROM cno_file WHERE cno01 = p_no
         IF p_type1 = '2' THEN         #狀況:進口
            CALL s_upd_codcoe(l_cno10,l_cnp.cnp02,'2','2','5')
         END IF
         IF p_type1 = '1' THEN         #狀況:出口
            CALL s_upd_codcoe(l_cno10,l_cnp.cnp02,'2','1','5')
         END IF
      END IF
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err('upd cod/coe:',STATUS,0) LET g_success='N' EXIT FOREACH
      END IF
 
   END FOREACH
END FUNCTION
 
FUNCTION t520_z()
  DEFINE l_cno01  LIKE cno_file.cno01
 
   IF g_cno.cno01 IS NULL THEN RETURN END IF
   SELECT * INTO g_cno.* FROM cno_file WHERE cno01=g_cno.cno01
   IF g_cno.cnoconf ='X' THEN RETURN END IF #CHI-C80041
   IF g_cno.cnoconf='N' THEN RETURN END IF
   IF g_cno.cnoacti='N' THEN RETURN END IF
   IF g_cno.cno03 = '2' AND g_cno.cno04 = '5' AND g_cno.cno031 ='2' AND
      NOT cl_null(g_cno.cno18) THEN
      CALL cl_err(g_cno.cno01,'aco-068',0) RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   #找出原始的申請編號
   SELECT coc01 INTO g_coc01 FROM coc_file
    WHERE coc03 = g_cno.cno10
      AND cocacti !='N' #010807增
   IF cl_null(g_coc01) THEN
      CALL cl_err('sel coc01:','aco-005',1)  
      RETURN
   END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t520_cl USING g_cno.cno01
   IF STATUS THEN
      CALL cl_err("OPEN t520_cl:", STATUS, 1)
      CLOSE t520_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t520_cl INTO g_cno.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_cno.cno01,SQLCA.sqlcode,0)
       CLOSE t520_cl
       ROLLBACK WORK
       RETURN
   END IF
   UPDATE cno_file SET cnoconf='N' WHERE cno01 = g_cno.cno01
   IF STATUS THEN
#     CALL cl_err('upd cofconf',STATUS,0)  #No.TQC-660045
      CALL cl_err3("upd","cno_file",g_cno.cno01,"",STATUS,"","upd cofconf",1) #TQC-660045
      LET g_success='N'
   END IF
   CALL t520_yz('0',g_cno.cno01,g_cno.cno03,g_cno.cno031,g_cno.cno04,'z')
   #成品-出口,折合原料單據處理
   DECLARE note_cur CURSOR FOR
    SELECT cno01 FROM cno_file WHERE cno18 = g_cno.cno01 AND cnoconf='Y'
   FOREACH note_cur INTO l_cno01
      IF STATUS THEN
         CALL cl_err('',STATUS,0)
         LET g_success='N'
         RETURN
      END IF
      UPDATE cno_file SET cnoconf='N' WHERE cno01 = l_cno01
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd cnoconf #2',STATUS,0)  #No.TQC-660045
         CALL cl_err3("upd","cno_file",l_cno01,"",STATUS,"","upd cnoconf #2",1) #TQC-660045
         LET g_success='N'
      END IF
      CALL t520_yz('1',l_cno01,'2','2','5','z')
 
      DELETE FROM cno_file WHERE cno01 = l_cno01
      IF STATUS THEN
#        CALL cl_err('del cno',STATUS,0)  #No.TQC-660045
         CALL cl_err3("del","cno_file",l_cno01,"",STATUS,"","del cno",1) #TQC-660045
         LET g_success='N'
      END IF
      DELETE FROM cnp_file WHERE cnp01 = l_cno01
      IF STATUS THEN
#        CALL cl_err('del cnp',STATUS,0)  #No.TQC-660045
         CALL cl_err3("del","cnp_file",l_cno01,"",STATUS,"","del cnp",1) #TQC-660045
         LET g_success='N'
      END IF
      UPDATE cno_file SET cno18=NULL WHERE cno01 = g_cno.cno01
      IF STATUS THEN
#        CALL cl_err('upd cno18',STATUS,0)  #No.TQC-660045
         CALL cl_err3("upd","cno_file",g_cno.cno01,"",STATUS,"","upd cno18",1) #TQC-660045        
         LET g_success='N'
      END IF
   END FOREACH
   #coc07(核銷日期)更新#
   IF g_cno.cno031 = '1' THEN
      UPDATE coc_file SET coc07='' WHERE coc03 = g_cno.cno10
      IF SQLCA.sqlcode THEN
#        CALL cl_err('update coc07',SQLCA.sqlcode,0) #No.TQC-660045
         CALL cl_err3("upd","coc_file",g_cno.cno10,"",SQLCA.sqlcode,"","update coc07",1) #TQC-660045
         LET g_success ='N'
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT cnoconf INTO g_cno.cnoconf FROM cno_file
    WHERE cno01 = g_cno.cno01
   DISPLAY BY NAME g_cno.cnoconf
   #CALL cl_set_field_pic(g_cno.cnoconf,"","","","",g_cno.cnoacti)  #CHI-C80041
   IF g_cno.cnoconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_cno.cnoconf,"","","",g_void,g_cno.cnoacti)   #CHI-C80041
END FUNCTION
 
FUNCTION t520_g_b()
  DEFINE l_coe   RECORD LIKE coe_file.*
  DEFINE l_cnp   RECORD LIKE cnp_file.*
  DEFINE l_qty   LIKE cnp_file.cnp05
  DEFINE l_qty1  LIKE cnp_file.cnp05
  DEFINE l_coc03 LIKE coc_file.coc03
  DEFINE l_count LIKE type_file.num5          #No.FUN-680069 SMALLINT
  DEFINE l_i     LIKE type_file.num5          #No.FUN-680069 SMALLINT
  DEFINE l_cnt   LIKE type_file.num5          #No.FUN-680069 SMALLINT
  DEFINE l_sql   LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(600)
 
    LET l_count = 0
    IF g_cno.cno031 = '1' THEN
       LET l_coc03 = g_cno.cno10
    ELSE
       LET l_coc03 = g_cno.cno11
    END IF
    DECLARE coe_cur CURSOR FOR
     SELECT coe_file.* FROM coe_file,coc_file
      WHERE coe01 = coc01 AND coc03 = l_coc03
    LET l_i = 1
    FOREACH coe_cur INTO l_coe.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach coe:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       INITIALIZE l_cnp.* TO NULL
       LET l_cnp.cnp01 = g_cno.cno01
       LET l_cnp.cnp012= l_i
       LET l_cnp.cnp02 = l_coe.coe02
       IF g_cno.cno031 = '2' THEN   #兩本手冊的備案序號不一樣
          SELECT coe02 INTO l_cnp.cnp02 FROM coe_file,coc_file
           WHERE coc03 = g_cno.cno10 AND coc01 = coe01
             AND coe03 = l_coe.coe03
       END IF
       LET l_cnp.cnp03 = l_coe.coe03
       IF g_cno.cno031 = '1' THEN   #核銷撥出的時候用可用量default單身
          CALL s_chkcoe1(l_coc03,l_coe.coe02) RETURNING l_cnp.cnp05
       END IF
       IF g_cno.cno031 = '2' THEN   #核銷撥入的時候用cno11的撥出量default單身
          SELECT coe103 INTO l_qty FROM coc_file,coe_file  #cno11的撥出量總和
           WHERE coc01 = coe01 AND coc03 = g_cno.cno11
             AND coe02 = l_coe.coe02
          SELECT SUM(cnp05) INTO l_qty1 FROM cno_file,cnp_file  #cno11的已撥入量總和
           WHERE cno01 = cnp01 AND cno03 = '2'
             AND cno031= '2'   AND cno04 = '5'
             AND cnoconf = 'Y' AND cno11 = g_cno.cno11
             AND cnp03 = l_coe.coe03
          IF cl_null(l_qty)  THEN LET l_qty = 0 END IF
          IF cl_null(l_qty1) THEN LET l_qty1= 0 END IF
          LET l_cnp.cnp05 = l_qty - l_qty1                 #剩余量
       END IF
       IF cl_null(l_cnp.cnp05) THEN LET l_cnp.cnp05 = 0 END IF
       IF l_cnp.cnp05 <=0 THEN CONTINUE FOREACH END IF
       LET l_cnp.cnp06 = l_coe.coe06
       LET l_cnp.cnp05 = s_digqty(l_cnp.cnp05,l_cnp.cnp06)   #FUN-BB0084
       LET l_cnp.cnp07 = l_coe.coe07
       LET l_cnp.cnp08 = l_cnp.cnp05 * l_cnp.cnp07
       LET l_cnp.cnp09 = 0
       LET l_cnp.cnp10 = 0
       LET l_cnp.cnp11 = l_coe.coe11
       LET l_cnp.cnp12 = NULL
       LET l_cnp.cnp13 = NULL
       LET l_cnp.cnp14 = 0
       LET l_cnp.cnp15 = g_cno.cno20
       LET l_cnp.cnpplant = g_plant #FUN-980002
       LET l_cnp.cnplegal = g_legal #FUN-980002
 
       INSERT INTO cnp_file VALUES(l_cnp.*)
       IF STATUS THEN
#          CALL cl_err('ins cnp:',STATUS,1) #No.TQC-660045
           CALL cl_err3("ins","cnp_file",l_cnp.cnp01,l_cnp.cnp012,STATUS,"","ins cnp",1) #TQC-660045
           EXIT FOREACH
       END IF
       LET l_i = l_i + 1
    END FOREACH
    LET l_count = l_i - 1
 
    IF l_count = 0 THEN CALL cl_err('','aco-058',0) END IF
    CALL t520_b_fill('1=1')                 #單身
END FUNCTION
 
FUNCTION t520_gen()
  DEFINE l_qty    LIKE col_file.col10
  DEFINE l_qty2   LIKE col_file.col10
  DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680069 SMALLINT
  DEFINE l_i      LIKE type_file.num5          #No.FUN-680069 SMALLINT
  DEFINE l_slip   LIKE coy_file.coyslip
  DEFINE m_cno    RECORD LIKE cno_file.*
  DEFINE m_cnp    RECORD LIKE cnp_file.*
  DEFINE l_cnp    RECORD LIKE cnp_file.*
  DEFINE l_coe    RECORD LIKE coe_file.*
  DEFINE l_coe1   RECORD LIKE coe_file.*
  DEFINE li_result   LIKE type_file.num5       #No.FUN-560060        #No.FUN-680069 SMALLINT
 
    INITIALIZE m_cno.* TO NULL
    LET m_cno.* = g_cno.*
#   LET l_slip = g_cno.cno01[1,3]
    LET l_slip = s_get_doc_no(g_cno.cno01)     #No.FUN-550036
#No.FUN-560060 --start--
    CALL s_auto_assign_no("aco",l_slip,g_cno.cno02,"19","","","","","")
        RETURNING li_result,m_cno.cno01
      IF (NOT li_result) THEN
         LET g_success='N'
      RETURN
      END IF
#    CALL s_acoauno(l_slip,g_cno.cno02,'19')
#         RETURNING g_i,m_cno.cno01
#    IF g_i THEN LET g_success='N' RETURN END IF
#No.FUN-560060 --end--
 
    LET m_cno.cno031= '2'
    LET m_cno.cno10 = g_cno.cno11
    LET m_cno.cno11 = g_cno.cno10
    LET m_cno.cno18 = g_cno.cno01
    LET m_cno.cnoconf = 'Y'
    LET m_cno.cnoplant = g_plant #FUN-980002
    LET m_cno.cnolegal = g_legal #FUN-980002
 
    LET m_cno.cnooriu = g_user      #No.FUN-980030 10/01/04
    LET m_cno.cnoorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO cno_file VALUES(m_cno.*)
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#      CALL cl_err('ins cno',STATUS,0)  #No.TQC-660045
       CALL cl_err3("ins","cno_file",m_cno.cno01,"",STATUS,"","ins cno",1) #TQC-660045
       LET g_success='N' RETURN
    END IF
 
    #折合材料單身
    INITIALIZE m_cnp.* TO NULL
    LET m_cnp.cnp01 = m_cno.cno01
    LET m_cnp.cnp012 = 0
    LET m_cnp.cnp09 = 0
    LET m_cnp.cnp10 = 0
    LET m_cnp.cnp14 = 0
    DECLARE cnp_curs CURSOR FOR
     SELECT * FROM cnp_file
      WHERE cnp01 = g_cno.cno01
     IF STATUS THEN
        CALL cl_err('cnp_curs',STATUS,0) 
        LET g_success='N' RETURN
     END IF
    LET l_i = 1
    FOREACH cnp_curs INTO l_cnp.*
       IF STATUS THEN
          CALL cl_err('cnp_curs',STATUS,0) LET g_success='N' RETURN
       END IF
       LET l_qty = l_cnp.cnp05
       IF cl_null(l_qty) THEN LET l_qty = 0 END IF
 
       SELECT coe_file.* INTO l_coe1.* FROM coc_file,coe_file
        WHERE coc01 = coe01 AND coc03 = g_cno.cno11
          AND coe03 = l_cnp.cnp03
       CALL s_coeqty(g_cno.cno11,l_coe1.coe02) RETURNING l_qty2
       IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF
       #可進口余量小于合同轉入量
       IF l_qty2 < l_qty THEN
          CALL cl_err(g_cno.cno11,'aco-190',0)
          LET g_success = 'N'
          RETURN
       END IF
 
       LET m_cnp.cnp012= l_i
       LET m_cnp.cnp02 = l_coe1.coe02
       LET m_cnp.cnp03 = l_coe1.coe03
       LET m_cnp.cnp05 = l_qty
       LET m_cnp.cnp06 = l_coe1.coe06
       LET m_cnp.cnp05 = s_digqty(m_cnp.cnp05,m_cnp.cnp06)    #FUN-BB0084
       LET m_cnp.cnp07 = l_coe1.coe07
       LET m_cnp.cnp08 = m_cnp.cnp05 * m_cnp.cnp07
       LET m_cnp.cnp11 = l_coe1.coe11
       LET m_cnp.cnp12 = g_cno.cno01
       LET m_cnp.cnp13 = l_cnp.cnp012
       LET m_cnp.cnpplant = g_plant #FUN-980002
       LET m_cnp.cnplegal = g_legal #FUN-980002
 
       INSERT INTO cnp_file VALUES(m_cnp.*)
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('ins cnp',STATUS,0)  #No.TQC-660045
          CALL cl_err3("ins","cnp_file",m_cnp.cnp01,m_cnp.cnp012,STATUS,"","ins cnp",1) #TQC-660045
          LET g_success='N' RETURN
       END IF
       LET l_i = l_i + 1
    END FOREACH
    SELECT COUNT(*) INTO l_cnt FROM cnp_file WHERE cnp01 = m_cno.cno01
    IF l_cnt = 0 THEN
       DELETE FROM cno_file WHERE cno01 = m_cno.cno01
    ELSE
       UPDATE cno_file SET cno18 = m_cno.cno01
        WHERE cno01 = g_cno.cno01
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('upd cno',STATUS,0)  #No.TQC-660045
          CALL cl_err3("upd","cno_file",g_cno.cno01,"",STATUS,"","upd cno",1) #TQC-660045
          LET g_success='N' RETURN
       END IF
       CALL t520_yz('1',m_cno.cno01,m_cno.cno03,m_cno.cno031,m_cno.cno04,'y')
    END IF
END FUNCTION
 
FUNCTION t520_set_required()
 
  IF g_cno.cno031= '2' THEN
     CALL cl_set_comp_required("cno11",TRUE)
     CALL cl_set_comp_required("cno18",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION t520_set_no_required()
 
  CALL cl_set_comp_required("cno11",FALSE)
  CALL cl_set_comp_required("cno18",FALSE)
 
END FUNCTION
 
FUNCTION t520_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cno01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t520_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cno01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t520_cno10_cno11()
  DEFINE l_coe     RECORD LIKE coe_file.*,
         l_cnp05   LIKE cnp_file.cnp05,
         l_flag    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
 
    IF cl_null(g_cno.cno11) THEN RETURN END IF
    IF g_cno.cno031 <> '1' THEN RETURN END IF
    #在核銷出口的時候,如果cno11不為空的話..系統自動生成一筆對應核銷進口的資料.
    #所以這時要檢查是否出現核銷出口的手冊中包含cno11不存在的商品,且此商品的量是
    #不為零的.
    LET l_flag = '0'
    DECLARE t520_cno10_11_cur CURSOR FOR
     SELECT * FROM coe_file
      WHERE coe01 = g_coc01
    FOREACH t520_cno10_11_cur INTO l_coe.*
       IF STATUS THEN
          CALL cl_err('cno10_11_curs',STATUS,0)
          EXIT FOREACH
       END IF
       CALL s_chkcoe1(g_cno.cno10,l_coe.coe02) RETURNING l_cnp05
       IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
       IF l_cnp05 <=0 THEN CONTINUE FOREACH END IF
       SELECT * FROM coc_file,coe_file
        WHERE coc01 = coe01 AND coc03 = g_cno.cno11
          AND coe03 = l_coe.coe03
       IF SQLCA.sqlcode THEN
          LET l_flag = '1'
          EXIT FOREACH
       END IF
    END FOREACH
    IF l_flag = '1' THEN LET g_errno = 'aco-190' END IF
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002> #
#Patch....NO.TQC-610035 <001> #
#CHI-C80041---begin
FUNCTION t520_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_cno.cno01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t520_cl USING g_cno.cno01
   IF STATUS THEN
      CALL cl_err("OPEN t520_cl:", STATUS, 1)
      CLOSE t520_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t520_cl INTO g_cno.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cno.cno01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t520_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_cno.cnoconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_cno.cnoconf)   THEN 
        LET l_chr=g_cno.cnoconf
        IF g_cno.cnoconf='N' THEN 
            LET g_cno.cnoconf='X' 
        ELSE
            LET g_cno.cnoconf='N'
        END IF
        UPDATE cno_file
            SET cnoconf=g_cno.cnoconf,  
                cnomodu=g_user,
                cnodate=g_today
            WHERE cno01=g_cno.cno01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","cno_file",g_cno.cno01,"",SQLCA.sqlcode,"","",1)  
            LET g_cno.cnoconf=l_chr 
        END IF
        DISPLAY BY NAME g_cno.cnoconf 
   END IF
 
   CLOSE t520_cl
   COMMIT WORK
   CALL cl_flow_notify(g_cno.cno01,'V')
 
END FUNCTION
#CHI-C80041---end
