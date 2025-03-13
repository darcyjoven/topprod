# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apsi330.4gl
# Descriptions...: APS工模具群組維護作業
# Date & Author..: FUN-880102  08/09/26 By DUKE
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: FUN-B50004 11/05/05 By Abby---GP5.25 追版---str---
# Modify.........: TQC-9A0005 09/10/02 By Mandy 移除&include "qry_string.4gl"
# Modify.........: FUN-B50004 11/05/05 By Abby---GP5.25 追版---end---
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_vnk    RECORD LIKE vnk_file.*,         #倉庫別資料檔
    g_vnk_t  RECORD LIKE vnk_file.*,         #倉庫別資料檔(舊值)
    g_vnk_o  RECORD LIKE vnk_file.*,         #倉庫別資料檔(舊值)
    g_vnk01_t       LIKE vnk_file.vnk01,     #倉庫別(舊值)
    g_vnl           DYNAMIC ARRAY OF RECORD  #APS工模具群組明細
        vnl02       LIKE vnl_file.vnl02,   
        fea02       LIKE fea_file.fea02,   
        fea031      LIKE fea_file.fea031   
                    END RECORD,
    g_vnl_t         RECORD                 #APS工模具群組明細
        vnl02       LIKE vnl_file.vnl02,   
        fea02       LIKE fea_file.fea02,   
        fea031      LIKE fea_file.fea031   
                    END RECORD,
    g_wc,g_sql,g_wc2    string,                #No.FUN-580092 HCN
    g_argv1             LIKE vnk_file.vnk01,   #倉庫別
    g_argv2             LIKE type_file.chr1,   #是否具有新增功能(ASM#41)  #No.FUN-690026 VARCHAR(1)
    g_rec_b             LIKE type_file.num5,   #單身筆數  #No.FUN-690026 SMALLINT
    g_flag              LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
    l_ac                LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    g_yn                LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
    g_mrp_yn            LIKE type_file.chr1,   #No.TQC-620004 add  #No.FUN-690026 VARCHAR(1)
    g_num_args          LIKE type_file.num5    #NUM_ARGS() #BugNo:6598  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cmd               LIKE type_file.chr1000 #FUN-680048 
DEFINE g_flag1             LIKE type_file.chr1    #FUN-680048 
DEFINE g_azp03             LIKE azp_file.azp03    #No.TQC-710110
DEFINE g_db1               LIKE type_file.chr21   #No.TQC-710110
DEFINE g_bookno1           LIKE aza_file.aza81    #No.FUN-730033
DEFINE g_bookno2           LIKE aza_file.aza82    #No.FUN-730033
DEFINE g_dbsm              LIKE type_file.chr21   #No.FUN-730033
DEFINE g_db_type           LIKE type_file.chr3    #No.FUN-730033
 
#主程式開始
MAIN
#     DEFINEl_tvnl LIKE type_file.chr8            #No.FUN-6A0074
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 

   INITIALIZE g_vnk_t.* TO NULL
   INITIALIZE g_vnk.* TO NULL
   LET p_row = 10 LET p_col = 12
 
   OPEN WINDOW i330_w AT p_row,p_col           #顯示畫面
     WITH FORM "aps/42f/apsi330"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-880102 
   
   CALL cl_ui_init()
 
   LET g_forupd_sql = 
          "SELECT * FROM vnk_file WHERE vnk01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i330_cl CURSOR FROM g_forupd_sql 
   LET g_flag1 = 'N'  #FUN-680048
   CALL i330_menu()
   CLOSE WINDOW i330_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION i330_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    IF cl_null(g_argv1) OR g_argv1 IS NULL THEN
       CLEAR FORM                             #清除畫面
       CALL g_vnl.clear()
       CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
       CONSTRUCT BY NAME g_wc ON 
                    vnk01#螢幕上取單頭條件
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(vnk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_vnk01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO vnk01
                  NEXT FIELD vnk01
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       
       IF INT_FLAG THEN RETURN END IF
       CALL g_vnl.clear()
       CONSTRUCT g_wc2 ON vnl02  #螢幕上取單身條件
          FROM s_vnl[1].vnl02
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(vnl02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.form = "q_fea01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO vnl02
                 NEXT FIELD vnl02
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
    ELSE
      LET g_wc = " vnk01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
    END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  vnk01 FROM vnk_file ",
                  " WHERE ", g_wc CLIPPED
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE vnk_file. vnk01 ",
                  "  FROM vnk_file, vnl_file ",
                  " WHERE vnk01 = vnl01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
    END IF
    PREPARE i330_prepare FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
    END IF
    DECLARE i330_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i330_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM vnk_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(distinct vnk01)", 
                  " FROM vnk_file,vnl_file WHERE ",
                  " vnk01=vnl01 AND ",g_wc CLIPPED,
                  " AND ",g_wc2 CLIPPED 
    END IF
    PREPARE i330_precount FROM g_sql
    DECLARE i330_count CURSOR FOR i330_precount
END FUNCTION
 
FUNCTION i330_menu()
 
   WHILE TRUE
      CALL i330_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i330_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i330_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i330_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i330_u()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i330_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vnl),'','')
            END IF
         #No.FUN-680046-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_vnk.vnk01 IS NOT NULL THEN
                 LET g_doc.column1 = "vnk01"
                 LET g_doc.value1 = g_vnk.vnk01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-680046-------add--------end----
      END CASE
   END WHILE  
END FUNCTION
 
 
#Add  輸入
FUNCTION i330_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
 
    #若非由MENU進入本程式,則無新增之功能
    IF g_argv2 != ' ' THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
   CALL g_vnl.clear()
    INITIALIZE g_vnk.* LIKE vnk_file.*
    LET g_vnk01_t = NULL
    LET g_vnk_t.*=g_vnk.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i330_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_vnk.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_vnl.clear()
            EXIT WHILE
        END IF
        IF g_vnk.vnk01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO vnk_file VALUES(g_vnk.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","vnk_file",g_vnk.vnk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            CONTINUE WHILE
        END IF
        SELECT vnk01 INTO g_vnk.vnk01 FROM vnk_file
            WHERE vnk01 = g_vnk.vnk01
        LET g_vnk01_t = g_vnk.vnk01        #保留舊值
        LET g_vnk_t.* = g_vnk.*
        CALL g_vnl.clear()
        LET g_rec_b =0
        CALL i330_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i330_i(p_cmd)
    DEFINE
        l_utvnl         LIKE type_file.chr1,   #檢查是否第一次更改  #No.FUN-690026 VARCHAR(1)
        l_dir1          LIKE type_file.chr1,   #CURSOR JUMP DIRECTION  #No.FUN-690026 VARCHAR(1)
        l_dir2          LIKE type_file.chr1,   #CURSOR JUMP DIRECTION  #No.FUN-690026 VARCHAR(1)
        l_sw            LIKE type_file.chr1,   #檢查必要欄位是否空白  #No.FUN-690026 VARCHAR(1)
        p_cmd           LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
    LET l_utvnl = 'Y'
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030 
    INPUT BY NAME g_vnk.vnk01,g_vnk.vnk02, g_vnk.vnk03
                  WITHOUT DEFAULTS 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i330_set_entry(p_cmd)
            CALL i330_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD vnk01
            IF p_cmd = "a" THEN       # 若輸入KEY值不可重複
                SELECT count(*) INTO l_n FROM vnk_file
                    WHERE vnk01 = g_vnk.vnk01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_vnk.vnk01,-239,0)
                    LET g_vnk.vnk01 = g_vnk01_t
                    DISPLAY BY NAME g_vnk.vnk01 
                    NEXT FIELD vnk01
                END IF
            END IF
 
 
        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF l_sw = 'Y' THEN 
               CALL cl_err('','9033',0)
               LET l_sw = 'N'
               NEXT FIELD vnk01
            END IF
 
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
   
 
FUNCTION i330_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i330_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
   CALL g_vnl.clear()
        RETURN
    END IF
    MESSAGE "Waiting...." 
    OPEN i330_count
    FETCH i330_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN i330_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnk.vnk01,SQLCA.sqlcode,0)
        INITIALIZE g_vnk.* TO NULL
    ELSE
        CALL i330_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i330_fetch(p_flag)
    DEFINE
        p_flag          LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i330_cs INTO g_vnk.vnk01
        WHEN 'P' FETCH PREVIOUS i330_cs INTO g_vnk.vnk01
        WHEN 'F' FETCH FIRST    i330_cs INTO g_vnk.vnk01
        WHEN 'L' FETCH LAST     i330_cs INTO g_vnk.vnk01
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
            FETCH ABSOLUTE g_jump i330_cs INTO g_vnk.vnk01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_vnk.* TO NULL  #TQC-6B0105
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
 
SELECT * INTO g_vnk.* FROM vnk_file            
WHERE vnk01 = g_vnk.vnk01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vnk_file",g_vnk.vnk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        CALL i330_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i330_show()
    LET g_vnk_t.* = g_vnk.*
    DISPLAY BY NAME g_vnk.vnk01,g_vnk.vnk02,g_vnk.vnk03
    CALL i330_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i330_u()
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無更新之功能
    IF g_argv2 != ' ' THEN RETURN END IF
    IF g_vnk.vnk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_vnk.* FROM vnk_file WHERE vnk01=g_vnk.vnk01
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_vnk01_t = g_vnk.vnk01
    LET g_vnk_t.* = g_vnk.*
    LET g_vnk_o.* = g_vnk.*
    BEGIN WORK
 
    OPEN i330_cl USING g_vnk.vnk01
    IF STATUS THEN
       CALL cl_err("OPEN i330_cl:", STATUS, 1)
       CLOSE i330_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i330_cl INTO g_vnk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnk.vnk01,SQLCA.sqlcode,0)
        CLOSE i330_cl ROLLBACK WORK RETURN
    END IF
    CALL i330_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i330_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_vnk.*=g_vnk_t.*
            CALL i330_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE vnk_file SET vnk_file.* = g_vnk.*    # 更新DB
            WHERE vnk01 = g_vnk_t.vnk01             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","vnk_file",g_vnk_t.vnk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            CONTINUE WHILE
        END IF
 
        CALL i330_show()
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
 
FUNCTION i330_x()
    DEFINE
        l_buf LIKE ze_file.ze03,     #儲存下游檔案的名稱 #No.FUN-690026 VARCHAR(80)
        l_chr LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_vnk.vnk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i330_cl USING g_vnk.vnk01
    IF STATUS THEN
       CALL cl_err("OPEN i330_cl:", STATUS, 1)
       CLOSE i330_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i330_cl INTO g_vnk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vnk.vnk01,SQLCA.sqlcode,0)
        CLOSE i330_cl ROLLBACK WORK RETURN
    END IF
    CALL i330_show()
    #在刪除前先檢查其下游檔案vnl_file是否尚在使用中
    LET l_buf = NULL
    SELECT COUNT(*) INTO g_i FROM vnl_file WHERE vnl01 = g_vnk.vnk01
    IF g_i > 0 THEN 
       CALL cl_getmsg('mfg1010',g_lang) RETURNING g_msg
       LET l_buf = g_msg
    END IF
    CLOSE i330_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i330_r()
    DEFINE l_chr LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_buf LIKE ze_file.ze03       #儲存下游檔案的名稱 #No.FUN-690026 VARCHAR(80)
 
    IF NOT cl_delete() THEN
       RETURN 
    END IF
    INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
    LET g_doc.column1 = "vnk01"         #No.FUN-9B0098 10/02/24
    LET g_doc.value1 = g_vnk.vnk01      #No.FUN-9B0098 10/02/24
    CALL cl_del_doc()                            #No.FUN-9B0098 10/02/24
 
    IF s_shut(0) THEN RETURN END IF
    IF g_vnk.vnk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i330_cl USING g_vnk.vnk01
    IF STATUS THEN
       CALL cl_err("OPEN i330_cl:", STATUS, 1)
       CLOSE i330_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i330_cl INTO g_vnk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_vnk.vnk01,SQLCA.sqlcode,0)
       CLOSE i330_cl ROLLBACK WORK RETURN
    END IF
    CALL i330_show()
    DELETE FROM vnk_file WHERE vnk01 = g_vnk.vnk01
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("del","vnk_file",g_vnk.vnk01,"",SQLCA.sqlcode,"","",1)
    ELSE
       DELETE FROM vnl_file WHERE vnl01=g_vnk.vnk01
       CLEAR FORM
       CALL g_vnl.clear()
       OPEN i330_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i330_cs
          CLOSE i330_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH i330_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i330_cs
          CLOSE i330_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i330_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i330_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i330_fetch('/')
       END IF
    END IF
    LET g_msg=TIME
    CLOSE i330_cl
    CALL cl_err('','asf-079',0)
    COMMIT WORK
END FUNCTION
 
 
#單身
FUNCTION i330_b()
DEFINE
    l_buf           LIKE ze_file.ze03,     #儲存尚在使用中之下游檔案之檔名 #No.FUN-690026 VARCHAR(80)
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用  #No.FUN-690026 SMALLINT
    l_cnt           LIKE type_file.num5,   #No.MOD-790105 add
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態  #No.FUN-690026 VARCHAR(1)
    l_bcur          LIKE type_file.chr1,   #'1':表存放位置有值,'2':則為NULL  #No.FUN-690026 VARCHAR(1)
    l_vnl02         LIKE vnl_file.vnl02,
    l_dir1          LIKE type_file.chr1,   #next field flag    #No.FUN-690026 VARCHAR(1)
    l_dir2          LIKE type_file.chr1,   #next field flag    #No.FUN-690026 VARCHAR(1)
    l_dir3          LIKE type_file.chr1,   #next field flag    #No.FUN-690026 VARCHAR(1)
    l_chr           LIKE type_file.chr1,   #MOD-850215 add     #新增狀態
    l_allow_insert  LIKE type_file.num5,   #可新增否  #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否  #No.FUN-690026 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_vnk.vnk01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_vnk.* FROM vnk_file WHERE vnk01=g_vnk.vnk01
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT vnl02,fea02,fea031 ",     #FUN-880102
                       "   FROM vnl_file,fea_file  ",
                       "   WHERE vnl02=fea01 AND vnl02 = ? ",
                       "    AND vnl01 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i330_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
     LET l_allow_insert = cl_detail_input_auth("insert")
     LET l_allow_delete = cl_detail_input_auth("delete")
 
     INPUT ARRAY g_vnl WITHOUT DEFAULTS FROM s_vnl.*
           ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           LET g_before_input_done = FALSE
            CALL i330_set_entry_b('')     #MOD-4A0269
            CALL i330_set_no_entry_b('')  #MOD-4A0269
           LET g_before_input_done = TRUE
 
        BEFORE ROW
           LET p_cmd=''
           LET l_chr=''                   #MOD-850215 add
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           IF g_rec_b>=l_ac THEN
              LET p_cmd='u'
              LET g_vnl_t.* = g_vnl[l_ac].*  #BACKUP
              IF g_vnl_t.vnl02 IS NOT NULL THEN
                 OPEN i330_bcl USING g_vnl_t.vnl02,g_vnk.vnk01
                 IF STATUS THEN
                    CALL cl_err("OPEN i330_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH i330_bcl INTO g_vnl[l_ac].* 
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_vnl_t.vnl02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    ELSE
                       LET g_vnl_t.*=g_vnl[l_ac].*
                    END IF
                    LET l_bcur = '1'
                 END IF
               CALL i330_set_entry_b('u')      #MOD-4A0269
               CALL i330_set_no_entry_b('u')   #MOD-4A0269
               CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF
           END IF
 
        AFTER INSERT
           DISPLAY "AFTER INSERT"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           LET l_chr='' #MOD-850215 add
            INSERT INTO vnl_file(vnl01,vnl02)
                VALUES(g_vnk.vnk01,g_vnl[l_ac].vnl02)
            IF (SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0) THEN # AND   #MOD-570193
              CALL cl_err3("ins","vnl_file",g_vnl[l_ac].vnl02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              CANCEL INSERT
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_vnl[l_ac].* TO NULL      #900423
            LET g_vnl[l_ac].vnl02 = ' '
            LET g_vnl[l_ac].fea02 = ' '
            LET g_vnl[l_ac].fea031 = ' '
            LET g_vnl_t.* = g_vnl[l_ac].*         #新輸入資料
             CALL i330_set_entry_b('u')       #MOD-4A0269
             CALL i330_set_no_entry_b('u')    #MOD-4A0269
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD vnl02
 
        BEFORE DELETE#是否取消單身
            IF g_vnl_t.vnl02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) then
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM vnl_file
                 WHERE vnl01 = g_vnk.vnk01 AND vnl02 = g_vnl[l_ac].vnl02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","vnl_file",g_vnk.vnk01,g_vnl[l_ac].vnl02,SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b = g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
 
        AFTER FIELD vnl02
            DISPLAY BY NAME g_vnl[l_ac].vnl02    
            IF cl_null(g_vnl[l_ac].vnl02) THEN NEXT FIELD vnl02 END IF
            IF NOT cl_null(g_vnl[l_ac].vnl02) THEN
               SELECT fea02,fea031 INTO g_vnl[l_ac].fea02,g_vnl[l_ac].fea031
                 FROM fea_file
                 WHERE fea01=g_vnl[l_ac].vnl02
               IF cl_null(g_vnl[l_ac].fea02) THEN 
                  CALL cl_err('','aps-730',1) 
                  NEXT FIELD vnl02 
               END IF     
            END IF                        
            IF p_cmd='a' THEN
               LET l_chr='a'                              
            END IF
            IF p_cmd='a' AND (NOT cl_null(g_vnl[l_ac].vnl02)) THEN
               SELECT count(*) INTO l_n
                 FROM vnl_file
                  WHERE vnl01 = g_vnk.vnk01 AND vnl02 = g_vnl[l_ac].vnl02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_vnl[l_ac].vnl02 = g_vnl_t.vnl02
                  NEXT FIELD vnl02
               END IF
            END IF
        
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_vnl[l_ac].* = g_vnl_t.*
               CLOSE i330_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_vnl[l_ac].vnl02,-263,1)
                LET g_vnl[l_ac].* = g_vnl_t.*
            ELSE
                IF g_vnl[l_ac].vnl02 IS NULL THEN
                    LET g_vnl[l_ac].vnl02 = ' '
                END IF
                UPDATE vnl_file SET
                       vnl02  = g_vnl[l_ac].vnl02
                       WHERE vnl02=g_vnl_t.vnl02 
                         AND vnl01=g_vnk.vnk01 
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","vnl_file",g_vnk.vnk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                    LET g_vnl[l_ac].* = g_vnl_t.*
                END IF 
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd ='u' THEN
                  LET g_vnl[l_ac].* = g_vnl_t.*
               END IF
               CLOSE i330_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #MOD-850215-begin-add
           #因vnl02空白一直無法走after insert,insert段只好放到after row 
           IF l_chr='a' THEN
              LET l_chr=''
              INSERT INTO vnl_file(vnl01,vnl02)  
                  VALUES(g_vnk.vnk01,g_vnl[l_ac].vnl02)
             IF (SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0) THEN # AND   #MOD-570193
                CALL cl_err3("ins","vnl_file",g_vnl[l_ac].vnl02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                CLOSE i330_bcl
                ROLLBACK WORK
                EXIT INPUT
             ELSE
                DISPLAY 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                CLOSE i330_bcl
                CALL i330_b_fill(" 1=1")
             END IF
           ELSE
           #MOD-850215-end-add
            CLOSE i330_bcl
            COMMIT WORK
           END IF #MOD-850215 add
 
 
        #FUN-880102 MARK
        #ON ACTION CONTROLO                        #沿用所有欄位
        #    IF INFIELD(vnl02) AND l_ac > 1 THEN
        #        LET g_vnl[l_ac].* = g_vnl[l_ac-1].*
        #        DISPLAY g_vnl[l_ac].* TO s_vnl[l_ac].*
        #        NEXT FIELD vnl02
        #    END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(vnl02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fea01"
                  LET g_qryparam.default1 = g_vnl[l_ac].vnl02
                  CALL cl_create_qry() RETURNING g_vnl[l_ac].vnl02
                  DISPLAY BY NAME g_vnl[l_ac].vnl02 
                  NEXT FIELD vnl02
             OTHERWISE EXIT CASE
          END CASE
 
 
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
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
        
        END INPUT
    CLOSE i330_bcl
    COMMIT WORK
    CALL i330_delHeader()     #CHI-C30002 add
END FUNCTION
   
#CHI-C30002 -------- add -------- begin
FUNCTION i330_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM vnk_file WHERE vnk01 = g_vnk.vnk01
         INITIALIZE g_vnk.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i330_delall()
    SELECT COUNT(*) INTO g_cnt FROM vnl_file
        WHERE vnl01 = g_vnk.vnk01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM vnk_file WHERE vnk01 = g_vnk.vnk01
    END IF
END FUNCTION
 
FUNCTION i330_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CONSTRUCT l_wc ON vnl02  #螢幕上取單身條件
       FROM s_vnl[1].vnl02
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
    CALL i330_b_fill(l_wc)
END FUNCTION
 
FUNCTION i330_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(400)
 
    LET g_sql =
       "SELECT vnl02,fea02,fea031",
       " FROM vnl_file,fea_file ",
       " WHERE vnl02=fea01 AND vnl01 = '",g_vnk.vnk01,"' AND ",p_wc CLIPPED 
    PREPARE i330_prepare2 FROM g_sql      #預備一下
    DECLARE vnl_cs CURSOR FOR i330_prepare2
    CALL g_vnl.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH vnl_cs INTO g_vnl[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_vnl.deleteElement(g_cnt)   #取消 Array Element
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i330_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vnl TO s_vnl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #FUN-680048-----start
         IF g_flag1 = 'Y' THEN
            CALL fgl_set_arr_curr(l_ac)
            LET g_flag1 = 'N'
         END IF
         #FUN-680048-----end
 
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
         CALL i330_fetch('F')
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i330_fetch('P')
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i330_fetch('/')
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i330_fetch('N')
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last
         CALL i330_fetch('L')
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
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
         EXIT DISPLAY
 
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
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
            
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
     #TQC-9A0005--mark--str---
     ##No.FUN-7C0050 add
     #&include "qry_string.4gl"
     #TQC-9A0005--mark--end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#genero
#單頭
FUNCTION i330_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("vnk01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i330_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("vnk01",FALSE)
       END IF
   END IF
 
END FUNCTION
 
#單身
FUNCTION i330_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF NOT g_before_input_done THEN                      #MOD-4A0269
       CALL cl_set_comp_entry("vnl02",TRUE)
       CALL cl_set_comp_entry("fea02,fea031",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i330_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
    CALL cl_set_comp_entry("vnl02",TRUE)
    CALL cl_set_comp_entry("fea02,fea031",FALSE)
 
END FUNCTION
#FUN-B50004 
