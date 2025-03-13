# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmt900.4gl
# Descriptions...: 请购变更单维护作业
# Date & Author..: 10/08/24 By Carrier #No.FUN-A80115
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/10 By chenying 修改料號開窗
# Modify.........: No.MOD-B30424 11/03/15 By baogc 修改請購單號的查詢開窗
# Modify.........: No.FUN-B30076 11/04/21 By suncx 新增取消確認和發出功能
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B70014 11/07/08 By Lilan 簽核不可執行的ACTION清單
# Modify.........: No.FUN-B30081 11/08/01 By lixiang 單頭增加"交易條件"頁簽
# Modify.........: No.FUN-910088 11/12/01 By chenjing 增加數量欄位小數取位

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20026 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:FUN-C20068 12/02/13 By fengrui 增加數量欄位小數取位
# Modify.........: No.TQC-BB0252 12/02/16 By SunLM 對pne01開窗查詢返回的結果進行判斷
# Modify.........: No.TQC-C20183 12/02/20 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-C30017 12/03/07 By Mandy 未確認，且狀況碼為「0/1/R/W」時，可允許"U:修改","B:單身"; 修改資料後，狀況碼變為「0:開立」
# Modify.........: No.TQC-C30173 12/03/14 By lixiang 服飾流通行業下變更單的處理
# Modify.........: No.MOD-C30595 12/03/15 By zhuhao 單位變更時檢查是否存在單位轉換率
# Modify.........: No:MOD-C30822 12/03/22 by Vampire 取消發出不應該update pneconf='Y',將更新段搬到t900sub_update_pr中處理
# Modify.........: No:CHI-C30112 12/05/02 by Sakura 增加新增項次時控卡交貨日期為必輸
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C90184 12/09/28 By Vampire 隨意輸入不存在的請購單，卻出現已完全轉採購(apm-515)
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.FUN-CC0094 13/01/21 By xianghui 增加發出人員，日期時間
# Modify.........: No.MOD-CB0261 13/02/04 By jt_chen 增加控卡不能同時KEY入兩張變更單
# Modify.........: No.FUN-D20025 13/02/21 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.CHI-C50063 13/02/23 By Elise 單身欄位開放查詢
# Modify.........: No.CHI-CB0002 13/02/25 By Elise 預算控卡
# Modify.........: No.MOD-D30012 13/03/07 By Elise OUTER JOIN gec_file時增加條件
# Modify.........: No.CHI-D10010 13/03/29 By Elise 變更單比照請購單新增時的單別權限控卡
# Modify.........: No.MOD-D40015 13/04/02 By SunLM 新增单身项次,计价单位自动带出
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds #No.FUN-A80115

GLOBALS "../../config/top.global"

DEFINE g_pne           RECORD LIKE pne_file.*             #请购單
DEFINE g_pne_t         RECORD LIKE pne_file.*             #请购單   (舊值)
DEFINE g_pne_o         RECORD LIKE pne_file.*             #请购單   (舊值)
DEFINE g_pne01_t       LIKE pne_file.pne01                #變更單號 (舊值)
DEFINE g_pne02_t       LIKE pne_file.pne02                #變更序號 (舊值)
DEFINE g_pnf03_o       LIKE pnf_file.pnf03
DEFINE g_pnf           DYNAMIC ARRAY OF RECORD            #程式變數(Program Variables)
                       pnf03       LIKE pnf_file.pnf03,   #項次
                       before      LIKE type_file.chr1,   #
                       pnf04b      LIKE pnf_file.pnf04b,  #變更前料號(變更前)
                       pnf041b     LIKE pnf_file.pnf041b, #品名
                       ima021b     LIKE ima_file.ima021,  #規格
                       pnf20b      LIKE pnf_file.pnf20b,  #數    量
                       pnf07b      LIKE pnf_file.pnf07b,  #單    位
                       pnf83b      LIKE pnf_file.pnf83b,
                       pnf84b      LIKE pnf_file.pnf84b,
                       pnf85b      LIKE pnf_file.pnf85b,
                       pnf80b      LIKE pnf_file.pnf80b,
                       pnf81b      LIKE pnf_file.pnf81b,
                       pnf82b      LIKE pnf_file.pnf82b,
                       pnf86b      LIKE pnf_file.pnf86b,
                       pnf87b      LIKE pnf_file.pnf87b,
                       pnf41b      LIKE pnf_file.pnf41b,  #PLP-No.
                       pnf12b      LIKE pnf_file.pnf12b,
                       pnf121b     LIKE pnf_file.pnf121b,
                       pnf122b     LIKE pnf_file.pnf122b,
                       pnf33b      LIKE pnf_file.pnf33b,  #交 貨 日
                       after       LIKE type_file.chr1,
                       pnf04a      LIKE pnf_file.pnf04a,  #變更后料號(變更后)
                       pnf041a     LIKE pnf_file.pnf041a, #品名
                       ima021a     LIKE ima_file.ima021,  #規格
                       pnf20a      LIKE pnf_file.pnf20a,  #數    量
                       pnf07a      LIKE pnf_file.pnf07a,  #單    位
                       pnf83a      LIKE pnf_file.pnf83a,
                       pnf84a      LIKE pnf_file.pnf84a,
                       pnf85a      LIKE pnf_file.pnf85a,
                       pnf80a      LIKE pnf_file.pnf80a,
                       pnf81a      LIKE pnf_file.pnf81a,
                       pnf82a      LIKE pnf_file.pnf82a,
                       pnf86a      LIKE pnf_file.pnf86a,
                       pnf87a      LIKE pnf_file.pnf87a,
                       pnf41a      LIKE pnf_file.pnf41a,  #PLP-No.
                       pnf12a      LIKE pnf_file.pnf12a,
                       pnf121a     LIKE pnf_file.pnf121a,
                       pnf122a     LIKE pnf_file.pnf122a,
                       pnf33a      LIKE pnf_file.pnf33a,  #交 貨 日
                       pnf50       LIKE pnf_file.pnf50    #備    註
                       END RECORD
DEFINE g_pnf_t         RECORD                             #程式變數 (舊值)
                       pnf03       LIKE pnf_file.pnf03,   #項次
                       before      LIKE type_file.chr1,   #
                       pnf04b      LIKE pnf_file.pnf04b,  #變更前料號(變更前)
                       pnf041b     LIKE pnf_file.pnf041b, #品名
                       ima021b     LIKE ima_file.ima021,  #規格
                       pnf20b      LIKE pnf_file.pnf20b,  #數    量
                       pnf07b      LIKE pnf_file.pnf07b,  #單    位
                       pnf83b      LIKE pnf_file.pnf83b,
                       pnf84b      LIKE pnf_file.pnf84b,
                       pnf85b      LIKE pnf_file.pnf85b,
                       pnf80b      LIKE pnf_file.pnf80b,
                       pnf81b      LIKE pnf_file.pnf81b,
                       pnf82b      LIKE pnf_file.pnf82b,
                       pnf86b      LIKE pnf_file.pnf86b,
                       pnf87b      LIKE pnf_file.pnf87b,
                       pnf41b      LIKE pnf_file.pnf41b,  #PLP-No.
                       pnf12b      LIKE pnf_file.pnf12b,
                       pnf121b     LIKE pnf_file.pnf121b,
                       pnf122b     LIKE pnf_file.pnf122b,
                       pnf33b      LIKE pnf_file.pnf33b,  #交 貨 日
                       after       LIKE type_file.chr1,
                       pnf04a      LIKE pnf_file.pnf04a,  #變更后料號(變更后)
                       pnf041a     LIKE pnf_file.pnf041a, #品名
                       ima021a     LIKE ima_file.ima021,  #規格
                       pnf20a      LIKE pnf_file.pnf20a,  #數    量
                       pnf07a      LIKE pnf_file.pnf07a,  #單    位
                       pnf83a      LIKE pnf_file.pnf83a,
                       pnf84a      LIKE pnf_file.pnf84a,
                       pnf85a      LIKE pnf_file.pnf85a,
                       pnf80a      LIKE pnf_file.pnf80a,
                       pnf81a      LIKE pnf_file.pnf81a,
                       pnf82a      LIKE pnf_file.pnf82a,
                       pnf86a      LIKE pnf_file.pnf86a,
                       pnf87a      LIKE pnf_file.pnf87a,
                       pnf41a      LIKE pnf_file.pnf41a,  #PLP-No.
                       pnf12a      LIKE pnf_file.pnf12a,
                       pnf121a     LIKE pnf_file.pnf121a,
                       pnf122a     LIKE pnf_file.pnf122a,
                       pnf33a      LIKE pnf_file.pnf33a,  #交 貨 日
                       pnf50       LIKE pnf_file.pnf50    #備    註
                       END RECORD
DEFINE g_wc                STRING
DEFINE g_wc2               STRING
DEFINE g_sql               STRING
DEFINE g_sql_tmp           STRING
DEFINE g_pnf04             LIKE pnf_file.pnf04b
DEFINE g_smy62             LIKE smy_file.smy62
DEFINE g_flag              LIKE type_file.num5
DEFINE g_ima31             LIKE ima_file.ima31
DEFINE g_ima44             LIKE ima_file.ima44
DEFINE g_ima906            LIKE ima_file.ima906
DEFINE g_ima907            LIKE ima_file.ima907
DEFINE g_ima908            LIKE ima_file.ima908
DEFINE g_factor            LIKE pml_file.pml09
DEFINE g_change            LIKE type_file.chr1
DEFINE g_argv1             LIKE pmk_file.pmk01    #请购单号
DEFINE g_argv2             LIKE pmk_file.pmk03    #变更序号
DEFINE g_argv3             STRING
DEFINE g_cmd               LIKE type_file.chr1000
DEFINE g_rec_b             LIKE type_file.num5     #單身筆數
DEFINE g_t1                LIKE oay_file.oayslip
DEFINE g_laststage         LIKE type_file.chr1
DEFINE l_ac                LIKE type_file.num5     #目前處理的ARRAY CNT
DEFINE g_forupd_sql        STRING                  #SELECT ...  FOR UPDATE SQL
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_chr2              LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_error             LIKE type_file.chr10
DEFINE g_newline           LIKE type_file.chr1

MAIN
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP,
           FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)
       DEFER INTERRUPT
    END IF

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("APM")) THEN
       EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_wc2=' 1=1'
    LET g_forupd_sql = "SELECT * FROM pne_file WHERE pne01 = ? AND pne02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t900_cl CURSOR FROM g_forupd_sql

    LET g_pne.pne01 = NULL
    LET g_argv1      = ARG_VAL(1)          # 參數值(1) - 请购單號
    LET g_argv2      = ARG_VAL(2)          # 參數值(2) - 请购变更序号
    LET g_argv3      = ARG_VAL(3)          # 參數值(3) - 功能

    IF fgl_getenv('EASYFLOW') = "1" THEN
       LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
       LET g_argv2 = aws_efapp_wsk(2)   #參數:key-2
    END IF

    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
       OPEN WINDOW t900_w WITH FORM "apm/42f/apmt900"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
       CALL cl_ui_init()
    END IF

    #建立簽核模式時的 toolbar icon
    CALL aws_efapp_toolbar()

    IF NOT cl_null(g_argv1) THEN
       CASE g_argv3
          WHEN "efconfirm"
             CALL t900_q()
             CALL t900sub_y_chk(g_argv1,g_argv2)             #CALL 原確認的 check 段
             IF g_success = "Y" THEN
                LET l_ac = 1
                CALL t900sub_y_upd(g_argv1,g_argv2,g_argv3)  #CALL 原確認的 update 段
             END IF
             EXIT PROGRAM
          OTHERWISE
             CALL t900_q()
       END CASE
    END IF

    CALL t900_def_form()

    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, unconfirm, issued, easyflow_approval")  #FUN-B70014 add:unconfirm, issued #FUN-D20025 add undo_void
         RETURNING g_laststage

    CALL t900_menu()
    CLOSE t900_cl
    CLOSE WINDOW t900_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION t900_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN

   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "pne01 = '",g_argv1,"' "
      IF NOT cl_null(g_argv2) THEN
         LET g_wc = g_wc," AND pne02='",g_argv2,"'"
      END IF
      LET g_wc2= " 1=1"
      LET g_pne.pne01=g_argv1
      DISPLAY BY NAME g_pne.pne01
      LET g_pne.pne02=g_argv2
      DISPLAY BY NAME g_pne.pne02
   ELSE
      CLEAR FORM                #NO:7203
      CALL g_pnf.clear()
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_pne.* TO NULL
      CONSTRUCT BY NAME g_wc ON pne01,pne02,pne03,pne04,pne05,pne06,
                                pne14,pnemksg,pne09,pne10,pne11,pne12,pne13,
                                pne09b,pne10b,pne11b,pne12b,pne13b,
                                pneuser,pnegrup,pneoriu,pneorig,
                                pnemodu,pnedate,pnesendu,pnesendd,pneacti,  #FUN-CC0094 add pnesendu,pnesendd
                                pneud01,pneud02,pneud03,pneud04,pneud05,
                                pneud06,pneud07,pneud08,pneud09,pneud10,
                                pneud11,pneud12,pneud13,pneud14,pneud15,
                                pneconf #FUN-B30076 add

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pne01)   #请购单号
                    CALL cl_init_qry_var()
               #    LET g_qryparam.form = "q_pmk01"           #MOD-B30424 MARK
                    LET g_qryparam.form = "q_pmk3"            #MOD-B30424 ADD
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne01
                    NEXT FIELD pne01
               WHEN INFIELD(pne04)   #查詢碼別代號說明資料檔
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azf01a"
                    LET g_qryparam.arg1 = 'B'
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne04
                    NEXT FIELD pne04
               WHEN INFIELD(pne05)   #變更人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne05
                    NEXT FIELD pne05
               WHEN INFIELD(pne09)   #查詢幣別資料檔
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azi"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne09
                    NEXT FIELD pne09
               WHEN INFIELD(pne10)   #查詢付款條件資料檔(pma_file)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pma"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne10
                    NEXT FIELD pne10
               WHEN INFIELD(pne11)   #價格條件
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pnz01"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne11
                    NEXT FIELD pne11
               WHEN INFIELD(pne12)   #查詢地址資料檔 (0:表送貨地址)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pme"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne12
                    NEXT FIELD pne12
               WHEN INFIELD(pne13)   #查詢地址資料檔 (1:表帳單地址) #BugNo:6478
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pme"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne13
                    NEXT FIELD pne13
               WHEN INFIELD(pne09b)   #查詢幣別資料檔
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azi"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne09b
                    NEXT FIELD pne09b
               WHEN INFIELD(pne10b)   #查詢付款條件資料檔(pma_file)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pma"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne10b
                    NEXT FIELD pne10b
               WHEN INFIELD(pne11b)   #價格條件
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pnz01"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne11b
                    NEXT FIELD pne11b
               WHEN INFIELD(pne12b)   #查詢地址資料檔 (0:表送貨地址)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pme"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne12b
                    NEXT FIELD pne12b
               WHEN INFIELD(pne13b)   #查詢地址資料檔 (1:表帳單地址)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pme"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pne13b
                    NEXT FIELD pne13b
               OTHERWISE EXIT CASE
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)

      END CONSTRUCT
      IF INT_FLAG THEN  RETURN END IF

      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pneuser', 'pnegrup')

      CONSTRUCT g_wc2 ON pnf03,pnf04b,pnf041b,pnf20b,pnf07b,pnf83b,pnf84b,
                         pnf85b,pnf80b,pnf81b,pnf82b,pnf86b,pnf87b,pnf41b,
                         pnf12b,pnf121b,pnf122b,pnf33b,
                         pnf04a,pnf041a,pnf20a,pnf07a,pnf83a,pnf84a,
                         pnf85a,pnf80a,pnf81a,pnf82a,pnf86a,pnf87a,pnf41a,
                         pnf12a,pnf121a,pnf122a,pnf33a
                         ,pnf50   #CHI-C50063 add
           FROM s_pnf[1].pnf03,s_pnf[1].pnf04b,s_pnf[1].pnf041b,s_pnf[1].pnf20b,s_pnf[1].pnf07b,
                s_pnf[1].pnf83b,s_pnf[1].pnf84b,s_pnf[1].pnf85b,s_pnf[1].pnf80b,s_pnf[1].pnf81b,
                s_pnf[1].pnf82b,s_pnf[1].pnf86b,s_pnf[1].pnf87b,s_pnf[1].pnf41b,s_pnf[1].pnf12b,
                s_pnf[1].pnf121b,s_pnf[1].pnf122b,s_pnf[1].pnf33b,s_pnf[1].pnf04a,s_pnf[1].pnf041a,
                s_pnf[1].pnf20a,s_pnf[1].pnf07a,s_pnf[1].pnf83a,s_pnf[1].pnf84a,s_pnf[1].pnf85a,
                s_pnf[1].pnf80a,s_pnf[1].pnf81a,s_pnf[1].pnf82a,s_pnf[1].pnf86a,s_pnf[1].pnf87a,
                s_pnf[1].pnf41a, s_pnf[1].pnf12a,s_pnf[1].pnf121a,s_pnf[1].pnf122a,s_pnf[1].pnf33a
                ,s_pnf[1].pnf50  #CHI-C50063 add

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pnf04b)  #料件
#FUN-AA0059---------mod------------str-----------------               
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.state = 'c'
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY g_qryparam.multiret TO pnf04b
                    NEXT FIELD pnf04b
               WHEN INFIELD(pnf07b)  #单位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf07b
                    NEXT FIELD pnf07b
               WHEN INFIELD(pnf83b)  #单位二
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf83b
                    NEXT FIELD pnf83b
               WHEN INFIELD(pnf80b)  #单位一
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf80b
                    NEXT FIELD pnf80b
               WHEN INFIELD(pnf86b)  #计价单位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf86b
                    NEXT FIELD pnf86b
               WHEN INFIELD(pnf12b)  #项目编号
                    CALL cl_init_qry_var()
                   #LET g_qryparam.form = "q_pjb2"   #CHI-C50063 mark
                    LET g_qryparam.form = "q_pja2"   #CHI-C50063
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf12b
                    NEXT FIELD pnf12b
               WHEN INFIELD(pnf121b) #WBS编号
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pjb4"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf121b
                    NEXT FIELD pnf121b
               WHEN INFIELD(pnf122b) #活动代号
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pjk3"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf122b
                    NEXT FIELD pnf122b
               WHEN INFIELD(pnf04a)  #料件
#FUN-AA0059---------mod------------str-----------------               
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.state = 'c'
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY g_qryparam.multiret TO pnf04a
                    NEXT FIELD pnf04a
               WHEN INFIELD(pnf07a)  #单位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf07a
                    NEXT FIELD pnf07a
               WHEN INFIELD(pnf83a)  #单位二
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf83a
                    NEXT FIELD pnf83a
               WHEN INFIELD(pnf80a)  #单位一
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf80a
                    NEXT FIELD pnf80a
               WHEN INFIELD(pnf86a)  #计价单位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf86a
                    NEXT FIELD pnf86a
               WHEN INFIELD(pnf12a)  #项目编号
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pja2"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf12a
                    NEXT FIELD pnf12a
               WHEN INFIELD(pnf121a) #WBS编号
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pjb4"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf121a
                    NEXT FIELD pnf121a
               WHEN INFIELD(pnf122a) #活动代号
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pjk3"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pnf122a
                    NEXT FIELD pnf122a
               OTHERWISE
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF

   IF g_wc2 = " 1=1" THEN                        #若單身未輸入條件
      LET g_sql = "SELECT pne01,pne02 FROM pne_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY pne01,pne02"
   ELSE
       LET g_sql= "SELECT UNIQUE pne01,pne02 ",
                  " FROM pne_file, pnf_file ",
                  " WHERE pne01 = pnf01 ",
                  "  AND  pne02 = pnf02 ",
                  "  AND ", g_wc CLIPPED, " AND ", g_wc2 CLIPPED,
                  " ORDER BY pne01,pne02 "
   END IF
   PREPARE t900_prepare FROM g_sql      #預備一下
   DECLARE t900_b_cs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t900_prepare

   DROP TABLE count_tmp
   IF g_wc2 = " 1=1" THEN     # 取合乎條件筆數
      LET g_sql_tmp = "SELECT pne01,pne02 FROM pne_file ",
                      " WHERE ", g_wc CLIPPED,
                      " INTO TEMP count_tmp"
   ELSE
      LET g_sql_tmp = "SELECT UNIQUE pne01,pne02 ",
                      " FROM pne_file, pnf_file ",
                      " WHERE pne01 = pnf01 ",
                      "  AND  pne02 = pnf02 ",
                      "  AND ", g_wc CLIPPED, " AND ", g_wc2 CLIPPED,
                      " INTO TEMP count_tmp"
   END IF
   PREPARE t900_cnt_tmp FROM g_sql_tmp
   EXECUTE t900_cnt_tmp
   LET g_sql = "SELECT COUNT(*) FROM count_tmp"
   PREPARE t900_precnt FROM g_sql
   DECLARE t900_count CURSOR FOR t900_precnt

END FUNCTION

FUNCTION t900_menu()
   DEFINE l_creator     LIKE type_file.chr1     #「不准」時是否退回填表人
   DEFINE l_flowuser    LIKE type_file.chr1     # 是否有指定加簽人員
   DEFINE l_time        LIKE pne_file.pnesendt  #FUN-CC0094

   LET l_flowuser = "N"
   WHILE TRUE
      CALL t900_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t900_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t900_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t900_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t900_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t900_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            CALL t900_out()
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

        #@WHEN "簽核狀況"
         WHEN "approval_status"
            IF cl_chk_act_auth() THEN          #DISPLAY ONLY
               IF aws_condition2() THEN        #FUN-550038
                  CALL aws_efstat2()           #MOD-560007
               END IF
            END IF

         WHEN "easyflow_approval"              #FUN-550038
            IF cl_chk_act_auth() THEN
              #FUN-C20026 add str---
               SELECT * INTO g_pne.* FROM pne_file
                WHERE pne01 = g_pne.pne01
                  AND pne02 = g_pne.pne02
               CALL t900_show()
               CALL t900_b_fill(' 1=1')
              #FUN-C20026 add end---
               CALL t900_ef()
               CALL t900_show()  #FUN-C20026 add
            END IF

         #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = "N" THEN                  #最後一關並且沒有加簽人員
                 CALL t900sub_y_upd(g_pne.pne01,g_pne.pne02,g_action_choice)  #CALL 原確認的 update 段
                 CALL t900sub_refresh(g_pne.pne01,g_pne.pne02) RETURNING g_pne.*           
                 CALL t900_show()
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                 IF cl_confirm('aws-081') THEN
                    IF aws_efapp_getnextforminfo() THEN
                       LET l_flowuser = 'N'
                       LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                       LET g_argv2 = aws_efapp_wsk(2)   #參數:key-1
                       IF NOT cl_null(g_argv1) THEN
                          CALL t900_q()
                          #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, unconfirm, issued, easyflow_approval") #FUN-B70014 add:unconfirm, issued #FUN-D20025 add undo_void
                               RETURNING g_laststage
                       ELSE
                          EXIT WHILE
                       END IF
                    ELSE
                       EXIT WHILE
                    END IF
                 ELSE
                    EXIT WHILE
                 END IF
              END IF

         #@WHEN "不准"
         WHEN "deny"
             IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN
                IF aws_efapp_formapproval() THEN
                   IF l_creator = "Y" THEN
                      LET g_pne.pne14 = 'R'
                      DISPLAY BY NAME g_pne.pne14
                   END IF
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                         LET l_flowuser = 'N'
                         LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                         LET g_argv2 = aws_efapp_wsk(2)   #參數:key-1
                         IF NOT cl_null(g_argv1) THEN
                            CALL t900_q()
                            #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                            CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void, confirm, unconfirm, issued, easyflow_approval") #FUN-B70014 add:unconfirm, issued #FUN-D20025 add undo_void
                                 RETURNING g_laststage
                         ELSE
                            EXIT WHILE
                         END IF
                      ELSE
                         EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                END IF
              END IF

         #@WHEN "加簽"
         WHEN "modify_flow"
              IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF

         #@WHEN "撤簽"
         WHEN "withdraw"
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF

         #@WHEN "抽單"
         WHEN "org_withdraw"
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF

         #@WHEN "簽核意見"
         WHEN "phrase"
              CALL aws_efapp_phrase()
         #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t900sub_y_chk(g_pne.pne01,g_pne.pne02)                          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t900sub_y_upd(g_pne.pne01,g_pne.pne02,g_action_choice)       #CALL 原確認的 update 段
                  CALL t900sub_refresh(g_pne.pne01,g_pne.pne02) RETURNING g_pne.*           
                  CALL t900_show()
               END IF
            END IF
         #FUN-B30076 add begin--------------
         #@WHEN "取消確認"
         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN 
               CALL t900_unconfirm(g_pne.pne01,g_pne.pne02)
               CALL t900sub_refresh(g_pne.pne01,g_pne.pne02) RETURNING g_pne.*           
               CALL t900_show()
            END IF
            
         #@WHEN "發出"
         WHEN "issued"
            IF cl_chk_act_auth() THEN
               BEGIN WORK 
               LET g_success = 'Y'  
               CALL t900sub_update_pr(g_pne.pne01,g_pne.pne02)
               IF g_success = 'N' THEN
                  ROLLBACK WORK
               ELSE 
                  #MOD-C30822 ----- mark start -----
               	  #UPDATE pne_file SET pneconf = 'Y'
               	  # WHERE pne01=g_pne.pne01 AND pne02=g_pne.pne02
                  #MOD-C30822 ----- mark end -----
                  #FUN-CC0094--add--str--
                  LET l_time = TIME
                  UPDATE pne_file 
                     SET pnesendu = g_user,
                         pnesendd = g_today,
                         pnesendt = l_time
                   WHERE pne01=g_pne.pne01
                     AND pne02=g_pne.pne02     
                  #FUN-CC0094--add--end--
               	  COMMIT WORK
               	  CALL t900sub_refresh(g_pne.pne01,g_pne.pne02) RETURNING g_pne.*           
                  CALL t900_show()
               END IF
            END IF
         #FUN-B30076 add -end---------------
         
         #@WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t900_x() #FUN-D20025 mark
               CALL t900_x(1) #FUN-D20025 add
            END IF
#FUN-D20025 add            
         #@WHEN "取消作廢"
	     WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t900_x(2)
            END IF 
#FUN-D20025 add             
        WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_pne.pne01 IS NOT NULL THEN
                  LET g_doc.column1 = "pne01"
                  LET g_doc.column2 = "pne02"    #TQC-740121 add
                  LET g_doc.value1 = g_pne.pne01
                  LET g_doc.value2 = g_pne.pne02 #TQC-740121 add
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION t900_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_pnf.clear()
   INITIALIZE g_pne.*   LIKE pne_file.*             #DEFAULT 設定
   INITIALIZE g_pne_t.* LIKE pne_file.*             #DEFAULT 設定
   INITIALIZE g_pne_o.* LIKE pne_file.*             #DEFAULT 設定
   LET g_pne.pne01  = ' '
   LET g_pne.pne03 = g_today
   LET g_pne.pne05 = g_user
   CALL t900_peo('d',g_pne.pne05)
   IF NOT cl_null(g_errno) THEN
      LET g_pne.pne05 = ''
   END IF
   CALL cl_opmsg('a')
   WHILE TRUE
       LET g_pne.pne06   = 'N'                    #未审核
       LET g_pne.pne14   = '0'
       LET g_pne.pnemksg = 'N'
       LET g_pne.pneacti = 'Y'
       LET g_pne.pneconf = 'N'    #FUN-B30076 ADD
       LET g_pne.pnegrup = g_grup
       LET g_pne.pnedate = g_today
       LET g_pne.pneuser = g_user
       LET g_pne.pneoriu = g_user
       LET g_pne.pneorig = g_grup
       LET g_data_plant  = g_plant
       LET g_pne.pneplant= g_plant
       LET g_pne.pnelegal= g_legal
       INITIALIZE g_pnf_t.* TO NULL
       CALL t900_i("a")                   #輸入單頭
       IF INT_FLAG THEN                   #使用者不玩了
          INITIALIZE g_pne.* TO NULL
          LET INT_FLAG = 0
          EXIT WHILE
       END IF
       DISPLAY g_pne.pne01 TO pne01
       INSERT INTO pne_file VALUES(g_pne.*)
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_pne.pne01,SQLCA.sqlcode,0)
          CONTINUE WHILE
       ELSE
          SELECT pne01,pne02 INTO g_pne.pne01,g_pne.pne02 FROM pne_file
           WHERE pne01 = g_pne.pne01
             AND pne02 = g_pne.pne02
       END IF
       LET g_rec_b = 0
       CALL t900_b()                   #輸入單身

       LET g_t1 = s_get_doc_no(g_pne.pne01)       #No.FUN-550060
       SELECT * INTO g_smy.* FROM smy_file
        WHERE smyslip=g_t1
       IF (NOT cl_null(g_pne.pne01)) AND (NOT cl_null(g_pne.pne02)) AND
          g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y' THEN
          LET g_action_choice = "insert"
          CALL t900sub_y_chk(g_pne.pne01,g_pne.pne02)                              #CALL 原確認的 check 段
          IF g_success = "Y" THEN
             CALL t900sub_y_upd(g_pne.pne01,g_pne.pne02,g_action_choice)           #CALL 原確認的 update 段
          END IF
       END IF

       EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t900_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_pne.pne01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF
   IF g_pne.pne06 = 'Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_pne.pne06 = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_pne.pneacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_pne.pne01,9027,0)
      RETURN
   END IF
   IF g_pne.pne14 matches '[Ss]' THEN          #FUN-550038
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
  #FUN-C30017---mark----str---
  #IF g_pne.pne14 = '1' AND g_pne.pnemksg = 'Y' THEN
  #   CALL cl_err('','mfg3186',0)
  #   RETURN
  #END IF
  #FUN-C30017---mark----end---

   CALL cl_opmsg('u')
   BEGIN WORK
   LET g_success ='Y'

   OPEN t900_cl USING g_pne.pne01,g_pne.pne02
   IF STATUS THEN
      CALL cl_err("OPEN t900_cl:", STATUS, 1)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900_cl INTO g_pne.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pne.pne01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t900_cl
       ROLLBACK WORK
       RETURN
   END IF

   LET g_pne01_t = g_pne.pne01
   LET g_pne02_t = g_pne.pne02
   LET g_pne_o.* = g_pne.*
   CALL t900_show()
   WHILE TRUE
       LET g_pne01_t = g_pne.pne01
       LET g_pne02_t = g_pne.pne02
       LET g_pne.pnemodu=g_user
       LET g_pne.pnedate=g_today
       CALL t900_i("u")                      #欄位更改
       IF INT_FLAG THEN
           LET g_success ='N'
           LET INT_FLAG = 0
           LET g_pne.*=g_pne_o.*
           LET g_pne.pne01 = g_pne_o.pne01
           DISPLAY BY NAME g_pne.pne01
           CALL cl_err('','9001',0)
           EXIT WHILE
       END IF
       IF g_pne.pne01 != g_pne01_t OR g_pne.pne02 != g_pne02_t THEN            # 更改單號
          UPDATE pnf_file SET pnf01 = g_pne.pne01,
                              pnf02 = g_pne.pne02
           WHERE pnf01 = g_pne01_t
             AND pnf02=  g_pne02_t
          IF SQLCA.sqlcode THEN
             CALL cl_err('pnf',SQLCA.sqlcode,0) CONTINUE WHILE
          END IF
       END IF
       LET g_pne.pne14 = '0'
       UPDATE pne_file SET pne_file.* = g_pne.*
        WHERE pne01 = g_pne01_t AND pne02 = g_pne02_t
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_pne.pne01,SQLCA.sqlcode,0)
          CONTINUE WHILE
       END IF
       IF cl_null(g_pne_o.pne09b) AND NOT cl_null(g_pne.pne09b) OR
          cl_null(g_pne.pne09b) AND NOT cl_null(g_pne_o.pne09b) OR
          NOT cl_null(g_pne.pne09b) AND NOT cl_null(g_pne_o.pne09b) AND
          g_pne.pne09b <> g_pne_o.pne09b THEN
          CALL cl_err(g_pne.pne09b,'axm-190',1)
       END IF
       EXIT WHILE
   END WHILE
   IF g_pne.pne06='X' THEN LET g_chr='Y'  ELSE LET g_chr='N'  END IF
   IF g_pne.pne14='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_pne.pne06,g_chr2,"","",g_chr,"")
   COMMIT WORK
   CALL t900_show()
END FUNCTION


FUNCTION t900_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1     #a:輸入 u:更改
   DEFINE l_pmk04         LIKE pmk_file.pmk04
   DEFINE l_flag          LIKE type_file.chr1 
   DEFINE l_azi02b        LIKE azi_file.azi02,    #No.FUN-B30081 Add
          l_pma02b        LIKE pma_file.pma02,    #No.FUN-B30081 Add
          l_pnz02b        LIKE pnz_file.pnz02,    #No.FUN-B30081 Add
          l_pme031b       LIKE pme_file.pme031,   #No.FUN-B30081 Add
          l_pme032b       LIKE pme_file.pme032,   #No.FUN-B30081 Add
          l_pme031b1      LIKE pme_file.pme031,   #No.FUN-B30081 Add
          l_pme032b1      LIKE pme_file.pme032    #No.FUN-B30081 Add
   DEFINE li_result       LIKE type_file.num5     #CHI-D10010 add
   DEFINE l_pne01         LIKE pne_file.pne01     #CHI-D10010 add

   CALL cl_set_head_visible("","YES")
   DISPLAY BY NAME g_pne.pne01,g_pne.pne02,g_pne.pne03,g_pne.pne04,g_pne.pne05,
                   g_pne.pne06,g_pne.pne14,g_pne.pnemksg,
                   g_pne.pne09,g_pne.pne10,g_pne.pne11,g_pne.pne12,g_pne.pne13,
                   g_pne.pne09b,g_pne.pne10b,g_pne.pne11b,g_pne.pne12b,g_pne.pne13b,
                   g_pne.pneuser,g_pne.pnegrup,g_pne.pnemodu,g_pne.pnedate,g_pne.pneacti,
                   g_pne.pneconf   #FUN-B30076 add

   INPUT BY NAME g_pne.pne01,g_pne.pne03,g_pne.pne04,g_pne.pne05,
                 g_pne.pne09b,g_pne.pne10b,
                 g_pne.pne12b,g_pne.pne11b,g_pne.pne13b,
                 g_pne.pneud01,g_pne.pneud02,g_pne.pneud03,g_pne.pneud04,
                 g_pne.pneud05,g_pne.pneud06,g_pne.pneud07,g_pne.pneud08,
                 g_pne.pneud09,g_pne.pneud10,g_pne.pneud11,g_pne.pneud12,
                 g_pne.pneud13,g_pne.pneud14,g_pne.pneud15
                 WITHOUT DEFAULTS

      BEFORE INPUT
         CALL cl_set_docno_format("pne01")
         LET  g_before_input_done = FALSE
         CALL t900_set_entry(p_cmd)
         CALL t900_set_no_entry(p_cmd)
         LET  g_before_input_done = TRUE

      BEFORE FIELD pne01
         CALL cl_set_comp_entry("pne09b,pne11b,pne10b,pne12b,pne13b",TRUE)

      AFTER FIELD pne01                   #请购單號
         IF NOT cl_null(g_pne.pne01) THEN
            CALL t900_pne01(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pne.pne01,g_errno,0)
               LET g_pne.pne01 = g_pne_t.pne01
               DISPLAY BY NAME g_pne.pne01
               NEXT FIELD pne01
            END IF

           #CHI-D10010---add---S
           #若單別設定檔有做使用者或部門設限，需照新增時的單別權限控卡
            LET g_t1=s_get_doc_no(g_pne.pne01)
            CALL s_check_no("apm",g_t1,"","1","pne_file","pne01","")
                 RETURNING li_result,l_pne01
            IF (NOT li_result) THEN
               NEXT FIELD pne01
            END IF
           #CHI-D10010---add---E

            #---->判斷此请购單,是否尚有未审核的變更單
            IF cl_null(g_pne_t.pne01) OR (g_pne.pne01 != g_pne_t.pne01) THEN
               LET g_t1 = s_get_doc_no(g_pne.pne01)       #No.FUN-550060
               SELECT smyapr INTO g_smy.smyapr FROM smy_file
                WHERE smyslip=g_t1
               LET g_pne.pnemksg = g_smy.smyapr
               DISPLAY BY NAME g_pne.pnemksg

               SELECT COUNT(*) INTO g_cnt FROM pne_file
                WHERE pne01 = g_pne.pne01
                  AND pne06 = 'N'     #未审核
               IF g_cnt > 0 THEN
                  #尚有未审核的请购变更单,请重新录入
                  CALL cl_err('','apm-171',0)
                  NEXT FIELD pne01
               END IF

               #MOD-CB0261 -- add start --
               SELECT count(*) INTO g_cnt FROM pne_file
                WHERE pne01 = g_pne.pne01
                   AND pneconf IN ('N','n')   #MOD-4B0045
                   AND pne06 <> 'X' #未作廢的 #MOD-4B0045 add
               IF g_cnt > 0 THEN                   # 代表尚有未發出的請購變更單
                  CALL cl_err('','apm1083',0)
                  NEXT FIELD pne01
               END IF
               #MOD-CB0261 -- add end --

               #---->變更序號
               SELECT max(pne02) INTO g_pne.pne02
                FROM  pne_file
                WHERE pne01 = g_pne.pne01
               IF cl_null(g_pne.pne02) THEN
                  LET g_pne.pne02 = 1
               ELSE
                  LET g_pne.pne02 = g_pne.pne02 + 1
               END IF
               DISPLAY BY NAME g_pne.pne02
            END IF
            CALL t900_pne09b()   #请购单号会带币种
         ELSE
            NEXT FIELD pne01
         END IF

      AFTER FIELD pne03
         IF NOT cl_null(g_pne.pne03) THEN
            SELECT pmk04 INTO l_pmk04
              FROM pmk_file
             WHERE pmk01 = g_pne.pne01
            IF g_pne.pne03 < l_pmk04 THEN
               #变更日期不可小于请购日期!
               CALL cl_err('','apm-173',0)
               NEXT FIELD pne03
            END IF
         END IF

      AFTER FIELD pne04   #變更理由
         IF NOT cl_null(g_pne.pne04) THEN
            CALL t900_pne04()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pne.pne04,g_errno,0)
               LET g_pne.pne04 = g_pne_t.pne04
               DISPLAY BY NAME g_pne.pne04
               NEXT FIELD pne04
            END IF
         END IF

      AFTER FIELD pne05  #變更人員
         IF NOT cl_null(g_pne.pne05) THEN
            CALL t900_peo('a',g_pne.pne05)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pne.pne05,g_errno,1)
               LET g_pne.pne05 = g_pne_t.pne05
               DISPLAY BY NAME g_pne.pne05
               NEXT FIELD pne05
            END IF
         END IF

      AFTER FIELD pne09b #幣別
         LET l_azi02b = ' '      #No.FUN-B30081
         IF NOT cl_null(g_pne.pne09b) THEN
            CALL t900_pne09b()  #check 幣別合理性
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pne.pne09b,g_errno,0)
               LET g_pne.pne09b = g_pne_t.pne09b
               DISPLAY BY NAME g_pne.pne09b
               NEXT FIELD pne09b
            END IF
            SELECT azi02 INTO l_azi02b FROM azi_file WHERE azi01=g_pne.pne09b    #No.FUN-B30081
         END IF
         DISPLAY l_azi02b TO FORMONLY.azi02b       #No.FUN-B30081 

      AFTER FIELD pne10b #付款條件
         LET l_pma02b=' '           #No.FUN-B30081
         IF NOT cl_null(g_pne.pne10b) THEN
            CALL t900_pne10b()  #check 付款條件合理性
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pne.pne10b,g_errno,0)
               LET g_pne.pne10b = g_pne_t.pne10b
               DISPLAY BY NAME g_pne.pne10b
               NEXT FIELD pne10b
            END IF
            SELECT pma02 INTO l_pma02b FROM pma_file WHERE pma01=g_pne.pne10b      #No.FUN-B30081
         END IF
         DISPLAY l_pma02b TO FORMONLY.pma02b       #No.FUN-B30081

      AFTER FIELD pne11b #價格條件
         LET l_pnz02b=' '    #No.FUN-B30081 
         IF NOT cl_null(g_pne.pne11b) THEN
            CALL t900_pne11b()  #check 價格條件合理性
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pne.pne11b,g_errno,0)
               LET g_pne.pne11b = g_pne_t.pne11b
               DISPLAY BY NAME g_pne.pne11b
               NEXT FIELD pne11b
            END IF
            SELECT pnz02 INTO l_pnz02b FROM pnz_file WHERE pnz01=g_pne.pne11b    #No.FUN-B30081    
         END IF
         DISPLAY l_pnz02b TO FORMONLY.pnz02b       #No.FUN-B30081

      AFTER FIELD pne12b #送貨地址
         LET l_pme031b = ' '                 #No.FUN-B30081
         LET l_pme032b = ' '                 #No.FUN-B30081 
         IF NOT cl_null(g_pne.pne12b) THEN
            CALL t900_pne12b(g_pne.pne12b)  #check 送貨地址合理性
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pne.pne12b,g_errno,0)
               LET g_pne.pne12b = g_pne_t.pne12b
               DISPLAY BY NAME g_pne.pne12b
               NEXT FIELD pne12b
            END IF
            SELECT pme031,pme032 INTO l_pme031b,l_pme032b FROM pme_file WHERE pme01=g_pne.pne12b AND pme02!='1'  #No.FUN-B30081
         END IF
         DISPLAY l_pme031b TO FORMONLY.pme031b    #No.FUN-B30081
         DISPLAY l_pme032b TO FORMONLY.pme032b    #No.FUN-B30081 

      AFTER FIELD pne13b #發票地址
         LET l_pme031b1 = ' '                 #No.FUN-B30081
         LET l_pme032b1 = ' '                 #No.FUN-B30081
         IF NOT cl_null(g_pne.pne13b) THEN
            CALL t900_pne12b(g_pne.pne13b)  #check 送貨地址合理性
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pne.pne13b,g_errno,0)
               LET g_pne.pne13b = g_pne_t.pne13b
               DISPLAY BY NAME g_pne.pne13b
               NEXT FIELD pne13b
            END IF
            SELECT pme031,pme032 INTO l_pme031b1,l_pme032b1 FROM pme_file WHERE pme01=g_pne.pne13b AND pme02!='0'      #No.FUN-B30081
         END IF
         DISPLAY l_pme031b1 TO FORMONLY.pme031b1    #No.FUN-B30081
         DISPLAY l_pme032b1 TO FORMONLY.pme032b1    #No.FUN-B30081

      AFTER FIELD pneud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD pneud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER INPUT
         LET g_pne.pneuser = s_get_data_owner("pne_file") #FUN-C10039
         LET g_pne.pnegrup = s_get_data_group("pne_file") #FUN-C10039
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         CALL t900_pne09b()
         IF g_pne.pne01 IS NULL THEN            #请购單單號
            LET l_flag='Y'
         END IF
         IF g_pne.pne03 IS NULL THEN            #變更日期
            LET l_flag='Y'
         END IF
         IF l_flag='Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD pne01
         END IF
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913


      ON ACTION CONTROLP
         CASE      #查詢符合條件的單號
             WHEN INFIELD(pne01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmk01"
                LET g_qryparam.default1 = g_pne.pne01
                CALL cl_create_qry() RETURNING g_pne.pne01
                DISPLAY BY NAME g_pne.pne01
                NEXT FIELD pne01
             WHEN INFIELD(pne04) #查詢碼別代號說明資料檔
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_azf01a"
                LET g_qryparam.arg1     = 'B'
                LET g_qryparam.default1 = g_pne.pne04
                CALL cl_create_qry() RETURNING g_pne.pne04
                DISPLAY BY NAME g_pne.pne04
                NEXT FIELD pne04
             WHEN INFIELD(pne05) #變更人員
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.default1 = g_pne.pne05
                CALL cl_create_qry() RETURNING g_pne.pne05
                DISPLAY BY NAME g_pne.pne05
                CALL t900_peo('a',g_pne.pne05)
                NEXT FIELD pne05
             WHEN INFIELD(pne09b) #查詢幣別資料檔
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azi"
                LET g_qryparam.default1 = g_pne.pne09b
                CALL cl_create_qry() RETURNING g_pne.pne09b
                DISPLAY BY NAME g_pne.pne09b
                NEXT FIELD pne09b
             WHEN INFIELD(pne10b) #查詢付款條件資料檔(pma_file)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pma"
                LET g_qryparam.default1 = g_pne.pne10b
                CALL cl_create_qry() RETURNING g_pne.pne10b
                DISPLAY BY NAME g_pne.pne10b
                NEXT FIELD pne10b
             WHEN INFIELD(pne11b) #價格條件
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pnz01"
                LET g_qryparam.default1 = g_pne.pne11b
                CALL cl_create_qry() RETURNING g_pne.pne11b
                DISPLAY BY NAME g_pne.pne11b
                NEXT FIELD pne11b
             WHEN INFIELD(pne12b) #查詢地址資料檔 (0:表送貨地址)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pme"
                LET g_qryparam.default1 = g_pne.pne12b
                CALL cl_create_qry() RETURNING g_pne.pne12b
                DISPLAY BY NAME g_pne.pne12b
                NEXT FIELD pne12b
             WHEN INFIELD(pne13b) #查詢地址資料檔 (1:表帳單地址)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pme"
                LET g_qryparam.default1 = g_pne.pne13b
                LET g_qryparam.arg1     = 1
                CALL cl_create_qry() RETURNING g_pne.pne13b
                DISPLAY BY NAME g_pne.pne13b
                NEXT FIELD pne13b
             OTHERWISE EXIT CASE
         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

   END INPUT
END FUNCTION

#Query 查詢
FUNCTION t900_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   CALL cl_msg("")

   CLEAR FORM
   CALL g_pnf.clear()
   CALL t900_cs()                    #取得查詢條件
   IF INT_FLAG THEN                  #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t900_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pne.pne01 TO NULL
   ELSE
      CALL t900_fetch('F')            #讀出TEMP第一筆並顯示
      OPEN t900_count
      FETCH t900_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF

END FUNCTION

#處理資料的讀取
FUNCTION t900_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1                  #處理方式

   CALL cl_msg("")

   CASE p_flag
       WHEN 'N' FETCH NEXT     t900_b_cs INTO g_pne.pne01,g_pne.pne02
       WHEN 'P' FETCH PREVIOUS t900_b_cs INTO g_pne.pne01,g_pne.pne02
       WHEN 'F' FETCH FIRST    t900_b_cs INTO g_pne.pne01,g_pne.pne02
       WHEN 'L' FETCH LAST     t900_b_cs INTO g_pne.pne01,g_pne.pne02
       WHEN '/'
           IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()

                  ON ACTION about
                     CALL cl_about()

                  ON ACTION help
                     CALL cl_show_help()

                  ON ACTION controlg
                     CALL cl_cmdask()

               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
           END IF
           FETCH ABSOLUTE g_jump t900_b_cs INTO g_pne.pne01,g_pne.pne02
           LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN                         #有麻煩
      INITIALIZE g_pne.* TO NULL
      CALL cl_err(g_pne.pne01,SQLCA.sqlcode,0)
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
   SELECT * INTO g_pne.* FROM pne_file WHERE pne01 = g_pne.pne01 AND pne02 = g_pne.pne02
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_pne.pne01,SQLCA.sqlcode,0)
      INITIALIZE g_pne.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_pne.pneuser
   LET g_data_group = g_pne.pnegrup
   LET g_data_plant = g_pne.pneplant
   CALL t900_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION t900_show()
   DEFINE l_azi02b        LIKE azi_file.azi02,    #No.FUN-B30081 Add
          l_pma02b        LIKE pma_file.pma02,    #No.FUN-B30081 Add
          l_pnz02b        LIKE pnz_file.pnz02,    #No.FUN-B30081 Add
          l_pme031b       LIKE pme_file.pme031,   #No.FUN-B30081 Add
          l_pme032b       LIKE pme_file.pme032,   #No.FUN-B30081 Add
          l_pme031b1      LIKE pme_file.pme031,   #No.FUN-B30081 Add
          l_pme032b1      LIKE pme_file.pme032    #No.FUN-B30081 Add

   LET l_azi02b = ' '       #No.FUN-B30081 Add
   LET l_pma02b = ' '       #No.FUN-B30081 Add
   LET l_pnz02b = ' '       #No.FUN-B30081 Add
   LET l_pme031b = ' '      #No.FUN-B30081 Add
   LET l_pme032b = ' '      #No.FUN-B30081 Add
   LET l_pme031b1 = ' '     #No.FUN-B30081 Add
   LET l_pme032b1 = ' '     #No.FUN-B30081 Add

   LET g_pne_t.* = g_pne.*

   DISPLAY BY NAME 
        g_pne.pne01,g_pne.pne02,g_pne.pne03,g_pne.pne04,g_pne.pne05,g_pne.pne06,
        g_pne.pne14,g_pne.pnemksg,g_pne.pne09,g_pne.pne10,g_pne.pne11,g_pne.pne12,g_pne.pne13,
        g_pne.pne09b,g_pne.pne10b,g_pne.pne11b,g_pne.pne12b,g_pne.pne13b,
        g_pne.pneuser,g_pne.pnegrup,g_pne.pnemodu,g_pne.pnedate,g_pne.pneacti,
        g_pne.pneoriu,g_pne.pneorig,g_pne.pnesendu,g_pne.pnesendd,g_pne.pnesendt,  #FUN-CC0094 add g_pne.pnesendu,g_pne.pnesendd,g_pne.pnesendt
        g_pne.pneud01,g_pne.pneud02,g_pne.pneud03,g_pne.pneud04,
        g_pne.pneud05,g_pne.pneud06,g_pne.pneud07,g_pne.pneud08,
        g_pne.pneud09,g_pne.pneud10,g_pne.pneud11,g_pne.pneud12,
        g_pne.pneud13,g_pne.pneud14,g_pne.pneud15,
        g_pne.pneconf    #FUN-B30076 add

   #CKP
   IF g_pne.pne06='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_pne.pne14='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_pne.pne06,g_chr2,"","",g_chr,"")

   CALL t900_pne01('d')
   CALL t900_pne04()
   CALL t900_peo('d',g_pne.pne05)
   CALL t900_pne09b()
   #No.FUN-B30081
   SELECT azi02 INTO l_azi02b FROM azi_file WHERE azi01=g_pne.pne09b 
   SELECT pma02 INTO l_pma02b FROM pma_file WHERE pma01=g_pne.pne10b  
   SELECT pnz02 INTO l_pnz02b FROM pnz_file WHERE pnz01=g_pne.pne11b
   SELECT pme031,pme032 INTO l_pme031b,l_pme032b FROM pme_file WHERE pme01=g_pne.pne12b AND pme02!='1'
   SELECT pme031,pme032 INTO l_pme031b1,l_pme032b1 FROM pme_file WHERE pme01=g_pne.pne13b AND pme02!='0'        
   DISPLAY l_azi02b TO FORMONLY.azi02b   
   DISPLAY l_pma02b TO FORMONLY.pma02b  
   DISPLAY l_pnz02b TO FORMONLY.pnz02b
   DISPLAY l_pme031b TO FORMONLY.pme031b
   DISPLAY l_pme032b TO FORMONLY.pme032b
   DISPLAY l_pme031b1 TO FORMONLY.pme031b1
   DISPLAY l_pme032b1 TO FORMONLY.pme032b1
   #No.FUN-B30081 
   CALL t900_b_fill(g_wc2)          #單身
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t900_r()
   DEFINE l_flag LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF

   IF g_pne.pne01 IS NULL OR g_pne.pne01 = ' ' THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   #----> 如為'已發出',不可取消
   IF g_pne.pne06 = 'Y' THEN
      CALL cl_err('','apm-242',0)
      RETURN
   END IF
   IF g_pne.pne06 = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_pne.pne14 matches '[Ss1]' THEN 
       CALL cl_err("","mfg3557",0)
       RETURN
   END IF

   BEGIN WORK

   OPEN t900_cl USING g_pne.pne01,g_pne.pne02
   IF STATUS THEN
      CALL cl_err("OPEN t900_cl:", STATUS, 1)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900_cl INTO g_pne.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pne.pne01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t900_show()
   IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "pne01"
      LET g_doc.column2 = "pne02"
      LET g_doc.value1 = g_pne.pne01
      LET g_doc.value2 = g_pne.pne02
      CALL cl_del_doc()

      DELETE FROM pne_file WHERE pne01 = g_pne.pne01
                             AND pne02 = g_pne.pne02
      DELETE FROM pnf_file WHERE pnf01 = g_pne.pne01
                             AND pnf02 = g_pne.pne02
      INITIALIZE g_pne.* TO NULL
      CLEAR FORM
      CALL g_pnf.clear()
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
             VALUES ('apmt900',g_user,g_today,g_msg,g_pne.pne01,'delete',g_plant,g_legal)

      DROP TABLE count_tmp
      PREPARE t900_pre_x2 FROM g_sql_tmp
      EXECUTE t900_pre_x2
      OPEN t900_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t900_b_cs
         CLOSE t900_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t900_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t900_b_cs
         CLOSE t900_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t900_b_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t900_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t900_fetch('/')
      END IF
   END IF
   COMMIT WORK
END FUNCTION

#單身
FUNCTION t900_b()
   DEFINE l_ac_t          LIKE type_file.num5     #未取消的ARRAY CNT
   DEFINE l_n             LIKE type_file.num5     #檢查重複用
   DEFINE l_cnt           LIKE type_file.num5 
   DEFINE l_lock_sw       LIKE type_file.chr1     #單身鎖住否
   DEFINE p_cmd           LIKE type_file.chr1     #處理狀態
   DEFINE l_i             LIKE type_file.num5 
   DEFINE l_allow_insert  LIKE type_file.num5     #可新增否
   DEFINE l_allow_delete  LIKE type_file.num5     #可刪除否
   DEFINE l_pml16         LIKE pml_file.pml16
   DEFINE l_pnf81         LIKE pnf_file.pnf81a
   DEFINE l_pnf84         LIKE pnf_file.pnf84a
   DEFINE l_pnf85         LIKE pnf_file.pnf85a
   DEFINE l_tot           LIKE pnf_file.pnf85a
   DEFINE l_flag          LIKE type_file.chr1
   DEFINE l_date          LIKE type_file.dat 
   DEFINE l_pml21         LIKE pml_file.pml21
   DEFINE l_tf            LIKE type_file.chr1    #FUN-910088--add--
   DEFINE l_pnf04         LIKE pnf_file.pnf04a   #MOD-C30595 -- add
   DEFINE l_fac4          LIKE pmn_file.pmn09    #MOD-C30595 -- add
   DEFINE l_slip          LIKE smy_file.smyslip  #CHI-CB0002 add

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_pne.pne01) THEN
      RETURN
   END IF
   SELECT * INTO g_pne.* FROM pne_file
    WHERE pne01 = g_pne.pne01
      AND pne02 = g_pne.pne02
   IF g_pne.pneacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_pne.pne01,'9028',1)
      RETURN
   END IF
   #--->如為'已確認',不可異動
   IF g_pne.pne06='Y' THEN
      CALL cl_err('','apm-242',1)
      RETURN
   END IF
   IF g_pne.pne06='X' THEN
      CALL cl_err('','9024',1)
      RETURN
   END IF

   IF g_pne.pne14 matches '[Ss]' THEN
      CALL cl_err('','apm-030',0)
      RETURN
   END IF

  #FUN-C30017---mark----str---
  #IF g_pne.pne14 = '1' AND g_pne.pnemksg = 'Y' THEN
  #   CALL cl_err('','mfg3186',0)
  #   RETURN
  #END IF
  #FUN-C30017---mark----end---

   CALL cl_opmsg('b')

   LET g_forupd_sql =
       " SELECT pnf03, '0',    pnf04b, pnf041b, '',      pnf20b, pnf07b, pnf83b,        ",
       "               pnf84b, pnf85b, pnf80b,  pnf81b,  pnf82b, pnf86b, pnf87b, pnf41b,",
       "               pnf12b, pnf121b,pnf122b, pnf33b,                                 ",
       "               '1',    pnf04a, pnf041a, '',      pnf20a, pnf07a, pnf83a,        ",
       "               pnf84a, pnf85a, pnf80a,  pnf81a,  pnf82a, pnf86a, pnf87a, pnf41a,",
       "               pnf12a, pnf121a,pnf122a, pnf33a,  pnf50                          ",
       "  FROM pnf_file  ",
       " WHERE pnf01 = ? ",
       "   AND pnf02 = ? ",
       "   AND pnf03 = ? ",
       "   FOR UPDATE    "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_pnf WITHOUT DEFAULTS FROM s_pnf.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

   BEFORE INPUT
      IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(l_ac)
      END IF

   BEFORE ROW
      LET p_cmd = ''
      LET g_newline = 'N'
      LET l_ac = ARR_CURR()
      LET l_lock_sw = 'N'            #DEFAULT
      LET l_n  = ARR_COUNT()
      BEGIN WORK

      OPEN t900_cl USING g_pne.pne01,g_pne.pne02
      IF STATUS THEN
         CALL cl_err("OPEN t900_cl:", STATUS, 1)
         CLOSE t900_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH t900_cl INTO g_pne.*            # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_pne.pne01,SQLCA.sqlcode,0)      # 資料被他人LOCK
         CLOSE t900_cl
         ROLLBACK WORK
         RETURN
      END IF
      IF g_rec_b>=l_ac THEN
         LET p_cmd='u'
         LET g_pnf_t.* = g_pnf[l_ac].*  #BACKUP
         LET g_pnf03_o = g_pnf[l_ac].pnf03

         OPEN t900_bcl USING g_pne.pne01,g_pne.pne02,g_pnf_t.pnf03
         IF STATUS THEN
            CALL cl_err("OPEN t900_bcl:", STATUS, 1)
         ELSE
            FETCH t900_bcl INTO g_pnf[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_pnf_t.pnf03,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF

            SELECT ima021 INTO g_pnf[l_ac].ima021a FROM ima_file
             WHERE ima01=g_pnf[l_ac].pnf04a
            SELECT ima021 INTO g_pnf[l_ac].ima021b FROM ima_file
             WHERE ima01=g_pnf[l_ac].pnf04b

            CALL t900_set_no_required()
            CALL t900_set_required()
         END IF

         LET g_change='N'
         IF NOT cl_null(g_pnf[l_ac].pnf04a) THEN
            LET g_pnf04 = g_pnf[l_ac].pnf04a
         ELSE
            IF NOT cl_null(g_pnf[l_ac].pnf04b) THEN
               LET g_pnf04 = g_pnf[l_ac].pnf04b
            END IF
         END IF
         IF NOT cl_null(g_pnf04) THEN
            SELECT ima44,ima31,ima906,ima907,ima908
              INTO g_ima44,g_ima31,g_ima906,g_ima907,g_ima908
              FROM ima_file WHERE ima01=g_pnf04
         END IF

         CALL t900_set_entry_b()
         CALL t900_set_no_entry_b()
         CALL t900_set_entry_b1()
         CALL t900_set_no_entry_b1()
         CALL cl_show_fld_cont()
      END IF

   AFTER INSERT
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         CANCEL INSERT
      END IF

      IF g_sma.sma115 = 'Y' THEN
         IF NOT cl_null(g_pnf[l_ac].pnf04a) THEN
            LET g_pnf04 = g_pnf[l_ac].pnf04a
            SELECT ima44,ima31 INTO g_ima44,g_ima31
              FROM ima_file WHERE ima01=g_pnf04

            CALL s_chk_va_setting(g_pnf04)
                 RETURNING g_flag,g_ima906,g_ima907
            IF g_flag=1 THEN
               CANCEL INSERT
            END IF
            CALL s_chk_va_setting1(g_pnf04)
                 RETURNING g_flag,g_ima908
            IF g_flag=1 THEN
               CANCEL INSERT
            END IF
         END IF

         CALL t900_set_origin_field()
      END IF
      INSERT INTO pnf_file(pnf01,pnf02,pnf03,
                           pnf04b,pnf041b,pnf07b,pnf20b,
                           pnf33b,pnf80b,pnf81b,pnf82b,
                           pnf83b,pnf84b,pnf85b,pnf86b,
                           pnf87b,pnf41b,pnf12b,pnf121b,
                           pnf122b,
                           pnf04a,pnf041a,pnf07a,pnf20a,
                           pnf33a,pnf80a,pnf81a,pnf82a,
                           pnf83a,pnf84a,pnf85a,pnf86a,
                           pnf87a,pnf41a,pnf12a,pnf121a,
                           pnf122a,
                           pnf50,pnfplant,pnflegal)
      VALUES(g_pne.pne01,g_pne.pne02, g_pnf[l_ac].pnf03,
             g_pnf[l_ac].pnf04b, g_pnf[l_ac].pnf041b, g_pnf[l_ac].pnf07b,g_pnf[l_ac].pnf20b, 
             g_pnf[l_ac].pnf33b, g_pnf[l_ac].pnf80b,  g_pnf[l_ac].pnf81b,g_pnf[l_ac].pnf82b, 
             g_pnf[l_ac].pnf83b, g_pnf[l_ac].pnf84b,  g_pnf[l_ac].pnf85b,g_pnf[l_ac].pnf86b,
             g_pnf[l_ac].pnf87b, g_pnf[l_ac].pnf41b,  g_pnf[l_ac].pnf12b,g_pnf[l_ac].pnf121b,
             g_pnf[l_ac].pnf122b,
             g_pnf[l_ac].pnf04a, g_pnf[l_ac].pnf041a, g_pnf[l_ac].pnf07a,g_pnf[l_ac].pnf20a, 
             g_pnf[l_ac].pnf33a, g_pnf[l_ac].pnf80a,  g_pnf[l_ac].pnf81a,g_pnf[l_ac].pnf82a, 
             g_pnf[l_ac].pnf83a, g_pnf[l_ac].pnf84a,  g_pnf[l_ac].pnf85a,g_pnf[l_ac].pnf86a,
             g_pnf[l_ac].pnf87a, g_pnf[l_ac].pnf41a,  g_pnf[l_ac].pnf12a,g_pnf[l_ac].pnf121a,
             g_pnf[l_ac].pnf122a,
             g_pnf[l_ac].pnf50,  g_plant,g_legal)
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_pnf[l_ac].pnf03,SQLCA.sqlcode,0)
         CANCEL INSERT
      ELSE
         MESSAGE 'INSERT O.K'
         COMMIT WORK
         LET g_rec_b=g_rec_b+1
         DISPLAY g_rec_b TO FORMONLY.cn2
      END IF

   BEFORE INSERT
      LET l_n = ARR_COUNT()
      LET p_cmd='a'
      LET g_newline = 'N'
      INITIALIZE g_pnf[l_ac].* TO NULL      #900423
      LET g_pnf[l_ac].before = '0'
      LET g_pnf[l_ac].after  = '1'
      LET g_change='N'
      LET g_pnf_t.* = g_pnf[l_ac].*         #新輸入資料
      CALL t900_set_no_required()
      CALL t900_set_required()
      CALL t900_set_entry_b()
      CALL t900_set_no_entry_b()
      CALL t900_set_entry_b1()
      CALL t900_set_no_entry_b1()      
      CALL cl_show_fld_cont()

   BEFORE FIELD pnf03
      CALL t900_set_no_required()
      CALL t900_set_entry_b1()      
 
   AFTER FIELD pnf03
      IF NOT cl_null(g_pnf[l_ac].pnf03) THEN
         #------>是否有重複輸入項次
         IF p_cmd = 'a' OR p_cmd = 'u' AND g_pnf[l_ac].pnf03 <> g_pnf_t.pnf03 THEN
            SELECT COUNT(*) INTO l_n FROM pnf_file
             WHERE pnf01 = g_pne.pne01
               AND pnf02 = g_pne.pne02
               AND pnf03 = g_pnf[l_ac].pnf03
            IF l_n > 0 THEN                  # Duplicated
               CALL cl_err(g_pnf[l_ac].pnf03,-239,0)
               LET g_pnf[l_ac].pnf03 = g_pnf_t.pnf03
               NEXT FIELD pnf03
            END IF

            #请购项次修改
            IF g_pnf[l_ac].pnf03 <> g_pnf03_o THEN   
               IF NOT cl_null(g_pnf[l_ac].pnf04a)  OR
                  NOT cl_null(g_pnf[l_ac].pnf041a) OR
                  NOT cl_null(g_pnf[l_ac].pnf20a)  OR
                  NOT cl_null(g_pnf[l_ac].pnf07a)  OR
                  NOT cl_null(g_pnf[l_ac].pnf83a)  OR
                  NOT cl_null(g_pnf[l_ac].pnf85a)  OR
                  NOT cl_null(g_pnf[l_ac].pnf80a)  OR
                  NOT cl_null(g_pnf[l_ac].pnf82a)  OR
                  NOT cl_null(g_pnf[l_ac].pnf86a)  OR
                  NOT cl_null(g_pnf[l_ac].pnf87a)  OR
                  NOT cl_null(g_pnf[l_ac].pnf41a)  OR
                  NOT cl_null(g_pnf[l_ac].pnf12a)  OR
                  NOT cl_null(g_pnf[l_ac].pnf121a) OR
                  NOT cl_null(g_pnf[l_ac].pnf122a) OR
                  NOT cl_null(g_pnf[l_ac].pnf33a)  THEN
                  #变更后字段已有输入,不允许修改项次.是否清空变更后字段?
                  IF cl_confirm('apm-360') THEN
                     CALL t900_b_init()
                  ELSE
                     LET g_pnf[l_ac].pnf03 = g_pnf03_o
                     NEXT FIELD pnf03
                  END IF
               END IF
            END IF
            LET l_cnt = 0
            #------>判斷此请购單有無此項次(若無代表為新增line)
            SELECT COUNT(*),pml16 INTO l_cnt,l_pml16 FROM pml_file
             WHERE pml01 = g_pne.pne01
               AND pml02 = g_pnf[l_ac].pnf03
             GROUP BY pml16
            IF l_cnt > 0 THEN  #请购资料存在
               IF l_pml16 <> '1' AND l_pml16 <> '2' THEN
                  #资料非审核状态,不可变更!
                  CALL cl_err(g_pnf[l_ac].pnf03,'apm-174',1)
                  NEXT FIELD pnf03
               END IF
            END IF
          #TQC-C30173--add--begin--
            IF s_industry("slk") AND g_azw.azw04 = '2' THEN
               IF l_cnt = 0 THEN
                  CALL cl_err(g_pnf[l_ac].pnf03,'mfg-315',0)
                  LET g_pnf[l_ac].pnf03=g_pnf_t.pnf03
                  NEXT FIELD pnf03
               ELSE
                  CALL t900_pnf03(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     LET g_pnf[l_ac].pnf03=g_pnf_t.pnf03
                     DISPLAY BY NAME g_pnf[l_ac].pnf03
                  END IF
               END IF
            ELSE   
          #TQC-C30173--add--end--
               IF l_cnt = 0 THEN
                  CALL t900_b_init()
                 #CHI-CB0002---add---S
                 #若該單別有做預算控管，則不可由變更新增項次
                 #因為需維護會計科目、費用原因的資料  
                  CALL s_get_doc_no(g_pne.pne01) RETURNING l_slip
                   SELECT smy59 INTO g_smy.smy59 FROM smy_file
                    WHERE smyslip = l_slip
                  IF g_smy.smy59 = 'Y' THEN
                     CALL cl_err(g_pne.pne01,'apm1095',1)
                     NEXT FIELD pnf03 
                  END IF
                 #CHI-CB0002---add---E
               ELSE
                  CALL t900_pnf03(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     LET g_pnf[l_ac].pnf03=g_pnf_t.pnf03
                     DISPLAY BY NAME g_pnf[l_ac].pnf03
                  END IF
               END IF
            END IF  #TQC-C30173 add
         END IF
      END IF
   #CHI-C30112---add---START
      IF cl_null(g_pnf[l_ac].pnf04b) THEN
         #新增項次,所以此欄位不可空白
         CALL cl_set_comp_required("pnf33a",TRUE)
      END IF
   #CHI-C30112---add-----END
      LET g_pnf03_o = g_pnf[l_ac].pnf03
      CALL t900_set_required()
      CALL t900_set_no_entry_b1()      
      
   BEFORE FIELD pnf04a
      IF cl_null(g_pnf[l_ac].pnf03) THEN NEXT FIELD pnf03 END IF
      CALL t900_set_entry_b()

   AFTER FIELD pnf04a
      LET l_tf = NULL    #FUN-C20068--add--
      IF NOT cl_null(g_pnf[l_ac].pnf03) THEN
         IF g_newline='Y' AND cl_null(g_pnf[l_ac].pnf04a) THEN
            #新增項次,所以此欄位不可空白
            CALL cl_err('','apm-915',0)
            NEXT FIELD pnf04a
         END IF
      END IF
      IF (NOT cl_null(g_pnf[l_ac].pnf04a) OR g_pnf[l_ac].pnf04a != g_pnf[l_ac].pnf04b) THEN  #NO:6808
         CALL t900_item_chk1(g_pnf[l_ac].pnf04a)
              RETURNING l_i
         IF l_i = FALSE THEN
            NEXT FIELD pnf04a
         END IF

         IF cl_null(g_pnf_t.pnf04a) OR (g_pnf[l_ac].pnf04a <> g_pnf_t.pnf04a)  THEN
            CALL t900_pnf04a(g_pnf[l_ac].pnf04a) 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pnf[l_ac].pnf04a,g_errno,0)
               LET g_pnf[l_ac].pnf04a = g_pnf_t.pnf04a
               NEXT FIELD pnf04a
            END IF
          #FUN-910088--add--start--
               IF NOT cl_null(g_pnf[l_ac].pnf20a) AND g_pnf[l_ac].pnf20a != 0 THEN
                  CALL t900_pnf20a_check() RETURNING l_tf
               END IF
          #FUN-910088--add--end--
         END IF
      END IF
      IF NOT cl_null(g_pnf[l_ac].pnf04a) AND g_pnf[l_ac].pnf04a != g_pnf[l_ac].pnf04b THEN
         SELECT pml21 INTO l_pml21 FROM pml_file
          WHERE pml01 = g_pne.pne01
            AND pml02 = g_pnf[l_ac].pnf03
         IF cl_null(l_pml21) THEN LET l_pml21 = 0 END IF
         IF l_pml21 > 0 THEN
            #已有采购资料,故请购料号不能做更改!
            CALL cl_err(g_pnf[l_ac].pnf04a,'apm-177',0)
            LET g_pnf[l_ac].pnf04a = NULL
            LET g_pnf[l_ac].pnf041a= NULL
            LET g_pnf[l_ac].ima021a= NULL
            NEXT FIELD pnf04a
         END IF
      END IF      
      IF NOT cl_null(g_pnf[l_ac].pnf04a) THEN
         IF g_sma.sma115 = 'Y' THEN
            CALL s_chk_va_setting(g_pnf[l_ac].pnf04a)
                 RETURNING g_flag,g_ima906,g_ima907
            IF g_flag=1 THEN
               NEXT FIELD pnf04a
            END IF
            CALL s_chk_va_setting1(g_pnf[l_ac].pnf04a)
                 RETURNING g_flag,g_ima908
            IF g_flag=1 THEN
               NEXT FIELD pnf04a
            END IF
            CALL t900_du_default(p_cmd)
         END IF
         LET g_pnf04 = g_pnf[l_ac].pnf04a
         LET g_change='Y'
      ELSE
         LET g_pnf04 = g_pnf[l_ac].pnf04b
      END IF
      SELECT ima44,ima906,ima907,ima908
        INTO g_ima44,g_ima906,g_ima907,g_ima908 FROM ima_file
       WHERE ima01=g_pnf04
      CALL t900_set_no_entry_b()
    #FUN-910088--add--start--
      IF NOT cl_null(l_tf) AND NOT l_tf THEN
         NEXT FIELD pnf20a
      END IF
    #FUN-910088--add--end--
#MOD-D40015 add begin-----------------
      IF NOT cl_null(g_pnf[l_ac].pnf04a) AND g_newline='Y' THEN
         IF g_sma.sma116 MATCHES '[13]' THEN
            IF cl_null(g_pnf[l_ac].pnf86a) THEN 
               LET g_pnf[l_ac].pnf86a = g_ima908
               IF cl_null(g_pnf[l_ac].pnf86a) THEN
                  LET g_pnf[l_ac].pnf86a = g_pnf[l_ac].pnf07a
               END IF 
            END IF
            DISPLAY BY NAME g_pnf[l_ac].pnf86a                    
         END IF 
      END IF      
#MOD-D40015 add end------------------
   #---> 輸入數量後,是否大於未交量
   AFTER FIELD pnf20a
      IF NOT t900_pnf20a_check() THEN NEXT FIELD pnf20a END IF   #FUN-910088--add--
   #FUN-910088--mark--start--
   #  IF g_newline='Y' AND
   #     (cl_null(g_pnf[l_ac].pnf20a) OR g_pnf[l_ac].pnf20a <=0 ) THEN
   #     CALL cl_err('','mfg3331',0)
   #     NEXT FIELD pnf20a
   #  END IF
   #  IF NOT cl_null(g_pnf[l_ac].pnf20a) AND g_pnf[l_ac].pnf20b<>g_pnf[l_ac].pnf20a THEN      
   #     SELECT pml21 INTO l_pml21 FROM pml_file
   #      WHERE pml01 = g_pne.pne01
   #        AND pml02 = g_pnf[l_ac].pnf03
   #     IF cl_null(l_pml21) THEN LET l_pml21 = 0 END IF
   #     IF g_pnf[l_ac].pnf20a < l_pml21 THEN
   #        #请购数量不得小于已转采购数量!
   #        CALL cl_err(g_pnf[l_ac].pnf20a,'apm-178',0)
   #        LET g_pnf[l_ac].pnf20a = NULL
   #        NEXT FIELD pnf20a
   #     END IF
   #  END IF
   #  IF cl_null(g_pnf[l_ac].pnf20b) AND NOT cl_null(g_pnf[l_ac].pnf20a) OR
   #     g_pnf[l_ac].pnf20b<>g_pnf[l_ac].pnf20a THEN      
   #     LET g_change = 'Y' 
   #  END IF
   #  IF g_change = 'Y' THEN
   #     CALL t900_set_pnf87a()
   #  END IF
   #FUN-910088--mark--end--

   #--->單位需存在於單位檔中
   AFTER FIELD pnf07a #请购單位,須存在
      IF g_newline='Y' AND cl_null(g_pnf[l_ac].pnf07a) THEN
          #新增項次,所以此欄位不可空白
          CALL cl_err('','apm-915',0)
      END IF
      IF cl_null(g_pnf[l_ac].pnf07b) AND NOT cl_null(g_pnf[l_ac].pnf07a) OR
         g_pnf[l_ac].pnf07b<>g_pnf[l_ac].pnf07a THEN
         CALL t900_unit(g_pnf[l_ac].pnf07a)   #是否存在於單位檔中
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnf[l_ac].pnf07a,g_errno,0)
            LET g_pnf[l_ac].pnf07a = g_pnf_t.pnf07a
            DISPLAY BY NAME g_pnf[l_ac].pnf07a
            NEXT FIELD pnf07a
         END IF
         IF g_sma.sma116 MATCHES '[02]' THEN
            LET g_pnf[l_ac].pnf86a = g_pnf[l_ac].pnf07a
         END IF
         LET g_change = 'Y'
      END IF
#MOD-C30595 -- add -- begin
      IF NOT cl_null(g_pnf[l_ac].pnf07a) THEN
         IF cl_null(g_pnf[l_ac].pnf04a) THEN
            LET l_pnf04 = g_pnf[l_ac].pnf04b
         ELSE
            LET l_pnf04 = g_pnf[l_ac].pnf04a
         END IF
         IF l_pnf04[1,4] <> 'MISC' THEN
            CALL s_umfchk(l_pnf04,g_pnf[l_ac].pnf07a,g_pnf[l_ac].pnf07b)
                 RETURNING l_flag,l_fac4
            IF l_flag=1 THEN
            ##### -----單位換算率抓不到----#####
               CALL cl_err('','art-032',1)
               NEXT FIELD pnf07a
            END IF
         ELSE
            LET g_pnf[l_ac].pnf07a = g_pnf[l_ac].pnf07b
         END IF
      END IF
#MOD-C30595 -- add -- end
      IF g_change = 'Y' THEN
         CALL t900_set_pnf87a()
      END IF
    #FUN-910088--add--start--
      IF NOT cl_null(g_pnf[l_ac].pnf20a) AND g_pnf[l_ac].pnf20a != 0 THEN
         IF NOT t900_pnf20a_check() THEN
            NEXT FIELD pnf20a
         END IF
      END IF
    #FUN-910088--add--end--
   AFTER FIELD pnf83a  #第二單位
      LET l_tf = NULL     #FUN-C20068--add--
      IF cl_null(g_pnf[l_ac].pnf83b) AND NOT cl_null(g_pnf[l_ac].pnf83a) OR
         g_pnf[l_ac].pnf83b<>g_pnf[l_ac].pnf83a THEN
         LET g_change = 'Y'
      END IF
      IF NOT cl_null(g_pnf[l_ac].pnf83a) THEN
         CALL t900_unit(g_pnf[l_ac].pnf83a)   #是否存在於單位檔中
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnf[l_ac].pnf83a,g_errno,0)
            LET g_pnf[l_ac].pnf83a = g_pnf_t.pnf83a
            DISPLAY BY NAME g_pnf[l_ac].pnf83a
            NEXT FIELD pnf83a
         END IF
         CALL s_du_umfchk(g_pnf04,'','','',
                          g_ima44,g_pnf[l_ac].pnf83a,g_ima906)
              RETURNING g_errno,g_factor
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnf[l_ac].pnf83a,g_errno,0)
            NEXT FIELD pnf83a
         END IF
         LET g_pnf[l_ac].pnf84a = g_factor
      #FUN-910088--add--start--
         IF NOT cl_null(g_pnf[l_ac].pnf85a) AND g_pnf[l_ac].pnf85a != 0 THEN
            CALL t900_pnf85a_check(p_cmd) RETURNING l_tf
         END IF
      #FUN-910088--add--end--
      END IF
      CALL cl_show_fld_cont()
     #FUN-910088--add--start--
      IF NOT cl_null(l_tf) AND NOT l_tf THEN
         NEXT FIELD pnf85a
      END IF
    #FUN-910088--add--end--

   AFTER FIELD pnf85a  #第二數量
      IF NOT t900_pnf85a_check(p_cmd) THEN NEXT FIELD pnf85a END IF   #FUN-910088--add--
   #FUN-910088--mark--start--
   #  IF cl_null(g_pnf[l_ac].pnf85b) AND NOT cl_null(g_pnf[l_ac].pnf85a) OR
   #     g_pnf[l_ac].pnf85b<>g_pnf[l_ac].pnf85a THEN
   #     LET g_change = 'Y'
   #  END IF
   #  IF NOT cl_null(g_pnf[l_ac].pnf85a) THEN
   #     IF g_pnf[l_ac].pnf85a < 0 THEN
   #        CALL cl_err('','aim-391',0)  #
   #        NEXT FIELD pnf85a
   #     END IF
   #     IF p_cmd = 'a' OR  p_cmd = 'u' AND
   #        g_pnf_t.pnf85a <> g_pnf[l_ac].pnf85a THEN
   #        IF g_ima906='3' THEN
   #           LET l_pnf84 = g_pnf[l_ac].pnf84b
   #           LET l_pnf85 = g_pnf[l_ac].pnf85b
   #           LET l_pnf81 = g_pnf[l_ac].pnf81b
   #           IF NOT cl_null(g_pnf[l_ac].pnf84a) THEN
   #              LET l_pnf84 = g_pnf[l_ac].pnf84a
   #           END IF
   #           IF NOT cl_null(g_pnf[l_ac].pnf85a) THEN
   #              LET l_pnf85 = g_pnf[l_ac].pnf85a
   #           END IF
   #           IF NOT cl_null(g_pnf[l_ac].pnf81a) THEN
   #              LET l_pnf81 = g_pnf[l_ac].pnf81a
   #           END IF
   #           LET l_tot=l_pnf85*l_pnf84
   #           LET g_pnf[l_ac].pnf82a=l_tot*l_pnf81
   #           DISPLAY BY NAME g_pnf[l_ac].pnf82a 
   #        END IF
   #     END IF
   #  END IF
   #  IF g_change = 'Y' THEN
   #     CALL t900_set_pnf87a()
   #  END IF
   #  CALL cl_show_fld_cont()
   #FUN-910088--mark--end--

   AFTER FIELD pnf80a  #第一單位
      LET l_tf = NULL       #TQC-C20183--add--
      IF cl_null(g_pnf[l_ac].pnf80b) AND NOT cl_null(g_pnf[l_ac].pnf80a) OR
         g_pnf[l_ac].pnf80b<>g_pnf[l_ac].pnf80a THEN
         LET g_change = 'Y'
      END IF
      IF NOT cl_null(g_pnf[l_ac].pnf80a) THEN
         CALL t900_unit(g_pnf[l_ac].pnf80a)   #是否存在於單位檔中
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnf[l_ac].pnf80a,g_errno,0)
            LET g_pnf[l_ac].pnf80a = g_pnf_t.pnf80a
            DISPLAY BY NAME g_pnf[l_ac].pnf80a
            NEXT FIELD pnf80a
         END IF
         CALL s_du_umfchk(g_pnf04,'','','',
                          g_ima44,g_pnf[l_ac].pnf80a,'1')
              RETURNING g_errno,g_factor
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnf[l_ac].pnf80a,g_errno,0)
            NEXT FIELD pnf80a
         END IF
         LET g_pnf[l_ac].pnf81a = g_factor
      #FUN-910088--add--start--
         IF NOT cl_null(g_pnf[l_ac].pnf82a) AND g_pnf[l_ac].pnf82a != 0 THEN
            CALL t900_pnf82a_check() RETURNING l_tf           
         END IF
      #FUN-910088--add--end--
      END IF
      CALL cl_show_fld_cont()
  #FUN-910088--add--start--
      IF NOT cl_null(l_tf) AND NOT l_tf THEN
         NEXT FIELD pnf82a
      END IF
  #FUN-910088--add--end--
   AFTER FIELD pnf82a  #第一數量
      IF NOT t900_pnf82a_check() THEN NEXT FIELD pnf82a END IF   #FUN-910088--add--
   #FUN-910088--mark--start--
   #  IF cl_null(g_pnf[l_ac].pnf82b) AND NOT cl_null(g_pnf[l_ac].pnf82a) OR
   #     g_pnf[l_ac].pnf82b<>g_pnf[l_ac].pnf82a THEN
   #     LET g_change = 'Y'
   #  END IF
   #  IF NOT cl_null(g_pnf[l_ac].pnf82a) THEN
   #     IF g_pnf[l_ac].pnf82a < 0 THEN
   #        CALL cl_err('','aim-391',0)  #
   #        NEXT FIELD pnf82a
   #     END IF
   #  END IF
   #  #計算pnf20,pnf07的值,檢查數量的合理性
   #  CALL t900_set_origin_field()
   #  IF g_change = 'Y' THEN
   #     CALL t900_set_pnf87a()
   #  END IF
   #  CALL cl_show_fld_cont()
   #FUN-910088--mark--end--

   AFTER FIELD pnf86a
      LET l_tf = NULL      #TQC-C20183--add--
      IF cl_null(g_pnf[l_ac].pnf86b) AND NOT cl_null(g_pnf[l_ac].pnf86a) OR
         g_pnf[l_ac].pnf86b<>g_pnf[l_ac].pnf86a THEN
         LET g_change = 'Y'
      END IF
      IF NOT cl_null(g_pnf[l_ac].pnf86a) THEN
         CALL t900_unit(g_pnf[l_ac].pnf86a)   #是否存在於單位檔中
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnf[l_ac].pnf86a,g_errno,0)
            LET g_pnf[l_ac].pnf86a = g_pnf_t.pnf86a
            DISPLAY BY NAME g_pnf[l_ac].pnf86a
            NEXT FIELD pnf86a
         END IF
         CALL s_du_umfchk(g_pnf04,'','','',
                          g_ima44,g_pnf[l_ac].pnf86a,'1')
              RETURNING g_errno,g_factor
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnf[l_ac].pnf86a,g_errno,0)
            NEXT FIELD pnf86a
         END IF
      #FUN-910088--add--start--
         IF NOT cl_null(g_pnf[l_ac].pnf87a) AND g_pnf[l_ac].pnf87a != 0 THEN
            CALL t900_pnf87a_check() RETURNING l_tf
         END IF
      #FUN-910088--add--end--
      END IF
      IF g_change = 'Y' THEN
         CALL t900_set_pnf87a()
      END IF
    #FUN-910088--add-start--
      IF NOT cl_null(l_tf) AND NOT l_tf THEN 
         NEXT FIELD pnf87a
      END IF
    #FUN-910088--add--end--
   BEFORE FIELD pnf87a
       IF g_change = 'Y' THEN
          CALL t900_set_pnf87a()
       END IF

   AFTER FIELD pnf87a
      IF NOT t900_pnf87a_check() THEN NEXT FIELD pnf87a END IF  #FUN-910088--add--
     #FUN-910088--mark--start--
     #IF NOT cl_null(g_pnf[l_ac].pnf87a) THEN
     #   IF g_pnf[l_ac].pnf87a < 0 THEN
     #      CALL cl_err('','aim-391',0)  #
     #      NEXT FIELD pnf87a
     #   END IF
     #END IF
     #FUN-910088--mark--end--
      
   BEFORE FIELD pnf12a
      CALL t900_set_entry_b1()
      
   AFTER FIELD pnf12a
      IF NOT cl_null(g_pnf[l_ac].pnf12a) THEN     
         CALL t900_pnf12a()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnf[l_ac].pnf12a,g_errno,0)
            LET g_pnf[l_ac].pnf12a = g_pnf_t.pnf12a
            DISPLAY BY NAME g_pnf[l_ac].pnf12a
            NEXT FIELD pnf12a
         END IF
      END IF
      CALL t900_set_no_entry_b1()      
      
   BEFORE FIELD pnf121a
      CALL t900_set_entry_b1()   
         
   AFTER FIELD pnf121a
      IF NOT cl_null(g_pnf[l_ac].pnf12a) THEN     
         CALL t900_pnf121a()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnf[l_ac].pnf121a,g_errno,0)
            LET g_pnf[l_ac].pnf121a = g_pnf_t.pnf121a
            DISPLAY BY NAME g_pnf[l_ac].pnf121a
            NEXT FIELD pnf121a
         END IF
      END IF
      CALL t900_set_no_entry_b1()
      
   AFTER FIELD pnf122a
      IF NOT cl_null(g_pnf[l_ac].pnf12a) OR 
         g_pnf[l_ac].pnf121a IS NOT NULL OR
         g_pnf[l_ac].pnf122a IS NOT NULL THEN
         CALL t900_pnf12a()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnf[l_ac].pnf12a,g_errno,0)
            LET g_pnf[l_ac].pnf12a = g_pnf_t.pnf12a
            DISPLAY BY NAME g_pnf[l_ac].pnf12a
            NEXT FIELD pnf12a    
         END IF
         CALL t900_pnf121a()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnf[l_ac].pnf121a,g_errno,0)
            LET g_pnf[l_ac].pnf121a = g_pnf_t.pnf121a
            DISPLAY BY NAME g_pnf[l_ac].pnf121a
            NEXT FIELD pnf121a
         END IF
         CALL t900_pnf122a()
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pnf[l_ac].pnf122a,g_errno,0)
            LET g_pnf[l_ac].pnf122a = g_pnf_t.pnf122a
            DISPLAY BY NAME g_pnf[l_ac].pnf122a
            NEXT FIELD pnf122a
         END IF         
      END IF
      
   AFTER FIELD pnf33a
   #CHI-C30112---add---START
      IF g_newline='Y' AND cl_null(g_pnf[l_ac].pnf33a) THEN
         #新增項次,所以此欄位不可空白
         CALL cl_err('','apm-915',0)
         NEXT FIELD pnf33a
      END IF
   #CHI-C30112---add-----END
      IF g_pnf[l_ac].pnf33a IS NOT NULL THEN
         IF g_pnf[l_ac].pnf33a < g_pne.pne03 THEN
            CALL cl_err('','apm-054',0)
            NEXT FIELD pnf33a
         END IF
         CALL s_wkday(g_pnf[l_ac].pnf33a) RETURNING l_flag,l_date
         IF l_date IS NULL OR l_date = ' ' THEN
            NEXT FIELD pnf33a
         ELSE
            LET g_pnf[l_ac].pnf33a = l_date
         END IF
      END IF

   BEFORE DELETE                            #是否取消單身
      IF g_pnf_t.pnf03 > 0 AND
         g_pnf_t.pnf03 IS NOT NULL THEN
          IF NOT cl_delb(0,0) THEN
             CANCEL DELETE
          END IF
          IF l_lock_sw = "Y" THEN
             CALL cl_err("", -263, 1)
             CANCEL DELETE
          END IF
          DELETE FROM pnf_file
           WHERE pnf01 = g_pne.pne01
             AND pnf02 = g_pne.pne02
             AND pnf03 = g_pnf_t.pnf03
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_pnf_t.pnf03,SQLCA.sqlcode,0)
             ROLLBACK WORK
             CANCEL DELETE
          END IF
          LET g_rec_b=g_rec_b-1
          DISPLAY g_rec_b TO FORMONLY.cn2
          COMMIT WORK
      END IF


   ON ROW CHANGE
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_pnf[l_ac].* = g_pnf_t.*
         CLOSE t900_bcl
         ROLLBACK WORK
         EXIT INPUT
      END IF
      IF l_lock_sw = 'Y' THEN
         CALL cl_err(g_pnf[l_ac].pnf03,-263,1)
         LET g_pnf[l_ac].* = g_pnf_t.*
      ELSE
         IF g_sma.sma115 = 'Y' THEN
            IF NOT cl_null(g_pnf[l_ac].pnf04a) THEN
               CALL s_chk_va_setting(g_pnf[l_ac].pnf04a)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD pnf04a
               END IF
               CALL s_chk_va_setting1(g_pnf[l_ac].pnf04a)
                    RETURNING g_flag,g_ima908
               IF g_flag=1 THEN
                  NEXT FIELD pnf04a
               END IF
            END IF

            CALL t900_set_origin_field()
         END IF
         UPDATE pnf_file SET
              pnf03  = g_pnf[l_ac].pnf03,
              pnf04a = g_pnf[l_ac].pnf04a,
              pnf041a= g_pnf[l_ac].pnf041a,
              pnf20a = g_pnf[l_ac].pnf20a,
              pnf07a = g_pnf[l_ac].pnf07a,
              pnf83a = g_pnf[l_ac].pnf83a,
              pnf84a = g_pnf[l_ac].pnf84a,
              pnf85a = g_pnf[l_ac].pnf85a,
              pnf80a = g_pnf[l_ac].pnf80a,
              pnf81a = g_pnf[l_ac].pnf81a,
              pnf82a = g_pnf[l_ac].pnf82a,
              pnf86a = g_pnf[l_ac].pnf86a,
              pnf87a = g_pnf[l_ac].pnf87a,
              pnf41a = g_pnf[l_ac].pnf41a,
              pnf12a = g_pnf[l_ac].pnf12a,
              pnf121a= g_pnf[l_ac].pnf121a,
              pnf122a= g_pnf[l_ac].pnf122a,
              pnf33a = g_pnf[l_ac].pnf33a,
              pnf50  = g_pnf[l_ac].pnf50
         WHERE pnf01  = g_pne.pne01
           AND pnf02  = g_pne.pne02
           AND pnf03  = g_pnf_t.pnf03
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_pnf[l_ac].pnf03,SQLCA.sqlcode,0)
            LET g_pnf[l_ac].* = g_pnf_t.*
         ELSE
            MESSAGE 'UPDATE O.K'
            COMMIT WORK
         END IF
      END IF         
       
   AFTER ROW
      LET l_ac = ARR_CURR()
   #  LET l_ac_t = l_ac   #FUN-D30034
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         IF p_cmd = 'u' THEN
            LET g_pnf[l_ac].* = g_pnf_t.*
      #FUN-D30034--add--str--
         ELSE
            CALL g_pnf.deleteElement(l_ac)
            IF g_rec_b != 0 THEN
               LET g_action_choice = "detail"
               LET l_ac = l_ac_t
            END IF
      #FUN-D30034--add--end--
         END IF
         CLOSE t900_bcl

         ROLLBACK WORK
         EXIT INPUT
      END IF
      LET l_ac_t = l_ac   #FUN-D30034
      CLOSE t900_bcl
      COMMIT WORK

   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(pnf03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pml5"
              LET g_qryparam.default1 = g_pnf[l_ac].pnf03
              LET g_qryparam.arg1 = g_pne.pne01
              CALL cl_create_qry() RETURNING g_pnf[l_ac].pnf03
              DISPLAY g_pnf[l_ac].pnf03 TO pnf03
              NEXT FIELD pnf03
         WHEN INFIELD(pnf04a) #料件編號
#             CALL cl_init_qry_var()                       #FUN-AB0025 mark
              LET g_t1 =g_pne.pne01[1,g_doc_len]
              SELECT smy62 INTO g_smy62 FROM smy_file
               WHERE smyslip =g_t1
              IF g_sma.sma120 ='Y' AND g_sma.sma907 ='Y' AND NOT cl_null(g_smy62) THEN
#FUN-AB0025---------mod-----------str----------------
#                LET g_qryparam.form     = "q_ima19"      
#                LET g_qryparam.arg1= g_smy62             
#                LET g_qryparam.default1 = g_pnf[l_ac].pnf04a
                 CALL q_sel_ima(FALSE, "q_ima19","",g_pnf[l_ac].pnf04a,g_smy62,"","","","",'' ) 
                    RETURNING g_pnf[l_ac].pnf04a
#FUN-AB0025---------mod-----------end------------------
              ELSE
#FUN-AB0025---------mod-----------str----------------
#                LET g_qryparam.form = "q_ima"
#                LET g_qryparam.default1 = g_pnf[l_ac].pnf04a
                 CALL q_sel_ima(FALSE, "q_ima","",g_pnf[l_ac].pnf04a,"","","","","",'' ) 
                     RETURNING g_pnf[l_ac].pnf04a
#FUN-AB0025---------mod-----------end------------------
              END IF
#             CALL cl_create_qry() RETURNING g_pnf[l_ac].pnf04a   #FUN-AB0025 mark
              DISPLAY g_pnf[l_ac].pnf04a TO pnf04a
         WHEN INFIELD(pnf07a) #请购單位
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gfe"
              LET g_qryparam.default1 = g_pnf[l_ac].pnf07a
              CALL cl_create_qry() RETURNING g_pnf[l_ac].pnf07a
              DISPLAY g_pnf[l_ac].pnf07a TO pnf07a
              NEXT FIELD pnf07a
         WHEN INFIELD(pnf80a) #單位
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gfe"
              LET g_qryparam.default1 = g_pnf[l_ac].pnf80a
              CALL cl_create_qry() RETURNING g_pnf[l_ac].pnf80a
              DISPLAY BY NAME g_pnf[l_ac].pnf80a
              NEXT FIELD pnf80a

         WHEN INFIELD(pnf83a) #單位
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gfe"
              LET g_qryparam.default1 = g_pnf[l_ac].pnf83a
              CALL cl_create_qry() RETURNING g_pnf[l_ac].pnf83a
              DISPLAY BY NAME g_pnf[l_ac].pnf83a
              NEXT FIELD pnf83a

         WHEN INFIELD(pnf86a) #計價單位
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gfe"
              LET g_qryparam.default1 = g_pnf[l_ac].pnf86a
              CALL cl_create_qry() RETURNING g_pnf[l_ac].pnf86a
              DISPLAY BY NAME g_pnf[l_ac].pnf86a
              NEXT FIELD pnf86a
         WHEN INFIELD(pnf12a) #项目
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_pja2"
              LET g_qryparam.default1 = g_pnf[l_ac].pnf12a
              CALL cl_create_qry() RETURNING g_pnf[l_ac].pnf12a
              DISPLAY BY NAME g_pnf[l_ac].pnf12a
              NEXT FIELD pnf12a
         WHEN INFIELD(pnf121a) #WBS
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_pjb4"
              LET g_qryparam.default1 = g_pnf[l_ac].pnf121a
              LET g_qryparam.arg1 = g_pnf[l_ac].pnf12a
              CALL cl_create_qry() RETURNING g_pnf[l_ac].pnf121a
              DISPLAY BY NAME g_pnf[l_ac].pnf121a
              NEXT FIELD pnf121a
         WHEN INFIELD(pnf122a) #活動
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_pjk3"
              LET g_qryparam.default1 = g_pnf[l_ac].pnf122a
              LET g_qryparam.arg1 = g_pnf[l_ac].pnf121a
              CALL cl_create_qry() RETURNING g_pnf[l_ac].pnf122a
              DISPLAY BY NAME g_pnf[l_ac].pnf122a
              NEXT FIELD pnf122a
         OTHERWISE EXIT CASE
      END CASE

   ON ACTION CONTROLR
      CALL cl_show_req_fields()

   ON ACTION controls
      CALL cl_set_head_visible("","AUTO")

   ON ACTION CONTROLG
      CALL cl_cmdask()

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE INPUT
   
   ON ACTION about
      CALL cl_about()
   
   ON ACTION help
      CALL cl_show_help()


   END INPUT
   UPDATE pne_file SET pnemodu=g_user,pnedate=g_today,pne14='0'
    WHERE pne01=g_pne.pne01
      AND pne02=g_pne.pne02
   DISPLAY BY NAME g_pne.pnemodu,g_pne.pnedate,g_pne.pne14
   CLOSE t900_bcl
   COMMIT WORK

   #因為可只變更單頭,故可不輸入單身
#  CALL t900_delall()  #CHI-C30002 mark
   CALL t900_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t900_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_pne.pne01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM pne_file ",
                  "  WHERE pne01 LIKE '",l_slip,"%' ",
                  "    AND pne01 > '",g_pne.pne01,"'"
      PREPARE t900_pb1 FROM l_sql 
      EXECUTE t900_pb1 INTO l_cnt 
      
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
         #CALL t900_x() #FUN-D20025 mark
         CALL t900_x(1) #FUN-D20025 add
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM pne_file WHERE pne01=g_pne.pne01 AND pne02=g_pne.pne02
         INITIALIZE g_pne.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t900_set_required()
   DEFINE l_newline LIKE type_file.chr1
   DEFINE l_pnf03   LIKE pnf_file.pnf03
   DEFINE l_cnt     LIKE type_file.num5

   LET l_newline = 'N'
   IF NOT cl_null(g_pnf[l_ac].pnf03) THEN
      SELECT COUNT(*) INTO l_cnt FROM pml_file
       WHERE pml01 = g_pne.pne01
         AND pml02 = g_pnf[l_ac].pnf03
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN
         LET l_newline = 'N'
      ELSE
         LET l_newline = 'Y'
      END IF
   END IF
   
   IF l_newline='Y' THEN
      CALL cl_set_comp_required("pnf04a",TRUE)
      IF g_sma.sma115 = 'Y' THEN
         IF g_ima906 = '1' THEN   #单一单位
            CALL cl_set_comp_required("pnf80a,pnf82a",TRUE)
         END IF
         IF g_ima906 = '3' THEN   #参考单位
            CALL cl_set_comp_required("pnf80a,pnf82a,pnf83a,pnf85a",TRUE)
         END IF
      ELSE
         CALL cl_set_comp_required("pnf07a,pnf20a",TRUE)
      END IF
      IF g_sma.sma116 ='1' OR g_sma.sma116 ='3' THEN
         CALL cl_set_comp_required("pnf86a,pnf87a",TRUE)
      END IF
   END IF
   LET g_newline = l_newline

END FUNCTION

FUNCTION t900_set_no_required()

   CALL cl_set_comp_required("pnf04a,pnf20a,pnf07a",FALSE)
   CALL cl_set_comp_required("pnf86a,pnf87a",FALSE)
   CALL cl_set_comp_required("pnf33a",FALSE) #CHI-C30112 add
   IF g_sma.sma115 = 'Y' THEN
      CALL cl_set_comp_required("pnf80a,pnf82a,pnf83a,pnf85a",FALSE)
   END IF
END FUNCTION

FUNCTION t900_set_entry_b1()
   CALL cl_set_comp_entry("pnf12a,pnf121a,pnf122a",TRUE)
 #TQC-C30173--add--begin--
   IF s_industry("slk") AND g_azw.azw04 = '2' THEN
      CALL cl_set_comp_entry("pnf12a,pnf121a,pnf122a",FALSE)
   END IF
 #TQC-C30173--add--end--  
END FUNCTION

FUNCTION t900_set_no_entry_b1()
   DEFINE l_pml24    LIKE pml_file.pml24
   DEFINE l_pnf12    LIKE pnf_file.pnf12a
   DEFINE l_pnf121   LIKE pnf_file.pnf121a
   DEFINE l_pjb25    LIKE pjb_file.pjb25
   
   IF NOT cl_null(g_pnf[l_ac].pnf03) THEN
      SELECT pml24 INTO l_pml24 FROM pml_file
       WHERE pml01 = g_pne.pne01
         AND pml02 = g_pnf[l_ac].pnf03
      IF NOT cl_null(l_pml24) THEN
         CALL cl_set_comp_entry("pnf12a,pnf121a,pnf122a",FALSE)
      ELSE
      	 LET l_pnf12 = g_pnf[l_ac].pnf12b
      	 LET l_pnf121= g_pnf[l_ac].pnf121b
      	 IF NOT cl_null(g_pnf[l_ac].pnf12a) THEN
      	    LET l_pnf12 = g_pnf[l_ac].pnf12a
      	 END IF
      	 IF NOT cl_null(g_pnf[l_ac].pnf121a) THEN
      	    LET l_pnf121= g_pnf[l_ac].pnf121a
      	 END IF
      	 IF l_pnf12 IS NOT NULL AND l_pnf121 IS NOT NULL THEN
      	    SELECT pjb25 INTO l_pjb25 FROM pjb_file
      	     WHERE pjb01 = l_pnf12
      	       AND pjb02 = l_pnf121
      	    IF cl_null(l_pjb25) OR l_pjb25 <> 'Y' THEN
      	       CALL cl_set_comp_entry("pnf122a",FALSE)
      	       LET g_pnf[l_ac].pnf122a = ' '
      	    END IF
      	 END IF
      END IF
   END IF
 #TQC-C30173--add--begin--
   IF s_industry("slk") AND g_azw.azw04 = '2' THEN
      CALL cl_set_comp_entry("pnf12a,pnf121a,pnf122a",FALSE)
   END IF
 #TQC-C30173--add--end--
END FUNCTION

FUNCTION t900_set_entry_b()

   IF g_sma.sma115 = 'Y' THEN
      CALL cl_set_comp_entry("pnf80a,pnf82a,pnf83a,pnf85a,pnf86a,pnf87a",TRUE)
   END IF

   CALL cl_set_comp_entry("pnf041a",FALSE)   #pnf041a正好相反,正常情况下不能KEY IN

END FUNCTION

FUNCTION t900_set_no_entry_b()
   DEFINE l_n LIKE type_file.num5

   IF g_sma.sma115 = 'Y' THEN
      IF g_ima906 = '1' THEN
         CALL cl_set_comp_entry("pnf83a,pnf85a",FALSE)
      END IF
      #參考單位，每個料件只有一個，所以不開放讓用戶輸入
      IF g_ima906 = '3' THEN
         CALL cl_set_comp_entry("pnf83a",FALSE)
      END IF
      IF g_sma.sma116 MATCHES '[02]' THEN
         CALL cl_set_comp_entry("pnf86a,pnf87a",FALSE)
      END IF
   END IF

   IF l_ac > 0 THEN
      IF NOT cl_null(g_pnf[l_ac].pnf04a) THEN
         IF g_pnf[l_ac].pnf04a[1,4] = 'MISC' THEN
            CALL cl_set_comp_entry("pnf041a",TRUE)
         END IF
      ELSE
         IF g_pnf[l_ac].pnf04b[1,4] = 'MISC' THEN
            CALL cl_set_comp_entry("pnf041a",TRUE)
         END IF
      END IF
   END IF
 #TQC-C30173--add--begin--
   IF s_industry("slk") AND g_azw.azw04 = '2' THEN
      CALL cl_set_comp_entry("pnf04a,pnf041a,ima021a,pnf07a,pnf83a,pnf84a,pnf85a,
                              pnf80a,pnf81a,pnf82a,pnf87a,pnf41a,pnf12a,pnf121a,pnf122a,
                              pnf33a",FALSE)
   END IF
 #TQC-C30173--add--end--

END FUNCTION

#CHI-C30002 -------- mark -------- begin
#FUNCTION t900_delall()      # 未輸入單身資料, 是否取消單頭資料
#  DEFINE l_flag LIKE type_file.chr1
#  SELECT COUNT(*) INTO g_cnt FROM pnf_file
#   WHERE pnf01 = g_pne.pne01
#     AND pnf02 = g_pne.pne02
#  IF g_cnt = 0 THEN
#     #若單頭也無任何變更
#     IF cl_null(g_pne.pne09b)
#        AND cl_null(g_pne.pne10b)
#        AND cl_null(g_pne.pne11b)   
#        AND cl_null(g_pne.pne12b)
#        AND cl_null(g_pne.pne13b) THEN
#        CALL cl_err(g_pne.pne01,9044,0)
#        DELETE FROM pne_file WHERE pne01 = g_pne.pne01 AND pne02 = g_pne.pne02
#        DELETE FROM pnf_file WHERE pnf01 = g_pne.pne01 AND pnf02 = g_pne.pne02
#        CLEAR FORM
#        CALL g_pnf.clear()
#     END IF
#  END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end

FUNCTION  t900_pnf03(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1

   LET g_errno = ' '

   SELECT pml04, pml041,pml07, pml20, pml83, pml84, pml85 ,pml80,
          pml81, pml82, pml86, pml87, pml41, pml12, pml121,pml122,
          pml33
     INTO g_pnf[l_ac].pnf04b, g_pnf[l_ac].pnf041b, g_pnf[l_ac].pnf07b,
          g_pnf[l_ac].pnf20b, g_pnf[l_ac].pnf83b,g_pnf[l_ac].pnf84b,
          g_pnf[l_ac].pnf85b, g_pnf[l_ac].pnf80b,g_pnf[l_ac].pnf81b,
          g_pnf[l_ac].pnf82b, g_pnf[l_ac].pnf86b,g_pnf[l_ac].pnf87b,
          g_pnf[l_ac].pnf41b, g_pnf[l_ac].pnf12b,g_pnf[l_ac].pnf121b,
          g_pnf[l_ac].pnf122b,g_pnf[l_ac].pnf33b
     FROM pml_file
    WHERE pml01 = g_pne.pne01 AND pml02 = g_pnf[l_ac].pnf03

   SELECT ima021 INTO g_pnf[l_ac].ima021b FROM ima_file
    WHERE ima01=g_pnf[l_ac].pnf04b
END FUNCTION

FUNCTION t900_pnf04a(p_no)            #料件編號
   DEFINE l_imaacti LIKE ima_file.imaacti
   DEFINE p_no      LIKE pml_file.pml04
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_ima021  LIKE ima_file.ima021
   DEFINE l_ima44   LIKE ima_file.ima44

   IF p_no[1,4] = 'MISC' THEN
      LET p_no = 'MISC'
   END IF 

   LET g_errno = " "
   SELECT imaacti,ima02,ima44,ima021          #品名及單位
     INTO l_imaacti,l_ima02,l_ima44,l_ima021
     FROM ima_file
    WHERE ima01 = p_no

   CASE WHEN SQLCA.SQLCODE = 100          LET g_errno = 'mfg0002'
                                          LET l_ima02 = NULL
                                          LET l_ima021= NULL
                                          LET l_ima44 = NULL
        WHEN l_imaacti='N'                LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'     LET g_errno = '9038'
        OTHERWISE                         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   LET g_pnf[l_ac].pnf041a = l_ima02
   LET g_pnf[l_ac].ima021a = l_ima021
   IF g_newline = 'Y' THEN
      LET g_pnf[l_ac].pnf07a = l_ima44
   END IF

   DISPLAY BY NAME g_pnf[l_ac].pnf041a
   DISPLAY BY NAME g_pnf[l_ac].pnf07a
   DISPLAY BY NAME g_pnf[l_ac].ima021a

END FUNCTION

#--->單位檔
FUNCTION t900_unit(p_key)
  DEFINE p_key      LIKE gfe_file.gfe01
  DEFINE l_gfeacti  LIKE gfe_file.gfeacti

  LET g_errno = ' '
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
   WHERE gfe01 = p_key
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
       WHEN l_gfeacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION


FUNCTION t900_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc      LIKE type_file.chr1000

   LET g_sql =
      " SELECT pnf03, '0',    pnf04b, pnf041b, '',      pnf20b, pnf07b, pnf83b,        ",
      "               pnf84b, pnf85b, pnf80b,  pnf81b,  pnf82b, pnf86b, pnf87b, pnf41b,",
      "               pnf12b, pnf121b,pnf122b, pnf33b,                                 ",
      "               '1',    pnf04a, pnf041a, '',      pnf20a, pnf07a, pnf83a,        ",
      "               pnf84a, pnf85a, pnf80a,  pnf81a,  pnf82a, pnf86a, pnf87a, pnf41a,",
      "               pnf12a, pnf121a,pnf122a, pnf33a,  pnf50                          ",
      "  FROM pnf_file  ",    
      " WHERE pnf01 = '",g_pne.pne01, "'",
      "   AND pnf02 =  ",g_pne.pne02,
      "   AND ", p_wc CLIPPED
      
   PREPARE t900_prepare2 FROM g_sql      #預備一下
   DECLARE pnf_cs CURSOR FOR t900_prepare2
   CALL g_pnf.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH pnf_cs INTO g_pnf[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       SELECT ima021 INTO g_pnf[g_cnt].ima021a FROM ima_file
        WHERE ima01=g_pnf[g_cnt].pnf04a
       SELECT ima021 INTO g_pnf[g_cnt].ima021b FROM ima_file
        WHERE ima01=g_pnf[g_cnt].pnf04b

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_pnf.deleteElement(g_cnt)

   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2

END FUNCTION


FUNCTION t900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pnf TO s_pnf.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
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
         CALL t900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL t900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY

      ON ACTION jump
         CALL t900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY

      ON ACTION next
         CALL t900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY

      ON ACTION last
         CALL t900_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         IF g_pne.pne06='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_pne.pne14='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_pne.pne06,g_chr2,"","",g_chr,"")
         CALL t900_def_form()

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
     #FUN-B30076 ADD BEGIN--------------     
     #@ON ACTION 取消確認
       ON ACTION unconfirm
          LET g_action_choice="unconfirm"
          EXIT DISPLAY  
             
     #@ON ACTION 發出     
       ON ACTION issued
          LET g_action_choice="issued"
          EXIT DISPLAY
     #FUN-B30076 ADD -END---------------
          
     #@ON ACTION 作廢
       ON ACTION void
          LET g_action_choice="void"
          EXIT DISPLAY
#FUN-D20025 add
     #@ON ACTION 取消作廢
       ON ACTION undo_void
          LET g_action_choice="undo_void"
          EXIT DISPLAY
#FUN-D20025 add  
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE     
         LET g_action_choice="exit"
         EXIT DISPLAY

    #@ON ACTION easyflow送簽
      ON ACTION easyflow_approval
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY

    #@ON ACTION 簽核狀況
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY

      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY

      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY

      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY

      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY

      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY

      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION t900_out()
  DEFINE l_sw       LIKE type_file.num5 
  DEFINE l_wc       LIKE type_file.chr1000
  DEFINE l_cmd      LIKE type_file.chr1000
  DEFINE l_prtway   LIKE type_file.chr1

  IF NOT cl_null(g_pne.pne01) THEN
     CALL cl_confirm('apm-176') RETURNING l_sw
     IF l_sw THEN
        LET l_wc = " pne01 = '",g_pne.pne01,"' AND pne02 = ",g_pne.pne02
        SELECT zz22 INTO l_prtway FROM zz_file
         WHERE zz01 = 'apmr930'
        LET l_cmd = "apmr930 ",
                    ' "',g_today CLIPPED,'" ""',
                    ' "',g_lang  CLIPPED,'" "Y" "',l_prtway,'" "1"',
                    ' "',l_wc    CLIPPED,'" "3" '
        CALL cl_cmdrun(l_cmd)
     END IF
  END IF
END FUNCTION


#FUNCTION t900_x() #FUN-D20025 mark
FUNCTION t900_x(p_type) #FUN-D20025 add
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20025 add 

   IF s_shut(0) THEN RETURN END IF

   IF cl_null(g_pne.pne01) OR cl_null(g_pne.pne02) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_pne.* FROM pne_file
    WHERE pne01 = g_pne.pne01
      AND pne02 = g_pne.pne02
   IF g_pne.pne01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_pne.pne06 = 'Y' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_pne.pne14 MATCHES '[Ss1]' THEN
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF
   #FUN-D20025---begin 
   IF p_type = 1 THEN 
      IF g_pne.pne06='X' THEN RETURN END IF
   ELSE
      IF g_pne.pne06<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20025---end 
   IF g_pne.pne06 = 'X' THEN
      SELECT COUNT(*) INTO g_cnt FROM pne_file
       WHERE pne01 = g_pne.pne01
         AND (pne06 = 'N' OR pne06 = 'Y' AND pne02 > g_pne.pne02)
      IF g_cnt > 0 THEN
         #该请购单有未审核的变更单资料,或是大于当前版本的已审核变更单资料存在,故不可做取消作废动作!
         CALL cl_err('','apm-175',1)
         RETURN
      END IF
   END IF

   BEGIN WORK
   LET g_success = 'Y'

   OPEN t900_cl USING g_pne.pne01,g_pne.pne02
   IF STATUS THEN
      CALL cl_err("OPEN t900_cl:", STATUS, 1)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900_cl INTO g_pne.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pne.pne01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t900_cl
       ROLLBACK WORK
       RETURN
   END IF
   IF cl_void(0,0,g_pne.pne06) THEN
      LET g_chr=g_pne.pne06
      IF g_pne.pne06 ='N' THEN
         LET g_pne.pne06='X'
         LET g_pne.pne14='9'
      ELSE
         LET g_pne.pne06='N'
         LET g_pne.pne14='0'
      END IF
      UPDATE pne_file SET
             pne06   = g_pne.pne06,
             pne14   = g_pne.pne14,
             pnemodu = g_user,
             pnedate = g_today
       WHERE pne01 = g_pne.pne01
         AND pne02 = g_pne.pne02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('up pne_file',SQLCA.sqlcode,0) LET g_success = 'N'
      END IF
   END IF
   CLOSE t900_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF

   SELECT pne06,pne14 INTO g_pne.pne06,g_pne.pne14 FROM pne_file
    WHERE pne01 = g_pne.pne01 AND pne02=g_pne.pne02
   DISPLAY BY NAME g_pne.pne06
   DISPLAY BY NAME g_pne.pne14
   #CKP
   IF g_pne.pne06='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_pne.pne14='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_pne.pne06,g_chr2,"","",g_chr,"")

END FUNCTION

FUNCTION t900_pne09b()  #幣別
   DEFINE l_aziacti LIKE azi_file.aziacti

   LET g_errno = " "
   SELECT azi03,azi04,aziacti INTO t_azi03,t_azi04,l_aziacti
     FROM azi_file
    WHERE azi01 = g_pne.pne09b
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
        WHEN l_aziacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_pne.pne09b) THEN
      SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file WHERE azi01 = g_pne.pne09
   END IF
END FUNCTION

FUNCTION t900_pne10b()  #付款條件
   DEFINE l_pma02    like pma_file.pma02
   DEFINE l_pma06    like pma_file.pma06
   DEFINE l_pmaacti  like pma_file.pmaacti

   LET g_errno = " "
   SELECT pma02,pma06,pmaacti INTO l_pma02,l_pma06,l_pmaacti
     FROM pma_file
    WHERE pma01 = g_pne.pne10b

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
   WHEN l_pmaacti='N'       LET g_errno = '9028'
   OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION t900_pne11b()  #價格條件
   LET g_errno = " "
   SELECT * FROM pnz_file
    WHERE pnz01 = g_pne.pne11b

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'sub-221'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION t900_pne12b(p_code)    #check 地址pne12b或pne13b
  DEFINE p_code    LIKE pme_file.pme01
  DEFINE l_pmeacti LIKE pme_file.pmeacti

  LET g_errno = " "
  SELECT pmeacti INTO l_pmeacti FROM pme_file
   WHERE pme01 = p_code

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno='mfg3012'
       WHEN l_pmeacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION

FUNCTION t900_peo(p_cmd,p_key)
   DEFINE p_cmd       LIKE type_file.chr1
   DEFINE p_key       LIKE gen_file.gen01
   DEFINE l_gen02     LIKE gen_file.gen02
   DEFINE l_genacti   LIKE gen_file.genacti

   LET g_errno = ' '
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01 = p_key

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                  LET l_gen02 = NULL
        WHEN l_genacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   DISPLAY l_gen02 TO FORMONLY.gen02
END FUNCTION

FUNCTION t900_pne04()    #變更理由
   DEFINE l_azf03    LIKE azf_file.azf03,
          l_azf09    LIKE azf_file.azf09,
          l_azf09_mark   LIKE azf_file.azf09,
          l_azfacti  LIKE azf_file.azfacti

   LET g_errno = " "
   SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti
     FROM azf_file
    WHERE azf01 = g_pne.pne04
      AND azf02 = '2'

   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'asf-453'
                                 LET l_azf03   = NULL
        WHEN l_azfacti='N'       LET g_errno = '9028'
        WHEN l_azf09 != 'B'      LET g_errno = 'aoo-410'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   DISPLAY l_azf03 TO FORMONLY.azf03

END FUNCTION


FUNCTION t900_pne01(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_pmk09   LIKE pmk_file.pmk09
   DEFINE l_pmc03   LIKE pmc_file.pmc03
   DEFINE l_pmk21   LIKE pmk_file.pmk21
   DEFINE l_pmk18   LIKE pmk_file.pmk18
   DEFINE l_pmk25   LIKE pmk_file.pmk25
   DEFINE l_gec07   LIKE gec_file.gec07
   DEFINE l_pmk43   LIKE pmk_file.pmk43
   DEFINE l_pne09   LIKE pne_file.pne09
   DEFINE l_pne10   LIKE pne_file.pne10
   DEFINE l_pne11   LIKE pne_file.pne11
   DEFINE l_pne12   LIKE pne_file.pne12
   DEFINE l_pne13   LIKE pne_file.pne13
   DEFINE l_azi02   LIKE azi_file.azi02,  #No.FUN-B30081 Add
          l_pma02   LIKE pma_file.pma02,  #No.FUN-B30081 Add
          l_pnz02   LIKE pnz_file.pnz02,  #No.FUN-B30081 Add
          l_pme031  LIKE pme_file.pme031, #No.FUN-B30081 Add
          l_pme032  LIKE pme_file.pme032, #No.FUN-B30081 Add
          l_pme031a LIKE pme_file.pme031, #No.FUN-B30081 Add
          l_pme032a LIKE pme_file.pme032  #No.FUN-B30081 Add
   DEFINE l_cnt     LIKE type_file.num5   #No.TQC-BB0252 請購單單身未完全轉採購個數統計 
   LET g_errno = " "
   SELECT pmk18,pmk25 INTO l_pmk18,l_pmk25
     FROM pmk_file
    WHERE pmk01 = g_pne.pne01

   CASE WHEN SQLCA.SQLCODE = 100         LET g_errno = 'mfg3055'
        WHEN l_pmk18 ='N'                LET g_errno = 'apm-292'
        WHEN l_pmk25 NOT MATCHES '[12]'  LET g_errno = 'apm-172'
        OTHERWISE                        LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) AND p_cmd <> 'd' THEN RETURN END IF #MOD-C90184 add
   ##No.TQC-BB0252  begin
   #請購單單身未完全轉採購個數統計
   SELECT COUNT(*) INTO l_cnt 
     FROM pml_file
    WHERE pml01 = g_pne.pne01
      AND (pml20-pml21) > 0  #請購量 - 已轉採購量
   #如果符合條件的單身筆數為零,就報錯    
      IF l_cnt = 0 THEN 
         LET g_errno = 'apm-515' 
      END IF 
   #No.TQC-BB0252 end
   IF NOT cl_null(g_errno) AND p_cmd <> 'd' THEN RETURN END IF

   SELECT pmk09,pmc03,pmk21,pmk43,gec07,
          pmk22,pmk20,pmk41,pmk10,pmk11
     INTO l_pmk09,l_pmc03,l_pmk21,l_pmk43,l_gec07,
          l_pne09,l_pne10,l_pne11,l_pne12,l_pne13
    FROM pmk_file LEFT OUTER JOIN gec_file
                       ON pmk21 = gec_file.gec01
                       AND gec_file.gec011 = '1'  #進項 #MOD-D30012 add
                  LEFT OUTER JOIN pmc_file
                       ON pmk09 = pmc_file.pmc01
   WHERE pmk01 = g_pne.pne01

   DISPLAY l_pmk09,l_pmc03 TO FORMONLY.pmk09,FORMONLY.pmc03
   DISPLAY l_pmk21,l_pmk43 TO FORMONLY.pmk21,FORMONLY.pmk43
   DISPLAY l_gec07 TO FORMONLY.gec07
   IF p_cmd <> 'd' THEN
      LET g_pne.pne09 = l_pne09
      LET g_pne.pne10 = l_pne10
      LET g_pne.pne11 = l_pne11
      LET g_pne.pne12 = l_pne12
      LET g_pne.pne13 = l_pne13
   END IF
   DISPLAY BY NAME g_pne.pne09,g_pne.pne10,g_pne.pne11,g_pne.pne12,g_pne.pne13
   #No.FUN-B30081 Add
   SELECT azi02 INTO l_azi02 FROM azi_file WHERE azi01=g_pne.pne09
   SELECT pma02 INTO l_pma02 FROM pma_file WHERE pma01=g_pne.pne10
   SELECT pnz02 INTO l_pnz02 FROM pnz_file WHERE pnz01=g_pne.pne11
   SELECT pme031,pme031 INTO l_pme031,l_pme032 FROM pme_file WHERE pme01=g_pne.pne12 AND pme02!='1'
   SELECT pme031,pme031 INTO l_pme031a,l_pme032a FROM pme_file WHERE pme01=g_pne.pne12 AND pme02!='0'
   DISPLAY l_azi02 TO FORMONLY.azi02
   DISPLAY l_pma02 TO FORMONLY.pma02
   DISPLAY l_pnz02 TO FORMONLY.pnz02
   DISPLAY l_pme031 TO FORMONLY.pme031
   DISPLAY l_pme032 TO FORMONLY.pme032
   DISPLAY l_pme031a TO FORMONLY.pme031a
   DISPLAY l_pme032a TO FORMONLY.pme032a
   #No.FUN-B30081 Add

END FUNCTION


#對原來數量/換算率/單位的賦值
FUNCTION t900_set_origin_field()
  DEFINE l_tot    LIKE img_file.img10
  DEFINE l_unit2  LIKE pnf_file.pnf83a
  DEFINE l_fac2   LIKE pnf_file.pnf84a
  DEFINE l_qty2   LIKE pnf_file.pnf85a
  DEFINE l_fac1   LIKE pnf_file.pnf81a
  DEFINE l_qty1   LIKE pnf_file.pnf82a
  DEFINE l_unit1  LIKE pnf_file.pnf80a
  DEFINE l_ima25  LIKE ima_file.ima25
  DEFINE l_ima44  LIKE ima_file.ima44

  IF g_sma.sma115='N' THEN RETURN END IF
  LET g_pnf04 = g_pnf[l_ac].pnf04b
  IF NOT cl_null(g_pnf[l_ac].pnf04a) THEN
     LET g_pnf04 = g_pnf[l_ac].pnf04a
  END IF
  SELECT ima25,ima44 INTO l_ima25,l_ima44
    FROM ima_file WHERE ima01=g_pnf04
  IF SQLCA.sqlcode = 100 THEN
     IF g_pnf04 MATCHES 'MISC*' THEN
        SELECT ima25,ima44 INTO l_ima25,l_ima44
          FROM ima_file WHERE ima01='MISC'
     END IF
  END IF
  IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF

  LET l_unit2=g_pnf[l_ac].pnf83b
  LET l_fac2=g_pnf[l_ac].pnf84b
  LET l_qty2=g_pnf[l_ac].pnf85b
  LET l_unit1=g_pnf[l_ac].pnf80b
  LET l_fac1=g_pnf[l_ac].pnf81b
  LET l_qty1=g_pnf[l_ac].pnf82b

  IF NOT cl_null(g_pnf[l_ac].pnf83a) THEN
     LET l_unit2=g_pnf[l_ac].pnf83a
  END IF
  IF NOT cl_null(g_pnf[l_ac].pnf84a) THEN
     LET l_fac2=g_pnf[l_ac].pnf84a
  END IF
  IF NOT cl_null(g_pnf[l_ac].pnf85a) THEN
     LET l_qty2=g_pnf[l_ac].pnf85a
  END IF
  IF NOT cl_null(g_pnf[l_ac].pnf80a) THEN
     LET l_unit1=g_pnf[l_ac].pnf80a
  END IF
  IF NOT cl_null(g_pnf[l_ac].pnf81a) THEN
     LET l_fac1=g_pnf[l_ac].pnf81a
  END IF
  IF NOT cl_null(g_pnf[l_ac].pnf82a) THEN
     LET l_qty1=g_pnf[l_ac].pnf82a
  END IF

  IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
  IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
  IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
  IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

  IF g_sma.sma115 = 'Y' THEN
     CASE g_ima906
        WHEN '1' LET g_pnf[l_ac].pnf07a=l_unit1
                 LET g_pnf[l_ac].pnf20a=l_qty1
        WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                 LET g_pnf[l_ac].pnf07a=l_ima44
                 LET g_pnf[l_ac].pnf20a=l_tot
                 LET g_pnf[l_ac].pnf20a = s_digqty(g_pnf[l_ac].pnf20a,g_pnf[l_ac].pnf07a)   #FUN-910088--add--
        WHEN '3' LET g_pnf[l_ac].pnf07a=l_unit1
                 LET g_pnf[l_ac].pnf20a=l_qty1
                 IF l_qty2 <> 0 THEN
                    LET g_pnf[l_ac].pnf84a=l_qty1/l_qty2
                 ELSE
                    LET g_pnf[l_ac].pnf84a=0
                 END IF
     END CASE
  END IF

  IF g_sma.sma116 ='0' OR g_sma.sma116 ='2' THEN
     LET g_pnf[l_ac].pnf86a = g_pnf[l_ac].pnf07a
     LET g_pnf[l_ac].pnf87a = g_pnf[l_ac].pnf20a
  END IF
END FUNCTION

FUNCTION t900_set_pnf87a()
   DEFINE  l_item   LIKE img_file.img01     #料號
   DEFINE  l_pnf07  LIKE pnf_file.pnf07a
   DEFINE  l_ima25  LIKE ima_file.ima25     #ima單位
   DEFINE  l_ima44  LIKE ima_file.ima44     #ima單位
   DEFINE  l_ima906 LIKE ima_file.ima906
   DEFINE  l_fac2   LIKE img_file.img21     #第二轉換率
   DEFINE  l_qty2   LIKE img_file.img10     #第二數量
   DEFINE  l_fac1   LIKE img_file.img21     #第一轉換率
   DEFINE  l_qty1   LIKE img_file.img10     #第一數量
   DEFINE  l_tot    LIKE img_file.img10     #計價數量
   DEFINE  l_factor LIKE ima_file.ima31_fac

   LET g_pnf04 = g_pnf[l_ac].pnf04b
   IF NOT cl_null(g_pnf[l_ac].pnf04a) THEN
      LET g_pnf04 = g_pnf[l_ac].pnf04a
   END IF
   SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
     FROM ima_file WHERE ima01=g_pnf04
   IF SQLCA.sqlcode =100 THEN
      IF g_pnf04 MATCHES 'MISC*' THEN
         SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
           FROM ima_file WHERE ima01='MISC'
      END IF
   END IF
   IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF

   IF g_sma.sma115 = 'Y' THEN
      LET l_fac2=g_pnf[l_ac].pnf84b
      LET l_qty2=g_pnf[l_ac].pnf85b
      LET l_fac1=g_pnf[l_ac].pnf81b
      LET l_qty1=g_pnf[l_ac].pnf82b
      IF NOT cl_null(g_pnf[l_ac].pnf84a) THEN
         LET l_fac2=g_pnf[l_ac].pnf84a
      END IF
      IF NOT cl_null(g_pnf[l_ac].pnf85a) THEN
         LET l_qty2=g_pnf[l_ac].pnf85a
      END IF
      IF NOT cl_null(g_pnf[l_ac].pnf81a) THEN
         LET l_fac1=g_pnf[l_ac].pnf81a
      END IF
      IF NOT cl_null(g_pnf[l_ac].pnf82a) THEN
         LET l_qty1=g_pnf[l_ac].pnf82a
      END IF
   ELSE
      LET l_fac1=1
      LET l_qty1=g_pnf[l_ac].pnf20b
      IF NOT cl_null(g_pnf[l_ac].pnf20a) THEN
         LET l_qty1=g_pnf[l_ac].pnf20a
      END IF
      LET l_pnf07 = g_pnf[l_ac].pnf07b
      IF NOT cl_null(g_pnf[l_ac].pnf07a) THEN
         LET l_pnf07=g_pnf[l_ac].pnf07a
      END IF
      CALL s_umfchk(g_pnf04,l_pnf07,l_ima44)
            RETURNING g_cnt,l_fac1
      IF g_cnt = 1 THEN
         LET l_fac1 = 1
      END IF
   END IF
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot=l_qty1*l_fac1
         WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
         WHEN '3' LET l_tot=l_qty1*l_fac1
      END CASE
   ELSE  #不使用雙單位
     LET l_tot=l_qty1*l_fac1
   END IF
   IF cl_null(l_tot) THEN LET l_tot = 0 END IF
   
   IF g_sma.sma116 MATCHES '[02]' THEN
      IF NOT cl_null(g_pnf[l_ac].pnf07a) THEN
         LET g_pnf[l_ac].pnf86a = g_pnf[l_ac].pnf07a
      ELSE
         LET g_pnf[l_ac].pnf86a = g_pnf[l_ac].pnf07b      	
      END IF
   ELSE
      IF cl_null(g_pnf[l_ac].pnf86a) THEN
         LET g_pnf[l_ac].pnf86a = g_pnf[l_ac].pnf86b       	
      END IF	
   END IF
   
   LET l_factor = 1
   CALL s_umfchk(g_pnf04,l_ima44,g_pnf[l_ac].pnf86a)
        RETURNING g_cnt,l_factor
   IF g_cnt = 1 THEN
      LET l_factor = 1
   END IF
   LET l_tot = l_tot * l_factor

   LET g_pnf[l_ac].pnf87a = l_tot
   LET g_pnf[l_ac].pnf87a = s_digqty(g_pnf[l_ac].pnf87a,g_pnf[l_ac].pnf86a)   #FUN-910088--add--
END FUNCTION

#用于default 雙單位/轉換率/數量
FUNCTION t900_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_ima908 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_unit3  LIKE img_file.img09,     #計價單位
            l_qty3   LIKE img_file.img10,     #計價數量
            p_cmd    LIKE type_file.chr1,
            l_factor LIKE ima_file.ima31_fac

    LET l_item = g_pnf[l_ac].pnf04a

    SELECT ima44,ima906,ima907,ima908
      INTO l_ima44,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_item

    IF g_sma.sma115 = 'Y' THEN
       IF l_ima906 = '1' THEN  #不使用雙單位
          LET l_unit2 = NULL
          LET l_fac2  = NULL
          LET l_qty2  = NULL
       ELSE
          LET l_unit2 = l_ima907
          CALL s_du_umfchk(l_item,'','','',l_ima44,l_ima907,l_ima906)
               RETURNING g_errno,l_factor
          LET l_fac2 = l_factor
          LET l_qty2  = 0
       END IF

       LET l_unit1 = l_ima44
       LET l_fac1  = 1
       LET l_qty1  = 0
    END IF

    IF g_sma.sma116 MATCHES '[02]' THEN
       LET l_unit3 = NULL
       LET l_qty3  = NULL
    ELSE
       LET l_unit3 = l_ima908
       LET l_qty3  = 0
    END IF

    IF g_newline = 'Y' THEN
       LET g_pnf[l_ac].pnf83a=l_unit2
       LET g_pnf[l_ac].pnf84a=l_fac2
       LET g_pnf[l_ac].pnf85a=l_qty2
       LET g_pnf[l_ac].pnf80a=l_unit1
       LET g_pnf[l_ac].pnf81a=l_fac1
       LET g_pnf[l_ac].pnf82a=l_qty1
       LET g_pnf[l_ac].pnf86a=l_unit3
       LET g_pnf[l_ac].pnf87a=l_qty3
    END IF
END FUNCTION

FUNCTION t900_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("pne01",TRUE)
   END IF
END FUNCTION

FUNCTION t900_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("pne01",FALSE)
   END IF
END FUNCTION

FUNCTION t900_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("pnf83b,pnf85b,pnf80b,pnf82b",FALSE)
      CALL cl_set_comp_visible("pnf83a,pnf85a,pnf80a,pnf82a",FALSE)
      CALL cl_set_comp_visible("pnf07b,pnf20b,pnf07a,pnf20a",TRUE)
      CALL cl_set_comp_visible("dummy83,dummy85,dummy80,dummy82",FALSE)
      CALL cl_set_comp_visible("dummy06,dummy05",TRUE)
      CALL cl_set_comp_lab_text("dummy80"," ")
      CALL cl_set_comp_lab_text("dummy81"," ")
      CALL cl_set_comp_lab_text("dummy82"," ")
      CALL cl_set_comp_lab_text("dummy83"," ")
      CALL cl_set_comp_lab_text("dummy84"," ")
      CALL cl_set_comp_lab_text("dummy85"," ")
   ELSE
      CALL cl_set_comp_visible("pnf83b,pnf85b,pnf80b,pnf82b",TRUE)
      CALL cl_set_comp_visible("pnf83a,pnf85a,pnf80a,pnf82a",TRUE)
      CALL cl_set_comp_visible("pnf07b,pnf20b,pnf07a,pnf20a",FALSE)
      CALL cl_set_comp_visible("dummy83,dummy85,dummy80,dummy82",TRUE)
      CALL cl_set_comp_visible("dummy06,dummy05",FALSE)
      CALL cl_set_comp_lab_text("dummy05"," ")
      CALL cl_set_comp_lab_text("dummy06"," ")
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN
       CALL cl_set_comp_visible("pnf86a,pnf87a,pnf86b,pnf87b",FALSE)
      CALL cl_set_comp_visible("dummy86",FALSE)
      CALL cl_set_comp_visible("dummy87",FALSE)
   ELSE
       CALL cl_set_comp_visible("pnf86a,pnf87a,pnf86b,pnf87b",TRUE)
       CALL cl_set_comp_visible("dummy86,dummy87",TRUE)
   END IF
   CALL cl_set_comp_lab_text("dummy81"," ")
   CALL cl_set_comp_lab_text("dummy84"," ")
   CALL cl_set_comp_visible("pnf81b,pnf84b,pnf81a,pnf84a",FALSE)
   CALL cl_set_comp_visible("dummy81,dummy84",FALSE)
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy82",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_lab_text("dummy82",g_msg CLIPPED)
   END IF
END FUNCTION

FUNCTION t900_b_init()
   LET g_pnf[l_ac].pnf04a = NULL
   LET g_pnf[l_ac].pnf041a= NULL
   LET g_pnf[l_ac].ima021a= NULL
   LET g_pnf[l_ac].pnf20a = NULL
   LET g_pnf[l_ac].pnf07a = NULL
   LET g_pnf[l_ac].pnf83a = NULL
   LET g_pnf[l_ac].pnf85a = NULL
   LET g_pnf[l_ac].pnf80a = NULL
   LET g_pnf[l_ac].pnf82a = NULL
   LET g_pnf[l_ac].pnf86a = NULL
   LET g_pnf[l_ac].pnf87a = NULL
   LET g_pnf[l_ac].pnf41a = NULL
   LET g_pnf[l_ac].pnf12a = NULL
   LET g_pnf[l_ac].pnf121a= NULL
   LET g_pnf[l_ac].pnf122a= NULL
   LET g_pnf[l_ac].pnf33a = NULL

   LET g_pnf[l_ac].pnf04b = NULL
   LET g_pnf[l_ac].pnf041b= NULL
   LET g_pnf[l_ac].ima021b= NULL
   LET g_pnf[l_ac].pnf20b = NULL
   LET g_pnf[l_ac].pnf07b = NULL
   LET g_pnf[l_ac].pnf83b = NULL
   LET g_pnf[l_ac].pnf85b = NULL
   LET g_pnf[l_ac].pnf80b = NULL
   LET g_pnf[l_ac].pnf82b = NULL
   LET g_pnf[l_ac].pnf86b = NULL
   LET g_pnf[l_ac].pnf87b = NULL
   LET g_pnf[l_ac].pnf41b = NULL
   LET g_pnf[l_ac].pnf12b = NULL
   LET g_pnf[l_ac].pnf121b= NULL
   LET g_pnf[l_ac].pnf122b= NULL
   LET g_pnf[l_ac].pnf33b = NULL
   LET g_pnf[l_ac].pnf50  = NULL   #CHI-C50063 add

END FUNCTION

FUNCTION t900_item_chk1(p_item)
   DEFINE p_item        LIKE ima_file.ima01
   DEFINE l_imaag       LIKE ima_file.imaag
   DEFINE l_imaag1      LIKE ima_file.imaag
   
   IF g_sma.sma120 = 'N' THEN
      SELECT imaag,imaag1 INTO l_imaag,l_imaag1 FROM ima_file
       WHERE ima01 =p_item
      IF NOT cl_null(l_imaag) AND l_imaag <> '@CHILD' THEN
         CALL cl_err(p_item,'aim1004',0)
         RETURN FALSE
      END IF
   END IF
   IF g_sma.sma120 ='Y' AND g_sma.sma907 ='Y' THEN
      LET g_t1 =g_pne.pne01[1,g_doc_len]
      SELECT smy62 INTO g_smy62 FROM smy_file
       WHERE smyslip =g_t1
      IF NOT cl_null(g_smy62) THEN
         IF g_smy62 <> l_imaag1 THEN
            CALL cl_err('','atm-525',0)
            RETURN FALSE
         END IF
         IF cl_null(l_imaag1) THEN
            CALL cl_err('','atm-525',0)
            RETURN FALSE
         END IF
      END IF
   END IF
   RETURN TRUE
            
END FUNCTION     
       
FUNCTION t900_pnf12a()
   DEFINE l_pjaclose LIKE pja_file.pjaclose
   DEFINE l_pjaacti  LIKE pja_file.pjaacti
   DEFINE l_pnf121   LIKE pnf_file.pnf121a
   DEFINE l_pnf122   LIKE pnf_file.pnf122a

   #项目检查
   LET g_errno = " "
   SELECT pjaacti,pjaclose INTO l_pjaacti,l_pjaclose 
     FROM pja_file 
    WHERE pja01 = g_pnf[l_ac].pnf12a

   CASE WHEN SQLCA.SQLCODE = 100   LET g_errno = 'mfg3064'
        WHEN l_pjaacti='N'         LET g_errno = '9028'   
        WHEN l_pjaclose='Y'        LET g_errno = 'abg-503'  
        OTHERWISE                  LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
END FUNCTION

FUNCTION t900_pnf121a()
   DEFINE l_pnf12     LIKE pnf_file.pnf12a
   DEFINE l_pnf121    LIKE pnf_file.pnf121a
   DEFINE l_pjbacti   LIKE pjb_file.pjbacti
   DEFINE l_pjb09     LIKE pjb_file.pjb09
   DEFINE l_pjb11     LIKE pjb_file.pjb11

   LET g_errno = ''   
   LET l_pnf12 = g_pnf[l_ac].pnf12b
   IF NOT cl_null(g_pnf[l_ac].pnf12a) THEN
      LET l_pnf12 = g_pnf[l_ac].pnf12a
   END IF
   
   LET l_pnf121 = g_pnf[l_ac].pnf121b
   IF NOT cl_null(g_pnf[l_ac].pnf121a) THEN
      LET l_pnf121 = g_pnf[l_ac].pnf121a
   END IF
   
   IF cl_null(l_pnf12) THEN RETURN END IF
   IF l_pnf121 IS NULL THEN RETURN END IF
   
   SELECT pjbacti,pjb09,pjb11 INTO l_pjbacti,l_pjb09,l_pjb11
     FROM pjb_file 
    WHERE pjb01 = l_pnf12
      AND pjb02 = l_pnf121

   CASE WHEN SQLCA.SQLCODE = 100   LET g_errno = 'apj-051'
        WHEN l_pjbacti='N'         LET g_errno = '9028'   
        WHEN l_pjb09<>'Y'          LET g_errno = 'apj-090'  
        WHEN l_pjb11<>'Y'          LET g_errno = 'apj-090'
        OTHERWISE                  LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE   

END FUNCTION

FUNCTION t900_pnf122a()
   DEFINE l_pnf121    LIKE pnf_file.pnf121a
   DEFINE l_pnf122    LIKE pnf_file.pnf122a   
   DEFINE l_cnt       LIKE type_file.num5

   LET g_errno = ''   
   
   LET l_pnf121 = g_pnf[l_ac].pnf121b
   IF NOT cl_null(g_pnf[l_ac].pnf121a) THEN
      LET l_pnf121 = g_pnf[l_ac].pnf121a
   END IF
   LET l_pnf122 = g_pnf[l_ac].pnf122b
   IF NOT cl_null(g_pnf[l_ac].pnf122a) THEN
      LET l_pnf122 = g_pnf[l_ac].pnf122a
   END IF   
   
   IF l_pnf121 IS NULL THEN RETURN END IF
   IF l_pnf122 IS NULL THEN RETURN END IF
      
   SELECT COUNT(*) INTO l_cnt FROM pjk_file
    WHERE pjk02 = l_pnf122
      AND pjk11 = l_pnf121
   IF l_cnt = 0 THEN
      LET g_errno = 'apj-049'
   END IF 

END FUNCTION

FUNCTION t900_ef()

    CALL t900sub_y_chk(g_pne.pne01,g_pne.pne02)          #CALL 原確認的 check 段
    IF g_success = "N" THEN
        RETURN
    END IF

    CALL aws_condition()#判斷送簽資料
    IF g_success = 'N' THEN
        RETURN
    END IF
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########


  IF aws_efcli2(base.TypeInfo.create(g_pne),base.TypeInfo.create(g_pnf),'','','','')
  THEN
      LET g_success = 'Y'
      LET g_pne.pne14 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
      DISPLAY BY NAME g_pne.pne14
   ELSE
      LET g_success = 'N'
   END IF
END FUNCTION

#FUN-910088--add--start--
FUNCTION t900_pnf20a_check()
   DEFINE l_pml21  LIKE pml_file.pml21
   IF NOT cl_null(g_pnf[l_ac].pnf20a) THEN
      IF NOT cl_null(g_pnf[l_ac].pnf07a) THEN
         LET g_pnf[l_ac].pnf20a = s_digqty(g_pnf[l_ac].pnf20a,g_pnf[l_ac].pnf07a)
      ELSE 
         LET g_pnf[l_ac].pnf20a = s_digqty(g_pnf[l_ac].pnf20a,g_pnf[l_ac].pnf07b)
      END IF
      DISPLAY BY NAME g_pnf[l_ac].pnf20a
   END IF
   IF g_newline='Y' AND
      (cl_null(g_pnf[l_ac].pnf20a) OR g_pnf[l_ac].pnf20a <=0 ) THEN
      CALL cl_err('','mfg3331',0)
      RETURN FALSE     
   END IF
   IF NOT cl_null(g_pnf[l_ac].pnf20a) AND g_pnf[l_ac].pnf20b<>g_pnf[l_ac].pnf20a THEN      
      SELECT pml21 INTO l_pml21 FROM pml_file
       WHERE pml01 = g_pne.pne01
         AND pml02 = g_pnf[l_ac].pnf03
      IF cl_null(l_pml21) THEN LET l_pml21 = 0 END IF
      IF g_pnf[l_ac].pnf20a < l_pml21 THEN
         #请购数量不得小于已转采购数量!
         CALL cl_err(g_pnf[l_ac].pnf20a,'apm-178',0)
         LET g_pnf[l_ac].pnf20a = NULL
         RETURN FALSE     
      END IF
   END IF
   IF cl_null(g_pnf[l_ac].pnf20b) AND NOT cl_null(g_pnf[l_ac].pnf20a) OR
      g_pnf[l_ac].pnf20b<>g_pnf[l_ac].pnf20a THEN      
      LET g_change = 'Y' 
   END IF
   IF g_change = 'Y' THEN
      CALL t900_set_pnf87a()
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t900_pnf82a_check()
   IF NOT cl_null(g_pnf[l_ac].pnf82a) THEN
      IF NOT cl_null(g_pnf[l_ac].pnf80a) THEN
         LET g_pnf[l_ac].pnf82a = s_digqty(g_pnf[l_ac].pnf82a,g_pnf[l_ac].pnf80a)
      ELSE
         LET g_pnf[l_ac].pnf82a = s_digqty(g_pnf[l_ac].pnf82a,g_pnf[l_ac].pnf80b)
      END IF
      DISPLAY BY NAME g_pnf[l_ac].pnf82a
   END IF
   IF cl_null(g_pnf[l_ac].pnf82b) AND NOT cl_null(g_pnf[l_ac].pnf82a) OR
      g_pnf[l_ac].pnf82b<>g_pnf[l_ac].pnf82a THEN
      LET g_change = 'Y'
   END IF
   IF NOT cl_null(g_pnf[l_ac].pnf82a) THEN
      IF g_pnf[l_ac].pnf82a < 0 THEN
         CALL cl_err('','aim-391',0)   
         RETURN FALSE     
      END IF
   END IF
   #計算pnf20,pnf07的值,檢查數量的合理性
   CALL t900_set_origin_field()
   IF g_change = 'Y' THEN
      CALL t900_set_pnf87a()
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t900_pnf85a_check(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE l_pnf81         LIKE pnf_file.pnf81a,
          l_pnf84         LIKE pnf_file.pnf84a,
          l_pnf85         LIKE pnf_file.pnf85a
   DEFINE l_tot           LIKE pnf_file.pnf85a
   IF NOT cl_null(g_pnf[l_ac].pnf85a) THEN 
      IF NOT cl_null(g_pnf[l_ac].pnf83a) THEN
         LET g_pnf[l_ac].pnf85a = s_digqty(g_pnf[l_ac].pnf85a,g_pnf[l_ac].pnf83a)
      ELSE
         LET g_pnf[l_ac].pnf85a = s_digqty(g_pnf[l_ac].pnf85a,g_pnf[l_ac].pnf83b)
      END IF
      DISPLAY BY NAME g_pnf[l_ac].pnf85a
   END IF
   IF cl_null(g_pnf[l_ac].pnf85b) AND NOT cl_null(g_pnf[l_ac].pnf85a) OR
      g_pnf[l_ac].pnf85b<>g_pnf[l_ac].pnf85a THEN
      LET g_change = 'Y'
   END IF
   IF NOT cl_null(g_pnf[l_ac].pnf85a) THEN
      IF g_pnf[l_ac].pnf85a < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE     
      END IF
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_pnf_t.pnf85a <> g_pnf[l_ac].pnf85a THEN
         IF g_ima906='3' THEN
            LET l_pnf84 = g_pnf[l_ac].pnf84b
            LET l_pnf85 = g_pnf[l_ac].pnf85b
            LET l_pnf81 = g_pnf[l_ac].pnf81b
            IF NOT cl_null(g_pnf[l_ac].pnf84a) THEN
               LET l_pnf84 = g_pnf[l_ac].pnf84a
            END IF
            IF NOT cl_null(g_pnf[l_ac].pnf85a) THEN
               LET l_pnf85 = g_pnf[l_ac].pnf85a
            END IF
            IF NOT cl_null(g_pnf[l_ac].pnf81a) THEN
               LET l_pnf81 = g_pnf[l_ac].pnf81a
            END IF
            LET l_tot=l_pnf85*l_pnf84
            LET g_pnf[l_ac].pnf82a=l_tot*l_pnf81
            LET g_pnf[l_ac].pnf82a = s_digqty(g_pnf[l_ac].pnf82a,g_pnf[l_ac].pnf80a)   
            DISPLAY BY NAME g_pnf[l_ac].pnf82a 
         END IF
      END IF
   END IF
   IF g_change = 'Y' THEN
      CALL t900_set_pnf87a()
   END IF
   CALL cl_show_fld_cont()
   RETURN TRUE
END FUNCTION

FUNCTION t900_pnf87a_check()
   IF NOT cl_null(g_pnf[l_ac].pnf87a) THEN
      IF NOT cl_null(g_pnf[l_ac].pnf86a) THEN
         LET g_pnf[l_ac].pnf87a = s_digqty(g_pnf[l_ac].pnf87a,g_pnf[l_ac].pnf86a)
      ELSE
         LET g_pnf[l_ac].pnf87a = s_digqty(g_pnf[l_ac].pnf87a,g_pnf[l_ac].pnf86b)
      END IF
      DISPLAY BY NAME g_pnf[l_ac].pnf87a
   END IF
   IF NOT cl_null(g_pnf[l_ac].pnf87a) THEN
      IF g_pnf[l_ac].pnf87a < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE     
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--

