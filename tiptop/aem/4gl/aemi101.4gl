# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aemi101.4gl
# Descriptions...: 設備位置資料維護作業
# Date & Author..: 04/07/14 by day
# Modify         : 04/09/10 By Carrier   #adjust structure fjg_file
# Modify.........: No.FUN-4C0069 04/12/13 By Smapmin 加入權限控管
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: No.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-650044 06/05/15 By Echo 憑證類的報表因報表寬度(p_zz)為0或NULL,導致報表當掉
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680072 06/08/22 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0050 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-860005 08/06/06 By mike 報表輸出方式轉為Crystal Reports
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.TQC-880014 08/08/14 By sabrina 當p_zz無設定可修改key時，執行修改後再執行新增功能程式會當掉
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-930162 09/04/02 By destiny 修改formonly字段fka02,azp02的顯示問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/16 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fjf            RECORD LIKE fjf_file.*,
    g_fjf_t          RECORD LIKE fjf_file.*,
    g_fjf01_t        LIKE fjf_file.fjf01,
    g_fjf02_t        LIKE fjf_file.fjf02,
    g_fjf02          LIKE fjf_file.fjf02,
    g_azp02          LIKE azp_file.azp02,
    g_fjf01          LIKE fjf_file.fjf01,
    g_fka02          LIKE fka_file.fka02,
    g_fjg            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variatpss)
        fjg03        LIKE fjg_file.fjg03,
        fjg04        LIKE fjg_file.fjg04,
        fka02a       LIKE fka_file.fka02
                     END RECORD,
    g_fjg_t          RECORD                 #程式變數 (舊值)
        fjg03        LIKE fjg_file.fjg03,
        fjg04        LIKE fjg_file.fjg04,
        fka02a       LIKE fka_file.fka02
                     END RECORD,
     g_wc,g_wc2,g_sql STRING,  #No.FUN-580092 HCN  
    g_rec_b          LIKE type_file.num5,                 #單身筆數                 #No.FUN-680072 SMALLINT
    l_ac             LIKE type_file.num5,                 #目前處理的ARRAY CNT      #No.FUN-680072 SMALLINT
    g_end            LIKE type_file.num5,                 #No.FUN-680072 SMALLINT 
    g_level_end      ARRAY[20] OF LIKE type_file.num5     #NO.FUN-680072 SMALLINT
DEFINE   p_row,p_col         LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp       STRING   #No.TQC-720019
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680072CHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   l_table         STRING                       #No.FUN-860005
DEFINE   g_str           STRING                       #No.FUN-860005
 
#主程式開始
MAIN
#DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0068
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AEM")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
 
    #No.FUN-860005  --BEGIN
    LET g_sql = "g_fjf02.fjf_file.fjf02,",
                "g_azp02.azp_file.azp02,",
                "p_level.type_file.num5,",
                "g_level_end.type_file.num5,",
                "fjf01.fjf_file.fjf01,",
                "fka02.fka_file.fka02,",
                "g_fjf01_a.fjf_file.fjf01"
    LET l_table = cl_prt_temptable('aemi101',g_sql) CLIPPED                                                                          
    IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?) "                                                                        
    PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
    END IF      
    #No.FUN-860005  --END                                              
    
    LET g_forupd_sql = "SELECT * FROM fjf_file WHERE fjf01 = ? AND fjf02 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW i101_w AT p_row,p_col WITH FORM "aem/42f/aemi101"
         ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
 
    CALL g_x.clear()
 
 
    CALL i101_menu()
 
    CLOSE WINDOW i101_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION i101_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_fjg.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
   INITIALIZE g_fjf.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        fjf01,fjf02,
        fjfuser,fjfgrup,fjfmodu,fjfdate,fjfacti
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
              WHEN INFIELD(fjf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_fka"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fjf01
                  NEXT FIELD fjf01
              WHEN INFIELD(fjf02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azp"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fjf02
                  NEXT FIELD fjf02
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET g_wc = g_wc clipped," AND fjfuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET g_wc = g_wc clipped," AND fjfgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET g_wc = g_wc clipped," AND fjfgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fjfuser', 'fjfgrup')
    #End:FUN-980030
 
 
    CONSTRUCT g_wc2 ON fjg03,fjg04
               FROM s_fjg[1].fjg03,s_fjg[1].fjg04
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
              WHEN INFIELD(fjg04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_fka1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fjg04
                  NEXT FIELD fjg04
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
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  fjf01,fjf02 FROM fjf_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY fjf01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fjf01,fjf02 ",
                   "  FROM fjf_file, fjg_file ",
                   " WHERE fjf01 = fjg01",
                   "   AND fjf02 = fjg02",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY fjf01"
    END IF
 
    PREPARE i101_prepare FROM g_sql
    DECLARE i101_cs                         #SCROLL CURSOR
     SCROLL CURSOR WITH HOLD FOR i101_prepare
 
    #No.TQC-720019  --Begin
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql_tmp="SELECT UNIQUE fjf01,fjf02 FROM fjf_file WHERE ",g_wc CLIPPED,
                      " INTO TEMP x "
    ELSE
        LET g_sql_tmp="SELECT UNIQUE fjf01,fjf02 FROM fjf_file,fjg_file ",
                      " WHERE fjf01=fjg01 AND fjf02=fjg02 ",
                      " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      " INTO TEMP x "
    END IF
    DROP TABLE x
    PREPARE i101_precount_x FROM g_sql_tmp
    EXECUTE i101_precount_x
    LET g_sql = " SELECT COUNT(*) FROM x "
    #No.TQC-720019  --End  
    PREPARE i101_precount FROM g_sql
    DECLARE i101_count CURSOR FOR i101_precount
 
END FUNCTION
 
#中文的MENU
FUNCTION i101_menu()
   WHILE TRUE
      CALL i101_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i101_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i101_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i101_r()
           END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i101_copy()
            END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i101_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i101_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "invalid"
           IF cl_chk_act_auth() THEN
              CALL i101_x()
           END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL i101_out()
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        #No.FUN-6B0050-------add--------str----
        WHEN "related_document"           #相關文件
         IF cl_chk_act_auth() THEN
            IF g_fjf.fjf01 IS NOT NULL THEN
               LET g_doc.column1 = "fjf01"
               LET g_doc.column2 = "fjf02"
               LET g_doc.value1 = g_fjf.fjf01
               LET g_doc.value2 = g_fjf.fjf02
               CALL cl_doc()
            END IF 
         END IF
        #No.FUN-6B0050-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i101_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_fjg.clear()
 
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_fjf.* LIKE fjf_file.*             #DEFAULT 設定
    LET g_fjf01_t = NULL
    LET g_fjf02_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fjf.fjfuser=g_user
        LET g_fjf.fjforiu = g_user #FUN-980030
        LET g_fjf.fjforig = g_grup #FUN-980030
        LET g_fjf.fjfgrup=g_grup
        LET g_fjf.fjfdate=g_today
        LET g_fjf.fjfacti='Y'              #資料有效
      #TQC-880014 begin
        LET g_before_input_done = FALSE
        CALL i101_set_entry('a')   
        LET g_before_input_done = TRUE
      #TQC-880014 end
        CALL i101_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_fjf.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_fjf.fjf01 IS NULL OR g_fjf.fjf02 IS NULL THEN  # KEY 不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO fjf_file VALUES (g_fjf.*)
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_fjf.fjf01,SQLCA.sqlcode,1)   #No.FUN-660092
           CALL cl_err3("ins","fjf_file",g_fjf.fjf01,g_fjf.fjf02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
           CONTINUE WHILE
        END IF
        SELECT fjf01,fjf02 INTO g_fjf.fjf01,g_fjf.fjf02 FROM fjf_file
         WHERE fjf01 = g_fjf.fjf01
           AND fjf02 = g_fjf.fjf02
        LET g_fjf01_t = g_fjf.fjf01        #保留舊值
        LET g_fjf02_t = g_fjf.fjf02        #保留舊值
 
        CALL g_fjg.clear()
        LET g_rec_b=0
        CALL i101_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i101_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fjf.fjf01 IS NULL OR g_fjf.fjf02 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    SELECT * INTO g_fjf.* FROM fjf_file
     WHERE fjf01=g_fjf.fjf01
       AND fjf02=g_fjf.fjf02
 
    IF g_fjf.fjfacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_fjf.fjf01,'mfg1000',0) RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fjf01_t = g_fjf.fjf01
    LET g_fjf02_t = g_fjf.fjf02
    LET g_fjf_t.* = g_fjf.*
    BEGIN WORK
    OPEN i101_cl USING g_fjf.fjf01,g_fjf.fjf02
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_fjf.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fjf.fjf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i101_cl
        ROLLBACK WORK
        RETURN
    END IF
    LET g_fjf.fjfmodu=g_user
    LET g_fjf.fjfdate=g_today
    CALL i101_show()
    WHILE TRUE
        CALL i101_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fjf.*=g_fjf_t.*
            CALL i101_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_fjf.fjf01 != g_fjf01_t OR g_fjf.fjf02 != g_fjf02_t THEN
            UPDATE fjg_file
               SET fjg01 = g_fjf.fjf01,
                   fjg02 = g_fjf.fjf02
             WHERE fjg01 = g_fjf01_t
               AND fjg02 = g_fjf02_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('fjg',SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("upd","fjg_file",g_fjf01_t,g_fjf02_t,SQLCA.sqlcode,"","fjg",1)  #No.FUN-660092
                CONTINUE WHILE
            END IF
        END IF
        UPDATE fjf_file
           SET fjf_file.* = g_fjf.*
         WHERE fjf01=g_fjf01_t AND fjf02=g_fjf02_t
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err(g_fjf.fjf01,SQLCA.sqlcode,0)   #No.FUN-660092
            CALL cl_err3("upd","fjf_file",g_fjf01_t,g_fjf02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660092
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i101_i(p_cmd)
DEFINE
    l_n	      LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    l_sw      LIKE type_file.chr1,          #No.FUN-680072CHAR(1)
    l_fka03   LIKE fka_file.fka03,
    p_cmd     LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680072 VARCHAR(1)
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INPUT BY NAME g_fjf.fjforiu,g_fjf.fjforig,
        g_fjf.fjf01,g_fjf.fjf02,
        g_fjf.fjfuser,g_fjf.fjfgrup,g_fjf.fjfmodu,
        g_fjf.fjfdate,g_fjf.fjfacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i101_set_entry(p_cmd)
            CALL i101_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD fjf01
            IF NOT cl_null(g_fjf.fjf01) THEN
               SELECT COUNT(*) INTO g_i FROM fka_file
                WHERE fka01=g_fjf.fjf01
                  AND fkaacti='Y'
               IF g_i=0 THEN
                  CALL cl_err(g_fjf.fjf01,100,0)
                  NEXT FIELD fjf01
               END IF
               IF NOT cl_null(g_fjf.fjf02) THEN
                  CALL i101_fjf01_02(g_fjf.fjf01,g_fjf.fjf02)
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err(g_fjf.fjf01,g_errno,0)
                     LET g_fjf.fjf01 = g_fjf_t.fjf01
                     DISPLAY BY NAME g_fjf.fjf01
                     NEXT FIELD fjf01
                  END IF
               END IF
            END IF
 
        AFTER FIELD fjf02
            IF NOT cl_null(g_fjf.fjf02) THEN
               SELECT COUNT(*) INTO g_i FROM fka_file
                WHERE fka03=g_fjf.fjf02
                  AND fkaacti='Y'
               IF g_i=0 THEN
                  CALL cl_err(g_fjf.fjf02,100,0)
                  NEXT FIELD fjf02
               END IF
               IF NOT cl_null(g_fjf.fjf01) THEN
                  CALL i101_fjf01_02(g_fjf.fjf01,g_fjf.fjf02)
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err(g_fjf.fjf02,g_errno,0)
                     LET g_fjf.fjf02 = g_fjf_t.fjf02
                     DISPLAY BY NAME g_fjf.fjf02
                     NEXT FIELD fjf02
                  END IF
               END IF
               IF g_fjf.fjf01 != g_fjf_t.fjf01 OR g_fjf_t.fjf01 IS NULL
               OR g_fjf.fjf02 != g_fjf_t.fjf02 OR g_fjf_t.fjf02 IS NULL THEN
                  SELECT COUNT(*) INTO g_cnt FROM fjf_file
                   WHERE fjf01 = g_fjf.fjf01
                     AND fjf02 = g_fjf.fjf02
                  IF g_cnt > 0 THEN   #資料重復
                     CALL cl_err(g_fjf.fjf01,-239,0)
                     LET g_fjf.fjf01 = g_fjf_t.fjf01
                     LET g_fjf.fjf02 = g_fjf_t.fjf02
                     DISPLAY BY NAME g_fjf.fjf01
                     DISPLAY BY NAME g_fjf.fjf02
                     NEXT FIELD fjf01
                  END IF
               END IF
           END IF
 
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                 #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(fjf01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_fka"
                   LET g_qryparam.default1 = g_fjf.fjf01
                   LET g_qryparam.default2 = g_fjf.fjf02
                   CALL cl_create_qry() RETURNING g_fjf.fjf01,g_fjf.fjf02
                   DISPLAY BY NAME g_fjf.fjf01,g_fjf.fjf02
                   NEXT FIELD fjf01
               WHEN INFIELD(fjf02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azp"
                   LET g_qryparam.default1 = g_fjf.fjf02
                   CALL cl_create_qry() RETURNING g_fjf.fjf02
                   DISPLAY BY NAME g_fjf.fjf02
                   NEXT FIELD fjf02
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
 
FUNCTION i101_fjf01_02(p_fjf01,p_fjf02)
  DEFINE p_fjf01  LIKE fjf_file.fjf01
  DEFINE p_fjf02  LIKE fjf_file.fjf02
  DEFINE l_fka02  LIKE fka_file.fka02
  DEFINE l_azp02  LIKE azp_file.azp02
 
  LET g_errno = ' '
  SELECT fka02,azp02 INTO l_fka02,l_azp02 FROM fka_file,azp_file
   WHERE fka01=p_fjf01 AND fka03=p_fjf02
     AND fka03=azp01   AND fkaacti='Y'
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     DISPLAY l_azp02 TO FORMONLY.azp02
     DISPLAY l_fka02 TO FORMONLY.fka02
  #No.TQC-930162--begin                                                                                                             
  ELSE                                                                                                                              
     DISPLAY '' TO FORMONLY.azp02                                                                                                   
     DISPLAY '' TO FORMONLY.fka02                                                                                                   
  #No.TQC-930162--end 
  END IF
END FUNCTION
 
#Query 查詢
FUNCTION i101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fjf.* TO NULL              #No.FUN-6B0050
 
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_fjg.clear()
    DISPLAY '   ' TO FORMONLY.cnt           #ATTRIBUTE(YELLOW)
    CALL i101_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_fjf.* TO NULL
        RETURN
    END IF
 
    OPEN i101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fjf.* TO NULL
    ELSE
        OPEN i101_count
        FETCH i101_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i101_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i101_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                 #處理方式        #No.FUN-680072 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i101_cs INTO g_fjf.fjf01,g_fjf.fjf02
        WHEN 'P' FETCH PREVIOUS i101_cs INTO g_fjf.fjf01,g_fjf.fjf02
        WHEN 'F' FETCH FIRST    i101_cs INTO g_fjf.fjf01,g_fjf.fjf02
        WHEN 'L' FETCH LAST     i101_cs INTO g_fjf.fjf01,g_fjf.fjf02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######fjf for prompt bug
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
             FETCH ABSOLUTE g_jump i101_cs INTO g_fjf.fjf01,g_fjf.fjf02
             LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fjf.fjf01,SQLCA.sqlcode,0)
       INITIALIZE g_fjf.* TO NULL  #TQC-6B0105
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
 
    SELECT * INTO g_fjf.* FROM fjf_file WHERE fjf01=g_fjf.fjf01 AND fjf02=g_fjf.fjf02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fjf.fjf01,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("sel","fjf_file",g_fjf.fjf01,g_fjf.fjf02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
        INITIALIZE g_fjf.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fjf.fjfuser   #FUN-4C0069
    LET g_data_group = g_fjf.fjfgrup   #FUN-4C0069
    CALL i101_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i101_show()
    LET g_fjf_t.* = g_fjf.*                #保存單頭舊值
    DISPLAY BY NAME g_fjf.fjforiu,g_fjf.fjforig,                              # 顯示單頭值
        g_fjf.fjf01,g_fjf.fjf02,
        g_fjf.fjfuser,g_fjf.fjfgrup,g_fjf.fjfmodu,
        g_fjf.fjfdate,g_fjf.fjfacti
    CALL i101_fjf01_02(g_fjf.fjf01,g_fjf.fjf02)
    CALL i101_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i101_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_fjf.fjf01 IS NULL OR g_fjf.fjf02 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    BEGIN WORK
    OPEN i101_cl USING g_fjf.fjf01,g_fjf.fjf02
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_fjf.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fjf.fjf01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i101_show()
    IF cl_exp(0,0,g_fjf.fjfacti) THEN                   #確認一下
        LET g_chr=g_fjf.fjfacti
        IF g_fjf.fjfacti='Y' THEN
            LET g_fjf.fjfacti='N'
        ELSE
            LET g_fjf.fjfacti='Y'
        END IF
        UPDATE fjf_file
           SET fjfacti=g_fjf.fjfacti, #更改有效碼
               fjfmodu=g_user,
               fjfdate=g_today
         WHERE fjf01=g_fjf.fjf01
        IF SQLCA.sqlcode OR STATUS = 100 THEN
#           CALL cl_err(g_fjf.fjf01,SQLCA.sqlcode,0)   #No.FUN-660092
            CALL cl_err3("upd","fjf_file",g_fjf.fjf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
            LET g_fjf.fjfacti=g_chr
        END IF
        SELECT fjfacti,fjfmodu,fjfdate
          INTO g_fjf.fjfacti,g_fjf.fjfmodu,g_fjf.fjfdate
          FROM fjf_file
#        WHERE fjf01=g_fjf.ff01                  #NO.TQC-930162
         WHERE fjf01=g_fjf.fjf01                 #NO.TQC-930162
        DISPLAY BY NAME g_fjf.fjfacti,g_fjf.fjfmodu,g_fjf.fjfdate
    END IF
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i101_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_fjf.fjf01 IS NULL OR g_fjf.fjf02 IS NULL THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    SELECT * INTO g_fjf.* FROM fjf_file
     WHERE fjf01=g_fjf.fjf01
       AND fjf02=g_fjf.fjf02
    IF g_fjf.fjfacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fjf.fjf01,'mfg1000',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i101_cl USING g_fjf.fjf01,g_fjf.fjf02
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_fjf.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fjf.fjf01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i101_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fjf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "fjf02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fjf.fjf01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_fjf.fjf02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM fjf_file WHERE fjf01=g_fjf.fjf01 AND fjf02=g_fjf.fjf02
       DELETE FROM fjg_file WHERE fjg01=g_fjf.fjf01 AND fjg02=g_fjf.fjf02
       CLEAR FORM
       #MOD-5A0004 add
       DROP TABLE x
#      EXECUTE i101_precount_x                  #No.TQC-720019
       PREPARE i101_precount_x2 FROM g_sql_tmp  #No.TQC-720019
       EXECUTE i101_precount_x2                 #No.TQC-720019
       #MOD-5A0004 end
       CALL g_fjg.clear()
       OPEN i101_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i101_cs
          CLOSE i101_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i101_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i101_cs
          CLOSE i101_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i101_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i101_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i101_fetch('/')
       END IF
    END IF
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i101_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680072 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重復用        #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680072 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680072 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fjf.fjf01 IS NULL
       OR g_fjf.fjf02 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_fjf.* FROM fjf_file
     WHERE fjf01=g_fjf.fjf01
       AND fjf02=g_fjf.fjf02
    IF g_fjf.fjfacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fjf.fjf01,'mfg1000',0) RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fjg03,fjg04,'' ",
                       "  FROM fjg_file  ",
                       " WHERE fjg01=? AND fjg02=? ",
                       "   AND fjg03=? ",
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_fjg WITHOUT DEFAULTS FROM s_fjg.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'
 
            BEGIN WORK
            OPEN i101_cl USING g_fjf.fjf01,g_fjf.fjf02
            IF STATUS THEN
               CALL cl_err('OPEN i101_cl:',STATUS,1)
               CLOSE i101_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i101_cl INTO g_fjf.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fjf.fjf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i101_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_fjg_t.* = g_fjg[l_ac].*  #BACKUP
               OPEN i101_b_cl USING g_fjf.fjf01,g_fjf.fjf02,
                                    g_fjg_t.fjg03
               IF STATUS THEN
                  CALL cl_err('OPEN i101_b_cl:', STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH i101_b_cl INTO g_fjg[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_fjg_t.fjg03,SQLCA.sqlcode,1)
                      LET l_lock_sw = 'Y'
                  END IF
               END IF
               CALL i101_fjg04('d')
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_fjg[l_ac].* TO NULL      #900423
            LET g_fjg_t.* = g_fjg[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fjg03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO fjg_file(fjg01,fjg02,fjg03,fjg04)
            VALUES(g_fjf.fjf01,g_fjf.fjf02,
                   g_fjg[l_ac].fjg03,g_fjg[l_ac].fjg04)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fjg[l_ac].fjg03,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("ins","fjg_file",g_fjf.fjf01,g_fjf.fjf02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        BEFORE FIELD fjg03                    #check部門/分攤類別/序號是否重復
            IF cl_null(g_fjg[l_ac].fjg03) OR g_fjg[l_ac].fjg03=0 THEN
               SELECT MAX(fjg03)+1 INTO g_fjg[l_ac].fjg03
                 FROM fjg_file
                WHERE fjg01 = g_fjf.fjf01
                  AND fjg02 = g_fjf.fjf02
               IF cl_null(g_fjg[l_ac].fjg03) THEN
                  LET g_fjg[l_ac].fjg03=1
               END IF
            END IF
 
        AFTER FIELD fjg03
            IF NOT cl_null(g_fjg[l_ac].fjg03) THEN
               IF g_fjg[l_ac].fjg03 != g_fjg_t.fjg03
                  OR g_fjg_t.fjg03 IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM fjg_file
                   WHERE fjg01 = g_fjf.fjf01
                     AND fjg02 = g_fjf.fjf02
                     AND fjg03 = g_fjg[l_ac].fjg03
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_fjg[l_ac].fjg03 = g_fjg_t.fjg03
                     NEXT FIELD fjg03
                  END IF
               END IF
            END IF
 
        AFTER FIELD fjg04
            IF NOT cl_null(g_fjg[l_ac].fjg04) THEN
               IF g_fjg[l_ac].fjg04 = g_fjf.fjf01 THEN
                  CALL cl_err(g_fjg[l_ac].fjg04,'aem-029',0)
                  NEXT FIELD fjg04
               END IF
               IF g_fjg[l_ac].fjg04 != g_fjg_t.fjg04
                  OR g_fjg_t.fjg04 IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM fjg_file
                   WHERE fjg01 = g_fjf.fjf01
                     AND fjg02 = g_fjf.fjf02
                     AND fjg04 = g_fjg[l_ac].fjg04
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_fjg[l_ac].fjg04 = g_fjg_t.fjg04
                     NEXT FIELD fjg04
                  END IF
               END IF
 
               CALL i101_fjg04('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err(g_fjg[l_ac].fjg04,g_errno,0)
                  NEXT FIELD fjg04
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fjg_t.fjg03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fjg_file
                    WHERE fjg01 = g_fjf.fjf01
                      AND fjg02 = g_fjf.fjf02
                      AND fjg03 = g_fjg_t.fjg03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fjg_t.fjg03,SQLCA.sqlcode,0)   #No.FUN-660092
                    CALL cl_err3("del","fjg_file",g_fjf.fjf01,g_fjf.fjf02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete Ok"
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fjg[l_ac].* = g_fjg_t.*
               CLOSE i101_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fjg[l_ac].fjg03,-263,1)
               LET g_fjg[l_ac].* = g_fjg_t.*
            ELSE
               UPDATE fjg_file
                  SET fjg03 = g_fjg[l_ac].fjg03,
                      fjg04 = g_fjg[l_ac].fjg04
                WHERE CURRENT OF i101_b_cl
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                  CALL cl_err(g_fjg[l_ac].fjg03,SQLCA.sqlcode,0)   #No.FUN-660092
                   CALL cl_err3("upd","fjg_file",g_fjg[l_ac].fjg03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
                   LET g_fjg[l_ac].* = g_fjg_t.*
                   CLOSE i101_b_cl
                  ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_fjg[l_ac].* = g_fjg_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fjg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i101_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i101_b_cl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i101_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(fjg03) AND l_ac > 1 THEN
                LET g_fjg[l_ac].* = g_fjg[l_ac-1].*
                NEXT FIELD fjg03
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
     ON ACTION CONTROLP
           CASE
              WHEN INFIELD(fjg04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_fka1"
                   LET g_qryparam.default1 = g_fjg[l_ac].fjg04
                   LET g_qryparam.arg1 = g_fjf.fjf02
                   CALL cl_create_qry() RETURNING g_fjg[l_ac].fjg04
                   NEXT FIELD fjg04
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end                       
    END INPUT
 
   #start FUN-5A0029
    LET g_fjf.fjfmodu = g_user
    LET g_fjf.fjfdate = g_today
    UPDATE fjf_file SET fjfmodu = g_fjf.fjfmodu,fjfdate = g_fjf.fjfdate
     WHERE fjf01 = g_fjf.fjf01 AND fjf02 = g_fjf.fjf02
    DISPLAY BY NAME g_fjf.fjfmodu,g_fjf.fjfdate
   #end FUN-5A0029
 
    CLOSE i101_b_cl
    COMMIT WORK
    CALL i101_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i101_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM fjf_file WHERE fjf01 = g_fjf.fjf01
                                AND fjf02 = g_fjf.fjf02
         INITIALIZE g_fjf.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i101_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    CONSTRUCT l_wc2 ON fjg03,fjg04
            FROM s_fjg[1].fjg03,s_fjg[1].fjg04
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
              WHEN INFIELD(fjg04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_fka1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fjg04
                  NEXT FIELD fjg04
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
    CALL i101_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i101_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    LET g_sql = "SELECT fjg03,fjg04,fka02 ",
                "  FROM fjg_file LEFT OUTER JOIN fka_file ON fjg_file.fjg04=fka_file.fka01 ",
                " WHERE fjg01 ='",g_fjf.fjf01,"'",
                "   AND fjg02 ='",g_fjf.fjf02,"'",
    #No.FUN-8B0123---Begin
                "   AND fjg04 = fka_file.fka01",  # AND ",p_wc2 CLIPPED,
                "   AND fka_file.fka03 = '",g_fjf.fjf02,"'"
    #           " ORDER BY fjg03 "
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY fjg03 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE i101_pb FROM g_sql
    DECLARE fjg_cs CURSOR FOR i101_pb
 
    #單身 ARRAY 乾洗
    CALL g_fjg.clear()
    LET g_cnt = 1
    FOREACH fjg_cs INTO g_fjg[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fjg.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i101_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fjg TO s_fjg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fjf in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fjf in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fjf in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fjf in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fjf in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fjf in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fjf in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fjf in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i101_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fjf in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fjf in 040505
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
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end                      
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i101_fjg04(p_cmd)
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680072 VARCHAR(1)
        l_fka02a    LIKE fka_file.fka02,
        l_fkaacti   LIKE fka_file.fkaacti
 
  LET g_errno = ' '
  SELECT fka02,fkaacti INTO l_fka02a,l_fkaacti
    FROM fka_file
   WHERE fka01 = g_fjg[l_ac].fjg04
     AND fka03 = g_fjf.fjf02
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aem-030'
       WHEN l_fkaacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_fjg[l_ac].fka02a = l_fka02a
     #------MOD-5A0095 START----------
     DISPLAY BY NAME g_fjg[l_ac].fka02a
     #------MOD-5A0095 END------------
  END IF
END FUNCTION
 
 
FUNCTION i101_copy()
DEFINE
    l_n             LIKE type_file.num5,                #檢查重復用        #No.FUN-680072 SMALLINT
    l_newno1        LIKE fjf_file.fjf01,
    l_newno2        LIKE fjf_file.fjf02,
    l_oldno1        LIKE fjf_file.fjf01,
    l_oldno2        LIKE fjf_file.fjf02,
    l_fka02         LIKE fka_file.fka02,
    l_fka03         LIKE fka_file.fka03,
    l_fkaacti       LIKE fka_file.fkaacti,
    l_azp02         LIKE azp_file.azp02
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fjf.fjf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_fjf.fjf02 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    LET g_before_input_done = FALSE
    CALL i101_set_entry('a')
    LET g_before_input_done = TRUE
 
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
    INPUT l_newno1,l_newno2 FROM fjf01,fjf02
 
       AFTER FIELD fjf01
            IF l_newno1 IS NULL THEN
               NEXT FIELD fjf01
            ELSE
               SELECT COUNT(*) INTO g_i FROM fka_file
                WHERE fka01=l_newno1
                  AND fkaacti='Y'
               IF g_i=0 THEN
                  CALL cl_err(l_newno1,100,0)
                  NEXT FIELD fjf01
               END IF
            END IF
 
        AFTER FIELD fjf02
            IF l_newno2 IS NULL THEN
                NEXT FIELD fjf02
            ELSE
               SELECT COUNT(*) INTO g_i FROM fka_file
                WHERE fka03=g_fjf.fjf02
                  AND fkaacti='Y'
               IF g_i=0 THEN
                  CALL cl_err(g_fjf.fjf02,100,0)
                  NEXT FIELD fjf02
               END IF
            END IF
            CALL i101_fjf01_02(l_newno1,l_newno2)
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err(l_newno1,g_errno,0)
               NEXT FIELD fjf01
            END IF
            SELECT COUNT(*) INTO g_cnt FROM fjf_file
             WHERE fjf01 = l_newno1
               AND fjf02 = l_newno2
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno1,-239,0)
               NEXT FIELD fjf01
            END IF
 
        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(fjf01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_fka"
                   LET g_qryparam.default1 = l_newno1
                   LET g_qryparam.default2 = l_newno2
                   CALL cl_create_qry() RETURNING l_newno1,l_newno2
                   DISPLAY l_newno1,l_newno2 TO fjf01,fjf02
                   NEXT FIELD fjf01
               WHEN INFIELD(fjf02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azp"
                   LET g_qryparam.default1 = l_newno2
                   CALL cl_create_qry() RETURNING l_newno2
                   DISPLAY l_newno2 TO fjf02
                   NEXT FIELD fjf02
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
    IF INT_FLAG OR l_newno1 IS NULL OR l_newno2 IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM fjf_file         #單頭復制
     WHERE fjf01=g_fjf.fjf01
       AND fjf02=g_fjf.fjf02
      INTO TEMP y
    UPDATE y
        SET fjf01=l_newno1,    #新的鍵值
            fjf02=l_newno2,    #新的鍵值
            fjfuser=g_user,    #資料所有者
            fjfgrup=g_grup,    #資料所有者所屬群
            fjfdate = g_today,
            fjfacti = 'Y'
    INSERT INTO fjf_file SELECT * FROM y
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_newno1,SQLCA.sqlcode,0) #No.FUN-660092
       CALL cl_err3("ins","fjf_file",g_fjf.fjf01,g_fjf.fjf02,SQLCA.sqlcode,"","",1) #No.FUN-660092
    END IF
 
    DROP TABLE x
    SELECT * FROM fjg_file         #單身復制
     WHERE fjg01=g_fjf.fjf01
       AND fjg02=g_fjf.fjf02
      INTO TEMP x
 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fjf.fjf01,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660092
        RETURN
    END IF
    UPDATE x SET fjg01=l_newno1,
                 fjg02=l_newno2
    INSERT INTO fjg_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno1,SQLCA.sqlcode,0)   #No.FUN-660092
        CALL cl_err3("ins","fjg_file",l_newno1,l_newno2,SQLCA.sqlcode,"","",1)  #No.FUN-660092
        RETURN
    END IF
 
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
        ATTRIBUTE(REVERSE)
     LET l_oldno1 = g_fjf.fjf01
     LET l_oldno2 = g_fjf.fjf02
    SELECT fjf_file.* INTO g_fjf.* FROM fjf_file
      WHERE fjf01 = l_newno1
        AND fjf02 = l_newno2
     CALL i101_u()
     CALL i101_b()
    #FUN-C30027---begin
    #SELECT fjf_file.* INTO g_fjf.* FROM fjf_file
    #  WHERE fjf01 = l_oldno1
    #    AND fjf02 = l_oldno2
    # CALL i101_show()
    #FUN-C30027---end
 
END FUNCTION
 
FUNCTION i101_out()
DEFINE
#       l_time    LIKE type_file.chr8	    #No.FUN-6A0068
    sr              RECORD
        fjf02       LIKE fjf_file.fjf02,
        azp02       LIKE azp_file.azp02,
        fjf01       LIKE fjf_file.fjf01,
        fka02       LIKE fka_file.fka02,
        fjg04       LIKE fjg_file.fjg04,
        fka02a      LIKE fka_file.fka02
       END RECORD,
    sr_null         RECORD
        fjf02       LIKE fjf_file.fjf02,
        azp02       LIKE azp_file.azp02,
        fjf01       LIKE fjf_file.fjf01,
        fka02       LIKE fka_file.fka02,
        fjg04       LIKE fjg_file.fjg04,
        fka02a      LIKE fka_file.fka02
       END RECORD,
    p_level         LIKE type_file.num5,         #No.FUN-680072SMALLINT
    l_name          LIKE type_file.chr20,        #No.FUN-680072 VARCHAR(20)
    l_sql           LIKE type_file.chr1000,      #No.FUN-680072CHAR(500)
    l_count         LIKE type_file.num5,         #No.FUN-680072SMALLINT
    l_za05          LIKE type_file.chr1000       #No.FUN-680072 VARCHAR(40)
 
    CALL cl_del_data(l_table)  #No.FUN-860005
 
#   IF g_wc IS NULL THEN
#      CALL cl_err('','9057',0) RETURN
#   END IF
    IF cl_null(g_wc) AND NOT cl_null(g_fjf.fjf01) AND NOT cl_null(g_fjf.fjf02) THEN
       LET g_wc = " fjf01 = '",g_fjf.fjf01,"' AND fjf02 = '",g_fjf.fjf02,"' "
    END IF
    IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
    CALL cl_wait()
#    CALL cl_outnam('aemi101') RETURNING l_name                   #FUN-860005 MARK
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR        #TQC-650044
 
    LET g_sql="SELECT UNIQUE fjf02,azp02 FROM fjf_file",
" LEFT OUTER JOIN azp_file ON fjf_file.fjf02=azp_file.azp01 ",
"WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
PREPARE i101_p1 FROM g_sql
    DECLARE i101_co CURSOR FOR i101_p1
    INITIALIZE sr_null.* TO NULL
 
    #START REPORT i101_rep TO l_name   #No.FUN-860005
    LET g_pageno = 0
    LET p_level = 0
 
    FOREACH i101_co INTO sr.fjf02,sr.azp02
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)  
            EXIT FOREACH
        END IF
        LET g_fjf02= sr.fjf02
        LET g_azp02= sr.azp02
 
        #OUTPUT TO REPORT i101_rep(p_level,sr.*)         #No.FUN-860005
        #OUTPUT TO REPORT i101_rep(p_level+1,sr_null.*)  #No.FUN-860005 
        LET g_end = 0
        CALL i101_bom(0,sr.fjf02,'')
        LET g_end = 1	
    END FOREACH
 
    #FINISH REPORT i101_rep   #No.FUN-860005 
 
    CLOSE i101_co
    ERROR ""
    #No.FUN-860005  --BEGIN
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
    IF g_zz05 ="Y" THEN 
       CALL cl_wcchp(g_wc,'fjf01,fjf02,                                                                                                                
                           fjfuser,fjfgrup,fjfmodu,fjfdate,fjfacti')
       RETURNING g_wc
    END IF
    LET g_str = ''
    LET g_str = g_wc,';',g_towhom
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                                                              
    CALL cl_prt_cs3('aemi101','aemi101',g_sql,g_str)
    #No.FUN-860005  --END  
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222  #No.FUN-6A0068
END FUNCTION
 
FUNCTION i101_bom(p_level,p_key1,p_key2)
        DEFINE  p_level LIKE type_file.num5,              #No.FUN-680072SMALLINT
                p_key1	LIKE fjf_file.fjf02,
                p_key2	LIKE fjf_file.fjf01,
                l_ac,i,j    LIKE type_file.num5,          #No.FUN-680072 SMALLINT
                l_time      LIKE type_file.num5,          #No.FUN-680072SMALLINT
                l_count     LIKE type_file.num5,          #No.FUN-680072SMALLINT
                l_sql       LIKE type_file.chr1000,       #No.FUN-680072CHAR(1000)
                sr DYNAMIC ARRAY OF RECORD
                      fjf02       LIKE fjf_file.fjf02,
                      azp02       LIKE azp_file.azp02,
                      fjf01       LIKE fjf_file.fjf01,
                      fka02       LIKE fka_file.fka02,
                      fjg04       LIKE fjg_file.fjg04,
                      fka02a      LIKE fka_file.fka02
                END RECORD
        INITIALIZE sr[600].* TO NULL
        IF p_key2 <> " 1=1" THEN
          LET l_sql="SELECT fjf02,azp02,fjf01,fka02,",
                    "       fjg04,'' ",
                    "  FROM fjg_file,fjf_file LEFT OUTER JOIN fka_file ON fjf_file.fjf01=fka_file.fka01 AND fjf_file.fjf02=fka_file.fka03 LEFT OUTER JOIN azp_file ON fjf_file.fjf02=azp_file.azp01",
                    " WHERE fjf01=fjg01 AND fjf02=fjg02 ",
                    "   AND fjf01= '",p_key2,"'",
                    "   AND fjf02= '",p_key1,"'",
                    "   AND",g_wc CLIPPED," AND ",g_wc2 CLIPPED
        ELSE
          LET l_sql="SELECT fjf02,azp02,fjf01,fka02",
                    "  FROM fjf_file LEFT OUTER JOIN fka_file ON fjf_file.fjf01=fka_file.fka01 AND fjf_file.fjf02=fka_file.fka03 LEFT OUTER JOIN azp_file ON fjf_file.fjf02=azp_file.azp01",
            "   WHERE fjf02= '",p_key1,"'",
            "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
      END IF
      PREPARE bom_prepare FROM l_sql
        IF SQLCA.sqlcode THEN
          CALL cl_err('Prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
        END IF
       	DECLARE bom_cs CURSOR FOR bom_prepare
        LET p_level = p_level + 1
        IF p_level > 20 THEN RETURN END IF
        LET l_count = 1
        FOREACH bom_cs INTO sr[l_count].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('bom_cs',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           IF sr[l_count].fjg04 IS NOT NULL THEN
              SELECT fka02 INTO sr[l_count].fka02a FROM fka_file
                   WHERE fka01=sr[l_count].fjg04
                     AND fka03=sr[l_count].fjf02
           END IF
           LET	l_count = l_count + 1
	END FOREACH			
        LET l_count = l_count - 1
        LET g_level_end[p_level] = 0
	FOR i = 1 TO l_count
          IF l_count = i THEN LET g_level_end[p_level] = 1 END IF
 
          #No.FUN-860005  --BEGIN
          #OUTPUT TO REPORT i101_rep(p_level,sr[i].*) 
          IF p_level <> 0 THEN
             IF p_level = 1 THEN                                                                                                      
                LET g_fjf01 = sr[i].fjf01                                                                                                   
                LET g_fka02 = sr[i].fka02                                                                                                   
             ELSE                                                                                                                        
                LET g_fjf01 = sr[i].fjg04                                                                                                   
                LET g_fka02 = sr[i].fka02a                                                                                                  
             END IF
          END IF 
          #No.FUN-860005  --END
                
          IF sr[i].fjg04 IS NOT NULL THEN
             SELECT fjf01 FROM fjf_file
              WHERE fjf01 = sr[i].fjg04
                AND fjf02 = sr[i].fjf02
             IF status != NOTFOUND THEN
                #No.FUN-860005  --BEGIN
                #OUTPUT TO REPORT i101_rep(p_level+1,sr[600].*)    
                EXECUTE insert_prep USING g_fjf02,g_azp02,p_level, 
                                          g_level_end[p_level],                                                     
                                          g_fjf01,g_fka02,sr[i].fjg04
                #No.FUN-860005  --END  
                CALL i101_bom(p_level,sr[i].fjf02,sr[i].fjg04)
             END IF
          ELSE
             #No.FUN-860005  --BEGIN
             #OUTPUT TO REPORT i101_rep(p_level+1,sr[600].*)     
             EXECUTE insert_prep USING g_fjf02,g_azp02,p_level,                                                                  
                                          g_level_end[p_level],                                                                     
                                          g_fjf01,g_fka02,sr[i].fjf01 
             #No.FUN-860005  --END   
             CALL i101_bom(p_level,sr[i].fjf02,sr[i].fjf01)
          END IF
	END FOR
END FUNCTION
 		
#No.FUN-860005  --BEGIN 
{	
REPORT i101_rep(sr)
 DEFINE l_last_sw       LIKE type_file.chr1,         #No.FUN-680072CHAR(1)
       sr               RECORD
                p_level     LIKE type_file.num5,     #No.FUN-680072SMALLINT
                fjf02       LIKE fjf_file.fjf02,
                azp02       LIKE azp_file.azp02,
                fjf01       LIKE fjf_file.fjf01,
                fka02       LIKE fka_file.fka02,
                fjg04       LIKE fjg_file.fjg04,
                fka02a      LIKE fka_file.fka02
	END RECORD ,
	i      LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
     #TQC-650044
     #LET g_pageno = g_pageno + 1
     #LET pageno_total = PAGENO USING '<<<', "/pageno"
     #PRINT g_head CLIPPED, pageno_total
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1, g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      #PRINT g_x[5]
     #END TQC-650044
      PRINT g_x[5]
      LET l_last_sw = 'n'
      PRINT g_fjf02 CLIPPED,'  (',g_azp02,')'
	
   ON EVERY ROW
 
   IF sr.p_level = 0 THEN
	SKIP TO TOP OF PAGE
   ELSE
        FOR i = 1 to (sr.p_level - 1)
 	IF g_level_end[i] THEN
 		PRINT g_x[5];
                ELSE
 		PRINT COLUMN (4 * i ),g_x[31] CLIPPED;
 	END IF
	END FOR
        LET i = sr.p_level
        IF sr.p_level = 1 THEN
           LET g_fjf01 = sr.fjf01
           LET g_fka02 = sr.fka02
        ELSE
           LET g_fjf01 = sr.fjg04
           LET g_fka02 = sr.fka02a
        END IF
        IF cl_null(g_fjf01) THEN
        		PRINT COLUMN ( sr.p_level * 4 ) CLIPPED,g_x[31]
        ELSE IF g_level_end[i]  THEN
                PRINT COLUMN ( sr.p_level * 4) CLIPPED,g_x[32] CLIPPED;
             ELSE
                PRINT COLUMN ( sr.p_level * 4) CLIPPED,g_x[33] CLIPPED;
             END IF
             PRINT g_fjf01, '  (',g_fka02 CLIPPED ,') '
             IF g_level_end[i]  THEN
                FOR i = 1 to (sr.p_level - 1)
                    IF g_level_end[i] THEN
                       PRINT g_x[5] ;
                    ELSE
                       PRINT COLUMN (4 * i ),g_x[31] CLIPPED;
                    END IF
                END FOR
                PRINT
             END IF
        END IF
   END IF
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
   IF g_end = 0 OR l_last_sw = 'n' THEN
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
   ELSE
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
   END IF
END REPORT
}
#No.FUN-860005  --END
 
FUNCTION i101_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("fjf01,fjf02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i101_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("fjf01,fjf02",FALSE)
       END IF
   END IF
END FUNCTION
#Patch....NO.MOD-5A0095 <001> #
#FUN-870144
