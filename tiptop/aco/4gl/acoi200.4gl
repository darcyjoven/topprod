# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acoi200
# Descriptions...: 加工合同BOM維護作業
# Date & Author..: 00/04/21 By Kammy
# Modify.........: 03/06/20 加版號(com02)
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/11/04 By Danny add com03
# Modify.........: No.FUN-550100 05/05/25 By ching 特性BOM功能修改
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: NO.FUN-570129 05/08/05 BY yiting 單身只有行序時只能放棄才能離
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: NO.FUN-590118 06/01/03 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660004 06/06/02 By Mandy 參數設不可於建檔作業修改KEY值,run Q->U->B->A,此時程式當住
# Modify.........: No.TQC-660045 06/06/12 By CZH cl_err-->cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0" 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-720019 07/03/02 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770006 07/07/06 By zhoufeng 報表輸出改為Crystal Reports
# Modify.........: No.TQC-790066 07/09/11 By Judy 單身"原產國"無控管
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-860043 08/06/05 By Dido PROMPT 改用 cl_prompt
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-960159 09/06/17 By Carrier copy時,檢查主件不得和單身料件相同
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.CHI-960013 09/08/11 By Smapmin 單耗計算應考慮主件的換算率
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B30040 11/03/15 by shenyang 加入固定損耗率及損耗批量
# Modify.........: No.FUN-B50062 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BB0083 11/12/23 By xujing 增加數量欄位小數取位 con_file
# Modify.........: No:TQC-C20434 12/02/23 By wuxj  過單
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_com           RECORD  LIKE com_file.*,
    g_com_t         RECORD  LIKE com_file.*,
    g_com_o         RECORD  LIKE com_file.*,
    g_com01_t       LIKE com_file.com01,   #商品編號(舊值)
    g_com02_t       LIKE com_file.com02,
    g_com03_t       LIKE com_file.com03,   #No.MOD-490398
    g_coa04         LIKE coa_file.coa04,   #CHI-960013
    g_ima01         LIKE ima_file.ima01,
    g_ima910        LIKE ima_file.ima910,  #FUN-550100
    g_sw            LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(01)
    g_con           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        con02       LIKE con_file.con02,   #項次
        con03       LIKE con_file.con03,   #料號
        cob02       LIKE cob_file.cob02,   #品名規格
        con04       LIKE con_file.con04,   #單位
        con05       LIKE con_file.con05,   #單耗
        con06       LIKE con_file.con06,   #損耗率
        con061      LIKE con_file.con061,         #FUN-B30040
        con062      LIKE con_file.con062,         #FUN-B30040
        con07       LIKE con_file.con07    #原產國
                    END RECORD,
    g_con_t         RECORD                 #程式變數 (舊值)
        con02       LIKE con_file.con02,   #項次
        con03       LIKE con_file.con03,   #料號
        cob02       LIKE cob_file.cob02,   #品名規格
        con04       LIKE con_file.con04,   #單位
        con05       LIKE con_file.con05,   #單耗
        con06       LIKE con_file.con06,   #損耗率
        con061      LIKE con_file.con061,         #FUN-B30040
        con062      LIKE con_file.con062,         #FUN-B30040
        con07       LIKE con_file.con07    #原產國
                    END RECORD,
   #g_wc,g_wc2,g_sql    STRING, #TQC-630166        #No.FUN-680069
    g_wc,g_wc2,g_sql    STRING,    #TQC-630166        #No.FUN-680069
    g_seq           LIKE type_file.num5,         #No.FUN-680069 SMALLINT  #單身筆數
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
 
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE   g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINe   g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
 
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680069 INTEGER
#CKP3
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_str           STRING                       #No.FUN-770006
DEFINE   l_table         STRING                       #No.FUN-770006
DEFINE   g_con04_t       LIKE con_file.con04          #FUN-BB0083 add
 
MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF(NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ACO")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
#No.FUN-770006  --start--
    LET g_sql="com01.com_file.com01,com02.com_file.com02,",
              "com03.com_file.com03,cna02.cna_file.cna02,",
              "cob02.cob_file.cob02,cob021.cob_file.cob021,",
              "cob04.cob_file.cob04,con02.con_file.con02,",
              "con03.con_file.con03,cob02_1.cob_file.cob02,",
              "cob021_1.cob_file.cob021,con04.con_file.con04,",
              "con05.con_file.con05,con06.con_file.con06"
    LET l_table = cl_prt_temptable('acoi200',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#No.FUN-770006 --end--
 
    DROP TABLE i200_temp
#No.FUN-680069-begin
    CREATE TEMP TABLE i200_temp (
              level1   LIKE type_file.num5,  
              bmb02    LIKE bmb_file.bmb02,
              bmb03    LIKE bmb_file.bmb03,
              bmb06    LIKE bmb_file.bmb06,
              bmb08    LIKE bmb_file.bmb08,
              bmb10    LIKE bmb_file.bmb10,
              bma01    LIKE bmb_file.bmb01);
#No.FUN-680069-end
    IF STATUS THEN CALL cl_err('create tmp',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM 
    END IF
 
    LET g_com.com01  = ARG_VAL(1)           #主件編號
 
    LET g_forupd_sql = " SELECT * FROM com_file ",
                       " WHERE com01 = ? AND com02 = ? AND com03 = ?  ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 6
    OPEN WINDOW i200_w AT p_row,p_col
        WITH FORM "aco/42f/acoi200"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    CALL i200_menu()
    CLOSE WINDOW i200_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION i200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM
    CALL g_con.clear()
 
    LET g_wc=NULL
    LET g_wc2=NULL
     #No.MOD-490398
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   INITIALIZE g_com.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON com01,com02,com03,comuser,comgrup,  # 螢幕上取單頭條件
                              commodu,comdate,comacti
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
    ON ACTION controlp
           CASE
              WHEN INFIELD(com01) #商品編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_cob"
                 LET g_qryparam.state ="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO com01
                 NEXT FIELD com01
               #No.MOD-490398
              WHEN INFIELD(com03)    #海關代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_cna"
                 LET g_qryparam.default1 = g_com.com03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO com03
                 NEXT FIELD com03
                #No.MOD-490398 end
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
    IF INT_FLAG THEN  RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                              #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND comuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                              #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND comgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND comgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('comuser', 'comgrup')
    #End:FUN-980030
 
 
   # 螢幕上取單身條件
   CONSTRUCT g_wc2 ON con02,con03,con04,con05,con06,con061,con062,con07     #FUN-B30040 add con061,con062
            FROM s_con[1].con02,s_con[1].con03,s_con[1].con04,
                 s_con[1].con05,s_con[1].con06,s_con[1].con061,s_con[1].con062,s_con[1].con07   #FUN-B30040 add con061,con062
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
   ON ACTION controlp
           CASE
              WHEN INFIELD(con03) #商品編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_cob"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO con03
                 NEXT FIELD con03
               WHEN INFIELD(con04) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO con04
                 NEXT FIELD con04
               WHEN INFIELD(con07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_geb"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO con07
                 NEXT FIELD con07
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
   IF INT_FLAG THEN  RETURN END IF
   IF g_wc2 = " 1=1" THEN		             # 若單身未輸入條件
       #No.MOD-490398
      LET g_sql = "SELECT com01,com02,com03 FROM com_file ",
                  " WHERE ", g_wc CLIPPED,
                   " ORDER BY com01,com02,com03"                  #No.MOD-490398
   ELSE					             # 若單身有輸入條件
 
      LET g_sql = "SELECT UNIQUE com01,com02,com03 ",
                  "  FROM com_file, con_file ",
                  " WHERE com01 = con01 ",
                  "   AND com02 = con013 ",
                  "   AND com03 = con08 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY com01,com02,com03"                  #No.MOD-490398
 
       #No.MOD-490398 end
   END IF
 
   PREPARE i200_prepare FROM g_sql
   DECLARE i200_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i200_prepare
 
    #No.MOD-490398
   DROP TABLE x
   IF g_wc2 = " 1=1" THEN		             # 若單身未輸入條件
#     LET g_sql="SELECT DISTINCT com01,com02,com03 ",      #No.TQC-720019
      LET g_sql_tmp="SELECT DISTINCT com01,com02,com03 ",  #No.TQC-720019
                " FROM com_file WHERE ", g_wc CLIPPED," INTO TEMP x"
   ELSE
#     LET g_sql="SELECT DISTINCT com01,com02,com03 ",      #No.TQC-720019
      LET g_sql_tmp="SELECT DISTINCT com01,com02,com03 ",  #No.TQC-720019
                "  FROM com_file,con_file ",
                " WHERE com01=con01 AND com02 = con013 AND com03 = con08 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," INTO TEMP x"
   END IF
#  PREPARE i200_precount_x  FROM g_sql      #No.TQC-720019
   PREPARE i200_precount_x  FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i200_precount_x
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE i200_precount FROM g_sql
   DECLARE i200_count CURSOR FOR  i200_precount
    #No.MOD-490398 end
END FUNCTION
 
FUNCTION i200_menu()
 
   WHILE TRUE
      CALL i200_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i200_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i200_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i200_u()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i200_r()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i200_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i200_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL i200_b('')           #No.MOD-490398
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i200_out()
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
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_con),'','')
             END IF
         #--
        #No.FUN-6A0168-------add--------str----
          WHEN "related_document"           #相關文件
           IF cl_chk_act_auth() THEN
              IF g_com.com01 IS NOT NULL THEN
                 LET g_doc.column1 = "com01"
                 LET g_doc.column2 = "com02"
                 LET g_doc.column3 = "com03"
                 LET g_doc.value1 = g_com.com01
                 LET g_doc.value2 = g_com.com02
                 LET g_doc.value3 = g_com.com03
                 CALL cl_doc()
              END IF 
           END IF
        #No.FUN-6A0168-------add--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i200_a()
  DEFINE l_chr   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_con.clear()
    INITIALIZE g_com.* LIKE com_file.*             #DEFAULT 設置
    LET g_com01_t = NULL
    LET g_com02_t = NULL
     LET g_com03_t = NULL                           #No.MOD-490398
     LET g_com.com03 = g_coz.coz02                  #No.MOD-490398
    LET g_com.comacti = 'Y'
    LET g_com.comuser = g_user
    LET g_com.comgrup = g_grup
    LET g_com.comdate = g_today
    LET g_com_o.* = g_com.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i200_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #用戶不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            INITIALIZE g_com.* TO NULL
            EXIT WHILE
        END IF
        IF cl_null(g_com.com01) THEN               # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF g_com.com02 IS NULL THEN LET g_com.com02 = ' ' END IF
        LET g_com.comoriu = g_user      #No.FUN-980030 10/01/04
        LET g_com.comorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO com_file VALUES (g_com.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#            CALL cl_err(g_com.com01,SQLCA.sqlcode,1) #No.TQC-660045
             CALL cl_err3("ins","com_file",g_com.com01,g_com.com02,SQLCA.sqlcode,"","",1)           #NO.TQC-660045
            CONTINUE WHILE
        END IF
        SELECT com01,com02,com03 INTO g_com.com01,g_com.com02,g_com.com03 FROM com_file
            WHERE com01 = g_com.com01
              AND com02 = g_com.com02
               AND com03 = g_com.com03       #No.MOD-490398
        LET g_com01_t  = g_com.com01        #保留舊值
        LET g_com02_t  = g_com.com02
         LET g_com03_t  = g_com.com03        #No.MOD-490398
        LET g_com_t.*  = g_com.*
        LET g_ima01    = ' '
        LET g_ima910   = ' '  #FUN-550100
         CALL g_con.clear()                  #No.MOD-490398  by carrier
 
        #-->詢問是否依料號生成
         #No.MOD-490398  by carrier
        IF cl_confirm('aco-027') THEN
           CALL q_cob1(FALSE,FALSE,g_com.com01,g_com.com03,g_ima01)
                RETURNING g_ima01
 
           #FUN-550100
           SELECT ima910 INTO g_ima910 FROM ima_file WHERE ima01=g_ima01
           IF cl_null(g_ima910) THEN LET g_ima910=' ' END IF
           #--
           LET g_rec_b =0                  #NO.FUN-680064
           IF cl_null(g_ima01) THEN
              LET g_msg = g_com.com01 CLIPPED
              CALL cl_err(g_msg,'aco-001',0)
           ELSE
              CALL i200_b_gen()
              CALL i200_b_fill('')
              CALL i200_b('')
           END IF
        ELSE
           CALL i200_b_fill('')
           CALL i200_b('a')
        END IF	
         #No.MOD-490398  end
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i200_u()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_com.com01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_com.comacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_com.com01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_com01_t = g_com.com01
    LET g_com02_t = g_com.com02
     LET g_com03_t = g_com.com03                   #No.MOD-490398
    LET g_com.commodu = g_user
    LET g_com.comdate = g_today
    LET g_com_o.* = g_com.*
    BEGIN WORK
 
    OPEN i200_cl USING g_com.com01,g_com.com02,g_com.com03
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_com.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_com.com01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i200_cl
        RETURN
    END IF
    CALL i200_show()
    WHILE TRUE
        LET g_com01_t = g_com.com01
        LET g_com02_t = g_com.com02
         LET g_com03_t = g_com.com03           #No.MOD-490398
        CALL i200_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_com.*=g_com_t.*
            CALL i200_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
         #No.MOD-490398
        IF g_com.com01 != g_com01_t OR g_com.com02 != g_com02_t OR
           g_com.com03 != g_com03_t THEN
           UPDATE con_file SET con01  = g_com.com01,
                               con013 = g_com.com02,
                               con08  = g_com.com03
            WHERE con01 = g_com01_t
              AND con013= g_com02_t
              AND con08 = g_com03_t
 
           IF SQLCA.sqlcode THEN
#               CALL cl_err('con',SQLCA.sqlcode,0)  #No.TQC-660045
                CALL cl_err3("upd","con_file",g_com01_t,g_com02_t,SQLCA.SQLCODE,"","con",1)           #NO.TQC-660045
                CONTINUE WHILE
           END IF
         END IF    #No.MOD-490398 end
        UPDATE com_file SET com_file.* = g_com.*
            WHERE com01=g_com01_t AND com02=g_com02_t AND com03=g_com03_t
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_com.com01,SQLCA.sqlcode,0) #No.TQC-660045
             CALL cl_err3("upd","com_file",g_com01_t,g_com02_t,SQLCA.sqlcode,"","",1)             #NO.TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i200_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i200_i(p_cmd)
   DEFINE
        p_cmd               LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
        l_flag              LIKE type_file.chr1,                    #判斷必要欄位是否輸入        #No.FUN-680069 VARCHAR(1)
        l_msg1,l_msg2       LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(70)
        l_n                 LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    #TQC-660004---add---
    LET g_before_input_done = FALSE
    CALL i200_set_entry('a')
    LET g_before_input_done = TRUE
    #TQC-660004---end---
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
    INPUT BY NAME g_com.com01,g_com.com02,g_com.com03,g_com.comuser, #No.MOD-490398
                 g_com.comgrup,g_com.commodu,g_com.comdate,g_com.comacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i200_set_entry(p_cmd)
            CALL i200_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
 
        AFTER FIELD com01   #商品編號
            IF NOT cl_null(g_com.com01) THEN
               #-->check 是否存在海關商品檔
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_com.com01 != g_com_t.com01) THEN
                  CALL i200_com01('a',g_com.com01)
                  IF NOT cl_null(g_errno) THEN
                     LET g_com.com01  = g_com_t.com01
                     DISPLAY BY NAME g_com.com01
                     CALL cl_err(g_com.com01,g_errno,0) NEXT FIELD com01
                  END IF
               END IF
            END IF
 
         #No.MOD-490398
        AFTER FIELD com02   #BOM版本編號
            IF g_com.com02 IS NULL THEN LET g_com.com02 = ' ' END IF
 
        AFTER FIELD com03                         #海關代號
            IF NOT cl_null(g_com.com03) THEN
               CALL i104_com03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_com.com03,g_errno,0)
                  NEXT FIELD com03
               END IF
            END IF
            IF p_cmd ='a' OR
              (p_cmd ='u' AND (g_com.com01 !=g_com_t.com01  OR
                               g_com.com02 !=g_com_t.com02  OR
                               g_com.com03 !=g_com_t.com03)) THEN
               #-->check duplicated
               SELECT COUNT(*) INTO l_n FROM com_file
                WHERE com01 = g_com.com01
                  AND com02 = g_com.com02
                  AND com03 = g_com.com03
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_com.com01,-239,0)
                  NEXT FIELD com02
               END IF
             END IF         #No.MOD-490398 end
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            IF INT_FLAG THEN CLEAR FORM EXIT INPUT  END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(com01) #商品類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_cob"
                 LET g_qryparam.default1 = g_com.com01
                 CALL cl_create_qry() RETURNING g_com.com01
#                 CALL FGL_DIALOG_SETBUFFER( g_com.com01 )
                 DISPLAY BY NAME g_com.com01
                 DISPLAY BY NAME g_com.com012
                 NEXT FIELD com01
               #No.MOD-490398
              WHEN INFIELD(com03)      #海關代號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_cna"
                LET g_qryparam.default1 = g_com.com03
                CALL cl_create_qry() RETURNING g_com.com03
#                CALL FGL_DIALOG_SETBUFFER( g_com.com03 )
                DISPLAY BY NAME g_com.com03
                NEXT FIELD com03
                #No.MOD-490398 end
               OTHERWISE EXIT CASE
            END CASE
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(com01) THEN
        #        LET g_com.* = g_com_t.*
        #        DISPLAY BY NAME g_com.*
        #        NEXT FIELD com01
        #    END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
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
FUNCTION i200_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("com01,com02,com03",TRUE)     #No.MOD-490398
    END IF
 
END FUNCTION
 
FUNCTION i200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("com01,com02,com03",FALSE)   #No.MOD-490398
    END IF
END FUNCTION
 
FUNCTION i200_com01(p_cmd,p_key)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           p_key     LIKE com_file.com01,
           l_cob02   LIKE cob_file.cob02,
           l_cob021  LIKE cob_file.cob021,  #No.MOD-490398
           l_cob04   LIKE cob_file.cob04,
           l_cobacti LIKE cob_file.cobacti
 
    LET g_errno = ' '
     #No.MOD-490398  --begin
    SELECT cob02,cob021,cob04,cobacti INTO l_cob02,l_cob021,l_cob04,l_cobacti
      FROM cob_file WHERE cob01 = p_key
     #No.MOD-490398  --end
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-001'
                                   LET l_cobacti = NULL
                                   LET l_cob02 = ''
         WHEN l_cobacti='N'        LET g_errno = '9028'
                                   LET l_cob02 = ''
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) THEN
       DISPLAY l_cob02  TO FORMONLY.cob02_h
        DISPLAY l_cob021 TO FORMONLY.cob021   #No.MOD-490398
       DISPLAY l_cob04  TO FORMONLY.cob04
    END IF
END FUNCTION
 
 #No.MOD-490398
FUNCTION i104_com03(p_cmd)  #
    DEFINE l_cna02   LIKE cna_file.cna02,
           l_cnaacti LIKE cna_file.cnaacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
    LET g_errno = ' '
    SELECT cna02,cnaacti INTO l_cna02,l_cnaacti
      FROM cna_file WHERE cna01 = g_com.com03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-016'
         WHEN l_cnaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 #No.MOD-490398 end
 
#Query 查詢
FUNCTION i200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_com.* TO NULL             #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_con.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i200_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i200_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_com.* TO NULL
    ELSE
        OPEN i200_count
        FETCH i200_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i200_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680069 INTEGER
 
 
     #No.MOD-490398
    CASE p_flag
        WHEN 'N' FETCH NEXT     i200_cs INTO g_com.com01,
                                             g_com.com02,g_com.com03
        WHEN 'P' FETCH PREVIOUS i200_cs INTO g_com.com01,
                                             g_com.com02,g_com.com03
        WHEN 'F' FETCH FIRST    i200_cs INTO g_com.com01,
                                             g_com.com02,g_com.com03
        WHEN 'L' FETCH LAST     i200_cs INTO g_com.com01,
                                             g_com.com02,g_com.com03
      #No.MOD-490398 end
        WHEN '/'
         #CKP3
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
         FETCH ABSOLUTE g_jump i200_cs INTO g_com.com01,
                                             g_com.com02,g_com.com03  #No.MOD-490398
         LET mi_no_ask = FALSE
    END CASE
 
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_com.com01,SQLCA.sqlcode,0)
        INITIALIZE g_com.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_com.* FROM com_file WHERE com01=g_com.com01 AND com02=g_com.com02 AND com03=g_com.com03
    IF SQLCA.sqlcode THEN
        LET g_msg = g_com.com01 clipped
#        CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
         CALL cl_err3("sel","com_file",g_com.com01,g_com.com02,SQLCA.sqlcode,"","",1)             #NO.TQC-660045
        INITIALIZE g_com.* TO NULL
        RETURN
    END IF
 
    CALL i200_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i200_show()
    LET g_com_t.* = g_com.*                #保存單頭舊值
 
     DISPLAY BY NAME  g_com.com01,g_com.com02,g_com.com03,     #No.MOD-490398
                     g_com.comuser,g_com.comgrup,g_com.commodu,
                     g_com.comdate,g_com.comacti
 
 
    CALL i200_com01('d',g_com.com01)
    CALL i200_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION i200_r()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_com.com01) THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_com.comacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_com.com01,'mfg1000',0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i200_cl USING g_com.com01,g_com.com02,g_com.com03
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_com.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        LET g_msg = g_com.com01 clipped
        CALL cl_err(g_msg,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i200_show()
 
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "com01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "com02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "com03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_com.com01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_com.com02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_com.com03      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM com_file WHERE com01 = g_com.com01
                AND com02 = g_com.com02 AND com03 = g_com.com03   #No.MOD-490398
       DELETE FROM con_file WHERE con01 = g_com.com01
                AND con013 = g_com.com02 AND con08 = g_com.com03  #No.MOD-490398
        #No.MOD-490398
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)     #FUN-980002 add azoplant,azolegal
          VALUES ('acoi200',g_user,g_today,g_msg,g_com.com01,'delete',g_plant,g_legal) #FUN-980002 add g_plant,g_legal
        #No.MOD-490398 end
       CLEAR FORM
       #MOD-5A0004 add
       DROP TABLE x
#      EXECUTE i200_precount_x                  #No.TQC-720019
       PREPARE i200_precount_x2 FROM g_sql_tmp  #No.TQC-720019
       EXECUTE i200_precount_x2                 #No.TQC-720019
       #MOD-5A0004 end
       CALL g_con.clear()
         #CKP3
 #No.MOD-490398  by carrier
         DROP TABLE x
         EXECUTE i200_precount_x
 #No.MOD-490398  end
         OPEN i200_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i200_cl
            CLOSE i200_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end-- 
         FETCH i200_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i200_cl
            CLOSE i200_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i200_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i200_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i200_fetch('/')
         END IF
    END IF
    CLOSE i200_cl
    COMMIT WORK
END FUNCTION
 
#-->依開窗選取的料號生成
 
FUNCTION i200_b_gen()
  DEFINE l_cnt      LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   SELECT count(*) INTO l_cnt FROM bma_file
    WHERE bma01 = g_ima01
   IF l_cnt <= 0 THEN                          #無生產BOM
      CALL cl_err(g_ima01,'aco-028',0)
      RETURN
   END IF
 
 
  #FUN-550100
  SELECT ima910 INTO g_ima910 FROM ima_file WHERE ima01=g_ima01
  IF cl_null(g_ima910) THEN LET g_ima910=' ' END IF
  #--
 
  #-----CHI-960013---------
  INITIALIZE g_coa04 TO NULL
  SELECT coa04 INTO g_coa04 FROM coa_file
   WHERE coa01 = g_ima01
     AND coa05 = g_com.com03
  IF cl_null(g_coa04) THEN 
     LET g_coa04 = 1
  END IF 
  #-----END CHI-960013-----
 
  IF cl_confirm('aco-080') THEN
     #展開至尾階
     LET g_seq = 0
     CALL i200_gen1(g_ima01,g_ima910)  #FUN-550100
  ELSE
     #展下階料
     LET g_seq = 0
     CALL i200_gen2(0,g_ima01,g_ima910,1)  #FUN-550100
  END IF
END FUNCTION
 
 
FUNCTION i200_gen1(p_key,p_key2)
   DEFINE p_key		LIKE bma_file.bma01,    #主件料件編號
          p_key2	LIKE ima_file.ima910,   #FUN-550100
          l_cnt 	LIKE type_file.num5,    #No.FUN-680069 SMALLINT
          l_sw  	LIKE type_file.chr1,    #No.FUN-680069 VARCHAR(1)
          sr  RECORD
              level1 LIKE type_file.num5,       #No.FUN-680069 SMALLINT
              bmb02  LIKE bmb_file.bmb02,    #項次
              bmb03  LIKE bmb_file.bmb03,    #元件料號
              bmb06  LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08  LIKE bmb_file.bmb08,    #損耗率
              bmb10  LIKE bmb_file.bmb10,    #發料單位
              bma01  LIKE bma_file.bma01,
              ima25  LIKE ima_file.ima25,
              coa03  LIKE coa_file.coa03,    #No.MOD-490398
              coa04  LIKE coa_file.coa04,    #No.MOD-490398
              cob04  LIKE cob_file.cob04,
              cob10  LIKE cob_file.cob10
          END RECORD,
          l_con         RECORD  LIKE con_file.*,
          l_qpa         LIKE bmb_file.bmb06,
          l_yield       LIKE bmb_file.bmb08,
          l_factor      LIKE bmb_file.bmb10_fac,
          l_cmd		LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(600)
	
    DELETE FROM i200_temp
    CALL i200_bom(0,p_key,p_key2,1)   #FUN-550100
 
    SELECT COUNT(*) INTO l_cnt FROM i200_temp
    IF l_cnt <= 0 THEN
       CALL cl_err(p_key,'aco-074',0)
       RETURN
    END IF
 
     #No.MOD-490398  by carrier
    DECLARE gen_curs CURSOR FOR
      SELECT i200_temp.*,ima25,'',0,'',''
        FROM i200_temp,ima_file
       WHERE ima01 = bmb03
     #No.MOD-490398  end
 
    FOREACH gen_curs INTO sr.*
       IF STATUS THEN
          CALL cl_err('gen_curs',STATUS,0) LET g_success='N' EXIT FOREACH
       END IF
 
        #No.MOD-490398  by carrier
       INITIALIZE sr.coa03 TO NULL
       INITIALIZE sr.coa04 TO NULL
       SELECT coa03,coa04 INTO sr.coa03,sr.coa04 FROM coa_file
        WHERE coa01 = sr.bmb03
          AND coa05 = g_com.com03
       IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN    #出現一個ima01對應多個coa03
          CALL q_coa(FALSE,FALSE,sr.coa03,sr.coa04,sr.bmb03,g_com.com03)
               RETURNING sr.coa03,sr.coa04
          IF INT_FLAG THEN
             LET INT_FLAG=0
             CONTINUE FOREACH
          END IF
 
       END IF
       SELECT cob04,cob10 INTO sr.cob04,sr.cob10
         FROM cob_file WHERE cob01 = sr.coa03
        #No.MOD-490398  end
 
       SELECT count(*) INTO l_cnt FROM con_file
        WHERE con01 = g_com.com01
          AND con03 = sr.coa03
          AND con013 = g_com.com02
           AND con08  = g_com.com03          #No.MOD-490398
       IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
 
       #-->發料單位轉庫存單位
       LET l_factor = 1
       CALL s_umfchk(sr.bmb03,sr.bmb10,sr.ima25)
       RETURNING l_sw,l_factor
       IF l_sw = '1' THEN
          CALL cl_err(sr.bmb03,'mfg1206',0)
          LET l_factor = 1
       END IF
       #-->轉換成重量單位
        #LET l_qpa   = sr.bmb06 * l_factor * sr.coa04              #No.MOD-490398   #CHI-960013
        LET l_qpa   = sr.bmb06 * l_factor * sr.coa04 / g_coa04     #CHI-960013
        LET l_yield = sr.bmb08 * l_factor * sr.coa04  #損耗率     #No.MOD-490398
       IF l_cnt = 0 THEN
          LET g_seq = g_seq + 1
          LET l_con.con01  = g_com.com01
          LET l_con.con013 = g_com.com02
           LET l_con.con08  = g_com.com03      #No.MOD-490398
          LET l_con.con02  = g_seq            #行序
          LET l_con.con03  = sr.coa03          #料件
          LET l_con.con04  = sr.cob04          #單位
          LET l_con.con05  = l_qpa            #單耗
          LET l_con.con06  = l_yield          #損耗率
          LET l_con.con061 = 0                #FUN-B30040
          LET l_con.con062 =1                 #FUN-B30040
          LET l_con.con07  = sr.cob10          #原產國
          INSERT INTO con_file VALUES(l_con.*)
       ELSE
          UPDATE con_file SET con05 = con05 + l_qpa,
                              con06 = con06 + l_yield
           WHERE con01 = g_com.com01
             AND con03 = sr.coa03
             AND con013 = g_com.com02
              AND con08  = g_com.com03        #No.MOD-490398
       END IF
    END FOREACH
END FUNCTION
 
FUNCTION i200_bom(p_level,p_key,p_key2,p_total)  #FUN-550100
   DEFINE p_level	LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          p_key		LIKE bma_file.bma01,  #主件料件編號
          p_key2	LIKE ima_file.ima910,  #FUN-550100
         #p_total       DECIMAL(13,5),
          p_total       LIKE bmb_file.bmb06, #FUN-560227
          l_ac,i	LIKE type_file.num5,          #No.FUN-680069 SMALLINT
          arrno		LIKE type_file.num5,         #No.FUN-680069 SMALLINT  #BUFFER SIZE (可存筆數)
          l_chr,l_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          l_cnt 	LIKE type_file.num5,          #No.FUN-680069 SMALLINT
          l_fac         LIKE bmb_file.bmb10_fac,
          l_ima55       LIKE ima_file.ima55,
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              level1 LIKE type_file.num5,         #No.FUN-680069 SMALLINT
              bmb02  LIKE bmb_file.bmb02,    #項次
              bmb03  LIKE bmb_file.bmb03,    #元件料號
              bmb06  LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08  LIKE bmb_file.bmb08,    #損耗率
              bmb10  LIKE bmb_file.bmb10,    #發料單位
              bma01  LIKE bma_file.bma01
          END RECORD,
          l_cmd		LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(600)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
	
    IF p_level > 20 THEN
       CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
          
    END IF
    LET p_level = p_level + 1
    LET arrno = 600			
    LET l_cmd= "SELECT 0, bmb02, bmb03, (bmb06/bmb07),bmb08,bmb10, bma01",
               "  FROM bmb_file LEFT OUTER JOIN bma_file ON bmb_file.bmb03 = bma_file.bma01 ",
               " WHERE bmb01='", p_key,"' ",
               "   AND bmb29 ='",p_key2,"' "  #FUN-550100
    #---->生效日及失效日的判斷
     LET l_cmd=l_cmd CLIPPED,
               " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
               " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
    LET l_cmd = l_cmd CLIPPED, ' ORDER BY bmb02'
    PREPARE q502_precur FROM l_cmd
    IF SQLCA.sqlcode THEN CALL cl_err('P1:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM 
    END IF
    DECLARE q502_cur CURSOR FOR q502_precur
    LET l_ac = 1
    CALL sr.clear()
    FOREACH q502_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
        #FUN-8B0035--BEGIN--                                                                                                    
        LET l_ima910[l_ac]=''
        SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
        IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
        #FUN-8B0035--END--
        LET l_ac = l_ac + 1
        IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1    	        	# 讀BUFFER傳給REPORT
        LET sr[i].level1 = p_level
         #No.MOD-490398  by carrier
        LET l_fac = 1
        SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=sr[i].bmb03
        IF l_ima55 !=sr[i].bmb10 THEN
           CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,l_ima55)
                 RETURNING l_sw, l_fac    #單位換算
           IF l_sw  = '1'  THEN #有問題
              CALL cl_err(sr[i].bmb03,'abm-731',1)
              LET l_fac = 1
           END IF
        END IF
        LET sr[i].bmb06=p_total*sr[i].bmb06*l_fac
         #No.MOD-490398  end
 
        IF sr[i].bma01 IS NOT NULL 			#若為主件
          #THEN CALL i200_bom(p_level,sr[i].bmb03,' ',sr[i].bmb06)  #FUN-550100#FUN-8B0035
           THEN CALL i200_bom(p_level,sr[i].bmb03,l_ima910[i],sr[i].bmb06)  #FUN-8B0035
        ELSE
            #No.MOD-490398
           SELECT UNIQUE ima01 FROM ima_file,cob_file,coa_file
            WHERE ima01 = sr[i].bmb03
              AND coa01 = ima01
              AND coa05 = g_com.com03
               AND cob01 = coa03         #No.MOD-490398 end
           IF STATUS = 0 THEN
              INSERT INTO i200_temp VALUES(sr[i].*)
           END IF
        END IF
    END FOR
END FUNCTION
 
 
FUNCTION i200_gen2(p_level,p_key,p_key2,p_total)  #FUN-550100
   DEFINE p_level	LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          p_key		LIKE bma_file.bma01,  #主件料件編號
          p_key2	LIKE ima_file.ima910,  #FUN-550100
          l_ima02	LIKE ima_file.ima02,  #料件品名規格
         #p_total       DECIMAL(13,5),
          p_total       LIKE bmb_file.bmb06, #FUN-560227
          l_ac,i	LIKE type_file.num5,          #No.FUN-680069 SMALLINT
          arrno		LIKE type_file.num5,         #No.FUN-680069 SMALLINT  #BUFFER SIZE (可存筆數)
          l_chr,l_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
          l_cnt 	LIKE type_file.num5,          #No.FUN-680069 SMALLINT
          l_ima55       LIKE ima_file.ima55,
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              level1 LIKE type_file.num5,         #No.FUN-680069 SMALLINT
              bmb02  LIKE bmb_file.bmb02,    #項次
              bmb03  LIKE bmb_file.bmb03,    #元件料號
              bmb06  LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08  LIKE bmb_file.bmb08,    #損耗率
              bmb10  LIKE bmb_file.bmb10,    #發料單位
              bma01  LIKE bma_file.bma01
          END RECORD,
          l_con         RECORD  LIKE con_file.*,
          l_ima25       LIKE ima_file.ima25,
          l_coa03       LIKE coa_file.coa03,       #No.MOD-490398
          l_cob04       LIKE cob_file.cob04,
          l_coa04       LIKE coa_file.coa04,       #No.MOD-490398
          l_cob10       LIKE cob_file.cob10,
          l_qpa         LIKE bmb_file.bmb06,
          l_yield       LIKE bmb_file.bmb08,
          l_factor      LIKE bmb_file.bmb10_fac,
          l_fac         LIKE bmb_file.bmb10_fac,
          l_cmd		LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(600)
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
    DEFINE l_ima910a   DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
	
    IF p_level > 20 THEN
       CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
          
    END IF
    LET p_level = p_level + 1
    LET arrno = 600		
 
    LET l_cmd= "SELECT 0, bmb02, bmb03, (bmb06/bmb07),bmb08,bmb10,bma01",
               "  FROM bmb_file LEFT OUTER JOIN bma_file ON bmb_file.bmb03 = bma_file.bma01 ",
               " WHERE bmb01='", p_key,"' ",
               "   AND bmb29 ='",p_key2,"' "  #FUN-550100
    #---->生效日及失效日的判斷
     LET l_cmd=l_cmd CLIPPED,
               " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
               " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
    LET l_cmd = l_cmd CLIPPED, ' ORDER BY bmb02'
    PREPARE i200_precur FROM l_cmd
    IF SQLCA.sqlcode THEN CALL cl_err('P1:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM 
    END IF
    DECLARE i200_cur CURSOR FOR i200_precur
    LET l_ac = 1
    FOREACH i200_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
        #FUN-8B0035--BEGIN--
        LET l_ima910[l_ac]=''
        SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bma01
        IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
        LET l_ima910a[l_ac]=''
        SELECT ima910 INTO l_ima910a[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
        IF cl_null(l_ima910a[l_ac]) THEN LET l_ima910a[l_ac]=' ' END IF
        #FUN-8B0035--END-- 
        LET l_ac = l_ac + 1
        IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1    	        	# 讀BUFFER傳給REPORT
         #No.MOD-490398   by carrier
        LET l_fac = 1
        SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=sr[i].bmb03
        IF l_ima55 !=sr[i].bmb10 THEN
           CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,l_ima55)
                 RETURNING l_sw ,l_fac    #單位換算
           IF l_sw  = '1'  THEN #有問題
              CALL cl_err(sr[i].bmb03,'abm-731',1)
              LET l_fac = 1
           END IF
        END IF
 
        LET sr[i].level1 = p_level
        LET sr[i].bmb06  = p_total*sr[i].bmb06*l_fac
         #No.MOD-490398  end
        IF sr[i].bma01 IS NOT NULL THEN 			#若為主件
           DELETE FROM i200_temp
          #CALL i200_bom(0,sr[i].bma01,' ',1)  #FUN-550100#FUN-8B0035
           CALL i200_bom(0,sr[i].bma01,l_ima910[i],1)  #FUN-8B0035
           SELECT COUNT(*) INTO l_cnt FROM i200_temp
 
           IF l_cnt > 0 THEN     #若為保稅半成品,開窗詢問是否展下階
 
              OPEN WINDOW cl_bom_w WITH 5 ROWS,50 COLUMNS
                 ATTRIBUTES( STYLE=g_win_style CLIPPED)
 
              DISPLAY sr[i].level1 at 1,10
              DISPLAY sr[i].bmb03 at 1,20
              SELECT ima02 INTO l_ima02
                FROM ima_file
               WHERE ima01 = sr[i].bmb03
              IF SQLCA.sqlcode THEN LET l_ima02 = '' END IF
              DISPLAY l_ima02 
              DISPLAY sr[i].bmb06 
              LET g_sw =' '
             
              CALL cl_getmsg('aco-011',g_lang) RETURNING g_msg
 
              IF cl_prompt(17,5,g_msg) THEN
                 LET g_sw = 'Y'
              ELSE
                 LET g_sw = 'N'
              END IF
              #-----END CHI-960013-----
             #WHILE TRUE
             #   CASE
             #      WHEN g_lang = '0'
             #          LET INT_FLAG = 0  ######add for prompt bug
             #          PROMPT "   是否展下階料 ? " FOR CHAR g_sw
             #      WHEN g_lang = '2'
             #          LET INT_FLAG = 0  ######add for prompt bug
             #          PROMPT "   是否展下階料 ? " FOR CHAR g_sw
             #      OTHERWISE
             #          LET INT_FLAG = 0  ######add for prompt bug
             #          PROMPT " Expand Down Level Item ? (Y/N) " FOR CHAR g_sw
             #             ON IDLE g_idle_seconds
             #                CALL cl_on_idle()
             #
             #              ON ACTION about         #MOD-4C0121
             #                 CALL cl_about()      #MOD-4C0121
             #
             #              ON ACTION help          #MOD-4C0121
             #                 CALL cl_show_help()  #MOD-4C0121
             #
             #              ON ACTION controlg      #MOD-4C0121
             #                 CALL cl_cmdask()     #MOD-4C0121
             #  
             #          END PROMPT
             #   END CASE
             #   IF g_sw MATCHES '[YyNn]' THEN
             #      EXIT WHILE
             #   ELSE
             #      CONTINUE WHILE
             #   END IF
             #END WHILE
             #---- END MOD-860043 ----#
                 CLOSE WINDOW cl_bom_w
              IF g_sw MATCHES '[yY]' THEN            #展下階料
               #CALL i200_gen2(p_level,sr[i].bmb03,' ',sr[i].bmb06) #FUN-550100#FUN-8B0035
                CALL i200_gen2(p_level,sr[i].bmb03,l_ima910a[i],sr[i].bmb06) #FUN-8B0035
              ELSE                       #不展下階料,直接寫入con_file
                  #No.MOD-490398  by carrier
                 SELECT ima25 INTO l_ima25 FROM ima_file
                  WHERE ima01 = sr[i].bmb03
                 INITIALIZE l_coa03 TO NULL
                 INITIALIZE l_coa04 TO NULL
                 SELECT coa03,coa04 INTO l_coa03,l_coa04 FROM coa_file
                  WHERE coa01 = sr[i].bmb03
                    AND coa05 = g_com.com03
                 IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN    #出現一個ima01對應多個coa03
                    CALL q_coa(FALSE,FALSE,l_coa03,l_coa04,sr[i].bmb03,g_com.com03)
                         RETURNING l_coa03,l_coa04
                    IF INT_FLAG THEN LET INT_FLAG=0 CONTINUE FOR END IF
                 END IF
                 SELECT cob04,cob10 INTO l_cob04,l_cob10
                   FROM cob_file WHERE cob01 = l_coa03
                 IF cl_null(l_coa03) THEN       #此半成品無對應的商品編號
                     CALL cl_err(sr[i].bmb03,'aco-075',0)    #No.MOD-490398
                 ELSE
                    SELECT count(*) INTO l_cnt FROM con_file
                    WHERE con01 = g_com.com01
                      AND con03 = l_coa03
                      AND con013 = g_com.com02
                       AND con08  = g_com.com03               #No.MOD-490398
                    IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
                    #-->發料單位轉庫存單位
                     #No.MOD-490398 by carrier
                    #CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,l_ima25)
                    #     RETURNING l_sw,l_factor
                    CALL s_umfchk(sr[i].bmb03,l_ima55,l_ima25)
                         RETURNING l_sw,l_factor
                     #No.MOD-490398 end
                    IF l_sw = '1' THEN
                       CALL cl_err(sr[i].bmb03,'mfg1206',0)
                       LET l_factor = 1
                    END IF
                    #-->轉換成重量單位
                    #LET l_qpa   = sr[i].bmb06 * l_factor * l_coa04   #CHI-960013
                    LET l_qpa   = sr[i].bmb06 * l_factor * l_coa04/g_coa04   #CHI-960013  
                    LET l_yield = sr[i].bmb08 * l_factor * l_coa04  #損耗率
                    IF l_cnt = 0 THEN
                       LET g_seq = g_seq + 1
                       LET l_con.con01  = g_com.com01
                       LET l_con.con013 = g_com.com02      #BOM版本編號
                       LET l_con.con08  = g_com.com03      #海關代號
                       LET l_con.con02  = g_seq            #行序
                       LET l_con.con03  = l_coa03          #料件
                       LET l_con.con04  = l_cob04          #單位
                       LET l_con.con05  = l_qpa            #單耗
                       LET l_con.con06  = l_yield          #損耗率
                       LET l_con.con061 = 0                #FUN-B30040
                       LET l_con.con062 = 1                #FUN-B30040
                       LET l_con.con07  = l_cob10          #原產國
                       INSERT INTO con_file VALUES(l_con.*)
                    ELSE
                       UPDATE con_file SET con05 = con05 + l_qpa,
                                           con06 = con06 + l_yield
                        WHERE con01 = g_com.com01
                          AND con03 = l_coa03
                          AND con013= g_com.com02
                          AND con08 = g_com.com03
                    END IF
                 END IF
              END IF
           END IF
        ELSE                          #元件
            #No.MOD-490398 carrier
           SELECT ima25 INTO l_ima25 FROM ima_file
            WHERE ima01 = sr[i].bmb03
           INITIALIZE l_coa03 TO NULL
           INITIALIZE l_coa04 TO NULL
           SELECT coa03,coa04 INTO l_coa03,l_coa04 FROM coa_file
            WHERE coa01 = sr[i].bmb03
              AND coa05 = g_com.com03
           IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN    #出現一個ima01對應多個coa03
              CALL q_coa(FALSE,FALSE,l_coa03,l_coa04,sr[i].bmb03,g_com.com03)
                   RETURNING l_coa03,l_coa04
          IF INT_FLAG THEN
             LET INT_FLAG=0
             CONTINUE FOR
          END IF
           END IF
           SELECT cob04,cob10 INTO l_cob04,l_cob10
             FROM cob_file WHERE cob01 = l_coa03
           IF cl_null(l_coa03) THEN CONTINUE FOR END IF
            #No.MOD-490398 end
           SELECT count(*) INTO l_cnt FROM con_file
            WHERE con01 = g_com.com01
              AND con03 = l_coa03
              AND con013 = g_com.com02
              AND con08  = g_com.com03
           IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
           #-->發料單位轉庫存單位
            #No.MOD-490398 carrier
           #CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,l_ima25)
           #     RETURNING l_sw,l_factor
           CALL s_umfchk(sr[i].bmb03,l_ima55,l_ima25)
                RETURNING l_sw,l_factor
            #No.MOD-490398 end
           IF l_sw = '1' THEN
              CALL cl_err(sr[i].bmb03,'mfg1206',0)
              LET l_factor = 1
           END IF
           #-->轉換成重量單位
           #LET l_qpa   = sr[i].bmb06 * l_factor * l_coa04   #CHI-960013
           LET l_qpa   = sr[i].bmb06 * l_factor * l_coa04/g_coa04  #CHI-960013
           LET l_yield = sr[i].bmb08 * l_factor * l_coa04  #損耗率
           IF l_cnt = 0 THEN
              LET g_seq = g_seq + 1
              LET l_con.con01  = g_com.com01
              LET l_con.con013  = g_com.com02     #BOM版本編號
              LET l_con.con08  = g_com.com03      #海關代號
              LET l_con.con02  = g_seq            #行序
              LET l_con.con03  = l_coa03          #料件
              LET l_con.con04  = l_cob04          #單位
              LET l_con.con05  = l_qpa            #單耗
              LET l_con.con06  = l_yield          #損耗率
              LET l_con.con061 = 0                #FUN-B30040
              LET l_con.con062 = 1                #FUN-B30040
              LET l_con.con07  = l_cob10          #原產國
              INSERT INTO con_file VALUES(l_con.*)
           ELSE
              UPDATE con_file SET con05 = con05 + l_qpa,
                                  con06 = con06 + l_yield
               WHERE con01 = g_com.com01
                 AND con03 = l_coa03
                 AND con013 = g_com.com02
                 AND con08  = g_com.com03
            END IF     #No.MOD-490398  end
        END IF
    END FOR
END FUNCTION
 
#單身
 FUNCTION i200_b(p_flag)                    #No.MOD-490398
DEFINE
    p_flag          LIKE type_file.chr1,                #No.MOD-490398        #No.FUN-680069 VARCHAR(1)
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680069 VARCHAR(1)
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680069 VARCHAR(1)
    l_cnt           LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    l_chr           LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_com.com01 IS NULL THEN
        RETURN
    END IF
    IF g_com.comacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_com.com01,'mfg1000',0)
        RETURN
    END IF
     #No.MOD-490398
    IF cl_null(p_flag) THEN
       SELECT COUNT(*) INTO l_cnt FROM con_file
        WHERE con01=g_com.com01
          AND con013=g_com.com02
          AND con08 =g_com.com03
       IF l_cnt = 0 THEN
           #-->詢問是否依料號生成
           IF cl_confirm('aco-027') THEN
              CALL q_cob1(FALSE,FALSE,g_com.com01,g_com.com03,g_ima01)
                   RETURNING g_ima01
              IF cl_null(g_ima01) THEN
                 LET g_msg = g_com.com01 CLIPPED
                 CALL cl_err(g_msg,'aco-001',0)
              ELSE
                 CALL i200_b_gen()
                 CALL i200_b_fill(' 1=1')
              END IF
           END IF
       END IF
    END IF
     #No.MOD-490398  end
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT con02,con03,'',con04,con05,con06,con061,con062,con07 ",  #FUN-B30040 add con06,con061
                       "   FROM con_file ",
                       "  WHERE con01= ? ",
                        "    AND con02= ? AND con013=? AND con08=?  ",  #No.MOD-490398
                       "    FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
   #CKP2
   IF g_rec_b=0 THEN CALL g_con.clear() END IF
 
   INPUT ARRAY g_con WITHOUT DEFAULTS FROM s_con.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            BEGIN WORK
            OPEN i200_cl USING g_com.com01,g_com.com02,g_com.com03
            IF STATUS THEN
               CALL cl_err("OPEN i200_cl:", STATUS, 1)
               CLOSE i200_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i200_cl INTO g_com.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_com.com01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i200_cl
               ROLLBACK WORK
               RETURN
            END IF
            LET l_ac = ARR_CURR()
            DISPLAY l_ac  TO FORMONLY.cn2
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_con_t.* = g_con[l_ac].*  #BACKUP
                LET g_con04_t = g_con[l_ac].con04  #FUN-BB0083 add
                OPEN i200_bcl USING g_com.com01,g_con_t.con02,g_com.com02,
                                     g_com.com03     #No.MOD-490398
                IF STATUS THEN
                   CALL cl_err("OPEN i200_bcl:", STATUS, 1)
                   CLOSE i200_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i200_bcl INTO g_con[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_con_t.con03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   CALL i200_con03('a')
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD con02
 
        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_con[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_con[l_ac].* TO s_con.*
              CALL g_con.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              #CKP
              CANCEL INSERT
              EXIT INPUT
            END IF
            INSERT INTO con_file(con01,con013,con02,con03,
                                  con04,con05,con06,con061,con062,con07,con08)  #No.MOD-490398  #FUN-B30040
            VALUES(g_com.com01,g_com.com02,
                   g_con[l_ac].con02,g_con[l_ac].con03,
                   g_con[l_ac].con04,g_con[l_ac].con05,
                    g_con[l_ac].con06,g_con[l_ac].con061,g_con[l_ac].con062,g_con[l_ac].con07,g_com.com03)  #No.MOD-490398
 
            IF SQLCA.sqlcode THEN
 #               CALL cl_err(g_con[l_ac].con02,SQLCA.sqlcode,0) #No.TQC-660045
                 CALL cl_err3("ins","con_file",g_com.com01,g_com.com02,SQLCA.sqlcode,"","",1)             #NO.TQC-660045
                #CKP
                ROLLBACK WORK
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_con[l_ac].* TO NULL      #900423
            LET g_con[l_ac].con05 = 1
            LET g_con[l_ac].con06 = 0
            LET g_con[l_ac].con061 =0             #FUN-B30040
            LET g_con[l_ac].con062 =1             #FUN-B30040
            LET g_con_t.* = g_con[l_ac].*         #新輸入資料
            LET g_con04_t = NULL        #FUN-BB0083 add
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD con02
 
        BEFORE FIELD con02                        #default 序號
            IF g_con[l_ac].con02 IS NULL OR g_con[l_ac].con02 = 0 THEN
               SELECT MAX(con02)+1 INTO g_con[l_ac].con02
                   FROM con_file
                   WHERE con01 = g_com.com01
                     AND con013 = g_com.com02
                IF g_con[l_ac].con02 IS NULL THEN
                    LET g_con[l_ac].con02 = 1
                END IF
                 #NO.MOD-570129 MARK
                #DISPLAY g_con[l_ac].con02 TO con02
            END IF
 
        AFTER FIELD con02                        #check 序號是否重複
            IF NOT g_con[l_ac].con02 IS NULL THEN
               IF g_con[l_ac].con02 != g_con_t.con02 OR
                  g_con_t.con02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM con_file
                    WHERE con01 = g_com.com01
                      AND con013 = g_com.com02
                       AND con08  = g_com.com03           #No.MOD-490398
                      AND con02 = g_con[l_ac].con02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_con[l_ac].con02 = g_con_t.con02
                       DISPLAY g_con[l_ac].con02 TO con02
                       NEXT FIELD con02
                   END IF
               END IF
            END IF
 
        AFTER FIELD con03
            IF NOT cl_null(g_con[l_ac].con03) THEN
              #-->check 是否存在海關商品檔
               #No.MOD-490398  --begin
              IF g_con[l_ac].con03 = g_com.com01 THEN
                 CALL cl_err(g_con[l_ac].con03,'mfg2633',0)
                 NEXT FIELD con03
              END IF
               #No.MOD-490398  --end
              IF cl_null(g_con_t.con03) THEN
                  SELECT COUNT(*) INTO l_n FROM cof_file
                   WHERE cof01 = g_con[l_ac].con03
                  IF cl_null(l_n) THEN LET l_n =0 END IF
                  IF l_n <= 0
                  THEN CALL cl_err(g_con[l_ac].con03,'aco-001',0)
                       LET g_con[l_ac].con03 = g_con_t.con03
                       DISPLAY g_con[l_ac].con03 TO con03
                       NEXT FIELD con03
                  END IF
              END IF
              CALL i200_con03('a')
            END IF
 
        AFTER FIELD con04
            IF NOT cl_null(g_con[l_ac].con04) THEN
               CALL i200_con04('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_con[l_ac].con04 = g_con_t.con04
                  DISPLAY g_con[l_ac].con04 TO con04
                  CALL cl_err(g_con[l_ac].con04,g_errno,0) NEXT FIELD con04
               END IF
               #FUN-BB0083---add---str
               IF NOT i200_con061_check() THEN 
                  LET g_con04_t = g_con[l_ac].con04
                  NEXT FIELD con061
               END IF 
               LET g_con04_t = g_con[l_ac].con04
               #FUN-BB0083---add---end
            END IF
 
        AFTER FIELD con05
            IF NOT cl_null(g_con[l_ac].con05) THEN
               IF g_con[l_ac].con05 <=0 THEN
                  LET g_con[l_ac].con05 = g_con_t.con05
                  DISPLAY g_con[l_ac].con05 TO con05
                  NEXT FIELD con05
               END IF
            END IF
 
        AFTER FIELD con06
            IF NOT cl_null(g_con[l_ac].con06) THEN
               IF g_con[l_ac].con06 < 0 OR g_con[l_ac].con06 > 100 THEN
                  CALL cl_err('','mfg4063',0)
                  LET g_con[l_ac].con06 = g_con_t.con06
                  DISPLAY g_con[l_ac].con06 TO con06
                  NEXT FIELD con06
               END IF
            END IF
#FUN-B30040--add--begin
       AFTER FIELD con061    #固定損耗量
          #FUN-BB0083---add---str
          IF NOT i200_con061_check() THEN
             NEXT FIELD con061
          END IF 
          #FUN-BB0083---add---end
          #FUN-BB0083---mark---str
          #  IF NOT cl_null(g_con[l_ac].con061) THEN
          #      IF g_con[l_ac].con061 < 0 THEN
          #         CALL cl_err(g_con[l_ac].con061,'aec-020',0)
          #         LET g_con[l_ac].con061 = g_con_t.con061
          #         NEXT FIELD con061
          #      END IF
          #      LET g_con_t.con061 = g_con[l_ac].con061
          #  END IF
          #  IF cl_null(g_con[l_ac].con061) THEN
          #      LET g_con[l_ac].con061 = 0
          #  END IF
          #  DISPLAY BY NAME g_con[l_ac].con061
          #FUN-BB0083---mark---end 

        AFTER FIELD con062    #損耗批量
            IF NOT cl_null(g_con[l_ac].con062) THEN
                IF g_con[l_ac].con062 <= 0 THEN
                   CALL cl_err(g_con[l_ac].con062,'alm-808',0)
                   LET g_con[l_ac].con062 = g_con_t.con062
                   NEXT FIELD con062
                END IF
                LET g_con_t.con062 = g_con[l_ac].con062
            END IF
            IF cl_null(g_con[l_ac].con062) THEN
                LET g_con[l_ac].con062 = 1
            END IF
            DISPLAY BY NAME g_con[l_ac].con062
#FUN-B30040--add--end 
#TQC-790066....begin
        AFTER FIELD con07
            IF NOT cl_null(g_con[l_ac].con07) THEN
                  SELECT COUNT(*) INTO l_n FROM geb_file 
                   WHERE geb01=g_con[l_ac].con07 
                  IF l_n = 0 THEN
                     CALL cl_err('','aco-238',0)
                     NEXT FIELD con07
                  END IF
            END IF
#TQC-790066....end
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_con_t.con02 > 0 AND
               g_con_t.con02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM con_file
                    WHERE con01 = g_com.com01
                      AND con013 = g_com.com02
                       AND con08  = g_com.com03       #No.MOD-490398
                      AND con02 = g_con_t.con02
                IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_con_t.con02,SQLCA.sqlcode,0) #No.TQC-660045
                     CALL cl_err3("del","con_file",g_com.com01,g_com.com02,SQLCA.sqlcode,"","",1)             #NO.TQC-660045
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
               LET g_con[l_ac].* = g_con_t.*
               CLOSE i200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_con[l_ac].con02,-263,1)
               LET g_con[l_ac].* = g_con_t.*
            ELSE
               UPDATE con_file SET con013= g_com.com02,
                                   con02 = g_con[l_ac].con02,
                                   con03 = g_con[l_ac].con03,
                                   con04 = g_con[l_ac].con04,
                                   con05 = g_con[l_ac].con05,
                                   con06 = g_con[l_ac].con06,
                                   con07 = g_con[l_ac].con07,
                                   con061=g_con[l_ac].con061, #FUN-B30040
                                   con062=g_con[l_ac].con062, #FUN-B30040
                                    con08 = g_com.com03     #No.MOD-490398
               WHERE con01=g_com.com01
                 AND con02=g_con_t.con02
                 AND con013=g_com.com02
                  AND con08 =g_com.com03     #No.MOD-490398
               IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_con[l_ac].con02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("upd","con_file",g_com.com01,g_com.com02,SQLCA.sqlcode,"","",1)             #NO.TQC-660045
                   LET g_con[l_ac].* = g_con_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
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
                  LET g_con[l_ac].* = g_con_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_con.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE i200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            #CKP
            #LET g_con_t.* = g_con[l_ac].*          # 900423
            LET l_ac_t = l_ac     #FUN-D30034 Add
            CLOSE i200_bcl
            COMMIT WORK
            #CKP2
           #CALL g_con.deleteElement(g_rec_b+1)     #FUN-D30034 Mark
 
        ON ACTION controlp #ok
           CASE
              WHEN INFIELD(con03) #商品編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_cob"
                 LET g_qryparam.default1 = g_con[l_ac].con03
                 CALL cl_create_qry() RETURNING g_con[l_ac].con03
#                 CALL FGL_DIALOG_SETBUFFER( g_con[l_ac].con03 )
                  DISPLAY BY NAME g_con[l_ac].con03         #No.MOD-490371
                 NEXT FIELD con03
               WHEN INFIELD(con04) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_con[l_ac].con04
                 CALL cl_create_qry() RETURNING g_con[l_ac].con04
#                 CALL FGL_DIALOG_SETBUFFER( g_con[l_ac].con04 )
                  DISPLAY BY NAME g_con[l_ac].con04         #No.MOD-490371
                 NEXT FIELD con04
               WHEN INFIELD(con07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_geb"
                 LET g_qryparam.default1 = g_con[l_ac].con07
                 CALL cl_create_qry() RETURNING g_con[l_ac].con07
#                 CALL FGL_DIALOG_SETBUFFER( g_con[l_ac].con07 )
                 DISPLAY BY NAME g_con[l_ac].con07
                 NEXT FIELD con07
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLN
            CALL i200_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(con02) AND l_ac > 1 THEN
                LET g_con[l_ac].* = g_con[l_ac-1].*
                NEXT FIELD con02
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
 
    #FUN-5B0043-begin
     LET g_com.commodu = g_user
     LET g_com.comdate = g_today
     UPDATE com_file SET commodu = g_com.commodu,comdate = g_com.comdate
      WHERE com01 = g_com.com01
     DISPLAY BY NAME g_com.commodu,g_com.comdate
    #FUN-5B0043-end
 
    CLOSE i200_cl
    CLOSE i200_bcl
    COMMIT WORK
    CALL i200_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i200_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM com_file WHERE com01 = g_com.com01
                                AND com02 = g_com.com02
                                AND com03 = g_com.com03
         INITIALIZE g_com.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i200_con03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_unit    LIKE con_file.con04,
           l_cobacti LIKE cob_file.cobacti
 
    LET g_errno = ' '
    SELECT cob02,cob04,cobacti INTO g_con[l_ac].cob02,l_unit,l_cobacti
           FROM cob_file WHERE cob01 = g_con[l_ac].con03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-001'
                                   LET l_cobacti = NULL
                                   LET g_con[l_ac].cob02 = ' '
         WHEN l_cobacti='N'        LET g_errno = '9028'
                                   LET g_con[l_ac].cob02 = ' '
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_con[l_ac].con04) AND cl_null(g_errno) THEN
       LET g_con[l_ac].con04 = l_unit
 #       DISPLAY g_con[l_ac].con04 TO con04  #No.MOD-490398 by carrier
    END IF
    IF cl_null(g_errno) THEN
 #       DISPLAY g_con[l_ac].cob02 TO cob02  #No.MOD-490398 by carrier
    END IF
END FUNCTION
 
FUNCTION i200_con04(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfeacti INTO l_gfeacti
           FROM gfe_file WHERE gfe01 = g_con[l_ac].con04
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2605'
                                   LET l_gfeacti = NULL
         WHEN l_gfeacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i200_b_askkey()
DEFINE
   #l_wc2           STRING #TQC-630166        #No.FUN-680069
    l_wc2           STRING    #TQC-630166        #No.FUN-680069
 
    CONSTRUCT l_wc2 ON con02,con03,con04,con05,con06,con061,con062,con07   #FUN-B30040
            FROM s_con[1].con02,s_con[1].con03,s_con[1].con04,
                 s_con[1].con05,s_con[1].con06,s_con[1].con061,s_con[1].con062,s_con[1].con07  #FUN-B30040
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 #No.MOD-490398  carrier
       ON ACTION controlp
           CASE
              WHEN INFIELD(con03) #商品編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_cob"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO con03
                 NEXT FIELD con03
               WHEN INFIELD(con04) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO con04
                 NEXT FIELD con04
               WHEN INFIELD(con07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_geb"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO con07
                 NEXT FIELD con07
               OTHERWISE EXIT CASE
            END CASE
 #No.MOD-490398  --end
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
    CALL i200_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           STRING, #TQC-630166        #No.FUN-680069
    p_wc2           STRING,    #TQC-630166        #No.FUN-680069
    l_flag          LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF cl_null(p_wc2) THEN LET p_wc2 = " 1=1" END IF
 
    LET g_sql =
        "SELECT con02,con03,cob02,con04,con05,con06,con061,con062,con07 ",    #FUN-B30040
        " FROM con_file LEFT OUTER JOIN cob_file ON con_file.con03 = cob_file.cob01 ",
        " WHERE con01 ='",g_com.com01,"' AND ",  #單頭-1
        "       con013 ='",g_com.com02,"' AND ",  #單頭-1
         "       con08  ='",g_com.com03,"' AND ",  #No.MOD-490398
    #No.FUN-8B0123---Begin   
        "       cob01 = con03 "       # AND ",
    #   p_wc2 CLIPPED,                #單身
    #   " ORDER BY 1"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE i200_pb FROM g_sql
    DECLARE con_cs                       #SCROLL CURSOR
        CURSOR FOR i200_pb
 
    CALL g_con.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH con_cs INTO g_con[g_cnt].*   #單身 ARRAY 填充
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
    #CKP
    CALL g_con.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_con TO s_con.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i200_fetch('L')
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
      ON ACTION output
         LET g_action_choice="output"
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
 
 
FUNCTION i200_copy()
DEFINE
    l_com      RECORD LIKE com_file.*,
    l_newno, l_oldno  LIKE com_file.com01,
    l_newno2,l_oldno2 LIKE com_file.com02,         #No.MOD-490398
    l_newno3,l_oldno3 LIKE com_file.com03          #No.MOD-490398
DEFINE l_cnt   LIKE type_file.num5                 #No.TQC-960159
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF cl_null(g_com.com01) THEN CALL cl_err('',-400,0) RETURN END IF
    DISPLAY '' TO FORMONLY.cob02_h
    DISPLAY g_msg AT 2,1
 
     #No.MOD-490398  --begin
    LET g_before_input_done = FALSE
    CALL i200_set_entry('a')
    LET g_before_input_done = TRUE
     #No.MOD-490398  --end
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
     INPUT l_newno,l_newno2,l_newno3 FROM com01,com02,com03     #No.MOD-490398
 
        AFTER FIELD com01
            IF NOT cl_null(l_newno) THEN
               CALL i200_com01('a',l_newno)
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(l_newno,g_errno,0)
                  NEXT FIELD com01
               END IF
               #No.TQC-960159  --Begin
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM con_file
                WHERE con03 = l_newno
               IF l_cnt > 0 THEN
                  CALL cl_err(l_newno,'mfg2633',0)
                  NEXT FIELD com01
               END IF
               #No.TQC-960159  --End  
            END IF
 
         #No.MOD-490398
        AFTER FIELD com02
            IF l_newno2 IS NULL THEN LET l_newno2 = ' ' END IF
 
        AFTER FIELD com03
            IF l_newno3 IS NULL THEN LET l_newno3 = ' ' END IF
            IF NOT cl_null(l_newno3) THEN
               SELECT COUNT(*) INTO g_cnt FROM com_file
                WHERE com01 = l_newno AND com02 = l_newno2
                  AND com03 = l_newno3
               IF g_cnt > 0 THEN
                  LET g_msg = l_newno,'+',l_newno2 clipped,'+',l_newno3 clipped
                  CALL cl_err(g_msg,-239,0)
                   NEXT FIELD com02       #No.MOD-490398  by carrier
               END IF
            END IF
          #No.MOD-490398 end
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(com01) #商品類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_cob"
                 LET g_qryparam.default1 = l_newno
                 CALL cl_create_qry() RETURNING l_newno
#                 CALL FGL_DIALOG_SETBUFFER( l_newno )
                 DISPLAY BY NAME l_newno
                 NEXT FIELD com01
               #No.MOD-490398
              WHEN INFIELD(com03)     #海關代號
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_cna"
                LET g_qryparam.default1 = l_newno3
                CALL cl_create_qry() RETURNING l_newno3
                DISPLAY l_newno3 TO com03
                NEXT FIELD com03
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
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG = 0
        DISPLAY BY NAME g_com.com01
        DISPLAY BY NAME g_com.com02    #add 03/03/24 NO.A024
         DISPLAY BY NAME g_com.com03    #No.MOD-490398
        CALL i200_com01('d',g_com.com01)
        RETURN
    END IF
 
    LET l_com.* = g_com.*
    LET l_com.com01 = l_newno
     LET l_com.com02 = l_newno2         #No.MOD-490398
     LET l_com.com03 = l_newno3         #No.MOD-490398
    LET l_com.comacti='Y'
    LET l_com.comdate=g_today
    LET l_com.commodu= ''
    BEGIN WORK
    LET l_com.comoriu = g_user      #No.FUN-980030 10/01/04
    LET l_com.comorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO com_file VALUES(l_com.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('com:',SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("ins","com_file",l_newno,l_newno2,SQLCA.sqlcode,"","com:",1)             #NO.TQC-660045
       RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM con_file             #單身複製
        WHERE con01 =g_com.com01
          AND con013 =g_com.com02       #add 03/03/24 NO.A024
           AND con08 =g_com.com03        #No.MOD-490398
        INTO TEMP x
    IF SQLCA.sqlcode
    THEN LET g_msg = g_com.com01,'+',g_com.com02 clipped #add 03/03/24 NO.A024
         CALL cl_err(g_msg,SQLCA.sqlcode,0)
         RETURN
    END IF
    UPDATE x
        SET con01=l_newno,
             con013=l_newno2, con08=l_newno3    #No.MOD-490398
    INSERT INTO con_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN 
#        CALL cl_err('con:',SQLCA.sqlcode,0) #No.TQC-660045
         CALL cl_err3("ins","con_file",l_newno,l_newno2,SQLCA.sqlcode,"","con:",1)             #NO.TQC-660045
       ROLLBACK WORK
            RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    LET l_oldno = g_com.com01
     LET l_oldno2= g_com.com02            #No.MOD-490398
     LET l_oldno3= g_com.com03            #No.MOD-490398
    SELECT com_file.* INTO g_com.* FROM com_file
              WHERE com01 = l_newno
                 AND com02 = l_newno2 AND com03 = l_newno3   #No.MOD-490398
    CALL i200_u()
     CALL i200_b('a')                     #No.MOD-490398
    #FUN-C30027---begin
    #SELECT com_file.* INTO g_com.* FROM com_file
    #          WHERE com01 = l_oldno
    #             AND com02 = l_oldno2 AND com03 = l_oldno3  #No.MOD-490398
    #CALL i200_show()
    #FUN-C30027---end
END FUNCTION
 
FUNCTION i200_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    sr              RECORD
        com01       LIKE com_file.com01,   #商品編號
        com02       LIKE com_file.com02,
        com03       LIKE com_file.com03,   #No.MOD-490398
        con02       LIKE con_file.con02,   #項次
        con03       LIKE con_file.con03,   #料件編號
        cob02       LIKE cob_file.cob02,   #品名規格
        cob021      LIKE cob_file.cob021,  #品名規格
        con04       LIKE con_file.con04,   #單位
        con05       LIKE con_file.con05,   #單耗
        con06       LIKE con_file.con06    #損耗率
                    END RECORD,
    l_name          LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) #External(Disk) file name
    l_za05          LIKE cob_file.cob01          #No.FUN-680069 VARCHAR(40)
DEFINE
    l_cob02         LIKE cob_file.cob02,         #No.FUN-770006
    l_cna02         LIKE cna_file.cna02,         #No.FUN-770006
    l_cob021        LIKE cob_file.cob021,        #No.FUN-770006
    l_cob04         LIKE cob_file.cob04,         #No.FUN-770006
    l_sql           LIKE type_file.chr1000       #No.FUN-770006
 
    CALL cl_del_data(l_table)                    #No.FUN-770006
 
    IF cl_null(g_wc) AND NOT cl_null(g_com.com01) AND NOT cl_null(g_com.com02)
       AND NOT cl_null(g_com.com03) THEN
       LET g_wc=" com01='",g_com.com01,"'",
            " AND com02='",g_com.com02,"'",
            " AND com03='",g_com.com03,"'"
    END IF
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#   CALL cl_outnam('acoi200') RETURNING l_name   #No.FUN-770006
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
     LET g_sql = "SELECT com01,com02,com03,con02,",    #No.MOD-490398
                "con03,cob02,cob021,con04,con05,con06 ",
               " FROM com_file,con_file LEFT OUTER JOIN cob_file ON con_file.con03=cob_file.cob01",
               " WHERE com01=con01 AND com02=con013",
                "   AND com03=con08  ",   #No.MOD-490398
               "   AND ",g_wc CLIPPED,
               "   AND ",g_wc2 CLIPPED
 
    PREPARE i200_p1 FROM g_sql                # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM 
    END IF
    DECLARE i200_co CURSOR FOR i200_p1
 
#   START REPORT i200_rep TO l_name           #No.FUN-770006
 
    FOREACH i200_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
#       OUTPUT TO REPORT i200_rep(sr.*)       #No.FUN-770006
#No.FUN-770006 --start--
        SELECT cob02,cob021,cob04 INTO l_cob02,l_cob021,l_cob04 FROM cob_file
               WHERE cob01=sr.com01              
        SELECT cna02 INTO l_cna02 FROM cna_file       
               WHERE cna01=sr.com03 
        EXECUTE insert_prep USING sr.com01,sr.com02,sr.com03,l_cna02,l_cob02,
                                  l_cob021,l_cob04,sr.con02,sr.con03,sr.cob02,
                                  sr.cob021,sr.con04,sr.con05,sr.con06
#No.FUN-770006 --end--
    END FOREACH
 
#   FINISH REPORT i200_rep                  #No.FUN-770006
 
    CLOSE i200_co
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)       #No.FUN-770006
#No.FUN-770006 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'com01,com02,com03,comuser,comgrup,
                           commodu,comdate,comacti')
            RETURNING g_wc
       LET g_str = g_wc
    END IF
    LET g_str = g_str
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('acoi200','acoi200',l_sql,g_str)
#No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT i200_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
    l_i             LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    l_cob02         LIKE cob_file.cob02,
    l_cna02         LIKE cna_file.cna02,
    l_cob021        LIKE cob_file.cob021,
    l_cob04         LIKE cob_file.cob04,
    sr              RECORD
        com01       LIKE com_file.com01,   #商品編號
        com02       LIKE com_file.com02,
        com03       LIKE com_file.com03,   #No.MOD-490398
        con02       LIKE con_file.con02,   #項次
        con03       LIKE con_file.con03,   #料件編號
        cob02       LIKE cob_file.cob02,   #品名規格
        cob021      LIKE cob_file.cob021,   #品名規格
        con04       LIKE con_file.con04,   #單位
        con05       LIKE con_file.con05,   #單耗
        con06       LIKE con_file.con06    #損耗率
                    END RECORD
 
OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
 ORDER BY sr.com01,sr.com02,sr.com03,sr.con02     #No.MOD-490398
 
    FORMAT
        PAGE HEADER
            SELECT cob02,cob021,cob04 INTO l_cob02,l_cob021,l_cob04 FROM cob_file
             WHERE cob01=sr.com01
            SELECT cna02 INTO l_cna02 FROM cna_file
            WHERE cna01=sr.com03
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<', "/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1, g_x[1]
            PRINT g_x[5]
            PRINT g_dash[1,g_len]
            PRINT COLUMN  4,g_x[9] ,sr.com01,
                  COLUMN 30,g_x[10],sr.com02,
                  COLUMN 62,g_x[11],sr.com03 CLIPPED,' ',l_cna02
            PRINT COLUMN  4,g_x[12],l_cob02,
                  COLUMN 66,g_x[13],l_cob04
            PRINT COLUMN  4,g_x[14],l_cob021
            PRINT g_x[5]
            PRINT g_x[31],g_x[32],g_x[33],g_x[37],g_x[34],g_x[35],g_x[36]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.com03
            SKIP TO TOP OF PAGE
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.con02 USING '###&',  #FUN-590118
                  COLUMN g_c[32],sr.con03,
                  COLUMN g_c[33],sr.cob02,
                  COLUMN g_c[37],sr.cob021,
                  COLUMN g_c[34],sr.con04,
                  COLUMN g_c[35],sr.con05,
                  COLUMN g_c[36],sr.con06
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,201
               THEN
              #IF g_wc[001,080] > ' ' THEN
 	      #PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
              #     IF g_wc[071,140] > ' ' THEN
 	      #PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
              #     IF g_wc[141,210] > ' ' THEN
 	      #PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
                    PRINT g_dash[1,g_len]
            END IF
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-770006 --end--
FUNCTION i200_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_com.com01 IS NULL THEN
 CALL cl_err("",-400,0)
 RETURN
    END IF
    BEGIN WORK
 
    OPEN i200_cl USING g_com.com01,g_com.com02,g_com.com03
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_com.*# 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_com.com01,SQLCA.sqlcode,0)#資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i200_show()
    IF cl_exp(0,0,g_com.comacti) THEN#審核一下
        LET g_chr=g_com.comacti
        IF g_com.comacti='Y' THEN
            LET g_com.comacti='N'
        ELSE
            LET g_com.comacti='Y'
        END IF
        UPDATE com_file                    #更改有效碼
            SET comacti=g_com.comacti
            WHERE com01=g_com.com01
               AND com02=g_com.com02 AND com03=g_com.com03   #No.MOD-490398
        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_com.com01,SQLCA.sqlcode,0) #No.TQC-660045
             CALL cl_err3("upd","com_file",g_com.com01,g_com.com03,SQLCA.sqlcode,"","",1)             #NO.TQC-660045
            LET g_com.comacti=g_chr
        END IF
        DISPLAY BY NAME g_com.comacti
    END IF
    CLOSE i200_cl
    COMMIT WORK
END FUNCTION

#FUN-BB0083---add---str
FUNCTION i200_con061_check()
#con061 的單位 con04 

   IF NOT cl_null(g_con[l_ac].con04) AND NOT cl_null(g_con[l_ac].con061) THEN
      IF cl_null(g_con_t.con061) OR cl_null(g_con04_t) OR g_con_t.con061 != g_con[l_ac].con061 
         OR g_con04_t != g_con[l_ac].con04 THEN 
         LET g_con[l_ac].con061=s_digqty(g_con[l_ac].con061,g_con[l_ac].con04)
         DISPLAY BY NAME g_con[l_ac].con061  
      END IF  
   END IF
   IF NOT cl_null(g_con[l_ac].con061) THEN
      IF g_con[l_ac].con061 < 0 THEN
         CALL cl_err(g_con[l_ac].con061,'aec-020',0)
         LET g_con[l_ac].con061 = g_con_t.con061
         RETURN FALSE
      END IF
      LET g_con_t.con061 = g_con[l_ac].con061
   END IF
   IF cl_null(g_con[l_ac].con061) THEN
      LET g_con[l_ac].con061 = 0
   END IF
   DISPLAY BY NAME g_con[l_ac].con061
   RETURN TRUE 
END FUNCTION
#FUN-BB0083---add---end
#TQC-C20434---add----
