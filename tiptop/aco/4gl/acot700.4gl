# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acot700.4gl
# Descriptions...: 新貿加工合同核銷作業
# Date & Author..: 00/09/27 By Kammy
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/11/22 By Carrier
# Modify.........: No.FUN-550036 05/05/26 By Trisy 單據編號加大
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
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80045 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-910088 12/01/16 By chenjing 增加數量欄位小數取位 
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C80041 12/12/21 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cns           RECORD LIKE cns_file.*,       #單頭
    g_cns_t         RECORD LIKE cns_file.*,       #單頭(舊值)
    g_cns_o         RECORD LIKE cns_file.*,       #單頭(舊值)
    g_cns00_t       LIKE cns_file.cns00,          #單頭 (舊值)
    g_t1            LIKE oay_file.oayslip,              #No.FUN-550036        #No.FUN-680069  VARCHAR(05)
    g_cnt1          DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        cnt02       LIKE cnt_file.cnt02,   #序號
        cnt03       LIKE cnt_file.cnt03,   #商品編號
        cob02       LIKE cob_file.cob02,   #品名
        coe06       LIKE coe_file.coe06,   #商品編號
        cnt05       LIKE cnt_file.cnt05,   #進口總數
        cnt051      LIKE cnt_file.cnt051,  #
        cnt06       LIKE cnt_file.cnt06,   #
        cnt061      LIKE cnt_file.cnt061,  #
        cnt062      LIKE cnt_file.cnt062,  #
        cnt07       LIKE cnt_file.cnt07,   #
        cnt08       LIKE cnt_file.cnt08,   #
        cnt09       LIKE cnt_file.cnt09,   #
        cnt10       LIKE cnt_file.cnt10,   #
        cnt11       LIKE cnt_file.cnt11    #
                    END RECORD,
    g_cnt1_t         RECORD                 #程式變數 (舊值)
        cnt02       LIKE cnt_file.cnt02,   #序號
        cnt03       LIKE cnt_file.cnt03,   #商品編號
        cob02       LIKE cob_file.cob02,    #品名
        coe06       LIKE coe_file.coe06,   #商品編號
        cnt05       LIKE cnt_file.cnt05,   #進口總數
        cnt051      LIKE cnt_file.cnt051,  #
        cnt06       LIKE cnt_file.cnt06,   #
        cnt061      LIKE cnt_file.cnt061,  #
        cnt062      LIKE cnt_file.cnt062,  #
        cnt07       LIKE cnt_file.cnt07,   #
        cnt08       LIKE cnt_file.cnt08,   #
        cnt09       LIKE cnt_file.cnt09,   #
        cnt10       LIKE cnt_file.cnt10,   #
        cnt11       LIKE cnt_file.cnt11    #
                    END RECORD,
    g_cnt1_o         RECORD                 #程式變數 (舊值)
        cnt02       LIKE cnt_file.cnt02,   #序號
        cnt03       LIKE cnt_file.cnt03,   #商品編號
        cob02       LIKE cob_file.cob02,    #品名
        coe06       LIKE coe_file.coe06,   #商品編號
        cnt05       LIKE cnt_file.cnt05,   #進口總數
        cnt051      LIKE cnt_file.cnt051,  #
        cnt06       LIKE cnt_file.cnt06,   #
        cnt061      LIKE cnt_file.cnt061,  #
        cnt062      LIKE cnt_file.cnt062,  #
        cnt07       LIKE cnt_file.cnt07,   #
        cnt08       LIKE cnt_file.cnt08,   #
        cnt09       LIKE cnt_file.cnt09,   #
        cnt10       LIKE cnt_file.cnt10,   #
        cnt11       LIKE cnt_file.cnt11    #
                    END RECORD,
    g_argv1         LIKE cnt_file.cnt01,   # 詢價單號
    g_argv2         STRING,                #No.FUN-680069  STRING  #FUN-630014 指定執行的功能
     g_wc,g_wc2,g_sql    STRING,           #No.FUN-580092 HCN      #No.FUN-680069
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5,   #前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
    g_coc01         LIKE coc_file.coc01,   #申請單號
    g_coc01_2       LIKE coc_file.coc01    #申請單號
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   #No.FUN-680069
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE g_i             LIKE type_file.num5          #count/index for any purpose    #No.FUN-680069 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680069 INTEGER
 
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5        #No.FUN-680069 SMALLINT
DEFINE   g_void          LIKE type_file.chr1          #CHI-C80041

MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5            #No.FUN-680069 SMALLINT
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
 
    LET g_forupd_sql = "SELECT * FROM cns_file WHERE cns00 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t700_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW t700_w AT p_row,p_col
        WITH FORM "aco/42f/acot700"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-630014 --start--
    # 先以g_argv2判斷直接執行哪種功能
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t700_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t700_a()
             END IF
         OTHERWISE
            CALL t700_q()
       END CASE
    END IF
    #FUN-630014 ---end---
 
    CALL t700_menu()
    CLOSE WINDOW t700_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION t700_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
 
#FUN-630014-start 
  IF NOT cl_null(g_argv1) THEN
     LET g_wc = "cns00='",g_argv1 CLIPPED,"'"
     LET g_wc2= ' 1=1'
  ELSE
#FUN-630014-end
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
   INITIALIZE g_cns.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                              # 螢幕上取單頭條件
        cns00,cns01,cns02,cns03,
        cnsconf,cnsuser,cnsgrup,cnsmodu,cnsdate,cnsacti
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
    ON ACTION controlp                        # 沿用所有欄位
           CASE
               #No.MOD-490398
              WHEN INFIELD(cns01)      #核銷手冊編號
                CALL q_coc2(TRUE,TRUE,g_cns.cns01,'','','','','')
                     RETURNING g_cns.cns01
                DISPLAY BY NAME g_cns.cns01
                NEXT FIELD cns01
              WHEN INFIELD(cns02)      #轉入手冊編號
                CALL q_coc2(TRUE,TRUE,g_cns.cns02,'','','','','')
                     RETURNING g_cns.cns02
                DISPLAY BY NAME g_cns.cns02
                NEXT FIELD cns02
               #No.MOD-490398  end
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
    CONSTRUCT g_wc2 ON cnt02,cnt03,cnt05,cnt051,           #螢幕上取單身條件
                       cnt06,cnt061,cnt062,cnt07,cnt08,cnt09,cnt10,cnt11
            FROM s_cnt[1].cnt02,s_cnt[1].cnt03,
                 s_cnt[1].cnt05,s_cnt[1].cnt051,
                 s_cnt[1].cnt06,s_cnt[1].cnt061,s_cnt[1].cnt062,
                 s_cnt[1].cnt07,s_cnt[1].cnt08,s_cnt[1].cnt09,
                 s_cnt[1].cnt10,s_cnt[1].cnt11
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       ON ACTION controlp
            CASE
               WHEN INFIELD(cnt02)              #備案序號
                    CALL q_coe(4,2,g_coc01,g_cnt1[1].cnt02)
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cnt02
                    NEXT FIELD cnt02
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
 
  END IF    #FUN-630014 add
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND cnsuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND cnsgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET g_wc = g_wc clipped," AND cnsgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnsuser', 'cnsgrup')
    #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT cns00 FROM cns_file ",
                   " WHERE ", g_wc CLIPPED,
                   "  AND cns00 IS NOT NULL ",
                   " ORDER BY cns00"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cns00 ",
                   "  FROM cns_file, cnt_file ",
                   " WHERE cns00 = cnt01",
                   "  AND cns00 IS NOT NULL ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY cns00"
    END IF
 
    PREPARE t700_prepare FROM g_sql
    DECLARE t700_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t700_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM cns_file ",
                  " WHERE " ,g_wc CLIPPED,
                   "  AND cns00 IS NOT NULL "
    ELSE
        LET g_sql="SELECT COUNT(*) FROM cns_file,cnt_file ",
                  " WHERE cnt01=cns00 ",
                  "  AND cns00 IS NOT NULL ",
                  "  AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t700_precount FROM g_sql
    DECLARE t700_count CURSOR FOR t700_precount
END FUNCTION
 
FUNCTION t700_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069 VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL t700_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t700_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t700_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t700_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t700_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t700_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t700_b()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cnt1),'','')
             END IF
         #--
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t700_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t700_z()
            END IF
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_cns.cns00 IS NOT NULL THEN
                 LET g_doc.column1 = "cns00"
                 LET g_doc.value1 = g_cns.cns00
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t700_v()
               IF g_cns.cnsconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_cns.cnsconf,"","","",g_void,g_cns.cnsacti)
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t700_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550036        #No.FUN-680069 SMALLINT
    MESSAGE ""
    CLEAR FORM
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_cns.* LIKE cns_file.*             #DEFAULT 設置
    LET g_cns00_t = NULL
    LET g_cns_t.* = g_cns.*
    LET g_cns_o.* = g_cns.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cns.cns03 = g_today
        LET g_cns.cnsconf='N'
        LET g_cns.cnsuser=g_user
        LET g_cns.cnsoriu = g_user #FUN-980030
        LET g_cns.cnsorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_cns.cnsgrup=g_grup
        LET g_cns.cnsdate=g_today
        LET g_cns.cnsacti='Y'              #資料有效
        LET g_cns.cnsplant = g_plant #FUN-980002
        LET g_cns.cnslegal = g_legal #FUN-980002
 
        BEGIN WORK
        CALL t700_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #用戶不玩了
            INITIALIZE g_cns.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_cns.cns00 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
#No.FUN-550036 --start--
#       IF cl_null(g_cns.cns00[g_no_sp,g_no_ep]) THEN
        CALL s_auto_assign_no("aco",g_cns.cns00,g_cns.cns03,"19","cns_file","cns00","","","")
        RETURNING li_result,g_cns.cns00
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
#       IF cl_null(g_cns.cns00[5,10]) THEN              #自動編號
#          CALL s_acoauno(g_cns.cns00,g_cns.cns03,'19')
#            RETURNING g_i,g_cns.cns00
#          IF g_i THEN CONTINUE WHILE END IF
           DISPLAY BY NAME g_cns.cns00
#       END IF
        INSERT INTO cns_file VALUES (g_cns.*)
#       LET g_t1 = g_cns.cns00[1,3]           #備份上一筆單別
        LET g_t1 = s_get_doc_no(g_cns.cns00)  #No.FUN-550036
#No.FUN-550036 ---end---
        IF SQLCA.sqlcode THEN                 #置入資料庫不成功
#            CALL cl_err(g_cns.cns00,SQLCA.sqlcode,1) #No.TQC-660045
             CALL cl_err3("ins","cns_file",g_cns.cns00,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
            ROLLBACK WORK
            CONTINUE WHILE
        ELSE
            COMMIT WORK
            CALL cl_flow_notify(g_cns.cns00,'I')
        END IF
        SELECT cns00 INTO g_cns.cns00 FROM cns_file
            WHERE cns00 = g_cns.cns00
        LET g_cns00_t = g_cns.cns00        #保留舊值
        LET g_cns_t.* = g_cns.*
        LET g_cns_o.* = g_cns.*
        LET g_rec_b=0
        CALL t700_g_b()                 #自動生成單身
        CALL t700_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t700_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cns.cns00 IS NULL THEN
        CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_cns.* FROM cns_file WHERE cns00=g_cns.cns00
    IF g_cns.cnsacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cns.cns00,'mfg1000',0) RETURN
    END IF
    IF g_cns.cnsconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_cns.cnsconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_cns.cns00,'axm-101',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cns00_t = g_cns.cns00
    BEGIN WORK
 
    OPEN t700_cl USING g_cns.cns00
    IF STATUS THEN
       CALL cl_err("OPEN t700_cl:", STATUS, 1)
       CLOSE t700_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t700_cl INTO g_cns.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t700_cl
        RETURN
    END IF
    CALL t700_show()
    WHILE TRUE
        LET g_cns00_t = g_cns.cns00
        LET g_cns_o.* = g_cns.*
        LET g_cns.cnsmodu=g_user
        LET g_cns.cnsdate=g_today
        CALL t700_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cns.*=g_cns_t.*
            CALL t700_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_cns.cns00 != g_cns00_t THEN            # 更改單號
            UPDATE cnt_file SET cnt01 = g_cns.cns00
                WHERE cnt01 = g_cns00_t
            IF SQLCA.sqlcode THEN
#                CALL cl_err('cnt',SQLCA.sqlcode,0) #No.TQC-660045
                 CALL cl_err3("upd","cnt_file",g_cns00_t,"",SQLCA.SQLCODE,"","cnt",1)       #NO.TQC-660045
                  CONTINUE WHILE
            END IF
        END IF
        UPDATE cns_file SET cns_file.* = g_cns.*
            WHERE cns00 = g_cns00_t
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0) #No.TQC-660045
             CALL cl_err3("upd","cns_file",g_cns00_t,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t700_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cns.cns00,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t700_i(p_cmd)
DEFINE   li_result   LIKE type_file.num5         #No.FUN-550036 #No.FUN-680069 SMALLINT
DEFINE
    l_n,l_i        LIKE type_file.num5,          #No.FUN-680069 SMALLINT
     l_coc04        LIKE coc_file.coc04,         #No.MOD-490398
    p_cmd          LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0033
 
    INPUT BY NAME g_cns.cnsoriu,g_cns.cnsorig,
        g_cns.cns00,g_cns.cns03,g_cns.cns01,g_cns.cns02,
        g_cns.cnsconf,g_cns.cnsuser,
        g_cns.cnsgrup,g_cns.cnsmodu,g_cns.cnsdate,g_cns.cnsacti
                      WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t700_set_entry(p_cmd)
            CALL t700_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         #No.FUN-550036 --start--
         CALL cl_set_docno_format("cns00")
         #No.FUN-550036 ---end---
 
      {
        BEFORE FIELD cns00    #本系統不允許更改key
            IF p_cmd = 'u'  AND g_chkey = 'N' THEN
               NEXT FIELD cns02
            END IF
      }
        AFTER FIELD cns00
         #No.FUN-550036 --start--
            IF NOT cl_null(g_cns.cns00) THEN
            CALL s_check_no("aco",g_cns.cns00,g_cns00_t,"19","cns_file","cns00","")
            RETURNING li_result,g_cns.cns00
            DISPLAY BY NAME g_cns.cns00
            IF (NOT li_result) THEN
               LET g_cns.cns00=g_cns_o.cns00
               NEXT FIELD cns00
            END IF
 
#              LET g_t1=g_cns.cns00[1,3]
#              CALL s_acoslip(g_t1,'19',g_sys)             #檢查單別
#              IF NOT cl_null(g_errno) THEN                #抱歉, 有問題
#                 CALL cl_err(g_t1,g_errno,0)
#                 LET g_cns.cns00=g_cns_o.cns00
#                 NEXT FIELD cns00
#              END IF
#              IF p_cmd = 'a'  THEN
#          IF g_cns.cns00[1,3] IS NOT NULL AND       #並且單號空白時,
#          	  cl_null(g_cns.cns00[5,10]) THEN           #請用戶自行輸入
#             IF g_coy.coyauno = 'N' THEN            #新增並要不自動編號
#                NEXT FIELD cns00
#             ELSE					 #要不, 則單號不用
#                NEXT FIELD cns03			 #輸入
# 	             END IF
#           END IF
#           IF g_cns.cns00[1,3] IS NOT NULL AND	 #並且單號空白時,
#          	   NOT cl_null(g_cns.cns00[5,10]) THEN	 #請用戶自行輸入
#                     IF NOT cl_chk_data_continue(g_cns.cns00[5,10]) THEN
#                        CALL cl_err('','9056',0)
#                        NEXT FIELD cns00
#                     END IF
#                  END IF
#              END IF
#              IF g_cns.cns00 != g_cns00_t OR g_cns00_t IS NULL THEN
#                  SELECT COUNT(*) INTO l_n FROM cns_file
#                      WHERE cns00 = g_cns.cns00
#                  IF l_n > 0 THEN   #單據編號重複
#                      CALL cl_err(g_cns.cns00,-239,0)
#                      LET g_cns.cns00 = g_cns00_t
#                      DISPLAY BY NAME g_cns.cns00
#                      NEXT FIELD cns00
#                  END IF
               END IF
 #No.FUN-550036 ---end---
 
        AFTER FIELD cns01
            IF NOT cl_null(g_cns.cns01) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_cns.cns01 != g_cns_t.cns01) THEN
                  SELECT COUNT(*) INTO l_n FROM cns_file
                   WHERE cns01 = g_cns.cns01
                  IF l_n > 0 THEN
                     CALL cl_err(g_cns.cns01,'aco-057',0) NEXT FIELD cns01
                  END IF
                  CALL t700_cns01('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_cns.cns01,g_errno,0)
                     LET g_cns.cns01 = g_cns_t.cns01
                     DISPLAY BY NAME g_cns.cns01
                     NEXT FIELD cns01
                  END IF
               END IF
            END IF
 
        AFTER FIELD cns02
            IF NOT cl_null(g_cns.cns02) THEN
               IF g_cns.cns01 = g_cns.cns02 THEN
                  CALL cl_err('','aco-059',0)
                  NEXT FIELD cns02
               END IF
               CALL t700_cns02('a')
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                  NEXT FIELD cns02
                  LET g_cns.cns02 = g_cns_t.cns02
                  DISPLAY BY NAME g_cns.cns02
               END IF
            END IF
 
        ON ACTION controlp                        # 沿用所有欄位
            CASE
              WHEN INFIELD(cns00) #單別
                   #CALL q_coy(FALSE,TRUE,g_cns.cns00,'19',g_sys) RETURNING g_cns.cns00  #TQC-670008
                   CALL q_coy(FALSE,TRUE,g_cns.cns00,'19','ACO') RETURNING g_cns.cns00   #TQC-670008
#                   CALL FGL_DIALOG_SETBUFFER( g_cns.cns00 )
                   DISPLAY BY NAME g_cns.cns00
                   NEXT FIELD cns00
               #No.MOD-490398
              WHEN INFIELD(cns01)
                   CALL q_coc2(FALSE,TRUE,g_cns.cns01,g_cns.cns03,'','','','')
                        RETURNING g_cns.cns01,l_coc04
                   DISPLAY BY NAME g_cns.cns01
                   NEXT FIELD cns01
              WHEN INFIELD(cns02)
                   CALL q_coc2(FALSE,TRUE,g_cns.cns02,g_cns.cns03,'','','','')
                        RETURNING g_cns.cns02,l_coc04
                   DISPLAY BY NAME g_cns.cns02
                   NEXT FIELD cns02
               #No.MOD-490398  end
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
 
FUNCTION t700_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cns00,cns01",TRUE)
    END IF
    IF INFIELD(cnm04) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("cnm07",TRUE)
    END IF
END FUNCTION
 
FUNCTION t700_set_no_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cns00,cns01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t700_cns01(p_cmd)  #核銷手冊編號
    DEFINE l_coc02   LIKE coc_file.coc02,
           l_coc05   LIKE coc_file.coc05,
           l_coc10   LIKE coc_file.coc10,         #No.MOD-493098
           l_coc07   LIKE coc_file.coc07,
           l_coc03   LIKE coc_file.coc03,
           l_cocacti LIKE coc_file.cocacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
     #No.MOD-490398
    SELECT coc01,coc02,coc03,coc05,coc10,coc07,cocacti
      INTO g_coc01,l_coc02,l_coc03,l_coc05,l_coc10,l_coc07,l_cocacti
      FROM coc_file WHERE coc03 = g_cns.cns01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-062'
                                   LET l_coc02 = NULL
                                   LET l_coc03 = NULL
                                   LET l_coc05 = NULL
                                   LET l_coc10 = NULL
                                   LET l_coc07 = NULL
         WHEN l_cocacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(l_coc07) AND l_coc07 < g_today THEN
       LET g_errno='aco-057'
    END IF
    IF cl_null(g_errno) OR p_cmd='d' THEN
       DISPLAY l_coc02 TO FORMONLY.coc02
       DISPLAY l_coc03 TO FORMONLY.coc03
       DISPLAY l_coc05 TO FORMONLY.coc05
       DISPLAY l_coc10 TO FORMONLY.coc10
    END IF
     #No.MOD-490398  --end
END FUNCTION
 
FUNCTION t700_cns02(p_cmd)  #轉入手冊編號
    DEFINE l_coc02   LIKE coc_file.coc02,
           l_coc05   LIKE coc_file.coc05,
           l_coc10   LIKE coc_file.coc10,  #No.MOD-490398
           l_coc07   LIKE coc_file.coc07,
           l_coc03   LIKE coc_file.coc03,
           l_cocacti LIKE coc_file.cocacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT coc01,coc02,coc03,coc05,coc10,coc07,cocacti
      INTO g_coc01_2,l_coc02,l_coc03,l_coc05,l_coc10,l_coc07,l_cocacti
       FROM coc_file WHERE coc03 = g_cns.cns02           #No.MOD-490398
 
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-062'   #No.MOD-490398
                                   LET l_coc02 = NULL
                                   LET l_coc03 = NULL
                                   LET l_coc05 = NULL
                                   LET l_coc10 = NULL
                                   LET l_coc07 = NULL
         WHEN l_cocacti='N' LET g_errno = '9028'
         WHEN l_coc05 < g_today    LET g_errno = 'aco-056'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(l_coc07) AND l_coc07 < g_today THEN
       LET g_errno='aco-057'
    END IF
    IF cl_null(g_errno) OR p_cmd='d' THEN
       DISPLAY l_coc02 TO FORMONLY.coc02_2
       DISPLAY l_coc03 TO FORMONLY.coc03_2
       DISPLAY l_coc05 TO FORMONLY.coc05_2
       DISPLAY l_coc10 TO FORMONLY.coc10_2
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t700_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cns.* TO NULL               #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL g_cnt1.clear()                     #No.FUN-6A0168
    CLEAR FORM
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t700_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_cns.* TO NULL
        RETURN
    END IF
    OPEN t700_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cns.* TO NULL
    ELSE
        OPEN t700_count
        FETCH t700_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t700_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t700_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t700_cs INTO g_cns.cns00
        WHEN 'P' FETCH PREVIOUS t700_cs INTO g_cns.cns00
        WHEN 'F' FETCH FIRST    t700_cs INTO g_cns.cns00
        WHEN 'L' FETCH LAST     t700_cs INTO g_cns.cns00
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
         FETCH ABSOLUTE g_jump t700_cs INTO g_cns.cns00
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0)
        INITIALIZE g_cns.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_cns.* FROM cns_file WHERE cns00 = g_cns.cns00
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cns_file",g_cns.cns00,"",SQLCA.SQLCODE,"","",1) #No.TQC-660045
        INITIALIZE g_cns.* TO NULL
        RETURN
    END IF
 
    CALL t700_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t700_show()
    LET g_cns_t.* = g_cns.*                #保存單頭舊值
    LET g_cns_o.* = g_cns.*                #保存單頭舊值
    DISPLAY BY NAME g_cns.cnsoriu,g_cns.cnsorig,
 
        g_cns.cns00,g_cns.cns01,g_cns.cns02,g_cns.cns03,
        g_cns.cnsconf,g_cns.cnsuser,
        g_cns.cnsgrup,g_cns.cnsmodu,g_cns.cnsdate,g_cns.cnsacti
    #CALL cl_set_field_pic(g_cns.cnsconf,"","","","",g_cns.cnsacti)  #CHI-C80041
    IF g_cns.cnsconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cns.cnsconf,"","","",g_void,g_cns.cnsacti)   #CHI-C80041
    CALL t700_cns01('d')
    CALL t700_cns02('d')
    CALL t700_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t700_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cns.cns00 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t700_cl USING g_cns.cns00
    IF STATUS THEN
       CALL cl_err("OPEN t700_cl:", STATUS, 1)
       CLOSE t700_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t700_cl INTO g_cns.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t700_show()
    IF cl_exp(0,0,g_cns.cnsacti) THEN                   #審核一下
        LET g_chr=g_cns.cnsacti
        IF g_cns.cnsacti='Y' THEN
            LET g_cns.cnsacti='N'
        ELSE
            LET g_cns.cnsacti='Y'
        END IF
        UPDATE cns_file                    #更改有效碼
            SET cnsacti=g_cns.cnsacti
            WHERE cns00=g_cns.cns00
        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0) #No.TQC-660045
             CALL cl_err3("upd","cns_file",g_cns.cns00,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
            LET g_cns.cnsacti=g_chr
        END IF
        DISPLAY BY NAME g_cns.cnsacti
    END IF
    CLOSE t700_cl
    COMMIT WORK
 
    #CALL cl_set_field_pic(g_cns.cnsconf,"","","","",g_cns.cnsacti)  #CHI-C80041
    IF g_cns.cnsconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cns.cnsconf,"","","",g_void,g_cns.cnsacti)   #CHI-C80041
    CALL cl_flow_notify(g_cns.cns00,'V')
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t700_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cns.cns00 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    SELECT * INTO g_cns.* FROM cns_file WHERE cns00=g_cns.cns00
    IF g_cns.cnsacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cns.cns00,'mfg1000',0)
        RETURN
    END IF
    IF g_cns.cnsconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_cns.cnsconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_cns.cns00,'axm-101',0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t700_cl USING g_cns.cns00
    IF STATUS THEN
       CALL cl_err("OPEN t700_cl:", STATUS, 1)
       CLOSE t700_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t700_cl INTO g_cns.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t700_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cns00"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cns.cns00      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
            DELETE FROM cns_file WHERE cns00 = g_cns.cns00
            DELETE FROM cnt_file WHERE cnt01 = g_cns.cns00
        #No.MOD-490398
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980002 add azoplant,azolegal
          VALUES ('acot700',g_user,g_today,g_msg,g_cns.cns00,'delete',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
        #No.MOD-490398 end
            CLEAR FORM
 
         OPEN t700_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE t700_cs
             CLOSE t700_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH t700_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t700_cs
             CLOSE t700_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t700_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t700_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t700_fetch('/')
         END IF
    END IF
    CLOSE t700_cl
    COMMIT WORK
    CALL cl_flow_notify(g_cns.cns00,'D')
END FUNCTION
 
#單身
FUNCTION t700_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680069 VARCHAR(1)
    l_coe07         LIKE coe_file.coe07,
    l_cnt07         LIKE cnt_file.cnt07,
    l_cnt051        LIKE cnt_file.cnt051,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_cns.cns00 IS NULL THEN RETURN END IF
    SELECT * INTO g_cns.* FROM cns_file WHERE cns00=g_cns.cns00
    IF g_cns.cnsacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cns.cns00,'mfg1000',0) RETURN
    END IF
    IF g_cns.cnsconf ='X' THEN RETURN END IF  #CHI-C80041
    IF g_cns.cnsconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_cns.cns00,'axm-101',0) RETURN
    END IF
    LET g_success='Y'
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT cnt02,cnt03,'','',cnt05,cnt051,cnt06,cnt061,cnt062, ",
                       "  cnt07,cnt08,cnt09,cnt10,cnt11 ",
                       "   FROM cnt_file ",
                       "  WHERE cnt01=? AND cnt02=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
        IF g_rec_b=0 THEN CALL g_cnt1.clear() END IF
 
         INPUT ARRAY g_cnt1 WITHOUT DEFAULTS FROM s_cnt.*
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
 
            OPEN t700_cl USING g_cns.cns00
            IF STATUS THEN
               CALL cl_err("OPEN t700_cl:", STATUS, 1)
               CLOSE t700_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t700_cl INTO g_cns.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t700_cl
              RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_cnt1_t.* = g_cnt1[l_ac].*  #BACKUP
                LET g_cnt1_o.* = g_cnt1[l_ac].*  #BACKUP
 
                OPEN t700_bcl USING g_cns.cns00,g_cnt1_t.cnt02
                IF STATUS THEN
                   CALL cl_err("OPEN t700_bcl:", STATUS, 1)
                   CLOSE t700_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t700_bcl INTO g_cnt1[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cnt1_t.cnt02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL t700_cnt02('d')
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
#           NEXT FIELD cnt02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG=0
 
              INITIALIZE g_cnt1[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_cnt1[l_ac].* TO s_cnt1.*
              CALL g_cnt1.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            IF g_cnt1[l_ac].cnt03 IS NULL  THEN  #重要欄位空白,無效
               INITIALIZE g_cnt1[l_ac].* TO NULL
            END IF
            INSERT INTO cnt_file(cnt01,cnt02,cnt03,
                                 cnt05,cnt051,cnt06,cnt061,cnt062,
                                 #cnt07,cnt08,cnt09,cnt10,cnt11) #FUN-980002
                                 cnt07,cnt08,cnt09,cnt10,cnt11,  #FUN-980002
                                 cntplant,cntlegal) #FUN-980002
            VALUES(g_cns.cns00,g_cnt1[l_ac].cnt02,
                   g_cnt1[l_ac].cnt03,g_cnt1[l_ac].cnt05,
                   g_cnt1[l_ac].cnt051,g_cnt1[l_ac].cnt06,
                   g_cnt1[l_ac].cnt061,g_cnt1[l_ac].cnt062,
                   g_cnt1[l_ac].cnt07,g_cnt1[l_ac].cnt08,
                   g_cnt1[l_ac].cnt09,g_cnt1[l_ac].cnt10,
                   g_cnt1[l_ac].cnt11,g_plant,g_legal) #FUN-980002
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","cnt_file",g_cns.cns00,g_cnt1[l_ac].cnt02,SQLCA.SQLCODE,"","",1)       #NO.TQC-660045     #FUN-B80045   ADDA 
                ROLLBACK WORK
                CANCEL INSERT
#                CALL cl_err(g_cnt1[l_ac].cnt02,SQLCA.sqlcode,0) #No.TQC-660045
#                 CALL cl_err3("ins","cnt_file",g_cns.cns00,g_cnt1[l_ac].cnt02,SQLCA.SQLCODE,"","",1)       #NO.TQC-660045   #FUN-B80045   MARK
                LET g_cnt1[l_ac].* = g_cnt1_t.*
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
            INITIALIZE g_cnt1[l_ac].* TO NULL       #900423
            LET g_cnt1[l_ac].cnt05 = 0              #Body default
            LET g_cnt1[l_ac].cnt051= 0
            LET g_cnt1[l_ac].cnt06 = 0
            LET g_cnt1[l_ac].cnt061= 0
            LET g_cnt1[l_ac].cnt062= 0
            LET g_cnt1[l_ac].cnt07 = 0
            LET g_cnt1[l_ac].cnt08 = 0
            LET g_cnt1[l_ac].cnt09 = 0
            LET g_cnt1[l_ac].cnt10 = 0
            LET g_cnt1[l_ac].cnt11 = 0
            LET g_cnt1_t.* = g_cnt1[l_ac].*          #新輸入資料
            LET g_cnt1_o.* = g_cnt1[l_ac].*          #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnt02
 
        BEFORE FIELD cnt02                        #default 序號
            IF g_cnt1[l_ac].cnt02 IS NULL OR g_cnt1[l_ac].cnt02 = 0 THEN
                SELECT max(cnt02)+1
                   INTO g_cnt1[l_ac].cnt02
                   FROM cnt_file
                   WHERE cnt01 = g_cns.cns00
                IF g_cnt1[l_ac].cnt02 IS NULL THEN
                    LET g_cnt1[l_ac].cnt02 = 1
                END IF
#               DISPLAY g_cnt1[l_ac].cnt02 TO cnt02 #No.FUN-570273預設值不可使用
            END IF
 
        AFTER FIELD cnt02                        #check 序號是否重複
            IF NOT cl_null(g_cnt1[l_ac].cnt02) THEN
               IF g_cnt1[l_ac].cnt02 != g_cnt1_t.cnt02 OR
                  g_cnt1_t.cnt02 IS NULL THEN
                   SELECT count(*) INTO l_n
                       FROM cnt_file
                       WHERE cnt01 = g_cns.cns00 AND
                             cnt02 = g_cnt1[l_ac].cnt02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cnt1[l_ac].cnt02 = g_cnt1_t.cnt02
                       NEXT FIELD cnt02
                   END IF
                   CALL t700_cnt02('a')
                   IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_cnt1[l_ac].cnt02,g_errno,0)
                      LET g_cnt1[l_ac].cnt02 = g_cnt1_o.cnt02
                      DISPLAY g_cnt1[l_ac].cnt02 TO cnt02
                      NEXT FIELD cnt02
                   END IF
               END IF
            END IF
 
        AFTER FIELD cnt10
            IF g_cnt1[l_ac].cnt10 = 0 THEN NEXT FIELD cnt10 END IF
            IF g_cnt1[l_ac].cnt10 != g_cnt1_t.cnt10
               OR g_cnt1_t.cnt10 IS NULL THEN
               SELECT coe07 INTO l_coe07 FROM coe_file
                WHERE coe01=g_coc01 AND coe02 = g_cnt1[l_ac].cnt02
               CALL s_getcod(g_cns.cns01,g_cnt1[l_ac].cnt03)
                            RETURNING l_cnt07,l_cnt051
               IF (g_cnt1[l_ac].cnt05 - l_cnt051) < g_cnt1[l_ac].cnt10 THEN
                  CALL cl_err('','aco-004',0)
                  NEXT FIELD cnt10
               ELSE
                  LET g_cnt1[l_ac].cnt11 = g_cnt1[l_ac].cnt10 * l_coe07
                  DISPLAY g_cnt1[l_ac].cnt11 TO cnt11
               END IF
            END IF
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_cnt1_t.cnt02 > 0 AND
               g_cnt1_t.cnt02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM cnt_file
                    WHERE cnt01 = g_cns.cns00 AND
                          cnt02 = g_cnt1_t.cnt02
                IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_cnt1_t.cnt02,SQLCA.sqlcode,0) #No.TQC-660045
                     CALL cl_err3("del","cnt_file",g_cns.cns00,g_cnt1_t.cnt02,SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
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
               LET g_cnt1[l_ac].* = g_cnt1_t.*
               CLOSE t700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cnt1[l_ac].cnt02,-263,1)
               LET g_cnt1[l_ac].* = g_cnt1_t.*
            ELSE
               IF g_cnt1[l_ac].cnt03 IS NULL  THEN  #重要欄位空白,無效
                  INITIALIZE g_cnt1[l_ac].* TO NULL
               END IF
               UPDATE cnt_file SET
                   cnt02=g_cnt1[l_ac].cnt02,   cnt03=g_cnt1[l_ac].cnt03,
                   cnt05=g_cnt1[l_ac].cnt05,   cnt051=g_cnt1[l_ac].cnt051,
                   cnt06=g_cnt1[l_ac].cnt06,   cnt061=g_cnt1[l_ac].cnt061,
                   cnt062=g_cnt1[l_ac].cnt062, cnt07=g_cnt1[l_ac].cnt07,
                   cnt08=g_cnt1[l_ac].cnt08,   cnt09=g_cnt1[l_ac].cnt09,
                   cnt10=g_cnt1[l_ac].cnt10,   cnt11=g_cnt1[l_ac].cnt11
               WHERE cnt01=g_cns.cns00 AND cnt02=g_cnt1_t.cnt02
               IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cnt1[l_ac].cnt02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("upd","cnt_file",g_cns.cns00,g_cnt1_t.cnt02,SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
                   LET g_cnt1[l_ac].* = g_cnt1_t.*
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
                  LET g_cnt1[l_ac].* = g_cnt1_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cnt1.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add
          #LET g_cnt1_t.* = g_cnt1[l_ac].*          # 900423
            CLOSE t700_bcl
            COMMIT WORK
 
           #CALL g_cnt1.deleteElement(g_rec_b+1)    #FUN-D30034 Mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cnt02) AND l_ac > 1 THEN
                LET g_cnt1[l_ac].* = g_cnt1[l_ac-1].*
                NEXT FIELD cnt02
            END IF
        ON ACTION controls                       # No.FUN-6B0033
           CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0033
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(cnt02)              #備案序號
                    CALL q_coe(4,2,g_coc01,g_cnt1[l_ac].cnt02)
                          RETURNING g_coc01,g_cnt1[l_ac].cnt02
#                    CALL FGL_DIALOG_SETBUFFER( g_coc01 )
#                    CALL FGL_DIALOG_SETBUFFER( g_cnt1[l_ac].cnt02 )
                    DISPLAY g_cnt1[l_ac].cnt02 TO cnt02
                    NEXT FIELD cnt02
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
         LET g_cns.cnsmodu = g_user
         LET g_cns.cnsdate = g_today
         UPDATE cns_file SET cnsmodu = g_cns.cnsmodu,cnsdate = g_cns.cnsdate
          WHERE cns01 = g_cns.cns01
         DISPLAY BY NAME g_cns.cnsmodu,g_cns.cnsdate
        #FUN-5B0043-end
 
        CLOSE t700_bcl
        COMMIT WORK
        CALL t700_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t700_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_cns.cns00) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM cns_file ",
                  "  WHERE cns00 LIKE '",l_slip,"%' ",
                  "    AND cns00 > '",g_cns.cns00,"'"
      PREPARE t700_pb1 FROM l_sql 
      EXECUTE t700_pb1 INTO l_cnt       
      
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
         CALL t700_v()
         IF g_cns.cnsconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_cns.cnsconf,"","","",g_void,g_cns.cnsacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM cns_file WHERE cns00 = g_cns.cns00
         INITIALIZE g_cns.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t700_delall()
    SELECT COUNT(*) INTO g_cnt FROM cnt_file
        WHERE cnt01 = g_cns.cns00
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否撤銷單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM cns_file WHERE cns00 = g_cns.cns00
    END IF
END FUNCTION
 
FUNCTION t700_cnt02(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_cnt03   LIKE cnt_file.cnt03,
           l_cnt07   LIKE cnt_file.cnt07,
           l_cnt051  LIKE cnt_file.cnt051,
           l_coe05   LIKE coe_file.coe05,
           l_coe051  LIKE coe_file.coe051,
           l_coe06   LIKE coe_file.coe06,
           l_coe101  LIKE coe_file.coe101,
           l_coe103  LIKE coe_file.coe103,
           l_qty     LIKE cnt_file.cnt05
 
    LET g_errno = ' '
    SELECT coe03,coe051,coe06,(coe101-coe102),(coe05+coe10),
           (coe103-coe104)
      INTO l_cnt03,l_coe051,l_coe06,l_coe101,l_coe05,l_coe103
      FROM coe_file
     WHERE coe01=g_coc01 AND coe02=g_cnt1[l_ac].cnt02
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-026'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #取得成品折算量與成品耗量
    CALL s_getcod(g_cns.cns01,l_cnt03)
                RETURNING l_cnt07,l_cnt051
    IF p_cmd = 'a' THEN
       LET g_cnt1[l_ac].cnt03  = l_cnt03
       LET g_cnt1[l_ac].cnt051 = l_cnt051
       LET g_cnt1[l_ac].cnt06  = l_coe051
       LET g_cnt1[l_ac].cnt061 = l_coe101
       LET g_cnt1[l_ac].cnt062 = l_coe05
       LET g_cnt1[l_ac].cnt08  = l_coe103
       LET g_cnt1[l_ac].cnt07  = l_cnt07
       LET g_cnt1[l_ac].cnt051 = l_cnt051
       LET g_cnt1[l_ac].cnt05 = g_cnt1[l_ac].cnt06 + g_cnt1[l_ac].cnt061
                               + g_cnt1[l_ac].cnt062
       LET g_cnt1[l_ac].cnt10 = g_cnt1[l_ac].cnt05 - g_cnt1[l_ac].cnt051
       DISPLAY g_cnt1[l_ac].cnt03  TO cnt03
       DISPLAY g_cnt1[l_ac].cnt051 TO cnt051
       DISPLAY g_cnt1[l_ac].cnt06  TO cnt06
       DISPLAY g_cnt1[l_ac].cnt061 TO cnt061
       DISPLAY g_cnt1[l_ac].cnt062 TO cnt062
       DISPLAY g_cnt1[l_ac].cnt08  TO cnt08
       DISPLAY g_cnt1[l_ac].cnt07  TO cnt07
       DISPLAY g_cnt1[l_ac].cnt051 TO cnt051
       DISPLAY g_cnt1[l_ac].cnt10  TO cnt10
       DISPLAY g_cnt1[l_ac].cnt05  TO cnt05
 
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_cnt1[l_ac].coe06 = l_coe06
       SELECT cob02 INTO g_cnt1[l_ac].cob02
         FROM cob_file WHERE cob01=g_cnt1[l_ac].cnt03
       DISPLAY g_cnt1[l_ac].cob02 TO FORMONLY.cob02
       DISPLAY g_cnt1[l_ac].coe06 TO FORMONLY.coe06
    END IF
END FUNCTION
 
FUNCTION t700_g_b()
  DEFINE l_coe RECORD LIKE coe_file.*
  DEFINE l_cnt RECORD LIKE cnt_file.*
  DEFINE l_count      LIKE type_file.num5         #No.FUN-680069 SMALLINT
 
  IF NOT cl_confirm('aap-718') THEN RETURN END IF
  LET l_count = 0
  DECLARE t700_g_cs CURSOR FOR
   SELECT * INTO l_coe.* FROM coe_file WHERE coe01=g_coc01
  FOREACH t700_g_cs INTO l_coe.*
      LET l_count = l_count + 1
      LET l_cnt.cnt01 = g_cns.cns00
      LET l_cnt.cnt02 = l_coe.coe02
      LET l_cnt.cnt03 = l_coe.coe03
      CALL s_getcod(g_cns.cns01,l_cnt.cnt03)
        RETURNING l_cnt.cnt07,l_cnt.cnt051
      LET l_cnt.cnt06 = l_coe.coe051
      LET l_cnt.cnt061= l_coe.coe101-l_coe.coe102
      LET l_cnt.cnt062= l_coe.coe05 + l_coe.coe10
      LET l_cnt.cnt08 = l_coe.coe103-l_coe.coe104
      LET l_cnt.cnt09 = 0
      LET l_cnt.cnt05 = l_cnt.cnt06+l_cnt.cnt061 +l_cnt.cnt062
      LET l_cnt.cnt10 = l_cnt.cnt05 - l_cnt.cnt051
      #剩餘量 <= 0 則不生成
      IF l_cnt.cnt10 <= 0 THEN
         CONTINUE FOREACH
      END IF
      LET l_cnt.cnt11 = l_cnt.cnt10 * l_coe.coe07
      LET l_cnt.cntplant = g_plant  #FUN-980002
      LET l_cnt.cntlegal = g_legal  #FUN-980002
 
      INSERT INTO cnt_file VALUES(l_cnt.*)
      IF STATUS THEN
#         CALL cl_err('ins cnt:',STATUS,1) #No.TQC-660045
          CALL cl_err3("ins","cnt_file",l_cnt.cnt01,l_cnt.cnt02,STATUS,"","ins cnt:",1)       #NO.TQC-660045
         EXIT FOREACH
      END IF
  END FOREACH
  IF l_count = 0 THEN CALL cl_err('','aco-058',0) END IF
  CALL t700_b_fill(' 1=1')                 #單身
END FUNCTION
 
 
FUNCTION t700_b_askkey()
DEFINE
    l_wc2      LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON cnt02,cnt03,cnt05,cnt051,           #螢幕上取單身條件
                       cnt06,cnt061,cnt062,cnt07,cnt08,cnt09,cnt10,cnt11
            FROM s_cnt[1].cnt02,s_cnt[1].cnt03,
                 s_cnt[1].cnt05,s_cnt[1].cnt051,
                 s_cnt[1].cnt06,s_cnt[1].cnt061,s_cnt[1].cnt062,
                 s_cnt[1].cnt07,s_cnt[1].cnt08,s_cnt[1].cnt09,
                 s_cnt[1].cnt10,s_cnt[1].cnt11
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
    CALL t700_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t700_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2      LIKE  type_file.chr1000     #No.FUN-680069 VARCHAR(200)
   
 LET g_sql =
        "SELECT cnt02,cnt03,'','',cnt05,cnt051,cnt06,cnt061,cnt062,",
        "       cnt07,cnt08,cnt09,cnt10,cnt11 ",
        "  FROM cnt_file ",
        " WHERE cnt01 ='",g_cns.cns00,"'"   #單頭
    #No.FUN-8B0123---Begin
    #   "   AND ", p_wc2 CLIPPED, #單身
    #   " ORDER BY 1,2"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1,2 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE t700_pb FROM g_sql
    DECLARE cnt_cs                       #SCROLL CURSOR
        CURSOR FOR t700_pb
    CALL g_cnt1.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH cnt_cs INTO g_cnt1[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT coe06 INTO g_cnt1[g_cnt].coe06
          FROM coe_file WHERE coe01=g_coc01 AND coe02=g_cnt1[g_cnt].cnt02
        SELECT cob02 INTO g_cnt1[g_cnt].cob02 FROM cob_file
         WHERE cob01=g_cnt1[g_cnt].cnt03
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
 
    CALL g_cnt1.deleteElement(g_cnt)
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cnt1 TO s_cnt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t700_fetch('L')
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
 
         #CALL cl_set_field_pic(g_cns.cnsconf,"","","","",g_cns.cnsacti)  #CHI-C80041
         IF g_cns.cnsconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_cns.cnsconf,"","","",g_void,g_cns.cnsacti)   #CHI-C80041
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
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t700_y()
 DEFINE s_coc01    LIKE coc_file.coc01
 DEFINE t_coc01    LIKE coc_file.coc01
 DEFINE l_cnt02    LIKE cnt_file.cnt02
 DEFINE l_cnt05    LIKE cnt_file.cnt05
 DEFINE l_cnt10    LIKE cnt_file.cnt10
 DEFINE l_i        LIKE type_file.num5          #No.FUN-680069 SMALLINT
 DEFINE l_coe06    LIKE coe_file.coe06          #FUN-910088--add--
 
   IF g_cns.cns00 IS NULL THEN RETURN END IF
#CHI-C30107 ------------ add ------------ begin
   IF g_cns.cnsacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_cns.cns00,'mfg1000',0)
       RETURN
   END IF
   IF g_cns.cnsconf ='X' THEN RETURN END IF  #CHI-C80041
   IF g_cns.cnsconf='Y' THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM cnt_file
    WHERE cnt01 = g_cns.cns00
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ------------ add ------------ end
   SELECT * INTO g_cns.* FROM cns_file WHERE cns00=g_cns.cns00
   IF g_cns.cnsacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_cns.cns00,'mfg1000',0)
       RETURN
   END IF
   IF g_cns.cnsconf ='X' THEN RETURN END IF  #CHI-C80041
   IF g_cns.cnsconf='Y' THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM cnt_file
    WHERE cnt01 = g_cns.cns00
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
 
   #找出原始的申請編號
   SELECT coc01 INTO s_coc01 FROM coc_file
     WHERE coc03 = g_cns.cns02          #No.MOD-490398
      AND cocacti !='N'  #010807增
   IF cl_null(s_coc01) THEN
      CALL cl_err('sel coc01:','aco-005',1) RETURN
   END IF
   SELECT coc01 INTO t_coc01 FROM coc_file
     WHERE coc03 = g_cns.cns01          #No.MOD-490398
      AND cocacti !='N'  #010807增
   IF cl_null(t_coc01) THEN
      CALL cl_err('sel coc01:','aco-005',1) RETURN
   END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t700_cl USING g_cns.cns00
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t700_cl INTO g_cns.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0)
       CLOSE t700_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   DECLARE firm_cs CURSOR FOR
    SELECT cnt02,cnt10 FROM cnt_file WHERE cnt01 = g_cns.cns00
   FOREACH firm_cs INTO l_cnt02,l_cnt10
      IF STATUS THEN 
      CALL cl_err('foreach:',STATUS,0)
    EXIT FOREACH END IF
    #FUN-910088--add--start--
      SELECT coe06 INTO l_coe06 FROM coe_file
       WHERE coe01 = s_coc01 AND coe02 = l_cnt02
      LET l_cnt10 = s_digqty(l_cnt10,l_coe06)
    #FUN-910088--add--end--
      UPDATE coe_file SET coe051 = (coe051+l_cnt10)   
       WHERE coe01 = s_coc01 AND coe02 = l_cnt02
      IF STATUS THEN 
#        CALL cl_err('upd coe:',STATUS,0) #No.TQC-660045
         CALL cl_err3("upd","coe_file",s_coc01,l_cnt02,STATUS,"","upd coe:",1) #No.TQC-660045
         LET g_success='N'
         EXIT FOREACH
      END IF
   END FOREACH
   #更新核銷日期
   UPDATE coc_file SET coc07 = g_cns.cns03
    WHERE coc01 = t_coc01
   IF STATUS THEN
#      CALL cl_err('upd coc:',STATUS,0) #No.TQC-660045
       CALL cl_err3("upd","coc_file",t_coc01,"",STATUS,"","upd coc:",1)       #NO.TQC-660045
      LET g_success='N'
   END IF
   UPDATE cns_file SET cnsconf='Y'
    WHERE cns00 = g_cns.cns00
   IF STATUS THEN
#      CALL cl_err('upd cofconf',STATUS,0) #No.TQC-660045
       CALL cl_err3("upd","cns_file",g_cns.cns00,"",STATUS,"","upd cofconf",1)       #NO.TQC-660045
      LET g_success='N'
   END IF
   LET l_i = 0
   SELECT COUNT(*) INTO l_i FROM cng_file
     WHERE cng03 = g_cns.cns01              #No.MOD-490398
   IF l_i > 0 THEN
      UPDATE cng_file SET cng07 = g_cns.cns03
        WHERE cng03 = g_cns.cns01           #No.MOD-490398
      IF SQLCA.sqlcode THEN
#         CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0) #No.TQC-660045
          CALL cl_err3("upd","cng_file",g_cns.cns01,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
         LET g_success = 'N'
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_cns.cns00,'Y')
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT cnsconf INTO g_cns.cnsconf FROM cns_file
    WHERE cns00 = g_cns.cns00
   DISPLAY BY NAME g_cns.cnsconf
   #CALL cl_set_field_pic(g_cns.cnsconf,"","","","",g_cns.cnsacti)  #CHI-C80041
   IF g_cns.cnsconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_cns.cnsconf,"","","",g_void,g_cns.cnsacti)   #CHI-C80041
END FUNCTION
 
FUNCTION t700_z()
 DEFINE s_coc01    LIKE coc_file.coc01
 DEFINE t_coc01    LIKE coc_file.coc01
 DEFINE l_cnt05    LIKE cnt_file.cnt05
 DEFINE l_cnt02    LIKE cnt_file.cnt02
 DEFINE l_cnt10    LIKE cnt_file.cnt10
 DEFINE l_i        LIKE type_file.num5          #No.FUN-680069 SMALLINT
 DEFINE l_coe06    LIKE coe_file.coe06          #FUN-910088--add--

   IF g_cns.cns00 IS NULL THEN RETURN END IF
   SELECT * INTO g_cns.* FROM cns_file WHERE cns00=g_cns.cns00
   IF g_cns.cnsacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_cns.cns00,'mfg1000',0)
       RETURN
   END IF
   IF g_cns.cnsconf ='X' THEN RETURN END IF  #CHI-C80041
   IF g_cns.cnsconf='N' THEN RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   #找出原始的申請編號
   SELECT coc01 INTO s_coc01 FROM coc_file
     WHERE coc03 = g_cns.cns02           #No.MOD-490398
      AND cocacti !='N'  #010807增
   IF cl_null(s_coc01) THEN
      CALL cl_err('sel coc01:','aco-005',1) RETURN
   END IF
   SELECT coc01 INTO t_coc01 FROM coc_file
     WHERE coc03 = g_cns.cns01           #No.MOD-490398
      AND cocacti !='N'  #010807增
   IF cl_null(t_coc01) THEN
      CALL cl_err('sel coc01:','aco-005',1) RETURN
   END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t700_cl USING g_cns.cns00
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t700_cl INTO g_cns.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0)
       CLOSE t700_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   DECLARE unfirm_cs CURSOR FOR
    SELECT cnt02,cnt10 FROM cnt_file WHERE cnt01 = g_cns.cns00
   FOREACH unfirm_cs INTO l_cnt02,l_cnt10
      IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
    #FUN-910088--add--start--
      SELECT coe06 INTO l_coe06 FROM coe_file
       WHERE coe01 = s_coc01 AND coe02 = l_cnt02
      LET l_cnt10 = s_digqty(l_cnt10,l_coe06)
    #FUN-910088--add--end--
      UPDATE coe_file SET coe051 = (coe051-l_cnt10)   
       WHERE coe01 = s_coc01 AND coe02 = l_cnt02
      IF STATUS THEN 
#        CALL cl_err('upd coe:',STATUS,0) #No.TQC-660045
         CALL cl_err3("upd","coe_file",s_coc01,l_cnt02,STATUS,"","upd coe:",1) #No.TQC-660045
 
         LET g_success='N'
         EXIT FOREACH
      END IF
   END FOREACH
   #更新核銷日期
   UPDATE coc_file SET coc07 = null
    WHERE coc01 = t_coc01
   IF STATUS THEN
#      CALL cl_err('upd coc:',STATUS,0) #No.TQC-660045
       CALL cl_err3("upd","coc_file",t_coc01,"",STATUS,"","upd coc",1)       #NO.TQC-660045
      LET g_success='N'
   END IF
   UPDATE cns_file SET cnsconf='N'
    WHERE cns00 = g_cns.cns00
   IF STATUS THEN
#      CALL cl_err('upd cofconf',STATUS,0) #No.TQC-660045
       CALL cl_err3("upd","cns_file",g_cns.cns00,"",STATUS,"","upd cofconf",1)       #NO.TQC-660045
      LET g_success='N'
   END IF
 
   LET l_i = 0
   SELECT COUNT(*) INTO l_i FROM cng_file
     WHERE cng03 = g_cns.cns01           #No.MOD-490398
   IF l_i > 0 THEN
      UPDATE cng_file SET cng07 = null
        WHERE cng03 = g_cns.cns01        #No.MOD-490398
      IF SQLCA.sqlcode THEN
#         CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0) #No.TQC-660045
          CALL cl_err3("upd","cng_file",g_cns.cns01,"",SQLCA.SQLCODE,"","",1)       #NO.TQC-660045
         LET g_success = 'N'
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT cnsconf INTO g_cns.cnsconf FROM cns_file
    WHERE cns00 = g_cns.cns00
   DISPLAY BY NAME g_cns.cnsconf
   #CALL cl_set_field_pic(g_cns.cnsconf,"","","","",g_cns.cnsacti)  #CHI-C80041
   IF g_cns.cnsconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
   CALL cl_set_field_pic(g_cns.cnsconf,"","","",g_void,g_cns.cnsacti)   #CHI-C80041
END FUNCTION
#Patch....NO.TQC-610035 <001> #
#CHI-C80041---begin
FUNCTION t700_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_cns.cns00) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t700_cl USING g_cns.cns00
   IF STATUS THEN
      CALL cl_err("OPEN t700_cl:", STATUS, 1)
      CLOSE t700_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t700_cl INTO g_cns.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cns.cns00,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t700_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_cns.cnsconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_cns.cnsconf)   THEN 
        LET l_chr=g_cns.cnsconf
        IF g_cns.cnsconf='N' THEN 
            LET g_cns.cnsconf='X' 
        ELSE
            LET g_cns.cnsconf='N'
        END IF
        UPDATE cns_file
            SET cnsconf=g_cns.cnsconf,  
                cnsmodu=g_user,
                cnsdate=g_today
            WHERE cns00=g_cns.cns00
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","cns_file",g_cns.cns00,"",SQLCA.sqlcode,"","",1)  
            LET g_cns.cnsconf=l_chr 
        END IF
        DISPLAY BY NAME g_cns.cnsconf 
   END IF
 
   CLOSE t700_cl
   COMMIT WORK
   CALL cl_flow_notify(g_cns.cns00,'V')
 
END FUNCTION
#CHI-C80041---end
