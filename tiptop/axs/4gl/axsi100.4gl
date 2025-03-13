# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axsi100.4gl
# Descriptions...: 銷售目標維護作業
# Date & Author..: 95/03/08 By Danny
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No.MOD-4A0252 04/10/19 By Smapmin 增加目標單號開窗功能
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0069 04/11/25 By Mandy 匯率加開窗功能
# Modify.........: No.FUN-4C0046 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-550072 05/05/23 By Will 單據編號放大
# Modify.........: No.FUN-580013 05/08/15 By vivien 報表轉XML格式
# MOdify.........: NO.MOD-5A0063 05/10/05 By Rosayu 輸入不存在幣別可以過
# Modify.........: NO.MOD-5A0062 05/10/05 By Rosayu 輸入幣別貸出匯率
# Modify.........: NO.MOD-5A0061 05/10/05 By Rosayu 業務員與部門順序掉換,輸入業務員帶出部門
# Modify.........: NO.MOD-5A0071 05/10/06 By Rosayu 第一次新增時目標單據開窗有資料,到單身放棄後再新增目標單據開窗變空白
# Modify.........: No.TQC-5A0089 05/10/27 By Smapmin 單別寫死
# Modify.........: No.TQC-630069 06/03/07 By Smapmin 流程訊息通知功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.TQC-660071 06/06/14 By Smapmin 補充TQC-630069
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/30 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-6A0150 06/10/26 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0095 06/10/27 By xumin l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6C0115 06/12/20 By day 產品分類輸入任何值沒有控管
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740269 07/04/25 By bnlent  在單身已經制定完原幣目標及本幣目標,再修改幣種及匯率時,單身本幣目標沒有隨之更改
# Modify.........: No.TQC-740338 07/04/30 By sherry   狀態欄沒有顯示。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出  
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A90081 10/09/21 By Carrier 状态页签各字段CONSTRUCT
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_osa           RECORD LIKE osa_file.*,
    g_osa01_t       LIKE osa_file.osa01,
    g_osa_t         RECORD LIKE osa_file.*,
    g_osa_o         RECORD LIKE osa_file.*,
    g_osb           DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
        osb02       LIKE osb_file.osb02,
        osb03       LIKE osb_file.osb03,
        osb04       LIKE osb_file.osb04,
        osb05       LIKE osb_file.osb05
                    END RECORD,
    g_osb_t         RECORD                       #程式變數 (舊值)
        osb02       LIKE osb_file.osb02,
        osb03       LIKE osb_file.osb03,
        osb04       LIKE osb_file.osb04,
        osb05       LIKE osb_file.osb05
                    END RECORD,
   #g_wc,g_wc2,g_sql    LIKE type_file.chr1000,  #No.FUN-680130  VARCHAR(1000)
    g_wc,g_wc2,g_sql    STRING,                  #TQC-630166
    g_t1            LIKE oay_file.oayslip,       #No.FUN-680130  VARCHAR(05)
    g_buf           LIKE type_file.chr1000,      #No.FUN-680130  VARCHAR(20)
    g_rec_b         LIKE type_file.num5,         #單身筆數        #No.FUN-680130  SMALLINT
    l_ac            LIKE type_file.num5,         #目前處理的ARRAY CNT        #No.FUN-680130  SMALLINT
    l_cmd           LIKE type_file.chr1000       #No.FUN-680130  VARCHAR(200) 
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680130  SMALLINT
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680130  SMALLINT
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680130  INTEGER
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680130  INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680130  INTEGER
DEFINE mi_no_ask    LIKE type_file.num5          #No.FUN-680130  SMALLINT
#主程式開始
DEFINE g_forupd_sql STRING                       #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680130  INTEGER
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680130  VARCHAR(72)
DEFINE g_i          LIKE type_file.num5          #count/index for any purpose    #No.FUN-680130  SMALLINT
DEFINE g_argv1      LIKE osa_file.osa01          #No.FUN-680130  VARCHAR(16)
DEFINE g_argv2      STRING                       #TQC-630069
 
MAIN
  #  l_time        LIKE type_file.chr8      #計算被使用時間        #No.FUN-680130 VARCHAR(8) 
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXS")) THEN
      EXIT PROGRAM
   END IF
   
   LET g_argv1 = ARG_VAL(1)   #TQC-630069
   LET g_argv2 = ARG_VAL(2)   #TQC-630069
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #No.FUN-6A0095
        RETURNING g_time    #No.FUN-6A0095
 
    LET g_forupd_sql =
        "SELECT * FROM osa_file WHERE osa01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 4
 
    OPEN WINDOW i100_w AT p_row,p_col             #顯示畫面
         WITH FORM "axs/42f/axsi100"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #-----TQC-630069---------
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL i100_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL i100_a()
             END IF
          OTHERWISE   #TQC-660071
             CALL i100_q()   #TQC-660071
       END CASE
    END IF
    #-----END TQC-630069----- 
 
    CALL i100_menu()
 
    CLOSE WINDOW i100_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818   #No.FUN-6A0095
        RETURNING g_time      #No.FUN-6A0095
END MAIN
 
#QBE 查詢資料
FUNCTION i100_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                                    #清除畫面
    CALL g_osb.clear()
 
    IF cl_null(g_argv1) THEN   #TQC-630069 
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_osa.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON osa01,osa02,osa05,  # 螢幕上取單頭條件
                              osa15,osa14,osa25,osa26,osa03,osa06,
                              osa04,osa23,osa24,osa90,
                              osauser,osagrup,osaoriu,osaorig,osamodu,osadate       #No.TQC-740338  #No.TQC-A90081
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
           CASE
                 WHEN INFIELD(osa01)  #MOD-4A0252
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_osa1"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO osa01
                      NEXT FIELD osa01
                WHEN INFIELD(osa15)
#                     CALL q_gem(05,03,g_osa.osa15) RETURNING g_osa.osa15
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gem"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO osa15
                      NEXT FIELD osa15
                WHEN INFIELD(osa14)
#                     CALL q_gen(05,03,g_osa.osa14) RETURNING g_osa.osa14
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gen"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO osa14
                      NEXT FIELD osa14
                WHEN INFIELD(osa25)
#                     CALL q_oab(05,03,g_osa.osa25) RETURNING g_osa.osa25
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_oab"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO osa25
                      NEXT FIELD osa25
                WHEN INFIELD(osa26)
#                     CALL q_oab(05,03,g_osa.osa26) RETURNING g_osa.osa26
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_oab"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO osa26
                      NEXT FIELD osa26
                WHEN INFIELD(osa03)
#                     CALL q_occ(05,03,g_osa.osa03) RETURNING g_osa.osa03
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_occ"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO osa03
                      NEXT FIELD osa03
                WHEN INFIELD(osa04)
#                     CALL q_occ(05,03,g_osa.osa04) RETURNING g_osa.osa04
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_occ"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO osa04
                      NEXT FIELD osa04
                WHEN INFIELD(osa06)
#                     CALL q_oca(05,03,g_osa.osa06) RETURNING g_osa.osa06
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_oca"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO osa06
                      NEXT FIELD osa06
                WHEN INFIELD(osa23)
#                     CALL q_azi(05,03,g_osa.osa23) RETURNING g_osa.osa23
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_azi"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO osa23
                      NEXT FIELD osa23
                WHEN INFIELD(osa90)
#                     CALL q_oba(05,03,g_osa.osa90) RETURNING g_osa.osa90
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_oba"
                      LET g_qryparam.state = 'c'
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO osa90
                      NEXT FIELD osa90
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('osauser', 'osagrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON osb02,osb03,osb04,osb05
                  FROM s_osb[1].osb02,s_osb[1].osb03,
                       s_osb[1].osb04,s_osb[1].osb05
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    #-----TQC-630069---------
    ELSE   
    LET g_wc = "osa01 = '",g_argv1,"'"
    LET g_wc2 = " 1=1" 
    END IF 
    #-----END TQC-630069-----
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT osa01 FROM osa_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE osa01 ",
                   "  FROM osa_file, osb_file",
                   " WHERE osa01 = osb01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
    PREPARE i100_prepare FROM g_sql
    DECLARE i100_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i100_prepare
    IF g_wc2 = " 1=1" THEN                       # 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM osa_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql="SELECT COUNT(DISTINCT osa01) FROM osa_file,osb_file WHERE ",
                 "osa01=osb01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i100_precount FROM g_sql
   DECLARE i100_count CURSOR FOR i100_precount
 
 
END FUNCTION
 
 
FUNCTION i100_menu()
 
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i100_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i100_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i100_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i100_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i100_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_osb),'','')
            END IF
         #No.FUN-6A0150-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_osa.osa01 IS NOT NULL THEN
                 LET g_doc.column1 = "osa01"
                 LET g_doc.value1 = g_osa.osa01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0150-------add--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i100_a()
DEFINE li_result LIKE type_file.num5    #No.FUN-680130  SMALLINT
 
#   IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_osb.clear()
    INITIALIZE g_osa.* LIKE osa_file.*
    LET g_osa_o.* = g_osa.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_osa.osa02 = g_today
        LET g_osa.osauser=g_user
        LET g_osa.osaoriu = g_user #FUN-980030
        LET g_osa.osaorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_osa.osagrup=g_grup
        LET g_osa.osadate=g_today
        LET g_osa.osaplant = g_plant #FUN-980011 add
        LET g_osa.osalegal = g_legal #FUN-980011 add
        #-----TQC-630069---------
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_osa.osa01 = g_argv1
        END IF
        #-----END TQC-630069-----
        CALL i100_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_osa.osa01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK  #No:7829
        #No.FUN-550072  --start
        CALL s_auto_assign_no("axs",g_osa.osa01,g_osa.osa02,"","osa_file","osa01","","","")
          RETURNING li_result,g_osa.osa01
        IF (NOT li_result) THEN
          CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_osa.osa01
        #NO.Fun-550072 --end
#        IF g_osy.osyauno='Y' THEN
#           CALL s_axsauno(g_osa.osa01,g_osa.osa02)
#                RETURNING g_i,g_osa.osa01
#           IF g_i THEN #有問題
#              ROLLBACK WORK   #No:7829
#              CONTINUE WHILE
#           END IF
#           DISPLAY BY NAME g_osa.osa01
#        END IF
        INSERT INTO osa_file VALUES (g_osa.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#           CALL cl_err(g_osa.osa01,SQLCA.sqlcode,1)   #No.FUN-660155
            CALL cl_err3("ins","osa_file",g_osa.osa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660155
            ROLLBACK WORK   #No:7829
            CONTINUE WHILE
        ELSE
            COMMIT WORK     #No:7829
            SELECT osa01 INTO g_osa.osa01 FROM osa_file
                WHERE osa01 = g_osa.osa01
 
            CALL cl_flow_notify(g_osa.osa01,'I')
 
        END IF
        LET g_osa_t.* = g_osa.*
        CALL g_osb.clear()
        LET g_rec_b = 0
        CALL i100_b()                   #輸入單身
        SELECT osa01 INTO g_osa.osa01 FROM osa_file
            WHERE osa01 = g_osa.osa01
        LET g_osa01_t = g_osa.osa01        #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i100_u()
#   IF s_shut(0) THEN RETURN END IF
    IF g_osa.osa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_osa01_t = g_osa.osa01
    LET g_osa_o.* = g_osa.*
    BEGIN WORK
 
    OPEN i100_cl USING g_osa.osa01
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_osa.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_osa.osa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i100_cl
        RETURN
    END IF
    CALL i100_show()
    WHILE TRUE
        LET g_osa01_t = g_osa.osa01
        LET g_osa.osamodu=g_user
        LET g_osa.osadate=g_today
        CALL i100_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_osa.*=g_osa_t.*
            CALL i100_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE osa_file SET osa_file.* = g_osa.*
            WHERE osa01 = g_osa.osa01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_osa.osa01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","osa_file",g_osa01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660155
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE i100_cl
    COMMIT WORK
    CALL cl_flow_notify(g_osa.osa01,'U')
 
END FUNCTION
 
#處理INPUT
FUNCTION i100_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,         #判斷必要欄位是否有輸入    #No.FUN-680130  VARCHAR(1)
    l_n1            LIKE type_file.num5,         #No.FUN-680130  SMALLINT
    li_result       LIKE type_file.num5,         #No.FUN-680130  SMALLINT
    p_cmd           LIKE type_file.chr1          #a:輸入 u:更改     #No.FUN-680130 VARCHAR(01) 
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_osa.osaoriu,g_osa.osaorig,g_osa.osa01,g_osa.osa02,g_osa.osa05,g_osa.osa14, #MOD-5A0061 osa14 and osa15前後調換
                  g_osa.osa15,g_osa.osa25,g_osa.osa26,g_osa.osa03,
                  g_osa.osa06,g_osa.osa04,g_osa.osa23,g_osa.osa24,
                  g_osa.osa90 WITHOUT DEFAULTS
 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i100_set_entry(p_cmd)
            CALL i100_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("osa01")  #NO.Fun-550072
 
        AFTER FIELD osa01
            IF NOT cl_null(g_osa.osa01) THEN
                #No.FUN-550072  --start
                LET g_t1=s_get_doc_no(g_osa.osa01)
                LET g_buf=NULL
                SELECT osytype INTO g_buf FROM osy_file WHERE osyslip=g_t1
                CALL s_check_no("axs",g_osa.osa01,g_osa01_t,g_buf,"osa_file","osa01","")
                  RETURNING li_result,g_osa.osa01
                DISPLAY BY NAME g_osa.osa01
                IF (NOT li_result) THEN
         	    NEXT FIELD osa01
                END IF
#                LET g_t1=g_osa.osa01[1,3]
#                LET g_buf=NULL
#                SELECT osytype INTO g_buf FROM osy_file WHERE osyslip=g_t1
#	            CALL s_axsslip(g_t1,g_buf,g_sys)
#	            IF NOT cl_null(g_errno) THEN	 		#抱歉, 有問題
#	                CALL cl_err(g_t1,g_errno,0) NEXT FIELD osa01
#	            END IF
#                IF p_cmd = 'a' AND cl_null(g_osa.osa01[5,10]) AND g_osy.osyauno = 'N'
#	                   THEN NEXT FIELD osa01
#                END IF
#                IF g_osa.osa01 != g_osa_t.osa01 OR g_osa_t.osa01 IS NULL THEN
#                    IF g_osy.osyauno = 'Y' AND NOT cl_chk_data_continue(g_osa.osa01[5,10]) THEN
#                       CALL cl_err('','9056',0) NEXT FIELD osa01
#                    END IF
#                    SELECT count(*) INTO g_cnt FROM osa_file
#                        WHERE osa01 = g_osa.osa01
#                    IF g_cnt > 0 THEN   #資料重複
#                        CALL cl_err(g_osa.osa01,-239,0)
#                        LET g_osa.osa01 = g_osa_t.osa01
#                        DISPLAY BY NAME g_osa.osa01
#                        NEXT FIELD osa01
#                    END IF
#                END IF
 
            #No.FUN-550072  --end
            END IF
 
        AFTER FIELD osa05
           IF NOT cl_null(g_osa.osa05) THEN
               IF g_osa.osa05 NOT MATCHES '[12]' THEN
                   NEXT FIELD osa05
               END IF
           END IF
 
        AFTER FIELD osa15
           IF NOT cl_null(g_osa.osa15) THEN
              LET g_buf=NULL
              SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_osa.osa15
                AND gemacti='Y'   #NO:6950
              IF STATUS THEN
#                CALL cl_err('select gem',STATUS,0)    #No.FUN-660155
                 CALL cl_err3("sel","gem_file",g_osa.osa15,"",STATUS,"","select gem",1)  #No.FUN-660155
                 NEXT FIELD osa15
              END IF
              DISPLAY g_buf TO FORMONLY.gem02
           END IF
 
        AFTER FIELD osa14
           IF NOT cl_null(g_osa.osa14) THEN
              LET g_buf=NULL
              SELECT gen02 INTO g_buf FROM gen_file WHERE gen01=g_osa.osa14
              IF STATUS THEN
#                CALL cl_err('select gen',STATUS,0)   #No.FUN-660155
                 CALL cl_err3("sel","gen_file",g_osa.osa14,"",STATUS,"","select gen",1)  #No.FUN-660155
                 NEXT FIELD osa14 
              END IF
              DISPLAY g_buf TO FORMONLY.gen02
              #MOD-5A0061 add
              IF g_osa.osa14 != g_osa_t.osa14 OR cl_null(g_osa_t.osa14) THEN
                   SELECT gen03 INTO g_osa.osa15 FROM gen_file
                    WHERE gen01=g_osa.osa14
                   DISPLAY BY NAME g_osa.osa15
              END IF
              #MOD-5A0061 end
           END IF
 
        AFTER FIELD osa25
           IF NOT cl_null(g_osa.osa25) THEN
              LET g_buf=NULL
              SELECT oab02 INTO g_buf FROM oab_file WHERE oab01=g_osa.osa25
              IF STATUS THEN
#                CALL cl_err('select oab',STATUS,0)    #No.FUN-660155
                 CALL cl_err3("sel","oab_file",g_osa.osa25,"",STATUS,"","select oab",1)  #No.FUN-660155
                 NEXT FIELD osa25
              END IF
              DISPLAY g_buf TO FORMONLY.oab021
           END IF
 
        AFTER FIELD osa26
           IF NOT cl_null(g_osa.osa26) THEN
              LET g_buf=NULL
              SELECT oab02 INTO g_buf FROM oab_file WHERE oab01=g_osa.osa26
              IF STATUS THEN
#                CALL cl_err('select oab',STATUS,0)    #No.FUN-660155
                 CALL cl_err3("sel","oab_file",g_osa.osa26,"",STATUS,"","select oab",1)  #No.FUN-660155
                 NEXT FIELD osa26
              END IF
              DISPLAY g_buf TO FORMONLY.oab022
           END IF
 
        AFTER FIELD osa03
           IF NOT cl_null(g_osa.osa03) THEN
              LET g_buf=NULL
              SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_osa.osa03
              IF STATUS THEN
#                CALL cl_err('select occ',STATUS,0)   #No.FUN-660155
                 CALL cl_err3("sel","occ_file",g_osa.osa03,"",STATUS,"","select occ",1)  #No.FUN-660155
                 NEXT FIELD osa03 
              END IF
              DISPLAY g_buf TO FORMONLY.occ021
           END IF
 
        AFTER FIELD osa06
           IF NOT cl_null(g_osa.osa06) THEN
              LET g_buf=NULL
              SELECT oca02 INTO g_buf FROM oca_file WHERE oca01=g_osa.osa06
              IF STATUS THEN
#                CALL cl_err('select oca',STATUS,0)    #No.FUN-660155
                 CALL cl_err3("sel","oca_file",g_osa.osa06,"",STATUS,"","select oca",1)  #No.FUN-660155
                 NEXT FIELD osa06
              END IF
              DISPLAY g_buf TO FORMONLY.oca02
           END IF
 
        AFTER FIELD osa04
           IF NOT cl_null(g_osa.osa04) THEN
              LET g_buf=NULL
              SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_osa.osa04
              IF STATUS THEN
#                CALL cl_err('select occ',STATUS,0)    #No.FUN-660155
                 CALL cl_err3("sel","occ_file",g_osa.osa04,"",STATUS,"","select occ",1)  #No.FUN-660155
                 NEXT FIELD osa04
              END IF
              DISPLAY g_buf TO FORMONLY.occ022
           END IF
 
        AFTER FIELD osa23
           IF NOT cl_null(g_osa.osa23) THEN
              SELECT COUNT(*) INTO g_cnt FROM azi_file WHERE azi01=g_osa.osa23
              IF STATUS THEN
#                CALL cl_err('select azi',STATUS,0)   #No.FUN-660155
                 CALL cl_err3("sel","azi_file",g_osa.osa23,"",STATUS,"","select azi",1)  #No.FUN-660155
                 NEXT FIELD osa23
              END IF
              #MOD-5A0063 add
             IF g_cnt = 0 THEN
                CALL cl_err('','axs-001',0)
                NEXT FIELD osa23
             END IF
             #MOD-5A0063 end
             #MOD-5A0062 add
             SELECT azi01
                  FROM azi_file WHERE azi01=g_osa.osa23
             IF STATUS THEN
#                CALL cl_err('select azi',STATUS,0)   #No.FUN-660155
                 CALL cl_err3("sel","azi_file",g_osa.osa23,"",STATUS,"","select azi",1)  #No.FUN-660155
                 NEXT FIELD osa23 
             END IF
             IF g_aza.aza17 = g_osa.osa23 THEN #本幣
                  LET g_osa.osa24 = 1
             ELSE
                 CALL s_curr3(g_osa.osa23,g_osa.osa02,'B')
                      RETURNING g_osa.osa24
             END IF
             DISPLAY BY NAME g_osa.osa24
             #MOD-5A0062 end
           END IF
           IF p_cmd = 'u' THEN CALL i100_osb05() END IF    #No.TQC-740269
 
        BEFORE FIELD osa24
           #MOD-5A0061 mark
           #IF p_cmd='a' THEN
           #   LET g_osa.osa24=1
           #   DISPLAY BY NAME g_osa.osa24
           #END IF
           #MOD-5A0061 end
        AFTER FIELD osa90
           IF NOT cl_null(g_osa.osa90) THEN
              SELECT COUNT(*) INTO g_cnt FROM oba_file WHERE oba01=g_osa.osa90
              #No.TQC-6C0115--begin
#             IF STATUS THEN   
#                CALL cl_err('select oba',STATUS,0)   #No.FUN-660155
#                CALL cl_err3("sel","oba_file",g_osa.osa90,"",STATUS,"","select oba",1)  #No.FUN-660155
              IF g_cnt = 0  THEN  
                 CALL cl_err(g_osa.osa90,100,0)
              #No.TQC-6C0115--end  
                 NEXT FIELD osa90
              END IF
           END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(osa01) #目標單號
#                      LET g_t1=g_osa.osa01[1,3]   #TQC-5A0089
                      LET g_t1=s_get_doc_no(g_osa.osa01)   #TQC-5A0089
                      #LET g_t1=NULL
                      LET g_t1=s_get_doc_no(g_osa.osa01)     #No.FUN-550072
                      LET g_buf=g_t1 #MOD-5A0071 add
#                     CALL q_osy(0,0,g_t1,g_buf) RETURNING g_t1
                      CALL q_osy(FALSE, FALSE,g_t1,g_buf) RETURNING g_t1
#                      CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                      LET g_osa.osa01[1,3]=g_t1
                      LET g_osa.osa01=g_t1                   #No.FUN-550072
                      DISPLAY BY NAME g_osa.osa01
                      NEXT FIELD osa01
                WHEN INFIELD(osa15)
#                     CALL q_gem(05,03,g_osa.osa15) RETURNING g_osa.osa15
#                     CALL FGL_DIALOG_SETBUFFER( g_osa.osa15 )
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gem"
                      LET g_qryparam.default1 = g_osa.osa15
                      CALL cl_create_qry() RETURNING g_osa.osa15
#                      CALL FGL_DIALOG_SETBUFFER( g_osa.osa15 )
                      DISPLAY BY NAME g_osa.osa15
                      NEXT FIELD osa15
                WHEN INFIELD(osa14)
#                     CALL q_gen(05,03,g_osa.osa14) RETURNING g_osa.osa14
#                     CALL FGL_DIALOG_SETBUFFER( g_osa.osa14 )
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gen"
                      LET g_qryparam.default1 = g_osa.osa14
                      CALL cl_create_qry() RETURNING g_osa.osa14
#                      CALL FGL_DIALOG_SETBUFFER( g_osa.osa14 )
                      DISPLAY BY NAME g_osa.osa14
                      NEXT FIELD osa14
                WHEN INFIELD(osa25)
#                     CALL q_oab(05,03,g_osa.osa25) RETURNING g_osa.osa25
#                     CALL FGL_DIALOG_SETBUFFER( g_osa.osa25 )
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_oab"
                      LET g_qryparam.default1 = g_osa.osa25
                      CALL cl_create_qry() RETURNING g_osa.osa25
#                      CALL FGL_DIALOG_SETBUFFER( g_osa.osa25 )
                      DISPLAY BY NAME g_osa.osa25
                      NEXT FIELD osa25
                WHEN INFIELD(osa26)
#                     CALL q_oab(05,03,g_osa.osa26) RETURNING g_osa.osa26
#                     CALL FGL_DIALOG_SETBUFFER( g_osa.osa26 )
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_oab"
                      LET g_qryparam.default1 = g_osa.osa26
                      CALL cl_create_qry() RETURNING g_osa.osa26
#                      CALL FGL_DIALOG_SETBUFFER( g_osa.osa26 )
                      DISPLAY BY NAME g_osa.osa26
                      NEXT FIELD osa26
                WHEN INFIELD(osa03)
#                     CALL q_occ(05,03,g_osa.osa03) RETURNING g_osa.osa03
#                     CALL FGL_DIALOG_SETBUFFER( g_osa.osa03 )
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_occ"
                      LET g_qryparam.default1 = g_osa.osa03
                      CALL cl_create_qry() RETURNING g_osa.osa03
#                      CALL FGL_DIALOG_SETBUFFER( g_osa.osa03 )
                      DISPLAY BY NAME g_osa.osa03
                      NEXT FIELD osa03
                WHEN INFIELD(osa04)
#                     CALL q_occ(05,03,g_osa.osa04) RETURNING g_osa.osa04
#                     CALL FGL_DIALOG_SETBUFFER( g_osa.osa04 )
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_occ"
                      LET g_qryparam.default1 = g_osa.osa04
                      CALL cl_create_qry() RETURNING g_osa.osa04
#                      CALL FGL_DIALOG_SETBUFFER( g_osa.osa04 )
                      DISPLAY BY NAME g_osa.osa04
                      NEXT FIELD osa04
                WHEN INFIELD(osa06)
#                     CALL q_oca(05,03,g_osa.osa06) RETURNING g_osa.osa06
#                     CALL FGL_DIALOG_SETBUFFER( g_osa.osa06 )
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_oca"
                      LET g_qryparam.default1 = g_osa.osa06
                      CALL cl_create_qry() RETURNING g_osa.osa06
#                      CALL FGL_DIALOG_SETBUFFER( g_osa.osa06 )
                      DISPLAY BY NAME g_osa.osa06
                      NEXT FIELD osa06
                WHEN INFIELD(osa23)
#                     CALL q_azi(05,03,g_osa.osa23) RETURNING g_osa.osa23
#                     CALL FGL_DIALOG_SETBUFFER( g_osa.osa23 )
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_azi"
                      LET g_qryparam.default1 = g_osa.osa23
                      CALL cl_create_qry() RETURNING g_osa.osa23
#                      CALL FGL_DIALOG_SETBUFFER( g_osa.osa23 )
                      DISPLAY BY NAME g_osa.osa23
                      NEXT FIELD osa23
                #FUN-4B0069
                WHEN INFIELD(osa24) #匯率開窗
                   CALL s_rate(g_osa.osa23,g_osa.osa24) RETURNING g_osa.osa24
                   DISPLAY BY NAME g_osa.osa24
                   NEXT FIELD osa24
                #FUN-4B0069(end)
                WHEN INFIELD(osa90)
#                     CALL q_oba(05,03,g_osa.osa90) RETURNING g_osa.osa90
#                     CALL FGL_DIALOG_SETBUFFER( g_osa.osa90 )
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_oba"
                      LET g_qryparam.default1 = g_osa.osa90
                      CALL cl_create_qry() RETURNING g_osa.osa90
#                      CALL FGL_DIALOG_SETBUFFER( g_osa.osa90 )
                      DISPLAY BY NAME g_osa.osa90
                      NEXT FIELD osa90
           END CASE
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(osa01) THEN
      #          LET g_osa.* = g_osa_t.*
      #          DISPLAY BY NAME g_osa.*
      #          NEXT FIELD osa01
      #      END IF
      #MOD-650015 --end
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i100_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_osa.* TO NULL              #No.FUN-6A0150 
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL i100_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_osa.* TO NULL
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_osa.* TO NULL
    ELSE
        OPEN i100_count
        FETCH i100_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i100_fetch(p_flag)
DEFINE
    p_flag   LIKE type_file.chr1,  #處理方式     #No.FUN-680130  VARCHAR(1)
    l_abso   LIKE type_file.num10  #絕對的筆數   #No.FUN-680130  INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i100_cs INTO g_osa.osa01
        WHEN 'P' FETCH PREVIOUS i100_cs INTO g_osa.osa01
        WHEN 'F' FETCH FIRST    i100_cs INTO g_osa.osa01
        WHEN 'L' FETCH LAST     i100_cs INTO g_osa.osa01
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
            END IF
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
            FETCH ABSOLUTE g_jump i100_cs INTO g_osa.osa01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_osa.osa01,SQLCA.sqlcode,0)
        INITIALIZE g_osa.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_osa.* FROM osa_file WHERE osa01 = g_osa.osa01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_osa.osa01,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("sel","osa_file",g_osa.osa01,"",SQLCA.SQLCODE,"","",1)  #No.FUN-660155
        INITIALIZE g_osa.* TO NULL
        RETURN
    ELSE                                    #FUN-4C0046權限控管
       LET g_data_owner=g_osa.osauser
       LET g_data_group=g_osa.osagrup
       LET g_data_plant = g_osa.osaplant #FUN-980030
 
    END IF
    CALL i100_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i100_show()
    LET g_osa_t.* = g_osa.*                #保存單頭舊值
    LET g_buf=NULL
    SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_osa.osa15
    DISPLAY g_buf TO FORMONLY.gem02
    LET g_buf=NULL
    SELECT gen02 INTO g_buf FROM gen_file WHERE gen01=g_osa.osa14
    DISPLAY g_buf TO FORMONLY.gen02
    LET g_buf=NULL
    SELECT oab02 INTO g_buf FROM oab_file WHERE oab01=g_osa.osa25
    DISPLAY g_buf TO FORMONLY.oab021
    LET g_buf=NULL
    SELECT oab02 INTO g_buf FROM oab_file WHERE oab01=g_osa.osa26
    DISPLAY g_buf TO FORMONLY.oab022
    LET g_buf=NULL
    SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_osa.osa03
    DISPLAY g_buf TO FORMONLY.occ021
    LET g_buf=NULL
    SELECT occ02 INTO g_buf FROM occ_file WHERE occ01=g_osa.osa04
    DISPLAY g_buf TO FORMONLY.occ022
    LET g_buf=NULL
    SELECT oca02 INTO g_buf FROM oca_file WHERE oca01=g_osa.osa06
    DISPLAY g_buf TO FORMONLY.oca02
    DISPLAY BY NAME g_osa.osa01,g_osa.osa02,g_osa.osa05,g_osa.osa15, g_osa.osaoriu,g_osa.osaorig,
                    g_osa.osa14,g_osa.osa25,g_osa.osa26,g_osa.osa03,
                    g_osa.osa06,g_osa.osa04,g_osa.osa23,g_osa.osa24,
                    g_osa.osa90,
                    g_osa.osauser,g_osa.osagrup,g_osa.osamodu,g_osa.osadate     #No.TQC-740338       
    CALL i100_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i100_r()
    DEFINE l_chr,l_sure      LIKE type_file.chr1        #No.FUN-680130  VARCHAR(1)
 
#   IF s_shut(0) THEN RETURN END IF
    IF g_osa.osa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i100_cl USING g_osa.osa01
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_osa.*
    IF SQLCA.sqlcode THEN
      CALL cl_err(g_osa.osa01,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i100_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "osa01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_osa.osa01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM osa_file WHERE osa01 = g_osa.osa01
        DELETE FROM osb_file WHERE osb01 = g_osa.osa01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_osa.osa01,SQLCA.sqlcode,0)   #No.FUN-660155
           CALL cl_err3("del","osb_file",g_osa.osa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660155
        ELSE
           CLEAR FORM
           CALL g_osb.clear()
    	   INITIALIZE g_osa.* LIKE osa_file.*             #DEFAULT 設定
           OPEN i100_count
           #FUN-B50064-add-start--
           IF STATUS THEN
              CLOSE i100_cs
              CLOSE i100_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end--
           FETCH i100_count INTO g_row_count
           #FUN-B50064-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i100_cs
              CLOSE i100_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end-- 
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i100_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i100_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i100_fetch('/')
           END IF
        END IF
    END IF
 
    CLOSE i100_cl
    COMMIT WORK
    CALL cl_flow_notify(g_osa.osa01,'D')
 
END FUNCTION
 
#單身
FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,        #未取消的ARRAY CNT #No.FUN-680130  SMALLINT
    l_row,l_col     LIKE type_file.num5,        #分段輸入之行,列數 #No.FUN-680130  SMALLINT
    l_n,l_cnt,l_i   LIKE type_file.num5,        #檢查重複用        #No.FUN-680130  SMALLINT
    l_lock_sw       LIKE type_file.chr1,        #單身鎖住否        #No.FUN-680130  VARCHAR(1)
    p_cmd           LIKE type_file.chr1,        #處理狀態          #No.FUN-680130  VARCHAR(1)
    g_cmd           LIKE type_file.chr1000,     #No.FUN-680130  VARCHAR(100)
    l_day           LIKE type_file.num10,       #No.FUN-680130  INTEGER
    l_flag          LIKE type_file.num10,       #No.FUN-680130  INTEGER
    l_sme01         LIKE type_file.dat,         #No.FUN-680130  DATE
    l_allow_insert  LIKE type_file.num5,        #可新增否 #No.FUN-680130  SMALLINT
    l_allow_delete  LIKE type_file.num5         #可刪除否 #No.FUN-680130  SMALLINT
 
    LET g_action_choice = ""
    IF g_osa.osa01 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT osb02,osb03,osb04,osb05 ",
      "   FROM osb_file  ",
      "  WHERE osb01= ? ",
      "    AND osb02= ? ",
      "    AND osb03= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
	LET l_row = 12
	LET l_col = 15
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_osb WITHOUT DEFAULTS FROM s_osb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_osb_t.* = g_osb[l_ac].*  #BACKUP
	        BEGIN WORK
 
                OPEN i100_bcl USING g_osa.osa01,g_osb_t.osb02,g_osb_t.osb03
                IF STATUS THEN
                    CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i100_bcl INTO g_osb[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_osb_t.osb02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO osb_file(osb01,osb02,osb03,osb04,osb05,
                        osbplant,osblegal) #FUN-980011 add
            VALUES(g_osa.osa01,g_osb[l_ac].osb02,g_osb[l_ac].osb03,
                   g_osb[l_ac].osb04,g_osb[l_ac].osb05,
                   g_plant,g_legal)        #FUN-980011 add
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_osb[l_ac].osb02,SQLCA.sqlcode,0)   #No.FUN-660155
                CALL cl_err3("ins","osb_file",g_osa.osa01,g_osb[l_ac].osb02,SQLCA.sqlcode,"","",1)  #No.FUN-660155
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b = g_rec_b + 1
                DISPLAY g_rec_b TO FORMONLY.cn2
	        COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_osb[l_ac].* TO NULL      #900423
            LET g_osb_t.* = g_osb[l_ac].*             #新輸入資料
            IF l_ac > 1 THEN
                LET g_osb[l_ac].osb02=g_osb[l_ac-1].osb02
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD osb02
 
       BEFORE FIELD osb03
            IF cl_null(g_osb[l_ac].osb02) THEN
                NEXT FIELD osb02
            END IF
 
        AFTER FIELD osb03                        #check 序號是否重複
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_osb[l_ac].osb03) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_osb[l_ac].osb02
            IF g_azm.azm02 = 1 THEN
               IF g_osb[l_ac].osb03 > 12 OR g_osb[l_ac].osb03 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD osb03
               END IF
            ELSE
               IF g_osb[l_ac].osb03 > 13 OR g_osb[l_ac].osb03 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD osb03
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
           IF NOT cl_null(g_osb[l_ac].osb03) THEN
               IF g_osb[l_ac].osb03 != g_osb_t.osb03 OR
                  g_osb_t.osb03 IS NULL THEN
                   SELECT count(*)
                       INTO l_n
                       FROM osb_file
                       WHERE osb01 = g_osa.osa01
                         AND osb02 = g_osb[l_ac].osb02
                         AND osb03 = g_osb[l_ac].osb03
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_osb[l_ac].osb03 = g_osb_t.osb03
                       NEXT FIELD osb03
                   END IF
               END IF
           END IF
 
        AFTER FIELD osb04
           IF NOT cl_null(g_osb[l_ac].osb04) THEN
               IF NOT cl_null(g_osa.osa24) THEN
                  LET g_osb[l_ac].osb05=g_osa.osa24*g_osb[l_ac].osb04
               END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_osb_t.osb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM osb_file
                    WHERE osb01 = g_osa.osa01
                      AND osb02 = g_osb_t.osb02
                      AND osb03 = g_osb_t.osb03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_osb_t.osb02,SQLCA.sqlcode,0)   #No.FUN-660155
                    CALL cl_err3("del","osb_file",g_osa.osa01,g_osb_t.osb02,SQLCA.sqlcode,"","",1)  #No.FUN-660155
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
	        COMMIT WORK
                LET g_rec_b = g_rec_b - 1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_osb[l_ac].* = g_osb_t.*
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_osb[l_ac].osb02,-263,1)
                LET g_osb[l_ac].* = g_osb_t.*
            ELSE
                UPDATE osb_file SET
                       osb01=g_osa.osa01,
                       osb02=g_osb[l_ac].osb02,
                       osb03=g_osb[l_ac].osb03,
                       osb04=g_osb[l_ac].osb04,
                       osb05=g_osb[l_ac].osb05
                 WHERE osb01=g_osa.osa01
                   AND osb02=g_osb_t.osb02
                   AND osb03=g_osb_t.osb03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_osb[l_ac].osb02,SQLCA.sqlcode,0)   #No.FUN-660155
                    CALL cl_err3("upd","osb_file",g_osa.osa01,g_osb_t.osb02,SQLCA.sqlcode,"","",1)  #No.FUN-660155
                    LET g_osb[l_ac].* = g_osb_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
		    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_osb[l_ac].* = g_osb_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_osb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i100_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL i100_b_askkey()
      #     EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(osb02) AND l_ac > 1 THEN
                LET g_osb[l_ac].* = g_osb[l_ac-1].*
                NEXT FIELD osb02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
           UPDATE osa_file SET osamodu = g_user,osadate = g_today
                WHERE osa01 = g_osa.osa01
 
    CLOSE i100_bcl
    COMMIT WORK
#   CALL i100_delall() #CHI-C30002 mark
    CALL i100_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i100_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM osa_file WHERE osa01 = g_osa.osa01
         INITIALIZE g_osa.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i100_delall()
#   SELECT COUNT(*) INTO g_cnt FROM osb_file
#       WHERE osb01=g_osa.osa01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM osa_file WHERE osa01 = g_osa.osa01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i100_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680130  VARCHAR(500)
 
    CONSTRUCT l_wc2 ON osb02,osb03,osb04,osb05
            FROM s_osb[1].osb02,s_osb[1].osb03,s_osb[1].osb04,s_osb[1].osb05
       ON IDLE g_idle_seconds
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    CALL i100_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000       #No.FUN-680130  VARCHAR(1000)
 
    LET g_sql =
        "SELECT osb02,osb03,osb04,osb05 ",
        " FROM osb_file",
        " WHERE osb01 ='",g_osa.osa01,"'",  #單頭
        " AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY osb02,osb03"
 
    PREPARE i100_pb FROM g_sql
    DECLARE osb_curs                       #SCROLL CURSOR
        CURSOR WITH HOLD FOR i100_pb
 
 
    CALL g_osb.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH osb_curs INTO g_osb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF cl_null(g_osb[g_cnt].osb04) THEN LET g_osb[g_cnt].osb04=0 END IF
        IF cl_null(g_osb[g_cnt].osb05) THEN LET g_osb[g_cnt].osb05=0 END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_osb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680130  VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_osb TO s_osb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
 
   ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0150  相關文件
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
 
#No.FUN-7C0043--start--
FUNCTION i100_out()
 DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680130  SMALLINT
    sr              RECORD
                    osa   RECORD LIKE osa_file.*,
                    gem02 LIKE gem_file.gem02,
                    gen02 LIKE gen_file.gen02,
                    oab02 LIKE oab_file.oab02,
                    occ02 LIKE occ_file.occ02,
                    oca02 LIKE oca_file.oca02,
                    osb02 LIKE osb_file.osb02,
                    osb03 LIKE osb_file.osb03,
                    osb04 LIKE osb_file.osb04,
                    osb05 LIKE osb_file.osb05
                    END RECORD,
    l_name          LIKE type_file.chr20,         #External(Disk) file name    #No.FUN-680130  VARCHAR(20)
    l_za05          LIKE za_file.za05             #No.FUN-680130  VARCHAR(40)
 DEFINE l_cmd       LIKE type_file.chr1000        #No.FUN-7C0043                                                               
                                                                                                                                    
    IF cl_null(g_wc) AND NOT cl_null(g_osa.osa01) THEN                                                                              
       LET g_wc = " osa01 = '",g_osa.osa01,"' "                                                                                     
    END IF                                                                                                                          
    IF cl_null(g_wc)  THEN                                                                                                          
        CALL cl_err('','9057',0)                                                                                                    
        RETURN                                                                                                                      
    END IF                                                                                                                          
    IF cl_null(g_wc2)  THEN                                                                                                         
       LET g_wc2 =" 1=1 "                                                                                                           
       RETURN                                                                                                                       
    END IF 
    LET l_cmd = 'p_query "axsi100" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                          
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN
#   IF g_wc IS NULL THEN
#       CALL cl_err('',-400,0)
#       CALL cl_err('','9057',0)
#       RETURN
#   END IF
#   #改成印當下的那一筆資料內容
#   IF g_wc IS NULL THEN
#      IF cl_null(g_osa.osa01) THEN
#         CALL cl_err('','9057',0) RETURN
#      ELSE
#         LET g_wc=" osa01='",g_osa.osa01,"'"
#      END IF
#   END IF
#   CALL cl_wait()
#   ALL cl_outnam('axsi100') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#   LET g_sql="SELECT osa_file.*,gem02,gen02,oab02,",
#             "       occ02,oca02,osb02,osb03,osb04,osb05 ",
#             "  FROM osa_file,OUTER gem_file,OUTER oca_file,",
#             " OUTER gen_file,OUTER oab_file,OUTER occ_file,",
#             " OUTER osb_file",
#             " WHERE  ",g_wc CLIPPED,
#             " AND gem_file.gem01=osa15  AND gen_file.gen01=osa14 ",
#             " AND oab_file.oab01=osa25  AND occ_file.occ01=osa03 ",
#             " AND osb01=osa01 ",
#             " AND oca_file.oca01=osa06 ",
#             " ORDER BY osa01,osb02,osb03 "
#   PREPARE i100_p1 FROM g_sql                # RUNTIME 編譯
#   IF SQLCA.SQLCODE THEN CALL cl_err('prepare',STATUS,0) END IF
#   DECLARE i100_co                         # CURSOR
#       CURSOR WITH HOLD FOR i100_p1
 
#   START REPORT i100_rep TO l_name
 
#   FOREACH i100_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
#       OUTPUT TO REPORT i100_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i100_rep
 
#   CLOSE i100_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i100_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680130  VARCHAR(1)
#   l_sw            LIKE type_file.chr1,          #No.FUN-680130  VARCHAR(1)
#   l_sql           LIKE type_file.chr1000,       #No.FUN-680130  VARCHAR(300)
#   l_i,l_j         LIKE type_file.num5,          #No.FUN-680130  SMALLINT
#   sr              RECORD
#                   osa   RECORD LIKE osa_file.*,
#                   gem02 LIKE gem_file.gem02,
#                   gen02 LIKE gen_file.gen02,
#                   oab02 LIKE oab_file.oab02,
#                   occ02 LIKE occ_file.occ02,
#                   oca02 LIKE oca_file.oca02,
#                   osb02 LIKE osb_file.osb02,
#                   osb03 LIKE osb_file.osb03,
#                   osb04 LIKE osb_file.osb04,
#                   osb05 LIKE osb_file.osb05
#                   END RECORD,
#       m_osb_count LIKE type_file.num5,          #No.FUN-680130  SMALLINT
#       l_occ02     LIKE occ_file.occ02,
#       l_oab02     LIKE oab_file.oab02
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.osa.osa01
 
#   FORMAT
#       PAGE HEADER
#No.FUN-580013  --begin
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
 
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#           g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#           g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
#           g_x[46],g_x[47]
#     PRINT g_dash1
#     LET l_trailer_sw = 'y'
#     LET m_osb_count=200
#No.FUN-580013  --end
#
#No.FUN-580013  -start
#       BEFORE GROUP OF sr.osa.osa01
#          SKIP TO TOP OF PAGE
#          PRINT COLUMN g_c[31],sr.osa.osa01 CLIPPED,
#                COLUMN g_c[32],sr.osa.osa02 CLIPPED;
#          IF sr.osa.osa05='1' THEN
#               PRINT COLUMN g_c[33],g_x[25] CLIPPED;
#          ELSE PRINT COLUMN g_c[33],g_x[26] CLIPPED;
#          END IF
#          PRINT COLUMN g_c[34],sr.osa.osa15,' ',sr.gem02,
#                COLUMN g_c[35],sr.osa.osa14,' ',sr.gen02,
#                COLUMN g_c[36],sr.osa.osa25,' ',sr.oab02;
#          PRINT COLUMN g_c[37],sr.osa.osa26,' ';
#                SELECT oab02 INTO l_oab02 FROM oab_file
#                 WHERE oab01=sr.osa.osa26
#                    IF STATUS THEN LET l_oab02='' END IF
#                PRINT l_oab02;
#          PRINT COLUMN g_c[38],sr.osa.osa03,' ',sr.occ02,
#                COLUMN g_c[39],sr.osa.osa06,' ',sr.oca02;
#          PRINT COLUMN g_c[40],sr.osa.osa04,' ';
#                SELECT occ02 INTO l_occ02 FROM occ_file
#                 WHERE occ01=sr.osa.osa04
#                    IF STATUS THEN LET l_occ02='' END IF
#                 PRINT l_occ02;
#          PRINT COLUMN g_c[41],sr.osa.osa23 CLIPPED,
#                COLUMN g_c[42],sr.osa.osa24 CLIPPED,
#                COLUMN g_c[43],sr.osa.osa90 CLIPPED;
#
#       ON EVERY ROW
#          PRINT COLUMN g_c[44],sr.osb02 USING '####',
#                COLUMN g_c[45],sr.osb03 USING '##',
#                COLUMN g_c[46],cl_numfor(sr.osb04,46,g_azi04),
#                COLUMN g_c[47],cl_numfor(sr.osb05,47,g_azi04)
#No.FUN-580013  --end
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN
#                 #TQC-630166
#                 # IF g_wc[001,080] > ' ' THEN
#       	  #    PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                 # IF g_wc[071,140] > ' ' THEN
#       	  #    PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                 # IF g_wc[141,210] > ' ' THEN
#       	  #    PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                   CALL cl_prt_pos_wc(g_wc)
#                 #END TQC-630166
#                   PRINT g_dash[1,g_len]
#           END IF
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end--
#單頭
FUNCTION i100_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680130  VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("osa01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680130  VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("osa01",FALSE)
       END IF
   END IF
 
END FUNCTION
#No.TQC-740269  --Begin
FUNCTION i100_osb05()
DEFINE l_cnt LIKE type_file.num5 
  FOR l_cnt =1 TO g_rec_b
      IF NOT cl_null(g_osb[l_cnt].osb04) THEN
         IF NOT cl_null(g_osa.osa24) THEN
            LET g_osb[l_cnt].osb05=g_osa.osa24*g_osb[l_cnt].osb04
         END IF
      END IF
      UPDATE osb_file SET osb05 = g_osb[l_cnt].osb05
      WHERE osb01 = g_osa.osa01 AND osb04 = g_osb[l_cnt].osb04
      DISPLAY BY NAME g_osb[l_cnt].osb05
 END FOR
END FUNCTION
#No.TQC-740269  --End
#Patch....NO.TQC-610037 <> #
